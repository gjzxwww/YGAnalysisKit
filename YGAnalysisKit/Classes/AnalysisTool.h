
//
//  Created by wyg on 2020/5/11.
//  Copyright © 2020 wyg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnalysisTool : NSObject

+(void)swizzingMethodForClass:(Class)classObj fromSeletor:(SEL)originalSelector toSelector:(SEL)swizzledSelector;

@end

NS_ASSUME_NONNULL_END
