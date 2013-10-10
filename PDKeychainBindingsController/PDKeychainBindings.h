//
//  PDKeychainBindings.h
//  PDKeychainBindingsController
//
//  Created by Carl Brown on 7/10/11.
//  Copyright 2011 PDAgent, LLC. Released under MIT License.
//

#import <Foundation/Foundation.h>


@interface PDKeychainBindings : NSObject {
@private
    
}

+ (PDKeychainBindings *)sharedKeychainBindings;

- (id)objectForKey:(NSString *)defaultName;
- (void)setObject:(NSString *)value forKey:(NSString *)defaultName;
- (void)setObject:(NSString *)value forKey:(NSString *)defaultName accessibleAttribute:(CFTypeRef)accessibleAttribute;

- (void)setString:(NSString *)value forKey:(NSString *)defaultName;
- (void)setString:(NSString *)value forKey:(NSString *)defaultName accessibleAttribute:(CFTypeRef)accessibleAttribute;

- (void)removeObjectForKey:(NSString *)defaultName;

- (NSString *)stringForKey:(NSString *)defaultName;
@end
