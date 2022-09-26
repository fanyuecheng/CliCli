//
//  CCVieoParseRequest.h
//  CliCli
//
//  Created by Fancy 
//

#import "CCRequest.h"
#import "CCVideoParse.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCVieoParseRequest : CCRequest

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *parseApi;

@end

NS_ASSUME_NONNULL_END
