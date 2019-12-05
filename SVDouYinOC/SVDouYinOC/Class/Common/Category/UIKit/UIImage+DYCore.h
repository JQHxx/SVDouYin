//
//  UIImage+DYCore.h
//  SVDouYinOC
//
//  Created by HJQ on 2019/11/11.
//  Copyright © 2019 HJQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (DYCore)

+ (UIImage *) dy_imageNamed: (NSString *) name;

+ (CGSize)getImageSizeWithURL:(id)imageURL;

@end

NS_ASSUME_NONNULL_END
