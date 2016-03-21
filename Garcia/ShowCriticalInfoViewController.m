#import "ShowCriticalInfoViewController.h"
#import "ShowCriticalInfoListModel.h"
#import "CriticalTreatmentInfoViewController.h"
#import <MCLocalization/MCLocalization.h>
#import "ShowDetailOfCriticalInfoViewController.h"
@interface ShowCriticalInfoViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ShowCriticalInfoViewController
{
    NSMutableArray *completeCriticalDetailArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    completeCriticalDetailArray =[[NSMutableArray alloc]init];
     [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background-Image-1.jpg"]]];
    [self navigationItemMethod];
     [_criticalInfoLabel setTitle:[MCLocalization stringForKey:@"Critical TreatmentInfo"] forState:normal];
     [_addCriticalInfo setTitle:[MCLocalization stringForKey:@"Add Critical TreatmentInfo"] forState:normal];
    [self getDetailOfCriticalInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
-(void)getDetailOfCriticalInfo{
    for (NSDictionary *dict in _CriticalInfoArray) {
        ShowCriticalInfoListModel *model=[[ShowCriticalInfoListModel alloc]init];
        model.idvalue=dict[@"Id"];
         model.code=dict[@"Code"];
         model.summary=dict[@"Summary"];
        [completeCriticalDetailArray addObject:model];
    }
    [_tableview reloadData];
    [_scrollView layoutIfNeeded];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return completeCriticalDetailArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    UILabel *label=(UILabel*)[cell viewWithTag:10];
    ShowCriticalInfoListModel *model=completeCriticalDetailArray[indexPath.row];
    label.text=model.summary;
    tableView.tableFooterView=[UIView new];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 41;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ShowCriticalInfoListModel *model=completeCriticalDetailArray[indexPath.row];
    ShowDetailOfCriticalInfoViewController *critical=[self.storyboard instantiateViewControllerWithIdentifier:@"ShowDetailOfCriticalInfoViewController"];
    critical.criticalInfoModel=model;
    [self.navigationController pushViewController:critical animated:YES];
}
- (IBAction)addCriticalInfo:(id)sender {
    CriticalTreatmentInfoViewController *critical =[self.storyboard instantiateViewControllerWithIdentifier:@"CriticalTreatmentInfoViewController"];

    critical.summary=@"";
    critical.descriptionvalue=@"";
     critical.differOfAddOrEdit=@"add";
    [self.navigationController pushViewController:critical animated:YES];
}
-(void)navigationItemMethod{
    UIImage* image = [UIImage imageNamed:@"Back button.png"];
    CGRect frameimg1 = CGRectMake(100, 0, image.size.width+30, image.size.height);
    UIButton *button=[[UIButton alloc]initWithFrame:frameimg1];
    [button setImage:image forState:UIControlStateNormal];
    UIBarButtonItem *barItem=[[UIBarButtonItem alloc]initWithCustomView:button];
    UIBarButtonItem *negativeSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpace.width=-25;
    self.navigationItem.leftBarButtonItems=@[negativeSpace,barItem];
    [button addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
     self.title=[MCLocalization stringForKey:@"Share Critical Treatment Info"];
}
-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
