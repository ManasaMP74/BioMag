#import "AddPatientViewController.h"
#import "Constant.h"
#import "ContainerViewController.h"
#import "DatePicker.h"
#import "PlaceholderTextView.h"
#import "Postman.h"
#import "PostmanConstant.h"
#import "MBProgressHUD.h"
#import "editModel.h"
#import "ImageUploadAPI.h"
#import "SeedSyncer.h"
#import <MCLocalization/MCLocalization.h>
@interface AddPatientViewController ()<datePickerProtocol,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *nameTF;
@property (strong, nonatomic) IBOutlet UITextField *genderTF;
@property (strong, nonatomic) IBOutlet UITextField *maritialStatus;
@property (strong, nonatomic) IBOutlet UITextField *dateOfBirthTF;
@property (strong, nonatomic) IBOutlet UITextField *mobileNoTF;
@property (strong, nonatomic) IBOutlet UITextField *emailTF;
@property (strong, nonatomic) IBOutlet UITableView *gendertableview;
@property (strong, nonatomic) IBOutlet UITableView *maritialTableView;
@property (strong, nonatomic) IBOutlet PlaceholderTextView *addressTextView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *addView;
@property (strong, nonatomic) IBOutlet UIImageView *patientImageView;
- (IBAction)hideKeyboard:(UIControl *)sender;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *maritialTVHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *genderTVheight;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@end

@implementation AddPatientViewController
{
    Constant *constant;
    NSMutableArray *genderArray,*MaritialStatusArray;
    DatePicker *datePicker;
    UIControl *activeField;
    Postman *postman;
    NSString *genderCode,*martialCode,*addedPatientCode;
    ImageUploadAPI *imageManager;
    ContainerViewController *containerVC;
     NSString *alertOkStr,*alertStr,*saveFailedStr,*saveSuccessfullyStr,*requiredGenderFieldStr,*requiredNameField,*navTitle,*yesStr,*noStr,*requiredDateOfBirth,*requiredEmail,*requiredmobile,*requiredTransfusion,*invalidEmail,*invalidMobile;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    constant=[[Constant alloc]init];
    imageManager=[[ImageUploadAPI alloc]init];
    [self setFont];
    [self localize];
    [self textFieldLayer];
    genderArray=[[NSMutableArray alloc]init];
    MaritialStatusArray=[[NSMutableArray alloc]init];
    UINavigationController *nav=(UINavigationController*)self.parentViewController;
    if (nav.parentViewController==NULL) {
         self.title=navTitle;
    }
    else{
        containerVC=(ContainerViewController*)nav.parentViewController;
        [containerVC setTitle:navTitle];
    }
     [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background-Image-1.jpg"]]];
     [self registerForKeyboardNotifications];
    self.addressTextView.delegate=self;
    MaritialStatusArray=[@[yesStr,noStr]mutableCopy];
    
//    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
//        //For Vzone API
//        [self callApiForGender];
//    }else{
//        //For Material Api
    
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        if ([userDefault boolForKey:@"gender_FLAG"]) {
            [self callApiForGender];
        }
        else{
            NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,getGender];
            [[SeedSyncer sharedSyncer]getResponseFor:url completionHandler:^(BOOL success, id response) {
                if (success) {
                    [self prcessGenderObject:response];
                }
                else{
                    [self callApiForGender];
                }
            }];
        }
  //  }

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [constant changeSaveBtnImage:_saveBtn];
    [constant changeCancelBtnImage:_cancelBtn];
    _patientImageView.layer.cornerRadius=_patientImageView.frame.size.width/2;
    _patientImageView.clipsToBounds=YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//cancel
- (IBAction)cancel:(id)sender {
     addedPatientCode=@"";
    [self.delegate successfullyAdded:addedPatientCode];
    [self.navigationController popViewControllerAnimated:YES];
}
//Save the data
- (IBAction)save:(id)sender {
    [self.view endEditing:YES];
    [self validateEmail:_emailTF.text];
}
//maritialStatus field
- (IBAction)maritalStatus:(id)sender {
     [self.view endEditing:YES];
    _gendertableview.hidden=YES;
    _maritialTableView.hidden=NO;
    [_maritialTableView reloadData];
}
//DateOfBirth Field
- (IBAction)dateOfBirth:(id)sender {
    [self.view endEditing:YES];
    _gendertableview.hidden=YES;
    _maritialTableView.hidden=YES;
    if(datePicker==nil)
        datePicker= [[DatePicker alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+100, self.view.frame.origin.y+230,self.view.frame.size.width-200,230)];
    datePicker.datePicker.maximumDate=[NSDate date];
    [datePicker alphaViewInitialize];
    datePicker.delegate=self;
}
//datepicker Delegate
-(void)selectingDatePicker:(NSString *)date{
    _dateOfBirthTF.text=date;
}

//gender Field
- (IBAction)gender:(id)sender {
    [self.view endEditing:YES];
    _gendertableview.hidden=NO;
    _maritialTableView.hidden=YES;
    [_gendertableview reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
//TableView Number of row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
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
        _genderTVheight.constant=_gendertableview.contentSize.height;
    }
    else if ([tableView isEqual:self.maritialTableView]){
        cell.textLabel.text=MaritialStatusArray[indexPath.row];
        [constant setFontForLabel:cell.textLabel];
         _maritialTVHeight.constant=_maritialTableView.contentSize.height;
    }
    else {
        UILabel *label=(UILabel*)[cell viewWithTag:10];
        [constant setFontForLabel:label];
    }
    tableView.tableFooterView=[UIView new];
    cell.backgroundColor=[UIColor colorWithRed:0.933 green:0.933 blue:0.941 alpha:1];
    cell.separatorInset=UIEdgeInsetsZero;
    cell.layoutMargins=UIEdgeInsetsZero;
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
        _maritialStatus.text=MaritialStatusArray[indexPath.row];
     _maritialTableView.hidden=YES;
    }
}
//cell Color
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
   //[cell setBackgroundColor:[UIColor colorWithRed:0.73 green:0.76 blue:0.91 alpha:1]];
 [cell setBackgroundColor:[UIColor colorWithRed:0.933 green:0.933 blue:0.941 alpha:1]];

}
//Hide KeyBoard
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
//textField Begin Editing
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    _maritialTableView.hidden=YES;
    _gendertableview.hidden=YES;
      activeField = textField;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL status=YES;
    
    if ([textField isEqual:_mobileNoTF]) {
        if (_mobileNoTF.text.length>15) {
            if (string.length==0) {
                status=YES;
            }
            else status=NO;
        }
        else{
            NSCharacterSet * numberCharSet = [NSCharacterSet characterSetWithCharactersInString:@"()+-0123456789"];
            for (int i = 0; i < [string length]; ++i)
            {
                unichar c = [string characterAtIndex:i];
                if (![numberCharSet characterIsMember:c])
                {
                    status= NO;
                }
            }
        }
    }
    return status;
}
//set layesr for TextField and placeHolder
-(void)textFieldLayer{
//    _patientImageView.layer.cornerRadius=_patientImageView.frame.size.width/2;
//    _patientImageView.clipsToBounds=YES;
    _addView.layer.cornerRadius=5;
    [constant getTheAllSaveButtonImage:_saveBtn];
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
     _addressTextView.textContainerInset = UIEdgeInsetsMake(10,5,10, 10);
    self.addressTextView.backgroundColor=[UIColor whiteColor];
}
//setfont for label
-(void)setFont{
    [constant setFontForLabel:_genderLabel];
    [constant setFontForLabel:_nameLabel];
    [constant setFontForLabel:_transfusionLabel];
    [constant setFontForLabel:_dobLabel];
    [constant setFontForLabel:_surgeriesLabel];
    [constant setFontForLabel:_emailLabel];
    [constant setFontForLabel:_mobNumbLabel];
}
//Move the TextField Up
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}
//Keyboard shown
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
//TextVie Delegate Method
- (void)textViewDidBeginEditing:(UITextView *)textView{
    _maritialTableView.hidden=YES;
    _gendertableview.hidden=YES;
    //activeField = textView;
}
//TextVie Delegate Method
- (void)textViewDidEndEditing:(UITextView *)textView{
    activeField = nil;
}
//hide keyboard
- (IBAction)hideKeyboard:(UIControl *)sender
{
    [self.view endEditing:YES];
    _maritialTableView.hidden=YES;
    _gendertableview.hidden=YES;
}
//get image
- (IBAction)addImage:(id)sender {
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate=self;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}
//imagepicker delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *profileImage =info[UIImagePickerControllerOriginalImage];
    _patientImageView.image=profileImage;
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
//Call Api for add patient
-(void)callApiForAdd{
    postman =[[Postman alloc]init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"AddressLine1"]=@"";
    dict[@"AddressLine2"]=@"";
    dict[@"Country"]=@"";
    dict[@"State"]=@"";
    dict[@"City"]=@"";
    dict[@"Postal"]=@"";
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    dict1[@"AddressLine1"]=@"";
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
    
    NSMutableDictionary *jsonWithGender=[[NSMutableDictionary alloc]init];
    jsonWithGender[@"Gender"]=genderCode;
    jsonWithGender[@"MaritalStatus"]=@"";
    jsonWithGender[@"ContactNo"]=_mobileNoTF.text;
    jsonWithGender[@"Surgeries"]=_addressTextView.text;
    jsonWithGender[@"Transfusion"]=_maritialStatus.text;
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
    parameterDict[@"Id"]=@"0";
    parameterDict[@"Memo"]=@"";
    parameterDict[@"UserTypeCode"]=@"PAT123";
     parameterDict[@"RoleCode"]=@"B2ETN9";
     parameterDict[@"CompanyCode"]=postmanCompanyCode;
     parameterDict[@"Username"]=_emailTF.text;
      parameterDict[@"MethodType"]=@"POST";
     parameterDict[@"UserID"]=@"0";
    parameterDict[@"Password"]=@"Power@1234";
     parameterDict[@"MiddleName"]=@"";
    parameterDict[@"LastName"]=@"";
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,addPatient];
    NSString *parameter;
 if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
     //For Vzone Api
     
     NSMutableDictionary *finalVzoneParameteDict=[[NSMutableDictionary alloc]init];
     finalVzoneParameteDict[@"request"]=parameterDict;
     NSData *parameterData = [NSJSONSerialization dataWithJSONObject:finalVzoneParameteDict options:NSJSONWritingPrettyPrinted error:nil];
     parameter = [[NSString alloc] initWithData:parameterData encoding:NSUTF8StringEncoding];
 }else{
    //For Material Api
    
    NSData *parameterData = [NSJSONSerialization dataWithJSONObject:parameterDict options:NSJSONWritingPrettyPrinted error:nil];
   parameter = [[NSString alloc] initWithData:parameterData encoding:NSUTF8StringEncoding];
 }
    
    [containerVC showMBprogressTillLoadThedata];
    [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processResponseObjectForAdd:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [containerVC hideAllMBprogressTillLoadThedata];
    }];
}

//response object of add patient
-(void)processResponseObjectForAdd:(id)responseObject{
    NSDictionary *dict;
    
     if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
    NSDictionary *responseDict1 = responseObject;
   dict=responseDict1[@"aaData"];
     }else  dict=responseObject;
    
    if ([dict[@"Success"] intValue]==1) {
        NSArray *userDetail=dict[@"UserDetails"];
        NSDictionary *dict1=userDetail[0];
        addedPatientCode=dict1[@"Code"];
        if (![_patientImageView.image isEqual:[UIImage imageNamed:@"Patient-img.jpg"]]) {
            [self saveImage:_patientImageView.image];
        }
        else{
        [containerVC hideAllMBprogressTillLoadThedata];
        [self alertmessage:dict[@"Message"]];
       
        }
    }
    else {
        [containerVC hideAllMBprogressTillLoadThedata];
         [self showToastMessage:dict[@"Message"]];
        }
}

//Gender API
-(void)callApiForGender{
    postman=[[Postman alloc]init];
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,getGender];
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
          NSString *parameter=[NSString stringWithFormat:@"{\"request\":}}"];
        [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self prcessGenderObject:responseObject];
            [[SeedSyncer sharedSyncer]saveResponse:[operation responseString] forIdentity:url];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:NO forKey:@"gender_FLAG"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
        
    }else{
        [postman get:url withParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self prcessGenderObject:responseObject];
            [[SeedSyncer sharedSyncer]saveResponse:[operation responseString] forIdentity:url];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:NO forKey:@"gender_FLAG"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
        
    }
}

//response object of gender for Material Api
-(void)prcessGenderObject:(id)responseObject{
    [genderArray removeAllObjects];
    
    NSDictionary *dict;
    
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        NSDictionary *responseDict1 = responseObject;
        dict=responseDict1[@"aaData"];
    }else dict=responseObject;
    
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
    
    NSDictionary *dict;
    
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        NSDictionary *responseDict1 = responseObject;
        dict=responseDict1[@"aaData"];
    }else dict=responseObject;
    
    
    for (NSDictionary *dict1 in dict[@"GenericSearchViewModels"]) {
        if ([dict1[@"Status"]intValue]==1) {
            editModel *editModelValue=[[editModel alloc]init];
            editModelValue.martialStatusName= dict1[@"Name"];
            editModelValue.martialCode=dict1[@"Code"];
            [MaritialStatusArray addObject:editModelValue];
        }
    }
}

//validate Email
-(void)validateEmail:(NSString*)email{
    NSString *emailRegEx=@"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest=[NSPredicate predicateWithFormat:@"self matches %@",emailRegEx];
    BOOL validate= [emailTest evaluateWithObject:email];
    NSMutableArray *alertArray=[self validateAllFields];
    if (validate) {
        int a= [self validPhonenumber:_mobileNoTF.text];
        if (a==0) {
            if (_mobileNoTF.text.length==0) {
                [alertArray addObject:@"Mobile no. is required\n"];
            }
            else  [alertArray addObject:@"Mobile no. is invalid\n"];
            NSString *str1=@"";
            for (NSString *str in alertArray) {
                str1 =[str1 stringByAppendingString:str];
            }
            [self alertView:str1];
        }
        else{
            if (alertArray.count>0) {
                NSString *str1=@"";
                for (NSString *str in alertArray) {
                    str1 =[str1 stringByAppendingString:str];
                }
                [self alertView:str1];
            }
            else [self callApiForAdd];
        }
    }
    else{
        int a= [self validPhonenumber:_mobileNoTF.text];
        if (a==0) {
            if (_mobileNoTF.text.length==0) {
                [alertArray addObject:@"Mobile no. is required\n"];
            }
            else  [alertArray addObject:@"Mobile no. is invalid\n"];
            if (_emailTF.text.length==0) {
                [alertArray addObject:@"Email id is required\n"];
            }
            else [alertArray addObject:@"Email id is invalid\n"];
            NSString *str1=@"";
            for (NSString *str in alertArray) {
                str1 =[str1 stringByAppendingString:str];
            }
            [self alertView:str1];
        }
        else{
            if (_emailTF.text.length==0) {
                [alertArray addObject:@"Email id is required\n"];
            }
            else [alertArray addObject:@"Email id is invalid\n"];
            NSString *str1=@"";
            for (NSString *str in alertArray) {
                str1 =[str1 stringByAppendingString:str];
            }
            [self alertView:str1];
        }
    }
}
-(NSMutableArray*)validateAllFields{
    NSMutableArray *alrtArray=[[NSMutableArray alloc]init];
    if(_nameTF.text.length==0){
        [alrtArray addObject:@"Name is required\n"];
    }
    if(_genderTF.text.length==0){
        [alrtArray addObject:@"Gender is required\n"];
    }
    if(_maritialStatus.text.length==0){
        [alrtArray addObject:@"Transfusion is required\n"];
    }
    if(_dateOfBirthTF.text.length==0){
        [alrtArray addObject:@"Date Of Birth is required\n"];
    }
    return alrtArray;
}
-(void)alertView:(NSString*)message{
    UIAlertController *alertView=[UIAlertController alertControllerWithTitle:alertStr message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *success=[UIAlertAction actionWithTitle:alertOkStr style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
        [alertView dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertView addAction:success];
    [self presentViewController:alertView animated:YES completion:nil];
}
//validate phone number
-(int)validPhonenumber:(NSString *)string
{
//    NSString *phoneRegex = @"[0-9]{0,10}";
//    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
//    BOOL validatePhone=[phoneTest evaluateWithObject:string];
    if ((string.length!=10)) {
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
        NSData* data = UIImageJPEGRepresentation(image,.5);
        [data writeToFile:path atomically:YES];
//        [imageManager uploadUserImagePath:path forRequestCode:addedPatientCode withDocumentType:@"ABC123" onCompletion:^(BOOL success) {
//           
   [imageManager uploadUserImagePath:path forRequestCode:addedPatientCode withDocumentType:@"ABC123" andRequestType:@"User" onCompletion:^(BOOL success) {
            
            if (success)
            {
                [self alertmessage:saveSuccessfullyStr];
                 [containerVC hideAllMBprogressTillLoadThedata];
            }else
            {
              [self showToastMessage:saveFailedStr];
                 [containerVC hideAllMBprogressTillLoadThedata];
            }
        }];
    }
}
//alertMessage
-(void)alertmessage :(NSString*)msg{
    UIAlertController *alertView=[UIAlertController alertControllerWithTitle:alertStr message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *success=[UIAlertAction actionWithTitle:alertOkStr style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
        [self.delegate successfullyAdded:addedPatientCode];
        [self.navigationController popViewControllerAnimated:YES];
        [alertView dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertView addAction:success];
    [self presentViewController:alertView animated:YES completion:nil];
}
//Toast Message
-(void)showToastMessage:(NSString*)msg{
    MBProgressHUD *hubHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hubHUD.mode=MBProgressHUDModeText;
    hubHUD.labelText=msg;
    hubHUD.labelFont=[UIFont systemFontOfSize:15];
    hubHUD.margin=20.f;
    hubHUD.yOffset=150.f;
    hubHUD.removeFromSuperViewOnHide = YES;
    [hubHUD hide:YES afterDelay:2];
}
//localize
-(void)localize
{
    alertStr=[MCLocalization stringForKey:@"Alert!"];
    alertOkStr=[MCLocalization stringForKey:@"AlertOK"];
    saveFailedStr=[MCLocalization stringForKey:@"Save Failed"];
    saveSuccessfullyStr=[MCLocalization stringForKey:@"Saved successfully"];
    requiredGenderFieldStr=[MCLocalization stringForKey:@"Gender is required"];
    requiredNameField=[MCLocalization stringForKey:@"Name is required"];
    requiredmobile=[MCLocalization stringForKey:@"Mobile no. is required"];
    requiredEmail=[MCLocalization stringForKey:@"Email id is required"];
    requiredTransfusion=[MCLocalization stringForKey:@"Transfusion is required"];
    invalidEmail=[MCLocalization stringForKey:@"Email id is invalid"];
    invalidMobile=[MCLocalization stringForKey:@"Mobile no. is invalid"];
    requiredDateOfBirth=[MCLocalization stringForKey:@"Date Of Birth is required"];
    _nameTF.attributedPlaceholder=[constant textFieldPlaceHolderText:[MCLocalization stringForKey:@"Name"]];
    _emailTF.attributedPlaceholder=[constant textFieldPlaceHolderText:[MCLocalization stringForKey:@"EmailLabel"]];
    _genderTF.attributedPlaceholder=[constant textFieldPlaceHolderText:[MCLocalization stringForKey:@"GenderLabel"]];
    _mobileNoTF.attributedPlaceholder=[constant textFieldPlaceHolderText:[MCLocalization stringForKey:@"MobileLabel"]];
    _maritialStatus.attributedPlaceholder=[constant textFieldPlaceHolderText:[MCLocalization stringForKey:@"TransfusionLabel"]];
    _dateOfBirthTF.attributedPlaceholder=[constant textFieldPlaceHolderText:[MCLocalization stringForKey:@"DateOfBirthLabel"]];
    _addressTextView.placeholder=[MCLocalization stringForKey:@"SurgeriesLabel"];
    navTitle=[MCLocalization stringForKey:@"Add"];
    yesStr=[MCLocalization stringForKey:@"Yes"];
    noStr=[MCLocalization stringForKey:@"No"];
    [_cancelBtn setTitle:[MCLocalization stringForKey:@"Cancel"] forState:normal];
     [_saveBtn setTitle:[MCLocalization stringForKey:@"Save"] forState:normal];

    [self.nameLabel setAttributedText:[constant setColoredLabelandStar:[MCLocalization stringForKey:@"Name"]]];
    
    [self.genderLabel setAttributedText:[constant setColoredLabelandStar:[MCLocalization stringForKey:@"GenderLabel"]]];
    
    [self.transfusionLabel setAttributedText:[constant setColoredLabelandStar:[MCLocalization stringForKey:@"TransfusionLabel"]]];
    
    [self.dobLabel setAttributedText:[constant setColoredLabelandStar:[MCLocalization stringForKey:@"DateOfBirthLabel"]]];
    [self.mobNumbLabel setAttributedText:[constant setColoredLabelandStar:[MCLocalization stringForKey:@"MobileLabel"]]];
    [self.emailLabel setAttributedText:[constant setColoredLabelandStar:[MCLocalization stringForKey:@"EmailLabel"]]];
    



}
@end
