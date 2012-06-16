//
//  SubjectDetailViewController.h
//  poacMF
//
//  Created by Chris Vanderschuere on 10/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"
#import "TestViewController.h"

@interface SubjectDetailViewController : UIViewController <AQGridViewDataSource, AQGridViewDelegate, UIActionSheetDelegate, TestResultProtocol>{
    NSUInteger _emptyCellIndex;
    
}

@property (nonatomic, strong) NSMutableArray *subjectTests;
@property (nonatomic, strong) AQGridView *gridView;

@end
