//
//  CCVideoSearchRecordView.h
//  CliCli
//
//  Created by Fancy 
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCVideoSearchRecordView : UIView

@property (nonatomic, copy) NSArray <NSString *> *hotArray;

@property (nonatomic, copy) void (^searchBlock)(NSString *key);

- (void)addRecord:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
