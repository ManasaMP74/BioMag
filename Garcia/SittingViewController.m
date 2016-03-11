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
#import "SeedSyncer.h"
#import "PreviousSittingModelClass.h"
#import "ToxicDeficiency.h"
#import <MCLocalization/MCLocalization.h>
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
@property (weak, nonatomic) IBOutlet UILabel *sittingNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderValue;
@end

@implementation SittingViewController
{
    NSMutableArray  *selectedIndexArray,*allSortedDetailArray,*selectedPreviousSittingDetailArray,*allSectionNameArray,*toxicDeficiencyArray,*allDoctorDetailArray,*allPreviousSittingDetail,*selectedSittingModelInallDoctorDetailArray;
    AddSymptom *symptomView;
    Postman *postman;
    Constant *constant;
    germsView *germsViewXib;
    DatePicker *datePicker;
    NSIndexPath *selectedCellIndex;
    int selectedCellToFilter;
    AppDelegate *appdelegate;
    NSDateFormatter *formater;
    NSString *selectedToxicString;
    NSArray *selectedPreviousArray;
    NSString *navTitle,*alert,*alertOK,*saveFailed,*saveSuccess,*yesStr,*noStr,*authour,*enterSittingInfo,*previousSittings,*issueStr,*noIssueStr,*sStr,*s1Str,*doYoucloseSitting;
}
- (void)viewDidLoad {
    [self localize];
    appdelegate=[UIApplication sharedApplication].delegate;
      formater=[[NSDateFormatter alloc]init];
     [formater setTimeZone:[NSTimeZone localTimeZone]];
    constant=[[Constant alloc]init];
    toxicDeficiencyArray=[[NSMutableArray alloc]init];
    selectedSittingModelInallDoctorDetailArray=[[NSMutableArray alloc]init];
    allSortedDetailArray=[[NSMutableArray alloc]init];
    allDoctorDetailArray=[[NSMutableArray alloc]init];
    selectedIndexArray=[[NSMutableArray alloc]init];
    selectedPreviousSittingDetailArray=[[NSMutableArray alloc]init];
    allPreviousSittingDetail=[[NSMutableArray alloc]init];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.revealViewController.delegate=self;
    [self.revealViewController setRightViewRevealWidth:180];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background-Image-2.jpg"]]];
    postman=[[Postman alloc]init];
    [self navigationItemMethod];
    [self defaultValues];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    _tableview.tableFooterView=[UIView new];
    self.revealViewController.delegate=self;
    [self.revealViewController setRightViewRevealWidth:180];
    if ([_isTreatmntCompleted intValue]==0) {
        if ([_bioSittingDict[@"IsCompleted"]intValue]==0 ) {
            _saveBtn.hidden=NO;
            _exit.hidden=YES;
        }else{
            _saveBtn.hidden=YES;
            _exit.hidden=NO;
        }
    }else{
        _saveBtn.hidden=YES;
        _exit.hidden=NO;
    }
    [self setTheValuesInTableView];
    [constant changeSaveBtnImage:_saveBtn];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//Set The Data at the Begining
-(void)setTheValuesInTableView{
    [selectedIndexArray removeAllObjects];
    [selectedPreviousSittingDetailArray removeAllObjects];
    if ([_sectionName isEqualToString:@""]) {
        if (allDoctorDetailArray.count==0) {
            allSectionNameArray =[[NSMutableArray alloc]init];
            [self callSeed];
        }else{
            for (sittingModel *model in allDoctorDetailArray) {
                model.germsString=@"";
                model.issue=NO;
                model.edited=@"N";
            }
            if (allSectionNameArray.count>0) {
                _filterLabel.text=allSectionNameArray[0];
                [self compareNextBtnToBeHidden];
            }
        }
    }else{
        selectedCellToFilter=_selectedIndexPathOfSectionInSlideOut.row;
        [self compareNextBtnToBeHidden];
    }
    if (appdelegate.symptomTagArray.count>0) {
        _collectionViewWidth.constant=50;
        [_collectionView reloadData];
        [_scrollView layoutIfNeeded];
        if (_collectionView.contentSize.width<self.view.frame.size.width-100) {
            _collectionViewWidth.constant=_collectionView.contentSize.width;
        }else _collectionViewWidth.constant=self.view.frame.size.width-100;
    }
}
-(void)defaultValues{
    [constant setColorForLabel:_genderLabel];
    [constant setColorForLabel:_mobileLabel];
    [constant setColorForLabel:_transfusion];
    [constant setColorForLabel:_emailLabel];
    [constant setColorForLabel:_surgeriesLabel];
    [constant setColorForLabel:_chargeLabel];
    [constant setFontForLabel:_genderValue];
    [constant setFontForLabel:_mobileValue];
    [constant setFontForLabel:_transfusionValue];
    [constant setFontForLabel:_emailValue];
    [constant setFontForLabel:_surgeriesValueLabel];
    [constant setFontForLabel:_patientName];
    [constant setFontForLabel:_ageLabel];
    [constant setFontForLabel:_ageValue];
    [constant getTheAllSaveButtonImage:_saveBtn];
    [constant getTheAllSaveButtonImage:_exit];
    _patientimage.layer.cornerRadius=_patientimage.frame.size.width/2;
    _patientimage.clipsToBounds=YES;
    [constant SetBorderForTextField:_priceTf];
    [constant spaceAtTheBeginigOfTextField:_priceTf];
    _priceTf.attributedPlaceholder=[constant textFieldPlaceHolderText:[MCLocalization stringForKey:@"Charge"]];
    _patientName.text= _searchModel.name;
    _ageValue.text=_searchModel.age;
    _mobileValue.text=_searchModel.mobileNo;
    _emailValue.text=_searchModel.emailId;
    _surgeriesValueLabel.text=_searchModel.surgeries;
    _transfusionValue.text=_searchModel.tranfusion;
    _genderValue.text=_searchModel.gender;
    _patienViewHeight.constant=44;
    _patientDetailView.hidden=YES;
    if (_searchModel.profileImageCode==nil) {
        _patientimage.image=_searchModel.profileImage;
    }else{
        NSString *str=[NSString stringWithFormat:@"%@%@%@",baseUrl,getProfile,_searchModel.profileImageCode];
        [_patientimage setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"Patient-img.jpg"]];
    }
}
//save price
- (IBAction)savePrice:(id)sender {
    if (![_priceTf.text isEqualToString:@""]) {
        [self.view endEditing:YES];
        _priceTf.enabled=NO;
    }
     _priceTf.enabled=YES;
}
//navigation bar
-(void)navigationItemMethod{
    self.revealViewController.navigationItem.hidesBackButton=YES;
    self.revealViewController.title=navTitle;
//    UIImage* image3 = [UIImage imageNamed:@"Icon-Signout.png"];
//    CGRect frameimg = CGRectMake(0, 0, image3.size.width, image3.size.height);
//    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
//    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
//    [someButton addTarget:self action:@selector(popToViewController) forControlEvents:UIControlEventTouchUpInside];
//    [someButton setShowsTouchWhenHighlighted:YES];
//  UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
 //   self.revealViewController.navigationItem.rightBarButtonItem=mailbutton;
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
    cell.addNoteTV.layer.cornerRadius=10;
    cell.addNoteTV.layer.borderColor=[UIColor colorWithRed:0.004 green:0.216 blue:0.294 alpha:0.5].CGColor;
    cell.addNoteTV.layer.borderWidth=1;
    cell.addNoteTV.font=[UIFont fontWithName:@"OpenSansSemibold" size:14];
    cell.addNoteTV.textColor=[UIColor colorWithRed:0.04 green:0.216 blue:0.294 alpha:1];
    cell.delegate=self;
    sittingModel *model= allSortedDetailArray[indexPath.section];
    cell.scanpointLabel.text=model.scanPointName;
    cell.correspondinPairLabel.text=model.correspondingPairName;
    cell.interpretation.text=model.interpretation;
    cell.psychoemotional.text=model.psychoemotional;
    cell.serialNumber.text=model.sortNumber;
    cell.doctorName.text=model.author;
    cell.sittingTextView.text=model.germsString;
    cell.otherGermsLabel.text=model.germsCodeString;
    cell.author.text=authour;
    if ([selectedIndexArray containsObject:indexPath]) {
        [self hideTheViewInTableViewCell:NO withCell:cell];
        cell.interpretation.numberOfLines=0;
        cell.scanpointLabel.numberOfLines=0;
        cell.correspondinPairLabel.numberOfLines=0;
        if (![cell.expandButton.image isEqual:[UIImage imageNamed:@"Dropdown-icon-up"]]) {
            [self changeIncreaseDecreaseImageView:cell.expandButton];
        }
        if ([selectedPreviousSittingDetailArray containsObject:indexPath]) {
            selectedPreviousArray=model.allPreviousSittingDetail;
            [self hideTheViewOfPreviousDetailOFSittingTableViewCell:NO withCell:cell];
            if (![cell.morePreviousButton.currentImage isEqual:[UIImage imageNamed:@"icon-up"]]) {
                [self ChangeIncreaseDecreaseButtonImage:cell.morePreviousButton];
            }
        }
        else{
            [self hideTheViewOfPreviousDetailOFSittingTableViewCell:YES withCell:cell];
            [cell.morePreviousButton setImage:[UIImage imageNamed:@"icon-down"] forState:normal];
        }
        if (model.issue) {
            [self colorChange:model.issue withCell:cell];
            cell.headerView.backgroundColor=[UIColor colorWithRed:0.686 green:0.741 blue:1 alpha:1];
            cell.germView.backgroundColor=[UIColor colorWithRed:0.686 green:0.741 blue:1 alpha:1];
        }else{
            [self colorChange:model.issue withCell:cell];
            cell.headerView.backgroundColor=[UIColor colorWithRed:0.863 green:0.953 blue:0.988 alpha:1];
            cell.germView.backgroundColor=[UIColor colorWithRed:0.863 green:0.953 blue:0.988 alpha:1];
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
        if (model.issue) {
            [self colorChange:model.issue withCell:cell];
             cell.headerView.backgroundColor=[UIColor colorWithRed:0.686 green:0.741 blue:1 alpha:1];
        }else{
            [self colorChange:model.issue withCell:cell];
            if (indexPath.section%2==0) {
               cell.headerView.backgroundColor=[UIColor colorWithRed:0.38 green:0.82 blue:0.961 alpha:1];
            }else  cell.headerView.backgroundColor=[UIColor colorWithRed:0.667 green:0.902 blue:0.976 alpha:1];
        }
    }
     [self showDataSavedInDBInTable:model withCell:cell];
    
    NSString *str1=@"";
    for (NSString *str in model.germsCode) {
        str1=[str1 stringByAppendingString:str];
        str1=[str1 stringByAppendingString:@" "];
    }
    cell.germLabel.text=str1;
   
    cell.previousSittingBadgeImageView.layer.cornerRadius=cell.previousSittingBadgeImageView.frame.size.width/2;
    if ([model.otherSittingNumberHaveIssue isEqualToString:@""]) {
        cell.previousSittingBadgeLabel.hidden=YES;
        cell.previousSittingBadgeImageView.hidden=YES;
    }else{
        cell.previousSittingBadgeLabel.hidden=NO;
        NSArray *ar=[model.otherSittingNumberHaveIssue componentsSeparatedByString:@" "];
        cell.previousSittingBadgeImageView.hidden=NO;
        if (model.germsString.length==0) {
             cell.previousSittingBadgeLabel.text=ar[ar.count-2];
        }
        else  cell.previousSittingBadgeLabel.text=[NSString stringWithFormat:@"%@%d",sStr,[model.sittingNumber intValue]];
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
    }else{
        return selectedPreviousArray.count;
    }
}
//collection view cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==_collectionView) {
        SymptomTagCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        SymptomTagModel *m= appdelegate.symptomTagArray[indexPath.row];
        cell.label.text=m.tagName;
        cell.delegate=self;
        if ([_isTreatmntCompleted intValue]==0) {
            if ([_bioSittingDict[@"IsCompleted"]intValue]==0 ) {
                cell.deleteSymptom.hidden=NO;
            }else cell.deleteSymptom.hidden=YES;
        }else  cell.deleteSymptom.hidden=YES;
        return cell;
    }
    else{
        PreviousSittingCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        PreviousSittingModelClass *m=selectedPreviousArray[indexPath.row];
        cell.sittingNumber.text=m.sittingNumber;
        cell.infoLabel.text=m.germsString;
        cell.dateLabel.text=m.dateVisited;
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
//show the Data added to sitting in db
-(void)showDataSavedInDBInTable:(sittingModel*)model withCell:(SittingTableViewCell*)cell{
      if ([model.germsString isEqualToString:@""]) {
        cell.sittingTextView.text=@"";
        cell.sittingTvPlaceholder.hidden=NO;
        if (_bioSittingDict!=nil) {
            if ([model.edited isEqualToString:@"N"]) {
                NSDictionary *dict=_bioSittingDict;
                NSString *str=dict[@"JSON"];
                model.sittingNumber=dict[@"SittingNumber"];
                NSError *jsonError;
                NSData *objectData = [str dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:&jsonError];
                [_datePicButton setTitle:dict[@"Visit"] forState:normal];
                NSArray *anotomicalPointArray=json[@"AnatomicalPoints"];
                if (json[@"ToxicDeficiency"]!=nil) {
                    selectedToxicString=json[@"ToxicDeficiency"];
                }
                if (![json[@"Price"] isEqualToString:@""]) {
                    _priceTf.text=json[@"Price"];
                }
                _sittingNumberLabel.text=[NSString stringWithFormat:@"%@%d",sStr,[dict[@"SittingNumber"]intValue]];
                  cell.sittingNumber.text=[NSString stringWithFormat:@"%@%d",sStr,[dict[@"SittingNumber"]intValue]];
                if (anotomicalPointArray.count>0) {
                    for (NSDictionary *anotomicalDict in anotomicalPointArray) {
                        if ([model.anatomicalBiomagenticCode isEqualToString:anotomicalDict[@"AnatomicalBiomagenticCode"]]) {
                            cell.sittingTextView.text=anotomicalDict[@"GermsName"];
                            model.germsString= cell.sittingTextView.text;
                            model.germsCodeString=anotomicalDict[@"GermsCode"];
                            NSString *str=[model.germsCodeString stringByReplacingOccurrencesOfString:@"," withString:@" "];
                            cell.otherGermsLabel.text=str;
                            cell.sittingTvPlaceholder.hidden=YES;
                            
                            if (anotomicalDict[@"Notes"]) {
                                NSString *str1=anotomicalDict[@"Notes"];
                                if (str1.length!=0) {
                                    cell.addNoteTV.text=str1;
                                    cell.addNoteLabel.hidden=YES;
                                }else {
                                    cell.addNoteTV.text=@"";
                                    cell.addNoteLabel.hidden=NO;
                                }
                            }
                            if ([anotomicalDict[@"Issue"] integerValue]==1) {
                                model.issue= YES;
                                [self colorChange:model.issue withCell:cell];
                                  cell.headerView.backgroundColor=[UIColor colorWithRed:0.686 green:0.741 blue:1 alpha:1];
                            }else{
                                model.issue= NO;
                                [self colorChange:model.issue withCell:cell];
                                 cell.headerView.backgroundColor=[UIColor colorWithRed:0.38 green:0.82 blue:0.961 alpha:1];
                            }
                        }
                    }
                }
            }
        }else{
            _sittingNumberLabel.text=[NSString stringWithFormat:@"%@%d",sStr,[_sittingNumber intValue]+1];
            cell.sittingNumber.text=[NSString stringWithFormat:@"%@%d",sStr,[_sittingNumber intValue]+1];
            [formater setDateFormat:@"dd-MMM-yyyy"];
            NSString *dateStr=[formater stringFromDate:[NSDate date]];
            [_datePicButton setTitle:dateStr forState:normal];
        }
    }else {
        if (model.issue) {
            [self colorChange:model.issue withCell:cell];
            cell.headerView.backgroundColor=[UIColor colorWithRed:0.686 green:0.741 blue:1 alpha:1];
        }else{
            [self colorChange:model.issue withCell:cell];
            cell.headerView.backgroundColor=[UIColor colorWithRed:0.38 green:0.82 blue:0.961 alpha:1];
        }

        cell.sittingTextView.text=model.germsString;
        model.notes=cell.addNoteTV.text;
        NSString *str=[model.germsCodeString stringByReplacingOccurrencesOfString:@"," withString:@" "];
        cell.otherGermsLabel.text=str;
        cell.sittingTvPlaceholder.hidden=YES;
         _sittingNumberLabel.text=[NSString stringWithFormat:@"%@%@",sStr,_sittingNumber];
    }
    if ([_isTreatmntCompleted intValue]==0) {
        if ([_bioSittingDict[@"IsCompleted"]intValue]==0 ){
            [self disableTheButton:cell withStatus:YES];
        }else [self disableTheButton:cell withStatus:NO];
    }else  [self disableTheButton:cell withStatus:NO];
    [self getSittingNumberForEachSittingCell:model];
}
//getTheSittingNumberForEachSitting
-(void)getSittingNumberForEachSittingCell:(sittingModel*)model{
    [allPreviousSittingDetail removeAllObjects];
    model.otherSittingNumberHaveIssue=@"";
    for ( NSDictionary *dict in _allAddedBiomagArray) {
        NSString *str=dict[@"JSON"];
        NSError *jsonError;
        NSData *objectData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:&jsonError];
        NSArray *anotomicalPointArray=json[@"AnatomicalPoints"];
        if (anotomicalPointArray.count>0) {
            for (NSDictionary *anotomicalDict in anotomicalPointArray) {
                if (([anotomicalDict[@"SectionCode"] isEqualToString:model.sectionCode])&([anotomicalDict[@"CorrespondingPairCode"] isEqualToString:model.correspondingPairCode])&([anotomicalDict[@"ScanPointCode"] isEqualToString:model.scanPointCode]) ) {
                    if ([anotomicalDict[@"Issue"] integerValue]==1) {
                        NSString *str=[NSString stringWithFormat:@"%@%d",sStr,[dict[@"SittingNumber"]intValue]];
                        model.otherSittingNumberHaveIssue=[model.otherSittingNumberHaveIssue stringByAppendingString:str];
                        model.otherSittingNumberHaveIssue=[model.otherSittingNumberHaveIssue stringByAppendingString:@" "];
                    }
                    int i=[dict[@"SittingNumber"]intValue];
                    if (i<[model.sittingNumber intValue]) {
                        PreviousSittingModelClass *model1=[[PreviousSittingModelClass alloc]init];
                        model1.dateVisited=dict[@"Visit"];
                        model1.sittingNumber=[NSString stringWithFormat:@"S%d",[dict[@"SittingNumber"]intValue]];
                        if ([anotomicalDict[@"Issue"] integerValue]==1) {
                            model1.issue= YES;
                        }else{
                            model1.issue= NO;
                        }
                        model1.germsString=anotomicalDict[@"GermsName"];
                        [allPreviousSittingDetail addObject:model1];
                    }
                }
                model.allPreviousSittingDetail=[allPreviousSittingDetail copy];
            }
        }
    }
}
//Change the color of cell
-(void)colorChange:(BOOL)issue withCell:(SittingTableViewCell*)cell{
    if (issue) {
        [cell.checkBox setBackgroundImage:[UIImage imageNamed:@"issue-Button"] forState:normal];
        [cell.checkBox setTitle:issueStr forState:normal];
    }else{
        [cell.checkBox setBackgroundImage:[UIImage imageNamed:@"no-issue-Button"] forState:normal];
        [cell.checkBox setTitle:noIssueStr forState:normal];
    }
}
//Hide button if treatment is completed
-(void)disableTheButton:(SittingTableViewCell*)cell withStatus:(BOOL)status{
    cell.showGermsButton.userInteractionEnabled=status;
     cell.addNoteTV.userInteractionEnabled=status;
    cell.checkBox.userInteractionEnabled=status;
    _priceTf.enabled=status;
    _addSymptom.enabled=status;
}
//symptom view
- (IBAction)addSymptom:(id)sender {
    if (symptomView==nil)
        symptomView=[[AddSymptom alloc]initWithFrame:CGRectMake(150, 140,400,117)];
    symptomView.delegate=self;
    symptomView.searchModel=_searchModel;
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
    BOOL parameter =NO;
    for (sittingModel *model in allDoctorDetailArray) {
        if (![model.germsString isEqualToString:@""]) {
            parameter=YES;
            break;
        }
    }
    if (parameter) {
    UIAlertController *alertView=[UIAlertController alertControllerWithTitle:alert message:doYoucloseSitting preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *success=[UIAlertAction actionWithTitle:yesStr style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
        [self callApiToSaveTreatmentRequest:@"true"];
        [alertView dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertView addAction:success];
    UIAlertAction *failure=[UIAlertAction actionWithTitle:noStr style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
        [self callApiToSaveTreatmentRequest:@"false"];
        [alertView dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertView addAction:failure];
    [self presentViewController:alertView animated:YES completion:nil];
    }else{
        [self showToastMessage:@"No changes is there to save"];
    }
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
    if ([_toxicDeficiencyString isEqualToString:@""]) {
        [self getTheSortDetailOfCompleteDitailArray:allSectionNameArray[selectedCellToFilter]];
        if (selectedCellToFilter==0) _previousBtn.hidden=YES;
        else if (selectedCellToFilter==allSectionNameArray.count-1) {
            _nextBtn.hidden=YES;
        }
        else{
            _previousBtn.hidden=NO;
            _nextBtn.hidden=NO;
        }
    }else{
        ToxicDeficiency *model=toxicDeficiencyArray[selectedCellToFilter];
        _toxicDeficiencyString=[NSString stringWithFormat:@"%@$%@",model.code,model.name];
        [self showToxicDeficiencyView];
        if (selectedCellToFilter==0) _previousBtn.hidden=YES;
        else if (selectedCellToFilter==toxicDeficiencyArray.count-1) {
            _nextBtn.hidden=YES;
        }
        else{
            _previousBtn.hidden=NO;
            _nextBtn.hidden=NO;
        }
    }
}
//slide out
- (IBAction)slideout:(id)sender {
    [self callSeedForToxicDeficiency];
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
    sittingModel *model=allSortedDetailArray[indexPath.section];
    if (model.allPreviousSittingDetail.count>0) {
        if ([cell1.morePreviousButton.currentImage isEqual:[UIImage imageNamed:@"icon-down"]]) {
            [selectedPreviousSittingDetailArray addObject:indexPath];
            [self ChangeIncreaseDecreaseButtonImage:cell1.morePreviousButton];
        }
        else{
            [selectedPreviousSittingDetailArray removeObject:indexPath];
            [self ChangeIncreaseDecreaseButtonImage:cell1.morePreviousButton];
        }
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
    if (!status) {
        cell.previousDetailCollectionView.delegate=self;
        cell.previousDetailCollectionView.dataSource=self;
        [cell.previousDetailCollectionView reloadData];
    }
}
//Tap on DashBoard to close SlideOutViewController
- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position{
    if (position == FrontViewPositionLeftSide){
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
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    }
}
-(void)callSeed{
    
    //    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
    //        //For vzone API
    //        [self callApi];
    //    }else{
    //        //For Material API
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault boolForKey:@"anatomicalbiomagneticmatrix_FLAG"]) {
        [self callApi];
    }
    else{
        NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,biomagneticMatrix];
        [[SeedSyncer sharedSyncer]getResponseFor:url completionHandler:^(BOOL success, id response) {
            if (success) {
                [self processResponseObject:response];
            }
            else{
                [self callApi];
            }
        }];
    }
    
    //   }
}
//Call api to get the biomagnetic matrix
-(void)callApi{
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,biomagneticMatrix];
    
    NSString *parameter;
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        //For Vzone API
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSString *languageCode=[defaults valueForKey:@"languageCode"];
        parameter=[NSString stringWithFormat:@"{\"request\":{\"SectionCode\": \"\",\"ScanPointCode\": \"\",\"CorrespondingPairCode\":\"\",\"GermsCode\": \"\",\"CurrentLanguageCode\": \"%@\"}}",languageCode];
    }else{
        
        //For material API
        
        parameter =[NSString stringWithFormat:@"{\"SectionCode\": \"\",\"ScanPointCode\": \"\",\"CorrespondingPairCode\":\"\",\"GermsCode\": \"\"}"];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [self processResponseObject:responseObject];
        [[SeedSyncer sharedSyncer]saveResponse:[operation responseString] forIdentity:url];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setBool:NO forKey:@"anatomicalbiomagneticmatrix_FLAG"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [self showToastMessage:[NSString stringWithFormat:@"%@",error]];
        
    }];
}
//Response of biomagnetic matrix
-(void)processResponseObject:(id)responseObject{
    [allSortedDetailArray removeAllObjects];
    [allSectionNameArray removeAllObjects];
    [allDoctorDetailArray removeAllObjects];
    NSDictionary *dict;
    
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        //For Vzone API
        NSDictionary *responseDict1 = responseObject;
        dict= responseDict1[@"aaData"];
    }else{
        //For Material API
        dict=responseObject;
    }
    
    if ([dict[@"Success"] intValue]==1) {
        for (NSDictionary *dict1 in dict[@"AnatomicalBiomagneticMatrix"]) {
            if ([dict1[@"Status"]intValue]==1) {
                sittingModel *model=[[sittingModel alloc]init];
                model.edited=@"N";
                model.sittingId=dict1[@"Id"];
                model.germsName=[[NSMutableArray alloc]init];
                model.germsCode=[[NSMutableArray alloc]init];
                if (dict1[@"Code"]!=[NSNull null]) {
                    model.anatomicalBiomagenticCode=dict1[@"Code"];
                }
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
                 model.germsCodeString=@"";
                model.notes=@"";
                [allDoctorDetailArray addObject:model];
            }
        }
    }
    if (allSectionNameArray.count>0) {
         [self getTheSortDetailOfCompleteDitailArray:allSectionNameArray[0]];
    }
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
-(void)noteAddedDelegate:(UITableViewCell *)cell{
    SittingTableViewCell *cell1=(SittingTableViewCell*)cell;
  NSIndexPath  *i=[_tableview indexPathForCell:cell1];
   sittingModel *model1=allSortedDetailArray[i.section];
    model1.notes=cell1.addNoteTV.text;
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
        germsViewXib.fromParentViewGermsString=cell1.otherGermsLabel.text;
    }else germsViewXib.fromParentViewGermsString=@"";
    [germsViewXib alphaViewInitialize];
}
//delegate of germs
-(void)germsData:(NSArray *)germasData{
    sittingModel *model1=allSortedDetailArray[selectedCellIndex.section];
    if (germasData.count>0) {
        NSString *selectedGerms=@"";
        NSString *selectedGermsCode=@"";
        for (germsModel *model in germasData) {
            selectedGerms= [selectedGerms stringByAppendingString:[NSString stringWithFormat:@"%@",model.germsName]];
             selectedGermsCode= [selectedGermsCode stringByAppendingString:[NSString stringWithFormat:@"%@",model.germsUserFriendlycode]];
            if (![[germasData lastObject] isEqual:model]) {
                selectedGerms= [selectedGerms stringByAppendingString:@","];
                selectedGermsCode= [selectedGermsCode stringByAppendingString:@","];
            }
        }
        model1.selectedCellIndex=selectedCellIndex;
        model1.germsString=selectedGerms;
        model1.germsCodeString=selectedGermsCode;
        model1.issue=YES;
    }else {
        model1.selectedCellIndex=nil;
        model1.germsString=@"";
        model1.germsCodeString=@"";
        model1.issue=NO;
        model1.edited=@"Y";
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
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL status=YES;
    if ([textField isEqual:_priceTf]) {
        if (_priceTf.text.length>6) {
            if (string.length==0) {
                status=YES;
            }
            else status=NO;
        }
        else{
            NSCharacterSet * numberCharSet = [NSCharacterSet characterSetWithCharactersInString:@".0123456789"];
            for (int i = 0; i < [string length]; ++i)
            {
                unichar c = [string characterAtIndex:i];
                if (![numberCharSet characterIsMember:c])
                {
                    status= NO;
                }
            }
        }
        if (string.length!=0) {
        if (status) {
            NSString *priceRex=@"^[0-9]*((\\.|,)[0-9]{0,1})?$";;
            NSPredicate *priceTest=[NSPredicate predicateWithFormat:@"self matches %@",priceRex];
            BOOL validate=[priceTest evaluateWithObject:_priceTf.text];
            status=validate;
        }
        }
    }else status=NO;
    return status;
}
-(void)callApiToSaveTreatmentRequest:(NSString*)str{
    NSString *url=[NSString stringWithFormat:@"%@%@%@",baseUrl,closeTreatmentDetail,_treatmentId];
    NSString *parameter;
    if (_bioSittingDict!=nil) {
        parameter =[self getParameteToSaveSittingDetail:[_bioSittingDict[@"Id"] integerValue] withSittingNum:[_bioSittingDict[@"SittingNumber"] integerValue] withCompletedData:str];
    }else{
        parameter =[self getParameteToSaveSittingDetail:0 withSittingNum:0 withCompletedData:str];
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    if ([_treatmentId integerValue]==0) {
        [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            [self processResponseObjectOfSaveTreatment:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            NSString *str=[NSString stringWithFormat:@"%@",error];
            [self showToastMessage:str];
        }];
    }else{
        
        [postman put:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            [self processResponseObjectOfSaveTreatment:responseObject];
        
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [MBProgressHUD hideHUDForView:self.view animated:NO];
            
            [self showToastMessage:[NSString stringWithFormat:@"%@",error]];
          
        
        }];
    }
}
-(NSString*)getParameteToSaveSittingDetail:(NSInteger)biomagneticId withSittingNum:(NSInteger)sittingNum withCompletedData:(NSString*)completed{
    NSString *str=_sittingStringParameterFromParent;
    NSError *jsonError;
    NSData *objectData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers
                                                           error:&jsonError];
    
    NSMutableDictionary *treatmentDict;
    NSMutableDictionary *finalDict;
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        //For Vzone API
        NSDictionary *dict=json[@"request"];
        NSString *str1=dict[@"TreatmentRequest"];
        NSData *objectData1 = [str1 dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict1=[NSJSONSerialization JSONObjectWithData:objectData1 options:kNilOptions error:nil];
        treatmentDict=[dict1 mutableCopy];
        finalDict=[[NSMutableDictionary alloc]init];
    }else{
       finalDict =[json mutableCopy];
        treatmentDict=[finalDict[@"TreatmentRequest"]mutableCopy];
    }
    NSString *symptomStr=@"";
    for (SymptomTagModel *m in appdelegate.symptomTagArray) {
        symptomStr=[symptomStr stringByAppendingString:m.tagCode];
        symptomStr=[symptomStr stringByAppendingString:@","];
    }
    treatmentDict[@"SymptomTagCodes"]=symptomStr;
    treatmentDict[@"IsTreatmentCompleted"]=@"false";
    treatmentDict[@"Status"]=@"true";
    
    NSMutableArray *sittingResultArray=[[NSMutableArray alloc]init];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    dict[@"BiomagneticSittingId"]= [@(biomagneticId) description];
    [formater setDateFormat:@"dd-MMM-yyyy"];
    NSString *visitDate=[formater stringFromDate:[NSDate date]];
    dict[@"Visit"]=visitDate;
    if (sittingNum==0) {
        dict[@"SittingNumber"] =@([_sittingNumber intValue]+1);
    }else  dict[@"SittingNumber"] = @(sittingNum);
    dict[@"Interval"] = @(15);
    dict[@"IsCompleted"]=completed;
    NSMutableDictionary *sittingDict=[[NSMutableDictionary alloc]init];
    NSMutableArray *jsonSittingArray=[[NSMutableArray alloc]init];
    for (sittingModel *model in allDoctorDetailArray) {
        if (![model.germsString isEqualToString:@""]) {
            NSMutableDictionary *sectionDict=[[NSMutableDictionary alloc]init];
            sectionDict[@"SectionCode"]=model.sectionCode;
            sectionDict[@"ScanPointCode"]=model.scanPointCode;
            sectionDict[@"CorrespondingPairCode"]=model.correspondingPairCode;
//            sectionDict[@"SectionName"]=model.sectionName;
//            sectionDict[@"ScanPointName"]=model.scanPointName;
//            sectionDict[@"CorrespondingPairName"]=model.correspondingPairName;
            sectionDict[@"GermsCode"]=model.germsCodeString;
            sectionDict[@"GenderCode"]=model.genderCode;
            sectionDict[@"Description"]=model.interpretation;
            sectionDict[@"Psychoemotional"]=model.psychoemotional;
            sectionDict[@"Author"]=model.author;
//            sectionDict[@"LocationScanPoint"]=@"";
//            sectionDict[@"LocationCorrespondingPair"]=@"";
            sectionDict[@"GermsName"]=model.germsString;
            sectionDict[@"Notes"]=model.notes;
            sectionDict[@"Issue"]=[@(model.issue) description];
            sectionDict[@"AnatomicalBiomagenticCode"]=model.anatomicalBiomagenticCode;
            [jsonSittingArray addObject:sectionDict];
        }
    }
    NSString *toxicStr=[_toxicView getAllTheSelectedToxic];
    if (toxicStr.length==0) {
        toxicStr=selectedToxicString;
    }
    sittingDict[@"ToxicDeficiency"]=toxicStr;
    sittingDict[@"Notes"]=@"";
    sittingDict[@"Status"]=@"1";  
    sittingDict[@"AnatomicalPoints"]=jsonSittingArray;
    sittingDict[@"Price"]=_priceTf.text;
    
    NSString *parameter;
    
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        //For Vzone API
        if (([toxicStr isEqualToString:@""]) &(jsonSittingArray.count==0)){
           parameter=@"";
        }else{
        NSData *sitingReq1 = [NSJSONSerialization dataWithJSONObject:treatmentDict options:kNilOptions error:nil];
        NSString *sittunReqJsonString1 = [[NSString alloc] initWithData:sitingReq1 encoding:NSUTF8StringEncoding];
        NSMutableDictionary *dict1ofSitting=[[NSMutableDictionary alloc]init];
        dict1ofSitting[@"TreatmentRequest"]=sittunReqJsonString1;
        dict[@"JSON"]=sittingDict;
        [sittingResultArray addObject:dict];
        
        NSData *sitingReq = [NSJSONSerialization dataWithJSONObject:sittingResultArray options:kNilOptions error:nil];
        NSString *sittunReqJsonString = [[NSString alloc] initWithData:sitingReq encoding:NSUTF8StringEncoding];
   dict1ofSitting[@"SittingResultsRequest"]=sittunReqJsonString;
        
        if ([_treatmentId integerValue]==0) {
            dict1ofSitting[@"MethodType"]=@"POST";
        }
        else dict1ofSitting[@"MethodType"]=@"PUT";
        
        dict1ofSitting[@"Id"]=_treatmentId;
        finalDict[@"request"]=dict1ofSitting;
        
        NSData *parameterData1 = [NSJSONSerialization dataWithJSONObject:finalDict options:kNilOptions error:nil];
        parameter = [[NSString alloc] initWithData:parameterData1 encoding:NSUTF8StringEncoding];
        
        }
}else{
    if (([toxicStr isEqualToString:@""]) &(jsonSittingArray.count==0)){
      parameter=@"";
    }else{
    finalDict[@"TreatmentRequest"]=treatmentDict;
    NSData *sittingData = [NSJSONSerialization dataWithJSONObject:sittingDict options:kNilOptions error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:sittingData encoding:NSUTF8StringEncoding];
    dict[@"JSON"]=jsonString;
    [sittingResultArray addObject:dict];
    finalDict[@"SittingResultsRequest"]=sittingResultArray;
        //For Material API
    if ([_treatmentId integerValue]==0) {
        finalDict[@"MethodType"]=@"POST";
    }
    else finalDict[@"MethodType"]=@"PUT";
        NSData *parameterData = [NSJSONSerialization dataWithJSONObject:finalDict options:kNilOptions error:nil];
        parameter = [[NSString alloc] initWithData:parameterData encoding:NSUTF8StringEncoding];
    }
}

    return parameter;
}

-(void)processResponseObjectOfSaveTreatment:(id)responseObject{
    NSDictionary *dict;
    
if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
    //For Vzone API
    NSDictionary *responseDict1 = responseObject;
    dict  = responseDict1[@"aaData"];
}else{
    //For Material API
    dict=responseObject;
}
    if ([dict[@"Success"] intValue]==1) {
        NSDictionary *dict1=dict[@"TreatmentRequest"];
        int i=[dict1[@"ID"] intValue];
        [self.delegateForIncreasingSitting uploadImageAfterSaveInSitting:dict1[@"Code"]];
        [self.delegateForIncreasingSitting loadTreatMentFromSittingPart:[@(i) description] withTreatmentCode:dict1[@"Code"]];
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
//        UIAlertController *alert1=[UIAlertController alertControllerWithTitle:alert message:dict[@"Message"] preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *failure=[UIAlertAction actionWithTitle:alertOK style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//            
//        }];
//        [alert1 addAction:failure];
//        [self presentViewController:alert1 animated:YES completion:nil];
    }
    else{
        [self showToastMessage:dict[@"Message"]];
//        UIAlertController *alert1=[UIAlertController alertControllerWithTitle:alert message:dict[@"Message"] preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *failure=[UIAlertAction actionWithTitle:alertOK style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//            [self dismissViewControllerAnimated:YES completion:nil];
//        }];
//        [alert1 addAction:failure];
//        [self presentViewController:alert1 animated:YES completion:nil];
    }
}
-(void)getTheSortDetailOfCompleteDitailArray:(NSString*)str{
    [selectedSittingModelInallDoctorDetailArray removeAllObjects];
    if ([_toxicDeficiencyString isEqualToString:@""]) {
        _toxicView.hidden=YES;
        _tableview.hidden=NO;
        _scanPointHeaderView.hidden=NO;
        [allSortedDetailArray removeAllObjects];
        NSArray *ar=[str componentsSeparatedByString:@"$"];
        _sectionName=ar[1];
        _filterLabel.text=ar[0];
        for (sittingModel *model in allDoctorDetailArray) {
            if ([model.sectionCode isEqualToString:_sectionName]) {
                [allSortedDetailArray addObject:model];
            }
        }
        [_tableview reloadData];
        [_scrollView layoutIfNeeded];
    }
      [self getGermsStringForCompleDetailArray];
}
- (IBAction)exit:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)showToxicDeficiencyView{
    _toxicView.selectedToxicCode=_toxicDeficiencyString;
    _toxicView.selectedToxicDeficiency=selectedToxicString;
    if ([_isTreatmntCompleted intValue]==0) {
        _toxicView.isTreatmntCompleted=_bioSittingDict[@"IsCompleted"];
    }else  _toxicView.isTreatmntCompleted=@"1";
    NSArray *ar=[_toxicDeficiencyString componentsSeparatedByString:@"$"];
    if (_toxicView.toxicArray.count==0) {
        [_toxicView callSeed];
    }else [_toxicView sortData];
    _filterLabel.text=ar[1];
    [self hideAllViewAfterClickOnSlideOut:YES];
}
//hide The button
-(void)hideAllViewAfterClickOnSlideOut:(BOOL)status{
    _tableview.hidden=status;
    _scanPointHeaderView.hidden=status;
    if (status==NO) {
        _toxicView.hidden=YES;
    }else{
        _toxicView.hidden=NO;
    }
    if ([_isTreatmntCompleted intValue]==0)
    {
        if ([_bioSittingDict[@"IsCompleted"]intValue]==0 ) {
            _exit.hidden=YES;
        }else{
            _exit.hidden=NO;
        }
        
    }else {
        _exit.hidden=NO;
    }
}
//call toxicDeficiency
-(void)callSeedForToxicDeficiency{
    
//    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
//        //For Vzone API
//        [self callApiForToxicDeficiency];
//    }else{
//        //For Material API
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        if ([userDefault boolForKey:@"toxicdeficiencytype_FLAG"]) {
            [self callApiForToxicDeficiency];
        }
        else{
            NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,toxicDeficiencyType];
            [[SeedSyncer sharedSyncer]getResponseFor:url completionHandler:^(BOOL success, id response) {
                if (success) {
                    [self processResponse:response];
                }
                else{
                    [self callApiForToxicDeficiency];
                }
            }];
        }
  //  }
    
}
//Api for Toxic
-(void)callApiForToxicDeficiency{
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,toxicDeficiencyType];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
          NSString *parameter=[NSString stringWithFormat:@"{\"request\":}}"];
    [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processResponse:responseObject];
         [MBProgressHUD hideHUDForView:self.view animated:NO];
        [[SeedSyncer sharedSyncer]saveResponse:[operation responseString] forIdentity:url];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setBool:NO forKey:@"toxicdeficiencytype_FLAG"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [self showToastMessage:[NSString stringWithFormat:@"%@",error]];
    }];
     }else{
         [postman get:url withParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [self processResponse:responseObject];
             [[SeedSyncer sharedSyncer]saveResponse:[operation responseString] forIdentity:url];
             NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
             [userDefault setBool:NO forKey:@"toxicdeficiencytype_FLAG"];
             [MBProgressHUD hideHUDForView:self.view animated:YES];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
         }];
     }
}
//process Response
-(void)processResponse:(id)responseObject{
    [toxicDeficiencyArray removeAllObjects];
    
    NSDictionary *dict;
    
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        //For Vzone API
        NSDictionary *responseDict1 = responseObject;
        dict  = responseDict1[@"aaData"];
    }else{
        //For Material API
        dict=responseObject;
    }

    for (NSDictionary *dict1 in dict[@"GenericSearchViewModels"]) {
        if ([dict1[@"Status"]intValue]==1) {
            ToxicDeficiency *model=[[ToxicDeficiency alloc]init];
            model.idValue=dict1[@"Id"];
            model.name=dict1[@"Name"];
            model.code=dict1[@"Code"];
            [toxicDeficiencyArray addObject:model];
        }
    }
    [self.revealViewController rightRevealToggleAnimated:YES];
    [self.revealViewController setRearViewRevealWidth:200];
    UINavigationController *nav=(UINavigationController*)self.revealViewController.rightViewController;
    SlideOutTableViewController *slideout=nav.viewControllers[0];
    slideout.allSectionNameArray=allSectionNameArray;
    slideout.allToxicDeficiencyArray=toxicDeficiencyArray;
}
-(void)sittingFromSlideOut{
    [self.revealViewController setFrontViewPosition:FrontViewPositionLeft];
    [self setTheValuesInTableView];
}
//get the germs string for each array
-(void)getGermsStringForCompleDetailArray{
    if (_bioSittingDict!=nil) {
    NSDictionary *dict=_bioSittingDict;
    NSString *str=dict[@"JSON"];
    NSError *jsonError;
    NSData *objectData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:&jsonError];
    NSArray *anotomicalPointArray=json[@"AnatomicalPoints"];
    if (anotomicalPointArray.count>0) {
        for (NSDictionary *anotomicalDict in anotomicalPointArray) {
            for (sittingModel *model in allDoctorDetailArray) {
                if (([anotomicalDict[@"SectionCode"] isEqualToString:model.sectionCode])&([anotomicalDict[@"CorrespondingPairCode"] isEqualToString:model.correspondingPairCode])&([anotomicalDict[@"ScanPointCode"] isEqualToString:model.scanPointCode]) ) {
                    if (model.germsString.length==0) {
                        model.germsCodeString=anotomicalDict[@"GermsCode"];
                        model.germsString=anotomicalDict[@"GermsName"];
                        model.issue=YES;
                    }
                    [selectedSittingModelInallDoctorDetailArray addObject:model];
                    break;
                }
            }
        }
    }
    }
}

//Alert Message
-(void)showAlerView:(NSString*)msg{
    UIAlertController *alertView=[UIAlertController alertControllerWithTitle:alert message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *success=[UIAlertAction actionWithTitle:alertOK style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
        [alertView dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertView addAction:success];
    [self presentViewController:alertView animated:YES completion:nil];
}
//Toast Message
-(void)showToastMessage:(NSString*)msg{
    MBProgressHUD *hubHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hubHUD.mode=MBProgressHUDModeText;
    hubHUD.labelText=msg;
    hubHUD.labelFont=[UIFont systemFontOfSize:15];
    hubHUD.margin=20.f;
    hubHUD.yOffset=150.f;
    hubHUD.removeFromSuperViewOnHide = YES;
    [hubHUD hide:YES afterDelay:2];
}
-(void)localize{
    navTitle=[MCLocalization stringForKey:@"TreatmentSheet"];
    alert=[MCLocalization stringForKey:@"Alert!"];
    alertOK=[MCLocalization stringForKey:@"AlertOK"];
    saveFailed=[MCLocalization stringForKey:@"Save Failed"];
    saveSuccess=[MCLocalization stringForKey:@"Saved successfully"];
    _genderLabel.text=[MCLocalization stringForKey:@"GenderLabel"];
    _ageLabel.text=[MCLocalization stringForKey:@"AgeLabel"];
    _mobileLabel.text=[MCLocalization stringForKey:@"MobileLabel"];
    _transfusion.text=[MCLocalization stringForKey:@"TransfusionLabel"];
    _emailLabel.text=[MCLocalization stringForKey:@"EmailLabel"];
    _surgeriesLabel.text=[MCLocalization stringForKey:@"SurgeriesLabel"];
    yesStr=[MCLocalization stringForKey:@"Yes"];
    noStr=[MCLocalization stringForKey:@"No"];
    _chargeLabel.text=[MCLocalization stringForKey:@"Charge"];
    navTitle=[MCLocalization stringForKey:@"Sitting"];
    [_saveBtn setTitle:[MCLocalization stringForKey:@"Save"] forState:normal];
    [_exit setTitle:[MCLocalization stringForKey:@"Exit"] forState:normal];
//    [_nextBtn setTitle:[MCLocalization stringForKey:@"Next"] forState:normal];
//    [_previousBtn setTitle:[MCLocalization stringForKey:@"Previous"] forState:normal];
    [_addSymptom setTitle:[MCLocalization stringForKey:@"Add symptoms"] forState:normal];
    
    _scanpointLabel.text=[MCLocalization stringForKey:@"Scan Point"];
    _correspondingPair.text=[MCLocalization stringForKey:@"Corresponding Pair"];
    _CodeLabel.text=[MCLocalization stringForKey:@"Code"];
    _interpretationLabel.text=[MCLocalization stringForKey:@"Interpretation"];
    _psychoemotionalLabel.text=[MCLocalization stringForKey:@"Psychoemotional"];
   authour=[MCLocalization stringForKey:@"Author"];
    enterSittingInfo=[MCLocalization stringForKey:@"Enter Sitting information"];
    previousSittings=[MCLocalization stringForKey:@"Previous Sittings"];
    sStr=[MCLocalization stringForKey:@"S"];
    issueStr=[MCLocalization stringForKey:@"issues"];
    noIssueStr=[MCLocalization stringForKey:@"No issues"];
    s1Str=[MCLocalization stringForKey:@"S1"];
    doYoucloseSitting=[MCLocalization stringForKey:@"Do you want to close Sitting?"];
}
@end
