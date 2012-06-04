//
//  DAO.m
//  poacMF
//
//  Created by Matt Hunter on 3/18/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import "DAO.h"
#import "AppConstants.h"


@implementation DAO

@synthesize databasePath;

-(id)init {
    if ((self = [super init]))
		self.databasePath = [[NSUserDefaults standardUserDefaults] objectForKey: DATABASE_PATH];
    return self;
}//end method


#pragma mark -
//end method

@end