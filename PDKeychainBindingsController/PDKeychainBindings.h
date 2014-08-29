
/*! @file       PDKeychainBindings.h
    @class      PDKeychainBindings
    @author     Carl Brown @since 7/10/11.
    @copyright  2011 PDAgent, LLC. Released under MIT License.
*/

#import <Foundation/Foundation.h>

@interface PDKeychainBindings : NSObject

+ (instancetype) sharedKeychainBindings;

- (NSString*)  stringForKey:(NSString*)def;

- (void)          setString:(NSString*)s
                     forKey:(NSString*)def;

- (void)          setString:(NSString*)s
                     forKey:(NSString*)def
        accessibleAttribute:(CFTypeRef)aa;


-              objectForKey:(NSString*)def;

- (void)          setObject:(NSString*)x
                     forKey:(NSString*)def;

- (void)          setObject:(NSString*)x
                     forKey:(NSString*)def
       accessibleAttribute:(CFTypeRef)aa;

- (void) removeObjectForKey:(NSString*)def;



@end
