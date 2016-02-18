#import "PopOverViewController.h"
@interface PopOverViewController ()

@end

@implementation PopOverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.borderColor=[UIColor clearColor].CGColor;
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
             label.text=_slideoutNameArray[indexPath.row];
        UIImageView *im=(UIImageView*)[cell viewWithTag:20];
        im.image=[UIImage imageNamed:_slideoutImageArray[indexPath.row]];
        if (indexPath.row==0) {
            label.textColor=[UIColor blackColor];
        }
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     if ([_buttonName isEqualToString:@"language"]) {
    [self.delegate selectedObject:indexPath.row];
     }else
     {
         if (indexPath.row>0) {
              [self.delegate selectedSlideOutObject:indexPath.row];
         }
     }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_buttonName isEqualToString:@"language"]) {
    cell.backgroundColor=[UIColor clearColor];
    }else{
        if (indexPath.row==0) {
            cell.backgroundColor=[UIColor colorWithRed:0.808 green:0.886 blue:0.918 alpha:1];
        }else  cell.backgroundColor=[UIColor clearColor];
    }
}
-(float)getHeightOfTableView{
    [self.tableView reloadData];
    return self.tableView.contentSize.height;
}
@end
