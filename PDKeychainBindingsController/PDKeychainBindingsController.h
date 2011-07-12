//
//  PDKeychainBindingsController.h
//  PDKeychainBindingsController
//
//  Created by Carl Brown on 7/10/11.
//  Copyright 2011 PDAgent, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDKeychainBindings.h"


@interface PDKeychainBindingsController : NSObject {
@private
    PDKeychainBindings *_keychainBindings;
    NSMutableDictionary *_valueBuffer;
}


+ (PDKeychainBindingsController *)sharedKeychainBindingsController;
- (PDKeychainBindings *) keychainBindings;

- (id)values;    // accessor object for PDKeychainBindings values. This property is observable using key-value observing.


@end

