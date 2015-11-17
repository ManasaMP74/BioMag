#import "SearchPatientViewController.h"
#import "SearchPatientTableViewCell.h"
#import "DefaultValues.h"
#import "Constant.h"
#import "ContainerViewController.h"
#import "MBProgressHUD.h"
#import "searchPatientModel.h"
@interface SearchPatientViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;

@property (strong, nonatomic) IBOutlet UITableView *patientListTableView;

- (IBAction)hideKeyboard:(UIControl *)sender;
@end

@implementation SearchPatientViewController
{
    DefaultValues *defaultValue;
    NSMutableArray *patentFilteredArray;
    Constant *constant;
    NSMutableArray *patentnameArray;
    NSIndexPath *selectedIndexPath;
    PostmanConstant *postmanConstant;
    Postman *postman;
    NSDateFormatter *dateFormatter;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    defaultValue=[[DefaultValues alloc]init];
    postman=[[Postman alloc]init];
    postmanConstant=[[PostmanConstant alloc]init];
    constant=[[Constant alloc]init];
     [_searchTextField addTarget:self action:@selector(searchDoctorOnProfession) forControlEvents:UIControlEventEditingChanged];
    patentFilteredArray=[[NSMutableArray alloc]init];
    [constant spaceAtTheBeginigOfTextField:_searchTextField];
    _searchTextField.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Search"];
    _searchTextField.layer.cornerRadius=18;
    _searchTextField.layer.borderColor=[UIColor colorWithRed:0.004 green:0.216 blue:0.294 alpha:0.5].CGColor;
    _searchTextField.layer.borderWidth=1;
    selectedIndexPath=nil;
     [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background-Image-02.jpg"]]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [constant setFontFortextField:_searchTextField];
    dateFormatter=[[NSDateFormatter alloc]init];
    patentnameArray=[[NSMutableArray alloc]init];
    _patientListTableView.tableFooterView=[UIView new];
    [self callApi];
}
//TableView Number of section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}
//TableView Number of row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_searchTextField.text isEqualToString:@""]) {

        return patentnameArray.count;
    }
    else
        return patentFilteredArray.count;
}
//TableView cell 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchPatientTableViewCell *cell;
     cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
     if ([_searchTextField.text isEqualToString:@""]) {
    searchPatientModel *model=patentnameArray[indexPath.row];
    cell.patientNameLabel.text=model.name;
     }
    else cell.patientNameLabel.text=patentFilteredArray[indexPath.row];
    [constant setFontForLabel:cell.patientNameLabel];
    cell.patientNameLabel.textColor=[UIColor whiteColor];
     tableView.tableFooterView=[UIView new];
     return cell;
}
//Row Height
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
//Cell Colour
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}
//Search
-(void)searchDoctorOnProfession{
    NSMutableArray *ar=[[NSMutableArray alloc]init];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"self CONTAINS[cd]%@",_searchTextField.text];
    for (searchPatientModel *model in patentnameArray) {
        [ar addObject:model.name];
    }
    NSArray *array= [ar filteredArrayUsingPredicate:predicate];
    patentFilteredArray=[NSMutableArray arrayWithArray:array];
    [_patientListTableView reloadData];
    
}
//cell select
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ContainerViewController *containerVc=(ContainerViewController*)self.parentViewController;
    
    SearchPatientTableViewCell *cell;
    if (selectedIndexPath) {
        cell=(SearchPatientTableViewCell*)[tableView cellForRowAtIndexPath:selectedIndexPath];
        cell.patientNameLabel.textColor=[UIColor whiteColor];
     cell.accessoryView = [[UIImageView alloc] initWithImage:nil];
        selectedIndexPath=nil;
    }
if (selectedIndexPath!=indexPath){
        cell=(SearchPatientTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    selectedIndexPath=indexPath;
    cell.patientNameLabel.textColor=[UIColor colorWithRed:0.7098 green:0.99 blue:0.98 alpha:1];
     cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow-3"]];
   containerVc.viewControllerDiffer=@"";
    [containerVc passDataFromsearchPatientTableViewToPatient:patentnameArray[indexPath.row]];
    }
    [self.view endEditing:YES];
}
//TextField Delegat
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
//Gesture Method
- (IBAction)gesture:(id)sender {
    [self.view endEditing:YES];
}
//HideKeyboard
- (IBAction)hideKeyboard:(UIControl *)sender
{
    [self.view endEditing:YES];
}
//AddPatient
- (IBAction)addPatient:(id)sender {
     ContainerViewController *containerVc=(ContainerViewController*)self.parentViewController;
    [containerVc ChangeTheContainerViewViewController];
}
-(void)hideKeyBoard{
    [self.view endEditing:YES];

}
-(void)callApi{
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,getPatientList];
    [self.delegate showMBprogressTillLoadThedata];
    [postman get:url withParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processResponseObject:responseObject];
        [self.delegate hideMBprogressTillLoadThedata];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       [self.delegate hideMBprogressTillLoadThedata];
    }];

}
-(void)processResponseObject:(id)responseObject{
    NSDictionary *dict1=responseObject;
    if (dict1[@"Success"]) {
    for (NSDictionary *dict in dict1[@"User"]) {
        if ([dict[@"Status"] intValue]==1) {
            searchPatientModel *model=[[searchPatientModel alloc]init];
            model.name=[NSString stringWithFormat:@"%@ %@",dict[@"FirstName"], dict[@"LastName"]];
            model.Id=dict[@"Id"];
              model.userID=dict[@"Id"];
              model.memo=dict[@"Memo"];
              model.companyCode=dict[@"CompanyCode"];
              model.password=dict[@"Password"];
            model.userTypeCode=dict[@"UserTypeCode"];
            model.roleCode=dict[@"RoleCode"];
            NSArray *dob=[dict[@"DOB"] componentsSeparatedByString:@"T"];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *dobDate=[dateFormatter dateFromString:dob[0]];
            [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
            model.dob=[dateFormatter stringFromDate:dobDate];
            model.code=dict[@"Code"];
            model.emailId=dict[@"Email"];
            NSString *addressJson=dict[@"Address"];
            if (![addressJson isKindOfClass:[NSNull class]]) {
                NSData *jsonData = [addressJson dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
                NSDictionary *d=jsonDict[@"TemporaryAddress"];
                NSString *address=d[@"AddressLine1"];
                model.addressLine1=address;
                model.country=d[@"Country"];
                model.city=d[@"City"];
                model.state=d[@"State"];
                model.pinCode=d[@"Postal"];
                model.addressline2=d[@"AddressLine2"];
                if (![d[@"City"] isEqualToString:@""]) {
                    address = [address stringByAppendingFormat:@", %@",d[@"City"]];
                }
                if (![d[@"State"] isEqualToString:@""]) {
                    address = [address stringByAppendingFormat:@", %@",d[@"State"]];
                }
                if (![d[@"Country"] isEqualToString:@""]) {
                    address = [address stringByAppendingFormat:@", %@",d[@"Country"]];
                }
                if (![d[@"Postal"] isEqualToString:@""]) {
                address = [address stringByAppendingFormat:@", %@",d[@"Postal"]];
                }
                model.address=address;
            }
            NSString *Json=dict[@"JSON"];
             if (![Json isKindOfClass:[NSNull class]]) {
            NSData *jsonData1 = [Json dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonDict1 = [NSJSONSerialization JSONObjectWithData:jsonData1 options:kNilOptions error:nil];
                 model.jsonDict=jsonDict1;
                 model.genderCode=jsonDict1[@"Gender"];
                 model.martialCode=jsonDict1[@"MaritalStatus"];
            [model getJsonDataForMartial:jsonDict1[@"MaritalStatus"] onComplete:^(NSString *martialStatus) {
                model.maritialStatus=martialStatus;
            } onError:^(NSError *error) {
                
            }];
            [model getJsonDataForGender:jsonDict1[@"Gender"] onComplete:^(NSString *genderName) {
                model.gender=genderName;
                [self reloadData];
            } onError:^(NSError *error) {
            }];
            model.mobileNo=jsonDict1[@"ContactNo"];
            NSDate *date = [dateFormatter dateFromString:model.dob];
            NSDateComponents *agecomponent=[[NSCalendar currentCalendar]components:NSCalendarUnitYear fromDate:date toDate:[NSDate date] options:0];
            model.age=[NSString stringWithFormat:@"%ld",(long)[agecomponent year]];
            }
            [patentnameArray addObject:model];
        }
    }
}
}
-(void)reloadData{
    [_patientListTableView reloadData];
    NSIndexPath* selectedCellIndexPath= [NSIndexPath indexPathForRow:0 inSection:0];
    [self tableView:_patientListTableView didSelectRowAtIndexPath:selectedCellIndexPath];
}
-(void)againCallApiAfterAddPatient{
    patentnameArray=[[NSMutableArray alloc]init];
    [self callApi];
}
@end
