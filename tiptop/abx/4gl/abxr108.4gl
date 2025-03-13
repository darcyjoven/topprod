# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: abxr108.4gl
# Descriptions...: 報廢除帳明細表
# LIKE type_file.dat & Author..: 06/11/06 By kim
# Modify.........: No.FUN-850089 08/05/27 By TSD.zeak 報表改寫由CR產出
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80082 11/08/08 By fengrui  程式撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           wc        STRING,
           bdate     LIKE type_file.dat,
           edate     LIKE type_file.dat,
           bxj21 LIKE bxr_file.bxr01,                 #折合原因代碼說明
           ima106    LIKE ima_file.ima06,             #料件型態
           h         LIKE type_file.chr1,             #明細列印否
           yn        LIKE type_file.chr1,             #僅列印保稅料件否
           desc      LIKE bxa_file.bxa01,             #管理處監毀文號
           s         LIKE type_file.chr2,             #排序
           u         LIKE type_file.chr2              #小計
           END RECORD    
     
DEFINE    g_i        LIKE type_file.num10   
DEFINE    g_msg      LIKE type_file.chr1000
DEFINE    g_msg1     LIKE type_file.chr1000
#FUN-850089 By TSD.zeak  ---start---  
DEFINE l_table       STRING                   
DEFINE g_str         STRING  
DEFINE g_sql         STRING                 
#FUN-850089 By TSD.zeak  ----end----  
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT   
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   #FUN-850089 By TSD.zeak  ---start---  
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql =  
            "bxi01.bxi_file.bxi01,",       #單據號碼
            "bxi02.bxi_file.bxi02,",       #異動日期
            "bxj03.bxj_file.bxj03,",       #序號
            "bxj04.bxj_file.bxj04,",       #料號
            "bxj05.bxj_file.bxj05,",       #單位
            "bxj06.bxj_file.bxj06,",       #數量
            "ima01.ima_file.ima01,",       #料件編號
            "ima02.ima_file.ima02,",       #品名
            "ima021.ima_file.ima021,",     #規格
            "ima1916.ima_file.ima1916,",
            "bxe02.bxe_file.bxe02,",
            "bxe03.bxe_file.bxe03,",
            "bnd04.bnd_file.bnd04,",        #BOM編號
            "bxz100.bxz_file.bxz100,",
            "bxz102.bxz_file.bxz102"
 
   LET l_table = cl_prt_temptable('abxr108',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,
                        ?,?,?,?,?) "
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
   CALL r108_tm(0,0) 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
END MAIN
 
FUNCTION r108_tm(p_row,p_col)
   DEFINE p_row,p_col LIKE type_file.num5 
   DEFINE l_cmd       LIKE type_file.chr1000
   DEFINE l_bxr02     LIKE bxr_file.bxr02    #折合原因代碼的說明
       
   LET p_row = 5 LET p_col = 5
 
   OPEN WINDOW r108_w AT p_row,p_col WITH FORM "abx/42f/abxr108"
        ATTRIBUTE (STYLE = g_win_style)
   CALL cl_ui_init()
   CALL cl_opmsg('p')
 
   INITIALIZE tm.* TO NULL
   LET tm.bdate   = g_today
   LET tm.edate   = g_today
   LET tm.ima106  = '3'
   LET tm.h       = 'Y'
   LET tm.yn      = 'N'
   LET tm2.s1     = '2'
   LET tm2.s2     = '1'
   LET tm2.u1     = 'N'
   LET tm2.u2     = 'N'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON ima01,bxe01
    
         ON ACTION locale
            LET g_action_choice = "locale"
            EXIT CONSTRUCT
    
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
    
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
    
         ON ACTION about
            CALL cl_about()
    
         ON ACTION help
            CALL cl_show_help()
    
         ON ACTION controlg
            CALL cl_cmdask()
    
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(ima01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima22"
                  LET g_qryparam.state="c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima01
                  NEXT FIELD ima01
               WHEN INFIELD(bxe01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_bxe01"
                  LET g_qryparam.state="c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO bxe01
                  NEXT FIELD bxe01
               OTHERWISE
                  EXIT CASE
            END CASE
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
    
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
    
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r108_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
         EXIT PROGRAM
      END IF
      IF tm.wc = " 1=1" THEN
         CALL cl_err('','9046',0)       #本作業查詢條件不可空白 !
         CONTINUE WHILE
      END IF
    
      #條件選項
      INPUT BY NAME tm.bdate,tm.edate,tm.bxj21,tm.ima106,tm.h,
                    tm.yn,tm.desc,tm2.s1,tm2.s2,tm2.u1,tm2.u2
         WITHOUT DEFAULTS
 
         ON ACTION locale
            LET g_action_choice = "locale"
            EXIT INPUT
    
         AFTER FIELD bxj21
            IF NOT cl_null(tm.bxj21) THEN
               SELECT bxr02 INTO l_bxr02 
                 FROM bxr_file
                WHERE bxr01=tm.bxj21
               IF STATUS THEN
                  CALL cl_err('',STATUS,0)
                  LET l_bxr02 = ''
                  NEXT FIELD bxj21
               END IF
               DISPLAY l_bxr02 TO FORMONLY.bxr02
            END IF
 
         AFTER FIELD ima106
            IF NOT cl_null(tm.ima106) AND tm.ima106 NOT MATCHES '[1235679]' THEN
               NEXT FIELD ima106
            END IF
 
         AFTER FIELD h
            IF NOT cl_null(tm.h) AND tm.h NOT MATCHES '[YN]' THEN
               NEXT FIELD h
            END IF
 
         AFTER FIELD yn
            IF NOT cl_null(tm.yn) AND tm.yn NOT MATCHES '[YN]' THEN
               NEXT FIELD yn
            END IF
 
         AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF
            IF NOT cl_null(tm.bdate) AND NOT cl_null(tm.edate) THEN 
               IF tm.edate < tm.bdate THEN
                  CALL cl_err('','mfg9234',0)
                  NEXT FIELD bdate 
               END IF
            END IF
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
            LET tm.u = tm2.u1[1,1],tm2.u2[1,1]
    
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG 
            CALL cl_cmdask()  
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
      
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
    
         ON ACTION CONTROLP
            IF INFIELD(bxj21) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_bxr"
               LET g_qryparam.default1 = tm.bxj21
               CALL cl_create_qry() RETURNING tm.bxj21
               DISPLAY BY NAME tm.bxj21
    
               SELECT bxr02 INTO l_bxr02 
                 FROM bxr_file
                WHERE bxr01=tm.bxj21
 
               IF STATUS THEN    #撈不到資料，就給予空白
                  LET l_bxr02 = ''
               END IF
               DISPLAY l_bxr02 TO FORMONLY.bxr02
               NEXT FIELD bxj21
            END IF
    
      END INPUT
 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
    
      IF INT_FLAG THEN 
         LET INT_FLAG = 0 
         CLOSE WINDOW r108_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
         EXIT PROGRAM 
      END IF
    
      CALL cl_wait()
    
      CALL r108()
    
      ERROR ""
   END WHILE
   CLOSE WINDOW r108_w
END FUNCTION
 
FUNCTION r108()
   DEFINE l_name    LIKE type_file.chr20         # 執行檔案名
   DEFINE l_sql     STRING       # RDSQL STATEMENT
   DEFINE l_order   ARRAY[3] OF LIKE bxj_file.bxj04
   DEFINE sr   RECORD
            bxi01     LIKE bxi_file.bxi01,       #單據號碼
            bxi02     LIKE bxi_file.bxi02,       #異動日期
            bxj03     LIKE bxj_file.bxj03,       #序號
            bxj04     LIKE bxj_file.bxj04,       #料號
            bxj05     LIKE bxj_file.bxj05,       #單位
            bxj06     LIKE bxj_file.bxj06,       #數量
            ima01     LIKE ima_file.ima01,       #料件編號
            ima02     LIKE ima_file.ima02,       #品名
            ima021    LIKE ima_file.ima021,      #規格
            ima1916   LIKE ima_file.ima1916,
            bxe02     LIKE bxe_file.bxe02,
            bxe03     LIKE bxe_file.bxe03,
            bnd04     LIKE bnd_file.bnd04        #BOM編號
            #FUN-850089 By TSD.zeak ---start---
            ,bxz100   LIKE bxz_file.bxz100,
            bxz102    LIKE bxz_file.bxz102
            #FUN-850089 By TSD.zeak ----end----
            END RECORD
   
   #No.FUN-B80082--mark--Begin--- 
   #CALL cl_used('abxr108',g_time,1) RETURNING g_time
   #No.FUN-B80082--mark--End-----
   #FUN-850089 By TSD.zeak  ---start---  
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   #------------------------------ CR (2) ------------------------------#
   #FUN-850089 By TSD.zeak  ----end----  
  
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang  #抓公司名稱
 
    LET l_sql="SELECT  bxi01,bxi02,bxj03,bxj04, ",        #FUN-850089 By TSD.zeak add
             "  bxj05, bxj06,ima01,ima02,ima021,ima1916, ",
             "  bxe02,bxe03, ''",                        
             "  ,' ',' ' ",                              #FUN-850089 By TSD.zeak add 
             "  FROM ima_file,bxi_file,bxj_file,bxe_file",
             " WHERE ",tm.wc CLIPPED,            #QBE 
             "   AND bxj01 = bxi01 ",            #單頭檔=單身檔編號
             "   AND ima01 = bxj04 ",
             "   AND ima1916 = bxe01 ",            
             "   AND bxi02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'", #異動日期
             "   AND bxj21 = '",tm.bxj21,"'"           #折合原因代碼
 
   IF tm.ima106 <> '9' THEN
      LET l_sql = l_sql CLIPPED," AND ima106='",tm.ima106,"' "  #符合料件型態
   END IF
 
   IF tm.yn  = 'Y' THEN      #保稅料件否打勾
      LET l_sql = l_sql CLIPPED," AND ima15 = 'Y' "
   END IF
 
   LET l_sql = l_sql CLIPPED," ORDER BY ima01 "
 
   PREPARE r108_pre FROM l_sql
 
   IF STATUS THEN 
      CALL cl_err('r108_pre',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
      EXIT PROGRAM 
   END IF
   DECLARE r108_curs1 CURSOR WITH HOLD FOR r108_pre
 
   LET g_pageno =  0
   FOREACH r108_curs1 INTO sr.*
      IF STATUS THEN CALL cl_err('fore1:',STATUS,1) EXIT FOREACH END IF
 
      #用料清表文號:在abxi030依料號條件找出最接近交易年月的截止日期的BOM編號
      DECLARE cur_bnd CURSOR FOR
       SELECT bnd04 
         FROM bnd_file
        WHERE bnd01 =sr.bxj04       #時間介於生效時間與失效時間之間
          AND bnd02 <= sr.bxi02 
          AND sr.bxi02 <= bnd03
        ORDER BY bnd02 DESC
 
      OPEN cur_bnd
      FETCH cur_bnd INTO sr.bnd04
 
      IF STATUS THEN 
         LET sr.bnd04='' 
      END IF
 
     #FUN-850089 By TSD.zeak ---start---    
     LET sr.bxz100 = g_bxz.bxz100
     LET sr.bxz102 = g_bxz.bxz102
     EXECUTE insert_prep USING sr.bxi01,sr.bxi02, sr.bxj03,
                               sr.bxj04,sr.bxj05, sr.bxj06,  sr.ima01,
                               sr.ima02,sr.ima021,sr.ima1916,sr.bxe02,
                               sr.bxe03,sr.bnd04, sr.bxz100, sr.bxz102
     #FUN-850089 By TSD.zeak ----end---- 
   END FOREACH
 
   #FUN-850089 By TSD.zeak      ---start---
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-720005 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'zu01')
           RETURNING tm.wc
      LET g_str = tm.wc
   ELSE
      LET g_str = ''
   END IF
   LET g_str = g_str ,";",      
               tm.bdate USING 'YYYY/MM/DD',";",    #p2
               tm.edate USING 'YYYY/MM/DD',";",    #p3
               tm.ima106,";",                      #p4
               tm.h,";",                           #p5
               tm.desc,";",                        #p6
               tm.s[1,1],";",                      #p7
               tm.s[2,2],";",                      #p8
               tm.u[1,1],";",                      #p9
               tm.u[2,2]                           #p10
 
   CALL cl_prt_cs3('abxr108','abxr108',l_sql,g_str)   
   #------------------------------ CR (4) ------------------------------#
   #FUN-850089 By TSD.zeak  ----end----  
   
   #No.FUN-B80082--mark--Begin---
   #CALL cl_used('cbabx04',g_time,2) RETURNING g_time
   #No.FUN-B80082--mark--End-----
END FUNCTION
#No.FUN-870144
