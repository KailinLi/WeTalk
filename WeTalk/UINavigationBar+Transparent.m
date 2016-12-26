//
//  UINavigationBar+Transparent.m
//  WeTalk
//
//  Created by 李恺林 on 2016/12/11.
//  Copyright © 2016年 李恺林. All rights reserved.
//

#import "UINavigationBar+Transparent.h"
#import <objc/runtime.h>

@implementation UINavigationBar (Transparent)

static const void *KCustomViewKey = @"KCustomViewKey";

- (void)js_setBackgroundColor:(UIColor *)backgroundColor
{
    if (!self.customView) {
        [self setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [self setShadowImage:[[UIImage alloc] init]];
        self.customView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 64)];
        self.customView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.customView];
    }
    self.customView.backgroundColor = backgroundColor;
    [self sendSubviewToBack:self.customView];
}

- (void)js_reset
{
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:nil];
    
    [self.customView removeFromSuperview];
    self.customView = nil;
}


#pragma mark - get和set方法
- (UIView *)customView
{
    return objc_getAssociatedObject(self, &KCustomViewKey);
}

- (void)setCustomView:(UIView *)customView
{
    objc_setAssociatedObject(self, &KCustomViewKey, customView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
