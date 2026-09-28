# Property of Four Js*
# (c) Copyright Four Js 1995, 2012. All Rights Reserved.
# * Trademark of Four Js Development Tools Europe Ltd
#   in the United States and elsewhere
#
# Four Js and its suppliers do not warrant or guarantee that these
# samples are accurate and suitable for your purposes. Their inclusion is
# purely for information purposes only.

# Using DrawGetClickedItemId() to identify what canvas item was clicked

IMPORT FGL fgldraw

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE Formula DYNAMIC ARRAY OF RECORD
            id             INT,    
            mark           STRING, 
            context        STRING, 
            lineNumber     INT,    
            length         INT,
            beginX,beginY  INT,    
            endX,endY      INT,     
            type           INT
        END RECORD

DEFINE myCursor RECORD
    CursorHeight INT,
    CursorWidth  INT,
    CursorPosX   INT,
    CursorPosY   INT,
    Pos          INT, # In which position of the Formula is the Cursor at 
    Ln           INT  # In which line 
END RECORD

#DISPLAY WINDOW
DEFINE DW RECORD
    offsetX INT,
    offsetY INT,
    width   INT,
    height  INT
END RECORD

#parameters for keys
DEFINE params DYNAMIC ARRAY OF RECORD
    shortcuts STRING,
    ct        STRING,
    wc        INT
END RECORD

DEFINE g_display     DYNAMIC ARRAY OF RECORD
          name    STRING,
          type       STRING
END RECORD

DEFINE  g_para       DYNAMIC ARRAY OF RECORD
          hrdh12     LIKE    hrdh_file.hrdh12,
          hrdh06     LIKE    hrdh_file.hrdh06,
          length     INT
                     END RECORD

DEFINE tipString String

DEFINE mywin ui.Window   
DEFINE myform ui.Form
DEFINE LineSpace , WordWidth , g_id , startX, startY, offsetX, offsetY INTEGER

DEFINE g_argv1   LIKE   hrdk_file.hrdk01     #传递参数----add by zhangbo for test

MAIN
  
  DEFINE l_i,l_j,l_k      INT                  #add by zhangbo for test
  DEFINE l_str1,l_str2    STRING               #add by zhangbo for test
  DEFINE l_hrdk14     LIKE  hrdk_file.hrdk14   #add by zhangbo for test
  DEFINE l_hrdk15     LIKE  hrdk_file.hrdk15   #add by zhangbo for test
  DEFINE l_hrdk17     LIKE  hrdk_file.hrdk17   #add by zhangbo for test
  DEFINE l_para       DYNAMIC ARRAY OF RECORD  #add by zhangbo for test
           para       LIKE  hrdh_file.hrdh12   #add by zhangbo for test
                      END RECORD               #add by zhangbo for test
  DEFINE cid   INTEGER


  ###########################
  OPTIONS
          INPUT NO WRAP
    DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
  ########################### 

  CALL drawInit()
  OPEN FORM canvas FROM "ghr/42f/p_canvas"
  DISPLAY FORM canvas

  LET g_argv1=ARG_VAL(1)    #接收参数---add by zhangbo for test

  CALL Init()
  #CALL DrawClear()
  #CALL DrawFillColor("black")
  #CALL DrawLineWidth(1)
  #LET cid = drawline(900,100,200,0)

  MENU
    ON ACTION b_IF
      CALL AddWord("IF")
    ON ACTION b_THEN
      CALL AddWord("THEN")
    ON ACTION b_ELSE
      CALL AddWord("ELSE")
    ON ACTION b_END
      CALL AddWord("END IF")
    ON ACTION b_SPACE
      CALL AddWord(" ")
    ON ACTION b_LEFT
      CALL CursorMoveLeft()
    ON ACTION b_RIGHT
      CALL CursorMoveRight()
    ON ACTION b_UP      
      CALL CursorMoveUp()    
    ON ACTION b_DOWN      
      CALL CursorMoveDown()    
    ON ACTION b_WRAP
      CALL CursorWrap()
    ON ACTION b_BACKSPACE
      CALL BACKSPACE()
    ON ACTION b_DEL
      CALL DEL()

    #number
    ON ACTION b_n0
      CALL AddWord("0")
    ON ACTION b_n1
      CALL AddWord("1")
    ON ACTION b_n2
      CALL AddWord("2")
    ON ACTION b_n3
      CALL AddWord("3")
    ON ACTION b_n4
      CALL AddWord("4")
    ON ACTION b_n5
      CALL AddWord("5")
    ON ACTION b_n6
      CALL AddWord("6")
    ON ACTION b_n7
      CALL AddWord("7")
    ON ACTION b_n8
      CALL AddWord("8")
    ON ACTION b_n9
      CALL AddWord("9")

    #operation
    ON ACTION b_plus
      CALL AddWord("+")
    ON ACTION b_minus
      CALL AddWord("-")
    ON ACTION b_multiply
      CALL AddWord("*")
    ON ACTION b_dividedby
      CALL AddWord("/")

    ON ACTION b_equal
      CALL AddWord("=")
    ON ACTION b_equals
      CALL AddWord("==")

    COMMAND KEY (UP)
      CALL CursorMoveUp()
    COMMAND KEY (DOWN)
      CALL CursorMoveDown()
    COMMAND KEY (LEFT)
      CALL CursorMoveLeft()
    COMMAND KEY (RIGHT)
      CALL CursorMoveRight() 

    COMMAND KEY ('0')
      CALL AddWord("0")
    COMMAND KEY ('1')
      CALL AddWord("1")
    COMMAND KEY ('2')
      CALL AddWord("2")
    COMMAND KEY ('3')
      CALL AddWord("3")
    COMMAND KEY ('4')
      CALL AddWord("4")
    COMMAND KEY ('5')
      CALL AddWord("5")
    COMMAND KEY ('6')
      CALL AddWord("6")
    COMMAND KEY ('7')
      CALL AddWord("7")
    COMMAND KEY ('8')
      CALL AddWord("8")
    COMMAND KEY ('9')
      CALL AddWord("9")

    COMMAND KEY ('+')
      CALL AddWord("+")
    COMMAND KEY ('-')
      CALL AddWord("-")
    COMMAND KEY ('*')
      CALL AddWord("*")
    COMMAND KEY ('/')
      CALL AddWord("/")
    COMMAND KEY (';')
      CALL AddWord(";")

    COMMAND KEY ('=')
      CALL AddWord("=")


    COMMAND KEY (RETURN)
      CALL CursorWrap()
    COMMAND KEY (BACKSPACE)
      CALL BACKSPACE()
    COMMAND KEY (DELETE)
      CALL DEL()
    COMMAND KEY (SPACE)
      CALL AddWord(" ")

    COMMAND KEY (A)
      CALL getKey("A")
    COMMAND KEY (B)
      CALL getKey("B")
    COMMAND KEY (C)
      CALL getKey("C")
    COMMAND KEY (D)
      CALL getKey("D")
    COMMAND KEY (E)
      CALL getKey("E")
    COMMAND KEY (F)
      CALL getKey("F")
    COMMAND KEY (G)
      CALL getKey("G")
    COMMAND KEY (H)
      CALL getKey("H")
    COMMAND KEY (I)
      CALL getKey("I")
    COMMAND KEY (J)
      CALL getKey("J")
    COMMAND KEY (K)
      CALL getKey("K")
    COMMAND KEY (L)
      CALL getKey("L")
    COMMAND KEY (M)
      CALL getKey("M")
    COMMAND KEY (N)
      CALL getKey("N")
    COMMAND KEY (O)
      CALL getKey("O")
    COMMAND KEY (P)
      CALL getKey("P")
    COMMAND KEY (Q)
      CALL getKey("Q")
    COMMAND KEY (R)
      CALL getKey("R")
    COMMAND KEY (S)
      CALL getKey("S")
    COMMAND KEY (T)
      CALL getKey("T")
    COMMAND KEY (U)
      CALL getKey("U")
    COMMAND KEY (V)
      CALL getKey("V")
    COMMAND KEY (W)
      CALL getKey("W")
    COMMAND KEY (X)
      CALL getKey("X")
    COMMAND KEY (Y)
      CALL getKey("Y")
    COMMAND KEY (Z)
      CALL getKey("Z")

    COMMAND "quit"
      EXIT MENU

    #add by zhangbo for test
    ON ACTION close
       EXIT MENU
    #add by zhangbo for test

  END MENU
  
  {
  #add by zhangbo for test---begin
  #将数组Formula的元素连接起来
  IF Formula.getLength()>1 THEN
     LET l_hrdk15=NULL
     LET l_hrdk17=NULL
     LET l_str1=NULL
     LET l_str2=NULL
     LET l_j=0
     FOR l_i=1 TO Formula.getLength()-1
         IF Formula[l_i].id=0 THEN
            LET Formula[l_i].context=" \n"
            LET Formula[l_i].mark=" \n"
         END IF
         #LET l_hrdk15=l_hrdk15,Formula[l_i].context
         #LET l_hrdk17=l_hrdk17,Formula[l_i].mark
         LET l_str1=l_str1,Formula[l_i].context
         LET l_str2=l_str2,Formula[l_i].mark
     END FOR

     LET l_hrdk15=l_str1
     LET l_hrdk17=l_str2

     UPDATE hrdk_file SET hrdk14=l_hrdk14,hrdk15=l_hrdk15,hrdk17=l_hrdk17
      WHERE hrdk01=g_argv1
  END IF
  #add by zhangbo for test---end
  }

END MAIN

FUNCTION getWord()
  DEFINE i ,len INT
  DEFINE l_cnt  INT
  DEFINE l_sql STRING

  CALL g_para.clear()
  CALL g_display.clear()

  LET tipString = tipString.toLowerCase()

  #get the parameters
  #need 3 columns , name->hrdh06 , shortcut, para_id->hrdh12
  LET l_sql = " SELECT hrdh12,hrdh06,(LENGTH(hrdh06)+LENGTHB(hrdh06))/2 FROM hrdh_file WHERE hrdh12 LIKE '%",tipString,"%'  ORDER BY hrdh01 "

  PREPARE i078_para_pre FROM l_sql
  DECLARE i078_para CURSOR FOR i078_para_pre

    LET l_cnt=1
    FOREACH i078_para INTO g_para[l_cnt].hrdh12,g_para[l_cnt].hrdh06,g_para[l_cnt].length
       LET g_display[l_cnt].name = g_para[l_cnt].hrdh06
       LET g_display[l_cnt].type    = "param"     
       LET l_cnt=l_cnt+1
    END FOREACH
    
    IF(l_cnt > 1) THEN
      CALL g_para.deleteElement(l_cnt)   
      LET l_cnt=l_cnt-1
    END IF

  #get the includes

END FUNCTION

FUNCTION getKey(key) 
  DEFINE key CHAR 
  DEFINE param_arr DYNAMIC ARRAY OF STRING 

  LET tipString = tipString.append(key)  

  CALL getWord()
 
  DISPLAY ARRAY g_display TO s_para.* ATTRIBUTES(UNBUFFERED) 
    ON KEY (A)
      #refresh the tipString and the display array
      LET tipString = tipString.append("A")
      CALL getWord()
      CONTINUE DISPLAY
    ON KEY (B)
      LET tipString = tipString.append("B")
      CALL getWord()
      CONTINUE DISPLAY
    ON KEY (C)
      LET tipString = tipString.append("C")
      CALL getWord()
      CONTINUE DISPLAY
    ON KEY (D)
      LET tipString = tipString.append("D")
      CALL getWord()
      CONTINUE DISPLAY
    ON KEY (E)
      LET tipString = tipString.append("E")
      CALL getWord()
      CONTINUE DISPLAY
    ON KEY (F) 
      LET tipString = tipString.append("F") 
      CALL getWord()
      CONTINUE DISPLAY
    ON KEY (G)
      LET tipString = tipString.append("G")
      CALL getWord()
      CONTINUE DISPLAY
    ON KEY (H)
      LET tipString = tipString.append("H")
      CALL getWord()
      CONTINUE DISPLAY
    ON KEY (I)
      LET tipString = tipString.append("I")
      CALL getWord()
      CONTINUE DISPLAY
    ON KEY (J)
      LET tipString = tipString.append("J")
      CALL getWord()
      CONTINUE DISPLAY
    ON KEY (K)
      LET tipString = tipString.append("K")
      CALL getWord()
      CONTINUE DISPLAY
    ON KEY (L)
      LET tipString = tipString.append("L")
      CALL getWord()
      CONTINUE DISPLAY
    ON KEY (M)
      LET tipString = tipString.append("M")
      CALL getWord()
      CONTINUE DISPLAY
    ON KEY (N)
      LET tipString = tipString.append("N")
      CALL getWord()
      CONTINUE DISPLAY
    ON KEY (O)
      LET tipString = tipString.append("O")
      CALL getWord()
      CONTINUE DISPLAY
    ON KEY (P)
      LET tipString = tipString.append("P")
      CALL getWord()
      CONTINUE DISPLAY
    ON KEY (Q)
      LET tipString = tipString.append("Q")
      CALL getWord()
      CONTINUE DISPLAY
    ON KEY (R)
      LET tipString = tipString.append("R")
      CALL getWord()
      CONTINUE DISPLAY
    ON KEY (S)
      LET tipString = tipString.append("S")
      CALL getWord()
      CONTINUE DISPLAY
    ON KEY (T)
      LET tipString = tipString.append("T")
      CALL getWord()
      CONTINUE DISPLAY
    ON KEY (U)
      LET tipString = tipString.append("U")
      CALL getWord()
      CONTINUE DISPLAY
    ON KEY (V)
      LET tipString = tipString.append("V")
      CALL getWord()
      CONTINUE DISPLAY 
    ON KEY (W)
      LET tipString = tipString.append("W")
      CALL getWord()
      CONTINUE DISPLAY
    ON KEY (X)
      CALL getWord()
      CONTINUE DISPLAY
    ON KEY (Y)
      CALL getWord()
      CONTINUE DISPLAY
    ON KEY (Z)
      LET tipString = tipString.append("Z")
      CALL getWord()
      CONTINUE DISPLAY
    ON ACTION ACCEPT
      IF(arr_curr() != 0) THEN 
        CALL AddWord2(g_para[arr_curr()].hrdh06,g_para[arr_curr()].hrdh12,g_para[arr_curr()].length)
      END IF
      CALL g_display.clear()
      CALL g_para.clear()
      LET tipString = NULL
      EXIT DISPLAY
    ON ACTION CANCEL
      CALL g_display.clear()
      CALL g_para.clear()
      LET tipString = NULL
      EXIT DISPLAY
  END DISPLAY

END FUNCTION


FUNCTION Init()

  DEFINE i INT

  LET mywin = ui.Window.getCurrent()
  LET myform = mywin.getForm()
  
  CALL drawSelect("editor")
  #CALL drawSetFontSize(5)

  LET LineSpace = 100
  #the width of a character
  #a chinese word may occupy 2 * WordWidth
  LET WordWidth = 15
  LET g_id = 1
  LET startX = 0
  LET startY = 900
  LET offsetX = 0
  LET offsetY = 0

  LET myCursor.CursorHeight = 80
  LET myCursor.CursorWidth = 5
  LET myCursor.CursorPosX = 0
  LET myCursor.CursorPosY = 900
  LET myCursor.Pos = 1
  LET myCursor.Ln = 1

  LET DW.offsetX = 0
  LET DW.offsetY = 0
  LET DW.width   = 900 #save some place for the scroll bar
  LET DW.height  = 900

  LET i = 1
  CALL Formula.insertElement(1)
  LET Formula[i].id = 0
  LET Formula[i].mark = " "
  LET Formula[i].context = " "
  LET Formula[i].lineNumber = 1
  LET Formula[i].beginX = startX + offsetX
  LET Formula[i].beginY = startY + offsetY
  LET Formula[i].endX   = Formula[i].beginX + WordWidth
  LET Formula[i].endY   = Formula[i].beginY - LineSpace
    
  CALL DrawCursor()

END FUNCTION

FUNCTION AddWord2(ct,mk,len)
  DEFINE ct,mk STRING
  DEFINE len , i, t  INT
  DEFINE ln   INT    
  DEFINE b_x,b_y,e_x,e_y INT
  DEFINE width INT

  LET i = myCursor.Pos
  LET ln = Formula[i].lineNumber
  LET b_x = Formula[i].beginX 
  LET b_y = Formula[i].beginY
  LET e_x = b_x + len * WordWidth
  LET e_y = Formula[i].endY
  LET width = e_x - b_x

  CALL Formula.insertElement(i)
  LET Formula[i].id = g_id
  LET g_id = g_id + 1
  LET Formula[i].mark = mk
  LET Formula[i].context = ct
  LET Formula[i].lineNumber = ln
  LET Formula[i].length = len
  LET Formula[i].beginX = b_x
  LET Formula[i].beginY = b_y
  LET Formula[i].endX   = e_x
  LET Formula[i].endY   = e_y

  #IF the text is out of range,move the display window
  IF( e_x > DW.offsetX + DW.width) THEN
    LET DW.offsetX = e_x - DW.width
  END IF

  #Move the words after the inserted in the same line
  FOR t = i + 1 TO Formula.getLength()
    IF(Formula[t].lineNumber != ln) THEN
      EXIT FOR
    ELSE
      LET Formula[t].beginX = Formula[t].beginX + width
      LET Formula[t].endX = Formula[t].endX + width
    END IF
  END FOR

  CALL CursorMoveRight()
  CALL RePaint()

END FUNCTION

FUNCTION AddWord(word)
  DEFINE word STRING 
  DEFINE ct   STRING 
  DEFINE ln   INT    
  DEFINE wc   INT    
  DEFINE b_x,b_y,e_x,e_y INT
  DEFINE width INT
  DEFINE i,t   INT    


  CASE word
    WHEN "IF"
      LET ct = "如果"
      LET wc = 4
    WHEN "THEN"
      LET ct = "那么"
      LET wc = 4
    WHEN "ELSE"
      LET ct = "否则"
      LET wc = 4
    WHEN "END IF"
      LET ct = "结束"
      LET wc = 4

    #number
    WHEN "0"
      LET ct = "0"
      LET wc = 1
    WHEN "1"
      LET ct = "1"
      LET wc = 1
    WHEN "2"
      LET ct = "2"
      LET wc = 1
    WHEN "3"
      LET ct = "3"
      LET wc = 1
    WHEN "4"
      LET ct = "4"
      LET wc = 1
    WHEN "5"
      LET ct = "5"
      LET wc = 1
    WHEN "6"
      LET ct = "6"
      LET wc = 1
    WHEN "7"
      LET ct = "7"
      LET wc = 1
    WHEN "8"
      LET ct = "8"
      LET wc = 1
    WHEN "9"
      LET ct = "9"
      LET wc = 1

    #operation
    WHEN "+"
      LET ct = "+"
      LET wc = 1
    WHEN "-"
      LET ct = "-"
      LET wc = 1
    WHEN "*"
      LET ct = "*"
      LET wc = 1
    WHEN "/"
      LET ct = "/"
      LET wc = 1
   WHEN ";"
      LET ct = ";"
      LET wc = 1

    WHEN "="
      LET ct = "="
      LET wc = 1

    WHEN "=="
      LET ct = "=="
      LET wc = 2
 
      
    WHEN " "
      LET ct = " "
      LET wc = 2

   OTHERWISE
      #EXIT PROGRAM
  END CASE



  FOR i = 1 TO Formula.getLength()
    IF(Formula[i].beginX == myCursor.CursorPosX
       AND Formula[i].beginY == myCursor.CursorPosY) THEN
      LET ln = Formula[i].lineNumber
      LET b_x = Formula[i].beginX
      LET b_y = Formula[i].beginY
      LET e_x = b_x + wc * WordWidth
      LET e_y = Formula[i].endY
      LET width = e_x - b_x

  
      CALL Formula.insertElement(i)
      LET Formula[i].id = g_id
      LET g_id = g_id + 1
      LET Formula[i].mark = word
      LET Formula[i].context = ct
      LET Formula[i].length  = wc
      LET Formula[i].lineNumber = ln
      LET Formula[i].beginX = b_x
      LET Formula[i].beginY = b_y
      LET Formula[i].endX   = e_x
      LET Formula[i].endY   = e_y

      #IF the text is out of range,move the display window
      IF( e_x > DW.offsetX + DW.width) THEN
        LET DW.offsetX = e_x - DW.width
      END IF

      #Move the words after the inserted in the same line
      FOR t = i + 1 TO Formula.getLength()
        IF(Formula[t].lineNumber != ln) THEN
          EXIT FOR
        ELSE
          LET Formula[t].beginX = Formula[t].beginX + width
          LET Formula[t].endX = Formula[t].endX + width
        END IF
      END FOR

      CALL RePaint()

     
      CALL CursorMoveRight()

      EXIT FOR
    ELSE
      CONTINUE FOR
    END IF

  END FOR

END FUNCTION



FUNCTION DrawCursor()
  DEFINE cid,x,y INTEGER

  CALL DrawClear()
  CALL DrawFillColor("black")
  CALL DrawLineWidth(myCursor.CursorWidth)

  LET x = myCursor.CursorPosX
  LET y = myCursor.CursorPosY

  #cursor is out of the range of X or Y axis
  IF( x < DW.offsetX ) THEN
    LET DW.offsetX = x
  END IF
  IF( x > DW.offsetX + DW.width ) THEN
    LET DW.offsetX = x - DW.width  
  END IF
  IF( y < DW.offsetY ) THEN
    LET DW.offsetY = y
  END IF
  IF( y >  DW.offsetY + DW.height ) THEN
    LET DW.offsetY = y - DW.height
  END IF
    
  #cursor in the display window
  IF( x >= DW.offsetX AND x <= DW.offsetX + DW.width
    AND y >= DW.offsetY AND y <= DW.offsetY + DW.height) THEN
    LET cid = DrawLine(y - DW.offsetY,x - DW.offsetX,myCursor.CursorHeight,0)
    LET cid = DrawLine(y - DW.offsetY,x - DW.offsetX,100,100)
    LET cid = DrawLine(y - DW.offsetY,x - DW.offsetX,-100,100)
    LET cid = DrawLine(450,450,100,100)
    LET cid = DrawLine(1000,100,-100,100)
    LET cid = DrawLine(800,100,100,100)
    LET cid = DrawLine(900,0,0,200)
    LET cid = DrawLine(800,100,200,0)
  ELSE 
    
  END IF

  
  IF myCursor.Pos != Formula.getLength() THEN  
  #draw the syntax tips   
  #LET cid = DrawRectangle(myCursor.CursorPosY,myCursor.CursorPosX-40,20,20)
                          #Formula[myCursor.Pos].beginY - Formula[myCursor.Pos].endY,
                          #Formula[myCursor.Pos].endX - Formula[myCursor.Pos].beginX) 
  END IF                          
  
END FUNCTION


FUNCTION CursorMoveLeft()
  DEFINE i INT

  CALL DrawFillColor("black")

  LET i = myCursor.Pos

  IF(i == 1) THEN
  ELSE
    LET myCursor.CursorPosX = Formula[i-1].beginX
    LET myCursor.CursorPosY = Formula[i-1].beginY
    LET myCursor.Ln         = Formula[i-1].lineNumber
    LET myCursor.Pos = myCursor.Pos - 1
  END IF

  CALL DrawCursor()
  CALL RePaint()


END FUNCTION

FUNCTION CursorMoveUp()
  DEFINE i ,t , cl INT

  CALL DrawFillColor("black")

  LET i = myCursor.Pos

  LET cl = Formula[i].lineNumber  
  IF(cl == 1) THEN
  ELSE     
    FOR t = i TO 1 STEP -1
      IF(Formula[t].lineNumber = cl - 2) THEN
        LET myCursor.CursorPosX = Formula[t+1].beginX
        LET myCursor.CursorPosY = Formula[t+1].beginY
        LET myCursor.Ln         = Formula[t+1].lineNumber
        LET myCursor.Pos        = t + 1
        EXIT FOR
      END IF               
    END FOR 
    IF(t == 0) THEN
        LET myCursor.CursorPosX = Formula[1].beginX
        LET myCursor.CursorPosY = Formula[1].beginY
        LET myCursor.Ln         = Formula[1].lineNumber
        LET myCursor.Pos        = 1    
    END IF    
  END IF           

  CALL DrawCursor()
  CALL RePaint()
  
END FUNCTION

FUNCTION CursorMoveDown()

  DEFINE i ,t , cl INT

  CALL DrawFillColor("black")

  LET i = myCursor.Pos

  LET cl = Formula[i].lineNumber  
  IF(cl == Formula[Formula.getLength()].lineNumber) THEN
  ELSE     
    FOR t = i TO Formula.getLength()
      IF(Formula[t].lineNumber = cl + 1) THEN
        LET myCursor.CursorPosX = Formula[t].beginX
        LET myCursor.CursorPosY = Formula[t].beginY
        LET myCursor.Ln         = Formula[t].lineNumber
        LET myCursor.Pos        = t 
        EXIT FOR
      END IF               
    END FOR   
  END IF           

  CALL DrawCursor()
  CALL RePaint()
  
END FUNCTION


FUNCTION CursorMoveRight()
  DEFINE i INT

  CALL DrawFillColor("black")

  LET i = myCursor.Pos 

  IF(i == Formula.getLength()) THEN
  ELSE
    LET myCursor.CursorPosX = Formula[i+1].beginX
    LET myCursor.CursorPosY = Formula[i+1].beginY
    LET myCursor.Ln         = Formula[i+1].lineNumber
    LET myCursor.Pos = myCursor.Pos + 1
  END IF
  
  CALL DrawCursor()
  CALL RePaint()


END FUNCTION


FUNCTION RePaint()
  DEFINE x,y,i,id INTEGER

  CALL DrawFillColor("blue")

  LET i = 1

  FOR i = 1 TO Formula.getLength()
    LET x= Formula[i].beginX
    LET y= Formula[i].beginY
    IF( x >= DW.offsetX AND x <= DW.offsetX + DW.width
        AND y >= DW.offsetY AND y <= DW.offsetY + DW.height) THEN
        LET y = y - DW.offsetY
        LET x = x + (Formula[i].length * WordWidth)/2 - DW.offsetX
        LET id = DrawText(y,x,Formula[i].context)
        #LET id = DrawText(900,40,Formula[i].context)
    END IF
  END FOR

END FUNCTION


FUNCTION CursorWrap()
  DEFINE pos,x,y,i,id,ln,width INTEGER

  #insert an blank element at the current position 
  LET pos = myCursor.Pos
  CALL Formula.insertElement(pos)
  LET Formula[pos].id = 0
  LET Formula[pos].mark = " "
  LET Formula[pos].context = " "
  LET Formula[pos].lineNumber = myCursor.Ln
  LET Formula[pos].beginX = myCursor.CursorPosX
  LET Formula[pos].beginY = myCursor.CursorPosY#startY + offsetY - (myCursor.Ln - 1) * LineSpace
  LET Formula[pos].endX   = Formula[pos].beginX + WordWidth
  LET Formula[pos].endY   = Formula[pos].beginY - LineSpace
  
 
  
  #and wrap the word after that
  LET ln = myCursor.Ln
  FOR i = myCursor.Pos + 1 TO Formula.getLength()
    LET Formula[i].lineNumber = Formula[i].lineNumber + 1
    IF(Formula[i].lineNumber = ln + 1) THEN
      LET ln = ln + 1
      LET x = 0;
      LET y = Formula[i].beginY - LineSpace
    ELSE
      LET x = x + width
    END IF
    LET width = Formula[i].endX - Formula[i].beginX
    LET Formula[i].beginX = startX + offsetX + x
    LET Formula[i].beginY = y
    LET Formula[i].endX   = Formula[i].beginX + width
    LET Formula[i].endY   = Formula[i].beginY - LineSpace
  END FOR

  #Set the cursor to the next line
  LET myCursor.Pos = myCursor.Pos + 1
  LET myCursor.Ln = myCursor.Ln + 1
  LET myCursor.CursorPosX = startX + offsetX
  LET myCursor.CursorPosY = startY + offsetY - (myCursor.Ln - 1) * LineSpace 

  CALL DrawCursor()
  CALL RePaint()


END FUNCTION

FUNCTION BACKSPACE()
  DEFINE i,ln,x,y,width INT

  IF myCursor.Pos != 1 THEN

    #put the current word at the position of the word to be deleted
    LET i = myCursor.Pos
    LET x = Formula[i - 1].beginX
    LET y = Formula[i - 1].beginY
    LET width = Formula[i].endX - Formula[i].beginX
    LET Formula[i].beginX = x
    LET Formula[i].endX = x + width
    LET Formula[i].beginY = y
    LET Formula[i].endY = Formula[i-1].endY
    LET Formula[i].lineNumber = Formula[i-1].lineNumber
    
    LET ln = Formula[i-1].lineNumber

    #set the position of the word in the same line of the current word     
    IF(Formula[i].lineNumber == ln) THEN
      FOR i = myCursor.Pos + 1 TO Formula.getLength()
        IF(Formula[i].lineNumber == ln) THEN            
          LET x = Formula[i - 1].endX
          LET y = Formula[i - 1].beginY
          LET width = Formula[i].endX - Formula[i].beginX
          LET Formula[i].beginX = x
          LET Formula[i].endX = x + width
          LET Formula[i].beginY = y
          LET Formula[i].endY = Formula[i-1].endY
          LET Formula[i].lineNumber = Formula[i-1].lineNumber
        ELSE  
          EXIT FOR        
        END IF        
      END FOR        
    ELSE
        #if the cursor is at the first position of the line
        #append the current line to last line
        #and set the position of every line after it
      FOR i = myCursor.Pos + 1 TO Formula.getLength()
        IF(Formula[i].lineNumber == ln + 1) THEN            
          LET x = Formula[i - 1].endX
          LET y = Formula[i - 1].beginY
          LET width = Formula[i].endX - Formula[i].beginX
          LET Formula[i].beginX = x
          LET Formula[i].endX = x + width
          LET Formula[i].beginY = y
          LET Formula[i].endY = Formula[i-1].endY
          LET Formula[i].lineNumber = Formula[i-1].lineNumber
        ELSE  
          LET Formula[i].lineNumber = Formula[i].lineNumber - 1
          LET Formula[i].beginY = Formula[i].beginY + LineSpace
          LET Formula[i].endY   = Formula[i].endY + LineSpace     
        END IF      
      END FOR      
    END IF

    {  
    #set the position of the word in the same line of the current word    
    FOR i = myCursor.Pos + 1 TO Formula.getLength()
      IF(Formula[i].lineNumber == ln) THEN            
        LET x = Formula[i - 1].endX
        LET y = Formula[i - 1].beginY
        LET width = Formula[i].endX - Formula[i].beginX
        LET Formula[i].beginX = x
        LET Formula[i].endX = x + width
        LET Formula[i].beginY = y
        LET Formula[i].endY = Formula[i-1].endY
        LET Formula[i].lineNumber = Formula[i-1].lineNumber
      ELSE
        #if the cursor is at the first position of the line
        #append the current line to last line
        #and set the position of every line after it
        IF(Formula[myCursor.Pos - 1].id == 0) THEN
          LET Formula[i].lineNumber = Formula[i].lineNumber - 1
          LET Formula[i].beginY = Formula[i].beginY + LineSpace
          LET Formula[i].endY   = Formula[i].endY + LineSpace
        #if not ,do nothing and exit
        ELSE
          EXIT FOR
        END IF
      END IF
    END FOR
}    

    LET myCursor.Pos = myCursor.Pos - 1
    CALL Formula.deleteElement(myCursor.Pos)

    LET myCursor.Ln = Formula[myCursor.Pos].lineNumber
    LET myCursor.CursorPosX = Formula[myCursor.Pos].beginX
    LET myCursor.CursorPosY = Formula[myCursor.Pos].beginY
    
    CALL DrawCursor()
    CALL RePaint()

  END IF
END FUNCTION

FUNCTION DEL()
  DEFINE i,ln,x,y,width INT

  IF myCursor.Pos != Formula.getLength() THEN
    LET myCursor.Pos = myCursor.Pos + 1
    CALL BACKSPACE()

  END IF

END FUNCTION

