# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: apmi206.4gl
# Descriptions...: 供應廠商聯絡資料
# Date & Author..: 01/09/10 By Mandy
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0056 04/12/08 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-4C0095 05/01/07 By Mandy 報表轉XML
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/08/31 By Jackho 欄位類型修改
# Modify.........: No.TQC-6A0090 06/11/07 By baogui 表頭多行空白,結束位置不對齊
# Modify.........: No.FUN-6A0162 06/11/11 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730032 07/03/20 By chenl 網絡銀行功能，本程序新增pmf04,pmf05兩個字段。
# Modify.........: No.TQC-740210 07/04/26 By Mandy 目前狀況pmc05,改用COMBOBOX方式呈式
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760031 07/06/06 By rainy 未使用網銀功能，進入單身時都出現查無資料的錯誤訊息
# Modify.........: No.FUN-870067 08/07/18 By douzh 使匯豐銀行時新增Email錄入
# Modify.........: NO.FUN-870037 08/09/10 by Yiting 配合網銀功能增加顯示欄位 
# Modify.........: No.MOD-910136 09/01/14 By Smapmin pmf09預設為pmf04
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990261 09/10/06 By Smapmin 若由外部傳遞參數執行時,也要做action權限的控管
# Modify.........: No:FUN-970077 09/09/04 By hongmei add pmf11(Extra Code),pmf12
# Modify.........: No.FUN-A20010 10/03/01 By chenmoyan add pmf14/pmf15
# Modify.........: No:TQC-960201 10/11/05 By Sabrina 單身做刪除動作時，應該g_pmf_t.pmf02跟g_pmf_t.pmf03去對應key值
# Modify.........: No:MOD-B10128 11/01/19 By Summer 將nsh_file的相關程式段都拿掉
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-BA0039 11/10/07 By Summer 當pmf08更改狀況,且 g_pmf_t.pmf08 為null 則無法進入判斷
# Modify.........: No:FUN-C30190 12/03/21 By tanxc 將老報表轉成CR報表
# Modify.........: No:TQC-C40270 12/04/28 By yuhuabao 新版大陸網銀無需用到aza74/aza78兩欄位,故MARK掉aza78判斷欄位隱藏中的pmf06、pmf07的部份
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
    g_pmf           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        pmf02       LIKE pmf_file.pmf02,   #銀行代號
        nmt02       LIKE nmt_file.nmt02,   #銀行名稱
        pmf13       LIKE pmf_file.pmf13,   #SWIFT CODE      #No.FUN-A20010
        pmf03       LIKE pmf_file.pmf03,   #銀行帳號
        pmf04       LIKE pmf_file.pmf04,   #帳戶名稱        #No.FUN-730032  
#       pmf10       LIKE pmf_file.pmf10,   #FUN-A20010
        pmf08       LIKE pmf_file.pmf08,   #幣別            #FUN-870037
        pmf09       LIKE pmf_file.pmf09,   #FUN-870037
        pmf14       LIKE pmf_file.pmf14,   #FUN-A20010
        pmf15       LIKE pmf_file.pmf15,   #FUN-A20010
        pmf12       LIKE pmf_file.pmf12,   #FUN-A20010
        pmf11       LIKE pmf_file.pmf11,   #Extra Code      #FUN-A20010
#       pmf05       LIKE pmf_file.pmf05,   #主要銀行帳號    #No.FUN-730032 
        pmf06       LIKE pmf_file.pmf06,   #帳戶Email       #No.FUN-870067
        pmf07       LIKE pmf_file.pmf07,   #附加Email       #No.FUN-870067
        pmf10       LIKE pmf_file.pmf10,   #FUN-A20010
        pmf05       LIKE pmf_file.pmf05,   #主要銀行帳號    #No.FUN-A20010
        pmfacti     LIKE pmf_file.pmfacti  #資料有效碼
                    END RECORD,
    g_pmf_t         RECORD                 #程式變數 (舊值)
        pmf02       LIKE pmf_file.pmf02,   #銀行代號
        nmt02       LIKE nmt_file.nmt02,   #銀行名稱
        pmf13       LIKE pmf_file.pmf13,   #SWIFT CODE      #No.FUN-A20010
        pmf03       LIKE pmf_file.pmf03,   #銀行帳號
        pmf04       LIKE pmf_file.pmf04,   #帳戶名稱        #No.FUN-730032  
#       pmf10       LIKE pmf_file.pmf10,   #FAX             #FUN-A20010
        pmf08       LIKE pmf_file.pmf08,   #幣別            #FUN-870037
        pmf09       LIKE pmf_file.pmf09,   #戶名            FUN-870037
        pmf14       LIKE pmf_file.pmf14,   #FUN-A20010
        pmf15       LIKE pmf_file.pmf15,   #FUN-A20010
        pmf12       LIKE pmf_file.pmf12,   #FUN-A20010
        pmf11       LIKE pmf_file.pmf11,   #Extra Code      #FUN-A20010
#       pmf05       LIKE pmf_file.pmf05,   #主要銀行帳號    #No.FUN-730032 #FUN-A20010
        pmf06       LIKE pmf_file.pmf06,   #帳戶Email       #No.FUN-870067
        pmf07       LIKE pmf_file.pmf07,   #附加Email       #No.FUN-870067
        pmf10       LIKE pmf_file.pmf10,   #FUN-A20010
        pmf05       LIKE pmf_file.pmf05,   #主要銀行帳號    #No.FUN-A20010
        pmfacti     LIKE pmf_file.pmfacti  #資料有效碼
                    END RECORD,
    #g_wc,g_wc2,g_sql   LIKE type_file.chr1000,     #NO.TQC-630166 MARK     #No.FUN-680136 VARCHAR(200)
    g_wc,g_wc2,g_sql    STRING,                     #NO.TQC-630166
    g_wc3               STRING,                     #FUN-C30190 add
    g_rec_b             LIKE type_file.num5,        #目前單身筆數           #No.FUN-680136 SMALLINT
    l_ac                LIKE type_file.num5         #目前處理 ARRAY COUNT   #No.FUN-680136 SMALLINT
 
DEFINE   p_row,p_col    LIKE type_file.num5         #No.FUN-680136 SMALLINT 
DEFINE   g_forupd_sql   STRING                      #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt          LIKE type_file.num10        #No.FUN-680136 INTEGER
DEFINE   g_i            LIKE type_file.num5         #count/index for any purpose   #No.FUN-680136 SMALLINT
DEFINE   g_msg          LIKE ze_file.ze03           #No.FUN-680136 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10        #No.FUN-680136 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10        #No.FUN-680136 INTEGER
DEFINE   g_jump         LIKE type_file.num10        #No.FUN-680136 INTEGER
DEFINE   g_no_ask      LIKE type_file.num5         #No.FUN-680136 SMALLINT
DEFINE   g_success      LIKE type_file.chr1         #No.FUN-730032
 
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
 
   OPEN WINDOW i206_w WITH FORM "apm/42f/apmi206"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
#NO.FUN-870037 mark-----
#  #No.FUN-730032--begin--
#   IF g_aza.aza73 MATCHES'[Nn]' THEN
##     CALL cl_set_comp_visible("pmf04,pmf05",FALSE)                          #No.FUN-870067
#      CALL cl_set_comp_visible("pmf04,pmf05,pmf06,pmf07",FALSE)              #No.FUN-870067
#   ELSE
##     CALL cl_set_comp_visible("pmf04,pmf05",TRUE)                           #No.FUN-870067
#      CALL cl_set_comp_visible("pmf04,pmf05,pmf06,pmf07",TRUE)               #No.FUN-870067
#   END IF
#  #No.FUN-730032--end--
#NO.FUN-870037 mark-----
 
 
   #NO.FUN-870037 start--
#FUN-A20010 --Begin
#  IF g_aza.aza26 <>'2' THEN  #非大陸版 
#     CALL cl_set_comp_visible("pmf06,pmf07",FALSE)  
#  ELSE
#FUN-A20010 --End
      IF g_aza.aza73 = 'N' THEN   #不使用網銀
#         CALL cl_set_comp_visible("pmf06,pmf07",FALSE)  #FUN-A20010
          CALL cl_set_comp_visible("pmf13,pmf08,pmf09,pmf14,pmf15,pmf12,pmf11,pmf05,pmf06,pmf07",FALSE) #FUN-A20010
      ELSE
#         CALL cl_set_comp_visible("pmf06,pmf07",TRUE)   #FUN-A20010
          CALL cl_set_comp_visible("pmf13,pmf08,pmf09,pmf14,pmf15,pmf12,pmf11,pmf05,pmf06,pmf07",TRUE) #FUN-A20010
      END IF
#  END IF   #FUN-A20010
   #NO.FUN-870037 end----
 
   LET g_argv1 = ARG_VAL(1)
   LET g_pmc.pmc01 = g_argv1
 
   IF NOT cl_null(g_argv1) THEN
      #-----MOD-990261---------
      #CALL i206_q()
      #CALL i206_b()
      LET g_action_choice = 'query'
      IF cl_chk_act_auth() THEN
         CALL i206_q()
      END IF 
      LET g_action_choice = 'detail'
      IF cl_chk_act_auth() THEN
         CALL i206_b()
      END IF 
      #-----END MOD-990261-----
   END IF
 
   CALL i206_menu()
   CLOSE WINDOW i206_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i206_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
   IF cl_null(g_argv1) THEN
      CLEAR FORM
      CALL g_pmf.clear()
 
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
 
      #---------NO.FUN-870037 mod-----------
      #CONSTRUCT g_wc2 ON pmf02,pmf03,pmf04,pmf05,pmf06,pmf07,pmfacti  # 螢幕上取單身條件             #No.FUN-730032 add pmf04,pmf05 #No.FUN-870067 add pmf06,pmf07
      #        FROM s_pmf[1].pmf02,s_pmf[1].pmf03,s_pmf[1].pmf04,s_pmf[1].pmf05,s_pmf[1].pmf06,       #No.FUN-870067 add pmf06,pmf07
      #             s_pmf[1].pmf07,s_pmf[1].pmfacti   #No.FUN-730032
#FUN-A20010 --Begin
#     CONSTRUCT g_wc2 ON pmf02,pmf03,pmf04,pmf10,pmf08,pmf09,pmf05,pmf06,pmf07,pmfacti  # 螢幕上取單身條件          
#             FROM s_pmf[1].pmf02,s_pmf[1].pmf03,s_pmf[1].pmf04,
#                  s_pmf[1].pmf10,s_pmf[1].pmf08,s_pmf[1].pmf09,
#                  s_pmf[1].pmf05,s_pmf[1].pmf06,   
#                  s_pmf[1].pmf07,s_pmf[1].pmfacti  
#FUN-A20010 --End
#No.FUN-A20010 --Begin                                                                                                              
      CONSTRUCT g_wc2 ON pmf02,pmf13,pmf03,pmf04,pmf08,pmf09,pmf14,pmf15,pmf12,
                         pmf11,pmf06,pmf07,pmf10,pmf05,pmfacti
              FROM s_pmf[1].pmf02,s_pmf[1].pmf13,s_pmf[1].pmf03,s_pmf[1].pmf04,                                                     
                   s_pmf[1].pmf08,s_pmf[1].pmf09,s_pmf[1].pmf14,s_pmf[1].pmf15,                                                     
                   s_pmf[1].pmf12,s_pmf[1].pmf11,s_pmf[1].pmf06,s_pmf[1].pmf07,                                                     
                   s_pmf[1].pmf10,s_pmf[1].pmf05,s_pmf[1].pmfacti                                                                   
#No.FUN-A20010 --End
      #---------NO.FUN-870037 mod------------
 
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
         ON ACTION controlp
            CASE
               WHEN INFIELD(pmf02)
#                 CALL q_nmt(0,0,g_pmf[1].pmf02) RETURNING g_pmf[1].pmf02
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_nmt"
                  LET g_qryparam.state ="c"
                  LET g_qryparam.default1 = g_pmf[1].pmf02
                  CALL cl_create_qry() RETURNING g_pmf[1].pmf02
                  DISPLAY BY NAME g_pmf[1].pmf02
                  NEXT FIELD pmf02
            #--NO.FUN-870037 START---
            WHEN INFIELD(pmf08) #查詢幣別資料檔
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_azi"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmf08
            END CASE
            #--NO.FUN-870037 end-----
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
                     " ORDER BY pmc01"
      ELSE                              # 若單身有輸入條件
         LET g_sql = "SELECT UNIQUE pmc_file. pmc01 ",
                     "  FROM pmc_file LEFT OUTER JOIN pmf_file ON pmc01 = pmf_file.pmf01",
                     " WHERE ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                     " ORDER BY pmc01"
      END IF
   ELSE
      LET g_wc = " pmc01 = '",g_argv1,"'"
      LET g_wc2 = " 1=1"
      LET g_sql = "SELECT  pmc01 FROM pmc_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY pmc01"
   END IF
 
   PREPARE i206_prepare FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,0)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
   DECLARE i206_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i206_prepare
 
   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM pmc_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(distinct pmc01)",
                " FROM pmc_file,pmf_file WHERE ",
                " pmc01=pmf01 AND ",g_wc CLIPPED,
                " AND ",g_wc2 CLIPPED
   END IF
   PREPARE i206_precount FROM g_sql
   DECLARE i206_count CURSOR FOR i206_precount
 
END FUNCTION
 
FUNCTION i206_menu()
 
   WHILE TRUE
      CALL i206_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i206_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i206_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i206_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pmf),'','')
            END IF
         #No.FUN-6A0162-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_pmc.pmc01 IS NOT NULL THEN
                 LET g_doc.column1 = "pmc01"
                 LET g_doc.value1 = g_pmc.pmc01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0162-------add--------end----
      END CASE
   END WHILE
   CLOSE i206_cs
END FUNCTION
 
FUNCTION i206_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_pmc.* TO NULL             #No.FUN-6A0162
 
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL i206_cs()                          # 宣告 SCROLL CURSOR
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      CALL g_pmf.clear()
      INITIALIZE g_pmc.* TO NULL
      RETURN
   END IF
 
   OPEN i206_count
   FETCH i206_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
 
   OPEN i206_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pmc.pmc01,SQLCA.sqlcode,0)
      INITIALIZE g_pmc.* TO NULL
   ELSE
      CALL i206_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION i206_fetch(p_flag)
   DEFINE
       p_flag          LIKE type_file.chr1,        #No.FUN-680136 VARCHAR(1)
       l_pmcuser       LIKE pmc_file.pmcuser,      #FUN-4C0056 add
       l_pmcgrup       LIKE pmc_file.pmcgrup       #FUN-4C0056 add
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i206_cs INTO g_pmc.pmc01
      WHEN 'P' FETCH PREVIOUS i206_cs INTO g_pmc.pmc01
      WHEN 'F' FETCH FIRST    i206_cs INTO g_pmc.pmc01
      WHEN 'L' FETCH LAST     i206_cs INTO g_pmc.pmc01
      WHEN '/'
            IF (NOT g_no_ask) THEN
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
            FETCH ABSOLUTE g_jump i206_cs INTO g_pmc.pmc01
            LET g_no_ask = FALSE
   END CASE
 
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
      INITIALIZE g_pmc.* TO NULL           #FUN-4C0056 add
   ELSE
      LET g_data_owner = l_pmcuser         #FUN-4C0056 add
      LET g_data_group = l_pmcgrup         #FUN-4C0056 add
      CALL i206_show()                     # 重新顯示
   END IF
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i206_show()
    DEFINE   l_msg   LIKE ze_file.ze03     #No.FUN-680136 VARCHAR(20)
 
    LET g_pmc_t.* = g_pmc.*                      #保存單頭舊值
    DISPLAY BY NAME g_pmc.pmc01,g_pmc.pmc03,g_pmc.pmc05
   #TQC-740210 mark
   #CALL s_stades(g_pmc.pmc05) RETURNING l_msg
   #DISPLAY l_msg TO FORMONLY.desc
 
    CALL i206_b_fill(g_wc2)                 #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i206_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680136 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680136 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680136 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680136 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680136 SMALLINT
DEFINE l_cnt        LIKE type_file.num5                 #NO.FUN-870037
DEFINE l_pmd02_f    LIKE pmd_file.pmd02                 #no.FUN-870037
DEFINE l_pmd03_f    LIKE pmd_file.pmd03                 #no.FUN-870037
DEFINE l_pmc        RECORD LIKE pmc_file.*              #NO.FUN-870037  
#DEFINE l_nsh        RECORD LIKE nsh_file.*              #NO.FUN-870037 #MOD-B10128 mark
DEFINE i            LIKE type_file.num5                 #NO.FUN-870037
 
    LET g_action_choice = ""
    
    LET g_success = 'Y'      #No.FUN-730032
 
    IF g_pmc.pmc01 IS NULL THEN
       RETURN
    END IF
 
    IF g_pmc.pmcacti = 'N' THEN
       CALL  cl_err('','mfg3283',0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    #LET g_forupd_sql = "SELECT pmf02,'',pmf03,pmf04,pmf05,pmf06,pmf07,pmfacti FROM pmf_file",          #No.FUN-730032   #No.FUN-870067 add pmf06,pmf07
#FUN-A20010 --Begin
#   LET g_forupd_sql = "SELECT pmf02,'',pmf03,pmf04,pmf10,pmf08,pmf09,",    #NO.FUN-870037
#                      "       pmf05,pmf06,pmf07,pmfacti ",     #NO.FUN-870037
#                      "  FROM pmf_file",          #No.FUN-730032   #No.FUN-870067 add pmf06,pmf07
#                     #" WHERE pmf01 =? AND pmf02 =? AND pmf03 =? AND pmf04=? AND pmf05=? FOR UPDATE"  #No.FUN-730032   #TQC-760031
#                      " WHERE pmf01 =? AND pmf02 =? AND pmf03 =? FOR UPDATE"  #No.FUN-730032                           #TQC-760031
#FUN-A20010 --End
#No.FUN-A20010 --Begin                                                                                                              
#   LET g_forupd_sql = "SELECT pmf02,'',pmf03,pmf04,pmf10,pmf08,pmf09,",    #NO.FUN-870037                                          
#                      "       pmf05,pmf06,pmf07,pmf11,pmf12,pmfacti ",     #NO.FUN-870037  #FUN-970077 add pmf11,pmf12             
#                      "  FROM pmf_file",          #No.FUN-730032   #No.FUN-870067 add pmf06,pmf07                                  
#                     #" WHERE pmf01 =? AND pmf02 =? AND pmf03 =? AND pmf04=? AND pmf05=? FOR UPDATE"  #No.FUN-730032   #TQC-760031 
#                      " WHERE pmf01 =? AND pmf02 =? AND pmf03 =? FOR UPDATE"  #No.FUN-730032                           #TQC-760031 
    LET g_forupd_sql = "SELECT pmf02,'',pmf13,pmf03,pmf04,pmf08,pmf09,pmf14,pmf15,",                                                
                       "       pmf12,pmf11,pmf06,pmf07,pmf10,pmf05,pmfacti ",                                                       
                       "  FROM pmf_file",                                                                                           
                       " WHERE pmf01 =? AND pmf02 =? AND pmf03 =? FOR UPDATE"                                                       
#No.FUN-A20010 --End
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i206_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_pmf WITHOUT DEFAULTS FROM s_pmf.*
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
             LET g_pmf_t.* = g_pmf[l_ac].*  #BACKUP
 
             OPEN i206_bcl USING g_pmc.pmc01,g_pmf_t.pmf02,g_pmf_t.pmf03
                                            # g_pmf_t.pmf04,g_pmf_t.pmf05  #No.FUN-730032  #TQC-760031 remark
             IF STATUS THEN
                CALL cl_err("OPEN i206_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i206_bcl INTO g_pmf[l_ac].*
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_pmf_t.pmf02,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
 
             SELECT nmt02 INTO g_pmf[l_ac].nmt02 FROM nmt_file
              WHERE nmt01=g_pmf[l_ac].pmf02
             CALL cl_show_fld_cont()     #FUN-550037(smin)
          END IF
          IF g_aza.aza26 = '2' THEN  #大陸版   #FUN-870037 add
              IF g_aza.aza73='Y' THEN          #FUN-870037 add
                  #No.FUN-730032--begin-- add 
                  CALL i206_pmf05_entry()
                  CALL i206_pmf05_noentry() 
                 #No.FUN-730032--end-- add 
              END IF                           #FUN-870037 add
          END IF
#No.FUN-870067--begin
          IF NOT cl_null(g_pmf[l_ac].pmf02) THEN
             CALL i206_pmf02(l_ac)
             IF NOT cl_null(g_errno) THEN
                LET g_pmf[l_ac].pmf02 = g_pmf_t.pmf02
                CALL cl_err('',g_errno,0)
                NEXT FIELD pmf02
             END IF
          END IF
#No.FUN-870067--end
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE g_pmf[l_ac].* TO NULL      #900423
          LET g_pmf[l_ac].pmfacti = 'Y'     #Body default
          LET g_pmf[l_ac].pmf05   = 'N'     #No.FUN-730032
          LET g_pmf[l_ac].pmf11   = ' '     #FUN-A20010
          LET g_pmf[l_ac].pmf12   = 'TW'    #FUN-A20010
          LET g_pmf[l_ac].pmf14   = '197'   #FUN-A20010
          LET g_pmf[l_ac].pmf15   = '1'     #FUN-A20010
          LET g_pmf_t.* = g_pmf[l_ac].*         #新輸入資料
          CALL cl_show_fld_cont()     #FUN-550037(smin)
          NEXT FIELD pmf02
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
          END IF
#誰用大括號注釋的,也不加單號！！！！
#No.FUN-870067--begin
#        { IF NOT cl_null(g_pmf[l_ac].pmf02) THEN
#            CALL i206_pmf02(l_ac)
#            IF NOT cl_null(g_errno) THEN
#               LET g_pmf[l_ac].pmf02 = g_pmf_t.pmf02
#               CALL cl_err('',g_errno,0)
#               NEXT FIELD pmf02
#            END IF
#         END IF
#        }
#No.FUN-870067--begin
 
          #---NO.FUN-A20010 mod---------------
          #INSERT INTO pmf_file (pmf01,pmf02,pmf03,pmf04,pmf05,pmf06,pmf07,pmfacti)       #No.FUN-730032  #No.FUN-870067
          #     VALUES(g_pmc.pmc01,g_pmf[l_ac].pmf02,
          #            g_pmf[l_ac].pmf03,g_pmf[l_ac].pmf04,g_pmf[l_ac].pmf05, #No.FUN-730032  
          #            g_pmf[l_ac].pmf06,g_pmf[l_ac].pmf07,                   #No.FUN-870067
          #            g_pmf[l_ac].pmfacti)
          INSERT INTO pmf_file (pmf01,pmf02,pmf03,pmf04,pmf05,pmf06,pmf07,
                                pmf08,pmf09,pmf10,
                                pmf11,pmf12,pmf13,pmf14,pmf15,pmfacti)  #FUN-970077 add pmf11/12/13/14/15
               VALUES(g_pmc.pmc01,g_pmf[l_ac].pmf02,
                      g_pmf[l_ac].pmf03,g_pmf[l_ac].pmf04,g_pmf[l_ac].pmf05,
                      g_pmf[l_ac].pmf06,g_pmf[l_ac].pmf07,g_pmf[l_ac].pmf08,                 
                      g_pmf[l_ac].pmf09,g_pmf[l_ac].pmf10,
                      g_pmf[l_ac].pmf11,g_pmf[l_ac].pmf12,
                      g_pmf[l_ac].pmf13,g_pmf[l_ac].pmf14,g_pmf[l_ac].pmf15,#FUN-A20010
                      g_pmf[l_ac].pmfacti)
          #---NO.FUN-A20010 mod---------------
          IF SQLCA.sqlcode THEN
#            CALL cl_err(g_pmf[l_ac].pmf02,SQLCA.sqlcode,0)   #No.FUN-660129
             CALL cl_err3("ins","pmf_file",g_pmc.pmc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             COMMIT WORK
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2
          END IF
 
       AFTER FIELD pmf02
#誰用大括號注釋的,也不加單號！！！！
#No.FUN-870067--begin
#       {  IF cl_null(g_pmf[l_ac].pmf02) THEN
#            LET g_pmf[l_ac].pmf02 = g_pmf_t.pmf02
#            CALL cl_err('','aap-099',0)
#            NEXT FIELD pmf02
#         END IF
#        }
#No.FUN-870067--end
          IF NOT cl_null(g_pmf[l_ac].pmf02) THEN
             CALL i206_pmf02(l_ac)
             IF NOT cl_null(g_errno) THEN
                LET g_pmf[l_ac].pmf02 = g_pmf_t.pmf02
                CALL cl_err('',g_errno,0)
                NEXT FIELD pmf02
             END IF
          END IF
 
#FUN-A20010 --Begin
          IF cl_null(g_pmf[l_ac].pmf13) THEN 
             SELECT nmt04
               INTO g_pmf[l_ac].pmf13
               FROM nmt_file
              WHERE nmt01=g_pmf[l_ac].pmf02
          END IF
#FUN-A20010 --End
       AFTER FIELD pmf03
          IF NOT cl_null(g_pmf[l_ac].pmf03) THEN
             IF g_pmf[l_ac].pmf02 != g_pmf_t.pmf02 OR
                g_pmf[l_ac].pmf03 != g_pmf_t.pmf03 OR
                (g_pmf[l_ac].pmf02 IS NOT NULL AND
                 g_pmf_t.pmf02 IS NULL) OR
                (g_pmf[l_ac].pmf03 IS NOT NULL AND
                 g_pmf_t.pmf03 IS NULL) THEN
                SELECT COUNT(*) INTO g_cnt FROM pmf_file
                 WHERE pmf01 = g_pmc.pmc01
                   AND pmf02 = g_pmf[l_ac].pmf02
                   AND pmf03 = g_pmf[l_ac].pmf03
                IF g_cnt > 0 THEN
                   CALL cl_err('','axm-298',0)
                   NEXT FIELD pmf03
                END IF
             END IF
          END IF
 
       #-----MOD-910136---------
       AFTER FIELD pmf04
          IF cl_null(g_pmf[l_ac].pmf09) THEN
             LET g_pmf[l_ac].pmf09 = g_pmf[l_ac].pmf04
             DISPLAY BY NAME g_pmf[l_ac].pmf09
          END IF 
       #-----END MOD-910136-----
 
      #No.FUN-730032--begin--              
       BEFORE FIELD pmf05
          IF g_aza.aza26 = '2' THEN  #大陸版   #FUN-870037 add
              IF g_aza.aza73='Y' THEN          #FUN-870037 add
                  CALL i206_pmf05_entry()
                  CALL i206_pmf05_noentry()
              END IF                           #FUN-870037 add
          END IF                               #FUN-870037 add
 
       ON CHANGE pmf05
       IF g_aza.aza26 = '2' THEN  #大陸版   #FUN-870037 add
           IF g_aza.aza73='Y' THEN
              IF g_pmf[l_ac].pmf05='Y' THEN
                 IF g_pmf[l_ac].pmfacti='N' THEN
                    CALL cl_err('','apm-061',1)
                    LET g_pmf[l_ac].pmf05 = g_pmf_t.pmf05
                    NEXT FIELD pmf05
                 END IF
              END IF 
           END IF
           CALL i206_pmf05_entry()
           CALL i206_pmf05_noentry()
       #---NO.FUN-870037 start-------------
       ELSE
           IF g_pmf[l_ac].pmf05 = 'Y' THEN
               SELECT COUNT(*) INTO l_cnt 
                 FROM pmf_file
                WHERE pmf01 = g_pmc.pmc01
                  AND pmf05= 'Y'
                  AND pmf08 = g_pmf[l_ac].pmf08
                  AND pmfacti = 'Y'
               IF l_cnt > =1 THEN                 #幣別相同者只能有一個為主要帳戶
                  CALL cl_err('','anm1009',1)
                  LET g_pmf[l_ac].pmf05 = 'N'
                  NEXT FIELD pmf05
               END IF
           END IF
       END IF
       #--NO.FUN-870037 end----------------
 
       ON CHANGE pmfacti
         IF g_aza.aza73='Y' THEN 
            IF g_pmf[l_ac].pmfacti='N' THEN
               IF g_pmf[l_ac].pmf05 = 'Y' THEN
                  CALL cl_err('','apm-061',1)
                  LET g_pmf[l_ac].pmf05 = 'N'
                  NEXT FIELD pmfacti
               END IF 
            END IF
         END IF 
      #No.FUN-730032--end--
 
 #--NO.FUN-870037 start----------------------------
      AFTER FIELD pmf08  		        #幣別
         IF NOT cl_null(g_pmf[l_ac].pmf08) THEN
           #IF (g_pmf[l_ac].pmf08 != g_pmf_t.pmf08) THEN #MOD-BA0039 mark
            IF (g_pmf[l_ac].pmf08 != g_pmf_t.pmf08) OR cl_null(g_pmf_t.pmf08) THEN #MOD-BA0039
               CALL i081_pmf08()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_pmf[l_ac].pmf08,g_errno,0)
                  LET g_pmf[l_ac].pmf08 = g_pmf_t.pmf08
                  DISPLAY BY NAME g_pmf[l_ac].pmf08
                  NEXT FIELD pmf08
               END IF
            END IF
         END IF
         LET g_pmf_t.pmf08 = g_pmf[l_ac].pmf08
#--NO.FUN-870037 end------------------------------------
 
       #-----MOD-910136---------
       BEFORE FIELD pmf09
          IF cl_null(g_pmf[l_ac].pmf09) THEN
             LET g_pmf[l_ac].pmf09 = g_pmf[l_ac].pmf04
          END IF 
       #-----END MOD-910136-----
       #FUN-970077---Begin
       AFTER FIELD pmf12
          IF NOT cl_null(g_pmf[l_ac].pmf12) THEN
             SELECT COUNT(*) INTO l_cnt FROM geb_file
              WHERE geb01 = g_pmf[l_ac].pmf12
                AND gebacti= 'Y'
              IF l_cnt = 0 THEN
                 CALL cl_err("","asfi115",0)
                 NEXT FIELD pmf12
              END IF
          END IF
       #FUN-970077---End
#FUN-A20010 --Begin
       AFTER FIELD pmf14
          IF NOT cl_null(g_pmf[l_ac].pmf14) THEN
             SELECT COUNT(*) INTO l_cnt FROM nnc_file
              WHERE nnc01='2' AND nnc02=g_pmf[l_ac].pmf14
             IF l_cnt = 0 THEN
                CALL cl_err('','apm-073',0)
                NEXT FIELD pmf14
             END IF
          END IF
#FUN-A20010 --End
 
       BEFORE DELETE                            #是否取消單身
          IF g_pmf_t.pmf02 IS NOT NULL THEN
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
             DELETE FROM pmf_file
              WHERE pmf01 = g_pmc.pmc01
              #TQC-960201---modify---start---
               #AND pmf02 = g_pmf[l_ac].pmf02
               #AND pmf03 = g_pmf[l_ac].pmf03
                AND pmf02 = g_pmf_t.pmf02
                AND pmf03 = g_pmf_t.pmf03
              #TQC-960201---modify---end---
                #AND pmf04 = g_pmf[l_ac].pmf04  #No.FUN-730032  #TQC-760031 remark
                #AND pmf05 = g_pmf[l_ac].pmf05  #No.FUN-730032  #TQC-760031 remark
             LET g_rec_b = g_rec_b -1
             DISPLAY g_rec_b TO FORMONLY.cn2
             IF SQLCA.SQLERRD[3] = 0 THEN
#               CALL cl_err(g_pmf_t.pmf02,SQLCA.sqlcode,0)   #No.FUN-660129
                CALL cl_err3("del","pmf_file",g_pmc.pmc01,g_pmf[l_ac].pmf02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
             END IF
          END IF
          COMMIT WORK
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_pmf[l_ac].* = g_pmf_t.*
             CLOSE i206_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_pmf[l_ac].pmf02,-263,1)
             LET g_pmf[l_ac].* = g_pmf_t.*
          ELSE
#No.FUN-870067--begin
             IF NOT cl_null(g_pmf[l_ac].pmf02) THEN
                CALL i206_pmf02(l_ac)
                IF NOT cl_null(g_errno) THEN
                   LET g_pmf[l_ac].pmf02 = g_pmf_t.pmf02
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD pmf02
                END IF
             END IF
#誰用大括號注釋的,也不加單號！！！！
#      {      IF NOT cl_null(g_pmf[l_ac].pmf02) THEN
#               CALL i206_pmf02(l_ac)
#               IF NOT cl_null(g_errno) THEN
#                  LET g_pmf[l_ac].pmf02 = g_pmf_t.pmf02
#                  CALL cl_err('',g_errno,0)
#                  NEXT FIELD pmf02
#               END IF
#            END IF
#      }
#No.FUN-870067--end
             UPDATE pmf_file SET pmf02=g_pmf[l_ac].pmf02,
                                 pmf03=g_pmf[l_ac].pmf03,
                                 pmf04=g_pmf[l_ac].pmf04,  #No.FUN-730032
                                 pmf05=g_pmf[l_ac].pmf05,  #No.FUN-730032
                                 pmf06=g_pmf[l_ac].pmf06,  #No.FUN-870067
                                 pmf07=g_pmf[l_ac].pmf07,  #No.FUN-870067
                                 pmf08=g_pmf[l_ac].pmf08,  #no.FUN-870037
                                 pmf09=g_pmf[l_ac].pmf09,  #no.FUN-870037
                                 pmf10=g_pmf[l_ac].pmf10,  #no.FUN-870037
                                 pmf11=g_pmf[l_ac].pmf11,  #FUN-970077 add
                                 pmf12=g_pmf[l_ac].pmf12,  #FUN-970077 add
                                 pmf13=g_pmf[l_ac].pmf13,  #FUN-A20010 add
                                 pmf14=g_pmf[l_ac].pmf14,  #FUN-A20010 add
                                 pmf15=g_pmf[l_ac].pmf15,  #FUN-A20010 add
                                 pmfacti=g_pmf[l_ac].pmfacti
              WHERE pmf01 = g_pmc.pmc01
                AND pmf02 = g_pmf_t.pmf02
                AND pmf03 = g_pmf_t.pmf03
                #AND pmf04 = g_pmf_t.pmf04  #No.FUN-730032  #TQC-760031 remark
                #AND pmf05 = g_pmf_t.pmf05  #No.FUN-730032  #TQC-760031 remark
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_pmf[l_ac].pmf02,SQLCA.sqlcode,0)   #No.FUN-660129
                CALL cl_err3("upd","pmf_file",g_pmc.pmc01,g_pmf_t.pmf02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                LET g_pmf[l_ac].* = g_pmf_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()
#         LET l_ac_t = l_ac    #FUN-D30034 mark
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
                LET g_pmf[l_ac].* = g_pmf_t.*
             #FUN-D30034---add---str---
             ELSE
                CALL g_pmf.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30034---add---end---
             END IF
             CLOSE i206_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac    #FUN-D30034 add
          CLOSE i206_bcl
          COMMIT WORK
 
      #MOD-B10128 mark --start--
      ##--NO.FUN-870037 start---在編輯往來銀行資料時要同時寫入帳號對像檔中---
      #AFTER INPUT
      #   SELECT * INTO l_pmc.*
      #     FROM pmc_file
      #    WHERE pmc01 = g_pmc.pmc01
      #   SELECT COUNT(*) INTO l_cnt 
      #     FROM pmd_file
      #    WHERE pmd01 = g_pmc.pmc01
      #   IF l_cnt > 0  THEN
      #       SELECT pmd02,pmd03 INTO l_pmd02_f,l_pmd03_f   #主要聯絡人/電話
      #         FROM pmd_file
      #        WHERE pmd01 = g_pmc.pmc01
      #          AND pmd05 = 'Y'
      #   END IF
      #   FOR i = 1 TO g_pmf.getLength()
      #       SELECT COUNT(*) INTO l_cnt
      #         FROM nsh_file
      #        WHERE nsh01 = g_pmf[i].pmf02
      #          AND nsh02 = g_pmf[i].pmf03
      #          AND nsh03 = '2'
      #          AND nsh04 = g_pmc.pmc01
      #       IF l_cnt = 0 THEN           
      #           LET l_nsh.nsh01 = g_pmf[i].pmf02
      #           LET l_nsh.nsh02 = g_pmf[i].pmf03
      #           LET l_nsh.nsh03 = '2'
      #           LET l_nsh.nsh04 = g_pmc.pmc01
      #           LET l_nsh.nsh05 = l_pmc.pmc03
      #           LET l_nsh.nsh06 = l_pmc.pmc24
      #           LET l_nsh.nsh07 = g_pmf[i].pmf09
      #           LET l_nsh.nsh08 = '3'
      #           LET l_nsh.nsh09 = l_pmd02_f
      #           LET l_nsh.nsh10 = ' ' 
      #           LET l_nsh.nsh11 = ' '
      #           LET l_nsh.nsh12 = l_pmd03_f
      #           LET l_nsh.nsh13 = ' '
      #           LET l_nsh.nsh14 = g_pmf[i].pmf10 
      #           LET l_nsh.nsh15 = g_pmf[i].pmf06
      # 
      #           INSERT INTO nsh_file (nsh01,nsh02,nsh03,nsh04,nsh05,nsh06,nsh07,
      #                                 nsh08,nsh09,nsh10,nsh11,nsh12,nsh13,nsh14,nsh15)
      #                VALUES(l_nsh.nsh01,l_nsh.nsh02,l_nsh.nsh03,
      #                       l_nsh.nsh04,l_nsh.nsh05,l_nsh.nsh06,
      #                       l_nsh.nsh07,l_nsh.nsh08,l_nsh.nsh09,
      #                       l_nsh.nsh10,l_nsh.nsh11,l_nsh.nsh12,
      #                       l_nsh.nsh13,l_nsh.nsh14,l_nsh.nsh15)
      #           IF SQLCA.sqlcode THEN
      #              CALL cl_err3("ins","nsh_file",g_pmf[i].pmf02,g_pmf[i].pmf03,SQLCA.sqlcode,"","",1) 
      #           END IF
      #       ELSE
      #           UPDATE nsh_file SET nsh07 = g_pmf[i].pmf09,  #戶名
      #                               nsh14 = g_pmf[i].pmf10,  #FAX
      #                               nsh15 = g_pmf[i].pmf06   #主要e-mail
      #            WHERE nsh01 = g_pmf[i].pmf02
      #              AND nsh02 = g_pmf[i].pmf03
      #              AND nsh03 = '2'
      #              AND nsh04 = g_pmc.pmc01
      #           IF SQLCA.sqlcode THEN
      #              CALL cl_err3("upd","nsh_file",g_pmf[i].pmf02,g_pmf[i].pmf03,SQLCA.sqlcode,"","",1) 
      #           END IF
      #       END IF
      #   END FOR 
      ##--NO.FUN-870037 end------------------
      #MOD-B10128 mark --end--
       ON ACTION controlp
          CASE
             WHEN INFIELD(pmf02)
#               CALL q_nmt(0,0,g_pmf[l_ac].pmf02) RETURNING g_pmf[l_ac].pmf02
#               CALL FGL_DIALOG_SETBUFFER( g_pmf[l_ac].pmf02 )
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_nmt"
                LET g_qryparam.default1 = g_pmf[l_ac].pmf02
                CALL cl_create_qry() RETURNING g_pmf[l_ac].pmf02
#                CALL FGL_DIALOG_SETBUFFER( g_pmf[l_ac].pmf02 )
                DISPLAY BY NAME g_pmf[l_ac].pmf02
                NEXT FIELD pmf02
#--NO.FUN-870037 start-------------------------------
            WHEN INFIELD(pmf08) #查詢幣別資料檔
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azi"
               LET g_qryparam.default1 = g_pmf[l_ac].pmf08
               CALL cl_create_qry() RETURNING g_pmf[l_ac].pmf08
               DISPLAY BY NAME g_pmf[l_ac].pmf08
               NEXT FIELD pmf08
            #FUN-970077---Begin                                                                                                     
            WHEN INFIELD(pmf12)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_geb"
               LET g_qryparam.default1 = g_pmf[l_ac].pmf12
               CALL cl_create_qry() RETURNING g_pmf[l_ac].pmf12
               DISPLAY BY NAME g_pmf[l_ac].pmf12
               NEXT FIELD pmf12
            #FUN-970077---End
            WHEN INFIELD(pmf14)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nnc2"
               LET g_qryparam.arg1 = ' '
               LET g_qryparam.default1 = g_pmf[l_ac].pmf14
               CALL cl_create_qry() RETURNING g_pmf[l_ac].pmf14
               DISPLAY BY NAME g_pmf[l_ac].pmf14
               NEXT FIELD pmf14
          END CASE
#--NO.FUN-870037 end----------------------------------
#      ON ACTION CONTROLN
#         CALL i206_b_askkey()
#         EXIT INPUT
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(pmf02) AND l_ac > 1 THEN
             LET g_pmf[l_ac].* = g_pmf[l_ac-1].*
             LET g_pmf[l_ac].pmf05 = 'N'    #No.FUN-730032    
             NEXT FIELD pmf02
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
                             
    CLOSE i206_bcl
    COMMIT WORK
    
   #No.FUN-730032--begin-- 
   #當前筆數不等于零，則判斷pmf05該欄位是否存在值，若不存在則要求用戶必須選擇一筆勾選。
    IF g_rec_b <> 0 THEN            
       CALL i206_pmf05_chk() RETURNING g_success
       IF g_success = 'N' THEN 
          LET g_success = 'Y' 
          CALL i206_b()
       END IF            
    END IF 
              
   #No.FUN-730032--end--   
    
 
END FUNCTION
 
FUNCTION i206_b_askkey()
DEFINE
   l_wc2           LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(200)
 
#FUN-A20010 --Begin
#  CONSTRUCT l_wc2 ON pmf02,pmf03,pmf04,pmf05,pmf06,pmf07,pmf11,pmf12,pmfacti  #No.FUN-730032   #No.FUN-870067 #FUN-970077 add pmf11
#                FROM s_pmf[1].pmf02,s_pmf[1].pmf03,s_pmf[1].pmf04,s_pmf[1].pmf05,  #No.FUN-730032
#                     s_pmf[1].pmf06,s_pmf[1].pmf07,s_pmf[1].pmf11,s_pmf[1].pmf12,  #FUN-970077 add pmf11,pmf12
#                     s_pmf[1].pmfacti
   CONSTRUCT l_wc2 ON pmf02,pmf13,pmf03,pmf04,pmf06,pmf07,pmf14,pmf15,
                      pmf12,pmf11,pmf05,pmfacti
                 FROM s_pmf[1].pmf02,s_pmf[1].pmf13,s_pmf[1].pmf03,s_pmf[1].pmf04,
                      s_pmf[1].pmf06,s_pmf[1].pmf07,s_pmf[1].pmf14,s_pmf[1].pmf15,
                      s_pmf[1].pmf12,s_pmf[1].pmf11,s_pmf[1].pmf05,s_pmf[1].pmfacti
#FUN-A20010 --End
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
 
   CALL i206_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION i206_b_fill(p_wc2)              #BODY FILL UP
DEFINE
   p_wc2           LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(200)
 
   LET g_rec_b = 0
   #LET g_sql = "SELECT pmf02,'',pmf03,pmf04,pmf05,pmf06,pmf07,pmfacti ",   #No.FUN-730032 #No.FUN-870067 add pmf06,pmf07
#No.FUN-A20010 --Begin
#  LET g_sql = "SELECT pmf02,'',pmf03,pmf04,pmf10,pmf08,pmf09,pmf05,",    #no.FUN-870037
#              "    pmf06,pmf07,pmf11,pmf12,pmfacti ",   #no.FUN-870037 #FUN-970077 add pmf11,pmf12
#              " FROM pmf_file",
#              " WHERE pmf01 ='",g_pmc.pmc01,"'",
#              " AND ",p_wc2 CLIPPED,
#              " ORDER BY 1,2"
   LET g_sql = "SELECT pmf02,'',pmf13,pmf03,pmf04,pmf08,pmf09,pmf14,pmf15,pmf12,",
               "       pmf11,pmf06,pmf07,pmf10,pmf05,pmfacti ",
               "  FROM pmf_file",
               " WHERE pmf01 ='",g_pmc.pmc01,"'",
               " AND ",p_wc2 CLIPPED,
               " ORDER BY pmf02,pmf13"                                                                                              
#No.FUN-A20010 --End
 
   PREPARE i206_pb FROM g_sql
 
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,0)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
   DECLARE pmf_cs CURSOR FOR i206_pb
 
   CALL g_pmf.clear()
   LET g_cnt = 1
 
   FOREACH pmf_cs INTO g_pmf[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      SELECT nmt02
        INTO g_pmf[g_cnt].nmt02
        FROM nmt_file
       WHERE nmt01 = g_pmf[g_cnt].pmf02
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
   CALL g_pmf.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i206_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pmf TO s_pmf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL i206_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i206_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i206_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i206_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i206_fetch('L')
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
 
 
FUNCTION i206_pmf02(p_ac)
DEFINE
   p_ac       LIKE type_file.num10,    #No.FUN-680136 INTEGER
   l_nmt12    LIKE nmt_file.nmt12,     #No.FUN-870067
   l_nmtacti  LIKE nmt_file.nmtacti
 
   LET g_errno=''
   SELECT nmt02,nmt12,nmtacti                     #No.FUN-870067
     INTO g_pmf[p_ac].nmt02,l_nmt12,l_nmtacti     #No.FUN-870067
     FROM nmt_file
    WHERE nmt01=g_pmf[p_ac].pmf02
 
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='anm-013' #無此銀行代號, 請重新輸入
                                LET g_pmf[p_ac].nmt02=NULL
                                LET l_nmt12=NULL                    #No.FUN-870067
       WHEN l_nmtacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
#No.FUN-870067--begin
#TQC-C40270 ----- mark ----- begin
#  IF NOT cl_null(g_aza.aza78) AND l_nmt12 = g_aza.aza78 THEN
#     CALL cl_set_comp_entry("pmf06,pmf07",TRUE) 
#     CALL cl_set_comp_required("pmf06,pmf07",TRUE)
#  ELSE
#     CALL cl_set_comp_entry("pmf06,pmf07",FALSE) 
#     CALL cl_set_comp_required("pmf06,pmf07",FALSE)
#  END IF
#TQC-C40270 ----- mark ----- end
#No.FUN-870067--end
END FUNCTION
 
FUNCTION i206_out()
 DEFINE
    l_i             LIKE type_file.num5,   #No.FUN-680136 SMALLINT
    sr              RECORD
        pmc01       LIKE pmc_file.pmc01,   #廠商編號
        pmc03       LIKE pmc_file.pmc03,   #廠商簡稱
        pmf02       LIKE pmf_file.pmf02,   #銀行代號
        nmt02       LIKE nmt_file.nmt02,   #銀行名稱
        pmf03       LIKE pmf_file.pmf03,   #銀行帳號
        pmf04       LIKE pmf_file.pmf04,                #No.FUN-730032
        pmf05       LIKE pmf_file.pmf05                 #No.FUN-730032
                    END RECORD,
    l_name          LIKE type_file.chr20,  #External(Disk) file name  #No.FUN-680136 VARCHAR(20)
    l_za05          LIKE za_file.za05      #No.FUN-680136 VARCHAR(40)
    #FUN-C30190--begin---
    DEFINE l_table    STRING
    DEFINE l_str      STRING
    DEFINE l_cob02           LIKE cob_file.cob02
    DEFINE l_cob021          LIKE cob_file.cob021

    LET g_sql ="pmc01.pmc_file.pmc01,",
               "pmc03.pmc_file.pmc03,",
               "pmf02.pmf_file.pmf02,",
               "nmt02.nmt_file.nmt02,",
               "pmf03.pmf_file.pmf03,",
               "pmf04.pmf_file.pmf04,",
               "pmf05.pmf_file.pmf05"

    LET l_table = cl_prt_temptable('apmi206',g_sql) CLIPPED
    IF l_table = -1 THEN 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM 
    END IF

    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                "      VALUES(?,?,?,?,?, ?,?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
        CALL cl_err("insert_prep:",STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
    END IF

    CALL cl_del_data(l_table)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    #FUN-C30190--end--- 
    
    IF g_wc IS NULL THEN
        CALL cl_err('','9057',0)
        RETURN
    END IF
    CALL cl_wait()
    CALL cl_outnam('apmi206') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT pmc01,pmc03,pmf02,'',pmf03,pmf04,pmf05",    #No.FUN-730032 add pmf04,pmf05
              "  FROM pmc_file,pmf_file",
              " WHERE pmc01=pmf01 ",
              "   AND pmfacti = 'Y' ",
              "   AND ",g_wc CLIPPED
    IF NOT cl_null(g_wc2) THEN
        LET g_sql = g_sql CLIPPED ,
                    " AND ",g_wc2 CLIPPED
    END IF
    PREPARE i206_p1 FROM g_sql                # RUNTIME 編譯
    IF SQLCA.sqlcode THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,0)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM
    END IF
    DECLARE i206_co                         # CURSOR
        CURSOR FOR i206_p1
   #No.FUN-730032--begin--
    IF g_aza.aza73 = 'N' THEN 
       LET g_zaa[36].zaa06 = 'Y'
       LET g_zaa[37].zaa06 = 'Y'
    ELSE 
    	 LET g_zaa[36].zaa06 = 'N'
    	 LET g_zaa[37].zaa06 = 'N'
    END IF 
    CALL cl_prt_pos_len()
   #No.FUN-730032     
    #START REPORT i206_rep TO l_name   #FUN-C30190 mark 
 
    FOREACH i206_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT nmt02 INTO sr.nmt02 FROM nmt_file
         WHERE nmt01 = sr.pmf02
        #OUTPUT TO REPORT i206_rep(sr.*)   #FUN-C30190 mark 
        #FUN-C30190--add--begin---
        EXECUTE insert_prep USING sr.pmc01,sr.pmc03,sr.pmf02,sr.nmt02,sr.pmf03,
                                  sr.pmf04,sr.pmf05
        #FUN-C30190--add--end---
    END FOREACH
 
    #FINISH REPORT i206_rep   #FUN-C30190 mark 
 
    CLOSE i206_co
    ERROR ""
    #FUN-C30190 add---srt---
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," ORDER BY pmc01,pmf02,pmf03"
    CALL cl_wcchp(g_wc,'pmc01,pmc03,pmc05') RETURNING g_wc3
    LET l_str = g_wc3 CLIPPED
    LET g_wc3 = ''
    CALL cl_wcchp(g_wc2,'pmf02,pmf13,pmf03,pmf04,pmf08,pmf09,pmf14,pmf15,pmf12,pmf11,pmf06,pmf07,pmf10,pmf05,pmfacti') RETURNING g_wc3
    LET l_str = l_str CLIPPED," AND ",g_wc3 CLIPPED
    CALL cl_prt_cs3('apmi206','apmi206',g_sql,l_str)
    #FUN-C30190 add---end---
    #CALL cl_prt(l_name,' ','1',g_len)   #FUN-C30190 mark 
 END FUNCTION

#FUN-C30190--mark--begin-- 
#REPORT i206_rep(sr)
# DEFINE
#    l_trailer_sw    LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(1)
#    l_i             LIKE type_file.num5,   #No.FUN-680136 SMALLINT
#    sr              RECORD
#        pmc01       LIKE pmc_file.pmc01,   #廠商編號
#        pmc03       LIKE pmc_file.pmc03,   #廠商簡稱
#        pmf02       LIKE pmf_file.pmf02,   #銀行代號
#        nmt02       LIKE nmt_file.nmt02,   #銀行名稱
#        pmf03       LIKE pmf_file.pmf03,   #銀行帳號
#        pmf04       LIKE pmf_file.pmf04,                #No.FUN-730032
#        pmf05       LIKE pmf_file.pmf05                 #No.FUN-730032
#                    END RECORD
# 
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
# 
#    ORDER BY sr.pmc01,sr.pmf02,sr.pmf03
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#            LET g_pageno = g_pageno + 1
#            LET pageno_total = PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
# #           PRINT                    #TQC-6A0090
#            PRINT g_dash
#            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
# 
#        BEFORE GROUP OF sr.pmc01
#            PRINT COLUMN g_c[31],sr.pmc01,
#                  COLUMN g_c[32],sr.pmc03;
# 
#        ON EVERY ROW
#           PRINT COLUMN g_c[33],sr.pmf02,
#                 COLUMN g_c[34],sr.nmt02,
#                 COLUMN g_c[35],sr.pmf03,
#                 COLUMN g_c[36],sr.pmf04,    #No.FUN-730032
#                 COLUMN g_c[37],sr.pmf05     #No.FUN-730032
# 
#        AFTER GROUP OF sr.pmc01
#           SKIP 1 LINES
# 
#        ON LAST ROW
#            PRINT g_dash
#           IF g_zz05 = 'Y'          # 80:70,140,210      132:120,201
#           THEN
# #NO.TQC-630166 start-- 
# #               IF g_wc[001,080] > ' ' THEN
# #                       PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
# #                IF g_wc[071,140] > ' ' THEN
# #                   PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
# #               IF g_wc[141,210] > ' ' THEN
# #                       PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
#                 CALL cl_prt_pos_wc(g_wc)
# #NO.TQC-630166 end---
#                   PRINT g_dash
#            END IF
#            LET l_trailer_sw = 'n'
#   #        PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[35], g_x[7] CLIPPED   #TQC-6A0090
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED   #TQC-6A0090
# 
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash
#   #            PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[35], g_x[6] CLIPPED   #TQC-6A0090
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED   #TQC-6A0090
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#FUN-C30190--mark--end--
 
#No.FUN-730032--begin--
FUNCTION i206_pmf05_entry()
DEFINE l_cnt    LIKE type_file.num5
 
  IF g_aza.aza73='Y' THEN
     SELECT COUNT(*) INTO l_cnt FROM pmf_file
      WHERE pmf01=g_pmc.pmc01 AND pmf05 = 'Y'
     IF l_cnt = 0 OR g_pmf[l_ac].pmf05 = 'Y'  THEN
        CALL cl_set_comp_entry("pmf05",TRUE)
     END IF
  END IF 
END FUNCTION
 
FUNCTION i206_pmf05_noentry()
DEFINE l_cnt    LIKE type_file.num5
 
  IF g_aza.aza73='Y' THEN
     SELECT COUNT(*) INTO l_cnt FROM pmf_file
      WHERE pmf01=g_pmc.pmc01 AND pmf05='Y'
     IF l_cnt > 0 AND g_pmf[l_ac].pmf05<>'Y' THEN
        CALL cl_set_comp_entry("pmf05",FALSE)
     END IF 
  END IF 
END FUNCTION 
 
#pmf05是否有值
FUNCTION i206_pmf05_chk()
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_success  LIKE type_file.chr1
 
  LET l_success = 'Y'
 
  IF g_aza.aza73='Y' THEN          #使用網銀
     SELECT COUNT(*) INTO l_cnt FROM pmf_file
      WHERE pmf01=g_pmc.pmc01 AND pmf05='Y' 
     IF l_cnt = 0 THEN
        CALL cl_err('','apm-062',1)
        LET l_success = 'N'
     END IF 
  END IF 
 
  RETURN l_success
END FUNCTION 
#No.FUN-730032--end--
 
#--NO.FUN-870037 start--------------
FUNCTION i081_pmf08()  #幣別
   DEFINE   p_cmd       LIKE type_file.chr1, 
            l_azi02     LIKE azi_file.azi02,
            l_aziacti   LIKE azi_file.aziacti
 
   LET g_errno = ' '
   SELECT aziacti,azi02
     INTO l_aziacti,l_azi02
     FROM azi_file WHERE azi01=g_pmf[l_ac].pmf08
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3008'
                                  LET l_aziacti = NULL
        WHEN l_aziacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
END FUNCTION
#--NO.FUN-870037 end----------------------
 
