//
//  QuestionSet.h
//  poacMF
//
//  Created by Matt Hunter on 3/22/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QuestionSetOLD : NSObject {
	int						setId;
	NSString				* questionSetName;
	int						mathType;
	int						setOrder;
	NSMutableArray			* setDetailsNSMA;
}

@property (nonatomic)			int						setId;
@property (strong, nonatomic)	NSString				*questionSetName;
@property (nonatomic)			int						mathType;
@property (nonatomic)			int						setOrder;
@property (strong, nonatomic)	NSMutableArray			*setDetailsNSMA;

- (id)mutableCopyWithZone:(NSZone *)zone;

@end