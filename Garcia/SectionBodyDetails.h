//
//  SectionBodyDetails.h
//  Garcia
//
//  Created by Vmoksha on 27/10/15.
//  Copyright (c) 2015 manasap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailsSection.h"

@interface SectionBodyDetails : UIView<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *sectionHeaderLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet DetailsSection *detailsSectionCell;
@property (strong, nonatomic) IBOutlet UILabel *bodyPartHeaderlabel;

@property (assign, nonatomic) BOOL showBodyPartLabel;
@property (assign, nonatomic) BOOL scanPointBool;

-(void)alphaViewInitialize;
@end
