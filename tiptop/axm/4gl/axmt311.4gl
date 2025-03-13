# Prog. Version..: '5.30.06-13.04.22(00008)'     #
#
# Pattern name...: axmt311.4gl
# Descriptions...: 估價單備註說明維護作業
# Date & Author..: 00/03/02 By Melody
# Modify.........: No.MOD-480128 04/08/05 Wiky axmt310串過來有問題
# Modify.........: No.FUN-4B0038 04/11/15 By pengu ARRAY轉為EXCEL檔
# Modify.........: NO.FUN-4C0096 05/01/11 By Carol 修改報表架構轉XML
# Modify.........: No.FUN-560060 05/06/15 By day   單據編號修改        
# Modify.........: No.FUN-660167 06/06/23 By cl cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/14 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.FUN-6A0020 06/11/21 By jamie 1.FUNCTION _fetch() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-740269 07/04/24 By bnlent 被axmt310調用時無法顯示單身
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-790070 07/09/11 By lumxa 打印報表中，“（結束）”不在頁面的右下腳，在最后一行的中間
# Modify.........: No.FUN-7C0043 07/12/25 By destiny 報表改為p_query輸出 
# Modify.........: No.FUN-980010 09/08/24 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30034 13/04/16 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_argv1         LIKE oqe_file.oqe01,   #No.FUN-560060
    g_argv2         LIKE type_file.num5,        # No.FUN-680137 SMALLINT    #項次 
    g_oqe01         LIKE oqe_file.oqe01,   #假單頭
    g_oqe02         LIKE oqe_file.oqe02,   #假單頭
    g_oqe01_t       LIKE oqe_file.oqe01,   #假單頭
    g_oqe02_t       LIKE oqe_file.oqe02,   #假單頭
    g_oqe           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        oqe03       LIKE oqe_file.oqe03,  
        oqe04       LIKE oqe_file.oqe04
                    END RECORD,
    g_oqe_t         RECORD                 #程式變數 (舊值)
        oqe03       LIKE oqe_file.oqe03,  
        oqe04       LIKE oqe_file.oqe04
                    END RECORD,
     g_wc2,g_sql    string, #No.FUN-580092 HCN
     g_wc           string, #No.FUN-580092 HCN
    g_rec_b        LIKE type_file.num5,                #單身筆數        #No.FUN-680137 SMALLINT
    l_ac           LIKE type_file.num5,                #目前處理的ARRAY CNT        #No.FUN-680137 SMALLINT
    g_ss           LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)
    l_flag         LIKE type_file.chr1           #No.FUN-680137 VARCHAR(1)
DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE g_forupd_sql  STRING  #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680137 SMALLINT
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0094
 
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
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
    LET g_argv1 = ARG_VAL(1)               #傳遞的參數:專案代號
    LET g_argv2 = ARG_VAL(2)               #傳遞的參數:行序   
    LET g_oqe01 = g_argv1 
    LET g_oqe02 = g_argv2 
 
    INITIALIZE g_oqe_t.* TO NULL
 
    LET p_row = 2 LET p_col = 21
 
    OPEN WINDOW t311_w AT p_row,p_col
         WITH FORM "axm/42f/axmt311" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
     #NO.MOD-480128
    IF NOT cl_null(g_argv1) THEN 
       #CALL t311_q()            #No.TQC-740269
       CALL t311_show()          #No.TQC-740269
       CALL t311_b()             #No.TQC-740269
    END IF
    CALL t311_menu()
     #NO.MOD-480128(end)
 
    CLOSE WINDOW t311_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
 
END MAIN
 
FUNCTION t311_menu()
   WHILE TRUE
      CALL t311_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL t311_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL t311_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"  
            IF cl_chk_act_auth() THEN
               CALL t311_out()
            END IF 
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oqe),'','')
            END IF
         #No.FUN-6A0020-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_oqe02 IS NOT NULL THEN
                LET g_doc.column1 = "oqe02"
                LET g_doc.column2 = "oqe01"
                LET g_doc.value1 = g_oqe02
                LET g_doc.value2 = g_oqe01
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6A0020-------add--------end----
 
      END CASE
   END WHILE
 
END FUNCTION
   
#QBE 查詢資料
FUNCTION t311_cs()
 
   IF NOT cl_null(g_argv1) THEN
       LET g_wc =" oqe01= '",g_argv1,"' AND "," oqe02= ",g_argv2
       LET g_sql=" SELECT oqe02,oqe01 ",
                 " FROM oqe_file ",
                 " WHERE ",g_wc CLIPPED
   ELSE
       CLEAR FORM                             #清除畫面
       CALL g_oqe.clear()
       CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE g_oqe02 TO NULL    #No.FUN-750051
   INITIALIZE g_oqe01 TO NULL    #No.FUN-750051
       CONSTRUCT g_wc ON oqe01, oqe02, oqe03, oqe04 
            FROM oqe01,oqe02, s_oqe[1].oqe03 , s_oqe[1].oqe04
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
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
    LET g_sql= "SELECT UNIQUE oqe02,oqe01 FROM oqe_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY oqe01"
   END IF
 
    PREPARE t311_prepare FROM g_sql      #預備一下
    DECLARE t311_b_cs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR t311_prepare
 
    #因主鍵值有兩個故所抓出資料筆數有誤
    DROP TABLE x
    LET g_sql="SELECT DISTINCT oqe01,oqe02 ",
              " FROM oqe_file WHERE ", g_wc CLIPPED," INTO TEMP x"
    PREPARE t311_precount_x  FROM g_sql
    EXECUTE t311_precount_x 
    LET g_sql="SELECT COUNT(*) FROM x "
    PREPARE t311_precount FROM g_sql
    DECLARE t311_count CURSOR FOR  t311_precount
    
END FUNCTION
 
 
 
   
FUNCTION t311_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改        #No.FUN-680137 VARCHAR(1)
    l_n             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
    l_str           LIKE aaf_file.aaf03      # No.FUN-680137  VARCHAR(40)
 
    LET g_ss='Y'
    DISPLAY  g_oqe01 TO oqe01 
    DISPLAY  g_oqe02 TO oqe02 
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
    INPUT BY NAME g_oqe01,g_oqe02 WITHOUT DEFAULTS 
 
        AFTER FIELD oqe01
            IF NOT cl_null(g_oqe01) THEN 
               IF g_oqe01 != g_oqe01_t OR      #輸入後更改不同時值
                  g_oqe01_t IS NULL THEN
                   SELECT UNIQUE oqe01 #INTO g_chr
                       FROM oqe_file
                       WHERE oqe01=g_oqe01
                   IF SQLCA.sqlcode THEN             #不存在, 新來的
                       IF p_cmd='a' THEN
                           LET g_ss='N'
                       END IF
                   ELSE
                       IF p_cmd='u' THEN
                           CALL cl_err(g_oqe01,-239,0)
                           LET g_oqe01=g_oqe01_t
                           NEXT FIELD oqe01
                       END IF
                   END IF
               END IF
            END IF
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
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
 
 
   
#Query 查詢
FUNCTION t311_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_oqe.clear()
    CALL t311_cs()                           #取得查詢條件
    IF INT_FLAG THEN                         #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_oqe01 TO NULL
        FOR g_cnt = 1 TO g_oqe.getLength()           
            LET g_oqe[g_cnt].oqe03 = ' ' 
        END FOR
        RETURN
    END IF
    OPEN t311_b_cs                           #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                    #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_oqe01 TO NULL
        INITIALIZE g_oqe02 TO NULL
    ELSE
        CALL t311_fetch('F')                 #讀出TEMP第一筆並顯示
        OPEN t311_count
        FETCH t311_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt  
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION t311_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680137 VARCHAR(1)
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     t311_b_cs INTO g_oqe02,g_oqe01
        WHEN 'P' FETCH PREVIOUS t311_b_cs INTO g_oqe02,g_oqe01
        WHEN 'F' FETCH FIRST    t311_b_cs INTO g_oqe02,g_oqe01
        WHEN 'L' FETCH LAST     t311_b_cs INTO g_oqe02,g_oqe01
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
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump t311_b_cs INTO g_oqe02,g_oqe01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN                        #有麻煩
       CALL cl_err(g_oqe01,SQLCA.sqlcode,0)
       FOR g_cnt = 1 TO g_oqe.getLength()           
           LET g_oqe[g_cnt].oqe03 = ' ' 
       END FOR
       DISPLAY g_oqe01,g_oqe02 TO oqe01,oqe02    #單頭
 
       INITIALIZE g_oqe01 TO NULL                #No.FUN-6A0020
       INITIALIZE g_oqe02 TO NULL                #No.FUN-6A0020
 
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
 
    CALL t311_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t311_show()
    DISPLAY g_oqe01,g_oqe02 TO oqe01,oqe02        #單頭
    CALL t311_b_fill(' 1=1')                      #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t311_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680137 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680137 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680137 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680137 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680137 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680137 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_oqe01 IS NULL THEN RETURN END IF 
    IF g_oqe02 IS NULL THEN RETURN END IF 
    CALL cl_opmsg('b')
 
 
    LET g_forupd_sql = "SELECT oqe03,oqe04 FROM oqe_file",
                       " WHERE oqe03= ? AND oqe01= ? AND oqe02= ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t311_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_oqe WITHOUT DEFAULTS FROM s_oqe.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
 
            IF g_rec_b >= l_ac THEN
               BEGIN WORK
 
               LET p_cmd='u' 
               LET g_oqe_t.* = g_oqe[l_ac].*  #BACKUP
 
               OPEN t311_bcl USING g_oqe_t.oqe03,g_oqe01,g_oqe02
               IF STATUS THEN
                  CALL cl_err("OPEN t311_bcl:", STATUS, 1)
                  LET l_lock_sw = 'Y'
               ELSE 
                  FETCH t311_bcl INTO g_oqe[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_oqe_t.oqe03,SQLCA.sqlcode,1)
                     LET l_lock_sw = 'Y'
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_oqe[l_ac].* TO NULL      #900423
            LET g_oqe_t.* = g_oqe[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD oqe03
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
 
            INSERT INTO oqe_file(oqe01,oqe02,oqe03,oqe04,oqeplant,oqelegal) #FUN-980010 add plant & legal 
                          VALUES(g_oqe01,g_oqe02,g_oqe[l_ac].oqe03,
                                 g_oqe[l_ac].oqe04,g_plant,g_legal)  #FUN-980010 
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_oqe[l_ac].oqe03,SQLCA.sqlcode,0)   #No.FUN-660167
               CALL cl_err3("ins","oqe_file",g_oqe01,g_oqe[l_ac].oqe03,SQLCA.sqlcode,"","",1)  #No.FUN-660167
               CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        BEFORE FIELD oqe03                        #check 編號是否重複
            IF g_oqe[l_ac].oqe03 IS NULL OR
               g_oqe[l_ac].oqe03 = 0 THEN
                SELECT max(oqe03)+1 INTO g_oqe[l_ac].oqe03 FROM oqe_file 
                 WHERE oqe01 = g_oqe01
                   AND oqe02 = g_oqe02
                IF g_oqe[l_ac].oqe03 IS NULL THEN
                    LET g_oqe[l_ac].oqe03 = 1
                END IF
            END IF
 
        AFTER FIELD oqe03                        #check 編號是否重複
            IF NOT cl_null(g_oqe[l_ac].oqe03) THEN
               IF g_oqe[l_ac].oqe03 != g_oqe_t.oqe03 OR
                  (g_oqe[l_ac].oqe03 IS NOT NULL AND g_oqe_t.oqe03 IS NULL) THEN
                   SELECT count(*) INTO l_n FROM oqe_file
                       WHERE oqe03 = g_oqe[l_ac].oqe03
                         AND oqe01 = g_oqe01 AND oqe02 = g_oqe02 
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_oqe[l_ac].oqe03 = g_oqe_t.oqe03
                       NEXT FIELD oqe03
                   END IF
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_oqe_t.oqe03 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                
                DELETE FROM oqe_file
                 WHERE oqe03 = g_oqe_t.oqe03  
                   AND oqe01 = g_oqe01 AND oqe02 = g_oqe02
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_oqe_t.oqe03,SQLCA.sqlcode,0)   #No.FUN-660167
                   CALL cl_err3("del","oqe_file",g_oqe01,g_oqe_t.oqe03,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                   ROLLBACK WORK
                   CANCEL DELETE 
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_oqe[l_ac].* = g_oqe_t.*
               CLOSE t311_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
 
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_oqe[l_ac].oqe03,-263,1)
               LET g_oqe[l_ac].* = g_oqe_t.*
            ELSE
               UPDATE oqe_file SET oqe01=g_oqe01,
                                   oqe02=g_oqe02,
                                   oqe03=g_oqe[l_ac].oqe03,
                                   oqe04=g_oqe[l_ac].oqe04
                WHERE oqe03=g_oqe_t.oqe03
                  AND oqe01=g_oqe01 
                  AND oqe02=g_oqe02
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_oqe[l_ac].oqe03,SQLCA.sqlcode,0)   #No.FUN-660167
                   CALL cl_err3("upd","oqe_file",g_oqe01,g_oqe_t.oqe03,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                   LET g_oqe[l_ac].* = g_oqe_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac      #FUN-D30034 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_oqe[l_ac].* = g_oqe_t.*
               #FUN-D30034--add--str--
               ELSE
                  CALL g_oqe.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end--
               END IF
               CLOSE t311_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac      #FUN-D30034 Add
            CLOSE t311_bcl
            COMMIT WORK
 
#       ON ACTION CONTROLN
#           CALL t311_b_askkey()
#           EXIT INPUT
        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF l_ac > 1 THEN
                LET g_oqe[l_ac].* = g_oqe[l_ac-1].*
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
 
    
    END INPUT
 
    CLOSE t311_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION t311_b_askkey()
    CLEAR FORM
    CALL g_oqe.clear()
    CONSTRUCT g_wc2 ON oqe03,oqe04
            FROM s_oqe[1].oqe03, s_oqe[1].oqe04
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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL t311_b_fill(g_wc2)
END FUNCTION
 
FUNCTION t311_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(200)
 
     LET g_sql ="SELECT oqe03,oqe04 FROM oqe_file",
                " WHERE oqe01='",g_oqe01,"' AND oqe02='",g_oqe02,"' AND ",
                  p_wc2 CLIPPED,
                " ORDER BY 1"
    PREPARE t311_pb FROM g_sql
    DECLARE oqe_curs CURSOR FOR t311_pb
      
    CALL g_oqe.clear()
 
    LET g_cnt = 1
 
    FOREACH oqe_curs INTO g_oqe[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
 
        LET g_cnt = g_cnt + 1
 
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_oqe.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt-1
 
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t311_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oqe TO s_oqe.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first 
         CALL t311_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL t311_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump 
         CALL t311_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL t311_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last 
         CALL t311_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
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
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0038
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0020  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
#No.FUN-7C0043--start--
FUNCTION t311_out()
    DEFINE
        l_oqe           RECORD LIKE oqe_file.*,
        l_i             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
        l_name          LIKE type_file.chr20,                 # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
        l_za05          LIKE type_file.chr1000                #        #No.FUN-680137 VARCHAR(40)
    DEFINE l_cmd        LIKE type_file.chr1000             #No.FUN-7C0043                                                                 
    DEFINE l_msg        LIKE type_file.chr1000             #No.FUN-7C0043                                                                 
    IF cl_null(g_wc) AND NOT cl_null(g_oqe01) AND NOT cl_null(g_oqe02) THEN                                                         
       LET g_wc = " oqe01 = '",g_oqe01,"' AND oqe02 = '",g_oqe02,"' "                                                               
    END IF                                                                                                                          
    IF g_wc  IS NULL THEN                                                                                                           
       CALL cl_err('','9057',0)                                                                                                     
       RETURN                                                                                                                       
    END IF                                                                                                                          
    LET l_msg = "oqe01 = '",g_oqe01,"' AND oqe02 = '",g_oqe02,"'"                                                                   
    LET l_cmd = 'p_query "axmt311" "',g_wc CLIPPED,'" "',l_msg,'"'                                                                  
    CALL cl_cmdrun(l_cmd)                                                                                                           
    RETURN    
#   IF g_wc  IS NULL THEN 
#      CALL cl_err('','9057',0)
#      RETURN
#   END IF
 
#   CALL cl_wait()
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT * FROM oqe_file ",          # 組合出 SQL 指令
#             " WHERE oqe01= '",g_oqe01,"' AND ",
#                " oqe02= '",g_oqe02,"' AND ",g_wc CLIPPED
#   PREPARE t311_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE t311_co                         # CURSOR
#       CURSOR FOR t311_p1
 
#   CALL cl_outnam('axmt311') RETURNING l_name         #FUN-4C0096 add
#   START REPORT t311_rep TO l_name
 
#   FOREACH t311_co INTO l_oqe.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT t311_rep(l_oqe.*)
#   END FOREACH
 
#   FINISH REPORT t311_rep
 
#   CLOSE t311_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT t311_rep(sr)
#   DEFINE
#       l_trailer_sw    LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)
#       sr RECORD LIKE oqe_file.*
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.oqe01,sr.oqe02 
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<','/pageno'
#           PRINT g_head CLIPPED, pageno_total
#           PRINT ''
 
#           PRINT g_dash
#           PRINT g_x[31], 
#                 g_x[32],
#                 g_x[33],
#                 g_x[34]
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
#       ON EVERY ROW
#           PRINT COLUMN g_c[31],sr.oqe01,
#                 COLUMN g_c[32],sr.oqe02 USING '###&',
#                 COLUMN g_c[33],sr.oqe03 USING '###&',
#                 COLUMN g_c[34],sr.oqe04
 
#       ON LAST ROW
#           PRINT g_dash
#           PRINT g_x[4] CLIPPED, COLUMN g_c[34], g_x[7] CLIPPED #TQC-790070
#           PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED #TQC-790070
#           LET l_trailer_sw = 'n'
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash
#               PRINT g_x[4] CLIPPED, COLUMN g_c[34], g_x[6] CLIPPED #TQC-790070
#               PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED #TQC-790070
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-7C0043--end--
