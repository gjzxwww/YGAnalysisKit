//
//  UIViewController+Analysis.m
//
//  Created by wyg on 2020/5/11.
//  Copyright © 2020 wyg. All rights reserved.
//

#import "UIViewController+Analysis.h"
#import "AnalysisTool.h"

@implementation UIViewController (Analysis)
+(void)load
{
    static dispatch_once_t onceToken;
       dispatch_once(&onceToken, ^{

           SEL fromSel = @selector(viewDidLoad);
           SEL toSel = @selector(YGAnalysis_viewDidLoad);
           
           SEL fromSel1 = @selector(viewWillAppear:);
           SEL toSel1 = @selector(YGAnalysis_viewWillAppear);
           
           SEL fromSel2= @selector(viewWillDisappear:);
           SEL toSel2 = @selector(YGAnalysis_viewWillDisappear);
           
           [AnalysisTool swizzingMethodForClass:[self class] fromSeletor:fromSel toSelector:toSel];
           [AnalysisTool swizzingMethodForClass:[self class] fromSeletor:fromSel1 toSelector:toSel1];
           [AnalysisTool swizzingMethodForClass:[self class] fromSeletor:fromSel2 toSelector:toSel2];
       });
    
}

-(void)YGAnalysis_viewDidLoad
{
    [self YGAnalysis_viewDidLoad];

  NSString *identifier = [NSString stringWithFormat:@"%@", [self class]];
   
   NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"plist"];
   NSDictionary *dic = [[[[NSDictionary alloc]initWithContentsOfFile:plistPath] objectForKey:@"PAGEVC"] objectForKey:identifier];
   
   if (dic)
   {
//       NSLog(@"viewDidLoad埋点成功--事件ID===%@",identifier);
   }
}

-(void)YGAnalysis_viewWillAppear
{
    [self YGAnalysis_viewWillAppear];
    
    NSString *identifier = [NSString stringWithFormat:@"%@", [self class]];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"plist"];
    NSDictionary *dic = [[[[NSDictionary alloc]initWithContentsOfFile:plistPath] objectForKey:@"PAGEVC"] objectForKey:identifier];
    
    if (dic)
    {
        NSLog(@"viewWillAppear埋点成功--事件ID===%@",identifier);
    }

}

-(void)YGAnalysis_viewWillDisappear
{
    [self YGAnalysis_viewWillDisappear];
    
    NSString *identifier = [NSString stringWithFormat:@"%@", [self class]];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"plist"];
    NSDictionary *dic = [[[[NSDictionary alloc]initWithContentsOfFile:plistPath] objectForKey:@"PAGEVC"] objectForKey:identifier];
    
    if (dic)
    {
        NSLog(@"viewWillDisappear埋点成功--事件ID===%@",identifier);
    }
    
}


@end
