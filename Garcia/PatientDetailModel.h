#import <Foundation/Foundation.h>

@interface PatientDetailModel : NSObject
@property(strong,nonatomic)NSString *idValue;
@property(strong,nonatomic)NSString *code;
@property(strong,nonatomic)NSString *title;
@property(strong,nonatomic)NSString *updateCount;
@property(strong,nonatomic)NSArray *symptomTagCodes;
@property(strong,nonatomic)NSArray *biomagneticSittingResults;
@property(strong,nonatomic)NSArray *documentDetails;
@property(strong,nonatomic)NSString *treatmentDetail;
@property(strong,nonatomic)NSString *treatmentRequestDate;
@property(strong,nonatomic)NSString *IsTreatmentCompleted;

@end
