//
//  CCVideoEpisodeView.m
//  CliCli
//
//  Created by Fancy 
//

#import "CCVideoEpisodeView.h"
#import "CCUI.h"
#import "CCVideoPlayer.h"

@interface CCVideoEpisodeView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation CCVideoEpisodeView

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

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat h = self.vertical ? self.collectionView.collectionViewLayout.collectionViewContentSize.height : 66;
    return CGSizeMake(SCREEN_WIDTH, h);
}

- (void)reloadData {
    [self.collectionView reloadData];
}

#pragma mark - CollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.episodeArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CCBaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CCBaseCollectionViewCell" forIndexPath:indexPath];
    UILabel *label = [cell.contentView viewWithTag:1000];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:cell.bounds];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 1000;
        label.font = UIFontMake(13);
        label.backgroundColor = UIColor.systemGray6Color;
        label.layer.cornerRadius = 4;
        [cell.contentView addSubview:label];
    }
    CCVideoEpisode *ep = [self.episodeArray cc_safeObjectAtIndex:indexPath.item];
    label.textColor = ep.selected ? UIColor.systemBlueColor : UIColor.secondaryLabelColor;
    label.text = ep.title;
    
    return cell;
}
 
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    CCVideoEpisode *ep = [self.episodeArray cc_safeObjectAtIndex:indexPath.item];
    if (ep.selected) {
        return;
    }
    [self.episodeArray enumerateObjectsUsingBlock:^(CCVideoEpisode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.selected) {
            obj.selected = NO;
            *stop = YES;
        }
    }];
    ep.selected = YES;
    [collectionView reloadData];
    !self.episodeBlock ? : self.episodeBlock(indexPath.item);
}

#pragma mark - Set
- (void)setEpisodeArray:(NSArray<CCVideoEpisode *> *)episodeArray {
    _episodeArray = episodeArray;
    [self.collectionView reloadData];
    [self sizeToFit];
}

- (void)setVertical:(BOOL)vertical {
    _vertical = vertical;
    ((UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout).scrollDirection = vertical ? UICollectionViewScrollDirectionVertical : UICollectionViewScrollDirectionHorizontal;
    [self sizeToFit];
    [self.collectionView reloadData];
}


#pragma mark - Get
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        CGFloat itemWidth = floor((SCREEN_WIDTH - 50) / 3);
        layout.itemSize = CGSizeMake(itemWidth, 36);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.clearColor;
        [_collectionView registerClass:[CCBaseCollectionViewCell class] forCellWithReuseIdentifier:@"CCBaseCollectionViewCell"];
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

@end

