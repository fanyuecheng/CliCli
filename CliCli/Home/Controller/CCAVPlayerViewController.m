//
//  CCAVPlayerViewController.m
//  CliCli
//
//  Created by Fancy
//

#import "CCAVPlayerViewController.h"
#import <KTVHTTPCache/KTVHTTPCache.h>

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

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#if defined(DEBUG)
        [KTVHTTPCache logSetConsoleLogEnable:YES];
#endif
        [KTVHTTPCache cacheSetMaxCacheLength:2000 * 1024 * 1024];
        NSError *error = nil;
        [KTVHTTPCache proxyStart:&error];
        if (error) {
            NSLog(@"Proxy Start Failure, %@", error);
        } else {
            NSLog(@"Proxy Start Success");
        }
        [KTVHTTPCache encodeSetURLConverter:^NSURL *(NSURL *URL) {
            NSLog(@"URL Filter reviced URL : %@", URL);
            return URL;
        }];
        [KTVHTTPCache downloadSetUnacceptableContentTypeDisposer:^BOOL(NSURL *URL, NSString *contentType) {
            NSLog(@"Unsupport Content-Type Filter reviced URL : %@, %@", URL, contentType);
            return NO;
        }];
    });
}

- (void)seekToTimeWithMillisecond:(double)millisecond {
    CMTimeScale timescale = self.player.currentItem.asset.duration.timescale;
    CMTime cmtime = CMTimeMakeWithSeconds(millisecond / 1000.0, timescale);
    [self seekToTime:cmtime];
}

- (void)seekToTime:(CMTime)time {
    [self.player seekToTime:time];
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
        NSString *urlString = [[url.absoluteString stringByRemovingPercentEncoding] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *cacheURL = [KTVHTTPCache proxyURLWithOriginalURL:[NSURL URLWithString:urlString]];
        AVAsset *asset = [AVAsset assetWithURL:cacheURL];
        NSArray *keys = @[
              @"tracks",
              @"duration",
              @"commonMetadata",
              @"availableMediaCharacteristicsWithMediaSelectionOptions"
          ];
        [self.player pause];
        self.player = nil;
        AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset automaticallyLoadedAssetKeys:keys];
        AVPlayer *player = [AVPlayer playerWithPlayerItem:item];
        self.player = player;
        [player play];
    }
}

@end
