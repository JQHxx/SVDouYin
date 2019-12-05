//
//  DYSameCityViewController.m
//  SVDouYinOC
//
//  Created by HJQ on 2019/11/10.
//  Copyright © 2019 HJQ. All rights reserved.
//

#import "DYSameCityViewController.h"
#import "DYSameCitySectionReusableView.h"
#import "DYSameCityCell.h"
#import <WSLWaterFlowLayout/WSLWaterFlowLayout.h>
#import "DYRecommentViewModel.h"
#import "DYRecommentModel.h"

#import "ScalePresentAnimation.h"
#import "SwipeLeftInteractiveTransition.h"
#import "ScaleDismissAnimation.h"
#import "DYRecommentViewController.h"

@interface DYSameCityViewController () <UICollectionViewDelegate, UICollectionViewDataSource, WSLWaterFlowLayoutDelegate, UIViewControllerTransitioningDelegate>
{
    WSLWaterFlowLayout * _flow;
}

@property (nonatomic, strong) NSMutableArray <DYRecommentData *>  *datas;
@property (nonatomic, strong) DYRecommentViewModel *recommentVM;

@property (nonatomic, strong) ScalePresentAnimation            *scalePresentAnimation;
@property (nonatomic, strong) ScaleDismissAnimation            *scaleDismissAnimation;
@property (nonatomic, strong) SwipeLeftInteractiveTransition   *swipeLeftInteractiveTransition;

@end

@implementation DYSameCityViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"同城";
    self.view.backgroundColor = RGB_COLOR(14.0, 15.0, 26.0, 1.0);
    [self setupUI];
    [self requestRecommentData];
}

#pragma mark - Private methods
- (void) setupUI {

    _scalePresentAnimation = [ScalePresentAnimation new];
    _scaleDismissAnimation = [ScaleDismissAnimation new];
    _swipeLeftInteractiveTransition = [SwipeLeftInteractiveTransition new];

    [self setupCollectionView];
}

- (void) setupCollectionView {

    _flow = [[WSLWaterFlowLayout alloc] init];
    _flow.delegate = self;
    _flow.flowLayoutStyle = WSLWaterFlowVerticalEqualWidth;
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (void) requestRecommentData {
    __weak typeof(self) weakSelf = self;
    [self.recommentVM getRecommentData:^(NSArray<DYRecommentData *> *datas) {
        __strong typeof(weakSelf) strongSelf = self;
        strongSelf.datas = [NSMutableArray arrayWithArray:datas];
        [strongSelf.collectionView reloadData];


    } failureBlock:^(NSString *message) {

    }];
}

#pragma mark - WSLWaterFlowLayoutDelegate
-(CGSize )waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section{
    return CGSizeMake(APP_WIDTH, 40);
}

- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForFooterViewInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}

/** 列数*/
-(CGFloat)columnCountInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 2;
}

/** 列间距*/
-(CGFloat)columnMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 5;
}

/** 行间距*/
-(CGFloat)rowMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 5;
}

/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return UIEdgeInsetsMake(0, 5, 0, 5);
}


//返回每个item大小
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    DYRecommentData *data = self.datas[indexPath.item];
    CGFloat width = ([UIScreen mainScreen].bounds.size.height - 15.0) / 2.0;
    if (data.imageHeight > 0) {
        return CGSizeMake(0, data.imageHeight + data.descHeight);
    }
    CGSize imageSize = [UIImage getImageSizeWithURL:data.video.dynamic_cover.url_list.firstObject];
    CGFloat imageHeight = 0;
    if (imageSize.height <= 0) {
        UIImage *loadingImageView = [UIImage imageNamed:@"loading"];
        imageHeight = loadingImageView.size.height * width / loadingImageView.size.width;
    } else {
        imageHeight = imageSize.height * width / imageSize.width;
        data.imageHeight = imageHeight;
    }
    CGFloat height = data.descHeight + imageHeight;
    return CGSizeMake(0, height);
}


#pragma mark - UICollectionViewDataSource
//组个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}

// 返回每个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    DYSameCityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DYSameCityCell" forIndexPath:indexPath];
    DYRecommentData *data = self.datas[indexPath.item];
    cell.recomment = data;

    return cell;
}

//返回头脚视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        DYSameCitySectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor blackColor];
        headerView.nameLabel.text = @"自动定位：深圳";
        return headerView;

    } else {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer" forIndexPath:indexPath];
        return footerView;
    }
}



#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"当前点击 section = %ld item = %ld", (long)indexPath.section, (long)indexPath.row);

    _selectIndex = indexPath.item;
    DYRecommentViewController *controller = [DYRecommentViewController new];
    controller.transitioningDelegate = self;
    controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    controller.ddy_AutoSetModalPresentationStyle = NO;
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    [_swipeLeftInteractiveTransition wireToViewController:controller];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate Delegate
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return _scalePresentAnimation;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return _scaleDismissAnimation;
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return _swipeLeftInteractiveTransition.interacting ? _swipeLeftInteractiveTransition : nil;
}

#pragma mark - Setter & Getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:_flow];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:DYSameCityCell.class forCellWithReuseIdentifier:@"DYSameCityCell"];
        [_collectionView registerClass:DYSameCitySectionReusableView.class forSupplementaryViewOfKind: UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
        [_collectionView registerClass:UICollectionReusableView.class forSupplementaryViewOfKind: UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer"];
    }
    return _collectionView;
}

- (NSMutableArray<DYRecommentData *> *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (DYRecommentViewModel *)recommentVM {
    if (!_recommentVM) {
        _recommentVM = [[DYRecommentViewModel alloc]init];
    }
    return _recommentVM;
}

@end
