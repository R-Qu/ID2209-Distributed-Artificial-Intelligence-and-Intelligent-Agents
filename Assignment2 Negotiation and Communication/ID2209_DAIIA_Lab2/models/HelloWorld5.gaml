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
		create HelloAgent number: 6
		{
			location <- {10 + addDist,10 + addDist};
			addDist <- addDist + 15;
			
			target_point <- {rnd(100),rnd(100)};
		}
	}
	reflex globalPrint
	{
		write "Step of simulation: " +time;
	}
}
species HelloAgent skills: [moving]{
	rgb myColor <- #red;
	
	bool haveMet <- false;
	
	point target_point;
	
	reflex changeColor when: !haveMet {
		myColor <- flip(0.5) ? #red : #blue;
	}
	
	reflex goToPoint when: myColor = #red and !haveMet
	{
		do goto target:target_point speed: 3;
		if(location distance_to(target_point ) < 3)
		{
			target_point <- {rnd(100),rnd(100)};
		}
	}
	
	reflex logBlueColor when: myColor = #blue and !haveMet {
		write self.name + " says: I'm blue da ba dee da ba daa";
		// Sqrt(50) = 7.07
		ask HelloAgent at_distance 7.1
		{
			if(myself.myColor = #blue and self.myColor = #blue)
			{
				write "We are both blue!";
				write "Agents managed to meet at time: "+ cycle;
				self.haveMet <- true;
				myself.haveMet <- true;
			}
		}
	}
	
	aspect default{
    	draw sphere(2) at: location color: myColor ;
		if(!haveMet)
    	{
    		draw box(2,2,2) at: target_point color: #black;
    		draw line([location,target_point]) color:#black;
    	}
    	draw cylinder(7.1,1) at:{location.x,location.y, location.z-3} color: # green;
    }
}


experiment main type: gui {
	output {
		display map type: opengl 
		{
			species HelloAgent ;
		}
		display chart
		{
			chart "Agent information"
			{
				data "Agents blue color" value:length(HelloAgent where (each.myColor = #blue));
				data "Have met another blue" value:length(HelloAgent where (each.haveMet = true));
			}
		}
	}
}