# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aicp045.4gl
# Descriptions...: ICD發票資料轉入作業
# Date& Author...: 08/01/01 by lilingyu
# Modify.........: 08/03/20 No.FUN-830083 by hellen 過單
# Modify.........: No.MOD-8B0036 08/11/05 By chenyu 語言別的要根據不同的情況用不同的值，不能直接用BIG5
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.FUN-980004 09/08/13 By TSD.danny2000 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0146 09/11/26 By lutingting rvw_file去除rvwplant 
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No.FUN-A30038 09/03/09 By lutingting windows改用zhcode方式來進行轉碼
# Modify.........: No.FUN-A90024 10/11/16 By Jay 調整各DB利用sch_file取得table與field等資訊
# Modify.........; No.FUN-B30176 11/03/25 By xianghui 使用iconv須區分為FOR UNIX& FOR Windows,批量去除$TOP
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80083 11/08/08 By minpp程序撰寫規範修改
# Modify.........: No:CHI-B70039 11/08/10 By JoHung 金額 = 計價數量 x 單價
# Modify.........: No.CHI-C30115 12/05/29 By yuhuabao -239的錯誤判斷,應全部改成IF cl_sql_dup_value(SQLCA.SQLCODE)
# Modify.........: No:TQC-C60190 12/06/25 By Sarah
#                                         1.idi03改為"上傳檔案檔名"
#                                         2.idi04改為"從 c:\tiptop 上傳",可由本機c:\tiptop目錄做檔案上傳
#                                         3.新增時詢問"是否要建立發票自動轉入所需的相關目錄?",整張刪除時詢問是否將目錄一併刪除
#                                         4.增加背景執行功能
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:CHI-C90044 12/09/26 By bart 廠商編號開窗改q_pmc1
# Modify.........: No:CHI-CA0007 12/10/03 by bart 將aic-065顯示訊息移除
# Modify.........: No:FUN-D10064 13/03/18 By minpp 给新增非空字段rvwacti默认值‘Y’
# Modify.........: No.FUN-D40030 13/04/07 By xuxz 單身新增時按下放棄鍵未執行AFTER INSERT的問題
IMPORT os   #No.FUN-9C0009
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_idi      RECORD LIKE idi_file.*,      #單頭
       g_idi_t    RECORD LIKE idi_file.*,
       g_idi_o    RECORD LIKE idi_file.*,
       g_idi01_t         LIKE idi_file.idi01,
       g_idi02_t         LIKE idi_file.idi02,
       g_idj      DYNAMIC ARRAY OF RECORD
                    idj03 LIKE idj_file.idj03, #順序 
                    idj04 LIKE idj_file.idj04, #檔案編號
                    idj05 LIKE idj_file.idj05, #欄位編號
                    gaq03 LIKE gaq_file.gaq03
                  END RECORD,
       g_idj_t    RECORD
                    idj03 LIKE idj_file.idj03, 
                    idj04 LIKE idj_file.idj04, 
                    idj05 LIKE idj_file.idj05,
                    gaq03 LIKE gaq_file.gaq03
                  END RECORD,
       g_idj_o    RECORD
                    idj03 LIKE idj_file.idj03, 
                    idj04 LIKE idj_file.idj04, 
                    idj05 LIKE idj_file.idj05,
                    gaq03 LIKE gaq_file.gaq03
                  END RECORD,
       g_sql               STRING, 
       g_wc                STRING,   
       g_wc2               STRING,  
       g_rec_b             LIKE type_file.num5,
       l_ac                LIKE type_file.num5 
DEFINE g_forupd_sql        STRING
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num5
DEFINE g_msg               LIKE type_file.chr1000
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE g_no_ask            LIKE type_file.num5
DEFINE g_argv1             LIKE type_file.chr1  #由P_CRON呼叫
DEFINE gs_fname            STRING
DEFINE g_name              STRING               #報表原始名稱
DEFINE p_table             STRING               #暫存檔
DEFINE pp_str              STRING               #用來組傳入cl_prt_cs3()參數
DEFINE p_sql               STRING               #抓取暫存盤資料sql
DEFINE ms_codeset          STRING               #No.MOD-8B0036 add
DEFINE ms_locale           STRING               #No.MOD-8B0036 add
DEFINE g_flag              LIKE type_file.chr1  #TQC-C60190 add
DEFINE g_str               STRING               #TQC-C60190 add
 
MAIN
   OPTIONS                               
      INPUT NO WRAP
   DEFER INTERRUPT                      
 
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
 
   #錄入CR所需的暫存檔   
   LET p_sql="l_count.type_file.num5 , g_msg.type_file.chr1000"
   LET p_table=cl_prt_temptable('aicp045',p_sql) CLIPPED            
   IF  p_table=-1 THEN EXIT PROGRAM END IF
   LET p_sql = "INSERT INTO ",g_cr_db_str,p_table CLIPPED," VALUES (?,?)"
   PREPARE insert_prep FROM p_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',STATUS,1)
      EXIT PROGRAM
   END IF              

   CALL cl_used(g_prog,g_time,1) RETURNING g_time
    
   #由P_CRON呼叫
   IF NOT cl_null(g_argv1) THEN
      DROP TABLE p045_file;
      CREATE TEMP TABLE p045_file(
        temp01   LIKE type_file.chr10,          #廠商
        temp02   LIKE type_file.chr10,          #工廠
        temp0301 LIKE type_file.num20_6,        #廠商順序  
        temp0302 LIKE type_file.num20_6,        #工廠順序
        temp04   LIKE type_file.chr1);          #分隔符號
 
      CALL p045_change_cron(g_argv1)   #TQC-C60190 add
     #CALL p045_change(g_argv1)        #TQC-C60190 mark
      DROP TABLE p045_file;
   ELSE
      LET g_forupd_sql = "SELECT * FROM idi_file WHERE idi01 = ? AND idi02 = ? FOR UPDATE"
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
      DECLARE p045_cl CURSOR FROM g_forupd_sql
 
      OPEN WINDOW p045_w WITH FORM "aic/42f/aicp045"
           ATTRIBUTE (STYLE = g_win_style CLIPPED)
      CALL cl_ui_init()
 
      CALL p045_menu()

      CLOSE WINDOW p045_w                 
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION p045_cs()
   DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01
 
   CLEAR FORM                           
   CALL g_idj.clear()
 
   CONSTRUCT BY NAME g_wc ON idi01,idi02,idi03,idi04,idi05  #TQC-C60190 add idi04

      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION controlp
         CASE
           WHEN INFIELD(idi01)                   #廠商編號
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              #LET g_qryparam.form = "q_pmc2"  #CHI-C90044
              LET g_qryparam.form = "q_pmc1"   #CHI-C90044
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO idi01
              CALL p045_idi01('d')
              NEXT FIELD idi01
 
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
   IF INT_FLAG THEN RETURN END IF
 
   CONSTRUCT g_wc2 ON idj03,idj04,idj05
        FROM s_idj[1].idj03,s_idj[1].idj04,s_idj[1].idj05

      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)  
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(idj04)                   #檔案名稱
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gat"
               LET g_qryparam.arg1 = g_lang
               LET g_qryparam.state = "c" 
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO idj04
               NEXT FIELD idj04
 
             WHEN INFIELD(idj05)                   #欄位名稱
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gaq"
               LET g_qryparam.arg1 = g_lang
               LET g_qryparam.state = "c" 
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO idj05
               NEXT FIELD idj05
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
   IF INT_FLAG THEN RETURN END IF
 
   IF g_wc2 = " 1=1" THEN              #若單身未輸入條件 
      LET g_sql = "SELECT idi01,idi02 FROM idi_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY idi01,idi02"
   ELSE                                #若單身有輸入條件
      LET g_sql = "SELECT UNIQUE idi_file.idi01,idi02 ",
                  "  FROM idi_file, idj_file ",
                  " WHERE idi01 = idj01",
                  "   AND idi02 = idj02",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY idi01,idi02"
   END IF
   PREPARE p045_prepare FROM g_sql
   DECLARE p045_cs SCROLL CURSOR WITH HOLD FOR p045_prepare      #SCROLL CURSOR
 
END FUNCTION
 
FUNCTION p045_count()
   DEFINE la_idi    DYNAMIC ARRAY of RECORD                       
                     idi01 LIKE idi_file.idi01,
                     idi02 LIKE idi_file.idi02
                    END RECORD
   DEFINE li_cnt    LIKE type_file.num10
   DEFINE li_rec_b  LIKE type_file.num10
 
   IF cl_null(g_wc) THEN
      LET g_wc = ' 1=1'
   END IF
 
   IF cl_null(g_wc2) THEN
      LET g_wc2 = ' 1=1'
   END IF
 
   IF g_wc2 = " 1=1" THEN            #取符合條件筆數
      LET g_sql = "SELECT idi01,idi02 FROM idi_file",
                  " WHERE ",g_wc CLIPPED,
                  " GROUP BY idi01,idi02"
   ELSE
      LET g_sql = "SELECT idi01,idi02 FROM idi_file,idj_file ",
                  " WHERE idj01 = idi01", 
                  "   AND idj02 = idi02", 
                  "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                  " GROUP BY idi01,idi02"
   END IF
 
   PREPARE p045_precount FROM g_sql
   DECLARE p045_count CURSOR FOR p045_precount 
                          
   LET li_cnt=1                                                                 
   LET li_rec_b=0     
                                                             
   FOREACH p045_count INTO la_idi[li_cnt].*                                 
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
 
FUNCTION p045_menu()
   DEFINE l_n  LIKE type_file.num5
 
   WHILE TRUE
      CALL p045_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL p045_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL p045_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL p045_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL p045_u()
            END IF
               
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL p045_copy()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p045_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "aic_change_file"               #轉檔 
            IF cl_chk_act_auth() THEN
               #無單身,不做轉檔
               LET l_n = 0 
               SELECT COUNT(*) INTO l_n FROM idj_file
                WHERE idj01 = g_idi.idi01
                  AND idj02 = g_idi.idi02
                  AND idj04 = 'idk_file'
               IF l_n = 0 THEN
                  CALL cl_err('','aic-063',1)
                  CONTINUE WHILE
               END IF
               
               #單身"欄位編號"無idk18,不做轉檔
               LET l_n = 0 
               SELECT COUNT(*) INTO l_n FROM idj_file
                WHERE idj01 = g_idi.idi01
                  AND idj02 = g_idi.idi02
                  AND idj04 = 'idk_file'
                  AND idj05 = 'idk18'
                  
               IF l_n = 0 THEN
                  CALL cl_err('idk18','aic-073',1)
                  CONTINUE WHILE
               END IF
               
               #單身"欄位編號"無idk19,不做轉檔
               LET l_n = 0 
               SELECT COUNT(*) INTO l_n FROM idj_file
                WHERE idj01 = g_idi.idi01
                  AND idj02 = g_idi.idi02
                  AND idj04 = 'idk_file'
                  AND idj05 = 'idk19'
               IF l_n = 0 THEN
                  CALL cl_err('idk19','aic-073',1)
                  CONTINUE WHILE
               END IF
               CALL p045_change('')
            END IF
 
        #str TQC-C60190 add
         WHEN "create_dir"    #建立發票自動轉入目錄
            IF cl_chk_act_auth() THEN
               CALL p045_mkdir()
            END IF
        #end TQC-C60190 add

         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_idj),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p045_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL p045_act_visible()   #TQC-C60190 add

   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_idj TO s_idj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL p045_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         CALL p045_act_visible()   #TQC-C60190 add
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL p045_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         CALL p045_act_visible()   #TQC-C60190 add
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL p045_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         CALL p045_act_visible()   #TQC-C60190 add
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL p045_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         CALL p045_act_visible()   #TQC-C60190 add
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL p045_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         CALL p045_act_visible()   #TQC-C60190 add
         ACCEPT DISPLAY
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION aic_change_file               #轉檔
         LET g_action_choice="aic_change_file"
         EXIT DISPLAY
 
     #str TQC-C60190 add
      ON ACTION create_dir    #建立發票自動轉入目錄
         LET g_action_choice="create_dir"
         EXIT DISPLAY
     #end TQC-C60190 add

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
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p045_bp_refresh()
 
   DISPLAY ARRAY g_idj TO s_idj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
   END DISPLAY
END FUNCTION
 
FUNCTION p045_a()
   DEFINE   li_result   LIKE type_file.num5
   DEFINE   ls_doc      STRING
   DEFINE   li_inx      LIKE type_file.num10
 
   MESSAGE ""
   CLEAR FORM
   CALL g_idj.clear()
   LET g_wc = NULL
   LET g_wc2 = NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_idi.* LIKE idi_file.*       #DEFAULT設定 
   LET g_idi01_t = NULL
   LET g_idi02_t = NULL
   
   #預設值及數值變數清零
   LET g_idi_t.* = g_idi.*
   LET g_idi_o.* = g_idi.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_idi.idi02 = '00'
     #LET g_idi.idi03 = FGL_GETENV('TEMPDIR'),'/ICD/INV/upload'  #TQC-C60190 mark
      LET g_idi.idi04 = 'Y'                                      #TQC-C60190 add
      LET g_idi.idi05 = '0'
      LET g_idi.idi08 = 0
 
      LET g_idi.idiplant = g_plant    #FUN-980004
      LET g_idi.idilegal = g_legal    #FUN-980004
 
      CALL p045_i("a")                     #輸入單頭
 
      IF INT_FLAG THEN                   
         INITIALIZE g_idi.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_idi.idi01) OR          #KEY不可空白
         cl_null(g_idi.idi02) THEN
         CONTINUE WHILE
      END IF
 
      INSERT INTO idi_file VALUES (g_idi.*)
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
         CALL cl_err(g_idi.idi01,SQLCA.sqlcode,1)  #FUN-B80083 ADD
         ROLLBACK WORK
        #CALL cl_err(g_idi.idi01,SQLCA.sqlcode,1)  #FUN-B80083 MARK
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_idi.idi01,'I')
      END IF
 
      #新增發票轉入設定檔時自動產生UNIX目錄
      CALL p045_mkdir()   #TQC-C60190 add

      SELECT idi01,idi02 INTO g_idi.idi01,g_idi.idi02 FROM idi_file
       WHERE idi01 = g_idi.idi01
         AND idi02 = g_idi.idi02
      LET g_idi01_t = g_idi.idi01                 #保留舊值
      LET g_idi02_t = g_idi.idi02                 #保留舊值
      LET g_idi_t.* = g_idi.*
      LET g_idi_o.* = g_idi.*
      CALL g_idj.clear()
 
      LET g_rec_b = 0 
      CALL p045_b()                              #輸入單身             
      EXIT WHILE 
   END WHILE
END FUNCTION
 
FUNCTION p045_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_idi.idi01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_idi.* FROM idi_file
    WHERE idi01 = g_idi.idi01
      AND idi02 = g_idi.idi02
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_idi01_t = g_idi.idi01
   LET g_idi02_t = g_idi.idi02
 
   BEGIN WORK
 
   OPEN p045_cl USING g_idi.idi01,g_idi.idi02
   IF SQLCA.sqlcode THEN
      CALL cl_err("OPEN p045_cl:",SQLCA.sqlcode, 1)
      CLOSE p045_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH p045_cl INTO g_idi.*                    
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_idi.idi01,SQLCA.sqlcode,0)  
      CLOSE p045_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL p045_show()
 
   WHILE TRUE
      LET g_idi01_t = g_idi.idi01
      LET g_idi02_t = g_idi.idi02
      LET g_idi_o.* = g_idi.*
 
      CALL p045_i("u")                   #欄位更改      
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_idi.* = g_idi_t.*
         CALL p045_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_idi.idi01 != g_idi01_t OR    #更改KEY值   
         g_idi.idi02 != g_idi02_t THEN
         UPDATE idj_file SET idj01 = g_idi.idi01,
                                idj02 = g_idi.idi02
           WHERE idj01 = g_idi01_t
             AND idj02 = g_idi02_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err('idj',SQLCA.sqlcode,0)
            CONTINUE WHILE
         END IF
      END IF
 
       UPDATE idi_file SET idi_file.* = g_idi.*
        WHERE idi01 = g_idi01_t AND idi02 = g_idi02_t
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err(g_idi.idi01,SQLCA.sqlcode,0)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE p045_cl
   COMMIT WORK
   CALL cl_flow_notify(g_idi.idi01,'U')
 
   CALL p045_b_fill(" 1=1")
   CALL p045_bp_refresh()
 
END FUNCTION
 
FUNCTION p045_i(p_cmd)
   DEFINE l_pmc05     LIKE pmc_file.pmc05,
          l_pmc30     LIKE pmc_file.pmc30,
          l_n         LIKE type_file.num5,
          p_cmd       LIKE type_file.chr1,    #a.輸入 u.更改 
          li_result   LIKE type_file.num5
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_idi.idi02,g_idi.idi03,g_idi.idi04,g_idi.idi05  #TQC-C60190 add idi04
   INPUT BY NAME g_idi.idi01,g_idi.idi02,g_idi.idi03,g_idi.idi04,g_idi.idi05  #TQC-C60190 add idi03,idi04
         WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL p045_set_entry(p_cmd)         
         CALL p045_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD idi01                             #廠商編號
         IF NOT cl_null(g_idi.idi01) THEN
            CALL p045_idi01(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_idi.idi01,g_errno,0)
               LET g_idi.idi01 = g_idi_o.idi01
               DISPLAY BY NAME g_idi.idi01
               NEXT FIELD idi01
            END IF
            LET g_idi_o.idi01 = g_idi.idi01
         END IF
 
      AFTER FIELD idi02                            #廠別
         IF NOT cl_null(g_idi.idi02) THEN
            IF NOT cl_null(g_idi.idi01) THEN 
               IF p_cmd = 'a' OR (p_cmd = 'u' AND (
                  g_idi.idi01 != g_idi01_t OR
                  g_idi.idi02 != g_idi02_t)) THEN
                  LET g_cnt = 0 
                  SELECT COUNT(*) INTO g_cnt FROM idi_file
                   WHERE idi01 = g_idi.idi01
                     AND idi02 = g_idi.idi02
                  IF g_cnt > 0 THEN
                     CALL cl_err(g_idi.idi01,'-239',0)  #CHI-C90044
                     LET g_idi.idi02 = g_idi_o.idi02
                     DISPLAY BY NAME g_idi.idi02
                     NEXT FIELD idi02
                  END IF
               END IF
            END IF
            LET g_idi_o.idi02 = g_idi.idi02
         END IF
 
      AFTER FIELD idi05                       #欄位分隔符號
         IF NOT cl_null(g_idi.idi05) THEN
            IF g_idi.idi05 NOT MATCHES '[012]' THEN
               LET g_idi.idi05 = g_idi_o.idi05
               NEXT FIELD idi05
            END IF
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN                 
            CALL cl_err('',9001,0)
            EXIT INPUT
         END IF
         IF NOT cl_null(g_idi.idi01) AND
            NOT cl_null(g_idi.idi02) THEN 
            IF p_cmd = 'a' OR (p_cmd = 'u' AND (
               g_idi.idi01 != g_idi01_t OR
               g_idi.idi02 != g_idi02_t)) THEN
               LET g_cnt = 0 
               SELECT COUNT(*) INTO g_cnt FROM idi_file
                WHERE idi01 = g_idi.idi01
                  AND idi02 = g_idi.idi02
               IF g_cnt > 0 THEN
                  CALL cl_err(g_idi.idi01,'-239',0)  #CHI-C90044
                  LET g_idi.idi02 = g_idi_o.idi02
                  DISPLAY BY NAME g_idi.idi02
                  NEXT FIELD idi02
               END IF
            END IF
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
      
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode())    
              RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)  
         
      ON ACTION controlp
         CASE    
            WHEN INFIELD(idi01)             #廠商編號
               CALL cl_init_qry_var()
               #LET g_qryparam.form = "q_pmc2"  #CHI-C90044
               LET g_qryparam.form = "q_pmc1"   #CHI-C90044
               LET g_qryparam.default1 = g_idi.idi01
               CALL cl_create_qry() RETURNING g_idi.idi01
               DISPLAY BY NAME g_idi.idi01
               CALL p045_idi01('d')
               NEXT FIELD idi01
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
 
FUNCTION p045_idi01(p_cmd)        #廠商編號 
   DEFINE l_pmc03   LIKE pmc_file.pmc03,
          l_pmcacti LIKE pmc_file.pmcacti,
          p_cmd     LIKE type_file.chr1
 
   LET g_errno = " "
 
   SELECT pmc03,pmcacti INTO l_pmc03,l_pmcacti
     FROM pmc_file WHERE pmc01 = g_idi.idi01
 
   CASE
        WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aic-064'
        WHEN l_pmcacti = 'N'     LET g_errno = 'aic-046'
        OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_pmc03 TO FORMONLY.pmc03
   END IF
END FUNCTION 
 
FUNCTION p045_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   INITIALIZE g_idi.* TO NULL
   CLEAR FORM
   CALL g_idj.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL p045_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_idi.* TO NULL
      RETURN
   END IF
 
   OPEN p045_cs                               
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_idi.* TO NULL
   ELSE
      CALL p045_count()
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL p045_fetch('F')                    
   END IF
 
END FUNCTION
 
FUNCTION p045_fetch(p_flag)
   DEFINE p_flag         LIKE type_file.chr1     #處理方式   
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     p045_cs INTO g_idi.idi01,
                                           g_idi.idi02
      WHEN 'P' FETCH PREVIOUS p045_cs INTO g_idi.idi01,
                                           g_idi.idi02
      WHEN 'F' FETCH FIRST    p045_cs INTO g_idi.idi01,
                                           g_idi.idi02
      WHEN 'L' FETCH LAST     p045_cs INTO g_idi.idi01,
                                           g_idi.idi02
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
         FETCH ABSOLUTE g_jump p045_cs INTO g_idi.idi01,
                                            g_idi.idi02
         LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_idi.idi01,SQLCA.sqlcode,0)
      INITIALIZE g_idi.* TO NULL
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
 
   SELECT * INTO g_idi.* FROM idi_file WHERE idi01 = g_idi.idi01 AND idi02 = g_idi.idi02
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_idi.idi01,SQLCA.sqlcode,0)
      INITIALIZE g_idi.* TO NULL
      RETURN
   END IF
 
   CALL p045_show()
END FUNCTION
 
FUNCTION p045_show()
   LET g_idi_t.* = g_idi.*          #保留單頭舊值
   LET g_idi_o.* = g_idi.*          #保留單頭舊值
 
   DISPLAY BY NAME g_idi.idi01,g_idi.idi02,g_idi.idi03,g_idi.idi04,g_idi.idi05   #TQC-C60190 add idi04
   
   CALL p045_idi01('d')
   CALL p045_b_fill(g_wc2)       
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION p045_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_idi.idi01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_idi.* FROM idi_file
    WHERE idi01 = g_idi.idi01
      AND idi02 = g_idi.idi02
 
   BEGIN WORK
 
   OPEN p045_cl USING g_idi.idi01,g_idi.idi02
   IF SQLCA.sqlcode THEN
      CALL cl_err("OPEN p045_cl:",SQLCA.sqlcode, 1)
      CLOSE p045_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH p045_cl INTO g_idi.*                      
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_idi.idi01,SQLCA.sqlcode,0)    
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL p045_show()
 
   IF cl_delh(0,0) THEN            #確認刪除 
      DELETE FROM idi_file 
             WHERE idi01 = g_idi.idi01
               AND idi02 = g_idi.idi02
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('del idi',SQLCA.sqlcode,0)
         ROLLBACK WORK
         RETURN
      END IF
      
      DELETE FROM idj_file WHERE idj01 = g_idi.idi01
                                AND idj02 = g_idi.idi02
      IF SQLCA.sqlcode THEN
         CALL cl_err('del idj',SQLCA.sqlcode,0)
         ROLLBACK WORK
         RETURN
      END IF
      
      #刪除發票轉入設定檔時自動刪除UNIX目錄
      CALL p045_rmdir()   #TQC-C60190 add

      CLEAR FORM
      CALL g_idj.clear()
      CALL p045_count()
      #FUN-B50062-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE p045_cs
         CLOSE p045_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN p045_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL p045_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL p045_fetch('/')
      END IF
   END IF
 
   CLOSE p045_cl
   COMMIT WORK
   CALL cl_flow_notify(g_idi.idi01,'D')
END FUNCTION
 
FUNCTION p045_b()
   DEFINE l_ac_t          LIKE type_file.num5,          #未取消的ARRAY CNT
          l_n             LIKE type_file.num5,          #檢查重復用
          l_cnt           LIKE type_file.num5,          #檢查重復用
          l_lock_sw       LIKE type_file.chr1,          #單身鎖住否 
          p_cmd           LIKE type_file.chr1,          #處理狀態
          l_allow_insert  LIKE type_file.num5,          #可新增否 
          l_allow_delete  LIKE type_file.num5,          #可刪除否
          ls_str          STRING,
          li_inx          LIKE type_file.num5
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_idi.idi01) THEN
      RETURN
   END IF
 
   SELECT * INTO g_idi.* FROM idi_file
      WHERE idi01 = g_idi.idi01
        AND idi02 = g_idi.idi02
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT idj03,idj04,idj05,''",
                      "  FROM idj_file",
                      "  WHERE idj01 = ? AND idj02 = ?",
                      "   AND idj03 = ?",
                      "   FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p045_bcl CURSOR FROM g_forupd_sql          # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_idj WITHOUT DEFAULTS FROM s_idj.*
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
         LET l_lock_sw = 'N'         
         LET l_n  = ARR_COUNT()
 
         BEGIN WORK
 
         OPEN p045_cl USING g_idi.idi01,g_idi.idi02
         IF SQLCA.sqlcode THEN
            CALL cl_err("OPEN p045_cl:", SQLCA.sqlcode, 1)
            CLOSE p045_cl
            ROLLBACK WORK
            RETURN
         END IF
 
         FETCH p045_cl INTO g_idi.*                     
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_idi.idi01,SQLCA.sqlcode,0)   
            CLOSE p045_cl
            ROLLBACK WORK
            RETURN
         END IF
 
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_idj_t.* = g_idj[l_ac].*             
            LET g_idj_o.* = g_idj[l_ac].*            
            OPEN p045_bcl USING g_idi.idi01,g_idi.idi02,
                                g_idj_t.idj03
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN p045_bcl:", SQLCA.sqlcode, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH p045_bcl INTO g_idj[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_idj_t.idj03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            
            SELECT gaq03 INTO g_idj[l_ac].gaq03 FROM gaq_file
               WHERE gaq01 = g_idj[l_ac].idj05                          
                 AND gaq02 = g_lang 
            DISPLAY BY NAME g_idj[l_ac].gaq03
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         DISPLAY "BEFORE INSERT!"
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         
         INITIALIZE g_idj[l_ac].* TO NULL
         LET g_idj[l_ac].idj04 = 'idk_file'
         LET g_idj_t.* = g_idj[l_ac].*           #新輸入資料      
         LET g_idj_o.* = g_idj[l_ac].*           #新輸入資料
                    
         CALL cl_show_fld_cont()
         NEXT FIELD idj03
 
      AFTER INSERT
         DISPLAY "AFTER INSERT!"
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         
         IF NOT cl_null(g_idj[l_ac].idj05) AND
            NOT cl_null(g_idj[l_ac].idj04) THEN
            LET l_n = 0 
            #---FUN-A90024---start-----
            #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
            #目前統一用sch_file紀錄TIPTOP資料結構
            #SELECT COUNT(*) INTO l_n FROM syscolumns
            #   WHERE id = object_id(g_idj[l_ac].idj04)
            #     AND lower(name) = g_idj[l_ac].idj05
            SELECT COUNT(*) INTO l_n FROM sch_file
              WHERE sch01 = g_idj[l_ac].idj04 AND sch02 = g_idj[l_ac].idj05
            #---FUN-A90024---end-------     
            IF l_n = 0 THEN
               CALL cl_err(g_idj[l_ac].idj05,'aic-033',1)
               CANCEL INSERT
               CALL g_idj.deleteElement(l_ac)
            END IF
         END IF
         
         INSERT INTO idj_file(idj01,idj02,idj03,idj04,idj05,idjplant,idjlegal)    #FUN-980004 add plant & legal
               VALUES(g_idi.idi01,g_idi.idi02,g_idj[l_ac].idj03,
                      g_idj[l_ac].idj04,g_idj[l_ac].idj05,g_plant,g_legal)        #FUN-980004 add plant & legal
                      
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err(g_idj[l_ac].idj03,SQLCA.sqlcode,0)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      AFTER FIELD idj03                            #順序
         IF NOT cl_null(g_idj[l_ac].idj03) THEN
            IF p_cmd = 'a' OR (p_cmd = 'u' AND
               g_idj[l_ac].idj03 != g_idj_t.idj03) THEN
               LET l_n = 0 
               SELECT COUNT(*) INTO l_n FROM idj_file
               WHERE idj01 = g_idi.idi01
                 AND idj02 = g_idi.idi02
                 AND idj03 = g_idj[l_ac].idj03
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_idj[l_ac].idj03 = g_idj_o.idj03
                  DISPLAY BY NAME g_idj[l_ac].idj03
                  NEXT FIELD idj03
               END IF
            END IF
            LET g_idj_o.idj03 = g_idj[l_ac].idj03
         END IF
 
      AFTER FIELD idj04                             #檔案名稱
         IF NOT cl_null(g_idj[l_ac].idj04) THEN
            IF g_idj[l_ac].idj04 != 'idk_file' THEN
               CALL cl_err(g_idj[l_ac].idj04,'aic-069',0) 
               LET g_idj[l_ac].idj04 = g_idj_o.idj04
               DISPLAY BY NAME g_idj[l_ac].idj04
               NEXT FIELD idj04
            END IF
            LET l_n = 0
            #---FUN-A90024---start-----
            #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
            #目前統一用sch_file紀錄TIPTOP資料結構 
            #SELECT COUNT(*) INTO l_n FROM sysobjects
            # WHERE lower(name) = g_idj[l_ac].idj04
            #   AND xtype = 'U'
            SELECT COUNT(*) INTO l_n FROM sch_file
              WHERE sch01 = g_idj[l_ac].idj04
            #---FUN-A90024---end-------  
            IF l_n = 0  THEN
               CALL cl_err(g_idj[l_ac].idj04,'aic-070',0)
               LET g_idj[l_ac].idj04 = g_idj_o.idj04
               DISPLAY BY NAME g_idj[l_ac].idj04
               NEXT FIELD idj04
            END IF
            LET g_idj_o.idj04 = g_idj[l_ac].idj04
         END IF
 
      AFTER FIELD idj05                             #欄位名稱
         IF NOT cl_null(g_idj[l_ac].idj05) THEN
            IF NOT cl_null(g_idj[l_ac].idj04) THEN
               LET l_n = 0 
               #---FUN-A90024---start-----
               #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
               #目前統一用sch_file紀錄TIPTOP資料結構
               #SELECT COUNT(*) INTO l_n FROM syscolumns
               #    WHERE id = object_id(g_idj[l_ac].idj04)
               #      AND lower(name) = g_idj[l_ac].idj05
               SELECT COUNT(*) INTO l_n FROM sch_file
                 WHERE sch01 = g_idj[l_ac].idj04 AND sch02 = g_idj[l_ac].idj05
               #---FUN-A90024---end------- 
               IF l_n = 0 THEN
                  CALL cl_err(g_idj[l_ac].idj05,'aic-033',0)
                  LET g_idj[l_ac].idj05 = g_idj_o.idj05
                  DISPLAY BY NAME g_idj[l_ac].idj05
                  NEXT FIELD idj05
               END IF
            END IF
            SELECT gaq03 INTO g_idj[l_ac].gaq03 FROM gaq_file
               WHERE gaq01 = g_idj[l_ac].idj05                          
                 AND gaq02 = g_lang 
            DISPLAY BY NAME g_idj[l_ac].gaq03
            LET g_idj_o.idj05 = g_idj[l_ac].idj05
         END IF
 
      BEFORE DELETE                                 #是否取消單身
         DISPLAY "BEFORE DELETE"
         IF g_idj_t.idj03 > 0 AND NOT cl_null(g_idj_t.idj03) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            
            DELETE FROM idj_file
             WHERE idj01 = g_idi.idi01
               AND idj02 = g_idi.idi02
               AND idj03 = g_idj_t.idj03
               
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err(g_idj_t.idj03,SQLCA.sqlcode,0)
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
            LET g_idj[l_ac].* = g_idj_t.*
            CLOSE p045_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_idj[l_ac].idj03,-263,1)
            LET g_idj[l_ac].* = g_idj_t.*
         ELSE
            IF NOT cl_null(g_idj[l_ac].idj05) AND
               NOT cl_null(g_idj[l_ac].idj04) THEN
               LET l_n = 0 
               #---FUN-A90024---start-----
               #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
               #目前統一用sch_file紀錄TIPTOP資料結構
               #SELECT COUNT(*) INTO l_n FROM syscolumns
               # WHERE id = object_id(g_idj[l_ac].idj04)
               #   AND lower(name) = g_idj[l_ac].idj05
               SELECT COUNT(*) INTO l_n FROM sch_file
                 WHERE sch01 = g_idj[l_ac].idj04 AND sch02 = g_idj[l_ac].idj05
               #---FUN-A90024---end------- 
               IF l_n = 0 THEN
                  CALL cl_err(g_idj[l_ac].idj05,'aic-071',0)
                  LET g_idj[l_ac].idj05 = g_idj_o.idj05
                  DISPLAY BY NAME g_idj[l_ac].idj05
                  NEXT FIELD idj05
               END IF
            END IF
            UPDATE idj_file SET idj03 = g_idj[l_ac].idj03,
                                idj04 = g_idj[l_ac].idj04,
                                idj05 = g_idj[l_ac].idj05
               WHERE idj01 = g_idi.idi01
                 AND idj02 = g_idi.idi02
                 AND idj03 = g_idj_t.idj03
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err(g_idj[l_ac].idj03,SQLCA.sqlcode,1)
               LET g_idj[l_ac].* = g_idj_t.*
               DISPLAY BY NAME g_idj[l_ac].*
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
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_idj[l_ac].* = g_idj_t.*
           #FUN-D40030--add--str
            ELSE
               CALL g_idj.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
           #FUN-D40030--add--end
            END IF
            CLOSE p045_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac#FUN-D40030 add
         CLOSE p045_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO                        
         IF INFIELD(idj03) AND l_ac > 1 THEN
            LET g_idj[l_ac].* = g_idj[l_ac-1].*
            DISPLAY BY NAME g_idj[l_ac].*
            NEXT FIELD idj03
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(idj04)                  #檔案名稱
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gat"
               LET g_qryparam.arg1 = g_lang
               LET g_qryparam.default1 = g_idj[l_ac].idj04
               CALL cl_create_qry() RETURNING g_idj[l_ac].idj04
               DISPLAY BY NAME g_idj[l_ac].idj04
               NEXT FIELD idj04
 
            WHEN INFIELD(idj05)                  #欄位名稱
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gaq"
               LET g_qryparam.arg1 = g_lang
               LET ls_str = g_idj[l_ac].idj04
               LET li_inx = ls_str.getIndexOf("_file",1)
               
               IF li_inx >= 1 THEN
                  LET ls_str = ls_str.subString(1,li_inx-1)
               ELSE
                  LET ls_str = ""
               END IF
               
               LET g_qryparam.arg2 = ls_str
               LET g_qryparam.default1 = g_idj[l_ac].idj05
               CALL cl_create_qry() RETURNING g_idj[l_ac].idj05
               DISPLAY BY NAME g_idj[l_ac].idj05
               NEXT FIELD idj05
 
            OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION CONTROLF
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
 
   CLOSE p045_bcl
   COMMIT WORK
   CALL p045_delall()
END FUNCTION
 
FUNCTION p045_delall()
 
    SELECT COUNT(*) INTO g_cnt FROM idj_file
      WHERE idj01 = g_idi.idi01
        AND idj02 = g_idi.idi02
 
    IF g_cnt = 0 THEN                 #未輸入單身,是否取消單頭資料                    
       IF NOT cl_confirm('9042') THEN
          RETURN
       END IF
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM idi_file WHERE idi01 = g_idi.idi01
                              AND idi02 = g_idi.idi02
    END IF
END FUNCTION 
 
FUNCTION p045_b_fill(p_wc2)                    
   DEFINE p_wc2       STRING
 
   LET g_sql = "SELECT idj03,idj04,idj05,''",
                "  FROM idj_file",
                " WHERE idj01 ='",g_idi.idi01,"' ",
                "   AND idj02 ='",g_idi.idi02,"' "
 
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    
    LET g_sql=g_sql CLIPPED," ORDER BY idj03,idj04,idj05 "
    DISPLAY g_sql
 
    PREPARE p045_pb FROM g_sql
    DECLARE idj_cs                              
        CURSOR FOR p045_pb
 
    CALL g_idj.clear()
    LET g_cnt = 1
 
    FOREACH idj_cs INTO g_idj[g_cnt].*        #單身ARRAY填充 
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
      
        SELECT gaq03 INTO g_idj[g_cnt].gaq03 FROM gaq_file
            WHERE gaq01 = g_idj[g_cnt].idj05
              AND gaq02 = g_lang
        LET g_cnt = g_cnt + 1
      
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
	         EXIT FOREACH	 
        END IF
    END FOREACH
    
    CALL g_idj.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION p045_copy()
    DEFINE l_new01        LIKE idi_file.idi01,
           l_new02        LIKE idi_file.idi02,
           l_old01        LIKE idi_file.idi01,
           l_old02        LIKE idi_file.idi02,
           l_pmc03        LIKE pmc_file.pmc03,
           l_pmcacti      LIKE pmc_file.pmcacti,
           li_result      LIKE type_file.num5
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_idi.idi01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   
   LET g_before_input_done = FALSE
   CALL p045_set_entry('a')  
   LET l_new02 = '00'
   DISPLAY l_new02 TO idi02
   DISPLAY '' TO FORMONLY.pmc03
 
   INPUT l_new01,l_new02 WITHOUT DEFAULTS FROM idi01,idi02
 
      AFTER FIELD idi01                           #廠商編號
         IF NOT cl_null(l_new01) THEN
            LET l_pmc03 = ''
            SELECT pmc03,pmcacti INTO l_pmc03,l_pmcacti
              FROM pmc_file 
              WHERE pmc01 = l_new01
              
            IF SQLCA.SQLCODE THEN
               CALL cl_err('','aic-064',0)
               NEXT FIELD idi01
            END IF
            
            IF l_pmcacti = 'N' THEN
               CALL cl_err('','9028',0)
               NEXT FIELD idi01
            END IF
            
            DISPLAY l_pmc03 TO FORMONLY.pmc03
         END IF
 
      AFTER FIELD idi02                            #工廠
         IF NOT cl_null(l_new02) THEN
            LET g_cnt = 0 
            SELECT COUNT(*) INTO g_cnt FROM idi_file
             WHERE idi01 = l_new01
               AND idi02 = l_new02
               
            IF g_cnt > 0 THEN
               CALL cl_err('',-239,0)
               NEXT FIELD idi02
            END IF
         END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(idi01)                   #廠商編號
               CALL cl_init_qry_var()
               #LET g_qryparam.form = "q_pmc2"  #CHI-C90044
               LET g_qryparam.form = "q_pmc1"   #CHI-C90044
               LET g_qryparam.default1 = l_new01
               CALL cl_create_qry() RETURNING l_new01
               DISPLAY l_new01 TO idi01
               NEXT FIELD idi01
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
      DISPLAY BY NAME g_idi.idi01,g_idi.idi02
      CALL p045_idi01('d')
      ROLLBACK WORK
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM idi_file                          #單頭復制
    WHERE idi01 = g_idi.idi01
      AND idi02 = g_idi.idi02
     INTO TEMP y
 
   UPDATE y SET idi01 = l_new01,                  
                idi02 = l_new02,                 
                idi08 = 0
 
   INSERT INTO idi_file
      SELECT * FROM y
      
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err(l_new01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
   END IF
 
   DROP TABLE x
 
   SELECT * FROM idj_file                          #單身復制
    WHERE idj01 = g_idi.idi01
      AND idj02 = g_idi.idi02
     INTO TEMP x
     
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_idi.idi01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   UPDATE x SET idj01 = l_new01,
                idj02 = l_new02
 
   INSERT INTO idj_file
      SELECT * FROM x
      
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_idi.idi01,SQLCA.sqlcode,0)  #FUN-B80083 ADD
      ROLLBACK WORK
     # CALL cl_err(g_idi.idi01,SQLCA.sqlcode,0)  #FUN-B80083 MARK
      RETURN
   ELSE
      COMMIT WORK
   END IF
   
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_new01,'+',l_new02,') O.K'
 
   LET l_old01 = g_idi.idi01
   LET l_old02 = g_idi.idi02
   SELECT idi_file.* INTO g_idi.* FROM idi_file
    WHERE idi01 = l_new01
      AND idi02 = l_new02
 
   #複製產生新的發票轉入設定檔時自動產生UNIX目錄
   CALL p045_mkdir()   #TQC-C60190 add

   CALL p045_u()
   CALL p045_b()
   #FUN-C30027---begin
   #SELECT idi_file.* INTO g_idi.* FROM idi_file
   # WHERE idi01 = l_old01
   #   AND idi02 = l_old02
   #CALL p045_show()
   #FUN-C30027---end
END FUNCTION
 
FUNCTION p045(p_count)         #接受值,并打印報表  
   DEFINE p_count      LIKE type_file.num5 
#  DEFINE l_n          LIKE type_file.num5 
 
   CALL cl_err('','aic-060',1)  #CHI-C90044  
   CALL cl_del_data(p_table)

   SELECT zo02 INTO g_company FROM zo_file WHERE zo01=g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='aicp045'
   
   EXECUTE insert_prep USING p_count,g_msg  
           
   LET p_sql="SELECT * FROM ",g_cr_db_str CLIPPED,p_table CLIPPED
   
   IF g_zz05='Y' THEN
      CALL cl_wcchp(g_wc,'idi01,idi02,idi03,idi04,idi05,idj03,idj04,idj05')   #TQC-C60190 add idi04
           RETURNING g_wc 
   ELSE
      LET g_wc=""  	
   END IF 
   LET pp_str=g_wc,";",g_towhom

   CALL cl_prt_cs3('aicp045','aicp045',p_sql,pp_str)                 
END FUNCTION
 
FUNCTION p045_set_entry(p_cmd)
  DEFINE p_cmd  LIKE type_file.chr1
 
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("idi01,idi02",TRUE)
  END IF
 
END FUNCTION
 
FUNCTION p045_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("idi01,idi02",FALSE)
   END IF
 
END FUNCTION
 
#str TQC-C60190 add
FUNCTION p045_change_cron(p_argv1)        #轉檔-背景執行
   DEFINE p_argv1      LIKE type_file.chr1
   DEFINE l_idi01      LIKE idi_file.idi01
   DEFINE l_idi02      LIKE idi_file.idi02

   LET g_sql = "SELECT * FROM idi_file"
   PREPARE p045_idi_pre1 FROM g_sql
   DECLARE p045_idi_cs1 SCROLL CURSOR WITH HOLD FOR p045_idi_pre1
   FOREACH p045_idi_cs1 INTO g_idi.*
      CALL p045_change(p_argv1)
   END FOREACH

END FUNCTION
#end TQC-C60190 add

FUNCTION p045_change(p_argv1)             #轉檔
   DEFINE p_argv1      LIKE type_file.chr1
   DEFINE l_cmd        STRING
   DEFINE lch_pipe     base.Channel
   DEFINE l_idi01      LIKE idi_file.idi01
   DEFINE l_idi02      LIKE idi_file.idi02
   DEFINE l_idi03      LIKE idi_file.idi03     #TQC-C60190 add
   DEFINE l_idi08      LIKE idi_file.idi08
   DEFINE l_i          LIKE type_file.num5
   DEFINE l_n          LIKE type_file.num5
   DEFINE l_flag       LIKE type_file.chr1
   DEFINE l_codeset    STRING                  #No.MOD-8B0036 add
   DEFINE l_file_c     LIKE type_file.chr1000  #TQC-C60190 add
   DEFINE l_file_u     LIKE type_file.chr1000  #TQC-C60190 add
   DEFINE ss1          LIKE type_file.chr1000  #TQC-C60190 add
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   SELECT zz17 INTO g_len FROM zz_file WHERE zz01 = 'aicp045'
 
   IF cl_null(p_argv1) THEN
      #詢問是否要轉檔
      IF NOT cl_confirm('aic-072') THEN
         RETURN 
      END IF
   ELSE
      #若為p_cron呼叫時,insert 設置檔至temp table 
      CALL p045_temp() 
     #LET g_idi.idi03 = FGL_GETENV('TEMPDIR'),'/ICD/INV/upload'   #TQC-C60190 mark
   END IF
 
   #No.MOD-8B0036 add --begin
   LET ms_codeset=cl_get_codeset()
   LET l_codeset = ms_codeset
   IF ms_codeset.getIndexOf("BIG5", 1) OR (ms_codeset.getIndexOf("GB2312", 1)
      OR ms_codeset.getIndexOf("GBK",1) OR ms_codeset.getIndexOf("GB18030",1)) THEN
      IF ms_locale = "ZH_TW" AND g_lang = '2' THEN
         LET l_codeset = "GB2312"
      END IF
      IF ms_locale = "ZH_CN" AND g_lang = '0' THEN
         LET l_codeset = "BIG5"
      END IF
   END IF
   #No.MOD-8B0036 add --end

  #str TQC-C60190 add
   LET l_idi03 = FGL_GETENV('TOP'),'/doc/aic/aicp045/',g_idi.idi01 CLIPPED,'/',g_idi.idi02 CLIPPED,'/upload/'
   #ERP主機端目的檔完整路徑
   LET l_file_u = l_idi03,g_idi.idi03
   IF cl_null(p_argv1) AND g_idi.idi04 = 'Y' THEN   #從c:\tiptop上傳
      #Client端來源檔完整路徑
      LET l_file_c = 'c:/tiptop/',g_idi.idi03
      IF NOT cl_upload_file(l_file_c, l_file_u) THEN
         CALL cl_err(NULL, "lib-212", 1)
         RETURN
      END IF
   END IF
  #end TQC-C60190 add

   LET l_flag = '0'
   LET g_msg = ""
   LET g_str = ''   #TQC-C60190 add
 
   #取得路徑下所有待轉檔的檔案,利用openpipe取得路徑下的所有檔案
  #str TQC-C60190 mark
  #IF cl_null(g_idi.idi03) THEN
  #   LET g_idi.idi03=FGL_GETENV('TEMPDIR'),'/ICD/INV/upload'
  #END IF
  #LET  l_cmd = "ls ",g_idi.idi03 CLIPPED
  #end TQC-C60190 mark
   LET l_cmd = "ls ",l_idi03 CLIPPED   #TQC-C60190 add
   LET  lch_pipe = base.Channel.create()
   CALL lch_pipe.openPipe(l_cmd,"r")

  #一筆一筆讀入,gs_fname=每一個的檔名 
 WHILE lch_pipe.read(gs_fname)
      #將檔案重新編碼,檔名各不相同 
    # LET l_cmd="iconv -f big5 -t UTF-8 ",g_idi.idi03 CLIPPED,"/",           #No.MOD-8B0036 mark
     #str TQC-C60190 mark
     #IF os.Path.separator() = "/" THEN        #Unix 環境    #FUN-A30038
     #   LET l_cmd="iconv -f ",l_codeset," -t UTF-8 ",g_idi.idi03 CLIPPED,"/",  #No.MOD-8B0036 add
     #                gs_fname CLIPPED," > ",g_idi.idi03 CLIPPED,"/",
     #                                    gs_fname CLIPPED,".tmp"
     #ELSE                                                                                    #No.FUN-B30176
     #   LET l_cmd="java -cp zhcode.java zhcode -u8 ",g_idi.idi03 CLIPPED,os.Path.separator(),                 #No.FUN-B30176
     #                gs_fname CLIPPED," > ",g_idi.idi03 CLIPPED,os.Path.separator(),gs_fname CLIPPED,".tmp"  #No.FUN-B30176
     #   RUN l_cmd
     #END IF   #FUN-A30038
     #end TQC-C60190 mark
     #str TQC-C60190 add
      IF os.Path.separator() = "/" THEN        #Unix 環境    #FUN-A30038
         LET l_cmd="iconv -t UTF-8 ",l_idi03 CLIPPED,"/",  #No.MOD-8B0036 add
                             gs_fname CLIPPED," > ",l_idi03 CLIPPED,"/",
                             gs_fname CLIPPED,".tmp"
         RUN l_cmd
      ELSE
         LET l_cmd="java -cp zhcode.java zhcode -u8 ",l_idi03 CLIPPED,os.Path.separator(),
                      gs_fname CLIPPED," > ",l_idi03 CLIPPED,os.Path.separator(),gs_fname CLIPPED,".tmp"
         RUN l_cmd
      END IF
     #end TQC-C60190 add
 
      LET l_cmd="rm ",l_idi03 CLIPPED,"/",gs_fname CLIPPED   #TQC-C60190 mod g_idi.idi03->l_idi03
      RUN l_cmd 
 
      LET l_cmd="mv ",l_idi03 CLIPPED,"/",gs_fname CLIPPED,".tmp ",   #TQC-C60190 mod g_idi.idi03->l_idi03
                      l_idi03 CLIPPED,"/",gs_fname CLIPPED            #TQC-C60190 mod g_idi.idi03->l_idi03
      RUN l_cmd
 
      #記錄指定的路徑下有無檔案
      LET l_flag = '1'
      #判斷是否為p_cron呼叫
      IF NOT cl_null(p_argv1) THEN
         #有p_cron呼叫時,先取得設置檔 
         CALL p045_p_cron(gs_fname) RETURNING l_idi01,l_idi02
         
         #1.若檔案無法打開時，回傳空值     #2.找不到符合的設置檔,回傳"N"
         IF (cl_null(l_idi01) AND cl_null(l_idi02)) OR
            (l_idi01 = 'N' AND l_idi02 = 'N') THEN
             
            #把檔案移至指定目錄下
            CALL p045_mv('miss',gs_fname)
            CONTINUE WHILE
         END IF
      ELSE
         LET l_idi01 = g_idi.idi01
         LET l_idi02 = g_idi.idi02
      END IF
 
      LET l_idi08 = 0
      SELECT idi08 INTO l_idi08 FROM idi_file
       WHERE idi01 = l_idi01
         AND idi02 = l_idi02
     
      #處理轉檔,xxx.txt insert idk_file 
      CALL p045_ins_idk(gs_fname,l_idi01,l_idi02)
   
      IF cl_null(l_idi08) THEN
         LET l_idi08 = 0
      ELSE
         IF g_success = 'N' THEN
            UPDATE idi_file SET idi08 = l_idi08 + 1
             WHERE idi01 = l_idi01
               AND idi02 = l_idi02
         END IF
      END IF
      
      #變更err report 為指定的檔名
     #LET g_name = "mv ",g_name CLIPPED," ",gs_fname CLIPPED,     #TQC-C60190 mark
      LET g_name = "mv ",gs_fname CLIPPED," ",gs_fname CLIPPED,   #TQC-C60190
                   ".err.unload.",l_idi08 + 1 USING '&&&&&'
      RUN g_name
 
#     LET g_name = "chmod 777 ",gs_fname CLIPPED,".err.unload.",#No.FUN-9C000  
#                  l_idi08 + 1 USING "&&&&&"                    #No.FUN-9C000 
#     RUN g_name                                                #No.FUN-9C000
      IF os.Path.chrwx(gs_fname CLIPPED,511) THEN END IF        #No.FUN-9C0009
      LET g_name = gs_fname CLIPPED,".err.unload.",l_idi08 + 1 USING "&&&&&"
      CALL p045_mv('rep',g_name)
     
   END WHILE
   CALL lch_pipe.close()
 
   IF cl_null(p_argv1) THEN
      UPDATE idi_file SET idi08 = l_idi08 + 1
       WHERE idi01 = l_idi01
         AND idi02 = l_idi02
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('upd idi',SQLCA.sqlcode,0)
      END IF
      #CALL cl_err("","aic-065",1) #CHI-CA0007
   END IF
 
   #指定的路徑下無檔案時
   IF l_flag = '0' THEN
      LET g_msg = cl_getmsg('aic-068',g_lang)
      LET g_msg = g_idi.idi03 CLIPPED,': ',g_msg CLIPPED
      CALL p045(0)
   ELSE
      #從idk_file轉到rvw_file
      CALL p045_ins_rvw()
   END IF
 
END FUNCTION
 
FUNCTION p045_temp()
   DEFINE l_idi      RECORD LIKE idi_file.*
   DEFINE l_temp0301        LIKE idj_file.idj03  #廠商順序
   DEFINE l_temp0302        LIKE idj_file.idj03  #工廠順序
   
   LET g_sql = "SELECT * FROM idi_file"
   PREPARE p045_a FROM g_sql
   DECLARE p045_a_cs CURSOR FOR p045_a
 
   FOREACH p045_a_cs INTO l_idi.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach idi:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET g_msg = ''
 
      #撈廠商順序
      LET l_temp0301 = ''
      SELECT idj03 INTO l_temp0301 FROM idj_file
       WHERE idj01 = l_idi.idi01
         AND idj02 = l_idi.idi02
         AND idj04 = 'idk_file'
         AND idj05 = 'idk18'
 
      #撈工廠順序
      LET l_temp0302 = ''
      SELECT idj03 INTO l_temp0302 FROM idj_file
       WHERE idj01 = l_idi.idi01
         AND idj02 = l_idi.idi02
         AND idj04 = 'idk_file'
         AND idj05 = 'idk19'
 
      #廠商及工廠需皆存在idj_file
      IF NOT cl_null(l_temp0301) AND NOT cl_null(l_temp0302) THEN
         INSERT INTO p045_file VALUES(l_idi.idi01,l_idi.idi02,
                                      l_temp0301,l_temp0302,l_idi.idi05)       
      END IF
   END FOREACH
END FUNCTION
 
#由p_cron呼叫時,先取得設置檔->傳入:欲轉檔的檔名,回傳:設置檔的"廠商"和"工廠"
FUNCTION p045_p_cron(p_fname)
   DEFINE p_fname     STRING
   DEFINE l_cmd       STRING
   DEFINE l_str       STRING               #檔案內的資料 
   DEFINE l_data      STRING               #欄位資料
   DEFINE l_channel   base.Channel
   DEFINE l_n         LIKE type_file.num5
   DEFINE l_symbol    STRING
   DEFINE l_temp      RECORD
           temp01     LIKE idj_file.idj01, #廠商
           temp02     LIKE idj_file.idj02, #工廠
           temp0301   LIKE idj_file.idj03, #廠商順序
           temp0302   LIKE idj_file.idj03, #工廠順序
           temp04     LIKE idi_file.idi05  #分隔符號
                      END RECORD
                   
   LET g_msg = ''
   
   #把p_fname的第一筆資料,放到l_str
  #LET l_cmd = g_idi.idi03 CLIPPED,'/',p_fname CLIPPED                                             #TQC-C60190 mark
   LET l_cmd = FGL_GETENV('TOP'),'/doc/aic/aicp045/',g_idi.idi01 CLIPPED,'/',g_idi.idi02 CLIPPED,  #TQC-C60190
                                 '/upload/',p_fname CLIPPED                                        #TQC-C60190
   LET l_channel = base.Channel.create()
   CALL l_channel.openFile(l_cmd,"r")
   
   IF STATUS THEN
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
 
   LET g_sql = "SELECT * FROM p045_file"
   PREPARE p045_temp FROM g_sql
   DECLARE p045_temp_cs CURSOR FOR p045_temp
 
   FOREACH p045_temp_cs INTO l_temp.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach temp:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      #取得分隔符號
      CASE l_temp.temp04   #0.Tab 1.分號 2.逗號
         WHEN '0'  LET l_symbol = '    '
         WHEN '1'  LET l_symbol = ';'
         WHEN '2'  LET l_symbol = ','
      END CASE
    
      #判斷廠商及工廠在字串的順序是否符合設置檔
      CALL p045_data(l_str,l_symbol,l_temp.temp0301) RETURNING l_data
      IF l_data != l_temp.temp01 OR cl_null(l_data) THEN
         CONTINUE FOREACH
      END IF
 
      CALL p045_data(l_str,l_symbol,l_temp.temp0302) RETURNING l_data
      IF cl_null(l_data) THEN
         LET l_data = '00'
      END IF
      IF l_data != l_temp.temp02 THEN
         CONTINUE FOREACH
      END IF
 
      #回傳符合的廠商及工廠
      RETURN l_temp.temp01,l_temp.temp02
 
   END FOREACH
   #若找不到符合的資料時,回傳N,N
   RETURN 'N','N'
 
END FUNCTION
 
#依"字串""分隔符號""第N個值"回傳字串中的"第N個值"
FUNCTION p045_data(p_str,p_symbol,p_num)
   DEFINE p_str        STRING               
   DEFINE p_symbol     STRING                #設定檔的分隔符號
   DEFINE p_num        LIKE type_file.num5   #要取得第幾個的值
   DEFINE l_n          LIKE type_file.num5   #字串的總長度
   DEFINE l_count      LIKE type_file.num5   #目前抓到第幾個值
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
            #若無值是,回傳''
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
   #找不到符合的資料時,則回傳原本的字串
   RETURN p_str
 
END FUNCTION
 
#處理轉檔
FUNCTION p045_ins_idk(p_fname,p_idi01,p_idi02)
   DEFINE p_fname         STRING                      #欲轉檔的檔名
   DEFINE p_idi01         LIKE idi_file.idi01         #設定檔的廠商
   DEFINE p_idi02         LIKE idi_file.idi02         #設定檔的工廠
   DEFINE l_channel       base.Channel
   DEFINE l_data          STRING                      #欄位資料
   DEFINE l_date          LIKE type_file.dat          #日期變數   #TQC-C60190 add
   DEFINE l_type          LIKE type_file.chr50        #欄位形態
   DEFINE l_str           STRING                      #資料(筆)
   DEFINE l_cmd           STRING                      #路徑+檔名
   DEFINE l_field         STRING                      #要insert進idk_file的欄位
   DEFINE l_values        STRING                      #要insert進idk_file的值
   DEFINE l_where         STRING                      #要update的條件
   DEFINE l_idi03         LIKE idi_file.idi03         #設定檔的路徑
   DEFINE l_idi05         LIKE idi_file.idi05         #設定檔的分隔符號
   DEFINE l_symbol        STRING                      #分隔符號	
   DEFINE l_idj03         LIKE idj_file.idj03         #設定檔的順序
   DEFINE l_idj04         LIKE idj_file.idj04         #設定檔的檔案名稱
   DEFINE l_idj05         LIKE idj_file.idj05         #設定檔的欄位名稱
   DEFINE l_count         LIKE type_file.num5  
   DEFINE l_n             LIKE type_file.num5
   DEFINE l_idk01         LIKE idk_file.idk01
   DEFINE l_idk02         LIKE idk_file.idk02
   DEFINE l_idk08         LIKE idk_file.idk08         #入庫單號  #TQC-C60190 add
   DEFINE l_idk09         LIKE idk_file.idk09         #入庫項次  #TQC-C60190 add
   DEFINE l_idk21         LIKE idk_file.idk21
   DEFINE l_f2            STRING                      #要insert進idk_file的欄位
   DEFINE l_v2            STRING                      #要insert進idk_file的欄位
   DEFINE l_war           LIKE type_file.chr1         #是否要show rep
   DEFINE l_sta           LIKE type_file.chr1         #是否要start rep
   DEFINE l_data_length   LIKE type_file.chr8         #FUN-A90024
   
   #設置檔需存在的欄位
   LET l_n = 0 
   SELECT COUNT(*) INTO l_n FROM idj_file
    WHERE idj01 = p_idi01
      AND idj02 = p_idi02
      AND idj04 = 'idk_file'
      AND idj05 = 'idk01'
   IF l_n = 0 THEN
      LET g_msg = cl_getmsg('aic-073',g_lang)
      LET g_msg = 'idk01',g_msg CLIPPED
      CALL p045(0)
      CALL p045_mv("err",p_fname)
      LET g_success = "N"
      RETURN
   END IF
 
   LET l_n = 0 
   SELECT COUNT(*) INTO l_n FROM idj_file
    WHERE idj01 = p_idi01
      AND idj02 = p_idi02
      AND idj04 = 'idk_file'
      AND idj05 = 'idk21'
   IF l_n = 0 THEN
      LET g_msg = cl_getmsg('aic-073',g_lang)
      LET g_msg = 'idk21',g_msg CLIPPED
      CALL p045(0)
      CALL p045_mv("err",p_fname)
      LET g_success = "N"
      RETURN
   END IF
 
   LET l_n = 0 
   SELECT COUNT(*) INTO l_n FROM idj_file
    WHERE idj01 = p_idi01
      AND idj02 = p_idi02
      AND idj04 = 'idk_file'
      AND idj05 = 'idk17'
   IF l_n = 0 THEN
      LET g_msg = cl_getmsg('aic-073',g_lang)
      LET g_msg = 'idk17',g_msg CLIPPED
      CALL p045(0)
      CALL p045_mv("err",p_fname)
      LET g_success = "N"
      RETURN
   END IF
 
   LET l_n = 0 
   SELECT COUNT(*) INTO l_n FROM idj_file
    WHERE idj01 = p_idi01
      AND idj02 = p_idi02
      AND idj04 = 'idk_file'
      AND idj05 = 'idk11'
   IF l_n = 0 THEN
      LET g_msg = cl_getmsg('aic-073',g_lang)
      LET g_msg = 'idk11',g_msg CLIPPED
      CALL p045(0)
      CALL p045_mv("err",p_fname)
      LET g_success = "N"
      RETURN
   END IF
 
   LET l_n = 0 
   SELECT COUNT(*) INTO l_n FROM idj_file
    WHERE idj01 = p_idi01
      AND idj02 = p_idi02
      AND idj04 = 'idk_file'
      AND idj05 = 'idk12'
   IF l_n = 0 THEN
      LET g_msg = cl_getmsg('aic-073',g_lang)
      LET g_msg = 'idk12',g_msg CLIPPED
      CALL p045(0)
      CALL p045_mv("err",p_fname)
      LET g_success = "N"
      RETURN
   END IF
 
   LET g_sql = "SELECT idj03,idj04,idj05",
               "  FROM idj_file",
               " WHERE idj01 = '",p_idi01,"'",
               "   AND idj02 = '",p_idi02,"'",
               " ORDER BY idj04,idj03"
 
   PREPARE p045_b FROM g_sql
   DECLARE p045_b_cs CURSOR FOR p045_b
 
   #取設置檔上的路徑及分隔符號
   SELECT idi03,idi05 INTO l_idi03,l_idi05 FROM idi_file
    WHERE idi01 = p_idi01
      AND idi02 = p_idi02
   IF SQLCA.sqlcode THEN
      LET g_msg = cl_getmsg(SQLCA.sqlcode,g_lang)
      LET g_msg = g_msg CLIPPED,": ",p_fname CLIPPED
      CALL p045(0)
      RETURN
   END IF
 
   #取得分隔符號
   CASE
      WHEN l_idi05 = "0"
         LET l_symbol = "	"
      WHEN l_idi05 = "1"
         LET l_symbol = ";"
      WHEN l_idi05 = "2"
         LET l_symbol = ","
   END CASE
   #把p_fname的第n筆資料,放到l_str
  #LET l_cmd = l_idi03 CLIPPED,'/',p_fname CLIPPED                                                 #TQC-C60190 mark
   LET l_cmd = FGL_GETENV('TOP'),'/doc/aic/aicp045/',g_idi.idi01 CLIPPED,'/',g_idi.idi02 CLIPPED,  #TQC-C60190
                                 '/upload/',p_fname CLIPPED                                        #TQC-C60190
   LET l_channel = base.Channel.create()
   CALL l_channel.openFile(l_cmd,"r")
   IF STATUS THEN
      LET g_msg = cl_getmsg("-808",g_lang)
      LET g_msg = g_msg CLIPPED,": ",l_cmd CLIPPED
      CALL p045(0)
      RETURN 
   END IF
 
   BEGIN WORK
   LET g_success = "Y"
 
   LET l_war = "N"
   LET l_sta = "Y"
   LET l_count = 1 
   
   #讀取檔案里的每筆資料
   WHILE l_channel.read([l_str])
      #略過第一行抬頭的部分 
      IF l_count = 1 THEN
         LET l_count = l_count + 1
         CONTINUE WHILE
      END IF
 
      IF l_str.getLength() = 0 THEN
         EXIT WHILE
      END IF
     
      #可能會有斷行符號
      CALL p045_data(l_str,"","1") RETURNING l_data
      
      #開始組要insert 或update的字串
      LET l_field = ""
      LET l_values = ""
      LET l_idk01 = ""
      LET l_idk02 = ""
      LET l_idk08 = ""   #TQC-C60190 add
      LET l_idk21 = ""
      FOREACH p045_b_cs INTO l_idj03,l_idj04,l_idj05
         IF SQLCA.sqlcode THEN
            CALL cl_err("foreach idj:",SQLCA.sqlcode,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
 
         #取得欄位值            
         CALL p045_data(l_str,l_symbol,l_idj03) RETURNING l_data
         IF l_str = l_data THEN LET l_data = '' END IF
         IF l_idj05 = "idk03" AND cl_null(l_data) THEN
            LET l_data = '00'
         END IF
          
         #在第一筆資料判斷設置檔是否符合,若是不符合則show錯誤訊息and rollback
         IF (l_idj05 = "idk18" AND l_data != g_idi.idi01) OR
            (l_idj05 = "idk19" AND l_data != g_idi.idi02) THEN
            #把檔案移至指定目錄下
            CALL p045_mv("miss",p_fname)
            LET g_success = "N"
            EXIT FOREACH
         END IF
 
         #確認以下欄位在檔案里要有值,若無值則err
         IF (l_idj05 = "idk01" OR #l_idj05 = "idk21" OR   #TQC-C60190 remove idk21
             l_idj05 = "idk17" OR l_idj05 = "idk11" OR 
             l_idj05 = "idk12") THEN
            IF cl_null(l_data) THEN
               LET g_msg = l_idj05,cl_getmsg("aic-067",g_lang) CLIPPED  #TQC-C60190 add
              #str TQC-C60190 mark
              #CASE
              #   WHEN l_idj05 = "idk01"
              #      LET g_msg = cl_getmsg("aic-067",g_lang)
              #      LET g_msg = "idk01",g_msg CLIPPED
              #   WHEN l_idj05 = "idk21"
              #      LET g_msg = cl_getmsg("aic-067",g_lang)
              #      LET g_msg = "idk21",g_msg CLIPPED
              #   WHEN l_idj05 = "idk17"
              #      LET g_msg = cl_getmsg("aic-067",g_lang)
              #      LET g_msg = "idk17",g_msg CLIPPED
              #   WHEN l_idj05 = "idk11"
              #      LET g_msg = cl_getmsg("aic-067",g_lang)
              #      LET g_msg = "idk11",g_msg CLIPPED
              #   WHEN l_idj05 = "idk12"
              #      LET g_msg = cl_getmsg("aic-067",g_lang)
              #      LET g_msg = "idk12",g_msg CLIPPED
              #END CASE
              #end TQC-C60190 mark
           
               IF l_sta = "Y" THEN          
                  SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='aicp045'   
                  SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang     
                  LET l_sta = "N"
               END IF  
               CALL cl_err('','aic-060',1)     #CHI-C90044
               CALL p045_out(l_count,g_msg)     
 
               CALL p045_mv("err",p_fname)
               LET g_success = "N"
               EXIT FOREACH
            END IF
           #str TQC-C60190 mark
           #IF l_idj05 = "idk21" THEN
           #   LET l_idk21 = l_data
           #   LET l_n = 0 
           #   SELECT COUNT(*) INTO l_n FROM rva_file
           #    WHERE rva08 = l_idk21
           #   IF l_n = 0 THEN
           #      IF l_sta = "Y" THEN              
           #         CALL p045(0)
           #         LET l_sta = "N"
           #      END IF
           #    
           #      LET g_msg = cl_getmsg("mfg3070",g_lang)
           #      LET g_msg = "idk21",g_msg CLIPPED                
           #   
           #      CALL p045_out(l_count,g_msg)
           #   
           #      CALL p045_mv("err",p_fname)
           #      LET g_success = "N"
           #      EXIT FOREACH
           #   END IF
           #END IF
           #end TQC-C60190 mark
            IF l_idj05 = "idk01" THEN
               LET l_idk01 = l_data
            END IF
         END IF
        #IF l_idj05 = "idk02" THEN   #TQC-C60190 mark
        #   LET l_idk02 = l_data     #TQC-C60190 mark
        #END IF                      #TQC-C60190 mark
        #str TQC-C60190 add
         IF l_idj05 = "idk08" THEN
            LET l_idk08 = l_data
         END IF
         IF l_idj05 = "idk09" THEN
            LET l_idk09 = l_data
         END IF
         IF l_idj05 = "idk21" THEN
            LET l_idk21 = l_data
         END IF
        #end TQC-C60190 add
  
         #此欄位最後再給值
         IF l_idj05 = "idk03" OR l_idj05 = "idk04" OR 
            l_idj05 = "idk05" OR l_idj05 = "idk05f" OR 
            l_idj05 = "idk06" OR l_idj05 = "idk06f" OR 
           #l_idj05 = "idk08" OR l_idj05 = "idk09" OR   #TQC-C60190 mark
            l_idj05 = "idk10" OR l_idj05 = "idk17" OR 
            l_idj05 = "idk29" THEN
            CONTINUE FOREACH
         END IF
      
          #取欄位形態
         #---FUN-A90024---start-----
         #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
         #目前統一用sch_file紀錄TIPTOP資料結構  
         #SELECT systypes.name FROM syscolumns,systypes
         # WHERE syscolumns.xusertype = systypes.xusertype
         #   AND syscolumns.id = objects_id(l_idj04)
         #   AND syscolumns.name = l_idj05
         CALL cl_get_column_info('ds', l_idj04, l_idj05) 
              RETURNING l_type, l_data_length
         #---FUN-A90024---end-------  

        #str TQC-C60190 add
         IF l_type = 'date' THEN
            LET l_date = l_data
            LET l_date = l_date USING 'YY/MM/DD'
            IF l_idj05 = "idk02" THEN
               LET l_idk02 = l_date
               LET l_data = l_date
            END IF
         END IF
        #end TQC-C60190 add
 
         IF l_idj05 = "idk19" AND cl_null(l_data) THEN
            LET l_data = "00"
         END IF
 
         #依insert組欄位+欄位值
         LET l_field = l_field CLIPPED,l_idj05 CLIPPED,","
         IF l_type = "number" THEN
            IF cl_null(l_values) THEN LET l_values = 0 END IF
            LET l_values = l_values CLIPPED,l_data CLIPPED,","
         ELSE
            LET l_values = l_values CLIPPED,"'",l_data CLIPPED,"',"
         END IF
 
      END FOREACH
 
      IF g_success = "Y" THEN
         IF NOT cl_null(l_idk21) AND l_idk21 != ' ' THEN   #TQC-C60190 add
            #如果已存在相同的idk01,idk02,idk21則出警告訊息
            LET l_n = 0 
            IF cl_null(l_idk02) THEN
               SELECT COUNT(*) INTO l_n FROM idk_file
                WHERE idk01 = l_idk01
                  AND idk02 IS NULL
                  AND idk21 = l_idk21
            ELSE
               SELECT COUNT(*) INTO l_n FROM idk_file
                WHERE idk01 = l_idk01
                  AND idk02 = l_idk02
                  AND idk21 = l_idk21
            END IF
            LET g_flag = '1'   #TQC-C60190 add
            CALL p045_chk(p_fname,l_str,l_symbol,p_idi01,p_idi02,l_idk21,l_idk09,l_count)  #TQC-C60190 add l_idk09
                 RETURNING l_f2,l_v2
            IF g_success = "N" THEN
               CALL p045_mv("err",p_fname)
            END IF
        #str TQC-C60190 add
         ELSE
            LET g_flag = '2'   #TQC-C60190 add
            CALL p045_chk(p_fname,l_str,l_symbol,p_idi01,p_idi02,l_idk08,l_idk09,l_count)  #TQC-C60190 add l_idk09
                 RETURNING l_f2,l_v2
            IF g_success = "N" THEN
               CALL p045_mv("err",p_fname)
            END IF
         END IF
        #end TQC-C60190 add
      END IF
      IF g_success = "Y" THEN
         #依insert組sql 
         LET l_field = l_field CLIPPED,l_f2 CLIPPED
         LET l_values = l_values CLIPPED,l_v2 CLIPPED
 
         LET l_field=l_field CLIPPED,
                     "idk29,idkplant,idklegal"    #FUN-980004 add plant & legal #TQC-C60190 add idk29
         LET l_values=l_values CLIPPED,
                      "'N','",g_plant CLIPPED,"','",g_legal CLIPPED,"'"  #FUN-980004 add plant & legal  #TQC-C60190 add 'N'
 
         LET g_sql = "INSERT INTO idk_file (",l_field CLIPPED,") ",
                     "VALUES (",l_values,")"
         PREPARE p045_ins_idk FROM g_sql
         EXECUTE p045_ins_idk
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
         END IF
         LET l_count = l_count + 1 
      ELSE
         EXIT WHILE 
      END IF
 
   END WHILE 
 
   IF g_success = 'Y' AND l_count <= 2 THEN
      #把檔案移至指定目錄下 
      CALL p045_mv("miss",p_fname)
      LET g_success = "N"
   END IF
 
   IF g_success = "N" THEN
      ROLLBACK WORK
   ELSE
      IF l_war = "Y" THEN   
         CALL cl_prt_cs3('aicp045','aicp045',p_sql,pp_str)     
         LET g_success = "N"
      END IF  
      COMMIT WORK
      CALL p045_mv("ok",p_fname)
   END IF
 
END FUNCTION
 
FUNCTION p045_mv(p_msg,p_fname)
   DEFINE p_msg     STRING         #狀態
   DEFINE p_fname   STRING         #檔名
   DEFINE l_stro    STRING         #舊路徑
   DEFINE l_strn    STRING         #新路徑
   DEFINE l_cmd     STRING         #欲執行的指令
   DEFINE l_path    STRING         #固定目錄字串   #TQC-C60190 add

   LET l_path = FGL_GETENV('TOP'),'/doc/aic/aicp045/',g_idi.idi01 CLIPPED,'/',g_idi.idi02 CLIPPED   #TQC-C60190 add

  #LET l_stro = FGL_GETENV('TEMPDIR'),'/ICD/INV/backup',p_fname CLIPPED   #TQC-C60190 mark
   LET l_stro = l_path,'/upload/',p_fname CLIPPED                         #TQC-C60190 mod
 
   #判斷要將檔案移至那個路徑下
  #str TQC-C60190 mark
  #CASE
  #   WHEN p_msg = 'miss'
  #      LET l_strn = FGL_GETENV('TEMPDIR'),'/ICD/INV/upload',p_fname CLIPPED
  #    
  #   WHEN p_msg = 'ok'
  #      LET l_strn = FGL_GETENV('TEMPDIR'),'/ICD/INV/upload',p_fname CLIPPED
  #   
  #   WHEN p_msg = 'err'
  #      LET l_strn = FGL_GETENV('TEMPDIR'),'/ICD/INV/upload',p_fname CLIPPED
  #   
  #   WHEN p_msg = 'rep'
  #      LET l_stro = FGL_GETENV('TEMPDIR'),'/ICD/INV/backup',p_fname CLIPPED
  #      LET l_strn = FGL_GETENV('TEMPDIR'),'/ICD/INV/upload',p_fname CLIPPED
  #END CASE
  #end TQC-C60190 mark
  #str TQC-C60190 add
   IF p_msg = "ok" THEN
      LET l_strn = l_path,'/trans/',p_fname CLIPPED
   ELSE
      LET l_strn = l_path,'/error/',p_fname CLIPPED
   END IF
  #end TQC-C60190 add

   LET l_cmd = "mv ",l_stro CLIPPED," ",l_strn CLIPPED
   RUN l_cmd
 
#  LET l_cmd = "chmod 777 ",l_strn CLIPPED            #No.FUN-9C0009 
#  RUN l_cmd                                          #No.FUN-9C0009
   IF os.Path.chrwx(l_strn CLIPPED,511) THEN END IF   #No.FUN-9C0009
END FUNCTION
 
#檢查單價與數量等,是否與收貨單相等
FUNCTION p045_chk(p_fname,p_str,p_symbol,p_idi01,p_idi02,p_idk21,p_idk09,p_count)  #TQC-C60190 add p_idk09
   DEFINE p_fname         STRING
   DEFINE p_str           STRING
   DEFINE p_symbol        STRING
   DEFINE p_idi01         LIKE idi_file.idi01
   DEFINE p_idi02         LIKE idi_file.idi02
   DEFINE p_idk21         LIKE idk_file.idk21
   DEFINE p_idk09         LIKE idk_file.idk09   #TQC0C60190 add
   DEFINE p_count         LIKE type_file.num5
   DEFINE l_data          STRING
   DEFINE l_field         STRING
   DEFINE l_values        STRING
   DEFINE l_idj03         LIKE idj_file.idj03
   DEFINE l_idk05         LIKE idk_file.idk05
   DEFINE l_idk05f        LIKE idk_file.idk05f
   DEFINE l_idk06         LIKE idk_file.idk06
   DEFINE l_idk06f        LIKE idk_file.idk06f
   DEFINE l_idk11         LIKE idk_file.idk11
   DEFINE l_idk12         LIKE idk_file.idk12
   DEFINE l_pmm21         LIKE pmm_file.pmm21
   DEFINE l_pmm43         LIKE pmm_file.pmm43
   DEFINE l_rvb01         LIKE rvb_file.rvb01
#  DEFINE l_rvb07         LIKE rvb_file.rvb07   #CHI-B70039 mark
   DEFINE l_rvb10         LIKE rvb_file.rvb10
   DEFINE l_azi04         LIKE azi_file.azi04
   DEFINE l_rvb87         LIKE rvb_file.rvb87   #CHI-B70039 add
 
   LET l_field = ""
   LET l_values = ""
   
   #取得設置檔的順序
   LET g_sql = "SELECT idj03 FROM idj_file",
               " WHERE idj01 = '",p_idi01,"'",
               "   AND idj02 = '",p_idi02,"'",
               "   AND idj05 = ?"
   PREPARE p045_3 FROM g_sql
   DECLARE p045_3_cs CURSOR FOR p045_3

  #str TQC-C60190 add
   #先取得收貨單號,後面再用收貨單號去抓其他需要的值
   LET l_rvb01 = ''
   IF g_flag = '1' THEN
      SELECT rva01 INTO l_rvb01 FROM rva_file WHERE rva08= p_idk21
   ELSE
      SELECT rvu02 INTO l_rvb01 FROM rvu_file WHERE rvu01= p_idk21
   END IF
  #end TQC-C60190 add
  
##########稅別##########
   #取得idk03"稅別"的值,檢查與收貨單上是否相同
   LET l_data = ""
   FOREACH p045_3_cs USING "idk03" INTO l_idj03
      IF SQLCA.sqlcode THEN
         CALL cl_err("for:",SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CALL p045_data(p_str,p_symbol,l_idj03) RETURNING l_data
   END FOREACH

   #稅別 稅率
   LET g_sql = "SELECT pmm21,pmm43 FROM pmm_file,rvb_file,rva_file",
              #" WHERE rva08 = '",p_idk21,"'",   #TQC-C60190 mark
               " WHERE rva01 = '",l_rvb01,"'",   #TQC-C60190
               "   AND rva01 = rvb01 AND rvb04 = pmm01"
   PREPARE p045_pmm FROM g_sql
   DECLARE p045_pmm_cs CURSOR FOR p045_pmm
   FOREACH p045_pmm_cs INTO l_pmm21,l_pmm43
      IF SQLCA.sqlcode THEN
         CALL cl_err("foreach pmm:",SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF NOT cl_null(l_pmm21) AND NOT cl_null(l_pmm43) THEN
         EXIT FOREACH
      END IF
   END FOREACH
 
   #檢查稅別與收貨單是否相同
   IF NOT cl_null(l_data) THEN
      IF l_pmm21 != l_data THEN
         LET g_msg = cl_getmsg("aic-074",g_lang)
         #LET g_msg = p_fname CLIPPED,": idk03",g_msg CLIPPED         #CHI-C90044
         LET g_msg = p_fname CLIPPED,": idk03 ",l_data,g_msg CLIPPED  #CHI-C90044
         CALL p045(p_count)
         LET g_success = "N"
         RETURN l_field,l_values
      END IF
   END IF
   LET l_field = l_field CLIPPED,"idk03,"
   LET l_values = l_values CLIPPED,"'",l_pmm21,"',"
 
##########稅率##########
   #取得idk04"稅率"的值,檢查與收貨單上是否相同
   LET l_data = ""
   FOREACH p045_3_cs USING "idk04" INTO l_idj03
      IF SQLCA.sqlcode THEN
         CALL cl_err("for:",SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CALL p045_data(p_str,p_symbol,l_idj03) RETURNING l_data
   END FOREACH
 
   #檢查稅率是否與收貨單相同
   IF NOT cl_null(l_data) THEN
      IF l_pmm43 != l_data THEN
         LET g_msg = cl_getmsg("aic-074",g_lang)
         #LET g_msg = p_fname CLIPPED,": idk04",g_msg CLIPPED        #CHI-C90044
         LET g_msg = p_fname CLIPPED,": idk04 ",l_data,g_msg CLIPPED #CHI-C90044
         CALL p045(p_count)
         LET g_success = "N"
         RETURN l_field,l_values
      END IF
   END IF
   LET l_field = l_field CLIPPED,"idk04,"
   LET l_values = l_values CLIPPED,l_pmm43,","
 
##########單價##########
   #取得idk17"單價"的值,檢查與收貨單上是否相同 
   LET l_data = ""
   FOREACH p045_3_cs USING "idk17" INTO l_idj03
      IF SQLCA.sqlcode THEN
         CALL cl_err("for:",SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CALL p045_data(p_str,p_symbol,l_idj03) RETURNING l_data
   END FOREACH
 
   #單價
   LET g_sql = "SELECT rvb10 FROM rvb_file,rva_file",   #TQC-C60190 remove rvb01
              #" WHERE rva08 = '",p_idk21,"'",   #TQC-C60190 mark
               " WHERE rva01 = '",l_rvb01,"'",   #TQC-C60190
               "   AND rvb02 = ",p_idk09,        #TQC-C60190 add
               "   AND rva01 = rvb01"
   PREPARE p045_rvb FROM g_sql
   DECLARE p045_rvb_cs CURSOR FOR p045_rvb
   FOREACH p045_rvb_cs INTO l_rvb10   #TQC-C60190 remove l_rvb01
      IF SQLCA.sqlcode THEN
         CALL cl_err("foreach rvb:",SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF NOT cl_null(l_rvb10) THEN
         EXIT FOREACH
      END IF
   END FOREACH
 
   #檢查單價與收貨單是否相同
   IF NOT cl_null(l_data) THEN
      IF l_rvb10 != l_data THEN
         LET g_msg = cl_getmsg("aic-074",g_lang)
         #LET g_msg = p_fname CLIPPED,": idk17",g_msg CLIPPED        #CHI-C90044
         LET g_msg = p_fname CLIPPED,": idk17 ",l_data,g_msg CLIPPED #CHI-C90044
         CALL p045(p_count)
         LET g_success = "N"
         RETURN l_field,l_values
      END IF
   END IF
   LET l_field = l_field CLIPPED,"idk17,"
   LET l_values = l_values CLIPPED,l_rvb10,","
 
##########數量##########
   #取得idk10"數量"的值,檢查與收貨單上是否相同
   LET l_data = ""
   FOREACH p045_3_cs USING "idk10" INTO l_idj03
      IF SQLCA.sqlcode THEN
         CALL cl_err("for:",SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CALL p045_data(p_str,p_symbol,l_idj03) RETURNING l_data
   END FOREACH
 
   #數量
   LET g_sql = "SELECT SUM(rvb87) FROM rvb_file",   #CHI-B70039 mod rvb07->rvb87
               " WHERE rvb01 = '",l_rvb01,"'",
               "   AND rvb02 = ",p_idk09            #TQC-C60190 add
   PREPARE p045_rvb87 FROM g_sql                    #CHI-B70039 mod rvb07->rvb87
   DECLARE p045_rvb87_cs CURSOR FOR p045_rvb87      #CHI-B70039 mod rvb07->rvb87
   FOREACH p045_rvb87_cs INTO l_rvb87               #CHI-B70039 mod rvb07->rvb87
      IF SQLCA.sqlcode THEN
         CALL cl_err("foreach rvb87:",SQLCA.sqlcode,1)   #CHI-B70039 mod rvb07->rvb87
         EXIT FOREACH
      END IF
      IF NOT cl_null(l_rvb87) THEN   #CHI-B70039 mod rvb07->rvb87
         EXIT FOREACH
      END IF
   END FOREACH
 
   #檢查數量與收貨單是否相同 
   IF NOT cl_null(l_data) THEN
      IF l_rvb87 != l_data THEN   #CHI-B70039 mod rvb07->rvb87
         LET g_msg = cl_getmsg("aic-074",g_lang)
         #LET g_msg = p_fname CLIPPED,": idk10",g_msg CLIPPED        #CHI-C90044
         LET g_msg = p_fname CLIPPED,": idk10 ",l_data,g_msg CLIPPED #CHI-C90044
         CALL p045(p_count)
         LET g_success = "N"
         RETURN l_field,l_values
      END IF
   END IF
   LET l_field = l_field CLIPPED,"idk10,"
   LET l_values = l_values CLIPPED,l_rvb87,","   #CHI-B70039 mod rvb07->rvb87
 
##########幣別##########
   #取得idk11"幣別"的值
   LET l_data = ""
   FOREACH p045_3_cs USING "idk11" INTO l_idj03
      IF SQLCA.sqlcode THEN
         CALL cl_err("for:",SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CALL p045_data(p_str,p_symbol,l_idj03) RETURNING l_idk11
   END FOREACH
 
   #取幣別小數位
   SELECT azi04 INTO l_azi04 FROM azi_file
    WHERE azi01 = l_idk11 AND aziacti = "Y"
   IF SQLCA.sqlcode THEN
      LET g_msg = cl_getmsg("aic-066",g_lang)
      #LET g_msg = p_fname CLIPPED,": idk11",g_msg CLIPPED  #CHI-C90044
      LET g_msg = p_fname CLIPPED,": idk11 ",l_idk11,g_msg CLIPPED #CHI-C90044
      CALL p045(p_count)
      LET g_success = "N"
      RETURN l_field,l_values
   END IF
 
   #取得idk12"匯率"的值
   LET l_data = ""
   FOREACH p045_3_cs USING "idk12" INTO l_idj03
      IF SQLCA.sqlcode THEN
         CALL cl_err("for:",SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CALL p045_data(p_str,p_symbol,l_idj03) RETURNING l_idk12
   END FOREACH
 
   LET l_idk05f = l_rvb10 * l_rvb87   #CHI-B70039 mod rvb07->rvb87
   IF  cl_null(l_idk05f) THEN LET l_idk05f = 0 END IF
   LET l_idk05f = cl_digcut(l_idk05f,l_azi04)
 
   LET l_idk06f = l_idk05f * l_pmm43 /100
   IF  cl_null(l_idk06f) THEN LET l_idk06f = 0 END IF
   LET l_idk06f = cl_digcut(l_idk06f,l_azi04)
 
   LET l_idk05 = l_idk05f * l_idk12
   IF  cl_null(l_idk05) THEN LET l_idk05 = 0 END IF
   LET l_idk05 = cl_digcut(l_idk05,g_azi04)
 
   LET l_idk06 = ((l_idk05f * l_idk12) * l_pmm43 /100)
   IF  cl_null(l_idk06) THEN LET l_idk06 = 0 END IF
   LET l_idk06 = cl_digcut(l_idk06,g_azi04)
 
   LET l_field = l_field CLIPPED,"idk05,idk05f,idk06,idk06f,"
   LET l_values = l_values CLIPPED,l_idk05,",",l_idk05f,",",l_idk06,",",l_idk06f,","
   RETURN l_field,l_values
 
END FUNCTION
 
#將idk29="N"的資料,insert到rvw_file
FUNCTION p045_ins_rvw()
   DEFINE l_rvw        RECORD LIKE rvw_file.*
   DEFINE l_idk        RECORD LIKE idk_file.*
   DEFINE l_count      LIKE type_file.num5
   DEFINE l_sta        LIKE type_file.chr1
   DEFINE l_msg,l_msg1 STRING   #TQC-C60190 add
 
   BEGIN WORK
   LET g_success = "Y"
 
   LET g_sql = "SELECT * FROM idk_file",
               " WHERE idk29 = 'N'"
 
   PREPARE p045_idk FROM g_sql
   DECLARE p045_idk_cs CURSOR FOR p045_idk
 
   LET l_sta = "Y"
   LET l_count = 1 
   FOREACH p045_idk_cs INTO l_idk.*
      IF SQLCA.sqlcode THEN
         CALL cl_err("foreach idk:",SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      INITIALIZE l_rvw.* TO NULL
 
      LET l_rvw.rvw01  = l_idk.idk01       #發票號碼
      LET l_rvw.rvw02  = l_idk.idk02       #發票日期
      LET l_rvw.rvw03  = l_idk.idk03       #稅別
      LET l_rvw.rvw04  = l_idk.idk04       #稅率
      LET l_rvw.rvw05  = l_idk.idk05       #稅前金額(本幣)
      LET l_rvw.rvw05f = l_idk.idk05f      #稅前金額(原幣)
      LET l_rvw.rvw06  = l_idk.idk06       #稅額(本幣)
      LET l_rvw.rvw06f = l_idk.idk06f      #稅額(原幣)
      LET l_rvw.rvw07  = l_idk.idk07       #發票代碼
      LET l_rvw.rvw08  = l_idk.idk08       #入庫/退貨單號
      LET l_rvw.rvw09  = l_idk.idk09       #項次
      LET l_rvw.rvw10  = l_idk.idk10       #數量
      LET l_rvw.rvw11  = l_idk.idk11       #幣別
      LET l_rvw.rvw12  = l_idk.idk12       #匯率
      LET l_rvw.rvw13  = l_idk.idk13       #no use
      LET l_rvw.rvw14  = l_idk.idk14       #no use
      LET l_rvw.rvw15  = l_idk.idk15       #no use
      LET l_rvw.rvw16  = l_idk.idk16       #no use
      LET l_rvw.rvw17  = l_idk.idk17       #原幣稅前單價
     #LET l_rvw.rvwplant = g_plant         #FUN-980004    #FUN-9B0146
     #LET l_rvw.rvwlegal = g_legal         #FUN-980004    #TQC-C60190 mark
      LET l_rvw.rvw99 = l_idk.idkplant     #來源營運中心  #TQC-C60190 add
      LET l_rvw.rvwlegal = l_idk.idklegal  #所屬法人      #TQC-C60190 add
      LET l_rvw.rvwacti = 'Y'              #有效否        #FUN-D10064 add 
      INSERT INTO rvw_file VALUES(l_rvw.*)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#        IF SQLCA.sqlcode = "-239" THEN #CHI-C30115 mark
         IF cl_sql_dup_value(SQLCA.sqlcode) THEN #CHI-C30115 add
            LET g_msg = cl_getmsg(SQLCA.sqlcode,g_lang)
            LET g_msg = "INSERT rvw_file: Warning! ",g_msg CLIPPED         
            IF l_sta = "Y" THEN           
               SELECT zo02 INTO g_company FROM zo_file WHERE zo01=g_rlang
               SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='aicp045' 
         
               LET l_sta = "N"
            END IF   

            CALL p045_out(l_count,g_msg) 
         ELSE
            LET g_msg = cl_getmsg(SQLCA.sqlcode,g_lang)
            IF  cl_null(g_msg) THEN 
            LET g_msg = cl_getmsg("9052",g_lang)
            END IF
            LET g_msg = "INSERT rvw_file:",g_msg CLIPPED
            IF l_sta = "Y" THEN      
                SELECT zo02 INTO g_company FROM zo_file WHERE zo01=g_rlang
                SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='aicp045' 
                LET l_sta = "N"
            END IF       

            CALL p045_out(l_count,g_msg)   
     
            LET g_success = "N"
            EXIT FOREACH
         END IF
      END IF
     #str TQC-C60190 add
      IF g_str IS NULL THEN
         LET g_str = l_rvw.rvw01 CLIPPED
      ELSE
         LET g_str = g_str CLIPPED,",",l_rvw.rvw01 CLIPPED
      END IF
     #end TQC-C60190 add
 
      UPDATE idk_file SET idk29 = "Y"
       WHERE idk01 = l_idk.idk01
         AND idk08 = l_idk.idk08
        #AND idk09 IS NULL         #TQC-C60190 mark
         AND idk09 = l_idk.idk09   #TQC-C60190 mod
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         LET g_msg = cl_getmsg(SQLCA.sqlcode,g_lang)
         IF cl_null(g_msg) THEN 
            LET g_msg = cl_getmsg("9050",g_lang)
         END IF
         LET g_msg = "UPDATE idk29:",g_msg CLIPPED
  
         IF l_sta = "Y" THEN   
             SELECT zo02 INTO g_company FROM zo_file WHERE zo01=g_rlang
             SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='aicp045' 
            LET l_sta = "N"
         END IF

         CALL p045_out(l_count,g_msg)   
 
         LET g_success = "N"
         EXIT FOREACH
      END IF
 
      UPDATE rvb_file SET rvb22 = l_idk.idk01
      #WHERE rvb01 = l_idk.idk08                                             #TQC-C60190 mark
       WHERE rvb01 IN (SELECT rvu02 FROM rvu_file WHERE rvu01=l_idk.idk08)   #TQC-C60190 mod
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         LET g_msg = cl_getmsg(SQLCA.sqlcode,g_lang)
         IF cl_null(g_msg) THEN 
            LET g_msg = cl_getmsg("9050",g_lang)
         END IF
         LET g_msg = "UPDATE rvb22:",g_msg CLIPPED
       
         IF l_sta = "Y" THEN   
            SELECT zo02 INTO g_company FROM zo_file WHERE zo01=g_rlang
            SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='aicp045' 
            LET l_sta = "N"
         END IF
         
         CALL p045_out(l_count,g_msg)   
 
         LET g_success = "N"
         EXIT FOREACH
      END IF
 
      LET l_count = l_count + 1 
   END FOREACH
 
   IF g_success = "Y" THEN
      COMMIT WORK   
      #非背景執行,顯示執行完成訊息
     #str TQC-C60190 add
      IF cl_null(g_argv1) THEN 
         IF l_count > 1 THEN   #表示有真正寫入rvw_file
            LET l_msg =cl_getmsg('aic-059',g_lang)
            LET l_msg1=cl_getmsg('aap-411',g_lang)
            LET g_msg =l_msg CLIPPED,l_msg1 CLIPPED,":",g_str CLIPPED
            CALL cl_err(g_msg,'!',1)
         ELSE
            CALL cl_err('','axc-034',1)
         END IF
      END IF
     #end TQC-C60190 add
      IF l_sta = "N" THEN 
         CALL cl_prt_cs3('aicp045','aicp045',p_sql,pp_str)
         #變更err report為指定的檔名
         CALL p045_mv('rep',g_name)
      END IF
   ELSE
      ROLLBACK WORK
      CALL p045_mv('rep',g_name)
      CALL cl_err('','aic-060',1)  #CHI-C90044
   END IF
 
END FUNCTION
 
FUNCTION p045_out(s_count,msg)   
   DEFINE s_count  LIKE type_file.num5    
   DEFINE msg      LIKE type_file.chr1000   

   EXECUTE insert_prep USING s_count,g_msg       
            
   LET p_sql="SELECT * FROM ",g_cr_db_str CLIPPED,p_table CLIPPED
     
   IF g_zz05='y' THEN
      CALL cl_wcchp(g_wc,'idi01,idi02,idi03,idi05,idj03,idj04,idj05')
           RETURNING g_wc 
   ELSE
   	 LET g_wc=""   	
   END IF 
     
   LET pp_str=g_wc,";",g_towhom
   CALL cl_prt_cs3('aicp045','aicp045',p_sql,pp_str)	 
END FUNCTION

#str TQC-C60190 add
FUNCTION p045_mkdir()   #建立目錄
    DEFINE l_docdir     STRING
    DEFINE l_file1      STRING
    DEFINE l_file2      STRING
    DEFINE l_file3      STRING
    DEFINE l_file4      STRING
    DEFINE l_file5      STRING
    DEFINE l_cmd        STRING
    DEFINE l_flag       LIKE type_file.num5

    #還沒新增或還沒查詢出資料，不可建立目錄
    IF cl_null(g_idi.idi01) OR cl_null(g_idi.idi02) THEN RETURN END IF

    #詢問"是否要建立發票自動轉入所需的相關目錄?",若不要則離開
    IF NOT cl_confirm('aic-252') THEN RETURN END IF

    #先找到 $TOP/doc/aicp045 這個目錄,此目錄權限要為777,這樣才可以在底下開目錄
    LET l_docdir = os.Path.join(os.Path.join(os.Path.join(FGL_GETENV('TOP'),"doc"),"aic"),"aicp045")
    LET l_file1 = os.Path.join(l_docdir,g_idi.idi01)   #$TOP/doc/aic/aicp045/廠商
    LET l_file2 = os.Path.join(l_file1,g_idi.idi02)    #$TOP/doc/aic/aicp045/廠商/廠別
    LET l_file3 = os.Path.join(l_file2,"upload")       #$TOP/doc/aic/aicp045/廠商/廠別/upload
    LET l_file4 = os.Path.join(l_file2,"trans")        #$TOP/doc/aic/aicp045/廠商/廠別/trans
    LET l_file5 = os.Path.join(l_file2,"error")        #$TOP/doc/aic/aicp045/廠商/廠別/error

    #如果 $TOP/doc/aic/aicp045/廠商 這個目錄不存在,那就要建目錄
    IF NOT os.Path.exists(l_file1) THEN
       CALL os.Path.mkdir(l_file1) RETURNING l_flag   #建立廠商目錄
       IF NOT l_flag THEN   #目錄建不成功,就秀錯誤訊息
          CALL cl_err_msg(NULL,"azz-284",l_file1,20)
          RETURN
       ELSE
          LET l_cmd="chmod 777 ",l_file1
          RUN l_cmd
       END IF
    END IF

    #如果 $TOP/doc/aic/aicp045/廠商/廠別 這個目錄不存在,那就要建目錄
    IF NOT os.Path.exists(l_file2) THEN
       CALL os.Path.mkdir(l_file2) RETURNING l_flag   #建立類別目錄
       IF NOT l_flag THEN   #目錄建不成功,就秀錯誤訊息
          CALL cl_err_msg(NULL,"azz-284",l_file2,20)
          RETURN
       ELSE
          LET l_cmd="chmod 777 ",l_file2
          RUN l_cmd
       END IF
    END IF

    #如果 $TOP/doc/aic/aicp045/廠商/廠別/upload 這個目錄不存在,那就要建目錄
    IF NOT os.Path.exists(l_file3) THEN
       CALL os.Path.mkdir(l_file3) RETURNING l_flag   #建立轉檔檔案放置的目錄
       IF NOT l_flag THEN   #目錄建不成功,就秀錯誤訊息
          CALL cl_err_msg(NULL,"azz-284",l_file3,20)
          RETURN
       ELSE
          LET l_cmd="chmod 777 ",l_file3
          RUN l_cmd
       END IF
    END IF

    #如果 $TOP/doc/aic/aicp045/廠商/廠別/trans 這個目錄不存在,那就要建目錄
    IF NOT os.Path.exists(l_file4) THEN
       CALL os.Path.mkdir(l_file4) RETURNING l_flag   #建立轉檔成功後檔案放置的目錄
       IF NOT l_flag THEN   #目錄建不成功,就秀錯誤訊息
          CALL cl_err_msg(NULL,"azz-284",l_file4,20)
          RETURN
       ELSE
          LET l_cmd="chmod 777 ",l_file4
          RUN l_cmd
       END IF
    END IF

    #如果 $TOP/doc/aic/aicp045/廠商/廠別/error 這個目錄不存在,那就要建目錄
    IF NOT os.Path.exists(l_file5) THEN
       CALL os.Path.mkdir(l_file5) RETURNING l_flag   #建立轉檔失敗後檔案放置的目錄
       IF NOT l_flag THEN   #目錄建不成功,就秀錯誤訊息
          CALL cl_err_msg(NULL,"azz-284",l_file5,20)
          RETURN
       ELSE
          LET l_cmd="chmod 777 ",l_file5
          RUN l_cmd
       END IF
    END IF

END FUNCTION

FUNCTION p045_rmdir()   #刪除目錄
    DEFINE l_file       STRING
    DEFINE l_cmd        STRING

    #詢問"是否要刪除發票自動轉入的相關目錄?",若不要則離開
    IF NOT cl_confirm('aic-253') THEN RETURN END IF

    #找到 $TOP/doc/aic/aicp045/廠商 這個目錄
    LET l_file = os.Path.join(os.Path.join(os.Path.join(os.Path.join(FGL_GETENV('TOP'),"doc"),"aic"),"aicp045"),g_idi.idi01)

    #將目錄與其底下所有東西都刪除
    LET l_cmd="rm -Rf ",l_file
    RUN l_cmd

END FUNCTION

FUNCTION p045_act_visible()   #控制"產生發票自動轉入目錄"ACTION的顯示與否
   DEFINE l_file1       STRING
   DEFINE l_file2       STRING

   IF cl_null(g_idi.idi01) OR cl_null(g_idi.idi02) THEN
      CALL cl_set_act_visible("create_dir",FALSE)
   ELSE
      #找到 $TOP/doc/aic/aicp045/廠商 與 $TOP/doc/aic/aicp045/廠商/廠別 這兩個目錄
      LET l_file1 = os.Path.join(os.Path.join(os.Path.join(os.Path.join(FGL_GETENV('TOP'),"doc"),"aic"),"aicp045"),g_idi.idi01)
      LET l_file2 = os.Path.join(l_file1,g_idi.idi02)
      #如果目錄已存在,那就不顯示"建立自動回貨目錄"的ACTION
      IF os.Path.exists(l_file1) AND os.Path.exists(l_file2) THEN
         CALL cl_set_act_visible("create_dir",FALSE)
      ELSE
         CALL cl_set_act_visible("create_dir",TRUE)
      END IF
   END IF

END FUNCTION
#end TQC-C60190 add

#No.FUN-830083 by hellen 過單
