//
//  AppDelegate.h
//  WeTalk
//
//  Created by 李恺林 on 2016/12/1.
//  Copyright © 2016年 李恺林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

