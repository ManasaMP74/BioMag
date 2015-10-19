#import "PatientViewController.h"
#import "Constant.h"
#import "ContainerViewController.h"
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
@property (strong, nonatomic) IBOutlet UILabel *addTreatmentLabel;
@property (strong, nonatomic) IBOutlet UIButton *addTreatmentButton;
@property (strong, nonatomic) IBOutlet UILabel *editLabel;
@property (strong, nonatomic) IBOutlet UILabel *patientNameTF;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@end

@implementation PatientViewController
{
    Constant *constant;
    ContainerViewController *containerVC;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    constant=[[Constant alloc]init];
    self.navigationController.navigationBarHidden=YES;
    [self setFont];
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
//setfont for label
-(void)setFont{
//    [constant setFontForLabel:_genderLabel];
//    [constant setFontForLabel:_emailLabel];
//    [constant setFontForLabel:_mobileLabel];
//    [constant setFontForLabel:_addressLabel];
//    [constant setFontForLabel:_addTreatmentLabel];
//    [constant setFontForLabel:_editLabel];
//    [constant setFontForLabel:_ageLabel];
//    [constant setFontForLabel:_dobLabel];
//    [constant setFontForLabel:_martiralStatus];
    [constant setFontForLabel:_genderValueLabel];
    [constant setFontForLabel:_emailValueLabel];
    [constant setFontForLabel:_mobileValueLabel];
    [constant setFontForLabel:_addressValueLabel];
    [constant setFontForLabel:_ageValueLabel];
    [constant setFontForLabel:_dobValueLabel];
    [constant setFontForLabel:_mariedValueLabel];
    [constant setFontForHeaders:_patientNameTF];
    [constant setFontForHeaders:_treatmentLabel];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    UILabel *label=(UILabel*)[cell viewWithTag:10];
    [constant setFontForLabel:label];
    tableView.tableFooterView=[UIView new];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [containerVC pushPatientSheetVC];
}
@end
