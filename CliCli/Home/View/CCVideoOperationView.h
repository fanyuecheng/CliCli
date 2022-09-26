//
//  CCVideoOperationView.h
//  CliCli
//
//  Created by Fancy 
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCVideoOperationView : UIView

@property (nonatomic, strong) UIButton *collectionButton;
@property (nonatomic, strong) UIButton *downloadButton;
@property (nonatomic, strong) UIButton *shareButton;

@property (nonatomic, copy) void (^actionBlock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
