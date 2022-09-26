//
//  CCVideoOperationView.m
//  CliCli
//
//  Created by Fancy 
//

#import "CCVideoOperationView.h"
#import "UIView+CCLayout.h"
#import "CCIconFont.h"

@interface CCVideoOperationView ()

@end

@implementation CCVideoOperationView

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
    [self addSubview:self.collectionButton];
    [self addSubview:self.downloadButton];
    [self addSubview:self.shareButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.cc_width;
    CGFloat height = self.cc_height;
    
    CGFloat w = width / 3;
    self.collectionButton.frame = CGRectMake(0, 0, w, height);
    self.downloadButton.frame = CGRectMake(w, 0, w, height);
    self.shareButton.frame = CGRectMake(w * 2, 0, w, height);
}

#pragma mark - Action
- (void)buttonAction:(UIButton *)sender {
    !self.actionBlock ? : self.actionBlock(sender.tag - 1000);
}

#pragma mark - Get
- (UIButton *)buttonWithImage:(CCIconFont *)image
                        title:(NSString *)title
                          tag:(NSInteger)tag {
    UIButton *button = [[UIButton alloc] init];
    button.titleLabel.font = UIFontMake(13);
    [button setImage:[image imageWithColor:UIColor.secondaryLabelColor size:25] forState:UIControlStateNormal];
    [button setImage:[image imageWithColor:UIColor.systemBlueColor size:25] forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:UIColor.secondaryLabelColor forState:UIControlStateNormal];
    [button setTitleColor:UIColor.systemBlueColor forState:UIControlStateSelected];
     
    CGFloat imageWidth = 25;
    CGFloat space = 10;
    CGFloat labelWidth = button.titleLabel.intrinsicContentSize.width;
    CGFloat labelHeight = button.titleLabel.intrinsicContentSize.height;
    
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsMake(-labelHeight - space / 2, 0, 0, -labelWidth);
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, -imageWidth - space / 2, 0);
    
    button.imageEdgeInsets = imageEdgeInsets;
    button.titleEdgeInsets = labelEdgeInsets;
    button.tag = tag;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (UIButton *)collectionButton {
    if (!_collectionButton) {
        _collectionButton = [self buttonWithImage:[CCIconFont collectionFont] title:@"收藏" tag:1000];
    }
    return _collectionButton;
}

- (UIButton *)downloadButton {
    if (!_downloadButton) {
        _downloadButton = [self buttonWithImage:[CCIconFont downloadFont] title:@"下载" tag:1001];
    }
    return _downloadButton;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [self buttonWithImage:[CCIconFont shareFont] title:@"分享" tag:1002];
    }
    return _shareButton;
}


@end
