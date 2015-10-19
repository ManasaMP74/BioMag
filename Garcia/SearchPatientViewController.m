#import "SearchPatientViewController.h"
#import "SearchPatientTableViewCell.h"
#import "DefaultValues.h"
#import "Constant.h"
@interface SearchPatientViewController ()<UITableViewDataSource,UITableViewDelegate>
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
    [constant SetBorderForTextField:_searchTextField];
    selectedIndexPath=nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self dummyData];
}
//TableView Number of section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}
//TableView Number of row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_searchTextField.text isEqualToString:@""]) {

        return patentnameArray.count;
    }
    else
        return patentFilteredArray.count;
}
//TableView cell 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     SearchPatientTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
     if ([_searchTextField.text isEqualToString:@""]) {
    cell.patientNameLabel.text=patentnameArray[indexPath.row];
     }
    else cell.patientNameLabel.text=patentFilteredArray[indexPath.row];
    [constant setFontForLabel:cell.patientNameLabel];
    cell.patientNameLabel.textColor=[UIColor whiteColor];
     tableView.tableFooterView=[UIView new];
     return cell;
}
//Row Height
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
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
    cell.patientNameLabel.textColor=[UIColor colorWithRed:0.65 green:1 blue:0.96 alpha:1];
    cell.accessoryType=1;
    }
}
- (IBAction)popViewController:(id)sender {
}
-(void)dummyData{
patentnameArray =@[@"Michael Ethan",@"Tyler Aiden",@"Aiden Joshua",@"Joseph Noah",@"Anthony Daniel",@"Angel Alexander",@"Jacob Michael",@"Ethan Jose",@"Jackson Jose"];
}
@end
