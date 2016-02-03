#import "SlideOutTableViewController.h"
#import "SittingViewController.h"
#import "SWRevealViewController.h"
#import "SlideOutTableViewCell.h"
@interface SlideOutTableViewController ()<expandCellToGetSectionName,getSectionNameProtocol>

@end

@implementation SlideOutTableViewController
{
    NSIndexPath *selectedIndexpath;
    CGFloat cellHeight;
    NSString *selectedSection;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    selectedIndexpath=[NSIndexPath indexPathForRow:0 inSection:0];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SlideOutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.delegate=self;
    if (indexPath.row==0) {
        cell.label.text=@"Section(s)";
        if (selectedIndexpath==nil) {
            cell.sectionNameViewHeight.constant=0;
            cell.sectionNameXib.hidden=YES;
            cell.expandImageView.image=[UIImage imageNamed:@"Button-Collapse"];
        }else{
           cell.expandImageView.image=[UIImage imageNamed:@"Button-Expand"];
            [self getDataOfSectionName:cell];
        }
    }
    cell.sectionNameXib.delegateForGetName=self;
      return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (selectedIndexpath!=nil) {
        return cellHeight;
    }
   else return 35;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor clearColor];
}
-(void)expandCellToGetSectionName:(UITableViewCell *)cell{
    SlideOutTableViewCell *cell1=(SlideOutTableViewCell*)cell;
    NSIndexPath *indexPath=[self.tableView indexPathForCell:cell1];
    if (indexPath.row==0) {
        SlideOutTableViewCell *cell2=(SlideOutTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        if ([cell1.expandImageView.image isEqual:[UIImage imageNamed:@"Button-Expand"]]) {
            selectedIndexpath=nil;
        }
        else{
            [self getDataOfSectionName:cell2];
        }
    }else {
     selectedIndexpath=nil;
    }
    [self.tableView reloadData];
}
-(void)getDataOfSectionName:(UITableViewCell*)cell2{
    SlideOutTableViewCell *cell=(SlideOutTableViewCell*)cell2;
    cell.sectionNameViewHeight.constant=35;
    [cell.sectionNameXib reloadData:_allSectionNameArray];
    cell.sectionNameViewHeight.constant=[cell.sectionNameXib getHeightOfView];
    cellHeight=cell.sectionNameViewHeight.constant+35;
    cell.sectionNameXib.hidden=NO;
    selectedIndexpath=[NSIndexPath indexPathForRow:0 inSection:0];
}
-(void)getSectionName:(NSString *)str{
     selectedSection=str;
    [self performSegueWithIdentifier:@"sittingVc" sender:self];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    SittingViewController *sitting=segue.destinationViewController;
    NSArray *ar=[selectedSection componentsSeparatedByString:@"$"];
    sitting.sectionName=ar[1];
    sitting.SortType=ar[0];
}
@end
