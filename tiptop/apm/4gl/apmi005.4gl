# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: apmi005.4gl
# Descriptions...: 供應商價格/交期/品質給分標準
# Date & Author..: FUN-720041 07/03/02 by Yiting
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify ........: NO.TQC-740056 07/04/18 by Yiting i005_copy
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-790095 07/09/14 By lumxa 打印功能無效，如無需打印功能請把該按鈕灰掉
# Modify.........: No.TQC-860019 08/06/09 By cliare ON IDLE 控制調整
# Modify.........: No.TQC-8C0076 09/01/09 By clover mark #ATTRIBUTE(YELLOW)
# Modify.........: No.TQC-970146 09/07/17 By lilingyu "差異比率以下"欄位對負數沒有控管
# Modify.........: No.TQC-970149 09/07/17 By lilingyu "分數"欄位對負數沒有控管
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:TQC-960198 10/11/05 By sabrina DISPLAY BY NAME g_ppb01寫法有誤，畫面檔沒有g_ppb01 
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30034 13/04/16 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_ppb01         LIKE ppb_file.ppb01,      #流程代碼 (假單頭)  #FUN-720041
    g_ppb01_t       LIKE ppb_file.ppb01,      #流程代碼   (舊值)
    g_ppa03         LIKE ppa_file.ppa03, 
    l_cnt           LIKE type_file.num5,      #No.FUN-680136 SMALLINT
    l_cnt1          LIKE type_file.num5,      #No.FUN-680136 SMALLINT
    l_cmd           LIKE type_file.chr1000,   #No.FUN-680136 VARCHAR(100)
    g_ppb           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
                    ppb02   LIKE ppb_file.ppb02,
                    ppb03   LIKE ppb_file.ppb03                   
                    END RECORD,
    g_ppb_t         RECORD                    #程式變數 (舊值)
                    ppb02   LIKE ppb_file.ppb02,
                    ppb03   LIKE ppb_file.ppb03                   
                    END RECORD,
    g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_delete        LIKE type_file.chr1,   #若刪除資料,則要重新顯示筆數  #No.FUN-680136
    g_rec_b         LIKE type_file.num5,   #單身筆數        #No.FUN-680136 SMALLINT
    l_za05          LIKE type_file.chr1000,#No.FUN-680136 VARCHAR(40)
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT  #No.FUN-680136 SMALLINT
    l_sl            LIKE type_file.num5    #No.FUN-680136 SMALLINT #目前處理的ARRAY CNT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_sql_tmp    STRING   #No.TQC-720019
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680136 SMALLINT
DEFINE   g_cnt            LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_i              LIKE type_file.num5          #count/index for any purpose    #No.FUN-680136 SMALLINT
DEFINE   g_msg            LIKE ze_file.ze03            #No.FUN-680136 VARCHAR(72)
DEFINE   g_row_count      LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_curs_index     LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_jump           LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   mi_no_ask        LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
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
 
   LET g_ppb01   = NULL                   #清除鍵值
   LET g_ppb01_t = NULL
 
   OPEN WINDOW i005_w WITH FORM "apm/42f/apmi005"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
   CALL i005_menu()
   CLOSE WINDOW i005_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i005_cs()
 
   CLEAR FORM                             #清除畫面
   CALL g_ppb.clear()
 
   INITIALIZE g_ppb01 TO NULL    #No.FUN-750051
   CONSTRUCT g_wc ON ppb01,ppb02,ppb03   #螢幕上取條件
           FROM ppb01,
                s_ppb[1].ppb02,s_ppb[1].ppb03
       #--No.MOD-4A0248--------
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
 
      ON ACTION CONTROLP
         CASE 
             WHEN INFIELD(ppb01)  
                   CALL cl_init_qry_var()
                   LET g_qryparam.state= "c"
                   LET g_qryparam.form = "q_ppa"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ppb01
                   NEXT FIELD ppb01
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
 
   
      #No.FUN-580031 --start--     HCN
       ON ACTION qbe_select
         CALL cl_qbe_select() 
       ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 --end--       HCN
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   IF INT_FLAG THEN RETURN END IF
 
   LET g_sql="SELECT UNIQUE ppb01 ",
              " FROM ppb_file ", # 組合出 SQL 指令
              " WHERE ", g_wc CLIPPED,
              " ORDER BY ppb01"
   PREPARE i005_prepare FROM g_sql      #預備一下
   DECLARE i005_bcs                  #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR i005_prepare
 
   LET g_sql_tmp="SELECT UNIQUE ppb01",  #No.TQC-720019
             "  FROM ppb_file WHERE ", g_wc CLIPPED,
             " GROUP BY ppb01",
             " INTO TEMP x"
   DROP TABLE x
   PREPARE i005_precount_x FROM g_sql_tmp  #No.TQC-720019
   EXECUTE i005_precount_x
 
   LET g_sql="SELECT COUNT(*) FROM x"
   PREPARE i005_precount FROM g_sql
   DECLARE i005_count CURSOR FOR i005_precount
 
END FUNCTION
 
FUNCTION i005_menu()
   WHILE TRUE
      CALL i005_bp("G")
      CASE g_action_choice
           WHEN "insert" 
            IF cl_chk_act_auth() THEN 
                CALL i005_a()
            END IF
           WHEN "query" 
            IF cl_chk_act_auth() THEN
                CALL i005_q()
            END IF
           WHEN "modify" 
            IF cl_chk_act_auth() THEN
                 CALL i005_u()
            END IF
           WHEN "detail" 
            IF cl_chk_act_auth() THEN 
                CALL i005_b()
            ELSE
               LET g_action_choice = NULL
            END IF
#NO.TQC-740056 start--
           WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i005_copy()
            END IF
#NO.TQC-740056 end--
           WHEN "next" 
            CALL i005_fetch('N')
           WHEN "previous" 
            CALL i005_fetch('P')
           WHEN "delete" 
            IF cl_chk_act_auth() THEN
                CALL i005_r()
            END IF
           WHEN "help" 
            CALL cl_show_help()
           WHEN "exit"
            EXIT WHILE
           WHEN "jump"
            CALL i005_fetch('/')
           WHEN "controlg"     
            CALL cl_cmdask()
            WHEN "related_document"  #No.MOD-470518
            IF cl_chk_act_auth() THEN
               IF g_ppb01 IS NOT NULL THEN
                  LET g_doc.column1 = "ppb01"
                  LET g_doc.value1 = g_ppb01
                  CALL cl_doc()
               END IF
            END IF
           WHEN "exporttoexcel"   #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ppb),'','') 
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i005_a()
 
   IF s_shut(0) THEN RETURN END IF                #檢查權限
   MESSAGE ""
   CLEAR FORM
   CALL g_ppb.clear()
   INITIALIZE g_ppb01 LIKE ppb_file.ppb01
   LET g_wc=NULL
   LET g_wc2=NULL
   LET g_ppb01_t = NULL
   #預設值及將數值類變數清成零
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL i005_i("a")                   #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b = 0
      CALL i005_b()                      #輸入單身
      LET g_ppb01_t = g_ppb01            #保留舊值
      EXIT WHILE
   END WHILE
 
END FUNCTION
   
FUNCTION i005_u()
 
   IF s_shut(0) THEN RETURN END IF                #檢查權限
   IF g_ppb01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_ppb01_t = g_ppb01
   WHILE TRUE
      CALL i005_i("u")                      #欄位更改
      IF INT_FLAG THEN
         LET g_ppb01=g_ppb01_t
         DISPLAY g_ppb01 TO ppb01 #單頭
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      IF g_ppb01 != g_ppb01_t THEN
         UPDATE ppb_file SET ppb01 = g_ppb01  #更新DB
          WHERE ppb01 = g_ppb01_t          #COLAUTH?
         IF SQLCA.sqlcode THEN
            LET g_msg = g_ppb01 CLIPPED CLIPPED
            CALL cl_err3("upd","ppb_file",g_ppb01_t,'',
                          SQLCA.sqlcode,"","",1)  #No.FUN-660129
            CONTINUE WHILE
         END IF
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION
 
#處理INPUT
FUNCTION i005_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1                 #a:輸入 u:更改        #No.FUN-680136 VARCHAR(1)
    
    INPUT g_ppb01 WITHOUT DEFAULTS 
           FROM ppb01
 
        AFTER FIELD ppb01
          #SELECT COUNT(*) INTO l_cnt
          #  FROM sma_file
          # WHERE ((sma910=g_ppb01) OR (sma911=g_ppb01) OR (sma912=g_ppb01) OR (sma913=g_ppb01))  
          # IF l_cnt = 0 THEN 
          #     CALL cl_err('','asm-624',0)
          #     NEXT FIELD ppb01 
          # END IF
          SELECT COUNT(*) INTO l_cnt
            FROM ppa_file
           WHERE ppa02 = g_ppb01
          IF l_cnt = 0 THEN 
              CALL cl_err('','asm-623',0)
              NEXT FIELD ppb01 
          END IF
          SELECT ppa03 INTO g_ppa03 
            FROM ppa_file
           WHERE ppa02 = g_ppb01
          DISPLAY g_ppa03 TO FORMONLY.ppa03
             
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON ACTION CONTROLP                  
           CASE
              WHEN INFIELD(ppb01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_ppa" 
                 LET g_qryparam.default1 = g_ppb01
                 CALL cl_create_qry() RETURNING g_ppb01
                #DISPLAY BY NAME g_ppb01        #TQC-960198 mark  
                 DISPLAY g_ppb01 TO ppb01       #TQC-960198 add 
                 NEXT FIELD ppb01
           END CASE
 
     #TQC-860019-begin-add
      ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
     #TQC-860019-end-add
          
    END INPUT
END FUNCTION
 
FUNCTION i005_q()
 
  DEFINE l_ppb01  LIKE ppb_file.ppb01,
         l_cnt    LIKE type_file.num10           #No.FUN-680136 INTEGER
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ppb01 TO NULL               #No.FUN-6A0162  
   CALL cl_opmsg('q')
   MESSAGE ""
   CALL i005_cs()                            #取得查詢條件
   IF INT_FLAG THEN                          #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_ppb01 TO NULL
      RETURN
   END IF
   OPEN i005_bcs                    #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                         #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_ppb01 TO NULL
   ELSE
      OPEN i005_count
      FETCH i005_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i005_fetch('F')            #讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
FUNCTION i005_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680136 VARCHAR(1)
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i005_bcs INTO g_ppb01
        WHEN 'P' FETCH PREVIOUS i005_bcs INTO g_ppb01
        WHEN 'F' FETCH FIRST    i005_bcs INTO g_ppb01
        WHEN 'L' FETCH LAST     i005_bcs INTO g_ppb01
        WHEN '/' 
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
                
                END PROMPT
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump i005_bcs INTO g_ppb01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
       CALL cl_err(g_ppb01,SQLCA.sqlcode,0)
       INITIALIZE g_ppb01 TO NULL  #TQC-6B0105
    ELSE
       OPEN i005_count
       FETCH i005_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt  
       CALL i005_show()
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
 
FUNCTION i005_show()
    DISPLAY g_ppb01 TO ppb01  
    SELECT ppa03 INTO g_ppa03 
      FROM ppa_file
     WHERE ppa02 = g_ppb01
    DISPLAY g_ppa03 TO FORMONLY.ppa03
    
    CALL i005_b_fill(g_wc)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i005_r()
 
   IF s_shut(0) THEN RETURN END IF                #檢查權限
   IF g_ppb01 IS NULL THEN
      CALL cl_err("",-400,0)                 #No.FUN-6A0162
      RETURN
   END IF
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "ppb01"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_ppb01       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM ppb_file
       WHERE ppb01 = g_ppb01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","ppb_file",g_ppb01,'',SQLCA.sqlcode,
                      "","BODY DELETE",1)  #No.FUN-660129
      ELSE
         CLEAR FORM
         CALL g_ppb.clear()
         LET g_delete='Y'
         LET g_ppb01 = NULL
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
         DROP TABLE x
         PREPARE i005_precount_x2 FROM g_sql_tmp  #No.TQC-720019
         EXECUTE i005_precount_x2                 #No.TQC-720019
         OPEN i005_count
         #FUN-B50063-add-start--
         IF STATUS THEN
            CLOSE i005_bcs
            CLOSE i005_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end-- 
         FETCH i005_count INTO g_row_count
         #FUN-B50063-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i005_bcs
            CLOSE i005_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i005_bcs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i005_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i005_fetch('/')
         END IF
      END IF
   END IF
END FUNCTION
 
#單身
FUNCTION i005_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680136 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680136 SMALLINT
    l_str           LIKE type_file.chr20,               #No.FUN-680136 VARCHAR(20)  
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680136 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680136 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680136 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_ppb01 IS NULL THEN
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT ppb02,ppb03",
                       "  FROM ppb_file",
                       "  WHERE ppb01=? AND ppb02=? ",
                       "   FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i005_bcl CURSOR FROM g_forupd_sql
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_ppb WITHOUT DEFAULTS FROM s_ppb.* 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
           IF g_rec_b >= l_ac THEN
              BEGIN WORK
              LET p_cmd='u'
              LET g_ppb_t.* = g_ppb[l_ac].*      #BACKUP
              OPEN i005_bcl USING g_ppb01,g_ppb_t.ppb02
              FETCH i005_bcl INTO g_ppb[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_ppb_t.ppb02,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
              LET g_ppb_t.* = g_ppb[l_ac].*      #BACKUP
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_ppb[l_ac].* TO NULL      #900423
           LET g_ppb_t.* = g_ppb[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD ppb02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
 
           INSERT INTO ppb_file(ppb01,ppb02,ppb03)
           VALUES(g_ppb01,g_ppb[l_ac].ppb02,
                  g_ppb[l_ac].ppb03)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","ppb_file",g_ppb[l_ac].ppb02,"",
                            SQLCA.sqlcode,"","",1)  #No.FUN-660129
              LET g_ppb[l_ac].* = g_ppb_t.*
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              COMMIT WORK
           END IF
 
#TQC-970146 --begin--
       AFTER FIELD ppb02
         IF NOT cl_null(g_ppb[l_ac].ppb02) THEN 
            IF g_ppb[l_ac].ppb02 < 0 THEN 
               CALL cl_err('','aim-223',0)
               NEXT FIELD ppb02
            END IF 
         END IF 
#TQC-970146 --end--
#TQC-970149 --begin--
       AFTER FIELD ppb03
         IF NOT cl_null(g_ppb[l_ac].ppb03) THEN 
            IF g_ppb[l_ac].ppb03 < 0 THEN 
               CALL cl_err('','aim-223',0)
               NEXT FIELD ppb03
            END IF 
         END IF 
#TQC-970149 --end--
 
        BEFORE DELETE                            #是否取消單身
           IF g_ppb[l_ac].ppb02 IS NOT NULL AND g_ppb_t.ppb02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN 
                 CALL cl_err("", -263, 1) 
                 CANCEL DELETE 
              END IF 
              DELETE FROM ppb_file
               WHERE ppb01 = g_ppb01
                 AND ppb02 = g_ppb_t.ppb02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","ppb_file",g_ppb_t.ppb02,"",
                               SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 ROLLBACK WORK
                 CANCEL DELETE 
              END IF
              COMMIT WORK
              LET g_rec_b=g_rec_b-1
           END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_ppb[l_ac].* = g_ppb_t.*
              CLOSE i005_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_ppb[l_ac].ppb02,-263,1)
              LET g_ppb[l_ac].* = g_ppb_t.*
           ELSE
              UPDATE ppb_file SET ppb02=g_ppb[l_ac].ppb02,
                                  ppb03=g_ppb[l_ac].ppb03
               WHERE ppb01=g_ppb01
                 AND ppb02=g_ppb_t.ppb02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","ppb_file",g_ppb[l_ac].ppb02,"",
                               SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 LET g_ppb[l_ac].* = g_ppb_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
#          LET l_ac_t = l_ac      #FUN-D30034 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN 
                 LET g_ppb[l_ac].* = g_ppb_t.*
              #FUN-D30034---add---str---
              ELSE
                 CALL g_ppb.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30034---add---end---
              END IF 
              CLOSE i005_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac      #FUN-D30034 add
           CLOSE i005_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(ppb02) AND l_ac > 1 THEN
              LET g_ppb[l_ac].* = g_ppb[l_ac-1].*
              NEXT FIELD ppb02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
 
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
 
    CLOSE i005_bcl
        COMMIT WORK
 
END FUNCTION
 
FUNCTION i005_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(200)
 
    LET g_sql = "SELECT ppb02,ppb03",
                "  FROM ppb_file ",
                " WHERE ppb01 = '",g_ppb01,"'", 
                "   AND ",p_wc CLIPPED ,
                " ORDER BY 1"
    PREPARE i005_prepare2 FROM g_sql      #預備一下
    DECLARE ppb_cs CURSOR FOR i005_prepare2
 
    CALL g_ppb.clear()   #FUN-5A0157
    LET g_cnt = 1
    LET g_rec_b=0
 
    FOREACH ppb_cs INTO g_ppb[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_ppb.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1               #no.6277
    LET g_cnt = 0
   
END FUNCTION
 
FUNCTION i005_bp(p_ud)
    DEFINE p_ud            LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
    IF p_ud <> "G" OR g_action_choice = "detail" THEN
        RETURN
    END IF
 
    LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_ppb TO s_ppb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET l_sl = SCR_LINE()
 
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
         CALL i005_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION previous
         CALL i005_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION jump 
         CALL i005_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION next
         CALL i005_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION last 
         CALL i005_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
#     ON ACTION output                   #TQC-790095
#        LET g_action_choice="output"    #TQC-790095
#        EXIT DISPLAY                    #TQC-790095
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
#NO.TQC-740056 start-
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
#NO.TQC-740056 end---
       ON ACTION related_document  #No.MOD-470518
         LET g_action_choice="related_document"
         EXIT DISPLAY
    
      ON ACTION exporttoexcel    #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY   #TQC-5B0076
 
     #TQC-860019-begin-add
      ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE DISPLAY
     #TQC-860019-end-add
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i005_copy()
DEFINE l_newno1,l_oldno1  LIKE pmb_file.pmb01,
       l_ppa03            LIKE ppa_file.ppa03,
       p_cmd              LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1)
       l_n                LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ppb01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
 
    INPUT l_newno1 WITHOUT DEFAULTS 
           FROM ppb01
 
       AFTER FIELD ppb01 
            SELECT COUNT(*) INTO l_n FROM ppb_file WHERE ppb01=l_newno1 
            IF l_n > 0 THEN 
               CALL cl_err(l_newno1,-239,0) NEXT FIELD ppb01
            END IF
            SELECT ppa03 INTO l_ppa03 FROM ppa_file WHERE ppa02=l_newno1 
            IF STATUS THEN 
               CALL cl_err3("sel","ppa_file",l_newno1,"",STATUS,"","",1) NEXT FIELD ppb01 
            END IF
            DISPLAY l_ppa03 TO FORMONLY.ppa03
  
       ON ACTION CONTROLP
           CASE
             WHEN INFIELD(ppb01)  
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_ppa" 
                 LET g_qryparam.default1 = g_ppb01
                 CALL cl_create_qry() RETURNING l_newno1
                 DISPLAY l_newno1 TO ppb01  
                 NEXT FIELD ppb01
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
        LET INT_FLAG = 0 DISPLAY g_ppb01 TO ppb01 #ATTRIBUTE(YELLOW)   #TQC-8C0076
        RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM ppb_file         #單身復制
        WHERE g_ppb01=ppb01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","x",g_ppb01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
       RETURN
    END IF
    UPDATE x SET ppb01 = l_newno1 
    INSERT INTO ppb_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","ppb_file",l_newno1,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
       RETURN
    #ELSE
    #   UPDATE ppb_file SET pmbuser=g_user,
    #                       pmbgrup=g_grup,
    #                       pmbdate=g_today
    #    WHERE pmb01=l_newno1
    END IF
    LET l_oldno1= g_ppb01
    LET g_ppb01=l_newno1
    CALL i005_b()
    #LET g_ppb01=l_oldno1  #FUN-C80046
    #CALL i005_show()      #FUN-C80046
END FUNCTION
 
