//
//  CCVideoDownloadManager.m
//  CliCli
//
//  Created by Fancy 
//

#import "CCVideoDownloadManager.h"

@interface CCVideoDownloadManager ()

@property (nonatomic, strong) NSFileManager    *fileManager;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSMutableArray   *cacheArray;

@end
 
@implementation CCVideoDownloadManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static CCVideoDownloadManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (instancetype)init {
    if (self = [super init]) {
        [self creatRootDirectory];
    }
    return self;
}

#pragma mark - Method
- (BOOL)creatFileDirectoryWithVideoId:(NSInteger)videoId
                            videoName:(NSString *)videoName {
    NSString *rootPath = [self downloadRootDirectory];
    NSString *filePath = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@", @(videoId), videoName]];
    if (![self.fileManager fileExistsAtPath:filePath]) {
        return [self.fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    } else {
        return YES;
    }
}

- (BOOL)creatRootDirectory {
    NSString *rootPath = [self downloadRootDirectory];
    if (![self.fileManager fileExistsAtPath:rootPath]) {
        return [self.fileManager createDirectoryAtPath:rootPath withIntermediateDirectories:YES attributes:nil error:nil];
    } else {
        return YES;
    }
}

- (NSString *)localPathVideoId:(NSInteger)videoId
                     videoName:(NSString *)videoName
                        epName:(NSString *)epName {
 
    NSString *path = [[self downloadRootDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@/%@.mp4", @(videoId), videoName, epName]];
    if ([self.fileManager fileExistsAtPath:path]) {
        return path;
    } else {
        return nil;
    }
}

- (CCVideoDownloadOperation *)downloadWithVideoId:(NSInteger)videoId
                                        videoName:(NSString *)videoName
                                         videoURL:(NSString *)videoURL
                                           epName:(NSString *)epName {
    NSString *localPath = [self localPathVideoId:videoId videoName:videoName epName:epName];
    if (localPath) {
        return nil;
    }
    CCVideoDownloadOperation *operation = [[CCVideoDownloadOperation alloc] initWithVideoId:videoId videoName:videoName videoURL:videoURL epName:epName];
    if ([self.cacheArray containsObject:operation.name]) {
        return nil;
    } else {
        [self.cacheArray addObject:operation.name];
        [self creatFileDirectoryWithVideoId:videoId videoName:videoName];
        [self.queue addOperation:operation];
         
        return operation;
    }
}

- (NSArray *)downloadVideoPathArray {
    NSArray *videoList = [self listFilesInDirectoryAtPath:[self downloadRootDirectory] deep:NO];
    if (videoList.count) {
        NSMutableArray *array = [NSMutableArray array];
        [videoList enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *epList = [self listFilesInDirectoryAtPath:[[self downloadRootDirectory] stringByAppendingPathComponent:obj] deep:NO];
            if (epList) {
                [array addObject:@{obj : epList}];
            }
        }];
        return array;
    } else {
        return nil;
    }
}

- (NSArray *)listFilesInDirectoryAtPath:(NSString *)path deep:(BOOL)deep {
    NSArray *listArr;
    NSError *error;
    NSFileManager *manager = [NSFileManager defaultManager];
    if (deep) {
        // 深遍历
        NSArray *deepArr = [manager subpathsOfDirectoryAtPath:path error:&error];
        if (!error) {
            listArr = deepArr;
        } else {
            listArr = nil;
        }
    } else {
        // 浅遍历
        NSArray *shallowArr = [manager contentsOfDirectoryAtPath:path error:&error];
        if (!error) {
            listArr = shallowArr;
        } else {
            listArr = nil;
        }
    }
    return listArr;
}

#pragma mark - Get
- (NSMutableArray *)cacheArray {
    if (!_cacheArray) {
        _cacheArray = @[].mutableCopy;
    }
    return _cacheArray;
}

- (NSOperationQueue *)queue {
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 3;
    }
    return _queue;
}

- (NSFileManager *)fileManager {
    if (!_fileManager) {
        _fileManager = [NSFileManager defaultManager];
    }
    return _fileManager;
}

- (NSString *)downloadRootDirectory {
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    return [cacheDir stringByAppendingPathComponent:@"CCVideo"];
}

@end
