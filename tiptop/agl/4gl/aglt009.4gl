# Prog. Version..: '5.30.06-13.04.22(00004)'     #
# Pattern name...: aglt009.4gl
# Descriptions...: 現金流量表直接法资料导入
# Date & Author..: 2010/11/12 By wuxj   
# Modify.........: NO.FUN-B40104 11/05/05 By jll 合并报表作业
# Modify.........: NO.FUN-B70003 11/07/05 By Lujh 新增字段aep16,aep17
# Modify.........: No.TQC-B70138 11/07/19 By guoch 查詢時，合并帳套取值錯誤
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"
DEFINE   g_aep      RECORD LIKE aep_file.*
DEFINE   g_aep_t    RECORD LIKE aep_file.*
DEFINE   g_aep01_1  LIKE axa_file.axa02
DEFINE   g_aep01_2  LIKE axa_file.axa03
DEFINE   g_aep1     DYNAMIC ARRAY OF RECORD
          aep05      LIKE aep_file.aep05,
          #aep05_1    LIKE nml_file.nml02,
          aep16      LIKE aep_file.aep16,     #FUN-B70003   把aep05_1换成aep16
          aep17      LIKE aep_file.aep17,     #FUN-B70003   add aep17
          aep09      LIKE aep_file.aep09,
          aep13      LIKE aep_file.aep13,
          aep06      LIKE aep_file.aep06,
          aep12      LIKE aep_file.aep12 
                    END RECORD
DEFINE   g_aep1_t   RECORD
          aep05      LIKE aep_file.aep05,
          #aep05_1    LIKE nml_file.nml02,
          aep16      LIKE aep_file.aep16,     #FUN-B70003    把aep05_1换成aep16
          aep17      LIKE aep_file.aep17,     #FUN-B70003    add aep17
          aep09      LIKE aep_file.aep09,
          aep06      LIKE aep_file.aep06,
          aep13      LIKE aep_file.aep13,
          aep12      LIKE aep_file.aep12 
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
DEFINE   g_dbs_axz03     LIKE axz_file.axz03  #TQC-B70138  

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

   
   OPEN WINDOW t009_w AT 5,10
        WITH FORM "agl/42f/aglt009" ATTRIBUTE(STYLE = g_win_style)              
                                                                                
   CALL cl_ui_init()                                                           

   CALL t009_menu()                                                            
   CLOSE WINDOW t009_w 

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION t009_cs()
   CLEAR FORM                                   #清除畫面
   CALL g_aep1.clear()
   CALL cl_set_head_visible("","YES")     

   CONSTRUCT g_wc ON aep01,aep02,aep03,aep04,aep07,aep10,aep08,aep11,
                     aep14,aep15, 
                     aep05,aep16,aep17,aep09,aep13,aep06,aep12 
                FROM aep01,aep02,aep03,aep04,aep07,aep10,aep08,aep11,
                     aep14,aep15,
                     s_aep1[1].aep05,s_aep1[1].aep16,s_aep1[1].aep17,s_aep1[1].aep09,s_aep1[1].aep13,s_aep1[1].aep06,s_aep1[1].aep12  #FUN-B70003  add aep16,aep17

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION controlp                 # 沿用所有欄位
         CASE
          WHEN INFIELD(aep01)                                                                                                 
             CALL cl_init_qry_var()                                                                                           
             LET g_qryparam.state = "c"                                                                                       
             LET g_qryparam.form ="q_aep01"                                                                                   
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aep01                                                                             
             NEXT FIELD aep01
          WHEN INFIELD(aep02)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aep02"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aep02           
             NEXT FIELD aep02
          WHEN INFIELD(aep07)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aep07"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aep07
             NEXT FIELD aep07
          WHEN INFIELD(aep10)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aep10"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aep10       
             NEXT FIELD aep10
          WHEN INFIELD(aep05)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aep05"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aep05
             NEXT FIELD aep05
          WHEN INFIELD(aep12)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_axz"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aep12
             NEXT FIELD aep12
          WHEN INFIELD(aep14)                   #FUN-B70003  add
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_azi"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aep14
             NEXT FIELD aep14
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
   LET g_sql="SELECT UNIQUE aep01,aep02,aep03,aep04 FROM aep_file ",
             " WHERE ", g_wc CLIPPED,
             " ORDER BY aep01,aep02,aep03,aep04 "
   PREPARE t009_prepare FROM g_sql              #預備一下
   DECLARE t009_b_cs                            #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR t009_prepare
                                                #計算本次查詢單頭的筆數
   LET g_sql_tmp= "SELECT UNIQUE aep01,aep02,aep03,aep04 FROM aep_file ",                                                     
                  " WHERE ",g_wc CLIPPED,                                                                                     
                  "   INTO TEMP x"                                                                                            
   DROP TABLE x                                                                                                               
   PREPARE t009_pre_x FROM g_sql_tmp
   EXECUTE t009_pre_x                                                                                                         
   LET g_sql = "SELECT COUNT(*) FROM x"                                                                                       
   PREPARE t009_precount FROM g_sql
   DECLARE t009_count CURSOR FOR t009_precount
END FUNCTION

FUNCTION t009_menu()
   WHILE TRUE
      CALL t009_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t009_a()
            END IF
     #   WHEN "modify"
     #      IF cl_chk_act_auth() THEN
     #         CALL t009_u()
     #      END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t009_r()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t009_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t009_q() 
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
          #    CALL t009_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aep1),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION t009_a()
   DEFINE li_chk_bookno  LIKE type_file.num5  
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_sw           LIKE type_file.chr1, 
          l_cmd          LIKE type_file.chr1000, 
          l_n            LIKE type_file.num5

   IF s_shut(0) THEN RETURN END IF                #檢查權限
   MESSAGE ""
   INITIALIZE g_aep.* TO NULL 
   CLEAR FORM
   CALL g_aep1.clear()
   CALL cl_opmsg('a')

   LET g_aep.aep11 = '2' 
   DISPLAY BY NAME g_aep.aep11  

   WHILE TRUE
      CALL t009_i("a")                           #輸入單頭
      IF INT_FLAG THEN                           #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      CALL g_aep1.clear()
      SELECT COUNT(*) INTO l_n FROM aep_file WHERE aep01=g_aep.aep01
                                               AND aep02=g_aep.aep02 
                                               AND aep03=g_aep.aep03
                                               AND aep04=g_aep.aep04
      LET g_rec_b = 0 
      IF l_n > 0 THEN
         CALL t009_b_fill('1=1')
      END IF
      CALL t009_b()                             #輸入單身
      LET g_aep_t.aep01 = g_aep.aep01           #保留舊值                          
      LET g_aep_t.aep02 = g_aep.aep02           #保留舊值
      LET g_aep_t.aep03 = g_aep.aep03           #保留舊值 
      LET g_aep_t.aep04 = g_aep.aep04           #保留舊值
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION t009_i(p_cmd)
DEFINE
   p_cmd           LIKE type_file.chr1,         #a:輸入 u:更改 
   l_cnt           LIKE type_file.num5,       
   l_n1,l_n        LIKE type_file.num5,
   l_axa02         LIKE axa_file.axa02,
   l_axa03         LIKE axa_file.axa03       

      CALL cl_set_head_visible("","YES")
      INPUT BY NAME g_aep.aep01,g_aep.aep02,g_aep.aep03,g_aep.aep04,
                    g_aep.aep10,g_aep.aep08,g_aep.aep14,g_aep.aep15  WITHOUT DEFAULTS
 
         BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t009_set_entry(p_cmd)
            CALL t009_set_no_entry(p_cmd)
            CALL cl_qbe_init()

 
         AFTER FIELD aep01
            IF NOT cl_null(g_aep.aep01) THEN
               SELECT COUNT(*) INTO l_n FROM axa_file WHERE axa01 = g_aep.aep01 AND axa04 = 'Y'
               IF l_n = 0 THEN 
                  CALL cl_err(g_aep.aep01,100,0)
                  NEXT FIELD aep01
               END IF
               SELECT axa02,axa03 INTO l_axa02,l_axa03 FROM axa_file WHERE axa01 = g_aep.aep01 AND axa04 = 'Y' 
               DISPLAY l_axa02 TO FORMONLY.aep01_1
               DISPLAY l_axa03 TO FORMONLY.aep01_2
            ELSE 
               NEXT FIELD aep01
            END IF
 
         AFTER FIELD aep02
            IF NOT cl_null(g_aep.aep02) THEN
               SELECT COUNT(*) INTO l_n FROM axz_file WHERE axz01 = g_aep.aep02
               IF l_n = 0 THEN 
                  CALL cl_err(g_aep.aep02,100,0)
                  NEXT FIELD aep02
               END IF
               IF g_aza.aza04 = 'Y' THEN 
                  SELECT axz06 INTO g_aep.aep07 FROM axz_file,axa_file WHERE axz01 = axa02 AND axa01 = g_aep.aep01 
                  DISPLAY BY NAME g_aep.aep07
               END IF
               SELECT axz06 INTO g_aep.aep10 FROM axz_file WHERE axz01 = g_aep.aep02 
               DISPLAY BY NAME g_aep.aep10 
            END IF

 
         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF

         ON ACTION controlp                 # 沿用所有欄位
            CASE
              WHEN INFIELD(aep01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axa1"
               LET g_qryparam.default1 = g_aep.aep01 
               CALL cl_create_qry() RETURNING g_aep.aep01 
               DISPLAY BY NAME g_aep.aep01
               NEXT FIELD aep01
              WHEN INFIELD(aep02)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axz"
               LET g_qryparam.default1 = g_aep.aep02
               CALL cl_create_qry() RETURNING g_aep.aep02
               DISPLAY BY NAME g_aep.aep02
               NEXT FIELD aep02
              WHEN INFIELD(aep10)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azi"
               LET g_qryparam.default1 = g_aep.aep10
               CALL cl_create_qry() RETURNING g_aep.aep10
               DISPLAY BY NAME g_aep.aep10
               NEXT FIELD aep10
              WHEN INFIELD(aep14)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azi"
               LET g_qryparam.default1 = g_aep.aep14
               CALL cl_create_qry() RETURNING g_aep.aep14
               DISPLAY BY NAME g_aep.aep14
               NEXT FIELD aep14
              OTHERWISE 
               EXIT CASE
            END CASE

         ON ACTION CONTROLZ
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

FUNCTION t009_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_aep.* TO NULL      

   MESSAGE ""
   CALL cl_opmsg('q')
   CALL t009_cs()                         #取得查詢條件
   IF INT_FLAG THEN                       #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN t009_b_cs                           #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                    #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_aep.* TO NULL
   ELSE
      CALL t009_fetch('F')               #讀出TEMP第一筆並顯示
      OPEN t009_count
      FETCH t009_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
   END IF
END FUNCTION

FUNCTION t009_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680098 VARCHAR(1)
   l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680098 INTEGER

   MESSAGE ""
   CASE p_flag
       WHEN 'N' FETCH NEXT     t009_b_cs INTO g_aep.aep01,g_aep.aep02,g_aep.aep03,g_aep.aep04                                
       WHEN 'P' FETCH PREVIOUS t009_b_cs INTO g_aep.aep01,g_aep.aep02,g_aep.aep03,g_aep.aep04                                
       WHEN 'F' FETCH FIRST    t009_b_cs INTO g_aep.aep01,g_aep.aep02,g_aep.aep03,g_aep.aep04                   
       WHEN 'L' FETCH LAST     t009_b_cs INTO g_aep.aep01,g_aep.aep02,g_aep.aep03,g_aep.aep04                   
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
            FETCH ABSOLUTE g_jump t009_b_cs INTO g_aep.aep01,g_aep.aep02,g_aep.aep03,g_aep.aep04                    
            LET mi_no_ask = FALSE
   END CASE
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_aep.aep01,SQLCA.sqlcode,0)   
      INITIALIZE g_aep.* TO NULL 
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

   CALL t009_show()
END FUNCTION

#將資料顯示在畫面上
FUNCTION t009_show()
DEFINE l_axa02    LIKE axa_file.axa02
DEFINE l_axa03    LIKE axa_file.axa03
DEFINE g_aaw01    LIKE aaw_file.aaw01  #TQC-B70138  add
   SELECT axa02,axa03 INTO l_axa02,l_axa03 FROM axa_file WHERE axa01 = g_aep.aep01 AND axa04 = 'Y'
   DISPLAY l_axa02 TO FORMONLY.aep01_1
   DISPLAY l_axa03 TO FORMONLY.aep01_2  #TQC-B70138 mark   #FUN-B70003  
   
   #TQC-B70138 --begin
  # CALL s_aaz641_dbs(g_aep.aep01,l_axa02) RETURNING g_dbs_axz03
  # CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaw01
  # DISPLAY g_aaw01 TO FORMONLY.aep01_2                #FUN-B70003  mark
   #TQC-B70138 --end
   
   SELECT aep07,aep08,aep10,aep11,aep14,aep15 
     INTO g_aep.aep07,g_aep.aep08,g_aep.aep10,g_aep.aep11,
          g_aep.aep14,g_aep.aep15 
     FROM aep_file 
    WHERE aep01 = g_aep.aep01
      AND aep02 = g_aep.aep02
      AND aep03 = g_aep.aep03
      AND aep04 = g_aep.aep04
   DISPLAY BY NAME g_aep.*              
   DISPLAY g_aep.aep01 TO aep01
   DISPLAY g_aep.aep02 TO aep02
   DISPLAY g_aep.aep03 TO aep03
   DISPLAY g_aep.aep04 TO aep04
   DISPLAY g_aep.aep07 TO aep07
   DISPLAY g_aep.aep10 TO aep10
   DISPLAY g_aep.aep08 TO aep08
   DISPLAY g_aep.aep11 TO aep11   
   DISPLAY g_aep.aep14 TO aep14
   DISPLAY g_aep.aep15 TO aep15
   CALL t009_b_fill(g_wc)             #單身
   CALL cl_show_fld_cont()  
END FUNCTION

#單身
FUNCTION t009_b()
DEFINE
   l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT   
   l_n             LIKE type_file.num5,     #檢查重複用    
   l_lock_sw       LIKE type_file.chr1,     #單身鎖住否   
   p_cmd           LIKE type_file.chr1,     #處理狀態    
   l_aep_delyn     LIKE type_file.chr1,     #判斷是否可以刪除單身資料ROW 
   l_chr           LIKE type_file.chr1,   
   l_allow_insert  LIKE type_file.num5,     #可新增否     
   l_allow_delete  LIKE type_file.num5      #可刪除否    

   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF        #檢查權限
   IF cl_null(g_aep.aep01) OR cl_null(g_aep.aep02) OR cl_null(g_aep.aep03) OR cl_null(g_aep.aep04) THEN
       RETURN
   END IF

   CALL cl_opmsg('b')                #單身處理的操作提示

  # LET g_forupd_sql = "SELECT aep05,'',aep09,aep13,aep06,aep12 FROM aep_file",
  #                    " WHERE aep01 = ? AND aep02=? AND aep03=? AND aep04=? AND aep05=? AND aep12=?  FOR UPDATE  "  #luttb add aep12 
   LET g_forupd_sql = "SELECT aep05,aep16,aep17,aep09,aep13,aep06,aep12 FROM aep_file ",
                      " WHERE aep01 = ? AND aep02=? AND aep03=? AND aep04=? AND aep05=? AND aep12=?  FOR UPDATE  "   #FUN-B70003 add aep16,aep17
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

   DECLARE t009_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_aep1 WITHOUT DEFAULTS FROM s_aep1.*
      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         LET g_action_choice = ""
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         #CALL cl_set_comp_entry("aep05_1",FALSE)
         CALL cl_set_comp_entry("aep16,aep17",FALSE)           #FUN-B70003  把aep05_1换成aep16
         
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET  g_before_input_done = FALSE
            CALL t009_set_entry(p_cmd)
            CALL t009_set_no_entry(p_cmd)
            LET  g_before_input_done = TRUE
            BEGIN WORK
            LET p_cmd='u'
            LET g_aep1_t.* = g_aep1[l_ac].*  #BACKUP
            OPEN t009_bcl USING g_aep.aep01,g_aep.aep02,g_aep.aep03,g_aep.aep04,
                                g_aep1[l_ac].aep05,g_aep1[l_ac].aep12   #luttb add aep12
            IF STATUS THEN
               CALL cl_err("OPEN t009_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t009_bcl INTO g_aep1[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_aep1_t.aep05,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               SELECT nml02,nml03 INTO g_aep1[l_ac].aep16,g_aep1[l_ac].aep17 FROM nml_file WHERE nml01 = g_aep1[l_ac].aep05    #FUN-B70003
            END IF
            CALL cl_show_fld_cont()
         END IF

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_aep1[l_ac].* TO NULL
         LET g_aep1[l_ac].aep09 = 0 
         LET g_aep1[l_ac].aep06 = 0 
         LET g_aep1[l_ac].aep13 = 0
         LET g_aep1_t.* = g_aep1[l_ac].*
         CALL cl_show_fld_cont() 
         NEXT FIELD aep05

      AFTER INSERT
         IF INT_FLAG THEN 
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
            CLOSE t009_bcl
         END IF
         #INSERT INTO aep_file VALUES(g_aep.aep01,g_aep.aep02,g_aep.aep03,g_aep.aep04,g_aep1[l_ac].aep05,
         #                            g_aep1[l_ac].aep06,g_aep.aep07,g_aep.aep08,g_aep1[l_ac].aep09,
         #                            g_aep.aep10,g_aep.aep11,g_aep1[l_ac].aep12,g_aep1[l_ac].aep13,g_aep.aep14,g_aep.aep15,
         #                          #  g_aep1[l_ac].aep16,g_aep1[l_ac].aep17,
         #                            g_legal)  #FUN-B70003 add g_aep1[l_ac].aep16,g_aep1[l_ac].aep17  

         INSERT INTO aep_file VALUES(g_aep.aep01,g_aep.aep02,g_aep.aep03,g_aep.aep04,g_aep1[l_ac].aep05,
                                     g_aep1[l_ac].aep06,g_aep.aep07,g_aep.aep08,g_aep1[l_ac].aep09,
                                     g_aep.aep10,g_aep.aep11,g_aep1[l_ac].aep12,g_aep1[l_ac].aep13,g_aep.aep14,g_aep.aep15,g_legal,g_aep1[l_ac].aep16,g_aep1[l_ac].aep17)  #FUN-B70003 add g_aep1[l_ac].aep16,g_aep1[l_ac].aep17  
         
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","aep_file",g_aep1[l_ac].aep05,"",SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
         END IF

      AFTER FIELD aep05                        #check 編號是否重複
       IF NOT cl_null(g_aep1[l_ac].aep05) THEN
         IF g_aep1[l_ac].aep05 != g_aep1_t.aep05 OR
            cl_null(g_aep1_t.aep05) THEN
            SELECT COUNT(*) INTO l_n FROM nml_file 
             WHERE nml01 = g_aep1[l_ac].aep05
            IF l_n = 0 THEN 
               CALL cl_err(g_aep1[l_ac].aep05,100,0)
               NEXT FIELD aep05
            END IF

            SELECT COUNT(*) INTO l_n FROM aep_file
             WHERE aep01 = g_aep.aep01 AND aep02 = g_aep.aep02   
               AND aep03 = g_aep.aep03 AND aep04 = g_aep.aep04
               AND aep05 = g_aep1[l_ac].aep05      
               AND aep12 = g_aep1[l_ac].aep12   #luttb add aep12 
            IF l_n <> 0 THEN
               LET g_aep1[l_ac].aep05 = g_aep1_t.aep05
               CALL cl_err('','-239',0)
               NEXT FIELD aep05 
            ELSE
               SELECT nml02,nml03 INTO g_aep1[l_ac].aep16,g_aep1[l_ac].aep17 FROM nml_file 
                WHERE nml01 = g_aep1[l_ac].aep05                        #FUN-B70003
            END IF
         END IF
       END IF 
#luttb--add--str--
      AFTER FIELD aep12
         IF g_aep1[l_ac].aep12 != g_aep1_t.aep12 OR
            cl_null(g_aep1_t.aep12) THEN
            SELECT COUNT(*) INTO l_n FROM axz_file
             WHERE axz01 = g_aep1[l_ac].aep12
            IF l_n = 0 THEN
               CALL cl_err(g_aep1[l_ac].aep12,100,0)
               NEXT FIELD aep12
            END IF
            SELECT COUNT(*) INTO l_n FROM aep_file
             WHERE aep01 = g_aep.aep01 AND aep02 = g_aep.aep02
               AND aep03 = g_aep.aep03 AND aep04 = g_aep.aep04
               AND aep05 = g_aep1[l_ac].aep05
               AND aep12 = g_aep1[l_ac].aep12
            IF l_n <> 0 THEN
               LET g_aep1[l_ac].aep12 = g_aep1_t.aep12
               CALL cl_err('','-239',0)
               NEXT FIELD aep12
            END IF
         END IF
#luttb--add--end
      AFTER FIELD aep09 
         IF g_aep1[l_ac].aep09 < 0  THEN 
            CALL cl_err(g_aep1[l_ac].aep09,'',0)
            NEXT FIELD aep09
         ELSE
            #LET g_aep1[l_ac].aep06 = g_aep1[l_ac].aep09 * g_aep.aep08 / 100   #luttb
            LET g_aep1[l_ac].aep13 = g_aep1[l_ac].aep09 * g_aep.aep08
            LET g_aep1[l_ac].aep06 = g_aep1[l_ac].aep13 * g_aep.aep15 
         END IF
         DISPLAY BY NAME g_aep1[l_ac].aep13
         DISPLAY BY NAME g_aep1[l_ac].aep06

      AFTER FIELD aep13
         IF g_aep1[l_ac].aep13 < 0  THEN
            CALL cl_err(g_aep1[l_ac].aep13,'',0)
            NEXT FIELD aep13
         ELSE
            LET g_aep1[l_ac].aep06 = g_aep1[l_ac].aep13 * g_aep.aep15
         END IF
         DISPLAY BY NAME g_aep1[l_ac].aep13

      BEFORE DELETE                            #是否取消單身
         IF g_aep1_t.aep05 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM aep_file
             WHERE aep01 = g_aep.aep01   
               AND aep02 = g_aep.aep02
               AND aep03 = g_aep.aep03
               AND aep04 = g_aep.aep04
               AND aep05 = g_aep1_t.aep05
               AND aep12 = g_aep1_t.aep12   #luttb add
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","aep_file",g_aep1_t.aep05,"",SQLCA.sqlcode,"","",1)
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF

      ON ROW CHANGE
         IF g_aep1_t.aep05 IS NOT NULL THEN
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_aep1[l_ac].aep05,-263,1)
               LET g_aep1[l_ac].* = g_aep1_t.*
            ELSE
               UPDATE aep_file SET aep05 = g_aep1[l_ac].aep05,
                                   aep16 = g_aep1[l_ac].aep16,  #FUN-B70003
                                   aep17 = g_aep1[l_ac].aep17,  #FUN-B70003 
                                   aep09 = g_aep1[l_ac].aep09,
                                   aep06 = g_aep1[l_ac].aep06,
                                   aep13 = g_aep1[l_ac].aep13,
                                   aep12 = g_aep1[l_ac].aep12 
                WHERE aep01 = g_aep.aep01 AND aep02 = g_aep.aep02 AND aep03 = g_aep.aep03
                  AND aep04 = g_aep.aep04 AND aep05 = g_aep1_t.aep05
                  AND aep12 = g_aep1_t.aep12   #luttb
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","aep_file",g_aep.aep01,g_aep1_t.aep05,SQLCA.sqlcode,"","",1)
                  LET g_aep1[l_ac].* = g_aep1_t.*
               ELSE
                  CALL cl_msg('UPDATE O.K')
               END IF
            END IF
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac  #FUN-D30032 mark
         #luttb--add--str--
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)  #FUN-D30032 add 
            LET INT_FLAG=0
            #FUN-D30032--add--begin--
            IF p_cmd='u' THEN
               LET g_aep1[l_ac].* = g_aep1_t.*
            ELSE
               CALL g_aep1.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            END IF
            CLOSE t009_bcl  
            ROLLBACK WORK
            EXIT INPUT
            #FUN-D30032--add--end----
         END IF
         #luttb--add--end
         LET l_ac_t = l_ac  #FUN-D30032 add
         CLOSE t009_bcl  
         COMMIT WORK
        #IF p_cmd = 'u' THEN  #FUN-D0032 mark
        #   CLOSE t009_bcl    #FUN-D0032 mark
        #END IF               #FUN-D0032 mark

      ON ACTION CONTROLP
         CASE
         WHEN INFIELD(aep05)
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_nml"
            LET g_qryparam.default1 = g_aep1[l_ac].aep05
            CALL cl_create_qry() RETURNING g_aep1[l_ac].aep05
            NEXT FIELD aep05
         WHEN INFIELD(aep12)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axz"
               LET g_qryparam.default1 = g_aep1[l_ac].aep12
               CALL cl_create_qry() RETURNING g_aep1[l_ac].aep12
               DISPLAY BY NAME g_aep1[l_ac].aep12
               NEXT FIELD aep12
         OTHERWISE
             EXIT CASE
         END CASE
      ON ACTION CONTROLZ
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
#     CLOSE t009_bcl
#     ROLLBACK WORK
#     RETURN
#  END IF

   CLOSE t009_bcl
   COMMIT WORK
END FUNCTION

FUNCTION t009_b_fill(p_wc)              #BODY FILL UP
DEFINE
   p_wc            STRING,        
   l_flag          LIKE type_file.chr1,              #有無單身筆數     
   l_sql           STRING       

   #LET l_sql = "SELECT aep05,nml02,aep09,aep13,aep06,aep12 ", 
   LET l_sql = "SELECT aep05,aep16,aep17,aep09,aep13,aep06,aep12 ",   #FUN-B70003 add aep16,aep17
               "  FROM aep_file,OUTER nml_file",
               " WHERE aep01 = '",g_aep.aep01,"'",     
               "   AND aep02 = '",g_aep.aep02,"'",                       
               "   AND aep03 = '",g_aep.aep03,"'",
               "   AND aep04 = '",g_aep.aep04,"'",
               "   AND aep05 = nml_file.nml01 ",
               "   AND ",p_wc CLIPPED, 
               " ORDER BY aep01,aep02,aep03,aep04,aep05 "

   PREPARE aep_pre FROM l_sql
   DECLARE aep_cs CURSOR FOR aep_pre

   CALL g_aep1.clear()
   LET g_cnt = 1
   LET l_flag='N'
   LET g_rec_b=0
   FOREACH aep_cs INTO g_aep1[g_cnt].*     #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      LET l_flag='Y'
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
       EXIT FOREACH
      END IF
   END FOREACH
   CALL g_aep1.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   IF l_flag='N' THEN LET g_rec_b=0 END IF     #無單身時將筆數清為零
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION

FUNCTION t009_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1  
 
END FUNCTION
 
FUNCTION t009_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1 
 
END FUNCTION

FUNCTION t009_bp(p_ud)
DEFINE
    p_ud   LIKE type_file.chr1 

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aep1 TO s_aep1.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
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
         CALL t009_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY      
 
      ON ACTION previous
         CALL t009_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)                         
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY 

      ON ACTION jump
         CALL t009_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)                         
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY            

      ON ACTION next
         CALL t009_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY            

      ON ACTION last
         CALL t009_fetch('L')
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

FUNCTION t009_r()

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_aep.aep01) AND cl_null(g_aep.aep02) AND cl_null(g_aep.aep03) AND cl_null(g_aep.aep04) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF
   BEGIN WORK

   IF cl_delh(0,0) THEN
      DELETE FROM aep_file WHERE aep01=g_aep.aep01 AND aep02=g_aep.aep02  
                             AND aep03=g_aep.aep03 AND aep04=g_aep.aep04
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","aep_file",g_aep.aep01,g_aep.aep02,SQLCA.sqlcode,"","",1)
      ELSE
         CLEAR FORM
         CALL g_aep1.clear()
         OPEN t009_count
         FETCH t009_count INTO g_row_count
         LET g_row_count = g_row_count -1     #刪除完後筆數會算錯(多一筆),所以要減一  
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t009_b_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t009_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE 
            CALL t009_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION
#NO.FUN-B40104
