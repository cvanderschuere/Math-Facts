//
//  StudentGraphPopoverViewController.h
//  poacMF
//
//  Created by Chris Vanderschuere on 08/07/2012.
//  Copyright (c) 2012 CDVConcepts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Result.h"

@interface StudentGraphPopoverViewController : UIViewController <CPTPlotSpaceDelegate,CPTPlotDataSource>

@property (nonatomic, weak) IBOutlet CPTGraphHostingView *graphView;
@property (nonatomic, strong) NSArray* resultsArray;

@end
