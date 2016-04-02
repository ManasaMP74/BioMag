#import "AddAnotomicalPointsViewController.h"
#import "Constant.h"
#import "Postman.h"
#import "PostmanConstant.h"
#import <MCLocalization/MCLocalization.h>
#import "MBProgressHUD.h"
#import "SittingViewController.h"
@interface AddAnotomicalPointsViewController ()

@end

@implementation AddAnotomicalPointsViewController
{
    Constant *constant;
    NSString *alertStr,*alertOkStr;
    Postman *postman;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    constant=[[Constant alloc]init];
     [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background-Image-1.jpg"]]];
    [self textFieldLayer];
    [self navigationItemMethod];
    [self localize];
    postman=[[Postman alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (IBAction)saveButtonForScanpoint:(id)sender {
    [self callApiToSaveScanpoint:@"scanpoint"];
}
- (IBAction)saveButtonForCorrespondingPair:(id)sender {
    [self callApiToSaveScanpoint:@"CorrespondingPair"];
}
- (IBAction)saveButtonForanatomicalPoint:(id)sender {
[self popView];
}
- (IBAction)cancel:(id)sender {
 [self popView];
}
-(void)callApiToSaveScanpoint:(NSString*)differForSaveData{
    NSString *url;
    NSString *parameter;
    NSUserDefaults *defaultvalue=[NSUserDefaults standardUserDefaults];
    int userIdInteger=[[defaultvalue valueForKey:@"Id"]intValue];
    
    if ([differForSaveData isEqualToString:@"scanpoint"]) {
        url=[NSString stringWithFormat:@"%@%@/0",baseUrl,saveScanpoint];
        if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
            //Parameter for Vzone Api
            parameter =[NSString stringWithFormat:@"{\"request\":{\"Name\":\"%@\",\"UserID\":%d,\"Status\":true,\"MethodType\":\"POST\"}}",_scanpointNameTF.text,userIdInteger];
        }else{
            //Parameter For Material Api
            parameter =[NSString stringWithFormat:@" {\"Name\":\"%@\",\"UserID\":%d,\"Status\":true,\"MethodType\":\"POST\"}",_scanpointNameTF.text,userIdInteger];
        }
    }else{
        url=[NSString stringWithFormat:@"%@%@/0",baseUrl,saveCorrespondingPair];
        if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
            //Parameter for Vzone Api
            parameter =[NSString stringWithFormat:@"{\"request\":{\"Name\":\"%@\",\"UserID\":%d,\"Status\":true,\"MethodType\":\"POST\"}}",_correspondingNameTF.text,userIdInteger];
        }else{
            //Parameter For Material Api
            parameter =[NSString stringWithFormat:@" {\"Name\":\"%@\",\"UserID\":%d,\"Status\":true,\"MethodType\":\"POST\"}",_correspondingNameTF.text,userIdInteger];
        }
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        [self processToAddScanpoinOrCorrespondingPair:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        NSString *str=[NSString stringWithFormat:@"%@",error];
        [self showToastMessage:str];
    }];
}
-(void)processToAddScanpoinOrCorrespondingPair:(id)responseObject{
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
    MBProgressHUD *hubHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
-(void)textFieldLayer{
    [constant spaceAtTheBeginigOfTextField:_scanpointNameTF];
    [constant spaceAtTheBeginigOfTextField:_scanpointLocationTF];
    [constant spaceAtTheBeginigOfTextField:_correspondingNameTF];
    [constant spaceAtTheBeginigOfTextField:_correspondingLocationTF];
    [constant spaceAtTheBeginigOfTextField:_anatomicalNameTF];
    [constant spaceAtTheBeginigOfTextField:_anatomicalLocationTF];
    [constant spaceAtTheBeginigOfTextField:_anatomicalSortNumberTF];
    [constant SetBorderForTextField:_scanpointNameTF];
    [constant SetBorderForTextField:_anatomicalSortNumberTF];
    [constant SetBorderForTextField:_anatomicalLocationTF];
    [constant SetBorderForTextField:_anatomicalNameTF];
    [constant SetBorderForTextField:_correspondingLocationTF];
    [constant SetBorderForTextview:_descriptionTV];
    [constant SetBorderForTextField:_correspondingNameTF];
    [constant SetBorderForTextField:_scanpointLocationTF];
    [constant setFontFortextField:_scanpointNameTF];
    [constant setFontFortextField:_scanpointNameTF];
    [constant setFontFortextField:_scanpointLocationTF];
    [constant setFontFortextField:_correspondingNameTF];
    [constant setFontFortextField:_correspondingLocationTF];
    [constant setFontFortextField:_anatomicalNameTF];
    [constant setFontFortextField:_anatomicalLocationTF];
    [constant setFontFortextField:_anatomicalSortNumberTF];
    _descriptionTV.textContainerInset = UIEdgeInsetsMake(10, 5, 10, 10);
    [constant changeSaveBtnImage:_saveBtn];
    [constant changeCancelBtnImage:_cancelBtn];
}
-(void)navigationItemMethod{
    self.navigationItem.hidesBackButton=YES;
    UIImage* image = [UIImage imageNamed:@"Back button.png"];
    CGRect frameimg1 = CGRectMake(100, 0, image.size.width+30, image.size.height);
    UIButton *button=[[UIButton alloc]initWithFrame:frameimg1];
    [button setImage:image forState:UIControlStateNormal];
    UIBarButtonItem *barItem=[[UIBarButtonItem alloc]initWithCustomView:button];
    UIBarButtonItem *negativeSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpace.width=-20;
    self.navigationItem.leftBarButtonItems=@[negativeSpace,barItem];
    [button addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
    self.title=[MCLocalization stringForKey:@"Add Anatomical Points"];
}
-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)localize
{
    alertStr=[MCLocalization stringForKey:@"Alert!"];
    alertOkStr=[MCLocalization stringForKey:@"AlertOK"];
    [_cancelBtn setTitle:[MCLocalization stringForKey:@"Cancel"] forState:normal];
    [_saveBtn setTitle:[MCLocalization stringForKey:@"Save"] forState:normal];
    _scanponitNameLabel.text=[MCLocalization stringForKey:@"Name"];
     _correspondingPairNameLabel.text=[MCLocalization stringForKey:@"Name"];
    _scanpointLocationLabel.text=[MCLocalization stringForKey:@"Location"];
    _correspondingPairLocationLabel.text=[MCLocalization stringForKey:@"Location"];
    _addScanpointLabel.text=[MCLocalization stringForKey:@"Add Scan Point"];
    _addCorrespondingPairLabel.text=[MCLocalization stringForKey:@"Add Corresponding Pair"];
     _anotomicalSortNumberLabel.text=[MCLocalization stringForKey:@"Sort Number"];
     _anotomicalScanpointNameLabel.text=[MCLocalization stringForKey:@"Scan Point"];
     _anotomicalCorrespondingLabel.text=[MCLocalization stringForKey:@"Corresponding Pair"];
     _mapAnotomicalLabel.text=[MCLocalization stringForKey:@"Map Anatomical Points"];
     _descriptionLabel.text=[MCLocalization stringForKey:@"Description"];
}
@end
