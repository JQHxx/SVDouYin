//
//Created by ESJsonFormatForMac on 19/11/11.
//

#import "DYRecommentModel.h"
@implementation DYRecommentModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"data" : [DYRecommentData class]};
}


@end

@implementation DYRecommentData

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"cha_list" : [DYRecommentCha_List class]};
}

- (void)setDesc:(NSString *)desc {
    _desc = desc;
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 15) / 2.0;
    CGSize size = [desc multiLineSizeWithAttributeText:width font:[UIFont systemFontOfSize:14]];
    if (size.height == 0) {
        _descHeight = 0;
    } else {
        _descHeight = size.height + 15;
    }

}


@end


@implementation DYRecommentStatus


@end


@implementation DYRecommentAuthor


@end


@implementation DYRecommentAvatar_Thumb


@end


@implementation DYRecommentVideo_Icon


@end


@implementation DYRecommentActivity


@end


@implementation DYRecommentAvatar_Medium


@end


@implementation DYRecommentAvatar_Larger


@end


@implementation DYRecommentShare_Info


@end


@implementation DYRecommentDescendants


@end


@implementation DYRecommentRisk_Infos


@end


@implementation DYRecommentMusic


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end


@implementation DYRecommentCover_Hd


@end


@implementation DYRecommentCover_Large


@end


@implementation DYRecommentPlay_Url


@end


@implementation DYRecommentCover_Medium


@end


@implementation DYRecommentCover_Thumb


@end


@implementation DYRecommentLabel_Top


@end


@implementation DYRecommentStatistics


@end


@implementation DYRecommentVideo

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"bit_rate" : [DYRecommentBit_Rate class]};
}


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end


@implementation DYRecommentDownload_Addr


@end


@implementation DYRecommentDynamic_Cover


@end


@implementation DYRecommentPlay_Addr


@end


@implementation DYRecommentPlay_Addr_Lowbr


@end


@implementation DYRecommentCover


@end


@implementation DYRecommentOrigin_Cover


@end


@implementation DYRecommentBit_Rate


@end


@implementation DYRecommentCha_List


@end


