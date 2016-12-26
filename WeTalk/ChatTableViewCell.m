//
//  ChatTableViewCell.m
//  WeTalk
//
//  Created by 李恺林 on 2016/12/11.
//  Copyright © 2016年 李恺林. All rights reserved.
//

#import "ChatTableViewCell.h"

@implementation ChatTableViewCell {
    UIImageView *showImage;
    UILabel *nameLable;
    UILabel *previewLable;
    UILabel *timeLable;
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
    
    
    UIImage *headImage = [UIImage imageNamed:self.preview.head];
    
    showImage = [[UIImageView alloc]initWithFrame:CGRectMake(bounds.origin.x + 15, bounds.origin.y + 10, 50, 50)];
    showImage.image = headImage;
    showImage.layer.cornerRadius = 50 * 0.5;
    showImage.layer.masksToBounds = YES;
    [showImage.layer setBorderWidth:0];
    
    
    nameLable = [[UILabel alloc]initWithFrame:CGRectMake(bounds.origin.x + 80, bounds.origin.y + 10, bounds.size.width - 140, 25)];
    nameLable.text = self.preview.name;
    nameLable.font = [UIFont systemFontOfSize:20.0];
    
    previewLable = [[UILabel alloc]initWithFrame:CGRectMake(bounds.origin.x + 80, bounds.origin.y + 10 + 30, bounds.size.width - 140, 20)];
    previewLable.text = self.preview.previewMessage;
    previewLable.textColor = [UIColor grayColor];
    previewLable.font = [UIFont systemFontOfSize:15.0];
    
    
    timeLable = [[UILabel alloc]initWithFrame:CGRectMake(bounds.origin.x + bounds.size.width * 0.8 + 10 - 30, bounds.origin.y + 10, 70, 25)];
    timeLable.text = self.preview.time;
    timeLable.textAlignment = NSTextAlignmentRight;
    timeLable.textColor = [UIColor grayColor];
    timeLable.font = [UIFont systemFontOfSize:14.0];
    
    [self.contentView addSubview:showImage];
    [self.contentView addSubview:nameLable];
    [self.contentView addSubview:previewLable];
    [self.contentView addSubview:timeLable];
    
    
}

@end
