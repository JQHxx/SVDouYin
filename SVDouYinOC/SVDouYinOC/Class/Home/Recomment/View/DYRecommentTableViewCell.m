//
//  DYRecommentTableViewCell.m
//  SVDouYinOC
//
//  Created by HJQ on 2019/11/11.
//  Copyright © 2019 HJQ. All rights reserved.
//

#import "DYRecommentTableViewCell.h"
#import "DYRemoteVedioDownLoadHelper.h"
#import "AVPlayerView.h"
#import "DYRecommentModel.h"
#import "DYFocusView.h"
#import "DYFavoriteView.h"
#import "DYMusicAlbumView.h"
#import "DYCircleTextView.h"
#import "DYSharePopView.h"

@interface DYRecommentTableViewCell() <AVPlayerUpdateDelegate, DYSharePopViewDelegate>

@property (nonatomic, strong) UIView *container;
@property (nonatomic ,strong) UIImageView  *musicIcon;

// 暂停按钮
@property (nonatomic ,strong) UIImageView *pauseIcon;
@property (nonatomic, assign) NSTimeInterval           lastTapTime;
@property (nonatomic, assign) CGPoint                  lastTapPoint;

// 进度条
@property (nonatomic ,strong) CAGradientLayer          *gradientLayer;
@property (nonatomic, strong) UIView                   *playerStatusBar;

@end

@implementation DYRecommentTableViewCell

CGFloat avatarRadius = 25;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.01];
        _lastTapTime = 0;
        _lastTapPoint = CGPointZero;
        [self initSubViews];
        [self viewBindEvents];
        [self setupLayout];
    }
    return self;

}

-(void)layoutSubviews {
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _gradientLayer.frame = CGRectMake(0, self.frame.size.height - 500, self.frame.size.width, 500);
    [CATransaction commit];
}

-(void)prepareForReuse {
    [super prepareForReuse];
    _isPlayerReady = NO;

    [_playerView cancelLoading];
    [_pauseIcon setHidden:YES];

    [_avatar setImage:[UIImage imageNamed:@"img_find_default"]];
    [_focus resetView];
    [_favorite resetView];
    [_musicAlum resetView];


}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) initSubViews {
    _playerView = [AVPlayerView new];
    _playerView.delegate = self;
    [self.contentView addSubview:_playerView];

    //init hover on player view container
    _container = [UIView new];
    [self.contentView addSubview:_container];

    // 暂停按钮
    _pauseIcon = [[UIImageView alloc] init];
    _pauseIcon.image = [UIImage imageNamed:@"icon_play_pause"];
    _pauseIcon.contentMode = UIViewContentModeCenter;
    _pauseIcon.layer.zPosition = 3;
    _pauseIcon.hidden = YES;
    [_container addSubview:_pauseIcon];


    /// 右边
    //init avatar
    _avatar = [[UIImageView alloc] init];
    _avatar.image = [UIImage imageNamed:@"img_find_default"];
    _avatar.layer.cornerRadius = avatarRadius;
    _avatar.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8].CGColor;
    _avatar.layer.borderWidth = 1;
    [_container addSubview:_avatar];

    //init focus action
    _focus = [DYFocusView new];
    [_container addSubview:_focus];

    _favorite = [DYFavoriteView new];
    [_container addSubview:_favorite];

    _favoriteNum = [[UILabel alloc]init];
     _favoriteNum.text = @"0";
     _favoriteNum.textColor = [UIColor whiteColor];
     _favoriteNum.font = [UIFont systemFontOfSize:12.0];
     [_container addSubview:_favoriteNum];

    // 评论数
    _comment = [[UIImageView alloc]init];
     _comment.contentMode = UIViewContentModeCenter;
     _comment.image = [UIImage imageNamed:@"icon_home_comment"];
     _comment.userInteractionEnabled = YES;
     [_comment addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commonHandleGesture:)]];
     [_container addSubview:_comment];

     _commentNum = [[UILabel alloc]init];
     _commentNum.text = @"0";
     _commentNum.textColor = [UIColor whiteColor];
     _commentNum.font = [UIFont systemFontOfSize:12.0];
     [_container addSubview:_commentNum];

    //init share、comment、like action view
    _share = [[UIImageView alloc]init];
    _share.contentMode = UIViewContentModeCenter;
    _share.image = [UIImage imageNamed:@"icon_home_share"];
    _share.userInteractionEnabled = YES;
    [_share addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareHandleGesture:)]];
    [_container addSubview:_share];

    _shareNum = [[UILabel alloc]init];
    _shareNum.text = @"0";
    _shareNum.textColor = [UIColor whiteColor];
    _shareNum.font = [UIFont systemFontOfSize:12.0];
    [_container addSubview:_shareNum];

    //init music alum view
    _musicAlum = [DYMusicAlbumView new];
    [_container addSubview:_musicAlum];


    /// 左边内容
    //init aweme message
    _musicIcon = [[UIImageView alloc]init];
    _musicIcon.contentMode = UIViewContentModeCenter;
    _musicIcon.image = [UIImage imageNamed:@"icon_home_musicnote3"];
    [_container addSubview:_musicIcon];

    _musicName = [[DYCircleTextView alloc]init];
    _musicName.textColor = [UIColor whiteColor];
    _musicName.font = [UIFont systemFontOfSize:14.0];
    [_container addSubview:_musicName];


    _desc = [[UILabel alloc]init];
    _desc.numberOfLines = 0;
    _desc.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    _desc.font = [UIFont systemFontOfSize:14.0];
    [_container addSubview:_desc];


    _nickName = [[UILabel alloc]init];
    _nickName.textColor = [UIColor whiteColor];
    _nickName.font = [UIFont boldSystemFontOfSize:14.0];
    [_container addSubview:_nickName];


    // 进度加载条
    _gradientLayer = [CAGradientLayer layer];
     _gradientLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor, (__bridge id)RGB_COLOR(0, 0, 0, 0.2).CGColor, (__bridge id)RGB_COLOR(0, 0, 0, 0.4).CGColor];
     _gradientLayer.locations = @[@0.3, @0.6, @1.0];
     _gradientLayer.startPoint = CGPointMake(0.0f, 0.0f);
     _gradientLayer.endPoint = CGPointMake(0.0f, 1.0f);
     [_container.layer addSublayer:_gradientLayer];

    //init player status bar
    _playerStatusBar = [[UIView alloc]init];
    _playerStatusBar.backgroundColor = [UIColor whiteColor];
    [_playerStatusBar setHidden:YES];
    [_container addSubview:_playerStatusBar];
    

}

- (void) setupLayout {

    __weak typeof(self) weakSelf = self;

    [_pauseIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.mas_equalTo(100);
    }];

    [_playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf);
    }];

    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf);
    }];

    // 右边
    [_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.favorite.mas_top).inset(35);
        make.right.equalTo(self).inset(10);
        make.width.height.mas_equalTo(avatarRadius*2);
    }];

    [_focus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.avatar);
        make.centerY.equalTo(self.avatar.mas_bottom);
        make.width.height.mas_equalTo(24);
    }];

    [_favorite mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.comment.mas_top).inset(25);
        make.right.equalTo(self).inset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(45);
    }];

    [_favoriteNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.favorite.mas_bottom);
        make.centerX.equalTo(self.favorite);
    }];

    [_comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.share.mas_top).inset(25);
        make.right.equalTo(self).inset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(45);
    }];
    [_commentNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.comment.mas_bottom);
        make.centerX.equalTo(self.comment);
    }];

    [_share mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.musicAlum.mas_top).inset(50);
        make.right.equalTo(self).inset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(45);
    }];
    [_shareNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.share.mas_bottom);
        make.centerX.equalTo(self.share);
    }];

    [_musicAlum mas_makeConstraints:^(MASConstraintMaker *make) {
        /*
       if (@available(iOS 11.0, *)) { make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).mas_offset(-60);
       } else {
           make.bottom.equalTo(self.mas_bottom).mas_offset(-15);
       }
         */
        make.bottom.equalTo(self).inset(60 + BOTTOM_BAR_HEIGHT);
        make.right.equalTo(self).inset(10);
        make.width.height.mas_equalTo(50);
    }];


    // 左边
    [_musicIcon mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(self);
         make.bottom.equalTo(self).inset(60 + BOTTOM_BAR_HEIGHT);
         make.width.mas_equalTo(30);
         make.height.mas_equalTo(25);
     }];

     [_musicName mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(self.musicIcon.mas_right);
         make.centerY.equalTo(self.musicIcon);
         make.width.mas_equalTo(APP_WIDTH/2);
         make.height.mas_equalTo(24);
     }];
     [_desc mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(self).offset(10);
         make.bottom.equalTo(self.musicIcon.mas_top);
         make.width.mas_lessThanOrEqualTo(APP_WIDTH/5*3);
     }];
     [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(self).offset(10);
         make.bottom.equalTo(self.desc.mas_top).inset(5);
         make.width.mas_lessThanOrEqualTo(APP_WIDTH/4*3 + 30);
     }];


    // 进度条
    [_playerStatusBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        //make.bottom.equalTo(self).inset(49.5f + SafeAreaBottomHeight);
        if (@available(iOS 11.0, *)) { make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.mas_bottom);
        }
        make.width.mas_equalTo(1.0f);
        make.height.mas_equalTo(0.5f);
    }];

    
}

- (void) viewBindEvents {
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [_container addGestureRecognizer:tapGes];
}

#pragma mark - Event response
- (void) commonHandleGesture:(UIGestureRecognizer *)ges {

}

- (void) shareHandleGesture:(UIGestureRecognizer *)ges {
    DYSharePopView *popView = [[DYSharePopView alloc] init];
    popView.delegate = self;
    [popView show];
}

- (void)handleGesture:(UITapGestureRecognizer *)sender {
    //获取点击坐标，用于设置爱心显示位置
    CGPoint point = [sender locationInView:_container];
    //获取当前时间
    NSTimeInterval time = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
    //判断当前点击时间与上次点击时间的时间间隔
    if(time - _lastTapTime > 0.25f) {
        //推迟0.25秒执行单击方法
        [self performSelector:@selector(singleTapAction) withObject:nil afterDelay:0.25f];
    }else {
        //取消执行单击方法
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTapAction) object: nil];
        //执行连击显示爱心的方法
        [self showLikeViewAnim:point oldPoint:_lastTapPoint];
    }
    //更新上一次点击位置
    _lastTapPoint = point;
    //更新上一次点击时间
    _lastTapTime =  time;

}

- (void)singleTapAction {
    [self showPauseViewAnim:[_playerView rate]];
    [_playerView updatePlayerState];
}

//暂停播放动画
- (void)showPauseViewAnim:(CGFloat)rate {
    if(rate == 0) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             self.pauseIcon.alpha = 0.0f;
                         } completion:^(BOOL finished) {
                             [self.pauseIcon setHidden:YES];
                         }];
    }else {
        [_pauseIcon setHidden:NO];
        _pauseIcon.transform = CGAffineTransformMakeScale(1.8f, 1.8f);
        _pauseIcon.alpha = 1.0f;
        [UIView animateWithDuration:0.25f delay:0
                            options:UIViewAnimationOptionCurveEaseIn animations:^{
                                self.pauseIcon.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                            } completion:^(BOOL finished) {
                            }];
    }
}

- (void)showLikeViewAnim:(CGPoint)newPoint oldPoint:(CGPoint)oldPoint {
    UIImageView *likeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_home_like_after"]];
    CGFloat k = ((oldPoint.y - newPoint.y)/(oldPoint.x - newPoint.x));
    k = fabs(k) < 0.5 ? k : (k > 0 ? 0.5f : -0.5f);
    CGFloat angle = M_PI_4 * -k;
    likeImageView.frame = CGRectMake(newPoint.x, newPoint.y, 80, 80);
    likeImageView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(angle), 0.8f, 1.8f);
    [_container addSubview:likeImageView];
    [UIView animateWithDuration:0.2f
                          delay:0.0f
         usingSpringWithDamping:0.5f
          initialSpringVelocity:1.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         likeImageView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(angle), 1.0f, 1.0f);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.5f
                                               delay:0.5f
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              likeImageView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(angle), 3.0f, 3.0f);
                                              likeImageView.alpha = 0.0f;
                                          }
                                          completion:^(BOOL finished) {
                                              [likeImageView removeFromSuperview];
                                          }];
                     }];
}


//加载动画
-(void)startLoadingPlayItemAnim:(BOOL)isStart {
    if (isStart) {
        _playerStatusBar.backgroundColor = [UIColor whiteColor];
        [_playerStatusBar setHidden:NO];
        [_playerStatusBar.layer removeAllAnimations];

        CAAnimationGroup *animationGroup = [[CAAnimationGroup alloc]init];
        animationGroup.duration = 0.5;
        animationGroup.beginTime = CACurrentMediaTime() + 0.5;
        animationGroup.repeatCount = MAXFLOAT;
        animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

        CABasicAnimation * scaleAnimation = [CABasicAnimation animation];
        scaleAnimation.keyPath = @"transform.scale.x";
        scaleAnimation.fromValue = @(1.0f);
        scaleAnimation.toValue = @(1.0f * APP_WIDTH);

        CABasicAnimation * alphaAnimation = [CABasicAnimation animation];
        alphaAnimation.keyPath = @"opacity";
        alphaAnimation.fromValue = @(1.0f);
        alphaAnimation.toValue = @(0.5f);
        [animationGroup setAnimations:@[scaleAnimation, alphaAnimation]];
        [self.playerStatusBar.layer addAnimation:animationGroup forKey:nil];
    } else {
        [self.playerStatusBar.layer removeAllAnimations];
        [self.playerStatusBar setHidden:YES];
    }

}

/// 快进
- (void)handleSlide:(UISlider *)slider{
    CMTime time = CMTimeMakeWithSeconds(_playerView.duration * slider.value, _playerView.fps);
    //NSString *timeText = [NSString stringWithFormat:@"%@/%@", [self convert:_duration * slider.value], [self convert:_duration]];
    //_bottomView.timeLabel.text = timeText;
    [_playerView seekToTime:time];
}

- (void)initData:(DYRecommentData *)recomment {
    _recomment = recomment;

    [_nickName setText:[NSString stringWithFormat:@"@%@", recomment.author.nickname]];
    [_desc setText:recomment.desc];
    [_musicName setText:[NSString stringWithFormat:@"%@ - %@", recomment.music.title, recomment.music.author]];
    [_favoriteNum setText:[NSString formatCount:recomment.statistics.digg_count]];
    [_commentNum setText:[NSString formatCount:recomment.statistics.comment_count]];
    [_shareNum setText:[NSString formatCount:recomment.statistics.share_count]];

    __weak typeof(self) weakSelf = self;
    [_musicAlum.album sd_setImageWithURL:[NSURL URLWithString:recomment.music.cover_thumb.url_list.firstObject] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            weakSelf.musicAlum.album.image = [image drawCircleImage];
    }];

    [_avatar sd_setImageWithURL:[NSURL URLWithString:recomment.author.avatar_thumb.url_list.firstObject] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            weakSelf.avatar.image = [image drawCircleImage];
    }];

}

- (void)play {
    [_playerView play];
    [_pauseIcon setHidden:YES];
    [_musicAlum startAnimation:_recomment.rate];
}

- (void)pause {
    [_playerView pause];
    [_pauseIcon setHidden:NO];
}

- (void)replay {
    [_playerView replay];
    [_pauseIcon setHidden:YES];
}

- (void)startDownloadBackgroundTask {
    NSString *playUrl = [[IHttpRequest shareRequest] isHasWifi] ? _recomment.video.play_addr.url_list.firstObject : _recomment.video.play_addr_lowbr.url_list.firstObject;
    [_playerView setPlayerWithUrl:playUrl];
}

- (void)startDownloadHighPriorityTask {
    NSString *playUrl = [[IHttpRequest shareRequest] isHasWifi]? _recomment.video.play_addr.url_list.firstObject : _recomment.video.play_addr_lowbr.url_list.firstObject;
      [_playerView startDownloadTask:[[NSURL alloc] initWithString:playUrl] isBackground:NO];

}

#pragma mark - AVPlayerUpdateDelegate
-(void)onProgressUpdate:(CGFloat)current total:(CGFloat)total {
    //播放进度更新
}

-(void)onPlayItemStatusUpdate:(AVPlayerItemStatus)status {

    switch (status) {
        case AVPlayerItemStatusUnknown:
            [self startLoadingPlayItemAnim:YES];
            break;
        case AVPlayerItemStatusReadyToPlay:
            [self startLoadingPlayItemAnim:NO];
            _isPlayerReady = YES;
           [_musicAlum startAnimation:_recomment.rate];

            if(_onPlayerReady) {
                _onPlayerReady();
            }
            break;
        case AVPlayerItemStatusFailed:
            [self startLoadingPlayItemAnim:NO];
            //[UIWindow showTips:@"加载失败"];
            break;
        default:
            break;
    }

}

#pragma mark - DYSharePopViewDelegate
- (void)sharePopViewActionItem:(NSInteger)tag {
    if (tag == 1) { // 下载
        NSString *playUrl = [[IHttpRequest shareRequest] isHasWifi] ? _recomment.video.play_addr.url_list.firstObject : _recomment.video.play_addr_lowbr.url_list.firstObject;
        [[DYRemoteVedioDownLoadHelper downLoadhepler] downLoadRemoteVedioWithUrl:playUrl];
    }
}

- (void)sharePopViewShareItem:(NSInteger)tag {

}

@end
