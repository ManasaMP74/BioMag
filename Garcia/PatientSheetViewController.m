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
@interface PatientSheetViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UITextViewDelegate,deleteCell,deleteTagCell,selectedImage,cellHeight>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *genderLabel;
@property (strong, nonatomic) IBOutlet UILabel *martiralStatus;
@property (strong, nonatomic) IBOutlet UILabel *dobLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *genderValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *mariedValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *dobValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressValueLabel;
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
@property (strong, nonatomic) IBOutlet UITextField *treatmentNameTF;
@property (strong, nonatomic) IBOutlet UILabel *treatmentEnclosure;
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
    float sittingCollectionViewHeight,uploadCellHeight;
    AttachmentViewController *attachView;
    UIView *activeField;
    NSMutableArray *uploadedImageArray,*sittingCollectionArray;
    SettingView *sectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    sittingCollectionViewHeight=0.0,uploadCellHeight=0.0;
    constant=[[Constant alloc]init];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background-Image-02.jpg"]]];
    self.title=@"Patient Sheet";
    tagListArray=[[NSMutableArray alloc]init];
    [_treatmentNameTF addTarget:self action:@selector(enableAndDisableTreatmenyName) forControlEvents:UIControlEventEditingChanged];
    diagnosisTableListArray=[[NSMutableArray alloc]init];
    medicalTableListArray=[[NSMutableArray alloc]init];
    uploadedImageArray=[[NSMutableArray alloc]init];
    sittingCollectionArray=[[NSMutableArray alloc]init];
     [self defaultValue];
    [self registerForKeyboardNotifications];
    [self navigationItemMethod];
    attachView=[self.storyboard instantiateViewControllerWithIdentifier:@"AttachmentViewController"];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self changeTreatmentTF];
    self.navigationItem.hidesBackButton=YES;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_sittingCollectionView reloadData];
}
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
-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)popToViewController{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)enableAndDisableTreatmenyName{
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
    if ([_increasePatientViewButton.currentImage isEqual:[UIImage imageNamed:@"Button-Collapse"]]) {
        _increasePatientView.hidden=NO;
        _increasePatientViewHeight.constant=_addressLabel.frame.size.height+100;
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
    if ([_increaseUploadViewButton.currentImage isEqual:[UIImage imageNamed:@"Button-Collapse"]]) {
        _uploadView.hidden=NO;
        if (uploadedImageArray.count>0) {
            _uploadViewHeigh.constant=210;
            _uploadCollectionView.hidden=NO;
        }
        else  _uploadViewHeigh.constant=69;
        [self ChangeIncreaseDecreaseButtonImage:_increaseUploadViewButton];
    }
    else{
        _uploadView.hidden=YES;
        _uploadViewHeigh.constant=0;
        [self ChangeIncreaseDecreaseButtonImage:_increaseUploadViewButton];
    }
}
- (IBAction)saveMedicalHistory:(id)sender {
    if (![_medicalHistoryTextView.text isEqualToString:@""]) {
        [self getCurrentTimeAndDate:@"medical"];
        [_MedicaltableView reloadData];
        _medicalHistoryTextView.text=@"";
    }
    
}
//increase the View Height of Daignosis view
- (IBAction)increaseDiagnosisView:(id)sender {
    if ([_increaseDiagnosisViewButton.currentImage isEqual:[UIImage imageNamed:@"Button-Collapse"]]) {
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
- (IBAction)recordMedicalHistory:(id)sender {
}
//increase the View Height of medical History view
- (IBAction)increaseViewHeightOfMedicalHistort:(id)sender {
    if ([_increaseMedicalViewButton.currentImage isEqual:[UIImage imageNamed:@"Button-Collapse"]]) {
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
- (IBAction)saveDiagnosisTextViewValue:(id)sender {
    if (![_diagnosisTextView.text isEqualToString:@""]) {
        [self getCurrentTimeAndDate:@"Diagnosis"];
        [_diagnosisTableView reloadData];
        _diagnosisTextView.text=@"";
    }
}
//increase the View Height of setting view
- (IBAction)increaseSettingView:(id)sender {
    if ([_increasesettingViewButton.currentImage isEqual:[UIImage imageNamed:@"Button-Collapse"]]) {
        _settingView.hidden=NO;
        _sittingcollectionViewHeight.constant=_sittingCollectionView.contentSize.height;
        _settingViewHeight.constant=_sittingCollectionView.contentSize.height+30;
        [self ChangeIncreaseDecreaseButtonImage:_increasesettingViewButton];
    }
    else{
        _settingView.hidden=YES;
        _settingViewHeight.constant=0;
        [self ChangeIncreaseDecreaseButtonImage:_increasesettingViewButton];
    }
}
- (IBAction)saveTreatmentEncloser:(id)sender {
}
- (IBAction)closeTreatmentEncloser:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//increase the View Height of patient view
- (IBAction)increaseuploadView:(id)sender {
    if ([_increaseUploadViewButton.currentImage isEqual:[UIImage imageNamed:@"Button-Collapse"]]) {
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
    if ([btn.currentImage isEqual:[UIImage imageNamed:@"Button-Collapse"]]) {
        [btn setImage:[UIImage imageNamed:@"Button-Expand"] forState:normal];
    }
    else  if ([btn.currentImage isEqual:[UIImage imageNamed:@"Button-Expand"]]) {
        [btn setImage:[UIImage imageNamed:@"Button-Collapse"] forState:normal];
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
        return medicalTableListArray.count+1;
    }
    else
        return diagnosisTableListArray.count+1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PatientSheetTableViewCell *cell;
        cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
    if (indexPath.section>0) {
        if (medicalTableListArray.count!=0 | diagnosisTableListArray.count!=0) {
            if (tableView==_MedicaltableView) {
                NSDictionary *dict=medicalTableListArray[indexPath.section-1];
                cell.dateValueLabel.text=dict[@"currentDateValue"];
                cell.timeValueLabel.text=dict[@"currentTimeValue"];
                cell.messageValueLabel.text=dict[@"message"];
            }
            else{
                NSDictionary *dict=diagnosisTableListArray[indexPath.section-1];
                cell.dateValueLabel.text=dict[@"currentDateValue"];
                cell.timeValueLabel.text=dict[@"currentTimeValue"];
                cell.messageValueLabel.text=dict[@"message"];
            }
    }
}
    tableView.tableFooterView=[UIView new];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 25;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor clearColor];
}
//CollectionView datasource Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView== _sittingCollectionView) {
        return sittingCollectionArray.count;
    }
    else if (collectionView ==_uploadCollectionView) {
        NSLog(@"%d",uploadedImageArray.count);
        return uploadedImageArray.count;
    }
    else
        return tagListArray.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView==_sittingCollectionView) {
        SittingCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell" forIndexPath:indexPath];
        cell.delegate=self;
        if (_sittingCollectionView.contentSize.width>_settingView .frame.size.width-100) {
            _sittingCollectionViewWidth.constant=_settingView.frame.size.width-100;
        }
        else _sittingCollectionViewWidth.constant=_sittingCollectionView.contentSize.width;
        cell.sittingLabel.text=[NSString stringWithFormat:@"%@%d",@"Sitting #",indexPath.row+1];
         CollectionViewTableViewCell *c=(CollectionViewTableViewCell*)[cell.headerView.headerTableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
        cell.layer.cornerRadius=8;
        
        SittingModelClass *model=sittingCollectionArray[indexPath.row];
        if ([model.completed isEqualToString:@"Yes"])
            c.switchImageView.image=[UIImage imageNamed:@"Button-on"];
        else c.switchImageView.image=[UIImage imageNamed:@"Button-off"];
       
        if (model.selectedHeader) {
            cell.headerViewHeight.constant=[cell.headerView increaseHeaderinHeaderTV:model.selectedScanPointIndexpath];
        }
        else {
           cell.headerViewHeight.constant=[cell.headerView decreaseHeaderinHeaderTV:model.selectedScanPointIndexpath];
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
            _uploadCollectionViewHeight.constant=uploadCellHeight+150;
            UploadModelClass *model=uploadedImageArray[indexPath.row];
            UIImage *img=model.imageName;
            cell.uploadImageView.image=img;
            cell.labelHeight.constant =[model.captionText boundingRectWithSize:(CGSize){136,CGFLOAT_MAX } options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:12]} context:nil].size.height+10;
                   NSLog(@"%f %f",cell.labelHeight.constant,uploadCellHeight);
            cell.captionLabel.text=model.captionText;
            cell.delegate=self;
        }
        return cell;
        }
        else {
            TagCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
            cell.tagLabel.text=tagListArray[indexPath.row];
            cell.layer.masksToBounds = YES;
            cell.layer.cornerRadius = 6;
             cell.delegate=self;
            return cell;
        }
}
-(void)increaseCellHeight:(float)height withCell:(UICollectionViewCell*)cell withSelectedScanPoint:(NSArray*)selectedScanPointindexpath{
    NSIndexPath *indexpath1=[_sittingCollectionView indexPathForCell:cell];
    SittingModelClass *model=sittingCollectionArray[indexpath1.row];
    model.selectedHeader=YES;
    model.height=height;
    model.selectedScanPointIndexpath=selectedScanPointindexpath;
    for (SittingModelClass *m in sittingCollectionArray) {
        sittingCollectionViewHeight=MAX(m.height,sittingCollectionViewHeight);
    }
    [_sittingCollectionView reloadData];
    [self.view layoutIfNeeded];
    _settingViewHeight.constant=sittingCollectionViewHeight+140;
}
-(void)decreaseCellHeight:(float)height withCell:(UICollectionViewCell*)cell withSelectedScanPoint:(NSArray*)selectedScanPointindexpath{
    sittingCollectionViewHeight=0.0;
    NSIndexPath *indexpath1=[_sittingCollectionView indexPathForCell:cell];
    SittingModelClass *model=sittingCollectionArray[indexpath1.row];
    model.height=height;
    if (selectedScanPointindexpath.count>0) {
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
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
        if (collectionView==_sittingCollectionView) {
                return CGSizeMake(280,sittingCollectionViewHeight+100);
        }
        else if (collectionView==_uploadCollectionView)
        {
            return CGSizeMake(140,uploadCellHeight+150);
        }
        else{
            NSString *text = tagListArray[indexPath.row];
//               CGFloat width =[text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName, nil]].width;
            CGFloat width =  [text boundingRectWithSize:(CGSizeMake(NSIntegerMax, 40)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:12]} context:nil].size.width;
          return CGSizeMake(width+10,40);
        }
    }
    
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
        return 10;
}
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==_tagCollectionView) {
        cell.backgroundColor=[UIColor colorWithRed:0.55 green:0.59 blue:0.78 alpha:0.7];
    }
    if (collectionView==_sittingCollectionView) {
        cell.backgroundColor=[UIColor clearColor];
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==_uploadCollectionView) {
        [self.navigationController pushViewController:attachView animated:YES];
        UploadModelClass *model=uploadedImageArray[indexPath.row];
        attachView.selectedImage=model.imageName;
        attachView.captionText=model.captionText;
        attachView.okButton.hidden=YES;
        attachView.CancelButton.hidden=YES;
        attachView.textViewEnabled=NO;
    }
}
//Add tag
    - (IBAction)addTag:(id)sender {
        if (![_symptomtagTF.text isEqualToString:@""]) {
            [tagListArray addObject:_symptomtagTF.text];
            NSLog(@"%lu",(unsigned long)tagListArray.count);
            [_tagCollectionView reloadData];
            [self.view layoutIfNeeded];
            _collectionViewHeight.constant=_tagCollectionView.contentSize.height;
            [self setSymptomViewHeight];
            _symptomtagTF.text=@"";
        }
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
        _increasePatientViewHeight.constant=_addressLabel.frame.size.height+100;
        _increasePatientView.hidden=NO;
        [_increaseDiagnosisViewButton setImage:[UIImage imageNamed:@"Button-Collapse"] forState:normal];
        [_increaseMedicalViewButton setImage:[UIImage imageNamed:@"Button-Collapse"] forState:normal];
        [_increasePatientViewButton setImage:[UIImage imageNamed:@"Button-Expand"] forState:normal];
        [_increasesettingViewButton setImage:[UIImage imageNamed:@"Button-Collapse"] forState:normal];
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
        [constant setColorForLabel:_addressLabel];
        [constant setColorForLabel:_ageLabel];
        [constant setColorForLabel:_dobLabel];
        [constant setColorForLabel:_martiralStatus];
        [constant setFontForLabel:_genderValueLabel];
        [constant setFontForLabel:_emailValueLabel];
        [constant setFontForLabel:_nameValueLabel];
        [constant setFontForLabel:_addressValueLabel];
        [constant setFontForLabel:_ageValueLabel];
        [constant setFontForLabel:_dobValueLabel];
        [constant setFontForLabel:_mariedValueLabel];
        _uploadView.hidden=YES;
        _uploadViewHeigh.constant=0;
         [_increaseUploadViewButton setImage:[UIImage imageNamed:@"Button-Collapse"] forState:normal];
    }
    -(void)changeTreatmentTF{
        if (![_TitleName isEqual:@""]) {
            _treatmentNameTF.text=_TitleName;
            _treatmentNameTF.layer.borderWidth=0;
            [_treatmentButton setImage:[UIImage imageNamed:@"Edit"] forState:normal];
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
            [_treatmentButton setImage:[UIImage imageNamed:@"Button-Tick"] forState:normal];
            _treatmentNameTF.enabled=YES;
            [constant spaceAtTheBeginigOfTextField:_treatmentNameTF];
        }
    }
    -(void)setSymptomViewHeight{
        _symptomTagViewHeight.constant=_tagCollectionView.contentSize.height+65;
    }
    - (IBAction)TreatmentButton:(id)sender {
        if (![_treatmentButton.currentImage isEqual:[UIImage imageNamed:@"Edit"]]) {
            _treatmentNameTF.layer.borderWidth=0;
            [_treatmentButton setImage:[UIImage imageNamed:@"Edit"] forState:normal];
            [constant setFontbold:_treatmentNameTF];
            _treatmentNameTF.enabled=NO;
        }
        else {
            _treatmentNameTF.layer.borderWidth=1;
            _treatmentNameTF.layer.cornerRadius=5;
            _treatmentNameTF.layer.borderColor=[UIColor lightGrayColor].CGColor;
            [_treatmentButton setImage:[UIImage imageNamed:@"Button-Tick"] forState:normal];
            _treatmentNameTF.enabled=YES;
            [constant setFontSemibold:_treatmentNameTF];
        }
        
    }
    //Getting Current Date Time Values
    -(void)getCurrentTimeAndDate:(NSString*)str{
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"dd-MMM-yyyy"];
        NSString *currentDate=[formatter stringFromDate:[NSDate date]];
        [formatter setDateFormat:@"HH:mm:ss"];
        NSString *currentTime=[formatter stringFromDate:[NSDate date]];
        if ([str isEqualToString:@"medical"]) {
            NSDictionary *dict=@{@"currentDateValue":currentDate,@"currentTimeValue":currentTime,@"message":_medicalHistoryTextView.text};
            [medicalTableListArray addObject:dict];
        }
        else{
            NSDictionary *dict=@{@"currentDateValue":currentDate,@"currentTimeValue":currentTime,@"message":_diagnosisTextView.text};
            [diagnosisTableListArray addObject:dict];
        }
    }
    - (IBAction)takePic:(id)sender {
        UIImagePickerController *picker=[[UIImagePickerController alloc]init];
        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
      //  picker.mediaTypes = [UIImagePickerController  availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:picker animated:YES completion:nil];
        picker.delegate=self;
    }
    - (IBAction)album:(id)sender {
        UIImagePickerController *picker=[[UIImagePickerController alloc]init];
        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
        picker.delegate=self;
    }
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
    _uploadViewHeigh.constant=uploadCellHeight+250;
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
        _uploadViewHeigh.constant=69;
    }
    else _uploadViewHeigh.constant=uploadCellHeight+250;
}
-(void)deleteTagCell:(UICollectionViewCell *)cell{
 NSIndexPath *index=[_tagCollectionView indexPathForCell:cell];
    [tagListArray removeObjectAtIndex:index.row];
    NSLog(@"%lu",(unsigned long)tagListArray.count);
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
    - (IBAction)addSitting:(id)sender {
        //if(sectionView==nil)
            sectionView=[[SettingView alloc]initWithFrame:CGRectMake(150, 140,500,330)];
        sectionView.delegate=self;
        [sectionView alphaViewInitialize];
}
-(void)incrementSittingCell:(NSString *)completed{
            SittingModelClass *model=[[SittingModelClass alloc]init];
            model.height=128;
            model.selectedScanPointIndexpath=nil;
            model.completed=completed;
            [sittingCollectionArray addObject:model];
    for (SittingModelClass *m in sittingCollectionArray) {
        sittingCollectionViewHeight=MAX(sittingCollectionViewHeight, m.height);
    }
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
        NSLog(@"%@, ",NSStringFromCGRect(activeField.frame));
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

-(void)deleteSittingCell:(UICollectionViewCell *)cell{
    sittingCollectionViewHeight=0;
    NSIndexPath *index=[_sittingCollectionView indexPathForCell:cell];
    [sittingCollectionArray removeObjectAtIndex:index.row];
    if (sittingCollectionArray.count>0) {
        for (SittingModelClass *m in sittingCollectionArray) {
            sittingCollectionViewHeight=MAX(sittingCollectionViewHeight, m.height);
        }
        [_sittingCollectionView reloadData];
    }
    else    _sittingCollectionViewWidth.constant=0;
    _settingViewHeight.constant=sittingCollectionViewHeight+130;
}
-(void)editSittingCell:(UICollectionViewCell *)cell{
  NSIndexPath *index=[_sittingCollectionView indexPathForCell:cell];
    [sittingCollectionArray removeObjectAtIndex:index.row];
    if(sectionView==nil)
        sectionView=[[SettingView alloc]initWithFrame:CGRectMake(150, 140,500,330)];
    sectionView.delegate=self;
    sectionView.dummyData=@[[NSString stringWithFormat:@"%@%d",@"Sitting #",index.row+1]];
    [sectionView alphaViewInitialize];
}
@end
