#import "Postman.h"
@implementation Postman
-(id)init
{
    if(self=[super init])
    {
        [self initiate];
    }
    return self;
}
-(void)initiate

{
    self.manager=[AFHTTPRequestOperationManager manager];
    AFJSONRequestSerializer *requestSerializer=[AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestSerializer setValue:@"x-access-token" forHTTPHeaderField:@"x-access-token"];
    self.manager.requestSerializer=requestSerializer;
}
- (void)post:(NSString *)URLString withParameters:(NSString *)parameter success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSDictionary *parameterDict = [NSJSONSerialization JSONObjectWithData:[parameter dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    [self.manager POST:URLString parameters:parameterDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(operation, responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        failure(operation,error);
        NSLog(@"Error");
    }];
}
- (void)put:(NSString *)URLString withParameters:(NSString *)parameter success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSDictionary *parameterDict=[NSJSONSerialization JSONObjectWithData:[parameter dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    [self.manager PUT:URLString parameters:parameterDict success:^(AFHTTPRequestOperation *operation,id responseObject) {
        success(operation, responseObject);
    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        failure(operation,error);
    }];
}
- (void)get:(NSString *)URLString withParameters:(NSString *)parameter success:(void(^)(AFHTTPRequestOperation *operation,id responseObject))success failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self.manager GET:URLString parameters:parameter success:^(AFHTTPRequestOperation *operation,id responseObject)
     {
         success(operation,responseObject);
         
     }failure:^(AFHTTPRequestOperation *operation,NSError *error){
         
         failure(operation,error);
         NSLog(@"%@",error);
     }];
}
@end
