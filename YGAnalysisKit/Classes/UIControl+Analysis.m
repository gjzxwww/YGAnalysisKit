//
//  UIControl+Analysis.m
//
//  Created by wyg on 2020/5/11.
//  Copyright © 2020 wyg. All rights reserved.
//

#import "UIControl+Analysis.h"
#import "AnalysisTool.h"
#import "AnalysisAction.h"
#import <objc/runtime.h>

static char ActionKey;

@implementation UIControl (Analysis)

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        SEL originalSelector = @selector(sendAction:to:forEvent:);
//        SEL swizzingSelector = @selector(yg_sendAction:to:forEvent:);
//        [AnalysisTool swizzingMethodForClass:[self class] fromSeletor:originalSelector toSelector:swizzingSelector];
        
        SEL originalSelector = @selector(addTarget:action:forControlEvents:);
        SEL swizzingSelector = @selector(YGAnalysis_addTarget:action:forControlEvents:);
        
        SEL originalSelector1 = @selector(removeTarget:action:forControlEvents:);
        SEL swizzingSelector1 = @selector(YGAnalysis_removeTarget:action:forControlEvents:);
        
        [AnalysisTool swizzingMethodForClass:[self class] fromSeletor:originalSelector toSelector:swizzingSelector];
        [AnalysisTool swizzingMethodForClass:[self class] fromSeletor:originalSelector1 toSelector:swizzingSelector1];
    });
}

//老方法会导致问题
//-(void)yg_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
//{
//    [self yg_sendAction:action to:target forEvent:event];
//
//    NSString * identifier = [NSString stringWithFormat:@"%@/%@/%ld", [target class], NSStringFromSelector(action),self.tag];
////    NSDictionary * dic = [[[DataContainer dataInstance].data objectForKey:@"ACTION"] objectForKey:identifier];
////    if (dic) {
////
////        NSString * eventid = dic[@"userDefined"][@"eventid"];
////        NSString * targetname = dic[@"userDefined"][@"target"];
////        NSString * pageid = dic[@"userDefined"][@"pageid"];
////        NSString * pagename = dic[@"userDefined"][@"pagename"];
////        NSDictionary * pagePara = dic[@"pagePara"];
////        __block NSMutableDictionary * uploadDic = [NSMutableDictionary dictionaryWithCapacity:0];
////        [pagePara enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
////
////            id value = [CaptureTool captureVarforInstance:target withPara:obj];
////            if (value && key) {
////                [uploadDic setObject:value forKey:key];
////            }
////        }];
////
////        NSLog(@" \n  唯一标识符为 : %@, \n event id === %@,\n  target === %@, \n  pageid === %@,\n  pagename === %@,\n pagepara === %@ \n", identifier, eventid, targetname, pageid, pagename, uploadDic);
////    }
//    
//    NSLog(@" \n  唯一标识符为 : %@", identifier);
//}



-(void)YGAnalysis_addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    
    [self YGAnalysis_addTarget:target action:action forControlEvents:controlEvents];
    
    
    NSString *identifier = [NSString stringWithFormat:@"%@/%@/%ld", NSStringFromClass([target class]), NSStringFromSelector(action),self.tag];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"plist"];
    NSDictionary *dic = [[[[NSDictionary alloc]initWithContentsOfFile:plistPath] objectForKey:@"ACTION"] objectForKey:identifier];
    
    if (dic) {
    
        AnalysisAction *myaction = [[AnalysisAction alloc] init];
        myaction.targetName = NSStringFromClass([target class]);
        myaction.actionName = NSStringFromSelector(action);
        myaction.events = controlEvents;
        
        objc_setAssociatedObject(self, &ActionKey, myaction, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        // 添加动作，等点击按钮的时候会同时触发AnalysisAction的action:方法
        [self YGAnalysis_addTarget:myaction action:@selector(ControlAnalysis:) forControlEvents:controlEvents];
    }
    
}

-(void)YGAnalysis_removeTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self YGAnalysis_removeTarget:target action:action forControlEvents:controlEvents];
    objc_setAssociatedObject(self, &ActionKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

@end
