# Types of model changes for view updates 
(MODEL_PROFILE_CHANGE, MODEL_VALUE_CHANGE) = range(2)

class ConfigModel(object):
    """A simple settings dictionary with support for saving and loading profiles.

    The following four methods need to be implemented by sub-classes:
    - read_settings: read current system configuration
    - write_settings: write self.settings to system
    - profile_to_string: convert a dictionary into a single-line string for storage.
    - string_to_profile: the inverse of the above.

    The class implements a basic model-view pattern. The user-interface can attach
    to this to receive updates whenever the values are modified.

    Events: 
    - MODEL_PROFILE_CHANGE: 
      Issued when the sets of defined profiles has been modified. 
      This is relevant for widgets which handle profile creation/deletion.
    - MODEL_VALUE_CHANGE:
      Issued whenever a new profile is loaded. This is useful for all widgets
      which actually display and edit a configuration.
    """
    def __init__(self, profiles_file, *views, **kwargs):
        """Creates a new configuration settings model.

        This currently provides support for a model/view pattern and 
        unmodifiable default profiles.
        
        @profiles_file: name of the file to which to save/store all profiles.
        @views: all positional arguments are views.
        @kwargs: all keyword arguments should be default profiles.
        """
        self.views = list(views)
        self.settings = {}

        # these cannot be edited
        self.default_profiles = kwargs

        self.profiles_file = profiles_file
        self.profiles = {}

        self.fetch_profiles()

    def notify(self, reason, *args):
        """Dispatches all views."""
        for v in self.views:
            v.update_view(reason, *args)

    def set_profile(self, name, dictionary):
        """Inserts a new profile into the profile dictionary.

        Issues a MODEL_PROFILE_CHANGE event and passes the name of
        the profile to the views along with all new profiles.
        """
        notify = name not in self.profiles
        self.profiles.setdefault(name, {}).update(dictionary)
        if notify:
            self.notify(MODEL_PROFILE_CHANGE, name, self.profiles)

    def delete_profile(self, name):
        """Removes profile <name>, if it exists.

        If, and only if, the profile name existed a MODEL_PROFILE_CHANGE
        event is issued to all views. No new selected profile will be passed.
        If name was the active profile, then the views can select a new one.
        """
        notify = name in self.profiles
        del self.profiles[name]
        if notify:
            self.notify(MODEL_PROFILE_CHANGE, '', self.profiles)

    def load_profile(self, settings):
        """Directly loads the profile specified by settings.

        Dispatches the views with a MODEL_VALUE_CHANGE event.
        """
        self.settings.update(settings)
        self.notify(MODEL_VALUE_CHANGE, self.settings)

    def load_named_profile(self, name):
        """If <name> is a valid profile, make it active.

        Inspects the default profiles before the custom profiles and dispatches
        the views with a MODEL_VALUE_CHANGE event.
        """
        notify = True
        if name in self.default_profiles:
            self.settings.update(self.default_profiles[name])
        elif name in self.profiles:
            self.settings.update(self.profiles[name])
        else:
            notify = False
        if notify:
            self.notify(MODEL_VALUE_CHANGE, self.settings)

    def fetch_profiles(self):
        """Load non-default profiles from disk."""
        with open(self.profiles_file, 'r') as f:
            name = None
            for line in f:
                if name is None:
                    name = line.rstrip()
                else:
                    self.profiles[name] = self.string_to_profile(line.rstrip())
                    name = None

    def store_profiles(self):
        """Write all non-default profiles to disk."""
        with open(self.profiles_file, 'w') as f:
            for name in sorted(self.profiles.keys()):
                f.write('%s\n%s\n' % (name, self.profile_to_string(self.profiles[name])))

    def read_settings(self):
        """Read current configuration from the system.

        Needs to be implemented by sub-classes.
        """
        pass

    def write_settings(self):
        """Write current configuration to system.

        Needs to be implemented by sub-classes.
        """
        pass

    def profile_to_string(self, dct):
        """Convert a configuration profile to a single-line string.
        
        Sub-classes should override this with a more optimal implementation.
        """
        return str(dct)
    
    def string_to_profile(self, s):
        """Convert a profile string to a configuration profile.

        This is intended to be overridden by sub-classes.
        It should be the inverse operation of profile_to_string.
        """
        return eval(s)
