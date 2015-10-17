#import "AddPatientViewController.h"
#import "Constant.h"
@interface AddPatientViewController ()
@property (strong, nonatomic) IBOutlet UITextField *nameTF;
@property (strong, nonatomic) IBOutlet UITextField *genderTF;
@property (strong, nonatomic) IBOutlet UITextField *maritialStatus;
@property (strong, nonatomic) IBOutlet UITextField *dateOfBirthTF;
@property (strong, nonatomic) IBOutlet UITextField *ageTF;
@property (strong, nonatomic) IBOutlet UITextField *mobileNoTF;
@property (strong, nonatomic) IBOutlet UITextField *emailTF;
@property (strong, nonatomic) IBOutlet UITextField *Address;
@property (strong, nonatomic) IBOutlet UITableView *gendertableview;
@property (strong, nonatomic) IBOutlet UITableView *maritialTableView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *gestureRecognizer;
@property (strong, nonatomic) IBOutlet UILabel *saveLabel;
@end

@implementation AddPatientViewController
{
    Constant *constant;
    NSArray *genderArray,*MaritialStatusArray;
    NSString *differOfTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    constant=[[Constant alloc]init];
    [self textFieldLayer];
    genderArray=@[@"Male",@"Female"];
    MaritialStatusArray=@[@"Single",@"Married"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
//Save the data
- (IBAction)save:(id)sender {
}
//maritialStatus field
- (IBAction)maritalStatus:(id)sender {
    _gendertableview.hidden=YES;
    _maritialTableView.hidden=NO;
    differOfTableView=@"maritral";
    [_maritialTableView reloadData];
     [self keepThetextFieldDisbale:NO];
    _gestureRecognizer.enabled=NO;
}
//DateOfBirth Field
- (IBAction)dateOfBirth:(id)sender {
}
//gender Field
- (IBAction)gender:(id)sender {
    _gendertableview.hidden=NO;
    _maritialTableView.hidden=YES;
    differOfTableView=@"gender";
    [_gendertableview reloadData];
    [self keepThetextFieldDisbale:NO];
    _gestureRecognizer.enabled=NO;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
//TableView Number of row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return genderArray.count;
}
//TableView cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if ([differOfTableView isEqualToString:@"gender"]) {
        cell.textLabel.text=genderArray[indexPath.row];
        [constant setFontForLabel:cell.textLabel];
    }
    else if ([differOfTableView isEqualToString:@"maritral"]){
        cell.textLabel.text=MaritialStatusArray[indexPath.row];
        [constant setFontForLabel:cell.textLabel];
    }
    tableView.tableFooterView=[UIView new];
    return cell;
}
//select tableviewContent
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if ([differOfTableView isEqualToString:@"gender"]){
        _genderTF.text=cell.textLabel.text;
        _gendertableview.hidden=YES;
    }
    else if([differOfTableView isEqualToString:@"maritral"])
    {
        _maritialStatus.text=cell.textLabel.text;
        _maritialTableView.hidden=YES;
    }
     [self keepThetextFieldDisbale:YES];
    _gestureRecognizer.enabled=YES;
}
//cell Color
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([differOfTableView isEqualToString:@"gender"] | [differOfTableView isEqualToString:@"maritral"])
        [cell setBackgroundColor:[UIColor lightGrayColor]];
}
//Hide KeyBoard
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
//Hide KeyBoard
- (IBAction)gestureMethod:(id)sender {
    [self.view endEditing:YES];
}
//TextField Enable/Disable
-(void)keepThetextFieldDisbale:(BOOL)status{
    _nameTF.enabled=status;
    _mobileNoTF.enabled=status;
    _ageTF.enabled=status;
    _Address.enabled=status;
    _emailTF.enabled=status;
}
//set layesr for TextField and placeHolder
-(void)textFieldLayer{
    _nameTF.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Name"];
    _emailTF.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Email"];
    _genderTF.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Gender"];
    _mobileNoTF.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Mobile"];
    _Address.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Address"];
    _maritialStatus.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Marital Status"];
    _ageTF.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Age"];
    _dateOfBirthTF.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Date Of Birth"];
    [constant spaceAtTheBeginigOfTextField:_genderTF];
    [constant spaceAtTheBeginigOfTextField:_emailTF];
    [constant spaceAtTheBeginigOfTextField:_ageTF];
    [constant spaceAtTheBeginigOfTextField:_nameTF];
    [constant spaceAtTheBeginigOfTextField:_maritialStatus];
    [constant spaceAtTheBeginigOfTextField:_dateOfBirthTF];
    [constant spaceAtTheBeginigOfTextField:_Address];
    [constant spaceAtTheBeginigOfTextField:_mobileNoTF];
    [constant SetBorderForTextField:_genderTF];
    [constant SetBorderForTextField:_mobileNoTF];
    [constant SetBorderForTextField:_ageTF];
    [constant SetBorderForTextField:_maritialStatus];
    [constant SetBorderForTextField:_emailTF];
    [constant SetBorderForTextField:_Address];
    [constant SetBorderForTextField:_nameTF];
    [constant SetBorderForTextField:_dateOfBirthTF];
}
@end
