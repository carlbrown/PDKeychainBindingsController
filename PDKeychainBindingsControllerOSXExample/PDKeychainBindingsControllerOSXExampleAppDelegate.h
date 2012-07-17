//
//  PDKeychainBindingsControllerOSXExampleAppDelegate.h
//  PDKeychainBindingsControllerOSXExample
//
//  Created by Carl Brown on 7/10/11.
//  Copyright 2011 PDAgent, LLC. Released under MIT License.
//

#import <Cocoa/Cocoa.h>

@interface PDKeychainBindingsControllerOSXExampleAppDelegate : NSObject <NSApplicationDelegate>

@property (strong) IBOutlet NSWindow *window;
@property (strong) IBOutlet NSTextField *RevealLabel;
@property (strong) IBOutlet NSSecureTextField *passwordField;
@property (strong) IBOutlet NSButton *RevealConcealButton;
- (IBAction)toggleRevealConceal:(id)sender;

@end
