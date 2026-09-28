# Property of Four Js*
# (c) Copyright Four Js 1995, 2012. All Rights Reserved.
# * Trademark of Four Js Development Tools Europe Ltd
#   in the United States and elsewhere
#
# Four Js and its suppliers do not warrant or guarantee that these
# samples are accurate and suitable for your purposes. Their inclusion is
# purely for information purposes only.

# Using DrawGetClickedItemId() to identify what canvas item was clicked p_formulaedit Formula

IMPORT FGL fgldraw

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE Formula DYNAMIC ARRAY OF RECORD
            id             INT,    
            mark           LIKE hrdka_file.hrdka04, 
            context        LIKE hrdka_file.hrdka05, 
            lineNumber     INT,    
            length         INT,
            beginX,beginY  INT,    
            endX,endY      INT,     
            type           LIKE hrdka_file.hrdka12     
        END RECORD

DEFINE Formula_t DYNAMIC ARRAY OF RECORD
            id             INT,    
            mark           LIKE hrdka_file.hrdka04, 
            context        LIKE hrdka_file.hrdka05, 
            lineNumber     INT,    
            length         INT,
            beginX,beginY  INT,    
            endX,endY      INT,     
            type           LIKE hrdka_file.hrdka12     
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
    s_ln   INT,  #start line number 
    height INT   #contains how many lines
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

DEFINE  g_keyword       DYNAMIC ARRAY OF RECORD
          hred02     LIKE    hred_file.hred02,
          hred03     LIKE    hred_file.hred03,
          hred04     LIKE    hred_file.hred04,
          type       STRING        
                     END RECORD

DEFINE  g_para       DYNAMIC ARRAY OF RECORD
          hrdh12     LIKE    hrdh_file.hrdh12,
          hrdh06     LIKE    hrdh_file.hrdh06,
          hrdh13     LIKE    hrdh_file.hrdh13,
          type       STRING        
                     END RECORD
DEFINE  g_value       DYNAMIC ARRAY OF RECORD
          hrag06     LIKE    type_file.chr1000,
          hrag07     LIKE    type_file.chr1000,
          type       STRING        
                     END RECORD

DEFINE  g_inc       DYNAMIC ARRAY OF RECORD
          hrdk01     LIKE    hrdk_file.hrdk01,
          hrdk03     LIKE    hrdk_file.hrdk03,
          hrdk16     LIKE    hrdk_file.hrdk16,
          hrdk19     LIKE    hrdk_file.hrdk19,
          type       STRING        
                     END RECORD

DEFINE tipString String  #to show in the tip textedit

DEFINE mywin ui.Window   
DEFINE myform ui.Form
DEFINE LineSpace , WordWidth , g_id , startX, startY, offsetX, offsetY, g_coursorL, g_coursorR INTEGER

DEFINE g_desc STRING #描述

DEFINE g_argv1   LIKE   hrdk_file.hrdk01     #传递参数----add by zhangbo for test
DEFINE g_str     STRING                      #add by zhangbo for test 
DEFINE g_hrdk    RECORD LIKE hrdk_file.*     #add by zhangbo for test
DEFINE g_flag    LIKE  type_file.chr1

MAIN
  
  DEFINE i,l_i,l_j,l_k,l_rn      INT                  #add by zhangbo for test
  DEFINE l_str1,l_str2    STRING               #add by zhangbo for test
  #DEFINE l_hrdk14     LIKE  hrdk_file.hrdk14   #add by zhangbo for test
  #DEFINE l_hrdk15     LIKE  hrdk_file.hrdk15   #add by zhangbo for test
  #DEFINE l_hrdk17     LIKE  hrdk_file.hrdk17   #add by zhangbo for test
  DEFINE l_para       DYNAMIC ARRAY OF RECORD  #add by zhangbo for test
           para       LIKE  hrdh_file.hrdh12   #add by zhangbo for test
                      END RECORD               #add by zhangbo for test
  DEFINE l_flag       LIKE   type_file.chr1
  DEFINE l_fun        LIKE   type_file.chr100  
  DEFINE l_desc       LIKE   type_file.chr1000   #add by zhangbo131115 
  DEFINE l_sql        STRING                     #add by zhangbo130913
  DEFINE l_syz        STRING                     #add by zhangbo130913
  DEFINE l_hrdxb02    LIKE   hrdxb_file.hrdxb02  #add by zhangbo130913
  DEFINE l_check      LIKE   type_file.num5      #add by zhangbo130913
  DEFINE l_flagb,l_flage   LIKE   type_file.chr1 #add by zhangbo131112
  DEFINE l_stra,l_strb     STRING                #add by zhangbo131112
  DEFINE l_n               LIKE   type_file.num5 #add by zhangbo131112
  DEFINE l_length          LIKE   type_file.num5 #add by zhangbo131112
  DEFINE l_cnt             LIKE   type_file.num5 #add by zhangbo131115 


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

  #CALL drawInit()
  #OPEN FORM canvas FROM "ghr/42f/ghri999"
  #DISPLAY FORM canvas
  OPEN WINDOW canvas WITH FORM "ghr/42f/ghri999"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

  CALL cl_ui_init()

  LET g_argv1=ARG_VAL(1)    #接收参数---add by zhangbo for test
  
  SELECT * INTO g_hrdk.* FROM hrdk_file WHERE hrdk01=g_argv1

  IF STATUS=100 THEN
     CALL cl_err('此计算项编号还未维护','!',1)
     CLOSE WINDOW canvas     #add by zhangbo130905
     EXIT PROGRAM
  END IF

  CALL Init()


  MENU
    #mark by zhangbo130909---begin
    #ON ACTION b_IF
    #  CALL AddWord("IF")
    #ON ACTION b_THEN
    #  CALL AddWord("THEN")
    #ON ACTION b_RESULT
    #  CALL AddWord("RESULT")  
    #ON ACTION b_ELSE
    #  CALL AddWord("ELSE")
    #ON ACTION b_END
    #  CALL AddWord("END IF")
    #mark by zhangbo130909---end

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

    #ON ACTION b_equal   #mark by zhangbo130906
    ON ACTION 逻辑等于   #add by zhangbo130906
      CALL AddWord("=")
    #ON ACTION b_equals  #mark by zhangbo130906
    ON ACTION 赋值等于   #add by zhangbo130906
      CALL AddWord(":=")
    ON ACTION b_more
      CALL AddWord(">")
    ON ACTION b_less
      CALL AddWord("<")

    ON ACTION s_quotes
      CALL AddWord("'")

    #ON ACTION d_quotes
    #  CALL AddWord(""")
    
    ON ACTION b_semicolon
      CALL AddWord(";")
    
    ON ACTION b_comma
      CALL AddWord(",")

    ON ACTION l_bracket
      CALL AddWord("(")

    ON ACTION r_bracket
      CALL AddWord(")")

    ON ACTION b_point
      CALL AddWord(".")

    #add by zhangbo130906---begin
    ON ACTION 不等于
      CALL AddWord("<>")
    #add by zhangbo130906---end

    ON ACTION fun_num
      CALL Get_fun_num() RETURNING l_fun,l_desc   #mod by zhangbo131115
      IF NOT cl_null(l_fun) THEN 
         CALL AddWord(l_fun)
         DISPLAY l_desc TO description             #add by zhangbo131115
      END IF

    ON ACTION fun_date
      CALL Get_fun_date() RETURNING l_fun,l_desc   #mod by zhangbo131115
      IF NOT cl_null(l_fun) THEN
         CALL AddWord(l_fun)
         DISPLAY l_desc TO description             #add by zhangbo131115
      END IF

    #add by zhangbo130909---begin
    #取上月值
    ON ACTION v_lmth
       CALL AddWord("取上月值")          #add by zhangbo130913
       CALL AddWord("(")                 #add by zhangbo130913
       CALL AddWord("'")                #add by zhangbo130913
       CALL AddWord("'")                #add by zhangbo130913
       CALL AddWord(")")                 #add by zhangbo130913
    
    #取部门值
    ON ACTION v_grup
 
    #add by zhangbo130909---end

    #add by zhangbo131112---begin
    ON ACTION v_getsum
       CALL AddWord("取累计值")          #add by zhangbo130913
       CALL AddWord("(")                 #add by zhangbo130913
       CALL AddWord(")")                 #add by zhangbo130913
    #add by zhangbo131112---end

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
    COMMAND KEY (',')
      CALL AddWord(",")
    COMMAND KEY ("'")
      CALL AddWord("'")
    COMMAND KEY (';')
      CALL AddWord(";")
    COMMAND KEY ('.')
      CALL AddWord(".")

    #COMMAND KEY (CONTROL-"9")
    #  CALL AddWord("(")
    #COMMAND KEY (CONTROL-A)
    #  CALL AddWord(")")

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
      CALL getKey("a")
    COMMAND KEY (B)
      CALL getKey("b")
    COMMAND KEY (C)
      CALL getKey("c")
    COMMAND KEY (D)
      CALL getKey("d")
    COMMAND KEY (E)
      CALL getKey("e")
    COMMAND KEY (F)
      CALL getKey("f")
    COMMAND KEY (G)
      CALL getKey("g")
    COMMAND KEY (H)
      CALL getKey("h")
    COMMAND KEY (I)
      CALL getKey("i")
    COMMAND KEY (J)
      CALL getKey("j")
    COMMAND KEY (K)
      CALL getKey("k")
    COMMAND KEY (L)
      CALL getKey("l")
    COMMAND KEY (M)
      CALL getKey("m")
    COMMAND KEY (N)
      CALL getKey("n")
    COMMAND KEY (O)
      CALL getKey("o")
    COMMAND KEY (P)
      CALL getKey("p")
    COMMAND KEY (Q)
      CALL getKey("q")
    COMMAND KEY (R)
      CALL getKey("r")
    COMMAND KEY (S)
      CALL getKey("s")
    COMMAND KEY (T)
      CALL getKey("t")
    COMMAND KEY (U)
      CALL getKey("u")
    COMMAND KEY (V)
      CALL getKey("v")
    COMMAND KEY (W)
      CALL getKey("w")
    COMMAND KEY (X)
      CALL getKey("x")
    COMMAND KEY (Y)
      CALL getKey("y")
    COMMAND KEY (Z)
      CALL getKey("z")

    #add by zhangbo130909
    COMMAND "参数分类浏览"
       CALL cl_cmdrun_wait("ghrq076")
    COMMAND "人事参数维护"
       CALL cl_cmdrun_wait("ghri115")
    COMMAND "考勤参数维护"
       CALL cl_cmdrun_wait("ghri077")
    COMMAND "薪资参数维护"
       CALL cl_cmdrun_wait("ghri076")
    #add by zhangbo130909

    #COMMAND "quit"
    COMMAND "保存"
      LET g_flag='Y'
      EXIT MENU
    
    COMMAND "退出"
      LET g_flag='N'
      EXIT MENU

    #add by zhangbo for test
    #ON ACTION close
    #   LET g_flag='N'
    #   EXIT MENU
    #add by zhangbo for test

  END MENU
  
  IF g_flag='N' OR cl_null(g_flag) THEN
     CLOSE WINDOW canvas     #add by zhangbo130905
     EXIT PROGRAM
  END IF
  
  #add by zhangbo for test---begin
  #将数组Formula的元素连接起来 
  IF NOT cl_null(g_argv1) THEN 
     IF Formula.getLength()>1 THEN
        BEGIN WORK
        LET g_success='Y'
        DELETE FROM hrdka_file WHERE hrdka01=g_argv1
        IF SQLCA.sqlcode THEN
           CALL cl_err('删除原数组数据出错','!',0)
           LET g_success='N'
        END IF
        IF g_success='Y' THEN
           LET g_hrdk.hrdk14=NULL
           LET g_hrdk.hrdk15=NULL
           LET g_hrdk.hrdk17=NULL
           LET g_hrdk.hrdkud01=NULL
           LET l_str1=NULL
           LET l_str2=NULL
           LET l_j=0
           LET l_rn=0
           FOR l_i=1 TO Formula.getLength()-1
            IF Formula[l_i].mark = 'cur' THEN
               CONTINUE FOR
            END IF 
            IF l_i > 1 THEN 
               IF Formula[l_i].lineNumber != Formula[l_i-1].lineNumber THEN 
                  LET l_rn=0
               END IF 
            END IF 
            LET l_rn=l_rn+1
              INSERT INTO hrdka_file VALUES (g_argv1,l_i,Formula[l_i].id,Formula[l_i].mark,Formula[l_i].context,
                                             Formula[l_i].lineNumber,l_rn,Formula[l_i].beginX,
                                             Formula[l_i].beginY,Formula[l_i].endX,Formula[l_i].endY,Formula[l_i].type)
              IF SQLCA.sqlcode THEN
                 CALL cl_err('保存数组出错','!',0)
                 LET g_success='N'
                 EXIT FOR 
              END IF

              IF Formula[l_i].id=0 THEN
                 LET Formula[l_i].context="\n"
                 LET Formula[l_i].mark="\n"
              END IF

              IF Formula[l_i].type='包含项' THEN
                 LET g_hrdk.hrdkud01 = g_hrdk.hrdkud01,',',Formula[l_i].mark
              END IF
              #IF Formula[l_i].type='1' THEN       #改成中文显示
              IF Formula[l_i].type='参数' THEN
                 IF l_j=0 THEN
                    LET l_j=l_j+1
                    LET l_para[l_j]=Formula[l_i].mark
                 ELSE
                    LET l_flag='N'
                    FOR l_k=1 TO l_j
                       IF l_para[l_k].para=Formula[l_i].mark THEN
                          LET l_flag='Y'
                          EXIT FOR
                       END IF
                    END FOR
                    IF l_flag='N' THEN
                       LET l_j=l_j+1
                       LET l_para[l_j].para=Formula[l_i].mark
                    END IF
                 END IF
              END IF   
              #LET l_hrdk15=l_hrdk15,Formula[l_i].context
              #LET l_hrdk17=l_hrdk17,Formula[l_i].mark

              IF Formula[l_i].type='参数值' THEN  #参数值加引号
              	 LET l_str1=l_str1,Formula[l_i].context
                 LET l_str2=l_str2,"'",Formula[l_i].mark,"'"
              ELSE	
                 LET l_str1=l_str1,Formula[l_i].context
                 LET l_str2=l_str2,Formula[l_i].mark
              END IF

           END FOR
        END IF

        IF g_success='Y' THEN
           IF l_j>0 THEN
              FOR i=1 TO l_j
                 IF i=1 THEN
                    LET g_hrdk.hrdk14=l_para[i].para
                 ELSE
                    LET g_hrdk.hrdk14=g_hrdk.hrdk14,"|",l_para[i].para
                 END IF
              END FOR
           END IF
    
           CALL cl_replace_str(l_str2,'FN_GETLASTVALUE(','FN_GETLASTVALUE(p_hrat01,p_hrct11,')   #add by zhangbo130913
             RETURNING l_str2   #add by zhangbo130913 
           
           #add by zhangbo131112---begin
           LET l_flagb='B'
           LET l_flage='E'
           CALL cl_replace_str(l_str2,"FN_XZYDATE_B","FN_XZYDATE(p_hrct11,'B')")
              RETURNING l_str2
           CALL cl_replace_str(l_str2,"FN_XZYDATE_E","FN_XZYDATE(p_hrct11,'E')")
              RETURNING l_str2
           #CALL cl_replace_str(l_str2,'FN_XZYDATE_E','FN_XZYDATE(p_hrct11,l_flage)')
           #   RETURNING l_str2
           #add by zhangbo131112---end 

           #add by zhangbo131112---begin
           LET l_n=0
           LET l_n=l_str2.getIndexOf('FN_GETSUM',1)
           #IF l_n>0 THEN         #mark by zhangbo131115
           WHILE l_n>0
              LET l_length=l_str2.getLength()
              LET l_stra=l_str2.subString(1,l_n+9)
              LET l_strb=l_str2.subString(l_n+10,l_length)
              LET l_cnt=l_strb.getIndexOf(')',1)
              LET l_length=l_strb.getLength()
              LET l_str2=l_stra CLIPPED,"'",l_strb.subString(1,l_cnt-1) CLIPPED,"'",l_strb.subString(l_cnt,l_length)
              #CALL cl_replace_str(l_str2,'FN_GETSUM(','FN_GETSUM(p_hrat01,')    #mark by zhangbo131115
              #   RETURNING l_str2                                               #mark by zhangbo131115
              LET l_n=l_str2.getIndexOf('FN_GETSUM',l_n+1)
           #END IF                #mark by zhangbo131115
           END WHILE              #add by zhangbo131115  

           CALL cl_replace_str(l_str2,'FN_GETSUM(','FN_GETSUM(p_hrat01,')    #add by zhangbo131115
                RETURNING l_str2                                             #add by zhangbo131115
           
           #add by zhangbo131112---end 

           LET g_hrdk.hrdk15=l_str1
           LET g_hrdk.hrdk17=l_str2

           LET g_hrdk.hrdkud01 = cl_replace_str(g_hrdk.hrdkud01,",res","|")
         IF g_hrdk.hrdk05 = '001' OR g_hrdk.hrdk05 = '003' THEN LET g_hrdk.hrdk17 = g_hrdk.hrdk17," SELECT  TRUNC(",g_hrdk.hrdk16,",",g_hrdk.hrdk06,") INTO ",g_hrdk.hrdk16," FROM dual;" END IF 
         IF g_hrdk.hrdk05 = '002' THEN LET g_hrdk.hrdk17 = g_hrdk.hrdk17," SELECT  ROUND(",g_hrdk.hrdk16,",",g_hrdk.hrdk06,") INTO ",g_hrdk.hrdk16," FROM dual;" END IF 
         IF g_hrdk.hrdk05 = '004' THEN LET g_hrdk.hrdk17 = g_hrdk.hrdk17," SELECT  CEIL(",g_hrdk.hrdk16,"*POWER(10,",g_hrdk.hrdk06,"))/POWER(10,",g_hrdk.hrdk06,") INTO ",g_hrdk.hrdk16," FROM dual;" END IF 
           UPDATE hrdk_file SET hrdk14=g_hrdk.hrdk14,hrdk15=g_hrdk.hrdk15,hrdk17=g_hrdk.hrdk17,hrdkud01=g_hrdk.hrdkud01
            WHERE hrdk01=g_argv1
           IF SQLCA.sqlcode THEN
              CALL cl_err('更新公式内容出错','!',0)
              LET g_success='N'
           #add by zhangbo131111---begin
           #修改公式之后更新包含此公式的存储过程
           ELSE
              IF SQLCA.sqlerrd[3]<>0 THEN
                 CALL Upd_procedure()
              END IF
           #add by zhangbo131111---end
           END IF
        END IF
        
        IF g_success='Y' THEN
           COMMIT WORK
        ELSE
           ROLLBACK WORK
        END IF

     END IF
  END IF
  #add by zhangbo for test---end
  CLOSE WINDOW canvas     #add by zhangbo130905
END MAIN

#add by zhangbo131111---begin
FUNCTION Upd_procedure()
DEFINE l_n          LIKE      type_file.num5
DEFINE l_hrdl01     LIKE      hrdl_file.hrdl01
DEFINE l_sql1       STRING
       
       LET l_n=0
       SELECT COUNT(*) INTO l_n FROM hrdl_file,hrdla_file
        WHERE hrdl01=hrdla01
          AND hrdla02=g_argv1
       IF l_n=0 THEN
          RETURN
       END IF

       LET l_sql1=" SELECT DISTINCT hrdl01 FROM hrdl_file,hrdla_file ",
                  "  WHERE hrdl01=hrdla01 ",
                  "    AND hrdla02='",g_argv1,"'"
       PREPARE Updpro_hrdl01_pre FROM l_sql1
       DECLARE Updpro_hrdl01 CURSOR FOR Updpro_hrdl01_pre

       
       FOREACH Updpro_hrdl01 INTO l_hrdl01
         
          CALL Gen_procedure(l_hrdl01)

          IF g_success='N' THEN
             EXIT FOREACH
          END IF

       END FOREACH 

END FUNCTION

FUNCTION Gen_procedure(p_hrdl01)
DEFINE l_sql          STRING
DEFINE l_hrdla02      LIKE  hrdla_file.hrdla02
DEFINE l_hrdk14       LIKE  hrdk_file.hrdk14
DEFINE l_hrdk16       LIKE  hrdk_file.hrdk16
DEFINE l_hrdk17       LIKE  hrdk_file.hrdk17
DEFINE tok            base.StringTokenizer
DEFINE l_str          STRING
DEFINE l_value        LIKE type_file.chr100
DEFINE l_str_head     STRING
DEFINE l_str_init     STRING
DEFINE l_str_value    STRING
DEFINE l_str_body     STRING
DEFINE l_str_res      STRING
DEFINE l_str_tail     STRING
DEFINE l_str_pro      STRING
DEFINE i,l_i          LIKE  type_file.num5
DEFINE j,k            LIKE  type_file.num5
DEFINE l_para         DYNAMIC ARRAY OF RECORD
         para         LIKE  hrdh_file.hrdh12
                      END RECORD
DEFINE l_res          DYNAMIC ARRAY OF RECORD
         res          LIKE  hrdk_file.hrdk16
                      END RECORD
DEFINE l_formula      DYNAMIC ARRAY OF RECORD
         fml          LIKE  hrdk_file.hrdk17
                      END RECORD
DEFINE l_flag         LIKE  type_file.chr1
DEFINE l_length       LIKE  type_file.num10
DEFINE l_hrdl21       LIKE  hrdl_file.hrdl21
DEFINE l_str_test     STRING
DEFINE l_hrdl11       LIKE  hrdl_file.hrdl11
DEFINE l_hrdl12       LIKE  hrdl_file.hrdl12
DEFINE l_hrdl13       LIKE  hrdl_file.hrdl13
DEFINE l_hrdl14       LIKE  hrdl_file.hrdl14
DEFINE l_hrdl15       LIKE  hrdl_file.hrdl15
DEFINE l_hrdl16       LIKE  hrdl_file.hrdl16
DEFINE l_hrdl17       LIKE  hrdl_file.hrdl17
DEFINE l_hrdl18       LIKE  hrdl_file.hrdl18
DEFINE l_hrdl19       LIKE  hrdl_file.hrdl19
DEFINE l_hrdl20       LIKE  hrdl_file.hrdl20
DEFINE l_arg          LIKE  type_file.chr1000
DEFINE li_res         LIKE  hrdl_file.hrdl11
DEFINE l_hrdl22       LIKE  hrdl_file.hrdl22     #add by zhangbo130730
DEFINE p_hrdl01       LIKE  hrdl_file.hrdl01     

       LET l_str_head="create or replace procedure salary",
                      "(p_hrat01 in varchar2,p_hrct11 in varchar2,res out varchar2) is \n"    #mod by zhangbo---hrct11薪资月
       LET l_str_body=""
       LET l_str_tail="end;"
       LET l_str_value=''
       LET l_str_res="res:="

       LET l_sql=" SELECT hrdla02 FROM hrdla_file ",
                 "  WHERE hrdla01='",p_hrdl01,"'",
                 "  ORDER BY hrdla03 "
       PREPARE Gen_pro_pre1 FROM l_sql
       DECLARE Gen_pro_cs1 CURSOR FOR Gen_pro_pre1

       LET i=0
       LET j=0
       LET k=0

       FOREACH Gen_pro_cs1 INTO l_hrdla02

          LET l_str=''
          SELECT hrdk14 INTO l_hrdk14 FROM hrdk_file WHERE hrdk01=l_hrdla02
          LET l_str=l_hrdk14
          LET l_str=l_str.trim()
          LET tok = base.StringTokenizer.create(l_str,"|")
          IF NOT cl_null(l_str) THEN
             WHILE tok.hasMoreTokens()
                LET l_value=tok.nextToken()
                IF i=0 THEN
                         LET i=i+1
                         LET l_para[i].para=l_value
                ELSE
                         LET l_flag='N'
                         FOR l_i=1 TO i
                            IF l_para[l_i].para=l_value THEN
                                 LET l_flag='Y'
                                 EXIT FOR
                            END IF
                         END FOR
                         IF l_flag='N' THEN
                                  LET i=i+1
                                  LET l_para[i].para=l_value
                         END IF
                END IF
             END WHILE
          END IF

          SELECT hrdk16,hrdk17 INTO l_hrdk16,l_hrdk17 FROM hrdk_file
           WHERE hrdk01=l_hrdla02
          IF NOT cl_null(l_hrdk16) THEN
                 LET j=j+1
                 LET l_res[j].res=l_hrdk16
          END IF
          IF NOT cl_null(l_hrdk17) THEN
                 LET k=k+1
                 LET l_formula[k].fml=l_hrdk17
          END IF

       END FOREACH

       #定义参数以及参数取值
       FOR l_i=1 TO i
           #add by zhangbo130730---begin
           #记录所有参数
           IF l_i=1 THEN
              LET l_hrdl22=l_para[l_i].para
           ELSE
              LET l_hrdl22=l_hrdl22 CLIPPED,"|",l_para[l_i].para
           END IF

           #add by zhangbo130730---end

           LET l_str_head=l_str_head,l_para[l_i].para," varchar2(100); \n"
           #mod by zhangbo130730---参数表hrdxc_file
           LET l_str_value=l_str_value,"SELECT hrdxc05 INTO ",l_para[l_i].para,
                           " FROM hrdxc_file WHERE hrdxc02=p_hrat01 AND hrdxc01=p_hrct11 AND hrdxc08='",l_para[l_i].para,"'; \n"
       END FOR

       LET l_str_body=l_str_body,l_str_value

       #组合主逻辑块
       FOR l_i=1 TO k
          LET l_str_body=l_str_body,l_formula[l_i].fml," \n"
       END FOR

       #定义输出结果的参数
       FOR l_i=1 TO j
          IF l_i=1 THEN
                 LET l_str_res=l_str_res,l_res[l_i].res
          ELSE
                 LET l_str_res=l_str_res,"||','||",l_res[l_i].res
          END IF

          LET l_str_head=l_str_head,l_res[l_i].res," varchar2(100); \n"
          LET l_str_init=l_str_init,l_res[l_i].res," := 0;\n"

       END FOR

       LET l_str_pro=l_str_head,"begin \n",l_str_init,l_str_body,l_str_res,"; \n",l_str_tail
       LET l_length=l_str_pro.getLength()
       LET l_hrdl11=''
       LET l_hrdl12=''
       LET l_hrdl13=''
       LET l_hrdl14=''
       LET l_hrdl15=''
       LET l_hrdl16=''
       LET l_hrdl17=''
       LET l_hrdl18=''
       LET l_hrdl19=''
       LET l_hrdl20=''
       IF l_length<=4000 THEN
          LET l_hrdl11=l_str_pro.subString(1,l_length)
       END IF
       IF l_length>4000 AND l_length<=8000 THEN
          LET l_hrdl11=l_str_pro.subString(1,4000)
          LET l_hrdl12=l_str_pro.subString(4001,l_length)
       END IF
       IF l_length>8000 AND l_length<=12000 THEN
          LET l_hrdl11=l_str_pro.subString(1,4000)
          LET l_hrdl12=l_str_pro.subString(4001,8000)
          LET l_hrdl13=l_str_pro.subString(8001,l_length)
       END IF
       IF l_length>12000 AND l_length<=16000 THEN
          LET l_hrdl11=l_str_pro.subString(1,4000)
          LET l_hrdl12=l_str_pro.subString(4001,8000)
          LET l_hrdl13=l_str_pro.subString(8001,12000)
          LET l_hrdl14=l_str_pro.subString(12001,l_length)
       END IF
       IF l_length>16000 AND l_length<=20000 THEN
          LET l_hrdl11=l_str_pro.subString(1,4000)
          LET l_hrdl12=l_str_pro.subString(4001,8000)
          LET l_hrdl13=l_str_pro.subString(8001,12000)
          LET l_hrdl14=l_str_pro.subString(12001,16000)
          LET l_hrdl15=l_str_pro.subString(16001,l_length)
       END IF
       IF l_length>20000 AND l_length<=24000 THEN
          LET l_hrdl11=l_str_pro.subString(1,4000)
          LET l_hrdl12=l_str_pro.subString(4001,8000)
          LET l_hrdl13=l_str_pro.subString(8001,12000)
          LET l_hrdl14=l_str_pro.subString(12001,16000)
          LET l_hrdl15=l_str_pro.subString(16001,20000)
          LET l_hrdl16=l_str_pro.subString(20001,l_length)
       END IF
       IF l_length>24000 AND l_length<=28000 THEN
          LET l_hrdl11=l_str_pro.subString(1,4000)
          LET l_hrdl12=l_str_pro.subString(4001,8000)
          LET l_hrdl13=l_str_pro.subString(8001,12000)
          LET l_hrdl14=l_str_pro.subString(12001,16000)
          LET l_hrdl15=l_str_pro.subString(16001,20000)
          LET l_hrdl16=l_str_pro.subString(20001,24000)
          LET l_hrdl17=l_str_pro.subString(24001,l_length)
       END IF
       IF l_length>28000 AND l_length<=32000 THEN
          LET l_hrdl11=l_str_pro.subString(1,4000)
          LET l_hrdl12=l_str_pro.subString(4001,8000)
          LET l_hrdl13=l_str_pro.subString(8001,12000)
          LET l_hrdl14=l_str_pro.subString(12001,16000)
          LET l_hrdl15=l_str_pro.subString(16001,20000)
          LET l_hrdl16=l_str_pro.subString(20001,24000)
          LET l_hrdl17=l_str_pro.subString(24001,28000)
          LET l_hrdl18=l_str_pro.subString(28001,l_length)
       END IF
       IF l_length>32000 AND l_length<=36000 THEN
          LET l_hrdl11=l_str_pro.subString(1,4000)
          LET l_hrdl12=l_str_pro.subString(4001,8000)
          LET l_hrdl13=l_str_pro.subString(8001,12000)
          LET l_hrdl14=l_str_pro.subString(12001,16000)
          LET l_hrdl15=l_str_pro.subString(16001,20000)
          LET l_hrdl16=l_str_pro.subString(20001,24000)
          LET l_hrdl17=l_str_pro.subString(24001,28000)
          LET l_hrdl18=l_str_pro.subString(28001,32000)
          LET l_hrdl19=l_str_pro.subString(32001,l_length)
       END IF
       IF l_length>36000 AND l_length<=40000 THEN
          LET l_hrdl11=l_str_pro.subString(1,4000)
          LET l_hrdl12=l_str_pro.subString(4001,8000)
          LET l_hrdl13=l_str_pro.subString(8001,12000)
          LET l_hrdl14=l_str_pro.subString(12001,16000)
          LET l_hrdl15=l_str_pro.subString(16001,20000)
          LET l_hrdl16=l_str_pro.subString(20001,24000)
          LET l_hrdl17=l_str_pro.subString(24001,28000)
          LET l_hrdl18=l_str_pro.subString(28001,32000)
          LET l_hrdl19=l_str_pro.subString(32001,36000)
          LET l_hrdl20=l_str_pro.subString(36001,l_length)
       END IF

       UPDATE hrdl_file SET hrdl11=l_hrdl11,
                            hrdl12=l_hrdl12,
                            hrdl13=l_hrdl13,
                            hrdl14=l_hrdl14,
                            hrdl15=l_hrdl15,
                            hrdl16=l_hrdl16,
                            hrdl17=l_hrdl17,
                            hrdl18=l_hrdl18,
                            hrdl19=l_hrdl19,
                            hrdl20=l_hrdl20,
                            hrdl22=l_hrdl22        #add by zhangbo130730
                      WHERE hrdl01=p_hrdl01
       IF SQLCA.sqlcode THEN
          LET g_success='N'
       END IF

END FUNCTION
#add by zhangbo131111---end

FUNCTION Get_fun_num()
DEFINE p_row,p_col   LIKE type_file.num5
DEFINE l_dec    DYNAMIC ARRAY OF RECORD 
         name    LIKE    type_file.chr100,
         des     LIKE    type_file.chr1000
                 END RECORD
DEFINE l_rec_b           LIKE type_file.num5
DEFINE i,l_ac_dec,l_n        LIKE type_file.num5
DEFINE l_str             STRING
DEFINE l_desc            STRING         #add by zhangbo131115

       LET l_str=''
       CALL l_dec.clear()
       
       LET p_row = 11 LET p_col = 3
       OPEN WINDOW i078_date AT p_row,p_col WITH FORM "ghr/42f/ghri078_date"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
       
      
       CALL cl_ui_locale("ghri078_date")
       
       LET l_dec[1].name="FLOOR"
       LET l_dec[1].des="取整:FLOOR(数值):向下取数值的整数部分,如123.45返回123;-123.45返回-124"
       LET l_dec[2].name="ROUND"
       LET l_dec[2].des="四舍五入:ROUND(数值,保留小数位数):按保留的小数位数四舍五入"
       LET l_dec[3].name="MOD"
       LET l_dec[3].des="取余:MOD(除数,被除数):取除数除以被除数的余数" 	
       LET l_dec[4].name="POWER"
       LET l_dec[4].des="幂:POWER(底数,幂):计算底数的幂次方的值"
       LET l_dec[5].name="SANQI"
       LET l_dec[5].des="三舍七入:SANQI(数值):三舍七入,其他为0.5"	
       
       
       LET l_rec_b=5
       
       CALL cl_set_act_visible("accept,cancel", FALSE)
       DISPLAY ARRAY l_dec TO s_fun.* ATTRIBUTE(COUNT=l_rec_b,UNBUFFERED)

       BEFORE ROW
         LET l_ac_dec = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf  
 
       ON ACTION accept
         LET l_str=l_dec[l_ac_dec].name
         LET l_desc=l_dec[l_ac_dec].des        #add by zhangbo131115
         EXIT DISPLAY
          
       END DISPLAY
       CALL cl_set_act_visible("accept,cancel", TRUE)
       CLOSE WINDOW i078_date
       
       RETURN l_str,l_desc                     #mod by zhangbo131115


END FUNCTION

FUNCTION Get_fun_date()
DEFINE p_row,p_col   LIKE type_file.num5
DEFINE l_date    DYNAMIC ARRAY OF RECORD 
         name    LIKE    type_file.chr100,
         des     LIKE    type_file.chr1000
                 END RECORD
DEFINE l_rec_b           LIKE type_file.num5
DEFINE i,l_ac_date,l_n        LIKE type_file.num5
DEFINE l_str             STRING 
DEFINE l_desc            STRING
                
       CALL l_date.clear()
       LET l_str=''
       
       LET p_row = 11 LET p_col = 3
       OPEN WINDOW i078_date AT p_row,p_col WITH FORM "ghr/42f/ghri078_date"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
       
      
       CALL cl_ui_locale("ghri078_date")
       
       LET l_date[1].name="YEAR"
       LET l_date[1].des="YEAR(日期):取日期的年"
       LET l_date[2].name="MONTH"
       LET l_date[2].des="MONTH(日期):取日期的月"
       LET l_date[3].name="DAY"
       LET l_date[3].des="DAY(日期):取日期的日"
       LET l_date[4].name="QUARTER"
       LET l_date[4].des="QUARTER(日期):取日期所在的季度值"
       LET l_date[5].name="WEEK"
       LET l_date[5].des="WEEK(日期):取日期在本年第几周"
       LET l_date[6].name="WEEKDAY"
       LET l_date[6].des="WEEKDAY(日期):取日期是星期几"
       LET l_date[7].name="TODAY"
       LET l_date[7].des="TODAY():取今天的日期"
       LET l_date[8].name="AGE"
       LET l_date[8].des="AGE(日期):计算日期日到现在的年龄"
       LET l_date[9].name="MONTHAGE"
       LET l_date[9].des="MONTHAGE(日期):计算日期月到现在的年龄"
       LET l_date[10].name="WORKAGE"
       LET l_date[10].des="WORKAGE(日期):计算日期年份到现在年份的工龄"
       LET l_date[11].name="YEARS"
       LET l_date[11].des="YEARS(日期1,日期2):计算日期2月到日期1的年数"                 	
       LET l_date[12].name="MONTHS"
       LET l_date[12].des="MONTHS(日期1,日期2):计算日期2月到日期1的月数"
       LET l_date[13].name="DAYS"
       LET l_date[13].des="DAYS(日期1,日期2):计算日期2月到日期1的天数"
       LET l_date[14].name="QUARTERS"
       LET l_date[14].des="QUARTERS(日期1,日期2):计算日期2月到日期1的季度数"
       LET l_date[15].name="WEEKS"
       LET l_date[15].des="WEEKS(日期1,日期2):计算日期2月到日期1的周数"
       LET l_date[16].name="DIFFDATE"
       LET l_date[16].des="DIFFDATE(开始日期,结束日期,返回类型,所属公司):根据返回类型,在日期区间内取值\n",
                          "返回类型=1:返回两个日期中间隔天数;\n",
                          "返回类型=2:返回两个日期中间隔的工作天数(从标准薪资日历中取区间,去假日);\n",
                          "返回类型=3:返回两个日期中间隔的工作天数(从标准薪资日历中取区间,去节假日);\n",
                          "返回类型=4:返回日历中两个日期中间隔的天数(去周六、周日);\n",
                          "返回类型=5:返回两个日期中间隔的工作天数(从考勤企业行事历中取区间,去假日);\n",
                          "返回类型=6:返回两个日期中间隔的工作天数(从考勤企业行事历中取区间,去节、假日);\n",
                          "注:如果开始日期或结束日期的值为空，则返回-9999;如果开始日期大于结束日期,则返回 -1"

       #add by zhangbo131112---begin
       LET l_date[17].name="FN_XZYDATE_B"
       LET l_date[17].des="薪资月开始日期"
       LET l_date[18].name="FN_XZYDATE_E"
       LET l_date[18].des="薪资月结束日期"   

       #add by zhangbo131112---end
       #add by yinbq 20141022 for 添加将字符串转换为日期的函数   
       LET l_date[19].name="FN_TODATE"
       LET l_date[19].des="FN_TODATE(日期字符串)当参数为空时，系统自动设置参数值为19990101"
       #add by yinbq 20141022 for 添加将字符串转换为日期的函数

       #add by yinbq 20141126 for 添加将字符串转换为数值
       LET l_date[20].name="FN_TONUMBER"
       LET l_date[20].des="FN_TONUMBER(数值字符串)当参数为空时，系统自动设置参数值为0"
       #add by yinbq 20141126 for 添加将字符串转换为数值 
                         
       LET l_rec_b=18        #mod by zhangbo131112
       
       CALL cl_set_act_visible("accept,cancel", FALSE)
       DISPLAY ARRAY l_date TO s_fun.* ATTRIBUTE(COUNT=l_rec_b,UNBUFFERED)

       BEFORE ROW
         LET l_ac_date = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf  
 
       ON ACTION accept
         LET l_str=l_date[l_ac_date].name
         LET l_desc=l_date[l_ac_date].des   #add by zhangbo131115
         EXIT DISPLAY
          
       END DISPLAY
       CALL cl_set_act_visible("accept,cancel", TRUE)
       CLOSE WINDOW i078_date
       
       RETURN l_str,l_desc                #add by zhangbo131115

END FUNCTION


FUNCTION getWord()
  DEFINE i ,len INT
  DEFINE l_display_cnt, l_cnt  INT
  DEFINE l_sql STRING

  CALL g_para.clear()
  CALL g_display.clear()

  LET tipString = tipString.toLowerCase()

  LET l_display_cnt = 1

  #get the keywords
  #need 3 columns , name->hred02 , shortcut->hred04, keyword->hred03
  LET l_sql = " SELECT hred02,hred03,hred04 FROM hred_file WHERE hred04 LIKE '%",tipString,"%'  ORDER BY hred01 "

  PREPARE i078_keyword_pre FROM l_sql
  DECLARE i078_keyword CURSOR FOR i078_keyword_pre

  LET l_cnt=1
  FOREACH i078_keyword INTO g_keyword[l_cnt].hred02,g_keyword[l_cnt].hred03,g_keyword[l_cnt].hred04
     LET g_keyword[l_cnt].type = '3'
     LET g_display[l_display_cnt].name = g_keyword[l_cnt].hred02
     LET g_display[l_display_cnt].type = "关键字"     
     LET l_cnt=l_cnt+1
     LET l_display_cnt = l_display_cnt+1
  END FOREACH
  
  IF(l_cnt > 1) THEN
    CALL g_keyword.deleteElement(l_cnt)   
    CALL g_display.deleteElement(l_display_cnt)
  END IF

  #get the parameters
  #need 3 columns , name->hrdh06 , shortcut->hrdh13, para_id->hrdh12
  LET l_sql = " SELECT hrdh06,hrdh12,hrdh13 FROM hrdh_file WHERE hrdh13 LIKE '%",tipString,"%'  ORDER BY hrdh01 "

  PREPARE i078_para_pre FROM l_sql
  DECLARE i078_para CURSOR FOR i078_para_pre

  LET l_cnt=1
  FOREACH i078_para INTO g_para[l_cnt].hrdh06,g_para[l_cnt].hrdh12,g_para[l_cnt].hrdh13
     LET g_para[l_cnt].type = '1'
     LET g_display[l_display_cnt].name = g_para[l_cnt].hrdh06
     LET g_display[l_display_cnt].type    = "参数"     
     LET l_cnt=l_cnt+1
     LET l_display_cnt = l_display_cnt+1
  END FOREACH
  
  IF(l_cnt > 1) THEN
    CALL g_para.deleteElement(l_cnt)   
    CALL g_display.deleteElement(l_display_cnt)
  END IF

  #get the includes
  #need 4 columns ,id->hrdk01,  name->hrdk03 , result->hrdk16, shortcut->hrdk19
  LET l_sql = " SELECT hrdk01,hrdk03,hrdk16,hrdk19 FROM hrdk_file WHERE hrdk19 LIKE '%",tipString,"%'  ORDER BY hrdk01 "

  PREPARE i078_inc_pre FROM l_sql
  DECLARE i078_inc CURSOR FOR i078_inc_pre

  LET l_cnt=1
  FOREACH i078_inc INTO g_inc[l_cnt].hrdk01,g_inc[l_cnt].hrdk03,g_inc[l_cnt].hrdk16,g_inc[l_cnt].hrdk19
     LET g_inc[l_cnt].type = '1'
     LET g_display[l_display_cnt].name = g_inc[l_cnt].hrdk03
     LET g_display[l_display_cnt].type    = "包含项"     
     LET l_cnt=l_cnt+1
     LET l_display_cnt = l_display_cnt+1
  END FOREACH
  
  IF(l_cnt > 1) THEN
    CALL g_inc.deleteElement(l_cnt)   
    CALL g_display.deleteElement(l_display_cnt)
  END IF


  #IF there is nothing to display
  IF(g_display.getLength() == 0) THEN
    LET g_desc = NULL
  ELSE
    #autoselect the first row
    #LET g_desc = "Here is the description for ",g_display[1].name    #mark by zhangbo130909
  END IF 

  DISPLAY g_desc TO description

END FUNCTION

FUNCTION getKey(key) 
  DEFINE l_i INT
  DEFINE key CHAR
  DEFINE l_n STRING 
  DEFINE param_arr DYNAMIC ARRAY OF STRING 

  DEFINE l_hrdh14  LIKE  hrdh_file.hrdh14

  DEFINE l_flag    LIKE  type_file.chr1
  DEFINE l_desc    LIKE  hrdh_file.hrdh11     #add by zhangbo130909

  LET tipString = tipString.append(key)  
  DISPLAY tipString TO keyword

  LET l_flag='N'

  CALL getWord()
  
  CALL cl_set_act_visible("ACCEPT,CANCEL", FALSE)

  DISPLAY ARRAY g_display TO s_para.* ATTRIBUTES(UNBUFFERED) 
    ON KEY (A)
       IF l_flag='N' THEN
          #refresh the tipString and the display array
          LET tipString = tipString.append("a")
          DISPLAY tipString TO keyword
          CALL getWord()
       END IF
       CONTINUE DISPLAY
    ON KEY (B)
       IF l_flag='N' THEN
          LET tipString = tipString.append("b")
          DISPLAY tipString TO keyword
          CALL getWord()
       END IF
       CONTINUE DISPLAY
    ON KEY (C)
       IF l_flag='N' THEN
          LET tipString = tipString.append("c")
          DISPLAY tipString TO keyword
          CALL getWord()
       END IF
       CONTINUE DISPLAY
    ON KEY (D)
       IF l_flag='N' THEN
          LET tipString = tipString.append("d")
          DISPLAY tipString TO keyword
          CALL getWord()
       END IF
       CONTINUE DISPLAY
    ON KEY (E)
       IF l_flag='N' THEN
          LET tipString = tipString.append("e")
          DISPLAY tipString TO keyword
          CALL getWord()
       END IF
       CONTINUE DISPLAY
    ON KEY (F) 
       IF l_flag='N' THEN
          LET tipString = tipString.append("f") 
          DISPLAY tipString TO keyword
          CALL getWord()
       END IF
       CONTINUE DISPLAY
    ON KEY (G)
       IF l_flag='N' THEN
          LET tipString = tipString.append("g")
          DISPLAY tipString TO keyword
          CALL getWord()
       END IF
       CONTINUE DISPLAY
    ON KEY (H)
       IF l_flag='N' THEN
          LET tipString = tipString.append("h")
          DISPLAY tipString TO keyword
          CALL getWord()
       END IF
       CONTINUE DISPLAY
    ON KEY (I)
       IF l_flag='N' THEN
          LET tipString = tipString.append("i")
          DISPLAY tipString TO keyword
          CALL getWord()
       END IF
       CONTINUE DISPLAY
    ON KEY (J)
       IF l_flag='N' THEN
          LET tipString = tipString.append("j")
          DISPLAY tipString TO keyword
          CALL getWord()
       END IF
       CONTINUE DISPLAY
    ON KEY (K)
       IF l_flag='N' THEN
          LET tipString = tipString.append("k")
          DISPLAY tipString TO keyword
          CALL getWord()
       END IF
       CONTINUE DISPLAY
    ON KEY (L)
       IF l_flag='N' THEN
          LET tipString = tipString.append("l")
          DISPLAY tipString TO keyword
          CALL getWord()
       END IF
       CONTINUE DISPLAY
    ON KEY (M)
       IF l_flag='N' THEN
          LET tipString = tipString.append("m")
          DISPLAY tipString TO keyword
          CALL getWord()
       END IF
       CONTINUE DISPLAY
    ON KEY (N)
       IF l_flag='N' THEN
          LET tipString = tipString.append("n")
          DISPLAY tipString TO keyword
          CALL getWord()
       END IF
       CONTINUE DISPLAY
    ON KEY (O)
       IF l_flag='N' THEN
          LET tipString = tipString.append("o")
          DISPLAY tipString TO keyword
          CALL getWord()
       END IF
       CONTINUE DISPLAY
    ON KEY (P)
       IF l_flag='N' THEN
          LET tipString = tipString.append("p")
          DISPLAY tipString TO keyword
          CALL getWord()
       END IF
       CONTINUE DISPLAY
    ON KEY (Q)
       IF l_flag='N' THEN
          LET tipString = tipString.append("q")
          DISPLAY tipString TO keyword
          CALL getWord()
       END IF
       CONTINUE DISPLAY
    ON KEY (R)
       IF l_flag='N' THEN
          LET tipString = tipString.append("r")
          DISPLAY tipString TO keyword
          CALL getWord()
       END IF
       CONTINUE DISPLAY
    ON KEY (S)
       IF l_flag='N' THEN
          LET tipString = tipString.append("s")
          DISPLAY tipString TO keyword
          CALL getWord()
       END IF
       CONTINUE DISPLAY
    ON KEY (T)
       IF l_flag='N' THEN
          LET tipString = tipString.append("t")
          DISPLAY tipString TO keyword
          CALL getWord()
       END IF
       CONTINUE DISPLAY
    ON KEY (U)
       IF l_flag='N' THEN
          LET tipString = tipString.append("u")
          DISPLAY tipString TO keyword
          CALL getWord()
       END IF
       CONTINUE DISPLAY
    ON KEY (V)
       IF l_flag='N' THEN
          LET tipString = tipString.append("v")
          DISPLAY tipString TO keyword
          CALL getWord()
       END IF
       CONTINUE DISPLAY 
    ON KEY (W)
       IF l_flag='N' THEN
          LET tipString = tipString.append("w")
          DISPLAY tipString TO keyword
          CALL getWord()
       END IF
       CONTINUE DISPLAY
    ON KEY (X)
       IF l_flag='N' THEN
          LET tipString = tipString.append("x")
          DISPLAY tipString TO keyword
          CALL getWord()
       END IF
       CONTINUE DISPLAY
    ON KEY (Y)
       IF l_flag='N' THEN
          LET tipString = tipString.append("y")
          DISPLAY tipString TO keyword
          CALL getWord()
       END IF
       CONTINUE DISPLAY
    ON KEY (Z)
       IF l_flag='N' THEN
          LET tipString = tipString.append("z")
          DISPLAY tipString TO keyword
          CALL getWord()
       END IF
       CONTINUE DISPLAY

    #Display the description text
    BEFORE ROW
      #add by zhangbo130909---begin
      LET g_desc=''
      IF(arr_curr() != 0) THEN
        LET l_n = g_display[arr_curr()].name;
        CASE g_display[arr_curr()].type
           WHEN '参数'
              FOR l_i = 1 TO g_para.getLength()
                 IF g_para[l_i].hrdh06 == l_n THEN
                    SELECT hrdh11 INTO l_desc FROM hrdh_file WHERE hrdh12=g_para[l_i].hrdh12
                    LET g_desc=l_desc
                    EXIT FOR
                 END IF
              END FOR  
        END CASE
      END IF   
      #add by zhangbo130909---end
      #LET g_desc = "Here is the description for ",g_display[arr_curr()].name     #mark by zhangbo130909
      DISPLAY g_desc TO description

    ON KEY ('=')
      CALL AddWord("=")
    ON KEY (',')
      CALL AddWord(",")
    ON KEY (';')
      CALL AddWord(";")
    ON KEY ("'")
      CALL AddWord("'")
    ON KEY ('+')
      CALL AddWord("+")
    ON KEY ('-')
      CALL AddWord("-")
    ON KEY ('*')
      CALL AddWord("*")
    ON KEY ('/')
      CALL AddWord("/")

    ON KEY (SPACE)
      CALL AddWord(" ")

    ON ACTION b_SPACE
      CALL AddWord(" ")
    
    ON ACTION b_BACKSPACE
      CALL BACKSPACE()


    ON KEY (BACKSPACE)
      IF l_flag='N' THEN 
        IF tipString.getLength() > 1 THEN
           LET tipString = tipString.subString(1,tipString.getLength()-1)
           DISPLAY tipString TO keyword
           CALL getWord()
        ELSE 
           LET tipString = null
           DISPLAY tipString TO keyword
           LET g_desc = null
           DISPLAY g_desc TO description
	   CALL g_display.clear()
           CALL g_para.clear()
           EXIT DISPLAY
        END IF
      ELSE
        CALL BACKSPACE()
      END IF

    #operation
    #ON ACTION b_equal     #mark by zhangbo130906
    ON ACTION 逻辑等于     #add by zhangbo130906
      CALL AddWord("=")
    #ON ACTION b_equals    #mark by zhangbo130906
    ON ACTION 赋值等于     #add by zhangbo130906 
      CALL AddWord(":=")   
    #add by zhangbo130906---begin
    ON ACTION 不等于
      CALL AddWord("<>")
    #add by zhangbo130906---end
    ON ACTION b_more
      CALL AddWord(">")
    ON ACTION b_less
      CALL AddWord("<")

    ON ACTION ACCEPT
      IF(arr_curr() != 0) THEN 
        LET l_n = g_display[arr_curr()].name;
        CASE g_display[arr_curr()].type
          WHEN '关键字'
            FOR l_i = 1 TO g_keyword.getLength()
              IF g_keyword[l_i].hred02 == l_n THEN
                CALL AddWord2(g_keyword[l_i].hred02,g_keyword[l_i].hred03,g_display[arr_curr()].type)
                EXIT FOR
              END IF
            END FOR
          WHEN '参数' 
            FOR l_i = 1 TO g_para.getLength()
              IF g_para[l_i].hrdh06 == l_n THEN
                CALL AddWord2(g_para[l_i].hrdh06,g_para[l_i].hrdh12,g_display[arr_curr()].type)
                #IF param.hasValue
                LET l_hrdh14=''
                SELECT hrdh14 INTO l_hrdh14 FROM hrdh_file WHERE hrdh12=g_para[l_i].hrdh12
                IF l_hrdh14='Y' THEN
                   LET l_flag='Y'
                   CALL GetParamValue(g_para[l_i].hrdh12)
                ELSE
                   LET l_flag='N'
                   CALL g_value.clear() 
                END IF
                #ELSE
                #g_value.clear()
                EXIT FOR
              END IF
            END FOR
          WHEN '参数值' 
            FOR l_i = 1 TO g_value.getLength()
              IF g_value[l_i].hrag07 == l_n THEN
                CALL AddWord2(g_value[l_i].hrag07,g_value[l_i].hrag06,g_display[arr_curr()].type)
                CALL g_value.clear()
                EXIT FOR
              END IF
            END FOR
         WHEN '包含项'
            FOR l_i = 1 TO g_inc.getLength()
              IF g_inc[l_i].hrdk03 == l_n THEN
                CALL AddWord2(g_inc[l_i].hrdk03,g_inc[l_i].hrdk16,g_display[arr_curr()].type)
                EXIT FOR
              END IF
            END FOR
      
        END CASE
      END IF

      CALL g_para.clear()
      LET tipString = NULL
      DISPLAY tipString TO keyword
     
      LET g_desc = NULL
      DISPLAY g_desc TO description

      IF g_value.getLength() == 0 THEN
        CALL g_display.clear()
        EXIT DISPLAY
      ELSE
        CONTINUE DISPLAY
      END IF

    ON ACTION CANCEL
      CALL g_display.clear()
      CALL g_para.clear()
      CALL g_value.clear()
      LET tipString = NULL
      DISPLAY tipString TO keyword
      LET g_desc = NULL
      DISPLAY g_desc TO description
      EXIT DISPLAY
  END DISPLAY
  
  CALL cl_set_act_visible("ACCEPT,CANCEL", TRUE)

END FUNCTION

FUNCTION GetParamValue(p_hrdh12)
  DEFINE l_display_cnt,l_cnt INT
  DEFINE l_id,l_sql STRING
  DEFINE p_hrdh12   LIKE  hrdh_file.hrdh12 
  DEFINE l_hrdh15   LIKE  hrdh_file.hrdh15

  CALL g_display.clear()

  LET l_display_cnt = 1

  #get the value of the param
  #LET l_sql = " SELECT hrag06,hrag07 FROM hrag_file WHERE hrag01 = '",l_id,"'  ORDER BY hrag05 "

  SELECT hrdh15 INTO l_hrdh15 FROM hrdh_file WHERE hrdh12=p_hrdh12

  IF NOT cl_null(l_hrdh15) THEN
     LET l_sql=l_hrdh15
     PREPARE i078_value_pre FROM l_sql
     DECLARE i078_value CURSOR FOR i078_value_pre

     LET l_cnt=1
     FOREACH i078_value INTO g_value[l_cnt].hrag06,g_value[l_cnt].hrag07
        LET g_value[l_cnt].type = '2'
        LET g_display[l_display_cnt].name = g_value[l_cnt].hrag07
        LET g_display[l_display_cnt].type = "参数值"     
        LET l_cnt=l_cnt+1
        LET l_display_cnt = l_display_cnt+1
     END FOREACH
  
     IF(l_cnt > 1) THEN
       CALL g_keyword.deleteElement(l_cnt)   
       CALL g_display.deleteElement(l_display_cnt)
     END IF
  END IF
END FUNCTION




FUNCTION Init()

  DEFINE i INT
  DEFINE l_i INT
  DEFINE l_n INT
  DEFINE l_sql   STRING
  DEFINE n om.DomDocument
  DEFINE node om.DomNode
  DEFINE list om.NodeList
  DEFINE l_s STRING

  LET n = ui.Interface.getDocument()
  LET node = n.getDocumentElement()

  LET list = node.selectByTagName("TextEdit")
  LET node = list.item(1)

  LET DW.s_ln   = 1 
  LET DW.height = node.getAttribute("gridHeight")

  LET mywin = ui.Window.getCurrent()
  LET myform = mywin.getForm()
  
  #CALL drawSelect("editor")
  #CALL drawSetFontSize(5)

  LET LineSpace = 100
  #the width of a character
  #a chinese word may occupy 2 * WordWidth
  LET WordWidth = 15
  #LET g_id = 1
  LET startX = 0
  LET startY = 900
  LET offsetX = 0
  LET offsetY = 0

  LET l_sql=" SELECT hrdka03,hrdka04,hrdka05,hrdka06,hrdka07,hrdka08,hrdka09,hrdka10,hrdka11,hrdka12 ",
            "   FROM hrdka_file ",
            "  WHERE hrdka01='",g_argv1,"' ",
            "  ORDER BY hrdka01,hrdka02 "

  PREPARE hrdka_pre FROM l_sql
  DECLARE hrdka_cs CURSOR FOR hrdka_pre

  LET l_i=1

  FOREACH hrdka_cs INTO Formula[l_i].*
     
     LET l_i=l_i+1

  END FOREACH

#  CALL Formula.deleteElement(l_i)

#  LET l_i=l_i-1

  IF l_i>1 THEN
     LET Formula[l_i].id = 0
     LET Formula[l_i].mark = "cur"
     LET Formula[l_i].context = "|"
     LET Formula[l_i].lineNumber = Formula[l_i-1].lineNumber
     LET Formula[l_i].length = Formula[l_i-1].length + 1 
     LET Formula[l_i].beginX = 1
     LET Formula[l_i].beginY = 1
     LET Formula[l_i].endX   = 1
     LET Formula[l_i].endY   = 1
   
#     LET g_id=Formula[l_i].id+1
     LET myCursor.Pos=Formula[l_i].length
     LET myCursor.Ln=Formula[l_i].lineNumber
  ELSE
     LET Formula[l_i].id = 0
     LET Formula[l_i].mark = "cur"
     LET Formula[l_i].context = "|"
     LET Formula[l_i].lineNumber =1 
     LET Formula[l_i].length =1 
     LET Formula[l_i].beginX = 1
     LET Formula[l_i].beginY = 1
     LET Formula[l_i].endX   = 1
     LET Formula[l_i].endY   = 1
#     LET g_id=1
     LET myCursor.Pos = 1
     LET myCursor.Ln = 1
  END IF

  #LET DW.s_ln   = myCursor.Ln-DW.height+1
  #IF DW.s_ln<1 THEN
  #   LET DW.s_ln=1
  #END IF
     

#  LET myCursor.CursorHeight = 80
#  LET myCursor.CursorWidth = 5
#  LET myCursor.CursorPosX = 0
#  LET myCursor.CursorPosY = 900
#  #LET myCursor.Pos = 1
#  #LET myCursor.Ln = 1
#
#
#  LET i = l_i+1
#  CALL Formula.insertElement(i)
#  LET Formula[i].id = 0
#  LET Formula[i].mark = " "
#  LET Formula[i].context = " "
#  LET Formula[i].lineNumber =myCursor.Ln 
#  LET Formula[i].beginX = startX + offsetX
#  LET Formula[i].beginY = startY + offsetY
#  LET Formula[i].endX   = Formula[i].beginX + WordWidth
#  LET Formula[i].endY   = Formula[i].beginY - LineSpace

    
  CALL DrawCursor()

END FUNCTION

FUNCTION AddWord2(ct,mk,tp)
  DEFINE ct,mk STRING
  DEFINE tp    STRING
  DEFINE len , i, t  INT
  DEFINE ln   INT    
  DEFINE b_x,b_y,e_x,e_y INT
  DEFINE width INT
DEFINE l_n1,l_n LIKE type_file.num5   

  LET i = myCursor.Pos
  LET ln = Formula[i].lineNumber
  LET b_x = Formula[i].beginX 
  LET b_y = Formula[i].beginY
  LET e_x = b_x + len * WordWidth
  LET e_y = Formula[i].endY
  LET width = e_x - b_x

#  CALL Formula.insertElement(i)
#  LET Formula[i].id = g_id
#  LET g_id = g_id + 1
#  LET Formula[i].mark = mk            
#  LET Formula[i].context = ct   
#  IF Formula[i].mark="RESULT" THEN       #add by zhangbo130821
#     LET Formula[i].mark=g_hrdk.hrdk16   #add by zhangbo130821 
#  END IF                                 #add by zhangbo130821
#  LET Formula[i].lineNumber = ln
#  LET Formula[i].length = 0 
#  LET Formula[i].beginX = b_x
#  LET Formula[i].beginY = b_y
#  LET Formula[i].endX   = e_x
#  LET Formula[i].endY   = e_y
#  LET Formula[i].type = tp

   LET l_n1 = Formula.getLength()
   FOR l_n = 1 TO l_n1
      IF Formula[l_n].lineNumber = myCursor.Ln THEN
         IF Formula[l_n].mark = "cur" THEN 
            CALL Formula.insertElement(l_n)
            LET Formula[l_n].* = Formula[l_n + 1].*
            LET Formula[l_n].mark = mk
            IF Formula[l_n].mark="RESULT" THEN 
               LET Formula[l_n].mark=g_hrdk.hrdk16
            END IF 
            LET Formula[l_n].context = ct
            LET Formula[l_n].type = tp
            LET l_n=l_n + 1
#            LET l_n1=l_n1 + 1
            LET Formula[l_n].length = Formula[l_n].length + 1
            LET myCursor.Pos = myCursor.Pos + 1
         ELSE
            IF Formula[l_n].length >= myCursor.Pos THEN 
               LET Formula[l_n].length = Formula[l_n].length + 1
            END IF 
         END IF
      END IF 
   END FOR
   LET l_n1 = Formula.getLength()
   CALL Formula.deleteElement(l_n1)
  ##IF the text is out of range,move the display window
  #IF( e_x > DW.offsetX + DW.width) THEN
  #  LET DW.offsetX = e_x - DW.width
  #END IF
  #
  ##Move the words after the inserted in the same line
  #FOR t = i + 1 TO Formula.getLength()
  #  IF(Formula[t].lineNumber != ln) THEN
  #    EXIT FOR
  #  ELSE
  #    LET Formula[t].beginX = Formula[t].beginX + width
  #    LET Formula[t].endX = Formula[t].endX + width
  #  END IF
  #END FOR

  CALL CursorMoveRight()
  #CALL RePaint()

END FUNCTION

FUNCTION AddWord(word)
  DEFINE word STRING 
  DEFINE ct   STRING 
  DEFINE ln   INT    
  DEFINE wc   INT    
  DEFINE b_x,b_y,e_x,e_y INT
  DEFINE width INT
  DEFINE i,t   INT 
DEFINE l_n1,l_n LIKE type_file.num5    

  LET wc = 1

  CASE word
    WHEN "IF"
      LET ct = "如果"
    WHEN "THEN"
      LET ct = "那么"
    WHEN "RESULT"
      LET word=g_hrdk.hrdk16
      LET ct="结果"
    WHEN "ELSE"
      LET ct = "否则"
    WHEN "END IF"
      LET ct = "结束"

    #number
    WHEN "0"
      LET ct = "0"
    WHEN "1"
      LET ct = "1"
    WHEN "2"
      LET ct = "2"
    WHEN "3"
      LET ct = "3"
    WHEN "4"
      LET ct = "4"
    WHEN "5"
      LET ct = "5"
    WHEN "6"
      LET ct = "6"
    WHEN "7"
      LET ct = "7"
    WHEN "8"
      LET ct = "8"
    WHEN "9"
      LET ct = "9"

    #operation
    WHEN "+"
      LET ct = "+"
    WHEN "-"
      LET ct = "-"
    WHEN "*"
      LET ct = "*"
    WHEN "/"
      LET ct = "/"
   WHEN "'"
      LET ct = "'"
   WHEN ","
      LET ct = ","
   WHEN ";"
      LET ct = ";"
    WHEN "="
      LET ct = "="
    WHEN ":="
      LET ct = ":="
    WHEN "<"
      LET ct = "<"
    WHEN ">"
      LET ct = ">"
    WHEN " "
      LET ct = " "
      
   #add by zhangbo130913---begin
   WHEN "取上月值"
      LET ct = "取上月值"
      LET word = "FN_GETLASTVALUE"
   
   #add by zhangbo130913---end

   #add by zhangbo131112---begin
   WHEN "取累计值"
      LET ct = "取累计值"
      LET word = "FN_GETSUM"
   #add by zhangbo131112---end

   OTHERWISE
      LET ct=word
      #EXIT PROGRAM
  END CASE


   
   LET l_n1 = Formula.getLength()
   FOR l_n = 1 TO l_n1
      IF Formula[l_n].lineNumber = myCursor.Ln THEN
         IF Formula[l_n].mark = "cur" THEN 
            CALL Formula.insertElement(l_n)
            LET Formula[l_n].* = Formula[l_n + 1].*
            LET Formula[l_n].mark = word
            LET Formula[l_n].context = ct
            LET l_n=l_n + 1
#            LET l_n1=l_n1 + 1
            LET Formula[l_n].length = Formula[l_n].length + 1
            LET myCursor.Pos = myCursor.Pos + 1
         ELSE
            IF Formula[l_n].length >= myCursor.Pos THEN 
               LET Formula[l_n].length = Formula[l_n].length + 1
            END IF 
         END IF
      END IF 
   END FOR
   LET l_n1 = Formula.getLength()
   CALL Formula.deleteElement(l_n1)
#   LET myCursor.Pos = 1
#   LET myCursor.Ln = myCursor.Ln + 1
#
#  #FOR i = 1 TO Formula.getLength()
#  #  IF(myCursor.Pos==i) THEN
#      LET i=myCursor.Pos
#      LET ln = Formula[i].lineNumber
#      LET b_x = Formula[i].beginX
#      LET b_y = Formula[i].beginY
#      LET e_x = b_x + wc * WordWidth
#      LET e_y = Formula[i].endY
#      LET width = e_x - b_x
#
#  
#      CALL Formula.insertElement(i)
#      LET Formula[i].id = g_id
#      LET g_id = g_id + 1
#      LET Formula[i].mark = word
#      LET Formula[i].context = ct
#      LET Formula[i].length  = wc
#      LET Formula[i].lineNumber = ln
#      LET Formula[i].beginX = b_x
#      LET Formula[i].beginY = b_y
#      LET Formula[i].endX   = e_x
#      LET Formula[i].endY   = e_y

      ##IF the text is out of range,move the display window
      #IF( e_x > DW.offsetX + DW.width) THEN
      #  LET DW.offsetX = e_x - DW.width
      #END IF

      ##Move the words after the inserted in the same line
      #FOR t = i + 1 TO Formula.getLength()
      #  IF(Formula[t].lineNumber != ln) THEN
      #    EXIT FOR
      #  ELSE
      #    LET Formula[t].beginX = Formula[t].beginX + width
      #    LET Formula[t].endX = Formula[t].endX + width
      #  END IF
      #END FOR

      #CALL RePaint()

     
      CALL DrawCursor()

      #EXIT FOR
  #  ELSE
  #    CONTINUE FOR
  #  END IF

  #END FOR

END FUNCTION



FUNCTION DrawCursor()
  DEFINE cid,x,y INTEGER
  DEFINE l_i,ln,pos  INTEGER
  DEFINE l_str1,l_str2 STRING 

  #CALL DrawClear()
  #CALL DrawFillColor("black")
  #CALL DrawLineWidth(myCursor.CursorWidth)
 
  #LET x = myCursor.CursorPosX
  #LET y = myCursor.CursorPosY

  ##cursor is out of the range of X or Y axis
  #IF( x < DW.offsetX ) THEN
  #  LET DW.offsetX = x
  #END IF
  #IF( x > DW.offsetX + DW.width ) THEN
  #  LET DW.offsetX = x - DW.width  
  #END IF
  #IF( y < DW.offsetY ) THEN
  #  LET DW.offsetY = y
  #END IF
  #IF( y >  DW.offsetY + DW.height ) THEN
  #  LET DW.offsetY = y - DW.height
  #END IF
    
  ##cursor in the display window
  #IF( x >= DW.offsetX AND x <= DW.offsetX + DW.width
  #  AND y >= DW.offsetY AND y <= DW.offsetY + DW.height) THEN
  #  LET cid = DrawLine(y - DW.offsetY,x - DW.offsetX,myCursor.CursorHeight,0)
  #
  #ELSE 
  #  
  #END IF

  
  #IF myCursor.Pos != Formula.getLength() THEN  
  ##draw the syntax tips   
  ##LET cid = DrawRectangle(myCursor.CursorPosY,myCursor.CursorPosX-40,20,20)
  #                        #Formula[myCursor.Pos].beginY - Formula[myCursor.Pos].endY,
  #                        #Formula[myCursor.Pos].endX - Formula[myCursor.Pos].beginX) 
  #END IF 
  
  LET ln=myCursor.Ln
  LET pos=myCursor.Pos
  LET g_str=''
  LET l_str1=''
  LET l_str2=''
  
  #数组大于一行,表示画面有输入,否则没有输入,那么游标位置为1
#  IF Formula.getLength()>1 THEN
#     #游标在中间位置
#     IF Formula.getLength()-1>=pos THEN
#        FOR l_i=1 TO pos-1
#          IF Formula[l_i].lineNumber >= DW.s_ln THEN
#  	    IF Formula[l_i].id=0 THEN
#              LET Formula[l_i].context="\n"
#            END IF
#  	    LET l_str1=l_str1,Formula[l_i].context
#          END IF
#  	END FOR
  	
  	FOR l_i=1 TO Formula.getLength()
#  	   IF l_i > 1 THEN 
#  	      IF Formula[l_i].lineNumber != Formula[l_i-1].lineNumber THEN 
#  	         LET g_str = g_str , "\n"
#  	      END IF 
#  	   END IF 
  	   LET g_str = g_str , Formula[l_i].context
#  	   IF Formula[l_i].lineNumber <= DW.s_ln + DW.height THEN
#  	    IF Formula[l_i].id=0 THEN
#               LET Formula[l_i].context="\n"
#            END IF
#  	    LET l_str2=l_str2,Formula[l_i].context
#          END IF
   END FOR
#  	#以"|"代替游标
#  	LET g_str=l_str1,"|",l_str2 
#     #游标在最后   
#     ELSE
#       FOR l_i=1 TO Formula.getLength()-1
#         IF Formula[l_i].lineNumber >= DW.s_ln THEN
#  	   IF Formula[l_i].id=0 THEN
#             LET Formula[l_i].context="\n"
#           END IF
#  	   LET l_str1=l_str1,Formula[l_i].context
#         END IF
#       END FOR
#  	    
#       LET g_str=l_str1,"|"
#     END IF
#  #数组为1行,表示没有输入
#  ELSE
#     LET g_str="|"
#  END IF
  	
  DISPLAY g_str TO hrdk15
  DISPLAY myCursor.Ln TO c_ln
  DISPLAY Formula[Formula.getLength()].lineNumber TO t_ln
  
END FUNCTION


FUNCTION CursorMoveLeft()
DEFINE l_n1,l_n LIKE type_file.num5 
DEFINE l_Ln,l_Pos LIKE type_file.num5 
   
   LET l_n1 = Formula.getLength()
   LET l_Ln = myCursor.Ln
   LET l_Pos = myCursor.Pos
   
   IF myCursor.Ln = 1 AND myCursor.Pos = 1 THEN 
   ELSE 
      FOR l_n = l_n1 TO 2 STEP -1
         IF Formula[l_n].mark = "cur" THEN 
            IF Formula[l_n-1].lineNumber = l_Ln THEN 
               LET Formula_t[1].* = Formula[l_n].*
               LET Formula[l_n].* = Formula[l_n-1].*
               LET Formula[l_n].length = Formula[l_n].length + 1
               LET Formula[l_n-1].* = Formula_t[1].*
               LET Formula[l_n-1].length = Formula[l_n-1].length - 1
      LET myCursor.Pos = Formula[l_n-1].length
      LET myCursor.Ln = l_Ln
               EXIT FOR 
            ELSE 
               LET Formula[l_n].length = Formula[l_n-1].length + 1
               LET Formula[l_n].lineNumber = l_Ln - 1
      LET myCursor.Pos = Formula[l_n].length
      LET myCursor.Ln = l_Ln - 1
               EXIT FOR 
            END IF 
         ELSE 
            IF Formula[l_n].lineNumber = l_Ln AND l_Pos = 1 THEN 
               LET Formula[l_n].length = Formula[l_n].length - 1
            ELSE 
               IF Formula[l_n].lineNumber < l_Ln  THEN 
                  EXIT FOR 
               END IF 
            END IF 
         END IF 
      END FOR
   END IF 
#  DEFINE i INT
#
#  #CALL DrawFillColor("black")
#
#  LET i = myCursor.Pos
#
#  IF(i == 1) THEN
#  ELSE
#    #LET myCursor.CursorPosX = Formula[i-1].beginX
#    #LET myCursor.CursorPosY = Formula[i-1].beginY
#    LET myCursor.Ln         = Formula[i-1].lineNumber
#    LET myCursor.Pos = myCursor.Pos - 1
#  END IF
#
#  IF(myCursor.Ln == (DW.s_ln - 1)) THEN
#    LET DW.s_ln = myCursor.Ln 
#  END IF

  CALL DrawCursor()
  #CALL RePaint()


END FUNCTION

FUNCTION CursorMoveUp()
DEFINE l_n1,l_n LIKE type_file.num5 

   IF myCursor.Ln = 1 THEN 
   ELSE 
      LET l_n1 = Formula.getLength()
      FOR l_n = l_n1 TO 2 STEP -1
         IF Formula[l_n].lineNumber = myCursor.Ln THEN
            IF Formula[l_n].length > myCursor.Pos THEN 
               LET Formula[l_n].length = Formula[l_n].length - 1
            ELSE 
               IF Formula[l_n].mark = "cur" THEN 
                  IF Formula[l_n].length > 1 THEN 
                     LET Formula_t[1].* = Formula[l_n].*
                     LET Formula[l_n].* = Formula[l_n-1].*
                     LET Formula[l_n-1].* = Formula_t[1].*
                     LET Formula[l_n-1].length = Formula[l_n-1].length - 1
                  ELSE 
                     LET Formula_t[1].* = Formula[l_n].*
                     LET Formula[l_n].* = Formula[l_n-1].*
                     LET Formula[l_n-1].* = Formula_t[1].*
                     LET Formula[l_n-1].lineNumber = Formula[l_n].lineNumber
                     LET Formula[l_n-1].length = Formula[l_n].length
                     LET Formula[l_n].length = Formula[l_n].length + 1
                  END IF 
               END IF
            END IF 
         ELSE 
            IF Formula[l_n].lineNumber = myCursor.Ln - 1 THEN
               IF Formula[l_n].length > 1 THEN
                  LET Formula_t[1].* = Formula[l_n].*
                  LET Formula[l_n].* = Formula[l_n-1].*
                  LET Formula[l_n].length = Formula[l_n].length + 1
                  LET Formula[l_n-1].* = Formula_t[1].*
                  LET Formula[l_n-1].length = Formula[l_n-1].length - 1
               ELSE 
                  EXIT FOR 
               END IF 
            ELSE 
               IF Formula[l_n].lineNumber < myCursor.Ln - 1 THEN
                  EXIT FOR
               END IF 
            END IF 
         END IF 
      END FOR
      LET myCursor.Pos = 1
      LET myCursor.Ln = myCursor.Ln - 1
   END IF 
#  DEFINE i ,t , cl INT
#
#  #CALL DrawFillColor("black")
#
#  LET i = myCursor.Pos
#
#  #IF on the top ,move the display window
#  IF(myCursor.Ln == DW.s_ln) THEN
#    IF(DW.s_ln > 1) THEN
#      LET DW.s_ln = DW.s_ln - 1
#    END IF
#  END IF
#
#  LET cl = Formula[i].lineNumber  
#  IF(cl == 1) THEN
#  ELSE     
#    FOR t = i TO 1 STEP -1
#      IF(Formula[t].lineNumber = cl - 2) THEN
#        #LET myCursor.CursorPosX = Formula[t+1].beginX
#        #LET myCursor.CursorPosY = Formula[t+1].beginY
#        LET myCursor.Ln         = Formula[t+1].lineNumber
#        LET myCursor.Pos        = t + 1
#        EXIT FOR
#      END IF               
#    END FOR 
#    IF(t == 0) THEN
#        #LET myCursor.CursorPosX = Formula[1].beginX
#        #LET myCursor.CursorPosY = Formula[1].beginY
#        LET myCursor.Ln         = Formula[1].lineNumber
#        LET myCursor.Pos        = 1    
#    END IF    
#  END IF           


  CALL DrawCursor()
  #CALL RePaint()
  
END FUNCTION

FUNCTION CursorMoveDown()
DEFINE l_n1,l_n LIKE type_file.num5 
   
   LET l_n1 = Formula.getLength()
   IF myCursor.Ln = Formula[l_n1].lineNumber THEN 
   ELSE 
      FOR l_n = 1 TO l_n1
         IF Formula[l_n].lineNumber = myCursor.Ln THEN
            IF Formula[l_n].mark = "cur" THEN 
               IF Formula[l_n].lineNumber = Formula[l_n+1].lineNumber THEN 
                  LET Formula_t[1].* = Formula[l_n].*
                  LET Formula[l_n].* = Formula[l_n+1].*
                  LET Formula[l_n].length = Formula[l_n].length - 1
                  LET Formula[l_n+1].* = Formula_t[1].*
                  LET Formula[l_n+1].length = Formula[l_n+1].length + 1
               ELSE 
                  LET Formula[l_n].lineNumber = Formula[l_n].lineNumber+1
                  LET Formula[l_n].length = 1
               END IF 
            END IF
         ELSE 
            IF Formula[l_n].lineNumber = myCursor.Ln + 1 THEN
               LET Formula[l_n].length = Formula[l_n].length + 1
            ELSE 
               IF Formula[l_n].lineNumber > myCursor.Ln + 1 THEN
                  EXIT FOR
               END IF 
            END IF 
         END IF 
      END FOR
      LET myCursor.Pos = 1
      LET myCursor.Ln = myCursor.Ln + 1
   END IF 

#  DEFINE i ,t , cl INT
#
#  #CALL DrawFillColor("black")
#
#  LET i = myCursor.Pos
#
#  #IF on the bottom ,move the display window
#  IF(myCursor.Ln == DW.s_ln + DW.height) THEN
#    IF(DW.s_ln < Formula[Formula.getLength()].lineNumber) THEN
#      LET DW.s_ln = DW.s_ln + 1
#    END IF
#  END IF
#
#  LET cl = Formula[i].lineNumber  
#  IF(cl == Formula[Formula.getLength()].lineNumber) THEN
#  ELSE     
#    FOR t = i TO Formula.getLength()
#      IF(Formula[t].lineNumber = cl + 1) THEN
#        #LET myCursor.CursorPosX = Formula[t].beginX
#        #LET myCursor.CursorPosY = Formula[t].beginY
#        LET myCursor.Ln         = Formula[t].lineNumber
#        LET myCursor.Pos        = t 
#        EXIT FOR
#      END IF               
#    END FOR   
#  END IF           

  CALL DrawCursor()
  #CALL RePaint()
  
END FUNCTION


FUNCTION CursorMoveRight()
DEFINE l_n1,l_n LIKE type_file.num5 
DEFINE l_Ln,l_Pos LIKE type_file.num5 
   
   LET l_n1 = Formula.getLength()
   LET l_Ln = myCursor.Ln
   LET l_Pos = myCursor.Pos
   IF l_Ln = Formula[l_n1].lineNumber AND l_Pos = Formula[l_n1].length THEN 
   ELSE 
      FOR l_n = 1 TO l_n1
         IF Formula[l_n].mark = "cur" THEN 
            IF Formula[l_n+1].lineNumber = l_Ln THEN 
               LET Formula_t[1].* = Formula[l_n].*
               LET Formula[l_n].* = Formula[l_n+1].*
               LET Formula[l_n].length = Formula[l_n].length - 1
               LET Formula[l_n+1].* = Formula_t[1].*
               LET Formula[l_n+1].length = Formula[l_n+1].length + 1
      LET myCursor.Pos = Formula[l_n+1].length
      LET myCursor.Ln = l_Ln
               EXIT FOR 
            ELSE 
               LET Formula[l_n].length = 1
               LET Formula[l_n].lineNumber = l_Ln + 1
      LET myCursor.Pos = 1
      LET myCursor.Ln = l_Ln + 1
            END IF 
         ELSE 
            IF Formula[l_n].lineNumber = l_Ln + 1 THEN 
               LET Formula[l_n].length = Formula[l_n].length + 1
            ELSE 
               IF Formula[l_n].lineNumber > l_Ln + 1 THEN 
                  EXIT FOR 
               END IF 
            END IF 
         END IF 
      END FOR
   END IF 
#  DEFINE i INT
#
#  #CALL DrawFillColor("black")
#
#  LET i = myCursor.Pos 
#
#  IF(i == Formula.getLength()) THEN
#  ELSE
#    #LET myCursor.CursorPosX = Formula[i+1].beginX
#    #LET myCursor.CursorPosY = Formula[i+1].beginY
#    LET myCursor.Ln         = Formula[i+1].lineNumber
#    LET myCursor.Pos = myCursor.Pos + 1
#  END IF
#
#  IF(myCursor.Ln == (DW.s_ln + DW.height + 1)) THEN
#    LET DW.s_ln = myCursor.Ln 
#  END IF
  
  CALL DrawCursor()
  #CALL RePaint()


END FUNCTION

{
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
}

FUNCTION CursorWrap()
  DEFINE pos,x,y,i,id,ln,width INTEGER
DEFINE l_n1,l_n,l_Ln,l_Pos LIKE type_file.num5 

   LET l_n1 = Formula.getLength()
   LET l_Ln = myCursor.Ln
   LET l_Pos = myCursor.Pos
   FOR l_n = 1 TO l_n1+1
      IF Formula[l_n].lineNumber = l_Ln THEN
         IF Formula[l_n].mark = "cur" THEN 
            CALL Formula.insertElement(l_n)
            LET Formula[l_n].* = Formula[l_n + 1].*
            LET Formula[l_n].mark = "\n"
            LET Formula[l_n].context = "\n"
            LET l_n=l_n + 1
            LET Formula[l_n].length = 1
            LET Formula[l_n].lineNumber = myCursor.Ln + 1
#            LET l_n1=l_n1 + 1
            LET myCursor.Pos = 1
            LET myCursor.Ln = l_Ln + 1
         ELSE
            IF Formula[l_n].length >= l_Pos THEN 
               LET Formula[l_n].length = Formula[l_n - 1].length + 1
               LET Formula[l_n].lineNumber = Formula[l_n - 1].lineNumber
            END IF 
         END IF
      ELSE 
         IF Formula[l_n].lineNumber > l_Ln THEN
            LET Formula[l_n].lineNumber = Formula[l_n].lineNumber + 1
         END IF 
      END IF 
   END FOR
   
   
   
   
#
#  #insert an blank element at the current position 
#  LET pos = myCursor.Pos
#  CALL Formula.insertElement(pos)
#  LET Formula[pos].id = 0
#  LET Formula[pos].mark = "\n"
#  LET Formula[pos].context = "\n"
#  LET Formula[pos].lineNumber = myCursor.Ln
#  LET Formula[pos].beginX = myCursor.CursorPosX
#  LET Formula[pos].beginY = myCursor.CursorPosY#startY + offsetY - (myCursor.Ln - 1) * LineSpace
#  LET Formula[pos].endX   = Formula[pos].beginX + WordWidth
#  LET Formula[pos].endY   = Formula[pos].beginY - LineSpace
#  
# 
#  
#  #and wrap the word after that
#  LET ln = myCursor.Ln
#  FOR i = myCursor.Pos + 1 TO Formula.getLength()
#    LET Formula[i].lineNumber = Formula[i].lineNumber + 1
#    IF(Formula[i].lineNumber = ln + 1) THEN
#      LET ln = ln + 1
#      LET x = 0;
#      LET y = Formula[i].beginY - LineSpace
#    ELSE
#      LET x = x + width
#    END IF
#    LET width = Formula[i].endX - Formula[i].beginX
#    LET Formula[i].beginX = startX + offsetX + x
#    LET Formula[i].beginY = y
#    LET Formula[i].endX   = Formula[i].beginX + width
#    LET Formula[i].endY   = Formula[i].beginY - LineSpace
#  END FOR
#
#  #Set the cursor to the next line
#  LET myCursor.Pos = myCursor.Pos + 1
#  LET myCursor.Ln = myCursor.Ln + 1
#  LET myCursor.CursorPosX = startX + offsetX
#  LET myCursor.CursorPosY = startY + offsetY - (myCursor.Ln - 1) * LineSpace 
#
#  #out of the display window
#  IF myCursor.Ln >= DW.s_ln + DW.height THEN
#    LET DW.s_ln = DW.s_ln + 1
#  END IF

  CALL DrawCursor()
  #CALL RePaint()


END FUNCTION

FUNCTION BACKSPACE()
DEFINE l_n1,l_n LIKE type_file.num5 
DEFINE l_Ln,l_Pos LIKE type_file.num5 
   
   LET l_n1 = Formula.getLength()
   LET l_Ln = myCursor.Ln
   LET l_Pos = myCursor.Pos
   
   IF myCursor.Ln = 1 AND myCursor.Pos = 1 THEN 
   ELSE 
      FOR l_n = 1 TO l_n1-1
         IF Formula[l_n].mark = "cur" THEN 
            LET Formula[l_n].length = Formula[l_n-1].length
            LET Formula[l_n].lineNumber = Formula[l_n-1].lineNumber
            LET Formula[l_n-1].* = Formula[l_n].*
            CALL Formula.deleteElement(l_n)
            LET myCursor.Pos = Formula[l_n-1].length
            LET myCursor.Ln = Formula[l_n-1].lineNumber
         ELSE 
            IF Formula[l_n].lineNumber = l_Ln THEN 
               IF l_Pos = 1 THEN 
                  LET Formula[l_n].length = Formula[l_n-1].length + 1
                  LET Formula[l_n].lineNumber = l_Ln - 1
               ELSE 
                  IF Formula[l_n].length > l_Pos THEN 
                     LET Formula[l_n].length = Formula[l_n].length - 1
                  END IF 
               END IF 
            END IF 
         END IF 
      END FOR
   END IF 
#
#
#  DEFINE i,ln,x,y,width INT
#
#  IF myCursor.Pos != 1 THEN
#
#    #put the current word at the position of the word to be deleted
#    LET i = myCursor.Pos
#    LET x = Formula[i - 1].beginX
#    LET y = Formula[i - 1].beginY
#    LET width = Formula[i].endX - Formula[i].beginX
#    LET Formula[i].beginX = x
#    LET Formula[i].endX = x + width
#    LET Formula[i].beginY = y
#    LET Formula[i].endY = Formula[i-1].endY
#    LET Formula[i].lineNumber = Formula[i-1].lineNumber
#    
#    LET ln = Formula[i-1].lineNumber
#
#    #set the position of the word in the same line of the current word     
#    IF(Formula[i].lineNumber == ln) THEN
#      FOR i = myCursor.Pos + 1 TO Formula.getLength()
#        IF(Formula[i].lineNumber == ln) THEN            
#          LET x = Formula[i - 1].endX
#          LET y = Formula[i - 1].beginY
#          LET width = Formula[i].endX - Formula[i].beginX
#          LET Formula[i].beginX = x
#          LET Formula[i].endX = x + width
#          LET Formula[i].beginY = y
#          LET Formula[i].endY = Formula[i-1].endY
#          LET Formula[i].lineNumber = Formula[i-1].lineNumber
#        ELSE  
#          EXIT FOR        
#        END IF        
#      END FOR        
#    ELSE
#        #if the cursor is at the first position of the line
#        #append the current line to last line
#        #and set the position of every line after it
#      FOR i = myCursor.Pos + 1 TO Formula.getLength()
#        IF(Formula[i].lineNumber == ln + 1) THEN            
#          LET x = Formula[i - 1].endX
#          LET y = Formula[i - 1].beginY
#          LET width = Formula[i].endX - Formula[i].beginX
#          LET Formula[i].beginX = x
#          LET Formula[i].endX = x + width
#          LET Formula[i].beginY = y
#          LET Formula[i].endY = Formula[i-1].endY
#          LET Formula[i].lineNumber = Formula[i-1].lineNumber
#        ELSE  
#          LET Formula[i].lineNumber = Formula[i].lineNumber - 1
#          LET Formula[i].beginY = Formula[i].beginY + LineSpace
#          LET Formula[i].endY   = Formula[i].endY + LineSpace     
#        END IF      
#      END FOR      
#    END IF
#
#    {  
#    #set the position of the word in the same line of the current word    
#    FOR i = myCursor.Pos + 1 TO Formula.getLength()
#      IF(Formula[i].lineNumber == ln) THEN            
#        LET x = Formula[i - 1].endX
#        LET y = Formula[i - 1].beginY
#        LET width = Formula[i].endX - Formula[i].beginX
#        LET Formula[i].beginX = x
#        LET Formula[i].endX = x + width
#        LET Formula[i].beginY = y
#        LET Formula[i].endY = Formula[i-1].endY
#        LET Formula[i].lineNumber = Formula[i-1].lineNumber
#      ELSE
#        #if the cursor is at the first position of the line
#        #append the current line to last line
#        #and set the position of every line after it
#        IF(Formula[myCursor.Pos - 1].id == 0) THEN
#          LET Formula[i].lineNumber = Formula[i].lineNumber - 1
#          LET Formula[i].beginY = Formula[i].beginY + LineSpace
#          LET Formula[i].endY   = Formula[i].endY + LineSpace
#        #if not ,do nothing and exit
#        ELSE
#          EXIT FOR
#        END IF
#      END IF
#    END FOR
#}    
#
#    LET myCursor.Pos = myCursor.Pos - 1
#    CALL Formula.deleteElement(myCursor.Pos)
#
#    LET myCursor.Ln = Formula[myCursor.Pos].lineNumber
#    LET myCursor.CursorPosX = Formula[myCursor.Pos].beginX
#    LET myCursor.CursorPosY = Formula[myCursor.Pos].beginY
#
#      #keep two lines on the top
#      IF myCursor.Ln < DW.s_ln + 2 THEN
#        IF DW.s_ln > 1 THEN
#          LET DW.s_ln = DW.s_ln - 1
#        END IF
#      END IF
    
    CALL DrawCursor()
    #CALL RePaint()
END FUNCTION

FUNCTION DEL()
  DEFINE i,ln,x,y,width INT

  IF myCursor.Pos != Formula.getLength() THEN
    LET myCursor.Pos = myCursor.Pos + 1
    CALL BACKSPACE()

  END IF

END FUNCTION

