//
//  ChatViewDelegate.h
//  WeTalk
//
//  Created by 李恺林 on 2016/12/11.
//  Copyright © 2016年 李恺林. All rights reserved.
//

#ifndef ChatViewDelegate_h
#define ChatViewDelegate_h


@protocol ChatViewDelegate <NSObject>

- (void) sendChatValue :(NSMutableArray *)chatValue;

@end


#endif /* ChatViewDelegate_h */
