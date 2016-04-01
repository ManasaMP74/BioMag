#import <Foundation/Foundation.h>

//#define BASE_URL [VMEnvironment environment].baseUrl

@interface VMEnvironment : NSObject
@property(nonatomic,strong)NSString *environmentName;
@property(nonatomic,strong)NSString *buildCommit;
@property(nonatomic,strong)NSString *baseUrl;
@property(nonatomic,strong)NSString *dbName;
@property(nonatomic,strong)NSString *dbNameforResized;
@property(nonatomic,strong)NSString *postmanCompanyCode;
@property(nonatomic,strong)NSString *aboutUs;
@property(nonatomic,strong)NSString *FAQUrl;
@property(nonatomic,strong)NSString *termsandCondition;
@property(nonatomic,strong)NSString *privecyandPolicy;


+(instancetype)environment;
@end
