#import "ContainerViewController.h"
#import "PatientViewController.h"
#import "AddPatientViewController.h"
#import "PatientSheetViewController.h"
#import "SearchPatientViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "PopOverViewController.h"
#import <WYPopoverController/WYPopoverController.h>
@interface ContainerViewController ()<addedPatient,loadTreatmentDelegate,selectedObjectInPop,WYPopoverControllerDelegate>

@end

@implementation ContainerViewController
{
    NSString *patientName;
    WYPopoverController *wypopOverController;
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
    
    
    CGRect lagFrameimg = CGRectMake(30, 0,95,25);
    UIButton *lagSomeButton = [[UIButton alloc] initWithFrame:lagFrameimg];
    lagSomeButton.backgroundColor=[UIColor whiteColor];
    lagSomeButton.layer.cornerRadius=13;
    [lagSomeButton setTitle:@"" forState:normal];
    UIImage* image = [UIImage imageNamed:@"Language-Icon.jpg"];
    CGRect frameimg1 = CGRectMake(85-image.size.width,5,15, 15);
    UIImageView *imview=[[UIImageView alloc]initWithFrame:frameimg1];
    imview.image=image;
    [lagSomeButton addSubview:imview];
    [lagSomeButton addTarget:self action:@selector(languageChange:) forControlEvents:UIControlEventTouchUpInside];
    [lagSomeButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *lagButton =[[UIBarButtonItem alloc] initWithCustomView:lagSomeButton];
    
    self.navigationItem.rightBarButtonItems=@[mailbutton,lagButton];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
//pop back
-(void)popToViewController{
    [self.navigationController popViewControllerAnimated:YES];
}
//LanguageChange
-(IBAction)languageChange:(id)sender{
    UIView *btn = (UIView *)sender;
    if (wypopOverController==nil){
    PopOverViewController *pop=[self.storyboard instantiateViewControllerWithIdentifier:@"PopOverViewController"];
        pop.delegate=self;
        wypopOverController=[[WYPopoverController alloc]initWithContentViewController:pop];
        wypopOverController.delegate=self;
        wypopOverController.passthroughViews = @[btn];
        wypopOverController.theme=[WYPopoverTheme themeForIOS6];
        wypopOverController.theme.outerCornerRadius=2;
        wypopOverController.theme.outerStrokeColor=[UIColor lightGrayColor];
        wypopOverController.theme.arrowHeight = 8;
        
        wypopOverController.theme.arrowBase= 15;
        
        wypopOverController.theme.fillTopColor = [UIColor grayColor];
        CGFloat height=[pop getHeightOfTableView];
        CGSize contentSize = CGSizeMake(200,height);
        pop.preferredContentSize=contentSize;
        wypopOverController.theme.overlayColor= [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        CGRect biggerBounds = CGRectInset(btn.bounds, -6, -6);
        [wypopOverController presentPopoverFromRect:biggerBounds inView:sender permittedArrowDirections:(WYPopoverArrowDirectionUp) animated:YES options:(WYPopoverAnimationOptionFadeWithScale)];
    }else
        
    {
        [wypopOverController dismissPopoverAnimated:YES completion:^{
            wypopOverController.delegate = nil;
            wypopOverController = nil;
        }];
        
    }
}
-(void)selectedObject{
  [wypopOverController dismissPopoverAnimated:NO];

}
-(BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)popoverController

{
    return YES;
}

-(void)popoverControllerDidDismissPopover:(WYPopoverController *)popoverController

{
    wypopOverController.delegate=nil;
    wypopOverController=nil;
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
-(void)pushTreatmentViewController:(PatientTitleModel *)model{
    PatientSheetViewController *patientSheet=[self.storyboard instantiateViewControllerWithIdentifier:@"PatientSheetViewController"];
    patientSheet.model=_model;
    patientSheet.patientTitleModel=model;
    patientSheet.delegate=self;
    [self.navigationController pushViewController:patientSheet animated:YES];
}
//callEndEditing
-(void)callEndEditing{
    SearchPatientViewController *searchVC=self.childViewControllers[0];
    [searchVC hideKeyBoard];
}
//Method Successfully Added
-(void)successfullyAdded:(NSString *)code{
 SearchPatientViewController *searchVC=[self.childViewControllers firstObject];
    [searchVC againCallApiAfterAddPatient:code];
}
//Method Successfully Edit
-(void)successfullyEdit:(NSString *)code{
    SearchPatientViewController *searchVC=[self.childViewControllers firstObject];
    [searchVC againCallApiAfterEditPatient:code];
}
//Show (NSString *)code
-(void)showMBprogressTillLoadThedata{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
//hide mbprogress
-(void)hideMBprogressTillLoadThedata{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
//hide mbprogress
-(void)hideAllMBprogressTillLoadThedata{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
//Load TreatmentList in PatientVC
-(void)loadTreatment{
    SearchPatientViewController *searchVC=[self.childViewControllers firstObject];
    [searchVC reloadTableviewAfterAddNewTreatment];
}
@end
