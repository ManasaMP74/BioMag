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
@interface PatientViewController ()<UITableViewDataSource,UITableViewDelegate,editPatient>
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
}
- (void)viewDidLoad {
    [super viewDidLoad];
    constant=[[Constant alloc]init];
    self.navigationController.navigationBarHidden=YES;
    [self setFont];
    UINavigationController *nav=(UINavigationController*)self.parentViewController;
    containerVC=(ContainerViewController*)nav.parentViewController;
    postman=[[Postman alloc]init];
    _tableViewHeight.constant=self.tableview.contentSize.height;
    treatmentListArray=[[NSMutableArray alloc]init];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background-Image-1.jpg"]]];
    [containerVC setTitle:@"Patients"];
    [_tableview reloadData];
}
//set the DefaultValues For Label
-(void)setDefaultValues{
    _patientNameTF.text=_model.name;
    _ageValueLabel.text=_model.age;
    _dobValueLabel.text=_model.dob;
    _mobileValueLabel.text=_model.mobileNo;
    _mariedValueLabel.text=_model.maritialStatus;
    _transfusinTF.text=_model.tranfusion;
    _genderValueLabel.text=_model.gender;
    _emailValueLabel.text=_model.emailId;
        if (_model.profileImageCode==nil) {
        _patientImageView.image=_model.profileImage;
        }else{
            NSString *str=[NSString stringWithFormat:@"%@%@%@",baseUrl,getProfile,_model.profileImageCode];
             [_patientImageView setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"Patient-img.jpg"]];
        }
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
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    UILabel *label=(UILabel*)[cell viewWithTag:10];
    PatientTitleModel *model=treatmentListArray[indexPath.row];
    label.text=model.title;
    label.font=[UIFont fontWithName:@"OpenSans" size:13];
    tableView.tableFooterView=[UIView new];
    if ([model.IsTreatmentCompleted intValue]==0) {
        cell.backgroundColor=[UIColor colorWithRed:0.4471 green:0.8157 blue:0.9725 alpha:1];
    }else cell.backgroundColor=[UIColor colorWithRed:0.627 green:0.89 blue:1 alpha:1];
    return cell;
}
//table didselect
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PatientTitleModel *model=treatmentListArray[indexPath.row];
    containerVC.model=_model;
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    app.isTreatmntCompleted=model.IsTreatmentCompleted;
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
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    app.isTreatmntCompleted=@"0";
    [containerVC pushTreatmentViewController:model];
}
//add tap gesture
- (IBAction)gesture:(id)sender {
    [self.view endEditing:YES];
    [containerVC callEndEditing];
}
//successfully edited
-(void)successfullyEdited{
    [containerVC successfullyEdit];
}
- (IBAction)showFullProfileImage:(id)sender {
    if (profileView==nil)
        profileView=[[ProfileImageView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+70, self.view.frame.origin.y+100,self.view.frame.size.width-40,self.view.frame.size.height-100)];
    profileView.imageCode=_model.documentCode;
    [profileView alphaViewInitialize];
}
//call api to get detail of treatment
-(void)callApiTogetAllDetailOfTheTreatment{
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,getTitleOfTreatment];
    [containerVC showMBprogressTillLoadThedata];
    [postman get:url withParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processResponseObjectToGetTreatmentDetail:responseObject];
        [containerVC hideAllMBprogressTillLoadThedata];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [containerVC hideAllMBprogressTillLoadThedata];
    }];
}
-(void)processResponseObjectToGetTreatmentDetail:(id)responseObject{
    [treatmentListArray removeAllObjects];
    NSUserDefaults *defaultValues=[NSUserDefaults standardUserDefaults];
    NSString *docID=[defaultValues valueForKey:@"Id"];
    NSDictionary *dict=responseObject;
    if ([dict[@"Success"] intValue]==1) {
        for (NSDictionary *dict1 in dict[@"ViewModels"]) {
            if (([dict1[@"DoctorId"]intValue]==[docID intValue]) & ([dict1[@"PatientId"]intValue]==[_model.Id intValue])) {
                if ([dict1[@"Status"]intValue]==1) {
                    PatientTitleModel *model=[[PatientTitleModel alloc]init];
                    model.idValue=dict1[@"ID"];
                    model.code=dict1[@"Code"];
                    model.title=dict1[@"Title"];
                    model.IsTreatmentCompleted=dict1[@"IsTreatmentCompleted"];
                    [treatmentListArray addObject:model];
                }
            }
        }
        [_tableview reloadData];
        _tableViewHeight.constant=self.tableview.contentSize.height;
    }
}
@end
