//
//  TransparentView.h
//  WeTalk
//
//  Created by 李恺林 on 2016/12/11.
//  Copyright © 2016年 李恺林. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol transparentDelegate <NSObject>

- (void) callHUD;

@end

@interface TransparentView : UIView

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *stretchView;
+ (instancetype)dropHeaderViewWithFrame:(CGRect)frame contentView:(UIView *)contentView stretchView:(UIView *)stretchView;

@property (nonatomic, strong, readwrite) id <transparentDelegate> delegate;

@end
