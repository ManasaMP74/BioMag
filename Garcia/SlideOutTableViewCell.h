#import <UIKit/UIKit.h>
#import "SectionXibView.h"
@protocol expandCellToGetSectionName<NSObject>
-(void)expandCellToGetSectionName:(UITableViewCell*)cell;
@end
@interface SlideOutTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet SectionXibView *sectionNameXib;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *sectionNameViewHeight;
@property(weak,nonatomic)id<expandCellToGetSectionName>delegate;
@property (strong, nonatomic) IBOutlet UIImageView *expandImageView;
@end
