//
//  previewData.m
//  WeTalk
//
//  Created by 李恺林 on 2016/12/11.
//  Copyright © 2016年 李恺林. All rights reserved.
//

#import "previewData.h"

@implementation previewData

- (void) setPreview :(NSString *) previewMessage :(NSString *) head :(NSString *) time : (NSString *) name {
    if (self) {
        self.previewMessage = previewMessage;
        self.head = head;
        self.time = time;
        self.name = name;
    }
}

@end
