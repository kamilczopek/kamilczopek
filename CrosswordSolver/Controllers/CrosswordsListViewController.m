//
//  CrosswordsListViewController.m
//  CrosswordSolver
//
//  Created by Kamil Czopek on 05.12.2014.
//  Copyright (c) 2014 Kamil Czopek. All rights reserved.
//

#import "AppDelegate.h"
#import "CrosswordsListViewController.h"
#import "Crossword+CoreData_CRUD.h"
#import "ActivityIndicatorView.h"
#import "PersistenceManager.h"

@interface CrosswordsListViewController()
@property (nonatomic, strong)  NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) ActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSArray *filteredList;
@property (nonatomic, strong) NSFetchRequest *searchFetchRequest;

@end

@implementation CrosswordsListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Check if the db has already been initiated
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isDatabaseInitialized = [userDefaults boolForKey:@"IsDatabaseInitialized"];
    
    if (!isDatabaseInitialized) {
            // Display some overview on the top.
        [self.activityIndicatorView show];
        [[PersistenceManager sharedInstance] initializeDatabase];
        
        [userDefaults setBool:YES forKey:@"IsDatabaseInitialized"];
        
        // Delay execution of my block for 2 seconds.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
           [self.activityIndicatorView hide];
        });
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Getters and Setters

- (NSManagedObjectContext *)managedObjectContext
{
    if (!_managedObjectContext) {
        _managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    return _managedObjectContext;
}

- (ActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView)
    {
        _activityIndicatorView = [[ActivityIndicatorView alloc] initWithView:self.view andTitle:NSLocalizedString(@"Initalizing database,\n please wait.", nil)];
    }
    return _activityIndicatorView;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView)
    {
        return [[self.fetchedResultsController sections] count];
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView)
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    }
    else
    {
        return [self.filteredList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Always use self.tableView insead of tableView passesd as a method's param.
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CrosswordCell" forIndexPath:indexPath];
    
    Crossword *crossword = nil;
    if (tableView == self.tableView)
    {
        crossword = [self.fetchedResultsController objectAtIndexPath:indexPath];;
        
    }
    else
    {
        crossword = [self.filteredList objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = crossword.word;
    return cell;
}


#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Crossword" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"word" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"default-cache"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            break;
            
        case NSFetchedResultsChangeUpdate:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
 {
 // In the simplest, most efficient, case, reload the table view.
 [self.tableView reloadData];
 }
 */

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Crossword *crossword = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = crossword.word;
}

- (NSFetchRequest *)searchFetchRequest
{
    if (_searchFetchRequest != nil)
    {
        return _searchFetchRequest;
    }
    
    _searchFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Crossword" inManagedObjectContext:self.managedObjectContext];
    [_searchFetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"word" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [_searchFetchRequest setSortDescriptors:sortDescriptors];
    
    return _searchFetchRequest;
}

#pragma mark -
#pragma mark === UISearchDisplayDelegate ===
#pragma mark -

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self searchWithText:searchString andScope:controller.searchBar.selectedScopeButtonIndex];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self searchWithText:controller.searchBar.text andScope:searchOption];

    return YES;
}

- (NSPredicate*)searchPredicateWithSearchString:(NSString*)searchString andScopeButtonIndex:(NSInteger)buttonIndex
{
    NSUInteger wordLength = buttonIndex + 4;
    NSString *searchStringWithWildcards = searchString;
    
    // Add wildcards for the missing characters.
    for (int i=0; i< wordLength - searchString.length; i++) {
        searchStringWithWildcards = [searchStringWithWildcards stringByAppendingString:@"?"];
    }
    
    NSString *predicateFormat = @"length == %d AND word LIKE[cd] %@";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat, wordLength, searchStringWithWildcards];

    return predicate;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    tableView.rowHeight = 64;
}

- (void)searchWithText:(NSString *)searchText andScope:(NSInteger)scope
{
    NSPredicate *predicate = [self searchPredicateWithSearchString:searchText andScopeButtonIndex:scope];
    [self searchWithPredicate:predicate];
}

- (void)searchWithPredicate:(NSPredicate*)predicate
{
    if (self.managedObjectContext)
    {
        [self.searchFetchRequest setPredicate:predicate];
        
        NSError *error = nil;
        self.filteredList = [self.managedObjectContext executeFetchRequest:self.searchFetchRequest error:&error];
        if (error)
        {
            NSLog(@"searchFetchRequest failed: %@",[error localizedDescription]);
        }
    }
}



@end
