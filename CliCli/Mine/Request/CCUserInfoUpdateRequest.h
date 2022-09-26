//
//  CCUserInfoUpdateRequest.h
//  CliCli
//
//  Created by Fancy
//

#import "CCRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCUserInfoUpdateRequest : CCRequest

@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nickName;

@end

NS_ASSUME_NONNULL_END
