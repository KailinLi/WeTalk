//
//  InputBarDelegate.h
//  WeTalk
//
//  Created by 李恺林 on 2016/12/4.
//  Copyright © 2016年 李恺林. All rights reserved.
//

#ifndef InputBarDelegate_h
#define InputBarDelegate_h

@protocol InputBarDelegate <NSObject, UITextFieldDelegate>


- (BOOL) textFieldShouldReturn:(UITextField *)textField;
- (void) draw:(CGRect)rect;

@end


#endif /* InputBarDelegate_h */
