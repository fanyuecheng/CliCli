//
//  CCVideoListCell.m
//  CliCli
//
//  Created by Fancy 
//

#import "CCVideoListCell.h"
#import "CCIconFont.h"
#import <SDWebImage/SDWebImage.h>
 
@interface CCVideoListCell ()

@end

@implementation CCVideoListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.coverView];
        [self.coverView addSubview:self.updateLabel];
        [self.contentView addSubview:self.infoView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.cc_width;
    
    self.coverView.frame = CGRectMake(15, 10, width / 3, width / 6);
    self.updateLabel.frame = CGRectMake(0, self.coverView.cc_height - 20, self.coverView.cc_width, 20);
    CGSize infoSize = [self.infoView systemLayoutSizeFittingSize:CGSizeMake(width - self.coverView.cc_right - 20, CGFLOAT_MAX)];
    self.infoView.frame = CGRectMake(self.coverView.cc_right + 10, 15, width - self.coverView.cc_right - 20, infoSize.height);
}

- (NSString *)timeFormatted:(NSInteger)totalSeconds {
    NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = (totalSeconds / 60) % 60;
    NSInteger hours = totalSeconds / 3600;
    
    return hours ? [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hours, minutes, seconds] : [NSString stringWithFormat:@"%02ld:%02ld", minutes, seconds];
}

#pragma mark - Set
- (void)setVideo:(CCVideoInfo *)video {
    _video = video;
    [self.coverView sd_setImageWithURL:[NSURL URLWithString:video.vod_pic]];
    self.nameLabel.text = video.vod_name;
    self.infoLabel.text = [NSString stringWithFormat:@"%@/%@", video.vod_year, video.vod_area];
    self.updateLabel.text = video.vod_remarks;
}

- (void)setHistory:(CCVideoHistory *)history {
    _history = history;
    [self.coverView sd_setImageWithURL:[NSURL URLWithString:history.vod_pic]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", history.vod_name, history.video_section_name];
    self.updateLabel.textAlignment = NSTextAlignmentRight;
    self.updateLabel.backgroundColor = UIColor.clearColor;
    self.updateLabel.text = [self timeFormatted:history.watch_time / 1000];
    self.infoLabel.text = [NSString stringWithFormat:@"剩余：%@",  [self timeFormatted:(history.total_time - history.watch_time) / 1000]];
}

#pragma mark - Get
- (UIImageView *)coverView {
    if (!_coverView) {
        _coverView = [[UIImageView alloc] init];
        _coverView.layer.cornerRadius = 4;
        _coverView.layer.masksToBounds = YES;
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

- (UIStackView *)infoView {
    if (!_infoView) {
        _infoView = [[UIStackView alloc] init];
        _infoView.spacing = 8;
        _infoView.axis = UILayoutConstraintAxisVertical;
        _infoView.alignment = UIStackViewAlignmentLeading;
        [_infoView addArrangedSubview:self.nameLabel];
        [_infoView addArrangedSubview:self.infoLabel];
    }
    return _infoView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = UIFontBoldMake(15);
        _nameLabel.textColor = UIColor.labelColor;
    }
    return _nameLabel;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [self infoCommonLabel];
    }
    return _infoLabel;
}

- (UILabel *)infoCommonLabel {
    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.font = UIFontBoldMake(12);
    infoLabel.textColor = UIColor.tertiaryLabelColor;
    return infoLabel;
}

@end
