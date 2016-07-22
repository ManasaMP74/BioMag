#import <UIKit/UIKit.h>
#import "HeaderTableVIew.h"
@protocol cellHeight<NSObject>
@optional
-(void)deleteSittingCell:(UICollectionViewCell*)cell;
-(void)editSittingCell:(UICollectionViewCell*)cell;
-(void)selectedHeaderCell:(NSString*)selectedHeader withcell:(UICollectionViewCell*)cell withCorrespondingHeight:(CGFloat)height;
-(void)deselectedHeaderCell:(NSString*)deselectedHeader withcell:(UICollectionViewCell*)cell withCorrespondingHeight:(CGFloat)height;
-(void)selectedToxicCell1:(NSString*)selectedToxicHeader withcell:(UICollectionViewCell*)cell ;
-(void)deselectedToxicCell1:(NSString*)deselectedHeader withcell:(UICollectionViewCell*)cell ;
-(void)completedSittingByTapOnSwitchFromHeaderCell:(UICollectionViewCell*)cell;
@end
@interface SittingCollectionViewCell : UICollectionViewCell<selectedCellProtocol>
@property (strong, nonatomic) IBOutlet UILabel *visitLabel;
@property (strong, nonatomic) IBOutlet UILabel *sittingLabel;
@property (strong, nonatomic) IBOutlet UILabel *visitDateLabel;
@property(weak,nonatomic)id<cellHeight>delegate;
@property (strong, nonatomic) IBOutlet UIButton *closeSitting;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet HeaderTableVIew *headerTableView;
@end

