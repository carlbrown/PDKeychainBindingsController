//
//  PDKeychainBindingsController.m
//  PDKeychainBindingsController
//
//  Created by Carl Brown on 7/10/11.
//  Copyright 2011 PDAgent, LLC. All rights reserved.
//

//  There's (understandably) a lot of controversy about how (and whether)
//   to use the Singleton pattern for Cocoa.  I am here because I'm 
//   trying to emulate existing Singleton (NSUserDefaults) behavior
//
//   and I'm using the singleton methodology from
//   http://www.duckrowing.com/2010/05/21/using-the-singleton-pattern-in-objective-c/
//   because it seemed reasonable


#import "PDKeychainBindingsController.h"
#import <Security/Security.h>

static PDKeychainBindingsController *sharedInstance = nil;

@implementation PDKeychainBindingsController


+ (NSString*)serviceName {
	return [[NSBundle mainBundle] bundleIdentifier];
}

+ (NSString*)stringForKey:(NSString*)key {
	OSStatus status;
#if TARGET_OS_IPHONE
    NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:(id)kCFBooleanTrue, kSecReturnData,
                           kSecClassGenericPassword, kSecClass,
                           key, kSecAttrAccount,
                           [self serviceName], kSecAttrService,
                           nil];
	
    CFDataRef stringData = NULL;
    status = SecItemCopyMatching((CFDictionaryRef)query, (CFTypeRef*)&stringData);
#else //OSX
    SecKeychainItemRef item = NULL;
    status = SecKeychainFindGenericPassword(NULL, (uint) [[self serviceName] lengthOfBytesUsingEncoding:NSUTF8StringEncoding], [[self serviceName] UTF8String],
                                            (uint) [key lengthOfBytesUsingEncoding:NSUTF8StringEncoding], [key UTF8String],
                                            NULL, NULL, &item);
    if(status) return nil;
    UInt32 stringLength;
    void *stringBuffer;
    
    status = SecKeychainItemCopyAttributesAndData(item, NULL, NULL, NULL, &stringLength, &stringBuffer);
#endif
	if(status) return nil;
	
#if TARGET_OS_IPHONE
    NSString *string = [[[NSString alloc] initWithData:(id)stringData encoding:NSUTF8StringEncoding] autorelease];
    CFRelease(stringData);
#else //OSX
    NSString *string = [[[NSString alloc] initWithBytes:stringBuffer length:stringLength encoding:NSUTF8StringEncoding] autorelease];
    SecKeychainItemFreeAttributesAndData(NULL, stringBuffer);
#endif
	return string;	
}


+ (BOOL)storeString:(NSString*)string forKey:(NSString*)key {
	if (!string) 
		return NO;
    
#if TARGET_OS_IPHONE
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *spec = [NSDictionary dictionaryWithObjectsAndKeys:(id)kSecClassGenericPassword, kSecClass,
                          key, kSecAttrAccount,[self serviceName], kSecAttrService, nil];
	
    if(!string) {
        return !SecItemDelete((CFDictionaryRef)spec);
    }else if([self stringForKey:key]) {
        NSDictionary *update = [NSDictionary dictionaryWithObject:stringData forKey:(id)kSecValueData];
        return !SecItemUpdate((CFDictionaryRef)spec, (CFDictionaryRef)update);
    }else{
        NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:spec];
        [data setObject:stringData forKey:(id)kSecValueData];
        return !SecItemAdd((CFDictionaryRef)data, NULL);
    }
#else //OSX
    SecKeychainItemRef item = NULL;
    OSStatus status = SecKeychainFindGenericPassword(NULL, (uint) [[self serviceName] lengthOfBytesUsingEncoding:NSUTF8StringEncoding], [[self serviceName] UTF8String],
                                            (uint) [key lengthOfBytesUsingEncoding:NSUTF8StringEncoding], [key UTF8String],
                                            NULL, NULL, &item);
    if(status) return NO;
	
    if(item)
        return !SecKeychainItemModifyAttributesAndData(item, NULL, (uint) [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding], [string UTF8String]);
    
    else
        return !SecKeychainAddGenericPassword(NULL, (uint) [[self serviceName] lengthOfBytesUsingEncoding:NSUTF8StringEncoding], [[self serviceName] UTF8String],
                                              (uint) [key lengthOfBytesUsingEncoding:NSUTF8StringEncoding], [key UTF8String],
                                              (uint) [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding],[string UTF8String],
                                              NULL);
#endif
}

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

- (oneway void)release
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *) context {	
    NSLog(@"Observed change");
}

- (PDKeychainBindings *) keychainBindings {
    if (_keychainBindings == nil) {
        _keychainBindings = [[PDKeychainBindings alloc] init]; 
    }
    if (_valueBuffer==nil) {
        _valueBuffer = [[NSMutableDictionary alloc] init];
        [self addObserver:self forKeyPath:@"values.*" options:0 context:NULL];
    }
    return _keychainBindings;
}

-(id) values {
    if (_valueBuffer==nil) {
        _valueBuffer = [[NSMutableDictionary alloc] init];
        [self addObserver:self forKeyPath:@"values.*" options:0 context:NULL];
    }
    return _valueBuffer;
}

@end
