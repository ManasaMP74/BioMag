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
     [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"01-Splash"]]];
       [self placeHolderText];
    _loginView.layer.cornerRadius=10;
    
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
    _userNameTf.attributedPlaceholder=[constant textFieldPlaceHolderText:@"UserName"];
    _passwordTF.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Password"];
    [constant spaceAtTheBeginigOfTextField:_userNameTf];
    [constant spaceAtTheBeginigOfTextField:_passwordTF];
    [constant setFontForbutton:_signIn];
    [constant setFontFortextField:_userNameTf];
    [constant setFontFortextField:_passwordTF];
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
