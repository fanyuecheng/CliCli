//
//  CCVideoListCell.h
//  CliCli
//
//  Created by Fancy 
//

#import "CCUI.h"
#import "CCVideoInfo.h"
#import "CCVideoHistory.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCVideoListCell : CCBaseTableViewCell

@property (nonatomic, strong) UIImageView *coverView;
@property (nonatomic, strong) UILabel     *updateLabel;
@property (nonatomic, strong) UIStackView *infoView;
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UILabel     *infoLabel;

@property (nonatomic, strong) CCVideoInfo *video;
@property (nonatomic, strong) CCVideoHistory *history;

- (UILabel *)infoCommonLabel;

@end

NS_ASSUME_NONNULL_END
