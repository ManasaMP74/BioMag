#import "ImageUploadAPI.h"
#import "Postman.h"
#import "PostmanConstant.h"
#import <AFNetworking/AFNetworking.h>

@implementation ImageUploadAPI
{
    Postman *postman;
    NSString *_imagePath;
    NSString *_pathToDoc;
    AFHTTPRequestOperationManager *manager;
}
//get image
- (void)uploadDocumentPath:(NSString *)imagePath forRequestCode:(NSString *)reqCode withDocumentType:(NSArray*)docType withText:(NSArray*)caption withRequestType:(NSString*)reqType onCompletion:(void (^)(BOOL))completionHandler
{
    [self uploadUserDocumentPath:imagePath forRequestCode:reqCode withType:docType withText:caption withRequestType:reqType onCompletion:completionHandler];
}
//upload Image
- (void)uploadUserDocumentPath:(NSString *)imagePath forRequestCode:(NSString *)reqCode withType:(NSArray *)type withText:(NSArray*)caption withRequestType:(NSString*)reqType onCompletion:(void (^)(BOOL))completionHandler
{
    if ([reqCode isKindOfClass:[NSNull class]])
    {
        return;
    }
    if (reqCode.length == 0)
    {
        return;
    }
   
    [self setHeader];
    NSString  *URLString =  [NSString stringWithFormat:@"%@%@", baseUrl,uploadFile];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    dict[@"RequestCode"]=reqCode;
    dict[@"RequestType"]=reqType;
    dict[@"DocumentTypes"]=type;
    dict[@"Renames"]=caption;
    dict[@"SortNumbers"]=@[@"1"];
    NSData *parameterData = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:parameterData encoding:NSUTF8StringEncoding];
    NSDictionary *parameter = @{@"request":jsonString};
    [manager POST:URLString parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:imagePath]name:@"Files" error:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completionHandler(YES);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionHandler(NO);
    }];
}
//get profile image
- (void)uploadUserImagePath:(NSString *)imagePath forRequestCode:(NSString *)reqCode withDocumentType:(NSString*)docType onCompletion:(void (^)(BOOL))completionHandler
{
    [self uploadImagePath:imagePath forRequestCode:reqCode withType:docType onCompletion:completionHandler];
}
//upload  profile Image
- (void)uploadImagePath:(NSString *)imagePath forRequestCode:(NSString *)reqCode withType:(NSString *)type onCompletion:(void (^)(BOOL))completionHandler
{
    if ([reqCode isKindOfClass:[NSNull class]])
    {
        return;
    }
    if (reqCode.length == 0)
    {
        return;
    }
    [self setHeader];
    NSString *jsonString = [NSString stringWithFormat:@"{\"RequestCode\":\"%@\",\"RequestType\":\"User\",\"DocumentType\":\"%@\"}",reqCode,type];
    NSDictionary *parameter = @{@"request" : jsonString};
    NSString *URLString =  [NSString stringWithFormat:@"%@%@", baseUrl,uploadFile];
    [manager POST:URLString parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:imagePath]name:@"Files" error:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
       completionHandler(YES);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionHandler(NO);
    }];
}
-(void)setHeader{
    NSUserDefaults *defaultvalue=[NSUserDefaults standardUserDefaults];
    NSString *token= [defaultvalue valueForKey:@"X-access-Token"];
    int userIdInteger=[[defaultvalue valueForKey:@"Id"]intValue];
    NSString *userID=[@(userIdInteger) description];
    
    manager= [AFHTTPRequestOperationManager manager];
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestSerializer setValue:token forHTTPHeaderField:@"x-access-token"];
    [requestSerializer setValue:userID forHTTPHeaderField:@"x-uid"];
    manager.requestSerializer = requestSerializer;
}
@end