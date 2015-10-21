#import "PatientViewController.h"
#import "Constant.h"
#import "ContainerViewController.h"
#import "EditPatientViewController.h"
@interface PatientViewController ()<UITableViewDataSource,UITableViewDelegate>

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
@property (strong, nonatomic) IBOutlet UILabel *addressValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *treatmentLabel;
@property (strong, nonatomic) IBOutlet UIButton *addTreatmentButton;
@property (strong, nonatomic) IBOutlet UILabel *patientNameTF;
@property (strong, nonatomic) IBOutlet UIView *TreatmentView;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *gestureRecognizer;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@end

@implementation PatientViewController
{
    Constant *constant;
    ContainerViewController *containerVC;
    NSArray *treatmentArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    constant=[[Constant alloc]init];
    self.navigationController.navigationBarHidden=YES;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background-Image-01.jpg"]]];
    [self setFont];
    [self dummyData];
    _tableViewHeight.constant=self.tableview.contentSize.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UINavigationController *nav=(UINavigationController*)self.parentViewController;
    containerVC=(ContainerViewController*)nav.parentViewController;
    [containerVC setTitle:@"Patients"];
}
//set the DefaultValues For Label
-(void)setDefaultValues{
    _patientNameTF.text=_patientName;
}
//setfont for label
-(void)setFont{
    _TreatmentView.backgroundColor=[UIColor colorWithRed:0.73 green:0.76 blue:0.91 alpha:1];
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
    [constant setFontForLabel:_addressValueLabel];
    [constant setFontForLabel:_ageValueLabel];
    [constant setFontForLabel:_dobValueLabel];
    [constant setFontForLabel:_mariedValueLabel];
    [constant setFontForHeaders:_patientNameTF];
}
//TableView Delegate Method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return treatmentArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    UILabel *label=(UILabel*)[cell viewWithTag:10];
    label.text=treatmentArray[indexPath.row];
    label.font=[UIFont fontWithName:@"OpenSans" size:13];
    tableView.tableFooterView=[UIView new];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPat{
}
- (IBAction)gestureRecognizer:(id)sender {
    [self.view endEditing:YES];
}
//DummyData
-(void)dummyData{
    treatmentArray =@[@"Neck Pain",@"Chest Pain",@"Back Pain",@"Eye"];
    [_tableview reloadData];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"edit"]) {
        EditPatientViewController *edit=segue.destinationViewController;
        edit.detailOfPatient=@[_patientNameTF.text,_genderValueLabel.text,_mariedValueLabel.text,_dobValueLabel.text,_ageValueLabel.text,_mobileValueLabel.text,_emailValueLabel.text, _addressValueLabel.text];
    }
}
@end
