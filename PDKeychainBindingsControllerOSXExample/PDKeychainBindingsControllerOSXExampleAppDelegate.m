//
//  PDKeychainBindingsControllerOSXExampleAppDelegate.m
//  PDKeychainBindingsControllerOSXExample
//
//  Created by Carl Brown on 7/10/11.
//  Copyright 2011 PDAgent, LLC. Released under MIT License.
//

#import "PDKeychainBindingsControllerOSXExampleAppDelegate.h"
#import "PDKeychainBindings.h"
#import "PDKeychainBindingsController.h"

@implementation PDKeychainBindingsControllerOSXExampleAppDelegate

@synthesize window, RevealLabel, passwordField, RevealConcealButton;

- (void)applicationDidFinishLaunching:(NSNotification *)n
{
  [passwordField bind:NSValueBinding
             toObject:PDKeychainBindingsController.sharedKeychainBindingsController
          withKeyPath:[NSString stringWithFormat:@"values.%@",@"passwordString"]
              options:@{@"NSContinuouslyUpdatesValue":@YES}];
}

- (IBAction)toggleRevealConceal:(id)sender {

  PDKeychainBindings *bindings = PDKeychainBindings.sharedKeychainBindings;
  BOOL reveal = [RevealConcealButton.title isEqualToString:@"Reveal"];

  RevealLabel.stringValue   = reveal ? [bindings stringForKey:@"passwordString"] : @"";
  RevealConcealButton.title = reveal ? @"Conceal" : @"Reveal";
}

@end

int main(int argc, char *argv[]) { return NSApplicationMain(argc, (const char **)argv); }

