# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Pattern name...: amsg540.4gl
# Descriptions...: MPS 取消建議表
# Input parameter: 
# Return code....: 
# Date & Author..: 96/06/10 By Roger
# Modify.........: No.FUN-510036 05/01/19 By pengu 報表轉XML
# Modify.........: No.FUN-550056 05/05/20 By Trisy 單據編號加大
# Modify.........: No.FUN-570240 05/07/26 By Trisy 料件編號開窗 
# Modify.........: No.TQC-5C0059 05/12/12 By kevin 欄位沒對齊
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610075 06/01/24 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-660108 06/06/12 BY cheunl  cl_err --->cl_err3
# Modify.........: No.FUN-680101 06/08/30 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-690116 06/10/16 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0081 06/11/06 By atsea l_time轉g_time
# Modify.........: No.TQC-6A0080 06/11/16 By cheunl   修改報表格式
# Modify.........: No.FUN-750095 07/05/31 By johnray 修改報表功能，使用CR打印報表
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-950104 10/03/10 BY huangrh insert r540_tmp不可直接用mpt.*
# Modify.........: No.FUN-CB0072 12/11/26 By dongsz CR轉GR
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD                           # Print condition RECORD
            #wc      LIKE type_file.chr1000,#NO.FUN-680101 VARCHAR(600) # Where condition  #FUN-CB0072 mark
             wc      STRING,                #FUN-CB0072 add
            #n       VARCHAR(1),               #TQC-610075
             ver_no  LIKE mps_file.mps_v,   #NO.FUN-680101 VARCHAR(2)
             edate   LIKE type_file.dat,    #NO.FUN-680101 DATE
             s       LIKE type_file.chr3,   #NO.FUN-680101 VARCHAR(3)   # order
             t       LIKE type_file.chr3,   #NO.FUN-680101 VARCHAR(3)   # 換行
             more    LIKE type_file.chr1    #NO.FUN-680101 VARCHAR(1)   # Input more condition(Y/N)
          END RECORD
DEFINE  g_mps08      LIKE mps_file.mps08
DEFINE  g_cnt        LIKE type_file.num10   #NO.FUN-680101 INTEGER
DEFINE  g_i          LIKE type_file.num5    #NO.FUN-680101 SMALLINT   #count/index for any purpose
DEFINE  g_head1      STRING
#No.FUN-750095 -- begin --
DEFINE  g_sql        STRING
DEFINE  l_table      STRING
DEFINE  g_str        STRING
#No.FUN-750095 -- end --
 
###GENGRE###START
TYPE sr1_t RECORD
    mps01 LIKE mps_file.mps01,
    mps03 LIKE mps_file.mps03,
    ima02 LIKE ima_file.ima02,
    lastbal LIKE mps_file.mps08,
    ima08 LIKE ima_file.ima08,
    ima67 LIKE ima_file.ima67,
    ima43 LIKE ima_file.ima43,
    mpt07 LIKE mpt_file.mpt07,
    mps00 LIKE mps_file.mps00,
    mpt06 LIKE mpt_file.mpt06,
    mpt061 LIKE mpt_file.mpt061,
    mpt08 LIKE mpt_file.mpt08,
    mpt04 LIKE mpt_file.mpt04,
    mpt05 LIKE mpt_file.mpt05,
    l_order1 LIKE mps_file.mps01,       #FUN-CB0072 add
    l_order2 LIKE mps_file.mps01,       #FUN-CB0072 add
    l_order3 LIKE mps_file.mps01        #FUN-CB0072 add
END RECORD
###GENGRE###END

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
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.ver_no = ARG_VAL(8)
   LET tm.edate  = ARG_VAL(9)
   LET tm.s      = ARG_VAL(10)
   LET tm.t      = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
#No.FUN-750095 -- begin --
   LET g_sql = "mps01.mps_file.mps01,",
               "mps03.mps_file.mps03,",
               "ima02.ima_file.ima02,",
               "lastbal.mps_file.mps08,",
               "ima08.ima_file.ima08,",
               "ima67.ima_file.ima67,",
               "ima43.ima_file.ima43,",
               "mpt07.mpt_file.mpt07,",
               "mps00.mps_file.mps00,",
               "mpt06.mpt_file.mpt06,",
               "mpt061.mpt_file.mpt061,",
               "mpt08.mpt_file.mpt08,",
               "mpt04.mpt_file.mpt04,",
               "mpt05.mpt_file.mpt05,",
               "l_order1.mps_file.mps01,",    #FUN-CB0072 add
               "l_order2.mps_file.mps01,",    #FUN-CB0072 add
               "l_order3.mps_file.mps01"      #FUN-CB0072 add
   LET l_table = cl_prt_temptable('amsg540',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?)"           #FUN-CB0072 add 3?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_gre_drop_temptable(l_table)       #FUN-CB0072 add
      EXIT PROGRAM
   END IF
#No.FUN-750095 -- end --
 
   IF cl_null(g_bgjob) OR g_bgjob='N'        # If background job sw is off
      THEN CALL amsg540_tm(0,0)        # Input print condition
      ELSE CALL amsg540()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION amsg540_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,  #NO.FUN-680101 SMALLINT
          l_cmd          LIKE type_file.chr1000#NO.FUN-680101 VARCHAR(400)
 
   LET p_row = 5 LET p_col = 17
 
   OPEN WINDOW amsg540_w AT p_row,p_col
        WITH FORM "ams/42f/amsg540"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
  #LET tm.n    = '1'                  #TQC-610075
   LET tm.s    = '123'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON mps01,ima67,ima08,ima43 
#No.FUN-570240 --start--                                                                                    
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION controlp                                                                                              
           #IF INFIELD(mps01) THEN             #FUN-CB0072 mark
         CASE                                  #FUN-CB0072 add
            WHEN INFIELD(mps01)                #FUN-CB0072 add                                                                                         
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form = "q_ima"                                                                                       
               LET g_qryparam.state = "c"                                                                                           
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
               DISPLAY g_qryparam.multiret TO mps01                                                                                 
               NEXT FIELD mps01                              
           #FUN-CB0072--add--str---
            WHEN INFIELD(ima67)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima67
               NEXT FIELD ima67
            WHEN INFIELD(ima43)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima43
               NEXT FIELD ima43
         END CASE
           #FUN-CB0072--add--end---                                                                       
           #END IF                    #FUN-CB0072 mark 
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
      LET INT_FLAG = 0 CLOSE WINDOW amsg540_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      CALL cl_gre_drop_temptable(l_table)       #FUN-CB0072 add
      EXIT PROGRAM
         
   END IF
   INPUT BY NAME tm.ver_no, tm.edate,
                   tm2.s1,tm2.s2,tm2.s3,
                   tm2.t1,tm2.t2,tm2.t3,
                   tm.more WITHOUT DEFAULTS 
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
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      AFTER INPUT  
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
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
      LET INT_FLAG = 0 CLOSE WINDOW amsg540_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      CALL cl_gre_drop_temptable(l_table)       #FUN-CB0072 add
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='amsg540'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amsg540','9031',1)
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
                         " '",tm.edate  CLIPPED,"'",
                         " '",tm.s      CLIPPED,"'",
                         " '",tm.t      CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('amsg540',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW amsg540_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      CALL cl_gre_drop_temptable(l_table)       #FUN-CB0072 add
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL amsg540()
   ERROR ""
END WHILE
   CLOSE WINDOW amsg540_w
END FUNCTION
 
FUNCTION amsg540()
   DEFINE l_name    LIKE type_file.chr20,  #NO.FUN-680101 VARCHAR(20)    # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0081
         #l_sql     LIKE type_file.chr1000,#NO.FUN-680101 VARCHAR(1000)  # RDSQL STATEMENT   #FUN-CB0072 mark
          l_sql     STRING,                #FUN-CB0072 add
          l_chr     LIKE type_file.chr1,   #NO.FUN-680101 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,#NO.FUN-680101 VARCHAR(40)
          l_order   ARRAY[3] OF   LIKE mps_file.mps01, #NO.FUN-680101  VARCHAR(40) #FUN-5B0105 20->40
          l_no      LIKE mpt_file.mpt06,   #NO.FUN-680101 VARCHAR(10)
          l_max     LIKE type_file.chr1,   #NO.FUN-680101 VARCHAR(01)
          l_lastbal LIKE mps_file.mps08,
          l_type    LIKE type_file.chr1,   #NO.FUN-680101 VARCHAR(01)
          sr    RECORD
                l_order1 LIKE mps_file.mps01,  #FUN-5B0105 20->40   #NO.FUN-680101 VARCHAR(40)
                l_order2 LIKE mps_file.mps01,  #FUN-5B0105 20->40   #NO.FUN-680101 VARCHAR(40)
                l_order3 LIKE mps_file.mps01   #FUN-5B0105 20->40   #NO.FUN-680101 VARCHAR(40)
                END RECORD,
          mps   RECORD LIKE mps_file.*,
          mpt   RECORD LIKE mpt_file.*,
          ima   RECORD LIKE ima_file.*
   DEFINE l_ima02      LIKE ima_file.ima02   #No.FUN-750095
 
   CALL cl_del_data(l_table)       #No.FUN-750095
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     CREATE TEMP TABLE r540_tmp(
       mpt_v     LIKE mpt_file.mpt_v,
       mpt01     LIKE mpt_file.mpt01,
       mpt03     LIKE mpt_file.mpt03,
       mpt04     LIKE mpt_file.mpt04,
       mpt05     LIKE mpt_file.mpt05,
       mpt06     LIKE mpt_file.mpt06,
       mpt061    LIKE mpt_file.mpt061,
       mpt06_fz  LIKE mpt_file.mpt06_fz,
       mpt07     LIKE mpt_file.mpt07,
       mpt08     LIKE mpt_file.mpt08,
       mpt_t     LIKE type_file.chr1);  
       
#No.FUN-750095 -- begin --
#     create        index mpt_01 on mpt_file (mpt01,mpt03);
#     create        index mpt_02 on mpt_file (mpt06);
#No.FUN-750095 -- end --
 
     LET l_sql = "SELECT mps01",
                 "  FROM mps_file, ima_file",
                 " WHERE ",tm.wc CLIPPED,
                 "   AND mps01=ima01 ",
                 "   AND mps03<='",tm.edate,"'",
                 "   AND mps_v='",tm.ver_no,"'",
                 " GROUP BY mps01"
     PREPARE amsg540_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
        CALL cl_gre_drop_temptable(l_table)       #FUN-CB0072 add
        EXIT PROGRAM 
     END IF
     DECLARE amsg540_curs1 CURSOR FOR amsg540_prepare1
 
      #--->取彙總檔上時距最大之後往前推算
      LET l_sql = "SELECT mps_file.*  FROM mps_file ",
                  " WHERE mps_v='",tm.ver_no,"'",
                  " AND mps01= ? ", 
                  " AND mps03 <='",tm.edate,"'",
                  " ORDER BY mps03 DESC "
 
      PREPARE amsg540_premps  FROM l_sql
      IF STATUS THEN CALL cl_err('pre mps:',STATUS,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
         CALL cl_gre_drop_temptable(l_table)       #FUN-CB0072 add
         EXIT PROGRAM 
      END IF
      DECLARE amsg540_curmps CURSOR FOR amsg540_premps   
 
      #-->產生明細至暫存檔 
      LET l_sql = " SELECT * FROM mpt_file",
                  "  WHERE mpt01=? ",
                  "    AND mpt03=? AND mpt_v=? ",
                  "    AND mpt05 MATCHES '6*' AND mpt08>0"
      PREPARE amsg540_prempt  FROM l_sql
      IF STATUS THEN CALL cl_err('pre mpt:',STATUS,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
         CALL cl_gre_drop_temptable(l_table)       #FUN-CB0072 add
         EXIT PROGRAM 
      END IF
      DECLARE r540_c2        CURSOR FOR amsg540_prempt   
 
      #-->取暫存檔資料排序
      LET l_sql = " SELECT * FROM r540_tmp ",
                  "  WHERE mpt01= ? ", 
                  "    AND mpt03= ? AND mpt_v= ? ",
                  "    AND mpt05 MATCHES '6*' AND mpt08>0 ",
                  "  ORDER BY mpt_t,mpt03 DESC,mpt04 DESC "
 
      PREPARE amsg540_pretmp  FROM l_sql
      IF STATUS THEN CALL cl_err('pre tmp:',STATUS,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
         CALL cl_gre_drop_temptable(l_table)       #FUN-CB0072 add
         EXIT PROGRAM 
      END IF
      DECLARE r540_c3        CURSOR FOR amsg540_pretmp   
 
#No.FUN-750095 -- begin --
#     CALL cl_outnam('amsg540') RETURNING l_name
#     START REPORT amsg540_rep TO l_name
#     LET g_pageno = 0
#No.FUN-750095 -- end --
 
     FOREACH amsg540_curs1 INTO mps.mps01
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET l_max = 'Y' 
 
      FOREACH amsg540_curmps USING mps.mps01 INTO mps.* 
        IF SQLCA.sqlcode THEN 
           CALL cl_err('r540_curmps',SQLCA.sqlcode,0)
           EXIT FOREACH 
        END IF
        #-->預計結存先取最後bucket有多才推算
        IF l_max = 'Y' THEN 
           LET g_mps08 = mps.mps08 + mps.mps09
           IF g_mps08<=0 THEN EXIT FOREACH END IF 
           LET l_lastbal = mps.mps08 + mps.mps09 
        END IF
        LET l_max = 'N'
 
        #-->產生PLP/PLM 資料
        IF mps.mps09 >0 THEN 
           LET l_no = 'Plan-',mps.mps00 using '&&&&&'
           INSERT INTO r540_tmp VALUES(mps.mps_v,
                                       mps.mps01,
                                       mps.mps03,
                                       mps.mps11,'66',
                                       l_no,1,
                                       'N',' ',mps.mps09,'1')
           IF SQLCA.sqlcode THEN
  #           CALL cl_err('insert r540_temp',SQLCA.sqlcode,1) #No.FUN-660108
              CALL cl_err3("ins","r540_tmp",mps.mps_v,mps.mps01,SQLCA.sqlcode,"","insert r540_temp",1)      #No.FUN-660108           
              EXIT FOREACH 
           END IF
        END IF
 
        SELECT * INTO ima.*  FROM ima_file WHERE ima01=mps.mps01
#FUN-CB0072--remark--str---
#No.FUN-750095 -- begin --
         FOR g_cnt = 1 TO 3 
          CASE 
            WHEN tm.s[g_cnt,g_cnt]='1' LET l_order[g_cnt]=mps.mps01
            WHEN tm.s[g_cnt,g_cnt]='2' LET l_order[g_cnt]=ima.ima08
            WHEN tm.s[g_cnt,g_cnt]='3' LET l_order[g_cnt]=ima.ima67
            WHEN tm.s[g_cnt,g_cnt]='4' LET l_order[g_cnt]=ima.ima43
            OTHERWISE LET l_order[g_cnt]='-'
          END CASE
          LET sr.l_order1 = l_order[1]
          LET sr.l_order2 = l_order[2]
          LET sr.l_order3 = l_order[3]
        END FOR
#No.FUN-750095 -- end --
#FUN-CB0072--remark--end---
 
       #-->產生明細至暫存檔 
       FOREACH r540_c2  USING mps.mps01,mps.mps03,mps.mps_v
           INTO mpt.*
           IF SQLCA.sqlcode THEN 
              CALL cl_err('r540_curmps',SQLCA.sqlcode,0)
              EXIT FOREACH 
           END IF
#No.TQC-950104 --Begin--
#          INSERT INTO r540_tmp VALUES(mpt.*,'2') #TQC-950104
           INSERT INTO r540_tmp VALUES(mpt.mpt_v,mpt.mpt01,mpt.mpt03,
                                       mpt.mpt04,mpt.mpt05,mpt.mpt06,
                                       mpt.mpt061,mpt.mpt06_fz,mpt.mpt07,
                                       mpt.mpt08,'2')
#No.TQC-950104 --End--

       END FOREACH  
 
       #-->取暫存檔資料排序
       FOREACH r540_c3 USING mps.mps01,mps.mps03,mps.mps_v
          INTO mpt.*,l_type
          IF g_mps08<= 0 THEN EXIT FOREACH END IF
          LET g_mps08=g_mps08-mpt.mpt08
#No.FUN-750095 -- begin --
#          OUTPUT TO REPORT amsg540_rep(sr.*,mps.*, ima.*,mpt.*,l_lastbal)
          LET l_ima02=ima.ima02,' ',ima.ima25
          EXECUTE insert_prep USING mps.mps01,mps.mps03,l_ima02,l_lastbal,
                  ima.ima08,ima.ima67,ima.ima43,mpt.mpt07,mps.mps00,
                  mpt.mpt06,mpt.mpt061,mpt.mpt08,mpt.mpt04,mpt.mpt05,
                  sr.*                                                #FUN-CB0072 add
          IF STATUS THEN
             CALL cl_err("execute insert_prep:",STATUS,1)
             EXIT FOREACH
          END IF
#No.FUN-750095 -- end --
       END FOREACH
       IF g_mps08 <=0 THEN EXIT FOREACH END IF
      END FOREACH
 
     END FOREACH
#     FINISH REPORT amsg540_rep   #No.FUN-750095
     DROP TABLE r540_tmp
#No.FUN-750095 -- begin --
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    #CALL cl_wcchp(tm.wc,'')             #FUN-CB0072 mark
     LET g_str = ''                      #FUN-CB0072 add
     IF g_zz05 = 'Y' THEN                #FUN-CB0072 add
        CALL cl_wcchp(tm.wc,'mps01,ima67,ima08,ima43')     #FUN-CB0072 add
           RETURNING tm.wc
        LET g_str = tm.wc                #FUN-CB0072 add
     END IF                              #FUN-CB0072 add    
###GENGRE###     LET g_str = tm.wc,";",g_zz05,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t
###GENGRE###     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
###GENGRE###     CALL cl_prt_cs3('amsg540','amsg540',l_sql,g_str)
    CALL amsg540_grdata()    ###GENGRE###
#No.FUN-750095 -- end --
END FUNCTION
 
#No.FUN-750095 -- begin --
#REPORT amsg540_rep(sr,mps, ima,mpt,p_lastbal)
#   DEFINE l_last_sw    LIKE type_file.chr1     #NO.FUN-680101 VARCHAR(1)
#   DEFINE l_pmc03      LIKE pmc_file.pmc03     #NO.FUN-680101 VARCHAR(10)
#   DEFINE l_ima02      LIKE ima_file.ima02     #NO.FUN-680101 VARCHAR(30)
#   DEFINE p_lastbal     LIKE mps_file.mps08
#   DEFINE mps           RECORD LIKE mps_file.*
#   DEFINE mpt           RECORD LIKE mpt_file.*
#   DEFINE ima           RECORD LIKE ima_file.*
#   DEFINE sr            RECORD
#                        l_order1 LIKE mps_file.mps01, #FUN-5B0105 20->40   #NO.FUN-680101 VARCHAR(40)                                            
#                        l_order2 LIKE mps_file.mps01, #FUN-5B0105 20->40   #NO.FUN-680101 VARCHAR(40)                                                   
#                        l_order3 LIKE mps_file.mps01  #FUN-5B0105 20->40   #NO.FUN-680101 VARCHAR(40)
#                    END RECORD
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#  ORDER BY sr.l_order1,sr.l_order2,sr.l_order3,mps.mps01,mps.mps03,
#           mpt.mpt04 DESC,mpt.mpt05
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED  #No.TQC-6A0080
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED    #No.TQC-6A0080
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      LET g_head1=g_x[9] CLIPPED,tm.ver_no,'   ',g_x[10] CLIPPED,tm.edate
#      PRINT g_head1
#      PRINT g_dash2[1,g_len] CLIPPED
#      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.l_order1
#      IF tm.t[1,1]='Y' AND (PAGENO > 1 OR LINENO > 9) THEN
#         SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr.l_order2
#      IF tm.t[2,2]='Y' AND (PAGENO > 1 OR LINENO > 9) THEN
#         SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr.l_order3
#      IF tm.t[3,3]='Y' AND (PAGENO > 1 OR LINENO > 9) THEN
#         SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF mps.mps01
#         LET l_ima02=ima.ima02,' ',ima.ima25
#         PRINT COLUMN g_c[31],mps.mps01 CLIPPED,   #No.TQC-6A0080
#               COLUMN g_c[32],l_ima02 CLIPPED;     #No.TQC-6A0080
#         #PRINT COLUMN g_c[34],p_lastbal USING '----,---,--&'
#         PRINT COLUMN g_c[34],cl_numfor(p_lastbal,34,0) #No.TQC-5C0059
#
#   ON EVERY ROW
#         PRINT COLUMN g_c[31],mpt.mpt07 CLIPPED,  #No.TQC-6A0080
#               COLUMN g_c[33],mps.mps00 CLIPPED USING '###&', #No.TQC-5C0059 #FUN-590118  #No.TQC-6A0080
##              COLUMN g_c[35],mpt.mpt06[1,10] CLIPPED,    #No.TQC-6A0080
#               COLUMN g_c[35],mpt.mpt06 CLIPPED,         #No.FUN-550056   #No.TQC-6A0080
#               COLUMN g_c[36],mpt.mpt061 CLIPPED USING '###&',#No.TQC-5C0059 #FUN-590118   #No.TQC-6A0080
##              COLUMN g_c[37],mpt.mpt08 CLIPPED USING '---,---,--&',' ',    #No.TQC-6A0080
#               COLUMN g_c[37],cl_numfor(mpt.mpt08,37,0), #No.TQC-5C0059
#               COLUMN g_c[38],mpt.mpt04 CLIPPED     #No.TQC-6A0080
#
#   AFTER GROUP OF mps.mps01
#         PRINT g_dash2[1,g_len] CLIPPED
#
#   ON LAST ROW
#      LET l_last_sw = 'y'
#         PRINT g_dash[1,g_len] CLIPPED
#         PRINT g_x[4] CLIPPED,g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED     #No.TQC-6A0080
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len] CLIPPED
#              PRINT g_x[4] CLIPPED,g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED    #No.TQC-6A0080
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#No.FUN-750095 -- end --
 


###GENGRE###START
FUNCTION amsg540_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("amsg540")
        IF handler IS NOT NULL THEN
            START REPORT amsg540_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                       ," ORDER BY l_order1,l_order2,l_order3,mps01,mps03,mpt04 DESC,mpt05"    #FUN-CB0072 add 
          
            DECLARE amsg540_datacur1 CURSOR FROM l_sql
            FOREACH amsg540_datacur1 INTO sr1.*
                OUTPUT TO REPORT amsg540_rep(sr1.*)
            END FOREACH
            FINISH REPORT amsg540_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT amsg540_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_order1_skip  STRING           #FUN-CB0072 add
    DEFINE l_order2_skip  STRING           #FUN-CB0072 add
    DEFINE l_order3_skip  STRING           #FUN-CB0072 add

    
   #ORDER EXTERNAL BY sr1.mps01,sr1.mps03,sr1.mpt04 DESC,sr1.mpt05      #FUN-CB0072 mark
    ORDER EXTERNAL BY sr1.l_order1,sr1.l_order2,sr1.l_order3,sr1.mps01  #FUN-CB0072 add
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            PRINTX tm.*
       #FUN-CB0072--add--str---
        LET l_order1_skip = tm.t[1]
        LET l_order2_skip = tm.t[2]
        LET l_order3_skip = tm.t[3]
        PRINTX l_order1_skip,l_order2_skip,l_order3_skip
       #FUN-CB0072--add--end---
             
        BEFORE GROUP OF sr1.l_order1                 #FUN-CB0072 add
        BEFORE GROUP OF sr1.l_order2                 #FUN-CB0072 add
        BEFORE GROUP OF sr1.l_order3                 #FUN-CB0072 add 
        BEFORE GROUP OF sr1.mps01

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
 
            PRINTX sr1.*

        AFTER GROUP OF sr1.l_order1                 #FUN-CB0072 add
        AFTER GROUP OF sr1.l_order2                 #FUN-CB0072 add
        AFTER GROUP OF sr1.l_order3                 #FUN-CB0072 add
        AFTER GROUP OF sr1.mps01

        
        ON LAST ROW

END REPORT
###GENGRE###END
