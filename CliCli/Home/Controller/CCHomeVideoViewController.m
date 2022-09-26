//
//  CCHomeVideoViewController.m
//  CliCli
//
//  Created by Fancy 
//

#import "CCHomeVideoViewController.h"
#import "CCHomeRecommendRequest.h"
#import "CCIconFont.h"
#import "CCVideoCell.h"
#import "CCVideoFilterView.h"
#import "CCHomeCategoryRequest.h"
#import <MJRefresh/MJRefresh.h>
#import "CCVideoDetailViewController.h"

@interface CCHomeVideoViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) CCVideoFilterView *filterView;
@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, strong) UIButton          *topButton;

@property (nonatomic, strong) NSMutableArray    *dataSource;
@property (nonatomic, assign) NSInteger         totalPage;
@property (nonatomic, assign) CGFloat           offsetY;

@property (nonatomic, strong) CCHomeCategoryRequest  *categoryRequest;
@property (nonatomic, strong) CCHomeRecommendRequest *recommendRequest;

@end

@implementation CCHomeVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self requestData];
}

- (void)initSubviews {
    [super initSubviews];
    
    if (!self.navigation.isCustom) {
        [self.view addSubview:self.filterView];
    }
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.topButton];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat width = self.view.cc_width;
    CGFloat height = self.view.cc_height;

    _filterView.frame = CGRectSetY(_filterView.bounds, -self.offsetY);
    self.collectionView.frame = CGRectMake(0, _filterView.cc_bottom, width, height - _filterView.cc_bottom);
    self.topButton.frame = CGRectMake(width - 15 - 40, height - 70, 40, 40);
}
 
#pragma mark - Net
- (void)requestData {
    if (!self.navigation) {
        return;
    }
    if (self.navigation.isCustom) {
        [self.recommendRequest sendRequest:^(NSArray <CCVideoGroup *>*data) {
            [self.collectionView.mj_header endRefreshing];
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:data];
            [self.collectionView reloadData];
        } failure:^(NSError * _Nonnull error) {
            [self.collectionView.mj_header endRefreshing];
            [self showEmptyViewWithText:@"网络错误" buttonTitle:@"点击刷新" buttonAction:@selector(requestData)];
        }];
    } else {
        [self.categoryRequest sendRequest:^(NSDictionary *data) {
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            self.totalPage = [[data allKeys].firstObject integerValue];
            if (self.categoryRequest.page == 1) {
                [self.dataSource removeAllObjects];
                [self.collectionView setContentOffset:CGPointZero animated:NO];
            }
            [self.dataSource addObjectsFromArray:[data allValues].firstObject];
            [self.collectionView reloadData];
        } failure:^(NSError * _Nonnull error) {
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            [self showEmptyViewWithText:@"网络错误" buttonTitle:@"点击刷新" buttonAction:@selector(requestData)];
        }];
    }
}

#pragma mark - Action
- (void)topAction:(UIButton *)sender {
    [self.collectionView setContentOffset:CGPointZero animated:YES];
    sender.alpha = 0;
}

#pragma mark - JXPagerViewListViewDelegate
 
- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.collectionView;
}
 
- (void)listViewDidScrollCallback:(void (^)(UIScrollView *scrollView))callback {
    
}

#pragma mark - Collection
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.navigation.isCustom ? self.dataSource.count : 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.navigation.isCustom ? ((CCVideoGroup *)self.dataSource[section]).vlist.count : self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CCVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CCVideoCell" forIndexPath:indexPath];
    CCVideo *video = self.navigation.isCustom ? ((CCVideoGroup *)self.dataSource[indexPath.section]).vlist[indexPath.row] : self.dataSource[indexPath.row];
    cell.video = video;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (self.navigation.isCustom && [kind isEqualToString:UICollectionElementKindSectionHeader])  {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionElementKindSectionHeader" forIndexPath:indexPath];
        UILabel *label = [header viewWithTag:1000];
        if (!label) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, header.cc_width - 30, header.cc_height)];
            label.tag = 1000;
            label.font = UIFontMake(14);
            [header addSubview:label];
        }
        label.text = ((CCVideoGroup *)self.dataSource[indexPath.section]).name;
        
        return header;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    CCVideo *video = self.navigation.isCustom ? ((CCVideoGroup *)self.dataSource[indexPath.section]).vlist[indexPath.row] : self.dataSource[indexPath.row];
    CCVideoDetailViewController *detail = [[CCVideoDetailViewController alloc] initWithVideoId:video.vod_id];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.navigation.isCustom) {
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY >= 0) {
            self.offsetY = offsetY;
        }
    }
}

#pragma mark - Get
- (CCVideoFilterView *)filterView {
    if (!_filterView) {
        _filterView = [[CCVideoFilterView alloc] initWithType:self.navigation.type_extend];
        [_filterView sizeToFit];
        @weakify(self)
        _filterView.filterBlock = ^(NSInteger index, NSString * _Nonnull value) {
            @strongify(self)
            switch (index) {
                case 1:
                    self.categoryRequest.type = value;
                    break;
                case 2:
                    self.categoryRequest.area = value;
                    break;
                case 3:
                    self.categoryRequest.language = value;
                    break;
                case 4:
                    self.categoryRequest.year = value;
                    break;
                default:
                    break;
            }
            self.categoryRequest.page = 1;
            [self requestData];
        };
    }
    return _filterView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 8;
        layout.minimumInteritemSpacing = 8;
        layout.sectionInset = UIEdgeInsetsMake(self.navigation.isCustom ? 5 : 15, 15, 30, 15);
        CGFloat itemWidth = floor((SCREEN_WIDTH - 46) / 3);
        layout.itemSize = CGSizeMake(itemWidth, itemWidth / 3 * 4);
        layout.headerReferenceSize = self.navigation.isCustom ? CGSizeMake(SCREEN_WIDTH, 30) : CGSizeZero;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.clearColor;
        [_collectionView registerClass:[CCVideoCell class] forCellWithReuseIdentifier:@"CCVideoCell"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionElementKindSectionHeader"];
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        @weakify(self)
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            if (!self.navigation.isCustom) {
                self.categoryRequest.page = 1;
                [self.collectionView.mj_footer resetNoMoreData];
            }
            [self requestData];
        }];
        
        _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self)
            if (self.categoryRequest.page >= self.totalPage) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            } else {
                self.categoryRequest.page ++;
                [self requestData];
            }
        }];
        _collectionView.mj_footer.hidden = self.navigation.isCustom;
    }
    return _collectionView;
}

- (UIButton *)topButton {
    if (!_topButton) {
        _topButton = [[UIButton alloc] init];
        _topButton.titleLabel.font = [UIFont fontWithName:@"iconfont" size:20];
        [_topButton setTitle:[CCIconFont topFont].unicode forState:UIControlStateNormal];
        [_topButton setTitleColor:UIColor.labelColor forState:UIControlStateNormal];
        _topButton.layer.cornerRadius = 20;
        _topButton.backgroundColor = UIColor.systemGray6Color;
        [_topButton addTarget:self action:@selector(topAction:) forControlEvents:UIControlEventTouchUpInside];
        _topButton.alpha = 0;
    }
    return _topButton;
}

- (CCHomeRecommendRequest *)recommendRequest {
    if (!_recommendRequest) {
        _recommendRequest = [[CCHomeRecommendRequest alloc] init];
    }
    return _recommendRequest;
}
 
- (CCHomeCategoryRequest *)categoryRequest {
    if (!_categoryRequest) {
        _categoryRequest = [[CCHomeCategoryRequest alloc] init];
    }
    return _categoryRequest;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)setNavigation:(CCVideoNavigation *)navigation {
    _navigation = navigation;
    if (navigation.type_id) {
       self.categoryRequest.tid = navigation.type_id;
    }
}

#pragma mark - Set
- (void)setOffsetY:(CGFloat)offsetY {
    if (self.filterView.cc_height - offsetY >= 0) {
        _offsetY = offsetY;
        self.topButton.alpha = 0;
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    } else {
        self.topButton.alpha = 1;
    }
}

@end
