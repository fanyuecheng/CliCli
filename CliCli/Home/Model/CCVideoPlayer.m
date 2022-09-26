//
//  CCVideoPlayer.m
//  CliCli
//
//  Created by Fancy 
//

#import "CCVideoPlayer.h"
#import "CCVieoParseRequest.h"

@interface CCVideoEpisode ()

@property (nonatomic, strong) CCVieoParseRequest *request;
@property (nonatomic, strong) CCVideoParse *parse;

@end

@implementation CCVideoEpisode

- (void)parse:(void (^)(CCVideoEpisode *episode, NSError *error))finished {
    if (_parse) {
        !finished ? : finished(self, nil);
        return;
    }
 
    self.request.url = self.url;
    self.request.parseApi = self.parseApi;
    
    [self.request sendRequest:^(CCVideoParse *parse) {
        self.parse = parse;
        !finished ? : finished(self, nil);
    } failure:^(NSError * _Nonnull error) {
        !finished ? : finished(nil, error);
    }];
}

- (CCVieoParseRequest *)request {
    if (!_request) {
        _request = [[CCVieoParseRequest alloc] init];
    }
    return _request;
}

@end

@interface CCVideoPlayer ()

@property (nonatomic, copy) NSArray *episodeArray;

@end

@implementation CCVideoPlayer

- (NSArray *)episodeArray {
    if (self.url) {
        if (_episodeArray) {
            return _episodeArray;
        }
        //"第01集$270a2eeedf0fe53f58940e4c4da4de2f#第02集$ff0a118827645231c5e5fab3fcb34158#第03集$28d4211eb586e08650b94e6c6d408109#第04集$aeadd273e42d1aa80dc02839e4aa9cef#第05集$65f4ef8901f205f330957fdc31348f1c#第06集$f59db2cb5876ac846399f1960e31b9d7#第07集$d9ce2b1809bc2b7c8df4a7a99bebb223",
        NSArray *itemArray = [self.url componentsSeparatedByString:@"#"];
        NSMutableArray *episodeArray = [NSMutableArray array];
        for (NSString *obj in itemArray) {
            NSArray *item = [obj componentsSeparatedByString:@"$"];
            CCVideoEpisode *episode = [[CCVideoEpisode alloc] init];
            episode.title = item.firstObject;
            episode.url = item.lastObject;
            episode.parseApi = self.parse_api;
            [episodeArray addObject:episode];
        }
        _episodeArray = episodeArray.copy;
        return _episodeArray;
    } else {
        return nil;
    }
}


@end
