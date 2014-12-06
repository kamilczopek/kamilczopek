//
//  DBAccess.h
//  CrosswordSolver
//
//  Created by Kamil Czopek on 30.11.2014.
//  Copyright (c) 2014 Kamil Czopek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBAccess : NSObject

- (NSMutableArray *)getAllCrosswords;
- (void)closeDatabase;
- (void)initializeDatabase;

@end
