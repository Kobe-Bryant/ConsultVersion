//
//  Common.h
//  realmStatus
//
//  Created by zhang hao on 11-7-21.
//  Copyright 2011 SEL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#define dataBaseFile @"appstorm.db"
#define CONFIG_FILE_NAME @"config"
#define CONFIG_FILE_TYPE @"xml"
#define goup5String @""
///////////////////////接口id
#define HOT_RECOMMENDED 1
#define PROMOTIONS 2
#define COMPANY_NEWS 3
#define SERVICE 4
#define COMMUNITY 5
#define ABOUTUS 6
#define PRODUCT 7
#define WALLPAPER 8
#define APNS 9
#define SINAWEIAPI 10
#define COMMENTLIST 11
#define PUBLISH_COMMENT 12
#define COMMENTLIST_MORE 13
#define FANSWALL_COMMENTLIST 14
#define FANSWALL_RECENTLY_COMMENTLIST 15
#define MORE_FANSWALL_COMMENTLIST 16
#define COMMENT_REPLY_LIST 17
#define AD_COMMENT 18

#define APP_SOFTWARE_VER_ID 0
#define HOT_RECOMMENDED_ID 1
#define PROMOTIONS_ID 2
#define COMPANY_NEWS_ID 3
#define BUSINESS_ID 4
#define HOTLINE_ID 5
#define BRANCH_ID 6
#define SNS_ID 7
#define ABOUTUS_ID 8
#define PRODUCT_ID 9
#define WALLPAPER_ID 10
#define AD_QY_ID 12
#define AD_PLATFORM_ID 13
#define NEWS_ID 14

#define PI 3.1415926

#define CURRENT_APP_VERSION 3

////////////////////////全局变量
NSOperationQueue	*networkQueue;
UIActivityIndicatorView *commonSpinner;
CLLocationCoordinate2D myLocation;

int currentSelectingIndex;

NSMutableArray		*tabArray;	//底部tab文字
NSMutableArray		*produceModuleArray;//产品模块
NSMutableArray		*hotTabArrar;
NSDictionary		*urlDictionary;
NSMutableArray		*videoListArray;
NSMutableArray		*soildListArray;
NSString			*productShowType;
NSString			*ACCESS_SERVICE_LINK;
NSString			*SHARE_TO_SINA;
NSString			*SHARE_TO_QQ;
NSString			*App_Registration;
NSString			*Feedback;
NSString			*shop_link;
NSString			*SHARE_CONTENT;
NSString			*invite_content;
NSString			*emailSubject;
NSString			*emailContent;
NSString			*weiBoAccount;
int					shop_id;
int					uid;
int					used;
NSString			*shop;
int					site_id;
float				BTO_COLOR_RED;
float				BTO_COLOR_GREEN;
float				BTO_COLOR_BLUE;
float				FONT_COLOR_RED;
float				FONT_COLOR_GREEN;
float			    FONT_COLOR_BLUE;
bool				isPromotionFirstLoad;
bool				isComNewsFirstLoad;
BOOL				isShareToWechat;

enum module_type_id {
	product_module = 1,
	buy_module = 2,
	news_module = 3,
	job_module = 4,
	app_module = 5
};

int	app_wechat_share_type;
enum share_wechat_type {
	app_to_wechat = 1,
	wechat_to_app
};

#define ACCESS_SERVICE_LINK_KEY @"accessLink"
#define SHARE_TO_SINA_KEY @"sinaUrl"
#define SHARE_TO_QQ_KEY @"tencentUrl"
#define App_Registration_KEY @"regLink"
#define Feedback_KEY @"feedback"
#define shop_link_KEY @"shopLink"
#define SHARE_CONTENT_KEY @"share"
#define invite_content_KEY @"invite"
#define emailSubject_KEY @"emailSubject"
#define emailContent_KEY @"emailContent"

//微博接口
#define SINA @"sina"
#define TENCENT @"tencent"
#define SinaAppKey @"956585871"
#define SinaAppSecret @"20a7e950f6fe68ec8e0ddd410067f4e5"
#define QQAppKey @"801106679"
#define QQAppSecret @"14e3e1188d69231e59f6c98d4a9a5527"
#define redirectUrl @"http://our.3g.yunlai.cn/"

#define API_FORMAT @"json"
#define API_DOMAIN	@"api.t.sina.com.cn/"

//微信接口
#define WEICHATID @"wxea924d2d7b95ef88"

////////////////////////全局使用参数
/////////宏编译控制
#define IOS4 1
#define SHOW_NAV_TAB_BG 2
#define NAV_BG_PIC @"上bar.png"
#define TAB_BG_PIC @"下bar.png"
#define IOS7_NAV_BG_PIC @"ios7上bar.png"
#define BG_IMAGE @"背景.png"

#define EMAILMATCHSTRING @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"

#define MAXICONDOWNLOADINGNUM 3 //同时下载图片的数量

#define CUSTOMER_PHOTO 10000 // 下载图片类型

#define NEED_UPDATE 1
#define NO_UPDATE 0
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define COLOR_BAR_COMMENT [UIColor whiteColor]   //上bar右边按钮的字体颜色

 
CLLocationManager *locManager;
@interface Common : NSObject {
}
+(void)testJson;
+(NSString*)TransformJson:(NSMutableDictionary*)sourceDic withLinkStr:(NSString*)strurl;
+(NSString*)encodeBase64:(NSMutableData*)data;
+(NSString*)URLEncodedString:(NSString*)input;
+(NSString*)URLDecodedString:(NSString*)input;
+(NSNumber*)getVersion:(int)commandId;
+(BOOL)connectedToNetwork;
+(double)LantitudeLongitudeDist:(double)lon1 Latitude1:(double)lat1 long2:(double)lon2 Latitude2:(double)lat2;
@end
