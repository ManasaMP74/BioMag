#import "ImageUploadAPI.h"
#import "Postman.h"
#import "PostmanConstant.h"
#import <AFNetworking/AFNetworking.h>

@implementation ImageUploadAPI
{
    Postman *postman;
    NSString *_imagePath;
    NSString *_pathToDoc;
}
//get image
- (void)uploadUserImagePath:(NSString *)imagePath forRequestCode:(NSString *)reqCode withDocumentType:(NSString*)docType onCompletion:(void (^)(BOOL))completionHandler
{
    [self uploadImagePath:imagePath forRequestCode:reqCode withType:@"User"  withDocumentType:docType onCompletion:completionHandler];
}
//post image
- (void)uploadImagePath:(NSString *)imagePath forRequestCode:(NSString *)reqCode withType:(NSString *)type withDocumentType:(NSString*)docType onCompletion:(void (^)(BOOL))completionHandler
{
    if ([reqCode isKindOfClass:[NSNull class]])
    {
        return;
    }
    if (reqCode.length == 0)
    {
        return;
    }
    _imagePath = imagePath;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
   [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestSerializer setValue:@"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ2IjowLCJpYXQiOjE0NDg0MjY2NzUsImQiOnsidWlkIjozMDA0MiwiRmlyc3ROYW1lIjoiTHVpcyIsIkVtYWlsIjoiZHJsdWlzZ2FyY2lhQG15ZG9tYWluLmNvbSJ9LCJleHAiOjE0NDg0MzAyNzUsIm5iZiI6MTQ0ODQyNjY3NSwiZGVidWciOnRydWV9.drqd8Pqtm9ItVsYMJa2igubTUojPSvZHSQ1hfQk00kI" forHTTPHeaderField:@"x-access-token"];
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"multipart/form-data"];
    
    NSString *jsonString = [NSString stringWithFormat:@"{\"RequestCode\":\"%@\",\"RequestType\":\"%@\",\"DocumentType\":\"%@\"}", reqCode, type,docType];
    NSDictionary *parameter = @{@"request" : jsonString};
    NSString *URLString = [NSString stringWithFormat:@"%@%@", baseUrl, uploadFile];
    [manager POST:URLString parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSError *error;
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:imagePath]
                                   name:@"Files"
                                  error:&error];
        NSLog(@"Error  formadata %@", error);
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Success %@", operation.responseString);
        [self  parseData:responseObject withHandler:completionHandler];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error %@ \n  Response %@", error, operation.responseString);
        completionHandler(NO);
    }];
}
- (void)parseData:(id)response withHandler:(void (^)(BOOL))completionHandler
{
    NSDictionary *dict = response;
    if ([dict[@"Success"] intValue]==1)
    {
        completionHandler(YES);
    }else
    {
        completionHandler(NO);
    }
}
@end
