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
    UIButton *addButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0,130, 30)];
    [addButton addTarget:self action:@selector(pushAddPatientSheetVC) forControlEvents:UIControlEventTouchUpInside];
    [addButton setBackgroundImage:[UIImage imageNamed:@"Button-Add-Patient-1"] forState:normal];
    [addButton setTitle:@"Add Patient" forState:normal];
    addButton.titleLabel.font=[UIFont systemFontOfSize:13];
    [addButton setContentEdgeInsets:UIEdgeInsetsMake(0,-20,0,0)];
    [addButton setTitleColor:[UIColor colorWithRed:0.082 green:0.706 blue:0.941 alpha:1] forState:normal];
  UIBarButtonItem *leftbarbutton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(popToViewController)];
    UIBarButtonItem *rightbarbutton=[[UIBarButtonItem alloc]initWithCustomView:addButton];
    self.navigationItem.leftBarButtonItem=leftbarbutton;
    self.navigationItem.rightBarButtonItem=rightbarbutton;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
//pop back
-(void)popToViewController{
    [self.navigationController popViewControllerAnimated:YES];
}
//push Add Patient ViewController
-(void)pushAddPatientSheetVC{
    AddPatientViewController *addpatientVC=[self.storyboard instantiateViewControllerWithIdentifier:@"AddPatientViewController"];
    [self.navigationController pushViewController:addpatientVC animated:YES];
}
//push Patient Sheet ViewController
-(void)pushPatientSheetVC{
    PatientSheetViewController *patientSheet=[self.storyboard instantiateViewControllerWithIdentifier:@"PatientSheetViewController"];
     [self.navigationController pushViewController:patientSheet animated:YES];
}
//pass data from one viewController to another
-(void)passDataFromsearchPatientTableViewToPatient:(NSString *)str{
    UINavigationController * nav=[self.childViewControllers lastObject];
    PatientViewController *patientVc=nav.viewControllers[0];
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
