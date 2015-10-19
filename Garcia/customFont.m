#import "customFont.h"

@implementation customFont


//Implementation of custom method it return custom font
- (UIFont *)customFont:(NSInteger)size ofName:(CustomFontNames)fontName
{
    UIFont *customFont;
  // switch (1)
   //{
 //       case OpenSansBold:
  //         customFont = [UIFont fontWithName:@"OpenSans-Bold" size:size];
  //         break;
   //    case MuseoSans_300:
      //     customFont = [UIFont fontWithName:@"MuseoSans-300" size:size];
   //        break;
   //    case MuseoSans_700:
   //        customFont = [UIFont fontWithName:@"MuseoSans-700" size:size];
   //         break;
   //    default:
   //         break;
  //  }
    
    customFont =[UIFont fontWithName:@"OpenSans-Bold" size:size];
    
    
 
    
    
    NSArray *fontFamilies = [UIFont familyNames];
    for (int i = 0; i < [fontFamilies count]; i++)
    {
        NSString *fontFamily = [fontFamilies objectAtIndex:i];
        NSArray *fontNames = [UIFont fontNamesForFamilyName:[fontFamilies objectAtIndex:i]];
        NSLog (@"%@: %@", fontFamily, fontNames);
    }
    
    
    
    return customFont;
}




@end
