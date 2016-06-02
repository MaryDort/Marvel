//
//  ViewController.m
//  Marvel
//
//  Created by Mariia Cherniuk on 24.05.16.
//  Copyright © 2016 marydort. All rights reserved.
//

#import "ViewController.h"
#import "MADDownloader.h"
#import "MADHeroesParser.h"
#import "MADCustomCollectionViewCell.h"
#import "MADCoreDataStack.h"
#import "MADHero.h"
#import "UICollectionView+NSFetchedResultsController.h"
#import "MADAnimator.h"
#import "MADHeroDescriprionViewController.h"

@interface ViewController () <UICollectionViewDataSource, NSFetchedResultsControllerDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UIViewControllerTransitioningDelegate, UIScrollViewDelegate>

@property (nonatomic, readwrite, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readwrite, strong) UICollectionView *collectionView;
@property (nonatomic, readwrite, strong) UISearchBar *searchBar;
@property (nonatomic, readwrite, strong) UIRefreshControl *refreshControl;
@property (nonatomic, readwrite, strong) NSArray *filteredList;
@property (nonatomic, readwrite, strong) NSFetchRequest *searchFetchRequest;
@property (nonatomic, readwrite, assign) BOOL searchBarActive;
@property (nonatomic, readwrite, assign) CGSize sizeToUse;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self createCollectionView];
    [self createSearchBar];
    [self createRefreshControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    _searchFetchRequest = nil;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _collectionView.frame = self.view.frame;
    _searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
    _sizeToUse = self.view.frame.size;
}

- (void)createRefreshControl {
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.backgroundColor = [UIColor blackColor];
    _refreshControl.tintColor = [UIColor whiteColor];
    [_refreshControl addTarget:self action:@selector(refreshPage:) forControlEvents:UIControlEventValueChanged];
    
    [_collectionView addSubview:_refreshControl];
}

- (void)createSearchBar {
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50.f)];
    _searchBar.delegate = self;
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.tintColor = [UIColor blackColor];
    
    [self.view addSubview:_searchBar];
}

- (void)createCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.alwaysBounceVertical = YES;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"MADCustomCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:@"MADCustomCollectionViewCell"];
    
    [self.view addSubview:_collectionView];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_sizeToUse.width > _sizeToUse.height) {
        return CGSizeMake(_sizeToUse.width/3 - 20, _sizeToUse.height/2 - 10);
    }
    return CGSizeMake(_sizeToUse.width/2 - 10, _sizeToUse.height/3 - 10);
}

#pragma mark - Action

- (IBAction)refreshPage:(UIRefreshControl *)sender {
    [[MADDownloader sharedDownloader] downloadInfoWithComplitionBlock:^{
        [_refreshControl endRefreshing];
    }];
}

#pragma mark - protocolUIContentContainer

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    _sizeToUse = size;
    [_collectionView.collectionViewLayout invalidateLayout];
}

#pragma mark - Private

- (void)loadData {
    [[MADDownloader sharedDownloader] downloadInfoWithComplitionBlock:^{
    }];
}

#pragma mark - GETmethods

- (NSFetchRequest *)searchFetchRequest {
    if (_searchFetchRequest) {
        return _searchFetchRequest;
    }
    
    _searchFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"MADHero"
                                                         inManagedObjectContext:_managedObjectContext];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    
    _searchFetchRequest.sortDescriptors = @[sortDescriptor];
    _searchFetchRequest.entity = entityDescription;
    _searchFetchRequest.fetchBatchSize = 5;
    
    return _searchFetchRequest;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (!_searchBarActive) {
        return [[self.fetchedResultsController sections] count];
    }
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (!_searchBarActive) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
        NSLog(@"%lu", (unsigned long)[sectionInfo numberOfObjects]);
        
        return [sectionInfo numberOfObjects];
    }
    
     NSLog(@"%lu", (unsigned long)_filteredList.count);
    return _filteredList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MADCustomCollectionViewCell *cell = (MADCustomCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"MADCustomCollectionViewCell" forIndexPath:indexPath];
    MADHero *hero = nil;
    
    if (!_searchBarActive) {
        hero = [self.fetchedResultsController objectAtIndexPath:indexPath];
    } else {
        hero = [_filteredList objectAtIndex:indexPath.row];
    }
    
    cell.heroNamelabel.text = hero.name;
    
    if (!hero.image) {
        [[MADDownloader sharedDownloader] downloadImageByURI:hero.imageURL
                                         withComplitionBlock:^(NSData *image) {
                                             hero.image = image;
                                         }];
    } else {
        cell.heroPhotoImageView.image = [UIImage imageWithData:hero.image];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MADHero *hero = [self.fetchedResultsController objectAtIndexPath:indexPath];
    MADHeroDescriprionViewController *toViewController = [[MADHeroDescriprionViewController alloc] init];
    
    if (hero.definition) {
        toViewController.info = hero.definition;
    } else {
        toViewController.info = [NSString stringWithFormat:@"Oups, hero %@ has't description!\n😡💩", hero.name];
    }
    toViewController.transitioningDelegate = self;
    toViewController.modalPresentationStyle = UIModalPresentationCustom;
    
    
    [self presentViewController:toViewController animated:YES completion:nil];
}

#pragma mark - NSFetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    _managedObjectContext = [[MADCoreDataStack sharedCoreData] managedObjectContext];
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.searchFetchRequest
                                                                    managedObjectContext:_managedObjectContext
                                                                      sectionNameKeyPath:nil
                                                                               cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    NSError *error;
    if (![_fetchedResultsController performFetch:&error]) {
        NSLog(@"%@", [error description]);
    }
    
    return _fetchedResultsController;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    [_collectionView addChangeForSection:sectionInfo atIndex:sectionIndex forChangeType:type];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    [_collectionView addChangeForObjectAtIndexPath:indexPath forChangeType:type newIndexPath:newIndexPath];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [_collectionView commitChanges];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    _searchBarActive = YES;
    [_searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length > 0) {
        _searchBarActive = YES;
        [self filterContentForSearchText:searchText];
    } else {
        _searchBarActive = NO;
    }
    [_collectionView reloadData];
}

- (void)filterContentForSearchText:(NSString*)searchText {
    if (_managedObjectContext) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K BEGINSWITH[cd] %@", @"name", searchText];
        NSError *error;
        
        self.searchFetchRequest.predicate = predicate;
        _filteredList = [_managedObjectContext executeFetchRequest:self.searchFetchRequest error:&error];
        
        if (error) {
            NSLog(@"%@", [error description]);
        }
    }
}

#pragma mark - UIViewControllerTransitioningDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    MADAnimator *animator = [[MADAnimator alloc] init];
    
    animator.presenting = YES;
    
    return animator;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    MADAnimator *animator = [[MADAnimator alloc] init];
    
    animator.presenting = NO;
    
    return animator;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_searchBar resignFirstResponder];
}

@end
