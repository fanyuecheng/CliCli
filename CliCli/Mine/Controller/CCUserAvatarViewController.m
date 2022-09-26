//
//  CCUserAvatarViewController.m
//  CliCli
//
//  Created by Fancy 
//

#import "CCUserAvatarViewController.h"
#import "CCUserAvatar.h"
#import "CCUserAvatarRequest.h"
#import <SDWebImage/SDWebImage.h>

@interface CCUserAvatarViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy)   NSArray <CCUserAvatar *>*dataSource;

@property (nonatomic, strong) CCUserAvatarRequest *request;

@end

@implementation CCUserAvatarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     
    [self requestData];
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    
    self.navigationItem.title = @"选择头像";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"自定义" style:UIBarButtonItemStylePlain target:self action:@selector(customAction:)];
}

- (void)initSubviews {
    [super initSubviews];
    
    [self.view addSubview:self.collectionView];
}
 
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.collectionView.frame = self.view.bounds;
}

#pragma mark - Action
- (void)customAction:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入头像链接" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.font = UIFontMake(14);
        textField.placeholder = @"请输入头像链接";
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    @weakify(self)
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        @strongify(self)
        UITextField *textField = alert.textFields.firstObject;
        if (textField.text.length) {
            !self.avatarBlock ? : self.avatarBlock(textField.text);
        }
    }];
    [alert addAction:cancelAction];
    [alert addAction:otherAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Net
- (void)requestData {
    [self showEmptyViewWithLoading];
    [self.request sendRequest:^(NSArray *response) {
        [self hideEmptyView];
        self.dataSource = response;
        [self.collectionView reloadData];
    } failure:^(NSError * _Nonnull error) {
        [self showEmptyViewWithText:@"网络错误" buttonTitle:@"点击重试" buttonAction:@selector(requestData)];
    }];
}

#pragma mark - CollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CCBaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CCBaseCollectionViewCell" forIndexPath:indexPath];
    
    SDAnimatedImageView *avatarView = [cell.contentView viewWithTag:1000];
    if (!avatarView) {
        avatarView = [[SDAnimatedImageView alloc] initWithFrame:cell.bounds];
        avatarView.tag = 1000;
        avatarView.layer.cornerRadius = cell.cc_width / 2;
        avatarView.layer.masksToBounds = YES;
        [cell.contentView addSubview:avatarView];
    }
    
    [avatarView sd_setImageWithURL:[NSURL URLWithString:self.dataSource[indexPath.item].img_url]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    !self.avatarBlock ? : self.avatarBlock(self.dataSource[indexPath.item].img_url);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Get
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 15;
        layout.minimumInteritemSpacing = 15;
        layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        CGFloat itemWidth = floorf((SCREEN_WIDTH - 15 * 5) / 4);
        layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.clearColor;
        [_collectionView registerClass:[CCBaseCollectionViewCell class] forCellWithReuseIdentifier:@"CCBaseCollectionViewCell"];
    }
    return _collectionView;
}

- (CCUserAvatarRequest *)request {
    if (!_request) {
        _request = [[CCUserAvatarRequest alloc] init];
    }
    return _request;
}

@end
