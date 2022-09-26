//
//  CCVideoCommentCell.m
//  CliCli
//
//  Created by Fancy 
//

#import "CCVideoCommentCell.h"
#import "CCIconFont.h"
#import <SDWebImage/SDWebImage.h>
 
@interface CCVideoCommentCell ()

@property (nonatomic, strong) UIImageView *coverView;
@property (nonatomic, strong) UIStackView *userView;
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UILabel     *vipLabel;
@property (nonatomic, strong) UILabel     *contentLabel;
@property (nonatomic, strong) UILabel     *dateLabel;
@property (nonatomic, strong) UILabel     *countLabel;
@property (nonatomic, strong) UIView      *replayBackView;
@property (nonatomic, strong) UIStackView *replayView;
@property (nonatomic, strong) UILabel     *replayLabel1;
@property (nonatomic, strong) UILabel     *replayLabel2;
@property (nonatomic, strong) UIButton    *checkButton;

@end

@implementation CCVideoCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.coverView];
        [self.contentView addSubview:self.userView];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.countLabel];
        [self.contentView addSubview:self.replayBackView];
        [self.replayBackView addSubview:self.replayView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.cc_width;
    
    self.coverView.frame = CGRectMake(15, 15, 40, 40);
    CGSize userSize = [self.userView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    self.userView.frame = CGRectMake(70, 15, userSize.width, userSize.height);
    CGSize contentSize = [self.contentLabel sizeThatFits:CGSizeMake(width - 85, CGFLOAT_MAX)];
    self.contentLabel.frame = CGRectMake(70, self.userView.cc_bottom + 10, width - 85, contentSize.height);
    CGSize dateSize = [self.dateLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    self.dateLabel.frame = CGRectMake(70, self.contentLabel.cc_bottom + 10, dateSize.width, dateSize.height);
    CGSize countSize = [self.countLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    self.countLabel.frame = CGRectMake(width - countSize.width - 15, self.contentLabel.cc_bottom + 10, countSize.width, countSize.height);
    CGSize replaySize = [self.replayView systemLayoutSizeFittingSize:CGSizeMake(width - 105, CGFLOAT_MAX)];
    self.replayView.frame = CGRectMake(10, 10, width - 105, replaySize.height);
    self.replayBackView.frame = CGRectMake(70, self.dateLabel.cc_bottom + 10, width - 85, replaySize.height + 20);
}

- (void)setComment:(CCVideoComment *)comment {
    _comment = comment;
    [self.coverView sd_setImageWithURL:[NSURL URLWithString:comment.user_portrait]];
    self.nameLabel.text = comment.user_name;
    self.vipLabel.hidden = !comment.user_is_vip;
    self.contentLabel.text = comment.comment_content;
    self.countLabel.text = [NSString stringWithFormat:@"%@ 回复", @(comment.reply_count)];
    self.dateLabel.text = comment.comment_time;
    CCVideoComment *reply1 = [comment.reply_list cc_safeObjectAtIndex:0];
    CCVideoComment *reply2 = [comment.reply_list cc_safeObjectAtIndex:1];
    self.replayLabel1.text = [NSString stringWithFormat:@"%@：%@", reply1.comment_name, reply1.comment_content];
    self.replayLabel2.text = [NSString stringWithFormat:@"%@：%@", reply2.comment_name, reply2.comment_content];
    self.replayLabel1.hidden = !reply1;
    self.replayLabel2.hidden = !reply2;
    self.checkButton.hidden = comment.reply_list.count < 2;
    self.replayBackView.hidden = !comment.reply_list.count;
}

- (void)replyAction:(UIButton *)sender {
    !self.replyBlock ? : self.replyBlock(self.comment);
}

#pragma mark - Get
- (UIImageView *)coverView {
    if (!_coverView) {
        _coverView = [[SDAnimatedImageView alloc] init];
        _coverView.layer.cornerRadius = 20;
        _coverView.layer.masksToBounds = YES;
        _coverView.backgroundColor = UIColor.systemGray6Color;
    }
    return _coverView;
}

- (UIStackView *)userView {
    if (!_userView) {
        _userView = [[UIStackView alloc] init];
        _userView.spacing = 5;
        _userView.axis = UILayoutConstraintAxisHorizontal;
        _userView.alignment = UIStackViewAlignmentCenter;
        [_userView addArrangedSubview:self.nameLabel];
        [_userView addArrangedSubview:self.vipLabel];
    }
    return _userView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = UIFontBoldMake(14);
        _nameLabel.textColor = UIColor.labelColor;
    }
    return _nameLabel;
}

- (UILabel *)vipLabel {
    if (!_vipLabel) {
        _vipLabel = [[UILabel alloc] init];
        _vipLabel.font = [UIFont fontWithName:@"iconfont" size:14];
        _vipLabel.textColor = UIColor.systemYellowColor;
        _vipLabel.text = [CCIconFont memberFont].unicode;
    }
    return _vipLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = UIFontMake(13);
        _contentLabel.textColor = UIColor.labelColor;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = UIFontMake(12);
        _dateLabel.textColor = UIColor.secondaryLabelColor;
    }
    return _dateLabel;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.font = UIFontMake(12);
        _countLabel.textColor = UIColor.secondaryLabelColor;
    }
    return _countLabel;
}

- (UIStackView *)replayView {
    if (!_replayView) {
        _replayView = [[UIStackView alloc] init];
        _replayView.spacing = 5;
        _replayView.axis = UILayoutConstraintAxisVertical;
        _replayView.alignment = UIStackViewAlignmentLeading;
        [_replayView addArrangedSubview:self.replayLabel1];
        [_replayView addArrangedSubview:self.replayLabel2];
        [_replayView addArrangedSubview:self.checkButton];
    }
    return _replayView;
}

- (UILabel *)replayLabel1 {
    if (!_replayLabel1) {
        _replayLabel1 = [[UILabel alloc] init];
        _replayLabel1.font = UIFontMake(12);
        _replayLabel1.textColor = UIColor.secondaryLabelColor;
        _replayLabel1.numberOfLines = 0;
    }
    return _replayLabel1;
}

- (UILabel *)replayLabel2 {
    if (!_replayLabel2) {
        _replayLabel2 = [[UILabel alloc] init];
        _replayLabel2.font = UIFontMake(12);
        _replayLabel2.textColor = UIColor.secondaryLabelColor;
        _replayLabel2.numberOfLines = 0;
    }
    return _replayLabel2;
}

- (UIButton *)checkButton {
    if (!_checkButton) {
        _checkButton = [[UIButton alloc] init];
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] init];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:@"查看更多回复 " attributes:@{NSFontAttributeName : UIFontMake(12), NSForegroundColorAttributeName : UIColor.systemBlueColor}];
        NSAttributedString *arrow = [[NSAttributedString alloc] initWithString:[CCIconFont arrowFont].unicode attributes:@{NSFontAttributeName : [UIFont fontWithName:@"iconfont" size:12], NSForegroundColorAttributeName : UIColor.systemBlueColor}];
        [title appendAttributedString:text];
        [title appendAttributedString:arrow];
        [_checkButton setAttributedTitle:title forState:UIControlStateNormal];
        [_checkButton addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkButton;
}

- (UIView *)replayBackView {
    if (!_replayBackView) {
        _replayBackView = [[UIView alloc] init];
        _replayBackView.backgroundColor = UIColor.secondarySystemBackgroundColor;
    }
    return _replayBackView;
}

@end
