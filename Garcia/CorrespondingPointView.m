#import "CorrespondingPointView.h"
#import "AppDelegate.h"
@implementation CorrespondingPointView
{
    NSMutableArray *correspondingPointArray;
    UIView *view;
    UIControl *alphaView;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])){
        UIView *subView = [[[NSBundle mainBundle] loadNibNamed:@"CorrespondingPointView"
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
        correspondingPointArray=[[NSMutableArray alloc]init];
        correspondingPointArray=[@[@"Corresponding Point1",@"Corresponding Point2",@"Corresponding Point3"]mutableCopy];
//        [_correspondingTableView registerNib:[UINib nibWithNibName:@"CorrespondingPointCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        [_correspondingTableView reloadData];
    }
    
    return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    else
     return correspondingPointArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   CorrespondingPointCell  *cell = (CorrespondingPointCell *)[tableView dequeueReusableCellWithIdentifier:@"cell2"];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"CorrespondingPointCell" owner:self options:nil];
        cell = _correspondingCell;
        _correspondingCell = nil;
    }
    if (indexPath.section==0) {
        cell.correspondingLabel.text=@"Corresponding Points";
        cell.correspondingLabel.textColor=[UIColor colorWithRed:0.41176 green:0.42745 blue:0.683 alpha:1];
        cell.correspondingLabel.font=[UIFont fontWithName:@"OpenSans-Semibold" size:15];
    }
    else {
        cell.correspondingLabel.text=[NSString stringWithFormat:@"%@ %ld",@"Corresponding Point",(long)indexPath.row];
    }
       return cell;
}
-(float)corespondingCellHeight{
    return _correspondingTableView.contentSize.height;
}
@end
