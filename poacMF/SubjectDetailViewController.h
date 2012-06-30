//
//  SubjectDetailViewController.h
//  poacMF
//
//  Created by Chris Vanderschuere on 10/06/2012.
//  Copyright (c) 2012 Chris Vanderschuere. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"
#import "TestViewController.h"

@interface SubjectDetailViewController : UIViewController <AQGridViewDataSource, AQGridViewDelegate, UIActionSheetDelegate, TestResultProtocol>{
    NSUInteger _emptyCellIndex;
}

@property (nonatomic, strong) Student *currentStudent;
@property (nonatomic, strong) AQGridView *gridView;

@end
