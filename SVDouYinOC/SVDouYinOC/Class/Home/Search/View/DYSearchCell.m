//
//  DYSearchCell.m
//  SVDouYinOC
//
//  Created by HJQ on 2019/11/15.
//  Copyright © 2019 HJQ. All rights reserved.
//

#import "DYSearchCell.h"

@implementation DYSearchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubViews];
    }
    return self;
}

- (void) initSubViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.deleteButton];

    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView);
        make.top.bottom.mas_equalTo(self.contentView);
        make.width.mas_equalTo(self.deleteButton.mas_height);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_offset(15);
        make.top.bottom.mas_equalTo(self.contentView);
        make.right.lessThanOrEqualTo(self.deleteButton.mas_left);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Event response
- (void) deletedAction {

}

#pragma mark - Setter & Getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"icon_closetopic"] forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deletedAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _deleteButton;
}

@end
