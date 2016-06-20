//
//  MADHeroDescriprionViewController.m
//  Marvel
//
//  Created by Mariia Cherniuk on 30.05.16.
//  Copyright © 2016 marydort. All rights reserved.
//

#import "MADHeroDescriprionViewController.h"

@interface MADHeroDescriprionViewController ()

@property (nonatomic, readwrite, strong) UILabel *label;
@property (nonatomic, readwrite, strong) UIVisualEffectView *vibrancyEffectView;

@end

@implementation MADHeroDescriprionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(viewPressed:)]];
    [self createLabel];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self configureViews];
}

- (void)createLabel {
    _vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]]];
    _vibrancyEffectView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:_vibrancyEffectView];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_vibrancyEffectView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.f
                                                           constant:0.f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_vibrancyEffectView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.f
                                                           constant:0.f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_vibrancyEffectView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.f
                                                           constant:0.f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_vibrancyEffectView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.f
                                                           constant:0.f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_vibrancyEffectView.contentView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.f
                                                           constant:0.f]];
    
    _label = [[UILabel alloc] init];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.numberOfLines = 0;
    _label.textColor = [UIColor whiteColor];
    _label.backgroundColor = [UIColor clearColor];
    _label.font = [UIFont boldSystemFontOfSize:18.f];
    _label.translatesAutoresizingMaskIntoConstraints = NO;
    _label.userInteractionEnabled = YES;
    
    [_vibrancyEffectView.contentView addSubview:_label];
    
    [_vibrancyEffectView.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_label
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_vibrancyEffectView.contentView
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.f
                                                           constant:0.f]];
    
    [_vibrancyEffectView.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_label
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_vibrancyEffectView.contentView
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.f
                                                           constant:0.f]];
    
    [_vibrancyEffectView.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_label
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_vibrancyEffectView.contentView
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.f
                                                           constant:20.f]];
    
    [_vibrancyEffectView.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_label
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_vibrancyEffectView.contentView
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.f
                                                           constant:-20.f]];
}

- (void)setInfo:(NSString *)info {
    if (![_info isEqualToString:info]) {
        _info = info;
        
        [self configureViews];
    }
}

- (void)configureViews {
    _label.text = _info;
}

#pragma mark - Action 

- (IBAction)viewPressed:(UITapGestureRecognizer *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
