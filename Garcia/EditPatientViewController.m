#import "EditPatientViewController.h"
#import "Constant.h"
#import "ContainerViewController.h"
#import "DatePicker.h"
#import "PlaceholderTextView.h"
#import "Postman.h"
#import "PostmanConstant.h"
#import "MBProgressHUD.h"
#import "editModel.h"
#import "ImageUploadAPI.h"
@interface EditPatientViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,datePickerProtocol,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *nameTF;
@property (strong, nonatomic) IBOutlet UITextField *genderTF;
@property (strong, nonatomic) IBOutlet UITextField *maritialStatus;
@property (strong, nonatomic) IBOutlet UITextField *dateOfBirthTF;
@property (strong, nonatomic) IBOutlet UITextField *mobileNoTF;
@property (strong, nonatomic) IBOutlet UITextField *emailTF;
@property (strong, nonatomic) IBOutlet UITableView *gendertableview;
@property (strong, nonatomic) IBOutlet UITableView *maritialTableView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *patientImageView;
- (IBAction)hideKeyboard:(UIControl *)sender;
@property (strong, nonatomic) IBOutlet PlaceholderTextView *addressTextView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *maritialTableHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *genderTvHeight;
@end

@implementation EditPatientViewController
{
    Constant *constant;
    NSMutableArray *genderArray,*MaritialStatusArray;
    ContainerViewController *containerVC;
    DatePicker *datePicker;
    UIControl *activeField;
    Postman *postman;
    UIAlertView *successEditalert,*failureEditAlert;
    NSString *genderCode,*martialCode;
    ImageUploadAPI *imageManager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    constant=[[Constant alloc]init];
    imageManager=[[ImageUploadAPI alloc]init];
    [self textFieldLayer];
    genderArray=[[NSMutableArray alloc]init];
    MaritialStatusArray=[[NSMutableArray alloc]init];
    [self registerForKeyboardNotifications];
     [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background-Image-01.jpg"]]];
    [self defaultValues];
    self.gendertableview.dataSource=self;
    self.gendertableview.delegate=self;
    self.nameTF.delegate=self;
    self.mobileNoTF.delegate=self;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getImage)];
    [_patientImageView addGestureRecognizer:tap];
    [self callApiForGender];
    [self callApiForMaritial];
}
-(void)viewWillAppear:(BOOL)animated{
    UINavigationController *nav=(UINavigationController*)self.parentViewController;
    containerVC=(ContainerViewController*)nav.parentViewController;
    [containerVC setTitle:@"Edit"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
//default values
-(void)defaultValues{
    _nameTF.text=_model.name;
     _genderTF.text=_model.gender;
     _maritialStatus.text=_model.maritialStatus;
     _dateOfBirthTF.text=_model.dob;
    _mobileNoTF.text=_model.mobileNo;
     _emailTF.text=_model.emailId;
     _addressTextView.text=_model.address;
    martialCode=_model.martialCode;
    genderCode=_model.genderCode;
    _patientImageView.image=_model.profileImage;
}
- (IBAction)cancel:(id)sender {
[self.navigationController popViewControllerAnimated:YES];
}
//Save the data
- (IBAction)save:(id)sender {
    [self validateEmail:_emailTF.text];
}
//maritialStatus field
- (IBAction)maritalStatus:(id)sender {
    _gendertableview.hidden=YES;
    _maritialTableView.hidden=NO;
    [self.view endEditing:YES];
    [_maritialTableView reloadData];
    [_scrollView layoutIfNeeded];
    _maritialTableHeight.constant=_maritialTableView.contentSize.height;
}
//DateOfBirth Field
- (IBAction)dateOfBirth:(id)sender {
    _gendertableview.hidden=YES;
    _maritialTableView.hidden=YES;
    if(datePicker==nil)
        datePicker= [[DatePicker alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+100, self.view.frame.origin.y+230,self.view.frame.size.width-200,230)];
   datePicker.datePicker.maximumDate=[NSDate date];
    [datePicker alphaViewInitialize];
    datePicker.delegate=self;
}
-(void)selectingDatePicker:(NSString *)date{
    _dateOfBirthTF.text=date;
}
//gender Field
- (IBAction)gender:(id)sender {
    [self.view endEditing:YES];
     _maritialTableView.hidden=YES;
    _gendertableview.hidden=NO;
    [_gendertableview reloadData];
    [_scrollView layoutIfNeeded];
    _genderTvHeight.constant=_gendertableview.contentSize.height;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
//TableView Number of row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.gendertableview])
    {
        return genderArray.count;
        
    }
    else if ([tableView isEqual:self.maritialTableView])
    return MaritialStatusArray.count;
    else
        return 10;
    
}
//TableView cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if ([tableView isEqual:self.gendertableview]) {
        editModel *model=genderArray[indexPath.row];
        cell.textLabel.text=model.genderName;
        [constant setFontForLabel:cell.textLabel];
    }
    else if ([tableView isEqual:self.maritialTableView]){
          editModel *model=MaritialStatusArray[indexPath.row];
        cell.textLabel.text=model.martialStatusName;
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
    
    if ([self.gendertableview isEqual:tableView ])
   {
        editModel *model=genderArray[indexPath.row];
        _genderTF.text=model.genderName;
        genderCode=model.genderCode;
        _gendertableview.hidden=YES;
    }
    else if([self.maritialTableView isEqual:tableView ])
    {
         editModel *model=MaritialStatusArray[indexPath.row];
        _maritialStatus.text=model.martialStatusName;
        martialCode=model.martialCode;
        _maritialTableView.hidden=YES;
    }
}
//cell Color
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
 [cell setBackgroundColor:[UIColor colorWithRed:0.73 green:0.76 blue:0.91 alpha:1]];
}
//Hide KeyBoard
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
//set layesr for TextField and placeHolder
-(void)textFieldLayer{
    _patientImageView.layer.cornerRadius=_patientImageView.frame.size.width/2;
    _patientImageView.layer.masksToBounds = YES;
    _nameTF.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Name"];
    _emailTF.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Email"];
    _genderTF.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Gender"];
    _mobileNoTF.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Mobile"];
    _maritialStatus.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Marital Status"];
    _dateOfBirthTF.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Date Of Birth"];
    _addressTextView.placeholder=@"Address";
    [constant spaceAtTheBeginigOfTextField:_genderTF];
    [constant spaceAtTheBeginigOfTextField:_emailTF];
    [constant spaceAtTheBeginigOfTextField:_nameTF];
    [constant spaceAtTheBeginigOfTextField:_maritialStatus];
    [constant spaceAtTheBeginigOfTextField:_dateOfBirthTF];
    [constant spaceAtTheBeginigOfTextField:_mobileNoTF];
    [constant SetBorderForTextField:_genderTF];
    [constant SetBorderForTextField:_mobileNoTF];
    [constant SetBorderForTextField:_maritialStatus];
    [constant SetBorderForTextField:_emailTF];
    [constant SetBorderForTextview:_addressTextView];
    [constant SetBorderForTextField:_nameTF];
    [constant SetBorderForTextField:_dateOfBirthTF];
    [constant setFontFortextField:_nameTF];
    [constant setFontFortextField:_genderTF];
    [constant setFontFortextField:_emailTF];
    [constant setFontFortextField:_maritialStatus];
    [constant setFontFortextField:_dateOfBirthTF];
    [constant setFontFortextField:_mobileNoTF];
    _addressTextView.textContainerInset = UIEdgeInsetsMake(10, 5, 10, 10);
}
//textField Begin Editing
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
    _maritialTableView.hidden=YES;
    _gendertableview.hidden=YES;
    if (activeField==self.mobileNoTF)
    {
        if (self.mobileNoTF.text.length==0)
        {
        //            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter the phone number" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            //            [alert show];
        }
        else if (self.mobileNoTF.text.length==10 && [self myMobileNumberValidate:self.mobileNoTF.text])
        {
            
            
        }
    }
}
//textField EndEditing
- (void)textFieldDidEndEditing:(UITextField *)textFieldcs
{
    activeField = nil;
}
//TextView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    _maritialTableView.hidden=YES;
    _gendertableview.hidden=YES;
    //activeField = textView;
}
//textField EndEditing
- (void)textViewDidEndEditing:(UITextView *)textView{
    activeField = nil;
}
//Mobile number valid
- (BOOL)myMobileNumberValidate:(NSString*)number
{
    NSString *numberRegEx = @"[1-9]{1}[0-9]{9}";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegEx];
    if ([numberTest evaluateWithObject:number] == YES)
        return YES;
    else
        return NO;
}
//Age Valid
- (BOOL)myAgeValidate:(NSString*)number
{
    NSString *numberRegEx = @"[0-9]{2}";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegEx];
    if ([numberTest evaluateWithObject:number] == YES)
        return YES;
    else
        return NO;
}
//Move the TextField Up
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}
//KeyBoard Shown
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:activeField.frame animated:YES];
    }
}
//Keyboard Hidden
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets =UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
}
//get image
-(void)getImage{
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate=self;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
   


}
//image picker delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
 UIImage *profileImage =info[UIImagePickerControllerOriginalImage];
       _patientImageView.image=profileImage;
    containerVC.viewControllerDiffer=@"Edit";
      [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self saveImage:profileImage];
}
// hide keyboard
- (IBAction)hideKeyboard:(UIControl *)sender
{
    [self.view endEditing:YES];
    _maritialTableView.hidden=YES;
    _gendertableview.hidden=YES;
}

//Gesture Method
- (IBAction)gesture:(id)sender {
    [self.view endEditing:YES];
}
//Gender API
-(void)callApiForGender{
   postman=[[Postman alloc]init];
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,getGender];
      [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [postman get:url withParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self prcessGenderObject:responseObject];
      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}
//response object for gender
-(void)prcessGenderObject:(id)responseObject{
    NSDictionary *dict=responseObject;
    for (NSDictionary *dict1 in dict[@"GenericSearchViewModels"]) {
        if ([dict1[@"Status"]intValue]==1) {
            editModel *editModelValue=[[editModel alloc]init];
            editModelValue.genderName=dict1[@"Name"];
            editModelValue.genderCode=dict1[@"Code"];
            [genderArray addObject:editModelValue];
        }
    }
}
//Martial API
-(void)callApiForMaritial{
  postman =[[Postman alloc]init];
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,getMartialStatus];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [postman get:url withParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
       [self prcessMartialObject:responseObject];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}
//for martial api
-(void)prcessMartialObject:(id)responseObject{
    NSDictionary *dict=responseObject;
    for (NSDictionary *dict1 in dict[@"GenericSearchViewModels"]) {
        if ([dict1[@"Status"]intValue]==1) {
             editModel *editModelValue=[[editModel alloc]init];
            editModelValue.martialStatusName= dict1[@"Name"];
            editModelValue.martialCode=dict1[@"Code"];
            [MaritialStatusArray addObject:editModelValue];
        }
    }
}
//Patient Update
-(void)callApiForUpdate{
    postman =[[Postman alloc]init];
   NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"AddressLine1"]=_model.addressLine1;
    dict[@"AddressLine2"]=_model.addressline2;
     dict[@"Country"]=_model.country;
     dict[@"State"]=_model.state;
     dict[@"City"]=_model.city;
     dict[@"Postal"]=_model.pinCode;
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    dict1[@"AddressLine1"]=_addressTextView.text;
    dict1[@"AddressLine2"]=@"";
    dict1[@"Country"]=@"";
    dict1[@"State"]=@"";
    dict1[@"City"]=@"";
    dict1[@"Postal"]=@"";
    NSMutableDictionary *address=[[NSMutableDictionary alloc]init];
    address[@"PermanentAddress"]=dict;
    address[@"TemporaryAddress"]=dict1;
    NSData *jsonData1 = [NSJSONSerialization dataWithJSONObject:address options:kNilOptions error:nil];
    NSString *temporaryAddress = [[NSString alloc] initWithData:jsonData1 encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *jsonWithGender=[self.model.jsonDict mutableCopy];
    
    jsonWithGender[@"Gender"]=genderCode;
    
    jsonWithGender[@"MaritalStatus"]=martialCode;
    
    jsonWithGender[@"ContactNo"]=_mobileNoTF.text;
    
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:jsonWithGender options:kNilOptions error:nil];
    
    NSString *genderData = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
    NSMutableDictionary *parameterDict=[[NSMutableDictionary alloc]init];
    NSDateFormatter *format=[[NSDateFormatter alloc]init];
    [format setDateFormat:@"dd-MMM-yyyy"];
    NSDate *Dobdate=[format dateFromString:_dateOfBirthTF.text];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *dobString=[format stringFromDate:Dobdate];
    parameterDict[@"Address"]=temporaryAddress;
    parameterDict[@"Email"]=_emailTF.text;
    parameterDict[@"FirstName"]=_nameTF.text;
    parameterDict[@"DOB"]=dobString;
    parameterDict[@"JSON"]=genderData;
    parameterDict[@"Status"]=@"true";
    parameterDict[@"Id"]=_model.Id;
    parameterDict[@"Code"]=_model.code;
    parameterDict[@"UserTypeCode"]=_model.userTypeCode;
    parameterDict[@"CompanyCode"]=_model.companyCode;
    parameterDict[@"Username"]=_emailTF.text;
    parameterDict[@"MethodType"]=@"PUT";
    parameterDict[@"UserID"]=_model.userID;
    parameterDict[@"MiddleName"]=@"";
    parameterDict[@"LastName"]=@"";
     parameterDict[@"RoleCode"]=[NSNull null];

     NSString *url=[NSString stringWithFormat:@"%@%@%@",baseUrl,editPatient,_model.Id];
    NSData *parameterData = [NSJSONSerialization dataWithJSONObject:parameterDict options:NSJSONWritingPrettyPrinted error:nil];
     NSString *parameter = [[NSString alloc] initWithData:parameterData encoding:NSUTF8StringEncoding];
    [containerVC showMBprogressTillLoadThedata];
    [postman put:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processResponseObjectForEdit:responseObject];
        [containerVC hideAllMBprogressTillLoadThedata];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [containerVC hideAllMBprogressTillLoadThedata];
    }];
}
//process response object for edit
-(void)processResponseObjectForEdit:(id)responseObject{
    NSDictionary *dict=responseObject;
    if ([dict[@"Success"] intValue]==1) {
     successEditalert =[[UIAlertView alloc]initWithTitle:@"" message:dict[@"Message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [successEditalert show];
    }
    else {
        failureEditAlert =[[UIAlertView alloc]initWithTitle:@"" message:dict[@"Message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [failureEditAlert show];
    }
    
}
//UIAlertView
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView isEqual:successEditalert]) {
        [self.delegate successfullyEdited];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//validate email
-(void)validateEmail:(NSString*)email{
    NSString *emailRegEx=@"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest=[NSPredicate predicateWithFormat:@"self matches %@",emailRegEx];
    BOOL validate= [emailTest evaluateWithObject:email];
    if (!validate) {
       int a= [self validPhonenumber:_mobileNoTF.text];
        if (a==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Invalid email id and mobile number" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Invalid email id" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else{
            int a= [self validPhonenumber:_mobileNoTF.text];
            if (a==0) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Invalid mobile number" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            else [self callApiForUpdate];
        }
}
//validate phone number
-(int)validPhonenumber:(NSString *)string
{
    NSString *phoneRegex = @"[0-9]{0,10}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL validatePhone=[phoneTest evaluateWithObject:string];
    if ((string.length!=10) | !validatePhone) {
        return 0;
    }
    else return 1;
}
//save profile
- (void)saveImage: (UIImage*)image
{
    if (image != nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:@"EdittedProfile.jpeg" ];
        //        NSData* data = UIImagePNGRepresentation(image);
        NSData* data = UIImageJPEGRepresentation(image, .5);
        [data writeToFile:path atomically:YES];
        [self uploadUserImagePath:path forRequestCode:_model.code onCompletion:^(BOOL success){
        if (success)
            {
        
            }else
            {
                
            }
        }];
    }
}


- (void)uploadUserImagePath:(NSString *)imagePath forRequestCode:(NSString *)reqCode onCompletion:(void (^)(BOOL))completionHandler
{
    [self uploadImagePath:imagePath forRequestCode:reqCode withType:@"User" onCompletion:completionHandler];
}




- (void)uploadImagePath:(NSString *)imagePath forRequestCode:(NSString *)reqCode withType:(NSString *)type onCompletion:(void (^)(BOOL))completionHandler
{
    if ([reqCode isKindOfClass:[NSNull class]])
    {
        return;
    }
    if (reqCode.length == 0)
    {
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
  
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"multipart/form-data"];
    
    NSString *jsonString = [NSString stringWithFormat:@"{\"RequestCode\":\"%@\",\"RequestType\":\"%@\",\"DocumentType\":\"ABC123\"}", reqCode, type];
    NSDictionary *parameter = @{@"request" : jsonString};
   
  
    
//    NSDictionary *parameter = @{@"RequestCode":@"HCTI1B",@"RequestType":@"User",@"DocumentType":@"ABC123"};
    
    
   // NSString *URLString = [NSString stringWithFormat:@"%@%@", baseUrl,uploadFile];
    NSString *URLString = @"http://prithiviraj.vmokshagroup.com:8033/api/upload";
    
    [manager POST:URLString parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:imagePath]
                                   name:@"Files"
                                  error:nil];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Success %@", operation.responseString);
        // [self  parseData:responseObject withHandler:completionHandler];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error %@ \n  Response %@", error, operation.responseString);
        completionHandler(NO);
    }];
}

@end
