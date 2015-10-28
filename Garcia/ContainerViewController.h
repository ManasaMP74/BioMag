#import <UIKit/UIKit.h>

@interface ContainerViewController : UIViewController
-(void)passDataFromsearchPatientTableViewToPatient:(NSString*)str;
-(void)ChangeTheContainerViewViewController;
-(void)pushTreatmentViewController;
@property(strong,nonatomic)NSString *viewControllerDiffer;
@end
