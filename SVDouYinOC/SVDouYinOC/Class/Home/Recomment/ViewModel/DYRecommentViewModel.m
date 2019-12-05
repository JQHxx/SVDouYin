//
//  DYRecommentViewModel.m
//  SVDouYinOC
//
//  Created by HJQ on 2019/11/11.
//  Copyright © 2019 HJQ. All rights reserved.
//

#import "DYRecommentViewModel.h"
#import "DYRecommentModel.h"

@implementation DYRecommentViewModel

- (void) getRecommentData: (RequestSuccessBlock) successBlock
failureBlock: (RequestFailureBlock) failureBlock {
    NSDictionary *dict = [DYJsonUtil readJson2DicWithFileName:@"awemes"];
    DYRecommentModel *model = [DYRecommentModel yy_modelWithDictionary:dict];
    if (successBlock) {
        successBlock(model.data);
    }
}

@end
