//
//  CCVideoCell.m
//  CliCli
//
//  Created by Fancy 
//

#import "CCVideoCell.h"
#import <SDWebImage/SDWebImage.h>

@interface CCVideoCell ()

@property (nonatomic, strong) UIImageView *coverView;
@property (nonatomic, strong) UILabel     *updateLabel;
@property (nonatomic, strong) UILabel     *nameLabel;

@end

@implementation CCVideoCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.coverView];
        [self.contentView addSubview:self.updateLabel];
        [self.contentView addSubview:self.nameLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.cc_width;
    CGFloat height = self.cc_height;
     
    self.coverView.frame = CGRectMake(0, 0, width, height - 20);
    self.updateLabel.frame = CGRectMake(0, height - 35, width, 15);
    self.nameLabel.frame = CGRectMake(0, height - 20, width, 20);
}

- (void)setVideo:(CCVideo *)video {
    _video = video;
    
    [self.coverView sd_setImageWithURL:[NSURL URLWithString:video.vod_pic]];
    self.updateLabel.text = video.vod_remarks;
    self.nameLabel.text = video.vod_name;
}

#pragma mark - Get
- (UIImageView *)coverView {
    if (!_coverView) {
        _coverView = [[UIImageView alloc] init];
        _coverView.backgroundColor = UIColor.systemGray6Color;
        _coverView.contentMode = UIViewContentModeScaleAspectFill;
        _coverView.clipsToBounds = YES;
    }
    return _coverView;
}

- (UILabel *)updateLabel {
    if (!_updateLabel) {
        _updateLabel = [[UILabel alloc] init];
        _updateLabel.textColor = UIColor.whiteColor;
        _updateLabel.font = UIFontMake(12);
        _updateLabel.textAlignment = NSTextAlignmentCenter;
        _updateLabel.backgroundColor = [UIColor.systemGrayColor colorWithAlphaComponent:.7];
    }
    return _updateLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = UIColor.labelColor;
        _nameLabel.font = UIFontMake(14);
    }
    return _nameLabel;
}

@end
