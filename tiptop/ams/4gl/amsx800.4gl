# Prog. Version..: '5.30.07-13.05.30(00002)'     #
#
# Pattern name...: amsx800.4gl
# Descriptions...: MPS Slow Moving Report
# Input parameter: 
# Return code....: 
# Date & Author..: 98/06/29 By Eric
# Modify ........: No:8342 03/09/25 By Apple 版本欄位應該是抓MPS的版本檔案(mpr_file)
# Modify.........: No.FUN-510036 05/01/19 By pengu 報表轉XML
# Modify.........: No.FUN-570240 05/07/26 By Trisy 料件編號開窗 
# Modify.........: No.TQC-5C0005 05/12/05 By kevin 結束位置調整
# Modify.........: No.TQC-610075 06/01/24 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680101 06/08/30 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-690116 06/10/16 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0081 06/11/06 By atsea l_time轉g_time
# Modify.........: No.TQC-6A0080 06/11/16 By cheunl   修改報表格式
# Modify.........: No.FUN-740078 07/05/04 By TSD.Achick報表改寫由Crystal Report產出
# Modify.........: No.TQC-950116 09/06/05 By chenmoyan cr建立的temp table使用到關鍵字plan
# Modify.........: No.MOD-960196 09/06/23 By lilingyu 當供給大于等于需求時才有可能呆滯
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-CB0004 12/11/05 By dongsz CR轉XtraGrid
# Modify.........: No.FUN-D40117 13/05/13 By chenying 排序選擇[料號]時按照料號排序
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,#NO.FUN-680101 VARCHAR(600)     # Where condition
              ver_no  LIKE rqa_file.rqa02,   #NO.FUN-680101 VARCHAR(2)
              edate   LIKE type_file.dat,    #NO.FUN-680101 DATE
              l_sw    LIKE type_file.chr1,   #NO.FUN-680101 VARCHAR(01)
              maxqty  LIKE mps_file.mps051,  #NO.FUN-680101 DEC(08,0)
              order   LIKE type_file.chr1,   #NO.FUN-680101 VARCHAR(1)
              more    LIKE type_file.chr1    #NO.FUN-680101 VARCHAR(1)        # Input more condition(Y/N)
              END RECORD
 
DEFINE   g_i          LIKE type_file.num5    #NO.FUN-680101 SMALLINT       #count/index for any purpose
DEFINE   g_head1      STRING
DEFINE l_table     STRING                       ### FUN-740078 add ###
DEFINE g_sql       STRING                       ### FUN-740078 add ###
DEFINE g_str       STRING                       ### FUN-740078 add ###
 
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
 
#   #str FUN-740078 add
# *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> 2007/05/04 *** ##
     LET g_sql = "order1.ima_file.ima23,",
                 "ima01.ima_file.ima01,",   
                 "ima02.ima_file.ima02,",   
                 "ima08.ima_file.ima08,",   
                 "ima23.ima_file.ima23,",   
                 "ima25.ima_file.ima25,",   
                 "ima43.ima_file.ima43,",   
                 "ima67.ima_file.ima67,",  
                 "inline.mps_file.mps051,", 
                 "iqc.mps_file.mps052,",  
                 "order2.mps_file.mps061,",
#                "plan.mps_file.mps065 "       #No.TQC-950116
                 "plan_1.mps_file.mps065,",    #No.TQC-950116
                 "total.mps_file.mps065,",      #FUN-CB0004 add
                 "mps01.mps_file.mps01,",       #FUN-CB0004 add
                 "ima021.ima_file.ima021,",        #FUN-CB0004 add
                 "gen02_1.gen_file.gen02,",        #FUN-CB0004 add
                 "gen02_2.gen_file.gen02"          #FUN-CB0004 add
 
    LET l_table = cl_prt_temptable('amsx800',g_sql) CLIPPED   # 產生Temp Table
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,? ,?,?,?,?,?,
                         ?,?,?,?,?,?,?)"                #FUN-CB0004 add 5?
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF
#----------------------------------------------------------CR (1) ------------#
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #TQC-610075-begin
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(8)
   #LET g_rep_clas = ARG_VAL(9)
   #LET g_template = ARG_VAL(10)
   ##No.FUN-570264 ---end---
   LET tm.ver_no = ARG_VAL(8)
   LET tm.edate  = ARG_VAL(9)
   LET tm.l_sw   = ARG_VAL(10)
   LET tm.maxqty = ARG_VAL(11)
   LET tm.order  = ARG_VAL(12)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #TQC-610075-end
   IF cl_null(g_bgjob) OR g_bgjob='N'        # If background job sw is off
      THEN CALL amsx800_tm(0,0)        # Input print condition
      ELSE CALL amsx800()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION amsx800_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01    #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,   #NO.FUN-680101 SMALLINT
          l_mpr RECORD   LIKE mpr_file.*,       #No:8342
          l_cmd          LIKE type_file.chr1000 #NO.FUN-680101 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 17
   ELSE LET p_row = 3 LET p_col = 15
   END IF
   OPEN WINDOW amsx800_w AT p_row,p_col WITH FORM "ams/42f/amsx800" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET tm.order = '1'
   LET tm.maxqty = 0
   LET tm.edate = NULL
   LET tm.l_sw = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON mps01,ima08,ima67,ima43,ima23 
#No.FUN-570240 --start--                                                                                    
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION controlp                                                                                              
           #IF INFIELD(mps01) THEN            #FUN-CB0004 mark
        CASE                       #FUN-CB0004 add
            WHEN INFIELD(mps01)    #FUN-CB0004 add                                                                                         
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
         WHEN INFIELD(ima23)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_gen"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima23
            NEXT FIELD ima23
         WHEN INFIELD(ima43)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_gen"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima43
            NEXT FIELD ima43       
        END CASE                                                                     
           #FUN-CB0004--add--end---                                                                                                
          # END IF                   #FUN-CB0004 mark 
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
      LET INT_FLAG = 0 CLOSE WINDOW amsx800_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
   INPUT BY NAME tm.ver_no, tm.edate, tm.l_sw,tm.maxqty,tm.order,tm.more 
    WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD ver_no
         IF cl_null(tm.ver_no) THEN NEXT FIELD ver_no END IF
         SELECT * INTO l_mpr.* FROM mpr_file WHERE mpr_v=tm.ver_no   #No:8342
         IF STATUS <> 0 THEN
            ERROR 'MRP Version not found!'
            LET tm.ver_no=' '
            NEXT FIELD ver_no
         END IF
         LET tm.edate=l_mpr.edate  #No:8342
 
      AFTER FIELD l_sw
         IF cl_null(tm.l_sw) THEN 
            LET tm.l_sw='N'
            NEXT FIELD l_sw
         END IF
         IF tm.l_sw NOT MATCHES '[YN]' THEN
            LET tm.l_sw='N'
            NEXT FIELD l_sw
         END IF
 
      AFTER FIELD edate
         IF tm.edate IS NULL THEN
            LET tm.edate=l_mpr.edate       #No:8342
            NEXT FIELD edate
         END IF
         IF tm.edate > l_mpr.edate THEN    #No:8342
            LET tm.edate=l_mpr.edate       #No:8342
            NEXT FIELD edate
         END IF
 
      AFTER FIELD order
         IF cl_null(tm.order) THEN NEXT FIELD order END IF
         IF tm.order NOT MATCHES '[1234]' THEN
            LET tm.order='1'
            NEXT FIELD order
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
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW amsx800_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='amsx800'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amsx800','9031',1)
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
                         " '",tm.ver_no CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",tm.l_sw CLIPPED,"'",
                         " '",tm.maxqty CLIPPED,"'",
                         " '",tm.order CLIPPED,"'",
                         #TQC-610075-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('amsx800',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW amsx800_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL amsx800()
   ERROR ""
END WHILE
   CLOSE WINDOW amsx800_w
END FUNCTION
 
FUNCTION amsx800()
   DEFINE l_name    LIKE type_file.chr20,  #NO.FUN-680101 VARCHAR(20)   # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0081
          l_sql     LIKE type_file.chr1000,#NO.FUN-680101 VARCHAR(1000) # RDSQL STATEMENT
          l_chr     LIKE type_file.chr1,   #NO.FUN-680101 VARCHAR(1)
          l_n       LIKE type_file.num5,   #NO.FUN-680101 SMALLINT
          l_za05    LIKE type_file.chr1000,#NO.FUN-680101 VARCHAR(40)
          l_supply,l_demand  LIKE mps_file.mps051,  #NO.FUN-680101 DEC(12,3)
          l_mps01 LIKE mps_file.mps01,
          ss  RECORD 
              order1 LIKE ima_file.ima23,
              ima01  LIKE ima_file.ima01,   
              ima02  LIKE ima_file.ima02,  
              ima021 LIKE ima_file.ima021,           #FUN-CB0004 add 
              ima08  LIKE ima_file.ima08,   
              ima23  LIKE ima_file.ima23,   
              ima25  LIKE ima_file.ima25,   
              ima43  LIKE ima_file.ima43,   
              ima67  LIKE ima_file.ima67,   
              inline LIKE mps_file.mps051, #NO.FUN-680101 DEC(12,3)
              iqc    LIKE mps_file.mps052, #NO.FUN-680101 DEC(12,3)
              order  LIKE mps_file.mps061, #NO.FUN-680101 DEC(12,3)
              plan   LIKE mps_file.mps065  #NO.FUN-680101 DEC(12,3) 
              END RECORD,
          sr  RECORD 
              order1 LIKE ima_file.ima23,
              ima01  LIKE ima_file.ima01,   
              ima02  LIKE ima_file.ima02,   
              ima021 LIKE ima_file.ima021,          #FUN-CB0004 add
              ima08  LIKE ima_file.ima08,   
              ima23  LIKE ima_file.ima23,   
              ima25  LIKE ima_file.ima25,   
              ima43  LIKE ima_file.ima43,   
              ima67  LIKE ima_file.ima67,   
              mps051 LIKE mps_file.mps051,   
              mps052 LIKE mps_file.mps052,   
              mps053 LIKE mps_file.mps053,   
              mps061 LIKE mps_file.mps061,   
              mps062 LIKE mps_file.mps062,   
              mps063 LIKE mps_file.mps063,   
              mps064 LIKE mps_file.mps064,   
              mps065 LIKE mps_file.mps065   
              END RECORD
   DEFINE l_total    LIKE mps_file.mps065            #FUN-CB0004 add
   DEFINE l_str      STRING                          #FUN-CB0004 add
   DEFINE l_gen02_1  LIKE gen_file.gen02   #FUN-CB0004 add
   DEFINE l_gen02_2  LIKE gen_file.gen02   #FUN-CB0004 add

 
#str FUN-740078 add
## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> FUN-740078 *** ##
 
    CALL cl_del_data(l_table)
 
# ------------------------------------------------------ CR (2) ------- ##
 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-740078 add ###
 
     LET l_sql = "SELECT UNIQUE mps01",
                 "  FROM mps_file, ima_file",
                 " WHERE ",tm.wc CLIPPED,
                 "   AND mps01=ima01 ",
                 "   AND mps_v='",tm.ver_no,"'",
                 "   AND mps03 <='",tm.edate,"'"
 
     LET g_pageno = 0
     PREPARE amsx800_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
        EXIT PROGRAM 
     END IF
     DECLARE amsx800_curs1 CURSOR FOR amsx800_prepare1
     FOREACH amsx800_curs1 INTO l_mps01
       IF STATUS THEN CALL cl_err('foreach1:',STATUS,1) EXIT FOREACH END IF
       LET sr.mps051=0
       LET sr.mps052=0
       LET sr.mps053=0
       LET sr.mps061=0
       LET sr.mps062=0
       LET sr.mps063=0
       LET sr.mps064=0
       LET sr.mps065=0
       LET l_demand=0
       SELECT SUM(mps051),SUM(mps052),SUM(mps053),SUM(mps061),SUM(mps062),
              SUM(mps063),SUM(mps064),SUM(mps065),SUM(mps041+mps043+mps044) 
         INTO sr.mps051,sr.mps052,sr.mps053,sr.mps061,sr.mps062,
              sr.mps063,sr.mps064,sr.mps065,l_demand FROM mps_file
        WHERE mps_v=tm.ver_no AND mps01=l_mps01 AND mps03 <= tm.edate
       IF sr.mps051 IS NULL THEN LET sr.mps051=0 END IF 
       IF sr.mps052 IS NULL THEN LET sr.mps052=0 END IF 
       IF sr.mps053 IS NULL THEN LET sr.mps053=0 END IF 
       IF sr.mps061 IS NULL THEN LET sr.mps061=0 END IF 
       IF sr.mps062 IS NULL THEN LET sr.mps062=0 END IF 
       IF sr.mps063 IS NULL THEN LET sr.mps063=0 END IF 
       IF sr.mps064 IS NULL THEN LET sr.mps064=0 END IF 
       IF sr.mps065 IS NULL THEN LET sr.mps065=0 END IF 
       IF l_demand IS NULL THEN LET l_demand=0 END IF
       LET l_supply= sr.mps051+sr.mps052+sr.mps053+sr.mps061+sr.mps062+
                     sr.mps063+sr.mps064+sr.mps065 
      #IF l_supply >= l_demand THEN  #MOD-960196
       IF l_supply < l_demand THEN   #MOD-960196
          CONTINUE FOREACH
       END IF
       IF l_supply < tm.maxqty THEN
          CONTINUE FOREACH
       END IF
       IF tm.l_sw='Y' AND l_demand <> 0 THEN
          CONTINUE FOREACH
       END IF
       SELECT ima01,ima02,ima021,ima08,ima23,ima25,ima43,ima67                 #FUN-CB0004 add ima021
         INTO sr.ima01,sr.ima02,sr.ima021,sr.ima08,sr.ima23,sr.ima25,sr.ima43,sr.ima67       #FUN-CB0004 add sr.ima021
         FROM ima_file WHERE ima01=l_mps01
       IF STATUS <> 0 THEN CONTINUE FOREACH END IF
       CASE WHEN tm.order = '1' 
                 LET ss.order1=sr.ima23
            WHEN tm.order = '2' 
                 LET ss.order1=sr.ima67
            WHEN tm.order = '3' 
                 LET ss.order1=sr.ima43
            WHEN tm.order = '4'          #FUN-D40117
                 LET ss.order1=sr.ima01  #FUN-D40117
            OTHERWISE
                 LET ss.order1=' '    
                
       END CASE
       LET ss.ima01  =sr.ima01   
       LET ss.ima02  =sr.ima02  
       LET ss.ima021 =sr.ima021             #FUN-CB0004 add 
       LET ss.ima08  =sr.ima08   
       LET ss.ima23  =sr.ima23   
       LET ss.ima25  =sr.ima25   
       LET ss.ima43  =sr.ima43   
       LET ss.ima67  =sr.ima67   
       LET ss.inline =sr.mps051+sr.mps053   #庫存量+在驗量
       LET ss.iqc    =sr.mps052             #在驗量
                      #請購量+  在採量+   在外量+   在製量
       LET ss.order  =sr.mps061+sr.mps062+sr.mps063+sr.mps064 
       LET ss.plan   =sr.mps065  #計劃產
       IF ss.inline >= l_demand THEN
          LET ss.inline=ss.inline-l_demand
       ELSE
          IF ss.inline+ss.iqc >= l_demand THEN
             LET ss.inline=0
             LET ss.iqc   =ss.inline+ss.iqc-l_demand
          ELSE
             IF ss.inline+ss.iqc+ss.order >= l_demand THEN
                LET ss.inline=0
                LET ss.iqc   =0
                LET ss.order =ss.inline+ss.iqc+ss.order-l_demand
             ELSE
                LET ss.inline=0
                LET ss.iqc   =0
                LET ss.order =0
                LET ss.plan  =ss.inline+ss.iqc+ss.order+ss.plan-l_demand
             END IF
          END IF
       END IF
         # add by TSD.Martin 
         # 不允許有負值的存在
         IF ss.inline < 0 THEN LET ss.inline = ss.inline *-1 END IF 
         IF ss.iqc < 0 THEN LET ss.iqc = ss.iqc *-1 END IF 
         IF ss.order < 0 THEN LET ss.order = ss.order *-1 END IF 
         IF ss.plan < 0 THEN LET ss.plan = ss.plan *-1 END IF 
         # end  by TSD.Martin 
         ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-740078 *** ##
        #FUN-CB0004--add--str---
         SELECT gen02 INTO l_gen02_1 FROM gen_file WHERE gen01 = ss.ima23
         SELECT gen02 INTO l_gen02_2 FROM gen_file WHERE gen01 = ss.ima67
        #FUN-CB0004--add--end---
         LET l_total = ss.inline + ss.iqc + ss.order + ss.plan      #FUN-CB0004 add
         EXECUTE insert_prep USING 
         ss.order1,ss.ima01,ss.ima02,ss.ima08, ss.ima23,
         ss.ima25, ss.ima43,ss.ima67,ss.inline,ss.iqc,
         ss.order, ss.plan,l_total,l_mps01,                               #FUN-CB0004 add l_total,l_mps01
         ss.ima021,l_gen02_1,l_gen02_2                           #FUN-CB0004 add
       #------------------------------ CR (3) ------------------------------#
 
     END FOREACH
   #str FUN-740078 add 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-740078 **** ##
###XtraGrid###   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-740078 modify
   #是否列印選擇條件
    LET g_xgrid.table = l_table    ###XtraGrid###
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'mps01,ima08,ima67,ima43,ima23')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
###XtraGrid###   LET g_str = g_str,";",tm.order
###XtraGrid###   CALL cl_prt_cs3('amsx800','amsx800',l_sql,g_str)   
   #FUN-CB0004--add--str---
    CASE tm.order
       WHEN '1'
          LET g_xgrid.order_field = "ima23"
          LET g_xgrid.grup_field = "ima23"
          LET g_xgrid.skippage_field = "ima23"
          LET l_str = cl_wcchp(g_xgrid.order_field,"ima23")
         #LET g_xgrid.footerinfo1 = l_str,':  ',ss.order1  #FUN-D40117
       WHEN '2'
          LET g_xgrid.order_field = "ima67"
          LET g_xgrid.grup_field = "ima67"
          LET g_xgrid.skippage_field = "ima67"
          LET l_str = cl_wcchp(g_xgrid.order_field,"ima67")
         #LET g_xgrid.footerinfo1 = l_str,':  ',ss.order1 ##FUN-D40117
       WHEN '3'
          LET g_xgrid.order_field = "ima43"
          LET g_xgrid.grup_field = "ima43"
          LET g_xgrid.skippage_field = "ima43"
          LET l_str = cl_wcchp(g_xgrid.order_field,"ima43")
         #LET g_xgrid.footerinfo1 = l_str,':  ',ss.order1 #FUN-D40117 
       WHEN '4'
         #FUN-D40117--add--str--
         #LET g_xgrid.order_field = null
         #LET g_xgrid.grup_field = null
         #LET l_str = ' '
         #LET g_xgrid.footerinfo1 = l_str
          LET g_xgrid.order_field = 'ima01'
          LET g_xgrid.grup_field = 'ima01'
          LET g_xgrid.skippage_field = "ima01"
          LET l_str = cl_wcchp(g_xgrid.order_field,"ima01") 
         #LET g_xgrid.footerinfo1 = l_str,':  ',ss.order1 #FUN-D40117 
         #FUN-D40117--add--end--
    END CASE
    
    LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc
   #FUN-CB0004--add--end---
    CALL cl_xg_view()    ###XtraGrid###
   #------------------------------ CR (4) ------------------------------#
   #end FUN-740078 add 
END FUNCTION
 
REPORT amsx800_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1    #NO.FUN-680101 VARCHAR(1) 
   DEFINE fno          LIKE cre_file.cre08    #NO.FUN-680101 VARCHAR(10)
   DEFINE st  RECORD 
              inline LIKE mps_file.mps051, #NO.FUN-680101 DEC(12,3)
              iqc    LIKE mps_file.mps052, #NO.FUN-680101 DEC(12,3)
              order  LIKE mps_file.mps061, #NO.FUN-680101 DEC(12,3)
              plan   LIKE mps_file.mps065  #NO.FUN-680101 DEC(12,3) 
              END RECORD
   DEFINE sr  RECORD 
              order1 LIKE ima_file.ima23,
              ima01  LIKE ima_file.ima01,   
              ima02  LIKE ima_file.ima02,   
              ima08  LIKE ima_file.ima08,   
              ima23  LIKE ima_file.ima23,   
              ima25  LIKE ima_file.ima25,   
              ima43  LIKE ima_file.ima43,   
              ima67  LIKE ima_file.ima67,   
              inline LIKE mps_file.mps051, #NO.FUN-680101 DEC(12,3)
              iqc    LIKE mps_file.mps052, #NO.FUN-680101 DEC(12,3)
              order  LIKE mps_file.mps061, #NO.FUN-680101 DEC(12,3)
              plan   LIKE mps_file.mps065  #NO.FUN-680101 DEC(12,3) 
              END RECORD
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.ima01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED   #No.TQC-6A0080
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED        #No.TQC-6A0080
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      IF tm.order='1' THEN
         LET g_head1= g_x[8] CLIPPED,sr.order1
         PRINT g_head1
      ELSE
         IF tm.order='2' THEN
            LET g_head1= g_x[9] CLIPPED,sr.order1
            PRINT g_head1
         ELSE
            IF tm.order='3' THEN
               LET g_head1= g_x[10] CLIPPED,sr.order1
               PRINT g_head1
            ELSE
               PRINT ' '
            END IF
         END IF
      END IF
 
      PRINT g_dash[1,g_len] CLIPPED
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
            g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.order MATCHES '[123]' THEN
         SKIP TO TOP OF PAGE
      END IF
   AFTER GROUP OF sr.order1
      IF tm.order MATCHES '[123]' THEN
         LET st.inline=GROUP SUM(sr.inline)
         LET st.iqc   =GROUP SUM(sr.iqc)
         LET st.order =GROUP SUM(sr.order)
         LET st.plan  =GROUP SUM(sr.plan)
         PRINT g_dash2[1,g_len] CLIPPED
         PRINT COLUMN g_c[31],g_x[11] CLIPPED,
               COLUMN g_c[35],st.inline USING '#,###,##&.&&',
               COLUMN g_c[36], st.iqc    USING '#,###,##&.&&',
               COLUMN g_c[37],st.order  USING '#,###,##&.&&',
               COLUMN g_c[38],st.plan   USING '#,###,##&.&&',
               COLUMN g_c[39],st.inline+st.iqc+st.order+st.plan USING '#,###,##&.&&'
      END IF
 
   ON EVERY ROW
      PRINT COLUMN g_c[31],sr.ima01[1,12],
            COLUMN g_c[32],sr.ima02,
            COLUMN g_c[33],sr.ima08,
            COLUMN g_c[34],sr.ima25,
            COLUMN g_c[35],sr.inline USING '#,###,##&.&&',
            COLUMN g_c[36],sr.iqc    USING '#,###,##&.&&',
            COLUMN g_c[37],sr.order  USING '#,###,##&.&&',
            COLUMN g_c[38],sr.plan   USING '#,###,##&.&&',
            COLUMN g_c[39],sr.inline+sr.iqc+sr.order+sr.plan USING '#,###,##&.&&',
            COLUMN g_c[40],sr.ima23,
            COLUMN g_c[41],sr.ima67
 
   ON LAST ROW
      LET l_last_sw = 'y'
      PRINT g_dash[1,g_len] CLIPPED #No.TQC-5C0005
      IF tm.order = '4' THEN
         LET st.inline=SUM(sr.inline)
         LET st.iqc   =SUM(sr.iqc)
         LET st.order =SUM(sr.order)
         LET st.plan  =SUM(sr.plan)
         PRINT COLUMN g_c[31],g_x[11] CLIPPED,
               COLUMN g_c[35],st.inline USING '#,###,##&.&&',
               COLUMN g_c[36],st.iqc    USING '#,###,##&.&&',
               COLUMN g_c[37],st.order  USING '#,###,##&.&&',
               COLUMN g_c[38],st.plan   USING '#,###,##&.&&',
               COLUMN g_c[39], st.inline+st.iqc+st.order+st.plan USING '#,###,##&.&&'
         PRINT g_dash2[1,g_len] CLIPPED
      END IF
      #PRINT '(amsx800)' #No.TQC-5C0005
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED #No.TQC-5C0005
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len] CLIPPED
              #PRINT '(amsx800)' #No.TQC-5C0005
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #No.TQC-5C0005
         ELSE SKIP 2 LINE
      END IF
END REPORT


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
