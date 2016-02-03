#import "SlideOutTableViewController.h"
#import "SittingViewController.h"
#import "SWRevealViewController.h"
#import "SlideOutTableViewCell.h"
#import "ToxicDeficiency.h"
#import "Postman.h"
#import "PostmanConstant.h"
#import "MBProgressHUD.h"
#import "SeedSyncer.h"
@interface SlideOutTableViewController ()<expandCellToGetSectionName,getSectionNameProtocol>

@end

@implementation SlideOutTableViewController
{
    NSIndexPath *selectedIndexpath,*selectedCell;
    CGFloat cellHeight;
    NSString *selectedSection;
    Postman *postman;
    NSArray *toxicDeficiencyArray;
    int selectedRow;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    postman=[[Postman alloc]init];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    toxicDeficiencyArray=_allToxicDeficiencyArray;
    selectedIndexpath=[NSIndexPath indexPathForRow:0 inSection:0];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SlideOutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.delegate=self;
    if (indexPath.row==0) {
        cell.label.text=@"Section(s)";
        cell.sectionNameXib.delegateForGetName=self;
    }if (indexPath.row==1) {
        cell.label.text=@"Toxic & Deficiency";
        cell.sectionNameXib.delegateForGetName=self;
    }
    if ([selectedIndexpath isEqual:indexPath]) {
        cell.expandImageView.image=[UIImage imageNamed:@"Button-Expand"];
        int index=(int)indexPath.row;
        if (indexPath.row==0) {
            [self getDataOfSectionName:cell withArray:_allSectionNameArray withIndex:index];
        }else  [self getDataOfSectionName:cell withArray:toxicDeficiencyArray withIndex:index];
    }else{
        cell.sectionNameViewHeight.constant=0;
        cell.sectionNameXib.hidden=YES;
        cell.expandImageView.image=[UIImage imageNamed:@"Button-Collapse"];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (selectedIndexpath!=nil) {
        if ([selectedIndexpath isEqual:indexPath]) {
            return cellHeight;
        }
        else return 35;
    }
    else return 35;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor clearColor];
}
-(void)expandCellToGetSectionName:(UITableViewCell *)cell{
    SlideOutTableViewCell *cell1=(SlideOutTableViewCell*)cell;
    NSIndexPath *indexPath=[self.tableView indexPathForCell:cell1];
    SlideOutTableViewCell *cell2=(SlideOutTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    if ([cell1.expandImageView.image isEqual:[UIImage imageNamed:@"Button-Expand"]]) {
        selectedIndexpath=nil;
    }
    else{
        selectedIndexpath=indexPath;
        if (indexPath.row==0) [self getDataOfSectionName:cell2 withArray:_allSectionNameArray withIndex:indexPath.row];
        else if(indexPath.row==1) [self getDataOfSectionName:cell2 withArray:toxicDeficiencyArray withIndex:indexPath.row];
    }
    [self.tableView reloadData];
}
-(void)getDataOfSectionName:(UITableViewCell*)cell2 withArray:(NSArray*)array withIndex:(int)i{
    SlideOutTableViewCell *cell=(SlideOutTableViewCell*)cell2;
    cell.sectionNameViewHeight.constant=35;
    [cell.sectionNameXib reloadData:array withIndex:i];
    cell.sectionNameViewHeight.constant=[cell.sectionNameXib getHeightOfView];
    cellHeight=cell.sectionNameViewHeight.constant+35;
    cell.sectionNameXib.hidden=NO;
}
-(void)getSectionName:(NSString *)str withIndex:(NSIndexPath *)index withCellIndex:(int)i{
    if (i==0) {
        selectedSection=str;
        selectedCell=index;
        selectedRow=i;
    }
    else if (i==1){
        selectedSection=str;
        selectedCell=index;
        selectedRow=i;
    }
    UINavigationController *nav=(UINavigationController*)self.parentViewController;
    SWRevealViewController *reveal=(SWRevealViewController*)nav.parentViewController;
    SittingViewController *sitting=(SittingViewController*)reveal.childViewControllers[0];
    [self setTheDataToSittingVC:sitting];
    [sitting sittingFromSlideOut];
}
-(void)setTheDataToSittingVC:(SittingViewController*)sitting{
    if (selectedRow==0) {
        sitting.selectedIndexPathOfSectionInSlideOut=selectedCell;
        sitting.SortType=selectedSection;
        sitting.toxicDeficiencyString=@"";
    }
    else if (selectedRow==1){
        sitting.selectedIndexPathOfSectionInSlideOut=selectedCell;
        sitting.toxicDeficiencyString=selectedSection;
    }
    sitting.editOrAddSitting=@"n";
}
@end
