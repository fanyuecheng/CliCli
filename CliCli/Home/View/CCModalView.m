//
//  CCModalView.m
//  CliCli
//
//  Created by Fancy 
//

#import "CCModalView.h"
#import "CCUI.h"

@implementation CCModalView

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
    self.backgroundColor = UIColor.systemBackgroundColor;
    [self addSubview:self.titleLabel];
    [self addSubview:self.toolBar];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.cc_width;
    CGFloat height = self.cc_height;
    
    self.titleLabel.frame = CGRectMake(15, 0, width - 30, 44);
    self.toolBar.frame = CGRectMake(0, 0, width, 44);
    self.customView.frame = CGRectMake(0, 44, width, height - 44);
}

#pragma mark - Action
- (void)closeAction:(id)sender {
    !self.closeBlock ? : self.closeBlock(self);
}

#pragma mark - Get
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = UIFontBoldMake(18);
        _titleLabel.textColor = UIColor.labelColor;
    }
    return _titleLabel;
}

- (UIToolbar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] init];
        UIToolbarAppearance *appearance = [[UIToolbarAppearance alloc] init];
        [appearance configureWithDefaultBackground];
        appearance.backgroundColor = UIColor.clearColor;
        appearance.shadowColor =  UIColor.clearColor;
        appearance.backgroundEffect = nil;
        _toolBar.standardAppearance = appearance;
        if (@available(iOS 15.0, *)) {
            _toolBar.scrollEdgeAppearance = appearance;
        }
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        space.width = SCREEN_WIDTH - 44;
        UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemClose target:self action:@selector(closeAction:)];
       
        _toolBar.items = @[space, close];
    }
    return _toolBar;
}

- (void)setCustomView:(UIView *)customView {
    [_customView removeFromSuperview];
    _customView = customView;
    if (customView) {
        [self addSubview:customView];
    }
}

@end
