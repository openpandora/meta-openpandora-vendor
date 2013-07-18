#!/usr/bin/python

import os
import re
import sys
import gtk
import time
import optparse

# ================================================================

GUI_DESCRIPTION = 'nubmode.glade'
PROFILES = '/etc/pandora/conf/nub_profiles.conf'

# Shell command to reset nub: 3-0066 = left-nub, 3-0067 = right-nub
# apparently they are linked and resetting one resets both.
#RESET_CMD = 'echo %i > /sys/bus/i2c/drivers/vsense/3-00%i/reset'
RESET_CMD = "sudo /usr/pandora/scripts/reset_nubs.sh"

# Valid values for mode setting
MODES = ("mouse", "mbuttons", "scroll", "absolute")

# Paths for reading and writing different configuration options %i -> 0 | 1
SETTINGS = dict(
    mode='/proc/pandora/nub%s/mode',
    mouse='/proc/pandora/nub%s/mouse_sensitivity',
    button='/proc/pandora/nub%s/mbutton_threshold',
    rate='/proc/pandora/nub%s/scroll_rate',
    scrollx='/proc/pandora/nub%s/scrollx_sensitivity',
    scrolly='/proc/pandora/nub%s/scrolly_sensitivity',
)

# format for saving/loading
FILE_ORDER = ("mode", "mouse", "button", "rate", "scrollx", "scrolly")

# Default configuration
DEFAULT_PROFILENAME = "Default"
DEFAULT_DICT = dict(mode0='mouse', mode1='mbuttons', mouse0='150', mouse1='150',
                    button0='20', button1='20', rate0='20', rate1='20',
                    scrollx0='7', scrollx1='7', scrolly0='7', scrolly1='7')

# Types of model changes for view updates 
(MODEL_PROFILE_CHANGE, MODEL_VALUE_CHANGE) = range(2)

# Documentation for commandline options
HELP_RESET = "Reset specified nub(s). Format: left,right"
HELP_LEFT_NUB = ("Configure left nub. Include -a flag to activate. Format: %s. E.g. %s" %
                 (' '.join(FILE_ORDER),
                  ' '.join(DEFAULT_DICT[k+'0'] for k in FILE_ORDER)))
HELP_RIGHT_NUB = ("Configure right nub. Include -a flag to activate. Format: %s. E.g. %s" %
                  (' '.join(FILE_ORDER),
                   ' '.join(DEFAULT_DICT[k+'1'] for k in FILE_ORDER)))
HELP_SAVE = "Store current configuration as specified profile (no spaces allowed)"
HELP_APPLY = "Write currently loaded configuration to nubs."
HELP_LOAD = "Load and apply specified nub configuration profile"
HELP_DEL = "Delete specified nub configuration profile"

# Commandline input type checking
TYPECHECK = dict(mode='(%s)' % '|'.join(MODES), 
                 mouse='(\d+)', button='(\d+)',
                 rate='(\d+)', scrollx='(\d+)', scrolly='(\d+)')
RE_FORMAT = ','.join(TYPECHECK[k] for k in FILE_ORDER)
BOUNDS = dict(mouse=(50, 300), button=(1, 40), rate=(1, 40),
              scrollx=(-32,32), scrolly=(-32,32))

# ================================================================
# There is a bug in setting scrollx/scrolly sensitivity in the
# firmware (to be fixed in hotfix 6). 
# Detect and set FIX_SCROLLXY_BUG to use a workaround.

def ReadWriteTest(value=None):
    with open(SETTINGS['scrollx'] % 0, 'w' if value else 'r') as f:
        return f.write('%s\n' % value) if value else f.readline().rstrip()

tmp = int(ReadWriteTest())                       # backup original
ReadWriteTest(tmp + (-1 if tmp < 0 else 1))      # write corrected value
FIX_SCROLLXY_BUG = int(ReadWriteTest()) == tmp   # fix bug if equal to original
ReadWriteTest(tmp + ((-1 if tmp < 0 else 1) if FIX_SCROLLXY_BUG else 0)) # restore

# ================================================================

def ReadProc():
    config = {}
    for key, value in SETTINGS.iteritems():
        for c in '01':
            with open(value % c, 'r') as f:
                config[key+c] = f.readline().strip()
    return config

def StoreProc(dictionary):
    # fix for value decrement/increment after written
    if FIX_SCROLLXY_BUG:
        dictionary = dictionary.copy()
        for key in ('scrollx0', 'scrolly0', 'scrollx1', 'scrolly1'):
            value = int(dictionary[key])
            value += -1 if value < 0 else 1
            dictionary[key] = str(value)
    for key, value in SETTINGS.iteritems():
        for c in '01':
            with open(value % c, 'w') as f:
                f.write('%s\n' % dictionary[key+c])

def ProfileToString(dictionary):
    return ' '.join(dictionary[k+c] for c in '01' for k in FILE_ORDER)

def StringToProfile(line):
    return dict(zip((k+c for c in '01' for k in FILE_ORDER), line.split(' ')))

def Validate(value):
    mo = re.match(RE_FORMAT, value)
    if mo: # verify bounds
        values = dict(zip(FILE_ORDER, mo.groups()))
        if all(BOUNDS[k][0] <= int(values[k]) <= BOUNDS[k][1] for k in BOUNDS):
            return values
    return {}

# ================================================================

class NubModel(object):
    def __init__(self, view=None):
        self.views = [view] if view else []
        self.settings = ReadProc()
        self.profiles = {}
        with open(PROFILES) as f:
            name = None
            for line in f:
                if name is None:
                    name = line.rstrip()
                else:
                    self.profiles[name] = StringToProfile(line.rstrip())
                    name = None

    def notify(self, reason, *args):
        for v in self.views:
            v.update_view(reason, *args)

    def set_profile(self, name, dictionary):
        notify = name not in self.profiles
        self.profiles.setdefault(name, {}).update(dictionary)
        if notify:
            self.notify(MODEL_PROFILE_CHANGE, name, self.profiles)

    def delete_profile(self, name):
        notify = name in self.profiles
        del self.profiles[name]
        if notify:
            self.notify(MODEL_PROFILE_CHANGE, '', self.profiles)

    def load_profile(self, settings):
        self.settings.update(settings)
        self.notify(MODEL_VALUE_CHANGE, self.settings)

    def load_named_profile(self, name):
        notify = True
        if name == DEFAULT_PROFILENAME:
            self.settings.update(DEFAULT_DICT)
        elif name in self.profiles:
            self.settings.update(self.profiles[name])
        else:
            notify = False
        if notify:
            self.notify(MODEL_VALUE_CHANGE, self.settings)

    def store_profiles(self, filename):
        with open(filename, 'w') as f:
            for name in sorted(self.profiles.keys()):
                f.write('%s\n%s\n' % (name, ProfileToString(self.profiles[name])))


class NubConfig(object):
    """GUI application for modifying the pandora nub configuration"""
    def __init__(self):
        builder = gtk.Builder()
        builder.add_from_file(
            os.path.join(os.path.dirname(__file__), GUI_DESCRIPTION))
        builder.connect_signals(self)

        # slider widgets, more specifically: their Adjustment objects
        self.widgets = {}
        for s in DEFAULT_DICT:
            w = builder.get_object(s)
            if w is not None:
                w.connect('value-changed', self.on_slider_changed, s)
                self.widgets[s] = w

        # radio buttons
        for c in '01':
            group = []
            for m in MODES:
                w = builder.get_object('R%s%s' % (m,c))
                w.connect('clicked', self.on_radio_changed, 'mode'+c, m)
                group.append(w)
            self.widgets['mode'+c] = group

        self.statusbar = builder.get_object('statusbar')
        self.contextid = self.statusbar.get_context_id('')

        self.model = NubModel(self)

        self.profiles = gtk.ListStore(str)
        self.profiles.append([DEFAULT_PROFILENAME])
        for name in self.model.profiles:
            self.profiles.append([name])

        self.comboentry = builder.get_object('ProfileComboEntry')
        self.comboentry.set_model(self.profiles)
        self.comboentry.set_text_column(0)
        self.comboentry.connect('changed', self.on_combo_changed)

        self.entry = self.comboentry.get_child()
        self.entry.connect('activate', self.on_LoadProfile_clicked)

        # we need a reference to change their sensitive
        # setting according to the profile
        self.delete = builder.get_object('DeleteProfile')
        self.save = builder.get_object('SaveProfile')

        # this also changes sensitive of self.save & self.load
        self.comboentry.set_active(0)

        # read current config
        self.model.load_profile(ReadProc())

        self.window = builder.get_object("window")
        self.window.show_all()

        accelgrp = gtk.AccelGroup()
        key, mod = gtk.accelerator_parse('<Control>Q')
        accelgrp.connect_group(key, mod, 0, self.on_window_destroy)
        self.window.add_accel_group(accelgrp)

    def _update_profile_list(self, new, profiles):
        self.profiles.clear()
        self.profiles.append([DEFAULT_PROFILENAME])
        activate = 0
        for i, key in enumerate(sorted(profiles.keys())):
            self.profiles.append([key])
            if key == new:
                activate = i
        self.comboentry.set_active(activate)
            
    def _update_widgets(self, settings):
        for key, value in settings.iteritems():
            if 'mode' in key:
                for w, m in zip(self.widgets[key], MODES):
                    w.set_active(m == value)
            else:
                self.widgets[key].value = int(value)

    def update_view(self, reason, *data):
        if reason == MODEL_PROFILE_CHANGE:
            self._update_profile_list(*data)
        elif reason == MODEL_VALUE_CHANGE:
            self._update_widgets(*data)

    def _lose_active(self):
        # Forces the comboboxentry to lose its active selection
        # such that it also generates a changed signal when we
        # select the same value.
        temp = self.entry.get_text()
        self.entry.set_text('')
        self.entry.set_text(temp)

    def Notify(self, message):
        self.statusbar.pop(self.contextid)
        self.statusbar.push(self.contextid, message)

    def on_slider_changed(self, widget, key):
        self.model.settings[key] = str(int(widget.value))

    def on_radio_changed(self, widget, key, mode):
        self.model.settings[key] = mode

    def on_combo_changed(self, widget, *data):
        name = self.entry.get_text()
        self.delete.set_sensitive(name in self.model.profiles)
        self.save.set_sensitive(name != '' and name != DEFAULT_PROFILENAME)
        if self.comboentry.get_active() != -1:
            self.on_LoadProfile_clicked(None)

    def on_ResetNubs_clicked(self, widget, *data):
        self.Notify("Resetting the nubs...")
        os.system(RESET_CMD)
        self.Notify("Nubs reset.")

    def on_ReadNubConfig_clicked(self, widget, *data):
        self.model.load_profile(ReadProc())
        self.Notify("Active nub configuration loaded.")

    def on_WriteNubConfig_clicked(self, widget, *data):
        StoreProc(self.model.settings)
        self.Notify("Nub configuration updated.")

    def on_SaveProfile_clicked(self, widget, *data):
        name = self.entry.get_text()
        if name == '' or name == DEFAULT_PROFILENAME:
            self.Notify("Invalid profile name")
        else:
            self.model.set_profile(name, self.model.settings)
            self.Notify("Profile saved as: %s" % name)

    def on_LoadProfile_clicked(self, widget, *data):
        self._lose_active()          # force widget to always emit changed signals,
        name = self.entry.get_text() # ok since we always lookup by text value anyway
        if not name:
            return
        elif name not in self.model.profiles and name != DEFAULT_PROFILENAME:
            self.Notify("Cannot load profile, please select an existing profile.")
        else:
            self.model.load_named_profile(name)
            self.Notify("Profile loaded, hit 'Write nub settings' to make it active")

    def on_DeleteProfile_clicked(self, widget, *data):
        name = self.entry.get_text()
        if name not in self.model.profiles or name == DEFAULT_PROFILENAME:
            self.model("Cannot remove profile, please select an existing non-default profile.")
        else:
            dialog = gtk.MessageDialog(flags=gtk.DIALOG_MODAL, type=gtk.MESSAGE_WARNING,
                 buttons=gtk.BUTTONS_YES_NO,
                 message_format="Are you sure you want to delete profile %s?" % name)
            if dialog.run() == gtk.RESPONSE_YES:
                self.model.delete_profile(name)
            dialog.destroy()
        
    def on_window_destroy(self, widget, *data):
        self.Notify("Storing profiles...")
        self.model.store_profiles(PROFILES)
        gtk.main_quit()

# ================================================================

if __name__ == '__main__':
    parser = optparse.OptionParser()
    parser.add_option('--reset', default=False, action='store_true', help=HELP_RESET)
    parser.add_option('-l', '--left_nub', default='', help=HELP_LEFT_NUB)
    parser.add_option('-r', '--right_nub', default='', help=HELP_RIGHT_NUB)
    parser.add_option('-s', '--save_profile', default='', help=HELP_SAVE)
    parser.add_option('-a', '--apply', default=False, action='store_true', help=HELP_APPLY)
    parser.add_option('-p', '--load_profile', default='', help=HELP_LOAD)
    parser.add_option('-d', '--remove_profile', default='', help=HELP_DEL)
    options, args = parser.parse_args()

    if len(sys.argv) == 1: # no params: run gui app
        app = NubConfig()
        gtk.main()
    else: # run command line app
        model = NubModel()

        if options.reset:
            os.system(RESET_CMD)
        for key, value in Validate(options.left_nub).iteritems():
            model.settings[key+'0'] = value
        for key, value in Validate(options.right_nub).iteritems():
            model.settings[key+'1'] = value
        if options.save_profile and options.save_profile != DEFAULT_PROFILENAME:
            model.set_profile(options.save_profile, model.settings)
        if options.apply:
            StoreProc(model.settings)
        if options.load_profile:
            model.load_named_profile(options.load_profile)
            StoreProc(model.settings)
        if options.remove_profile:
            model.delete_profile(options.remove_profile)
        if options.save_profile or options.remove_profile:
            model.store_profiles(PROFILES)
