//
//  DYChatViewController.m
//  SVDouYinOC
//
//  Created by HJQ on 2019/11/16.
//  Copyright © 2019 HJQ. All rights reserved.
//

#import "DYChatListViewController.h"
#import "DYChatTextView.h"

@interface DYChatListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DYChatTextView  *textView;


@end

@implementation DYChatListViewController

#pragma mark - Life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_textView show];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_textView dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setupUI];
}

#pragma mark - Private methods
- (void) setupUI {
    [self setupTableView];
    _textView = [DYChatTextView new];
    //_textView.delegate = self;
}

- (void) setupTableView {

}


#pragma mark - UITableViewDataSource

#pragma mark - UITableViewDelegate

#pragma mark - Setter & Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _tableView;
}

@end
