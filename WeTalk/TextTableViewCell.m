//
//  TextTableViewCell.m
//  WeTalk
//
//  Created by 李恺林 on 2016/12/3.
//  Copyright © 2016年 李恺林. All rights reserved.
//

#import "TextTableViewCell.h"

@implementation TextTableViewCell {
    UILabel *showText;
    UIImageView *bubble;
    UIImageView *head;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void) load {
    
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    showText = [[UILabel alloc]init];
    showText.text = self.message.textMessage;
    showText.font = [UIFont systemFontOfSize:18.0];
    self.cellSize = [showText.text  boundingRectWithSize:CGSizeMake(bounds.size.width - 95 - 55 - 32, CGFLOAT_MAX)options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:showText.font,NSFontAttributeName, nil] context:nil].size;
    showText.numberOfLines = 100;
    showText.backgroundColor = [UIColor clearColor];
    
    if (self.message.isMine) {
        showText.frame = CGRectMake(bounds.origin.x + (bounds.size.width - self.cellSize.width) + 5 - 25 + 6 - 55 - 5 - 4 - 8, bounds.origin.y + 18, self.cellSize.width,self.cellSize.height);
        showText.textColor = [UIColor whiteColor];
        UIImage *bubbleImage = [UIImage imageNamed:@"send"];
        bubbleImage = [bubbleImage stretchableImageWithLeftCapWidth:30 topCapHeight:30];
        bubble = [[UIImageView alloc]initWithFrame:CGRectMake(bounds.origin.x + (bounds.size.width - self.cellSize.width) - 35 - 55 - 4 - 8 - 8, bounds.origin.y, self.cellSize.width + 30 + 10 + 8,self.cellSize.height + 30 + 8)];
        bubble.image = bubbleImage;
        
        
        UIImage *headImage = [UIImage imageNamed:@"Mine"];
        head = [[UIImageView alloc]initWithFrame:CGRectMake(bounds.size.width + 9 - 65 - 4, bounds.origin.y + 5 + 2, 46, 46)];
        head.image = headImage;
        head.layer.cornerRadius = 46 * 0.5;
        head.layer.masksToBounds = YES;
        [head.layer setBorderWidth:0];
    }
    else {
        showText.frame = CGRectMake(bounds.origin.x + 15 + 40 + 15 + 5 + 4 + 5 + 4, bounds.origin.y + 18, self.cellSize.width,self.cellSize.height);
        UIImage *bubbleImage = [UIImage imageNamed:@"recive"];
        bubbleImage = [bubbleImage stretchableImageWithLeftCapWidth:30 topCapHeight:30];
        bubble = [[UIImageView alloc]initWithFrame:CGRectMake(bounds.origin.x + 40 + 15 + 5 + 4, bounds.origin.y, self.cellSize.width + 40 + 8,self.cellSize.height + 30 + 8)];
        bubble.image = bubbleImage;
        
        UIImage *headImage = [UIImage imageNamed:[self iconCount:self.UserID]];
        head = [[UIImageView alloc]initWithFrame:CGRectMake(bounds.origin.x + 15, bounds.origin.y + 5 + 2, 46, 46)];
        head.image = headImage;
        head.layer.cornerRadius = 46 * 0.5;
        head.layer.masksToBounds = YES;
        [head.layer setBorderWidth:0];
    }
    
    [self.contentView addSubview:head];
    [self.contentView addSubview:bubble];
    [self.contentView addSubview:showText];
}

- (NSString *) iconCount :(NSString *)number {
    int count = [number intValue];
    return [NSString stringWithFormat:@"%d", count % 20];
}

@end
