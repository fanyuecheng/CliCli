//
//  CCVideoDetailViewController.m
//  CliCli
//
//  Created by Fancy 
//

#import "CCVideoDetailViewController.h"
#import "CCAVPlayerViewController.h"
#import "CCVideoInfoController.h"
#import "CCVideoCommentController.h"
#import "CCVideoDetailRequest.h"
#import "CCVideoHistorySyncRequest.h"
#import "CCVideoDownloadManager.h"
#import "JXCategoryView/JXCategoryView.h"
#import "JXPagingView/JXPagerListRefreshView.h"
#import "SVProgressHUD/SVProgressHUD.h"
 
@interface CCVideoDetailViewController () <JXPagerViewDelegate>

@property (nonatomic, assign) NSInteger     videoId;
@property (nonatomic, strong) CCVideoDetail *detail;
@property (nonatomic, strong) CCVideoEpisode *episode;
@property (nonatomic, strong) CCAVPlayerViewController *playerController;
@property (nonatomic, strong) CCVideoDetailRequest     *detailRequest;
@property (nonatomic, strong) CCVideoHistorySyncRequest *syncRequest;

@property (nonatomic, strong) JXCategoryTitleView    *categoryView;
@property (nonatomic, strong) JXPagerListRefreshView *contentView;

@property (nonatomic, strong) CCVideoInfoController    *infoController;
@property (nonatomic, strong) CCVideoCommentController *commentController;

@end

@implementation CCVideoDetailViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self syncHistory];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.playerController.player pause];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.playerController.player play];
}

- (instancetype)initWithVideoId:(NSInteger)videoId {
    if (self = [super init]) {
        self.videoId = videoId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     
    [self requestData];
}

- (void)initSubviews {
    [super initSubviews];
    
    [self addChildViewController:self.playerController];
    [self.view addSubview:self.playerController.view];
    [self.playerController didMoveToParentViewController:self];
    
    [self.view addSubview:self.contentView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat width = self.view.cc_width;
    CGFloat height = self.view.cc_height;
    CGFloat navigationBarBottom = self.navigationController.navigationBar.cc_bottom;
    
    if (!CGRectEqualToRect(CGRectZero, self.playerController.videoBounds) && CGRectGetWidth(self.playerController.videoBounds) <= width) {
        self.playerController.view.frame = CGRectMake(0, navigationBarBottom, width, CGRectGetHeight(self.playerController.videoBounds));
    }
    self.contentView.frame = CGRectMake(0, self.playerController.view.cc_bottom, width, height - self.playerController.view.cc_bottom);
}

#pragma mark - Net
- (void)requestData {
    [self showEmptyViewWithLoading];
    [self.detailRequest sendRequest:^(CCVideoDetail *response) {
        self.detail = response;
    } failure:^(NSError * _Nonnull error) {
        [self showEmptyViewWithText:@"网络错误" buttonTitle:@"点击刷新" buttonAction:@selector(requestData)];
    }];
}

- (void)syncHistory {
    if (self.detail && [CCUser userFromLocal]) {
        NSMutableDictionary *history = [NSMutableDictionary dictionary];
        history[@"last_play_time"] = @([[NSDate date] timeIntervalSince1970] * 1000);
        history[@"vod_id"] = @(self.detail.vod_info.vod_id);
        history[@"vod_name"] = self.detail.vod_info.vod_name;
        history[@"vod_pic"] = self.detail.vod_info.vod_pic;
        history[@"player_code"] = self.detail.vod_info.vod_play_from;
        history[@"video_section_name"] = self.episode.title;
        history[@"video_section_index"] = @([[self.detail.vod_info.vod_url_with_player.firstObject episodeArray] indexOfObject:self.episode]);
        if (isnan(CMTimeGetSeconds(self.playerController.player.currentItem.currentTime))) {
            return;
        } else {
            history[@"watch_time"] = @(CMTimeGetSeconds(self.playerController.player.currentItem.currentTime) * 1000);
        }
        if (isnan(CMTimeGetSeconds(self.playerController.player.currentItem.duration))) {
            return;
        } else {
            history[@"total_time"] = @(CMTimeGetSeconds(self.playerController.player.currentItem.duration) * 1000);
        }
        self.syncRequest.historyList = @[history];
        
        [self.syncRequest sendRequest:^(id  _Nonnull response) {
            
        } failure:^(NSError * _Nonnull error) {
            
        }];
    }
}

#pragma mark - Section

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return 0;
}
 
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return [[UIView alloc] init];
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return 40;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return self.categoryView.titles.count;
}
 
- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return self.infoController;
            break;
        case 1:
            return self.commentController;
            break;
  
        default:
             
            break;
    }
    return nil;
}

#pragma mark - Method
- (void)episodeWithIndex:(NSInteger)index
                finished:(void (^)(CCVideoEpisode *ep, NSError *error))finished {
    NSArray *urlArray = [self.detail.vod_info.vod_url_with_player.firstObject episodeArray];
    CCVideoEpisode *episode = [urlArray cc_safeObjectAtIndex:index];
    episode.selected = YES;
    NSString *localPath = [[CCVideoDownloadManager sharedInstance] localPathVideoId:self.detail.vod_info.vod_id videoName:self.detail.vod_info.vod_name epName:episode.title];
    if (localPath) {
        episode.downloaded = YES;
        episode.localPath = localPath;
        !finished ? : finished(episode, nil);
        return;
    }
    
    if (episode.parse) {
        !finished ? : finished(episode, nil);
    } else {
        [episode parse:^(CCVideoEpisode * _Nonnull ep, NSError * _Nonnull error) {
            !finished ? : finished(ep, error);
        }];
    }
}
 
#pragma mark - Set
- (void)setDetail:(CCVideoDetail *)detail {
    _detail = detail;
 
    CCVideoHistory *history = detail.vod_history;
    NSInteger index = history ? history.video_section_index : 0;
    [self episodeWithIndex:index finished:^(CCVideoEpisode *ep, NSError *error) {
        if (error) {
            [self showEmptyViewWithText:error.localizedDescription buttonTitle:@"点击重试" buttonAction:@selector(requestData)];
        } else {
            self.episode = ep;
        }
    }];
    self.infoController.detail = detail;
    self.categoryView.titles = @[@"视频", [NSString stringWithFormat:@"评论（%@）", @(detail.comment_count)]];
    [self.categoryView reloadData];
}

- (void)setEpisode:(CCVideoEpisode *)episode {
    _episode = episode;
    
    if (episode.downloaded) {
        self.playerController.localPath = episode.localPath;
    } else {
        self.playerController.URLString = episode.parse.url;
    }
}

#pragma mark - Get
- (CCVideoDetailRequest *)detailRequest {
    if (!_detailRequest) {
        if (self.videoId) {
            _detailRequest = [[CCVideoDetailRequest alloc] init];
            _detailRequest.videoId = self.videoId;
        }
    }
    return _detailRequest;
}

- (CCVideoHistorySyncRequest *)syncRequest {
    if (!_syncRequest) {
        _syncRequest = [[CCVideoHistorySyncRequest alloc] init];
    }
    return _syncRequest;
}

- (CCAVPlayerViewController *)playerController {
    if (!_playerController) {
        _playerController = [[CCAVPlayerViewController alloc] init];
        _playerController.view.hidden = YES;
        @weakify(self)
        _playerController.readyForDisplayBlock = ^(BOOL ready) {
            @strongify(self)
            if (ready) {
                [self.view setNeedsLayout];
                [self.view layoutIfNeeded];
                [self hideEmptyView];
                self.playerController.view.hidden = NO;
            }
        };
    }
    return _playerController;
}

- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _categoryView.titleColor = UIColor.secondaryLabelColor;
        _categoryView.titleSelectedColor = UIColor.labelColor;
        _categoryView.titleFont = UIFontMake(14);
        _categoryView.titleSelectedFont = UIFontBoldMake(14);
        _categoryView.titleColorGradientEnabled = YES;
        _categoryView.contentEdgeInsetLeft = 20;
        _categoryView.contentEdgeInsetRight = 20;
        _categoryView.cellSpacing = 20;
        _categoryView.averageCellSpacingEnabled = NO;
        _categoryView.titles = @[@"视频", @"评论"];
        _categoryView.listContainer = (id<JXCategoryViewListContainer>)self.contentView.listContainerView;
        
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorColor = UIColor.systemBlueColor;
        lineView.indicatorWidth = 28;
        lineView.verticalMargin = 3;
        _categoryView.indicators = @[lineView];
    }
    return _categoryView;
}

- (JXPagerListRefreshView *)contentView {
    if (!_contentView) {
        _contentView = [[JXPagerListRefreshView alloc] initWithDelegate:self];
    }
    return _contentView;
}

- (CCVideoInfoController *)infoController {
    if (!_infoController) {
        _infoController = [[CCVideoInfoController alloc] init];
        @weakify(self)
        _infoController.episodeBlock = ^(NSInteger index) {
            @strongify(self)
            [self episodeWithIndex:index finished:^(CCVideoEpisode *ep, NSError *error) {
                if (error) {
                    [self showEmptyViewWithText:@"网络异常" buttonTitle:@"点击重试" buttonAction:@selector(requestData)];
                } else {
                    self.episode = ep;
                }
            }];
        };
        
        _infoController.downloadBlock = ^{
            @strongify(self)
            CCVideoDownloadOperation *operation = [[CCVideoDownloadManager sharedInstance] downloadWithVideoId:self.detail.vod_info.vod_id videoName:self.detail.vod_info.vod_name videoURL:self.episode.parse.url epName:self.episode.title];
            if (operation) {
                [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@已加入下载", operation.name]];
            } else {
                [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@-%@已下载", self.detail.vod_info.vod_name, self.episode.title]];
            }
        };
    }
    return _infoController;
}

- (CCVideoCommentController *)commentController {
    if (!_commentController) {
        _commentController = [[CCVideoCommentController alloc] initWithVideoId:self.videoId];
    }
    return _commentController;
}

@end
