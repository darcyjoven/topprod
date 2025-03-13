# Prog. Version..: '5.30.06-13.03.18(00010)'     #
#
# Pattern name...: axcr441.4gl
# Descriptions...: 工單單位成本表
# Date & Author..: 00/11/16 by Byron
# Modify ........: No:8741 03/11/25 By Melody 修改PRINT段
# Modify.........: No.FUN-4C0099 04/12/31 By kim 報表轉XML功能
# Modify.........: No.MOD-530181 05/03/23 By kim Define金額單價位數改為DEC(20,6)
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-570190 05/08/08 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.TQC-610051 06/02/22 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-630038 06/03/21 By Claire 少計其他
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-690007 06/12/26 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.MOD-720042 07/02/06 by TSD.doris 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/29 By Sarah CR報表串cs3()增加傳一個參數,增加數字取位的處理
# Modify.........: No.FUN-7C0101 08/01/23 By shiwuying 成本改善，CR增加類別編號ccg07和各種制費
# Modify.........: No.FUN-8C0047 09/02/18 By zhaijie MARK cl_outnam()
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-970003 09/12/01 By jan 批次成本修改
# Modify.........: No:MOD-B60192 11/07/19 By sabrina 製費三、四、五傳入rpt變數有誤
# Modify.........: No:CHI-C30012 12/07/30 By bart 金額取位改抓ccz26
# Modify.........: No:CHI-B50026 13/01/18 By Alberti 工單單位成本應加上開帳成本
# Modify.........: No:MOD-D50258 13/05/31 By suncx 新增l_table字段num，用作排序

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                        # Print condition RECORD
              wc      LIKE type_file.chr1000,        #No.FUN-680122  VARCHAR(300)          # Where condition
              type    LIKE ccg_file.ccg06,           #No.FUN-7C0101 add
              d_sw    LIKE type_file.chr1,           #No.FUN-680122  VARCHAR(01)           #  是否列印產品明細
              more    LIKE type_file.chr1            #No.FUN-680122   VARCHAR(01)           # Input more condition(Y/N)
              END RECORD
   #CR11 add MOD-720042 by TSD.doris--------(S)--------
   DEFINE l_table     STRING                        ### CR11 add ###
   DEFINE g_sql       STRING                        ### CR11 add ###
   DEFINE g_str       STRING                        ### CR11 add ###
   #CR11 add MOD-720042 by TSD.doris--------(E)--------
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo 
 
   #CR11 add MOD-720042 by TSD.doris-----(S)-----
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "ccg01.ccg_file.ccg01,",
               "ccg04.ccg_file.ccg04,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "ccg07.ccg_file.ccg07,",      #No.FUN-7C0101 add
               "sfb09.sfb_file.sfb09,",
               "unit_amt.ccg_file.ccg22a,",
               "ccg22a.ccg_file.ccg22a,",
               "ccg22b.ccg_file.ccg22b,",
               "ccg22c.ccg_file.ccg22c,",
               "ccg22d.ccg_file.ccg22d,",
               "ccg22e.ccg_file.ccg22e,",
               "ccg22f.ccg_file.ccg22f,",     #No.FUN-7C0101 add    
               "ccg22g.ccg_file.ccg22g,",     #No.FUN-7C0101 add    
               "ccg22h.ccg_file.ccg22h,",     #No.FUN-7C0101 add
               "cch04.cch_file.cch04,",
               "cch22a.cch_file.cch22a,",
               "cch22b.cch_file.cch22b,",
               "cch22c.cch_file.cch22c,",
               "cch22d.cch_file.cch22d,",
               "cch22e.cch_file.cch22e,",
               "cch22f.cch_file.cch22f,",     #No.FUN-7C0101 add    
               "cch22g.cch_file.cch22g,",     #No.FUN-7C0101 add    
               "cch22h.cch_file.cch22h,",     #No.FUN-7C0101 add
               "count.cch_file.cch22e,",
               "num.type_file.num5"           #MOD-D50258 add
 
   LET l_table = cl_prt_temptable('axcr441',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              # " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)" #No.FUN-7C0101
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?)" #No.FUN-7C0101  #MOD-D50258 add ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
  #CR11 add MOD-720042 by TSD.doris-----(E)-----
 
 
   #TQC-610051-begin
   #INITIALIZE tm.* TO NULL            # Default condition
   #LET tm.d_sw	='N'
   #LET tm.more = 'N'
   #LET g_pdate = g_today
   #LET g_rlang = g_lang
   #LET g_bgjob = 'N'
   #LET g_copies = '1'
   #LET tm.wc = ARG_VAL(1)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(2)
   #LET g_rep_clas = ARG_VAL(3)
   #LET g_template = ARG_VAL(4)
   ##No.FUN-570264 ---end---
   LET g_pdate    = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom   = ARG_VAL(2)
   LET g_rlang    = ARG_VAL(3)
   LET g_bgjob    = ARG_VAL(4)
   LET g_prtway   = ARG_VAL(5)
   LET g_copies   = ARG_VAL(6)
   LET tm.type    = ARG_VAL(12)  #No.FUN-7C0101 add
   LET tm.wc      = ARG_VAL(7)
   LET tm.d_sw    = ARG_VAL(8)
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #TQC-610051-end
   IF cl_null(tm.wc)
      THEN CALL axcr441_tm(0,0)             # Input print condition
      ELSE LET tm.wc="ccg01= '",tm.wc CLIPPED,"'"
           CALL axcr441()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr441_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680122CHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 6 LET p_col = 20 
   ELSE LET p_row = 5 LET p_col = 15
   END IF
   OPEN WINDOW axcr441_w AT p_row,p_col
        WITH FORM "axc/42f/axcr441" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   #TQC-610051-begin
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.type = g_ccz.ccz28          #No.FUN-7C0101 add
   LET tm.d_sw	='N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #TQC-610051-end
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ccg01,ccg04 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE CONSTRUCT
 
#No.FUN-570240 --start                                                          
     ON ACTION controlp                                                      
        IF INFIELD(ccg04) THEN                                              
           CALL cl_init_qry_var()                                           
           LET g_qryparam.form = "q_ima5"                                    
           LET g_qryparam.state = "c"                                       
           CALL cl_create_qry() RETURNING g_qryparam.multiret               
           DISPLAY g_qryparam.multiret TO ccg04                             
           NEXT FIELD ccg04                                                 
        END IF                                                              
#No.FUN-570240 --end     
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
END CONSTRUCT
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ccguser', 'ccggrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axcr441_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN 
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF 
   INPUT BY NAME tm.type,tm.d_sw,tm.more  #No.FUN-7C0101 add tm.type
		WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD d_sw
         IF cl_null(tm.d_sw) OR tm.d_sw NOT MATCHES '[YN]' THEN
            NEXT FIELD n
         END IF
      AFTER FIELD type                                               #No.FUN-7C0101
         IF tm.type NOT MATCHES '[12345]' THEN NEXT FIELD type END IF#No.FUN-7C0101
                
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axcr441_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axcr441'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr441','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.type CLIPPED,"'" ,             #No.FUN-7C0101 add
                         " '",tm.d_sw CLIPPED,"'" ,
                        #" '",tm.more CLIPPED,"'"  ,            #TQC-610051
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axcr441',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr441_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr441()
   ERROR ""
END WHILE
   CLOSE WINDOW axcr441_w
END FUNCTION
 
FUNCTION axcr441()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680122 VARCHAR(20)       # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0146
          l_sql     LIKE type_file.chr1000,       #No.FUN-680122CHAR(600)
          l_za05    LIKE type_file.chr1000,        #No.FUN-680122 VARCHAR(40)
	  l_ccg01	LIKE ccg_file.ccg01,
          l_order    ARRAY[5] OF LIKE type_file.chr20,          #No.FUN-680122CHAR(20)
          sr        RECORD        
	            ccg01     LIKE ccg_file.ccg01,	
                    ccg04     LIKE ccg_file.ccg04,
                    ccg07     LIKE ccg_file.ccg07,    #No.FUN-7C0101 add 	
	            sfb09     LIKE sfb_file.sfb09,
		    unit_amt  LIKE ccg_file.ccg22a,
                    ccg22a     LIKE ccg_file.ccg22a,
	       	    ccg22b     LIKE ccg_file.ccg22b,
                    ccg22c     LIKE ccg_file.ccg22c,
                    ccg22d     LIKE ccg_file.ccg22d    
                   ,ccg22e     LIKE ccg_file.ccg22e   #FUN-630038   
                   ,ccg22f     LIKE ccg_file.ccg22f,  #No.FUN-7C0101 add
	       	    ccg22g     LIKE ccg_file.ccg22g,  #No.FUN-7C0101 add
                    ccg22h     LIKE ccg_file.ccg22h   #No.FUN-7C0101 add
                    END RECORD, 
   #CR11 add MOD-720042 by TSD.doris-----(S)----
           l_ima02      LIKE ima_file.ima02,
           l_ima021     LIKE ima_file.ima021,
           sr2      RECORD
                    cch04      LIKE cch_file.cch04,
                    cch22a     LIKE cch_file.cch22a,
                    cch22b     LIKE cch_file.cch22b,
                    cch22c     LIKE cch_file.cch22c,
                    cch22d     LIKE cch_file.cch22d,
                    cch22e     LIKE cch_file.cch22e
                   ,cch22f     LIKE cch_file.cch22f,  #No.FUN-7C0101 add
	       	    cch22g     LIKE cch_file.cch22g,  #No.FUN-7C0101 add
                    cch22h     LIKE cch_file.cch22h   #No.FUN-7C0101 add
                    END RECORD,
           l_count      LIKE ccg_file.ccg02 
   DEFINE l_ccf12a  LIKE ccf_file.ccf12a            #No:CHI-B50026 add       
   DEFINE l_ccf12b  LIKE ccf_file.ccf12b            #No:CHI-B50026 add       
   DEFINE l_ccf12c  LIKE ccf_file.ccf12c            #No:CHI-B50026 add       
   DEFINE l_ccf12d  LIKE ccf_file.ccf12d            #No:CHI-B50026 add       
   DEFINE l_ccf12e  LIKE ccf_file.ccf12e            #No:CHI-B50026 add       
   DEFINE l_ccf12f  LIKE ccf_file.ccf12f            #No:CHI-B50026 add       
   DEFINE l_ccf12g  LIKE ccf_file.ccf12g            #No:CHI-B50026 add       
   DEFINE l_ccf12h  LIKE ccf_file.ccf12h            #No:CHI-B50026 add 
   DEFINE l_cn      LIKE type_file.num5             #MOD-D50258 add

   LET l_cn = 1  #MOD-D50258 add
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
   #CR11 add MOD-720042 by TSD.doris-----(E)----
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog    #MOD-720042 add
 
   LET l_sql="SELECT ccg01,ccg04,ccg07,sfb09,'', ",          #No.FUN-7C0101 add ccg07
             "       SUM(ccg22a+ccg23a),SUM(ccg22b+ccg23b), ",
             "       SUM(ccg22c+ccg23c),SUM(ccg22d+ccg23d)  ",
             "      ,SUM(ccg22e+ccg23e) ",   #FUN-630038
             "      ,SUM(ccg22f+ccg23f), ",                  #No.FUN-7C0101 add
             "       SUM(ccg22g+ccg23g),SUM(ccg22h+ccg23h) ",#No.FUN-7C0101 add
             "  FROM ccg_file, sfb_file ",
             " WHERE ccg01 = sfb01 ",
             "   AND sfb38 IS NOT NULL ",
             "   AND ccg06 = '",tm.type,"'",                 #No.FUN-7C0101 add
             "   AND ", tm.wc CLIPPED,
             " GROUP BY ccg01,ccg04,ccg07,sfb09 ",           #No.FUN-7C0101 add ccg07
             " ORDER BY ccg01,ccg04,ccg07 "                  #No.FUN-7C0101 add ccg07
   PREPARE axcr441_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN 
     CALL cl_err('prepare:',SQLCA.sqlcode,1)    
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM 
   END IF
   DECLARE axcr441_curs1 CURSOR FOR axcr441_prepare1
 
   #CALL cl_outnam('axcr441') RETURNING l_name   #FUN-8C0047
   #START REPORT axcr441_rep TO l_name # CR11 070207 TSD.doris
 
   LET g_pageno = 0
   FOREACH axcr441_curs1 INTO sr.*
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('foreach:',SQLCA.sqlcode,1) 
        EXIT FOREACH 
     END IF
 
     #CR11 add MOD-720042 by TSD.doris-----(S)--------
     SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file 
         WHERE ima01=sr.ccg04
     IF SQLCA.sqlcode THEN 
        LET l_ima02 = NULL 
        LET l_ima021 = NULL 
     END IF
 
     LET sr2.cch04 = NULL
     LET sr2.cch22a = NULL
     LET sr2.cch22b = NULL
     LET sr2.cch22c = NULL
     LET sr2.cch22d = NULL
     LET sr2.cch22e = NULL
      #------------------------No:CHI-B50026 add
     LET l_ccf12a = 0            LET l_ccf12b = 0
     LET l_ccf12c = 0            LET l_ccf12d = 0
     LET l_ccf12e = 0            LET l_ccf12f = 0
     LET l_ccf12g = 0            LET l_ccf12h = 0
     SELECT SUM(ccf12a),SUM(ccf12b),SUM(ccf12c),SUM(ccf12d),SUM(ccf12e),SUM(ccf12f),SUM(ccf12g),SUM(ccf12h) 
       INTO l_ccf12a,l_ccf12b,l_ccf12c,l_ccf12d,l_ccf12e,l_ccf12f,l_ccf12g,l_ccf12h
       FROM ccf_file WHERE ccf01 = sr.ccg01 AND ccf06 = tm.type AND ccf07 = sr.ccg07
     IF cl_null(l_ccf12a) THEN LET l_ccf12a = 0 END IF
     IF cl_null(l_ccf12b) THEN LET l_ccf12b = 0 END IF
     IF cl_null(l_ccf12c) THEN LET l_ccf12c = 0 END IF
     IF cl_null(l_ccf12d) THEN LET l_ccf12d = 0 END IF
     IF cl_null(l_ccf12e) THEN LET l_ccf12e = 0 END IF
     IF cl_null(l_ccf12f) THEN LET l_ccf12f = 0 END IF
     IF cl_null(l_ccf12g) THEN LET l_ccf12g = 0 END IF
     IF cl_null(l_ccf12h) THEN LET l_ccf12h = 0 END IF
     LET sr.ccg22a = sr.ccg22a + l_ccf12a
     LET sr.ccg22b = sr.ccg22b + l_ccf12b
     LET sr.ccg22c = sr.ccg22c + l_ccf12c
     LET sr.ccg22d = sr.ccg22d + l_ccf12d
     LET sr.ccg22e = sr.ccg22e + l_ccf12e
     LET sr.ccg22f = sr.ccg22f + l_ccf12f
     LET sr.ccg22g = sr.ccg22g + l_ccf12g
     LET sr.ccg22h = sr.ccg22h + l_ccf12h
    #------------------------No:CHI-B50026 end
 
  #   LET sr.unit_amt = (sr.ccg22a+sr.ccg22b+sr.ccg22c+sr.ccg22d+sr.ccg22e)/sr.sfb09   #No.FUN-7C0101
     LET sr.unit_amt = (sr.ccg22a+sr.ccg22b+sr.ccg22c+sr.ccg22d+sr.ccg22e+sr.ccg22f+sr.ccg22g+sr.ccg22h)/sr.sfb09 #No.FUN-7C0101
     IF sr.unit_amt IS  NULL  THEN LET sr.unit_amt = 0 END IF
 
     LET l_count = 0
     SELECT count(cch04) INTO l_count FROM cch_file
      WHERE cch01 = sr.ccg01
     #AND cch06 = tm.type AND cch07 = sr.ccg07      #No.FUN-7C0101 add #TQC-970003
      AND cch06 = tm.type   #TQC-970003
 
     ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
     EXECUTE insert_prep USING
          sr.ccg01,sr.ccg04,l_ima02,l_ima021,sr.ccg07, #No.FUN-7C0101 add
          sr.sfb09,sr.unit_amt,sr.ccg22a,sr.ccg22b,
          sr.ccg22c,sr.ccg22d,sr.ccg22e,
          sr.ccg22f,sr.ccg22g,sr.ccg22h,               #No.FUN-7C0101 add
          sr2.cch04,sr2.cch22a,sr2.cch22b,
         #sr2.cch22c,sr2.cch22d,sr2.cch22e,sr.ccg22f,sr.ccg22g,sr.ccg22h,l_count #No.FUN-7C0101   #MOD-B60192 mark
          sr2.cch22c,sr2.cch22d,sr2.cch22e,sr2.cch22f,sr2.cch22g,sr2.cch22h,l_count,l_cn               #MOD-B60192 add  #MOD-D50258 add l_cn
 
     IF l_count > 0 THEN
        LET l_count=0
        DECLARE axcr441_cur3 CURSOR FOR 
         SELECT cch04,SUM(cch22a),SUM(cch22b),SUM(cch22c),SUM(cch22d)
               ,SUM(cch22e) 
               ,SUM(cch22f),SUM(cch22g),SUM(cch22h) #No.FUN-7C0101 add
           FROM cch_file
          WHERE cch01=sr.ccg01
         #AND cch06 = tm.type AND cch07 = sr.ccg07  #No.FUN-7C0101 add #TQC-970003
          AND cch06 = tm.type   #TQC-970003
          GROUP BY cch04
          ORDER BY cch04
        FOREACH axcr441_cur3 INTO sr2.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           LET l_cn = l_cn+1   #MOD-D50258 add
            #------------------------No:CHI-B50026 add
           LET l_ccf12a = 0            LET l_ccf12b = 0
           LET l_ccf12c = 0            LET l_ccf12d = 0
           LET l_ccf12e = 0            LET l_ccf12f = 0
           LET l_ccf12g = 0            LET l_ccf12h = 0
           SELECT SUM(ccf12a),SUM(ccf12b),SUM(ccf12c),SUM(ccf12d),SUM(ccf12e),SUM(ccf12f),SUM(ccf12g),SUM(ccf12h) 
             INTO l_ccf12a,l_ccf12b,l_ccf12c,l_ccf12d,l_ccf12e,l_ccf12f,l_ccf12g,l_ccf12h
             FROM ccf_file WHERE ccf01 = sr.ccg01 AND ccf04 = sr2.cch04 AND ccf06 = tm.type AND ccf07 = sr.ccg07
           IF cl_null(l_ccf12a) THEN LET l_ccf12a = 0 END IF
           IF cl_null(l_ccf12b) THEN LET l_ccf12b = 0 END IF
           IF cl_null(l_ccf12c) THEN LET l_ccf12c = 0 END IF
           IF cl_null(l_ccf12d) THEN LET l_ccf12d = 0 END IF
           IF cl_null(l_ccf12e) THEN LET l_ccf12e = 0 END IF
           IF cl_null(l_ccf12f) THEN LET l_ccf12f = 0 END IF
           IF cl_null(l_ccf12g) THEN LET l_ccf12g = 0 END IF
           IF cl_null(l_ccf12h) THEN LET l_ccf12h = 0 END IF
           LET sr2.cch22a = sr2.cch22a + l_ccf12a
           LET sr2.cch22b = sr2.cch22b + l_ccf12b
           LET sr2.cch22c = sr2.cch22c + l_ccf12c
           LET sr2.cch22d = sr2.cch22d + l_ccf12d
           LET sr2.cch22e = sr2.cch22e + l_ccf12e
           LET sr2.cch22f = sr2.cch22f + l_ccf12f
           LET sr2.cch22g = sr2.cch22g + l_ccf12g
           LET sr2.cch22h = sr2.cch22h + l_ccf12h
          #------------------------No:CHI-B50026 end
 
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING
                sr.ccg01,sr.ccg04,l_ima02,l_ima021,sr.ccg07, #No.FUN-7C0101 add
                sr.sfb09,sr.unit_amt,sr.ccg22a,sr.ccg22b,
                sr.ccg22c,sr.ccg22d,sr.ccg22e,
                sr.ccg22f,sr.ccg22g,sr.ccg22h,               #No.FUN-7C0101 add
                sr2.cch04,sr2.cch22a,sr2.cch22b,
               #sr2.cch22c,sr2.cch22d,sr2.cch22e,sr.ccg22f,sr.ccg22g,sr.ccg22h,l_count #No.FUN-7C0101   #MOD-B60192 mark
                sr2.cch22c,sr2.cch22d,sr2.cch22e,sr2.cch22f,sr2.cch22g,sr2.cch22h,l_count,l_cn               #MOD-B60192 add  #MOD-D50258 add l_cn 
        END FOREACH
 
     END IF 
     #CR11 add MOD-720042 by TSD.doris-----(E)--------
 
   END FOREACH
 
   #CR11 add MOD-720042 by TSD.doris-----(S)------
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
  #LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify                   #MOD-D50258 mark
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," ORDER BY num"   #FUN-710080 modify   #MOD-D50258 add ORDER BY num
   DISPLAY l_sql
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'ccg01,ccg04')
           RETURNING tm.wc
      LET g_str = tm.wc
   ELSE
      LET g_str = " "
   END IF
   #LET g_str = g_str,";",tm.d_sw,";",g_ccz.ccz27,";",g_azi03,";",tm.type  #FUN-710080 modify  #No.FUN-7C0101 add tm.type #CHI-C30012
   LET g_str = g_str,";",tm.d_sw,";",g_ccz.ccz27,";",g_ccz.ccz26,";",tm.type  #CHI-C30012
#No.FUN-7C0101-------------BEGIN-----------------
   #CALL cl_prt_cs3('axcr441','axcr441',l_sql,g_str)            #FUN-710080 modify
   IF tm.type MATCHES '[12]' THEN
      CALL cl_prt_cs3('axcr441','axcr441_1',l_sql,g_str)
   END IF
   IF tm.type MATCHES '[345]' THEN
      CALL cl_prt_cs3('axcr441','axcr441',l_sql,g_str)
   END IF
#No.FUN-7C0101--------------END------------------
   #------------------------------ CR (4) ------------------------------#
   #CR11 add MOD-720042 by TSD.doris-----(E)------
 
END FUNCTION
 
 
#No.8741
REPORT axcr441_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,           #No.FUN-680122CHAR(1)
          sr        RECORD        
	            ccg01     LIKE ccg_file.ccg01,	
                    ccg04     LIKE ccg_file.ccg04,
	            sfb09     LIKE sfb_file.sfb09,
		    unit_amt  LIKE ccg_file.ccg22a,
                    ccg22a     LIKE ccg_file.ccg22a,
	       	    ccg22b     LIKE ccg_file.ccg22b,
                    ccg22c     LIKE ccg_file.ccg22c,
                    ccg22d     LIKE ccg_file.ccg22d 
                   ,ccg22e     LIKE ccg_file.ccg22e   #FUN-630038
                    END RECORD,
          sr2       RECORD        
                    cch04      LIKE cch_file.cch04,
                    cch22a     LIKE cch_file.cch22a,
                    cch22b     LIKE cch_file.cch22b,
                    cch22c     LIKE cch_file.cch22c,
                    cch22d     LIKE cch_file.cch22d
                   ,cch22e     LIKE cch_file.cch22e   #FUN-630038
                    END RECORD,
         l_flag     LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
	 l_buf      LIKE type_file.chr20,         #No.FUN-680122 VARCHAR(10)
#       l_time	 LIKE type_file.chr8         #No.FUN-6A0146
         l_count    LIKE type_file.num5,           #No.FUN-680122SMALLINT
         l_ima02   LIKE ima_file.ima02,
         l_ima021   LIKE ima_file.ima021, 
         l_cch22at,l_cch22bt,l_cch22ct,l_cch22dt,l_cch22et   LIKE type_file.num20_6       #No.FUN-680122DEC(20,6)  #FUN-630038 add l_cch22et
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.ccg01
  FORMAT
   PAGE HEADER 
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      PRINT
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],g_x[41]  #FUN-630038 add[41]
      PRINT g_dash1 
      LET l_last_sw='n'
 
     BEFORE GROUP OF sr.ccg01
      IF tm.d_sw = 'Y' THEN
          SKIP TO TOP OF PAGE
      END IF
 
   ON EVERY ROW
     LET sr.unit_amt = (sr.ccg22a+sr.ccg22b+sr.ccg22c+sr.ccg22d+sr.ccg22e)/sr.sfb09   #FUN-630038 add sr.ccg22e
     IF sr.unit_amt IS  NULL  THEN LET sr.unit_amt = 0 END IF
     # IF g_trace = 'Y' THEN DISPLAY sr.ccg01 END IF
 
     SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file 
         WHERE ima01=sr.ccg04
     IF SQLCA.sqlcode THEN 
        LET l_ima02 = NULL 
        LET l_ima021 = NULL 
     END IF
 
     PRINT COLUMN g_c[31],sr.ccg01 CLIPPED,
           COLUMN g_c[32],sr.ccg04 CLIPPED,
           COLUMN g_c[33],l_ima02,
           COLUMN g_c[34],l_ima021, 
           COLUMN g_c[35],cl_numfor(sr.sfb09,35,g_ccz.ccz27), #CHI-690007 1->ccz27
           COLUMN g_c[36],cl_numfor(sr.unit_amt,36,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[37],cl_numfor(sr.ccg22a,37,g_ccz.ccz26),      #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[38],cl_numfor(sr.ccg22b,38,g_ccz.ccz26),      #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[39],cl_numfor(sr.ccg22c,39,g_ccz.ccz26),      #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[40],cl_numfor(sr.ccg22d,40,g_ccz.ccz26)       #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
          ,COLUMN g_c[41],cl_numfor(sr.ccg22e,41,g_ccz.ccz26)       #FUN-630038 #CHI-C30012 g_azi03->g_ccz.ccz26
	  IF tm.d_sw = 'Y' THEN
                PRINT  
                LET l_count = 0
                SELECT count(cch04) INTO l_count FROM cch_file
                 WHERE cch01 = sr.ccg01
                IF l_count > 0 THEN
		  PRINT COLUMN g_c[35],g_x[10] CLIPPED,
                        COLUMN g_c[37],g_x[11] CLIPPED,
                        COLUMN g_c[38],g_x[12] CLIPPED,
                        COLUMN g_c[39],g_x[13] CLIPPED,
                        COLUMN g_c[40],g_x[14] CLIPPED
                       ,COLUMN g_c[41],g_x[15] CLIPPED   #FUN-630038
                  PRINT COLUMN g_c[35],g_dash2[1,g_w[35]],
                        COLUMN g_c[37],g_dash2[1,g_w[37]],
                        COLUMN g_c[38],g_dash2[1,g_w[38]],
                        COLUMN g_c[39],g_dash2[1,g_w[39]],
                        COLUMN g_c[40],g_dash2[1,g_w[40]]
                       ,COLUMN g_c[41],g_dash2[1,g_w[41]]  #FUN-630038
	          DECLARE axcr441_cur2 CURSOR FOR 
	           SELECT cch04,SUM(cch22a),SUM(cch22b),SUM(cch22c),SUM(cch22d)
                          ,SUM(cch22e)   #FUN-630038
		     FROM cch_file
		    WHERE cch01=sr.ccg01
                    GROUP BY cch04
                    ORDER BY cch04
	  	  FOREACH axcr441_cur2 INTO sr2.*
      		     PRINT COLUMN g_c[35],sr2.cch04,
	                   COLUMN g_c[37],cl_numfor(sr2.cch22a,37,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
	                   COLUMN g_c[38],cl_numfor(sr2.cch22b,38,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                           COLUMN g_c[39],cl_numfor(sr2.cch22c,39,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                           COLUMN g_c[40],cl_numfor(sr2.cch22d,40,g_ccz.ccz26)    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                          ,COLUMN g_c[41],cl_numfor(sr2.cch22e,40,g_ccz.ccz26)     #FUN-630038 #CHI-C30012 g_azi03->g_ccz.ccz26
                  END FOREACH 
                  PRINT COLUMN g_c[37],g_dash2[1,g_w[37]],
                        COLUMN g_c[38],g_dash2[1,g_w[38]],
                        COLUMN g_c[39],g_dash2[1,g_w[39]],
                        COLUMN g_c[40],g_dash2[1,g_w[40]]
                       ,COLUMN g_c[41],g_dash2[1,g_w[41]]   #FUN-630038
                    LET l_cch22at= 0
                    LET l_cch22bt= 0
                    LET l_cch22ct= 0
                    LET l_cch22dt= 0
                    LET l_cch22et= 0        #FUN-630038
                    SELECT SUM(cch22a),SUM(cch22b),SUM(cch22c),SUM(cch22d),SUM(cch22e)  #FUN-630038 add SUM(cch22e)
                      INTO l_cch22at,l_cch22bt,l_cch22ct,l_cch22dt,l_cch22et            #FUN-630038 add l_cch22et  
                      FROM cch_file
                     WHERE cch01 = sr.ccg01
                  PRINT COLUMN g_c[35],g_x[9] CLIPPED,
                        COLUMN g_c[37],cl_numfor(l_cch22at,37,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                        COLUMN g_c[38],cl_numfor(l_cch22bt,38,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                        COLUMN g_c[39],cl_numfor(l_cch22ct,39,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                        COLUMN g_c[40],cl_numfor(l_cch22dt,40,g_ccz.ccz26)    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                       ,COLUMN g_c[41],cl_numfor(l_cch22et,40,g_ccz.ccz26)     #FUN-630038 #CHI-C30012 g_azi03->g_ccz.ccz26
                END IF
	  END IF
   ON LAST ROW
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED #CHI-69007
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
		
#No.8741(END)
END REPORT
