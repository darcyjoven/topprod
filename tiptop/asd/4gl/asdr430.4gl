# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: asdr430.4gl
# Descriptions...: 半成品成本與巿價孰低比較表
# Date & Author..: 99/10/11 By Eric
# Modify.........: No.FUN-510037 05/01/21 By pengu 報表轉XML
# Modify.........: No.MOD-530125 05/03/17 By Carol QBE欄位順序調整
# Modify.........: No.FUN-570244 05/07/22 By vivien 料件編號欄位增加controlp
# Modify.........: No.FUN-5A0059 05/11/02 By Sarah 補印ima021
# Modify.........: No.TQC-610079 06/02/09 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-690010 06/09/05 By zdyllq 類型轉換  
# Modify.........: No.FUN-690122 06/10/13 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: NO.FUN-750031 07/07/31 By TSD.c123k 改為crystal report
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9C0179 09/12/29 By tsai_yen EXECUTE裡不可有擷取字串的中括號[]
# Modify.........: No.FUN-B80062 11/08/03 By minpp程序撰寫規範修改
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-690010CHAR(300),    # Where condition
              yea     LIKE type_file.num5,         #No.FUN-690010SMALLINT,
              mo      LIKE type_file.num5,         #No.FUN-690010SMALLINT,
              sw2     LIKE type_file.chr1,         #No.FUN-690010CHAR(1),
              sw3     LIKE type_file.num5,         #No.FUN-690010SMALLINT,
              sw4     LIKE type_file.chr1,         #No.FUN-690010CHAR(1),
              more    LIKE type_file.chr1          #No.FUN-690010CHAR(1)         # Input more condition(Y/N)
              END RECORD,
          sort  RECORD                # Print condition RECORD
              stp021  LIKE stp_file.stp021,         # Prog. Version..: '5.30.06-13.03.12(04), #TQC-840066
              stp03   LIKE oqu_file.oqu12,         #No.FUN-690010DEC(12,2),
              stp05   LIKE alb_file.alb06,         #No.FUN-690010DEC(20,6),
              stp06   LIKE alb_file.alb06,         #No.FUN-690010DEC(20,6),
              stp08   LIKE alb_file.alb06,         #No.FUN-690010DEC(20,6),
              stp15   LIKE alb_file.alb06,         #No.FUN-690010DEC(20,6),
              stp17   LIKE alb_file.alb06,         #No.FUN-690010DEC(20,6),
              stp18   LIKE alb_file.alb06,         #No.FUN-690010DEC(20,6),
              stp19   LIKE alb_file.alb06          #No.FUN-690010DEC(20,6)
              END RECORD,
          g_prdate  LIKE type_file.chr1000,      #No.FUN-690010CHAR(50),
          g_year    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          g_month   LIKE type_file.num5          #No.FUN-690010SMALLINT
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   g_head1         STRING
DEFINE   g_sql       STRING                  # FUN-750031 TSD.c123k
DEFINE   g_str       STRING                  # FUN-750031 TSD.c123k
DEFINE   l_table     STRING                  # FUN-750031 TSD.c123k
 
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASD")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #NO.FUN-690122 by baogui
 
   # add FUN-750031
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> TSD.c123k *** ##
   LET g_sql = "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "ima131.ima_file.ima131,",
               "t_azi03.azi_file.azi03,",
               "t_azi04.azi_file.azi04,",
               "stp02.stp1_file.stp02,",
               "stp03.stp1_file.stp03,",
               "stp04.stp1_file.stp04,",
               "stp05.stp1_file.stp05,",
               "stp06.stp1_file.stp06,",
               "stp07.stp1_file.stp07,",
               "stp08.stp1_file.stp08,",
               "stp09.stp1_file.stp09,",
               "stp10.stp1_file.stp10,",
               "stp11.stp1_file.stp11,",
               "stp15.stp1_file.stp15,",
               "stp17.stp1_file.stp17,",
               "stp18.stp1_file.stp18,",
               "stp19.stp1_file.stp19,",
               "stp021.stp1_file.stp021" 
 
   LET l_table = cl_prt_temptable('asdr430',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?) "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------------ CR (1) ------------------------------#
   # end FUN-750031
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #TQC-610079-begin
   LET tm.sw2 = ARG_VAL(8)
   LET tm.sw3 = ARG_VAL(9)
   LET tm.sw4 = ARG_VAL(10)
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(8)
   #LET g_rep_clas = ARG_VAL(9)
   #LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   ##No.FUN-570264 ---end---
   #TQC-610079-end
#No.FUN-690010-----Begin-------
#   CREATE TEMP TABLE r430tmp
#    (
#          stp021  VARCHAR(04),
#          stp03   DEC(12,2),
#          stp05   DEC(20,6),
#          stp06   DEC(20,6),
#          stp08   DEC(20,6),
#          stp15   DEC(20,6),
#          stp17   DEC(20,6),
#          stp18   DEC(20,6),
#          stp19   DEC(20,6)
#    );
   CREATE TEMP TABLE r430tmp(
          stp021  LIKE stp_file.stp021,
          stp03   LIKE stp_file.stp03,
          stp05   LIKE type_file.num20_6,
          stp06   LIKE type_file.num20_6,
          stp08   LIKE type_file.num20_6,
          stp15   LIKE type_file.num20_6,
          stp17   LIKE type_file.num20_6,
          stp18   LIKE type_file.num20_6,
          stp19   LIKE type_file.num20_6);
    
#No.FUN-690010--------End---------
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL asdr430_tm(4,16)        # Input print condition
      ELSE CALL asdr430()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #NO.FUN-690122 by baogui
END MAIN
 
FUNCTION asdr430_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
   LET p_row = 3 LET p_col = 20
   OPEN WINDOW asdr430_w AT p_row,p_col WITH FORM "asd/42f/asdr430" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   SELECT sto01,sto02 INTO tm.yea,tm.mo FROM sto_file
   LET tm.sw2  ='2'
   LET tm.sw3  =NULL
   LET tm.sw4  ='N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   WHILE TRUE
 #MOD-530125
     CONSTRUCT BY NAME tm.wc ON stp02,stp09,ima131 
 
#No.FUN-570244 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION CONTROLP                                                                                                 
            IF INFIELD(stp02) THEN                                                                                                  
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form = "q_ima"                                                                                       
               LET g_qryparam.state = "c"                                                                                           
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
               DISPLAY g_qryparam.multiret TO stp02                                                                                 
               NEXT FIELD stp02                                                                                                     
            END IF                                                            
#No.FUN-570244 --end  
 
##
       ON ACTION locale
          LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
        LET INT_FLAG = 0 
        EXIT WHILE 
     END IF
 
     INPUT BY NAME tm.sw3,tm.sw2,tm.sw4 WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
        AFTER FIELD sw2
           IF tm.sw2 NOT MATCHES '[123]' THEN
              NEXT FIELD sw2
           END IF
        AFTER FIELD sw4
           IF tm.sw4 NOT MATCHES '[YN]' THEN
              NEXT FIELD sw4
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
        LET INT_FLAG = 0 
        EXIT WHILE 
     END IF
 
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
         WHERE zz01='asdr430'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('asdr430','9031',1)   
           
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
                           " '",tm.sw2 CLIPPED,"'",             #TQC-610079
                           " '",tm.sw3 CLIPPED,"'",             #TQC-610079
                           " '",tm.sw4 CLIPPED,"'",             #TQC-610079
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
  
           CALL cl_cmdat('asdr430',g_time,l_cmd)    # Execute cmd at later time
        END IF
        CLOSE WINDOW asdr430_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #NO.FUN-690122 by baogui
        EXIT PROGRAM
     END IF
     CALL cl_wait()
     CALL asdr430()
     ERROR ""
   END WHILE
 
   CLOSE WINDOW asdr430_w
END FUNCTION
 
FUNCTION asdr430()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0089
          l_time    LIKE type_file.chr8,          #TSD.c123k add 
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT  #No.FUN-690010 VARCHAR(900)
          g_sql     string,        # RDSQL STATEMENT  #No.FUN-580092 HCN
          l_chr     LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
          l_za05    LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(40)
          l_year    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          l_month   LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          l_ima06   LIKE type_file.chr1,         #No.FUN-690010CHAR(01),
          last_y    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          last_m    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          l_date    LIKE type_file.dat,          #No.FUN-690010DATE,
          l_ima73   LIKE type_file.dat,          #No.FUN-690010DATE,
          l_ima74   LIKE type_file.dat,          #No.FUN-690010DATE,
          l_cnt     LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_ima131  LIKE ima_file.ima131,
          sr RECORD LIKE stp1_file.*,
          #FUN-750031 TSD.c123k add --------
          l_ima02   like ima_file.ima02,
          l_ima021  like ima_file.ima021  
          #FUN-750031 TSD.c123k end --------
   ###TQC-9C0179 START ###
   DEFINE l_ima02_1    LIKE ima_file.ima02
   DEFINE l_ima021_1   LIKE ima_file.ima021
   ###TQC-9C0179 END ###
 
     #CALL cl_used(g_prog,l_time,1) RETURNING l_time  #TSD.c123k add  #FUN-B80062 MARK
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
 
     # add FUN-750031
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> TSD.c123k *** ##
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     #------------------------------ CR (2) ----------------------------------#
     # end FUN-750031
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     DELETE FROM r430tmp
     LET l_sql = "SELECT stp1_file.*,ima131 FROM stp1_file,ima_file",
                 " WHERE stp01='3' AND stp02=ima01 AND ",tm.wc CLIPPED
     IF tm.sw4='N' THEN
        LET l_sql=l_sql CLIPPED, " AND stp03<>0 "
     END IF
     IF tm.sw2='1' THEN
        LET l_sql=l_sql CLIPPED," ORDER BY stp02"
     END IF
     IF tm.sw2='2' THEN
        LET l_sql=l_sql CLIPPED," ORDER BY stp05 DESC,stp02"
     END IF
     IF tm.sw2='3' THEN
        LET l_sql=l_sql CLIPPED," ORDER BY ima131,stp02"
     END IF
     PREPARE asdr430_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #NO.FUN-690122 by baogui
        EXIT PROGRAM
           
     END IF
     DECLARE asdr430_curs1 CURSOR FOR asdr430_prepare1
     #CALL cl_outnam('asdr430') RETURNING l_name  #FUN-750031 TSD.c123k mark
     #START REPORT asdr430_rep TO l_name          #FUN-750031 TSD.c123k mark
     LET g_pageno = 0
     LET l_cnt=1
     FOREACH asdr430_curs1 INTO sr.*,l_ima131
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF tm.sw3 IS NOT NULL AND tm.sw3 <> 0 THEN
          IF l_cnt > tm.sw3 THEN
              EXIT FOREACH 
          END IF
       END IF
 
       LET sort.stp021=sr.stp021
       LET sort.stp03 =sr.stp03
       LET sort.stp05 =sr.stp05
       LET sort.stp06 =sr.stp06
       LET sort.stp08 =sr.stp08
       LET sort.stp15 =sr.stp15
       LET sort.stp17 =sr.stp17
       LET sort.stp18 =sr.stp18
       LET sort.stp19 =sr.stp19
       SELECT * FROM r430tmp WHERE stp021=sort.stp021
       IF STATUS <> 0 THEN
          INSERT INTO r430tmp VALUES(sort.*)
       ELSE
          UPDATE r430tmp
             SET stp03=stp03+sort.stp03, stp05=stp05+sort.stp05,
                 stp06=stp06+sort.stp06, stp08=stp08+sort.stp08,
                 stp15=stp15+sort.stp15, stp18=stp18+sort.stp18,
                 stp17=stp17+sort.stp17, stp19=stp19+sort.stp19
           WHERE stp021=sort.stp021
       END IF
       LET l_cnt=l_cnt+1
 
       #FUN-750031 TSD.c123k add 
       SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file WHERE ima01=sr.stp02
 
       SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file WHERE azi01=sr.stp12
 
       IF cl_null(sr.stp03) THEN LET sr.stp03 = 0 END IF
       IF cl_null(sr.stp04) THEN LET sr.stp04 = 0 END IF
       IF cl_null(sr.stp05) THEN LET sr.stp05 = 0 END IF
       IF cl_null(sr.stp06) THEN LET sr.stp06 = 0 END IF
       IF cl_null(sr.stp07) THEN LET sr.stp07 = 0 END IF
       IF cl_null(sr.stp08) THEN LET sr.stp08 = 0 END IF
       IF cl_null(sr.stp15) THEN LET sr.stp15 = 0 END IF
       IF cl_null(sr.stp17) THEN LET sr.stp17 = 0 END IF
       IF cl_null(sr.stp18) THEN LET sr.stp18 = 0 END IF
       IF cl_null(sr.stp19) THEN LET sr.stp19 = 0 END IF

       ###TQC-9C0179 START ###
       LET l_ima02_1 = l_ima02[1,30]
       LET l_ima021_1 = l_ima021[1,30]
       ###TQC-9C0179 END ### 
       #FUN-750031 add
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
       EXECUTE insert_prep USING
          #l_ima02[1,30], l_ima021[1,30],  l_ima131,   t_azi03,    t_azi04, #TQC-9C0179 mark
          l_ima02_1,     l_ima021_1,      l_ima131,    t_azi03,    t_azi04, #TQC-9C0179
          sr.stp02,      sr.stp03,        sr.stp04,   sr.stp05,   sr.stp06,
          sr.stp07,      sr.stp08,        sr.stp09,   sr.stp10,   sr.stp11,
          sr.stp15,      sr.stp17,        sr.stp18,   sr.stp19,   sr.stp021     
       #------------------------------ CR (3) ------------------------------#
       #FUN-750031 end
 
     END FOREACH 
     #FINISH REPORT asdr430_rep  #TSD.c123k add  #FUN-750031 TSD.c123k mark
     #CALL cl_used(g_prog,l_time,2) RETURNING l_time  #TSD.c123k add    #FUN-B80062 MARK
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)  #FUN-750031 TSD.c123k mark
 
     # FUN-750031 add
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'stp02,stp09,ima131') 
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str,";",tm.yea,";",tm.mo,";",tm.sw2
  
     CALL cl_prt_cs3('asdr430','asdr430',l_sql,g_str)
     #------------------------------ CR (4) ------------------------------#
     # FUN-750031 end
END FUNCTION
