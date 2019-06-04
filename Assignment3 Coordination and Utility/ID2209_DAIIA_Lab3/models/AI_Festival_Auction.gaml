/***
* Name: AI Festival 2.0
* Author: Mukesh Muralidharan
* Description: Some peaceful agents attending a AI festival with auctioneers.
* Tags: Tag1, Tag2, TagN
***/

model AI_Festival_Auction

global {
	image_file securityguard const: true <- file('../icons/security.png');
	image_file baddy const: true <- file('../icons/badguy.gif');
	
	
	float displacement_WM;
	float displacement_WoM;
	bool securityalert;
	bool movebaddy;
	bool baddyalert;
	point baddypoint;
	
	emotion joy <- new_emotion("joy");
	
	Consumer0 C0;
	Consumer1 C1;
	Consumer2 C2;
	Consumer3 C3;
	Consumer4 C4;
	
	init
	{
		create Entrance number: 1
		{
			location <- {1,50};
		}
		create InformationCentre number: 1
		{
			securityalert <- false;
			baddyalert <- false;
			location <- {50,50};
			JuiceParlorPoint <- {95,2.5};
			PubPoint <- {5,2.5};
			VeganRestaurantPoint <- {5,97.5};
			NonVegRestaurantPoint <- {95,97.5};
			WCPoint <- {50,97.5};
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
		create AuctionCentre number: 1
		{
			location <- {50,20};
		}
		create Merchant number: 1
		{
			startofauction <- true;
			notsold <- true;
			whom <- 0;
			baseprice <- 500.0;
			startprice <- 999.0;
			location <- {45,20};
		}
		create Consumer0 number: 1 returns: c0
		{
			offeredprice <- '';
			startofauction <- true;
			begin <- false;
			buyprice <- 399.0;
			dist <- 1;
			location <- {rnd(48,54),rnd(16,24)};
		}
		create Consumer1 number: 1 returns: c1
		{
			offeredprice <- '';
			startofauction <- true;
			begin <- false;
			buyprice <- 499.0;
			dist <- 1;
			location <- {rnd(48,54),rnd(16,24)};
		}
		create Consumer2 number: 1 returns: c2
		{
			offeredprice <- '';
			startofauction <- true;
			begin <- false;
			buyprice <- 599.0;
			dist <- 1;
			location <- {rnd(48,54),rnd(16,24)};
		}
		create Consumer3 number: 1 returns: c3
		{
			offeredprice <- '';
			startofauction <- true;
			begin <- false;
			buyprice <- 699.0;
			dist <- 1;
			location <- {rnd(48,54),rnd(16,24)};
		}
		create Consumer4 number: 1 returns: c4
		{
			offeredprice <- '';
			startofauction <- true;
			begin <- false;
			buyprice <- 799.0;
			dist <- 1;
			location <- {rnd(48,54),rnd(16,24)};
		}
		
		C0 <- c0 at 0;
		C1 <- c1 at 0;
		C2 <- c2 at 0;
		C3 <- c3 at 0;
		C4 <- c4 at 0;
	}
}

species Entrance{
	rgb myColor <- #white;
	reflex changeColor {
		myColor <- flip(0.5) ? #white : #red;
	}
	aspect default{
    	draw cylinder(1,4) at: location + {0, 7.5, 0} color: #black ;
    	draw cylinder(1,4) at: location + {0, -7.5, 0} color: #black ;
    	draw sphere(2) at: location + {0, 7.5, 3.8} color: myColor ;
    	draw sphere(2) at: location + {0, -7.5, 3.8} color: myColor ;
    }
}
species InformationCentre{
	point JuiceParlorPoint;
	point PubPoint;
	point VeganRestaurantPoint;
	point NonVegRestaurantPoint;
	point WCPoint;
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
    	draw box(10,5,4) at: location color: #blue lighted: bool(1) ;
    }
}
species JuiceParlor{
	aspect default{
    	draw box(10,5,4) at: location color: #yellow lighted: bool(1) ;
    }
}
species VeganRestaurant{
	aspect default{
    	draw box(10,5,4) at: location color: #cyan lighted: bool(1) ;
    }
}
species NonVegRestaurant{
	aspect default{
    	draw box(10,5,4) at: location color: #red lighted: bool(1) ;
    }
}
species WC{
	aspect default{
    	draw box(10,5,4) at: location color: #grey lighted: bool(1) ;
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
		do goto target:{50,50} speed: 3.0;
		
		if securityalert = true
		{
			baddypoint <- self.location;
		}
		if(location = {50,50})
		{
			if thirst <= 0
			{
				ask InformationCentre {
					myself.targetpoint <- PubPoint;
					}
			}
			if hunger <= 0
			{
				ask InformationCentre {
					myself.targetpoint <- NonVegRestaurantPoint;
					}
			}
			if wc <= 0
			{
				ask InformationCentre {
					myself.targetpoint <- WCPoint;
					}
			}
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
		do goto target:{50,50} speed: 3.0;
		
		if(location = {50,50})
		{
			if wait <= 0
			{
				if thirst <= 0
				{
					ask self {
						if (has_emotion(joy))
						{
							ask InformationCentre {
								myself.targetpoint <- JuiceParlorPoint;
								}
						}
						else
						{
							ask InformationCentre {
								myself.targetpoint <- PubPoint;
								}
						}
						}
				}
				else if hunger <= 0
				{
					ask self {
						if (has_emotion(joy))
						{
							ask InformationCentre {
								myself.targetpoint <- VeganRestaurantPoint;
								}
						}
						else
						{
							ask InformationCentre {
								myself.targetpoint <- NonVegRestaurantPoint;
								}
						}
						}
				}
				else
				{
					ask InformationCentre {
								myself.targetpoint <- WCPoint;
								}
				}
				informed <- true;
				wait <- 20;
			}
			wait <- wait - 1;
		}
		else
		{
			displacement_WoM <- displacement_WoM + 1;
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
    	draw cone3D(1.5,2.5) at: location color: #white ;
    	draw sphere(1) at: location + {0, 0, 2} color: #white ;
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
		do goto target:{50,50} speed: 3.0;
		
		if(location = {50,50})
		{
			if wait <= 0
			{
				if thirst <= 0
				{
					if iter = 1
					{
						ask InformationCentre {
							myself.targetpoint <- JuiceParlorPoint;
							}
					}
					else
					{
						ask InformationCentre {
							myself.targetpoint <- PubPoint;
							}
					}
				}
				else if hunger <= 0
				{
					if iter = 1
					{
						ask InformationCentre {
							myself.targetpoint <- NonVegRestaurantPoint;
							}
					}
					else
					{
						ask InformationCentre {
							myself.targetpoint <- VeganRestaurantPoint;
							}
					}
				}
				else if wc <= 0
				{
					ask InformationCentre {
						myself.targetpoint <- WCPoint;
						}
				}
				else
				{
					targetpoint <- {rnd(100),rnd(100)};
				}
				informed <- true;
				wait <- 20;
			}
			wait <- wait - 1;
		}
		else
		{
			displacement_WM <- displacement_WM + 1;
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
    	draw cone3D(1.5,2.5) at: location color: #yellow ;
    	draw sphere(1) at: location + {0, 0, 2} color: #yellow ;
    }
}
species AuctionCentre{
	aspect default{
    	draw square(10) at: location color: #violet lighted: bool(1) ;
    }
}
species Merchant skills: [fipa]{
	float baseprice;
	float startprice;
	int whom;
	bool notsold;
	bool startofauction;
	reflex start_of_auction when: startofauction = true {
		write self.name + ': INFORM';
		do start_conversation with: [ to :: [C0], protocol :: 'fipa-contract-net', performative :: 'inform', contents :: ['Auction is starting now.'] ];
		startofauction <- false;
	}
	reflex call_for_proposals when: notsold = true {
		write self.name + ': CALL FOR PROPOSAL';
		write self.name + ': Selling for the price: '+ startprice + ' Kr.';
		if whom = 0{
			do start_conversation with: [ to :: [C0], protocol :: 'fipa-contract-net', performative :: 'cfp', contents :: ['Selling for the price: '+ startprice + ' Kr.'] ];
			notsold <- false;
		}
		else if whom = 1{
			do start_conversation with: [ to :: [C1], protocol :: 'fipa-contract-net', performative :: 'cfp', contents :: ['Selling for the price: '+ startprice + ' Kr.'] ];
			notsold <- false;
		}
		else if whom = 2{
			do start_conversation with: [ to :: [C2], protocol :: 'fipa-contract-net', performative :: 'cfp', contents :: ['Selling for the price: '+ startprice + ' Kr.'] ];
			notsold <- false;
		}
		else if whom = 3{
			do start_conversation with: [ to :: [C3], protocol :: 'fipa-contract-net', performative :: 'cfp', contents :: ['Selling for the price: '+ startprice + ' Kr.'] ];
			notsold <- false;
		}
		else{
			do start_conversation with: [ to :: [C4], protocol :: 'fipa-contract-net', performative :: 'cfp', contents :: ['Selling for the price: '+ startprice + ' Kr.'] ];
			notsold <- false;
		}
	}
	reflex read_proposal when: !(empty(proposes)) {
		loop p over: proposes {
			write self.name + ': Proposal recieved: ' + string(p.contents);
			if string(p.contents) = '[\'' + string(startprice) + '\']'{
				write self.name + ': Its a deal';
				do accept_proposal with: [message :: p, contents :: ['Its a deal.']];
			}
			else{
				write self.name + ': No deal';
				do reject_proposal with: [message :: p, contents :: ['No deal.']];
				if whom < 4{
					whom <- whom + 1;
				}
				else{
					if startprice >= baseprice{
						startprice <- startprice - 100.0;
						whom <- 0;
						notsold <- true;
					}
					else{
						do end_conversation with: [message :: cfps at 0, contents :: ['Auction cancelled.']];
					}
				}
				notsold <- true;
			}
		}
	}
	aspect default{ 
    	draw cone3D(1.5,2.5) at: location color: #black ;
    	draw sphere(1) at: location + {0, 0, 2} color: #white ;
    }
}
species Consumer0 skills: [fipa, moving]{
	int dist;
	float buyprice;
	string offeredprice;
	bool begin;
	bool startofauction;
	reflex read_inform_message when: !(empty(informs)) and startofauction = true {
		loop i over: informs {
			write self.name + ': Information recieved: ' + string(i.contents);
		}
		startofauction <- false;
	}
	reflex read_cfp_message when: !(empty(cfps)) {
		loop c over: cfps {
			if offeredprice != string(c.contents){
				write self.name + ': Cfp recieved: ' + string(c.contents);
				write self.name + ': I am willing to buy for ' + buyprice + ' Kr.';
				do propose with: [message :: c, contents :: [string(buyprice)]];
				offeredprice <- string(c.contents);
			}
		}
	}
	reflex proposal_accepted when: !(empty(accept_proposals)) {
		loop ap over: accept_proposals {
			write self.name + ': Acceptance recieved: ' + string(ap.contents);
			write self.name + ': OK.';
			do end_conversation with: [message :: ap, contents :: ['OK.']];
		}
	}
	reflex proposal_rejected when: !(empty(reject_proposals)) {
		loop rp over: reject_proposals {
			write self.name + ': Rejection recieved: ' + string(rp.contents);
			write self.name + ': OK.';
			do end_conversation with: [message :: rp, contents :: ['OK.']];
		}
	}
	reflex dance
	{
		dist <- -dist;
		do goto target:location + dist speed: 1.0;
	}
	aspect default{ 
    	draw cone3D(1.5,2.5) at: location color: #white ;
    	draw sphere(1) at: location + {0, 0, 2} color: #black ;
    }
}
species Consumer1 skills: [fipa, moving]{
	int dist;
	float buyprice;
	string offeredprice;
	bool begin;
	bool startofauction;
	reflex read_inform_message when: !(empty(informs)) and startofauction = true {
		loop i over: informs {
			write self.name + ': Information recieved: ' + string(i.contents);
		}
		startofauction <- false;
	}
	reflex read_cfp_message when: !(empty(cfps)) {
		loop c over: cfps {
			if offeredprice != string(c.contents){
				write self.name + ': Cfp recieved: ' + string(c.contents);
				write self.name + ': I am willing to buy for ' + buyprice + ' Kr.';
				do propose with: [message :: c, contents :: [string(buyprice)]];
				offeredprice <- string(c.contents);
			}
		}
	}
	reflex proposal_accepted when: !(empty(accept_proposals)) {
		loop ap over: accept_proposals {
			write self.name + ': Acceptance recieved: ' + string(ap.contents);
			write self.name + ': OK.';
			do end_conversation with: [message :: ap, contents :: ['OK.']];
		}
	}
	reflex proposal_rejected when: !(empty(reject_proposals)) {
		loop rp over: reject_proposals {
			write self.name + ': Rejection recieved: ' + string(rp.contents);
			write self.name + ': OK.';
			do end_conversation with: [message :: rp, contents :: ['OK.']];
		}
	}
	reflex dance
	{
		dist <- -dist;
		do goto target:location + dist speed: 1.0;
	}
	aspect default{ 
    	draw cone3D(1.5,2.5) at: location color: #white ;
    	draw sphere(1) at: location + {0, 0, 2} color: #black ;
    }
}
species Consumer2 skills: [fipa, moving]{
	int dist;
	float buyprice;
	string offeredprice;
	bool begin;
	bool startofauction;
	reflex read_inform_message when: !(empty(informs)) and startofauction = true {
		loop i over: informs {
			write self.name + ': Information recieved: ' + string(i.contents);
		}
		startofauction <- false;
	}
	reflex read_cfp_message when: !(empty(cfps)) {
		loop c over: cfps {
			if offeredprice != string(c.contents){
				write self.name + ': Cfp recieved: ' + string(c.contents);
				write self.name + ': I am willing to buy for ' + buyprice + ' Kr.';
				do propose with: [message :: c, contents :: [string(buyprice)]];
				offeredprice <- string(c.contents);
			}
		}
	}
	reflex proposal_accepted when: !(empty(accept_proposals)) {
		loop ap over: accept_proposals {
			write self.name + ': Acceptance recieved: ' + string(ap.contents);
			write self.name + ': OK.';
			do end_conversation with: [message :: ap, contents :: ['OK.']];
		}
	}
	reflex proposal_rejected when: !(empty(reject_proposals)) {
		loop rp over: reject_proposals {
			write self.name + ': Rejection recieved: ' + string(rp.contents);
			write self.name + ': OK.';
			do end_conversation with: [message :: rp, contents :: ['OK.']];
		}
	}
	reflex dance
	{
		dist <- -dist;
		do goto target:location + dist speed: 1.0;
	}
	aspect default{ 
    	draw cone3D(1.5,2.5) at: location color: #white ;
    	draw sphere(1) at: location + {0, 0, 2} color: #black ;
    }
}
species Consumer3 skills: [fipa, moving]{
	int dist;
	float buyprice;
	string offeredprice;
	bool begin;
	bool startofauction;
	reflex read_inform_message when: !(empty(informs)) and startofauction = true {
		loop i over: informs {
			write self.name + ': Information recieved: ' + string(i.contents);
		}
		startofauction <- false;
	}
	reflex read_cfp_message when: !(empty(cfps)) {
		loop c over: cfps {
			if offeredprice != string(c.contents){
				write self.name + ': Cfp recieved: ' + string(c.contents);
				write self.name + ': I am willing to buy for ' + buyprice + ' Kr.';
				do propose with: [message :: c, contents :: [string(buyprice)]];
				offeredprice <- string(c.contents);
			}
		}
	}
	reflex proposal_accepted when: !(empty(accept_proposals)) {
		loop ap over: accept_proposals {
			write self.name + ': Acceptance recieved: ' + string(ap.contents);
			write self.name + ': OK.';
			do end_conversation with: [message :: ap, contents :: ['OK.']];
		}
	}
	reflex proposal_rejected when: !(empty(reject_proposals)) {
		loop rp over: reject_proposals {
			write self.name + ': Rejection recieved: ' + string(rp.contents);
			write self.name + ': OK.';
			do end_conversation with: [message :: rp, contents :: ['OK.']];
		}
	}
	reflex dance
	{
		dist <- -dist;
		do goto target:location + dist speed: 1.0;
	}
	aspect default{ 
    	draw cone3D(1.5,2.5) at: location color: #white ;
    	draw sphere(1) at: location + {0, 0, 2} color: #black ;
    }
}
species Consumer4 skills: [fipa, moving]{
	int dist;
	float buyprice;
	string offeredprice;
	bool begin;
	bool startofauction;
	reflex read_inform_message when: !(empty(informs)) and startofauction = true {
		loop i over: informs {
			write self.name + ': Information recieved: ' + string(i.contents);
		}
		startofauction <- false;
	}
	reflex read_cfp_message when: !(empty(cfps)) {
		loop c over: cfps {
			if offeredprice != string(c.contents){
				write self.name + ': Cfp recieved: ' + string(c.contents);
				write self.name + ': I am willing to buy for ' + buyprice + ' Kr.';
				do propose with: [message :: c, contents :: [string(buyprice)]];
				offeredprice <- string(c.contents);
			}
		}
	}
	reflex proposal_accepted when: !(empty(accept_proposals)) {
		loop ap over: accept_proposals {
			write self.name + ': Acceptance recieved: ' + string(ap.contents);
			write self.name + ': OK.';
			do end_conversation with: [message :: ap, contents :: ['OK.']];
		}
	}
	reflex proposal_rejected when: !(empty(reject_proposals)) {
		loop rp over: reject_proposals {
			write self.name + ': Rejection recieved: ' + string(rp.contents);
			write self.name + ': OK.';
			do end_conversation with: [message :: rp, contents :: ['OK.']];
		}
	}
	reflex dance
	{
		dist <- -dist;
		do goto target:location + dist speed: 1.0;
	}
	aspect default{ 
    	draw cone3D(1.5,2.5) at: location color: #white ;
    	draw sphere(1) at: location + {0, 0, 2} color: #black ;
    }
}

experiment main type: gui {
	output {
		display map type: opengl
		{
			image '../Icons/Background.jpg' ;
			species InformationCentre;
			species Entrance;
			species Pub;
			species JuiceParlor;
			species VeganRestaurant;
			species NonVegRestaurant;
			species WC;
			species Guest_Baddy;
			species Guest_Singles_WoM;
			species Guest_Singles_WM;
			species Security_Guard;
			species Merchant;
			species AuctionCentre;
			species Consumer0;
			species Consumer1;
			species Consumer2;
			species Consumer3;
			species Consumer4;
		}
		display chart
		{
			chart "Agent displacements"
			{
				//data "Agents with memory" value: displacement_WM color: #green;
				//data "Agents without memory" value: displacement_WoM color: #red;
			}
		}
	}
}