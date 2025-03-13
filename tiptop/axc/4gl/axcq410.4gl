# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcq410.4gl
# Descriptions...: 每月工單元件在製成本查詢作業
# Date & Author..: 96/02/06 By Roger
# Modify.........: No.FUN-4B0015 04/11/09 By Pengu 新增Array轉Excel檔功能
# Modify.........: No.MOD-4C0005 04/12/02 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.MOD-530170 05/03/21 By Carol 直接執行此程式時,用滑鼠無法打X離開
# Modify.........: No.MOD-530850 05/03/29 By Will 增加料件的開窗
# Modify.........: No.TQC-5B0076 05/11/09 By Claire excel匯出失效
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-680007 06/08/02 By Sarah 將之前FUN-670058多抓cct_file,ccu_file的部份remove
# Modify.........: No.FUN-680122 06/08/30 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/16 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-770105 07/07/20 By Rayven 點擊右邊"營運中心切換"按鈕,錄入欲切換的營運中心,切庫后查不到任何資料
# Modify.........: No.TQC-780013 07/08/02 By wujie  點擊右邊"營運中心切換"按鈕,彈出的界面沒有進行中文維護"plant code"
# Modify.........: No.FUN-7C0101 08/01/15 By Cockroach 成本改善增加ccg06(成本計算類別),ccg07(類別編號)
# Modify.........: No.FUN-830140 08/03/31 By Cockroach 串axct400,axct410增加key columns
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.FUN-B10030 11/01/19 By vealxu 拿掉"營運中心切換"ACTION
# Modify.........: No.TQC-B50021 11/05/05 By yinhy 查詢時，元件料號欄位下查詢條件，確定報錯【-201 發生語法錯誤】
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_ccg   RECORD LIKE ccg_file.*,
    g_ccg_t RECORD LIKE ccg_file.*,
    g_ccg_o RECORD LIKE ccg_file.*,
    g_wc,g_wc2,g_sql    STRING,  #No.FUN-580092 HCN
#FUN-4C0005  modify
    g_cch           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
	cch04		LIKE cch_file.cch04,
	cch05		LIKE cch_file.cch05,
	cch11		LIKE cch_file.cch11,
	cch21		LIKE cch_file.cch21,
	cch31		LIKE cch_file.cch31,
	cch91		LIKE cch_file.cch91,
	cch12		LIKE cch_file.cch12,
	cch22		LIKE cch_file.cch22,
	cch32		LIKE cch_file.cch32,
	cch92		LIKE cch_file.cch92
                    END RECORD,
    g_cch_t         RECORD                 #程式變數 (舊值)
	cch04		LIKE cch_file.cch04,
	cch05		LIKE cch_file.cch05,
	cch11		LIKE cch_file.cch11,
	cch21		LIKE cch_file.cch21,
	cch31		LIKE cch_file.cch31,
	cch91		LIKE cch_file.cch91,
	cch12		LIKE cch_file.cch12,
	cch22		LIKE cch_file.cch22,
	cch32		LIKE cch_file.cch32,
	cch92		LIKE cch_file.cch92
                    END RECORD,
##
    g_buf           LIKE type_file.chr1000,                     #No.FUN-680122 VARCHAR(78),
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680122 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT        #No.FUN-680122 SMALLINT
    l_sl            LIKE type_file.num5                 #No.FUN-680122 SMALLINT                #目前處理的SCREEN LINE
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(72) 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680122 INTEGER
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8              #No.FUN-6A0146
   DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
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
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
 
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW q410_w AT p_row,p_col
         WITH FORM "axc/42f/axcq410"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    INITIALIZE g_ccg.* TO NULL
    INITIALIZE g_ccg_t.* TO NULL
    INITIALIZE g_ccg_o.* TO NULL
 
    DROP TABLE count_tmp
    CREATE TEMP TABLE count_tmp(
       ccg01    LIKE cch_file.cch01,
       ccg02    LIKE cch_file.cch02,
       ccg03    LIKE cch_file.cch03,
       ccg04    LIKE ima_file.ima01);
 
    CALL q410_menu()
    CLOSE WINDOW q410_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
FUNCTION q410_cs()
DEFINE l_ccg06 LIKE ccg_file.ccg06 #NO.FUN-7C0101
DEFINE  lc_qbe_sn        LIKE gbm_file.gbm01    #No.FUN-580031  HCN
 
    CLEAR FORM
    CALL g_cch.clear()
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
    INITIALIZE g_ccg.* TO NULL      #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON
         ccg04, ccg01, ccg02, ccg03, ccg06, ccg07, ccg11, ccg12, ccg21, ccg22, ccg31, ccg32 #FUN-7C0101 ADD ccg06,ccg07
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
          CALL cl_qbe_list() RETURNING lc_qbe_sn
          CALL cl_qbe_display_condition(lc_qbe_sn)
       #No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ccguser', 'ccggrup') #FUN-980030
    IF INT_FLAG THEN RETURN END IF
   
    CONSTRUCT g_wc2 ON cch04,cch05
         FROM s_cch[1].cch04,s_cch[1].cch05
       #No.FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
          CALL cl_qbe_display_condition(lc_qbe_sn)
       #No.FUN-580031 --end--       HCN
 
       ON IDLE g_idle_seconds   
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      #MOD-530850
       ON ACTION CONTROLP
          CASE
            WHEN INFIELD(cch04)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_bmb203"
              LET g_qryparam.state = "c"
              LET g_qryparam.default1 = g_cch[1].cch04
              CALL cl_create_qry() RETURNING g_cch[1].cch04
              DISPLAY g_cch[1].cch04 TO cch04
              NEXT FIELD cch04
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
       ON ACTION qbe_save
          CALL cl_qbe_save()
       #No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            # 只能使用自己的資料
    #       LET g_wc = g_wc clipped," AND ccguser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                            # 只能使用相同群的資料
    #       LET g_wc = g_wc clipped," AND ccggrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    IF g_wc2=' 1=1' THEN
       LET g_sql="SELECT ccg04,ccg01,ccg02,ccg03,ccg06,ccg07 FROM ccg_file ",  #FUN-7C0101 ADD ccg06,ccg07
                 " WHERE ",g_wc CLIPPED," ORDER BY ccg04,ccg01,ccg02,ccg03"
    ELSE 
       #LET g_sql="SELECT ,ccg04,ccg01,ccg02,ccg03,ccg06,ccg07",    #FUN-7C0101 ADD ccg06,ccg07 #TQC-B50021 mark 
       LET g_sql="SELECT ccg04,ccg01,ccg02,ccg03,ccg06,ccg07",    #TQC-B50021 
                 "  FROM ccg_file,cch_file ",
                 " WHERE ccg01=cch01 AND ccg02=cch02 AND ccg03=cch03",
                 "   AND ccg06=cch06 AND ccg07=cch07",            #TQC-B50021
                 "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                 " ORDER BY ccg04,ccg01,ccg02,ccg03"
    END IF
    PREPARE q410_prepare FROM g_sql                # RUNTIME 編譯
    DECLARE q410_cs SCROLL CURSOR WITH HOLD FOR q410_prepare
    LET g_sql= "SELECT COUNT(*) FROM ccg_file WHERE ",g_wc CLIPPED
    PREPARE q410_precount FROM g_sql
    DECLARE q410_count CURSOR FOR q410_precount
END FUNCTION
 
FUNCTION q410_menu()
 
   WHILE TRUE
      CALL q410_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q410_q()
            END IF
#        WHEN "detail"
#           IF cl_chk_act_auth() THEN
#              CALL q410_b('0')
#           ELSE
#              LET g_action_choice = NULL
#           END IF
#        WHEN "output"
#           IF cl_chk_act_auth() THEN
#              CALL q410_out('o')
#           END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #@WHEN "主件明細成本"
         WHEN "assm_p_n_detail_cost"
            LET g_msg="axct400 ",g_ccg.ccg01," ",g_ccg.ccg02," ",g_ccg.ccg03," ",g_ccg.ccg04," ",g_ccg.ccg06," ",g_ccg.ccg07 #No.FUN-830140
            #CALL cl_cmdrun(g_msg)      #FUN-660216 remark
            CALL cl_cmdrun_wait(g_msg)  #FUN-660216 add
         #@WHEN "元件明細成本"
         WHEN "component_p_n_detail_cost"
            LET g_msg="axct410 ",g_ccg.ccg01," ",g_ccg.ccg02," ",g_ccg.ccg03," ",g_ccg.ccg06," ",g_ccg.ccg07 #No.FUN-830140 
            #CALL cl_cmdrun(g_msg)   #FUN-660216 remark
            CALL cl_cmdrun_wait(g_msg)    #FUN-660216 add
         #@WHEN "工廠切換"
       # WHEN "switch_plant"      #FUN-B10030
       #    CALL q410_d()         #FUN-B10030
         WHEN "exporttoexcel" #FUN-4B0015
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_cch),'','')
      END CASE
   END WHILE
      CLOSE q410_cs
END FUNCTION
 
FUNCTION q410_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q410_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       CALL g_cch.clear()
       RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN q410_count
    FETCH q410_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN q410_cs                           # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ccg.ccg01,SQLCA.sqlcode,0)
       INITIALIZE g_ccg.* TO NULL
    ELSE
       CALL q410_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION q410_fetch(p_flccg)
    DEFINE
        p_flccg         LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
        l_abso          LIKE type_file.num10          #No.FUN-680122 INTEGER
 
    CASE p_flccg
        WHEN 'N' FETCH NEXT     q410_cs INTO 
                                             g_ccg.ccg04,g_ccg.ccg01,
                                             g_ccg.ccg02,g_ccg.ccg03,
                                             g_ccg.ccg06,g_ccg.ccg07    #FUN-7C0101 ADD
        WHEN 'P' FETCH PREVIOUS q410_cs INTO 
                                             g_ccg.ccg04,g_ccg.ccg01,
                                             g_ccg.ccg02,g_ccg.ccg03,
                                             g_ccg.ccg06,g_ccg.ccg07    #FUN-7C0101 ADD 
        WHEN 'F' FETCH FIRST    q410_cs INTO 
                                             g_ccg.ccg04,g_ccg.ccg01,
                                             g_ccg.ccg02,g_ccg.ccg03,
                                             g_ccg.ccg06,g_ccg.ccg07    #FUN-7C0101 ADD 
        WHEN 'L' FETCH LAST     q410_cs INTO 
                                             g_ccg.ccg04,g_ccg.ccg01,
                                             g_ccg.ccg02,g_ccg.ccg03,
                                             g_ccg.ccg06,g_ccg.ccg07    #FUN-7C0101 ADD 
        WHEN '/'
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR l_abso
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
#                  CONTINUE PROMPT
 
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
            FETCH ABSOLUTE l_abso q410_cs INTO 
                                               g_ccg.ccg04,g_ccg.ccg01,
                                               g_ccg.ccg02,g_ccg.ccg03,
                                               g_ccg.ccg06,g_ccg.ccg07    #FUN-7C0101 ADD 
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ccg.ccg01,SQLCA.sqlcode,0)
        INITIALIZE g_ccg.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flccg
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_ccg.* FROM ccg_file       # 重讀DB,因TEMP有不被更新特性
     WHERE ccg01=g_ccg.ccg01 AND ccg02=g_ccg.ccg02 AND ccg03=g_ccg.ccg03
       AND ccg06=g_ccg.ccg06 AND ccg07=g_ccg.ccg07   #No.TQC-B50021
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_ccg.ccg01,SQLCA.sqlcode,0)   #No.FUN-660127
        CALL cl_err3("sel","ccg_file",g_ccg.ccg01,g_ccg.ccg02,SQLCA.sqlcode,"","",0)   #No.FUN-660127
    ELSE
        CALL q410_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION q410_show()
    DEFINE l_ima	RECORD LIKE ima_file.*
    LET g_ccg_t.* = g_ccg.*
    DISPLAY BY NAME
           g_ccg.ccg04, g_ccg.ccg01, g_ccg.ccg02, g_ccg.ccg03,g_ccg.ccg06,g_ccg.ccg07,    #FUN-7C0101 ADD ccg06,ccg07
           g_ccg.ccg11, g_ccg.ccg12, g_ccg.ccg21, g_ccg.ccg22, g_ccg.ccg23,
           g_ccg.ccg31, g_ccg.ccg32, g_ccg.ccg91, g_ccg.ccg92
    SELECT * INTO l_ima.* FROM ima_file WHERE ima01=g_ccg.ccg04
    DISPLAY BY NAME l_ima.ima02,l_ima.ima25
    CALL q410_b_fill(g_wc2)
    CALL q410_b_tot('d')
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q410_out(p_cmd)
   DEFINE p_cmd	        LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_cmd	        LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(400)
          l_wc          LIKE type_file.chr1000        #No.FUN-680122 VARCHAR(200)
 
   CALL cl_wait()
   IF p_cmd= 'a'
      THEN LET l_wc = 'ccg01="',g_ccg.ccg01,'"' 		# "新增"則印單張
      ELSE LET l_wc = g_wc                     			# 其他則印多張
   END IF
   IF g_wc IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
#     CALL cl_err('',-400,0) END IF
   LET l_cmd = "axcr510",
               " '",g_today CLIPPED,"' ''",
               " '",g_lang CLIPPED,"' 'Y' '' '1' '",
               l_wc CLIPPED
   CALL cl_cmdrun(l_cmd)
   ERROR ' '
END FUNCTION
 
#FUN-B10030 ------------mark start--------------
#FUNCTION q410_d()
#  DEFINE l_plant,l_dbs	LIKE type_file.chr21          #No.FUN-680122 VARCHAR(21)
#  DEFINE l_msg         LIKE type_file.chr1000        #No.TQC-780013
#
#  CALL cl_getmsg('axc-535',g_lang) RETURNING l_msg     #No.TQC-780013
#  LET INT_FLAG = 0  ######add for prompt bug
##  PROMPT 'PLANT CODE:' FOR l_plant
#  PROMPT l_msg FOR l_plant                           #No.TQC-780013
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
##         CONTINUE PROMPT
#
#     ON ACTION about         #MOD-4C0121
#        CALL cl_about()      #MOD-4C0121
#
#     ON ACTION help          #MOD-4C0121
#        CALL cl_show_help()  #MOD-4C0121
#
#     ON ACTION controlg      #MOD-4C0121
#        CALL cl_cmdask()     #MOD-4C0121
#
#  END PROMPT
#  IF l_plant IS NULL THEN RETURN END IF
#  SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_plant
#  IF STATUS THEN ERROR 'WRONG database!' RETURN END IF
#  CALL cl_ins_del_sid(2,'')   #FUN-990069 
#  CLOSE DATABASE #No.TQC-770105
#  DATABASE l_dbs
#  CALL cl_ins_del_sid(1,l_plant)   #FUN-990069 
#  IF STATUS THEN ERROR 'open database error!' RETURN END IF
#  LET g_plant = l_plant
#  LET g_dbs   = l_dbs
#END FUNCTION
#FUN-B10030 ------------mark end----------------
 
FUNCTION q410_b_tot(p_cmd)
   DEFINE p_cmd		LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
   DEFINE cch12_t,cch22_t,cch32_t,cch92_t,cch23_t  LIKE cch_file.cch12  #FUN-4C0005
 
   SELECT SUM(cch12),SUM(cch22),SUM(cch32),SUM(cch92)
     INTO    cch12_t,   cch22_t,   cch32_t,   cch92_t
     FROM cch_file
    WHERE cch01 = g_ccg.ccg01 AND cch02 = g_ccg.ccg02 AND cch03 = g_ccg.ccg03
   SELECT SUM(cch22) INTO cch23_t
     FROM cch_file
    WHERE cch01 = g_ccg.ccg01 AND cch02 = g_ccg.ccg02 AND cch03 = g_ccg.ccg03
      AND cch05 = 'M'
   IF cch22_t IS NULL THEN LET cch22_t = 0 END IF
   IF cch23_t IS NULL THEN LET cch23_t = 0 END IF
   LET cch22_t = cch22_t - cch23_t
   DISPLAY BY NAME cch12_t,cch22_t,cch32_t,cch92_t,cch23_t
   IF p_cmd = 'd' THEN RETURN END IF
   UPDATE ccg_file SET ccg12 = cch12_t,
                       ccg22 = cch22_t,
                       ccg23 = cch23_t,
                       ccg32 = cch32_t,
                       ccg92 = cch92_t
          WHERE ccg01=g_ccg.ccg01 AND ccg02=g_ccg.ccg02 AND ccg03=g_ccg.ccg03
   IF STATUS THEN 
#     CALL cl_err('upd ccg:',STATUS,1)      #No.FUN-660127 
      CALL cl_err3("upd","ccg_file",g_ccg.ccg01,g_ccg.ccg02,STATUS,"","upd ccg:",1)   #No.FUN-660127
   RETURN END IF
   LET g_ccg.ccg12=cch12_t
   LET g_ccg.ccg22=cch22_t
   LET g_ccg.ccg23=cch23_t
   LET g_ccg.ccg32=cch32_t
   LET g_ccg.ccg92=cch92_t
   DISPLAY BY NAME g_ccg.ccg12,g_ccg.ccg22,g_ccg.ccg23,g_ccg.ccg32,g_ccg.ccg92
END FUNCTION
 
FUNCTION q410_b_askkey()
    CONSTRUCT g_wc2 ON cch04,cch05
                  FROM s_cch[1].cch04,s_cch[1].cch05
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
    CALL q410_b_fill(g_wc2)
END FUNCTION
 
FUNCTION q410_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           STRING 
 
#FUN-4C0005 modify
    LET g_sql =
        "SELECT cch04,cch05,cch11,cch21,cch31,cch91,cch12,cch22,cch32,cch92",
##
        "  FROM cch_file",
        " WHERE cch01 ='",g_ccg.ccg01,"' AND cch02 ='",g_ccg.ccg02,"'",
        "   AND cch03 ='",g_ccg.ccg03,"'",
        "   AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY cch04"
    PREPARE q410_pb FROM g_sql
    DECLARE cch_curs CURSOR FOR q410_pb
 
    CALL g_cch.clear()   #FUN-4C0005
 
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH cch_curs INTO g_cch[g_cnt].*   #單身 ARRAY 填充
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
    LET g_rec_b=g_cnt-1
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION q410_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cch TO s_cch.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first
         CALL q410_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL q410_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL q410_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL q410_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL q410_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
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
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      #@ON ACTION 主件明細成本
      ON ACTION assm_p_n_detail_cost
         LET g_action_choice="assm_p_n_detail_cost"
         EXIT DISPLAY
 
      #@ON ACTION 元件明細成本
      ON ACTION component_p_n_detail_cost
         LET g_action_choice="component_p_n_detail_cost"
         EXIT DISPLAY
 
      #@ON ACTION 工廠切換
    # ON ACTION switch_plant                    #FUN-B10030
    #    LET g_action_choice="switch_plant"     #FUN-B10030
    #    EXIT DISPLAY                           #FUN-B10030
 
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
 
#Patch....NO.TQC-610037 <001> #
