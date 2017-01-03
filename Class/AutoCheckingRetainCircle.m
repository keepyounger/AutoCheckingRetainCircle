//
//  AutoCheckingRetainCircle.m
//  AutoCheckingRetainCircle
//
//  Created by lixy on 2016/12/29.
//  Copyright © 2016年 lixy. All rights reserved.
//

#import "AutoCheckingRetainCircle.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "Aspects.h"

@interface UIViewController (AutoCheckCircleRetain)
#ifdef DEBUG
@property (nonatomic, assign) BOOL xy_exsit;
#endif
@end

@implementation UIViewController (AutoCheckCircleRetain)
#ifdef DEBUG
- (void)setXy_exsit:(BOOL)xy_exsit
{
    objc_setAssociatedObject(self, @selector(xy_exsit), @(xy_exsit), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)xy_exsit
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)xy_startCheck
{
    __weak UIViewController *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        sleep(1);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!weakSelf.parentViewController && !weakSelf.presentingViewController && weakSelf!=[UIApplication sharedApplication].delegate.window.rootViewController) {
                if (weakSelf.xy_exsit) {
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        sleep(3);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if (weakSelf.xy_exsit) {
                                UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"⚠️有vc可能没有正确释放" message:NSStringFromClass([weakSelf class]) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                [view show];
                                NSLog(@"【AutoCheckingRetainCircle】【⚠️有vc可能没有正确释放】\nvc=%@",weakSelf);

                            }
                            
                        });
                    });
                    
                }
            } else {
                [weakSelf xy_startCheck];
            }
            
        });
    });
}
#endif
@end

static AutoCheckingRetainCircle *m_instance = nil;

@implementation AutoCheckingRetainCircle

#ifdef DEBUG
+ (void)load
{
    [[self sharedInstance] startCheck];
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //只在debug模式运行
        NSLog(@"【AutoCheckingRetainCircle】只在DEBUG模式运行，请放心使用，此提示只提示一次");
        m_instance = [[AutoCheckingRetainCircle alloc] init];
    });
    return m_instance;
}

- (void)startCheck
{
    [UIViewController aspect_hookSelector:@selector(viewDidLoad) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info){
        UIViewController *vc = [info instance];
        //排除系统的AlertView等VC
        NSBundle *mainB = [NSBundle bundleForClass:[vc class]];
        if (mainB == [NSBundle mainBundle]) {
            vc.xy_exsit = YES;
            [vc xy_startCheck];
        }
        
    } error:nil];
    
    [UIViewController aspect_hookSelector:NSSelectorFromString(@"dealloc") withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> info){
        UIViewController *vc = [info instance];
        //排除系统的AlertView等VC
        NSBundle *mainB = [NSBundle bundleForClass:[vc class]];
        if (mainB == [NSBundle mainBundle]) {
            vc.xy_exsit = NO;
        }
    } error:nil];
}
#endif
@end
