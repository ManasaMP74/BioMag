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
#import "AboutUsViewController.h"
#import "LoginViewController.h"
#import "ToxicDeficiencyDetailModel.h"
#import "ToxicDeficiency.h"
#import "sittingModel.h"
#import "DrProfileViewController.h"
#import "CriticalTreatmentInfoViewController.h"
#import <MCLocalization/MCLocalization.h>
#import "ShowCriticalInfoViewController.h"
#import "DrProfilModel.h"
#if !defined(MAX)
#define MAX(A,B)((A) > (B) ? (A) : (B))
#endif
@interface ContainerViewController ()<addedPatient,loadTreatmentDelegate,selectedObjectInPop,WYPopoverControllerDelegate,languageChangeForDelegat>

@end

@implementation ContainerViewController
{
    NSMutableArray *languageArray,*toxicDeficiencyDetailArray,*toxicDeficiencyTypeArray,*sittingArray;
    Postman *postman;
    NSString *patientName;
    WYPopoverController *wypopOverController;
    UIButton *lagSomeButton;
     NSArray *slideoutImageArray,*slideoutArray;
    UIButton *someButton ;
    NSUserDefaults *standardDefault;
    int selectedLangRow;
    PopOverViewController *pop;
    LanguageChanger *languageChanger;
    NSString *doyoureallywanttoSignout,*profile,*shareCriticalTreatmentInfo,*aboutUsStr,*FAQStr,*termsandConditionsStr,*privacyandPolicyStr,*logoutStr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self localize];
      self.navigationController.navigationBarHidden=NO;
    self.navigationItem.hidesBackButton = YES;
    languageArray =[[NSMutableArray alloc]init];
    toxicDeficiencyDetailArray=[[NSMutableArray alloc]init];
    toxicDeficiencyTypeArray=[[NSMutableArray alloc]init];
    sittingArray=[[NSMutableArray alloc]init];
    postman=[[Postman alloc]init];
    [self navigationMethod];
    [lagSomeButton setTitle:[standardDefault valueForKey:@"languageName"] forState:normal];
    [self callSeedForSitting];
    [self callSeed];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [lagSomeButton setBackgroundImage:[[UIImage imageNamed:@"Language-Button.png"] resizableImageWithCapInsets:(UIEdgeInsetsMake(14,30, 14,30))] forState:(UIControlStateNormal)];
    lagSomeButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    lagSomeButton.titleLabel.numberOfLines = 2;
         [lagSomeButton sizeToFit];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSData *doctorDetail=[defaults valueForKey:@"DoctorDetail1"];
    if (doctorDetail!=nil) {
        DrProfilModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:doctorDetail];
        slideoutArray=@[model.name,profile,shareCriticalTreatmentInfo,aboutUsStr,FAQStr,termsandConditionsStr,privacyandPolicyStr,logoutStr];
    }else{
        slideoutArray=@[@"",profile,shareCriticalTreatmentInfo,aboutUsStr,FAQStr,termsandConditionsStr,privacyandPolicyStr,logoutStr];
    }
        slideoutImageArray=@[@"Dr-Thumbnail",@"Doctor-128.png",@"Data-Information-128.png",@"01-Icon-About-Us.png",@"02-Icon-FAQ.png",@"04-Icon-Terms.png",@"03-Icon-Privacy.png",@"05-Icon-Logout.png"];
}
//navigationMethod
-(void)navigationMethod{
    UIImage* image3 = [UIImage imageNamed:@"06-Icon-Navigation.png"];
    CGRect frameimg = CGRectMake(0, 0, image3.size.width, image3.size.height);
    someButton= [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(slideout:) forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    
    
  //  UIImage* image = [UIImage imageNamed:@"Icon-Langauge.png"];
    // [lagSomeButton setImage:image forState:normal];
    // lagSomeButton.titleEdgeInsets=UIEdgeInsetsMake(0, -35, 0, 30);
    // lagSomeButton.imageEdgeInsets=UIEdgeInsetsMake(0,74, 0, 0);
    //    [standardDefault setValue:@"English" forKey:@"languageName"];
   // CGRect lagFrameimg = CGRectMake(0,0,image1.size.width, image1.size.height);
    // lagSomeButton.titleEdgeInsets=UIEdgeInsetsMake(0,0.20,0,0.20);
    
    lagSomeButton= [[UIButton alloc] init];
    standardDefault=[NSUserDefaults standardUserDefaults];
    lagSomeButton.titleLabel.font=[UIFont fontWithName:@"OpenSans-Semibold" size:14];
    [lagSomeButton setTitleColor:[UIColor blackColor] forState:normal];
    [lagSomeButton addTarget:self action:@selector(languageChange:) forControlEvents:UIControlEventTouchUpInside];
    [lagSomeButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *lagButton =[[UIBarButtonItem alloc] initWithCustomView:lagSomeButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = 20;
    self.navigationItem.rightBarButtonItems=@[mailbutton,negativeSpacer,lagButton];
}
//pop back
-(void)popToViewController{
    [self.navigationController popViewControllerAnimated:YES];
}
//call lang from PatientSheet
-(void)callForNavigationButton:(NSString*)str withButton:(UIButton *)btn{
    if ([str isEqualToString:@"language"]) {
        lagSomeButton=btn;
        [self languageChange:lagSomeButton];
    }else {
        someButton=btn;
        [self slideout:someButton];
    }
}

//LanguageChange
-(IBAction)languageChange:(id)sender{
  //  [self.delegate getThePopOverForLanguage:languageArray];
    UIView *btn = (UIView *)sender;
    if (wypopOverController==nil){
        pop=[self.storyboard instantiateViewControllerWithIdentifier:@"PopOverViewController"];
        pop.delegate=self;
        pop.buttonName=@"language";
        pop.lagArray=languageArray;
        
        CGFloat finalWidth =0.0;
        for (lagModel *str in languageArray) {
            CGFloat width =  [str.name boundingRectWithSize:(CGSizeMake(NSIntegerMax,self.view.frame.size.width)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:15]} context:nil].size.width;
            finalWidth=MAX(finalWidth, width);
        }
        pop.slideoutNameArray=languageArray;
        [self wypopOver:btn];
        CGFloat height=[pop getHeightOfTableView];
        CGSize contentSize = CGSizeMake(finalWidth+70,height);
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
    //[self.delegate getThePopOverForslideout];
    UIView *btn = (UIView *)sender;
    if (wypopOverController==nil){
        pop=[self.storyboard instantiateViewControllerWithIdentifier:@"PopOverViewController"];
        pop.delegate=self;
        pop.buttonName=@"slideout";
        pop.slideoutImageArray=slideoutImageArray;
        
       CGFloat finalWidth = 0.0;
        for (NSString *str in slideoutArray) {
            CGFloat width =  [str boundingRectWithSize:(CGSizeMake(NSIntegerMax,self.view.frame.size.width)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:15]} context:nil].size.width;
            finalWidth=MAX(finalWidth, width);
        }

        pop.slideoutNameArray = slideoutArray;
        [self wypopOver:btn];
        CGFloat height=[pop getHeightOfTableView];
        CGSize contentSize = CGSizeMake(finalWidth+70,height);
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
-(void)wypopOver:(UIView*)btn{
    wypopOverController=[[WYPopoverController alloc]initWithContentViewController:pop];
    wypopOverController.delegate=self;
    wypopOverController.passthroughViews = @[btn];
    wypopOverController.theme=[WYPopoverTheme themeForIOS6];
    wypopOverController.theme.outerCornerRadius=0;
    wypopOverController.theme.outerStrokeColor=[UIColor clearColor];
    wypopOverController.theme.outerShadowColor=[UIColor clearColor];
    wypopOverController.theme.arrowHeight =0;
    wypopOverController.theme.arrowBase= 0;
    wypopOverController.theme.fillTopColor = [UIColor clearColor];
    wypopOverController.theme.overlayColor= [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
    wypopOverController.theme.borderWidth=0;
    wypopOverController.theme.tintColor=[UIColor clearColor];
    wypopOverController.theme.outerShadowColor=[UIColor clearColor];
    wypopOverController.theme.outerShadowBlurRadius=0;
}
//delegate of language selection
-(void)selectedObject:(int)row{
  languageChanger =[[LanguageChanger alloc]init];
    selectedLangRow=row;
    lagModel *model=languageArray[selectedLangRow];
    NSString *langCode=[standardDefault valueForKey:@"languageCode"];
    if ([langCode isEqualToString:model.code]) {
       [MBProgressHUD hideHUDForView:self.view animated:NO];
        [wypopOverController dismissPopoverAnimated:YES completion:^{
            wypopOverController.delegate = nil;
            wypopOverController = nil;
        }];
        [wypopOverController dismissPopoverAnimated:NO];
    }else{
    [standardDefault setValue:model.code forKey:@"changedLanguageCode"];
    [standardDefault setValue:model.name forKey:@"changedLanguageName"];
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
      [languageChanger callApiForPreferredLanguage];
    languageChanger.delegate=self;
    }
}
-(void)languageChangeDelegate:(int)str{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    if (str==1) {
         lagModel *model=languageArray[selectedLangRow];
        [standardDefault setValue:model.code forKey:@"languageCode"];
        [standardDefault setValue:model.name forKey:@"languageName"];
        [lagSomeButton setTitle:[standardDefault valueForKey:@"languageName"] forState:normal];
       // [languageChanger readingLanguageFromDocument];
    }
    [wypopOverController dismissPopoverAnimated:YES completion:^{
        wypopOverController.delegate = nil;
        wypopOverController = nil;
    }];
     [wypopOverController dismissPopoverAnimated:NO];
}
//delegate of slideout
-(void)selectedSlideOutObject:(int)row{
    if (row==7) {
     [self showFailureAlerMessage:doyoureallywanttoSignout];
    }else  if (row==6) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseUrl,privecyAndPolicy]]];
    }
    else  if (row==3) {
        AboutUsViewController *about=[self.storyboard instantiateViewControllerWithIdentifier:@"AboutUsViewController"];
        [self.navigationController pushViewController:about animated:YES];
    }
    else  if (row==5) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseUrl,termsAndCondition]]];
    }
    else  if (row==4) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseUrl,FAQurl]]];
    }
    else if (row==2){
        [self  callApiToSearchSaredCriticalInfo];
    }else if (row==1){
        DrProfileViewController *dr=[self.storyboard instantiateViewControllerWithIdentifier:@"DrProfileViewController"];
        [self.navigationController pushViewController:dr animated:YES];
    
    }
    [wypopOverController dismissPopoverAnimated:YES completion:^{
        wypopOverController.delegate = nil;
        wypopOverController = nil;
    }];
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
        [self.navigationController popToRootViewControllerAnimated:YES];
        NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
        UINavigationController *nav=(UINavigationController*)self.parentViewController;
        LoginViewController *login=[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [nav setViewControllers:@[login]];
        [userdefault setValue:@"" forKey:@"userName"];
        [userdefault setValue:@"" forKey:@"password"];
        [userdefault setBool:NO forKey:@"rememberMe"];
        [userdefault setBool:YES forKey:@"logout"];
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
-(void)passDataFromsearchPatientTableViewToPatient:(searchPatientModel*)model withPatientDataIsThereOrNot:(BOOL)status{
    if ([_viewControllerDiffer isEqualToString:@""]) {
        UINavigationController * nav=[self.childViewControllers lastObject];
        PatientViewController *patientVc=nav.viewControllers[0];
        [nav popToViewController:patientVc animated:YES];
        patientVc.model =model;
        [patientVc setDefaultValues:status];
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
    patientSheet.sittingArray=sittingArray;
    patientSheet.toxicDeficiencyDetailArray=toxicDeficiencyDetailArray;
    patientSheet.toxicDeficiencyTypeArray=toxicDeficiencyTypeArray;
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
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
}
//hide mbprogress
-(void)hideMBprogressTillLoadThedata{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
}
//hide mbprogress
-(void)hideAllMBprogressTillLoadThedata{
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
}
//Load TreatmentList in PatientVC
-(void)loadTreatment{
    SearchPatientViewController *searchVC=[self.childViewControllers firstObject];
    [searchVC reloadTableviewAfterAddNewTreatment];
}
-(void)callSeed{
//    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
//        //Api For Vzone
//        [self callApiForLanguage];
//    }else{
        //  API for material
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        if ([userDefault boolForKey:@"language_FLAG"]) {
            [self callApiForLanguage];
        }
        else{
            NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,language];
            [[SeedSyncer sharedSyncer]getResponseFor:url completionHandler:^(BOOL success, id response) {
                if (success) {
                    [self processResponse:response];
                }
                else{
                    [self callApiForLanguage];
                }
            }];
        }
  //  }
}

-(void)callApiForLanguage{
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,language];
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        NSString *parameter=[NSString stringWithFormat:@"{\"request\":}}"];
        [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processResponse:responseObject];
            [[SeedSyncer sharedSyncer]saveResponse:[operation responseString] forIdentity:url];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:NO forKey:@"language_FLAG"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        }];
    }else{
    [postman get:url withParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processResponse:responseObject];
        [[SeedSyncer sharedSyncer]saveResponse:[operation responseString] forIdentity:url];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setBool:NO forKey:@"language_FLAG"];
        [MBProgressHUD hideHUDForView:self.view animated:NO ];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [self showToastMessage:[NSString stringWithFormat:@"%@",error]];
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
    NSUserDefaults *standardDefault1=[NSUserDefaults standardUserDefaults];
    [self getTheLanguageName:[standardDefault1 valueForKey:@"languageCode"]];
     [self callSeedForToxicDeficiency];
}
-(void)getTheLanguageName:(NSString*)code{
    if (languageArray.count>0) {
        for (lagModel *model in languageArray) {
            if ([model.code isEqualToString:code]) {
                [standardDefault setValue:model.name forKey:@"languageName"];
                [lagSomeButton setTitle:[standardDefault valueForKey:@"languageName"] forState:normal];
  
            }
        }
    }
}

-(void)callSeedForToxic{
    //  if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
    //      //For Vzone API
    //      [self callApiToToxicDeficiency];
    //  }else{
    //      //For Material API
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault boolForKey:@"toxicdeficiency_FLAG"]) {
        [self callApiToToxicDeficiency];
    }
    else{
        NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,toxicDeficiencyDetail];
        [[SeedSyncer sharedSyncer]getResponseFor:url completionHandler:^(BOOL success, id response) {
            if (success) {
                [self processToxicDeficiency:response];
            }
            else{
                [self callApiToToxicDeficiency];
            }
        }];
        
    }
    //}
}

-(void)callApiToToxicDeficiency{
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,toxicDeficiencyDetail];
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        NSString *parameter=[NSString stringWithFormat:@"{\"request\":}}"];
        [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processToxicDeficiency:responseObject];
            [[SeedSyncer sharedSyncer]saveResponse:[operation responseString] forIdentity:url];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:NO forKey:@"toxicdeficiency_FLAG"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       // NSString *str=[NSString stringWithFormat:@"%@",error];
        }];
        
    }else{
        [postman get:url withParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processToxicDeficiency:responseObject];
            [[SeedSyncer sharedSyncer]saveResponse:[operation responseString] forIdentity:url];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:NO forKey:@"toxicdeficiency_FLAG"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          //  NSString *str=[NSString stringWithFormat:@"%@",error];
            
        }];
    }
}
-(void)processToxicDeficiency:(id)responseObject{
    [toxicDeficiencyDetailArray removeAllObjects];
    
    NSDictionary *dict;
    
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        //For Vzone API
        NSDictionary *responseDict1 = responseObject;
        dict  = responseDict1[@"aaData"];
        for (NSDictionary *dict1 in dict[@"GenericSearchViewModels"]) {
            if ([dict1[@"Status"] intValue]==1) {
                ToxicDeficiencyDetailModel *model=[[ToxicDeficiencyDetailModel alloc]init];
                model.toxicCode=dict1[@"Code"];
                model.toxicName=dict1[@"Name"];
                model.toxicId=dict1[@"Id"];
                model.selected=NO;
                model.toxicTypeCode=dict1[@"ToxicDeficiencyTypeCode"];
                [toxicDeficiencyDetailArray addObject:model];
            }
        }
    }else{
        //For Material API
        dict=responseObject;
        for (NSDictionary *dict1 in dict[@"ViewModels"]) {
            if ([dict1[@"Status"] intValue]==1) {
                ToxicDeficiencyDetailModel *model=[[ToxicDeficiencyDetailModel alloc]init];
                model.toxicCode=dict1[@"Code"];
                model.toxicName=dict1[@"Name"];
                model.toxicId=dict1[@"Id"];
                model.selected=NO;
                model.toxicTypeCode=dict1[@"ToxicDeficiencyTypeCode"];
                [toxicDeficiencyDetailArray addObject:model];
            }
        }
    }
}
//call toxicDeficiency
-(void)callSeedForToxicDeficiency{
    
    //    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
    //        //For Vzone API
    //        [self callApiForToxicDeficiency];
    //    }else{
    //        //For Material API
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault boolForKey:@"toxicdeficiencytype_FLAG"]) {
        [self callApiForToxicDeficiencyType];
    }
    else{
        NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,toxicDeficiencyType];
        [[SeedSyncer sharedSyncer]getResponseFor:url completionHandler:^(BOOL success, id response) {
            if (success) {
                [self processResponseForToxicType:response];
            }
            else{
                [self callApiForToxicDeficiencyType];
            }
        }];
    }
    //  }
    
}
//Api for Toxic
-(void)callApiForToxicDeficiencyType{
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,toxicDeficiencyType];
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        NSString *parameter=[NSString stringWithFormat:@"{\"request\":}}"];
        [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processResponseForToxicType:responseObject];
            [[SeedSyncer sharedSyncer]saveResponse:[operation responseString] forIdentity:url];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:NO forKey:@"toxicdeficiencytype_FLAG"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
        }];
    }else{
        [postman get:url withParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processResponseForToxicType:responseObject];
            [[SeedSyncer sharedSyncer]saveResponse:[operation responseString] forIdentity:url];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:NO forKey:@"toxicdeficiencytype_FLAG"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        }];
    }
}
//process Response
-(void)processResponseForToxicType:(id)responseObject{
    [toxicDeficiencyTypeArray removeAllObjects];
    
    NSDictionary *dict;
    
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        //For Vzone API
        NSDictionary *responseDict1 = responseObject;
        dict  = responseDict1[@"aaData"];
    }else{
        //For Material API
        dict=responseObject;
    }
    
    for (NSDictionary *dict1 in dict[@"GenericSearchViewModels"]) {
        if ([dict1[@"Status"]intValue]==1) {
            ToxicDeficiency *model=[[ToxicDeficiency alloc]init];
            model.idValue=dict1[@"Id"];
            model.name=dict1[@"Name"];
            model.code=dict1[@"Code"];
            [toxicDeficiencyTypeArray addObject:model];
        }
    }
     [self callSeedForToxic];
}
-(void)callSeedForSitting{
    
    //    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
    //        //For vzone API
    //        [self callApi];
    //    }else{
    //        //For Material API
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault boolForKey:@"anatomicalbiomagneticmatrix_FLAG"]) {
        [self callApiforSitting];
    }
    else{
        NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,biomagneticMatrix];
        [[SeedSyncer sharedSyncer]getResponseFor:url completionHandler:^(BOOL success, id response) {
            if (success) {
                [self processResponseObjectforSitting:response];
            }
            else{
                [self callApiforSitting];
            }
        }];
    }
    
    //   }
}
//Call api to get the biomagnetic matrix
-(void)callApiforSitting{
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,biomagneticMatrix];
    
    NSString *parameter;
      NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        //For Vzone API
        NSString *languageCode=[userDefault valueForKey:@"languageCode"];
        parameter=[NSString stringWithFormat:@"{\"request\":{\"SectionCode\": \"\",\"ScanPointCode\": \"\",\"CorrespondingPairCode\":\"\",\"GermsCode\": \"\",\"CurrentLanguageCode\":\"%@\"}}",languageCode];
    }else{
        
        //For material API
        
        parameter =[NSString stringWithFormat:@"{\"SectionCode\": \"\",\"ScanPointCode\": \"\",\"CorrespondingPairCode\":\"\",\"GermsCode\": \"\"}"];
    }
    [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processResponseObjectforSitting:responseObject];
        [[SeedSyncer sharedSyncer]saveResponse:[operation responseString] forIdentity:url];
        [userDefault setBool:NO forKey:@"anatomicalbiomagneticmatrix_FLAG"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
//Response of biomagnetic matrix
-(void)processResponseObjectforSitting:(id)responseObject{
    [sittingArray removeAllObjects];
    NSDictionary *dict;
    
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        //For Vzone API
        NSDictionary *responseDict1 = responseObject;
        dict= responseDict1[@"aaData"];
    }else{
        //For Material API
        dict=responseObject;
    }
    
    if ([dict[@"Success"] intValue]==1) {
        for (NSDictionary *dict1 in dict[@"AnatomicalBiomagneticMatrix"]) {
            if ([dict1[@"Status"]intValue]==1) {
                sittingModel *model=[[sittingModel alloc]init];
                model.sittingId=dict1[@"Id"];
                if (dict1[@"Code"]!=[NSNull null]) {
                    model.anatomicalBiomagenticCode=dict1[@"Code"];
                }
                if (dict1[@"ScanPointCode"]!=[NSNull null]) {
                    model.scanPointCode=dict1[@"ScanPointCode"];
                }
                if (dict1[@"CorrespondingPairCode"]!=[NSNull null]){
                    model.correspondingPairCode=dict1[@"CorrespondingPairCode"];
                }
                if (dict1[@"GermsCode"]!=[NSNull null]){
                    model.germsCode=dict1[@"GermsCode"];
                }
                if (dict1[@"SectionCode"]!=[NSNull null]){
                    model.sectionCode=dict1[@"SectionCode"];
                }
                if (dict1[@"Section"]!=[NSNull null]){
                    model.sectionName=dict1[@"Section"];
                }
                if (dict1[@"ScanPoint"]!=[NSNull null]){
                    model.scanPointName=dict1[@"ScanPoint"];
                }
                if (dict1[@"CorrespondingPair"]!=[NSNull null]){
                    model.correspondingPairName=dict1[@"CorrespondingPair"];
                }
                if (dict1[@"AppTypeCode"]!=[NSNull null]){
                    model.appTypeCodeValue=dict1[@"AppTypeCode"];
                }
                if (dict1[@"ApplicableVersionCode"]!=[NSNull null]){
                    model.applicableVersionCodeValue=dict1[@"ApplicableVersionCode"];
                }
                [sittingArray addObject:model];
            }
        }
    }
}

//Toast Message
-(void)showToastMessage:(NSString*)msg{
    MBProgressHUD *hubHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hubHUD.mode=MBProgressHUDModeText;
    hubHUD.detailsLabelText=msg;
    hubHUD.detailsLabelFont=[UIFont systemFontOfSize:15];
    hubHUD.margin=20.f;
    hubHUD.yOffset=150.f;
    hubHUD.removeFromSuperViewOnHide = YES;
    [hubHUD hide:YES afterDelay:2];
}
-(void)languageBtnFrame:(UIButton*)btn{
    standardDefault=[NSUserDefaults standardUserDefaults];
    lagSomeButton.titleLabel.font=[UIFont fontWithName:@"OpenSans-Semibold" size:14];
   // NSString *languageName=[standardDefault valueForKey:@"languageName"];
}
-(void)localize{
    doyoureallywanttoSignout=[MCLocalization stringForKey:@"Do you really want to Signout?"];
    profile=[MCLocalization stringForKey:@"Profile"];
    shareCriticalTreatmentInfo=[MCLocalization stringForKey:@"Share Critical Treatment Info"];
    aboutUsStr=[MCLocalization stringForKey:@"About Us"];
    FAQStr=[MCLocalization stringForKey:@"FAQ"];
    termsandConditionsStr=[MCLocalization stringForKey:@"Terms and Conditions"];
    privacyandPolicyStr=[MCLocalization stringForKey:@"Privacy and Policy"];
    logoutStr=[MCLocalization stringForKey:@"Logout"];
}
-(void)callApiToSearchSaredCriticalInfo{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
   NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *docid=[userDefault valueForKey:@"Id"];
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,searchSaredCriticalInfo];
    NSString *parameter=[NSString stringWithFormat:@"{\"request\":{\"Published\":\"0\",\"FromDate\":null,\"ToDate\":null,\"CreatedBy\":\"%@\"}}",docid];
    [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [self processResponseOfcallApiToSearchSaredCriticalInfo:responseObject];
           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [self showToastMessage:[NSString stringWithFormat:@"%@",error]];
    }];
}
-(void)processResponseOfcallApiToSearchSaredCriticalInfo:(id)responseObject{
    NSDictionary *dict;
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        NSDictionary *dic1=responseObject;
        dict=dic1[@"aaData"];
    }else{
        dict=responseObject;
    }
    if ([dict[@"Success"] intValue]==1) {
        NSArray *ar=dict[@"GenericSearchViewModels"];
        if (ar.count==0) {
            CriticalTreatmentInfoViewController *critical=[self.storyboard instantiateViewControllerWithIdentifier:@"CriticalTreatmentInfoViewController"];
           critical.summary=@"";
            critical.descriptionvalue=@"";
            critical.differOfAddOrEdit=@"add";
            [self.navigationController pushViewController:critical animated:YES];
        }else{
            ShowCriticalInfoViewController *critical=[self.storyboard instantiateViewControllerWithIdentifier:@"ShowCriticalInfoViewController"];
            critical.CriticalInfoArray=ar;
            [self.navigationController pushViewController:critical animated:YES];
        }
    }else {
    [self showToastMessage:[NSString stringWithFormat:@"%@",dict[@"Message"]]];
    }
}
@end
