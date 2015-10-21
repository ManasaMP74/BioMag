#import "ContainerViewController.h"
#import "AddPatientViewController.h"
#import "PatientSheetViewController.h"
#import "SearchPatientViewController.h"
#import "PatientViewController.h"
#import "AddPatientViewController.h"
@interface ContainerViewController ()

@end

@implementation ContainerViewController
{
    NSString *patientName;
}
- (void)viewDidLoad {
    [super viewDidLoad];
      self.navigationController.navigationBarHidden=NO;
    self.navigationItem.hidesBackButton = YES;
  UIBarButtonItem *leftbarbutton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(popToViewController)];
    self.navigationItem.leftBarButtonItem=leftbarbutton;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
//pop back
-(void)popToViewController{
    [self.navigationController popViewControllerAnimated:YES];
}
//pass data from one viewController to another
-(void)passDataFromsearchPatientTableViewToPatient:(NSString *)str{
    UINavigationController * nav=[self.childViewControllers lastObject];
    PatientViewController *patientVc=nav.viewControllers[0];
    [nav popViewControllerAnimated:YES];
    patientVc.patientName = str;
    [patientVc setDefaultValues];
}
//Change the UiviewController
-(void)ChangeTheContainerViewViewController{
    UINavigationController * nav=[self.childViewControllers lastObject];
    AddPatientViewController *addPatientVc=[self.storyboard instantiateViewControllerWithIdentifier:@"AddPatientViewController"];
    [nav initWithRootViewController:addPatientVc];
}
@end
