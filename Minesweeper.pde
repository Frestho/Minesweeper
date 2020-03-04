import de.bezier.guido.*;
public final static int NUM_ROWS = 15;
public final static int NUM_COLS = 15;
private MSButton[][] buttons = new MSButton[NUM_ROWS][NUM_COLS]; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined
boolean winning = false;
void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    //too lazy to initialize size here so i did it at the beginning
    for(int i = 0; i < NUM_ROWS; i++) {
        for(int j = 0; j < NUM_COLS; j++) {
            buttons[i][j] = new MSButton(i, j);
        }
    }
    
    for(int i = 0; i < 30; i++) {
        setMines();
    }
}
public void setMines()
{
    while(true) {
        //your code
        int r = (int)(Math.random()*NUM_ROWS);
        int c = (int)(Math.random()*NUM_COLS);
        if(!mines.contains(buttons[r][c])) {
            mines.add(buttons[r][c]);
            return;
        }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
    if(winning) {

    background(69);
    text("YOU WON", 69, 69);
    }
}
public boolean isWon()
{
    //your code here
    for(int i = 0; i < NUM_ROWS; i++) {
        for(int j = 0; j < NUM_COLS; j++) {
            if(!buttons[i][j].clicked && !mines.contains(buttons[i][j])) {
                return false;
            }
        }
    }
    return true;
}
public void displayLosingMessage()
{
    //your code here
    for(int i = 0; i < mines.size(); i++) {
        mines.get(i).mousePressed();
    }
}
public void displayWinningMessage()
{
    //your code here
    for(int i = NUM_ROWS/2-4; i < NUM_ROWS/2+4; i++){
        for(int j = NUM_COLS/2-4; j < NUM_COLS/2+4; j++){
            String message = "You win!";
            buttons[i][j].setLabel(message.charAt(j-NUM_COLS/2+4) + "");
            buttons[i][j].draw();
        }
    }
    winning = true;
}
public boolean isValid(int r, int c)
{
    //your code here
    return r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    //your code here
    for(int i = -1; i < 2; i++) {
        for(int j = -1; j < 2; j++) {
            if(i == 0 && j == 0) continue;
            if(isValid(row+i, col+j) && mines.contains(buttons[row+i][col+j])) {
                numMines++;
            }
        }
    }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        //your code here
        if(mouseButton == RIGHT) {flagged = !flagged; if(flagged) clicked = false;}

        else if (mines.contains(this)) displayLosingMessage();
        else if (countMines(myRow, myCol) > 0) {clicked = true;
            myLabel = "" + countMines(myRow,myCol);}
        else {
            for(int i = -1; i < 2; i++) {
                for(int j = -1; j < 2; j++) {
                    if((i != 0 || j != 0) && isValid(myRow+i, myCol+j) && !buttons[myRow+i][myCol+j].clicked) {
                        buttons[myRow+i][myCol+j].mousePressed();
                    }
                }
            }
        }
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
         else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
