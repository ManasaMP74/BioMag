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
        _baseUrl       = plist[@"baseUrl"];
        _dbName       = plist[@"dbName"];
        _dbNameforResized       = plist[@"dbNameforResized"];
        _postmanCompanyCode       = plist[@"postmanCompanyCode"];
        _aboutUs       = plist[@"aboutUs"];
        _FAQUrl       = plist[@"FAQurl"];
        _termsandCondition       = plist[@"termsAndCondition"];
        _privecyandPolicy       = plist[@"privecyAndPolicy"];
    }
    return self;
}
@end
