//
//  DAO.h
//  poacMF
//
//  Created by Matt Hunter on 3/18/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DAO : NSObject {

	@private
	NSString	*databasePath;
}

@property (nonatomic, retain) NSString	*databasePath;

@end
