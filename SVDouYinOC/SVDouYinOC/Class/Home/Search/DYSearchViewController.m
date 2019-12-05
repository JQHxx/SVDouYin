//
//  DYSearchViewController.m
//  SVDouYinOC
//
//  Created by HJQ on 2019/11/11.
//  Copyright © 2019 HJQ. All rights reserved.
//

#import "DYSearchViewController.h"
#import "DYSearchToolBar.h"
#import "DYSearchCell.h"
#import "DYSearchFooterView.h"

@interface DYSearchViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) DYSearchToolBar *searchToolBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSString *> *datas;
@property (nonatomic, assign) BOOL isExpand;

@end

@implementation DYSearchViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _isExpand = NO;
    // self.title = @"搜索";
    [self setupUI];
}

#pragma mark - Private methods
- (void) setupUI {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[UIView new]];
    [self setupTableView];

    self.searchToolBar.frame = CGRectMake(0, 0, APP_WIDTH, 44);
    self.navigationItem.titleView = self.searchToolBar;
    //[self.navigationController.navigationBar addSubview:self.searchToolBar];
    __weak typeof(self) weakSelf = self;
    [self.searchToolBar setBackBtnClickBlock:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    [self.searchToolBar setSearchBtnClickBlock:^(NSString * _Nonnull text) {

        NSMutableArray *array = [NSMutableArray arrayWithArray:[DYUserDefaultsUtil searchHistoryList]];
        if ([array containsObject:text]) {
            [array removeObject:text];
        }
        if (array.count > 9) {
            [array removeLastObject];
        }
        [array insertObject:text atIndex:0];
        DYUserDefaultsUtil.searchHistoryList = array;
        weakSelf.datas = array;
        [weakSelf.tableView reloadData];
    }];
}

- (void) setupTableView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isExpand) {
        return self.datas.count;
    } else {
        if ([self.datas count] > 4) {
            return 5;
        }
        return self.datas.count;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DYSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(DYSearchCell.class)];
    if (!cell) {
        cell = [[DYSearchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(DYSearchCell.class)];
    }
    cell.titleLabel.text = self.datas[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.datas.count == 0) {
        return 0.001;
    }
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    DYSearchFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(DYSearchFooterView.class)];
    if (!footerView) {
        footerView = [[DYSearchFooterView alloc]initWithReuseIdentifier:NSStringFromClass(DYSearchFooterView.class)];
    }
    NSString *title = @"全部搜索记录";
    if (_isExpand) {
        title =  @"清空所有搜索记录";
    }
    footerView.titleLabel.text = title;
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - Setter & Getter
- (DYSearchToolBar *)searchToolBar {
    if (!_searchToolBar) {
        _searchToolBar = [[DYSearchToolBar alloc]init];
    }
    return _searchToolBar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor blackColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:DYSearchCell.class forCellReuseIdentifier:NSStringFromClass(DYSearchCell.class)];
        [_tableView registerClass:DYSearchFooterView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(DYSearchFooterView.class)];
    }
    return _tableView;
}

- (NSMutableArray<NSString *> *)datas {
    if (!_datas) {
        _datas = [NSMutableArray arrayWithArray:[DYUserDefaultsUtil searchHistoryList]];
    }
    return _datas;
}


@end
