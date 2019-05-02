//
//  HFKsyUserDefinedType.m
//  HexFiend_2
//
//  Created by Karsten Kusche on 02.05.19.
//  Copyright © 2019 ridiculous_fish. All rights reserved.
//

#import "HFKsyUserDefinedType.h"
#import "HFKsyEnum.h"
#import "HFKsyInstance.h"
#import "HFKsyAttribute.h"
#import "HFKsyMeta.h"
#import "HFYamlDecoder.h"

@interface HFKsyUserDefinedType ()

@property (retain) NSString* identifier;
@property (retain) HFKsyMeta* meta;
@property (retain) NSArray<HFKsyAttribute*>* attributes;
@property (retain) NSDictionary<NSString*,HFKsyUserDefinedType*>* types;
@property (retain) NSDictionary<NSString*,HFKsyInstance*>* instances;
@property (retain) NSDictionary<NSString*,HFKsyEnum*>* enums;

@end

@implementation HFKsyUserDefinedType
+ (NSMutableDictionary<NSString*,NSString*>*)attributesForKeyNames
{
    NSMutableDictionary<NSString*,NSString*>* dict = [super attributesForKeyNames];
    // id is stored as part of meta and is not part of the dictionary directly
    [dict removeObjectForKey:@"id"];
    return dict;
}

- (NSArray*)objectsOfType:(Class)aClass from:(NSArray*)array
{
    NSMutableArray* objects = [NSMutableArray array];
    for (NSDictionary* each in array)
    {
        id object = [aClass fromDictionary: each];
        if (object != nil)
        {
            [objects addObject:object];
        }
    }
    return objects;
}

- (NSDictionary*)namedObjectsOfType:(Class)aClass from:(NSDictionary*)dict
{
    NSMutableDictionary* objects = [NSMutableDictionary dictionary];
    for (NSString* key in dict.allKeys)
    {
        NSDictionary* value = dict[key];
        id object = [aClass fromDictionary: value];
        if (object != nil)
        {
            [object setValue:key forKeyPath:@"identifier"];
            [objects setObject:object forKey:key];
        }
    }
    return objects;
}

- (instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self != nil)
    {
        _meta = [HFKsyMeta fromDictionary:dictionary[@"meta"]];
        _attributes = [self objectsOfType:[HFKsyAttribute class] from: dictionary[@"seq"]];
        _types = [self namedObjectsOfType:[self class] from: dictionary[@"types"]];
        _instances = [self namedObjectsOfType:[HFKsyInstance class] from: dictionary[@"instances"]];
        _enums = [self namedObjectsOfType:[HFKsyEnum class] from: dictionary[@"enums"]];
        if (_meta != nil)
        {
            _identifier = _meta.identifier;
        }
    }
    return self;
}

- (HFKsyUserDefinedType*)typeNamed:(NSString*)string
{
    return _types[string];
}

- (HFKsyEnum*)enumNamed:(NSString*)string
{
    return _enums[string];
}

- (HFKsyInstance*)instanceNamed:(NSString*)string
{
    return _instances[string];
}

+ (void)load
{
    @autoreleasepool {
        NSString* source = [[NSBundle mainBundle] pathForResource:@"yaml" ofType:@"yaml"];
        NSError* error = nil;
        NSDictionary* dict = [HFYamlDecoder dictionaryFromData:[NSData dataWithContentsOfFile:source] error:&error];
        if (dict)
        {
            id type = [self fromDictionary:dict];
            NSLog(@"res: %@ - %@",type,error);

        }
    }
}

@end
