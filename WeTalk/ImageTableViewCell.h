//
//  ImageTableViewCell.h
//  WeTalk
//
//  Created by 李恺林 on 2016/12/4.
//  Copyright © 2016年 李恺林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatData.h"

@protocol imageWilShow <NSObject>

- (void) closeKeyBoard;

@end

@interface ImageTableViewCell : UITableViewCell

@property (nonatomic, strong, readwrite) ChatData *message;
@property (nonatomic, strong, readwrite) NSString *UserID;
@property (nonatomic, readwrite) CGSize cellSize;

- (void) load;
- (UIImage *)resizeImage:(UIImage *)sourceImage toMaxWidthAndHeight:(CGFloat)maxValue;

@property (nonatomic, strong, readwrite) id <imageWilShow> delegate;

@end
