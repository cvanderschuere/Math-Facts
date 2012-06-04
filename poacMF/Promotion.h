//
//  Promotion.h
//  poacMF
//
//  Created by Matt Hunter on 4/17/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuizSet.h"
#import "User.h"

@interface Promotion : NSObject {
    
}

-(void) promoteUser: (User *) user withQuizSet: (QuizSet *) studentQuizSet;
-(void) regressUser: (User *) user withQuizSet: (QuizSet *) studentQuizSet;
@end
