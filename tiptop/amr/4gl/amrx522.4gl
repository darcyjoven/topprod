# Prog. Version..: '5.30.07-13.05.30(00004)'     #
#
# Pattern name...: amrx522.4gl
# Descriptions...: MRP 採購/工單建議表(依行動日)
# Input parameter: 
# Return code....: 
# Date & Author..: 96/06/10 By Roger
# Modify.........: No.FUN-510046 05/01/25 By pengu 報表轉XML
# Modify.........: No.FUN-570240 05/07/22 By vivien 料件編號欄位增加controlp
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: No.TQC-5C0059 05/12/12 By kevin 欄位沒對齊
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610074 06/01/24 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo 欄位類型定義-改為LIKE
# Modify.........: No.FUN-690116 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.FUN-850143 08/06/03 By lutingting報表轉為使用CR
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9C0179 09/12/29 By tsai_yen EXECUTE裡不可有擷取字串的中括號[]
# Modify.........: No.FUN-CB0002 12/11/02 By lujh CR轉XtraGrid
# Modify.........: No:FUN-D30070 13/03/21 By yangtt 去掉頁脚排序顯示 
# Modify.........: No:FUN-D40129 13/05/06 By yangtt 新增ima021欄位
# Modify.........: No.FUN-D40128 13/05/08 By wangrr "來源碼""採購員""計劃員""廠牌"增加開窗
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                              # Print condition RECORD       
              wc      LIKE type_file.chr1000,     # Where condition           #NO.FUN-680082 VARCHAR(600)
              n       LIKE type_file.chr1,                                    #NO.FUN-680082 VARCHAR(1)
              ver_no  LIKE mss_file.mss_v,                                    #NO.FUN-680082 VARCHAR(2)
              s       LIKE type_file.chr3,        #NO.FUN-680082 VARCHAR(3)
              t       LIKE type_file.chr3,        #NO.FUN-680082 VARCHAR(3)
              more    LIKE type_file.chr1         # Input more condition(Y/N) #NO.FUN-680082 VARCHAR(1)
              END RECORD
 
DEFINE   g_cnt           LIKE type_file.num10     #NO.FUN-680082 INTEGER
DEFINE   g_i             LIKE type_file.num5      #count/index for any purpose #NO.FUN-680082 SMALLINT
DEFINE   g_sql           STRING                   #No.FUN-850143
DEFINE   g_str           STRING                   #No.FUN-850143
DEFINE   l_table         STRING                   #No.FUN-850143
DEFINE   l_str           STRING                   #FUN-CB0002  add
 
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
 
   #No.FUN-850143---------start--
   LET g_sql = "mss11.mss_file.mss11,",
               "mss01.mss_file.mss01,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",   #FUN-D40129
               "ima25.ima_file.ima25,",
               "mss02.mss_file.mss02,",
               "pmc03.pmc_file.pmc03,",
               "mss00.mss_file.mss00,",
               "mss03.mss_file.mss03,",
               "mss09.mss_file.mss09,",
               "mss10.mss_file.mss10,",
               "ima08.ima_file.ima08,",
               "ima67.ima_file.ima67,",
               "ima43.ima_file.ima43"  
   LET l_table = cl_prt_temptable('amrx522',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?, ?,?,?,?)"    #FUN-D40129 add 1?
               
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep:',STATUS,1) EXIT PROGRAM
   END IF 
   #No.FUN-850143---------end
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #TQC-610074-begin
   LET tm.n = ARG_VAL(8)
   LET tm.ver_no = ARG_VAL(9)
   LET tm.s = ARG_VAL(10)
   LET tm.t = ARG_VAL(11)
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(8)
   #LET g_rep_clas = ARG_VAL(9)
   #LET g_template = ARG_VAL(10)
   ##No.FUN-570264 ---end---
   #TQC-610074-end
   IF cl_null(g_bgjob) OR g_bgjob='N'        # If background job sw is off
      THEN CALL amrx522_tm(0,0)        # Input print condition
      ELSE CALL amrx522()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION amrx522_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01      #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,     #NO.FUN-680082 SMALLINT
          l_cmd          LIKE type_file.chr1000   #NO.FUN-680082 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 14
   ELSE LET p_row = 4 LET p_col = 15
   END IF
 
   OPEN WINDOW amrx522_w AT p_row,p_col
        WITH FORM "amr/42f/amrx522" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.n    = '1'
   LET tm.more = 'N'
   LET tm.s    = '123'
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
   CONSTRUCT BY NAME tm.wc ON mss11,ima08,ima43,mss03,mss01,ima67,mss02 
 
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
         #FUN-D40128--add--str--
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
         #FUN-D40128--add--end                                                            
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
      LET INT_FLAG = 0 CLOSE WINDOW amrx522_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
 
   INPUT BY NAME tm.ver_no, tm.n,
                   tm2.s1,tm2.s2,tm2.s3,
                   tm2.t1,tm2.t2,tm2.t3,
                   tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD ver_no
         IF cl_null(tm.ver_no) THEN NEXT FIELD ver_no END IF
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
      LET INT_FLAG = 0 CLOSE WINDOW amrx522_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='amrx522'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amrx522','9031',1)
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
                         #TQC-610074-begin
                         " '",tm.n CLIPPED,"'",
                         " '",tm.ver_no CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         #TQC-610074-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('amrx522',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW amrx522_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL amrx522()
   ERROR ""
END WHILE
   CLOSE WINDOW amrx522_w
END FUNCTION
 
FUNCTION amrx522()
   DEFINE l_name    LIKE type_file.chr20,   # External(Disk) file name       #NO.FUN-680082 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0076
          l_sql     LIKE type_file.chr1000, # RDSQL STATEMENT                #NO.FUN-680082 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,    #NO.FUN-680082 VARCHAR(1)
          l_za05    LIKE type_file.chr1000, #NO.FUN-680082 VARCHAR(40)
          l_order ARRAY[3] OF LIKE mss_file.mss01, #FUN-5B0105 20->40        #NO.FUN-680082 VARCHAR(40)
          sr    RECORD
                l_order1 LIKE mss_file.mss01,    #FUN-5B0105 20->40  #NO.FUN-680082 VARCHAR(40)
                l_order2 LIKE mss_file.mss01,    #FUN-5B0105 20->40  #NO.FUN-680082 VARCHAR(40)
                l_order3 LIKE mss_file.mss01     #FUN-5B0105 20->40  #NO.FUN-680082 VARCHAR(40)
          END RECORD,
          mss	RECORD LIKE mss_file.*,
          ima	RECORD LIKE ima_file.*
 
  #No.FUN-850143-----start--
  DEFINE l_pmc03      LIKE pmc_file.pmc03
  DEFINE l_ima02      LIKE ima_file.ima02
  DEFINE l_mss02      LIKE mss_file.mss02   #TQC-9C0179
  DEFINE l_msg1       LIKE type_file.chr100  #FUN-CB0002
  DEFINE l_msg2       LIKE type_file.chr100  #FUN-CB0002
  DEFINE l_msg3       LIKE type_file.chr100  #FUN-CB0002
  DEFINE l_ima021     LIKE ima_file.ima021   #FUN-D40129
  
  CALL cl_del_data(l_table)
  
  SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'amrx522'
  
  #No.FUN-850143-----end
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = "SELECT *",
                 " FROM mss_file, ima_file",
                 " WHERE mss01=ima01 AND mss09 > 0 ",
                 " AND mss_v='",tm.ver_no,"'",
                 " AND ",tm.wc clipped
     PREPARE amrx522_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
        EXIT PROGRAM 
     END IF
     DECLARE amrx522_curs1 CURSOR FOR amrx522_prepare1
 
     #CALL cl_outnam('amrx522') RETURNING l_name    #No.FUN-850143
     #START REPORT amrx522_rep TO l_name     #No.FUN-850143
     LET g_pageno = 0
     FOREACH amrx522_curs1 INTO mss.*, ima.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       IF tm.n='1' AND mss.mss10='Y' THEN CONTINUE FOREACH END IF
       IF tm.n='2' AND mss.mss10='N' THEN CONTINUE FOREACH END IF
       
       #No.FUN-850143---------start--
       #FOR g_cnt = 1 TO 3
       #  CASE
       #    WHEN tm.s[g_cnt,g_cnt]='1' LET l_order[g_cnt]=mss.mss11
       #                                                  USING 'yyyymmdd'
       #    WHEN tm.s[g_cnt,g_cnt]='2' LET l_order[g_cnt]=mss.mss01
       #    WHEN tm.s[g_cnt,g_cnt]='3' LET l_order[g_cnt]=ima.ima08
       #    WHEN tm.s[g_cnt,g_cnt]='4' LET l_order[g_cnt]=ima.ima67
       #    WHEN tm.s[g_cnt,g_cnt]='5' LET l_order[g_cnt]=ima.ima43
       #    WHEN tm.s[g_cnt,g_cnt]='6' LET l_order[g_cnt]=mss.mss02
       #    WHEN tm.s[g_cnt,g_cnt]='7' LET l_order[g_cnt]=mss.mss03
       #                                                  USING 'yyyymmdd'
       #    OTHERWISE LET l_order[g_cnt]='-'
       #  END CASE
       #END FOR
       #LET sr.l_order1=l_order[1]
       #LET sr.l_order2=l_order[2]
       #LET sr.l_order3=l_order[3]
 
      #SELECT ima02 INTO l_ima02 FROM ima_file  WHERE ima01=mss.mss01   #FUN-D40129 mark
       SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file  WHERE ima01=mss.mss01   #FUN-D40129 add 
       LET l_pmc03 = ''
       SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01=mss.mss02    
       LET l_mss02 = mss.mss02[1,7]   #TQC-9C0179
       EXECUTE insert_prep USING
           #mss.mss11,mss.mss01,l_ima02,ima.ima25,mss.mss02[1,7],l_pmc03,  #TQC-9C0179 mark
           mss.mss11,mss.mss01,l_ima02,l_ima021,ima.ima25,l_mss02,l_pmc03, #TQC-9C0179 mark  #FUN-D40129 add l_ima021
           mss.mss00,mss.mss03,mss.mss09,mss.mss10,ima.ima08,ima.ima67,ima.ima43   
       #OUTPUT TO REPORT amrx522_rep(sr.*,mss.*, ima.*)
       #No.FUN-850143---------end
     END FOREACH
 
     #No.FUN-850143--------start--
###XtraGrid###     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     #FUN-CB0002--mark--str--
     #IF g_zz05 = 'Y'   THEN
     #   CALL cl_wcchp(tm.wc,'mss11,ima08,ima43,mss03,mss01,ima67,mss02')
     #   RETURNING tm.wc
     #END IF
     #FUN-CB0002--mark--end--
     
###XtraGrid###     LET g_str = tm.wc,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
###XtraGrid###                 tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",tm.n,";",tm.ver_no
     
###XtraGrid###     CALL cl_prt_cs3('amrx522','amrx522',g_sql,g_str)
    LET g_xgrid.table = l_table    ###XtraGrid###

    IF g_zz05 = 'Y'   THEN
        CALL cl_wcchp(tm.wc,'mss11,ima08,ima43,mss03,mss01,ima67,mss02')
        RETURNING tm.wc
     END IF
    
    LET g_xgrid.order_field = cl_get_order_field(tm.s,"mss11,mss01,ima08,ima67,ima43,mss02,mss03")
    LET g_xgrid.skippage_field = cl_get_skip_field(tm.s,tm.t,"mss11,mss01,ima08,ima67,ima43,mss02,mss03")

   #LET l_str = cl_wcchp(g_xgrid.order_field,"mss11,mss01,ima08,ima67,ima43,mss02,mss03")  #FUN-D30070  mark
   #LET l_str = cl_replace_str(l_str,',','-')  #FUN-D30070  mark
    LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc
   #LET g_xgrid.footerinfo1 = cl_getmsg("lib-626",g_lang),l_str  #FUN-D30070  mark
    IF tm.n = '1' THEN 
       LET l_msg1 = cl_getmsg("amr-070",g_lang)
    END IF 
    IF tm.n = '2' THEN 
       LET l_msg1 = cl_getmsg("amr-071",g_lang)
    END IF 
    IF tm.n = '3' THEN 
       LET l_msg1 = cl_getmsg("amr-072",g_lang)
    END IF 
    LET l_msg2 = cl_getmsg("amr-063",g_lang)
    LET l_msg3 = cl_getmsg("amr-064",g_lang)
    LET g_xgrid.footerinfo2 = l_msg2,l_msg1,'|',l_msg3,tm.ver_no
    CALL cl_xg_view()    ###XtraGrid###
     #FINISH REPORT amrx522_rep
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #No.FUN-850143--------end
END FUNCTION
 
#No.FUN-850143-------start--
#REPORT amrx522_rep(sr,mss, ima)
#   DEFINE l_last_sw    LIKE type_file.chr1    #NO.FUN-680082 VARCHAR(1)
#   DEFINE l_pmc03      LIKE pmc_file.pmc03    #NO.FUN-680082 VARCHAR(10)
#   DEFINE l_ima02      LIKE ima_file.ima02
#   DEFINE mss		RECORD LIKE mss_file.*
#   DEFINE ima		RECORD LIKE ima_file.*
#   DEFINE sr RECORD
#             l_order1 LIKE mss_file.mss01, #FUN-5B0105 20->40   #NO.FUN-680082 VARCHAR(40)
#             l_order2 LIKE mss_file.mss01, #FUN-5B0105 20->40   #NO.FUN-680082 VARCHAR(40)
#             l_order3 LIKE mss_file.mss01  #FUN-5B0105 20->40   #NO.FUN-680082 VARCHAR(40)
#          END RECORD 
#
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#  ORDER BY sr.l_order1,sr.l_order2,sr.l_order3,
#           mss.mss11, mss.mss01, mss.mss02, mss.mss03
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      PRINT g_dash[1,g_len] CLIPPED
#      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
#            g_x[39] CLIPPED,g_x[40] CLIPPED
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
#   BEFORE GROUP OF mss.mss11
#      PRINT COLUMN g_c[31],mss.mss11;
#   BEFORE GROUP OF mss.mss01
#      SELECT ima02 INTO l_ima02 FROM ima_file  WHERE ima01=mss.mss01
#      PRINT COLUMN g_c[32],mss.mss01 CLIPPED, #FUN-5B0014 [1,20],
#            COLUMN g_c[33],l_ima02,
#            COLUMN g_c[34],ima.ima25;
#   BEFORE GROUP OF mss.mss02
#      LET l_pmc03 = ''
#      SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01=mss.mss02
#      PRINT COLUMN g_c[35],mss.mss02[1,7],
#            COLUMN g_c[36],l_pmc03;
#   ON EVERY ROW
#      PRINT COLUMN g_c[37], mss.mss00 USING '###&',#No.TQC-5C0059 #FUN-590118
#            COLUMN g_c[38],mss.mss03 USING 'mm/dd',
#            COLUMN g_c[39],cl_numfor(mss.mss09,39,2),
#            COLUMN g_c[40],mss.mss10
#   AFTER GROUP OF mss.mss11
#      PRINT g_dash2[1,g_len] CLIPPED
#   ON LAST ROW
#      LET l_last_sw = 'y'
#      PRINT g_dash[1,g_len]
#      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9),g_x[7]
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash2[1,g_len] CLIPPED
#      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9),g_x[6]
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#No.FUN-850143------end
#FUN-870144


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
