@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>

@implementation UserInterfaceObjects : CPObject
{
	CPArray items;
}

- (id)init
{
	self = [super init];
	if (self)
	{
		items = @[
			"CPButton", 
			"CPTextField",
			"CPCheckBox",
			"CPRadio",
			"CPPopUpButton",
			"CPProgressIndicator",
			"CPColorWell",
			"CPStepper",
			"CPSlider",
			"CPSegmentedControl",
			"CPPredicateEditor",
			"CPButtonBar"
			];
	}
	return self;
}

- (int)numberOfRowsInTableView:(CPTableView)aTableView
{
	return [items count];
}

- (id)tableView:(CPTableView)aTableView objectValueForTableColumn:(CPTableColumn)aColumn row:(int)aRowIndex
{
	return [items objectAtIndex:aRowIndex];
}

@end
