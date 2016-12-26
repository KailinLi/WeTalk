//
//  ChatData.m
//  WeTalk
//
//  Created by 李恺林 on 2016/12/3.
//  Copyright © 2016年 李恺林. All rights reserved.
//

#import "ChatData.h"

@implementation ChatData

- (void) initText :(NSString *) chatString :(BOOL) ifIsMine {
    if (self) {
        self.textMessage = chatString;
        self.isMine = ifIsMine;
        self.imageMessage = @"";
        self.messageTime = [self setTheTime];
    }
}

- (void) initImage :(NSString *) chatUrl :(BOOL) ifIsMine {
    if (self) {
        self.textMessage = @"[图片]";
        self.isMine = ifIsMine;
        self.imageMessage = chatUrl;
        self.messageTime = [self setTheTime];
    }
}

- (NSDate *) setTheTime {
    NSDate *localDate = [[NSDate date]  dateByAddingTimeInterval: [[NSTimeZone systemTimeZone] secondsFromGMTForDate:[NSDate date]]];
    return localDate;
}

@end
