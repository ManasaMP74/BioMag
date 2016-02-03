#import "SittingViewController.h"
#import "SittingTableViewCell.h"
#import "sittingModel.h"
#import "AddSymptom.h"
#import "SymptomTagCollectionViewCell.h"
#import "SWRevealViewController.h"
#import "Constant.h"
#import "Postman.h"
#import "PostmanConstant.h"
#import "MBProgressHUD.h"
#import "SectionModel.h"
#import "ScanPointModel.h"
#import "CorrespondingModelClass.h"
#import "germsModel.h"
#import "AppDelegate.h"
#import "germsView.h"
#import "SlideOutTableViewController.h"
#import "DatePicker.h"
#import "germsModel.h"
#import "PreviousSittingCollectionViewCell.h"
@interface SittingViewController ()<UITableViewDelegate,UITableViewDataSource,addsymptom,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,ExpandCellProtocol,SWRevealViewControllerDelegate,deleteCellValue,SWRevealViewControllerDelegate,datePickerProtocol,sendGermsData>
@property (strong, nonatomic) IBOutlet UILabel *ageValue;
@property (strong, nonatomic) IBOutlet UILabel *filterLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *firstView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrolviewWidth;
@property (strong, nonatomic) IBOutlet UILabel *patientName;
@property (strong, nonatomic) IBOutlet UIImageView *patientimage;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewWidth;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableviewHeight;
@end

@implementation SittingViewController
{
    NSMutableArray *symptomTagArray, *selectedIndexArray,*allSectionsDetail,*allGerms,*completeDetailToDrArray,*selectedPreviousSittingDetailArray,*allSectionNameArray,*selectedGermsArray,*selectedGermsIndexArray;
    AddSymptom *symptomView;
    Postman *postman;
    Constant *constant;
    germsView *germsViewXib;
    DatePicker *datePicker;
    NSIndexPath *selectedGermsIndexPath;
}
- (void)viewDidLoad {
    constant=[[Constant alloc]init];
    symptomTagArray =[[NSMutableArray alloc]init];
    selectedIndexArray=[[NSMutableArray alloc]init];
     selectedPreviousSittingDetailArray=[[NSMutableArray alloc]init];
    selectedGermsArray=[[NSMutableArray alloc]init];
    selectedGermsIndexArray=[[NSMutableArray alloc]init];
   [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.revealViewController.delegate=self;
 [self.revealViewController setRightViewRevealWidth:180];
  [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background-Image-02.jpg"]]];
    if (symptomTagArray.count==0) {
        _collectionViewWidth.constant=0;
    }
    postman=[[Postman alloc]init];
    completeDetailToDrArray =[[NSMutableArray alloc]init];
    allSectionsDetail =[[NSMutableArray alloc]init];
    allGerms =[[NSMutableArray alloc]init];
    allSectionNameArray=[[NSMutableArray alloc]init];
    [_priceTf addTarget:self action:@selector(DidChangePriceTF) forControlEvents:UIControlEventEditingChanged];
    [self defaultValues];
     [self callApi];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
     [self navigationItemMethod];
       _tableview.tableFooterView=[UIView new];
    if (![_SortType isEqualToString:@""]) {
        _filterLabel.text=_SortType;
    }else _filterLabel.text=@"Filter";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)defaultValues{
    [constant SetBorderForTextField:_priceTf];
    [constant spaceAtTheBeginigOfTextField:_priceTf];
    _priceTf.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Enter price"];
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    _patientName.text= app.model.name;
    _ageValue.text=app.model.age;
    _mobileValue.text=app.model.mobileNo;
    _emailValue.text=app.model.emailId;
    _surgeriesValueLabel.text=app.model.surgeries;
    _transfusionValue.text=app.model.tranfusion;
    _patienViewHeight.constant=44;
    _patientDetailView.hidden=YES;
}
    //save price
- (IBAction)savePrice:(id)sender {
    if (![_priceTf.text isEqualToString:@""]) {
        [self.view endEditing:YES];
        _priceTf.enabled=NO;
    }
}
//navigation bar
-(void)navigationItemMethod{
    self.revealViewController.navigationItem.hidesBackButton=YES;
   self.revealViewController.title=@"Sitting";
    UIImage* image3 = [UIImage imageNamed:@"Icon-Signout.png"];
    CGRect frameimg = CGRectMake(0, 0, image3.size.width, image3.size.height);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(popToViewController) forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.revealViewController.navigationItem.rightBarButtonItem=mailbutton;
    UIImage* image = [UIImage imageNamed:@"Back button.png"];
    CGRect frameimg1 = CGRectMake(100, 0, image.size.width+30, image.size.height);
    UIButton *button=[[UIButton alloc]initWithFrame:frameimg1];
    [button setImage:image forState:UIControlStateNormal];
    UIBarButtonItem *barItem=[[UIBarButtonItem alloc]initWithCustomView:button];
    UIBarButtonItem *negativeSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpace.width=-25;
    self.revealViewController.navigationItem.leftBarButtonItems=@[negativeSpace,barItem];
    [button addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
}
//pop
-(void)popToViewController{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//pop
-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}
//tableview number of sections
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return completeDetailToDrArray.count;
}
//tableview number of rows
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//tableview cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SittingTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.sittingTextView.layer.cornerRadius=20;
 cell.sittingTextView.layer.borderColor=[UIColor colorWithRed:0.004 green:0.216 blue:0.294 alpha:0.5].CGColor;
    cell.sittingTextView.layer.borderWidth=1;
    cell.sittingTextView.font=[UIFont fontWithName:@"OpenSansSemibold" size:14];
    cell.sittingTextView.textColor=[UIColor colorWithRed:0.04 green:0.216 blue:0.294 alpha:1];
    cell.delegate=self;
     sittingModel *model= completeDetailToDrArray[indexPath.section];
    cell.scanpointLabel.text=model.scanPointName;
    cell.correspondinPairLabel.text=model.correspondingPairName;
    cell.interpretation.text=model.interpretation;
    cell.psychoemotional.text=model.psychoemotional;
    cell.serialNumber.text=model.sortNumber;
    cell.doctorName.text=model.author;
    if (indexPath.section==0) {
      cell.sittingNumber.text=@"S4";
    }
    CGFloat x_axis=0;
    for (NSString *str in model.germsCode) {
        UILabel *im=[[UILabel alloc]initWithFrame:CGRectMake(x_axis,10,12,12)];
        im.text=str;
        im.textColor=[UIColor colorWithRed:0.04 green:0.216 blue:0.294 alpha:1];
        im.font=[UIFont fontWithName:@"OpenSansSemibold" size:9];
        x_axis+=13;
        [cell.codeView addSubview:im];
        cell.codeView.clipsToBounds=YES;
    }
    if ([selectedIndexArray containsObject:indexPath]) {
        [self hideTheViewInTableViewCell:NO withCell:cell];
         cell.interpretation.numberOfLines=0;
        cell.scanpointLabel.numberOfLines=0;
        cell.correspondinPairLabel.numberOfLines=0;
        if (![cell.expandButton.image isEqual:[UIImage imageNamed:@"Dropdown-icon-up"]]) {
              [self changeIncreaseDecreaseImageView:cell.expandButton];
        }
        if ([selectedPreviousSittingDetailArray containsObject:indexPath]) {
            [self hideTheViewOfPreviousDetailOFSittingTableViewCell:NO withCell:cell];
            if (![cell.morePreviousButton.currentImage isEqual:[UIImage imageNamed:@"icon-up"]]) {
                [self ChangeIncreaseDecreaseButtonImage:cell.morePreviousButton];
            }
        }
        else{
        [self hideTheViewOfPreviousDetailOFSittingTableViewCell:YES withCell:cell];
            [cell.morePreviousButton setImage:[UIImage imageNamed:@"icon-down"] forState:normal];
        }
    }
    else {
     [self hideTheViewInTableViewCell:YES withCell:cell];
        cell.interpretation.numberOfLines=1;
        cell.scanpointLabel.numberOfLines=1;
        cell.correspondinPairLabel.numberOfLines=1;
    [self hideTheViewOfPreviousDetailOFSittingTableViewCell:YES withCell:cell];
    cell.expandButton.image=[UIImage imageNamed:@"Dropdown-icon"];
    [cell.morePreviousButton setImage:[UIImage imageNamed:@"Dropdown-icon"] forState:normal];
    }
    if([_sectionName isEqualToString:@""]){
    sittingModel *model1= completeDetailToDrArray[0];
        _filterLabel.text=model1.sectionName;
        _sectionName=model1.sectionCode;
        [self callApi];
    }
    if (selectedGermsArray.count>0) {
        for (int i=0; i<selectedGermsArray.count; i++) {
            NSIndexPath *ind=selectedGermsIndexArray[i];
            if (ind.section==indexPath.section) {
                cell.sittingTvPlaceholder.hidden=YES;
                cell.sittingTextView.text=selectedGermsArray[i];
            }
        }
}
    return cell;
}
//display cell
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor clearColor];
}
//height of cell
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([selectedIndexArray containsObject:indexPath]) {
        if ([selectedPreviousSittingDetailArray containsObject:indexPath]) {
            return 267;
        }
       else return 187;
    }
    else return 33;
}
//collection view no. of cell
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView==_collectionView) {
        return symptomTagArray.count;
    }
    else return 3;
}
//collection view cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==_collectionView) {
  SymptomTagCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
   cell.label.text=symptomTagArray[indexPath.row];
    cell.delegate=self;
       return cell;
    }
    else{
        PreviousSittingCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        if (indexPath.row==0) {
            cell.sittingNumber.text=@"S3";
            cell.infoLabel.text=@"B, B, V, H";
        }
       else if (indexPath.row==1) {
            cell.sittingNumber.text=@"S2";
            cell.infoLabel.text=@"B, V, H";
        }
        else{
            cell.sittingNumber.text=@"S1";
            cell.infoLabel.text=@"B, V";
        }
        return cell;
    }

}
//collection view cell height
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==_collectionView) {
    CGFloat width =  [symptomTagArray[indexPath.row] boundingRectWithSize:(CGSizeMake(NSIntegerMax, 40)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:12]} context:nil].size.width;
    return CGSizeMake(width+30,40);
    }
    else return CGSizeMake(177,74);
}
//symptom view
- (IBAction)addSymptom:(id)sender {
    if (symptomView==nil)
    symptomView=[[AddSymptom alloc]initWithFrame:CGRectMake(150, 140,400,117)];
    symptomView.delegate=self;
    [symptomView alphaViewInitialize];
    symptomView.heightOfView=self.view.frame.size.height;
}
//add symptom
-(void)addsymptom:(NSArray *)array{
    [symptomTagArray removeAllObjects];
    [symptomTagArray addObjectsFromArray:array];
    _collectionViewWidth.constant=50;
    [_collectionView reloadData];
    [_scrollView layoutIfNeeded];
    if (_collectionView.contentSize.width<self.view.frame.size.width-100) {
        _collectionViewWidth.constant=_collectionView.contentSize.width;
    }else _collectionViewWidth.constant=self.view.frame.size.width-100;
}
//previous
- (IBAction)previous:(id)sender {
}
//save
- (IBAction)save:(id)sender {
    [self.delegateForIncreasingSitting increaseSitting];
    [self.navigationController popViewControllerAnimated:YES];
}
//next
- (IBAction)next:(id)sender {
}
//slide out
- (IBAction)slideout:(id)sender {
    [self.revealViewController rightRevealToggleAnimated:YES];
    [self.revealViewController setRearViewRevealWidth:200];
    UINavigationController *nav=(UINavigationController*)self.revealViewController.rightViewController;
    SlideOutTableViewController *slideout=nav.viewControllers[0];
    slideout.allSectionNameArray=allSectionNameArray;
}
//delete tag
-(void)deleteCell:(UICollectionViewCell *)cell{
SymptomTagCollectionViewCell *cell1=(SymptomTagCollectionViewCell*)cell;
 NSIndexPath *indexPath=[_collectionView indexPathForCell:cell1];
    [symptomTagArray removeObjectAtIndex:indexPath.row];
    [_collectionView reloadData];
    [_scrollView layoutIfNeeded];
    if (symptomTagArray.count==0) {
        _collectionViewWidth.constant=0;
    }
    else if (_collectionView.contentSize.width<self.view.frame.size.width-100) {
        _collectionViewWidth.constant=_collectionView.contentSize.width;
    }else _collectionViewWidth.constant=self.view.frame.size.width-100;
}
//expand cell
-(void)expandCell:(UITableViewCell *)cell{
    SittingTableViewCell *cell1=(SittingTableViewCell*)cell;
     NSIndexPath *indexPath=[_tableview indexPathForCell:cell1];
    if ([cell1.expandButton.image isEqual:[UIImage imageNamed:@"Dropdown-icon"]]) {
        [selectedIndexArray addObject:indexPath];
        [_tableview reloadData];
    }
    else{
        [selectedIndexArray removeObject:indexPath];
        [selectedPreviousSittingDetailArray removeObject:indexPath];
          [_tableview reloadData];
    }
}
//enpand previous sitting detail
-(void)expandCellTOGetPreviousSitting:(UITableViewCell *)cell{
    SittingTableViewCell *cell1=(SittingTableViewCell*)cell;
    NSIndexPath *indexPath=[_tableview indexPathForCell:cell1];
    if ([cell1.morePreviousButton.currentImage isEqual:[UIImage imageNamed:@"icon-down"]]) {
        [selectedPreviousSittingDetailArray addObject:indexPath];
        [self ChangeIncreaseDecreaseButtonImage:cell1.morePreviousButton];
        [_tableview reloadData];
    }
    else{
        [selectedPreviousSittingDetailArray removeObject:indexPath];
        [self ChangeIncreaseDecreaseButtonImage:cell1.morePreviousButton];
        [_tableview reloadData];
   }
}
//datePicker
-(void)datePicker:(UITableViewCell*)cell withDate:(NSString *)date{
    SittingTableViewCell *cell1=(SittingTableViewCell*)cell;
    NSIndexPath *indexPath=[_tableview indexPathForCell:cell1];
    sittingModel *model=completeDetailToDrArray[indexPath.row];
    model.dateCreated=date;
    [_tableview reloadData];
}
//set button color
-(void)ChangeIncreaseDecreaseButtonImage:(UIButton*)btn{
    if ([btn.currentImage isEqual:[UIImage imageNamed:@"icon-up"]]) {
        [btn setImage:[UIImage imageNamed:@"icon-down"] forState:normal];
    }
    else  if ([btn.currentImage isEqual:[UIImage imageNamed:@"icon-down"]]) {
        [btn setImage:[UIImage imageNamed:@"icon-up"] forState:normal];
    }
}
//set ImageView
-(void)changeIncreaseDecreaseImageView:(UIImageView*)btn{
    if ([btn.image isEqual:[UIImage imageNamed:@"Dropdown-icon"]]) {
        btn.image =[UIImage imageNamed:@"Dropdown-icon-up"];
    }
    else  if ([btn.image isEqual:[UIImage imageNamed:@"Dropdown-icon-up"]]) {
        btn.image =[UIImage imageNamed:@"Dropdown-icon"];
    }
}
//hide the views
-(void)hideTheViewInTableViewCell:(BOOL)status withCell:(SittingTableViewCell*)cell{
    cell.doctorImage.hidden=status;
     cell.doctorName.hidden=status;
     cell.sittingTextView.hidden=status;
     cell.morePreviousButton.hidden=status;
     cell.sittingNumber.hidden=status;
    cell.sittingTvPlaceholder.hidden=status;
}
//Hide PreviousDetail of cell
-(void)hideTheViewOfPreviousDetailOFSittingTableViewCell:(BOOL)status withCell:(SittingTableViewCell*)cell{
    cell.previousDetailCollectionView.hidden=status;
    if (status) {
        cell.previousDetailCollectionView.delegate=self;
        cell.previousDetailCollectionView.dataSource=self;
        [cell.previousDetailCollectionView reloadData];
    }
}
//Tap on DashBoard to close SlideOutViewController
- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position{
    if (position == FrontViewPositionRight){
        UIView *topview = [[UIView alloc]initWithFrame:self.view.frame];
        [topview setTag:111];
        [self.view addSubview:topview];
        SWRevealViewController *reveleViewController = self.revealViewController;
        if (reveleViewController){
            [topview addGestureRecognizer:self.revealViewController.panGestureRecognizer];
            [topview addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
        }
    }else if (position == FrontViewPositionLeft)
    {
        UIView *lower = [self.view viewWithTag:111];
        [lower removeFromSuperview];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}
//Call api to get the biomagnetic matrix
-(void)callApi{
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,biomagneticMatrix];
    NSString *parameter=[NSString stringWithFormat:@"{\"SectionCode\": \"%@\",\"ScanPointCode\": \"\",\"CorrespondingPairCode\":\"\",\"GermsCode\": \"\"}",_sectionName];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processResponseObject:responseObject];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
//process api
-(void)processResponseObject:(id)responseObject{
    [completeDetailToDrArray removeAllObjects];
    NSDictionary *dict=responseObject;
    if ([dict[@"Success"] intValue]==1) {
    NSDateFormatter  *formater=[[NSDateFormatter alloc]init];
    for (NSDictionary *dict1 in dict[@"AnatomicalBiomagneticMatrix"]) {
        if ([dict1[@"Status"]intValue]==1) {
            sittingModel *model=[[sittingModel alloc]init];
            model.sittingId=dict1[@"Id"];
            model.code=dict1[@"Code"];
            model.germsName=[[NSMutableArray alloc]init];
            model.germsCode=[[NSMutableArray alloc]init];
            if (dict1[@"Author"]!=[NSNull null]) {
                model.author=dict1[@"Author"];
            }
            if (dict1[@"ScanPointCode"]!=[NSNull null]) {
                model.scanPointCode=dict1[@"ScanPointCode"];
            }
            if (dict1[@"Description"]!=[NSNull null]) {
                model.interpretation=dict1[@"Description"];
            }
            if (dict1[@"CorrespondingPairCode"]!=[NSNull null]){
            model.correspondingPairCode=dict1[@"CorrespondingPairCode"];
            }
            if (dict1[@"GermsCode"]!=[NSNull null]){
                [model.germsCode addObject:dict1[@"GermsCode"]];
            }
            if (dict1[@"Psychoemotional"]!=[NSNull null]){
                model.psychoemotional=dict1[@"Psychoemotional"];
            }
            if (dict1[@"Author"]!=[NSNull null]){
                model.author=dict1[@"Author"];
            }
            if (dict1[@"SectionCode"]!=[NSNull null]){
                model.sectionCode=dict1[@"SectionCode"];
            }
            if (dict1[@"SortingRank"]!=[NSNull null]){
                model.sortNumber=[NSString stringWithFormat:@"%@",dict1[@"SortingRank"]];
            }
            if (dict1[@"Section"]!=[NSNull null]){
                model.sectionName=dict1[@"Section"];
                NSString *str=[NSString stringWithFormat:@"%@$%@",model.sectionName,model.sectionCode];
                if (![allSectionNameArray containsObject:str]) {
                    [allSectionNameArray addObject:str];
                }
            }
            if (dict1[@"ScanPoint"]!=[NSNull null]){
                model.scanPointName=dict1[@"ScanPoint"];
            }
            if (dict1[@"CorrespondingPair"]!=[NSNull null]){
                model.correspondingPairName=dict1[@"CorrespondingPair"];
            }
            if (dict1[@"Germs"]!=[NSNull null]){
                [model.germsName addObject:dict1[@"Germs"]];
            }
            if (dict1[@"DateCreated"]!=[NSNull null]){
                NSArray *dateArray=[dict1[@"DateCreated"] componentsSeparatedByString:@"T"];
                [formater setTimeZone:[NSTimeZone localTimeZone]];
                [formater setDateFormat:@"yyyy-MM-dd"];
                NSDate *date=[formater dateFromString:dateArray[0]];
                [formater setDateFormat:@"dd-MMM-yyyy"];
                model.dateCreated=[formater stringFromDate:date];
            }
             [completeDetailToDrArray addObject:model];
    }
}
      [_tableview reloadData];
    }
}
//germs view
-(void)getGermsView:(UITableViewCell *)cell{
    SittingTableViewCell *cell1=(SittingTableViewCell*)cell;
    NSIndexPath *indexPath=[_tableview indexPathForCell:cell1];
    if (selectedGermsIndexArray.count>0) {
        for (int i=0; i<selectedGermsIndexArray.count;i++) {
            if ([selectedGermsIndexArray[i] isEqual:indexPath]) {
                [selectedGermsIndexArray removeObject:indexPath];
                [selectedGermsIndexArray addObject:indexPath];
                [selectedGermsArray removeObjectAtIndex:i];
            }
        }
    }
    if (![selectedGermsIndexArray containsObject:indexPath]) {
     [selectedGermsIndexArray addObject:indexPath];
    }
    if (germsViewXib==nil)
        germsViewXib=[[germsView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+70,self.view.frame.origin.y+100,self.view.frame.size.width-300,186)];
    germsViewXib.delegateForGerms=self;
    germsViewXib.heightOfSuperView=self.view.frame.size.height;
    [germsViewXib alphaViewInitialize];
}
//delegate of germs
-(void)germsData:(NSArray *)germasData{
    NSString *selectedGerms=@"";
    for (germsModel *model in germasData) {
   selectedGerms= [selectedGerms stringByAppendingString:[NSString stringWithFormat:@"%@ - %@",model.germsCode,model.germsName]];
   selectedGerms= [selectedGerms stringByAppendingString:@","];
    }
    [selectedGermsArray addObject:selectedGerms];
    [_tableview reloadData];
}
//gesture
- (IBAction)gestureRecognizer:(id)sender {
    [self.view endEditing:YES];
}
//expand patientview
- (IBAction)expandPatientView:(id)sender {
    if ([_expandPatientViewImageView.image isEqual:[UIImage imageNamed:@"Dropdown-icon"]]) {
        _expandPatientViewImageView.image=[UIImage imageNamed:@"Dropdown-icon-up"];
        CGFloat height=(self.view.frame.size.height-498)/2;
        CGFloat emailHeight=[_emailValue.text boundingRectWithSize:(CGSize){height,CGFLOAT_MAX }options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:13]} context:nil].size.height;
        CGFloat surgeriesHeight=[_surgeriesValueLabel.text boundingRectWithSize:(CGSize){height,CGFLOAT_MAX }options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:13]} context:nil].size.height;
        CGFloat finalheight=MAX(surgeriesHeight, emailHeight);
        if (finalheight>33) {
           _patienViewHeight.constant=finalheight+98;
            _emailValueHeight.constant=emailHeight;
            _surgeriesValueHeight.constant=surgeriesHeight;
        }else{
            _patienViewHeight.constant=115+finalheight;
            _emailValueHeight.constant=33+finalheight;
            _surgeriesValueHeight.constant=33+finalheight;
        }
        _patientDetailView.hidden=NO;
 
    }else{
      _expandPatientViewImageView.image=[UIImage imageNamed:@"Dropdown-icon"];
        _patienViewHeight.constant=44;
        _patientDetailView.hidden=YES;
   }
    
}
//Visited Date
- (IBAction)visitedDate:(id)sender {
    if(datePicker==nil)
        datePicker= [[DatePicker alloc]initWithFrame:CGRectMake(100,230,400,230)];
    datePicker.datePicker.minimumDate=[NSDate date];
    [datePicker alphaViewInitialize];
    datePicker.delegate=self;
}
//datepicker Delegate
-(void)selectingDatePicker:(NSString *)date{
    [_datePicButton setTitle:date forState:normal];
}
//Price check
-(void)DidChangePriceTF{
    NSString *priceRex=@"^[+-]?(?:[0-9]{0,9}\\.[0-9]{0,1}|[0-9]{1,91})$";
    NSPredicate *priceTest=[NSPredicate predicateWithFormat:@"self matches %@",priceRex];
    BOOL validate=[priceTest evaluateWithObject:_priceTf.text];
    if (!validate) {
          [self.view endEditing:YES];
    }
}
@end
