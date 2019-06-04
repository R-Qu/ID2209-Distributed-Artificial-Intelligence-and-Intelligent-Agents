/**
* Name: HelloWorld
* Author: ottarg
* Description: Really cool agents saying hello to the world!
* Tags: Tag1, Tag2, TagN
*/

model HelloWorld
global {
	init
	{
		int addDist <- 0;
		create HelloAgent number: 2
		{
			location <- {50 + addDist,50 + addDist};
			addDist <- addDist + 5;
		}
	}
	reflex globalPrint
	{
		write "Step of simulation: " +time;
	}
}
species HelloAgent{
	rgb myColor <- #red;
	
	
	reflex changeColor {
		myColor <- flip(0.5) ? #red : #blue;
	}
	
	
	reflex logBlueColor when: myColor = #blue  {
		write self.name + " says: I'm blue da ba dee da ba daa";
		// Sqrt(50) = 7.07
		ask HelloAgent at_distance 7.1
		{
			if(myself.myColor = #blue and self.myColor = #blue)
			{
				write "We are both blue!";
			}
		}
	}
	
	aspect default{
    	draw sphere(2) at: location color: myColor ;
    }
}


experiment main type: gui {
	output {
		display map type: opengl 
		{
			species HelloAgent ;
		}
	}
}