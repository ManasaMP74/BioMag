#import "LoginViewController.h"
#import "Constant.h"
#import "MBProgressHUD.h"
#import "PostmanConstant.h"
#import "Postman.h"
#import "AppDelegate.h"
#import "SeedSyncer.h"
@interface LoginViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *userNameTf;
@property (strong, nonatomic) IBOutlet UITextField *passwordTF;
@property (strong, nonatomic) IBOutlet UIButton *signIn;
@property (strong, nonatomic) IBOutlet UIView *loginView;

@end

@implementation LoginViewController
{
    Constant *constant;
    Postman *postman;
    AppDelegate *app;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    constant=[[Constant alloc]init];
    postman=[[Postman alloc]init];
       [self placeHolderText];
    _loginView.layer.cornerRadius=10;
    _loginView.backgroundColor=[UIColor colorWithRed:0.741 green:0.906 blue:0.965 alpha:0.9];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Sign-in-bg-image.jpg"]]];
    self.userNameTf.text=nil;
    self.passwordTF.text=nil;
    self.navigationController.navigationBarHidden=YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
        parameter = [NSString stringWithFormat:@"{\"Username\":\"%@\",\"Password\":\"%@\"}",_userNameTf.text,_passwordTF.text];
        //NSString *parameter = [NSString stringWithFormat:@"{\"Username\":\"drluisgarcia@mydomain.com\", \"Password\":\"Power@1234\"}"];
    
    }
    
    
//    if (_userNameTf.text.length==0 & _passwordTF.text.length==0) {
//        [self showAlerView:@"Username and Password is required"];
//    }
//    else if (_userNameTf.text.length==0) [self showAlerView:@"Username is required"];
//    else if (_passwordTF.text.length==0) [self showAlerView:@"Password is required"];
//    else{
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
              [MBProgressHUD hideHUDForView:self.view animated:YES];
          }];
// }
}

//parse login response of Matirial API
- (void)parseLoginResponseMatirial:(id)response
{
    NSDictionary *responseDict = response;
    if ([responseDict[@"Success"] intValue]==1)
    {
        NSDictionary *userDict = responseDict[@"UserDetailsViewModel"];
        if ([userDict[@"UserTypeCode"] isEqual:@"DOC123"]) {
            NSUserDefaults *defaultvalue=[NSUserDefaults standardUserDefaults];
            [defaultvalue setValue:responseDict[@"token"] forKey:@"X-access-Token"];
            NSArray *ar=responseDict[@"UserDetails"];
            NSDictionary *dict=ar[0];
            [defaultvalue setValue:dict[@"Id"] forKey:@"Id"];
            [defaultvalue setValue:dict[@"CompanyCode"] forKey:@"CompanyCode"];
            [[SeedSyncer sharedSyncer] callSeedAPI:^(BOOL success) {
                if (success) {
                    [self performSegueWithIdentifier:@"loginSuccess" sender:nil];
                }
                else{
                   [self showAlerView:@"Login failed"];
                }
            }];
        }
        else{
            [self showAlerView:@"Authentication failed"];
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
            NSUserDefaults *defaultvalue=[NSUserDefaults standardUserDefaults];
            [defaultvalue setValue:responseDict[@"token"] forKey:@"X-access-Token"];
            NSArray *ar=responseDict[@"UserDetails"];
            NSDictionary *dict=ar[0];
            [defaultvalue setValue:dict[@"Id"] forKey:@"Id"];
            [defaultvalue setValue:dict[@"CompanyCode"] forKey:@"CompanyCode"];
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
            [self showAlerView:@"Authentication failed"];
        }
    }
    else{
        [self showAlerView:responseDict[@"Message"]];
    }
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
        [mutableString appendString:@"'User Name' is required\n"];
    }
    if (password.length == 0)
    {
        goodToGo = NO;
        [mutableString appendString:@"'Password' is required"];
    }
    if (!goodToGo)
    {
    }
    return goodToGo;
}
//placeHolderText
-(void)placeHolderText{
    _userNameTf.attributedPlaceholder=[constant textFieldPlaceLogin:@"Username"];
    _passwordTF.attributedPlaceholder=[constant textFieldPlaceLogin:@"Password"];
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
@end
