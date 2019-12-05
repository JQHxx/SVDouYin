//
//  DYSearchToolBar.m
//  SVDouYinOC
//
//  Created by HJQ on 2019/11/11.
//  Copyright © 2019 HJQ. All rights reserved.
//

#import "DYSearchToolBar.h"

@interface DYSearchToolBar() <UISearchBarDelegate>

@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) UIButton *searchBtn;
@property (strong, nonatomic) UIView *bottomLine;

@end

@implementation DYSearchToolBar

- (CGSize)intrinsicContentSize {
    return UILayoutFittingExpandedSize;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initUI];
        [self addMasonry];
    }
    return self;
}

-(void) initUI{
    [self addSubview:self.backBtn];
    [self addSubview:self.searchBtn];
    [self addSubview:self.searchBar];
    [self addSubview:self.bottomLine];
}

-(void) addMasonry{
//    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.mas_equalTo(self).mas_offset(0);
//        make.bottom.mas_equalTo(self).mas_offset(0);
//        make.height.mas_equalTo(0.5);
//    }];
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self).mas_offset(0);
        make.left.mas_equalTo(self).mas_offset(0);
        make.size.mas_equalTo(CGSizeMake(28, 44));
    }];
    [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self).mas_offset(0);
        make.right.mas_equalTo(self).mas_offset(0);
        make.size.mas_equalTo(CGSizeMake(40, 44));
    }];

    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.centerY.mas_equalTo(self).mas_offset(0);
        make.left.mas_equalTo(self.backBtn.mas_right).mas_offset(0);
        make.right.mas_equalTo(self.searchBtn.mas_left).mas_offset(-8);
    }];
}


#pragma mark - public

-(void)becomeFirstReponse{
    [_searchBar becomeFirstResponder];
}


#pragma mark - response

-(void)backBtnClick:(UIButton *)button{
    if(self.backBtnClickBlock){
        self.backBtnClickBlock();
    }
}

-(void)searchBtnClick:(UIButton *)button{
     [self.searchBar resignFirstResponder];
    if(self.searchBtnClickBlock){
        self.searchBtnClickBlock(self.searchBar.text);
//        self.searchBar.text = @"";
    }
}


#pragma mark - seachbar delegate

-(BOOL) searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"]) {
        if(self.searchBtnClickBlock){
            self.searchBtnClickBlock(searchBar.text);
            [searchBar resignFirstResponder];
//            searchBar.text = @"";
        }
        return NO;
    }
    return YES;
}

#pragma mark - getter
-(UIButton *)backBtn{
    if(!_backBtn){
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_backBtn setImage:[UIImage imageNamed:@"home_scan"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

-(UISearchBar *)searchBar{
    if(!_searchBar){
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectZero];
        //_searchBar.placeholder = @"搜索用户、视频名称";
        _searchBar.backgroundImage = [UIImage new];
        _searchBar.delegate = self;
//        _searchBar.layer.masksToBounds = YES;
        //获取textField(也可以通过KVC获取)
        UITextField *searchField;
            if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 13.0) {
                searchField = _searchBar.searchTextField;
            }else{
                UITextField *searchTextField =  [_searchBar valueForKey:@"_searchField"];
                searchField = searchTextField;
            }
        searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索用户、视频名称"attributes:@{NSForegroundColorAttributeName: HEX_COLOR(0xCCCCCC)}];
        //设置placeHolder字体的颜色
        //[searchField setValue:[UIColor colorWithHexString:@"#CCCCCC" alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
        searchField.layer.cornerRadius = 16;
        searchField.textColor = [UIColor whiteColor];
        searchField.font = [UIFont systemFontOfSize:15];
        searchField.layer.masksToBounds = YES;
        searchField.tintColor = HEX_COLOR(0x62a0fe);
        searchField.layer.borderWidth = 0.8;
        searchField.layer.borderColor = [HEX_COLOR(0x333333) CGColor];
        searchField.backgroundColor = HEX_COLOR(0x333333);
    }
    return _searchBar;
}

-(UIButton *)searchBtn{
    if(!_searchBtn){
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_searchBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _searchBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_searchBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

-(UIView *)bottomLine{
    if(!_bottomLine){
        _bottomLine = [[UIView alloc]init];
        _bottomLine.backgroundColor = HEX_COLOR(0x888888);
    }
    return _bottomLine;
}

@end
