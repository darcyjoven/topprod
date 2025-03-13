# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcq400.4gl
# Descriptions...: 成本項目成本分析查詢作業
# Date & Author..: 01/11/09 BY DS/P
# Modify.........: No.FUN-4B0015 04/11/09 By Pengu 新增Array轉Excel檔功能
# Modify.........: No.MOD-4C0005 04/12/02 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.FUN-4C0099 05/01/28 By kim 報表轉XML功能
# Modify.........: No.MOD-530170 05/03/21 By Carol 直接執行此程式時,用滑鼠無法打X離開
# Modify.........: No.MOD-530850 05/03/31 By Will 增加料件的開窗
# Modify.........: No.FUN-550025 05/05/16 By vivien 單據編號格式放大 
# Modify.........: No.TQC-5B0076 05/11/09 By Claire excel匯出失效
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680122 06/08/30 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.MOD-6B0031 06/11/07 By Claire 報表調整
# Modify.........: No.TQC-6B0002 06/11/21 By johnray 報表修改
# Modify.........: No.FUN-6A0092 06/11/23 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.MOD-720042 07/02/27 By TSD.hoho 報表改寫由Crystal Report產出
# Modify.........: No.TQC-6B0105 07/03/09 By Sarah 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
#                                            <代葉美英修改>
# Modify.........: No.FUN-710080 07/04/02 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0101 08/01/10 By ChenMoyan 新增ccg06和ccg07
# Modify.........: No.FUN-830032 08/03/14 By lutingting報表新增字段ccg06與ccg07
# Modify.........: No.FUN-8A0067 09/02/13 By lilingyu mark cl_outnam()
# Modify.........: No.CHI-940027 09/04/23 By ve007 制費分為5大類
# Modify.........: No.CHI-970021 09/08/21 By jan 成本分類欄位改成cai08
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-970003 09/12/01 By jan 批次成本改善
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
     tm  RECORD
        	wc  	LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(300)		# Head Where condition
        	wc2  	LIKE type_file.chr1000        #No.FUN-680122 VARCHAR(300) 		# Body Where condition
        END RECORD,
    g_ccg   RECORD
            ccg01   LIKE ccg_file.ccg01,  #工單編號 
            ccg02   LIKE ccg_file.ccg02,  #年
            ccg03   LIKE ccg_file.ccg03,  #月
            ccg04   LIKE ccg_file.ccg04   #主件料號
           ,ccg06   LIKE ccg_file.ccg06,  #No.FUN-7C0101
            ccg07   LIKE ccg_file.ccg07   #No.FUN-7C0101
        END RECORD,
    g_cai DYNAMIC ARRAY OF RECORD
            cai05   LIKE cai_file.cai05, #成本中心
            cai06   LIKE cai_file.cai06, #成本項目
            cab02   LIKE cab_file.cab02,
           #caa04_d LIKE cre_file.cre08, #No.FUN-680122 VARCHAR(8), #成本分類說明 #CHI-970021
            cai08   LIKE cai_file.cai08,   #CHI-970021 
            cai07   LIKE cai_file.cai07 
        END RECORD,
    g_argv1         LIKE ccg_file.ccg01, #工單
    g_argv2         LIKE ccg_file.ccg04, #主件
    g_argv3         LIKE ccg_file.ccg06, #FUN-7C0101                                                                                      
   #g_argv4         LIKE ccg_file.ccg07, #FUN-7C0101  #TQC-970003
    g_query_flag    LIKE type_file.num5,          #No.FUN-680122 SMALLINT, #第一次進入程式時即進入Query之後進入N.下筆料件
    g_cai_arrno     LIKE type_file.num5,          #No.FUN-680122 SMALLINT, #程式陣列的個數(Program array no)
    g_cai_sarrno    LIKE type_file.num5,          #No.FUN-680122 SMALLINT, #螢幕陣列的個數(Screen array no)
    g_cai_pageno    LIKE type_file.num5,          #No.FUN-680122 SMALLINT, #目前單身頁數
     g_wc,g_wc2,g_sql string, #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num10          #No.FUN-680122 INTEGER                #單身筆數
 
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680122 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000      #No.FUN-680122 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680122 INTEGER
 
DEFINE l_table   STRING   #Add MOD-720042 By TSD.hoho CR11 add
#DEFINE g_sql     STRING   #Add MOD-720042 By TSD.hoho CR11 add
DEFINE g_str     STRING   #Add MOD-720042 By TSD.hoho CR11 add
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0146
DEFINE l_sl          LIKE type_file.num5          #No.FUN-680122 SMALLINT
DEFINE p_row,p_col   LIKE type_file.num5             #No.FUN-680122 SMALLINT
 
 
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
    WHENEVER ERROR CONTINUE                #忽略一切錯誤
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AXC")) THEN
       EXIT PROGRAM
    END IF
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
         RETURNING g_time    #No.FUN-6A0146
 
    #----------------Add MOD-720042 By TSD.hoho CR11 add----------------(S)
    # CREATE TEMP TABLE
    LET g_sql = " ccg04.ccg_file.ccg04,", #主件料號
                " ima02.ima_file.ima02,", #品名
                " ima25.ima_file.ima25,", #庫存單位
                " ccg01.ccg_file.ccg01,", #工單編號
                " ccg02.ccg_file.ccg02,", #年
                " ccg03.ccg_file.ccg03,", #月份
                " ccg06.ccg_file.ccg06,", #成本計算類別 #FUN-830032
                " ccg07.ccg_file.ccg07,", #類別編號   #FUN-830032
                " cai05.cai_file.cai05,", #成本中心   
                " cai06.cai_file.cai06,", #成本項目
                " cab02.cab_file.cab02,", #成本項目名稱
                " caa04_d.cre_file.cre08,",
                " cai07.cai_file.cai07"   #本月投入金額 
    LET l_table = cl_prt_temptable('axcq400',g_sql) CLIPPED  #產生Temp Table
    IF l_table = -1 THEN EXIT PROGRAM END IF
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             #  " VALUES(?,?,?,?,?,?,?,?,?,?,?) "   #FUN-830032
                " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?) " #FUN-830032
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',STATUS,1) EXIT PROGRAM
    END IF
    #----------------Add MOD-720042 By TSD.hoho CR11 add----------------(E)
 
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
    LET g_argv2      = ARG_VAL(2)          #參數值(2) Part#
    LET g_argv3      = ARG_VAL(3)          #No.FUN-7C0101
   #LET g_argv4      = ARG_VAL(4)          #No.FUN-7C0101 #TQC-970003
    LET g_query_flag = 1
 
    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW q400_w AT p_row,p_col WITH FORM "axc/42f/axcq400" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
#    IF cl_chk_act_auth() THEN
#       CALL q400_q() #    END IF
IF NOT cl_null(g_argv1) THEN CALL q400_q() END IF
    CALL q400_menu()    #中文
    CLOSE WINDOW q400_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
         RETURNING g_time    #No.FUN-6A0146
END MAIN
 
#QBE 查詢資料
FUNCTION q400_cs()
   DEFINE   l_cnt LIKE type_file.num5           #No.FUN-680122 SMALLINT
   DEFINE   l_ccg06 LIKE ccg_file.ccg06         #No.FUN-7C0101
  #IF NOT cl_null(g_argv1) OR NOT cl_null(g_argv2)  THEN                                           #No.FUN-7C0101
  #IF NOT cl_null(g_argv1) OR NOT cl_null(g_argv2) OR NOT cl_null(g_argv3) OR NOT cl_null(g_argv4) THEN                #No.FUN-7C0101#TQC-970003
   IF NOT cl_null(g_argv1) OR NOT cl_null(g_argv2) OR NOT cl_null(g_argv3) THEN   #TQC-970003
  #    LET tm.wc = "ccg01 = '",g_argv1,"' AND ccg04='",g_argv2,"' "                                                    #No.FUN-7C0101 mark
  #    LET tm.wc = "ccg01 = '",g_argv1,"' AND ccg04='",g_argv2,"' AND ccg06='",g_argv3,"' AND ccg07 = '",g_argv4,"'"   #No.FUN-7C0101 #TQC-970003
       LET tm.wc = "ccg01 = '",g_argv1,"' AND ccg04='",g_argv2,"' AND ccg06='",g_argv3,"' "  #TQC-970003
       LET tm.wc2=" 1=1 "
   ELSE CLEAR FORM #清除畫面
   CALL g_cai.clear()
           CALL cl_opmsg('q')
           INITIALIZE tm.* TO NULL			# Default condition
           CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE g_ccg.* TO NULL    #No.FUN-750051
           CONSTRUCT BY NAME tm.wc ON ccg04,ccg01,ccg02,ccg03
                                     ,ccg06,ccg07   #No.FUN-7C0101
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
            LET g_qryparam.form = "q_ima"                                       
            LET g_qryparam.state = "c"                                          
            LET g_qryparam.default1 = g_ccg.ccg04                               
            CALL cl_create_qry() RETURNING g_qryparam.multiret                  
            DISPLAY g_qryparam.multiret TO ccg04                                
            NEXT FIELD ccg04      
#No.FUN-7C0101 --Begin    
           WHEN INFIELD(ccg07)
             CALL cl_init_qry_var()
             IF l_ccg06 MATCHES '[45]' THEN
               IF l_ccg06 = '4' THEN
                 LET g_qryparam.form = "q_pja"
               END IF
               IF l_ccg06 = '5' THEN
                 LET g_qryparam.form = "q_gem4"
               END IF
               LET g_qryparam.state = "c"
               LET g_qryparam.default1 = g_ccg.ccg07
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ccg07
               NEXT FIELD ccg07
            END IF
#No.FUN-7C0101 --End
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
           LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ccguser', 'ccggrup') #FUN-980030
           IF INT_FLAG THEN RETURN END IF
           CALL q400_b_askkey()
           IF INT_FLAG THEN RETURN END IF
   END IF
 
   MESSAGE ' WAIT ' 
  IF tm.wc2 = " 1=1" THEN
#  LET g_sql=" SELECT UNIQUE ccg01,ccg02,ccg03,ccg04 FROM ccg_file ",                      #No.FUN-7C0101
   LET g_sql=" SELECT UNIQUE ccg01,ccg02,ccg03,ccg04,ccg06,ccg07 FROM ccg_file ",          #No.FUN-7C0101
             " WHERE ",tm.wc CLIPPED
  ELSE
#  LET g_sql=" SELECT UNIQUE ccg01,ccg02,ccg03,ccg04 FROM ccg_file,cai_file ",             #No.FUN-7C0101
   LET g_sql=" SELECT UNIQUE ccg01,ccg02,ccg03,ccg04,ccg06,ccg07 FROM ccg_file,cai_file ", #No.FUN-7C0101
             " WHERE ccg01=cai01 AND ccg02=cai02 AND ccg03=cai03  AND ",tm.wc CLIPPED,
             " AND ",tm.wc2 CLIPPED	
  END IF
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND ccguser = '",g_user,"'"
   #   END IF
 
   PREPARE q400_prepare FROM g_sql
   DECLARE q400_cs                         #SCROLL CURSOR
           SCROLL CURSOR WITH HOLD FOR q400_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
  IF tm.wc2 = " 1=1 " THEN
#  LET g_sql=" SELECT UNIQUE ccg01,ccg02,ccg03,ccg04 FROM ccg_file ",                      #No.FUN-7C0101 
   LET g_sql=" SELECT UNIQUE ccg01,ccg02,ccg03,ccg04,ccg06,ccg07 FROM ccg_file ",          #No.FUN-7C0101
              " WHERE ",tm.wc CLIPPED
    
  ELSE
#  LET g_sql=" SELECT UNIQUE ccg01,ccg02,ccg03,ccg04 FROM ccg_file,cai_file ",             #No.FUN-7C0101
   LET g_sql=" SELECT UNIQUE ccg01,ccg02,ccg03,ccg04,ccg06,ccg07 FROM ccg_file,cai_file ", #No.FUN-7C0101 
              " WHERE ccg01 = cai01 AND ccg02=cai02 AND ccg03=cai03  ",  #MOD-6B0031 modify ccg02->ccg03=cai03
              "  AND ",tm.wc CLIPPED,
              " AND ",tm.wc2 CLIPPED
  END IF
   #資料權限的檢查
   IF g_priv2='4' THEN#只能使用自己的資料
      LET g_sql = g_sql clipped," AND ccguser = '",g_user,"'"
   END IF
   PREPARE q400_pp  FROM g_sql
   DECLARE q400_cnt   CURSOR FOR q400_pp
END FUNCTION
 
FUNCTION q400_b_askkey()
   CONSTRUCT tm.wc2 ON cai05,cai06,cai08,cai07  #CHI-970021 add cai08
                  FROM s_cai[1].cai05,s_cai[1].cai06,s_cai[1].cai08,s_cai[1].cai07 #CHI-970021
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
END FUNCTION
 
#中文的MENU
FUNCTION q400_menu()
 
   WHILE TRUE
      CALL q400_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q400_q()
            END IF
         WHEN "output"
            CALL q400_out()
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0015
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_cai),'','')
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q400_q() 
   DEFINE l_ccg01 LIKE ccg_file.ccg01 
   DEFINE l_ccg02 LIKE ccg_file.ccg02 
   DEFINE l_ccg03 LIKE ccg_file.ccg03 
   DEFINE l_ccg04 LIKE ccg_file.ccg04 
   DEFINE l_ccg06 LIKE ccg_file.ccg06       #No.FUN-7C0101
   DEFINE l_ccg07 LIKE ccg_file.ccg07       #No.FUN-7C0101
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt 
    CALL q400_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q400_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q400_cnt
       LET g_cnt=0 
       FOREACH q400_cnt INTO l_ccg01,l_ccg02,l_ccg03,l_ccg04 
                            ,l_ccg06,l_ccg07 #No.FUN-7C0101
         LET g_cnt=g_cnt+1 
       END FOREACH 
       DISPLAY g_cnt TO FORMONLY.cnt 
       LET g_row_count = g_cnt
       CALL q400_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
 
FUNCTION q400_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680122 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680122 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q400_cs INTO g_ccg.ccg01,g_ccg.ccg02,
                                             g_ccg.ccg03,g_ccg.ccg04
                                            ,g_ccg.ccg06,g_ccg.ccg07      #No.FUN-7C0101
        WHEN 'P' FETCH PREVIOUS q400_cs INTO g_ccg.ccg01,g_ccg.ccg02,
                                             g_ccg.ccg03,g_ccg.ccg04
                                            ,g_ccg.ccg06,g_ccg.ccg07      #No.FUN-7C0101
        WHEN 'F' FETCH FIRST    q400_cs INTO g_ccg.ccg01,g_ccg.ccg02,
                                             g_ccg.ccg03,g_ccg.ccg04
                                            ,g_ccg.ccg06,g_ccg.ccg07      #No.FUN-7C0101
        WHEN 'L' FETCH LAST     q400_cs INTO g_ccg.ccg01,g_ccg.ccg02,
                                             g_ccg.ccg03,g_ccg.ccg04
                                            ,g_ccg.ccg06,g_ccg.ccg07      #No.FUN-7C0101
        WHEN '/'
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
             PROMPT g_msg CLIPPED,': ' FOR l_abso
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
#                   CONTINUE PROMPT
 
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
            FETCH ABSOLUTE l_abso q400_cs INTO g_ccg.ccg01,g_ccg.ccg02,
                                               g_ccg.ccg03,g_ccg.ccg04
                                              ,g_ccg.ccg06,g_ccg.ccg07      #No.FUN-7C0101
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ccg.ccg01,SQLCA.sqlcode,0)
        INITIALIZE  g_ccg.* TO NULL          ##TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
	SELECT ccg01,ccg02,ccg03,ccg04 
              ,g_ccg.ccg06,g_ccg.ccg07          #No.FUN-7C0101
	  INTO g_ccg.*
	  FROM ccg_file
	 WHERE ccg01 = g_ccg.ccg01 AND ccg02=g_ccg.ccg02 
           AND ccg03 = g_ccg.ccg03 AND ccg04=g_ccg.ccg04
           AND ccg06 = g_ccg.ccg06 AND ccg07=g_ccg.ccg07                 #No.FUN-7C0101 
    IF SQLCA.sqlcode THEN
        LET g_msg=g_ccg.ccg01 CLIPPED,'+',g_ccg.ccg02,'+',
                  g_ccg.ccg03 CLIPPED,'+',g_ccg.ccg04 
                  ,'+',g_ccg.ccg06,'+',g_ccg.ccg07                       #No.FUN-7C0101
#        CALL cl_err(g_msg,SQLCA.sqlcode,0)     #No.FUN-660127
         CALL cl_err3("sel","ccg_file",g_msg,"",SQLCA.SQLCODE,"","",0)   #No.FUN-660127
        RETURN
    END IF
 
    CALL q400_show()
END FUNCTION
 
FUNCTION q400_show()
  DEFINE l_ima25 LIKE ima_file.ima25 
  DEFINE l_ima02 LIKE ima_file.ima02  
 
   DISPLAY BY NAME g_ccg.*   # 顯示單頭值
   SELECT ima02,ima25 INTO l_ima02,l_ima25 FROM ima_file 
    WHERE ima01=g_ccg.ccg04
   IF SQLCA.SQLCODE THEN LET l_ima02=' '  LET l_ima25=''END IF
   DISPLAY l_ima02 TO FORMONLY.ima02 
   DISPLAY l_ima25 TO FORMONLY.ima25 
   CALL q400_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q400_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000        #No.FUN-680122 VARCHAR(400)
 
   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF
   LET l_sql =
       #"SELECT cai05,cai06,cab02,'',cai07 ",    #CHI-970021
        "SELECT cai05,cai06,cab02,cai08,cai07 ", #CHI-970021
        "  FROM cai_file,cab_file ",
        " WHERE cai01 = '",g_ccg.ccg01,"'",
        "   AND cai02 = '",g_ccg.ccg02,"' ",
        "   AND cai03 = '",g_ccg.ccg03,"' ",
        "   AND cai04 = '",g_ccg.ccg04,"' ",
        "   AND cai06 = cab01 ", 
        "   AND ", tm.wc2 CLIPPED,
        " ORDER BY 1"
    PREPARE q400_pb FROM l_sql
    DECLARE q400_bcs                       #BODY CURSOR
        CURSOR WITH HOLD FOR q400_pb
    DISPLAY "l_sql=",l_sql
    FOR g_cnt = 1 TO g_cai.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_cai[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    FOREACH q400_bcs INTO g_cai[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
       #CALL q400_get_caa04_d(g_cai[g_cnt].cai05,g_cai[g_cnt].cai06) #CHI-970021
       #RETURNING g_cai[g_cnt].caa04_d   #CHI-970021
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2 
 
END FUNCTION
 
#CHI-970021--begin--mark--
#FUNCTION q400_get_caa04_d(p_cai05,p_cai06)
# DEFINE p_cai05 LIKE cai_file.cai05 
# DEFINE p_cai06 LIKE cai_file.cai06 
# DEFINE l_sql   LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(300)
# DEFINE l_caa04_d LIKE cre_file.cre08        #No.FUN-680122 VARCHAR(8)
# DEFINE l_caa04 LIKE caa_file.caa04  #成本分類(1.人工成本 2.製造費用)
  #
 
# LET l_caa04='' 
# LET l_caa04_d='' 
# #同一成本項目會屬於不同成本分類???
# #
# LET l_sql=''
# LET l_sql=" SELECT UNIQUE caa04 FROM caa_file  ",
#           "  WHERE caa01='",p_cai05,"' ", 
#           "    AND caa02='",p_cai06,"' " CLIPPED
# PREPARE q400_get_pre FROM l_sql 
# IF STATUS THEN ERROR "q400_get_pre" CLIPPED RETURN l_caa04_d END IF  
# DECLARE q400_get_cur CURSOR FOR q400_get_pre  
# IF STATUS THEN ERROR "q400_get_pre" CLIPPED RETURN l_caa04_d END IF  
# OPEN q400_get_cur 
# FETCH q400_get_cur INTO l_caa04 
# CLOSE q400_get_cur 
# CASE l_caa04 
##   WHEN '1'  LET l_caa04_d='人工成本'  
#   WHEN '1'  LET l_caa04_d=cl_getmsg('axc-281',g_lang) #No.CHI-940027
#   WHEN '2'  LET l_caa04_d=cl_getmsg('axc-287',g_lang)#製費1
# #NO.CHI-940027 --begin--
#   WHEN '3'  LET l_caa04_d=cl_getmsg('axc-288',g_lang)#製費2
#   WHEN '4'  LET l_caa04_d=cl_getmsg('axc-289',g_lang)#製費3
#   WHEN '5'  LET l_caa04_d=cl_getmsg('axc-290',g_lang)#製費4
#   WHEN '6'  LET l_caa04_d=cl_getmsg('axc-299',g_lang)#製費5
# #No.CHI-940027 --end--
# END CASE 
# RETURN l_caa04_d 
#END FUNCTION
#CHI-970021--end--
 
FUNCTION q400_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cai TO s_cai.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      #BEFORE ROW
      #   LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      #   LET l_sl = SCR_LINE()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first 
         CALL q400_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL q400_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump 
         CALL q400_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL q400_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last 
         CALL q400_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
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
 
 #MOD-530170
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
##
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
   
      ON ACTION exporttoexcel #FUN-4B0015
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY  #TQC-5B0076
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION q400_out()
  DEFINE l_sql  LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(500)
  DEFINE l_za05 LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(40)
  DEFINE l_name LIKE type_file.chr20         #No.FUN-680122 VARCHAR(20)     #No.FUN-550025
  DEFINE sr RECORD 
             ccg04  LIKE ccg_file.ccg04, #主件料號
             ima02  LIKE ima_file.ima02, #品名
             ima25  LIKE ima_file.ima25, #庫存單位
             ccg01  LIKE ccg_file.ccg01, #工單編號
             ccg02  LIKE ccg_file.ccg02, #年
             ccg03  LIKE ccg_file.ccg03, #月份
             ccg06  LIKE ccg_file.ccg06, #成本計算類型  #FUN-830032
             ccg07  LIKE ccg_file.ccg07, #類型編號      #FUN-830032
             cai05  LIKE cai_file.cai05, #成本中心
             cai06  LIKE cai_file.cai06, #成本項目
             cab02  LIKE cab_file.cab02, #成本項目名稱
            #caa04_d  LIKE cre_file.cre08,           #No.FUN-680122 VARCHAR(8),           #成本分類 #CHI-970021
             cai08  LIKE cai_file.cai08, #CHI-970021
             cai07  LIKE cai_file.cai07  #本月投入金額 
            END RECORD  
 
   #----------------Add MOD-720042 By TSD.hoho CR11 add----------------------(S)
   ### *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   #----------------Add MOD-720042 By TSD.hoho CR11 add----------------------(E)
 
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #MOD-720042 add
 
#   CALL cl_outnam('axcq400') RETURNING l_name   #NO.FUN-8A0067
   #START REPORT q400_out_rep TO l_name #Mod MOD-720042 By TSD.hoho CR11 add
 
#  LET l_sql=" SELECT ccg04,ima02,ima25,ccg01,ccg02,ccg03, ",  #FUN-830032
   LET l_sql=" SELECT ccg04,ima02,ima25,ccg01,ccg02,ccg03,ccg06,ccg07, ", #FUN-830032
            #" cai05,cai06,cab02,'',cai07 ",    #CHI-970021
             " cai05,cai06,cab02,cai08,cai07 ", #CHI-970021
             "  FROM ccg_file LEFT OUTER JOIN ima_file ON ccg04=ima01,cai_file LEFT OUTER JOIN cab_file ON cai06=cab01 ",
             "  WHERE ccg01=cai01 AND ccg02=cai02 ",
             "    AND ccg03=cai03 ",
             "    AND ccg01='",g_ccg.ccg01,"' ",
             "    AND ccg02='",g_ccg.ccg02,"' ",
             "    AND ccg03='",g_ccg.ccg03,"' ",
           # "    AND ccg04='",g_ccg.ccg04,"' " CLIPPED  #FUN-830032
             "    AND ccg04='",g_ccg.ccg04,"' ",         #FUN-830032
             "    AND ccg06='",g_ccg.ccg06,"' ",         #FUN-830032 
             "    AND ccg07='",g_ccg.ccg07,"' " CLIPPED  #FUN-830032  
  PREPARE q400_out_pre FROM l_sql 
  DECLARE q400_out_cur CURSOR FOR q400_out_pre 
  FOREACH q400_out_cur INTO sr.* 
    IF STATUS THEN EXIT FOREACH END IF 
    #CALL q400_get_caa04_d(sr.cai05,sr.cai06) RETURNING sr.caa04_d #CHI-970021
     #OUTPUT TO REPORT q400_out_rep(sr.*) #Mod MOD-720042 By TSD.hoho CR11 add
 
    #Add MOD-720042 By TSD.hoho CR11---------------------------------------(S)
    ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
    EXECUTE insert_prep USING
      sr.ccg04, sr.ima02, sr.ima25, sr.ccg01, sr.ccg02,
     #sr.ccg03, sr.cai05, sr.cai06, sr.cab02, sr.caa04_d,  #FUN-830032
      sr.ccg03, sr.ccg06, sr.ccg07, sr.cai05, sr.cai06, sr.cab02, sr.cai08,  #FUN-830032 #CHI-970021
      sr.cai07
    #Add MOD-720042 By TSD.hoho CR11---------------------------------------(E)
  END FOREACH   
 
  #Modify MOD-720042 By TSD.hoho CR11---------------------------------------(S)
  ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
  LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
  #列印選擇條件
  LET g_str = " "
  CALL cl_prt_cs3('axcq400','axcq400',l_sql,g_str)   #FUN-710080 modify
  #Modify MOD-720042 By TSD.hoho CR11---------------------------------------(E)
 
  #FINISH REPORT q400_out_rep #Mod MOD-720042 By TSD.hoho CR11 add
  
  #CALL cl_prt(l_name,g_prtway,g_copies,g_len) #Mod MOD-720042 By TSD.hoho CR11 add
  CLOSE q400_out_cur 
  ERROR "" 
  RETURN 
END FUNCTION
 
# #Mod MOD-720042 By TSD.hoho CR11 add---------------------------------------(S)
{
REPORT q400_out_rep(sr)
    DEFINE sr RECORD 
             ccg04  LIKE ccg_file.ccg04, #主件料號
             ima02  LIKE ima_file.ima02, #品名
             ima25  LIKE ima_file.ima25, #庫存單位
             ccg01  LIKE ccg_file.ccg01, #工單編號
             ccg02  LIKE ccg_file.ccg02, #年
             ccg03  LIKE ccg_file.ccg03, #月份
             cai05  LIKE cai_file.cai05, #成本中心
             cai06  LIKE cai_file.cai06, #成本項目
             cab02  LIKE cab_file.cab02, #成本項目名稱
             caa04_d  LIKE cre_file.cre08,           #No.FUN-680122 VARCHAR(8),           #成本分類
             cai07  LIKE cai_file.cai07  #本月投入金額 
        END RECORD,
        l_last_sw LIKE type_file.chr1           #No.FUN-680122 VARCHAR(1)
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 ORDER BY sr.ccg04,sr.ccg01,sr.ccg02,sr.ccg03  
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]   #No.TQC-6B0002
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED   #No.TQC-6B0002
      PRINT 
      PRINT g_dash CLIPPED
      PRINT g_x[9] CLIPPED,sr.ccg04 CLIPPED,'  ',sr.ima02 
      PRINT g_x[10] CLIPPED,sr.ccg01,
 #  No.FUN-550025 --start--
            COLUMN 30,g_x[11] CLIPPED,sr.ccg02 USING '###&',
            '-',sr.ccg03 USING '#&',
            COLUMN 58,g_x[12] CLIPPED,sr.ima25   #MOD-6B0031 modify 59->58
 #  No.FUN-550025 --end--  
      PRINT ''
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.ccg04 
     SKIP TO TOP OF PAGE 
#    PRINT g_x[9] CLIPPED,sr.ccg04 CLIPPED,'  ',sr.ima02 
#    PRINT g_x[10] CLIPPED,sr.ccg01,
#          COLUMN 25,g_x[11] CLIPPED,sr.ccg02 USING '###&',
#          '-',sr.ccg03 USING '#&',
#          COLUMN 60,g_x[14] CLIPPED,sr.ima25  
#    PRINT ''
#    PRINT g_x[12],g_x[13] 
#    PRINT g_x[15],g_x[16] 
 
   ON EVERY ROW
     PRINT COLUMN g_c[31],sr.cai05,
           COLUMN g_c[32],sr.cai06 CLIPPED,	 	
           COLUMN g_c[33],sr.cab02 CLIPPED,	 	
           COLUMN g_c[34],sr.caa04_d CLIPPED,	 	
           COLUMN g_c[35],cl_numfor(sr.cai07,35,2)
 
   ON LAST ROW
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
}
# #Mod MOD-720042 By TSD.hoho CR11 add---------------------------------------(E)
