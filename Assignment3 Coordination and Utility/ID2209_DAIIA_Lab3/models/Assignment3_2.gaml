/**
* Name: Assignment3Task2
* Author:Rui
* Description: 
* Tags: Tag1, Tag2, TagN
*/

model Assignment3Task2

global 
{
	list<point> stagelocation;
	list<string> namelocation;
	int NumberofGuests <- rnd(20,80);
	init
	{
		create Entrance number: 1
		{
			location <- {1,50};
		}
		create Stage number: 1
		{
			location <- {20, 50};
			add location to: stagelocation;	
			add name to: namelocation;	
		}
		create Stage number: 1
		{
			location <- {50,20};
			add location to: stagelocation;	
			add name to: namelocation;	
		}
		create Stage number: 1
		{
			location <- {50, 80};
			add location to: stagelocation;	
			add name to: namelocation;	
		}
		create Stage number: 1
		{
			location <- {80, 50};
			add location to: stagelocation;	
			add name to: namelocation;	
		}
		create Guest number: NumberofGuests
		{
			location <- {10 + rnd(80), 10 + rnd(80)};	
		}
		create Leader number:1
		{
			location <- {1,50};
		}
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

species Leader skills:[fipa]{

	float sumutlities <- 0.0;
	float sumnewutlities <- 0.0;
	list<int> goals <- [];
	
	reflex intendedgoals when: (!empty(informs))
	{
		
		list intendedgoals <- informs;
		
		if length(intendedgoals) = length(Guest)
		{
			
			list Guestsperstage <-[];
			list Crowdedlevel <-[];
			
			loop a over: intendedgoals
				{
				sumnewutlities <- sumnewutlities + float(a.contents[2]);									
				}
			
			if sumnewutlities > sumutlities
			{
				
				sumutlities <- sumnewutlities;
				sumnewutlities <- 0.0;
				goals <- [];
				
				loop a over: intendedgoals
				{
				add int(a.contents[0]) to: goals;									
				}
				
				
				loop a from: 0 to: (length(Stage)-1)
				{
					add 0 to: Guestsperstage;	
					add 0 to: Crowdedlevel;	
				}

				loop a over: intendedgoals
					{
					int b <- Guestsperstage[a.contents[0]];
					Guestsperstage[a.contents[0]] <- b + 1;
					}
					loop a from: 0 to: length(Guestsperstage) - 1
					{
						if string(Guestsperstage[a])as_int 10  >= NumberofGuests / 5
						{
							Crowdedlevel[a] <- 1;
						}
					}			
				do start_conversation with: [ to::list(Guest), protocol:: 'no-protocol', performative :: 'inform', contents::[Crowdedlevel]];
					
			}else{
				
				write 'the utility is not better. move to the goal from the last solution!';
				write goals;
				
				
				do start_conversation with: [ to::list(Guest), protocol:: 'no-protocol', performative :: 'request', contents::goals];
				sumutlities <- 0.0;
				sumnewutlities <- 0.0;
				goals <- [];
			}	
						
		}
			
	}

	aspect default
	{
		draw cone3D(1.3,2.3) at: location color: #white ;
    	draw sphere(0.7) at: location + {0, 0, 2} color: #white ; 
	}	
}

species Guest skills: [fipa, moving] {
	point PreferredStage;
	float TheatricsPreference <- rnd(10)/10;
	float actPreference <- rnd(10)/10;
	float LightPreference <- rnd(10)/10;
	float OppositeAttractPreference <- rnd(10)/10;
	float SoundPreference <- rnd(10)/10;
	float PopularityPreference <- rnd(10)/10;
	float CrowdPreference <- rnd(10)/10;
	list<float> utilities;
	bool startconversation <- true; 

	
	reflex getparameters when: (!empty(cfps))
	{
		list<string> names <-[];
		list<float> Theatrics <-[];
		list<float> acts <- [];
		list<float> Lights <- [];
		list<float> OppositeAttracts <- [];
		list<float> Sounds <- [];
		list<float> Popularitys <- [];
		utilities <- []; 
		list getparameters <- cfps;
		point PreferredStage <- nil;
		
		
	
		if length(getparameters) = length(stagelocation)
			{
					
			loop a over: getparameters
			{			
			add (string(a.contents[0])) to: names;
			add (float(a.contents[1])) to: Theatrics;			
			add (float(a.contents[2])) to: acts;
			add (float(a.contents[3])) to: Lights;
			add (float(a.contents[4])) to: OppositeAttracts;
			add (float(a.contents[5])) to: Sounds;
			add (float(a.contents[6])) to: Popularitys;
			}
			
			loop i from: 0 to: (length(getparameters) - 1)
			{
				float utilitynew <- actPreference * acts[i] + TheatricsPreference * Theatrics[i] + LightPreference * Lights[i] + OppositeAttractPreference * OppositeAttracts[i] + SoundPreference * Sounds[i] + PopularityPreference * Popularitys[i] ; 
				add utilitynew to: utilities;
				
			}
		
			int goal <- utilities index_of (max(utilities));
			float maxutility <- utilities[goal];
			do start_conversation with: [ to :: list(Leader), protocol :: 'no-protocol', performative :: 'inform', contents :: [goal, self.name, maxutility]];	
						
			loop a over: getparameters
			{
				do end_conversation with:[message:: a, contents::['The faborable places of all guests in a list']];	
			}
				

			
			}
		}
	
	reflex askforparameters when: startconversation = true
	{
	do start_conversation with: [ to :: list(Stage), protocol :: 'no-protocol', performative :: 'cfp', contents :: ['getparameters'] ];	
	startconversation <- false;
	}
	
	reflex calculatenewutility when: (!empty(informs))
	{
		list Crowdlevel <- informs[0].contents[0];
		
		if CrowdPreference < 0.5
		{
			loop a from: 0 to: (length(Crowdlevel) -1)
			{
				if string(Crowdlevel[a])as_int 10 = 1
				{
					Crowdlevel[a] <- 0;
				}else{
					Crowdlevel[a] <- 1;
				}
			}			
		}
		list newutilities <-[ ];
		loop a from: 0 to: length(utilities) - 1
		{
			if CrowdPreference < 0.5
			{
			add (float(utilities[a]) + float(Crowdlevel[a]) * (1- CrowdPreference - 0.5)) to: newutilities;	
			}else
			{
			add (float(utilities[a]) + float(Crowdlevel[a]) * (CrowdPreference - 0.5)) to: newutilities;	
			}
			
		}
		
		int goal <- newutilities index_of (max(newutilities));
		float maxutility <- newutilities[goal]; 
		do start_conversation with: [ to :: list(Leader), protocol :: 'no-protocol', performative :: 'inform', contents :: [goal, self.name, maxutility]];	
		
	}
	
	reflex getPreferredStage when: (!empty(requests))
	{		
		write 'The faborable places of all guests in a list';
		list goals <- requests[0].contents;
		write goals;
		int a <- index_of(Guest, self);
		write name +' will move to '+ namelocation[goals [a]] + ' based on the utilitiy.' ;
		PreferredStage <- stagelocation[goals [a]];
		
			
	}
	

	
	reflex gototarget when: PreferredStage != nil
	{		
		
		if (location distance_to PreferredStage) < 10.0
		{
			do wander;
		}
		else
		{
			do goto target: PreferredStage speed: 5.0;	
		}
	}	

	aspect default
	{
		draw cone3D(1.3,2.3) at: location color: #black ;
    	draw sphere(0.7) at: location + {0, 0, 2} color: #black ;
	}
}
species Stage skills: [fipa, moving] {
	rgb myColor <- #blue;
	bool begin <- true;
	float newact <- 30.0;
	float act <- rnd(10)/10;
	float theatrics <- rnd(10)/10;
	float Light <- rnd(10)/10;
	float OppositeAttract <- rnd(10)/10;
	float Sound <- rnd(10)/10;
	float Popularity <- rnd(10)/10;
	
	reflex hostnewact when: time = newact 
	{
		theatrics <- 1/(1 + rnd(9));
		act <- 1 / (1 + rnd(9));
		Light <- 1/(1 + rnd(9));
		OppositeAttract <- 1/(1 + rnd(9));
		Sound <- 1/(1 + rnd(9));
		Popularity <- 1/(1 + rnd(9));	
		
		do start_conversation with: [ to::list(Guest), protocol:: 'no-protocol', performative :: 'cfp', contents::[self.name, theatrics, act, Light, OppositeAttract, Sound, Popularity]];
		
		newact <- time + 30.0;
	} 

	reflex sendparameters when: (!empty(cfps)) 
		{
		loop a over: cfps
		{
		if a.contents = ['getparameters']
			{
			do cfp with:[message:: a, contents::[self.name, theatrics, act, Light, OppositeAttract, Sound, Popularity]];	
							
			}	
		}			
		}

	
	aspect default
	{
		draw cube (5) at: location color: myColor; 
	}
}
experiment main type: gui {
	output {
		display map type: opengl 
		{
			image '../Icons/Background.jpg' ;
			species Guest;
			species Stage;
			species Leader;
			species Entrance;
		}
	}
}