#import "LanguageChanger.h"
#import "Postman.h"
#import "PostmanConstant.h"
#import "MBProgressHUD.h"
#import <MCLocalization/MCLocalization.h>
@implementation LanguageChanger
{
    NSUserDefaults *userDefault;
    NSFileManager *fileManager;
    NSMutableDictionary *jsonDictionary;
}



-(void)callApiForLanguage
{
    userDefault=[NSUserDefaults standardUserDefaults];
    NSString *languageCode=[userDefault valueForKey:@"languageCode"];
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
        str=[str stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",dict1[@"Name"],dict1[@"Value"]]];
        if (![dict1 isEqualToDictionary:[genericArray lastObject]]) {
            str=[str stringByAppendingString:@","];
        }else
            str=[str stringByAppendingString:@"}"];
        }
    }
    NSString *languageCode=[userDefault valueForKey:@"languageCode"];
    [self createFolderandSaveaStringInDocuDirectory:languageCode withContent:str];
}

-(void)createFolderandSaveaStringInDocuDirectory:(NSString*)languageCode withContent:(NSString *)content{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask , YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];
    NSString *path=[documentsDirectory stringByAppendingPathComponent:@"Language"];
    NSError *error;
   fileManager =[[NSFileManager alloc]init];
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error];
    }
    NSString *filePath=[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json",languageCode]];
    if (![fileManager fileExistsAtPath:filePath]) {
        NSData *data=[content dataUsingEncoding:NSUTF8StringEncoding];
        [fileManager createFileAtPath:filePath contents:data attributes:nil];
    }
 [self readingLanguageFromDocument];
}


-(void)readingLanguageFromDocument
{
    jsonDictionary=[[NSMutableDictionary alloc]init];
   userDefault=[NSUserDefaults standardUserDefaults];
    NSString *langCode=[userDefault valueForKey:@"languageCode"];
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *docPath=[path stringByAppendingPathComponent:@"Language"];
    
    NSArray *allfiles=[fileManager contentsOfDirectoryAtPath:docPath error:nil];
    NSPredicate *filter=[NSPredicate predicateWithFormat:@"self ENDSWITH'.json'"];
    NSArray *jsonFiles = [allfiles filteredArrayUsingPredicate:filter];
    NSString *name=nil;
    
    for (NSString *jsonFile in jsonFiles) {
        NSString *filename=[docPath stringByAppendingPathComponent:jsonFile];
        name=[jsonFile stringByDeletingPathExtension];
        NSURL *filePathUrl = [NSURL fileURLWithPath:filename];
        [jsonDictionary setObject:filePathUrl forKey:name];
    }
 
    [MCLocalization loadFromLanguageURLPairs:jsonDictionary defaultLanguage:@"en"];
    
    [MCLocalization sharedInstance].noKeyPlaceholder = @"[No '{key}' in '{language}']";
    
    [MCLocalization sharedInstance].language = langCode;
    
//    NSString *filepath=[docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json",langCode]];
//    if ([fileManager fileExistsAtPath:filepath]) {
//        NSError *error;
//        NSString *content=[NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
//        NSLog(@"%@",content);
//    }
    
}
@end
