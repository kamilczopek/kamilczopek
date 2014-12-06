//
//  DBAccess.m
//  CrosswordSolver
//
//  Created by Kamil Czopek on 30.11.2014.
//  Copyright (c) 2014 Kamil Czopek. All rights reserved.
//

#import "DBAccess.h"
#import "CrosswordTO.h"

@implementation DBAccess
sqlite3 *database;

- (instancetype)init
{
    if (self = [super init]) {
        [self initializeDatabase];
    }
    
    return self;
}

- (NSMutableArray *)getAllCrosswords
{

    NSMutableArray *crosswords = [[NSMutableArray alloc] init];
    
    // The SQL statement that we plan on executing against the database
    const char *sql = "SELECT * FROM Crossword";
    // The SQLite statement that will hold the result set.
    sqlite3_stmt *statement;
    // Prepare the statement to compile the SQL query into byte-code.
    int sqlResult = sqlite3_prepare_v2(database, sql, -1, &statement, NULL);
    
    if (sqlResult == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            // Allocate the Crossword Transfer Object.
            CrosswordTO *crosswordTO = [[CrosswordTO alloc] init];
            crosswordTO.identifier = sqlite3_column_int(statement, 0);
            crosswordTO.length = sqlite3_column_int(statement, 1);
            char *word = (char *)sqlite3_column_text(statement, 2);
            crosswordTO.word = [NSString stringWithUTF8String:word];
            char *definition = (char *)sqlite3_column_text(statement, 3);
            crosswordTO.definition = [NSString stringWithUTF8String:definition];
            [crosswords addObject:crosswordTO];
        }
    }
    
    // Finalize the statement to realease its resources.
    sqlite3_finalize(statement);
    
    return crosswords;
}
- (void)closeDatabase
{
    // Close the database.
    if (sqlite3_close(database) != SQLITE_OK) {
        NSAssert1(0, @"Failed to close database: '%s'.", sqlite3_errmsg(database) );
    }
}

- (void)initializeDatabase
{
    // Get the database from the application bundle.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"crossword" ofType:@"db"];
    
    // Open the database.
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
        NSLog(@"Opening database");
    }
    else {
        sqlite3_close(database);
        NSAssert1(0, @"Failed to open database: '%s'.", sqlite3_errmsg(database) );
    }
}

@end
