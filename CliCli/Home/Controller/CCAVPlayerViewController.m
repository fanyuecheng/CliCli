//
//  CCAVPlayerViewController.m
//  CliCli
//
//  Created by Fancy 
//

#import "CCAVPlayerViewController.h"

@interface CCAVPlayerViewController ()

@end

@implementation CCAVPlayerViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addObserver:self forKeyPath:@"readyForDisplay" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self removeObserver:self forKeyPath:@"readyForDisplay"];
}

- (instancetype)initWithURLString:(NSString *)URLString {
    if (self = [super init]) {
        self.URLString = URLString;
    }
    return self;
}

#pragma mark - 方向
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}

#pragma mark - Observe
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"readyForDisplay"]) {
        BOOL readyForDisplay = [change[NSKeyValueChangeNewKey] boolValue];
        !self.readyForDisplayBlock ? : self.readyForDisplayBlock(readyForDisplay);
    }
}

#pragma mark - Set
- (void)setLocalPath:(NSString *)localPath {
    _localPath = localPath;
    NSURL *url = [NSURL fileURLWithPath:localPath];
    [self setPlayURL:url];
}

- (void)setURLString:(NSString *)URLString {
    _URLString = URLString;
    NSURL *url = [NSURL URLWithString:[[URLString stringByRemovingPercentEncoding] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [self setPlayURL:url];
}

- (void)setPlayURL:(NSURL *)url {
    if (url) {
        AVAsset *asset = [AVAsset assetWithURL:url];
        NSArray *keys = @[
              @"tracks",
              @"duration",
              @"commonMetadata",
              @"availableMediaCharacteristicsWithMediaSelectionOptions"
          ];
        AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset automaticallyLoadedAssetKeys:keys];
        AVPlayer *player = [AVPlayer playerWithPlayerItem:item];
        self.player = player;
        [player play];
    }
}

@end
