//
//  GKDYVideoPlayer.m
//  GKDYVideo
//
//  Created by QuintGao on 2018/9/23.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import "GKDYVideoPlayer.h"
#import <TXLiteAVSDK_UGC/TXLiveBase.h>
#import <TXLiteAVSDK_UGC/TXVodPlayer.h>
#import <TXLiteAVSDK_UGC/TXVodPlayListener.h>

@interface GKDYVideoPlayer()<TXVodPlayListener>

@property (nonatomic, strong) TXVodPlayer   *player;

@property (nonatomic, assign) float         duration;

@property (nonatomic, assign) BOOL          isNeedResume;
@property (nonatomic, strong) UIView *playView;

@end

@implementation GKDYVideoPlayer

- (instancetype)init {
    if (self = [super init]) {
        // 监听APP退出后台及进入前台
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark - Notification
// APP退出到后台
- (void)appDidEnterBackground:(NSNotification *)notify {
    if (self.status == GKDYVideoPlayerStatusLoading || self.status == GKDYVideoPlayerStatusPlaying) {
        [self pausePlay];
        
        self.isNeedResume = YES;
    }
}

// APP进入前台
- (void)appWillEnterForeground:(NSNotification *)notify {
    if (self.isNeedResume && self.status == GKDYVideoPlayerStatusPaused) {
        self.isNeedResume = NO;
        
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self resumePlay];
        });
    }
}

#pragma mark - Public Methods
- (void)playVideoWithView:(UIView *)playView url:(NSString *)url {
    // 设置播放视图
    [self.player setupVideoWidget:playView insertIndex:0];
    _playView = playView;
    
    // 准备播放
    [self playerStatusChanged:GKDYVideoPlayerStatusPrepared];
    
    // 开始播放
    if ([self.player startPlay:url] == 0) {
        // 这里可加入缓冲视图
    }else {
        [self playerStatusChanged:GKDYVideoPlayerStatusError];
    }
}

- (void)removeVideo {
    // 停止播放
    [self.player stopPlay];
    
    // 移除播放视图
    [self.player removeVideoWidget];
    
    // 改变状态
    [self playerStatusChanged:GKDYVideoPlayerStatusUnload];
}

- (void)pausePlay {
    [self.player pause];
    [self playerStatusChanged:GKDYVideoPlayerStatusPaused];
    
    
}

- (void)resumePlay {
    if (self.status == GKDYVideoPlayerStatusPaused) {
        [self.player resume];
        [self playerStatusChanged:GKDYVideoPlayerStatusPlaying];
    }
}

- (void)resetPlay {
    [self.player resume];
    [self playerStatusChanged:GKDYVideoPlayerStatusPlaying];
}

- (BOOL)isPlaying {
    return self.player.isPlaying;
}

#pragma mark - Private Methods
- (void)playerStatusChanged:(GKDYVideoPlayerStatus)status {
    self.status = status;
    
    if ([self.delegate respondsToSelector:@selector(player:statusChanged:)]) {
        [self.delegate player:self statusChanged:status];
    }
}

#pragma mark - TXVodPlayListener
- (void)onPlayEvent:(TXVodPlayer *)player event:(int)EvtID withParam:(NSDictionary *)param {
    switch (EvtID) {
        case PLAY_EVT_PLAY_LOADING:{    // loading
            if (self.status == GKDYVideoPlayerStatusPaused) {
                [self playerStatusChanged:GKDYVideoPlayerStatusPaused];
            }else {
                [self playerStatusChanged:GKDYVideoPlayerStatusLoading];
            }
        }
            break;
        case PLAY_EVT_PLAY_BEGIN:{    // 开始播放
           
            [self playerStatusChanged:GKDYVideoPlayerStatusPlaying];
        }
            break;
        case PLAY_EVT_PLAY_END:{    // 播放结束
            if ([self.delegate respondsToSelector:@selector(player:currentTime:totalTime:progress:)]) {
                [self.delegate player:self currentTime:self.duration totalTime:self.duration progress:1.0f];
            }
            
            [self playerStatusChanged:GKDYVideoPlayerStatusEnded];
        }
            break;
        case PLAY_ERR_NET_DISCONNECT:{    // 失败，多次重连无效
            [self playerStatusChanged:GKDYVideoPlayerStatusError];
        }
            break;
        case PLAY_EVT_PLAY_PROGRESS:{    // 进度
            if (self.status == GKDYVideoPlayerStatusPlaying) {
                self.duration = [param[EVT_PLAY_DURATION] floatValue];
                
                float currTime = [param[EVT_PLAY_PROGRESS] floatValue];
                
                float progress = self.duration == 0 ? 0 : currTime / self.duration;
                
                if ([self.delegate respondsToSelector:@selector(player:currentTime:totalTime:progress:)]) {
                    [self.delegate player:self currentTime:currTime totalTime:self.duration progress:progress];
                }
            }
        }
            break;
            
        default:
            break;
    }
}



- (void)onNetStatus:(TXVodPlayer *)player withParam:(NSDictionary *)param {
    
}

#pragma mark - 懒加载
- (TXVodPlayer *)player {
    if (!_player) {
        [TXLiveBase setLogLevel:LOGLEVEL_NULL];
        [TXLiveBase setConsoleEnabled:NO];

        _player = [TXVodPlayer new];
        _player.enableHWAcceleration = YES;//硬件加速
        [_player setRenderMode:self.renderMode];
        TXVodPlayConfig *config = [[TXVodPlayConfig alloc] init];
        config.maxCacheItems = 2;
        config.cacheFolderPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/TXCache"];
//        config.progressInterval = 0.03;
        //        config.playerType = PLAYER_AVPLAYER;
        [_player setConfig:config];
        _player.loop = YES;
        _player.vodDelegate = self;
    }
    return _player;
}

@end
