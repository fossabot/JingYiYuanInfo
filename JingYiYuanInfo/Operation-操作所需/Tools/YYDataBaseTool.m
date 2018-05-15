//
//  YYDataBaseTool.m
//  JingYiYuanInfo
//
//  Created by 杨春禹 on 2017/10/5.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYDataBaseTool.h"
#import "YYIapModel.h"

static YYDataBaseTool *theData = nil;

@implementation YYDataBaseTool
{
    
    FMDatabase *fmdb;
    
}



+(instancetype)sharedDataBaseTool{
    
    @synchronized(self) {
        
        if(!theData) {
            
            theData= [[YYDataBaseTool alloc] init];
            
            [theData initDataBase];
            
        } }
    
    return theData;
    
}

-(void)initDataBase{
    
    //获得Documents目录路径
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    //文件路径
    
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"yyinfo.db"];
    
    //实例化FMDataBase对象
    
    YYLog(@"---path:%@",filePath);
    
    fmdb= [FMDatabase databaseWithPath:filePath];
    
    if([fmdb open]) {
        
        //初始化数据表
        
        [self addIapTable];
        [self addWebTable];
        
        [fmdb close];
        
    }else{
        
        YYLog(@"数据库打开失败---%@", fmdb.lastErrorMessage);
        
    }
}


//初始化内购表
-(void)addIapTable{
    
    NSString*yyinfoSQL =@"create table if not exists yyinfo (id integer Primary Key Autoincrement, transactionIdentifier text, productIdentifier text, userid text, receipt text, good_type text, transactionDate text, rechargeDate text, state integer)";
    
    BOOL yyinfoSuccess = [fmdb executeUpdate:yyinfoSQL];
    
    if(!yyinfoSuccess) {
        
        YYLog(@"内购数据表创建失败---%@",fmdb.lastErrorMessage);
        
    }
}


//返回未同步的支付结果集
- (NSMutableArray *)getAllUnCompleteIap {
    
    [fmdb open];
    
    NSMutableArray *array = [NSMutableArray new];
    
    FMResultSet *result = [fmdb executeQuery:@"select * from yyinfo where state = 0"];
    
    while([result next]) {
        
        YYIapModel *model = [[YYIapModel alloc] init];
        model.transactionIdentifier = [result stringForColumn:@"transactionIdentifier"];
        model.productIdentifier = [result stringForColumn:@"productIdentifier"];
        model.userid = [result stringForColumn:@"userid"];
        model.receipt = [result stringForColumn:@"receipt"];
        model.good_type = [result stringForColumn:@"good_type"];
        model.state = [result intForColumn:@"state"];
        [array addObject:model];
        
    }
    
    [fmdb close];
    
    return array;
}


- (void)saveIapDataWithTransactionIdentifier:(NSString *)transactionIdentifier productIdentifier:(NSString *)productIdentifier userid:(NSString *)userid receipt:(NSString *)receipt good_type:(NSString *)good_type transactionDate:(NSString *)transactionDate rechargeDate:(NSString *)rechargeDate state:(NSInteger)state {
    
    //检查是否存在该交易
    BOOL exist = [self checkTransactionIdentifier:transactionIdentifier];
    if (exist) {
        return;
    }
    [fmdb open];
    
    NSString*SQL =@"insert into yyinfo(transactionIdentifier, productIdentifier, userid, receipt, good_type, transactionDate, rechargeDate, state) values(?,?,?,?,?,?,?,?)";
    
    BOOL isAddSuccess = [fmdb executeUpdate:SQL,transactionIdentifier, productIdentifier, userid, receipt, good_type, transactionDate, rechargeDate, @(state)];
    
    if(!isAddSuccess) {
        
        YYLog(@"内购Table插入信息失败--%@",fmdb.lastErrorMessage);
    }
    
    NSString *selectSql = @"select * from yyinfo";
    FMResultSet *result = [fmdb executeQuery:selectSql];
    while ([result next]) {
        YYLog(@"transactionIdentifier  ---  %@",[result stringForColumn:@"transactionIdentifier"]);
        YYLog(@"productIdentifier  ---  %@",[result stringForColumn:@"productIdentifier"]);
        YYLog(@"userid  ---  %@",[result stringForColumn:@"userid"]);
        YYLog(@"receipt  ---  %@",[result stringForColumn:@"receipt"]);
        YYLog(@"transactionDate  ---  %@",[result stringForColumn:@"transactionDate"]);
        YYLog(@"rechargeDate  ---  %@",[result stringForColumn:@"rechargeDate"]);
        YYLog(@"state  ---  %d",[result intForColumn:@"state"]);
    }
    
    [fmdb close];
    
}


//修改这条交易的交易状态
- (void)changeTransactionIdentifierState:(NSString *)transactionIdentifier {

    [fmdb open];
    
    NSString *SQL = @"update yyinfo set state = ? where transactionIdentifier = ?";
    
    BOOL isSuccess = [fmdb executeUpdate:SQL, @1, transactionIdentifier];
    
    if(!isSuccess) {
        
        YYLog(@"修改状态失败--%@",fmdb.lastErrorMessage);
    }
    
    [fmdb close];
}

//检查transactionIdentifier是否存在，存在就不用添加相同交易到数据库了
- (BOOL)checkTransactionIdentifier:(NSString *)transactionIdentifier {
    
    [fmdb open];
    
    BOOL exist = NO;
    
    FMResultSet *result = [fmdb executeQuery:@"select * from yyinfo where transactionIdentifier = ?",transactionIdentifier];
    
    while([result next]) {
        
        exist = YES;
    }
    
    [fmdb close];
    
    return exist;
}


//检查该交易的交易状态，如果state是1 说明已同步完成 ，就不要再发给后台验证了
- (BOOL)checkTransactionDealState:(NSString *)transactionIdentifier {
    
    [fmdb open];
    
    BOOL state = NO;
    
    FMResultSet *result = [fmdb executeQuery:@"select * from yyinfo where transactionIdentifier = ?",transactionIdentifier];
    
    while([result next]) {
        
        int dealState = [result intForColumn:@"state"];
        if (dealState) {
            
            state = YES;
        }else {
            state = NO;
        }
    }
    
    [fmdb close];
    
    return state;
    
}




#pragma mark --- 这里是标记文章阅读状态的分隔线  ---------------

/**
 储存已阅读的网页url
 
 @param url url
 */
- (void)saveSelectedUrl:(NSString *)url {
    
    BOOL exist = [self isUrlHadReaded:url];
    
    if (!exist) {
        
        [fmdb open];
        
        NSString*SQL =@"insert into yyinfoarticle(webUrl) values(?)";
        
        BOOL isAddSuccess = [fmdb executeUpdate:SQL,url];
        
        if(!isAddSuccess) {
            
            YYLog(@"内购Table插入信息失败--%@",fmdb.lastErrorMessage);
        }
        
        NSString *selectSql = @"select * from yyinfo";
        FMResultSet *result = [fmdb executeQuery:selectSql];
        while ([result next]) {
            YYLog(@"webUrl  ---  %@",[result stringForColumn:@"webUrl"]);
        }
        
        [fmdb close];
        
    }
    
}


//初始化网页浏览记录表
-(void)addWebTable{
    
    NSString*yyinfoSQL =@"create table if not exists yyinfoarticle (id integer Primary Key Autoincrement, webUrl text)";
    
    BOOL yyinfoSuccess = [fmdb executeUpdate:yyinfoSQL];
    
    if(!yyinfoSuccess) {
        
        YYLog(@"内购数据表创建失败---%@",fmdb.lastErrorMessage);
        
    }
}


/**
 查询某网址是否被阅读过  并返回状态 yes读过  no未读

 @param url 网址
 @return 阅读状态
 */
- (BOOL)isUrlHadReaded:(NSString *)url {
    
    [fmdb open];
    
    BOOL exist = NO;
    
    FMResultSet *result = [fmdb executeQuery:@"select * from yyinfoarticle where webUrl = ?",url];
    
    while([result next]) {
        
        exist = YES;
    }
    
    [fmdb close];
    
    return exist;
    
}




@end
