//
//  CCVideoCollectionRequest.h
//  CliCli
//
//  Created by Fancy  
//

#import "CCRequest.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CCVideoCollectionOperation) {
    CCVideoCollectionOperationAdd,
    CCVideoCollectionOperationCancel
};

@interface CCVideoCollectionRequest : CCRequest

@property (nonatomic, assign) NSInteger videoId;
@property (nonatomic, assign) CCVideoCollectionOperation operation;

@end

NS_ASSUME_NONNULL_END
