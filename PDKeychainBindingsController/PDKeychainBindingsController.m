
/*! @file       PDKeychainBindingsController.m
    @class      PDKeychainBindingsController
    @author     Carl Brown @since 7/10/11.
    @copyright  2011 PDAgent, LLC. Released under MIT License.
*/

#import "PDKeychainBindingsController.h"
#import <Security/Security.h>

@implementation PDKeychainBindingsController {
#if !TARGET_OS_IPHONE
	     SecKeychainRef		_secKeychainRef;
#endif
  @private
  NSMutableDictionary *_valueBuffer;
}

#pragma mark - Singleton Stuff

/*
  @note There's (understandably) a lot of controversy about how (and whether) to use the Singleton pattern for Cocoa.  I am here because I'm  trying to emulate existing Singleton (NSUserDefaults) behavior and I'm using the singleton methodology from @link  http://www.duckrowing.com/2010/05/21/using-the-singleton-pattern-in-objective-c/ because it seemed reasonable
*/

static PDKeychainBindingsController *sharedInstance = nil;

+ (PDKeychainBindingsController*) sharedKeychainBindingsController {
    static dispatch_once_t onceQueue;

    dispatch_once(&onceQueue, ^{
        sharedInstance = [[self alloc] init];
    });

	return sharedInstance;
}

#pragma mark - External Keychain Access (OSX)

#if !TARGET_OS_IPHONE

- (NSError*)NSErrorFromOSStatus:(OSStatus)status {
	// get error description
	NSString *description = (__bridge_transfer NSString*)SecCopyErrorMessageString(status, NULL);
	return [NSError errorWithDomain:NSOSStatusErrorDomain
							   code:status
						   userInfo:@{ NSLocalizedDescriptionKey : description}];
}

- (void)useDefaultKeychain {
	if( _secKeychainRef ) {
		SecKeychainLock(_secKeychainRef);
		CFRelease(_secKeychainRef);
		_secKeychainRef = NULL;
	}
}

- (BOOL)useExternalKeychainFileWithPath:(NSString*)path password:(NSString*)password error:(NSError**)error {
	if( _secKeychainRef ) {
		SecKeychainLock(_secKeychainRef);
		// free current keychainRef
		CFRelease(_secKeychainRef);
	}
	
	OSStatus status;
	
	// open existing keychain
	status = SecKeychainOpen([path fileSystemRepresentation], &_secKeychainRef);
	if( status != errSecSuccess ) {
		goto handleError;
	}
	
	status = SecKeychainUnlock(_secKeychainRef, (UInt32)password.length, [password UTF8String], TRUE );
	if( status == errSecSuccess ) {
		return YES;
	}
	if( status == errSecNoSuchKeychain ) {
		// create new keychain
		status = SecKeychainCreate([path fileSystemRepresentation]
							   , (UInt32)password.length
							   , [password UTF8String]
							   , FALSE
							   , NULL
							   , &_secKeychainRef );
	
		if( status != errSecSuccess ) {
			goto handleError;
		}
		
		return YES;
	}
	
handleError:
	if( error ) {
		*error = [self NSErrorFromOSStatus:status];
	}
	
	return NO;
}

- (BOOL)removeExternalKeychainFileWithError:(NSError**)error {
	if( _secKeychainRef ) {
		OSStatus status = SecKeychainDelete(_secKeychainRef);
		if( status != errSecSuccess ) {
			if( error ) {
				*error = [self NSErrorFromOSStatus:status];
			}
			return NO;
		}
	} else {
		return NO;
	}
	
	_secKeychainRef = NULL;
	
	return YES;
}

- (void) dealloc {
	// release
	if( _secKeychainRef ) {
		SecKeychainLock(_secKeychainRef);
		CFRelease(_secKeychainRef);
	}
}

#endif

#pragma mark - Keychain Access

- (NSString*)serviceName {
	return [[NSBundle mainBundle] bundleIdentifier];
}

- (NSString*)stringForKey:(NSString*)key {
	OSStatus status;
#if TARGET_OS_IPHONE
    NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:(id)kCFBooleanTrue, kSecReturnData,
                           kSecClassGenericPassword, kSecClass,
                           key, kSecAttrAccount,
                           [self serviceName], kSecAttrService,
                           nil];
	
    CFDataRef stringData = NULL;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef*)&stringData);
#else //OSX
    //SecKeychainItemRef item = NULL;
    UInt32 stringLength;
    void *stringBuffer;
    status = SecKeychainFindGenericPassword(_secKeychainRef, (uint) [[self serviceName] lengthOfBytesUsingEncoding:NSUTF8StringEncoding], [[self serviceName] UTF8String],
                                            (uint) [key lengthOfBytesUsingEncoding:NSUTF8StringEncoding], [key UTF8String],
                                            &stringLength, &stringBuffer, NULL);
    #endif
	if(status) return nil;
	
#if TARGET_OS_IPHONE
    NSString *string = [[NSString alloc] initWithData:(__bridge id)stringData encoding:NSUTF8StringEncoding];
    CFRelease(stringData);
#else //OSX
    NSString *string = [[NSString alloc] initWithBytes:stringBuffer length:stringLength encoding:NSUTF8StringEncoding];
    SecKeychainItemFreeAttributesAndData(NULL, stringBuffer);
#endif
	return string;	
}

- (BOOL)storeString:(NSString*)string forKey:(NSString*)key {
    return [self storeString:string forKey:key accessibleAttribute:kSecAttrAccessibleWhenUnlocked];
}

- (BOOL)storeString:(NSString*)string forKey:(NSString*)key accessibleAttribute:(CFTypeRef)accessibleAttribute {
	if (!string)  {
		//Need to delete the Key 
#if TARGET_OS_IPHONE
        NSDictionary *spec = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)kSecClassGenericPassword, kSecClass,
                              key, kSecAttrAccount,[self serviceName], kSecAttrService, nil];
        
        OSStatus result=SecItemDelete((__bridge CFDictionaryRef)spec);
        if (result!=0) {
            NSLog(@"Could not store(Delete) string. Error was:%i",(int)result);
        }
        return !result;
#else //OSX
        SecKeychainItemRef item = NULL;
        OSStatus status = SecKeychainFindGenericPassword(_secKeychainRef, (uint) [[self serviceName] lengthOfBytesUsingEncoding:NSUTF8StringEncoding], [[self serviceName] UTF8String],
                                                         (uint) [key lengthOfBytesUsingEncoding:NSUTF8StringEncoding], [key UTF8String],
                                                         NULL, NULL, &item);
        if(status) return YES;
        if(!item) return YES;
        return !SecKeychainItemDelete(item);
#endif
    } else {
#if TARGET_OS_IPHONE
        NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *spec = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)kSecClassGenericPassword, kSecClass,
                              key, kSecAttrAccount,[self serviceName], kSecAttrService, nil];
        
        if(!string) {
            OSStatus result=SecItemDelete((__bridge CFDictionaryRef)spec);
            if (result!=0) {
                NSLog(@"Could not store(Delete) string. Error was:%i",(int)result);
            }
            return !result;
        }else if([self stringForKey:key]) {
            NSDictionary *update = @{
                                     (__bridge id)kSecAttrAccessible:(__bridge id)accessibleAttribute,
                                     (__bridge id)kSecValueData:stringData
                                     };
            
            OSStatus result=SecItemUpdate((__bridge CFDictionaryRef)spec, (__bridge CFDictionaryRef)update);
            if (result!=0) {
                NSLog(@"Could not store(Update) string. Error was:%i",(int)result);
            }
return !result;
        }else{
            NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:spec];
            data[(__bridge id)kSecValueData] = stringData;
            data[(__bridge id)kSecAttrAccessible] =(__bridge id)accessibleAttribute;
            OSStatus result=SecItemAdd((__bridge CFDictionaryRef)data, NULL);
            if (result!=0) {
                NSLog(@"Could not store(Add) string. Error was:%i",(int)result);
            }
            return !result;
        }
#else //OSX
        SecKeychainItemRef item = NULL;
        OSStatus status = SecKeychainFindGenericPassword(_secKeychainRef, (uint) [[self serviceName] lengthOfBytesUsingEncoding:NSUTF8StringEncoding], [[self serviceName] UTF8String],
                                                         (uint) [key lengthOfBytesUsingEncoding:NSUTF8StringEncoding], [key UTF8String],
                                                         NULL, NULL, &item);
        if(status) {
            //NO such item. Need to add it
            return !SecKeychainAddGenericPassword(_secKeychainRef, (uint) [[self serviceName] lengthOfBytesUsingEncoding:NSUTF8StringEncoding], [[self serviceName] UTF8String],
                                                  (uint) [key lengthOfBytesUsingEncoding:NSUTF8StringEncoding], [key UTF8String],
                                                  (uint) [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding],[string UTF8String],
                                                  NULL);
        }
        
        if(item)
            return !SecKeychainItemModifyAttributesAndData(item, NULL, (uint) [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding], [string UTF8String]);
        
        else
            return !SecKeychainAddGenericPassword(_secKeychainRef, (uint) [[self serviceName] lengthOfBytesUsingEncoding:NSUTF8StringEncoding], [[self serviceName] UTF8String],
                                                  (uint) [key lengthOfBytesUsingEncoding:NSUTF8StringEncoding], [key UTF8String],
                                                  (uint) [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding],[string UTF8String],
                                                  NULL);
#endif
    }
}

#pragma mark - Business Logic

@synthesize keychainBindings = _keychainBindings;

- (PDKeychainBindings *) keychainBindings {
    if (_keychainBindings == nil) {
        _keychainBindings = [[PDKeychainBindings alloc] init]; 
    }
    if (_valueBuffer==nil) {
        _valueBuffer = [[NSMutableDictionary alloc] init];
    }
    return _keychainBindings;
}

- values {
    if (_valueBuffer==nil) {
        _valueBuffer = [[NSMutableDictionary alloc] init];
    }
    return _valueBuffer;
}

- valueForKeyPath:(NSString *)keyPath {
    NSRange firstSeven=NSMakeRange(0, 7);
    if (NSEqualRanges([keyPath rangeOfString:@"values."],firstSeven)) {
        //This is a values keyPath, so we need to check the keychain
        NSString *subKeyPath = [keyPath stringByReplacingCharactersInRange:firstSeven withString:@""];
        NSString *retrievedString = [self stringForKey:subKeyPath];
        if (retrievedString) {
            if (![_valueBuffer objectForKey:subKeyPath] || ![[_valueBuffer objectForKey:subKeyPath] isEqualToString:retrievedString]) {
                //buffer has wrong value, need to update it
                [_valueBuffer setValue:retrievedString forKey:subKeyPath];
            }
        }
    }
    
    return [super valueForKeyPath:keyPath];
}

- (void)setValue:value forKeyPath:(NSString*)keyPath {
    [self setValue:value forKeyPath:keyPath accessibleAttribute:kSecAttrAccessibleWhenUnlocked];
}

- (void)setValue:value forKeyPath:(NSString*)keyPath accessibleAttribute:(CFTypeRef)accessibleAttribute {
    NSRange firstSeven=NSMakeRange(0, 7);
    if (NSEqualRanges([keyPath rangeOfString:@"values."],firstSeven)) {
        //This is a values keyPath, so we need to check the keychain
        NSString *subKeyPath = [keyPath stringByReplacingCharactersInRange:firstSeven withString:@""];
        NSString *retrievedString = [self stringForKey:subKeyPath];
        if (retrievedString) {
            if (![value isEqualToString:retrievedString]) {
                [self storeString:value forKey:subKeyPath accessibleAttribute:accessibleAttribute];
            }
            if (![_valueBuffer objectForKey:subKeyPath] || ![[_valueBuffer objectForKey:subKeyPath] isEqualToString:value]) {
                //buffer has wrong value, need to update it
                [_valueBuffer setValue:value forKey:subKeyPath ];
            }
        } else {
            //First time to set it
            [self storeString:value forKey:subKeyPath accessibleAttribute:accessibleAttribute];
            [_valueBuffer setValue:value forKey:subKeyPath];
        }
    } 
    [super setValue:value forKeyPath:keyPath];
}

@end
