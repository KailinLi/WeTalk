//
//  ChatData.h
//  WeTalk
//
//  Created by 李恺林 on 2016/12/3.
//  Copyright © 2016年 李恺林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatData : NSObject

@property (nonatomic, readwrite, copy) NSString *textMessage;
@property NSString *imageMessage;
@property BOOL isMine;
@property (nonatomic, strong, readwrite) NSDate *messageTime;

- (void) initText :(NSString *) chatString :(BOOL) ifIsMine;
- (void) initImage :(NSString *) chatUrl :(BOOL) ifIsMine;

@end
