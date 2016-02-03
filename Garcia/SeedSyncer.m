#import "SeedSyncer.h"
#import "Postman.h"
#import "PostmanConstant.h"
#import "MBProgressHUD.h"
#import "DBManager.h"
@interface SeedSyncer()<DBManagerDelegate>

@end
@implementation SeedSyncer
{
    Postman *postman;
    DBManager *dbmanager;
    NSString *urlString;
    NSUserDefaults *userDefault;
}
+ (SeedSyncer *)sharedSyncer{
    static dispatch_once_t token;
    static SeedSyncer *syncer=nil;
    dispatch_once(&token,^{
        syncer=[[SeedSyncer alloc]init];
    });
    return syncer;
}
-(instancetype)init{
    self=[super init];
//    postman=[[Postman alloc]init];
    urlString=[NSString stringWithFormat:@"%@%@",baseUrl,kGET_SEED_URL];
    userDefault=[NSUserDefaults standardUserDefaults];
    dbmanager=[[DBManager alloc]initWithFileName:@"API_Resp.db"];
    dbmanager.delegate=self;
    return self;
}
- (void)callSeedAPI:(void (^)(BOOL success))completionHandler{
    postman=[[Postman alloc]init];
   [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:NO];
    [postman get:urlString withParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([self parseResponse:responseObject]) {
            completionHandler(true);
        }else completionHandler(false);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionHandler(false);
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
    }];

}
-(BOOL)parseResponse:(id)responseObject{
    NSDictionary *dict=responseObject;
    NSArray *seedArray = dict[@"seedmaster"];
    if (seedArray) {
        for (NSDictionary *seed in seedArray) {
            [self compareAndSave:seed];
        }
        return YES;
    }else{
        return NO;
    }
}
-(void)compareAndSave:(NSDictionary*)dict{
    NSInteger localValue=[userDefault integerForKey:[NSString stringWithFormat:@"%@_Value",dict[@"TableName"]]];
    NSInteger newValue = [dict[@"UpdateCount"] integerValue];
    if (localValue<newValue) {
        [userDefault setInteger:newValue forKey:[NSString stringWithFormat:@"%@_Value",dict[@"TableName"]]];
        NSString *stausKey=[NSString stringWithFormat:@"%@_FLAG", dict[@"TableName"]];
        [userDefault setBool:true forKey:stausKey];
    }
}
- (void)saveResponse:(NSString *)responseString forIdentity:(NSString *)identity{
NSString *createQuer=@"create table if not exists API_TABLE(API text  PRIMARY KEY,data text)";
    [dbmanager createTableForQuery:createQuer];
    NSMutableString *mutResponseString=[responseString mutableCopy];
    NSRange rageOfString;
    rageOfString.location=0;
    rageOfString.length=mutResponseString.length;
    [mutResponseString replaceOccurrencesOfString:@"'"  withString:@"''" options:(NSCaseInsensitiveSearch) range:rageOfString];
    NSString *inserSql=[NSString stringWithFormat:@"INSERT OR REPLACE INTO  API_TABLE (API,data) values ('%@', '%@')",identity,mutResponseString];
    [dbmanager saveDataToDBForQuery:inserSql];
    
}
- (void)getResponseFor:(NSString *)identity completionHandler:(void (^)(BOOL success, id response))completionHandler{
    NSString *getDataQuery=[NSString stringWithFormat:@"select * from API_TABLE where API='%@'",identity];
    [dbmanager getDataForQuery:getDataQuery withCompletionHandler:^(BOOL success, sqlite3_stmt *statment){
        if (success){
            if (sqlite3_step(statment)==SQLITE_ROW) {
                NSString *string = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statment,1)];
                NSData *data=[string dataUsingEncoding:NSUTF8StringEncoding];
                id response=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                completionHandler(YES,response);
            }
        
        }else{
         completionHandler(NO,nil);
        }
    
    
    
    }];
}
- (void)DBManager:(DBManager *)manager gotSqliteStatment:(sqlite3_stmt *)statment{

}
@end
