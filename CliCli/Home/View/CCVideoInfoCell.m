//
//  CCVideoInfoCell.m
//  CliCli
//
//  Created by Fancy
//

#import "CCVideoInfoCell.h"
#import <SDWebImage/SDWebImage.h>

@interface CCVideoInfoCell ()

@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *directorLabel;
@property (nonatomic, strong) UILabel *actorLabel;

@end

@implementation CCVideoInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.coverView addSubview:self.numberLabel];
        [self.infoView addArrangedSubview:self.contentLabel];
        [self.infoView addArrangedSubview:self.directorLabel];
        [self.infoView addArrangedSubview:self.actorLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.cc_width;
    
    self.coverView.frame = CGRectMake(15, 15, width / 3, width / 9 * 4);
    self.numberLabel.frame = CGRectMake(0, 0, 25, 25);
    self.updateLabel.frame = CGRectMake(0, self.coverView.cc_height - 20, self.coverView.cc_width, 20);
    CGSize infoSize = [self.infoView systemLayoutSizeFittingSize:CGSizeMake(width - self.coverView.cc_right - 20, CGFLOAT_MAX)];
    self.infoView.frame = CGRectMake(self.coverView.cc_right + 10, 15, width - self.coverView.cc_right - 20, infoSize.height);
}

#pragma mark - Set
- (void)setNumber:(NSInteger)number {
    _number = number;
    self.numberLabel.hidden = NO;
    self.numberLabel.text = [@(number) stringValue];
}

- (void)setVideo:(CCVideoInfo *)video {
    [super setVideo:video];
    
    self.infoLabel.text = [NSString stringWithFormat:@"%@/%@/%@", video.vod_year, video.vod_area, video.vod_class];
    self.contentLabel.text = video.vod_blurb;
    self.directorLabel.text = video.vod_director.length ? [NSString stringWithFormat:@"导演：%@", video.vod_director] : nil;
    self.actorLabel.text = video.vod_actor.length ? [NSString stringWithFormat:@"演员：%@", video.vod_actor] : nil; 
}

#pragma mark - Get
- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.layer.maskedCorners = kCALayerMaxXMaxYCorner;
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.font = UIFontBoldMake(15);
        _numberLabel.textColor = UIColor.systemBackgroundColor;
        _numberLabel.backgroundColor = UIColor.systemRedColor;
        _numberLabel.layer.cornerRadius = 4;
        _numberLabel.layer.masksToBounds = YES;
        _numberLabel.hidden = YES;
    }
    return _numberLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [self infoCommonLabel];
        _contentLabel.numberOfLines = 4;
    }
    return _contentLabel;
}

- (UILabel *)directorLabel {
    if (!_directorLabel) {
        _directorLabel = [self infoCommonLabel];
    }
    return _directorLabel;
}

- (UILabel *)actorLabel {
    if (!_actorLabel) {
        _actorLabel = [self infoCommonLabel];
    }
    return _actorLabel;
}

@end
