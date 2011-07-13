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

- (id)objectForKey:(NSString *)defaultName {
    //return [[[PDKeychainBindingsController sharedKeychainBindingsController] valueBuffer] objectForKey:defaultName];
    return [[PDKeychainBindingsController sharedKeychainBindingsController] valueForKeyPath:[NSString stringWithFormat:@"values.%@",defaultName]];
}

- (void)setObject:(id)value forKey:(NSString *)defaultName {
    [[PDKeychainBindingsController sharedKeychainBindingsController] setValue:value forKeyPath:[NSString stringWithFormat:@"values.%@",defaultName]];
}

- (void)removeObjectForKey:(NSString *)defaultName {
    [[PDKeychainBindingsController sharedKeychainBindingsController] setValue:nil forKeyPath:[NSString stringWithFormat:@"values.%@",defaultName]];
}


- (NSString *)stringForKey:(NSString *)defaultName {
    return nil; //TODO: Implement this
}

- (NSArray *)arrayForKey:(NSString *)defaultName {
    return nil; //TODO: Implement this
}

- (NSDictionary *)dictionaryForKey:(NSString *)defaultName {
    return nil; //TODO: Implement this
}

- (NSData *)dataForKey:(NSString *)defaultName {
    return nil; //TODO: Implement this
}

- (NSArray *)stringArrayForKey:(NSString *)defaultName {
    return nil; //TODO: Implement this
}

- (NSInteger)integerForKey:(NSString *)defaultName {
    return (NSInteger) nil; //TODO: Implement this
}

- (float)floatForKey:(NSString *)defaultName {
    return (float) 0.0; //TODO: Implement this
}

- (double)doubleForKey:(NSString *)defaultName {
    return (double) 0.0; //TODO: Implement this
}

- (BOOL)boolForKey:(NSString *)defaultName {
    return NO; //TODO: Implement this
}

- (NSURL *)URLForKey:(NSString *)defaultName {
    return nil; //TODO: Implement this
}


- (void)setInteger:(NSInteger)value forKey:(NSString *)defaultName {
    
}

- (void)setFloat:(float)value forKey:(NSString *)defaultName {
    
}

- (void)setDouble:(double)value forKey:(NSString *)defaultName {
    
}

- (void)setBool:(BOOL)value forKey:(NSString *)defaultName {
    
}

- (void)setURL:(NSURL *)url forKey:(NSString *)defaultName {
    
}


@end
