//
//  DYChatTextView.h
//  SVDouYinOC
//
//  Created by HJQ on 2019/11/16.
//  Copyright © 2019 HJQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// #define EmotionSelectorHeight   220 + BOTTOM_BAR_HEIGHT
// #define PhotoSelectorHeight   220 + BOTTOM_BAR_HEIGHT

typedef NS_ENUM(NSUInteger, DYChatEditMessageType) {
    EditTextMessage        = 0,
    EditPhotoMessage       = 1,
    EditEmotionMessage     = 2,
    EditNoneMessage        = 3,
};

@protocol DYChatTextViewDelegate

@required
-(void)onSendText:(NSString *)text;
-(void)onSendImages:(NSMutableArray<UIImage *> *)images;
-(void)onEditBoardHeightChange:(CGFloat)height;

@end

@interface DYChatTextView : UIView

@property (nonatomic, strong) UIView  *container;
@property (nonatomic, strong) UITextView  *textView;
@property (nonatomic, assign) DYChatEditMessageType   editMessageType;
@property (nonatomic, weak) id<DYChatTextViewDelegate> delegate;

- (void)show;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
