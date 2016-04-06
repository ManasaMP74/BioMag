#import "AddAnotomicalPointsViewController.h"
#import "Constant.h"
#import "Postman.h"
#import "PostmanConstant.h"
#import <MCLocalization/MCLocalization.h>
#import "MBProgressHUD.h"
#import "SittingViewController.h"
#import "SeedSyncer.h"
#import "germsModel.h"
#import "CompleteScanpointModel.h"
#import "CompleteCorrespondingpairModel.h"
#import "CompleteSectionModel.h"
#import "CompleteAuthorModel.h"
@interface AddAnotomicalPointsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate>

@end

@implementation AddAnotomicalPointsViewController
{
    Constant *constant;
    NSString *alertStr,*alertOkStr,*requiredNameField,*requiredLocationField,*requiredBoth,*requiredSection,*requiredScanpoint,*requiredCorrespondingpair,*requiredAuthor,*requiredGerms,*requiredSort,*requiredDesc;
    Postman *postman;
    NSMutableArray *scanpointArray,*correspondingPointArray,*authorArray,*germsArray,*sectionArray;
    NSString *selectedGermsCode,*selectedSection,*selectedScanpoint,*selectedCorrespondingpair,*selectedAuthor;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    constant=[[Constant alloc]init];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background-Image-1.jpg"]]];
    [self textFieldLayer];
    [self navigationItemMethod];
    [self localize];
    scanpointArray=[[NSMutableArray alloc]init];
    correspondingPointArray=[[NSMutableArray alloc]init];
    sectionArray=[[NSMutableArray alloc]init];
    germsArray=[[NSMutableArray alloc]init];
    authorArray=[[NSMutableArray alloc]init];
    postman=[[Postman alloc]init];
    [self callSeedForGerms];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self setDefault];
    [self.view endEditing:YES];
    [self hideTheViews:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)setDefault{
    selectedGermsCode=@"";
    selectedSection=@"";
    selectedScanpoint=@"";
    selectedCorrespondingpair=@"";
    selectedAuthor=@"";
    _anatomicalAuthorTF.text=@"";
    _anatomicalGermsTF.text=@"";
    _anatomicalSectionTF.text=@"";
    _anatomicalCorrespondingPairTF.text=@"";
    _anatomicalScanpointTF.text=@"";
    _scanpointNameTF.text=@"";
    _scanpointLocationTF.text=@"";
    _correspondingNameTF.text=@"";
    _correspondingLocationTF.text=@"";
}
- (IBAction)saveButtonForScanpoint:(id)sender {
    [self.view endEditing:YES];
    [self hideTheViews:nil];
    if (_scanpointNameTF.text.length==0) {
        [self showToastMessage:requiredNameField];
    }else if (_scanpointLocationTF.text.length==0) {
        [self showToastMessage:requiredLocationField];
    }else if (_scanpointLocationTF.text.length==0 & _scanpointNameTF.text.length==0) {
        [self showToastMessage:requiredBoth];
    }
    else
        [self callApiToSaveScanpoint:@"scanpoint"];
}
- (IBAction)saveButtonForCorrespondingPair:(id)sender {
    [self.view endEditing:YES];
    [self hideTheViews:nil];
    if (_correspondingNameTF.text.length==0) {
        [self showToastMessage:requiredNameField];
    }else if (_correspondingLocationTF.text.length==0) {
        [self showToastMessage:requiredLocationField];
    }else if (_correspondingNameTF.text.length==0 & _correspondingLocationTF.text.length==0) {
        [self showToastMessage:requiredBoth];
    }   else [self callApiToSaveScanpoint:@"CorrespondingPair"];
}
- (IBAction)saveButtonForanatomicalPoint:(id)sender {
    [self.view endEditing:YES];
    [self hideTheViews:nil];
    NSMutableArray *alertArray=[[NSMutableArray alloc]init];
    if (_anatomicalSectionTF.text.length==0) {
        [alertArray addObject:[NSString stringWithFormat:@"%@\n",requiredSection]];
    }
    if (_anatomicalScanpointTF.text.length==0) {
        [alertArray addObject:[NSString stringWithFormat:@"%@\n",requiredScanpoint]];
    }
    if (_anatomicalCorrespondingPairTF.text.length==0) {
        [alertArray addObject:[NSString stringWithFormat:@"%@\n",requiredCorrespondingpair]];
    }
    if (_anatomicalAuthorTF.text.length==0) {
        [alertArray addObject:[NSString stringWithFormat:@"%@\n",requiredAuthor]];
    }
    if (_anatomicalGermsTF.text.length==0) {
        [alertArray addObject:[NSString stringWithFormat:@"%@\n",requiredGerms]];
    }
//    if (_anatomicalSortNumberTF.text.length==0) {
//        [alertArray addObject:[NSString stringWithFormat:@"%@\n",requiredSort]];
//    }
//    if (_descriptionTV.text.length==0) {
//        [alertArray addObject:[NSString stringWithFormat:@"%@\n",requiredDesc]];
//    }
    
    if (alertArray.count==0) {
        [self callApiToSaveScanpoint:@"anatomical"];
    }else{
        NSString *str1=@"";
        for (NSString *str in alertArray) {
            str1=[str1 stringByAppendingString:str];
        }
        [self alertMessage:str1];
    }
}
- (IBAction)cancel:(id)sender {
    [self.view endEditing:YES];
    [self hideTheViews:nil];
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
            parameter =[NSString stringWithFormat:@"{\"request\":{\"Id\":0,\"Name\":\"%@\",\"LocationScanPoint\":\"%@\",\"Status\":true,\"IsPublished\":false,\"CompanyCode\":\"%@\",\"UserID\":%d,\"MethodType\":\"POST\"}}",_scanpointNameTF.text,_scanpointLocationTF.text,postmanCompanyCode,userIdInteger];
        }else{
            //Parameter For Material Api
            parameter =[NSString stringWithFormat:@"{\"request\":{\"Id\":0,\"Name\":\"%@\",\"LocationScanPoint\":\"%@\",\"Status\":true,\"IsPublished\":false,\"CompanyCode\":\"%@\",\"UserID\":%d,\"MethodType\":\"POST\"}}",_scanpointNameTF.text,_scanpointLocationTF.text,postmanCompanyCode,userIdInteger];
        }
    }else if ([differForSaveData isEqualToString:@"CorrespondingPair"]){
        url=[NSString stringWithFormat:@"%@%@/0",baseUrl,saveCorrespondingPair];
        if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
            //Parameter for Vzone Api
              parameter =[NSString stringWithFormat:@"{\"request\":{\"Id\":0,\"Name\":\"%@\",\"LocationCorrespondingPair\":\"%@\",\"Status\":true,\"IsPublished\":false,\"CompanyCode\":\"%@\",\"UserID\":%d,\"MethodType\":\"POST\"}}",_correspondingNameTF.text,_correspondingLocationTF.text,postmanCompanyCode,userIdInteger];
            
        }else{
            //Parameter For Material Api
            parameter =[NSString stringWithFormat:@"{\"request\":{\"Id\":0,\"Name\":\"%@\",\"LocationCorrespondingPair\":\"%@\",\"Status\":true,\"IsPublished\":false,\"CompanyCode\":\"%@\",\"UserID\":%d,\"MethodType\":\"POST\"}}",_correspondingNameTF.text,_correspondingLocationTF.text,postmanCompanyCode,userIdInteger];
        }
    }else{
        url=[NSString stringWithFormat:@"%@%@/0",baseUrl,addAnatomicalPoints];
        if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
            //Parameter for Vzone Api
            parameter =[NSString stringWithFormat:@"{\"request\":{\"Id\":\"0\",\"SectionCode\":\"%@\",\"ScanPointCode\":\"%@\",\"CorrespondingPairCode\":\"%@\",\"IsPublished\":false,\"GermsCode\":\"%@\",\"Status\":true,\"GenderCode\":\"\",\"Author\":\"%@\",\"ApplicableVersionCode\":\"KP18Z7\",\"AppTypeCode\":\"2AP7S5\",\"Psychoemotional\":\"\",\"Description\":\"%@\",\"CompanyCode\":\"%@\",\"UserID\":%d,\"MethodType\":\"POST\"}}",selectedSection,selectedScanpoint,selectedCorrespondingpair,selectedGermsCode,selectedAuthor,_descriptionTV.text, postmanCompanyCode, userIdInteger];
        }else{
            //Parameter For Material Api
           parameter =[NSString stringWithFormat:@"{\"request\":{\"Id\":\"0\",\"SectionCode\":\"%@\",\"ScanPointCode\":\"%@\",\"CorrespondingPairCode\":\"%@\",\"IsPublished\":false,\"GermsCode\":\"%@\",\"Status\":true,\"GenderCode\":\"\",\"Author\":\"%@\",\"ApplicableVersionCode\":\"KP18Z7\",\"AppTypeCode\":\"2AP7S5\",\"Psychoemotional\":\"\",\"Description\":\"%@\",\"CompanyCode\":\"%@\",\"UserID\":%d,\"MethodType\":\"POST\"}}",selectedSection,selectedScanpoint,selectedCorrespondingpair,selectedGermsCode,selectedAuthor,_descriptionTV.text, postmanCompanyCode, userIdInteger];
        }
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        [self processToAddScanpoinOrCorrespondingPair:responseObject withDiffer:differForSaveData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        NSString *str=[NSString stringWithFormat:@"%@",error];
        [self showToastMessage:str];
    }];
}
-(void)processToAddScanpoinOrCorrespondingPair:(id)responseObject withDiffer:(NSString*)differForSaveData{
    NSDictionary *dict;
    NSDictionary *dict1=responseObject;
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        dict =dict1[@"aaData"];
    }else dict=responseObject;
    if ([differForSaveData isEqualToString:@"scanpoint"] | [differForSaveData isEqualToString:@"CorrespondingPair"]) {
        if ([dict[@"Success"]intValue]==1) {
            [self showToastMessage:dict[@"Message"]];
            if ([differForSaveData isEqualToString:@"scanpoint"]){
                _scanpointNameTF.text=@"";
                _scanpointLocationTF.text=@"";
            }else{
                _correspondingNameTF.text=@"";
                _correspondingLocationTF.text=@"";
            }
        }else{
            [self showToastMessage:dict[@"Message"]];
        }
    }else  if ([differForSaveData isEqualToString:@"anatomical"]){
     if ([dict[@"Success"]intValue]==1) {
         [self alertView:dict[@"Message"]];
     
     }else{
      [self showToastMessage:dict[@"Message"]];
     }
    }
}
-(void)alertView:(NSString*)message{
    UIAlertController *alertView=[UIAlertController alertControllerWithTitle:alertStr message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *success=[UIAlertAction actionWithTitle:alertOkStr style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
        [alertView dismissViewControllerAnimated:YES completion:nil];
        [self popView];
    }];
    [alertView addAction:success];
    [self presentViewController:alertView animated:YES completion:nil];
}
-(void)alertMessage:(NSString*)message{
    UIAlertController *alertView=[UIAlertController alertControllerWithTitle:alertStr message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *success=[UIAlertAction actionWithTitle:alertOkStr style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
        [alertView dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertView addAction:success];
    [self presentViewController:alertView animated:YES completion:nil];
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
    [constant spaceAtTheBeginigOfTextField:_anatomicalScanpointTF];
    [constant spaceAtTheBeginigOfTextField:_anatomicalCorrespondingPairTF];
    [constant spaceAtTheBeginigOfTextField:_anatomicalSortNumberTF];
    [constant SetBorderForTextField:_scanpointNameTF];
    [constant SetBorderForTextField:_anatomicalSortNumberTF];
    [constant SetBorderForTextField:_anatomicalCorrespondingPairTF];
    [constant SetBorderForTextField:_anatomicalScanpointTF];
    [constant SetBorderForTextField:_correspondingLocationTF];
    [constant SetBorderForTextview:_descriptionTV];
    [constant SetBorderForTextField:_correspondingNameTF];
    [constant SetBorderForTextField:_scanpointLocationTF];
    [constant setFontFortextField:_scanpointNameTF];
    [constant setFontFortextField:_scanpointNameTF];
    [constant setFontFortextField:_scanpointLocationTF];
    [constant setFontFortextField:_correspondingNameTF];
    [constant setFontFortextField:_correspondingLocationTF];
    [constant setFontFortextField:_anatomicalScanpointTF];
    [constant setFontFortextField:_anatomicalCorrespondingPairTF];
    [constant setFontFortextField:_anatomicalSortNumberTF];
    _descriptionTV.textContainerInset = UIEdgeInsetsMake(10, 5, 10, 10);
    [constant changeSaveBtnImage:_saveBtn];
    [constant changeCancelBtnImage:_cancelBtn];
    [constant spaceAtTheBeginigOfTextField:_anatomicalSectionTF];
    [constant SetBorderForTextField:_anatomicalSectionTF];
    [constant setFontFortextField:_anatomicalSectionTF];
    [constant spaceAtTheBeginigOfTextField:_anatomicalGermsTF];
    [constant SetBorderForTextField:_anatomicalGermsTF];
    [constant setFontFortextField:_anatomicalGermsTF];
    [constant spaceAtTheBeginigOfTextField:_anatomicalAuthorTF];
    [constant SetBorderForTextField:_anatomicalAuthorTF];
    [constant setFontFortextField:_anatomicalAuthorTF];
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
-(void)hideTheViews:(UITextField*)text{
    if ([_anatomicalSectionTF isEqual:text]) {
        _sectionTableview.hidden=NO;
    }else _sectionTableview.hidden=YES;
    
    if ([_anatomicalScanpointTF isEqual:text]) {
        _scanpointTable.hidden=NO;
    }else _scanpointTable.hidden=YES;
    
    if ([_anatomicalCorrespondingPairTF isEqual:text]) {
        _correspondingPairTable.hidden=NO;
    }else _correspondingPairTable.hidden=YES;
    
    if ([_anatomicalGermsTF isEqual:text]) {
        _germsTableView.hidden=NO;
    }else _germsTableView.hidden=YES;
    
    if ([_anatomicalAuthorTF isEqual:text]) {
        _authorTableView.hidden=NO;
    }else _authorTableView.hidden=YES;
}
- (IBAction)gestureRecognizer:(id)sender {
    [self.view endEditing:YES];
    [self hideTheViews:nil];
}
- (IBAction)selectScanpoint:(id)sender {
    [self.view endEditing:YES];
    [self hideTheViews:_anatomicalScanpointTF];
    [_scanpointTable reloadData];
}
- (IBAction)selectCorrespondingPair:(id)sender {
    [self.view endEditing:YES];
    [self hideTheViews:_anatomicalCorrespondingPairTF];
    [_correspondingPairTable reloadData];
}
- (IBAction)selectSection:(id)sender {
    [self.view endEditing:YES];
    [self hideTheViews:_anatomicalSectionTF];
    [_sectionTableview reloadData];
}
- (IBAction)selectGerms:(id)sender {
    [self.view endEditing:YES];
    [self hideTheViews:_anatomicalGermsTF];
    [_germsTableView reloadData];
}
- (IBAction)selectAuthor:(id)sender {
    [self.view endEditing:YES];
    [self hideTheViews:_anatomicalAuthorTF];
    [_authorTableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
//TableView Number of row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_sectionTableview])
    {
        return sectionArray.count;
    }
    else if ([tableView isEqual:_scanpointTable])
        return scanpointArray.count;
    else if ([tableView isEqual:_correspondingPairTable])
        return correspondingPointArray.count;
    else if ([tableView isEqual:_authorTableView])
        return authorArray.count;
    else if ([tableView isEqual:_germsTableView])
        return germsArray.count;
    else
        return 10;
    
}
//TableView cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    UILabel *label=(UILabel*)[cell viewWithTag:10];
    if ([tableView isEqual:_sectionTableview])
    {
        CompleteSectionModel *model=sectionArray[indexPath.row];
        label.text=model.name;
    }
    else if ([tableView isEqual:_scanpointTable])
    {
        CompleteScanpointModel *model=scanpointArray[indexPath.row];
        label.text=model.name;
    }
    else if ([tableView isEqual:_correspondingPairTable])
    {
        CompleteCorrespondingpairModel *model=correspondingPointArray[indexPath.row];
        label.text=model.name;
    }
    else if ([tableView isEqual:_authorTableView])
    {
        CompleteAuthorModel *model=authorArray[indexPath.row];
        label.text=model.name;
    }
    else if ([tableView isEqual:_germsTableView])
    {
        germsModel *model=germsArray[indexPath.row];
        label.text=model.germsName;
    }
    tableView.tableFooterView=[UIView new];
    cell.backgroundColor=[UIColor colorWithRed:0.933 green:0.933 blue:0.941 alpha:1];
    cell.separatorInset=UIEdgeInsetsZero;
    cell.layoutMargins=UIEdgeInsetsZero;
    return cell;
}
//select tableviewContent
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:_sectionTableview])
    {
        CompleteSectionModel *model=sectionArray[indexPath.row];
        _anatomicalSectionTF.text=model.name;
        selectedSection=model.code;
        _sectionTableview.hidden=YES;
    }
    else if ([tableView isEqual:_scanpointTable])
    {
        CompleteScanpointModel *model=scanpointArray[indexPath.row];
        _anatomicalScanpointTF.text=model.name;
        selectedScanpoint=model.code;
        _scanpointTable.hidden=YES;
    }
    else if ([tableView isEqual:_correspondingPairTable])
    {
        CompleteCorrespondingpairModel *model=correspondingPointArray[indexPath.row];
        _anatomicalCorrespondingPairTF.text=model.name;
        selectedCorrespondingpair=model.code;
        _correspondingPairTable.hidden=YES;
    }
    else if ([tableView isEqual:_authorTableView])
    {
        CompleteAuthorModel *model=authorArray[indexPath.row];
        _anatomicalAuthorTF.text=model.name;
        selectedAuthor=model.code;
        _authorTableView.hidden=YES;
    }
    else if ([tableView isEqual:_germsTableView])
    {
        germsModel *model=germsArray[indexPath.row];
        _anatomicalGermsTF.text=model.germsName;
        selectedGermsCode=model.germsCode;
        _germsTableView.hidden=YES;
    }
}
//cell Color
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setBackgroundColor:[UIColor colorWithRed:0.933 green:0.933 blue:0.941 alpha:1]];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
-(void)callSeedForGerms{
    //    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
    //        //For Vzone API
    //        [self callApiToGetGerms];
    //    }else {
    //        //For Material API
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault boolForKey:@"germs_FLAG"]) {
        [self callApiToGetGerms];
    }
    else{
        NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,germsUrl];
        [[SeedSyncer sharedSyncer]getResponseFor:url completionHandler:^(BOOL success, id response) {
            if (success) {
                [self processGerms:response];
            }
            else{
                [self callApiToGetGerms];
            }
        }];
    }
    // }
}
-(void)callApiToGetGerms{
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,germsUrl];
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        NSString *parameter=[NSString stringWithFormat:@"{\"request\":}}"];
        [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processGerms:responseObject];
            [[SeedSyncer sharedSyncer]saveResponse:[operation responseString] forIdentity:url];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:NO forKey:@"germs_FLAG"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSString *str=[NSString stringWithFormat:@"%@",error];
            [self showToastMessage:str];
            [self callApiToGetGerms];
        }];
    }else {
        [postman get:url withParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processGerms:responseObject];
            [[SeedSyncer sharedSyncer]saveResponse:[operation responseString] forIdentity:url];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:NO forKey:@"germs_FLAG"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            NSString *str=[NSString stringWithFormat:@"%@",error];
            [self showToastMessage:str];
        }];
    }
}
-(void)processGerms:(id)responseObject{
    NSDictionary *dict;
    
    [germsArray removeAllObjects];
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        //For Vzone API
        NSDictionary *responseDict1 = responseObject;
        dict  = responseDict1[@"aaData"];
    }else{
        //For Material API
        dict=responseObject;
    }
    for (NSDictionary *dict1 in dict[@"GenericSearchViewModels"]) {
        if ([dict1[@"Status"] intValue]==1) {
            germsModel *model=[[germsModel alloc]init];
            model.germsCode=dict1[@"Code"];
            model.germsName=dict1[@"Name"];
            model.germsId=dict1[@"Id"];
            if (dict1[@"UserfriendlyCode"]!=[NSNull null]) {
                model.germsUserFriendlycode=dict1[@"UserfriendlyCode"];
            }else model.germsUserFriendlycode=model.germsName;
            [germsArray addObject:model];
        }
    }
    [self callSeedForSection];
}
-(void)callSeedForSection{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault boolForKey:@"section_FLAG"]) {
        [self callApiToGetSection];
    }
    else{
        NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,getAllSection];
        [[SeedSyncer sharedSyncer]getResponseFor:url completionHandler:^(BOOL success, id response) {
            if (success) {
                [self processSection:response];
            }
            else{
                [self callApiToGetSection];
            }
        }];
    }
}
-(void)callApiToGetSection{
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,getAllSection];
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        NSString *parameter=[NSString stringWithFormat:@"{\"request\":}}"];
        [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processSection:responseObject];
            [[SeedSyncer sharedSyncer]saveResponse:[operation responseString] forIdentity:url];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:NO forKey:@"section_FLAG"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self callApiToGetSection];
            NSString *str=[NSString stringWithFormat:@"%@",error];
            [self showToastMessage:str];
        }];
    }
}
-(void)processSection:(id)responseObject{
    
    NSDictionary *dict;
    
    [sectionArray removeAllObjects];
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        //For Vzone API
        NSDictionary *responseDict1 = responseObject;
        dict  = responseDict1[@"aaData"];
    }else{
        //For Material API
        dict=responseObject;
    }
    for (NSDictionary *dict1 in dict[@"GenericSearchViewModels"]) {
        if ([dict1[@"Status"] intValue]==1) {
            CompleteSectionModel *model=[[CompleteSectionModel alloc]init];
            model.code=dict1[@"Code"];
            model.name=dict1[@"Name"];
            model.idValue=dict1[@"Id"];
            [sectionArray addObject:model];
        }
    }
    [self callSeedForScanpoint];
}
-(void)callSeedForScanpoint{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault boolForKey:@"scanpoint_FLAG"]) {
        [self callApiToGetScanpoint];
    }
    else{
        NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,getAllScanpoint];
        [[SeedSyncer sharedSyncer]getResponseFor:url completionHandler:^(BOOL success, id response) {
            if (success) {
                [self processScanpoint:response];
            }
            else{
                [self callApiToGetScanpoint];
            }
        }];
    }
}
-(void)callApiToGetScanpoint{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,getAllScanpoint];
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        NSString *parameter=[NSString stringWithFormat:@"{\"request\":}}"];
        [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processScanpoint:responseObject];
            [[SeedSyncer sharedSyncer]saveResponse:[operation responseString] forIdentity:url];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:NO forKey:@"scanpoint_FLAG"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self callApiToGetScanpoint];
            NSString *str=[NSString stringWithFormat:@"%@",error];
            [self showToastMessage:str];
        }];
    }
}
-(void)processScanpoint:(id)responseObject{
    
    NSDictionary *dict;
    
    [scanpointArray removeAllObjects];
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        //For Vzone API
        NSDictionary *responseDict1 = responseObject;
        dict  = responseDict1[@"aaData"];
    }else{
        //For Material API
        dict=responseObject;
    }
    for (NSDictionary *dict1 in dict[@"GenericSearchViewModels"]) {
        if ([dict1[@"Status"] intValue]==1) {
            CompleteScanpointModel *model=[[CompleteScanpointModel alloc]init];
            model.code=dict1[@"Code"];
            model.name=dict1[@"Name"];
            model.idValue=dict1[@"Id"];
            [scanpointArray addObject:model];
        }
    }
    [self callSeedForCorrespondingPair];
}

-(void)callSeedForCorrespondingPair{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault boolForKey:@"correspondingpair_FLAG"]) {
        [self callApiToGetCorrespondingPair];
    }
    else{
        NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,getAllCorrespondingPair];
        [[SeedSyncer sharedSyncer]getResponseFor:url completionHandler:^(BOOL success, id response) {
            if (success) {
                [self processCorrespondingpair:response];
            }
            else{
                [self callApiToGetCorrespondingPair];
            }
        }];
    }
}
-(void)callApiToGetCorrespondingPair{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,getAllCorrespondingPair];
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        NSString *parameter=[NSString stringWithFormat:@"{\"request\":}}"];
        [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processCorrespondingpair:responseObject];
            [[SeedSyncer sharedSyncer]saveResponse:[operation responseString] forIdentity:url];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:NO forKey:@"correspondingpair_FLAG"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self callApiToGetCorrespondingPair];
            NSString *str=[NSString stringWithFormat:@"%@",error];
            [self showToastMessage:str];
        }];
    }
}
-(void)processCorrespondingpair:(id)responseObject{
    NSDictionary *dict;
    
    [correspondingPointArray removeAllObjects];
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        //For Vzone API
        NSDictionary *responseDict1 = responseObject;
        dict  = responseDict1[@"aaData"];
    }else{
        //For Material API
        dict=responseObject;
    }
    for (NSDictionary *dict1 in dict[@"GenericSearchViewModels"]) {
        if ([dict1[@"Status"] intValue]==1) {
            CompleteCorrespondingpairModel *model=[[CompleteCorrespondingpairModel alloc]init];
            model.code=dict1[@"Code"];
            model.name=dict1[@"Name"];
            model.idValue=dict1[@"Id"];
            [correspondingPointArray addObject:model];
        }
    }
    [self callSeedForAuthor];
    
}

-(void)callSeedForAuthor{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault boolForKey:@"author_FLAG"]) {
        [self callApiToGetAuthor];
    }
    else{
        NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,getAllAuthor];
        [[SeedSyncer sharedSyncer]getResponseFor:url completionHandler:^(BOOL success, id response) {
            if (success) {
                [self processAuthor:response];
            }
            else{
                [self callApiToGetAuthor];
            }
        }];
    }
}
-(void)callApiToGetAuthor{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,getAllAuthor];
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        NSString *parameter=[NSString stringWithFormat:@"{\"request\":}}"];
        [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processAuthor:responseObject];
            [[SeedSyncer sharedSyncer]saveResponse:[operation responseString] forIdentity:url];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:NO forKey:@"author_FLAG"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self callApiToGetAuthor];
            NSString *str=[NSString stringWithFormat:@"%@",error];
            [self showToastMessage:str];
        }];
    }
}
-(void)processAuthor:(id)responseObject{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    NSDictionary *dict;
    
    [authorArray removeAllObjects];
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        //For Vzone API
        NSDictionary *responseDict1 = responseObject;
        dict  = responseDict1[@"aaData"];
    }else{
        //For Material API
        dict=responseObject;
    }
    for (NSDictionary *dict1 in dict[@"GenericSearchViewModels"]) {
        if ([dict1[@"Status"] intValue]==1) {
            CompleteAuthorModel *model=[[CompleteAuthorModel alloc]init];
            model.code=dict1[@"Code"];
            model.name=dict1[@"Name"];
            model.idValue=dict1[@"Id"];
            [authorArray addObject:model];
        }
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self hideTheViews:textField];
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    [self hideTheViews:nil];
}
-(void)localize
{
    alertStr=[MCLocalization stringForKey:@"Alert!"];
    alertOkStr=[MCLocalization stringForKey:@"AlertOK"];
    requiredNameField=[MCLocalization stringForKey:@"Name is required"];
    requiredLocationField=[MCLocalization stringForKey:@"Location is required"];
    requiredBoth=[MCLocalization stringForKey:@"Name and Location are required"];
    requiredSection=[MCLocalization stringForKey:@"Section is required"];
    requiredScanpoint=[MCLocalization stringForKey:@"Scan Point is required"];
    requiredCorrespondingpair=[MCLocalization stringForKey:@"Corresponding Pair is required"];
    requiredAuthor=[MCLocalization stringForKey:@"Author is required"];
    requiredGerms=[MCLocalization stringForKey:@"Germs is required"];
    requiredSort=[MCLocalization stringForKey:@"Sort is required"];
    requiredDesc=[MCLocalization stringForKey:@"Description is required"];
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
    _anatomicalScanpointTF.attributedPlaceholder=[constant textFieldPlaceHolderText:[MCLocalization stringForKey:@"Select"]];
    _anatomicalCorrespondingPairTF.attributedPlaceholder=[constant textFieldPlaceHolderText:[MCLocalization stringForKey:@"Select"]];
    _anatomicalAuthorTF.attributedPlaceholder=[constant textFieldPlaceHolderText:[MCLocalization stringForKey:@"Select"]];
    _anatomicalGermsTF.attributedPlaceholder=[constant textFieldPlaceHolderText:[MCLocalization stringForKey:@"Select"]];
    _anatomicalSectionTF.attributedPlaceholder=[constant textFieldPlaceHolderText:[MCLocalization stringForKey:@"Select"]];
    _anatomicalSectionLabel.text=[MCLocalization stringForKey:@"Section"];
    _anatomicalGermsLabel.text=[MCLocalization stringForKey:@"Germs"];
    _anatomicalAuthorLabel.text=[MCLocalization stringForKey:@"Author"];
}
@end
