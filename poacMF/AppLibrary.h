//
//  AppLibrary.h
//  poacMF
//
//  Created by Matt Hunter on 3/19/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AppLibrary : NSObject {
    
}

-(void)				showAlertFromDelegate: (id) delegateObject  withWarning: (NSString *) warning;
-(NSString *)		interpretMathTypeAsPhrase: (int) mathType;
-(NSString *)		interpretMathTypeAsSymbol: (int) mathType;
-(NSString *)		formattedDate: (NSDate *)thisDate;
-(NSDictionary *)	matchAndCountUsers: (NSMutableArray *)listOfUsers toDetails:(NSMutableArray *) listOfResults;

@end
