# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: apmi303.4gl
# Descriptions...: 收貨替代群組維護作業
# Date & Author..: 08/01/11 By jan
# Modify.........: No.FUN-810017 08/03/21 By jan
# Modify.........: No.TQC-8C0075 08/12/30 By clover 複製功能,pnc01&pnc02為key值 ;複製放棄改正常顯示
#                                                   離開按鈕正確出現
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.CHI-950007 09/05/15 By Carrier EXECUTE后接prepare_id,非cursor_id
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-930027 09/09/30 By chenmoyan 復制時給供應商編號開窗
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/22 By chenying 料號開窗控管
# Modify.........: No.TQC-960218 10/11/05 By sabrina _b_fill()單身的料件名稱用單頭的料號去撈，導致撈出來的料件名稱每筆都一樣 
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No.FUN-C30039 12/12/10 By pauline 增加ima021顯示,增加單身批次新增功能
# Modify.........: No.FUN-C30075 13/01/29 By Sakura 修改單頭要可打特性主料，但單身不行
# Modify.........: No:FUN-D30034 13/04/16 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE g_pnc01         LIKE pnc_file.pnc01,   #料號 (假單頭)
       g_pnc02         LIKE pnc_file.pnc02,   #供應商編號
       g_pnc01_t       LIKE pnc_file.pnc01,   #料號(舊值)
       g_pnc02_t       LIKE pnc_file.pnc02,   #供應商編號（舊值）
       g_pnc           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                          pnc03             LIKE pnc_file.pnc03, #可替代料號
                          pnc03_ima02       LIKE ima_file.ima02, #料件編號
                          pnc03_ima021      LIKE ima_file.ima021,#規格     #FUN-C30039 add
                          pnc04             LIKE pnc_file.pnc04, #生效日期 
                          pnc05             LIKE pnc_file.pnc05  #失效日期
                       END RECORD,
       g_pnc_t         RECORD                 #程式變數 (舊值)
                          pnc03             LIKE pnc_file.pnc03, #可替代料號
                          pnc03_ima02       LIKE ima_file.ima02, #料件編號
                          pnc03_ima021      LIKE ima_file.ima021,#規格     #FUN-C30039 add
                          pnc04             LIKE pnc_file.pnc04, #生效日期 
                          pnc05             LIKE pnc_file.pnc05  #失效日期
                       END RECORD,
 
       g_wc,g_sql,g_sql1      STRING,      
       g_rec_b         LIKE type_file.num5,                #單身筆數  
       l_sql           STRING,
       l_ac            LIKE type_file.num5                #目前處理的ARRAY CNT  
DEFINE p_row,p_col     LIKE type_file.num5    
DEFINE g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_cnt           LIKE type_file.num10   
DEFINE g_msg           LIKE ze_file.ze03      
DEFINE g_row_count     LIKE type_file.num10   
DEFINE g_curs_index    LIKE type_file.num10   
DEFINE g_jump          LIKE type_file.num10   
DEFINE g_no_ask        LIKE type_file.num5    
 
MAIN
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_pnc01= NULL                     #清除鍵值
   LET g_pnc01_t = NULL
   LET g_pnc02_t = NULL
 
   OPEN WINDOW i303_w WITH FORM "apm/42f/apmi303"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   CALL i303_menu()
   CLOSE WINDOW i303_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
FUNCTION i303_curs()
 
   CLEAR FORM                             #清除畫面
   CALL g_pnc.clear()
 
      CONSTRUCT g_wc ON pnc01,pnc02,pnc03,pnc04,pnc05
                   FROM pnc01,pnc02,s_pnc[1].pnc03,s_pnc[1].pnc04,s_pnc[1].pnc05
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pnc01)     #供應商編號
#FUN-AA0059---------mod------------str------------------               
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state ="c"
#                  LET g_qryparam.form ="q_pnc01"
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL  q_sel_ima(TRUE, "q_pnc01","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end------------------
                  DISPLAY g_qryparam.multiret TO pnc01
                  NEXT FIELD pnc01
               WHEN INFIELD(pnc02)     #供應商編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state ="c"
                  LET g_qryparam.form ="q_pnc02"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pnc02
                  NEXT FIELD pnc02
               WHEN INFIELD(pnc03)     #供應商編號
#FUN-AA0059---------mod------------str-----------------
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state ="c"
#                  LET g_qryparam.form ="q_pnc03"
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                   CALL  q_sel_ima(TRUE, "q_pnc03","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end------------------                   
                  DISPLAY g_qryparam.multiret TO pnc03
                  NEXT FIELD pnc03
                OTHERWISE EXIT CASE
            END CASE
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
      IF INT_FLAG THEN RETURN END IF
 
   LET g_sql= "SELECT UNIQUE pnc01,pnc02 FROM pnc_file ",
              " WHERE ", g_wc CLIPPED,
              " ORDER BY pnc01"
   PREPARE i303_prepare FROM g_sql      #預備一下
   DECLARE i303_b_curs                  #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR i303_prepare
 
   LET g_sql1="SELECT UNIQUE pnc01,pnc02 FROM pnc_file WHERE ",g_wc CLIPPED, "INTO TEMP x "
   DROP TABLE x
   PREPARE i303_precount_x FROM g_sql1
   EXECUTE i303_precount_x
   LET g_sql="SELECT COUNT(*) FROM x"
   PREPARE i303_precount FROM g_sql
   DECLARE i303_count CURSOR FOR i303_precount
 
END FUNCTION
 
FUNCTION i303_menu()
 
   WHILE TRUE
      CALL i303_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i303_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i303_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i303_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i303_u()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i303_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i303_b()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pnc),'','')
            END IF
 
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                IF g_pnc01 IS NOT NULL THEN
                 LET g_doc.column1 = "pnc01"
                 LET g_doc.value1 = g_pnc01
                 CALL cl_doc()
                END IF 
              END IF
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i303_a()
 
   MESSAGE ""
   CLEAR FORM
   LET g_pnc01=''
   LET g_pnc02=''
   CALL g_pnc.clear()
   INITIALIZE g_pnc01 LIKE pnc_file.pnc01
   INITIALIZE g_pnc02 LIKE pnc_file.pnc02
   LET g_pnc01_t = NULL
   LET g_pnc02_t = NULL
   #預設值及將數值類變數清成零
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL i303_i("a")                #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         LET g_pnc01=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
         CALL g_pnc.clear()
 
      LET g_rec_b=0   
      DISPLAY g_rec_b TO FORMONLY.cn2
      CALL i303_b()                   #輸入單身
 
      LET g_pnc01_t = g_pnc01            #保留舊值
      LET g_pnc02_t = g_pnc02
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i303_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_pnc01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    MESSAGE " "
    CALL cl_opmsg('u')
    LET g_pnc01_t = g_pnc01
    LET g_pnc02_t = g_pnc02
    WHILE TRUE
        CALL i303_i("u")       #欄位更改
        IF INT_FLAG THEN
           LET g_pnc01 = g_pnc01_t
           DISPLAY g_pnc01 TO pnc01
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           EXIT WHILE
        END IF
        UPDATE pnc_file SET pnc01 = g_pnc01,
                            pnc02 = g_pnc02
         WHERE pnc01 = g_pnc01_t
           AND pnc02 = g_pnc02_t
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_pnc01,SQLCA.sqlcode,0)
            CONTINUE WHILE
         END IF
        EXIT WHILE
    END WHILE
END FUNCTION
  
FUNCTION i303_i(p_cmd)
DEFINE p_cmd           LIKE type_file.chr1,                  #a:輸入 u:更改  
       l_n             LIKE type_file.num5,                  #檢查重復用
       l_n1            LIKE type_file.num5                   #檢查重復用
       
 
   CALL cl_set_head_visible("","YES")           
   INPUT g_pnc01,g_pnc02 WITHOUT DEFAULTS FROM pnc01,pnc02
 
      AFTER FIELD pnc01                      
         IF NOT cl_null(g_pnc01) THEN
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_pnc01,"") THEN
             CALL cl_err('',g_errno,1)
             LET g_pnc01= g_pnc01_t
             NEXT FIELD pnc01
            END IF
#FUN-AA0059 ---------------------end-------------------------------
            CALL i303_pnc01('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_pnc01,g_errno,0)
               NEXT FIELD pnc01
            END IF
            SELECT count(*) INTO l_n FROM ima_file
             WHERE ima01 = g_pnc01
               AND imaacti = 'Y'
            IF l_n = 0 THEN
               CALL cl_err(g_pnc01,'asfi115',0)
               NEXT FIELD pnc01
            END IF
            IF g_pnc01 != g_pnc01_t THEN 
               DECLARE pnc_cs1 CURSOR FOR
                 SELECT pnc03 FROM pnc_file
                  WHERE pnc01 = g_pnc01_t
                    AND pnc02 = g_pnc02_t
               FOREACH pnc_cs1 INTO g_pnc[l_ac].pnc03
                 IF g_pnc[l_ac].pnc03 = g_pnc01 THEN
                    CALL cl_err('','apm-526',0)
                    NEXT FIELD pnc01
                 END IF
                 LET l_ac=l_ac+1
               END FOREACH
            END IF
         END IF
 
     AFTER FIELD pnc02
      IF NOT cl_null(g_pnc02) THEN
         CALL i303_pnc02('a')
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_pnc02,g_errno,0)
            NEXT FIELD pnc02
         END IF
        IF g_pnc02 != '*' THEN
           SELECT count(*) INTO l_n1 FROM pmc_file
            WHERE pmc01 = g_pnc02
              AND pmcacti = 'Y'
              AND pmc05 != '2'
              AND (pmc30 like '%1%' OR
                   pmc30 like '%3%')
            IF l_n1 = 0 THEN
               CALL cl_err('','asfi115',0)
               NEXT FIELD pnc02
            END IF
        END IF
      END IF
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pnc01)     #料號
#FUN-AA0059---------mod------------str-----------------            
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_pnc01"
#               LET g_qryparam.default1 = g_pnc01
#               CALL cl_create_qry() RETURNING g_pnc01
               CALL q_sel_ima(FALSE, "q_pnc01", "",g_pnc01,"","","","","",'' ) RETURNING g_pnc01
#FUN-AA0059---------mod------------end-----------------
               DISPLAY  g_pnc01 TO pnc01
               NEXT FIELD pnc01
            WHEN INFIELD(pnc02)     #供應商編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_pnc02"
               LET g_qryparam.default1 = g_pnc02
               CALL cl_create_qry() RETURNING g_pnc02
               DISPLAY g_pnc02 TO pnc02
               NEXT FIELD pnc02
            OTHERWISE EXIT CASE
         END CASE
 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   END INPUT
 
END FUNCTION
 
FUNCTION i303_pnc01(p_cmd)
DEFINE p_cmd           LIKE type_file.chr1,    
       l_ima02         LIKE ima_file.ima02,
       l_imaacti       LIKE ima_file.imaacti,         #資料有效碼
       l_ima021        LIKE ima_file.ima021           #FUN-C30039 add  #規格  

   LET g_errno = ' '
   SELECT ima02,imaacti,ima021           #FUN-C30039 add ima021
     INTO l_ima02,l_imaacti,l_ima021     #FUN-C30039 add ima021
     FROM ima_file
    WHERE ima01 = g_pnc01
 
   CASE WHEN SQLCA.SQLCODE=100
             LET g_errno = 'mfg3015'
             LET l_ima02   =  NULL
        WHEN l_imaacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_ima02 TO FORMONLY.pnc01_ima02
      DISPLAY l_ima021 TO FORMONLY.pnc01_ima021     #FUN-C30039 add
   END IF
 
END FUNCTION
 
FUNCTION i303_pnc02(p_cmd)
DEFINE p_cmd           LIKE type_file.chr1,    
       l_pmc03         LIKE pmc_file.pmc03,
       l_pmcacti       LIKE pmc_file.pmcacti,          #資料有效碼
       l_ze03          LIKE ze_file.ze03
 
   SELECT ze03 INTO l_ze03 FROM ze_file
    WHERE ze01='apm-527'
      AND ze02=g_lang
 
   IF g_pnc02 = '*' THEN
      LET l_pmc03 = l_ze03
   ELSE
      LET g_errno = ' '
      SELECT pmc03,pmcacti
        INTO l_pmc03,l_pmcacti
        FROM pmc_file
       WHERE pmc01 = g_pnc02
 
      CASE WHEN SQLCA.SQLCODE=100
             LET g_errno = 'mfg3004'
             LET l_pmc03 =  NULL
        WHEN l_pmcacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.sqlcode USING '-------'
      END CASE
   END IF
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_pmc03 TO FORMONLY.pnc02_pmc03
   END IF
 
END FUNCTION
 
FUNCTION i303_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
 
   MESSAGE ""
   CALL cl_opmsg('q')
 
   CALL i303_curs()                    #取得查詢條件
 
   IF INT_FLAG THEN                       #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_pnc01 TO NULL
      RETURN
   END IF
 
   OPEN i303_b_curs                    #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                         #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_pnc01 TO NULL
   ELSE
      OPEN i303_count
      FETCH i303_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i303_fetch('F')            #讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION i303_fetch(p_flag)
DEFINE p_flag          LIKE type_file.chr1                  #處理方式  
 
   MESSAGE ""
   CASE p_flag
       WHEN 'N' FETCH NEXT     i303_b_curs INTO g_pnc01,g_pnc02
       WHEN 'P' FETCH PREVIOUS i303_b_curs INTO g_pnc01,g_pnc02
       WHEN 'F' FETCH FIRST    i303_b_curs INTO g_pnc01,g_pnc02
       WHEN 'L' FETCH LAST     i303_b_curs INTO g_pnc01,g_pnc02
       WHEN '/'
           IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
#                    CONTINUE PROMPT
 
                  ON ACTION about         #MOD-4C0121
                     CALL cl_about()      #MOD-4C0121
 
                  ON ACTION help          #MOD-4C0121
                     CALL cl_show_help()  #MOD-4C0121
 
                  ON ACTION controlg      #MOD-4C0121
                     CALL cl_cmdask()     #MOD-4C0121
 
               END PROMPT
               IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
           END IF
           FETCH ABSOLUTE g_jump i303_b_curs INTO g_pnc01,g_pnc02
           LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_pnc01,SQLCA.sqlcode,0)
      INITIALIZE g_pnc01 TO NULL
   ELSE
      CALL i303_show()
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
END FUNCTION
 
FUNCTION i303_show()
 
   DISPLAY g_pnc01 TO pnc01               #單頭
   DISPLAY g_pnc02 TO pnc02
 
   CALL i303_pnc01('d')                 
   CALL i303_pnc02('d')
   CALL i303_b_fill(g_wc)                 #單身
 
   CALL cl_show_fld_cont()                   
 
END FUNCTION
 
FUNCTION i303_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_pnc01 IS NULL THEN
      CALL cl_err("",-400,0)                 
      RETURN
   END IF
 
   BEGIN WORK
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "pnc01"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_pnc01       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM pnc_file WHERE pnc01 = g_pnc01
                             AND pnc02 = g_pnc02
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","pnc_file","","",SQLCA.sqlcode,"","BODY DELETE:",1)  
      ELSE
         CLEAR FORM
         CALL g_pnc.clear()
         OPEN i303_count
         #FUN-B50063-add-start--
         IF STATUS THEN
            CLOSE i303_b_curs
            CLOSE i303_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end-- 
           FETCH i303_count INTO g_row_count
         #FUN-B50063-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i303_b_curs
            CLOSE i303_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i303_b_curs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i303_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL i303_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i303_b()
DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  
       l_n             LIKE type_file.num5,                #檢查重複用  
       l_n1            LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,                #單身鎖住否  
       p_cmd           LIKE type_file.chr1,                #處理狀態  
       l_cmd           LIKE type_file.chr1000,             #可新增否  
       l_allow_insert  LIKE type_file.num5,                #可新增否  
       l_allow_delete  LIKE type_file.num5                 #可刪除否  
DEFINE l_flag          LIKE type_file.chr1                 #FUN-C30039 add   #判斷是否開窗多選,重新進入_b()
DEFINE l_ima928        LIKE ima_file.ima928                #FUN-C30075 add 
 

   LET g_action_choice = ""

   LET l_flag = 'N'  #FUN-C30039 add
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_pnc01 IS NULL THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT pnc03,' ','',pnc04,pnc05",    #FUN-C30039 add  ' ' 
                      "  FROM pnc_file",
                      " WHERE pnc01 = ? AND pnc02 = ? AND pnc03 = ? AND pnc04 = ? ",
                      " FOR UPDATE"  
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i303_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_pnc WITHOUT DEFAULTS FROM s_pnc.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         LET g_rec_b  = ARR_COUNT()
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_pnc_t.* = g_pnc[l_ac].*  #BACKUP
            LET l_sql = "SELECT pnc01,pnc02,pnc03,pnc04 FROM pnc_file",
                        " WHERE pnc01 = '",g_pnc01,"' ",
                        "   AND pnc02 = '",g_pnc02,"' ",
                        "   AND pnc03 = '",g_pnc_t.pnc03,"' ",
                        "   AND pnc04 = '",g_pnc_t.pnc04,"' "
            #No.CHI-950007  --Begin
            PREPARE i303_prepare_r FROM l_sql
          # DECLARE pnc_cs_r CURSOR FOR i303_prepare_r
          # EXECUTE pnc_cs_r INTO g_pnc01,g_pnc02,g_pnc[l_ac].pnc03,g_pnc[l_ac].pnc04
            EXECUTE i303_prepare_r INTO g_pnc01,g_pnc02,g_pnc[l_ac].pnc03,g_pnc[l_ac].pnc04
            #No.CHI-950007  --End  
            OPEN i303_bcl USING g_pnc01,g_pnc02,g_pnc[l_ac].pnc03,g_pnc[l_ac].pnc04
            IF STATUS THEN
               CALL cl_err("OPEN i303_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i303_bcl INTO g_pnc[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_pnc02_t,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               SELECT ima02,ima021                #FUN-C30039 add ima021
                 INTO g_pnc[l_ac].pnc03_ima02,
                      g_pnc[l_ac].pnc03_ima021    #FUN-C30039 add 
                 FROM ima_file
               #WHERE ima01=g_pnc01                #FUN-C30039 mark 
                WHERE ima01 = g_pnc[l_ac].pnc03    #FUN-C30039 add
            END IF
            CALL cl_show_fld_cont()     
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_pnc[l_ac].* TO NULL      
         LET g_pnc[l_ac].pnc04 = g_today
         LET g_pnc_t.* = g_pnc[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD pnc03
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         INSERT INTO pnc_file(pnc01,pnc02,pnc03,pnc04,pnc05)
                       VALUES(g_pnc01,g_pnc02,g_pnc[l_ac].pnc03,
                              g_pnc[l_ac].pnc04,g_pnc[l_ac].pnc05)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","pnc_file","","",SQLCA.sqlcode,"","",1)  
            CANCEL INSERT
            ROLLBACK WORK
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      AFTER FIELD pnc03
         IF NOT cl_null(g_pnc[l_ac].pnc03) THEN
#FUN-C30075---add---START
            SELECT ima928 INTO l_ima928 FROM ima_file WHERE ima01 = g_pnc[l_ac].pnc03
            IF l_ima928='Y' THEN
               CALL cl_err('','ima-001',0)
               NEXT FIELD pnc03
            END IF
#FUN-C30075---add-----END
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_pnc[l_ac].pnc03,"") THEN
             CALL cl_err('',g_errno,1)
             LET g_pnc[l_ac].pnc03= g_pnc_t.pnc03
             NEXT FIELD pnc03
            END IF
#FUN-AA0059 ---------------------end-------------------------------
          IF (g_pnc[l_ac].pnc03 != g_pnc_t.pnc03) OR
             cl_null(g_pnc_t.pnc03) THEN
           IF NOT cl_null(g_pnc[l_ac].pnc04) THEN
              LET l_n1 = 0
              SELECT count(*) INTO l_n1
                FROM pnc_file
               WHERE pnc01=g_pnc01
                 AND pnc02=g_pnc02
                 AND pnc03=g_pnc[l_ac].pnc03
                 AND pnc04=g_pnc[l_ac].pnc04
              IF l_n1 > 0 THEN
                 CALL cl_err('',-239,1)
                 NEXT FIELD pnc03
              END IF
           END IF
            IF g_pnc[l_ac].pnc03 = g_pnc01 THEN
               CALL cl_err('','apm-525',0)
               NEXT FIELD pnc03
            END IF
            CALL i303_pnc03('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_pnc[l_ac].pnc03,g_errno,0)
               NEXT FIELD pnc03
            END IF
            SELECT count(*) INTO l_n FROM ima_file
             WHERE ima01 = g_pnc[l_ac].pnc03
               AND ima151 != 'Y'
               AND imaacti = 'Y'
            IF l_n = 0 THEN
               CALL cl_err('','asfi115',0)
               NEXT FIELD pnc03
            END IF
           END IF
         END IF
 
      AFTER FIELD pnc04
         IF NOT cl_null(g_pnc[l_ac].pnc04) THEN
          IF (g_pnc[l_ac].pnc04 != g_pnc_t.pnc04) OR
             cl_null(g_pnc_t.pnc04) THEN
           IF NOT cl_null(g_pnc[l_ac].pnc03) THEN
              LET l_n1 = 0
              SELECT count(*) INTO l_n1
                FROM pnc_file
               WHERE pnc01=g_pnc01
                 AND pnc02=g_pnc02
                 AND pnc03=g_pnc[l_ac].pnc03
                 AND pnc04=g_pnc[l_ac].pnc04
              IF l_n1 > 0 THEN
                 CALL cl_err('',-239,1)
                 NEXT FIELD pnc04
              END IF
           END IF
           IF NOT cl_null(g_pnc[l_ac].pnc05) THEN
            IF g_pnc[l_ac].pnc04 > g_pnc[l_ac].pnc05 THEN
               CALL cl_err('',-9913,0)
               NEXT FIELD pnc04
            END IF
           END IF
          END IF
         END IF
 
      AFTER FIELD pnc05
         IF NOT cl_null(g_pnc[l_ac].pnc04) AND
            NOT cl_null(g_pnc[l_ac].pnc05) THEN
            IF g_pnc[l_ac].pnc04 > g_pnc[l_ac].pnc05 THEN
               CALL cl_err('',-9913,0)
               NEXT FIELD pnc05
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_pnc_t.pnc03) THEN
            IF NOT cl_delb(0,0) THEN
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM pnc_file
             WHERE pnc01 = g_pnc01 AND pnc02 = g_pnc02 AND pnc03 = g_pnc_t.pnc03 AND pnc04 = g_pnc_t.pnc04
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","pnc_file","","",SQLCA.sqlcode,"","",1)  
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_pnc[l_ac].* = g_pnc_t.*
            CLOSE i303_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_pnc[l_ac].pnc03,-263,1)
            LET g_pnc[l_ac].* = g_pnc_t.*
         ELSE
            UPDATE pnc_file SET pnc03=g_pnc[l_ac].pnc03,
                                pnc04=g_pnc[l_ac].pnc04,
             pnc05=g_pnc[l_ac].pnc05
       WHERE pnc01 = g_pnc01
         AND pnc02 = g_pnc02
         AND pnc03 = g_pnc_t.pnc03
         AND pnc04 = g_pnc_t.pnc04
       IF SQLCA.sqlcode THEN
          CALL cl_err3("upd","pnc_file","","",SQLCA.sqlcode,"","",1)
               LET g_pnc[l_ac].* = g_pnc_t.*
               ROLLBACK WORK
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
#        LET l_ac_t = l_ac        #FUN-D30034 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_pnc[l_ac].* = g_pnc_t.*
            #FUN-D30034---add---str---
            ELSE
               CALL g_pnc.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034---add---end---
            END IF
            CLOSE i303_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac        #FUN-D30034 add
         CLOSE i303_bcl
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pnc03)
#FUN-AA0059---------mod------------str-----------------
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_pnc03"
#               LET g_qryparam.default1 = g_pnc[l_ac].pnc03
#               CALL cl_create_qry() RETURNING g_pnc[l_ac].pnc03
                CALL q_sel_ima(FALSE, "q_pnc03","",g_pnc[l_ac].pnc03,"","","","","",'' ) 
                  RETURNING g_pnc[l_ac].pnc03
#FUN-AA0059---------mod------------end-----------------
               DISPLAY BY NAME g_pnc[l_ac].pnc03           
               NEXT FIELD pnc03
            OTHERWISE EXIT CASE
         END CASE
 
 
     #FUN-C30039 add START
      ON ACTION batch_ins_pnc
         CALL i303_ins_pnc()
         LET l_flag = 'Y'
         EXIT INPUT
     #FUN-C30039 add END


      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(pnc02) AND l_ac > 1 THEN
            LET g_pnc[l_ac].* = g_pnc[l_ac-1].*
            NEXT FIELD pnc02
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
    
 
   END INPUT
 
   CLOSE i303_bcl
   COMMIT WORK

  #FUN-C30039 add START
   CALL i303_b_fill(" 1=1")   

   IF l_flag = 'Y' THEN
      CALL i303_b()
   END IF
  #FUN-C30039 add END 
 
END FUNCTION
 
FUNCTION i303_pnc03(p_cmd)  
   DEFINE p_cmd        LIKE type_file.chr1,    
          l_ima02      LIKE ima_file.ima02,
          l_imaacti    LIKE ima_file.imaacti,
          l_ima021     LIKE ima_file.ima021   #FUN-C30039 add  #規格
 
   SELECT ima02,imaacti,ima021        #FUN-C30039 add ima021  
     INTO l_ima02,l_imaacti,l_ima021  #FUN-C30039 add ima021
     FROM ima_file
   #WHERE ima01 = g_pnc01              #FUN-C30039 mark
    WHERE ima01 = g_pnc[l_ac].pnc03    #FUN-C30039 add
 
   CASE WHEN SQLCA.SQLCODE=100
             LET g_errno = 'mfg3015'
             LET  l_ima02 = NULL
        WHEN l_imaacti='N' LET g_errno = '9028'
        WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038'  
        OTHERWISE          LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_pnc[l_ac].pnc03_ima02 = l_ima02
      LET g_pnc[l_ac].pnc03_ima021 = l_ima021   #FUN-C30039 add
   END IF
 
END FUNCTION
 
FUNCTION i303_b_askkey()
DEFINE
   #l_wc            LIKE type_file.chr1000 
   l_wc             STRING           #NO.FUN-910082
      
   CONSTRUCT l_wc ON pnc03,pnc04,pnc05
                FROM s_pnc[1].pnc03,s_pnc[1].pnc04,s_pnc[1].pnc05
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
 
   IF INT_FLAG THEN RETURN END IF
 
   CALL i303_b_fill(l_wc)
 
END FUNCTION
 
FUNCTION i303_b_fill(p_wc)              #BODY FILL UP
 
DEFINE p_wc            LIKE type_file.chr1000 #No.FUN-680136
 
   LET g_sql = " SELECT pnc03,'','',pnc04,pnc05 FROM pnc_file ",   #FUN-C30039 add '' 
               " WHERE pnc01 = '",g_pnc01,"'",
               "   AND pnc02 = '",g_pnc02,"'",
               "   AND ",p_wc CLIPPED,
               " ORDER BY 1"
   PREPARE i303_prepare2 FROM g_sql      #預備一下
   DECLARE pnc_curs CURSOR FOR i303_prepare2
 
   CALL g_pnc.clear()
   LET g_cnt = 1
 
   FOREACH pnc_curs INTO g_pnc[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT ima02 ,ima021                   #FUN-C30039 add ima021
         INTO g_pnc[g_cnt].pnc03_ima02 ,
              g_pnc[g_cnt].pnc03_ima021      #FUN-C30039 add
       FROM ima_file
           
      #WHERE ima01 = g_pnc01                 #TQC-960218 mark
       WHERE ima01 = g_pnc[g_cnt].pnc03      #TQC-960218 add
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_pnc.deleteElement(g_cnt)
 
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i303_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pnc TO s_pnc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
         CALL i303_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i303_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i303_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i303_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i303_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
             LET INT_FLAG=FALSE                 #MOD-570244 mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
      ON ACTION related_document                #相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
     #TQC-8C0075 --add
     ON ACTION exit                       
         LET g_action_choice="exit"
         EXIT DISPLAY
     #TQC-8C0075
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i303_copy()
DEFINE l_newno,l_oldno1  LIKE pnc_file.pnc01,
       l_n               LIKE type_file.num5,   
       l_n1              LIKE type_file.num5,    
       l_ima02           LIKE ima_file.ima02,
       l_ima021          LIKE ima_file.ima021, 
       l_newno2,l_oldno2 LIKE pnc_file.pnc02    #TQC-8C0075
 
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_pnc01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_pnc01_t = g_pnc01
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   #INPUT l_newno FROM pnc01 
   INPUT l_newno,l_newno2 FROM pnc01,pnc02      #TQC-8C0075
  
      AFTER FIELD pnc01
         IF NOT cl_null(l_newno) THEN
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(l_newno,"") THEN
             CALL cl_err('',g_errno,1)
             NEXT FIELD pnc01
            END IF
#FUN-AA0059 ---------------------end-------------------------------
            LET l_n = 0
            SELECT count(*) INTO l_n FROM ima_file WHERE ima01 = l_newno
            IF l_n = 0 THEN
               CALL cl_err(l_newno,'mfg3015',0)
               NEXT FIELD pnc01
            END IF
            LET l_n = 0
            #SELECT count(*) INTO l_n FROM pnc_file WHERE pnc01 = l_newno   #TQC-8C0075
            #IF l_n > 0 THEN
            #   CALL cl_err('',-239,0)
            #   NEXT FIELD pnc01
            #END IF
            SELECT COUNT(*) INTO l_n1 FROM pnc_file
             WHERE pnc01 = g_pnc01_t
               AND pnc03 = l_newno
            IF l_n1 > 0 THEN
               CALL cl_err('','apm-526',0)
               NEXT FIELD pnc01
            END IF
         END IF
      #TQC-8C0075 -add-start
      AFTER FIELD pnc02
         IF NOT cl_null(l_newno2) THEN
            SELECT count(*) INTO l_n FROM pnc_file
                 WHERE pnc01=l_newno AND  pnc02=l_newno2
            IF l_n > 0 THEN
               LET g_msg = l_newno CLIPPED,'+',l_newno2 CLIPPED
               CALL cl_err(g_msg,-239,0)
               NEXT FIELD pnc02
             END IF
          END IF
      #TQC-8C0075 -add -end
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pnc01)                  
#FUN-AA0059---------mod------------str-----------------
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_pnc01"
#               LET g_qryparam.default1 = l_newno
#               CALL cl_create_qry() RETURNING l_newno
                CALL q_sel_ima(FALSE, "q_pnc01","",l_newno,"","","","","",'' ) RETURNING l_newno
#FUN-AA0059---------mod------------str-----------------
               DISPLAY l_newno TO pnc01
               NEXT FIELD pnc01
#No.FUN-930027 --Begin
            WHEN INFIELD(pnc02)     #供應商編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_pnc02"
               LET g_qryparam.default1 = l_newno2
               CALL cl_create_qry() RETURNING l_newno2
               DISPLAY l_newno2 TO pnc02
               NEXT FIELD pnc02
#No.FUN-930027 --End
            OTHERWISE EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      #DISPLAY BY NAME g_pnc01
      DISPLAY  g_pnc01 TO pnc01    #TQC-8C0075
      DISPLAY  g_pnc02 TO pnc02    #TQC-8C0075
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM pnc_file WHERE pnc01 = g_pnc01
                            AND pnc02 = g_pnc02    
                           INTO TEMP x
 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","pnc_file","","",SQLCA.sqlcode,"","",1)  
      RETURN
   END IF
 
   UPDATE x SET pnc01 = l_newno,
                pnc02 = l_newno2    #TQC-8C0075
 
   INSERT INTO pnc_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","pnc_file","","",SQLCA.sqlcode,"","",1)  
      RETURN
   END IF
 
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno1= g_pnc01
   LET g_pnc01=l_newno
   LET l_oldno2= g_pnc02   #TQC-8C0075
   LET g_pnc02=l_newno2    #TQC-8C0075
   #CALL i303_u()          #TQC-8C0075
   CALL i303_b()
   #LET g_pnc01=l_oldno1   #FUN-C80046 
   #LET g_pnc02=l_oldno2   #TQC-8C0075  #FUN-C80046 
 
   #CALL i303_show()       #FUN-C80046 
 
END FUNCTION
#No.FUN-810017

#FUN-C30039 add START
FUNCTION i303_ins_pnc()
DEFINE l_tok base.StringTokenizer
DEFINE l_pnc03      LIKE pnc_file.pnc03
DEFINE l_n          LIKE type_file.num5
DEFINE l_pnc        RECORD LIKE pnc_file.*

   LET l_pnc.pnc01 = g_pnc01
   LET l_pnc.pnc02 = g_pnc02
   LET l_pnc.pnc04 = g_today
   LET l_pnc.pnc05 = NULL
   IF cl_null(l_pnc.pnc01) OR cl_null(l_pnc.pnc02) THEN
      RETURN
   END IF
   CALL  q_sel_ima(TRUE, "q_pnc03","","","","","","","",'')  RETURNING  g_qryparam.multiret

   IF NOT cl_null(g_qryparam.multiret) THEN

      LET l_tok = base.StringTokenizer.create(g_qryparam.multiret,"|")
      WHILE l_tok.hasMoreTokens()
         LET l_pnc03 = l_tok.nextToken()
         SELECT COUNT(*) INTO l_n FROM pnc_file
           WHERE pnc01 = g_pnc01
             AND pnc02 = g_pnc02
             AND pnc03 = l_pnc03
         IF l_n = 0 THEN
            LET l_pnc.pnc03 = l_pnc03
            INSERT INTO pnc_file VALUES(l_pnc.*)
         END IF
      END WHILE
      CALL i303_b_fill(" 1=1")

   END IF
END FUNCTION

#FUN-C30039 add END

 
