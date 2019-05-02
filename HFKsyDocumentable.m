//
//  HFKsyDocumentable.m
//  HexFiend_2
//
//  Created by Karsten Kusche on 02.05.19.
//  Copyright © 2019 ridiculous_fish. All rights reserved.
//

#import "HFKsyDocumentable.h"

@interface HFKsyDocumentable ()

@property (retain) NSString* identifier;
@property (retain) NSString* documentation;
@property (retain) NSArray<NSString*>* documentationReferences;

@end

@implementation HFKsyDocumentable

+ (NSMutableDictionary<NSString*,NSString*>*)attributesForKeyNames
{
    NSMutableDictionary<NSString*,NSString*>* dict = [super attributesForKeyNames];
    dict[@"id"] = @"identifier";
    dict[@"doc"] = @"documentation";
    dict[@"doc-ref"] = @"docRefString";
    return dict;
}

- (void)setDocRefString:(id)object
{
    if ([object isKindOfClass:[NSArray class]])
    {
        _documentationReferences = (NSArray*)object;
    }
    else if ([object isKindOfClass:[NSString class]])
    {
        _documentationReferences = @[ (NSString*)object ];
    }
}
@end
