#import <UIKit/UIKit.h>
@protocol deleteTagCell<NSObject>
-(void)deleteTagCell:(UICollectionViewCell*)cell;
@end
@interface TagCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *tagLabel;
@property(weak,nonatomic)id<deleteTagCell>delegate;
@end
