//
//  InputBar.h
//  WeTalk
//
//  Created by 李恺林 on 2016/12/3.
//  Copyright © 2016年 李恺林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputBarDelegate.h"

@interface InputBar : UIView <UITextFieldDelegate>

@property (nonatomic, strong, readwrite) UITextField *inputField;
@property (nonatomic, strong, readwrite) UIButton *emoji;

@property (nonatomic, weak) id <InputBarDelegate> delegate;

@end
