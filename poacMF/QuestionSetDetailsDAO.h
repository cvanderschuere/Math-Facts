//
//  QuestionSetDetailsDAO.h
//  poacMF
//
//  Created by Matt Hunter on 3/21/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAO.h"

@interface QuestionSetDetailsDAO : DAO {
    
}

-(int) addDetailsById: (int) setId andXValue: (int) xValue andYValue: (int) yValue;

-(NSMutableArray *) getAllDetailSets;
-(NSMutableArray *) getDetailSetForSetId: (int) setId;
-(BOOL)				deleteDetailSetForDetailId: (int) detailId;
-(BOOL)				deleteDetailSetForSetId: (int) setId;

@end
