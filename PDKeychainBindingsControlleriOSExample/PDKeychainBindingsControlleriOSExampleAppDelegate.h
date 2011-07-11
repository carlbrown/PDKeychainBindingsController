//
//  PDKeychainBindingsControlleriOSExampleAppDelegate.h
//  PDKeychainBindingsControlleriOSExample
//
//  Created by Carl Brown on 7/10/11.
//  Copyright 2011 PDAgent, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PDKeychainBindingsControlleriOSExampleViewController;

@interface PDKeychainBindingsControlleriOSExampleAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet PDKeychainBindingsControlleriOSExampleViewController *viewController;

@end
