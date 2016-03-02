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
#import "AppDelegate.h"
#import "ImageUploadAPI.h"
#import "SeedSyncer.h"
#import "PopOverViewController.h"
#import <WYPopoverController/WYPopoverController.h>
#import <MCLocalization/MCLocalization.h>
#import "ContainerViewController.h"
#import <WYPopoverController/WYPopoverController.h>
#import "germsModel.h"
#define NULL_CHECK(X) [X isKindOfClass:[NSNull class]]?nil:X


@interface PatientSheetViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UITextViewDelegate,deleteCell,selectedImage,increaseSittingCell,cellHeight,WYPopoverControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *attachment;
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
@property (weak, nonatomic) IBOutlet UILabel *medicalDate;
@property (weak, nonatomic) IBOutlet UILabel *medicalTime;
@property (weak, nonatomic) IBOutlet UILabel *medicalMessage;
@property (weak, nonatomic) IBOutlet UILabel *diagnosisDate;
@property (weak, nonatomic) IBOutlet UILabel *diagnosisTime;
@property (weak, nonatomic) IBOutlet UILabel *diagnosismessage;

@end

@implementation PatientSheetViewController
{
    Constant *constant;
    NSMutableArray *diagnosisTableListArray,*medicalTableListArray,*previousSittingDetailArray,*germsArray;
    float sittingCollectionViewHeight,uploadCellHeight,diagnosisCellHeight,medicalHistoryCellHeight;
    AttachmentViewController *attachView;
    UIView *activeField;
    NSMutableArray *uploadedImageArray,*sittingCollectionArray,*allTagListArray,*filterdTagListArray;
    Postman *postman;
    NSDateFormatter *formatter;
    NSString *treatmentID,*passDataToSittingVC,*treatmentModifiedDate;
    NSDictionary *passingDictToSittingVc;
    NSArray *biomagneticArray;
    AppDelegate *app;
    ImageUploadAPI *imageManager;
    NSDictionary *sittingAddOrEditDiffer;
    NSString *sittingNumberToPassSittingVC;
    NSIndexPath *selectedSittingIndex;
    NSArray *slideoutImageArray,*slideoutArray;
    NSString *differForNavButton;
    NSString *navTitle,*titleOfTreatment,*closureNote,*medicalNote,*diagnosisNote,*doYouWantToCloseTreatment,*alert,*alertOk,*updatedSuccess,*updateFailed,*saveSuccess,*saveFailed,*enterTreatmentClosure,*ok,*yesStr,*noStr,*treatmentTitlerequired,*sittingStr,*closedSuccess;
    WYPopoverController *wypopOverController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self localize];
    germsArray=[[NSMutableArray alloc]init];
    [self callSeedForGerms];
    imageManager =[[ImageUploadAPI alloc]init];
    allTagListArray=[[NSMutableArray alloc]init];
    filterdTagListArray=[[NSMutableArray alloc]init];
    previousSittingDetailArray=[[NSMutableArray alloc]init];
    formatter=[[NSDateFormatter alloc]init];
    sittingCollectionViewHeight=0.0,uploadCellHeight=0.0,diagnosisCellHeight=25.0,medicalHistoryCellHeight=25.0;
    constant=[[Constant alloc]init];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background-Image-2.jpg"]]];
    self.title=navTitle;
    [_treatmentNameTF addTarget:self action:@selector(enableAndDisableTreatmentName) forControlEvents:UIControlEventEditingChanged];
    uploadedImageArray=[[NSMutableArray alloc]init];
    sittingCollectionArray=[[NSMutableArray alloc]init];
    [self defaultValue];
    [self registerForKeyboardNotifications];
    [self navigationItemMethod];
    attachView=[self.storyboard instantiateViewControllerWithIdentifier:@"AttachmentViewController"];
    postman=[[Postman alloc]init];
    medicalTableListArray=[[NSMutableArray alloc]init];
    diagnosisTableListArray=[[NSMutableArray alloc]init];
    app=[UIApplication sharedApplication].delegate;
    app.symptomTagArray=[[NSMutableArray alloc]init];
    if (_patientTitleModel.title!=nil) {
        _treatmentNameTF.text=_patientTitleModel.title;
        [self callSeedApi];
    }else{
        _patientDetailModel=[[PatientDetailModel alloc]init];
        _patientDetailModel.IsTreatmentCompleted=@"0";
        treatmentID=@"0";
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self changeTreatmentTF];
    self.navigationItem.hidesBackButton=YES;
    if ([_patientTitleModel.IsTreatmentCompleted intValue]==0) {
        [self DisableAllButton:NO];
    }else [self DisableAllButton:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_sittingCollectionView reloadData];
}

-(void)callSeedApi{
    
    //    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
    //        //For Vzone API
    //        [self callApiTogetSymptomTag];
    //    }else{
    //        //For Material Api
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault boolForKey:@"symptomtag_FLAG"]) {
        [self callApiTogetSymptomTag];
    }
    else{
        NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,getSymptomTag];
        [[SeedSyncer sharedSyncer]getResponseFor:url completionHandler:^(BOOL success, id response) {
            if (success) {
                [self processResponseObjectOfGetAllTag:response];
            }
            else{
                [self callApiTogetSymptomTag];
            }
        }];
    }
    //  }
    
}
//Hide button if treatment is closed
-(void)DisableAllButton:(BOOL)status{
    _addDiagnosis.hidden=status;
    _addMedical.hidden=status;
    _saveTreatmentClosure.hidden=status;
    _closeTreatmentClosure.hidden=status;
    _album.hidden=status;
    _takePic.hidden=status;
    _addSittingButton.hidden=status;
    _cancelMedical.hidden=status;
    _medicalNoteLabel.hidden=status;
    _diagnosisNoteLabel.hidden=status;
    _medicalHistoryTextView.hidden=status;
    _diagnosisTextView.hidden=status;
    if (status==NO) {
        _treatmentButton.userInteractionEnabled=YES;
        _treatmentNameTF.userInteractionEnabled=YES;
        _exit.hidden=YES;
        _medicalTableHeight.constant=87;
        _diagnosisTableHeight.constant=92;
        _medicalHistoryTextView.userInteractionEnabled=YES;
        _diagnosisTextView.userInteractionEnabled=YES;
        _treatmentEncloserTextView.userInteractionEnabled=YES;
    }else{
        _treatmentButton.userInteractionEnabled=NO;
        _treatmentNameTF.userInteractionEnabled=NO;
        _exit.hidden=NO;
        _medicalTableHeight.constant=195;
        _diagnosisTableHeight.constant=175;
        _medicalHistoryTextView.userInteractionEnabled=NO;
        _diagnosisTextView.userInteractionEnabled=NO;
        _treatmentEncloserTextView.userInteractionEnabled=NO;
    }
}
//navigation bar
-(void)navigationItemMethod{
    UIImage* image3 = [UIImage imageNamed:@"06-Icon-Navigation.png"];
    CGRect frameimg = CGRectMake(0, 0, image3.size.width, image3.size.height);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(callMethodInContainerForSlideOut:) forControlEvents:UIControlEventTouchUpInside];
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
    
    
    //UIImage* image2 = [UIImage imageNamed:@"Icon-Langauge.png"];
    UIImage* image1 = [UIImage imageNamed:@"Language-Button.png"];
    CGRect lagFrameimg = CGRectMake(0,0,image1.size.width, image1.size.height);
    UIButton * lagSomeButton= [[UIButton alloc] initWithFrame:lagFrameimg];
    [lagSomeButton setBackgroundImage:image1 forState:normal];
    // [lagSomeButton setImage:image2 forState:normal];
    lagSomeButton.titleEdgeInsets=UIEdgeInsetsMake(0,10, 0,28);
    // lagSomeButton.imageEdgeInsets=UIEdgeInsetsMake(0,74, 0, 0);
    NSUserDefaults *standardDefault=[NSUserDefaults standardUserDefaults];
    [lagSomeButton setTitle:[standardDefault valueForKey:@"languageName"] forState:normal];
    [lagSomeButton setTitleColor:[UIColor blackColor] forState:normal];
    lagSomeButton.titleLabel.font=[UIFont fontWithName:@"OpenSans-Semibold" size:14];
    [lagSomeButton addTarget:self action:@selector(callMethodInContainerForLang:) forControlEvents:UIControlEventTouchUpInside];
    [lagSomeButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *lagButton =[[UIBarButtonItem alloc] initWithCustomView:lagSomeButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = 20;
    self.navigationItem.rightBarButtonItems=@[mailbutton,negativeSpacer,lagButton];}
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
//increase the View Height of patient view
- (IBAction)increaseViewHeightOfPatientView:(id)sender {
    if ([_increasePatientViewButton.currentImage isEqual:[UIImage imageNamed:@"Dropdown-icon"]]) {
        _increasePatientView.hidden=NO;
        _increasePatientViewHeight.constant=_surgeryValueLabel.frame.size.height+130+_emailValueLabel.frame.size.height;
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
    [self ShowuploadImageFromSitting];
}
//save medical history
- (IBAction)saveMedicalHistory:(id)sender {
    if (![_medicalHistoryTextView.text isEqualToString:@""]) {
        [self getCurrentTimeAndDate:@"medical"];
        [_MedicaltableView reloadData];
        _medicalHistoryTextView.text=@"";
        _medicalNoteLabel.hidden=NO;
        
    }
}
//increase the View Height of Daignosis view
- (IBAction)increaseDiagnosisView:(id)sender {
    if ([_increaseDiagnosisViewButton.currentImage isEqual:[UIImage imageNamed:@"Dropdown-icon"]]) {
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
        _diagnosisNoteLabel.hidden=NO;
    }
}
//increase the View Height of setting view
- (IBAction)increaseSettingView:(id)sender {
    if ([_increasesettingViewButton.currentImage isEqual:[UIImage imageNamed:@"Dropdown-icon"]]) {
        _settingView.hidden=NO;
        if (sittingCollectionArray.count>0) {
            _sittingcollectionViewHeight.constant=sittingCollectionViewHeight+100;
            _settingViewHeight.constant=sittingCollectionViewHeight+120;
        }else _settingViewHeight.constant=100;
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
    if (_treatmentNameTF.text.length==0) {
        [self showToastMessage:treatmentTitlerequired];
    }else{
        [self callApiToPostTreatment];
    }
}
//cancel treatment enclosure
- (IBAction)closeTreatmentEncloser:(id)sender {
    if (![_treatmentEncloserTextView.text isEqualToString:@""]) {
        if (_treatmentNameTF.text.length==0) {
            [self showToastMessage:treatmentTitlerequired];
        }else{
            UIAlertController *alertView=[UIAlertController alertControllerWithTitle:alert message:doYouWantToCloseTreatment preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *success=[UIAlertAction actionWithTitle:yesStr style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
                [self callAPIToCloseTreatmentOrUpdate:@"close"];
                [alertView dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertView addAction:success];
            UIAlertAction *failure=[UIAlertAction actionWithTitle:noStr style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
                [alertView dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertView addAction:failure];
            [self presentViewController:alertView animated:YES completion:nil];
        }
    }
    else{
        [self showToastMessage:enterTreatmentClosure];
    }
}
//show alert
-(void)showAlert:(NSString*)msg{
    UIAlertController *alertView=[UIAlertController alertControllerWithTitle:alert message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *success=[UIAlertAction actionWithTitle:alertOk style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
        [alertView dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertView addAction:success];
    [self presentViewController:alertView animated:YES completion:nil];
    
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
                NSArray *dateTime=[treatmentModifiedDate componentsSeparatedByString:@"T"];
                NSArray *ar=[dateTime[1] componentsSeparatedByString:@"."];
                cell.dateValueLabel.text=dateTime[0];
                cell.timeValueLabel.text=ar[0];
                cell.messageValueLabel.text=medicalTableListArray[indexPath.section];
            }
            else{
                NSArray *dateTime=[treatmentModifiedDate componentsSeparatedByString:@"T"];
                NSArray *ar=[dateTime[1] componentsSeparatedByString:@"."];
                cell.dateValueLabel.text=dateTime[0];
                cell.timeValueLabel.text=ar[0];
                cell.messageValueLabel.text=diagnosisTableListArray[indexPath.section];
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
            CGFloat i=_diagnosisView.frame.size.width-230;
            CGFloat labelHeight=[ diagnosisTableListArray[indexPath.section] boundingRectWithSize:(CGSize){i,CGFLOAT_MAX }
                                                                                          options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:13]} context:nil].size.height;
            if (labelHeight<25) {
                return 30;
            }
            else  return labelHeight+15;
        }
        else return 30;
    }
    else if(tableView==_MedicaltableView){
        if (medicalTableListArray.count>0) {
            CGFloat i=_diagnosisView.frame.size.width-240;
            CGFloat labelHeight=[ medicalTableListArray[indexPath.section] boundingRectWithSize:(CGSize){i,CGFLOAT_MAX }
                                                                                        options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:13]} context:nil].size.height;
            if (labelHeight<25) {
                return 30;
            }
            else  return labelHeight+15;
        }
        else return 30;
    }else return 30;
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
    if ([collectionView isEqual:_sittingCollectionView]) {
        return sittingCollectionArray.count;
    }
    else if (collectionView ==_uploadCollectionView) {
        return uploadedImageArray.count;
    }
    else
        return 1;
}
//collectionview cell
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView==_sittingCollectionView) {
        SittingCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell" forIndexPath:indexPath];
        cell.delegate=self;
        
        //For Sitting CollectionViewPart
        
        SittingModelClass *model=sittingCollectionArray[indexPath.row];
        if (_sittingCollectionView.contentSize.width>_settingView .frame.size.width-100) {
            _sittingCollectionViewWidth.constant=_settingView.frame.size.width-100;
        }
        else _sittingCollectionViewWidth.constant=_sittingCollectionView.contentSize.width;
        cell.sittingLabel.text=[NSString stringWithFormat:@"%@ #%@",sittingStr,model.sittingNumber];
        if ([_patientDetailModel.IsTreatmentCompleted intValue]==0) {
            if ([model.completed isEqualToString:@"0"]) {
                [cell.editButton setImage:[UIImage imageNamed:@"Edit-1.jpg"] forState:normal];
            }
            else{
                [cell.editButton setImage:[UIImage imageNamed:@"View-button.png"] forState:normal];
            }
            //            NSArray *treatmentDateArray=[model.visit componentsSeparatedByString:@"T"];
            //            [formatter setTimeZone:[NSTimeZone localTimeZone]];
            //            [formatter setDateFormat:@"yyyy-MM-DD"];
            //            NSDate *dateofTreatment=[formatter dateFromString:treatmentDateArray[0]];
            //            [formatter setDateFormat:@"dd-MMM-yyyy"];
            //            NSString *dateofTreatmentStr=[formatter stringFromDate:dateofTreatment];
        }
        cell.visitDateLabel.text=model.visit;
        //For Header TableView Part
        cell.headerTableView.model=model;
        cell.headerTableView.germsArray=germsArray;
        cell.headerTableView.sittingArray=_sittingArray;
        cell.headerTableView.toxicDeficiencyDetailArray=_toxicDeficiencyDetailArray;
        cell.headerTableView.toxicDeficiencyTypeArray=_toxicDeficiencyTypeArray;
        cell.delegate=self;
        [cell.headerTableView gettheSection];
        CGFloat height= [cell.headerTableView getTHeHeightOfTableVIew];
        model.height=height;
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
            if (model.imageName!=nil) {
                if (model.imageName!=[UIImage imageNamed:@"Loading.jpg"])
                    cell.uploadImageView.image=model.imageName;
            }
            else{
                NSString *strimageUrl;
                if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
                    strimageUrl = [NSString stringWithFormat:@"%@%@%@/%@",baseUrlAws,dbName,model.storgeId,model.fileName];
                }else
                {
                    strimageUrl = [NSString stringWithFormat:@"%@%@%@",baseUrl,expandProfileImage,model.code];
                }
                
                [cell.uploadImageView setImageWithURL:[NSURL URLWithString:strimageUrl] placeholderImage:[UIImage imageNamed:@""]];
                
            }
            cell.labelHeight.constant =[model.captionText boundingRectWithSize:(CGSize){136,CGFLOAT_MAX } options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:12]} context:nil].size.height+10;
            cell.captionLabel.text=model.captionText;
            cell.delegate=self;
        }
        if ([_patientDetailModel.IsTreatmentCompleted intValue]==0) {
            cell.cancelButton.hidden=NO;
        }else cell.cancelButton.hidden=YES;
        return cell;
    }
    else {
        TagCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
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
        return CGSizeMake(10,40);
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
        UploadCollectionViewCell *cell=(UploadCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        [self.navigationController pushViewController:attachView animated:YES];
        UploadModelClass *model=uploadedImageArray[indexPath.row];
        model.imageName=cell.uploadImageView.image;
        attachView.selectedImage=model.imageName;
        attachView.captionText=model.captionText;
        attachView.imageViewHeight.constant=self.view.frame.size.height-300;
        attachView.textViewEnabled=NO;
    }
}
//delete sitting cell
-(void)deleteSittingCell:(SittingCollectionViewCell *)cell{
    //NSIndexPath *index=[_sittingCollectionView indexPathForCell:cell];
    NSLog(@"%@",sittingCollectionArray);
    
    SittingModelClass *sitMode = sittingCollectionArray[0];
    NSLog(@"%@",sitMode.visit);
    
    
    [self callApiToDeleteSitting];
}
-(void)selectedHeaderCell:(NSString*)selectedHeader withcell:(UICollectionViewCell*)cell withCorrespondingHeight:(CGFloat)height{
    SittingCollectionViewCell *cell1=(SittingCollectionViewCell*)cell;
    NSIndexPath *index=[_sittingCollectionView indexPathForCell:cell1];
    SittingModelClass *m=sittingCollectionArray[index.row];
    [m.selectedHeaderIndexpath addObject:selectedHeader];
    NSString *str=[NSString stringWithFormat:@"%f",height];
    NSDictionary *dict=[NSDictionary dictionaryWithObject:str forKey:selectedHeader];
    [m.correspondingPairHeight addObject:dict];
    [self.view layoutIfNeeded];
    [_sittingCollectionView reloadData];
    [self.view layoutIfNeeded];
    [_sittingCollectionView reloadData];
    sittingCollectionViewHeight=0;
    for (SittingModelClass *m in sittingCollectionArray) {
        sittingCollectionViewHeight=MAX(sittingCollectionViewHeight, m.height);
    }
    _sittingcollectionViewHeight.constant=sittingCollectionViewHeight+100;
    _settingViewHeight.constant=sittingCollectionViewHeight+120;
}
-(void)deselectedHeaderCell:(NSString*)deselectedHeader withcell:(UICollectionViewCell*)cell withCorrespondingHeight:(CGFloat)height{
    SittingCollectionViewCell *cell1=(SittingCollectionViewCell*)cell;
    NSIndexPath *index=[_sittingCollectionView indexPathForCell:cell1];
    SittingModelClass *m=sittingCollectionArray[index.row];
    NSArray *ar=[deselectedHeader componentsSeparatedByString:@"-"];
    if ([ar[0] intValue]==0) {
        NSMutableArray *headerRemoveArray=[[NSMutableArray alloc]init];
        for (NSString *str in m.selectedHeaderIndexpath) {
          NSArray *ar1=[str componentsSeparatedByString:@"-"];
            if ([ar1[1] isEqualToString:ar[1]]) {
                [headerRemoveArray addObject:str];
            }
        }
        NSMutableArray *dictArray=[[NSMutableArray alloc]init];
        for (NSString *str in headerRemoveArray) {
            for (NSDictionary *dict in m.correspondingPairHeight) {
                    if (dict[str]) {
                        [dictArray addObject:dict[str]];
                        break;
                    }
                }
        }
        [m.selectedHeaderIndexpath removeObjectsInArray:headerRemoveArray];
        [m.correspondingPairHeight removeObjectsInArray:dictArray];
    }else{
        [m.selectedHeaderIndexpath removeObject:deselectedHeader];
        NSDictionary *dict1;
        for (NSDictionary *dict in m.correspondingPairHeight) {
            if (dict[deselectedHeader]) {
                dict1=dict;
                break;
            }
        }
        [m.correspondingPairHeight removeObject:dict1];
    }
    [self.view layoutIfNeeded];
    [_sittingCollectionView reloadData];
    [self.view layoutIfNeeded];
    [_sittingCollectionView reloadData];
    sittingCollectionViewHeight=0;
    for (SittingModelClass *m in sittingCollectionArray) {
        sittingCollectionViewHeight=MAX(sittingCollectionViewHeight, m.height);
    }
    _sittingcollectionViewHeight.constant=sittingCollectionViewHeight+100;
    _settingViewHeight.constant=sittingCollectionViewHeight+120;
}
-(void)selectedToxicCell1:(NSString *)selectedToxicHeader withcell:(UICollectionViewCell*)cell {
    SittingCollectionViewCell *cell1=(SittingCollectionViewCell*)cell;
    NSIndexPath *index=[_sittingCollectionView indexPathForCell:cell1];
    SittingModelClass *m=sittingCollectionArray[index.row];
    [m.selectedToxicHeader addObject:selectedToxicHeader];
    [self.view layoutIfNeeded];
    [_sittingCollectionView reloadData];
    [self.view layoutIfNeeded];
    [_sittingCollectionView reloadData];
    sittingCollectionViewHeight=0;
    for (SittingModelClass *m in sittingCollectionArray) {
        sittingCollectionViewHeight=MAX(sittingCollectionViewHeight, m.height);
    }
    _sittingcollectionViewHeight.constant=sittingCollectionViewHeight+100;
    _settingViewHeight.constant=sittingCollectionViewHeight+120;

}
-(void)deselectedToxicCell1:(NSString *)deselectedHeader withcell:(UICollectionViewCell*)cell {
    SittingCollectionViewCell *cell1=(SittingCollectionViewCell*)cell;
    NSIndexPath *index=[_sittingCollectionView indexPathForCell:cell1];
    SittingModelClass *m=sittingCollectionArray[index.row];
    [m.selectedToxicHeader removeObject:deselectedHeader];
    [self.view layoutIfNeeded];
    [_sittingCollectionView reloadData];
    [self.view layoutIfNeeded];
    [_sittingCollectionView reloadData];
    sittingCollectionViewHeight=0;
    for (SittingModelClass *m in sittingCollectionArray) {
        sittingCollectionViewHeight=MAX(sittingCollectionViewHeight, m.height);
    }
    _sittingcollectionViewHeight.constant=sittingCollectionViewHeight+100;
    _settingViewHeight.constant=sittingCollectionViewHeight+120;
}
//default values
-(void)defaultValue{
    [constant getTheAllSaveButtonImage:_exit];
    [constant getTheAllSaveButtonImage:_addDiagnosis];
    [constant getTheAllSaveButtonImage:_addMedical];
    [constant getTheAllSaveButtonImage:_saveTreatmentClosure];
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
    _increasePatientViewHeight.constant=_surgeryValueLabel.frame.size.height+130;
    _increasePatientView.hidden=NO;
    [_increaseDiagnosisViewButton setImage:[UIImage imageNamed:@"Dropdown-icon"] forState:normal];
    [_increaseMedicalViewButton setImage:[UIImage imageNamed:@"Dropdown-icon"] forState:normal];
    [_increasePatientViewButton setImage:[UIImage imageNamed:@"Dropdown-icon-up"] forState:normal];
    [_increasesettingViewButton setImage:[UIImage imageNamed:@"Dropdown-icon"] forState:normal];
    _treatmentNameTF.attributedPlaceholder=[constant PatientSheetPlaceHolderText:titleOfTreatment];
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
    if (![_treatmentNameTF.text isEqualToString:@""]) {
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
        _treatmentNameTF.attributedPlaceholder=[constant PatientSheetPlaceHolderText:titleOfTreatment];
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
    if (![_treatmentNameTF.text isEqualToString:@""]) {
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
}
//Getting Current Date Time Values
-(void)getCurrentTimeAndDate:(NSString*)str{
    [formatter setDateFormat:@"dd-MMM-yyyy"];
    NSString *currentDate=[formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString *currentTime=[formatter stringFromDate:[NSDate date]];
    if ([str isEqualToString:@"medical"]) {
        treatmentModifiedDate=[NSString stringWithFormat:@"%@T%@",currentDate,currentTime];
        [medicalTableListArray addObject:_medicalHistoryTextView.text];
    }
    else{
        treatmentModifiedDate=[NSString stringWithFormat:@"%@T%@",currentDate,currentTime];
        [diagnosisTableListArray addObject:_diagnosisTextView.text];
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
    _uploadViewHeigh.constant=uploadCellHeight+230;
}



-(void)deleteCell:(id)cell{
    uploadCellHeight=0.0;
    NSIndexPath *index=[_uploadCollectionView indexPathForCell:cell];
    UploadModelClass *model=uploadedImageArray[index.row];
    if (model.storgeId.length==0) {
        [self afterSuccesfullDeleteOfDocument:index];
    }
    else [self callDeleteDocumentAPI:index withDocumentModel:model];
}
//DocumentDeleteSuccess
-(void)afterSuccesfullDeleteOfDocument:(NSIndexPath*)index{
    [uploadedImageArray removeObjectAtIndex:index.row];
    for (UploadModelClass *m in uploadedImageArray) {
        CGFloat labelHeight=[m.captionText boundingRectWithSize:(CGSize){136,CGFLOAT_MAX }
                                                        options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:12]} context:nil].size.height;
        uploadCellHeight=MAX(uploadCellHeight, labelHeight);
    }
    [_uploadCollectionView reloadData];
    [_scrollView layoutIfNeeded];
    if (uploadedImageArray.count==0) {
        _uploadViewHeigh.constant=100;
    }
    else _uploadViewHeigh.constant=uploadCellHeight+230;
}
//api to delete doc
-(void)callDeleteDocumentAPI:(NSIndexPath*)index withDocumentModel:(UploadModelClass*)uploadmodel{
    
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,deleteDocumentUrl];
    NSString *parameter=[NSString stringWithFormat:@"{\"request\":{\"docid\":%@,\"fileid\":\"%@\",\"RequestId\":%d,\"RequestCode\":\"%@\",\"UserName\":\"%@\",\"AuditEventDescription\":\"Document(%@)Deleted\"}}",uploadmodel.docId,uploadmodel.storgeId,[_model.Id intValue],uploadmodel.docReqCode,_model.name,uploadmodel.fileName];
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [self processDeleteDoc:responseObject withIndex:index];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        NSString *str=[NSString stringWithFormat:@"%@",error];
        [self showToastMessage:str];
    }];
}
//process delete doc
-(void)processDeleteDoc:(id)responseObject withIndex:(NSIndexPath*)index{
    NSDictionary *dict;
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        NSDictionary *dict1=responseObject;
        dict=dict1[@"aaData"];
    }
    if ([dict[@"Success"]intValue]==1) {
        [self afterSuccesfullDeleteOfDocument:index];
        [self showToastMessage:dict[@"Message"]];
    }
    else [self showToastMessage:dict[@"Message"]];
    
}

- (IBAction)gestureRecognize:(id)sender {
    [self.view endEditing:YES];
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
        else {
            [self saveImage:_patientDetailModel.code];
        }
    }
}
//call post method
-(void)callPostTreatment{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    NSString *parameter =[self getParameterForSaveORCloseOrUpdateTreatment:@"true" withTreatmentCompleted:@"false" withMethodType:@"POST"];
    NSString *url=[NSString stringWithFormat:@"%@%@/0",baseUrl,addTreatmentUrl];
    [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [self processResponseObject:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [self showToastMessage:[NSString stringWithFormat:@"%@",error]];
    }];
    
}

//process post response object
-(void)processResponseObject:(id)responseObject{
    NSDictionary *dict;
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        NSDictionary *responseDict1 = responseObject;
        dict  = responseDict1[@"aaData"];
    }else  dict=responseObject;
    
    if ([dict[@"Success"] intValue]==1) {
        if ([treatmentID isEqualToString:@"0"]) {
            NSDictionary *dict1=dict[@"TreatmentRequest"];
            [self saveImage:dict1[@"Code"]];
        }
        UIAlertController *alertView=[UIAlertController alertControllerWithTitle:alert message:dict[@"Message"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *success=[UIAlertAction actionWithTitle:alertOk style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
            [self.navigationController popViewControllerAnimated:YES];
            if (![_patientDetailModel.title isEqualToString:_treatmentNameTF.text]) {
                [self CallLoadTreatMentDelegate];
            }
            [alertView dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertView addAction:success];
        [self presentViewController:alertView animated:YES completion:nil];
    }
    else {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [self showToastMessage:dict[@"Message"]];
    }
}

//show detail of treatment

-(void)showTreatmentDetail{
    [medicalTableListArray removeAllObjects];
    [diagnosisTableListArray removeAllObjects];
    treatmentID=_patientDetailModel.idValue;
    if (_patientDetailModel.treatmentDetail!=nil) {
        _treatmentNameTF.text=_patientDetailModel.title;
        NSData *jsonData = [_patientDetailModel.treatmentDetail dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        NSArray *medicalArray=jsonDict[@"MedicalHistory"];
        NSArray *diagnosisArray=jsonDict[@"Diagnosis"];
        _treatmentEncloserTextView.text=jsonDict[@"TreatmentClosure"];
        _medicalHistoryTextView.text=@"";
        _diagnosisTextView.text=@"";
        if ([_treatmentEncloserTextView.text isEqualToString:@""]) {
            _addClosureNoteLabel.hidden=NO;
        }else _addClosureNoteLabel.hidden=YES;
        treatmentModifiedDate=_patientDetailModel.treatmentRequestDate;
        for (NSString *str in medicalArray) {
            if (![str isEqualToString:@""]) {
                [medicalTableListArray addObject:str];
            }
        }
        [_MedicaltableView reloadData];
        for (NSString *str in diagnosisArray) {
            if (![str isEqualToString:@""]) {
                [diagnosisTableListArray addObject:str];
            }
        }
        [_diagnosisTableView reloadData];
    }
    [app.symptomTagArray removeAllObjects];
    if (_patientDetailModel.symptomTagCodes.count>0) {
        for (NSString *str in _patientDetailModel.symptomTagCodes) {
            for (int i=0; i<allTagListArray.count; i++) {
                SymptomTagModel *m=allTagListArray[i];
                if ([m.tagCode isEqualToString:str]) {
                    [app.symptomTagArray addObject:m];
                }
            }
        }
    }
    [uploadedImageArray removeAllObjects];
    if (_patientDetailModel.documentDetails.count>0) {
        for (NSDictionary *dict in _patientDetailModel.documentDetails) {
            UploadModelClass *uploadModel=[[UploadModelClass alloc]init];
            //            uploadModel.storgeId=  dict[@"StorageID"];
            //            uploadModel.code=  dict[@"Code"];
            //            uploadModel.captionText=  dict[@"RenamedFilename"];
            //            uploadModel.imageName=nil;
            
            uploadModel.storgeId = NULL_CHECK(dict[@"StorageID"]);
            uploadModel.code=   NULL_CHECK(dict[@"Code"]);
            uploadModel.captionText= NULL_CHECK(dict[@"RenamedFilename"]);
            uploadModel.imageName=nil;
            uploadModel.docId=NULL_CHECK(dict[@"Id"]);
            uploadModel.docReqType=NULL_CHECK(dict[@"RequestType"]);
            uploadModel.docReqCode=NULL_CHECK(dict[@"RequestCode"]);
            uploadModel.fileName=NULL_CHECK(dict[@"FileName"]);
            [uploadedImageArray addObject:uploadModel];
        }
        if (![_increaseUploadViewButton.currentImage isEqual:[UIImage imageNamed:@"Dropdown-icon"]]) {
            [self ShowuploadImageFromSitting];
        }
    }
    biomagneticArray=_patientDetailModel.biomagneticSittingResults;
    [self SittingPartToViewCompleteDetail:biomagneticArray];
}
//Show Upload Image from sitting
-(void)ShowuploadImageFromSitting{
    if ([_increaseUploadViewButton.currentImage isEqual:[UIImage imageNamed:@"Dropdown-icon"]]) {
        _uploadView.hidden=NO;
        if (uploadedImageArray.count>0) {
            for (UploadModelClass *m in uploadedImageArray) {
                CGFloat labelHeight=[m.captionText boundingRectWithSize:(CGSize){136,CGFLOAT_MAX }
                                                                options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:12]} context:nil].size.height;
                uploadCellHeight=MAX(uploadCellHeight, labelHeight);
            }
            _uploadCollectionView.hidden=NO;
            _uploadViewHeigh.constant=uploadCellHeight+230;
            [_uploadCollectionView reloadData];
            [self.view layoutIfNeeded];
        }
        else  _uploadViewHeigh.constant=100;
        [self ChangeIncreaseDecreaseButtonImage:_increaseUploadViewButton];
    }
    else{
        _uploadView.hidden=YES;
        _uploadViewHeigh.constant=0;
        [self ChangeIncreaseDecreaseButtonImage:_increaseUploadViewButton];
    }
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
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        if ([closeOrUpdate isEqualToString:@"close"]) {
            [self processCloseTreatment:responseObject withMessage:closedSuccess];
        }else  [self processCloseTreatment:responseObject withMessage:updatedSuccess];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        NSString *str=[NSString stringWithFormat:@"%@",error];
        [self showToastMessage:str];
    }];
}

//Process Close treatment
-(void)processCloseTreatment:(id)responseObject withMessage:(NSString*)msg{
    
    NSDictionary *dict;
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        NSDictionary *responseDict1 = responseObject;
        dict  = responseDict1[@"aaData"];
    }else  dict=responseObject;
    if ([dict[@"Success"]intValue]==1) {
        UIAlertController *alertView=[UIAlertController alertControllerWithTitle:alert message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *success=[UIAlertAction actionWithTitle:alertOk style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
            [self.navigationController popViewControllerAnimated:YES];
            [self CallLoadTreatMentDelegate];
            [alertView dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertView addAction:success];
        [self presentViewController:alertView animated:YES completion:nil];
    }else {
        [self showToastMessage:dict[@"Message"]];
    }
}


//set parameter for treatment api.
-(NSString*)getParameterForSaveORCloseOrUpdateTreatment:(NSString*)status withTreatmentCompleted:(NSString*)treatmentComplete withMethodType:(NSString*)type{
    NSUserDefaults *defaultValues=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *jsondict=[[NSMutableDictionary alloc]init];
    if (medicalTableListArray.count>0) {
        NSMutableArray *medicalText=[[NSMutableArray alloc]init];
        for (NSString *str in medicalTableListArray) {
            [medicalText addObject:str];
        }
        jsondict[@"MedicalHistory"]=medicalText;
    }else{
        NSArray *medicalText=@[@""];
        jsondict[@"MedicalHistory"]=medicalText;
    }
    if (diagnosisTableListArray.count>0) {
        NSMutableArray *medicalText=[[NSMutableArray alloc]init];
        for (NSString *str in diagnosisTableListArray) {
            [medicalText addObject:str];
        }
        jsondict[@"Diagnosis"]=medicalText;
    }else{
        NSArray *medicalText=@[@""];
        jsondict[@"Diagnosis"]=medicalText;
    }
    jsondict[@"TreatmentClosure"]=_treatmentEncloserTextView.text;
    NSMutableDictionary *treatmentRequestDict=[[NSMutableDictionary alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr=[formatter stringFromDate:[NSDate date]];
    treatmentRequestDict[@"TreatmentRequestDate"]=dateStr;
    treatmentRequestDict[@"IsTreatmentCompleted"]=treatmentComplete;
    treatmentRequestDict[@"PatientId"]=_model.Id;
    treatmentRequestDict[@"DoctorId"]=[defaultValues valueForKey:@"Id"];
    treatmentRequestDict[@"languagecode"]=languageCode;
    NSString *symptomtag=@"";
    treatmentRequestDict[@"SymptomTagCodes"]=symptomtag;
    treatmentRequestDict[@"Title"]=_treatmentNameTF.text;
    treatmentRequestDict[@"Status"]=status;
    treatmentRequestDict[@"CompanyCode"]=postmanCompanyCode;
    
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"])
    {
        treatmentRequestDict[@"JSON"]=jsondict;
        
    }else
    {
        NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:jsondict options:kNilOptions error:nil];
        NSString *treatmentRequest = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
        treatmentRequestDict[@"JSON"]=treatmentRequest;
    }
    
    if ([type isEqualToString:@""]) {
        passingDictToSittingVc=treatmentRequestDict;
    }
    NSData *parameterData = [NSJSONSerialization dataWithJSONObject:treatmentRequestDict options:kNilOptions error:nil];
    NSString *treatmentRequestStr = [[NSString alloc] initWithData:parameterData encoding:NSUTF8StringEncoding];
    NSString *parameter;
    
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        //For Vzone API
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        dict[@"MethodType"]=type;
        dict[@"Id"]=treatmentID;
        dict[@"TreatmentRequest"]=treatmentRequestStr;
        NSData *parameterData1 = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
        NSString *treatmentRequestStr1 = [[NSString alloc] initWithData:parameterData1 encoding:NSUTF8StringEncoding];
        parameter =[NSString stringWithFormat:@"{\"request\":%@}",treatmentRequestStr1];
        
        
    }
    
    
    else{
        //For Material API
        parameter=[NSString stringWithFormat:@"{\"MethodType\": \"%@\", \"Id\": \"%@\",\"TreatmentRequest\":%@}",type,treatmentID,treatmentRequestStr];
    }
    
    return parameter;
}
//call api to load treatment api
-(void)CallLoadTreatMentDelegate{
    [self.delegate loadTreatment];
}
//Load Treatment from sitting part
-(void)loadTreatMentFromSittingPart:(NSString*)idvalue withTreatmentCode:(NSString *)treatmentCode{
    _patientTitleModel=[[PatientTitleModel alloc]init];
    _patientTitleModel.idValue=idvalue;
    _patientTitleModel.code=treatmentCode;
    [self CallLoadTreatMentDelegate];
    [self callApiTogetSymptomTag];
}
//Cancel Medical History
- (IBAction)cancelMedicalHistory:(id)sender {
    _medicalHistoryTextView.text=@"";
    _medicalNoteLabel.hidden=NO;
}

//get symptom API
-(void)callApiTogetSymptomTag{
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,getSymptomTag];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        NSString *parameter=[NSString stringWithFormat:@"{\"request\":}}"];
        [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processResponseObjectOfGetAllTag:responseObject];
            [[SeedSyncer sharedSyncer]saveResponse:[operation responseString] forIdentity:url];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:NO forKey:@"symptomtag_FLAG"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            [self showToastMessage:[NSString stringWithFormat:@"%@",error]];
        }];
    }else{
        [postman get:url withParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processResponseObjectOfGetAllTag:responseObject];
            [[SeedSyncer sharedSyncer]saveResponse:[operation responseString] forIdentity:url];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:NO forKey:@"symptomtag_FLAG"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            [self showToastMessage:[NSString stringWithFormat:@"%@",error]];
        }];
    }
}

//process get tag
-(void)processResponseObjectOfGetAllTag:(id)responseObject{
    allTagListArray=[[NSMutableArray alloc]init];
    NSDictionary *dict;
    
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        NSDictionary *responseDict1 = responseObject;
        dict=responseDict1[@"aaData"];
    }else dict=responseObject;
    
    for (NSDictionary *dict1 in dict[@"GenericSearchViewModels"]) {
        if ([dict1[@"Status"]intValue]==1) {
            SymptomTagModel *model=[[SymptomTagModel alloc]init];
            model.tagId=dict1[@"Id"];
            model.tagCode=dict1[@"Code"];
            model.tagName=dict1[@"Name"];
            [allTagListArray addObject:model];
        }
    }
    [self callApiTogetAllDetailOfTheTreatment];
}
//Show Sitting Part
-(void)SittingPartToViewCompleteDetail:(NSArray*)bioSittingArray{
    int sittingNum=0;
    [sittingCollectionArray removeAllObjects];
    if (bioSittingArray.count>0) {
        for (NSDictionary *dict in bioSittingArray) {
            NSString *str=dict[@"JSON"];
            NSError *jsonError;
            NSData *objectData = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:&jsonError];
            NSArray *anotomicalPointArray=json[@"AnatomicalPoints"];
            if ([json[@"Status"] integerValue]==1) {
                SittingModelClass *m=[[SittingModelClass alloc]init];
                _sittingCollectionViewWidth.constant=100;
                m.selectedHeaderIndexpath=[[NSMutableArray alloc]init];
                m.selectedScanPointIndexpath=[[NSMutableArray alloc]init];
                m.selectedToxicHeader=[[NSMutableArray alloc]init];
                m.toxicDeficiency=json[@"ToxicDeficiency"];
                m.price=json[@"Price"];
                m.height=100;
                m.correspondingPairHeight =[[NSMutableArray alloc]init];
                m.selectedScanPointIndexpath=nil;
                NSInteger i=[dict[@"IsCompleted"] integerValue];
                m.completed=[@(i)description];
                m.visit=dict[@"Visit"];
                int sittingI=[dict[@"SittingNumber"] integerValue];
                m.sittingNumber=[@(sittingI)description];
                m.sittingID=dict[@"Id"];
                m.anotomicalPointArray=anotomicalPointArray;
                [sittingCollectionArray addObject:m];
                sittingNum+=1;
                sittingNumberToPassSittingVC=[@(sittingNum)description];
            }
        }
        [self.view layoutIfNeeded];
        [_sittingCollectionView reloadData];
        [self.view layoutIfNeeded];
        [_sittingCollectionView reloadData];
        sittingCollectionViewHeight=0;
        for (SittingModelClass *m in sittingCollectionArray) {
            sittingCollectionViewHeight=MAX(sittingCollectionViewHeight, m.height);
        }
        if (![_increasesettingViewButton.currentImage isEqual:[UIImage imageNamed:@"Dropdown-icon"]]) {
            if (sittingCollectionArray.count>0) {
                _sittingcollectionViewHeight.constant=sittingCollectionViewHeight+100;
                _settingViewHeight.constant=sittingCollectionViewHeight+120;
            }else _settingViewHeight.constant=100;
        }
        if (selectedSittingIndex!=nil) {
            [_sittingCollectionView scrollToItemAtIndexPath:selectedSittingIndex atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        }else{
            if (sittingCollectionArray.count>0) {
                NSIndexPath *index=[NSIndexPath indexPathForRow:sittingCollectionArray.count-1 inSection:0];
                [_sittingCollectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            }
        }
    }else  sittingNumberToPassSittingVC=[@(sittingNum)description];
}
-(void)editSittingCell:(UICollectionViewCell *)cell{
    [previousSittingDetailArray removeAllObjects];
    SittingCollectionViewCell *cell1=(SittingCollectionViewCell*)cell;
    NSIndexPath *index=[_sittingCollectionView indexPathForCell:cell1];
    selectedSittingIndex=index;
    SittingModelClass *model=sittingCollectionArray[index.row];
    for (NSDictionary *dict in biomagneticArray) {
        int i=[dict[@"Id"]intValue];
        if ([model.sittingID intValue]==i) {
            sittingAddOrEditDiffer=dict;
        }else{
            [previousSittingDetailArray addObject:dict];
        }
    }
    if (sittingAddOrEditDiffer!=nil) {
        [self performSegueWithIdentifier:@"sitting" sender:nil];
    }
}
- (IBAction)addSitting:(id)sender {
    if (_treatmentNameTF.text.length==0) {
        [self showToastMessage:treatmentTitlerequired];
    }else{
        selectedSittingIndex=nil;
        [previousSittingDetailArray removeAllObjects];
        for (NSDictionary *dict in biomagneticArray) {
            [previousSittingDetailArray addObject:dict];
        }
        sittingAddOrEditDiffer=nil;
        [app.symptomTagArray removeAllObjects];
        [self performSegueWithIdentifier:@"sitting" sender:nil];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"sitting"]) {
        SWRevealViewController *revealVC=segue.destinationViewController;
        SittingViewController *sittingVC=[self.storyboard instantiateViewControllerWithIdentifier:@"SittingViewController"];
        sittingVC.delegateForIncreasingSitting=self;
        NSString *str=[self getParameterForSaveORCloseOrUpdateTreatment:@"" withTreatmentCompleted:@"" withMethodType:@""];
        sittingVC.sittingStringParameterFromParent=str;
        sittingVC.editOrAddSitting=@"y";
        sittingVC.treatmentId=treatmentID;
        sittingVC.searchModel=_model;
        sittingVC.isTreatmntCompleted=_patientDetailModel.IsTreatmentCompleted;
        if(sittingAddOrEditDiffer==nil){
            sittingVC.bioSittingDict=nil;
            sittingVC.biomagneticAnotomicalPointArray=nil;
        }else{
            sittingVC.bioSittingDict=sittingAddOrEditDiffer;
            sittingVC.biomagneticAnotomicalPointArray=biomagneticArray;
        }
        sittingVC.allAddedBiomagArray=previousSittingDetailArray;
        [revealVC setFrontViewController:sittingVC];
        sittingVC.sectionName=@"";
        sittingVC.SortType=@"";
        sittingVC.toxicDeficiencyString=@"";
        sittingVC.sittingNumber=sittingNumberToPassSittingVC;
    }
}

//save profile
- (void)saveImage:(NSString*)code
{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    if (uploadedImageArray.count>0) {
        for (UploadModelClass *model in uploadedImageArray) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString* path = [documentsDirectory stringByAppendingPathComponent:@"EdittedProfile.jpeg" ];
            NSData* data = UIImageJPEGRepresentation(model.imageName,.5);
            [data writeToFile:path atomically:YES];
            NSArray *type=@[@"NLB0H7"];
            NSArray *caption=@[model.captionText];
            if (model.storgeId==nil) {
                [imageManager uploadDocumentPath:path forRequestCode:code withDocumentType:type withText:caption withRequestType:@"Treatment" onCompletion:^(BOOL success) {
                    if (success)
                    {
                        [MBProgressHUD hideHUDForView:self.view animated:NO];
                        [self callAPIToCloseTreatmentOrUpdate:@"update"];
                    }else
                    {
                        [MBProgressHUD hideHUDForView:self.view animated:NO];
                        [self showToastMessage:@"failed"];
                    }
                }];
            }
        }
    }else{
        [self callAPIToCloseTreatmentOrUpdate:@"update"];
    }
}
- (IBAction)exit:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//getThe Detail of Treatment
-(void)callApiTogetAllDetailOfTheTreatment{
    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,getTreatmentDetail];
    NSUserDefaults *defaultvalue=[NSUserDefaults standardUserDefaults];
    int userIdInteger=[[defaultvalue valueForKey:@"Id"]intValue];
    NSString *userID=[@(userIdInteger) description];
    
    NSString *parameter;
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        //For Vzone API
        parameter=[NSString stringWithFormat:@"{\"request\":{\"DoctorId\":\"%@\",\"PatientId\":\"%@\",\"TreatmentCode\":\"%@\"}}",userID,_model.Id,_patientTitleModel.code];
    }else {
        //For Material API
        parameter=[NSString stringWithFormat:@"{\"DoctorId\":\"%@\",\"PatientId\":\"%@\",\"TreatmentCode\":\"%@\"}",userID,_model.Id,_patientTitleModel.code];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        [self processResponseObjectToGetTreatmentDetail:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        [self showToastMessage:[NSString stringWithFormat:@"%@",error]];
    }];
}

//process object to get detail of treatment
-(void)processResponseObjectToGetTreatmentDetail:(id)responseObject{
    NSDictionary *dict;
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        //For Vzone API
        NSDictionary *responseDict1 = responseObject;
        dict = responseDict1[@"aaData"];
    }else{
        dict=responseObject;
    }
    if ([dict[@"Success"] intValue]==1) {
        for (NSDictionary *dict1 in dict[@"TreatmentRequests"]) {
            if ([dict1[@"Status"]intValue]==1) {
                if ([dict1[@"Id"]intValue]==[_patientTitleModel.idValue intValue]) {
                    [self getDataOfResponseOfTreatmentRequestDetail:dict1];
                }
            }
        }
        [self showTreatmentDetail];
    }
}
-(void)getDataOfResponseOfTreatmentRequestDetail:(NSDictionary*)dict1{
    _patientDetailModel=[[PatientDetailModel alloc]init];
    _patientDetailModel.IsTreatmentCompleted=dict1[@"IsTreatmentCompleted"];
    // _patientDetailModel.idValue=dict1[@"TreatmentId"];
    _patientDetailModel.idValue=dict1[@"Id"];
    _patientDetailModel.code=dict1[@"TreatmentCode"];
    _patientDetailModel.title=dict1[@"Title"];
    _patientDetailModel.symptomTagCodes=[dict1[@"SymptomTagCodes"] componentsSeparatedByString:@"|$|"];
    NSDictionary *bioDict=dict1[@"BiomagneticSittingResults"];
    NSSortDescriptor *descriptor=[[NSSortDescriptor alloc]initWithKey:@"SittingNumber" ascending:YES];
    NSArray *ar=[bioDict[@"ViewModels"] sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor, nil]];
    _patientDetailModel.biomagneticSittingResults=ar;
    _patientDetailModel.documentDetails=dict1[@"DocumentDetails"];
    _patientDetailModel.treatmentRequestDate=dict1[@"TreatmentRequestDate"];
    _patientDetailModel.treatmentDetail=dict1[@"JSON"];
    // model.updateCount=dict1[@"UpdateCount"];
}
//upload image after save sitting
-(void)uploadImageAfterSaveInSitting:(NSString*)code{
    [self saveImage:code];
}

//Delete SittingPart
-(void)callApiToDeleteSitting{
    NSString *url=[NSString stringWithFormat:@"%@%@%@",baseUrl,closeTreatmentDetail,treatmentID];
    NSString *parameter;
    parameter =[self getParameteToDeleteSittingDetail];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [postman put:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [self processResponseObjectOfCloseTreatment:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [self showToastMessage:[NSString stringWithFormat:@"%@",error]];
    }];
}
//parameter to Delete SittingPart
-(NSString*)getParameteToDeleteSittingDetail{
    NSString *parameter= [self getParameterForSaveORCloseOrUpdateTreatment:@"true" withTreatmentCompleted:@"false" withMethodType:@"PUT"];
    NSDictionary *parameterDict = [NSJSONSerialization JSONObjectWithData:[parameter dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    NSMutableDictionary *finalDict=[parameterDict mutableCopy];
    NSMutableDictionary *sectionDict=[[NSMutableDictionary alloc]init];
    NSMutableArray *jsonSittingArray=[[NSMutableArray alloc]init];
    sectionDict[@"SectionCode"]=@"";
    sectionDict[@"ScanPointCode"]=@"";
    sectionDict[@"CorrespondingPairCode"]=@"";
    sectionDict[@"SectionName"]=@"";
    sectionDict[@"ScanPointName"]=@"";
    sectionDict[@"CorrespondingPairName"]=@"";
    sectionDict[@"GermsCode"]=@"";
    sectionDict[@"GenderCode"]=@"";
    sectionDict[@"Description"]=@"";
    sectionDict[@"Psychoemotional"]=@"";
    sectionDict[@"Author"]=@"";
    sectionDict[@"LocationScanPoint"]=@"";
    sectionDict[@"LocationCorrespondingPair"]=@"";
    sectionDict[@"Price"]=@"";
    sectionDict[@"GermsName"]=@"";
    sectionDict[@"Issue"]=@"";
    [jsonSittingArray addObject:sectionDict];
    
    NSMutableDictionary *sittingDict=[[NSMutableDictionary alloc]init];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    NSDictionary *toxicDict=[NSDictionary dictionaryWithObjectsAndKeys:@"",@"ToxicDeficiency", nil];
    [jsonSittingArray addObject:toxicDict];
    sittingDict[@"Notes"]=@"";
    sittingDict[@"AnatomicalPoints"]=jsonSittingArray;
    sittingDict[@"Status"]=@"0";
    NSData *sittingData = [NSJSONSerialization dataWithJSONObject:parameterDict options:kNilOptions error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:sittingData encoding:NSUTF8StringEncoding];
    dict[@"JSON"]=jsonString;
    NSArray *sittingResultArray=@[dict];
    finalDict[@"SittingResultsRequest"]=sittingResultArray;
    
    NSString *parameter1;
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        //For Vzone API
        NSMutableDictionary *vzoneFinalDict=[[NSMutableDictionary alloc]init];
        vzoneFinalDict[@""]=finalDict;
        NSData *parameterData = [NSJSONSerialization dataWithJSONObject:vzoneFinalDict options:kNilOptions error:nil];
        parameter1 = [[NSString alloc] initWithData:parameterData encoding:NSUTF8StringEncoding];
    }else{
        //For Material API
        NSData *parameterData = [NSJSONSerialization dataWithJSONObject:finalDict options:kNilOptions error:nil];
        parameter1 = [[NSString alloc] initWithData:parameterData encoding:NSUTF8StringEncoding];
    }
    
    return parameter1;
}
//process Delete SittingPart
-(void)processResponseObjectOfCloseTreatment:(id)responseObject{
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
        [self callApiTogetAllDetailOfTheTreatment];
    }else [self showToastMessage:dict[@"Message"]];
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
    alertOk=[MCLocalization stringForKey:@"AlertOK"];
    updateFailed=[MCLocalization stringForKey:@"Updated.Failed"];
    updatedSuccess=[MCLocalization stringForKey:@"Updated.successfully"];
    saveFailed=[MCLocalization stringForKey:@"Save Failed"];
    saveSuccess=[MCLocalization stringForKey:@"Saved successfully"];
    _genderLabel.text=[MCLocalization stringForKey:@"GenderLabel"];
    _dobLabel.text=[MCLocalization stringForKey:@"DateOfBirthLabel"];
    _ageLabel.text=[MCLocalization stringForKey:@"AgeLabel"];
    _mobileLabel.text=[MCLocalization stringForKey:@"MobileLabel"];
    _tranfusion.text=[MCLocalization stringForKey:@"TransfusionLabel"];
    _emailLabel.text=[MCLocalization stringForKey:@"EmailLabel"];
    _surgeryLabel.text=[MCLocalization stringForKey:@"SurgeriesLabel"];
    yesStr=[MCLocalization stringForKey:@"Yes"];
    noStr=[MCLocalization stringForKey:@"No"];
    _attachment.text=[MCLocalization stringForKey:@"Attachment"];
    _medicalHistoryLabel.text=[MCLocalization stringForKey:@"Medical History"];
    _diagnosisLabel.text=[MCLocalization stringForKey:@"Diagnosis"];
    _uploadLabel.text=[MCLocalization stringForKey:@"upload"];
    _settingLabel.text=[MCLocalization stringForKey:@"Sittings"];
    _treatmentEnclosure.text=[MCLocalization stringForKey:@"Treatment Closure"];
    closureNote=[MCLocalization stringForKey:@"Add Closure Notes"];
    medicalNote=[MCLocalization stringForKey:@"Add Medical Notes"];
    diagnosisNote=[MCLocalization stringForKey:@"Add Diagnosis Notes"];
    _medicalDate.text=[MCLocalization stringForKey:@"Date"];
    _medicalTime.text=[MCLocalization stringForKey:@"Time"];
    _medicalMessage.text=[MCLocalization stringForKey:@"Message"];
    _diagnosisDate.text=[MCLocalization stringForKey:@"Date"];
    _diagnosisTime.text=[MCLocalization stringForKey:@"Time"];
    _diagnosismessage.text=[MCLocalization stringForKey:@"Message"];
    _patientDetailLabel.text=[MCLocalization stringForKey:@"Patient Details"];
    titleOfTreatment=[MCLocalization stringForKey:@"Title of the Treatment"];
    [_closeTreatmentClosure setTitle:[MCLocalization stringForKey:@"close"] forState:normal];
    [_saveTreatmentClosure setTitle:[MCLocalization stringForKey:@"Save"] forState:normal];
    [_exit setTitle:[MCLocalization stringForKey:@"Exit"] forState:normal];
    [_addMedical setTitle:[MCLocalization stringForKey:@"Add"] forState:normal];
    [_addDiagnosis setTitle:[MCLocalization stringForKey:@"Add"] forState:normal];
    [_cancelMedical setTitle:[MCLocalization stringForKey:@"Clear"] forState:normal];
    ok=[MCLocalization stringForKey:@"OK"];
    enterTreatmentClosure=[MCLocalization stringForKey:@"Please enter Treatment Closure Notes"];
    doYouWantToCloseTreatment=[MCLocalization stringForKey:@"Do you want to close the Treatment?"];
    treatmentTitlerequired=[MCLocalization stringForKey:@"Treatment Title  is required"];
    sittingStr=[MCLocalization stringForKey:@"Sitting"];
    closedSuccess=[MCLocalization stringForKey:@"Closed successfully"];
}
//for language popOver
-(IBAction)callMethodInContainerForLang:(id)sender{
    UINavigationController *nav=(UINavigationController*)self.parentViewController;
    NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
    BOOL status=[userdefault boolForKey:@"rememberMe"];
    ContainerViewController *contain;
    if (status) {
        contain=nav.viewControllers[0];
    }
    else contain=nav.viewControllers[1];
    [contain callForNavigationButton:@"language" withButton:sender];
}
//for slideout popOver
-(IBAction)callMethodInContainerForSlideOut:(id)sender{
    UINavigationController *nav=(UINavigationController*)self.parentViewController;
    NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
    BOOL status=[userdefault boolForKey:@"rememberMe"];
    ContainerViewController *contain;
    if (status) {
        contain =nav.viewControllers[0];
    }
    else contain=nav.viewControllers[1];
    [contain callForNavigationButton:@"slideout" withButton:sender];
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
    if ([DifferMetirialOrVzoneApi isEqualToString:@"vzone"]) {
        NSString *parameter=[NSString stringWithFormat:@"{\"request\":}}"];
        [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processGerms:responseObject];
            [[SeedSyncer sharedSyncer]saveResponse:[operation responseString] forIdentity:url];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:NO forKey:@"germs_FLAG"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    }else {
        [postman get:url withParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processGerms:responseObject];
            [[SeedSyncer sharedSyncer]saveResponse:[operation responseString] forIdentity:url];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:NO forKey:@"germs_FLAG"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
}

@end