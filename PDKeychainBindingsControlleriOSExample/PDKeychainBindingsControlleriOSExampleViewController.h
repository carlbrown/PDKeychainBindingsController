//
//  PDKeychainBindingsControlleriOSExampleViewController.h
//  PDKeychainBindingsControlleriOSExample
//
//  Created by Carl Brown on 7/10/11.
//  Copyright 2011 PDAgent, LLC. Released under MIT License.
//

#import <UIKit/UIKit.h>

@interface PDKeychainBindingsControlleriOSExampleViewController : UIViewController <UITextFieldDelegate>{
    
    UITextField *passwordField;
    UIButton *revealButton;
    UILabel *retrievedLabel;
}
@property (nonatomic, retain) IBOutlet UITextField *passwordField;
@property (nonatomic, retain) IBOutlet UIButton *revealButton;
@property (nonatomic, retain) IBOutlet UILabel *retrievedLabel;

- (IBAction)toggleReveal:(id)sender;

@end
