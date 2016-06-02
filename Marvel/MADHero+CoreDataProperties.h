//
//  MADHero+CoreDataProperties.h
//  
//
//  Created by Mariia Cherniuk on 31.05.16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MADHero.h"

NS_ASSUME_NONNULL_BEGIN

@interface MADHero (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *definition;
@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, retain) NSString *imageURL;
@property (nullable, nonatomic, retain) NSString *name;

@end

NS_ASSUME_NONNULL_END
