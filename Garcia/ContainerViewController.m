#import "ContainerViewController.h"
#import "PatientViewController.h"
#import "AddPatientViewController.h"
#import "PatientSheetViewController.h"
#import "SearchPatientViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "PopOverViewController.h"
#import <WYPopoverController/WYPopoverController.h>
#import "Postman.h"
#import "MBProgressHUD.h"
#import "PostmanConstant.h"
#import "lagModel.h"
#import "SeedSyncer.h"
#import "LanguageChanger.h"
#if !defined(MAX)
#define MAX(A,B)((A) > (B) ? (A) : (B))
#endif
@interface ContainerViewController ()<addedPatient,loadTreatmentDelegate,selectedObjectInPop,WYPopoverControllerDelegate>

@end

@implementation ContainerViewController
{
    NSMutableArray *languageArray;
    Postman *postman;
    NSString *patientName;
    WYPopoverController *wypopOverController;
    UIButton *lagSomeButton;
    NSArray *slideoutArray;
    NSArray *slideoutImageArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
      self.navigationController.navigationBarHidden=NO;
    self.navigationItem.hidesBackButton = YES;
    languageArray =[[NSMutableArray alloc]init];
    postman=[[Postman alloc]init];
    [self callSeed];
    slideoutArray=@[@"About Us",@"FAQ",@"Terms and Conditions",@"Privacy and Policy",@"Logout"];
    slideoutImageArray=@[@"07-User.png",@"Icon-About.png",@"Icon-Faq.png",@"Icon-Terms.png",@"Icon-Privacy.png",@"Icon-Logout.png"];
    
    
    
    UIImage* image3 = [UIImage imageNamed:@"06-Icon-Navigation.png"];
    CGRect frameimg = CGRectMake(0, 0, image3.size.width, image3.size.height);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(slideout:) forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    
    
    CGRect lagFrameimg = CGRectMake(30,0,95,25);
    lagSomeButton= [[UIButton alloc] initWithFrame:lagFrameimg];
    lagSomeButton.backgroundColor=[UIColor whiteColor];
    lagSomeButton.layer.cornerRadius=13;
    NSUserDefaults *standardDefault=[NSUserDefaults standardUserDefaults];
    [standardDefault setValue:@"English" forKey:@"languageName"];
    [lagSomeButton setTitle:[standardDefault valueForKey:@"languageName"] forState:normal];
    [lagSomeButton setTitleColor:[UIColor blackColor] forState:normal];
    lagSomeButton.titleLabel.font=[UIFont fontWithName:@"OpenSansSemibold" size:10];
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
        pop.buttonName=@"language";
        pop.lagArray=languageArray;
        CGFloat finalWidth =0.0;
        for (lagModel *str in languageArray) {
            CGFloat width =  [str.name boundingRectWithSize:(CGSizeMake(NSIntegerMax,40)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:15]} context:nil].size.width;
            finalWidth=MAX(finalWidth, width);
        }
        [self wypopOver:btn withPopOver:pop];
        CGFloat height=[pop getHeightOfTableView];
        CGSize contentSize = CGSizeMake(finalWidth+50,height);
        pop.preferredContentSize=contentSize;
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
//slide out
-(IBAction)slideout:(id)sender{
    UIView *btn = (UIView *)sender;
    if (wypopOverController==nil){
        PopOverViewController *pop=[self.storyboard instantiateViewControllerWithIdentifier:@"PopOverViewController"];
        pop.delegate=self;
        pop.buttonName=@"slideout";
        pop.slideoutImageArray=slideoutImageArray;
        
       CGFloat finalWidth =0.0;
        for (NSString *str in slideoutArray) {
            CGFloat width =  [str boundingRectWithSize:(CGSizeMake(NSIntegerMax,40)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:15]} context:nil].size.width;
            finalWidth=MAX(finalWidth+50, width);
        }
        pop.slideoutNameArray=slideoutArray;
        [self wypopOver:btn withPopOver:pop];
        CGFloat height=[pop getHeightOfTableView];
        CGSize contentSize = CGSizeMake(finalWidth,height);
        pop.preferredContentSize=contentSize;
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
//wypopover method
-(void)wypopOver:(UIView*)btn withPopOver:(PopOverViewController*)pop{
    wypopOverController=[[WYPopoverController alloc]initWithContentViewController:pop];
    wypopOverController.delegate=self;
    wypopOverController.passthroughViews = @[btn];
    wypopOverController.theme=[WYPopoverTheme themeForIOS6];
    wypopOverController.theme.outerCornerRadius=2;
    wypopOverController.theme.outerStrokeColor=[UIColor lightGrayColor];
    wypopOverController.theme.arrowHeight =0;
    wypopOverController.theme.arrowBase= 15;
    wypopOverController.theme.fillTopColor = [UIColor grayColor];
    wypopOverController.theme.overlayColor= [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
}
//delegate of language selection
-(void)selectedObject:(lagModel *)model{
    NSUserDefaults *standardDefault=[NSUserDefaults standardUserDefaults];
    [standardDefault setValue:model.code forKey:@"languageCode"];
     [standardDefault setValue:model.name forKey:@"languageName"];
    [lagSomeButton setTitle:[standardDefault valueForKey:@"languageName"] forState:normal];
  [wypopOverController dismissPopoverAnimated:NO];
    LanguageChanger *languageChanger=[[LanguageChanger alloc]init];
    [languageChanger callApiForLanguage];
}
//delegate of slideout
-(void)selectedSlideOutObject:(NSString *)name{
    if ([name isEqualToString:slideoutArray[slideoutArray.count-1]]) {
     [self showFailureAlerMessage:@"Do you realy want to signout?"];
    }else  if ([name isEqualToString:slideoutArray[slideoutArray.count-2]]) {
      
    }
     [wypopOverController dismissPopoverAnimated:NO];
}
//delegate of wypopover
-(BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)popoverController

{
    return YES;
}

-(void)popoverControllerDidDismissPopover:(WYPopoverController *)popoverController

{
    wypopOverController.delegate=nil;
    wypopOverController=nil;
}
//failure message
-(void)showFailureAlerMessage:(NSString*)msg{
    UIAlertController *alertView=[UIAlertController alertControllerWithTitle:@"Alert!" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *success=[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
        [self.navigationController popViewControllerAnimated:YES];
        NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
        [userdefault setValue:@"" forKey:@"userName"];
        [userdefault setValue:@"" forKey:@"password"];
        [userdefault setBool:NO forKey:@"rememberMe"];
        [alertView dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertView addAction:success];
    UIAlertAction *fail=[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
        [alertView dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertView addAction:fail];
    
    [self presentViewController:alertView animated:YES completion:nil];
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
-(void)callSeed{
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        //Api For Vzone
        [self callApiForLanguage];
    }else{
        //  API for material
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        if ([userDefault boolForKey:@"language_FLAG"]) {
            [self callApiForLanguage];
        }
        else{
            NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,getPatientList];
            [[SeedSyncer sharedSyncer]getResponseFor:url completionHandler:^(BOOL success, id response) {
                if (success) {
                    [self processResponse:response];
                }
                else{
                    [self callApiForLanguage];
                }
            }];
        }
    }
}

-(void)callApiForLanguage{
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,language];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        NSString *parameter=[NSString stringWithFormat:@"{\"request\":}}"];
        [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processResponse:responseObject];
            [[SeedSyncer sharedSyncer]saveResponse:[operation responseString] forIdentity:url];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:NO forKey:@"gender_FLAG"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        }];
    }else{
    [postman get:url withParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processResponse:responseObject];
        [[SeedSyncer sharedSyncer]saveResponse:[operation responseString] forIdentity:url];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setBool:NO forKey:@"language_FLAG"];
        [MBProgressHUD hideHUDForView:self.view animated:YES ];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    }
}
-(void)processResponse:(id)response{
    NSDictionary *dict;
     if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
    NSDictionary *dic1=response;
         dict=dic1[@"aaData"];
     }else{
         dict=response;
     }
    for (NSDictionary *dict1 in dict[@"GenericSearchViewModels"]) {
        if ([dict1[@"Status"]boolValue]) {
            lagModel *model=[[lagModel alloc]init];
            model.name=dict1[@"Name"];
            model.code=dict1[@"Code"];
            [languageArray addObject:model];

        }
    }
}

@end
