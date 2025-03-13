# Prog. Version..: '5.30.06-13.04.22(00008)'     #
#
# Pattern name...: apmi202.4gl
# Descriptions...: 供應廠商重要備註維護作業
# Date & Author..: 91/08/28 By Lin
# Modify.........: 92/12/29 By Apple
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0056 04/12/08 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-4C0095 05/01/07 By Mandy 報表轉XML
# Modify.........: No.TQC-5B0037 05/11/07 By Rosayu 報表結束定位點修改
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/08/31 By Jackho 欄位類型修改
# Modify.........: No.TQC-6A0090 06/11/07 By baogui 表頭多行空白
# Modify.........: No.FUN-6A0162 06/11/11 By jamie FUNCTION _fetch() 一開始應清空key值
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-740210 07/04/26 By Mandy 目前狀況pmc05,改用COMBOBOX方式呈式
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-820002 08/02/25 By lutingting 報表轉為使用p_query
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30034 13/04/16 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_pmc           RECORD
                       pmc01  LIKE pmc_file.pmc01,    #供應廠商編號
                       pmc03  LIKE pmc_file.pmc03,    #簡稱
                       pmc05  LIKE pmc_file.pmc05,    #目前狀況
                       pmcacti LIKE pmc_file.pmcacti  #資料有效值
                    END RECORD,
    g_pmc_t         RECORD
                       pmc01  LIKE pmc_file.pmc01,    #供應廠商編號
                       pmc03  LIKE pmc_file.pmc03,    #簡稱
                       pmc05  LIKE pmc_file.pmc05,    #目前狀況
                       pmcacti LIKE pmc_file.pmcacti  #資料有效值
                    END RECORD,
    g_pmc01_t       LIKE pmc_file.pmc01,              #供應商編號  (舊值)
    g_pmg           DYNAMIC ARRAY OF RECORD           #程式變數(Program Variables)
        pmg02       LIKE pmg_file.pmg02,              #行序
        pmg03       LIKE pmg_file.pmg03               #重要備註
                    END RECORD,
    g_pmg_t         RECORD                            #程式變數 (舊值)
        pmg02       LIKE pmg_file.pmg02,              #行序
        pmg03       LIKE pmg_file.pmg03               #重要備註
                    END RECORD,
#    g_wc,g_wc2,g_sql    LIKE type_file.chr1000,      #NO.TQC-630166 MARK         #No.FUN-680136
    g_wc,g_wc2,g_sql     STRING,                      #NO.TQC-630166 
    g_argv1         LIKE pmc_file.pmc01,
    g_flag          LIKE type_file.chr1,              #No.FUN-680136 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,              #單身筆數                   #No.FUN-680136 SMALLINT
    l_ac            LIKE type_file.num5               #目前處理的ARRAY CNT        #No.FUN-680136 SMALLINT
DEFINE p_row,p_col     LIKE type_file.num5            #No.FUN-680136 SMALLINT 
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt          LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_i            LIKE type_file.num5          #count/index for any purpose #No.FUN-680136 SMALLINT
DEFINE   g_msg          LIKE ze_file.ze03            #No.FUN-680136 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
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
 
   LET g_argv1      = ARG_VAL(1)           #廠商編號
   LET g_pmc.pmc01  = g_argv1
 
   LET g_forupd_sql = "SELECT * FROM pmc_file WHERE pmc01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i202_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 2 LET p_col = 20
 
   OPEN WINDOW i202_w WITH FORM "apm/42f/apmi202"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   CALL g_pmg.clear()
 
   IF NOT cl_null(g_argv1) THEN
      CALL i202_q()
      CALL i202_b()
   END IF
 
   CALL i202_menu()
   CLOSE WINDOW i202_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i202_cs()
   DEFINE lc_qbe_sn  LIKE    gbm_file.gbm01  #No.FUN-580031  HCN
   DEFINE l_msg      LIKE ze_file.ze03       #No.FUN-680136 VARCHAR(20)
 
   CLEAR FORM                             #清除畫面
   CALL g_pmg.clear()
 
   IF cl_null(g_argv1) THEN
      CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_pmc.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON pmc01,pmc03,pmc05
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
 
      IF INT_FLAG THEN
         RETURN
      END IF
 
      CONSTRUCT g_wc2 ON pmg02,pmg03 FROM s_pmg[1].pmg02,s_pmg[1].pmg03
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
 
      IF INT_FLAG THEN
         RETURN
      END IF
 
      #資料權限的檢查
      #Begin:FUN-980030
      #      IF g_priv2='4' THEN                           #只能使用自己的資料
      #         LET g_wc = g_wc clipped," AND pmcuser = '",g_user,"'"
      #      END IF
 
      #      IF g_priv3='4' THEN                           #只能使用相同群的資料
      #         LET g_wc = g_wc clipped," AND pmcgrup MATCHES '",g_grup CLIPPED,"*'"
      #      END IF
 
      #      IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
      #         LET g_wc = g_wc clipped," AND pmcgrup IN ",cl_chk_tgrup_list()
      #      END IF
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pmcuser', 'pmcgrup')
      #End:FUN-980030
 
 
   ELSE
      SELECT pmc01,pmc03,pmc05,pmcacti
        INTO g_pmc.* FROM pmc_file WHERE pmc01 = g_pmc.pmc01
 
      DISPLAY BY NAME g_pmc.pmc01     # 顯示單頭值
      DISPLAY BY NAME g_pmc.pmc03     # 顯示單頭值
      DISPLAY BY NAME g_pmc.pmc05     # 顯示單頭值
     #TQC-740210 mark
     #CALL s_stades(g_pmc.pmc05) RETURNING l_msg
     #DISPLAY l_msg TO FORMONLY.desc
      LET g_wc = " pmc01 ='",g_pmc.pmc01,"'"
      LET g_wc2= " pmg01 ='",g_pmc.pmc01,"'"
   END IF
 
   IF g_wc2 = " 1=1" THEN         # 若單身未輸入條件
      LET g_sql = "SELECT  pmc01 FROM pmc_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY pmc01"
   ELSE               # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE pmc_file. pmc01 ",
                  "  FROM pmc_file, pmg_file ",
                  " WHERE pmc01 = pmg01 ",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY pmc01"
   END IF
 
   PREPARE i202_prepare FROM g_sql
   DECLARE i202_cs                         #SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR i202_prepare
 
   IF g_wc2 = " 1=1" THEN         # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM pmc_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(distinct pmc01) FROM pmc_file,pmg_file WHERE ",
                "pmc01=pmg01 ",
                " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE i202_precount FROM g_sql
   DECLARE i202_count CURSOR FOR i202_precount
 
END FUNCTION
 
FUNCTION i202_menu()
 
   WHILE TRUE
      CALL i202_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i202_q()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i202_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i202_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i202_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470518
            IF cl_chk_act_auth() THEN
               IF g_pmc.pmc01 IS NOT NULL THEN
                  LET g_doc.column1 = "pmc01"
                  LET g_doc.value1 = g_pmc.pmc01
                  CALL cl_doc()
               END IF
            END IF
 
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pmg),'','')
            END IF
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i202_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_pmg.clear()
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL i202_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_pmc.* TO NULL
      RETURN
   END IF
 
   OPEN i202_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_pmc.* TO NULL
   ELSE
      OPEN i202_count
      FETCH i202_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i202_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
#處理資料的讀取
FUNCTION i202_fetch(p_flag)
DEFINE
       p_flag          LIKE type_file.chr1,        #處理方式    #No.FUN-680136 VARCHAR(1)
       l_pmcuser       LIKE pmc_file.pmcuser,      #FUN-4C0056 add
       l_pmcgrup       LIKE pmc_file.pmcgrup       #FUN-4C0056 add
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i202_cs INTO g_pmc.pmc01
      WHEN 'P' FETCH PREVIOUS i202_cs INTO g_pmc.pmc01
      WHEN 'F' FETCH FIRST    i202_cs INTO g_pmc.pmc01
      WHEN 'L' FETCH LAST     i202_cs INTO g_pmc.pmc01
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
            FETCH ABSOLUTE g_jump i202_cs INTO g_pmc.pmc01
            LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode AND cl_null(g_argv1) THEN
      LET g_msg=g_pmc.pmc01 CLIPPED,'+',g_pmc.pmc03 CLIPPED
      CALL cl_err(g_msg,SQLCA.sqlcode,0)
      INITIALIZE g_pmc.* TO NULL               #No.FUN-6A0162
      RETURN
   END IF
 
   IF cl_null(g_argv1) THEN
      SELECT pmc01,pmc03,pmc05,pmcacti,pmcuser,pmcgrup  #FUN-4C0056 add
        INTO g_pmc.*,l_pmcuser,l_pmcgrup                #FUN-4C0056 add
        FROM pmc_file WHERE pmc01 = g_pmc.pmc01
      IF SQLCA.sqlcode THEN
         LET g_msg=g_pmc.pmc01 CLIPPED,'+',g_pmc.pmc03 CLIPPED,'+',g_pmc.pmc05
#        CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660129
         CALL cl_err3("sel","pmc_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         INITIALIZE g_pmc.* TO NULL
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
      LET g_data_owner = l_pmcuser      #FUN-4C0056 add
      LET g_data_group = l_pmcgrup      #FUN-4C0056 add
   END IF
 
   CALL i202_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i202_show()
  DEFINE l_msg   LIKE ze_file.ze03   #No.FUN-680136 VARCHAR(20)
 
   LET g_pmc_t.* = g_pmc.*           #保存單頭舊值
   DISPLAY BY NAME   g_pmc.pmc01     # 顯示單頭值
   DISPLAY BY NAME   g_pmc.pmc03     # 顯示單頭值
   DISPLAY BY NAME   g_pmc.pmc05     # 顯示單頭值
  #TQC-740210 mark
  #CALL s_stades(g_pmc.pmc05) RETURNING l_msg
  #DISPLAY l_msg TO FORMONLY.desc
 
   CALL i202_b_fill(g_wc2)                 #單身
 
    CALL cl_show_fld_cont()                #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i202_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680136 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用               #No.FUN-680136 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否               #No.FUN-680136 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態                 #No.FUN-680136 VARCHAR(1)
    l_flag          LIKE type_file.chr1,                #判斷必要欄位是否有輸入   #No.FUN-680136 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否                 #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否                 #No.FUN-680136 SMALLINT
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF cl_null(g_pmc.pmc01) THEN
       RETURN
    END IF
 
    IF g_pmc.pmcacti = 'N' THEN
       CALL  cl_err('','mfg3283',0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT pmg02,pmg03 FROM pmg_file",
                       " WHERE pmg01=? AND pmg02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i202_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_pmg WITHOUT DEFAULTS FROM s_pmg.*
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
              BEGIN WORK
              LET p_cmd='u'
              LET g_pmg_t.* = g_pmg[l_ac].*  #BACKUP
 
              OPEN i202_bcl USING g_pmc.pmc01,g_pmg_t.pmg02
              IF STATUS THEN
                 CALL cl_err("OPEN i202_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i202_bcl INTO g_pmg[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_pmg_t.pmg02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_pmg[l_ac].* TO NULL      #900423
           LET g_pmg_t.* = g_pmg[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD pmg02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO pmg_file(pmg01,pmg02,pmg03)
                VALUES(g_pmc.pmc01,g_pmg[l_ac].pmg02,g_pmg[l_ac].pmg03)
           IF SQLCA.sqlcode THEN
#             CALL cl_err(g_pmg[l_ac].pmg02,SQLCA.sqlcode,0)   #No.FUN-660129
              CALL cl_err3("ins","pmg_file",g_pmc.pmc01,g_pmg[l_ac].pmg02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        BEFORE FIELD pmg02                        #default 序號
           IF g_pmg[l_ac].pmg02 IS NULL OR g_pmg[l_ac].pmg02 = 0 THEN
              SELECT max(pmg02)+1
                INTO g_pmg[l_ac].pmg02
                FROM pmg_file
               WHERE pmg01 = g_pmc.pmc01
              IF g_pmg[l_ac].pmg02 IS NULL THEN
                 LET g_pmg[l_ac].pmg02 = 1
              END IF
           END IF
 
        AFTER FIELD pmg02                        #check 序號是否重複
           IF NOT cl_null(g_pmg[l_ac].pmg02) THEN
              IF g_pmg[l_ac].pmg02 != g_pmg_t.pmg02 OR g_pmg_t.pmg02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM pmg_file
                  WHERE pmg01 = g_pmc.pmc01
                    AND pmg02 = g_pmg[l_ac].pmg02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_pmg[l_ac].pmg02 = g_pmg_t.pmg02
                    NEXT FIELD pmg02
                 END IF
              END IF
              LET g_cnt = g_cnt + 1
           END IF
 
        BEFORE DELETE                            #是否取消單身
           IF g_pmg_t.pmg02 > 0 AND g_pmg_t.pmg02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM pmg_file
               WHERE pmg01 = g_pmc.pmc01
                 AND pmg02 = g_pmg_t.pmg02
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_pmg_t.pmg02,SQLCA.sqlcode,0)   #No.FUN-660129
                 CALL cl_err3("del","pmg_file",g_pmc.pmc01,g_pmg_t.pmg02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
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
              LET g_pmg[l_ac].* = g_pmg_t.*
              CLOSE i202_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_pmg[l_ac].pmg02,-263,1)
              LET g_pmg[l_ac].* = g_pmg_t.*
           ELSE
              UPDATE pmg_file SET pmg02=g_pmg[l_ac].pmg02,
                                  pmg03=g_pmg[l_ac].pmg03
               WHERE pmg01=g_pmc.pmc01
                 AND pmg02=g_pmg_t.pmg02
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_pmg[l_ac].pmg02,SQLCA.sqlcode,0)   #No.FUN-660129
                 CALL cl_err3("upd","pmg_file",g_pmc.pmc01,g_pmg_t.pmg02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 LET g_pmg[l_ac].* = g_pmg_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
#          LET l_ac_t = l_ac         #FUN-D30034 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_pmg[l_ac].* = g_pmg_t.*
              #FUN-D30034---add---str---
              ELSE
                 CALL g_pmg.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30034---add---end---
              END IF
              CLOSE i202_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac         #FUN-D30034 add 
           CLOSE i202_bcl
           COMMIT WORK
 
#       ON ACTION CONTROLN
#          CALL i202_b_askkey()
#          EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(pmg02) AND l_ac > 1 THEN
              LET g_pmg[l_ac].* = g_pmg[l_ac-1].*
              SELECT max(pmg02)+1
                INTO g_pmg[l_ac].pmg02
                FROM pmg_file
               WHERE pmg01 = g_pmc.pmc01
              NEXT FIELD pmg02
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
 
    CLOSE i202_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i202_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON pmg02,pmg03 FROM s_pmg[1].pmg02,s_pmg[1].pmg03
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
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
 
    CALL i202_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION i202_b_fill(p_wc2)              #BODY FILL UP
DEFINE
   p_wc2           LIKE type_file.chr1000,      #No.FUN-680136 VARCHAR(200)
   l_flag          LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
   LET g_sql = "SELECT pmg02,pmg03,'' ",
               " FROM pmg_file",
               " WHERE pmg01 ='",g_pmc.pmc01,"' AND ",  #單頭-1
               p_wc2 CLIPPED,                     #單身
               " ORDER BY 1"
   PREPARE i202_pb FROM g_sql
   DECLARE pmg_cs CURSOR FOR i202_pb
 
   CALL g_pmg.clear()
   LET g_cnt = 1
   LET g_rec_b=0
 
   FOREACH pmg_cs INTO g_pmg[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_pmg.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i202_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pmg TO s_pmg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL i202_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i202_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i202_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i202_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i202_fetch('L')
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
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
       ON ACTION related_document  #No.MOD-470518
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
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
 
 
FUNCTION i202_copy()
DEFINE
   l_pmc03 LIKE pmc_file.pmc03,
   l_newno,l_oldno LIKE pmc_file.pmc01 #己存在,欲copy單身的廠商編號
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_pmc.pmc01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INPUT l_newno FROM pmc01
 
      AFTER FIELD pmc01
         IF cl_null(l_newno) THEN
            NEXT FIELD pmc01
         END IF
         #檢查廠商編號是否存在
         SELECT count(*) INTO g_cnt
           FROM pmc_file
          WHERE pmc01 = l_newno AND pmcacti = 'Y'
         IF g_cnt = 0 THEN
            CALL cl_err(l_newno,'mfg3001',0)
            NEXT FIELD pmc01
         END IF
         #檢查是否己有單身資料
         SELECT count(*) INTO g_cnt FROM pmg_file
          WHERE pmg01 = l_newno
         IF g_cnt > 0 THEN
            CALL cl_err(l_newno,-239,0)
            NEXT FIELD pmc01
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
      DISPLAY BY NAME g_pmc.pmc01
      DISPLAY BY NAME g_pmc.pmc03
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM pmg_file         #單身複製
    WHERE pmg01=g_pmc.pmc01
     INTO TEMP x
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_pmc.pmc01,SQLCA.sqlcode,0)   #No.FUN-660129
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      RETURN
   END IF
 
   UPDATE x SET pmg01=l_newno
 
   INSERT INTO pmg_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_pmc.pmc01,SQLCA.sqlcode,0)   #No.FUN-660129
      CALL cl_err3("ins","pmg_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      RETURN
   END IF
 
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_pmc.pmc01
   SELECT pmc01,pmc03 INTO g_pmc.pmc01,g_pmc.pmc03
     FROM pmc_file
    WHERE pmc01 = l_newno
   DISPLAY BY NAME g_pmc.pmc03
 
   CALL i202_b()
   #FUN-C80046---begin
   #LET g_pmc.pmc01=l_oldno
   #
   #SELECT pmc01,pmc03 INTO g_pmc.pmc01,g_pmc.pmc03
   #  FROM pmc_file
   # WHERE pmc01=l_oldno
   #
   #CALL i202_show()
   #FUN-C80046---end
END FUNCTION
 
FUNCTION i202_out()
DEFINE
   l_i             LIKE type_file.num5,          #No.FUN-680136 SMALLINT
   sr              RECORD
       pmc01       LIKE pmc_file.pmc01,          #簽核等級
       pmc03       LIKE pmc_file.pmc03,
       pmg02       LIKE pmg_file.pmg02,          #行序號
       pmg03       LIKE pmg_file.pmg03           #備註
                   END RECORD,
   l_name          LIKE type_file.chr20,         #External(Disk) file name #No.FUN-680136 VARCHAR(20)
   l_za05          LIKE za_file.za05             #No.FUN-680136 VARCHAR(40)
DEFINE l_cmd           LIKE type_file.chr1000         #No.FUN-820002
 
   IF g_wc IS NULL THEN
      CALL cl_err('','9057',0) RETURN END IF
#       CALL cl_err('',-400,0)
#       RETURN
#   END IF
 
#No.FUN-820002--start--
   IF cl_null(g_wc) AND NOT cl_null(g_pmc.pmc01) THEN                                                                               
      LET g_wc = " pmc01 = '",g_pmc.pmc01,"' "                                                                                      
   END IF                                                                                                                           
   IF cl_null(g_wc2) THEN                                                                                                           
       LET g_wc2 = " 1=1"                                                                                                           
   END IF
 
   #報表轉為使用 p_query                                                                                                            
   LET l_cmd = 'p_query "apmi202" "',g_wc CLIPPED,' AND ',g_wc2 CLIPPED,'"'                                                         
   CALL cl_cmdrun(l_cmd)                                                                                                            
   RETURN 
 
#   CALL cl_wait()
#   CALL cl_outnam('apmi202') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT pmc01,pmc03,pmg02,pmg03",
#         " FROM pmc_file,pmg_file ",
#         " WHERE pmc01=pmg01 ",
#         " AND ",g_wc CLIPPED,
#         " AND ",g_wc2 CLIPPED
#   PREPARE i202_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i202_co                         # CURSOR
#       CURSOR FOR i202_p1
 
#   START REPORT i202_rep TO l_name
 
#   FOREACH i202_co INTO sr.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)  
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT i202_rep(sr.*)
#   END FOREACH
 
#   FINISH REPORT i202_rep
 
#   CLOSE i202_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i202_rep(sr)
#DEFINE
#   l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1)
#   l_i             LIKE type_file.num5,          #No.FUN-680136 SMALLINT
#   sr              RECORD
#       pmc01       LIKE pmc_file.pmc01,   #簽核等級
#       pmc03       LIKE pmc_file.pmc03,   #簽核說明
#       pmg02       LIKE pmg_file.pmg02,
#       pmg03       LIKE pmg_file.pmg03
#                   END RECORD
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.pmc01
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<',"/pageno"
#           PRINT g_head CLIPPED,pageno_total
#  #        PRINT                       #TQC-6A0090
#           PRINT g_dash
#           PRINT g_x[31],g_x[32],g_x[33]
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
#       BEFORE GROUP OF sr.pmc01  #等級
#           LET g_cnt=1
#           PRINT COLUMN g_c[31],sr.pmc01,
#                 COLUMN g_c[32],sr.pmc03;
#       ON EVERY ROW
#           PRINT COLUMN g_c[33],sr.pmg03 CLIPPED
 
#       AFTER GROUP OF sr.pmc01
#             SKIP 1 LINE
#       ON LAST ROW
#           PRINT g_dash
#           IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
#              THEN 
##NO.TQC-630166 start--
##             IF g_wc[001,080] > ' ' THEN
##             PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
##                    IF g_wc[071,140] > ' ' THEN
##             PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
##                    IF g_wc[141,210] > ' ' THEN
##             PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
#              CALL cl_prt_pos_wc(g_wc)
##NO.TQC-630166 end--
#             PRINT g_dash
#           END IF
#           LET l_trailer_sw = 'n'
#           #PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[33], g_x[7] CLIPPED #TQC-5B0037 mark
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-8, g_x[7] CLIPPED #TQC-5B0037 add
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash
#               #PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[33], g_x[6] CLIPPED #TQC-5B0037 mark
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED #TQC-5B0037 add
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-820002--end
