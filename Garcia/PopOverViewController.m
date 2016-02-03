#import "PopOverViewController.h"

@interface PopOverViewController ()

@end

@implementation PopOverViewController
{
    NSMutableArray *languageArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    languageArray =[[NSMutableArray alloc]init];;
    [languageArray addObject:@"English"];
    [languageArray addObject:@"kannada"];
    [languageArray addObject:@"hindi"];
    [languageArray addObject:@"telgu"];
    [languageArray addObject:@"tamil"];
    [languageArray addObject:@"spanish"];
    [languageArray addObject:@"japan"];
    [languageArray addObject:@"English"];
    [languageArray addObject:@"kannada"];
    [languageArray addObject:@"hindi"];
    [languageArray addObject:@"telgu"];
    [languageArray addObject:@"tamil"];
    [languageArray addObject:@"spanish"];
    [languageArray addObject:@"japan"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return languageArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    UILabel *label=(UILabel*)[cell viewWithTag:10];
    label.text=languageArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate selectedObject];
}
-(float)getHeightOfTableView{
    [self.tableView reloadData];
    return self.tableView.contentSize.height;
}
@end
