
/*! @file       PDKeychainBindingsController.h
    @class      PDKeychainBindingsController
    @author     Carl Brown @since 7/10/11.
    @copyright  2011 PDAgent, LLC. Released under MIT License.
*/

#import "PDKeychainBindings.h"

@interface PDKeychainBindingsController : NSObject

@property (readonly) PDKeychainBindings* keychainBindings;

+ (instancetype) sharedKeychainBindingsController;

/// KVO-observable accessor property representing the PDKeychainBindings' values.

@property (readonly) id values;

- (void)          setValue:x
                forKeyPath:(NSString*)kp
       accessibleAttribute:(CFTypeRef)aa;

- (BOOL)       storeString:(NSString*)s
                    forKey:(NSString*)k
       accessibleAttribute:(CFTypeRef)aa;

- (BOOL)       storeString:(NSString*)s
                    forKey:(NSString*)k;

- (NSString*) stringForKey:(NSString*)k;

#if !TARGET_OS_IPHONE // The following methods are OSX-only

- (void)                  useDefaultKeychain;
- (BOOL) removeExternalKeychainFileWithError:(NSError**)e;
- (BOOL)     useExternalKeychainFileWithPath:(NSString*)x
                                    password:(NSString*)p
                                       error:(NSError**)e;
#endif

@end
