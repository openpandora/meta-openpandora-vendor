#!/usr/bin/python

import os
import re
import sys
import gtk
import optparse

from ConfigModel import *

# ================================================================
# Todos and known bugs
# ================================================================
# Todo
# - compute PreviewPane constants PP_DX and PP_DY
# - test commandline interface

# ================================================================
# Constants
# ================================================================

# configuration files
GUI_DESCRIPTION = 'tvout.glade'
PROFILES = '/etc/pandora/conf/tvout-profiles.conf'

# Shell command to change settings:
SET_CONFIG_CMD = 'sudo /usr/pandora/scripts/op_tvout.sh %s'
CONFIG_PARAMS = '-t %(encoding)s -c %(connection)s -l %(layer)s -%(type)ss %(width)s,%(height)s -%(type)sp %(x)s,%(y)s'

# Maximum vertical resolutions
Y_RES_PAL = 574
Y_RES_NTSC = 482

# Profile header string, should be a single line only
# This does NOT conflict with profile names.
PROF_HEADER = 'Last written configuration:'

# Paths for reading different configuration options
SETTINGS = dict(
    size='/sys/devices/platform/omapdss/overlay2/output_size',
    position='/sys/devices/platform/omapdss/overlay2/position',
    enabled='/sys/devices/platform/omapdss/display1/enabled',
    connection='/sys/devices/platform/omapdss/display1/venc_type', # if it exists
    fb0='/sys/class/graphics/fb0/overlays',
    fb1='/sys/class/graphics/fb1/overlays',
)

# format for saving/loading
FILE_ORDER = (
    "enabled", "encoding", "connection", "layer", "x", "y", "width", "height")

# Default configurations
DC_DISABLED = "Disabled"
DC_DISABLED_DICT = dict(
    enabled="False", encoding="pal", connection="composite", 
    layer="0", width="658", height="520", x="35", y="35")
DC_DEFAULTS = {
    DC_DISABLED: DC_DISABLED_DICT,
    }

# Widget names
W_RADIO_BUTTONS = ('pal', 'ntsc', 'composite', 'svideo', 'layer0', 'layer1')
W_ADJUSTMENTS = ('x', 'y', 'width', 'height')
W_WIDGETS = ('enabled', 'pal', 'ntsc', 'composite', 'svideo', 
             'layer0', 'layer1', 'width', 'height', 'x', 'y')

# Preview pane
PP_WIDGET = 'previewAlignment'
PP_HANDLES = ('xPaned', 'yPaned', 'widthPaned', 'heightPaned')
PP_DX = 26.0 # Todo: compute these
PP_DY = 14.0 # (they might be theme dependent)

ENABLED_USERDATA = 'enabled'
RADIO_USERDATA = dict(
    pal='encoding', ntsc='encoding',
    composite='connection', svideo='connection',
    layer0='layer', layer1='layer')
ADJUSTMENT_USERDATA = ('width', 'height', 'x', 'y')

# Documentation for commandline options
HELP_ENABLED = "Enable TV-out. Valid values: True, False"
HELP_ENCODING = "Set encoding type (pal or ntsc)."
HELP_CONNECTION = "Set connection type (composite or svideo)"
HELP_LAYER = "Sets video layer to either main (0) or HW scaler / overlay (1)"
HELP_WIDTH = "Screen width (max 720)"
HELP_HEIGHT = "Screen height (max %s for pal and %s for ntsc)" % (Y_RES_PAL, Y_RES_NTSC)
HELP_X = "X coordinate of top left corner of the display area. Max 720 - width."
HELP_Y = "Y coordinate of top left corner of the display area. Y + HEIGHT may not exceed the max values specified in the height option."
HELP_SAVE = "Store current configuration as specified profile."
HELP_APPLY = "Activate the currently specified configuration."
HELP_LOAD = "Load and apply the specified configuration profile."
HELP_DEL = "Delete specified configuration profile."

# Commandline input type checking
TYPECHECK = dict(
    enabled='(True|False)', layer='(0|1)',
    encoding='(pal|ntsc)', connection='(composite|svideo)',
    width='(\d+)', height='(\d+)', x='(\d+)', y='(\d+)',
)
RE_FORMAT = ' '.join(TYPECHECK[k] for k in FILE_ORDER)
BOUNDS = dict(width=(0,720), height=(0, Y_RES_PAL),
              x=(0,720), y=(0,Y_RES_PAL))

# ================================================================
# Misc. auxiliary functions
# ================================================================

def Validate(value):
    """Verifies all values in a profile string (see TVoutModel).

    This is used to validate inputs passed through the commandline interface.

    @value: a profile string.
    """
    mo = re.match(RE_FORMAT, value)
    if mo is None:
        return {}
    else: # verify bounds
        values = dict(zip(FILE_ORDER, mo.groups()))
    
        x = int(values['x'])
        y = int(values['y'])
        w = int(values['width'])
        h = int(values['height'])
        Y = Y_RES_PAL if values['encoding'] == 'pal' else Y_RES_NTSC
        
        if 720 < x + w:
            print "Invalid position and/or size specified, x (%s) + width (%s) may not exceed 720." % (x, w)
            sys.exit(1)
        if Y < y + h:
            print "Invalid position and/or size specified, y (%s) + height (%s) may not exceed %s." % (y, h, Y)
            sys.exit(1)

        if not all(BOUNDS[k][0] <= int(values[k]) <= BOUNDS[k][1] for k in BOUNDS):
            print "Invalid position and/or size bounds specified"
            sys.exit(1)
        else:
            return values

# ================================================================
# Main model & gui classes
# ================================================================

class TVoutModel(ConfigModel):
    """Model for TV-out configuration.

    Since not all TV-out settings can be easily read back from the system,
    the last-saved profile is stored to fill in the gaps (mainly encoding).

    This currently stores the following key/value pairs (all strings):
    - "enabled": "True" | "False" # TV-out turned on/off
    - "encoding": "pal" | "ntsc"  # which colour encoding is utilized
    - "connection": "composite" | "svideo"
    - "layer": "0" | "1"          # main video layer or hw scaler/overlay
    - "x": "\d+"                  # left side of area displayed area
    - "y": "\d+"                  # top side of the displayed area
    - "width": "\d+"              # right side of the displayed area, 
                                  # relative to "x"
    - "height": "\d+"             # bottom side of the displayed area,
                                  # relative to "y"
    """
    def __init__(self, *views):
        self.last_written = None
        ConfigModel.__init__(self, PROFILES, *views, **DC_DEFAULTS)

    def fetch_profiles(self):
        """Loads the profiles.

        The header line is ignored and is included for user documentation only.
        The second line is the last written profile.
        The remainder of the file consists of a series of lines which 
        alternating contain the profile name and a profile.

        Profiles are stored as space separated values, in the following order:
        <enabled> <encoding> <connection> <layer> <x> <y> <width> <height>
        """
        with open(self.profiles_file, 'r') as f:
            f.readline() # header
            self.last_written = self.string_to_profile(f.readline().strip()) # last_saved profile

            name = None
            for line in f:
                if name is None:
                    name = line.rstrip()
                else:
                    self.profiles[name] = self.string_to_profile(line.rstrip())
                    name = None

    def store_profiles(self):
        """Write profiles to file.

        Refer to the doc-string of fetch_profiles for the file format.
        """
        with open(self.profiles_file, 'w') as f:
            f.write('%s\n%s\n' % (PROF_HEADER, self.profile_to_string(self.last_written)))
            for name in sorted(self.profiles.keys()):
                f.write('%s\n%s\n' % (name, self.profile_to_string(self.profiles[name])))

    def read_settings(self):
        """Reads current TV-out configuration from the system.

        The way the encoding is stored is tricky to convert back to pal/ntsc 
        and might change in later hotfixes / firmware releases. Therefore this
        value is read from the last written profile instead.

        Layer is determined by interpreting the framebuffer values. 
        If an unknown configuration is encountered, which is quite possible, 
        then the last written configuration is read instead.
        """
        # Uncomment to test on desktop linux:
        # self.load_profile(self.last_written)
        # return

        settings = {}
        for key, path in SETTINGS.iteritems():
            try:
                with open(path, 'r') as f:
                    settings[key] = f.readline().strip()
            except:
                settings[key] = self.last_written[key] if key in self.last_written else None

        # This one is quite tricky to read directly from the system, yet unlikely to change often.
        settings['encoding'] = self.last_written['encoding']

        # These ones are stored as a single value
        settings['width'], settings['height'] = settings.pop('size').split(',')
        settings['x'], settings['y'] = settings.pop('position').split(',')

        # To determine the layer we interpret the framebuffer values
        fb0 = settings.pop('fb0')
        fb1 = settings.pop('fb1')
        settings['layer'] = ('1' if fb0 == '0' and fb1 == '1,2' else 
                             ('0' if fb0 == '0,2' and fb1 == '1' else 
                              self.last_written['layer']))

        self.load_profile(settings)

    def write_settings(self):
        """Write configuration to the system.

        This relies on op_tvout.sh to write the configuration, such that
        the details can be easily changed in later firmware versions.

        Documentation for op_tvout.sh:
        op_tvout.sh [-d] [-t pal|ntsc] [-c composite|svideo] [-l 0|1] 
                    [-{p|n}s w,h] [-{p|n}p x,y]

        - op_tvout.sh -d      # just disables tv-out
        - t ntsc -c composite # enable NTSC/composite mode
        - l 1      
          layer, 0 is the main layer and 1 is hardware scaler/overlay
          (video layer, used by some emus too), only one can be used at a time)
        - pp 0,0 -ps 640 480 
          display position and size in 720xSomething space, 
          this has to be tuned for every TV by user for best results, 
          can't go out of range of 720xSomething (I think).
        - np 0,0 -ns 640 480 # same for NTSC

        The script expects you to supply everything at once.
        """
        self.last_written.update(self.settings)
        if self.settings['enabled'] == 'False':
            #print SET_CONFIG_CMD % '-d'
            os.system(SET_CONFIG_CMD % '-d')
        else:
            pp = self.settings.copy()
            pp['type'] = self.settings['encoding'][0]
            #print SET_CONFIG_CMD % (CONFIG_PARAMS % pp)
            os.system(SET_CONFIG_CMD % (CONFIG_PARAMS % pp))

    def profile_to_string(self, dct):
        """Converts settings dictionary to a string.

        Profiles are stored as space separated values, in the following order:
        <enabled> <encoding> <connection> <layer> <x> <y> <width> <height>
        """
        return ' '.join(dct[k] for k in FILE_ORDER)
    
    def string_to_profile(self, s):
        """Converts a profile string back to a settings dictionary.

        Profiles are stored as space separated values, in the following order:
        <enabled> <encoding> <connection> <layer> <x> <y> <width> <height>
        """
        return dict(zip(FILE_ORDER, s.split(' ')))

class TVoutConfig(object):
    """GUI application for modifying the pandora TV-out configuration

    Design (tvout.glade):
    +------------+---------------+--------------------+
    |            | Position----- | Size-------------- |
    |  Logo      | X: <spin btn> | Width: <spin btn>  |
    |            | Y: <spin btn> | Height: <spin btn> |
    +------------+---------------+--------------------+
    |Encoding    | Overscan                           |
    |. pal       | +--------------------------------+ |
    |. ntsc      | |      <undisplayed area>        | |
    +------------+ |   +-----------------------+    | |
    |Connection  | |   |                       |    | |
    |. composite | |   |   <displayed area>    |    | |
    |. S-video   | |   |                       |    | |
    +------------+ |   |                       |    | |
    |Layer       | |   +-----------------------+    | |
    |. Main      | |                                | |
    |. overlay   | +--------------------------------+ |
    +------------+------------------------------------+
    |[v] enabled | [ Read settings ] [Write settings] |
    |[delete p.] | {.............|v} [ Save profile ] |  
    +------------+------------------------------------+

    Important widget names:
    - X,Y,Width and Height spinbuttons: x,y,width and height
    - Radio buttons (for Encoding, Connection, Layer):
      pal, ntsc, composite, svideo, layer0, layer1

      These names correspond to their values as they are written,
      except for layer0 and layer1 which are stored as strings(!) 0 and 1.
    - The checkbox is called: enabled
    - The buttons are called: 
      readSettings, writeSettings, deleteProfile, saveProfile
    - The combobox is called: ProfileComboEntry
    - The displayed area is created by a set of GtkHPaned and GtkVPaned 
      widgets called: xPaned, yPaned, widthPaned, heightPaned
      They are contained in a frame called previewAlignment which can be
      used to determine the total allocated size.
    """

    def __init__(self):
        """Initialize the GUI application.
        
        Loads glade file, creates widget references, connects unbound handlers
        (mainly those handlers which require userdata) and finally initializes
        the model.
        """
        builder = gtk.Builder()
        builder.add_from_file(
            os.path.join(os.path.dirname(__file__), GUI_DESCRIPTION))
        builder.connect_signals(self)

        self.widgets = {}
        for widgetname in W_WIDGETS:
            self.widgets[widgetname] = builder.get_object(widgetname)

        # Bind radiobutton signals
        for widget, setting in RADIO_USERDATA.iteritems():
            self.widgets[widget].connect('clicked', self.on_clicked, 
                                      setting, widget.lstrip('layer'))

        # Bind adjustment signals
        for widget in ADJUSTMENT_USERDATA:
            self.widgets[widget].get_adjustment().connect(
                'value_changed', self.on_value_changed, widget)
        

        # The allocated size of this widget is utilized to convert the 
        # slider positions to absolute x,y,width and height values.
        self.previewPane = builder.get_object(PP_WIDGET)

        self.panedwidgets = {}
        # Bind previewpane handle signals
        for key in PP_HANDLES:
            w = builder.get_object(key)
            self.panedwidgets[key] = w
            w.connect("notify::position", self.on_paned_position_change, key)

        self.model = TVoutModel(self)

        # We have two sets of widgets manipulating position and size
        # (spinbuttons and the handles in the previewpane).
        # To prevent an update race between these sets, the following flags 
        # are set to block the handlers of the widgets which we are NOT 
        # manipulating. The spinbuttons are more precise and therefore leading.
        self.suppress_handles = False
        self.suppress_spinbuttons = False

        self.statusbar = builder.get_object('statusbar')
        self.contextid = self.statusbar.get_context_id('')

        self.profiles = gtk.ListStore(str)
        for profile in DC_DEFAULTS:
            self.profiles.append([profile])
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
        self.delete = builder.get_object('deleteProfile')
        self.save = builder.get_object('saveProfile')

        # this also changes sensitive of self.save & self.load
        self.comboentry.set_active(0)

        self.window = builder.get_object("window")
        self.window.show_all()

        accelgrp = gtk.AccelGroup()
        key, mod = gtk.accelerator_parse('<Control>Q')
        accelgrp.connect_group(key, mod, 0, self.on_window_destroy)
        self.window.add_accel_group(accelgrp)

        # read current config
        self.model.read_settings()

    def Notify(self, message):
        """Displays a message on the statusbar"""
        self.statusbar.pop(self.contextid)
        self.statusbar.push(self.contextid, message)

    def get_y_resolution(self):
        """Returns the (mode-dependent) maximum Y resolution"""
        return Y_RES_PAL if self.widgets['pal'].get_active() else Y_RES_NTSC

    # --------------------------------
    # View updates when model changes
    # --------------------------------

    def _update_profile_list(self, new, profiles):
        """Show all default profiles and then the custom profiles.
        
        @new: name of newly selected profile
        @profiles: dictionary of all profiles.
        """
        self.profiles.clear()
        activate = 0
        for i, key in enumerate(DC_DEFAULTS):
            self.profiles.append([key])
            if key == new:
                activate = i
        offset = len(DC_DEFAULTS)
        for i, key in enumerate(sorted(profiles.keys())):
            self.profiles.append([key])
            if key == new:
                activate = i + offset
        self.comboentry.set_active(activate)
            
    def _update_widgets(self, settings):
        """Update all widgets to reflect the configuration in settings"""
        enabled = eval(settings['enabled'])
        self.widgets['enabled'].set_active(enabled)

        self.widgets[settings['encoding']].set_active(True)
        self.widgets[settings['connection']].set_active(True)
        self.widgets['layer'+settings['layer']].set_active(True)

        for key in W_ADJUSTMENTS:
            w = self.widgets[key]
            w.get_adjustment().set_value(eval(settings[key]))
            w.set_sensitive(enabled)
        
        for key in W_RADIO_BUTTONS:
            self.widgets[key].set_sensitive(enabled)

    def update_view(self, reason, *data):
        """Dispatcher for events generated by the model."""
        if reason == MODEL_PROFILE_CHANGE:
            self._update_profile_list(*data)
        elif reason == MODEL_VALUE_CHANGE:
            self._update_widgets(*data)

    def update_adjustments(self):
        """Update all Gtk adjustments to recompute their maximum.

        The value of x+width should not exceed 720.
        The value of y+height should not exceed the maximum Y resolution.
        """
        x = self.widgets['x'].get_adjustment()
        y = self.widgets['y'].get_adjustment()

        xval = int(self.model.settings['x'])
        yval = int(self.model.settings['y'])
        wval = int(self.model.settings['width'])
        hval = int(self.model.settings['height'])

        # update vertical resolution thresholds
        y.set_upper(self.get_y_resolution())
        y.set_value(min(yval, y.get_upper()))

        # update width thresholds
        width = self.widgets['width'].get_adjustment()
        width.set_upper(x.get_upper()-xval)
        width.set_value(min(wval, width.get_upper()))

        # update height thresholds
        height = self.widgets['height'].get_adjustment()
        height.set_upper(y.get_upper()-yval)
        height.set_value(min(hval, height.get_upper()))

    # --------------------------------
    # Handling of widget changes
    # --------------------------------

    def on_toggled(self, widget, *data):
        """Handles changes of the enabled radio button."""
        enabled = widget.get_active()
        self.model.settings[ENABLED_USERDATA] = str(enabled)
        for name, widget in self.widgets.iteritems():
            if name != 'enabled':
                widget.set_sensitive(enabled)

    def on_clicked(self, widget, key=None, value=None):
        """Handles changes of the radio buttons.
        
        @key: the setting being changed, i.e.
              - "encoding" for pal/ntsc, 
              - "connection" for composite/svideo
              - "layer" for layer0/layer1. 
        These correspond to the keys in the profile settings dictionaries.
        @value: the value to be written to the dictionary.

        When the encoding changes, so does the maximum Y resolution.
        Hence it requires the adjustments to be updated.
        """
        if key:
            self.model.settings[key] = value
        if key == 'encoding':
            self.update_adjustments()

    def on_value_changed(self, widget, data):
        """Handles spinbutton events.

        If the user manipulates the spinbutton, the model is updated.
        Note that suppress_handles is set to prevent the GtkPaned widgets
        from retriggering an update. The precision of the Paned widgets
        depends on screen resolution and tends to be less precise than
        that of the spinbuttons causing an update-race.
        """
        if self.suppress_spinbuttons:
            return

        self.model.settings[data] = str(int(widget.get_value()))
        self.update_adjustments()
        yresolution = self.get_y_resolution()

        # update the handle displays, but don't generate a new signal.
        self.suppress_handles = True
        self.set_pane_position(data + 'Paned', yresolution)
        self.suppress_handles = False

    # --------------------------------
    # Button clicks
    # --------------------------------

    def on_readSettings_clicked(self, widget, *data):
        """Handles a click on the readSettings button.
        
        Since it doesn't require userdata, this is connected through glade.
        """
        self.model.read_settings()
        self.Notify("Active TV-out configuration loaded.")

    def on_writeSettings_clicked(self, widget, *data):
        """Handles a click on the writeSettings button.

        Since it doesn't require userdata, this is connected through glade.
        """
        self.model.write_settings()
        self.Notify("TV-out configuration updated.")

    def on_deleteProfile_clicked(self, widget, *data):
        """Handles a click on the deleteProfile button.

        Since it doesn't require userdata, this is connected through glade.
        The touch-screen is not the highest precision input and has no 
        visual feedback before a click. Therefore we better prompt for
        confirmation. Having an undo instead would probably be better.
        """
        name = self.entry.get_text()
        if name not in self.model.profiles or name in DC_DEFAULTS:
            self.Notify("Cannot remove profile, please select an existing non-default profile.")
        else:
            dialog = gtk.MessageDialog(flags=gtk.DIALOG_MODAL, type=gtk.MESSAGE_WARNING,
                 buttons=gtk.BUTTONS_YES_NO,
                 message_format="Are you sure you want to delete profile %s?" % name)
            if dialog.run() == gtk.RESPONSE_YES:
                self.model.delete_profile(name)
            dialog.destroy()

    def on_saveProfile_clicked(self, widget, *data):
        """Handles a click on the saveProfile button.

        Since it doesn't require userdata, this is connected through glade.
        Default profiles cannot be overwritten.
        """
        name = self.entry.get_text()
        if name == '' or name in DC_DEFAULTS:
            self.Notify("Invalid profile name")
        else:
            self.model.set_profile(name, self.model.settings)
            self.Notify("Profile saved as: %s" % name)

    # --------------------------------
    # ComboBox
    # --------------------------------

    def _lose_active(self):
        """Forces the comboboxentry to lose its active selection.
        
        This ensures that it also generates a changed signal when we
        select the same value twice in a row such that a user can undo
        any changes made to a loaded profile by loading the profile again.
        """
        temp = self.entry.get_text()
        self.entry.set_text('')
        self.entry.set_text(temp)

    def on_combo_changed(self, widget, *data):
        """Handles selection in the profile combo box."""
        name = self.entry.get_text()
        self.delete.set_sensitive(name in self.model.profiles)
        self.save.set_sensitive(name != '' and name not in DC_DEFAULTS)
        if self.comboentry.get_active() != -1:
            self.on_LoadProfile_clicked(None)

    def on_LoadProfile_clicked(self, widget, *data):
        """Loads profile in the entry widget (by name).

        It is directly activated by the activation event of the combobox entry
        (i.e. when the user presses enter) and indirectly called by 
        on_combo_changed (when the user performs a mouse selection).
        """
        self._lose_active()          # force widget to always emit changed signals,
        name = self.entry.get_text() # ok since we always lookup by text value anyway
        if not name:
            return
        elif name not in self.model.profiles and name not in DC_DEFAULTS:
            self.Notify("Cannot load profile, please select an existing profile.")
        else:
            self.model.load_named_profile(name)
            self.Notify("Profile loaded, hit 'Write settings' to make it active")

    # --------------------------------

    def set_pane_position(self, key, yresolution):
        """Sync the GtkPaned widgets with the spinbuttons.

        The Paned handles need their position specified in pixels.
        This converts an absolute value to a relative position as the pane is 
        not actually 720 pixels wide (nor high). 

        PP_DX and PP_DY are corrections for the border around the client area.
        They are measured for a specific theme, I'm not sure if changing theme
        can invalidate this value but I guess it can.
        """
        value = int(self.model.settings[key.rstrip('Paned')])
        widget = self.panedwidgets[key]
        if key == 'widthPaned' or key == 'xPaned':
            maxval = self.previewPane.allocation.width - PP_DX
            newpos = (value / 720.) * maxval
        else:
            maxval = self.previewPane.allocation.height - PP_DY
            newpos = (value / float(yresolution)) * maxval
        widget.set_position(int(newpos))

    def on_paned_position_change(self, widget, param, key):
        """Handle dragging of the GtkPaned widgets.

        This turns of handling of the spinbuttons as otherwise the spinbutton
        update would re-trigger this event handler causing an update race due
        to differences in precision.
        """
        if self.suppress_handles:
            return

        yresolution = self.get_y_resolution()
        self.suppress_spinbuttons = True

        maxval = self.previewPane.allocation.width - PP_DX        
        for key in ('xPaned', 'widthPaned'):
            pos = int((self.panedwidgets[key].get_position()/maxval)*720)
            adj = self.widgets[key.rstrip('Paned')].get_adjustment()
            adj.set_value(pos)
            self.model.settings[key.rstrip('Paned')] = str(int(pos))

        maxval = self.previewPane.allocation.height - PP_DY
        for key in ('yPaned', 'heightPaned'):
            pos = (self.panedwidgets[key].get_position()/maxval) * yresolution
            adj = self.widgets[key.rstrip('Paned')].get_adjustment()
            adj.set_value(int(pos))
            self.model.settings[key.rstrip('Paned')] = str(int(pos))

        self.update_adjustments()
        self.suppress_spinbuttons = False
        
    def on_window_destroy(self, widget, *data):
        """Handle application shutdown."""
        self.Notify("Storing profiles...")
        self.model.store_profiles()
        gtk.main_quit()

# ================================================================

def main(args):
    """Runs the application.

    @args: command-line arguments (typically sys.argv).
    """
    if len(args) == 1: # no params: run gui app
        app = TVoutConfig()
        gtk.main()
    else: # run command line app
        parser = optparse.OptionParser()

        parser.add_option('-e', '--enabled', default='', help=HELP_ENABLED)
        parser.add_option('-t', '--encoding_type', default='', help=HELP_ENCODING)
        parser.add_option('-c', '--connection_type', default='', help=HELP_CONNECTION)
        parser.add_option('-l', '--layer', default='', help=HELP_LAYER)
        parser.add_option('-w', '--width', default='', help=HELP_WIDTH)
        parser.add_option('-g', '--height', default='', help=HELP_HEIGHT)
        parser.add_option('-x', '--x_position', default='', help=HELP_X)
        parser.add_option('-y', '--y_position', default='', help=HELP_Y)

        parser.add_option('-s', '--save_profile', default='', help=HELP_SAVE)
        parser.add_option('-a', '--apply', default=False, action='store_true', help=HELP_APPLY)
        parser.add_option('-p', '--load_profile', default='', help=HELP_LOAD)
        parser.add_option('-d', '--remove_profile', default='', help=HELP_DEL)

        options, args = parser.parse_args()
                          
        model = TVoutModel()
        model.read_settings()
        if options.enabled:
            model.settings['enabled'] = options.enabled
        if options.encoding_type:
            model.settings['encoding'] = options.encoding_type
        if options.connection_type:
            model.settings['connection'] = options.connection_type
        if options.layer:
            model.settings['layer'] = options.layer
        if options.width:
            model.settings['width'] = options.width
        if options.height:
            model.settings['height'] = options.height
        if options.x_position:
            model.settings['x'] = options.x_position
        if options.y_position:
            model.settings['y'] = options.y_position

        profile_string = model.profile_to_string(model.settings)
        config = Validate(profile_string)

        if not config:
            print "Invalid values encountered in profile (%s), terminating." % profile_string
            sys.exit(1)

        if options.save_profile and options.save_profile not in DC_DEFAULTS:
            model.set_profile(options.save_profile, self.model.settings)
        if options.apply:
            model.write_settings()
        if options.load_profile:
            model.load_named_profile(options.load_profile)
            model.write_settings()
        if options.remove_profile:
            model.delete_profile(options.remove_profile)

        if options.save_profile or options.remove_profile:
            model.store_profiles()

if __name__ == '__main__':
    try:
        main(sys.argv)
    except Exception, e:
        print e
        sys.exit(1)
    else:
        sys.exit(0)
