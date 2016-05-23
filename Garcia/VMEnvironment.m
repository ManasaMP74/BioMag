#import "VMEnvironment.h"

@implementation VMEnvironment
+(instancetype)environment {
    static VMEnvironment *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[VMEnvironment alloc] init];
    });
    return instance; }

-(instancetype)init
{ self = [super init];
    if (self != nil) {
        //examples. Use proper values here.
        NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"environment" ofType:@"plist"]];
        _environmentName = plist[@"environment"];
        _buildCommit     = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
        _baseurl       = plist[@"baseUrl"];
        _dbname       = plist[@"dbName"];
        _dbnameforResized       = plist[@"dbNameforResized"];
        _postmancompanycode       = plist[@"postmanCompanyCode"];
        _aboutus       = plist[@"aboutUs"];
        _faqurl       = plist[@"FAQurl"];
        _termsandcondition       = plist[@"termsAndCondition"];
        _privecyandpolicy       = plist[@"privecyAndPolicy"];
        _baseurlForaws = plist[@"baseUrlAws"];
        _apptypecode=plist[@"appTypeCode"];
         _applicablebasicversioncode=plist[@"applicableBasicVersionCode"];
         _applicableintermediateversionCode=plist[@"applicableIntermediateVersionCode"];
         _aboutuscode=plist[@"aboutUsCode"];
         _aboutusmodule=plist[@"aboutUsModule"];
        
    }
    return self;
}
@end
