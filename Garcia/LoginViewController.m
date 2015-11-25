#import "LoginViewController.h"
#import "Constant.h"
#import "MBProgressHUD.h"
#import "PostmanConstant.h"
#import "Postman.h"

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
}
- (void)viewDidLoad {
    [super viewDidLoad];
    constant=[[Constant alloc]init];
    postman=[[Postman alloc]init];
     [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Sign-in-bg-image.jpg"]]];
       [self placeHolderText];
    _loginView.layer.cornerRadius=10;
    _loginView.backgroundColor=[UIColor colorWithRed:0.741 green:0.906 blue:0.965 alpha:0.9];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.userNameTf.text=nil;
    self.passwordTF.text=nil;
    self.navigationController.navigationBarHidden=YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
//signin button action
- (IBAction)signIn:(id)sender {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl, logIn];
   // NSString *parameter = [NSString stringWithFormat:@"{\"Username\":\"%@\",\"Password\":\"%@\"}",_userNameTf.text,_passwordTF.text];
    NSString *parameter = [NSString stringWithFormat:@"{\"Username\":\"drluisgarcia@mydomain.com\",\"Password\":\"Power@1234\"}"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [postman post:urlString withParameters:parameter
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"Operations = %@", responseObject);
              if (![self parseLoginResponse:responseObject]) {
                  UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Invalid Username or Password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                  [alert show];
                  
                  
              }else
              {
                  [self performSegueWithIdentifier:@"loginSuccess" sender:nil];
              }
              
              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"Some error occured. Please try again");
              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
              
          }];
}
//parse login response
- (BOOL)parseLoginResponse:(id)response
{
    NSDictionary *responseDict = response;
    if ([responseDict[@"Success"] boolValue])
    {
        NSDictionary *userDict = responseDict[@"UserDetailsViewModel"];
        if ([userDict[@"UserTypeCode"] isEqual:@"DOC123"]) {
            NSUserDefaults *defaultvalue=[NSUserDefaults standardUserDefaults];
            [defaultvalue setValue:responseDict[@"token"] forKey:@"X-access-Token"];
            return YES;
        }
        else return NO;
    }
    else
    {
        return NO;
    }
    
    return NO;
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
