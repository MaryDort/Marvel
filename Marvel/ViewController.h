//
//  ViewController.h
//  Marvel
//
//  Created by Mariia Cherniuk on 24.05.16.
//  Copyright © 2016 marydort. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ViewController : UIViewController

@property (nonatomic, readwrite, strong) NSFetchedResultsController *fetchedResultsController;

@end

