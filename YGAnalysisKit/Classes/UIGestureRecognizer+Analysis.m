//
//  UIGestureRecognizer+Analysis.m
//
//  Created by wyg on 2020/5/11.
//  Copyright © 2020 wyg. All rights reserved.
//

#import "UIGestureRecognizer+Analysis.h"
#import "AnalysisTool.h"
#import <objc/runtime.h>
#import "AnalysisAction.h"
static char ActionKey;


@implementation UIGestureRecognizer (Analysis)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        SEL fromSel = @selector(initWithTarget:action:);
        SEL toSel = @selector(YGAnalysis_initWithTarget:action:);
        
        SEL originalSelector = @selector(addTarget:action:);
        SEL swizzingSelector = @selector(YGAnalysis_addTarget:action:);
        
        SEL originalSelector1 = @selector(removeTarget:action:);
        SEL swizzingSelector1 = @selector(YGAnalysis_removeTarget:action:);
        
        [AnalysisTool swizzingMethodForClass:[self class] fromSeletor:fromSel toSelector:toSel];
        [AnalysisTool swizzingMethodForClass:[self class] fromSeletor:originalSelector toSelector:swizzingSelector];
        [AnalysisTool swizzingMethodForClass:[self class] fromSeletor:originalSelector1 toSelector:swizzingSelector1];
        
       
    });
}

- (instancetype)YGAnalysis_initWithTarget:(nullable id)target action:(nullable SEL)action
{
    UIGestureRecognizer *selfGestureRecognizer = [self YGAnalysis_initWithTarget:target action:action];

    //这里还需要做一些判断，排除系统动作，或者根据后台配置表只给对应的动作做埋点
    if (!target || !action) {
        return selfGestureRecognizer;
    }

    if ([target isKindOfClass:[UIScrollView class]]) {
        return selfGestureRecognizer;
    }

     NSString *identifier = [NSString stringWithFormat:@"%@/%@/%@",[self class],NSStringFromClass([target class]), NSStringFromSelector(action)];
      
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"plist"];
    NSDictionary *dic = [[[[NSDictionary alloc]initWithContentsOfFile:plistPath] objectForKey:@"GESTURE"] objectForKey:identifier];
    
    if (dic)
    {
         AnalysisAction *myaction = [[AnalysisAction alloc] init];
           myaction.targetName = NSStringFromClass([target class]);
           myaction.actionName = NSStringFromSelector(action);
             
           objc_setAssociatedObject(self, &ActionKey, myaction, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
             
             // 添加动作，等点击按钮的时候会同时触发AnalysisAction的action:方法
           [self YGAnalysis_addTarget:myaction action:@selector(GestureAnalysisanalysis:)];
    }
   
    
    return selfGestureRecognizer;
}



-(void)YGAnalysis_addTarget:(id)target action:(SEL)action
{
    
     [self YGAnalysis_addTarget:target action:action];
    
    if (!target || !action) {
           return ;
       }

       if ([target isKindOfClass:[UIScrollView class]]) {
           return ;
       }
    
    
      NSString *identifier = [NSString stringWithFormat:@"%@/%@/%@/%@",[self.view class],[self class],NSStringFromClass([target class]), NSStringFromSelector(action)];
       
     NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"plist"];
     NSDictionary *dic = [[[[NSDictionary alloc]initWithContentsOfFile:plistPath] objectForKey:@"GESTURE"] objectForKey:identifier];
     
     if (dic)
     {
          AnalysisAction *myaction = [[AnalysisAction alloc] init];
            myaction.targetName = NSStringFromClass([target class]);
            myaction.actionName = NSStringFromSelector(action);

            
            objc_setAssociatedObject(self, &ActionKey, myaction, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            


            // 添加动作，等点击按钮的时候会同时触发AnalysisAction的action:方法
            [self YGAnalysis_addTarget:myaction action:@selector(GestureAnalysisanalysis:)];
     }
    
  
    
}

-(void)YGAnalysis_removeTarget:(id)target action:(SEL)action
{
    [self YGAnalysis_removeTarget:target action:action];
    
    if (!target || !action) {
             return ;
         }

         if ([target isKindOfClass:[UIScrollView class]]) {
             return ;
         }
   objc_setAssociatedObject(self, &ActionKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

@end
