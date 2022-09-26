//
//  CCVideoFilterView.m
//  CliCli
//
//  Created by Fancy 
//

#import "CCVideoFilterView.h"
#import "CCUI.h"

@interface CCVideoFilterView ()

@property (nonatomic, strong) CCFloatLayoutView *typeView;
@property (nonatomic, strong) CCFloatLayoutView *areaView;
@property (nonatomic, strong) CCFloatLayoutView *languageView;
@property (nonatomic, strong) CCFloatLayoutView *yearView;
@property (nonatomic, strong) UIButton          *openButton;

@end

@implementation CCVideoFilterView

- (instancetype)initWithType:(CCVideoType *)type {
    if (self = [super init]) {
        self.type = type;
        [self didInitialize];
    }
    return self;
}
 
- (void)didInitialize {
    [self addSubview:self.typeView];
    [self addSubview:self.areaView];
    [self addSubview:self.languageView];
    [self addSubview:self.yearView];
    [self addSubview:self.openButton];
}

- (void)layoutSubviews {
    CGFloat width = self.cc_width;
    
    self.typeView.frame = CGRectMake(0, 0, width, [self.typeView sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)].height);
    self.areaView.frame = CGRectMake(0, self.typeView.cc_bottom, width, [self.areaView sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)].height);
    self.languageView.frame = CGRectMake(0, self.areaView.cc_bottom, width, [self.languageView sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)].height);
    self.yearView.frame = CGRectMake(0, self.languageView.cc_bottom, width, [self.yearView sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)].height);
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat height = 0;
    if (self.type.clzArray.count) {
        height += [self.typeView sizeThatFits:CGSizeMake(SCREEN_WIDTH, CGFLOAT_MAX)].height;
    }
    if (self.type.areaArray.count) {
        height += [self.areaView sizeThatFits:CGSizeMake(SCREEN_WIDTH, CGFLOAT_MAX)].height;
    }
    if (self.type.langArray.count) {
        height += [self.languageView sizeThatFits:CGSizeMake(SCREEN_WIDTH, CGFLOAT_MAX)].height;
    }
    if (self.type.yearArray.count) {
        height += [self.yearView sizeThatFits:CGSizeMake(SCREEN_WIDTH, CGFLOAT_MAX)].height;
    }
    return CGSizeMake(SCREEN_WIDTH, height);
}

#pragma mark - Action
- (void)filterAction:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    [sender.superview.subviews enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.selected) {
            obj.selected = NO;
            *stop = YES;
        }
    }];
    sender.selected = YES;
    !self.filterBlock ? : self.filterBlock(sender.tag / 1000, [sender.currentTitle isEqualToString:@"全部"] ? nil : sender.currentTitle);
}

#pragma mark - Get
- (CCFloatLayoutView *)floatLayoutViewWithData:(NSArray *)data
                                           tag:(NSInteger)tag {
    CCFloatLayoutView *view = [[CCFloatLayoutView alloc] init];
    if (data.count) {
        view.padding = UIEdgeInsetsMake(10, 15, 0, 15);
        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:data];
        [dataArray insertObject:@"全部" atIndex:0];
        data = dataArray.copy;
    } else {
        return view;
    }
    view.itemMargins = UIEdgeInsetsMake(0, 0, 5, 15);
    
    [data enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [[UIButton alloc] init];
        button.selected = idx == 0;
        button.tag = tag + idx;
        button.titleLabel.font = UIFontMake(12);
        [button setTitleColor:UIColor.secondaryLabelColor forState:UIControlStateNormal];
        [button setTitleColor:UIColor.systemBlueColor forState:UIControlStateSelected];
        [button setTitle:obj forState:UIControlStateNormal];
        [button addTarget:self action:@selector(filterAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }];
    
    return view;
}

- (CCFloatLayoutView *)typeView {
    if (!_typeView) {
        _typeView = [self floatLayoutViewWithData:self.type.clzArray tag:1000];
    }
    return _typeView;
}

- (CCFloatLayoutView *)areaView {
    if (!_areaView) {
        _areaView = [self floatLayoutViewWithData:self.type.areaArray tag:2000];
    }
    return _areaView;
}

- (CCFloatLayoutView *)languageView {
    if (!_languageView) {
        _languageView = [self floatLayoutViewWithData:self.type.langArray tag:3000];
    }
    return _languageView;
}

- (CCFloatLayoutView *)yearView {
    if (!_yearView) {
        _yearView = [self floatLayoutViewWithData:self.type.yearArray tag:4000];
    }
    return _yearView;
}

 
 
@end
