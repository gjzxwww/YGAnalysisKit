#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "AnalysisAction.h"
#import "AnalysisTool.h"
#import "UIControl+Analysis.h"
#import "UIGestureRecognizer+Analysis.h"
#import "UITableView+Analysis.h"
#import "UIViewController+Analysis.h"

FOUNDATION_EXPORT double YGAnalysisKitVersionNumber;
FOUNDATION_EXPORT const unsigned char YGAnalysisKitVersionString[];

