# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcr104.4gl
# Descriptions...: 直接原料明細表
# Input parameter:
# Return code....:
# Date & Author..: 00/04/11 By Tommy
# Modify        .: 01/05/21 By Ostrich #No.+277
# Modify ........: No:8741 03/11/25 By Melody 修改PRINT段
# Modify ........: MOD-4A0351 04/11/01 By Carol sql中起迄年月的判斷有錯
#                                               報表排列調整 
# Modify.........: No.FUN-4C0099 04/12/27 By kim 報表轉XML功能
# Modify.........: No.MOD-530181 05/03/21 By kim Define金額單價位數改為DEC(20,6)
# Modify.........: No.FUN-570190 05/08/08 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.MOD-590022 05/09/07 By wujie 報表修改  
# Modify.........: No.TQC-5B0019 05/11/08 By Sarah 出表時,(接下頁),(結束)的位置沒有印在一列的最後面
# Modify.........: No.TQC-610051 06/02/13 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-670058 06/07/18 By Sarah 增加抓拆件式工單資料(cct_file,ccu_file)
# Modify.........: No.FUN-680007 06/08/03 By Sarah 將之前FUN-670058多抓cct_file的部份remove
# Modify.........: No.FUN-680122 06/08/31 By zdyllq 類型轉換  
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-690007 06/12/08 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.TQC-770088 07/07/31 By Rayven 報表第四行"年度期別"顯示的數據與所下條件時的年度期別數據不符(少加了11年)
# Modify.........: No.FUN-780017 07/08/02 By dxfwo CR報表的制作
# Modify.........: No.FUN-7C0101 08/01/24 By shiwuying 成本改善，CR增加類別編號ccg07
# Modify.........: No.FUN-850132 08/05/23 By zhaijie CR BUG修改
# Modify.........: No.MOD-940343 09/05/21 By Pengu 成品生產數量異常
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-970003 09/12/01 By jan 批次成本修改
# Modify.........: No.FUN-a40023 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No.TQC-A40130 10/04/27 By Carrier MOD-970107 追单
# Modify.........: No:CHI-C30012 12/07/27 By bart 金額取位改抓ccz26

DATABASE ds
GLOBALS "../../config/top.global"
DEFINE tm    RECORD                     # Print condition RECORD
              wc      LIKE type_file.chr1000,       #No.FUN-680122CHAR(600),        # Where condition
              yy1,yy2 LIKE type_file.num5,          #No.FUN-680122SMALLINT,
              m1,m2   LIKE type_file.num5,          #No.FUN-680122SMALLINT,
              type    LIKE ccg_file.ccg06,          #No.FUN-7C0101 add
              n       LIKE type_file.chr1,          #No.FUN-680122CHAR(1)
              more    LIKE type_file.chr1           #No.FUN-680122CHAR(1)           # Input more condition(Y/N)
             END RECORD,
       g_tot_bal      LIKE type_file.num20_6        #No.FUN-680122DECIMAL(20,6)     # User defined variable
DEFINE g_i            LIKE type_file.num5           #No.FUN-680122SMALLINT         #count/index for any purpose
DEFINE l_table             STRING                   #No.FUN-780017                                                                    
DEFINE g_sql               STRING                   #No.FUN-780017                                                                    
DEFINE g_str               STRING                   #No.FUN-780017 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo 
#No.FUN-780017---Begin                                                                                                              
   LET g_sql = " ccg04.ccg_file.ccg04,",
               " l_ima02_1.ima_file.ima02,",
               " l_ima021_1.ima_file.ima021,",
               "ccg07.ccg_file.ccg07,",      #No.FUN-7C0101 add
               " ccg21.ccg_file.ccg21,",
               " cch04.cch_file.cch04,",                                                                                            
               " l_ima02_2.ima_file.ima02,",
               " l_ima021_2.ima_file.ima021,",
               " cch21.cch_file.cch21,",
               " cch22.cch_file.cch22 "                                                                                                                                                                                            
   LET l_table = cl_prt_temptable('axcr104',g_sql) CLIPPED                                                                  
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                    
              # " VALUES(?,?,?,?,?,?,?,?,?)"    #No.FUN-7C0101
               " VALUES(?,?,?,?,?,?,?,?,?, ?)"  #No.FUN-7C0101
   PREPARE insert_prep FROM g_sql                                                                                           
   IF STATUS THEN                                                                                                           
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                     
   END IF                                                                                                                   
#No.FUN-780017---End
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.n = ARG_VAL(8)
   #TQC-610051-begin
   LET tm.yy1= ARG_VAL(9)
   LET tm.m1 = ARG_VAL(10)
   LET tm.yy2 = ARG_VAL(11)
   LET tm.m2 = ARG_VAL(12)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(9)
   #LET g_rep_clas = ARG_VAL(10)
   #LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   ##No.FUN-570264 ---end---
   #TQC-610051-end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL axcr104_tm(0,0)        # Input print condition
      ELSE CALL axcr104()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr104_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,           #No.FUN-680122 SMALLINT
          l_cmd          LIKE type_file.chr1000         #No.FUN-680122CHAR(400) 
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   LET p_row = 6 LET p_col = 20
   OPEN WINDOW axcr104_w AT p_row,p_col WITH FORM "axc/42f/axcr104" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.n    = 'Y'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.type = g_ccz.ccz28     #No.FUN-7C0101 add
   LET tm.yy1=year(g_today)
   LET tm.m1=month(g_today)
   LET tm.yy2=year(g_today)
   LET tm.m2=month(g_today)
 
   WHILE TRUE
     CONSTRUCT BY NAME tm.wc ON ccg04,ccg01
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr104_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
 
   IF tm.wc = ' 1=1' THEN CALL cl_err('',9046,0) CONTINUE WHILE END IF
 
   INPUT BY NAME tm.yy1,tm.m1,tm.yy2,tm.m2,tm.type,tm.n ,tm.more #No.FUN-7C0101 add tm.type
                 WITHOUT DEFAULTS 
      #No.FUN-580031 --start--
      BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 ---end---
 
      AFTER FIELD yy1
         IF cl_null(tm.yy1) THEN NEXT FIELD yy1 END IF
      AFTER FIELD m1
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.m1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy1
            IF g_azm.azm02 = 1 THEN
               IF tm.m1 > 12 OR tm.m1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1
               END IF
            ELSE
               IF tm.m1 > 13 OR tm.m1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
         IF cl_null(tm.m1) THEN NEXT FIELD m1 END IF
#
      AFTER FIELD yy2
         IF cl_null(tm.yy2) THEN NEXT FIELD yy2 END IF
         IF tm.yy2 < tm.yy1 THEN NEXT FIELD yy2 END IF
      AFTER FIELD m2
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.m2) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy2
            IF g_azm.azm02 = 1 THEN
               IF tm.m2 > 12 OR tm.m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            ELSE
               IF tm.m2 > 13 OR tm.m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
         IF cl_null(tm.m2) THEN NEXT FIELD m2 END IF
      AFTER FIELD n
         IF cl_null(tm.n) THEN NEXT FIELD n END IF
         IF tm.n NOT MATCHES '[YN]' THEN NEXT FIELD n END IF
 
      AFTER FIELD type                                               #No.FUN-7C0101 add          
         IF tm.type NOT MATCHES '[12345]' THEN NEXT FIELD type END IF#No.FUN-7C0101 add      
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG 
         CALL cl_cmdask()    # Command execution
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
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF tm.yy2 < tm.yy1 THEN NEXT FIELD yy2 END IF
         IF tm.yy2 = tm.yy1 THEN 
            IF tm.m1 > tm.m2 THEN 
               NEXT FIELD m2 
            END IF
         END IF
 
      #No.FUN-580031 --start--
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW axcr104_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
       WHERE zz01='axcr104'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr104','9031',1)   
      ELSE
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.n CLIPPED,"'",
                         #TQC-610051-begin
                         " '",tm.yy1 CLIPPED,"'",
                         " '",tm.m1 CLIPPED,"'",
                         " '",tm.yy2 CLIPPED,"'",
                         " '",tm.m2 CLIPPED,"'",
                         #TQC-610051-end
                         " '",tm.type CLIPPED,"'" ,             #No.FUN-7C0101 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axcr104',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr104_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr104()
   ERROR ""
END WHILE
   CLOSE WINDOW axcr104_w
END FUNCTION
 
#No.8741
FUNCTION axcr104()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680122  VARCHAR(20),        # External(Disk) file name
          l_time    LIKE cre_file.cre08,           #No.FUN-680122   VARCHAR(8),       # Used time for running the job
          l_sql     STRING,   #CHAR(1500),      # RDSQL STATEMENT   #FUN-670058 modify
          l_za05    LIKE type_file.chr1000,        #No.FUN-680122 VARCHAR(40)
#          qty1      LIKE ima_file.ima26,           #No.FUN-680122DEC(15,3),  #FUN-A40023
          qty1      LIKE type_file.num15_3,           #No.FUN-680122DEC(15,3),  #FUN-A40023
          amt1      LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
          l_ima02_1  LIKE ima_file.ima02,
          l_ima021_1 LIKE ima_file.ima021,
          l_ima25_1  LIKE ima_file.ima25,
          l_ima02_2  LIKE ima_file.ima02,
          l_ima021_2 LIKE ima_file.ima021,
          l_ima25_2  LIKE ima_file.ima25,
          l_count    LIKE type_file.num5,           #No.FUN-680122SMALLINT
          sr        RECORD
                       ccg04 LIKE ccg_file.ccg04,
                       ccg07 LIKE ccg_file.ccg07,   #No.FUN-7C0101 add
                       ccg21 LIKE ccg_file.ccg21,
                       cch04 LIKE cch_file.cch04,
                       cch21 LIKE cch_file.cch21,
                       cch22 LIKE cch_file.cch22
                    END RECORD
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   LET l_sql = "SELECT ccg04,ccg07,SUM(ccg21),cch04,SUM(cch21),SUM(cch22) ", #No.FUN-7C0101 add ccg07
                      # Product         part-no
               " FROM ccg_file,cch_file",
               " WHERE ccg01 = cch01 AND ccg02 = cch02 AND ccg03 = cch03 ",
              # " AND ccg06 = cch06 AND ccg07 = cch06 ",     #No.FUN-7C0101 add
              #" AND ccg06 = cch06 AND ccg07 = cch07 ",      #No.FUN-850132 #TQC-970003
               " AND ccg06 = cch06 ",   #TQC-970003
               " AND cch04 <> ' DL+OH+SUB' ",
 #MOD-4A0351
               " AND ( ccg02*12+ccg03 BETWEEN ",tm.yy1*12+tm.m1," AND ",
                 tm.yy2*12+tm.m2," ) AND ",tm.wc CLIPPED,
 ##
               " AND ccg06 = '",tm.type,"'",                #No.FUN-7C0101 add
           #    " GROUP BY 1,3 "                            #No.FUN-7C0101
               " GROUP BY ccg04,ccg07,cch04"                           #No.FUN-7C0101
 
   PREPARE axcr104_pr FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM 
   END IF
   DECLARE axcr104_cs1 CURSOR FOR axcr104_pr
 
  #--------------No.MOD-940343 add
   LET l_sql = " SELECT SUM(ccg21) FROM ccg_file ",
               " WHERE ccg04=  ? ",
               " AND ( ccg02*12+ccg03 BETWEEN ",tm.yy1*12+tm.m1," AND ",
                 tm.yy2*12+tm.m2," ) AND ",tm.wc CLIPPED
 
   PREPARE r104_ccg21 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE r104_ccg21_c1 CURSOR FOR r104_ccg21
  #--------------No.MOD-940343 end
#  CALL cl_outnam('axcr104') RETURNING l_name                          #No.FUN-780017 
#  START REPORT axcr104_rep TO l_name                                  #No.FUN-780017 
   CALL cl_del_data(l_table)                                           #No.FUN-780017
   LET g_pageno = 0
   FOREACH axcr104_cs1 INTO sr.*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
     #-----------------No.MOD-940343  add
      OPEN r104_ccg21_c1 USING sr.ccg04
      FETCH r104_ccg21_c1 INTO sr.ccg21
      IF cl_null(sr.ccg21) THEN LET sr.ccg21 = 0 END IF
     #-----------------No.MOD-940343  end
      LET l_count = 1                                                                                                               
      SELECT ima02,ima021,ima25 INTO l_ima02_1,l_ima021_1,l_ima25_1                                                                 
        FROM ima_file                                                                                                               
       WHERE ima01 = sr.ccg04                                                                                                       
      IF STATUS THEN                                                                                                                
         LET l_ima02_1 = ''                                                                                                         
         LET l_ima021_1 = ''                                                                                                        
         LET l_ima25_1 = ''                                                                                                         
      END IF                 
      IF tm.n = 'Y' THEN                                                                                                            
         SELECT ima02,ima021,ima25 INTO l_ima02_2,l_ima021_2,l_ima25_2                                                              
           FROM ima_file                                                                                                            
          WHERE ima01 = sr.cch04                                                                                                    
         IF STATUS THEN                                                                                                             
            LET l_ima02_2 = ''                                                                                                      
            LET l_ima021_2 = ''                                                                                                     
            LET l_ima25_2 = ''                                                                                                      
         END IF
      END IF                 
#     OUTPUT TO REPORT axcr104_rep(sr.*)                               #No.FUN-780017
#     EXECUTE insert_prep USING sr.ccg04,sr.ccg07,l_ima02_1,l_ima021_1,sr.ccg21,sr.cch04, #No.FUN-7C0101 add ccg07  #No.TQC-A40130
      EXECUTE insert_prep USING sr.ccg04,l_ima02_1,l_ima021_1,sr.ccg07,sr.ccg21,sr.cch04, #No.FUN-7C0101 add ccg07  #No.TQC-A40130
      l_ima02_2,l_ima021_2,sr.cch21,sr.cch22 
   END FOREACH
   CLOSE r104_ccg21_c1    #No.MOD-940343  add
#No.FUN-780017---Begin 
#  FINISH REPORT axcr104_rep
 
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05 = 'Y' THEN                                                        
      CALL cl_wcchp(tm.wc,'ccg04,ccg01')         
           RETURNING tm.wc                                                     
   END IF
   LET g_str = tm.wc,";",tm.yy1,";",tm.m1,";",tm.yy2,";",tm.m2,";",tm.n,";",
               #g_ccz.ccz27,";", g_azi03,";",tm.type     #CHI-C30012
               g_ccz.ccz27,";", g_ccz.ccz26,";",tm.type  #CHI-C30012
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED   
#No.FUN-7C0101-------------BEGIN-----------------
   #CALL cl_prt_cs3('axcr104','axcr104',l_sql,g_str)
   IF tm.type MATCHES '[12]' THEN
      CALL cl_prt_cs3('axcr104','axcr104_1',l_sql,g_str)
   END IF
   IF tm.type MATCHES '[345]' THEN
      CALL cl_prt_cs3('axcr104','axcr104',l_sql,g_str)
   END IF
#No.FUN-7C0101--------------END------------------
#No.FUN-780017---End
END FUNCTION
 
{                                                   #No.FUN-780017 
REPORT axcr104_rep(sr)
#   DEFINE qty        LIKE ima_file.ima26,           #No.FUN-680122DEC(15,3),  #FUN-A40023
   DEFINE qty        LIKE type_file.num15_3,           #No.FUN-680122DEC(15,3),  #FUN-A40023
          u_p        LIKE oeb_file.oeb13,           #No.FUN-680122DEC(20,6)
          amt        LIKE type_file.num20_6         #No.FUN-680122 DECIMAL(20,6)
   DEFINE l_last_sw  LIKE type_file.chr1,           #No.FUN-680122CHAR(1)
          sr         RECORD
                        ccg04 LIKE ccg_file.ccg04,
                        ccg21 LIKE ccg_file.ccg21,
                        cch04 LIKE cch_file.cch04,
                        cch21 LIKE cch_file.cch21,
                        cch22 LIKE cch_file.cch22
                     END RECORD,
          l_ima02_1  LIKE ima_file.ima02,
          l_ima021_1 LIKE ima_file.ima021,
          l_ima25_1  LIKE ima_file.ima25,
          l_ima02_2  LIKE ima_file.ima02,
          l_ima021_2 LIKE ima_file.ima021,
          l_ima25_2  LIKE ima_file.ima25,
          l_amt1     LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
          l_amt2     LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
#          l_qty      LIKE ima_file.ima26,           #No.FUN-680122DEC(15,3), #FUN-A40023
          l_qty      LIKE type_file.num15_3,          #FUN-A40023
          l_count    LIKE type_file.num5,           #No.FUN-680122SMALLINT
          l_chr      LIKE type_file.chr1            #No.FUN-680122 VARCHAR(1)
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.ccg04 , sr.cch04
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT #No.TQC-770088
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
#No.TQC-770088 --start--
#     PRINT g_head CLIPPED,pageno_total
#     PRINT (tm.yy1-1911) USING '##',g_x[11] CLIPPED,tm.m1 USING '##',
#           g_x[12] CLIPPED,(tm.yy2-1911) USING '##',g_x[11] CLIPPED,
      PRINT tm.yy1 USING '####',g_x[11] CLIPPED,tm.m1 USING '##',
            g_x[12] CLIPPED,tm.yy2 USING '####',g_x[11] CLIPPED,
#No.TQC-770088 --end--
            tm.m2 USING '##',g_x[13] CLIPPED
      PRINT g_head CLIPPED,pageno_total  #No.TQC-770088
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.ccg04   ## Product
      LET l_count = 1
      SELECT ima02,ima021,ima25 INTO l_ima02_1,l_ima021_1,l_ima25_1
        FROM ima_file
       WHERE ima01 = sr.ccg04
      IF STATUS THEN
         LET l_ima02_1 = ''
         LET l_ima021_1 = ''
         LET l_ima25_1 = ''
      END IF
      PRINT COLUMN g_c[31],sr.ccg04 CLIPPED,
            COLUMN g_c[32],l_ima02_1 CLIPPED,
            COLUMN g_c[33],l_ima021_1 CLIPPED,
            COLUMN g_c[34],cl_numfor(sr.ccg21,34,0);
 
   ON EVERY ROW
      IF tm.n = 'Y' THEN
         SELECT ima02,ima021,ima25 INTO l_ima02_2,l_ima021_2,l_ima25_2
           FROM ima_file
          WHERE ima01 = sr.cch04
         IF STATUS THEN
            LET l_ima02_2 = ''
            LET l_ima021_2 = ''
            LET l_ima25_2 = ''
         END IF
         PRINT COLUMN g_c[35],sr.cch04 CLIPPED,
               COLUMN g_c[36],l_ima02_2,
               COLUMN g_c[37],l_ima021_2,
               COLUMN g_c[38],cl_numfor((sr.cch22/sr.cch21),38,g_azi03),
               COLUMN g_c[39],cl_numfor(sr.cch21,39,g_ccz.ccz27), #CHI-690007 2->g_ccz.ccz27
               COLUMN g_c[40],cl_numfor(sr.cch22,40,g_azi03)    #FUN-570190
      END IF
 
   AFTER GROUP OF sr.ccg04    # Product
      LET l_amt1 = GROUP SUM(sr.cch21)
      LET l_amt2 = GROUP SUM(sr.cch22)
      PRINT COLUMN g_c[37],g_x[9] CLIPPED,
            COLUMN g_c[39],cl_numfor(l_amt1,39,g_ccz.ccz27),       #MOD-590022 #CHI-690007 2->g_ccz.ccz27
            COLUMN g_c[40],cl_numfor(l_amt2,40,g_azi03)    #FUN-570190        #MOD-590022
      PRINT g_dash2
 
   ON LAST ROW
      LET l_amt1 = SUM(sr.cch21)
      LET l_amt2 = SUM(sr.cch22)
      PRINT COLUMN g_c[37],g_x[10] CLIPPED,
            COLUMN g_c[39],cl_numfor(l_amt1,38,g_ccz.ccz27), #CHI-690007 2->g_ccz.ccz27
            COLUMN g_c[40],cl_numfor(l_amt2,39,g_azi03)    #FUN-570190
      PRINT g_dash
      LET l_last_sw = 'y'
     #PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[40],g_x[7] CLIPPED     #TQC-5B0019 mark
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),g_x[7] CLIPPED   #TQC-5B0019
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
             #PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[40],g_x[6] CLIPPED     #TQC-5B0019 mark
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),g_x[6] CLIPPED   #TQC-5B0019
         ELSE SKIP 2 LINE
      END IF
#No.8741(END)
END REPORT     }                                         #No.FUN-780017
