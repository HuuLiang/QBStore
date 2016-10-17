//
//  DBPersistence.m
//  QBStoreSDK
//
//  Created by Sean Yue on 16/5/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "DBPersistence.h"
#import "DBHandler.h"

@implementation DBPersistence

+ (dispatch_queue_t)persistenceQueue {
    static dispatch_queue_t _persistenceQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *queueName = [NSString stringWithFormat:@"com.qbstore.queue.persistence.%@", [self class]];
        _persistenceQueue = dispatch_queue_create(queueName.UTF8String, nil);
    });
    return _persistenceQueue;
}

+ (BOOL)DBShouldPersistentSubProperties {
    return NO;
}

+ (NSArray *)DBPersistenceExcludedProperties {
    return @[@"description",@"debugDescription",@"hash",@"superclass"];
}

+ (NSArray *)objectsFromPersistence {
    return [[DBHandler sharedInstance] queryWithClass:[self class] key:nil value:nil orderByKey:nil desc:NO];
}

+ (NSArray *)objectsFromPersistenceAsync:(void (^)(NSArray *objects))asyncBlock {
    if (asyncBlock) {
        dispatch_async(self.persistenceQueue, ^{
            NSArray *objects = [self objectsFromPersistence];
            dispatch_async(dispatch_get_main_queue(), ^{
                asyncBlock(objects);
            });
        });
    } else {
        return [self objectsFromPersistence];
    }
    return nil;
}

+ (instancetype)objectFromPersistenceWithPKValue:(id)value {
    return [[DBHandler sharedInstance] queryWithClass:[self class] key:[[self class] primaryKey] value:value orderByKey:nil desc:NO].firstObject;
}

+ (instancetype)objectFromPersistenceWithPKValue:(id)value async:(void (^)(id obj))asyncBlock {
    if (asyncBlock) {
        dispatch_async(self.persistenceQueue, ^{
            id object = [self objectFromPersistenceWithPKValue:value];
            dispatch_async(dispatch_get_main_queue(), ^{
                asyncBlock(object);
            });
        });
    } else {
        return [self objectFromPersistenceWithPKValue:value];
    }
    return nil;
}

+ (void)saveObjects:(NSArray *)objects {
    if (objects.count == 0) {
        return ;
    }
    
    [objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSAssert([obj class] == [self class], @"DBPersistence: the object to be persisted must be a class of %@!", [self class]);
    }];
    
    dispatch_async(self.persistenceQueue, ^{
        [[DBHandler sharedInstance] insertOrUpdateWithModelArr:objects byPrimaryKey:[[self class] primaryKey]];
    });
}

+ (void)removeAllObjectsFromPersistence {
    dispatch_async(self.persistenceQueue, ^{
        [[DBHandler sharedInstance] dropModels:[self class]];
    });
}

+ (void)removeFromPersistenceWithObjects:(NSArray *)objects {
    if (objects.count == 0) {
        return ;
    }
    
    [objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSAssert([obj class] == [self class], @"DBPersistence: the object to be persisted must be a class of %@!", [self class]);
    }];
    
    dispatch_async(self.persistenceQueue, ^{
        [[DBHandler sharedInstance] deleteModels:objects withPrimaryKey:[[self class] primaryKey]];
    });
}

- (void)save {
    [self saveWithCompletion:nil];
}

- (void)saveWithCompletion:(void (^)(BOOL success))completionBlock {
    dispatch_async([self class].persistenceQueue, ^{
        BOOL ret = [[DBHandler sharedInstance] insertOrUpdateWithModelArr:@[self] byPrimaryKey:[[self class] primaryKey]];
        if (completionBlock) {
            completionBlock(ret);
        }
    });
}

- (void)removeFromPersistence {
    [self removeFromPersistenceWithCompletion:nil];
}

- (void)removeFromPersistenceWithCompletion:(void (^)(BOOL success))completionBlock {
    dispatch_async([self class].persistenceQueue, ^{
        BOOL ret = [[DBHandler sharedInstance] deleteModels:@[self] withPrimaryKey:[[self class] primaryKey]];
        if (completionBlock) {
            completionBlock(ret);
        }
    });
}
@end

@implementation DBPersistence (SubclassingHooks)

+ (NSString *)primaryKey {
    return nil;
}

@end