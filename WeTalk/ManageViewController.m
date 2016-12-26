//
//  ManageViewController.m
//  WeTalk
//
//  Created by 李恺林 on 2016/12/11.
//  Copyright © 2016年 李恺林. All rights reserved.
//

#import "ManageViewController.h"
#import "ChatViewController.h"
#import "ChatTableViewCell.h"
#import "previewData.h"
#import "ChatData.h"
#import <FMDB.h>
#import <MBProgressHUD.h>
#import "UINavigationBar+Transparent.h"
#import "TransparentView.h"
#import <UserNotifications/UserNotifications.h>


@interface ManageViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, ChatViewDelegate, transparentDelegate, UIViewControllerPreviewingDelegate>

@property (nonatomic, strong, readwrite) UITableView *table;
@property (nonatomic, strong, readwrite) FMDatabase *dataBase;
//@property (nonatomic, strong, readwrite) NSMutableArray *timeArray;


@end

@implementation ManageViewController {
    NSInteger selectRow;
    BOOL ifWillAdd;
    BOOL ifWillDetail;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.chatLogArray = [[NSMutableArray alloc]init];
    //self.timeArray = [[NSMutableArray alloc]init];
    

    ifWillAdd = NO;
    ifWillDetail = NO;
    
    [self notice];
    [self noticeDaily];
    
    [self registerForPreviewingWithDelegate:self sourceView:self.view];
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, bounds.size.height)];

    [self.table setSeparatorInset:UIEdgeInsetsMake(0, 80, 0, 0)];
    
    UIImageView *topView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    topView.frame = CGRectMake(0, 0, self.view.frame.size.width, 200);
    
    TransparentView *transparentView = [TransparentView dropHeaderViewWithFrame: topView.frame contentView:topView stretchView: topView];
    transparentView.frame = topView.frame;
    transparentView.delegate = self;
    self.table.tableHeaderView = transparentView;
    
    
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.view addSubview:self.table];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0/255.0 green:182.0/255.0 blue:252.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    self.navigationItem.title = @"小小Q";
    UIImage* addImage = [UIImage imageNamed:@"add"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 28, 28);
    [btn setBackgroundImage:addImage forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(addChat) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *addButton=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = addButton;

    self.table.tableFooterView = [UIView new];
    
    

    [self openDataBase];
    
    NSInteger index = 1;
    while (index) {
        NSMutableArray *tmp = [self selectChatByID:[NSString stringWithFormat:@"%ld", (long)index]];
        if (tmp.count != 0) {
            [self.chatLogArray addObject:tmp];
            index++;
        }
        else break;
    }
    
    
    
    
    
    
    // Do any additional setup after loading the view.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!ifWillDetail && !ifWillAdd) {
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY > 0) {
            CGFloat alpha = (offsetY - 64) / 64 ;
            alpha = MIN(alpha, 1);
            [self.navigationController.navigationBar js_setBackgroundColor:[[UIColor colorWithRed:0/255.0 green:182.0/255.0 blue:252.0/255.0 alpha:1.0] colorWithAlphaComponent:alpha]];
        } else {
            [self.navigationController.navigationBar js_setBackgroundColor:[UIColor clearColor]];
        }
    }
}

- (void) openDataBase {
    
    if (self.dataBase != nil) {
        return ;
    }
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    documentPath = [documentPath stringByAppendingPathComponent:@"/ChatLog.sqlite"];
    
    
    self.dataBase = [FMDatabase databaseWithPath:documentPath];
    
    if ([self.dataBase open]) {
        
        BOOL result = [self.dataBase executeUpdate:@"CREATE TABLE IF NOT EXISTS Chat ('id' INTEGER PRIMARY KEY NOT NULL, 'UserID' TEXT NOT NULL, 'textMessage' TEXT NOT NULL, 'imageMessage' TEXT NOT NULL, 'isMine' TEXT NOT NULL, 'time' TEXT NOT NULL);"];
        
        if (result) {
            //NSLog(@"数据库打开成功!");
        }else{
            //NSLog(@"数据库打开失败!");
        }
    }
}

- (void) addNewChat: (NSMutableArray *)message {
    if (selectRow != -1) {
        NSInteger index = selectRow + 1;
        for (ChatData *new in message) {
            [self insertChatData:new :[NSString stringWithFormat:@"%ld",(long)index]];
        }
    }
    else {
        NSInteger index = self.chatLogArray.count;
        for (ChatData *new in message) {
            [self insertChatData:new :[NSString stringWithFormat:@"%ld",(long)index]];
        }
    }
    
}


- (void)insertChatData:(ChatData *)message :(NSString *) UserID{
    
    
    BOOL result = [self.dataBase executeUpdate:@"INSERT INTO Chat (UserID, textMessage, imageMessage, isMine, time) VALUES (?, ?, ?, ?, ?);", UserID, message.textMessage, message.imageMessage, (message.isMine == YES)? @"1" : @"0", [self timeToString:message.messageTime]];
    
    if (result) {
        //NSLog(@"插入成功!");
    }else{
        //NSLog(@"插入失败!");
    }
    
    
}

- (NSMutableArray *)selectChatByID: (NSString *)ID{
    FMResultSet *result = [self.dataBase executeQuery:@"SELECT * FROM Chat where UserID = ?",ID];
    
    NSMutableArray *chatArray = [[NSMutableArray alloc]init];
    
    

    
    while ([result next]) {
        
        ChatData *newData = [[ChatData alloc]init];
        newData.textMessage = [result stringForColumn:@"textMessage"];
        newData.imageMessage = [result stringForColumn:@"imageMessage"];
        
        newData.isMine = ([[result stringForColumn:@"isMine"] isEqualToString:@"1"]) ? YES : NO;
        newData.messageTime = [self stringToTime:[result stringForColumn:@"time"]];
        [chatArray addObject:newData];
        
        
        //[array addObject:model];
    }
    [result close];
    

    return chatArray;
}

- (void) deleteChat :(NSString *)ID {
    [self.dataBase executeUpdate:@"DELETE FROM Chat where UserID = ?",ID];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chatLogArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0;
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellID";
    NSString *row = [NSString stringWithFormat: @"%ld", (long)indexPath.row];
    ChatTableViewCell *chatCell = [tableView dequeueReusableCellWithIdentifier:[cellID stringByAppendingString:row]];
    if (chatCell == nil) {
        chatCell = [[ChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSMutableArray *dataAtIndex = [self.chatLogArray objectAtIndex:indexPath.row];
    ChatData *preview = [dataAtIndex objectAtIndex:dataAtIndex.count - 1];
    chatCell.preview = [previewData new];
    
    [chatCell.preview setPreview: preview.textMessage : [self iconCount:(long)indexPath.row + 1] :[self previewTime:preview.messageTime] :@"小小Q"];
    
    [chatCell load];
    
    return chatCell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {


    [self.chatLogArray removeObjectAtIndex:indexPath.row];
    [self.table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

    [self deleteChat:[NSString stringWithFormat:@"%ld", (long)indexPath.row + 1]];
}


- (void) addChat {
    selectRow = -1;
    ChatViewController *addView = [[ChatViewController alloc]initWithNibName:nil bundle:[NSBundle mainBundle]];
    addView.delegate = self;
    addView.UserID = [NSString stringWithFormat:@"%lu", (unsigned long)self.chatLogArray.count + 1];
    [self.navigationController.navigationBar js_reset];
    ifWillAdd = YES;
    [self.navigationController pushViewController:addView animated:YES];
    

}

- (void) sendChatValue :(NSMutableArray *)chatValue {
    if (selectRow != -1) {
        [self.chatLogArray removeObjectAtIndex:selectRow];
        [self deleteChat:[NSString stringWithFormat:@"%ld", (long)selectRow + 1]];
        [self.chatLogArray insertObject:chatValue atIndex:selectRow];
    }
    else {
        [self.chatLogArray insertObject:chatValue atIndex:self.chatLogArray.count];
    }
    
    [self addNewChat:chatValue];
    [self.table reloadData];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    selectRow = indexPath.row;
    
    ChatViewController *detailChatView = [[ChatViewController alloc]initWithNibName:nil bundle:[NSBundle mainBundle]];
    detailChatView.delegate = self;
    detailChatView.dataArray = [[NSMutableArray alloc]init];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableArray *sendChatValue = [self.chatLogArray objectAtIndex:indexPath.row];
    detailChatView.dataArray = sendChatValue;
    detailChatView.UserID = [NSString stringWithFormat:@"%ld",(long)indexPath.row + 1];
    [self.navigationController.navigationBar js_reset];
    ifWillDetail = YES;
    [self.navigationController pushViewController:detailChatView animated:YES];
}

- (void) viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    ifWillDetail = NO;
    ifWillAdd = NO;
}

- (void) callHUD {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.userInteractionEnabled = YES;
    hud.animationType = MBProgressHUDAnimationZoom;
    hud.label.text = @"刷新成功";
    hud.contentColor = [UIColor grayColor];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"correctIcon"]];
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1];

}

- (void) notice {
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {

    }];
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"小小Q";
    content.body = @"主人，有没有想我呢？";
    content.sound = [UNNotificationSound defaultSound];
    
    content.badge = @1;
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval: 60 * 60 * 2  repeats:YES];
    
    NSString *requestIdentifier = @"sample";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier
                                                                          content:content
                                                                          trigger:trigger];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        
    }];
}
- (void) noticeDaily {
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
    }];
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"“最大的魅力是努力”";
    content.subtitle = @"今天，你进步了没有？";
    content.body = @"每天让自己再强一点点";
    content.sound = [UNNotificationSound defaultSound];
    
    content.badge = @2;
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.hour = 23;
    components.minute = 20;
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];
    NSString *requestIdentifier = @"dailyNotice";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier
                                                                          content:content
                                                                          trigger:trigger];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        
    }];
}

- (NSString *) timeToString :(NSDate *)time{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年MM月dd日 HH:mm::ss";
    NSString *string = [dateFormatter stringFromDate:time];
    return string;
}
- (NSDate *) stringToTime :(NSString *)string {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm::ss"];
    NSDate *date = [formatter dateFromString:string];
    return date;
}
- (NSString *)previewTime :(NSDate *)time {
    NSDate *localDate = [[NSDate date]  dateByAddingTimeInterval: [[NSTimeZone systemTimeZone] secondsFromGMTForDate:[NSDate date]]];
    NSDate *yesterdayDate = [[NSDate alloc] initWithTimeInterval:- 60 * 60 * 24 sinceDate:localDate];
    NSDate *beforeDate = [[NSDate alloc] initWithTimeInterval:- 60 * 60 * 24 * 2 sinceDate:localDate];
    if ([time laterDate:yesterdayDate]) {
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"HH:mm";
        NSString *string = [dateFormatter stringFromDate:[[NSDate alloc] initWithTimeInterval:-60 * 60 * 8 sinceDate:time]];
        return string;
    }
    else if ([time laterDate:beforeDate]) {
        return @"昨天";
    }
    else {
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"M月d日";
        NSString *string = [dateFormatter stringFromDate:[[NSDate alloc] initWithTimeInterval:-60 * 60 * 8 sinceDate:time]];
        return string;
    }
}

- (NSString *) iconCount :(long)number{
    return [NSString stringWithFormat:@"%ld", number % 20];
}


- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    CGPoint place = [self.table convertPoint:location fromView:self.view];
    
    NSIndexPath *indexPath = [self.table indexPathForRowAtPoint:place];
    

    
    ChatViewController *detailChatView = [[ChatViewController alloc]initWithNibName:nil bundle:[NSBundle mainBundle]];
    detailChatView.delegate = self;
    
    detailChatView.dataArray = [[NSMutableArray alloc]init];
    
    [self.table deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableArray *sendChatValue = [self.chatLogArray objectAtIndex:indexPath.row];
    detailChatView.dataArray = sendChatValue;
    detailChatView.view.frame = self.view.frame;
    detailChatView.UserID = [NSString stringWithFormat:@"%ld",(long)indexPath.row + 1];
    [self.navigationController.navigationBar js_reset];
    ifWillDetail = YES;
    
    return detailChatView;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    [self showViewController:viewControllerToCommit sender:self];
}

//- (void)setExtraCellLineHidden: (UITableView *)tableView
//{
//    UIView *view =[ [UIView alloc]init];
//    view.backgroundColor = [UIColor clearColor];
//    [tableView setTableFooterView:view];
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
