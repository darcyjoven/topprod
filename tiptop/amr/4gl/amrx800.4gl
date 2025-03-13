# Prog. Version..: '5.30.07-13.05.30(00002)'     #
#
# Pattern name...: amrx800.4gl
# Descriptions...: MRP Slow Moving Report
# Input parameter: 
# Return code....: 
# Date & Author..: 98/06/29 By Eric
# Modify.........: No.FUN-510046 05/01/28 By pengu  報表轉XML
# Modify.........: No.FUN-570240 05/07/22 By vivien 料件編號欄位增加controlp
# Modify.........: No.TQC-610074 06/01/24 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.MOD-620083 06/02/27 By Claire 邏輯錯誤
# Modify.........: No.MOD-640019 06/04/10 By Claire ON EVERY ROW 應使用 sr.* 非 s
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-690116 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.TQC-6A0080 06/11/17 By xumin 報表表頭調整
# Modify.........: NO.MOD-720041 07/02/08 By TSD.GILL 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/29 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.TQC-790177 07/09/29 By Carrier 去掉全型字符
# Modify.........: No.TQC-970294 09/07/30 By destiny 建立cr 的資料表時，使用了plan 這是msv的保留字                                  
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-CB0004 12/11/02 By dongsz CR轉XtraGrid
# Modify.........: No.FUN-D40129 13/05/06 By yangtt 1、ima08欄位新增開窗   2、添加料件編號(mss01)排序
#                                                   3、添加【採購員名稱】欄位  4、去除分組、跳頁以及頁脚顯示


DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc      LIKE type_file.chr1000,# Where condition      #NO.FUN-680082 VARCHAR(600) 
              ver_no  LIKE mss_file.mss_v,   #NO.FUN-680082 VARCHAR(2)
              edate   LIKE type_file.dat,    #NO.FUN-680082 DATE
              l_sw    LIKE type_file.chr1,   #NO.FUN-680082 VARCHAR(01)
              maxQty  LIKE type_file.num10,  #NO.FUN-680082 DEC(08,0)
              order   LIKE type_file.chr1,   #NO.FUN-680082 VARCHAR(1)
              more    LIKE type_file.chr1    #NO.FUN-680082 VARCHAR(1) # Input more condition(Y/N)
              END RECORD
 
DEFINE   g_i          LIKE type_file.num5    #count/index for any purpose   #NO.FUN-680082 SMALLINT
DEFINE   g_head1      STRING
 
#NO:PKGCR-AMR01 07/02/08 BY TSD.GILL --START
DEFINE l_table     STRING  
DEFINE g_sql       STRING   
DEFINE g_str       STRING   
#NO:PKGCR-AMR01 07/02/08 BY TSD.GILL --END
 
 
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
   
   #NO.MOD-720041 07/02/08 BY TSD.GILL --START
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql ="order1.ima_file.ima23,",   #倉、計、採員(取決排序項目)
              "ima01.ima_file.ima01,",    #料件
              "ima02.ima_file.ima02,",    #品名
              "ima08.ima_file.ima08,",    #來源碼
              "ima25.ima_file.ima25,",    #單位
              "inline.mss_file.mss051,",  #In Line(庫存)
              "iqc.mss_file.mss052,",     #Iqc(在驗)
              "order2.mss_file.mss064,",  #Order(在製)
#             "plan.mss_file.mss065,",    #Plan(計劃產)                      #No.TQC-970294                                         
              "l_plan.mss_file.mss065,",    #Plan(計劃產)                    #No.TQC-970294
              "total.mss_file.mss065,",   #Subtotal(inline+iqc+order+plan)  
              "ima23.ima_file.ima23,",    #倉管員
              "ima67.ima_file.ima67,",      #計劃員
              "ima43.ima_file.ima43,",      #採購員       #FUN-CB0004 add
              "mss01.mss_file.mss01,",                      #FUN-CB0004 add
              "ima021.ima_file.ima021,",        #FUN-CB0004 add
              "gen02_1.gen_file.gen02,",        #FUN-CB0004 add
              "gen02_2.gen_file.gen02,",        #FUN-CB0004 add
              "gen02_3.gen_file.gen02"          #FUN-D40129 add
 
   LET l_table = cl_prt_temptable('amrx800',g_sql) CLIPPED   # 產生Temp Table 
   IF l_table = -1 THEN 
      EXIT PROGRAM 
   END IF        
   # Temp Table產生   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED, 
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"    #FUN-CB0004 add 5?     #FUN-D40129 add 1?
   PREPARE insert_prep FROM g_sql   
   IF STATUS THEN     
      CALL cl_err('insert_prep:',status,1) 
      EXIT PROGRAM   
   END IF
   #NO.MOD-720041 07/02/08 BY TSD.GILL --END
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #TQC-610074-begin
   LET tm.ver_no  = ARG_VAL(8)
   LET tm.edate   = ARG_VAL(9)
   LET tm.l_sw    = ARG_VAL(10)
   LET tm.maxqty  = ARG_VAL(11)
   LET tm.order   = ARG_VAL(12)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(8)
   #LET g_rep_clas = ARG_VAL(9)
   #LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   ##No.FUN-570264 ---end---
   #TQC-610074-end
   IF cl_null(g_bgjob) OR g_bgjob='N'        # If background job sw is off
      THEN CALL amrx800_tm(0,0)        # Input print condition
      ELSE CALL amrx800()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION amrx800_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,  #NO.FUN-680082 SMALLINT
          l_msr RECORD   LIKE msr_file.*,
          l_cmd          LIKE type_file.chr1000#NO.FUN-680082 VARCHAR(10) 
 
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col =14
   ELSE LET p_row = 3 LET p_col = 15
   END IF
   OPEN WINDOW amrx800_w AT p_row,p_col
        WITH FORM "amr/42f/amrx800" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET tm.order = '1'
   LET tm.maxqty = 0
   LET tm.edate = g_today 
   LET tm.l_sw = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON mss01,ima67,ima23,ima08,ima43 
 
#No.FUN-570240 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION controlp       
         CASE                       #FUN-CB0004 add
        #IF INFIELD(mss01) THEN             #FUN-CB0004 mark                                                                                     
         WHEN INFIELD(mss01)         #FUN-CB0004 add
            CALL cl_init_qry_var()                                                                                               
            LET g_qryparam.form = "q_ima"                                                                                       
            LET g_qryparam.state = "c"                                                                                           
            CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
            DISPLAY g_qryparam.multiret TO mss01                                                                                 
            NEXT FIELD mss01          
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
         #FUN-D40129---add---str--
         WHEN INFIELD(ima08)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima7"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima08
            NEXT FIELD ima08
         #FUN-D40129---add---end--
         END CASE
        #FUN-CB0004--add--end---                                                                                           
        #END IF                 #FUN-CB0004 mark                                                    
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
      LET INT_FLAG = 0 CLOSE WINDOW amrx800_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
   INPUT BY NAME tm.ver_no, tm.edate, tm.maxqty,tm.l_sw,tm.order,tm.more 
                 WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD ver_no
         IF cl_null(tm.ver_no) THEN NEXT FIELD ver_no END IF
         SELECT * INTO l_msr.* FROM msr_file WHERE msr_v=tm.ver_no
         IF STATUS <> 0 THEN
            ERROR 'MRP Version not found!'
            LET tm.ver_no=' '
            NEXT FIELD ver_no
         END IF
         LET tm.edate=l_msr.edate
 
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
            LET tm.edate=l_msr.edate
            NEXT FIELD edate
         END IF
         IF tm.edate > l_msr.edate THEN
            LET tm.edate=l_msr.edate
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
      LET INT_FLAG = 0 CLOSE WINDOW amrx800_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='amrx800'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amrx800','9031',1)
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
                         #TQC-610074-begin
                         " '",tm.ver_no CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",tm.l_sw CLIPPED,"'",
                         " '",tm.maxqty CLIPPED,"'",
                         " '",tm.order CLIPPED,"'",
                         #TQC-610074-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('amrx800',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW amrx800_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL amrx800()
   ERROR ""
END WHILE
   CLOSE WINDOW amrx800_w
END FUNCTION
 
#NO:PKGCR-AMR01 07/02/08 BY TSD.GILL --START
#原本的程式碼，全部mark起來，改用Crystal Report寫法
{
FUNCTION amrx800()
   DEFINE l_name    LIKE type_file.chr20,   # External(Disk) file name     #NO.FUN-680082 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0076
          l_sql     LIKE type_file.chr1000, # RDSQL STATEMENT              #NO.FUN-680082 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,    #NO.FUN-680082 VARCHAR(1)
          l_n       LIKE type_file.num5,    #NO.FUN-680082 SMALLINT
          l_za05    LIKE type_file.chr1000, #NO.FUN-680082 VARCHAR(40)
          l_supply,l_demand   LIKE mss_file.mss051,   #NO.FUN-680082 DEC(12,3)
          l_mss01   LIKE mss_file.mss01,
          ss  RECORD 
              order1 LIKE ima_file.ima23,
              ima01  LIKE ima_file.ima01,   
              ima02  LIKE ima_file.ima02,   
              ima08  LIKE ima_file.ima08,   
              ima23  LIKE ima_file.ima23,   
              ima25  LIKE ima_file.ima25,   
              ima43  LIKE ima_file.ima43,   
              ima67  LIKE ima_file.ima67,   
              inline LIKE mss_file.mss051,
              iqc    LIKE mss_file.mss052,
              order  LIKE mss_file.mss064,
              plan   LIKE mss_file.mss065 
              END RECORD,
          sr  RECORD 
              order1 LIKE ima_file.ima23,
              ima01  LIKE ima_file.ima01,   
              ima02  LIKE ima_file.ima02,   
              ima08  LIKE ima_file.ima08,   
              ima23  LIKE ima_file.ima23,   
              ima25  LIKE ima_file.ima25,   
              ima43  LIKE ima_file.ima43,   
              ima67  LIKE ima_file.ima67,   
              mss051 LIKE mss_file.mss051,   
              mss052 LIKE mss_file.mss052,   
              mss053 LIKE mss_file.mss053,   
              mss061 LIKE mss_file.mss061,   
              mss062 LIKE mss_file.mss062,   
              mss063 LIKE mss_file.mss063,   
              mss064 LIKE mss_file.mss064,   
              mss065 LIKE mss_file.mss065   
              END RECORD
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = "SELECT UNIQUE mss01",
                 "  FROM mss_file, ima_file",
                 " WHERE ",tm.wc CLIPPED,
                 "   AND mss01=ima01 ",
                 "   AND mss_v='",tm.ver_no,"'",
                 "   AND mss03 <='",tm.edate,"'"
 
     CALL cl_outnam('amrx800') RETURNING l_name
     START REPORT amrx800_rep TO l_name
     LET g_pageno = 0
     PREPARE amrx800_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
        EXIT PROGRAM 
     END IF
     DECLARE amrx800_curs1 CURSOR FOR amrx800_prepare1
     FOREACH amrx800_curs1 INTO l_mss01
       IF STATUS THEN CALL cl_err('foreach1:',STATUS,1) EXIT FOREACH END IF
       LET sr.mss051=0
       LET sr.mss052=0
       LET sr.mss053=0
       LET sr.mss061=0
       LET sr.mss062=0
       LET sr.mss063=0
       LET sr.mss064=0
       LET sr.mss065=0
       LET l_demand=0
       SELECT SUM(mss051),SUM(mss052),SUM(mss053),SUM(mss061),SUM(mss062),
              SUM(mss063),SUM(mss064),SUM(mss065),SUM(mss041+mss043+mss044) 
         INTO sr.mss051,sr.mss052,sr.mss053,sr.mss061,sr.mss062,
              sr.mss063,sr.mss064,sr.mss065,l_demand FROM mss_file
        WHERE mss_v=tm.ver_no AND mss01=l_mss01 AND mss03 <= tm.edate
       IF sr.mss051 IS NULL THEN LET sr.mss051=0 END IF 
       IF sr.mss052 IS NULL THEN LET sr.mss052=0 END IF 
       IF sr.mss053 IS NULL THEN LET sr.mss053=0 END IF 
       IF sr.mss061 IS NULL THEN LET sr.mss061=0 END IF 
       IF sr.mss062 IS NULL THEN LET sr.mss062=0 END IF 
       IF sr.mss063 IS NULL THEN LET sr.mss063=0 END IF 
       IF sr.mss064 IS NULL THEN LET sr.mss064=0 END IF 
       IF sr.mss065 IS NULL THEN LET sr.mss065=0 END IF 
       IF l_demand IS NULL THEN LET l_demand=0 END IF
       LET l_supply= sr.mss051+sr.mss052+sr.mss053+sr.mss061+sr.mss062+
                     sr.mss063+sr.mss064+sr.mss065 
       IF l_supply < l_demand THEN
          CONTINUE FOREACH
       END IF
       IF l_supply < tm.maxqty THEN
          CONTINUE FOREACH
       END IF
       IF tm.l_sw='Y' AND l_demand <> 0 THEN
          CONTINUE FOREACH
       END IF
       SELECT ima01,ima02,ima08,ima23,ima25,ima43,ima67 
         INTO sr.ima01,sr.ima02,sr.ima08,sr.ima23,sr.ima25,sr.ima43,sr.ima67 
         FROM ima_file WHERE ima01=l_mss01
       IF STATUS <> 0 THEN CONTINUE FOREACH END IF
       CASE WHEN tm.order = '1' 
                 LET ss.order1=sr.ima23
            WHEN tm.order = '2' 
                 LET ss.order1=sr.ima67
            WHEN tm.order = '3' 
                 LET ss.order1=sr.ima43
            OTHERWISE
                 LET ss.order1=' '
       END CASE
       LET ss.ima01  =sr.ima01   
       LET ss.ima02  =sr.ima02   
       LET ss.ima08  =sr.ima08   
       LET ss.ima23  =sr.ima23   
       LET ss.ima25  =sr.ima25   
       LET ss.ima43  =sr.ima43   
       LET ss.ima67  =sr.ima67   
       LET ss.inline =sr.mss051+sr.mss053   #庫存量+在驗量
       LET ss.iqc    =sr.mss052             #在驗量
                      #請購量+  在採量+   在外量+   在製量
       LET ss.order  =sr.mss061+sr.mss062+sr.mss063+sr.mss064 
       LET ss.plan   =sr.mss065  #計劃產
       IF ss.inline >= l_demand THEN
          LET ss.inline=ss.inline-l_demand
       ELSE
          IF ss.inline+ss.iqc >= l_demand THEN
             LET ss.iqc   =ss.inline+ss.iqc-l_demand  #MOD-620083
             LET ss.inline=0                        
            #LET ss.iqc   =ss.inline+ss.iqc-l_demand  #MOD-620083
          ELSE
             IF ss.inline+ss.iqc+ss.order >= l_demand THEN
                LET ss.order =ss.inline+ss.iqc+ss.order-l_demand #MOD-620083
                LET ss.inline=0
                LET ss.iqc   =0
               #LET ss.order =ss.inline+ss.iqc+ss.order-l_demand #MOD-620083
             ELSE
                LET ss.plan  =ss.inline+ss.iqc+ss.order+ss.plan-l_demand #MOD-620083
                LET ss.inline=0
                LET ss.iqc   =0
                LET ss.order =0
               #LET ss.plan  =ss.inline+ss.iqc+ss.order+ss.plan-l_demand #MOD-620083
             END IF
          END IF
       END IF
       OUTPUT TO REPORT amrx800_rep(ss.*)
     END FOREACH
     FINISH REPORT amrx800_rep
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT amrx800_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1    #NO.FUN-680082 VARCHAR(1)
   define fno          LIKE type_file.chr20   #NO.FUN-680082 VARCHAR(10)
   DEFINE st  RECORD 
              inline LIKE mss_file.mss051,
              iqc    LIKE mss_file.mss052,
              order  LIKE mss_file.mss064,
              plan   LIKE mss_file.mss065 
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
              inline LIKE mss_file.mss051, 
              iqc    LIKE mss_file.mss052, 
              order  LIKE mss_file.mss064, 
              plan   LIKE mss_file.mss065  
              END RECORD
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.ima01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED  #TQC-6A0080
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED  #TQC-6A0080
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
         PRINT COLUMN g_c[31],g_x[15] CLIPPED,
               COLUMN g_c[35],cl_numfor(st.inline,35,2),
               COLUMN g_c[36],cl_numfor(st.iqc,36,2),   
               COLUMN g_c[37],cl_numfor(st.order,37,2), 
               COLUMN g_c[38],cl_numfor(st.plan,38,2),  
               COLUMN g_c[39],cl_numfor(st.inline+st.iqc+st.order+st.plan,39,2) 
      END IF
 
   ON EVERY ROW
      PRINT COLUMN g_c[31],sr.ima01[1,12],
            COLUMN g_c[32],sr.ima02,
            COLUMN g_c[33],sr.ima08,
            COLUMN g_c[34],sr.ima25,
            COLUMN g_c[35],cl_numfor(sr.inline,35,2),  #MOD-640019 st->sr
            COLUMN g_c[36],cl_numfor(sr.iqc,36,2),     #MOD-640019 st->sr
            COLUMN g_c[37],cl_numfor(sr.order,37,2),   #MOD-640019 st->sr
            COLUMN g_c[38],cl_numfor(sr.plan,38,2),    #MOD-640019 st->sr
            COLUMN g_c[39],cl_numfor(sr.inline+sr.iqc+sr.order+sr.plan,39,2), #MOD-640019 st->sr
            COLUMN g_c[40],sr.ima23,
            COLUMN g_c[41],sr.ima67
 
   ON LAST ROW
      LET l_last_sw = 'y'
      PRINT g_dash[1,g_len] CLIPPED
      IF tm.order = '4' THEN
         LET st.inline=SUM(sr.inline)
         LET st.iqc   =SUM(sr.iqc)
         LET st.order =SUM(sr.order)
         LET st.plan  =SUM(sr.plan)
         PRINT COLUMN g_c[31],g_x[15] CLIPPED,
            COLUMN g_c[35],cl_numfor(st.inline,35,2),
            COLUMN g_c[36],cl_numfor(st.iqc,36,2),   
            COLUMN g_c[37],cl_numfor(st.order,37,2), 
            COLUMN g_c[38],cl_numfor(st.plan,38,2),  
            COLUMN g_c[39],cl_numfor(st.inline+st.iqc+st.order+st.plan,39,2) 
         PRINT g_dash[1,g_len] CLIPPED
      END IF
      PRINT g_x[4] CLIPPED,COLUMN (g_len-9),g_x[7]
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len] CLIPPED
              PRINT g_x[4] CLIPPED,COLUMN (g_len-9),g_x[6]
         ELSE SKIP 2 LINE
      END IF
END REPORT
}
 
FUNCTION amrx800()
   DEFINE l_name    LIKE type_file.chr20,   # External(Disk) file name     #NO.FUN-680082 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0076
          l_sql     LIKE type_file.chr1000, # RDSQL STATEMENT              #NO.FUN-680082 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,    #NO.FUN-680082 VARCHAR(1)
          l_n       LIKE type_file.num5,    #NO.FUN-680082 SMALLINT
          l_za05    LIKE type_file.chr1000, #NO.FUN-680082 VARCHAR(40)
          l_supply,l_demand   LIKE mss_file.mss051,   #NO.FUN-680082 DEC(12,3)
          l_mss01   LIKE mss_file.mss01,
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
              inline LIKE mss_file.mss051,
              iqc    LIKE mss_file.mss052,
              order2 LIKE mss_file.mss064,
              plan   LIKE mss_file.mss065 
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
              mss051 LIKE mss_file.mss051,   
              mss052 LIKE mss_file.mss052,   
              mss053 LIKE mss_file.mss053,   
              mss061 LIKE mss_file.mss061,   
              mss062 LIKE mss_file.mss062,   
              mss063 LIKE mss_file.mss063,   
              mss064 LIKE mss_file.mss064,   
              mss065 LIKE mss_file.mss065   
              END RECORD
   DEFINE l_total LIKE mss_file.mss065
   DEFINE l_str   STRING                   #FUN-CB0004 add
   DEFINE l_gen02_1  LIKE gen_file.gen02   #FUN-CB0004 add
   DEFINE l_gen02_2  LIKE gen_file.gen02   #FUN-CB0004 add
   DEFINE l_gen02_3  LIKE gen_file.gen02   #FUN-D40129 add
 
   #NO.MOD-720041 07/02/08 BY TSD.GILL --START
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> MOD-720041 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
   #NO.MOD-720041 07/02/08 BY TSD.GILL --END
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang   
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
 
   LET l_sql = "SELECT UNIQUE mss01",
               "  FROM mss_file, ima_file",
               " WHERE ",tm.wc CLIPPED,
               "   AND mss01=ima01 ",
               "   AND mss_v='",tm.ver_no,"'",
               "   AND mss03 <='",tm.edate,"'"
   PREPARE amrx800_prepare1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM 
   END IF
   DECLARE amrx800_curs1 CURSOR FOR amrx800_prepare1
 
   FOREACH amrx800_curs1 INTO l_mss01
      IF STATUS THEN CALL cl_err('foreach1:',STATUS,1) EXIT FOREACH END IF
      LET sr.mss051=0
      LET sr.mss052=0
      LET sr.mss053=0
      LET sr.mss061=0
      LET sr.mss062=0
      LET sr.mss063=0
      LET sr.mss064=0
      LET sr.mss065=0
      LET l_demand=0
      SELECT SUM(mss051),SUM(mss052),SUM(mss053),SUM(mss061),SUM(mss062),
             SUM(mss063),SUM(mss064),SUM(mss065),SUM(mss041+mss043+mss044) 
        INTO sr.mss051,sr.mss052,sr.mss053,sr.mss061,sr.mss062,
             sr.mss063,sr.mss064,sr.mss065,l_demand FROM mss_file
       WHERE mss_v=tm.ver_no AND mss01=l_mss01 AND mss03 <= tm.edate
      IF sr.mss051 IS NULL THEN LET sr.mss051=0 END IF 
      IF sr.mss052 IS NULL THEN LET sr.mss052=0 END IF 
      IF sr.mss053 IS NULL THEN LET sr.mss053=0 END IF 
      IF sr.mss061 IS NULL THEN LET sr.mss061=0 END IF 
      IF sr.mss062 IS NULL THEN LET sr.mss062=0 END IF 
      IF sr.mss063 IS NULL THEN LET sr.mss063=0 END IF 
      IF sr.mss064 IS NULL THEN LET sr.mss064=0 END IF 
      IF sr.mss065 IS NULL THEN LET sr.mss065=0 END IF 
      IF l_demand IS NULL THEN LET l_demand=0 END IF
      LET l_supply= sr.mss051+sr.mss052+sr.mss053+sr.mss061+sr.mss062+
                    sr.mss063+sr.mss064+sr.mss065 
      IF l_supply < l_demand THEN
         CONTINUE FOREACH
      END IF
      IF l_supply < tm.maxqty THEN
         CONTINUE FOREACH
      END IF
      IF tm.l_sw='Y' AND l_demand <> 0 THEN
         CONTINUE FOREACH
      END IF
      SELECT ima01,ima02,ima08,ima23,ima25,ima43,ima67,ima021                 #FUN-CB0004 add ima021 
        INTO sr.ima01,sr.ima02,sr.ima08,sr.ima23,sr.ima25,sr.ima43,sr.ima67,sr.ima021   #FUN-CB0004 add sr.ima021 
        FROM ima_file WHERE ima01=l_mss01
      IF STATUS <> 0 THEN CONTINUE FOREACH END IF
      CASE WHEN tm.order = '1' 
                LET ss.order1=sr.ima23
           WHEN tm.order = '2' 
                LET ss.order1=sr.ima67
           WHEN tm.order = '3' 
                LET ss.order1=sr.ima43
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
      LET ss.inline =sr.mss051+sr.mss053   #庫存量+在驗量
      LET ss.iqc    =sr.mss052             #在驗量
                     #請購量+  在採量+   在外量+   在製量
      LET ss.order2  =sr.mss061+sr.mss062+sr.mss063+sr.mss064 
      LET ss.plan   =sr.mss065  #計劃產
      IF ss.inline >= l_demand THEN
         LET ss.inline=ss.inline-l_demand
      ELSE
         IF ss.inline+ss.iqc >= l_demand THEN
            LET ss.iqc   =ss.inline+ss.iqc-l_demand  #MOD-620083
            LET ss.inline=0                        
           #LET ss.iqc   =ss.inline+ss.iqc-l_demand  #MOD-620083
         ELSE
            IF ss.inline+ss.iqc+ss.order2 >= l_demand THEN
               LET ss.order2 =ss.inline+ss.iqc+ss.order2-l_demand #MOD-620083
               LET ss.inline=0
               LET ss.iqc   =0
              #LET ss.order =ss.inline+ss.iqc+ss.order-l_demand #MOD-620083
            ELSE
               LET ss.plan  =ss.inline+ss.iqc+ss.order2+ss.plan-l_demand #MOD-620083
               LET ss.inline=0
               LET ss.iqc   =0
               LET ss.order2 =0
              #LET ss.plan  =ss.inline+ss.iqc+ss.order+ss.plan-l_demand #MOD-620083
            END IF
         END IF
      END IF
     #FUN-CB0004--add--str---
      SELECT gen02 INTO l_gen02_1 FROM gen_file WHERE gen01 = ss.ima23
      SELECT gen02 INTO l_gen02_2 FROM gen_file WHERE gen01 = ss.ima67
     #FUN-CB0004--add--end--- 
      SELECT gen02 INTO l_gen02_3 FROM gen_file WHERE gen01 = ss.ima43
      #NO.MOD-720041 07/02/08 BY TSD.GILL --START
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##   
      LET l_total = ss.inline + ss.iqc + ss.order2 + ss.plan
      EXECUTE insert_prep USING ss.order1,ss.ima01,ss.ima02,ss.ima08,
                                ss.ima25,ss.inline,ss.iqc,ss.order2,
                                ss.plan,l_total,ss.ima23,ss.ima67,ss.ima43,l_mss01,     #FUN-CB0004 add ss.ima43,l_mss01
                                ss.ima021,l_gen02_1,l_gen02_2                           #FUN-CB0004 add
                                ,l_gen02_3   #FUN-D40129
      IF SQLCA.SQLCODE THEN
         CALL cl_err('',SQLCA.SQLCODE,1)
      END IF        
      #NO.MOD-720041 07/02/08 BY TSD.GILL --END
   END FOREACH
     
   #NO.MOD-720041 07/02/08 BY TSD.GILL --START
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ## 
###XtraGrid###   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   #是否列印選擇條件   
    LET g_xgrid.table = l_table    ###XtraGrid###
   LET g_str =''
   IF g_zz05 = 'Y' THEN      
      CALL cl_wcchp(tm.wc,'mss01,ima08,ima67,ima43,ima23') RETURNING tm.wc      
      LET g_str = tm.wc   
   END IF 
   IF cl_null(g_str) THEN
      LET g_str=' ' 
   END IF
###XtraGrid###   LET g_str = g_str,";",tm.ver_no,";",tm.edate,";",tm.maxqty,";",tm.l_sw,";",tm.order   
###XtraGrid###   CALL cl_prt_cs3('amrx800','amrx800',l_sql,g_str)   #FUN-710080 modify
   #FUN-CB0004--add--str---
    CASE tm.order
       WHEN '1'
          LET g_xgrid.order_field = "ima23"
         #LET g_xgrid.grup_field = "ima23"   #FUN-D40129 mark
         #LET g_xgrid.skippage_field = "ima23"    #FUN-D40129 mark
         #LET l_str = cl_wcchp(g_xgrid.order_field,"ima23") #FUN-D40129 mark
         #LET g_xgrid.footerinfo1 = l_str,':  ',ss.order1  #FUN-D40129 mark
       WHEN '2'
          LET g_xgrid.order_field = "ima67"
         #LET g_xgrid.grup_field = "ima67"   #FUN-D40129 mark
         #LET g_xgrid.skippage_field = "ima67"   #FUN-D40129 mark
         #LET l_str = cl_wcchp(g_xgrid.order_field,"ima67") #FUN-D40129 mark
         #LET g_xgrid.footerinfo1 = l_str,':  ',ss.order1   #FUN-D40129 mark
       WHEN '3'
          LET g_xgrid.order_field = "ima43"
         #LET g_xgrid.grup_field = "ima43"   #FUN-D40129 mark
         #LET g_xgrid.skippage_field = "ima43"   #FUN-D40129 mark
         #LET l_str = cl_wcchp(g_xgrid.order_field,"ima43") #FUN-D40129 mark
         #LET g_xgrid.footerinfo1 = l_str,':  ',ss.order1   #FUN-D40129 mark
       WHEN '4'
         #LET g_xgrid.order_field = null        #FUN-D40129
         #LET g_xgrid.grup_field = null         #FUN-D40129
         #LET l_str = ' '                       #FUN-D40129
          LET g_xgrid.order_field = "ima01"     #FUN-D40129
         #LET g_xgrid.footerinfo1 = l_str       #FUN-D40129 mark
    END CASE
    LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc
   #FUN-CB0004--add--end---
    CALL cl_xg_view()    ###XtraGrid###
   #NO.MOD-720041 07/02/08 BY TSD.GILL --END
   
END FUNCTION
#TQC-790177


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
