//
//  UITableView+Analysis.m
//
//  Created by wyg on 2020/5/11.
//  Copyright © 2020 wyg. All rights reserved.
//

#import "UITableView+Analysis.h"
#import "AnalysisTool.h"
#import <objc/runtime.h>

@implementation UITableView (Analysis)

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        SEL originalAppearSelector = @selector(setDelegate:);
        SEL swizzingAppearSelector = @selector(YGAnalysis_setDelegate:);
        [AnalysisTool swizzingMethodForClass:[self class] fromSeletor:originalAppearSelector toSelector:swizzingAppearSelector];
    });
}

-(void)YGAnalysis_setDelegate:(id<UITableViewDelegate>)delegate
{
    [self YGAnalysis_setDelegate:delegate];

    SEL sel = @selector(tableView:didSelectRowAtIndexPath:);
    SEL sel_ = @selector(YGAnalysis_tableView:didSelectRowAtIndexPath:);

    //因为 tableView:didSelectRowAtIndexPath:方法是optional的，所以没有实现的时候直接return
    if (![self isContainSel:sel inClass:[delegate class]]) {

        return;
    }
    //给tableview的delegate添加自己实现的didSelectRowAtIndexPath:方法
    BOOL addsuccess = class_addMethod([delegate class],
                                      sel_,
                                      method_getImplementation(class_getInstanceMethod([self class], @selector(YGAnalysis_tableView:didSelectRowAtIndexPath:))),
                                      method_getTypeEncoding(class_getInstanceMethod([self class], @selector(YGAnalysis_tableView:didSelectRowAtIndexPath:))));

    //如果添加成功了就直接交换实现， 如果没有添加成功，说明之前已经添加过并交换过实现了
    if (addsuccess) {
        
        Method selMethod = class_getInstanceMethod([delegate class], sel);
        Method sel_Method = class_getInstanceMethod([delegate class], sel_);
        method_exchangeImplementations(selMethod, sel_Method);
    }
}

//判断页面是否实现了某个sel
- (BOOL)isContainSel:(SEL)sel inClass:(Class)class {
    unsigned int count;

    Method *methodList = class_copyMethodList(class,&count);
    for (int i = 0; i < count; i++) {
        Method method = methodList[i];
        NSString *tempMethodString = [NSString stringWithUTF8String:sel_getName(method_getName(method))];
        if ([tempMethodString isEqualToString:NSStringFromSelector(sel)]) {
            return YES;
        }
    }
    return NO;
}

// 由于我们交换了方法， 所以在tableview的 didselected 被调用的时候， 实质调用的是以下方法：
-(void)YGAnalysis_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    SEL sel = @selector(YGAnalysis_tableView:didSelectRowAtIndexPath:);
    if ([self respondsToSelector:sel]) {
        
        //c函数直接调用
//        IMP imp = [self methodForSelector:sel];
//        void (*func)(id, SEL,id,id) = (void *)imp;
//        func(self, sel,tableView,indexPath);
        
        //通过NSInvocation调用
//        NSMethodSignature *signature = [[tableView.delegate class] instanceMethodSignatureForSelector:sel];
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
//        invocation.target = tableView.delegate;
//        invocation.selector = sel;
//        [invocation setArgument:&tableView atIndex:2];
//        [invocation setArgument:&indexPath atIndex:3];
//        [invocation invoke];
        
         //方法实现虽然写在tableview的分类中，但是方法调用者已经变成delegate，也就在这个方法里self不是tableview而是delegate，所以可以直接这么写
        [self YGAnalysis_tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    
    
     NSString * identifier = [NSString stringWithFormat:@"%@/%@/%ld", [self class],[tableView class], (long)tableView.tag];
      
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"plist"];
    NSDictionary *dic = [[[[NSDictionary alloc]initWithContentsOfFile:plistPath] objectForKey:@"TABLEVIEW"] objectForKey:identifier];
    
    if (dic)
    {
        NSLog(@"tableView埋点成功--事件ID ==== %@/%ld", identifier,indexPath.row);
    }
   


           
}

@end

