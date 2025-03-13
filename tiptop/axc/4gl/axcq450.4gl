# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: axcq450.4gl
# Descriptions...: 工單轉出聯產品成本查詢作業
# Date & Author..: 03/05/15 BY Jiunn (No.7267)
# Modify.........: MOD-4A0227 04/10/22 Carol 單身顯示異常,上筆下筆查詢,單身永遠是同一筆資料
# Modify.........: No.FUN-4B0015 04/11/09 By Pengu 新增Array轉Excel檔功能
# Modify.........: No.FUN-4C0005 04/12/02 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.MOD-530170 05/03/21 By Carol 直接執行此程式時,用滑鼠無法打X離開
# Modify.........: No.MOD-530850 05/03/31 By Will 增加料件的開窗
# Modify.........: No.TQC-5B0076 05/11/09 By Claire excel匯出失效
# Modify.........: No.FUN-610080 06/02/09 By Sarah 當ccg04(主件)的ima911(重複性生產料件)='Y'時,隱藏ccg01
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680122 06/08/30 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/16 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0101 08/01/10 By lala  成本改善
# Modify.........: No.MOD-860293 08/06/26 By Pengu 查詢時單身下條件無功用
# Modify.........: No.MOD-8A0035 08/11/15 By Pengu axct400串查[聯產品成本查詢]時會出現-201錯誤訊息
# Modify.........: No.MOD-920355 09/02/26 By Pengu 當單身有多筆時按上下筆會異常
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-970003 09/12/01 By jan 批次成本修改
# Modify.........: No:MOD-AB0160 10/11/17 By sabrina FOREACH q450_bcs裡計算g_t22f、g_t22g、g_t22h三行，前面變數誤寫成g_t22e
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    tm_wc  LIKE type_file.chr1000,       #No.FUN-680122CHAR(300),           # Head Where condition
    tm_wc2 LIKE type_file.chr1000,       #No.FUN-680122CHAR(300),           # Head Where condition
    g_ccg  RECORD
            ccg01               LIKE ccg_file.ccg01,    #工單編號
            ccg02               LIKE ccg_file.ccg02,    #年度 
            ccg03               LIKE ccg_file.ccg03,    #月份
            ccg04               LIKE ccg_file.ccg04,    #主件
            ccg06               LIKE ccg_file.ccg06,    #FUN-7C0101
            ccg07               LIKE ccg_file.ccg07,    #FUN-7C0101
            ccguser             LIKE ccg_file.ccguser,  #
            ccgdate             LIKE ccg_file.ccgdate,  #
            ccgtime             LIKE ccg_file.ccgtime,  #
            ima02a              LIKE ima_file.ima02,    #
            ima021a             LIKE ima_file.ima021    #
        END RECORD,
    g_cce DYNAMIC ARRAY OF RECORD
            cce04       LIKE cce_file.cce04,  #轉出料號(聯產品料號)
            ima02       LIKE ima_file.ima02,  #品名
            ima021      LIKE ima_file.ima021, #規格
            ima25       LIKE ima_file.ima25,  #單位
            cce21       LIKE cce_file.cce21,  #數量
            cce22a      LIKE cce_file.cce22a, #
            cce22b      LIKE cce_file.cce22b, #
            cce22c      LIKE cce_file.cce22c, #
            cce22d      LIKE cce_file.cce22d, #
            cce22e      LIKE cce_file.cce22e, #
            cce22f      LIKE cce_file.cce22f, #FUN-7C0101
            cce22g      LIKE cce_file.cce22g, #FUN-7C0101
            cce22h      LIKE cce_file.cce22h, #FUN-7C0101
            cce22       LIKE cce_file.cce22   #
        END RECORD,
    g_argv1         LIKE cce_file.cce04,   #參數1 #料號
    g_argv2         LIKE ccg_file.ccg02,   #參數2 #年度
    g_argv3         LIKE ccg_file.ccg03,   #參數3 #月份
    g_argv4         LIKE ccg_file.ccg01,   #參數4 #工單
    g_argv5         LIKE type_file.chr1,          # Prog. Version..: '5.30.06-13.03.12(01),             #參數5 #來源('1':axct100 '2':axct400)
    g_argv6         LIKE ccg_file.ccg06,   #參數6 #成本計算類別  #No.FUN-7C0101
    g_argv7         LIKE ccg_file.ccg07,   #參數7 #類別編號      #No.FUN-7C0101
    g_wc,g_sql      string,             #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680122 SMALLINT
    g_t21           LIKE cce_file.cce21,           #No.FUN-680122DECIMAL(15,3),
    g_t22a          LIKE cce_file.cce22a,          #No.FUN-680122 DECIMAL(20,6), #FUN-4C0005
    g_t22b          LIKE cce_file.cce22b,          #No.FUN-680122 DECIMAL(20,6), #FUN-4C0005 
    g_t22c          LIKE cce_file.cce22c,          #No.FUN-680122 DECIMAL(20,6), #FUN-4C0005
    g_t22d          LIKE cce_file.cce22d,          #No.FUN-680122 DECIMAL(20,6), #FUN-4C0005
    g_t22e          LIKE cce_file.cce22e,          #No.FUN-680122 DECIMAL(20,6), #FUN-4C0005
    g_t22f          LIKE cce_file.cce22f,          #FUN-7C0101
    g_t22g          LIKE cce_file.cce22g,          #FUN-7C0101
    g_t22h          LIKE cce_file.cce22h,          #FUN-7C0101
    g_t22           LIKE cce_file.cce22            #No.FUN-680122 DECIMAL(20,6)  #FUN-4C0005
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(72)
 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680122 INTEGER
MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0146
DEFINE l_sl          LIKE type_file.num5           #No.FUN-680122 SMALLINT
 
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
         RETURNING g_time    #No.FUN-6A0146
    LET g_argv1       = ARG_VAL(1)        #參數值(1) 料號
    LET g_argv2       = ARG_VAL(2)        #參數值(2) 年度
    LET g_argv3       = ARG_VAL(3)        #參數值(3) 月份
    LET g_argv4       = ARG_VAL(4)        #參數值(4) 工單
    LET g_argv5       = ARG_VAL(5)        #參數值(5) 來源
    LET g_argv6       = ARG_VAL(6)        #參數值(6) 成本計算類別  #No.FUN-7C0101
    LET g_argv7       = ARG_VAL(7)        #參數值(7) 類別編號      #No.FUN-7C0101 
 
    OPEN WINDOW q450_w AT 3,2
      WITH FORM "axc/42f/axcq450"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv5) THEN 
       CALL q450_q() 
    END IF
    CALL q450_menu()
    CLOSE WINDOW q450_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
         RETURNING g_time    #No.FUN-6A0146
END MAIN
 
 
#QBE 查詢資料
FUNCTION q450_cs()
  DEFINE   l_cnt LIKE type_file.num5           #No.FUN-680122 SMALLINT
  DEFINE l_ccg06 LIKE ccg_file.ccg06   #No.FUN-7C0101
  IF g_argv5 != ' '  THEN 
     IF g_argv5='1' THEN #axct100
       #---------No.MOD-920355 modify
       #LET tm_wc="cce04='",g_argv1,"' AND ccg02='",g_argv2,"' AND ccg03='",
        LET tm_wc="ccg04='",g_argv1,"' AND ccg02='",g_argv2,"' AND ccg03='",
       #---------No.MOD-920355 end
                            g_argv3,"'"
                            ," AND ccg06 = '",g_argv6,"' AND ccg07 = '",g_argv7,"'"   #No.FUN-7C0101
     END IF
     IF g_argv5='2' THEN #axct400
        LET tm_wc="ccg02='",g_argv2,"' AND ccg03='",g_argv3,"' AND ccg01='",
                            g_argv4,"'"
                           ," AND ccg06 = '",g_argv6,"' "    #TQC-970003
                          #," AND ccg06 = '",g_argv6,"' AND ccg07 = '",g_argv7,"'"   #No.FUN-7C0101 #TQC-970003
     END IF
     #LET tm_wc = "ccg01 = '",g_argv1,"'" 
  ELSE 
     CLEAR FORM #清除畫面
   CALL g_cce.clear()
     CALL cl_opmsg('q')
     LET tm_wc = NULL
     CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE g_ccg.* TO NULL    #No.FUN-750051
     CONSTRUCT BY NAME tm_wc ON ccg01,ccg02,ccg03,ccg06,ccg04,ccg07,ccguser,ccgdate,ccgtime    #FUN-7C0101
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
 
        #No.FUN-7C0101--start--
        AFTER FIELD ccg06
              LET l_ccg06 = get_fldbuf(ccg06)
        #No.FUN-7C0101---end---
 
     #FUN-530065
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
     END CONSTRUCT
     LET tm_wc = tm_wc CLIPPED,cl_get_extra_cond('ccguser', 'ccggrup') #FUN-980030
 
     IF INT_FLAG THEN RETURN END IF
     CONSTRUCT tm_wc2 ON cce04,cce21,
                         cce22a,cce22b,cce22c,cce22d,cce22e,cce22f,cce22g,cce22h,cce22               #FUN-7C0101
         FROM s_cce[1].cce04,s_cce[1].cce21,s_cce[1].cce22a,s_cce[1].cce22b,s_cce[1].cce22c,s_cce[1].cce22d,
              s_cce[1].cce22e,s_cce[1].cce22f,s_cce[1].cce22g,s_cce[1].cce22h,s_cce[1].cce22         #FUN-7C0101
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
 
      #MOD-530850                                                                 
     ON ACTION CONTROLP                                                         
        CASE                                                                    
          WHEN INFIELD(cce04)                                                   
            CALL cl_init_qry_var()                                              
            LET g_qryparam.form = "q_ima"                                       
            LET g_qryparam.state = "c"                                          
            LET g_qryparam.default1 = g_cce[1].cce04                               
            CALL cl_create_qry() RETURNING g_cce[1].cce04             
            DISPLAY g_cce[1].cce04 TO cce04                               
            NEXT FIELD cce04                                                 
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
 
     
     END CONSTRUCT
  END IF
 
  IF cl_null(tm_wc2) THEN LET tm_wc2='1=1' END IF   #No.MOD-8A0035 add
  MESSAGE ' WAIT '
 #-----------No.MOD-920355 add
  IF cl_null(tm_wc2) OR tm_wc2 = '1=1' THEN   
     LET g_sql=" SELECT DISTINCT ccg01,ccg02,ccg03,ccg04,ccg06,ccg07 ",
               " FROM ccg_file ",
               " WHERE ", tm_wc CLIPPED
  ELSE  
 #-----------------No.MOD-920355 end
    #--------------No.MOD-920355 modify
    #LET g_sql=" SELECT ccg01,ccg02,ccg03,ccg04,ccg06,ccg07 ",
     LET g_sql=" SELECT DISTINCT ccg01,ccg02,ccg03,ccg04,ccg06,ccg07 ",
    #--------------No.MOD-920355 end
               " FROM ccg_file,cce_file ",
               " WHERE ", tm_wc CLIPPED,
               "   AND ", tm_wc2 CLIPPED,        #No.MOD-860293 add
               "   AND cce01=ccg01 ",            #wo
               "   AND cce02=ccg02 ",            #年
               "   AND cce03=ccg03 ",            #月
           #    "   AND cce04=ccg04 ",            #FUN-7C0101
               "   AND cce06=ccg06 "             #FUN-7C0101 #TQC-970003
#              "   AND cce07=ccg07 "             #FUN-7C0101 #TQC-970003
   END IF    #No.MOD-920355 add
     
 
  #資料權限的檢查
  #Begin:FUN-980030
  #  IF g_priv2='4' THEN#只能使用自己的資料
  #     LET g_sql = g_sql clipped," AND ccguser = '",g_user,"'"
  #  END IF
  #沒有ccggrup欄
  #IF g_priv3='4' THEN#只能使用相同群的資
  #   LET g_sql = g_sql clipped," AND ccggrup MATCHES '",g_grup CLIPPED,"*'"
  #END IF
  LET g_sql = g_sql clipped," ORDER BY ccg01,ccg02,ccg03,ccg04,ccg06,ccg07"   #FUN-7C0101
  PREPARE q450_prepare FROM g_sql
  DECLARE q450_cs SCROLL CURSOR FOR q450_prepare #SCROLL CURSOR
 
  #取合乎條件筆數
  #若使用組合鍵值, 則可以使用本方法去得到筆數值
 #---------------No.MOD-920355 add
  IF cl_null(tm_wc2) OR tm_wc2 = '1=1' THEN   
     LET g_sql=" SELECT DISTINCT ccg01,ccg02,ccg03,ccg04,ccg06,ccg07 ",
               " FROM ccg_file ",
               " WHERE ", tm_wc CLIPPED
  ELSE  
 #-----------------No.MOD-920355 end
 #--------------------No.MOD-920355 modify
    #LET g_sql=" SELECT DISTINCT ccg01,ccg02,ccg03,ccg04,ccg06,ccg07 ",    #FUN-7C0101
    #          " FROM ccg_file,cce_file ",
    #          " WHERE ", tm_wc CLIPPED ,
    #          "   AND ", tm_wc2 CLIPPED,        #No.MOD-860293 add
    #          "   AND cce01=ccg01 ",            #wo
    #          "   AND cce02=ccg02 ",            #年
    #          "   AND cce03=ccg03 ",            #月
    #       #   "   AND cce04=ccg04 ",            #FUN-7C0101
    #          "   AND cce06=ccg06 ",            #FUN-7C0101                       
    #          "   AND cce07=ccg07 "             #FUN-7C0101
     LET g_sql=" SELECT DISTINCT ccg01,ccg02,ccg03,ccg04,ccg06,ccg07 ",
               " FROM ccg_file,cce_file ",
               " WHERE ", tm_wc CLIPPED ,
               "   AND ccg01||ccg02||ccg03||ccg06||ccg07 IN ",
               "       (SELECT cce01||cce02||cce03||cce06||cce07 ",
               "          FROM cce_file ",
               "   WHERE  ", tm_wc2 CLIPPED,      
               "   AND cce01=ccg01 ",            #wo
               "   AND cce02=ccg02 ",            #年
               "   AND cce03=ccg03 ",            #月
               "   AND cce06=ccg06 )"            #FUN-7C0101  #TQC-970003                     
#              "   AND cce07=ccg07 )"            #FUN-7C0101  #TQC-970003
   END IF
 #--------------------No.MOD-920355 end
           
  #資料權限的檢查
  IF g_priv2='4' THEN#只能使用自己的資料
     LET g_sql = g_sql clipped," AND ccguser = '",g_user,"'"
  END IF
  #沒有ccggrup欄位
  #IF g_priv3='4' THEN#只能使用相同群的資料
  #   LET g_sql = g_sql clipped," AND ccggrup MATCHES '",g_grup CLIPPED,"*'"
  #END IF
   LET g_sql = g_sql CLIPPED," INTO TEMP x "
   DROP TABLE x
   PREPARE q450_precount_x FROM g_sql
   EXECUTE q450_precount_x
 
   LET g_sql="SELECT COUNT(*) FROM x "
 
   PREPARE q450_precount FROM g_sql
   DECLARE q450_count CURSOR FOR q450_precount
END FUNCTION
 
#中文的MENU
FUNCTION q450_menu()
 
   WHILE TRUE
      CALL q450_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q450_q()
            END IF
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0015
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_cce),'','')
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q450_q()
  DEFINE l_ccg01 LIKE ccg_file.ccg01,
         l_ccg02 LIKE ccg_file.ccg02,
         l_ccg03 LIKE ccg_file.ccg03
 
  LET g_row_count = 0
  LET g_curs_index = 0
  CALL cl_navigator_setting( g_curs_index, g_row_count )
 
  CALL cl_opmsg('q')
  DISPLAY '   ' TO FORMONLY.cnt 
  CALL q450_cs()
  IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
  OPEN q450_cs                            # 從DB產生合乎條件TEMP(0-30秒)
  IF SQLCA.sqlcode THEN
     CALL cl_err('',SQLCA.sqlcode,0)
  ELSE
     OPEN q450_count
     FETCH q450_count INTO g_row_count
     DISPLAY g_row_count TO FORMONLY.cnt  
     CALL q450_fetch('F')                  # 讀出TEMP第一筆並顯示
  END IF
  MESSAGE ''
END FUNCTION
 
FUNCTION q450_fetch(p_flag)
DEFINE p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680122 VARCHAR(1)
       l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680122 INTEGER
 
  CASE p_flag
    WHEN 'N' FETCH NEXT     q450_cs INTO g_ccg.ccg01,g_ccg.ccg02,
                                         g_ccg.ccg03,g_ccg.ccg04,g_ccg.ccg06,g_ccg.ccg07   #FUN-7C0101
    WHEN 'P' FETCH PREVIOUS q450_cs INTO g_ccg.ccg01,g_ccg.ccg02,
                                         g_ccg.ccg03,g_ccg.ccg04,g_ccg.ccg06,g_ccg.ccg07   #FUN-7C0101
    WHEN 'F' FETCH FIRST    q450_cs INTO g_ccg.ccg01,g_ccg.ccg02,
                                         g_ccg.ccg03,g_ccg.ccg04,g_ccg.ccg06,g_ccg.ccg07   #FUN-7C0101
    WHEN 'L' FETCH LAST     q450_cs INTO g_ccg.ccg01,g_ccg.ccg02,
                                         g_ccg.ccg03,g_ccg.ccg04,g_ccg.ccg06,g_ccg.ccg07   #FUN-7C0101
    WHEN '/'
         CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
         LET INT_FLAG = 0  ######add for prompt bug
         PROMPT g_msg CLIPPED,': ' FOR l_abso
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
#               CONTINUE PROMPT
 
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
         FETCH ABSOLUTE l_abso q450_cs INTO g_ccg.ccg01,g_ccg.ccg02,
                                            g_ccg.ccg03,g_ccg.ccg04,g_ccg.ccg06,g_ccg.ccg07    #FUN-7C0101
  END CASE
 
  IF SQLCA.sqlcode THEN
     CALL cl_err(g_ccg.ccg01,SQLCA.sqlcode,0)
     INITIALIZE g_ccg.* TO NULL  #TQC-6B0105
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
            
  SELECT ccg01,ccg02,ccg03,ccg04,ccg06,ccg07,ccguser,ccgdate,ccgtime,ima02,ima021     #FUN-7C0101
    INTO g_ccg.*
    FROM ccg_file LEFT OUTER JOIN ima_file ON ccg04=ima_file.ima01
   WHERE ccg01=g_ccg.ccg01
     AND ccg02=g_ccg.ccg02
     AND ccg03=g_ccg.ccg03
     AND ccg06=g_ccg.ccg06     #FUN-7C0101
     AND ccg07=g_ccg.ccg07     #FUN-7C0101
  IF SQLCA.sqlcode THEN
#    CALL cl_err(g_ccg.ccg01,SQLCA.sqlcode,0)   #No.FUN-660127
     CALL cl_err3("sel","ccg_file",g_ccg.ccg01,g_ccg.ccg02,SQLCA.sqlcode,"","",0)   #No.FUN-660127
     RETURN
 
  END IF
  CALL q450_show()
 
END FUNCTION
############
FUNCTION q450_show()
  DEFINE l_ima911  LIKE ima_file.ima911   #FUN-610080
 
  DISPLAY BY NAME g_ccg.ccg01,g_ccg.ccg02,g_ccg.ccg03,g_ccg.ccg04,g_ccg.ccg06,g_ccg.ccg07,
                  g_ccg.ccguser,g_ccg.ccgdate,g_ccg.ccgtime,g_ccg.ima02a,g_ccg.ima021a   # 顯示單頭值
 #start FUN-610080
  SELECT ima911 INTO l_ima911 FROM ima_file WHERE ima01=g_ccg.ccg04
  IF l_ima911='Y' THEN
     CALL cl_set_comp_visible("ccg01",FALSE)
  ELSE
     CALL cl_set_comp_visible("ccg01",TRUE)
  END IF
 #end FUN-610080
  CALL q450_b_fill() #單身
 #MOD-4A0227 add
  DISPLAY g_t21  TO FORMONLY.tot21
  DISPLAY g_t22a TO FORMONLY.tot22a
  DISPLAY g_t22b TO FORMONLY.tot22b
  DISPLAY g_t22c TO FORMONLY.tot22c
  DISPLAY g_t22d TO FORMONLY.tot22d
  DISPLAY g_t22e TO FORMONLY.tot22e
  DISPLAY g_t22f TO FORMONLY.tot22f
  DISPLAY g_t22g TO FORMONLY.tot22g
  DISPLAY g_t22h TO FORMONLY.tot22h
  DISPLAY g_t22  TO FORMONLY.tot22
##
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q450_b_fill()              #BODY FILL UP
  DEFINE l_sql     LIKE type_file.chr1000        #No.FUN-680122 VARCHAR(400)
 
  LET l_sql = "SELECT cce04,ima02,ima021,ima25,cce21,",
              " cce22a,cce22b,cce22c,cce22d,cce22e,cce22f,cce22g,cce22h,cce22",
        " FROM  cce_file LEFT OUTER JOIN ima_file ON ima_file.ima01=cce04 ",
        " WHERE cce01 = '",g_ccg.ccg01,"'",
        " AND   cce02 = '",g_ccg.ccg02,"'",
        " AND   cce03 = '",g_ccg.ccg03,"'",
        " AND   cce06 = '",g_ccg.ccg06,"'",    #FUN-7C0101
#       " AND   cce07 = '",g_ccg.ccg07,"'",    #FUN-7C0101  #TQC-970003
        " AND ",tm_wc2 CLIPPED,                #No.MOD-920355 add
        " ORDER BY 1"
    PREPARE q450_pb FROM l_sql
    DECLARE q450_bcs CURSOR FOR q450_pb #BODY CURSOR
 
     CALL g_cce.clear()  #MOD-4A0227 modify
 
    LET g_cnt =1
    LET g_t21 =0
    LET g_t22a=0
    LET g_t22b=0
    LET g_t22c=0
    LET g_t22d=0
    LET g_t22e=0
    LET g_t22f=0
    LET g_t22g=0
    LET g_t22h=0
    LET g_t22 =0
 
    FOREACH q450_bcs INTO g_cce[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_t21 = g_t21  + g_cce[g_cnt].cce21
      LET g_t22a= g_t22a + g_cce[g_cnt].cce22a
      LET g_t22b= g_t22b + g_cce[g_cnt].cce22b
      LET g_t22c= g_t22c + g_cce[g_cnt].cce22c
      LET g_t22d= g_t22d + g_cce[g_cnt].cce22d
      LET g_t22e= g_t22e + g_cce[g_cnt].cce22e
     #LET g_t22e= g_t22f + g_cce[g_cnt].cce22f          #MOD-AB0160 mark    
     #LET g_t22e= g_t22g + g_cce[g_cnt].cce22g          #MOD-AB0160 mark   
     #LET g_t22e= g_t22h + g_cce[g_cnt].cce22h          #MOD-AB0160 mark     
      LET g_t22f= g_t22f + g_cce[g_cnt].cce22f          #MOD-AB0160 add 
      LET g_t22g= g_t22g + g_cce[g_cnt].cce22g          #MOD-AB0160 add 
      LET g_t22h= g_t22h + g_cce[g_cnt].cce22h          #MOD-AB0160 add 
      LET g_t22 = g_t22  + g_cce[g_cnt].cce22
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
 
    END FOREACH
 
    LET g_rec_b = g_cnt - 1
 
END FUNCTION
 
FUNCTION q450_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_cce TO s_cce.*  ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED) #MOD-4A0227 modify
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      #BEFORE ROW
      #   LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      #   LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first 
         CALL q450_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL q450_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump 
         CALL q450_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL q450_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last 
         CALL q450_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
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
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   
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
 
 
