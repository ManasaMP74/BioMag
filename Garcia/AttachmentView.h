#import <UIKit/UIKit.h>
@protocol takeImage<NSObject>
-(void)throughCamera;
-(void)throughAlbum;
@end
@interface AttachmentView : UIView
-(void)alphaViewInitialize;
@property(weak,nonatomic)id<takeImage>delegate;
@end
