//
//  CCVideoSearchViewController.m
//  CliCli
//
//  Created by Fancy 
//

#import "CCVideoSearchViewController.h"
#import "CCIconFont.h"
#import "CCVideoSearchHotRequest.h"
#import "CCVideoSearchRecordView.h"
#import "CCVideoSearchResultController.h"
#import "JXCategoryView/JXCategoryView.h"
#import "JXPagingView/JXPagerView.h"

@interface CCVideoSearchViewController () <UITextFieldDelegate, JXPagerViewDelegate>

@property (nonatomic, strong) UITextField             *textField;
@property (nonatomic, strong) CCVideoSearchRecordView *recordView;
@property (nonatomic, strong) JXCategoryTitleView     *categoryView;
@property (nonatomic, strong) JXPagerView             *contentView;
@property (nonatomic, strong) CCVideoSearchResultController *videoController;
@property (nonatomic, strong) CCVideoSearchResultController *topicController;

@property (nonatomic, strong) CCVideoSearchHotRequest *hotRequest;
@property (nonatomic, copy)   NSArray <NSString *> *hotArray;

@end

@implementation CCVideoSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     
    [self requestHotData];
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.textField];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
}

- (void)initSubviews {
    [super initSubviews];
    
    [self.view addSubview:self.categoryView];
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.recordView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat width = self.view.cc_width;
    CGFloat height = self.view.cc_height;
    CGFloat navigationBarBottom = self.navigationController.navigationBar.cc_bottom;
    
    self.categoryView.frame = CGRectMake(0, navigationBarBottom, width, 40);
    self.contentView.frame = CGRectMake(0, self.categoryView.cc_bottom, width, height - navigationBarBottom - 40);
    self.recordView.frame = CGRectMake(0, navigationBarBottom, width, height - navigationBarBottom);
}

#pragma mark - Net
- (void)requestHotData {
    [self.hotRequest sendRequest:^(NSArray <NSString *> *response) {
        self.hotArray = response;
        self.recordView.hotArray = response;
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - Acation
- (void)cancelAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Method
- (void)searchWithKey:(NSString *)key {
    if (key.length) {
        self.recordView.hidden = YES;
        [self.recordView addRecord:key];
        self.videoController.searchKey = key;
        self.topicController.searchKey = key;
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.recordView.hidden = textField.text.length != 0;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self searchWithKey:textField.text];
}
 
- (void)textFieldDidChange:(UITextField *)textField {
    self.recordView.hidden = textField.text.length != 0;
}

#pragma mark - JXPagerViewDelegate

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return 0;
}
 
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return [[UIView alloc] init];
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return 0;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return [[UIView alloc] init];
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return self.categoryView.titles.count;
}
 
- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return self.videoController;
            break;
        default:
            return self.topicController;
            break;
    }
    return nil;
}

#pragma mark - Get
- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 16 * 3 - 42, 30)];
        _textField.font = UIFontMake(14);
        _textField.layer.cornerRadius =15;
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.backgroundColor = UIColor.systemGray5Color;
        _textField.placeholder = @"请输入关键词";
        _textField.returnKeyType = UIReturnKeySearch;
        _textField.delegate = self;
        UILabel *leftView = [[UILabel alloc] init];
        leftView.text = [NSString stringWithFormat:@"  %@  ", [CCIconFont searchFont].unicode];
        leftView.textColor = UIColor.placeholderTextColor;
        leftView.font = [UIFont fontWithName:@"iconfont" size:14];
        [leftView sizeToFit];
        _textField.leftView = leftView;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (CCVideoSearchRecordView *)recordView {
    if (!_recordView) {
        _recordView = [[CCVideoSearchRecordView alloc] init];
        @weakify(self)
        _recordView.searchBlock = ^(NSString * _Nonnull key) {
            @strongify(self)
            self.textField.text = key;
            if (self.textField.isFirstResponder) {
                [self.textField endEditing:YES];
            } else {
                [self searchWithKey:key];
            }
        };
    }
    return _recordView;
}

- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] init];
        _categoryView.titleColor = UIColor.secondaryLabelColor;
        _categoryView.titleSelectedColor = UIColor.labelColor;
        _categoryView.titleFont = UIFontMake(14);
        _categoryView.titleSelectedFont = UIFontBoldMake(14);
        _categoryView.titleColorGradientEnabled = YES;
        _categoryView.contentEdgeInsetLeft = 15;
        _categoryView.contentEdgeInsetRight = 15;
        _categoryView.cellSpacing = 10;
        _categoryView.cellWidthIncrement = 20;
        _categoryView.averageCellSpacingEnabled = NO;
        _categoryView.titles = @[@"影视", @"专辑"];
        _categoryView.listContainer = (id<JXCategoryViewListContainer>)self.contentView.listContainerView;
        
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorColor = UIColor.systemBlueColor;
        lineView.indicatorWidth = 28;
        lineView.verticalMargin = 3;
        _categoryView.indicators = @[lineView];
    }
    return _categoryView;
}

- (JXPagerView *)contentView {
    if (!_contentView) {
        _contentView = [[JXPagerView alloc] initWithDelegate:self];
        _contentView.mainTableView.bounces = NO;
    }
    return _contentView;
}

- (CCVideoSearchResultController *)videoController {
    if (!_videoController) {
        _videoController = [[CCVideoSearchResultController alloc] initWithType:CCVideoSearchTypeDefault];
    }
    return _videoController;
}

- (CCVideoSearchResultController *)topicController {
    if (!_topicController) {
        _topicController = [[CCVideoSearchResultController alloc] initWithType:CCVideoSearchTypeCollection];
    }
    return _topicController;
}

- (CCVideoSearchHotRequest *)hotRequest {
    if (!_hotRequest) {
        _hotRequest = [[CCVideoSearchHotRequest alloc] init];
    }
    return _hotRequest;
}

@end
