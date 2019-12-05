//
//  DYRecommentViewModel.h
//  SVDouYinOC
//
//  Created by HJQ on 2019/11/11.
//  Copyright © 2019 HJQ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DYRecommentViewModel : NSObject


/// 获取推荐数据
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void) getRecommentData: (RequestSuccessBlock) successBlock
             failureBlock: (RequestFailureBlock) failureBlock;

@end

NS_ASSUME_NONNULL_END
