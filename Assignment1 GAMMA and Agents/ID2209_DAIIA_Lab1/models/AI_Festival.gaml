/***
* Name: AI Festival
* Author: Mukesh Muralidharan
* Description: Some peaceful agents attending a AI festival.
* Tags: Tag1, Tag2, TagN
***/

model AI_Festival

global {
	image_file securityguard const: true <- file('../icons/security.png');
	image_file baddy const: true <- file('../icons/badguy.png');
	
	float displacement_WM;
	float displacement_WoM;
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
		create Disco number: 1
		{
			location <- {55,20};
		}
		create RandomShop number: 3
		{
			location <- {rnd(10,90),rnd(60,90)};
		}
		create RandomStore number: 2
		{
			location <- {rnd(10,50),rnd(10,40)};
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
		create Guest_Couple number: 2
		{
			location <- {rnd(100),rnd(100)};
			dist <- 1;
			informed <- false;
			thirst <- 33;
			hunger <- 77;
			wc <- 100;
			wait <- 20;
			couplemet <- false;
			targetpoint <- {rnd(100),rnd(100)};
		}
		create Guest_Baddy number: 1
		{
			location <- {rnd(100),rnd(100)};
			informed <- false;
			thirst <- rnd(100);
			hunger <- rnd(100);
			wc <- rnd(100);
			wait <- 20;
			targetpoint <- {rnd(100),rnd(100)};
			baddypoint <- targetpoint;
		}
		create Guest_Singles_WoM number: 5
		{
			location <- {rnd(100),rnd(100)};
			informed <- false;
			thirst <- rnd(100);
			hunger <- rnd(100);
			wc <- rnd(100);
			emothreshold <- rnd(100);
			wait <- 20;
			displacement_WoM <- 0.0;
			targetpoint <- {rnd(100),rnd(100)};
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
			displacement_WM <- 0.0;
			targetpoint <- {rnd(100),rnd(100)};
			JuiceParlorPoint <- {0,0};
			PubPoint <- {0,0};
			VeganRestaurantPoint <- {0,0};
			NonVegRestaurantPoint <- {0,0};
			WCPoint <- {0,0};
		}
		create Security_Guard number: 1
		{
			targetpoint <- {rnd(100),rnd(100)};
			foundbaddy <- false;
			location <- {4,55};
			movebaddy <- false;
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
species Disco{
	rgb myColor <- #violet;
	reflex changeColor {
		myColor <- flip(0.5) ? #violet : #red;
	}
	aspect default{
    	draw sphere(5) at: location color: myColor lighted: bool(1) ;
    }
}
species RandomShop{
	aspect default{
    	draw pyramid(5) at: location color: #blue lighted: bool(1) ;
    }
}
species RandomStore{
	aspect default{
    	draw box(5,5,2) at: location color: #yellow lighted: bool(1) ;
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
species Security_Guard skills: [moving]{
	bool foundbaddy;
	point targetpoint;
	reflex chase when: securityalert = true and foundbaddy = false
	{
		do goto target:targetpoint speed: 10.0;
		if(location distance_to(targetpoint) < 3)
		{
			targetpoint <- {rnd(100),rnd(100)};
			
		}
		if(location distance_to(baddypoint) < 10)
		{
			write self.name + "says: Found baddy.";
			movebaddy <- true;
			foundbaddy <- true;
		}
	}
	reflex escortout when: foundbaddy = true
	{
		do goto target:{4,55} speed: 10.0;
	}
	aspect default{
    	//draw cylinder(2,2) at: location color: #black lighted: bool(1) ;
    	draw securityguard size: {5, 7.4} at: location;
    }
}
species Guest_Couple skills: [moving]{
	int thirst;
	int hunger;
	int wc;
	int dist;
	int wait;
	bool informed;
	bool couplemet;
	point targetpoint;
	
	reflex meet when: couplemet = false
	{
		do goto target:targetpoint speed: 5.0;
		if(location distance_to(targetpoint) < 3)
		{
			targetpoint <- {rnd(100),rnd(100)};
		}
		ask Guest_Couple at_distance 5
		{
			write self.name + "says: Hello! Nice to meet you!";
			write myself.name + "says: Hello! Nice to meet you too!";
			self.couplemet <- true;
			myself.couplemet <- true;
		}
	}
	
	reflex dance when: thirst != 0 and hunger != 0 and wc != 0 and couplemet = true
	{
		dist <- -dist;
		thirst <- thirst - 1;
		hunger <- hunger - 1;
		wc <- wc-1;
		do goto target:location+dist speed: 1.0;
	}
	
	reflex gotoInformationCentre when: (thirst <= 0 or hunger <= 0 or wc <= 0) and informed = false 
	{
		if thirst <= 0
		{
			write self.name + "says: Ah.. I'm thirsty.";
			targetpoint <- {95,2.5};
		}
		if hunger <= 0
		{
			write self.name + "says: Ah.. I'm hungry.";
			targetpoint <- {95,97.5};
		}
		if wc <= 0
		{
			write self.name + "says: OMG.. I've to pee/poo.";
			targetpoint <- {50,97.5};
		}
		do goto target:{50,50} speed: 3.0;
		if(location = {50,50})
		{
			write self.name + "says: We're informed";
			informed <- true;
		}
	}
	
	reflex fromInformationCentre when: informed = true
	{
		if thirst <= 0
		{
			do goto target:targetpoint speed: 3.0;
			if(location = targetpoint)
			{
				if wait <= 0
				{
					targetpoint <- {45,18};
					if location = {45,18}
					{
						write self.name + "says: Oooohhhh... Lets dance again.";
						thirst <- 33;
						informed <- false;
						wait <- 20;
					}
				}
				wait <- wait - 1;
			}
		}
		if hunger <= 0
		{
			do goto target:targetpoint speed: 3.0;
			if(location = targetpoint)
			{
				if wait <= 0
				{
					targetpoint <- {65,18};
					if location = {65,18}
					{
						write self.name + "says: Oooohhhh... Lets dance again.";
						hunger <- 77;
						informed <- false;
						wait <- 20;
					}
				}
				wait <- wait - 1;
			}
		}
		if wc <= 0
		{
			do goto target:targetpoint speed: 3.0;
			if(location = targetpoint)
			{
				if wait <= 0
				{
					targetpoint <- {55,25};
					if location = {55,25}
					{
						write self.name + "says: Oooohhhh... Lets dance again.";
						wc <- 100;
						informed <- false;
						wait <- 20;
					}
				}
				wait <- wait - 1;
			}
		}
		if (thirst > 0 and hunger > 0 and wc > 0)
		{
			do goto target:{rnd(100),rnd(100)} speed: 3.0;
		}
	}
	
	aspect default{
    	draw cylinder(1,1) at: location color: #red lighted: bool(1) ;
    }
}
species Guest_Baddy skills: [moving]{
	int thirst;
	int hunger;
	int wc;
	int dist;
	int wait;
	bool informed;
	point targetpoint;
	
	reflex movearound when: thirst != 0 and hunger != 0 and wc != 0
	{
		thirst <- thirst - 1;
		hunger <- hunger - 1;
		wc <- wc-1;
		do wander speed: 5.0;
		if securityalert = true
		{
			baddypoint <- self.location;
		}
	}
	
	reflex gotcaught when: movebaddy = true
	{
		do goto target:{0,50} speed: 12.0;
		if(location distance_to({0,50}) < 1)
		{
			do die;
		}
	}
	
	reflex gotoInformationCentre when: (thirst <= 0 or hunger <= 0 or wc <= 0) and informed = false
	{
		if thirst <= 0
		{
			write self.name + "says: Ah.. I'm thirsty.";
			targetpoint <- {95,2.5};
		}
		if hunger <= 0
		{
			write self.name + "says: Ah.. I'm hungry.";
			targetpoint <- {95,97.5};
		}
		if wc <= 0
		{
			write self.name + "says: OMG.. I've to pee/poo.";
			targetpoint <- {50,97.5};
		}
		do goto target:{50,50} speed: 3.0;
		if securityalert = true
		{
			baddypoint <- self.location;
		}
		if(location = {50,50})
		{
			write self.name + "says: We're informed";
			baddyalert <- true;
			informed <- true;
		}
	}
	
	reflex fromInformationCentre when: informed = true
	{
		if thirst <= 0
		{
			do goto target:targetpoint speed: 3.0;
			if securityalert = true
			{
				baddypoint <- self.location;
			}
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
			do goto target:targetpoint speed: 3.0;
			if securityalert = true
			{
				baddypoint <- self.location;
			}
			if(location = targetpoint)
			{
				if wait <= 0
				{
					//emothreshold <- rnd(100);
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
			do goto target:targetpoint speed: 3.0;
			if securityalert = true
			{
				baddypoint <- self.location;
			}
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
			if securityalert = true
			{
				baddypoint <- self.location;
			}
		}
	}
	
	aspect default{
    	//draw cylinder(1,1) at: location color: #black lighted: bool(1) ;
    	draw baddy size: {7, 7} at: location;
    }
}
species Guest_Singles_WoM skills: [moving] control:simple_bdi{
	int thirst;
	int hunger;
	int wc;
	int emothreshold;
	int wait;
	bool informed;
	point targetpoint;
	
	bool use_social_architecture <- true;
	bool use_emotions_architecture <- true;
	bool use_personality <- true;
	
	//possible predicates concerning Singles
	predicate enjoyment <- new_predicate("enjoyment") ;
	
	init
	{
		do add_desire(enjoyment);
	}
	
	reflex roamaround when: (thirst > 0 and hunger > 0 and wc > 0)
	{
		do goto target:targetpoint speed: 3.0;
		displacement_WoM <- displacement_WoM + 1;
		if(location distance_to(targetpoint) < 3)
		{
			targetpoint <- {rnd(100),rnd(100)};
		}
		emothreshold <- emothreshold - 1;
		if emothreshold <= 0
		{
			do add_belief(enjoyment);
		}
		else
		{
			do remove_belief(enjoyment);
		}
		thirst <- thirst - 1;
		hunger <- hunger -1;
		wc <- wc - 1;
	}
	
	reflex gotoInformationCentre when: (thirst <= 0 or hunger <= 0 or wc <= 0) and informed = false 
	{
		if thirst <= 0
		{
			write name + "says: Ah.. I'm thirsty.";
			ask self {
				if (has_emotion(joy))
				{
					targetpoint <- {95,2.5};
				}
				else
				{
					targetpoint <- {5,2.5};
				}
				}
		}
		else if hunger <= 0
		{
			write name + "says: Ah.. I'm hungry.";
			ask self {
				if (has_emotion(joy))
				{
					targetpoint <- {5,97.5};
				}
				else
				{
					targetpoint <- {95,97.5};
				}
				}
		}
		else
		{
			write name + "says: OMG.. I've to pee/poo.";
			targetpoint <- {50,97.5};
		}
		do goto target:{50,50} speed: 3.0;
		if(location != {50,50})
		{
			displacement_WoM <- displacement_WoM + 1;
		}
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
	
	reflex fromInformationCentre when: informed = true
	{
		if thirst <= 0
		{
			do goto target:targetpoint speed: 3.0;
			if(location != targetpoint)
			{
				displacement_WoM <- displacement_WoM + 1;
			}
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
			do goto target:targetpoint speed: 3.0;
			if(location != targetpoint)
			{
				displacement_WoM <- displacement_WoM + 1;
			}
			if(location = targetpoint)
			{
				if wait <= 0
				{
					//emothreshold <- rnd(100);
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
			do goto target:targetpoint speed: 3.0;
			if(location != targetpoint)
			{
				displacement_WoM <- displacement_WoM + 1;
			}
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
			displacement_WoM <- displacement_WoM + 1;
		}
	}
	
	aspect default{
    	draw cylinder(1,1) at: location color: #white lighted: bool(1) ;
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
		displacement_WM <- displacement_WM + 1;
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
		if(location != {50,50})
		{
			displacement_WM <- displacement_WM + 1;
		}
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
			if(location != targetpoint)
			{
				displacement_WM <- displacement_WM + 1;
			}
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
			if(location != targetpoint)
			{
				displacement_WM <- displacement_WM + 1;
			}
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
			if(location != targetpoint)
			{
				displacement_WM <- displacement_WM + 1;
			}
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
			displacement_WM <- displacement_WM + 1;
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
			species Disco;
			species RandomShop;
			species RandomStore;
			species Pub;
			species JuiceParlor;
			species VeganRestaurant;
			species NonVegRestaurant;
			species WC;
			species Guest_Couple;
			species Guest_Baddy;
			species Guest_Singles_WoM;
			species Guest_Singles_WM;
			species Security_Guard;
		}
		display chart
		{
			chart "Agent displacements"
			{
				data "Agents with memory" value: displacement_WM color: #green;
				data "Agents without memory" value: displacement_WoM color: #red;
			}
		}
	}
}