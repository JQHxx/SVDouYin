//
//  DYHomeMainViewController.m
//  SVDouYinOC
//
//  Created by HJQ on 2019/11/10.
//  Copyright © 2019 HJQ. All rights reserved.
//

#import "DYHomeMainViewController.h"
#import "DYRecommentViewController.h"
#import "DYAttentionViewController.h"
#import "DYHomeMainRouter.h"

@interface DYHomeMainViewController () <TYTabPagerBarDataSource, TYTabPagerBarDelegate, TYPagerControllerDataSource, TYPagerControllerDelegate>

@property (nonatomic, strong) TYTabPagerBar *tabBar;
@property (nonatomic, strong) TYPagerController *pagerController;

@property (nonatomic, strong) NSMutableArray<DYPagerModel *> *datas;

@end

@implementation DYHomeMainViewController

#pragma mark - Life cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    //self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupUI];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.pagerController.view.frame = self.view.bounds;
    self.tabBar.frame = CGRectMake(0, 0, 160, 44);
}

#pragma mark - Private methods
- (void) setupUI {

    [self setupNavBar];
    [self addTabPagerBar];
    [self addPagerController];
    [self reloadData];
    // 默认选中
    [self.pagerController scrollToControllerAtIndex:1 animate:NO];
}

- (void) setupNavBar {

    // 搜索
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 40, 40);
    [leftButton setImage:[UIImage imageNamed:@"home_search"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];

    // 扫码
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 40, 40);
    [rightButton setImage:[UIImage imageNamed:@"home_scan"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(scanAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

- (void) addTabPagerBar {

    self.tabBar.layout.adjustContentCellsCenter = YES;
    // self.tabBar.layout.cellWidth = kScreenW / 5.0;
    self.tabBar.layout.cellSpacing = 15.0;
    self.tabBar.layout.selectedTextFont = [UIFont systemFontOfSize:18];
    self.tabBar.layout.normalTextFont = [UIFont systemFontOfSize:18];
    // self.tabBar.layout.animateDuration = 0.0;
    self.tabBar.layout.progressHeight = 3.0;
    self.tabBar.layout.selectedTextColor = [UIColor whiteColor];
    self.tabBar.layout.progressColor = [UIColor whiteColor];
    self.tabBar.layout.barStyle = TYPagerBarStyleProgressView;
    self.tabBar.delegate = self;
    self.tabBar.dataSource = self;
    [self.tabBar setBackgroundColor:[UIColor clearColor]];
    [self.tabBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:NSStringFromClass([TYTabPagerBarCell class])];
    self.navigationItem.titleView = self.tabBar;
}

- (void) addPagerController {
    self.pagerController.delegate = self;
    self.pagerController.dataSource = self;
    [self addChildViewController:self.pagerController];
    [self.pagerController.view setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.pagerController.view];

}

- (void) reloadData {
    [self.tabBar reloadData];
    [self.pagerController reloadData];
}

#pragma mark - Event response
- (void) searchAction {
    [DYHomeMainRouter pushToSearchViewControllerFromVC:self];
}

- (void) scanAction {
    [DYHomeMainRouter pushToQRcodeScanViewControllerFromVC:self];
}

#pragma mark - TYTabPagerBarDataSource & TYTabPagerBarDelegate
- (NSInteger)numberOfItemsInPagerTabBar {
    return self.datas.count;
}

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    TYTabPagerBarCell *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TYTabPagerBarCell class]) forIndex:index];
    cell.titleLabel.text = self.datas[index].title;
    return cell;
}

- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    return [pagerTabBar cellWidthForTitle:self.datas[index].title];
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [self.pagerController scrollToControllerAtIndex:index animate:YES];
}

#pragma mark - TYPagerControllerDataSource & TYPagerControllerDelegate
- (NSInteger)numberOfControllersInPagerController {
    return self.datas.count;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    return [self.datas[index] vc];
}

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [self.tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:YES];
}

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [self.tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}

#pragma mark - Setter & Getter
- (TYTabPagerBar *)tabBar {
    if (! _tabBar) {
        _tabBar = [TYTabPagerBar new];
    }
    return _tabBar;
}

- (TYPagerController *)pagerController {
    if (!_pagerController) {
        _pagerController = [TYPagerController new];
    }
    return _pagerController;
}

- (NSMutableArray<DYPagerModel *> *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
        DYPagerModel *attentionModel = [DYPagerModel new];
        attentionModel.title = @"关注";
        attentionModel.vc = [[DYRecommentViewController alloc]init];

        DYPagerModel *recommendModel = [DYPagerModel new];
        recommendModel.title = @"推荐";
        recommendModel.vc = [DYRecommentViewController new];
        [_datas addObject:attentionModel];
        [_datas addObject: recommendModel];
    }
    return _datas;
}


@end
