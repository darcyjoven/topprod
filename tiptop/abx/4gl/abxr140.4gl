# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: abxr140.4gl
# Descriptions...: 內銷報稅彙總表
# Date & Author..: 96/08/23 By STAR 
# Modify.........: No.FUN-530012 05/03/21 By kim 報表轉XML功能
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換  
# Modify.........: No.FUN-690108 06/10/13 By xumin cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-740077 07/04/20 By TSD.liquor 報表改寫由Crystal Report產出
# Modify.........: No.TQC-780054 07/08/15 By xiaofeizhu 修改INSERT INTO temptable語法(不用ora轉換) 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000,   # Where condition #No.FUN-680062 VARCHAR(1000)
              yea     LIKE type_file.num5,                        #No.FUN-680062 SMALLINT
              mo      LIKE type_file.num5,                       #No.FUN-680062  SMALLINT
              more    LIKE type_file.chr1                        #No.FUN-680062  VARCHAR(1)
              END RECORD,
          g_mount       LIKE type_file.num10                     #No.FUN-680062  INTEGER
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680062 SMALLINT
DEFINE l_table        STRING                    #FUN-740077 add
DEFINE g_sql          STRING                    #FUN-740077 add
DEFINE g_str          STRING                    #FUN-740077 add
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690108
   
   #str FUN-740077 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "bnf01.bnf_file.bnf01,",
               "bnf01s.bnf_file.bnf01,",
               "ima15.ima_file.ima15,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "bnf09.bnf_file.bnf09,",
               "bnf11.bnf_file.bnf11,",
               "bnf12.bnf_file.bnf12"
 
   LET l_table = cl_prt_temptable('abxr140',g_sql) CLIPPED            # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                           # Temp Table產生
#  LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,              # TQC-780054
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,      # TQC-780054 
               " VALUES(?,?,?,?,?, ?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
   #end FUN-740077 add
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.yea = ARG_VAL(8)
   LET tm.mo    = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL abxr140_tm(4,15)        # Input print condition
      ELSE CALL abxr140()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
END MAIN
 
FUNCTION abxr140_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680062 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680062 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 8 LET p_col = 22
   ELSE LET p_row = 5 LET p_col = 12
   END IF
   OPEN WINDOW abxr140_w AT p_row,p_col
        WITH FORM "abx/42f/abxr140" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = '1=1' 
WHILE TRUE
   INPUT BY NAME tm.yea,tm.mo,tm.more 
   WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT INPUT
 
      AFTER FIELD yea
           IF cl_null(tm.yea) THEN NEXT FIELD yea END IF 
 
      AFTER FIELD mo
           IF cl_null(tm.mo) OR tm.mo >12 OR tm.mo < 1 THEN 
              NEXT FIELD mo 
           END IF 
 
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
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW abxr140_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='abxr140'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abxr140','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,      #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.yea     CLIPPED,"'",
                         " '",tm.mo      CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
                        
         CALL cl_cmdat('abxr140',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW abxr140_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL abxr140()
   ERROR ""
   DELETE FROM b1_temp 
END WHILE
   CLOSE WINDOW abxr140_w
END FUNCTION
 
FUNCTION abxr140()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name             #No.FUN-680062  VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0062
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680062 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-680062  VARCHAR(1)
          l_za05    LIKE za_file.za05,            #No.FUN-680062  VARCHAR(40)     
          l_year    LIKE type_file.num5,          #No.FUN-680062  smallint
          l_month   LIKE type_file.num5,          #No.FUN-680062  smallint
          l_mea01   LIKE mea_file.mea01,
          l_bnf01   LIKE bnf_file.bnf01,
          l_n       LIKE type_file.num5,          #No.FUN-680062  smallint
          l_count   LIKE type_file.num5,          #No.FUN-680062  smallint
          l_bnf12t  LIKE bnf_file.bnf12,  #--累計非保稅數---          #No.FUN-680062 decimal(14,3)
          sr           RECORD 
          mea01     LIKE mea_file.mea01,                               #No.FUN-680062 smallint
          bnf01     LIKE bnf_file.bnf01,                              #No.FUN-680062 VARCHAR(20)
          bnf01s    LIKE bnf_file.bnf01,                              #No.FUN-680062 VARCHAR(20)
          bnf02     LIKE bnf_file.bnf02,           {倉庫編號        }  #No.FUN-680062 VARCHAR(8)
          ima15     LIKE ima_file.ima15,                               #No.FUN-680062 VARCHAR(1)
          ima02     LIKE ima_file.ima02,
          ima021    LIKE ima_file.ima021,
          bnf09b    LIKE bnf_file.bnf09,{上期非保稅進貨數}
          bnf09     LIKE bnf_file.bnf09,{本期非保稅進貨數}
          bnf11     LIKE bnf_file.bnf11,{本期內銷累計數  }
          bnf12     LIKE bnf_file.bnf12,{本期結存非保稅數}
          bnf12t    LIKE bnf_file.bnf12 #--累計非保稅數---
                       END RECORD
 
     #str FUN-740077 add
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
     CALL cl_del_data(l_table)
     #------------------------------ CR (2) ------------------------------#
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'abxr140'
 
     LET g_pageno = 0
 
     DECLARE abxr140_curs1 CURSOR FOR 
     SELECT mea01,bnf01,mea02,bnf02,ima15,ima02,ima021,0,bnf09,bnf11,bnf12 ,0
            FROM bnf_file ,ima_file, OUTER mea_file 
            WHERE bnf01=ima01 AND bnf_file.bnf01=mea_file.mea02 AND bnf03 = tm.yea 
                  AND bnf04 = tm.mo {AND ima15 IN ('1','3') }
                  AND (bnf09<>0 OR bnf11<>0 OR bnf12<>0)
     LET l_mea01 = 0
     LET l_bnf12t = 0 
     FOREACH abxr140_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH 
       END IF
       #----不同的 Group -----
       IF cl_null(sr.bnf01s) THEN
          LET sr.bnf01s=sr.bnf01
       ELSE
          IF l_mea01 != sr.mea01 THEN
          LET l_bnf01 = sr.bnf01 END IF
          LET sr.bnf01s = l_bnf01
       END IF
     
       LET l_mea01 = sr.mea01
       # 若前面user 按下 control-t 則會顯示目前做到第 n 筆
 
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
      EXECUTE insert_prep USING
         sr.bnf01,sr.bnf01s,sr.ima15,sr.ima02,sr.ima021,sr.bnf09,
         sr.bnf11,sr.bnf12
      #------------------------------ CR (3) ------------------------------#
      #end FUN-740077 add
     END FOREACH
     #-----如有問題則不印了----
     IF STATUS THEN CALL cl_err('err Data',STATUS,0) RETURN END IF 
     #str FUN-740077 add
 
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
         LET g_str = tm.wc,";",tm.yea,";",tm.mo 
     END IF
     CALL cl_prt_cs3('abxr140','abxr140',l_sql,g_str)
   #------------------------------ CR (4) ------------------------------#
END FUNCTION
 
