//////////////////////////////////////////////////////////////////
//
//	IMPORTANT
//
//	INNER X = NOT OK (only important when LEDs x != LEDs y
//	SIDES and TOPCOVER NOT OK
//
//
//////////////////////////////////////////////////////////////////



use <TextGenerator.scad>

LEDs_X = 8;		// Amount of LEDs in X direction
LEDs_Y = 8;		// Amount of LEDs in Y direction

// Raspberry Pi Size
RPIx = 86;	//without SD card!
RPIy = 56;
RPIz = 21;

//Beagle Bone Black
BBBx = 87;	//without size of ETH JACK
BBBy = 54;
BBBz = 21;	//ESTIMATED!

//Arduino
ARDx = 54;
ARDy = 69;
ARDz = 21;	//ESTIMATED

LEDx = 35;		//Size of LED x
LEDy = 35;		//Size of LED y
LEDD = 5;		//Depth of LED in backpanel
CaW = 10;		//Cable Width
CaL = 100;		//Cable Lenght
CaD = 5;			//Depth of Cable in backpanel
// P = 150; 		// LED Pitch, center to center
P = CaL + ( LEDx / 2 );
ILD = 3;			//interlock depth

TfW = (LEDs_X*P);		//Total Frame Width
TfH = (LEDs_Y*P);		//Total Frame Height
TfD = 100; 			// Total Frame Depth

Ift = 4; 			// Inner frame thickness
Oft = Ift; 	// Outer frame thickness
Bt = 18;			// Thickness of bottom layer
Ct = 3;			// Thickness of cover

Bw = TfW-(2*Oft);		// Bottom frame Width
Bh = TfH-(2*Oft);	    // Bottom frame Height

IfD = TfD - Bt - Ct; 
/* 
	Inner Frame Depth 
		= Total Depth - Bottom layer Thickness - Top Layer Thickness
*/

TXT_SIZE = 7;
TXT_COLOR = [0.1,0.5,0.1];

//Bottom Plate
//	LEDMilling = 1 -> bottom panel with milling for LEDS
// 	LEDMilling != 1 -> milling for inner structure
module bottom_plate(LEDMilling)	
{
	color([137/255,104/255,238/255,1])
	difference()
	{
		cube([Bw , Bh , Bt]);
		for (x = [0 : LEDs_X-1])
		{
			for (y = [0 : LEDs_Y-1]) 
			{
				translate([P/2 - LEDx/2 + P*x - Oft, P/2 - LEDy/2 + P*y - Oft, Bt - LEDD + 1])
				if (LEDMilling == 1) cube([LEDx , LEDy , LEDD]);
				if (y < LEDs_Y -1)
				{
					translate([P/2 - CaW/2 + P*x - Oft, P - CaL/2 + P*y - Oft, Bt - CaD + 1])
					if (LEDMilling == 1) cube([CaW , CaL , CaD]);
					translate([0,P*(y+1)-Oft-Ift/2,Bt-ILD+1])
					if (LEDMilling != 1) cube([Bw, Ift, ILD+1]);
				}
				
			}

			if (x < LEDs_X-1)
			{
				if (x%2 == 1) 
				{
					translate([P - (CaL+LEDx)/2 + P*x - Oft, P/2 + LEDy / 2 + P*(LEDs_Y-1) - 1 - Oft , Bt - CaD + 1])
					if (LEDMilling == 1) cube([CaL + LEDx, CaW , CaD]);
				}
				else
				{
					translate([P - (CaL+LEDx)/2 + P*x - Oft, P/2 - LEDy /2 - CaW + 1 - Oft, Bt - CaD + 1]) 
					if (LEDMilling == 1) cube([CaL + LEDx, CaW , CaD]);
				}
				translate([P*(x+1)-Oft-Ift/2,0,Bt-ILD+1])
				if (LEDMilling != 1) cube([Ift, Bw, ILD+1]);
			}
		}
	}
}

//Inner plates X direction
module inner_x()
{
	color([0.4,0.2,1])
	union() {
		for (z = [0 : LEDs_X-2]) 
		{
			translate([ P*z+Oft , 0 , 0])
	    		cube([ P-Ift , Ift  ,IfD+ILD]);
			translate([ (P*(z+1))-Ift+Oft , 0 , (IfD/2)])
			cube([Ift , Ift , IfD/2+ILD]);    	
		}
		translate([ P*(LEDs_X-1)+Oft , 0 , 0])
		cube([ P-Ift ,Ift , IfD]);
	}
}

//Inner plates Y direction
module inner_y()
{	
	color([0.4,1,0.5])
	union() {
		translate([0 , Oft+Oft/2 ,0])
	    	cube([ Ift, P-Ift-Oft/2 , IfD+ILD]); //First part without outer frame thickness
		for (z = [0 : LEDs_Y-2]) 
		{
			translate([0 , P*z+Oft ,0])
	    		if (z > 0) cube([ Ift, P-Ift , IfD+ILD]);  
			translate([ 0 , (P*(z+1))-Ift+Oft , 0 ])
			cube([ Ift , Ift , IfD/2]);
			  	
		}
		translate([0, P*(LEDs_Y-1)+Oft, 0])
		cube([Ift , P-Ift-Oft/2 , IfD+ILD]);	//Laste part without outer frame thickness
	}
}


//Top Cover
module top_cover(opacity) 
{
	translate([Oft,Oft,TfD-Ct])
	color([0.2,0.2,0.2,opacity/100])
	cube([TfW-(2*Oft),TfH-(2*Oft),Ct]);
}

//Side X
module side_x() 
{
	color([0.3,0.2,0.4])
	cube([TfW-Oft,Oft,TfD]);
}
//Side Y
module side_y() 
{
	color([0.4,0.5,0.4])
	cube([Oft,TfH-Oft,TfD]);
}

//////////////////////////////////////////////////////
//
//		Draw complete frame
//
//////////////////////////////////////////////////////

module complete_frame()
{
	translate([Oft,Oft,0])
	bottom_plate();
	translate([Oft,0,0])
	side_x();
	translate([0,TfH-Oft,0])
	side_x();
	translate([0,0,0])
	side_y();
	translate([TfW-Oft,Oft,0])
	side_y();
	for (i = [1 : LEDs_X-1])
	{
		translate([(P*i)-Oft , 0, Bt-ILD])
		inner_y();
	}
	for (i = [1 : LEDs_Y-1])
	{
		translate([0, (P*i)-Oft, Bt-ILD])
		inner_x();
	}
	
	top_cover(70);	//Generate top cover with specified opacity
}


//////////////////////////////////////////////////////
//
//		Draw Seperate panels
//
//////////////////////////////////////////////////////

module seperate_panels() {

	if(LEDs_X==LEDs_Y)
	{
		translate([-2*P,0,Ift/2])
		rotate(a=[0,90,0])
		inner_y();
		translate([-2*P,-P,0])
		color(TXT_COLOR)scale(TXT_SIZE)drawtext(str(LEDs_X+LEDs_Y-2 , "x"));
		translate([-2*P,-2*P,0])
		color(TXT_COLOR)scale(TXT_SIZE)drawtext(str(Ift, "mm"));
	
/*
		translate([-4*P,0,Oft/2])
		rotate(a=[0,90,0])
		side_y();
		translate([-4*P,-P,0])
		color(TXT_COLOR)scale(TXT_SIZE)drawtext("4x");
		translate([-4*P,-2*P,0])
		color(TXT_COLOR)scale(TXT_SIZE)drawtext(str(Oft, "mm"));
*/
		
	}
	else
	{
		translate([-2*P,0,Ift/2])
		rotate(a=[0,90,0])
		inner_y();
		translate([-2*P,-P,0])
		color(TXT_COLOR)scale(TXT_SIZE)drawtext(str(LEDs_X-1 , "x"));
		translate([-2*P,-2*P,0])
		color(TXT_COLOR)scale(TXT_SIZE)drawtext(str(Ift, "mm"));

		translate([IfD-(4*P),0,Ift/2])
		rotate(a=[270,0,90])
		inner_x();
		translate([-4*P,-P,0])
		color(TXT_COLOR)scale(TXT_SIZE)drawtext(str(LEDs_Y-1 , "x"));
		translate([-4*P,-2*P,0])
		color(TXT_COLOR)scale(TXT_SIZE)drawtext(str(Ift, "mm"));
		
		translate([-6*P,0,Oft/2])
		rotate(a=[0,90,0])
		side_y();
		translate([-6*P,-P,0])
		color(TXT_COLOR)scale(TXT_SIZE)drawtext("2x");
		translate([-6*P,-2*P,0])
		color(TXT_COLOR)scale(TXT_SIZE)drawtext(str(Oft, "mm"));
		
		translate([TfD-(8*P),0,Oft/2])
		rotate(a=[270,0,90])
		side_x();
		translate([-8*P,-P,0])
		color(TXT_COLOR)scale(TXT_SIZE)drawtext("2x");
		translate([-8*P,-2*P,0])
		color(TXT_COLOR)scale(TXT_SIZE)drawtext(str(Oft, "mm"));
	}

/*	
	translate([2*(TfW+P),0,-TfD+Ct])
	top_cover(100);
	translate([2*(TfW+P),-P,0])
	color(TXT_COLOR)scale(TXT_SIZE)drawtext("1x");
	translate([2*(TfW+P),-2*P,0])
	color(TXT_COLOR)scale(TXT_SIZE)drawtext(str(Ct, "mm"));
*/

	translate([0,0,1-Bt])
	bottom_plate(1);	//With LED milling
	translate([0,-P,0])
	color(TXT_COLOR)scale(TXT_SIZE)drawtext("1x");
	translate([0,-2*P,0])
	color(TXT_COLOR)scale(TXT_SIZE)drawtext(str(Bt, "mm thick"));
	translate([0,-3*P,0])
	color(TXT_COLOR)scale(TXT_SIZE)drawtext(str(CaD, "mm milled"));

	translate([TfW+P,0,1-Bt])
	bottom_plate(0);	//With inner structure milling
	translate([TfW+P,-P,0])
	color(TXT_COLOR)scale(TXT_SIZE)drawtext(str(ILD, "mm milled"));
 
}

//////////////////////////////////////////////////////
//
//		Draw Something
//
//////////////////////////////////////////////////////

//seperate_panels();
projection(cut = true) seperate_panels();
//complete_frame();
//bottom_plate();

//////////////////////////////////////////////////////
//
//		Print sizes
//
//////////////////////////////////////////////////////

echo(str("Overal Size = ",TfW ," mm x ", TfH ," mm x ",TfD," mm"));
echo(str("X Side Dimensions = ",TfW-Oft ," mm x ", TfD ," mm x ",Oft," mm"));
echo(str("Y Side Dimensions = ",TfH-Oft ," mm x ", TfD ," mm x ",Oft," mm"));
echo(str("Back Panel Dimensions = ",TfH-(2*Oft) ," mm x ", TfW-(2*Oft) ," mm x ",Bt," mm"));
echo(str("Cover Panel Dimensions = ",TfH-(2*Oft) ," mm x ", TfW-(2*Oft) ," mm x ",Ct," mm"));
echo(str(LEDs_Y-1," x Inner X Divide Dimensions = ",((LEDs_X - 1)*P) + P-Ift ," mm x ", TfD-Ct-Bt+ILD ," mm x ",Ift," mm"));
echo(str(LEDs_X-1," x Inner Y Divide Dimensions = ",((LEDs_Y - 1)*P) + P-Ift ," mm x ", TfD-Ct-Bt+ILD ," mm x ",Ift," mm"));

