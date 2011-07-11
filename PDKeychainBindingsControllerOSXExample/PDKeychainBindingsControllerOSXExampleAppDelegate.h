//
//  PDKeychainBindingsControllerOSXExampleAppDelegate.h
//  PDKeychainBindingsControllerOSXExample
//
//  Created by Carl Brown on 7/10/11.
//  Copyright 2011 PDAgent, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PDKeychainBindingsControllerOSXExampleAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
