#import "SearchPatientViewController.h"
#import "SearchPatientTableViewCell.h"
#import "DefaultValues.h"
#import "Constant.h"
#import "ContainerViewController.h"
@interface SearchPatientViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;

@property (strong, nonatomic) IBOutlet UITableView *patientListTableView;
@end

@implementation SearchPatientViewController
{
    DefaultValues *defaultValue;
    NSMutableArray *patentFilteredArray;
    Constant *constant;
    NSArray *patentnameArray;
    NSIndexPath *selectedIndexPath;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    defaultValue=[[DefaultValues alloc]init];
    constant=[[Constant alloc]init];
     [_searchTextField addTarget:self action:@selector(searchDoctorOnProfession) forControlEvents:UIControlEventEditingChanged];
    patentFilteredArray=[[NSMutableArray alloc]init];
    [constant spaceAtTheBeginigOfTextField:_searchTextField];
    _searchTextField.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Search"];
    _searchTextField.layer.cornerRadius=18;
    _searchTextField.layer.borderColor=[UIColor colorWithRed:0.004 green:0.216 blue:0.294 alpha:0.5].CGColor;
    _searchTextField.layer.borderWidth=1;
    selectedIndexPath=nil;
     [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background-Image-02.jpg"]]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self dummyData];
    NSIndexPath* selectedCellIndexPath= [NSIndexPath indexPathForRow:1 inSection:0];
    [self tableView:_patientListTableView didSelectRowAtIndexPath:selectedCellIndexPath];
//    [_patientListTableView selectRowAtIndexPath:selectedCellIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}
//TableView Number of section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}
//TableView Number of row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_searchTextField.text isEqualToString:@""]) {

        return patentnameArray.count+1;
    }
    else
        return patentFilteredArray.count+1;
}
//TableView cell 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchPatientTableViewCell *cell;
    if(indexPath.row==0){
    cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
    }
    else{
     cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
     if ([_searchTextField.text isEqualToString:@""]) {
    cell.patientNameLabel.text=patentnameArray[indexPath.row-1];
     }
    else cell.patientNameLabel.text=patentFilteredArray[indexPath.row-1];
    }
    [constant setFontForLabel:cell.patientNameLabel];
    cell.patientNameLabel.textColor=[UIColor whiteColor];
     tableView.tableFooterView=[UIView new];
     return cell;
}
//Row Height
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
//Cell Colour
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}
//Search
-(void)searchDoctorOnProfession{
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"self CONTAINS[cd]%@",_searchTextField.text];
    NSArray *array= [patentnameArray filteredArrayUsingPredicate:predicate];
    patentFilteredArray=[NSMutableArray arrayWithArray:array];
    [_patientListTableView reloadData];
    
}
//cell select
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ContainerViewController *containerVc=(ContainerViewController*)self.parentViewController;
    if (indexPath.row==0) {
        [containerVc ChangeTheContainerViewViewController];
    }
    else{
    SearchPatientTableViewCell *cell;
    if (selectedIndexPath) {
        cell=(SearchPatientTableViewCell*)[tableView cellForRowAtIndexPath:selectedIndexPath];
        cell.patientNameLabel.textColor=[UIColor whiteColor];
        cell.accessoryType=0;
        selectedIndexPath=nil;
    }
if (selectedIndexPath!=indexPath){
        cell=(SearchPatientTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    selectedIndexPath=indexPath;
    cell.patientNameLabel.textColor=[UIColor colorWithRed:0.7098 green:0.99 blue:0.98 alpha:1];
    cell.accessoryType=1;
    [containerVc passDataFromsearchPatientTableViewToPatient:cell.patientNameLabel.text];
    
    }
}
}
- (IBAction)popViewController:(id)sender {

}
-(void)dummyData{
patentnameArray =@[@"Michael Ethan",@"Tyler Aiden",@"Aiden Joshua",@"Joseph Noah",@"Anthony Daniel",@"Angel Alexander",@"Jacob Michael",@"Ethan Jose",@"Jackson Jose"];
    [_patientListTableView reloadData];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
@end
