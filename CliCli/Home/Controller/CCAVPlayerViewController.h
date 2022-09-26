//
//  CCAVPlayerViewController.h
//  CliCli
//
//  Created by Fancy 
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCAVPlayerViewController : AVPlayerViewController

@property (nonatomic, copy) void (^readyForDisplayBlock)(BOOL b);
@property (nonatomic, copy) NSString *URLString;
@property (nonatomic, copy) NSString *localPath;

- (instancetype)initWithURLString:(NSString *)URLString;

@end

NS_ASSUME_NONNULL_END
