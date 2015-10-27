#import "PatientSheetViewController.h"
#import "Constant.h"
#import "PatientSheetTableViewCell.h"
#import "SettingView.h"
@interface PatientSheetViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
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
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *symptomTagViewHeight;
@end

@implementation PatientSheetViewController
{
    Constant *constant;
    SettingView *setingView;
    NSMutableArray *tagListArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    constant=[[Constant alloc]init];
    [self defaultValue];
   [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background-Image-02.jpg"]]];
    self.title=@"Patient Sheet";
    tagListArray=[[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//increase the View Height of patient view
- (IBAction)increaseViewHeightOfPatientView:(id)sender {
    if ([_increasePatientViewButton.currentImage isEqual:[UIImage imageNamed:@"Button-Collapse"]]) {
        _increasePatientView.hidden=NO;
        _increasePatientViewHeight.constant=110;
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
        _uploadViewHeigh.constant=99;
        [self ChangeIncreaseDecreaseButtonImage:_increaseUploadViewButton];
    }
    else{
        _diagnosisView.hidden=YES;
        _diagnosisViewHeight.constant=0;
        [self ChangeIncreaseDecreaseButtonImage:_increaseUploadViewButton];
    }
}
- (IBAction)saveMedicalHistory:(id)sender {

}
//increase the View Height of Daignosis view
- (IBAction)increaseDiagnosisView:(id)sender {
    if ([_increaseDiagnosisViewButton.currentImage isEqual:[UIImage imageNamed:@"Button-Collapse"]]) {
        _diagnosisView.hidden=NO;
        _diagnosisViewHeight.constant=250;
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
}
//increase the View Height of setting view
- (IBAction)increaseSettingView:(id)sender {
    if ([_increasesettingViewButton.currentImage isEqual:[UIImage imageNamed:@"Button-Collapse"]]) {
        _settingView.hidden=NO;
        _settingViewHeight.constant=111;
        [self ChangeIncreaseDecreaseButtonImage:_increasesettingViewButton];
    }
    else{
        _settingView.hidden=YES;
        _settingViewHeight.constant=0;
        [self ChangeIncreaseDecreaseButtonImage:_increasesettingViewButton];
    }
}
//setting Button
- (IBAction)buttonSetting:(id)sender {
if(setingView==nil)
    setingView=[[SettingView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x-50, 500,311, 222)];
    [setingView alphaViewInitialize];
}
- (IBAction)saveTreatmentEncloser:(id)sender {
}
- (IBAction)closeTreatmentEncloser:(id)sender {
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
//tableview Datasource method
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PatientSheetTableViewCell *cell;
    if (indexPath.row==0) {
        cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
   else cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
     [constant setFontForLabel:cell.dateLabel];
     [constant setFontForLabel:cell.time];
     [constant setFontForLabel:cell.messageLabel];
     [constant setFontForLabel:cell.timeValueLabel];
     [constant setFontForLabel:cell.dateValueLabel];
     [constant setFontForLabel:cell.messageValueLabel];
    return cell;
}
//CollectionView datasource Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return tagListArray.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(cell.frame.origin.x+3,cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)];
    NSLog(@"%f",label.frame.size.width);
    label.font=[UIFont systemFontOfSize:12];
    label.textAlignment=1;
    label.text=tagListArray[indexPath.row];
    [cell addSubview:label];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 6;
    _collectionViewHeight.constant=_collectionView.contentSize.height;
    [self setSymptomViewHeight];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    UILabel *label=[[UILabel alloc]init];
    label.text=tagListArray[indexPath.row];
    CGFloat width =[label.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName, nil]].width;
       NSLog(@"%f",width);
    return CGSizeMake(width+25,30);
}
//Add tag
- (IBAction)addTag:(id)sender {
    if (![_symptomtagTF.text isEqualToString:@""]) {
        [tagListArray addObject:_symptomtagTF.text];
        [_collectionView reloadData];
        _symptomtagTF.text=@"";
    }
}
//default values
-(void)defaultValue{
    [self setSymptomViewHeight];
    _treatmentNameTF.layer.borderWidth=1;
    _treatmentNameTF.layer.cornerRadius=5;
    _treatmentNameTF.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _treatmentNameTF.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Treatment Name"];
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
    _uploadView.hidden=YES;
    _uploadViewHeigh.constant=0;
    _settingView.hidden=YES;
    _settingViewHeight.constant=0;
    _increasePatientViewHeight.constant=0;
    _increasePatientView.hidden=YES;
    [_increasePatientViewButton setImage:[UIImage imageNamed:@"Button-Collapse"] forState:normal];
    [_increaseDiagnosisViewButton setImage:[UIImage imageNamed:@"Button-Collapse"] forState:normal];
    [_increaseMedicalViewButton setImage:[UIImage imageNamed:@"Button-Collapse"] forState:normal];
    [_increasePatientViewButton setImage:[UIImage imageNamed:@"Button-Collapse"] forState:normal];
    [_increasesettingViewButton setImage:[UIImage imageNamed:@"Button-Collapse"] forState:normal];
    [_increaseUploadViewButton setImage:[UIImage imageNamed:@"Button-Collapse"] forState:normal];
    [constant setColorForLabel:_genderLabel];
    [constant setColorForLabel:_emailLabel];
    [constant setColorForLabel:_nameLabel];
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
    _treatmentNameTF.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Treatment Name"];
    [constant spaceAtTheBeginigOfTextField:_treatmentNameTF];
    [constant SetBorderForTextview:_treatmentEncloserTextView];
    [constant SetBorderForTextview:_medicalHistoryTextView];
    [constant SetBorderForTextview:_diagnosisTextView];
    _medicalHistoryTextView.textContainerInset = UIEdgeInsetsMake(10, 10,10, 10);
    _diagnosisTextView.textContainerInset = UIEdgeInsetsMake(10, 10,10, 10);
}
-(void)setSymptomViewHeight{
   _symptomTagViewHeight.constant=_collectionView.contentSize.height+65;
}
- (IBAction)TreatmentButton:(id)sender {
    if (![_treatmentButton.currentImage isEqual:[UIImage imageNamed:@"Button-Edit"]]) {
        _treatmentNameTF.layer.borderWidth=0;
        [_treatmentButton setImage:[UIImage imageNamed:@"Button-Edit"] forState:normal];
        _treatmentNameTF.enabled=NO;
    }
    else {
        _treatmentNameTF.layer.borderWidth=1;
        _treatmentNameTF.layer.cornerRadius=5;
        _treatmentNameTF.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [_treatmentButton setImage:[UIImage imageNamed:@"Button-Tick"] forState:normal];
        _treatmentNameTF.enabled=YES;
    }
    
}
@end
