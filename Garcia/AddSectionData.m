#import "AddSectionData.h"
#import "Constant.h"
#import "PostmanConstant.h"
#import "Postman.h"
#import "AppDelegate.h"
#import <MCLocalization/MCLocalization.h>
#import<AFNetworking/AFNetworking.h>
#import "MBProgressHUD.h"
@implementation AddSectionData
{
    UIView *view;
    UIControl  *alphaView;
    Constant *constant;
    Postman *postman;
    AppDelegate *appDel;
}
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    view=[[[NSBundle mainBundle]loadNibNamed:@"AddSectionData" owner:self options:nil]lastObject];
    [self initializeView];
     view.frame=self.bounds;
    [self addSubview:view];
    constant=[[Constant alloc]init];
    return self;
}
-(void)initializeView
{
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds  = YES;
    _nameTF.layer.borderWidth=1;
    _nameTF.layer.borderColor=[UIColor blackColor].CGColor;
    _nameTF.layer.cornerRadius=5;
}
-(void)alphaViewInitialize{
    if (alphaView == nil)
    {
        alphaView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alphaView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        [alphaView addSubview:view];
    }
     postman=[[Postman alloc]init];
    [_saveButton setTitle:[MCLocalization stringForKey:@"Save"] forState:normal];
    _nameTF.text=@"";
    [constant spaceAtTheBeginigOfTextField:_nameTF];
     _nameTF.attributedPlaceholder=[constant textFieldPlaceHolderText:[MCLocalization stringForKey:@"Name"]];
    appDel = [UIApplication sharedApplication].delegate;
  
    if ([_differForSaveData isEqualToString:@"scanpoint"]) {
        _titleLabel.text=[MCLocalization stringForKey:@"Scanpoint"];
    }else if ([_differForSaveData isEqualToString:@"correspondingpair"]) {
        _titleLabel.text=[MCLocalization stringForKey:@"Corresponding Pair"];
    }
    [alphaView addTarget:self action:@selector(hideAlphaview) forControlEvents:UIControlEventTouchUpInside];
    [appDel.window addSubview:alphaView];
    view.center = alphaView.center;
}
-(void)hideAlphaview{
    [alphaView removeFromSuperview];
}
- (IBAction)saveButton:(id)sender {
 if ([_differForSaveData isEqualToString:@"scanpoint"]) {
     [self callApiToSaveScanpoint];
 }else if ([_differForSaveData isEqualToString:@"correspondingpair"]) {
     [self callApiToSaveScanpoint];
 }
}
-(void)callApiToSaveScanpoint{
    NSString *url;
    if ([_differForSaveData isEqualToString:@"scanpoint"]) {
  url=[NSString stringWithFormat:@"%@%@/0",baseUrl,saveScanpoint];
    }else{
     url=[NSString stringWithFormat:@"%@%@/0",baseUrl,saveCorrespondingPair];
    }
    NSString *parameter;
    NSUserDefaults *defaultvalue=[NSUserDefaults standardUserDefaults];
    int userIdInteger=[[defaultvalue valueForKey:@"Id"]intValue];
    
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        //Parameter for Vzone Api
        parameter =[NSString stringWithFormat:@"{\"request\":{\"Name\":\"%@\",\"UserID\":%d,\"Status\":true,\"MethodType\":\"POST\"}}",_nameTF.text,userIdInteger];
    }else{
        //Parameter For Material Api
        parameter =[NSString stringWithFormat:@" {\"Name\":\"%@\",\"UserID\":%d,\"Status\":true,\"MethodType\":\"POST\"}",_nameTF.text,userIdInteger];
    }
    [MBProgressHUD showHUDAddedTo:alphaView animated:YES];
    [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:alphaView animated:NO];
        [self processToAddGerms:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:alphaView animated:NO];
        NSString *str=[NSString stringWithFormat:@"%@",error];
        [self showToastMessage:str];
    }];
}
-(void)processToAddGerms:(id)responseObject{
    NSDictionary *dict;
    NSDictionary *dict1=responseObject;
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        dict =dict1[@"aaData"];
    }else dict=responseObject;
    if ([dict[@"Success"]intValue]==1) {
         [self showToastMessage:dict[@"Message"]];
    }else{
        [self showToastMessage:dict[@"Message"]];
    }
}
-(void)showToastMessage:(NSString*)msg{
        MBProgressHUD *hubHUD=[MBProgressHUD showHUDAddedTo:alphaView animated:YES];
        hubHUD.mode=MBProgressHUDModeText;
        if (msg.length>0) {
            hubHUD.labelText=msg;
        }
        hubHUD.labelFont=[UIFont systemFontOfSize:15];
        hubHUD.margin=20.f;
        hubHUD.yOffset=150.f;
        hubHUD.removeFromSuperViewOnHide = YES;
        [hubHUD hide:YES afterDelay:2];
}
@end
