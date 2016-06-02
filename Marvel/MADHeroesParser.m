//
//  MADStoriesParser.m
//  Marvel
//
//  Created by Mariia Cherniuk on 27.05.16.
//  Copyright © 2016 marydort. All rights reserved.
//

#import "MADHeroesParser.h"
#import "MADDownloader.h"

@implementation MADHeroesParser

+ (NSArray *)parseHeroes:(NSArray *)heroes {
    NSMutableArray *arrHeroes = [[NSMutableArray alloc] init];
        
    for (NSDictionary *hero in heroes) {
        NSMutableDictionary *dicHero = [[NSMutableDictionary alloc] init];
        dicHero[@"name"] = hero[@"name"];

        if ([hero[@"thumbnail"] count] != 0) {
            NSString *imagePath = [NSString stringWithFormat:@"%@.%@", hero[@"thumbnail"][@"path"], hero[@"thumbnail"][@"extension"]];
            dicHero[@"imageURL"] = imagePath;
        }
        
        if (![hero[@"description"] isEqualToString:@""]) {
            dicHero[@"description"] = hero[@"description"];
        }
        
        [arrHeroes addObject:dicHero];
    }
    
    return arrHeroes;
}

@end
