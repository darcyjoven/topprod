# Prog. Version..: '5.30.09-13.09.06(00000)'     #
#
# Pattern name...: agli900.4gl
# Descriptions...: 财务指标取數設置資料維護作業
# Date & Author..: FUN-D50004 13/05/06 By zhangweib
# Modify.........: No:CHI-D70005 13/07/05 by Reanna 修正「查詢任何一筆資料，再查詢，不輸入任何資料，直接esc離開，再按下b進入單身，會出現無法離開程式的bug」


DATABASE ds
GLOBALS "../../config/top.global"

DEFINE g_abo00          LIKE abo_file.abo00,       #单头  FUN-D50004
       g_abo00_t        LIKE abo_file.abo00,       #单头旧值
       g_abo            DYNAMIC ARRAY OF RECORD    #单身数组
          abo01         LIKE abo_file.abo01,       
          abo02         LIKE abo_file.abo02,
          abo03         LIKE abo_file.abo03,
          abo04         LIKE abo_file.abo04,
          abo05         LIKE abo_file.abo05,
          abo06         LIKE abo_file.abo06
                        END RECORD,
       g_abo_t          RECORD                     #单身旧值
          abo01         LIKE abo_file.abo01,
          abo02         LIKE abo_file.abo02,
          abo03         LIKE abo_file.abo03,
          abo04         LIKE abo_file.abo04,
          abo05         LIKE abo_file.abo05,
          abo06         LIKE abo_file.abo06
                        END RECORD,
       g_cnt2           LIKE type_file.num5,
       g_wc             STRING,
       g_sql            STRING,
       g_success        LIKE type_file.chr1,
       g_rec_b          LIKE type_file.num5,       #单身总笔数
       l_ac             LIKE type_file.num5        #当前笔数
DEFINE g_cnt            LIKE type_file.num10
DEFINE g_chr            LIKE type_file.chr1
DEFINE g_msg            LIKE type_file.chr1000  
DEFINE g_forupd_sql     STRING       
DEFINE g_curs_index     LIKE type_file.num10    
DEFINE g_row_count      LIKE type_file.num10
DEFINE g_jump           LIKE type_file.num10    
DEFINE g_no_ask         LIKE type_file.num5   
DEFINE g_abo_lock       RECORD LIKE abo_file.*     
DEFINE g_before_input_done   LIKE type_file.num5        

MAIN
   OPTIONS                                                  #改变一些系统预设值
      INPUT NO WRAP                                         #输入不打转
   DEFER INTERRUPT                                          #拮取中断键，由程序处理

   IF (NOT cl_user()) THEN                                  #判断用户，带出与用户有关的信息
      EXIT PROGRAM
   END IF
   
   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AGL")) THEN                            #判断模组
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #程序开始时间

   LET g_abo00_t = NULL

   OPEN WINDOW i900_w WITH FORM "agl/42f/agli900"           #打开画面
      ATTRIBUTE(STYLE = g_win_style CLIPPED) 

   CALL cl_ui_init()

   LET g_forupd_sql = " SELECT * FROM abo_file WHERE abo00 = ? FOR UPDATE"  #FOR UPDATE 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i900_cl CURSOR FROM g_forupd_sql

   CALL i900_menu() 
   CLOSE WINDOW i900_w                                     #关闭画面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time          #程序结束时间
END MAIN    
     
FUNCTION i900_curs()
   CLEAR FORM
   CALL g_abo.clear()

   CALL cl_set_head_visible("","YES")

   CONSTRUCT g_wc ON abo00,abo01,abo02,abo03,abo04,abo05,abo06
                FROM abo00,s_abo[1].abo01,s_abo[1].abo02,s_abo[1].abo03,
                     s_abo[1].abo04,s_abo[1].abo05,s_abo[1].abo06

   ON ACTION controlp
      CASE
         WHEN INFIELD(abo00)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_aaa"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO abo00
            NEXT FIELD abo00
         WHEN INFIELD(abo04) 
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_aag"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO abo04
            NEXT FIELD abo04

         WHEN INFIELD(abo05) 
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_aag0"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO abo05
            NEXT FIELD abo05
                 
 
               OTHERWISE
                  EXIT CASE
            END CASE
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
          ON ACTION help
             CALL cl_show_help()
          ON ACTION controlg
             CALL cl_cmdask()
          ON ACTION about
             CALL cl_about()
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED
 
      IF INT_FLAG THEN RETURN END IF
  
   
         LET g_sql = "SELECT UNIQUE abo00 FROM abo_file"," WHERE ",g_wc CLIPPED," ORDER BY abo00"
         PREPARE i900_prepare FROM g_sql          
   DECLARE i900_curs                      
      SCROLL CURSOR WITH HOLD FOR i900_prepare
 
END FUNCTION

FUNCTION i900_count()
DEFINE   li_cnt    LIKE     type_file.num10
DEFINE   li_rec_b  LIKE     type_file.num10

   LET g_sql = "SELECT UNIQUE abo00 FROM abo_file"," WHERE ",g_wc CLIPPED
   
   PREPARE i900_precount FROM g_sql
   DECLARE i900_count CURSOR FOR i900_precount
   LET li_cnt=1
   LET li_rec_b=0
   FOREACH i900_count INTO g_abo[li_cnt].*  
       LET li_rec_b = li_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          LET li_rec_b = li_rec_b - 1
          EXIT FOREACH
       END IF
       LET li_cnt = li_cnt + 1
    END FOREACH
    LET g_row_count=li_rec_b
 
END FUNCTION

FUNCTION i900_menu()
 
   WHILE TRUE
      CALL i900_bp("G")
 
      CASE g_action_choice
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL i900_a()
            END IF
         WHEN "modify"                          # U.修改
            IF cl_chk_act_auth() THEN
               CALL i900_u()
            END IF
         WHEN "reproduce"                       # C.複製
            IF cl_chk_act_auth() THEN
               CALL i900_copy()
            END IF
         WHEN "delete"                          # R.取消
            IF cl_chk_act_auth() THEN
               CALL i900_r()
             END IF  
         
         WHEN "query"                           
            IF cl_chk_act_auth() THEN
               CALL i900_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i900_b("u")
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"                            
            CALL cl_show_help()
         WHEN "exit"                            
            EXIT WHILE
         WHEN "controlg"                        
            CALL cl_cmdask()
         WHEN "exporttoexcel"     
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_abo),'','')
            END IF
        END CASE
    END WHILE
END FUNCTION

FUNCTION i900_a()                            # Add  輸入
   MESSAGE ""
   CLEAR FORM
   CALL g_abo.clear()
 
   INITIALIZE g_abo00 LIKE abo_file.abo00
   CALL cl_opmsg('a')
 
   WHILE TRUE
   LET g_abo00 = g_aza.aza81 
   CALL i900_i("a")
   IF INT_FLAG THEN                            
         LET g_abo00=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b = 0
 
      IF g_success='N' THEN
         CALL g_abo.clear()
             
      END IF
 
      CALL i900_b("a")                          
      LET g_abo00_t=g_abo00
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION i900_i(p_cmd)
DEFINE   l_count     LIKE    type_file.num5
DEFINE   p_cmd       LIKE    type_file.chr1

   LET g_success = 'Y'
   DISPLAY g_abo00 TO abo00    
   CALL cl_set_head_visible("","YES")   
   INPUT g_abo00 WITHOUT DEFAULTS FROM abo00
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
               END IF
      AFTER FIELD abo00
         IF NOT cl_null(g_abo00) THEN
#            IF g_abo00 != g_abo00_t OR cl_null(g_abo00_t) THEN
               SELECT COUNT(UNIQUE abo00) INTO g_cnt FROM abo_file
                WHERE abo00 = g_abo00    
               IF g_cnt > 0 THEN
                  CALL cl_err(g_abo00,-239,0)
                  LET g_abo00 = g_abo00_t
                     NEXT FIELD abo00
               END IF
          
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_abo00,g_errno,0)
                  NEXT FIELD abo00
               END IF
            END IF
#         END IF
     
      SELECT COUNT(aaa01) INTO l_count FROM aaa_file WHERE aaa01 = g_abo00
                                                     AND aaaacti = 'Y'
         IF l_count = 0 THEN
            CALL cl_err('该帐套不存在','!',0)
            NEXT FIELD abo00
         END IF   
           
      ON ACTION controlp
         CASE
            WHEN INFIELD(abo00)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aaa"
               LET g_qryparam.default1= g_abo00
               CALL cl_create_qry() RETURNING g_abo00
               NEXT FIELD abo00
 
            OTHERWISE 
               EXIT CASE
         END CASE
 
      ON ACTION controlf                  
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
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

FUNCTION i900_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_abo00) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_abo00_t = g_abo00
   
 
   BEGIN WORK
   OPEN i900_cl USING g_abo00  
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE i900_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i900_cl INTO g_abo_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("abo00 LOCK:",SQLCA.sqlcode,1)
      CLOSE i900_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   WHILE TRUE
      CALL i900_b("u")
      IF INT_FLAG THEN
         LET g_abo00 = g_abo00_t
         DISPLAY g_abo00 TO abo00
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE abo_file SET abo00 = g_abo00
       WHERE abo00 = g_abo00_t
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","abo_file",g_abo00_t,' ',SQLCA.sqlcode,"","",1)
         CONTINUE WHILE

      END IF
      EXIT WHILE
   END WHILE
   COMMIT WORK
END FUNCTION   
      
FUNCTION i900_q()                            #Query 查詢
   MESSAGE ""
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CLEAR FORM  
   CALL g_abo.clear()
   DISPLAY '' TO FORMONLY.cnt
   CALL i900_curs()                         
   IF INT_FLAG THEN                          
      LET INT_FLAG = 0
      LET g_rec_b = 0                       #CHI-D70005      
      RETURN
   END IF
   OPEN i900_curs                       
   IF SQLCA.SQLCODE THEN                         
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_abo00 TO NULL
      
   ELSE

      CALL i900_count()
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i900_fetch('F')                 
    END IF
END FUNCTION

FUNCTION i900_fetch(p_flag)                  #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1,         
            l_abso   LIKE type_file.num10         
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i900_curs INTO g_abo00   
      WHEN 'P' FETCH PREVIOUS i900_curs INTO g_abo00
      WHEN 'F' FETCH FIRST    i900_curs INTO g_abo00
      WHEN 'L' FETCH LAST     i900_curs INTO g_abo00
      WHEN '/' 
         IF (NOT g_no_ask) THEN          
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  
            PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
                ON ACTION controlg
                   CALL cl_cmdask()
 
                ON ACTION help
                   CALL cl_show_help()
 
                ON ACTION about
                   CALL cl_about()
 
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump i900_curs INTO g_abo00   
         LET g_no_ask = FALSE    
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_abo00,SQLCA.sqlcode,0)
      INITIALIZE g_abo00 TO NULL  
   ELSE
      CALL i900_show()
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump          
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
 
  
   END IF
END FUNCTION

FUNCTION i900_show()                        
   DISPLAY g_abo00 TO abo00  
   CALL i900_b_fill(g_wc)                    
   CALL cl_show_fld_cont()                   
END FUNCTION

FUNCTION i900_r()        
   DEFINE   l_cnt   LIKE type_file.num5,      
            l_abo   RECORD LIKE abo_file.*
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_abo00) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   BEGIN WORK
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM abo_file
       WHERE abo00 = g_abo00
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","abo_file",g_abo00,' ',SQLCA.sqlcode,"","BODY DELETE",0)  
      ELSE
         CLEAR FORM
         CALL g_abo.clear()
         CALL i900_count()
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i900_curs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i900_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE         
            CALL i900_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION
 
FUNCTION i900_b(p_c)                            
   DEFINE   l_ac_t          LIKE type_file.num5,               # 未取消的ARRAY CNT 
            l_n             LIKE type_file.num5,               
            l_cnt           LIKE type_file.num5,               
            l_gau01         LIKE type_file.num5,               
            l_lock_sw       LIKE type_file.chr1,              
            p_cmd           LIKE type_file.chr1,               
            l_allow_insert  LIKE type_file.num5,               
            l_allow_delete  LIKE type_file.num5               
   DEFINE   l_count         LIKE type_file.num5                
   DEFINE   ls_msg_o        STRING
   DEFINE   ls_msg_n        STRING
   DEFINE   l_num           LIKE type_file.num5  
   DEFINE   l_check         LIKE type_file.chr1
   DEFINE   l_string        STRING
   DEFINE   l_i             LIKE type_file.num5
   DEFINE   l_abo04      LIKE abo_file.abo04
   DEFINE   l_abo05      LIKE abo_file.abo05
   DEFINE   l_aag02    LIKE aag_file.aag02,
            l_aag07    LIKE aag_file.aag07,
            l_aag13    LIKE aag_file.aag13,
            l_aagacti  LIKE aag_file.aagacti
   DEFINE   p_c        LIKE type_file.chr1

   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_abo00) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
 
   LET g_forupd_sql= "SELECT abo01,abo02,abo03,abo04,abo05,abo06 ",
                     "  FROM abo_file ",
                     "  WHERE abo00 = ? AND abo01 = ?  ",
                       " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i900_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   IF g_rec_b=0 THEN CALL g_abo.clear() END IF
 
   INPUT ARRAY g_abo WITHOUT DEFAULTS FROM s_abo.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         LET g_before_input_done = FALSE
         LET g_before_input_done = TRUE
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_abo_t.* = g_abo[l_ac].*    #BACKUP
            OPEN i900_bcl USING g_abo00,g_abo[l_ac].abo01
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN i900_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH i900_bcl INTO g_abo[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH i900_bcl:',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               
               END IF
            END IF
            CALL cl_show_fld_cont()    
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_abo[l_ac].* TO NULL       
         LET g_abo_t.* = g_abo[l_ac].*          
         CALL cl_show_fld_cont()     
         NEXT FIELD abo01
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         INSERT INTO abo_file(abo00,abo01,abo02,abo03,abo04,abo05,abo06)
                      VALUES (g_abo00,g_abo[l_ac].abo01,g_abo[l_ac].abo02,g_abo[l_ac].abo03,
                              g_abo[l_ac].abo04,g_abo[l_ac].abo05,g_abo[l_ac].abo06)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","abo_file",g_abo00,g_abo_t.abo01,SQLCA.sqlcode,"","",0)
            CANCEL INSERT
         ELSE
            
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
    
 
      AFTER FIELD abo01
         IF NOT cl_null(g_abo[l_ac].abo01) THEN
            IF g_abo[l_ac].abo01 != g_abo_t.abo01 OR g_abo_t.abo01 IS NULL THEN
            LET l_string = g_abo[l_ac].abo01
            LET l_string = l_string.trim()
            LET l_num = l_string.getLength()
         FOR l_i = 1 TO l_num
            LET l_check = l_string.getCharAt(l_i)
               IF l_check NOT MATCHES "[a-zA-Z]" THEN 
                  CALL cl_err('该变量代码不符合规格','!',0)
                  NEXT FIELD abo01
               EXIT FOR     
               END IF
         END FOR
          SELECT COUNT(abo01) INTO l_count FROM abo_file WHERE abo01 = g_abo[l_ac].abo01
                                                                 AND abo00 = g_abo00
            IF l_count > 0 THEN
               CALL cl_err(g_abo[l_ac].abo01,-239,0)
               LET g_abo[l_ac].abo01 = g_abo_t.abo01
               NEXT FIELD abo01
         END IF                         
      END IF
   END IF     
              

      BEFORE FIELD abo03
        IF cl_null(g_abo[l_ac].abo03) THEN
           LET g_abo[l_ac].abo03 = '1'
        END IF   
 
      AFTER FIELD abo03
         IF cl_null(g_abo[l_ac].abo03) THEN
            CALL cl_err('正常余额不为空','!',0)
               NEXT FIELD abo03
         END IF      
 
      AFTER FIELD abo04
         IF cl_null(g_abo[l_ac].abo04) THEN
            CALL cl_err('科目编号不能为空','!',0)
            NEXT FIELD abo04
         ELSE
            SELECT COUNT(*) INTO l_num FROM aag_file WHERE aag01 = g_abo[l_ac].abo04
               IF l_num = 0 THEN
                  CALL cl_err('该科目不存在','!',0)
                     NEXT FIELD abo04
               ELSE
               CALL i900_abo04(g_abo[l_ac].abo04)
             
                 IF NOT cl_null(g_errno) THEN
                 CALL cl_err('sel aag:',g_errno,0)
                 NEXT FIELD abo04
                 END IF
              END IF
          END IF

                  IF cl_null(g_abo[l_ac].abo05) THEN
                     LET g_abo[l_ac].abo05 = g_abo[l_ac].abo04
                        DISPLAY BY NAME g_abo[l_ac].abo05
                  END IF
       

       AFTER FIELD abo05
          IF NOT cl_null(g_abo[l_ac].abo05) THEN
             SELECT COUNT(*) INTO l_num FROM aag_file WHERE aag01 = g_abo[l_ac].abo05
                                                      
                IF l_num = 0 THEN
                   CALL cl_err('该科目不存在','!',0)
                      NEXT FIELD abo05
                ELSE
                   CALL i900_abo04(g_abo[l_ac].abo05)
                      IF NOT cl_null(g_errno) THEN
                         CALL cl_err('sel aag:',g_errno,0)
                      NEXT FIELD abo05
                      END IF
               END IF 
          END IF
             
 
      BEFORE DELETE                            
         IF NOT cl_null(g_abo_t.abo01) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
           
            DELETE FROM abo_file WHERE abo00 = g_abo00
                                      AND abo01 = g_abo[l_ac].abo01
                                              
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","abo_file",g_abo00,g_abo_t.abo01,SQLCA.sqlcode,"","",0)  
               ROLLBACK WORK
               CANCEL DELETE
            
            END IF 
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_abo[l_ac].* = g_abo_t.*
            CLOSE i900_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
        
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_abo[l_ac].abo02,-263,1)
            LET g_abo[l_ac].* = g_abo_t.*
         ELSE
            UPDATE abo_file
               SET abo01 = g_abo[l_ac].abo01,
                   abo02 = g_abo[l_ac].abo02,
                   abo03 = g_abo[l_ac].abo03,
                   abo04 = g_abo[l_ac].abo04,  
                   abo05 = g_abo[l_ac].abo05,
                   abo06 = g_abo[l_ac].abo06
             WHERE abo00 = g_abo00
               AND abo01 = g_abo_t.abo01
                          
            IF SQLCA.sqlcode THEN
               
               CALL cl_err3("upd","abo_file",g_abo00,g_abo_t.abo01,SQLCA.sqlcode,"","",0)   
               LET g_abo[l_ac].* = g_abo_t.*
             
            ELSE    
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
        
            END IF
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac

 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_abo[l_ac].* = g_abo_t.*
            END IF
            CLOSE i900_bcl
            ROLLBACK WORK
#            IF p_c = "c" THEN
#               DELETE FROM abo_file WHERE abo00 = g_abo00 
#            END IF
            EXIT INPUT
         END IF


#         CALL i900_abo04(g_abo[l_ac].abo04)
#            IF NOT cl_null(g_errno) THEN
#               CALL cl_err(g_abo[l_ac].abo04,'该套帐没有此起始科目!',0)
#               NEXT FIELD abo04 
#             ROLLBACK WORK
#            END IF
#         CALL i900_abo04(g_abo[l_ac].abo05)
#            IF NOT cl_null(g_errno) THEN
#               CALL cl_err(g_abo[l_ac].abo05,'该套帐没有此截止科目!',0)
#               NEXT FIELD abo05 
#             ROLLBACK WORK
#            END IF   

      ON ACTION controlp
         CASE
            WHEN INFIELD(abo04)
               CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag"     
                  LET g_qryparam.default1 = g_abo[l_ac].abo04
                  LET g_qryparam.arg1 = g_abo00
                  CALL cl_create_qry() RETURNING g_abo[l_ac].abo04
                  DISPLAY BY NAME g_abo[l_ac].abo04          
                  NEXT FIELD abo04
            WHEN INFIELD(abo05)
               CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag"     
                  LET g_qryparam.default1 = g_abo[l_ac].abo05
                  LET g_qryparam.arg1 = g_abo00
                  CALL cl_create_qry() RETURNING g_abo[l_ac].abo05
                  DISPLAY BY NAME g_abo[l_ac].abo05          
                  NEXT FIELD abo05
               OTHERWISE 
            EXIT CASE
        END CASE                  
          
      ON ACTION CONTROLO                       
         IF INFIELD(abo01) AND l_ac > 1 THEN
            LET g_abo[l_ac].* = g_abo[l_ac-1].*
            NEXT FIELD abo01
         END IF
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
   
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION about
         CALL cl_about()
                                                                                       
   
 
   END INPUT
 
   CLOSE i900_bcl
   COMMIT WORK
END FUNCTION

FUNCTION i900_b_fill(p_wc)               
 
   DEFINE p_wc         STRING 
 

 
    LET g_sql = "SELECT abo01,abo02,abo03,abo04,abo05,abo06 ",
                 " FROM abo_file ",
                " WHERE abo00 = '",g_abo00 CLIPPED,"' ",
                  " AND ",p_wc CLIPPED,
                " ORDER BY abo01"
 
    PREPARE i900_prepare2 FROM g_sql           
    DECLARE abo_curs CURSOR FOR i900_prepare2
 
    CALL g_abo.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH abo_curs INTO g_abo[g_cnt].*       
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_abo.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION i900_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL SET_COUNT(g_rec_b)
   DISPLAY ARRAY g_abo TO s_abo.* ATTRIBUTE(UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   
 
      ON ACTION insert                           
         LET g_action_choice='insert'
         EXIT DISPLAY
 
      ON ACTION query                           
         LET g_action_choice='query'
         EXIT DISPLAY
 
      ON ACTION modify                           
         LET g_action_choice='modify'
         EXIT DISPLAY
 
      ON ACTION reproduce                        
         LET g_action_choice='reproduce'
         EXIT DISPLAY
 
      ON ACTION delete                           
         LET g_action_choice='delete'
         EXIT DISPLAY
 
      ON ACTION detail                           
         LET g_action_choice='detail'
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION first                            
         CALL i900_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1) 
         END IF
           ACCEPT DISPLAY                   
 
      ON ACTION previous                        
         CALL i900_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  
         END IF
	ACCEPT DISPLAY                 
 
      ON ACTION jump                            
         CALL i900_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
         END IF
	ACCEPT DISPLAY                 
 
      ON ACTION next                            
         CALL i900_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	ACCEPT DISPLAY                   
 
      ON ACTION last                         
         CALL i900_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
	ACCEPT DISPLAY                   
 
       ON ACTION help                            
          LET g_action_choice='help'
          EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   
 
         EXIT DISPLAY
 
      ON ACTION exit                             
         LET g_action_choice='exit'
         EXIT DISPLAY
 
      ON ACTION close
         LET g_action_choice='exit'
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION exporttoexcel       
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
 #      ON ACTION showlog            
 #        LET g_action_choice = "showlog"
 #        EXIT DISPLAY
 
      
      AFTER DISPLAY
         CONTINUE DISPLAY
      
 
                                                                                            
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
    
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i900_copy()
DEFINE
   l_n                LIKE type_file.num5,          
   l_cnt              LIKE type_file.num10,          
   l_newno1,l_oldno1  LIKE abo_file.abo01
   
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_abo00) THEN
      CALL cl_err('',-400,1)
   END IF
 
  
   CALL cl_set_head_visible("","YES")   
 
   INPUT l_newno1  FROM  abo00
      AFTER FIELD abo00
         IF l_newno1 IS NULL THEN
            NEXT FIELD abo00
         END IF
      SELECT COUNT(*) INTO g_cnt FROM abo_file WHERE abo00 = l_newno1
         IF g_cnt > 0 THEN
            CALL cl_err(l_newno1,-239,0)
            NEXT FIELD abo00
         END IF
       
      SELECT COUNT(aaa01) INTO l_n FROM aaa_file WHERE aaa01 = l_newno1
                                                   AND aaaacti = 'Y'
         IF l_n = 0 THEN
            CALL cl_err('该帐套不存在','!',0)
            NEXT FIELD abo00
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF


      ON ACTION controlp
         CASE
            WHEN INFIELD(abo00)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_aaa"
            LET g_qryparam.default1 = l_newno1
            CALL cl_create_qry() RETURNING l_newno1
            DISPLAY l_newno1 TO abo00
            NEXT FIELD abo00
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

     IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_abo00 TO abo00
      RETURN
   END IF
 
   DROP TABLE i900_x
 
   SELECT * FROM abo_file             #單身複製
    WHERE abo00 = g_abo00
     INTO TEMP i900_x
   IF SQLCA.sqlcode THEN
      LET g_msg=l_newno1 CLIPPED
      CALL cl_err3("ins","i900_x",g_abo00,' ',SQLCA.sqlcode,"","",1)
      RETURN
   END IF
 
   UPDATE i900_x SET abo00=l_newno1
   
 
   INSERT INTO abo_file SELECT * FROM i900_x
   IF SQLCA.sqlcode THEN
      LET g_msg=l_newno1 CLIPPED
      CALL cl_err3("ins","abo_file",l_newno1,' ',SQLCA.sqlcode,"",g_msg,1)
      RETURN
   END IF
   LET g_msg=l_newno1 CLIPPED
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
 
   LET l_oldno1 = g_abo00
   LET g_abo00 = l_newno1
   IF g_abo00 != l_oldno1 THEN
      CALL cl_err(g_abo00,'agl-502',1)
   END IF
   CALL i900_b("c")
 
   LET g_abo00 = l_oldno1
   CALL i900_show()
   DISPLAY BY NAME g_abo00
 
END FUNCTION

FUNCTION i900_abo04(p_code)
DEFINE p_code     LIKE aag_file.aag01,
       l_aag02    LIKE aag_file.aag02,
       l_aag07    LIKE aag_file.aag07,
       l_aag13    LIKE aag_file.aag13,
       l_aagacti  LIKE aag_file.aagacti
    
 
   SELECT aag02,aag07,aag13,aagacti INTO l_aag02,l_aag07,l_aag13,l_aagacti
     FROM aag_file WHERE aag01=p_code
                     AND aag00=g_abo00
 
   CASE
      WHEN SQLCA.sqlcode   LET l_aag02  = NULL LET l_aag13  = NULL
                           LET g_errno = 'agl-001'
      WHEN l_aagacti = 'N' LET g_errno = '9028'
      WHEN l_aag07 = '1'   LET g_errno = 'agl-134' #不可輸入統制科目!
      OTHERWISE            LET g_errno = SQLCA.sqlcode USING '----------'
   END CASE
END FUNCTION
