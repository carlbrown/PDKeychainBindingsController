//
//  PDKeychainBindingsTest.m
//  PDKeychainBindingsController
//
//  Created by Carl Brown on 7/10/11.
//  Copyright 2011 PDAgent, LLC. All rights reserved.
//

#import "PDKeychainBindingsTest.h"
#import "PDKeychainBindings.h"


@implementation PDKeychainBindingsTest

- (NSString*) stringWithUUID {
    CFUUIDRef	uuidObj = CFUUIDCreate(nil);//create a new UUID
    //get the string representation of the UUID
    NSString	*uuidString = (NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return [uuidString autorelease];
}

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

- (void)testStandardBindingsExists
{
    STAssertNotNil([PDKeychainBindings sharedKeychainBindings], @"PDKeychainBindings sharedKeychainBindings was nil!!");
}

- (void)testStandardBindingsWorksAtAll
{
    //Decide what we're going to set it to
    NSString *targetString = [self stringWithUUID];
    
    //Now set it
    [[PDKeychainBindings sharedKeychainBindings] setObject:targetString forKey:@"testObject"];
    
    //Now make sure it got set correctly
    STAssertNotNil([[PDKeychainBindings sharedKeychainBindings] objectForKey:@"testObject"], @"PDKeychainBindings sharedKeychainBindings was nil!!");
    STAssertEquals(targetString, [[PDKeychainBindings sharedKeychainBindings] objectForKey:@"testObject"], @"Did not retrieve object correctly");
    
    //Now clean up after ourselves
    [[PDKeychainBindings sharedKeychainBindings] removeObjectForKey:@"testObject"];

}

- (void)testStandardBindingsTalksToKeychain
{
    //Decide what we're going to set it to
    NSString *targetString = [self stringWithUUID];
    
    //Now set it
    [[PDKeychainBindings sharedKeychainBindings] setObject:targetString forKey:@"keychainRetrievalTestObject"];
    
    //Now make sure it got set correctly
    NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:(id)kCFBooleanTrue, kSecReturnData,
                           kSecClassGenericPassword, kSecClass,
                           @"keychainRetrievalTestObject", kSecAttrAccount,
                           [[NSBundle mainBundle] bundleIdentifier], kSecAttrService,
                           nil];
	
    CFDataRef stringData = NULL;
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)query, (CFTypeRef*)&stringData);
    
    STAssertEquals((uint) 0, (uint) status, @"Failed to retrive data, status was '%i'", status);
    
    NSString *string = [[[NSString alloc] initWithData:(id)stringData encoding:NSUTF8StringEncoding] autorelease];
    STAssertEqualObjects(string, targetString, @"retrieved string from keychain '%@' not equal to expected 'foo'", string);
    CFRelease(stringData);
    
    STAssertNotNil([[PDKeychainBindings sharedKeychainBindings] objectForKey:@"keychainRetrievalTestObject"], @"PDKeychainBindings sharedKeychainBindings was nil!!");
    STAssertEquals(targetString, [[PDKeychainBindings sharedKeychainBindings] objectForKey:@"keychainRetrievalTestObject"], @"Did not retrieve object correctly");
    
    //Now clean up after ourselves
    [[PDKeychainBindings sharedKeychainBindings] removeObjectForKey:@"keychainRetrievalTestObject"];
}

#else                           // all code under test must be linked into the Unit Test bundle

- (void)testStandardBindingsExists
{
    STAssertNotNil([PDKeychainBindings sharedKeychainBindings], @"PDKeychainBindings sharedKeychainBindings was nil!!");
}

- (void)testStandardBindingsWorksAtAll
{
    //Make sure it's empty
    [[PDKeychainBindings sharedKeychainBindings] setObject:@"foo" forKey:@"testObject"];
    STAssertNil([[PDKeychainBindings sharedKeychainBindings] objectForKey:@"testObject"], @"PDKeychainBindings sharedKeychainBindings was nil!!");

    //Now set it
    [[PDKeychainBindings sharedKeychainBindings] setObject:@"foo" forKey:@"testObject"];

    //Now make sure it got set correctly
    STAssertNotNil([[PDKeychainBindings sharedKeychainBindings] objectForKey:@"testObject"], @"PDKeychainBindings sharedKeychainBindings was nil!!");
    STAssertEquals(@"foo", [[PDKeychainBindings sharedKeychainBindings] objectForKey:@"testObject"], @"Did not retrieve object correctly");
}
#endif

@end
