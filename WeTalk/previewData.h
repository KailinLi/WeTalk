//
//  previewData.h
//  WeTalk
//
//  Created by 李恺林 on 2016/12/11.
//  Copyright © 2016年 李恺林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface previewData : NSObject

@property (nonatomic, readwrite, copy) NSString *previewMessage;
@property (nonatomic, readwrite, copy) NSString *head;
@property (nonatomic, readwrite, copy) NSString *time;
@property (nonatomic, readwrite, copy) NSString *name;

- (void) setPreview :(NSString *) previewMessage :(NSString *) head :(NSString *) time : (NSString *) name;

@end
