//
//  CCLoginRegisterController.m
//  CliCli
//
//  Created by Fancy 
//

#import "CCLoginRegisterController.h"
#import "CCUserLoginRequest.h"
#import "CCUserRegistRequest.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface CCLoginRegisterController ()

@property (nonatomic, assign) CCAccountAction action;

@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UITextField *accountTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton    *confirmButton;
@property (nonatomic, strong) UIButton    *registButton;
@property (nonatomic, strong) UIView      *accountLine;
@property (nonatomic, strong) UIView      *passwordLine;

@property (nonatomic, strong) CCUserLoginRequest *loginRequest;
@property (nonatomic, strong) CCUserRegistRequest *registRequest;
@property (nonatomic, assign) BOOL autoLogin;

@end

@implementation CCLoginRegisterController

- (instancetype)initWithAction:(CCAccountAction)action {
    if (self = [super init]) {
        self.action = action;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    
    self.navigationItem.title = self.action == CCAccountActionLogin ? @"登录" : @"注册";
}

- (void)initSubviews {
    [super initSubviews];
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.accountTextField];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.accountLine];
    [self.view addSubview:self.passwordLine];
    [self.view addSubview:self.confirmButton];
    [self.view addSubview:self.registButton];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat width = self.view.cc_width;
    CGFloat height = self.view.cc_height;
    CGFloat navigationBarBottom = self.navigationController.navigationBar.cc_bottom;
    
    self.titleLabel.frame = CGRectMake(15, navigationBarBottom + 15, width - 30, 20);
    self.accountTextField.frame = CGRectMake(15, self.titleLabel.cc_bottom + 44, width - 30, 44);
    self.passwordTextField.frame = CGRectMake(15, self.accountTextField.cc_bottom + 10, width - 30, 44);
    self.accountLine.frame = CGRectMake(15, self.accountTextField.cc_bottom, width - 30, 0.5);
    self.passwordTextField.frame = CGRectMake(15, self.accountTextField.cc_bottom + 10, width - 30, 44);
    self.passwordLine.frame = CGRectMake(15, self.passwordTextField.cc_bottom, width - 30, 0.5);
    self.confirmButton.frame = CGRectMake(15, self.passwordTextField.cc_bottom + 60, width - 30, 44);
    self.registButton.frame = CGRectMake((width - 200) / 2, height - self.view.safeAreaInsets.bottom - 20 - 44, 200, 20);
}

#pragma mark - Net
- (void)login {
    [SVProgressHUD showProgress:-1];
    
    self.loginRequest.account = self.accountTextField.text;
    self.loginRequest.password = self.passwordTextField.text;
    
    [self.loginRequest sendRequest:^(CCUser *user) {
        [SVProgressHUD dismiss];
        if (self.autoLogin) {
            [self popViewControllers:2 animated:YES];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)regist {
    [SVProgressHUD showProgress:-1];
    self.registRequest.account = self.accountTextField.text;
    self.registRequest.password = self.passwordTextField.text;
    
    [self.registRequest sendRequest:^(NSDictionary *user) {
        self.autoLogin = YES;
        [self login];
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - Action
- (void)confirmAction:(UIButton *)sender {
    if (!self.accountTextField.text.length) {
        [SVProgressHUD showInfoWithStatus:@"请输入用户名"];
        return;
    }
    if (!self.passwordTextField.text.length) {
        [SVProgressHUD showInfoWithStatus:@"请输入密码"];
        return;
    }
 
    switch (self.action) {
        case CCAccountActionLogin:
            [self login];
            break;
        default:
            [self regist];
            break;
    }
}

- (void)registAction:(UIButton *)sender {
    CCLoginRegisterController *regist = [[CCLoginRegisterController alloc] initWithAction:CCAccountActionRegister];
    [self.navigationController pushViewController:regist animated:YES];
}

#pragma mark - Method
- (void)popViewControllers:(NSUInteger)count animated:(BOOL)animated {
    if (self.navigationController && count) {
        NSInteger viewControllers = self.navigationController.viewControllers.count;
        if (viewControllers >= count + 1) {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:viewControllers - count - 1]
                                                  animated:animated];
        } else {
            [self.navigationController popToRootViewControllerAnimated:animated];
        }
    }
}

#pragma mark - Set
- (void)setAction:(CCAccountAction)action {
    _action = action;
    
    BOOL login = action == CCAccountActionLogin;
    self.titleLabel.text = login ? @"请登录您的账号" : @"请注册您的账号";
    [self.confirmButton setTitle:login ? @"登录" : @"注册" forState:UIControlStateNormal];
    self.registButton.hidden = !login;
}

#pragma mark - Get
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColor.secondaryLabelColor;
        _titleLabel.font = UIFontMake(14);
    }
    return _titleLabel;
}

- (UITextField *)accountTextField {
    if (!_accountTextField) {
        _accountTextField = [[UITextField alloc] init];
        _accountTextField.font = UIFontMake(15);
        _accountTextField.placeholder = @"请输入用户名";
    }
    return _accountTextField;
}

- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] init];
        _passwordTextField.font = UIFontMake(15);
        _passwordTextField.placeholder = @"请输入密码";
    }
    return _passwordTextField;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc] init];
        _confirmButton.titleLabel.font = UIFontMake(15);
        _confirmButton.backgroundColor = UIColor.systemBlueColor;
        _confirmButton.layer.cornerRadius = 8;
        [_confirmButton setTitleColor:UIColor.systemBackgroundColor forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (UIButton *)registButton {
    if (!_registButton) {
        _registButton = [[UIButton alloc] init];
        _registButton.titleLabel.font = UIFontMake(12);
        [_registButton setTitle:@"立即注册" forState:UIControlStateNormal];
        [_registButton setTitleColor:UIColor.systemBlueColor forState:UIControlStateNormal];
        [_registButton addTarget:self action:@selector(registAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registButton;
}

- (UIView *)accountLine {
    if (!_accountLine) {
        _accountLine = [[UIView alloc] init];
        _accountLine.backgroundColor = UIColor.separatorColor;
    }
    return _accountLine;
}

- (UIView *)passwordLine {
    if (!_passwordLine) {
        _passwordLine = [[UIView alloc] init];
        _passwordLine.backgroundColor = UIColor.separatorColor;
    }
    return _passwordLine;
}

- (CCUserLoginRequest *)loginRequest {
    if (!_loginRequest) {
        _loginRequest = [[CCUserLoginRequest alloc] init];
    }
    return _loginRequest;
}

- (CCUserRegistRequest *)registRequest {
    if (!_registRequest) {
        _registRequest = [[CCUserRegistRequest alloc] init];
    }
    return _registRequest;
}

@end
