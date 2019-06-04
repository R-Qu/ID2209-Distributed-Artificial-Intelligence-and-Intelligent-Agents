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
		create HelloAgent number: 2
		{
		}
	}
}
species HelloAgent{
	rgb myColor <- #red;
	
	reflex changeColor {
		myColor <- flip(0.5) ? #red : #blue;
	}
	
	reflex logBlueColor when: myColor = #blue {
		write self.name + " says: I'm blue da ba dee da ba daa";
		
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