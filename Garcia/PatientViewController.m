#import "PatientViewController.h"
#import "Constant.h"
#import "ContainerViewController.h"
#import "EditPatientViewController.h"
#import "MBProgressHUD.h"
#import "PostmanConstant.h"
#import "Postman.h"
#import "PatientDetailModel.h"
@interface PatientViewController ()<UITableViewDataSource,UITableViewDelegate,editPatient>
@property (strong, nonatomic) IBOutlet UILabel *transfusinTF;

@property (strong, nonatomic) IBOutlet UIButton *edit;
@property (strong, nonatomic) IBOutlet UILabel *genderLabel;
@property (strong, nonatomic) IBOutlet UILabel *martiralStatus;
@property (strong, nonatomic) IBOutlet UILabel *dobLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *mobileLabel;
@property (strong, nonatomic) IBOutlet UILabel *genderValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *mariedValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *dobValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *mobileValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *treatmentLabel;
@property (strong, nonatomic) IBOutlet UIButton *addTreatmentButton;
@property (strong, nonatomic) IBOutlet UILabel *patientNameTF;
@property (strong, nonatomic) IBOutlet UIView *TreatmentView;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (strong, nonatomic) IBOutlet UIImageView *patientImageView;
@property (strong, nonatomic) IBOutlet UILabel *surgeriesLabel;
@end

@implementation PatientViewController
{
    Constant *constant;
    ContainerViewController *containerVC;
    Postman *postman;
    NSMutableArray *treatmentListArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    constant=[[Constant alloc]init];
    self.navigationController.navigationBarHidden=YES;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background-Image-01.jpg"]]];
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
    [containerVC setTitle:@"Patients"];
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
    _patientImageView.image=_model.profileImage;
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
    PatientDetailModel *model=treatmentListArray[indexPath.row];
    label.text=model.title;
    label.font=[UIFont fontWithName:@"OpenSans" size:13];
    tableView.tableFooterView=[UIView new];
    return cell;
}
//table didselect
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PatientDetailModel *model=treatmentListArray[indexPath.row];
    containerVC.model=_model;
    containerVC.delegate=self;
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
    PatientDetailModel *model=[[PatientDetailModel alloc]init];
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
                            if (([dict1[@"Status"]intValue]==1) & ([dict1[@"IsTreatmentCompleted"]intValue]==0)) {
                                PatientDetailModel *model=[[PatientDetailModel alloc]init];
                                model.idValue=dict1[@"ID"];
                                model.code=dict1[@"Code"];
                                model.title=dict1[@"Title"];
                                model.updateCount=dict1[@"UpdateCount"];
                                [treatmentListArray addObject:model];
               }
            }
        }
        [_tableview reloadData];
        _tableViewHeight.constant=self.tableview.contentSize.height;
    }
}
@end
