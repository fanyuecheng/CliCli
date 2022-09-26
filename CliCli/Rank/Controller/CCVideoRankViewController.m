//
//  CCVideoRankViewController.m
//  CliCli
//
//  Created by Fancy 
//

#import "CCVideoRankViewController.h"
#import "CCVideoRankRequest.h"
#import "CCVideoInfoCell.h"
#import "CCVideoDetailViewController.h"

@interface CCVideoRankViewController ()

@property (nonatomic, strong) CCVideoRankRequest *request;
@property (nonatomic, copy)   NSArray <CCVideoInfo *> *dataSource;

@end

@implementation CCVideoRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self requestData];
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    
    self.navigationItem.title = @"排行";
}

- (void)initTableView {
    [super initTableView];
    
    [self.tableView registerClass:[CCVideoInfoCell class] forCellReuseIdentifier:@"CCVideoInfoCell"];
    self.tableView.rowHeight = SCREEN_WIDTH / 9 * 4 + 30;
}

#pragma mark - Net
- (void)requestData {
    [self showEmptyViewWithLoading];
    
    [self.request sendRequest:^(NSArray <CCVideoInfo *>* response) {
        [self hideEmptyView];
        self.dataSource = response;
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        [self showEmptyViewWithText:@"网络错误" buttonTitle:@"点击重试" buttonAction:@selector(requestData)];
    }];
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
    cell.number = indexPath.row + 1;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CCVideoInfo *video = [self.dataSource cc_safeObjectAtIndex:indexPath.row];
    CCVideoDetailViewController *detail = [[CCVideoDetailViewController alloc] initWithVideoId:video.vod_id];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - Get
- (CCVideoRankRequest *)request {
    if (!_request) {
        _request = [[CCVideoRankRequest alloc] init];
    }
    return _request;
}

@end
