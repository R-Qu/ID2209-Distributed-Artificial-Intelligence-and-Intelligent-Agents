/***
* Name: Assignment3Task1
* Author: Rui
* Description:
* Tags: Tag1, Tag2, TagN
***/

model Assignment3Task1

/* Insert your model definition here */

global{

    int N <- rnd(4,20); 
    init
    {
        create Queen number: N
        {
           location <- ChessBoard[rnd(0,N),0].location;
        }
        
    }
    list<Queen> queens;
    list<ChessBoard> ChessBoards;
    
}

grid ChessBoard skills:[fipa] width:N height:N neighbors:N {

	rgb color <- bool(((grid_x + grid_y) mod 2)) ? #grey : #white;
	bool busy <- false;
	init{
		add self to: ChessBoards;
   }
 
}

species Queen skills:[fipa]
{
    int queenIndex;
    int currentRow <- 0;
    ChessBoard selectedCell <-  nil;
    bool noPositionAvailable <- false;
    bool positionFound <- false;
    bool findPosition <- false;
    
    init{
        add self to: queens;
        queenIndex <- int(queens[length(queens) -1]);
        if(length(queens) = N ){
            do start_conversation with:(to: list(queens[0]), protocol: 'fipa-inform', performative: 'inform', contents: ['NextQueen']);        
            write "Start finding position!";
        }
        
    }
    
    aspect default
    {
       	draw cone3D(1.3,2.3) at: location color: #black ;
    	draw sphere(0.7) at: location + {0, 0, 2} color: #black ;
    }
     
     reflex informPredecessorOfPosition when: noPositionAvailable{
        do start_conversation with:(to: list(queens[queenIndex -1]), protocol: 'fipa-inform', performative: 'inform', contents: ['NoPosition']);
        write name + ": Position not found, back to " + queens[queenIndex -1];
        noPositionAvailable <- false;
     }
     
     reflex informNextQueen when: positionFound{
         if(queenIndex != N -1){
             write name + ": Position found";
             do start_conversation with:(to: list(queens[queenIndex +1]), protocol: 'fipa-inform', performative: 'inform', contents: ['NextQueen']);
            
            noPositionAvailable <- false;
         }else{
             write "All positions found!";
         }
         positionFound <- false;
        
     }
     
     
     reflex listen_inform when: (!empty(informs)){
         
        message msgFromQueen <- (informs at 0);
        
        if(msgFromQueen.contents[0] = 'NextQueen')
        {
            findPosition <- true;
            write name + ": Find a new position";
        }else if(msgFromQueen.contents[0] = 'NoPosition'){
        	currentRow <- (currentRow +1) mod N;
        	
        	positionFound <- false;
        	selectedCell.busy <- false;
        	selectedCell <- nil;
              	
        	if(currentRow = 0){
        		noPositionAvailable <- true;
        	}else{
        		findPosition <- true;
        		
        	}
        	
            
        }
        informs <- nil;
     }
     int getListIndex(int curIndex, int curRow){
     	return (N * curRow) + curIndex;
     }
     
     reflex findPosition when: findPosition{
           
        loop i from: currentRow to: N-1
        {   
        	
        	if(checkRow (i) = false and checkUpDiagonal (i,queenIndex) = false and checkDownDiagonal (i,queenIndex) = false){
        		if(selectedCell != nil){
        			selectedCell.busy <- false;
        		}
        		currentRow <- i;
        		selectedCell <- ChessBoards[getListIndex(queenIndex, currentRow)];
        		
        		location <- selectedCell.location;
        		selectedCell.busy <- true;
        		ChessBoards[getListIndex(queenIndex, currentRow)] <- selectedCell;
        		findPosition <- false;
        		positionFound <- true;
        		break;
        	}
        	
        	if(i = (N-1) and !positionFound){
        		noPositionAvailable <- true;
        		currentRow <- 0;
        		findPosition <- false;
        		positionFound <- false;
        		break;
        	}
        } 
        
     }
     
     bool checkRow (int curRow){
     	int currentCol <- queenIndex -1;
     	if(currentCol >= 0){	
     		loop while: currentCol >= 0{
     			
        		ChessBoard tempCell <- ChessBoards[getListIndex(currentCol,curRow)];
        		if(tempCell.busy = true){
        			return true;
        		}
        		currentCol <- currentCol -1;
       		} 
     	}
     	
        return false;
     }

     bool checkUpDiagonal (int curRow, int curIndex){
     	
     	int currentX <- curIndex;
     	int currentY <- curRow;
     	
     	currentY <- currentY -1;
     	currentX <- currentX -1;
     	
     	loop while: (currentY >= 0 and currentX >= 0){
			ChessBoard tempCell <- ChessBoards[getListIndex(currentX, currentY)];
     		if(tempCell.busy = true){
        		return true;
        	}
        	currentY <- currentY -1;
     		currentX <- currentX -1;
     	}
     	
     	return false;
     }
     
     bool checkDownDiagonal (int curRow, int curIndex){
     	
     	int currentX <- curIndex;
     	int currentY <- curRow;
     	
     	currentY <- currentY +1;
     	currentX <- currentX -1;
     	
     	loop while: (currentY < N and currentY >= 0 and currentX >= 0){
			ChessBoard tempCell <- ChessBoards[getListIndex(currentX, currentY)];
     		if(tempCell.busy = true){
        		return true;
        	}
        	currentY <- currentY -1;
     		currentX <- currentX -1;
     	}
     	
     	return false;
     }
     
    
}

experiment main type: gui
{
   
    output
    {
        display map type: opengl
        {
            grid ChessBoard lines: #black ;
            species Queen;
        }
    }
}