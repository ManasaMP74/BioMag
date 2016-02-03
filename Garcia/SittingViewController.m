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
#import "AppDelegate.h"
#import "SymptomTagModel.h"
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
    NSMutableArray  *selectedIndexArray,*allSortedDetailArray,*selectedPreviousSittingDetailArray,*allSectionNameArray;
    AddSymptom *symptomView;
    Postman *postman;
    Constant *constant;
    germsView *germsViewXib;
    DatePicker *datePicker;
    NSIndexPath *selectedCellIndex;
    int selectedCellToFilter;
    AppDelegate *appdelegate;
}
- (void)viewDidLoad {
     appdelegate=[UIApplication sharedApplication].delegate;
    constant=[[Constant alloc]init];
    allSortedDetailArray   =[[NSMutableArray alloc]init];
    selectedIndexArray=[[NSMutableArray alloc]init];
    selectedPreviousSittingDetailArray=[[NSMutableArray alloc]init];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
   self.revealViewController.delegate=self;
   [self.revealViewController setRightViewRevealWidth:180];
   [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background-Image-2.jpg"]]];
    postman=[[Postman alloc]init];
    if ([_sectionName isEqualToString:@""]) {
        allSectionNameArray=[[NSMutableArray alloc]init];
         [self callApi];
    }else{
        selectedCellToFilter=_selectedIndexPathOfSectionInSlideOut.row;
       [self compareNextBtnToBeHidden];
    }
    [_priceTf addTarget:self action:@selector(DidChangePriceTF) forControlEvents:UIControlEventEditingChanged];
    [self defaultValues];
    if (appdelegate.symptomTagArray.count>0) {
        _collectionViewWidth.constant=50;
        [_collectionView reloadData];
        [_scrollView layoutIfNeeded];
        if (_collectionView.contentSize.width<self.view.frame.size.width-100) {
            _collectionViewWidth.constant=_collectionView.contentSize.width;
        }else _collectionViewWidth.constant=self.view.frame.size.width-100;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
     [self navigationItemMethod];
       _tableview.tableFooterView=[UIView new];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)defaultValues{
    [constant SetBorderForTextField:_priceTf];
    [constant spaceAtTheBeginigOfTextField:_priceTf];
    _priceTf.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Charge"];
    _patientName.text= appdelegate.model.name;
    _ageValue.text=appdelegate.model.age;
    _mobileValue.text=appdelegate.model.mobileNo;
    _emailValue.text=appdelegate.model.emailId;
    _surgeriesValueLabel.text=appdelegate.model.surgeries;
    _transfusionValue.text=appdelegate.model.tranfusion;
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
    return allSortedDetailArray.count;
}
//tableview number of rows
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//tableview cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SittingTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.sittingTextView.layer.cornerRadius=10;
   cell.sittingTextView.layer.borderColor=[UIColor colorWithRed:0.004 green:0.216 blue:0.294 alpha:0.5].CGColor;
    cell.sittingTextView.layer.borderWidth=1;
    cell.sittingTextView.font=[UIFont fontWithName:@"OpenSansSemibold" size:14];
    cell.sittingTextView.textColor=[UIColor colorWithRed:0.04 green:0.216 blue:0.294 alpha:1];
    cell.delegate=self;
     sittingModel *model= allSortedDetailArray[indexPath.section];
    cell.scanpointLabel.text=model.scanPointName;
    cell.correspondinPairLabel.text=model.correspondingPairName;
    cell.interpretation.text=model.interpretation;
    cell.psychoemotional.text=model.psychoemotional;
    cell.serialNumber.text=model.sortNumber;
    cell.doctorName.text=model.author;
    if (indexPath.section==0) {
      cell.sittingNumber.text=@"S4";
    }
    for (NSString *str in model.germsCode) {
        cell.germLabel.text=str;
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
    if (model.issue) {
        [cell.checkBox setBackgroundImage:[UIImage imageNamed:@"issue-Button"] forState:normal];
        [cell.checkBox setTitle:@"Issues" forState:normal];
    }else{
        [cell.checkBox setBackgroundImage:[UIImage imageNamed:@"no-issue-Button"] forState:normal];
        [cell.checkBox setTitle:@"No issues" forState:normal];
    }
    if ([model.germsString isEqualToString:@""]) {
        cell.sittingTextView.text=@"";
        cell.sittingTvPlaceholder.hidden=NO;
        if (appdelegate.bioSittingDict!=nil) {
            NSDictionary *dict=appdelegate.bioSittingDict;
            NSString *str=dict[@"JSON"];
            NSError *jsonError;
            NSData *objectData = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers
                                error:&jsonError];
            NSArray *anotomicalPointArray=json[@"AnatomicalPoints"];
            if (anotomicalPointArray.count>0) {
                NSDictionary *anotomicalDict=anotomicalPointArray[0];
                if (([anotomicalDict[@"SectionCode"] isEqualToString:model.sectionCode])&([anotomicalDict[@"CorrespondingPairCode"] isEqualToString:model.correspondingPairCode])&([anotomicalDict[@"ScanPointCode"] isEqualToString:model.scanPointCode]) ) {
                    cell.sittingTextView.text=anotomicalDict[@"GermsName"];
                    model.germsString= cell.sittingTextView.text;
                    cell.sittingTvPlaceholder.hidden=YES;
                    if ([anotomicalDict[@"Issue"] integerValue]==1) {
                          model.issue= YES;
                        [cell.checkBox setBackgroundImage:[UIImage imageNamed:@"issue-Button"] forState:normal];
                        [cell.checkBox setTitle:@"Issues" forState:normal];
                    }else{
                        model.issue= NO;
                        [cell.checkBox setBackgroundImage:[UIImage imageNamed:@"no-issue-Button"] forState:normal];
                        [cell.checkBox setTitle:@"No issues" forState:normal];
                    }
                }else{
                    cell.sittingTextView.text=@"";
                    cell.sittingTvPlaceholder.hidden=NO;
                }
                if (![anotomicalDict[@"Price"] isEqualToString:@""]) {
                    _priceTf.text=anotomicalDict[@"Price"];
                }
            }
        }
    }else {
        cell.sittingTextView.text=model.germsString;
        cell.sittingTvPlaceholder.hidden=YES;
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
    else return 40;
}
//collection view no. of cell
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView==_collectionView) {
        return appdelegate.symptomTagArray.count;
    }
    else return 3;
}
//collection view cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==_collectionView) {
  SymptomTagCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    SymptomTagModel *m= appdelegate.symptomTagArray[indexPath.row];
   cell.label.text=m.tagName;
    cell.delegate=self;
       return cell;
    }
    else{
        PreviousSittingCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        if (indexPath.row==0) {
            cell.sittingNumber.text=@"S3";
            cell.infoLabel.text=@"B, B, V, H";
            cell.dateLabel.text=@"11-Jan-2015";
        }
       else if (indexPath.row==1) {
            cell.sittingNumber.text=@"S2";
            cell.infoLabel.text=@"B, V, H";
            cell.dateLabel.text=@"11-Jan-2015";
        }
        else{
            cell.sittingNumber.text=@"S1";
            cell.infoLabel.text=@"B, V";
            cell.dateLabel.text=@"11-Jan-2015";
        }
        return cell;
    }

}
//collection view cell height
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==_collectionView) {
        SymptomTagModel *m= appdelegate.symptomTagArray[indexPath.row];
    CGFloat width =  [m.tagName boundingRectWithSize:(CGSizeMake(NSIntegerMax,40)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:12]} context:nil].size.width;
    return CGSizeMake(width+30,40);
    }
    else return CGSizeMake(177,74);
}
//symptom view
- (IBAction)addSymptom:(id)sender {
    if (symptomView==nil)
    symptomView=[[AddSymptom alloc]initWithFrame:CGRectMake(150, 140,400,117)];
    symptomView.delegate=self;
    symptomView.searchModel=appdelegate.model;
    [symptomView alphaViewInitialize];
    symptomView.heightOfView=self.view.frame.size.height;
}
//add symptom
-(void)addsymptom:(NSArray *)array{
    [appdelegate.symptomTagArray removeAllObjects];
    [appdelegate.symptomTagArray addObjectsFromArray:array];
    _collectionViewWidth.constant=50;
    [_collectionView reloadData];
    [_scrollView layoutIfNeeded];
    if (_collectionView.contentSize.width<self.view.frame.size.width-100) {
        _collectionViewWidth.constant=_collectionView.contentSize.width;
    }else _collectionViewWidth.constant=self.view.frame.size.width-100;
}
//previous
- (IBAction)previous:(id)sender {
    selectedCellToFilter-=1;
    [selectedIndexArray removeAllObjects];
    [selectedPreviousSittingDetailArray removeAllObjects];
   [self compareNextBtnToBeHidden];
}
//save
- (IBAction)save:(id)sender {
         [self callApiToSaveTreatmentRequest];
}
//next
- (IBAction)next:(id)sender {
 selectedCellToFilter+=1;
[selectedIndexArray removeAllObjects];
[selectedPreviousSittingDetailArray removeAllObjects];
[self compareNextBtnToBeHidden];
}
//Compare Next and Previous
-(void)compareNextBtnToBeHidden{
    [self getTheSortDetailOfCompleteDitailArray:appdelegate.allsectionNameArray[selectedCellToFilter]];
    if (selectedCellToFilter==0) _previousBtn.hidden=YES;
    else if (selectedCellToFilter==appdelegate.allsectionNameArray.count-1) {
            _nextBtn.hidden=YES;
        }
    else{
        _previousBtn.hidden=NO;
        _nextBtn.hidden=NO;
        }
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
    [appdelegate.symptomTagArray removeObjectAtIndex:indexPath.row];
    [_collectionView reloadData];
    [_scrollView layoutIfNeeded];
    if (appdelegate.symptomTagArray.count==0) {
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
        [self.tableview scrollToRowAtIndexPath:indexPath atScrollPosition:(UITableViewScrollPositionMiddle) animated:YES];
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
    sittingModel *model=allSortedDetailArray[indexPath.row];
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
    NSString *parameter=[NSString stringWithFormat:@"{\"SectionCode\": \"\",\"ScanPointCode\": \"\",\"CorrespondingPairCode\":\"\",\"GermsCode\": \"\"}"];
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
    [allSortedDetailArray removeAllObjects];
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
            if (dict1[@"GenderCode"]!=[NSNull null]){
                model.genderCode=dict1[@"GenderCode"];
            }
            model.issue=NO;
            model.germsString=@"";
             [allSortedDetailArray addObject:model];
    }
}
        appdelegate.completeDetailToDrArray=[[NSMutableArray alloc]init];
        appdelegate.allsectionNameArray=[[NSMutableArray alloc]init];
        [appdelegate.allsectionNameArray addObjectsFromArray:allSectionNameArray];
        [appdelegate.completeDetailToDrArray addObjectsFromArray:allSortedDetailArray];
}
    [self getTheSortDetailOfCompleteDitailArray:allSectionNameArray[0]];
    selectedCellToFilter=0;
    if (selectedCellToFilter==allSectionNameArray.count-1) {
       _previousBtn.hidden=YES;
        _nextBtn.hidden=YES;
    }else{
        _previousBtn.hidden=YES;
        _nextBtn.hidden=NO;
    }
   
}
//Issue And No Issue
-(void)issueAndNoIssue:(UITableViewCell *)cell{
    SittingTableViewCell *cell1=(SittingTableViewCell*)cell;
     NSIndexPath *index=[_tableview indexPathForCell:cell1];
     sittingModel *model1=allSortedDetailArray[index.section];
    if ([cell1.checkBox.currentBackgroundImage isEqual:[UIImage imageNamed:@"issue-Button"]]) {
        model1.issue=NO;
    }else {
        model1.issue=YES;
    }
    [_tableview reloadData];
}
//germs view
-(void)getGermsView:(UITableViewCell *)cell{
    SittingTableViewCell *cell1=(SittingTableViewCell*)cell;
     selectedCellIndex=[_tableview indexPathForCell:cell1];
       if (germsViewXib==nil)
        germsViewXib=[[germsView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+70,self.view.frame.origin.y+100,self.view.frame.size.width-300,186)];
    germsViewXib.delegateForGerms=self;
    germsViewXib.heightOfSuperView=self.view.frame.size.height;
    if (![cell1.sittingTextView.text isEqualToString:@""]) {
        germsViewXib.fromParentViewGermsString=cell1.sittingTextView.text;
    }
    [germsViewXib alphaViewInitialize];
}
//delegate of germs
-(void)germsData:(NSArray *)germasData{
    sittingModel *model1=allSortedDetailArray[selectedCellIndex.section];
    if (germasData.count>0) {
    NSString *selectedGerms=@"";
    for (germsModel *model in germasData) {
   selectedGerms= [selectedGerms stringByAppendingString:[NSString stringWithFormat:@"%@",model.germsName]];
        if (![[germasData lastObject] isEqual:model]) {
          selectedGerms= [selectedGerms stringByAppendingString:@","];   
        }
    }
        model1.selectedCellIndex=selectedCellIndex;
        model1.germsString=selectedGerms;
        model1.newlyAddedGermsArray=germasData;
        model1.issue=YES;
    }else {
        model1.selectedCellIndex=nil;
        model1.germsString=@"";
        model1.issue=NO;
    }
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
    NSString *priceRex=@"^[+-]?(?:[0-9]{0,5}\\.[0-9]{0,1}|[0-9]{1,})$";
    NSPredicate *priceTest=[NSPredicate predicateWithFormat:@"self matches %@",priceRex];
    BOOL validate=[priceTest evaluateWithObject:_priceTf.text];
    if (!validate) {
          [self.view endEditing:YES];
    }
}
-(void)callApiToSaveTreatmentRequest{
    NSString *url=[NSString stringWithFormat:@"%@%@%@",baseUrl,closeTreatmentDetail,appdelegate.treatmentId];
    NSString *parameter;
    if (appdelegate.bioSittingDict!=nil) {
        parameter =[self getParameteToSaveSittingDetail:[appdelegate.bioSittingDict[@"Id"] integerValue] withSittingNum:[appdelegate.bioSittingDict[@"SittingNumber"] integerValue]];
    }else{
   parameter =[self getParameteToSaveSittingDetail:0 withSittingNum:0];
    }
       [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([appdelegate.treatmentId integerValue]==0) {
        [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self processResponseObjectOfSaveTreatment:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }else{
    [postman put:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self processResponseObjectOfSaveTreatment:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    }
}
-(NSString*)getParameteToSaveSittingDetail:(NSInteger)biomagneticId withSittingNum:(NSInteger)sittingNum{
    NSString *str=appdelegate.sittingString;
    NSError *jsonError;
    NSData *objectData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers
                                                           error:&jsonError];
    NSMutableDictionary *finalDict=[json mutableCopy];
    if ([appdelegate.treatmentId integerValue]==0) {
        finalDict[@"MethodType"]=@"POST";
    }
    else finalDict[@"MethodType"]=@"PUT";
    NSMutableDictionary *treatmentDict=[finalDict[@"TreatmentRequest"]mutableCopy];
    NSString *symptomStr=@"";
    for (SymptomTagModel *m in appdelegate.symptomTagArray) {
        symptomStr=[symptomStr stringByAppendingString:m.tagCode];
        symptomStr=[symptomStr stringByAppendingString:@","];
    }
    treatmentDict[@"SymptomTagCodes"]=symptomStr;
    treatmentDict[@"IsTreatmentCompleted"]=@"false";
    treatmentDict[@"Status"]=@"true";
    finalDict[@"TreatmentRequest"]=treatmentDict;
    NSMutableArray *sittingResultArray=[[NSMutableArray alloc]init];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    dict[@"BiomagneticSittingId"]= [@(biomagneticId) description];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd-MMM-yyyy"];
    NSString *visitDate=[formatter stringFromDate:[NSDate date]];
    dict[@"Visit"]=visitDate;
    if (sittingNum==0) {
        dict[@"SittingNumber"] = @([appdelegate.sittingNumber intValue]+1);
    }else dict[@"SittingNumber"] = @(sittingNum);
    dict[@"Interval"] = @(15);
    dict[@"IsCompleted"]=@"false";
    NSMutableDictionary *sittingDict=[[NSMutableDictionary alloc]init];
    NSMutableArray *jsonSittingArray=[[NSMutableArray alloc]init];
    for (sittingModel *model in appdelegate.completeDetailToDrArray) {
        if (![model.germsString isEqualToString:@""]) {
            NSMutableDictionary *sectionDict=[[NSMutableDictionary alloc]init];
            sectionDict[@"SectionCode"]=model.sectionCode;
            sectionDict[@"ScanPointCode"]=model.scanPointCode;
            sectionDict[@"CorrespondingPairCode"]=model.correspondingPairCode;
            NSString *str=@"";
            for (germsModel *m1 in model.newlyAddedGermsArray) {
                str=[str stringByAppendingString:m1.germsCode];
                str=[str stringByAppendingString:@","];
            }
            sectionDict[@"GermsCode"]=model.correspondingPairCode;
            sectionDict[@"GenderCode"]=model.genderCode;
            sectionDict[@"Description"]=model.interpretation;
            sectionDict[@"Psychoemotional"]=model.psychoemotional;
            sectionDict[@"Author"]=model.author;
            sectionDict[@"LocationScanPoint"]=@"";
            sectionDict[@"LocationCorrespondingPair"]=@"";
            sectionDict[@"Price"]=_priceTf.text;
            sectionDict[@"GermsName"]=model.germsString;
            sectionDict[@"Issue"]=[@(model.issue) description];
            [jsonSittingArray addObject:sectionDict];
        }
    }
    sittingDict[@"Notes"]=@"";
    sittingDict[@"AnatomicalPoints"]=jsonSittingArray;
    NSData *sittingData = [NSJSONSerialization dataWithJSONObject:sittingDict options:kNilOptions error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:sittingData encoding:NSUTF8StringEncoding];
    dict[@"JSON"]=jsonString;
    [sittingResultArray addObject:dict];
    finalDict[@"SittingResultsRequest"]=sittingResultArray;
    NSData *parameterData = [NSJSONSerialization dataWithJSONObject:finalDict options:kNilOptions error:nil];
    NSString *parameter = [[NSString alloc] initWithData:parameterData encoding:NSUTF8StringEncoding];
    return parameter;
}
-(void)processResponseObjectOfSaveTreatment:(id)responseObject{
        NSDictionary *dict=responseObject;
        if ([dict[@"Success"] intValue]==1) {
            [self.delegateForIncreasingSitting loadTreatMentFromSittingPart];
            [self.navigationController popViewControllerAnimated:YES];
}
}
-(void)getTheSortDetailOfCompleteDitailArray:(NSString*)str{
        [allSortedDetailArray removeAllObjects];
        NSArray *ar=[str componentsSeparatedByString:@"$"];
        _sectionName=ar[1];
        _filterLabel.text=ar[0];
        for (sittingModel *model in appdelegate.completeDetailToDrArray) {
            if ([model.sectionCode isEqualToString:_sectionName]) {
                [allSortedDetailArray addObject:model];
            }
        }
        [_tableview reloadData];
}
@end
