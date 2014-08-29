
/*! @file       PDKeychainBindings.m
    @class      PDKeychainBindings
    @author     Carl Brown @since 7/10/11.
    @copyright  2011 PDAgent, LLC. Released under MIT License.
*/

#import "PDKeychainBindings.h"
#import "PDKeychainBindingsController.h"

@implementation PDKeychainBindings

+ (PDKeychainBindings *)sharedKeychainBindings
{
	return PDKeychainBindingsController.sharedKeychainBindingsController.keychainBindings;
}

- objectForKey:(NSString*)defaultName
{
  //return PDKeychainBindingsController.sharedKeychainBindingsController.valueBuffer[defaultName];

  return [PDKeychainBindingsController.sharedKeychainBindingsController
   valueForKeyPath:[NSString stringWithFormat:@"values.%@",defaultName]];
}

- (void)setObject:(NSString *)value forKey:(NSString *)defaultName
{
  [PDKeychainBindingsController.sharedKeychainBindingsController setValue:value
               forKeyPath:[NSString stringWithFormat:@"values.%@",defaultName]];
}

- (void)setObject:(NSString *)value forKey:(NSString *)defaultName accessibleAttribute:(CFTypeRef)accessibleAttribute
{
  [PDKeychainBindingsController.sharedKeychainBindingsController setValue:value
                     forKeyPath:[NSString stringWithFormat:@"values.%@",defaultName]
            accessibleAttribute:accessibleAttribute];
}

- (void)setString:(NSString *)value forKey:(NSString *)defaultName
{
  [PDKeychainBindingsController.sharedKeychainBindingsController setValue:value
                     forKeyPath:[NSString stringWithFormat:@"values.%@",defaultName]];
}

- (void)setString:(NSString *)value forKey:(NSString *)defaultName accessibleAttribute:(CFTypeRef)accessibleAttribute
{
  [PDKeychainBindingsController.sharedKeychainBindingsController setValue:value
                forKeyPath:[NSString stringWithFormat:@"values.%@",defaultName]
                                       accessibleAttribute:accessibleAttribute];
}

- (void)removeObjectForKey:(NSString *)defaultName
{
  [PDKeychainBindingsController.sharedKeychainBindingsController setValue:nil
             forKeyPath:[NSString stringWithFormat:@"values.%@",defaultName]];
}

- (NSString *)stringForKey:(NSString *)defaultName { return [self objectForKey:defaultName]; }

@end
