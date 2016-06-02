//
//  MADCoreDataStack.m
//  Marvel
//
//  Created by Mariia Cherniuk on 28.05.16.
//  Copyright © 2016 marydort. All rights reserved.
//

#import "MADCoreDataStack.h"
#import "MADHero.h"

@implementation MADCoreDataStack

+ (instancetype)sharedCoreData {
    static MADCoreDataStack *coreDataStack = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        coreDataStack = [[MADCoreDataStack alloc] init];
    });
    
    return coreDataStack;
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Marvel" withExtension:@"momd"];
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    NSURL *url = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Marvel.sqlite"];
    NSError *error;
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:url
                                                         options:nil
                                                           error:&error]) {
        NSLog(@"%@", [error description]);
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    if (!self.persistentStoreCoordinator) {
        return nil;
    }
    
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    
    return _managedObjectContext;
}

- (void)saveObjects:(NSArray *)objects {
    NSManagedObjectContext *context = self.managedObjectContext;
    NSError *error;
    
    for (NSDictionary *hero in objects) {
        MADHero *marvelHero = (MADHero *)[NSEntityDescription insertNewObjectForEntityForName:@"MADHero" inManagedObjectContext:context];
        
        marvelHero.name = hero[@"name"];
        marvelHero.imageURL = hero[@"imageURL"];
        marvelHero.definition = hero[@"description"];
    }
    
    if (![context save:&error]) {
        NSLog(@"%@", [error description]);
    }
}

- (NSArray *)uniquenessCheck:(NSArray *)heroes {
    NSArray *names = [heroes valueForKeyPath:@"name"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name IN %@", names];
    NSArray *response = [[self fetchingDistinctValueByPredicate:predicate] valueForKeyPath:@"name"];
    NSPredicate *filterPredicate = [NSPredicate predicateWithBlock:
                                    ^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
                                        return ![response containsObject:[NSString stringWithFormat:@"%@", evaluatedObject[@"name"]]];
                                    }];

    return [heroes filteredArrayUsingPredicate:filterPredicate];
}

- (NSArray *)fetchingDistinctValueByPredicate:(NSPredicate *)predicate {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MADHero"
                                              inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    request.predicate = predicate;
    request.sortDescriptors = [[NSArray alloc] init];
    
    NSError *error = nil;
    NSArray *respone = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"%@", [error description]);
    }
    
    return respone;
}

@end
