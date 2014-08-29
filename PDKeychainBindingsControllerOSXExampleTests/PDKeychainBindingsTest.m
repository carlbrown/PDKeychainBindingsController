//
//  PDKeychainBindingsTest.m
//  PDKeychainBindingsController
//
//  Created by Carl Brown on 7/14/11.
//  Copyright 2011 PDAgent, LLC. Released under MIT License.
//

#import "PDKeychainBindings.h"
#import <Security/Security.h>

@interface PDKeychainBindingsTest : SenTestCase
@end

@implementation PDKeychainBindingsTest

- (void)testStandardBindingsExists
{
  STAssertNotNil(PDKeychainBindings.sharedKeychainBindings, @"PDKeychainBindings sharedKeychainBindings was nil!!");
}

- (void)testStandardBindingsWorksAtAll
{
  //Decide what we're going to set it to
  NSString *targetString = UUIDString();

  //Now set it
  [PDKeychainBindings.sharedKeychainBindings setObject:targetString forKey:@"testObject"];

  //Now make sure it got set correctly
  STAssertNotNil([PDKeychainBindings.sharedKeychainBindings objectForKey:@"testObject"], @"PDKeychainBindings sharedKeychainBindings was nil!!");
  STAssertEquals(targetString, [PDKeychainBindings.sharedKeychainBindings objectForKey:@"testObject"], @"Did not retrieve object correctly");

  //Now clean up after ourselves
  [PDKeychainBindings.sharedKeychainBindings removeObjectForKey:@"testObject"];

}


- (void)testStandardBindingsTalksToKeychain
{
  //Decide what we're going to set it to
  NSString *targetString = UUIDString();

  //Now set it
  [PDKeychainBindings.sharedKeychainBindings setObject:targetString
                                                forKey:@"keychainRetrievalTestObject"];

  //Now make sure it got set correctly
  UInt32 stringLength=0;
  void *stringBuffer=NULL;

  OSStatus status = SecKeychainFindGenericPassword(NULL, (uint) [[[NSBundle mainBundle] bundleIdentifier] lengthOfBytesUsingEncoding:NSUTF8StringEncoding], [[[NSBundle mainBundle] bundleIdentifier] UTF8String],
                                                   (uint) [@"keychainRetrievalTestObject" lengthOfBytesUsingEncoding:NSUTF8StringEncoding], [@"keychainRetrievalTestObject" UTF8String],
                                                   &stringLength, &stringBuffer, NULL);
  STAssertEquals(0, status, @"Failed to retrive data, status was '%i'", status);

  if (status) {
    CFStringRef errorMsg= SecCopyErrorMessageString(status, NULL);
    NSLog(@"Error copying Keychain item: %@",errorMsg);
    CFRelease(errorMsg);
  }
  NSString *string = [NSString.alloc initWithBytes:stringBuffer length:stringLength encoding:NSUTF8StringEncoding];
  STAssertEqualObjects(string, targetString, @"retrieved string from keychain '%@' not equal to expected 'foo'", string);
  SecKeychainItemFreeAttributesAndData(NULL, stringBuffer);

  STAssertNotNil([[PDKeychainBindings sharedKeychainBindings] objectForKey:@"keychainRetrievalTestObject"], @"PDKeychainBindings sharedKeychainBindings was nil!!");
  STAssertEquals(targetString, [PDKeychainBindings.sharedKeychainBindings objectForKey:@"keychainRetrievalTestObject"], @"Did not retrieve object correctly");

  //Now clean up after ourselves
  [PDKeychainBindings.sharedKeychainBindings removeObjectForKey:@"keychainRetrievalTestObject"];
}

@end
