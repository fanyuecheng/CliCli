//
//  CCVideoSearchResultController.m
//  CliCli
//
//  Created by Fancy 
//

#import "CCVideoSearchResultController.h"
#import "CCVideoInfoCell.h"
#import "CCVideoDetailViewController.h"
#import <MJRefresh/MJRefresh.h>

@interface CCVideoSearchResultController ()

@property (nonatomic, assign) CCVideoSearchType    type;
@property (nonatomic, strong) CCVideoSearchRequest *request;
@property (nonatomic, strong) NSMutableArray <CCVideoInfo *>*dataSource;

@end

@implementation CCVideoSearchResultController

- (instancetype)initWithType:(CCVideoSearchType)type {
    if (self = [super init]) {
        self.type = type;
        self.request.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.searchKey) {
        [self requestData];
    }
}

- (void)initTableView {
    [super initTableView];
    
    [self.tableView registerClass:[CCVideoInfoCell class] forCellReuseIdentifier:@"CCVideoInfoCell"];
    self.tableView.rowHeight = SCREEN_WIDTH / 9 * 4 + 30;
    
    @weakify(self)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        self.request.page = 1;
        [self.tableView.mj_footer resetNoMoreData];
        [self requestData];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        @strongify(self)
        self.request.page ++;
        [self requestData];
    }];
}

#pragma mark - Net
- (void)requestData {
    if (!self.dataSource.count) {
        [self showEmptyViewWithLoading];
    }
    [self.request sendRequest:^(NSMutableArray *response) {
        [self hideEmptyView];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.request.page == 1) {
            [self.dataSource removeAllObjects];
        }
        if (response.count) {
            [self.dataSource addObjectsFromArray:response];
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (self.dataSource.count == 0) {
            [self showEmptyViewWithText:@"没有找到相关影片，请尝试更换关键词" buttonTitle:nil buttonAction:NULL];
        }
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self showEmptyViewWithText:@"网络错误" buttonTitle:@"点击刷新" buttonAction:@selector(requestData)];
    }];
}

#pragma mark - JXPagerViewListViewDelegate
 
- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.tableView;
}
 
- (void)listViewDidScrollCallback:(void (^)(UIScrollView *scrollView))callback {
    
}
 
#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CCVideoInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CCVideoInfoCell" forIndexPath:indexPath];
    cell.video = [self.dataSource cc_safeObjectAtIndex:indexPath.row];
 
    return cell;
}
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CCVideoInfo *video = [self.dataSource cc_safeObjectAtIndex:indexPath.row];
    CCVideoDetailViewController *detail = [[CCVideoDetailViewController alloc] initWithVideoId:video.vod_id];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - Set
- (void)setSearchKey:(NSString *)searchKey {
    if (searchKey.length) {
        if (![_searchKey isEqualToString:searchKey]) {
            _searchKey = searchKey;
            if ([self isViewLoaded]) {
                self.request.searchKey = searchKey;
                [self requestData];
            }
        }
    }
}

#pragma mark - Get
- (CCVideoSearchRequest *)request {
    if (!_request) {
        _request = [[CCVideoSearchRequest alloc] init];
    }
    return _request;
}

- (NSMutableArray<CCVideoInfo *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
