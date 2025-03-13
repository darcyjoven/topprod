# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: axct460.4gl
# Descriptions...: 工單製程下階在製成本維護作業
# Date & Author..: 96/01/31 By Roger
# Modify ........: 01/11/16 BY DS/P
# Modify.........: No.A088 03/08/22 By Wiky 程式中沒有menu2
# Modify.........: No.FUN-4C0005 04/12/03 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.MOD-530850 05/03/31 By Will 增加料件的開窗
# Modify.........: No.FUN-550025 05/05/16 By vivien 單據編號格式放大
# Modify.........: No.FUN-550025 05/05/16 By vivien 單據編號格式放大
# Modify.........: No.FUN-560253 05/06/29 By Melody shell錯誤更正
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-670016 06/07/13 By Sarah 從axct410串過來時,資料沒有帶出來
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0019 06/10/27 By jamie 1.FUNCTION _fetch() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0146 06/10/27 By bnlent l_time轉g_time
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0101 08/01/11 By Zhangyajun 成本改善增加cxh06(成本計算類別),cxh07(類別編號)和各種制費
# Modify.........: No.FUN-910073 09/02/02 By jan 成本計算類別為"1or2"時,類別編號應noentry且自動給' '
# Modify.........: No.FUN-980009 09/08/18 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-970227 09/08/03 By destiny 新增時如果年月為空會卡在工單編號上
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 專案加上'結案'的判斷
# Modify.........: No.TQC-970003 09/07/01 By jan 批次成本修改
# Modify.........: No.FUN-A20044 10/03/20 By jiachenchao 刪除字段ima26* 
# Modify.........: No.FUN-A50075 10/05/24 By lutingting GP5.2 AXC模組TABLE重新分類,相關INSERT語法修改
# Modify.........: No.FUN-A60092 10/07/12 By lilingyu 平行工藝
# Modify.........: No.FUN-AA0059 10/10/27 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-B10056 11/02/15 By vealxu 修改制程段號的管控
# Modify.........: No.TQC-B90089 11/09/13 By yinhy 查詢時，會出現 open t460_cs，字元轉換至數值失敗的錯誤訊息
# Modify.........: No:FUN-BC0062 12/02/20 By lilingyu 成本計算類型(axcs010)不可選擇【6.移動加權平均成本】

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_argv1 LIKE type_file.chr20,        #No.FUN-680122 VARCHAR(16)  #FUN-670016 VARCHAR(10)->CHAR(16)
    g_argv2 LIKE type_file.num5,         #No.FUN-680122SMALLINT
    g_argv3 LIKE type_file.num5,         #No.FUN-680122SMALLINT
    g_argv4 LIKE cxh_file.cxh06,         #No.FUN-7C0101
   #g_argv5 LIKE cxh_file.cxh07,         #No.FUN-7C0101 #TQC-970003
    g_argv6 LIKE cxh_file.cxh013,        #FUN-A60092
    g_argv7 LIKE cxh_file.cxh014,        #FUN-A60092 
    g_sfb38 LIKE sfb_file.sfb38,
    g_cxh   RECORD LIKE cxh_file.*,
    g_cxh_t RECORD LIKE cxh_file.*,
    g_cxh01_t LIKE cxh_file.cxh01,   #工單
    g_cxh011_t LIKE cxh_file.cxh011, #成本中心
    g_cxh012_t LIKE cxh_file.cxh012, #作業編號
    g_cxh02_t LIKE cxh_file.cxh02,   #年度
    g_cxh03_t LIKE cxh_file.cxh03,   #月份
    g_cxh04_t LIKE cxh_file.cxh04,   #元件料號
    g_cxh06_t LIKE cxh_file.cxh06,   #No.FUN-7C0101 
    g_cxh07_t LIKE cxh_file.cxh07,   #No.FUN-7C0101
    g_cxh013_t LIKE cxh_file.cxh013,  #FUN-A60092 
    g_cxh014_t LIKE cxh_file.cxh014,  #FUN-A60092     
     g_wc,g_sql          string,  #No.FUN-580092 HCN
    g_ima   RECORD LIKE ima_file.*,
    g_ccg   RECORD LIKE ccg_file.*
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_msg           LIKE ze_file.ze03            #No.FUN-680122CHAR(72)
DEFINE   g_before_input_done LIKE type_file.num5          #No.FUN-680122 SMALLINT 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680122 SMALLINT
MAIN
#     DEFINE    l_time LIKE type_file.chr8           #No.FUN-6A0146
DEFINE p_row,p_col      LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
 
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)
    LET g_argv3 = ARG_VAL(3)
    LET g_argv4 = ARG_VAL(4)    #NO.FUN-7C0101
#   LET g_argv5 = ARG_VAL(5)    #No.FUN-7C0101   #TQC-970003
    LET g_argv6 = ARG_VAL(6)    #FUN-A60092
    LET g_argv7 = ARG_VAL(7)    #FUN-A60092 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
    INITIALIZE g_cxh.* TO NULL
    INITIALIZE g_cxh_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM cxh_file WHERE cxh01 = ? AND cxh011 = ? AND cxh012 = ? AND cxh02 = ?" ,
                       "   AND cxh03 = ? AND cxh04 = ? AND cxh06 = ?",
                       "   AND cxh07 = ? AND cxh013= ? AND cxh014= ? FOR UPDATE "  
                       #FUN-A60092 add cxh013,cxh014
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t460_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
    LET p_row = 2 LET p_col = 2
 
    OPEN WINDOW t460_w AT p_row,p_col
        WITH FORM "axc/42f/axct460"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
#FUN-A60092 --begin--
    IF g_sma.sma541 = 'Y' THEN 
       CALL cl_set_comp_visible("cxh013,cxh014",TRUE)
    ELSE
       CALL cl_set_comp_visible("cxh013,cxh014",FALSE)    
    END IF 	
#FUN-A60092 --end-- 
 
    IF NOT cl_null(g_argv1) THEN CALL t460_q() END IF
    #No:A088
 
    #WHILE TRUE      ####040512
    LET g_action_choice=""
    CALL t460_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    ##
    CLOSE WINDOW t460_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
FUNCTION t460_cs()
DEFINE l_cxh06 LIKE cxh_file.cxh06   #No.FUN-7C0101
    CLEAR FORM
    IF NOT cl_null(g_argv1) THEN
       #No.TQC-B90089  --Begin
       IF cl_null(g_argv7) THEN
          LET g_argv7 = '0' 
       END IF
       #No.TQC-B90089  --End
       LET g_wc = " cxh01='", g_argv1, "' AND ",
                  " cxh02=", g_argv2, " AND cxh03=", g_argv3
                  ," AND cxh06 = '",g_argv4,"' "   #TQC-970003
#                 ," AND cxh06 = '",g_argv4,"' AND cxh07 = '",g_argv5,"'"     #No.FUN-7C0101 add #TQC-970003
                  ," AND cxh013='",g_argv6,"' AND cxh014='",g_argv7,"'"  #FUN-A60092
    ELSE
   INITIALIZE g_cxh.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
          ccg04, cxh01,cxh013,cxh014,cxh011,cxh012,cxh02,cxh03,cxh06,cxh07,  #No.FUN-7C0101
                       #FUN-A60092 add cxh013,cxh014
          ccg12, ccg22, ccg32, ccg42, ccg92,
          cxh04, cxh05,
          cxh11, cxh12a, cxh12b, cxh12c, cxh12d, cxh12e, cxh12f,cxh12g,cxh12h,cxh12,  #No.FUN-7C0101 add
          cxh21, cxh22a, cxh22b, cxh22c, cxh22d, cxh22e, cxh22f,cxh22g,cxh22h,cxh22,  #
          cxh24, cxh25a, cxh25b, cxh25c, cxh25d, cxh25e, cxh25f,cxh25g,cxh25h,cxh25,  #
          cxh31, cxh32a, cxh32b, cxh32c, cxh32d, cxh32e, cxh32f,cxh32g,cxh32h,cxh32,  #
          cxh41, cxh42a, cxh42b, cxh42c, cxh42d, cxh42e, cxh42f,cxh42g,cxh42h,cxh42,  #
          cxh91, cxh92a, cxh92b, cxh92c, cxh92d, cxh92e, cxh92f,cxh92g,cxh92h,cxh92   #
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
     AFTER FIELD cxh06                      #No.FUN-7C0101
           LET l_cxh06 = get_fldbuf(cxh06)  #No.FUN-7C0101
      #MOD-530850
     ON ACTION CONTROLP
        CASE
          WHEN INFIELD(ccg04)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_bma2"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_ccg.ccg04
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ccg04
            NEXT FIELD ccg04

#FUN-A60092 --begin--
          WHEN INFIELD(cxh013)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_cxh013"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_cxh.cxh013
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO cxh013
            NEXT FIELD cxh013
#FUN-A60092 --end--
            
          WHEN INFIELD(cxh04)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_bmb203"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_cxh.cxh04
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO cxh04
            NEXT FIELD cxh04
         #No.FUN-7C0101--start--                                           
              WHEN INFIELD(cxh07)                                               
                 IF l_cxh06 MATCHES '[45]' THEN                                 
                    CALL cl_init_qry_var()                                      
                    LET g_qryparam.state= "c"                                   
                 CASE l_cxh06                                                   
                    WHEN '4'                                                    
                      LET g_qryparam.form = "q_pja"                             
                    WHEN '5'                                                    
                      LET g_qryparam.form = "q_gem4"                            
                    OTHERWISE EXIT CASE                                         
                 END CASE                                                       
                 CALL cl_create_qry() RETURNING g_qryparam.multiret                         
                 DISPLAY g_qryparam.multiret TO cxh07                                       
                 NEXT FIELD cxh07                                               
                 END IF                                                         
               #No.FUN-7C0101---end---    
         OTHERWISE
            EXIT CASE
       END CASE
     #--
 
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
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ccguser', 'ccggrup') #FUN-980030
 
       IF INT_FLAG THEN
          RETURN
       END IF
    END IF
    LET g_sql="SELECT cxh01,cxh011,cxh012,cxh02,cxh03,",
              "  cxh04,cxh06,cxh07",     #No.FUN-7C0101 add cxh06,cxh07
              " ,cxh013,cxh014 ",        #FUN-A60092 add
              "  FROM cxh_file,ccg_file ",
              " WHERE ",g_wc CLIPPED,
              "   AND cxh01=ccg01 AND cxh02=ccg02 AND cxh03=ccg03",
              " AND cxh06=ccg06 AND cxh07=ccg07",    #No.FUN-7C0101
#              " AND cxh013 = ccg012 AND cxh014= ccg013",  #FUN-A60092 add
              " ORDER BY ccg04,cxh01,cxh011,cxh012,cxh02,cxh03,cxh04,cxh06,cxh07"  #No.FUN-7C0101
#             ,",cxh013,cxh014"    #FUN-A60092 add
    PREPARE t460_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t460_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t460_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM cxh_file,ccg_file WHERE ",g_wc CLIPPED,
        "   AND cxh01=ccg01 AND cxh02=ccg02 AND cxh03=ccg03",
#       "   AND cxh06=ccg06 AND cxh07=cxh07"   #No.FUN-7C0101 #TQC-970003
        "   AND cxh06=ccg06 "                  #No.TQC-970003 
#       ,"   AND cxh013 = ccg012 AND cxh014 = ccg013"   #FUN-A60092 add
    PREPARE t460_precount FROM g_sql
    DECLARE t460_count CURSOR FOR t460_precount
END FUNCTION
 
FUNCTION t460_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )

        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL t460_a()
            END IF

        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL t460_q()
            END IF

        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
               CALL t460_u()
            END IF
                        
#       ON ACTION 累計查詢
        ON ACTION query_accumulated
        #   LET g_msg="axcq430 ",g_cxh.cxh01," ",g_cxh.cxh02," ",g_cxh.cxh03                                  #No.FUN-7C0101 mark
        #   LET g_msg="axcq430 ",g_cxh.cxh01," ",g_cxh.cxh02," ",g_cxh.cxh03," ",g_cxh.cxh06," ",g_cxh.cxh07  #No.FUN-7C0101 #TQC-970003
            LET g_msg="axcq430 ",g_cxh.cxh01," ",g_cxh.cxh02," ",g_cxh.cxh03," ",g_cxh.cxh06  #TQC-970003
            CALL cl_cmdrun(g_msg)
 
        ON ACTION next
            CALL t460_fetch('N')
        ON ACTION previous
            CALL t460_fetch('P')
        ON ACTION jump
            CALL t460_fetch('/')
        ON ACTION first
            CALL t460_fetch('F')
        ON ACTION last
            CALL t460_fetch('L')
            
        ON ACTION HELP
           CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            #EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
       
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121  

        #No.FUN-6A0019-------add--------str----
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_cxh.cxh01 IS NOT NULL THEN
                  LET g_doc.column1 = "cxh01"
                  LET g_doc.value1 = g_cxh.cxh01
                  CALL cl_doc()
               END IF
           END IF
        #No.FUN-6A0019-------add--------end----
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU                     
    END MENU
    CLOSE t460_cs
END FUNCTION
 
#No:A088
##
FUNCTION g_cxh_zero()
	LET g_cxh.cxh11=0
	LET g_cxh.cxh12=0
	LET g_cxh.cxh12a=0
	LET g_cxh.cxh12b=0
	LET g_cxh.cxh12c=0
	LET g_cxh.cxh12d=0
	LET g_cxh.cxh12e=0
        LET g_cxh.cxh12f=0    #No.FUN-7C0101
        LET g_cxh.cxh12g=0    #No.FUN-7C0101
        LET g_cxh.cxh12h=0    #No.FUN-7C0101
	LET g_cxh.cxh21=0
	LET g_cxh.cxh22=0
	LET g_cxh.cxh22a=0
	LET g_cxh.cxh22b=0
	LET g_cxh.cxh22c=0
	LET g_cxh.cxh22d=0
	LET g_cxh.cxh22e=0
        LET g_cxh.cxh22f=0    #No.FUN-7C0101
        LET g_cxh.cxh22g=0    #No.FUN-7C0101
        LET g_cxh.cxh22h=0    #No.FUN-7C0101
	LET g_cxh.cxh24=0
	LET g_cxh.cxh25=0
	LET g_cxh.cxh25a=0
	LET g_cxh.cxh25b=0
	LET g_cxh.cxh25c=0
	LET g_cxh.cxh25d=0
	LET g_cxh.cxh25e=0
        LET g_cxh.cxh25f=0    #No.FUN-7C0101
        LET g_cxh.cxh25g=0    #No.FUN-7C0101
        LET g_cxh.cxh25h=0    #No.FUN-7C0101
	LET g_cxh.cxh31=0
	LET g_cxh.cxh32=0
	LET g_cxh.cxh32a=0
	LET g_cxh.cxh32b=0
	LET g_cxh.cxh32c=0
	LET g_cxh.cxh32d=0
	LET g_cxh.cxh32e=0
        LET g_cxh.cxh32f=0    #No.FUN-7C0101
        LET g_cxh.cxh32g=0    #No.FUN-7C0101
        LET g_cxh.cxh32h=0    #No.FUN-7C0101
	LET g_cxh.cxh41=0
	LET g_cxh.cxh42=0
	LET g_cxh.cxh42a=0
	LET g_cxh.cxh42b=0
	LET g_cxh.cxh42c=0
	LET g_cxh.cxh42d=0
	LET g_cxh.cxh42e=0
        LET g_cxh.cxh42f=0    #No.FUN-7C0101
        LET g_cxh.cxh42g=0    #No.FUN-7C0101
        LET g_cxh.cxh42h=0    #No.FUN-7C0101
	LET g_cxh.cxh91=0
	LET g_cxh.cxh92=0
	LET g_cxh.cxh92a=0
	LET g_cxh.cxh92b=0
	LET g_cxh.cxh92c=0
	LET g_cxh.cxh92d=0
	LET g_cxh.cxh92e=0
        LET g_cxh.cxh92f=0    #No.FUN-7C0101
        LET g_cxh.cxh92g=0    #No.FUN-7C0101
        LET g_cxh.cxh92h=0    #No.FUN-7C0101
END FUNCTION
 
FUNCTION t460_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_cxh.* LIKE cxh_file.*
    CALL g_cxh_zero()
    LET g_cxh.cxh011=g_cxh_t.cxh011
    LET g_cxh.cxh012=g_cxh_t.cxh012
    LET g_cxh.cxh02=g_cxh_t.cxh02
    LET g_cxh.cxh03=g_cxh_t.cxh03
    LET g_cxh01_t = NULL
    LET g_cxh011_t= NULL
    LET g_cxh012_t= NULL
    LET g_cxh02_t = NULL
    LET g_cxh03_t = NULL
    LET g_cxh04_t = NULL
    LET g_cxh06_t = NULL     #No.FUN-7C0101
    LET g_cxh07_t = NULL     #No.FUN-7C0101
    LET g_cxh013_t= NULL     #FUN-A60092 
    LET g_cxh014_t= NULL     #FUN-A60092 add
    
   #LET g_cxh.cxhplant = g_plant #FUN-980009 add    #FUN-A50075
    LET g_cxh.cxhlegal = g_legal #FUN-980009 add
    LET g_cxh_t.*=g_cxh.*
    CALL cl_opmsg('a')
    WHILE TRUE

#FUN-BC0062 --begin--
       IF g_ccz.ccz28 = '6' THEN
          CALL cl_err('','axc-026',1)
          EXIT WHILE
       END IF
#FUN-BC0062 --end--

        LET g_cxh.cxh06 = g_ccz.ccz28         #No.FUN-7C0101
        LET g_cxh.cxh07 = ' '                 #No.FUN-7C0101
        CALL t460_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_cxh.cxh01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        LET g_cxh.cxhoriu = g_user      #No.FUN-980030 10/01/04
        LET g_cxh.cxhorig = g_grup      #No.FUN-980030 10/01/04

#FUN-A60092 --begin--        
       IF cl_null(g_cxh.cxh013) THEN 
          LET g_cxh.cxh013 = ' '
       END IF 
       IF cl_null(g_cxh.cxh014) THEN 
          LET g_cxh.cxh014 = 0 
       END IF 
       CALL t460_init()
#FUN-A60092 --end--
        INSERT INTO cxh_file VALUES(g_cxh.*)
        IF SQLCA.sqlcode THEN
#           CALL cl_err('ins cxh:',SQLCA.sqlcode,0)   #No.FUN-660127
            CALL cl_err3("ins","cxh_file",g_cxh.cxh01,g_cxh.cxh02,SQLCA.sqlcode,"","ins cxh:",1)  #No.FUN-660127
            CONTINUE WHILE
        ELSE
            LET g_cxh_t.* = g_cxh.*                # 保存上筆資料
            SELECT cxh01,cxh011,cxh012,cxh02,cxh03,cxh04,cxh06,cxh07 INTO g_cxh.cxh01,g_cxh.cxh011,g_cxh.cxh012,g_cxh.cxh02,g_cxh.cxh03,g_cxh.cxh04,g_cxh.cxh06,g_cxh.cxh07 FROM cxh_file
             WHERE cxh01 = g_cxh.cxh01 AND cxh02 = g_cxh.cxh02
               AND cxh03 = g_cxh.cxh03 AND cxh04 = g_cxh.cxh04
               AND cxh06 = g_cxh.cxh06     #No.FUN-7C0101
               AND cxh07 = g_cxh.cxh07     #No.FUN-7C0101
               AND cxh013= g_cxh.cxh013    #FUN-A60092 add 
               AND cxh014= g_cxh.cxh014    #FUN-A60092 add
        END IF
        CALL t460_b_tot('u')
        EXIT WHILE
    END WHILE
END FUNCTION

#FUN-A60092 --begin--        
FUNCTION t460_init()
 IF cl_null(g_cxh.cxh26) THEN LET g_cxh.cxh26 = 0 END IF 
 IF cl_null(g_cxh.cxh27) THEN LET g_cxh.cxh27 = 0 END IF 
 IF cl_null(g_cxh.cxh27a) THEN LET g_cxh.cxh27a = 0 END IF 
 IF cl_null(g_cxh.cxh27b) THEN LET g_cxh.cxh27b = 0 END IF 
 IF cl_null(g_cxh.cxh27c) THEN LET g_cxh.cxh27c = 0 END IF 
 IF cl_null(g_cxh.cxh27d) THEN LET g_cxh.cxh27d = 0 END IF 
 IF cl_null(g_cxh.cxh27e) THEN LET g_cxh.cxh27e = 0 END IF     
 IF cl_null(g_cxh.cxh28) THEN LET g_cxh.cxh28 = 0 END IF 
 IF cl_null(g_cxh.cxh29) THEN LET g_cxh.cxh29 = 0 END IF 
 IF cl_null(g_cxh.cxh29a) THEN LET g_cxh.cxh29a = 0 END IF 
 IF cl_null(g_cxh.cxh29b) THEN LET g_cxh.cxh29b = 0 END IF 
 IF cl_null(g_cxh.cxh29c) THEN LET g_cxh.cxh29c = 0 END IF 
 IF cl_null(g_cxh.cxh29d) THEN LET g_cxh.cxh29d = 0 END IF 
 IF cl_null(g_cxh.cxh29e) THEN LET g_cxh.cxh29e = 0 END IF     
 IF cl_null(g_cxh.cxh31) THEN LET g_cxh.cxh31 = 0 END IF 
 IF cl_null(g_cxh.cxh32) THEN LET g_cxh.cxh32 = 0 END IF 
 IF cl_null(g_cxh.cxh32a) THEN LET g_cxh.cxh32a = 0 END IF 
 IF cl_null(g_cxh.cxh32b) THEN LET g_cxh.cxh32b = 0 END IF 
 IF cl_null(g_cxh.cxh32c) THEN LET g_cxh.cxh32c = 0 END IF 
 IF cl_null(g_cxh.cxh32d) THEN LET g_cxh.cxh32d = 0 END IF 
 IF cl_null(g_cxh.cxh32e) THEN LET g_cxh.cxh32e = 0 END IF     
 IF cl_null(g_cxh.cxh33) THEN LET g_cxh.cxh33 = 0 END IF 
 IF cl_null(g_cxh.cxh34) THEN LET g_cxh.cxh34 = 0 END IF 
 IF cl_null(g_cxh.cxh34a) THEN LET g_cxh.cxh34a = 0 END IF 
 IF cl_null(g_cxh.cxh34b) THEN LET g_cxh.cxh34b = 0 END IF 
 IF cl_null(g_cxh.cxh34c) THEN LET g_cxh.cxh34c = 0 END IF 
 IF cl_null(g_cxh.cxh34d) THEN LET g_cxh.cxh34d = 0 END IF 
 IF cl_null(g_cxh.cxh34e) THEN LET g_cxh.cxh34e = 0 END IF  
 IF cl_null(g_cxh.cxh35) THEN LET g_cxh.cxh35 = 0 END IF 
 IF cl_null(g_cxh.cxh36) THEN LET g_cxh.cxh36 = 0 END IF 
 IF cl_null(g_cxh.cxh36a) THEN LET g_cxh.cxh36a = 0 END IF 
 IF cl_null(g_cxh.cxh36b) THEN LET g_cxh.cxh36b = 0 END IF 
 IF cl_null(g_cxh.cxh36c) THEN LET g_cxh.cxh36c = 0 END IF 
 IF cl_null(g_cxh.cxh36d) THEN LET g_cxh.cxh36d = 0 END IF 
 IF cl_null(g_cxh.cxh36e) THEN LET g_cxh.cxh36e = 0 END IF 
 IF cl_null(g_cxh.cxh37) THEN LET g_cxh.cxh37 = 0 END IF 
 IF cl_null(g_cxh.cxh38) THEN LET g_cxh.cxh38 = 0 END IF 
 IF cl_null(g_cxh.cxh38a) THEN LET g_cxh.cxh38a = 0 END IF 
 IF cl_null(g_cxh.cxh38b) THEN LET g_cxh.cxh38b = 0 END IF 
 IF cl_null(g_cxh.cxh38c) THEN LET g_cxh.cxh38c = 0 END IF 
 IF cl_null(g_cxh.cxh38d) THEN LET g_cxh.cxh38d = 0 END IF 
 IF cl_null(g_cxh.cxh38e) THEN LET g_cxh.cxh38e = 0 END IF       
 IF cl_null(g_cxh.cxh39) THEN LET g_cxh.cxh39 = 0 END IF 
 IF cl_null(g_cxh.cxh40) THEN LET g_cxh.cxh40 = 0 END IF 
 IF cl_null(g_cxh.cxh40a) THEN LET g_cxh.cxh40a = 0 END IF 
 IF cl_null(g_cxh.cxh40b) THEN LET g_cxh.cxh40b = 0 END IF 
 IF cl_null(g_cxh.cxh40c) THEN LET g_cxh.cxh40c = 0 END IF 
 IF cl_null(g_cxh.cxh40d) THEN LET g_cxh.cxh40d = 0 END IF     
 IF cl_null(g_cxh.cxh40e) THEN LET g_cxh.cxh40e = 0 END IF  
 IF cl_null(g_cxh.cxh41) THEN LET g_cxh.cxh41 = 0 END IF 
 IF cl_null(g_cxh.cxh42) THEN LET g_cxh.cxh42 = 0 END IF 
 IF cl_null(g_cxh.cxh42a) THEN LET g_cxh.cxh42a = 0 END IF 
 IF cl_null(g_cxh.cxh42b) THEN LET g_cxh.cxh42b = 0 END IF 
 IF cl_null(g_cxh.cxh42c) THEN LET g_cxh.cxh42c = 0 END IF 
 IF cl_null(g_cxh.cxh42d) THEN LET g_cxh.cxh42d = 0 END IF 
 IF cl_null(g_cxh.cxh42e) THEN LET g_cxh.cxh42e = 0 END IF      
 IF cl_null(g_cxh.cxh51) THEN LET g_cxh.cxh51 = 0 END IF 
 IF cl_null(g_cxh.cxh52) THEN LET g_cxh.cxh52 = 0 END IF 
 IF cl_null(g_cxh.cxh52a) THEN LET g_cxh.cxh52a = 0 END IF 
 IF cl_null(g_cxh.cxh52b) THEN LET g_cxh.cxh52b = 0 END IF 
 IF cl_null(g_cxh.cxh52c) THEN LET g_cxh.cxh52c = 0 END IF 
 IF cl_null(g_cxh.cxh52d) THEN LET g_cxh.cxh52d = 0 END IF 
 IF cl_null(g_cxh.cxh52e) THEN LET g_cxh.cxh52e = 0 END IF      
 IF cl_null(g_cxh.cxh53) THEN LET g_cxh.cxh53 = 0 END IF 
 IF cl_null(g_cxh.cxh54) THEN LET g_cxh.cxh54 = 0 END IF                    
 IF cl_null(g_cxh.cxh54a) THEN LET g_cxh.cxh54a = 0 END IF 
 IF cl_null(g_cxh.cxh54b) THEN LET g_cxh.cxh54b = 0 END IF 
 IF cl_null(g_cxh.cxh54c) THEN LET g_cxh.cxh54c = 0 END IF 
 IF cl_null(g_cxh.cxh54d) THEN LET g_cxh.cxh54d = 0 END IF 
 IF cl_null(g_cxh.cxh54e) THEN LET g_cxh.cxh54e = 0 END IF  
 IF cl_null(g_cxh.cxh55) THEN LET g_cxh.cxh55 = 0 END IF 
 IF cl_null(g_cxh.cxh56) THEN LET g_cxh.cxh56 = 0 END IF 
 IF cl_null(g_cxh.cxh56a) THEN LET g_cxh.cxh56a = 0 END IF 
 IF cl_null(g_cxh.cxh56b) THEN LET g_cxh.cxh56b = 0 END IF 
 IF cl_null(g_cxh.cxh56c) THEN LET g_cxh.cxh56c = 0 END IF 
 IF cl_null(g_cxh.cxh56d) THEN LET g_cxh.cxh56d = 0 END IF 
 IF cl_null(g_cxh.cxh56e) THEN LET g_cxh.cxh56e = 0 END IF  
 IF cl_null(g_cxh.cxh57) THEN LET g_cxh.cxh57 = 0 END IF 
 IF cl_null(g_cxh.cxh58) THEN LET g_cxh.cxh58 = 0 END IF     
 IF cl_null(g_cxh.cxh58a) THEN LET g_cxh.cxh58a = 0 END IF 
 IF cl_null(g_cxh.cxh58b) THEN LET g_cxh.cxh58b = 0 END IF 
 IF cl_null(g_cxh.cxh58c) THEN LET g_cxh.cxh58c = 0 END IF 
 IF cl_null(g_cxh.cxh58d) THEN LET g_cxh.cxh58d = 0 END IF 
 IF cl_null(g_cxh.cxh58e) THEN LET g_cxh.cxh58e = 0 END IF  
 IF cl_null(g_cxh.cxh59) THEN LET g_cxh.cxh59 = 0 END IF  
 IF cl_null(g_cxh.cxh60) THEN LET g_cxh.cxh60 = 0 END IF  
 IF cl_null(g_cxh.cxh60a) THEN LET g_cxh.cxh60a = 0 END IF 
 IF cl_null(g_cxh.cxh60b) THEN LET g_cxh.cxh60b = 0 END IF 
 IF cl_null(g_cxh.cxh60c) THEN LET g_cxh.cxh60c = 0 END IF 
 IF cl_null(g_cxh.cxh60d) THEN LET g_cxh.cxh60d = 0 END IF 
 IF cl_null(g_cxh.cxh60e) THEN LET g_cxh.cxh60e = 0 END IF  
 IF cl_null(g_cxh.cxh91) THEN LET g_cxh.cxh91 = 0 END IF 
 IF cl_null(g_cxh.cxh92) THEN LET g_cxh.cxh92 = 0 END IF 
 IF cl_null(g_cxh.cxh92a) THEN LET g_cxh.cxh92a = 0 END IF 
 IF cl_null(g_cxh.cxh92b) THEN LET g_cxh.cxh92b = 0 END IF 
 IF cl_null(g_cxh.cxh92c) THEN LET g_cxh.cxh92c = 0 END IF 
 IF cl_null(g_cxh.cxh92d) THEN LET g_cxh.cxh92d = 0 END IF 
 IF cl_null(g_cxh.cxh92e) THEN LET g_cxh.cxh92e = 0 END IF  
 IF cl_null(g_cxh.cxh014) THEN LET g_cxh.cxh014 = 0 END IF 
 IF cl_null(g_cxh.cxhlegal) THEN LET g_cxh.cxhlegal = g_legal END IF 
END FUNCTION 
#FUN-A60092 --end--
 
FUNCTION t460_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
        l_flag          LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
        l_n             LIKE type_file.num5          #No.FUN-680122 SMALLINT
DEFINE  l_sfb05         LIKE sfb_file.sfb05         #FUN-A60092 
DEFINE  l_sfb06         LIKE sfb_file.sfb06         #FUN-A60092 
DEFINE  l_cnt           LIKE type_file.num5         #FUN-A60092 
DEFINE  l_ecd02         LIKE ecd_file.ecd02         #FUN-A60092 

    INPUT BY NAME
        g_cxh.cxh01, g_cxh.cxh013,g_cxh.cxh014,g_cxh.cxh011,g_cxh.cxh012,g_cxh.cxh02,g_cxh.cxh03,   #No.FUN-7C0101 mod
                       #FUN-A60092 add cxh013,cxh014
        g_cxh.cxh06,g_cxh.cxh07,                                          #No.FUN-7C0101 add 
        g_cxh.cxh04, g_cxh.cxh05,
        g_cxh.cxh11, g_cxh.cxh12a, g_cxh.cxh12b, g_cxh.cxh12c,
        g_cxh.cxh12d, g_cxh.cxh12e, g_cxh.cxh12f, g_cxh.cxh12g, g_cxh.cxh12h, g_cxh.cxh12,
        g_cxh.cxh21, g_cxh.cxh22a, g_cxh.cxh22b, g_cxh.cxh22c,
        g_cxh.cxh22d, g_cxh.cxh22e, g_cxh.cxh22f, g_cxh.cxh22g, g_cxh.cxh22h, g_cxh.cxh22,
        g_cxh.cxh24, g_cxh.cxh25a, g_cxh.cxh25b, g_cxh.cxh25c,
        g_cxh.cxh25d, g_cxh.cxh25e, g_cxh.cxh25f, g_cxh.cxh25g, g_cxh.cxh25h, g_cxh.cxh25,
        g_cxh.cxh31, g_cxh.cxh32a, g_cxh.cxh32b, g_cxh.cxh32c,
        g_cxh.cxh32d, g_cxh.cxh32e, g_cxh.cxh32f, g_cxh.cxh32g, g_cxh.cxh32h, g_cxh.cxh32,
        g_cxh.cxh41, g_cxh.cxh42a, g_cxh.cxh42b, g_cxh.cxh42c,
        g_cxh.cxh42d, g_cxh.cxh42e, g_cxh.cxh42f, g_cxh.cxh42g, g_cxh.cxh42h, g_cxh.cxh42,
        g_cxh.cxh91, g_cxh.cxh92a, g_cxh.cxh92b, g_cxh.cxh92c,
        g_cxh.cxh92d, g_cxh.cxh92e, g_cxh.cxh92f, g_cxh.cxh92g, g_cxh.cxh92h, g_cxh.cxh92
        WITHOUT DEFAULTS
 
        BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL t460_set_entry(p_cmd)
          CALL t460_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
            #No.FUN-550025 --start--
          CALL cl_set_docno_format("cxh01")
            #No.FUN-550025 ---end---
#FUN-A60092 --begin--
          IF g_sma.sma541 = 'Y' THEN 
             CALL cl_set_comp_entry("cxh012",FALSE)
          ELSE
             CALL cl_set_comp_entry("cxh012",TRUE)
          END IF 	
#FUN-A60092 --end--            
 
        AFTER FIELD cxh01
#         IF g_cxh.cxh01 IS NOT NULL THEN                                                               #No.TQC-970227              
          IF NOT cl_null(g_cxh.cxh01) AND g_cxh.cxh02 IS NOT NULL AND  g_cxh.cxh03 IS NOT NULL THEN      #No.TQC-970227             
            SELECT * INTO g_ccg.* FROM ccg_file
             WHERE ccg01=g_cxh.cxh01 AND ccg02=g_cxh.cxh02 AND ccg03=g_cxh.cxh03
                   AND ccg06 = g_cxh.cxh06 AND ccg07 = g_cxh.cxh07     #No.FUN-7C0101
            IF STATUS THEN
#              CALL cl_err('sel ccg:',STATUS,0)    #No.FUN-660127
               CALL cl_err3("sel","ccg_file",g_cxh.cxh01,g_cxh.cxh02,STATUS,"","sel ccg:",1)  #No.FUN-660127
               NEXT FIELD cxh01
            END IF
            DISPLAY BY NAME g_ccg.ccg04
            INITIALIZE g_ima.* TO NULL
            SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_ccg.ccg04
            DISPLAY BY NAME g_ima.ima02,g_ima.ima25
            SELECT sfb38 INTO g_sfb38 FROM sfb_file
             WHERE sfb01=g_cxh.cxh01
           # DISPLAY g_sfb38 TO sfb38
          END IF

#FUN-A60092 --begin--
        AFTER FIELD cxh013
           IF g_cxh.cxh013 IS NOT NULL THEN 
             IF p_cmd = 'a' OR (p_cmd = 'u' AND g_cxh.cxh013 != g_cxh013_t) THEN 
             #FUN-B10056 -----------mod start-----------
             #SELECT sfb05,sfb06 INTO l_sfb05,l_sfb06 FROM sfb_file
             # WHERE sfb01 = g_cxh.cxh01
             #SELECT COUNT(*) INTO l_cnt FROM ecu_file
             # WHERE ecu01 = l_sfb05 AND ecu02 = l_sfb06
             #   AND ecu012= g_cxh.cxh013
             #IF l_cnt = 0 THEN 
              IF NOT s_schdat_ecm012(g_cxh.cxh01,g_cxh.cxh013) THEN            
             #FUN-B10056 ----------mod end------------
                 CALL cl_err('','abm-214',0)
                 NEXT FIELD CURRENT 
              ELSE
              	 IF NOT cl_null(g_cxh.cxh014) THEN 
                   #FUN-B10056 -------mod start---------------
              	   #SELECT ecb06 INTO g_cxh.cxh012 FROM ecb_file
              	   # WHERE ecb01 = l_sfb05 AND ecb02 = l_sfb06
              	   #   AND ecb03 = g_cxh.cxh014 AND ecb012= g_cxh.cxh013
                    SELECT ecm04 INTO g_cxh.cxh012 FROM ecm_file
                     WHERE ecm01 = g_cxh.cxh01
                       AND ecm012 =  g_cxh.cxh013
                       AND ecm03 = g_cxh.cxh014  
                   #FUN-B10056 -------mod end----------------
                    SELECT ecd02 INTO l_ecd02 FROM ecd_file
                     WHERE ecd01=g_cxh.cxh012              	       
              	    DISPLAY BY NAME g_cxh.cxh012  
              	    DISPLAY l_ecd02 TO FORMONLY.ecd02 
              	    
                   SELECT COUNT(*) INTO l_cnt FROM cxh_file
                    WHERE cxh01 = g_cxh.cxh01 AND cxh011= g_cxh.cxh011
                      AND cxh012= g_cxh.cxh012
                      AND cxh02 = g_cxh.cxh02 AND cxh03 = g_cxh.cxh03
                      AND cxh04 = g_cxh.cxh04 AND cxh06 = g_cxh.cxh06
                      AND cxh07 = g_cxh.cxh07 AND cxh013= g_cxh.cxh013
                      AND cxh014= g_cxh.cxh014
                    IF l_cnt > 0 THEN 
                      CALL cl_err('',-239,0)
                      NEXT FIELD CURRENT    
                    END IF    
                  END IF   
              END IF                          
            END IF   
           END IF 
        
        AFTER FIELD cxh014
           IF NOT cl_null(g_cxh.cxh014) THEN 
             IF p_cmd = 'a' OR (p_cmd = 'u' AND g_cxh.cxh014 != g_cxh014_t) THEN 
             #FUN-B10056 ----------mod start-------- 
             #SELECT sfb05,sfb06 INTO l_sfb05,l_sfb06 FROM sfb_file
             # WHERE sfb01 = g_cxh.cxh01
             #SELECT COUNT(*),ecb06 INTO l_cnt,g_cxh.cxh012 FROM ecb_file
             # WHERE ecb01 = l_sfb05 AND ecb02 = l_sfb06
             #   AND ecb012= g_cxh.cxh013 AND ecb03 = g_cxh.cxh014
             # GROUP BY ecb06
              LET l_cnt = 0
              SELECT COUNT(*),ecm04 INTO l_cnt,g_cxh.cxh012 FROM ecm_file 
               WHERE ecm01 = g_cxh.cxh01
                 AND ecm012 = g_cxh.cxh013
                 AND ecm03 = g_cxh.cxh014
               GROUP BY ecm04  
             #FUN-B10056 --------mod end--------------
              SELECT ecd02 INTO l_ecd02 FROM ecd_file
               WHERE ecd01=g_cxh.cxh012               
              IF l_cnt = 0 THEN 
                 CALL cl_err('','abm-215',0)
                 NEXT FIELD CURRENT 
              ELSE
              	 LET l_cnt = 0 
                 SELECT COUNT(*) INTO l_cnt FROM cxh_file
                  WHERE cxh01 = g_cxh.cxh01 AND cxh011= g_cxh.cxh011
                   AND cxh012= g_cxh.cxh012 AND cxh02 = g_cxh.cxh02
                   AND cxh03 = g_cxh.cxh03  AND cxh04 = g_cxh.cxh04
                   AND cxh06 = g_cxh.cxh06  AND cxh07 = g_cxh.cxh07
                   AND cxh013= g_cxh.cxh013 AND cxh014= g_cxh.cxh014
                   IF l_cnt > 0 THEN 
                     CALL cl_err('',-239,0)
                     NEXT FIELD CURRENT    
                   END IF    
              END IF                          
            END IF   
            DISPLAY BY NAME g_cxh.cxh012
            DISPLAY l_ecd02 TO FORMONLY.ecd02
           END IF         
#FUN-A60092 --end--
          
        #No.TQC-970227--begin
        AFTER FIELD cxh02
          IF g_cxh.cxh02 IS NOT NULL AND NOT cl_null(g_cxh.cxh01) AND g_cxh.cxh03 IS NOT NULL THEN
            SELECT ccg01 FROM ccg_file
                    WHERE ccg01 = g_cxh.cxh01 AND ccg02 = g_cxh.cxh02
                      AND ccg03 = g_cxh.cxh03
                      AND ccg06 = g_cxh.cxh06 AND ccg07 = g_cxh.cxh07       
            IF STATUS THEN
               CALL cl_err3("sel","ccg_file",g_cxh.cxh01,g_cxh.cxh02,STATUS,"","sel ccg:",1) 
               NEXT FIELD cxh02 
            END IF
            IF cl_null(g_ccg.ccg04) THEN 
               SELECT * INTO g_ccg.* FROM ccg_file
                WHERE ccg01=g_cxh.cxh01 AND ccg02=g_cxh.cxh02 AND ccg03=g_cxh.cxh03
                      AND ccg06 = g_cxh.cxh06 AND ccg07 = g_cxh.cxh07
               DISPLAY BY NAME g_ccg.ccg04   
               SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_ccg.ccg04
               DISPLAY BY NAME g_ima.ima02,g_ima.ima25
               SELECT sfb38 INTO g_sfb38 FROM sfb_file
                WHERE sfb01=g_cxh.cxh01   
            END IF     
          END IF
        #No.TQC-970227--end 
        AFTER FIELD cxh03
#         IF g_cxh.cxh03 IS NOT NULL THEN                                                               #No.TQC-970227                    
          IF NOT cl_null(g_cxh.cxh01) AND g_cxh.cxh02 IS NOT NULL AND  g_cxh.cxh03 IS NOT NULL THEN      #No.TQC-970227
            SELECT ccg01 FROM ccg_file
                    WHERE ccg01 = g_cxh.cxh01 AND ccg02 = g_cxh.cxh02
                      AND ccg03 = g_cxh.cxh03
                      AND ccg06 = g_cxh.cxh06 AND ccg07 = g_cxh.cxh07       #No.FUN-7C0101
            IF STATUS THEN
#              CALL cl_err('sel ccg:',STATUS,0)   #No.FUN-660127
               CALL cl_err3("sel","ccg_file",g_cxh.cxh01,g_cxh.cxh02,STATUS,"","sel ccg:",1)  #No.FUN-660127
               NEXT FIELD cxh03 
            END IF
            #No.TQC-970227--begin
            IF cl_null(g_ccg.ccg04) THEN 
               SELECT * INTO g_ccg.* FROM ccg_file
                WHERE ccg01=g_cxh.cxh01 AND ccg02=g_cxh.cxh02 AND ccg03=g_cxh.cxh03
                      AND ccg06 = g_cxh.cxh06 AND ccg07 = g_cxh.cxh07
               DISPLAY BY NAME g_ccg.ccg04   
               SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_ccg.ccg04
               DISPLAY BY NAME g_ima.ima02,g_ima.ima25
               SELECT sfb38 INTO g_sfb38 FROM sfb_file
                WHERE sfb01=g_cxh.cxh01   
            END IF    
            #No.TQC-970227--end
          END IF
 
        AFTER FIELD cxh04
          IF g_cxh.cxh04 IS NOT NULL THEN
           #FUN-AA0059 ---------------------add start----------------
            IF NOT s_chk_item_no(g_cxh.cxh04,'') THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD cxh04
            END IF 
           #FUN-AA0059 --------------------add end-----------------
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND
               (g_cxh.cxh01 != g_cxh01_t OR g_cxh.cxh02 != g_cxh02_t OR
                g_cxh.cxh03 != g_cxh03_t OR g_cxh.cxh04 != g_cxh04_t OR
                g_cxh.cxh013 != g_cxh013_t OR g_cxh.cxh014 != g_cxh014_t OR #FUN-A60092 add
                g_cxh.cxh011 != g_cxh011_t OR g_cxh.cxh012 != g_cxh012_t OR    #No.FUN-7C0101 add
                g_cxh.cxh06 != g_cxh06_t OR g_cxh.cxh07 != g_cxh07_t)) THEN    #No.FUN-7C0101 add
                SELECT count(*) INTO l_n FROM cxh_file
                 WHERE cxh01 = g_cxh.cxh01 AND cxh02 = g_cxh.cxh02
                   AND cxh03 = g_cxh.cxh03 AND cxh04 = g_cxh.cxh04
                   AND cxh06 = g_cxh.cxh06 AND cxh07 = g_cxh.cxh07          #No.FUN-7C0101
                   AND cxh013= g_cxh.cxh013   #FUN-A60092 
                   AND cxh014= g_cxh.cxh014   #FUN-A60092
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err('count:',-239,0)
                    NEXT FIELD cxh01
                END IF
            END IF
            SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_cxh.cxh04
            IF STATUS THEN
#              CALL cl_err('sel ccg:',STATUS,0)    #No.FUN-660127
               CALL cl_err3("sel","ima_file",g_cxh.cxh04,"",STATUS,"","sel ccg:",1)  #No.FUN-660127
               NEXT FIELD cxh04
            END IF
            DISPLAY g_ima.ima02,g_ima.ima25 TO ima02b,ima25b
            LET g_cxh.cxh05 = g_ima.ima08
            DISPLAY BY NAME g_cxh.cxh05
          END IF
        #No.FUN-7C0101--start--
        AFTER FIELD cxh06
            IF g_cxh.cxh06 IS NOT NULL THEN
               IF g_cxh.cxh06 NOT MATCHES '[12345]' THEN
                  NEXT FIELD cxh06
               END IF
               #FUN-910073--BEGIN--                                                                                                    
               IF g_cxh.cxh06 MATCHES'[12]' THEN                                                                                    
                  CALL cl_set_comp_entry("cxh07",FALSE)                                                                             
                  LET g_cxh.cxh07 = ' '                                                                                             
               ELSE                                                                                                                 
                  CALL cl_set_comp_entry("cxh07",TRUE)                                                                              
               END IF                                                                                                               
               #FUN-910073--END--
            END IF
 
        AFTER FIELD cxh07 
            IF NOT cl_null(g_cxh.cxh07) THEN
                CASE g_cxh.cxh06                                                
                 WHEN 4                                                         
                  SELECT pja02 FROM pja_file WHERE pja01 = g_cxh.cxh07          
                                               AND pjaclose='N'    #No.FUN-960038
                  IF SQLCA.sqlcode!=0 THEN                                      
                     CALL cl_err3('sel','pja_file',g_cxh.cxh07,'',SQLCA.sqlcode,'','',1)
                     NEXT FIELD cxh07                                           
                  END IF                                                        
                 WHEN 5                                                         
                   SELECT gem02 FROM gem_file WHERE gem01 = g_cxh.cxh07 AND gem09 IN ('1','2') AND gemacti = 'Y'
                   IF SQLCA.sqlcode!=0 THEN                                     
                     CALL cl_err3('sel','gem_file',g_cxh.cxh07,'',SQLCA.sqlcode,'','',1)
                     NEXT FIELD cxh07                                           
                  END IF                                                        
                 OTHERWISE EXIT CASE                                            
                END CASE 
            ELSE 
              LET g_cxh.cxh07 = ' '
            END IF
        #No.FUN-7C0101---end---
        AFTER FIELD
        cxh11, cxh12a, cxh12b, cxh12c, cxh12d, cxh12e, cxh12f, cxh12g, cxh12h, cxh12,   #No.FUN-7C0101
        cxh21, cxh22a, cxh22b, cxh22c, cxh22d, cxh22e, cxh22f, cxh22g, cxh22h, cxh22,
        cxh24, cxh25a, cxh25b, cxh25c, cxh25d, cxh25e, cxh25f, cxh25g, cxh25h, cxh25, 
        cxh31, cxh32a, cxh32b, cxh32c, cxh32d, cxh32e, cxh32f, cxh32g, cxh32h, cxh32,
        cxh41, cxh42a, cxh42b, cxh42c, cxh42d, cxh42e, cxh42f, cxh42g, cxh42h, cxh42,
        cxh91, cxh92a, cxh92b, cxh92c, cxh92d, cxh92e, cxh92f, cxh92g, cxh92h, cxh92
            CALL t460_u_cost()
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
            LET l_flag='N'
            IF INT_FLAG THEN
                EXIT INPUT
            END IF
            IF l_flag='Y' THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD cxh01
            END IF
 
      #MOD-530850
     ON ACTION CONTROLP
        CASE
          WHEN INFIELD(ccg04)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_bma2"
            LET g_qryparam.default1 = g_ccg.ccg04
            CALL cl_create_qry() RETURNING g_ccg.ccg04
            DISPLAY g_ccg.ccg04 TO ccg04
            NEXT FIELD ccg04

#FUN-A60092 --begin--
          WHEN INFIELD(cxh013)
            SELECT sfb05,sfb06 INTO l_sfb05,l_sfb06 FROM sfb_file
             WHERE sfb01 = g_cxh.cxh01
            CALL cl_init_qry_var()
          # LET g_qryparam.form = "q_cxh013_1"           #FUN-B10056 mark 
            LET g_qryparam.form = "q_sgx012_2"           #FUN-B10056  
            LET g_qryparam.default1 = g_cxh.cxh013
            LET g_qryparam.default2 = g_cxh.cxh014
          # LET g_qryparam.arg1     = l_sfb05            #FUN-B10056 mark 
          # LET g_qryparam.arg2     = l_sfb06            #FUN-B10056 mark
            LET g_qryparam.arg1     = g_cxh.cxh01        #FUN-B10056    
            CALL cl_create_qry() RETURNING g_cxh.cxh013,g_cxh.cxh014
            IF cl_null(g_cxh.cxh013) THEN LET g_cxh.cxh013 = ' '  END IF  #FUN-B10056 
            DISPLAY BY NAME g_cxh.cxh013,g_cxh.cxh014
            NEXT FIELD cxh013
#FUN-A60092 --end--
            
          WHEN INFIELD(cxh04)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_bmb203"
            LET g_qryparam.default1 = g_cxh.cxh04
            CALL cl_create_qry() RETURNING g_cxh.cxh04
            DISPLAY g_cxh.cxh04 TO cxh04
            NEXT FIELD cxh04
         #No.FUN-7C0101--start--
         WHEN INFIELD(cxh07)
            IF g_cxh.cxh06 MATCHES '[45]' THEN
               CALL cl_init_qry_var()
               CASE g_cxh.cxh06
                  WHEN '4'
                     LET g_qryparam.form = "q_pja"                     
                  WHEN '5'
                      LET g_qryparam.form = "q_gem4"
                  OTHERWISE EXIT CASE
               END CASE
               LET g_qryparam.default1 = g_cxh.cxh07
               CALL cl_create_qry() RETURNING g_cxh.cxh07
               DISPLAY BY NAME g_cxh.cxh07
               NEXT FIELD cxh07  
            END IF      
         OTHERWISE  EXIT CASE          
           #No.FUN-7C0101---end---
       END CASE
 
      #MOD-650015 --start
      #  ON ACTION CONTROLO                        # 沿用所有欄位
      #      IF INFIELD(cxh01) THEN
      #          LET g_cxh.* = g_cxh_t.*
      #          DISPLAY BY NAME g_cxh.*
      #          NEXT FIELD cxh01
      #      END IF
      #MOD-650015 --start
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON KEY(F1) NEXT FIELD cxh11
        ON KEY(F2) NEXT FIELD cxh21
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
FUNCTION t460_u_cost()
    LET g_cxh.cxh91 =g_cxh.cxh11 +g_cxh.cxh21 +g_cxh.cxh31 +g_cxh.cxh41
    LET g_cxh.cxh92 =g_cxh.cxh12 +g_cxh.cxh22 +g_cxh.cxh32 +g_cxh.cxh42
    LET g_cxh.cxh92a=g_cxh.cxh12a+g_cxh.cxh22a+g_cxh.cxh32a+g_cxh.cxh42a
    LET g_cxh.cxh92b=g_cxh.cxh12b+g_cxh.cxh22b+g_cxh.cxh32b+g_cxh.cxh42b
    LET g_cxh.cxh92c=g_cxh.cxh12c+g_cxh.cxh22c+g_cxh.cxh32c+g_cxh.cxh42c
    LET g_cxh.cxh92d=g_cxh.cxh12d+g_cxh.cxh22d+g_cxh.cxh32d+g_cxh.cxh42d
    LET g_cxh.cxh92e=g_cxh.cxh12e+g_cxh.cxh22e+g_cxh.cxh32e+g_cxh.cxh42e
    LET g_cxh.cxh12=g_cxh.cxh12a+g_cxh.cxh12b+g_cxh.cxh12c+g_cxh.cxh12d
                    +g_cxh.cxh12e+g_cxh.cxh12f+g_cxh.cxh12g+g_cxh.cxh12h    #No.FUN-7C0101
    LET g_cxh.cxh22=g_cxh.cxh22a+g_cxh.cxh22b+g_cxh.cxh22c+g_cxh.cxh22d
                    +g_cxh.cxh22e+g_cxh.cxh22f+g_cxh.cxh22g+g_cxh.cxh22h    #No.FUN-7C0101
    LET g_cxh.cxh32=g_cxh.cxh32a+g_cxh.cxh32b+g_cxh.cxh32c+g_cxh.cxh32d
                    +g_cxh.cxh32e+g_cxh.cxh32f+g_cxh.cxh32g+g_cxh.cxh32h    #No.FUN-7C0101
    LET g_cxh.cxh42=g_cxh.cxh42a+g_cxh.cxh42b+g_cxh.cxh42c+g_cxh.cxh42d
                    +g_cxh.cxh42e+g_cxh.cxh42f+g_cxh.cxh42g+g_cxh.cxh42h    #No.FUN-7C0101
    LET g_cxh.cxh92=g_cxh.cxh92a+g_cxh.cxh92b+g_cxh.cxh92c+g_cxh.cxh92d
                    +g_cxh.cxh92e+g_cxh.cxh92f+g_cxh.cxh92g+g_cxh.cxh92h    #No.FUN-7C0101
    CALL t460_show_2()
END FUNCTION
 
FUNCTION t460_b_tot(p_cmd)
 DEFINE p_cmd		LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 DEFINE mccg		RECORD LIKE ccg_file.*
 
 SELECT * INTO mccg.* FROM ccg_file
  WHERE ccg01=g_cxh.cxh01 AND ccg02=g_cxh.cxh02 AND ccg03=g_cxh.cxh03
#    AND ccg012= g_cxh.cxh013   #FUN-A60092 add
#    AND ccg013= g_cxh.cxh014   #FUN-A60092 add    
 
 SELECT SUM(cxh12),SUM(cxh12a),SUM(cxh12b),SUM(cxh12c),SUM(cxh12d),SUM(cxh12e),SUM(cxh12f),SUM(cxh12g),SUM(cxh12h),   #No.FUN-7C0101  add
        SUM(cxh22),SUM(cxh22a),SUM(cxh22b),SUM(cxh22c),SUM(cxh22d),SUM(cxh22e),SUM(cxh22f),SUM(cxh22g),SUM(cxh22h),   #No.FUN-7C0101
        SUM(cxh32),SUM(cxh32a),SUM(cxh32b),SUM(cxh32c),SUM(cxh32d),SUM(cxh32e),SUM(cxh32f),SUM(cxh32g),SUM(cxh32h),   #No.FUN-7C0101
        SUM(cxh42),SUM(cxh42a),SUM(cxh42b),SUM(cxh42c),SUM(cxh42d),SUM(cxh42e),SUM(cxh42f),SUM(cxh42g),SUM(cxh42h),   #No.FUN-7C0101
        SUM(cxh92),SUM(cxh92a),SUM(cxh92b),SUM(cxh92c),SUM(cxh92d),SUM(cxh92e),SUM(cxh92f),SUM(cxh92g),SUM(cxh92h)    #No.FUN-7C0101
   INTO mccg.ccg12,mccg.ccg12a,mccg.ccg12b,mccg.ccg12c,mccg.ccg12d,mccg.ccg12e,mccg.ccg12f,mccg.ccg12g,mccg.ccg12h,   #No.FUN-7C0101
        mccg.ccg22,mccg.ccg22a,mccg.ccg22b,mccg.ccg22c,mccg.ccg22d,mccg.ccg22e,mccg.ccg12f,mccg.ccg12g,mccg.ccg12h,   #No.FUN-7C0101
        mccg.ccg32,mccg.ccg32a,mccg.ccg32b,mccg.ccg32c,mccg.ccg32d,mccg.ccg32e,mccg.ccg12f,mccg.ccg12g,mccg.ccg12h,   #No.FUN-7C0101
        mccg.ccg42,mccg.ccg42a,mccg.ccg42b,mccg.ccg42c,mccg.ccg42d,mccg.ccg42e,mccg.ccg12f,mccg.ccg12g,mccg.ccg12h,   #No.FUN-7C0101
        mccg.ccg92,mccg.ccg92a,mccg.ccg92b,mccg.ccg92c,mccg.ccg92d,mccg.ccg92e,mccg.ccg12f,mccg.ccg12g,mccg.ccg12h    #No.FUN-7C0101
   FROM cxh_file
  WHERE cxh01=g_cxh.cxh01 AND cxh02=g_cxh.cxh02 AND cxh03=g_cxh.cxh03
    AND cxh013= g_cxh.cxh013   #FUN-A60092 add
    AND cxh014= g_cxh.cxh014   #FUN-A60092 add  
      
 IF mccg.ccg12 IS NULL THEN
    LET mccg.ccg12 = 0 LET mccg.ccg12a= 0 LET mccg.ccg12b= 0
    LET mccg.ccg12c= 0 LET mccg.ccg12d= 0 LET mccg.ccg12e= 0
    LET mccg.ccg12f= 0 LET mccg.ccg12g= 0 LET mccg.ccg12h= 0    #No.FUN-7C0101
    LET mccg.ccg22 = 0 LET mccg.ccg22a= 0 LET mccg.ccg22b= 0
    LET mccg.ccg22c= 0 LET mccg.ccg22d= 0 LET mccg.ccg22e= 0
    LET mccg.ccg22f= 0 LET mccg.ccg22g= 0 LET mccg.ccg22h= 0    #No.FUN-7C0101
    LET mccg.ccg32 = 0 LET mccg.ccg32a= 0 LET mccg.ccg32b= 0
    LET mccg.ccg32c= 0 LET mccg.ccg32d= 0 LET mccg.ccg32e= 0
    LET mccg.ccg32f= 0 LET mccg.ccg32g= 0 LET mccg.ccg32h= 0    #No.FUN-7C0101
    LET mccg.ccg42 = 0 LET mccg.ccg42a= 0 LET mccg.ccg42b= 0
    LET mccg.ccg42c= 0 LET mccg.ccg42d= 0 LET mccg.ccg42e= 0
    LET mccg.ccg42f= 0 LET mccg.ccg42g= 0 LET mccg.ccg42h= 0    #No.FUN-7C0101
    LET mccg.ccg92 = 0 LET mccg.ccg92a= 0 LET mccg.ccg92b= 0
    LET mccg.ccg92c= 0 LET mccg.ccg92d= 0 LET mccg.ccg92e= 0
    LET mccg.ccg92f= 0 LET mccg.ccg92g= 0 LET mccg.ccg92h= 0    #No.FUN-7C0101
 END IF
 
 SELECT SUM(cxh22),SUM(cxh22a),SUM(cxh22b),SUM(cxh22c),SUM(cxh22d),SUM(cxh22e),SUM(cxh22f),SUM(cxh22g),SUM(cxh22h)   #No.FUN-7C0101
   INTO mccg.ccg23,mccg.ccg23a,mccg.ccg23b,mccg.ccg23c,mccg.ccg23d,mccg.ccg23e,mccg.ccg23f,mccg.ccg23g,mccg.ccg23h   #NO.FUN-7C0101
     FROM cxh_file
  WHERE cxh01=g_cxh.cxh01 AND cxh02=g_cxh.cxh02 AND cxh03=g_cxh.cxh03
    AND cxh05 IN ('M','R')
    AND cxh013= g_cxh.cxh013   #FUN-A60092 add
    AND cxh014= g_cxh.cxh014   #FUN-A60092 add      
 IF mccg.ccg23 IS NULL THEN
    LET mccg.ccg23 = 0 LET mccg.ccg23a= 0 LET mccg.ccg23b= 0
    LET mccg.ccg23c= 0 LET mccg.ccg23d= 0 LET mccg.ccg23e= 0
    LET mccg.ccg23f= 0 LET mccg.ccg23g= 0 LET mccg.ccg23h= 0          #No.FUN-7C0101
 END IF
 LET mccg.ccg22 =mccg.ccg22 -mccg.ccg23
 LET mccg.ccg22a=mccg.ccg22a-mccg.ccg23a
 LET mccg.ccg22b=mccg.ccg22b-mccg.ccg23b
 LET mccg.ccg22c=mccg.ccg22c-mccg.ccg23c
 LET mccg.ccg22d=mccg.ccg22d-mccg.ccg23d
 LET mccg.ccg22e=mccg.ccg22e-mccg.ccg23e
 LET mccg.ccg22f=mccg.ccg22f-mccg.ccg23f        #No.FUN-7C0101
 LET mccg.ccg22g=mccg.ccg22g-mccg.ccg23g        #No.FUN-7C0101
 LET mccg.ccg22h=mccg.ccg22h-mccg.ccg23h        #No.FUN-7C0101
 DISPLAY BY NAME
         mccg.ccg12,mccg.ccg22,mccg.ccg23,mccg.ccg32,mccg.ccg42,mccg.ccg92
 UPDATE ccg_file SET ccg_file.* = mccg.*
  WHERE ccg01=g_cxh.cxh01 AND ccg02=g_cxh.cxh02 AND ccg03=g_cxh.cxh03
#    AND ccg012=g_cxh.cxh013   #FUN-A60092 add
#    AND ccg013=g_cxh.cxh014   #FUN-A60092 add
 IF STATUS THEN 
# CALL cl_err('upd ccg.*:',STATUS,1)  #No.FUN-660127
  CALL cl_err3("upd","ccg_file",g_cxh.cxh01,g_cxh.cxh02,STATUS,"","upd ccg.*:",1)  #No.FUN-660127
 
  RETURN END IF
END FUNCTION
 
FUNCTION t460_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t460_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t460_count
    FETCH t460_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t460_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('open t460_cs:',SQLCA.sqlcode,0)
        INITIALIZE g_cxh.* TO NULL
    ELSE
        CALL t460_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t460_fetch(p_flcxh)
    DEFINE
        p_flcxh          LIKE type_file.chr1           #No.FUN-680122CHAR(01)
 
    CASE p_flcxh
        WHEN 'N' FETCH NEXT     t460_cs INTO g_cxh.cxh01,g_cxh.cxh011,g_cxh.cxh012,g_cxh.cxh02,g_cxh.cxh03,g_cxh.cxh04,g_cxh.cxh06,g_cxh.cxh07
                                            ,g_cxh.cxh013,g_cxh.cxh014   #FUN-A60092 
        WHEN 'P' FETCH PREVIOUS t460_cs INTO g_cxh.cxh01,g_cxh.cxh011,g_cxh.cxh012,g_cxh.cxh02,g_cxh.cxh03,g_cxh.cxh04,g_cxh.cxh06,g_cxh.cxh07
                                            ,g_cxh.cxh013,g_cxh.cxh014   #FUN-A60092 
        WHEN 'F' FETCH FIRST    t460_cs INTO g_cxh.cxh01,g_cxh.cxh011,g_cxh.cxh012,g_cxh.cxh02,g_cxh.cxh03,g_cxh.cxh04,g_cxh.cxh06,g_cxh.cxh07
                                            ,g_cxh.cxh013,g_cxh.cxh014   #FUN-A60092         
        WHEN 'L' FETCH LAST     t460_cs INTO g_cxh.cxh01,g_cxh.cxh011,g_cxh.cxh012,g_cxh.cxh02,g_cxh.cxh03,g_cxh.cxh04,g_cxh.cxh06,g_cxh.cxh07
                                            ,g_cxh.cxh013,g_cxh.cxh014   #FUN-A60092         
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
            FETCH ABSOLUTE g_jump t460_cs INTO g_cxh.cxh01,g_cxh.cxh011,g_cxh.cxh012,g_cxh.cxh02,g_cxh.cxh03,g_cxh.cxh04,g_cxh.cxh06,g_cxh.cxh07
                                              ,g_cxh.cxh013,g_cxh.cxh014   #FUN-A60092             
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cxh.cxh01,SQLCA.sqlcode,0)
        INITIALIZE g_cxh.* TO NULL              #No.FUN-6A0019
        RETURN
    ELSE
       CASE p_flcxh
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_cxh.* FROM cxh_file            # 重讀DB,因TEMP有不被更新特性
     WHERE cxh01 = g_cxh.cxh01 
       AND cxh011 = g_cxh.cxh011 
       AND cxh012 = g_cxh.cxh012 
       AND cxh02 = g_cxh.cxh02 
       AND cxh03 = g_cxh.cxh03 
       AND cxh04 = g_cxh.cxh04 
       AND cxh06 = g_cxh.cxh06 
       AND cxh07 = g_cxh.cxh07
       AND cxh013= g_cxh.cxh013   #FUN-A60092 
       AND cxh014= g_cxh.cxh014   #FUN-A60092        
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_cxh.cxh01,SQLCA.sqlcode,0)   #No.FUN-660127
        CALL cl_err3("sel","cxh_file",g_cxh.cxh01,g_cxh.cxh02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
        INITIALIZE g_cxh.* TO NULL              #No.FUN-6A0019
    ELSE
 
        CALL t460_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t460_show()
    DEFINE mccg	RECORD LIKE ccg_file.*
    DEFINE l_ima02,l_ima25   LIKE ima_file.ima02       #No.FUN-680122CHAR(30)	
    DEFINE l_ecd02           LIKE ecd_file.ecd02
    DEFINE l_ima57           LIKE ima_file.ima57       #No.FUN-680122SMALLINT	
    INITIALIZE mccg.* TO NULL
    SELECT * INTO mccg.* FROM ccg_file
     WHERE ccg01=g_cxh.cxh01 AND ccg02=g_cxh.cxh02 AND ccg03=g_cxh.cxh03
       AND ccg06=g_cxh.cxh06 AND ccg07=g_cxh.cxh07    #No.FUN-7C0101
#       AND ccg012= g_cxh.cxh013   #FUN-A60092 
#       AND ccg013= g_cxh.cxh014   #FUN-A60092        
    DISPLAY BY NAME mccg.ccg04,
            mccg.ccg11,mccg.ccg21,           mccg.ccg31,mccg.ccg41, mccg.ccg91,
            mccg.ccg12,mccg.ccg22,mccg.ccg23,mccg.ccg32,mccg.ccg42,mccg.ccg92
    LET g_cxh_t.* = g_cxh.*
    DISPLAY BY NAME g_cxh.cxh01,g_cxh.cxh011,g_cxh.cxh012,g_cxh.cxh02,
                    g_cxh.cxh03, g_cxh.cxh04, g_cxh.cxh05,g_cxh.cxh06,g_cxh.cxh07    #No.FUN-7C0101
                   ,g_cxh.cxh013,g_cxh.cxh014   #FUN-A60092 add 
    LET l_ecd02=NULL
    SELECT ecd02 INTO l_ecd02 FROM ecd_file
     WHERE ecd01=g_cxh.cxh012
    DISPLAY l_ecd02 TO ecd02
    LET l_ima02=NULL LET l_ima25=NULL
    SELECT ima02,ima25,ima57 INTO l_ima02,l_ima25,l_ima57
      FROM ima_file WHERE ima01 = mccg.ccg04
    DISPLAY l_ima02,l_ima25,l_ima57 TO ima02,ima25,ima57
    LET l_ima02=NULL LET l_ima25=NULL
    SELECT ima02,ima25,ima57 INTO l_ima02,l_ima25,l_ima57
      FROM ima_file WHERE ima01=g_cxh.cxh04
    DISPLAY l_ima02,l_ima25,l_ima57 TO ima02b,ima25b,ima57b
    SELECT sfb38 INTO g_sfb38 FROM sfb_file
     WHERE sfb01=g_cxh.cxh01
    #DISPLAY g_sfb38 TO sfb38
    CALL t460_show_2()
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t460_show_2()
   #DEFINE cxh12u,cxh22u,cxh32u,cxh42u,cxh92u	LIKE aao_file.aao05         #No.FUN-680122DEC(15,5)
 #  DEFINE tot                              LIKE ima_file.ima26         #No.FUN-680122DEC(15,3)  #FUN-4C0005#FUN-A20044
   DEFINE tot                              LIKE type_file.num15_3         #No.FUN-680122DEC(15,3)  #FUN-4C0005#FUN-A20044
   DEFINE amta,amtb,amtc,amtd,amte,amt     LIKE type_file.num20_6      #No.FUN-680122DEC(20,6)  #FUN-4C0005
 
   {
    LET tot=g_cxh.cxh31+g_cxh.cxh33+g_cxh.cxh35+g_cxh.cxh37
    LET amta=g_cxh.cxh32a+g_cxh.cxh34a+g_cxh.cxh36a+g_cxh.cxh38a
    LET amtb=g_cxh.cxh32b+g_cxh.cxh34b+g_cxh.cxh36b+g_cxh.cxh38b
    LET amtc=g_cxh.cxh32c+g_cxh.cxh34c+g_cxh.cxh36c+g_cxh.cxh38c
    LET amtd=g_cxh.cxh32d+g_cxh.cxh34d+g_cxh.cxh36d+g_cxh.cxh38d
    LET amte=g_cxh.cxh32e+g_cxh.cxh34e+g_cxh.cxh36e+g_cxh.cxh38e
    LET amte=g_cxh.cxh32e+g_cxh.cxh34e+g_cxh.cxh36e+g_cxh.cxh38e
    LET amt =g_cxh.cxh32 +g_cxh.cxh34 +g_cxh.cxh36 +g_cxh.cxh38
   }
    DISPLAY By NAME
        g_cxh.cxh11, g_cxh.cxh12a, g_cxh.cxh12b, g_cxh.cxh12c,
        g_cxh.cxh12d, g_cxh.cxh12e, g_cxh.cxh12f, g_cxh.cxh12g, g_cxh.cxh12h,g_cxh.cxh12,     #No.FUN-7C0101
        g_cxh.cxh21, g_cxh.cxh22a, g_cxh.cxh22b, g_cxh.cxh22c,
        g_cxh.cxh22d, g_cxh.cxh22e, g_cxh.cxh22f, g_cxh.cxh22g, g_cxh.cxh22h, g_cxh.cxh22,
        g_cxh.cxh24,g_cxh.cxh25a,g_cxh.cxh25b,g_cxh.cxh25c,g_cxh.cxh25d,
        g_cxh.cxh25e,g_cxh.cxh25f, g_cxh.cxh25g, g_cxh.cxh25h, g_cxh.cxh25,
        g_cxh.cxh26,g_cxh.cxh27a,g_cxh.cxh27b,g_cxh.cxh27c,g_cxh.cxh27d,
        g_cxh.cxh27e,g_cxh.cxh27f, g_cxh.cxh27g, g_cxh.cxh27h, g_cxh.cxh27,
        g_cxh.cxh28,g_cxh.cxh29a,g_cxh.cxh29b,g_cxh.cxh29c,g_cxh.cxh29d,
        g_cxh.cxh29e,g_cxh.cxh29f, g_cxh.cxh29g, g_cxh.cxh29h, g_cxh.cxh29,
       # tot,amta,amtb,amtc,amtd,amte,amt,
        g_cxh.cxh31, g_cxh.cxh32a, g_cxh.cxh32b, g_cxh.cxh32c,
        g_cxh.cxh32d, g_cxh.cxh32e, g_cxh.cxh32f, g_cxh.cxh32g, g_cxh.cxh32h, g_cxh.cxh32,
        g_cxh.cxh33, g_cxh.cxh34a, g_cxh.cxh34b, g_cxh.cxh34c,
        g_cxh.cxh34d, g_cxh.cxh34e, g_cxh.cxh34f, g_cxh.cxh34g, g_cxh.cxh34h, g_cxh.cxh34,
        g_cxh.cxh35, g_cxh.cxh36a, g_cxh.cxh36b, g_cxh.cxh36c,
        g_cxh.cxh36d, g_cxh.cxh36e, g_cxh.cxh36f, g_cxh.cxh36g, g_cxh.cxh36h, g_cxh.cxh36, 
        g_cxh.cxh37, g_cxh.cxh38a, g_cxh.cxh38b, g_cxh.cxh38c,
        g_cxh.cxh38d, g_cxh.cxh38e, g_cxh.cxh38f, g_cxh.cxh38g, g_cxh.cxh38h, g_cxh.cxh38,
        g_cxh.cxh39, g_cxh.cxh40a, g_cxh.cxh40b, g_cxh.cxh40c,
        g_cxh.cxh40d, g_cxh.cxh40e, g_cxh.cxh40f, g_cxh.cxh40g, g_cxh.cxh40h, g_cxh.cxh40,
        g_cxh.cxh41, g_cxh.cxh42a, g_cxh.cxh42b, g_cxh.cxh42c,
        g_cxh.cxh42d, g_cxh.cxh42e, g_cxh.cxh42f, g_cxh.cxh42g, g_cxh.cxh42h, g_cxh.cxh42,
        g_cxh.cxh91, g_cxh.cxh92a, g_cxh.cxh92b, g_cxh.cxh92c,
        g_cxh.cxh92d, g_cxh.cxh92e, g_cxh.cxh92f, g_cxh.cxh92g, g_cxh.cxh92h, g_cxh.cxh92
END FUNCTION
 
FUNCTION t460_u()
    IF g_cxh.cxh01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_cxh01_t = g_cxh.cxh01
    LET g_cxh011_t = g_cxh.cxh011
    LET g_cxh012_t = g_cxh.cxh012
    LET g_cxh02_t = g_cxh.cxh02
    LET g_cxh03_t = g_cxh.cxh03
    LET g_cxh04_t = g_cxh.cxh04
    LET g_cxh06_t = g_cxh.cxh06    #No.FUN-7C0101
    LET g_cxh07_t = g_cxh.cxh07    #No.FUN-7C0101
    LET g_cxh013_t= g_cxh.cxh013   #FUN-A60092 
    LET g_cxh014_t= g_cxh.cxh014   #FUN-A60092 
    
    BEGIN WORK
 
    OPEN t460_cl USING g_cxh.cxh01,g_cxh.cxh011,g_cxh.cxh012,g_cxh.cxh02,g_cxh.cxh03,g_cxh.cxh04,g_cxh.cxh06,g_cxh.cxh07
                      ,g_cxh.cxh013,g_cxh.cxh014   #FUN-A60092 add
    IF STATUS THEN
       CALL cl_err("OPEN t460_cl:", STATUS, 1)
       CLOSE t460_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t460_cl INTO g_cxh.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t460_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t460_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_cxh.*=g_cxh_t.*
            CALL t460_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE cxh_file SET cxh_file.* = g_cxh.*    # 更新DB
         WHERE cxh01 = g_cxh01_t 
           AND cxh011 = g_cxh011_t 
           AND cxh012 = g_cxh012_t 
           AND cxh02 = g_cxh02_t 
           AND cxh03 = g_cxh03_t 
           AND cxh04 = g_cxh04_t 
           AND cxh06 = g_cxh06_t 
           AND cxh07 = g_cxh07_t            # COLAUTH?
           AND cxh013= g_cxh013_t           #FUN-A60092 
           AND cxh014= g_cxh014_t           #FUN-A60092 add
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_cxh.cxh01,SQLCA.sqlcode,0)   #No.FUN-660127
            CALL cl_err3("upd","cxh_file",g_cxh01_t,g_cxh02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660127
            CONTINUE WHILE
        END IF
        CALL t460_b_tot('u')
        EXIT WHILE
    END WHILE
    CLOSE t460_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t460_set_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
  IF p_cmd = 'a' AND (NOT g_before_input_done) OR INFIELD(cxh04) THEN
     CALL cl_set_comp_entry("cxh01,cxh011,cxh012,cxh02,cxh03,cxh04,cxh06,cxh07,cxh013,cxh014",TRUE)   #No.FUN-7C0101
                             #FUN-A60092 add cxh013,cxh014
  END IF
END FUNCTION
 
FUNCTION t460_set_no_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
  IF p_cmd = 'u' AND g_chkey MATCHES '[Nn]' AND
     (NOT g_before_input_done) OR INFIELD(cxh04) THEN
     CALL cl_set_comp_entry("cxh01,cxh011,cxh012,cxh02,cxh03,cxh04,cxh06,cxh07,cxh013,cxh014",FALSE)  #No.FUN-7C0101
                        #FUN-A60092 add cxh013,cxh014
  END IF
  #FUN-910073--BENGIN--                                                                                                             
  IF p_cmd = 'u' AND g_chkey MATCHES '[Yy]' AND                                                                                     
     (NOT g_before_input_done) AND NOT INFIELD(cxh04) THEN                                                                                                 
     IF g_cxh.cxh06 MATCHES'[12]' THEN                                                                                              
        CALL cl_set_comp_entry("cxh07",FALSE)                                                                                       
     ELSE                                                                                                                           
        CALL cl_set_comp_entry("cxh07",TRUE)                                                                                        
     END IF                                                                                                                         
  END IF                                                                                                                            
  #FUN-910073--END-- 
END FUNCTION
 
#Patch....NO.TQC-610037 <001> #
