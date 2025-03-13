# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aeci102.4gl
# Descriptions...: 產品製程單元資料維護作業
# Date & Author..: 99/06/29 By Kammy
# Modify.........: No.MOD-490371 04/09/22 By Yuna Controlp 未加display
# Modify.........: No.FUN-4B0012 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.FUN-4C0034 04/12/07 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-660091 05/06/14 By hellen cl_err --> cl_err3
# Modify.........: No.FUN-680073 06/08/21 By hongmei 欄位型態轉換
# Modify.........: No.FUN-6A0039 06/10/25 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760047 07/06/06 By xufeng  零件數,單位人力為負數無控管
# Modify.........: No.FUN-810017 08/01/21 By jan 新增服飾業作業
# Modify.........: No.FUN-830114 08/03/28 By jan 服飾作業修改
# Modify.........: No.FUN-830121 08/04/01 By jan 修改可報工否字段為非行業別字段(sgcslk01->sgc14)
# Modify.........: No.FUN-840178 08/04/24 By jan 修改服飾作業
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60021 10/06/04 By lilingyu 平行工藝 
# Modify.........: No.FUN-A60028 10/06/05 By lilingyu 規格調整,程式還原
# Modify.........: No.FUN-A70131 10/07/29 By destiny 平行工藝 
# Modify.........: No.CHI-C90006 12/11/13 By bart 無效不可進單身
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_ecu   RECORD LIKE ecu_file.*,
    g_ecb   RECORD LIKE ecb_file.*,
    g_ecu01 LIKE ecu_file.ecu01,
    g_ecu02 LIKE ecu_file.ecu02,
    g_ecu012 LIKE ecu_file.ecu012,   #FUN-A60021  #FUN-A60028
    g_ecb03 LIKE ecb_file.ecb03,
    g_argv1 LIKE ecu_file.ecu01,
    g_argv2 LIKE ecu_file.ecu02,
    g_argv3 LIKE ecu_file.ecu012,    #FUN-A60021
    g_wc,g_wc2,g_sql    STRING,               #No.FUN-580092 HCN #No.FUN-680073
    g_rec_b         LIKE type_file.num5,      #單身筆數          #No.FUN-680073 SMALLINT
    g_sgc           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        sgc05           LIKE sgc_file.sgc05,  #單元代號
        sga02           LIKE sga_file.sga02,  #名稱
        sga03           LIKE sga_file.sga03,  #規格
        Sgc06           LIKE sgc_file.sgc06,
        sgc07           LIKE sgc_file.sgc07,  #單位工時
        sgc08           LIKE sgc_file.sgc08,  #單元工時
        sgc10           LIKE sgc_file.sgc10,  #單位機時
        sgc11           LIKE sgc_file.sgc11,  #單元機時
        sgc09           LIKE sgc_file.sgc09,  #單位人力
        sgcslk05       LIKE sgc_file.sgcslk05, #單元順序       #No.FUN-810017
        sgcslk04       LIKE sgc_file.sgcslk04, #單元現實工價   #No.FUN-810017
        sgcslk03       LIKE sgc_file.sgcslk03, #單元標准工價   #No.FUN-810017
        sgcslk02       LIKE sgc_file.sgcslk02, #單元現實工時   #No.FUN-810017
        sgc13          LIKE sgc_file.sgc13,    #可委外否       #No.FUN-810017
        sgc14          LIKE sgc_file.sgc14     #可報工否       #No.FUN-830121
                    END RECORD,
    g_sgc_t         RECORD                 #程式變數 (舊值)
        sgc05           LIKE sgc_file.sgc05,      #單元代號
        sga02           LIKE sga_file.sga02,      #名稱
        sga03           LIKE sga_file.sga03,      #規格
        sgc06           LIKE sgc_file.sgc06,
        sgc07           LIKE sgc_file.sgc07,      #單位工時
        sgc08           LIKE sgc_file.sgc08,      #單元工時
        sgc10           LIKE sgc_file.sgc10,      #單位機時
        sgc11           LIKE sgc_file.sgc11,      #單元機時
        sgc09           LIKE sgc_file.sgc09,      #單位人力
        sgcslk05       LIKE sgc_file.sgcslk05,    #單元順序       #No.FUN-810017
        sgcslk04       LIKE sgc_file.sgcslk04,    #單元現實工價   #No.FUN-810017
        sgcslk03       LIKE sgc_file.sgcslk03,    #單元標准工價   #No.FUN-810017
        sgcslk02       LIKE sgc_file.sgcslk02,    #單元現實工時   #No.FUN-810017
        sgc13          LIKE sgc_file.sgc13,       #可委外否       #No.FUN-810017
        sgc14          LIKE sgc_file.sgc14        #可報工否       #No.FUN-810017
                    END RECORD,
    p_row,p_col     LIKE type_file.num5,          #No.FUN-680073 SMALLINT 
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-680073 SMALLINT
 
DEFINE g_forupd_sql         STRING   #SELECT ... FOR UPDATE SQL     
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680073 SMALLINT
DEFINE   g_cnt              LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_msg              LIKE type_file.chr1000       #No.FUN-680073
DEFINE   g_row_count        LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_curs_index       LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_jump             LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   mi_no_ask          LIKE type_file.num5          #No.FUN-680073 SMALLINT
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0100
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET g_prog = "aeci102_slk"    #No.FUN-810017                                                                                     
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
    LET g_argv3=ARG_VAL(3)     #FUN-A60021 add
 
    LET p_row = 5 LET p_col = 2
    OPEN WINDOW i102_w AT p_row,p_col
         WITH FORM "aec/42f/aeci102"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()

#FUN-A60021 --begin--
    IF g_sma.sma541 = 'Y' THEN 
       CALL cl_set_comp_visible("ecu012,ecu014",TRUE)
    ELSE
       CALL cl_set_comp_visible("ecu012,ecu014",FALSE)
    END IF   	 
#FUN-A60021 --end--
 
    IF NOT cl_null(g_argv1) THEN
       CALL i102_q()
       CALL i102_b()
    END IF
 
    CALL i102()
 
    CLOSE WINDOW i102_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
 
END MAIN
 
FUNCTION i102()
    INITIALIZE g_ecu.* TO NULL
    INITIALIZE g_ecb.* TO NULL
    CALL i102_menu()
END FUNCTION
 
FUNCTION i102_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    LET  g_wc2=' 1=1'
    CLEAR FORM
    CALL g_sgc.clear()
 
    IF cl_null(g_argv1) AND cl_null(g_argv2) AND g_argv3 IS NULL THEN  #FUN-A60021 add g_argv3
       CALL cl_set_head_visible("","YES")         #No.FUN-6B0029
 
   INITIALIZE g_ecu01 TO NULL    #No.FUN-750051
   INITIALIZE g_ecu02 TO NULL    #No.FUN-750051
   INITIALIZE g_ecu012 TO NULL   #FUN-A60021 
   INITIALIZE g_ecb03 TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON ecu01,ecu02,ecu012,ecu014,         #FUN-A60021 add ecu012,ecu014
                                 ecb03,ecb08,ecb19,ecb21,ecb38,
                                 ecb47,ecu10
                                 ,ecbslk05,ecbslk04,ecbslk02   #No.FUN-810017
 
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
       IF INT_FLAG THEN RETURN END IF
 
       CONSTRUCT g_wc2 ON sgc05,sgc06,sgc07,sgc08,sgc10,sgc11,sgc09,
                          sgcslk05,sgcslk04,sgcslk03,sgcslk02,    #No.FUN-810017
                          sgc13                                   #No.FUN-810017
                          ,sgc14                                    
                 FROM s_sgc[1].sgc05,s_sgc[1].sgc06,s_sgc[1].sgc07,
                      s_sgc[1].sgc08,s_sgc[1].sgc10,s_sgc[1].sgc11,
                      s_sgc[1].sgc09,
                      s_sgc[1].sgcslk05,s_sgc[1].sgcslk04,s_sgc[1].sgcslk03,     #No.FUN-810017
                      s_sgc[1].sgcslk02,
                      s_sgc[1].sgc13                                             #No.FUN-810017
                      ,s_sgc[1].sgc14                                         #No.FUN-810017
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
 
        ON ACTION controlp                        #
           CASE WHEN INFIELD(sgc05)
                CALL cl_init_qry_var()
                LET g_qryparam.state= "c"
                LET g_qryparam.form = "q_sga"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO sgc05
                NEXT FIELD sgc05
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
       LET g_wc= " ecu01='",g_argv1,"' AND ecu02='",g_argv2,"' AND ecu012 = '",g_argv3,"'"   #FUN-A60021 add g_argv3
    END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            # 只能使用自己的資料
    #       LET g_wc = g_wc clipped," AND ecuuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                            # 只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND ecugrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND ecugrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ecuuser', 'ecugrup')
    #End:FUN-980030
 
 
    IF g_wc2=' 1=1' OR g_wc2 IS NULL THEN
       LET g_sql="SELECT DISTINCT ecu01,ecu02,ecb03,ecu012 FROM ecu_file,ecb_file ",  #FUN-A60021 add ecu012
                 " WHERE ecu01=ecb01",
                 "   AND ecu02=ecb02",
                 "   AND ecu012=ecb012",  #FUN-A60021 
                 "   AND ", g_wc CLIPPED, " ORDER BY ecu01,ecu02,ecu012"   #FUN-A60021 add ecu012
    ELSE
       LET g_sql="SELECT DISTINCT ecu01,ecu02,ecb03,ecu012 FROM ecu_file,ecb_file,sgc_file",  #FUN-A60021 add ecu012
                 " WHERE ecu01=ecb01 ",
                 "   AND ecu02=ecb02 ",
                 "   AND ecu012= ecb012",  #FUN-A60021
                 "   AND sgc01=ecb01 ",
                 "   AND sgc02=ecb02 ",
                 "   AND sgc012=ecb012",   #FUN-A60021
                 "   AND sgc03=ecb03 ",
                 "   AND sgc04=ecb08 ",
                 "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                 " ORDER BY ecu01,ecu02,ecu012"  #FUN-A60021 add ecu012
    END IF
 
    PREPARE i102_prepare FROM g_sql                # RUNTIME 編譯
    DECLARE i102_cs SCROLL CURSOR WITH HOLD FOR i102_prepare
    IF g_wc2=' 1=1' OR g_wc2 IS NULL THEN
       LET g_sql="SELECT DISTINCT ecu01,ecu02,ecb03,ecu012 FROM ecu_file,ecb_file ",  #FUN-A60021 add ecu012
                 " WHERE ecu01=ecb01",
                 "   AND ecu02=ecb02",
                 "   AND ecu012=ecb012",  #FUN-A60021
                 "   AND ", g_wc CLIPPED
    ELSE
       LET g_sql="SELECT DISTINCT ecu01,ecu02,ecb03,ecu012 ",   #FUN-A60021 add ecu012
                 " FROM ecu_file,ecb_file,sgc_file ",
                 " WHERE ecu01=ecb01 ",
                 "   AND ecu02=ecb02 ",
                 "   AND ecu012=ecb012",  #FUN-A60021 
                 "   AND sgc01=ecb01 ",
                 "   AND sgc02=ecb02 ",
                 "   AND sgc012=ecb012",  #FUN-A60021
                 "   AND sgc03=ecb03 ",
                 "   AND sgc04=ecb08 ",
                 "   AND ",g_wc CLIPPED
    END IF
    IF INT_FLAG THEN RETURN END IF
    PREPARE i102_precount FROM g_sql
    DECLARE i102_count CURSOR FOR i102_precount
 
END FUNCTION
 
FUNCTION i102_menu()
 
   WHILE TRUE
      CALL i102_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i102_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i102_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#FUN-4B0012
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sgc),'','')
            END IF
##
        #No.FUN-6A0039-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_ecu01 IS NOT NULL THEN
                LET g_doc.column1 = "ecu01"
                LET g_doc.column2 = "ecu02"
                LET g_doc.column3 = "ecb03"
                LET g_doc.column4 = "ecu012"  #FUN-A60021
                LET g_doc.value1 = g_ecu01
                LET g_doc.value2 = g_ecu02
                LET g_doc.value3 = g_ecb03
                LET g_doc.value4 = g_ecu012   #FUN-A60021
                CALL cl_doc()
             END IF 
          END IF
        #No.FUN-6A0039-------add--------end----
      END CASE
   END WHILE
   CLOSE i102_cs
END FUNCTION
 
FUNCTION i102_q()
 DEFINE l_cnt  RECORD
        ecu01    LIKE ecu_file.ecu01,
        ecu02    LIKE ecu_file.ecu02,
        ecb03    LIKE ecb_file.ecb03
       ,ecu012   LIKE ecu_file.ecu012   #FUN-A60021 
        END RECORD
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ecu.* TO NULL              #No.FUN-6A0039
    INITIALIZE g_ecb.* TO NULL              #No.FUN-6A0039
    CALL cl_opmsg('q')
    MESSAGE ""
    CALL i102_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        CALL g_sgc.clear()
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN i102_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ecu.ecu01,SQLCA.sqlcode,0)
        INITIALIZE g_ecu.* TO NULL
        INITIALIZE g_ecb.* TO NULL
    ELSE
        FOREACH i102_count INTO l_cnt.*   #單身 ARRAY 填充
           LET g_row_count = g_row_count + 1
        END FOREACH
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i102_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION i102_fetch(p_flsgc)
    DEFINE
        p_flsgc         LIKE type_file.chr1,         #No.FUN-680073 VARCHAR(1)
        l_abso          LIKE type_file.num10         #No.FUN-680073 INTEGER
 
    CASE p_flsgc
        WHEN 'N' FETCH NEXT     i102_cs INTO g_ecu01,g_ecu02,g_ecb03,g_ecu012   #FUN-A60021 add g_ecu012
        WHEN 'P' FETCH PREVIOUS i102_cs INTO g_ecu01,g_ecu02,g_ecb03,g_ecu012   #FUN-A60021 add g_ecu012
        WHEN 'F' FETCH FIRST    i102_cs INTO g_ecu01,g_ecu02,g_ecb03,g_ecu012   #FUN-A60021 add g_ecu012
        WHEN 'L' FETCH LAST     i102_cs INTO g_ecu01,g_ecu02,g_ecb03,g_ecu012   #FUN-A60021 add g_ecu012 
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
#                     CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump i102_cs INTO g_ecu01,g_ecu02,g_ecb03,g_ecu012   #FUN-A60021 add g_ecu012
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ecu.ecu01,SQLCA.sqlcode,0)
        INITIALIZE g_ecb.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flsgc
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_ecu.* FROM ecu_file       # 重讀DB,因TEMP有不被更新特性
     WHERE ecu01= g_ecu01 AND ecu02 =g_ecu02
       AND ecu012 = g_ecu012       #FUN-A60021 
       
    IF SQLCA.sqlcode THEN INITIALIZE g_ecu.* TO NULL END IF
 
    SELECT * INTO g_ecb.* FROM ecb_file
     WHERE ecb01 =g_ecu01 AND ecb02=g_ecu02 AND ecb03=g_ecb03
       AND ecb012 = g_ecu012   #FUN-A60021
#FUN-4C0034
    IF SQLCA.sqlcode THEN
       INITIALIZE g_ecb.* TO NULL
#      CALL cl_err(g_ecu01,SQLCA.sqlcode,1) #No.FUN-660091
       CALL cl_err3("sel","ecb_file",g_ecu01,g_ecu02,SQLCA.sqlcode,"","",1) #FUN-660091
    ELSE
       LET g_data_owner = g_ecb.ecbuser      #FUN-4C0034
       LET g_data_group = g_ecb.ecbgrup      #FUN-4C0034
       CALL i102_show()                      # 重新顯示
    END IF
##
 
END FUNCTION
 
FUNCTION i102_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000   #No.FUN-680073 VARCHAR(200)
 
    CONSTRUCT g_wc2 ON sgc05,sgc06,sgc07,sgc08,sgc09,sgc10,sgc11,
                       sgcslk05,sgcslk04,sgcslk03,sgcslk02,#No.FUN-810017
                       sgc13                               #No.FUN-810017
                       ,sgc14                           #No.FUN-810017
              FROM s_sgc[1].sgc05,s_sgc[1].sgc06,s_sgc[1].sgc07,
                   s_sgc[1].sgc08,s_sgc[1].sgc09,s_sgc[1].sgc10,
                   s_sgc[1].sgc11,
                   s_sgc[1].sgcslk05,s_sgc[1].sgcslk04,s_sgc[1].sgcslk03,   #No.FUN-810017
                   s_sgc[1].sgcslk02,                                       #No.FUN-810017
                   s_sgc[1].sgc13                                           #No.FUN-810017
                   ,s_sgc[1].sgc14                                       #No.FUN-810017
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
    CALL i102_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i102_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sgc TO s_sgc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#     BEFORE ROW
#        LET l_ac = ARR_CURR()
#      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL i102_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i102_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i102_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i102_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i102_fetch('L')
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
         CALL i102_show_pic()                      #No.FUN-810017
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
 
 
 
FUNCTION i102_show()
    DEFINE l_ima02    LIKE ima_file.ima02,
           l_ima021   LIKE ima_file.ima021,
           l_b08_name LIKE eca_file.eca02
 
    DISPLAY BY NAME g_ecu.ecu01,g_ecu.ecu02,
                    g_ecu.ecu012,g_ecu.ecu014,        #FUN-A60021
                    g_ecb.ecb03,g_ecb.ecb17,g_ecb.ecb19,g_ecb.ecb08,
                    g_ecb.ecb08,g_ecb.ecb21,g_ecb.ecb38,
                    g_ecb.ecb47,g_ecu.ecu10                                #No.FUN-810017
                    ,g_ecb.ecbslk05,g_ecb.ecbslk04,g_ecb.ecbslk02          #No.FUN-810017
    SELECT ima02,ima021 INTO  l_ima02,l_ima021 FROM ima_file
     WHERE ima01 = g_ecu.ecu01
    SELECT eca02 INTO l_b08_name FROM eca_file
     WHERE eca01=g_ecb.ecb08
 
    DISPLAY l_ima02 TO FORMONLY.ima02
    DISPLAY l_ima021 TO FORMONLY.ima021
    DISPLAY l_b08_name TO FORMONLY.b08_name
 
    CALL i102_b_fill(g_wc2)
    CALL i102_show_pic()                      #No.FUN-810017
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i102_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2        LIKE type_file.chr1000  #No.FUN-680073 VARCHAR(200)
    LET g_sql = "SELECT sgc05,'','',sgc06,sgc07,sgc08,sgc10,sgc11,sgc09,",
                " sgcslk05,sgcslk04,sgcslk03,sgcslk02,sgc13,sgc14",         #No.FUN-810017
                " FROM sgc_file",
                " WHERE sgc01 = '",g_ecu01,"'  ",
                "   AND sgc02 = '",g_ecu02,"'  ",
                "   AND sgc012 = '",g_ecu012,"'",   #FUN-A60021
                "   AND sgc03 = '",g_ecb03,"'  ",
                "   AND sgc04 = '",g_ecb.ecb08,"' ",
                "   AND ", p_wc2 CLIPPED,
                " ORDER BY 1 "
    PREPARE i102_pb FROM g_sql
    DECLARE sgc_curs CURSOR FOR i102_pb
 
    CALL g_sgc.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
 
    FOREACH sgc_curs INTO g_sgc[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET l_ac=g_cnt
      CALL i102_sgc05_1('d')#No.FUN-830114
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
 
    END FOREACH
    CALL g_sgc.deleteElement(g_cnt)
 
    LET g_rec_b= g_cnt-1
 
    DISPLAY g_rec_b TO FORMONLY.cn2
 
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i102_sgc05(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
    LET g_errno = ' '
#No.FUN-840178--BEGIN--
#&ifdef SLK
#   #No.FUN-810017--BEGIN
#   IF cl_null(g_sgc[l_ac].sgc06) THEN
#      LET g_sgc[l_ac].sgc06 = 0
#   END IF
#   #No.FUN-810017--END
#&endif
#No.FUN-840178--END--
 
    CASE WHEN p_cmd = 'a'
              SELECT sga02,sga03,sga04,sga06,sga07,sga08                #No.FUN-840178
                     #No.FUN-810017--BEGIN
                     ,sgaslk03,sgaslk04    #,sgaslk02*g_sgc[l_ac].sgc06 #No.FUN-840178
                     #No.FUN-810017--END
                INTO g_sgc[l_ac].sga02,g_sgc[l_ac].sga03,
                     g_sgc[l_ac].sgc07,g_sgc[l_ac].sgc10,
                     g_sgc[l_ac].sgc13,g_sgc[l_ac].sgc14                #No.FUN-840178
                     #No.FUN-810017--BEGIN
                     ,g_sgc[l_ac].sgcslk03,g_sgc[l_ac].sgcslk04
                   # g_sgc[l_ac].sgcslk02     #No.FUN-840178
                     #No.FUN-810017--END
                FROM  sga_file
               WHERE sga01 = g_sgc[l_ac].sgc05
         WHEN p_cmd = 'd'
              SELECT sga02,sga03
                     #No.FUN-810017--BEGIN
                     ,sgaslk03,sgaslk04,sgaslk02*g_sgc[l_ac].sgc06
                     #No.FUN-810017--END
                INTO g_sgc[l_ac].sga02,g_sgc[l_ac].sga03
                     #No.FUN-810017--BEGIN
                     ,g_sgc[l_ac].sgcslk03,g_sgc[l_ac].sgcslk04,
                     g_sgc[l_ac].sgcslk02
                     #No.FUN-810017--END
                FROM sga_file
               WHERE sga01 = g_sgc[l_ac].sgc05
    END CASE
 
    CASE
         WHEN SQLCA.SQLCODE = 100
              LET g_errno = 'aec-012'
              LET g_sgc[l_ac].sgc05 = NULL
         WHEN SQLCA.SQLCODE ! = 0
              LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
END FUNCTION
#No.FUN-830114--BEGIN--
FUNCTION i102_sgc05_1(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
    LET g_errno = ' '
 
    CASE WHEN p_cmd = 'a'
              SELECT sga02,sga03
                INTO g_sgc[l_ac].sga02,g_sgc[l_ac].sga03
                FROM  sga_file
               WHERE sga01 = g_sgc[l_ac].sgc05
         WHEN p_cmd = 'd'
              SELECT sga02,sga03
                INTO g_sgc[l_ac].sga02,g_sgc[l_ac].sga03
                FROM sga_file
               WHERE sga01 = g_sgc[l_ac].sgc05
    END CASE
 
    CASE
         WHEN SQLCA.SQLCODE = 100
              LET g_errno = 'aec-012'
              LET g_sgc[l_ac].sgc05 = NULL
         WHEN SQLCA.SQLCODE ! = 0
              LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
END FUNCTION
#No.FUN-830114--END
 
FUNCTION i102_b_tot()
    DEFINE ttecb19 LIKE ecb_file.ecb19,
           ttecb38 LIKE ecb_file.ecb38,
           ttecb21 LIKE ecb_file.ecb21
 
    SELECT SUM(sgc08),SUM(sgc09),SUM(sgc11) INTO ttecb19,ttecb38,ttecb21
            FROM sgc_file
            WHERE sgc01=g_ecu.ecu01 AND sgc02=g_ecu.ecu02
              AND sgc012=g_ecu.ecu012              #FUN-A60021 add
              AND sgc03=g_ecb.ecb03  AND sgc04 = g_ecb.ecb08
    DISPLAY ttecb19 TO ecb19
    DISPLAY ttecb38 TO ecb38
    DISPLAY ttecb21 TO ecb21
    UPDATE ecb_file SET ecb19=ttecb19,
                        ecb38=ttecb38,
                        ecb21=ttecb21
      WHERE ecb01=g_ecu.ecu01
        AND ecb02=g_ecu.ecu02
        AND ecb012 = g_ecu.ecu012   #FUN-A60021 add
        AND ecb03=g_ecb03
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#      CALL cl_err('update ecb_file failure',SQLCA.sqlcode,1) #No.FUN-660091
       CALL cl_err3("upd","ecb_file",g_ecu.ecu01,g_ecu.ecu02,SQLCA.sqlcode,"","update ecb_file failure",1) #FUN-660091
    END IF
END FUNCTION
 
#No.FUN-810017--Begin
FUNCTION i102_show_pic()
       CALL cl_set_field_pic1(g_ecu.ecu10,"","","","",g_ecu.ecuacti,"","")
END FUNCTION
#No.FUN-810017--End
 
FUNCTION i102_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680073 SMALLINT SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680073 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680073 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680073 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680073 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680073 SMALLINT
DEFINE l_sgcslk02 LIKE sgc_file.sgcslk02                #No.FUN-840178
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_ecu.ecu01 IS NULL THEN RETURN END IF
    IF g_ecu.ecuacti='N' THEN RETURN END IF  #CHI-C90006
#No.FUN-810017--Begin
    IF g_ecu.ecu10 = 'Y' THEN
       CALL cl_err('','mfg1005',0)
       RETURN
    END IF
#No.FUN-810017--End
 
    SELECT * INTO g_ecu.* FROM ecu_file WHERE ecu01= g_ecu01 AND ecu02 =g_ecu02
      AND ecu012 = g_ecu012           #FUN-A60021
    IF SQLCA.sqlcode THEN INITIALIZE g_ecu.* TO NULL END IF
 
    SELECT * INTO g_ecb.* FROM ecb_file
     WHERE ecb01 =g_ecu01 AND ecb02=g_ecu02 AND ecb03=g_ecb03
       AND ecb012 = g_ecu012   #FUN-A60021
    IF SQLCA.sqlcode THEN INITIALIZE g_ecb.* TO NULL END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT sgc05,'','',sgc06,sgc07,sgc08,sgc10,sgc11,sgc09,",
                       "       sgcslk05,sgcslk04,sgcslk03,sgcslk02,sgc13,sgc14", #No.FUN-810017   
                       " FROM sgc_file ",
                       "WHERE sgc01 = ? AND sgc02 = ? AND sgc03 = ? ",
                       " AND sgc04 = ? AND sgc05 = ? AND sgc012 = ? FOR UPDATE"  #FUN-A60021 add sgc012
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i102_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_sgc WITHOUT DEFAULTS FROM s_sgc.*
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
 
            IF g_rec_b >= l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_sgc_t.* = g_sgc[l_ac].*  #BACKUP
               OPEN i102_bcl USING g_ecu01,g_ecu02,g_ecb03,g_ecb.ecb08,
                                   g_sgc_t.sgc05,g_ecu012    #FUN-A60021 add g_ecu012
               IF STATUS THEN
                  CALL cl_err("OPEN i102_bcl:", STATUS, 1)
                  CLOSE i102_bcl
                  ROLLBACK WORK
                  RETURN
               ELSE
                  FETCH i102_bcl INTO g_sgc[l_ac].*
                  IF SQLCA.sqlcode THEN
                      CALL cl_err('fetch i102_bcl:',SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                  ELSE
#                      CALL  i102_sgc05('d')  #No.FUN-840178
                       CALL i102_sgc05_1('d') #No.FUN-840178
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_sgc[l_ac].* TO NULL      #900423
            LET g_sgc[l_ac].sgc07 = 0
            LET g_sgc[l_ac].sgc08 = 0
            LET g_sgc[l_ac].sgc09 = 0
            LET g_sgc[l_ac].sgc10 = 0
            LET g_sgc[l_ac].sgc11 = 0
            LET g_sgc[l_ac].sgc13 = 'N'          #No.FUN-810017
            LET g_sgc[l_ac].sgc14 = 'N'       #No.FUN-810017
            LET g_sgc_t.* = g_sgc[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD sgc05
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            #No.FUN-A70131--begin
            IF cl_null(g_ecu.ecu012) THEN 
               LET g_ecu.ecu012=' '
            END IF 
            IF cl_null(g_ecb.ecb03) THEN 
               LET g_ecb.ecb03=0
            END IF 
            #No.FUN-A70131--end
            INSERT INTO sgc_file(sgc01,sgc02,sgc03,sgc04,sgc05,sgc06,
                                 sgc07,sgc08,sgc09,sgc10,sgc11,
                                 sgcslk05,sgcslk04,sgcslk03,sgcslk02,     #No.FUN-810017
                                 sgc13                                    #No.FUN-810017
                                 ,sgc14                                #No.FUN-810017
                                 ,sgc012)                                #FUN-A60021 add sgc012
                          VALUES(g_ecu.ecu01,g_ecu.ecu02,g_ecb.ecb03,
                                 g_ecb.ecb08,
                                 g_sgc[l_ac].sgc05,g_sgc[l_ac].sgc06,
                                 g_sgc[l_ac].sgc07,g_sgc[l_ac].sgc08,
                                 g_sgc[l_ac].sgc09,g_sgc[l_ac].sgc10,
                                 g_sgc[l_ac].sgc11,
                                 g_sgc[l_ac].sgcslk05,g_sgc[l_ac].sgcslk04,  #No.FUN-810017
                                 g_sgc[l_ac].sgcslk03,g_sgc[l_ac].sgcslk02,  #No.FUN-810017
                                 g_sgc[l_ac].sgc13                           #No.FUN-810017
                                 ,g_sgc[l_ac].sgc14                       #No.FUN-810017
                                 ,g_ecu.ecu012)  #FUN-A60021 add ecu012
            IF SQLCA.sqlcode THEN
#              CALL cl_err('ins sgc:',SQLCA.sqlcode,1) #No.FUN-660091
               CALL cl_err3("ins","sgc_file",g_ecu.ecu01,g_ecu.ecu02,SQLCA.sqlcode,"","ins sgc:",1) #FUN-660091
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
               CALL i102_b_tot()
            END IF
 
        AFTER FIELD sgc05
            IF NOT cl_null(g_sgc[l_ac].sgc05) THEN
               IF g_sgc[l_ac].sgc05 != g_sgc_t.sgc05 OR
                  g_sgc_t.sgc05 IS NULL THEN
                   SELECT count(*) INTO l_n FROM sgc_file
                    WHERE sgc01 = g_ecu.ecu01
                      AND sgc02 = g_ecu.ecu02
                      AND sgc012=g_ecu.ecu012   #FUN-A60021 
                      AND sgc03 = g_ecb.ecb03
                      AND sgc04 = g_ecb.ecb08
                      AND sgc05 = g_sgc[l_ac].sgc05
                   IF l_n > 0 THEN
                      CALL cl_err('',-239,0)
                      LET g_sgc[l_ac].sgc05 = g_sgc_t.sgc05
                      NEXT FIELD sgc05
                   END IF
 
                   CALL i102_sgc05('a')
                   IF NOT cl_null(g_errno)  THEN
                      CALL cl_err('',g_errno,0)
                      LET g_sgc[l_ac].sgc05 = g_sgc_t.sgc05
                      NEXT FIELD sgc05
                   END IF
               END IF
            END IF
 
        AFTER FIELD sgc06
            IF NOT cl_null(g_sgc[l_ac].sgc06) THEN
             IF cl_null(g_sgc_t.sgc06) OR g_sgc[l_ac].sgc06 != g_sgc_t.sgc06#No.FUN-840178 
                OR g_sgc[l_ac].sgc05 != g_sgc_t.sgc05 THEN                  #No.FUN-840178
               IF g_sgc[l_ac].sgc06 = 0  THEN
                  NEXT FIELD sgc06
               END IF
               LET g_sgc[l_ac].sgc08 = g_sgc[l_ac].sgc07 * g_sgc[l_ac].sgc06
               LET g_sgc[l_ac].sgc11 = g_sgc[l_ac].sgc10 * g_sgc[l_ac].sgc06
               #No.FUN-840178--BEGIN--
               SELECT sgaslk02 INTO l_sgcslk02 
                 FROM sga_file
                WHERE sga01 = g_sgc[l_ac].sgc05
               LET g_sgc[l_ac].sgcslk02 = l_sgcslk02 * g_sgc[l_ac].sgc06
               DISPLAY BY NAME g_sgc[l_ac].sgcslk02            
               #No.FUN-840178--END
               #------MOD-5A0095 START----------
               DISPLAY BY NAME g_sgc[l_ac].sgc08
               DISPLAY BY NAME g_sgc[l_ac].sgc11
               #------MOD-5A0095 END------------
               #No.TQC-760047     --begin
               IF g_sgc[l_ac].sgc06 <1 THEN
                  CALL cl_err('','aec-020',0) #No.FUN-810017報錯信息有誤
                  NEXT FIELD sgc06
               END IF
               #No.TQC-760047     --end   
             END IF                           #No.FUN-840178
            END IF
 
        BEFORE FIELD sgc09
            IF cl_null(g_sma.sma551) THEN
               LET g_sma.sma551=480
            END IF
            LET g_sgc[l_ac].sgc09 = g_sgc[l_ac].sgc08 / (g_sma.sma551 * 60)
            IF g_sgc[l_ac].sgc09 < 0.001 THEN
               LET g_sgc[l_ac].sgc09 = 0.001
            END IF
            #------MOD-5A0095 START----------
            DISPLAY BY NAME g_sgc[l_ac].sgc09
            #------MOD-5A0095 END------------
 
        AFTER FIELD sgc09
            IF NOT cl_null(g_sgc[l_ac].sgc09) THEN
               IF g_sgc[l_ac].sgc09 = 0  THEN
                  NEXT FIELD sgc09
               END IF
               #No.TQC-760047     --begin
               IF g_sgc[l_ac].sgc09 <=0 THEN
                  CALL cl_err('','aec-994',0)
                  NEXT FIELD sgc09
               END IF
               #No.TQC-760047     --end   
            END IF
            
#No.FUN-810017--Begin
        AFTER FIELD sgcslk05                                                                                                           
            IF NOT cl_null(g_sgc[l_ac].sgcslk05) THEN                                                                                  
               IF g_sgc[l_ac].sgcslk05 < 0 THEN                                                                                        
                  CALL cl_err(g_sgc[l_ac].sgcslk05,'anm-249',0)                                                                        
                  NEXT FIELD sgcslk05                                                                                                  
               END IF                                                                                                               
            END IF
 
        AFTER FIELD sgcslk04                                                                                                           
            IF NOT cl_null(g_sgc[l_ac].sgcslk04) THEN                                                                                  
               IF g_sgc[l_ac].sgcslk04 < 0 THEN                                                                                        
                  CALL cl_err(g_sgc[l_ac].sgcslk04,'anm-249',0)                                                                        
                  NEXT FIELD sgcslk04                                                                                                  
               END IF                                                                                                               
            END IF
 
        AFTER FIELD sgcslk03                                                                                                           
            IF NOT cl_null(g_sgc[l_ac].sgcslk03) THEN                                                                                  
               IF g_sgc[l_ac].sgcslk03 < 0 THEN                                                                                        
                  CALL cl_err(g_sgc[l_ac].sgcslk03,'anm-249',0)                                                                        
                  NEXT FIELD sgcslk03                                                                                                  
               END IF                                                                                                               
            END IF
 
        AFTER FIELD sgcslk02                                                                                                           
            IF NOT cl_null(g_sgc[l_ac].sgcslk02) THEN                                                                                  
               IF g_sgc[l_ac].sgcslk02 < 0 THEN                                                                                        
                  CALL cl_err(g_sgc[l_ac].sgcslk02,'anm-249',0)                                                                        
                  NEXT FIELD sgcslk02                                                                                                  
               END IF                                                                                                               
            END IF
#No.FUN-810017--End       
 
        BEFORE DELETE                            #是否取消單身
            IF g_sgc_t.sgc05 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
 
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
 
               DELETE FROM sgc_file
               WHERE sgc01=g_ecu.ecu01 AND sgc02=g_ecu.ecu02
                 AND sgc012=g_ecu.ecu012   #FUN-A60021
                 AND sgc03=g_ecb.ecb03 AND sgc04 = g_ecb.ecb08
                 AND sgc05=g_sgc[l_ac].sgc05
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_sgc_t.sgc05,SQLCA.sqlcode,0) #No.FUN-660091
                  CALL cl_err3("del","sgc_file",g_ecu.ecu01,g_ecu.ecu02,SQLCA.sqlcode,"","",1) #FUN-660091
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
 
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
               COMMIT WORK
 
               CALL i102_b_tot()
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_sgc[l_ac].* = g_sgc_t.*
               CLOSE i102_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
 
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_sgc[l_ac].sgc05,-263,1)
               LET g_sgc[l_ac].* = g_sgc_t.*
            ELSE
               UPDATE sgc_file SET sgc05=g_sgc[l_ac].sgc05,
                                   sgc06=g_sgc[l_ac].sgc06,
                                   sgc07=g_sgc[l_ac].sgc07,
                                   sgc08=g_sgc[l_ac].sgc08,
                                   sgc09=g_sgc[l_ac].sgc09,
                                   sgcslk05=g_sgc[l_ac].sgcslk05,    #No.FUN-810017
                                   sgcslk04=g_sgc[l_ac].sgcslk04,    #No.FUN-810017
                                   sgcslk03=g_sgc[l_ac].sgcslk03,    #No.FUN-810017
                                   sgcslk02=g_sgc[l_ac].sgcslk02,    #No.FUN-810017
                                   sgc13=g_sgc[l_ac].sgc13,          #No.FUN-810017
                                   sgc14=g_sgc[l_ac].sgc14,    #No.FUN-810017
                                   sgc10=g_sgc[l_ac].sgc10,
                                   sgc11=g_sgc[l_ac].sgc11
                WHERE sgc01 = g_ecu01
                  AND sgc02 = g_ecu02
                  AND sgc012 = g_ecu012   #FUN-A60021
                  AND sgc03 = g_ecb.ecb03
                  AND sgc04 = g_ecb.ecb08
                  AND sgc05 = g_sgc_t.sgc05
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                 CALL cl_err(g_sgc[l_ac].sgc05,SQLCA.sqlcode,0) #No.FUN-660091
                  CALL cl_err3("upd","sgc_file",g_ecu01,g_sgc_t.sgc05,SQLCA.sqlcode,"","",1) #FUN-660091
                  LET g_sgc[l_ac].* = g_sgc_t.*
                  ROLLBACK WORK
               ELSE
                  MESSAGE 'UPDATE O.K'
                  CALL i102_b_tot()
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_sgc[l_ac].* = g_sgc_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_sgc.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i102_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i102_bcl
            COMMIT WORK
 
        ON ACTION controlp                        #
           CASE WHEN INFIELD(sgc05)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_sga"
                LET g_qryparam.default1 = g_sgc[l_ac].sgc05
                CALL cl_create_qry() RETURNING g_sgc[l_ac].sgc05
#                CALL FGL_DIALOG_SETBUFFER( g_sgc[l_ac].sgc05 )
                 DISPLAY BY NAME  g_sgc[l_ac].sgc05      #No.MOD-490371
                NEXT FIELD sgc05
           END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(sgc05) AND l_ac > 1 THEN
              LET g_sgc[l_ac].* = g_sgc[l_ac-1].*
              NEXT FIELD sgc05
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
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end  
 
    END INPUT
 
    CLOSE i102_bcl
    COMMIT WORK
 
END FUNCTION
#Patch....NO.MOD-5A0095 <001,002> #
