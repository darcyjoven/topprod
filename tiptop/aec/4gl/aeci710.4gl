# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aeci710.4gl
# Descriptions...: 工單單元明細資料維護作業
# Date & Author..: 99/06/30 By Kammy
# Modify.........: No.MOD-490371 04/09/22 By Yuna Controlp 未加display
# Modify.........: No.FUN-4B0012 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.FUN-4C0034 04/12/07 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-660091 05/06/15 By hellen cl_err --> cl_err3
# Modify.........: No.FUN-680073 06/08/21 By hongmei 欄位型態轉換
# Modify.........: No.FUN-6A0039 06/10/25 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-810014 07/08/02 By arman 修改為服飾版 
# Modify.........: No.FUN-830114 08/03/25 By jan 修改服飾作業 
# Modify.........: No.FUN-830121 08/04/01 By hongmei sgcslk01-->sgc14 將報工否修改為一般行業
# Modify.........: No.MOD-840485 08/04/22 By kim GP5.1顧問測試修改
# Modify.........: No.MOD-840481 08/04/22 By kim GP5.1顧問測試修改
# Modify.........: No.FUN-840178 08/04/24 By jan 修改服飾作業 
# Modify.........: No.FUN-980002 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60080 10/07/08 By destiny 增加平行工艺逻辑
# Modify.........: No.FUN-A70131 10/07/29 By destiny 平行工藝
# Modify.........: No.TQC-AC0374 10/12/30 By jan 調用s_schdat_ecu014()抓取製程段名稱
# Modify.........: No.FUN-B10056 11/02/21 By lixh1 制程段號說明欄位改用實體欄位ecm014來顯示
# Modify.........: No:TQC-D40081 13/08/14 By dongsz 欄位增加開窗
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_sfb      RECORD LIKE sfb_file.*,
    g_sfb_t    RECORD LIKE sfb_file.*,
    g_ecm      RECORD LIKE ecm_file.*,
    g_sfb01    LIKE sfb_file.sfb01,
    g_sfb05    LIKE sfb_file.sfb05,
    g_ecm03    LIKE ecm_file.ecm03,
    g_ecm012   LIKE ecm_file.ecm012,  #NO.FUN-A60080  add ecm012
    g_argv1    LIKE sfb_file.sfb01,
    g_argv2    LIKE sfb_file.sfb05,
    g_argv3    LIKE ecm_file.ecm03,
     g_wc,g_wc2,g_sql,g_sql1    STRING,             #No.FUN-580092 HCN     
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680073 SMALLINT
    g_sgd           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
      sgd05           LIKE sgd_file.sgd05, #單元代號
      sga02           LIKE sga_file.sga02, #名稱
      sga03           LIKE sga_file.sga03, #規格
      sgd06           LIKE sgd_file.sgd06, #零件數
      sgd07           LIKE sgd_file.sgd07, #單位工時
      sgd08           LIKE sgd_file.sgd08, #單元工時
      sgd10           LIKE sgd_file.sgd10, #單位機時
      sgd11           LIKE sgd_file.sgd11, #單元機時
      sgd09           LIKE sgd_file.sgd09, #單位人力           #No.FUN-810014
      sgdslk05        LIKE sgd_file.sgdslk05,  #單元順序      #No.FUN-810014
      sgdslk04        LIKE sgd_file.sgdslk04,  #單元現實工價  #No.FUN-810014
      sgdslk03        LIKE sgd_file.sgdslk03,  #單元標准工價  #No.FUN-810014
      sgdslk02        LIKE sgd_file.sgdslk02,  #單元現實工時  #No.FUN-810014
      sgd13           LIKE sgd_file.sgd13,      #可委外否      #No.FUN-810014
      sgd14           LIKE sgd_file.sgd14   #可報工否      #No.FUN-810014 #No.FUN-830121
                    END RECORD,
    g_sgd_t         RECORD                 #程式變數 (舊值)
      sgd05           LIKE sgd_file.sgd05, #單元代號
      sga02           LIKE sga_file.sga02, #名稱
      sga03           LIKE sga_file.sga03, #規格
      sgd06           LIKE sgd_file.sgd06, #零件數
      sgd07           LIKE sgd_file.sgd07, #單位工時
      sgd08           LIKE sgd_file.sgd08, #單元工時
      sgd10           LIKE sgd_file.sgd10, #單位機時
      sgd11           LIKE sgd_file.sgd11, #單元機時
      sgd09           LIKE sgd_file.sgd09,  #單位人力          #No.FUN-810014
      sgdslk05        LIKE sgd_file.sgdslk05,  #單元順序      #No.FUN-810014                                                     
      sgdslk04        LIKE sgd_file.sgdslk04,  #單元現實工價  #No.FUN-810014                                                     
      sgdslk03        LIKE sgd_file.sgdslk03,  #單元標准工價  #No.FUN-810014                                                     
      sgdslk02        LIKE sgd_file.sgdslk02,  #單元現實工時  #No.FUN-810014                                                     
      sgd13           LIKE sgd_file.sgd13,      #可委外否      #No.FUN-810014                                                     
      sgd14           LIKE sgd_file.sgd14   #可報工否      #No.FUN-810014
                    END RECORD,
    p_row,p_col     LIKE type_file.num5,          #No.FUN-680073 SMALLINT 
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680073 SMALLINT
 
DEFINE g_forupd_sql         STRING                  #SELECT ... FOR UPDATE  SQL  
DEFINE g_before_input_done  LIKE type_file.num5     #No.FUN-680073 SMALLINT
DEFINE g_cnt           LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE g_msg           LIKE type_file.chr1000       #No.FUN-680073 VARCHAR(72)
DEFINE g_row_count     LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE g_curs_index    LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE g_jump          LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5          #No.FUN-680073 SMALLINT
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0100
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AEC")) THEN
      EXIT PROGRAM
   END IF
 
 
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
    IF g_sma.sma55='N' THEN
       CALL cl_err('sma55=N:','aec-021',1)
       EXIT PROGRAM
    END IF
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
    LET g_argv1=ARG_VAL(1)
    LET g_argv2=ARG_VAL(2)
    LET g_argv3=ARG_VAL(3)
    LET p_row = 4 LET p_col = 3
    OPEN WINDOW i710_w AT p_row,p_col
         WITH FORM "aec/42f/aeci710"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    IF g_sma.sma541='N' THEN 
      # CALL cl_set_comp_visible('ecm012,ecu014',FALSE) #FUN-B10056 mark
        CALL cl_set_comp_visible('ecm012,ecm014',FALSE) #FUN-B10056
    END IF 
#No.FUN-810014--Begin                                                                                                             
       CALL cl_set_comp_visible("ecmslk04,ecmslk03,ecmslk02,sgdslk05,sgdslk04,sgdslk03,sgdslk02",FALSE)                                                              
#No.FUN-810014--End
 
    IF NOT cl_null(g_argv1) THEN
       LET g_sfb01=g_argv1 #MOD-840485
       CALL i710_q()
    END IF
 
    CALL i710()
    CLOSE WINDOW i710_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
 
END MAIN
 
FUNCTION i710()
   #INITIALIZE g_sfb.* TO NULL #MOD-840485
   #INITIALIZE g_ecm.* TO NULL #MOD-840485
    CALL i710_menu()
END FUNCTION
 
FUNCTION i710_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    LET  g_wc2=' 1=1'
    CLEAR FORM
    CALL g_sgd.clear()
    IF cl_null(g_argv1) AND cl_null(g_argv2) THEN
       CALL cl_set_head_visible("","YES")         #No.FUN-6B0029
   INITIALIZE g_sfb01 TO NULL    #No.FUN-750051
   INITIALIZE g_sfb05 TO NULL    #No.FUN-750051
   INITIALIZE g_ecm03 TO NULL    #No.FUN-750051
   INITIALIZE g_ecm012 TO NULL    #NO.FUN-A60080
    #   CONSTRUCT BY NAME g_wc ON sfb01,sfb05,sfb06,ecm03,ecm012,ecm45,ecm06,      #NO.FUN-A60080  add ecm012  #FUN-B10056 mark
        CONSTRUCT BY NAME g_wc ON sfb01,sfb05,sfb06,ecm03,ecm012,ecm014,ecm45,ecm06,   #FUN-B10056 add ecm014
                                 sfb08,ecm14,ecm16 ,ecm49,                #No.FUN-810014
                                 ecm60
 
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT

     #TQC-D40081--add--str---
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(sfb01)
               CALL cl_init_qry_var()
               LET g_qryparam.state    = "c"
               LET g_qryparam.form     = "q_sfb01_1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO sfb01
               NEXT FIELD sfb01
            WHEN INFIELD(sfb05)
               CALL cl_init_qry_var()
               LET g_qryparam.state    = "c"
               LET g_qryparam.form     = "q_sfb05_1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO sfb05
               NEXT FIELD sfb05
            WHEN INFIELD(sfb06)
               CALL cl_init_qry_var()
               LET g_qryparam.state    = "c"
               LET g_qryparam.form     = "q_sfb06_1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO sfb06
               NEXT FIELD sfb06
            WHEN INFIELD(ecm06)
               CALL cl_init_qry_var()
               LET g_qryparam.state    = "c"
               LET g_qryparam.form     = "q_ecm06_1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ecm06
               NEXT FIELD ecm06
         END CASE
     #TQC-D40081--add--end---
 
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
       IF INT_FLAG THEN RETURN END IF
 
       CONSTRUCT g_wc2 ON sgd05,sgd06,sgd07,sgd08,sgd10,sgd1l,sgd09,  #No.FUN-810014
                          sgd13,sgd14        #No.FUN-810014
                 FROM s_sgd[1].sgd05,s_sgd[1].sgd06,s_sgd[1].sgd07,
                      s_sgd[1].sgd08,s_sgd[1].sgd10,s_sgd[1].sgd11,
                      s_sgd[1].sgd09,                                           #No.FUN-810014
                      s_sgd[1].sgd13,s_sgd[1].sgd14      #No.FUN-810014
                      
 
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
 
          ON ACTION controlp                        #
             CASE WHEN INFIELD(sgd05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_sga"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sgd05
                  NEXT FIELD sgd05
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
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
 
       END CONSTRUCT
 
       IF INT_FLAG THEN RETURN END IF
    ELSE
       LET g_wc= " sfb01='",g_argv1,"' AND sfb05='",g_argv2,"'"
    END IF
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            # 只能使用自己的資料
    #       LET g_wc = g_wc clipped," AND sfbuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                            # 只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND sfbgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND sfbgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
    #End:FUN-980030
 
 
    IF g_wc2=' 1=1' OR g_wc2 IS NULL THEN
     #  LET g_sql="SELECT sfb01,sfb05,ecm03,ecm012 FROM sfb_file,ecm_file ",   #NO.FUN-A60080  add ecm012  #FUN-B10056 mark
        LET g_sql="SELECT sfb01,sfb05,ecm03,ecm012,ecm014 FROM sfb_file,ecm_file ",  #FUN-B10056 add ecm014
                 " WHERE sfb01=ecm01 AND sfb87!='X' ",
                 "   AND ", g_wc CLIPPED, " ORDER BY sfb01,sfb05"
    ELSE
     #  LET g_sql="SELECT sfb01,sfb05,ecm03,ecm012 FROM sfb_file,ecm_file,sgd_file",  #NO.FUN-A60080  add ecm012  #FUN-B10056 mark
        LET g_sql="SELECT sfb01,sfb05,ecm03,ecm012,ecm014 FROM sfb_file,ecm_file,sgd_file",  #FUN-B10056  add ecm014
                 " WHERE sfb01=ecm01 ",
                 "   AND sgd00=ecm01 ",
                 "   AND sgd01=sfb05 ",
                 "   AND sgd02=sfb06 ",
                 "   AND sgd03=ecm03 ",
                 "   AND sgd04=ecm06 ",
                 "   AND sfb87!='X' ",
                 "   AND sgd012=ecm012 ",                     #NO.FUN-A60080 
                 "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                 " ORDER BY sfb01,sfb05"
    END IF
 
    PREPARE i710_prepare FROM g_sql                # RUNTIME 編譯
    DECLARE i710_cs SCROLL CURSOR WITH HOLD FOR i710_prepare
 
    IF g_wc2=' 1=1' OR g_wc2 IS NULL THEN
     #  LET g_sql1="SELECT UNIQUE sfb01,sfb05,ecm03,ecm012 FROM sfb_file,ecm_file ",            #NO.FUN-A60080  add ecm012  #FUN-B10056 mark
       LET g_sql1="SELECT UNIQUE sfb01,sfb05,ecm03,ecm012,ecm014 FROM sfb_file,ecm_file ",    #FUN-B10056  add ecm014
                " WHERE sfb01=ecm01 AND sfb87!='X' ",
                 "   AND ", g_wc CLIPPED, " INTO TEMP x "
    ELSE
     #  LET g_sql1="SELECT UNIQUE sfb01,sfb05,ecm03,ecm012 FROM sfb_file,ecm_file,sgd_file",    #NO.FUN-A60080  add ecm012  #FUN-B10056 mark
       LET g_sql1="SELECT UNIQUE sfb01,sfb05,ecm03,ecm012,ecm014 FROM sfb_file,ecm_file,sgd_file",   #FUN-B10056  add ecm014 
                " WHERE sfb01=ecm01 ",
                 "   AND sgd00=ecm01 ",
                 "   AND sgd01=sfb05 ",
                 "   AND sgd02=sfb06 ",
                 "   AND sgd03=ecm03 ",
                 "   AND sgd04=ecm06 ",
                 "   AND sfb87!='X' ",
                 "   AND sgd012=ecm012 ",                     #NO.FUN-A60080
                 "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                 " INTO TEMP x "
    END IF
#FUN-810014--Begin--修正程序計算筆數錯誤
    DROP TABLE x
    PREPARE i710_precount_x FROM g_sql1
    EXECUTE I710_precount_x
    LET g_sql="SELECT COUNT(*) FROM x "
    PREPARE i710_precount FROM g_sql
    DECLARE i710_count CURSOR FOR i710_precount
#   PREPARE i710_count FROM g_sql                # RUNTIME 編譯
#FUN-810014--End
 
END FUNCTION
 
FUNCTION i710_menu()
 
   WHILE TRUE
      CALL i710_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i710_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i710_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#FUN-4B0012
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sgd),'','')
            END IF
##
        #No.FUN-6A0039-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_sfb01 IS NOT NULL THEN
                LET g_doc.column1 = "sfb01"
                LET g_doc.column2 = "sfb02"
                LET g_doc.column3 = "ecm03"
                LET g_doc.value1 = g_sfb01
                LET g_doc.value2 = g_sfb05
                LET g_doc.value3 = g_ecm03
                CALL cl_doc()
             END IF 
          END IF
        #No.FUN-6A0039-------add--------end----
      END CASE
   END WHILE
   CLOSE i710_cs
END FUNCTION
 
FUNCTION i710_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    IF cl_null(g_argv1) THEN #MOD-840485
       INITIALIZE g_sfb.* TO NULL              #No.FUN-6A0039
       INITIALIZE g_ecm.* TO NULL              #No.FUN-6A0039
    END IF
    CALL cl_opmsg('q')
    MESSAGE ""
    CALL i710_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        CALL g_sgd.clear()
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN i710_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sfb.sfb01,SQLCA.sqlcode,0)
        INITIALIZE g_sfb.* TO NULL
        INITIALIZE g_ecm.* TO NULL
    ELSE
#FUN-810014--Begin--修正程序計算筆數的錯誤
#       EXECUTE i710_count
#       SELECT COUNT(*) INTO g_row_count FROM x
        OPEN i710_count
        FETCH i710_count INTO g_row_count
#FUN-810014--End
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i710_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION i710_fetch(p_flsgd)
    DEFINE
        p_flsgd         LIKE type_file.chr1,         #No.FUN-680073 VARCHAR(1)
        l_abso          LIKE type_file.num10         #No.FUN-680073 INTEGER
 
    CASE p_flsgd
        WHEN 'N' FETCH NEXT     i710_cs INTO g_sfb01,g_sfb05,g_ecm03,g_ecm012   #NO.FUN-A60080
        WHEN 'P' FETCH PREVIOUS i710_cs INTO g_sfb01,g_sfb05,g_ecm03,g_ecm012   #NO.FUN-A60080
        WHEN 'F' FETCH FIRST    i710_cs INTO g_sfb01,g_sfb05,g_ecm03,g_ecm012   #NO.FUN-A60080
        WHEN 'L' FETCH LAST     i710_cs INTO g_sfb01,g_sfb05,g_ecm03,g_ecm012   #NO.FUN-A60080
        WHEN '/'
            IF (NOT mi_no_ask) THEN
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
            FETCH ABSOLUTE g_jump i710_cs INTO g_sfb01,g_sfb05,g_ecm03,g_ecm012  #NO.FUN-A60080
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sfb.sfb01,SQLCA.sqlcode,0)
        INITIALIZE g_ecm.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flsgd
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
#FUN-4C0034
    SELECT * INTO g_sfb.* FROM sfb_file       # 重讀DB,因TEMP有不被更新特性
       WHERE sfb01= g_sfb01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_sfb.sfb01,SQLCA.sqlcode,1) #No.FUN-660091
       CALL cl_err3("sel","sfb_file",g_sfb01,"",SQLCA.sqlcode,"","",1) #FUN-660091
       INITIALIZE g_sfb.* TO NULL
    ELSE
       SELECT * INTO g_ecm.* FROM ecm_file
        WHERE ecm01 =g_sfb01 AND ecm03=g_ecm03 
        AND ecm012=g_ecm012  #NO.FUN-A60080
       IF SQLCA.sqlcode THEN
#         CALL cl_err(g_ecm.ecm01,SQLCA.sqlcode,1) #No.FUN-660091
          CALL cl_err3("sel","ecm_file",g_sfb01,g_ecm03,SQLCA.sqlcode,"","",1) #FUN-660091
          INITIALIZE g_ecm.* TO NULL
       ELSE
          LET g_data_owner = g_sfb.sfbuser      #FUN-4C0034
          LET g_data_group = g_sfb.sfbgrup      #FUN-4C0034
          LET g_data_plant = g_sfb.sfbplant #FUN-980030
          CALL i710_show()                      # 重新顯示
       END IF
    END IF
##
 
END FUNCTION
 
FUNCTION i710_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000   #No.FUN-680073 VARCHAR(200)
 
    CONSTRUCT g_wc2 ON sgd05,sgd06,sgd07,sgd08,sgd09,sgd10,sgd11,                #No.FUN-810014
                       sgd13,sgd14   #No.FUN-810014
                      
              FROM s_sgd[1].sgd05,s_sgd[1].sgd06,s_sgd[1].sgd07,
                   s_sgd[1].sgd08,s_sgd[1].sgd09,s_sgd[1].sgd10,
                   s_sgd[1].sgd11,                                               #No.FUN-810014
                   s_sgd[1].sgd13,s_sgd[1].sgd14          #No.FUN-810014
                  
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp                        #
           CASE WHEN INFIELD(sgd05)
                CALL cl_init_qry_var()
                LET g_qryparam.state= "c"
                LET g_qryparam.form = "q_sga"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO sgd05
                NEXT FIELD sgd05
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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i710_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i710_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sgd TO s_sgd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i710_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i710_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i710_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i710_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i710_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
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
         EXIT DISPLAY
 
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
 
 
#FUN-4B0012
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
##
      ON ACTION related_document                #No.FUN-6A0039  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i710_show()
    DEFINE l_ima02    LIKE ima_file.ima02,
           l_ima021   LIKE ima_file.ima021,
           l_eca02    LIKE eca_file.eca02,
           l_ecu014   LIKE ecu_file.ecu014   #NO.FUN-A60080
            
    DISPLAY BY NAME g_sfb.sfb01,g_sfb.sfb08,g_sfb.sfb05,g_sfb.sfb06,
                    g_ecm.ecm012, g_ecm.ecm014,                                    #NO.FUN-A60080    #FUN-B10056 add ecm014
                    g_ecm.ecm03,g_ecm.ecm45,g_ecm.ecm06,g_ecm.ecm14,
                    g_ecm.ecm49,g_ecm.ecm16,                                       #No.FUN-810014
                    g_ecm.ecm60
    SELECT ima02,ima021 INTO  l_ima02,l_ima021 FROM ima_file
     WHERE ima01 = g_sfb.sfb05
    SELECT eca02 INTO l_eca02  FROM eca_file
     WHERE eca01=g_ecm.ecm06
   #SELECT ecu014 INTO l_ecu014 FROM ecu_file                       #NO.FUN-A60080 #TQC-AC0374
   # WHERE ecu01=g_sfb.sfb05 AND ecu02=g_ecm03 AND ecu012=g_ecm012  #NO.FUN-A60080 #TQC-AC0374
  #  CALL s_schdat_ecu014(g_sfb.sfb01,g_ecm012) RETURNING l_ecu014   #TQC-AC0374   #FUN-B10056 mark
    DISPLAY l_ima02  TO FORMONLY.ima02
    DISPLAY l_ima021 TO FORMONLY.ima021
    DISPLAY l_eca02  TO FORMONLY.eca02
    CALL i710_b_tot('d')
    CALL i710_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i710_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2       LIKE type_file.chr1000   #No.FUN-680073 VARCHAR(200) 
 
    LET g_sql = "SELECT sgd05,'','',sgd06,sgd07,sgd08,sgd10,sgd11,sgd09,",   #No.FUN-810014
                " '','','','',sgd13,sgd14",  #No.FUN-810014
                " FROM sgd_file ",
                " WHERE sgd00 = '",g_sfb01,"'  ",
                "   AND sgd01 = '",g_sfb05,"'  ",
                "   AND sgd02 = '",g_sfb.sfb06,"'  ",
                "   AND sgd03 =  ",g_ecm03,"   ", #MOD-840481
                "   AND sgd04 = '",g_ecm.ecm06,"' ",
                "   AND sgd012= '",g_ecm012,"' ",  #NO.FUN-A60080
                "   AND ", p_wc2 CLIPPED,
                " ORDER BY 1 "
    PREPARE i710_pb FROM g_sql
    DECLARE sgd_curs CURSOR FOR i710_pb
 
    CALL g_sgd.clear()
 
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH sgd_curs INTO g_sgd[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET l_ac=g_cnt
        CALL i710_sgd05_1() #No.FUN-830114
 
        LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_sgd.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i710_sgd05()
    LET g_errno = ' '
#No.FUN-840178--BEGIN--
#&ifdef SLK                                                                                                                          
#   #No.FUN-830114--BEGIN                                                                                                            
#   IF cl_null(g_sgd[l_ac].sgd06) THEN                                                                                               
#      LET g_sgd[l_ac].sgd06 = 0                                                                                                     
#   END IF                                                                                                                           
#   #No.FUN-830114--END                                                                                                              
#&endif
#No.FUN-840178--END--
    SELECT sga02,sga03,sga04,sga06,sga07,sga08                    #No.FUN-840178
      INTO g_sgd[l_ac].sga02,g_sgd[l_ac].sga03,g_sgd[l_ac].sgd07,
           g_sgd[l_ac].sgd10,g_sgd[l_ac].sgd13,g_sgd[l_ac].sgd14  #No.FUN-840178
      FROM  sga_file
     WHERE sga01 = g_sgd[l_ac].sgd05
    CASE WHEN SQLCA.SQLCODE = 100
              LET g_errno = 'aec-012'
              LET g_sgd[l_ac].sgd05 = NULL
         OTHERWISE
              LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
END FUNCTION
 
#No.FUN-830114--BEGIN--
FUNCTION i710_sgd05_1()
    LET g_errno = ' '
    SELECT sga02,sga03
      INTO g_sgd[l_ac].sga02,g_sgd[l_ac].sga03
      FROM  sga_file
     WHERE sga01 = g_sgd[l_ac].sgd05
    CASE WHEN SQLCA.SQLCODE = 100
              LET g_errno = 'aec-012'
              LET g_sgd[l_ac].sgd05 = NULL
         OTHERWISE
              LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
END FUNCTION
#No.FUN-830114--END--
 
FUNCTION i710_b_tot(p_cmd)
    DEFINE l_ecm14a LIKE ecm_file.ecm14,
           l_ecm49a LIKE ecm_file.ecm49,
           l_ecm16a LIKE ecm_file.ecm16,
           l_ecm14  LIKE ecm_file.ecm14,
           l_ecm49  LIKE ecm_file.ecm49,
           l_ecm16  LIKE ecm_file.ecm16,
           p_cmd    LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
    SELECT SUM(sgd08),SUM(sgd09),SUM(sgd11)
      INTO l_ecm14a,l_ecm49a,l_ecm16a FROM sgd_file
     WHERE sgd00=g_sfb.sfb01
       AND sgd01=g_sfb.sfb05
       AND sgd02=g_sfb.sfb06
       AND sgd03=g_ecm03
       AND sgd04=g_ecm.ecm06
    LET g_ecm.ecm14 = l_ecm14a * g_sfb.sfb08
    LET g_ecm.ecm49 = l_ecm49a * g_sfb.sfb08
    LET g_ecm.ecm16 = l_ecm16a * g_sfb.sfb08
    DISPLAY BY NAME g_ecm.ecm14,g_ecm.ecm49,g_ecm.ecm16
    DISPLAY l_ecm14a,l_ecm49a,l_ecm16a TO ecm14a,ecm49a,ecm16a
 
    IF p_cmd='a' THEN
       UPDATE ecm_file SET ecm14=g_ecm.ecm14,
                           ecm49=g_ecm.ecm49,
                           ecm16=g_ecm.ecm16
        WHERE ecm01=g_ecm.ecm01
          AND ecm03=g_ecm.ecm03
        IF STATUS THEN
#          CALL cl_err('',STATUS,0) #No.FUN-660091
           CALL cl_err3("upd","ecm_file",g_ecm.ecm01,g_ecm.ecm03,STATUS,"","",1) #FUN-660091
        END IF
    END IF
 
END FUNCTION
 
FUNCTION i710_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680073 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680073 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680073 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680073 VARCHAR(1)
    l_sfb87         LIKE sfb_file.sfb87,                #確認否            #No.FUN-810014
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680073 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680073 SMALLINT
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_sfb.sfb01 IS NULL THEN RETURN END IF
 
#No.FUN-810014--Begin
    SELECT sfb87 INTO l_sfb87 FROM sfb_file
     WHERE sfb01 = g_sfb01
    IF l_sfb87='Y' THEN
       CALL cl_err('','mfg1005',0)
       RETURN
    END IF
#No.FUN-810014--End
 
    SELECT * INTO g_sfb.* FROM sfb_file
     WHERE sfb01= g_sfb01
    IF SQLCA.sqlcode THEN INITIALIZE g_sfb.* TO NULL END IF
 
    SELECT * INTO g_ecm.* FROM ecm_file
     WHERE ecm01 =g_sfb01 AND  ecm03=g_ecm03
    IF SQLCA.sqlcode THEN INITIALIZE g_ecm.* TO NULL END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
#       "SELECT sgd05,'','',sgd06,sgd07,sgd08,sgd10,sgd11,sgd09 FROM sgd_file ",  #No.FUN-810014
        "SELECT sgd05,'','',sgd06,sgd07,sgd08,sgd10,sgd11,sgd09,'',",      #No.FUN-810014
        " '','','',sgd13,sgd14",                         #No.FUN-810014
        " FROM sgd_file ",                                                        #No.FUN-810014
        " WHERE sgd00= ? AND sgd01= ? AND sgd02= ? AND sgd03= ? AND sgd04= ? ",
        " AND sgd05= ?  FOR UPDATE  "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i710_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_sgd WITHOUT DEFAULTS FROM s_sgd.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            IF g_rec_b >= l_ac THEN
 
                LET p_cmd='u'
                LET g_sgd_t.* = g_sgd[l_ac].*  #BACKUP
 
                OPEN i710_bcl USING g_sfb.sfb01,g_sfb.sfb05,g_sfb.sfb06,g_ecm03,
                                    g_ecm.ecm06,g_sgd_t.sgd05
                IF STATUS THEN
                   CALL cl_err("OPEN i710_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i710_bcl INTO g_sgd[l_ac].*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_sgd_t.sgd05,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   ELSE
#                     CALL  i710_sgd05()  #No.FUN-840178
                      CALL i710_sgd05_1() #No.FUN-840178
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_sgd[l_ac].* TO NULL      #900423
            LET g_sgd[l_ac].sgd06 = 0
            LET g_sgd[l_ac].sgd07 = 0
            LET g_sgd[l_ac].sgd08 = 0
            LET g_sgd[l_ac].sgd09 = 0
            LET g_sgd[l_ac].sgd13 = 'N'           #No.FUN-810014
            LET g_sgd[l_ac].sgd14 = 'N'       #No.FUN-810014
            LET g_sgd_t.* = g_sgd[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD sgd05
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            #No.FUN-A70131--begin
            IF cl_null(g_ecm012) THEN 
               LET g_ecm012=' '
            END IF 
            IF cl_null(g_ecm03) THEN 
               LET g_ecm03=0
            END IF 
            #No.FUN-A70131--end            
            INSERT INTO sgd_file(sgd00,sgd01,sgd02,sgd03,sgd04,sgd05,
                                 sgd06,sgd07,sgd08,sgd10,sgd11,sgd09,   #No.FUN-810014
                                 sgd13,sgd14,             #No.FUN-810014
                                 sgdplant,sgdlegal,sgd012) #FUN-980002 #FUN-A60080
                          VALUES(g_sfb.sfb01,g_sfb.sfb05,g_sfb.sfb06,
                                 g_ecm03 ,g_ecm.ecm06,g_sgd[l_ac].sgd05,
                                 g_sgd[l_ac].sgd06,g_sgd[l_ac].sgd07,
                                 g_sgd[l_ac].sgd08,g_sgd[l_ac].sgd10,
                                 g_sgd[l_ac].sgd11,g_sgd[l_ac].sgd09,          #No.FUN-810014
                                 g_sgd[l_ac].sgd13,g_sgd[l_ac].sgd14,      #No.FUN-810014
                                 g_plant,g_legal,g_ecm012) #FUN-980002 #FUN-A60080
            IF SQLCA.sqlcode THEN
#              CALL cl_err('ins sgd:',SQLCA.sqlcode,0) #No.FUN-660091
               CALL cl_err3("ins","sgd_file",g_sfb.sfb01,g_sfb.sfb05,SQLCA.sqlcode,"","ins sgd:",1) #FUN-660091
               CANCEL INSERT
            ELSE
                LET g_success='Y'
                CALL i710_b_tot('a')
                COMMIT WORK
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
 
        BEFORE FIELD sgd05
            LET g_sfb_t.* = g_sfb.*	
 
        AFTER FIELD sgd05                        #check 序號是否重複
            IF NOT cl_null(g_sgd[l_ac].sgd05) THEN
               IF g_sgd[l_ac].sgd05 != g_sgd_t.sgd05 OR
                  g_sgd_t.sgd05 IS NULL THEN
                  SELECT count(*) INTO l_n FROM sgd_file
                   WHERE sgd00 = g_sfb.sfb01
                     AND sgd01 = g_sfb.sfb05
                     AND sgd02 = g_sfb.sfb06
                     AND sgd03 = g_ecm03
                     AND sgd04 = g_ecm.ecm06
                     AND sgd05 = g_sgd[l_ac].sgd05
                  IF l_n > 0 THEN CALL cl_err('',-239,0)
                     LET g_sgd[l_ac].sgd05 = g_sgd_t.sgd05
                     NEXT FIELD sgd05
                  END IF
 
                  CALL i710_sgd05()
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     NEXT FIELD sgd05
                  END IF
               END IF
            END IF
 
        AFTER FIELD sgd06
            IF NOT cl_null(g_sgd[l_ac].sgd06) THEN
             IF cl_null(g_sgd_t.sgd06) OR g_sgd[l_ac].sgd06 != g_sgd_t.sgd06 #No.FUN-840178 
                OR g_sgd[l_ac].sgd05 != g_sgd_t.sgd05 THEN                   #No.FUN-840178
               IF g_sgd[l_ac].sgd06 = 0  THEN
                  NEXT FIELD sgd06
               END IF
               LET g_sgd[l_ac].sgd08 = g_sgd[l_ac].sgd07 * g_sgd[l_ac].sgd06
               LET g_sgd[l_ac].sgd11 = g_sgd[l_ac].sgd10 * g_sgd[l_ac].sgd06
               #------MOD-5A0095 START----------
               DISPLAY BY NAME g_sgd[l_ac].sgd08
               DISPLAY BY NAME g_sgd[l_ac].sgd11
               #------MOD-5A0095 END------------
             END IF                              #No.FUN-840178
            END IF
 
        BEFORE FIELD sgd09
            LET g_sgd[l_ac].sgd09 = g_sgd[l_ac].sgd08 / 500
            IF g_sgd[l_ac].sgd09 < 0.001 THEN
               LET g_sgd[l_ac].sgd09 = 0.001
            END IF
            #------MOD-5A0095 START----------
            DISPLAY BY NAME g_sgd[l_ac].sgd09
            #------MOD-5A0095 END------------
 
        AFTER FIELD sgd09
            IF NOT cl_null(g_sgd[l_ac].sgd09) THEN
               IF g_sgd[l_ac].sgd09 = 0  THEN
                  NEXT FIELD sgd09
               END IF
            END IF
 
 
        BEFORE DELETE                            #是否取消單身
            IF g_sgd_t.sgd05 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
 
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
 
               DELETE FROM sgd_file
                WHERE sgd00=g_sfb.sfb01 AND sgd01=g_sfb.sfb05
                  AND sgd02=g_sfb.sfb06 AND sgd03=g_ecm03
                  AND sgd04=g_ecm.ecm06 AND sgd05 = g_sgd[l_ac].sgd05
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_sgd_t.sgd05,SQLCA.sqlcode,0) #No.FUN-660091
                  CALL cl_err3("del","sgd_file",g_sfb.sfb01,g_sgd[l_ac].sgd05,SQLCA.sqlcode,"","",1) #FUN-660091
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
 
 
               LET g_success='Y'
 
               CALL i710_b_tot('a')
 
               IF g_success='Y' THEN
                  LET g_rec_b=g_rec_b-1
                  DISPLAY g_rec_b TO FORMONLY.cn2
                  COMMIT WORK
               ELSE
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_sgd[l_ac].* = g_sgd_t.*
               CLOSE i710_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_sgd[l_ac].sgd05,-263,1)
               LET g_sgd[l_ac].* = g_sgd_t.*
            ELSE
               UPDATE sgd_file SET sgd05=g_sgd[l_ac].sgd05,
                                   sgd06=g_sgd[l_ac].sgd06,
                                   sgd07=g_sgd[l_ac].sgd07,
                                   sgd08=g_sgd[l_ac].sgd08,
                                   sgd10=g_sgd[l_ac].sgd10,
                                   sgd11=g_sgd[l_ac].sgd11,
                                   sgd09=g_sgd[l_ac].sgd09,          #No.FUN-810014
                                   sgd13=g_sgd[l_ac].sgd13,           #No.FUN-810014
                                   sgd14=g_sgd[l_ac].sgd14   #No.FUN-810014
                WHERE sgd00=g_sfb.sfb01
                  AND sgd01=g_sfb.sfb05
                  AND sgd02=g_sfb.sfb06
                  AND sgd03=g_ecm03
                  AND sgd04=g_ecm.ecm06
                  AND sgd05 = g_sgd_t.sgd05
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_sgd[l_ac].sgd05,SQLCA.sqlcode,0) #No.FUN-660091
                  CALL cl_err3("upd","sgd_file",g_sfb.sfb01,g_sgd_t.sgd05,SQLCA.sqlcode,"","",1) #FUN-660091
                  LET g_sgd[l_ac].* = g_sgd_t.*
               ELSE
                  LET g_success='Y'
                  CALL i710_b_tot('a')
                  IF g_success='Y' THEN
                     COMMIT WORK
                     MESSAGE 'UPDATE O.K'
                  END IF
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_sgd[l_ac].* = g_sgd_t.*
               END IF
               CLOSE i710_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i710_bcl
            COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(sgd05) AND l_ac > 1 THEN
              LET g_sgd[l_ac].* = g_sgd[l_ac-1].*
              NEXT FIELD sgd05
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp                        #
           CASE WHEN INFIELD(sgd05)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_sga"
                LET g_qryparam.default1 = g_sgd[l_ac].sgd05
                CALL cl_create_qry() RETURNING g_sgd[l_ac].sgd05
#                CALL FGL_DIALOG_SETBUFFER( g_sgd[l_ac].sgd05 )
                 DISPLAY BY NAME g_sgd[l_ac].sgd05    #No.MOD-490371
                NEXT FIELD sgd05
           END CASE
 
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
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end 
 
    END INPUT
 
    CLOSE i710_bcl
    COMMIT WORK
 
END FUNCTION
#Patch....NO.MOD-5A0095 <001,002> #
