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
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationController.navigationItem.hidesBackButton=YES;
    defaultValue=[[DefaultValues alloc]init];
    constant=[[Constant alloc]init];
     [_searchTextField addTarget:self action:@selector(searchDoctorOnProfession) forControlEvents:UIControlEventEditingChanged];
    patentFilteredArray=[[NSMutableArray alloc]init];
    [constant spaceAtTheBeginigOfTextField:_searchTextField];
    _searchTextField.attributedPlaceholder=[constant textFieldPlaceHolderText:@"Search"];
    [constant SetBorderForTextField:_searchTextField];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    defaultValue=[[DefaultValues alloc]init];
    [_patientListTableView reloadData];
    
}
//TableView Number of section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}
//TableView Number of row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_searchTextField.text isEqualToString:@""]) {

        return defaultValue.patentnameArray.count;
    }
    else
        return patentFilteredArray.count;
}
//TableView cell 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     SearchPatientTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
     if ([_searchTextField.text isEqualToString:@""]) {
    cell.patientNameLabel.text=defaultValue.patentnameArray[indexPath.row];
     }
    else cell.patientNameLabel.text=patentFilteredArray[indexPath.row];
    [constant setFontForLabel:cell.patientNameLabel];
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
    NSArray *array= [defaultValue.patentnameArray filteredArrayUsingPredicate:predicate];
    patentFilteredArray=[NSMutableArray arrayWithArray:array];
    [_patientListTableView reloadData];
    
}
@end
