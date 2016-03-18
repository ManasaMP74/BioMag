#import "ShowCriticalInfoViewController.h"
#import "ShowCriticalInfoListModel.h"
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
}
@end
