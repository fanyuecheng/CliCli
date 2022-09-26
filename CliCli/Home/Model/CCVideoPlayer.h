//
//  CCVideoPlayer.h
//  CliCli
//
//  Created by Fancy 
//

#import <Foundation/Foundation.h>
#import "CCVideoParse.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCVideoEpisode : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *parseApi;
@property (nonatomic, copy) NSString *localPath;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL downloaded;
@property (nonatomic, strong, readonly) CCVideoParse *parse;

- (void)parse:(void (^)(CCVideoEpisode *episode, NSError *error))finished;

@end

@interface CCVideoPlayer : NSObject

@property (nonatomic, copy)   NSString *name;
@property (nonatomic, copy)   NSString *code;
@property (nonatomic, copy)   NSString *url;
@property (nonatomic, copy)   NSString *parse_api;
@property (nonatomic, copy)   NSString *extra_parse_api;
@property (nonatomic, copy)   NSString *subtitle_field;
@property (nonatomic, copy)   NSString *user_agent;
@property (nonatomic, copy)   NSString *headers;
@property (nonatomic, copy)   NSString *link_features;
@property (nonatomic, copy)   NSString *un_link_features;
@property (nonatomic, copy)   NSString *parse_after_config_enable;
@property (nonatomic, copy)   NSString *parse_after_config_features;
@property (nonatomic, copy)   NSString *parse_after_config_user_agent;
@property (nonatomic, copy)   NSString *parse_after_config_headers;

- (NSArray <CCVideoEpisode *>*)episodeArray;

@end

NS_ASSUME_NONNULL_END
