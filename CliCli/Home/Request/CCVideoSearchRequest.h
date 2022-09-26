//
//  CCVideoSearchRequest.h
//  CliCli
//
//  Created by Fancy 
//

#import "CCRequest.h"
#import "CCVideoInfo.h"

NS_ASSUME_NONNULL_BEGIN
 
typedef NS_ENUM(NSUInteger, CCVideoSearchType) {
    CCVideoSearchTypeDefault,
    CCVideoSearchTypeCollection
};

@interface CCVideoSearchRequest : CCRequest

@property (nonatomic, assign) CCVideoSearchType type;
@property (nonatomic, assign) NSInteger         page;
@property (nonatomic, copy)   NSString          *searchKey;

@end

NS_ASSUME_NONNULL_END
