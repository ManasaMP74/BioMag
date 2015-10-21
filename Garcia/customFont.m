#import "customFont.h"

@implementation customFont


//Implementation of custom method it return custom font
- (UIFont *)customFont:(NSInteger)size ofName:(CustomFontNames)fontName
{
    UIFont *customFont;
   switch (fontName)
   {
        case OpenSansBold:
           customFont = [UIFont fontWithName:@"OpenSans-Bold" size:size];
           break;
       case OpenSansRegular:
           customFont = [UIFont fontWithName:@"OpenSans" size:size];
           break;
       case OpenSansSemibold:
           customFont = [UIFont fontWithName:@"OpenSans-Semibold" size:size];
            break;
       default:
            break;
    }
   
    
//    NSArray *fontFamilies = [UIFont familyNames];
//    for (int i = 0; i < [fontFamilies count]; i++)
//    {
//        NSString *fontFamily = [fontFamilies objectAtIndex:i];
//        NSArray *fontNames = [UIFont fontNamesForFamilyName:[fontFamilies objectAtIndex:i]];
//        NSLog (@"%@: %@", fontFamily, fontNames);
//    }
    
    
    return customFont;
}

@end
