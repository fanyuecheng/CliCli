//
//  CCVideoInfoController.m
//  CliCli
//
//  Created by Fancy 
//

#import "CCVideoInfoController.h"
#import "CCVideoOperationView.h"
#import "CCVideoEpisodeView.h"
#import "CCModalView.h"
#import "CCVideoCollectionRequest.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface CCVideoInfoController ()

@property (nonatomic, strong) CCVideoOperationView *operationView;
@property (nonatomic, strong) CCVideoEpisodeView   *episodeView;
@property (nonatomic, strong) CCVideoEpisodeView   *episodeModalView;
@property (nonatomic, strong) CCModalView          *modalView;
@property (nonatomic, strong) UITextView           *infoView;

@property (nonatomic, strong) CCVideoCollectionRequest *collectionRequest;

@end

@implementation CCVideoInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
     
}

- (void)initTableView {
    [super initTableView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Method
- (void)showVideoInfo {
    self.modalView.customView = self.infoView;
    self.modalView.titleLabel.text = self.detail.vod_info.vod_name;
    self.modalView.frame = CGRectMake(0, self.view.cc_height, self.view.cc_width, self.view.cc_height);
    [self.view addSubview:self.modalView];
    [UIView animateWithDuration:.25 animations:^{
        self.modalView.cc_top = 0;
    } completion:^(BOOL finished) {
        self.tableView.scrollEnabled = NO;
    }];
}

- (void)showVideoEpisode {
    self.modalView.customView = self.episodeModalView;
    self.modalView.titleLabel.text = @"选集";
    self.modalView.frame = CGRectMake(0, self.view.cc_height, self.view.cc_width, self.view.cc_height);
    [self.view addSubview:self.modalView];
    [UIView animateWithDuration:.25 animations:^{
        self.modalView.cc_top = 0;
    } completion:^(BOOL finished) {
        self.tableView.scrollEnabled = NO;
    }];
}

- (void)collectionVideo {
    self.collectionRequest.operation = self.detail.is_collect ? CCVideoCollectionOperationCancel : CCVideoCollectionOperationAdd;
    
    [SVProgressHUD showProgress:-1];
    [self.collectionRequest sendRequest:^(id  _Nonnull response) {
        [SVProgressHUD dismiss];
        self.detail.is_collect = !self.detail.is_collect;
        self.operationView.collectionButton.selected = self.detail.is_collect;
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
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

#pragma mark - Table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;//3 推荐
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellIdentifer = @"CCBaseTableViewCell";
    CCBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer];
    if (!cell) {
        cell = [[CCBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellIdentifer];
        cell.textLabel.font = UIFontMake(15);
        cell.detailTextLabel.font = UIFontMake(12);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSString *title = nil;
    NSString *detail = nil;
    UITableViewCellAccessoryType accessoryType = UITableViewCellAccessoryNone;
    switch (indexPath.section) {
        case 0:
            title = self.detail.vod_info.vod_name;
            detail = @"简介";
            accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 1:
            title = @"选集";
            detail = self.detail.vod_info.vod_remarks;
            accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        default:
            title = @"推荐";
            break;
    }
    cell.textLabel.text = title;
    cell.detailTextLabel.text = detail;
    cell.accessoryType = accessoryType;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 50;
            break;
        case 1:
            return 66;
            break;
        case 2:
             
            break;
        default:
            break;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.operationView;
            break;
        case 1:
            return self.episodeView;
            break;
        case 2:
             
            break;
        default:
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
            [self showVideoInfo];
            break;
        case 1:
            [self showVideoEpisode];
            break;
        default:
            break;
    }
}

#pragma mark - Set
- (void)setDetail:(CCVideoDetail *)detail {
    _detail = detail;
    
    self.operationView.collectionButton.selected = detail.is_collect;
    self.episodeView.episodeArray = [detail.vod_info.vod_url_with_player.lastObject episodeArray];
    self.episodeModalView.episodeArray = [detail.vod_info.vod_url_with_player.lastObject episodeArray];
    CCVideoInfo *info = detail.vod_info;
    NSString *infoText = [NSString stringWithFormat:@"导演：%@\n主演：%@\n类型：%@\n地区：%@\n\n简介：\n%@", info.vod_director, info.vod_actor, info.vod_class, info.vod_area, info.vod_content];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 8;
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:infoText attributes:@{NSFontAttributeName : UIFontMake(13), NSForegroundColorAttributeName : UIColor.secondaryLabelColor, NSParagraphStyleAttributeName : style}];
    
    self.infoView.attributedText = attributedText;
    [self.tableView reloadData];
}

#pragma mark - Get
- (CCVideoOperationView *)operationView {
    if (!_operationView) {
        _operationView = [[CCVideoOperationView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        @weakify(self)
        _operationView.actionBlock = ^(NSInteger index) {
            @strongify(self)
            CCUser *user = [CCUser userFromLocal];
            switch (index) {
                case 0:
                    user ? [self collectionVideo] : [CCUser toLoginController:self];
                    break;
                case 1:
                    !self.downloadBlock ? : self.downloadBlock();
                    break;
                default:
                    break;
            }
        };
    }
    return _operationView;
}

- (CCVideoEpisodeView *)episodeView {
    if (!_episodeView) {
        _episodeView = [[CCVideoEpisodeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 66)];
        @weakify(self)
        _episodeView.episodeBlock = ^(NSInteger index) {
            @strongify(self)
            [self.episodeModalView reloadData];
            !self.episodeBlock ? : self.episodeBlock(index);
        };
    }
    return _episodeView;
}

- (CCVideoEpisodeView *)episodeModalView {
    if (!_episodeModalView) {
        _episodeModalView = [[CCVideoEpisodeView alloc] init];
        _episodeModalView.vertical = YES;
        @weakify(self)
        _episodeModalView.episodeBlock = ^(NSInteger index) {
            @strongify(self)
            [self.episodeView reloadData];
            !self.episodeBlock ? : self.episodeBlock(index);
        };
    }
    return _episodeModalView;
}

- (CCModalView *)modalView {
    if (!_modalView) {
        _modalView = [[CCModalView alloc] init];
        @weakify(self)
        _modalView.closeBlock = ^(CCModalView * _Nonnull view) {
            @strongify(self)
            [UIView animateWithDuration:.25 animations:^{
                view.frame = CGRectSetY(view.frame, self.view.cc_height);
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
                self.tableView.scrollEnabled = YES;
            }];
        };
    }
    return _modalView;
}

- (UITextView *)infoView {
    if (!_infoView) {
        _infoView = [[UITextView alloc] init];
        _infoView.editable = NO;
        _infoView.textContainerInset = UIEdgeInsetsMake(15, 10, 25, 10);
        _infoView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return _infoView;
}
 
- (CCVideoCollectionRequest *)collectionRequest {
    if (!_collectionRequest) {
        _collectionRequest = [[CCVideoCollectionRequest alloc] init];
        _collectionRequest.videoId = self.detail.vod_info.vod_id;
    }
    return _collectionRequest;
}

@end
