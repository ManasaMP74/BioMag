#import "ForgotPasswordViewController.h"
#import "Constant.h"
#import "Postman.h"
#import "PostmanConstant.h"
#import "MBProgressHUD.h"
@interface ForgotPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTf;
@property (weak, nonatomic) IBOutlet UIView *loginView;

@end

@implementation ForgotPasswordViewController
{
    Constant *constant;
    Postman *postman;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    constant=[[Constant alloc]init];
    postman=[[Postman alloc]init];
    _userNameTf.attributedPlaceholder=[constant textFieldPlaceLogin:@"Email Address"];
    [constant spaceAtTheBeginigOfTextField:_userNameTf];
    [constant setFontFortextField:_userNameTf];
    [constant SetBorderForLoginTextField:_userNameTf];
    _loginView.layer.cornerRadius=10;
    _loginView.backgroundColor=[UIColor colorWithRed:0.741 green:0.906 blue:0.965 alpha:0.9];
    [self navigationItemMethod];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Sign-in-bg-image.jpg"]]];
    self.userNameTf.text=nil;
    self.navigationController.navigationBarHidden=NO;
}
//send mail
- (IBAction)send:(id)sender {
    [self callApi];
}
//gestureRecognize
- (IBAction)gesture:(id)sender {
    [self.view endEditing:YES];
}
-(void)callApi{
    if (_userNameTf.text.length==0) {
        [self showAlerView:@"Email Id is required"];
    }
    else{
        NSString *emailRegEx=@"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest=[NSPredicate predicateWithFormat:@"self matches %@",emailRegEx];
        BOOL validate= [emailTest evaluateWithObject:_userNameTf.text];
        if (!validate) {
         [self showAlerView:@"Email Id is invalid"];
        }
        else{
        NSString *parameter = [NSString stringWithFormat:@"{\"email\":\"%@\"}",_userNameTf.text];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl,forgotPassword];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [postman post:urlString withParameters:parameter
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSLog(@"Operations = %@", responseObject);
                  [self parseLoginResponse:responseObject];
                  [MBProgressHUD hideHUDForView:self.view animated:YES];
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [MBProgressHUD hideHUDForView:self.view animated:YES];
              }];
    }
}
}
-(void)parseLoginResponse:(id)responseObject{
    NSDictionary *responseDict = responseObject;
    if ([responseDict[@"Success"] intValue]==1)
    {
        [self showAlerViewSuccess:responseDict[@"Message"]];
    }else{
     [self showAlerView:responseDict[@"Message"]];
    }

}
-(void)showAlerViewSuccess:(NSString*)msg{
    UIAlertController *alertView=[UIAlertController alertControllerWithTitle:@"Alert!" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *success=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
        [self.navigationController popViewControllerAnimated:YES];
        [alertView dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertView addAction:success];
    [self presentViewController:alertView animated:YES completion:nil];
}
-(void)showAlerView:(NSString*)msg{
    UIAlertController *alertView=[UIAlertController alertControllerWithTitle:@"Alert!" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *success=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
        [alertView dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertView addAction:success];
    [self presentViewController:alertView animated:YES completion:nil];
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
    self.navigationItem.leftBarButtonItems=@[barItem];
    [button addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
}
-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
