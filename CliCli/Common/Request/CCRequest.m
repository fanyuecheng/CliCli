//
//  CCRequest.m
//  CliCli
//
//  Created by Fancy 
//

#import "CCRequest.h"
#import <SVProgressHUD/SVProgressHUD.h>

@implementation CCRequest

- (instancetype)init {
    if (self = [super init]) {
        [self converContentTypeConfig];
    }
    return self;
}

- (void)converContentTypeConfig {
    YTKNetworkAgent *agent = [YTKNetworkAgent sharedAgent];
    NSSet *acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", @"text/css", nil];
    NSString *keypath = @"jsonResponseSerializer.acceptableContentTypes";
    [agent setValue:acceptableContentTypes forKeyPath:keypath];
}

- (void)sendRequest:(void (^)(id response))success
            failure:(void (^)(NSError *error))failure {
    [self addAccessory];
}

- (void)addAccessory {
    [self.requestAccessories removeAllObjects];
    YTKRequestEventAccessory *accessory = [[YTKRequestEventAccessory alloc] init];
    accessory.willStopBlock = ^(CCRequest *_Nonnull request) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (request.error) {
#if defined(DEBUG)
                NSLog(@"\n============ PCRequest Info] ============\nrequest method: %@  from cache: %@\nrequest url: %@\nrequest parameters: \n%@\nrequest error:\n%@\nresponse:\n%@\n%@\n==========================================\n", self.methodString, self.isDataFromCache ? @"YES" : @"NO", self.requestUrl, self.requestArgument, self.error, self.response, self.responseObject);
                [SVProgressHUD showErrorWithStatus:self.error.localizedDescription];
            } else {
                NSLog(@"\n============ [MHSRequest Info] ============\nrequest url: %@ %@\nrequest parameters: \n%@\nrequest response:\n%@\n==========================================\n", self.methodString, self.requestUrl, self.requestArgument, self.responseJSONObject);
#endif
            }
        });
    };

    [self addAccessory:accessory];
}

- (NSString *)methodString {
    NSString *methodString = nil;
    switch (self.requestMethod) {
        case YTKRequestMethodGET:
            methodString = @"GET";
            break;
        case YTKRequestMethodPOST:
            methodString = @"POST";
            break;
        case YTKRequestMethodHEAD:
            methodString = @"HEAD";
            break;
        case YTKRequestMethodPUT:
            methodString = @"PUT";
            break;
        case YTKRequestMethodDELETE:
            methodString = @"DELETE";
            break;
        case YTKRequestMethodPATCH:
            methodString = @"PATCH";
            break;
        default:
            methodString = @"UNKNOW";
            break;
    }
    return methodString;
}

- (NSString *)baseUrl {
    NSString *url = [NSString stringWithFormat:@"%@%@", CC_API_HOST, CC_API_VERSION];
    return url;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeJSON;
}

- (id)requestArgument {
    CCUser *user = [CCUser userFromLocal];
    if (user) {
        return @{@"token" : user.token};
    } else {
        return @{};
    }
}

- (NSInteger)cacheTimeInSeconds {
    return 1000000000000;
}

- (BOOL)ignoreCache {
    return YES;
}

- (NSTimeInterval)requestTimeoutInterval {
    return 30;
}

@end
