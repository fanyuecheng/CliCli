//
//  CCVideoInfo.h
//  CliCli
//
//  Created by Fancy 
//

#import "CCVideo.h"
#import "CCVideoPlayer.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCVideoInfo : CCVideo

@property (nonatomic, assign) NSInteger type_id_1;
@property (nonatomic, assign) NSInteger group_id;
@property (nonatomic, copy)   NSString *vod_sub;
@property (nonatomic, copy)   NSString *vod_en;
@property (nonatomic, assign) NSInteger vod_status;
@property (nonatomic, copy)   NSString *vod_letter;
@property (nonatomic, copy)   NSString *vod_color;
@property (nonatomic, copy)   NSString *vod_tag;
@property (nonatomic, copy)   NSString *vod_class;
@property (nonatomic, copy)   NSString *vod_pic_thumb;
@property (nonatomic, copy)   NSString *vod_pic_screenshot;
@property (nonatomic, copy)   NSString *vod_actor;
@property (nonatomic, copy)   NSString *vod_director;
@property (nonatomic, copy)   NSString *vod_writer;
@property (nonatomic, copy)   NSString *vod_behind;
@property (nonatomic, copy)   NSString *vod_blurb;
@property (nonatomic, copy)   NSString *vod_pubdate;
@property (nonatomic, assign) NSInteger vod_total;
@property (nonatomic, copy)   NSString *vod_serial;
@property (nonatomic, copy)   NSString *vod_tv;
@property (nonatomic, copy)   NSString *vod_weekday;
@property (nonatomic, copy)   NSString *vod_area;
@property (nonatomic, copy)   NSString *vod_lang;
@property (nonatomic, copy)   NSString *vod_year;
@property (nonatomic, copy)   NSString *vod_version;
@property (nonatomic, copy)   NSString *vod_state;
@property (nonatomic, copy)   NSString *vod_author;
@property (nonatomic, copy)   NSString *vod_jumpurl;
@property (nonatomic, copy)   NSString *vod_tpl;
@property (nonatomic, copy)   NSString *vod_tpl_play;
@property (nonatomic, copy)   NSString *vod_tpl_down;
@property (nonatomic, assign) NSInteger vod_isend;
@property (nonatomic, assign) NSInteger vod_lock;
@property (nonatomic, assign) NSInteger vod_level;
@property (nonatomic, assign) NSInteger vod_copyright;
@property (nonatomic, assign) NSInteger vod_points;
@property (nonatomic, assign) NSInteger vod_points_play;
@property (nonatomic, assign) NSInteger vod_points_down;
@property (nonatomic, assign) NSInteger vod_hits;
@property (nonatomic, assign) NSInteger vod_hits_day;
@property (nonatomic, assign) NSInteger vod_hits_week;
@property (nonatomic, assign) NSInteger vod_hits_month;
@property (nonatomic, assign) NSInteger vod_up;
@property (nonatomic, assign) NSInteger vod_down;
@property (nonatomic, copy)   NSString *vod_duration;
@property (nonatomic, copy)   NSString *vod_score;
@property (nonatomic, assign) NSInteger vod_score_all;
@property (nonatomic, assign) NSInteger vod_score_num;
@property (nonatomic, assign) NSInteger vod_time;
@property (nonatomic, assign) NSInteger vod_time_hits;
@property (nonatomic, assign) NSInteger vod_time_make;
@property (nonatomic, assign) NSInteger vod_trysee;
@property (nonatomic, assign) NSInteger vod_douban_id;
@property (nonatomic, copy)   NSString *vod_douban_score;
@property (nonatomic, copy)   NSString *vod_reurl;
@property (nonatomic, copy)   NSString *vod_rel_vod;
@property (nonatomic, copy)   NSString *vod_rel_art;
@property (nonatomic, copy)   NSString *vod_pwd;
@property (nonatomic, copy)   NSString *vod_pwd_url;
@property (nonatomic, copy)   NSString *vod_pwd_play_url;
@property (nonatomic, copy)   NSString *vod_pwd_down;
@property (nonatomic, copy)   NSString *vod_pwd_down_url;
@property (nonatomic, copy)   NSString *vod_content;
@property (nonatomic, copy)   NSString *vod_play_from;
@property (nonatomic, copy)   NSString *vod_play_server;
@property (nonatomic, copy)   NSString *vod_play_note;
@property (nonatomic, copy)   NSString *vod_play_url;
@property (nonatomic, copy)   NSString *vod_down_from;
@property (nonatomic, copy)   NSString *vod_down_server;
@property (nonatomic, copy)   NSString *vod_down_note;
@property (nonatomic, copy)   NSString *vod_down_url;
@property (nonatomic, copy)   NSString *vod_plot_name;
@property (nonatomic, copy)   NSString *vod_plot_detail;
@property (nonatomic, assign) NSInteger vod_plot;
@property (nonatomic, strong) NSArray <CCVideoPlayer *> *vod_url_with_player;

@end

NS_ASSUME_NONNULL_END
