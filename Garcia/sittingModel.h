#import <Foundation/Foundation.h>

@interface sittingModel : NSObject
@property(strong,nonatomic)NSString *sittingId;
@property(strong,nonatomic)NSString *code;
@property(strong,nonatomic)NSString *sectionName;
@property(strong,nonatomic)NSString *sectionCode;
@property(strong,nonatomic)NSString *scanPointName;
@property(strong,nonatomic)NSString *scanPointCode;
@property(strong,nonatomic)NSString *correspondingPairCode;
@property(strong,nonatomic)NSString *correspondingPairName;
@property(strong,nonatomic)NSMutableArray *germsCode;
@property(strong,nonatomic)NSMutableArray *germsName;
@property(strong,nonatomic)NSString *psychoemotional;
@property(strong,nonatomic)NSString *author;
@property(strong,nonatomic)NSString *interpretation;
@property(strong,nonatomic)NSString *sortNumber;
@property(strong,nonatomic)NSString *dateCreated;
@end
