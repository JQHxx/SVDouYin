//
//  RGRemoteVedioDownLoadHelper.h
//  RedGrass
//
//  Created by wukong on 2019/2/20.
//  Copyright © 2019年 hongcaosp. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DYRemoteVedioDownLoadHelper : NSObject

+(DYRemoteVedioDownLoadHelper *)downLoadhepler;

-(void) downLoadRemoteVedioWithUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
