//
//  PersistenceManager.h
//  CrosswordSolver
//
//  Created by Kamil Czopek on 05.12.2014.
//  Copyright (c) 2014 Kamil Czopek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersistenceManager : NSObject

+ (PersistenceManager*)sharedInstance;
- (BOOL)initializeDatabase;

@end
