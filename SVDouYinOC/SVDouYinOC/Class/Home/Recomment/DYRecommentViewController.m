//
//  DYRecommentViewController.m
//  SVDouYinOC
//
//  Created by HJQ on 2019/11/10.
//  Copyright © 2019 HJQ. All rights reserved.
//

#import "DYRecommentViewController.h"
#import "DYRecommentTableViewCell.h"
#import "DYRecommentViewModel.h"
#import "DYRecommentModel.h"
#import "AVPlayerManager.h"
#import "AVPlayerView.h"


@interface DYRecommentViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) BOOL isCurPlayerPause;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <DYRecommentData *>  *datas;
@property (nonatomic, strong) DYRecommentViewModel *recommentVM;

@end

@implementation DYRecommentViewController

#pragma mark - Life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSArray<DYRecommentTableViewCell *> *cells = [self.tableView visibleCells];
    for(DYRecommentTableViewCell *cell in cells) {
        //[cell.playerView cancelLoading];
        if(cell.isPlayerReady) {
            // 播放视频
            [cell play];
        }
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.tableView.layer removeAllAnimations];

    NSArray<DYRecommentTableViewCell *> *cells = [self.tableView visibleCells];
    for(DYRecommentTableViewCell *cell in cells) {
        //[cell.playerView cancelLoading];
        [cell.playerView pause];

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setupUI];
    [self viewBindEvents];
    [self requestRecommentData];
    [self addObserver:self forKeyPath:@"currentIndex" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc {
    [[AVPlayerManager shareManager] removeAllPlayers];
    [self removeObserver:self forKeyPath:@"currentIndex"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"======== dealloc =======");
}

#pragma mark - Private methods
- (void) initData {
    _isCurPlayerPause = NO;
    _currentIndex = 0;
}

- (void) setupUI {
    self.view.backgroundColor = RGB_COLOR(14.0, 15.0, 26.0, 1.0);
    [self setBackgroundImage:@"img_video_loading"];
    self.view.layer.masksToBounds = YES;
    [self setupTableView];
}

- (void) setupTableView {
    self.tableView.frame = CGRectMake(0, 0, APP_WIDTH,APP_HEIGHT );
    [self.view addSubview:self.tableView];
}

- (void) setBackgroundImage:(NSString *)imageName {
    UIImageView *background = [[UIImageView alloc] initWithFrame:self.view.bounds];
    background.clipsToBounds = YES;
    background.contentMode = UIViewContentModeScaleAspectFill;
    background.image = [UIImage imageNamed:imageName];
    [self.view addSubview:background];
}

- (void) viewBindEvents {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarTouchBegin) name:@"StatusBarTouchBeginNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void) requestRecommentData {
    __weak typeof(self) weakSelf = self;
    [self.recommentVM getRecommentData:^(NSArray<DYRecommentData *> *datas) {
        __strong typeof(weakSelf) strongSelf = self;
        strongSelf.datas = [NSMutableArray arrayWithArray:datas];
        [strongSelf.tableView reloadData];
        NSIndexPath *curIndexPath = [NSIndexPath indexPathForRow:strongSelf.currentIndex inSection:0];
           [strongSelf.tableView scrollToRowAtIndexPath:curIndexPath atScrollPosition:UITableViewScrollPositionMiddle
                                         animated:NO];

    } failureBlock:^(NSString *message) {

    }];
}

/*
- (void) setupKVO {
    // create KVO controller instance
    FBKVOController *_KVOController = [FBKVOController controllerWithObserver:self];
    // handle clock change, including initial value
    [_KVOController observe:self keyPath:@"currentIndex" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {


    }];
}
 */

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    //观察currentIndex变化
    if ([keyPath isEqualToString:@"currentIndex"]) {
        if (_currentIndex >= 0) {
            //设置用于标记当前视频是否播放的BOOL值为NO
             _isCurPlayerPause = NO;
             //获取当前显示的cell
             DYRecommentTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
             [cell startDownloadHighPriorityTask];
             __weak typeof (cell) wcell = cell;
             __weak typeof (self) wself = self;
             //判断当前cell的视频源是否已经准备播放
             if(cell.isPlayerReady) {
                 //播放视频
                 [cell replay];
             }else {
                 [[AVPlayerManager shareManager] pauseAll];
                 //当前cell的视频源还未准备好播放，则实现cell的OnPlayerReady Block 用于等待视频准备好后通知播放
                 cell.onPlayerReady = ^{
                     NSIndexPath *indexPath = [wself.tableView indexPathForCell:wcell];
                     if(!wself.isCurPlayerPause && indexPath && indexPath.row == wself.currentIndex) {
                         [wcell play];
                     }
                 };
             }
        }

    } else {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Event response
- (void)statusBarTouchBegin {
    _currentIndex = 0;
}

- (void)applicationBecomeActive {
    DYRecommentTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
    if(!_isCurPlayerPause) {
        [cell.playerView play];
    }
}

- (void)applicationEnterBackground {
    DYRecommentTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
    _isCurPlayerPause = ![cell.playerView rate];
    [cell.playerView pause];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DYRecommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if(!cell) {
        cell = [[DYRecommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
    }
    [cell initData:_datas[indexPath.row]];
    [cell startDownloadBackgroundTask];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGPoint translatedPoint = [scrollView.panGestureRecognizer translationInView:scrollView];
        //UITableView禁止响应其他滑动手势
        scrollView.panGestureRecognizer.enabled = NO;
        NSLog(@"y= %f", translatedPoint.y);
        if(translatedPoint.y < -50 && self.currentIndex < (self.datas.count - 1)) {
            self.currentIndex ++;   //向下滑动索引递增
        }
        if(translatedPoint.y > 50 && self.currentIndex > 0) {
            self.currentIndex --;   //向上滑动索引递减
        }
        if(self.currentIndex >= 0){
            if(self.currentIndex < self.datas.count){
                [UIView animateWithDuration:0.15
                                      delay:0.0
                                    options:UIViewAnimationOptionCurveEaseOut animations:^{
                                        //UITableView滑动到指定cell
                                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                                    } completion:^(BOOL finished) {
                                        //UITableView可以响应其他滑动手势
                                        scrollView.panGestureRecognizer.enabled = YES;
                                    }];
            }else{
               scrollView.panGestureRecognizer.enabled = YES;
            }

        }else{
            scrollView.panGestureRecognizer.enabled = YES;
        }
    });
}


#pragma mark - Setter & Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style: UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView setTableFooterView:[UIView new]];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[DYRecommentTableViewCell class] forCellReuseIdentifier:@"CellID"];
    }
    return _tableView;
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
