//
//  UISearchBar+DYCore.m
//  SVDouYinOC
//
//  Created by HJQ on 2019/11/10.
//  Copyright © 2019 HJQ. All rights reserved.
//

#import "UISearchBar+DYCore.h"


@implementation UISearchBar (DYCore)

- (UITextField *) getSearchTextField {
    if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 13.0) {
        return self.searchTextField;
    } else {
        UITextField *searchTextField =  [self valueForKey:@"_searchField"];
        return searchTextField;
    }
}

@end
