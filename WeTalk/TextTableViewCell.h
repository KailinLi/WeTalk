//
//  TextTableViewCell.h
//  WeTalk
//
//  Created by 李恺林 on 2016/12/3.
//  Copyright © 2016年 李恺林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatData.h"

@interface TextTableViewCell : UITableViewCell

@property (nonatomic, strong, readwrite) ChatData *message;
@property (nonatomic, strong, readwrite) NSString *UserID;
@property (nonatomic, readwrite) CGSize cellSize;

- (void) load;

@end
