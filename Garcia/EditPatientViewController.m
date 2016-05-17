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
#import "SeedSyncer.h"
#import "UIImageView+clearCachImage.h"
#import <MCLocalization/MCLocalization.h>
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
    NSString *genderCode,*martialCode;
    ImageUploadAPI *imageManager;
    NSString *editedPatientCode;
    BOOL imageAlreadyUpdated;
    NSString *alertOkStr,*alertStr,*updatedFailedStr,*updatedSuccessfullyStr,*requiredGenderFieldStr,*requiredNameField,*navTitle,*yesStr,*noStr,*requiredDateOfBirth,*requiredEmail,*requiredmobile,*requiredTransfusion,*invalidEmail,*invalidMobile;
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
    [self registerForKeyboardNotifications];
    [self defaultValues];
    self.gendertableview.dataSource=self;
    self.gendertableview.delegate=self;
    self.nameTF.delegate=self;
    self.mobileNoTF.delegate=self;
    MaritialStatusArray=[@[yesStr,noStr]mutableCopy];
    
    UITapGestureRecognizer *gest=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addImage:)];
    [_patientImageView addGestureRecognizer:gest];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localize) name:MCLocalizationLanguageDidChangeNotification object:nil];
//
    _mainController.layer.cornerRadius=5;
    _patientImageView.layer.cornerRadius=_patientImageView.frame.size.height/2;
    _patientImageView.layer.masksToBounds = YES;

  
//    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
//        //For Vzone API
//        [self callApiForGender];
//    }else{
//        //For Material Api
//        
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
 //   }
}
-(void)viewWillAppear:(BOOL)animated{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background-Image-1.jpg"]]];
    [constant changeSaveBtnImage:_saveBtn];
    [constant changeCancelBtnImage:_cancelBtn];
    UINavigationController *nav=(UINavigationController*)self.parentViewController;
    containerVC=(ContainerViewController*)nav.parentViewController;
    [containerVC setTitle:navTitle];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//default values
-(void)defaultValues{
    [constant getTheAllSaveButtonImage:_saveBtn];
    _nameTF.text=_model.name;
    _genderTF.text=_model.gender;
    _dateOfBirthTF.text=_model.dob;
    _mobileNoTF.text=_model.mobileNo;
    _emailTF.text=_model.emailId;
    martialCode=_model.martialCode;
    genderCode=_model.genderCode;
    if (_model.profileImageCode==nil) {
        _patientImageView.image=[UIImage imageNamed:@"Patient-img.jpg"];
        imageAlreadyUpdated=NO;
    }else{
        
        NSString *strimageUrl;
        if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        strimageUrl = [NSString stringWithFormat:@"%@%@%@/%@",baseUrlAws,dbName,_model.storageID,_model.fileName];
            imageAlreadyUpdated=YES;
        
    }else
    {
        strimageUrl = [NSString stringWithFormat:@"%@%@%@",baseUrl,getProfile,_model.profileImageCode];
        
    }
        [_patientImageView setImageWithURL:[NSURL URLWithString:strimageUrl] placeholderImage:[UIImage imageNamed:@"Patient-img.jpg"]];
    }
    if (_model.surgeries!=nil) {
        _addressTextView.text=_model.surgeries;
    }else _addressTextView.text=@"";
    if (_model.tranfusion!=nil) {
        _maritialStatus.text=_model.tranfusion;
    }else _maritialStatus.text=@"";
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
    [self.view endEditing:YES];
    [_maritialTableView reloadData];
    [_scrollView layoutIfNeeded];
    _maritialTableHeight.constant=_maritialTableView.contentSize.height;
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
        cell.textLabel.text=MaritialStatusArray[indexPath.row];
        [constant setFontForLabel:cell.textLabel];
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
//set layesr for TextField and placeHolder
-(void)textFieldLayer{
    _patientImageView.layer.cornerRadius=_patientImageView.frame.size.width/2;
    _patientImageView.clipsToBounds=YES;
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
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL status=YES;

    if ([textField isEqual:_mobileNoTF]) {
        if (_mobileNoTF.text.length>=15) {
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
//textField EndEditing
- (void)textViewDidEndEditing:(UITextView *)textView{
    activeField = nil;
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
- (IBAction)addImage:(id)sender {
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate=self;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}
//image picker delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *profileImage =info[UIImagePickerControllerOriginalImage];
    _patientImageView.image=profileImage;
    imageAlreadyUpdated=NO;
    containerVC.viewControllerDiffer=@"Edit";
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
//Patient Update
-(void)callApiForUpdate{
    postman =[[Postman alloc]init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (_model.addressLine1!=nil) {
        dict[@"AddressLine1"]=_model.addressLine1;
    }else  dict[@"AddressLine1"]=@"";
    if (_model.addressline2!=nil) {
        dict[@"AddressLine2"]=_model.addressline2;
    }else  dict[@"AddressLine2"]=@"";
    if (_model.country!=nil) {
        dict[@"Country"]=_model.country;
    }else   dict[@"Country"]=@"";
    if (_model.state!=nil) {
        dict[@"State"]=_model.state;
    }else dict[@"State"]=@"";
    if (_model.city!=nil) {
        dict[@"City"]=_model.city;
    }else  dict[@"City"]=@"";
    if (_model.pinCode!=nil) {
        dict[@"Postal"]=_model.pinCode;
    }else   dict[@"Postal"]=@"";
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    if (_model.addressLine1!=nil) {
        dict[@"AddressLine1"]=_model.addressLine1;
    }else  dict[@"AddressLine1"]=@"";
    if (_model.addressline2!=nil) {
        dict1[@"AddressLine2"]=_model.addressline2;
    }else   dict1[@"AddressLine2"]=@"";
    dict1[@"Country"]=@"";
    dict1[@"State"]=@"";
    dict1[@"City"]=@"";
    dict1[@"Postal"]=@"";
    NSMutableDictionary *address=[[NSMutableDictionary alloc]init];
    address[@"PermanentAddress"]=dict;
    address[@"TemporaryAddress"]=dict1;
    NSData *jsonData1 = [NSJSONSerialization dataWithJSONObject:address options:kNilOptions error:nil];
    NSString *temporaryAddress = [[NSString alloc] initWithData:jsonData1 encoding:NSUTF8StringEncoding];
    NSMutableDictionary *jsonWithGender;
    if (self.model.jsonDict==nil) {
        jsonWithGender=[[NSMutableDictionary alloc]init];
    }else jsonWithGender=[self.model.jsonDict mutableCopy];
    jsonWithGender[@"Gender"]=genderCode;
    jsonWithGender[@"MaritalStatus"]=@"";
    jsonWithGender[@"ContactNo"]=_mobileNoTF.text;
    jsonWithGender[@"Surgeries"]=_addressTextView.text;
    jsonWithGender[@"Transfusion"]=_maritialStatus.text;;
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
    parameterDict[@"Id"]=[NSString stringWithFormat:@"%@",_model.Id];
    parameterDict[@"Code"]=_model.code;
    parameterDict[@"UserTypeCode"]=_model.userTypeCode;
    parameterDict[@"CompanyCode"]=postmanCompanyCode;
    parameterDict[@"Username"]=_emailTF.text;
    parameterDict[@"MethodType"]=@"PUT";
    parameterDict[@"UserID"]=[NSString stringWithFormat:@"%@",_model.userID];
    parameterDict[@"MiddleName"]=@"";
    parameterDict[@"LastName"]=@"";
    parameterDict[@"RoleCode"]=@"B2ETN9";
    NSString *url=[NSString stringWithFormat:@"%@%@%@",baseUrl,editPatient,_model.Id];
    NSString *parameter;
    
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        //Parameter for Vzone Api
        NSMutableDictionary *finalVzoneParameteDict=[[NSMutableDictionary alloc]init];
        finalVzoneParameteDict[@"request"]=parameterDict;
        NSData *parameterData = [NSJSONSerialization dataWithJSONObject:finalVzoneParameteDict options:NSJSONWritingPrettyPrinted error:nil];
        parameter = [[NSString alloc] initWithData:parameterData encoding:NSUTF8StringEncoding];
    }else{
        //Parameter For Material Api
        NSData *parameterData = [NSJSONSerialization dataWithJSONObject:parameterDict options:NSJSONWritingPrettyPrinted error:nil];
        parameter = [[NSString alloc] initWithData:parameterData encoding:NSUTF8StringEncoding];
    }

    [containerVC showMBprogressTillLoadThedata];
    [postman put:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processResponseObjectForEdit:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [containerVC hideAllMBprogressTillLoadThedata];
        [self showToastMessage:[NSString stringWithFormat:@"%@",error]];
        
    }];
}
//process response object for edit
-(void)processResponseObjectForEdit:(id)responseObject{
    NSDictionary *dict;
    
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        NSDictionary *responseDict1 = responseObject;
        dict=responseDict1[@"aaData"];
    }else  dict=responseObject;

    if ([dict[@"Success"] intValue]==1) {
        NSDictionary *dict1=dict[@"UserObj"];
        editedPatientCode=dict1[@"Code"];
        if (![_patientImageView.image isEqual:[UIImage imageNamed:@"Patient-img.jpg"]]) {
            if (!imageAlreadyUpdated) {
               [self saveImage:_patientImageView.image];
            }else{
                [containerVC hideAllMBprogressTillLoadThedata];
                [self alertmessage:dict[@"Message"]];
            }
        }
        else{
             [containerVC hideAllMBprogressTillLoadThedata];
            [self alertmessage:dict[@"Message"]];
        }
    }
    else{
        [containerVC hideAllMBprogressTillLoadThedata];
        [self showToastMessage:dict[@"Message"]];
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
                [alertArray addObject:[NSString stringWithFormat:@"%@\n",requiredmobile]];
            }
            else  [alertArray addObject:[NSString stringWithFormat:@"%@\n",invalidMobile]];
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
            else [self callApiForUpdate];
        }
    }
    else{
        int a= [self validPhonenumber:_mobileNoTF.text];
        if (a==0) {
            if (_mobileNoTF.text.length==0) {
                [alertArray addObject:[NSString stringWithFormat:@"%@\n",requiredmobile]];
            }
            else  [alertArray addObject:[NSString stringWithFormat:@"%@\n",invalidMobile]];
            if (_emailTF.text.length==0) {
                [alertArray addObject:[NSString stringWithFormat:@"%@\n",requiredEmail]];
            }
            else [alertArray addObject:[NSString stringWithFormat:@"%@\n",invalidEmail]];
            NSString *str1=@"";
            for (NSString *str in alertArray) {
                str1 =[str1 stringByAppendingString:str];
            }
            [self alertView:str1];
        }
        else{
            if (_emailTF.text.length==0) {
                [alertArray addObject:[NSString stringWithFormat:@"%@\n",requiredEmail]];
            }
            else [alertArray addObject:[NSString stringWithFormat:@"%@\n",invalidEmail]];
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
        [alrtArray addObject:[NSString stringWithFormat:@"%@\n",requiredNameField]];
    }
    if(_genderTF.text.length==0){
        [alrtArray addObject:[NSString stringWithFormat:@"%@\n",requiredGenderFieldStr]];
    }
    if(_maritialStatus.text.length==0){
        [alrtArray addObject:[NSString stringWithFormat:@"%@\n",requiredTransfusion]];
    }
    if(_dateOfBirthTF.text.length==0){
        [alrtArray addObject:[NSString stringWithFormat:@"%@\n",requiredDateOfBirth]];
    }
    return alrtArray;
}
//validate phone number
-(int)validPhonenumber:(NSString *)string
{
//    NSString *phoneRegex = @"[0-9]{0,10}";
//    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
//    BOOL validatePhone=[phoneTest evaluateWithObject:string];
    if ((string.length>15)) {
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
        if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
            NSString *type=@"ABC123";
            [imageManager uploadUserForVzoneDocumentPath:path forRequestCode:_model.code withType:type withText:@"" withRequestType:@"User" withUserId:_model.Id onCompletion:^(BOOL success) {
                if (success)
                {
                    if (_model.profileImageCode)
                    {
                        NSString *str=[NSString stringWithFormat:@"%@%@%@",baseUrl,getProfile,_model.profileImageCode];
                        [self.patientImageView clearImageCacheForURL:[NSURL URLWithString:str]];
                    }
                    [self alertmessage:updatedSuccessfullyStr];
                    [containerVC hideAllMBprogressTillLoadThedata];
                }else
                {
                    [containerVC hideAllMBprogressTillLoadThedata];
                    [self showToastMessage:updatedFailedStr];
                }
            }];
        }else{
        [imageManager uploadUserImagePath:path forRequestCode:_model.code withDocumentType:@"ABC123" andRequestType:@"User" onCompletion:^(BOOL success) {
            if (success)
            {
                if (_model.profileImageCode)
                {
                    NSString *str=[NSString stringWithFormat:@"%@%@%@",baseUrl,getProfile,_model.profileImageCode];
                    [self.patientImageView clearImageCacheForURL:[NSURL URLWithString:str]];
                }
                [self alertmessage:updatedSuccessfullyStr];
                [containerVC hideAllMBprogressTillLoadThedata];
            }else
            {
                 [containerVC hideAllMBprogressTillLoadThedata];
                [self showToastMessage:updatedFailedStr];
            }
        }];
    }
    }
}
-(void)alertView:(NSString*)message{
    UIAlertController *alertView=[UIAlertController alertControllerWithTitle:alertStr message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *success=[UIAlertAction actionWithTitle:alertOkStr style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
        [alertView dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertView addAction:success];
    [self presentViewController:alertView animated:YES completion:nil];
}
//alert message
-(void)alertmessage :(NSString*)msg{
    UIAlertController *alertView=[UIAlertController alertControllerWithTitle:alertStr message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *success=[UIAlertAction actionWithTitle:alertOkStr style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
        [self.delegate successfullyEdited:editedPatientCode];
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
    hubHUD.detailsLabelText=msg;
    hubHUD.detailsLabelFont=[UIFont systemFontOfSize:15];
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
    updatedFailedStr=[MCLocalization stringForKey:@"Updated.Failed"];
    updatedSuccessfullyStr=[MCLocalization stringForKey:@"Updated.successfully"];
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
    navTitle=[MCLocalization stringForKey:@"Edit"];
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
