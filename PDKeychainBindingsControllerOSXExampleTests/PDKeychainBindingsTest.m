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
    [[PDKeychainBindings sharedKeychainBindings] removeObjectForKey:@"testObject"];
    STAssertNil([[PDKeychainBindings sharedKeychainBindings] objectForKey:@"testObject"], @"PDKeychainBindings sharedKeychainBindings was nil!!");
    //Make sure Keychain doesn't have it, either
    SecKeychainItemRef item = NULL;
    OSStatus status = SecKeychainFindGenericPassword(NULL, (uint) [[[NSBundle mainBundle] bundleIdentifier] lengthOfBytesUsingEncoding:NSUTF8StringEncoding], [[[NSBundle mainBundle] bundleIdentifier] UTF8String],
                                                     (uint) [@"testObject" lengthOfBytesUsingEncoding:NSUTF8StringEncoding], [@"testObject" UTF8String],
                                                     NULL, NULL, &item);
    if(!status && item) SecKeychainItemDelete(item);

    //Now set it
    [[PDKeychainBindings sharedKeychainBindings] setObject:@"foo" forKey:@"testObject"];
    
    //Now make sure it got set correctly
    STAssertNotNil([[PDKeychainBindings sharedKeychainBindings] objectForKey:@"testObject"], @"PDKeychainBindings sharedKeychainBindings was nil!!");
    STAssertEquals(@"foo", [[PDKeychainBindings sharedKeychainBindings] objectForKey:@"testObject"], @"Did not retrieve object correctly");
    item = NULL;
    status = SecKeychainFindGenericPassword(NULL, (uint) [[[NSBundle mainBundle] bundleIdentifier] lengthOfBytesUsingEncoding:NSUTF8StringEncoding], [[[NSBundle mainBundle] bundleIdentifier] UTF8String],
                                            (uint) [@"testObject" lengthOfBytesUsingEncoding:NSUTF8StringEncoding], [@"testObject" UTF8String],
                                            NULL, NULL, &item);
    UInt32 stringLength;
    void *stringBuffer;
    
    status = SecKeychainItemCopyAttributesAndData(item, NULL, NULL, NULL, &stringLength, &stringBuffer);
    STAssertFalse(status, @"Failed to retrive data, status was true");
    NSString *string = [[[NSString alloc] initWithBytes:stringBuffer length:stringLength encoding:NSUTF8StringEncoding] autorelease];
    STAssertEqualObjects(string, @"testObject", @"retrieved string from keychain '%@' not equal to expected 'testObject'", string);
    SecKeychainItemFreeAttributesAndData(NULL, stringBuffer);

}

@end
