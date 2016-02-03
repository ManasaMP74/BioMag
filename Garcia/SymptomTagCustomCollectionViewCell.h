#import <UIKit/UIKit.h>
@protocol deleteCell<NSObject>
-(void)deleteCell:(UICollectionViewCell*)cell;
@end
@interface SymptomTagCustomCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIButton *deleteCell;
@property(weak,nonatomic)id<deleteCell>delegate;
@end
