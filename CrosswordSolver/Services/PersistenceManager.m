//
//  PersistenceManager.m
//  CrosswordSolver
//
//  Created by Kamil Czopek on 05.12.2014.
//  Copyright (c) 2014 Kamil Czopek. All rights reserved.
//

#import "PersistenceManager.h"
#import "DBAccess.h"
#import "Crossword+CoreData_CRUD.h"
#import "AppDelegate.h"

@implementation PersistenceManager

- (BOOL)initializeDatabase
{
    // Refactor so that we use the Pesrsistence Manager.
    DBAccess *dbAccess = [[DBAccess alloc] init];
    NSArray *crosswordsTOArray = [dbAccess getAllCrosswords];
    [dbAccess closeDatabase];
    
    // Creating managed objects
    __block NSManagedObjectContext *managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    __block NSManagedObjectContext *writerObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] writerManagedObjectContext];
    __block NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    temporaryContext.parentContext = managedObjectContext;
    
    [temporaryContext performBlock:^{
        
        NSArray *crosswords = [Crossword loadCrosswordsFromCrosswordsTOArray:crosswordsTOArray intoManagedObjectContext:temporaryContext];
#pragma unused (crosswords)
        // Save the context.
        NSError *error = nil;
        NSLog(@"Saving to PSC");
        if (![temporaryContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        [managedObjectContext performBlock:^{
            // Save the context.
            NSError *error = nil;
            if (![managedObjectContext save:&error]) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
            
            [writerObjectContext performBlock:^{
                // Save the context.
                NSError *error = nil;
                if (![writerObjectContext save:&error]) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    abort();
                }
                
            }]; // writer
        }]; // main
    }]; // parent
    
    return YES;
}


+ (PersistenceManager*)sharedInstance
{
    static PersistenceManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[PersistenceManager alloc] init];
    });
    
    return _sharedInstance;
}

@end
