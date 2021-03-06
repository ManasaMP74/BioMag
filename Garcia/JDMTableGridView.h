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

#import <UIKit/UIKit.h>

@protocol JDMTableGridViewDelegate;

@interface JDMTableGridView : UIView <UIScrollViewDelegate>

@property (nonatomic,assign) id<JDMTableGridViewDelegate> tableGridDelegate;

- (void)reload;

- (UIView*)viewForHeaderForColumn:(NSInteger)col;
- (UIView*)viewForLeftCellForRow:(NSInteger)row;
- (UIView*)viewForCellWithIndex:(CGPoint)index;
- (UIView*)viewForFooterForColumn:(NSInteger)col;

- (void)scrollToColumn:(NSInteger)column;

// Methods for updating the Header objects
- (void)insertHeaderForColumn:(NSInteger)col;
- (void)deleteHeaderForColumn:(NSInteger)col;

// Methods for updating the LeftCell objects
- (void)insertLeftCellForRow:(NSInteger)row;
- (void)deleteLeftCellForRow:(NSInteger)row;
- (void)allowBouncing:(BOOL)allow;

@end

@protocol JDMTableGridViewDelegate <NSObject>

@required

- (NSInteger)numberOfColumns;
- (NSInteger)numberOfRows;

- (CGSize)sizeOfHeaderCell;
- (CGSize)sizeOfLeftCell;

- (UIView *)topLeftFloaterViewForTableGridView:(JDMTableGridView *)tgv;
- (UIView *)tableGridView:(JDMTableGridView *)tgv viewForHeaderForColumn:(NSInteger)col;
- (UIView *)tableGridView:(JDMTableGridView *)tgv viewForLeftCellForRow:(NSInteger)row;
- (UIView *)tableGridView:(JDMTableGridView *)tgv viewForCellWithIndex:(CGPoint)index;

@optional

- (CGFloat)heightOfFooterCell;
- (UIView *)bottomLeftFloaterViewForTableGridView:(JDMTableGridView *)tgv;
- (UIView *)tableGridView:(JDMTableGridView *)tgv viewForFooterForColumn:(NSInteger)col;

@end
