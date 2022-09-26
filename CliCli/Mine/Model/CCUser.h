//
//  CCUser.h
//  CliCli
//
//  Created by Fancy 
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define CC_NOTIFICATION_LOGIN_STATUS   @"CC_NOTIFICATION_LOGIN_STATUS"

@interface CCUser : NSObject <NSSecureCoding>

@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, assign) NSInteger user_points;
@property (nonatomic, assign) NSInteger user_type;
@property (nonatomic, copy)   NSString  *token;
@property (nonatomic, copy)   NSString  *user_name;
@property (nonatomic, copy)   NSString  *user_email;
@property (nonatomic, copy)   NSString  *user_nick_name;
@property (nonatomic, copy)   NSString  *user_end_time;
@property (nonatomic, copy)   NSString  *user_portrait_origin;
@property (nonatomic, copy)   NSString  *user_portrait;
@property (nonatomic, copy)   NSString  *invite_code;

- (BOOL)saveToLocal;
+ (BOOL)deleteFromLocal;
+ (CCUser *)userFromLocal;
+ (void)toLoginController:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
