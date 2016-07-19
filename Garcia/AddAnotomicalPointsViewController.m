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
#import "lagModel.h"
#import "SittingViewController.h"
#import "SWRevealViewController.h"
#import "AddAnatomicalPointCell.h"
#import "sittingModel.h"
#import "EditAnatomicalPoint.h"
@interface AddAnotomicalPointsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,editAnatomicalPointSucceed>
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;
@property (weak, nonatomic) IBOutlet UIControl *view1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *authorTVHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *germsTVHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *correspondingTVHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scanpointTvHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sectionTvHeight;
@property (weak, nonatomic) IBOutlet UILabel *sectionHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *scanpointHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *correspondingHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeHeaderLabel;

@end

@implementation AddAnotomicalPointsViewController
{
    Constant *constant;
    NSString *alertStr,*alertOkStr,*requiredNameField,*requiredLocationField,*requiredBoth,*requiredSection,*requiredScanpoint,*requiredCorrespondingpair,*requiredAuthor,*requiredGerms,*requiredSort,*requiredDesc;
    Postman *postman;
    NSMutableArray *scanpointArray,*correspondingPointArray,*authorArray,*germsArray,*sectionArray,*languageArray,*personalScanpointArray,*personalCorrespondingPointArray;
    NSString *selectedGermsCode,*selectedSection,*selectedScanpoint,*selectedCorrespondingpair,*selectedAuthor,*selectedLang,*selectedSegment,*TextShouldBeLessThan250;
    sittingModel *selectedPersonalPairModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    constant=[[Constant alloc]init];
    _view1.layer.cornerRadius=5;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background-Image-1.jpg"]]];
    [self textFieldLayer];
    [self navigationItemMethod];
    [self localize];
    self.tapGesture.delaysTouchesBegan = NO;
    self.tapGesture.delaysTouchesBegan = NO;
    _langButton.layer.cornerRadius=15;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [_langButton setTitle:[defaults valueForKey:@"languageName"] forState:normal];
    scanpointArray=[[NSMutableArray alloc]init];
    correspondingPointArray=[[NSMutableArray alloc]init];
    sectionArray=[[NSMutableArray alloc]init];
    germsArray=[[NSMutableArray alloc]init];
    authorArray=[[NSMutableArray alloc]init];
    languageArray=[[NSMutableArray alloc]init];
    personalScanpointArray=[[NSMutableArray alloc]init];
    personalCorrespondingPointArray=[[NSMutableArray alloc]init];
    selectedPersonalPairModel=[[sittingModel alloc]init];
      _personalPairView.hidden=NO;
    _personalScanpointView.hidden=YES;
    postman=[[Postman alloc]init];
    [self callSeedForGerms];
    [self callSeedForLanguage];
    selectedPersonalPairModel=nil;
    _personalPairTable.tableFooterView=[UIView new];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    selectedSegment=@"anatomicalPair";
    [self setDefault];
    [self.view endEditing:YES];
    [self hideTheViews:nil];
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    selectedLang=[userDefault valueForKey:@"languageCode"];
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
    _anatomicalSortNumberTF.text=@"";
}
- (IBAction)saveButtonForScanpoint:(id)sender {
    [self.view endEditing:YES];
    [self hideTheViews:nil];
    if (_scanpointLocationTF.text.length==0 & _scanpointNameTF.text.length==0) {
        [self showToastMessage:requiredBoth];
    }
    else if (_scanpointNameTF.text.length==0) {
        [self showToastMessage:requiredNameField];
    }else if (_scanpointLocationTF.text.length==0) {
        [self showToastMessage:requiredLocationField];
    }
    else
        [self callApiToSaveScanpoint:@"scanpoint"];
}
- (IBAction)saveButtonForCorrespondingPair:(id)sender {
    [self.view endEditing:YES];
    [self hideTheViews:nil];
    if (_correspondingNameTF.text.length==0 & _correspondingLocationTF.text.length==0) {
        [self showToastMessage:requiredBoth];
    }
    else if (_correspondingNameTF.text.length==0) {
        [self showToastMessage:requiredNameField];
    }else if (_correspondingLocationTF.text.length==0) {
        [self showToastMessage:requiredLocationField];
    } else [self callApiToSaveScanpoint:@"CorrespondingPair"];
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
    if (_anatomicalSortNumberTF.text.length==0) {
        [alertArray addObject:[NSString stringWithFormat:@"%@\n",requiredSort]];
    }
    if (_descriptionTV.text.length==0) {
        [alertArray addObject:[NSString stringWithFormat:@"%@\n",requiredDesc]];
    }
    
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
- (IBAction)getLanguage:(id)sender {
    [self hideTheViews:nil];
    _langTable.hidden=NO;
    [_langTable reloadData];
    [self.view layoutIfNeeded];
    CGFloat finalWidth =0.0;
    if (languageArray.count>0) {
        for (lagModel *str in languageArray) {
            CGFloat width =  [str.name boundingRectWithSize:(CGSizeMake(NSIntegerMax,self.view.frame.size.width)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:15]} context:nil].size.width;
            finalWidth=MAX(finalWidth, width);
        }
    }
    _langTableWidth.constant=finalWidth+35;
    _langTableHeight.constant=_langTable.contentSize.height;
    
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
            parameter =[NSString stringWithFormat:@"{\"request\":{\"Id\":\"0\",\"SectionCode\":\"%@\",\"ScanPointCode\":\"%@\",\"CorrespondingPairCode\":\"%@\",\"IsPublished\":false,\"GermsCode\":\"%@\",\"Status\":true,\"GenderCode\":\"\",\"Author\":\"%@\",\"ApplicableVersionCode\":\"%@\",\"AppTypeCode\":\"%@\",\"Psychoemotional\":\"\",\"Description\":\"%@\",\"CompanyCode\":\"%@\",\"UserID\":%d,\"MethodType\":\"POST\",\"LanguageCode\":\"%@\"}}",selectedSection,selectedScanpoint,selectedCorrespondingpair,selectedGermsCode,selectedAuthor,applicableBasicVersionCode,appTypeCode,_descriptionTV.text, postmanCompanyCode, userIdInteger,selectedLang];
        }else{
            //Parameter For Material Api
            parameter =[NSString stringWithFormat:@"{\"request\":{\"Id\":\"0\",\"SectionCode\":\"%@\",\"ScanPointCode\":\"%@\",\"CorrespondingPairCode\":\"%@\",\"IsPublished\":false,\"GermsCode\":\"%@\",\"Status\":true,\"GenderCode\":\"\",\"Author\":\"%@\",\"ApplicableVersionCode\":\"%@\",\"AppTypeCode\":\"%@\",\"Psychoemotional\":\"\",\"Description\":\"%@\",\"CompanyCode\":\"%@\",\"UserID\":%d,\"MethodType\":\"POST\",\"LanguageCode\":\"%@\"}}",selectedSection,selectedScanpoint,selectedCorrespondingpair,selectedGermsCode,selectedAuthor,applicableBasicVersionCode,appTypeCode,_descriptionTV.text, postmanCompanyCode, userIdInteger,selectedLang];
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
            if ([differForSaveData isEqualToString:@"scanpoint"]){
             [self showToastMessage:dict[@"Message"]];
                [self callApiToGetScanpoint:NO];
            }else if ([differForSaveData isEqualToString:@"CorrespondingPair"]){
                 [self showToastMessage:dict[@"Message"]];
                [self callApiToGetCorrespondingPair:NO];
            }
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
            NSString *str=dict[@"Message"];
            if (str.length==0) {
                [self showToastMessage:[MCLocalization stringForKey:@"Save Failed"]];
            }
        }
    }
}
-(void)alertView:(NSString*)message{
    UIAlertController *alertView=[UIAlertController alertControllerWithTitle:alertStr message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *success=[UIAlertAction actionWithTitle:alertOkStr style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
        [alertView dismissViewControllerAnimated:YES completion:nil];
        [self popView];
        [self.delegate successFullAddingAnatomicalPoints];
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
        hubHUD.detailsLabelText=msg;
    }
    hubHUD.detailsLabelFont=[UIFont systemFontOfSize:15];
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
     [constant spaceAtTheBeginigOfTextField:_personalScanpointSortTF];
     [constant spaceAtTheBeginigOfTextField:_personalCorrespondingSortTF];
    [constant SetBorderForTextField:_scanpointNameTF];
    [constant SetBorderForTextField:_anatomicalSortNumberTF];
    [constant SetBorderForTextField:_anatomicalCorrespondingPairTF];
    [constant SetBorderForTextField:_anatomicalScanpointTF];
    [constant SetBorderForTextField:_correspondingLocationTF];
    [constant SetBorderForTextview:_descriptionTV];
    [constant SetBorderForTextField:_correspondingNameTF];
    [constant SetBorderForTextField:_scanpointLocationTF];
    [constant SetBorderForTextField:_personalScanpointSortTF];
    [constant SetBorderForTextField:_personalCorrespondingSortTF];
    [constant setFontFortextField:_scanpointNameTF];
    [constant setFontFortextField:_scanpointNameTF];
    [constant setFontFortextField:_scanpointLocationTF];
    [constant setFontFortextField:_correspondingNameTF];
    [constant setFontFortextField:_correspondingLocationTF];
    [constant setFontFortextField:_anatomicalScanpointTF];
    [constant setFontFortextField:_anatomicalCorrespondingPairTF];
    [constant setFontFortextField:_anatomicalSortNumberTF];
    [constant setFontFortextField:_personalScanpointSortTF];
    [constant setFontFortextField:_personalCorrespondingSortTF];
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
    [constant changeCancelBtnImage:_cancelBtn];
    [constant changeSaveBtnImage:_saveBtn];
    [constant changeCancelBtnImage:_langButton];
    
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
    NSArray *ar=self.navigationController.viewControllers;
    SWRevealViewController *sw;
    if (ar.count==4)  {
        sw=(SWRevealViewController*)self.navigationController.viewControllers[2];
    }else{
        sw=(SWRevealViewController*)self.navigationController.viewControllers[3];
    }
    SittingViewController *sitting=(SittingViewController*)sw.frontViewController;
    sitting.sittingViewId=@"addAnatomical";
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
    _langTable.hidden=YES;
}
- (IBAction)gestureRecognizer:(id)sender {
    [self.view endEditing:YES];
    [self hideTheViews:nil];
}
- (IBAction)touchEvent:(id)sender {
    [self.view endEditing:YES];
    [self hideTheViews:nil];
}
- (IBAction)selectScanpoint:(id)sender {
    [self.view endEditing:YES];
    [self hideTheViews:_anatomicalScanpointTF];
    [_scanpointTable reloadData];
    //    [self.view layoutIfNeeded];
    //    _scanpointTvHeight.constant=_scanpointTable.contentSize.height;
}
- (IBAction)selectCorrespondingPair:(id)sender {
    [self.view endEditing:YES];
    [self hideTheViews:_anatomicalCorrespondingPairTF];
    [_correspondingPairTable reloadData];
    //    [self.view layoutIfNeeded];
    //    _correspondingTVHeight.constant=_correspondingPairTable.contentSize.height;
}
- (IBAction)selectSection:(id)sender {
    [self.view endEditing:YES];
    [self hideTheViews:_anatomicalSectionTF];
    [_sectionTableview reloadData];
    //    [self.view layoutIfNeeded];
    //    _sectionTvHeight.constant=_sectionTableview.contentSize.height;
}
- (IBAction)selectGerms:(id)sender {
    [self.view endEditing:YES];
    [self hideTheViews:_anatomicalGermsTF];
    [_germsTableView reloadData];
    //    [self.view layoutIfNeeded];
    //    _germsTVHeight.constant=_germsTableView.contentSize.height;
}
- (IBAction)selectAuthor:(id)sender {
    [self.view endEditing:YES];
    [self hideTheViews:_anatomicalAuthorTF];
    [_authorTableView reloadData];
    //    [self.view layoutIfNeeded];
    //    _authorTVHeight.constant=_authorTableView.contentSize.height;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isEqual:_anatomicalAuthorTF]) {
        [self hideTheViews:_anatomicalAuthorTF];
        [_authorTableView reloadData];
        return NO;
    }
    return YES;
}
- (IBAction)personPairDetail:(id)sender {
    switch ([sender selectedSegmentIndex]) {
        case 0:
            selectedSegment=@"anatomicalPair";
            [self ShowPersonalPairView];
            break;
        case 1:
            selectedSegment=@"scanpoint";
            _personalScanpointNameLabel.text= [MCLocalization stringForKey:@"Scan Point"];
            [self ShowPersonalPairView];
            break;
        case 2:
            selectedSegment=@"correspondingpair";
             _personalScanpointNameLabel.text=[MCLocalization stringForKey:@"Corresponding Pair"];
            [self ShowPersonalPairView];
            break;
        default:
            break;
    }

}
-(void)ShowPersonalPairView{
 if ([selectedSegment isEqualToString:@"anatomicalPair"]) {
     _personalPairView.hidden=NO;
     _personalPairTable.hidden=NO;
     _personalScanPointOrCorrespondingPair.hidden=YES;
     _personalScanpointView.hidden=YES;
     _personalPairTableHeight.constant=10;
     _personalScanpointTableViewHeight.constant=0;
     [_personalPairTable reloadData];
      [self.view layoutIfNeeded];
     _personalPairTableHeight.constant=_personalPairTable.contentSize.height;
 }else{
     _personalPairView.hidden=YES;
     _personalPairTable.hidden=YES;
      _personalScanpointView.hidden=NO;
     _personalScanPointOrCorrespondingPair.hidden=NO;
     _personalPairTableHeight.constant=0;
     _personalScanpointTableViewHeight.constant=10;
    [_personalScanPointOrCorrespondingPair reloadData];
     [self.view layoutIfNeeded];
     _personalScanpointTableViewHeight.constant=_personalScanPointOrCorrespondingPair.contentSize.height;
 }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
//TableView Number of row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int countValue=0;
    if ([tableView isEqual:_sectionTableview])
    {
        return sectionArray.count;
    }
    else if ([tableView isEqual:_scanpointTable])
        countValue=(int) scanpointArray.count;
    else if ([tableView isEqual:_correspondingPairTable])
        countValue= (int)correspondingPointArray.count;
    else if ([tableView isEqual:_authorTableView])
        countValue=(int) authorArray.count;
    else if ([tableView isEqual:_germsTableView])
        countValue= (int)germsArray.count;
    else if ([tableView isEqual:_langTable])
        countValue= (int)languageArray.count;
    else if ([tableView isEqual:_personalPairTable])
        countValue= (int)_personalPairArray.count;
    else if ([tableView isEqual:_personalScanPointOrCorrespondingPair])
    {
        if ([selectedSegment isEqualToString:@"scanpoint"]) {
            countValue=(int)personalScanpointArray.count;
        }
        else  countValue=(int)personalCorrespondingPointArray.count;
    }
    else  countValue= 10;
        
        return countValue;
    
}
//TableView cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_personalPairTable] | [tableView isEqual:_personalScanPointOrCorrespondingPair]) {
        AddAnatomicalPointCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if ([tableView isEqual:_personalPairTable]){
        if ([selectedSegment isEqualToString:@"anatomicalPair"]) {
            sittingModel *model=_personalPairArray[indexPath.row];
            cell.sectionLabel.text=model.sectionName;
            cell.scanpointLabel.text=model.scanPointName;
            cell.correspondingpairLabel.text=model.correspondingPairName;
            cell.code.text=model.germsName;
            _personalPairTableHeight.constant=_personalPairTable.contentSize.height;
        }
        }
    else if ([tableView isEqual:_personalScanPointOrCorrespondingPair])
        {
            if ([selectedSegment isEqualToString:@"scanpoint"]) {
                CompleteScanpointModel *m=personalScanpointArray[indexPath.row];
                cell.personalScanpointOrCorrespondingPairLabel.text=m.name;
                NSLog(@"%@",m.location);
                if (m.location==nil) {
                    cell.personalScanpointOrCorrespondingPairLocLabel.text=@"";
                }
               else cell.personalScanpointOrCorrespondingPairLocLabel.text=m.location;
            }
            else if ([selectedSegment isEqualToString:@"correspondingpair"]){
                CompleteCorrespondingpairModel *m=personalCorrespondingPointArray[indexPath.row];
                cell.personalScanpointOrCorrespondingPairLabel.text=m.name;
                 cell.personalScanpointOrCorrespondingPairLocLabel.text=m.location;
            }
        }
        return cell;
    }
    else{
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
        else if ([tableView isEqual:_langTable])
        {
            lagModel *model=languageArray[indexPath.row];
            label.text=model.name;
        }
        tableView.tableFooterView=[UIView new];
        cell.backgroundColor=[UIColor colorWithRed:0.933 green:0.933 blue:0.941 alpha:1];
        cell.separatorInset=UIEdgeInsetsZero;
        cell.layoutMargins=UIEdgeInsetsZero;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:_personalPairTable]| [tableView isEqual:_personalScanPointOrCorrespondingPair]) {
        if (indexPath.row%2==0) {
            cell.backgroundColor=[UIColor colorWithRed:0.38 green:0.82 blue:0.961 alpha:1];
        }else{
            cell.backgroundColor=[UIColor colorWithRed:0.667 green:0.902 blue:0.976 alpha:1];
        }
    }
    else [cell setBackgroundColor:[UIColor colorWithRed:0.933 green:0.933 blue:0.941 alpha:1]];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:_personalPairTable]| [tableView isEqual:_personalScanPointOrCorrespondingPair]) {
        return 41;
    }else return 30;
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
        [self.view endEditing:YES];
    }
    else if ([tableView isEqual:_germsTableView])
    {
        germsModel *model=germsArray[indexPath.row];
        _anatomicalGermsTF.text=model.germsName;
        selectedGermsCode=model.germsCode;
        _germsTableView.hidden=YES;
    }
    else if ([tableView isEqual:_langTable])
    {
        lagModel *model=languageArray[indexPath.row];
        [_langButton setTitle:model.name forState:normal];
        selectedLang=model.code;
        _langTable.hidden=YES;
    }
    else if ([tableView isEqual:_personalPairTable]) {
        selectedPersonalPairModel=_personalPairArray[indexPath.row];
        EditAnatomicalPoint *edit=[self.storyboard instantiateViewControllerWithIdentifier:@"EditAnatomicalPoint"];
        edit.delegate=self;
        edit.selectedPersonalAnatomicalPair=selectedPersonalPairModel;
        [self.navigationController pushViewController:edit animated:YES];
    }
}
-(void)successOfEditAnatomicalPoint{
    [self.delegate successFullAddingAnatomicalPoints];
    // [self callApiToGetEditedAnatomicalPointDetail];
}
-(void)callApiToGetEditedAnatomicalPointDetail{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url=[NSString stringWithFormat:@"%@%@/%@",baseUrl,addAnatomicalPoints,selectedPersonalPairModel.sittingId];
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        [postman get:url withParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processToGetEditedAnatomicalPointDetail:responseObject];
            [MBProgressHUD hideHUDForView:self.view animated:NO];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            NSString *str=[NSString stringWithFormat:@"%@",error];
            [self showToastMessage:str];
        }];
    }
}
-(void)processToGetEditedAnatomicalPointDetail:(id)responseObject{
    NSDictionary *dict;
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        //For Vzone API
        NSDictionary *responseDict1 = responseObject;
        dict  = responseDict1[@"aaData"];
    }else{
        //For Material API
        dict=responseObject;
    }
    NSMutableArray *array=[[NSMutableArray alloc]initWithArray:_personalPairArray];
    if (array.count>0) {
        for ( sittingModel *m in array) {
            if ([m.sittingId isEqualToString:selectedPersonalPairModel.sittingId]) {
                if (dict[@"SectionCode"]!=[NSNull null]){
                m.sectionCode=dict[@"SectionCode"];
                }
                if (dict[@"ScanPointCode"]!=[NSNull null]){
                m.scanPointCode=dict[@"ScanPointCode"];
                }
                 if (dict[@"CorrespondingPairCode"]!=[NSNull null]){
                m.correspondingPairCode=dict[@"CorrespondingPairCode"];
                 }
                 if (dict[@"Section"]!=[NSNull null]){
                m.sectionName=dict[@"Section"];
                 }
                 if (dict[@"ScanPoint"]!=[NSNull null]){
                m.scanPointName=dict[@"ScanPoint"];
                 }
                 if (dict[@"CorrespondingPair"]!=[NSNull null]){
                m.correspondingPairName=dict[@"CorrespondingPair"];
                 }
                 if (dict[@"SortingRank"]!=[NSNull null]){
                m.sortNumber=dict[@"SortingRank"];
                 }
                 if (dict[@"Author"]!=[NSNull null]){
                m.author=dict[@"Author"];
                 }
                 if (dict[@"GermsCode"]!=[NSNull null]){
                m.germsCode=dict[@"GermsCode"];
                 }
                 if (dict[@"Description"]!=[NSNull null]){
                m.interpretation=dict[@"Description"];
                 }
                break;
            }
        }
    }
    [_personalPairTable reloadData];
    [self.view layoutIfNeeded];
    _personalPairTableHeight.constant=_personalPairTable.contentSize.height;
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
        [self callApiToGetScanpoint:YES];
    }
    else{
        NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,getAllScanpoint];
        [[SeedSyncer sharedSyncer]getResponseFor:url completionHandler:^(BOOL success, id response) {
            if (success) {
                [self processScanpoint:response with:YES];
            }
            else{
                [self callApiToGetScanpoint:YES];
            }
        }];
    }
}
-(void)callApiToGetScanpoint:(BOOL)status{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,getAllScanpoint];
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        NSString *parameter=[NSString stringWithFormat:@"{\"request\":}}"];
        [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processScanpoint:responseObject with:status];
            [[SeedSyncer sharedSyncer]saveResponse:[operation responseString] forIdentity:url];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:NO forKey:@"scanpoint_FLAG"];
            if (!status) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self callApiToGetScanpoint:status];
            NSString *str=[NSString stringWithFormat:@"%@",error];
            [self showToastMessage:str];
        }];
    }
}
-(void)processScanpoint:(id)responseObject with:(BOOL)status{
    
    NSDictionary *dict;
     [personalScanpointArray removeAllObjects];
    [scanpointArray removeAllObjects];
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        //For Vzone API
        NSDictionary *responseDict1 = responseObject;
        dict  = responseDict1[@"aaData"];
    }else{
        //For Material API
        dict=responseObject;
    }
    NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
    NSString *docId=[userdefault valueForKey:@"Id"];
    for (NSDictionary *dict1 in dict[@"GenericSearchViewModels"]) {
        if ([dict1[@"Status"] intValue]==1) {
            CompleteScanpointModel *model=[[CompleteScanpointModel alloc]init];
            model.code=dict1[@"Code"];
            model.name=NULL_CHECK(dict1[@"Name"]);
            model.idValue=dict1[@"Id"];
            model.location=NULL_CHECK(dict1[@"LocationScanPoint"]);
            [scanpointArray addObject:model];
            if ([docId intValue]==[dict1[@"CreatedBy"] intValue]) {
                [personalScanpointArray addObject:model];
            }
        }
    }
    if (status) {
        [self callSeedForCorrespondingPair];
    }else   [_scanpointTable reloadData];
}

-(void)callSeedForCorrespondingPair{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault boolForKey:@"correspondingpair_FLAG"]) {
        [self callApiToGetCorrespondingPair:YES];
    }
    else{
        NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,getAllCorrespondingPair];
        [[SeedSyncer sharedSyncer]getResponseFor:url completionHandler:^(BOOL success, id response) {
            if (success) {
                [self processCorrespondingpair:response with:YES];
            }
            else{
                [self callApiToGetCorrespondingPair:YES];
            }
        }];
    }
}
-(void)callApiToGetCorrespondingPair:(BOOL)status{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,getAllCorrespondingPair];
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        NSString *parameter=[NSString stringWithFormat:@"{\"request\":}}"];
        [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processCorrespondingpair:responseObject with:status];
            [[SeedSyncer sharedSyncer]saveResponse:[operation responseString] forIdentity:url];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:NO forKey:@"correspondingpair_FLAG"];
            if (!status) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self callApiToGetCorrespondingPair:status];
            NSString *str=[NSString stringWithFormat:@"%@",error];
            [self showToastMessage:str];
        }];
    }
}
-(void)processCorrespondingpair:(id)responseObject with:(BOOL)status{
    NSDictionary *dict;
    
    [correspondingPointArray removeAllObjects];
    [personalCorrespondingPointArray removeAllObjects];
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        //For Vzone API
        NSDictionary *responseDict1 = responseObject;
        dict  = responseDict1[@"aaData"];
    }else{
        //For Material API
        dict=responseObject;
    }
    NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
    NSString *docId=[userdefault valueForKey:@"Id"];
    for (NSDictionary *dict1 in dict[@"GenericSearchViewModels"]) {
        if ([dict1[@"Status"] intValue]==1) {
            CompleteCorrespondingpairModel *model=[[CompleteCorrespondingpairModel alloc]init];
            model.code=dict1[@"Code"];
            model.name=NULL_CHECK(dict1[@"Name"]);
            model.idValue=dict1[@"Id"];
            model.location=NULL_CHECK(dict1[@"LocationCorrespondingPair"]);
            [correspondingPointArray addObject:model];
            if ([docId intValue]==[dict1[@"CreatedBy"] intValue]) {
                [personalCorrespondingPointArray addObject:model];
            }
        }
    }
    if (status) {
        [self callSeedForAuthor];
    }else   [_correspondingPairTable reloadData];
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
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL status=YES;
    if ([textField isEqual:_anatomicalSortNumberTF]|[textField isEqual:_personalScanpointSortTF]|[textField isEqual:_personalCorrespondingSortTF]) {
        NSCharacterSet * numberCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        for (int i = 0; i < [string length]; ++i)
        {
            unichar c = [string characterAtIndex:i];
            if (![numberCharSet characterIsMember:c])
            {
                status= NO;
            }
        }
    }
    if ([textField isEqual:_scanpointNameTF]|[textField isEqual:_scanpointLocationTF]|[textField isEqual:_correspondingNameTF]|[textField isEqual:_correspondingLocationTF]) {
        if (textField.text.length+string.length>250) {
            status=NO;
            UIAlertController *alertView=[UIAlertController alertControllerWithTitle:alertStr message:TextShouldBeLessThan250 preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel=[UIAlertAction actionWithTitle:alertOkStr style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
                [alertView dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertView addAction:cancel];
            [self presentViewController:alertView animated:YES completion:nil];
        }
    }
    return status;
}
-(void)callSeedForLanguage{
    //    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
    //        //Api For Vzone
    //        [self callApiForLanguage];
    //    }else{
    //  API for material
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault boolForKey:@"language_FLAG"]) {
        [self callApiForLanguage];
    }
    else{
        NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,language];
        [[SeedSyncer sharedSyncer]getResponseFor:url completionHandler:^(BOOL success, id response) {
            if (success) {
                [self processResponse:response];
            }
            else{
                [self callApiForLanguage];
            }
        }];
    }
    //  }
}

-(void)callApiForLanguage{
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,language];
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        NSString *parameter=[NSString stringWithFormat:@"{\"request\":}}"];
        [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processResponse:responseObject];
            [[SeedSyncer sharedSyncer]saveResponse:[operation responseString] forIdentity:url];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:NO forKey:@"language_FLAG"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }else{
        [postman get:url withParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processResponse:responseObject];
            [[SeedSyncer sharedSyncer]saveResponse:[operation responseString] forIdentity:url];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:NO forKey:@"language_FLAG"];
            [MBProgressHUD hideHUDForView:self.view animated:NO ];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            [self showToastMessage:[NSString stringWithFormat:@"%@",error]];
        }];
    }
}
-(void)processResponse:(id)response{
    [languageArray removeAllObjects];
    NSDictionary *dict;
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        NSDictionary *dic1=response;
        dict=dic1[@"aaData"];
    }else{
        dict=response;
    }
    for (NSDictionary *dict1 in dict[@"GenericSearchViewModels"]) {
        if ([dict1[@"Status"]boolValue]) {
            lagModel *model=[[lagModel alloc]init];
            model.name=dict1[@"Name"];
            model.code=dict1[@"Code"];
            [languageArray addObject:model];
        }
    }
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
    _personalPair.text=[MCLocalization stringForKey:@"Personal Pairs"];
    _scanpointHeaderLabel.text=[MCLocalization stringForKey:@"Scan Point"];
    _correspondingHeaderLabel.text=[MCLocalization stringForKey:@"Corresponding Pair"];
    _codeHeaderLabel.text=[MCLocalization stringForKey:@"Code"];
    _sectionHeaderLabel.text=[MCLocalization stringForKey:@"Section"];
    [_segment setTitle:[MCLocalization stringForKey:@"Personal Pairs"] forSegmentAtIndex:0];
    [_segment setTitle:[MCLocalization stringForKey:@"Personal ScanPoint"] forSegmentAtIndex:1];
    [_segment setTitle:[MCLocalization stringForKey:@"Personal CorrespondingPair"] forSegmentAtIndex:2];
 _personalScanpointSortLabel.text=[MCLocalization stringForKey:@"Sort Number"];
_personalScanpointLocationLabel.text=[MCLocalization stringForKey:@"Location"];
_personalCorrespondingSortLabel.text=[MCLocalization stringForKey:@"Sort Number"];
TextShouldBeLessThan250=[MCLocalization stringForKey:@"Text should be less than 250"];
}
@end
