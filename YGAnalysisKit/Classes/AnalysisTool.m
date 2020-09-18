//
//
//  Created by wyg on 2020/5/11.
//  Copyright © 2020 wyg. All rights reserved.
//

#import "AnalysisTool.h"
#import <objc/runtime.h>

@implementation AnalysisTool


+(void)swizzingMethodForClass:(Class)classObj fromSeletor:(SEL)originalSelector toSelector:(SEL)swizzledSelector
{
    Class class = classObj;
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    //第三版hook，安全交换
    //如果本类中有 originalSelector 方法，直接交换。
    //如果本类中没有 originalSelector 方法，添加父类的的方法到子类，然后再直接交换。
   BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    
   if (didAddMethod) {
       //添加成功后，重新获取子类的originalSelector
       originalMethod = class_getInstanceMethod(class, originalSelector);
   }
   
   //交换实现
    method_exchangeImplementations(originalMethod,swizzledMethod);
    
    
}


//取参可以根据后台配置表定位到相应控制器，以及参数，仅供参考

+(id)captureVarforInstance:(id)instance varName:(NSString *)varName
{
    id value = [instance valueForKey:varName];

    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([instance class], &count);

    if (!value)
    {
        NSMutableArray * varNameArray = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < count; i++) {
            objc_property_t property = properties[i];
            NSString* propertyAttributes = [NSString stringWithUTF8String:property_getAttributes(property)];
            NSArray* splitPropertyAttributes = [propertyAttributes componentsSeparatedByString:@"\""];
            if (splitPropertyAttributes.count < 2) {
                continue;
            }
            NSString * className = [splitPropertyAttributes objectAtIndex:1];
            Class cls = NSClassFromString(className);
            NSBundle *bundle2 = [NSBundle bundleForClass:cls];
            if (bundle2 == [NSBundle mainBundle]) {
//                NSLog(@"自定义的类----- %@", className);
                const char * name = property_getName(property);
                NSString * varname = [[NSString alloc] initWithCString:name encoding:NSUTF8StringEncoding];
                [varNameArray addObject:varname];
            } else {
//                NSLog(@"系统的类");
            }
        }

        for (NSString * name in varNameArray) {
            id newValue = [instance valueForKey:name];
            if (newValue) {
                value = [newValue valueForKey:varName];
                if (value) {
                    return value;
                }else{
                    value = [[self class] captureVarforInstance:newValue varName:varName];
                }
            }
        }
    }
    return value;
}

+(id)captureVarforInstance:(id)instance withPara:(NSDictionary *)para
{
    NSString * properyName = para[@"propertyName"];
    NSString * propertyPath = para[@"propertyPath"];
    if (propertyPath.length > 0) {
        NSArray * keysArray = [propertyPath componentsSeparatedByString:@"/"];

        return [[self class] captureVarforInstance:instance withKeys:keysArray];
    }
    return [[self class] captureVarforInstance:instance varName:properyName];
}

+(id)captureVarforInstance:(id)instance withKeys:(NSArray *)keyArray
{
    id result = [instance valueForKey:keyArray[0]];

    if (keyArray.count > 1 && result) {
        int i = 1;
        while (i < keyArray.count && result) {
            result = [result valueForKey:keyArray[i]];
            i++;
        }
    }
    return result;
}

//后台配置表
//{
//    "ACTION": {
//        "ViewController/jumpSecond": {
//            "userDefined": {
//                "eventid": "201803074|93",
//                "target": "",
//                "pageid": "234",
//                "pagename": "button点击，跳转至下一个页面"
//            },
//            "pagePara": {
//                "testKey9": {
//                    "propertyName": "testPara",
//                    "propertyPath":"",
//                    "containIn": "0"
//                }
//            }
//        }
//    },
//
//    "PAGEPV": {
//        "ViewController": {
//            "userDefined": {
//                "pageid": "234",
//                "pagename": "XXX 页面展示了"
//            },
//            "pagePara": {
//                "testKey10": {
//                    "propertyName": "testPara",
//                    "propertyPath":"",
//                    "containIn": "0"
//                }
//            }
//        }
//    },
//    "TABLEVIEW": {
//        "ViewController/UITableView/0":{
//            "userDefined": {
//                "eventid": "201803074|93",
//                "target": "",
//                "pageid": "234",
//                "pagename": "tableview 被点击"
//            },
//            "pagePara": {
//                "user_grade": {
//                    "propertyName": "grade",
//                    "propertyPath":"",
//                    "containIn": "1"
//                }
//            }
//        }
//    },
//
//    "GESTURE": {
//        "ViewController/controllerclicked:":{
//            "userDefined": {
//                "eventid": "201803074|93",
//                "target": "",
//                "pageid": "123",
//                "pagename": "手势响应"
//            },
//            "pagePara": {
//                "testKey1": {
//                    "propertyName": "testPara",
//                    "propertyPath":"",
//                    "containIn": "0"
//                }
//            }
//        }
//    }
//}


@end
