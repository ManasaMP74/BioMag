#import <Foundation/Foundation.h>

@interface SittingModelClass : NSObject

@property(assign,nonatomic) BOOL selectedHeader;
@property(assign,nonatomic) float height;
@property(strong,nonatomic) NSArray *selectedScanPointIndexpath;
@property(strong,nonatomic) NSString *completed;
@property(strong,nonatomic) NSIndexPath *headerIndex;
@property(strong,nonatomic) NSIndexPath *noteIndex;
@property(strong,nonatomic)NSString *visit;
@property(strong,nonatomic)NSString *price;
@property(strong,nonatomic)NSString *sittingNumber;
@property(strong,nonatomic)NSString *sittingID;
@end
