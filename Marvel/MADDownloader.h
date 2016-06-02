//
//  MADDownloader.h
//  Marvel
//
//  Created by Mariia Cherniuk on 27.05.16.
//  Copyright © 2016 marydort. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MADDownloader : NSObject

+ (instancetype)sharedDownloader;

- (void)downloadInfoWithComplitionBlock:(void (^)(void))complitionBlock;
- (void)downloadInfoByURI:(NSString *)url withComplitionBlock:(void (^)(NSDictionary *result))complitionBlock;
- (void)downloadImageByURI:(NSString *)uri withComplitionBlock:(void (^)(NSData *image))complitionBlock;

@end
