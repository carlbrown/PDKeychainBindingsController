//
//  PDKeychainBindingsControllerTest.m
//  PDKeychainBindingsController
//
//  Created by Carl Brown on 7/10/11.
//  Copyright 2011 PDAgent, LLC. All rights reserved.
//

#import "PDKeychainBindingsControllerTest.h"
#import "PDKeychainBindingsController.h"


@implementation PDKeychainBindingsControllerTest

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
    STAssertNotNil([PDKeychainBindingsController sharedKeychainBindingsController], @"PDKeychainBindingsController sharedKeychainBindingsController was nil!!");
}

@end
