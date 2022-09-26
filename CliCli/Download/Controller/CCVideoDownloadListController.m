//
//  CCVideoDownloadListController.m
//  CliCli
//
//  Created by Fancy 
//

#import "CCVideoDownloadListController.h"
#import "CCVideoDownloadManager.h"
#import <AVKit/AVKit.h>

@interface CCVideoDownloadListController ()

@property (nonatomic, strong) NSMutableArray <NSDictionary *> *dataSrouce;

@end

@implementation CCVideoDownloadListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)showEmptyView {
    [super showEmptyView];
    
    self.emptyView.contentView.backgroundColor = UIColor.clearColor;
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    
    self.navigationItem.title = @"我的下载";
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSrouce.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *video = self.dataSrouce[section];
    NSArray *epArray = video.allValues.firstObject;
    return epArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellIdentifer = @"CCBaseTableViewCell";
    CCBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer];
    if (!cell) {
        cell = [[CCBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifer];
        cell.textLabel.font = UIFontMake(15);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *video = self.dataSrouce[indexPath.section];
    NSArray *epArray = video.allValues.firstObject;
    cell.textLabel.text = epArray[indexPath.row];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary *video = self.dataSrouce[section];
    return video.allKeys.firstObject;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *video = self.dataSrouce[indexPath.section];
    NSString *videoName = video.allKeys.firstObject;
    NSArray *epArray = video.allValues.firstObject;
    NSString *root = [[[CCVideoDownloadManager sharedInstance] downloadRootDirectory] stringByAppendingPathComponent:videoName];
    NSURL *fileURL = [NSURL fileURLWithPath:[root stringByAppendingPathComponent:epArray[indexPath.row]]];
    AVPlayer *player = [[AVPlayer alloc] initWithURL:fileURL];
    AVPlayerViewController *playerController = [[AVPlayerViewController alloc] init];
    playerController.player = player;
    [self presentViewController:playerController animated:YES completion:nil];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIContextualAction *action = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        NSDictionary *video = self.dataSrouce[indexPath.section];
        NSString *videoName = video.allKeys.firstObject;
        NSMutableArray *epArray = video.allValues.firstObject;
        NSString *root = [[[CCVideoDownloadManager sharedInstance] downloadRootDirectory] stringByAppendingPathComponent:videoName];
        NSString *filePath = [root stringByAppendingPathComponent:epArray[indexPath.row]];
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        [epArray removeObjectAtIndex:indexPath.row];
        if (!epArray.count) {
            [self.dataSrouce removeObjectAtIndex:indexPath.section];
            [[NSFileManager defaultManager] removeItemAtPath:root error:nil];
        }
        if (!self.dataSrouce.count) {
            [self showEmptyViewWithText:@"还没有任何下载的视频" buttonTitle:nil buttonAction:nil];
        }
        [tableView reloadData];
        completionHandler(YES);
    }];
      
    UISwipeActionsConfiguration *configuration = [UISwipeActionsConfiguration configurationWithActions:@[action]];
    return configuration;
}

#pragma mark - Get

- (NSMutableArray<NSDictionary *> *)dataSrouce {
    if (!_dataSrouce) {
        NSArray *list = [[CCVideoDownloadManager sharedInstance] downloadVideoPathArray];
        if (list) {
            _dataSrouce = [NSMutableArray arrayWithArray:list];
        } else {
            _dataSrouce = [NSMutableArray array];
        }
        if (!_dataSrouce.count) {
            [self showEmptyViewWithText:@"还没有任何下载的视频" buttonTitle:nil buttonAction:nil];
        }
    }
    return _dataSrouce;
}

@end
