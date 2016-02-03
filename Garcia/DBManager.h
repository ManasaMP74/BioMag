#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class DBManager;
@protocol DBManagerDelegate <NSObject>
@optional
-(void)DBManager:(sqlite3_stmt*)statement;
- (void)DBManager:(DBManager *)manager gotSqliteStatment:(sqlite3_stmt *)statment;
@end
@interface DBManager : NSObject
//Reference of DBManager
@property (weak, nonatomic) id<DBManagerDelegate> delegate;
//Methods
- (instancetype)initWithFileName:(NSString *)dbFileName;
- (void)createTableForQuery:(NSString *)query;

- (void)dropTable:(NSString *)tableName;

- (void)saveDataToDBForQuery:(NSString *)query;

- (void)getDataForQuery:(NSString *)query;

- (void)deleteRowForQuery:(NSString *)query;

@end
