# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: amsr513.4gl
# Descriptions...: MPS 請採購資料調整明細表
# Input parameter: 
# Return code....: 
# Date & Author..: 96/06/10 By Roger
# Modify.........: No.FUN-510036 05/01/19 By pengu 報表轉XML
# Modify.........: No.FUN-550056 05/05/20 By Trisy 單據編號加大
# Modify.........: No.FUN-570240 05/07/26 By Trisy 料件編號開窗 
# Modify.........: No.TQC-5C0059 05/12/12 By kevin 欄位沒對齊
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610075 06/01/24 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680101 06/08/30 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-690116 06/10/16 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0081 06/11/06 By atsea l_time轉g_time
# Modify.........: No.FUN-750097 07/06/22 By cheunl 報表改寫為CR報表
# Modify.........: No.TQC-970257 09/07/24 By dxfwo  這支程序在塞數據cr的temp table 時，對于mpt08有幾處都是塞' ' (中間有空白的值)，
#           因為mpt08是數字字段這樣會造成-6372的問題，請''中間不要留空白(null)或塞0
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc      LIKE type_file.chr1000,#NO.FUN-680101 VARCHAR(600)    # Where condition
             #n       VARCHAR(1),               #TQC-610075 
              ver_no  LIKE mps_file.mps_v,   #NO.FUN-680101 VARCHAR(2)
              edate   LIKE type_file.dat,    #NO.FUN-680101 DATE  
              more    LIKE type_file.chr1    #NO.FUN-680101 VARCHAR(1)      # Input more condition(Y/N)
              END RECORD
 
DEFINE   g_i          LIKE type_file.num5    #NO.FUN-680101 SMALLINT     #count/index for any purpose
DEFINE   g_head1         STRING
DEFINE l_table        STRING                 #No.FUN-750097                                                                         
DEFINE g_str          STRING                 #No.FUN-750097                                                                         
DEFINE g_sql          STRING                 #No.FUN-750097
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AMS")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690116
#No.FUN-750097 -----------start-----------------                                                                                    
    LET g_sql = " ima02.ima_file.ima02,",   
                " ima25.ima_file.ima25,",
                " ima43.ima_file.ima43,",
                " pmm09.pmm_file.pmm09,",
                " pmc03.pmc_file.pmc03,",
                " gen02.gen_file.gen02,",
                " mpt04.mpt_file.mpt04,",
                " mpt06.mpt_file.mpt06,",
                " mpt061.mpt_file.mpt061,",
                " mpt08.mpt_file.mpt08,",
                " mps00.mps_file.mps00,",
                " mps01.mps_file.mps01,",
                " mps03.mps_file.mps03,",
                " mps041.mps_file.mps041,",
                " mps043.mps_file.mps043,",
                " mps044.mps_file.mps044,",
                " mps051.mps_file.mps051,",
                " mps052.mps_file.mps052,",
                " mps053.mps_file.mps053,",
                " mps063.mps_file.mps063,",
                " mps064.mps_file.mps064,",
                " mps065.mps_file.mps065,",
                " mps08.mps_file.mps08,",
                " mps09.mps_file.mps09 " 
    LET l_table = cl_prt_temptable('amsr513',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                           
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",                                                                          
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? )"                                                                                  
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
#No.FUN-750097---------------end------------ 
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.ver_no = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob='N'        # If background job sw is off
      THEN CALL amsr513_tm(0,0)        # Input print condition
      ELSE CALL amsr513()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION amsr513_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01      #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,     #NO.FUN-680101 SMALLINT
          l_cmd          LIKE type_file.chr1000   #NO.FUN-680101 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 13 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 6 LET p_col = 17
   ELSE LET p_row = 4 LET p_col = 13
   END IF
   OPEN WINDOW amsr513_w AT p_row,p_col
        WITH FORM "ams/42f/amsr513" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
  #LET tm.n    = '2'                  #TQC-610075
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON mps01,ima08,ima67,ima43 
#No.FUN-570240 --start--                                                                                    
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION CONTROLP                                                                                              
            IF INFIELD(mps01) THEN                                                                                                  
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form = "q_ima"                                                                                       
               LET g_qryparam.state = "c"                                                                                           
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
               DISPLAY g_qryparam.multiret TO mps01                                                                                 
               NEXT FIELD mps01                                                                                                     
            END IF  
#No.FUN-570240 --end-- 
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
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW amsr513_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
   INPUT BY NAME tm.ver_no, tm.edate,tm.more
                 WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD ver_no
         IF cl_null(tm.ver_no) THEN NEXT FIELD ver_no END IF
      AFTER FIELD edate
         IF cl_null(tm.edate) THEN NEXT FIELD edate END IF
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
      LET INT_FLAG = 0 CLOSE WINDOW amsr513_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='amsr513'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amsr513','9031',1)
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
                         " '",tm.ver_no CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('amsr513',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW amsr513_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL amsr513()
   ERROR ""
END WHILE
   CLOSE WINDOW amsr513_w
END FUNCTION
 
FUNCTION amsr513()
   DEFINE l_name    LIKE type_file.chr20,  #NO.FUN-680101 VARCHAR(20)   # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0081
          l_sql     LIKE type_file.chr1000,#NO.FUN-680101 VARCHAR(1000) # RDSQL STATEMENT
          l_chr     LIKE type_file.chr1,   #NO.FUN-680101 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,#NO.FUN-680101 VARCHAR(40)
          l_order   LIKE type_file.chr20,  #NO.FUN-680101 VARCHAR(20)
          l_bal,l_qty  LIKE mps_file.mps061,
          l_begin   LIKE type_file.chr1,   #NO.FUN-680101 VARCHAR(01)
          mps   RECORD LIKE mps_file.*,
          mps_o RECORD LIKE mps_file.*,
          mpt   RECORD LIKE mpt_file.*,
          ima   RECORD      
                  ima02  LIKE ima_file.ima02,
                  ima08  LIKE ima_file.ima08,
                  ima25  LIKE ima_file.ima25,
                  ima43  LIKE ima_file.ima43
                END RECORD,
          ima_o RECORD      
                  ima02  LIKE ima_file.ima02,
                  ima08  LIKE ima_file.ima08,
                  ima25  LIKE ima_file.ima25,
                  ima43  LIKE ima_file.ima43
                END RECORD
   DEFINE l_gen02  LIKE gen_file.gen02 
   DEFINE l_vender LIKE pmm_file.pmm09 
   DEFINE l_pmc03  LIKE pmc_file.pmc03 
   DEFINE l_cnt    LIKE type_file.num5          #NO.FUN-680101 SMALLINT
   DEFINE l_pono   LIKE pmm_file.pmm01 
   DEFINE l_prno   LIKE pmm_file.pmm01 
   DEFINE l_a      LIKE type_file.chr1          #NO.FUN-6750097
   DEFINE l_b      LIKE type_file.chr1          #NO.FUN-6750097
 
#No.FUN-750097-----------------start--------------                                                                                  
     CALL cl_del_data(l_table)                                                                                                      
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                       
#No.FUN-750097-----------------end----------------
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET l_sql = "SELECT mps_file.*,ima02,ima08,ima25,ima43",
                 "  FROM mps_file, ima_file",
                 " WHERE ",tm.wc CLIPPED,
                 "   AND mps01=ima01 ",
                 "   AND mps_v='",tm.ver_no,"'",
                 "   AND mps03<='",tm.edate,"'",
                 "   ORDER BY mps01,mps03"
 
     PREPARE amsr513_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
        EXIT PROGRAM 
     END IF
     DECLARE amsr513_curs1 CURSOR FOR amsr513_prepare1
 
     LET l_sql = "SELECT *  FROM mpt_file ",
                 " WHERE (mpt05='61' OR mpt05='62' OR mpt05='63')",
                 "   AND mpt_v = '",tm.ver_no,"'",
                 "   AND mpt01=? ",
                 "   AND mpt03=? AND mpt_v=? "
     PREPARE r513_prempt  FROM l_sql
     IF STATUS THEN CALL cl_err('prepare2:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
        EXIT PROGRAM 
     END IF
     DECLARE r513_curmpt CURSOR FOR r513_prempt 
 
#    CALL cl_outnam('amsr513') RETURNING l_name           #No.FUN-750097
#    START REPORT amsr513_rep TO l_name                   #No.FUN-750097
     LET g_pageno = 0 LET mps_o.mps01 = ' '
     FOREACH amsr513_curs1 INTO mps.*, ima.* 
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
         IF mps.mps01 != mps_o.mps01 THEN LET l_begin = 'N' END IF
         LET l_qty = mps.mps061 + mps.mps062 + mps.mps063
         LET l_bal = mps.mps08  + mps.mps09
         IF l_begin = 'N' THEN 
            IF l_qty <= 0 OR l_bal <=0
            THEN LET mps_o.* = mps.*
                 LET ima_o.* = ima.*
                 CONTINUE FOREACH
            ELSE IF mps.mps01 = mps_o.mps01 THEN 
#No.FUN-750097--------------start--------------------
                   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = ima.ima43
                   IF SQLCA.sqlcode THEN LET l_gen02 = ' ' END IF
                   LET l_a = 'N'
                   FOREACH r513_curmpt  USING mps.mps01,mps.mps03,mps.mps_v
                   INTO mpt.*
                     LET l_cnt = l_cnt + 1
                     IF mpt.mpt05 = '62' OR mpt.mpt05 = '63' THEN
                        LET l_pono = mpt.mpt06         #No.FUN-550056 
                        SELECT pmm09,pmc03 INTO l_vender,l_pmc03 
                          FROM pmm_file,pmc_file
                         WHERE pmm09 = pmc01 and pmm01 = l_pono AND pmm18 !='X'
                            IF SQLCA.sqlcode THEN LET l_vender = ' ' LET l_pmc03 = ' ' END IF
                     END IF
                     IF mpt.mpt05 ='61' THEN 
                        LET l_prno = mpt.mpt06         #No.FUN-550056 
                        SELECT pmk09,pmc03 INTO l_vender,l_pmc03 
                          FROM pmk_file,pmc_file
                         WHERE pmk09 = pmc01 and pmk01 = l_prno
                            IF SQLCA.sqlcode THEN LET l_vender = ' ' LET l_pmc03 = ' ' END IF
                     END IF
                     EXECUTE insert_prep USING
                             ima.ima02,ima.ima25,ima.ima43,l_vender,l_pmc03,l_gen02,
                             mpt.mpt04,mpt.mpt06,mpt.mpt061,mpt.mpt08,mps.mps00,mps.mps01,
                             mps.mps03,mps.mps041,mps.mps043,mps.mps044,mps.mps051,mps.mps052,
                             mps.mps053,mps.mps063,mps.mps064,mps.mps065,mps.mps08,mps.mps09
                     LET l_a = 'Y'
                   END FOREACH
#                  OUTPUT TO REPORT amsr513_rep(mps_o.*, ima_o.*)
                   IF l_a = 'N' THEN
                      EXECUTE insert_prep USING
                              ima.ima02,ima.ima25,ima.ima43,' ',' ',l_gen02,
#                             ' ',' ',' ',' ',mps.mps00,mps.mps01,  #No.TQC-970257
                              ' ',' ',' ','0',mps.mps00,mps.mps01,  #No.TQC-970257 
                              mps.mps03,mps.mps041,mps.mps043,mps.mps044,mps.mps051,mps.mps052,
                              mps.mps053,mps.mps063,mps.mps064,mps.mps065,mps.mps08,mps.mps09
                   END IF
                 END IF
                 LET l_begin = 'Y' 
            END IF 
         END IF 
         SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = ima.ima43
         IF SQLCA.sqlcode THEN LET l_gen02 = ' ' END IF
         LET l_b = 'N'
         FOREACH r513_curmpt  USING mps.mps01,mps.mps03,mps.mps_v
         INTO mpt.*
           LET l_cnt = l_cnt + 1
           IF mpt.mpt05 = '62' OR mpt.mpt05 = '63' THEN
              LET l_pono = mpt.mpt06         #No.FUN-550056 
              SELECT pmm09,pmc03 INTO l_vender,l_pmc03 
                FROM pmm_file,pmc_file
               WHERE pmm09 = pmc01 and pmm01 = l_pono AND pmm18 !='X'
                  IF SQLCA.sqlcode THEN LET l_vender = ' ' LET l_pmc03 = ' ' END IF
           END IF
           IF mpt.mpt05 ='61' THEN 
              LET l_prno = mpt.mpt06         #No.FUN-550056 
              SELECT pmk09,pmc03 INTO l_vender,l_pmc03 
                FROM pmk_file,pmc_file
               WHERE pmk09 = pmc01 and pmk01 = l_prno
                  IF SQLCA.sqlcode THEN LET l_vender = ' ' LET l_pmc03 = ' ' END IF
           END IF
           EXECUTE insert_prep USING
                   ima.ima02,ima.ima25,ima.ima43,l_vender,l_pmc03,l_gen02,
                   mpt.mpt04,mpt.mpt06,mpt.mpt061,mpt.mpt08,mps.mps00,mps.mps01,
                   mps.mps03,mps.mps041,mps.mps043,mps.mps044,mps.mps051,mps.mps052,
                   mps.mps053,mps.mps063,mps.mps064,mps.mps065,mps.mps08,mps.mps09
           LET l_b = 'Y'
         END FOREACH
#        OUTPUT TO REPORT amsr513_rep(mps.*, ima.*)
         IF l_b = 'N' THEN
            EXECUTE insert_prep USING
                    ima.ima02,ima.ima25,ima.ima43,' ',' ',l_gen02,
#                   ' ',' ',' ',' ',mps.mps00,mps.mps01,   #No.TQC-970257
                    ' ',' ',' ','0',mps.mps00,mps.mps01,   #No.TQC-970257 
                    mps.mps03,mps.mps041,mps.mps043,mps.mps044,mps.mps051,mps.mps052,
                    mps.mps053,mps.mps063,mps.mps064,mps.mps065,mps.mps08,mps.mps09
         END IF
#No.FUN-750097--------------end---------------------
         LET mps_o.* = mps.*
         LET ima_o.* = ima.*
     END FOREACH
#No.FUN-750097-------------start------------------
#    FINISH REPORT amsr513_rep                        #No.FUN-750097
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)      #No.FUN-750097
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                               
     LET g_str = ''                                                                                                                 
     #是否列印選擇條件                                                                                                              
     IF g_zz05 = 'Y' THEN                                                                                                           
        CALL cl_wcchp(tm.wc,'mps01')                                                                                                
             RETURNING tm.wc                                                                                                        
        LET g_str = tm.wc                                                                                                           
     END IF                                                                                                                         
     LET g_str = g_str,";",tm.ver_no,";",tm.edate                                             
     CALL cl_prt_cs3('amsr513','amsr513',l_sql,g_str)                                                                                 
#No.FUN-750097-------------end--------------------
END FUNCTION
 
#No.FUN-750097--------------start--------------------
{REPORT amsr513_rep(mps,ima)
   DEFINE l_last_sw     LIKE type_file.chr1     #NO.FUN-680101 VARCHAR(1)
   DEFINE mps           RECORD LIKE mps_file.*
   DEFINE mpt           RECORD LIKE mpt_file.*
   DEFINE ima   RECORD      
                  ima02  LIKE ima_file.ima02,
                  ima08  LIKE ima_file.ima08,
                  ima25  LIKE ima_file.ima25,
                  ima43  LIKE ima_file.ima43
                END RECORD
   DEFINE l_reqqty,l_othqty LIKE mps_file.mps041 
   DEFINE l_cnt    LIKE type_file.num5          #NO.FUN-680101 SMALLINT
   DEFINE l_gen02  LIKE gen_file.gen02 
   DEFINE l_pono   LIKE pmm_file.pmm01 
   DEFINE l_prno   LIKE pmm_file.pmm01 
   DEFINE l_vender LIKE pmm_file.pmm09 
   DEFINE l_pmc03  LIKE pmc_file.pmc03 
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY ima.ima43,mps.mps01,mps.mps03
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
 
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = ima.ima43
      IF SQLCA.sqlcode THEN LET l_gen02 = ' ' END IF
      LET g_head1= g_x[22] clipped,ima.ima43,' ',l_gen02
      PRINT g_head1
      LET g_head1= g_x[16] CLIPPED,tm.ver_no,'  ',g_x[21] CLIPPED,tm.edate
      PRINT g_head1
      PRINT g_dash[1,g_len] CLIPPED
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
            g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF ima.ima43   #採購員
       SKIP TO TOP OF PAGE
 
   BEFORE GROUP OF mps.mps01
      PRINT COLUMN g_c[31],g_x[17] CLIPPED,
            COLUMN g_c[32],mps.mps01,
            COLUMN g_c[33],g_x[18] CLIPPED,
            COLUMN g_c[34],ima.ima02,
            COLUMN g_c[35],g_x[19] CLIPPED,
            COLUMN g_c[36],ima.ima25 
 
   BEFORE GROUP OF mps.mps03
      LET l_cnt = 0
      LET l_reqqty = mps.mps041+mps.mps043+mps.mps044
      LET l_othqty = mps.mps051+mps.mps052+mps.mps053 +
                     mps.mps063+mps.mps064+mps.mps065 + mps.mps09
      PRINT COLUMN g_c[31],mps.mps00 USING '###&', #No.TQC-5C0059 #FUN-590118
            COLUMN g_c[32],mps.mps03,
            COLUMN g_c[33],(mps.mps08+mps.mps09) USING '----,---,--&',#No.TQC-5C0059
            COLUMN g_c[34],l_reqqty  USING '----,---,--&',#No.TQC-5C0059
            COLUMN g_c[35],l_othqty  USING '----,---,--&';#No.TQC-5C0059
 
   ON EVERY ROW 
       #-->取請購/採購供給
       FOREACH r513_curmpt  USING mps.mps01,mps.mps03,mps.mps_v
         INTO mpt.*
         LET l_cnt = l_cnt + 1
         IF mpt.mpt05 = '62' OR mpt.mpt05 = '63' THEN
#           LET l_pono = mpt.mpt06[1,10]
            LET l_pono = mpt.mpt06         #No.FUN-550056 
            SELECT pmm09,pmc03 INTO l_vender,l_pmc03 
              FROM pmm_file,pmc_file
              WHERE pmm09 = pmc01 and pmm01 = l_pono AND pmm18 !='X'
            IF SQLCA.sqlcode THEN LET l_vender = ' ' LET l_pmc03 = ' ' END IF
         END IF
         IF mpt.mpt05 ='61' THEN 
#           LET l_prno = mpt.mpt06[1,10]
            LET l_prno = mpt.mpt06         #No.FUN-550056 
            SELECT pmk09,pmc03 INTO l_vender,l_pmc03 
              FROM pmk_file,pmc_file
              WHERE pmk09 = pmc01 and pmk01 = l_prno
            IF SQLCA.sqlcode THEN LET l_vender = ' ' LET l_pmc03 = ' ' END IF
         END IF
         PRINT COLUMN g_c[36],mpt.mpt08 USING '----,---,---', #No.TQC-5C0059
#              COLUMN g_c[37],mpt.mpt06[1,10],
               COLUMN g_c[37],mpt.mpt06,         #No.FUN-550056 
               COLUMN g_c[38],mpt.mpt061 using '###&', #No.TQC-5C0059 #FUN-590118
               COLUMN g_c[39],mpt.mpt04,
               COLUMN g_c[40],l_vender,
               COLUMN g_c[41],l_pmc03
       END FOREACH
 
   AFTER GROUP OF mps.mps03
      IF l_cnt = 0 THEN PRINT ' ' END IF
 
   AFTER GROUP OF mps.mps01
      PRINT g_dash2[1,g_len] CLIPPED
 
   ON LAST ROW
      LET l_last_sw = 'y'
#     PRINT g_dash2[1,g_len] CLIPPED
#     PRINT '(amsr513)'
      PRINT g_dash[1,g_len] CLIPPED #No.TQC-5C0059
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED #No.TQC-5C0059
 
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len] CLIPPED
              #PRINT '(amsr513)'
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #No.TQC-5C0059 
         ELSE SKIP 2 LINE
      END IF
END REPORT}
#No.FUN-750097--------------end---------------------
