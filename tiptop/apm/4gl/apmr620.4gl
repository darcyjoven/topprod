# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apmr620.4gl
# Descriptions...: 交貨數量統計分析表
# Input parameter:
# Return code....:
# Date & Author..: 93/02/03 By Franky
# Modify.........: No.FUN-4C0095 05/01/05 By Mandy 報表轉XML
# Modify.........: No.FUN-570243 05/07/25 By Trisy 料件編號開窗
# Modify.........: No.FUN-580004 05/08/08 By jackie 雙單位報表修改
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: NO.FUN-680136 06/09/05 By jackho 欄位型態修改，改為LIKE
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-720010 07/02/07 By TSD.Hazel 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/28 By Sarah CR報表串cs3()增加傳一個參數,增加數字取位的處理
# Modify.........: No.TQC-790064 07/09/13 By mike 語言功能無效轉有效
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580004 --start--
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17   #FUN-560079
  DEFINE g_seq_item     LIKE type_file.num5   #FUN-680136 SMALLINT
  DEFINE l_table        STRING,                 ### FUN-720010 ###
         g_str          STRING,                 ### FUN-720010 ###
         g_sql          STRING                  ### FUN-720010 ###
END GLOBALS
#No.FUN-580004 --end--
 
  DEFINE tm  RECORD                              # Print condition RECORD
            #wc      VARCHAR(500),                  # Where condition             #TQC-630166 mark
             wc      STRING,                     # Where condition             #TQC-630166
             a       LIKE type_file.chr1,        # No.FUN-680136 VARCHAR(1)
             more    LIKE type_file.chr1         # No.FUN-680136 VARCHAR(1)       # Input more condition(Y/N)
             END RECORD
 
  DEFINE g_i         LIKE type_file.num5         #count/index for any purpose  #No.FUN-680136 SMALLINT
#No.FUN-580004 --start--
  DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680136 INTEGER
  DEFINE   g_sma115        LIKE sma_file.sma115
  DEFINE   g_sma116        LIKE sma_file.sma116
#No.FUN-580004 --end--
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
 
   #str FUN-720010 add
   ## *** FUN-720010 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> TSD.Martin  *** ##
   LET g_sql = "l_order.type_file.chr20, ",
               "pmm01.pmm_file.pmm01,",     #採購單號
               "pmn02.pmn_file.pmn02,",     #項次
               "pmn04.pmn_file.pmn04,",     #料號
               "pmn041.pmn_file.pmn041,",   #品名
               "pmn07.pmn_file.pmn07,",     #單位
               "pmn20.pmn_file.pmn20,",     #訂購量
               "pmn50_50.pmn_file.pmn50,",  #已交量
               "rva01.rva_file.rva01,",     #驗收單號
               "rvb02.rvb_file.rvb02,",     #驗收項次
               "rva06.rva_file.rva06,",     #收貨日期
               "rvb07.rvb_file.rvb07,",     #收貨數量
               "rvaconf.rva_file.rvaconf,", #確認否
               "pmn80.pmn_file.pmn80,",     #單位一
               "pmn82.pmn_file.pmn82,",     #單位一數量
               "pmn83.pmn_file.pmn83,",     #單位二
               "pmn85.pmn_file.pmn85,",     #單位二數量
               "ima021.ima_file.ima021,",   #規格
               "ima906.ima_file.ima906,",   #單位使用方式
               "str2.type_file.chr20"       #pmn85 + pmn83
 
   LET l_table = cl_prt_temptable('apmr620',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?,   ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?,   ?, ?, ?, ?, ? )"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #----------------------------------------------------------CR (1) ------------#
   #end FUN-720010 add
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL apmr620_tm(0,0)        # Input print condition
      ELSE CALL apmr620()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION apmr620_tm(p_row,p_col)
   DEFINE lc_qbe_sn    LIKE gbm_file.gbm01          #No.FUN-580031
   DEFINE p_row,p_col  LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_dir        LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1)
          l_cmd        LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW apmr620_w AT p_row,p_col WITH FORM "apm/42f/apmr620"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.a= '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pmm01,pmn04,pmm04     #ON ACTION locale  #TQC-790064 MARK
 
#No.TQC-790064  --STR
         ON ACTION locale
            CALL cl_show_fld_cont()                                                                               
            LET g_action_choice = "locale"                                                                                             
            EXIT CONSTRUCT 
#No.TQC-790064  --END
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
#No.FUN-570243 --start--
      ON ACTION CONTROLP
            IF INFIELD(pmn04) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmn04
               NEXT FIELD pmn04
            END IF
#No.FUN-570243 --end--
 
#No.TQC-790064 --STR
{         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
}
#No.TQC-790064  --END
 
 
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE CONSTRUCT
 
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
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW apmr620_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1 " THEN CALL cl_err(' ','9046',0) CONTINUE WHILE END IF
   DISPLAY BY NAME tm.a,tm.more          # Condition
   INPUT BY NAME tm.a,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES "[12]"
            THEN NEXT FIELD a
         END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
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
      LET INT_FLAG = 0 CLOSE WINDOW apmr620_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='apmr620'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr620','9031',1)
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
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apmr620',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW apmr620_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmr620()
   ERROR ""
END WHILE
   CLOSE WINDOW apmr620_w
END FUNCTION
 
FUNCTION apmr620()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name                 #No.FUN-680136 VARCHAR(20)
          l_time    LIKE type_file.chr8,          # Used time for running the job            #No.FUN-680136 VARCHAR(8)
         #l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT       #TQC-630166 mark   #No.FUN-680136 VARCHAR(1000)
          l_sql     STRING,                       # RDSQL STATEMENT       #TQC-630166
          l_chr     LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680136 VARCHAR(40)
          l_order   LIKE aaf_file.aaf03,          #No.FUN-680136 VARCHAR(40) #FUN-5B0105 24->40
          i         LIKE type_file.num5,          #NO.FUN-580004          #No.FUN-680136 SMALLINT
          sr               RECORD
                            l_order   LIKE aaf_file.aaf03,  #No.FUN-680136 VARCHAR(40)        
                            pmm01     LIKE pmm_file.pmm01,  #採購單號
                            pmn02     LIKE pmn_file.pmn02,  #項次
                            pmn04     LIKE pmn_file.pmn04,  #料號
                            pmn041    LIKE pmn_file.pmn041, #品名
                            pmn07     LIKE pmn_file.pmn07,  #單位
                            pmn20     LIKE pmn_file.pmn20,  #訂購量
                            pmn50_55  LIKE pmn_file.pmn50,  #已交量
                            rva01     LIKE rva_file.rva01,  #驗收單號
                            rvb02     LIKE rvb_file.rvb02,  #驗收項次
                            rva06     LIKE rva_file.rva06,  #收貨日期
                            rvb07     LIKE rvb_file.rvb07,  #收貨數量
                            rvaconf   LIKE rva_file.rvaconf,#確認否
                            pmn80     LIKE pmn_file.pmn80,  #單位一
                            pmn82     LIKE pmn_file.pmn82,  #      數量
                            pmn83     LIKE pmn_file.pmn83,  #單位二
                            pmn85     LIKE pmn_file.pmn85,  #      數量
                            ima021    LIKE ima_file.ima021, #規格
                            ima906    LIKE ima_file.ima906, #單位使用方式
                            str2      LIKE ima_file.ima021 
                        END RECORD
     DEFINE l_i,l_cnt     LIKE type_file.num5          #No.FUN-680136 SMALLINT
     DEFINE l_zaa02       LIKE zaa_file.zaa02
     DEFINE l_pmn85        STRING
     DEFINE l_pmn82        STRING
 
   #str FUN-720010 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-720010 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
   #end FUN-720010 add
 
   SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file   #FUN-580004
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-720010 add ###
 
   LET l_sql = "SELECT '',pmm01,pmn02,pmn04,pmn041,pmn07,pmn20,",
               "       (pmn50-pmn55), ",
               "       rva01,rvb02,rva06,rvb07,rvaconf, ",
               "       pmn80,pmn82,pmn83,pmn85,'','','' ", #No.FUN-580004
               "  FROM pmm_file,pmn_file, ",
               " rvb_file LEFT OUTER JOIN rva_file ON rva01 = rvb01",
               " WHERE pmm01 = pmn01 AND pmn01=rvb04 AND pmn02=rvb03 ",
               " AND pmm18 !='X' ",
               " AND rvaconf !='X' AND ",tm.wc
   PREPARE apmr620_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   DECLARE apmr620_curs1 CURSOR FOR apmr620_prepare1
 
   LET g_pageno = 0
   FOREACH apmr620_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET sr.l_order = tm.a 
      IF cl_null(sr.pmn04) THEN LET sr.pmn04 = ' ' END IF 
      IF cl_null(sr.pmn041) THEN LET sr.pmn041 = ' ' END IF 
      IF cl_null(sr.pmn07) THEN LET sr.pmn07 = ' ' END IF 
      IF cl_null(sr.pmn20) THEN LET sr.pmn20 = 0 END IF 
      IF cl_null(sr.pmn50_55) THEN LET sr.pmn50_55 = 0 END IF 
      IF cl_null(sr.rvb07) THEN LET sr.rvb07 = 0 END IF 
      IF cl_null(sr.pmn80) THEN LET sr.pmn80 = ' ' END IF 
      IF cl_null(sr.pmn83) THEN LET sr.pmn83 = ' ' END IF 
      IF cl_null(sr.pmn82) THEN LET sr.pmn82 = 0 END IF 
      IF cl_null(sr.pmn85) THEN LET sr.pmn85 = 0 END IF 
      #取得ima_file
      SELECT ima021,ima906 INTO sr.ima021,sr.ima906 FROM ima_file
       WHERE ima01 = sr.pmn04
         AND imaacti = 'Y'
      #取得str2
      LET l_pmn85 = 0   #單位二數量
      IF g_sma115 = "Y" THEN
         CASE sr.ima906
            WHEN "2"
               CALL cl_remove_zero(sr.pmn85) RETURNING l_pmn85
               LET sr.str2 = l_pmn85 , sr.pmn83 CLIPPED
               IF cl_null(sr.pmn85) OR sr.pmn85 = 0 THEN
                  CALL cl_remove_zero(sr.pmn82) RETURNING l_pmn82
                  LET sr.str2 = l_pmn82, sr.pmn80 CLIPPED
               ELSE
                  IF NOT cl_null(sr.pmn82) AND sr.pmn82 > 0 THEN
                     CALL cl_remove_zero(sr.pmn82) RETURNING l_pmn82
                     LET sr.str2 = sr.str2 CLIPPED,',',l_pmn82, sr.pmn80 CLIPPED
                  END IF
               END IF
            WHEN "3"
               IF NOT cl_null(sr.pmn85) AND sr.pmn85 > 0 THEN
                  CALL cl_remove_zero(sr.pmn85) RETURNING l_pmn85
                  LET sr.str2 = l_pmn85 , sr.pmn83 CLIPPED
               END IF
         END CASE
      END IF
 
      #str FUN-720010 add
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-720010 *** ##
      EXECUTE insert_prep USING 
              sr.l_order,sr.pmm01,sr.pmn02,sr.pmn04,sr.pmn041,
              sr.pmn07,sr.pmn20,sr.pmn50_55,sr.rva01,sr.rvb02,
              sr.rva06,sr.rvb07,sr.rvaconf,sr.pmn80,sr.pmn82,
              sr.pmn83,sr.pmn85,sr.ima021,sr.ima906,sr.str2
      #------------------------------ CR (3) ------------------------------#
      #end FUN-720010 add
   END FOREACH
     
   #str FUN-720010 add
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-720010 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   LET g_str = ''
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'pmm01,pmn04,pmm04') 
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   LET g_str = g_str,";",tm.a,";",g_sma115
   IF g_sma115 = 'Y' THEN 
      CALL cl_prt_cs3('apmr620','apmr620_1',l_sql,g_str) #多單位   #FUN-710080 modify
   ELSE    
      CALL cl_prt_cs3('apmr620','apmr620',l_sql,g_str)             #FUN-710080 modify
   END IF 
   #------------------------------ CR (4) ------------------------------#
   #end FUN-720010 add
 
END FUNCTION
