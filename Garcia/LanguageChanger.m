#import "LanguageChanger.h"
#import "Postman.h"
#import "PostmanConstant.h"
#import "MBProgressHUD.h"
#import <MCLocalization/MCLocalization.h>
@implementation LanguageChanger
{
    NSFileManager *fileManager;
    NSMutableDictionary *jsonDictionary;
    NSUserDefaults *userdefault;
     Postman *postman;
    NSString *successMessage;
}
//Call PreferredLanguage
-(void)callApiForPreferredLanguage{
    NSString *urlString;
    NSString *parameter;
    
    postman=[[Postman alloc]init];
    userdefault=[NSUserDefaults standardUserDefaults];
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        //Vzone API
        urlString = [NSString stringWithFormat:@"%@%@",baseUrl,preferredLanguage];
        NSString *userId=[userdefault valueForKey:@"Id"];
        NSString *languageCode=[userdefault valueForKey:@"changedLanguageCode"];
        parameter = [NSString stringWithFormat:@"{\"request\":{\"MethodType\":\"PUT\",\"UserID\": \"1\",\"PreferredLanguageCode\": \"%@\",\"Id\": %@}}",languageCode,userId];
    }else{
        //Material Api
        
    }
    [postman put:urlString withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processResponseOfPreferredLanguage:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate languageChangeDelegate:0];
    }];
    
}
//process preferredLanguage
-(void)processResponseOfPreferredLanguage:(id)responseObject{
    NSDictionary *dict;
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        NSDictionary *dict1=responseObject;
        dict=dict1[@"aaData"];
    }
    if ([dict[@"Success"]intValue]==1) {
        [self callApiForUILabelLanguage];
    }
}

-(void)callApiForUILabelLanguage
{
     postman=[[Postman alloc]init];
     userdefault=[NSUserDefaults standardUserDefaults];
    NSString *languageCode=[userdefault valueForKey:@"languageCode"];
     if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
    NSString *url=[NSString stringWithFormat:@"%@%@%@",baseUrl,languageUILabel,languageCode];
         NSString *parameter=[NSString stringWithFormat:@"{\"\"}"];
    [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
      [self responseofLanguageAPI:responseObject];
        [self.delegate languageChangeDelegate:1];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     [self.delegate languageChangeDelegate:0];
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
    NSString *languageCode=[userdefault valueForKey:@"languageCode"];
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
//    if ([fileManager fileExistsAtPath:filePath]) {
        NSData *data=[content dataUsingEncoding:NSUTF8StringEncoding];
        [fileManager createFileAtPath:filePath contents:data attributes:nil];
//    }
}


-(void)readingLanguageFromDocument
{
    fileManager =[[NSFileManager alloc]init];
    jsonDictionary=[[NSMutableDictionary alloc]init];
    NSString *langCode=[userdefault valueForKey:@"languageCode"];
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
