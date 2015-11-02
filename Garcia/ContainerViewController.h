#import <UIKit/UIKit.h>

@interface ContainerViewController : UIViewController
-(void)passDataFromsearchPatientTableViewToPatient:(NSString*)str;
-(void)ChangeTheContainerViewViewController;
-(void)pushTreatmentViewController:(NSString *)str;
@property(strong,nonatomic)NSString *viewControllerDiffer;
-(void)callEndEditing;
@end
