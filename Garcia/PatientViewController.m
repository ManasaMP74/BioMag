#import "PatientViewController.h"
#import "Constant.h"
#import "ContainerViewController.h"
#import "EditPatientViewController.h"
#import "MBProgressHUD.h"
#import "PostmanConstant.h"
#import "Postman.h"
#import "PatientDetailModel.h"
#import "ProfileImageView.h"
#import "AppDelegate.h"
#import "PatientTitleModel.h"
#import <MCLocalization/MCLocalization.h>
#import "lagModel.h"
#import "SeedSyncer.h"
#import "sittingModel.h"
@interface PatientViewController ()<UITableViewDataSource,UITableViewDelegate,editPatient,loadTreatmentDelegateInContainer>
@property (weak, nonatomic) IBOutlet UILabel *transfusinTF;
@property (weak, nonatomic) IBOutlet UIButton *edit;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *martiralStatus;
@property (weak, nonatomic) IBOutlet UILabel *dobLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *mariedValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *dobValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *treatmentLabel;
@property (weak, nonatomic) IBOutlet UIButton *addTreatmentButton;
@property (weak, nonatomic) IBOutlet UILabel *patientNameTF;
@property (weak, nonatomic) IBOutlet UIView *TreatmentView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *patientImageView;
@property (weak, nonatomic) IBOutlet UILabel *surgeriesLabel;
@end
@implementation PatientViewController
{
    Constant *constant;
    ContainerViewController *containerVC;
    Postman *postman;
    NSMutableArray *treatmentListArray;
    ProfileImageView *profileView;
    NSString *alertTitle,*alertOK,*navTitle,*differForSlideoutAndLang;
    NSMutableArray *sittingArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    constant=[[Constant alloc]init];
    sittingArray =[[NSMutableArray alloc]init];
    [self callSeedForSitting];
    self.navigationController.navigationBarHidden=YES;
    [self setFont];
    _tableViewHeight.constant=self.tableview.contentSize.height;
    treatmentListArray=[[NSMutableArray alloc]init];
    _patientDetailView.layer.cornerRadius=5;
    [self localize];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background-Image-1.jpg"]]];
    _alphaViewToShowLanguage.hidden=YES;
    _popTableView.hidden=YES;
    [_tableview reloadData];
}
//set the DefaultValues For Label
-(void)setDefaultValues{
    UINavigationController *nav=(UINavigationController*)self.parentViewController;
    containerVC=(ContainerViewController*)nav.parentViewController;
      postman=[[Postman alloc]init];
    [containerVC setTitle:navTitle];
    containerVC.delegate=self;
    
    NSString *strimageUrl;
    
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
    strimageUrl = [NSString stringWithFormat:@"%@%@%@/EdittedProfile.jpeg",baseUrlAws,dbName,_model.storageID];
        
    }else
    {
  strimageUrl = [NSString stringWithFormat:@"%@%@%@",baseUrl,getProfile,_model.profileImageCode];
    
    }
    
      [_patientImageView setImageWithURL:[NSURL URLWithString:strimageUrl] placeholderImage:[UIImage imageNamed:@"Patient-img.jpg"]];
    
    _patientImageView.layer.cornerRadius=_patientImageView.frame.size.width/2;
    _patientImageView.clipsToBounds=YES;
    if (_model.surgeries!=nil) {
        _surgeriesLabel.text=_model.surgeries;
    }else _surgeriesLabel.text=@"";
    if (_model.tranfusion!=nil) {
        _transfusinTF.text=_model.tranfusion;
    }else _surgeriesLabel.text=@"";
    [self callApiTogetAllDetailOfTheTreatment];
}
//setfont for label
-(void)setFont{
    [constant setColorForLabel:_genderLabel];
    [constant setColorForLabel:_emailLabel];
    [constant setColorForLabel:_mobileLabel];
    [constant setColorForLabel:_addressLabel];
    [constant setColorForLabel:_ageLabel];
    [constant setColorForLabel:_dobLabel];
    [constant setColorForLabel:_martiralStatus];
    [constant setFontForLabel:_genderValueLabel];
    [constant setFontForLabel:_emailValueLabel];
    [constant setFontForLabel:_mobileValueLabel];
    [constant setFontForLabel:_surgeriesLabel];
    [constant setFontForLabel:_ageValueLabel];
    [constant setFontForLabel:_dobValueLabel];
    [constant setFontForLabel:_mariedValueLabel];
    [constant setFontForHeaders:_patientNameTF];
}
//TableView Delegate Method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return treatmentListArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    UILabel *label=(UILabel*)[cell viewWithTag:10];
    PatientTitleModel *model=treatmentListArray[indexPath.row];
    label.text=model.title;
    label.font=[UIFont fontWithName:@"OpenSans-Semibold" size:14];
    tableView.tableFooterView=[UIView new];
    if ([model.IsTreatmentCompleted intValue]==0) {
       // cell.backgroundColor=[UIColor colorWithRed:0.4471 green:0.8157 blue:0.9725 alpha:1];
        cell.backgroundColor=[UIColor whiteColor];
    }else{
       //cell.backgroundColor=[UIColor colorWithRed:0.627 green:0.89 blue:1 alpha:1];
       cell.backgroundColor=[UIColor colorWithRed:0.933 green:0.933 blue:0.941 alpha:1];
    }
//    cell.separatorInset=UIEdgeInsetsZero;
//    cell.layoutMargins=UIEdgeInsetsZero;
     return cell;
}
//table didselect
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PatientTitleModel *model=treatmentListArray[indexPath.row];
    containerVC.model=_model;
    containerVC.sittingArray=sittingArray;
    [containerVC pushTreatmentViewController:model];
   }
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"edit"]) {
        EditPatientViewController *edit=segue.destinationViewController;
        edit.model=_model;
        edit.delegate=self;
    }
}
//add treatment
- (IBAction)addTreatment:(id)sender {
    containerVC.model=_model;
    PatientTitleModel *model=[[PatientTitleModel alloc]init];
    [containerVC pushTreatmentViewController:model];
}
//add tap gesture
- (IBAction)gesture:(id)sender {
    [self.view endEditing:YES];
    [containerVC callEndEditing];
}
//successfully edited
-(void)successfullyEdited:(NSString*)code{
    [containerVC successfullyEdit:code];
}
- (IBAction)showFullProfileImage:(id)sender {
    if (profileView==nil)
        profileView=[[ProfileImageView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+70, self.view.frame.origin.y+100,self.view.frame.size.width-40,self.view.frame.size.height-400)];
    profileView.imageCode=_model.profileImageCode;
    profileView.storageId = _model.storageID;
    profileView.DisplayImg = _patientImageView.image;
    [profileView alphaViewInitialize];
}

//call api to get detail of treatment
-(void)callApiTogetAllDetailOfTheTreatment{
    [containerVC showMBprogressTillLoadThedata];
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,getTitleOfTreatment];
    [postman get:url withParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [containerVC hideAllMBprogressTillLoadThedata];
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:NO];
        [self processResponseObjectToGetTreatmentDetail:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [containerVC hideAllMBprogressTillLoadThedata];
        [self showToastMessage:[NSString stringWithFormat:@"%@",error]];
        }];
}

//process Response of Api
-(void)processResponseObjectToGetTreatmentDetail:(id)responseObject{
    [containerVC hideAllMBprogressTillLoadThedata];
    [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:NO];
    [treatmentListArray removeAllObjects];
    NSUserDefaults *defaultValues=[NSUserDefaults standardUserDefaults];
    NSString *docID=[defaultValues valueForKey:@"Id"];
    
    NSDictionary *dict;
    
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        NSDictionary *responseDict1 = responseObject;
       dict=responseDict1[@"aaData"];
    }else  dict=responseObject;
    
    NSMutableArray *treatmentArray=[[NSMutableArray alloc]init];
       if ([dict[@"Success"] intValue]==1) {
        for (NSDictionary *dict1 in dict[@"ViewModels"]) {
            if ((dict1[@"DoctorId"]!=[NSNull null]) & (dict1[@"PatientId"]!=[NSNull null])) {
            if (([dict1[@"DoctorId"]intValue]==[docID intValue]) & ([dict1[@"PatientId"]intValue]==[_model.Id intValue])) {
                if ([dict1[@"Status"]intValue]==1) {
                    [treatmentArray addObject:dict1];
                }
            }
          }
        }
           if (treatmentArray.count>0) {
           NSSortDescriptor *descriptor=[[NSSortDescriptor alloc]initWithKey:@"IsTreatmentCompleted" ascending:YES];
           NSArray *ar=[treatmentArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor, nil]];
           for (NSDictionary *dict1 in ar) {
               PatientTitleModel *model=[[PatientTitleModel alloc]init];
               model.idValue=dict1[@"ID"];
               model.code=dict1[@"Code"];
               model.title=dict1[@"Title"];
               model.IsTreatmentCompleted=dict1[@"IsTreatmentCompleted"];
               [treatmentListArray addObject:model];
           }
           }
           _patientNameTF.text=_model.name;
           _ageValueLabel.text=_model.age;
           _dobValueLabel.text=_model.dob;
           _mobileValueLabel.text=_model.mobileNo;
           _mariedValueLabel.text=_model.maritialStatus;
           _transfusinTF.text=_model.tranfusion;
           _genderValueLabel.text=_model.gender;
           _emailValueLabel.text=_model.emailId;

        [_tableview reloadData];
        _tableViewHeight.constant=self.tableview.contentSize.height;
       }else {
       [self showToastMessage:dict[@"Message"]];
       }
}
//Alert Message
-(void)showAlerView:(NSString*)msg{
    UIAlertController *alertView=[UIAlertController alertControllerWithTitle:alertTitle message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *success=[UIAlertAction actionWithTitle:alertOK style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
        [alertView dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertView addAction:success];
    [self presentViewController:alertView animated:YES completion:nil];
}
//Toast Message
-(void)showToastMessage:(NSString*)msg{
    MBProgressHUD *hubHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hubHUD.mode=MBProgressHUDModeText;
    hubHUD.labelText=msg;
    hubHUD.labelFont=[UIFont systemFontOfSize:15];
    hubHUD.margin=20.f;
    hubHUD.yOffset=150.f;
    hubHUD.removeFromSuperViewOnHide = YES;
    [hubHUD hide:YES afterDelay:2];
}
-(void)localize{
    alertTitle=[MCLocalization stringForKey:@"Alert!"];
    alertOK=[MCLocalization stringForKey:@"AlertOK"];
    _genderLabel.text=[MCLocalization stringForKey:@"GenderLabel"];
     _dobLabel.text=[MCLocalization stringForKey:@"DateOfBirthLabel"];
     _ageLabel.text=[MCLocalization stringForKey:@"AgeLabel"];
     _mobileLabel.text=[MCLocalization stringForKey:@"MobileLabel"];
     _martiralStatus.text=[MCLocalization stringForKey:@"TransfusionLabel"];
     _emailLabel.text=[MCLocalization stringForKey:@"EmailLabel"];
     _addressLabel.text=[MCLocalization stringForKey:@"SurgeriesLabel"];
     _treatmentLabel.text=[MCLocalization stringForKey:@"TreatmentsHeading"];
    [_addTreatmentButton setTitle:[MCLocalization stringForKey:@"AddTreatmentHeading"] forState:normal];
    navTitle=[MCLocalization stringForKey:@"Patients"];
    [_edit setTitle:[MCLocalization stringForKey:@"Edit"] forState:normal];
}
- (IBAction)ShowAlphaView:(id)sender {
    _popTableView.hidden=YES;
    _alphaViewToShowLanguage.hidden=YES;
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
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        //For Vzone API
        parameter=[NSString stringWithFormat:@"{\"request\":{\"SectionCode\": \"\",\"ScanPointCode\": \"\",\"CorrespondingPairCode\":\"\",\"GermsCode\": \"\"}}"];
    }else{
        
        //For material API
        
        parameter =[NSString stringWithFormat:@"{\"SectionCode\": \"\",\"ScanPointCode\": \"\",\"CorrespondingPairCode\":\"\",\"GermsCode\": \"\"}"];
    }
    [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processResponseObjectforSitting:responseObject];
        [[SeedSyncer sharedSyncer]saveResponse:[operation responseString] forIdentity:url];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setBool:NO forKey:@"anatomicalbiomagneticmatrix_FLAG"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [MBProgressHUD hideHUDForView:self.view animated:NO];
//        [self showToastMessage:[NSString stringWithFormat:@"%@",error]];
        
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
                    [model.germsCode addObject:dict1[@"GermsCode"]];
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
                [sittingArray addObject:model];
            }
        }
    }
}
@end
