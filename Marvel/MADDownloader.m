//
//  MADDownloader.m
//  Marvel
//
//  Created by Mariia Cherniuk on 27.05.16.
//  Copyright © 2016 marydort. All rights reserved.
//

#import "MADDownloader.h"
#import "NSString+MD5.h"
#import "MADCoreDataStack.h"
#import "MADHeroesParser.h"

@interface MADDownloader ()

@property (nonatomic, readwrite, copy) NSString *publicKey;
@property (nonatomic, readwrite, copy) NSString *privateKey;
@property (nonatomic, readwrite, copy) NSString *hasch;
@property (nonatomic, readwrite, copy) NSString *timeStampString;

@end


@implementation MADDownloader

+ (instancetype)sharedDownloader {
    static MADDownloader *downloader = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloader = [[MADDownloader alloc] init];
    });
    
    return downloader;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _publicKey = @"03bb5d25596e06a6f5dac5b2c6d1e71c";
        _privateKey = @"b195e47a3d1bd5e169a22e201e08c420ccb29114";
        _timeStampString = [self createTimeStampString];
        _hasch = [[NSString stringWithFormat:@"%@%@%@", _timeStampString, _privateKey, _publicKey] MD5String];
    }
    
    return self;
}

- (NSString *)createTimeStampString {
    NSDateFormatter *dataFormater = [[NSDateFormatter alloc] init];
    [dataFormater setDateFormat:@"yyyyMMddHHmmss"];
    
    return [dataFormater stringFromDate:[NSDate date]];
}

- (void)downloadInfoWithComplitionBlock:(void (^)(void))complitionBlock {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gateway.marvel.com/v1/public/characters?ts=%@&apikey=%@&hash=%@", _timeStampString, _publicKey, _hasch]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           
        if (data) {
            NSError *error;
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            
            if (error) {
                NSLog(@"%@", [error description]);
            } else {
                NSArray *arrResults = result[@"data"][@"results"];
                NSArray *uniqueObjects = [[MADCoreDataStack sharedCoreData] uniquenessCheck:arrResults];
                NSArray *parseHeroes = [MADHeroesParser parseHeroes:uniqueObjects];
                
                [[MADCoreDataStack sharedCoreData] saveObjects:parseHeroes];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    complitionBlock();
                });
            }
        } else {
            NSLog(@"%@", [error description]);
        }
    }];
    
    [sessionDataTask resume];
}

- (void)downloadImageByURI:(NSString *)uri withComplitionBlock:(void (^)(NSData *image))complitionBlock {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:uri]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                complitionBlock(data);
            });
        } else {
            NSLog(@"%@", [error description]);
        }
    }];
    [sessionDataTask resume];
}

- (void)downloadInfoByURI:(NSString *)uri withComplitionBlock:(void (^)(NSDictionary *result))complitionBlock {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?ts=%@&apikey=%@&hash=%@", uri, _timeStampString, _publicKey, _hasch]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data) {
            NSError *error2;
            NSDictionary *dicResult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error2];
            
            if (error2) {
                NSLog(@"%@", [error2 description]);
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    complitionBlock(dicResult);
                });
            }
        } else {
            NSLog(@"%@", [error description]);
        }
    }];
    [sessionDataTask resume];
}


@end
