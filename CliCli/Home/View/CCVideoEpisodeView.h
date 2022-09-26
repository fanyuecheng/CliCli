//
//  CCVideoEpisodeView.h
//  CliCli
//
//  Created by Fancy 
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CCVideoEpisode;
@interface CCVideoEpisodeView : UIView

@property (nonatomic, assign) BOOL vertical;
@property (nonatomic, copy)   NSArray <CCVideoEpisode *>*episodeArray;
@property (nonatomic, copy)   void (^episodeBlock)(NSInteger index);

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
