//
//  UsersDAO.h
//  poacMF
//
//  Created by Matt Hunter on 3/18/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAO.h"
#import "User.h"

@interface UsersDAO : DAO {
    
}

-(BOOL)				loginUserWithUserName: (NSString *) userName andPassword: (NSString *) password;
-(User *)			getUserInformation : (NSString *) userName;
-(NSMutableArray *)	getAllUsers;
-(int)				addUser: (User *) newUser;
-(BOOL)				deleteUserById: (int) userId;
-(BOOL)				updateUser: (User *) updateUser;

@end
