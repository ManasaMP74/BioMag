#import "CorrespondPoint.h"

@implementation CorrespondPoint
{
    NSMutableArray *sittingArray;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])){
        UIView *subView = [[[NSBundle mainBundle] loadNibNamed:@"scan" owner:self options:nil] objectAtIndex:0];
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
        sittingArray=[@[@"Eye (Scan Point)",@"Ear (Scan Point)",@"Neck (Scan Point)"]mutableCopy];
    
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
    ScanPointCell *cell = (ScanPointCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"ScanPointCell" owner:self options:nil];
        cell = _scanPointCell;
        _scanPointCell = nil;
    }
    cell.scanpointLabel.text=sittingArray[indexPath.section];
    return cell;
}


@end
