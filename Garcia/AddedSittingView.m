#import "AddedSittingView.h"
#import "AppDelegate.h"
#import <MCLocalization/MCLocalization.h>
#import "sittingModel.h"
#if !defined(MAX)
#define MAX(A,B)((A) > (B) ? (A) : (B))
#endif
@implementation AddedSittingView
{
    AppDelegate *appdelegate;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])){
        UIView *subView = [[[NSBundle mainBundle] loadNibNamed:@"AddedSittingView" owner:self options:nil] objectAtIndex:0];
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
        appdelegate=  [UIApplication sharedApplication].delegate;
    }
    [self localization];
    
    return  self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _selectedSittingPair.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddedSittingViewTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        [[NSBundle mainBundle] loadNibNamed:@"AddedSittingViewCell" owner:self options:nil];
        cell=_customCell;
        _customCell=nil;
    }
    sittingModel *model=_selectedSittingPair[indexPath.row];
    
  //  cell.section.text=model.sectionName;
    cell.scanpoint.text=model.scanPointName;
    cell.correspondingpair.text=model.correspondingPairName;
    cell.locOfScanpoint.text=model.germsCodeString;
    cell.locOfCorrespondingPair.text=model.interpretation;
    tableView.tableFooterView=[UIView new];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height=41;
    if (_heightOfEachCellArray.count>0) {
        if ([_heightOfEachCellArray[indexPath.row] floatValue]>41) {
            height=[_heightOfEachCellArray[indexPath.row] floatValue]+20;
        }
    }
     return height;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor colorWithRed:0.38 green:0.82 blue:0.961 alpha:1];
}
-(void)localization{
_scanpointLabel.text=[MCLocalization stringForKey:@"Scan Point"];
_correspondingPairLabel.text=[MCLocalization stringForKey:@"Corresponding Pair"];
_sectionLabel.text=[MCLocalization stringForKey:@"Section"];
_locOfScanPoint.text=[MCLocalization stringForKey:@"Code"];
_locOfCorrespondingPair.text=[MCLocalization stringForKey:@"Interpretation"];
}
@end
