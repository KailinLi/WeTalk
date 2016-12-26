//
//  ManageViewController.h
//  WeTalk
//
//  Created by 李恺林 on 2016/12/11.
//  Copyright © 2016年 李恺林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatViewDelegate.h"

@interface ManageViewController : UIViewController

@property (nonatomic, strong, readwrite) NSMutableArray *chatLogArray;
@property (nonatomic, strong) id <ChatViewDelegate> delegate;

@end
