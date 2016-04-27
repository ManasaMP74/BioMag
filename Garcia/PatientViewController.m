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
#import "VMEnvironment.h"
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
}
- (void)viewDidLoad {
    [super viewDidLoad];
    constant=[[Constant alloc]init];
    self.navigationController.navigationBarHidden=YES;
    [self setFont];
    _tableViewHeight.constant=self.tableview.contentSize.height;
    treatmentListArray=[[NSMutableArray alloc]init];
    _patientDetailView.layer.cornerRadius=5;
    _patientImageView.layer.cornerRadius=_patientImageView.frame.size.width/2;
    _patientImageView.clipsToBounds=YES;
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
-(void)setDefaultValues:(BOOL)status{
    UINavigationController *nav=(UINavigationController*)self.parentViewController;
    containerVC=(ContainerViewController*)nav.parentViewController;
    postman=[[Postman alloc]init];
    [containerVC setTitle:navTitle];
    containerVC.delegate=self;
    if(status){
        if (_model.surgeries!=nil) {
            _surgeriesLabel.text=_model.surgeries;
        }else _surgeriesLabel.text=@"";
        if (_model.tranfusion!=nil) {
            _transfusinTF.text=_model.tranfusion;
        }else _surgeriesLabel.text=@"";
        [self callApiTogetAllDetailOfTheTreatment];
    }else{
        _patientNameTF.text=@"";
        _ageValueLabel.text=@"";
        _dobValueLabel.text=@"";
        _mobileValueLabel.text=@"";
        _surgeriesLabel.text=@"";
        _transfusinTF.text=@"";
        _genderValueLabel.text=@"";
        _emailValueLabel.text=@"";
        [treatmentListArray removeAllObjects];
        [_tableview reloadData];
    }
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PatientTitleModel *model=treatmentListArray[indexPath.row];
    CGFloat i=self.view.frame.size.width-150;
    CGFloat labelHeight=[model.title boundingRectWithSize:(CGSize){i,CGFLOAT_MAX }options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:13]} context:nil].size.height;
    if (labelHeight>41) {
        return labelHeight+20;
    }
    else return 41;
}
//table didselect
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PatientTitleModel *model=treatmentListArray[indexPath.row];
    containerVC.model=_model;
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
    profileView.filename=_model.fileName;
    [profileView alphaViewInitialize];
}

//call api to get detail of treatment
-(void)callApiTogetAllDetailOfTheTreatment{
    [containerVC showMBprogressTillLoadThedata];
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,getTitleOfTreatment];
    [postman get:url withParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processResponseObjectToGetTreatmentDetail:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [containerVC hideAllMBprogressTillLoadThedata];
        [self showToastMessage:[NSString stringWithFormat:@"%@",error]];
    }];
}
//process Response of Api
-(void)processResponseObjectToGetTreatmentDetail:(id)responseObject{
    NSString *strimageUrl;
    
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        strimageUrl = [NSString stringWithFormat:@"%@%@%@/%@",baseUrlAws,dbNameforResized,_model.storageID,_model.fileName];
        
    }else
    {
        strimageUrl = [NSString stringWithFormat:@"%@%@%@",baseUrl,getProfile,_model.profileImageCode];
    }
    
    [_patientImageView setImageWithURL:[NSURL URLWithString:strimageUrl] placeholderImage:[UIImage imageNamed:@"Patient-img.jpg"]];
    _patientNameTF.text=_model.name;
    _ageValueLabel.text=_model.age;
    _dobValueLabel.text=_model.dob;
    _mobileValueLabel.text=_model.mobileNo;
    _surgeriesLabel.text=_model.surgeries;
    _transfusinTF.text=_model.tranfusion;
    _genderValueLabel.text=_model.gender;
    _emailValueLabel.text=_model.emailId;
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
        [_tableview reloadData];
        [self.view layoutIfNeeded];
        [_scrollView layoutIfNeeded];
        _tableViewHeight.constant=self.tableview.contentSize.height;
    }else {
        [self showToastMessage:dict[@"Message"]];
    }
    [containerVC hideAllMBprogressTillLoadThedata];
    [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:NO];
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

@end
