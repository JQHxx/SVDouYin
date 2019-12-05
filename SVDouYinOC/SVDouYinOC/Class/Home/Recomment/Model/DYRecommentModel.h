//
//Created by ESJsonFormatForMac on 19/11/11.
//

#import <Foundation/Foundation.h>

@class DYRecommentData,DYRecommentStatus,DYRecommentAuthor,DYRecommentAvatar_Thumb,DYRecommentVideo_Icon,DYRecommentActivity,DYRecommentAvatar_Medium,DYRecommentAvatar_Larger,DYRecommentShare_Info,DYRecommentDescendants,DYRecommentRisk_Infos,DYRecommentMusic,DYRecommentCover_Hd,DYRecommentCover_Large,DYRecommentPlay_Url,DYRecommentCover_Medium,DYRecommentCover_Thumb,DYRecommentLabel_Top,DYRecommentStatistics,DYRecommentVideo,DYRecommentDownload_Addr,DYRecommentDynamic_Cover,DYRecommentPlay_Addr,DYRecommentPlay_Addr_Lowbr,DYRecommentCover,DYRecommentOrigin_Cover,DYRecommentBit_Rate,DYRecommentCha_List;
@interface DYRecommentModel : NSObject

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) NSArray *data;

@property (nonatomic, assign) NSInteger total_count;

@property (nonatomic, assign) NSInteger has_more;

@end
@interface DYRecommentData : NSObject

@property (nonatomic, strong) DYRecommentAuthor *author;

@property (nonatomic, strong) DYRecommentMusic *music;

@property (nonatomic, assign) BOOL cmt_swt;

@property (nonatomic, assign) NSInteger is_top;

@property (nonatomic, strong) DYRecommentRisk_Infos *risk_infos;

@property (nonatomic, copy) NSString *region;

@property (nonatomic, assign) NSInteger user_digged;

@property (nonatomic, strong) NSArray *video_text;

@property (nonatomic, strong) NSArray *cha_list;

@property (nonatomic, assign) BOOL is_ads;

@property (nonatomic, assign) NSInteger bodydance_score;

@property (nonatomic, assign) BOOL law_critical_country;

@property (nonatomic, assign) long long author_user_id;

@property (nonatomic, assign) NSInteger create_time;

@property (nonatomic, strong) DYRecommentStatistics *statistics;

@property (nonatomic, copy) NSString *sort_label;

@property (nonatomic, strong) DYRecommentDescendants *descendants;

@property (nonatomic, strong) NSArray *video_labels;

@property (nonatomic, strong) NSArray *geofencing;

@property (nonatomic, assign) BOOL is_relieve;

@property (nonatomic, strong) DYRecommentStatus *status;

@property (nonatomic, assign) NSInteger vr_type;

@property (nonatomic, assign) NSInteger aweme_type;

@property (nonatomic, copy) NSString *aweme_id;

@property (nonatomic, strong) DYRecommentVideo *video;

@property (nonatomic, assign) BOOL is_pgcshow;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, assign) NSInteger is_hash_tag;

@property (nonatomic, strong) DYRecommentShare_Info *share_info;

@property (nonatomic, copy) NSString *share_url;

@property (nonatomic, assign) NSInteger scenario;

@property (nonatomic, strong) DYRecommentLabel_Top *label_top;

@property (nonatomic, assign) NSInteger rate;

@property (nonatomic, assign) BOOL can_play;

@property (nonatomic, assign) BOOL is_vr;

@property (nonatomic, strong) NSArray *text_extra;

// 文本高度
@property (nonatomic, assign) CGFloat descHeight;
@property (nonatomic, assign) BOOL isCalculate;
@property (nonatomic, assign) BOOL imageHeight;

@end

@interface DYRecommentStatus : NSObject

@property (nonatomic, assign) BOOL allow_share;

@property (nonatomic, assign) NSInteger private_status;

@property (nonatomic, assign) BOOL is_delete;

@property (nonatomic, assign) BOOL with_goods;

@property (nonatomic, assign) BOOL is_private;

@property (nonatomic, assign) BOOL with_fusion_goods;

@property (nonatomic, assign) BOOL allow_comment;

@end

@interface DYRecommentAuthor : NSObject

@property (nonatomic, copy) NSString *weibo_name;

@property (nonatomic, copy) NSString *google_account;

@property (nonatomic, assign) NSInteger special_lock;

@property (nonatomic, assign) BOOL is_binded_weibo;

@property (nonatomic, assign) NSInteger shield_follow_notice;

@property (nonatomic, assign) BOOL user_canceled;

@property (nonatomic, strong) DYRecommentAvatar_Larger *avatar_larger;

@property (nonatomic, assign) BOOL accept_private_policy;

@property (nonatomic, assign) NSInteger follow_status;

@property (nonatomic, assign) BOOL with_commerce_entry;

@property (nonatomic, copy) NSString *original_music_qrcode;

@property (nonatomic, assign) NSInteger authority_status;

@property (nonatomic, copy) NSString *youtube_channel_title;

@property (nonatomic, assign) BOOL is_ad_fake;

@property (nonatomic, assign) BOOL prevent_download;

@property (nonatomic, assign) NSInteger verification_type;

@property (nonatomic, assign) BOOL is_gov_media_vip;

@property (nonatomic, copy) NSString *weibo_url;

@property (nonatomic, copy) NSString *twitter_id;

@property (nonatomic, assign) NSInteger need_recommend;

@property (nonatomic, assign) NSInteger comment_setting;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *unique_id;

@property (nonatomic, assign) BOOL hide_location;

@property (nonatomic, copy) NSString *enterprise_verify_reason;

@property (nonatomic, assign) NSInteger aweme_count;

@property (nonatomic, assign) NSInteger story_count;

@property (nonatomic, assign) NSInteger unique_id_modify_time;

@property (nonatomic, assign) NSInteger follower_count;

@property (nonatomic, assign) NSInteger apple_account;

@property (nonatomic, copy) NSString *short_id;

@property (nonatomic, copy) NSString *account_region;

@property (nonatomic, copy) NSString *signature;

@property (nonatomic, copy) NSString *twitter_name;

@property (nonatomic, strong) DYRecommentAvatar_Medium *avatar_medium;

@property (nonatomic, copy) NSString *verify_info;

@property (nonatomic, assign) NSInteger create_time;

@property (nonatomic, assign) BOOL story_open;

@property (nonatomic, copy) NSString *region;

@property (nonatomic, assign) BOOL hide_search;

@property (nonatomic, strong) DYRecommentAvatar_Thumb *avatar_thumb;

@property (nonatomic, copy) NSString *school_poi_id;

@property (nonatomic, assign) NSInteger shield_comment_notice;

@property (nonatomic, assign) NSInteger total_favorited;

@property (nonatomic, strong) DYRecommentVideo_Icon *video_icon;

@property (nonatomic, copy) NSString *original_music_cover;

@property (nonatomic, assign) NSInteger following_count;

@property (nonatomic, assign) NSInteger shield_digg_notice;

@property (nonatomic, copy) NSString *geofencing;

@property (nonatomic, copy) NSString *bind_phone;

@property (nonatomic, assign) BOOL has_email;

@property (nonatomic, assign) NSInteger live_verify;

@property (nonatomic, copy) NSString *birthday;

@property (nonatomic, assign) NSInteger duet_setting;

@property (nonatomic, copy) NSString *ins_id;

@property (nonatomic, assign) NSInteger follower_status;

@property (nonatomic, assign) NSInteger live_agreement;

@property (nonatomic, assign) NSInteger neiguang_shield;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, assign) NSInteger secret;

@property (nonatomic, assign) BOOL is_phone_binded;

@property (nonatomic, assign) NSInteger live_agreement_time;

@property (nonatomic, copy) NSString *weibo_schema;

@property (nonatomic, assign) BOOL is_verified;

@property (nonatomic, copy) NSString *custom_verify;

@property (nonatomic, assign) NSInteger commerce_user_level;

@property (nonatomic, assign) NSInteger gender;

@property (nonatomic, assign) BOOL has_orders;

@property (nonatomic, copy) NSString *youtube_channel_id;

@property (nonatomic, assign) NSInteger reflow_page_gid;

@property (nonatomic, assign) NSInteger reflow_page_uid;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, assign) NSInteger school_type;

@property (nonatomic, copy) NSString *avatar_uri;

@property (nonatomic, copy) NSString *weibo_verify;

@property (nonatomic, assign) NSInteger favoriting_count;

@property (nonatomic, copy) NSString *share_qrcode_uri;

@property (nonatomic, assign) NSInteger room_id;

@property (nonatomic, assign) NSInteger constellation;

@property (nonatomic, copy) NSString *school_name;

@property (nonatomic, strong) DYRecommentActivity *activity;

@property (nonatomic, assign) NSInteger user_rate;

@property (nonatomic, copy) NSString *video_icon_virtual_URI;

@end

@interface DYRecommentAvatar_Thumb : NSObject

@property (nonatomic, copy) NSString *uri;

@property (nonatomic, strong) NSArray *url_list;

@end

@interface DYRecommentVideo_Icon : NSObject

@property (nonatomic, copy) NSString *uri;

@property (nonatomic, copy) NSString *url_list;

@end

@interface DYRecommentActivity : NSObject

@property (nonatomic, assign) NSInteger digg_count;

@property (nonatomic, assign) NSInteger use_music_count;

@end

@interface DYRecommentAvatar_Medium : NSObject

@property (nonatomic, copy) NSString *uri;

@property (nonatomic, strong) NSArray *url_list;

@end

@interface DYRecommentAvatar_Larger : NSObject

@property (nonatomic, copy) NSString *uri;

@property (nonatomic, strong) NSArray *url_list;

@end

@interface DYRecommentShare_Info : NSObject

@property (nonatomic, copy) NSString *share_weibo_desc;

@property (nonatomic, copy) NSString *share_title;

@property (nonatomic, copy) NSString *share_url;

@property (nonatomic, copy) NSString *share_desc;

@end

@interface DYRecommentDescendants : NSObject

@property (nonatomic, copy) NSString *notify_msg;

@property (nonatomic, strong) NSArray *platforms;

@end

@interface DYRecommentRisk_Infos : NSObject

@property (nonatomic, assign) BOOL warn;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) BOOL risk_sink;

@property (nonatomic, assign) NSInteger type;

@end

@interface DYRecommentMusic : NSObject

@property (nonatomic, strong) DYRecommentCover_Hd *cover_hd;

@property (nonatomic, strong) DYRecommentCover_Large *cover_large;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *extra;

@property (nonatomic, assign) NSInteger user_count;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger duration;

@property (nonatomic, strong) DYRecommentPlay_Url *play_url;

@property (nonatomic, copy) NSString *mid;

@property (nonatomic, assign) BOOL is_restricted;

@property (nonatomic, copy) NSString *offline_desc;

@property (nonatomic, copy) NSString *schema_url;

@property (nonatomic, strong) DYRecommentCover_Medium *cover_medium;

@property (nonatomic, assign) BOOL is_original;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, strong) DYRecommentCover_Thumb *cover_thumb;

@property (nonatomic, assign) NSInteger source_platform;

@property (nonatomic, copy) NSString *author;

@property (nonatomic, copy) NSString *id_str;

@end

@interface DYRecommentCover_Hd : NSObject

@property (nonatomic, copy) NSString *uri;

@property (nonatomic, strong) NSArray *url_list;

@end

@interface DYRecommentCover_Large : NSObject

@property (nonatomic, copy) NSString *uri;

@property (nonatomic, strong) NSArray *url_list;

@end

@interface DYRecommentPlay_Url : NSObject

@property (nonatomic, copy) NSString *uri;

@property (nonatomic, strong) NSArray *url_list;

@end

@interface DYRecommentCover_Medium : NSObject

@property (nonatomic, copy) NSString *uri;

@property (nonatomic, strong) NSArray *url_list;

@end

@interface DYRecommentCover_Thumb : NSObject

@property (nonatomic, copy) NSString *uri;

@property (nonatomic, strong) NSArray *url_list;

@end

@interface DYRecommentLabel_Top : NSObject

@property (nonatomic, copy) NSString *uri;

@property (nonatomic, strong) NSArray *url_list;

@end

@interface DYRecommentStatistics : NSObject

@property (nonatomic, assign) NSInteger digg_count;

@property (nonatomic, copy) NSString *aweme_id;

@property (nonatomic, assign) NSInteger share_count;

@property (nonatomic, assign) NSInteger play_count;

@property (nonatomic, assign) NSInteger comment_count;

@end

@interface DYRecommentVideo : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, strong) DYRecommentDynamic_Cover *dynamic_cover;

@property (nonatomic, strong) DYRecommentPlay_Addr_Lowbr *play_addr_lowbr;

@property (nonatomic, assign) NSInteger width;

@property (nonatomic, copy) NSString *ratio;

@property (nonatomic, strong) DYRecommentPlay_Addr *play_addr;

@property (nonatomic, strong) DYRecommentCover *cover;

@property (nonatomic, assign) NSInteger height;

@property (nonatomic, strong) NSArray *bit_rate;

@property (nonatomic, strong) DYRecommentOrigin_Cover *origin_cover;

@property (nonatomic, assign) NSInteger duration;

@property (nonatomic, strong) DYRecommentDownload_Addr *download_addr;

@property (nonatomic, assign) BOOL has_watermark;

@end

@interface DYRecommentDownload_Addr : NSObject

@property (nonatomic, copy) NSString *uri;

@property (nonatomic, strong) NSArray *url_list;

@end

@interface DYRecommentDynamic_Cover : NSObject

@property (nonatomic, copy) NSString *uri;

@property (nonatomic, strong) NSArray *url_list;

@end

@interface DYRecommentPlay_Addr : NSObject

@property (nonatomic, copy) NSString *uri;

@property (nonatomic, strong) NSArray *url_list;

@end

@interface DYRecommentPlay_Addr_Lowbr : NSObject

@property (nonatomic, copy) NSString *uri;

@property (nonatomic, strong) NSArray *url_list;

@end

@interface DYRecommentCover : NSObject

@property (nonatomic, copy) NSString *uri;

@property (nonatomic, strong) NSArray *url_list;

@end

@interface DYRecommentOrigin_Cover : NSObject

@property (nonatomic, copy) NSString *uri;

@property (nonatomic, strong) NSArray *url_list;

@end

@interface DYRecommentBit_Rate : NSObject

@property (nonatomic, assign) NSInteger bit_rate;

@property (nonatomic, copy) NSString *gear_name;

@property (nonatomic, assign) NSInteger quality_type;

@end

@interface DYRecommentCha_List : NSObject

@property (nonatomic, copy) NSString *schema;

@property (nonatomic, assign) NSInteger user_count;

@property (nonatomic, assign) NSInteger sub_type;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, assign) BOOL is_pgcshow;

@property (nonatomic, copy) NSString *cha_name;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *cid;

@end

