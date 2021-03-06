//
// Copyright 2010-2012 JDMdesign.com
// Created by Jeffrey Morris on 10/23/2010.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "JDMTableGridView.h"

#define TABLE_GRID_STR_DEC		@"%d"
#define TABLE_GRID_STR_DEC_DEC	@"%d-%d"
#define TABLE_GRID_STR_FLOAT	@"%0.0f-%0.0f"
@interface JDMTableGridView ()
@property (nonatomic,assign) UIScrollView *scrollview;
@property (nonatomic,assign) UIView *viewOfCells;
@property CGSize headerSize;
@property CGSize leftSize;
@property CGSize cellSize;
@property CGSize footerSize;
@property BOOL needsRender;
@property BOOL scrollToTop;
@property BOOL scrollToLeft;
@property (nonatomic,assign) UIView *leftHeader;
@property (nonatomic,assign) NSMutableDictionary *headerDict;
@property (nonatomic,assign) NSMutableDictionary *leftSideDict;
@property (nonatomic,assign) NSMutableDictionary *innerCellDict;
@property (nonatomic,assign) NSMutableDictionary *footerDict;
@property (nonatomic,assign) UIView *leftFooter;
@property NSInteger numberOfColumns;
@property NSInteger numberOfRows;
@property NSInteger scrollToColumn;
@end

@implementation JDMTableGridView

@synthesize tableGridDelegate;
@synthesize scrollview;
@synthesize viewOfCells;
@synthesize headerSize;
@synthesize leftSize;
@synthesize cellSize;
@synthesize footerSize;
@synthesize needsRender;
@synthesize scrollToTop;
@synthesize scrollToLeft;
@synthesize leftHeader;
@synthesize headerDict;
@synthesize leftSideDict;
@synthesize innerCellDict;
@synthesize footerDict;
@synthesize leftFooter;
@synthesize numberOfColumns;
@synthesize numberOfRows;
@synthesize scrollToColumn;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Clip the bounds, so the header and left side cell do not overflow...
        self.clipsToBounds = YES;
        
        // Create the arrays that hold the header, leftside, and footer cells
        self.headerDict = [[NSMutableDictionary alloc] init];
        self.leftSideDict = [[NSMutableDictionary alloc] init];
        self.innerCellDict = [[NSMutableDictionary alloc] init];
        self.footerDict = [[NSMutableDictionary alloc] init];
        
        // Create the view that will hold all the inner cells
        self.viewOfCells = [[UIView alloc] initWithFrame:CGRectZero];
        
        // Create a scrollview, which is the root of our main view.
        self.scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
        self.scrollview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.scrollview addSubview:self.viewOfCells];
        self.scrollview.directionalLockEnabled = YES;
        [self addSubview:self.scrollview];
        
        self.scrollview.bounces = YES;
        self.scrollview.alwaysBounceVertical = YES;
        self.scrollview.alwaysBounceHorizontal = YES;
        self.scrollview.delegate = self;
        
        self.needsRender = YES;
        self.scrollToLeft = YES;
        self.scrollToTop = YES;
        
        //    self.backgroundColor = [UIColor blueColor];
        //    scrollview.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (CGPoint)getOffSet {
    CGRect wf = [[UIApplication sharedApplication] keyWindow].frame;
    CGRect cf = [self convertRect:wf toView:self.viewOfCells];
    return CGPointMake((cf.origin.x+self.leftSize.width)*-1,(cf.origin.y+self.headerSize.height)*-1);
}

- (void)layoutSubviews {
    if (self.tableGridDelegate==nil) return;
    
    CGPoint offSet = [self getOffSet];
    CGSize offSetSize = CGSizeMake(0,0);
    if (self.leftFooter!=nil) {
        offSetSize = CGSizeMake(self.leftSize.width, self.headerSize.height);
    }
    CGRect scrollFrame = self.scrollview.frame;
    
    NSInteger colCount = [self.tableGridDelegate numberOfColumns];
    self.numberOfColumns = colCount;
    NSInteger rowCount = [self.tableGridDelegate numberOfRows];
    self.numberOfRows = rowCount;
    
    // Create the initial views to be displayed, this happens once, or on a full reload
    if (self.needsRender) {
        self.needsRender = NO;
        
        self.headerSize = [self.tableGridDelegate sizeOfHeaderCell];
        self.leftSize = [self.tableGridDelegate sizeOfLeftCell];
        self.cellSize = CGSizeMake(self.headerSize.width, self.leftSize.height);
        if ([self.tableGridDelegate respondsToSelector:@selector(heightOfFooterCell)]) {
            self.footerSize = CGSizeMake(self.headerSize.width, [self.tableGridDelegate heightOfFooterCell]);
        }
        
        self.leftHeader = [self.tableGridDelegate topLeftFloaterViewForTableGridView:self];
        
        if ([self.tableGridDelegate respondsToSelector:@selector(bottomLeftFloaterViewForTableGridView:)]) {
            self.leftFooter = [self.tableGridDelegate bottomLeftFloaterViewForTableGridView:self];
            if (self.leftFooter!=nil) {
                offSetSize = CGSizeMake(self.leftSize.width, self.footerSize.height);
            }
        }
        
        scrollFrame.origin.x = self.leftSize.width;
        //		scrollFrame.origin.x = 0;
        scrollFrame.origin.y = self.headerSize.height;
        scrollFrame.size.width = self.frame.size.width-self.leftSize.width; //-offSetSize.width;
        //		scrollFrame.size.width = self.frame.size.width;
        scrollFrame.size.height = self.frame.size.height-self.headerSize.height-offSetSize.height;
        self.scrollview.frame = scrollFrame;
        
        CGRect fr = self.viewOfCells.frame;
        fr.origin.x = 0.0;
        fr.origin.y = 0.0;
        fr.size.width = (self.cellSize.width*colCount);
        fr.size.height = (self.cellSize.height*rowCount);
        self.viewOfCells.frame = fr;
        
        self.scrollview.contentSize = CGSizeMake(self.viewOfCells.frame.size.width, self.viewOfCells.frame.size.height);
        [self.scrollview addSubview:self.viewOfCells];
        
        // Add the scroll view...
        [self addSubview:self.scrollview];
        
    }
    
    NSInteger maxColShown = scrollFrame.size.width/self.headerSize.width;
    NSInteger maxRowShown = scrollFrame.size.height/self.leftSize.height;
    
    if (self.scrollToColumn>=0) {
        CGPoint contentOffSet = self.scrollview.contentOffset;
        if (self.scrollToColumn<(colCount-maxColShown)) {
            contentOffSet.x = self.scrollToColumn*self.cellSize.width;
        } else {
            contentOffSet.x = (colCount-maxColShown+1)*self.cellSize.width;
        }
        [self.scrollview setContentOffset:contentOffSet animated:YES];
        self.scrollToColumn = -1;
    }
    
    if (self.scrollToTop) {
        offSet.y = 0;
        self.scrollToTop = NO;
    }
    if (self.scrollToLeft) {
        offSet.x = 0;
        self.scrollToLeft = NO;
    }
    
    NSInteger colIndex = (offSet.x/self.headerSize.width)*-1;
    NSInteger rowIndex = (offSet.y/self.leftSize.height)*-1;
    NSInteger lastColIndex = colIndex+maxColShown;
    if (lastColIndex>colCount) lastColIndex = colCount;
    NSInteger lastRowIndex = rowIndex+maxRowShown;
    if (lastRowIndex>rowCount) lastRowIndex = rowCount;
    
    NSInteger padNum = 1;
    
    // Remove any header, leftside, or footer cells that should no be showing...
    NSArray *list = [self.headerDict allKeys];
    for (NSString *key in list) {
        NSInteger num = [key integerValue];
        if (num<(colIndex-padNum) || num>(lastColIndex+padNum)) {
            [[self.headerDict objectForKey:key] removeFromSuperview];
            [self.headerDict removeObjectForKey:key];
        }
    }
    list = [self.leftSideDict allKeys];
    for (NSString *key in list) {
        NSInteger num = [key integerValue];
        if (num<(rowIndex-padNum) || num>(lastRowIndex+padNum)) {
            [[self.leftSideDict objectForKey:key] removeFromSuperview];
            [self.leftSideDict removeObjectForKey:key];
        }
    }
    list = [self.footerDict allKeys];
    for (NSString *key in list) {
        NSInteger num = [key integerValue];
        if (num<(colIndex-padNum) || num>(lastColIndex+padNum)) {
            [[self.footerDict objectForKey:key] removeFromSuperview];
            [self.footerDict removeObjectForKey:key];
        }
    }
    
    // Get the header cells
    for (NSInteger x = colIndex-padNum; x <= lastColIndex+padNum; x++) {
        if (x>=0 && x<colCount) {
            NSString *key =[NSString stringWithFormat:TABLE_GRID_STR_DEC,x];
            CGRect frame = CGRectZero;
            frame.origin.x = self.leftSize.width+(self.headerSize.width*x)+offSet.x;
            if (frame.origin.x<(self.leftSize.width-self.headerSize.width) ||
                frame.origin.x>(self.frame.size.width+self.headerSize.width)) {
                UIView *view = [self.headerDict objectForKey:key];
                if (view!=nil) {
                    [view removeFromSuperview];
                    [self.headerDict removeObjectForKey:key];
                }
            } else {
                UIView *view = [self.headerDict objectForKey:key];
                if (view==nil) {
                    view = [self.tableGridDelegate tableGridView:self viewForHeaderForColumn:x];
                    if (view==nil) {
                        NSLog(@"Delegate did not return a Header UIView for Column %d",x);
                        abort();
                    }
                }
                frame.size.width = self.headerSize.width;
                frame.size.height = self.headerSize.height;
                view.frame = frame;
                [self addSubview:view];
                [self.headerDict setObject:view forKey:key];
            }
        }
    }
    
    // Get the left side cells
    for (NSInteger y = rowIndex-padNum; y <= lastRowIndex+padNum; y++) {
        if (y>=0 && y<rowCount) {
            NSString *key =[NSString stringWithFormat:TABLE_GRID_STR_DEC,y];
            CGRect frame = CGRectZero;
            frame.origin.y = self.headerSize.height+(self.leftSize.height*y)+offSet.y;
            if (frame.origin.y<(self.headerSize.height-self.leftSize.height) ||
                frame.origin.y>(self.frame.size.height+self.leftSize.height)) {
                UIView *view = [self.leftSideDict objectForKey:key];
                if (view!=nil) {
                    [view removeFromSuperview];
                    [self.leftSideDict removeObjectForKey:key];
                }
            } else {
                UIView *view = [self.leftSideDict objectForKey:key];
                if (view==nil) {
                    view = [self.tableGridDelegate tableGridView:self viewForLeftCellForRow:y];
                    if (view==nil) {
                        NSLog(@"Delegate did not return a LeftSide UIView for Row %d",y);
                        abort();
                    }
                }
                frame.size.width = self.leftSize.width;
                frame.size.height = self.leftSize.height;
                view.frame = frame;
                [self addSubview:view];
                [self.leftSideDict setObject:view forKey:key];
            }
        }
    }
    
    // Get the footer cells
    if ([self.tableGridDelegate respondsToSelector:@selector(tableGridView:viewForFooterForColumn:)]) {
        for (NSInteger x = colIndex-padNum; x <= lastColIndex+padNum; x++) {
            if (x>=0 && x<colCount) {
                NSString *key =[NSString stringWithFormat:TABLE_GRID_STR_DEC,x];
                CGRect frame = CGRectZero;
                frame.origin.x = self.leftSize.width+(self.headerSize.width*x)+offSet.x;
                frame.origin.y = self.frame.size.height-self.footerSize.height;
                if (frame.origin.x<(self.headerSize.width-self.headerSize.width) ||
                    frame.origin.x>(self.frame.size.width+self.headerSize.width)) {
                    UIView *view = [self.footerDict objectForKey:key];
                    if (view!=nil) {
                        [view removeFromSuperview];
                        [self.footerDict removeObjectForKey:key];
                    }
                } else {
                    UIView *view = [self.footerDict objectForKey:key];
                    if (view==nil) {
                        view = [self.tableGridDelegate tableGridView:self viewForFooterForColumn:x];
                        if (view==nil) {
                            NSLog(@"Delegate did not return a Footer UIView for Column %d",x);
                        }
                    }
                    frame.size.width = self.headerSize.width;
                    frame.size.height = self.footerSize.height;
                    view.frame = frame;
                    [self addSubview:view];
                    [self.footerDict setObject:view forKey:key];
                }
            }
        }
    }
    
    // Important to add this after setting the headers, footers, left side cells, so it is on top
    if (self.leftHeader!=nil) {
        CGRect frame = CGRectZero;
        frame.size.width = self.leftSize.width;
        frame.size.height = self.headerSize.height;
        self.leftHeader.frame = frame;
        [self addSubview:self.leftHeader];
    }
    if (self.leftFooter!=nil) {
        CGRect frame = CGRectZero;
        frame.origin.y = self.frame.size.height-self.footerSize.height;
        frame.size.width = self.leftSize.width;
        frame.size.height = self.footerSize.height;
        self.leftFooter.frame = frame;
        [self addSubview:self.leftFooter];
    }
    
    // Get the inner cells
    for (NSInteger x = colIndex-padNum; x <= lastColIndex+padNum; x++) {
        if (x>=0 && x<colCount) {
            for (NSInteger y = rowIndex-padNum; y <= lastRowIndex+padNum; y++) {
                if (y>=0 && y<rowCount) {
                    NSString *key = [NSString stringWithFormat:TABLE_GRID_STR_DEC_DEC,x,y];
                    
                    CGRect frame = CGRectZero;
                    frame.origin.x = self.cellSize.width*x;
                    frame.origin.y = self.cellSize.height*y;
                    frame.size.width = self.cellSize.width;
                    frame.size.height = self.cellSize.height;
                    
                    CGRect svFrame = [self.scrollview convertRect:frame toView:self];
                    svFrame.origin.x -= self.leftSize.width;
                    svFrame.origin.y -= self.headerSize.height;
                    
                    if (svFrame.origin.x<(self.cellSize.width*-1.0)
                        || svFrame.origin.x>((self.cellSize.width*maxColShown)+self.cellSize.width)
                        || svFrame.origin.y<(self.cellSize.height*-1)
                        || svFrame.origin.y>((self.cellSize.height*maxRowShown)+self.cellSize.height) ) {
                        UIView *view = [self.innerCellDict objectForKey:key];
                        if (view!=nil) {
                            [view removeFromSuperview];
                            [self.innerCellDict removeObjectForKey:key];
                        }
                    } else {
                        UIView *view = [self.innerCellDict objectForKey:key];
                        if (view==nil) {
                            view = [self.tableGridDelegate tableGridView:self viewForCellWithIndex:CGPointMake(x, y)];
                            if (view==nil) {
                                NSLog(@"Delegate did not return a Cell UIView for coord (%d,%d)",x,y);
                                abort();
                            }
                        }
                        view.frame = frame;
                        [self.viewOfCells addSubview:view];
                        [self.innerCellDict setObject:view forKey:key];
                    }
                }
            }
        }
    }
    
    if (self.scrollToTop) {
        self.scrollToTop = NO;
        [self.scrollview scrollsToTop];
        [self.scrollview scrollRectToVisible:CGRectMake(0,0,0,0) animated:YES];
    }
    
}

- (void)reload {
    self.needsRender = YES;
    [self.leftHeader removeFromSuperview];
      self.leftHeader = nil;
    self.leftFooter = nil;
    if (self.leftFooter!=nil) {
        [self.leftFooter removeFromSuperview];
        self.leftFooter = nil;
    }
    // Remove all cell views...
    NSArray *subViews = [self.viewOfCells subviews];
    for (UIView *subview in subViews) {
        [subview removeFromSuperview];
    }
    // Remove all other headers, footers, and leftside cells.
    subViews = [self subviews];
    for (UIView *subview in subViews) {
        if (![subview isEqual:self.scrollview]) {
            [subview removeFromSuperview];
        }
    }
    [self.headerDict removeAllObjects];
    [self.leftSideDict removeAllObjects];
    [self.innerCellDict removeAllObjects];
    [self.footerDict removeAllObjects];
    
    if (self.numberOfColumns>[self.tableGridDelegate numberOfColumns]) {
        self.scrollToLeft = YES;
    }
    if (self.numberOfRows>[self.tableGridDelegate numberOfRows]) {
        self.scrollToTop = YES;
    }
    
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (UIView*)viewForHeaderForColumn:(NSInteger)col {
    return [self.headerDict objectForKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC,col]];
}

- (UIView*)viewForLeftCellForRow:(NSInteger)row {
    return [self.leftSideDict objectForKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC,row]];
}

- (UIView*)viewForCellWithIndex:(CGPoint)index {
    return [self.innerCellDict objectForKey:[NSString stringWithFormat:TABLE_GRID_STR_FLOAT,index.x,index.y]];
}

- (UIView*)viewForFooterForColumn:(NSInteger)col {
    return [self.footerDict objectForKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC,col]];
}

- (void)scrollToColumn:(NSInteger)column {
    if (column>=0 && column<=[self.tableGridDelegate numberOfColumns]) {
        self.scrollToColumn = column;
        [self setNeedsLayout];
    }
}

// Methods for updating the Header objects
- (void)insertHeaderForColumn:(NSInteger)col {
    // Verify that we can add this header into our tableGrid
    if (col<=self.numberOfColumns) {
        // First move everything to the right of this insert col to the right.
        for (NSInteger x = self.numberOfColumns-1; x >= col; x--) {
            UIView *header = [self.headerDict objectForKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC,x]];
            if (header) {
                CGRect frame = header.frame;
                frame.origin.x += frame.size.width;
                header.frame = frame;
                [self.headerDict setObject:header forKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC,x+1]];
                [self.headerDict removeObjectForKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC,x]];
            }
            // Push anything innerCells right of the column, +1
            for (NSInteger y = 0; y < self.numberOfRows; y++) {
                UIView *innerCell = [self.innerCellDict objectForKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC_DEC,x,y]];
                if (innerCell) {
                    CGRect frame = innerCell.frame;
                    frame.origin.x += frame.size.width;
                    innerCell.frame = frame;
                    [self.innerCellDict setObject:innerCell forKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC_DEC,x+1,y]];
                    [self.innerCellDict removeObjectForKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC_DEC,x,y]];
                }
            }
            // Push anything headerCells right of the column, +1
            UIView *footer = [self.footerDict objectForKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC,x]];
            if (footer) {
                CGRect frame = footer.frame;
                frame.origin.x += frame.size.width;
                footer.frame = frame;
                [self.footerDict setObject:footer forKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC,x+1]];
                [self.footerDict removeObjectForKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC,x]];
            }
        }
        
        // Get the new view from the delegate
        NSString *key = [NSString stringWithFormat:TABLE_GRID_STR_DEC,col];
        UIView *header = [self.tableGridDelegate tableGridView:self viewForHeaderForColumn:col];
        if (header==nil) {
            NSLog(@"Delegate did not return a Header UIView for Column %d",col);
            abort();
        }
        CGPoint offSet = [self getOffSet];
        CGRect frame = CGRectZero;
        frame.origin.x = self.leftSize.width+(self.headerSize.width*col)+offSet.x;
        frame.size.width = self.headerSize.width;
        frame.size.height = self.headerSize.height;
        header.frame = frame;
        [self addSubview:header];
        [self.headerDict setObject:header forKey:key];
        
        // Now add the innerCells for this header
        for (NSInteger y = 0; y < self.numberOfRows; y++) {
            NSString *key = [NSString stringWithFormat:TABLE_GRID_STR_DEC_DEC,col,y];
            UIView *view = [self.tableGridDelegate tableGridView:self viewForCellWithIndex:CGPointMake(col, y)];
            if (view==nil) {
                NSLog(@"Delegate did not return a Cell UIView for coord (%d,%d)",col,y);
                abort();
            }
            CGRect frame = CGRectZero;
            frame.origin.x = self.cellSize.width*col;
            frame.origin.y = self.cellSize.height*y;
            frame.size.width = self.cellSize.width;
            frame.size.height = self.cellSize.height;
            view.frame = frame;
            [self.viewOfCells addSubview:view];
            [self.innerCellDict setObject:view forKey:key];
        }
        
        // If we are showing the footer, add a footer for the tableGrid.
        if ([self.tableGridDelegate respondsToSelector:@selector(tableGridView:viewForFooterForColumn:)]) {
            UIView *footer = [self.tableGridDelegate tableGridView:self viewForFooterForColumn:col];
            if (footer) {
                CGRect frame = header.frame;
                frame.origin.y = self.scrollview.frame.size.height-self.footerSize.height;
                frame.size.width = self.footerSize.width;
                frame.size.height = self.footerSize.height;
                footer.frame = frame;
                [self addSubview:footer];
                [self.footerDict setObject:footer forKey:key];
            }
        }
        
        // Lastly, increase the number of columns
        self.numberOfColumns+=1;
    }
}

- (void)deleteHeaderForColumn:(NSInteger)col {
    // First find the header
    UIView *header = [self.headerDict objectForKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC,col]];
    if (header) {
        // We have a header, so remove it.
        [self.headerDict removeObjectForKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC,col]];
        [header removeFromSuperview];
        // Now remove any innerCells for this column.
        for (NSInteger row = 0; row < self.numberOfRows; row++) {
            UIView *innerCell = [self.innerCellDict objectForKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC_DEC,col,row]];
            if (innerCell) {
                [innerCell removeFromSuperview];
                [self.innerCellDict removeObjectForKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC_DEC,col,row]];
            }
        }
        // Next remove the footer views (if applicable) for this column
        UIView *footer = [self.footerDict objectForKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC,col]];
        if (footer) { // We have a header, so remove it.
            [footer removeFromSuperview];
            [self.footerDict removeObjectForKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC,col]];
        }
        
        // The entire column has been removed, so now lets push all the visible views to the right of this column, with a -1
        for (NSInteger x = col+1; x < self.numberOfColumns; x++) {
            // Push anything headerCells right of the column, -1
            header = [self.headerDict objectForKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC,x]];
            if (header) {
                CGRect frame = header.frame;
                frame.origin.x -= frame.size.width;
                header.frame = frame;
                [self.headerDict setObject:header forKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC,x-1]];
                [self.headerDict removeObjectForKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC,x]];
            }
            // Push anything innerCells right of the column, -1
            for (NSInteger y = 0; y < self.numberOfRows; y++) {
                UIView *innerCell = [self.innerCellDict objectForKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC_DEC,x,y]];
                if (innerCell) {
                    CGRect frame = innerCell.frame;
                    frame.origin.x -= frame.size.width;
                    innerCell.frame = frame;
                    [self.innerCellDict setObject:innerCell forKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC_DEC,x-1,y]];
                    [self.innerCellDict removeObjectForKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC_DEC,x,y]];
                }
            }
            // Push anything footers right of the column, -1
            footer = [self.footerDict objectForKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC,x]];
            if (footer) {
                CGRect frame = footer.frame;
                frame.origin.x -= frame.size.width;
                footer.frame = frame;
                [self.footerDict setObject:footer forKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC,x-1]];
                [self.footerDict removeObjectForKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC,x]];
            }
        }
        // Now decrease the max number of columns.
        self.numberOfColumns-=1;
    }
}

// Methods for updating the LeftCell objects
- (void)insertLeftCellForRow:(NSInteger)row {
    // Verify that we can add this leftCell into our tableGrid
    if (row<=self.numberOfRows) {
        // First move everything to the below this insert row down one.
        for (NSInteger y = self.numberOfRows-1; y >= row; y--) {
            UIView *leftCell = [self.leftSideDict objectForKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC,y]];
            if (leftCell) {
                CGRect frame = leftCell.frame;
                frame.origin.y += frame.size.height;
                leftCell.frame = frame;
                [self.leftSideDict setObject:leftCell forKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC,y+1]];
                [self.leftSideDict removeObjectForKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC,y]];
            }
            // Push anything innerCells right of the column, +1
            for (NSInteger x = 0; x < self.numberOfColumns; x++) {
                UIView *innerCell = [self.innerCellDict objectForKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC_DEC,x,y]];
                if (innerCell) {
                    CGRect frame = innerCell.frame;
                    frame.origin.y += frame.size.height;
                    innerCell.frame = frame;
                    [self.innerCellDict setObject:innerCell forKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC_DEC,x,y+1]];
                    [self.innerCellDict removeObjectForKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC_DEC,x,y]];
                }
            }
        }
        
        // Get the new view from the delegate
        UIView *leftCell = [self.tableGridDelegate tableGridView:self viewForLeftCellForRow:row];
        if (leftCell==nil) {
            NSLog(@"Delegate did not return a LeftSide UIView for Row %d",row);
            abort();
        }
        CGPoint offSet = [self getOffSet];
        CGRect frame = CGRectZero;
        frame.origin.y = self.leftSize.height+(self.headerSize.height*row)+offSet.y;
        frame.size.width = self.headerSize.width;
        frame.size.height = self.headerSize.height;
        leftCell.frame = frame;
        [self addSubview:leftCell];
        //        [self insertSubview:leftCell belowSubview:scrollview];
        [self.leftSideDict setObject:leftCell forKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC,row]];
        
        // Now add the innerCells for the leftCell
        for (NSInteger x = 0; x < self.numberOfRows; x++) {
            UIView *view = [self.tableGridDelegate tableGridView:self viewForCellWithIndex:CGPointMake(x, row)];
            if (view==nil) {
                NSLog(@"Delegate did not return a Cell UIView for coord (%d,%d)",x,row);
                abort();
            }
            CGRect frame = CGRectZero;
            frame.origin.x = self.cellSize.width*x;
            //            frame.origin.x = self.leftSize.width+self.cellSize.width*x;
            frame.origin.y = self.cellSize.height*row;
            frame.size.width = self.cellSize.width;
            frame.size.height = self.cellSize.height;
            view.frame = frame;
            [self.viewOfCells addSubview:view];
            [self.innerCellDict setObject:view forKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC_DEC,x,row]];
        }
        
        // Lastly, increase the number of rows
        self.numberOfRows+=1;
    }
}

- (void)deleteLeftCellForRow:(NSInteger)row {
    // First find the leftCell
    UIView *leftCell = [self.leftSideDict objectForKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC,row]];
    if (leftCell) {
        // We have a leftCell, so remove it.
        [self.leftSideDict removeObjectForKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC,row]];
        [leftCell removeFromSuperview];
        // Now remove any innerCells for this row.
        for (NSInteger col = 0; col < self.numberOfColumns; col++) {
            UIView *innerCell = [self.innerCellDict objectForKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC_DEC,col,row]];
            if (innerCell) {
                [innerCell removeFromSuperview];
                [self.innerCellDict removeObjectForKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC_DEC,col,row]];
            }
        }
        
        // The entire row has been removed, so now lets push all the visible views below this row, up with a -1
        for (NSInteger y = row+1; y < self.numberOfRows; y++) {
            // Push anything leftCell below of the row, -1
            leftCell = [self.leftSideDict objectForKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC,y]];
            if (leftCell) { 
                CGRect frame = leftCell.frame;
                frame.origin.y -= frame.size.height;
                leftCell.frame = frame;
                [self.leftSideDict setObject:leftCell forKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC,y-1]];
                [self.leftSideDict removeObjectForKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC,y]];
            }
            // Push anything innerCells below of the row, -1
            for (NSInteger col = 0; col < self.numberOfColumns; col++) {
                UIView *innerCell = [self.innerCellDict objectForKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC_DEC,col,y]];
                if (innerCell) {
                    CGRect frame = innerCell.frame;
                    frame.origin.y -= frame.size.height;
                    innerCell.frame = frame;
                    [self.innerCellDict setObject:innerCell forKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC_DEC,col,y-1]];
                    [self.innerCellDict removeObjectForKey:[NSString stringWithFormat:TABLE_GRID_STR_DEC_DEC,col,y]];
                }
            }
        }
        // Now decrease the max number of rows.
        self.numberOfRows-=1;
    }
}
- (void)allowBouncing:(BOOL)allow {
    self.scrollview.bounces = allow;
    self.scrollview.alwaysBounceVertical = allow;
    self.scrollview.alwaysBounceHorizontal = allow;
}

- (void)dealloc {
    tableGridDelegate = nil;
    [self.headerDict removeAllObjects];
    [self.leftSideDict removeAllObjects];
    [self.innerCellDict removeAllObjects];
    [self.footerDict removeAllObjects];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

@end
