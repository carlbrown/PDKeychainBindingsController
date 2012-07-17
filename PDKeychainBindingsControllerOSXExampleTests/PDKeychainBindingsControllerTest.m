//
//  PDKeychainBindingsControllerTest.m
//  PDKeychainBindingsController
//
//  Created by Carl Brown on 7/10/11.
//  Copyright 2011 PDAgent, LLC. Released under MIT License.
//

#import "PDKeychainBindingsControllerTest.h"
#import "PDKeychainBindingsController.h"
#import "TestContainerClass.h"

@implementation PDKeychainBindingsControllerTest

- (NSString*) stringWithUUID {
    CFUUIDRef	uuidObj = CFUUIDCreate(nil);//create a new UUID
    //get the string representation of the UUID
    NSString	*uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidString;
}

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

- (void)testStandardBindingsControllerSetRetrieval
{
    //Decide what we're going to set it to
    NSString *targetString = [self stringWithUUID];

    //Pull the PDKeychainBindingsController into a local variable just so we can look at it in the debugger if we want to see what's going on
    PDKeychainBindingsController *controller = [PDKeychainBindingsController sharedKeychainBindingsController];
    [controller setValue:targetString forKeyPath:[NSString stringWithFormat:@"values.%@",@"myTestString"]];

    NSObject *currentValue = [controller valueForKeyPath:[NSString stringWithFormat:@"values.%@",@"myTestString"]];
    STAssertNotNil(currentValue, @"could not get value back");
    //Now make sure it got set correctly
    STAssertNotNil([[PDKeychainBindings sharedKeychainBindings] objectForKey:@"myTestString"], @"PDKeychainBindings sharedKeychainBindings object for myTestString was nil!!");
    STAssertEquals(targetString, [[PDKeychainBindings sharedKeychainBindings] objectForKey:@"myTestString"], @"Did not retrieve object correctly");
    
    //Now clean up after ourselves
    [[PDKeychainBindings sharedKeychainBindings] removeObjectForKey:@"myTestString"];

}

/*
 Commenting these out, because bindings, although seemingly working in the UI, aren't working inside the unit tests.

- (void)testStandardDefaultsWillBind
{
    
    //This tests shows how to bind NSUserDefaults the way the next test binds our new object

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"myTestString"];
    
    TestContainerClass *testContainer = [[TestContainerClass alloc] init];
    [testContainer bind:@"value"
               toObject:[NSUserDefaultsController sharedUserDefaultsController]
            withKeyPath:[NSString stringWithFormat:@"values.%@",@"myTestString"]
                options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
                                                    forKey:@"NSContinuouslyUpdatesValue"]];

    [testContainer setValue:@"foo" forKey:@"value"];
    
    NSUserDefaultsController *controller = [NSUserDefaultsController sharedUserDefaultsController];

    NSObject *currentValue = [controller valueForKeyPath:[NSString stringWithFormat:@"values.%@",@"myTestString"]];
    STAssertNotNil(currentValue, @"could not get value back");
    //Now make sure it got set correctly
    STAssertNotNil([[NSUserDefaults standardUserDefaults] objectForKey:@"myTestString"], @"PDKeychainBindings sharedKeychainBindings object for myTestString was nil!!");
    STAssertEquals(@"foo", [[NSUserDefaults standardUserDefaults] objectForKey:@"myTestString"], @"Did not retrieve object correctly");
    
}


- (void)testStandardBindingsWillBind
{
 
    //Pull the PDKeychainBindingsController into a local variable just so we can look at it in the debugger if we want to see what's going on
    PDKeychainBindingsController *controller = [PDKeychainBindingsController sharedKeychainBindingsController];

    //Erase it first
    [controller setValue:nil forKeyPath:[NSString stringWithFormat:@"values.%@",@"myTestString"]];

    TestContainerClass *testContainer = [[TestContainerClass alloc] init];
    [testContainer bind:@"value"
               toObject:[PDKeychainBindingsController sharedKeychainBindingsController]
            withKeyPath:[NSString stringWithFormat:@"values.%@",@"myTestString"]
                options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
                                                    forKey:@"NSContinuouslyUpdatesValue"]];
    
    [testContainer setValue:@"foo" forKey:@"value"];
    
    //Now make sure it got set correctly
    STAssertNotNil([[PDKeychainBindings sharedKeychainBindings] objectForKey:@"myTestString"], @"PDKeychainBindings sharedKeychainBindings object for myTestString was nil!!");
    STAssertEquals(@"foo", [[PDKeychainBindings sharedKeychainBindings] objectForKey:@"myTestString"], @"Did not retrieve object correctly");
    
}

*/

@end
