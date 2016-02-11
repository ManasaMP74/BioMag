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
        parameter = [NSString stringWithFormat:@"{\"request\":{\"Username\":\"drluisgarcia@mydomain.com\", \"Password\":\"Power@1234\"}}"];
        // NSString *parameter = [NSString stringWithFormat:@"{\"request\":{\"Username\":\"%@\", \"Password\":\"%@\"}}",_userNameTf.text,_passwordTF.text];
    }else{
        //Material Api
        urlString = [NSString stringWithFormat:@"%@%@",baseUrl,logIn];
        // parameter = [NSString stringWithFormat:@"{\"Username\":\"%@\",\"Password\":\"%@\"}",_userNameTf.text,_passwordTF.text];
        parameter = [NSString stringWithFormat:@"{\"Username\":\"drluisgarcia@mydomain.com\", \"Password\":\"Power@1234\"}"];
        
    }
    
    if (_userNameTf.text.length==0 & _passwordTF.text.length==0) {
        [self showAlerView:@"Username and Password is required"];
    }
    else if (_userNameTf.text.length==0) [self showAlerView:@"Username is required"];
    else if (_passwordTF.text.length==0) [self showAlerView:@"Password is required"];
    else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [postman post:urlString withParameters:parameter
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSLog(@"Operations = %@", responseObject);
                  if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
                      [self parseLoginResponseVzone:responseObject];
                  }else [self parseLoginResponseMatirial:responseObject];
                  [MBProgressHUD hideHUDForView:self.view animated:YES];
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [self showAlerView:[NSString stringWithFormat:@"%@",error]];
                  [MBProgressHUD hideHUDForView:self.view animated:YES];
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
            [[SeedSyncer sharedSyncer] callSeedAPI:^(BOOL success) {
                if (success) {
                    [self performSegueWithIdentifier:@"loginSuccess" sender:nil];
                }
                else{
                    [self showAlerView:seedError];
                }
            }];
        }
        else{
            [self showAlerView:loginFailed];
        }
    }
    else{
        [self showAlerView:responseDict[@"Message"]];
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
            //            [[SeedSyncer sharedSyncer] callSeedAPI:^(BOOL success) {
            //                if (success) {
            [self performSegueWithIdentifier:@"loginSuccess" sender:nil];
            //                }
            //                else{
            //                   [self showAlerView:@"Unkown error occured. Please try again."];
            //                }
            //            }];
        }
        else{
            [self showAlerView:authenticationFailedStr];
        }
    }
    else{
        [self showAlerView:responseDict[@"Message"]];
    }
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

//languageChange
-(void)localize
{
    _userNameTf.attributedPlaceholder=[constant textFieldPlaceLogin:[MCLocalization stringForKey:@"Username"]];
    _passwordTF.attributedPlaceholder=[constant textFieldPlaceLogin:[MCLocalization stringForKey:@"Password"]];
    authenticationFailedStr=[MCLocalization stringForKey:@"Authentication.failed"];
    alertStr=[MCLocalization stringForKey:@"Alert!"];
    alertOkStr=[MCLocalization stringForKey:@"AlertButtonOK"];
    userNameRequiredStr=[MCLocalization stringForKey:@"User.Name.is.required"];
    PasswordRequiredStr=[MCLocalization stringForKey:@"Password.is.required"];
    seedError=@"Some.error.occured.Please.try.again";
    loginFailed= @"Login.failed";
    [_signIn setTitle:[MCLocalization stringForKey:@"Sign.In"] forState:normal];
    [_forgotPassword setTitle:[MCLocalization stringForKey:@"Forgot.password?"] forState:normal];
}
@end
