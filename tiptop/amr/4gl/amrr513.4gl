# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: amrr513.4gl
# Descriptions...: MRP 模擬明細表
# Input parameter: 
# Return code....: 
# Date & Author..: 96/06/10 By Roger
# Modify.........: No.FUN-510046 05/01/25 By pengu 報表轉XML
# Modify.........: No.FUN-550055 05/05/24 By day   單據編號加大
# Modify.........: No.FUN-570240 05/07/22 By vivien 料件編號欄位增加controlp
# Modify.........: No.TQC-610074 06/01/24 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo 欄位類型定義-改為LIKE 
# Modify.........: No.FUN-690116 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.TQC-6A0080 06/11/20 By xumin 報表表頭居中
# Modify.........: No.TQC-740005 07/04/02 By pengu 其他供給量不應該包含"在外量"
# Modify.........: No.FUN-850041 08/05/13 By hellen 轉換成CR報表
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
# Modify.........: No.TQC-950124 09/05/20 By chenyu CR報表的臨時表在插入前沒有清空
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80023 11/08/03 By fengrui  程式撰寫規範修正
# Modify.........: No.TQC-D90020 13/09/23 By yangtt "計劃員""廠牌""來源碼""採購員""版本"增加開窗
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                              # Print condition RECORD      #NO.FUN-680082 VARCHAR(600)
              wc      LIKE type_file.chr1000,     # Where condition
              #n      VARCHAR(1),                    #TQC-610074
              ver_no  LIKE mss_file.mss_v,        #NO.FUN-680082 VARCHAR(2)
              edate   LIKE type_file.dat    ,     #NO.FUN-680082 DATE
              more    LIKE type_file.chr1         # Input more condition(Y/N)   #NO.FUN-680082 VARCHAR(1) 
              END RECORD
 
DEFINE   g_i          LIKE type_file.num5         #count/index for any purpose  #NO.FUN-680082 SMALLINT
#No.FUN-850041 add 080514 --begin
DEFINE   g_head1      STRING
DEFINE   g_sql        STRING
DEFINE   g_str        STRING
DEFINE   l_table      STRING
#No.FUN-850041 add 080514 --end
 
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
   
   #No.FUN-850041 add 080514 --begin
   LET g_sql = "mst08.mst_file.mst08,",                                                                                           
               "mst06.mst_file.mst06,",                                                                                             
               "mst061.mst_file.mst061,",                                                                                             
               "mst04.mst_file.mst04,",                                                                                             
               "l_vender.pmm_file.pmm09,",                                                                                             
               "l_pmc03.pmc_file.pmc03,",                                                                                             
               "l_gen02.gen_file.gen02,",                                                                                             
               "ima43.ima_file.ima43,",                                                                                             
               "mss01.mss_file.mss01,",                                                                                             
               "ima02.ima_file.ima02,",                                                                                             
               "ima25.ima_file.ima25,",                                                                                             
               "mss00.mss_file.mss00,",                                                                                             
               "mss03.mss_file.mss03,",                                                                                             
               "mss08.mss_file.mss08,",                                                                                             
               "mss09.mss_file.mss09,",                                                                                             
               "l_reqqty.mss_file.mss041,",
               "l_othqty.mss_file.mss041,",                                                                                             
               "l_cnt.type_file.num5,",
               "mss02.mss_file.mss02"                                                              
   LET l_table = cl_prt_temptable('amrr513',g_sql) CLIPPED
   IF l_table = -1 THEN
      EXIT PROGRAM 
   END IF
   #No.FUN-850041 add 080514 --end
 
   LET g_pdate = ARG_VAL(1)       # Get arguments from command line
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
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob='N'        # If background job sw is off
      THEN CALL amrr513_tm(0,0)        # Input print condition
      ELSE CALL amrr513()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION amrr513_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01      #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,     #NO.FUN-680082 SMALLINT
          l_cmd          LIKE type_file.chr1000   #NO.FUN-680082 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 13 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 12
   ELSE LET p_row = 4 LET p_col = 13
   END IF
 
   OPEN WINDOW amrr513_w AT p_row,p_col
        WITH FORM "amr/42f/amrr513" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   #LET tm.n    = '2'                 #TQC-610074
   LET tm.edate = g_today
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON mss01,ima08,ima67,ima43,mss02 
 
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
         #TQC-D90020--add--str--
         IF INFIELD(ima67) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_gen"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima67
            NEXT FIELD ima67
         END IF
         IF INFIELD(ima08) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima7"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima08
            NEXT FIELD ima08
         END IF
         IF INFIELD(ima43) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_gen"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima43
            NEXT FIELD ima43
         END IF
         IF INFIELD(mss02) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_pmc2"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO mss02
            NEXT FIELD mss02
         END IF
         #TQC-D90020--add--end
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
      LET INT_FLAG = 0 CLOSE WINDOW amrr513_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
 
   DISPLAY BY NAME tm.ver_no, tm.edate,tm.more 
 
   INPUT BY NAME tm.ver_no, tm.edate,tm.more WITHOUT DEFAULTS
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

      ON ACTION controlp 
         #TQC-D90020--add--str--
         IF INFIELD(ver_no) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_mss_v"
            LET g_qryparam.state = "i"
            CALL cl_create_qry() RETURNING tm.ver_no
            DISPLAY BY NAME tm.ver_no
            NEXT FIELD ver_no
         END IF
         #TQC-D90020--add--end--
 
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
      LET INT_FLAG = 0 CLOSE WINDOW amrr513_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='amrr513'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amrr513','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.ver_no CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('amrr513',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW amrr513_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL amrr513()
   ERROR ""
END WHILE
   CLOSE WINDOW amrr513_w
END FUNCTION
 
FUNCTION amrr513()
   DEFINE l_name    LIKE type_file.chr20,     # External(Disk) file name       #NO.FUN-680082 VARCHAR(20)                
#       l_time          LIKE type_file.chr8        #No.FUN-6A0076
          l_sql     LIKE type_file.chr1000,   # RDSQL STATEMENT                #NO.FUN-680082 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,      #NO.FUN-680082 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,   #NO.FUN-680082 VARCHAR(40)
          l_order   LIKE type_file.chr20,     #NO.FUN-680082 VARCHAR(20)
          l_bal,l_qty  LIKE mss_file.mss061,
          l_begin   LIKE type_file.chr1,      #NO.FUN-680082 VARCHAR(1)
          mss   RECORD LIKE mss_file.*,
          mss_o RECORD LIKE mss_file.*,
          mst   RECORD LIKE mst_file.*,
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
     #No.FUN-850041 add 080514 --begin
     DEFINE l_reqqty LIKE mss_file.mss041 
     DEFINE l_othqty LIKE mss_file.mss041 
     DEFINE l_cnt    LIKE type_file.num5
     DEFINE l_gen02  LIKE gen_file.gen02 
     DEFINE l_pono   LIKE pmm_file.pmm01 
     DEFINE l_prno   LIKE pmm_file.pmm01 
     DEFINE l_vender LIKE pmm_file.pmm09 
     DEFINE l_pmc03  LIKE pmc_file.pmc03 
     #No.FUN-850041 add 080514 --end
     
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog     #No.FUN-850041 080602 add
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #No.FUN-850041 add 080513 --begin
     CALL cl_del_data(l_table)    #No.TQC-950124 add
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
                 " VALUES(?,?,?,?,?,?,?,
                          ?,?,?,?,?,?,?,
                          ?,?,?,?,?) "                                                          
     PREPARE insert_prep FROM g_sql                                                                                                   
     IF STATUS THEN                                                                                                                   
        CALL cl_err('insert_prep:',STATUS,1)   
        CALL  cl_used(g_prog,g_time,2)  RETURNING g_time #No.FUN-B80023--add--
        EXIT PROGRAM                                                                             
     END IF
     #No.FUN-850041 add 080513 --end
          
     LET l_sql = "SELECT mss_file.*,ima02,ima08,ima25,ima43",
                 "  FROM mss_file, ima_file",
                 " WHERE ",tm.wc,
                 "   AND mss01=ima01 ",
                 "   AND mss_v='",tm.ver_no,"'",
                 "   AND mss03<='",tm.edate,"'",
                 "   ORDER BY mss01,mss02,mss03"
 
     PREPARE amrr513_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
        EXIT PROGRAM 
     END IF
     DECLARE amrr513_curs1 CURSOR FOR amrr513_prepare1
 
     LET l_sql = "SELECT *  FROM mst_file ",
                 " WHERE (mst05='61' OR mst05='62' OR mst05='63')",
                 "   AND mst_v = '",tm.ver_no,"'",
                 "   AND mst01=? AND mst02=? ",
                 "   AND mst03=? AND mst_v=? "
     PREPARE r513_premst  FROM l_sql
     IF STATUS THEN CALL cl_err('prepare2:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
        EXIT PROGRAM 
     END IF
     DECLARE r513_curmst CURSOR FOR r513_premst 
 
#    CALL cl_outnam('amrr513') RETURNING l_name
#    START REPORT amrr513_rep TO l_name
     LET g_pageno = 0 LET mss_o.mss01 = ' '
     FOREACH amrr513_curs1 INTO mss.*, ima.* 
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) 
          EXIT FOREACH
       END IF
       IF mss.mss01 != mss_o.mss01 THEN 
          LET l_begin = 'N' 
       END IF
       LET l_qty = mss.mss061 + mss.mss062 + mss.mss063
       LET l_bal = mss.mss08  + mss.mss09
 
       IF l_begin = 'N' THEN 
          IF l_qty <= 0 OR l_bal <=0
          THEN LET mss_o.* = mss.*
               LET ima_o.* = ima.*
               CONTINUE FOREACH
          ELSE 
             IF mss.mss01 = mss_o.mss01 THEN 
#No.FUN-850041 modify 080513 --begin
                #mark by hellen --begin
#               OUTPUT TO REPORT amrr513_rep(mss_o.*, ima_o.*)
                #mark by hellen --end
                
                #add by hellen --begin
                LET l_cnt = 0
                LET l_reqqty = mss_o.mss041 + mss_o.mss043 + mss_o.mss044
                LET l_othqty = mss_o.mss051 + mss_o.mss052 + mss_o.mss053 +
                               mss_o.mss064 + mss_o.mss065 + mss_o.mss09
                SELECT gen02 INTO l_gen02 
                  FROM gen_file 
                 WHERE gen01 = ima_o.ima43
                IF SQLCA.sqlcode THEN 
                   LET l_gen02 = ' ' 
                END IF
 
                #-->取請購/採購供給
                FOREACH r513_curmst  USING mss_o.mss01,mss_o.mss02,mss_o.mss03,mss_o.mss_v
                  INTO mst.*
                  LET l_cnt = l_cnt + 1
                  IF mst.mst05 = '62' OR mst.mst05 = '63' THEN
                     LET l_pono = mst.mst06
                     SELECT pmm09,pmc03 INTO l_vender,l_pmc03 
                       FROM pmm_file,pmc_file
                       WHERE pmm09 = pmc01 and pmm01 = l_pono AND pmm18 !='X'
                     IF SQLCA.sqlcode THEN 
                        LET l_vender = ' ' 
                        LET l_pmc03 = ' ' 
                     END IF
                  END IF
                  IF mst.mst05 ='61' THEN 
                     LET l_prno = mst.mst06
                     SELECT pmk09,pmc03 INTO l_vender,l_pmc03 
                       FROM pmk_file,pmc_file
                       WHERE pmk09 = pmc01 and pmk01 = l_prno
                     IF SQLCA.sqlcode THEN
                        LET l_vender = ' ' 
                        LET l_pmc03 = ' '
                     END IF
                  END IF
                  EXECUTE insert_prep USING mst.mst08,mst.mst06,mst.mst061,
                                            mst.mst04,l_vender,l_pmc03,
                                            l_gen02,ima_o.ima43,mss_o.mss01,
                                            ima_o.ima02,ima_o.ima25,mss_o.mss00,                                                                                             
                                            mss_o.mss03,mss_o.mss08,mss_o.mss09,                                                                                             
                                            l_reqqty,l_othqty,l_cnt,mss_o.mss02
                END FOREACH  
                IF l_cnt = 0 THEN
                   EXECUTE insert_prep USING '','','','','','',
                                             l_gen02,ima_o.ima43,mss_o.mss01,
                                             ima_o.ima02,ima_o.ima25,mss_o.mss00,                                                                                             
                                             mss_o.mss03,mss_o.mss08,mss_o.mss09,                                                                                             
                                             l_reqqty,l_othqty,l_cnt,mss_o.mss02
                END IF
                #add by hellen --end
#No.FUN-850041 modify 080513 --end                  
             END IF
             LET l_begin = 'Y' 
          END IF 
       END IF
#No.FUN-850041 modify 080513 --begin
       #mark by hellen --begin 
#      OUTPUT TO REPORT amrr513_rep(mss.*, ima.*)
       #mark by hellen --end
       
       #add by hellen --begin
       LET l_cnt = 0
       LET l_reqqty = mss.mss041 + mss.mss043 + mss.mss044
       LET l_othqty = mss.mss051 + mss.mss052 + mss.mss053 +
                      mss.mss064 + mss.mss065 + mss.mss09
       SELECT gen02 INTO l_gen02 
         FROM gen_file 
        WHERE gen01 = ima.ima43
       IF SQLCA.sqlcode THEN 
          LET l_gen02 = ' ' 
       END IF
 
       #-->取請購/採購供給
       FOREACH r513_curmst  USING mss.mss01,mss.mss02,mss.mss03,mss.mss_v
         INTO mst.*
         LET l_cnt = l_cnt + 1
         IF mst.mst05 = '62' OR mst.mst05 = '63' THEN
            LET l_pono = mst.mst06
            SELECT pmm09,pmc03 INTO l_vender,l_pmc03 
              FROM pmm_file,pmc_file
              WHERE pmm09 = pmc01 and pmm01 = l_pono AND pmm18 !='X'
            IF SQLCA.sqlcode THEN LET l_vender = ' ' LET l_pmc03 = ' ' END IF
         END IF
         IF mst.mst05 ='61' THEN 
            LET l_prno = mst.mst06
            SELECT pmk09,pmc03 INTO l_vender,l_pmc03 
              FROM pmk_file,pmc_file
              WHERE pmk09 = pmc01 and pmk01 = l_prno
            IF SQLCA.sqlcode THEN LET l_vender = ' ' LET l_pmc03 = ' ' END IF
         END IF
         EXECUTE insert_prep USING mst.mst08,mst.mst06,mst.mst061,
                                   mst.mst04,l_vender,l_pmc03,
                                   l_gen02,ima.ima43,mss.mss01,
                                   ima.ima02,ima.ima25,mss.mss00,                                                                                             
                                   mss.mss03,mss.mss08,mss.mss09,                                                                                             
                                   l_reqqty,l_othqty,l_cnt,mss.mss02 
       END FOREACH  
       IF l_cnt = 0 THEN
          EXECUTE insert_prep USING '','','','','','',
                                    l_gen02,ima.ima43,mss.mss01,
                                    ima.ima02,ima.ima25,mss.mss00,                                                                                             
                                    mss.mss03,mss.mss08,mss.mss09,                                                                                             
                                    l_reqqty,l_othqty,l_cnt,mss.mss02 
       END IF
       #add by hellen --end
#No.FUN-850041 modify 080513 --end    
       LET mss_o.* = mss.*
       LET ima_o.* = ima.*
     END FOREACH
 
#No.FUN-850041 add 080513 --begin     
#add --begin
     IF g_zz05 = 'Y' THEN                                                                                                       
        CALL cl_wcchp(tm.wc,'mss01,ima08,ima67,ima43,mss02')                                                                             
        RETURNING tm.wc                                                                                                       
     END IF                                                                                                                        
     LET g_str = tm.wc,";",tm.ver_no,";",tm.edate                                                               
                                                                                                                                   
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
     
     CALL cl_prt_cs3('amrr513','amrr513',l_sql,g_str) 
#add --end
 
#mark --begin
#    FINISH REPORT amrr513_rep
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#mark --end
#No.FUN-850041 add 080513 --end
 
END FUNCTION
 
#REPORT amrr513_rep(mss,ima)
#   DEFINE l_last_sw     LIKE type_file.chr1      #NO.FUN-680082 VARCHAR(1)
#   DEFINE mss           RECORD LIKE mss_file.*
#   DEFINE mst           RECORD LIKE mst_file.*
#   DEFINE ima   RECORD      
#                  ima02  LIKE ima_file.ima02,
#                  ima08  LIKE ima_file.ima08,
#                  ima25  LIKE ima_file.ima25,
#                  ima43  LIKE ima_file.ima43
#                END RECORD
#   DEFINE l_reqqty,l_othqty LIKE mss_file.mss041 
#   DEFINE l_cnt    LIKE type_file.num5          #NO.FUN-680082 SMALLINT
#   DEFINE l_gen02  LIKE gen_file.gen02 
#   DEFINE l_pono   LIKE pmm_file.pmm01 
#   DEFINE l_prno   LIKE pmm_file.pmm01 
#   DEFINE l_vender LIKE pmm_file.pmm09 
#   DEFINE l_pmc03  LIKE pmc_file.pmc03 
#
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#  ORDER BY ima.ima43,mss.mss01,mss.mss02,mss.mss03
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company   #TQC-6A0080
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1]    #TQC-6A0080
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#
#      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = ima.ima43
#      IF SQLCA.sqlcode THEN LET l_gen02 = ' ' END IF
#      LET g_head1= g_x[22] clipped,ima.ima43,' ',l_gen02
#      PRINT g_head1
#      LET g_head1=g_x[16] CLIPPED,tm.ver_no,'  ',g_x[21] CLIPPED,tm.edate
#      PRINT g_head1
#      PRINT g_dash[1,g_len] CLIPPED
#      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
#            g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED 
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF ima.ima43   #採購員
#       SKIP TO TOP OF PAGE
#
#   BEFORE GROUP OF mss.mss02
#      PRINT COLUMN g_c[31],g_x[17] CLIPPED,
#            COLUMN g_c[32],mss.mss01,
#            COLUMN g_c[33],g_x[18] CLIPPED,
#            COLUMN g_c[34],ima.ima02,
#            COLUMN g_c[35],g_x[19] CLIPPED,
#            COLUMN g_c[36],ima.ima25 
#
#   BEFORE GROUP OF mss.mss03
#      LET l_cnt = 0
#      LET l_reqqty = mss.mss041+mss.mss043+mss.mss044
#      LET l_othqty = mss.mss051+mss.mss052+mss.mss053 +
#                    #---------No.TQC-740005 modify
#                    #mss.mss063+mss.mss064+mss.mss065 + mss.mss09
#                     mss.mss064+mss.mss065 + mss.mss09
#                    #---------No.TQC-740005 end
#      PRINT COLUMN g_c[31],mss.mss00 USING '###&',#FUN-590118
#            COLUMN g_c[32],mss.mss03,
#            COLUMN g_c[33],cl_numfor((mss.mss08+mss.mss09),33,0), 
#            COLUMN g_c[34],cl_numfor(l_reqqty,34,0),
#            COLUMN g_c[35],cl_numfor(l_othqty,35,0); 
#
#   ON EVERY ROW 
#       #-->取請購/採購供給
#       FOREACH r513_curmst  USING mss.mss01,mss.mss02,mss.mss03,mss.mss_v
#         INTO mst.*
#         LET l_cnt = l_cnt + 1
#         IF mst.mst05 = '62' OR mst.mst05 = '63' THEN
#            LET l_pono = mst.mst06          #No.FUN-550055
#            SELECT pmm09,pmc03 INTO l_vender,l_pmc03 
#              FROM pmm_file,pmc_file
#              WHERE pmm09 = pmc01 and pmm01 = l_pono AND pmm18 !='X'
#            IF SQLCA.sqlcode THEN LET l_vender = ' ' LET l_pmc03 = ' ' END IF
#         END IF
#         IF mst.mst05 ='61' THEN 
#            LET l_prno = mst.mst06          #No.FUN-550055
#            SELECT pmk09,pmc03 INTO l_vender,l_pmc03 
#              FROM pmk_file,pmc_file
#              WHERE pmk09 = pmc01 and pmk01 = l_prno
#            IF SQLCA.sqlcode THEN LET l_vender = ' ' LET l_pmc03 = ' ' END IF
#         END IF
#         PRINT COLUMN g_c[36],cl_numfor(mst.mst08,36,0), 
#               COLUMN g_c[37],mst.mst06,     #No.FUN-550055
#               COLUMN g_c[38],mst.mst061 using '###&', #FUN-590118
#               COLUMN g_c[39],mst.mst04,
#               COLUMN g_c[40],l_vender,
#               COLUMN g_c[41],l_pmc03
#       END FOREACH
#
#   AFTER GROUP OF mss.mss03
#      IF l_cnt = 0 THEN PRINT ' ' END IF
#
#   AFTER GROUP OF mss.mss02
#      PRINT g_dash[1,g_len] CLIPPED
#
#   ON LAST ROW
#      LET l_last_sw = 'y'
##     PRINT g_dash2[1,g_len] CLIPPED
#      PRINT '(amrr513)', COLUMN g_len-9, g_x[7] CLIPPED      #No.TQC-6A0080
##     PRINT '(amrr513)'                                      #No.TQC-6A0080
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash2[1,g_len] CLIPPED
#              PRINT '(amrr513)', COLUMN g_len-9, g_x[6] CLIPPED   #No.TQC-6A0080
##             PRINT '(amrr513)'                                   #No.TQC-6A0080
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#FUN-870144
