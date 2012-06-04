//
//  QuestionSetDetail.h
//  poacMF
//
//  Created by Matt Hunter on 3/23/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QuestionSetDetail : NSObject {
	int						detailId;
	int						setId;
	int						xValue;
	int						yValue;
}

@property (nonatomic)			int						detailId;
@property (nonatomic)			int						setId;
@property (nonatomic)			int						xValue;
@property (nonatomic)			int						yValue;

@end