# Prog. Version..: '5.30.06-13.04.22(00003)'     #
# Pattern name...: aglt010.4gl
# Descriptions...: 現金流量表直接法抵消设置
# Date & Author..: 2010/11/16 By wuxj   
# Modify.........: NO.FUN-B40104 11/05/05 By jll   #合并报表回收产品
# Modify.........: No.TQC-B70139 11/07/19 By guoch 查詢時，合并帳套取值錯誤
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"
DEFINE   g_aeq      RECORD LIKE aeq_file.*
DEFINE   g_aeq_t    RECORD LIKE aeq_file.*
DEFINE   g_aeq01_1  LIKE axa_file.axa02
DEFINE   g_aeq01_2  LIKE axa_file.axa03
DEFINE   g_aeq1     DYNAMIC ARRAY OF RECORD
          aeq02      LIKE aeq_file.aeq02,
          aeq06      LIKE aeq_file.aeq06,
          aeq06_1    LIKE nml_file.nml02,
          aeq07      LIKE aeq_file.aeq07,
          aeq08      LIKE aeq_file.aeq08,
          aeq03      LIKE aeq_file.aeq03,
          aeq09      LIKE aeq_file.aeq09,
          aeq09_1    LIKE nml_file.nml02,
          aeq10      LIKE aeq_file.aeq10,
          aeq11      LIKE aeq_file.aeq11
                    END RECORD
DEFINE   g_aeq1_t   RECORD
          aeq02      LIKE aeq_file.aeq02,
          aeq06      LIKE aeq_file.aeq06,
          aeq06_1    LIKE nml_file.nml02,
          aeq07      LIKE aeq_file.aeq07,
          aeq08      LIKE aeq_file.aeq08,
          aeq03      LIKE aeq_file.aeq03,
          aeq09      LIKE aeq_file.aeq09,
          aeq09_1    LIKE nml_file.nml02,
          aeq10      LIKE aeq_file.aeq10,
          aeq11      LIKE aeq_file.aeq11
                    END RECORD
DEFINE    p_cmd      LIKE type_file.chr1 
DEFINE    l_table    STRING 
DEFINE    g_str      STRING
DEFINE    g_sql      STRING
DEFINE    g_rec_b    LIKE type_file.num10
DEFINE    g_wc       STRING 
DEFINE    l_ac       LIKE type_file.num5
DEFINE    g_sql_tmp  STRING

#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5   
DEFINE   g_cnt           LIKE type_file.num10    
DEFINE   g_i             LIKE type_file.num5    
DEFINE   g_msg           LIKE ze_file.ze03     
DEFINE   g_row_count     LIKE type_file.num10 
DEFINE   g_curs_index    LIKE type_file.num10
DEFINE   g_jump          LIKE type_file.num10 
DEFINE   mi_no_ask       LIKE type_file.num5 
DEFINE   g_dbs_axz03     LIKE axz_file.axz03  #TQC-B70139 add


MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT          

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   OPEN WINDOW t010_w AT 5,10
        WITH FORM "agl/42f/aglt010" ATTRIBUTE(STYLE = g_win_style)              
                                                                                
   CALL cl_ui_init()                                                           

   CALL t010_menu()                                                            
   CLOSE WINDOW t010_w 

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION t010_cs()
   CLEAR FORM                                   #清除畫面
   CALL g_aeq1.clear()
   CALL cl_set_head_visible("","YES")     

   CONSTRUCT g_wc ON aeq01,aeq04,aeq05,aeq02,aeq06,aeq07,aeq08,aeq03,aeq09,aeq10,aeq11     
                FROM aeq01,aeq04,aeq05,s_aeq1[1].aeq02,s_aeq1[1].aeq06,s_aeq1[1].aeq07,
                     s_aeq1[1].aeq08,s_aeq1[1].aeq03,s_aeq1[1].aeq09,s_aeq1[1].aeq10,s_aeq1[1].aeq11

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION controlp                 # 沿用所有欄位
         CASE
          WHEN INFIELD(aeq01)                                                                                                 
             CALL cl_init_qry_var()                                                                                           
             LET g_qryparam.state = "c"                                                                                       
             LET g_qryparam.form ="q_aeq01"                                                                                   
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aeq01                                                                             
             NEXT FIELD aeq01
          WHEN INFIELD(aeq02)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aeq02"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aeq02           
             NEXT FIELD aeq02
          WHEN INFIELD(aeq06)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aeq06"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aeq06
             NEXT FIELD aeq06
          WHEN INFIELD(aeq03)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aeq03"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aeq03       
             NEXT FIELD aeq03
          WHEN INFIELD(aeq09)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aeq09"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aeq09
             NEXT FIELD aeq09
          OTHERWISE
             EXIT CASE
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


                #No:FUN-580031 --start--     HCN
                 ON ACTION qbe_select
                   CALL cl_qbe_select()
                 ON ACTION qbe_save
                   CALL cl_qbe_save()
                #No:FUN-580031 --end--       HCN
   END CONSTRUCT

   IF INT_FLAG THEN RETURN END IF
   LET g_sql="SELECT UNIQUE aeq01,aeq04,aeq05 FROM aeq_file ",
             " WHERE ", g_wc CLIPPED,
             " ORDER BY aeq01,aeq04,aeq05 "
   PREPARE t010_prepare FROM g_sql              #預備一下
   DECLARE t010_b_cs                            #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR t010_prepare
                                                #計算本次查詢單頭的筆數
   LET g_sql_tmp= "SELECT UNIQUE aeq01,aeq04,aeq05 FROM aeq_file ",                                                     
                  " WHERE ",g_wc CLIPPED,                                                                                     
                  "   INTO TEMP x"                                                                                            
   DROP TABLE x                                                                                                               
   PREPARE t010_pre_x FROM g_sql_tmp
   EXECUTE t010_pre_x                                                                                                         
   LET g_sql = "SELECT COUNT(*) FROM x"                                                                                       
   PREPARE t010_precount FROM g_sql
   DECLARE t010_count CURSOR FOR t010_precount
END FUNCTION

FUNCTION t010_menu()
   WHILE TRUE
      CALL t010_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t010_a()
            END IF
     #   WHEN "modify"
     #      IF cl_chk_act_auth() THEN
     #         CALL t010_u()
     #      END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t010_r()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t010_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t010_q() 
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
          #    CALL t010_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aeq1),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION t010_a()
   DEFINE li_chk_bookno  LIKE type_file.num5  
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_sw           LIKE type_file.chr1, 
          l_cmd          LIKE type_file.chr1000, 
          l_n            LIKE type_file.num5

   IF s_shut(0) THEN RETURN END IF                #檢查權限
   MESSAGE ""
   INITIALIZE g_aeq.* TO NULL 
   CLEAR FORM
   CALL g_aeq1.clear()
   CALL cl_opmsg('a')

   WHILE TRUE
      CALL t010_i("a")                           #輸入單頭
      IF INT_FLAG THEN                           #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      CALL g_aeq1.clear()
      SELECT COUNT(*) INTO l_n FROM aeq_file WHERE aeq01=g_aeq.aeq01
                                               AND aeq04=g_aeq.aeq04 
                                               AND aeq05=g_aeq.aeq05
      LET g_rec_b = 0 
      IF l_n > 0 THEN
         CALL t010_b_fill('1=1')
      END IF
      CALL t010_b()                             #輸入單身
      LET g_aeq_t.aeq01 = g_aeq.aeq01           #保留舊值                          
      LET g_aeq_t.aeq04 = g_aeq.aeq04           #保留舊值
      LET g_aeq_t.aeq05 = g_aeq.aeq05           #保留舊值 
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION t010_i(p_cmd)
DEFINE
   p_cmd           LIKE type_file.chr1,         #a:輸入 u:更改 
   l_cnt           LIKE type_file.num5,       
   l_n1,l_n        LIKE type_file.num5,
   l_axa02         LIKE axa_file.axa02,
   l_axa03         LIKE axa_file.axa03       

      CALL cl_set_head_visible("","YES")
      INPUT BY NAME g_aeq.aeq01,g_aeq.aeq04,g_aeq.aeq05 WITHOUT DEFAULTS
 
         BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t010_set_entry(p_cmd)
            CALL t010_set_no_entry(p_cmd)
            CALL cl_qbe_init()

 
         AFTER FIELD aeq01
            IF NOT cl_null(g_aeq.aeq01) THEN
               SELECT COUNT(*) INTO l_n FROM axa_file WHERE axa01 = g_aeq.aeq01 AND axa04 = 'Y'
               IF l_n = 0 THEN 
                  CALL cl_err(g_aeq.aeq01,100,0)
                  NEXT FIELD aeq01
               END IF
               SELECT axa02,axa03 INTO l_axa02,l_axa03 FROM axa_file WHERE axa01 = g_aeq.aeq01 AND axa04 = 'Y' 
               DISPLAY l_axa02 TO FORMONLY.aeq01_1
               DISPLAY l_axa03 TO FORMONLY.aeq01_2
            ELSE 
               NEXT FIELD aeq01
            END IF

         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF

         ON ACTION controlp                 # 沿用所有欄位
            CASE
              WHEN INFIELD(aeq01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axa1"
               LET g_qryparam.default1 = g_aeq.aeq01 
               CALL cl_create_qry() RETURNING g_aeq.aeq01 
               DISPLAY BY NAME g_aeq.aeq01
               NEXT FIELD aeq01
            END CASE

         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
          ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
 
          ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121
 
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
      END INPUT
END FUNCTION

FUNCTION t010_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_aeq.* TO NULL      

   MESSAGE ""
   CALL cl_opmsg('q')
   CALL t010_cs()                         #取得查詢條件
   IF INT_FLAG THEN                       #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN t010_b_cs                           #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                    #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_aeq.* TO NULL
   ELSE
      CALL t010_fetch('F')               #讀出TEMP第一筆並顯示
      OPEN t010_count
      FETCH t010_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
   END IF
END FUNCTION

FUNCTION t010_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680098 VARCHAR(1)
   l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680098 INTEGER

   MESSAGE ""
   CASE p_flag
       WHEN 'N' FETCH NEXT     t010_b_cs INTO g_aeq.aeq01,g_aeq.aeq04,g_aeq.aeq05
       WHEN 'P' FETCH PREVIOUS t010_b_cs INTO g_aeq.aeq01,g_aeq.aeq04,g_aeq.aeq05
       WHEN 'F' FETCH FIRST    t010_b_cs INTO g_aeq.aeq01,g_aeq.aeq04,g_aeq.aeq05
       WHEN 'L' FETCH LAST     t010_b_cs INTO g_aeq.aeq01,g_aeq.aeq04,g_aeq.aeq05
       WHEN '/'
            IF (NOT mi_no_ask) THEN
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
            IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump t010_b_cs INTO g_aeq.aeq01,g_aeq.aeq04,g_aeq.aeq05                                
            LET mi_no_ask = FALSE
   END CASE
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_aeq.aeq01,SQLCA.sqlcode,0)   
      INITIALIZE g_aeq.* TO NULL 
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

   CALL t010_show()
END FUNCTION

#將資料顯示在畫面上
FUNCTION t010_show()
DEFINE l_axa02    LIKE axa_file.axa02
DEFINE l_axa03    LIKE axa_file.axa03
DEFINE g_aaw01    LIKE aaw_file.aaw01  #TQC-B70139 add
   SELECT axa02,axa03 INTO l_axa02,l_axa03 FROM axa_file WHERE axa01 = g_aeq.aeq01 AND axa04 = 'Y'
   DISPLAY l_axa02 TO FORMONLY.aeq01_1
 #  DISPLAY l_axa03 TO FORMONLY.aeq01_2  TQC-B70139 mark
   #TQC-B70139 -begin
   CALL s_aaz641_dbs(g_aeq.aeq01,l_axa02) RETURNING g_dbs_axz03
   CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaw01
   DISPLAY g_aaw01 TO FORMONLY.aeq01_2
   #TQC-B70139 -end
   DISPLAY BY NAME g_aeq.*              
   DISPLAY g_aeq.aeq01 TO aeq01    #NO.FUN-B40104
   DISPLAY g_aeq.aeq04 TO aeq04    
   DISPLAY g_aeq.aeq05 TO aeq05
   CALL t010_b_fill(g_wc)             #單身
   CALL cl_show_fld_cont()  
END FUNCTION

#單身
FUNCTION t010_b()
DEFINE
   l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT   
   l_n             LIKE type_file.num5,     #檢查重複用    
   l_n1            LIKE type_file.num5,
   l_n2            LIKE type_file.num5,
   l_lock_sw       LIKE type_file.chr1,     #單身鎖住否   
   p_cmd           LIKE type_file.chr1,     #處理狀態    
   l_aeq_delyn     LIKE type_file.chr1,     #判斷是否可以刪除單身資料ROW 
   l_chr           LIKE type_file.chr1,   
   l_allow_insert  LIKE type_file.num5,     #可新增否     
   l_allow_delete  LIKE type_file.num5      #可刪除否    

   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF        #檢查權限
   IF cl_null(g_aeq.aeq01) OR cl_null(g_aeq.aeq04) OR cl_null(g_aeq.aeq05) THEN
       RETURN
   END IF

   CALL cl_opmsg('b')                #單身處理的操作提示

   LET g_forupd_sql = "SELECT aeq02,aeq06,'',aeq07,aeq08,aeq03,aeq09,'',aeq10,aeq11 FROM aeq_file",
                      " WHERE aeq01 = ? AND aeq02=? AND aeq03=? AND aeq04=? AND aeq05=? AND aeq06=? AND aeq09=?",
                      "   FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)  
 
   DECLARE t010_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_aeq1 WITHOUT DEFAULTS FROM s_aeq1.*
      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         LET g_action_choice = ""
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         CALL cl_set_comp_entry("aeq10",FALSE)

      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET  g_before_input_done = FALSE
            CALL t010_set_entry(p_cmd)
            CALL t010_set_no_entry(p_cmd)
            LET  g_before_input_done = TRUE
            BEGIN WORK
            LET p_cmd='u'
            LET g_aeq1_t.* = g_aeq1[l_ac].*  #BACKUP
            OPEN t010_bcl USING g_aeq.aeq01,g_aeq1[l_ac].aeq02,g_aeq1[l_ac].aeq03,g_aeq.aeq04,
                                g_aeq.aeq05,g_aeq1[l_ac].aeq06,g_aeq1[l_ac].aeq09
            IF STATUS THEN
               CALL cl_err("OPEN t010_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t010_bcl INTO g_aeq1[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_aeq1_t.aeq02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               SELECT nml02 INTO g_aeq1[l_ac].aeq06_1 FROM nml_file WHERE nml01 = g_aeq1[l_ac].aeq06
               SELECT nml02 INTO g_aeq1[l_ac].aeq09_1 FROM nml_file WHERE nml01 = g_aeq1[l_ac].aeq09
            END IF
            CALL cl_show_fld_cont()
         END IF

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_aeq1[l_ac].* TO NULL
         LET g_aeq1[l_ac].aeq08 = 0
         LET g_aeq1_t.* = g_aeq1[l_ac].* 
         CALL cl_show_fld_cont() 
         NEXT FIELD aeq02

      AFTER INSERT
         IF INT_FLAG THEN 
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
            CLOSE t010_bcl
         END IF
         INSERT INTO aeq_file VALUES(g_aeq.aeq01,g_aeq1[l_ac].aeq02,g_aeq1[l_ac].aeq03,g_aeq.aeq04,g_aeq.aeq05,
                                     g_aeq1[l_ac].aeq06,g_aeq1[l_ac].aeq07,g_aeq1[l_ac].aeq08,g_aeq1[l_ac].aeq09,
                                     g_aeq1[l_ac].aeq10,g_aeq1[l_ac].aeq11,g_legal)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","aeq_file",g_aeq1[l_ac].aeq02,"",SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
         END IF

      AFTER FIELD aeq02
         IF g_aeq1[l_ac].aeq02 != g_aeq1_t.aeq02 OR
            cl_null(g_aeq1_t.aeq02) THEN
            SELECT COUNT(*) INTO l_n FROM axz_file where axz01 = g_aeq1[l_ac].aeq02
            IF l_n = 0 THEN
               CALL cl_err(g_aeq1[l_ac].aeq02,100,0)
               NEXT FIELD aeq02
            END IF
            IF NOT cl_null(g_aeq1[l_ac].aeq02) AND NOT cl_null(g_aeq1[l_ac].aeq03) AND NOT cl_null(g_aeq1[l_ac].aeq06)
               AND NOT cl_null(g_aeq1[l_ac].aeq09) THEN
               SELECT COUNT(*) INTO l_n FROM aeq_file WHERE aeq01 = g_aeq.aeq01 AND aeq02 = g_aeq1[l_ac].aeq02
                  AND aeq03 = g_aeq1[l_ac].aeq03 AND aeq04 = g_aeq.aeq04 AND aeq05 = g_aeq.aeq05
                  AND aeq06 = g_aeq1[l_ac].aeq06 AND aeq09 = g_aeq1[l_ac].aeq09
               IF l_n > 0 THEN
                  LET g_aeq1[l_ac].aeq02 = g_aeq1_t.aeq02
                  CALL cl_err('','-239',0)
                  NEXT FIELD aeq02
               END IF
            END IF 
         END IF 

      AFTER FIELD aeq06                        #check 編號是否重複
         IF g_aeq1[l_ac].aeq06 != g_aeq1_t.aeq06 OR
            cl_null(g_aeq1_t.aeq06) THEN
            SELECT COUNT(*) INTO l_n FROM nml_file 
             WHERE nml01 = g_aeq1[l_ac].aeq06
            IF l_n = 0 THEN 
               CALL cl_err(g_aeq1[l_ac].aeq06,100,0)
               NEXT FIELD aeq06
            END IF
            SELECT COUNT(*) INTO l_n FROM aeq_file
             WHERE aeq06 = g_aeq1[l_ac].aeq06
            IF l_n > 0 THEN    #科目已存在其他群組中
               IF NOT cl_confirm('agl-919') THEN
                  NEXT FIELD aeq06
               END IF
            END IF
            IF NOT cl_null(g_aeq1[l_ac].aeq02) AND NOT cl_null(g_aeq1[l_ac].aeq03) AND NOT cl_null(g_aeq1[l_ac].aeq06)
               AND NOT cl_null(g_aeq1[l_ac].aeq09) THEN
               SELECT COUNT(*) INTO l_n FROM aeq_file WHERE aeq01 = g_aeq.aeq01 AND aeq02 = g_aeq1[l_ac].aeq02
                  AND aeq03 = g_aeq1[l_ac].aeq03 AND aeq04 = g_aeq.aeq04 AND aeq05 = g_aeq.aeq05
                  AND aeq06 = g_aeq1[l_ac].aeq06 AND aeq09 = g_aeq1[l_ac].aeq09
               IF l_n > 0 THEN
                  LET g_aeq1[l_ac].aeq06 = g_aeq1_t.aeq06
                  CALL cl_err('','-239',0)
                  NEXT FIELD aeq06
               END IF
            END IF
            SELECT nml02 INTO g_aeq1[l_ac].aeq06_1 FROM nml_file
             WHERE nml01 = g_aeq1[l_ac].aeq06
         END IF
         IF NOT cl_null(g_aeq1[l_ac].aeq06) AND NOT cl_null(g_aeq1[l_ac].aeq09) THEN
            SELECT COUNT(*) INTO l_n1 FROM nml_file WHERE nml01 = g_aeq1[l_ac].aeq06 AND nml03 IN('10','20','30','40')
            SELECT COUNT(*) INTO l_n2 FROM nml_file WHERE nml01 = g_aeq1[l_ac].aeq09 AND nml03 IN('10','20','30','40')
            IF l_n1 > 0 AND l_n2 > 0 THEN
               IF g_aeq1[l_ac].aeq07 = '+' THEN
                  LET g_aeq1[l_ac].aeq10 = '-'
               END IF
               IF g_aeq1[l_ac].aeq07 = '-' THEN
                  LET g_aeq1[l_ac].aeq10 = '+'
               END IF
            ELSE
               IF g_aeq1[l_ac].aeq07 = '+' THEN
                  LET g_aeq1[l_ac].aeq10 = '+'
               END IF
               IF g_aeq1[l_ac].aeq07 = '-' THEN
                  LET g_aeq1[l_ac].aeq10 = '-'
               END IF
            END IF
         END IF

      AFTER FIELD aeq07 
         IF NOT cl_null(g_aeq1[l_ac].aeq06) AND NOT cl_null(g_aeq1[l_ac].aeq09) THEN 
            SELECT COUNT(*) INTO l_n1 FROM nml_file WHERE nml01 = g_aeq1[l_ac].aeq06 AND nml03 IN('10','20','30','40')
            SELECT COUNT(*) INTO l_n2 FROM nml_file WHERE nml01 = g_aeq1[l_ac].aeq09 AND nml03 IN('10','20','30','40')
            IF l_n1 > 0 AND l_n2 > 0 THEN
               IF g_aeq1[l_ac].aeq07 = '+' THEN
                  LET g_aeq1[l_ac].aeq10 = '-'
               END IF
               IF g_aeq1[l_ac].aeq07 = '-' THEN 
                  LET g_aeq1[l_ac].aeq10 = '+'
               END IF 
            ELSE
               IF g_aeq1[l_ac].aeq07 = '+' THEN
                  LET g_aeq1[l_ac].aeq10 = '+'
               END IF
               IF g_aeq1[l_ac].aeq07 = '-' THEN
                  LET g_aeq1[l_ac].aeq10 = '-'
               END IF
            END IF 
         END IF 

      AFTER FIELD aeq08 
         IF g_aeq1[l_ac].aeq08 < 0  THEN 
            CALL cl_err(g_aeq1[l_ac].aeq08,'',0)
            NEXT FIELD aeq08
         END IF

      AFTER FIELD aeq03
         IF g_aeq1[l_ac].aeq03 != g_aeq1_t.aeq03 OR
            cl_null(g_aeq1_t.aeq03) THEN
            SELECT COUNT(*) INTO l_n FROM axz_file where axz01 = g_aeq1[l_ac].aeq03
            IF l_n = 0 THEN
               CALL cl_err(g_aeq1[l_ac].aeq03,100,0)
               NEXT FIELD aeq03
            END IF
            IF NOT cl_null(g_aeq1[l_ac].aeq02) AND NOT cl_null(g_aeq1[l_ac].aeq03) AND NOT cl_null(g_aeq1[l_ac].aeq06)
               AND NOT cl_null(g_aeq1[l_ac].aeq09) THEN
               SELECT COUNT(*) INTO l_n FROM aeq_file WHERE aeq01 = g_aeq.aeq01 AND aeq02 = g_aeq1[l_ac].aeq02
                  AND aeq03 = g_aeq1[l_ac].aeq03 AND aeq04 = g_aeq.aeq04 AND aeq05 = g_aeq.aeq05
                  AND aeq06 = g_aeq1[l_ac].aeq06 AND aeq09 = g_aeq1[l_ac].aeq09
               IF l_n > 0 THEN
                  LET g_aeq1[l_ac].aeq03 = g_aeq1_t.aeq03
                  CALL cl_err('','-239',0)
                  NEXT FIELD aeq03
               END IF
            END IF
         END IF

      AFTER FIELD aeq09                        #check 編號是否重複
         IF g_aeq1[l_ac].aeq09 != g_aeq1_t.aeq09 OR
            cl_null(g_aeq1_t.aeq09) THEN
            SELECT COUNT(*) INTO l_n FROM nml_file
             WHERE nml01 = g_aeq1[l_ac].aeq09
            IF l_n = 0 THEN
               CALL cl_err(g_aeq1[l_ac].aeq09,100,0)
               NEXT FIELD aeq09
            END IF
            SELECT COUNT(*) INTO l_n FROM aeq_file
             WHERE aeq09 = g_aeq1[l_ac].aeq09
            IF l_n > 0 THEN    #科目已存在其他群組中
               IF NOT cl_confirm('agl-919') THEN
                  NEXT FIELD aeq09
               END IF
            END IF
            IF NOT cl_null(g_aeq1[l_ac].aeq02) AND NOT cl_null(g_aeq1[l_ac].aeq03) AND NOT cl_null(g_aeq1[l_ac].aeq06)
               AND NOT cl_null(g_aeq1[l_ac].aeq09) THEN
               SELECT COUNT(*) INTO l_n FROM aeq_file WHERE aeq01 = g_aeq.aeq01 AND aeq02 = g_aeq1[l_ac].aeq02
                  AND aeq03 = g_aeq1[l_ac].aeq03 AND aeq04 = g_aeq.aeq04 AND aeq05 = g_aeq.aeq05
                  AND aeq06 = g_aeq1[l_ac].aeq06 AND aeq09 = g_aeq1[l_ac].aeq09
               IF l_n > 0 THEN
                  LET g_aeq1[l_ac].aeq09 = g_aeq1_t.aeq09
                  CALL cl_err('','-239',0)
                  NEXT FIELD aeq09
               END IF
            END IF
            SELECT nml02 INTO g_aeq1[l_ac].aeq09_1 FROM nml_file
             WHERE nml01 = g_aeq1[l_ac].aeq09
         END IF
         IF NOT cl_null(g_aeq1[l_ac].aeq06) AND NOT cl_null(g_aeq1[l_ac].aeq09) THEN
            SELECT COUNT(*) INTO l_n1 FROM nml_file WHERE nml01 = g_aeq1[l_ac].aeq06 AND nml03 IN('10','20','30','40')
            SELECT COUNT(*) INTO l_n2 FROM nml_file WHERE nml01 = g_aeq1[l_ac].aeq09 AND nml03 IN('10','20','30','40')
            IF l_n1 > 0 AND l_n2 > 0 THEN
               IF g_aeq1[l_ac].aeq07 = '+' THEN
                  LET g_aeq1[l_ac].aeq10 = '-'
               END IF
               IF g_aeq1[l_ac].aeq07 = '-' THEN
                  LET g_aeq1[l_ac].aeq10 = '+'
               END IF
            ELSE
               IF g_aeq1[l_ac].aeq07 = '+' THEN
                  LET g_aeq1[l_ac].aeq10 = '+'
               END IF
               IF g_aeq1[l_ac].aeq07 = '-' THEN
                  LET g_aeq1[l_ac].aeq10 = '-'
               END IF
            END IF
         END IF

      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_aeq1_t.aeq02) AND NOT cl_null(g_aeq1_t.aeq03) AND NOT cl_null(g_aeq1_t.aeq06)
            AND NOT cl_null(g_aeq1_t.aeq09) THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM aeq_file
             WHERE aeq01 = g_aeq.aeq01   
               AND aeq02 = g_aeq1_t.aeq02
               AND aeq03 = g_aeq1_t.aeq03
               AND aeq04 = g_aeq.aeq04
               AND aeq05 = g_aeq.aeq05
               AND aeq06 = g_aeq1_t.aeq06
               AND aeq09 = g_aeq1_t.aeq09
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","aeq_file",g_aeq1_t.aeq02,"",SQLCA.sqlcode,"","",1)
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF

      ON ROW CHANGE
         IF NOT cl_null(g_aeq1_t.aeq02) AND NOT cl_null(g_aeq1_t.aeq03) AND NOT cl_null(g_aeq1_t.aeq06)
            AND NOT cl_null(g_aeq1_t.aeq09) THEN 
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_aeq1[l_ac].aeq02,-263,1)
               LET g_aeq1[l_ac].* = g_aeq1_t.*
            ELSE
               UPDATE aeq_file SET aeq02 = g_aeq1[l_ac].aeq02,aeq03 = g_aeq1[l_ac].aeq03,
                                   aeq06 = g_aeq1[l_ac].aeq06,aeq07 = g_aeq1[l_ac].aeq07,
                                   aeq08 = g_aeq1[l_ac].aeq08,aeq09 = g_aeq1[l_ac].aeq09,
                                   aeq10 = g_aeq1[l_ac].aeq10,aeq11 = g_aeq1[l_ac].aeq11
                WHERE aeq01 = g_aeq.aeq01 AND aeq02 = g_aeq1_t.aeq02
                  AND aeq03 = g_aeq1_t.aeq03 AND aeq04 = g_aeq.aeq04
                  AND aeq05 = g_aeq.aeq05 AND aeq06 = g_aeq1_t.aeq06
                  AND aeq09 = g_aeq1_t.aeq09
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","aeq_file",g_aeq.aeq01,g_aeq1_t.aeq02,SQLCA.sqlcode,"","",1)
                  LET g_aeq1[l_ac].* = g_aeq1_t.*
               ELSE
                  CALL cl_msg('UPDATE O.K')
               END IF
            END IF
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac    #FUN-D30032 mark
        #IF p_cmd = 'u' THEN  #FUN-D30032 mark
        #   CLOSE t010_bcl    #FUN-D30032 mark
        #END IF               #FUN-D30032 mark
        #FUN-D30032--add--begin--
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_aeq1[l_ac].* = g_aeq1_t.*
            ELSE
               CALL g_aeq1.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            END IF
            CLOSE t010_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac
         CLOSE t010_bcl
         COMMIT WORK
        #FUN-D30032--add--end----
   
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(aeq02)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_axz"
              LET g_qryparam.default1 = g_aeq1[l_ac].aeq02
              CALL cl_create_qry() RETURNING g_aeq1[l_ac].aeq02
              NEXT FIELD aeq02
            WHEN INFIELD(aeq06)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_nml"
              LET g_qryparam.default1 = g_aeq1[l_ac].aeq06
              CALL cl_create_qry() RETURNING g_aeq1[l_ac].aeq06
              NEXT FIELD aeq06
            WHEN INFIELD(aeq03)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_axz"
              LET g_qryparam.default1 = g_aeq1[l_ac].aeq03
              CALL cl_create_qry() RETURNING g_aeq1[l_ac].aeq03
              NEXT FIELD aeq03
            WHEN INFIELD(aeq09)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_nml"
              LET g_qryparam.default1 = g_aeq1[l_ac].aeq09
              CALL cl_create_qry() RETURNING g_aeq1[l_ac].aeq09
              NEXT FIELD aeq09
            OTHERWISE
              EXIT CASE
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
#  IF INT_FLAG THEN
#     LET INT_FLAG = 0
#     CLOSE t010_bcl
#     ROLLBACK WORK
#     RETURN
#  END IF

   CLOSE t010_bcl
   COMMIT WORK
END FUNCTION

FUNCTION t010_b_fill(p_wc)              #BODY FILL UP
DEFINE
   p_wc            STRING,        
   l_flag          LIKE type_file.chr1,              #有無單身筆數     
   l_sql           STRING       

   LET l_sql = "SELECT aeq02,aeq06,'',aeq07,aeq08,aeq03,aeq09,'',aeq10,aeq11 FROM aeq_file ",
               " WHERE aeq01 = '",g_aeq.aeq01,"'",     
               "   AND aeq04 = '",g_aeq.aeq04,"'",
               "   AND aeq05 = '",g_aeq.aeq05,"'",
               "   AND ",p_wc CLIPPED, 
               " ORDER BY aeq01,aeq03,aeq04,aeq02,aeq06 "

   PREPARE aeq_pre FROM l_sql
   DECLARE aeq_cs CURSOR FOR aeq_pre

   CALL g_aeq1.clear()
   LET g_cnt = 1
   LET l_flag='N'
   LET g_rec_b=0
   FOREACH aeq_cs INTO g_aeq1[g_cnt].*     #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT nml02 INTO g_aeq1[g_cnt].aeq06_1 FROM nml_file WHERE nml01 = g_aeq1[g_cnt].aeq06
      SELECT nml02 INTO g_aeq1[g_cnt].aeq09_1 FROM nml_file WHERE nml01 = g_aeq1[g_cnt].aeq09
      LET l_flag='Y'
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
       EXIT FOREACH
      END IF
   END FOREACH
   CALL g_aeq1.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   IF l_flag='N' THEN LET g_rec_b=0 END IF     #無單身時將筆數清為零
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION

FUNCTION t010_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1  
 
END FUNCTION
 
FUNCTION t010_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1 
 
END FUNCTION

FUNCTION t010_bp(p_ud)
DEFINE
    p_ud   LIKE type_file.chr1 

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aeq1 TO s_aeq1.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
       BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()     

      ON ACTION insert 
         LET g_action_choice="insert"
         EXIT DISPLAY

    # ON ACTION modify 
    #    LET g_action_choice="modify"
    #    EXIT DISPLAY
 
      ON ACTION delete 
         LET g_action_choice="delete"
         EXIT DISPLAY  

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION first
         CALL t010_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY      
 
      ON ACTION previous
         CALL t010_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)                         
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY 

      ON ACTION jump
         CALL t010_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)                         
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY            

      ON ACTION next
         CALL t010_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY            

      ON ACTION last
         CALL t010_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY           

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()      

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

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

      ON ACTION exporttoexcel  
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION t010_r()

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_aeq.aeq01) AND cl_null(g_aeq.aeq04) AND cl_null(g_aeq.aeq05) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF
   BEGIN WORK

   IF cl_delh(0,0) THEN
      DELETE FROM aeq_file WHERE aeq01=g_aeq.aeq01 AND aeq04=g_aeq.aeq04  
                             AND aeq05=g_aeq.aeq05                                  
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","aeq_file",g_aeq.aeq01,'',SQLCA.sqlcode,"","",1)
      ELSE
         CLEAR FORM
         CALL g_aeq1.clear()
         OPEN t010_count
         FETCH t010_count INTO g_row_count
         LET g_row_count = g_row_count -1     #刪除完後筆數會算錯(多一筆),所以要減一  
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t010_b_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t010_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE 
            CALL t010_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION

#NO.FUN-B40104
