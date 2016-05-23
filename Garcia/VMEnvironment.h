#import <Foundation/Foundation.h>

#define baseUrl [VMEnvironment environment].baseurl
#define dbName [VMEnvironment environment].dbname
#define dbNameforResized [VMEnvironment environment].dbnameforResized
#define postmanCompanyCode [VMEnvironment environment].postmancompanycode
#define aboutUs [VMEnvironment environment].aboutus
#define FAQurl [VMEnvironment environment].faqurl
#define termsAndCondition [VMEnvironment environment].termsandcondition
#define privecyAndPolicy [VMEnvironment environment].privecyandpolicy
#define baseUrlAws [VMEnvironment environment].baseurlForaws
#define appTypeCode [VMEnvironment environment].apptypecode
#define applicableBasicVersionCode [VMEnvironment environment].applicablebasicversioncode
#define applicableIntermediateVersionCode [VMEnvironment environment].applicableintermediateversionCode
#define aboutUsCode [VMEnvironment environment].aboutuscode

@interface VMEnvironment : NSObject
@property(nonatomic,strong)NSString *environmentName;
@property(nonatomic,strong)NSString *buildCommit;
@property(nonatomic,strong)NSString *baseurl;
@property(nonatomic,strong)NSString *dbname;
@property(nonatomic,strong)NSString *dbnameforResized;
@property(nonatomic,strong)NSString *postmancompanycode;
@property(nonatomic,strong)NSString *aboutus;
@property(nonatomic,strong)NSString *faqurl;
@property(nonatomic,strong)NSString *termsandcondition;
@property(nonatomic,strong)NSString *privecyandpolicy;
@property(nonatomic,strong)NSString *baseurlForaws;
@property(nonatomic,strong)NSString *apptypecode;
@property(nonatomic,strong)NSString *applicablebasicversioncode;
@property(nonatomic,strong)NSString *applicableintermediateversionCode;
@property(nonatomic,strong)NSString *aboutuscode;

+(instancetype)environment;
@end
