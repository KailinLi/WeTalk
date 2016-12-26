//
//  ImageTableViewCell.m
//  WeTalk
//
//  Created by 李恺林 on 2016/12/4.
//  Copyright © 2016年 李恺林. All rights reserved.
//

#import "ImageTableViewCell.h"
#import <AFNetworking.h>
#import "UIImageView+AFNetworking.h"

@interface ImageTableViewCell()

@property (nonatomic, weak) UIImage *demoImage;

@end

@implementation ImageTableViewCell {
    UIImage *image;
    UIImageView *showImage;
    UIImageView *bubble;
    UIImageView *head;
    CGRect oldframe;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIImage *)resizeImage:(UIImage *)sourceImage toMaxWidthAndHeight:(CGFloat)maxValue {
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    if (width >= height && width > maxValue) {
        height = height * (maxValue / width);
        width = maxValue;
    }
    else if (height > width && height > maxValue) {
        width = width * (maxValue / height);
        height = maxValue;
    }
    else {
        return sourceImage;
    }
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [sourceImage drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void) load {
    
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    
    
    if ([self.message.imageMessage  isEqual: @"placeholder"]) {
        image = [UIImage imageNamed:self.message.imageMessage];
    }
    else {
        NSString *documentPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"/"];
        NSString *path = [documentPath stringByAppendingString:self.message.imageMessage];
        NSData * imagedata = [NSData dataWithContentsOfURL:[NSURL URLWithString:[@"file://" stringByAppendingString:path]]];
        image = [UIImage imageWithData:imagedata];
    }
    
    
    showImage = [[UIImageView alloc]initWithImage:[self resizeImage:image toMaxWidthAndHeight:150.0]];
    showImage.backgroundColor = [UIColor clearColor];
    showImage.layer.cornerRadius = 10;
    showImage.layer.masksToBounds = YES;
    [showImage.layer setBorderWidth:0];
    
    
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImage)];
    showImage.userInteractionEnabled = YES;
    [showImage addGestureRecognizer:tap];
    
    CGRect imageSize = showImage.frame;
    self.cellSize = imageSize.size;
    
    if (self.message.isMine) {
        showImage.frame = CGRectMake(bounds.origin.x + (bounds.size.width - self.cellSize.width) + 15 - 25 + 6 - 10, bounds.origin.y + 15, self.cellSize.width,self.cellSize.height);
        
        
        UIImage *bubbleImage = [UIImage imageNamed:@"send"];
        bubbleImage = [bubbleImage stretchableImageWithLeftCapWidth:30 topCapHeight:30];
        bubble = [[UIImageView alloc]initWithFrame:CGRectMake(bounds.origin.x + (bounds.size.width - self.cellSize.width) - 25 + 6 - 10, bounds.origin.y, self.cellSize.width + 30,self.cellSize.height + 30)];
        bubble.image = bubbleImage;
        
        
        UIImage *headImage = [UIImage imageNamed:@"Mine"];
        head = [[UIImageView alloc]initWithFrame:CGRectMake(bounds.size.width + 9 - 10, bounds.origin.y + 5 + 2, 46, 46)];
        head.image = headImage;
        head.layer.cornerRadius = 46 * 0.5;
        head.layer.masksToBounds = YES;
        [head.layer setBorderWidth:0];
    }
    else {
        showImage.frame = CGRectMake(bounds.origin.x + 15 + 40 + 5 + 10 + 4 + 5, bounds.origin.y + 15, self.cellSize.width,self.cellSize.height);
        UIImage *bubbleImage = [UIImage imageNamed:@"recive"];
        bubbleImage = [bubbleImage stretchableImageWithLeftCapWidth:30 topCapHeight:30];
        bubble = [[UIImageView alloc]initWithFrame:CGRectMake(bounds.origin.x + 40 + 15 + 4 + 5, bounds.origin.y, self.cellSize.width + 30,self.cellSize.height + 30)];
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
    [self.contentView addSubview:showImage];
}

- (void)showImage{
    UIImage *Image = image;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    oldframe = [showImage convertRect:showImage.bounds toView:window];
    backgroundView.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:oldframe];
    imageView.image = Image;
    imageView.tag = 1;
    [backgroundView addSubview: imageView];
    [window addSubview: backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [self.delegate closeKeyBoard];
    
    [UIView animateWithDuration:0.3f animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height - Image.size.height * [UIScreen mainScreen].bounds.size.width / Image.size.width)/2, [UIScreen mainScreen].bounds.size.width, Image.size.height * [UIScreen mainScreen].bounds.size.width / Image.size.width);
        backgroundView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView = tap.view;
    UIImageView *imageView = (UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3f animations:^{
        imageView.frame = oldframe;
        backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}

- (NSString *) iconCount :(NSString *)number {
    int count = [number intValue];
    return [NSString stringWithFormat:@"%d", count % 20];
}



@end
