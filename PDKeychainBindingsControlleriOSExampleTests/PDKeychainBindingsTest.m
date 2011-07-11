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

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

- (void)testStandardBindingsExists
{
    STAssertNotNil([PDKeychainBindings sharedKeychainBindings], @"PDKeychainBindings sharedKeychainBindings was nil!!");
}

#else                           // all code under test must be linked into the Unit Test bundle

- (void)testStandardBindingsExists
{
    STAssertNotNil([PDKeychainBindings sharedKeychainBindings], @"PDKeychainBindings sharedKeychainBindings was nil!!");
}

#endif

@end
