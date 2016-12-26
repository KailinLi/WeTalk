//
//  ChatViewController.h
//  WeTalk
//
//  Created by 李恺林 on 2016/12/3.
//  Copyright © 2016年 李恺林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatViewDelegate.h"

@interface ChatViewController : UIViewController


@property (nonatomic, strong, readwrite) NSMutableArray *dataArray;

@property (nonatomic, strong, readwrite) NSString *UserID;

@property (nonatomic, strong, readwrite) id <ChatViewDelegate> delegate;

@end
