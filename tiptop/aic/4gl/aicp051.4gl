# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: aicp051.4gl
# Descriptions...: WIP資料交換作業
# Date & Author..: NO.FUN-7B0077 08/01/11 By mike
# Modify.........: No.FUN-830066 08/03/21 By mike 補充"相關文件"按鈕
# Modify.........: No.FUN-830131 08/03/26 By mike 補充設定檔是否符合轉檔條件的判斷語句
# Modify.........: No.MOD-8B0036 08/11/05 By chenyu 語言別的要根據不同的情況用不同的值，不能直接用BIG5
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.FUN-980004 09/08/26 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No.TQC-A10060 10/01/08 By wuxj   修改INSERT INTO加入oriu及orig這2個欄位
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A30038 09/03/09 By lutingting windows改用zhcode方式來進行轉碼
# Modify.........: No.FUN-A90024 10/11/16 By Jay 調整各DB利用sch_file取得table與field等資訊
# Modify.........; No.FUN-B30176 11/03/25 By xianghui 使用iconv須區分為FOR UNIX& FOR Windows,批量去除$TOP
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80083 11/08/08 By minpp程序撰寫規範修改
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No.FUN-D40030 13/04/07 By xuxz 單身新增時按下放棄鍵未執行AFTER INSERT的問題

IMPORT os   #No.FUN-9C0009 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_idm        RECORD LIKE idm_file.*,   #(單頭)
       g_idm_t      RECORD LIKE idm_file.*,   #(舊值)
       g_idm_o      RECORD LIKE idm_file.*,   #(舊值)
       g_idm01_t    LIKE idm_file.idm01,      #(舊值)
       g_idm02_t    LIKE idm_file.idm02,      #(舊值)
       g_idn        DYNAMIC ARRAY OF RECORD   #程序變量(Program Variables)
                          idn03   LIKE idn_file.idn03, #順序
                          idn04   LIKE idn_file.idn04, #文檔名稱
                          idn05   LIKE idn_file.idn05, #字段編號
                          gaq03   LIKE gaq_file.gaq03  #字段名稱
                    END RECORD,
       g_idn_t      RECORD                    #程序變量(舊值)
                          idn03   LIKE idn_file.idn03, #順序
                          idn04   LIKE idn_file.idn04, #文檔名稱
                          idn05   LIKE idn_file.idn05, #字段編號
                          gaq03   LIKE gaq_file.gaq03  #字段名稱
                    END RECORD,
       g_idn_o      RECORD                       #程序變量(舊值)
                          idn03   LIKE idn_file.idn03, #順序
                          idn04   LIKE idn_file.idn04, #文檔名稱
                          idn05   LIKE idn_file.idn05, #字段編號
                          gaq03   LIKE gaq_file.gaq03  #字段名稱
                    END RECORD
 
DEFINE g_sql        STRING                      #CURSOR暫存
DEFINE g_wc         STRING                      #單頭CONSTRUCT結果
DEFINE g_wc2        STRING                      #單身CONSTRUCT結果
DEFINE g_rec_b      LIKE type_file.num5         #單身筆數
DEFINE l_ac         LIKE type_file.num5         #目前處理的ARRAY CNT
DEFINE g_forupd_sql        STRING                #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num5   #count/index for any purpose
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10  #總筆數
DEFINE g_jump              LIKE type_file.num10  #查詢指定的筆數
DEFINE g_no_ask            LIKE type_file.num5   #是否開放指定筆視窗
DEFINE g_argv1             LIKE type_file.chr1   #由p_cron呼叫
DEFINE gs_fname            STRING
DEFINE g_name              STRING                #報表原始名稱
DEFINE l_table             STRING   
DEFINE g_str               STRING
DEFINE ms_codeset          STRING                   #No.MOD-8B0036 add
DEFINE ms_locale           STRING                   #No.MOD-8B0036 add
 
MAIN
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_argv1=ARG_VAL(1)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF
 
   IF NOT s_industry("icd") THEN                                                                                                    
      CALL cl_err('','aic-999',1)                                                                                                   
      EXIT PROGRAM                                                                                                                  
   END IF             
 
   LET g_sql = "count.type_file.num5,",
               "msg.ze_file.ze03 "
   LET l_table = cl_prt_temptable('aicp051',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?)"
   PREPARE insert_prep FROM g_sql   
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

  #由p_cron呼叫
   IF NOT cl_null(g_argv1) THEN
     #CREATE TEMP TABLE放置符合的設定檔
      DROP TABLE p051_file;
      CREATE TEMP TABLE p051_file(
       temp010   LIKE type_file.chr10,
       temp020   LIKE type_file.chr10,
       temp0301  LIKE type_file.num5,
       temp0302  LIKE type_file.num5,
       temp040   LIKE type_file.chr1);
      CALL p051_change(g_argv1)
      DROP TABLE p051_file;
   ELSE
      LET g_forupd_sql = "SELECT * FROM idm_file  WHERE idm01 = ? AND idm02 = ? FOR UPDATE "
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
      DECLARE p051_cl CURSOR FROM g_forupd_sql
 
      OPEN WINDOW p051_w WITH FORM "aic/42f/aicp051"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
      CALL cl_ui_init()
 
      CALL p051_menu()
      CLOSE WINDOW p051_w                 #結束畫面
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE查詢資料
FUNCTION p051_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01
 
   CLEAR FORM                             #清除畫面
   CALL g_idn.clear()
 
   CONSTRUCT BY NAME g_wc ON idm01,idm02,idm03,idm05
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(idm01) #廠商編號
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_pmc2"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO idm01
               CALL p051_idm01('d')
               NEXT FIELD idm01
 
            OTHERWISE EXIT CASE
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
         CALL cl_qbe_list() RETURNING lc_qbe_sn
        CALL cl_qbe_display_condition(lc_qbe_sn) 
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   CONSTRUCT g_wc2 ON idn03,idn04,idn05
        FROM s_idn[1].idn03,s_idn[1].idn04,
             s_idn[1].idn05
 
      BEFORE CONSTRUCT
        CALL cl_qbe_display_condition(lc_qbe_sn) 
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(idn04) #文檔名稱
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gat"
               LET g_qryparam.arg1 = g_lang
               LET g_qryparam.state = "c" 
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO idn04
               NEXT FIELD idn04
 
             WHEN INFIELD(idn05) #字段名稱
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gaq"
               LET g_qryparam.arg1 = g_lang
               LET g_qryparam.state = "c" 
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO idn05
               NEXT FIELD idn05
             OTHERWISE EXIT CASE
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
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
   END CONSTRUCT
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   IF g_wc2 = " 1=1" THEN                  #若單身未輸入條件
      LET g_sql = "SELECT idm01,idm02 FROM idm_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY idm01,idm02"
   ELSE                              #若單身有輸入條件
      LET g_sql = "SELECT UNIQUE idm_file.idm01,idm02 ",
                  "  FROM idm_file, idn_file ",
                  " WHERE idm01 = idn01",
                  "   AND idm02 = idn02",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY idm01,idm02"
   END IF
 
   PREPARE p051_prepare FROM g_sql
   DECLARE p051_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR p051_prepare
 
END FUNCTION
 
FUNCTION p051_count()
DEFINE la_idm   DYNAMIC ARRAY of RECORD        #程序變量               
                      idm01 LIKE idm_file.idm01,
                      idm02 LIKE idm_file.idm02
                   END RECORD
DEFINE li_cnt      LIKE type_file.num10
DEFINE li_rec_b    LIKE type_file.num10
 
   IF cl_null(g_wc) THEN
      LET g_wc = ' 1=1'
   END IF
 
   IF cl_null(g_wc2) THEN
      LET g_wc2 = ' 1=1'
   END IF
 
   IF g_wc2 = " 1=1" THEN                  #取合乎條件筆數
      LET g_sql = "SELECT idm01,idm02 FROM idm_file",
                  " WHERE ",g_wc CLIPPED,
                  " GROUP BY idm01,idm02"
   ELSE
      LET g_sql = "SELECT idm01,idm02 FROM idm_file,idn_file ",
                  " WHERE idn01 = idm01", 
                  "   AND idn02 = idm02", 
                  "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                  " GROUP BY idm01,idm02"
   END IF
 
   PREPARE p051_precount FROM g_sql
   DECLARE p051_count CURSOR FOR p051_precount                        
   LET li_cnt=1                                                                 
   LET li_rec_b=0                                                               
   FOREACH p051_count INTO la_idm[li_cnt].*                                 
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
 
 
FUNCTION p051_menu()
DEFINE l_n  LIKE type_file.num10
 
   WHILE TRUE
      CALL p051_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL p051_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL p051_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL p051_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL p051_u()
            END IF
 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL p051_copy()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p051_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "aic_change_file" #轉檔
            IF cl_chk_act_auth() THEN
              #無單身，不做轉檔
               LET l_n = 0 
               SELECT COUNT(*) INTO l_n FROM idn_file
                WHERE idn01 = g_idm.idm01
                  AND idn02 = g_idm.idm02
                  AND idn04 = 'ido_file'
               IF l_n = 0 THEN
                  CALL cl_err('','aws-068',1)
                  CONTINUE WHILE
               END IF
 
               CALL p051_change('')
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
   
         #FUN-830066  --begin
         WHEN "related_document"           #相關文件                                                                                
            IF cl_chk_act_auth() THEN                                                                                               
               IF g_idm.idm01 IS NOT NULL THEN                                                                                          
                  LET g_doc.column1 = "idm01"                                                                                       
                  LET g_doc.value1 = g_idm.idm01                                                                                        
                  CALL cl_doc()                                                                                                     
               END IF                                                                                                               
            END IF                   
         #FUN-830066  --END
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_idn),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p051_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_idn TO s_idn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL p051_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL p051_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL p051_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL p051_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL p051_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION aic_change_file #轉檔
         LET g_action_choice="aic_change_file"
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
         LET INT_FLAG = FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      #No.FUN-830066  --BEGIN
      ON ACTION related_document                                                                                                    
         LET g_action_choice="related_document"                                                                                     
         EXIT DISPLAY 
      #No.FUN-830066  --END
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p051_bp_refresh()
 
   DISPLAY ARRAY g_idn TO s_idn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
   END DISPLAY
 
END FUNCTION
 
FUNCTION p051_a()
DEFINE   li_result   LIKE type_file.num10
DEFINE   ls_doc      STRING
DEFINE   li_inx      LIKE type_file.num10
 
   MESSAGE ""
   CLEAR FORM
   CALL g_idn.clear()
   LET g_wc = NULL
   LET g_wc2 = NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_idm.* LIKE idm_file.*             #DEFAULT設定
   LET g_idm01_t = NULL
   LET g_idm02_t = NULL
 
   #預設值及將數值類變量清成零
   LET g_idm_t.* = g_idm.*
   LET g_idm_o.* = g_idm.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_idm.idm02 = '00'
     #LET g_idm.idm03 = '/$TEMPDIR/ICD/WIP/upload'   #No.FUN-830131
      LET g_idm.idm03 = FGL_GETENV("TEMPDIR"),'/ICD/WIP/upload'   #No.FUN-830131
      LET g_idm.idm05 = '0'
      LET g_idm.idm08 = 0
      LET g_idm.idmplant = g_plant #FUN-980004 add
      LET g_idm.idmlegal = g_legal #FUN-980004 add
 
      CALL p051_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_idm.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',0511,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_idm.idm01) OR       # KEY不可空白
         cl_null(g_idm.idm02) THEN
         CONTINUE WHILE
      END IF
 
      INSERT INTO idm_file VALUES (g_idm.*)
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #置入數據庫不成功
         CALL cl_err(g_idm.idm01,SQLCA.sqlcode,1)  #FUN-B80083  ADD
         ROLLBACK WORK
        # CALL cl_err(g_idm.idm01,SQLCA.sqlcode,1)  #FUN-B80083 MARK
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_idm.idm01,'I')
      END IF
 
      SELECT idm01,idm02 INTO g_idm.idm01,g_idm.idm02 FROM idm_file
       WHERE idm01 = g_idm.idm01
         AND idm02 = g_idm.idm02
      LET g_idm01_t = g_idm.idm01        #保留舊值
      LET g_idm02_t = g_idm.idm02        #保留舊值
      LET g_idm_t.* = g_idm.*
      LET g_idm_o.* = g_idm.*
      CALL g_idn.clear()
 
      LET g_rec_b = 0 
      CALL p051_b()                   #輸入單身
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION p051_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_idm.idm01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_idm.* FROM idm_file
    WHERE idm01 = g_idm.idm01
      AND idm02 = g_idm.idm02
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_idm01_t = g_idm.idm01
   LET g_idm02_t = g_idm.idm02
 
   BEGIN WORK
 
   OPEN p051_cl USING g_idm.idm01,g_idm.idm02
   IF SQLCA.sqlcode THEN
      CALL cl_err("OPEN p051_cl:",SQLCA.sqlcode, 1)
      CLOSE p051_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH p051_cl INTO g_idm.*                      #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_idm.idm01,SQLCA.sqlcode,0)    #資料被他人LOCK
      CLOSE p051_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL p051_show()
 
   WHILE TRUE
      LET g_idm01_t = g_idm.idm01
      LET g_idm02_t = g_idm.idm02
      LET g_idm_o.* = g_idm.*
 
      CALL p051_i("u")                      #字段更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_idm.* = g_idm_t.*
         CALL p051_show()
         CALL cl_err('','0511',0)
         EXIT WHILE
      END IF
 
      IF g_idm.idm01 != g_idm01_t OR   #更改key值
         g_idm.idm02 != g_idm02_t THEN
         UPDATE idn_file SET idn01 = g_idm.idm01,
                                idn02 = g_idm.idm02
          WHERE idn01 = g_idm01_t
            AND idn02 = g_idm02_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err('idn',SQLCA.sqlcode,0)
            CONTINUE WHILE
         END IF
      END IF
 
     UPDATE idm_file SET idm_file.* = g_idm.*
      WHERE idm01 = g_idm01_t AND idm02 = g_idm02_t
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err(g_idm.idm01,SQLCA.sqlcode,0)
        CONTINUE WHILE
     END IF
     EXIT WHILE
  END WHILE
  CLOSE p051_cl
  COMMIT WORK
  CALL cl_flow_notify(g_idm.idm01,'U')
 
   CALL p051_b_fill(" 1=1")
   CALL p051_bp_refresh()
 
END FUNCTION
 
FUNCTION p051_i(p_cmd)
DEFINE l_pmc05     LIKE pmc_file.pmc05,
       l_pmc30     LIKE pmc_file.pmc30,
       l_n         LIKE type_file.num10,
       p_cmd       LIKE type_file.chr1,               #a:輸入 u:更改
       li_result   LIKE type_file.num10
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_idm.idm02,g_idm.idm03,g_idm.idm05
 
   INPUT BY NAME g_idm.idm01,g_idm.idm02,g_idm.idm05
      WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL p051_set_entry(p_cmd)
         CALL p051_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD idm01 #廠商編號
         IF NOT cl_null(g_idm.idm01) THEN
            CALL p051_idm01(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_idm.idm01,g_errno,0)
               LET g_idm.idm01 = g_idm_o.idm01
               DISPLAY BY NAME g_idm.idm01
               NEXT FIELD idm01
            END IF
            LET g_idm_o.idm01 = g_idm.idm01
         END IF
 
      AFTER FIELD idm02 #工廠
         IF NOT cl_null(g_idm.idm02) THEN
            IF NOT cl_null(g_idm.idm01) THEN 
               IF p_cmd = 'a' OR (p_cmd = 'u' AND (
                  g_idm.idm01 != g_idm01_t OR
                  g_idm.idm02 != g_idm02_t)) THEN
                  LET g_cnt = 0 
                  SELECT COUNT(*) INTO g_cnt FROM idm_file
                   WHERE idm01 = g_idm.idm01
                     AND idm02 = g_idm.idm02
                  IF g_cnt > 0 THEN
                     CALL cl_err('','-239',0)
                     LET g_idm.idm02 = g_idm_o.idm02
                     DISPLAY BY NAME g_idm.idm02
                     NEXT FIELD idm02
                  END IF
               END IF
            END IF
            LET g_idm_o.idm02 = g_idm.idm02
         END IF
 
      AFTER FIELD idm05 #字段分隔符號
         IF NOT cl_null(g_idm.idm05) THEN
            IF g_idm.idm05 NOT MATCHES '[01]' THEN
               LET g_idm.idm05 = g_idm_o.idm05
               NEXT FIELD idm05
            END IF
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN                   #使用者不玩了
            CALL cl_err('',0511,0)
            EXIT INPUT
         END IF
         IF NOT cl_null(g_idm.idm01) AND
            NOT cl_null(g_idm.idm02) THEN 
            IF p_cmd = 'a' OR (p_cmd = 'u' AND (
               g_idm.idm01 != g_idm01_t OR
               g_idm.idm02 != g_idm02_t)) THEN
               LET g_cnt = 0 
               SELECT COUNT(*) INTO g_cnt FROM idm_file
                WHERE idm01 = g_idm.idm01
                  AND idm02 = g_idm.idm02
               IF g_cnt > 0 THEN
                  CALL cl_err('','-239',0)
                  LET g_idm.idm02 = g_idm_o.idm02
                  DISPLAY BY NAME g_idm.idm02
                  NEXT FIELD idm02
               END IF
            END IF
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF #字段說明
         CALL cl_set_focus_form(ui.Interface.getRootNode())
            RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON ACTION controlp
         CASE
             WHEN INFIELD(idm01) #廠商編號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pmc2"
               LET g_qryparam.default1 = g_idm.idm01
               CALL cl_create_qry() RETURNING g_idm.idm01
               DISPLAY BY NAME g_idm.idm01
               CALL p051_idm01('d')
               NEXT FIELD idm01
 
            OTHERWISE EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
 
END FUNCTION
 
 
FUNCTION p051_idm01(p_cmd) #廠商編號
DEFINE l_pmc03   LIKE pmc_file.pmc03,
       l_pmcacti LIKE pmc_file.pmcacti,
       p_cmd     LIKE type_file.chr1
 
   LET g_errno = " "
 
   SELECT pmc03,pmcacti INTO l_pmc03,l_pmcacti
     FROM pmc_file WHERE pmc01 = g_idm.idm01
 
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg3001'
        WHEN l_pmcacti = 'N'     LET g_errno = '9028'
        OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_pmc03 TO FORMONLY.pmc03
   END IF
 
END FUNCTION
 
 
FUNCTION p051_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   INITIALIZE g_idm.* TO NULL
   CLEAR FORM
   CALL g_idn.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL p051_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_idm.* TO NULL
      RETURN
   END IF
 
   OPEN p051_cs                            #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_idm.* TO NULL
   ELSE
      CALL p051_count()
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL p051_fetch('F')                  #讀出TEMP第一筆并顯示
   END IF
 
END FUNCTION
 
FUNCTION p051_fetch(p_flag)
DEFINE p_flag          LIKE type_file.chr1   #處理方式
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     p051_cs INTO g_idm.idm01,
                                           g_idm.idm02
      WHEN 'P' FETCH PREVIOUS p051_cs INTO g_idm.idm01,
                                           g_idm.idm02
      WHEN 'F' FETCH FIRST    p051_cs INTO g_idm.idm01,
                                           g_idm.idm02
      WHEN 'L' FETCH LAST     p051_cs INTO g_idm.idm01,
                                           g_idm.idm02
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
 
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
 
         END IF
         FETCH ABSOLUTE g_jump p051_cs INTO g_idm.idm01,
                                            g_idm.idm02
         LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_idm.idm01,SQLCA.sqlcode,0)
      INITIALIZE g_idm.* TO NULL
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
      DISPLAY g_curs_index TO FORMONLY.idx
   END IF
 
   SELECT * INTO g_idm.* FROM idm_file WHERE idm01 = g_idm.idm01 AND idm02 = g_idm.idm02
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_idm.idm01,SQLCA.sqlcode,0)
      INITIALIZE g_idm.* TO NULL
      RETURN
   END IF
 
   CALL p051_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION p051_show()
   LET g_idm_t.* = g_idm.*                #保存單頭舊值
   LET g_idm_o.* = g_idm.*                #保存單頭舊值
 
   DISPLAY BY NAME g_idm.idm01,g_idm.idm02,g_idm.idm03,
                   g_idm.idm05
 
   CALL p051_idm01('d')
 
   CALL p051_b_fill(g_wc2)                 #單身
 
   CALL cl_show_fld_cont()
 
END FUNCTION
 
 
FUNCTION p051_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_idm.idm01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_idm.* FROM idm_file
    WHERE idm01 = g_idm.idm01
      AND idm02 = g_idm.idm02
 
   BEGIN WORK
 
   OPEN p051_cl USING g_idm.idm01,g_idm.idm02
   IF SQLCA.sqlcode THEN
      CALL cl_err("OPEN p051_cl:",SQLCA.sqlcode, 1)
      CLOSE p051_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH p051_cl INTO g_idm.*   #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_idm.idm01,SQLCA.sqlcode,0) #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL p051_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "idm01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_idm.idm01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM idm_file WHERE idm01 = g_idm.idm01
                                AND idm02 = g_idm.idm02
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('del idm',SQLCA.sqlcode,0)
         ROLLBACK WORK
         RETURN
      END IF
      DELETE FROM idn_file WHERE idn01 = g_idm.idm01
                                AND idn02 = g_idm.idm02
      IF SQLCA.sqlcode THEN
         CALL cl_err('del idn',SQLCA.sqlcode,0)
         ROLLBACK WORK
         RETURN
      END IF
      CLEAR FORM
      CALL g_idn.clear()
      CALL p051_count()
      #FUN-B50062-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE p051_cs
         CLOSE p051_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN p051_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL p051_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL p051_fetch('/')
      END IF
   END IF
 
   CLOSE p051_cl
   COMMIT WORK
   CALL cl_flow_notify(g_idm.idm01,'D')
 
END FUNCTION
 
#單身
FUNCTION p051_b()
DEFINE l_ac_t          LIKE type_file.num10,              #未取消的ARRAY CNT
       l_n             LIKE type_file.num10,              #檢查重復用
       l_cnt           LIKE type_file.num10,              #檢查重復用
       l_lock_sw       LIKE type_file.chr1,               #單身鎖住否
       p_cmd           LIKE type_file.chr1,               #處理狀態
       l_allow_insert  LIKE type_file.num10,              #可新增否
       l_allow_delete  LIKE type_file.num10,              #可刪除否
       ls_str          STRING,
       li_inx          LIKE type_file.num10
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_idm.idm01) THEN
      RETURN
   END IF
 
   SELECT * INTO g_idm.* FROM idm_file
    WHERE idm01 = g_idm.idm01
      AND idm02 = g_idm.idm02
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT idn03,idn04,idn05,''",
                      "  FROM idn_file",
                      "  WHERE idn01 = ? AND idn02 = ?",
                      "   AND idn03 = ?",
                      "   FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p051_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_idn WITHOUT DEFAULTS FROM s_idn.*
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         DISPLAY "BEFORE INPUT!"
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         DISPLAY "BEFORE ROW!"
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
 
         BEGIN WORK
 
         OPEN p051_cl USING g_idm.idm01,g_idm.idm02
         IF SQLCA.sqlcode THEN
            CALL cl_err("OPEN p051_cl:", SQLCA.sqlcode, 1)
            CLOSE p051_cl
            ROLLBACK WORK
            RETURN
         END IF
 
         FETCH p051_cl INTO g_idm.*            #鎖住將被更改或取消的資料
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_idm.idm01,SQLCA.sqlcode,0) #資料被他人LOCK
            CLOSE p051_cl
            ROLLBACK WORK
            RETURN
         END IF
 
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_idn_t.* = g_idn[l_ac].*  #BACKUP
            LET g_idn_o.* = g_idn[l_ac].*  #BACKUP
            OPEN p051_bcl USING g_idm.idm01,g_idm.idm02,
                                g_idn_t.idn03
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN p051_bcl:", SQLCA.sqlcode, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH p051_bcl INTO g_idn[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_idn_t.idn03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            SELECT gaq03 INTO g_idn[l_ac].gaq03 FROM gaq_file
             WHERE gaq01 = g_idn[l_ac].idn05                          
               AND gaq02 = g_lang 
            DISPLAY BY NAME g_idn[l_ac].gaq03
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         DISPLAY "BEFORE INSERT!"
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_idn[l_ac].* TO NULL
         LET g_idn[l_ac].idn04 = 'ido_file'
         LET g_idn_t.* = g_idn[l_ac].*         #新輸入資料
         LET g_idn_o.* = g_idn[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()
         NEXT FIELD idn03
 
      AFTER INSERT
         DISPLAY "AFTER INSERT!"
         IF INT_FLAG THEN
            CALL cl_err('',0511,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF NOT cl_null(g_idn[l_ac].idn05) AND
            NOT cl_null(g_idn[l_ac].idn04) THEN
            LET l_n = 0 
            #---FUN-A90024---start-----
            #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
            #目前統一用sch_file紀錄TIPTOP資料結構
            #SELECT COUNT(*) INTO l_n FROM syscolumns
            # WHERE id = object_id(g_idn[l_ac].idn04)
            #   AND lower(name) = g_idn[l_ac].idn05
            SELECT COUNT(*) INTO l_n FROM sch_file
              WHERE sch01 = g_idn[l_ac].idn04 AND sch02 = g_idn[l_ac].idn05
            #---FUN-A90024---end------- 
            IF l_n = 0 THEN
               CALL cl_err(g_idn[l_ac].idn05,'aic-033',1)
               CANCEL INSERT
               CALL g_idn.deleteElement(l_ac)
            END IF
         END IF
         INSERT INTO idn_file(idn01,idn02,idn03,idn04,
                                 idn05,idnplant,idnlegal) #FUN-980004 add idnplant,idnlegal
                          VALUES(g_idm.idm01,g_idm.idm02,
                                 g_idn[l_ac].idn03,
                                 g_idn[l_ac].idn04,
                                 g_idn[l_ac].idn05,g_plant,g_legal) #FUN-980004 add g_plant,g_legal
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err(g_idn[l_ac].idn03,SQLCA.sqlcode,0)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      AFTER FIELD idn03 #順序
         IF NOT cl_null(g_idn[l_ac].idn03) THEN
            IF p_cmd = 'a' OR (p_cmd = 'u' AND
               g_idn[l_ac].idn03 != g_idn_t.idn03) THEN
               LET l_n = 0 
               SELECT COUNT(*) INTO l_n FROM idn_file
               WHERE idn01 = g_idm.idm01
                 AND idn02 = g_idm.idm02
                 AND idn03 = g_idn[l_ac].idn03
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_idn[l_ac].idn03 = g_idn_o.idn03
                  DISPLAY BY NAME g_idn[l_ac].idn03
                  NEXT FIELD idn03
               END IF
            END IF
            LET g_idn_o.idn03 = g_idn[l_ac].idn03
         END IF
 
      AFTER FIELD idn04 #文檔名稱
         IF NOT cl_null(g_idn[l_ac].idn04) THEN
            IF g_idn[l_ac].idn04 != 'ido_file' THEN
               CALL cl_err(g_idn[l_ac].idn04,'aic-031',0)
               LET g_idn[l_ac].idn04 = g_idn_o.idn04
               DISPLAY BY NAME g_idn[l_ac].idn04
               NEXT FIELD idn04
            END IF
            LET l_n = 0
            #---FUN-A90024---start-----
            #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
            #目前統一用sch_file紀錄TIPTOP資料結構 
            #SELECT COUNT(*) INTO l_n FROM sysobjects
            # WHERE lower(name) = g_idn[l_ac].idn04
            SELECT COUNT(*) INTO l_n FROM sch_file
              WHERE sch01 = g_idn[l_ac].idn04
            #---FUN-A90024---end-------  
            IF l_n = 0  THEN
               CALL cl_err(g_idn[l_ac].idn04,'aic-032',0)
               LET g_idn[l_ac].idn04 = g_idn_o.idn04
               DISPLAY BY NAME g_idn[l_ac].idn04
               NEXT FIELD idn04
            END IF
            LET g_idn_o.idn04 = g_idn[l_ac].idn04
         END IF
 
      AFTER FIELD idn05 #字段編號
         IF NOT cl_null(g_idn[l_ac].idn05) THEN
            IF NOT cl_null(g_idn[l_ac].idn04) THEN
               LET l_n = 0 
               #---FUN-A90024---start-----
               #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
               #目前統一用sch_file紀錄TIPTOP資料結構
               #SELECT COUNT(*) INTO l_n FROM syscolumns
               # WHERE id = object_id(g_idn[l_ac].idn04)
               #   AND lower(name) = g_idn[l_ac].idn05
               SELECT COUNT(*) INTO l_n FROM sch_file
                 WHERE sch01 = g_idn[l_ac].idn04 AND sch02 = g_idn[l_ac].idn05
               #---FUN-A90024---end------- 
               IF l_n = 0 THEN
                  CALL cl_err(g_idn[l_ac].idn05,'aic-033',0)
                  LET g_idn[l_ac].idn05 = g_idn_o.idn05
                  DISPLAY BY NAME g_idn[l_ac].idn05
                  NEXT FIELD idn05
               END IF
            END IF
            SELECT gaq03 INTO g_idn[l_ac].gaq03 FROM gaq_file
             WHERE gaq01 = g_idn[l_ac].idn05                          
               AND gaq02 = g_lang 
            DISPLAY BY NAME g_idn[l_ac].gaq03
            LET g_idn_o.idn05 = g_idn[l_ac].idn05
         END IF
 
      BEFORE DELETE                      #是否取消單身
         DISPLAY "BEFORE DELETE"
         IF g_idn_t.idn03 > 0 AND NOT cl_null(g_idn_t.idn03) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM idn_file
             WHERE idn01 = g_idm.idm01
               AND idn02 = g_idm.idm02
               AND idn03 = g_idn_t.idn03
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err(g_idn_t.idn03,SQLCA.sqlcode,0)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',0511,0)
            LET INT_FLAG = 0
            LET g_idn[l_ac].* = g_idn_t.*
            CLOSE p051_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_idn[l_ac].idn03,-263,1)
            LET g_idn[l_ac].* = g_idn_t.*
         ELSE
            IF NOT cl_null(g_idn[l_ac].idn05) AND
               NOT cl_null(g_idn[l_ac].idn04) THEN
               LET l_n = 0 
               #---FUN-A90024---start-----
               #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
               #目前統一用sch_file紀錄TIPTOP資料結構
               #SELECT COUNT(*) INTO l_n FROM syscolumns
               # WHERE id = object_id(g_idn[l_ac].idn04)
               #   AND lower(name) = g_idn[l_ac].idn05
               SELECT COUNT(*) INTO l_n FROM sch_file
                 WHERE sch01 = g_idn[l_ac].idn04 AND sch02 = g_idn[l_ac].idn05
               #---FUN-A90024---end------- 
               IF l_n = 0 THEN
                  CALL cl_err(g_idn[l_ac].idn05,'aic-033',0)
                  LET g_idn[l_ac].idn05 = g_idn_o.idn05
                  DISPLAY BY NAME g_idn[l_ac].idn05
                  NEXT FIELD idn05
               END IF
            END IF
           #UPDATE idn_fiile SET idn03 = g_idn[l_ac].idn03,  #No.FUN-830131
            UPDATE idn_file  SET idn03 = g_idn[l_ac].idn03,  #No.FUN-830131
                                 idn04 = g_idn[l_ac].idn04,
                                 idn05 = g_idn[l_ac].idn05
             WHERE idn01 = g_idm.idm01
               AND idn02 = g_idm.idm02
               AND idn03 = g_idn_t.idn03
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err(g_idn[l_ac].idn03,SQLCA.sqlcode,1)
               LET g_idn[l_ac].* = g_idn_t.*
               DISPLAY BY NAME g_idn[l_ac].*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         DISPLAY  "AFTER ROW!!"
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac#FUN-D40030 mark
         IF INT_FLAG THEN
            CALL cl_err('',0511,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_idn[l_ac].* = g_idn_t.*
           #FUN-D40030--add--str
            ELSE
               CALL g_idn.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
           #FUN-D40030--add--end
            END IF
            CLOSE p051_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac#FUN-D40030add
         CLOSE p051_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(idn03) AND l_ac > 1 THEN
            LET g_idn[l_ac].* = g_idn[l_ac-1].*
            DISPLAY BY NAME g_idn[l_ac].*
            NEXT FIELD idn03
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(idn04) #文檔名稱
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gat"
               LET g_qryparam.arg1 = g_lang
               LET g_qryparam.default1 = g_idn[l_ac].idn04
               CALL cl_create_qry() RETURNING g_idn[l_ac].idn04
               DISPLAY BY NAME g_idn[l_ac].idn04
               NEXT FIELD idn04
 
            WHEN INFIELD(idn05) #字段名稱
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gaq"
               LET g_qryparam.arg1 = g_lang
               LET ls_str = g_idn[l_ac].idn04
               LET li_inx = ls_str.getIndexOf("_file",1)
               IF li_inx >= 1 THEN
                  LET ls_str = ls_str.subString(1,li_inx-1)
               ELSE
                  LET ls_str = ""
               END IF
               LET g_qryparam.arg2 = ls_str
               IF g_idn[l_ac].idn04 = 'ido_file' THEN
                  LET g_qryparam.where = "    gaq01 = 'ido04' OR gaq01 = 'ido05' ",
                                         " OR gaq01 = 'ido06' OR gaq01 = 'ido07' ",
                                         " OR gaq01 = 'ido08' OR gaq01 = 'ido09' ",
                                         " OR gaq01 = 'ido10' OR gaq01 = 'ido11' ",
                                         " OR gaq01 = 'ido12' OR gaq01 = 'ido13' ",
                                         " OR gaq01 = 'ido14' OR gaq01 = 'ido15' ",
                                         " OR gaq01 = 'ido16' OR gaq01 = 'ido17' ",
                                         " OR gaq01 = 'ido18' OR gaq01 = 'ido19' ",
                                         " OR gaq01 = 'ido20' OR gaq01 = 'ido21' ",
                                         " OR gaq01 = 'ido22' OR gaq01 = 'ido23' ",
                                         " OR gaq01 = 'ido24' OR gaq01 = 'ido25' "
               END IF  
               LET g_qryparam.default1 = g_idn[l_ac].idn05
               CALL cl_create_qry() RETURNING g_idn[l_ac].idn05
               DISPLAY BY NAME g_idn[l_ac].idn05
               NEXT FIELD idn05
 
            OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION CONTROLF #字段說明
         CALL cl_set_focus_form(ui.Interface.getRootNode())
            RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
 
   CLOSE p051_bcl
   COMMIT WORK
   CALL p051_delall()
 
END FUNCTION
 
FUNCTION p051_delall()
 
    SELECT COUNT(*) INTO g_cnt FROM idn_file
     WHERE idn01 = g_idm.idm01
       AND idn02 = g_idm.idm02
 
    IF g_cnt = 0 THEN   #未輸入單身資料，是否取消單頭資料
       IF NOT cl_confirm('9042') THEN
          RETURN
       END IF
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM idm_file WHERE idm01 = g_idm.idm01
                              AND idm02 = g_idm.idm02
    END IF
 
END FUNCTION
 
 
FUNCTION p051_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2       STRING
 
    LET g_sql = "SELECT idn03,idn04,idn05,''",
                "  FROM idn_file",
                " WHERE idn01 ='",g_idm.idm01,"' ",
                "   AND idn02 ='",g_idm.idm02,"' "
 
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    LET g_sql=g_sql CLIPPED," ORDER BY idn03,idn04,idn05 "
    DISPLAY g_sql
 
    PREPARE p051_pb FROM g_sql
    DECLARE idn_cs                       #CURSOR
        CURSOR FOR p051_pb
 
    CALL g_idn.clear()
    LET g_cnt = 1
 
    FOREACH idn_cs INTO g_idn[g_cnt].*   #單身ARRAY填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT gaq03 INTO g_idn[g_cnt].gaq03 FROM gaq_file
       WHERE gaq01 = g_idn[g_cnt].idn05
         AND gaq02 = g_lang
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_idn.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION p051_copy()
DEFINE l_new010        LIKE idm_file.idm01,
       l_new020        LIKE idm_file.idm02,
       l_old010        LIKE idm_file.idm01,
       l_old020        LIKE idm_file.idm02,
       l_pmc03         LIKE pmc_file.pmc03,
       l_pmcacti       LIKE pmc_file.pmcacti,
       li_result       LIKE type_file.num10
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_idm.idm01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL p051_set_entry('a')
   LET l_new020 = '00'
   DISPLAY l_new020 TO idm02
   DISPLAY '' TO FORMONLY.pmc03
 
   INPUT l_new010,l_new020 WITHOUT DEFAULTS FROM idm01,idm02
 
      AFTER FIELD idm01 #廠商編號
         IF NOT cl_null(l_new010) THEN
            LET l_pmc03 = ''
            SELECT pmc03,pmcacti INTO l_pmc03,l_pmcacti
              FROM pmc_file WHERE pmc01 = l_new010
            IF SQLCA.SQLCODE THEN
               CALL cl_err('','mfg3001',0)
               NEXT FIELD idm01
            END IF
            IF l_pmcacti = 'N' THEN
               CALL cl_err('','9028',0)
               NEXT FIELD idm01
            END IF
            DISPLAY l_pmc03 TO FORMONLY.pmc03
         END IF
 
      AFTER FIELD idm02 #工廠
         IF NOT cl_null(l_new020) THEN
            LET g_cnt = 0 
            SELECT COUNT(*) INTO g_cnt FROM idm_file
             WHERE idm01 = l_new010
               AND idm02 = l_new020
            IF g_cnt > 0 THEN
               CALL cl_err('',-239,0)
               NEXT FIELD idm02
            END IF
         END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(idm01) #廠商編號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pmc2"
               LET g_qryparam.default1 = l_new010
               CALL cl_create_qry() RETURNING l_new010
               DISPLAY l_new010 TO idm01
               NEXT FIELD idm01
            OTHERWISE EXIT CASE
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
      DISPLAY BY NAME g_idm.idm01,g_idm.idm02
      CALL p051_idm01('d')
      ROLLBACK WORK
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM idm_file         #單頭復制
    WHERE idm01 = g_idm.idm01
      AND idm02 = g_idm.idm02
     INTO TEMP y
 
   UPDATE y SET idm01 = l_new010,  #新的鍵值
                idm02 = l_new020,  #新的鍵值
                idm08 = 0
 
   INSERT INTO idm_file
      SELECT * FROM y
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err(l_new010,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
   END IF
 
   DROP TABLE x
 
   SELECT * FROM idn_file         #單身復制
    WHERE idn01 = g_idm.idm01
      AND idn02 = g_idm.idm02
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_idm.idm01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   UPDATE x SET idn01 = l_new010,
                idn02 = l_new020
 
   INSERT INTO idn_file
      SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_idm.idm01,SQLCA.sqlcode,0)   #FUN-B80083  ADD
      ROLLBACK WORK
     # CALL cl_err(g_idm.idm01,SQLCA.sqlcode,0)   #FUN-B80083 MARK
      RETURN
   ELSE
      COMMIT WORK
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_new010,'+',l_new020,') O.K'
 
   LET l_old010 = g_idm.idm01
   LET l_old020 = g_idm.idm02
   SELECT idm_file.* INTO g_idm.* FROM idm_file
    WHERE idm01 = l_new010
      AND idm02 = l_new020
 
   CALL p051_u()
   CALL p051_b()
   #FUN-C30027---begin
   #SELECT idm_file.* INTO g_idm.* FROM idm_file
   # WHERE idm01 = l_old010
   #   AND idm02 = l_old020
   #CALL p051_show()
   #FUN-C30027---end
END FUNCTION
 
 
#每一個文檔有一個err report
FUNCTION p051(p_count)
DEFINE p_count      LIKE type_file.chr1
 
   CALL cl_del_data(l_table)
   EXECUTE insert_prep USING "0",g_msg
 
   LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
   IF g_zz05="Y" THEN
      CALL cl_wcchp(g_wc,'idm01,idm02,idm03,idm05')
      RETURNING g_wc
   END IF
   LET g_str=''
   LET g_str=g_wc,';',g_towhom
   CALL cl_prt_cs3('aicp051','aicp051',g_sql,g_str)
END FUNCTION
 
FUNCTION p051_set_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("idm01,idm02",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION p051_set_no_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("idm01,idm02",FALSE)
   END IF
 
END FUNCTION
 
#轉檔
FUNCTION p051_change(p_argv1)
DEFINE p_argv1      LIKE type_file.chr1
DEFINE l_cmd        STRING
DEFINE lch_pipe     base.Channel
DEFINE l_idm01      Like idm_file.idm01
DEFINE l_idm02      Like idm_file.idm02
DEFINE l_idm08      Like idm_file.idm08
DEFINE l_i          LIKE type_file.num5
DEFINE l_n          LIKE type_file.num5
DEFINE l_flag       LIKE type_file.chr1
DEFINE l_codeset    STRING                 #No.MOD-8B0036 add
 
  #詢問是否要轉檔
   IF cl_null(p_argv1) THEN
      IF NOT cl_confirm('aic-072') THEN
         RETURN 
      END IF
   END IF
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   SELECT zz17 INTO g_len FROM zz_file WHERE zz01 = 'aicp051'
   FOR l_i = 1 TO g_len LET g_dash[l_i,l_i] = '=' END FOR
   FOR l_i = 1 TO g_len LET g_dash2[l_i,l_i] = '-' END FOR
 
  #若為p_cron呼叫時，INSERT設定檔至TEMP TABLE
   IF NOT cl_null(p_argv1) THEN
      CALL p051_temp() 
     #LET g_idm.idm03 = '$TEMPDIR/ICD/WIP/upload'                #No.FUN-830131
      LET g_idm.idm03 = FGL_GETENV("TEMPDIR"),'/ICD/WIP/upload'  #No.FUN-830131
   END IF
 
   LET l_flag = '0'
 
  #取得路徑下所有待轉檔的文檔
  #利用openPipe取得路徑下的所有文檔
   LET l_cmd = "ls ",g_idm.idm03 CLIPPED
   LET lch_pipe = base.Channel.create()
   CALL lch_pipe.openPipe(l_cmd,"r")
   LET g_msg = ""
 
   #No.MOD-8B0036 add --begin
   LET ms_codeset=cl_get_codeset()
   LET l_codeset = ms_codeset
   IF ms_codeset.getIndexOf("BIG5", 1) OR (ms_codeset.getIndexOf("GB2312", 1)
      OR ms_codeset.getIndexOf("GBK",1) OR ms_codeset.getIndexOf("GB18030",1))
   THEN
      IF ms_locale = "ZH_TW" AND g_lang = '2' THEN
         LET l_codeset = "GB2312"
      END IF
      IF ms_locale = "ZH_CN" AND g_lang = '0' THEN
         LET l_codeset = "BIG5"
      END IF
   END IF
   #No.MOD-8B0036 add --end
 
  #一筆一筆讀入，gs_fname=每一個的檔名
   WHILE lch_pipe.read(gs_fname)
 
     #將文檔重新編碼，檔名不可相同
    # LET l_cmd="iconv -f big5 -t UTF-8 ",g_idm.idm03 CLIPPED,"/",            #No.MOD-8B0036 mark
      IF os.Path.separator() = "/" THEN        #Unix 環境    #FUN-A30038
         LET l_cmd="iconv -f ",l_codeset," -t UTF-8 ",g_idm.idm03 CLIPPED,"/",   #No.MOD-8B0036 add
                    gs_fname CLIPPED," > ",g_idm.idm03 CLIPPED,"/",
                                           gs_fname CLIPPED,".tmp"
      ELSE                                                                                     #FUN-B30176
         LET l_cmd="java -cp zhcode.java zhcode -u8 ",g_idm.idm03 CLIPPED,os.Path.separator(),                 #FUN-B30176
                    gs_fname CLIPPED," > ",g_idm.idm03 CLIPPED,os.Path.separator(),gs_fname CLIPPED,".tmp"     #FUN-B30176
         RUN l_cmd
      END IF   #FUN-A30038
 
      LET l_cmd="rm ",g_idm.idm03 CLIPPED,"/",gs_fname CLIPPED
      RUN l_cmd 
 
      LET l_cmd="mv ",g_idm.idm03 CLIPPED,"/",gs_fname CLIPPED,".tmp ",
                 g_idm.idm03 CLIPPED,"/",gs_fname CLIPPED
      RUN l_cmd 
 
     #記錄制定的路徑下有無文檔
      LET l_flag = '1'
 
     #判斷是否為p_cron呼叫
      IF NOT cl_null(p_argv1) THEN
 
        #由p_cron呼叫時，先取得設置檔
         CALL p051_p_cron(gs_fname) RETURNING l_idm01,l_idm02
 
        #1.若文檔無法打開時，回轉空值 #2.找不到符合的設定檔，回傳"N"
         IF (cl_null(l_idm01) AND cl_null(l_idm02)) OR
            (l_idm01 = 'N' AND l_idm02 = 'N') THEN
           #把文檔移至指定目錄下
            CALL p051_mv('miss',gs_fname)
            CONTINUE WHILE
         END IF
 
         LET l_idm08 = 0
         SELECT idm08 INTO l_idm08 FROM idm_file
          WHERE idm01 = l_idm01
            AND idm02 = l_idm02
      ELSE
         LET l_idm01 = g_idm.idm01
         LET l_idm02 = g_idm.idm02
         LET l_idm08 = g_idm.idm08
      END IF
 
     #處理轉檔,xxx.txt INSERT ido_file
      CALL p051_ins_ido(gs_fname,l_idm01,l_idm02)
 
      IF cl_null(l_idm08) THEN
         LET l_idm08 = 0
      ELSE
         IF g_success = 'N' THEN
            UPDATE idm_file SET idm08 = l_idm08 + 1
             WHERE idm01 = l_idm01
               AND idm02 = l_idm02
         END IF
      END IF
     #變更err report為指定的檔名
      LET g_name = "mv ",g_name CLIPPED," ",gs_fname CLIPPED,
                   ".err.unload.",l_idm08 + 1 USING '&&&&&'
      RUN g_name
 
#     LET g_name = "chmod 777 ",gs_fname CLIPPED,".err.unload.", #No.FUN-9C0009
#                  l_idm08 + 1 USING "&&&&&"               #No.FUN-9C0009
#     RUN g_name                                           #No.FUN-9C0009
      IF os.Path.chrwx(gs_fname CLIPPED,511) THEN END IF   #No.FUN-9C0009
      LET g_name = gs_fname CLIPPED,".err.unload.",l_idm08 + 1 USING "&&&&&"
      CALL p051_mv('rep',g_name)
 
   END WHILE
   CALL lch_pipe.close()
 
   IF cl_null(p_argv1) THEN
      UPDATE idm_file SET idm08 = l_idm08 + 1
       WHERE idm01 = l_idm01
         AND idm02 = l_idm02
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('upd idm',SQLCA.sqlcode,0)
      END IF
      CALL cl_err("","agl-112",0)
   END IF
 
  #指定的路徑無文檔時
   IF l_flag = '0' THEN
      LET g_msg = cl_getmsg('aic-068',g_lang)
      LET g_msg = g_idm.idm03 CLIPPED,': ',g_msg CLIPPED
      CALL p051(0)
   END IF
 
END FUNCTION
 
#取得符合的設定檔INSERT至TEMP TABLE
FUNCTION p051_temp()
DEFINE l_idm    RECORD LIKE idm_file.*
DEFINE l_temp0301  LIKE idn_file.idn03  #廠商順序
DEFINE l_temp0302  LIKE idn_file.idn03  #工廠順序
 
   LET g_sql = "SELECT * FROM idm_file"
 
   PREPARE p051_a FROM g_sql
   DECLARE p051_a_cs CURSOR FOR p051_a
 
   FOREACH p051_a_cs INTO l_idm.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach idm:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET g_msg = ''
 
     #撈廠商順序
      LET l_temp0301 = ''
      SELECT idn03 INTO l_temp0301 FROM idn_file
       WHERE idn01 = l_idm.idm01
         AND idn02 = l_idm.idm02
         AND idn04 = 'ido_file'
 
     #撈工廠順序
      LET l_temp0302 = ''
      SELECT idn03 INTO l_temp0302 FROM idn_file
       WHERE idn01 = l_idm.idm01
         AND idn02 = l_idm.idm02
         AND idn04 = 'ido_file'
 
     #廠商及工廠需皆存在idn_file
      IF NOT cl_null(l_temp0301) AND NOT cl_null(l_temp0302) THEN
         INSERT INTO p051_file VALUES(l_idm.idm01,l_idm.idm02,
                                      l_temp0301,l_temp0302,l_idm.idm05)
      END IF
   END FOREACH
 
END FUNCTION
 
#由p_cron呼叫時,先取得設定檔=>傳入:欲轉檔的檔名,回傳:設定檔的"廠商"及"工廠"
FUNCTION p051_p_cron(p_fname)
DEFINE p_fname     STRING
DEFINE l_cmd       STRING
DEFINE l_str       STRING        #檔案內的資料(一筆)
DEFINE l_date      STRING        #字段資料
DEFINE l_channel   base.Channel
DEFINE l_n         LIKE type_file.num10
DEFINE l_symbol    STRING
DEFINE l_temp      RECORD
                      temp010   LIKE idn_file.idn01, #廠商
                      temp020   LIKE idn_file.idn02, #工廠
                      temp0301  LIKE idn_file.idn03, #廠商順序 
                      temp0302  LIKE idn_file.idn03, #工廠順序 
                      temp040   LIKE idm_file.idm05  #分隔符號
                   END RECORD
 
   LET g_msg = ''
 
  #把p_fname的第一筆資料，放到l_str
   LET l_cmd = g_idm.idm03 CLIPPED,'/',p_fname CLIPPED
   LET l_channel = base.Channel.create()
   CALL l_channel.openFile(l_cmd,"r")
   IF STATUS THEN
     #若檔案無法打開時，回傳空值
      RETURN '',''
   END IF
   LET l_n = 1
   LET l_str = ''
   WHILE l_channel.read([l_str])
      IF l_n > 1 AND l_str.getLength() != 0 THEN
         EXIT WHILE
      END IF
      LET l_str = ''
      LET l_n = l_n + 1
   END WHILE
   CALL l_channel.close()
 
   LET g_sql = "SELECT * FROM p051_file"
 
   PREPARE p051_temp FROM g_sql
   DECLARE p051_temp_cs CURSOR FOR p051_temp
 
   FOREACH p051_temp_cs INTO l_temp.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach temp:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
     #取得分隔符號
      CASE
         WHEN l_temp.temp040 = '0'
            LET l_symbol = '	'
         WHEN l_temp.temp040 = '1'
            LET l_symbol = ';'
      END CASE
 
     #判斷廠商及工廠在字串的順序是否符合設定檔
      CALL p051_date(l_str,l_symbol,l_temp.temp0301) RETURNING l_date
      IF l_date != l_temp.temp010 OR cl_null(l_date) THEN
         CONTINUE FOREACH
      END IF
 
      CALL p051_date(l_str,l_symbol,l_temp.temp0302) RETURNING l_date
      IF cl_null(l_date) THEN
         LET l_date = '00'
      END IF
      IF l_date != l_temp.temp020 THEN
         CONTINUE FOREACH
      END IF
 
     #回傳符合的廠商及工廠
      RETURN l_temp.temp010,l_temp.temp020
 
   END FOREACH
 
  #若找不到符合的資料時，回傳'N','N'
   RETURN 'N','N'
 
END FUNCTION
 
#依“字串”，“分隔符號”，“第N個值”->回傳字串中第N個值
FUNCTION p051_date(p_str,p_symbol,p_num)
DEFINE p_str        STRING                 # xxx.txt的第N筆資料
DEFINE p_symbol     STRING                 #設定檔的分隔符號
DEFINE p_num        LIKE type_file.num5   #要取得第幾個的值
DEFINE l_n          LIKE type_file.num5   #字串的總長度
DEFINE l_count      LIKE type_file.num5   #目前抓到第幾個的值
DEFINE l_i,l_si     LIKE type_file.num5
 
   CALL p_str.getLength() RETURNING l_n
   IF cl_null(l_n) OR l_n = 0 THEN
      RETURN
   END IF
 
   LET l_count = 0 
   LET l_si = 1
   FOR l_i = 1 TO l_n
      IF p_str.subString(l_i,l_i) = p_symbol THEN
         LET l_count = l_count + 1
         IF l_count = p_num THEN
           #若無值時，回傳''
            IF l_i = l_si THEN
               RETURN ''
            ELSE
               RETURN p_str.subString(l_si,l_i - 1)
            END IF
         END IF
         LET l_si = l_i + 1
      END IF
   END FOR
 
   IF p_num = l_count + 1 THEN
      RETURN p_str.subString(l_si,l_n)
   END IF
 
  #找不到符合的資料時，則回傳原本的字串
   RETURN p_str
 
END FUNCTION
 
#處理轉檔,xxx.txt INSERT ido_file
FUNCTION p051_ins_ido(p_fname,p_idm01,p_idm02)
DEFINE p_fname         STRING                      #欲轉檔的檔名
DEFINE p_idm01         LIKE idm_file.idm01         #設定檔的廠商
DEFINE p_idm02         LIKE idm_file.idm02         #設定檔的工廠
DEFINE l_channel       base.Channel
DEFINE l_date          STRING                      #字段資料
DEFINE l_type          LIKE type_file.chr50        #字段類型
DEFINE l_str           STRING                      #資料（筆）
DEFINE l_cmd           STRING                      #路徑+檔名
DEFINE l_field         STRING                      #要insert進ido_file的字段
DEFINE l_values        STRING                      #要insert進ido_file的值
DEFINE l_where         STRING                      #要UPDATE的條件
DEFINE l_idm03         LIKE idm_file.idm03         #設定檔的路徑
DEFINE l_idm05         LIKE idm_file.idm05         #設定檔的分隔符號
DEFINE l_symbol        STRING                      #分隔符號
DEFINE l_idn03         LIKE idn_file.idn03         #設定檔的順序
DEFINE l_idn04         LIKE idn_file.idn04         #設定檔的文檔名稱
DEFINE l_idn05         LIKE idn_file.idn05         #設定檔的字段名稱
DEFINE l_count         LIKE type_file.num10        #筆數
DEFINE l_n             LIKE type_file.num10 
DEFINE l_ido06         LIKE ido_file.ido06
DEFINE l_ido07         LIKE ido_file.ido07
DEFINE l_ins           LIKE type_file.chr1         #判斷是insert或update
DEFINE l_data_length   LIKE type_file.chr8         #FUN-A90024
 
   LET g_sql = "SELECT idn03,idn04,idn05",
               "  FROM idn_file",
               " WHERE idn01 = '",p_idm01,"'",
               "   AND idn02 = '",p_idm02,"'",
               " ORDER BY idn04,idn03"
 
   PREPARE p051_b FROM g_sql
   DECLARE p051_b_cs CURSOR FOR p051_b
 
  #取設定檔上的路徑及分隔符號
   SELECT idm03,idm05 INTO l_idm03,l_idm05 FROM idm_file
    WHERE idm01 = p_idm01
      AND idm02 = p_idm02
   IF SQLCA.sqlcode THEN
      LET g_msg = cl_getmsg(SQLCA.sqlcode,g_lang)
      LET g_msg = g_msg CLIPPED,": ",p_fname CLIPPED
      CALL p051(0)
      RETURN
   END IF
 
  #取得分隔符號
   CASE
      WHEN l_idm05 = "0"
         LET l_symbol = "	"
      WHEN l_idm05 = "1"
         LET l_symbol = ";"
   END CASE
 
  #把p_fname的第n筆資料，放到l_str
   LET l_cmd = l_idm03 CLIPPED,"/",p_fname CLIPPED
   LET l_channel = base.Channel.create()
   CALL l_channel.openFile(l_cmd,"r")
   IF STATUS THEN
      LET g_msg = cl_getmsg("-808",g_lang)
      LET g_msg = g_msg CLIPPED,": ",l_cmd CLIPPED
      CALL p051(0)
      RETURN 
   END IF
 
   BEGIN WORK
   LET g_success = "Y"
 
   LET l_count = 1 
  #讀取文檔里的每筆資料
   WHILE l_channel.read([l_str])
     #略過第一行抬頭的部份
      IF l_count = 1 THEN
         LET l_count = l_count + 1
         CONTINUE WHILE
      END IF
 
      IF l_str.getLength() = 0 THEN
         EXIT WHILE
      END IF
 
     #可能會有斷行符號
      CALL p051_date(l_str,"","1") RETURNING l_date
 
     #取得ido06,ido07的資料
      LET l_idn03 = ""
      SELECT idn03 INTO l_idn03 FROM idn_file
       WHERE idn01 = p_idm01
         AND idn02 = p_idm02
         AND idn05 = "ido06"
      IF NOT cl_null(l_idn03) THEN
         CALL p051_date(l_str,l_symbol,l_idn03) RETURNING l_ido06
         IF l_str = l_ido06 THEN LET l_ido06 = '' END IF
      END IF
 
      LET l_idn03 = ""
      SELECT idn03 INTO l_idn03 FROM idn_file
       WHERE idn01 = p_idm01
         AND idn02 = p_idm02
         AND idn05 = "ido07"
      IF NOT cl_null(l_idn03) THEN
         CALL p051_date(l_str,l_symbol,l_idn03) RETURNING l_ido07
         IF l_str = l_ido07 THEN LET l_ido07 = '' END IF
      END IF
 
     #判斷是要INSERT還是UPDATE
     #當ido02,ido03,ido06,ido07已存在時,則由INSERT改成UPDATE
      LET l_ins = "Y"
      LET l_where = ""
      LET g_sql = "SELECT COUNT(*) FROM ido_file",
                  " WHERE ido02 = '",p_idm01 CLIPPED,"'",
                  "   AND ido03 = '",p_idm02 CLIPPED,"'"
      IF cl_null(l_ido06) THEN
         LET l_where = l_where CLIPPED," AND ido06 IS NULL"
      ELSE
         LET l_where = l_where CLIPPED,
                       " AND ido06 = '",l_ido06 CLIPPED,"'"
      END IF
      IF cl_null(l_ido07) THEN
         LET l_where = l_where CLIPPED," AND ido07 IS NULL"
      ELSE
         LET l_where = l_where CLIPPED,
                       " AND ido07 = '",l_ido07 CLIPPED,"'"
      END IF
      LET g_sql = g_sql CLIPPED,l_where CLIPPED
      PREPARE p051_cou FROM g_sql
      DECLARE p051_cou_cs CURSOR FOR p051_cou
      LET l_n = 0 
      FOREACH p051_cou_cs INTO l_n
         IF SQLCA.sqlcode THEN
            CALL cl_err("foreach cou:",SQLCA.sqlcode,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
      END FOREACH
      IF l_n > 0 THEN
         LET l_ins = "N"
      END IF
 
     #開始組要INSERT或UPDATE的字串 
      IF l_ins = "Y" THEN
         LET l_field = "ido01,"
         LET l_values = "'",p_fname CLIPPED,"',"
      ELSE
         LET l_field = "ido01 = '",p_fname CLIPPED,"',"
      END IF
 
      FOREACH p051_b_cs INTO l_idn03,l_idn04,l_idn05
         IF SQLCA.sqlcode THEN
            CALL cl_err("foreach idn:",SQLCA.sqlcode,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
 
        #取得字段值
         CALL p051_date(l_str,l_symbol,l_idn03) RETURNING l_date
         IF l_str = l_date THEN LET l_date = '' END IF
         IF cl_null(l_date) THEN
            LET l_date = '00'
         END IF
 
        #在第一筆資料判斷設置檔是否符合，若是不符合則show錯誤訊息and ROLLBACK
        #IF ( l_date != g_idm.idm01) OR                     #No.FUN-830131
        #   ( l_date != g_idm.idm02) THEN                   #No.FUN-830131
         IF (l_idn05="ido02" AND l_date != g_idm.idm01) OR    #No.FUN-830131
            (l_idn05="ido03" AND l_date != g_idm.idm02) THEN  #No.FUN-830131
           #把文檔移至指定目錄下
            CALL p051_mv("miss",p_fname)
            LET g_success = "N"
            EXIT FOREACH
         END IF

            #---FUN-A90024---start-----
            #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
            #目前統一用sch_file紀錄TIPTOP資料結構 
            #SELECT lower(systypes.name) INTO l_type FROM systypes,syscolumns
            # WHERE lower(syscolumns.name) = l_idn05
            #   AND syscolumns.id = object_id(l_idn04)
            CALL cl_get_column_info('ds', l_idn04, l_idn05) 
               RETURNING l_type, l_data_length
            #---FUN-A90024---end-------  
 
         IF cl_null(l_date) THEN
            LET l_date = "00"
         END IF
 
        #依INSERT或UPDATE組字段+字段值
         IF l_ins = "Y" THEN
            LET l_field = l_field CLIPPED,l_idn05 CLIPPED,","
 
            IF l_type = "number" THEN
               IF cl_null(l_values) THEN LET l_values = 0 END IF
               LET l_values = l_values CLIPPED,l_date CLIPPED,","
            ELSE
               LET l_values = l_values CLIPPED,"'",l_date CLIPPED,"',"
            END IF
         ELSE
            IF l_type = "number" THEN
               IF cl_null(l_values) THEN LET l_values = 0 END IF
               LET l_field = l_field CLIPPED,
                             l_idn05 CLIPPED," = ",l_date CLIPPED,","
            ELSE
               LET l_field = l_field CLIPPED,
                             l_idn05 CLIPPED," = '",l_date CLIPPED,"',"
            END IF
         END IF
 
      END FOREACH
 
      IF g_success = "Y" THEN
        #依INSERT或UPDATE組SQL
         IF l_ins = "Y" THEN
            LET l_field = l_field CLIPPED,
                          "idouser,idogrup,idoacti,idodate,idoplant,idolegal,idooriu,idoorig" #TQC-A10060 add idooriu,idoorig  #FUN-980004 add idoplant,idolegal
            LET l_values = l_values CLIPPED,
                          "'",g_user,"','",g_grup,"','Y','",g_today,"'",",'",g_plant,"','",g_legal,"','",g_user,"','",g_grup,"'"   #TQC-A10060 add ' ',' '   #FUN-980004 add g_plant,g_legal
 
            LET g_sql = "INSERT INTO ido_file (",l_field CLIPPED,") ",
                        "VALUES (",l_values,")"
         ELSE
            LET l_field = l_field CLIPPED,"idomodu = '",g_user,"',",
                                          "idodate = '",g_today,"'"
            LET g_sql = "UPDATE ido_file SET ",l_field CLIPPED,
                        " WHERE ido02 = '",p_idm01 CLIPPED,"'",
                        "   AND ido03 = '",p_idm02 CLIPPED,"' ",
                        l_where CLIPPED
         END IF
 
         PREPARE p051_ins_ido FROM g_sql
         EXECUTE p051_ins_ido
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
            LET g_msg = cl_getmsg(SQLCA.sqlcode,g_lang)
            IF cl_null(g_msg) THEN 
               LET g_msg = cl_getmsg("9052",g_lang)
            END IF
            LET g_msg = "INSERT ",p_fname CLIPPED," TO ",l_idn04 CLIPPED,
                        ":",g_msg CLIPPED
            CALL p051(l_count)
            CALL p051_mv("err",p_fname)
            LET g_success = "N"
            EXIT WHILE
         END IF
         LET l_count = l_count + 1 
      ELSE
         EXIT WHILE
      END IF
 
   END WHILE
 
   IF g_success = 'Y' AND l_count <= 2 THEN
     #把文檔移至指定目錄下
      CALL p051_mv("miss",p_fname)
      LET g_success = "N"
   END IF
 
   IF g_success = "N" THEN
      ROLLBACK WORK
   ELSE
      COMMIT WORK
      CALL p051_mv("ok",p_fname)
   END IF
 
END FUNCTION
 
#將處理過的文檔搬到指定的路徑
FUNCTION p051_mv(p_msg,p_fname)
DEFINE p_msg     STRING  #狀態
DEFINE p_fname   STRING  #檔名
DEFINE l_stro    STRING  #舊路徑
DEFINE l_strn    STRING  #新路徑
DEFINE l_cmd     STRING  #欲執行的指令
 
  #LET l_stro = '$TEMPDIR/ICD/WIP/upload/',p_fname CLIPPED   #No.FUN-830131
   LET l_stro = FGL_GETENV("TEMPDIR"),'/ICD/WIP/upload/',p_fname CLIPPED  #No.FUN-830131
 
  #判斷要將文檔移至哪個路徑下
   CASE
      WHEN p_msg = 'miss'
        #LET l_strn = '$TEMPDIR/ICD/WIP/miss/',p_fname CLIPPED  #No.FUN-830131
         LET l_strn = FGL_GETENV("TEMPDIR"),'/ICD/WIP/miss/',p_fname CLIPPED  #No.FUN-830131
 
      WHEN p_msg = 'ok'
        #LET l_strn = '$TEMPDIR/ICD/WIP/backup/',p_fname CLIPPED  #No.FUN-830131
         LET l_strn = FGL_GETENV("TEMPDIR"),'/ICD/WIP/backup/',p_fname CLIPPED  #No.FUN-830131
 
      WHEN p_msg = 'err'
        #LET l_strn = '$TEMPDIR/ICD/WIP/err/',p_fname CLIPPED   #No.FUN-830131   
         LET l_strn = FGL_GETENV("TEMPDIR"),'/ICD/WIP/err/',p_fname CLIPPED  #No.FUN-830131
 
      WHEN p_msg = 'rep'
        #LET l_stro = '$TEMPDIR/ICD/',p_fname CLIPPED    #No.FUN-830131  
        #LET l_strn = '$TEMPDIR/ICD/WIP/err/',p_fname CLIPPED  #No.FUN-830131  
         LET l_stro = FGL_GETENV("TEMPDIR"),'/ICD/',p_fname CLIPPED    #No.FUN-830131 
         LET l_strn = FGL_GETENV("TEMPDIR"),'/ICD/WIP/err/',p_fname CLIPPED  #No.FUN-830131 
 
   END CASE
 
   LET l_cmd = "mv ",l_stro CLIPPED," ",l_strn CLIPPED
   RUN l_cmd
 
#  LET l_cmd = "chmod 777 ",l_strn CLIPPED            #No.FUN-9C0009
#  RUN l_cmd                                          #No.FUN-9C0009
   IF os.Path.chrwx(l_strn CLIPPED,511) THEN END IF   #No.FUN-9C0009
 
 
END FUNCTION
 
#No.FUN-7B0077
