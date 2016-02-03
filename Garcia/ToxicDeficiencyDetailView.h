#import <UIKit/UIKit.h>
#import "ToxicDeficiencyCell.h"
@interface ToxicDeficiencyDetailView : UIView
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet ToxicDeficiencyCell *customCell;
@property(strong,nonatomic)NSString *selectedToxicCode;
-(void)callSeed;
-(void)sortData;
-(NSString*)getAllTheSelectedToxic;
@property(strong,nonatomic)NSString *selectedToxicDeficiency;
@property(strong,nonatomic)NSString *isTreatmntCompleted;
@property(strong,nonatomic) NSMutableArray *toxicArray;
@end
