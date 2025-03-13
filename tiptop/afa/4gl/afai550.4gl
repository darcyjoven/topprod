# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Pattern name...: afai550.4gl
# Descriptions...: 利息資本化維護作業
# Date & Author..: 98/06/25 By Alan Kuan
# Modify.........: No.9057 04/01/28 Kammy 1.維護分錄底稿改 call s_fsgl
#                                         2.刪除時要刪分錄底稿
# Modify.........: No.MOD-470515 04/07/30 By Nicola 加入"相關文件"功能
# Modify.........: No.MOD-490132 04/09/17 By Kitty  698行SELECT fcx_file加where條件
# Modify.........: No.MOD-490344 04/09/20 By Kitty  control 少display補入
# Modify.........: No.MOD-490441 04/09/29 By Yuna 判斷財產編號,應該是在after field fcx011(附號)後才能做此判斷
# Modify.........: No.FUN-4C0059 04/12/10 By Smapmin 加入權限控管
# Modify.........: NO.FUN-550034 05/05/23 By jackie 單據編號加大
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.TQC-610055 06/06/27 By Smapmin 修改報表列印所傳遞的參數
# Modify.........: No.FUN-680028 06/08/23 By Ray 多帳套修改
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單
# Modify.........: No.FUN-6A0001 06/10/02 By jamie FUNCTION i550_q()一開始應清空g_fcx.*值
# Modify.........: No.FUN-6A0069 06/10/30 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-710112 07/03/27 By Judy 1.財產編號開窗選擇不上，要手工錄入
#                                                 2."月初累計金額"先錄入錯誤值報錯，后錄入正確值報同樣的錯
# Modify.........: No.FUN-740026 07/04/11 By atsea 會計科目加帳套
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-7B0143 07/11/14 By Smapmin 錯誤訊息位置錯誤
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.FUN-850103 08/06/19 By xiaofeizhu 增加"會計分錄產生" action
# Modify.........: No.TQC-950164 09/05/26 By xiaofeizhu 資料無效時，不可刪除
# Modify.........: No.FUN-980003 09/08/10 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0015 09/11/04 By Carrier SQL STANDARDIZE
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-9A0036 10/09/14 By chenmoyan 勾選二套帳時,分錄底稿二的匯率,應依帳別二的設定幣別進行換算
# Modify.........: No.FUN-B10053 11/01/25 By yinhy 科目查询自动过滤
# Modify.........: No.FUN-AB0088 11/04/06 By lixiang 固定资料財簽二功能
# Modify.........: No:FUN-B40056 11/05/11 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No.FUN-B50062 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No:FUN-B60140 11/09/07 By minpp "財簽二二次改善" 追單
# Modify.........: No:FUN-BB0113 11/11/22 By xuxz      處理固資財簽二重測BUG
# Modify.........: No.FUN-D10065 13/01/17 By lujh 所有npq04的给值统一放在s_def_npq3（s_def_npq,s_def_npq5等）的后面
#                                                 判断若npq04 为空.则依原给值方式给值
# Modify.........: No.FUN-D40118 13/05/20 By zhangweib 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_fcx   RECORD LIKE fcx_file.*,
    g_fcx_t RECORD LIKE fcx_file.*,
    g_fcx01_t LIKE fcx_file.fcx01,
     g_wc,g_sql          string  #No.FUN-580092 HCN
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE   g_cnt           LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
 
 
DEFINE   g_chr           LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
DEFINE   g_row_count    LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10        #No.FUN-680070 INTEGER
#CKP3
DEFINE   g_jump         LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE   l_wc,l_cmd     STRING   #TQC-610055
DEFINE   g_bookno1      LIKE aza_file.aza81         #No.FUN-740026                                                                  
DEFINE   g_bookno2      LIKE aza_file.aza82         #No.FUN-740026                                                                  
DEFINE   g_flag         LIKE type_file.chr1         #No.FUN-740026 
DEFINE   g_npp_trn      RECORD LIKE npp_file.*      #No.FUN-850103
DEFINE   g_npq_trn      RECORD LIKE npq_file.*      #No.FUN-850103
 
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5         #No.FUN-680070 SMALLINT
#        l_time          LIKE type_file.chr8         #No.FUN-680070 VARCHAR(8)  #NO.FUN-6A0069
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
 
    LET p_row = ARG_VAL(1)
    LET p_col = ARG_VAL(2)
      CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
    INITIALIZE g_fcx.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM fcx_file WHERE fcx01 = ? AND fcx02 = ? AND fcx03 = ? AND fcx011 = ? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i550_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 3 LET p_col = 14
    OPEN WINDOW i550_w AT p_row,p_col
         WITH FORM "afa/42f/afai550"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    #No.FUN-680028 --begin
  # IF g_aza.aza63 = 'Y' THEN
    IF g_faa.faa31 = 'Y' THEN   #NO.FUN-AB0088
       CALL cl_set_comp_visible("fcx091,fcx101",TRUE)
       CALL cl_set_comp_visible("fcx112,fcx122",TRUE)  #No:FUN-B60140
    ELSE
       CALL cl_set_comp_visible("fcx091,fcx101",FALSE)
       CALL cl_set_comp_visible("fcx112,fcx122",FALSE)  #No:FUN-B60140
    END IF
    #No.FUN-680028 --end
 
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL i550_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i550_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069 
END MAIN
 
FUNCTION i550_curs()
 DEFINE
        l_fak06         LIKE fak_file.fak06,
        l_fak061        LIKE fak_file.fak061,
        l_temp          LIKE fak_file.fak022,
        l_n             LIKE type_file.num5         #No.FUN-680070 SMALLINT
    CLEAR FORM
   INITIALIZE g_fcx.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        fcx01,fcx011,fak06,fak061,fcx02,fcx03,fcx04,fcx05,fcx06,fcx07,
        fcx08,fcx09,
        fcx10,fcx11,fcx12,fcx112,fcx122,   #No:FUN-B60140 加后2个
        fcx13,fcx091,fcx101,fcxuser,fcxgrup,fcxmodu,fcxdate,fcxacti     #No.FUN-680028
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
#No.FUN-740026---begin---
             CALL s_get_bookno(g_fcx.fcx02)
                  RETURNING g_flag,g_bookno1,g_bookno2    
             IF g_flag= '1' THEN        
                CALL cl_err(g_fcx.fcx02,'aoo-801',1 )
                NEXT FIELD fcx02
             END IF 
#No.FUN-740026--end--
        ON ACTION controlp                        # 沿用所有欄位
           CASE
              WHEN INFIELD(fcx01)
#                CALL q_fak(10,3,g_fcx.fcx01,g_fcx.fcx011)
#                     RETURNING g_fcx.fcx01,g_fcx.fcx011
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
#                LET g_qryparam.form = "q_fak"  #TQC-710112
                 LET g_qryparam.form = "q_fak1" #TQC-710112
                 LET g_qryparam.default1 = g_fcx.fcx01
                 LET g_qryparam.default2 = g_fcx.fcx011
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fcx01
                 NEXT FIELD fcx01
 
              WHEN INFIELD(fcx09) # 總帳會計科目查詢
#                CALL q_aag(2,2,g_fcx.fcx09,' ',' ',' ') RETURNING g_fcx.fcx09
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.default1 = g_fcx.fcx09
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fcx09
                 NEXT FIELD fcx09
              WHEN INFIELD(fcx10) # 總帳會計科目查詢
#                CALL q_aag(2,2,g_fcx.fcx10,' ',' ',' ') RETURNING g_fcx.fcx10
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.default1 = g_fcx.fcx10
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fcx10
                 NEXT FIELD fcx10
              #No.FUN-680028 --begin
              WHEN INFIELD(fcx091) # 總帳會計科目查詢
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.default1 = g_fcx.fcx091
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fcx091
                 NEXT FIELD fcx091
              WHEN INFIELD(fcx101) # 總帳會計科目查詢
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.default1 = g_fcx.fcx101
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fcx101
                 NEXT FIELD fcx101
              #No.FUN-680028 --end
              OTHERWISE
                 EXIT CASE
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
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND gebuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND gebgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND gebgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('gebuser', 'gebgrup')
    #End:FUN-980030
 
    LET g_sql="SELECT fcx01,fcx02,fcx03,fcx011 FROM fcx_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY fcx01 "
    PREPARE i550_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i550_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i550_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM fcx_file WHERE ",g_wc CLIPPED
    PREPARE i550_precount FROM g_sql
    DECLARE i550_count CURSOR FOR i550_precount
END FUNCTION
 
FUNCTION i550_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            #No.FUN-680028 --begin
         #  IF g_aza.aza63 = 'Y' THEN
            IF g_faa.faa31 = 'Y' THEN   #NO.FUN-AB0088
               CALL cl_set_act_visible("entry_sheet2",TRUE)
            ELSE
               CALL cl_set_act_visible("entry_sheet2",FALSE)
            END IF
            #No.FUN-680028 --end
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i550_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i550_q()
            END IF
        ON ACTION first
           CALL i550_fetch('F')
        ON ACTION jump
           CALL i550_fetch('/')
        ON ACTION next
            CALL i550_fetch('N')
        ON ACTION previous
            CALL i550_fetch('P')
        ON ACTION last
           CALL i550_fetch('L')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i550_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i550_x()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i550_r()
            END IF
        ON ACTION entry_sheet
            LET g_action_choice="entry_sheet"
            IF cl_chk_act_auth() THEN
               CALL i550_fsgl('0')     #No.FUN-680028
            END IF
        #No.FUN-680028 --begin
        ON ACTION entry_sheet2
            LET g_action_choice="entry_sheet2"
            IF cl_chk_act_auth() THEN
               CALL i550_fsgl('1')
            END IF
        #No.FUN-680028 --end
 
        #No.FUN-850103 --begin
        ON ACTION entry_sheet3                                                                                                      
            LET g_action_choice="entry_sheet3"                                                                                      
            IF cl_chk_act_auth() THEN
              IF NOT cl_null(g_fcx.fcx09) OR NOT cl_null(g_fcx.fcx10) THEN                                                          
                 CALL i550_t()                                                                                                      
              END IF                                                                                               
            END IF        
        #No.FUN-850103 --end
 
        ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth() THEN
               #-----TQC-610055---------
               LET l_wc='fcx01="',g_fcx.fcx01,'"'
               LET l_cmd = "afar550",
                            " '",g_today CLIPPED,"' ''",
                            " '",g_lang CLIPPED,"' 'Y' '' '1'",
                            " '",l_wc CLIPPED,"' '",g_fcx.fcx02,"' '",
                            g_fcx.fcx03,"'"
               CALL cl_cmdrun(l_cmd)
               #CALL cl_cmdrun('afar550')
               #-----END TQC-610055-----
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#           EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION related_document    #No.MOD-470515
          LET g_action_choice="related_document"
          IF cl_chk_act_auth() THEN
             IF g_fcx.fcx01 IS NOT NULL THEN
                LET g_doc.column1 = "fcx01"
                LET g_doc.value1 = g_fcx.fcx01
                CALL cl_doc()
             END IF
          END IF
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
      #FUN-810046
      &include "qry_string.4gl"
 
    END MENU
    CLOSE i550_cs
END FUNCTION
 
 
FUNCTION i550_a()
    MESSAGE ""
    IF s_shut(0) THEN RETURN END IF
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_fcx.* LIKE fcx_file.*
    LET g_fcx01_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_fcx.fcx04 = 0
        LET g_fcx.fcx05 = 0
        LET g_fcx.fcx06 = 0
        LET g_fcx.fcx07 = 0
        LET g_fcx.fcx08 = 0
        LET g_fcx.fcxuser = g_user
        LET g_fcx.fcxoriu = g_user #FUN-980030
        LET g_fcx.fcxorig = g_grup #FUN-980030
        LET g_fcx.fcxgrup = g_grup               #使用者所屬群
        LET g_fcx.fcxdate = g_today
        LET g_fcx.fcxacti = 'Y'
        LET g_fcx.fcxlegal = g_legal          #FUN-980003
        CALL i550_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_fcx.fcx01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO fcx_file VALUES(g_fcx.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_fcx.fcx01,SQLCA.sqlcode,0)   #No.FUN-660136
            CALL cl_err3("ins","fcx_file",g_fcx.fcx01,g_fcx.fcx02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
            CONTINUE WHILE
        ELSE
            LET g_fcx_t.* = g_fcx.*                # 保存上筆資料
            SELECT fcx01,fcx02,fcx03,fcx011 INTO g_fcx.fcx01,g_fcx.fcx02,g_fcx.fcx03,g_fcx.fcx011 FROM fcx_file
                WHERE fcx01 = g_fcx.fcx01
                  AND fcx011= g_fcx.fcx011
                  AND fcx02 = g_fcx.fcx02
                  AND fcx03 = g_fcx.fcx03
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i550_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
        l_fak06         LIKE fak_file.fak06,
        l_fak061        LIKE fak_file.fak061,
        l_temp          LIKE fak_file.fak022,
        l_n             LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
 
    DISPLAY BY NAME
        g_fcx.fcx01,g_fcx.fcx011,g_fcx.fcx02,g_fcx.fcx03,g_fcx.fcx04,
        g_fcx.fcx05,
        g_fcx.fcx06,g_fcx.fcx07,g_fcx.fcx08,g_fcx.fcx09,g_fcx.fcx10,
        g_fcx.fcx11,g_fcx.fcx12,g_fcx.fcx13,g_fcx.fcx091,g_fcx.fcx101,     #No.FUN-680028
        g_fcx.fcx112,g_fcx.fcx122,  #No:FUN-B60140 add
        g_fcx.fcxuser,g_fcx.fcxgrup,g_fcx.fcxmodu,g_fcx.fcxdate,g_fcx.fcxacti
 
    INPUT BY NAME g_fcx.fcxoriu,g_fcx.fcxorig,
        g_fcx.fcx01,g_fcx.fcx011,g_fcx.fcx02,g_fcx.fcx03,g_fcx.fcx04,
        g_fcx.fcx05,
        g_fcx.fcx06,g_fcx.fcx07,g_fcx.fcx08,g_fcx.fcx09,g_fcx.fcx10,
        g_fcx.fcx11,g_fcx.fcx12,g_fcx.fcx112,g_fcx.fcx122,  #No:FUN-B60140 add  fcx112 fcx122
        g_fcx.fcx13,g_fcx.fcx091,g_fcx.fcx101,     #No.FUN-680028
        g_fcx.fcxuser,g_fcx.fcxgrup,g_fcx.fcxmodu,g_fcx.fcxdate,g_fcx.fcxacti
        WITHOUT DEFAULTS
 
       BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i550_set_entry(p_cmd)
            CALL i550_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
#No.FUN-550034 --start--
         CALL cl_set_docno_format("fcx11,fcx112")  #No:FUN-B60140 add fcx112
#No.FUN-550034 ---end---
 
        #No.TQC-9B0015  --Begin
        # #--No.MOD-490441
        #{
        #AFTER FIELD fcx01
        #    IF g_fcx.fcx01 IS NOT NULL THEN
        #       IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
        #         (p_cmd = "u" AND g_fcx.fcx01 != g_fcx01_t) THEN
        #          DECLARE i550_s SCROLL CURSOR FOR
        #           SELECT fak06,fak061,rowid
        #             FROM fak_file
        #             WHERE fak02=g_fcx.fcx01
        #              AND fak022 = '    '
        #          OPEN i550_s
        #          IF SQLCA.sqlcode THEN
        #             CALL cl_err('i550_s',SQLCA.SQLCODE,3) NEXT FIELD fcx01  
        #          ELSE
        #             FETCH FIRST i550_s INTO l_fak06,l_fak061
        #             IF SQLCA.sqlcode THEN
        #                CALL cl_err(g_fcx.fcx01,'afa-134',3) #此財編不存在!   
        #                LET g_fcx.fcx01 = g_fcx01_t
        #                DISPLAY BY NAME g_fcx.fcx01
        #                NEXT FIELD fcx01
        #             ELSE
        #                DISPLAY l_fak06   TO FORMONLY.fak06
        #                DISPLAY l_fak061  TO FORMONLY.fak061
        #             END IF
        #          END IF
        #        END IF
        #      END IF
        #}
        #No.TQC-9B0015  --End  
       AFTER FIELD fcx011
          #--No-MOD-490441---------
          IF g_fcx.fcx01 IS NOT NULL THEN
             IF p_cmd = "a" OR# 若輸入或更改且改KEY
               (p_cmd = "u" AND g_fcx.fcx01 != g_fcx01_t) THEN
                IF cl_null(g_fcx.fcx011) THEN LET g_fcx.fcx011 = ' ' END IF
                DECLARE i550_s SCROLL CURSOR FOR
                 SELECT fak06,fak061 FROM fak_file                         
                   WHERE fak02=g_fcx.fcx01                                       
                     AND fak022 = g_fcx.fcx011
                OPEN i550_s
                IF SQLCA.sqlcode THEN
#                 CALL cl_err('i550_s',SQLCA.SQLCODE,3)    #No.FUN-660136
                  CALL cl_err3("sel","fak_file",g_fcx.fcx01,g_fcx.fcx011,SQLCA.sqlcode,"","i550_s",1)  #No.FUN-660136
                  NEXT FIELD fcx01
                ELSE
                  FETCH FIRST i550_s INTO l_fak06,l_fak061
                  IF SQLCA.sqlcode THEN
                    CALL cl_err(g_fcx.fcx01,'afa-920',3) #此財編不存在!  
                    LET g_fcx.fcx01 = g_fcx01_t
                    LET g_fcx.fcx011= ' '
                    DISPLAY BY NAME g_fcx.fcx011
                    NEXT FIELD fcx01
                  ELSE
                    DISPLAY l_fak06   TO FORMONLY.fak06
                    DISPLAY l_fak061  TO FORMONLY.fak061
                  END IF
                END IF
             END IF
          END IF
         # SELECT COUNT(*) INTO g_cnt FROM fak_file
         #  WHERE fak02  = g_fcx.fcx01
         #    AND fak022 = g_fcx.fcx011
         # IF g_cnt = 0 THEN
         #   #No.+045 010403 by plum
         #   #CALL cl_err(g_fcx.fcx011,'afa-xxx',0)
         #    CALL cl_err(g_fcx.fcx011,'afa-920',0)
         #    NEXT FIELD fcx011
         # END IF
        #--END-----------------------
        AFTER FIELD fcx02
          IF g_fcx.fcx02 IS NOT NULL THEN
             IF g_fcx.fcx02 < 1000 OR g_fcx.fcx02 > 2100 THEN
                CALL cl_err('','afa-370',0)   #年度資料錯誤
                NEXT FIELD fcx02
             END IF
#No.FUN-740026---begin---
             CALL s_get_bookno(g_fcx.fcx02)
                  RETURNING g_flag,g_bookno1,g_bookno2    
             IF g_flag= '1' THEN  
                CALL cl_err(g_fcx.fcx02,'aoo-801',1 )
                NEXT FIELD fcx02
             END IF 
#No.FUN-740026--end--
 
          END IF
 
        AFTER FIELD fcx03
          IF g_fcx.fcx03 IS NOT NULL THEN
             IF g_fcx.fcx03 > 12 OR g_fcx.fcx03 < 1 THEN
                CALL cl_err('','afa-371',0)   #月份資料輸入錯誤!
                NEXT FIELD fcx03
             END IF
             SELECT count(*) INTO l_n FROM fcx_file
               WHERE fcx01=g_fcx.fcx01
                AND fcx011 = g_fcx.fcx011
                AND fcx02 = g_fcx.fcx02
                AND fcx03=g_fcx.fcx03
             IF l_n > 0 THEN                  # Duplicated
                CALL cl_err(g_fcx.fcx01,-239,0)
                DISPLAY BY NAME g_fcx.fcx02
                NEXT FIELD fcx01
             END IF
          END IF
 
#       AFTER FIELD fcx04,fcx05,fcx06,fcx07,fcx08  #TQC-710112
        AFTER FIELD fcx04 #TQC-710112
#         CASE  #TQC-710112
#           WHEN INFIELD(fcx04)   #TQC-710112
           IF NOT cl_null(g_fcx.fcx04) THEN #TQC-710112
            IF g_fcx.fcx04 <0 THEN
               CALL cl_err(g_fcx.fcx04,'afa-040',3)
               NEXT FIELD fcx04
            END IF
           END IF  #TQC-710112
#           WHEN INFIELD(fcx05)  #TQC-710112
        AFTER FIELD fcx05 #TQC-710112 
            IF g_fcx.fcx05 <0 THEN
               CALL cl_err(g_fcx.fcx05,'afa-040',3)
               NEXT FIELD fcx05
            END IF
#           WHEN INFIELD(fcx06)  #TQC-710112
        AFTER FIELD fcx06  #TQC-710112
            IF g_fcx.fcx06 <0 THEN
               CALL cl_err(g_fcx.fcx06,'afa-040',3) #值不可小於 0 !!
               NEXT FIELD fcx06
            END IF
#           WHEN INFIELD(fcx07)  #TQC-710112
        AFTER FIELD fcx07 #TQC-710112 
            IF g_fcx.fcx07 <0 THEN
               CALL cl_err(g_fcx.fcx07,'afa-040',3)
               NEXT FIELD fcx07
            END IF
#           WHEN INFIELD(fcx08)  #TQC-710112
        AFTER FIELD fcx08   #TQC-710112
            IF g_fcx.fcx08 <0 THEN
               CALL cl_err(g_fcx.fcx08,'afa-040',3)
               NEXT FIELD fcx08
            END IF
#         END CASE   #TQC-710112
   
        #No.FUN-680028 --begin
        AFTER FIELD fcx09
          IF NOT cl_null(g_fcx.fcx09) THEN
             SELECT aag01 FROM aag_file
              WHERE aag01 = g_fcx.fcx09
                AND aag00 = g_bookno1        #No.FUN-740026 
             IF STATUS = 100 THEN
                CALL cl_err3("sel","aag_file",g_fcx.fcx09,"","abg-010","","",0)
                #No.FUN-B10053  --Begin
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag"
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_fcx.fcx09
                LET g_qryparam.arg1 = g_bookno1
                LET g_qryparam.where = " aag01 LIKE '",g_fcx.fcx09 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_fcx.fcx09
                DISPLAY BY NAME g_fcx.fcx09
                #No.FUN-B10053  --End
                NEXT FIELD fcx09
             END IF
          END IF
             
        AFTER FIELD fcx10
          IF NOT cl_null(g_fcx.fcx10) THEN
             SELECT aag01 FROM aag_file
              WHERE aag01 = g_fcx.fcx10
                AND aag00 = g_bookno1        #No.FUN-740026 
             IF STATUS = 100 THEN
                CALL cl_err3("sel","aag_file",g_fcx.fcx10,"","abg-010","","",0)
                #No.FUN-B10053  --Begin
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag"
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_fcx.fcx10
                LET g_qryparam.arg1 = g_bookno1
                LET g_qryparam.where = " aag01 LIKE '",g_fcx.fcx10 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_fcx.fcx10
                DISPLAY BY NAME g_fcx.fcx10
                #No.FUN-B10053  --End
                NEXT FIELD fcx10
             END IF
          END IF
             
        AFTER FIELD fcx091
          IF NOT cl_null(g_fcx.fcx091) THEN
             SELECT aag01 FROM aag_file
              WHERE aag01 = g_fcx.fcx091
                #AND aag00 = g_bookno2        #No.FUN-740026 #FUn-BB0113 mark 
                AND aag00 = g_faa.faa02c   #FUN-BB0113 add
             IF STATUS = 100 THEN
                CALL cl_err3("sel","aag_file",g_fcx.fcx091,"","abg-010","","",0)
                #No.FUN-B10053  --Begin
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag"
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_fcx.fcx091
                #LET g_qryparam.arg1 = g_bookno2 #FUn-BB0113 mark
                LET g_qryparam.arg1 = g_faa.faa02c   #FUN-BB0113 add 
                LET g_qryparam.where = " aag01 LIKE '",g_fcx.fcx091 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_fcx.fcx091
                DISPLAY BY NAME g_fcx.fcx091
                #No.FUN-B10053  --End
                NEXT FIELD fcx091
             END IF
          END IF
             
        AFTER FIELD fcx101
          IF NOT cl_null(g_fcx.fcx101) THEN
             SELECT aag01 FROM aag_file
              WHERE aag01 = g_fcx.fcx101
                #AND aag00 = g_bookno2        #No.FUN-740026#FUn-BB0113 mark
                AND aag00 = g_faa.faa02c   #FUN-BB0113 add 
             IF STATUS = 100 THEN
                CALL cl_err3("sel","aag_file",g_fcx.fcx101,"","abg-010","","",0)
                #No.FUN-B10053  --Begin
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag"
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_fcx.fcx101
                #LET g_qryparam.arg1 = g_bookno2#FUn-BB0113 mark
                LET g_qryparam.arg1 = g_faa.faa02c   #FUN-BB0113 add
                LET g_qryparam.where = " aag01 LIKE '",g_fcx.fcx101 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_fcx.fcx101
                DISPLAY BY NAME g_fcx.fcx101
                #No.FUN-B10053  --End
                NEXT FIELD fcx101
             END IF
          END IF
        #No.FUN-680028 --end
             
        ON ACTION controlp                        # 沿用所有欄位
           CASE
              WHEN INFIELD(fcx01)
                 CALL cl_init_qry_var()
#                LET g_qryparam.form = "q_fak"  #TQC-710112
                 LET g_qryparam.form = "q_fak1" #TQC-710112
                 LET g_qryparam.default1 = g_fcx.fcx01
                 LET g_qryparam.default2 = g_fcx.fcx011
                 CALL cl_create_qry() RETURNING g_fcx.fcx01,g_fcx.fcx011
#               CALL FGL_DIALOG_SETBUFFER( g_fcx.fcx01 )
#               CALL FGL_DIALOG_SETBUFFER( g_fcx.fcx011 )
#               CALL q_fak(10,3,g_fcx.fcx01,g_fcx.fcx011)
#                                    RETURNING g_fcx.fcx01,g_fcx.fcx011
#               CALL FGL_DIALOG_SETBUFFER( g_fcx.fcx01 )
#               CALL FGL_DIALOG_SETBUFFER( g_fcx.fcx011 )
                 DISPLAY BY NAME g_fcx.fcx01,g_fcx.fcx011
#TQC-710112.....begin
                IF NOT cl_null(g_fcx.fcx011) THEN
                  SELECT fak06,fak061
                    INTO l_fak06,l_fak061
                    FROM fak_file
                   WHERE fak02=g_fcx.fcx01
                     AND fak022=g_fcx.fcx011
                ELSE
                  SELECT fak06,fak061                                           
                    INTO l_fak06,l_fak061                                       
                    FROM fak_file                                               
                   WHERE fak02=g_fcx.fcx01
                     AND fak022 = ' '
                END IF
               #   SELECT fak06,fak061                                           
               #     INTO l_fak06,l_fak061                                       
               #     FROM fak_file                                               
               #    WHERE fak02=g_fcx.fcx01                                      
               #      AND fak022=g_fcx.fcx011
#TQC-710112.....end
                  IF SQLCA.sqlcode=0 THEN
                     DISPLAY l_fak06   TO FORMONLY.fak06
                     DISPLAY l_fak061 TO FORMONLY.fak061
                  ELSE
                      LET g_fcx.fcx01 = g_fcx01_t
                      DISPLAY BY NAME g_fcx.fcx01
                      CALL cl_err(g_fcx.fcx01,'afa-911',0)  #TQC-710112   #MOD-7B0143
                      NEXT FIELD fcx01
                  END IF
                  #CALL cl_err(g_fcx.fcx01,'afa-911',0)  #TQC-710112   #MOD-7B0143
                  NEXT FIELD fcx01
 
              WHEN INFIELD(fcx09) # 總帳會計科目查詢
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.default1 = g_fcx.fcx09
                 LET g_qryparam.arg1 = g_bookno1    #No.FUN-740026
                 CALL cl_create_qry() RETURNING g_fcx.fcx09
#               CALL q_aag(2,2,g_fcx.fcx09,' ',' ',' ') RETURNING g_fcx.fcx09
#               CALL FGL_DIALOG_SETBUFFER( g_fcx.fcx09 )
                  DISPLAY BY NAME g_fcx.fcx09                 #No.MOD-490344
                 NEXT FIELD fcx09
 
              WHEN INFIELD(fcx10) # 總帳會計科目查詢
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.default1 = g_fcx.fcx10 
                 LET g_qryparam.arg1 = g_bookno1    #No.FUN-740026
                 CALL cl_create_qry() RETURNING g_fcx.fcx10
#               CALL q_aag(2,2,g_fcx.fcx10,' ',' ',' ') RETURNING g_fcx.fcx10
#               CALL FGL_DIALOG_SETBUFFER( g_fcx.fcx10 )
                  DISPLAY BY NAME g_fcx.fcx10                 #No.MOD-490344
                 NEXT FIELD fcx10
              #No.FUN-680028 --begin
              WHEN INFIELD(fcx091) # 總帳會計科目查詢
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.default1 = g_fcx.fcx091
                 #LET g_qryparam.arg1 = g_bookno2    #No.FUN-740026#FUn-BB0113 mark
                 LET g_qryparam.arg1 = g_faa.faa02c   #FUN-BB0113 add
                 CALL cl_create_qry() RETURNING g_fcx.fcx091
                  DISPLAY BY NAME g_fcx.fcx091
                 NEXT FIELD fcx091
 
              WHEN INFIELD(fcx101) # 總帳會計科目查詢
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.default1 = g_fcx.fcx101
                 #LET g_qryparam.arg1 = g_bookno2    #No.FUN-740026#FUn-BB0113 mark
                 LET g_qryparam.arg1 = g_faa.faa02c   #FUN-BB0113 add
                 CALL cl_create_qry() RETURNING g_fcx.fcx101
                  DISPLAY BY NAME g_fcx.fcx101
                 NEXT FIELD fcx101
              #No.FUN-680028 --end
              OTHERWISE
                 EXIT CASE
           END CASE
 
        #MOD-650015 --start 
       # ON ACTION CONTROLO                        # 沿用所有欄位
       #     IF INFIELD(fcx01) THEN
       #         LET g_fcx.* = g_fcx_t.*
       #         CALL i550_show()
       #         NEXT FIELD fcx01
       #     END IF
        #MOD-650015 --end
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
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
END FUNCTION
 
FUNCTION i550_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_fcx.* TO NULL             #No.FUN-6A0001    
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i550_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i550_count
    FETCH i550_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i550_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fcx.fcx01,SQLCA.sqlcode,0)
        INITIALIZE g_fcx.* TO NULL
    ELSE
        CALL i550_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i550_fetch(p_flfcx)
    DEFINE
        p_flfcx          LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
        l_abso          LIKE type_file.num10        #No.FUN-680070 INTEGER
 
    CASE p_flfcx
        WHEN 'N' FETCH NEXT     i550_cs INTO g_fcx.fcx01,g_fcx.fcx02,g_fcx.fcx03,g_fcx.fcx011
        WHEN 'P' FETCH PREVIOUS i550_cs INTO g_fcx.fcx01,g_fcx.fcx02,g_fcx.fcx03,g_fcx.fcx011
        WHEN 'F' FETCH FIRST    i550_cs INTO g_fcx.fcx01,g_fcx.fcx02,g_fcx.fcx03,g_fcx.fcx011
        WHEN 'L' FETCH LAST     i550_cs INTO g_fcx.fcx01,g_fcx.fcx02,g_fcx.fcx03,g_fcx.fcx011
        WHEN '/'
         #CKP3
         IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump #CKP3
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
         #CKP3
         END IF
         FETCH ABSOLUTE g_jump i550_cs INTO g_fcx.fcx01,g_fcx.fcx02,g_fcx.fcx03,g_fcx.fcx011
         LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fcx.fcx01,SQLCA.sqlcode,0)
        INITIALIZE g_fcx.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flfcx
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump #CKP3
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_fcx.* FROM fcx_file            # 重讀DB,因TEMP有不被更新特性
       WHERE fcx01 = g_fcx.fcx01 AND fcx02 = g_fcx.fcx02 AND fcx03 = g_fcx.fcx03 AND fcx011 = g_fcx.fcx011
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_fcx.fcx01,SQLCA.sqlcode,0)   #No.FUN-660136
        CALL cl_err3("sel","fcx_file",g_fcx.fcx01,g_fcx.fcx02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
    ELSE
        LET g_data_owner = g_fcx.fcxuser   #FUN-4C0059
        LET g_data_group = g_fcx.fcxgrup   #FUN-4C0059
        CALL i550_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i550_show()
    DEFINE
        l_fak06        LIKE fak_file.fak06,
        l_fak061      LIKE fak_file.fak061
    LET g_fcx_t.* = g_fcx.*
#   DISPLAY BY NAME g_fcx.*   #FUN-980003 不能用此方式
    DISPLAY BY NAME g_fcx.fcx01,g_fcx.fcx011,g_fcx.fcx02,g_fcx.fcx03,   g_fcx.fcxoriu,g_fcx.fcxorig,
            g_fcx.fcx04,g_fcx.fcx05,g_fcx.fcx06,g_fcx.fcx07,g_fcx.fcx08,  
            g_fcx.fcx09,g_fcx.fcx10,g_fcx.fcx11,g_fcx.fcx12,g_fcx.fcx13, 
            g_fcx.fcxacti,g_fcx.fcxuser,g_fcx.fcxgrup,g_fcx.fcxmodu,g_fcx.fcxdate, 
            g_fcx.fcx091,g_fcx.fcx101   
 
    SELECT fak06,fak061 INTO l_fak06,l_fak061
       FROM fak_file
       WHERE fak02=g_fcx.fcx01
         AND fak022=g_fcx.fcx011
    DISPLAY l_fak06   TO FORMONLY.fak06
    DISPLAY l_fak061 TO FORMONLY.fak061
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i550_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_fcx.fcx01 IS NULL THEN
#       CALL cl_err('','afa-091',0)          #No.FUN-6A0001 
        CALL cl_err('',-400,0)               #No.FUN-6A0001
        RETURN
    END IF
    SELECT * INTO g_fcx.* FROM fcx_file WHERE fcx01 = g_fcx.fcx01 AND fcx02 = g_fcx.fcx02 AND fcx03 = g_fcx.fcx03 AND fcx011 = g_fcx.fcx011
    IF NOT cl_null(g_fcx.fcx11) OR NOT cl_null(g_fcx.fcx112) THEN  #No:FUN-B60140
       CALL cl_err('','afa-311',0) RETURN
    END IF
    IF g_fcx.fcxacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_fcx_t.*=g_fcx.*
    BEGIN WORK
 
    OPEN i550_cl USING g_fcx.fcx01,g_fcx.fcx02,g_fcx.fcx03,g_fcx.fcx011
 
    IF STATUS THEN
       CALL cl_err("OPEN i550_cl:", STATUS, 1)
       CLOSE i550_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i550_cl INTO g_fcx.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fcx.fcx01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_fcx.fcxmodu=g_user                     #修改者
    LET g_fcx.fcxdate = g_today                  #修改日期
    CALL i550_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i550_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_fcx.*=g_fcx_t.*
            CALL i550_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE fcx_file SET fcx_file.* = g_fcx.*    # 更新DB
            WHERE fcx01 = g_fcx.fcx01 AND fcx02 = g_fcx.fcx02 AND fcx03 = g_fcx.fcx03 AND fcx011 = g_fcx.fcx011             # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_fcx.fcx01,SQLCA.sqlcode,0)   #No.FUN-660136
            CALL cl_err3("upd","fcx_file",g_fcx01_t,g_fcx_t.fcx02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i550_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i550_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_fcx.fcx01 IS NULL THEN
#       CALL cl_err('','afa-091',0)           #No.FUN-6A0001 
        CALL cl_err('',-400,0)                #No.FUN-6A0001
        RETURN
    END IF
    IF NOT cl_null(g_fcx.fcx11) OR NOT cl_null(g_fcx.fcx112) THEN   #No:FUN-B60140
       CALL cl_err('','afa-311',0) RETURN
    END IF
    BEGIN WORK
 
    OPEN i550_cl USING g_fcx.fcx01,g_fcx.fcx02,g_fcx.fcx03,g_fcx.fcx011
 
    IF STATUS THEN
       CALL cl_err("OPEN i550_cl:", STATUS, 1)
       CLOSE i550_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i550_cl INTO g_fcx.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_fcx.fcx01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i550_show()
    IF cl_exp(0,0,g_fcx.fcxacti) THEN
        LET g_chr=g_fcx.fcxacti
        IF g_fcx.fcxacti='Y' THEN
            LET g_fcx.fcxacti='N'
        ELSE
            LET g_fcx.fcxacti='Y'
        END IF
        UPDATE fcx_file
            SET fcxacti=g_fcx.fcxacti
            WHERE fcx01 = g_fcx.fcx01 AND fcx02 = g_fcx.fcx02 AND fcx03 = g_fcx.fcx03 AND fcx011 = g_fcx.fcx011
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_fcx.fcx01,SQLCA.sqlcode,0)   #No.FUN-660136
            CALL cl_err3("upd","fcx_file",g_fcx.fcx01,g_fcx.fcx02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
            LET g_fcx.fcxacti=g_chr
        END IF
        DISPLAY BY NAME g_fcx.fcxacti
    END IF
    CLOSE i550_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i550_fsgl(p_npptype)
DEFINE p_trno    LIKE npp_file.npp01      #No:9057
DEFINE p_npptype LIKE npp_file.npptype    #No.FUN-680028
 
    IF g_fcx.fcx01 IS NULL THEN RETURN END IF
 #No.9057
    SELECT * INTO g_fcx.* FROM fcx_file
      #No.FUN-680028--begin-fcx條件有錯
#     WHERE fcx01 = g_fcx.fcx01 AND fcx=g_fcx.fcx02    #No.MOD-490132
#      AND fcx=g_fcx.fcx03
      WHERE fcx01 = g_fcx.fcx01 AND fcx02=g_fcx.fcx02    #No.MOD-490132
       AND fcx03=g_fcx.fcx03
       AND fcx011=g_fcx.fcx011
      #No.FUN-680028--end
 
    LET p_trno[1,10]=g_fcx.fcx01
    LET p_trno[11,16]=g_fcx.fcx02 USING '&&&&', g_fcx.fcx03 USING '&&'
    #No.FUN-680028 --begin
    IF p_npptype = '0' THEN
       CALL s_fsgl('FA','11',p_trno,0,g_faa.faa02b,0,'N','0',g_faa.faa02p)
    ELSE  
       CALL s_fsgl('FA','11',p_trno,0,g_faa.faa02c,0,'N','1',g_faa.faa02p)
    END IF
    #No.FUN-680028 --end
  # LET g_wc = "afai104 ",
  #            " 'FA'",
  #            " '11'",
  #            " '",g_fcx.fcx01,"'"
  # CALL cl_cmdrun(g_wc CLIPPED)
    #No.9057(end)
END FUNCTION
 
#No.FUN-850103 --begin
#--------------------------------------------------------------                                                                 
# 產生分錄底稿 ------------ 借方科目=fcx09(預付設備科目)                                                                        
#                           貸方科目=fcx10(利息支出科目)                                                                        
#                           金額    =fcx06(利息資本化金額)                                                                      
#--------------------------------------------------------------
FUNCTION i550_t()
DEFINE        
    l_npp01  LIKE npp_file.npp01,          
    l_b_bdate       LIKE type_file.dat,                    
    l_b_edate       LIKE type_file.dat
   DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
   DEFINE l_flag        LIKE type_file.chr1    #No.FUN-D40118   Add
 
          LET g_success = 'Y'
 
          LET g_npp_trn.nppsys ='FA'
          LET g_npp_trn.npp00  =11
          LET g_npp_trn.npp01  =g_fcx.fcx01
          #---------------------------------------------
          CALL s_mothck(MDY(g_fcx.fcx03,1,g_fcx.fcx02))
               RETURNING l_b_bdate,l_b_edate
          #---------------------------------------------
          LET g_npp_trn.npp02  =l_b_edate
          LET g_npp_trn.npp03  =NULL
          LET g_npp_trn.npp04  =''
          LET g_npp_trn.npp05  =''
          LET g_npp_trn.npp06  =''
          LET g_npp_trn.npp07  =''
          LET g_npp_trn.nppglno =''
          LET g_npp_trn.npptype = '0'    
         LET l_npp01[1,10] = g_fcx.fcx01
         LET l_npp01[11,16]= g_fcx.fcx02 USING '&&&&',g_fcx.fcx03 USING '&&'
         LET g_npp_trn.npp01 = l_npp01
 
         LET g_npp_trn.npplegal = g_legal          #FUN-980003
 
         DELETE FROM npp_file WHERE nppsys = 'FA'    AND npp00 ='11'
                                AND npp01  = l_npp01 AND npp011=0
                                AND npptype='0'  
         DELETE FROM npq_file WHERE npqsys = 'FA'    AND npq00 ='11'
                                AND npq01  = l_npp01 AND npq011=0
                                AND npqtype='0'  

         #FUN-B40056--add--str--
         DELETE FROM tic_file WHERE tic04 = l_npp01
         #FUN-B40056--add--end--

         LET g_npp_trn.npp011 = 0
 
         INSERT INTO npp_file VALUES(g_npp_trn.*)
          IF STATUS THEN 
             LET g_showmsg = g_npp_trn.npp01,"/",g_npp_trn.npp011,"/",g_npp_trn.nppsys,"/",g_npp_trn.npp00 
             CALL s_errmsg('npp01,npp011,nppsys,npp00',g_showmsg,'ins npp',STATUS,1)                       
             LET g_success = 'N'
          END IF
    #--借 -------------------------------------------------
          LET g_npq_trn.npqsys = 'FA'
          LET g_npq_trn.npq00  = 11
          LET g_npq_trn.npq01  = l_npp01      
          LET g_npq_trn.npq011 = 0            
          LET g_npq_trn.npq02  = 1
          LET g_npq_trn.npq03  = g_fcx.fcx09
          LET g_npq_trn.npq04  = ''
          LET g_npq_trn.npq05  = ''
          LET g_npq_trn.npq06  = 1
          LET g_npq_trn.npq07f = g_fcx.fcx06
          LET g_npq_trn.npq07  = g_fcx.fcx06
          LET g_npq_trn.npq08  = ''
          LET g_npq_trn.npq11  = ''
          LET g_npq_trn.npq12  = ''
          LET g_npq_trn.npq13  = ''
          LET g_npq_trn.npq14  = ''
          LET g_npq_trn.npq15  = ''
          LET g_npq_trn.npq21  = ''
          LET g_npq_trn.npq22  = ''
          LET g_npq_trn.npq23  = ''
          LET g_npq_trn.npq24  = g_aza.aza17
          LET g_npq_trn.npq25  = 1
          LET g_npq_trn.npq26  = ''
          LET g_npq_trn.npq27  = ''
          LET g_npq_trn.npq28  = ''
          LET g_npq_trn.npq29  = ''
          LET g_npq_trn.npq30  = ''
          LET g_npq_trn.npqtype = '0'     
          LET g_npq_trn.npqlegal = g_legal          #FUN-980003
#No.FUN-9A0036 --Begin
          IF g_npp_trn.npptype = '1' THEN
             CALL s_newrate(g_bookno1,g_bookno2,
                            g_npq_trn.npq24,g_npq_trn.npq25,g_npp_trn.npp02)
                   RETURNING g_npq_trn.npq25
             LET g_npq_trn.npq07 = g_npq_trn.npq07f * g_npq_trn.npq25
          END IF
#No.FUN-9A0036 --End
 
        #FUN-D10065--add--str--
        CALL s_def_npq3(g_bookno1,g_npq_trn.npq03,g_prog,g_npq_trn.npq01,'','')
        RETURNING g_npq_trn.npq04
        #FUN-D10065--add--end--
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno1
            AND aag01 = g_npq_trn.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(g_npq_trn.npq03,g_bookno1) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET g_npq_trn.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
        INSERT INTO npq_file VALUES(g_npq_trn.*)
          IF STATUS THEN 
             LET g_showmsg = g_npq_trn.npq01,g_npq_trn.npq011,g_npq_trn.npq02,g_npq_trn.npqsys,g_npq_trn.npq00 
             CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'in21npq',STATUS,1)                      
             LET g_success = 'N'
          END IF
    #--貸 -----------------------------------------------
          LET g_npq_trn.npq02  = 2
          LET g_npq_trn.npq03  = g_fcx.fcx10
          LET g_npq_trn.npq06  = 2
#No.FUN-9A0036 --Begin
          IF g_npp_trn.npptype = '1' THEN
             CALL s_newrate(g_bookno1,g_bookno2,
                            g_npq_trn.npq24,g_npq_trn.npq25,g_npp_trn.npp02)
                   RETURNING g_npq_trn.npq25
             LET g_npq_trn.npq07 = g_npq_trn.npq07f * g_npq_trn.npq25
          END IF
#No.FUN-9A0036 --End
       #FUN-D10065--add--str--
       LET g_npq_trn.npq04 = NULL
       CALL s_def_npq3(g_bookno1,g_npq_trn.npq03,g_prog,g_npq_trn.npq01,'','')
       RETURNING g_npq_trn.npq04
       #FUN-D10065--add--end--
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno1
            AND aag01 = g_npq_trn.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(g_npq_trn.npq03,g_bookno1) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET g_npq_trn.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
       INSERT INTO npq_file VALUES(g_npq_trn.*)
         IF STATUS THEN 
            LET g_showmsg = g_npq_trn.npq01,g_npq_trn.npq011,g_npq_trn.npq02,g_npq_trn.npqsys,g_npq_trn.npq00 
            CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'in22npq',STATUS,1)                      
            LET g_success = 'N'
         END IF
 
  #    IF g_aza.aza63 = 'Y' THEN
       IF g_faa.faa31 = 'Y' THEN   #NO.FUN-AB0088
          LET g_npp_trn.nppsys ='FA'
          LET g_npp_trn.npp00  =11
          LET g_npp_trn.npp01  =g_fcx.fcx01
          #---------------------------------------------
          CALL s_mothck(MDY(g_fcx.fcx03,1,g_fcx.fcx02))
               RETURNING l_b_bdate,l_b_edate
          #---------------------------------------------
          LET g_npp_trn.npp02  =l_b_edate
          LET g_npp_trn.npp03  =NULL
          LET g_npp_trn.npp04  =''
          LET g_npp_trn.npp05  =''
          LET g_npp_trn.npp06  =''
          LET g_npp_trn.npp07  =''
          LET g_npp_trn.nppglno =''
          LET g_npp_trn.npptype = '1'
          LET g_npp_trn.npplegal = g_legal          #FUN-980003
 
         LET l_npp01[1,10] = g_fcx.fcx01
         LET l_npp01[11,16]= g_fcx.fcx02 USING '&&&&',g_fcx.fcx03 USING '&&'
         LET g_npp_trn.npp01 = l_npp01
         DELETE FROM npp_file WHERE nppsys = 'FA'    AND npp00 ='11'
                                AND npp01  = l_npp01 AND npp011=0
                                AND npptype='1'   
         DELETE FROM npq_file WHERE npqsys = 'FA'    AND npq00 ='11'
                                AND npq01  = l_npp01 AND npq011=0
                                AND npqtype='1'   

         #FUN-B40056--add--str--
         DELETE FROM tic_file WHERE tic04 = l_npp01
         #FUN-B40056--add--end--           

         LET g_npp_trn.npp011 = 0
         INSERT INTO npp_file VALUES(g_npp_trn.*)
            IF STATUS THEN 
               LET g_showmsg = g_npp_trn.npp01,"/",g_npp_trn.npp011,"/",g_npp_trn.nppsys,"/",g_npp_trn.npp00 
               CALL s_errmsg('npp01,npp011,nppsys,npp00',g_showmsg,'ins npp',STATUS,1)                       
           LET g_success = 'N'
          END IF
    #--借 -------------------------------------------------
          LET g_npq_trn.npqsys = 'FA'
          LET g_npq_trn.npq00  = 11
          LET g_npq_trn.npq01  = l_npp01     
          LET g_npq_trn.npq011 = 0            
          LET g_npq_trn.npq02  = 1
          LET g_npq_trn.npq03  = g_fcx.fcx091
          LET g_npq_trn.npq04  = ''
          LET g_npq_trn.npq05  = ''
          LET g_npq_trn.npq06  = 1
          LET g_npq_trn.npq07f = g_fcx.fcx06
          LET g_npq_trn.npq07  = g_fcx.fcx06
          LET g_npq_trn.npq08  = ''
          LET g_npq_trn.npq11  = ''
          LET g_npq_trn.npq12  = ''
          LET g_npq_trn.npq13  = ''
          LET g_npq_trn.npq14  = ''
          LET g_npq_trn.npq15  = ''
          LET g_npq_trn.npq21  = ''
          LET g_npq_trn.npq22  = ''
          LET g_npq_trn.npq23  = ''
          LET g_npq_trn.npq24  = g_aza.aza17
          LET g_npq_trn.npq25  = 1
          LET g_npq_trn.npq26  = ''
          LET g_npq_trn.npq27  = ''
          LET g_npq_trn.npq28  = ''
          LET g_npq_trn.npq29  = ''
          LET g_npq_trn.npq30  = ''
          LET g_npq_trn.npqtype = '1'
          LET g_npq_trn.npqlegal = g_legal          #FUN-980003
 
#No.FUN-9A0036 --Begin
          IF g_npp_trn.npptype = '1' THEN
             CALL s_newrate(g_bookno1,g_bookno2,
                            g_npq_trn.npq24,g_npq_trn.npq25,g_npp_trn.npp02)
                   RETURNING g_npq_trn.npq25
             LET g_npq_trn.npq07 = g_npq_trn.npq07f * g_npq_trn.npq25
          END IF
#No.FUN-9A0036 --End
        #FUN-D10065--add--str--
        CALL s_def_npq3(g_bookno1,g_npq_trn.npq03,g_prog,g_npq_trn.npq01,'','')
        RETURNING g_npq_trn.npq04
        #FUN-D10065--add--end--
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno2
            AND aag01 = g_npq_trn.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(g_npq_trn.npq03,g_bookno2) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET g_npq_trn.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
        INSERT INTO npq_file VALUES(g_npq_trn.*)
          IF STATUS THEN 
             LET g_showmsg = g_npq_trn.npq01,g_npq_trn.npq011,g_npq_trn.npq02,g_npq_trn.npqsys,g_npq_trn.npq00  
             CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'in21npq',STATUS,1)                      
             LET g_success = 'N'
          END IF
    #--貸 -----------------------------------------------
          LET g_npq_trn.npq02  = 2
          LET g_npq_trn.npq03  = g_fcx.fcx101
          LET g_npq_trn.npq06  = 2
#No.FUN-9A0036 --Begin
          IF g_npp_trn.npptype = '1' THEN
             CALL s_newrate(g_bookno1,g_bookno2,
                            g_npq_trn.npq24,g_npq_trn.npq25,g_npp_trn.npp02)
                   RETURNING g_npq_trn.npq25
             LET g_npq_trn.npq07 = g_npq_trn.npq07f * g_npq_trn.npq25
          END IF
#No.FUN-9A0036 --End
       #FUN-D10065--add--str--
       LET g_npq_trn.npq04 = NULL
       CALL s_def_npq3(g_bookno1,g_npq_trn.npq03,g_prog,g_npq_trn.npq01,'','')
       RETURNING g_npq_trn.npq04
       #FUN-D10065--add--end--
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno2
            AND aag01 = g_npq_trn.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(g_npq_trn.npq03,g_bookno2) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET g_npq_trn.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
       INSERT INTO npq_file VALUES(g_npq_trn.*)
         IF STATUS THEN 
            LET g_showmsg = g_npq_trn.npq01,g_npq_trn.npq011,g_npq_trn.npq02,g_npq_trn.npqsys,g_npq_trn.npq00  
            CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'in22npq',STATUS,1)                      
            LET g_success = 'N'
         END IF
     END IF
     CALL s_flows('3','',g_npq_trn.npq01,g_npp_trn.npp02,'N',g_npq_trn.npqtype,TRUE)   #No.TQC-B70021
     IF g_success <> 'N' THEN                                                                                                       
        CALL cl_err('','msg008',1)
     END IF
#No.FUN-850103 --end
END FUNCTION
 
FUNCTION i550_r()
DEFINE p_trno LIKE npp_file.npp01    #No:9057
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fcx.fcx01 IS NULL THEN
#       CALL cl_err('','afa-091',0)          #No.FUN-6A0001 
        CALL cl_err('',-400,0)               #No.FUN-6A0001 
        RETURN
    END IF
    IF NOT cl_null(g_fcx.fcx11) OR NOT cl_null(g_fcx.fcx112) THEN  #No:FUN-B60140
       CALL cl_err('','afa-311',0) RETURN
    END IF
    #TQC-950164--Begin--#                                                                                                           
    IF g_fcx.fcxacti = 'N' THEN                                                                                                     
        CALL cl_err('','abm-950',0)                                                                                                 
        RETURN                                                                                                                      
    END IF                                                                                                                          
    #TQC-950164--End--#
    BEGIN WORK
 
    OPEN i550_cl USING g_fcx.fcx01,g_fcx.fcx02,g_fcx.fcx03,g_fcx.fcx011
 
    IF STATUS THEN
       CALL cl_err("OPEN i550_cl:", STATUS, 1)
       CLOSE i550_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i550_cl INTO g_fcx.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_fcx.fcx01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i550_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "fcx01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_fcx.fcx01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM fcx_file
       WHERE fcx01 = g_fcx.fcx01 AND fcx011=g_fcx.fcx011
         AND fcx02=g_fcx.fcx02   AND fcx03 = g_fcx.fcx03
       IF STATUS THEN
#         CALL cl_err('',STATUS,0)   #No.FUN-660136
          CALL cl_err3("del","fcx_file",g_fcx.fcx01,g_fcx.fcx02,STATUS,"","",1)  #No.FUN-660136
       ELSE
       #No.9057
       LET p_trno[1,10] = g_fcx.fcx01
       LET p_trno[11,16]= g_fcx.fcx02 USING '&&&&', g_fcx.fcx03 USING '&&'
       DELETE FROM npp_file WHERE nppsys = 'FA'    AND npp00 ='11'
                              AND npp01  = p_trno  AND npp011=0
       DELETE FROM npq_file WHERE npqsys = 'FA'    AND npq00 ='11'
                              AND npq01  = p_trno  AND npq011=0

       #FUN-B40056--add--str--
       DELETE FROM tic_file WHERE tic04 = p_trno
       #FUN-B40056--add--end--

       #No.9057(end)
       CLEAR FORM
         #CKP3
         OPEN i550_count
         #FUN-B50062-add-start--
         IF STATUS THEN
            CLOSE i550_cs
            CLOSE i550_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end-- 
         FETCH i550_count INTO g_row_count
         #FUN-B50062-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i550_cs
            CLOSE i550_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i550_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i550_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i550_fetch('/')
         END IF
       END IF
    END IF
    CLOSE i550_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i550_aag(p_key,p_key1,p_bookno)
DEFINE
      l_aagacti  LIKE aag_file.aagacti,
      l_aag02    LIKE aag_file.aag02,
      l_aag07    LIKE aag_file.aag07,
      l_aag03    LIKE aag_file.aag03,
      l_aag09    LIKE aag_file.aag09,
      p_key      LIKE fcx_file.fcx09,
      p_key1     LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
      p_cmd      LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
DEFINE p_bookno  LIKE aag_file.aag02         #No.FUN-740026
 
    LET g_errno = " "
    SELECT aag02,aagacti,aag07,aag03,aag09
      INTO l_aag02,l_aagacti,l_aag07,l_aag03,l_aag09
      FROM aag_file
     WHERE aag01=p_key
       AND aag00 = p_bookno        #No.FUN-740026 
    CASE
         WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-025'
                                  LET l_aag02 = NULL
                                  LET l_aagacti = NULL
         WHEN l_aagacti='N'       LET g_errno = '9028'
         WHEN l_aag07  ='1'       LET g_errno = 'agl-131'
         WHEN l_aag03  ='4'       LET g_errno = 'agl-912'
         WHEN l_aag09  ='N'       LET g_errno = 'agl-913'
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       CASE
           WHEN p_key1='1'
                DISPLAY l_aag02 TO fcx09
           WHEN p_key1='2'
                DISPLAY l_aag02 TO fcx10
       END CASE
    END IF
END FUNCTION
 
FUNCTION i550_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("fcx01,fcx011,fcx02,fcx03",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i550_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
         l_n     LIKE type_file.num10        #No.FUN-680070 INTEGER
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("fcx01,fcx011,fcx02,fcx03",FALSE)
   END IF
 
END FUNCTION
