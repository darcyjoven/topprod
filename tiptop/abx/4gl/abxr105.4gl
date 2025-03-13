# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: abxr105.4gl
# Descriptions...: 廠外加工貨品進廠紀錄表憑證列印作業       
# Date & Author..: 2006/10/19 By kim
 
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-850089 08/05/23 by TSD.lucasyeh 轉crystal報表
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80082 11/08/08 By fengrui  程式撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD            
           wc      STRING,            # QBE 條件
           more    LIKE type_file.chr1              # 輸入其它特殊列印條件
           END RECORD
DEFINE g_msg LIKE type_file.chr1000 
DEFINE g_sql      STRING,             #FUN-850089 add
       g_str      STRING,             #FUN-850089 add
       l_table    STRING              #FUN-850089 add
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT   
 
   #--外部程式傳遞參數或 Background Job 時接受參數 --#
   LET tm.wc    = ARG_VAL(1)
   LET g_pdate  = ARG_VAL(2)      
   LET g_towhom = ARG_VAL(3)
   LET g_rlang  = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.more  = ARG_VAL(8)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
 
#---FUN-850089 add----start
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "bxb01.bxb_file.bxb01,",     #進廠單號
               "bxb02.bxb_file.bxb02,",     #單據日期
               "bxb03.bxb_file.bxb03,",     #加工廠商
               "bxb08.bxb_file.bxb08,",     #進廠日期
               "bxb04.bxb_file.bxb04,",     #入庫單號
               "bxb06.bxb_file.bxb06,",     #產品品號
               "bxb07.bxb_file.bxb07,",     #入庫數量
               "bxb10.bxb_file.bxb10,",     #入庫庫別
               "bxb13.bxb_file.bxb13,",     #部門
               "bxb14.bxb_file.bxb14,",     #保稅業務人員
               "bxbconf.bxb_file.bxbconf,", #確認碼
               "bxb15.bxb_file.bxb15,",     #備註
               "pmc03.pmc_file.pmc03,",     #加工廠商
               "ima02_a.ima_file.ima02,",   #品名
               "ima021_a.ima_file.ima021,", #產品規格
               "ima55.ima_file.ima55,",     #單位
               "bxc02.bxc_file.bxc02,",     #序號
               "bxc03.bxc_file.bxc03,",     #材料品號
               "bxc08.bxc_file.bxc08,",     #使用原料總數
               "bxc09.bxc_file.bxc09,",     #損耗數量
               "bxc11.bxc_file.bxc11,",     #未加工運品原料數量
               "bxc04.bxc_file.bxc04,",     #運品原料入庫庫別
               "bxc05.bxc_file.bxc05,",     #儲位
               "bxc06.bxc_file.bxc06,",     #批號
               "bxc10.bxc_file.bxc10,",     #下腳及廢料運回數量
               "bxc12.bxc_file.bxc12,",     #下腳及廢料運入庫庫別
               "bxc13.bxc_file.bxc13,",     #儲位
               "bxc14.bxc_file.bxc14,",     #批號
               "ima02_b.ima_file.ima02,",   #品名
               "ima021_b.ima_file.ima021,", #產品規格
               "ima25.ima_file.ima25"       #單位
                                            #31 items
 
   LET l_table = cl_prt_temptable('abxr105',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      EXIT PROGRAM
   END IF
#---FUN-850089 add-----end-

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80082--add-- 
   IF NOT cl_null(tm.wc) THEN  
      CALL r105()
   ELSE  
      CALL r105_tm(0,0)        
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
END MAIN
 
FUNCTION r105_tm(p_row,p_col)
DEFINE p_row,p_col    LIKE type_file.num5 
DEFINE l_cmd          LIKE type_file.chr1000
 
   #開啟視窗
   LET p_row = 5 LET p_col = 5
   OPEN WINDOW r105_w AT p_row,p_col WITH FORM "abx/42f/abxr105" 
      ATTRIBUTE (STYLE = g_win_style)
   CALL cl_ui_init()
   CALL cl_opmsg('p')
 
   #預設畫面欄位
   INITIALIZE tm.* TO NULL        
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
 
      # QBE 
      CONSTRUCT BY NAME tm.wc ON bxb03,bxb08,bxb02,bxb01
 
         ON ACTION CONTROLP
            CASE 
               WHEN INFIELD(bxb01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_bxb01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO bxb01
                  NEXT FIELD bxb01
 
               WHEN INFIELD(bxb03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_pmc2"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO bxb03
                  NEXT FIELD bxb03
               OTHERWISE EXIT CASE
            END CASE
 
         ON ACTION about
            CALL cl_about()
    
         ON ACTION help
            CALL cl_show_help()
    
         ON ACTION controlg
            CALL cl_cmdask()   
      
         ON ACTION locale
            LET g_action_choice = "locale"
            EXIT CONSTRUCT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
     
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bxbuser', 'bxbgrup') #FUN-980030
 
       IF g_action_choice = "locale" THEN
            LET g_action_choice = ""
            CALL cl_dynamic_locale()
            CONTINUE WHILE
         END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         CLOSE WINDOW r105_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN 
         CALL cl_err('','9046',0) CONTINUE WHILE 
      END IF
 
 
      # INPUT 
      INPUT BY NAME tm.more
         WITHOUT DEFAULTS 
         AFTER FIELD more    #是否輸入其它特殊條件
            IF tm.more NOT MATCHES '[YN]' THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,
                         g_bgjob,g_time,g_prtway,g_copies
            END IF
         ON ACTION about
            CALL cl_about()
    
         ON ACTION help
            CALL cl_show_help()
    
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG 
            CALL cl_cmdask()  
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
      
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         CLOSE WINDOW r105_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
         EXIT PROGRAM
      END IF
 
      #選擇延後執行本作業 ( Background Job 設定)
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file   
                WHERE zz01=g_prog
         IF SQLCA.sqlcode OR cl_null(l_cmd) THEN
            CALL cl_err(g_prog,'9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,     
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_lang CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.more CLIPPED,"'"
            CALL cl_cmdat(g_prog,g_time,l_cmd) 
         END IF
         CLOSE WINDOW r105_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()  # 列印中，請稍候
      #開始製作報表 
      CALL r105()
      ERROR ""
   END WHILE
   CLOSE WINDOW r105_w
END FUNCTION
 
FUNCTION r105()
   DEFINE l_name    LIKE type_file.chr20          # External(Disk) file name
#     DEFINE   l_time LIKE type_file.chr8        #No.FUN-6A0062
   DEFINE l_sql     STRING                        # SQL STATEMENT
   DEFINE sr        RECORD bxb01   LIKE bxb_file.bxb01,   #進廠單號
                           bxb02   LIKE bxb_file.bxb02,   #單據日期
                           bxb03   LIKE bxb_file.bxb03,   #加工廠商
                           bxb08   LIKE bxb_file.bxb08,   #進廠日期
                           bxb04   LIKE bxb_file.bxb04,   #入庫單號
                           bxb06   LIKE bxb_file.bxb06,   #產品品號
                           bxb07   LIKE bxb_file.bxb07,   #入庫數量
                           bxb10   LIKE bxb_file.bxb10,   #入庫庫別
                           bxb13   LIKE bxb_file.bxb13,   #部門
                           bxb14   LIKE bxb_file.bxb14,   #保稅業務人員
                           bxbconf LIKE bxb_file.bxbconf, #確認碼
                           bxb15   LIKE bxb_file.bxb15,   #備註  
                           pmc03      LIKE pmc_file.pmc03,         #加工廠商
                           ima02_a    LIKE ima_file.ima02,         #品名
                           ima021_a   LIKE ima_file.ima021,        #產品規格
                           ima55      LIKE ima_file.ima55,         #單位
                           bxc02   LIKE bxc_file.bxc02,   #序號
                           bxc03   LIKE bxc_file.bxc03,   #材料品號
                           bxc08   LIKE bxc_file.bxc08,   #使用原料總數
                           bxc09   LIKE bxc_file.bxc09,   #損耗數量
                           bxc11   LIKE bxc_file.bxc11,   #未加工運品原料數量
                           bxc04   LIKE bxc_file.bxc04,   #運品原料入庫庫別
                           bxc05   LIKE bxc_file.bxc05,   #儲位
                           bxc06   LIKE bxc_file.bxc06,   #批號
                           bxc10   LIKE bxc_file.bxc10,   #下腳及廢料運回數量
                           bxc12   LIKE bxc_file.bxc12,   #下腳及廢料運入庫庫別
                           bxc13   LIKE bxc_file.bxc13,   #儲位
                           bxc14   LIKE bxc_file.bxc14,   #批號
                           ima02_b    LIKE ima_file.ima02,         #品名
                           ima021_b   LIKE ima_file.ima021,        #產品規格
                           ima25      LIKE ima_file.ima25          #單位
                           END RECORD
 
#---FUN-850089 add---start
    ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
    CALL cl_del_data(l_table)
    #------------------------------ CR (2) ------------------------------#
 
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
#---FUN-850089 add----end-

   #No.FUN-B80082--mark--Begin--- 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6A0062
   #No.FUN-B80082--mark--End-----   

   #抓取公司名稱
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang 
   
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                   #只能使用自己的資料
   #     LET tm.wc = tm.wc clipped," AND bxbuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                   #只能使用相同群的資料
   #     LET tm.wc = tm.wc clipped," AND bxbgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #抓取資料
   LET l_sql = "SELECT",
               " bxb01,bxb02,bxb03,bxb08,bxb04,bxb06, ",
               " bxb07,bxb10,bxb13,bxb14,bxbconf,bxb15, ",
               " pmc03,ima02,ima021,ima55, ",
               " bxc02,bxc03,bxc08,bxc09,bxc11,bxc04, ",
               " bxc05,bxc06,bxc10,bxc12,bxc13,bxc14, ",
               " '','','' ",
               " FROM bxb_file,bxc_file, ",
               " OUTER ima_file,OUTER pmc_file ",
               " WHERE bxb01=bxc01 AND bxb_file.bxb03=pmc_file.pmc01  ",
               " AND bxb_file.bxb06 = ima_file.ima01 ",
               " AND ", tm.wc CLIPPED , 
               " ORDER BY bxb01,bxc02 "
 
   PREPARE r105_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN 
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
      EXIT PROGRAM 
   END IF
   DECLARE r105_curs1 CURSOR FOR r105_prepare1
   LET g_pageno = 0
   FOREACH r105_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
      SELECT ima02,ima021,ima25 INTO sr.ima02_b,sr.ima021_b,sr.ima25
        FROM ima_file WHERE ima01 = sr.bxc03
      IF SQLCA.sqlcode != 0 THEN 
         CALL cl_err('foreach:',SQLCA.sqlcode,0)  
      END IF
 
#---FUN-850089 add---start
      EXECUTE insert_prep USING sr.*
      IF SQLCA.sqlcode  THEN
         CALL cl_err('insert_prep:',STATUS,1) EXIT FOREACH
      END IF
      ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR-11 **** ##
#---FUN-850089 add----end-
 
   END FOREACH
 
#---FUN-850089 add---start
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED 
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   LET g_str = g_str,";",g_bxz.bxz100,";",g_bxz.bxz102,";",g_towhom
   CALL cl_prt_cs3('abxr105','abxr105',l_sql,g_str)
   #------------------------------ CR (4) ------------------------------#
#---FUN-850089 add----end-

   #No.FUN-B80082--mark--Begin---
   #CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6A0062
   #No.FUN-B80082--mark--End-----
END FUNCTION
#No.FUN-870144
