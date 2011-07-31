//
//  PDKeychainBindingsControllerOSXExampleAppDelegate.h
//  PDKeychainBindingsControllerOSXExample
//
//  Created by Carl Brown on 7/10/11.
//  Copyright 2011 PDAgent, LLC. Released under MIT License.
//

#import <Cocoa/Cocoa.h>

@interface PDKeychainBindingsControllerOSXExampleAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
    NSTextField *RevealLabel;
    NSSecureTextField *passwordField;
    NSButton *RevealConcealButton;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextField *RevealLabel;
@property (assign) IBOutlet NSSecureTextField *passwordField;
@property (assign) IBOutlet NSButton *RevealConcealButton;
- (IBAction)toggleRevealConceal:(id)sender;

@end
