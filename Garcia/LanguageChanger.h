#import <Foundation/Foundation.h>
#import "VMEnvironment.h"
@protocol languageChangeForDelegat <NSObject>
@optional
-(void)languageChangeDelegate:(int)str;
@end


@interface LanguageChanger : NSObject

-(void)callApiForUILabelLanguage;
-(void)callApiForPreferredLanguage;
-(void)readingLanguageFromDocument;
@property(weak,nonatomic) id<languageChangeForDelegat>delegate;
@end
