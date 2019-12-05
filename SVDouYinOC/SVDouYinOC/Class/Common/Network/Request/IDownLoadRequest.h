//
//  IDownLoadRequest.h
//  SVDouYinOC
//
//  Created by HJQ on 2019/11/11.
//  Copyright © 2019 HJQ. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IDownLoadRequest : NSObject

@property (nonatomic, copy) NSString *downLoadURL;

@property (nonatomic, copy) NSString *fileType;

@end
