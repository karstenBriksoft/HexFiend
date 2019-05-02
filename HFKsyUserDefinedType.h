//
//  HFKsyUserDefinedType.h
//  HexFiend_2
//
//  Created by Karsten Kusche on 02.05.19.
//  Copyright © 2019 ridiculous_fish. All rights reserved.
//

#import "HFKsyDocumentable.h"

NS_ASSUME_NONNULL_BEGIN

@class HFKsyAttribute, HFKsyInstance, HFKsyEnum;

@interface HFKsyUserDefinedType : HFKsyDocumentable

- (NSArray<HFKsyAttribute*>*)attributes;
- (HFKsyUserDefinedType*)typeNamed:(NSString*)string;
- (HFKsyEnum*)enumNamed:(NSString*)string;
- (HFKsyInstance*)instanceNamed:(NSString*)string;
@end

NS_ASSUME_NONNULL_END
