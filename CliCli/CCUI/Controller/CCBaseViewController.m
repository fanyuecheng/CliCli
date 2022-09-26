//
//  CCBaseViewController.m
//  CCUI
//
//  Created by Fancy
//

#import "CCBaseViewController.h"

@interface CCBaseViewController ()

@end

@implementation CCBaseViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self didInitialize];
    }
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self didInitialize];
    }
    return self;
}

- (void)didInitialize {
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.view.backgroundColor) {
        self.view.backgroundColor = UIColor.systemBackgroundColor;
    }
    
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNavigationItems];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self layoutEmptyView];
}

@synthesize emptyView = _emptyView;

- (CCEmptyView *)emptyView {
    if (!_emptyView && self.isViewLoaded) {
        _emptyView = [[CCEmptyView alloc] initWithFrame:self.view.bounds];
    }
    return _emptyView;
}

- (void)showEmptyView {
    [self.view addSubview:self.emptyView];
}

- (void)hideEmptyView {
    [_emptyView removeFromSuperview];
}

- (void)layoutEmptyView {
    if (_emptyView) {
        BOOL viewDidLoad = self.emptyView.superview && [self isViewLoaded];
        if (viewDidLoad) {
            self.emptyView.frame = self.view.bounds;
        }
    }
}

- (void)showEmptyViewWithLoading {
    [self showEmptyView];
    [self.emptyView showLoading];
}

- (void)showEmptyViewWithText:(nullable NSString *)text
                  buttonTitle:(nullable NSString *)buttonTitle
                 buttonAction:(nullable SEL)action {
    [self showEmptyView];
    [self.emptyView showText:text actionTitle:buttonTitle];
    [self.emptyView.actionButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
}

@end

@implementation CCBaseViewController (CCUISubclassingHooks)

- (void)initSubviews {
    
}

- (void)setupNavigationItems {
     
}

@end
