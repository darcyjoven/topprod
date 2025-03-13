# Prog. Version..: '5.30.07-13.05.30(00002)'     #
#
# Pattern name...: amsx500.4gl
# Descriptions...: MPS 模擬彙總報表
# Input parameter: 
# Return code....: 
# Date & Author..: 96/06/10 By Roger
# Modify.........: No.FUN-510036 05/01/18 By pengu 報表轉XML
# Modify.........: No.FUN-570240 05/07/26 By Trisy 料件編號開窗 
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: No.TQC-5C0005 05/12/05 By kevin 結束位置調整
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610075 06/01/24 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.MOD-640517 06/04/019 By pengu 報表顯示欄位少了[預測量]
# Modify.........: No.FUN-680101 06/08/29 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-690116 06/10/16 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0081 06/11/06 By atsea l_time轉g_time
# Modify.........: No.FUN-770012 07/07/12 By johnray 修改報表功能，使用CR打印報表
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-CB0004 12/11/06 By dongsz CR轉XtraGrid
# Modify.........: No.FUN-D40128 13/05/08 By wangrr "來源碼"增加開窗
# Modify.........: No.FUN-D50114 13/05/30 By wangrr 修改動態分組設置
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                          # Print condition RECORD
              wc      LIKE type_file.chr1000, #NO.FUN-680101 VARCHAR(600)   # Where condition
              edate   LIKE type_file.dat,     #NO.FUN-680101 DATE
              ver_no  LIKE mps_file.mps_v,    #NO.FUN-680101 VARCHAR(3)
              n       LIKE type_file.chr2,    #NO.FUN-680101 VARCHAR(2)
              s       LIKE type_file.chr3,    #NO.FUN-680101 VARCHAR(3)     #排列
              t       LIKE type_file.chr3,    #NO.FUN-680101 VARCHAR(3)     #跳頁
              more    LIKE type_file.chr1     #NO.FUN-680101 VARCHAR(2)     # Input more condition(Y/N)
              END RECORD
 
DEFINE   g_cnt        LIKE type_file.num10    #NO.FUN-680101 INTEGER  
DEFINE   g_i          LIKE type_file.num5     #NO.FUN-680101 SMALLINT  #count/index for any purpose
DEFINE   g_msg        LIKE type_file.chr1000  #NO.FUN-680101 VARCHAR(72)
#No.FUN-770012 -- begin --
DEFINE g_sql      STRING
DEFINE l_table    STRING
DEFINE g_str      STRING
#No.FUN-770012 -- end --
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
   #TQC-610075-begin
   LET tm.edate = ARG_VAL(8)
   LET tm.ver_no = ARG_VAL(9)
  #LET tm.n = ARG_VAL(10)             #FUN-CB0004 mark
   LET tm.s = ARG_VAL(11)
   LET tm.t = ARG_VAL(12)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(8)
   #LET g_rep_clas = ARG_VAL(9)
   #LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   ##No.FUN-570264 ---end---
   #TQC-610075-end
#No.FUN-770012 -- begin --
   LET g_sql = "order1.mps_file.mps01,",
               "order2.mps_file.mps01,",
               "order3.mps_file.mps01,",
               "l_cnt.type_file.num10,",
               "ima08.ima_file.ima08,",
               "ima67.ima_file.ima67,",
               "ima43.ima_file.ima43,",
               "mps01.mps_file.mps01,",
               "ima25.ima_file.ima25,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",       #FUN-CB0004 add
               "mps00.mps_file.mps00,",
               "mps03.mps_file.mps03,",
               "mps039.mps_file.mps039,",
               "mps041.mps_file.mps041,",
               "mps043.mps_file.mps043,",
               "mps044.mps_file.mps044,",
               "mps051.mps_file.mps051,",
               "mps052.mps_file.mps052,",
               "mps053.mps_file.mps053,",
               "l_qoh.mps_file.mps039,",
               "mps061.mps_file.mps061,",
               "mps062.mps_file.mps062,",
               "mps063.mps_file.mps063,",
               "mps064.mps_file.mps064,",
               "mps065.mps_file.mps065,",
               "l_drq.mps_file.mps071,",
               "mps08.mps_file.mps08,",
               "mps09.mps_file.mps09,",
               "g_msg.type_file.chr1000,",
               "l_pot.type_file.num5"         #FUN-CB0004 add
   LET l_table = cl_prt_temptable('amsx500',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"           #FUN-CB0004 add 2?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#No.FUN-770012 -- end --
   IF cl_null(g_bgjob) OR g_bgjob='N'        # If background job sw is off
      THEN CALL amsx500_tm(0,0)        # Input print condition
      ELSE CALL amsx500()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION amsx500_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01    #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,   #NO.FUN-680101 SMALLINT
          l_cnt          LIKE type_file.num5,   #NO.FUN-680101 SMALLINT
          l_cmd          LIKE type_file.chr1000 #NO.FUN-680101 VARCHAR(400)
 
   LET p_row = 4 LET p_col = 17
   OPEN WINDOW amsx500_w AT p_row,p_col WITH FORM "ams/42f/amsx500" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
  #LET tm.n    = '2'                  #FUN-CB0004 mark
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.s = '123'
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
   CONSTRUCT BY NAME tm.wc ON mps01,ima08,ima67,ima43 
#No.FUN-570240 --start--                                                                                    
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION CONTROLP                                                                                              
           #IF INFIELD(mps01) THEN                     FUN-CB0004 mark
         CASE
            WHEN INFIELD(mps01)                                                                             
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form = "q_ima"                                                                                       
               LET g_qryparam.state = "c"                                                                                           
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
               DISPLAY g_qryparam.multiret TO mps01                                                                                 
               NEXT FIELD mps01
           #FUN-CB0004--add--str---
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
           #FUN-CB0004--add--end---
           #FUN-D40128--add--str--
           WHEN INFIELD(ima08)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ima7"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ima08
              NEXT FIELD ima08
           #FUN-D40128--add--end
         END CASE                          #FUN-CB0004 add                                                                                    
         #  END IF                        #FUN-CB0004 mark
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
      LET INT_FLAG = 0
      EXIT WHILE 
   END IF
 
  #INPUT BY NAME tm.edate,tm.ver_no,tm.n,                  #FUN-CB0004 mark
   INPUT BY NAME tm.edate,tm.ver_no,                       #FUN-CB0004 add
                   tm2.s1,tm2.s2,tm2.s3,
                   tm2.t1,tm2.t2,tm2.t3,
                   tm.more WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD ver_no
         IF NOT cl_null(tm.ver_no) THEN 
            SELECT COUNT(*) INTO l_cnt FROM mps_file
             WHERE mps_v= tm.ver_no
            IF l_cnt = 0 THEN
               CALL cl_err('','ams-367',1)       
               NEXT FIELD ver_no
            END IF 
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
   {  ON ACTION controlp
           CASE
              WHEN INFIELD(ver_no)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_mpb"
                 LET g_qryparam.default1 = tm.ver_no
                 CALL cl_create_qry() RETURNING tm.ver_no 
                 DISPLAY g_qryparam.multiret TO ver_no
                 NEXT FIELD ver_no
              OTHERWISE
                 EXIT CASE
           END CASE
   }
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
      LET INT_FLAG = 0 CLOSE WINDOW amsx500_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='amsx500'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amsx500','9031',1)
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
                         #TQC-610075-begin
                         " '",tm.edate CLIPPED,"'",
                         " '",tm.ver_no CLIPPED,"'",
                        #" '",tm.n CLIPPED,"'",           #FUN-CB0004 mark
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         #TQC-610075-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('amsx500',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW amsx500_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL amsx500()
   ERROR ""
 
 END WHILE
 CLOSE WINDOW amsx500_w
 
END FUNCTION
 
FUNCTION amsx500()
   DEFINE l_name    LIKE type_file.chr20,    #NO.FUN-680101 VARCHAR(20)   # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0081
          l_sql     LIKE type_file.chr1000,  #NO.FUN-680101 VARCHAR(1000) # RDSQL STATEMENT
          l_chr     LIKE type_file.chr1,     #NO.FUN-680101 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,  #NO.FUN-680101 VARCHAR(40)
          l_order  ARRAY[3] OF   LIKE mps_file.mps01,  #FUN-5B0105 20->40 #NO.FUN-680101 VARCHAR(40)
     sr RECORD 
          l_order1  LIKE mps_file.mps01,   #FUN-5B0105 20->40  #NO.FUN-680101 VARCHAR(40)
          l_order2  LIKE mps_file.mps01,   #FUN-5B0105 20->40  #NO.FUN-680101 VARCHAR(40)
          l_order3  LIKE mps_file.mps01    #FUN-5B0105 20->40  #NO.FUN-680101 VARCHAR(40)
      END RECORD,
          mps   RECORD LIKE mps_file.*, 
          l_ima02       LIKE ima_file.ima02,
          l_ima021      LIKE ima_file.ima021,          #FUN-CB0004 add
          l_ima08       LIKE ima_file.ima08,
          l_ima67       LIKE ima_file.ima67,
          l_ima43       LIKE ima_file.ima43,
          l_ima25       LIKE ima_file.ima25
#No.FUN-770012 -- begin --
   DEFINE l_order1_t LIKE mps_file.mps01
   DEFINE l_order2_t LIKE mps_file.mps01
   DEFINE l_order3_t LIKE mps_file.mps01
   DEFINE l_mps01_t  LIKE mps_file.mps01
   DEFINE l_cnt      LIKE type_file.num10
   DEFINE l_qoh      LIKE mps_file.mps039
   DEFINE l_drq      LIKE mps_file.mps039
   DEFINE l_pot      LIKE type_file.num5               #FUN-CB0004 add
#No.FUN-770012 -- end --
 
     CALL cl_del_data(l_table)     #No.FUN-770012
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = "SELECT '','','',mps_file.*,ima02,ima021,ima25,ima08,ima67,ima43",     #FUN-CB0004 add ima021
                 "  FROM mps_file, ima_file",
                 " WHERE ",tm.wc CLIPPED,
                 "   AND mps01=ima01 ",
                 "   AND mps_v='",tm.ver_no,"'"
    IF tm.edate IS NOT NULL THEN
       LET l_sql=l_sql CLIPPED,
                 "   AND mps03<='",tm.edate,"'"
    END IF
    LET l_sql = l_sql CLIPPED," ORDER BY ima08,ima67,ima43,mps01"   #No.FUN-770012 l_cnt計數
    PREPARE amsx500_prepare1 FROM l_sql
    IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
       EXIT PROGRAM 
    END IF
    DECLARE amsx500_curs1 CURSOR FOR amsx500_prepare1
 
#No.FUN-770012 -- begin --
#    CALL cl_outnam('amsx500') RETURNING l_name
#    START REPORT amsx500_rep TO l_name
#    LET g_pageno = 0
   #分組改變新舊值比較,l_cnt計數
   INITIALIZE l_order1_t TO NULL
   INITIALIZE l_order2_t TO NULL
   INITIALIZE l_order3_t TO NULL
   INITIALIZE l_mps01_t TO NULL
   LET l_cnt = 0
#No.FUN-770012 -- end --
   FOREACH amsx500_curs1 INTO sr.*,mps.*, l_ima02,l_ima021,l_ima25,l_ima08,l_ima67,l_ima43      #FUN-CB0004 add l_ima021
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF     #No.FUN-770012
      FOR g_cnt = 1 TO 3 
         CASE 
            WHEN tm.s[g_cnt,g_cnt]='1' LET l_order[g_cnt] = mps.mps01
            WHEN tm.s[g_cnt,g_cnt]='2' LET l_order[g_cnt] = l_ima08
            WHEN tm.s[g_cnt,g_cnt]='3' LET l_order[g_cnt] = l_ima67
            WHEN tm.s[g_cnt,g_cnt]='4' LET l_order[g_cnt] = l_ima43
            OTHERWISE LET l_order[g_cnt]='-' 
         END CASE 
      END FOR 
      LET sr.l_order1 = l_order[1] 
      LET sr.l_order2 = l_order[2] 
      LET sr.l_order3 = l_order[3] 
 
#      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF   #No.FUN-770012
#No.FUN-770012 -- begin --
#      OUTPUT TO REPORT amsx500_rep(sr.*,mps.*,
#                                   l_ima02,l_ima25,l_ima08,l_ima67,l_ima43)
      #組內計數
      IF l_cnt = 0 OR sr.l_order1 <> l_order1_t OR sr.l_order2 <> l_order2_t
         OR sr.l_order3 <> l_order3_t OR mps.mps01 <> l_mps01_t THEN
         LET l_order1_t = sr.l_order1
         LET l_order2_t = sr.l_order2
         LET l_order3_t = sr.l_order3
         LET l_mps01_t  = mps.mps01
         LET l_cnt      = 1
      ELSE
         LET l_cnt      = l_cnt+1
      END IF
      LET l_qoh = l_qoh + (mps.mps051 + mps.mps052 + mps.mps053
                        - mps.mps041 - mps.mps043 - mps.mps044)
      LET l_drq = mps.mps072 - mps.mps071
      LET l_pot = 0                        #FUN-CB0004 add
      EXECUTE insert_prep USING sr.l_order1,sr.l_order2,sr.l_order3,l_cnt,l_ima08,
                                l_ima67,l_ima43,mps.mps01,l_ima25, l_ima02,l_ima021,mps.mps00,     #FUN-CB0004 add l_ima021
                                mps.mps03,mps.mps039,mps.mps041,mps.mps043,mps.mps044,
                                mps.mps051,mps.mps052,mps.mps053,l_qoh,mps.mps061,
                                mps.mps062,mps.mps063,mps.mps064,mps.mps065,l_drq,
                                mps.mps08,mps.mps09,g_msg,l_pot                             #FUN-CB0004 add l_pot
      IF STATUS THEN
         CALL cl_err("execute insert_prep:",STATUS,1)
         EXIT FOREACH
      END IF
#No.FUN-770012 -- end --
   END FOREACH
 
#No.FUN-770012 -- begin --
#     FINISH REPORT amsx500_rep
#
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    LET g_xgrid.table = l_table    ###XtraGrid###
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
     IF g_zz05='Y' THEN 
        CALL cl_wcchp(tm.wc,'mps01,ima08,ima67,ima43')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
###XtraGrid###     LET g_str = tm.t,";",tm.n,";",g_str
###XtraGrid###     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
###XtraGrid###     CALL cl_prt_cs3('amsx500','amsx500',g_sql,g_str)
   #FUN-CB0004--add--str---
    LET g_xgrid.order_field = cl_get_order_field(tm.s,"mps01,ima08,ima67,ima43")
    LET g_xgrid.grup_field = cl_get_sum_field(tm.s,tm.t,"mps01,ima08,ima67,ima43") #FUN-D50114 unMark
    LET g_xgrid.grup_field = cl_get_order_field(tm.s,"mps01,ima08,ima67,ima43")    #FUN-D50114 unMark
   #LET g_xgrid.grup_field = "mps01"  #FUN-D50114 Mark
    LET g_xgrid.skippage_field = cl_get_skip_field(tm.s,tm.t,"mps01,ima08,ima67,ima43")
    LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc
   #FUN-CB0004--add--end--- 
    CALL cl_xg_view()    ###XtraGrid###
#No.FUN-770012 -- end --
END FUNCTION
 
#No.FUN-770012 -- begin --
#REPORT amsx500_rep(sr,mps, l_ima02,l_ima25,l_ima08,l_ima67,l_ima43)
#   DEFINE l_last_sw    LIKE type_file.chr1    #NO.FUN-680101 VARCHAR(1)
#   DEFINE 
#        sr RECORD l_order1     LIKE mps_file.mps01, #FUN-5B0105 20->40   #NO.FUN-680101 VARCHAR(40)
#                  l_order2     LIKE mps_file.mps01, #FUN-5B0105 20->40   #NO.FUN-680101 VARCHAR(40)
#                  l_order3     LIKE mps_file.mps01  #FUN-5B0105 20->40   #NO.FUN-680101 VARCHAR(40)
#           END RECORD 
#   DEFINE mps           RECORD LIKE mps_file.*
#   DEFINE l_ima02       LIKE ima_file.ima02
#   DEFINE l_ima25     LIKE ima_file.ima25
#   DEFINE l_ima08     LIKE ima_file.ima08
#   DEFINE l_ima67     LIKE ima_file.ima67
#   DEFINE l_ima43     LIKE ima_file.ima43
#   DEFINE l_QOH       LIKE mps_file.mps039    #NO.FUN-680101 DEC(15,3)
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#  ORDER BY sr.l_order1,sr.l_order2,sr.l_order3,mps.mps01,mps.mps03
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#
#
#      PRINT g_dash[1,g_len] CLIPPED
#      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
#            g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED,g_x[42] CLIPPED,
#            g_x[43] CLIPPED,g_x[44] CLIPPED,g_x[45] CLIPPED,g_x[46] CLIPPED,
#            g_x[47] CLIPPED,g_x[48] CLIPPED,g_x[49] CLIPPED,g_x[50] CLIPPED,
#            g_x[51] CLIPPED      #No.MOD-640517 add
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.l_order1 
#     IF tm.t[1,1] = 'Y' AND (PAGENO >1 OR LINENO >9) THEN 
#          SKIP TO TOP OF PAGE  
#     END IF 
#   BEFORE GROUP OF sr.l_order2 
#     IF tm.t[2,2] = 'Y' AND (PAGENO >1 OR LINENO >9) THEN 
#          SKIP TO TOP OF PAGE
#     END IF 
#  BEFORE GROUP OF sr.l_order3 
#    IF tm.t[3,3] = 'Y' AND (PAGENO >1 OR LINENO >9) THEN 
#         SKIP TO TOP OF PAGE 
#    END IF 
#
#   BEFORE GROUP OF mps.mps01
#      PRINT COLUMN g_c[31],mps.mps01 CLIPPED,  #FUN-5B0014 [1,20],
#            COLUMN g_c[32],l_ima25;
#      LET g_cnt=0
#      LET l_QOH=0
#
#   ON EVERY ROW
#      IF tm.n='2' THEN
#         LET g_cnt=g_cnt+1
#         IF g_cnt=2 THEN PRINT l_ima02; END IF
#         LET l_QOH=l_QOH+(mps.mps051+mps.mps052+mps.mps053
#                         -mps.mps041-mps.mps043-mps.mps044)
#         PRINT COLUMN g_c[33],mps.mps00 USING '###&', #FUN-590118
#               COLUMN g_c[34],mps.mps03 USING 'mm/dd',
#               COLUMN g_c[51],cl_numfor(mps.mps039 ,51,0),     #No.MOD-640517 add
#               COLUMN g_c[35],cl_numfor(mps.mps041 ,35,0),
#               COLUMN g_c[36],cl_numfor(mps.mps043 ,36,0),
#               COLUMN g_c[37],cl_numfor(mps.mps044 ,37,0),
#               COLUMN g_c[38],cl_numfor(mps.mps051 ,38,0),
#               COLUMN g_c[39],cl_numfor(mps.mps052 ,39,0),
#               COLUMN g_c[40],cl_numfor(mps.mps053 ,40,0),
#               COLUMN g_c[41],cl_numfor(l_QOH      ,41,0),
#               COLUMN g_c[42],cl_numfor(mps.mps061 ,42,0),
#               COLUMN g_c[43],cl_numfor(mps.mps062 ,43,0),
#               COLUMN g_c[44],cl_numfor(mps.mps063 ,44,0),
#               COLUMN g_c[45],cl_numfor(mps.mps064 ,45,0),
#               COLUMN g_c[46],cl_numfor(mps.mps065 ,46,0),
#               COLUMN g_c[47],cl_numfor((mps.mps072-mps.mps071),47,0), 
#               COLUMN g_c[48],cl_numfor(mps.mps08 ,48,0), 
#               COLUMN g_c[49],cl_numfor(mps.mps09 ,49,0), 
#               COLUMN g_c[50],g_msg[1,10] CLIPPED
#      END IF
#   AFTER GROUP OF mps.mps01
#      IF tm.n='2' THEN
#         IF g_cnt<2 THEN PRINT l_ima02  END IF
#         PRINT
#      END IF
#      IF tm.n='1' THEN
#         LET l_QOH=GROUP SUM(mps.mps051+mps.mps052+mps.mps053
#                            -mps.mps041-mps.mps043-mps.mps044)
#         PRINT COLUMN g_c[33],mps.mps00 USING '#####',
#               COLUMN g_c[35],cl_numfor(GROUP SUM(mps.mps041) ,35,0),
#               COLUMN g_c[36],cl_numfor(GROUP SUM(mps.mps043) ,36,0),
#               COLUMN g_c[37],cl_numfor(GROUP SUM(mps.mps044) ,37,0),
#               COLUMN g_c[38],cl_numfor(GROUP SUM(mps.mps051) ,38,0),
#               COLUMN g_c[39],cl_numfor(GROUP SUM(mps.mps052) ,39,0),
#               COLUMN g_c[40],cl_numfor(GROUP SUM(mps.mps053) ,40,0),
#               COLUMN g_c[41],cl_numfor(l_QOH                 ,41,0),
#               COLUMN g_c[42],cl_numfor(GROUP SUM(mps.mps061) ,42,0),
#               COLUMN g_c[43],cl_numfor(GROUP SUM(mps.mps062) ,43,0),
#               COLUMN g_c[44],cl_numfor(GROUP SUM(mps.mps063) ,44,0),
#               COLUMN g_c[45],cl_numfor(GROUP SUM(mps.mps064) ,45,0),
#               COLUMN g_c[46],cl_numfor(GROUP SUM(mps.mps065) ,46,0),
#               COLUMN g_c[47],cl_numfor(GROUP SUM(mps.mps072-mps.mps071),47,0), 
#               COLUMN g_c[48],cl_numfor(GROUP SUM(mps.mps08 ),48,0), 
#               COLUMN g_c[49],cl_numfor(GROUP SUM(mps.mps09 ),49,0) 
#         PRINT l_ima02
#      END IF
#   ON LAST ROW
#      LET l_last_sw = 'y'
#      PRINT g_dash[1,g_len] CLIPPED
#      #PRINT '(amsx500)'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED #No.TQC-5C0005
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len] CLIPPED
#              #PRINT '(amsx500)'
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #No.TQC-5C0005
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#No.FUN-770012 -- end --


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
