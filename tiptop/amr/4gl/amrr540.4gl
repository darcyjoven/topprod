# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: amrr540.4gl
# Descriptions...: MRP 取消建議表
# Input parameter: 
# Return code....: 
# Date & Author..: 96/06/10 By Roger
# Modify.........: No.FUN-510046 05/01/28 By pengu 報表轉XML
# Modify.........: No.FUN-550055 05/05/24 By day   單據編號加大
# Modify.........: No.FUN-560011 05/06/06 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-570240 05/07/22 By vivien 料件編號欄位增加controlp
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610074 06/01/24 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-660107 06/06/14 By CZH cl_err-->cl_err3
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo 欄位類型定義-改為LIKE
# Modify.........: No.FUN-690116 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.TQC-6A0080 06/11/17 By xumin 報表表頭調整
# Modify.........: No.FUN-750095 07/05/25 By Lynn 報表功能改為使用CR
# Modfiy.........: No.TQC-950046 09/05/08 By chenyu 不能取消的采購供給需求也列印出來了
# Modfiy.........: No.TQC-950060 09/05/11 By chenyu 給變量賦值之前應先清空
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-AC0057 10/12/07 By baogc 修改INSERT INTO r540_tmp的值個數 
# Modify.........: No.FUN-B80023 11/08/03 By fengrui  程式撰寫規範修正
# Modify.........: No.TQC-D20022 13/02/19 By xuxz l_sql，wc定義修改為STRING

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                              # Print condition RECORD
             #wc      LIKE type_file.chr1000,     # Where condition          #NO.FUN-680082 VARCHAR(600) #TQC-D20022 mark
              wc      STRING,#TQC-D20022 add
             #n       VARCHAR(1),        #TQC-610074
              ver_no  LIKE mss_file.mss_v,        #NO.FUN-680082 VARCHAR(2)
              edate   LIKE type_file.dat,         #NO.FUN-680082 DATE
              s       LIKE type_file.chr3,        # order                    #NO.FUN-680082 VARCHAR(3)      
              t       LIKE type_file.chr3,        # 換行                     #NO.FUN-680082 VARCHAR(3)       
              more    LIKE type_file.chr1         # Input more condition(Y/N)#NO.FUN-680082 VARCHAR(1)
              END RECORD,
              g_mss08 LIKE mss_file.mss08
 
DEFINE   g_cnt           LIKE type_file.num10     #NO.FUN-680082 INTEGER 
DEFINE   g_i             LIKE type_file.num5      #count/index for any purpose  #NO.FUN-680082 SMALLINT
DEFINE   g_head1         STRING
DEFINE   l_table         STRING                   # No.FUN-750095                                                                       
DEFINE   g_str           STRING                   # No.FUN-750095                                                                       
DEFINE   g_sql           STRING                   # No.FUN-750095
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AMR")) THEN
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
# No.FUN-750095--begin--
 
  LET g_sql ="mss00.mss_file.mss00,",
             "mss01.mss_file.mss01,",
             "mss02.mss_file.mss02,",
             "mss08.mss_file.mss08,",
             "pmc03.pmc_file.pmc03,",
             "mst04.mst_file.mst04,",
             "mst06.mst_file.mst06,",
             "mst061.mst_file.mst061,",
             "mst07.mst_file.mst07,",
             "mst08.mst_file.mst08,",
             "ima01.ima_file.ima01,",
             "ima02.ima_file.ima02,",
             "ima021_1.ima_file.ima021,",#TQC-D20022 規格
             "ima08.ima_file.ima08,",
             "ima25.ima_file.ima25,",
             "ima43.ima_file.ima43,",
             "ima67.ima_file.ima67,",
             "ima021.ima_file.ima021,",
             "ima021_2.ima_file.ima021,",#TQC-D20022 規格
             "ima31.ima_file.ima31,",
             "mss03.mss_file.mss03,",
             "mst05.mst_file.mst05"
 
  LET l_table = cl_prt_temptable('amrr540',g_sql) CLIPPED
  IF l_table = -1 THEN EXIT PROGRAM END IF
 
# No.FUN-750095--end--
   IF cl_null(g_bgjob) OR g_bgjob='N' THEN    # If background job sw is off
      CALL amrr540_tm()        # Input print condition
   ELSE 
      CALL amrr540()           # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION amrr540_tm()
DEFINE lc_qbe_sn          LIKE gbm_file.gbm01     #No.FUN-580031
   DEFINE p_row,p_col     LIKE type_file.num5,    #NO.FUN-680082 SMALLINT
          l_cmd           LIKE type_file.chr1000  #NO.FUN-680082 VARCHAR(400)
 
   LET p_row = 3 LET p_col = 14
 
   OPEN WINDOW amrr540_w AT p_row,p_col
        WITH FORM "amr/42f/amrr540" 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   #LET tm.n    = '1'                 #TQC-610074
   LET tm.s    = '123'
   LET tm.more = 'N'
   LET tm.edate = g_today
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   #genero版本default 排序,跳頁,合計值
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
   CONSTRUCT BY NAME tm.wc ON mss01,ima67,mss02,ima08,ima43 
 
#No.FUN-570240 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION controlp                                                                                                 
         IF INFIELD(mss01) THEN                                                                                                  
            CALL cl_init_qry_var()                                                                                               
            LET g_qryparam.form = "q_ima"                                                                                       
            LET g_qryparam.state = "c"                                                                                           
            CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
            DISPLAY g_qryparam.multiret TO mss01                                                                                 
            NEXT FIELD mss01                                                                                                     
         END IF                                                            
#No.FUN-570240 --end  
 
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
      LET INT_FLAG = 0 CLOSE WINDOW amrr540_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
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
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
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
      LET INT_FLAG = 0 CLOSE WINDOW amrr540_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='amrr540'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amrr540','9031',1)
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
         CALL cl_cmdat('amrr540',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW amrr540_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL amrr540()
   ERROR ""
END WHILE
   CLOSE WINDOW amrr540_w
END FUNCTION
 
FUNCTION amrr540()
   DEFINE l_name    LIKE type_file.chr20,   # External(Disk) file name      #NO.FUN-680082 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0076
         #l_sql     LIKE type_file.chr1000, # RDSQL STATEMENT               #NO.FUN-680082 VARCHAR(1000)#TQC-D20022 mark
          l_sql     STRING,#TQC-D20022 add
          l_chr     LIKE type_file.chr1,    #NO.FUN-680082 VARCHAR(1)
          l_za05    LIKE type_file.chr1000, #NO.FUN-680082 VARCHAR(40) 
          l_order   ARRAY[3] OF  LIKE mss_file.mss01,  #FUN-5B0105 20->40   #NO.FUN-680082 VARCHAR(40)
          l_no      LIKE type_file.chr20,     #NO.FUN-680082 VARCHAR(10)
          l_max     LIKE type_file.chr1,    #NO.FUN-680082 VARCHAR(01)
          l_lastbal LIKE mss_file.mss08,
          l_mssbal  LIKE mss_file.mss08,    #No.TQC-950046 add
          l_type    LIKE type_file.chr1,    #NO.FUN-680082 VARCHAR(01)
          sr    RECORD
                l_order1 LIKE mss_file.mss01, #FUN-5B0105 20->40          #NO.FUN-680082 VARCHAR(40)
                l_order2 LIKE mss_file.mss01, #FUN-5B0105 20->40          #NO.FUN-680082 VARCHAR(40)
                l_order3 LIKE mss_file.mss01  #FUN-5B0105 20->40          #NO.FUN-680082 VARCHAR(40)
                END RECORD,
          mss   RECORD LIKE mss_file.*,
          mst   RECORD LIKE mst_file.*,
          ima   RECORD LIKE ima_file.*
   DEFINE l_pmc03       LIKE pmc_file.pmc03     # No.FUN-750095 
   DEFINE l_ima02       LIKE ima_file.ima02     # No.FUN-750095                                                                                         
   DEFINE l_ima25       LIKE ima_file.ima25     # No.FUN-750095
   DEFINE l_ima021      LIKE ima_file.ima021    # No.TQC-D20022 add
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     CREATE TEMP TABLE r540_tmp(
       mst_v     LIKE mst_file.mst_v, 
       mst01     LIKE mst_file.mst01,
       mst02     LIKE mst_file.mst02,
       mst03     LIKE mst_file.mst03,
       mst04     LIKE mst_file.mst04,
       mst05     LIKE mst_file.mst05,
       mst06     LIKE mst_file.mst06,
       mst061    LIKE mst_file.mst061,
       mst06_fz  LIKE mst_file.mst06_fz,
       mst07     LIKE mst_file.mst07,
       mst08     LIKE mst_file.mst08,
       mst_t     LIKE type_file.chr1);
       
     create        index mst_01 on mst_file (mst01,mst03,mst02);
     create        index mst_02 on mst_file (mst06);
# No.FUN-750095--begin--
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED," values(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?) "#TQC-D20022 add , ?,?
     PREPARE insert_prep FROM g_sql                                                                                                   
     IF STATUS THEN                                                                                                                   
        CALL cl_err("insert_prep:",STATUS,0)                                                                            
        CALL cl_used(g_prog,g_time,2) RETURNING g_time       #No.FUN-B80023--add--
        EXIT PROGRAM
     END IF
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
# No.FUN-750095--end--
     LET l_sql = "SELECT mss01,mss02",
                 "  FROM mss_file, ima_file",
                 " WHERE ",tm.wc CLIPPED,
                 "   AND mss01=ima01 ",
                 "   AND mss03<='",tm.edate,"'",
                 "   AND mss_v='",tm.ver_no,"'",
                 " GROUP BY mss01,mss02"
     PREPARE amrr540_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
        EXIT PROGRAM 
     END IF
     DECLARE amrr540_curs1 CURSOR FOR amrr540_prepare1
 
      #--->取彙總檔上時距最大之後往前推算
      LET l_sql = "SELECT mss_file.*  FROM mss_file ",
                  " WHERE mss_v='",tm.ver_no,"'",
                  " AND mss01= ? ", 
                  " AND mss02= ? ",
                  " AND mss03 <='",tm.edate,"'",
                  " ORDER BY mss03 DESC "
 
      PREPARE amrr540_premss  FROM l_sql
      IF STATUS THEN CALL cl_err('pre mss:',STATUS,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
         EXIT PROGRAM 
      END IF
      DECLARE amrr540_curmss CURSOR FOR amrr540_premss   
 
      #-->產生明細至暫存檔 
      LET l_sql = " SELECT * FROM mst_file",
                  "  WHERE mst01=? AND mst02=? ",
                  "    AND mst03=? AND mst_v=? ",
                  "    AND mst05 MATCHES '6*' AND mst08>0"
      PREPARE amrr540_premst  FROM l_sql
      IF STATUS THEN CALL cl_err('pre mst:',STATUS,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
         EXIT PROGRAM 
      END IF
      DECLARE r540_c2        CURSOR FOR amrr540_premst   
 
      #-->取暫存檔資料排序
      LET l_sql = " SELECT * FROM r540_tmp ",
                  "  WHERE mst01= ? AND mst02= ? ", 
                  "    AND mst03= ? AND mst_v= ? ",
                  "    AND mst05 MATCHES '6*' AND mst08>0 ",
                  "  ORDER BY mst_t,mst03 DESC,mst04 DESC "
 
      PREPARE amrr540_pretmp  FROM l_sql
      IF STATUS THEN CALL cl_err('pre tmp:',STATUS,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
         EXIT PROGRAM 
      END IF
      DECLARE r540_c3        CURSOR FOR amrr540_pretmp   
 
#    CALL cl_outnam('amrr540') RETURNING l_name        # No.FUN-750095
#    START REPORT amrr540_rep TO l_name                # No.FUN-750095
     LET g_pageno = 0
     FOREACH amrr540_curs1 INTO mss.mss01,mss.mss02
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET l_max = 'Y' 
 
      FOREACH amrr540_curmss  USING mss.mss01,mss.mss02
        INTO mss.* 
        IF SQLCA.sqlcode THEN 
           CALL cl_err('r540_curmss',SQLCA.sqlcode,0)
           EXIT FOREACH 
        END IF
        #-->預計結存先取最後bucket有多才推算
        IF l_max = 'Y' THEN 
           LET g_mss08 = mss.mss08 + mss.mss09
           IF g_mss08<=0 THEN EXIT FOREACH END IF 
           LET l_lastbal = mss.mss08 + mss.mss09 
        END IF
        LET l_max = 'N'
 
        #-->產生PLP/PLM 資料
        IF mss.mss09 >0 THEN 
           LET l_no = 'Plan-',mss.mss00 using '&&&&&'
           INSERT INTO r540_tmp VALUES(mss.mss_v,
                                       mss.mss01,mss.mss02,
                                       mss.mss03,
                                       mss.mss11,'66',
                                       l_no,1,
                                       'N',' ',mss.mss09,'1')
           IF SQLCA.sqlcode THEN
#              CALL cl_err('insert r540_temp',SQLCA.sqlcode,1) #No.FUN-660107
               CALL cl_err3("ins","r540_tmp",mss.mss01,mss.mss02,SQLCA.SQLCODE,"","insert r540_temp",1)        #NO.FUN-660107
              EXIT FOREACH 
           END IF
        END IF
 
        SELECT * INTO ima.*  FROM ima_file WHERE ima01=mss.mss01
#No.FUN-750095 -- begin --
#        FOR g_cnt = 1 TO 3 
#         CASE 
#           WHEN tm.s[g_cnt,g_cnt]='1' LET l_order[g_cnt]=mss.mss01
#           WHEN tm.s[g_cnt,g_cnt]='2' LET l_order[g_cnt]=ima.ima08
#           WHEN tm.s[g_cnt,g_cnt]='3' LET l_order[g_cnt]=ima.ima67
#           WHEN tm.s[g_cnt,g_cnt]='4' LET l_order[g_cnt]=ima.ima43
#           WHEN tm.s[g_cnt,g_cnt]='5' LET l_order[g_cnt]=mss.mss02
#           OTHERWISE LET l_order[g_cnt]='-'
#         END CASE
#         LET sr.l_order1 = l_order[1]
#         LET sr.l_order2 = l_order[2]
#         LET sr.l_order3 = l_order[3]
#       END FOR
#No.FUN-750095 -- end --
 
       #-->產生明細至暫存檔 
       FOREACH r540_c2 USING mss.mss01,mss.mss02,mss.mss03,mss.mss_v
           INTO mst.*
           IF SQLCA.sqlcode THEN 
              CALL cl_err('r540_curmss',SQLCA.sqlcode,0)
              EXIT FOREACH 
           END IF
        #   INSERT INTO r540_tmp VALUES(mst.*,'2') #No.TQC-AC0057
#No.TQC-AC0057 -- begin --
           INSERT INTO r540_tmp 
                  VALUES(mst.mst_v,mst.mst01,mst.mst02,mst.mst03,
                         mst.mst04,mst.mst05,mst.mst06,mst.mst061,
                         mst.mst06_fz,mst.mst07,mst.mst08,'2') 
#No.TQC-AC0057 -- end --
       END FOREACH  
 
       #-->取暫存檔資料排序
       FOREACH r540_c3 USING mss.mss01,mss.mss02,mss.mss03,mss.mss_v
          INTO mst.*,l_type
          IF g_mss08<= 0 THEN EXIT FOREACH END IF
 
          #No.TQC-950046 add -- begin
          LET l_mssbal = g_mss08 - mst.mst08
          IF l_mssbal < 0 THEN CONTINUE FOREACH END IF
          #No.TQC-950046 add -- end
 
          LET g_mss08=g_mss08-mst.mst08
# No.FUN-750095--begin
          #No.TQC-950060 add --begin
          LET l_pmc03 = NULL
          LET l_ima02 = NULL  LET l_ima25 = NULL
          LET l_ima021 = NULL #TQC-D20022 add
          #No.TQC-950060 add --end
          SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01=mss.mss02
          SELECT ima02,ima021,ima25 INTO l_ima02,l_ima021,l_ima25 FROM ima_file WHERE ima01=mst.mst07#TQC-D20022 add ima021
#         OUTPUT TO REPORT amrr540_rep(sr.*,mss.*, ima.*,mst.*,l_lastbal) 
          EXECUTE insert_prep USING mss.mss00,mss.mss01,mss.mss02,l_lastbal,l_pmc03,mst.mst04,
                                    mst.mst06,mst.mst061,mst.mst07,mst.mst08,
                                    ima.ima01,ima.ima02,ima.ima021,ima.ima08,ima.ima25,ima.ima43,ima.ima67,#TQC-D20022 add ima.ima021規格
                                    l_ima02,l_ima021,l_ima25,mss.mss03,mst.mst05#TQC-D20022 add l_ima021 規格
 
# No.FUN-750095--end
       END FOREACH
       IF g_mss08 <=0 THEN EXIT FOREACH END IF
      END FOREACH
 
     END FOREACH
#    FINISH REPORT amrr540_rep                       # No.FUN-750095
     DROP TABLE r540_tmp
# No.FUN-750095--begin--
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                 
     LET g_str = ''                                                                                                                   
     IF g_zz05 = 'Y' THEN                                                                                                             
        CALL cl_wcchp(tm.wc,'mss01,ima67,mss02,ima08,ima43')                                                              
             RETURNING tm.wc                                                                                                          
        LET g_str = tm.wc                                                                                                             
     END IF                                                                                                                           
     LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t                                                    
                      ,";",tm.ver_no,";",tm.edate                                                                            
     CALL cl_prt_cs3('amrr540','amrr540',l_sql,g_str)
# No.FUN-750095--end--
END FUNCTION
 
# No.FUN-750095--begin--
{
REPORT amrr540_rep(sr,mss, ima,mst,p_lastbal)
   DEFINE l_last_sw     LIKE type_file.chr1        #NO.FUN-680082 VARCHAR(1)
   DEFINE l_pmc03       LIKE pmc_file.pmc03 
   DEFINE l_ima02       LIKE ima_file.ima02
   DEFINE l_ima25       LIKE ima_file.ima25
   DEFINE p_lastbal     LIKE mss_file.mss08
   DEFINE mss           RECORD LIKE mss_file.*
   DEFINE mst           RECORD LIKE mst_file.*
   DEFINE ima           RECORD LIKE ima_file.*
   DEFINE sr            RECORD
                        l_order1 LIKE mss_file.mss01, #FUN-5B0105 20->40     #NO.FUN-680082 VARCHAR(40)
                        l_order2 LIKE mss_file.mss01, #FUN-5B0105 20->40     #NO.FUN-680082 VARCHAR(40)
                        l_order3 LIKE mss_file.mss01  #FUN-5B0105 20->40     #NO.FUN-680082 VARCHAR(40)
                        END RECORD
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.l_order1,sr.l_order2,sr.l_order3,mss.mss01,mss.mss02,mss.mss03,
           mst.mst04 DESC,mst.mst05
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED    #No.TQC-6A0080
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED      #No.TQC-6A0080
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
 
      LET g_head1=g_x[11] CLIPPED,tm.ver_no,g_x[12] CLIPPED,tm.edate
      PRINT g_head1
      PRINT g_dash[1,g_len] 
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
            g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.l_order1
      IF tm.t[1,1]='Y' AND (PAGENO > 1 OR LINENO > 9) THEN
         SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.l_order2
      IF tm.t[2,2]='Y' AND (PAGENO > 1 OR LINENO > 9) THEN
         SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.l_order3
      IF tm.t[3,3]='Y' AND (PAGENO > 1 OR LINENO > 9) THEN
         SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF mss.mss02
         SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01=mss.mss02
         PRINT COLUMN g_c[31],mss.mss01,
               COLUMN g_c[32],ima.ima02,
               COLUMN g_c[33],ima.ima25
         PRINT COLUMN g_c[34],mss.mss02[1,7],
               COLUMN g_c[35],l_pmc03,
               COLUMN g_c[37],cl_numfor(p_lastbal,37,0) 
 
   ON EVERY ROW
         SELECT ima02,ima25 INTO l_ima02,l_ima25 FROM ima_file WHERE ima01=mst.mst07
         PRINT COLUMN g_c[31],mst.mst07 CLIPPED,
               COLUMN g_c[32],l_ima02,
               COLUMN g_c[33],l_ima25, 
               COLUMN g_c[36],mss.mss00 USING '###&', #FUN-590118
               COLUMN g_c[38],mst.mst06,             #No.FUN-550055
               COLUMN g_c[39],mst.mst061 USING '###&', #FUN-590118
               COLUMN g_c[40],cl_numfor(mst.mst08,40,0), 
               COLUMN g_c[41],mst.mst04
 
   AFTER GROUP OF mss.mss02
         PRINT g_dash2[1,g_len] CLIPPED
 
   ON LAST ROW
      LET l_last_sw = 'y'
      PRINT g_dash[1,g_len] CLIPPED
      PRINT g_x[4] CLIPPED, COLUMN (g_len-9),g_x[7]
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash2[1,g_len] CLIPPED
         PRINT g_x[4] CLIPPED, COLUMN (g_len-9),g_x[6]
         ELSE SKIP 2 LINE
      END IF
END REPORT
}
# No.FUN-750095--end--
