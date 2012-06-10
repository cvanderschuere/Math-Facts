//
//  UserProgressViewController.h
//  poacMF
//
//  Created by Chris Vanderschuere on 05/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"

@interface StudentMainViewController : UIViewController <UIActionSheetDelegate>{
    BOOL pageControlBeingUsed;
}


@property (nonatomic, strong) Student *currentStudent;
@property (nonatomic, weak) IBOutlet UIScrollView* subjectScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *subjects2DArray;

- (IBAction)changePage:(id)sender;

@end
