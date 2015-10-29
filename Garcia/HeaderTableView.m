#import "HeaderTableView.h"
@implementation HeaderTableView
{
    NSMutableArray *sittingArray;
    NSIndexPath *selectedIndexPath;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])){
        UIView *subView = [[[NSBundle mainBundle] loadNibNamed:@"HeaderTableView"
                                                         owner:self
                                                       options:nil] objectAtIndex:0];
        [self addSubview: subView];
        subView.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *views = NSDictionaryOfVariableBindings(subView);
        
        NSArray *constrains = [NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[subView]-(0)-|"
                                                                      options:kNilOptions
                                                                      metrics:nil
                                                                        views:views];
        [self addConstraints:constrains];
        
        constrains = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[subView]-(0)-|"
                                                             options:kNilOptions
                                                             metrics:nil
                                                               views:views];
        [self addConstraints:constrains];
        sittingArray=[[NSMutableArray alloc]init];
        sittingArray=[@[@"Head",@"Interval",@"Notes",@"Completed"]mutableCopy];
        selectedIndexPath=nil;
        [_headerTableview reloadData];
    }
    return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return sittingArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewTableViewCell *cell = (CollectionViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"CollectionViewTableViewCell" owner:self options:nil];
        cell = _cell;
        _cell = nil;
    }
    cell.headLabel.text=sittingArray[indexPath.section];
    [cell.headIncreaseButton setImage:[UIImage imageNamed:@"Button-Collapse"] forState:normal];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([selectedIndexPath isEqual:indexPath]) {
      //  CollectionViewTableViewCell *cell = (CollectionViewTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//        cell.scanPointView.hidden=NO;
//        cell.scanPointViewHeight.constant=cell.scanPointView.scanPointTableView.contentSize.height;
//        return cell.scanPointView.scanPointTableView.contentSize.height+37;
            return 100;
    }
    else {
//        CollectionViewTableViewCell *cell = (CollectionViewTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//        cell.scanPointView.hidden=YES;
//        cell.scanPointViewHeight.constant=0;
        return 24;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewTableViewCell *cell = (CollectionViewTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([cell.headIncreaseButton.currentImage isEqual:[UIImage imageNamed:@"Button-Collapse"]]) {
        [self ChangeIncreaseDecreaseButtonImage:cell.headIncreaseButton];
            selectedIndexPath=indexPath;
    }
    else{
    [self ChangeIncreaseDecreaseButtonImage:cell.headIncreaseButton];
        cell.scanPointView.hidden=NO;
        selectedIndexPath=nil;
    }
    [tableView beginUpdates];
    [tableView endUpdates];
    [tableView reloadData];
    CGRect frame=_headerTableview.frame;
   frame.size.height=_headerTableview.contentSize.height;
    _headerTableview.frame=frame;
    [self.delegate headCellHeight];
    
}
-(void)ChangeIncreaseDecreaseButtonImage:(UIButton*)btn{
    if ([btn.currentImage isEqual:[UIImage imageNamed:@"Button-Collapse"]]) {
        [btn setImage:[UIImage imageNamed:@"Button-Expand"] forState:normal];
        
    }
    else  if ([btn.currentImage isEqual:[UIImage imageNamed:@"Button-Expand"]]) {
        [btn setImage:[UIImage imageNamed:@"Button-Collapse"] forState:normal];
    }
}
@end
