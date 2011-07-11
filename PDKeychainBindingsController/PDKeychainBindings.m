//
//  PDKeychainBindings.m
//  PDKeychainBindings
//
//  Created by Carl Brown on 7/10/11.
//  Copyright 2011 PDAgent, LLC. All rights reserved.
//

#import "PDKeychainBindings.h"
#import "PDKeychainBindingsController.h"


@implementation PDKeychainBindings



+ (PDKeychainBindings *)sharedKeychainBindings
{
	return [[PDKeychainBindingsController sharedKeychainBindingsController] keychainBindings];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}



@end
