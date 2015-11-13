//
//  DBOperate.m
//  Shopping
//
//  Created by zhu zhu chao on 11-3-22.
//  Copyright 2011 sal. All rights reserved.
//

#import "DBOperate.h"
#import "FileManager.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "Common.h"








#define C_T_360PIC @"create table tb_360pic (id integer primary key autoincrement,picurl TEXT)" 


#define C_T_VIDEO @"create table tb_video\
(id INTEGER PRIMARY KEY AUTOINCREMENT,\
video_picname TEXT,\
video_picpath TEXT,\
video_path TEXT,\
video_iphone_name TEXT,\
video_android_name TEXT,\
content TEXT)"



@implementation DBOperate
+(BOOL)createTable{
	NSArray *tableListSql=[NSArray arrayWithObjects:C_T_VERSION,C_T_CATEGORY_PRETTY_PIC,C_T_PRODUCT_PRETTY_PIC,C_T_PIC,C_T_WALLPAPER,\
						   C_T_COMMUNITY,C_T_PROMOTIONS,C_T_COMPANYNEWS,C_T_HOT,C_T_HOTLINE,C_T_360PIC,C_T_SUBBRANCH,\
						   C_T_ABOUT,C_T_VIDEO,C_T_BUSINESS,C_T_MYSERVICE,C_T_MYSNS,C_T_DEVTOKEN,C_T_WEIBO_USERINFO,\
						   C_T_COMMENT_VOTE,C_T_COMMENT_LIST,C_T_COMMENT_VERSION,C_T_FANSWALL_COMMENT_LIST,\
						   C_T_ADVERTISE_LIST,C_T_APP_INFO,nil];
	NSArray *tableList=[NSArray arrayWithObjects:T_VERSION,T_CATEGORY_PRETTY_PIC,T_PRODUCT_PRETTY_PIC,T_PIC,T_WALLPAPER,\
						T_COMMUNITY,T_PROMOTIONS,T_COMPANYNEWS,T_HOT,T_HOTLINE,T_360PIC,T_SUBBRANCH,\
						T_ABOUT,T_VIDEO,T_BUSINESS,T_MYSERVICE,T_MYSNS,T_DEVTOKEN,T_WEIBO_USERINFO,\
						T_COMMENT_VOTE,T_COMMENT_LIST,T_COMMENT_VERSION,T_FANSWALL_COMMENT_LIST,\
						T_ADVERTISE_LIST,T_APP_INFO,nil];
	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	NSLog(@"dbfilepath %@",dbFilePath);
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	if ([db open]) {
		[db setShouldCacheStatements:YES];
		for (int i = 0 ;i <[tableList count];i++) {
			//NSString *checkTableSQL = [NSString stringWithFormat:@"SELECT COUNT(*) as CNT FROM sqlite_master WHERE type='table' AND name='%@'",[tableList objectAtIndex:i]];
			NSString *checkTableSQL = [NSString stringWithFormat:@"SELECT name FROM sqlite_master WHERE type='table' AND name='%@'",[tableList objectAtIndex:i]];
			//FMResultSet *rs1 = [db executeQuery:checkTableSQL];
			NSLog(@"checktablke %@",checkTableSQL);
			FMResultSet *rs = [db executeQuery:checkTableSQL];
			//[db executeQuery:@"VACUUM"];
			if (![rs next]) {
				NSLog(@"create table %@",[tableList objectAtIndex:i]);
				[db executeUpdate:[tableListSql objectAtIndex:i]];
			}
			//[rs close];
		}
		
	}
	//[db executeQuery:@"VACUUM"];
	NSLog(@"finsih ");
	[db close];
	return YES;
}
//////插入一整行，array数组元素个数需与该表列数一致  忽略第一个字段id 因为已经设着它为自增
+(BOOL)insertData:(NSArray *)data tableName:(NSString *)aName{
	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	NSUInteger columCount=[data count];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	NSString *colum=@",?";
	for (NSInteger i=0; i<columCount-1; i++) {
		colum=[colum stringByAppendingString:@",?"];
	}
	if ([db open]) {
		[db setShouldCacheStatements:YES];
		
		[db beginTransaction];
		
		[db executeUpdate:[NSString stringWithFormat:@"insert into %@ values(NULL%@)",aName,colum] withArgumentsInArray:data];
		
		if ([db hadError]) {
			NSLog(@"Err %d %@",[db lastErrorCode],[db lastErrorMessage]);
			[db rollback];
			return NO;
		}
		[db commit];
		[db close];
		return YES;
	}else {
		NSLog(@"could not open dababase!");
		return NO;
	}
	
}
//插入一行不忽略第一个id字段
+(BOOL)insertDataWithnotAutoID:(NSArray *)data tableName:(NSString *)aName{
	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	NSUInteger columCount=[data count];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	NSString *colum=@"?";
	for (NSInteger i=0; i<columCount-1; i++) {
		colum=[colum stringByAppendingString:@",?"];
	}
	if ([db open]) {
		[db setShouldCacheStatements:YES];
		
		[db beginTransaction];
		
		[db executeUpdate:[NSString stringWithFormat:@"insert into %@ values(%@)",aName,colum] withArgumentsInArray:data];
		
		if ([db hadError]) {
			NSLog(@"Err %d %@",[db lastErrorCode],[db lastErrorMessage]);
			[db rollback];
			[db close];
			return NO;
		}
		
		[db commit];
		[db close];
		return YES;
	}else {
		NSLog(@"could not open dababase!");
		return NO;
	}
	
}





+(NSArray *)queryData:(NSString *)aName theColumn:(NSString *)aColumn equalValue1:(id)aColumnValue theColumn:(NSString*)bColumn equalValue:(id)bColumnValue{
	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	
	if ([db open]){
		[db setShouldCacheStatements:YES];
		NSMutableArray *FinalArray=[NSMutableArray arrayWithCapacity:0];
		FMResultSet *rs=nil;
		rs=[db executeQuery:[NSString stringWithFormat:@"select * from %@ where %@=? and %@=?", aName,aColumn,bColumn],aColumnValue,bColumnValue];
		
		int col = sqlite3_column_count(rs.statement.statement); // sqlite3_column_count(rs.statement)
		while ([rs next]) {
			NSMutableArray *rsArray=[NSMutableArray arrayWithCapacity:0];
			for (int i=0; i<col; i++) {
				NSString *temp =[rs stringForColumnIndex:i];
				if (temp == nil) {
					[rsArray addObject:@""];
				}
				else {
					[rsArray addObject:temp];
				}
				
				
			}
			[FinalArray addObject:(NSMutableArray *)rsArray];
			//[rsArray removeAllObjects];
		}
		[rs close];
		[db close];
		return FinalArray;
		
	}else {
		NSLog(@"could not open dababase!");
		return nil;
	}
	
}

+(NSArray *)queryData:(NSString *)aName theColumn:(NSString *)aColumn noEqualValue:(id)aColumnValue theColumn:(NSString*)bColumn equalValue:(id)bColumnValue{
	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	
	if ([db open]){
		[db setShouldCacheStatements:YES];
		NSMutableArray *FinalArray=[NSMutableArray arrayWithCapacity:0];
		FMResultSet *rs=nil;
		if ([aName isEqualToString:T_PRODUCT_PRETTY_PIC]) {
			rs=[db executeQuery:[NSString stringWithFormat:@"select * from %@ where %@!=? and %@=? order by createTime desc", aName,aColumn,bColumn],aColumnValue,bColumnValue];
		}else {
			rs=[db executeQuery:[NSString stringWithFormat:@"select * from %@ where %@!=? and %@=?", aName,aColumn,bColumn],aColumnValue,bColumnValue];
		}
		int col = sqlite3_column_count(rs.statement.statement); // sqlite3_column_count(rs.statement)
		while ([rs next]) {
			NSMutableArray *rsArray=[NSMutableArray arrayWithCapacity:0];
			for (int i=0; i<col; i++) {
				NSString *temp =[rs stringForColumnIndex:i];
				if (temp == nil) {
					[rsArray addObject:@""];
				}
				else {
					[rsArray addObject:temp];
				}
				
				
			}
			[FinalArray addObject:(NSMutableArray *)rsArray];
			//[rsArray removeAllObjects];
		}
		[rs close];
		[db close];
		return FinalArray;
		
	}else {
		NSLog(@"could not open dababase!");
		return nil;
	}
	
}


////////查询整个表，或是查询某个条件下的一整行
////select * from aName
////select * from aName where aColumn=aColumnValue
+(NSArray *)queryData:(NSString *)aName theColumn:(NSString *)aColumn theColumnValue:(NSString *)aColumnValue  withAll:(BOOL)yesNO{
	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	NSLog(@"dbfilepath %@",dbFilePath);
	NSLog(@"queryData ");
	if ([db open]){
		[db setShouldCacheStatements:YES];
		NSMutableArray *FinalArray=[NSMutableArray arrayWithCapacity:0];
		FMResultSet *rs=nil;
		if (yesNO) {
			if ([aName isEqualToString:T_CATEGORY_PRETTY_PIC]) {
				rs=[db executeQuery:[NSString stringWithFormat:@"select * from %@ order by sortid,id", aName]];
			}
			else if ([aName isEqualToString:T_HOT] || [aName isEqualToString:T_COMPANYNEWS] || [aName isEqualToString:T_PROMOTIONS]) {
				rs=[db executeQuery:[NSString stringWithFormat:@"select * from %@ order by createTime desc", aName,aColumn],aColumnValue];
			}
			else if ([aName isEqualToString:T_FANSWALL_COMMENT_LIST]) {
				rs=[db executeQuery:[NSString stringWithFormat:@"select * from %@ order by created desc", aName]];
			}else {
				rs=[db executeQuery:[NSString stringWithFormat:@"select * from %@ ", aName]];
			}
		}else {
			if ([aName isEqualToString:T_CATEGORY_PRETTY_PIC]) {
				rs=[db executeQuery:[NSString stringWithFormat:@"select * from %@ where %@=? order by sortid,id", aName,aColumn],aColumnValue];				
			}
			else if ([aName isEqualToString:T_HOT] || [aName isEqualToString:T_COMPANYNEWS] || [aName isEqualToString:T_PROMOTIONS]) {
				rs=[db executeQuery:[NSString stringWithFormat:@"select * from %@ order by createTime desc", aName,aColumn],aColumnValue];
			}
			else if ([aName isEqualToString:T_ADVERTISE_LIST]) {
				rs=[db executeQuery:[NSString stringWithFormat:@"select * from %@ where %@=? order by imageid asc", aName,aColumn],aColumnValue];
			}
			else {
				rs=[db executeQuery:[NSString stringWithFormat:@"select * from %@ where %@=?", aName,aColumn],aColumnValue];				
			}
			
		}
		
		int col = sqlite3_column_count(rs.statement.statement); // sqlite3_column_count(rs.statement)
		while ([rs next]) {
			NSMutableArray *rsArray=[NSMutableArray arrayWithCapacity:0];
			for (int i=0; i<col; i++) {
				NSString *temp =[rs stringForColumnIndex:i];
				if (temp == nil) {
					[rsArray addObject:@""];
				}
				else {
					[rsArray addObject:temp];
				}
				
				
			}
			[FinalArray addObject:(NSMutableArray *)rsArray];
			//[rsArray removeAllObjects];
		}
		[rs close];
		[db close];
		return FinalArray;
		
	}else {
		NSLog(@"could not open dababase!");
		return nil;
	}
	
}

//////查询某列一个值或是返回一整列的值
//select theColumn from aTableName where aColumn＝aColumnValue
//select theColumn from aTableName
+(NSArray *)selectColumn:(NSString *)theColumn 
			   tableName:(NSString *)aTableName 
			   conColumn:(NSString *)aColumn 
		  conColumnValue:(NSString *)aColumnValue 
		 withWholeColumn:(BOOL)yesNO
{
	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	
	if ([db open]){
		[db setShouldCacheStatements:YES];
		FMResultSet *rs=nil;
		if (yesNO) {
			rs=[db executeQuery:[NSString stringWithFormat:@"select %@ from %@ ",theColumn, aTableName]];
		}else {
			rs=[db executeQuery:[NSString stringWithFormat:@"select %@ from %@ where %@=?", theColumn,aTableName,aColumn],aColumnValue];
		}
		NSMutableArray *rsArray=[NSMutableArray arrayWithCapacity:0];		
		while ([rs next]) {
			NSString *temp =[rs stringForColumn:theColumn];
			[rsArray addObject:temp];
		}
		[rs close];
		[db close];
		return rsArray;
		
	}else {
		NSLog(@"could not open dababase!");
		return nil;
	}
}

+(BOOL)deleteALLData:(NSString *)tableName{
	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	
	if ([db open]) {
		[db setShouldCacheStatements:YES];		
		[db beginTransaction];
		[db executeUpdate:[NSString stringWithFormat:@"delete from %@",tableName]];		
		if ([db hadError]) {
			NSLog(@"Err %d %@",[db lastErrorCode],[db lastErrorMessage]);
			[db rollback];
			return NO;
		}
		[db commit];
		[db close];
		return YES;
	}else {
		NSLog(@"could not open dababase!");
		return NO;
	}
}

////////////删除某个条件下的某一行 如 delete from tableName where colunm=aValue
+(BOOL)deleteData:(NSString *)tableName tableColumn:(NSString *)column columnValue:(id)aValue{
	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	
	if ([db open]) {
		[db setShouldCacheStatements:YES];		
		[db beginTransaction];
		[db executeUpdate:[NSString stringWithFormat:@"delete from %@ where %@=?",tableName,column],aValue];		
		if ([db hadError]) {
			NSLog(@"Err %d %@",[db lastErrorCode],[db lastErrorMessage]);
			[db rollback];
			return NO;
		}
		[db commit];
		[db close];
		return YES;
	}else {
		NSLog(@"could not open dababase!");
		return NO;
	}
}
/*+(BOOL)deleteData:(NSString *)tableName tableColumn:(NSString *)column columnNumberValue:(NSNumber*)aValue{
 NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
 FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
 
 if ([db open]) {
 [db setShouldCacheStatements:YES];		
 [db beginTransaction];
 [db executeUpdate:[NSString stringWithFormat:@"delete from %@ where %@=?",tableName,column],aValue];		
 if ([db hadError]) {
 NSLog(@"Err %d %@",[db lastErrorCode],[db lastErrorMessage]);
 [db rollback];
 return NO;
 }
 [db commit];
 [db close];
 return YES;
 }else {
 NSLog(@"could not open dababase!");
 return NO;
 }
 }*/

//+(BOOL)deleteData:(NSString *)tableName condition:(NSString *)con {
//	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
//	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
//	
//	if ([db open]) {
//		[db setShouldCacheStatements:YES];		
//		[db beginTransaction];
//		[db executeUpdate:[NSString stringWithFormat:@"delete from %@ where %@",tableName,con]];		
//		if ([db hadError]) {
//			NSLog(@"Err %d %@",[db lastErrorCode],[db lastErrorMessage]);
//			[db rollback];
//			return NO;
//		}
//		[db commit];
//		[db close];
//		return YES;
//	}else {
//		NSLog(@"could not open dababase!");
//		return NO;
//	}
//}

+(BOOL)deleteData:(NSString *)tableName {
	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	
	if ([db open]) {
		[db setShouldCacheStatements:YES];		
		[db beginTransaction];
		[db executeUpdate:[NSString stringWithFormat:@"delete from %@ ",tableName]];		
		if ([db hadError]) {
			NSLog(@"Err %d %@",[db lastErrorCode],[db lastErrorMessage]);
			[db rollback];
			return NO;
		}
		[db commit];
		[db close];
		return YES;
	}else {
		NSLog(@"could not open dababase!");
		return NO;
	}
}


+(BOOL)updateData:(NSString *)tableName tableColumn:(NSString *)column columnValue:(NSString *)aValue 
  conditionColumn:(NSString *)conColumn conditionColumnValue:(id)conValue
{
	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	
	if ([db open]) {
		[db setShouldCacheStatements:YES];		
		[db beginTransaction];
		//	NSLog([NSString stringWithFormat:@"update %@ set %@=%@ where %@=%@",tableName,column,aValue,conColumn,conValue]);
		//	[db executeUpdate:@"update ? set ?=? where ?=?",tableName,column,aValue,conColumn,conValue];
		//NSLog(@"sql %@",[NSString stringWithFormat:@"update %@ set %@=? where %@=?",tableName,column,conColumn]);
		NSLog(@"column %@ value %@, conColum %@  value %@",column,aValue,conColumn,conValue);
		[db executeUpdate:[NSString stringWithFormat:@"update %@ set %@=? where %@=?",tableName,column,conColumn],aValue,conValue];
		if ([db hadError]) {
			NSLog(@"Err %d %@",[db lastErrorCode],[db lastErrorMessage]);
			[db rollback];
			return NO;
		}
		[db commit];
		[db close];
		return YES;
	}else {
		NSLog(@"could not open dababase!");
		return NO;
	}
}

+(BOOL)updateData:(NSString *)tableName tableColumn:(NSString *)column columnValue:(NSString *)aValue 
  conditionColumn1:(NSString *)conColumn1 conditionColumnValue1:(id)conValue1
  conditionColumn2:(NSString *)conColumn2 conditionColumnValue2:(id)conValue2
{
	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	
	if ([db open]) {
		[db setShouldCacheStatements:YES];		
		[db beginTransaction];
		//	NSLog([NSString stringWithFormat:@"update %@ set %@=%@ where %@=%@",tableName,column,aValue,conColumn,conValue]);
		//	[db executeUpdate:@"update ? set ?=? where ?=?",tableName,column,aValue,conColumn,conValue];
		//NSLog(@"sql %@",[NSString stringWithFormat:@"update %@ set %@=? where %@=?",tableName,column,conColumn]);
		[db executeUpdate:[NSString stringWithFormat:@"update %@ set %@=? where %@=? and %@=?",tableName,column,conColumn1,conColumn2],aValue,conValue1,conValue2];
		if ([db hadError]) {
			NSLog(@"Err %d %@",[db lastErrorCode],[db lastErrorMessage]);
			[db rollback];
			return NO;
		}
		[db commit];
		[db close];
		return YES;
	}else {
		NSLog(@"could not open dababase!");
		return NO;
	}
}


//+(BOOL)updateData:(NSString *)tableName tableColumn:(NSString *)column columnValue:(NSString *)aValue 
//{
//	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
//	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
//	
//	if ([db open]) {
//		[db setShouldCacheStatements:YES];		
//		[db beginTransaction];
//		//	NSLog([NSString stringWithFormat:@"update %@ set %@=%@ where %@=%@",tableName,column,aValue,conColumn,conValue]);
//		//	[db executeUpdate:@"update ? set ?=? where ?=?",tableName,column,aValue,conColumn,conValue];		
//		[db executeUpdate:[NSString stringWithFormat:@"update %@ set %@=? ",tableName,column],aValue];
//		if ([db hadError]) {
//			NSLog(@"Err %d %@",[db lastErrorCode],[db lastErrorMessage]);
//			[db rollback];
//			return NO;
//		}
//		[db commit];
//		[db close];
//		return YES;
//	}else {
//		NSLog(@"could not open dababase!");
//		return NO;
//	}
//}

///////按正序或倒序查询某表的某列前n条记录
+(NSArray *)selectTopNColumn:(NSString *)theColumn tableName:(NSString *)aTableName rowNum:(NSInteger)n 
{
	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	
	if ([db open]){
		[db setShouldCacheStatements:YES];
		FMResultSet *rs=nil;
		if (n==WHOLE_COLUMN) {
			rs=[db executeQuery:[NSString stringWithFormat:@"select %@ from %@ ORDER BY id DESC  ",theColumn, aTableName]];
		}else {
			NSLog(@"%@",[NSString stringWithFormat:@"select %@ from %@ ORDER BY id DESC limit 0,%d ",theColumn, aTableName,n]);
			rs=[db executeQuery:[NSString stringWithFormat:@"select %@ from %@ ORDER BY id DESC limit 0,%d ",theColumn, aTableName,n]];
		}
		NSMutableArray *rsArray=[NSMutableArray arrayWithCapacity:0];		
		while ([rs next]) {
			NSString *temp =[rs stringForColumn:theColumn];
			[rsArray addObject:temp];
		}
		[rs close];
		[db close];
		return rsArray;
		
	}else {
		NSLog(@"could not open dababase!");
		return nil;
	}
	
}
///倒序或是正序查询一列
//select theColumn from aTableName where aColumn=aColumnValue order by ID descOrAsc
+(NSArray *)selectColumnWithOrder:(NSString *)theColumn 
						tableName:(NSString *)aTableName 
						conColumn:(NSString *)aColumn 
				   conColumnValue:(NSString *)aColumnValue 
						  orderBy:(NSString *)descOrAsc
{
	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	
	if ([db open]){
		[db setShouldCacheStatements:YES];
		FMResultSet *rs=[db executeQuery:[NSString stringWithFormat:@"select %@ from %@ where %@ = '%@' order by ID %@",theColumn, aTableName,aColumn,aColumnValue,descOrAsc]];
		NSMutableArray *rsArray=[NSMutableArray arrayWithCapacity:0];		
		while ([rs next]) {
			NSString *temp =[rs stringForColumn:theColumn];
			[rsArray addObject:temp];
		}
		[rs close];
		[db close];
		return rsArray;
		
	}else {
		NSLog(@"could not open dababase!");
		return nil;
	}
}



//add by zhanghao
+(NSArray *)getSearchIndex:(NSString *)tableName;
{
	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];	
	if ([db open]){
		[db setShouldCacheStatements:YES];
		NSString *string;
		NSMutableArray *rsArray=[NSMutableArray arrayWithCapacity:0];
		FMResultSet *rs=nil;
		rs=[db executeQuery:[NSString stringWithFormat:@"select distinct(searchIndex) from %@",tableName]];
		while ([rs next]) {			
			string=[rs stringForColumnIndex:0];
			[rsArray addObject:string];
		}
		[rs close];
		[db close];
		return rsArray;
		
	}else {
		NSLog(@"could not open dababase!");
		return nil;
	}
	
}
+(NSArray *)getContentForIndex:(NSString *)index InTable:(NSString *)tableName{
	
	return [self queryData:tableName theColumn:@"searchIndex" theColumnValue:index withAll:NO];
}
//======

+(NSArray *)qureyWithTwoConditions:(NSString *)tabelName 
						 ColumnOne:(NSString *)columnOne 
						  valueOne:(NSString *)valueOne 
						 columnTwo:(NSString *)columnTwo
						  valueTwo:(NSString *)valueTwo
{
	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	
	if ([db open]){
		[db setShouldCacheStatements:YES];
		NSMutableArray *FinalArray=[NSMutableArray arrayWithCapacity:0];
		FMResultSet *rs=nil;
		rs=[db executeQuery:[NSString stringWithFormat:@"select * from %@ where %@=? and %@=?", tabelName,columnOne,columnTwo],valueOne,valueTwo];
		int col = sqlite3_column_count(rs.statement.statement); // sqlite3_column_count(rs.statement)
		while ([rs next]) {
			NSMutableArray *rsArray=[NSMutableArray arrayWithCapacity:0];
			for (int i=0; i<col; i++) {
				NSString *temp =[rs stringForColumnIndex:i];
				[rsArray addObject:temp];
			}
			[FinalArray addObject:(NSMutableArray *)rsArray];
		}
		[rs close];
		[db close];
		return FinalArray;
	}else {
		NSLog(@"could not open dababase!");
		return nil;
	}
	
	
	
	
}


+(BOOL)updateWithTwoConditions:(NSString *)tabelName 
					 theColumn:(NSString *)Column 
				theColumnValue:(NSString *)aValue 
					 ColumnOne:(NSString *)columnOne 
					  valueOne:(NSString *)valueOne 
					 columnTwo:(NSString *)columnTwo 
					  valueTwo:(NSString *)valueTwo;
{
	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	
	if ([db open]) {
		[db setShouldCacheStatements:YES];		
		[db beginTransaction];	
		[db executeUpdate:[NSString stringWithFormat:@"update %@ set %@=? where %@=? and %@=?",tabelName,Column,columnOne,columnTwo],aValue,valueOne,valueTwo];
		if ([db hadError]) {
			NSLog(@"Err %d %@",[db lastErrorCode],[db lastErrorMessage]);
			[db rollback];
			return NO;
		}
		[db commit];
		[db close];
		return YES;
	}else {
		NSLog(@"could not open dababase!");
		return NO;
	}
	
	
}



+(BOOL)deleteDataWithTwoConditions:(NSString *)tableName 
						 columnOne:(NSString *)columnOne 
						  valueOne:(NSString *)valueOne 
						 columnTwo:(NSString *)columnTwo
						  valueTwo:(NSString *)valueTwo
{
	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	
	if ([db open]) {
		[db setShouldCacheStatements:YES];		
		[db beginTransaction];
		[db executeUpdate:[NSString stringWithFormat:@"delete from %@ where %@=? and %@=?",tableName,columnOne,columnTwo],valueOne,valueTwo];		
		if ([db hadError]) {
			NSLog(@"Err %d %@",[db lastErrorCode],[db lastErrorMessage]);
			[db rollback];
			return NO;
		}
		[db commit];
		[db close];
		return YES;
	}else {
		NSLog(@"could not open dababase!");
		return NO;
	}
	
}





@end
