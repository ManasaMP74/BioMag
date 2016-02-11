#import "PopOverViewController.h"
@interface PopOverViewController ()

@end

@implementation PopOverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_buttonName isEqualToString:@"language"]) {
         return _lagArray.count;
    }
    else return _slideoutImageArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([_buttonName isEqualToString:@"language"]) {
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    UILabel *label=(UILabel*)[cell viewWithTag:10];
    lagModel *model=_lagArray[indexPath.row];
    label.text=model.name;
    return cell;
    }else{
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
        UILabel *label=(UILabel*)[cell viewWithTag:10];
        if (indexPath.row!=0) {
             label.text=_slideoutNameArray[indexPath.row-1];
        }
        UIImageView *im=(UIImageView*)[cell viewWithTag:20];
        im.image=[UIImage imageNamed:_slideoutImageArray[indexPath.row]];
        return cell;

    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     if ([_buttonName isEqualToString:@"language"]) {
    [self.delegate selectedObject:_lagArray[indexPath.row]];
     }else
     {
         if (indexPath.row>0) {
              [self.delegate selectedSlideOutObject:_slideoutNameArray[indexPath.row-1]];
         }
     }
}
-(float)getHeightOfTableView{
    [self.tableView reloadData];
    return self.tableView.contentSize.height;
}
@end
