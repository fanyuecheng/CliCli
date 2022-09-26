//
//  CCVideoComment.h
//  CliCli
//
//  Created by Fancy 
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCVideoComment : NSObject

@property (nonatomic, assign) NSInteger comment_id;
@property (nonatomic, assign) NSInteger comment_mid;
@property (nonatomic, assign) NSInteger comment_rid;
@property (nonatomic, assign) NSInteger comment_pid;
@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, assign) NSInteger comment_status;
@property (nonatomic, assign) NSInteger comment_ip;
@property (nonatomic, assign) NSInteger comment_up;
@property (nonatomic, assign) NSInteger comment_down;
@property (nonatomic, assign) NSInteger comment_reply;
@property (nonatomic, assign) NSInteger comment_report;
@property (nonatomic, assign) NSInteger reply_count;
@property (nonatomic, assign) NSInteger reply_num;
@property (nonatomic, assign) BOOL user_is_vip;
@property (nonatomic, copy)   NSString *comment_name;
@property (nonatomic, copy)   NSString *comment_time;
@property (nonatomic, copy)   NSString *comment_content;
@property (nonatomic, copy)   NSString *user_name;
@property (nonatomic, copy)   NSString *user_portrait;
@property (nonatomic, copy)   NSArray <CCVideoComment *> *reply_list;
 
@property (nonatomic, assign, readonly) CGFloat rowHeight;

@end

NS_ASSUME_NONNULL_END
