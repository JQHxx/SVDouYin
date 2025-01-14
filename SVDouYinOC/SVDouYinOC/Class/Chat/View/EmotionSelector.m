//
//  EmotionSelector.m
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import "EmotionSelector.h"

NSString * const kEmotionCell = @"EmotionCell";

@interface EmotionSelector () <UICollectionViewDelegate,UICollectionViewDataSource, UIGestureRecognizerDelegate, UIScrollViewDelegate>
@property (nonatomic, assign) CGFloat            itemWidth;
@property (nonatomic, assign) CGFloat            itemHeight;
@property (nonatomic, strong) NSMutableArray       *data;
@property (nonatomic, copy) NSDictionary         *emotionDic;
@property (nonatomic, strong) NSMutableArray       *pointViews;
@property (nonatomic, assign) NSInteger          currentIndex;
@property (nonatomic, strong) UIView             *bottomView;
@property (nonatomic, strong) UIButton           *send;
@end

@implementation EmotionSelector

-(instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, APP_WIDTH, EmotionSelectorHeight)];
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = RGB_COLOR(230.0, 230.0, 230.0, 1.0);
        self.clipsToBounds = NO;
        NSDictionary *data = [DYJsonUtil readJson2DicWithFileName:@"emotion"];
        _emotionDic = [data objectForKey:@"dict"];
        _data = [data objectForKey:@"array"];
        
        _itemWidth = APP_WIDTH/ 7.0f;
        _itemHeight = 50;
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.itemSize = CGSizeMake(_itemWidth, _itemHeight);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView  alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, _itemHeight * 3) collectionViewLayout:layout];
        _collectionView.clipsToBounds = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.alwaysBounceHorizontal = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[EmotionCell class] forCellWithReuseIdentifier:kEmotionCell];
        [self addSubview:_collectionView];
        
        _pointViews = [[NSMutableArray alloc] init];
        _currentIndex = 0;
        CGFloat indicatorWith = 5;
        CGFloat indicatorHeight = 5;
        CGFloat indicatorSpacing = 8;
        for(int i=0;i<_data.count;i++) {
            UIView *pointView = [[UIView alloc] initWithFrame:CGRectMake(APP_WIDTH/2-(indicatorWith*_data.count + indicatorSpacing*(_data.count-1))/2 + (indicatorWith + indicatorSpacing)*i, _collectionView.frame.size.height + 5, indicatorWith, indicatorHeight)];
            if(_currentIndex == i) {
                pointView.backgroundColor = [UIColor redColor];
            }else {
                pointView.backgroundColor = [UIColor grayColor];
            }
            pointView.layer.cornerRadius = indicatorWith/2;
            [_pointViews addObject:pointView];
            [self addSubview:pointView];
        }
        
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _collectionView.frame.size.height + 25, APP_WIDTH, 45 + BOTTOM_BAR_HEIGHT)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bottomView];
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _itemWidth, 45 + BOTTOM_BAR_HEIGHT)];
        leftView.backgroundColor = RGB_COLOR(230.0, 230.0, 230.0, 1.0);
        [_bottomView addSubview:leftView];
        
        UIImageView *defaultEmotion = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _itemWidth, 45)];
        defaultEmotion.contentMode = UIViewContentModeCenter;
        defaultEmotion.image = [UIImage imageNamed:@"default_emoticon_cover"];
        [leftView addSubview:defaultEmotion];
        
        _send = [[UIButton alloc] initWithFrame:CGRectMake(APP_WIDTH - 60 - 15, 10, 60, 25)];
        _send.enabled = NO;
        _send.backgroundColor = RGB_COLOR(230.0, 230.0, 230.0, 1.0);
        _send.layer.cornerRadius = 2;
        _send.titleLabel.font = [UIFont systemFontOfSize:14];
        [_send setTitle:@"发送" forState:UIControlStateNormal];
        [_send setTintColor:[UIColor whiteColor]];
        [_send addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_send];
        
        
    }
    return self;
}

-(void)updatePoints {
    for(int i=0;i<_pointViews.count;i++) {
        UIView *pointView = [_pointViews objectAtIndex:i];
        if(_currentIndex == i) {
            pointView.backgroundColor = RGB_COLOR(241.0, 47.0, 84.0, 1.0);
        }else {
            pointView.backgroundColor = [UIColor grayColor];
        }
    }
}

-(void)sendMessage {
    if(_delegate) {
        [_delegate onSend];
    }
}

-(void)addTextViewObserver:(UITextView *)textView {
    [textView addObserver:self forKeyPath:@"attributedText" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeTextViewObserver:(UITextView *)textView {
    [textView removeObserver:self forKeyPath:@"attributedText"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if([keyPath isEqualToString:@"attributedText"]){
        NSAttributedString *attributedString = [change objectForKey:NSKeyValueChangeNewKey];
        if(attributedString && attributedString.length > 0) {
            _send.backgroundColor = RGB_COLOR(241.0, 47.0, 84.0, 1.0);
            _send.enabled = YES;
        }else {
            _send.backgroundColor = RGB_COLOR(230.0, 230.0, 230.0, 1.0);
            _send.enabled = NO;
        }
    }else {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

//pragma UICollectionViewDataSource Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _data.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 21;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EmotionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kEmotionCell forIndexPath:indexPath];
    NSArray *array = _data[indexPath.section];
    if(indexPath.section < _data.count - 1) {
        if(indexPath.row < array.count) {
            [cell initData:array[indexPath.row]];
        }
    }else {
        if(indexPath.row % 3 != 2) {
            [cell initData:array[indexPath.row - indexPath.row/3]];
        }
    }
    if(indexPath.row == 20) {
        [cell setDelete];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(_delegate) {
        if(indexPath.row == 20) {
            [_delegate onDelete];
        }else {
            EmotionCell *cell = (EmotionCell *)[collectionView cellForItemAtIndexPath:indexPath];
            if(cell.emotionKey) {
                [_delegate onSelect:cell.emotionKey];
            }
        }
    }
}

//scrollview delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGPoint translatedPoint = [scrollView.panGestureRecognizer translationInView:scrollView];
    scrollView.panGestureRecognizer.enabled = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        if(translatedPoint.x < 0 && self.currentIndex < (self.data.count - 1)) {
            self.currentIndex ++;
        }
        if(translatedPoint.x > 0 && self.currentIndex > 0) {
            self.currentIndex --;
        }
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut animations:^{
                                [self updatePoints];
                                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.currentIndex] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
                            } completion:^(BOOL finished) {
                                scrollView.panGestureRecognizer.enabled = YES;
                            }];
    });
}


@end

#pragma Emotion Cell
@implementation EmotionCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        _emotion = [[UIImageView alloc] initWithFrame:self.bounds];
        _emotion.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:_emotion];
    }
    return self;
}
- (void)prepareForReuse {
    [super prepareForReuse];
    _emotion.image = nil;
}
- (void)setDelete {
    _emotion.image = [UIImage imageNamed:@"iconLaststep"];
    _emotionKey = nil;
}
- (void)initData:(NSString *)key {
    _emotionKey = key;
    NSString *emoticonsPath = [[NSBundle mainBundle]pathForResource:@"Emoticons"ofType:@"bundle"];
    NSString *arrowPath = [emoticonsPath stringByAppendingPathComponent:key];
    _emotion.image = [UIImage imageWithContentsOfFile:arrowPath];
}

@end
