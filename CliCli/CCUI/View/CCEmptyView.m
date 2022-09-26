//
//  CCEmptyView.m
//  CCUI
//
//  Created by Fancy
//

#import "CCEmptyView.h"
#import "UIView+CCLayout.h"

@interface CCEmptyView ()

@property (nonatomic, strong) UIView                  *contentView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) UILabel                 *titleLabel;
@property (nonatomic, strong) UIButton                *actionButton;

@end

@implementation CCEmptyView

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self didInitialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self didInitialize];
    }
    return self;
}

- (void)didInitialize {
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.loadingView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.actionButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.bounds);
    
    self.loadingView.frame = CGRectSetXY(self.loadingView.bounds, (width - self.loadingView.cc_width) / 2, 10);
    self.titleLabel.frame = CGRectMake(10, self.loadingView.cc_bottom, width - 20, [self.titleLabel sizeThatFits:CGSizeMake(width - 20, CGFLOAT_MAX)].height);
    [self.actionButton sizeToFit];
    self.actionButton.frame = CGRectSetXY(self.actionButton.bounds, (width - self.actionButton.cc_width) / 2, self.titleLabel.cc_bottom + 10);
    self.contentView.frame = CGRectMake(0, 0, width, self.actionButton.cc_bottom + 10);
    self.contentView.center = self.center;
}

- (void)showLoading {
    [self showLoadingWithText:nil];
}
- (void)showLoadingWithText:(NSString *)text {
    self.loadingView.hidden = NO;
    [self.loadingView startAnimating];
    self.titleLabel.text = text;
    self.titleLabel.hidden = !text.length;
    self.actionButton.hidden = YES;
    [self setNeedsLayout];
}
- (void)showText:(NSString *)text {
    self.loadingView.hidden = YES;
    [self showText:text actionTitle:nil];
    self.actionButton.hidden = YES;
    [self setNeedsLayout];
}

- (void)showText:(NSString *)text
     actionTitle:(NSString *)title {
    self.loadingView.hidden = YES;
    self.titleLabel.text = text;
    self.titleLabel.hidden = !text.length;
    [self.actionButton setTitle:title forState:UIControlStateNormal];
    self.actionButton.hidden = !title.length;
    [self setNeedsLayout];
}

#pragma mark - Get
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = UIColor.systemBackgroundColor;
    }
    return _contentView;
}

- (UIActivityIndicatorView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
        [_loadingView sizeToFit];
    }
    return _loadingView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = UIFontMake(14);
        _titleLabel.textColor = UIColor.labelColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UIButton *)actionButton {
    if (!_actionButton) {
        _actionButton = [[UIButton alloc] init];
        _actionButton.titleLabel.font = UIFontMake(14);
        [_actionButton setTitleColor:UIColor.secondaryLabelColor forState:UIControlStateNormal];
    }
    return _actionButton;
}

@end
