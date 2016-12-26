//
//  TransparentView.m
//  WeTalk
//
//  Created by 李恺林 on 2016/12/11.
//  Copyright © 2016年 李恺林. All rights reserved.
//

#import "TransparentView.h"
#import "UIView+Size.h"

@interface TransparentView ()<UIScrollViewDelegate>

@property (nonatomic, assign) CGFloat initOffsetY;
@property (nonatomic, assign) CGRect initStretchViewFrame;
@property (nonatomic, assign) CGFloat initSelfHeight;
@property (nonatomic, assign) CGFloat initContentHeight;

@end
@implementation TransparentView

+ (instancetype)dropHeaderViewWithFrame:(CGRect)frame contentView:(UIView *)contentView stretchView:(UIView *)stretchView
{
    TransparentView *dropHeaderView = [[TransparentView alloc] init];
    dropHeaderView.frame = frame;
    dropHeaderView.contentView = contentView;
    dropHeaderView.stretchView = stretchView;
    
    stretchView.contentMode = UIViewContentModeScaleAspectFill;
    stretchView.clipsToBounds = YES;
    return dropHeaderView;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self.superview removeObserver:self forKeyPath:@"contentOffset"];
    if (newSuperview != nil) {
        [newSuperview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        UIScrollView *scrollView = (UIScrollView *)newSuperview;
        
        self.initOffsetY = scrollView.contentOffset.y;
        self.initStretchViewFrame = self.stretchView.frame;
        self.initSelfHeight = self.height;
        self.initContentHeight = self.contentView.height;
    }
    
}

- (void)setContentView:(UIView *)contentView
{
    _contentView = contentView;
    [self addSubview:contentView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGFloat offsetY = [change[@"new"] CGPointValue].y - self.initOffsetY;
    
    if (offsetY < - 200) {
        [self.delegate callHUD];
    }

    if (offsetY > 0) {
        
        self.stretchView.y = self.initStretchViewFrame.origin.y + offsetY;
        self.stretchView.height = self.initStretchViewFrame.size.height - offsetY;
        
    }else{
        
        
        self.stretchView.y = self.initStretchViewFrame.origin.y + offsetY;
        self.stretchView.height = self.initStretchViewFrame.size.height - offsetY;
        
    }
    
}


@end
