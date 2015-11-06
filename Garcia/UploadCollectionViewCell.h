#import <UIKit/UIKit.h>
@protocol deleteCell<NSObject>
-(void)deleteCell:(UICollectionViewCell*)cell;
@end
@interface UploadCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *uploadImageView;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property(weak,nonatomic)id<deleteCell>delegate;
@property (strong, nonatomic) IBOutlet UILabel *captionLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *labelHeight;
@end
