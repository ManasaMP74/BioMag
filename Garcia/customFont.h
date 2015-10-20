#import <UIKit/UIKit.h>

@interface customFont : NSObject
typedef NS_ENUM(NSInteger, CustomFontNames)
{
    OpenSansBold = 1,
   OpenSansRegular,
    MuseoSans_700,
};

- (UIFont *)customFont:(NSInteger)size ofName:(CustomFontNames)fontName;

@end
