/***
* Name: NewModel
* Author: mkm
* Description: 
* Tags: Tag1, Tag2, TagN
***/

model NewModel

global {
	bool securityalert;
	bool movebaddy;
	bool baddyalert;
	point baddypoint;
	
	emotion joy <- new_emotion("joy");
	
	init
	{
		create Entrance number: 1
		{
			location <- {1,50};
		}
		create InformationCenter number: 1
		{
			securityalert <- false;
			baddyalert <- false;
			location <- {50,50};
		}
		create Pub number: 1
		{
			location <- {5,2.5};
		}
		create JuiceParlor number: 1
		{
			location <- {95,2.5};
		}
		create VeganRestaurant number: 1
		{
			location <- {5,97.5};
		}
		create NonVegRestaurant number: 1
		{
			location <- {95,97.5};
		}
		create WC number: 1
		{
			location <- {50,97.5};
		}
		create Guest_Singles_WM number: 2
		{
			location <- {rnd(100),rnd(100)};
			informed <- false;
			thirst <- rnd(100);
			hunger <-rnd(100);
			wc <- rnd(100);
			iter <- 1;
			wait <- 20;
			targetpoint <- {rnd(100),rnd(100)};
			JuiceParlorPoint <- {0,0};
			PubPoint <- {0,0};
			VeganRestaurantPoint <- {0,0};
			NonVegRestaurantPoint <- {0,0};
			WCPoint <- {0,0};
		}
	}
}

species Entrance{
	aspect default{
    	draw box(2,15,2) at: location color: #violet lighted: bool(1) ;
    }
}
species InformationCenter{
	reflex foundbaddy when: baddyalert = true
	{
		securityalert <- true;
	}
	aspect default{
    	draw pyramid(10) at: location color: #orange lighted: bool(1) ;
    }
}
species Pub{
	aspect default{
    	draw box(10,5,2) at: location color: #blue lighted: bool(1) ;
    }
}
species JuiceParlor{
	aspect default{
    	draw box(10,5,2) at: location color: #yellow lighted: bool(1) ;
    }
}
species VeganRestaurant{
	aspect default{
    	draw box(10,5,2) at: location color: #cyan lighted: bool(1) ;
    }
}
species NonVegRestaurant{
	aspect default{
    	draw box(10,5,2) at: location color: #red lighted: bool(1) ;
    }
}
species WC{
	aspect default{
    	draw box(10,5,2) at: location color: #grey lighted: bool(1) ;
    }
}
species Guest_Singles_WM skills: [moving]{
	int thirst;
	int hunger;
	int wc;
	int wait;
	int iter;
	bool informed;
	point targetpoint;
	point JuiceParlorPoint;
	point PubPoint;
	point VeganRestaurantPoint;
	point NonVegRestaurantPoint;
	point WCPoint;
	
	reflex roamaround when: (thirst > 0 and hunger > 0 and wc > 0)
	{
		do goto target:targetpoint speed: 3.0;
		if(location distance_to(targetpoint) < 3)
		{
			targetpoint <- {rnd(100),rnd(100)};
		}
		thirst <- thirst - 1;
		hunger <- hunger -1;
		wc <- wc - 1;
		iter <- iter * -1;
	}
	
	reflex gotoInformationCentre when: ((thirst <= 0 and (JuiceParlorPoint = {0,0} or PubPoint = {0,0})) or (hunger <= 0 and (NonVegRestaurantPoint = {0,0} or VeganRestaurantPoint = {0,0})) or (wc <= 0 and WCPoint = {0,0})) and informed = false 
	{
		if thirst <= 0
		{
			write name + "says: Ah.. I'm thirsty.";
			if iter = 1
			{
				targetpoint <- {95,2.5}; // JuiceParlor
			}
			else
			{
				targetpoint <- {5,2.5}; // Pub
			}
		}
		else if hunger <= 0
		{
			write name + "says: Ah.. I'm hungry.";
			if iter = 1
			{
				targetpoint <- {95,97.5}; // NonVegRestaurant
			}
			else
			{
				targetpoint <- {5,97.5}; // VeganRestaurant
			}
		}
		else if wc <= 0
		{
			write name + "says: OMG.. I've to pee/poo.";
			targetpoint <- {50,97.5}; // WC
		}
		else
		{
			targetpoint <- {rnd(100),rnd(100)};
		}
		do goto target:{50,50} speed: 3.0;
		if(location = {50,50})
		{
			if wait <= 0
			{
				write name + "says: We're informed";
				informed <- true;
				wait <- 20;
			}
			wait <- wait - 1;
		}
	}
	
	reflex fromInformationCentre when: informed = true or (thirst <= 0 and JuiceParlorPoint != {0,0} and PubPoint != {0,0}) or (hunger <= 0 and NonVegRestaurantPoint != {0,0} and VeganRestaurantPoint != {0,0}) or (wc <= 0 and WCPoint != {0,0})
	{
		if thirst <= 0
		{
			if informed = true
			{
				// Guided from information centre.
				self.JuiceParlorPoint <- {95,2.5}; // Memorize
				self.PubPoint <- {5,2.5}; // Memorize
				if iter = 1
				{
					targetpoint <- self.PubPoint;
				}
				else
				{
					targetpoint <- self.JuiceParlorPoint;
				}
			}
			else
			{
				write name + "says: Ah.. I'm thirsty.";
				if iter = 1
				{
					targetpoint <- self.PubPoint;
				}
				else
				{
					targetpoint <- self.JuiceParlorPoint;
				}
			}
			do goto target:targetpoint speed: 3.0;
			if(location = targetpoint)
			{
				if wait <= 0
				{
					write self.name + "says: Feeling Great!... Lets roam again.";
					thirst <- rnd(100);
					informed <- false;
					wait <- 20;
					targetpoint <- {rnd(100),rnd(100)};
				}
				wait <- wait - 1;
			}
		}
		else if hunger <= 0
		{
			if informed = true
			{
				// Guided from information centre.
				self.NonVegRestaurantPoint <- {95,97.5}; // Memorize
				self.VeganRestaurantPoint <- {5,97.5}; // Memorize
				if iter = 1
				{
					targetpoint <- self.VeganRestaurantPoint;
				}
				else
				{
					targetpoint <- self.NonVegRestaurantPoint;
				}
			}
			else
			{
				write name + "says: Ah.. I'm hungry.";
				if iter = 1
				{
					targetpoint <- self.VeganRestaurantPoint;
				}
				else
				{
					targetpoint <- self.NonVegRestaurantPoint;
				}
			}
			do goto target:targetpoint speed: 3.0;
			if(location = targetpoint)
			{
				if wait <= 0
				{
					write self.name + "says: Feeling Great!... Lets roam again.";
					hunger <- rnd(100);
					informed <- false;
					wait <- 20;
					targetpoint <- {rnd(100),rnd(100)};
				}
				wait <- wait - 1;
			}
		}
		else if wc <= 0
		{
			if informed = true
			{
				// Guided from information centre.
				self.WCPoint <- {50,97.5}; // Memorize
				targetpoint <- self.WCPoint;
			}
			else
			{
				write name + "says: OMG.. I've to pee/poo.";
				targetpoint <- self.WCPoint;
			}
			do goto target:targetpoint speed: 3.0;
			if(location = targetpoint)
			{
				if wait <= 0
				{
					write self.name + "says: Oooohhhh... Lets go.";
					wc <- rnd(100);
					informed <- false;
					wait <- 20;
					targetpoint <- {rnd(100),rnd(100)};
				}
				wait <- wait - 1;
			}
		}
		else
		{
			do goto target:{rnd(100),rnd(100)} speed: 3.0;
		}
	}
	
	aspect default{ 
    	draw cylinder(1,1) at: location color: #yellow lighted: bool(1) ;
    }
}

experiment main type: gui {
	output {
		display map type: opengl
		{
			image '../Icons/Background.jpg' ;
			species InformationCenter;
			species Entrance;
			species Pub;
			species JuiceParlor;
			species VeganRestaurant;
			species NonVegRestaurant;
			species WC;
			//species Guest_Couple;
			//species Guest_Baddy;
			//species Guest_Singles_WoM;
			species Guest_Singles_WM;
			//species Security_Guard;
		}
	}
}

/* Insert your model definition here */

