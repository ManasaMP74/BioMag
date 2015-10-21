#import "LoginViewController.h"
#import "Constant.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *userNameTf;
@property (strong, nonatomic) IBOutlet UITextField *passwordTF;
@property (strong, nonatomic) IBOutlet UIButton *signIn;
@property (strong, nonatomic) IBOutlet UIView *loginView;

@end

@implementation LoginViewController
{
    Constant *constant;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    constant=[[Constant alloc]init];
     [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Sign-in-bg-image.jpg"]]];
       [self placeHolderText];
    _loginView.layer.cornerRadius=10;
    _loginView.backgroundColor=[UIColor colorWithRed:0.741 green:0.906 blue:0.965 alpha:0.9];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
//signin button action
- (IBAction)signIn:(id)sender {
    [self performSegueWithIdentifier:@"loginSuccess" sender:nil];
}
//placeHolderText
-(void)placeHolderText{
    _userNameTf.attributedPlaceholder=[constant textFieldPlaceLogin:@"Username"];
    _passwordTF.attributedPlaceholder=[constant textFieldPlaceLogin:@"Password"];
    [constant spaceAtTheBeginigOfTextField:_userNameTf];
    [constant spaceAtTheBeginigOfTextField:_passwordTF];
    [constant setFontFortextField:_userNameTf];
    [constant setFontFortextField:_passwordTF];
    [constant SetBorderForTextField:_userNameTf];
    [constant SetBorderForTextField:_passwordTF];
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
