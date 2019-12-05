//
//  RGVopPlayerView.m
//  RedGrass
//
//  Created by wukong on 2019/1/20.
//  Copyright © 2019年 hongcaosp. All rights reserved.
//

#import "RGVodPlayerView.h"
//#import "TXImageSprite.h"
#import <UIImageView+WebCache.h>


@interface RGVodPlayerView()

//@property (strong, nonatomic) TXImageSprite        *imageSprite;
@property (nonatomic, strong) RGVodPlayerModel     *playerModel;
/** 腾讯点播播放器 */
@property (nonatomic, strong) TXVodPlayer          *vodPlayer;

/** 进入后台*/
@property (nonatomic, assign) BOOL                 didEnterBackground;
@property (nonatomic, assign)                      CGFloat videoRatio;
/** 单击 */
//@property (nonatomic, strong) UITapGestureRecognizer *singleTap;

@end


@implementation RGVodPlayerView

#pragma mark - life Cycle

/**
 *  代码初始化调用此方法
 */
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) { [self initializeThePlayer]; }
    return self;
}

/**
 *  storyboard、xib加载playerView会调用此方法
 */
- (void)awakeFromNib {
    [super awakeFromNib];
    [self initializeThePlayer];
}


/**
 *  初始化player
 */
- (void)initializeThePlayer {
    
    
    [self addNotifications];
    // 添加手势
//    [self createGesture];
}

- (void)dealloc {
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

#pragma mark - 观察者、通知

/**
 *  添加观察者、通知
 */
- (void)addNotifications {
    // app退到后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    // app进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayground) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    // 监测设备方向
//    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(onDeviceOrientationChange)
//                                                 name:UIDeviceOrientationDidChangeNotification
//                                               object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(onStatusBarOrientationChange)
//                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
//                                               object:nil];
}

#pragma mark - layoutSubviews

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.subviews.count > 0) {
        UIView *innerView = self.subviews[0];
        if ([innerView isKindOfClass:NSClassFromString(@"TXIJKSDLGLView")] ||
            [innerView isKindOfClass:NSClassFromString(@"TXCAVPlayerView")]) {
            innerView.frame = self.bounds;
        }
    }
}

#pragma mark - Public Method

- (void)playWithModel:(RGVodPlayerModel *)playerModel {
    _playerModel = playerModel;
//    self.imageSprite = nil;
    [self _removeOldPlayer];
    [self _playWithModel:playerModel];
    self.coverImageView.alpha = 1;
    if([playerModel.coverImgPath length]){
        NSURL *url = [NSURL URLWithString:playerModel.coverImgPath];

        [self.coverImageView sd_setImageWithURL:url];
    }
}

- (void)_playWithModel:(RGVodPlayerModel *)playerModel {
    _playerModel = playerModel;
    
    [self pause];
    
    NSString *videoURL = playerModel.vedioUrl;
    if (videoURL != nil) {
        [self configTXPlayer];
    }else {
        NSLog(@"无播放地址");
    }
}

-(BOOL) checkIsHavePlayModel{
    if(_playerModel == nil){
        return NO;
    }
    return YES;
}

/**
 *  重置player
 */
- (void)resetPlayer {
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 暂停
    [self pause];
    
    [self.vodPlayer stopPlay];
    [self.vodPlayer removeVideoWidget];
    self.vodPlayer = nil;
    self.state = StateStopped;
}

/**
 *  播放
 */
- (void)resume {
//    [self.controlView setPlayState:YES];
    self.isPauseByUser = NO;
    [_vodPlayer resume];
}

-(void) play{
    [self resume];
}

/**
 * 暂停
 */
- (void)pause {
//    [self.controlView setPlayState:NO];
    self.isPauseByUser = YES;
    [_vodPlayer pause];
}

-(BOOL)isPlaying{
    return [_vodPlayer isPlaying];
}

- (TXVodPlayer *)vodPlayer
{
    if (_vodPlayer == nil) {
        _vodPlayer = [[TXVodPlayer alloc] init];
        _vodPlayer.loop = YES;
        TXVodPlayConfig *config = [[TXVodPlayConfig alloc] init];
        config.maxCacheItems = 1;
        config.cacheFolderPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/TXCache"];
        config.progressInterval = 0.02;
        //        config.playerType = PLAYER_AVPLAYER;
        [_vodPlayer setConfig:config];
        _vodPlayer.vodDelegate = self;
    }
    return _vodPlayer;
}

#pragma mark - Private Method
/**
 *  设置Player相关参数
 */
- (void)configTXPlayer {
    self.backgroundColor = [UIColor blackColor];
    
    [self.vodPlayer stopPlay];
    [self.vodPlayer removeVideoWidget];
    
    self.isLoaded = NO;
//    self.netWatcher.playerModel = self.playerModel;
//    if (self.playerModel.playingDefinition == nil) {
//        self.playerModel.playingDefinition = self.netWatcher.adviseDefinition;
//    }
    self.vodPlayer.enableHWAcceleration = YES;//硬件加速
    [self.vodPlayer startPlay:_playerModel.vedioUrl];
//    [self.vodPlayer setBitrateIndex:self.playerModel.playingDefinitionIndex]; //更改码率
    
//    [self.vodPlayer setRate:self.playerConfig.playRate]; //播放速度，默认1
//    [self.vodPlayer setMirror:NO];//是否镜像，默认NO
//    [self.vodPlayer setMute:NO];// 是否静音，默认NO
//    [self.vodPlayer setRenderMode:self.playerConfig.renderMode];// 填充模式，默认铺满
  
    self.state = StateBuffering;
    self.isPauseByUser = NO;
//    self.repeatBtn.hidden = YES;
    self.playDidEnd = NO;
}

///**
// *  创建手势
// */
//- (void)createGesture {
//    // 单击
//    self.singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction:)];
//    self.singleTap.delegate                = self;
//    self.singleTap.numberOfTouchesRequired = 1; //手指数
//    self.singleTap.numberOfTapsRequired    = 1;
//    [self addGestureRecognizer:self.singleTap];
//
//    // 解决点击当前view时候响应其他控件事件
//    [self.singleTap setDelaysTouchesBegan:YES];
//
//}

//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//
//}

#pragma mark - Action

/**
 *   轻拍方法
 *
 *  @param gesture UITapGestureRecognizer
 */
//- (void)singleTapAction:(UIGestureRecognizer *)gesture {
//    if (gesture.state == UIGestureRecognizerStateRecognized) {
//
//        if (self.playDidEnd) {
//            return;
//        }
//
//        if (self.isPauseByUser) {
//            [self resume];
//        } else {
//            [self pause];
//        }
//    }
//}


#pragma mark - NSNotification Action

/**
 *  播放完了
 *
 */
- (void)moviePlayDidEnd {
//    self.state = StateStopped;
//    self.playDidEnd = YES;
//    // 播放结束隐藏
//    if (SuperPlayerWindowShared.isShowing) {
//        [SuperPlayerWindowShared hide];
//        [self resetPlayer];
//    }
//    self.repeatBtn.hidden = NO;
}

/**
 *  应用退到后台
 */
- (void)appDidEnterBackground {
    NSLog(@"appDidEnterBackground");
    self.didEnterBackground     = YES;
    if (self.state == StatePlaying) {
        [_vodPlayer pause];
        self.state = StatePause;
    }
}

/**
 *  应用进入前台
 */
- (void)appDidEnterPlayground {
    NSLog(@"appDidEnterPlayground");
    self.didEnterBackground     = NO;
    if (!self.isPauseByUser && self.state == StatePause) {
        self.state = StatePlaying;
        self.isPauseByUser = NO;
        [self resume];
    }
}

#pragma mark - UIPanGestureRecognizer手势方法
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//
//    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
//        return YES;
//    }
//    return NO;
//}

#pragma mark - UIGestureRecognizerDelegate

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    
//    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
//        if (self.playDidEnd){
//            return NO;
//        }
//    }
//    return YES;
//}

#pragma mark - Setter

/**
 *  设置播放的状态
 *
 *  @param state ZFPlayerState
 */
- (void)setState:(SuperPlayerState)state {
    _state = state;
    // 控制菊花显示、隐藏
    if (state == StateBuffering) {
//        [self.spinner startAnimating];
    } else {
//        [self.spinner stopAnimating];
    }
    if (state == StatePlaying || state == StateBuffering) {
        
        if (self.coverImageView.alpha == 1) {
            [UIView animateWithDuration:0.2 animations:^{
                self.coverImageView.alpha = 0;
            }];
        }
    } else if (state == StateFailed) {
        
    } else if (state == StateStopped) {

        self.coverImageView.alpha = 1;
        
    } else if (state == StatePause) {
        
    }
}


#pragma mark - Getter

- (CGFloat)getTotalTime {
  
    return self.vodPlayer.duration;
}

- (CGFloat)getCurrentTime {
  
    return self.vodPlayer.currentPlaybackTime;
}

#pragma mark - SuperPlayerControlViewDelegate

//- (void)controlViewPlay:(SuperPlayerControlView *)controlView
//{
//    [self resume];
//    if (self.state == StatePause) { self.state = StatePlaying; }
//}
//
//- (void)controlViewPause:(SuperPlayerControlView *)controlView
//{
//    [self pause];
//    if (self.state == StatePlaying) { self.state = StatePause;}
//}
//
//- (void)controlViewBack:(SuperPlayerControlView *)controlView {
//    if ([self.delegate respondsToSelector:@selector(superPlayerBackAction:)]) {
//        [self.delegate superPlayerBackAction:self];
//    }
//}



//- (void)controlViewLockScreen:(SuperPlayerControlView *)controlView withLock:(BOOL)isLock {
//    self.isLockScreen = isLock;
//}



- (void)controlViewReload:(UIView *)controlView {
//    self.seekTime = [self.vodPlayer currentPlaybackTime];
//    [self configTXPlayer];
}


#pragma clang diagnostic pop
#pragma mark - 点播回调

- (void)_removeOldPlayer
{
    for (UIView *w in [self subviews]) {
        if ([w isKindOfClass:NSClassFromString(@"TXCRenderView")])
            [w removeFromSuperview];
        if ([w isKindOfClass:NSClassFromString(@"TXIJKSDLGLView")])
            [w removeFromSuperview];
        if ([w isKindOfClass:NSClassFromString(@"TXCAVPlayerView")])
            [w removeFromSuperview];
    }
}

-(void) onPlayEvent:(TXVodPlayer *)player event:(int)EvtID withParam:(NSDictionary*)param
{
    NSDictionary* dict = param;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (EvtID == PLAY_EVT_RCV_FIRST_I_FRAME) {
            [self setNeedsLayout];
            [self layoutIfNeeded];
            self.isLoaded = YES;
            [self _removeOldPlayer];
            [self.vodPlayer setupVideoWidget:self insertIndex:0];
            [self layoutSubviews];  // 防止横屏状态下添加view显示不全
            self.state = StatePlaying;
            
//            [self updatePlayerPoint];
        }
        if (EvtID == PLAY_EVT_VOD_PLAY_PREPARED) {
//            if (self.seekTime > 0) {
//                [player seek:self.seekTime];
//                self.seekTime = 0;
//            }
        }
        
        if (EvtID == PLAY_EVT_PLAY_BEGIN) {
            if (self.state == StateBuffering)
                self.state = StatePlaying;
        } else if (EvtID == PLAY_EVT_PLAY_PROGRESS) {
            if (self.state == StateStopped)
                return;
            
//            NSInteger currentTime = player.currentPlaybackTime;
//            CGFloat totalTime     = player.duration;
//            CGFloat value         = player.currentPlaybackTime / player.duration;
            
//            [self.controlView setProgressTime:currentTime totalTime:totalTime progressValue:value playableValue:player.playableDuration / player.duration];
            
        } else if (EvtID == PLAY_EVT_PLAY_END) {
            self.state = StateStopped;
            [self moviePlayDidEnd];
        } else if (EvtID == PLAY_ERR_NET_DISCONNECT || EvtID == PLAY_ERR_FILE_NOT_FOUND || EvtID == PLAY_ERR_HLS_KEY) {
            if (EvtID == PLAY_ERR_NET_DISCONNECT) {
//                [self showMiddleBtnMsg:kStrBadNetRetry withAction:ActionReplay];
            } else {
//                [self showMiddleBtnMsg:kStrLoadFaildRetry withAction:ActionReplay];
            }
            self.state = StateFailed;
            [player stopPlay];
        } else if (EvtID == PLAY_EVT_PLAY_LOADING){
            // 当缓冲是空的时候
            self.state = StateBuffering;
        } else if (EvtID == PLAY_EVT_CHANGE_RESOLUTION) {
            if (player.height != 0) {
                self.videoRatio = (GLfloat)player.width / player.height;
            }
        }
    });
}

//- (void)onNetStatus:(TXVodPlayer *)player withParam:(NSDictionary *)param {
//
//}


//- (void)updateBitrates:(NSArray<TXBitrateItem *> *)bitrates;
//{
//    if (bitrates.count > 0) {
//        NSArray *titles = [TXBitrateItemHelper sortWithBitrate:bitrates];
//        _playerModel.multiVideoURLs = titles;
//        self.netWatcher.playerModel = _playerModel;
//        _playerModel.playingDefinition = self.netWatcher.adviseDefinition;
//        [self.controlView playerBegin:_playerModel isLive:self.isLive isTimeShifting:self.isShiftPlayback];
//        [self.vodPlayer setBitrateIndex:_playerModel.playingDefinitionIndex];
//    }
//}

//- (void)updatePlayerPoint {
//    [self.controlView removeAllVideoPoints];
//
//    for (NSDictionary *keyFrameDesc in self.keyFrameDescList) {
//        NSInteger time = [J2Num([keyFrameDesc valueForKeyPath:@"timeOffset"]) intValue];
//        NSString *content = J2Str([keyFrameDesc valueForKeyPath:@"content"]);
//        [self.controlView addVideoPoint:time/1000.0/([self getTotalTime]+1)
//                                   text:[content stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
//                                   time:time];
//    }
//}

#pragma mark - Net

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.userInteractionEnabled = NO;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
        _coverImageView.alpha = 0;
        [self addSubview:_coverImageView];
        [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return _coverImageView;
}


@end
