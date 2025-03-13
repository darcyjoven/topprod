# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: apmt403.4gl
# Descriptions...: 請購重要備註維護作業
# Date & Author..: 90/09/10 By Wu
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0056 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-4C0095 05/01/07 By Mandy 報表轉XML
# Modify.........: NO.FUN-550060 05/05/30 By jackie 單據編號加大
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/07 By Jackho 欄位類型修改
# Modify.........: No.FUN-6A0162 06/11/07 By jamie 1.FUNCTION _fetch() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-740117 07/04/20 By rainy GP5.0整合測試
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-820002 08/02/25 By lutingting 報表轉為使用p_query
# Modify.........: No.FUN-980006 09/08/14 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-B20125 11/02/21 By lilingyu 新增一筆請購單資料,維護備註action時,未帶出"資料建立者、資料建立部門"欄位的值
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30034 13/04/17 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_pmk           RECORD LIKE pmk_file.*,
    g_pmk_t         RECORD LIKE pmk_file.*,
    g_pmk01_t       LIKE pmk_file.pmk01,      #請購單號
    g_type_t        LIKE type_file.chr1,      #資料性質 	#No.FUN-680136 VARCHAR(1)
    g_type          LIKE type_file.chr1,      #資料性質 	#No.FUN-680136 VARCHAR(1)
    g_pmp           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        pmp03       LIKE pmp_file.pmp03,      #記錄日期
        pmp04       LIKE pmp_file.pmp04,      #行序
        pmp05       LIKE pmp_file.pmp05       #備註
                    END RECORD,
    g_pmp_t         RECORD                    #程式變數 (舊值)
        pmp03       LIKE pmp_file.pmp03,      #記錄日期
        pmp04       LIKE pmp_file.pmp04,      #行序
        pmp05       LIKE pmp_file.pmp05       #備註
                    END RECORD,
    g_wc,g_sql          string,              #No.FUN-580092 HCN
    g_wc2               string,              #No.FUN-580092 HCN
    g_argv1         LIKE type_file.chr1,     #資料性質             #No.FUN-680136 VARCHAR(1)
    g_argv2         LIKE pmk_file.pmk01,     #請購單號
    g_rec_b         LIKE type_file.num5,     #單身筆數             #No.FUN-680136 SMALLINT
    l_ac            LIKE type_file.num5      #目前處理的ARRAY CNT  #No.FUN-680136 SMALLINT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt      LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose   #No.FUN-680136 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000  #No.FUN-680136 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE   g_jump          LIKE type_file.num10    #FUN-4C0056    #No.FUN-680136 INTEGER
DEFINE   g_no_ask       LIKE type_file.num5     #FUN-4C0056    #No.FUN-680136 SMALLINT

MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    LET g_argv1 =  ARG_VAL(1)              #資料性質
    LET g_argv2 =  ARG_VAL(2)              #請購單號
    LET g_pmk01_t = NULL
    LET g_pmk.pmk01 = g_argv2                  #請購單號
    LET g_type      = g_argv1                  #資料性質
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("APM")) THEN
       EXIT PROGRAM
    END IF
 
    IF g_sma.sma31 matches'[Nn]' THEN    #無使用請購功能
       CALL cl_err(g_sma.sma31,'mfg0032',1)
       EXIT PROGRAM
    END IF

    CALL cl_used(g_prog,g_time,1) RETURNING g_time

    LET g_forupd_sql = "SELECT * FROM pmk_file WHERE pmk01=? FOR UPDATE" 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t403_cl CURSOR FROM g_forupd_sql
 
    OPEN WINDOW t403_w WITH FORM "apm/42f/apmt403"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    IF g_argv1 IS NOT NULL AND g_argv1 != ' '
      AND g_argv2 IS NOT NULL AND g_argv2 != ' '
    THEN CALL t403_q()
         CALL t403_b()
    ELSE
         LET g_type = '0'
         CALL t403_menu()
    END IF
    CLOSE WINDOW t403_w                 #結束畫面
    CLOSE WINDOW t403_w                 #結束畫面

    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION t403_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    CALL g_pmp.clear()
 
 IF g_argv1 IS NULL OR g_argv1 = ' '  OR
    g_argv2 IS NULL OR g_argv2 = ' '
 THEN
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_pmk.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
          pmk01,pmkuser,pmkgrup,
          pmkoriu,pmkorig,                  #TQC-B20125 
          pmkmodu,pmkdate,pmkacti
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
 ELSE DISPLAY BY NAME g_pmk.pmk01
      LET g_wc = " pmk01 ='",g_pmk.pmk01,"'"
 END IF
    IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND pmkuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND pmkgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND pmkgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pmkuser', 'pmkgrup')
    #End:FUN-980030
 
 IF g_argv1 IS NULL OR g_argv1 = ' '  OR
    g_argv2 IS NULL OR g_argv2 = ' '
 THEN
   CONSTRUCT g_wc2 ON pmp03,pmp04,pmp05           # 螢幕上取單身條件
            FROM s_pmp[1].pmp03,s_pmp[1].pmp04,s_pmp[1].pmp05
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
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
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
    IF INT_FLAG THEN  RETURN END IF
 ELSE LET g_wc2 = " 1=1"
 END IF
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT  pmk01 FROM pmk_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 1"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE pmk_file. pmk01 ",
                   "  FROM pmk_file, pmp_file ",
                   " WHERE pmk01 = pmp01 ",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY 1"
    END IF
 
    PREPARE t403_prepare FROM g_sql
    DECLARE t403_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t403_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM pmk_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(*) FROM pmk_file,pmp_file WHERE ",
                  "pmk01=pmp01 ",
                  " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t403_precount FROM g_sql
    DECLARE t403_count CURSOR FOR t403_precount
END FUNCTION
 
FUNCTION t403_menu()
 
   WHILE TRUE
      CALL t403_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t403_q()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t403_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t403_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t403_out()      
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pmp),'','')
            END IF
         #No.FUN-6A0162-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_pmk.pmk01 IS NOT NULL THEN
                 LET g_doc.column1 = "pmk01"
                 LET g_doc.value1 = g_pmk.pmk01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0162-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
 
#Query 查詢
FUNCTION t403_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_pmp.clear()
    CALL t403_cs()                         #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_pmk.pmk01 TO NULL
        RETURN
    END IF
    OPEN t403_cs                           #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                  #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_pmk.pmk01 TO NULL
    ELSE
        CALL t403_fetch('F')               #讀出TEMP第一筆並顯示
        OPEN t403_count
        FETCH t403_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION t403_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式       #No.FUN-680136 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數     #No.FUN-680136 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t403_cs INTO g_pmk.pmk01
        WHEN 'P' FETCH PREVIOUS t403_cs INTO g_pmk.pmk01
        WHEN 'F' FETCH FIRST    t403_cs INTO g_pmk.pmk01
        WHEN 'L' FETCH LAST     t403_cs INTO g_pmk.pmk01
        WHEN '/'
#FUN-4C0056 modify
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                   LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
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
            FETCH ABSOLUTE g_jump t403_cs INTO g_pmk.pmk01
            LET g_no_ask = FALSE
    END CASE
##
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pmk.pmk01,SQLCA.sqlcode,0)
        INITIALIZE g_pmk.pmk01 TO NULL        #No.FUN-6A0162 
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump    #FUN-4C0056
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_pmk.* FROM pmk_file WHERE pmk01=g_pmk.pmk01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_pmk.pmk01,SQLCA.sqlcode,0)   #No.FUN-660129
        CALL cl_err3("sel","pmk_file",g_pmk.pmk01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
        INITIALIZE g_pmk.* TO NULL
        RETURN
    END IF
 
    LET g_data_owner = g_pmk.pmkuser      #FUN-4C0056 add
    LET g_data_group = g_pmk.pmkgrup      #FUN-4C0056 add
    LET g_data_plant = g_pmk.pmkplant #FUN-980030
    CALL t403_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t403_show()
    LET g_pmk_t.* = g_pmk.*                #保存單頭舊值
    LET g_pmk.pmkmodu=g_user
    LET g_pmk.pmkdate=g_today
    DISPLAY BY NAME                              # 顯示單頭值
        g_pmk.pmk01,g_pmk.pmkuser,g_pmk.pmkgrup,
        g_pmk.pmkmodu,g_pmk.pmkdate,g_pmk.pmkacti
       ,g_pmk.pmkoriu,g_pmk.pmkorig                  #TQC-B20125 
 
    CALL t403_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
#單身
FUNCTION t403_b()
DEFINE
    l_ac_t          LIKE type_file.num5,         #未取消的ARRAY CNT   #No.FUN-680136 SMALLINT
    l_n             LIKE type_file.num5,         #檢查重複用      #No.FUN-680136 SMALLINT
    l_lock_sw       LIKE type_file.chr1,         #單身鎖住否      #No.FUN-680136 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,         #可新增否        #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5          #可刪除否        #No.FUN-680136 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_pmk.pmk01 IS NULL  THEN
        RETURN
    END IF
 
    CALL cl_opmsg('b')
 
 
    LET g_forupd_sql =
       "SELECT pmp03,pmp04,pmp05 ",
       "FROM pmp_file ",
       " WHERE pmp01 = ? ",
       "  AND pmp02 = ? ",
       "  AND pmp03 = ? ",
       "  AND pmp04 = ? ",
       "FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t403_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_pmp WITHOUT DEFAULTS FROM s_pmp.*
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
 
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_pmp_t.* = g_pmp[l_ac].*  #BACKUP
                BEGIN WORK
                OPEN t403_bcl USING g_pmk.pmk01,g_type,g_pmp_t.pmp03,g_pmp_t.pmp04
                IF STATUS THEN
                    CALL cl_err("OPEN t403_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH t403_bcl INTO g_pmp[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_pmp_t.pmp04,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    ELSE
                        LET g_pmp_t.*=g_pmp[l_ac].*
                    END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO pmp_file(pmp01,pmp02,pmp03,pmp04,pmp05,pmpplant,pmplegal) #FUN-980006 add pmpplant,pmplegal
                          VALUES(g_pmk.pmk01,g_type,g_pmp[l_ac].pmp03,
                                 g_pmp[l_ac].pmp04,g_pmp[l_ac].pmp05,g_plant,g_legal) #FUN-980006 add g_plant,g_legal
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_pmp[l_ac].pmp04,SQLCA.sqlcode,1)   #No.FUN-660129
               CALL cl_err3("ins","pmp_file",g_pmk.pmk01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_pmp[l_ac].* TO NULL      #900423
            LET g_pmp_t.* = g_pmp[l_ac].*         #新輸入資料
            IF l_ac > 1	THEN #沿用欄位
               LET g_pmp[l_ac].pmp03 = g_pmp[l_ac-1].pmp03
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD pmp03
 
        BEFORE FIELD pmp04                        # dgeeault 序號
            IF g_pmp[l_ac].pmp04 IS NULL or g_pmp[l_ac].pmp04 = 0
               OR g_pmp[l_ac].pmp03 != g_pmp_t.pmp03 THEN
                SELECT max(pmp04)+1 INTO g_pmp[l_ac].pmp04 FROM pmp_file
                    WHERE pmp01 = g_pmk.pmk01 AND pmp02 = g_type
                      AND pmp03 = g_pmp[l_ac].pmp03
                IF g_pmp[l_ac].pmp04 IS NULL THEN
                    LET g_pmp[l_ac].pmp04 = 1
                END IF
            END IF
 
        AFTER FIELD pmp04                        #check 序號是否重複
            IF g_pmp[l_ac].pmp04 IS NOT NULL AND
               (g_pmp[l_ac].pmp04 != g_pmp_t.pmp04 OR
                g_pmp_t.pmp04 IS NULL) THEN
                SELECT count(*) INTO l_n FROM pmp_file
                 WHERE pmp01 = g_pmk.pmk01 AND pmp02 = g_type
                   AND pmp03 = g_pmp[l_ac].pmp03 AND
                       pmp04 = g_pmp[l_ac].pmp04
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_pmp[l_ac].pmp04 = g_pmp_t.pmp04
                   NEXT FIELD pmp04
                END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_pmp_t.pmp04 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM pmp_file
                 WHERE pmp01 = g_pmk.pmk01 AND pmp02 = g_type
                   AND pmp03 = g_pmp_t.pmp03 AND pmp04 = g_pmp_t.pmp04
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_pmp_t.pmp04,SQLCA.sqlcode,0)   #No.FUN-660129
                   CALL cl_err3("del","pmp_file",g_pmk.pmk01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b = g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_pmp[l_ac].* = g_pmp_t.*
               CLOSE t403_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_pmp[l_ac].pmp03,-263,1)
               LET g_pmp[l_ac].* = g_pmp_t.*
            ELSE
                UPDATE pmp_file SET
                       pmp03 = g_pmp[l_ac].pmp03,
                       pmp04 = g_pmp[l_ac].pmp04,
                       pmp05 = g_pmp[l_ac].pmp05
                 WHERE pmp01 = g_pmk.pmk01
                   AND pmp02 = g_type
                   AND pmp03 = g_pmp_t.pmp03
                   AND pmp04 = g_pmp_t.pmp04
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_pmp[l_ac].pmp04,SQLCA.sqlcode,0)   #No.FUN-660129
                    CALL cl_err3("upd","pmp_file",g_pmk.pmk01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
                    LET g_pmp[l_ac].* = g_pmp_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
#           LET l_ac_t = l_ac       #FUN-D30034 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_pmp[l_ac].* = g_pmp_t.*
               #FUN-D30034---add---str---
               ELSE
                  CALL g_pmp.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034---add---end---
               END IF
               CLOSE t403_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac       #FUN-D30034 add
            CLOSE t403_bcl
            COMMIT WORK
 
      # ON ACTION CONTROLN
      #     CALL t403_b_askkey()
      #     EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            #IF INFIELD(pmp04) AND l_ac > 1 THEN         #TQC-740117
            IF INFIELD(pmp03) AND l_ac > 1 THEN          #TQC-740117
                LET g_pmp[l_ac].* = g_pmp[l_ac-1].*
                DISPLAY g_pmp[l_ac].* TO s_pmp[l_ac].*
                NEXT FIELD pmp04
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
 
    CLOSE t403_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION t403_b_askkey()
DEFINE
    l_wc            LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(200)
 
    CONSTRUCT l_wc ON pmp03,pmp04,pmp05    #螢幕上取條件
       FROM s_pmp[1].pmp03,s_pmp[1].pmp04,s_pmp[1].pmp05
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
    CALL t403_b_fill(l_wc)
END FUNCTION
 
FUNCTION t403_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2         LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(200)
 
    LET g_sql =
        "SELECT pmp03,pmp04,pmp05 ",
        " FROM pmp_file",
        " WHERE pmp01 ='",g_pmk.pmk01,"' AND",  #單頭-1
        " pmp02 ='",g_type,"' AND ",
        p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE t403_pb FROM g_sql
    DECLARE pmp_cs                       #CURSOR
        CURSOR FOR t403_pb
 
    CALL g_pmp.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH pmp_cs INTO g_pmp[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_pmp.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t403_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pmp TO s_pmp.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL t403_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t403_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t403_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t403_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t403_fetch('L')
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0162  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
  
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t403_copy()
DEFINE
    l_newno1         LIKE pmk_file.pmk01,
    l_oldno          LIKE pmk_file.pmk01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_pmk.pmk01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
    INPUT l_newno1 FROM pmk01
#No.FUN-550060 --start--
       BEFORE INPUT
         CALL cl_set_docno_format("pmk01")
#No.FUN-550060 ---end---
 
        AFTER FIELD pmk01
            IF l_newno1 IS NULL THEN
                NEXT FIELD pmk01
            ELSE
               SELECT pmk01 FROM pmk_file WHERE pmk01 = l_newno1
                 IF SQLCA.sqlcode THEN
#                   CALL cl_err('','mfg3052',0)  #No.FUN-660129
                    CALL cl_err3("sel","pmk_file",l_newno1,"","mfg3052","","",1)  #No.FUN-660129
                    NEXT FIELD pmk01
                 END IF
            END IF
            SELECT count(*) INTO g_cnt FROM pmp_file
                WHERE pmp01=l_newno1
            IF g_cnt > 0 THEN
                LET g_msg = l_newno1 CLIPPED
                CALL cl_err(g_msg,-239,0)
                NEXT FIELD pmk01
            END IF
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
        DISPLAY BY NAME g_pmk.pmk01
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM pmp_file         #單身複製
        WHERE pmp01=g_pmk.pmk01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        LET g_msg=g_pmk.pmk01 CLIPPED,'+',g_type CLIPPED
#       CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660129
        CALL cl_err3("ins","x",g_msg,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
        RETURN
    END IF
    UPDATE x
        SET pmp01=l_newno1
    INSERT INTO pmp_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        LET g_msg=g_pmk.pmk01 CLIPPED,'+',g_type CLIPPED,'+'
#       CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660129
        CALL cl_err3("ins","pmp_file",g_msg,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
        RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno1,') O.K'
 
     LET l_oldno = g_pmk.pmk01
     LET g_pmk.pmk01 = l_newno1
#    SELECT * INTO g_pmk.* FROM pmk_file WHERE pmk01 = l_newno
#    CALL i020_u()
     CALL t403_b()
     #LET g_pmk.pmk01 = l_oldno   #FUN-C80046
#    SELECT * INTO g_pmk.* FROM pmk_file WHERE pmk01 = l_oldno
     #CALL t403_show()            #FUN-C80046
    DISPLAY BY NAME g_pmk.pmk01
END FUNCTION
 
FUNCTION t403_out()
DEFINE
   l_i             LIKE type_file.num5,                #No.FUN-680136 SMALLINT
   sr              RECORD
       pmp01       LIKE pmp_file.pmp01,   #請購編號
       pmp03       LIKE pmp_file.pmp03,   #記錄日期
       pmp04       LIKE pmp_file.pmp04,   #行序
       pmp05       LIKE pmp_file.pmp05    #備註
                   END RECORD,
   l_name          LIKE type_file.chr20,               #External(Disk) file name   #No.FUN-680136 VARCHAR(20)
   l_za05          LIKE type_file.chr1000              #No.FUN-680136 VARCHAR(40)
 
DEFINE l_cmd           LIKE type_file.chr1000         #No.FUN-820002
 
   IF g_wc IS NULL THEN
      CALL cl_err('','9057',0) RETURN END IF
#       CALL cl_err('',-400,0)
#       RETURN
#   END IF
 
#No.FUN-820002 --start-- 
   IF cl_null(g_wc) AND NOT cl_null(g_pmk.pmk01) THEN                                                                               
      LET g_wc = " pmk01 = '",g_pmk.pmk01,"' "                                                                                      
                                                                                                                                    
   END IF
 
   IF cl_null(g_wc2) THEN                                                                                                           
      LET g_wc2 = " 1=1"                                                                                                            
   END IF                                                                                                                           
 
   #報表轉為使用 p_query                                                                                                            
   LET l_cmd = 'p_query "apmt403" "',g_wc CLIPPED,' AND ',g_wc2 CLIPPED,'"'                                                         
   CALL cl_cmdrun(l_cmd)                                                                                                            
   RETURN
 
#   CALL cl_wait()
#   CALL cl_outnam('apmt403') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT pmp01,pmp03,pmp04,pmp05 ",
#             " FROM pmp_file ,pmk_file",  # 組合出 SQL 指令
#             " WHERE pmk01 = pmp01 AND pmp02 = '0' ",
#             " AND ",g_wc CLIPPED,
#             " AND ",g_wc2 CLIPPED
#   PREPARE t403_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE t403_co                         # CURSOR
#       CURSOR FOR t403_p1
 
#   START REPORT t403_rep TO l_name
 
#   FOREACH t403_co INTO sr.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)   #No.FUN-660129
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT t403_rep(sr.*)
#   END FOREACH
 
#   FINISH REPORT t403_rep
 
#   CLOSE t403_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT t403_rep(sr)
#DEFINE
#   l_trailer_sw    LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
#   sr              RECORD
#       pmp01       LIKE pmp_file.pmp01,   #請購編號
#       pmp03       LIKE pmp_file.pmp03,   #記錄日期
#       pmp04       LIKE pmp_file.pmp04,   #行序
#       pmp05       LIKE pmp_file.pmp05    #備註
#                   END RECORD
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.pmp01,sr.pmp03,sr.pmp04
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<',"/pageno"
#           PRINT g_head CLIPPED,pageno_total
#           PRINT
#           PRINT g_dash
#           PRINT g_x[31],g_x[32],g_x[33]
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
#       BEFORE GROUP OF sr.pmp01  #請購日期
#           PRINT COLUMN g_c[31],sr.pmp01;
#       BEFORE GROUP OF sr.pmp03  #記錄日期
#           PRINT COLUMN g_c[32],sr.pmp03;
#       ON EVERY ROW
#           PRINT COLUMN g_c[33],sr.pmp05 CLIPPED
#       AFTER GROUP OF sr.pmp01   #請購單號
#           PRINT g_dash
#       ON LAST ROW
#           LET l_trailer_sw = 'n'
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[33], g_x[7] CLIPPED
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[33], g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#FUN-820002--end
