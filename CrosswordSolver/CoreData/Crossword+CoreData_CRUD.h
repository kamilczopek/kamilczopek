//
//  Crossword+CoreData_CRUD.h
//  CrosswordSolver
//
//  Created by Kamil Czopek on 04.12.2014.
//  Copyright (c) 2014 Kamil Czopek. All rights reserved.
//

#import "Crossword.h"
#import "CrosswordTO.h"

@interface Crossword (CoreData_CRUD)

+ (Crossword *)crosswordWithCrosswordTO:(CrosswordTO*)crosswordTO inManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSArray*)loadCrosswordsFromCrosswordsTOArray:(NSArray *)crosswordTOsArray intoManagedObjectContext:(NSManagedObjectContext *)context;

@end
