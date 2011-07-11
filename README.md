
This project is intended to be a KVO-compliant Cocoa wrapper around the  Mac OSX and iOS Keychains.

The model for this wrapper is NSUserDefaults, so the intent is that for the common cases you would normally want to call:

> [NSUserDefaultsController sharedUserDefaultsController]

You should be able to call

> [PDKeychainBindingsController sharedKeychainBindingsController]

And for the common cases you normally would have called:

> [NSUserDefaults standardUserDefaults]

You should be able to call

> [PDKeychainBindings sharedKeychainBindings]

I'm not sure how exhaustive I'm going to make the implementation, although we'll see.

As background, I'm writing a Mac App that has a NSSecureTextField in its Preferences window.  I want the value that the user enters there to be stored in the Keychain, but to simplify the code, I want to be able to bind it the same way I'm binding all the non-secure preferences to NSUserDefaultsController.

I thought this class would potentially be useful to other people, so I'm making it its own module for release under an MIT license.

