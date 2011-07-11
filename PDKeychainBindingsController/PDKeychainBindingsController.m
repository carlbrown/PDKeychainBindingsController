//
//  PDKeychainBindingsController.m
//  PDKeychainBindingsController
//
//  Created by Carl Brown on 7/10/11.
//  Copyright 2011 PDAgent, LLC. All rights reserved.
//

#import "PDKeychainBindingsController.h"

static PDKeychainBindingsController *sharedInstance = nil;

@implementation PDKeychainBindingsController



+ (PDKeychainBindingsController *)sharedKeychainBindingsController 
{
	@synchronized (self) {
		if (sharedInstance == nil) {
			[[self alloc] init]; // assignment not done here, see allocWithZone
		}
	}
	
	return sharedInstance;   
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
	
    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  // This is sooo not zero
}

- (id)init
{
	@synchronized(self) {
		[super init];	
		return self;
	}
}

- (PDKeychainBindings *) keychainBindings {
    if (_keychainBindings == nil) {
        _keychainBindings = [[PDKeychainBindings alloc] init]; 
    }
    return _keychainBindings;
}

-(id) values {
    return [self keychainBindings];
}

@end
