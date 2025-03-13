# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: apmi201.4gl
# Descriptions...: 供應廠商聯絡資料
# Date & Author..: 91/09/02 By Nora
# Modify.........: 92/11/14 By Apple
# Modify.........: 95/11/01 By Yin
# Modify.........: NO.MOD-470518 BY wiky add cl_doc()功能
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0056 04/12/08 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-4C0095 05/01/07 By Mandy 報表轉XML
# Modify.........: No.TQC-5B0212 05/12/01 By kevin 結束位置調整
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/08/31 By Jackho 欄位類型修改
# Modify.........: No.TQC-6A0090 06/11/07 By baogui 表頭多行空白
# Modify.........: No.FUN-6A0162 06/11/11 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740210 07/04/26 By Mandy 目前狀況pmc05,改用COMBOBOX方式呈式
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-820002 08/02/25 By lutingting 報表轉為使用p_query
# Modify.........: No.FUN-940071 09/07/11 By chenmoyan 增加欄位pmd08
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-960200 10/11/05 By sabrina 單身在刪除時，應該要用g_pmd_t的值，而非用g_pmd[l_ac]的key值欄位
# Modify.........: No:FUN-B30211 11/03/30 By lixiang 加cl_used(g_prog,g_time,2) 
# Modify.........: No:MOD-B80049 11/08/04 By johung 列印功能無法正常列印，remark CALL cl_cmdrun
# Modify.........: No:FUN-D30034 13/04/16 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_pmc     RECORD    pmc01    LIKE pmc_file.pmc01,
                        pmc03    LIKE pmc_file.pmc03,
                        pmc05    LIKE pmc_file.pmc05,
                        pmcacti  LIKE pmc_file.pmcacti
              END RECORD,
    g_pmc_t   RECORD    pmc01    LIKE pmc_file.pmc01,
                        pmc03    LIKE pmc_file.pmc03,
                        pmc05    LIKE pmc_file.pmc05,
                        pmcacti  LIKE pmc_file.pmcacti
              END RECORD,
    g_pmc01_t       LIKE pmc_file.pmc01,
    g_argv1         LIKE pmc_file.pmc01,
    g_pmd           DYNAMIC ARRAY OF RECORD  #程式變數(Program Variables)
        pmd06       LIKE pmd_file.pmd06,     #類別
        pmd02       LIKE pmd_file.pmd02,     #聯絡人
        pmd03       LIKE pmd_file.pmd03,     #聯絡電話
        pmd05       LIKE pmd_file.pmd05,     #主要聯絡人
        pmd08       LIKE pmd_file.pmd08,     #是否寄mail      #No.FUN-940071 add
        pmd04       LIKE pmd_file.pmd04,     #備註
        pmd07       LIKE pmd_file.pmd07      #E-mail
                    END RECORD,
    g_pmd_t         RECORD                   #程式變數 (舊值)
        pmd06       LIKE pmd_file.pmd06,     #類別
        pmd02       LIKE pmd_file.pmd02,     #聯絡人
        pmd03       LIKE pmd_file.pmd03,     #聯絡電話
        pmd05       LIKE pmd_file.pmd05,     #主要聯絡人
        pmd08       LIKE pmd_file.pmd08,     #是否寄mail      #No.FUN-940071 add
        pmd04       LIKE pmd_file.pmd04,     #備註
        pmd07       LIKE pmd_file.pmd07      #E-mail
                    END RECORD,
#    g_wc,g_wc2,g_sql   LIKE type_file.chr1000, #NO.TQC-630166 MARK   #No.FUN-680136 VARCHAR(1000)
    g_wc,g_wc2,g_sql    STRING,                 #NO.TQC-630166 
    g_rec_b             LIKE type_file.num5,    #目前單身筆數         #No.FUN-680136 SMALLINT
    l_ac                LIKE type_file.num5     #目前處理 ARRAY COUNT #No.FUN-680136 SMALLINT
DEFINE p_row,p_col      LIKE type_file.num5     #No.FUN-680136 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQ# Modify.........: No:TQC-960200 
DEFINE   g_cnt          LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose  #No.FUN-680136 SMALLINT
DEFINE   g_msg          LIKE type_file.chr1000  #No.FUN-680136 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE   g_jump         LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5     #No.FUN-680136 SMALLINT
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
 
     CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818
   INITIALIZE g_pmc.* TO NULL
   INITIALIZE g_pmc_t.* TO NULL
   LET p_row = 1 LET p_col = 2
 
   OPEN WINDOW i201_w AT p_row,p_col
     WITH FORM "apm/42f/apmi201"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   LET g_argv1 = ARG_VAL(1)
   LET g_pmc.pmc01 = g_argv1
 
   IF NOT cl_null(g_argv1) THEN
      CALL i201_q()
      CALL i201_b()
   END IF
 
   CALL i201_menu()
   CLOSE WINDOW i201_w

     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818
END MAIN
 
FUNCTION i201_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
   IF cl_null(g_argv1) THEN
      CLEAR FORM
      CALL g_pmd.clear()
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
 
      CONSTRUCT g_wc2 ON pmd06,pmd02,pmd03,pmd05,pmd08,pmd04,pmd07  # 螢幕上取單身條件#No.FUN-940071 ADD pmd08
              FROM s_pmd[1].pmd06,s_pmd[1].pmd02,
                   s_pmd[1].pmd03,s_pmd[1].pmd05,s_pmd[1].pmd08,s_pmd[1].pmd04,       #No.FUN-940071 ADD pmd08
                   s_pmd[1].pmd07
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
 
 
      IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
         LET g_sql = "SELECT  pmc01 FROM pmc_file ",
                     " WHERE ", g_wc CLIPPED,
                     " ORDER BY 1"
      ELSE                              # 若單身有輸入條件
         LET g_sql = "SELECT UNIQUE pmc_file. pmc01 ",
                     "  FROM pmc_file LEFT OUTER JOIN pmd_file ON pmc01 = pmd_file.pmd01 ",
                     " WHERE ",g_wc CLIPPED,
                     " AND ",g_wc2 CLIPPED,
                     " ORDER BY 1"
      END IF
   ELSE
      LET g_wc = " pmc01 = '",g_argv1,"'"
      LET g_wc2 = " 1=1"
      LET g_sql = "SELECT  pmc01 FROM pmc_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY 1"
   END IF
 
   PREPARE i201_prepare FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,0)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   DECLARE i201_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i201_prepare
 
   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM pmc_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(distinct pmc01)",
                " FROM pmc_file,pmd_file WHERE ",
                " pmc01=pmd01 AND ",g_wc CLIPPED,
                " AND ",g_wc2 CLIPPED
   END IF
   PREPARE i201_precount FROM g_sql
   DECLARE i201_count CURSOR FOR i201_precount
 
END FUNCTION
 
FUNCTION i201_menu()
 
   WHILE TRUE
      CALL i201_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i201_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i201_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i201_out()              
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pmd),'','')
            END IF
 
      END CASE
   END WHILE
   CLOSE i201_cs
 
END FUNCTION
 
FUNCTION i201_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_pmc.* TO NULL             #No.FUN-6A0162
 
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL i201_cs()                          # 宣告 SCROLL CURSOR
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      CALL g_pmd.clear()
      INITIALIZE g_pmc.* TO NULL
      RETURN
   END IF
 
   OPEN i201_count
   FETCH i201_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
 
   OPEN i201_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pmc.pmc01,SQLCA.sqlcode,0)
      INITIALIZE g_pmc.* TO NULL
   ELSE
      CALL i201_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION i201_fetch(p_flag)
   DEFINE
       p_flag          LIKE type_file.chr1,        #No.FUN-680136 VARCHAR(1)
       l_pmcuser       LIKE pmc_file.pmcuser,      #FUN-4C0056 add
       l_pmcgrup       LIKE pmc_file.pmcgrup       #FUN-4C0056 add
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i201_cs INTO g_pmc.pmc01
      WHEN 'P' FETCH PREVIOUS i201_cs INTO g_pmc.pmc01
      WHEN 'F' FETCH FIRST    i201_cs INTO g_pmc.pmc01
      WHEN 'L' FETCH LAST     i201_cs INTO g_pmc.pmc01
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
            FETCH ABSOLUTE g_jump i201_cs INTO g_pmc.pmc01
            LET mi_no_ask = FALSE
   END CASE
 
#FUN-4C0056 modify
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pmc.pmc01,SQLCA.sqlcode,0)
      INITIALIZE g_pmc.* TO NULL  #TQC-6B0105
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
 
   SELECT pmc01,pmc03,pmc05,pmcacti,pmcuser,pmcgrup  # 重讀DB,因TEMP有不被更新特性
     INTO g_pmc.*,l_pmcuser,l_pmcgrup FROM pmc_file  #FUN-4C0056 add l_pmcuser,l_pmcgrup
    WHERE pmc01 = g_pmc.pmc01
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_pmc.pmc01,SQLCA.sqlcode,0)   #No.FUN-660129
      CALL cl_err3("sel","pmc_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      INITIALIZE g_pmc.* TO NULL             #FUN-4C0056 add
   ELSE
       LET g_data_owner = l_pmcuser      #FUN-4C0056 add
       LET g_data_group = l_pmcgrup      #FUN-4C0056 add
      CALL i201_show()                      # 重新顯示
   END IF
##
 
END FUNCTION
 
FUNCTION i201_show()
    DEFINE   l_msg   LIKE ze_file.ze03       #No.FUN-680136 VARCHAR(20)
 
    LET g_pmc_t.* = g_pmc.*                      #保存單頭舊值
    DISPLAY BY NAME g_pmc.pmc01,g_pmc.pmc03,g_pmc.pmc05
 
   #TQC-740210 mark
   #CALL s_stades(g_pmc.pmc05) RETURNING l_msg
   #DISPLAY l_msg TO FORMONLY.desc
 
    CALL i201_b_fill(g_wc2)                 #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i201_b()
DEFINE
   l_ac_t          LIKE type_file.num5,       #未取消的ARRAY CNT #No.FUN-680136 SMALLINT
   l_n             LIKE type_file.num5,       #檢查重複用        #No.FUN-680136 SMALLINT
   l_lock_sw       LIKE type_file.chr1,       #單身鎖住否        #No.FUN-680136 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,       #處理狀態          #No.FUN-680136 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,       #可新增否          #No.FUN-680136 SMALLINT
   l_allow_delete  LIKE type_file.num5        #可刪除否          #No.FUN-680136 SMALLINT
 
   LET g_action_choice = ""
   IF cl_null(g_pmc.pmc01) THEN
      RETURN
   END IF
 
   IF g_pmc.pmcacti = 'N' THEN
      CALL cl_err('','mfg3283',0)
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT pmd06,pmd02,pmd03,pmd05,pmd08,pmd04,pmd07",  #No.FUN-940071 ADD pmd08
                      "  FROM pmd_file",
                      " WHERE pmd01 =? AND pmd02 =? AND pmd06 =? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i201_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_pmd WITHOUT DEFAULTS FROM s_pmd.*
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
         IF g_rec_b>=l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_pmd_t.* = g_pmd[l_ac].*  #BACKUP
 
         #  BEGIN WORK
 
            OPEN i201_bcl USING g_pmc.pmc01,g_pmd_t.pmd02,g_pmd_t.pmd06
            IF STATUS THEN
               CALL cl_err("OPEN i201_bcl:", STATUS, 1)
               CLOSE i201_bcl
               ROLLBACK WORK
               RETURN
            END IF
 
            FETCH i201_bcl INTO g_pmd[l_ac].*
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_pmd_t.pmd02,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_pmd[l_ac].* TO NULL      #900423
         LET g_pmd_t.* = g_pmd[l_ac].*         #新輸入資料
         LET g_pmd[l_ac].pmd05 = 'N'           #Default
         LET g_pmd[l_ac].pmd08 = 'N'           #No.FUN-940071 
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD pmd06
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO pmd_file (pmd01,pmd02,pmd03,pmd04,pmd05,pmd06,pmd07,pmd08)  #No.FUN-940071 add pmd08
         VALUES(g_pmc.pmc01,g_pmd[l_ac].pmd02,g_pmd[l_ac].pmd03,
                g_pmd[l_ac].pmd04,g_pmd[l_ac].pmd05,g_pmd[l_ac].pmd06,
                g_pmd[l_ac].pmd07,g_pmd[l_ac].pmd08)                             #No.FUN-940071 add pmd08 
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_pmd[l_ac].pmd02,SQLCA.sqlcode,0)   #No.FUN-660129
            CALL cl_err3("ins","pmd_file",g_pmc.pmc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      AFTER FIELD pmd02                        #check 聯絡人是否重複
         IF (p_cmd = 'a') OR (p_cmd = 'u' AND g_pmd_t.pmd02 != g_pmd[l_ac].pmd02) THEN
            SELECT count(*) INTO l_n
              FROM pmd_file
             WHERE pmd01 = g_pmc.pmc01
               AND pmd02 = g_pmd[l_ac].pmd02
               AND pmd06 = g_pmd[l_ac].pmd06
            IF l_n > 0 THEN
               CALL cl_err('',-239,0)
               LET g_pmd[l_ac].pmd02 = g_pmd_t.pmd02
               NEXT FIELD pmd02
            END IF
         END IF
 
      AFTER FIELD pmd05
         IF NOT cl_null(g_pmd[l_ac].pmd05) THEN
            IF g_pmd[l_ac].pmd05 NOT MATCHES'[YyNn]' THEN
               LET g_pmd[l_ac].pmd05 = g_pmd_t.pmd05
               NEXT FIELD pmd05
            END IF
            IF (p_cmd = 'a' OR ( NOT cl_null(g_pmd_t.pmd05) AND
                g_pmd[l_ac].pmd05 != g_pmd_t.pmd05)) AND
               g_pmd[l_ac].pmd05 = 'Y' THEN    #檢查主要聯絡人是否重覆
               LET l_n = 0
               SELECT COUNT(*) INTO l_n FROM pmd_file
                WHERE pmd01 = g_pmc.pmc01 AND pmd05 IN ('Y','y')
               IF l_n + 1 > 1 THEN
                  LET g_pmd[l_ac].pmd05 = 'N'
                  NEXT FIELD pmd05
               END IF
            END IF
            LET g_pmd_t.pmd05 = g_pmd[l_ac].pmd05
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_pmd_t.pmd02) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM pmd_file
             WHERE pmd01 = g_pmc.pmc01
             #TQC-960200---modify---start---
              #AND pmd02 = g_pmd[l_ac].pmd02
              #AND pmd06 = g_pmd[l_ac].pmd06
               AND pmd02 = g_pmd_t.pmd02
               AND pmd06 = g_pmd_t.pmd06
             #TQC-960200---modify---end---  
            LET g_rec_b = g_rec_b -1
            DISPLAY g_rec_b TO FORMONLY.cn2
 
            IF SQLCA.SQLERRD[3] = 0 THEN
#              CALL cl_err(g_pmd_t.pmd02,SQLCA.sqlcode,0)   #No.FUN-660129
               CALL cl_err3("del","pmd_file",g_pmc.pmc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
            END IF
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_pmd[l_ac].* = g_pmd_t.*
            CLOSE i201_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_pmd[l_ac].pmd02,-263,1)
            LET g_pmd[l_ac].* = g_pmd_t.*
         ELSE
            UPDATE pmd_file SET pmd02=g_pmd[l_ac].pmd02,
                                pmd03=g_pmd[l_ac].pmd03,
                                pmd04=g_pmd[l_ac].pmd04,
                                pmd05=g_pmd[l_ac].pmd05,
                                pmd06=g_pmd[l_ac].pmd06,
                                pmd08=g_pmd[l_ac].pmd08,        #No.FUN-940071 add pmd08 
                                pmd07=g_pmd[l_ac].pmd07
             WHERE pmd01 = g_pmc.pmc01
               AND pmd02 = g_pmd_t.pmd02
               AND pmd06 = g_pmd_t.pmd06
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_pmd[l_ac].pmd02,SQLCA.sqlcode,0)   #No.FUN-660129
               CALL cl_err3("upd","pmd_file",g_pmc.pmc01,g_pmd_t.pmd02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
               LET g_pmd[l_ac].* = g_pmd_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
#        LET l_ac_t = l_ac    #FUN-D30034 mark 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_pmd[l_ac].* = g_pmd_t.*
            #FUN-D30034---add---str---
            ELSE
               CALL g_pmd.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034---add---end---
            END IF
            CLOSE i201_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac    #FUN-D30034 add
         CLOSE i201_bcl
         COMMIT WORK
 
#     ON ACTION CONTROLN
#        CALL i201_b_askkey()
#        EXIT INPUT
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(pmd06) AND l_ac > 1 THEN
            LET g_pmd[l_ac].* = g_pmd[l_ac-1].*
            NEXT FIELD pmd06
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
 
 
   CLOSE i201_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i201_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON pmd02,pmd03,pmd04,pmd07
                  FROM s_pmd[1].pmd02,s_pmd[1].pmd03,
                       s_pmd[1].pmd04,s_pmd[1].pmd07
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
 
    CALL i201_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION i201_b_fill(p_wc2)              #BODY FILL UP
DEFINE
   p_wc2           LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(200)
 
   LET g_rec_b = 0
   LET g_sql = "SELECT pmd06,pmd02,pmd03,pmd05,pmd08,pmd04,pmd07,pmd08", #No.FUN-940071 add pmd08 
               " FROM pmd_file",
               " WHERE pmd01 ='",g_pmc.pmc01,"'",
               " AND ",p_wc2 CLIPPED,                     #單身
               " ORDER BY pmd06,pmd02"
 
   PREPARE i201_pb FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare i201_pb:',SQLCA.sqlcode,1)
      RETURN
   END IF
 
   DECLARE pmd_cs CURSOR FOR i201_pb
 
   CALL g_pmd.clear()
   LET g_cnt = 1
 
   FOREACH pmd_cs INTO g_pmd[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_pmd.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i201_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pmd TO s_pmd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
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
         CALL i201_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i201_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i201_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i201_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i201_fetch('L')
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
 
FUNCTION i201_out()
DEFINE
   l_i             LIKE type_file.num5,   #No.FUN-680136 SMALLINT
   sr              RECORD
       pmc01       LIKE pmc_file.pmc01,   #廠商編號
       pmc03       LIKE pmc_file.pmc03,   #廠商簡稱
       pmd02       LIKE pmd_file.pmd02,   #聯絡人
       pmd03       LIKE pmd_file.pmd03,   #聯絡電話
       pmd04       LIKE pmd_file.pmd04,   #備註
       pmd05       LIKE pmd_file.pmd05,   #主要否
       pmd06       LIKE pmd_file.pmd06,   #類別
       pmd07       LIKE pmd_file.pmd07    #E-mail
                   END RECORD,
   l_name          LIKE type_file.chr20,  #External(Disk) file name #No.FUN-680136 VARCHAR(20)
   l_za05          LIKE za_file.za05      #No.FUN-680136 VARCHAR(40)
DEFINE l_cmd           LIKE type_file.chr1000         #No.FUN-820002
 
   IF g_wc IS NULL THEN
      CALL cl_err('','9057',0) RETURN END IF
#       CALL cl_err('',-400,0)
#       RETURN
#   END IF
 
#No.FUN-820002--start--
   IF cl_null(g_wc) AND NOT cl_null(g_pmc.pmc01) AND NOT cl_null(g_pmc.pmc03)                                                       
      AND cl_null(g_pmc.pmc05) THEN                                                                                                 
      LET g_wc = " pmc01 = '",g_pmc.pmc01,"' AND pmc03 = '",g_pmc.pmc03,                                                            
                 "' AND pmc05 = '",g_pmc.pmc05,"'"                                                                                  
   END IF                                                                                                                           
   IF cl_null(g_wc2) THEN                                                                                                           
       LET g_wc2 = " 1=1"                                                                                                           
   END IF   
 
    #報表轉為使用 p_query                                                                                                           
    LET l_cmd = 'p_query "apmi201" "',g_wc CLIPPED,' AND ',g_wc2 CLIPPED,'"'                                                        
#display l_cmd              #MOD-B80049 mark
    CALL cl_cmdrun(l_cmd)   #MOD-B80049 remark 
    RETURN 
 
#   CALL cl_wait()
#   LET l_name = 'apmi201.out'
#   CALL cl_outnam('apmi201') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT pmc01,pmc03,pmd02,",
#             "pmd03,pmd04,pmd05,pmd06,pmd07",
#             " FROM pmc_file,pmd_file",
#             " WHERE pmc01=pmd01 AND ",g_wc CLIPPED,
#             " AND ",g_wc2 CLIPPED,
#             " ORDER BY 7,1,3 "
#   PREPARE i201_p1 FROM g_sql                # RUNTIME 編譯
#   IF SQLCA.sqlcode THEN
#      CALL cl_err('prepare:',SQLCA.sqlcode,0)  
#      EXIT PROGRAM
#   END IF
#   DECLARE i201_co                         # CURSOR
#       CURSOR FOR i201_p1
 
#   START REPORT i201_rep TO l_name
 
#   FOREACH i201_co INTO sr.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#       END IF
#       OUTPUT TO REPORT i201_rep(sr.*)
#   END FOREACH
 
#   FINISH REPORT i201_rep
 
#   CLOSE i201_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i201_rep(sr)
#DEFINE
#   l_trailer_sw    LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(1)
#   l_i             LIKE type_file.num5,   #No.FUN-680136 SMALLINT
#   sr              RECORD
#       pmc01       LIKE pmc_file.pmc01,   #廠商編號
#       pmc03       LIKE pmc_file.pmc03,   #廠商簡稱
#       pmd02       LIKE pmd_file.pmd02,   #聯絡人
#       pmd03       LIKE pmd_file.pmd03,   #聯絡電話
#       pmd04       LIKE pmd_file.pmd04,   #備註
#       pmd05       LIKE pmd_file.pmd05,   #主要否
#       pmd06       LIKE pmd_file.pmd06,   #類別
#       pmd07       LIKE pmd_file.pmd07    #E-mail
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
#    #      PRINT                        #TQC-6A0090
#           PRINT g_dash
#           PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
 
#       BEFORE GROUP OF sr.pmc01
#           PRINT COLUMN g_c[31],sr.pmc01,
#                 COLUMN g_c[32],sr.pmc03;
 
#       ON EVERY ROW
#          PRINT COLUMN g_c[33],sr.pmd02,
#                COLUMN g_c[34],sr.pmd03,
#                COLUMN g_c[35],sr.pmd07,
#                COLUMN g_c[36],sr.pmd05,
#                COLUMN g_c[37],sr.pmd06,
#                COLUMN g_c[38],sr.pmd04
 
#       AFTER GROUP OF sr.pmc01
#          SKIP 1 LINES
 
#       ON LAST ROW
#           PRINT g_dash
#          IF g_zz05 = 'Y'          # 80:70,140,210      132:120,201
#          THEN 
##NO.TQC-630166 start--
##               IF g_wc[001,080] > ' ' THEN
##                     PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
##               IF g_wc[071,140] > ' ' THEN
##                    PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
##              IF g_wc[141,210] > ' ' THEN
##                    PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
#                CALL cl_prt_pos_wc(g_wc)
##NO.TQC-530166 end--
#                  PRINT g_dash
#           END IF
#           LET l_trailer_sw = 'n'
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9) , g_x[7] CLIPPED #No.TQC-5B0212
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9) , g_x[6] CLIPPED #No.TQC-5B0212
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-820002--end
