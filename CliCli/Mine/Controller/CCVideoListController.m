//
//  CCVideoListController.m
//  CliCli
//
//  Created by Fancy
//

#import "CCVideoListController.h"
#import "CCVideoListRequest.h"
#import "CCVideoClearRequest.h"
#import "CCVideoListCell.h"
#import "CCVideoDetailViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface CCVideoListController ()

@property (nonatomic, assign) CCVideoListType     type;
@property (nonatomic, strong) NSMutableArray      *dataSource;
@property (nonatomic, strong) CCVideoListRequest  *dataRequest;
@property (nonatomic, strong) CCVideoClearRequest *clearRequest;

@end

@implementation CCVideoListController

- (instancetype)initWithType:(CCVideoListType)type {
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestData];
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    
    self.navigationItem.title = self.type == CCVideoListTypeHistory ? @"观看历史" : @"我的收藏";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(clearAction:)];
}

- (void)initTableView {
    [super initTableView];
    
    self.tableView.rowHeight = SCREEN_WIDTH / 6 + 20;
    [self.tableView registerClass:[CCVideoListCell class] forCellReuseIdentifier:@"CCVideoListCell"];
    
    @weakify(self)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        self.dataRequest.page = 1;
        [self.tableView.mj_footer resetNoMoreData];
        [self requestData];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        @strongify(self)
        self.dataRequest.page ++;
        [self requestData];
    }];
}

#pragma mark - Net
- (void)requestData {
    [self showEmptyViewWithLoading];
    
    [self.dataRequest sendRequest:^(NSArray *response) {
        [self hideEmptyView];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.dataRequest.page == 1) {
            [self.dataSource removeAllObjects];
        }
        if (response.count) {
            [self.dataSource addObjectsFromArray:response];
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (self.dataSource.count == 0) {
            [self showEmptyViewWithText:self.type == CCVideoListTypeHistory ? @"没有任何观看历史" : @"您还没有任何收藏" buttonTitle:nil buttonAction:NULL];
        }
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self showEmptyViewWithText:@"网络错误" buttonTitle:@"点击刷新" buttonAction:@selector(requestData)];
    }];
}

- (void)clearVideoList {
    [SVProgressHUD showProgress:-1];
    [self.clearRequest sendRequest:^(id  _Nonnull response) {
        [SVProgressHUD dismiss];
        [self.dataSource removeAllObjects];
        [self.tableView reloadData];
        [self showEmptyViewWithText:self.type == CCVideoListTypeHistory ? @"没有任何观看历史" : @"您还没有任何收藏" buttonTitle:nil buttonAction:NULL];
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - Action
- (void)clearAction:(id)sender {
    if (self.dataSource.count) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.type == CCVideoListTypeHistory ? @"确定要清空观看历史吗？" : @"确定要清空收藏的视频吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
         
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        @weakify(self)
        UIAlertAction *clearAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            @strongify(self)
            [self clearVideoList];
        }];
        [alert addAction:cancelAction];
        [alert addAction:clearAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - TableView
 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CCVideoListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CCVideoListCell" forIndexPath:indexPath];
    if (self.type == CCVideoListTypeHistory) {
        cell.history = [self.dataSource cc_safeObjectAtIndex:indexPath.row];
    } else {
        cell.video = [self.dataSource cc_safeObjectAtIndex:indexPath.row];
    }
 
    return cell;
}
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CCVideoInfo *video = [self.dataSource cc_safeObjectAtIndex:indexPath.row];
    CCVideoDetailViewController *detail = [[CCVideoDetailViewController alloc] initWithVideoId:video.vod_id];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - Get
- (CCVideoListRequest *)dataRequest {
    if (!_dataRequest) {
        _dataRequest = [[CCVideoListRequest alloc] init];
        _dataRequest.type = self.type;
    }
    return _dataRequest;
}

- (CCVideoClearRequest *)clearRequest {
    if (!_clearRequest) {
        _clearRequest = [[CCVideoClearRequest alloc] init];
        _clearRequest.type = self.type;
    }
    return _clearRequest;
}
 
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
