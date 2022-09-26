//
//  CCUser.m
//  CliCli
//
//  Created by Fancy 
//

#import "CCUser.h"
#import "CCLoginRegisterController.h"

#define CC_USER_DATA_PATH   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"CCUser.data"]

static CCUser *currentUser = nil;

@implementation CCUser

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.user_id forKey:@"user_id"];
    [aCoder encodeInteger:self.user_points forKey:@"user_points"];
    [aCoder encodeInteger:self.user_type forKey:@"user_type"];
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.user_name forKey:@"user_name"];
    [aCoder encodeObject:self.user_email forKey:@"user_email"];
    [aCoder encodeObject:self.user_nick_name forKey:@"user_nick_name"];
    [aCoder encodeObject:self.user_end_time forKey:@"user_end_time"];
    [aCoder encodeObject:self.user_portrait_origin forKey:@"user_portrait_origin"];
    [aCoder encodeObject:self.user_portrait forKey:@"user_portrait"];
    [aCoder encodeObject:self.invite_code forKey:@"invite_code"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.user_id = [aDecoder decodeIntegerForKey:@"user_id"];
        self.user_points = [aDecoder decodeIntegerForKey:@"user_points"];
        self.user_type = [aDecoder decodeIntegerForKey:@"user_type"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self.user_name = [aDecoder decodeObjectForKey:@"user_name"];
        self.user_email = [aDecoder decodeObjectForKey:@"user_email"];
        self.user_nick_name = [aDecoder decodeObjectForKey:@"user_nick_name"];
        self.user_end_time = [aDecoder decodeObjectForKey:@"user_end_time"];
        self.user_portrait_origin = [aDecoder decodeObjectForKey:@"user_portrait_origin"];
        self.user_portrait = [aDecoder decodeObjectForKey:@"user_portrait"];
        self.invite_code = [aDecoder decodeObjectForKey:@"invite_code"];
    }
    return self;
}

- (BOOL)saveToLocal {
    NSError *error = nil;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self requiringSecureCoding:YES error:&error];
    if (error) {
        return NO;
    } else {
        return [data writeToFile:CC_USER_DATA_PATH atomically:YES];
    }
}

+ (BOOL)deleteFromLocal {
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if ([defaultManager isDeletableFileAtPath:CC_USER_DATA_PATH]) {
        if (currentUser) {
            currentUser = nil;
        }
        return [defaultManager removeItemAtPath:CC_USER_DATA_PATH error:nil];
    } else {
        return YES;
    }
}

+ (CCUser *)userFromLocal {
    if (currentUser) {
        return currentUser;
    }
    CCUser *user = nil;
    NSData *data = [NSData dataWithContentsOfFile:CC_USER_DATA_PATH];
    NSError *error = nil;
    user = [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithObjects:[CCUser class], [NSString class], nil] fromData:data error:&error];
    if (error) {
        return nil;
    } else {
        currentUser = user;
        return user;
    }
}

+ (void)toLoginController:(UIViewController *)vc {
    CCLoginRegisterController *login = [[CCLoginRegisterController alloc] initWithAction:CCAccountActionLogin];
    [vc.navigationController pushViewController:login animated:YES];}

@end
