/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

//
//  XMLParser.h
//  Created by Erica Sadun on 4/6/09.
//

#import <CoreFoundation/CoreFoundation.h>

@interface XMLParser : NSObject
{
	NSString			*m_strCurrentElement;  //读到的当前节点的名 
	NSMutableArray		*tabArray;
	NSMutableArray		*moduelArrar;
	NSMutableArray		*hotTabArrar;
	NSMutableDictionary	*urlDictionary;
	NSMutableArray		*videoArray;
	NSMutableArray		*solidArray;
	int					shopId;
	int					siteId;
	NSString			*shopName;
	NSString			*productType;
	BOOL				isShowNavBg;
	BOOL				wechatShare;
	float				red_color;
	float				green_color;
	float				blue_color;
	float				font_red_color;
	float				font_green_color;
	float				font_blue_color;
}

@property(nonatomic,retain) NSString			*m_strCurrentElement; 
@property(nonatomic,retain) NSString			*productType; 
@property(nonatomic,retain) NSMutableArray		*tabArray; 
@property(nonatomic,retain) NSMutableArray		*moduelArrar; 
@property(nonatomic,retain) NSMutableArray		*hotTabArrar; 
@property(nonatomic,retain) NSMutableDictionary *urlDictionary;
@property(nonatomic,retain) NSMutableArray		*videoArray;
@property(nonatomic,retain) NSMutableArray		*solidArray;
@property(nonatomic,retain) NSString			*shopName;
@property(nonatomic) int						shopId;
@property(nonatomic) int						 siteId;
@property(nonatomic) BOOL						 isShowNavBg;
@property(nonatomic) BOOL						 wechatShare;
@property(nonatomic) float						 red_color;
@property(nonatomic) float						 green_color;
@property(nonatomic) float						 blue_color;
@property(nonatomic) float						 font_red_color;
@property(nonatomic) float						 font_green_color;
@property(nonatomic) float						 font_blue_color;

+(XMLParser *) sharedInstance;
- (void *) parseXMLFromURL: (NSURL *) url;
- (void *) parseXMLFromData: (NSData*) data;
- (void *) parserXMLFromFile:(NSString*) xmlFilePath;
- (void) dealloc;
@end

