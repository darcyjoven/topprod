# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: axct400.4gl
# Descriptions...: 每月工單主件在製成本維護作業
# Date & Author..: 96/01/31 By Roger
# Modify.........: 03/05/17 By Jiunn (No.7267)
#                  新增 V.聯產品成本
# Modify.........: No.FUN-4C0005 04/12/02 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.FUN-4C0099 05/01/11 By kim 報表轉XML功能
# Modify.........: No.MOD-530850 05/03/31 By Will 增加料件的開窗
# Modify.........: No.FUN-550025 05/05/16 By vivien 單據編號格式放大 
# Modify.........: No.FUN-560253 05/06/29 By Melody shell錯誤更正
# Modify.........: No.MOD-580322 05/08/31 By wujie  中文資訊修改進 ze_file
# Modify.........: No.FUN-610080 06/02/09 By Sarah 增加顯示srm05,srm06,sre11,srm04,up1,up2,up3
# Modify.........: No.TQC-620151 06/02/27 By Sarah 修正抓srm_file的WHERE條件句
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換 
# Modify.........: No.FUN-6A0019 06/10/25 By jamie 1.FUNCTION _fetch() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0146 06/10/27 By bnlent l_time轉g_time
# Modify.........: No.TQC-6A0078 06/11/13 By ice 修正報表格式錯誤
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0101 08/01/07 By shiwuying 成本改善增加ccg06(成本計算類別),ccg07(類別編號)和各種制費
# Modify.........: NO.FUN-830149 08/04/01 By zhaijie
# Modify.........: No.FUN-840202 08/05/07 By TSD.lucasyeh 自定欄位功能修改
# Modify.........: No.FUN-910073 09/02/02 By jan 成本計算類別為"1or2"時,類別編號應noentry且自動給' '
# Modify.........: No.TQC-970207 09/07/20 By dxfwo  1.ccg01工單編號：有放大鏡但但不能開窗                                                    
#                                         2.ccguser ccgtime ccgdate未依標准給值
# Modify.........: No.FUN-980009 09/08/21 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/10/15 By chenmoyan 專案加上'結案'的判斷
# Modify.........: No:TQC-970003 09/12/01 By jan 批次成本修改
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50075 10/05/24 By lutingting GP5.2 AXC模組TABLE重新分類,相關INSERT語法修改
# Modify.........: No.FUN-AA0059 10/10/27 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.CHI-BC0001 11/12/01 By ck2yuan 去除刪除與更改功能
# Modify.........: No:FUN-BC0062 12/02/20 By lilingyu 成本計算類型(axcs010)不可選擇【6.移動加權平均成本】
# Modify.........: No:FUN-CC0002 12/12/04 By xujing 增加報廢量ccg311
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_argv1             LIKE ccg_file.ccg01,
    g_argv2             LIKE ccg_file.ccg02,
    g_argv3             LIKE ccg_file.ccg03,
    g_argv4             LIKE ccg_file.ccg04,
    g_argv5             LIKE ccg_file.ccg06,   #No.FUN-7C0101
    g_argv6             LIKE ccg_file.ccg07,   #No.FUN-7C0101
    g_ccg               RECORD LIKE ccg_file.*,
    g_ccg_t             RECORD LIKE ccg_file.*,
    g_ccg01_t           LIKE ccg_file.ccg01,
    g_ccg02_t           LIKE ccg_file.ccg02,
    g_ccg03_t           LIKE ccg_file.ccg03,
    g_ccg06_t           LIKE ccg_file.ccg06,    #No.FUN-7C0101
    g_ccg07_t           LIKE ccg_file.ccg07,    #No.FUN-7C0101
    g_wc,g_sql          STRING,                 #No.FUN-580092 HCN
    g_ima               RECORD LIKE ima_file.*,
    g_sfb               RECORD LIKE sfb_file.*
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt          LIKE type_file.num10    #No.FUN-680122 INTEGER
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE   g_msg          LIKE ze_file.ze03       #No.FUN-680122CHAR(72)
DEFINE   g_before_input_done LIKE type_file.num5     #No.FUN-680122 SMALLINT
 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680122 SMALLINT
DEFINE   g_str          STRING                       #NO.FUN-830149
DEFINE   l_table        STRING                       #NO.FUN-830149
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5          #No.FUN-680122 SMALLINT
#       l_time        LIKE type_file.chr8              #No.FUN-6A0146
 
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
    LET g_argv4 = ARG_VAL(4)
    LET g_argv5 = ARG_VAL(5)  #No.FUN-7C0101
    LET g_argv6 = ARG_VAL(6)  #No.FUN-7C0101
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
    INITIALIZE g_ccg.* TO NULL
    INITIALIZE g_ccg_t.* TO NULL
#NO.FUN-830149-----start----
   LET g_sql = "ccg01.ccg_file.ccg01,",
               "ccg02.ccg_file.ccg02,",
               "ccg03.ccg_file.ccg03,",
               "ccg04.ccg_file.ccg04,",
               "ccg11.ccg_file.ccg11,",
               "ccg12.ccg_file.ccg12,",
               "ima02.ima_file.ima02,",
               "ima25.ima_file.ima25,",
               "l_ima02.ima_file.ima02,",
               "l_ima021.ima_file.ima021,",
               "l_avg.ccg_file.ccg12"
   LET l_table = cl_prt_temptable('axct400',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",status,1) EXIT PROGRAM
   END IF
#NO.FUN-830149-----end-----
    LET g_forupd_sql = "SELECT * FROM ccg_file WHERE ccg01 = ? AND ccg02 = ? AND ccg03 = ? AND ccg06 = ? AND ccg07 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t400_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
    LET p_row = 4 LET p_col = 2
    OPEN WINDOW t400_w AT p_row,p_col
        WITH FORM "axc/42f/axct400" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
   #start FUN-610080
    CALL cl_set_comp_visible("srm04,srm05,srm06,sre11,up1,up2,up3,dummy11",FALSE)
   #end FUN-610080
   
    CALL cl_set_comp_visible("ccg311",g_ccz.ccz45='2')    #FUN-CC0002 add
    
    IF NOT cl_null(g_argv1) THEN CALL t400_q() END IF
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL t400_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW t400_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
FUNCTION t400_cs()
DEFINE l_ccg06 LIKE ccg_file.ccg06  #No.FUN-7C0101
    CLEAR FORM
    IF NOT cl_null(g_argv1) AND g_argv1 != '@' THEN
       LET g_wc="ccg01='",g_argv1,"' AND ccg02=",g_argv2," AND ccg03=",g_argv3, " AND ccg06='",g_argv5,"' AND ccg07='",g_argv6,"'" #No.FUN-7C0101
    END IF
    IF NOT cl_null(g_argv1) AND g_argv1  = '@' THEN
       LET g_wc="ccg04='",g_argv4,"' AND ccg02=",g_argv2," AND ccg03=",g_argv3, " AND ccg06='",g_argv5,"' AND ccg07='",g_argv6,"'" #No.FUN-7C0101
    END IF
    IF cl_null(g_argv1) THEN
   INITIALIZE g_ccg.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        ccg04, ccg01, ccg02, ccg03,ccg06,ccg07,  #No.FUN-7C0101 add ccg06,ccg07
        ccg20,
        ccg11, ccg12a, ccg12b, ccg12c, ccg12d, ccg12e, ccg12f, ccg12g, ccg12h, ccg12, #No.FUN-7C0101
        ccg21, ccg22a, ccg22b, ccg22c, ccg22d, ccg22e, ccg22f, ccg22g, ccg22h, ccg22, #No.FUN-7C0101
               ccg23a, ccg23b, ccg23c, ccg23d, ccg23e, ccg23f, ccg23g, ccg23h, ccg23, #No.FUN-7C0101
        ccg31, ccg311, ccg32a, ccg32b, ccg32c, ccg32d, ccg32e, ccg32f, ccg32g, ccg32h, ccg32, #No.FUN-7C0101  #FUN-CC0002 ccg311
               ccg42a, ccg42b, ccg42c, ccg42d, ccg42e, ccg42f, ccg42g, ccg42h, ccg42, #No.FUN-7C0101
        ccg91, ccg92a, ccg92b, ccg92c, ccg92d, ccg92e, ccg92f, ccg92g, ccg92h, ccg92, #No.FUN-7C0101
        ccguser, ccgdate,
      #FUN-840202    ---start---
        ccgud01,ccgud02,ccgud03,ccgud04,ccgud05,ccgud06,ccgud07,ccgud08,
        ccgud09,ccgud10,ccgud11,ccgud12,ccgud13,ccgud14,ccgud15
      #FUN-840202    ----end----
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
        #No.FUN-7C0101--start--
        AFTER FIELD ccg06
              LET l_ccg06 = get_fldbuf(ccg06)
        #No.FUN-7C0101---end---
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
          #No.FUN-7C0101--start--                                           
              WHEN INFIELD(ccg07)                                               
                 IF l_ccg06 MATCHES '[45]' THEN                             
                    CALL cl_init_qry_var()       
                    LET g_qryparam.state= "c"                                
                 CASE l_ccg06                                               
                    WHEN '4'                                                    
                      LET g_qryparam.form = "q_pja"                             
                    WHEN '5'                                                    
                      LET g_qryparam.form = "q_gem4"                            
                    OTHERWISE EXIT CASE                                         
                 END CASE                                                       
                 CALL cl_create_qry() RETURNING g_qryparam.multiret                     
                 DISPLAY  g_qryparam.multiret TO ccg07                                   
                 NEXT FIELD ccg07                                               
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
 
    END IF
    IF INT_FLAG THEN RETURN END IF
    LET g_sql="SELECT ccg04,ccg01,ccg02,ccg03,ccg06,ccg07 FROM ccg_file ", #No.FUN-7C0101
        " WHERE ",g_wc CLIPPED," ORDER BY ccg04,ccg01,ccg02,ccg03,ccg06,ccg07"   #No.FUN-7C0101
    PREPARE t400_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t400_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t400_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM ccg_file WHERE ",g_wc CLIPPED
    PREPARE t400_precount FROM g_sql
    DECLARE t400_count CURSOR FOR t400_precount
END FUNCTION
 
FUNCTION t400_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert 
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL t400_a() 
            END IF
        ON ACTION query 
            LET g_action_choice="query" 
            IF cl_chk_act_auth() THEN
               CALL t400_q() 
            END IF
        ON ACTION next 
            CALL t400_fetch('N') 
        ON ACTION previous 
            CALL t400_fetch('P')
       #----CHI-BC0001 start -----
       #ON ACTION modify 
       #    LET g_action_choice="modify"
       #    IF cl_chk_act_auth() THEN
       #       CALL t400_u() 
       #    END IF 
       #ON ACTION delete 
       #    LET g_action_choice="delete"
       #    IF cl_chk_act_auth() THEN
       #       CALL t400_r() 
       #    END IF 
       #----CHI-BC0001 end -----
#       ON ACTION 元件單身
        ON ACTION component_detail
            LET g_action_choice="component_detail"
            IF cl_chk_act_auth() THEN 
              #LET g_msg="axct410 ",g_ccg.ccg01," ",g_ccg.ccg02," ",g_ccg.ccg03," ",g_ccg.ccg06," ",g_ccg.ccg07  #No.FUN-7C0101 #TQC-970003
               LET g_msg="axct410 ",g_ccg.ccg01," ",g_ccg.ccg02," ",g_ccg.ccg03," ",g_ccg.ccg06  #TQC-970003
              #CALL cl_cmdrun(g_msg)      #FUN-660216 remark
               CALL cl_cmdrun_wait(g_msg)  #FUN-660216 add
            END IF
            SELECT * INTO g_ccg.* FROM ccg_file WHERE ccg01 = g_ccg.ccg01 AND ccg02 = g_ccg.ccg02 AND ccg03 = g_ccg.ccg03 AND ccg06 = g_ccg.ccg06 AND ccg07 = g_ccg.ccg07
            CALL t400_show()
#       ON ACTION 成本項目成本分析 
        ON ACTION cost_item_costing_analysis 
            LET g_action_choice="cost_item_costing_analysis"
            IF cl_chk_act_auth() THEN    #工單     主件料號
            #  LET g_msg="axcq400 ",g_ccg.ccg01," ",g_ccg.ccg04                                #No.FUN-7C0101 mark
            #  LET g_msg="axcq400 ",g_ccg.ccg01," ",g_ccg.ccg04," ",g_ccg.ccg06," ",g_ccg.ccg07 #No.FUN-7C0101 #TQC-970003
               LET g_msg="axcq400 ",g_ccg.ccg01," ",g_ccg.ccg04," ",g_ccg.ccg06   #TQC-9700003
               CALL cl_cmdrun(g_msg CLIPPED)
            END IF 
        #No.7267 03/05/17 By Jiunn Add.A.a.01 -----
#       ON ACTION 聯產品成本查詢
        ON ACTION jp_cost
            LET g_msg="axcq450 '' ",g_ccg.ccg02," ",
                                    g_ccg.ccg03," '",
                           #        g_ccg.ccg01,"' '2'"                                    #No.FUN-7C0101 mark
                           #        g_ccg.ccg01,"' '2' '",g_ccg.ccg06,"' '",g_ccg.ccg07,"'" #No.FUN-7C0101 #TQC-970003
                                    g_ccg.ccg01,"' '2' '",g_ccg.ccg06,"' "   #TQC-970003
            CALL cl_cmdrun(g_msg)
        #No.7267 End.A.a.01 -----------------------
        ON ACTION output 
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL t400_out()
            END IF
        ON ACTION help 
                     CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            #EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL t400_fetch('/')
        ON ACTION first
            CALL t400_fetch('F')
        ON ACTION last
            CALL t400_fetch('L')

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
               IF g_ccg.ccg04 IS NOT NULL THEN
                  LET g_doc.column1 = "ccg04"
                  LET g_doc.value1 = g_ccg.ccg04
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
    CLOSE t400_cs
END FUNCTION
 
 
FUNCTION g_ccg_zero()
	LET g_ccg.ccg11=0
	LET g_ccg.ccg12=0
	LET g_ccg.ccg12a=0
	LET g_ccg.ccg12b=0
	LET g_ccg.ccg12c=0
	LET g_ccg.ccg12d=0
	LET g_ccg.ccg12e=0
        LET g_ccg.ccg12f=0  #No.FUN-7C0101
        LET g_ccg.ccg12g=0  #No.FUN-7C0101
        LET g_ccg.ccg12h=0  #No.FUN-7C0101
	LET g_ccg.ccg20=0
	LET g_ccg.ccg21=0
	LET g_ccg.ccg22=0
	LET g_ccg.ccg22a=0
	LET g_ccg.ccg22b=0
	LET g_ccg.ccg22c=0
	LET g_ccg.ccg22d=0
	LET g_ccg.ccg22e=0
        LET g_ccg.ccg22f=0  #No.FUN-7C0101
        LET g_ccg.ccg22g=0  #No.FUN-7C0101
        LET g_ccg.ccg22h=0  #No.FUN-7C0101
	LET g_ccg.ccg23=0
	LET g_ccg.ccg23a=0
	LET g_ccg.ccg23b=0
	LET g_ccg.ccg23c=0
	LET g_ccg.ccg23d=0
	LET g_ccg.ccg23e=0
        LET g_ccg.ccg23f=0  #No.FUN-7C0101
        LET g_ccg.ccg23g=0  #No.FUN-7C0101
        LET g_ccg.ccg23h=0  #No.FUN-7C0101
	LET g_ccg.ccg31=0
        LET g_ccg.ccg311=0      #FUN-CC0002 add
	LET g_ccg.ccg32=0
	LET g_ccg.ccg32a=0
	LET g_ccg.ccg32b=0
	LET g_ccg.ccg32c=0
	LET g_ccg.ccg32d=0
	LET g_ccg.ccg32e=0
        LET g_ccg.ccg32f=0  #No.FUN-7C0101
        LET g_ccg.ccg32g=0  #No.FUN-7C0101
        LET g_ccg.ccg32h=0  #No.FUN-7C0101
	LET g_ccg.ccg42=0
	LET g_ccg.ccg42a=0
	LET g_ccg.ccg42b=0
	LET g_ccg.ccg42c=0
	LET g_ccg.ccg42d=0
	LET g_ccg.ccg42e=0
        LET g_ccg.ccg42f=0  #No.FUN-7C0101
        LET g_ccg.ccg42g=0  #No.FUN-7C0101
        LET g_ccg.ccg42h=0  #No.FUN-7C0101
	LET g_ccg.ccg91=0
	LET g_ccg.ccg92=0
	LET g_ccg.ccg92a=0
	LET g_ccg.ccg92b=0
	LET g_ccg.ccg92c=0
	LET g_ccg.ccg92d=0
	LET g_ccg.ccg92e=0
        LET g_ccg.ccg92f=0  #No.FUN-7C0101
        LET g_ccg.ccg92g=0  #No.FUN-7C0101
        LET g_ccg.ccg92h=0  #No.FUN-7C0101
END FUNCTION
 
FUNCTION t400_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_ccg.* TO NULL
    CALL g_ccg_zero()

#FUN-BC0062 --begin--
       IF g_ccz.ccz28 = '6' THEN
          CALL cl_err('','axc-026',1)
          RETURN 
       END IF
#FUN-BC0062 --end--

    LET g_ccg.ccg06 = g_ccz.ccz28                #No.FUN-7C0101
    LET g_ccg.ccg02=g_ccg_t.ccg02
    LET g_ccg.ccg03=g_ccg_t.ccg03
    LET g_ccg01_t = NULL
    LET g_ccg02_t = NULL
    LET g_ccg03_t = NULL
    LET g_ccg06_t = NULL    #No.FUN-7C0101
    LET g_ccg07_t = NULL    #No.FUN-7C0101
   #LET g_ccg.ccgplant = g_plant #FUN-980009 add    #FUN-A50075
    LET g_ccg.ccglegal = g_legal #FUN-980009 add
    LET g_ccg_t.*=g_ccg.*
    CALL cl_opmsg('a')
    WHILE TRUE
       LET g_ccg.ccguser = g_user                #No.TQC-970207                                                                     
       LET g_ccg.ccgoriu = g_user #FUN-980030
       LET g_ccg.ccgorig = g_grup #FUN-980030
       LET g_data_plant = g_plant #FUN-980030
       LET g_ccg.ccgtime = TIME                  #No.TQC-970207                                                                     
       LET g_ccg.ccgdate = g_today               #No.TQC-970207 
 
        CALL t400_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            INITIALIZE g_ccg.* TO NULL
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_ccg.ccg01 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO ccg_file VALUES(g_ccg.*)
        IF SQLCA.sqlcode THEN
#           CALL cl_err('ins ccg:',SQLCA.sqlcode,0)   #No.FUN-660127
            CALL cl_err3("ins","ccg_file",g_ccg.ccg01,g_ccg.ccg02,SQLCA.sqlcode,"","ins ccg:",1)  #No.FUN-660127
            CONTINUE WHILE
        ELSE
            LET g_ccg_t.* = g_ccg.*              # 保存上筆資料
            SELECT ccg01,ccg02,ccg03,ccg06,ccg07 INTO g_ccg.ccg01,g_ccg.ccg02,g_ccg.ccg03,g_ccg.ccg06,g_ccg.ccg07 FROM ccg_file
                WHERE ccg01 = g_ccg.ccg01
                  AND ccg02 = g_ccg.ccg02 AND ccg03 = g_ccg.ccg03
                  AND ccg06 = g_ccg.ccg06 AND ccg07 = g_ccg.ccg07 #No.FUN-7C0101
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t400_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,     #No.FUN-680122 VARCHAR(1)
        l_flag          LIKE type_file.chr1,     #No.FUN-680122 VARCHAR(1)
        l_n             LIKE type_file.num5,     #No.FUN-680122 SMALLINT
        l_pja01         LIKE pja_file.pja01,     #No.FUN-7C0101 add
        l_gem01         LIKE gem_file.gem01      #No.FUN-7C0101 add
 
    DISPLAY BY NAME   g_ccg.ccguser,g_ccg.ccgdate,g_ccg.ccgtime    #No.TQC-970207     
 
    INPUT BY NAME g_ccg.ccgoriu,g_ccg.ccgorig,
        g_ccg.ccg04, g_ccg.ccg01, g_ccg.ccg02, g_ccg.ccg03,
        g_ccg.ccg06, g_ccg.ccg07,                #No.FUN-7C0101 add ccg06,ccg07
        g_ccg.ccg20,
        g_ccg.ccg11, g_ccg.ccg12a, g_ccg.ccg12b, g_ccg.ccg12c,
        g_ccg.ccg12d,g_ccg.ccg12e, g_ccg.ccg12f, g_ccg.ccg12g, g_ccg.ccg12h,g_ccg.ccg12, #No.FUN-7C0101
        g_ccg.ccg21, g_ccg.ccg22a, g_ccg.ccg22b, g_ccg.ccg22c,
        g_ccg.ccg22d, g_ccg.ccg22e, g_ccg.ccg22f, g_ccg.ccg22g, g_ccg.ccg22h,g_ccg.ccg22,#No.FUN-7C0101
                     g_ccg.ccg23a, g_ccg.ccg23b, g_ccg.ccg23c,
        g_ccg.ccg23d, g_ccg.ccg23e, g_ccg.ccg23f, g_ccg.ccg23g, g_ccg.ccg23h,g_ccg.ccg23,#No.FUN-7C0101
        g_ccg.ccg31, g_ccg.ccg311, g_ccg.ccg32a, g_ccg.ccg32b, g_ccg.ccg32c,             #FUN-CC0002 ccg311
        g_ccg.ccg32d, g_ccg.ccg32e, g_ccg.ccg32f, g_ccg.ccg32g, g_ccg.ccg32h,g_ccg.ccg32,#No.FUN-7C0101
                     g_ccg.ccg42a, g_ccg.ccg42b, g_ccg.ccg42c,
        g_ccg.ccg42d, g_ccg.ccg42e, g_ccg.ccg42f, g_ccg.ccg42g, g_ccg.ccg42h,g_ccg.ccg42,#No.FUN-7C0101
        g_ccg.ccg91, g_ccg.ccg92a, g_ccg.ccg92b, g_ccg.ccg92c,
        g_ccg.ccg92d, g_ccg.ccg92e, g_ccg.ccg92f, g_ccg.ccg92g, g_ccg.ccg92h,g_ccg.ccg92 #No.FUN-7C0101
      #FUN-840202     ---start---
       ,g_ccg.ccgud01,g_ccg.ccgud02,g_ccg.ccgud03,g_ccg.ccgud04,
        g_ccg.ccgud05,g_ccg.ccgud06,g_ccg.ccgud07,g_ccg.ccgud08,
        g_ccg.ccgud09,g_ccg.ccgud10,g_ccg.ccgud11,g_ccg.ccgud12,
        g_ccg.ccgud13,g_ccg.ccgud14,g_ccg.ccgud15
      #FUN-840202     ----end----
        WITHOUT DEFAULTS 
 
        BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL t400_set_entry(p_cmd)
          CALL t400_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
            #No.FUN-550025 --start--
           CALL cl_set_docno_format("ccg01")
            #No.FUN-550025 ---end---
 
        AFTER FIELD ccg01
          IF g_ccg.ccg01 IS NOT NULL THEN
            SELECT * INTO g_sfb.* FROM sfb_file WHERE sfb01=g_ccg.ccg01 
            IF STATUS THEN
#              CALL cl_err('sel sfb:',STATUS,0)   #No.FUN-660127
               CALL cl_err3("sel","sfb_file",g_ccg.ccg01,"",STATUS,"","sel sfb:",1)  #No.FUN-660127
               NEXT FIELD ccg01 
            END IF
            LET g_ccg.ccg04=g_sfb.sfb05
            DISPLAY BY NAME g_ccg.ccg04
            INITIALIZE g_ima.* TO NULL
            SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_ccg.ccg04
            DISPLAY BY NAME g_ima.ima02,g_ima.ima25
          END IF
 
        AFTER FIELD ccg03
          IF g_ccg.ccg03 IS NOT NULL THEN 
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND 
               (g_ccg.ccg01 != g_ccg01_t OR
                g_ccg.ccg02 != g_ccg02_t OR g_ccg.ccg03 != g_ccg03_t OR
                g_ccg.ccg06 != g_ccg06_t OR g_ccg.ccg07 != g_ccg07_t)) THEN #No.FUN-7C0101
                SELECT count(*) INTO l_n FROM ccg_file
                    WHERE ccg01 = g_ccg.ccg01
                      AND ccg02 = g_ccg.ccg02 AND ccg03 = g_ccg.ccg03
                      AND ccg06 = g_ccg.ccg06 AND ccg07 = g_ccg.ccg07  #No.FUN-7C0101
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err('count:',-239,0)
                    NEXT FIELD ccg01
                END IF
            END IF
          END IF
 
        #FUN-530065        
        AFTER FIELD ccg04
          IF g_ccg.ccg04 IS NOT NULL THEN
            #FUN-AA0059 ---------------------------add start------------------
             IF NOT s_chk_item_no(g_ccg.ccg04,'') THEN
                CALL cl_err('',g_errno,1)
                NEXT FIELD ccg04
             END IF 
            #FUN-AA0059 --------------------------add end-------------------- 
             SELECT COUNT(*) INTO l_n 
               FROM ima_file 
               WHERE ima01 = g_ccg.ccg04
             IF l_n <=0 THEN
#No.MOD-580322--begin                                                                                                              
                CALL cl_err('','axc-204','1')                                                                                       
#               MESSAGE "料號不存在"                                                                                                
#No.MOD-580322--end        
                NEXT FIELD ccg04
              ELSE
                MESSAGE ""
             END IF
          END IF
        #--
 
#No.FUN-7C0101-------------BEGIN-----------------
        AFTER FIELD ccg06
           IF g_ccg.ccg06 IS NOT NULL THEN
              IF g_ccg.ccg06 NOT MATCHES '[12345]' THEN
                 NEXT FIELD ccg06
              END IF
              #FUN-910073--BEGIN--
               IF g_ccg.ccg06 MATCHES'[12]' THEN
                  CALL cl_set_comp_entry("ccg07",FALSE)
                  LET g_ccg.ccg07 = ' '
               ELSE
                  CALL cl_set_comp_entry("ccg07",TRUE)
               END IF
               #FUN-910073--END-- 
            END IF
        
         AFTER FIELD ccg07
            IF NOT cl_null(g_ccg.ccg07) OR g_ccg.ccg07 != ' '  THEN
               IF g_ccg.ccg06='4'THEN
                  SELECT pja01 INTO l_pja01 FROM pja_file WHERE pja01=g_ccg.ccg07
                                             AND pjaclose='N'     #FUN-960038
                  IF STATUS THEN
                     CALL cl_err3("sel","pja_file",g_ccg.ccg07,"",STATUS,"","sel pja:",1)
                     NEXT FIELD ccg07
                  END IF
               END IF
               IF g_ccg.ccg06='5'THEN
                  SELECT gem01 INTO l_gem01 FROM gem_file WHERE gem01=g_ccg.ccg07
                  IF STATUS THEN
                     CALL cl_err3("sel","gem_file",g_ccg.ccg07,"",STATUS,"","sel gem:",1)
                     NEXT FIELD ccg07
                  END IF
               END IF
            ELSE
               LET g_ccg.ccg07 = ' '
            END IF
#No.FUN-7C0101--------------END------------------
        AFTER FIELD 
        ccg11, ccg12a, ccg12b, ccg12c, ccg12d, ccg12e, ccg12f, ccg12g, ccg12h, ccg12, #No.FUN-7C0101
        ccg20,
        ccg21, ccg22a, ccg22b, ccg22c, ccg22d, ccg22e, ccg22f, ccg22g, ccg22h, ccg22, #No.FUN-7C0101
               ccg23a, ccg23b, ccg23c, ccg23d, ccg23e, ccg23f, ccg23g, ccg23h, ccg23, #No.FUN-7C0101
        ccg31, ccg32a, ccg32b, ccg32c, ccg32d, ccg32e, ccg32f, ccg32g, ccg32h, ccg32, #No.FUN-7C0101
               ccg42a, ccg42b, ccg42c, ccg42d, ccg42e, ccg42f, ccg42g, ccg42h, ccg42, #No.FUN-7C0101
        ccg91, ccg92a, ccg92b, ccg92c, ccg92d, ccg92e, ccg92f, ccg92g, ccg92h, ccg92  #No.FUN-7C0101
            CALL t400_u_cost()
 
      #FUN-840202     ---start---
        AFTER FIELD ccgud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccgud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccgud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccgud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccgud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccgud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccgud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccgud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccgud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccgud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccgud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccgud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccgud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccgud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccgud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #FUN-840202     ----end----
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
            LET l_flag='N'
            IF INT_FLAG THEN
                EXIT INPUT  
            END IF
            IF l_flag='Y' THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD ccg01
            END IF
 
      #MOD-530850                                                                
     ON ACTION CONTROLP                                                         
        CASE                                                                    
#No.TQC-970207--begin--                                                                                                             
          WHEN INFIELD(ccg01)                                                                                                       
            CALL cl_init_qry_var()                                                                                                  
            LET g_qryparam.form = "q_sfb001"                                                                                        
            LET g_qryparam.default1 = g_ccg.ccg01                                                                                   
            CALL cl_create_qry() RETURNING g_ccg.ccg01                                                                              
            DISPLAY g_ccg.ccg01 TO ccg01                                                                                            
            NEXT FIELD ccg01                                                                                                        
#No.TQC-970207 --end--
          WHEN INFIELD(ccg04)                                                   
            CALL cl_init_qry_var()                                              
            LET g_qryparam.form = "q_bma2"                                       
            LET g_qryparam.default1 = g_ccg.ccg04                               
            CALL cl_create_qry() RETURNING g_ccg.ccg04                  
            DISPLAY g_ccg.ccg04 TO ccg04                                
            NEXT FIELD ccg04                                                    
#No.FUN-7C0101-------------BEGIN-----------------
          WHEN INFIELD(ccg07)
            IF g_ccg.ccg06 MATCHES '[45]' THEN
             CALL cl_init_qry_var()
             CASE g_ccg.ccg06 
                WHEN '4'
                   LET g_qryparam.form = "q_pja"                     
                WHEN '5'
                   LET g_qryparam.form = "q_gem4"
                OTHERWISE EXIT CASE
             END CASE
             LET g_qryparam.default1 = g_ccg.ccg07
             CALL cl_create_qry() RETURNING g_ccg.ccg07
             DISPLAY BY NAME g_ccg.ccg07
            END IF
#No.FUN-7C0101--------------END------------------
         OTHERWISE                                                              
            EXIT CASE                                                           
       END CASE                                                                 
      #MOD-650015 --start
      #  ON ACTION CONTROLO                        # 沿用所有欄位
      #      IF INFIELD(ccg01) THEN
      #          LET g_ccg.* = g_ccg_t.*
      #          DISPLAY BY NAME g_ccg.* 
      #          NEXT FIELD ccg01
      #      END IF
      #MOD-650015 --end
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
        ON KEY(F1) NEXT FIELD ccg11
        ON KEY(F2) NEXT FIELD ccg20
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
    
    END INPUT
END FUNCTION
 
FUNCTION t400_u_cost()
    LET g_ccg.ccg91=g_ccg.ccg11+g_ccg.ccg21+g_ccg.ccg31
    LET g_ccg.ccg92=g_ccg.ccg12+g_ccg.ccg22+g_ccg.ccg32+g_ccg.ccg42
    LET g_ccg.ccg92a=g_ccg.ccg12a+g_ccg.ccg22a+g_ccg.ccg23a
                                 +g_ccg.ccg32a+g_ccg.ccg42a
    LET g_ccg.ccg92b=g_ccg.ccg12b+g_ccg.ccg22b+g_ccg.ccg23b
                                 +g_ccg.ccg32b+g_ccg.ccg42b
    LET g_ccg.ccg92c=g_ccg.ccg12c+g_ccg.ccg22c+g_ccg.ccg23c
                                 +g_ccg.ccg32c+g_ccg.ccg42c
    LET g_ccg.ccg92d=g_ccg.ccg12d+g_ccg.ccg22d+g_ccg.ccg23d
                                 +g_ccg.ccg32d+g_ccg.ccg42d
    LET g_ccg.ccg92e=g_ccg.ccg12e+g_ccg.ccg22e+g_ccg.ccg23e
                                 +g_ccg.ccg32e+g_ccg.ccg42e
    LET g_ccg.ccg92f=g_ccg.ccg12f+g_ccg.ccg22f+g_ccg.ccg23f
                                 +g_ccg.ccg32f+g_ccg.ccg42f     #No.FUN-7C0101
    LET g_ccg.ccg92g=g_ccg.ccg12g+g_ccg.ccg22g+g_ccg.ccg23g
                                 +g_ccg.ccg32g+g_ccg.ccg42g     #No.FUN-7C0101
    LET g_ccg.ccg92h=g_ccg.ccg12h+g_ccg.ccg22h+g_ccg.ccg23h
                                 +g_ccg.ccg32h+g_ccg.ccg42h     #No.FUN-7C0101
    LET g_ccg.ccg12=g_ccg.ccg12a+g_ccg.ccg12b+g_ccg.ccg12c+g_ccg.ccg12d
                                +g_ccg.ccg12e
                                +g_ccg.ccg12f+g_ccg.ccg12g+g_ccg.ccg12h #No.FUN-7C0101
    LET g_ccg.ccg22=g_ccg.ccg22a+g_ccg.ccg22b+g_ccg.ccg22c+g_ccg.ccg22d
                                +g_ccg.ccg22e
                                +g_ccg.ccg22f+g_ccg.ccg22g+g_ccg.ccg22h #No.FUN-7C0101
    LET g_ccg.ccg23=g_ccg.ccg23a+g_ccg.ccg23b+g_ccg.ccg23c+g_ccg.ccg23d
                                +g_ccg.ccg23e
                                +g_ccg.ccg23f+g_ccg.ccg23g+g_ccg.ccg23h #No.FUN-7C0101
    LET g_ccg.ccg32=g_ccg.ccg32a+g_ccg.ccg32b+g_ccg.ccg32c+g_ccg.ccg32d
                                +g_ccg.ccg32e
                                +g_ccg.ccg32f+g_ccg.ccg32g+g_ccg.ccg32h #No.FUN-7C0101
    LET g_ccg.ccg42=g_ccg.ccg42a+g_ccg.ccg42b+g_ccg.ccg42c+g_ccg.ccg42d
                                +g_ccg.ccg42e
                                +g_ccg.ccg42f+g_ccg.ccg42g+g_ccg.ccg42h #No.FUN-7C0101
    LET g_ccg.ccg92=g_ccg.ccg92a+g_ccg.ccg92b+g_ccg.ccg92c+g_ccg.ccg92d
                                +g_ccg.ccg92e
                                +g_ccg.ccg92f+g_ccg.ccg92g+g_ccg.ccg92h #No.FUN-7C0101
    CALL t400_show_2()
END FUNCTION
 
FUNCTION t400_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL t400_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t400_count
    FETCH t400_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    OPEN t400_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('open t400_cs:',SQLCA.sqlcode,0)
        INITIALIZE g_ccg.* TO NULL
    ELSE
        CALL t400_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t400_fetch(p_flccg)
    DEFINE
        p_flccg          LIKE type_file.chr1          #No.FUN-680122CHAR(01)
 
    CASE p_flccg
        WHEN 'N' FETCH NEXT     t400_cs INTO g_ccg.ccg04,g_ccg.ccg01,g_ccg.ccg02,g_ccg.ccg03,g_ccg.ccg06,g_ccg.ccg07
        WHEN 'P' FETCH PREVIOUS t400_cs INTO g_ccg.ccg04,g_ccg.ccg01,g_ccg.ccg02,g_ccg.ccg03,g_ccg.ccg06,g_ccg.ccg07
        WHEN 'F' FETCH FIRST    t400_cs INTO g_ccg.ccg04,g_ccg.ccg01,g_ccg.ccg02,g_ccg.ccg03,g_ccg.ccg06,g_ccg.ccg07
        WHEN 'L' FETCH LAST     t400_cs INTO g_ccg.ccg04,g_ccg.ccg01,g_ccg.ccg02,g_ccg.ccg03,g_ccg.ccg06,g_ccg.ccg07
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
            FETCH ABSOLUTE g_jump t400_cs INTO g_ccg.ccg04,g_ccg.ccg01,g_ccg.ccg02,g_ccg.ccg03,g_ccg.ccg06,g_ccg.ccg07
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ccg.ccg01,SQLCA.sqlcode,0)
        INITIALIZE g_ccg.* TO NULL              #No.FUN-6A0019
        RETURN
    ELSE
       CASE p_flccg
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_ccg.* FROM ccg_file            # 重讀DB,因TEMP有不被更新特性
       WHERE ccg01 = g_ccg.ccg01 AND ccg02 = g_ccg.ccg02 AND ccg03 = g_ccg.ccg03 AND ccg06 = g_ccg.ccg06 AND ccg07 = g_ccg.ccg07
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_ccg.ccg01,SQLCA.sqlcode,0)   #No.FUN-660127
        CALL cl_err3("sel","ccg_file",g_ccg.ccg01,g_ccg.ccg02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
        INITIALIZE g_ccg.* TO NULL              #No.FUN-6A0019
    ELSE
        CALL t400_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t400_show()
   #start FUN-610080
    DEFINE l_srm04  LIKE srm_file.srm04,
           l_srm05  LIKE srm_file.srm05,
           l_srm06  LIKE srm_file.srm06,
           l_sre11  LIKE sre_file.sre11,
           l_up1,l_up2,l_up3 LIKE ccg_file.ccg12        #No.FUN-680122DEC(20,6)
   #end FUN-610080
 
    LET g_ccg_t.* = g_ccg.*
    DISPLAY BY NAME g_ccg.ccgoriu,g_ccg.ccgorig,
        g_ccg.ccg04,  g_ccg.ccg01,  g_ccg.ccg02,  g_ccg.ccg03,
        g_ccg.ccg06,  g_ccg.ccg07,                      #No.FUN-7C0101
        g_ccg.ccg11,  g_ccg.ccg12a, g_ccg.ccg12b, g_ccg.ccg12c,
        g_ccg.ccg12d, g_ccg.ccg12e, g_ccg.ccg12,
        g_ccg.ccg12f, g_ccg.ccg12g, g_ccg.ccg12h,       #No.FUN-7C0101
        g_ccg.ccg20,
        g_ccg.ccguser, g_ccg.ccgdate, g_ccg.ccgtime
      #FUN-840202     ---start---
       ,g_ccg.ccgud01,g_ccg.ccgud02,g_ccg.ccgud03,g_ccg.ccgud04,
        g_ccg.ccgud05,g_ccg.ccgud06,g_ccg.ccgud07,g_ccg.ccgud08,
        g_ccg.ccgud09,g_ccg.ccgud10,g_ccg.ccgud11,g_ccg.ccgud12,
        g_ccg.ccgud13,g_ccg.ccgud14,g_ccg.ccgud15
      #FUN-840202     ----end----
 
   #start FUN-610080
    SELECT ima911 INTO g_ima.ima911 FROM ima_file WHERE ima01=g_ccg.ccg04
    IF g_ima.ima911='Y' THEN 
       CALL cl_set_comp_visible("ccg01",FALSE) 
    ELSE
       CALL cl_set_comp_visible("ccg01",TRUE) 
    END IF
    CALL cl_set_comp_visible("srm04,srm05,srm06,sre11,up1,up2,up3,dummy11",g_ima.ima911 = 'Y')
    SELECT srm04,srm05,srm06 INTO l_srm04,l_srm05,l_srm06 FROM srm_file
     WHERE srm01=g_ccg.ccg02 AND srm02=g_ccg.ccg03 AND srm03=g_ccg.ccg01   #TQC-620151
    IF cl_null(l_srm04) THEN LET l_srm04 = 0 END IF
    IF cl_null(l_srm05) THEN LET l_srm05 = 0 END IF
    IF cl_null(l_srm06) THEN LET l_srm06 = 0 END IF
    DISPLAY l_srm04 TO FORMONLY.srm04
    DISPLAY l_srm05 TO FORMONLY.srm05
    DISPLAY l_srm06 TO FORMONLY.srm06
    SELECT SUM(sre_file.sre11) INTO l_sre11 FROM sre_file
     WHERE sre01=g_ccg.ccg02 AND sre02=g_ccg.ccg03 AND sre04=g_ccg.ccg01   #TQC-620151
    IF cl_null(l_sre11) THEN LET l_sre11 = 0 END IF
    DISPLAY l_sre11 TO FORMONLY.sre11
    LET l_up1 = (g_ccg.ccg12a+g_ccg.ccg22a)/(l_sre11+l_srm04)
    LET l_up2 = (g_ccg.ccg12b+g_ccg.ccg22b)/(l_sre11+l_srm04*l_srm05)
    LET l_up3 = (g_ccg.ccg12c+g_ccg.ccg22c)/(l_sre11+l_srm04*l_srm06)
    DISPLAY l_up1 TO FORMONLY.up1
    DISPLAY l_up2 TO FORMONLY.up2
    DISPLAY l_up3 TO FORMONLY.up3
   #end FUN-610080
    CALL t400_show_2()
    SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_ccg.ccg04
    DISPLAY BY NAME g_ima.ima25,g_ima.ima02
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t400_show_2()
    DISPLAY By NAME
        g_ccg.ccg11, g_ccg.ccg12a, g_ccg.ccg12b, g_ccg.ccg12c,
        g_ccg.ccg12d,g_ccg.ccg12e, g_ccg.ccg12f, g_ccg.ccg12g,g_ccg.ccg12h, g_ccg.ccg12, #No.FUN-7C0101
        g_ccg.ccg21, g_ccg.ccg22a, g_ccg.ccg22b, g_ccg.ccg22c,
        g_ccg.ccg22d,g_ccg.ccg22e, g_ccg.ccg22f, g_ccg.ccg22g,g_ccg.ccg22h, g_ccg.ccg22, #No.FUN-7C0101
                     g_ccg.ccg23a, g_ccg.ccg23b, g_ccg.ccg23c,
        g_ccg.ccg23d,g_ccg.ccg23e, g_ccg.ccg23f, g_ccg.ccg23g, g_ccg.ccg23h,g_ccg.ccg23, #No.FUN-7C0101
        g_ccg.ccg31, g_ccg.ccg32a, g_ccg.ccg32b, g_ccg.ccg32c,
        g_ccg.ccg311,            #FUN-CC0002 add
        g_ccg.ccg32d,g_ccg.ccg32e, g_ccg.ccg32f, g_ccg.ccg32g, g_ccg.ccg32h,g_ccg.ccg32, #No.FUN-7C0101
                     g_ccg.ccg42a, g_ccg.ccg42b, g_ccg.ccg42c,
        g_ccg.ccg42d,g_ccg.ccg42e, g_ccg.ccg42f, g_ccg.ccg42g, g_ccg.ccg42h,g_ccg.ccg42, #No.FUN-7C0101
        g_ccg.ccg91, g_ccg.ccg92a, g_ccg.ccg92b, g_ccg.ccg92c,
        g_ccg.ccg92d,g_ccg.ccg92e, g_ccg.ccg92f, g_ccg.ccg92g, g_ccg.ccg92h,g_ccg.ccg92  #No.FUN-7C0101
END FUNCTION
#----------------  CHI-BC0001 start----------------------- 
#FUNCTION t400_u()
#   IF g_ccg.ccg01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
#   MESSAGE ""
#   CALL cl_opmsg('u')
#   LET g_ccg01_t = g_ccg.ccg01
#   LET g_ccg02_t = g_ccg.ccg02
#   LET g_ccg03_t = g_ccg.ccg03
#   LET g_ccg06_t = g_ccg.ccg06 #No.FUN-7C0101 add
#   LET g_ccg07_t = g_ccg.ccg07 #No.FUN-7C0101 add
#   BEGIN WORK
#
#   OPEN t400_cl USING g_ccg.ccg01,g_ccg.ccg02,g_ccg.ccg03,g_ccg.ccg06,g_ccg.ccg07
#   IF STATUS THEN
#      CALL cl_err("OPEN t400_cl:", STATUS, 1)
#      CLOSE t400_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
#   FETCH t400_cl INTO g_ccg.*               # 對DB鎖定
#   IF SQLCA.sqlcode THEN
#       CALL cl_err('',SQLCA.sqlcode,0)
#       RETURN
#   END IF
#   CALL t400_show()                          # 顯示最新資料
#   WHILE TRUE
#       CALL t400_i("u")                      # 欄位更改
#       IF INT_FLAG THEN
#           LET INT_FLAG = 0
#           LET g_ccg.*=g_ccg_t.*
#           CALL t400_show()
#           CALL cl_err('',9001,0)
#           EXIT WHILE
#       END IF
#       UPDATE ccg_file SET ccg_file.* = g_ccg.*    # 更新DB
#           WHERE ccg01 = g_ccg_t.ccg01 AND ccg02 = g_ccg_t.ccg02 AND ccg03 = g_ccg_t.ccg03 AND ccg06 = g_ccg_t.ccg06 AND ccg07 = g_ccg_t.ccg07            # COLAUTH?
#       IF SQLCA.sqlcode THEN
##           CALL cl_err(g_ccg.ccg01,SQLCA.sqlcode,0)   #No.FUN-660127
#           CALL cl_err3("upd","ccg_file",g_ccg01_t,g_ccg02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660127
#           CONTINUE WHILE
#       END IF
#       EXIT WHILE
#   END WHILE
#   CLOSE t400_cl
#   COMMIT WORK
#END FUNCTION
# 
#FUNCTION t400_r()
#   IF g_ccg.ccg01 IS NULL THEN
#       CALL cl_err('',-400,0)
#       RETURN
#   END IF
#   BEGIN WORK
#
#   OPEN t400_cl USING g_ccg.ccg01,g_ccg.ccg02,g_ccg.ccg03,g_ccg.ccg06,g_ccg.ccg07
#   IF STATUS THEN
#      CALL cl_err("OPEN t400_cl:", STATUS, 1)
#      CLOSE t400_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
#   FETCH t400_cl INTO g_ccg.*
#   IF SQLCA.sqlcode THEN
#       CALL cl_err(g_ccg.ccg01,SQLCA.sqlcode,0)
#       RETURN
#   END IF
#   CALL t400_show()
#   IF cl_delete() THEN
#       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
#       LET g_doc.column1 = "ccg04"         #No.FUN-9B0098 10/02/24
#       LET g_doc.value1 = g_ccg.ccg04      #No.FUN-9B0098 10/02/24
#       CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
#      DELETE FROM ccg_file WHERE ccg01 = g_ccg.ccg01
#                             AND ccg02 = g_ccg.ccg02 AND ccg03 = g_ccg.ccg03
#                             AND ccg06 = g_ccg.ccg06 AND ccg07 = g_ccg.ccg07 #No.FUN-7C0101 add
#      CLEAR FORM
#      OPEN t400_count
#      #FUN-B50064-add-start--
#      IF STATUS THEN
#         CLOSE t400_cs
#         CLOSE t400_count
#         COMMIT WORK
#         RETURN
#      END IF
#      #FUN-B50064-add-end-- 
#      FETCH t400_count INTO g_row_count
#      #FUN-B50064-add-start--
#      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
#         CLOSE t400_cs
#         CLOSE t400_count
#         COMMIT WORK
#         RETURN
#      END IF
#      #FUN-B50064-add-end--
#      DISPLAY g_row_count TO FORMONLY.cnt
#      OPEN t400_cs
#      IF g_curs_index = g_row_count + 1 THEN
#         LET g_jump = g_row_count
#         CALL t400_fetch('L')
#      ELSE
#         LET g_jump = g_curs_index
#         LET mi_no_ask = TRUE
#         CALL t400_fetch('/')
#      END IF
#   END IF
#   CLOSE t400_cl
#   COMMIT WORK
#END FUNCTION
#----------------  CHI-BC0001 end----------------------- 
FUNCTION t400_out()
    DEFINE
        l_i             LIKE type_file.num5,          #No.FUN-680122 SMALLINT
        l_name          LIKE type_file.chr20,         #No.FUN-680122 VARCHAR(20)               # External(Disk) file name
        l_za05          LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(40)               #
        l_ccg RECORD LIKE ccg_file.*,
        sr RECORD
           ima02 LIKE ima_file.ima02,
           ima25 LIKE ima_file.ima25
           END RECORD
#NO.FUN-830149----START---
DEFINE  l_avg       LIKE ccg_file.ccg12     
DEFINE  l_ima02     LIKE ima_file.ima02
DEFINE  l_ima021    LIKE ima_file.ima021
    CALL cl_del_data(l_table)
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'axct400' 
#NO.FUN-830149----END----
#   IF g_wc IS NULL THEN
#      CALL cl_err('','9057',0) RETURN END IF
#       CALL cl_err('',-400,0)
#       RETURN
#   END IF
    #改成印當下的那一筆資料內容
    IF g_wc IS NULL THEN
       IF cl_null(g_ccg.ccg01) THEN
          CALL cl_err('','9057',0) RETURN
       ELSE
          LET g_wc=" ccg01='",g_ccg.ccg01,"'"
       END IF
       IF NOT cl_null(g_ccg.ccg02) THEN
          LET g_wc=g_wc," and ccg02=",g_ccg.ccg02
       END IF
       IF NOT cl_null(g_ccg.ccg03) THEN
          LET g_wc=g_wc," and ccg03=",g_ccg.ccg03
       END IF
       IF NOT cl_null(g_ccg.ccg04) THEN
          LET g_wc=g_wc," and ccg04='",g_ccg.ccg04,"'"
       END IF
#No.FUN-7C0101-------------BEGIN-----------------
       IF NOT cl_null(g_ccg.ccg06) THEN
          LET g_wc=g_wc," and ccg06=",g_ccg.ccg06
       END IF
       IF NOT cl_null(g_ccg.ccg07) THEN
          LET g_wc=g_wc," and ccg07=",g_ccg.ccg07
       END IF
#No.FUN-7C0101--------------END------------------ 
    END IF
    CALL cl_wait()
#   LET l_name = 'axct400.out'
#    CALL cl_outnam('axct400') RETURNING l_name             #NO.FUN-830149
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT ccg_file.*, ima02,ima25 FROM ccg_file LEFT OUTER JOIN ima_file ON ccg04=ima_file.ima01 ",
              " WHERE ",g_wc CLIPPED
    PREPARE t400_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE t400_co CURSOR FOR t400_p1
 
#    START REPORT t400_rep TO l_name                        #NO.FUN-830149
 
    FOREACH t400_co INTO l_ccg.*, sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)   
            EXIT FOREACH
            END IF
#        OUTPUT TO REPORT t400_rep(l_ccg.*, sr.*)           #NO.FUN-830149
#NO.FUN-830094------START--
            IF l_ccg.ccg11 = 0 THEN 
                 LET l_avg = 0
            ELSE LET l_avg = l_ccg.ccg12/l_ccg.ccg11 
            END IF
            SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file 
                WHERE ima01=l_ccg.ccg04
            IF SQLCA.sqlcode THEN 
                LET l_ima02 = NULL 
                LET l_ima021 = NULL 
            END IF
            EXECUTE insert_prep USING 
              l_ccg.ccg01,l_ccg.ccg02,l_ccg.ccg03,l_ccg.ccg04,l_ccg.ccg11,
              l_ccg.ccg12,sr.ima02,sr.ima25,l_ima02,l_ima021,l_avg
#NO.FUN-830094------END-----
    END FOREACH
 
#    FINISH REPORT t400_rep                                 #NO.FUN-830149
#NO.FUN-830149--------start------------
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(g_wc,'ccg04,ccg01,ccg02,ccg03,ccg20,ccg11,ccg12a,
                             ccg12b,ccg12c,ccg12d,ccg12e,ccg12,ccg21,
                             ccg22a,ccg22b,ccg22c,ccg22d,ccg22e,ccg22,ccg23a,
                             ccg23b,ccg23c,ccg23d,ccg23e,ccg23,ccg31,ccg32a,
                             ccg32b,ccg32c,ccg32d,ccg32e,ccg32,ccg42a,ccg42b,
                             ccg42c,ccg42d,ccg42e,ccg42,ccg91,ccg92a,ccg92b,
                             ccg92c,ccg92d,ccg92e,ccg92,ccguser,ccgdate')
           RETURNING g_wc
     END IF
     LET g_str = g_wc         
     CALL cl_prt_cs3('axct400','axct400',g_sql,g_str)                      
#NO.FUN-7830149--------end------------
    CLOSE t400_co
    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)                      #NO.FUN-830149
END FUNCTION
#NO.FUN-830149---START---MARK---
#REPORT t400_rep(l_ccg, sr)
#    DEFINE
#        l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680122CHAR(01)
#        l_ccg RECORD LIKE ccg_file.*,
#        l_avg LIKE ccg_file.ccg12,     
#        l_ima02 LIKE ima_file.ima02,
#        l_ima021 LIKE ima_file.ima021,
#        sr RECORD
#           ima02 LIKE ima_file.ima02,
#           ima25 LIKE ima_file.ima25
#           END RECORD
#
#   OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#
#    ORDER BY l_ccg.ccg01,l_ccg.ccg02,l_ccg.ccg03
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED    #No.TQC-6A0078
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<','/pageno'
#            PRINT g_head CLIPPED,pageno_total
#            PRINT 
#            PRINT g_dash[1,g_len]   #No.TQC-6A0078
#            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#                  g_x[36],g_x[37],g_x[38],g_x[39]
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#        ON EVERY ROW
#            IF l_ccg.ccg11 = 0 THEN 
#                 LET l_avg = 0
#            ELSE LET l_avg = l_ccg.ccg12/l_ccg.ccg11 
#            END IF
#            SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file 
#                WHERE ima01=l_ccg.ccg04
#            IF SQLCA.sqlcode THEN 
#                LET l_ima02 = NULL 
#                LET l_ima021 = NULL 
#            END IF
#
#            PRINT COLUMN g_c[31],l_ccg.ccg04,
#                  COLUMN g_c[32],l_ima02,
#                  COLUMN g_c[33],l_ima021,
#                  COLUMN g_c[34],sr.ima25,
#                  COLUMN g_c[35],l_ccg.ccg02 USING '####',
#                  COLUMN g_c[36],l_ccg.ccg03 USING '##',
#                  COLUMN g_c[37],cl_numfor(l_ccg.ccg11,37,2),
#                  COLUMN g_c[38],cl_numfor(l_ccg.ccg12,38,2),
#                  COLUMN g_c[39],cl_numfor(l_avg,39,2)
##           PRINT sr.ima02
#        ON LAST ROW
#            PRINT
#            PRINT COLUMN g_c[35],g_x[9] CLIPPED,
#                  COLUMN g_c[38],cl_numfor(SUM(l_ccg.ccg12),38,2)
#            PRINT g_dash[1,g_len]   #No.TQC-6A0078
#            LET l_trailer_sw = 'n'
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED   #o.TQC-6A0078
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]   #No.TQC-6A0078
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED  #No.TQC-6A0078
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#NO.FUN-830149----END---MARK----
FUNCTION t400_set_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
  IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("ccg01,ccg02,ccg03,ccg06,ccg07",TRUE)  #No.FUN-7C0101 add ccg06,ccg07
  END IF
END FUNCTION
 
FUNCTION t400_set_no_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
  IF p_cmd = 'u' AND g_chkey MATCHES '[Nn]' AND
     (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("ccg01,ccg02,ccg03,ccg06,ccg07",FALSE) #No.FUN-7C0101 add ccg06,ccg07
  END IF
  #FUN-910073--BENGIN--                                                                                                             
  IF p_cmd = 'u' AND g_chkey MATCHES '[Yy]' AND                                                                                     
     (NOT g_before_input_done) THEN                                                                                                 
     IF g_ccg.ccg06 MATCHES'[12]' THEN                                                                                              
        CALL cl_set_comp_entry("ccg07",FALSE)                                                                                       
     ELSE                                                                                                                           
        CALL cl_set_comp_entry("ccg07",TRUE)                                                                                        
     END IF                                                                                                                         
  END IF                                                                                                                            
  #FUN-910073--END-- 
END FUNCTION
 
