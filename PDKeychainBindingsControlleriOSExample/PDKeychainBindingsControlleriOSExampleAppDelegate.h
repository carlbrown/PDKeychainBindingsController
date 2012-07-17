//
//  PDKeychainBindingsControlleriOSExampleAppDelegate.h
//  PDKeychainBindingsControlleriOSExample
//
//  Created by Carl Brown on 7/10/11.
//  Copyright 2011 PDAgent, LLC. Released under MIT License.
//

#import <UIKit/UIKit.h>

@class PDKeychainBindingsControlleriOSExampleViewController;

@interface PDKeychainBindingsControlleriOSExampleAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic) IBOutlet UIWindow *window;

@property (nonatomic) IBOutlet PDKeychainBindingsControlleriOSExampleViewController *viewController;

@end
