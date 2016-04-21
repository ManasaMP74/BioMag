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
    cell.section.text=model.sectionName;
    cell.scanpoint.text=model.scanPointName;
    cell.correspondingpair.text=model.correspondingPairName;
    cell.locOfScanpoint.text=model.locOfScanpoint;
    cell.locOfCorrespondingPair.text=model.locOfCorrespondingPair;
    tableView.tableFooterView=[UIView new];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

   // CGFloat i=self.frame.size.width/4;
//     sittingModel *model=_selectedSittingPair[indexPath.row];
//    CGFloat labelHeight1=[model.sectionName boundingRectWithSize:(CGSize){i,CGFLOAT_MAX }options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSansSemibold" size:13]} context:nil].size.height;
//    CGFloat labelHeight2=[model.scanPointName boundingRectWithSize:(CGSize){i,CGFLOAT_MAX }options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSansSemibold" size:13]} context:nil].size.height;
//    CGFloat labelHeight3=[model.correspondingPairName boundingRectWithSize:(CGSize){i,CGFLOAT_MAX }options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSansSemibold" size:13]} context:nil].size.height;
//CGFloat labelHeight4=[model.locOfScanpoint boundingRectWithSize:(CGSize){i,CGFLOAT_MAX }options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSansSemibold" size:13]} context:nil].size.height;
//    CGFloat labelHeight5=[model.locOfCorrespondingPair boundingRectWithSize:(CGSize){i,CGFLOAT_MAX }options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSansSemibold" size:13]} context:nil].size.height;
//    CGFloat j=MAX(labelHeight1, labelHeight2);
//    j=MAX(j, labelHeight3);
//    j=MAX(j, labelHeight4);
//    j=MAX(j, labelHeight5);
//    if (j>41) {
//        return j+10;
//    }
//   else return 41;
    return 41;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor colorWithRed:0.38 green:0.82 blue:0.961 alpha:1];
}
-(void)localization{
_scanpointLabel.text=[MCLocalization stringForKey:@"Scan Point"];
_correspondingPairLabel.text=[MCLocalization stringForKey:@"Corresponding Pair"];
_sectionLabel.text=[MCLocalization stringForKey:@"Section"];
_locOfScanPoint.text=[MCLocalization stringForKey:@"Loc. ScanPoint"];
_locOfCorrespondingPair.text=[MCLocalization stringForKey:@"Loc. Corresponding Pair"];
}
@end
