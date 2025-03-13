# Prog. Version..: '5.30.06-13.04.22(00003)'     #
# Pattern name...: axmi403.4gl
# Descriptions...: 订貨会目标维护作业 
# Date & Author..: FUN-A50011 10/05/06 By yangfeng
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B90105 11/10/09 By linlin  制訂訂貨會客戶訂貨目標
# Modify.........: No:FUN-D30034 13/04/16 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"
DEFINE
  g_odo01           LIKE odo_file.odo01,   
  g_odo01_t         LIKE odo_file.odo01,   
  l_cnt             LIKE type_file.num5,          
  g_odo             DYNAMIC ARRAY OF RECORD   
           odo02    LIKE odo_file.odo02,
           occ02    LIKE occ_file.occ02,
           odo03    LIKE odo_file.odo03,
           odo04    LIKE odo_file.odo04
                    END RECORD,
  g_odo_t           RECORD   
           odo02    LIKE odo_file.odo02,
           occ02    LIKE occ_file.occ02,
           odo03    LIKE odo_file.odo03,
           odo04    LIKE odo_file.odo04
                    END RECORD,
  g_wc,g_sql        STRING,
  g_delete          LIKE type_file.chr1,                #No.FUN-A50011 CHAR(1)
  g_rec_b           LIKE type_file.num5,                #No.FUN-A50011 sMALLINT 
  l_ac              LIKE type_file.num5                 #No.FUN-A50011 SMALLINT
DEFINE g_before_input_done LIKE type_file.num5          #No.FUN-A50011 SMALLINT 
DEFINE g_forupd_sql        STRING                       #SELECT ... FOR UPDATE SQL
DEFINE g_cnt               LIKE type_file.num10         #No.FUN-A50011  INTEGER
DEFINE g_i                 LIKE type_file.num5          #count/index for any purpose   #No.FUN-A50011 SMALLINT
DEFINE g_msg               LIKE ze_file.ze03            #No.FUN-A50011 CHAR(72)
DEFINE g_row_count         LIKE type_file.num10         #No.FUN-A50011 INTEGER
DEFINE g_curs_index        LIKE type_file.num10         #No.FUN-A50011 INTEGER
DEFINE g_jump              LIKE type_file.num10         #No.FUN-A50011 INTEGER                           
DEFINE g_no_ask            LIKE type_file.num5          #No.FUN-A50011 INTEGER   

MAIN
    OPTIONS 
       INPUT NO WRAP                       
    DEFER INTERRUPT                         

    IF (NOT cl_user()) THEN 
       EXIT PROGRAM 
    END IF 

    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("AXM")) THEN 
       EXIT PROGRAM
    END IF

    CALL cl_used(g_prog,g_time,1) RETURNING g_time

    INITIALIZE g_odo TO NULL                                                
    INITIALIZE g_odo_t.* TO NULL                                                

    LET g_forupd_sql = "SELECT * FROM odo_file WHERE odo01 = ? FOR UPDATE"  
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i403_cl CURSOR FROM g_forupd_sql             # LOCK CURSOR                      

    OPEN WINDOW i403_w WITH FORM "axm/42f/axmi403"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
    CALL i403_menu()   
    CLOSE WINDOW i403_w     

    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN


FUNCTION i403_cs()
    CLEAR FORM
    CALL g_odo.clear()

    CALL cl_set_head_visible("","YES")        
    INITIALIZE g_odo01 TO NULL    
    CONSTRUCT g_wc ON odo01,odo02,odo03,odo04
         FROM odo01,s_odo[1].odo02,s_odo[1].odo03,s_odo[1].odo04
              
      BEFORE CONSTRUCT
        CALL cl_qbe_init()
      
      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(odo01)
              CALL cl_init_qry_var()       
              LET g_qryparam.state ="c"
              LET g_qryparam.form ="q_odl01"
              LET g_qryparam.where = "odlacti = 'Y'"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO odo01
              NEXT FIELD odo01        
           WHEN INFIELD(odo02)
              CALL cl_init_qry_var()       
              LET g_qryparam.state ="c"
              LET g_qryparam.form ="q_occ"
              LET g_qryparam.where = "occacti = 'Y'"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO odo02
              NEXT FIELD odo02         
         END CASE

      ON IDLE g_idle_seconds                                              
         CALL cl_on_idle()                                                
         CONTINUE CONSTRUCT
     
      ON ACTION about     
         CALL cl_about()   
     
      ON ACTION help     
         CALL cl_show_help()
     
      ON ACTION controlg   
         CALL cl_cmdask() 
     
      ON ACTION qbe_select
         CALL cl_qbe_select() 

      ON ACTION qbe_save
         CALL cl_qbe_save()
    END CONSTRUCT
  
    IF INT_FLAG THEN
       RETURN 
    END IF
  
    LET g_sql=" SELECT DISTINCT odo01 FROM odo_file ",
              " WHERE ",g_wc CLIPPED,
              " ORDER BY odo01 "
    PREPARE i403_prepare FROM g_sql
    DECLARE i403_bcs SCROLL CURSOR WITH HOLD FOR i403_prepare
    LET g_sql=" SELECT COUNT(UNIQUE odo01) ",
              "   FROM odo_file WHERE ",g_wc CLIPPED
    PREPARE i403_precount FROM g_sql
    DECLARE i403_count CURSOR FOR i403_precount
  
END FUNCTION

FUNCTION i403_menu()
    WHILE TRUE
      CALL i403_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN
               CALL i403_a()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL i403_u()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i403_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i403_r()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i403_b()
            ELSE
               LET g_action_choice = NULL
            END IF
    {     WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i403_out()
            END IF
    }
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()        
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               call cl_export_to_excel(ui.interface.getrootnode(),base.typeinfo.create(g_odo),'','')
            END IF 
         WHEN "related_document"  
              IF cl_chk_act_auth() THEN
                 IF g_odo01 IS NOT NULL THEN
                    LET g_doc.column1 = "odo01"
                    LET g_doc.value1 = g_odo01
                    CALL cl_doc()
                 END IF
              END IF
      END CASE
    END WHILE
END FUNCTION 

FUNCTION i403_a() 
    IF s_shut(0) THEN RETURN END IF 
    MESSAGE ""
    CLEAR FORM
    CALL g_odo.clear()
    INITIALIZE g_odo01 LIKE odo_file.odo01
    LET g_odo01_t = NULL
    CALL cl_opmsg('a')
  
    WHILE TRUE
        CALL i403_i("a")     
        IF INT_FLAG THEN     
           LET g_odo01 = NULL
           CLEAR FORM
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           EXIT WHILE
        END IF
        LET g_rec_b=0
        CALL i403_b()                    
        LET g_odo01_t = g_odo01         
        EXIT WHILE
    END WHILE        
END FUNCTION

FUNCTION i403_u()
    IF g_odo01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    CALL cl_opmsg('u')
    LET g_odo01_t = g_odo01
   
    WHILE TRUE
        CALL i403_i("u")                    
        IF INT_FLAG THEN
            LET g_odo01=g_odo01_t
            DISPLAY g_odo01 TO odo01         
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_odo01 != g_odo01_t THEN          
            UPDATE odo_file SET odo01  = g_odo01
             WHERE odo01 = g_odo01_t       
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","odo_file",g_odo01,"",
                              SQLCA.sqlcode,"","",1) 
                CONTINUE WHILE
             END IF
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION 

FUNCTION i403_i(p_cmd)
   DEFINE   p_cmd           LIKE type_file.chr1,            #No.FUN-A50011 CHAR(1)
         l_n             LIKE type_file.num5,          #No.FUN-A50011 SMALLINT
         l_count         LIKE type_file.num5,
         l_occ02         LIKE occ_file.occ02


   INPUT g_odo01 WITHOUT DEFAULTS FROM odo01

        BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i403_set_entry(p_cmd)
          CALL i403_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE


        AFTER FIELD odo01
           IF g_odo01 IS NOT NULL THEN                                     
              IF p_cmd = "a" OR                                                     
                  (p_cmd = "u" AND g_odo01 != g_odo01_t) THEN  
                  LET l_count=0
                  SELECT COUNT(*) INTO l_count FROM odo_file
                   WHERE odo01=g_odo01
                  IF l_count>0 THEN
                     CALL cl_err(g_odo01,-239,1)
                     LET g_odo01 = g_odo01_t
                     DISPLAY BY NAME g_odo01
                     NEXT FIELD odo01
                  END IF
                  CALL i403_odo01('d')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_odo01,g_errno,1)
                     LET g_odo01 = g_odo01_t
                     DISPLAY BY NAME g_odo01
                     NEXT FIELD odo01
                  END IF
              END IF
           END IF

        ON ACTION CONTROLP                 
            CASE
                WHEN INFIELD(odo01)
                  CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_odl01"
                   LET g_qryparam.default1 = g_odo01
                   LET g_qryparam.where = "odlacti = 'Y' "
                   CALL cl_create_qry() RETURNING g_odo01 
                   DISPLAY g_odo01 TO odo01
                   NEXT FIELD odo01        
            END CASE
   
          
       ON IDLE g_idle_seconds                                                   
          CALL cl_on_idle()                                                     
          CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
    END INPUT
END FUNCTION


FUNCTION i403_q()
   DEFINE l_odo01  LIKE odo_file.odo01,
         l_cnt    LIKE type_file.num10               #No.FUN-A50011 INTEGER

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_odo01 TO NULL    

    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_odo.clear()

    CALL i403_cs()                  
    IF INT_FLAG THEN                 
       LET INT_FLAG = 0
       RETURN
    END IF
    OPEN i403_bcs                   
    IF SQLCA.sqlcode THEN           
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_odo01 TO NULL
    ELSE
       OPEN i403_count                                                     
       FETCH i403_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt  
       CALL i403_fetch('F')       
    END IF
END FUNCTION


FUNCTION i403_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1           #No.FUN-A50011 CHAR(1)

    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i403_bcs INTO g_odo01
        WHEN 'P' FETCH PREVIOUS i403_bcs INTO g_odo01
        WHEN 'F' FETCH FIRST    i403_bcs INTO g_odo01
        WHEN 'L' FETCH LAST     i403_bcs INTO g_odo01
        WHEN '/' 
         IF (NOT g_no_ask) THEN   
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
            PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
                ON ACTION about        
                   CALL cl_about()     
 
                ON ACTION help         
                   CALL cl_show_help() 
 
                ON ACTION controlg     
                   CALL cl_cmdask()    
 
             END PROMPT
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
         END IF
         FETCH ABSOLUTE g_jump i403_bcs INTO g_odo01
         LET g_no_ask = FALSE            
    END CASE

    IF SQLCA.sqlcode THEN                        
        CALL cl_err(g_odo01,SQLCA.sqlcode,0)
        INITIALIZE g_odo01 TO NULL 
        RETURN
    ELSE
        CASE p_flag                                                             
                                                                                
          WHEN 'F' LET g_curs_index = 1                                        
          WHEN 'P' LET g_curs_index = g_curs_index - 1                        
          WHEN 'N' LET g_curs_index = g_curs_index + 1                        
          WHEN 'L' LET g_curs_index = g_row_count                             
          WHEN '/' LET g_curs_index = g_jump                                   
        END CASE                                                                
        CALL cl_navigator_setting( g_curs_index, g_row_count )        
    END IF
    OPEN i403_count
    FETCH i403_count INTO g_row_count
    DISPLAY g_curs_index TO FORMONLY.idx
    CALL i403_show()
END FUNCTION

FUNCTION i403_show()
    DEFINE l_pma02         LIKE pma_file.pma02
    LET g_odo01_t = g_odo01

    DISPLAY g_odo01 TO odo01 
   
    CALL i403_odo01('d') 
    CALL i403_b_fill(g_wc)                 
    CALL cl_show_fld_cont()                 
END FUNCTION

FUNCTION i403_r()
    IF s_shut(0) THEN RETURN END IF                
    IF g_odo01 IS NULL THEN 
       CALL cl_err("",-400,0)               
       RETURN
    END IF
    IF cl_delh(0,0) THEN                   
        DELETE FROM odo_file WHERE odo01 = g_odo01 
        IF SQLCA.sqlcode THEN
            CALL cl_err3("del","odo_file",g_odo01,"",SQLCA.sqlcode,"",
                         "BODY DELETE",1) 
        ELSE
            CLEAR FORM
            CALL g_odo.clear()
            LET g_delete='Y'
            LET g_odo01 = NULL
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            OPEN i403_count                                                     
            #FUN-B50064-add-start--
            IF STATUS THEN
               CLOSE i403_bcs
               CLOSE i403_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50064-add-end-- 
                 FETCH i403_count INTO g_row_count                 
            #FUN-B50064-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i403_bcs
               CLOSE i403_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50064-add-end-- 
            DISPLAY g_row_count TO FORMONLY.cnt               
            OPEN i403_bcs                                      
            IF g_curs_index = g_row_count + 1 THEN            
               LET g_jump = g_row_count                       
               CALL i403_fetch('L')                           
            ELSE                                              
               LET g_jump = g_curs_index                      
               LET g_no_ask = TRUE                       
               CALL i403_fetch('/')                           
            END IF
        END IF
    END IF
END FUNCTION

FUNCTION i403_b()
    DEFINE
       l_ac_t          LIKE type_file.num5,               
       l_n             LIKE type_file.num5,             
       l_ac_o          LIKE type_file.num5,           
       l_rows          LIKE type_file.num5,                #No.FUN-A50011 SMALLINT
       l_success       LIKE type_file.chr1,                #No.FUN-A50011 CHAR(1)
       l_str           LIKE type_file.chr20,               #No.FUN-A50011 CHAR(20)
       l_lock_sw       LIKE type_file.chr1,                #No.FUN-A50011 CHAR(1)
       p_cmd           LIKE type_file.chr1,                #No.FUN-A50011 CHAR(1)
       l_allow_insert  LIKE type_file.num5,                #No.FUN-A50011 SMALLINT
       l_allow_delete  LIKE type_file.num5                

    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF             
    IF cl_null(g_odo01) THEN RETURN END IF


    CALL cl_opmsg('b')
    LET  g_forupd_sql = " SELECT odo02,'',odo03,odo04 ",
                       "   FROM odo_file  ",
                       "  WHERE odo01=?   ",
                       "    AND odo02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i403_bcl CURSOR FROM g_forupd_sql 

    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    INPUT ARRAY g_odo WITHOUT DEFAULTS FROM s_odo.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
    BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
           

    BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            IF g_rec_b >=l_ac THEN
                BEGIN WORK
                LET p_cmd='u'
                LET g_odo_t.* = g_odo[l_ac].*    
                OPEN i403_bcl USING g_odo01,g_odo_t.odo02
                IF STATUS THEN
                   CALL cl_err("OPEN i403_bcl:",STATUS,1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i403_bcl INTO g_odo[l_ac].* 
                   IF STATUS THEN
                      CALL cl_err(g_odo_t.odo03,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()
            END IF
            CALL i403_odo02('d') #FUN-B90105----ADD---
        
    BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_odo[l_ac].* TO NULL 
            LET g_odo_t.* = g_odo[l_ac].*   
            CALL cl_show_fld_cont()   
            LET g_odo[l_ac].odo03 = 0
            LET g_odo[l_ac].odo04 = 0
            NEXT FIELD odo02
   AFTER  FIELD odo02
      IF g_odo[l_ac].odo02 IS NOT NULL THEN 
          IF p_cmd = "a" OR
             (p_cmd = "u" AND g_odo[l_ac].odo02 != g_odo_t.odo02) THEN
#FUN-B90105----ADD---begin-
                 SELECT count(*)
                   INTO l_n
                   FROM odo_file
                  WHERE odo01 = g_odo01_t
                    AND odo02 = g_odo[l_ac].odo02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_odo[l_ac].odo02 = g_odo_t.odo02
                    NEXT FIELD odo02
                 END IF
#FUN-B90105----ADD---end--
                CALL i403_odo02('d') 
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_odo[l_ac].odo02,g_errno,1)
                    LET g_odo[l_ac].odo02 = g_odo_t.odo02
                    DISPLAY BY NAME g_odo[l_ac].odo02
                    NEXT FIELD odo02
                 END IF
          END IF
      END IF
   AFTER FIELD odo03
      IF g_odo[l_ac].odo03 < 0 THEN
         CALL cl_err(g_odo[l_ac].odo03,'axm-179',0) #FUN-B90105 ADD
         LET g_odo[l_ac].odo03 = 0     
         NEXT FIELD odo03
      END IF
   AFTER FIELD odo04
      IF g_odo[l_ac].odo04 < 0 THEN
         CALL cl_err(g_odo[l_ac].odo04,'axm-179',0) #FUN-B90105 ADD
         LET g_odo[l_ac].odo04 = 0  
         NEXT FIELD odo04
      END IF

    AFTER INSERT
      
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO odo_file(odo01,odo02,odo03,odo04,
                                 odoacti,odouser,odogrup,ododate,odomodu,odoorig,odooriu)
                          VALUES(g_odo01,g_odo[l_ac].odo02,g_odo[l_ac].odo03,
                                 g_odo[l_ac].odo04,
                                 'Y',g_user,g_grup,g_today,g_user,g_grup,g_user)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","odo_file",g_odo01,g_odo[l_ac].odo02,
                             SQLCA.sqlcode,"","",1)  
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               COMMIT WORK 
               LET g_rec_b=g_rec_b+1
            END IF
 

        BEFORE DELETE             
            IF g_odo_t.odo02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM odo_file
                 WHERE odo01 = g_odo01 
                   AND odo02 = g_odo_t.odo02 
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","odo_file",g_odo_t.odo02,"",
                                  SQLCA.sqlcode,"","",1) 
                    ROLLBACK WORK
                    CANCEL DELETE 
                    EXIT INPUT
                END IF
            LET g_rec_b=g_rec_b-1
            END IF
            COMMIT WORK

    ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_odo[l_ac].* = g_odo_t.*
               CLOSE i403_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_odo[l_ac].odo03,-263,1)
               LET g_odo[l_ac].* = g_odo_t.*
            ELSE
               UPDATE odo_file SET odo01  =g_odo01,
                                  
                                   odo02=g_odo[l_ac].odo02,
                                   odo03=g_odo[l_ac].odo03,
                                   odo04=g_odo[l_ac].odo04,
                                   odomodu = g_user
                WHERE odo01 = g_odo01 
                  AND odo02 = g_odo_t.odo02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","odo_file",g_odo[l_ac].odo02,"",
                               SQLCA.sqlcode,"","",1)
                 LET g_odo[l_ac].* = g_odo_t.*
                 ROLLBACK WORK
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
            END IF

    AFTER ROW
            LET l_ac = ARR_CURR()  #FUN-D30034 add
           #LET l_ac_t = l_ac   #FUN-D30034 mark 
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_odo[l_ac].* = g_odo_t.*
               #FUN-D30034--add--begin--
               ELSE
                  CALL g_odo.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end----
               END IF
               CLOSE i403_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30034 add
            CLOSE i403_bcl
            COMMIT WORK

    ON ACTION CONTROLP
        CASE
           WHEN INFIELD(odo02)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_occ"
                LET g_qryparam.where = "occacti = 'Y'"
                LET g_qryparam.default1 = g_odo[l_ac].odo02
                CALL cl_create_qry() RETURNING g_odo[l_ac].odo02 DISPLAY g_odo[l_ac].odo02 TO odo02 
                NEXT FIELD odo02
        END CASE

    ON ACTION CONTROLR
        CALL cl_show_req_fields()
   
    ON ACTION CONTROLG
        CALL cl_cmdask()

    ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
    ON ACTION about        
        CALL cl_about()      
 
    ON ACTION help          
        CALL cl_show_help()  
 
    ON ACTION controls                                       
        CALL cl_set_head_visible("","AUTO")       
    
    END INPUT
    CLOSE i403_bcl
    COMMIT WORK
 
END FUNCTION


FUNCTION i403_b_fill(p_wc)              #BODY FILL UP
    DEFINE
        p_wc            LIKE type_file.chr1000       #No.FUN-A50011 CHAR(200)

    LET g_sql = "SELECT odo02,occ02,odo03,odo04 ",
                "  FROM odo_file,OUTER occ_file ",
                " WHERE odo01 = '",g_odo01,"'",
                "   AND odo02 = occ_file.occ01 ",
                "   AND ",p_wc CLIPPED    
    PREPARE i403_prepare2 FROM g_sql     
   
    DECLARE odo_cs CURSOR FOR i403_prepare2
    CALL g_odo.clear()
    LET g_cnt = 1
    LET g_rec_b=0

    FOREACH odo_cs INTO g_odo[g_cnt].* 
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
    END FOREACH
    CALL g_odo.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1     
    LET g_cnt = 0
END FUNCTION

FUNCTION i403_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-A50011 CHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_odo TO s_odo.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY                                                            
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()   

      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first 
         CALL i403_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY            

      ON ACTION previous
         CALL i403_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  
         END IF
	ACCEPT DISPLAY            

      ON ACTION jump 
         CALL i403_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1) 
         END IF
	ACCEPT DISPLAY              

      ON ACTION next
         CALL i403_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY 

      ON ACTION last 
         CALL i403_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY 

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
{
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
}
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit" 
         EXIT DISPLAY 

      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()     
      
      ON ACTION exporttoexcel
         LET g_action_choice="exporttoexcel"
         EXIT DISPLAY

      ON ACTION related_document      
         LET g_action_choice="related_document"          
         EXIT DISPLAY

      ON ACTION controls                          
         CALL cl_set_head_visible("","AUTO")   

      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY

   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

{
FUNCTION i403_out()
  DEFINE g_str   STRING
  IF cl_null(g_wc) AND NOT cl_null(g_odo01) AND NOT cl_null(g_odo[l_ac].odo02) THEN
     LET g_wc = " odo01 = '",g_odo01,"' AND odo02 = '",g_odo[l_ac].odo02,"'"                                   
  END IF  
  IF g_wc IS NULL THEN
     CALL cl_err('','9057',0)
     RETURN
  END IF
  CALL cl_wait()
  SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
  LET g_sql = "SELECT odo01,odl02,odo02,occ02,odo03.odo04",
              " FROM odo_file,odl_file,occ_file",
              " WHERE odo01 = odl_file.odl01 AND odo02 = occ_file.occ01 ",
              g_wc CLIPPED
  LET g_str = ''
  SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
  IF g_zz05 = 'Y' THEN
     CALL cl_wcchp(g_wc,'odo01,odo02,odo03,odo04') RETURNING g_wc
  END IF
  LET g_str = g_wc
  CALL cl_prt_cs1("axmi403","axmi403",g_sql,g_str) 
               
END FUNCTION

}

FUNCTION i403_set_entry(p_cmd)                                                  
   DEFINE   p_cmd     LIKE type_file.chr1               #No.FUN-A50011 CHAR(1)
                                                                                
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN                                            
       CALL cl_set_comp_entry("odo01",TRUE)                               
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i403_set_no_entry(p_cmd)                                               
   DEFINE   p_cmd     LIKE type_file.chr1               #No.FUN-A50011 CHAR(1)
                                                                                
   IF (NOT g_before_input_done) THEN                                            
       IF p_cmd = 'u' AND g_chkey = 'N' THEN                                    
           CALL cl_set_comp_entry("odo01",FALSE)                          
       END IF                                                                   
   END IF                                                                       
END FUNCTION

    
FUNCTION i403_odo01(p_cmd)
   DEFINE p_cmd    LIKE type_file.chr1,
          l_odl02  LIKE odl_file.odl02
   LET g_errno = ''
   SELECT odl02 INTO l_odl02 FROM odl_file WHERE odl01 = g_odo01 AND odlacti = 'Y'
   CASE 
      WHEN SQLCA.sqlcode = 100
#        LET g_errno = "axm-070"    #FUN-B90105-mark   信息報錯
         LET g_errno = "mfg2732"    #FUN-B90105--add 
         LET l_odl02 = NULL
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      DISPLAY l_odl02 TO odl02
   END IF
END FUNCTION
   
FUNCTION i403_odo02(p_cmd)
   DEFINE p_cmd    LIKE type_file.chr1,
          l_occ02  LIKE occ_file.occ02
   LET g_errno = ''
   SELECT occ02 INTO g_odo[l_ac].occ02 FROM occ_file WHERE occ01 = g_odo[l_ac].odo02 AND occacti = 'Y'
   CASE 
      WHEN SQLCA.sqlcode = 100
#        LET g_errno = "axm-070"    #FUN-B90105-mark   信息報錯
         LET g_errno = "mfg2732"    #FUN-B90105--add 
         LET l_occ02 = NULL
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
     DISPLAY g_odo[l_ac].occ02  TO occ02 
   END IF
END FUNCTION

#FUN-A50011
