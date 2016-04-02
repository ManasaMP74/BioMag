#import "SlideOutTableViewController.h"
#import "SittingViewController.h"
#import "SWRevealViewController.h"
#import "SlideOutTableViewCell.h"
#import "ToxicDeficiency.h"
#import "Postman.h"
#import "PostmanConstant.h"
#import "MBProgressHUD.h"
#import "SeedSyncer.h"
#import <MCLocalization/MCLocalization.h>
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
    NSArray *slideoutContentArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    postman=[[Postman alloc]init];
   }
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    toxicDeficiencyArray=_allToxicDeficiencyArray;
   selectedIndexpath=[NSIndexPath indexPathForRow:1 inSection:0];
   // slideoutContentArray=@[[MCLocalization stringForKey:@"Section(s)"],[MCLocalization stringForKey:@"Toxic & Deficiency"],[MCLocalization stringForKey:@"Add ScanPoint"],[MCLocalization stringForKey:@"Add CorrespondingPair"],[MCLocalization stringForKey:@"Add Anatomical Points"]];
      slideoutContentArray=@[[MCLocalization stringForKey:@"Add Anatomical Points"],[MCLocalization stringForKey:@"Section(s)"],[MCLocalization stringForKey:@"Toxic & Deficiency"]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return slideoutContentArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SlideOutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
      cell.label.text=slideoutContentArray[indexPath.row];
     cell.delegate=self;
    if (indexPath.row==1) {
        cell.sectionNameXib.delegateForGetName=self;
    }else if (indexPath.row==2) {
        cell.sectionNameXib.delegateForGetName=self;
    }
    if (indexPath.row==1 | indexPath.row==2) {
        if ([selectedIndexpath isEqual:indexPath]) {
            cell.expandImageView.image=[UIImage imageNamed:@"Button-Expand"];
            int index=(int)indexPath.row;
            if (indexPath.row==1) {
                [self getDataOfSectionName:cell withArray:_allSectionNameArray withIndex:index];
            }else  [self getDataOfSectionName:cell withArray:toxicDeficiencyArray withIndex:index];
        }else{
            cell.sectionNameViewHeight.constant=0;
            cell.sectionNameXib.hidden=YES;
            cell.expandImageView.image=[UIImage imageNamed:@"Button-Collapse"];
        }
    }
    else{
        cell.expandImageView.hidden=YES;
        cell.sectionNameViewHeight.constant=0;
        cell.sectionNameXib.hidden=YES;
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
    if (indexPath.row==0) {
        selectedIndexpath=nil;
        [self.tableView reloadData];
        UINavigationController *nav=(UINavigationController*)self.parentViewController;
        SWRevealViewController *reveal=(SWRevealViewController*)nav.parentViewController;
        SittingViewController *sitting=(SittingViewController*)reveal.childViewControllers[0];
        sitting.sectionName=@"";
        [sitting addAnatomicalPointFromSlideout];
    }
    else if (indexPath.row==1 | indexPath.row==2) {
    if ([cell1.expandImageView.image isEqual:[UIImage imageNamed:@"Button-Expand"]]) {
        selectedIndexpath=nil;
    }
    else{
        selectedIndexpath=indexPath;
        if (indexPath.row==1) [self getDataOfSectionName:cell2 withArray:_allSectionNameArray withIndex:indexPath.row];
        else if(indexPath.row==2) [self getDataOfSectionName:cell2 withArray:toxicDeficiencyArray withIndex:indexPath.row];
    }
    [self.tableView reloadData];
      }
     else{
        // [self getViewToAddSectionData:indexPath];
     }
}
-(void)getViewToAddSectionData:(NSIndexPath*)index
{
    UINavigationController *nav=(UINavigationController*)self.parentViewController;
    SWRevealViewController *reveal=(SWRevealViewController*)nav.parentViewController;
    SittingViewController *sitting=(SittingViewController*)reveal.childViewControllers[0];
    if (index.row==2) {
        [sitting addSectionDataViewInSitting:@"scanpoint"];
    }else if (index.row==3){
        [sitting addSectionDataViewInSitting:@"correspondingpair"];
    }else if (index.row==4){
        [sitting addSectionDataViewInSitting:@"anatomicalPoint"];
    }
}


//get data of section name
-(void)getDataOfSectionName:(UITableViewCell*)cell2 withArray:(NSArray*)array withIndex:(int)i{
    SlideOutTableViewCell *cell=(SlideOutTableViewCell*)cell2;
    cell.sectionNameViewHeight.constant=35;
    [cell.sectionNameXib reloadData:array withIndex:i];
    cell.sectionNameViewHeight.constant=[cell.sectionNameXib getHeightOfView];
    cellHeight=cell.sectionNameViewHeight.constant+35;
    cell.sectionNameXib.hidden=NO;
}
//get section name
-(void)getSectionName:(NSString *)str withIndex:(NSIndexPath *)index withCellIndex:(int)i{
    if (i==1) {
        selectedSection=str;
        selectedCell=index;
        selectedRow=i;
    }
    else if (i==2){
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
//set data to sitting view
-(void)setTheDataToSittingVC:(SittingViewController*)sitting{
    if (selectedRow==1) {
        sitting.selectedIndexPathOfSectionInSlideOut=selectedCell;
        sitting.SortType=selectedSection;
        sitting.toxicDeficiencyString=@"";
    }
    else if (selectedRow==2){
        sitting.selectedIndexPathOfSectionInSlideOut=selectedCell;
        sitting.toxicDeficiencyString=selectedSection;
    }
    sitting.editOrAddSitting=@"n";
}
@end
