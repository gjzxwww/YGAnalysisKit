//
//  AnalysisAction.h
//
//  Created by wyg on 2020/5/12.
//  Copyright © 2020 wyg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface AnalysisAction : NSObject
@property(nonatomic,copy)NSString *targetName;
@property(nonatomic,copy)NSString *actionName;
@property(nonatomic,assign)UIControlEvents events;

-(void)ControlAnalysis:(UIControl *)sender;
-(void)GestureAnalysisanalysis:(UIControl *)sender;

@end

NS_ASSUME_NONNULL_END
