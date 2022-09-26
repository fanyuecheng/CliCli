//
//  CCVideoHistory.h
//  CliCli
//
//  Created by Fancy 
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCVideoHistory : NSObject

@property (nonatomic, assign) NSInteger historyId;
@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, assign) NSInteger vod_id;
@property (nonatomic, assign) NSInteger last_play_time;
@property (nonatomic, assign) NSInteger watch_time;
@property (nonatomic, assign) NSInteger total_time;
@property (nonatomic, assign) NSInteger video_section_index;
@property (nonatomic, copy)   NSString *video_section_name;
@property (nonatomic, copy)   NSString *player_code;
@property (nonatomic, copy)   NSString *vod_name;
@property (nonatomic, copy)   NSString *vod_pic;

@end

NS_ASSUME_NONNULL_END
