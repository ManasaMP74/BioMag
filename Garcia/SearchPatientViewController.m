#import "SearchPatientViewController.h"
#import "SearchPatientTableViewCell.h"
#import "Constant.h"
#import "ContainerViewController.h"
#import "MBProgressHUD.h"
#import "searchPatientModel.h"
#import "SeedSyncer.h"
#import <MCLocalization/MCLocalization.h>
@interface SearchPatientViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UILabel *addPatientLabel;

@property (weak, nonatomic) IBOutlet UITableView *patientListTableView;

- (IBAction)hideKeyboard:(UIControl *)sender;
@end
@implementation SearchPatientViewController
{
    NSMutableArray *patentFilteredArray;
    Constant *constant;
    NSString *selectedPatientCode;
    NSMutableArray *patentnameArray,*completePatientNameArray;
    NSIndexPath *selectedIndexPath;
    PostmanConstant *postmanConstant;
    Postman *postman;
    NSDateFormatter *dateFormatter;
    int initialSelectedRow,MBProgressCountToHide;
    NSString *search,*addPatient;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    initialSelectedRow=0;
    selectedPatientCode=@"";
    postman=[[Postman alloc]init];
    postmanConstant=[[PostmanConstant alloc]init];
    constant=[[Constant alloc]init];
    [self localize];
    [_searchTextField addTarget:self action:@selector(searchDoctorOnProfession) forControlEvents:UIControlEventEditingChanged];
    [constant spaceAtTheBeginigOfTextField:_searchTextField];
    _searchTextField.attributedPlaceholder=[constant textFieldPlaceHolderText:search];
    _addPatientLabel.text=addPatient;
    _searchTextField.layer.cornerRadius=18;
    _searchTextField.layer.borderColor=[UIColor colorWithRed:0.004 green:0.216 blue:0.294 alpha:0.5].CGColor;
    _searchTextField.layer.borderWidth=1;
    selectedIndexPath=nil;
    patentnameArray=[[NSMutableArray alloc]init];
    completePatientNameArray=[[NSMutableArray alloc]init];
    patentFilteredArray=[[NSMutableArray alloc]init];
      dateFormatter=[[NSDateFormatter alloc]init];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background-Image-2.jpg"]]];
    [constant setFontFortextField:_searchTextField];
    _patientListTableView.tableFooterView=[UIView new];
    if (patentnameArray.count==0) {
        MBProgressCountToHide=0;
        [self callSeed];
    }
}
-(void)callSeed{
//    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
//        //Api For Vzone
//        [self callApi];
//    }else{
//      //  API for material
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        if ([userDefault boolForKey:@"user_FLAG"]) {
            [self callApiforOffsetApi];
            [self callApi:NO];
        }
        else{
            NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,getPatientList];
           NSString *parameter=[NSString stringWithFormat:@"{\"UserTypeCode\":\"PAT123\"}"];
           NSString *strforComplete=[NSString stringWithFormat:@"%@ %@",url,parameter];

            
            NSString *urlForPaging=[NSString stringWithFormat:@"%@%@",baseUrl,getPagingPatientList];
           NSString * parameterPaging=[NSString stringWithFormat:@"{\"request\":{\"Start\": 0,\"End\": 100}}"];
            NSString *strforPaging=[NSString stringWithFormat:@"%@ %@",urlForPaging,parameterPaging];

                
            //for complete User Data APi
            [[SeedSyncer sharedSyncer]getResponseFor:strforComplete completionHandler:^(BOOL success, id response) {
                if (success) {
                    [self processResponseObject:response];
                     [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
                }
                else{
                    [[SeedSyncer sharedSyncer]getResponseFor:strforPaging completionHandler:^(BOOL success, id response) {
                        if (success) {
                            [self processResponseObjectforOffsetApi:response];
                            [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
                        }
                        else{
                            [self callApiforOffsetApi];
                            [self callApi:NO];
                        }
                    }];
                }
            }];
        }
   // }
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
    searchPatientModel *model;
    if ([_searchTextField.text isEqualToString:@""]) {
        model = patentnameArray[indexPath.row];
    }
    else
    {
        model = patentFilteredArray[indexPath.row];
    }
   
//        NSString *str=[NSString stringWithFormat:@"%@%@%@",baseUrl,getProfile,model.profileImageCode];
//    [cell.patientImageView setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"Patient-img.jpg"]];
//    
    
    
    NSString *strimageUrl;
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        strimageUrl = [NSString stringWithFormat:@"%@%@%@/EdittedProfile.jpeg",baseUrlAws,dbName,model.storageID];
        
    }else
    {
        strimageUrl = [NSString stringWithFormat:@"%@%@%@",baseUrl,getProfile,model.profileImageCode];
        
    }

    [cell.patientImageView setImageWithURL:[NSURL URLWithString:strimageUrl] placeholderImage:[UIImage imageNamed:@"Patient-img.jpg"]];
    
    
    
    cell.patientNameLabel.text = model.name;
    cell.patientNameLabel.font=[UIFont fontWithName:@"OpenSans-Bold" size:14];
    if ([selectedIndexPath isEqual:indexPath]) {
        cell.patientNameLabel.textColor=[UIColor colorWithRed:0.7098 green:0.99 blue:0.98 alpha:1];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow-3"]];
    }
    else {
        cell.accessoryView = [[UIImageView alloc] initWithImage:nil];
        cell.patientNameLabel.textColor=[UIColor whiteColor];
    }
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
//cell select
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
      ContainerViewController *containerVc =(ContainerViewController*)self.parentViewController;
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
        searchPatientModel *model;
        if ([_searchTextField.text isEqualToString:@""]) {
            model =patentnameArray[indexPath.row];
            selectedPatientCode=model.code;
        }
        else{
            if (patentFilteredArray.count>0) {
                model=patentFilteredArray[indexPath.row];
                selectedPatientCode=model.code;
            }
        }
        model.profileImage=cell.patientImageView.image;
        cell.patientNameLabel.textColor=[UIColor colorWithRed:0.7098 green:0.99 blue:0.98 alpha:1];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow-3"]];
        containerVc.viewControllerDiffer=@"";
        if ([_searchTextField.text isEqual:@""]) {
            [containerVc passDataFromsearchPatientTableViewToPatient:patentnameArray[indexPath.row]];
            
        }
        else [containerVc passDataFromsearchPatientTableViewToPatient:patentFilteredArray[indexPath.row]];
    }
}
//Search
-(void)searchDoctorOnProfession
{
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
        if ([selectedPatientCode isEqualToString:@""]) {
            if (patentFilteredArray.count>0) {
                NSIndexPath* selectedCellIndexPath= [NSIndexPath indexPathForRow:0 inSection:0];
                [self tableView:_patientListTableView didSelectRowAtIndexPath:selectedCellIndexPath];
            }
        }else{
            [_patientListTableView reloadData];
            NSIndexPath* selectedCellIndexPath= [NSIndexPath indexPathForRow:0 inSection:0];
            if (patentFilteredArray.count>0) {
                [self tableView:_patientListTableView didSelectRowAtIndexPath:selectedCellIndexPath];
            }
        }
    }else{
        [_patientListTableView reloadData];
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
    selectedIndexPath=nil;
    [_patientListTableView reloadData];
    ContainerViewController *containerVc =(ContainerViewController*)self.parentViewController;
    [containerVc ChangeTheContainerViewViewController];
}
-(void)hideKeyBoard{
    [self.view endEditing:YES];
}

//CallAPI for complete patient
-(void)callApi:(BOOL)staus
{
      ContainerViewController *containerVc =(ContainerViewController*)self.parentViewController;
    NSString *parameter;
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,getPatientList];

    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
   parameter=[NSString stringWithFormat:@"{\"UserTypeCode\":\"PAT123\"}"];
    }else{
     parameter=[NSString stringWithFormat:@"{\"UserTypeCode\":\"PAT123\"}"];
        [containerVc showMBprogressTillLoadThedata];
    }
    if (staus) {
        [containerVc showMBprogressTillLoadThedata];
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:NO];
    }
    [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processResponseObject:responseObject];
        NSString *str=[NSString stringWithFormat:@"%@ %@",url,parameter];
        [[SeedSyncer sharedSyncer]saveResponse:[operation responseString] forIdentity:str];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setBool:NO forKey:@"user_FLAG"];
        if (staus) {
            [containerVc hideAllMBprogressTillLoadThedata];
        }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self showAlerView:[NSString stringWithFormat:@"%@",error]];
            if (staus) {
                [containerVc hideAllMBprogressTillLoadThedata];
                [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
            }
    }];
}

//Response for API complete patient
-(void)processResponseObject:(id)responseObject{
    NSDictionary *dict1;
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        NSDictionary *responseDict1 = responseObject;
        dict1=responseDict1[@"aaData"];
    }
    else dict1=responseObject;
    
    if ([dict1[@"Success"] intValue]==1) {
        [patentnameArray removeAllObjects];
        for (NSDictionary *dict in dict1[@"ViewModels"]) {
            if ([dict[@"Status"]intValue]==1) {
            searchPatientModel *model=[[searchPatientModel alloc]init];
            if (![dict[@"Lastname"] isEqualToString:@""]) {
                model.name=[NSString stringWithFormat:@"%@ %@",dict[@"Firstname"],dict[@"Lastname"]];
            }else
                model.name=[NSString stringWithFormat:@"%@",dict[@"Firstname"]];
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
            if (![dict[@"Gender"] isKindOfClass:[NSNull class]]) {
                model.gender=dict[@"Gender"];
            }
            if (![dict[@"MaritalStatus"] isKindOfClass:[NSNull class]]) {
                model.maritialStatus=dict[@"MaritalStatus"];
            }
            if (![dict[@"StorageID"] isKindOfClass:[NSNull class]]) {
                model.storageID=dict[@"StorageID"];
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
                NSDate *date = [dateFormatter dateFromString:model.dob];
                NSDateComponents *agecomponent=[[NSCalendar currentCalendar]components:NSCalendarUnitYear fromDate:date toDate:[NSDate date] options:0];
                model.age=[NSString stringWithFormat:@"%ld",(long)[agecomponent year]];
            }
            [patentnameArray addObject:model];
            }
        }
    }
     [self reloadData];
}
//CallAPI for 100 offset patient
-(void)callApiforOffsetApi
{
    ContainerViewController *containerVc =(ContainerViewController*)self.parentViewController;
    NSString *parameter;
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,getPagingPatientList];
    
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        parameter=[NSString stringWithFormat:@"{\"request\":{\"Start\": 0,\"End\": 40}}"];
    }else{
        parameter=[NSString stringWithFormat:@"{\"UserTypeCode\":\"PAT123\"}"];
    }
     [containerVc showMBprogressTillLoadThedata];
     [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:NO];
    [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processResponseObjectforOffsetApi:responseObject];
        NSString *str=[NSString stringWithFormat:@"%@ %@",url,parameter];
        [[SeedSyncer sharedSyncer]saveResponse:[operation responseString] forIdentity:str];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setBool:NO forKey:@"user_FLAG"];
        [containerVc hideAllMBprogressTillLoadThedata];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showAlerView:[NSString stringWithFormat:@"%@",error]];
        [containerVc hideAllMBprogressTillLoadThedata];
          [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
    }];
}

//Response for API 100 offset patient
-(void)processResponseObjectforOffsetApi:(id)responseObject{
    NSDictionary *dict1;
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        NSDictionary *responseDict1 = responseObject;
        dict1=responseDict1[@"aaData"];
    }
    else dict1=responseObject;
    for (NSDictionary *dict in dict1[@"GenericSearchViewModels"]) {
            if ([dict[@"Status"]intValue]==1) {
                searchPatientModel *model=[[searchPatientModel alloc]init];
                if (![dict[@"Lastname"] isEqualToString:@""]) {
                    model.name=[NSString stringWithFormat:@"%@ %@",dict[@"Firstname"],dict[@"Lastname"]];
                }else
                    model.name=[NSString stringWithFormat:@"%@",dict[@"Firstname"]];
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
                if (![dict[@"Gender"] isKindOfClass:[NSNull class]]) {
                    model.gender=dict[@"Gender"];
                }
                if (![dict[@"MaritalStatus"] isKindOfClass:[NSNull class]]) {
                    model.maritialStatus=dict[@"MaritalStatus"];
                }
                if (![dict[@"StorageID"] isKindOfClass:[NSNull class]]) {
                    model.storageID=dict[@"StorageID"];
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
                    NSDate *date = [dateFormatter dateFromString:model.dob];
                    NSDateComponents *agecomponent=[[NSCalendar currentCalendar]components:NSCalendarUnitYear fromDate:date toDate:[NSDate date] options:0];
                    model.age=[NSString stringWithFormat:@"%ld",(long)[agecomponent year]];
                }
                [patentnameArray addObject:model];
                if (patentnameArray.count==1) {
                    if (initialSelectedRow==0) {
                         initialSelectedRow=1;
                        searchPatientModel *model=patentnameArray[0];
                        selectedPatientCode=model.code;
                        NSIndexPath* selectedCellIndexPath= [NSIndexPath indexPathForRow:0 inSection:0];
                        [self tableView:_patientListTableView didSelectRowAtIndexPath:selectedCellIndexPath];
                    }
                }
            }
        }
        [self reloadData];
}

- (void)reloadData
{
    if (![_searchTextField.text isEqualToString:@""]) {
        [self searchDoctorOnProfession];
        [self selectedCell:patentFilteredArray];
    } else{
        [_patientListTableView reloadData];
        if (initialSelectedRow!=0){
            [self selectedCell:patentnameArray];
        } else if (initialSelectedRow==0) {
            searchPatientModel *model=patentnameArray[0];
            selectedPatientCode=model.code;
            NSIndexPath* selectedCellIndexPath= [NSIndexPath indexPathForRow:0 inSection:0];
            [self tableView:_patientListTableView didSelectRowAtIndexPath:selectedCellIndexPath];
        }

    }
    MBProgressCountToHide++;
}
-(void)selectedCell:(NSArray*)ar{
    for (int i=0; i<ar.count; i++) {
        searchPatientModel *m=ar[i];
        if ([selectedPatientCode isEqualToString:m.code]) {
            NSIndexPath* selectedCellIndexPath= [NSIndexPath indexPathForRow:i inSection:0];
            [self tableView:_patientListTableView didSelectRowAtIndexPath:selectedCellIndexPath];
        }
    }
}
-(void)againCallApiAfterAddPatient:(NSString *)code{
    if (![code isEqualToString:@""]) {
        MBProgressCountToHide=0;
        [patentnameArray removeAllObjects];
        selectedPatientCode=code;
        _searchTextField.text=@"";
        initialSelectedRow=-1;
        [self callApi:YES];
    }else{
        if (patentnameArray.count>0)
        [self tableView:_patientListTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
}
-(void)againCallApiAfterEditPatient:(NSString *)code{
    MBProgressCountToHide=0;
    _searchTextField.text=@"";
    selectedPatientCode=code;
    [patentnameArray removeAllObjects];
    initialSelectedRow=1;
    [self callApi:YES];
}
-(void)reloadTableviewAfterAddNewTreatment{
    [self tableView:_patientListTableView didSelectRowAtIndexPath:selectedIndexPath];
}
//Alert Message
-(void)showAlerView:(NSString*)msg{
    UIAlertController *alertView=[UIAlertController alertControllerWithTitle:@"Alert!" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *success=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
        [alertView dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertView addAction:success];
    [self presentViewController:alertView animated:YES completion:nil];
}
-(void)localize{
    search=[MCLocalization stringForKey:@"Search"];
    addPatient=[MCLocalization stringForKey:@"Add Patient"];
}
@end
