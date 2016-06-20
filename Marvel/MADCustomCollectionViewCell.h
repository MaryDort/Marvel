//
//  MADCustomCollectionViewCell.h
//  Marvel
//
//  Created by Mariia Cherniuk on 28.05.16.
//  Copyright © 2016 marydort. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MADCustomCollectionViewCell : UICollectionViewCell

@property (nonatomic, readwrite, strong) IBOutlet UIImageView *heroPhotoImageView;
@property (nonatomic, readwrite, strong) IBOutlet UILabel *heroNamelabel;

@end
