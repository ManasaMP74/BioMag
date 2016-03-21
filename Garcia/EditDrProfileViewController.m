#import "EditDrProfileViewController.h"
#import "PlaceholderTextView.h"
#import "Constant.h"
#import <MCLocalization/MCLocalization.h>
#import "Postman.h"
#import "PostmanConstant.h"
#import "SeedSyncer.h"
#import "editModel.h"
#import "DatePicker.h"
#import "ImageUploadAPI.h"
#import "MBProgressHUD.h"
#import "DrProfilModel.h"
@interface EditDrProfileViewController ()<UITableViewDataSource,UITableViewDelegate,datePickerProtocol>
@property (strong, nonatomic) IBOutlet UITextField *nameTF;
@property (strong, nonatomic) IBOutlet UITextField *genderTF;
@property (strong, nonatomic) IBOutlet UITextField *yearOfExpTF;
@property (strong, nonatomic) IBOutlet UITextField *dateOfBirthTF;
@property (strong, nonatomic) IBOutlet UITextField *mobileNoTF;
@property (strong, nonatomic) IBOutlet UITextField *emailTF;
@property (strong, nonatomic) IBOutlet UITableView *gendertableview;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *drImageView;
@property (strong, nonatomic) IBOutlet PlaceholderTextView *certificateTextView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *genderTvHeight;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearOfExpLabel;
@property (weak, nonatomic) IBOutlet UILabel *dobLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobNumbLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *certificateLabel;
@end

@implementation EditDrProfileViewController
{
    Constant *constant;
    NSDateFormatter *formatter;
    Postman *postman;
    NSMutableArray *genderArray;
    NSString *genderCode;
    DatePicker *datePicker;
      NSString *alertOkStr,*alertStr,*updatedFailedStr,*updatedSuccessfullyStr,*requiredGenderFieldStr,*requiredNameField,*navTitle,*yesStr,*noStr,*requiredDateOfBirth,*requiredEmail,*requiredmobile,*requiredTransfusion,*invalidEmail,*invalidMobile;
    ImageUploadAPI *imageManager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    formatter=[[NSDateFormatter alloc]init];
    constant=[[Constant alloc]init];
    imageManager=[[ImageUploadAPI alloc]init];
    [self textFieldLayer];
    [self setFont];
    [self textFieldLayer];
    [self setDefault];
    [self navigationItemMethod];
    [self localize];
    genderArray=[[NSMutableArray alloc]init];
    _gendertableview.hidden=YES;
    [self callApiForGender];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
//set layesr for TextField and placeHolder
-(void)textFieldLayer{
    //       _patientImageView.layer.cornerRadius=_patientImageView.frame.size.width/2;
    //    _patientImageView.clipsToBounds=YES;
    
    [constant spaceAtTheBeginigOfTextField:_genderTF];
    [constant spaceAtTheBeginigOfTextField:_emailTF];
    [constant spaceAtTheBeginigOfTextField:_nameTF];
    [constant spaceAtTheBeginigOfTextField:_yearOfExpTF];
    [constant spaceAtTheBeginigOfTextField:_dateOfBirthTF];
    [constant spaceAtTheBeginigOfTextField:_mobileNoTF];
    [constant SetBorderForTextField:_genderTF];
    [constant SetBorderForTextField:_mobileNoTF];
    [constant SetBorderForTextField:_yearOfExpTF];
    [constant SetBorderForTextField:_emailTF];
    [constant SetBorderForTextview:_certificateTextView];
    [constant SetBorderForTextField:_nameTF];
    [constant SetBorderForTextField:_dateOfBirthTF];
    [constant setFontFortextField:_nameTF];
    [constant setFontFortextField:_genderTF];
    [constant setFontFortextField:_emailTF];
    [constant setFontFortextField:_yearOfExpTF];
    [constant setFontFortextField:_dateOfBirthTF];
    [constant setFontFortextField:_mobileNoTF];
    _certificateTextView.textContainerInset = UIEdgeInsetsMake(10, 5, 10, 10);
}
//setfont for label
-(void)setFont{
    [constant setFontForLabel:_genderLabel];
    [constant setFontForLabel:_nameLabel];
    [constant setFontForLabel:_yearOfExpLabel];
    [constant setFontForLabel:_dobLabel];
    [constant setFontForLabel:_certificateLabel];
    [constant setFontForLabel:_emailLabel];
    [constant setFontForLabel:_mobNumbLabel];
}
-(void)navigationItemMethod{
    self.navigationItem.hidesBackButton=YES;
    UIImage* image = [UIImage imageNamed:@"Back button.png"];
    CGRect frameimg1 = CGRectMake(100, 0, image.size.width+30, image.size.height);
    UIButton *button=[[UIButton alloc]initWithFrame:frameimg1];
    [button setImage:image forState:UIControlStateNormal];
    UIBarButtonItem *barItem=[[UIBarButtonItem alloc]initWithCustomView:button];
    UIBarButtonItem *negativeSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpace.width=-25;
    self.navigationItem.leftBarButtonItems=@[negativeSpace,barItem];
    [button addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
}
-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setDefault{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSArray *doctorDetail=[defaults valueForKey:@"DoctorDetail"];
    DrProfilModel *model=doctorDetail[0];
    _nameTF.text=model.name;
    NSArray *ar=[model.DOB componentsSeparatedByString:@"T"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[formatter dateFromString:ar[0]];
    [formatter setDateFormat:@"dd-MMM-yyyy"];
    NSString *str=[formatter stringFromDate:date];
    _dateOfBirthTF.text=str;
    _emailTF.text=model.email;
    _yearOfExpTF.text=model.experience;
    _certificateTextView.text=model.certificate;
    _mobileNoTF.text=model.ContactNo;
    _genderTF.text=model.gendername;
    genderCode=model.genderCode;
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
//TableView Number of row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.gendertableview])
    {
        return genderArray.count;
        
    }
   else return 1;
    
}
//TableView cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if ([tableView isEqual:self.gendertableview]) {
        editModel *model=genderArray[indexPath.row];
        cell.textLabel.text=model.genderName;
        [constant setFontForLabel:cell.textLabel];
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
}

- (IBAction)dateOfBirth:(id)sender {
    [self.view endEditing:YES];
    _gendertableview.hidden=YES;
    if(datePicker==nil)
        datePicker= [[DatePicker alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+100, self.view.frame.origin.y+230,self.view.frame.size.width-200,230)];
    datePicker.datePicker.maximumDate=[NSDate date];
    [datePicker alphaViewInitialize];
    datePicker.delegate=self;
}
-(void)selectingDatePicker:(NSString *)date{
    _dateOfBirthTF.text=date;
}
- (IBAction)gender:(id)sender {
    [self.view endEditing:YES];
    _gendertableview.hidden=NO;
    [_gendertableview reloadData];
    [_scrollView layoutIfNeeded];
    _genderTvHeight.constant=_gendertableview.contentSize.height;
}
- (IBAction)cancel:(id)sender {
 [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)save:(id)sender {
    [self.view endEditing:YES];
    [self validateEmail:_emailTF.text];
}
//Patient Update
-(void)callApiForUpdate{
//    postman =[[Postman alloc]init];
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//    if (_model.addressLine1!=nil) {
//        dict[@"AddressLine1"]=_model.addressLine1;
//    }else  dict[@"AddressLine1"]=@"";
//    if (_model.addressline2!=nil) {
//        dict[@"AddressLine2"]=_model.addressline2;
//    }else  dict[@"AddressLine2"]=@"";
//    if (_model.country!=nil) {
//        dict[@"Country"]=_model.country;
//    }else   dict[@"Country"]=@"";
//    if (_model.state!=nil) {
//        dict[@"State"]=_model.state;
//    }else dict[@"State"]=@"";
//    if (_model.city!=nil) {
//        dict[@"City"]=_model.city;
//    }else  dict[@"City"]=@"";
//    if (_model.pinCode!=nil) {
//        dict[@"Postal"]=_model.pinCode;
//    }else   dict[@"Postal"]=@"";
//    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
//    if (_model.addressLine1!=nil) {
//        dict[@"AddressLine1"]=_model.addressLine1;
//    }else  dict[@"AddressLine1"]=@"";
//    if (_model.addressline2!=nil) {
//        dict1[@"AddressLine2"]=_model.addressline2;
//    }else   dict1[@"AddressLine2"]=@"";
//    dict1[@"Country"]=@"";
//    dict1[@"State"]=@"";
//    dict1[@"City"]=@"";
//    dict1[@"Postal"]=@"";
//    NSMutableDictionary *address=[[NSMutableDictionary alloc]init];
//    address[@"PermanentAddress"]=dict;
//    address[@"TemporaryAddress"]=dict1;
//    NSData *jsonData1 = [NSJSONSerialization dataWithJSONObject:address options:kNilOptions error:nil];
//    NSString *temporaryAddress = [[NSString alloc] initWithData:jsonData1 encoding:NSUTF8StringEncoding];
//    NSMutableDictionary *jsonWithGender;
//    if (self.model.jsonDict==nil) {
//        jsonWithGender=[[NSMutableDictionary alloc]init];
//    }else jsonWithGender=[self.model.jsonDict mutableCopy];
//    jsonWithGender[@"Gender"]=genderCode;
//    jsonWithGender[@"MaritalStatus"]=@"";
//    jsonWithGender[@"ContactNo"]=_mobileNoTF.text;
//    jsonWithGender[@"Surgeries"]=_addressTextView.text;
//    jsonWithGender[@"Transfusion"]=_maritialStatus.text;;
//    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:jsonWithGender options:kNilOptions error:nil];
//    
//    NSString *genderData = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
//    NSMutableDictionary *parameterDict=[[NSMutableDictionary alloc]init];
//    NSDateFormatter *format=[[NSDateFormatter alloc]init];
//    [format setDateFormat:@"dd-MMM-yyyy"];
//    NSDate *Dobdate=[format dateFromString:_dateOfBirthTF.text];
//    [format setDateFormat:@"yyyy-MM-dd"];
//    NSString *dobString=[format stringFromDate:Dobdate];
//    parameterDict[@"Address"]=temporaryAddress;
//    parameterDict[@"Email"]=_emailTF.text;
//    parameterDict[@"FirstName"]=_nameTF.text;
//    parameterDict[@"DOB"]=dobString;
//    parameterDict[@"JSON"]=genderData;
//    parameterDict[@"Status"]=@"true";
//    parameterDict[@"Id"]=[NSString stringWithFormat:@"%@",_model.Id];
//    parameterDict[@"Code"]=_model.code;
//    parameterDict[@"UserTypeCode"]=_model.userTypeCode;
//    parameterDict[@"CompanyCode"]=postmanCompanyCode;
//    parameterDict[@"Username"]=_emailTF.text;
//    parameterDict[@"MethodType"]=@"PUT";
//    parameterDict[@"UserID"]=[NSString stringWithFormat:@"%@",_model.userID];
//    parameterDict[@"MiddleName"]=@"";
//    parameterDict[@"LastName"]=@"";
//    parameterDict[@"RoleCode"]=@"B2ETN9";
//    NSString *url=[NSString stringWithFormat:@"%@%@%@",baseUrl,editPatient,_model.Id];
//    NSString *parameter;
//    
//    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
//        //Parameter for Vzone Api
//        NSMutableDictionary *finalVzoneParameteDict=[[NSMutableDictionary alloc]init];
//        finalVzoneParameteDict[@"request"]=parameterDict;
//        NSData *parameterData = [NSJSONSerialization dataWithJSONObject:finalVzoneParameteDict options:NSJSONWritingPrettyPrinted error:nil];
//        parameter = [[NSString alloc] initWithData:parameterData encoding:NSUTF8StringEncoding];
//    }else{
//        //Parameter For Material Api
//        NSData *parameterData = [NSJSONSerialization dataWithJSONObject:parameterDict options:NSJSONWritingPrettyPrinted error:nil];
//        parameter = [[NSString alloc] initWithData:parameterData encoding:NSUTF8StringEncoding];
//    }
//    
//    [containerVC showMBprogressTillLoadThedata];
//    [postman put:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [self processResponseObjectForEdit:responseObject];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [containerVC hideAllMBprogressTillLoadThedata];
//        [self showToastMessage:[NSString stringWithFormat:@"%@",error]];
//        
//    }];
}

//process response object for edit

//-(void)processResponseObjectForEdit:(id)responseObject{
//    NSDictionary *dict;
//    
//    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
//        NSDictionary *responseDict1 = responseObject;
//        dict=responseDict1[@"aaData"];
//    }else  dict=responseObject;
//    
//    if ([dict[@"Success"] intValue]==1) {
//        NSDictionary *dict1=dict[@"UserObj"];
//        editedPatientCode=dict1[@"Code"];
//        if (![_patientImageView.image isEqual:[UIImage imageNamed:@"Patient-img.jpg"]]) {
//            if (!imageAlreadyUpdated) {
//                [self saveImage:_patientImageView.image];
//            }else{
//                [containerVC hideAllMBprogressTillLoadThedata];
//                [self alertmessage:dict[@"Message"]];
//            }
//        }
//        else{
//            [containerVC hideAllMBprogressTillLoadThedata];
//            [self alertmessage:dict[@"Message"]];
//        }
//    }
//    else{
//        [containerVC hideAllMBprogressTillLoadThedata];
//        [self showToastMessage:dict[@"Message"]];
//    }
//}

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
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0];
//        NSString* path = [documentsDirectory stringByAppendingPathComponent:@"EdittedProfile.jpeg" ];
//        NSData* data = UIImageJPEGRepresentation(image,.5);
//        [data writeToFile:path atomically:YES];
//        if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
//            NSString *type=@"ABC123";
//            [imageManager uploadUserForVzoneDocumentPath:path forRequestCode:_model.code withType:type withText:@"" withRequestType:@"User" withUserId:_model.Id onCompletion:^(BOOL success) {
//                if (success)
//                {
//                    if (_model.profileImageCode)
//                    {
//                        NSString *str=[NSString stringWithFormat:@"%@%@%@",baseUrl,getProfile,_model.profileImageCode];
//                        [self.patientImageView clearImageCacheForURL:[NSURL URLWithString:str]];
//                    }
//                    [self alertmessage:updatedSuccessfullyStr];
//                    [containerVC hideAllMBprogressTillLoadThedata];
//                }else
//                {
//                    [containerVC hideAllMBprogressTillLoadThedata];
//                    [self showToastMessage:updatedFailedStr];
//                }
//            }];
//        }else{
//            [imageManager uploadUserImagePath:path forRequestCode:_model.code withDocumentType:@"ABC123" andRequestType:@"User" onCompletion:^(BOOL success) {
//                if (success)
//                {
//                    if (_model.profileImageCode)
//                    {
//                        NSString *str=[NSString stringWithFormat:@"%@%@%@",baseUrl,getProfile,_model.profileImageCode];
//                        [self.patientImageView clearImageCacheForURL:[NSURL URLWithString:str]];
//                    }
//                    [self alertmessage:updatedSuccessfullyStr];
//                    [containerVC hideAllMBprogressTillLoadThedata];
//                }else
//                {
//                    [containerVC hideAllMBprogressTillLoadThedata];
//                    [self showToastMessage:updatedFailedStr];
//                }
//            }];
//        }
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
-(void)localize{
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
    _yearOfExpTF.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Year Of Experience"];
    _dateOfBirthTF.attributedPlaceholder=[constant textFieldPlaceHolderText:[MCLocalization stringForKey:@"DateOfBirthLabel"]];
    _certificateTextView.placeholder=@"Certificates";
    self.title=[MCLocalization stringForKey:@"Edit"];
    [_cancelBtn setTitle:[MCLocalization stringForKey:@"Cancel"] forState:normal];
    [_saveBtn setTitle:[MCLocalization stringForKey:@"Save"] forState:normal];
    [self.nameLabel setAttributedText:[constant setColoredLabelandStar:[MCLocalization stringForKey:@"Name"]]];
    [self.genderLabel setAttributedText:[constant setColoredLabelandStar:[MCLocalization stringForKey:@"GenderLabel"]]];
    [self.yearOfExpLabel setAttributedText:[constant setColoredLabelandStar:@"Year Of Experience"]];
    [self.dobLabel setAttributedText:[constant setColoredLabelandStar:[MCLocalization stringForKey:@"DateOfBirthLabel"]]];
    [self.mobNumbLabel setAttributedText:[constant setColoredLabelandStar:[MCLocalization stringForKey:@"MobileLabel"]]];
    [self.emailLabel setAttributedText:[constant setColoredLabelandStar:[MCLocalization stringForKey:@"EmailLabel"]]];
    [self.certificateLabel setAttributedText:[constant setColoredLabelandStar:@"Certificates"]];
}
-(void)callSeedForGender{
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
@end
