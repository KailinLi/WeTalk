//
//  ChatTableViewCell.h
//  WeTalk
//
//  Created by 李恺林 on 2016/12/11.
//  Copyright © 2016年 李恺林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "previewData.h"

@interface ChatTableViewCell : UITableViewCell

@property (nonatomic, strong, readwrite) previewData *preview;

- (void) load;

@end
