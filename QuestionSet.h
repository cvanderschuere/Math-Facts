//
//  QuestionSet.h
//  poacMF
//
//  Created by Matt Hunter on 3/22/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QuestionSet : NSObject {
	int						setId;
	NSString				*questionSetName;
	int						mathType;
	int						setOrder;
	NSMutableArray			*setDetailsNSMA;
}

@property (nonatomic)			int						setId;
@property (nonatomic)	NSString				*questionSetName;
@property (nonatomic)			int						mathType;
@property (nonatomic)			int						setOrder;
@property (nonatomic)	NSMutableArray			*setDetailsNSMA;

- (id)mutableCopyWithZone:(NSZone *)zone;

@end