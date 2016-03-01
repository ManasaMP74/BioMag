#import <Foundation/Foundation.h>

@interface SittingModelClass : NSObject


@property(assign,nonatomic) float height;
@property(strong,nonatomic) NSMutableArray *selectedScanPointIndexpath;
@property(strong,nonatomic) NSMutableArray *selectedHeaderIndexpath;
@property(strong,nonatomic) NSMutableArray *selectedToxicHeader;
@property(strong,nonatomic) NSString *completed;
@property(strong,nonatomic)NSString *visit;
@property(strong,nonatomic)NSString *sittingNumber;
@property(strong,nonatomic)NSString *sittingID;
@property(strong,nonatomic)NSArray *anotomicalPointArray;
@property(strong,nonatomic)NSString *price;
@property(strong,nonatomic)NSMutableArray *correspondingPairHeight;
@property(strong,nonatomic)NSString *toxicDeficiency;
@end
