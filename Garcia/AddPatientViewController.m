#import "AddPatientViewController.h"
#import "Constant.h"
#import "ContainerViewController.h"
#import "DatePicker.h"
#import "PlaceholderTextView.h"
@interface AddPatientViewController ()<datePickerProtocol,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *nameTF;
@property (strong, nonatomic) IBOutlet UITextField *genderTF;
@property (strong, nonatomic) IBOutlet UITextField *maritialStatus;
@property (strong, nonatomic) IBOutlet UITextField *dateOfBirthTF;
@property (strong, nonatomic) IBOutlet UITextField *mobileNoTF;
@property (strong, nonatomic) IBOutlet UITextField *emailTF;
@property (strong, nonatomic) IBOutlet UITableView *gendertableview;
@property (strong, nonatomic) IBOutlet UITableView *maritialTableView;
@property (strong, nonatomic) IBOutlet PlaceholderTextView *addressTextView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *addView;
@property (strong, nonatomic) IBOutlet UIImageView *patientImageView;
- (IBAction)hideKeyboard:(UIControl *)sender;
@end

@implementation AddPatientViewController
{
    Constant *constant;
    NSArray *genderArray,*MaritialStatusArray;
    DatePicker *datePicker;
    UIControl *activeField;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    constant=[[Constant alloc]init];
    [self textFieldLayer];
    genderArray=@[@"Male",@"Female"];
    MaritialStatusArray=@[@"Single",@"Married"];
    UINavigationController *nav=(UINavigationController*)self.parentViewController;
    if (nav.parentViewController==NULL) {
         self.title=@"Add Patient";
    }
    else{
      ContainerViewController *containerVC=(ContainerViewController*)nav.parentViewController;
        [containerVC setTitle:@"Add Patient"];
    }
     [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background-Image-01.jpg"]]];
     [self registerForKeyboardNotifications];
     _addressTextView.placeholder=@"Address";
    self.addressTextView.delegate=self;
   // UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getImage)];
    //[_patientImageView addGestureRecognizer:tap];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
//cancel
- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//Save the data
- (IBAction)save:(id)sender {
[self.navigationController popViewControllerAnimated:YES];
}
//maritialStatus field
- (IBAction)maritalStatus:(id)sender {
    _gendertableview.hidden=YES;
    _maritialTableView.hidden=NO;
    [_maritialTableView reloadData];
}
//DateOfBirth Field
- (IBAction)dateOfBirth:(id)sender {
    _gendertableview.hidden=YES;
    _maritialTableView.hidden=YES;
    if(datePicker==nil)
      datePicker= [[DatePicker alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+100, self.view.frame.origin.y+230,self.view.frame.size.width-200,230)];
    [datePicker alphaViewInitialize];
    datePicker.delegate=self;
}
-(void)selectingDatePicker:(NSString *)date{
    _dateOfBirthTF.text=date;
}

//gender Field
- (IBAction)gender:(id)sender {
    _gendertableview.hidden=NO;
    _maritialTableView.hidden=YES;
    [_gendertableview reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
//TableView Number of row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    if ([tableView isEqual:self.gendertableview])
    {
        return genderArray.count;
        
    }
    else if ([tableView isEqual:self.maritialTableView])
        return MaritialStatusArray.count;
    else
        return 10;
        
}
//TableView cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if ([tableView isEqual:self.gendertableview]) {
        cell.textLabel.text=genderArray[indexPath.row];
        [constant setFontForLabel:cell.textLabel];
    }
    else if ([tableView isEqual:self.maritialTableView]){
        cell.textLabel.text=MaritialStatusArray[indexPath.row];
        [constant setFontForLabel:cell.textLabel];
    }
    else {
        UILabel *label=(UILabel*)[cell viewWithTag:10];
        [constant setFontForLabel:label];
    }
    tableView.tableFooterView=[UIView new];
    return cell;
    
}
//select tableviewContent
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.gendertableview isEqual:tableView ])
    {
        
        _genderTF.text=genderArray[indexPath.row];
        _gendertableview.hidden=YES;
    }
    else if([self.maritialTableView isEqual:tableView ])
    {
        _maritialStatus.text=MaritialStatusArray[indexPath.row];
        _maritialTableView.hidden=YES;
    }
}
//cell Color
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
   [cell setBackgroundColor:[UIColor colorWithRed:0.73 green:0.76 blue:0.91 alpha:1]];
}
//Hide KeyBoard
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
//textField Begin Editing
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    _maritialTableView.hidden=YES;
    _gendertableview.hidden=YES;
      activeField = textField;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}
//set layesr for TextField and placeHolder
-(void)textFieldLayer{
   // _patientImageView.layer.cornerRadius=_patientImageView.frame.size.width/2;
  //  _patientImageView.clipsToBounds=YES;
    _nameTF.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Name"];
    _emailTF.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Email"];
    _genderTF.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Gender"];
    _mobileNoTF.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Mobile"];
        _maritialStatus.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Marital Status"];
    _dateOfBirthTF.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Date Of Birth"];
    [constant spaceAtTheBeginigOfTextField:_genderTF];
    [constant spaceAtTheBeginigOfTextField:_emailTF];
    [constant spaceAtTheBeginigOfTextField:_nameTF];
    [constant spaceAtTheBeginigOfTextField:_maritialStatus];
    [constant spaceAtTheBeginigOfTextField:_dateOfBirthTF];
    [constant spaceAtTheBeginigOfTextField:_mobileNoTF];
    [constant SetBorderForTextField:_genderTF];
    [constant SetBorderForTextField:_mobileNoTF];
    [constant SetBorderForTextField:_maritialStatus];
    [constant SetBorderForTextField:_emailTF];
    [constant SetBorderForTextview:_addressTextView];
    [constant SetBorderForTextField:_nameTF];
    [constant SetBorderForTextField:_dateOfBirthTF];
    [constant setFontFortextField:_nameTF];
    [constant setFontFortextField:_genderTF];
    [constant setFontFortextField:_emailTF];
    [constant setFontFortextField:_maritialStatus];
    [constant setFontFortextField:_dateOfBirthTF];
    [constant setFontFortextField:_mobileNoTF];
     _addressTextView.textContainerInset = UIEdgeInsetsMake(10,5,10, 10);
    self.addressTextView.backgroundColor=[UIColor whiteColor];
}
//Move the TextField Up
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
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:activeField.frame animated:YES];
    }
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets =UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
}
//TextVie Delegate Method
- (void)textViewDidBeginEditing:(UITextView *)textView{
    _maritialTableView.hidden=YES;
    _gendertableview.hidden=YES;
    //activeField = textView;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    activeField = nil;
}

- (IBAction)hideKeyboard:(UIControl *)sender
{
    [self.view endEditing:YES];
    _maritialTableView.hidden=YES;
    _gendertableview.hidden=YES;
}
-(void)getImage{
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate=self;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *profileImage =info[UIImagePickerControllerOriginalImage];
    _patientImageView.image=profileImage;
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
   // containerVC.viewControllerDiffer=@"Edit";
}
@end
