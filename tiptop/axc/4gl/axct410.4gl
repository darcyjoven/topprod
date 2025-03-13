# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: axct410.4gl
# Descriptions...: 每月工單元件在製成本維護作業
# Date & Author..: 96/01/31 By Roger
# Modify.........: No.FUN-4C0005 04/12/02 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.FUN-4C0099 05/01/11 By kim 報表轉XML功能
# Modify.........: No.MOD-530850 05/03/31 By Will 增加料件的開窗
# Modify.........: No.FUN-550025 05/05/16 By vivien 單據編號格式放大 
# Modify.........: No.FUN-580083 05/08/29 By Rosayu 單頭加秀該工的"重工否" sfb99值,以供查成本時判斷是否忘了設重工
# Modify.........: No.TQC-620151 06/02/27 By Sarah 將_cs()段裡,抓sfb_file的部份改成OUTER,取筆數的部份,不抓sfb_file
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-660197 06/06/29 By Sarah 增加欄位cch311報廢量
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換  
# Modify.........: No.FUN-6B0079 06/12/15 By jamie 1.FUNCTION _q() 清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0146 06/10/27 By bnlent l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0101 08/01/16 By Cockroach 成本改善 增加cch06(成本計算類別),cch07(類別編號)和各種制費
# Modify.........: No.FUN-830140 08/03/28 By shiwuying axct400 按元件單身(call axct410)時出現 -201 error
# Modify.........: No.FUN-840202 08/05/07 By TSD.lucasyeh 自定欄位功能修改
# Modify.........: No.FUN-910073 09/02/02 By jan 成本計算類別為"1or2"時,類別編號應noentry且自動給' '
# Modify.........: No.FUN-980009 09/08/18 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.CHI-980066 09/08/25 By mike 用單頭的工單號碼與元件編號去select sfa的相關欄位display到畫面上對應的欄位         
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-970003 09/07/01 By jan 批次成本修改
# Modify.........: No.TQC-9C0025 09/12/03 By Carrier select和fetch into的顺序不符
# Modify.........: No.FUN-A50075 10/05/24 By lutingting GP5.2 AXC模組TABLE重新分類,相關INSERT語法修改
# Modify.........: No.FUN-A70136 10/07/29 By destiny 平行工艺
# Modify.........: No.FUN-AA0059 10/10/59 By vealxu  全系統料號開窗及判斷控卡原則修改
# Modify.........: No.CHI-BC0001 11/12/01 By ck2yuan 去除更改功能
# Modify.........: No:FUN-BC0062 12/02/20 By lilingyu 成本計算類型(axcs010)不可選擇【6.移動加權平均成本】
# Modify.........: No.FUN-C30190 12/03/23 By chenjing 將原報表轉成CR輸出
# Modify.........: No.MOD-C90018 12/09/21 By Elise ima57,ima57b欄位改show ccc04
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_argv1             LIKE type_file.chr20,         #No.FUN-680122 VARCHAR(16)      #No.FUN-550025
    g_argv2             LIKE type_file.num5,          #No.FUN-680122 SMALLINT
    g_argv3             LIKE type_file.num5,          #No.FUN-680122 SMALLINT
    g_argv4             LIKE cch_file.cch06,     #FUN-7C0101 ADD 08/03/13 BY Cockroach
#   g_argv5             LIKE cch_file.cch07,     #FUN-7C0101 ADD 08/03/13 BY Cockroach	#TQC-970003 mark
    g_sfb38             LIKE sfb_file.sfb38,
    g_sfb99             LIKE sfb_file.sfb99,  #FUN-580083 add
    g_cch               RECORD LIKE cch_file.*,
    g_cch_t             RECORD LIKE cch_file.*,
    g_cch01_t           LIKE cch_file.cch01,
    g_cch02_t           LIKE cch_file.cch02,
    g_cch03_t           LIKE cch_file.cch03,
    g_cch04_t           LIKE cch_file.cch04,
    g_cch06_t           LIKE cch_file.cch06,     #FUN-7C0101 ADD                                                                                   
    g_cch07_t           LIKE cch_file.cch07,     #FUN-7C0101 ADD            
     g_wc,g_sql          string,  #No.FUN-580092 HCN
    g_ima               RECORD LIKE ima_file.*,
    g_ccg               RECORD LIKE ccg_file.*
 
DEFINE   g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680122 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE   g_msg           LIKE ze_file.ze03       #No.FUN-680122CHAR(72)
DEFINE   g_before_input_done LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680122 SMALLINT
#FUN-C30190--add--start--
DEFINE  g_sql1    STRING
DEFINE  g_str     STRING
DEFINE  l_table   STRING
#FUN-C30190--add--end--

MAIN
#     DEFINE    l_time LIKE type_file.chr8            #No.FUN-6A0146
DEFINE    p_row,p_col   LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
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
 
#FUN-C30190--add--start--
   LET g_sql1 = "ima25.ima_file.ima25,      cch01.cch_file.cch01,",
                "cch04.cch_file.cch04,      l_ima02.ima_file.ima02,",
                "l_ima021.ima_file.ima021,  cch02.cch_file.cch02,",
                "cch03.cch_file.cch03,      cch11.cch_file.cch11,",
                "cch12.cch_file.cch12"
   LET l_table = cl_prt_temptable('axct410',g_sql1) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql1 = "INSERT INTO ",g_cr_db_str CLIPPED, l_table CLIPPED,
                " VALUES (?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql1
   IF STATUS THEN
      CALL cl_err("insert_prep:",status,1)
   END IF
#FUN-C30190--add--end--

 
    LET g_argv1 =ARG_VAL(1)
    LET g_argv2 =ARG_VAL(2)
    LET g_argv3 =ARG_VAL(3)
    LET g_argv4 =ARG_VAL(4)                #FUN-7C0101 ADD 
#   LET g_argv5 =ARG_VAL(5)                #FUN-7C0101 ADD     #TQC-970003 mark 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
    INITIALIZE g_cch.* TO NULL
    INITIALIZE g_cch_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM cch_file WHERE cch01 = ? AND cch02 = ? AND cch03 = ? AND cch04 = ? AND cch06 = ? AND cch07 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t410_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
    LET p_row = 2 LET p_col = 2
    OPEN WINDOW t410_w AT p_row,p_col
        WITH FORM "axc/42f/axct410" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
 
    IF NOT cl_null(g_argv1) THEN CALL t410_q() END IF
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL t410_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW t410_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
FUNCTION t410_cs()
DEFINE l_cch06 LIKE cch_file.cch06  #No.FUN-7C0101
    CLEAR FORM
    IF NOT cl_null(g_argv1) THEN
       LET g_wc = " cch01='", g_argv1, "' AND ",
                  " cch02=", g_argv2, " AND cch03=", g_argv3,
#                  " AND cch06=", g_argv4, " AND cch07=", g_argv5 #FUN-7C0101 ADD 08/03/13 BY Cockroach  #No.FUN-830140
#                  " AND cch06='", g_argv4, "' AND cch07= '", g_argv5,"' " #No.FUN-830140    #No.TQC-970003 mark
                   " AND cch06='", g_argv4, "' "                           #No.TQC-970003 
                 
    ELSE
   INITIALIZE g_cch.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
          ccg04, cch01, cch02, cch03,
          cch06, cch07,                           #FUN-7C0101 ADD
          ccg12, ccg22, ccg32, ccg42, ccg92,
          cch04, cch05,
          cch11, cch12a, cch12b, cch12c, cch12d, cch12e, 
          cch12f,cch12g, cch12h, cch12,    #FUN-7C0101 ADD cch12f,cch12g,cch12h 
          cch21, cch22a, cch22b, cch22c, cch22d, cch22e, 
          cch22f,cch22g, cch22h, cch22,    #FUN-7C0101 ADD cch22f,cch22g,cch22h
          cch31, cch311, cch32a, cch32b, cch32c, cch32d, cch32e,   #FUN-660197 add cch311
          cch32f,cch32g, cch32h, cch32,    #FUN-7C0101 ADD cch32f,cch32g,cch32h
          cch41, cch42a, cch42b, cch42c, cch42d, cch42e,
          cch42f,cch42g, cch42h, cch42,    #FUN-7C0101 ADD cch42f,cch42g,cch42h
          cch91, cch92a, cch92b, cch92c, cch92d, cch92e, #FUN-580083  #cch92,sfb99 #FUN-580083
          cch92f,cch92g, cch92h, cch92, sfb99, #FUN-7C0101 ADD cch92f,cch92g,cch92h #FUN-580083
        #FUN-840202   ---start---
          cchud01,cchud02,cchud03,cchud04,cchud05,cchud06,cchud07,cchud08,
          cchud09,cchud10,cchud11,cchud12,cchud13,cchud14,cchud15
        #FUN-840202    ----end----
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
      #No.FUN-7C0101--start--
        AFTER FIELD cch06
              LET l_cch06 = get_fldbuf(cch06)
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
 
          WHEN INFIELD(cch04)                                                   
            CALL cl_init_qry_var()                                              
            LET g_qryparam.form = "q_bmb203"                                       
            LET g_qryparam.state = "c"                                          
            LET g_qryparam.default1 = g_cch.cch04                               
            CALL cl_create_qry() RETURNING g_qryparam.multiret                  
            DISPLAY g_qryparam.multiret TO cch04                                
            NEXT FIELD cch04
             
          #No.FUN-7C0101--start--                                           
              WHEN INFIELD(cch07)                                               
                 IF l_cch06 MATCHES '[45]' THEN                             
                    CALL cl_init_qry_var()       
                    LET g_qryparam.state= "c"                                
                 CASE l_cch06                                               
                    WHEN '4'                                                    
                      LET g_qryparam.form = "q_pja"                             
                    WHEN '5'                                                    
                      LET g_qryparam.form = "q_gem4"                            
                    OTHERWISE EXIT CASE                                         
                 END CASE                                                       
                 CALL cl_create_qry() RETURNING g_qryparam.multiret                     
                 DISPLAY  g_qryparam.multiret TO cch07                                   
                 NEXT FIELD cch07                                               
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
  # LET g_sql="SELECT cch01,cch02,cch03,cch04,cch06,cch07,sfb99", #FUN-580083 #FUN-7C0101 ADD cch06,cch07  #No.TQC-9C0025
    LET g_sql="SELECT cch01,cch06,cch07,cch02,cch03,cch04,sfb99", #FUN-580083 #FUN-7C0101 ADD cch06,cch07  #No.TQC-9C0025
              "  FROM cch_file LEFT OUTER JOIN sfb_file ON cch01=sfb_file.sfb01,ccg_file", #FUN-580083   #TQC-620151
              " WHERE ",g_wc CLIPPED,
              "   AND cch01=ccg01 AND cch02=ccg02 AND cch03=ccg03",
#             "   AND cch06=ccg06 AND cch07=ccg07",   #FUN-7C0101 ADD  #No.TQC-970003
              "   AND cch06=ccg06                ",   #FUN-7C0101 ADD  #No.TQC-970003
              "   AND cch01=sfb_file.sfb01", #FUN-580083   #TQC-620151
              " ORDER BY ccg04,cch01,cch02,cch03,cch06,cch07,cch04"  #FUN-7C0101 add cch06,cch07
    DISPLAY "g_sql=",g_sql 
    PREPARE t410_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t410_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t410_prepare
   #start TQC-620151
   #LET g_sql=
   #    "SELECT COUNT(*) FROM cch_file,ccg_file,sfb_file WHERE ",g_wc CLIPPED, #FUN-580083
   #    "   AND cch01=ccg01 AND cch02=ccg02 AND cch03=ccg03 AND cch01=sfb01"  #FUN-580083
    LET g_sql=
        "SELECT COUNT(*) FROM cch_file,ccg_file WHERE ",g_wc CLIPPED, #FUN-580083
        "   AND cch01=ccg01 AND cch02=ccg02 AND cch03=ccg03 ",  #FUN-580083
       #"   AND cch06=ccg06 AND cch07=ccg07"   #FUN-7C0101   #No.TQC-970003
        "   AND cch06=ccg06                "   #FUN-7C0101   #No.TQC-970003
   #end TQC-620151
    PREPARE t410_precount FROM g_sql
    DECLARE t410_count CURSOR FOR t410_precount
END FUNCTION
 
FUNCTION t410_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert 
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL t410_a() 
            END IF
        ON ACTION query 
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL t410_q() 
            END IF
        ON ACTION next 
            CALL t410_fetch('N') 
        ON ACTION previous 
            CALL t410_fetch('P')
      #----CHI-BC0001 start -----
      #  ON ACTION modify 
      #      LET g_action_choice="modify"
      #      IF cl_chk_act_auth() THEN
      #         CALL t410_u() 
      #      END IF
      #----CHI-BC0001 end ----- 
#       ON ACTION 累計查詢 
        ON ACTION query_accumulated 
            LET g_msg="axcq430 ",g_cch.cch01," ",g_cch.cch02," ",g_cch.cch03,
                      " ",g_cch.cch06                  #TQC-970003
#                     " ",g_cch.cch06," ",g_cch.cch07  #FUN-7C0101 #TQC-970003 mark 
            CALL cl_cmdrun(g_msg)
#       ON ACTION 製程下階查詢 
        ON ACTION query_rounting_level_detail 
            LET g_msg="axct460 ",g_cch.cch01," ",g_cch.cch02," ",g_cch.cch03,
                      " ",g_cch.cch06                  #No.TQC-970003
#                     " ",g_cch.cch06," ",g_cch.cch07  #FUN-7C0101 #No.TQC-970003 mark 
            #CALL cl_cmdrun(g_msg)      #FUN-660216 remark
            CALL cl_cmdrun_wait(g_msg)  #FUN-660216 add
       ON ACTION output 
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL t410_out()
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
            CALL t410_fetch('/')
        ON ACTION first
            CALL t410_fetch('F')
        ON ACTION last
            CALL t410_fetch('L')

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
  
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
        #No.FUN-6B0079-------add--------str----
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_cch.cch01 IS NOT NULL THEN
                  LET g_doc.column1 = "cch01"
                  LET g_doc.value1 = g_cch.cch01
                  CALL cl_doc()
               END IF
           END IF
        #No.FUN-6B0079-------add--------end----
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE t410_cs
END FUNCTION
 
 
FUNCTION g_cch_zero()
	LET g_cch.cch11=0
	LET g_cch.cch12=0
	LET g_cch.cch12a=0
	LET g_cch.cch12b=0
	LET g_cch.cch12c=0
	LET g_cch.cch12d=0
	LET g_cch.cch12e=0
        LET g_cch.cch12f=0     #FUN-7C0101 ADD                                                                                                          
        LET g_cch.cch12g=0     #FUN-7C0101 ADD
        LET g_cch.cch12h=0     #FUN-7C0101 ADD
	LET g_cch.cch21=0
	LET g_cch.cch22=0
	LET g_cch.cch22a=0
	LET g_cch.cch22b=0
	LET g_cch.cch22c=0
	LET g_cch.cch22d=0
        LET g_cch.cch22e=0 
	LET g_cch.cch22f=0    #FUN-7C0101 ADD
        LET g_cch.cch22g=0    #FUN-7C0101 ADD   
        LET g_cch.cch22h=0    #FUN-7C0101 ADD    
	LET g_cch.cch31=0
	LET g_cch.cch311=0   #FUN-660197 add
	LET g_cch.cch32=0
	LET g_cch.cch32a=0
	LET g_cch.cch32b=0
	LET g_cch.cch32c=0
	LET g_cch.cch32d=0
	LET g_cch.cch32e=0
        LET g_cch.cch32f=0     #FUN-7C0101 ADD
        LET g_cch.cch32g=0     #FUN-7C0101 ADD  
        LET g_cch.cch32h=0     #FUN-7C0101 ADD  
	LET g_cch.cch41=0
	LET g_cch.cch42=0
	LET g_cch.cch42a=0
	LET g_cch.cch42b=0
	LET g_cch.cch42c=0
	LET g_cch.cch42d=0
	LET g_cch.cch42e=0
        LET g_cch.cch42f=0     #FUN-7C0101 ADD
        LET g_cch.cch42g=0     #FUN-7C0101 ADD  
        LET g_cch.cch42h=0     #FUN-7C0101 ADD  
	LET g_cch.cch91=0
	LET g_cch.cch92=0
	LET g_cch.cch92a=0
	LET g_cch.cch92b=0
	LET g_cch.cch92c=0
	LET g_cch.cch92d=0
	LET g_cch.cch92e=0
        LET g_cch.cch92f=0     #FUN-7C0101 ADD
        LET g_cch.cch92g=0     #FUN-7C0101 ADD  
        LET g_cch.cch92h=0     #FUN-7C0101 ADD  
END FUNCTION
 
FUNCTION t410_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_cch.* LIKE cch_file.*

#FUN-BC0062 --begin--
       IF g_ccz.ccz28 = '6' THEN
          CALL cl_err('','axc-026',1)
          RETURN 
       END IF
#FUN-BC0062 --end--

    CALL g_cch_zero()
    LET g_cch.cch02=g_cch_t.cch02
    LET g_cch.cch03=g_cch_t.cch03
    LET g_cch01_t = NULL
    LET g_cch02_t = NULL
    LET g_cch03_t = NULL
    LET g_cch04_t = NULL
    LET g_cch06_t = g_ccz.ccz28   #FUN-7C0101 ADD
    LET g_cch07_t = ' '           #FUN-7C0101 ADD   
   #LET g_cch.cchplant= g_plant    #FUN-980009 add    #FUN-A50075
    LET g_cch.cchlegal= g_legal    #FUN-980009 add
    LET g_cch_t.*=g_cch.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_cch.cch07 = ' '      #FUN-7C0101 ADD 
        CALL t410_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_cch.cch01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        LET g_cch.cchoriu = g_user      #No.FUN-980030 10/01/04
        LET g_cch.cchorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO cch_file VALUES(g_cch.*)
        IF SQLCA.sqlcode THEN
#           CALL cl_err('ins cch:',SQLCA.sqlcode,0)   #No.FUN-660127
            CALL cl_err3("ins","cch_file",g_cch.cch01,g_cch.cch02,SQLCA.sqlcode,"","ins cch:",1)  #No.FUN-660127
            CONTINUE WHILE
        ELSE
            LET g_cch_t.* = g_cch.*                # 保存上筆資料
            SELECT cch01,cch02,cch03,cch04,cch06,cch07 INTO g_cch.cch01,g_cch.cch02,g_cch.cch03,g_cch.cch04,g_cch.cch06,g_cch.cch07 FROM cch_file
                WHERE cch01 = g_cch.cch01
                  AND cch02 = g_cch.cch02 
                  AND cch03 = g_cch.cch03
                  AND cch04 = g_cch.cch04
                  AND cch06 = g_cch.cch06    #FUN-7C0101 ADD
                  AND cch07 = g_cch.cch07    #FUN-7C0101 ADD    
        END IF
        CALL t410_b_tot('u')
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t410_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
        l_flag          LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
        l_n             LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
    INPUT BY NAME
        g_cch.cch01, g_cch.cch02, g_cch.cch03,g_cch.cch06,g_cch.cch07,  #FUN-7C0101 ADD cch06,cch07
        g_cch.cch04, g_cch.cch05,
        g_cch.cch11, g_cch.cch12a, g_cch.cch12b, g_cch.cch12c,
        g_cch.cch12d, g_cch.cch12e,
        g_cch.cch12f,g_cch.cch12g,g_cch.cch12h,                #FUN-7C0101 ADD
        g_cch.cch12,
        g_cch.cch21, g_cch.cch22a, g_cch.cch22b, g_cch.cch22c,
        g_cch.cch22d, g_cch.cch22e,
        g_cch.cch22f,g_cch.cch22g,g_cch.cch22h,                #FUN-7C0101 ADD       
        g_cch.cch22,
        g_cch.cch31, g_cch.cch311, g_cch.cch32a, g_cch.cch32b, g_cch.cch32c,   #FUN-660197 add cch311
        g_cch.cch32d, g_cch.cch32e,
        g_cch.cch32f,g_cch.cch32g,g_cch.cch32h,                #FUN-7C0101 ADD       
        g_cch.cch32,
        g_cch.cch41, g_cch.cch42a, g_cch.cch42b, g_cch.cch42c,
        g_cch.cch42d, g_cch.cch42e,
        g_cch.cch42f,g_cch.cch42g,g_cch.cch42h,                #FUN-7C0101 ADD       
        g_cch.cch42,
        g_cch.cch91, g_cch.cch92a, g_cch.cch92b, g_cch.cch92c,
        g_cch.cch92d, g_cch.cch92e,
        g_cch.cch92f,g_cch.cch92g,g_cch.cch92h,                #FUN-7C0101 ADD       
        g_cch.cch92,
      #FUN-840202     ---start---
        g_cch.cchud01,g_cch.cchud02,g_cch.cchud03,g_cch.cchud04,
        g_cch.cchud05,g_cch.cchud06,g_cch.cchud07,g_cch.cchud08,
        g_cch.cchud09,g_cch.cchud10,g_cch.cchud11,g_cch.cchud12,
        g_cch.cchud13,g_cch.cchud14,g_cch.cchud15
      #FUN-840202     ----end----
        WITHOUT DEFAULTS 
 
        BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL t410_set_entry(p_cmd)
          CALL t410_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
            #No.FUN-550025 --start--
           CALL cl_set_docno_format("cch01")
            #No.FUN-550025 ---end---
 
        AFTER FIELD cch01
          IF g_cch.cch01 IS NOT NULL THEN
            SELECT * INTO g_ccg.* FROM ccg_file
             WHERE ccg01=g_cch.cch01 AND ccg02=g_cch.cch02 AND ccg03=g_cch.cch03
              #AND ccg06=g_cch.cch06 AND ccg07=g_cch.cch07 #No.FUN-7C0101  #No.TQC-970003
               AND ccg06=g_cch.cch06                       #No.FUN-7C0101  #No.TQC-970003
            IF STATUS THEN
#              CALL cl_err('sel ccg:',STATUS,0)    #No.FUN-660127
               CALL cl_err3("sel","ccg_file",g_cch.cch01,g_cch.cch02,STATUS,"","sel ccg:",1)  #No.FUN-660127
               NEXT FIELD cch01
            END IF
            DISPLAY BY NAME g_ccg.ccg04
            INITIALIZE g_ima.* TO NULL
            SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_ccg.ccg04
            DISPLAY BY NAME g_ima.ima02,g_ima.ima25
            SELECT sfb38 INTO g_sfb38 FROM sfb_file
             WHERE sfb01=g_cch.cch01
            DISPLAY g_sfb38 TO sfb38
            #FUN-580083 add
            SELECT sfb99 INTO g_sfb99 FROM sfb_file WHERE sfb01=g_cch.cch01
            DISPLAY g_sfb99 TO sfb99
            #FUN-580083(end)
          END IF
 
        AFTER FIELD cch03
          IF g_cch.cch03 IS NOT NULL THEN
            SELECT ccg01 FROM ccg_file
                    WHERE ccg01 = g_cch.cch01 AND ccg02 = g_cch.cch02
                      AND ccg03 = g_cch.cch03 
            IF STATUS THEN
#              CALL cl_err('sel ccg:',STATUS,0)   #No.FUN-660127
               CALL cl_err3("sel","ccg_file",g_cch.cch01,g_cch.cch02,STATUS,"","sel ccg:",1)  #No.FUN-660127
               NEXT FIELD cch03 
            END IF
          END IF
#FUN-7C0101 --BEGIN--
        AFTER FIELD cch06
            IF g_cch.cch06 IS NOT NULL THEN
               IF g_cch.cch06 NOT  MATCHES '[12345]'  THEN
                  CALL cl_err(g_cch.cch06,'mfg0037',1)
                  NEXT FIELD  cch06
                END IF
               #FUN-910073--BEGIN--                                                                                                    
               IF g_cch.cch06 MATCHES'[12]' THEN                                                                                    
                  CALL cl_set_comp_entry("cch07",FALSE)                                                                             
                  LET g_cch.cch07 = ' '                                                                                             
               ELSE                                                                                                                 
                  CALL cl_set_comp_entry("cch07",TRUE)                                                                              
               END IF                                                                                                               
               #FUN-910073--END-- 
             END IF
        AFTER FIELD cch07
            IF g_cch.cch07 IS NULL THEN
               LET g_cch.cch07 = ' '
            END IF
#FUN-7C0101 --END--
 
        AFTER FIELD cch04
          IF g_cch.cch04 IS NOT NULL THEN 
           #FUN-AA0059 ------------------------add start----------------
            IF NOT s_chk_item_no(g_cch.cch04,'') THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD cch04
            END IF 
           #FUN-AA0059 ------------------------add end----------------------  
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND 
               (g_cch.cch01 != g_cch01_t OR g_cch.cch02 != g_cch02_t OR
                g_cch.cch03 != g_cch03_t OR g_cch.cch04 != g_cch04_t OR 
                g_cch.cch06 != g_cch06_t OR g_cch.cch07 != g_cch07_t)) THEN   #FUN-7C0101 ADD
                SELECT count(*) INTO l_n FROM cch_file
                    WHERE cch01 = g_cch.cch01 AND cch02 = g_cch.cch02
                      AND cch03 = g_cch.cch03 AND cch04 = g_cch.cch04
                      AND cch06 = g_cch.cch06 AND cch07 = g_cch.cch07         #FUN-7C0101 ADD
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err('count:',-239,0)
                    NEXT FIELD cch01
                END IF
            END IF
            SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_cch.cch04
            IF STATUS THEN
#              CALL cl_err('sel ccg:',STATUS,0)    #No.FUN-660127
               CALL cl_err3("sel","ima_file",g_cch.cch04,"",STATUS,"","sel ccg:",1)  #No.FUN-660127
               NEXT FIELD cch04
            END IF
            DISPLAY g_ima.ima02,g_ima.ima25 TO ima02b,ima25b
            LET g_cch.cch05 = g_ima.ima08
            DISPLAY BY NAME g_cch.cch05
          END IF 
          CALL t410_cch04() #CHI-980066 
        AFTER FIELD 
        cch11, cch12a, cch12b, cch12c, cch12d, cch12e, 
        cch12f,cch12g,cch12h,          #FUN-7C0101 ADD
        cch12,cch21, cch22a, cch22b, cch22c, cch22d, cch22e,
        cch22f,cch22g,cch22h,          #FUN-7C0101 ADD
        cch22,cch31, cch311, cch32a, cch32b, cch32c, cch32d, cch32e,   #FUN-660197 add cch311
        cch32f,cch32g,cch32h,          #FUN-7C0101 ADD
        cch32,cch41, cch42a, cch42b, cch42c, cch42d, cch42e,
        cch42f,cch42g,cch42h,          #FUN-7C0101 ADD
        cch42,cch91, cch92a, cch92b, cch92c, cch92d, cch92e, 
        cch92f,cch92g,cch92h,cch92     #FUN-7C0101 ADD cch92f-cch92h
            CALL t410_u_cost()
 
      #FUN-840202     ---start---
        AFTER FIELD cchud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cchud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cchud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cchud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cchud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cchud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cchud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cchud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cchud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cchud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cchud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cchud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cchud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cchud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cchud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
      #FUN-840202     ----end----
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
            LET l_flag='N'
            IF INT_FLAG THEN
                EXIT INPUT  
            END IF
            IF l_flag='Y' THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD cch01
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
 
   #FUN-7C0101 --BEGIN--                                                                                                            
            WHEN INFIELD(cch07)
                 IF g_cch.cch06 MATCHES '[45]' THEN
                    CALL cl_init_qry_var()                                                                                              
                    CASE g_cch.cch06
                        WHEN  '4'
                           LET g_qryparam.form = "q_pja"                                                                                         
                        WHEN  '5'                                                                                    
                           LET g_qryparam.form = "q_gem4"       
                        OTHERWISE EXIT CASE
                    END CASE                                                                           
                    LET g_qryparam.default1 = g_cch.cch07                                                                         
                    CALL cl_create_qry() RETURNING g_cch.cch07                       
                 ELSE 
                    LET g_cch.cch07 = ' '
                 END IF                                              
                    DISPLAY BY NAME g_cch.cch07                                                                                   
                    NEXT FIELD cch07               
   #FUN-7C0101 --END--            
                                                                          
          WHEN INFIELD(cch04)                                                   
            CALL cl_init_qry_var()                                              
            LET g_qryparam.form = "q_bmb203"                                      
            LET g_qryparam.default1 = g_cch.cch04                               
            CALL cl_create_qry() RETURNING g_cch.cch04                  
            DISPLAY g_cch.cch04 TO cch04                                
            NEXT FIELD cch04                                                    
         OTHERWISE                                                              
            EXIT CASE                                                           
       END CASE     
      #MOD-650015 --start
      #  ON ACTION CONTROLO                        # 沿用所有欄位
      #      IF INFIELD(cch01) THEN
      #          LET g_cch.* = g_cch_t.*
      #          DISPLAY BY NAME g_cch.* 
      #          NEXT FIELD cch01
      #      END IF
      #MOD-650015 --end
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
        ON KEY(F1) NEXT FIELD cch11
        ON KEY(F2) NEXT FIELD cch21
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
    
    END INPUT
END FUNCTION
 
FUNCTION t410_u_cost()
   #LET g_cch.cch91 =g_cch.cch11 +g_cch.cch21 +g_cch.cch31 +g_cch.cch41                 #FUN-660197 mark
    LET g_cch.cch91 =g_cch.cch11 +g_cch.cch21 +g_cch.cch31 +g_cch.cch311 +g_cch.cch41   #FUN-660197
    LET g_cch.cch92 =g_cch.cch12 +g_cch.cch22 +g_cch.cch32 +g_cch.cch42
    LET g_cch.cch92a=g_cch.cch12a+g_cch.cch22a+g_cch.cch32a+g_cch.cch42a
    LET g_cch.cch92b=g_cch.cch12b+g_cch.cch22b+g_cch.cch32b+g_cch.cch42b
    LET g_cch.cch92c=g_cch.cch12c+g_cch.cch22c+g_cch.cch32c+g_cch.cch42c
    LET g_cch.cch92d=g_cch.cch12d+g_cch.cch22d+g_cch.cch32d+g_cch.cch42d
    LET g_cch.cch92e=g_cch.cch12e+g_cch.cch22e+g_cch.cch32e+g_cch.cch42e
    LET g_cch.cch92f=g_cch.cch12f+g_cch.cch22f+g_cch.cch32f+g_cch.cch42f    #FUN-7C0101 ADD
    LET g_cch.cch92g=g_cch.cch12g+g_cch.cch22g+g_cch.cch32g+g_cch.cch42g    #FUN-7C0101 ADD 
    LET g_cch.cch92h=g_cch.cch12h+g_cch.cch22h+g_cch.cch32h+g_cch.cch42h    #FUN-7C0101 ADD
    LET g_cch.cch12=g_cch.cch12a+g_cch.cch12b+g_cch.cch12c+g_cch.cch12d
                   +g_cch.cch12e+g_cch.cch12f+g_cch.cch12g+g_cch.cch12h     #FUN-7C0101 ADD 12f-12h
    LET g_cch.cch22=g_cch.cch22a+g_cch.cch22b+g_cch.cch22c+g_cch.cch22d
                   +g_cch.cch22e+g_cch.cch22f+g_cch.cch22g+g_cch.cch22h     #FUN-7C0101 ADD 22f-22h 
    LET g_cch.cch32=g_cch.cch32a+g_cch.cch32b+g_cch.cch32c+g_cch.cch32d
                   +g_cch.cch32e+g_cch.cch32f+g_cch.cch32g+g_cch.cch32h     #FUN-7C0101 ADD 32f-32h 
    LET g_cch.cch42=g_cch.cch42a+g_cch.cch42b+g_cch.cch42c+g_cch.cch42d
                   +g_cch.cch42e+g_cch.cch42f+g_cch.cch42g+g_cch.cch42h     #FUN-7C0101 ADD 42f-42h 
    LET g_cch.cch92=g_cch.cch92a+g_cch.cch92b+g_cch.cch92c+g_cch.cch92d
                   +g_cch.cch92e+g_cch.cch92f+g_cch.cch92g+g_cch.cch92h     #FUN-7C0101 ADD 92f-92h 
    CALL t410_show_2()
END FUNCTION
 
FUNCTION t410_b_tot(p_cmd)
 DEFINE p_cmd		LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 DEFINE mccg		RECORD LIKE ccg_file.*
 
 SELECT * INTO mccg.* FROM ccg_file
       WHERE ccg01=g_cch.cch01 AND ccg02=g_cch.cch02 AND ccg03=g_cch.cch03 
                              #AND ccg06=g_cch.cch06 AND ccg07=g_cch.cch07   #No.FUN-7C0101  #No.TQC-970003
                               AND ccg06=g_cch.cch06                         #No.FUN-7C0101  #No.TQC-970003
 
 SELECT SUM(cch12),SUM(cch12a),SUM(cch12b),SUM(cch12c),SUM(cch12d),SUM(cch12e),
        SUM(cch12f),SUM(cch12g),SUM(cch12h),     #FUN-7C0101 ADD
        SUM(cch22),SUM(cch22a),SUM(cch22b),SUM(cch22c),SUM(cch22d),SUM(cch22e),
        SUM(cch22f),SUM(cch22g),SUM(cch22h),     #FUN-7C0101 ADD     
        SUM(cch32),SUM(cch32a),SUM(cch32b),SUM(cch32c),SUM(cch32d),SUM(cch32e),
        SUM(cch32f),SUM(cch32g),SUM(cch32h),     #FUN-7C0101 ADD     
        SUM(cch42),SUM(cch42a),SUM(cch42b),SUM(cch42c),SUM(cch42d),SUM(cch42e),
        SUM(cch42f),SUM(cch42g),SUM(cch42h),     #FUN-7C0101 ADD     
        SUM(cch92),SUM(cch92a),SUM(cch92b),SUM(cch92c),SUM(cch92d),SUM(cch92e),
        SUM(cch92f),SUM(cch92g),SUM(cch92h)      #FUN-7C0101 ADD     
   INTO mccg.ccg12,mccg.ccg12a,mccg.ccg12b,mccg.ccg12c,mccg.ccg12d,mccg.ccg12e,
        mccg.ccg12f,mccg.ccg12g,mccg.ccg12h,     #FUN-7C0101 ADD  
        mccg.ccg22,mccg.ccg22a,mccg.ccg22b,mccg.ccg22c,mccg.ccg22d,mccg.ccg22e,
        mccg.ccg22f,mccg.ccg22g,mccg.ccg22h,     #FUN-7C0101 ADD    
        mccg.ccg32,mccg.ccg32a,mccg.ccg32b,mccg.ccg32c,mccg.ccg32d,mccg.ccg32e,
        mccg.ccg32f,mccg.ccg32g,mccg.ccg32h,     #FUN-7C0101 ADD    
        mccg.ccg42,mccg.ccg42a,mccg.ccg42b,mccg.ccg42c,mccg.ccg42d,mccg.ccg42e,
        mccg.ccg42f,mccg.ccg42g,mccg.ccg42h,     #FUN-7C0101 ADD    
        mccg.ccg92,mccg.ccg92a,mccg.ccg92b,mccg.ccg92c,mccg.ccg92d,mccg.ccg92e,
        mccg.ccg92f,mccg.ccg92g,mccg.ccg92h     #FUN-7C0101 ADD    
   FROM cch_file 
  WHERE cch01=g_cch.cch01 AND cch02=g_cch.cch02 AND cch03=g_cch.cch03
                          AND cch06=g_cch.cch06 AND cch07=g_cch.cch07 #No.FUN-7C0101
 IF mccg.ccg12 IS NULL THEN 
    LET mccg.ccg12 = 0 LET mccg.ccg12a= 0 LET mccg.ccg12b= 0
    LET mccg.ccg12c= 0 LET mccg.ccg12d= 0 LET mccg.ccg12e= 0
    LET mccg.ccg12f= 0 LET mccg.ccg12g= 0 LET mccg.ccg12h= 0   #FUN-7C0101 ADD
    LET mccg.ccg22 = 0 LET mccg.ccg22a= 0 LET mccg.ccg22b= 0
    LET mccg.ccg22c= 0 LET mccg.ccg22d= 0 LET mccg.ccg22e= 0
    LET mccg.ccg22f= 0 LET mccg.ccg22g= 0 LET mccg.ccg22h= 0   #FUN-7C0101 ADD 
    LET mccg.ccg32 = 0 LET mccg.ccg32a= 0 LET mccg.ccg32b= 0
    LET mccg.ccg32c= 0 LET mccg.ccg32d= 0 LET mccg.ccg32e= 0
    LET mccg.ccg32f= 0 LET mccg.ccg32g= 0 LET mccg.ccg32h= 0   #FUN-7C0101 ADD 
    LET mccg.ccg42 = 0 LET mccg.ccg42a= 0 LET mccg.ccg42b= 0
    LET mccg.ccg42c= 0 LET mccg.ccg42d= 0 LET mccg.ccg42e= 0
    LET mccg.ccg42f= 0 LET mccg.ccg42g= 0 LET mccg.ccg42h= 0   #FUN-7C0101 ADD 
    LET mccg.ccg92 = 0 LET mccg.ccg92a= 0 LET mccg.ccg92b= 0
    LET mccg.ccg92c= 0 LET mccg.ccg92d= 0 LET mccg.ccg92e= 0
    LET mccg.ccg92f= 0 LET mccg.ccg92g= 0 LET mccg.ccg92h= 0   #FUN-7C0101 ADD 
 END IF
 
 SELECT SUM(cch22),SUM(cch22a),SUM(cch22b),SUM(cch22c),SUM(cch22d),SUM(cch22e),
        SUM(cch22f),SUM(cch22g),SUM(cch22h)     #FUN-7C0101 ADD 
   INTO mccg.ccg23,mccg.ccg23a,mccg.ccg23b,mccg.ccg23c,mccg.ccg23d,mccg.ccg23e,
        mccg.ccg23f,mccg.ccg23g,mccg.ccg23h     #FUN-7C0101 ADD 
     FROM cch_file 
  WHERE cch01=g_cch.cch01 AND cch02=g_cch.cch02 AND cch03=g_cch.cch03 AND
        cch06=g_cch.cch06 AND cch07=g_cch.cch07 AND cch05 IN ('M','R')  #No.FUN-7C0101
 IF mccg.ccg23 IS NULL THEN 
    LET mccg.ccg23 = 0 LET mccg.ccg23a= 0 LET mccg.ccg23b= 0
    LET mccg.ccg23c= 0 LET mccg.ccg23d= 0 LET mccg.ccg23e= 0
    LET mccg.ccg23f= 0 LET mccg.ccg23g= 0 LET mccg.ccg23h= 0   #FUN-7C0101 ADD   
 END IF
 LET mccg.ccg22 =mccg.ccg22 -mccg.ccg23
 LET mccg.ccg22a=mccg.ccg22a-mccg.ccg23a
 LET mccg.ccg22b=mccg.ccg22b-mccg.ccg23b
 LET mccg.ccg22c=mccg.ccg22c-mccg.ccg23c
 LET mccg.ccg22d=mccg.ccg22d-mccg.ccg23d
 LET mccg.ccg22e=mccg.ccg22e-mccg.ccg23e
 LET mccg.ccg22f=mccg.ccg22f-mccg.ccg23f    #FUN-7C0101 ADD
 LET mccg.ccg22g=mccg.ccg22g-mccg.ccg23g    #FUN-7C0101 ADD 
 LET mccg.ccg22h=mccg.ccg22h-mccg.ccg23h    #FUN-7C0101 ADD   
 DISPLAY BY NAME
         mccg.ccg12,mccg.ccg22,mccg.ccg23,mccg.ccg32,mccg.ccg42,mccg.ccg92
 UPDATE ccg_file SET ccg_file.* = mccg.*
        WHERE ccg01=g_cch.cch01 AND ccg02=g_cch.cch02 AND ccg03=g_cch.cch03
                               #AND ccg06=g_cch.cch06 AND ccg07=g_cch.cch07 #No.FUN-7C0101  #No.TQC-970003
                                AND ccg06=g_cch.cch06                       #No.FUN-7C0101  #No.TQC-970003
 IF STATUS THEN 
# CALL cl_err('upd ccg.*:',STATUS,1)       #No.FUN-660127
  CALL cl_err3("upd","ccg_file",g_cch.cch01,g_cch.cch02,STATUS,"","upd ccg.*:",1)  #No.FUN-660127
 RETURN END IF
END FUNCTION
 
FUNCTION t410_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_cch.* TO NULL              #NO.FUN-6B0079 add
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '  ' TO FORMONLY.cnt  
    CALL t410_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t410_count
    FETCH t410_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    OPEN t410_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('open t410_cs:',SQLCA.sqlcode,0)
        INITIALIZE g_cch.* TO NULL
    ELSE
        CALL t410_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t410_fetch(p_flcch)
    DEFINE
        p_flcch          LIKE type_file.chr1          #No.FUN-680122CHAR(01)
 
    CASE p_flcch
        WHEN 'N' FETCH NEXT     t410_cs INTO g_cch.cch01,g_cch.cch06,g_cch.cch07,g_cch.cch02,g_cch.cch03,g_cch.cch04
        WHEN 'P' FETCH PREVIOUS t410_cs INTO g_cch.cch01,g_cch.cch06,g_cch.cch07,g_cch.cch02,g_cch.cch03,g_cch.cch04
        WHEN 'F' FETCH FIRST    t410_cs INTO g_cch.cch01,g_cch.cch06,g_cch.cch07,g_cch.cch02,g_cch.cch03,g_cch.cch04
        WHEN 'L' FETCH LAST     t410_cs INTO g_cch.cch01,g_cch.cch06,g_cch.cch07,g_cch.cch02,g_cch.cch03,g_cch.cch04
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
            FETCH ABSOLUTE g_jump t410_cs INTO g_cch.cch01,g_cch.cch06,g_cch.cch07,g_cch.cch02,g_cch.cch03,g_cch.cch04
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cch.cch01,SQLCA.sqlcode,0)
        INITIALIZE g_cch.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flcch
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_cch.* FROM cch_file            # 重讀DB,因TEMP有不被更新特性
       WHERE cch01 = g_cch.cch01 AND cch02 = g_cch.cch02 AND cch03 = g_cch.cch03 AND cch04 = g_cch.cch04 AND cch06 = g_cch.cch06 AND cch07 = g_cch.cch07
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_cch.cch01,SQLCA.sqlcode,0)   #No.FUN-660127
        CALL cl_err3("sel","cch_file",g_cch.cch01,g_cch.cch02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
    ELSE
        CALL t410_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t410_show()
    DEFINE mccg	RECORD LIKE ccg_file.*
    DEFINE l_ima02,l_ima25	LIKE ima_file.ima02        #No.FUN-680122 VARCHAR(30)
    DEFINE l_ima57		LIKE ima_file.ima57        #No.FUN-680122 SMALLINT
    INITIALIZE mccg.* TO NULL
    SELECT * INTO mccg.* FROM ccg_file
          WHERE ccg01=g_cch.cch01 AND ccg02=g_cch.cch02 AND ccg03=g_cch.cch03
            #AND ccg06=g_cch.cch06 AND ccg07=g_cch.cch07  #FUN-7C0101 ADD  #No.TQC-970003
             AND ccg06=g_cch.cch06                        #FUN-7C0101 ADD  #No.TQC-970003
    DISPLAY BY NAME mccg.ccg04,
            mccg.ccg11,mccg.ccg21,           mccg.ccg31,           mccg.ccg91,
            mccg.ccg12,mccg.ccg22,mccg.ccg23,mccg.ccg32,mccg.ccg42,mccg.ccg92
    LET g_cch_t.* = g_cch.*
   
    LET l_ima02=NULL LET l_ima25=NULL
    LET l_ima57=0  #MOD-C90018 add
   #SELECT ima02,ima25,ima57 INTO l_ima02,l_ima25,l_ima57  #MOD-C90018 mark
    SELECT ima02,ima25 INTO l_ima02,l_ima25                #MOD-C90018
      FROM ima_file WHERE ima01 = mccg.ccg04
   #MOD-C90018----S---
    SELECT ccc04 INTO l_ima57
      FROM ccc_file
     WHERE ccc01 = mccg.ccg04
       AND ccc02 = g_cch.cch02
       AND ccc03 = g_cch.cch03
       AND ccc07 = g_cch.cch06
       AND ccc08 = g_cch.cch07
   #MOD-C90018----E---
    DISPLAY l_ima02,l_ima25,l_ima57 TO ima02,ima25,ima57
    LET l_ima02=NULL LET l_ima25=NULL
    LET l_ima57=0  #MOD-C90018 add
   #SELECT ima02,ima25,ima57 INTO l_ima02,l_ima25,l_ima57  #MOD-C90018 mark
    SELECT ima02,ima25 INTO l_ima02,l_ima25                #MOD-C90018
      FROM ima_file WHERE ima01=g_cch.cch04
   #MOD-C90018----S---
    SELECT ccc04 INTO l_ima57
      FROM ccc_file
     WHERE ccc01 = g_cch.cch04
       AND ccc02 = g_cch.cch02
       AND ccc03 = g_cch.cch03
       AND ccc07 = g_cch.cch06
       AND ccc08 = g_cch.cch07
   #MOD-C90018----E---
    DISPLAY l_ima02,l_ima25,l_ima57 TO ima02b,ima25b,ima57b
    CALL t410_cch04() #CHI-980066  
    SELECT sfb38 INTO g_sfb38 FROM sfb_file
     WHERE sfb01=g_cch.cch01
    DISPLAY g_sfb38 TO sfb38
    #FUN-580083 add
    SELECT sfb99 INTO g_sfb99 FROM sfb_file WHERE sfb01=g_cch.cch01
    DISPLAY g_sfb99 TO sfb99
    #FUN-580083(end)
    CALL t410_show_2()
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#CHI-980066   ---start                                                                                                              
FUNCTION t410_cch04()                                                                                                               
DEFINE l_sfa26  LIKE sfa_file.sfa26                                                                                                 
DEFINE l_sfa27  LIKE sfa_file.sfa27                                                                                                 
DEFINE l_sfa28  LIKE sfa_file.sfa28                                                                                                 
DEFINE l_sfa16  LIKE sfa_file.sfa16                                                                                                 
DEFINE l_sfa161 LIKE sfa_file.sfa161              
   #No.FUN-A70136--begin                                                                                  
   #SELECT sfa26,sfa27,sfa28,sfa16,sfa161                                                                                            
   #  INTO l_sfa26,l_sfa27,l_sfa28,l_sfa16,l_sfa161                                                                                  
   #  FROM sfa_file                                                                                                                  
   # WHERE sfa01=g_cch.cch01                                                                                                         
   #   AND sfa03=g_cch.cch04      
       
   DECLARE t410_sfa CURSOR FOR
    SELECT sfa26,sfa27,sfa28,sfa16,sfa161                                                                          
      FROM sfa_file                                                                                                                  
    WHERE sfa01=g_cch.cch01                                                                                                         
      AND sfa03=g_cch.cch04   
   FOREACH t410_sfa INTO l_sfa26,l_sfa27,l_sfa28,l_sfa16,l_sfa161 
      EXIT FOREACH 
   END FOREACH 
   #No.FUN-A70136--end                                                                                                           
   DISPLAY l_sfa26,l_sfa27,l_sfa28,l_sfa16,l_sfa161 TO sfa26,sfa27,sfa28,sfa16,sfa161                                               
END FUNCTION                                                                                                                        
#CHI-980066   ---end         
 
FUNCTION t410_show_2()
    DEFINE cch12u,cch22u,cch32u,cch42u,cch92u LIKE cch_file.cch12   #FUN-4C0005	
 
    DISPLAY BY NAME
        g_cch.cch01, g_cch.cch02, g_cch.cch03,
        g_cch.cch06,g_cch.cch07,    #FUN-7C0101 ADD 
        g_cch.cch04, g_cch.cch05,
        g_cch.cch11, g_cch.cch12a, g_cch.cch12b, g_cch.cch12c,
        g_cch.cch12d, g_cch.cch12e,
        g_cch.cch12f, g_cch.cch12g, g_cch.cch12h,  #FUN-7C0101 ADD 
        g_cch.cch12, 
        g_cch.cch21, g_cch.cch22a, g_cch.cch22b, g_cch.cch22c,
        g_cch.cch22d, g_cch.cch22e,
        g_cch.cch22f, g_cch.cch22g, g_cch.cch22h,  #FUN-7C0101 ADD
        g_cch.cch22,
        g_cch.cch31, g_cch.cch311, g_cch.cch32a, g_cch.cch32b, g_cch.cch32c,   #FUN-660197 add cch311
        g_cch.cch32d, g_cch.cch32e,
        g_cch.cch32f, g_cch.cch32g, g_cch.cch32h,  #FUN-7C0101 ADD
        g_cch.cch32,
        g_cch.cch41, g_cch.cch42a, g_cch.cch42b, g_cch.cch42c,
        g_cch.cch42d, g_cch.cch42e,
        g_cch.cch42f, g_cch.cch42g, g_cch.cch42h,  #FUN-7C0101 ADD   
        g_cch.cch42,
        g_cch.cch91, g_cch.cch92a, g_cch.cch92b, g_cch.cch92c,
        g_cch.cch92d, g_cch.cch92e,
        g_cch.cch92f, g_cch.cch92g, g_cch.cch92h,  #FUN-7C0101 ADD
        g_cch.cch92,
      #FUN-840202     ---start---
        g_cch.cchud01,g_cch.cchud02,g_cch.cchud03,g_cch.cchud04,
        g_cch.cchud05,g_cch.cchud06,g_cch.cchud07,g_cch.cchud08,
        g_cch.cchud09,g_cch.cchud10,g_cch.cchud11,g_cch.cchud12,
        g_cch.cchud13,g_cch.cchud14,g_cch.cchud15
      #FUN-840202     ----end----
 
    DISPLAY "g_cch.cch05=",g_cch.cch05
    LET cch12u=0 LET cch22u=0 LET cch32u=0 LET cch42u=0 LET cch92u=0
    IF g_cch.cch11 <> 0 THEN LET cch12u=g_cch.cch12/g_cch.cch11 END IF
    IF g_cch.cch21 <> 0 THEN LET cch22u=g_cch.cch22/g_cch.cch21 END IF
   #start FUN-660197 modify
   #加上報廢量cch311
   #IF g_cch.cch31 <> 0 THEN LET cch32u=g_cch.cch32/g_cch.cch31 END IF
    IF (g_cch.cch31+g_cch.cch311) <> 0 THEN LET cch32u=g_cch.cch32/(g_cch.cch31+g_cch.cch311) END IF
   #end FUN-660197 modify
    IF g_cch.cch41 <> 0 THEN LET cch42u=g_cch.cch42/g_cch.cch41 END IF
    IF g_cch.cch91 <> 0 THEN LET cch92u=g_cch.cch92/g_cch.cch91 END IF
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
    DISPLAY BY NAME cch12u,cch22u,cch32u,cch42u,cch92u
END FUNCTION
#----------------  CHI-BC0001 start----------------------- 
#FUNCTION t410_u()
#   IF g_cch.cch01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
#   MESSAGE ""
#   CALL cl_opmsg('u')
#   LET g_cch01_t = g_cch.cch01
#   LET g_cch02_t = g_cch.cch02
#   LET g_cch03_t = g_cch.cch03
#   LET g_cch04_t = g_cch.cch04
#   LET g_cch06_t = g_cch.cch06     #FUN-7C0101 ADD
#   LET g_cch07_t = g_cch.cch07     #FUN-7C0101 ADD
#   BEGIN WORK
#
#   OPEN t410_cl USING g_cch.cch01,g_cch.cch02,g_cch.cch03,g_cch.cch04,g_cch.cch06,g_cch.cch07
#   IF STATUS THEN
#      CALL cl_err("OPEN t410_cl:", STATUS, 1)
#      CLOSE t410_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
#   FETCH t410_cl INTO g_cch.*               # 對DB鎖定
#   IF SQLCA.sqlcode THEN
#       CALL cl_err('',SQLCA.sqlcode,0)
#       RETURN
#   END IF
#   CALL t410_show()                          # 顯示最新資料
#   WHILE TRUE
#       CALL t410_i("u")                      # 欄位更改
#       IF INT_FLAG THEN
#           LET INT_FLAG = 0
#           LET g_cch.*=g_cch_t.*
#           CALL t410_show()
#           CALL cl_err('',9001,0)
#           EXIT WHILE
#       END IF
#       UPDATE cch_file SET cch_file.* = g_cch.*    # 更新DB
#           WHERE cch01 = g_cch_t.cch01 AND cch02 = g_cch_t.cch02 AND cch03 = g_cch_t.cch03 AND cch04 = g_cch_t.cch04 AND cch06 = g_cch_t.cch06 AND cch07 = g_cch_t.cch07            # COLAUTH?
#        IF SQLCA.sqlcode THEN
##           CALL cl_err(g_cch.cch01,SQLCA.sqlcode,0)   #No.FUN-660127
#            CALL cl_err3("upd","cch_file",g_cch01_t,g_cch02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660127
#            CONTINUE WHILE
#        END IF
#        CALL t410_b_tot('u')
#        EXIT WHILE
#    END WHILE
#    CLOSE t410_cl
#    COMMIT WORK
#END FUNCTION
#----------------  CHI-BC0001 end----------------------- 
FUNCTION t410_out()
    DEFINE
        l_i             LIKE type_file.num5,          #No.FUN-680122 SMALLINT
        l_name          LIKE type_file.chr20,         #No.FUN-680122 VARCHAR(20)               # External(Disk) file name
        l_za05          LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(40)               #
        l_cch RECORD LIKE cch_file.*,
        sr RECORD
           ima02 LIKE ima_file.ima02,
           ima25 LIKE ima_file.ima25
           END RECORD
    DEFINE l_ima02      LIKE ima_file.ima02,         #FUN-C30190
           l_ima021     LIKE ima_file.ima021,        #FUN-C30190
           l_sql        STRING
    CALL cl_del_data(l_table)       #FUN-C30190--add--
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #FUN-C30190--add--

 
#   IF g_wc IS NULL THEN
#      CALL cl_err('','9057',0) RETURN END IF
#       CALL cl_err('',-400,0)
#       RETURN
#   END IF
    #改成印當下的那一筆資料內容
    IF g_wc IS NULL THEN
       IF cl_null(g_cch.cch01) THEN
          CALL cl_err('','9057',0) RETURN
       ELSE
          LET g_wc=" cch01='",g_cch.cch01,"'"
       END IF
       IF NOT cl_null(g_cch.cch02) THEN
          LET g_wc=g_wc," and cch02=",g_cch.cch02
       END IF
       IF NOT cl_null(g_cch.cch03) THEN
          LET g_wc=g_wc," and cch03=",g_cch.cch03
       END IF
       IF NOT cl_null(g_cch.cch06) THEN                                                                                             
          LET g_wc=g_wc," and cch06=",g_cch.cch06                                                                                   
       END IF                                 
       IF NOT cl_null(g_cch.cch07) THEN                                                                                             
          LET g_wc=g_wc," and cch07=",g_cch.cch07                                                                                   
       END IF                                 
    END IF
 
    CALL cl_wait()
    LET l_name = 'axct410.out'
#   CALL cl_outnam('axct410') RETURNING l_name         #FUN-C30190--mark              
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT cch_file.*, ima02,ima25 ",
              " FROM cch_file LEFT OUTER JOIN ima_file ON  cch04=ima_file.ima01, ccg_file ",
              " WHERE  ",g_wc CLIPPED,
              "   AND cch01=ccg01 AND cch02=ccg02 AND cch03=ccg03",
             #"   AND cch06=cch06 AND cch07=ccg07" #FUN-7C0101	 #TQC-970003
              "   AND cch06=ccg06 "  #TQC-970003 
 
    PREPARE t410_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE t410_co CURSOR FOR t410_p1
 
#   START REPORT t410_rep TO l_name                  #FUN-C30190--mark
 
    FOREACH t410_co INTO l_cch.*, sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)   
            EXIT FOREACH
            END IF
#       OUTPUT TO REPORT t410_rep(l_cch.*, sr.*)     #FUN-C30190--mark
 #FUN-C30190--add--start--
    SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
     WHERE ima01=l_cch.cch04
    IF SQLCA.sqlcode THEN
        LET l_ima02 = NULL
        LET l_ima021 = NULL
    END IF
    EXECUTE insert_prep USING sr.ima25,l_cch.cch01,l_cch.cch04,l_ima02,l_ima021,l_cch.cch02,l_cch.cch03,l_cch.cch11,l_cch.cch12
 #FUN-C30190--add--end--
    END FOREACH
 
 #  FINISH REPORT t410_rep      #FUN-C30190--mark
 
    CLOSE t410_co
    ERROR ""
 #  CALL cl_prt(l_name,' ','1',g_len)    #FUN-C30190-mark
#FUN-C30190--add--start--
    LET g_str = g_wc
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED, l_table CLIPPED," ORDER BY cch01,cch02,cch03"
    CALL cl_prt_cs3('axct410','axct410',l_sql,g_str)
#FUN-C30190--add--end--

 
END FUNCTION
#FUN-C30190--mark--start--
#REPORT t410_rep(l_cch, sr)
#   DEFINE
#       l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680122CHAR(01)
#       l_cch RECORD LIKE cch_file.*,
#       l_avg LIKE cch_file.cch12,
#       l_ima02 LIKE ima_file.ima02,
#       l_ima021 LIKE ima_file.ima021,
#       sr RECORD
#          ima02 LIKE ima_file.ima02,
#          ima25 LIKE ima_file.ima25
#          END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#
#   ORDER BY l_cch.cch01,l_cch.cch02,l_cch.cch03
#
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#           LET g_pageno=g_pageno+1
#           LET pageno_total=PAGENO USING '<<<','/pageno'
#           PRINT g_head CLIPPED,pageno_total
#           PRINT 
#           PRINT g_dash
#           PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#                 g_x[36],g_x[37],g_x[38],g_x[39]
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
#       ON EVERY ROW
#           IF l_cch.cch11 = 0 THEN 
#                LET l_avg = 0
#           ELSE LET l_avg = l_cch.cch12/l_cch.cch11
#           END IF
#           SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file 
#               WHERE ima01=l_cch.cch04
#           IF SQLCA.sqlcode THEN 
#               LET l_ima02 = NULL 
#               LET l_ima021 = NULL 
#           END IF
#           PRINT COLUMN g_c[31],l_cch.cch04,
#                 COLUMN g_c[32],l_ima02,
#                 COLUMN g_c[33],l_ima021,
#                 COLUMN g_c[34],sr.ima25,
#                 COLUMN g_c[35],l_cch.cch02 USING '#####',
#                 COLUMN g_c[36],l_cch.cch03 USING '###',
#                 COLUMN g_c[37],cl_numfor(l_cch.cch11,37,2),
#                 COLUMN g_c[38],cl_numfor(l_cch.cch12,38,2),
#                 COLUMN g_c[39],cl_numfor(l_avg,39,2)
#       ON LAST ROW
#           PRINT
#           PRINT COLUMN g_c[37],g_x[9] CLIPPED,
#                 COLUMN g_c[38],cl_numfor(SUM(l_cch.cch12),38,2)
#           PRINT g_dash
#           LET l_trailer_sw = 'n'
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[39], g_x[7] CLIPPED
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[39], g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
 
FUNCTION t410_set_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
  IF p_cmd = 'a' AND (NOT g_before_input_done) OR INFIELD(cch04) THEN
     CALL cl_set_comp_entry("cch01,cch02,cch03,cch04,cch06,cch07",TRUE)
  END IF
END FUNCTION
 
FUNCTION t410_set_no_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
  IF p_cmd = 'u' AND g_chkey MATCHES '[Nn]' AND
     (NOT g_before_input_done) OR INFIELD(cch04) THEN
     CALL cl_set_comp_entry("cch01,cch02,cch03,cch04,cch06,cch07",FALSE)
  END IF
  #FUN-910073--BENGIN--                                                                                                             
  IF p_cmd = 'u' AND g_chkey MATCHES '[Yy]' AND                                                                                     
     (NOT g_before_input_done) AND NOT INFIELD(cch04) THEN
     IF g_cch.cch06 MATCHES'[12]' THEN 
        CALL cl_set_comp_entry("cch07",FALSE)
     ELSE
        CALL cl_set_comp_entry("cch07",TRUE)
     END IF 
  END IF  
  #FUN-910073--END--
END FUNCTION
 
