# Prog. Version..: '5.30.06-13.04.22(00003)'     #
# Pattern name...: gglt502.4gl
# Descriptions...: 現金流量表直接法抵消设置
# Date & Author..: 2010/11/16 By wuxj   
# Modify.........: NO.FUN-B40104 11/05/05 By jll   #合并报表回收产品
# Modify.........: No.TQC-B70139 11/07/19 By guoch 查詢時，合并帳套取值錯誤
# Modify.........: No.FUN-B80135 11/08/22 By lujh  相關日期欄位不可小於關帳日期 
# Modify.........: NO.FUN-BB0037 11/11/22 By lilingyu 合併報表移植
# Modify.........: NO.TQC-C60142 12/06/18 By lujh 錄入一筆新資料後直接刪除，總筆數欄位變為-1.
# Modify.........: No:FUN-D30032 13/04/03 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"              #FUN-BB0037
DEFINE   g_ate      RECORD LIKE ate_file.*
DEFINE   g_ate_t    RECORD LIKE ate_file.*
DEFINE   g_ate01_1  LIKE asa_file.asa02
DEFINE   g_ate01_2  LIKE asa_file.asa03
DEFINE   g_ate1     DYNAMIC ARRAY OF RECORD
          ate02      LIKE ate_file.ate02,
          ate06      LIKE ate_file.ate06,
          ate06_1    LIKE nml_file.nml02,
          ate07      LIKE ate_file.ate07,
          ate08      LIKE ate_file.ate08,
          ate03      LIKE ate_file.ate03,
          ate09      LIKE ate_file.ate09,
          ate09_1    LIKE nml_file.nml02,
          ate10      LIKE ate_file.ate10,
          ate11      LIKE ate_file.ate11
                    END RECORD
DEFINE   g_ate1_t   RECORD
          ate02      LIKE ate_file.ate02,
          ate06      LIKE ate_file.ate06,
          ate06_1    LIKE nml_file.nml02,
          ate07      LIKE ate_file.ate07,
          ate08      LIKE ate_file.ate08,
          ate03      LIKE ate_file.ate03,
          ate09      LIKE ate_file.ate09,
          ate09_1    LIKE nml_file.nml02,
          ate10      LIKE ate_file.ate10,
          ate11      LIKE ate_file.ate11
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
DEFINE   g_dbs_asg03     LIKE asg_file.asg03  #TQC-B70139 add
DEFINE   g_aaa07         LIKE aaa_file.aaa07  #No.FUN-B80135
DEFINE   g_year          LIKE type_file.chr4  #No.FUN-B80135
DEFINE   g_month         LIKE type_file.chr2  #No.FUN-B80135


MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT          

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   #FUN-B80135--add--str--
   SELECT aaa07 INTO g_aaa07 FROM aaa_file,asz_file
    WHERE aaa01 = asz01 AND asz00 = '0' 
   LET g_year = YEAR(g_aaa07)
   LET g_month= MONTH(g_aaa07) 
   #FUN-B80135--add--end
   
   OPEN WINDOW t010_w AT 5,10
        WITH FORM "ggl/42f/gglt502" ATTRIBUTE(STYLE = g_win_style)              
                                                                                
   CALL cl_ui_init()                                                           

   CALL t010_menu()                                                            
   CLOSE WINDOW t010_w 

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION t010_cs()
   CLEAR FORM                                   #清除畫面
   CALL g_ate1.clear()
   CALL cl_set_head_visible("","YES")     

   CONSTRUCT g_wc ON ate01,ate04,ate05,ate02,ate06,ate07,ate08,ate03,ate09,ate10,ate11     
                FROM ate01,ate04,ate05,s_ate1[1].ate02,s_ate1[1].ate06,s_ate1[1].ate07,
                     s_ate1[1].ate08,s_ate1[1].ate03,s_ate1[1].ate09,s_ate1[1].ate10,s_ate1[1].ate11

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION controlp                 # 沿用所有欄位
         CASE
          WHEN INFIELD(ate01)                                                                                                 
             CALL cl_init_qry_var()                                                                                           
             LET g_qryparam.state = "c"                                                                                       
             LET g_qryparam.form ="q_ate01"                                                                                   
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ate01                                                                             
             NEXT FIELD ate01
          WHEN INFIELD(ate02)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_ate02"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ate02           
             NEXT FIELD ate02
          WHEN INFIELD(ate06)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_ate06"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ate06
             NEXT FIELD ate06
          WHEN INFIELD(ate03)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_ate03"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ate03       
             NEXT FIELD ate03
          WHEN INFIELD(ate09)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_ate09"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ate09
             NEXT FIELD ate09
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
   LET g_sql="SELECT UNIQUE ate01,ate04,ate05 FROM ate_file ",
             " WHERE ", g_wc CLIPPED,
             " ORDER BY ate01,ate04,ate05 "
   PREPARE t010_prepare FROM g_sql              #預備一下
   DECLARE t010_b_cs                            #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR t010_prepare
                                                #計算本次查詢單頭的筆數
   LET g_sql_tmp= "SELECT UNIQUE ate01,ate04,ate05 FROM ate_file ",   
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ate1),'','')
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
   INITIALIZE g_ate.* TO NULL 
   CLEAR FORM
   CALL g_ate1.clear()
   CALL cl_opmsg('a')

   WHILE TRUE
      CALL t010_i("a")                           #輸入單頭
      IF INT_FLAG THEN                           #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      CALL g_ate1.clear()
      SELECT COUNT(*) INTO l_n FROM ate_file WHERE ate01=g_ate.ate01
                                               AND ate04=g_ate.ate04 
                                               AND ate05=g_ate.ate05
      LET g_rec_b = 0 
      IF l_n > 0 THEN
         CALL t010_b_fill('1=1')
      END IF
      CALL t010_b()                             #輸入單身
      LET g_ate_t.ate01 = g_ate.ate01           #保留舊值                          
      LET g_ate_t.ate04 = g_ate.ate04           #保留舊值
      LET g_ate_t.ate05 = g_ate.ate05           #保留舊值 
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION t010_i(p_cmd)
DEFINE
   p_cmd           LIKE type_file.chr1,         #a:輸入 u:更改 
   l_cnt           LIKE type_file.num5,       
   l_n1,l_n        LIKE type_file.num5,
   l_asa02         LIKE asa_file.asa02,
   l_asa03         LIKE asa_file.asa03       

      CALL cl_set_head_visible("","YES")
      INPUT BY NAME g_ate.ate01,g_ate.ate04,g_ate.ate05 WITHOUT DEFAULTS
 
         BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t010_set_entry(p_cmd)
            CALL t010_set_no_entry(p_cmd)
            CALL cl_qbe_init()

 
         AFTER FIELD ate01
            IF NOT cl_null(g_ate.ate01) THEN
               SELECT COUNT(*) INTO l_n FROM asa_file WHERE asa01 = g_ate.ate01 AND asa04 = 'Y'
               IF l_n = 0 THEN 
                  CALL cl_err(g_ate.ate01,100,0)
                  NEXT FIELD ate01
               END IF
               SELECT asa02,asa03 INTO l_asa02,l_asa03 FROM asa_file WHERE asa01 = g_ate.ate01 AND asa04 = 'Y' 
               DISPLAY l_asa02 TO FORMONLY.ate01_1
               DISPLAY l_asa03 TO FORMONLY.ate01_2
            ELSE 
               NEXT FIELD ate01
            END IF

         #FUN-B80135--add--str--    
         AFTER FIELD ate04
           IF NOT cl_null(g_ate.ate04) THEN
             IF g_ate.ate04 < 0 THEN
                CALL cl_err(g_ate.ate04,'apj-035',0)
                LET g_ate.ate04 = g_ate_t.ate04
                NEXT FIELD ate04
             END IF
             IF g_ate.ate04<g_year THEN
                CALL cl_err(g_ate.ate04,'atp-164',0)
                LET g_ate.ate04 = g_ate_t.ate04
                NEXT FIELD ate04
             ELSE
                IF g_ate.ate04=g_year AND g_ate.ate05<=g_month THEN
                   CALL cl_err('','atp-164',0)
                   NEXT FIELD ate05
                END IF
             END IF 
           END IF

         AFTER FIELD ate05
            IF NOT cl_null(g_ate.ate05) THEN
               SELECT azm02 INTO g_azm.azm02 FROM azm_file
                WHERE azm01 = g_ate.ate04
               IF g_azm.azm02 = 1 THEN
                  IF g_ate.ate05 > 12 OR g_ate.ate05 < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD ate05
                  END IF
               ELSE
                  IF g_ate.ate05 > 13 OR g_ate.ate05 < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD ate05
                  END IF
               END IF
               IF NOT cl_null(g_ate.ate04) AND g_ate.ate04=g_year 
               AND g_ate.ate05<=g_month THEN
                  CALL cl_err('','atp-164',0)
                  NEXT FIELD ate05
               END IF 
            END IF
         #No.FUN-B80135--add--end
 
         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF

         ON ACTION controlp                 # 沿用所有欄位
            CASE
              WHEN INFIELD(ate01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_asa1"
               LET g_qryparam.default1 = g_ate.ate01 
               CALL cl_create_qry() RETURNING g_ate.ate01 
               DISPLAY BY NAME g_ate.ate01
               NEXT FIELD ate01
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

FUNCTION t010_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_ate.* TO NULL      

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
      INITIALIZE g_ate.* TO NULL
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
       WHEN 'N' FETCH NEXT     t010_b_cs INTO g_ate.ate01,g_ate.ate04,g_ate.ate05
       WHEN 'P' FETCH PREVIOUS t010_b_cs INTO g_ate.ate01,g_ate.ate04,g_ate.ate05
       WHEN 'F' FETCH FIRST    t010_b_cs INTO g_ate.ate01,g_ate.ate04,g_ate.ate05
       WHEN 'L' FETCH LAST     t010_b_cs INTO g_ate.ate01,g_ate.ate04,g_ate.ate05
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
            FETCH ABSOLUTE g_jump t010_b_cs INTO g_ate.ate01,g_ate.ate04,g_ate.ate05                                
            LET mi_no_ask = FALSE
   END CASE
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_ate.ate01,SQLCA.sqlcode,0)   
      INITIALIZE g_ate.* TO NULL 
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
DEFINE l_asa02    LIKE asa_file.asa02
DEFINE l_asa03    LIKE asa_file.asa03
DEFINE g_asz01    LIKE asz_file.asz01  #TQC-B70139 add
   SELECT asa02,asa03 INTO l_asa02,l_asa03 FROM asa_file WHERE asa01 = g_ate.ate01 AND asa04 = 'Y'
   DISPLAY l_asa02 TO FORMONLY.ate01_1
 #  DISPLAY l_asa03 TO FORMONLY.ate01_2  TQC-B70139 mark
   #TQC-B70139 -beatk
   CALL s_aaz641_asg(g_ate.ate01,l_asa02) RETURNING g_dbs_asg03
   CALL s_get_aaz641_asg(g_dbs_asg03) RETURNING g_asz01
   DISPLAY g_asz01 TO FORMONLY.ate01_2
   #TQC-B70139 -end
   DISPLAY BY NAME g_ate.*              
   DISPLAY g_ate.ate01 TO ate01    #NO.FUN-B40104
   DISPLAY g_ate.ate04 TO ate04    
   DISPLAY g_ate.ate05 TO ate05
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
   l_ate_delyn     LIKE type_file.chr1,     #判斷是否可以刪除單身資料ROW 
   l_chr           LIKE type_file.chr1,   
   l_allow_insert  LIKE type_file.num5,     #可新增否     
   l_allow_delete  LIKE type_file.num5      #可刪除否    

   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF        #檢查權限
   IF cl_null(g_ate.ate01) OR cl_null(g_ate.ate04) OR cl_null(g_ate.ate05) THEN
       RETURN
   END IF

   CALL cl_opmsg('b')                #單身處理的操作提示

   LET g_forupd_sql = "SELECT ate02,ate06,'',ate07,ate08,ate03,ate09,'',ate10,ate11 FROM ate_file",
                      " WHERE ate01 = ? AND ate02=? AND ate03=? AND ate04=? AND ate05=? AND ate06=? AND ate09=?",
                      "   FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)  
 
   DECLARE t010_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_ate1 WITHOUT DEFAULTS FROM s_ate1.*
      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         LET g_action_choice = ""
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         CALL cl_set_comp_entry("ate10",FALSE)

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
            LET g_ate1_t.* = g_ate1[l_ac].*  #BACKUP
            OPEN t010_bcl USING g_ate.ate01,g_ate1[l_ac].ate02,g_ate1[l_ac].ate03,g_ate.ate04,
                                g_ate.ate05,g_ate1[l_ac].ate06,g_ate1[l_ac].ate09
            IF STATUS THEN
               CALL cl_err("OPEN t010_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t010_bcl INTO g_ate1[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ate1_t.ate02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               SELECT nml02 INTO g_ate1[l_ac].ate06_1 FROM nml_file WHERE nml01 = g_ate1[l_ac].ate06
               SELECT nml02 INTO g_ate1[l_ac].ate09_1 FROM nml_file WHERE nml01 = g_ate1[l_ac].ate09
            END IF
            CALL cl_show_fld_cont()
         END IF

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_ate1[l_ac].* TO NULL
         LET g_ate1[l_ac].ate08 = 0
         LET g_ate1_t.* = g_ate1[l_ac].* 
         CALL cl_show_fld_cont() 
         NEXT FIELD ate02

      AFTER INSERT
         IF INT_FLAG THEN 
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
            CLOSE t010_bcl
         END IF
         INSERT INTO ate_file VALUES(g_ate.ate01,g_ate1[l_ac].ate02,g_ate1[l_ac].ate03,g_ate.ate04,g_ate.ate05,
                                     g_ate1[l_ac].ate06,g_ate1[l_ac].ate07,g_ate1[l_ac].ate08,g_ate1[l_ac].ate09,
                                     g_ate1[l_ac].ate10,g_ate1[l_ac].ate11,g_legal)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","ate_file",g_ate1[l_ac].ate02,"",SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
         END IF

      AFTER FIELD ate02
         IF g_ate1[l_ac].ate02 != g_ate1_t.ate02 OR
            cl_null(g_ate1_t.ate02) THEN
            SELECT COUNT(*) INTO l_n FROM asg_file where asg01 = g_ate1[l_ac].ate02
            IF l_n = 0 THEN
               CALL cl_err(g_ate1[l_ac].ate02,100,0)
               NEXT FIELD ate02
            END IF
            IF NOT cl_null(g_ate1[l_ac].ate02) AND NOT cl_null(g_ate1[l_ac].ate03) AND NOT cl_null(g_ate1[l_ac].ate06)
               AND NOT cl_null(g_ate1[l_ac].ate09) THEN
               SELECT COUNT(*) INTO l_n FROM ate_file WHERE ate01 = g_ate.ate01 AND ate02 = g_ate1[l_ac].ate02
                  AND ate03 = g_ate1[l_ac].ate03 AND ate04 = g_ate.ate04 AND ate05 = g_ate.ate05
                  AND ate06 = g_ate1[l_ac].ate06 AND ate09 = g_ate1[l_ac].ate09
               IF l_n > 0 THEN
                  LET g_ate1[l_ac].ate02 = g_ate1_t.ate02
                  CALL cl_err('','-239',0)
                  NEXT FIELD ate02
               END IF
            END IF 
         END IF 

      AFTER FIELD ate06                        #check 編號是否重複
         IF g_ate1[l_ac].ate06 != g_ate1_t.ate06 OR
            cl_null(g_ate1_t.ate06) THEN
            SELECT COUNT(*) INTO l_n FROM nml_file 
             WHERE nml01 = g_ate1[l_ac].ate06
            IF l_n = 0 THEN 
               CALL cl_err(g_ate1[l_ac].ate06,100,0)
               NEXT FIELD ate06
            END IF
            SELECT COUNT(*) INTO l_n FROM ate_file
             WHERE ate06 = g_ate1[l_ac].ate06
            IF l_n > 0 THEN    #科目已存在其他群組中
               IF NOT cl_confirm('agl-919') THEN
                  NEXT FIELD ate06
               END IF
            END IF
            IF NOT cl_null(g_ate1[l_ac].ate02) AND NOT cl_null(g_ate1[l_ac].ate03) AND NOT cl_null(g_ate1[l_ac].ate06)
               AND NOT cl_null(g_ate1[l_ac].ate09) THEN
               SELECT COUNT(*) INTO l_n FROM ate_file WHERE ate01 = g_ate.ate01 AND ate02 = g_ate1[l_ac].ate02
                  AND ate03 = g_ate1[l_ac].ate03 AND ate04 = g_ate.ate04 AND ate05 = g_ate.ate05
                  AND ate06 = g_ate1[l_ac].ate06 AND ate09 = g_ate1[l_ac].ate09
               IF l_n > 0 THEN
                  LET g_ate1[l_ac].ate06 = g_ate1_t.ate06
                  CALL cl_err('','-239',0)
                  NEXT FIELD ate06
               END IF
            END IF
            SELECT nml02 INTO g_ate1[l_ac].ate06_1 FROM nml_file
             WHERE nml01 = g_ate1[l_ac].ate06
         END IF
         IF NOT cl_null(g_ate1[l_ac].ate06) AND NOT cl_null(g_ate1[l_ac].ate09) THEN
            SELECT COUNT(*) INTO l_n1 FROM nml_file WHERE nml01 = g_ate1[l_ac].ate06 AND nml03 IN('10','20','30','40')
            SELECT COUNT(*) INTO l_n2 FROM nml_file WHERE nml01 = g_ate1[l_ac].ate09 AND nml03 IN('10','20','30','40')
            IF l_n1 > 0 AND l_n2 > 0 THEN
               IF g_ate1[l_ac].ate07 = '+' THEN
                  LET g_ate1[l_ac].ate10 = '-'
               END IF
               IF g_ate1[l_ac].ate07 = '-' THEN
                  LET g_ate1[l_ac].ate10 = '+'
               END IF
            ELSE
               IF g_ate1[l_ac].ate07 = '+' THEN
                  LET g_ate1[l_ac].ate10 = '+'
               END IF
               IF g_ate1[l_ac].ate07 = '-' THEN
                  LET g_ate1[l_ac].ate10 = '-'
               END IF
            END IF
         END IF

      AFTER FIELD ate07 
         IF NOT cl_null(g_ate1[l_ac].ate06) AND NOT cl_null(g_ate1[l_ac].ate09) THEN 
            SELECT COUNT(*) INTO l_n1 FROM nml_file WHERE nml01 = g_ate1[l_ac].ate06 AND nml03 IN('10','20','30','40')
            SELECT COUNT(*) INTO l_n2 FROM nml_file WHERE nml01 = g_ate1[l_ac].ate09 AND nml03 IN('10','20','30','40')
            IF l_n1 > 0 AND l_n2 > 0 THEN
               IF g_ate1[l_ac].ate07 = '+' THEN
                  LET g_ate1[l_ac].ate10 = '-'
               END IF
               IF g_ate1[l_ac].ate07 = '-' THEN 
                  LET g_ate1[l_ac].ate10 = '+'
               END IF 
            ELSE
               IF g_ate1[l_ac].ate07 = '+' THEN
                  LET g_ate1[l_ac].ate10 = '+'
               END IF
               IF g_ate1[l_ac].ate07 = '-' THEN
                  LET g_ate1[l_ac].ate10 = '-'
               END IF
            END IF 
         END IF 

      AFTER FIELD ate08 
         IF g_ate1[l_ac].ate08 < 0  THEN 
            CALL cl_err(g_ate1[l_ac].ate08,'',0)
            NEXT FIELD ate08
         END IF

      AFTER FIELD ate03
         IF g_ate1[l_ac].ate03 != g_ate1_t.ate03 OR
            cl_null(g_ate1_t.ate03) THEN
            SELECT COUNT(*) INTO l_n FROM asg_file where asg01 = g_ate1[l_ac].ate03
            IF l_n = 0 THEN
               CALL cl_err(g_ate1[l_ac].ate03,100,0)
               NEXT FIELD ate03
            END IF
            IF NOT cl_null(g_ate1[l_ac].ate02) AND NOT cl_null(g_ate1[l_ac].ate03) AND NOT cl_null(g_ate1[l_ac].ate06)
               AND NOT cl_null(g_ate1[l_ac].ate09) THEN
               SELECT COUNT(*) INTO l_n FROM ate_file WHERE ate01 = g_ate.ate01 AND ate02 = g_ate1[l_ac].ate02
                  AND ate03 = g_ate1[l_ac].ate03 AND ate04 = g_ate.ate04 AND ate05 = g_ate.ate05
                  AND ate06 = g_ate1[l_ac].ate06 AND ate09 = g_ate1[l_ac].ate09
               IF l_n > 0 THEN
                  LET g_ate1[l_ac].ate03 = g_ate1_t.ate03
                  CALL cl_err('','-239',0)
                  NEXT FIELD ate03
               END IF
            END IF
         END IF

      AFTER FIELD ate09                        #check 編號是否重複
         IF g_ate1[l_ac].ate09 != g_ate1_t.ate09 OR
            cl_null(g_ate1_t.ate09) THEN
            SELECT COUNT(*) INTO l_n FROM nml_file
             WHERE nml01 = g_ate1[l_ac].ate09
            IF l_n = 0 THEN
               CALL cl_err(g_ate1[l_ac].ate09,100,0)
               NEXT FIELD ate09
            END IF
            SELECT COUNT(*) INTO l_n FROM ate_file
             WHERE ate09 = g_ate1[l_ac].ate09
            IF l_n > 0 THEN    #科目已存在其他群組中
               IF NOT cl_confirm('agl-919') THEN
                  NEXT FIELD ate09
               END IF
            END IF
            IF NOT cl_null(g_ate1[l_ac].ate02) AND NOT cl_null(g_ate1[l_ac].ate03) AND NOT cl_null(g_ate1[l_ac].ate06)
               AND NOT cl_null(g_ate1[l_ac].ate09) THEN
               SELECT COUNT(*) INTO l_n FROM ate_file WHERE ate01 = g_ate.ate01 AND ate02 = g_ate1[l_ac].ate02
                  AND ate03 = g_ate1[l_ac].ate03 AND ate04 = g_ate.ate04 AND ate05 = g_ate.ate05
                  AND ate06 = g_ate1[l_ac].ate06 AND ate09 = g_ate1[l_ac].ate09
               IF l_n > 0 THEN
                  LET g_ate1[l_ac].ate09 = g_ate1_t.ate09
                  CALL cl_err('','-239',0)
                  NEXT FIELD ate09
               END IF
            END IF
            SELECT nml02 INTO g_ate1[l_ac].ate09_1 FROM nml_file
             WHERE nml01 = g_ate1[l_ac].ate09
         END IF
         IF NOT cl_null(g_ate1[l_ac].ate06) AND NOT cl_null(g_ate1[l_ac].ate09) THEN
            SELECT COUNT(*) INTO l_n1 FROM nml_file WHERE nml01 = g_ate1[l_ac].ate06 AND nml03 IN('10','20','30','40')
            SELECT COUNT(*) INTO l_n2 FROM nml_file WHERE nml01 = g_ate1[l_ac].ate09 AND nml03 IN('10','20','30','40')
            IF l_n1 > 0 AND l_n2 > 0 THEN
               IF g_ate1[l_ac].ate07 = '+' THEN
                  LET g_ate1[l_ac].ate10 = '-'
               END IF
               IF g_ate1[l_ac].ate07 = '-' THEN
                  LET g_ate1[l_ac].ate10 = '+'
               END IF
            ELSE
               IF g_ate1[l_ac].ate07 = '+' THEN
                  LET g_ate1[l_ac].ate10 = '+'
               END IF
               IF g_ate1[l_ac].ate07 = '-' THEN
                  LET g_ate1[l_ac].ate10 = '-'
               END IF
            END IF
         END IF

      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_ate1_t.ate02) AND NOT cl_null(g_ate1_t.ate03) AND NOT cl_null(g_ate1_t.ate06)
            AND NOT cl_null(g_ate1_t.ate09) THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM ate_file
             WHERE ate01 = g_ate.ate01   
               AND ate02 = g_ate1_t.ate02
               AND ate03 = g_ate1_t.ate03
               AND ate04 = g_ate.ate04
               AND ate05 = g_ate.ate05
               AND ate06 = g_ate1_t.ate06
               AND ate09 = g_ate1_t.ate09
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","ate_file",g_ate1_t.ate02,"",SQLCA.sqlcode,"","",1)
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF

      ON ROW CHANGE
         IF NOT cl_null(g_ate1_t.ate02) AND NOT cl_null(g_ate1_t.ate03) AND NOT cl_null(g_ate1_t.ate06)
            AND NOT cl_null(g_ate1_t.ate09) THEN 
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_ate1[l_ac].ate02,-263,1)
               LET g_ate1[l_ac].* = g_ate1_t.*
            ELSE
               UPDATE ate_file SET ate02 = g_ate1[l_ac].ate02,ate03 = g_ate1[l_ac].ate03,
                                   ate06 = g_ate1[l_ac].ate06,ate07 = g_ate1[l_ac].ate07,
                                   ate08 = g_ate1[l_ac].ate08,ate09 = g_ate1[l_ac].ate09,
                                   ate10 = g_ate1[l_ac].ate10,ate11 = g_ate1[l_ac].ate11
                WHERE ate01 = g_ate.ate01 AND ate02 = g_ate1_t.ate02
                  AND ate03 = g_ate1_t.ate03 AND ate04 = g_ate.ate04
                  AND ate05 = g_ate.ate05 AND ate06 = g_ate1_t.ate06
                  AND ate09 = g_ate1_t.ate09
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","ate_file",g_ate.ate01,g_ate1_t.ate02,SQLCA.sqlcode,"","",1)
                  LET g_ate1[l_ac].* = g_ate1_t.*
               ELSE
                  CALL cl_msg('UPDATE O.K')
               END IF
            END IF
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()
        #FUN-D30032----mark&add----str
        #LET l_ac_t = l_ac
        #IF p_cmd = 'u' THEN
        #   CLOSE t010_bcl
        #END IF
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_ate1[l_ac].* = g_ate1_t.*
            ELSE
               CALL g_ate1.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            END IF
            CLOSE t010_bcl
         END IF
         LET l_ac_t = l_ac
         CLOSE t010_bcl 
        #FUN-D30032----mark&add----end

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ate02)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_asg"
              LET g_qryparam.default1 = g_ate1[l_ac].ate02
              CALL cl_create_qry() RETURNING g_ate1[l_ac].ate02
              NEXT FIELD ate02
            WHEN INFIELD(ate06)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_nml"
              LET g_qryparam.default1 = g_ate1[l_ac].ate06
              CALL cl_create_qry() RETURNING g_ate1[l_ac].ate06
              NEXT FIELD ate06
            WHEN INFIELD(ate03)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_asg"
              LET g_qryparam.default1 = g_ate1[l_ac].ate03
              CALL cl_create_qry() RETURNING g_ate1[l_ac].ate03
              NEXT FIELD ate03
            WHEN INFIELD(ate09)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_nml"
              LET g_qryparam.default1 = g_ate1[l_ac].ate09
              CALL cl_create_qry() RETURNING g_ate1[l_ac].ate09
              NEXT FIELD ate09
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

   LET l_sql = "SELECT ate02,ate06,'',ate07,ate08,ate03,ate09,'',ate10,ate11 FROM ate_file ",
               " WHERE ate01 = '",g_ate.ate01,"'",     
               "   AND ate04 = '",g_ate.ate04,"'",
               "   AND ate05 = '",g_ate.ate05,"'",
               "   AND ",p_wc CLIPPED, 
               " ORDER BY ate01,ate03,ate04,ate02,ate06 "

   PREPARE ate_pre FROM l_sql
   DECLARE ate_cs CURSOR FOR ate_pre

   CALL g_ate1.clear()
   LET g_cnt = 1
   LET l_flag='N'
   LET g_rec_b=0
   FOREACH ate_cs INTO g_ate1[g_cnt].*     #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT nml02 INTO g_ate1[g_cnt].ate06_1 FROM nml_file WHERE nml01 = g_ate1[g_cnt].ate06
      SELECT nml02 INTO g_ate1[g_cnt].ate09_1 FROM nml_file WHERE nml01 = g_ate1[g_cnt].ate09
      LET l_flag='Y'
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
       EXIT FOREACH
      END IF
   END FOREACH
   CALL g_ate1.deleteElement(g_cnt)
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
   DISPLAY ARRAY g_ate1 TO s_ate1.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
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
   IF cl_null(g_ate.ate01) AND cl_null(g_ate.ate04) AND cl_null(g_ate.ate05) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF
   BEGIN WORK

   IF cl_delh(0,0) THEN
      DELETE FROM ate_file WHERE ate01=g_ate.ate01 AND ate04=g_ate.ate04  
                             AND ate05=g_ate.ate05      
      #TQC-C60142--add--str--
      LET g_sql_tmp= "SELECT UNIQUE ate01,ate04,ate05 FROM ate_file ",
                     " WHERE ",g_wc CLIPPED,
                     "   INTO TEMP x"
      DROP TABLE x
      PREPARE t010_pre_x1 FROM g_sql_tmp
      EXECUTE t010_pre_x1
      DELETE FROM x WHERE ate01=g_ate.ate01 AND ate04=g_ate.ate04
                      AND ate05=g_ate.ate05     
      #TQC-C60142--add--end--                      
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","ate_file",g_ate.ate01,'',SQLCA.sqlcode,"","",1)
      ELSE
         CLEAR FORM
         CALL g_ate1.clear()
         OPEN t010_count
         #TQC-C60142--add--str--
         IF STATUS THEN
            CLOSE t010_b_cs
            CLOSE t010_count
            COMMIT WORK
            RETURN
         END IF
         #TQC-C60142--add--str--
         FETCH t010_count INTO g_row_count
         #TQC-C60142--add--str--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t010_b_cs
            CLOSE t010_count
            COMMIT WORK
            RETURN
         END IF
         #TQC-C60142--add--str--
         #LET g_row_count = g_row_count -1     #刪除完後筆數會算錯(多一筆),所以要減一   #TQC-C60142  mark
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
