
/*! @file PDKeychainBindingsControllerOSXExampleAppDelegate.m */

@import AppKit;

#import "PDKeychainBindingsController.h"

@interface PDKBCOSXExAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet        NSTextView * reader;
@property (assign) IBOutlet          NSButton * revealConcealButton;
@property (assign) IBOutlet       NSTextField * revealLabel;
@property          IBOutlet NSSecureTextField * passwordField;

@end

@implementation PDKBCOSXExAppDelegate

- (void) awakeFromNib {

  [_passwordField bind:NSValueBinding
              toObject:PDKeychainBindingsController.sharedKeychainBindingsController
           withKeyPath:[NSString stringWithFormat:@"values.%@",@"passwordString"]
               options:@{@"NSContinuouslyUpdatesValue":@YES}];

  [self showReadme];
}

- (IBAction) toggleRevealConceal:x {

  PDKeychainBindings *bindings = PDKeychainBindings.sharedKeychainBindings;
  BOOL revealed = [_revealConcealButton.title isEqualToString:@"Reveal"];

  _revealLabel.stringValue   = revealed ? [bindings stringForKey:@"passwordString"] : @"";
  _revealConcealButton.title = revealed ? @"Conceal" : @"Reveal";
}

- (void) showReadme {

  NSArray * lines = [[NSString stringWithContentsOfFile:
                  [NSBundle.mainBundle pathForResource:@"README" ofType:@"md"]
                                               encoding:NSUTF8StringEncoding error:nil]
                                               componentsSeparatedByString:@"\n"];
  for (NSString *readme in lines) {

    NSUInteger caret; BOOL code = readme.length && (caret = [readme rangeOfString:@">"].location) != NSNotFound;
    NSString *line = [NSString stringWithFormat:@"%@\n", code ? [readme substringFromIndex:caret+1] : readme];
    [_reader.textStorage appendAttributedString:
       [NSAttributedString.alloc initWithString:line
                                     attributes:@{
                 NSForegroundColorAttributeName:[NSColor whiteColor],
                            NSFontAttributeName:(code ? [NSFont fontWithName:@"AmericanTypewriter"  size:18]
                                                      : [NSFont fontWithName:@"HelveticaNeue-Medium" size:17])
    }]];
  }
  _reader.textContainerInset = (NSSize){14,14};
  [_reader scrollPoint:NSZeroPoint];
}

@end

int main(int argc, char *argv[]) { return NSApplicationMain(argc, (const char **)argv); }

