//
//  MADCoreDataStack.h
//  Marvel
//
//  Created by Mariia Cherniuk on 28.05.16.
//  Copyright © 2016 marydort. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MADCoreDataStack : NSObject

@property (strong, nonatomic, readwrite) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic, readwrite) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic, readwrite) NSManagedObjectModel *managedObjectModel;

+ (instancetype)sharedCoreData;

- (void)saveObjects:(NSArray *)objects;
- (NSArray *)uniquenessCheck:(NSArray *)heroes;

@end
