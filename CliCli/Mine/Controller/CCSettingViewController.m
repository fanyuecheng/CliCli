//
//  CCSettingViewController.m
//  CliCli
//
//  Created by Fancy
//

#import "CCSettingViewController.h"
#import "CCUser.h"
#import "CCUserLogoutRequest.h"
#import <SDWebImage/SDWebImage.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface CCSettingViewController ()

@property (nonatomic, copy)   NSArray <NSString *> *dataSource;
@property (nonatomic, strong) CCUserLogoutRequest *request;
@property (nonatomic, strong) UIButton *logoutButton;

@end

@implementation CCSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    
    self.navigationItem.title = @"设置";
}

- (void)initTableView {
    [super initTableView];
    
    self.tableView.tableFooterView = [self tableFooterView];
    self.logoutButton.hidden = ![CCUser userFromLocal];
}

#pragma mark - Method
- (UIView *)tableFooterView {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    [footer addSubview:self.logoutButton];
    return footer;
}

- (void)alertWithTitle:(NSString *)title
                action:(void (^)(UIAlertAction *action))action {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
     
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *a) {
        !action ? : action(a);
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Net
- (void)logout {
    [SVProgressHUD showProgress:-1];
    [self.request sendRequest:^(id  _Nonnull response) {
        [SVProgressHUD dismiss];
        self.logoutButton.hidden = YES;
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - Action
- (void)logoutAction:(UIButton *)sender {
    @weakify(self)
    [self alertWithTitle:@"确定退出登录？" action:^(UIAlertAction *action) {
        @strongify(self)
        [self logout];
    }];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellIdentifer = @"CCBaseTableViewCell";
    CCBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer];
    if (!cell) {
        cell = [[CCBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellIdentifer];
        cell.textLabel.font = UIFontMake(15);
        cell.detailTextLabel.font = UIFontMake(12);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = [self.dataSource cc_safeObjectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [NSByteCountFormatter stringFromByteCount:[[SDImageCache sharedImageCache] totalDiskSize] countStyle:NSByteCountFormatterCountStyleFile];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self alertWithTitle:@"确定删除缓存？" action:^(UIAlertAction *action) {
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [tableView reloadData];
        }];
    }];
}

#pragma mark - Get
- (NSArray<NSString *> *)dataSource {
    if (!_dataSource) {
        _dataSource = @[@"清除缓存"];
    }
    return _dataSource;
}

- (UIButton *)logoutButton {
    if (!_logoutButton) {
        _logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 40, SCREEN_WIDTH - 30, 44)];
        [_logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
        _logoutButton.titleLabel.font = UIFontMake(15);
        _logoutButton.backgroundColor = UIColor.systemBlueColor;
        _logoutButton.layer.cornerRadius = 8;
        [_logoutButton setTitleColor:UIColor.systemBackgroundColor forState:UIControlStateNormal];
        [_logoutButton addTarget:self action:@selector(logoutAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logoutButton;
}

- (CCUserLogoutRequest *)request {
    if (!_request) {
        _request = [[CCUserLogoutRequest alloc] init];
    }
    return _request;
}

@end
