//
//  PDKeychainBindingsTest.m
//  PDKeychainBindingsController
//
//  Created by Carl Brown on 7/14/11.
//  Copyright 2011 PDAgent, LLC. All rights reserved.
//

#import "PDKeychainBindingsTest.h"
#import "PDKeychainBindings.h"
#import <Security/Security.h>

@implementation PDKeychainBindingsTest

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testStandardBindingsExists
{
    STAssertNotNil([PDKeychainBindings sharedKeychainBindings], @"PDKeychainBindings sharedKeychainBindings was nil!!");
}

- (void)testStandardBindingsWorksAtAll
{
    //Make sure it's empty
    [[PDKeychainBindings sharedKeychainBindings] removeObjectForKey:@"testObject"];
    STAssertNil([[PDKeychainBindings sharedKeychainBindings] objectForKey:@"testObject"], @"PDKeychainBindings sharedKeychainBindings was nil!!");
    
    //Now set it
    [[PDKeychainBindings sharedKeychainBindings] setObject:@"foo" forKey:@"testObject"];
    
    //Now make sure it got set correctly
    STAssertNotNil([[PDKeychainBindings sharedKeychainBindings] objectForKey:@"testObject"], @"PDKeychainBindings sharedKeychainBindings was nil!!");
    STAssertEquals(@"foo", [[PDKeychainBindings sharedKeychainBindings] objectForKey:@"testObject"], @"Did not retrieve object correctly");
}

- (void)testStandardBindingsTalksToKeychain
{
    //Make sure it's empty
    [[PDKeychainBindings sharedKeychainBindings] removeObjectForKey:@"keychainRetrievalTestObject"];
    STAssertNil([[PDKeychainBindings sharedKeychainBindings] objectForKey:@"keychainRetrievalTestObject"], @"PDKeychainBindings sharedKeychainBindings was nil!!");
    //Make sure Keychain doesn't have it, either
    SecKeychainItemRef item = NULL;
    OSStatus status = SecKeychainFindGenericPassword(NULL, (uint) [[[NSBundle mainBundle] bundleIdentifier] lengthOfBytesUsingEncoding:NSUTF8StringEncoding], [[[NSBundle mainBundle] bundleIdentifier] UTF8String],
                                                     (uint) [@"keychainRetrievalTestObject" lengthOfBytesUsingEncoding:NSUTF8StringEncoding], [@"keychainRetrievalTestObject" UTF8String],
                                                     NULL, NULL, &item);
    if(!status && item) {
        BOOL itemSuccesfullyClearedFromLastRun = SecKeychainItemDelete(item);
        STAssertTrue(itemSuccesfullyClearedFromLastRun, @"Failed to delete item from last run, can't continue");
    }
    
    //Now set it
    [[PDKeychainBindings sharedKeychainBindings] setObject:@"foo" forKey:@"keychainRetrievalTestObject"];
    
    //Now make sure it got set correctly
    item = NULL;
    UInt32 stringLength=0;
    void *stringBuffer=NULL;
    
    status = SecKeychainFindGenericPassword(NULL, (uint) [[[NSBundle mainBundle] bundleIdentifier] lengthOfBytesUsingEncoding:NSUTF8StringEncoding], [[[NSBundle mainBundle] bundleIdentifier] UTF8String],
                                            (uint) [@"keychainRetrievalTestObject" lengthOfBytesUsingEncoding:NSUTF8StringEncoding], [@"keychainRetrievalTestObject" UTF8String],
                                            &stringLength, &stringBuffer, NULL);
    STAssertEquals(0, status, @"Failed to retrive data, status was '%i'", status);
    
    if (status) {
        CFStringRef errorMsg= SecCopyErrorMessageString(status, NULL);
        NSLog(@"Error copying Keychain item: %@",errorMsg);
        CFRelease(errorMsg);
    }
    NSString *string = [[[NSString alloc] initWithBytes:stringBuffer length:stringLength encoding:NSUTF8StringEncoding] autorelease];
    STAssertEqualObjects(string, @"foo", @"retrieved string from keychain '%@' not equal to expected 'foo'", string);
    SecKeychainItemFreeAttributesAndData(NULL, stringBuffer);
    
    STAssertNotNil([[PDKeychainBindings sharedKeychainBindings] objectForKey:@"keychainRetrievalTestObject"], @"PDKeychainBindings sharedKeychainBindings was nil!!");
    STAssertEquals(@"foo", [[PDKeychainBindings sharedKeychainBindings] objectForKey:@"keychainRetrievalTestObject"], @"Did not retrieve object correctly");
}

@end
