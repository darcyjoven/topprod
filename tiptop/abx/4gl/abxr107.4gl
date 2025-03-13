# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: abxr107.4gl
# Descriptions...: 廠外加工貨品進廠紀錄卡列印作業       
# Date & Author..: 2006/10/20 By kim
 
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-850089 08/05/26 By TSD.zeak 報表改寫由CR產出
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
#FUN-850089 By TSD.zeak  ---start---  
DEFINE l_table       STRING                   
DEFINE g_str         STRING  
DEFINE g_sql         STRING                 
#FUN-850089 By TSD.zeak  ----end----  
 
DEFINE   g_date          RECORD
            min_no       LIKE bxb_file.bxb02, #最小單據日期
            max_no       LIKE bxb_file.bxb02, #最大單據日期
            min_fac      LIKE bxb_file.bxb08, #最小進廠日期
            max_fac      LIKE bxb_file.bxb08  #最大進廠日期
                         END RECORD
             
         
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
   #FUN-850089 By TSD.zeak  ---start---  
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "bxb01.bxb_file.bxb01,",   #加工品運回進廠存倉單證編號
               "bxb03.bxb_file.bxb03,",   #加工廠商
               "bxb06.bxb_file.bxb06,",   #品號
               "bxb07.bxb_file.bxb07,",   #數量
               "bxb08.bxb_file.bxb08,",   #運回日期
               "pmc03.pmc_file.pmc03,",   #加工廠商名稱
               "ima02.ima_file.ima02,",   #名稱
               "ima021.ima_file.ima021,", #規格
               "ima55.ima_file.ima55,",   #單位
               "bxc07.bxc_file.bxc07,",   #單位用料量
               "bxc08.bxc_file.bxc08,",   #使用原料總數
               "bxc09.bxc_file.bxc09,",   #損耗數量
               "bxc10.bxc_file.bxc10,",   #下腳及廢料運回數量
               "bxc11.bxc_file.bxc11,",   #未加工運回原料數量
               "bnb90.bnb_file.bnb90,",   #管理處核准文號
               "bxb18.bxb_file.bxb18,",   #核准文號
               "bxa03.bxa_file.bxa03,",   #品名
               "bxa04.bxa_file.bxa04,",   #規格
               "bxa08.bxa_file.bxa08,",   #核准加工數量
               "bxz100.bxz_file.bxz100,", #
               "bxz101.bxz_file.bxz101,",
               "bxz102.bxz_file.bxz102,",
               "zo10.zo_file.zo10,",
               "zo02.zo_file.zo02,",
               "min_no.bxb_file.bxb02,",
               "max_no.bxb_file.bxb02,",
               "min_fac.bxb_file.bxb08,",
               "max_fac.bxb_file.bxb08,",
               "towhom.zo_file.zo02,"
   LET l_table = cl_prt_temptable('abxr107',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,
                        ?,?,?,?,?,?,?,?,?,?,
                        ?,?,?,?,?,?,?,?,?) "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
   #FUN-850089 By TSD.zeak  ----end----  
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
  
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80082--add--
   IF NOT cl_null(tm.wc) THEN  
      CALL r107()
   ELSE  
      CALL r107_tm(0,0)        
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
END MAIN
 
FUNCTION r107_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5 
   DEFINE l_cmd          LIKE type_file.chr1000
 
   #開啟視窗
   LET p_row = 5 LET p_col = 5
   OPEN WINDOW r107_w AT p_row,p_col WITH FORM "abx/42f/abxr107" 
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
      CONSTRUCT BY NAME tm.wc ON bxb03,bxb08,bxb02,bxb01,bxb18
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
 
         ON ACTION CONTROLG
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
         CLOSE WINDOW r107_w 
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
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,
                         g_bgjob,g_time,g_prtway,g_copies
            END IF
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
 
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
         CLOSE WINDOW r107_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
         EXIT PROGRAM
      END IF
 
      #選擇延後執行本作業 ( Background Job 設定)
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file   
                WHERE zz01=g_prog
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
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
         CLOSE WINDOW r107_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()  # 列印中，請稍候
      #開始製作報表 
      CALL r107()
      ERROR ""
      MESSAGE ""
END WHILE
   CLOSE WINDOW r107_w
END FUNCTION
 
FUNCTION r107()
DEFINE l_name    LIKE type_file.chr20          # External(Disk) file name
#     DEFINEl_time LIKE type_file.chr8        #No.FUN-6A0062
DEFINE l_sql     STRING        # SQL STATEMENT
DEFINE l_zo10    LIKE zo_file.zo10,
       l_zo02    LIKE zo_file.zo02  
DEFINE sr        RECORD bxb01   LIKE bxb_file.bxb01,   #加工品運回進廠存倉單證編號
                        bxb03   LIKE bxb_file.bxb03,   #加工廠商
                        bxb06   LIKE bxb_file.bxb06,   #品號
                        bxb07   LIKE bxb_file.bxb07,   #數量
                        bxb08   LIKE bxb_file.bxb08,   #運回日期
                        pmc03   LIKE pmc_file.pmc03,   #加工廠商名稱
                        ima02   LIKE ima_file.ima02,   #名稱
                        ima021  LIKE ima_file.ima021,  #規格
                        ima55   LIKE ima_file.ima55,   #單位
                        bxc07   LIKE bxc_file.bxc07,   #單位用料量
                        bxc08   LIKE bxc_file.bxc08,   #使用原料總數
                        bxc09   LIKE bxc_file.bxc09,   #損耗數量
                        bxc10   LIKE bxc_file.bxc10,   #下腳及廢料運回數量
                        bxc11   LIKE bxc_file.bxc11,   #未加工運回原料數量
                        bnb90   LIKE bnb_file.bnb90,   #管理處核准文號
                        bxb18   LIKE bxb_file.bxb18    #核准文號
                        #FUN-850089 By TSD.zeak ---start---
                        ,bxa03  LIKE bxa_file.bxa03,   #品名
                        bxa04   LIKE bxa_file.bxa04,   #規格
                        bxa08   LIKE bxa_file.bxa08,   #核准加工數量
                        bxz100  LIKE bxz_file.bxz100,
                        bxz101  LIKE bxz_file.bxz101,
                        bxz102  LIKE bxz_file.bxz102,
                        zo10    LIKE zo_file.zo10,
                        zo02    LIKE zo_file.zo02,
                        min_no  LIKE bxb_file.bxb02,
                        max_no  LIKE bxb_file.bxb02,
                        min_fac LIKE bxb_file.bxb08,
                        max_fac LIKE bxb_file.bxb08,
                        towhom  LIKE zo_file.zo02
                        #FUN-850089 By TSD.zeak ----end----                        
                        END RECORD
 
   #No.FUN-B80082--mark--Begin---
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6A0062
   #No.FUN-B80082--mark--End----- 

   #FUN-850089 By TSD.zeak  ---start---  
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   #------------------------------ CR (2) ------------------------------#
   #FUN-850089 By TSD.zeak  ----end----  
 
   #抓取公司名稱
   #因為zo02 INTO g_company會影響報表轉excel(會被視為公司title而置中，所以用zo02取代
   SELECT zo02,zo10 INTO l_zo02,l_zo10 FROM zo_file WHERE zo01 = g_rlang 
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                   #只能使用自己的資料
   #     LET tm.wc = tm.wc clipped," AND bxbuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                   #只能使用相同群的資料
   #     LET tm.wc = tm.wc clipped," AND bxbgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   
   #抓取單據日期和進廠日期的範圍
   LET l_sql = " SELECT MIN(bxb02),MAX(bxb02),",
               " MIN(bxb08),MAX(bxb08) ",
               " FROM bxb_file ",
               " WHERE ",tm.wc CLIPPED
   PREPARE r107_prepare2 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('SCOPE OF DATE ERROR !',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
      EXIT PROGRAM
   END IF
   DECLARE r107_curs2 CURSOR FOR r107_prepare2
 
   FOREACH r107_curs2 INTO g_date.*
   END FOREACH
 
   #抓取資料
   LET l_sql = "SELECT",
               " bxb01,bxb03,bxb06,bxb07, ",
               " bxb08,pmc03,ima02,ima021,ima55, ",
               " '','','','','','',bxb18 ",
               #FUN-850089 By TSD.zeak ---start---
               " ,'','',0, ",
               " ' ',' ',' ',' ',' ',NULL,NULL,NULL,NULL,' ' ",
               #FUN-850089 By TSD.zeak ----end----                        
               " FROM bxb_file, ",
               " OUTER ima_file,OUTER pmc_file ",
               " WHERE bxb_file.bxb03=pmc_file.pmc01  ",
               " AND bxb_file.bxb06 = ima_file.ima01  ",
               " AND ", tm.wc CLIPPED , 
               " ORDER BY bxb18,bxb03,bxb01 "
 
   PREPARE r107_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN 
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
      EXIT PROGRAM 
   END IF
   DECLARE r107_curs1 CURSOR FOR r107_prepare1
 
   FOREACH r107_curs1 INTO sr.*
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('foreach:',SQLCA.sqlcode,0)
        EXIT FOREACH
     END IF
     SELECT bnb90 INTO sr.bnb90
       FROM bnb_file,bxb_file WHERE bxb16=bnb16
 
     SELECT SUM(bxc07),SUM(bxc08),SUM(bxc09), 
            SUM(bxc10),SUM(bxc11)
       INTO sr.bxc07,sr.bxc08,sr.bxc09,
            sr.bxc10,sr.bxc11
            FROM bxb_file,bxc_file
            WHERE bxb01=sr.bxb01 AND bxb01 = bxc01
 
     #FUN-850089 By TSD.zeak ---start---
     SELECT bxa03,bxa04,bxa08 INTO sr.bxa03,sr.bxa04,sr.bxa08
       FROM bxa_file WHERE bxa01 = sr.bxb18
     
     LET sr.zo02 = l_zo02
     LET sr.zo10 = l_zo10
     LET sr.bxz100 = g_bxz.bxz100
     LET sr.bxz101 = g_bxz.bxz101
     LET sr.bxz102 = g_bxz.bxz102
     LET sr.min_no = g_date.min_no 
     LET sr.max_no = g_date.max_no 
     LET sr.min_fac = g_date.min_fac 
     LET sr.max_fac = g_date.max_fac 
     LET sr.towhom = g_towhom
     #FUN-850089 By TSD.zeak ----end----    
                    
       EXECUTE insert_prep USING sr.* #FUN-840238
   END FOREACH
 
   #FUN-850089 By TSD.zeak      ---start---
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-720005 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'zu01')
           RETURNING g_str
   ELSE
      LET g_str = ''
   END IF
   CALL cl_prt_cs3('abxr107','abxr107',l_sql,g_str)   
   #------------------------------ CR (4) ------------------------------#
   #FUN-850089 By TSD.zeak  ----end----  
  
   #No.FUN-B80082--mark--Begin--- 
   #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
   #No.FUN-B80082--mark--End-----
END FUNCTION
#No.FUN-870144
