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
   
    NSString *token=@"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ2IjowLCJpYXQiOjE0NDg0MjY2NzUsImQiOnsidWlkIjozMDA0MiwiRmlyc3ROYW1lIjoiTHVpcyIsIkVtYWlsIjoiZHJsdWlzZ2FyY2lhQG15ZG9tYWluLmNvbSJ9LCJleHAiOjE0NDg0MzAyNzUsIm5iZiI6MTQ0ODQyNjY3NSwiZGVidWciOnRydWV9.drqd8Pqtm9ItVsYMJa2igubTUojPSvZHSQ1hfQk00kI";
    
    
    self.manager=[AFHTTPRequestOperationManager manager];
    AFJSONRequestSerializer *requestSerializer=[AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestSerializer setValue:token forHTTPHeaderField:@"x-access-token"];
    self.manager.requestSerializer=requestSerializer;
}
//post method
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
//put method
- (void)put:(NSString *)URLString withParameters:(NSString *)parameter success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSDictionary *parameterDict=[NSJSONSerialization JSONObjectWithData:[parameter dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    [self.manager PUT:URLString parameters:parameterDict success:^(AFHTTPRequestOperation *operation,id responseObject) {
        success(operation, responseObject);
    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        failure(operation,error);
    }];
}
//get data
- (void)get:(NSString *)URLString withParameters:(NSString *)parameter success:(void(^)(AFHTTPRequestOperation *operation,id responseObject))success failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self.manager GET:URLString parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject)
     {
         success(operation,responseObject);
         
     }failure:^(AFHTTPRequestOperation *operation,NSError *error){
         
         failure(operation,error);
         NSLog(@"%@",error);
     }];
}
@end
