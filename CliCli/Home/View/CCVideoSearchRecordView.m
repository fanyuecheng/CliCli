//
//  CCVideoSearchRecordView.m
//  CliCli
//
//  Created by Fancy 
//

#import "CCVideoSearchRecordView.h"
#import "CCUI.h"
#import "CCIconFont.h"

#define CC_SEARCH_RECORD  @"CC_SEARCH_RECORD"

@interface CCVideoSearchRecordView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray <NSString *> *historyArray;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation CCVideoSearchRecordView

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
    [self addSubview:self.collectionView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
}

- (void)addRecord:(NSString *)key {
    if (key.length) {
        if ([self.historyArray containsObject:key]) {
            [self.historyArray removeObject:key];
        }
        [self.historyArray insertObject:key atIndex:0];
        if (self.historyArray.count > 20) {
            [self.historyArray removeLastObject];
        }
        [[NSUserDefaults standardUserDefaults] setObject:self.historyArray forKey:CC_SEARCH_RECORD];
        [self.collectionView reloadData];
    }
}

#pragma mark - Action
- (void)deleteAction:(UIButton *)sender {
    [self.historyArray removeAllObjects];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CC_SEARCH_RECORD];
    [self.collectionView reloadData];
}

#pragma mark - CollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.historyArray.count;
            break;
        default:
            return self.hotArray.count;
            break;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CCBaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CCBaseCollectionViewCell" forIndexPath:indexPath];
    UILabel *titleLabel = [cell.contentView viewWithTag:1000];
    if (!titleLabel) {
        titleLabel = [[UILabel alloc] init];
        titleLabel.font = UIFontMake(14);
        titleLabel.backgroundColor = UIColor.secondarySystemBackgroundColor;
        titleLabel.textColor = UIColor.secondaryLabelColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.tag = 1000;
        titleLabel.layer.cornerRadius = 15;
        titleLabel.layer.masksToBounds = YES;
        [cell.contentView addSubview:titleLabel];
    }
    titleLabel.frame = cell.bounds;
    titleLabel.text = indexPath.section == 0 ? [self.historyArray cc_safeObjectAtIndex:indexPath.item] : [self.hotArray cc_safeObjectAtIndex:indexPath.item];
     
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])  {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionElementKindSectionHeader" forIndexPath:indexPath];
        UILabel *label = [header viewWithTag:1000];
        if (!label) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, header.cc_width - 30, header.cc_height)];
            label.tag = 1000;
            label.font = UIFontMake(14);
            [header addSubview:label];
        }
        label.text = indexPath.section == 0 ? @"历史记录" : @"热门搜索";
        
        UIButton *button = [header viewWithTag:1001];
        if (!button) {
            button = [[UIButton alloc] initWithFrame:CGRectMake(header.cc_width - 50, 0, 50, header.cc_height)];
            button.tag = 1001;
            button.titleLabel.font = [UIFont fontWithName:@"iconfont" size:14];
            [button setTitle:[CCIconFont deleteFont].unicode forState:UIControlStateNormal];
            [button setTitleColor:UIColor.labelColor forState:UIControlStateNormal];
            [button addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
            [header addSubview:button];
        }
        button.hidden = indexPath.section == 1;
        
        return header;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.historyArray.count ? CGSizeMake(collectionView.cc_width, 40) : CGSizeZero;
            break;
        default:
            return self.hotArray.count ? CGSizeMake(collectionView.cc_width, 40) : CGSizeZero;
            break;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    switch (section) {
        case 0:
            return self.historyArray.count ? UIEdgeInsetsMake(5, 15, 15, 15) : UIEdgeInsetsZero;
            break;
        default:
            return self.hotArray.count ? UIEdgeInsetsMake(5, 15, 15, 15) : UIEdgeInsetsZero;
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = indexPath.section == 0 ? [self.historyArray cc_safeObjectAtIndex:indexPath.item] : [self.hotArray cc_safeObjectAtIndex:indexPath.item];
    
    CGSize size = [key cc_sizeForFont:UIFontMake(14) size:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) mode:NSLineBreakByWordWrapping];
    return CGSizeMake(size.width + 20, 30);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSString *key = indexPath.section == 0 ? [self.historyArray cc_safeObjectAtIndex:indexPath.item] : [self.hotArray cc_safeObjectAtIndex:indexPath.item];
    !self.searchBlock ? : self.searchBlock(key);
}
 
#pragma mark - Get
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.clearColor;
        [_collectionView registerClass:[CCBaseCollectionViewCell class] forCellWithReuseIdentifier:@"CCBaseCollectionViewCell"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionElementKindSectionHeader"];
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return _collectionView;
}

- (NSMutableArray<NSString *> *)historyArray {
    if (!_historyArray) {
        _historyArray = [NSMutableArray array];
        NSArray *historyArray = [[NSUserDefaults standardUserDefaults] arrayForKey:CC_SEARCH_RECORD];
        if (historyArray.count) {
            [_historyArray addObjectsFromArray:historyArray];
        }
    }
    return _historyArray;
}

#pragma mark - Set
- (void)setHotArray:(NSArray<NSString *> *)hotArray {
    _hotArray = hotArray;
    [self.collectionView reloadData];
}

@end
