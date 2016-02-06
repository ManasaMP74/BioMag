#import "HeaderTableVIew.h"
#import "HeaderModelClass.h"
@implementation HeaderTableVIew
{
    UIView *view;
    NSMutableArray *selectedSectionNameArray,*allBiamagneticArray,*completeDetailOfSectionArray;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        view=[[[NSBundle mainBundle]loadNibNamed:@"HeaderTableVIew" owner:self options:nil]objectAtIndex:0];
        [self addSubview:view];
        view.translatesAutoresizingMaskIntoConstraints=NO;
        NSDictionary *subview=NSDictionaryOfVariableBindings(view);
        NSArray *constraints=[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[view]-(0)-|" options:kNilOptions metrics:nil views:subview];
        [self addConstraints:constraints];
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[view]-(0)-|"
                                                              options:kNilOptions
                                                              metrics:nil
                                                                views:subview];
        [self addConstraints:constraints];
        selectedSectionNameArray= [[NSMutableArray alloc]init];
        completeDetailOfSectionArray=[[NSMutableArray alloc]init];
        allBiamagneticArray= [[NSMutableArray alloc]init];
    }
    return self;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_model.selectedHeaderIndexpath.count>0) {
        if (section<selectedSectionNameArray.count-2) {
            NSString *str=_model.selectedHeaderIndexpath[section];
            NSArray *ar=[str componentsSeparatedByString:@"-"];
            if (section==[ar[1] integerValue]) {
                return [self getNumberOfRows:section];
            }else return 1;
        }
        else return 1;
    }
    else return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return selectedSectionNameArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        HeaderTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell==nil) {
            _headerCell=[[[NSBundle mainBundle]loadNibNamed:@"HeaderTableViewCell" owner:self options:nil]lastObject];
            cell=_headerCell;
            _headerCell=nil;
        }
        cell.delegate=self;
        if (indexPath.section<selectedSectionNameArray.count-2) {
            cell.headerLabel.text=[self nameForCell:indexPath];
        }else  cell.headerLabel.text=selectedSectionNameArray[indexPath.section];
       
        if (indexPath.section==selectedSectionNameArray.count-1) {
            cell.headerImageView.hidden=NO;
            cell.priceLabel.hidden=YES;
            cell.headerImageViewWidth.constant=35;
            cell.HeaderImageViewHeight.constant=15;
            if ([_model.completed intValue]==0) {
                cell.headerImageView.image=[UIImage imageNamed:@"Button-off"];
            }else  cell.headerImageView.image=[UIImage imageNamed:@"Button-on"];
        }else if (indexPath.section==selectedSectionNameArray.count-2) {
            cell.headerImageView.hidden=YES;
            cell.priceLabel.hidden=NO;
            cell.priceLabel.text=_model.price;
            
        }else{
            cell.headerImageView.hidden=NO;
            cell.priceLabel.hidden=YES;
            cell.HeaderImageViewHeight.constant=18;
            cell.headerImageViewWidth.constant=18;
            if (_model.selectedHeaderIndexpath.count>0) {
                for (NSString *i in _model.selectedHeaderIndexpath) {
                    if ([i isEqual:[NSString stringWithFormat:@"%d-%d",indexPath.row,indexPath.section]]) {
                        cell.headerImageView.image=[UIImage imageNamed:@"Button-Collapse"];
                    }else  cell.headerImageView.image=[UIImage imageNamed:@"Button-Expand"];
                }
            }else  cell.headerImageView.image=[UIImage imageNamed:@"Button-Expand"];
        }
        return cell;
    }else{
        ScanPointTableViewCell *cell1=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (cell1==nil) {
            _scapointCell=[[[NSBundle mainBundle]loadNibNamed:@"ScanPointTableViewCell" owner:self options:nil]objectAtIndex:0];
            cell1=_scapointCell;
            _scapointCell=nil;
        }
        cell1.delegate=self;
        cell1.scanpointLabel.text=[self nameForCell:indexPath];
        if (_model.selectedHeaderIndexpath.count>0) {
            for (NSIndexPath *i in _model.selectedHeaderIndexpath) {
                if ([i isEqual:indexPath]) {
                    cell1.scanpointImageView.image=[UIImage imageNamed:@"Button-Expand"];
                }else  cell1.scanpointImageView.image=[UIImage imageNamed:@"Button-Collapse"];
            }
        }else  cell1.scanpointImageView.image=[UIImage imageNamed:@"Button-Expand"];
        return cell1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
-(NSString*)nameForCell:(NSIndexPath*)indexPath{
    NSString *str=selectedSectionNameArray[indexPath.section];
    NSDictionary *dict=completeDetailOfSectionArray[indexPath.section];
    NSArray *ar=dict[str];
    NSDictionary *dict1=ar[indexPath.row];
    if (indexPath.row==0) {
        return dict1[@"SectionName"];
    }else return dict1[@"ScanPointName"];

}
-(int)getNumberOfRows:(NSInteger)indexPath{
    NSString *str=selectedSectionNameArray[indexPath];
    NSDictionary *dict=completeDetailOfSectionArray[indexPath];
    NSArray *ar=dict[str];
    return ar.count;
}
-(void)selectedHeaderCell:(UITableViewCell *)cell{
    HeaderTableViewCell *cell1=(HeaderTableViewCell*)cell;
    NSIndexPath *indexPath=[self.tableview indexPathForCell:cell1];
    NSString *str=[NSString stringWithFormat:@"%d-%d",indexPath.row,indexPath.section];
    if (![_model.selectedHeaderIndexpath containsObject:str]) {
        [self.delegate selectedCell:str];
    }else[self.delegate deselectedCell:str];
}
-(void)selectedScanPoint:(UITableViewCell *)cell{
    ScanPointTableViewCell *cell1=(ScanPointTableViewCell*)cell;
    NSIndexPath *indexPath=[self.tableview indexPathForCell:cell1];
    NSString *str=[NSString stringWithFormat:@"%d-%d",indexPath.row,indexPath.section];
    if (![_model.selectedHeaderIndexpath containsObject:str]) {
        [self.delegate selectedCell:str];
    }else[self.delegate deselectedCell:str];
}
-(void)gettheSection{
    [selectedSectionNameArray removeAllObjects];
     [completeDetailOfSectionArray removeAllObjects];
    for (NSDictionary *dict in _model.anotomicalPointArray) {
        if (![selectedSectionNameArray containsObject:dict[@"SectionCode"]]) {
            if (dict[@"SectionCode"]!=nil) {
                [selectedSectionNameArray addObject:dict[@"SectionCode"]];
            }
        }
    }
    int i=0;
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    while (i==selectedSectionNameArray.count-1) {
    NSMutableArray *ar=[[NSMutableArray alloc]init];
    for(NSDictionary *dict in _model.anotomicalPointArray){
        for (NSString *str in selectedSectionNameArray) {
            if ([dict[@"SectionCode"] isEqual:str]) {
                [ar addObject:dict];
            }
        }
    }
        NSString *str=selectedSectionNameArray[i];
        dict[str]=ar;
        [completeDetailOfSectionArray addObject:dict];
        i++;
    }
    [selectedSectionNameArray addObject:@"Price"];
    [selectedSectionNameArray addObject:@"Completed"];
   }
-(float)getTHeHeightOfTableVIew{
    [_tableview reloadData];
    CGRect frame=_tableview.frame;
    frame.size.height=_tableview.contentSize.height;
    _tableview.frame=frame;
    return _tableview.contentSize.height;

}
@end
