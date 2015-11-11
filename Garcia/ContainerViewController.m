#import "ContainerViewController.h"
#import "PatientViewController.h"
#import "AddPatientViewController.h"
#import "PatientSheetViewController.h"
#import "SearchPatientViewController.h"
@interface ContainerViewController ()<addedPatient>

@end

@implementation ContainerViewController
{
    NSString *patientName;
}
- (void)viewDidLoad {
    [super viewDidLoad];
      self.navigationController.navigationBarHidden=NO;
    self.navigationItem.hidesBackButton = YES;
    
    UIImage* image3 = [UIImage imageNamed:@"Icon-Signout.png"];
    CGRect frameimg = CGRectMake(0, 0, image3.size.width, image3.size.height);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(popToViewController) forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.navigationItem.rightBarButtonItem=mailbutton;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
//pop back
-(void)popToViewController{
    [self.navigationController popViewControllerAnimated:YES];
}
//pass data from one viewController to another
-(void)passDataFromsearchPatientTableViewToPatient:(searchPatientModel*)model{
    if ([_viewControllerDiffer isEqualToString:@""]) {
        UINavigationController * nav=[self.childViewControllers lastObject];
        PatientViewController *patientVc=nav.viewControllers[0];
        [nav popToViewController:patientVc animated:YES];
        patientVc.model =model;
        [patientVc setDefaultValues];
    }
}
//Change the UiviewController
-(void)ChangeTheContainerViewViewController{
    UINavigationController * nav=[self.childViewControllers lastObject];
    AddPatientViewController *addPatientVc=[self.storyboard instantiateViewControllerWithIdentifier:@"AddPatientViewController"];
    addPatientVc.delegate=self;
    [nav initWithRootViewController:addPatientVc];
}
//push treatmentViewController
-(void)pushTreatmentViewController:(NSString *)str{
    PatientSheetViewController *patientSheet=[self.storyboard instantiateViewControllerWithIdentifier:@"PatientSheetViewController"];
    patientSheet.TitleName=str;
    [self.navigationController pushViewController:patientSheet animated:YES];
}
//callEndEditing
-(void)callEndEditing{
    SearchPatientViewController *searchVC=self.childViewControllers[0];
    [searchVC hideKeyBoard];
}
-(void)successfullyAdded{
 SearchPatientViewController *searchVC=[self.childViewControllers firstObject];
    [searchVC againCallApiAfterAddPatient];
}
@end
