//
//  AnalysisAction.m
//
//  Created by wyg on 2020/5/12.
//  Copyright © 2020 wyg. All rights reserved.
//

#import "AnalysisAction.h"

@implementation AnalysisAction

-(void)dealloc
{
    NSLog(@"AnalysisAction--dealloc");
}

- (void)ControlAnalysis:(UIControl *)sender
{

    
    //这里做存库或上报操作
    NSString *event_code = [NSString stringWithFormat:@"%@/%@/%ld", self.targetName, self.actionName,sender.tag];
    NSLog(@"点击埋点成功--事件ID===%@",event_code);
   
}


- (void)GestureAnalysisanalysis:(UIGestureRecognizer *)sender
{

    //这里做存库或上报操作
    NSString *event_code = [NSString stringWithFormat:@"%@/%@/%@",[sender class],self.targetName, self.actionName];
    NSLog(@"手势埋点成功--事件ID===%@",event_code);
   
}
@end
