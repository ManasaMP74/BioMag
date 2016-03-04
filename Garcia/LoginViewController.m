#import "LoginViewController.h"
#import "Constant.h"
#import "MBProgressHUD.h"
#import "PostmanConstant.h"
#import "Postman.h"
#import "AppDelegate.h"
#import "SeedSyncer.h"
#import <MCLocalization/MCLocalization.h>

@interface LoginViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *userNameTf;
@property (strong, nonatomic) IBOutlet UITextField *passwordTF;
@property (strong, nonatomic) IBOutlet UIButton *signIn;
@property (strong, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIButton *forgotPassword;

@end

@implementation LoginViewController
{
    Constant *constant;
    Postman *postman;
    AppDelegate *app;
    NSString *userNameRequiredStr,*PasswordRequiredStr,*alertOkStr,*alertStr,*authenticationFailedStr,*seedError,*loginFailed;
    NSUserDefaults *userdefault;
    LanguageChanger *langchanger;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    constant=[[Constant alloc]init];
    postman=[[Postman alloc]init];
    [self placeHolderText];
    _loginView.layer.cornerRadius=10;
    _loginView.backgroundColor=[UIColor colorWithRed:0.741 green:0.906 blue:0.965 alpha:0.9];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localize) name:MCLocalizationLanguageDidChangeNotification object:nil];
    userdefault =[NSUserDefaults standardUserDefaults];
    [self localize];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Sign-in-bg-image.jpg"]]];
    self.userNameTf.text=nil;
    self.passwordTF.text=nil;
    [_rememberMe setImage:[UIImage imageNamed:@"Box-Unchecked.png"] forState:normal];
    self.navigationController.navigationBarHidden=YES;
    
    BOOL remember=[userdefault boolForKey:@"rememberMe"];
    if (remember) {
        _userNameTf.text=[userdefault valueForKey:@"userName"];
        _passwordTF.text=[userdefault valueForKey:@"password"];
        [_rememberMe setImage:[UIImage imageNamed:@"Box-Checked.png"] forState:normal];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
// Remember me
- (IBAction)rememberMe:(id)sender {
    if (_userNameTf.text.length>0 & _passwordTF.text.length>0) {
        BOOL remember=[userdefault boolForKey:@"rememberMe"];
        if (!remember) {
            [userdefault setBool:YES forKey:@"rememberMe"];
            [userdefault setValue:_userNameTf.text forKey:@"userName"];
            [userdefault setValue:_passwordTF.text forKey:@"password"];
            [_rememberMe setImage:[UIImage imageNamed:@"Box-Checked.png"] forState:normal];
        }
        else {
            [userdefault setValue:@"" forKey:@"userName"];
            [userdefault setValue:@"" forKey:@"password"];
            [userdefault setBool:NO forKey:@"rememberMe"];
            [_rememberMe setImage:[UIImage imageNamed:@"Box-Unchecked.png"] forState:normal];
        }
    }
}
//signin button action
- (IBAction)signIn:(id)sender {
    
    NSString *urlString;
    NSString *parameter;
    
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        //Vzone API
        urlString = [NSString stringWithFormat:@"%@%@",baseUrl,logIn];
        // parameter = [NSString stringWithFormat:@"{\"request\":{\"Username\":\"drluisgarcia@mydomain.com\", \"Password\":\"Power@1234\"}}"];
        parameter = [NSString stringWithFormat:@"{\"request\":{\"Username\":\"%@\", \"Password\":\"%@\"}}",_userNameTf.text,_passwordTF.text];
    }else{
        //Material Api
        urlString = [NSString stringWithFormat:@"%@%@",baseUrl,logIn];
         parameter = [NSString stringWithFormat:@"{\"Username\":\"%@\",\"Password\":\"%@\"}",_userNameTf.text,_passwordTF.text];
       // parameter = [NSString stringWithFormat:@"{\"Username\":\"drluisgarcia@mydomain.com\", \"Password\":\"Power@1234\"}"];
        
    }
    
    if (_userNameTf.text.length==0 & _passwordTF.text.length==0) {
        [self showToastMessage:@"Username and Password is required"];
    }
    else if (_userNameTf.text.length==0) [self showToastMessage:@"Username is required"];
    else if (_passwordTF.text.length==0) [self showToastMessage:@"Password is required"];
    else{
        [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        [postman post:urlString withParameters:parameter
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                  NSLog(@"Operations = %@", responseObject);
                  if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
                      [self parseLoginResponseVzone:responseObject];
                  }else [self parseLoginResponseMatirial:responseObject];
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [MBProgressHUD hideHUDForView:self.view animated:NO];
                   [self showToastMessage:[NSString stringWithFormat:@"%@",error]];
              }];
    }
}

//parse login response of Matirial API
- (void)parseLoginResponseMatirial:(id)response
{
    NSDictionary *responseDict = response;
    if ([responseDict[@"Success"] intValue]==1)
    {
        NSDictionary *userDict = responseDict[@"UserDetailsViewModel"];
        if ([userDict[@"UserTypeCode"] isEqual:@"DOC123"]) {
            [userdefault setValue:responseDict[@"token"] forKey:@"X-access-Token"];
            NSArray *ar=responseDict[@"UserDetails"];
            NSDictionary *dict=ar[0];
            [userdefault setValue:dict[@"Id"] forKey:@"Id"];
            [userdefault setValue:dict[@"CompanyCode"] forKey:@"CompanyCode"];
            NSString *doctorName=[NSString stringWithFormat:@"%@ %@",dict[@"FirstName"],dict[@"LastName"]];
            [userdefault setValue:doctorName forKey:@"DoctorName"];
            [[SeedSyncer sharedSyncer] callSeedAPI:^(BOOL success) {
                if (success) {
                    [self performSegueWithIdentifier:@"loginSuccess" sender:nil];
                }
                else{
                    [userdefault setValue:@"" forKey:@"userName"];
                    [userdefault setValue:@"" forKey:@"password"];
                    [userdefault setBool:NO forKey:@"rememberMe"];
                    [self showToastMessage:seedError];
                }
            }];
        }
        else{
            [userdefault setValue:@"" forKey:@"userName"];
            [userdefault setValue:@"" forKey:@"password"];
            [userdefault setBool:NO forKey:@"rememberMe"];
            [self showToastMessage:loginFailed];
        }
    }
    else{
        [userdefault setValue:@"" forKey:@"userName"];
        [userdefault setValue:@"" forKey:@"password"];
        [userdefault setBool:NO forKey:@"rememberMe"];
        [self showToastMessage:responseDict[@"Message"]];
    }
}

//parse login response of Vzone API
- (void)parseLoginResponseVzone:(id)response
{
    NSDictionary *responseDict1 = response;
    NSDictionary *responseDict = responseDict1[@"aaData"];
    if ([responseDict[@"Success"] intValue]==1)
    {
        NSDictionary *userDict = responseDict[@"UserDetailsViewModel"];
        if ([userDict[@"UserTypeCode"] isEqual:@"DOC123"]) {
            [userdefault setValue:responseDict[@"token"] forKey:@"X-access-Token"];
            NSArray *ar=responseDict[@"UserDetails"];
            NSDictionary *dict=ar[0];
            [userdefault setValue:dict[@"Id"] forKey:@"Id"];
            [userdefault setValue:dict[@"CompanyCode"] forKey:@"CompanyCode"];
            NSString *doctorName=[NSString stringWithFormat:@"%@",dict[@"Name"]];
            [userdefault setValue:doctorName forKey:@"DoctorName"];
            NSMutableArray *doctorDetail=[[NSMutableArray alloc]init];
            [doctorDetail addObject:dict[@"Name"]];
            [doctorDetail addObject:dict[@"DOb"]];
            [doctorDetail addObject:dict[@"Email"]];
            NSString *str=dict[@"JSON"];
            NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
             [doctorDetail addObject:jsonDict[@"ContactNo"]];
            [doctorDetail addObject:dict[@"Name"]];
            [doctorDetail addObject:dict[@"Name"]];
             [doctorDetail addObject:dict[@"Gender"]];
            [userdefault setValue:doctorDetail forKey:@"DoctorDetail"];


            NSString *languageCode=dict[@"PreferredLanguageCode"];
            if ([languageCode isEqualToString:@"(null)"]) {
              languageCode=@"en";
            }
            [userdefault setValue:languageCode forKey:@"languageCode"];
            [[SeedSyncer sharedSyncer] callSeedAPI:^(BOOL success) {
                if (success) {
                    [self languageChanger];
                }
                else{
                    [userdefault setValue:@"" forKey:@"userName"];
                    [userdefault setValue:@"" forKey:@"password"];
                    [userdefault setBool:NO forKey:@"rememberMe"];
                    [self showToastMessage:seedError];
                }
            }];
        }
        else{
            [userdefault setValue:@"" forKey:@"userName"];
            [userdefault setValue:@"" forKey:@"password"];
            [userdefault setBool:NO forKey:@"rememberMe"];
            [self showToastMessage:authenticationFailedStr];
        }
    }
    else{
        [userdefault setValue:@"" forKey:@"userName"];
        [userdefault setValue:@"" forKey:@"password"];
        [userdefault setBool:NO forKey:@"rememberMe"];
        //sleep(1);
        [self showToastMessage:responseDict[@"Message"]];
    }
}
-(void)languageChanger{
    langchanger=[[LanguageChanger alloc]init];
    [langchanger callApiForPreferredLanguage];
    langchanger.delegate=self;
}
-(void)languageChangeDelegate:(int)str{
    if (str==0) {
        [self showToastMessage:seedError];
    }else
        [langchanger readingLanguageFromDocument];
          [self performSegueWithIdentifier:@"loginSuccess" sender:nil];
}
//validate login
- (BOOL)validateLoginFields
{
    NSString *emailId = self.userNameTf.text;
    NSString *password = self.passwordTF.text;
    BOOL goodToGo = YES;
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    if (emailId.length == 0)
    {
        goodToGo = NO;
        [mutableString appendString:userNameRequiredStr];
    }
    if (password.length == 0)
    {
        goodToGo = NO;
        [mutableString appendString:PasswordRequiredStr];
    }
    if (!goodToGo)
    {
    }
    return goodToGo;
}
//placeHolderText
-(void)placeHolderText{
    [constant spaceAtTheBeginigOfTextField:_userNameTf];
    [constant spaceAtTheBeginigOfTextField:_passwordTF];
    [constant setFontFortextField:_userNameTf];
    [constant setFontFortextField:_passwordTF];
    [constant SetBorderForLoginTextField:_userNameTf];
    [constant SetBorderForLoginTextField:_passwordTF];
    _signIn.layer.cornerRadius=5;
}
//Hide Keyboard after tap on return
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
//Hide Keyboard after tap on view
- (IBAction)tapGesture:(id)sender {
    [self.view endEditing:YES];
}

//Alert Message
-(void)showAlerView:(NSString*)msg{
    UIAlertController *alertView=[UIAlertController alertControllerWithTitle:alertStr message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *success=[UIAlertAction actionWithTitle:alertOkStr style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
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
//languageChange
-(void)localize
{
    _userNameTf.attributedPlaceholder=[constant textFieldPlaceLogin:@"Username"];
    _passwordTF.attributedPlaceholder=[constant textFieldPlaceLogin:@"Password"];
    authenticationFailedStr=@"Authentication failed";
    alertStr=@"Alert!";
    alertOkStr=@"OK";
    userNameRequiredStr=@"User name is required";
    PasswordRequiredStr=@"Password is required";
    seedError=@"Some error occured Please try again";
    loginFailed= @"Login failed";
    [_signIn setTitle:@"Sign In" forState:normal];
    [_forgotPassword setTitle:@"Forgot password?" forState:normal];
    
    
    
    //    _userNameTf.attributedPlaceholder=[constant textFieldPlaceLogin:[MCLocalization stringForKey:@"Username"]];
    //    _passwordTF.attributedPlaceholder=[constant textFieldPlaceLogin:[MCLocalization stringForKey:@"Password"]];
    //    authenticationFailedStr=[MCLocalization stringForKey:@"Authentication.failed"];
    //    alertStr=[MCLocalization stringForKey:@"Alert!"];
    //    alertOkStr=[MCLocalization stringForKey:@"AlertButtonOK"];
    //    userNameRequiredStr=[MCLocalization stringForKey:@"User.Name.is.required"];
    //    PasswordRequiredStr=[MCLocalization stringForKey:@"Password.is.required"];
    //    seedError=@"Some.error.occured.Please.try.again";
    //    loginFailed= @"Login.failed";
    //    [_signIn setTitle:[MCLocalization stringForKey:@"Sign.In"] forState:normal];
    //    [_forgotPassword setTitle:[MCLocalization stringForKey:@"Forgot.password?"] forState:normal];
}
@end
