# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aeci110.4gl
# Descriptions...: 產品製程資源資料維護作業
# Date & Author..: 00/05/21 By Carol
# Modify.........: No.MOD-490371 04/09/22 By Yuna Controlp 未加display
# Modify.........: No.FUN-4B0012 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.FUN-4C0034 04/12/07 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-660091 05/06/14 By hellen cl_err --> cl_err3
# Modify.........: No.FUN-680073 06/08/21 By hongmei 欄位型態轉換
# Modify.........: No.FUN-690022 06/09/18 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0039 06/10/25 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6C0178 06/12/28 By Ray 修改刪除提示信息
# Modify.........: No.TQC-6C0220 07/01/09 By rainy QBE單身下條件查詢出來的筆數錯誤
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.FUN-840068 08/04/22 By TSD.lucasyeh 自定欄位功能修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60021 10/06/04 By lilingyu 平行工藝
# Modify.........: No.CHI-C90006 12/11/13 By bart 失效不可進單身
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_ecb   RECORD LIKE ecb_file.*,
    g_ecb_t RECORD LIKE ecb_file.*,
    g_ecb01 LIKE ecb_file.ecb01,
    g_ecb012 LIKE ecb_file.ecb012, #FUN-A60021
    g_ecb02 LIKE ecb_file.ecb02,
    g_ecb03 LIKE ecb_file.ecb03,
    g_ecb01_t LIKE ecb_file.ecb01,
    g_ecb012_t LIKE ecb_file.ecb012,   #FUN-A60021
    g_ecb02_t LIKE ecb_file.ecb02,
    g_ecb03_t LIKE ecb_file.ecb03,
    g_argv1 LIKE ecb_file.ecb01,    
    g_argv2 LIKE ecb_file.ecb02,
    g_argv3 LIKE ecb_file.ecb012,  #FUN-A60021    
     g_wc,g_wc2,g_sql    STRING,  #No.FUN-580092 HCN    
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680073 SMALLINT
    g_eco           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        eco04           LIKE eco_file.eco04,      #資源代號
        rpf02           LIKE rpf_file.rpf02,      #資源說明
        rpf07           LIKE rpf_file.rpf07,      #粗略產能考慮否
        eco05           LIKE eco_file.eco05,      #固定秏用
        eco06           LIKE eco_file.eco06,      #變動秏用
        eco07           LIKE eco_file.eco07,      #秏用批量
        eco08           LIKE eco_file.eco08       #備註
       #FUN-840068 --start---
       ,ecoud01         LIKE eco_file.ecoud01,
        ecoud02         LIKE eco_file.ecoud02,
        ecoud03         LIKE eco_file.ecoud03,
        ecoud04         LIKE eco_file.ecoud04,
        ecoud05         LIKE eco_file.ecoud05,
        ecoud06         LIKE eco_file.ecoud06,
        ecoud07         LIKE eco_file.ecoud07,
        ecoud08         LIKE eco_file.ecoud08,
        ecoud09         LIKE eco_file.ecoud09,
        ecoud10         LIKE eco_file.ecoud10,
        ecoud11         LIKE eco_file.ecoud11,
        ecoud12         LIKE eco_file.ecoud12,
        ecoud13         LIKE eco_file.ecoud13,
        ecoud14         LIKE eco_file.ecoud14,
        ecoud15         LIKE eco_file.ecoud15
       #FUN-840068 --end--
 
                    END RECORD,
    g_eco_t         RECORD                 #程式變數 (舊值)
        eco04           LIKE eco_file.eco04,      #資源代號
        rpf02           LIKE rpf_file.rpf02,      #資源說明
        rpf07           LIKE rpf_file.rpf07,      #粗略產能考慮否
        eco05           LIKE eco_file.eco05,      #固定秏用
        eco06           LIKE eco_file.eco06,      #變動秏用
        eco07           LIKE eco_file.eco07,      #秏用批量
        eco08           LIKE eco_file.eco08       #備註
       #FUN-840068 --start---
       ,ecoud01         LIKE eco_file.ecoud01,
        ecoud02         LIKE eco_file.ecoud02,
        ecoud03         LIKE eco_file.ecoud03,
        ecoud04         LIKE eco_file.ecoud04,
        ecoud05         LIKE eco_file.ecoud05,
        ecoud06         LIKE eco_file.ecoud06,
        ecoud07         LIKE eco_file.ecoud07,
        ecoud08         LIKE eco_file.ecoud08,
        ecoud09         LIKE eco_file.ecoud09,
        ecoud10         LIKE eco_file.ecoud10,
        ecoud11         LIKE eco_file.ecoud11,
        ecoud12         LIKE eco_file.ecoud12,
        ecoud13         LIKE eco_file.ecoud13,
        ecoud14         LIKE eco_file.ecoud14,
        ecoud15         LIKE eco_file.ecoud15
       #FUN-840068 --end--
 
                    END RECORD,
    p_row,p_col     LIKE type_file.num5,          #No.FUN-680073 SMALLINT SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680073 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL  
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680073 SMALLINT
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680073 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680073 SMALLINT
 
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
    LET g_argv3=ARG_VAL(3)      #FUN-A60021 
    
    LET p_row = 3 LET p_col = 15
    OPEN WINDOW i110_w AT p_row,p_col
         WITH FORM "aec/42f/aeci110"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    
#FUN-A60021 --begin--
   IF g_sma.sma541 = 'Y' THEN 
      CALL cl_set_comp_visible("ecb012,ecu014",TRUE)
   ELSE
      CALL cl_set_comp_visible("ecb012,ecu014",FALSE)
   END IF        
#FUN-A60021 --end--    
 
    INITIALIZE g_ecb.* TO NULL
    LET g_forupd_sql = "SELECT * FROM ecb_file WHERE ecb01=? AND ecb02=? AND ecb03=? AND ecb012 = ? FOR UPDATE" #FUN-A60021 add ecb012
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i110_cl CURSOR FROM g_forupd_sql
 
    IF NOT cl_null(g_argv1) THEN
       CALL i110_q()
       CALL i110_b()
    END IF
    CALL i110_menu()
    CLOSE WINDOW i110_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
END MAIN
 
FUNCTION i110_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    LET  g_wc2=' 1=1'
    CLEAR FORM
    CALL g_eco.clear()
    IF cl_null(g_argv1) AND cl_null(g_argv2) AND g_argv3 IS NULL THEN  #FUN-A60021 add g_argv3
       CALL cl_set_head_visible("","YES")         #No.FUN-6B0029 
 
   INITIALIZE g_ecb01 TO NULL    #No.FUN-750051
   INITIALIZE g_ecb012 TO NULL    #FUN-A60021 add
   INITIALIZE g_ecb02 TO NULL    #No.FUN-750051
   INITIALIZE g_ecb03 TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON ecb01,ecb02,ecb012,ecu014,ecb03,ecb06,ecb08   #FUN-A60021 add ecb012,ecu014
                                #FUN-840068   ---start---
                                ,ecbud01,ecbud02,ecbud03,ecbud04,ecbud05,
                                 ecbud06,ecbud07,ecbud08,ecbud09,ecbud10,
                                 ecbud11,ecbud12,ecbud13,ecbud14,ecbud15
                                #FUN-840068    ----end----
 
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
 
       CONSTRUCT g_wc2 ON eco04,eco05,eco06,eco07,eco08
                         #No.FUN-840068 --start--
                         ,ecoud01,ecoud02,ecoud03,ecoud04,ecoud05
                         ,ecoud06,ecoud07,ecoud08,ecoud09,ecoud10
                         ,ecoud11,ecoud12,ecoud13,ecoud14,ecoud15
                         #No.FUN-840068 ---end---
                 FROM s_eco[1].eco04,s_eco[1].eco05,
                      s_eco[1].eco06,s_eco[1].eco07,s_eco[1].eco08
                     #No.FUN-840068 --start--
                     ,s_eco[1].ecoud01,s_eco[1].ecoud02,s_eco[1].ecoud03
                     ,s_eco[1].ecoud04,s_eco[1].ecoud05,s_eco[1].ecoud06
                     ,s_eco[1].ecoud07,s_eco[1].ecoud08,s_eco[1].ecoud09
                     ,s_eco[1].ecoud10,s_eco[1].ecoud11,s_eco[1].ecoud12
                     ,s_eco[1].ecoud13,s_eco[1].ecoud14,s_eco[1].ecoud15
                     #No.FUN-840068 ---end---
 
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
 
        ON ACTION controlp                        #
           CASE WHEN INFIELD(eco04)
                CALL cl_init_qry_var()
                LET g_qryparam.state    = "c"
                LET g_qryparam.form = "q_rpf"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO eco04
                NEXT FIELD eco04
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
       LET g_wc= " ecb01='",g_argv1,"' AND ecb02='",g_argv2,"' AND ecb012 = '",g_argv3,"'"  #FUN-A60021 add g_argv3
       LET g_wc2= " 1=1"
    END IF
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            # 只能使用自己的資料
    #       LET g_wc = g_wc clipped," AND ecbuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                            # 只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND ecbgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND ecbgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ecbuser', 'ecbgrup')
    #End:FUN-980030
 
    IF cl_null(g_wc2) THEN LET g_wc2=' 1=1' END IF
 
    IF g_wc2=' 1=1' THEN
       LET g_sql="SELECT ecb01,ecb02,ecb03,ecb012 FROM ecb_file ",   #FUN-A60021 add ecb012
                 " WHERE ",g_wc CLIPPED," ORDER BY 1,2,3,4" CLIPPED  #FUN-A60021 add 4
    ELSE
       LET g_sql="SELECT ecb01,ecb02,ecb03,ecb012 ",   #FUN-A60021 add ecb012
                 " FROM ecb_file,eco_file",
                 " WHERE ecb01=eco01 ",
                 "   AND ecb012=eco012",   #FUN-A60021
                 "   AND ecb02=eco02 ",
                 "   AND ecb03=eco03 ",
                 "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                 " ORDER BY 1,2,3,4 " CLIPPED                  #FUN-A60021 add4
    END IF
 
    PREPARE i110_prepare FROM g_sql                # RUNTIME 編譯
    DECLARE i110_cs SCROLL CURSOR WITH HOLD FOR i110_prepare
    IF g_wc2=' 1=1' THEN
       LET g_sql= "SELECT COUNT(*) FROM ecb_file WHERE ",g_wc CLIPPED
    ELSE
       #LET g_sql="SELECT COUNT(*) FROM ecb_file,eco_file",              #TQC-6C0220
       LET g_sql="SELECT COUNT(UNIQUE ecb01||ecb02||ecb03||ecb012) FROM ecb_file,eco_file",    #TQC-6C0220 #FUN-A60021 ADD ecb012
                 " WHERE ecb01=eco01 ",
                 "   AND ecb012=eco012",   #FUN-A60021 add
                 "   AND ecb02=eco02 ",
                 "   AND ecb03=eco03 ",
                 "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE i110_precount FROM g_sql
    DECLARE i110_count CURSOR FOR i110_precount
 
END FUNCTION
 
FUNCTION i110_menu()
 
   WHILE TRUE
      CALL i110_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i110_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i110_r()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i110_b()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_eco),'','')
            END IF
##
 
        #No.FUN-6A0039-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_ecb01 IS NOT NULL THEN
                LET g_doc.column1 = "ecb01"
                LET g_doc.column2 = "ecb02"
                LET g_doc.column3 = "ecb03"
                LET g_doc.column4 = "ecb012"  #FUN-A60021
                LET g_doc.value1 = g_ecb01
                LET g_doc.value2 = g_ecb02
                LET g_doc.value3 = g_ecb03
                LET g_doc.value4 = g_ecb012   #FUN-A60021
                CALL cl_doc()
             END IF 
          END IF
        #No.FUN-6A0039-------add--------end----
      END CASE
   END WHILE
      CLOSE i110_cs
END FUNCTION
 
FUNCTION i110_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ecb.* TO NULL              #No.FUN-6A0039
    CALL cl_opmsg('q')
    MESSAGE ""
    CALL i110_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       CALL g_eco.clear()
       RETURN
    END IF
    MESSAGE " SEARCHING ! "
 
    OPEN i110_count
    FETCH i110_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i110_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ecb.ecb01,SQLCA.sqlcode,0)
       INITIALIZE g_ecb.* TO NULL
    ELSE
       CALL i110_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION i110_fetch(p_fleco)
    DEFINE
        p_fleco         LIKE type_file.chr1,         #No.FUN-680073 VARCHAR(1)
        l_abso          LIKE type_file.num10         #No.FUN-680073 INTEGER
 
    CASE p_fleco
        WHEN 'N' FETCH NEXT     i110_cs INTO g_ecb01,g_ecb02,g_ecb03,g_ecb012   #FUN-A60021 add g_ecb012
        WHEN 'P' FETCH PREVIOUS i110_cs INTO g_ecb01,g_ecb02,g_ecb03,g_ecb012   #FUN-A60021 add g_ecb012
        WHEN 'F' FETCH FIRST    i110_cs INTO g_ecb01,g_ecb02,g_ecb03,g_ecb012   #FUN-A60021 add g_ecb012
        WHEN 'L' FETCH LAST     i110_cs INTO g_ecb01,g_ecb02,g_ecb03,g_ecb012   #FUN-A60021 add g_ecb012
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
            FETCH ABSOLUTE g_jump i110_cs INTO g_ecb01,g_ecb02,g_ecb03,g_ecb012   #FUN-A60021 add g_ecb012
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ecb.ecb01,SQLCA.sqlcode,0)
        INITIALIZE g_ecb.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_fleco
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_ecb.* FROM ecb_file   #重讀DB,因TEMP有不被更新特性
     WHERE ecb01=g_ecb01 AND ecb02=g_ecb02 AND ecb03=g_ecb03
       AND ecb012 = g_ecb012    #FUN-A60021 
#FUN-4C0034
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_ecb.ecb01,SQLCA.sqlcode,1) #No.FUN-660091
       CALL cl_err3("sel","ecb_file",g_ecb.ecb01,g_ecb.ecb02,SQLCA.sqlcode,"","",1) #FUN-660091
       INITIALIZE g_ecb.* TO NULL
    ELSE
       LET g_data_owner = g_ecb.ecbuser      #FUN-4C0034
       LET g_data_group = g_ecb.ecbgrup      #FUN-4C0034
       CALL i110_show()                      # 重新顯示
    END IF
##
 
END FUNCTION
 
FUNCTION i110_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000    #No.FUN-680073 VARCHAR(200)
 
    CONSTRUCT g_wc2 ON eco04,eco05,eco06,eco07,eco08
                      #No.FUN-840068 --start--
                      ,ecoud01,ecoud02,ecoud03,ecoud04,ecoud05
                      ,ecoud06,ecoud07,ecoud08,ecoud09,ecoud10
                      ,ecoud11,ecoud12,ecoud13,ecoud14,ecoud15
                      #No.FUN-840068 ---end---
 
              FROM s_eco[1].eco04,s_eco[1].eco05,
                   s_eco[1].eco06,s_eco[1].eco07,s_eco[1].eco08
                  #No.FUN-840068 --start--
                  ,s_eco[1].ecoud01,s_eco[1].ecoud02,s_eco[1].ecoud03
                  ,s_eco[1].ecoud04,s_eco[1].ecoud05,s_eco[1].ecoud06
                  ,s_eco[1].ecoud07,s_eco[1].ecoud08,s_eco[1].ecoud09
                  ,s_eco[1].ecoud10,s_eco[1].ecoud11,s_eco[1].ecoud12
                  ,s_eco[1].ecoud13,s_eco[1].ecoud14,s_eco[1].ecoud15
                  #No.FUN-840068 ---end---
 
 
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
    CALL i110_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i110_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_eco TO s_eco.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION first
         CALL i110_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i110_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i110_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i110_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i110_fetch('L')
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
 
      #FUN-810046
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i110_show()
    DEFINE l_ima02    LIKE ima_file.ima02,
           l_ima021   LIKE ima_file.ima021,
           l_eca02    LIKE eca_file.eca02
    DEFINE l_ecu014   LIKE ecu_file.ecu014   #FUN-A60021 
    
    DISPLAY BY NAME g_ecb.ecb01,g_ecb.ecb02,g_ecb.ecb03,g_ecb.ecb06,
                    g_ecb.ecb17,g_ecb.ecb08
                   ,g_ecb.ecb012                #FUN-A60021 
                   #FUN-840068     ---start---
                   ,g_ecb.ecbud01,g_ecb.ecbud02,g_ecb.ecbud03,g_ecb.ecbud04,
                    g_ecb.ecbud05,g_ecb.ecbud06,g_ecb.ecbud07,g_ecb.ecbud08,
                    g_ecb.ecbud09,g_ecb.ecbud10,g_ecb.ecbud11,g_ecb.ecbud12,
                    g_ecb.ecbud13,g_ecb.ecbud14,g_ecb.ecbud15
                   #FUN-840068     ----end----
#FUN-A60021 --begin--
   LET l_ecu014 = NULL
   SELECT ecu014 INTO l_ecu014 FROM ecu_file
    WHERE ecu01  = g_ecb.ecb01
      AND ecu02  = g_ecb.ecb02
      AND ecu012 = g_ecb.ecb012
   DISPLAY l_ecu014 TO ecu014   
#FUN-A60021 --end-- 
 
    SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
     WHERE ima01 = g_ecb.ecb01
    SELECT eca02 INTO l_eca02 FROM eca_file
     WHERE eca01=g_ecb.ecb08
    DISPLAY l_ima02  TO FORMONLY.ima02
    DISPLAY l_ima021 TO FORMONLY.ima021
    DISPLAY l_eca02  TO FORMONLY.eca02
    CALL i110_b_fill(g_wc2)
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i110_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2       LIKE type_file.chr1000   #No.FUN-680073 VARCHAR(600)
 
    LET g_sql = "SELECT eco04,rpf02,rpf07,eco05,eco06,eco07,eco08,",
               #No.FUN-840068 --start--
                "       ecoud01,ecoud02,ecoud03,ecoud04,ecoud05,",
                "       ecoud06,ecoud07,ecoud08,ecoud09,ecoud10,",
                "       ecoud11,ecoud12,ecoud13,ecoud14,ecoud15",
               #No.FUN-840068 ---end---
                " FROM eco_file LEFT OUTER JOIN rpf_file ON eco_file.eco04=rpf_file.rpf01",
                " WHERE eco01 = '",g_ecb.ecb01,"' ",
                "   AND eco012 = '",g_ecb.ecb012,"'",   #FUN-A60021 add
                "   AND eco02 = '",g_ecb.ecb02,"' ",
                "   AND eco03 = '",g_ecb.ecb03,"' ",
                "   AND ",p_wc2 CLIPPED,
                " ORDER BY 1 "
    PREPARE i110_pb FROM g_sql
    DECLARE eco_curs CURSOR FOR i110_pb
 
    CALL g_eco.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH eco_curs INTO g_eco[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_eco.deleteElement(g_cnt)
    LET g_rec_b= g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i110_ecb01(p_cmd)  #料件編號
    DEFINE l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_imaacti LIKE ima_file.imaacti,
           p_cmd     LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
  LET g_errno = " "
  SELECT ima02,ima021,imaacti
         INTO l_ima02,l_ima021,l_imaacti FROM ima_file
         WHERE ima01 = g_ecb.ecb01
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                 LET l_ima02 = NULL  LET l_imaacti = NULL
                                 LET l_ima021=NULl
       WHEN l_imaacti='N'        LET g_errno = '9028'
    #FUN-690022------mod-------
       WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
    #FUN-690022------mod-------
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) THEN
     DISPLAY l_ima02 TO FORMONLY.ima02
     DISPLAY l_ima021 TO FORMONLY.ima021
  END IF
END FUNCTION
 
FUNCTION i110_eco04(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,          #No.FUN-680073 VARCHAR(1)
    l_rpf02         LIKE rpf_file.rpf02,
    l_rpf07         LIKE rpf_file.rpf07,
    l_rpfacti       LIKE rpf_file.rpfacti         #No.FUN-680073 VARCHAR(1)
    LET g_errno = ''
    SELECT rpf02,rpf07,rpfacti INTO l_rpf02,l_rpf07,l_rpfacti
      FROM rpf_file
     WHERE rpf01=g_eco[l_ac].eco04
 
     CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'ams-506'
                                    LET g_eco[l_ac].eco04 = NULL
          WHEN l_rpfacti='N'        LET g_errno = '9028'
                                    LET g_eco[l_ac].eco04 = NULL
          OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
 
    END CASE
    IF p_cmd='d' OR cl_null(g_errno)  THEN
       LET g_eco[l_ac].rpf02=l_rpf02
       LET g_eco[l_ac].rpf07=l_rpf07
    END IF
END FUNCTION
 
FUNCTION i110_b()
DEFINE
    l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT        #No.FUN-680073 SMALLINT SMALLINT
    l_n             LIKE type_file.num5,      #檢查重複用        #No.FUN-680073 SMALLINT
    l_lock_sw       LIKE type_file.chr1,      #單身鎖住否        #No.FUN-680073 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,      #處理狀態        #No.FUN-680073 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,      #可新增否        #No.FUN-680073 SMALLINT
    l_allow_delete  LIKE type_file.num5,      #可刪除否        #No.FUN-680073 SMALLINT
    l_ecuacti       LIKE ecu_file.ecuacti     #CHI-C90006
    
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_ecb.ecb01) THEN RETURN END IF
    #CHI-C90006---begin
    LET l_ecuacti = NULL 
    SELECT ecuacti INTO l_ecuacti
      FROM ecu_file
     WHERE ecu01  = g_ecb.ecb01
       AND ecu02  = g_ecb.ecb02
       AND ecu012 = g_ecb.ecb012
    IF l_ecuacti='N' THEN RETURN END IF  
    #CHI-C90006---end
    
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
        #No.FUN-840068 --start--
        #"SELECT eco04,'','',eco05,eco06,eco07,eco08 FROM eco_file ",
        "SELECT eco04,'','',eco05,eco06,eco07,eco08,",
        "       ecoud01,ecoud02,ecoud03,ecoud04,ecoud05,",
        "       ecoud06,ecoud07,ecoud08,ecoud09,ecoud10,",
        "       ecoud11,ecoud12,ecoud13,ecoud14,ecoud15", 
        " FROM eco_file ",
        #No.FUN-840068 ---end---
 
        "  WHERE eco01 = ? AND eco02 = ? AND eco03 = ? AND eco04 = ? AND eco012 = ? ",  #FUN-A60021 add eco012
        "FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i110_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_eco WITHOUT DEFAULTS FROM s_eco.*
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
 
            OPEN i110_cl USING g_ecb.ecb01,g_ecb.ecb02,g_ecb.ecb03,g_ecb.ecb012   #FUN-A60021 add ecb012
            IF STATUS THEN
               CALL cl_err("OPEN i110_cl:", STATUS, 1)
               CLOSE i110_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i110_cl INTO g_ecb.*               # 對DB鎖定
            IF SQLCA.sqlcode THEN
               CALL cl_err('lock ecb:',SQLCA.sqlcode,0)
               CLOSE i110_cl ROLLBACK WORK RETURN
            END IF
            IF g_rec_b >= l_ac  THEN
 
                LET p_cmd='u'
                LET g_eco_t.* = g_eco[l_ac].*  #BACKUP
 
                OPEN i110_bcl USING g_ecb01,g_ecb02,g_ecb03,g_eco_t.eco04,g_ecb012   #FUN-A60021 add g_ecb012
                IF STATUS THEN
                   CALL cl_err("OPEN i110_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i110_bcl INTO g_eco[l_ac].*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_eco_t.eco04,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   ELSE
                      CALL  i110_eco04('d')
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_eco[l_ac].* TO NULL      #900423
            LET g_eco[l_ac].eco05 = 0
            LET g_eco[l_ac].eco06 = 0
            LET g_eco[l_ac].eco07 = 0
            LET g_eco_t.* = g_eco[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD eco04
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
 
            INSERT INTO eco_file(eco01,eco02,eco03,eco04,eco05,eco06,
                               #No.FUN-840068 --start--
                                 #eco07,eco08)
                                  eco07,eco08 
                                 ,ecoud01,ecoud02,ecoud03,ecoud04,ecoud05
                                 ,ecoud06,ecoud07,ecoud08,ecoud09,ecoud10
                                 ,ecoud11,ecoud12,ecoud13,ecoud14,ecoud15,eco012)  #FUN-A60021 add eco012
                               #No.FUN-840068 ---end---
                          VALUES(g_ecb.ecb01,g_ecb.ecb02,g_ecb.ecb03,
                                 g_eco[l_ac].eco04,g_eco[l_ac].eco05,
                                 g_eco[l_ac].eco06,g_eco[l_ac].eco07,
                                #No.FUN-840068 --start--
                                 #g_eco[l_ac].eco08)
                                 g_eco[l_ac].eco08   
                                 ,g_eco[l_ac].ecoud01,g_eco[l_ac].ecoud02,g_eco[l_ac].ecoud03,g_eco[l_ac].ecoud04,g_eco[l_ac].ecoud05
                                 ,g_eco[l_ac].ecoud06,g_eco[l_ac].ecoud07,g_eco[l_ac].ecoud08,g_eco[l_ac].ecoud09,g_eco[l_ac].ecoud10
                                 ,g_eco[l_ac].ecoud11,g_eco[l_ac].ecoud12,g_eco[l_ac].ecoud13,g_eco[l_ac].ecoud14,g_eco[l_ac].ecoud15
                                 ,g_ecb.ecb012)  #FUN-A60021 
                                #No.FUN-840068 ---end---
 
            IF SQLCA.sqlcode THEN
#              CALL cl_err('ins eco:',SQLCA.sqlcode,0) #No.FUN-660091
               CALL cl_err3("ins","eco_file",g_ecb.ecb01,g_ecb.ecb02,SQLCA.sqlcode,"","ins eco:",1) #FUN-660091
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        AFTER  FIELD eco04
            IF NOT cl_null(g_eco[l_ac].eco04) THEN
               IF g_eco[l_ac].eco04 != g_eco_t.eco04 OR
                  g_eco_t.eco04 IS NULL  THEN
                  SELECT COUNT(*) INTO l_n FROM eco_file
                   WHERE eco01 = g_ecb01
                     AND eco012= g_ecb012   #FUN-A60021
                     AND eco02 = g_ecb02
                     AND eco03 = g_ecb03
                     AND eco04 = g_eco[l_ac].eco04
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_eco[l_ac].eco04 = g_eco_t.eco04
                     NEXT FIELD eco04
                  END IF
                  CALL i110_eco04('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,1)
                     NEXT FIELD eco04
                  END IF
               END IF
            END IF
 
        AFTER  FIELD eco05
            IF NOT cl_null(g_eco[l_ac].eco05) THEN
               IF g_eco[l_ac].eco05 < 0 THEN
                  LET g_eco[l_ac].eco05 = g_eco_t.eco05
                  NEXT FIELD eco05
               END IF
            END IF
 
        AFTER  FIELD eco06
            IF NOT cl_null(g_eco[l_ac].eco06) THEN
               IF g_eco[l_ac].eco06 < 0 THEN
                  LET g_eco[l_ac].eco06 = g_eco_t.eco06
                  NEXT FIELD eco06
               END IF
            END IF
 
        AFTER  FIELD eco07
            IF NOT cl_null(g_eco[l_ac].eco07) THEN
               IF g_eco[l_ac].eco07 < 0 THEN
                  LET g_eco[l_ac].eco07 = g_eco_t.eco07
                  NEXT FIELD eco07
               END IF
            END IF
 
       #No.FUN-840068 --start--
        AFTER FIELD ecoud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ecoud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ecoud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ecoud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ecoud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ecoud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ecoud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ecoud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ecoud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ecoud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ecoud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ecoud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ecoud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ecoud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ecoud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
       #No.FUN-840068 ---end---
 
        BEFORE DELETE                            #是否取消單身
            IF g_eco_t.eco04 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
 
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
 
               DELETE FROM eco_file
                WHERE eco01=g_ecb.ecb01 AND eco02=g_ecb.ecb02
                  AND eco03=g_ecb.ecb03 AND eco04=g_eco_t.eco04
                  AND eco012 = g_ecb.ecb012  #FUN-A60021
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_eco_t.eco04,SQLCA.sqlcode,0) #No.FUN-660091
                  CALL cl_err3("del","eco_file",g_ecb.ecb01,g_eco_t.eco04,SQLCA.sqlcode,"","",1) #FUN-660091
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
               LET g_eco[l_ac].* = g_eco_t.*
               CLOSE i110_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_eco[l_ac].eco04,-263,1)
               LET g_eco[l_ac].* = g_eco_t.*
            ELSE
               UPDATE eco_file SET eco04=g_eco[l_ac].eco04,
                                   eco05=g_eco[l_ac].eco05,
                                   eco06=g_eco[l_ac].eco06,
                                   eco07=g_eco[l_ac].eco07,
                                   eco08=g_eco[l_ac].eco08
                                  #FUN-840068 --start--
                                  ,ecoud01 = g_eco[l_ac].ecoud01,
                                   ecoud02 = g_eco[l_ac].ecoud02,
                                   ecoud03 = g_eco[l_ac].ecoud03,
                                   ecoud04 = g_eco[l_ac].ecoud04,
                                   ecoud05 = g_eco[l_ac].ecoud05,
                                   ecoud06 = g_eco[l_ac].ecoud06,
                                   ecoud07 = g_eco[l_ac].ecoud07,
                                   ecoud08 = g_eco[l_ac].ecoud08,
                                   ecoud09 = g_eco[l_ac].ecoud09,
                                   ecoud10 = g_eco[l_ac].ecoud10,
                                   ecoud11 = g_eco[l_ac].ecoud11,
                                   ecoud12 = g_eco[l_ac].ecoud12,
                                   ecoud13 = g_eco[l_ac].ecoud13,
                                   ecoud14 = g_eco[l_ac].ecoud14,
                                   ecoud15 = g_eco[l_ac].ecoud15
                                  #FUN-840068 --end-- 
 
                WHERE eco01 = g_ecb01
                  AND eco012= g_ecb012   #FUN-A60021
                  AND eco02 = g_ecb02
                  AND eco03 = g_ecb03
                  AND eco04 = g_eco_t.eco04
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_eco_t.eco04,SQLCA.sqlcode,0) #No.FUN-660091
                   CALL cl_err3("upd","eco_file",g_ecb01,g_eco_t.eco04,SQLCA.sqlcode,"","",1) #FUN-660091
                   LET g_eco[l_ac].* = g_eco_t.*
                   ROLLBACK WORK
               ELSE
                   MESSAGE 'UPDATE O.K'
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
                  LET g_eco[l_ac].* = g_eco_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_eco.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i110_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i110_bcl
            COMMIT WORK
 
        ON ACTION controlp                        #
           CASE WHEN INFIELD(eco04)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_rpf"
                LET g_qryparam.default1 = g_eco[l_ac].eco04
                CALL cl_create_qry() RETURNING g_eco[l_ac].eco04
#                CALL FGL_DIALOG_SETBUFFER( g_eco[l_ac].eco04 )
                 DISPLAY BY NAME g_eco[l_ac].eco04     #No.MOD-490371
                NEXT FIELD eco04
           END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(eco04) AND l_ac > 1 THEN
              LET g_eco[l_ac].* = g_eco[l_ac-1].*
              NEXT FIELD eco04
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
 
    CLOSE i110_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i110_r()
    DEFINE l_chr   LIKE type_file.chr1,         #No.FUN-680073 VARCHAR(1)
           l_cnt   LIKE type_file.num5          #No.FUN-680073 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_ecb.ecb01) AND cl_null(g_ecb.ecb02) AND g_ecb.ecb012 IS NULL THEN  #FUN-A60021 add ecb012
       CALL cl_err('',-400,0) RETURN
    END IF
 
    BEGIN WORK
 
    OPEN i110_cl USING g_ecb.ecb01,g_ecb.ecb02,g_ecb.ecb03,g_ecb.ecb012   #FUN-A60021 add ecb012
    IF STATUS THEN
       CALL cl_err("OPEN i110_cl:", STATUS, 1)
       CLOSE i110_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i110_cl INTO g_ecb.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err('lock ecb:',SQLCA.sqlcode,0)
       CLOSE i110_cl ROLLBACK WORK RETURN
    END IF
    CALL i110_show()
#   IF cl_delh(15,21) THEN     #No.TQC-6C0178
    SELECT ze03 INTO g_msg FROM ze_file WHERE ze01 = 'lib-354' AND ze02 = g_lang     #No.TQC-6C0178
    IF cl_prompt(15,21,g_msg) THEN     #No.TQC-6C0178
        DELETE FROM eco_file
         WHERE eco01=g_ecb.ecb01 AND eco02=g_ecb.ecb02 AND eco03=g_ecb.ecb03
           AND eco012 = g_ecb.ecb012   #FUN-A60021
        IF STATUS THEN
#          CALL cl_err('del_eco:',STATUS,0) #No.FUN-660091
           CALL cl_err3("del","eco_file",g_ecb.ecb01,g_ecb.ecb02,STATUS,"","del eco:",1) #FUN-660091
           CLOSE i110_cl
           ROLLBACK WORK
        ELSE
#          CLEAR FORM     #No.TQC-6C0178
           CALL g_eco.clear()
#No.TQC-6C0178 --begin
#          OPEN i110_count
#          FETCH i110_count INTO g_row_count
#          DISPLAY g_row_count TO FORMONLY.cnt
#          OPEN i110_cs
#          IF g_curs_index = g_row_count + 1 THEN
#             LET g_jump = g_row_count
#             CALL i110_fetch('L')
#          ELSE
#             LET g_jump = g_curs_index
#             LET mi_no_ask = TRUE
#             CALL i110_fetch('/')
#          END IF
#No.TQC-6C0178 --end
           CLOSE i110_cl
           COMMIT WORK
        END IF
    END IF
END FUNCTION
