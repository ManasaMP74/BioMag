#import "ContainerViewController.h"
#import "AddPatientViewController.h"
#import "PatientSheetViewController.h"
@interface ContainerViewController ()

@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      self.navigationController.navigationBarHidden=NO;
    self.navigationItem.hidesBackButton = YES;
    UIButton *addButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0,130, 30)];
    [addButton addTarget:self action:@selector(pushAddPatientSheetVC) forControlEvents:UIControlEventTouchUpInside];
    [addButton setImage:[UIImage imageNamed:@"Button-Add-Patient"] forState:normal];
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
@end
