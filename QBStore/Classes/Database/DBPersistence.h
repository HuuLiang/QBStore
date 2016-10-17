//
//  DBPersistence.h
//  QBStoreSDK
//
//  Created by Sean Yue on 16/5/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DBPersistentDelegate <NSObject>

@required
+ (BOOL)DBShouldPersistentSubProperties;
@optional
+ (NSArray *)DBPersistenceExcludedProperties;
+ (NSDictionary *)DBPersistenceCustomObjectMapping;
@end

@interface DBPersistence : NSObject <DBPersistentDelegate>

+ (NSArray *)objectsFromPersistenceAsync:(void (^)(NSArray *objects))asyncBlock;

+ (instancetype)objectFromPersistenceWithPKValue:(id)value async:(void (^)(id obj))asyncBlock;

+ (void)saveObjects:(NSArray *)objects;
+ (void)removeAllObjectsFromPersistence;
+ (void)removeFromPersistenceWithObjects:(NSArray *)objects;

- (void)save;
- (void)saveWithCompletion:(void (^)(BOOL success))completionBlock;
- (void)removeFromPersistence;
- (void)removeFromPersistenceWithCompletion:(void (^)(BOOL success))completionBlock;

@end

@interface DBPersistence (SubclassingHooks)

+ (NSString *)primaryKey; // Subclass should override this method to provide customed primary key

@end