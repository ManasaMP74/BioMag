#import "HeaderTableView.h"
@implementation HeaderTableView
{
    NSMutableArray *sittingArray;
    NSIndexPath *selectedHeaderIndexPath;
    NSMutableArray *scanPointArray,*selectedScanPointIndexPath;
    CGFloat correspondingViewHeight;
    NSMutableArray *selectedScanPoint;
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
        scanPointArray=[[NSMutableArray alloc]init];
        sittingArray=[@[@"Head",@"Interval",@"Notes",@"Completed"]mutableCopy];
        scanPointArray=[@[@"Eye (Scan Point)",@"Ear (Scan Point)",@"Nose (Scan Point)"]mutableCopy];
        selectedHeaderIndexPath=nil;
        selectedScanPointIndexPath=[[NSMutableArray alloc]init];
        [_headerTableview reloadData];
    }
    return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (selectedHeaderIndexPath != nil) {
        if (selectedHeaderIndexPath.section == section) {
            return scanPointArray.count+1;
        }
        else
            return 1;
    }
    else
        return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return sittingArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        CollectionViewTableViewCell *cell = (CollectionViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"CollectionViewTableViewCell" owner:self options:nil];
            cell = _cell;
            _cell = nil;
        }
        cell.headLabel.text=sittingArray[indexPath.section];
        if (indexPath.section==sittingArray.count-1) {
            cell.userInteractionEnabled=NO;
            cell.headIncreaseButton.hidden=YES;
            cell.switchImageView.hidden=NO;
            cell.intervalLabel.hidden=YES;
        }
        else if (indexPath.section==sittingArray.count-3) {
            cell.userInteractionEnabled=NO;
            cell.headIncreaseButton.hidden=YES;
            cell.switchImageView.hidden=YES;
            cell.intervalLabel.hidden=NO;
        }
        else {
            cell.userInteractionEnabled=YES;
            cell.headIncreaseButton.hidden=NO;
            cell.switchImageView.hidden=YES;
            cell.intervalLabel.hidden=YES;
        }
        return cell;
    }
    else{
        ScanPoinTableViewCell *cell = (ScanPoinTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"ScanPointTableViewCell" owner:self options:nil];
            cell = _scanPointCell;
            _scanPointCell = nil;
        }
        if (selectedScanPointIndexPath.count<1) {
            cell.correspondingViewHeight=0;
            cell.correspondingView.hidden=YES;
        }
        cell.scanpointLabel.text=scanPointArray[indexPath.row-1];
        cell.delegate=self;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor colorWithRed:0.839 green:0.847 blue:0.94 alpha:1];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (selectedScanPointIndexPath.count>0) {
        if ([selectedScanPointIndexPath containsObject:indexPath]) {
            return correspondingViewHeight+32;
        }
        else
            return 32;
        }
    else
    return 32;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
       CollectionViewTableViewCell *cell = (CollectionViewTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([cell.headIncreaseButton.currentBackgroundImage isEqual:[UIImage imageNamed:@"Button-Collapse"]]) {
        [self ChangeIncreaseDecreaseButtonImage:cell];
        if (indexPath.section<sittingArray.count-3) {
            selectedHeaderIndexPath=indexPath;
            [tableView reloadData];
            CGRect frame=_headerTableview.frame;
            frame.size.height=_headerTableview.contentSize.height;
            _headerTableview.frame=frame;
            [self.delegate increaseHeadCellHeight:_headerTableview.contentSize.height withSelectedScanPoint:nil];
        }
    }
    else{
        [self ChangeIncreaseDecreaseButtonImage:cell];
        if (indexPath.section<sittingArray.count-3) {
            selectedHeaderIndexPath=nil;
            [selectedScanPointIndexPath removeAllObjects];
            [tableView reloadData];
            CGRect frame=_headerTableview.frame;
            frame.size.height=_headerTableview.contentSize.height;
            _headerTableview.frame=frame;
            [self.delegate decreaseHeadCellHeight:_headerTableview.contentSize.height withSelectedScanPoint:nil];
        }
    }
 }
}
//ScanPoint Delegate Method
-(void)selectedScanPoint:(UITableViewCell *)cell{
    NSIndexPath *indexPath=[_headerTableview indexPathForCell:cell];
        ScanPoinTableViewCell *scanCell=(ScanPoinTableViewCell*)[_headerTableview cellForRowAtIndexPath:indexPath];
        if ([scanCell.sacnPointImageView.currentBackgroundImage isEqual:[UIImage imageNamed:@"Button-Collapse"]]) {
            [self ChangeIncreaseDecreaseButtonImage1:scanCell];
            [selectedScanPointIndexPath addObject: indexPath];
          //  NSLog(@"%@",selectedScanPointIndexPath);
            correspondingViewHeight = [scanCell.correspondingView corespondingCellHeight];
            scanCell.correspondingView.hidden = NO;
            scanCell.correspondingViewHeight.constant=correspondingViewHeight;
            [_headerTableview reloadData];
            CGRect frame=_headerTableview.frame;
            frame.size.height=_headerTableview.contentSize.height;
            _headerTableview.frame=frame;
            [self.delegate increaseHeadCellHeight:_headerTableview.contentSize.height withSelectedScanPoint:selectedScanPointIndexPath];
        }
        else{
            [self ChangeIncreaseDecreaseButtonImage1:scanCell];
           [selectedScanPointIndexPath removeObject: indexPath];
            scanCell.correspondingView.hidden=YES;
            scanCell.correspondingViewHeight.constant=0;
            [_headerTableview reloadData];
            CGRect frame=_headerTableview.frame;
            frame.size.height=_headerTableview.contentSize.height;
            _headerTableview.frame=frame;
            [self.delegate decreaseHeadCellHeight:_headerTableview.contentSize.height withSelectedScanPoint:selectedScanPointIndexPath];
            }
}
//Change the Header image
-(void)ChangeIncreaseDecreaseButtonImage:(CollectionViewTableViewCell*)cell{
    if ([cell.headIncreaseButton.currentBackgroundImage isEqual:[UIImage imageNamed:@"Button-Collapse"]]) {
        [cell.headIncreaseButton setBackgroundImage:[UIImage imageNamed:@"Button-Expand"] forState:UIControlStateNormal];
        
    }
    else  if ([cell.headIncreaseButton.currentBackgroundImage isEqual:[UIImage imageNamed:@"Button-Expand"]]) {
        [cell.headIncreaseButton setBackgroundImage:[UIImage imageNamed:@"Button-Collapse"] forState:UIControlStateNormal];
    }
}
//Change the ScanPoint image
-(void)ChangeIncreaseDecreaseButtonImage1:(ScanPoinTableViewCell*)cell{
    if ([cell.sacnPointImageView.currentBackgroundImage isEqual:[UIImage imageNamed:@"Button-Collapse"]]) {
        [cell.sacnPointImageView setBackgroundImage:[UIImage imageNamed:@"Button-Expand"] forState:UIControlStateNormal];
        
    }
    else  if ([cell.sacnPointImageView.currentBackgroundImage isEqual:[UIImage imageNamed:@"Button-Expand"]]) {
        [cell.sacnPointImageView setBackgroundImage:[UIImage imageNamed:@"Button-Collapse"] forState:UIControlStateNormal];
    }
}
-(float)increaseHeaderinHeaderTV :(NSArray*)indexpath{
    selectedHeaderIndexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    if (indexpath.count>0) {
        [selectedScanPointIndexPath addObject:indexpath];
        [_headerTableview reloadData];
    }
    [_headerTableview reloadData];
    CGRect frame=_headerTableview.frame;
    frame.size.height=_headerTableview.contentSize.height;
    _headerTableview.frame=frame;
    return _headerTableview.contentSize.height;
}
-(float)decreaseHeaderinHeaderTV :(NSArray*)indexpath{
    selectedHeaderIndexPath=nil;
    [_headerTableview reloadData];
    CGRect frame=_headerTableview.frame;
    frame.size.height=_headerTableview.contentSize.height;
    _headerTableview.frame=frame;
     return _headerTableview.contentSize.height;
}
@end
