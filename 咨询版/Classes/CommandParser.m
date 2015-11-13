//
//  parserCommand.m
//  AppStrom
//
//  Created by 掌商 on 11-9-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CommandParser.h"
#import "SBJson.h"
#import "HotRecommended.h"
#import "Promotions.h"
#import "CompanyNews.h"
#import "serviceBranch.h"
#import "serviceHotLine.h"
#import "sns.h"
#import "aboutUsBody.h"
#import "aboutUsBranch.h"
#import "cats.h"
#import "product.h"
#import "productPic.h"
#import "wallpaper.h"
#import "businessPhone.h"
#import "DBOperate.h"
#import "Common.h"
@implementation CommandParser

+(bool)updateVersion:(int)commanId versionID:(NSNumber*)versionid desc:(NSString*)describe{
	if (versionid==nil) {
		return NO;
	}
	NSArray *ar_ver = [NSArray arrayWithObjects:[NSNumber numberWithInt:commanId],versionid,describe,nil];
	[DBOperate deleteData:T_VERSION tableColumn:@"id" columnValue:[NSNumber numberWithInt:commanId]];
	[DBOperate insertDataWithnotAutoID:ar_ver tableName:T_VERSION];
	return YES;
}


+(NSMutableArray*)parseHotRecommended:(NSString*)jsonResult getVersion:(int*)ver
{
	NSDictionary *dic = [jsonResult JSONValue];
	
	NSArray *infoArray = [dic objectForKey:@"infos"];
	NSArray *commentCountArray = [dic objectForKey:@"comments"];
	for (NSDictionary *infoDic in infoArray){
		if ([[infoDic objectForKey:@"status"]boolValue]) {
			NSMutableArray *ar_hot = [[NSMutableArray alloc]init];
			[ar_hot addObject:[infoDic objectForKey:@"id"]];
			[ar_hot addObject:[infoDic objectForKey:@"type"]];
			[ar_hot addObject:[infoDic objectForKey:@"title"]];
			[ar_hot addObject:[infoDic objectForKey:@"desc"]];
			[ar_hot addObject:[infoDic objectForKey:@"pic"]];
			[ar_hot addObject:@""];
			[ar_hot addObject:@""];
			[ar_hot addObject:[infoDic objectForKey:@"url"]];
			[ar_hot addObject:@"0"];
			bool flag = [[infoDic objectForKey:@"isIphoneHot"]boolValue];
			if(flag){
				[ar_hot addObject:@"1"];
			}else {
				[ar_hot addObject:@"0"];
			}
			[ar_hot addObject:[infoDic objectForKey:@"created"]];
			[ar_hot addObject:[infoDic objectForKey:@"counts"]];
			//[DBOperate insertData:ar_hot tableName:T_HOT];
			[DBOperate deleteData:T_HOT tableColumn:@"id" columnValue:[infoDic objectForKey:@"id"]];
			[DBOperate insertDataWithnotAutoID:ar_hot tableName:T_HOT];

			[ar_hot release];
		}
		else {
			[DBOperate deleteData:T_HOT tableColumn:@"id" columnValue:[infoDic objectForKey:@"id"]];
		}
		
	}
	for (NSDictionary *commentCountDic in commentCountArray ) {
		[DBOperate updateData:T_HOT tableColumn:@"commentCounts" columnValue:[commentCountDic objectForKey:@"counts"]
			  conditionColumn1:@"id" conditionColumnValue1:[commentCountDic objectForKey:@"id"]
		      conditionColumn2:@"type" conditionColumnValue2:[commentCountDic objectForKey:@"type"]];
	}
	[self updateVersion:HOT_RECOMMENDED_ID versionID:[dic objectForKey:@"ver"] desc:@""];

	return nil;
	
}


+(NSMutableArray*)parsePromotions:(NSString*)jsonResult getVersion:(int*)ver{
	NSDictionary *dic = [jsonResult JSONValue];
	NSArray *infoArray = [dic objectForKey:@"infos"];
	NSArray *commentCountArray = [dic objectForKey:@"comments"];
	for (NSDictionary *infoDic in infoArray){
		if ([[infoDic objectForKey:@"status"]boolValue]) {
			NSMutableArray *ar_promotion = [[NSMutableArray alloc]init];
			[ar_promotion addObject:[infoDic objectForKey:@"id"]];
			[ar_promotion addObject:[infoDic objectForKey:@"type"]];
			[ar_promotion addObject:[infoDic objectForKey:@"title"]];
			[ar_promotion addObject:[infoDic objectForKey:@"desc"]];
			[ar_promotion addObject:[infoDic objectForKey:@"pic"]];
			[ar_promotion addObject:@""];
			[ar_promotion addObject:@""];
			[ar_promotion addObject:[infoDic objectForKey:@"url"]];
			[ar_promotion addObject:@"0"];
			bool flag = [[infoDic objectForKey:@"isIphoneHot"]boolValue];
			if(flag){
				[ar_promotion addObject:@"1"];
			}else {
				[ar_promotion addObject:@"0"];
			}
			[ar_promotion addObject:[infoDic objectForKey:@"created"]];
			[ar_promotion addObject:[infoDic objectForKey:@"counts"]];
			//[DBOperate insertData:ar_promotion tableName:T_PROMOTIONS];
			[DBOperate deleteData:T_PROMOTIONS tableColumn:@"id" columnValue:[infoDic objectForKey:@"id"]];
			[DBOperate insertDataWithnotAutoID:ar_promotion tableName:T_PROMOTIONS];
			[ar_promotion release];
		}
		else {
			[DBOperate deleteData:T_PROMOTIONS tableColumn:@"id" columnValue:[infoDic objectForKey:@"id"]];
		}

	}
	for (NSDictionary *commentCountDic in commentCountArray ) {
		[DBOperate updateData:T_PROMOTIONS tableColumn:@"commentCounts" columnValue:[commentCountDic objectForKey:@"counts"]
			 conditionColumn1:@"id" conditionColumnValue1:[commentCountDic objectForKey:@"id"]
			 conditionColumn2:@"type" conditionColumnValue2:[commentCountDic objectForKey:@"type"]];
	}
	[self updateVersion:PROMOTIONS_ID versionID:[dic objectForKey:@"ver"] desc:@""];
	return nil;
}

+(NSMutableArray*)parseCompanyNews:(NSString*)jsonResult getVersion:(int*)ver{
	NSDictionary *dic = [jsonResult JSONValue];
	NSArray *infoArray = [dic objectForKey:@"infos"];
	NSArray *commentCountArray = [dic objectForKey:@"comments"];
	//NSMutableArray *resultArray = [[NSMutableArray alloc]init];
	for (NSDictionary *infoDic in infoArray){
		if ([[infoDic objectForKey:@"status"]boolValue]) {
			NSMutableArray *ar_companynews = [[NSMutableArray alloc]init];
			[ar_companynews addObject:[infoDic objectForKey:@"id"]];
			[ar_companynews addObject:[infoDic objectForKey:@"type"]];
			[ar_companynews addObject:[infoDic objectForKey:@"title"]];
			[ar_companynews addObject:[infoDic objectForKey:@"desc"]];
			[ar_companynews addObject:[infoDic objectForKey:@"pic"]];
			[ar_companynews addObject:@""];
			[ar_companynews addObject:@""];
			[ar_companynews addObject:[infoDic objectForKey:@"url"]];
			[ar_companynews addObject : @"0"];
			bool flag = [[infoDic objectForKey:@"isIphoneHot"]boolValue];
			if(flag){
				[ar_companynews addObject:@"1"];
			}else {
				[ar_companynews addObject:@"0"];
			}
			[ar_companynews addObject:[infoDic objectForKey:@"created"]];
			[ar_companynews addObject:[infoDic objectForKey:@"counts"]];
			[DBOperate deleteData:T_COMPANYNEWS tableColumn:@"id" columnValue:[infoDic objectForKey:@"id"]];
			[DBOperate insertDataWithnotAutoID:ar_companynews tableName:T_COMPANYNEWS];
			[ar_companynews release];
		}
		else {
			[DBOperate deleteData:T_COMPANYNEWS tableColumn:@"id" columnValue:[infoDic objectForKey:@"id"]];
		}
	}
	for (NSDictionary *commentCountDic in commentCountArray ) {
		[DBOperate updateData:T_COMPANYNEWS tableColumn:@"commentCounts" columnValue:[commentCountDic objectForKey:@"counts"]
			 conditionColumn1:@"id" conditionColumnValue1:[commentCountDic objectForKey:@"id"]
			 conditionColumn2:@"type" conditionColumnValue2:[commentCountDic objectForKey:@"type"]];
	}
	[self updateVersion:COMPANY_NEWS_ID versionID:[dic objectForKey:@"ver"] desc:@""];
	return nil;
	
}

+(NSMutableArray*)parseService:(NSString*)jsonResult getVersion:(int*)ver{
	NSDictionary *dic = [jsonResult JSONValue];
	*ver = NO_UPDATE;
	NSDictionary *businessDic = [dic objectForKey:@"business-phone"];
	if ([businessDic objectForKey:@"status"]!=nil) {
		*ver = NEED_UPDATE;
		if ([[businessDic objectForKey:@"status"]boolValue]) {
			
			[DBOperate deleteALLData:T_BUSINESS];
			NSMutableArray *ar_business = [[NSMutableArray alloc]init];
			[ar_business addObject:[businessDic objectForKey:@"tel"]];
			[DBOperate insertData:ar_business tableName:T_BUSINESS];
			//[DBOperate insertDataWithnotAutoID:ar_business tableName:T_BUSINESS];
			[ar_business release];
			[self updateVersion:BUSINESS_ID versionID:[businessDic objectForKey:@"ver"] desc:@""];
		}
		
	}
	
	NSDictionary *hotline = [dic objectForKey:@"hotline"];

	if ([hotline objectForKey:@"status"]!=nil) {
		*ver = NEED_UPDATE;
    	if ([[hotline objectForKey:@"status"]boolValue]) {
    		[DBOperate deleteALLData:T_HOTLINE];
    		NSMutableArray *ar_hotline = [[NSMutableArray alloc]init];
    		[ar_hotline addObject:[hotline objectForKey:@"tel"]];
    		[ar_hotline addObject:[hotline objectForKey:@"mail"]];
    		[ar_hotline addObject:[hotline objectForKey:@"desc"]];
    		[ar_hotline addObject:[hotline objectForKey:@"title"]];
			[DBOperate deleteALLData:T_HOTLINE];
    		[DBOperate insertData:ar_hotline tableName:T_HOTLINE];
    		[ar_hotline release];
		
    	}
    	else {
      		[DBOperate deleteALLData:T_HOTLINE];
    	}
	}
	[self updateVersion:HOTLINE_ID versionID:[hotline objectForKey:@"ver"] desc:@""];

	NSDictionary *branchDic = [dic objectForKey:@"branchs"];
	NSArray *infoArray = [branchDic objectForKey:@"branchs"];
	for (NSDictionary *infoDic in infoArray){
		*ver = NEED_UPDATE;
		if ([infoDic objectForKey:@"status"]!=nil) {
			if ([[infoDic objectForKey:@"status"]boolValue]) {
				NSMutableArray *ar_branch = [[NSMutableArray alloc]init];
				[ar_branch addObject:[infoDic objectForKey:@"id"]];
				[ar_branch addObject:[infoDic objectForKey:@"name"]];
				[ar_branch addObject:[infoDic objectForKey:@"tel"]];
				[ar_branch addObject:[infoDic objectForKey:@"mobile"]];
				[ar_branch addObject:[infoDic objectForKey:@"fax"]];
				[ar_branch addObject:[infoDic objectForKey:@"mail"]];
				[ar_branch addObject:[infoDic objectForKey:@"companyname"]];
				[ar_branch addObject:[infoDic objectForKey:@"addr"]];
				[ar_branch addObject:[infoDic objectForKey:@"location"]];
				[ar_branch addObject:[infoDic objectForKey:@"showmail"]];
				[ar_branch addObject:[infoDic objectForKey:@"showfax"]];
				[ar_branch addObject:[infoDic objectForKey:@"showtel"]];
				[ar_branch addObject:[infoDic objectForKey:@"showmobile"]];
				[ar_branch addObject:[infoDic objectForKey:@"showname"]];
				[ar_branch addObject:[infoDic objectForKey:@"showlocation"]];
				[ar_branch addObject:[infoDic objectForKey:@"showaddr"]];
				[ar_branch addObject:[infoDic objectForKey:@"showcompanyname"]];
				[DBOperate deleteData:T_SUBBRANCH tableColumn:@"id" columnValue:[infoDic objectForKey:@"id"]];
				[DBOperate insertDataWithnotAutoID:ar_branch tableName:T_SUBBRANCH];

				NSLog(@"arbranch %@",ar_branch);
				//[DBOperate insertData:ar_branch tableName:T_SUBBRANCH];
				[ar_branch release];
				
			}
			else {
				[DBOperate deleteData:T_SUBBRANCH tableColumn:@"id" columnValue:[infoDic objectForKey:@"id"]];
			}

			
		}
	}
	[self updateVersion:BRANCH_ID versionID:[branchDic objectForKey:@"ver"] desc:@""];	

	return nil;
}

+(NSMutableArray*)parseSNS:(NSString*)jsonResult getVersion:(int*)ver{
	NSDictionary *dic = [jsonResult JSONValue];
	*ver = NO_UPDATE;

	NSArray *infoArray = [dic objectForKey:@"links"];
	for (NSDictionary *infoDic in infoArray){
		*ver = NEED_UPDATE;
		if ([[infoDic objectForKey:@"status"]boolValue]) {
		NSMutableArray *ar_community = [[NSMutableArray alloc]init];
		[ar_community addObject:[infoDic objectForKey:@"id"]];
		[ar_community addObject:[infoDic objectForKey:@"name"]];
		[ar_community addObject:[infoDic objectForKey:@"desc"]];
		[ar_community addObject:[infoDic objectForKey:@"url"]];
		[ar_community addObject:[infoDic objectForKey:@"pic"]];
		[ar_community addObject:@""];
		[ar_community addObject:@""];
		[DBOperate deleteData:T_COMMUNITY tableColumn:@"id" columnValue:[infoDic objectForKey:@"id"]];
		[DBOperate insertDataWithnotAutoID:ar_community tableName:T_COMMUNITY];
		[ar_community release];
		}
		else {
			[DBOperate deleteData:T_COMMUNITY tableColumn:@"id" columnValue:[infoDic objectForKey:@"id"]];
		}

	}
	[self updateVersion:SNS_ID versionID:[dic objectForKey:@"ver"] desc:@""];
	return nil;
}

+(NSMutableArray*)parseAboutus:(NSString*)jsonResult getVersion:(int*)ver{

	NSDictionary *dic = [jsonResult JSONValue];
	NSDictionary *bodyDic = [dic objectForKey:@"body"];
	
	*ver = NO_UPDATE;
	if ([bodyDic objectForKey:@"status"]!=nil) {
		*ver = NEED_UPDATE;
    	if ([[bodyDic objectForKey:@"status"]boolValue]) {
			NSMutableArray *ar_about = [[NSMutableArray alloc]init];
    		[ar_about addObject:[bodyDic objectForKey:@"id"]];
    		[ar_about addObject:[bodyDic objectForKey:@"content"]];
    		[ar_about addObject:[bodyDic objectForKey:@"logo"]];
    		[ar_about addObject:@""];
    		[ar_about addObject:@""];
			//[DBOperate deleteData:T_ABOUT tableColumn:@"id" columnValue:[bodyDic objectForKey:@"id"]];
			[DBOperate deleteALLData:T_ABOUT];
    		[DBOperate insertDataWithnotAutoID:ar_about tableName:T_ABOUT];
	    	[ar_about release];
			[self updateVersion:ABOUTUS_ID versionID:[bodyDic objectForKey:@"ver"] desc:@""];

		
    	}
	else {
		[DBOperate deleteALLData:T_ABOUT];
		//[DBOperate deleteData:T_ABOUT tableColumn:@"id" columnValue:[bodyDic objectForKey:@"id"]];
    	}		
	}


	NSDictionary *branchDic = [dic objectForKey:@"branchs"];
	//*ver = [[branchDic objectForKey:@"ver"]intValue];

	NSArray *infoArray = [branchDic objectForKey:@"branchs"];
	for (NSDictionary *infoDic in infoArray){
		if ([[infoDic objectForKey:@"status"]boolValue]) {
			NSMutableArray *ar_branch = [[NSMutableArray alloc]init];
			[ar_branch addObject:[infoDic objectForKey:@"id"]];
			[ar_branch addObject:[infoDic objectForKey:@"name"]];
			[ar_branch addObject:[infoDic objectForKey:@"tel"]];
			[ar_branch addObject:[infoDic objectForKey:@"mobile"]];
			[ar_branch addObject:[infoDic objectForKey:@"fax"]];
			[ar_branch addObject:[infoDic objectForKey:@"mail"]];
			[ar_branch addObject:[infoDic objectForKey:@"companyname"]];
			[ar_branch addObject:[infoDic objectForKey:@"addr"]];
			[ar_branch addObject:[infoDic objectForKey:@"location"]];
			[ar_branch addObject:[infoDic objectForKey:@"showmail"]];
			[ar_branch addObject:[infoDic objectForKey:@"showfax"]];
			[ar_branch addObject:[infoDic objectForKey:@"showtel"]];
			[ar_branch addObject:[infoDic objectForKey:@"showmobile"]];
			[ar_branch addObject:[infoDic objectForKey:@"showname"]];
			[ar_branch addObject:[infoDic objectForKey:@"showlocation"]];
			[ar_branch addObject:[infoDic objectForKey:@"showaddr"]];
			[ar_branch addObject:[infoDic objectForKey:@"showcompanyname"]];
			[DBOperate deleteData:T_SUBBRANCH tableColumn:@"id" columnValue:[infoDic objectForKey:@"id"]];
			[DBOperate insertDataWithnotAutoID:ar_branch tableName:T_SUBBRANCH];

			//[DBOperate insertData:ar_branch tableName:T_SUBBRANCH];
			[ar_branch release];
		}
		else {
			[DBOperate deleteData:T_SUBBRANCH tableColumn:@"id" columnValue:[infoDic objectForKey:@"id"]];
		}
	}
	[self updateVersion:BRANCH_ID versionID:[branchDic objectForKey:@"ver"] desc:@""];

	return nil;
}





+(NSDictionary*)parseProducts:(NSString*)jsonResult getVersion:(int*)ver{
	NSDictionary *dic = [jsonResult JSONValue];
	*ver = NO_UPDATE;
	NSArray *catsArray = [dic objectForKey:@"cats"];
	NSArray *productArray = [dic objectForKey:@"products"];
	for (NSDictionary *catsDic in catsArray) {
		*ver = NEED_UPDATE;
		if ([[catsDic objectForKey:@"status"]boolValue]) {
		NSMutableArray *ar_cat = [[NSMutableArray alloc]init];
		[ar_cat addObject:[catsDic objectForKey:@"id"]];
		[ar_cat addObject:[catsDic objectForKey:@"pid"]];
		[ar_cat addObject:[catsDic objectForKey:@"sortid"]];
		[ar_cat addObject:[catsDic objectForKey:@"name"]];
		[ar_cat addObject:[catsDic objectForKey:@"time"]];
		[ar_cat addObject:[catsDic objectForKey:@"pic"]];
		[ar_cat addObject:@""];
		[ar_cat addObject:@""];
		[ar_cat addObject:[catsDic objectForKey:@"product-id"]];//[ar_cat addObject:@" "];//
		[DBOperate deleteData:T_CATEGORY_PRETTY_PIC tableColumn:@"id" columnValue:[catsDic objectForKey:@"id"]];
		[DBOperate insertDataWithnotAutoID:ar_cat tableName:T_CATEGORY_PRETTY_PIC];
        //[DBOperate insertData:ar_cat tableName:T_CATEGORY_PRETTY_PIC];
		[ar_cat release];
		}
		else {
			[DBOperate deleteData:T_CATEGORY_PRETTY_PIC tableColumn:@"id" columnValue:[catsDic objectForKey:@"id"]];
		}

	}
	for (NSDictionary *productDic in productArray) {
		if ([[productDic objectForKey:@"status"]boolValue]) {
			NSMutableArray *ar_prod = [[NSMutableArray alloc]init];
			[ar_prod addObject:[productDic objectForKey:@"id"]];
			[ar_prod addObject:[productDic objectForKey:@"catid"]];
			[ar_prod addObject:[productDic objectForKey:@"name"]];
			[ar_prod addObject:[productDic objectForKey:@"desc"]];
			//[ar_prod addObject:[productDic objectForKey:@"time"]];
			[ar_prod addObject:[productDic objectForKey:@"url"]];
			
			[ar_prod addObject:[productDic objectForKey:@"pic"]];
			[ar_prod addObject:@""];
			[ar_prod addObject:@""];
			[ar_prod addObject:[productDic objectForKey:@"created"]];
			[DBOperate deleteData:T_PIC tableColumn:@"pid" columnValue:[productDic objectForKey:@"id"]];

			NSArray *picArray = [productDic objectForKey:@"pics"];
			for (NSDictionary *picDic in picArray) {
				NSMutableArray *ar_pic = [[NSMutableArray alloc]init];
				[ar_pic addObject:[productDic objectForKey:@"id"]];
				[ar_pic addObject:[picDic objectForKey:@"pic1"]];
				[ar_pic addObject:@""];
				[ar_pic addObject:@""];
				[ar_pic addObject:[picDic objectForKey:@"pic2"]];
				[ar_pic addObject:@""];
				[ar_pic addObject:@""];
				[ar_pic addObject:[picDic objectForKey:@"desc"]];
								
				[DBOperate insertData:ar_pic tableName:T_PIC];
				[ar_pic release];
			}
			[DBOperate deleteData:T_PRODUCT_PRETTY_PIC tableColumn:@"id" columnValue:[productDic objectForKey:@"id"]];
			[DBOperate insertDataWithnotAutoID:ar_prod tableName:T_PRODUCT_PRETTY_PIC];
			[ar_prod release];
		}
		else {
			[DBOperate deleteData:T_PIC tableColumn:@"pid" columnValue:[productDic objectForKey:@"id"]];
			[DBOperate deleteData:T_PRODUCT_PRETTY_PIC tableColumn:@"id" columnValue:[productDic objectForKey:@"id"]];
		}

	}
	[self updateVersion:PRODUCT_ID versionID:[dic objectForKey:@"ver"] desc:@""];

		return nil;
}

+(NSMutableArray*)parseWallPaper:(NSString*)jsonResult getVersion:(int*)ver
{
	NSDictionary *dic = [jsonResult JSONValue];
	NSArray *picsArray = [dic objectForKey:@"pics"];
	for (NSDictionary *picDic in picsArray){
		if ([[picDic objectForKey:@"status"]boolValue]) {
			NSMutableArray *ar_wp = [[NSMutableArray alloc]init];
			[ar_wp addObject:[picDic objectForKey:@"id"]];
			[ar_wp addObject:[picDic objectForKey:@"title"]];
			[ar_wp addObject:[picDic objectForKey:@"desc"]];
			[ar_wp addObject:[picDic objectForKey:@"pic"]];
			[ar_wp addObject:@""];
			[ar_wp addObject:[picDic objectForKey:@"pic2"]];
			[ar_wp addObject:@""];
			[ar_wp addObject:@""];
			[ar_wp addObject:@""];
			[DBOperate deleteData:T_WALLPAPER tableColumn:@"id" columnValue:[picDic objectForKey:@"id"]];
			[DBOperate insertDataWithnotAutoID:ar_wp tableName:T_WALLPAPER];
			[ar_wp release];
		}
		else{
			[DBOperate deleteData:T_WALLPAPER tableColumn:@"id" columnValue:[picDic objectForKey:@"id"]];
		}
	}
	[self updateVersion:WALLPAPER_ID versionID:[dic objectForKey:@"ver"] desc:@""];
	return nil;
}
+(NSMutableArray*)parseApns:(NSString*)jsonResult getVersion:(int*)ver{
	NSDictionary *dic = [jsonResult JSONValue];
	int issuccess = [[dic objectForKey:@"isSuccess"]intValue];
	if (issuccess == 1) {
		
		//更当前账号的状态
		uid = [dic objectForKey:@"uid"];
		used = [dic objectForKey:@"used"];
		
		[DBOperate updateData:T_WEIBO_USERINFO 
				  tableColumn:@"status" columnValue:used conditionColumn:@"uid" conditionColumnValue:uid];
		NSDictionary *appVerDic = [dic objectForKey:@"autopromotion"];		
		NSDictionary *appVerGradeDic = [dic objectForKey:@"grade"];
		
		if (appVerDic != [NSNull null]) {			
			[[appVerDic objectForKey:@"ver_soft"] intValue];
			[appVerDic objectForKey:@"url"];
			[DBOperate deleteData:T_APP_INFO tableColumn:@"type" columnValue:[NSNumber numberWithInt:0]];
			
			NSMutableArray *array = [[NSMutableArray alloc] init];
			[array addObject:[NSNumber numberWithInt:0]];
			[array addObject:[appVerDic objectForKey:@"ver_soft"]];
			[array addObject:[appVerDic objectForKey:@"url"]];
			[array addObject:[NSNumber numberWithInt:0]];
			[DBOperate insertDataWithnotAutoID:array tableName:T_APP_INFO];
			[array release];
		}
		if (appVerGradeDic != [NSNull null]) {			
			[[appVerGradeDic objectForKey:@"ver_grade"] intValue];
			[appVerGradeDic objectForKey:@"url"];
			
			[DBOperate deleteData:T_APP_INFO tableColumn:@"type" columnValue:[NSNumber numberWithInt:1]];
			
			NSMutableArray *array = [[NSMutableArray alloc] init];
			[array addObject:[NSNumber numberWithInt:1]];
			[array addObject:[appVerGradeDic objectForKey:@"ver_grade"]];
			[array addObject:[appVerGradeDic objectForKey:@"url"]];
			[array addObject:[NSNumber numberWithInt:0]];
			[DBOperate insertDataWithnotAutoID:array tableName:T_APP_INFO];
		}
	}

}
+(NSMutableArray*)parseSinaUserInfo:(NSString*)jsonResult  weiboUserID:(NSNumber*)weiboUserID{
	NSDictionary *dic = [jsonResult JSONValue];
	
	int issuccess = [[dic objectForKey:@"ret"]intValue];
	
	int userid = [[dic objectForKey:@"uid"]intValue];
	
	int use = [[dic objectForKey:@"used"]intValue];
	
	//update 微博用户表，更新uid
	[DBOperate updateData:T_WEIBO_USERINFO tableColumn:@"uid" columnValue:[NSNumber numberWithInt: userid] conditionColumn:@"uid" conditionColumnValue:weiboUserID];
	
	//update 微博用户表，更新status
	[DBOperate updateData:T_WEIBO_USERINFO tableColumn:@"status" columnValue:[NSNumber numberWithInt: use] conditionColumn:@"uid" conditionColumnValue:[NSNumber numberWithInt: userid]];
	
	return nil;
}

+(NSMutableArray*)parseCommentList:(NSString*)jsonResult getVersion:(int*)ver moduleTypeId:(NSNumber*)module_type_id moduleId:(NSNumber*)module_id
{
	//*ver = NO_UPDATE;
	
	NSDictionary *dic = [jsonResult JSONValue];
	//屏蔽的id
	NSArray *publishedArray = [dic objectForKey:@"published"];
	//需要更新回复数的id
	NSArray *replyArray = [dic objectForKey:@"reply"];
	//版本号 
	*ver = [[dic objectForKey:@"ver"] intValue];
	
	//update评论表评论数
	
	if (replyArray != nil && [replyArray count] > 0)
	{
		for(NSDictionary *replyDic in replyArray)
		{
			NSNumber *replyID = [NSNumber numberWithInteger:[[replyDic objectForKey:@"id"] intValue]];
			NSString *replyCount = [NSString stringWithFormat: @"%d", [[replyDic objectForKey:@"counts"] intValue]];
			[DBOperate updateData:T_COMMENT_LIST
					  tableColumn:@"replyCount" 
					  columnValue:replyCount 
				  conditionColumn:@"id" 
			 conditionColumnValue:replyID];
		}
	}
	
	//删除被屏蔽的数据
	if (publishedArray != nil && [publishedArray count] > 0)
	{
		for(NSDictionary *publishedDic in publishedArray)
		{
			NSNumber *publishedID = [NSNumber numberWithInteger:[[publishedDic objectForKey:@"id"] intValue]];
			[DBOperate deleteData:T_COMMENT_LIST 
					  tableColumn:@"id" 
					  columnValue:publishedID];
		}
	}
	
	
	//从数据库取出该信息所有数据
	NSMutableArray *CommentItems = [DBOperate queryData:T_COMMENT_LIST theColumn:@"module_type_id" equalValue1:module_type_id theColumn:@"module_id" equalValue:module_id];
	
	//删除该信息所有数据
	[DBOperate deleteDataWithTwoConditions:T_COMMENT_LIST 
								 columnOne:@"module_type_id" 
								  valueOne:[NSString stringWithFormat: @"%@",module_type_id] 
								 columnTwo:@"module_id"  
								  valueTwo:[NSString stringWithFormat: @"%@",module_id]];
	
	NSArray *commentsArray = [dic objectForKey:@"comments"];
	if (commentsArray != [NSNull null] && [commentsArray count] > 0) 
	{
		for (int i = 0; i < [commentsArray count];i++ ) 
		{
			NSDictionary *commentDis = [commentsArray objectAtIndex:i];
			NSMutableArray *ar_comment = [[NSMutableArray alloc]init];
			[ar_comment addObject:[commentDis objectForKey:@"id"]];
			[ar_comment addObject:module_type_id];
			[ar_comment addObject:module_id];
			[ar_comment addObject:[commentDis objectForKey:@"uid"]];
			[ar_comment addObject:[commentDis objectForKey:@"module_title"] == [NSNull null] ? @"" : [commentDis objectForKey:@"module_title"]];
			[ar_comment addObject:[commentDis objectForKey:@"profile_image"] == [NSNull null] ? @"" : [commentDis objectForKey:@"profile_image"]];
			[ar_comment addObject:[commentDis objectForKey:@"weibo_user_name"] == [NSNull null] ? @"" : [commentDis objectForKey:@"weibo_user_name"]];
			[ar_comment addObject:[commentDis objectForKey:@"content"] == [NSNull null] ? @"" : [commentDis objectForKey:@"content"]];
			[ar_comment addObject:[commentDis objectForKey:@"like"]];
			[ar_comment addObject:[commentDis objectForKey:@"pro_name"] == [NSNull null] ? @"" : [commentDis objectForKey:@"pro_name"]];
			[ar_comment addObject:[commentDis objectForKey:@"city_name"] == [NSNull null] ? @"" : [commentDis objectForKey:@"city_name"]];
			[ar_comment addObject:[commentDis objectForKey:@"lng"]];
			[ar_comment addObject:[commentDis objectForKey:@"lat"]];
			[ar_comment addObject:[commentDis objectForKey:@"reply_counts"]];
			[ar_comment addObject:[commentDis objectForKey:@"created"]];
			
			//合并数组
			[CommentItems insertObject:ar_comment atIndex:i];
			[ar_comment release];
		}
	}
	
	//保存数据
	
	if (CommentItems != nil && [CommentItems count] > 0) 
	{
		for (int i = 0; i < [CommentItems count];i++)
		{
			if (i<20) {
				NSArray *comment_data = [CommentItems objectAtIndex:i];
				[DBOperate insertDataWithnotAutoID:comment_data tableName:T_COMMENT_LIST];
			}else {
				break;
			}
		}
	}
	
	//查询投票信息是否存在
	NSArray *ar_comment_vote = [DBOperate queryData:T_COMMENT_VOTE theColumn:@"module_type_id" equalValue1:module_type_id theColumn:@"module_id" equalValue:module_id];

	
	if ([ar_comment_vote count]>0) 
	{
		//存在则更新 暂时删除处理
		NSArray *one_vote = [ar_comment_vote objectAtIndex:0];
		NSNumber *vote_id = [one_vote objectAtIndex:comment_vote_id];
		
		[DBOperate deleteData:T_COMMENT_VOTE tableColumn:@"id" columnValue:vote_id];
	}
	else
	{
		//不存在则添加
		
	}
	
	NSMutableArray *ar_data_vote = [[NSMutableArray alloc] init];
	[ar_data_vote addObject:module_type_id];
	[ar_data_vote addObject:module_id];
	[ar_data_vote addObject:[dic objectForKey:@"like"]];
	[ar_data_vote addObject:[dic objectForKey:@"neutral"]];
	[ar_data_vote addObject:[dic objectForKey:@"dislike"]];
	[DBOperate insertData:ar_data_vote tableName:T_COMMENT_VOTE];
	[ar_data_vote release];

	//更新版本号 
	NSArray *ar_version = [DBOperate queryData:T_COMMENT_VERSION theColumn:@"module_type_id" equalValue1:module_type_id theColumn:@"module_id" equalValue:module_id];
	
	if ([ar_version count]>0) 
	{
		//存在则更新
		NSArray *one_version = [ar_version objectAtIndex:0];
		NSNumber *version_id = [one_version objectAtIndex:comment_version_id];
		[DBOperate updateData:T_COMMENT_VERSION 
				  tableColumn:@"ver" 
				  columnValue:[NSString stringWithFormat: @"%d",*ver]
			  conditionColumn:@"id"
		 conditionColumnValue:version_id];
	}
	else
	{
		//不存在则添加
		NSMutableArray *ar_data_version = [[NSMutableArray alloc] init];
		[ar_data_version addObject:module_type_id];
		[ar_data_version addObject:module_id];
		[ar_data_version addObject:[NSNumber numberWithInt:*ver]];
		[DBOperate insertData:ar_data_version tableName:T_COMMENT_VERSION];
		[ar_data_version release];
	}
	
	return nil;
	
}

+(NSMutableArray*)parseCommentListMore:(NSString*)jsonResult getVersion:(int*)ver{
	NSDictionary *dic = [jsonResult JSONValue];
	NSMutableArray *exitCommentArray = [NSMutableArray array];
	NSArray *commentsArray = [dic objectForKey:@"comments"];
	if (commentsArray != [NSNull null] && [commentsArray count] > 0) {
		for (int i = 0; i < [commentsArray count];i++ ) {
			NSDictionary *commentDis = [commentsArray objectAtIndex:i];
			NSMutableArray *ar_comment = [[NSMutableArray alloc]init];
			[ar_comment addObject:[commentDis objectForKey:@"id"]];
			[ar_comment addObject:[NSNumber numberWithInt:0]];
			[ar_comment addObject:[NSNumber numberWithInt:0]];
			[ar_comment addObject:[commentDis objectForKey:@"uid"]];
			[ar_comment addObject:[commentDis objectForKey:@"module_title"] == [NSNull null] ? @"" : [commentDis objectForKey:@"module_title"]];
			[ar_comment addObject:[commentDis objectForKey:@"profile_image"] == [NSNull null] ? @"" : [commentDis objectForKey:@"profile_image"]];
			[ar_comment addObject:[commentDis objectForKey:@"weibo_user_name"] == [NSNull null] ? @"" : [commentDis objectForKey:@"weibo_user_name"]];
			[ar_comment addObject:[commentDis objectForKey:@"content"] == [NSNull null] ? @"" : [commentDis objectForKey:@"content"]];
			[ar_comment addObject:[commentDis objectForKey:@"like"]];
			[ar_comment addObject:[commentDis objectForKey:@"pro_name"] == [NSNull null] ? @"" : [commentDis objectForKey:@"pro_name"]];
			[ar_comment addObject:[commentDis objectForKey:@"city_name"] == [NSNull null] ? @"" : [commentDis objectForKey:@"city_name"]];
			[ar_comment addObject:[commentDis objectForKey:@"lng"]];
			[ar_comment addObject:[commentDis objectForKey:@"lat"]];
			[ar_comment addObject:[commentDis objectForKey:@"reply_counts"]];
			[ar_comment addObject:[commentDis objectForKey:@"created"]];
			
			[exitCommentArray insertObject:ar_comment atIndex:i];
			[ar_comment release];
		}
	}
	return exitCommentArray;
}

+(NSMutableArray*)parsePublishComment:(NSString*)jsonResult{
	NSDictionary *dic = [jsonResult JSONValue];
	int ret = [[dic objectForKey:@"ret"]intValue];
	NSMutableArray *array = [NSMutableArray array];
	[array addObject:[NSNumber numberWithInt:ret]];
	return array;
}


+(NSMutableArray*)parseFansWallCommentList:(NSString*)jsonResult getVersion:(int*)ver
{
	*ver = NO_UPDATE;
	NSDictionary *dic = [jsonResult JSONValue];
	//屏蔽的id
	NSArray *publishedArray = [dic objectForKey:@"published"];
	//需要更新回复数的id
	NSArray *replyArray = [dic objectForKey:@"reply"];
	
	//update评论表评论数
	
	if (replyArray != nil && [replyArray count] > 0)
	{
		for(NSDictionary *replyDic in replyArray)
		{
			NSNumber *replyID = [NSNumber numberWithInteger:[[replyDic objectForKey:@"id"] intValue]];
			NSString *replyCount = [NSString stringWithFormat: @"%d", [[replyDic objectForKey:@"counts"] intValue]];
			[DBOperate updateData:T_FANSWALL_COMMENT_LIST
					  tableColumn:@"replyCount" 
					  columnValue:replyCount 
				  conditionColumn:@"id" 
			 conditionColumnValue:replyID];
		}
		*ver = NEED_UPDATE;
	}
	
	//删除被屏蔽的数据
	if (publishedArray != nil && [publishedArray count] > 0)
	{
		for(NSDictionary *publishedDic in publishedArray)
		{
			NSNumber *publishedID = [NSNumber numberWithInteger:[[publishedDic objectForKey:@"id"] intValue]];
			[DBOperate deleteData:T_FANSWALL_COMMENT_LIST 
					  tableColumn:@"id" 
					  columnValue:publishedID];
		}
		*ver = NEED_UPDATE;
	}
	
	
	//从数据库取出所有数据
	NSMutableArray *fansWallCommentItems = [DBOperate queryData:T_FANSWALL_COMMENT_LIST theColumn:nil theColumnValue:nil  withAll:YES];
	
	//删除所有数据
	[DBOperate deleteData:T_FANSWALL_COMMENT_LIST];
	
	NSArray *commentsArray = [dic objectForKey:@"comments"];
	if (commentsArray != [NSNull null] && [commentsArray count] > 0) 
	{
		for (int i = 0; i < [commentsArray count];i++ ) 
		{
			NSDictionary *commentDis = [commentsArray objectAtIndex:i];
			NSMutableArray *ar_comment = [[NSMutableArray alloc]init];
			[ar_comment addObject:[commentDis objectForKey:@"id"]];
			[ar_comment addObject:[commentDis objectForKey:@"uid"]];
			[ar_comment addObject:[commentDis objectForKey:@"module_title"] == [NSNull null] ? @"" : [commentDis objectForKey:@"module_title"]];
			[ar_comment addObject:[commentDis objectForKey:@"profile_image"] == [NSNull null] ? @"" : [commentDis objectForKey:@"profile_image"]];
			[ar_comment addObject:[commentDis objectForKey:@"weibo_user_name"] == [NSNull null] ? @"" : [commentDis objectForKey:@"weibo_user_name"]];
			[ar_comment addObject:[commentDis objectForKey:@"content"] == [NSNull null] ? @"" : [commentDis objectForKey:@"content"]];
			[ar_comment addObject:[commentDis objectForKey:@"like"]];
			[ar_comment addObject:[commentDis objectForKey:@"pro_name"] == [NSNull null] ? @"" : [commentDis objectForKey:@"pro_name"]];
			[ar_comment addObject:[commentDis objectForKey:@"city_name"] == [NSNull null] ? @"" : [commentDis objectForKey:@"city_name"]];
			[ar_comment addObject:[commentDis objectForKey:@"lng"]];
			[ar_comment addObject:[commentDis objectForKey:@"lat"]];
			[ar_comment addObject:[commentDis objectForKey:@"reply_counts"]];
			[ar_comment addObject:[commentDis objectForKey:@"created"]];
			
			//合并数组
			[fansWallCommentItems insertObject:ar_comment atIndex:i];
			[ar_comment release];
		}
		*ver = NEED_UPDATE;
	}
	
	//保存数据

	if (fansWallCommentItems != nil && [fansWallCommentItems count] > 0) 
	{
		for (int i = 0; i < [fansWallCommentItems count];i++)
		{
			if (i<20) {
				NSArray *comment_data = [fansWallCommentItems objectAtIndex:i];
				[DBOperate insertDataWithnotAutoID:comment_data tableName:T_FANSWALL_COMMENT_LIST];
			}else {
				break;
			}
		}
	}
	
	return nil;
}

+(NSMutableArray*)parseCommentReplyList:(NSString*)jsonResult getVersion:(int*)ver{
	
	NSDictionary *dic = [jsonResult JSONValue];
	NSMutableArray *replyListArray = [NSMutableArray array];
	
	NSArray *replyArray = [dic objectForKey:@"replys"];
	int v = [[dic objectForKey:@"ver"] intValue];
	*ver = [[dic objectForKey:@"ver"] intValue];
	if (replyArray != [NSNull null] && [replyArray count] > 0) {
		for (int i = 0; i < [replyArray count];i++ ) {
			NSDictionary *replyDis = [replyArray objectAtIndex:i];
			NSMutableArray *ar_reply = [[NSMutableArray alloc]init];
			[ar_reply addObject:[replyDis objectForKey:@"id"]];
			[ar_reply addObject:[replyDis objectForKey:@"uid"]];
			[ar_reply addObject:[replyDis objectForKey:@"weibo_user_name"] == [NSNull null] ? @"" : [replyDis objectForKey:@"weibo_user_name"]];
			[ar_reply addObject:[replyDis objectForKey:@"profile_image"] == [NSNull null] ? @"" : [replyDis objectForKey:@"profile_image"]];
			[ar_reply addObject:[replyDis objectForKey:@"content"] == [NSNull null] ? @"" : [replyDis objectForKey:@"content"]];
			[ar_reply addObject:[replyDis objectForKey:@"pro_name"] == [NSNull null] ? @"" : [replyDis objectForKey:@"pro_name"]];
			[ar_reply addObject:[replyDis objectForKey:@"city_name"] == [NSNull null] ? @"" : [replyDis objectForKey:@"city_name"]];
			[ar_reply addObject:[replyDis objectForKey:@"lng"]];
			[ar_reply addObject:[replyDis objectForKey:@"lat"]];
			[ar_reply addObject:[replyDis objectForKey:@"created"]];
			
			
			[replyListArray insertObject:ar_reply atIndex:i];
			[ar_reply release];
		}
	}
	return replyListArray;
}

+(NSMutableArray*)parseFansWallRecentlyCommentList:(NSString*)jsonResult getVersion:(int*)ver{
	
	NSMutableArray *resultArray = [[NSMutableArray alloc]init];
	NSDictionary *dic = [jsonResult JSONValue];
	NSArray *commentsArray = [dic objectForKey:@"comments"];
	if (commentsArray != [NSNull null] && [commentsArray count] > 0) 
	{
		for (int i = 0; i < [commentsArray count];i++ ) 
		{
			NSDictionary *commentDis = [commentsArray objectAtIndex:i];
			NSMutableArray *ar_comment = [[NSMutableArray alloc]init];
			[ar_comment addObject:[commentDis objectForKey:@"id"]];
			[ar_comment addObject:[commentDis objectForKey:@"uid"]];
			[ar_comment addObject:[commentDis objectForKey:@"module_title"] == [NSNull null] ? @"" : [commentDis objectForKey:@"module_title"]];
			[ar_comment addObject:[commentDis objectForKey:@"profile_image"] == [NSNull null] ? @"" : [commentDis objectForKey:@"profile_image"]];
			[ar_comment addObject:[commentDis objectForKey:@"weibo_user_name"] == [NSNull null] ? @"" : [commentDis objectForKey:@"weibo_user_name"]];
			[ar_comment addObject:[commentDis objectForKey:@"content"] == [NSNull null] ? @"" : [commentDis objectForKey:@"content"]];
			[ar_comment addObject:[commentDis objectForKey:@"like"]];
			[ar_comment addObject:[commentDis objectForKey:@"pro_name"] == [NSNull null] ? @"" : [commentDis objectForKey:@"pro_name"]];
			[ar_comment addObject:[commentDis objectForKey:@"city_name"] == [NSNull null] ? @"" : [commentDis objectForKey:@"city_name"]];
			[ar_comment addObject:[commentDis objectForKey:@"lng"]];
			[ar_comment addObject:[commentDis objectForKey:@"lat"]];
			[ar_comment addObject:[commentDis objectForKey:@"reply_counts"]];
			[ar_comment addObject:[commentDis objectForKey:@"created"]];
			[ar_comment addObject:[commentDis objectForKey:@"distance"] == [NSNull null] ? @"" : [commentDis objectForKey:@"distance"]];
			
			//合并数组
			[resultArray insertObject:ar_comment atIndex:i];
			[ar_comment release];

		}
	}
	*ver = NEED_UPDATE;
	return resultArray;
}

+(NSMutableArray*)parseMoreFansWallCommentList:(NSString*)jsonResult getVersion:(int*)ver{
	
	NSMutableArray *resultArray = [[NSMutableArray alloc]init];
	NSDictionary *dic = [jsonResult JSONValue];
	NSArray *commentsArray = [dic objectForKey:@"comments"];
	if (commentsArray != [NSNull null] && [commentsArray count] > 0) 
	{
		for (int i = 0; i < [commentsArray count];i++ ) 
		{
			NSDictionary *commentDis = [commentsArray objectAtIndex:i];
			NSMutableArray *ar_comment = [[NSMutableArray alloc]init];
			[ar_comment addObject:[commentDis objectForKey:@"id"]];
			[ar_comment addObject:[commentDis objectForKey:@"uid"]];
			[ar_comment addObject:[commentDis objectForKey:@"module_title"] == [NSNull null] ? @"" : [commentDis objectForKey:@"module_title"]];
			[ar_comment addObject:[commentDis objectForKey:@"profile_image"] == [NSNull null] ? @"" : [commentDis objectForKey:@"profile_image"]];
			[ar_comment addObject:[commentDis objectForKey:@"weibo_user_name"] == [NSNull null] ? @"" : [commentDis objectForKey:@"weibo_user_name"]];
			[ar_comment addObject:[commentDis objectForKey:@"content"] == [NSNull null] ? @"" : [commentDis objectForKey:@"content"]];
			[ar_comment addObject:[commentDis objectForKey:@"like"]];
			[ar_comment addObject:[commentDis objectForKey:@"pro_name"] == [NSNull null] ? @"" : [commentDis objectForKey:@"pro_name"]];
			[ar_comment addObject:[commentDis objectForKey:@"city_name"] == [NSNull null] ? @"" : [commentDis objectForKey:@"city_name"]];
			[ar_comment addObject:[commentDis objectForKey:@"lng"]];
			[ar_comment addObject:[commentDis objectForKey:@"lat"]];
			[ar_comment addObject:[commentDis objectForKey:@"reply_counts"]];
			[ar_comment addObject:[commentDis objectForKey:@"created"]];
			
			//合并数组
			[resultArray insertObject:ar_comment atIndex:i];
			[ar_comment release];

		}
	}
	*ver = NEED_UPDATE;
	return resultArray;
}

+(NSMutableArray*)parseAdvertiseResult:(NSString*)jsonResult getVersion:(int*)ver{
	NSDictionary *dic = [jsonResult JSONValue];
	NSArray *topsdArray = [dic objectForKey:@"tops"];
	NSArray *footsArray = [dic objectForKey:@"foots"];
	NSArray *publishedtopArray = [dic objectForKey:@"publishedtop"];
	NSArray *publishedfootArray = [dic objectForKey:@"publishedfoot"];
	*ver = NO_UPDATE;
	for (int i = 0;i < [publishedtopArray count] ;i++ ) {
		NSMutableArray *dic = [publishedtopArray objectAtIndex:i];
		NSNumber *temp = [dic objectForKey:@"id"];
		[DBOperate deleteData:T_ADVERTISE_LIST tableColumn:@"imageid" columnValue:temp];
	}
	for (int i = 0;i < [publishedfootArray count] ;i++ ) {
		NSMutableArray *dic = [publishedfootArray objectAtIndex:i];
		NSNumber *temp = [dic objectForKey:@"id"];
		[DBOperate deleteData:T_ADVERTISE_LIST tableColumn:@"imageid" columnValue:temp];
	}
	for(NSDictionary *topsdDic in topsdArray){
		NSMutableArray *ar_tops = [[NSMutableArray alloc]init];
		[ar_tops addObject:[topsdDic objectForKey:@"id"]];
		[ar_tops addObject:@"top"];
		[ar_tops addObject:[topsdDic objectForKey:@"img"]];
		[ar_tops addObject:[topsdDic objectForKey:@"desc"]];
		[ar_tops addObject:[topsdDic objectForKey:@"url"]];
		[ar_tops addObject:@""];
		*ver = NEED_UPDATE;
		
		[DBOperate insertDataWithnotAutoID:ar_tops tableName:T_ADVERTISE_LIST];
		[ar_tops release];
	}
	for(NSDictionary *footsDic in footsArray){
		NSMutableArray *ar_foots = [[NSMutableArray alloc]init];
		[ar_foots addObject:[footsDic objectForKey:@"id"]];
		[ar_foots addObject:@"foot"];
		[ar_foots addObject:[footsDic objectForKey:@"img"]];
		[ar_foots addObject:@""];
		[ar_foots addObject:[footsDic objectForKey:@"url"]];
		[ar_foots addObject:@""];
		*ver = NEED_UPDATE;
		NSString *imageUrl = [footsDic objectForKey:@"url"];
		if (imageUrl.length > 0) {
			[DBOperate insertDataWithnotAutoID:ar_foots tableName:T_ADVERTISE_LIST];
		}		
		[ar_foots release];
	}
	[self updateVersion:AD_QY_ID versionID:[dic objectForKey:@"ver_qy"] desc:@""];
	[self updateVersion:AD_PLATFORM_ID versionID:[dic objectForKey:@"ver_platform"] desc:@""];
	return nil;
}

@end
