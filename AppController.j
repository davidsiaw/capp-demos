/*
 * AppController.j
 * capp-demos
 *
 * Created by You on August 17, 2014.
 * Copyright 2014, Your Company All rights reserved.
 */

@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>

@import "UserInterfaceObjects.j"

@implementation AppController : CPObject
{
	CPView adjustView;
	CPView detailView;
	CPTableView navigationTableView;
	UserInterfaceObjects uiObjects;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
        contentView = [theWindow contentView];

    uiObjects = [[UserInterfaceObjects alloc] init];

    navigationTableView = [[CPTableView alloc] initWithFrame:CGRectMakeZero()];

    [navigationTableView setDataSource:uiObjects];
    [navigationTableView setDelegate:self];
	[navigationTableView setAutoresizingMask: CPViewWidthSizable | CPViewHeightSizable];
	[navigationTableView setGridStyleMask:CPTableViewSolidHorizontalGridLineMask];
	[navigationTableView setHeaderView:nil];

	var column = [[CPTableColumn alloc] initWithIdentifier:@"Menu"];
	[[column headerView] setStringValue:@"Menu"];
	[column setMinWidth:200];
	[column setResizingMask:CPTableColumnAutoresizingMask];
	[navigationTableView addTableColumn:column];

    var tableScrollView = [[CPScrollView alloc] initWithFrame:CGRectMakeZero()];
	[tableScrollView setAutoresizingMask: CPViewWidthSizable | CPViewHeightSizable];
    [tableScrollView setDocumentView:navigationTableView];


    detailView = [[CPView alloc] initWithFrame:CGRectMakeZero()];
    [detailView setBackgroundColor:[CPColor grayColor]];
	[detailView setAutoresizingMask: CPViewWidthSizable | CPViewHeightSizable];

    adjustView = [[CPView alloc] initWithFrame:CGRectMakeZero()];

    var detailSplitView = [[CPSplitView alloc] initWithFrame:CGRectMakeZero()];
    [detailSplitView setDelegate:self];
    [detailSplitView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable ];
    [detailSplitView setVertical:NO];

    [detailSplitView addSubview:detailView];
    [detailSplitView addSubview:adjustView];


    var splitView = [[CPSplitView alloc] initWithFrame:[contentView bounds]];
    [splitView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable ];

    [splitView addSubview:tableScrollView];
    [splitView addSubview:detailSplitView];

    [splitView setPosition:200 ofDividerAtIndex:0];



    [contentView addSubview:splitView];


    [theWindow orderFront:self];

    // Uncomment the following line to turn on the standard menu bar.
    //[CPMenu setMenuBarVisible:YES];
}



- (float)splitView:(CPSplitView)aSplitView constrainMinCoordinate:(float)proposedMin ofSubviewAt:(int)subviewIndex
{
	return [aSplitView bounds].size.height - 200;
}

- (float)splitView:(CPSplitView)aSplitView constrainMaxCoordinate:(float)proposedMax ofSubviewAt:(int)subviewIndex
{
	return [aSplitView bounds].size.height - 200;
}

- (void)splitView:(CPSplitView)aSplitView resizeSubviewsWithOldSize:(CGSize)oldSize
{
	var newSize = [aSplitView bounds].size;
	[detailView setFrameSize:CGSizeMake(newSize.width, newSize.height - 200)];
	[adjustView setFrameSize:CGSizeMake(newSize.width, 200)];
    [aSplitView setPosition:newSize.height - 200 ofDividerAtIndex:0];
}


- (void)tableViewSelectionDidChange:(CPNotification)aNotification
{
	var array = [detailView subviews];
	for (var i=0; i < array.length; i++) {
    	[[array objectAtIndex:i] removeFromSuperview];
	}

	var viewType = [[navigationTableView dataSource] 
								tableView:[navigationTableView dataSource]
				objectValueForTableColumn:0 
									  row:[navigationTableView selectedRow] ];
	
	var bounds = [detailView bounds];

	var cls = CPClassFromString(viewType);

	var view = [[cls alloc] init];
	if (![view respondsToSelector:@selector(sizeToFit)]) {
		view = [view initWithFrame:CGRectMake(0,0,100,25)];
	}

	var methods = class_copyMethodList(cls);

	for (var i=0; i<methods.length; i++) {
		var method = methods[i];
		if (method.name.indexOf("set") == 0 && method.types.length == 2) {
			console.log(method.name);
		}
	}

	[view setTheme:[CPTheme defaultTheme]];
	[view setBackgroundColor:[CPColor whiteColor]];
	if ([view respondsToSelector:@selector(sizeToFit)]) {
		[view sizeToFit];
	}
	[view setCenter:CGPointMake(bounds.size.width / 2, bounds.size.height / 2)];
	[detailView addSubview:view];

}

@end
