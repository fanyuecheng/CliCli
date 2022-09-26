//
//  CCVideo.h
//  CliCli
//
//  Created by Fancy 
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCVideo : NSObject

@property (nonatomic, assign) NSInteger type_id;
@property (nonatomic, assign) NSInteger vod_id;
@property (nonatomic, copy)   NSString  *vod_name;
@property (nonatomic, copy)   NSString  *vod_pic;
@property (nonatomic, copy)   NSString  *vod_pic_slide;
@property (nonatomic, copy)   NSString  *vod_remarks;
@property (nonatomic, strong) NSDate    *vod_time_add;

/// 收藏
@property (nonatomic, assign) NSInteger collectionId;
@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, assign) NSInteger create_time;

@end

NS_ASSUME_NONNULL_END
