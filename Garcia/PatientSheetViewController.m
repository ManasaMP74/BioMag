#import "PatientSheetViewController.h"
#import "Constant.h"
#import "PatientSheetTableViewCell.h"
#import "AttachmentViewController.h"
#import "CollectionViewTableViewCell.h"
#import "SittingCollectionViewCell.h"
#import "CollectionViewTableViewCell.h"
#import "UploadCollectionViewCell.h"
#import "TagCollectionViewCell.h"
#import "SittingModelClass.h"
#import "UploadModelClass.h"
#import "Postman.h"
#import "PostmanConstant.h"
#import "MBProgressHUD.h"
#import "SymptomTagModel.h"
#import "SWRevealViewController.h"
#import "SittingViewController.h"
@interface PatientSheetViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UITextViewDelegate,deleteCell,deleteTagCell,selectedImage>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *genderLabel;
@property (strong, nonatomic) IBOutlet UILabel *tranfusion;
@property (strong, nonatomic) IBOutlet UILabel *dobLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *genderValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *transfusionValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *dobValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *surgeryLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *surgeryValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *patientDetailLabel;
@property (strong, nonatomic) IBOutlet UILabel *medicalHistoryLabel;
@property (strong, nonatomic) IBOutlet UITextView *medicalHistoryTextView;
@property (strong, nonatomic) IBOutlet UIButton *uploadButton;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UITableView *MedicaltableView;
@property (strong, nonatomic) IBOutlet UITableView *diagnosisTableView;
@property (strong, nonatomic) IBOutlet UILabel *diagnosisLabel;
@property (strong, nonatomic) IBOutlet UILabel *settingLabel;
@property (strong, nonatomic) IBOutlet UILabel *uploadLabel;
@property (strong, nonatomic) IBOutlet UILabel *symptomtagLabel;
@property (strong, nonatomic) IBOutlet UILabel *mobileLabel;
@property (strong, nonatomic) IBOutlet UITextField *treatmentNameTF;
@property (strong, nonatomic) IBOutlet UILabel *treatmentEnclosure;
@property (strong, nonatomic) IBOutlet UILabel *mobileValueLabel;
@property (strong, nonatomic) IBOutlet UITextField *symptomtagTF;
@property (strong, nonatomic) IBOutlet UITextView *treatmentEncloserTextView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *medicalHistoryViewHeight;
@property (strong, nonatomic) IBOutlet UIView *medicalHistoryView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *diagnosisViewHeight;
@property (strong, nonatomic) IBOutlet UIView *diagnosisView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *settingViewHeight;
@property (strong, nonatomic) IBOutlet UIButton *increasePatientViewButton;
@property (strong, nonatomic) IBOutlet UIButton *increaseMedicalViewButton;
@property (strong, nonatomic) IBOutlet UIButton *increaseDiagnosisViewButton;
@property (strong, nonatomic) IBOutlet UIButton *increasesettingViewButton;
@property (strong, nonatomic) IBOutlet UIButton *increaseUploadViewButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *uploadViewHeigh;
@property (strong, nonatomic) IBOutlet UIView *uploadView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *increasePatientViewHeight;
@property (strong, nonatomic) IBOutlet UIView *symptomView;
@property (strong, nonatomic) IBOutlet UIView *settingView;
@property (strong, nonatomic) IBOutlet UITextView *diagnosisTextView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *treatmentCloserViewHeight;
@property (strong, nonatomic) IBOutlet UIView *treatmentclosureView;
@property (strong, nonatomic) IBOutlet UIView *increasePatientView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *symptomTagViewHeight;
@property (strong, nonatomic) IBOutlet UICollectionView *sittingCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionView *tagCollectionView;

@end

@implementation PatientSheetViewController
{
    Constant *constant;
    NSMutableArray *tagListArray,*diagnosisTableListArray,*medicalTableListArray;
    float sittingCollectionViewHeight,uploadCellHeight,diagnosisCellHeight,medicalHistoryCellHeight;
    AttachmentViewController *attachView;
    UIView *activeField;
    NSMutableArray *uploadedImageArray,*sittingCollectionArray,*allTagListArray,*filterdTagListArray;
    Postman *postman;
    NSDateFormatter *formatter;
    UIAlertView *closeTreatMentAlert;
    NSString *treatmentID;
    NSDictionary *passingDictToSittingVc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    tagListArray =[[NSMutableArray alloc]init];
    filterdTagListArray=[[NSMutableArray alloc]init];
    sittingCollectionViewHeight=0.0,uploadCellHeight=0.0,diagnosisCellHeight=25.0,medicalHistoryCellHeight=25.0;
    constant=[[Constant alloc]init];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background-Image-02.jpg"]]];
    self.title=@"Treatment Sheet";
    tagListArray=[[NSMutableArray alloc]init];
    [_treatmentNameTF addTarget:self action:@selector(enableAndDisableTreatmentName) forControlEvents:UIControlEventEditingChanged];
    uploadedImageArray=[[NSMutableArray alloc]init];
    sittingCollectionArray=[[NSMutableArray alloc]init];
    [self defaultValue];
    [self registerForKeyboardNotifications];
    [self navigationItemMethod];
    attachView=[self.storyboard instantiateViewControllerWithIdentifier:@"AttachmentViewController"];
    postman=[[Postman alloc]init];
    [_symptomtagTF addTarget:self action:@selector(tagTextFieldChange) forControlEvents:UIControlEventEditingChanged];
    tagListArray =[[NSMutableArray alloc]init];
    medicalTableListArray=[[NSMutableArray alloc]init];
    diagnosisTableListArray=[[NSMutableArray alloc]init];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self changeTreatmentTF];
    self.navigationItem.hidesBackButton=YES;
    formatter=[[NSDateFormatter alloc]init];
    //    [self callApiTogetSymptomTag];
    if (_patientDetailModel.title!=nil) {
        [self callApiTogetAllDetailOfTheTreatment];
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_sittingCollectionView reloadData];
}
//navigation bar
-(void)navigationItemMethod{
    UIImage* image3 = [UIImage imageNamed:@"Icon-Signout.png"];
    CGRect frameimg = CGRectMake(0, 0, image3.size.width, image3.size.height);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(popToViewController) forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.navigationItem.rightBarButtonItem=mailbutton;
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
//pop view
-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}
//pop to root view
-(void)popToViewController{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//enable disable treatmentName
-(void)enableAndDisableTreatmentName{
    if (![_treatmentNameTF.text isEqualToString:@""]) {
        _treatmentButton.userInteractionEnabled=YES;
    }
    else _treatmentButton.userInteractionEnabled=NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//increase the View Height of patient view
- (IBAction)increaseViewHeightOfPatientView:(id)sender {
    if ([_increasePatientViewButton.currentImage isEqual:[UIImage imageNamed:@"Dropdown-icon"]]) {
        _increasePatientView.hidden=NO;
        _increasePatientViewHeight.constant=_surgeryValueLabel.frame.size.height+120+_emailValueLabel.frame.size.height;
        [self ChangeIncreaseDecreaseButtonImage:_increasePatientViewButton];
    }
    else{
        _increasePatientView.hidden=YES;
        _increasePatientViewHeight.constant=0;
        [self ChangeIncreaseDecreaseButtonImage:_increasePatientViewButton];
    }
}
//increase the View Height of upload view
- (IBAction)upload:(id)sender {
    if ([_increaseUploadViewButton.currentImage isEqual:[UIImage imageNamed:@"Dropdown-icon"]]) {
        _uploadView.hidden=NO;
        if (uploadedImageArray.count>0) {
            _uploadViewHeigh.constant=uploadCellHeight+185;
            _uploadCollectionView.hidden=NO;
        }
        else  _uploadViewHeigh.constant=55;
        [self ChangeIncreaseDecreaseButtonImage:_increaseUploadViewButton];
    }
    else{
        _uploadView.hidden=YES;
        _uploadViewHeigh.constant=0;
        [self ChangeIncreaseDecreaseButtonImage:_increaseUploadViewButton];
    }
}
//save medical history
- (IBAction)saveMedicalHistory:(id)sender {
    if (![_medicalHistoryTextView.text isEqualToString:@""]) {
        [self getCurrentTimeAndDate:@"medical"];
        [_MedicaltableView reloadData];
        _medicalHistoryTextView.text=@"";
    }
    
}
//increase the View Height of Daignosis view
- (IBAction)increaseDiagnosisView:(id)sender {
    if ([_increaseDiagnosisViewButton.currentImage isEqual:[UIImage imageNamed:@"Dropdown-icon"]]) {
        _diagnosisView.hidden=NO;
        _diagnosisViewHeight.constant=218;
        [self ChangeIncreaseDecreaseButtonImage:_increaseDiagnosisViewButton];
    }
    else{
        _diagnosisView.hidden=YES;
        _diagnosisViewHeight.constant=0;
        [self ChangeIncreaseDecreaseButtonImage:_increaseDiagnosisViewButton];
    }
}
//record medical history
- (IBAction)recordMedicalHistory:(id)sender {
}
//increase the View Height of medical History view
- (IBAction)increaseViewHeightOfMedicalHistort:(id)sender {
    if ([_increaseMedicalViewButton.currentImage isEqual:[UIImage imageNamed:@"Dropdown-icon"]]) {
        _medicalHistoryView.hidden=NO;
        _medicalHistoryViewHeight.constant=250;
        [self ChangeIncreaseDecreaseButtonImage:_increaseMedicalViewButton];
    }
    else{
        _medicalHistoryView.hidden=YES;
        _medicalHistoryViewHeight.constant=0;
        [self ChangeIncreaseDecreaseButtonImage:_increaseMedicalViewButton];
    }
}
//save diagnosis textview
- (IBAction)saveDiagnosisTextViewValue:(id)sender {
    if (![_diagnosisTextView.text isEqualToString:@""]) {
        [self getCurrentTimeAndDate:@"Diagnosis"];
        [_diagnosisTableView reloadData];
        _diagnosisTextView.text=@"";
    }
}
//increase the View Height of setting view
- (IBAction)increaseSettingView:(id)sender {
    if ([_increasesettingViewButton.currentImage isEqual:[UIImage imageNamed:@"Dropdown-icon"]]) {
        _settingView.hidden=NO;
        _sittingcollectionViewHeight.constant=sittingCollectionViewHeight;
        _settingViewHeight.constant=sittingCollectionViewHeight+80;
        [self ChangeIncreaseDecreaseButtonImage:_increasesettingViewButton];
    }
    else{
        _settingView.hidden=YES;
        _settingViewHeight.constant=0;
        [self ChangeIncreaseDecreaseButtonImage:_increasesettingViewButton];
    }
}
//save treatment enclosure
- (IBAction)saveTreatmentEncloser:(id)sender {
    [self callApiToPostTreatment];
}
//cancel treatment enclosure
- (IBAction)closeTreatmentEncloser:(id)sender {
    if (![_treatmentEncloserTextView.text isEqualToString:@""]) {
        closeTreatMentAlert=[[UIAlertView alloc]initWithTitle:@"" message:@"Do you want to close Treatment?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes",@"No", nil];
        [closeTreatMentAlert show];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please Enter Treatment Closure Notes" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}
//alert view delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView==closeTreatMentAlert) {
        if (buttonIndex==0) {
            [self callAPIToCloseTreatmentOrUpdate:@"close"];
        }
    }
    else{
        if (buttonIndex==0) {
            [self.navigationController popViewControllerAnimated:YES];
            if (![_patientDetailModel.title isEqualToString:_treatmentNameTF.text]) {
                [self CallLoadTreatMentDelegate];
            }
        }
    }
}
//increase the View Height of patient view
- (IBAction)increaseuploadView:(id)sender {
    if ([_increaseUploadViewButton.currentImage isEqual:[UIImage imageNamed:@"Dropdown-icon"]]) {
        _uploadView.hidden=NO;
        _uploadViewHeigh.constant=250;
        [self ChangeIncreaseDecreaseButtonImage:_increaseUploadViewButton];
    }
    else{
        _uploadView.hidden=YES;
        _uploadViewHeigh.constant=0;
        [self ChangeIncreaseDecreaseButtonImage:_increaseUploadViewButton];
    }
}
//set button color
-(void)ChangeIncreaseDecreaseButtonImage:(UIButton*)btn{
    if ([btn.currentImage isEqual:[UIImage imageNamed:@"Dropdown-icon"]]) {
        [btn setImage:[UIImage imageNamed:@"Dropdown-icon-up"] forState:normal];
    }
    else  if ([btn.currentImage isEqual:[UIImage imageNamed:@"Dropdown-icon-up"]]) {
        [btn setImage:[UIImage imageNamed:@"Dropdown-icon"] forState:normal];
    }
}
//tableview Datasource method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_MedicaltableView | tableView==_diagnosisTableView)
        return 1;
    else return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView==_MedicaltableView) {
        return medicalTableListArray.count;
    }
    if (tableView==_allTaglistTableView) {
        return filterdTagListArray.count;
    }
    else
        return diagnosisTableListArray.count;
}
//table view delegate
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_allTaglistTableView) {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        UILabel *label=(UILabel*)[cell viewWithTag:10];
        SymptomTagModel *model=filterdTagListArray[indexPath.section];
        label.text=model.tagName;
        tableView.tableFooterView=[UIView new];
        return cell;
    }
    else{
        PatientSheetTableViewCell *cell;
        cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
            if (medicalTableListArray.count!=0 | diagnosisTableListArray.count!=0) {
                if (tableView==_MedicaltableView) {
                    NSDictionary *dict=medicalTableListArray[indexPath.section];
                    cell.dateValueLabel.text=dict[@"currentDateValue"];
                    cell.timeValueLabel.text=dict[@"currentTimeValue"];
                    cell.messageValueLabel.text=dict[@"message"];
                }
                else{
                    NSDictionary *dict=diagnosisTableListArray[indexPath.section];
                    cell.dateValueLabel.text=dict[@"currentDateValue"];
                    cell.timeValueLabel.text=dict[@"currentTimeValue"];
                    cell.messageValueLabel.text=dict[@"message"];
                }
            }
        tableView.tableFooterView=[UIView new];
        return cell;
    }
}
//height for row
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_diagnosisTableView) {
        if (diagnosisTableListArray.count>0) {
            if (indexPath.section==0) {
                return 30;
            }
            else{
                NSDictionary *dict= diagnosisTableListArray[indexPath.section-1];
                CGFloat i=_diagnosisView.frame.size.width-229;
                CGFloat labelHeight=[dict[@"message"] boundingRectWithSize:(CGSize){i,CGFLOAT_MAX }
                                                                   options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:13]} context:nil].size.height;
                if (labelHeight<25) {
                    return 30;
                }
                else  return labelHeight+15;
            }
        }
        else return 30;
    }
    else if(tableView==_MedicaltableView){
        if (medicalTableListArray.count>0) {
            if (indexPath.section==0) {
                return 30;
            }
            else{
                NSDictionary *dict= medicalTableListArray[indexPath.section-1];
                CGFloat i=_medicalHistoryView.frame.size.width-231;
                CGFloat labelHeight=[dict[@"message"] boundingRectWithSize:(CGSize){i,CGFLOAT_MAX }
                                                                   options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:13]} context:nil].size.height;
                if (labelHeight<25) {
                    return 30;
                }
                else  return labelHeight+15;
            }
        }
        else return 30;
    }
    else return 30;
}
//display cell
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_allTaglistTableView) {
        cell.backgroundColor=[UIColor whiteColor];
    }
    else cell.backgroundColor=[UIColor clearColor];
}
//select tableview cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_allTaglistTableView) {
        SymptomTagModel *model=filterdTagListArray[indexPath.section];
        _symptomtagTF.text=model.tagName;
        _allTaglistTableView.hidden=YES;
    }
}

//CollectionView datasource Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView== _sittingCollectionView) {
        return sittingCollectionArray.count;
    }
    else if (collectionView ==_uploadCollectionView) {
        return uploadedImageArray.count;
    }
    else
        return tagListArray.count;
}
//collectionview cell
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView==_sittingCollectionView) {
        SittingCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell" forIndexPath:indexPath];
        if (_sittingCollectionView.contentSize.width>_settingView .frame.size.width-100) {
            _sittingCollectionViewWidth.constant=_settingView.frame.size.width-100;
        }
        else _sittingCollectionViewWidth.constant=_sittingCollectionView.contentSize.width;
        CollectionViewTableViewCell *c=(CollectionViewTableViewCell*)[cell.headerView.headerTableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
        cell.layer.cornerRadius=8;
        SittingModelClass *model=sittingCollectionArray[indexPath.row];
        if ([model.completed isEqualToString:@"Yes"])
            c.switchImageView.image=[UIImage imageNamed:@"Button-on"];
        else c.switchImageView.image=[UIImage imageNamed:@"Button-off"];
        
        if (model.selectedHeader) {
            cell.headerViewHeight.constant=[cell.headerView increaseHeaderinHeaderTV:model];
        }
        else {
            cell.headerViewHeight.constant=[cell.headerView decreaseHeaderinHeaderTV:model];
        }
        cell.headerViewHeight.constant=cell.headerView.headerTableview.contentSize.height;       _sittingcollectionViewHeight.constant=sittingCollectionViewHeight+100;
        return cell;
    }
    else if (collectionView==_uploadCollectionView){
        UploadCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        if (uploadedImageArray.count>0) {
            if (_uploadCollectionView.contentSize.width>_uploadView .frame.size.width-14) {
                _uploadCollectionViewWidth.constant=_uploadView.frame.size.width-14;
            }
            else _uploadCollectionViewWidth.constant=_uploadCollectionView.contentSize.width;
            _uploadCollectionViewHeight.constant=uploadCellHeight+120;
            UploadModelClass *model=uploadedImageArray[indexPath.row];
            UIImage *img=model.imageName;
            cell.uploadImageView.image=img;
            cell.labelHeight.constant =[model.captionText boundingRectWithSize:(CGSize){136,CGFLOAT_MAX } options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:12]} context:nil].size.height+10;
            cell.captionLabel.text=model.captionText;
            cell.delegate=self;
        }
        return cell;
    }
    else {
        TagCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        SymptomTagModel *model=tagListArray[indexPath.row];
        cell.tagLabel.text=model.tagName;
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 6;
        cell.delegate=self;
        return cell;
    }
}
//collectionview cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==_sittingCollectionView) {
        return CGSizeMake(280,sittingCollectionViewHeight+100);
    }
    else if (collectionView==_uploadCollectionView)
    {
        return CGSizeMake(140,uploadCellHeight+120);
    }
    else{
        SymptomTagModel *model = tagListArray[indexPath.row];
        CGFloat width =  [model.tagName boundingRectWithSize:(CGSizeMake(NSIntegerMax, 40)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:12]} context:nil].size.width;
        return CGSizeMake(width+10,40);
    }
}
//spacing between cell
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
//collectionview cell display
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==_tagCollectionView) {
        cell.backgroundColor=[UIColor colorWithRed:0.55 green:0.59 blue:0.78 alpha:0.7];
    }
    if (collectionView==_sittingCollectionView) {
        cell.backgroundColor=[UIColor clearColor];
    }
}
//select collection view cell
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==_uploadCollectionView) {
        [self.navigationController pushViewController:attachView animated:YES];
        UploadModelClass *model=uploadedImageArray[indexPath.row];
        attachView.selectedImage=model.imageName;
        attachView.captionText=model.captionText;
        attachView.imageViewHeight.constant=self.view.frame.size.height-300;
        attachView.okButton.hidden=YES;
        attachView.CancelButton.hidden=YES;
        attachView.textViewEnabled=NO;
    }
}
//increase cell height of sitting
-(void)increaseCellHeight:(float)height withCell:(UICollectionViewCell*)cell withSelectedScanPoint:(NSArray*)selectedScanPointindexpath withHeader:(NSIndexPath*)headerIndex withNoteHeader:(NSIndexPath*)NoteIndex{
    NSIndexPath *indexpath1=[_sittingCollectionView indexPathForCell:cell];
    SittingModelClass *model=sittingCollectionArray[indexpath1.row];
    model.selectedHeader=YES;
    model.height=height;
    model.headerIndex=headerIndex;
    model.selectedScanPointIndexpath=selectedScanPointindexpath;
    model.noteIndex=NoteIndex;
    for (SittingModelClass *m in sittingCollectionArray) {
        sittingCollectionViewHeight=MAX(m.height,sittingCollectionViewHeight);
    }
    [_sittingCollectionView reloadData];
    [self.view layoutIfNeeded];
    _settingViewHeight.constant=sittingCollectionViewHeight+140;
}
//decrease sitting
-(void)decreaseCellHeight:(float)height withCell:(UICollectionViewCell*)cell withSelectedScanPoint:(NSArray*)selectedScanPointindexpath withHeader:(NSIndexPath*)headerIndex withNoteHeader:(NSIndexPath*)NoteIndex{
    sittingCollectionViewHeight=0.0;
    NSIndexPath *indexpath1=[_sittingCollectionView indexPathForCell:cell];
    SittingModelClass *model=sittingCollectionArray[indexpath1.row];
    model.height=height;
    model.headerIndex=headerIndex;
    model.noteIndex=NoteIndex;
    if (headerIndex!=nil) {
        model.selectedHeader=YES;
    }
    else model.selectedHeader=NO;
    model.selectedScanPointIndexpath=selectedScanPointindexpath;
    for (SittingModelClass *m in sittingCollectionArray) {
        sittingCollectionViewHeight=MAX(m.height,sittingCollectionViewHeight);
    }
    [_sittingCollectionView reloadData];
    [self.view layoutIfNeeded];
    _settingViewHeight.constant=sittingCollectionViewHeight+140;
}
//default values
-(void)defaultValue{
    _treatmentClosureLabelView.layer.cornerRadius=1;
    _treatmentclosureView.layer.cornerRadius=1;
    _settingLabelView.layer.cornerRadius=1;
    _settingView.layer.cornerRadius=1;
    _uploadLabelView.layer.cornerRadius=1;
    _uploadView.layer.cornerRadius=1;
    _patientLabelView.layer.cornerRadius=1;
    _increasePatientView.layer.cornerRadius=1;
    _medicalHistoryLabelView .layer.cornerRadius=1;
    _medicalHistoryView.layer.cornerRadius=1;
    _diagnosisLabelView.layer.cornerRadius=1;
    _diagnosisView.layer.cornerRadius=1;
    _symptomLabelView.layer.cornerRadius=1;
    _symptomView.layer.cornerRadius=1;
    [self setSymptomViewHeight];
    [constant spaceAtTheBeginigOfTextField:_symptomtagTF];
    [constant SetBorderForTextField:_symptomtagTF];
    [constant setFontForHeaders:_patientDetailLabel];
    [constant setFontForHeaders:_treatmentEnclosure];
    [constant setFontForHeaders:_settingLabel];
    [constant setFontForHeaders:_uploadLabel];
    [constant setFontForHeaders:_diagnosisLabel];
    [constant setFontForHeaders:_medicalHistoryLabel];
    [constant setFontForHeaders:_symptomtagLabel];
    _medicalHistoryView.hidden=YES;
    _medicalHistoryViewHeight.constant=0;
    _diagnosisView.hidden=YES;
    _diagnosisViewHeight.constant=0;
    _settingView.hidden=YES;
    _settingViewHeight.constant=0;
    _increasePatientViewHeight.constant=_surgeryValueLabel.frame.size.height+100;
    _increasePatientView.hidden=NO;
    [_increaseDiagnosisViewButton setImage:[UIImage imageNamed:@"Dropdown-icon"] forState:normal];
    [_increaseMedicalViewButton setImage:[UIImage imageNamed:@"Dropdown-icon"] forState:normal];
    [_increasePatientViewButton setImage:[UIImage imageNamed:@"Dropdown-icon-up"] forState:normal];
    [_increasesettingViewButton setImage:[UIImage imageNamed:@"Dropdown-icon"] forState:normal];
    _treatmentNameTF.attributedPlaceholder=[constant textFieldPatient:@"Title of the Treatment"];
    [constant spaceAtTheBeginigOfTextField:_treatmentNameTF];
    _treatmentEncloserTextView.layer.borderColor=[UIColor colorWithRed:0.682 green:0.718 blue:0.729 alpha:0.6].CGColor;
    _treatmentEncloserTextView.layer.borderWidth=1;
    _treatmentEncloserTextView.layer.cornerRadius=5;
    _medicalHistoryTextView.layer.borderColor=[UIColor colorWithRed:0.682 green:0.718 blue:0.729 alpha:0.6].CGColor;
    _medicalHistoryTextView.layer.borderWidth=1;
    _medicalHistoryTextView.layer.cornerRadius=5;
    _diagnosisTextView.layer.borderColor=[UIColor colorWithRed:0.682 green:0.718 blue:0.729 alpha:0.6].CGColor;
    _diagnosisTextView.layer.borderWidth=1;
    _diagnosisTextView.layer.cornerRadius=5;
    _medicalHistoryTextView.textContainerInset = UIEdgeInsetsMake(10, 10,10, 10);
    _diagnosisTextView.textContainerInset = UIEdgeInsetsMake(10, 10,10, 10);
    [constant setColorForLabel:_nameLabel];
    [constant setColorForLabel:_genderLabel];
    [constant setColorForLabel:_emailLabel];
    [constant setColorForLabel:_surgeryLabel];
    [constant setColorForLabel:_mobileLabel];
    [constant setColorForLabel:_ageLabel];
    [constant setColorForLabel:_dobLabel];
    [constant setColorForLabel:_tranfusion];
    [constant setFontForLabel:_genderValueLabel];
    [constant setFontForLabel:_emailValueLabel];
    [constant setFontForLabel:_nameValueLabel];
    [constant setFontForLabel:_surgeryValueLabel];
    [constant setFontForLabel:_ageValueLabel];
    [constant setFontForLabel:_dobValueLabel];
    [constant setFontForLabel:_mobileValueLabel];
    [constant setFontForLabel:_transfusionValueLabel];
    _uploadView.hidden=YES;
    _uploadViewHeigh.constant=0;
    [_increaseUploadViewButton setImage:[UIImage imageNamed:@"Dropdown-icon"] forState:normal];
    _symptomtagTF.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Add Symptom Tags"];
    
    _mobileValueLabel.text=_model.mobileNo;
    _nameValueLabel.text=_model.name;
    _ageValueLabel.text=_model.age;
    _dobValueLabel.text=_model.dob;
    _surgeryValueLabel.text=_model.surgeries;
    _transfusionValueLabel.text=_model.tranfusion;
    _genderValueLabel.text=_model.gender;
    _emailValueLabel.text=_model.emailId;
}
//change treatment textfield
-(void)changeTreatmentTF{
    if (_patientDetailModel.title!=nil) {
        _treatmentNameTF.text=_patientDetailModel.title;
        _treatmentNameTF.layer.borderWidth=0;
        [_treatmentButton setImage:[UIImage imageNamed:@"Edit-icon.png"] forState:normal];
        [constant setFontbold:_treatmentNameTF];
        _treatmentNameTF.enabled=NO;
        _treatmentButton.userInteractionEnabled=YES;
    }
    else{
        _treatmentNameTF.layer.borderWidth=1;
        _treatmentNameTF.layer.cornerRadius=5;
        _treatmentNameTF.layer.borderColor=[UIColor colorWithRed:0.557 green:0.733 blue:0.796 alpha:1].CGColor;
        _treatmentNameTF.attributedPlaceholder=[constant PatientSheetPlaceHolderText:@"Title of the Treatment"];
        _treatmentButton.userInteractionEnabled=NO;
        [_treatmentButton setImage:[UIImage imageNamed:@"Tick-icon1.png"] forState:normal];
        _treatmentNameTF.enabled=YES;
        [constant spaceAtTheBeginigOfTextField:_treatmentNameTF];
    }
}
//set symptom height
-(void)setSymptomViewHeight{
    _symptomTagViewHeight.constant=_tagCollectionView.contentSize.height+65;
}
//treatment button
- (IBAction)TreatmentButton:(id)sender {
    if (![_treatmentButton.currentImage isEqual:[UIImage imageNamed:@"Edit-icon.png"]]) {
        _treatmentNameTF.layer.borderWidth=0;
        [_treatmentButton setImage:[UIImage imageNamed:@"Edit-icon.png"] forState:normal];
        [constant setFontbold:_treatmentNameTF];
        _treatmentNameTF.enabled=NO;
    }
    else {
        _treatmentNameTF.layer.borderWidth=1;
        _treatmentNameTF.layer.cornerRadius=5;
        _treatmentNameTF.layer.borderColor=[UIColor lightGrayColor].CGColor;
        [_treatmentButton setImage:[UIImage imageNamed:@"Tick-icon1.png"] forState:normal];
        _treatmentNameTF.enabled=YES;
        [_treatmentNameTF becomeFirstResponder];
        [constant setFontSemibold:_treatmentNameTF];
    }
    
}
//Getting Current Date Time Values
-(void)getCurrentTimeAndDate:(NSString*)str{
    [formatter setDateFormat:@"dd-MMM-yyyy"];
    NSString *currentDate=[formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString *currentTime=[formatter stringFromDate:[NSDate date]];
    if ([str isEqualToString:@"medical"]) {
        NSDictionary *dict = @{@"currentDateValue":currentDate,@"currentTimeValue":currentTime,@"message":_medicalHistoryTextView.text};
        [medicalTableListArray addObject:dict];
    }
    else{
        NSDictionary *dict=@{@"currentDateValue":currentDate,@"currentTimeValue":currentTime,@"message":_diagnosisTextView.text};
        [diagnosisTableListArray addObject:dict];
    }
}
//take pic
- (IBAction)takePic:(id)sender {
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.sourceType=UIImagePickerControllerSourceTypeCamera;
    //  picker.mediaTypes = [UIImagePickerController  availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:picker animated:YES completion:nil];
    picker.delegate=self;
}
//take photo from library
- (IBAction)album:(id)sender {
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
    picker.delegate=self;
}
//image picker delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqual:@"public.image"]) {
        UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
        [self.navigationController pushViewController:attachView animated:YES];
        attachView.selectedImage=image;
        attachView.captionText=nil;
        attachView.textViewEnabled=YES;
        attachView.okButton.hidden=NO;
        attachView.CancelButton.hidden=NO;
        attachView.imageViewHeight.constant=350;
        attachView.delegate=self;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)selectedImage:(UIImage *)image withCaption:(NSString *)captionText{
    UploadModelClass *uploadModel=[[UploadModelClass alloc]init];
    uploadModel.imageName=image;
    uploadModel.captionText=captionText;
    [uploadedImageArray addObject:uploadModel];
    for (UploadModelClass *m in uploadedImageArray) {
        CGFloat labelHeight=[m.captionText boundingRectWithSize:(CGSize){136,CGFLOAT_MAX }
                                                        options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:12]} context:nil].size.height;
        uploadCellHeight=MAX(uploadCellHeight, labelHeight);
    }
    [_uploadCollectionView reloadData];
    [self.view layoutIfNeeded];
    _uploadCollectionView.hidden=NO;
    _uploadViewHeigh.constant=uploadCellHeight+185;
}
-(void)deleteCell:(id)cell{
    uploadCellHeight=0.0;
    NSIndexPath *index=[_uploadCollectionView indexPathForCell:cell];
    [uploadedImageArray removeObjectAtIndex:index.row];
    for (UploadModelClass *m in uploadedImageArray) {
        CGFloat labelHeight=[m.captionText boundingRectWithSize:(CGSize){136,CGFLOAT_MAX }
                                                        options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:12]} context:nil].size.height;
        uploadCellHeight=MAX(uploadCellHeight, labelHeight);
    }
    [_uploadCollectionView reloadData];
    [_scrollView layoutIfNeeded];
    if (uploadedImageArray.count==0) {
        _uploadViewHeigh.constant=55;
    }
    else _uploadViewHeigh.constant=uploadCellHeight+185;
}
-(void)deleteTagCell:(UICollectionViewCell *)cell{
    NSIndexPath *index=[_tagCollectionView indexPathForCell:cell];
    SymptomTagModel *model=tagListArray[index.row];
    [self callApiForDeleteTag:model];
    [_tagCollectionView reloadData];
    [_scrollView layoutIfNeeded];
    if (tagListArray.count==0) {
        _symptomTagViewHeight.constant=70;
    }
    else _symptomTagViewHeight.constant=_tagCollectionView.contentSize.height+65;
}
- (IBAction)gestureRecognize:(id)sender {
    [self.view endEditing:YES];
}
-(void)incrementSittingCell:(NSString *)completed{
    SittingModelClass *model=[[SittingModelClass alloc]init];
    model.height=128;
    model.selectedScanPointIndexpath=nil;
    model.completed=completed;
    model.noteIndex=nil;
    model.headerIndex=nil;
    [sittingCollectionArray addObject:model];
    for (SittingModelClass *m in sittingCollectionArray) {
        sittingCollectionViewHeight=MAX(sittingCollectionViewHeight, m.height);
    }
    _sittingcollectionViewHeight.constant=sittingCollectionViewHeight;
    [_sittingCollectionView reloadData];
    [self.view layoutIfNeeded];
    NSIndexPath *index=[NSIndexPath indexPathForRow:sittingCollectionArray.count-1 inSection:0];
    [_sittingCollectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    _settingViewHeight.constant=sittingCollectionViewHeight+130;
}
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    CGRect aRect = self.view.frame;
    CGRect frameOfActiveTextField = [activeField convertRect:activeField.bounds toView:self.scrollView];
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, frameOfActiveTextField.origin) ) {
        [self.scrollView scrollRectToVisible:frameOfActiveTextField animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets=UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    activeField=textField;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    _allTaglistTableView.hidden=YES;
    activeField=nil;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    activeField=textView;
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    activeField=nil;
}
//call api to delete tag
-(void)callApiForDeleteTag:(SymptomTagModel*)model
{
    NSString *url=[NSString stringWithFormat:@"%@%@%@",baseUrl,updateSymptomTag,model.tagCode];
    NSString *parameter=[NSString stringWithFormat:@"{\"Name\": \"%@\",\"Status\": false, \"UserID\": %@,\"Id\": %@,\"MethodType\":\"PUT\"}",model.tagName,_model.Id,model.tagId];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [postman put:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}
//tag textfield change
-(void)tagTextFieldChange{
    if (allTagListArray.count>0) {
        [filterdTagListArray removeAllObjects];
        NSMutableArray *ar=[[NSMutableArray alloc]init];
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"self CONTAINS[cd]%@",_symptomtagTF.text];
        for (SymptomTagModel *model in allTagListArray) {
            [ar addObject:model.tagName];
        }
        NSArray *array= [ar filteredArrayUsingPredicate:predicate];
        for (NSString *str in array) {
            for (SymptomTagModel *model in allTagListArray) {
                if ([model.tagName isEqualToString:str]) {
                    [filterdTagListArray addObject:model];
                }
            }
        }
        if (filterdTagListArray.count>0) {
            _allTaglistTableView.hidden=NO;
            _allTaglistTableView.layer.cornerRadius=5;
            _allTaglistTableView.layer.borderWidth=1;
            _allTaglistTableView.layer.borderColor=[UIColor lightGrayColor].CGColor;
            [_allTaglistTableView reloadData];
            if (_allTaglistTableView.contentSize.height>141) {
                _allTagListTableViewHeight.constant=141;
            }else _allTagListTableViewHeight.constant=_allTaglistTableView.contentSize.height;
        }
        else  _allTaglistTableView.hidden=YES;
    }
}
//textView Change
-(void)textViewDidChange:(UITextView *)textView{
    if (textView==_treatmentEncloserTextView) {
        if ([_treatmentEncloserTextView.text isEqualToString:@""]) {
            _addClosureNoteLabel.hidden=NO;
        }
        else _addClosureNoteLabel.hidden=YES;
    }
    if (textView==_medicalHistoryTextView) {
        if ([_medicalHistoryTextView.text isEqualToString:@""]) {
            _medicalNoteLabel.hidden=NO;
        }
        else _medicalNoteLabel.hidden=YES;
    }
    if (textView==_diagnosisTextView) {
        if ([_diagnosisTextView.text isEqualToString:@""]) {
            _diagnosisNoteLabel.hidden=NO;
        }
        else _diagnosisNoteLabel.hidden=YES;
    }
}
//call api to post treatment
-(void)callApiToPostTreatment{
    if (_patientDetailModel.title==nil){
        [self callPostTreatment];
    }else {
        if (treatmentID==nil) {
            [self callPostTreatment];
        }
        else [self callAPIToCloseTreatmentOrUpdate:@"update"];
    }
}
//call post method
-(void)callPostTreatment{
    NSString *parameter =[self getParameterForSaveORCloseOrUpdateTreatment:@"true" withTreatmentCompleted:@"false" withMethodType:@"POST"];
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,addTreatmentUrl];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processResponseObject:responseObject];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}
//process post response object
-(void)processResponseObject:(id)responseObject{
    NSDictionary *dict=responseObject;
    if ([dict[@"Success"] intValue]==1) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:dict[@"Message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    else {
        [self MBProgressMessage:dict[@"Message"]];
    }
}
//call api to get detail of treatment
-(void)callApiTogetAllDetailOfTheTreatment{
    NSString *url=[NSString stringWithFormat:@"%@%@%@",baseUrl,getTreatmentDetail,_patientDetailModel.code];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [postman get:url withParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processResponseObjectToGetTreatmentDetail:responseObject];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
//process object to get detail of treatment
-(void)processResponseObjectToGetTreatmentDetail:(id)responseObject{
    [tagListArray removeAllObjects];
    [medicalTableListArray removeAllObjects];
    [diagnosisTableListArray removeAllObjects];
    NSDictionary *dict=responseObject;
    if ([dict[@"Success"] intValue]==1) {
        NSDictionary *dict1=dict[@"ViewModels"];
            treatmentID=dict1[@"ID"];
            NSArray *tagArray=[dict1[@"SymptomTagCodes"] componentsSeparatedByString:@","];
            NSLog(@"%@",tagArray);
            if (![dict1[@"JSON"] isKindOfClass:[NSNull class]]) {
                NSData *jsonData = [dict1[@"JSON"] dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
                NSArray *medicalArray=jsonDict[@"MedicalHistory"];
                NSArray *diagnosisArray=jsonDict[@"Diagnosis"];
                _treatmentEncloserTextView.text=jsonDict[@"TreatmentClosure"];
                if ([_treatmentEncloserTextView.text isEqualToString:@""]) {
                    _addClosureNoteLabel.hidden=NO;
                }else _addClosureNoteLabel.hidden=YES;
                for (NSString *str in medicalArray) {
                    if (![str isEqualToString:@""]) {
                        NSArray *ar=[str componentsSeparatedByString:@"/"];
                        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:ar[0],@"message",ar[1],@"currentDateValue",ar[2],@"currentTimeValue",nil];
                        [medicalTableListArray addObject:dict];
                    }
                }
                [_MedicaltableView reloadData];
                for (NSString *str in diagnosisArray) {
                    if (![str isEqualToString:@""]) {
                        NSArray *ar=[str componentsSeparatedByString:@"/"];
                        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:ar[0],@"message",ar[1],@"currentDateValue",ar[2],@"currentTimeValue",nil];
                        [diagnosisTableListArray addObject:dict];
                    }
                }
                [_diagnosisTableView reloadData];
            }
    }
   NSString *str=[self getParameterForSaveORCloseOrUpdateTreatment:@"" withTreatmentCompleted:@"" withMethodType:@""];
    NSLog(@"%@",str);
}
//Close api to close
-(void)callAPIToCloseTreatmentOrUpdate:(NSString*)closeOrUpdate{
    NSString *url=[NSString stringWithFormat:@"%@%@%@",baseUrl,closeTreatmentDetail,treatmentID];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *parameter=@"";
    if ([closeOrUpdate isEqualToString:@"close"]) {
        parameter =[self getParameterForSaveORCloseOrUpdateTreatment:@"true" withTreatmentCompleted:@"true" withMethodType:@"PUT"];
    }
    else  parameter=[self getParameterForSaveORCloseOrUpdateTreatment:@"true" withTreatmentCompleted:@"false" withMethodType:@"PUT"];
    [postman put:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([closeOrUpdate isEqualToString:@"close"]) {
            [self processCloseTreatment:responseObject withMessage:@"Closed successfully"];
        }else  [self processCloseTreatment:responseObject withMessage:@"Updated successfully"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
//Process Close treatment
-(void)processCloseTreatment:(id)responseObject withMessage:(NSString*)msg{
    NSDictionary *dict=responseObject;
    if ([dict[@"Success"]intValue]==1) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }else  [self MBProgressMessage:dict[@"Message"]];
}
//set parameter for treatment api.
-(NSString*)getParameterForSaveORCloseOrUpdateTreatment:(NSString*)status withTreatmentCompleted:(NSString*)treatmentComplete withMethodType:(NSString*)type{
    NSUserDefaults *defaultValues=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *jsondict=[[NSMutableDictionary alloc]init];
    if (medicalTableListArray.count>0) {
        NSMutableArray *medicalText=[[NSMutableArray alloc]init];
        for (NSDictionary *dict in medicalTableListArray) {
            NSString *str=[NSString stringWithFormat:@"%@/%@/%@",dict[@"message"],dict[@"currentDateValue"],dict[@"currentTimeValue"]];
            [medicalText addObject:str];
        }
        jsondict[@"MedicalHistory"]=medicalText;
    }else{
        NSArray *medicalText=@[@""];
        jsondict[@"MedicalHistory"]=medicalText;
    }
    if (diagnosisTableListArray.count>0) {
        NSMutableArray *medicalText=[[NSMutableArray alloc]init];
        for (NSDictionary *dict in diagnosisTableListArray) {
            NSString *str=[NSString stringWithFormat:@"%@/%@/%@",dict[@"message"],dict[@"currentDateValue"],dict[@"currentTimeValue"]];
            [medicalText addObject:str];
        }
        jsondict[@"Diagnosis"]=medicalText;
    }else{
        NSArray *medicalText=@[@""];
        jsondict[@"Diagnosis"]=medicalText;
    }
    jsondict[@"TreatmentClosure"]=_treatmentEncloserTextView.text;
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:jsondict options:kNilOptions error:nil];
    NSString *treatmentRequest = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
    NSMutableDictionary *treatmentRequestDict=[[NSMutableDictionary alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr=[formatter stringFromDate:[NSDate date]];
    treatmentRequestDict[@"TreatmentRequestDate"]=dateStr;
    treatmentRequestDict[@"IsTreatmentCompleted"]=treatmentComplete;
    treatmentRequestDict[@"PatientId"]=_model.Id;
    treatmentRequestDict[@"DoctorId"]=[defaultValues valueForKey:@"Id"];
    NSString *symptomtag=@"";
    if (tagListArray.count>0) {
        for (SymptomTagModel *model in tagListArray) {
            NSString *tagStr=[NSString stringWithFormat:@"%@,",model.tagCode];
            symptomtag=[symptomtag stringByAppendingString:tagStr];
        }
    }
    treatmentRequestDict[@"SymptomTagCodes"]=symptomtag;
    treatmentRequestDict[@"Title"]=_treatmentNameTF.text;
    treatmentRequestDict[@"Status"]=status;
    treatmentRequestDict[@"CompanyCode"]=@"A0I7LV";
    treatmentRequestDict[@"JSON"]=treatmentRequest;
    if ([type isEqualToString:@""]) {
        passingDictToSittingVc=treatmentRequestDict;
    }
    NSData *parameterData = [NSJSONSerialization dataWithJSONObject:treatmentRequestDict options:kNilOptions error:nil];
    NSString *treatmentRequestStr = [[NSString alloc] initWithData:parameterData encoding:NSUTF8StringEncoding];
    NSString *parameter=[NSString stringWithFormat:@"{\"MethodType\": \"%@\", \"Id\": \"0\",\"TreatmentRequest\":%@}",type,treatmentRequestStr];
    return parameter;
}
//add symptomTag
-(void)callAPIforAddSymptomTag{
    NSString *str=@"";
    for (SymptomTagModel *model in allTagListArray) {
        if ([model.tagName isEqualToString:_symptomtagTF.text]) {
            [tagListArray addObject:model];
            str=@"done";
            [_tagCollectionView reloadData];
            [self.view layoutIfNeeded];
            _collectionViewHeight.constant=_tagCollectionView.contentSize.height;
            [self setSymptomViewHeight];
            _symptomtagTF.text=@"";
        }
    }
    if ([str isEqualToString:@""]) {
        NSString *url=[NSString stringWithFormat:@"%@%@%@",baseUrl,addSymptomTag,_model.Id];
        NSString *parameter=[NSString stringWithFormat:@"{\"Name\":\"%@\",\"Status\": true,\"UserID\": %@,\"MethodType\": \"POST\"}",_symptomtagTF.text,_model.Id];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processResponseObjectOfAddTag:responseObject];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }
}
//process object
-(void)processResponseObjectOfAddTag:(id)responseObject{
    NSDictionary *dict=responseObject;
    if ([dict[@"Success"] intValue]==1) {
        NSDictionary *dict1=dict[@"ViewModel"];
        if ([dict1[@"Status"] intValue]==1) {
            SymptomTagModel *model=[[SymptomTagModel alloc]init];
            model.tagCode=dict1[@"Code"];
            model.tagId=dict1[@"Id"];
            model.tagName=dict1[@"Name"];
            [tagListArray addObject:model];
        }
        [_tagCollectionView reloadData];
        [self.view layoutIfNeeded];
        _collectionViewHeight.constant=_tagCollectionView.contentSize.height;
        [self setSymptomViewHeight];
        _symptomtagTF.text=@"";
    }
    else{
        [self MBProgressMessage:dict[@"Message"]];
    }
}
//MBProgress message
-(void)MBProgressMessage:(NSString*)message{
    MBProgressHUD *hubHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hubHUD.mode=MBProgressHUDModeText;
    hubHUD.labelText=message;
    hubHUD.labelFont=[UIFont systemFontOfSize:15];
    hubHUD.margin=20.f;
    hubHUD.yOffset=150.f;
    hubHUD.removeFromSuperViewOnHide = YES;
    [hubHUD hide:YES afterDelay:1];
}
-(void)CallLoadTreatMentDelegate{
    [self.delegate loadTreatment];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"sitting"]) {
        SWRevealViewController *revealVC=segue.destinationViewController;
        SittingViewController *sittingVC=[self.storyboard instantiateViewControllerWithIdentifier:@"SittingViewController"];
        [revealVC setFrontViewController:sittingVC];
        sittingVC.sectionName=@"";
        sittingVC.SortType=@"";
    }
}
@end
