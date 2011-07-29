//
//  PDKeychainBindingsTest.m
//  PDKeychainBindingsController
//
//  Created by Carl Brown on 7/14/11.
//  Copyright 2011 PDAgent, LLC. All rights reserved.
//

#import "PDKeychainBindingsTest.h"
#import "PDKeychainBindings.h"


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

@end
