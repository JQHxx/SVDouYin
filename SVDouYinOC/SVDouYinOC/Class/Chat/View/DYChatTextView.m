//
//  DYChatTextView.m
//  SVDouYinOC
//
//  Created by HJQ on 2019/11/16.
//  Copyright © 2019 HJQ. All rights reserved.
//

#import "DYChatTextView.h"
#import <Photos/Photos.h>
#import "EmotionHelper.h"
#import "EmotionSelector.h"
#import "PhotoSelector.h"

static const CGFloat kChatTextViewLeftInset      = 15;
static const CGFloat kChatTextViewRightInset     = 85;
static const CGFloat kChatTextViewTopBottomInset = 15;

@interface DYChatTextView() <UITextViewDelegate, UIGestureRecognizerDelegate, EmotionSelectorDelegate, PhotoSelectorDelegate>
{
    EmotionSelector        *emotionSelector;
    PhotoSelector          *photoSelector;
}

@property (nonatomic, assign) int maxNumberOfLine;
@property (nonatomic, assign) CGFloat textHeight;
@property (nonatomic, assign) CGFloat containerBoardHeight;

@property (nonatomic, retain) UILabel *placeholderLabel;
// 表情
@property (nonatomic, strong) UIButton *emotionBtn;
// 图片
@property (nonatomic, strong) UIButton *photoBtn;
@property (nonatomic, strong) UIVisualEffectView *visualEffectView;

@end

@implementation DYChatTextView

- (instancetype)init
{
    return [self initWithFrame:UIScreen.mainScreen.bounds];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initData];
        [self setupUI];
        [self viewBindEvents];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateContainerFrame];

    _photoBtn.frame = CGRectMake(APP_WIDTH - 50, 0, 50, 50);
    _emotionBtn.frame = CGRectMake(APP_WIDTH - 85, 0, 50, 50);

    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10.0f, 10.0f)];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    _container.layer.mask = shape;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if(hitView == self){
        if(_editMessageType == EditNoneMessage) {
            return nil;
        }
    }
    return hitView;
}

- (void)dealloc {
    [emotionSelector removeTextViewObserver:_textView];
    [self removeObserver:self forKeyPath:@"containerBoardHeight"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private methods
- (void) initData {
    _containerBoardHeight = BOTTOM_BAR_HEIGHT;
    _editMessageType = EditNoneMessage;
    _textHeight = ceilf(self.textView.font.lineHeight);
}

- (void) setupUI {
    [self addSubview:self.container];
    [self.container addSubview:self.textView];
    [self.textView addSubview:self.placeholderLabel];
    [self.textView addSubview:self.emotionBtn];
    [self.textView addSubview:self.photoBtn];
}

- (void) viewBindEvents {

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGuesture:)];
    tapGestureRecognizer.delegate = self;
    [self addGestureRecognizer:tapGestureRecognizer];

    // 监听键盘的高度
    [self addObserver:self forKeyPath:@"containerBoardHeight" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];

       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)updateContainerFrame {
    CGFloat textViewHeight = _containerBoardHeight > BOTTOM_BAR_HEIGHT ? _textHeight + 2*kChatTextViewTopBottomInset : [UIFont systemFontOfSize:16].lineHeight + 2*kChatTextViewTopBottomInset;
    _textView.frame = CGRectMake(0, 0, APP_WIDTH,  textViewHeight);
    [UIView animateWithDuration:0.0f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                        // 重要， 设置布局的位置
                         self.container.frame = CGRectMake(0, APP_HEIGHT - self.containerBoardHeight - textViewHeight, APP_WIDTH,  self.containerBoardHeight + textViewHeight);
                         if(self.delegate) {
                             [self.delegate onEditBoardHeightChange:self.container.frame.size.height];
                         }
                     }
                     completion:^(BOOL finished) {
                     }];

}

- (void)updateSelectorFrame:(BOOL)animated {
    CGFloat textViewHeight = _containerBoardHeight > 0 ? _textHeight + 2*kChatTextViewTopBottomInset : [UIFont systemFontOfSize:16].lineHeight + 2*kChatTextViewTopBottomInset;
    if(animated) {
        switch (self.editMessageType) {
            case EditEmotionMessage:
                [self.emotionSelector setHidden : NO];
                self.emotionSelector.frame = CGRectMake(0, textViewHeight + self.containerBoardHeight, APP_WIDTH,  self.containerBoardHeight);
                break;
            case EditPhotoMessage:
                [self.photoSelector setHidden : NO];
                self.photoSelector.frame = CGRectMake(0, textViewHeight + self.containerBoardHeight, APP_WIDTH,  self.containerBoardHeight);
                break;
            default:
                break;
        }
    }
    [UIView animateWithDuration:0.25f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         switch (self.editMessageType) {
                             case EditEmotionMessage:
                                 self.emotionSelector.frame = CGRectMake(0, textViewHeight, APP_WIDTH,  self.containerBoardHeight);
                                 self.photoSelector.frame = CGRectMake(0, textViewHeight + self.containerBoardHeight, APP_WIDTH,  self.containerBoardHeight);
                                 break;
                             case EditPhotoMessage:
                                 self.photoSelector.frame = CGRectMake(0, textViewHeight, APP_WIDTH,  self.containerBoardHeight);
                                 self.emotionSelector.frame = CGRectMake(0, textViewHeight + self.containerBoardHeight, APP_WIDTH,  self.containerBoardHeight);
                                 break;
                             default:
                                 self.photoSelector.frame = CGRectMake(0, textViewHeight + self.containerBoardHeight, APP_WIDTH,  self.containerBoardHeight);
                                 self.emotionSelector.frame = CGRectMake(0, textViewHeight + self.containerBoardHeight, APP_WIDTH,  self.containerBoardHeight);
                                 break;
                         }
                     }
                     completion:^(BOOL finished) {
                         switch (self.editMessageType) {
                             case EditEmotionMessage:
                                 [self.photoSelector setHidden : YES];
                                 break;
                             case EditPhotoMessage:
                                 [self.emotionSelector setHidden : YES];
                                 break;
                             default:
                                 [self.photoSelector setHidden : YES];
                                 [self.emotionSelector setHidden : YES];
                                 break;
                         }
                     }];
}

//删除
- (void)onDelete {
    [_textView deleteBackward];
}

//添加表情
- (void)onSelect:(NSString *)emotionKey {
    [_placeholderLabel setHidden:true];

    NSInteger location = _textView.selectedRange.location;
    [_textView setAttributedText:[EmotionHelper insertEmotion:_textView.attributedText index:location emotionKey:emotionKey]];
    [_textView setSelectedRange:NSMakeRange(location + 1, 0)];
    _textHeight = [_textView.attributedText multiLineSize:APP_WIDTH - kChatTextViewLeftInset - kChatTextViewRightInset].height;

    [self updateContainerFrame];
    [self updateSelectorFrame:NO];
}

//发送文字
- (void)onSend {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:_textView.attributedText];
    NSAttributedString *text = [EmotionHelper emotionToString:attributedString];
    if(_delegate) {
        if([_textView hasText]) {
            [self.delegate onSendText:text.string];
            [_placeholderLabel setHidden:NO];
            [_textView setText:@""];
            _textHeight = ceilf(_textView.font.lineHeight);
            [self updateContainerFrame];
            [self updateSelectorFrame:NO];
        }else {
            [self hideContainerBoard];
            //[UIWindow showTips:@"请输入文字"];
        }
    }
}

//发送图片
- (void)onSend:(NSMutableArray<UIImage *> *)selectedImages {
    if(_delegate) {
        [_delegate onSendImages:selectedImages];
    }
}

//隐藏编辑板
- (void)hideContainerBoard {
    _editMessageType = EditNoneMessage;
    [self setContainerBoardHeight:BOTTOM_BAR_HEIGHT];
    [self updateSelectorFrame:YES];
    [self updateContainerFrame];
    [_textView resignFirstResponder];
    [_emotionBtn setSelected:NO];
    [_photoBtn setSelected:NO];
}


#pragma mark - Event response
// keyboard notification
- (void)keyboardWillShow:(NSNotification *)notification {
    _editMessageType = EditTextMessage;
    [_emotionBtn setSelected:NO];
    [_photoBtn setSelected:NO];
    [self setContainerBoardHeight:[notification keyBoardHeight]];
    [self updateContainerFrame];
    [self updateSelectorFrame:YES];
 }

// 选择表情
- (void) emotionAction {
    [_emotionBtn setSelected:!_emotionBtn.selected];
          [_photoBtn setSelected:NO];
          if(_emotionBtn.isSelected) {
              _editMessageType = EditEmotionMessage;
              [self setContainerBoardHeight:EmotionSelectorHeight];
              [self updateContainerFrame];
              [self updateSelectorFrame:YES];
              [_textView resignFirstResponder];
          }else {
              _editMessageType = EditTextMessage;
              [_textView becomeFirstResponder];
          }
}

// 选择相片
- (void) photoAction {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
         if(PHAuthorizationStatusAuthorized == status) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.photoBtn setSelected:!self.photoBtn.selected];
                 [self.emotionBtn setSelected:NO];
                 if(self.photoBtn.isSelected) {
                     self.editMessageType = EditPhotoMessage;
                     [self setContainerBoardHeight:PhotoSelectorHeight];
                     [self updateContainerFrame];
                     [self updateSelectorFrame:YES];
                     [self.textView resignFirstResponder];
                 }else {
                     [self hideContainerBoard];
                 }
             });
         }else {
             //[UIWindow showTips:@"请在设置中开启图库读取权限"];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
             });
         }
}

- (void)handleGuesture:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:_container];
    if(![_container.layer containsPoint:point]) {
        [self hideContainerBoard];
    }
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if([keyPath isEqualToString:@"containerBoardHeight"]) {
        if(_containerBoardHeight == BOTTOM_BAR_HEIGHT ){
            _container.backgroundColor = RGB_COLOR(20.0, 21.0, 30.0, 1.0);
            _textView.textColor = [UIColor whiteColor];

            [_emotionBtn setImage:[UIImage imageNamed:@"baseline_emotion_white"] forState:UIControlStateNormal];
            [_photoBtn setImage:[UIImage imageNamed:@"outline_photo_white"] forState:UIControlStateNormal];
        }else {
            _container.backgroundColor = [UIColor whiteColor];
            _textView.textColor = [UIColor blackColor];

            [_emotionBtn setImage:[UIImage imageNamed:@"baseline_emotion_grey"] forState:UIControlStateNormal];
            [_photoBtn setImage:[UIImage imageNamed:@"outline_photo_grey"] forState:UIControlStateNormal];
        }
    }else {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }

}


#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:textView.attributedText];
    if(!textView.hasText) {
        [_placeholderLabel setHidden:NO];
        _textHeight = ceilf(_textView.font.lineHeight);
    }else {
        [_placeholderLabel setHidden:YES];
        _textHeight = [attributedString multiLineSize:APP_WIDTH - kChatTextViewLeftInset - kChatTextViewRightInset].height;
    }
    [self updateContainerFrame];
   [self updateSelectorFrame:NO];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [self onSend];
        return NO;
    }
    return YES;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view.superview class]) isEqualToString:@"EmotionCell"]
        ||[NSStringFromClass([touch.view.superview class]) isEqualToString:@"PhotoCell"]) {
        return NO;
    }else {
        return YES;
    }
}

#pragma mark - Public methods
- (void)show {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
}

- (void)dismiss {
    [self removeFromSuperview];
}

#pragma mark - Setter & Getter
- (UIView *)container {
    if (!_container) {
        _container = [[UIView alloc]initWithFrame:UIScreen.mainScreen.bounds];
        _container.backgroundColor = RGB_COLOR(20.0, 21.0, 30.0, 1.0);
    }
    return _container;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, APP_HEIGHT, APP_WIDTH, 0)];
        _textView.delegate = self;
        _textView.backgroundColor = [UIColor clearColor];
        _textView.clipsToBounds = NO;
        _textView.textColor = [UIColor whiteColor];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.returnKeyType = UIReturnKeySend;
        _textView.scrollEnabled = NO;
        _textView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
        _textView.textContainerInset = UIEdgeInsetsMake(kChatTextViewTopBottomInset, kChatTextViewLeftInset, kChatTextViewTopBottomInset, kChatTextViewRightInset);
        _textView.textContainer.lineFragmentPadding = 0;
    }
    return _textView;
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc]init];
        _placeholderLabel.text = @"发送消息...";
        _placeholderLabel.textColor = [UIColor grayColor];
        _placeholderLabel.font = [UIFont systemFontOfSize:16];
        _placeholderLabel.frame = CGRectMake(kChatTextViewLeftInset, 0, APP_WIDTH - kChatTextViewLeftInset - kChatTextViewRightInset, 50);
    }
    return _placeholderLabel;
}

- (UIButton *)emotionBtn {
    if (!_emotionBtn) {
        _emotionBtn = [[UIButton alloc] init];
        [_emotionBtn setImage:[UIImage imageNamed:@"baseline_emotion_white"] forState:UIControlStateNormal];
        [_emotionBtn setImage:[UIImage imageNamed:@"outline_keyboard_grey"] forState:UIControlStateSelected];
        [_emotionBtn addTarget:self action:@selector(emotionAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emotionBtn;
}

- (UIButton *)photoBtn {
    if (!_photoBtn) {
        _photoBtn = [[UIButton alloc] init];
           [_photoBtn setImage:[UIImage imageNamed:@"outline_photo_white"] forState:UIControlStateNormal];
           [_photoBtn setImage:[UIImage imageNamed:@"outline_photo_red"] forState:UIControlStateSelected];
            [_photoBtn addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _photoBtn;
}

-(EmotionSelector *)emotionSelector {
    if(!emotionSelector) {
        emotionSelector = [EmotionSelector new];
        emotionSelector.delegate = self;
        [emotionSelector addTextViewObserver:self.textView];
        [emotionSelector setHidden : YES];
        [_container addSubview:emotionSelector];
    }
    return emotionSelector;
}

-(PhotoSelector *)photoSelector {
    if(!photoSelector) {
        photoSelector = [PhotoSelector new];
        photoSelector.delegate = self;
        [photoSelector setHidden:YES];
        [_container addSubview:photoSelector];
    }
    return photoSelector;
}


@end
