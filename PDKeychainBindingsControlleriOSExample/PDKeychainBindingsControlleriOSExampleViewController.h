//
//  PDKeychainBindingsControlleriOSExampleViewController.h
//  PDKeychainBindingsControlleriOSExample
//
//  Created by Carl Brown on 7/10/11.
//  Copyright 2011 PDAgent, LLC. Released under MIT License.
//

#import <UIKit/UIKit.h>

@interface PDKeychainBindingsControlleriOSExampleViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic) IBOutlet UITextField *passwordField;
@property (nonatomic) IBOutlet UIButton *revealButton;
@property (nonatomic) IBOutlet UILabel *retrievedLabel;

- (IBAction)toggleReveal:(id)sender;

@end
