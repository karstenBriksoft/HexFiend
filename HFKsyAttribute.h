//
//  HFKsyAttribute.h
//  HexFiend_2
//
//  Created by Karsten Kusche on 02.05.19.
//  Copyright © 2019 ridiculous_fish. All rights reserved.
//

#import "HFKsyDocumentable.h"

NS_ASSUME_NONNULL_BEGIN

@interface HFKsyAttribute : HFKsyDocumentable

- (id)contents;
- (NSString*)type;

@end

NS_ASSUME_NONNULL_END
