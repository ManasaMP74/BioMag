#import <UIKit/UIKit.h>
@protocol deleteCellProtocol<NSObject>
-(void)deleteCell:(UICollectionViewCell*)cell;
@end

@interface CriticalTreatmentInfoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *treatmentImageView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property(weak,nonatomic)id<deleteCellProtocol>delegate;
@end
