#import <UIKit/UIKit.h>
#import "searchPatientModel.h"
@interface ContainerViewController : UIViewController
-(void)passDataFromsearchPatientTableViewToPatient:(searchPatientModel*)model;
-(void)ChangeTheContainerViewViewController;
-(void)pushTreatmentViewController:(NSString *)str;
@property(strong,nonatomic)NSString *viewControllerDiffer;
-(void)callEndEditing;
@end
