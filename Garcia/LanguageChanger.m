#import "LanguageChanger.h"
#import "Postman.h"
#import "PostmanConstant.h"
#import "MBProgressHUD.h"
@implementation LanguageChanger






-(void)callApiForLanguage:(NSString*)languageCode
{
    Postman *postman=[[Postman alloc]init];
     if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
    NSString *url=[NSString stringWithFormat:@"%@%@%@",baseUrl,languageUILabel,languageCode];
    NSString *parameter=[NSString stringWithFormat:@"{request:{}}"];
    [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self responseofLanguageAPI:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    }
    
    


}

-(void)readingLanguageFromDocument:(NSString*)languageCode
{
   


}

-(void)responseofLanguageAPI:(id)responseObject{
    NSDictionary *dict;
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        NSDictionary *dict1=responseObject;
        dict=dict1[@"aaData"];
    }else   dict=responseObject;
    NSArray *genericArray=dict[@"GenericSearchViewModels"];
    NSString *str=@"{";
    for (NSDictionary *dict1 in genericArray) {
        if ([dict1[@"Status"]intValue]==1) {
        str=[str stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",dict1[@"Value"],dict1[@"Name"]]];
        if (![dict1 isEqualToDictionary:[genericArray lastObject]]) {
            str=[str stringByAppendingString:@","];
        }else   str=[str stringByAppendingString:@"}"];
      }
    }
}


@end
