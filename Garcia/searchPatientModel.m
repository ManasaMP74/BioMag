#import "searchPatientModel.h"
#import "MBProgressHUD.h"
#import "Postman.h"
#import "PostmanConstant.h"
@implementation searchPatientModel
{
    Postman *postman;
}
-(void)getJsonDataForGender:(NSString *)code
        onComplete:(void (^)(NSString *genderName))successBlock
           onError:(void (^)(NSError *error))errorBlock {
    postman =[[Postman alloc]init];
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,getGender];
    [postman get:url withParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
       NSString *name =[self prcessGenderObject:code withResponseObject:responseObject];
        successBlock(name);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          errorBlock(error);
    }];
}
-(NSString*)prcessGenderObject:(NSString*)code withResponseObject:(id)responseObject{
    NSDictionary *dict=responseObject;
    NSString *genderName;
    for (NSDictionary *dict1 in dict[@"GenericSearchViewModels"]) {
        if (dict1[@"Status"]) {
            if ([code isEqualToString:dict1[@"Code"]]) {
               genderName= dict1[@"Name"];
            }
        }
    }
    return genderName;
}
-(void)getJsonDataForMartial:(NSString *)code
                  onComplete:(void (^)(NSString *martialStatus))successBlock
                     onError:(void (^)(NSError *error))errorBlock{

    postman =[[Postman alloc]init];
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,getMartialStatus];
    [postman get:url withParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *name =[self prcessMartialObject:code withResponseObject:responseObject];
        successBlock(name);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
    }];
}
-(NSString*)prcessMartialObject:(NSString*)code withResponseObject:(id)responseObject{
    NSDictionary *dict=responseObject;
    NSString *martial;
    for (NSDictionary *dict1 in dict[@"GenericSearchViewModels"]) {
        if (dict1[@"Status"]) {
            if ([code isEqualToString:dict1[@"Code"]]) {
                martial= dict1[@"Name"];
            }
        }
    }
    return martial;
}
@end
