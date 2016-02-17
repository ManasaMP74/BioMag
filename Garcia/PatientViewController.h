#import <UIKit/UIKit.h>
#import "searchPatientModel.h"
@interface PatientViewController : UIViewController
@property(strong,nonatomic)searchPatientModel *model;
-(void)setDefaultValues;
@property (weak, nonatomic) IBOutlet UIControl *alphaViewToShowLanguage;
@property (weak, nonatomic) IBOutlet UITableView *popTableView;
@property (weak, nonatomic) IBOutlet UIView *patientDetailView;
@end
