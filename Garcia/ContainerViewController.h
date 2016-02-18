#import <UIKit/UIKit.h>
#import "searchPatientModel.h"
#import "searchPatientModel.h"
#import "PatientTitleModel.h"
@protocol loadTreatmentDelegateInContainer <NSObject>
@optional
-(void)loadTreatment;
-(void)getThePopOverForLanguage:(NSArray*)popOverArray;
-(void)getThePopOverForslideout;
@end


@interface ContainerViewController : UIViewController
-(void)passDataFromsearchPatientTableViewToPatient:(searchPatientModel*)model;
-(void)ChangeTheContainerViewViewController;
-(void)pushTreatmentViewController:(PatientTitleModel *)model;
@property(strong,nonatomic)NSString *viewControllerDiffer;
-(void)callEndEditing;
-(void)successfullyAdded:(NSString *)code;
@property(strong,nonatomic)searchPatientModel *model;
-(void)successfullyEdit:(NSString *)code;
-(void)showMBprogressTillLoadThedata;
-(void)hideMBprogressTillLoadThedata;
-(void)hideAllMBprogressTillLoadThedata;
@property(weak,nonatomic)id<loadTreatmentDelegateInContainer>delegate;
-(void)callForNavigationButton:(NSString*)str;
@end
