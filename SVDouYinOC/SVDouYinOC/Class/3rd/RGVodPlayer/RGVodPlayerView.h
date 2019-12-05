//
//  RGVopPlayerView.h
//  RedGrass
//
//  Created by wukong on 2019/1/20.
//  Copyright © 2019年 hongcaosp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TXLiteAVSDK_UGC/TXVodPlayer.h>
#import "RGVodPlayerModel.h"


// 播放器的几种状态
typedef NS_ENUM(NSInteger, SuperPlayerState) {
    StateFailed,     // 播放失败
    StateBuffering,  // 缓冲中
    StatePlaying,    // 播放中
    StateStopped,    // 停止播放
    StatePause       // 暂停播放
};


@class RGVodPlayerView;

@protocol RGVodPlayerViewDelegate <NSObject>
@optional
/** 返回事件 */


@end


NS_ASSUME_NONNULL_BEGIN

@interface RGVodPlayerView : UIView<TXVodPlayListener,UIGestureRecognizerDelegate>

//播放进度、状态更新代理
//@property(nonatomic, weak) id<AVPlayerUpdateDelegate> delegate;
/** 播放器的状态 */
@property (nonatomic, assign) SuperPlayerState       state;
/// 是否在手势中
@property (readonly)  BOOL isDragging;
/**
 * 设置封面图片
 */
/** 是否被用户暂停 */
@property (nonatomic, assign) BOOL                 isPauseByUser;
// add for txvodplayer
@property (nonatomic, assign) BOOL                 isLoaded;
/** 播放完了*/
@property (nonatomic, assign) BOOL                 playDidEnd;

@property (strong, nonatomic) UIImageView *coverImageView;
//@property (strong, nonatomic) UIImageView *playStatusImgView;
@property (strong, nonatomic) NSString *coverImageUrl;

@property (assign, nonatomic) BOOL isPlaying;


/**
 * 播放model
 */
- (void)playWithModel:(RGVodPlayerModel *)playerModel;

-(BOOL) checkIsHavePlayModel;


////取消播放
//- (void)cancelLoading;
////更新AVPlayer状态，当前播放则暂停，当前暂停则播放
//- (void)updatePlayerState;
////移除KVO
//- (void)removeObserver;
//播放
- (void)play;
//暂停
- (void)pause;
////重新播放
//- (void)replay;
//播放速度
//- (CGFloat)rate;

@end

NS_ASSUME_NONNULL_END
