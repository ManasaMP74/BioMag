#import <UIKit/UIKit.h>
@protocol selectedImage<NSObject>
-(void)selectedImage:(UIImage*)image;
@end
@interface AttachmentViewController : UIViewController
@property(strong,nonatomic)NSString *selectedPickerSource;
@property(strong,nonatomic)UIImage *selectedImage;
@property(weak,nonatomic)id<selectedImage>delegate;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIButton *CancelButton;
@property (strong, nonatomic) IBOutlet UIButton *okButton;
@end
