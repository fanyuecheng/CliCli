//
//  CCRequest.h
//  CliCli
//
//  Created by Fancy 
//

#import <YTKNetwork/YTKNetwork.h>
#import <YYModel/YYModel.h>
#import "CCAPIHeader.h"
#import "CCUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCRequest : YTKRequest

- (void)sendRequest:(nullable void (^)(id response))success
            failure:(nullable void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
