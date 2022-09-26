//
//  CCUserInfoEditViewController.m
//  CliCli
//
//  Created by Fancy 
//

#import "CCUserInfoEditViewController.h"
#import "CCUser.h"
#import "CCUserAvatarViewController.h"
#import "CCUserInfoUpdateRequest.h"
#import <SDWebImage/SDWebImage.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface CCUserInfoEditViewController ()

@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, copy)   NSString *avatar;
@property (nonatomic, copy)   NSString *name;

@property (nonatomic, strong) CCUserInfoUpdateRequest *request;

@end

@implementation CCUserInfoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    
    self.navigationItem.title = @"个人资料";
}

- (void)initTableView {
    [super initTableView];
     
    self.tableView.tableFooterView = [self tableFooterView];
    self.tableView.rowHeight = 50;
}

#pragma mark - Action
- (void)confirmAction:(UIButton *)sender {
    self.request.avatar = self.avatar;
    self.request.nickName = self.name;
    
    [SVProgressHUD showProgress:-1];
    [self.request sendRequest:^(CCUser *response) {
        [SVProgressHUD dismiss];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - Method
- (UIView *)tableFooterView {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 144)];
    [footer addSubview:self.confirmButton];
    return footer;
}

- (void)selectAvatar {
    CCUserAvatarViewController *avatar = [[CCUserAvatarViewController alloc] init];
    @weakify(self)
    avatar.avatarBlock = ^(NSString * _Nonnull url) {
        @strongify(self)
        self.avatar = url;
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:avatar animated:YES];
}

- (void)userNameAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入新的昵称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.font = UIFontMake(14);
        textField.placeholder = @"请输入新的昵称";
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    @weakify(self)
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        @strongify(self)
        UITextField *textField = alert.textFields.firstObject;
        if (textField.text.length) {
            self.name = textField.text;
            [self.tableView reloadData];
        }
    }];
    [alert addAction:cancelAction];
    [alert addAction:otherAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellIdentifer = @"CCBaseTableViewCell";
    CCBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer];
    if (!cell) {
        cell = [[CCBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellIdentifer];
        cell.textLabel.font = UIFontMake(15);
        cell.detailTextLabel.font = UIFontMake(12);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = indexPath.row == 0 ? @"修改头像" : @"修改昵称";
    
    UIImageView *avatarView = [cell.contentView viewWithTag:1000];
    if (!avatarView) {
        avatarView = [[SDAnimatedImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 5, 40, 40)];
        avatarView.tag = 1000;
        avatarView.layer.cornerRadius = 20;
        avatarView.layer.masksToBounds = YES;
        [cell.contentView addSubview:avatarView];
    }
    
    avatarView.hidden = indexPath.row != 0;
    [avatarView sd_setImageWithURL:[NSURL URLWithString:self.avatar]];
    cell.detailTextLabel.text = indexPath.row == 1 ? self.name : nil;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [self selectAvatar];
    } else {
        [self userNameAlert];
    }
}
 
#pragma mark - Get
- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 50, SCREEN_WIDTH - 30, 44)];
        _confirmButton.titleLabel.font = UIFontMake(15);
        _confirmButton.backgroundColor = UIColor.systemBlueColor;
        _confirmButton.layer.cornerRadius = 15;
        [_confirmButton setTitleColor:UIColor.systemBackgroundColor forState:UIControlStateNormal];
        [_confirmButton setTitle:@"保存" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (NSString *)avatar {
    if (!_avatar) {
        _avatar = [CCUser userFromLocal].user_portrait;
    }
    return _avatar;
}

- (NSString *)name {
    if (!_name) {
        _name = [CCUser userFromLocal].user_name;
    }
    return _name;
}

- (CCUserInfoUpdateRequest *)request {
    if (!_request) {
        _request = [[CCUserInfoUpdateRequest alloc] init];
    }
    return _request;
}

@end
