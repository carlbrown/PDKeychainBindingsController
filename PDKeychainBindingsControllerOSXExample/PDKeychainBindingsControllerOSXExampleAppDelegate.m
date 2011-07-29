//
//  PDKeychainBindingsControllerOSXExampleAppDelegate.m
//  PDKeychainBindingsControllerOSXExample
//
//  Created by Carl Brown on 7/10/11.
//  Copyright 2011 PDAgent, LLC. All rights reserved.
//

#import "PDKeychainBindingsControllerOSXExampleAppDelegate.h"
#import "PDKeychainBindings.h"
#import "PDKeychainBindingsController.h"

@implementation PDKeychainBindingsControllerOSXExampleAppDelegate

@synthesize window;
@synthesize RevealLabel;
@synthesize passwordField;
@synthesize RevealConcealButton;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [passwordField bind:@"value"
               toObject:[PDKeychainBindingsController sharedKeychainBindingsController]
            withKeyPath:[NSString stringWithFormat:@"values.%@",@"passwordString"]
                options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
                                                    forKey:@"NSContinuouslyUpdatesValue"]];
}

- (IBAction)toggleRevealConceal:(id)sender {
    PDKeychainBindings *bindings=[PDKeychainBindings sharedKeychainBindings];
    if ([[RevealConcealButton title] isEqualToString:@"Reveal"]) {
        [RevealLabel setStringValue:
         [bindings stringForKey:@"passwordString"]
         ];
        [RevealConcealButton setTitle:@"Conceal"];
    } else {
        //Conceal
        [RevealLabel setStringValue:@""];
        [RevealConcealButton setTitle:@"Reveal"];
    }
}
@end
