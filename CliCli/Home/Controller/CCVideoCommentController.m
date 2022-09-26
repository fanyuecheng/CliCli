//
//  CCVideoCommentController.m
//  CliCli
//
//  Created by Fancy 
//

#import "CCVideoCommentController.h"
#import "CCVideoCommentListRequest.h"
#import "CCVideoCommentRequest.h"
#import "CCVideoCommentCell.h"
#import <MJRefresh/MJRefresh.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface CCVideoCommentController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, assign) CCVideoCommentType type;
@property (nonatomic, strong) CCVideoCommentListRequest *listRequest;
@property (nonatomic, strong) CCVideoCommentRequest     *saveRequest;
@property (nonatomic, strong) NSMutableArray <CCVideoComment *>*dataSource;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView      *bottomView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) CGFloat     keybordHeight;

@end

@implementation CCVideoCommentController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithVideoId:(NSInteger)videoId {
    if (self = [super init]) {
        self.videoId = videoId;
        self.type = CCVideoCommentTypeVideo;
    }
    return self;
}

- (instancetype)initWithCommentId:(NSInteger)commentId {
    if (self = [super init]) {
        self.commentId = commentId;
        self.type = CCVideoCommentTypeReply;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self requestData];
}

- (void)initSubviews {
    [super initSubviews];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.textField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat width = self.view.cc_width;
    CGFloat height = self.view.cc_height;
    CGFloat safe = self.view.safeAreaInsets.bottom;
    
    self.tableView.frame = CGRectMake(0, 0, width, height - 50 - safe);
    if (self.keybordHeight) {
        self.bottomView.frame = CGRectMake(0, height - self.keybordHeight - 50, width, 50);
    } else {
        self.bottomView.frame = CGRectMake(0, height - 50 - safe, width, 50);
    }
    self.textField.frame = CGRectMake(15, 10, width - 30, 30);
}

#pragma mark - Notification
- (void)keyboardWillShowNotification:(NSNotification *)noti {
    NSDictionary *userInfo = noti.userInfo;
    CGRect endFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keybordHeight = endFrame.size.height;
}

#pragma mark - Net
- (void)requestData {
    if (!self.dataSource.count) {
        [self showEmptyViewWithLoading];
    }
    
    [self.listRequest sendRequest:^(NSArray <CCVideoComment *>*response) {
        [self hideEmptyView];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.listRequest.page == 1) {
            [self.dataSource removeAllObjects];
        }
        if (response.count) {
            [self.dataSource addObjectsFromArray:response];
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self showEmptyViewWithText:@"网络错误" buttonTitle:@"点击重试" buttonAction:@selector(requestData)];
    }];
}

- (void)saveComment {
    [SVProgressHUD showProgress:-1];
    [self.saveRequest sendRequest:^(id  _Nonnull response) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:response[@"msg"]];
        self.textField.text = @"";
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - JXPagerViewListViewDelegate
 
- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.tableView;
}
 
- (void)listViewDidScrollCallback:(void (^)(UIScrollView *scrollView))callback {
    
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.keybordHeight = 0;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    
    if (textField.text.length) {
        self.saveRequest.content = textField.text;
        [self saveComment];
    }
    
    return YES;
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CCVideoCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CCVideoCommentCell" forIndexPath:indexPath];
    
    cell.comment = [self.dataSource cc_safeObjectAtIndex:indexPath.row];
    @weakify(self)
    cell.replyBlock = ^(CCVideoComment * _Nonnull comment) {
        @strongify(self)
        CCVideoCommentController *list = [[CCVideoCommentController alloc] initWithCommentId:comment.comment_id];
        list.videoId = self.videoId;
        [self.navigationController pushViewController:list animated:YES];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CCVideoComment *comment = [self.dataSource cc_safeObjectAtIndex:indexPath.row];
    return comment.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Get
- (CCVideoCommentListRequest *)listRequest {
    if (!_listRequest) {
        _listRequest = [[CCVideoCommentListRequest alloc] init];
        _listRequest.type = self.type;
        if (self.videoId) {
            _listRequest.videoId = self.videoId;
        }
        if (self.commentId) {
            _listRequest.commentId = self.commentId;
        }
    }
    return _listRequest;
}

- (CCVideoCommentRequest *)saveRequest {
    if (!_saveRequest) {
        _saveRequest = [[CCVideoCommentRequest alloc] init];
        _saveRequest.type = self.type;
        if (self.videoId) {
            _saveRequest.videoId = self.videoId;
        }
        if (self.commentId) {
            _saveRequest.commentId = self.commentId;
        }
    }
    return _saveRequest;
}

- (NSMutableArray<CCVideoComment *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[CCVideoCommentCell class] forCellReuseIdentifier:@"CCVideoCommentCell"];
        @weakify(self)
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            self.listRequest.page = 1;
            [self.tableView.mj_footer resetNoMoreData];
            [self requestData];
        }];
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self)
            self.listRequest.page ++;
            [self requestData];
        }];
    }
    return _tableView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = UIColor.systemBackgroundColor;
    }
    return _bottomView;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.backgroundColor = UIColor.secondarySystemBackgroundColor;
        _textField.placeholder = @"也来说一句吧";
        _textField.returnKeyType = UIReturnKeySend;
        _textField.delegate = self;
    }
    return _textField;
}

#pragma mark - Set
- (void)setKeybordHeight:(CGFloat)keybordHeight {
    _keybordHeight = keybordHeight;
    [self.view setNeedsLayout];
    [UIView animateWithDuration:.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}
 
@end
