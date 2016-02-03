#import <UIKit/UIKit.h>
#import "searchPatientModel.h"
@interface PatientViewController : UIViewController
@property(strong,nonatomic)searchPatientModel *model;
-(void)setDefaultValues;
@end
