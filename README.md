[![No Maintenance Intended](http://unmaintained.tech/badge.svg)](http://unmaintained.tech/)

The world has moved onto [Swift](https://github.com/apple/swift), and this project didn't turn out to have been built in a Swift-friendly way. You should use something like [this](https://github.com/jrendel/SwiftKeychainWrapper) or [this](https://github.com/kishikawakatsumi/KeychainAccess)

-----------------------------DEPRECATED OLD README FOR POSTERITY---------------------------------

This project is intended to make using the Mac OSX and iOS Keychains as easy as NSUserDefaults.

It is a KVO-compliant Cocoa wrapper around the  Mac OSX and iOS Keychains, and the model for this wrapper is NSUserDefaults, so the intent is that for the common cases you would normally want to call:

> [NSUserDefaultsController sharedUserDefaultsController]

You should be able to call

> [PDKeychainBindingsController sharedKeychainBindingsController]

And for the common cases you normally would have called:

> [NSUserDefaults standardUserDefaults]

You should be able to call

> [PDKeychainBindings sharedKeychainBindings]

There are a couple of differences between the implementations.  First, this class is only valid for strings, because that's what the Keychain accepts, so the methods that take non-string objects (like arrays and dictionaries and the like) have been omitted from the class.  Secondly, right now, only "immediate mode" is implemented, so you can't set a bunch of values and then call "save" to do only one write, and there's no "revert to saved values" functionality (this wouldn't be hard to implement, although I don't have a need for it right now, so if you want it, ping me and I'll put it in).

As background, I'm writing a Mac App that has a NSSecureTextField in its Preferences window.  I want the value that the user enters there to be stored in the Keychain, but to simplify the code, I want to be able to bind it the same way I'm binding all the non-secure preferences to NSUserDefaultsController.

I thought this class would potentially be useful to other people, so I'm making it its own module for release under an MIT license.

NOTE: The master branch has been updated to use ARC by [Vincent Tourraine](https://github.com/vtourraine) (Thanks, Vincent).  I'll be maintaining a non ARC branch called [non_ARC](https://github.com/carlbrown/PDKeychainBindingsController/tree/non_ARC) so it can still be used in projects that haven't been converted to ARC, yet.

Note that there's an issue with the unit tests running on the device failing due to a change in code signing entitlements.  See [this stack overflow answer](http://stackoverflow.com/a/22305193/159356) for more information if you're trying to run the unit tests on the device.
