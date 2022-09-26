//
//  CCMineViewController.m
//  CliCli
//
//  Created by Fancy 
//

#import "CCMineViewController.h"
#import "CCUser.h"
#import "CCLoginRegisterController.h"
#import "CCUserInfoEditViewController.h"
#import "CCVideoListController.h"
#import "CCSettingViewController.h"
#import "CCVideoDownloadListController.h"
#import <SDWebImage/SDWebImage.h>

@interface CCMineViewController ()

@property (nonatomic, copy) NSArray <NSString *> *dataSource;

@end

@implementation CCMineViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChanged:) name:CC_NOTIFICATION_LOGIN_STATUS object:nil];
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
 
    self.navigationItem.title = @"我的";
}

- (void)initTableView {
    [super initTableView];
    
    self.tableView.tableHeaderView = [self tableHeaderView];
}

#pragma mark - Action
- (void)accountAction:(UITapGestureRecognizer *)sender {
    CCUser *user = [CCUser userFromLocal];
    user ? [self toUserInfoEdit] : [CCUser toLoginController:self];
}

#pragma mark - Notification
- (void)loginStatusChanged:(NSNotification *)noti {
    self.tableView.tableHeaderView = [self tableHeaderView];
}

#pragma mark - Method
- (UIView *)tableHeaderView {
    CCUser *user = [CCUser userFromLocal];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    
    UIImageView *avatarView = [[SDAnimatedImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 80) / 2, 50, 80, 80)];
    avatarView.userInteractionEnabled = YES;
    avatarView.layer.cornerRadius = 40;
    avatarView.layer.masksToBounds = YES;
    avatarView.backgroundColor = UIColor.systemGray5Color;
    if (user) {
        [avatarView sd_setImageWithURL:[NSURL URLWithString:user.user_portrait]];
    }
    [avatarView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(accountAction:)]];
    [header addSubview:avatarView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 150, SCREEN_WIDTH - 100, 20)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = UIFontBoldMake(16);
    nameLabel.text = user ? (user.user_nick_name.length ? user.user_nick_name : user.user_name) : @"点击登录";
    nameLabel.userInteractionEnabled = YES;
    [nameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(accountAction:)]];
    [header addSubview:nameLabel];
    
    return header;
}

#pragma mark - Roter
- (void)toVideoHistoryList {
    CCVideoListController *list = [[CCVideoListController alloc] initWithType:CCVideoListTypeHistory];
    [self.navigationController pushViewController:list animated:YES];
}

- (void)toVideoCollectionList {
    CCVideoListController *list = [[CCVideoListController alloc] initWithType:CCVideoListTypeCollection];
    [self.navigationController pushViewController:list animated:YES];
}

- (void)toUserInfoEdit {
    CCUserInfoEditViewController *edit = [[CCUserInfoEditViewController alloc] init];
    [self.navigationController pushViewController:edit animated:YES];
}

- (void)toSetting {
    CCSettingViewController *setting = [[CCSettingViewController alloc] init];
    [self.navigationController pushViewController:setting animated:YES];
}

- (void)toDownload {
    CCVideoDownloadListController *download = [[CCVideoDownloadListController alloc] initWithStyle:UITableViewStyleInsetGrouped];
    [self.navigationController pushViewController:download animated:YES];
}


#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellIdentifer = @"CCBaseTableViewCell";
    CCBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer];
    if (!cell) {
        cell = [[CCBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellIdentifer];
        cell.textLabel.font = UIFontMake(15);
        cell.detailTextLabel.font = UIFontMake(12);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    };
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CCUser *user = [CCUser userFromLocal];
    switch (indexPath.row) {
        case 0:
            user ? [self toVideoHistoryList] : [CCUser toLoginController:self];
            break;
        case 1:
            user ? [self toVideoCollectionList] : [CCUser toLoginController:self];
            break;
        case 2:
            [self toDownload];
            break;
        default:
            [self toSetting];
            break;
    }
}

#pragma mark - Get
- (NSArray<NSString *> *)dataSource {
    if (!_dataSource) {
        _dataSource = @[@"观看历史", @"我的收藏", @"我的下载", @"设置"];
    }
    return _dataSource;
}

@end
