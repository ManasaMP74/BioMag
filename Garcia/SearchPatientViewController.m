#import "SearchPatientViewController.h"
#import "SearchPatientTableViewCell.h"
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
    NSMutableArray *patentFilteredArray;
    Constant *constant;
    NSMutableArray *patentnameArray;
    NSIndexPath *selectedIndexPath;
    PostmanConstant *postmanConstant;
    Postman *postman;
    NSDateFormatter *dateFormatter;
    int initialSelectedRow,MBProgressCountToHide;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    initialSelectedRow=0;
    postman=[[Postman alloc]init];
    postmanConstant=[[PostmanConstant alloc]init];
    constant=[[Constant alloc]init];
    [_searchTextField addTarget:self action:@selector(searchDoctorOnProfession) forControlEvents:UIControlEventEditingChanged];
    [constant spaceAtTheBeginigOfTextField:_searchTextField];
    _searchTextField.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Search"];
    _searchTextField.layer.cornerRadius=18;
    _searchTextField.layer.borderColor=[UIColor colorWithRed:0.004 green:0.216 blue:0.294 alpha:0.5].CGColor;
    _searchTextField.layer.borderWidth=1;
    selectedIndexPath=nil;
     [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background-Image-02.jpg"]]];
    patentnameArray=[[NSMutableArray alloc]init];
    patentFilteredArray=[[NSMutableArray alloc]init];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [constant setFontFortextField:_searchTextField];
    dateFormatter=[[NSDateFormatter alloc]init];
    _patientListTableView.tableFooterView=[UIView new];
    if (patentnameArray.count==0) {
        MBProgressCountToHide=0;
        [self callApi];
    }
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
        NSString *str=[NSString stringWithFormat:@"%@%@%@",baseUrl,getProfile,model.profileImageCode];
        [cell.patientImageView setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"patient.jpg"] ];
        
        cell.patientNameLabel.text = model.name;
        model.profileImage=cell.patientImageView.image;
    }
    else
    {
        searchPatientModel *model=patentFilteredArray[indexPath.row];
        cell.patientNameLabel.text=model.name;
        cell.patientImageView.image=model.profileImage;
    }
    cell.patientImageView.layer.cornerRadius=cell.patientImageView.frame.size.width/2;
    cell.patientImageView.clipsToBounds=YES;
    [constant setFontForLabel:cell.patientNameLabel];
    if ([selectedIndexPath isEqual:indexPath]) {
        cell.patientNameLabel.textColor=[UIColor colorWithRed:0.7098 green:0.99 blue:0.98 alpha:1];
    }
    else  cell.patientNameLabel.textColor=[UIColor whiteColor];
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
    if (![_searchTextField.text isEqual:@""]) {
     [patentFilteredArray removeAllObjects];
    NSMutableArray *ar=[[NSMutableArray alloc]init];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"self CONTAINS[cd]%@",_searchTextField.text];
    for (searchPatientModel *model in patentnameArray) {
        [ar addObject:model.name];
    }
    NSArray *array= [ar filteredArrayUsingPredicate:predicate];
    for (searchPatientModel *model in patentnameArray) {
        if ([array containsObject:model.name]) {
            [patentFilteredArray addObject:model];
        }
    }
    [_patientListTableView reloadData];
    if (patentFilteredArray.count>0) {
        NSIndexPath* selectedCellIndexPath= [NSIndexPath indexPathForRow:0 inSection:0];
        [self tableView:_patientListTableView didSelectRowAtIndexPath:selectedCellIndexPath];
    }
    }else{
        [_patientListTableView reloadData];
        NSIndexPath* selectedCellIndexPath= [NSIndexPath indexPathForRow:0 inSection:0];
        [self tableView:_patientListTableView didSelectRowAtIndexPath:selectedCellIndexPath];
    }
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
    if ([_searchTextField.text isEqual:@""]) {
        [containerVc passDataFromsearchPatientTableViewToPatient:patentnameArray[indexPath.row]];
    
    
    
    }
    else [containerVc passDataFromsearchPatientTableViewToPatient:patentFilteredArray[indexPath.row]];
    }
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
      ContainerViewController *containerVc=(ContainerViewController*)self.parentViewController;
     [containerVc showMBprogressTillLoadThedata];
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,getPatientList];
    NSString *parameter=[NSString stringWithFormat:@"{\"UserTypeCode\":\"PAT123\"}"];
    [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processResponseObject:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       [containerVc hideMBprogressTillLoadThedata];
    }];
}
-(void)processResponseObject:(id)responseObject{
    NSDictionary *dict1=responseObject;
    if ([dict1[@"Success"] intValue]==1) {
    for (NSDictionary *dict in dict1[@"ViewModels"]) {
            searchPatientModel *model=[[searchPatientModel alloc]init];
            model.name=[NSString stringWithFormat:@"%@ %@",dict[@"Firstname"],dict[@"Lastname"]];
            model.Id=dict[@"Id"];
            model.userID=dict[@"Id"];
            model.memo=dict[@"Memo"];
            model.companyCode=dict[@"CompanyCode"];
            model.password=dict[@"Password"];
            model.userTypeCode=dict[@"UserTypeCode"];
            model.roleCode=dict[@"RoleCode"];
            NSArray *dob=[dict[@"DOb"] componentsSeparatedByString:@"T"];
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
                if (![dict[@"StateName"] isEqualToString:@""]) {
                    address = [address stringByAppendingFormat:@", %@",dict[@"StateName"]];
                }
                if (![dict[@"Country"] isKindOfClass:[NSNull class]]) {
                    address = [address stringByAppendingFormat:@", %@",d[@"Country"]];
                }
                if (![d[@"Postal"] isEqualToString:@""]) {
                    address = [address stringByAppendingFormat:@", %@",d[@"Postal"]];
                }
                model.address=address;
            }
         if (![dict[@"DocumentCode"] isKindOfClass:[NSNull class]]) {
            model.documentCode=dict[@"DocumentCode"];
         }
          if (![dict[@"DocumentTypeCode"] isKindOfClass:[NSNull class]]) {
              model.documentTypeCode=dict[@"DocumentTypeCode"];
          }
            NSArray *documentTypeArray=[model.documentTypeCode componentsSeparatedByString:@"|"];
            NSArray *documentCodeArray=[model.documentCode componentsSeparatedByString:@"^$|"];
            for (int i=0; i<documentTypeArray.count; i++) {
                if ([documentTypeArray[i] isEqual:@"ABC123"]) {
                    model.profileImageCode=documentCodeArray[i];
                }
            }
            NSString *Json=dict[@"JSON"];
             if (![Json isKindOfClass:[NSNull class]]) {
            NSData *jsonData1 = [Json dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonDict1 = [NSJSONSerialization JSONObjectWithData:jsonData1 options:kNilOptions error:nil];
                 model.jsonDict=jsonDict1;
                 model.genderCode=jsonDict1[@"Gender"];
                 model.martialCode=jsonDict1[@"MaritalStatus"];
                 model.mobileNo=jsonDict1[@"ContactNo"];
                 model.surgeries=jsonDict1[@"Surgeries"];
                model.tranfusion=jsonDict1[@"Transfusion"];
            [model getJsonDataForMartial:jsonDict1[@"MaritalStatus"] onComplete:^(NSString *martialStatus) {
                model.maritialStatus=martialStatus;
            } onError:^(NSError *error) {
                
            }];
            ContainerViewController *containerVc=(ContainerViewController*)self.parentViewController;
            [model getJsonDataForGender:jsonDict1[@"Gender"] onComplete:^(NSString *genderName) {
                model.gender=genderName;
                [self reloadData];
                if(MBProgressCountToHide==patentnameArray.count){
                    [containerVc hideMBprogressTillLoadThedata];
                }
            } onError:^(NSError *error) {
            }];
            NSDate *date = [dateFormatter dateFromString:model.dob];
            NSDateComponents *agecomponent=[[NSCalendar currentCalendar]components:NSCalendarUnitYear fromDate:date toDate:[NSDate date] options:0];
            model.age=[NSString stringWithFormat:@"%ld",(long)[agecomponent year]];
            }
        model.tranfusion=@"YES";
        model.surgeries=@"";
            [patentnameArray addObject:model];
    }
}
}
-(void)reloadData{
    [_patientListTableView reloadData];
    if (initialSelectedRow==0) {
        NSIndexPath* selectedCellIndexPath= [NSIndexPath indexPathForRow:0 inSection:0];
        [self tableView:_patientListTableView didSelectRowAtIndexPath:selectedCellIndexPath];
    }
   [self tableView:_patientListTableView didSelectRowAtIndexPath:selectedIndexPath];
    MBProgressCountToHide++;
}
-(void)againCallApiAfterAddPatient{
    MBProgressCountToHide=0;
    [patentnameArray removeAllObjects];
    initialSelectedRow=0;
    [self callApi];
}
-(void)againCallApiAfterEditPatient{
    MBProgressCountToHide=0;
    [patentnameArray removeAllObjects];
    initialSelectedRow=-1;
    [self callApi];
}
-(void)reloadTableviewAfterAddNewTreatment{
[self tableView:_patientListTableView didSelectRowAtIndexPath:selectedIndexPath];
}
@end
