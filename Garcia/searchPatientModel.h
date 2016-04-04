#import <Foundation/Foundation.h>
#import "ProfileImageModel.h"
#import <UIKit/UIKit.h>
#import "VMEnvironment.h"
@interface searchPatientModel : NSObject
@property(strong,nonatomic)NSString *address;
@property(strong,nonatomic)NSString *addressLine1;
@property(strong,nonatomic)NSString *emailId;
@property(strong,nonatomic)NSString *dob;
@property(strong,nonatomic)NSString *name;
@property(strong,nonatomic)NSString *age;
@property(strong,nonatomic)NSString *maritialStatus;
@property(strong,nonatomic)NSString *gender;
@property(strong,nonatomic)NSString *Id;
@property(strong,nonatomic)NSString *code;
@property(strong,nonatomic)NSString *mobileNo;
@property(strong,nonatomic)NSString *state;
@property(strong,nonatomic)NSString *country;
@property(strong,nonatomic)NSString *city;
@property(strong,nonatomic)NSString *pinCode;
@property(strong,nonatomic)NSString *addressline2;
-(void)getJsonDataForGender:(NSString *)code
        onComplete:(void (^)(NSString *genderName))successBlock
           onError:(void (^)(NSError *error))errorBlock;
-(void)getJsonDataForMartial:(NSString *)code
                 onComplete:(void (^)(NSString *martialStatus))successBlock
                    onError:(void (^)(NSError *error))errorBlock;
@property(strong,nonatomic)NSString *genderCode;
@property(strong,nonatomic)NSString *martialCode;
@property(strong,nonatomic)NSDictionary *jsonDict;
@property(strong,nonatomic)NSString *memo;
@property(strong,nonatomic)NSString *companyCode;
@property(strong,nonatomic)NSString *userTypeCode;
@property(strong,nonatomic)NSString *roleCode;
@property(strong,nonatomic)NSString *password;
@property(strong,nonatomic)NSString *userID;
@property(strong,nonatomic)NSString *documentCode;
@property(strong,nonatomic)NSString *documentTypeCode;
@property(strong,nonatomic)NSString *profileImageCode;
@property(strong,nonatomic)NSString *tranfusion;
@property(strong,nonatomic)NSString *surgeries;
@property(strong,nonatomic)UIImage *profileImage;
@property(strong,nonatomic)UIImage *storageID;
@property(strong,nonatomic)NSString *fileName;
@end
