//
//  CCVideoDownloadOperation.m
//  CliCli
//
//  Created by Fancy
//

#import "CCVideoDownloadOperation.h"

@interface CCVideoDownloadOperation ()

@property (nonatomic, assign, getter = isExecuting) BOOL executing;
@property (nonatomic, assign, getter = isFinished)  BOOL finished;
@property (nonatomic, assign, getter = isCancelled) BOOL cancelled;

@property (nonatomic, strong) CCVideoDownloadRequest     *request;
@property (nonatomic, strong) NSFileManager              *fileManager;

@end

@implementation CCVideoDownloadOperation
@synthesize executing = _executing;
@synthesize finished = _finished;
@synthesize cancelled = _cancelled;

- (instancetype)initWithVideoId:(NSInteger)videoId
                      videoName:(NSString *)videoName
                       videoURL:(NSString *)videoURL
                         epName:(NSString *)epName {
    if (self = [super init]) {
        self.request.videoURL = videoURL.copy;
        self.request.videoName = videoName.copy;
        self.request.videoId = [@(videoId) stringValue];
        self.request.epName = epName.copy;
        self.name = [NSString stringWithFormat:@"%@_%@_%@", @(videoId), videoName, epName];
    }
    return self;
}

- (void)start {
    self.executing = YES;
    
    NSString *filePath = self.request.resumableDownloadPath;
    
    if ([self.fileManager fileExistsAtPath:filePath]) {
        !self.finishedBlock ? : self.finishedBlock(filePath, nil);
        [self done];
    } else {
        [self.request sendRequest:^(id  _Nonnull response) {
            !self.finishedBlock ? : self.finishedBlock(response, nil);
            [self done];
        } failure:^(NSError * _Nonnull error) {
            !self.finishedBlock ? : self.finishedBlock(nil, error);
            [self done];
        }];
    }
}

- (void)cancel {
    [self.request stop];
    self.cancelled = YES;
    [self done];
}

- (void)done {
    self.finished = YES;
    self.executing = NO;
    [self reset];
}

- (void)reset {
    _finishedBlock = nil;
    _progressBlock = nil;
}

#pragma mark - Get
- (CCVideoDownloadRequest *)request {
    if (!_request) {
        _request = [[CCVideoDownloadRequest alloc] init];
    }
    return _request;
}

- (NSFileManager *)fileManager {
    if (!_fileManager) {
        _fileManager = [NSFileManager defaultManager];
    }
    return _fileManager;
}

#pragma mark - Set
- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isAsynchronous {
    return YES;
}

- (void)setProgressBlock:(void (^)(NSProgress * _Nonnull))progressBlock {
    _progressBlock = progressBlock;
    self.request.resumableDownloadProgressBlock = progressBlock;
}

@end
