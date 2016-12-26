//
//  ChatViewController.m
//  WeTalk
//
//  Created by 李恺林 on 2016/12/3.
//  Copyright © 2016年 李恺林. All rights reserved.
//

#import "ChatViewController.h"
#import <AFNetworking.h>
#import "ChatData.h"
#import "TextTableViewCell.h"
#import "ImageTableViewCell.h"
#import "InputBar.h"
#import <MBProgressHUD.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ChatViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, InputBarDelegate, UIScrollViewDelegate, imageWilShow>

@property (nonatomic, strong, readwrite) UITableView *table;
//@property (nonatomic, strong, readwrite) UITableView *inputTable;

@end

@implementation ChatViewController {
    InputBar *inputBar;
    BOOL isModified;
    NSMutableArray *titleArray;
    BOOL tapButton;
    CGFloat sumHigh;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    sumHigh = 0.0;
    
#pragma mark - 初始化设置
    //导航栏设置
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0/255.0 green:182.0/255.0 blue:252.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    self.navigationItem.title = @"小小Q";
    
    
    
    //table设置
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height -88 - 8 - 20) style:UITableViewStylePlain];
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table.allowsSelection = NO;
    self.table.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:237.0/255.0 blue:241.0/255.0 alpha:1.0];
    self.table.tag = 1;
    self.table.dataSource = self;
    self.table.delegate = self;
    [self.view addSubview:self.table];
    
//    self.inputTable = [[UITableView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 100) style:UITableViewStylePlain];
//    //self.inputTable.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.inputTable.allowsSelection = YES;
//    self.inputTable.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:233.0/255.0 blue:238.0/255.0 alpha:1.0];
//    self.inputTable.tag = 1;
//    self.inputTable.dataSource = self;
//    self.inputTable.delegate = self;
//    [self.view addSubview:self.inputTable];
    
    
    //输入框设置
    inputBar = [[InputBar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 44 - 8, self.view.frame.size.width, 44 + 8)];
    inputBar.backgroundColor = [UIColor colorWithRed:210.0/255.0 green:213.0/255.0 blue:219.0/255.0 alpha:1.0];
    inputBar.delegate = self;
    [inputBar.delegate draw:CGRectMake(0, self.view.frame.size.height - 44 - 8, self.view.frame.size.width, 44 + 8)];
    [self.view addSubview: inputBar];
    
    //init
    if (self.dataArray == nil) {
        self.dataArray = [[NSMutableArray alloc]init];
        ChatData *initMessage = [[ChatData alloc]init];
        [initMessage initText:@"主人，我是小小Q" :NO];
        [self.dataArray addObject: initMessage];
    }
    
    
    //contentoffset
    NSIndexPath *bottomIndexPath = [NSIndexPath  indexPathForRow:(self.dataArray.count - 1) inSection:0];
    [self.table scrollToRowAtIndexPath:bottomIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    //[self.table setContentOffset:CGPointMake(0, self.table.bounds.size.height) animated:NO];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
    [self.table addGestureRecognizer: tapGesture];
    tapGesture.cancelsTouchesInView = NO;

    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: {
                [self problem];
                //NSLog(@"未知网络状态");
            }
                break;
            case AFNetworkReachabilityStatusNotReachable: {
                [self problem];
                //NSLog(@"无网络");
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0/255.0 green:182.0/255.0 blue:252.0/255.0 alpha:1.0];
                self.navigationItem.title = @"小小Q";
                inputBar.inputField.userInteractionEnabled = YES;
                inputBar.inputField.placeholder = nil;
                //NSLog(@"蜂窝数据网");
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0/255.0 green:182.0/255.0 blue:252.0/255.0 alpha:1.0];
                self.navigationItem.title = @"小小Q";
                inputBar.inputField.userInteractionEnabled = YES;
                inputBar.inputField.placeholder = nil;
                //NSLog(@"WiFi网络");
            }
                break;
                
            default:
                break;
        }
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


#pragma mark - table类型设置
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (tableView == self.inputTable) {
//        static NSString * cellID = @"cellID";
//        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//        if (!cell) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//        }
//        NSInteger rowNo = indexPath.row;
//        cell.textLabel.text = titleArray[rowNo];
//        return cell;
//    }
    
    static NSString *textID = @"textID";
    static NSString *imageID = @"imageID";
    NSString *row = [NSString stringWithFormat: @"%ld", (long)indexPath.row];
    TextTableViewCell *textCell = [tableView dequeueReusableCellWithIdentifier:[textID stringByAppendingString:row]];
    ImageTableViewCell *imageCell = [tableView dequeueReusableCellWithIdentifier:[imageID stringByAppendingString:row]];
    
    ChatData *message = [self.dataArray objectAtIndex:indexPath.row];
    
    if ([message.imageMessage  isEqual: @""]) {
        if (textCell == nil) {
            textCell = [[TextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textID];
        }
        textCell.message = [ChatData new];
        textCell.message = message;
        textCell.UserID = self.UserID;
        [textCell load];
        return textCell;
    }
    else {
        if (imageCell == nil) {
            imageCell = [[ImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:imageID];
        }
        imageCell.delegate = self;
        imageCell.message = [ChatData new];
        imageCell.message = message;
        imageCell.UserID = self.UserID;
        [imageCell load];
        return imageCell;
    }
}

#pragma mark - table高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (tableView == self.inputTable) {
//        return 20;
//    }
    
    
    
    ChatData *message = [self.dataArray objectAtIndex:indexPath.row];
    
    if ([message.imageMessage  isEqual: @""]) {
        CGSize cellSize = [message.textMessage  boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 95 - 55 - 32, CGFLOAT_MAX)options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:18.0] ,NSFontAttributeName, nil] context:nil].size;
        sumHigh += cellSize.height + 40;
        return cellSize.height + 40;
    }
    else {
        NSString *documentPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"/"];
        NSString *path = [documentPath stringByAppendingString:message.imageMessage];
        NSData * imagedata = [NSData dataWithContentsOfURL:[NSURL URLWithString:[@"file://" stringByAppendingString:path]]];
        UIImage *image = [UIImage imageWithData:imagedata];
        
        UIImageView *showImage = [[UIImageView alloc]initWithImage:[self resizeImage:image toMaxWidthAndHeight:150.0]];
        
        CGRect imageSize = showImage.frame;
        sumHigh += imageSize.size.height + 48;
        return imageSize.size.height + 48;
    }
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor clearColor];
}


#pragma mark - 消息处理

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    isModified = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    ChatData *newSender = [[ChatData alloc]init];
    [newSender initText:inputBar.inputField.text :YES];
    [self.dataArray addObject:newSender];
    
    [self.table reloadData];
    sumHigh = 0.0;
    NSIndexPath *bottomIndexPath = [NSIndexPath  indexPathForRow:(self.dataArray.count - 1) inSection:0];
    [self.table scrollToRowAtIndexPath:bottomIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    
    AFHTTPSessionManager *requesetManager = [AFHTTPSessionManager manager];
    NSDictionary *parameterDic = @{@"key":@"84ecdde1fb534af19977f15d4f8b9530",@"info":inputBar.inputField.text,@"userid":self.UserID};
    [requesetManager POST:@"http://www.tuling123.com/openapi/api" parameters:parameterDic progress:nil
                  success:^(NSURLSessionDataTask *task, id responseObject) {
                      
                      NSDictionary *responceString = responseObject;
                      
                      
                      NSNumber *imageCode = [[NSNumber alloc]initWithLong:200000];
                      NSNumber *newsCode = [[NSNumber alloc]initWithLong:302000];
                      NSNumber *menuCode = [[NSNumber alloc]initWithLong:308000];
                      if ([[responceString objectForKey:@"code"] isEqualToNumber:imageCode]) {
                          ChatData *newResponse = [[ChatData alloc]init];
                          [newResponse initText:[responceString objectForKey:@"text"] :NO];
                          [self.dataArray addObject:newResponse];
                          
                          NSIndexPath *bottomIndexPath = [NSIndexPath  indexPathForRow:(self.dataArray.count - 1) inSection:0];
                          
                          ChatData *newImageResponse = [[ChatData alloc]init];
                          [newImageResponse initImage:@"placeholder" :NO];
                          [self.dataArray addObject:newImageResponse];
                          
                          [self.table reloadData];
                          AudioServicesPlayAlertSound(1309);
                          [self downLoadFromURL:[responceString objectForKey:@"url"]];
                          
                          
                          bottomIndexPath = [NSIndexPath  indexPathForRow:(self.dataArray.count - 1) inSection:0];
                          [self.table scrollToRowAtIndexPath:bottomIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                      }
                      else if ([[responceString objectForKey:@"code"] isEqualToNumber:newsCode]) {
                          ChatData *newResponse = [[ChatData alloc]init];
                          [newResponse initText:[responceString objectForKey:@"text"] :NO];
                          [self.dataArray addObject:newResponse];
                          
                          NSIndexPath *bottomIndexPath = [NSIndexPath  indexPathForRow:(self.dataArray.count - 1) inSection:0];
                          
                          ChatData *newNewsResponse = [[ChatData alloc]init];
                          NSString *newsMessage = @"";
                          
                          for (NSDictionary *plist in [responceString objectForKey:@"list"]) {
                              newsMessage = [newsMessage stringByAppendingString:[plist objectForKey:@"article"]];
                              newsMessage = [newsMessage stringByAppendingString:@" "];
                              newsMessage = [newsMessage stringByAppendingString:[plist objectForKey:@"detailurl"]];
                              newsMessage = [newsMessage stringByAppendingString:@"\n"];
                          }
                          [newNewsResponse initText:newsMessage :NO];
                          [self.dataArray addObject:newNewsResponse];
                          [self.table reloadData];
                          AudioServicesPlayAlertSound(1309);
                          sumHigh = 0.0;
                          [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                          bottomIndexPath = [NSIndexPath  indexPathForRow:(self.dataArray.count - 1) inSection:0];
                          [self.table scrollToRowAtIndexPath:bottomIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                      }
                      else if ([[responceString objectForKey:@"code"] isEqualToNumber:menuCode]) {
                          ChatData *newResponse = [[ChatData alloc]init];
                          [newResponse initText:[responceString objectForKey:@"text"] :NO];
                          [self.dataArray addObject:newResponse];
                          
                          NSIndexPath *bottomIndexPath = [NSIndexPath  indexPathForRow:(self.dataArray.count - 1) inSection:0];
                          
                          ChatData *newMenuResponse = [[ChatData alloc]init];
                          NSString *newsMessage = @"";
                          
                          for (NSDictionary *plist in [responceString objectForKey:@"list"]) {
                              newsMessage = [newsMessage stringByAppendingString:[plist objectForKey:@"name"]];
                              newsMessage = [newsMessage stringByAppendingString:@"\n"];
                              newsMessage = [newsMessage stringByAppendingString:[plist objectForKey:@"info"]];
                              break;
                          }
                          [newMenuResponse initText:newsMessage :NO];
                          [self.dataArray addObject:newMenuResponse];
                          
                          for (NSDictionary *plist in [responceString objectForKey:@"list"]) {
                              if (![[plist objectForKey:@"icon"]  isEqual: @""]) {
                                  ChatData *newImageResponse = [[ChatData alloc]init];
                                  [newImageResponse initImage:@"placeholder" :NO];
                                  [self.dataArray addObject:newImageResponse];
                                  
                                  [self.table reloadData];
                                  AudioServicesPlayAlertSound(1309);
                                  NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
                                  AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
                                  
                                  NSURL *URL = [NSURL URLWithString:[plist objectForKey:@"icon"]];
                                  NSURLRequest *request = [NSURLRequest requestWithURL:URL];
                                  
                                  NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                      NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                                      return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                                  } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                      
                                      ChatData *newImageResponse = [[ChatData alloc]init];
                                      
                                      NSArray *splitArr=[filePath.absoluteString componentsSeparatedByString:@"/"];
                                      NSString *fileName = [splitArr lastObject];
                                      [newImageResponse initImage:fileName :NO];
                                      NSInteger imageIndex = [self.dataArray count] - 1;
                                      [self.dataArray replaceObjectAtIndex:imageIndex withObject:newImageResponse];
                                      [self.table beginUpdates];
                                      NSIndexPath *path = [NSIndexPath indexPathForRow:imageIndex inSection:0];
                                      [self.table reloadRowsAtIndexPaths:[NSArray arrayWithObjects:path, nil] withRowAnimation:UITableViewRowAnimationNone];
                                      [self.table endUpdates];
                                      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                      
                                  }];
                                  [downloadTask resume];
                              }
                              else {
                                  ChatData *newImageResponse = [[ChatData alloc]init];
                                  [newImageResponse initImage:@"placeholder" :NO];
                                  [self.dataArray addObject:newImageResponse];
                                  
                                  [self.table reloadData];
                                  AudioServicesPlayAlertSound(1309);
                                  [self downLoadMenuFromURL:[plist objectForKey:@"detailurl"]];
                              }
                              break;
                          }
                          [self.table reloadData];
                          AudioServicesPlayAlertSound(1309);
                          
                          bottomIndexPath = [NSIndexPath  indexPathForRow:(self.dataArray.count - 1) inSection:0];
                          [self.table scrollToRowAtIndexPath:bottomIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                      }
                      else {
                          ChatData *newResponse = [[ChatData alloc]init];
                          [newResponse initText:[responceString objectForKey:@"text"] :NO];
                          [self.dataArray addObject:newResponse];
                          [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                          [self.table reloadData];
                          AudioServicesPlayAlertSound(1309);
                          sumHigh = 0.0;
                          NSIndexPath *bottomIndexPath = [NSIndexPath  indexPathForRow:(self.dataArray.count - 1) inSection:0];
                          [self.table scrollToRowAtIndexPath:bottomIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                      }
    }
                  failure:^(NSURLSessionDataTask *task, NSError *error) {
                      
                  }
     ];
    inputBar.inputField.text = @"";
    return NO;
}

- (void) draw:(CGRect)rect {
    CGRect bound = inputBar.bounds;
    inputBar.inputField = [[UITextField alloc]initWithFrame:CGRectMake(bound.origin.x + 7, bound.origin.y + 7, bound.size.width - 14 - 40, bound.size.height - 14)];
    inputBar.inputField.backgroundColor = [UIColor whiteColor];
    
    inputBar.inputField.layer.cornerRadius = (bound.size.height - 10) * 0.2;
    inputBar.inputField.layer.masksToBounds = YES;
    [inputBar.inputField.layer setBorderWidth: 0];
    
    inputBar.inputField.returnKeyType = UIReturnKeySend;
    inputBar.inputField.delegate = self;
    [inputBar addSubview:inputBar.inputField];
    
    inputBar.emoji = [UIButton buttonWithType:UIButtonTypeCustom];
    inputBar.emoji.frame = CGRectMake(bound.origin.x + 5 + bound.size.width - 10 - 40, bound.origin.y + 3 + 3, 40, 40);
    inputBar.emoji.backgroundColor = [UIColor clearColor];
    [inputBar.emoji setImage:[UIImage imageNamed:@"chat_bottom_smile_nor"] forState:UIControlStateNormal];
    [inputBar.emoji setImage:[UIImage imageNamed:@"chat_bottom_smile_press"] forState:UIControlStateHighlighted];
    [inputBar.emoji  setImage:[UIImage imageNamed:@"chat_bottom_keyboard_nor"] forState:UIControlStateSelected];
    [inputBar addSubview:inputBar.emoji];
    [inputBar.emoji addTarget:self action:@selector(emoji) forControlEvents:UIControlEventTouchUpInside];
}

- (void) emoji {
    tapButton = YES;
    [inputBar.inputField resignFirstResponder];
    
}

#pragma mark - 下载设置
- (void) downLoadMenuFromURL :(NSString *)Url {
    NSURL *URL = [NSURL URLWithString:Url];
    __block NSInteger imageIndex = [self.dataArray count] - 1;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        NSString *html = [[NSString alloc] initWithData:[NSData dataWithContentsOfURL:filePath] encoding:NSUTF8StringEncoding];
        
        NSString *location;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(?<=content=\").*(?=jpg)" options:0 error:nil];
        if (regex != nil) {
            NSTextCheckingResult *firstMatch = [regex firstMatchInString:html options:0 range:NSMakeRange(0, [html length])];
            if (firstMatch) {
                NSRange resultRange = [firstMatch rangeAtIndex:0];
                location = [html substringWithRange:resultRange];
            }
        }
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtURL:filePath error:nil];
        
        location = [location stringByAppendingString:@"jpg"];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSURL *URL = [NSURL URLWithString:location];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            
            ChatData *newImageResponse = [[ChatData alloc]init];
            
            NSArray *splitArr=[filePath.absoluteString componentsSeparatedByString:@"/"];
            NSString *fileName = [splitArr lastObject];
            [newImageResponse initImage:fileName :NO];
            
            [self.dataArray replaceObjectAtIndex:imageIndex withObject:newImageResponse];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            [self.table beginUpdates];
            NSIndexPath *path = [NSIndexPath indexPathForRow:imageIndex inSection:0];
            [self.table reloadRowsAtIndexPaths:[NSArray arrayWithObjects:path, nil] withRowAnimation:UITableViewRowAnimationNone];
            [self.table endUpdates];
            
        }];
        [downloadTask resume];
    }];
    [downloadTask resume];
}

- (void) downLoadFromURL :(NSString *)Url {
    NSURL *URL = [NSURL URLWithString:Url];
    __block NSInteger imageIndex = [self.dataArray count] - 1;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        NSString *html = [[NSString alloc] initWithData:[NSData dataWithContentsOfURL:filePath] encoding:NSUTF8StringEncoding];
        
        NSString *location;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(?<=\"thumb\":\").*(?=\",\"grpcnt\")" options:0 error:nil];
        if (regex != nil) {
            NSTextCheckingResult *firstMatch = [regex firstMatchInString:html options:0 range:NSMakeRange(0, [html length])];
            if (firstMatch) {
                NSRange resultRange = [firstMatch rangeAtIndex:0];
                location = [html substringWithRange:resultRange];
            }
        }
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtURL:filePath error:nil];
        
        location = [location substringToIndex:49];
        location = [location stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSURL *URL = [NSURL URLWithString:location];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            
            ChatData *newImageResponse = [[ChatData alloc]init];
            
            NSArray *splitArr=[filePath.absoluteString componentsSeparatedByString:@"/"];
            NSString *fileName = [splitArr lastObject];
            [newImageResponse initImage:fileName :NO];
            
            [self.dataArray replaceObjectAtIndex:imageIndex withObject:newImageResponse];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self.table beginUpdates];
            NSIndexPath *path = [NSIndexPath indexPathForRow:imageIndex inSection:0];
            [self.table reloadRowsAtIndexPaths:[NSArray arrayWithObjects:path, nil] withRowAnimation:UITableViewRowAnimationNone];
            [self.table endUpdates];
            
        }];
        [downloadTask resume];
    }];
    [downloadTask resume];
}


- (void) keyboardWillShown:(NSNotification *) notif{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSTimeInterval animationDuration = 0.2f;
    [UIView beginAnimations: @"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration: animationDuration];
    CGRect inputRect = CGRectMake(0, self.view.frame.size.height - 44 - keyboardSize.height - 8, self.view.frame.size.width, 44 + 8);
    inputBar.frame = inputRect;

    if ((sumHigh / 5) > self.view.frame.size.height - 94 - 8 - keyboardSize.height) {
        CGRect viewRect = CGRectMake(0, 64 , self.view.frame.size.width, self.view.frame.size.height - 44 - 8 - keyboardSize.height - 64);
        self.table.frame = viewRect;
    }
//    else {
//        CGRect viewRect = CGRectMake(0, 44 - 44 - 8, self.view.frame.size.width, self.view.frame.size.height - 88 - 8);
//        self.table.frame = viewRect;
//    }
    [UIView commitAnimations];
    NSIndexPath *bottomIndexPath = [NSIndexPath  indexPathForRow:(self.dataArray.count - 1) inSection:0];
    [self.table scrollToRowAtIndexPath:bottomIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void) keyboardWillHidden:(NSNotification *) notif{
    NSTimeInterval animationDuration = 0.2f;
    [UIView beginAnimations: @"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration: animationDuration];
    CGRect inputRect = CGRectMake(0, self.view.frame.size.height - 44 - 8, self.view.frame.size.width, 44 + 8);
    inputBar.frame = inputRect;
    CGRect viewRect = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 88 - 8 - 20);
    self.table.frame = viewRect;
    [UIView commitAnimations];
}

-(void)dismissKeyBoard{
    [inputBar.inputField resignFirstResponder];
}
- (void) closeKeyBoard {
    [inputBar.inputField resignFirstResponder];
}

//- (void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    if (scrollView.contentOffset.y < -60) {
//        [inputBar.inputField resignFirstResponder];
//    }
//}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGPoint offset = scrollView.contentOffset;
//    CGRect bounds = scrollView.bounds;
//    CGSize size = scrollView.contentSize;
//    UIEdgeInsets inset = scrollView.contentInset;
//    
//    CGFloat currentOffset = offset.y + bounds.size.height - inset.bottom;
//    CGFloat maximumOffset = size.height;
//    
//    
//    if( (maximumOffset - currentOffset) < -520.0 ){
//        [inputBar.inputField becomeFirstResponder];
//    }
//    
//}

- (void) problem {
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:225.0/255.0 green:7.0/255.0 blue:63.0/255.0 alpha:1.0];
    self.navigationItem.title = @"无网络";
    inputBar.inputField.userInteractionEnabled = NO;
    inputBar.inputField.placeholder = @"糟糕，和主人的失联了";
    [self networkProblem];
}

- (void) networkProblem {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.label.text = @"好像断网了...";
    hud.userInteractionEnabled = YES;
    hud.animationType = MBProgressHUDAnimationZoom;
    hud.contentColor = [UIColor grayColor];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cryIcon"]];
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:3];
}


- (void)viewDidDisappear:(BOOL)animated {
    if (self.dataArray.count > 1 && isModified) {
        [self.delegate sendChatValue:self.dataArray];
    }
}

@end
