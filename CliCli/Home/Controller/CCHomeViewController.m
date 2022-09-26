//
//  CCHomeViewController.m
//  CliCli
//
//  Created by Fancy
//

#import "CCHomeViewController.h"
#import "CCIconFont.h"
#import "CCHomeNavigationRequest.h"
#import "CCHomeVideoViewController.h"
#import "CCVideoSearchViewController.h"
#import "JXCategoryView/JXCategoryView.h"
#import "JXPagingView/JXPagerView.h"

@interface CCHomeViewController () <JXPagerViewDelegate>

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXPagerView         *contentView;

@property (nonatomic, strong) CCHomeNavigationRequest *navigationRequest;
@property (nonatomic, strong) NSMutableArray <CCHomeVideoViewController *>*controllerArray;

@end

@implementation CCHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestNavigationData];
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    
    self.navigationItem.title = @"首页";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[CCIconFont searchFont] imageWithColor:UIColor.systemBlueColor size:20] style:UIBarButtonItemStylePlain target:self action:@selector(searchAction:)];
}

- (void)initSubviews {
    [super initSubviews];
    
    [self.view addSubview:self.categoryView];
    [self.view addSubview:self.contentView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat width = self.view.cc_width;
    CGFloat height = self.view.cc_height;
    CGFloat navigationBarBottom = self.navigationController.navigationBar.cc_bottom;
    CGFloat tabBarHeight = self.tabBarController.tabBar.cc_height;
    self.categoryView.frame = CGRectMake(0, navigationBarBottom, width, 40);
    self.contentView.frame = CGRectMake(0, self.categoryView.cc_bottom, width, height - tabBarHeight - navigationBarBottom - 40);
}

- (void)requestNavigationData {
    [self.navigationRequest sendRequest:^(NSArray *response) {
        NSMutableArray *titleArray = [NSMutableArray arrayWithArray:self.categoryView.titles];
        for (CCVideoNavigation *navigation in response ) {
            CCHomeVideoViewController *controller = [[CCHomeVideoViewController alloc] init];
            controller.navigation = navigation;
            [self.controllerArray addObject:controller];
            [titleArray addObject:navigation.type_name];
        }
        self.categoryView.titles = titleArray;
        [self.categoryView reloadData];
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - Action
- (void)searchAction:(UIButton *)sender {
    CCVideoSearchViewController *search = [[CCVideoSearchViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
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
    return [self.controllerArray cc_safeObjectAtIndex:index];
}

#pragma mark - Get

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
        _categoryView.titles = @[@"推荐"];
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

- (NSMutableArray<CCHomeVideoViewController *> *)controllerArray {
    if (!_controllerArray) {
        _controllerArray = [NSMutableArray array];
        CCHomeVideoViewController *recommend = [[CCHomeVideoViewController alloc] init];
        recommend.navigation = [CCVideoNavigation recommendNavigation];
        [_controllerArray addObject:recommend];
    }
    return _controllerArray;
}

- (CCHomeNavigationRequest *)navigationRequest {
    if (!_navigationRequest) {
        _navigationRequest = [[CCHomeNavigationRequest alloc] init];
    }
    return _navigationRequest;
}

@end
