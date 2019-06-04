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
	
	
	aspect default{
    	draw sphere(2) at: location color: #red ;
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