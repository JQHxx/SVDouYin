//
//  NSString+DYCore.h
//  SVDouYinOC
//
//  Created by HJQ on 2019/11/11.
//  Copyright © 2019 HJQ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (DYCore)

- (NSURL *)urlScheme:(NSString *)scheme;

+ (NSString *)formatCount:(NSInteger)count;

- (CGSize)singleLineSizeWithText:(UIFont *)font;

//计算单行文本行高、支持包含emoji表情符的计算。开头空格、自定义插入的文本图片不纳入计算范围
- (CGSize)singleLineSizeWithAttributeText:(UIFont *)font;

//固定宽度计算多行文本高度，支持包含emoji表情符的计算。开头空格、自定义插入的文本图片不纳入计算范围、
- (CGSize)multiLineSizeWithAttributeText:(CGFloat)width font:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
