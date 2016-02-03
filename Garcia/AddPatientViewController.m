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
}
- (void)viewDidLoad {
    [super viewDidLoad];
    constant=[[Constant alloc]init];
    imageManager=[[ImageUploadAPI alloc]init];
    [self textFieldLayer];
    genderArray=[[NSMutableArray alloc]init];
    MaritialStatusArray=[[NSMutableArray alloc]init];
    UINavigationController *nav=(UINavigationController*)self.parentViewController;
    if (nav.parentViewController==NULL) {
         self.title=@"Add Patient";
    }
    else{
        containerVC=(ContainerViewController*)nav.parentViewController;
        [containerVC setTitle:@"Add Patient"];
    }
     [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background-Image-1.jpg"]]];
     [self registerForKeyboardNotifications];
     _addressTextView.placeholder=@"Surgeries";
    self.addressTextView.delegate=self;
    MaritialStatusArray=[@[@"YES",@"NO"]mutableCopy];
    
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        //For Vzone API
        [self callApiForGender];
    }else{
        //For Material Api
        
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
    }

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    _patientImageView.layer.cornerRadius=_patientImageView.frame.size.width/2;
    _patientImageView.clipsToBounds=YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//cancel
- (IBAction)cancel:(id)sender {
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
   [cell setBackgroundColor:[UIColor colorWithRed:0.73 green:0.76 blue:0.91 alpha:1]];
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
    if ([textField isEqual:_mobileNoTF]) {
        NSCharacterSet * numberCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        for (int i = 0; i < [string length]; ++i)
        {
            unichar c = [string characterAtIndex:i];
            if (![numberCharSet characterIsMember:c])
            {
                return NO;
            }
        }
        
        return YES;
    }
    else return YES;
}
//set layesr for TextField and placeHolder
-(void)textFieldLayer{
//    _patientImageView.layer.cornerRadius=_patientImageView.frame.size.width/2;
//    _patientImageView.clipsToBounds=YES;
    _nameTF.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Name"];
    _emailTF.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Email"];
    _genderTF.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Gender"];
    _mobileNoTF.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Mobile"];
        _maritialStatus.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Transfusion"];
    _dateOfBirthTF.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Date Of Birth"];
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
        [self alertmessage:dict[@"Message"]];
        [containerVC hideAllMBprogressTillLoadThedata];
        }
    }
    else {
         [self alertmessageForFailure:dict[@"Message"]];
        [containerVC hideAllMBprogressTillLoadThedata];
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


//validate email
-(void)validateEmail:(NSString*)email{
    NSString *emailRegEx=@"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest=[NSPredicate predicateWithFormat:@"self matches %@",emailRegEx];
    BOOL validate= [emailTest evaluateWithObject:email];
    if (!validate) {
        NSMutableArray *alertArray=[self validateAllFields];
        if (_emailTF.text.length==0) {
            [alertArray addObject:@"Email Id. is Required\n"];
        }
        else{
        [alertArray addObject:@"Email Id is invalid\n"];
        }
        int a= [self validPhonenumber:_mobileNoTF.text];
        if (a==0) {
            if (_mobileNoTF.text.length==0) {
                [alertArray addObject:@"Mobile no. is Required\n"];
            }
            else{
            [alertArray addObject:@"Mobile no. is invalid\n"];
            }
             NSString *str1=@"";
            for (NSString *str in alertArray) {
                str1 =[str1 stringByAppendingString:str];
            }
            [self alertView:str1];
        }
        else{
            NSString *str1=@"";
            for (NSString *str in alertArray) {
                str1 =[str1 stringByAppendingString:str];
            }
            [self alertView:str1];
    }
}
    else{
        NSMutableArray *alertArray=[self validateAllFields];
        int a= [self validPhonenumber:_mobileNoTF.text];
        if (a==0) {
            if (_mobileNoTF.text.length==0) {
                [alertArray addObject:@"Mobile no. is Required\n"];
            }
            else{
            [alertArray addObject:@"Invalid mobile no.\n"];
            }
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
}
-(NSMutableArray*)validateAllFields{
    NSMutableArray *alrtArray=[[NSMutableArray alloc]init];
    if(_genderTF.text.length==0){
        [alrtArray addObject:@"Gender is required\n"];
    }
    if(_nameTF.text.length==0){
        [alrtArray addObject:@"Name is required\n"];
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
    UIAlertController *alertView=[UIAlertController alertControllerWithTitle:@"Alert!" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *success=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
        [alertView dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertView addAction:success];
    [self presentViewController:alertView animated:YES completion:nil];
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
        NSData* data = UIImageJPEGRepresentation(image,.5);
        [data writeToFile:path atomically:YES];
        [imageManager uploadUserImagePath:path forRequestCode:addedPatientCode withDocumentType:@"ABC123" onCompletion:^(BOOL success) {
            if (success)
            {
                [self alertmessage:@"Saved successfully"];
                 [containerVC hideAllMBprogressTillLoadThedata];
            }else
            {
              [self alertmessageForFailure:@"Saved Failed"];
                 [containerVC hideAllMBprogressTillLoadThedata];
            }
        }];
    }
}
-(void)alertmessage :(NSString*)msg{
    UIAlertController *alertView=[UIAlertController alertControllerWithTitle:@"Alert!" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *success=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
        [self.delegate successfullyAdded:addedPatientCode];
        [self.navigationController popViewControllerAnimated:YES];
        [alertView dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertView addAction:success];
    [self presentViewController:alertView animated:YES completion:nil];
}
-(void)alertmessageForFailure:(NSString*)msg{
    UIAlertController *alertView=[UIAlertController alertControllerWithTitle:@"Alert!" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *success=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
        [alertView dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertView addAction:success];
    [self presentViewController:alertView animated:YES completion:nil];
}
@end
