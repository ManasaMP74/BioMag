#import <Foundation/Foundation.h>

@interface searchPatientModel : NSObject
@property(strong,nonatomic)NSString *address;
@property(strong,nonatomic)NSString *emailId;
@property(strong,nonatomic)NSString *dob;
@property(strong,nonatomic)NSString *name;
@property(strong,nonatomic)NSString *age;
@property(strong,nonatomic)NSString *maritialStatus;
@property(strong,nonatomic)NSString *gender;
@property(strong,nonatomic)NSString *Id;
@property(strong,nonatomic)NSString *code;
@property(strong,nonatomic)NSString *mobileNo;
-(void)getJsonDataForGender:(NSString *)code
        onComplete:(void (^)(NSString *genderName))successBlock
           onError:(void (^)(NSError *error))errorBlock;
-(void)getJsonDataForMartial:(NSString *)code
                 onComplete:(void (^)(NSString *martialStatus))successBlock
                    onError:(void (^)(NSError *error))errorBlock;
@property(strong,nonatomic)NSString *genderCode;
@property(strong,nonatomic)NSString *martialCode;
@end
