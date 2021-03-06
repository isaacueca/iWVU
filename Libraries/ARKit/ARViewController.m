//
//  ARViewController.m
//  ARKitDemo
//
//  Created by Niels W Hansen on 1/23/10.
//  Copyright 2010 Agilite Software. All rights reserved.
//

#import "ARViewController.h"
#import "AugmentedRealityController.h"
#import "GEOLocations.h"
#import "CoordinateView.h"

@implementation ARViewController

@synthesize agController;
@synthesize delegate;

-(id)initWithDelegate:(id<ARLocationDelegate>) aDelegate {
	
	
	self.delegate = aDelegate;
	
	if (!(self = [super init]))
		return nil;
	
	[self setWantsFullScreenLayout: YES];
	
	return self;
}

- (void)loadView {
	[self setAgController:[[AugmentedRealityController alloc] initWithViewController:self]];
	
	
	[agController setDebugMode:NO];
	[agController setScaleViewsBasedOnDistance:YES];
	[agController setMinimumScaleFactor:0.05];
	[agController setRotateViewsBasedOnPerspective:YES];
	
	GEOLocations* locations = [[GEOLocations alloc] initWithDelegate:delegate];
	
	if ([[locations getLocations] count] > 0) {
		for (ARCoordinate *coordinate in [locations getLocations]) {
			CoordinateView *cv = [[CoordinateView alloc] initForCoordinate:coordinate];
			[agController addCoordinate:coordinate augmentedView:cv animated:NO];
			[cv release];
		}
	}
	
	[locations release];
	
	
	UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 31, 31)];
	[backButton setImage:[UIImage imageNamed:@"BlackBackButton.png"] forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:backButton];
	[self.view bringSubviewToFront:backButton];
	[backButton release];
}


-(void)backButtonPressed{
	//can't pop viewController until camera overlay is removed
	//this can't be called in a viewWillDissapear or similar, because loading camera overlay calls those functions
	[agController removeAR];
	
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
	
	[agController displayAR];
	[super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
