//
//  DYRecommentTableViewCell.h
//  SVDouYinOC
//
//  Created by HJQ on 2019/11/11.
//  Copyright © 2019 HJQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^OnPlayerReady)(void);

@class DYRecommentData;
@class AVPlayerView;
@class DYFocusView;
@class DYFavoriteView;
@class DYMusicAlbumView;
@class DYCircleTextView;

@interface DYRecommentTableViewCell : UITableViewCell

@property (nonatomic, strong) DYRecommentData  *recomment;
@property (nonatomic, strong) AVPlayerView *playerView;

/// 左边
// 歌曲名循环
@property (nonatomic, strong) DYCircleTextView   *musicName;
@property (nonatomic, strong) UILabel          *desc;
@property (nonatomic, strong) UILabel          *nickName;

// 头像
@property (nonatomic, strong) UIImageView *avatar;
// 添加关注
@property (nonatomic, strong) DYFocusView *focus;
// 喜欢
@property (nonatomic, strong) DYFavoriteView *favorite;
@property (nonatomic, strong) UILabel *favoriteNum;
// 评论数
@property (nonatomic, strong) UIImageView *comment;
@property (nonatomic, strong) UILabel  *commentNum;
// 分享数
@property (nonatomic, strong) UIImageView  *share;
@property (nonatomic, strong) UILabel *shareNum;
// 音乐旋转
@property (nonatomic, strong) DYMusicAlbumView *musicAlum;


@property (nonatomic, strong) OnPlayerReady onPlayerReady;
@property (nonatomic, assign) BOOL isPlayerReady;

- (void)initData:(DYRecommentData *)recomment;
- (void)play;
- (void)pause;
- (void)replay;
- (void)startDownloadBackgroundTask;
- (void)startDownloadHighPriorityTask;

@end

NS_ASSUME_NONNULL_END
