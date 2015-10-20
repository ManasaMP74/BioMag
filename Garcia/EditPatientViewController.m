#import "EditPatientViewController.h"
#import "Constant.h"
#import "ContainerViewController.h"
#import "DatePicker.h"
@interface EditPatientViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,datePickerProtocol>
@property (strong, nonatomic) IBOutlet UITextField *nameTF;
@property (strong, nonatomic) IBOutlet UITextField *genderTF;
@property (strong, nonatomic) IBOutlet UITextField *maritialStatus;
@property (strong, nonatomic) IBOutlet UITextField *dateOfBirthTF;
@property (strong, nonatomic) IBOutlet UITextField *ageTF;
@property (strong, nonatomic) IBOutlet UITextField *mobileNoTF;
@property (strong, nonatomic) IBOutlet UITextField *emailTF;
@property (strong, nonatomic) IBOutlet UITableView *gendertableview;
@property (strong, nonatomic) IBOutlet UITableView *maritialTableView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *gestureRecognizer;
@property (strong, nonatomic) IBOutlet UITextView *addressTextView;
@end

@implementation EditPatientViewController
{
    Constant *constant;
    NSArray *genderArray,*MaritialStatusArray;
    NSString *differOfTableView;
    ContainerViewController *containerVC;
    DatePicker *datePicker;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    constant=[[Constant alloc]init];
    [self textFieldLayer];
    genderArray=@[@"Male",@"Female"];
    MaritialStatusArray=@[@"Single",@"Married"];
    differOfTableView=@"treatment";
   UINavigationController *nav=(UINavigationController*)self.parentViewController;
   containerVC=(ContainerViewController*)nav.parentViewController;
   [containerVC setTitle:@"Edit"];
    UITapGestureRecognizer *maritialgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maritalStatus:)];
    [_maritialStatus addGestureRecognizer:maritialgesture];
    UITapGestureRecognizer *genderGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gender:)];
    [_maritialStatus addGestureRecognizer:genderGesture];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
- (IBAction)cancel:(id)sender {
[self.navigationController popViewControllerAnimated:YES];
}
//Save the data
- (IBAction)save:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//maritialStatus field
- (IBAction)maritalStatus:(id)sender {
    _gendertableview.hidden=YES;
    _maritialTableView.hidden=NO;
    differOfTableView=@"maritral";
    [_maritialTableView reloadData];
}
//DateOfBirth Field
- (IBAction)dateOfBirth:(id)sender {
    if(datePicker==nil)
        datePicker= [[DatePicker alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+50, self.view.frame.origin.y+230,self.view.frame.size.width-100,220)];
    [datePicker.datePicker setMinimumDate:[NSDate date]];
    [datePicker alphaViewInitialize];
    datePicker.delegate=self;
}
-(void)selectingDatePicker:(NSString *)date{
    _dateOfBirthTF.text=date;
}
//gender Field
- (IBAction)gender:(id)sender {
    _gendertableview.hidden=NO;
    _maritialTableView.hidden=YES;
    differOfTableView=@"gender";
    [_gendertableview reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
//TableView Number of row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (([differOfTableView isEqualToString:@"maritral"])|([differOfTableView isEqualToString:@"gender"])) {
        return genderArray.count;
    }
    else return 10;
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
    else {
        UILabel *label=(UILabel*)[cell viewWithTag:10];
        [constant setFontForLabel:label];
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
    _maritialTableView.hidden=YES;
    _gendertableview.hidden=YES;
    _gestureRecognizer.enabled=YES;
[self.view endEditing:YES];
}
//set layesr for TextField and placeHolder
-(void)textFieldLayer{
    _nameTF.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Name"];
    _emailTF.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Email"];
    _genderTF.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Gender"];
    _mobileNoTF.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Mobile"];
    _maritialStatus.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Marital Status"];
    _ageTF.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Age"];
    _dateOfBirthTF.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Date Of Birth"];
    [constant spaceAtTheBeginigOfTextField:_genderTF];
    [constant spaceAtTheBeginigOfTextField:_emailTF];
    [constant spaceAtTheBeginigOfTextField:_ageTF];
    [constant spaceAtTheBeginigOfTextField:_nameTF];
    [constant spaceAtTheBeginigOfTextField:_maritialStatus];
    [constant spaceAtTheBeginigOfTextField:_dateOfBirthTF];
    [constant spaceAtTheBeginigOfTextField:_mobileNoTF];
    [constant SetBorderForTextField:_genderTF];
    [constant SetBorderForTextField:_mobileNoTF];
    [constant SetBorderForTextField:_ageTF];
    [constant SetBorderForTextField:_maritialStatus];
    [constant SetBorderForTextField:_emailTF];
    [constant SetBorderForTextview:_addressTextView];
    [constant SetBorderForTextField:_nameTF];
    [constant SetBorderForTextField:_dateOfBirthTF];
    _addressTextView.contentInset = UIEdgeInsetsMake(0,10,10,0);
}
//textField Begin Editing
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    _maritialTableView.hidden=YES;
    _gendertableview.hidden=YES;
}
@end
