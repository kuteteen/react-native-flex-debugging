//
//  IMLEXExplorerToolbar.m
//  Flipboard
//
//  Created by Ryan Olson on 4/4/14.
//  Copyright (c) 2020 Flipboard. All rights reserved.
//

#import "IMLEXColor.h"
#import "IMLEXExplorerToolbar.h"
#import "IMLEXExplorerToolbarItem.h"
#import "IMLEXResources.h"
#import "IMLEXUtility.h"

@interface IMLEXExplorerToolbar ()

@property (nonatomic, readwrite) IMLEXExplorerToolbarItem *globalsItem;
@property (nonatomic, readwrite) IMLEXExplorerToolbarItem *hierarchyItem;
@property (nonatomic, readwrite) IMLEXExplorerToolbarItem *selectItem;
@property (nonatomic, readwrite) IMLEXExplorerToolbarItem *recentItem;
@property (nonatomic, readwrite) IMLEXExplorerToolbarItem *moveItem;
@property (nonatomic, readwrite) IMLEXExplorerToolbarItem *closeItem;
@property (nonatomic, readwrite) UIView *dragHandle;

@property (nonatomic) UIImageView *dragHandleImageView;

@property (nonatomic) UIView *selectedViewDescriptionContainer;
@property (nonatomic) UIView *selectedViewDescriptionSafeAreaContainer;
@property (nonatomic) UIView *selectedViewColorIndicator;
@property (nonatomic) UILabel *selectedViewDescriptionLabel;

@property (nonatomic,readwrite) UIView *backgroundView;

@end

@implementation IMLEXExplorerToolbar

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Background
        self.backgroundView = [UIView new];
        self.backgroundView.backgroundColor = [IMLEXColor secondaryBackgroundColorWithAlpha:0.95];
        [self addSubview:self.backgroundView];

        // Drag handle
        self.dragHandle = [UIView new];
        self.dragHandle.backgroundColor = UIColor.clearColor;
        self.dragHandleImageView = [[UIImageView alloc] initWithImage:IMLEXResources.dragHandle];
        self.dragHandleImageView.tintColor = [IMLEXColor.iconColor colorWithAlphaComponent:0.666];
        [self.dragHandle addSubview:self.dragHandleImageView];
        [self addSubview:self.dragHandle];
        
        // Buttons
        self.globalsItem   = [IMLEXExplorerToolbarItem itemWithTitle:@"menu" image:IMLEXResources.globalsIcon];
        self.hierarchyItem = [IMLEXExplorerToolbarItem itemWithTitle:@"views" image:IMLEXResources.hierarchyIcon];
        self.selectItem    = [IMLEXExplorerToolbarItem itemWithTitle:@"select" image:IMLEXResources.selectIcon];
        self.recentItem    = [IMLEXExplorerToolbarItem itemWithTitle:@"recent" image:IMLEXResources.recentIcon];
        self.moveItem      = [IMLEXExplorerToolbarItem itemWithTitle:@"move" image:IMLEXResources.moveIcon sibling:self.recentItem];
        self.closeItem     = [IMLEXExplorerToolbarItem itemWithTitle:@"close" image:IMLEXResources.closeIcon];

        // Selected view box //
        
        self.selectedViewDescriptionContainer = [UIView new];
        self.selectedViewDescriptionContainer.backgroundColor = [IMLEXColor tertiaryBackgroundColorWithAlpha:0.95];
        self.selectedViewDescriptionContainer.hidden = YES;
        [self addSubview:self.selectedViewDescriptionContainer];

        self.selectedViewDescriptionSafeAreaContainer = [UIView new];
        self.selectedViewDescriptionSafeAreaContainer.backgroundColor = UIColor.clearColor;
        [self.selectedViewDescriptionContainer addSubview:self.selectedViewDescriptionSafeAreaContainer];
        
        self.selectedViewColorIndicator = [UIView new];
        self.selectedViewColorIndicator.backgroundColor = UIColor.redColor;
        [self.selectedViewDescriptionSafeAreaContainer addSubview:self.selectedViewColorIndicator];
        
        self.selectedViewDescriptionLabel = [UILabel new];
        self.selectedViewDescriptionLabel.backgroundColor = UIColor.clearColor;
        self.selectedViewDescriptionLabel.font = [[self class] descriptionLabelFont];
        [self.selectedViewDescriptionSafeAreaContainer addSubview:self.selectedViewDescriptionLabel];
        
        // toolbarItems
        self.toolbarItems = @[_globalsItem, _hierarchyItem, _selectItem, _moveItem, _closeItem];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];


    CGRect safeArea = [self safeArea];
    // Drag Handle
    const CGFloat kToolbarItemHeight = [[self class] toolbarItemHeight];
    self.dragHandle.frame = CGRectMake(CGRectGetMinX(safeArea), CGRectGetMinY(safeArea), [[self class] dragHandleWidth], kToolbarItemHeight);
    CGRect dragHandleImageFrame = self.dragHandleImageView.frame;
    dragHandleImageFrame.origin.x = IMLEXFloor((self.dragHandle.frame.size.width - dragHandleImageFrame.size.width) / 2.0);
    dragHandleImageFrame.origin.y = IMLEXFloor((self.dragHandle.frame.size.height - dragHandleImageFrame.size.height) / 2.0);
    self.dragHandleImageView.frame = dragHandleImageFrame;
    
    
    // Toolbar Items
    CGFloat originX = CGRectGetMaxX(self.dragHandle.frame);
    CGFloat originY = CGRectGetMinY(safeArea);
    CGFloat height = kToolbarItemHeight;
    CGFloat width = IMLEXFloor((CGRectGetWidth(safeArea) - CGRectGetWidth(self.dragHandle.frame)) / self.toolbarItems.count);
    for (IMLEXExplorerToolbarItem *toolbarItem in self.toolbarItems) {
        toolbarItem.currentItem.frame = CGRectMake(originX, originY, width, height);
        originX = CGRectGetMaxX(toolbarItem.currentItem.frame);
    }
    
    // Make sure the last toolbar item goes to the edge to account for any accumulated rounding effects.
    UIView *lastToolbarItem = self.toolbarItems.lastObject.currentItem;
    CGRect lastToolbarItemFrame = lastToolbarItem.frame;
    lastToolbarItemFrame.size.width = CGRectGetMaxX(safeArea) - lastToolbarItemFrame.origin.x;
    lastToolbarItem.frame = lastToolbarItemFrame;

    self.backgroundView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), kToolbarItemHeight);
    
    const CGFloat kSelectedViewColorDiameter = [[self class] selectedViewColorIndicatorDiameter];
    const CGFloat kDescriptionLabelHeight = [[self class] descriptionLabelHeight];
    const CGFloat kHorizontalPadding = [[self class] horizontalPadding];
    const CGFloat kDescriptionVerticalPadding = [[self class] descriptionVerticalPadding];
    const CGFloat kDescriptionContainerHeight = [[self class] descriptionContainerHeight];
    
    CGRect descriptionContainerFrame = CGRectZero;
    descriptionContainerFrame.size.width = CGRectGetWidth(self.bounds);
    descriptionContainerFrame.size.height = kDescriptionContainerHeight;
    descriptionContainerFrame.origin.x = CGRectGetMinX(self.bounds);
    descriptionContainerFrame.origin.y = CGRectGetMaxY(self.bounds) - kDescriptionContainerHeight;
    self.selectedViewDescriptionContainer.frame = descriptionContainerFrame;

    CGRect descriptionSafeAreaContainerFrame = CGRectZero;
    descriptionSafeAreaContainerFrame.size.width = CGRectGetWidth(safeArea);
    descriptionSafeAreaContainerFrame.size.height = kDescriptionContainerHeight;
    descriptionSafeAreaContainerFrame.origin.x = CGRectGetMinX(safeArea);
    descriptionSafeAreaContainerFrame.origin.y = CGRectGetMinY(safeArea);
    self.selectedViewDescriptionSafeAreaContainer.frame = descriptionSafeAreaContainerFrame;

    // Selected View Color
    CGRect selectedViewColorFrame = CGRectZero;
    selectedViewColorFrame.size.width = kSelectedViewColorDiameter;
    selectedViewColorFrame.size.height = kSelectedViewColorDiameter;
    selectedViewColorFrame.origin.x = kHorizontalPadding;
    selectedViewColorFrame.origin.y = IMLEXFloor((kDescriptionContainerHeight - kSelectedViewColorDiameter) / 2.0);
    self.selectedViewColorIndicator.frame = selectedViewColorFrame;
    self.selectedViewColorIndicator.layer.cornerRadius = ceil(selectedViewColorFrame.size.height / 2.0);
    
    // Selected View Description
    CGRect descriptionLabelFrame = CGRectZero;
    CGFloat descriptionOriginX = CGRectGetMaxX(selectedViewColorFrame) + kHorizontalPadding;
    descriptionLabelFrame.size.height = kDescriptionLabelHeight;
    descriptionLabelFrame.origin.x = descriptionOriginX;
    descriptionLabelFrame.origin.y = kDescriptionVerticalPadding;
    descriptionLabelFrame.size.width = CGRectGetMaxX(self.selectedViewDescriptionContainer.bounds) - kHorizontalPadding - descriptionOriginX;
    self.selectedViewDescriptionLabel.frame = descriptionLabelFrame;
}


#pragma mark - Setter Overrides

- (void)setToolbarItems:(NSArray<IMLEXExplorerToolbarItem *> *)toolbarItems {
    if (_toolbarItems == toolbarItems) {
        return;
    }
    
    // Remove old toolbar items, if any
    for (IMLEXExplorerToolbarItem *item in _toolbarItems) {
        [item.currentItem removeFromSuperview];
    }
    
    // Trim to 5 items if necessary
    if (toolbarItems.count > 5) {
        toolbarItems = [toolbarItems subarrayWithRange:NSMakeRange(0, 5)];
    }

    for (IMLEXExplorerToolbarItem *item in toolbarItems) {
        [self addSubview:item.currentItem];
    }

    _toolbarItems = toolbarItems.copy;

    // Lay out new items
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setSelectedViewOverlayColor:(UIColor *)selectedViewOverlayColor {
    if (![_selectedViewOverlayColor isEqual:selectedViewOverlayColor]) {
        _selectedViewOverlayColor = selectedViewOverlayColor;
        self.selectedViewColorIndicator.backgroundColor = selectedViewOverlayColor;
    }
}

- (void)setSelectedViewDescription:(NSString *)selectedViewDescription {
    if (![_selectedViewDescription isEqual:selectedViewDescription]) {
        _selectedViewDescription = selectedViewDescription;
        self.selectedViewDescriptionLabel.text = selectedViewDescription;
        BOOL showDescription = selectedViewDescription.length > 0;
        self.selectedViewDescriptionContainer.hidden = !showDescription;
    }
}


#pragma mark - Sizing Convenience Methods

+ (UIFont *)descriptionLabelFont {
    return [UIFont systemFontOfSize:12.0];
}

+ (CGFloat)toolbarItemHeight {
    return 44.0;
}

+ (CGFloat)dragHandleWidth {
    return IMLEXResources.dragHandle.size.width;
}

+ (CGFloat)descriptionLabelHeight {
    return ceil([[self descriptionLabelFont] lineHeight]);
}

+ (CGFloat)descriptionVerticalPadding {
    return 2.0;
}

+ (CGFloat)descriptionContainerHeight {
    return [self descriptionVerticalPadding] * 2.0 + [self descriptionLabelHeight];
}

+ (CGFloat)selectedViewColorIndicatorDiameter {
    return ceil([self descriptionLabelHeight] / 2.0);
}

+ (CGFloat)horizontalPadding {
    return 11.0;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat height = 0.0;
    height += [[self class] toolbarItemHeight];
    height += [[self class] descriptionContainerHeight];
    return CGSizeMake(size.width, height);
}

- (CGRect)safeArea {
    CGRect safeArea = self.bounds;
    if (@available(iOS 11.0, *)) {
        safeArea = UIEdgeInsetsInsetRect(self.bounds, self.safeAreaInsets);
    }

    return safeArea;
}

@end
