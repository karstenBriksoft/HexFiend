//
//  HFKaitaiTemplateController.m
//  HexFiend_2
//
//  Created by Karsten Kusche on 02.05.19.
//  Copyright © 2019 ridiculous_fish. All rights reserved.
//

#import "HFKaitaiTemplateController.h"
#import "HFYamlDecoder.h"
#import "HFKsyUserDefinedType.h"
#import "HFKsyInstance.h"
#import "HFKsyEnum.h"
#import "HFEncodingManager.h"


@interface NSString (HFKaitaiProcessing)

- (BOOL)ksyProcessUsing:(HFKaitaiTemplateController*)controller named:(NSString*)name;

@end

@interface NSNumber (HFKaitaiProcessing)

- (BOOL)ksyProcessUsing:(HFKaitaiTemplateController*)controller named:(NSString*)name;

@end

@interface NSArray (HFKaitaiProcessing)

- (BOOL)ksyProcessUsing:(HFKaitaiTemplateController*)controller named:(NSString*)name;

@end

@interface HFKaitaiTemplateController ()
@property (retain) HFKsyUserDefinedType* rootType;
@end
@implementation HFKaitaiTemplateController

- (NSString *)evaluateScript:(NSString *)path {
    NSError* error = nil;
    NSDictionary* dict = [HFYamlDecoder dictionaryFromData:[NSData dataWithContentsOfFile:path] error: &error];
    if (dict == nil)
    {
        return error.localizedDescription;
    }
    _rootType = [HFKsyUserDefinedType fromDictionary:dict];
    [self processType: _rootType];
    return nil;
}

- (BOOL)processType:(HFKsyUserDefinedType*)type
{
    [self beginSectionWithLabel:type.identifier];
    for (HFKsyAttribute* attribute in type.attributes)
    {
        if ([self processAttribute: attribute] == NO)
        {
            [self endSection];
            return NO;
        }
    }
    [self endSection];
    return YES;
}

- (BOOL)processAttribute:(HFKsyAttribute*)attribute
{
    [self beginSectionWithLabel:attribute.identifier];
    if (attribute.contents)
    {
        if (! [attribute.contents ksyProcessUsing: self named: attribute.identifier])
        {
            [self endSection];
            return NO;
        }
    }
    else if (attribute.type != nil)
    {
        HFKsyUserDefinedType* customType = [_rootType typeNamed: attribute.type];
        if (customType != nil)
        {
            BOOL result = [self processType:customType];
            [self endSection];
            return result;
        }
        else
        {
            BOOL result = [self processPrimitiveType: attribute.type];
            [self endSection];
            return result;
        }
    }
    else
    {
        HFKsyInstance* instance = [_rootType instanceNamed:attribute.identifier];
        if (instance != nil)
        {
            BOOL result = [self processInstance: instance];
            [self endSection];
            return result;
        }
    }
    [self endSection];
    return YES;
}

- (BOOL)processInstance:(HFKsyInstance*)instance
{
    [self beginSectionWithLabel:instance.identifier];
    
    [self endSection];
    return YES;
}
- (BOOL)processPrimitiveType:(NSString*)type
{
    if ([type isEqual:@"u1"])
    {
        uint8_t value = 0;
        return [self readUInt8:&value forLabel:type asHex:YES];
    }
    if ([type isEqual:@"u2le"] || [type isEqual:@"u2"])
    {
        uint16_t value = 0;
        return [self readUInt16:&value forLabel:type asHex:YES];
    }
    if ([type isEqual:@"u2be"])
    {
        uint16_t value = 0;
        self.endian = HFEndianBig;
        BOOL res = [self readUInt16:&value forLabel:type asHex:YES];
        self.endian = HFEndianLittle;
        return res;
    }
    if ([type isEqual:@"u4le"] || [type isEqual:@"u4"])
    {
        uint32_t value = 0;
        return [self readUInt32:&value forLabel:type asHex:YES];
    }
    if ([type isEqual:@"u4be"])
    {
        uint32_t value = 0;
        self.endian = HFEndianBig;
        BOOL res = [self readUInt32:&value forLabel:type asHex:YES];
        self.endian = HFEndianLittle;
        return res;
    }
    if ([type isEqual:@"u8le"] || [type isEqual:@"u8"])
    {
        uint64_t value = 0;
        return [self readUInt64:&value forLabel:type asHex:YES];
    }
    if ([type isEqual:@"u8be"])
    {
        uint64_t value = 0;
        self.endian = HFEndianBig;
        BOOL res = [self readUInt64:&value forLabel:type asHex:YES];
        self.endian = HFEndianLittle;
        return res;
    }
    if ([type isEqual:@"s1"])
    {
        int8_t value = 0;
        return [self readInt8:&value forLabel:type];
    }
    if ([type isEqual:@"s2le"] || [type isEqual:@"s2"])
    {
        int16_t value = 0;
        return [self readInt16:&value forLabel:type];
    }
    if ([type isEqual:@"s2be"])
    {
        int16_t value = 0;
        self.endian = HFEndianBig;
        BOOL res = [self readInt16:&value forLabel:type];
        self.endian = HFEndianLittle;
        return res;
    }
    if ([type isEqual:@"s4le"] || [type isEqual:@"s4"])
    {
        int32_t value = 0;
        return [self readInt32:&value forLabel:type];
    }
    if ([type isEqual:@"s4be"])
    {
        int32_t value = 0;
        self.endian = HFEndianBig;
        BOOL res = [self readInt32:&value forLabel:type];
        self.endian = HFEndianLittle;
        return res;
    }
    if ([type isEqual:@"s8le"] || [type isEqual:@"s8"])
    {
        int64_t value = 0;
        return [self readInt64:&value forLabel:type];
    }
    if ([type isEqual:@"s8be"])
    {
        int64_t value = 0;
        self.endian = HFEndianBig;
        BOOL res = [self readInt64:&value forLabel:type];
        self.endian = HFEndianLittle;
        return res;
    }
    return NO;
}
@end

@implementation NSString (HFKaitaiProcessing)

- (BOOL)ksyProcessUsing:(HFKaitaiTemplateController *)controller named:(NSString*)name
{
    if (self.length > 2 && self.length <= 4 && [self characterAtIndex:0] == '0' && [self characterAtIndex:1] == 'x')
    {
        int num = [self characterAtIndex:2] - '0';
        if (self.length > 3)
        {
            num *= 16;
            num += [self characterAtIndex:3] - '0';
            return [@(num) ksyProcessUsing:controller named:name];
        }
    }
    HFStringEncoding* encoding = [[HFEncodingManager shared] systemEncoding:NSUTF8StringEncoding];
    NSString* string = [controller readStringDataForSize:self.length encoding:encoding forLabel:name];
    return string != nil && [self isEqual:string];
}
@end

@implementation NSArray (HFKaitaiProcessing)

- (BOOL)ksyProcessUsing:(HFKaitaiTemplateController *)controller named:(NSString*)name
{
    for (id each in self)
    {
        if (! [each ksyProcessUsing:controller named:name])
        {
            return NO;
        }
    }
    return YES;
}
@end

@implementation NSNumber (HFKaitaiProcessing)

- (BOOL)ksyProcessUsing:(HFKaitaiTemplateController *)controller named:(NSString*)name
{
    uint8_t num = 0;
    if ([controller readUInt8:&num forLabel:name asHex:YES] == NO) return NO;
    return num == self.intValue;
}

@end
