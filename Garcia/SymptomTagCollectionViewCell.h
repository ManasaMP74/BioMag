#import <UIKit/UIKit.h>
@protocol deleteCellValue<NSObject>
-(void)deleteCell:(UICollectionViewCell*)cell;
@end
@interface SymptomTagCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *label;
@property(weak,nonatomic)id<deleteCellValue>delegate;
@end
