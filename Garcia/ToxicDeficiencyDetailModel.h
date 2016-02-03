#import <Foundation/Foundation.h>

@interface ToxicDeficiencyDetailModel : NSObject
@property(strong,nonatomic)NSString *toxicCode;
@property(strong,nonatomic)NSString *toxicName;
@property(strong,nonatomic)NSString *toxicId;
@property(strong,nonatomic)NSString *toxicTypeCode;
@property(assign,nonatomic)BOOL selected;
@end
