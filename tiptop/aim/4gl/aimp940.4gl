# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimp940.4gl
# Descriptions...: 安全存量計算
# Date & Author..: FUN-730042 07/03/21 BY yiting 
# Modify.........: NO.TQC-740056 07/04/18 by yiting 
# Modify.........: No.FUN-840194 08/06/23 By sherry 增加變動前置時間批量（ima061）
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/23 By vealxu ima26x 調整
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No.FUN-AB0025 10/11/11 By vealxu p940_tm() 中 tm.wc 加上 企業料號的條件 
# Modify.........: No.FUN-B30211 11/04/01By yangtingting   1、離開MAIN時沒有cl_used(1)和cl_used(2)
#                                                           2、未加離開前得cl_used(2)
# Modify.........: No.TQC-B70047 11/07/06 By guoch 處理mfg2733報錯後提示無法關閉退出問題
# Modify.........: No.FUN-B80070 11/08/08 By fanbj EXIT PROGRAM 前加cl_used(2)
# Modify.........: No.FUN-BB0084 11/11/30 By lixh1 增加數量欄位小數取位
# Modify.........: No.MOD-CA0077 12/10/11 By zhangll 修改公式：料件單位時間消耗量=該段期間領用(即期间内tlf出库记录)/天數
# Modify.........: No.FUN-C30315 13/01/09 By Nina 只要程式有UPDATE ima_file 的任何一個欄位時,多加imadate=g_today 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD			 # Print condition RECORD
           wc     LIKE type_file.chr1000, #FUN-730042
           ima01  LIKE ima_file.ima01,
           ima06  LIKE ima_file.ima06,
           bdate  LIKE type_file.dat,
           edate  LIKE type_file.dat,
           style  LIKE type_file.chr1,
           upd    LIKE type_file.chr1
           END RECORD 
DEFINE g_bmb           DYNAMIC ARRAY OF RECORD       #每階存放資料
                       bmb01   LIKE bmb_file.bmb01,
                       bmb03   LIKE bmb_file.bmb03
                       END RECORD
DEFINE g_change_lang   LIKE type_file.chr1     #是否有做語言切換 No.FUN-570122  #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num5     #FUN-5B0016 #No.FUN-690026 SMALLINT
DEFINE #g_sql           LIKE type_file.chr1000 
       g_sql      STRING     #NO.FUN-910082        
DEFINE g_date          LIKE type_file.num5
DEFINE g_i             LIKE type_file.num5
DEFINE g_tlf10         LIKE tlf_file.tlf10
MAIN
DEFINE l_flag LIKE type_file.chr1    #FUN-570122  #No.FUN-690026 VARCHAR(1)
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.wc = ARG_VAL(1)
   LET tm.ima01 = ARG_VAL(2)
   LET tm.ima06 = ARG_VAL(3)
   LET tm.bdate = ARG_VAL(4)
   LET tm.edate = ARG_VAL(5)
   LET tm.style = ARG_VAL(6)
   LET tm.upd   = ARG_VAL(7)
   LET g_bgjob = ARG_VAL(8)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
   IF s_shut(0) THEN EXIT PROGRAM END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211
   WHILE TRUE
      LET g_success = 'Y'
      BEGIN WORK
      IF g_bgjob = 'N' THEN
         CALL p940_tm(0,0)                   # Input print condition
         IF cl_sure(0,0) THEN
            CALL p940_p1()
            IF g_success='Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
            END IF
 
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p940_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         CALL p940_p1()
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN
 
FUNCTION p940_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num5     #No.FUN-690026 SMALLINT
   DEFINE lc_cmd        LIKE type_file.chr1000  #No.FUN-570122 #No.FUN-690026 VARCHAR(500)
   DEFINE l_date1       LIKE type_file.dat
   DEFINE l_date2       LIKE type_file.dat
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 16 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 4 LET p_col = 36
   ELSE
       LET p_row = 4 LET p_col = 16
   END IF
 
   OPEN WINDOW p940_w AT p_row,p_col
        WITH FORM "aim/42f/aimp940" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_opmsg('p')
 
   CALL cl_ui_init()  #MOD-530155  從while迴圈移出
 
 WHILE TRUE
   INITIALIZE tm.* TO NULL		          # Default condition
   CONSTRUCT BY NAME tm.wc ON ima01,ima06 
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION locale
          #->No.FUN-570122--end---
          CALL cl_dynamic_locale()     #No.TQC-6C0153
          CALL cl_show_fld_cont()     #No.TQC-6C0153
          LET g_change_lang = TRUE
          #->No.FUN-570122--end---
         CONTINUE CONSTRUCT     #No.TQC-6C0153
 
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
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(ima01) #料件編號    
#FUN-AA0059 --Begin--
               #   CALL cl_init_qry_var()
               #   LET g_qryparam.form     = "q_ima"
               #   LET g_qryparam.state    = "c"
               #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                  DISPLAY g_qryparam.multiret TO ima01
                  NEXT FIELD ima01
               WHEN INFIELD(ima06) #
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_ima11"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima06
                  NEXT FIELD ima06
            END CASE
   END CONSTRUCT
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
 
   IF INT_FLAG THEN 
       LET INT_FLAG = 0 CLOSE WINDOW p940_w 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM 
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   LET tm.wc = tm.wc CLIPPED," AND( ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL ) " #FUN-AB0025  

   LET tm.bdate = g_today
   LET tm.edate = g_today
   LET tm.upd = 'Y'
   INPUT BY NAME tm.bdate,tm.edate,tm.style,tm.upd,g_bgjob
                  WITHOUT DEFAULTS
 
      AFTER FIELD edate
          LET l_date1 = ((YEAR(tm.bdate) *12) + MONTH(tm.bdate))
          LET l_date2 = ((YEAR(tm.edate) *12) + MONTH(tm.edate))
          IF l_date2 < l_date1 THEN NEXT FIELD bdate END IF
              
       AFTER FIELD g_bgjob
          IF g_bgjob NOT MATCHES "[YN]"  OR cl_null(g_bgjob) THEN
              NEXT FIELD g_bgjob
          END IF
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(ima01) #料件編號    
#FUN-AA0059 --Begin--
                #   CALL cl_init_qry_var()
                #   LET g_qryparam.form ="q_ima"
                #   CALL cl_create_qry() RETURNING tm.ima01
                   CALL q_sel_ima(FALSE, "q_ima", "", "" , "", "", "", "" ,"",'' )  RETURNING tm.ima01 
#FUN-AA0059 --End--
                   DISPLAY BY NAME tm.ima01
                   NEXT FIELD ima01
               WHEN INFIELD(ima06) #
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_ima11"
                   CALL cl_create_qry() RETURNING tm.ima06
                   DISPLAY BY NAME tm.ima06
                   NEXT FIELD ima06
            END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
 
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
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
   END INPUT
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW p940_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211 
      EXIT PROGRAM END IF
 
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
        WHERE zz01 = "aimp940"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('aimp940','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",tm.wc CLIPPED,"'",
                      " '",tm.ima01 CLIPPED,"'",
                      " '",tm.ima06 CLIPPED,"'",
                      " '",tm.bdate CLIPPED,"'",
                      " '",tm.edate CLIPPED,"'",
                      " '",tm.style CLIPPED,"'",
                      " '",tm.upd CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('aimp940',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p940_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
  EXIT WHILE
 END WHILE  
END FUNCTION
 
FUNCTION p940_p1()
    DEFINE l_name   LIKE type_file.chr20         # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
    DEFINE l_sql    LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(600)
    DEFINE l_ima    RECORD LIKE ima_file.*
    DEFINE l_tlf    RECORD LIKE tlf_file.*
    DEFINE l_amt    LIKE type_file.num20_6
    DEFINE l_order1 LIKE type_file.num20_6
    DEFINE l_ima38  LIKE ima_file.ima38
    DEFINE l_tlf10_sum LIKE type_file.num20_6
    DEFINE l_leadtime  LIKE type_file.num5
    DEFINE l_oeb_sum   LIKE type_file.num20_6
    DEFINE l_pur1      LIKE type_file.num20_6
    DEFINE l_ima88     LIKE ima_file.ima88
    DEFINE l_supply_time  LIKE type_file.num5,
           l_pml01     LIKE pml_file.pml01,
           l_pml02     LIKE pml_file.pml02,
           l_rvb_sum   LIKE rvb_file.rvb07
    DEFINE l_cnt1      LIKE type_file.num5
    DEFINE l_ima25     LIKE ima_file.ima25   #FUN-BB0084 
    DEFINE l_ima44     LIKE ima_file.ima44   #FUN-BB0084
 
    #--期間天數-----  
    LET g_date  = tm.edate - tm.bdate + 1
 
    #--依條件找出符合料件資料-------------
    LET l_sql = "SELECT *",
                    " FROM ima_file",
                    " WHERE imaacti = 'Y'",
                    "   AND ",tm.wc
    PREPARE p940_pb FROM l_sql
    DECLARE p940_cs CURSOR WITH HOLD FOR p940_pb
    CALL cl_outnam('aimp940') RETURNING l_name
    START REPORT p940_rep TO l_name
    LET l_amt = 0
    FOREACH p940_cs INTO l_ima.*
	IF STATUS THEN CALL s_errmsg('','','foreach:',STATUS,0) 
            LET g_success = 'N'
            EXIT FOREACH 
        END IF
        #--料件單位時間消耗量------------
        LET l_sql = "SELECT SUM(tlf10) ",
                        " FROM tlf_file",
                        " WHERE tlf01 = '",l_ima.ima01,"'",
                        "   AND tlf907 = '-1' ",               #只取出庫
                        "   AND tlf06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                        "   AND tlf13 NOT LIKE 'aimt32*'"    #排除調撥動作
        PREPARE p940_tlf_p FROM l_sql
        DECLARE p940_tlf_c CURSOR WITH HOLD FOR p940_tlf_p  
        OPEN p940_tlf_c 
        FETCH p940_tlf_c INTO l_tlf10_sum
        IF SQLCA.SQLCODE < 0 OR STATUS THEN
            LET g_success = 'N'
            ROLLBACK WORK
        END IF
        IF cl_null(l_tlf10_sum) THEN LET l_tlf10_sum = 0 END IF
 
       #MOD-CA0077 mark
       #SELECT COUNT(*) INTO l_cnt1  
       #  FROM bmb_file
       # WHERE bmb03 = l_ima.ima01
       #IF l_cnt1 > 0 THEN   #存於元件中時展到主件資料
       #     #--展階--
       #     LET g_i = 1 
       #     LET g_tlf10 = 0 
       #     CALL p940_root_bom(0,l_ima.ima01) 
       #END IF
       #LET g_tlf10 = g_tlf10 + l_tlf10_sum
       #MOD-CA0077 mark--end
        #-->料件單位時間消耗量 (該段期間領用+出貨量)/天數
       #LET l_amt = g_tlf10 /g_date 
        LET l_amt = l_tlf10_sum /g_date   #MOD-CA0077 mod
        
        #--前置時間---
        IF (l_ima.ima08 = 'P' OR l_ima.ima08 = 'Z' OR l_ima.ima08 = 'V'
           OR l_ima.ima08 = 'K') THEN
           LET l_leadtime = (l_ima.ima48 + l_ima.ima49 + l_ima.ima491 + l_ima.ima50)
        ELSE
           #LET l_leadtime = (l_ima.ima59 + l_ima.ima61 + (l_ima.ima60*l_ima.ima56)) #No.FUN-840194
           LET l_leadtime = (l_ima.ima59 + l_ima.ima61 + (l_ima.ima60/l_ima.ima601*l_ima.ima56)) #No.FUN-840194
        END IF
 
        #--再訂購點量--(料件單位時間消耗量 * 前置時間) + 安全存量
        IF cl_null(l_amt) THEN LET l_amt=0 END IF      #FUN-BB0084
        LET l_ima38 = l_amt * l_leadtime + l_ima.ima27
        IF cl_null(l_ima38) THEN LET l_ima38 = 0 END IF
    #FUN-BB0084 -------------Begin-------------
        SELECT ima25 INTO l_ima25 FROM ima_file
         WHERE ima01 = l_ima.ima01
        LET l_ima38 = s_digqty(l_ima38,l_ima25)  
    #FUN-BB0084 -------------End--------------- 

#        #--該次再訂購點量--
#        LET l_ima38 = l_order1 - l_ima.ima262
#        IF cl_null(l_ima38) OR l_ima38 < 0 THEN LET l_ima38 = 0 END IF
        IF tm.upd = 'Y' THEN 
           IF (tm.style = '1' OR tm.style = '3') THEN
               UPDATE ima_file SET ima38=l_ima38,
                                   imadate = g_today     #FUN-C30315 add 
                WHERE ima01=l_ima.ima01
               IF SQLCA.SQLERRD[3]=0 OR STATUS THEN
                  LET g_success='N'
                  CALL cl_err3("upd","ima_file",l_ima.ima01,'',STATUS,"","upd ima38",1)   #NO.FUN-640266
                  ROLLBACK WORK
               END IF
           END IF
        END IF
 
        #--補貨時間---(期間月數*30天)+期間天數
        LET l_supply_time = 0 
        IF cl_null(l_ima.ima89) THEN LET l_ima.ima89 = 0 END IF
        IF cl_null(l_ima.ima90) THEN LET l_ima.ima90 = 0 END IF
        LET l_supply_time = (l_ima.ima89 * 30) + l_ima.ima90
        IF cl_null(l_supply_time) THEN LET l_supply_time = 0 END IF
 
        #--期間採購量---
        #(料件單位時間消耗量*(前置時間+補貨期間)+安全存量)
        LET l_ima88 = 0
        LET l_ima88= (l_amt *(l_leadtime + l_supply_time)) + l_ima.ima27
        IF cl_null(l_ima88) THEN LET l_ima88 = 0 END IF
     #FUN-BB0084 ----------Begin---------------
        SELECT ima44 INTO l_ima44 FROM ima_file
         WHERE ima01 = l_ima.ima01
        LET l_ima88 = s_digqty(l_ima88,l_ima44) 
     #FUN-BB0084 ----------End-----------------   
       
#        #--在外訂單量------------
#        LET l_sql = "SELECT SUM(oeb12) ",
#                        " FROM oeb_file,oea_file",
#                        " WHERE oea01 = oeb01 ",
#                        "   AND oeb04 = '",l_ima.ima01,"'",
#                        "   AND oea02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
#                        "   AND oeaconf = 'Y'"
#
#        PREPARE p940_oeb1_p FROM l_sql
#        DECLARE p940_oeb1_c CURSOR WITH HOLD FOR p940_oeb1_p  
#        OPEN p940_oeb1_c 
#        FETCH p940_oeb1_c INTO l_oeb_sum   #訂單需求量
#        IF SQLCA.SQLCODE < 0 OR STATUS THEN
#            LET g_success = 'N'
#            ROLLBACK WORK 
#        END IF
#        IF cl_null(l_oeb_sum) THEN LET l_oeb_sum = 0 END IF
#        IF cl_null(l_tlf10_sum) THEN LET l_tlf10_sum = 0 END IF
#        LET l_amt = 0
#        LET l_amt = l_tlf10_sum /g_date  #-->料件單位時間消耗量 
 
        #--未交採購量-----
#        LET l_sql = "SELECT pml01,pml02 ",
#                   " FROM oeb_file,pml_file,oea_file",
#                    " WHERE oeb01 = pml24 ",   #訂單單號
#                    "   AND oeb03 = pml25 ",   #訂單項次
#                    "   AND oea01 = oeb01 ",
#                    "   AND oeb04 = '",l_ima.ima01,"'",
#                    "   AND oea02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
#                    "   AND oeaconf = 'Y'"
 
#        PREPARE p940_oeb2_p FROM l_sql
#        DECLARE p940_oeb2_c CURSOR WITH HOLD FOR p940_oeb2_p  
#        FOREACH p940_oeb2_c INTO l_pml01,l_pml02
#            IF SQLCA.SQLCODE < 0 OR STATUS THEN
#                LET g_success = 'N'
#                ROLLBACK WORK 
#            END IF
#            LET l_sql = "SELECT SUM(pmn20-rvb07) ",
#                        " FROM pmn_file,rvb_file,pmm_file,rva_file",
#                        " WHERE rva01 = rvb01 ",
#                        "   AND pmn01 = pmm01 ",
#                        "   AND rvb04 = pmn01 ", 
#                        "   AND rvb03 = pmn02 ",
#                        "   AND pmn04 = '",l_ima.ima01,"'",
#                        "   AND pmn25 = '",l_pml02,"'",
#                        "   AND rvaconf = 'Y'",
#                        "   AND pmm18 = 'Y'"
#
#            PREPARE p940_rvb_p FROM l_sql
#            DECLARE p940_rvb_c CURSOR WITH HOLD FOR p940_rvb_p  
#            OPEN p940_rvb_c 
#            FETCH p940_rvb_c INTO l_rvb_sum
#                IF SQLCA.SQLCODE < 0 OR STATUS THEN
#                    LET g_success = 'N'
#                    ROLLBACK WORK 
#                END IF
#            LET l_rvb_sum = l_rvb_sum + l_rvb_sum
#        END FOREACH
#        IF cl_null(l_rvb_sum) THEN LET l_rvb_sum = 0 END IF                
#        IF cl_null(l_tlf10_sum) THEN LET l_tlf10_sum = 0 END IF
 
        #--該次期間採購量--
#        LET l_ima88 = l_amt * (g_date + l_leadtime) + l_ima.ima27 -
#                     (l_ima.ima262+l_rvb_sum-l_oeb_sum ) 
#        IF cl_null(l_ima88) OR l_ima88 < 0 THEN LET l_ima88 = 0  END IF
        IF tm.upd = 'Y' THEN 
            IF (tm.style = '2' OR tm.style = '3') THEN  #NO.TQC-740056
                UPDATE ima_file SET ima88=l_ima88,
                                    imadate = g_today     #FUN-C30315 add
                 WHERE ima01=l_ima.ima01
                IF SQLCA.SQLERRD[3]=0 OR STATUS THEN
                   LET g_success='N'
                   CALL cl_err3("upd","ima_file",l_ima.ima01,'',STATUS,"","upd ima88",1)   #NO.FUN-640266
                   ROLLBACK WORK
                END IF
            END IF   #NO.TQC-740056
        END IF
        OUTPUT TO REPORT p940_rep(l_ima.*,l_ima38,l_ima88)
     END FOREACH
     FINISH REPORT p940_rep
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
#MOD-CA0077 mark
#FUNCTION p940_root_bom(p_level,p_key)
#   DEFINE l_opd_sum    LIKE opd_file.opd08
#   DEFINE l_sql        STRING
#   DEFINE l_tlf_sum    LIKE tlf_file.tlf10
#   DEFINE l_opd_total  LIKE opd_file.opd08
#   DEFINE l_tlf_total  LIKE tlf_file.tlf10
#   DEFINE p_i          LIKE type_file.num5
#   DEFINE p_level      LIKE type_file.num5,    #No.FUN-680096 SMALLINT
#          l_total      LIKE csa_file.csa0301,  #No.FUN-680096 DEC(13,5)
#          p_key	       LIKE bmb_file.bmb03,    
#          l_ac,i       LIKE type_file.num5,    #No.FUN-680096 SMALLINT
#          arrno	       LIKE type_file.num5,    #No.FUN-680096 SMALLINT
#          b_seq	       LIKE bmb_file.bmb02,    #滿時,重新讀單身之起始序號
#          l_chr	       LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
#          l_ima06      LIKE ima_file.ima06,    #分群碼
#          j,k          LIKE type_file.num5,
#          sr DYNAMIC ARRAY OF RECORD       #每階存放資料
#              bmb15 LIKE bmb_file.bmb15,    #元件耗用特性
#              bmb16 LIKE bmb_file.bmb16,    #替代特性
#              bmb01 LIKE bmb_file.bmb01,
#              bmb03 LIKE bmb_file.bmb03,    #元件料號
#              ima05 LIKE ima_file.ima05,    #版本
#              ima08 LIKE ima_file.ima08,    #來源
#              ima37 LIKE ima_file.ima37,    #補貨
#              ima63 LIKE ima_file.ima63,    #發料單位
#              ima55 LIKE ima_file.ima55,    #生產單位
#              bmb02 LIKE bmb_file.bmb02,    #項次
#              bmb06 LIKE bmb_file.bmb06,    #QPA
#              bmb08 LIKE bmb_file.bmb08,    #損耗率%
#              bmb10 LIKE bmb_file.bmb10,    #發料單位
#              bmb04 LIKE bmb_file.bmb04,    #有效日期
#              bmb05 LIKE bmb_file.bmb05,    #失效日期
#              bmb14 LIKE bmb_file.bmb14,    #元件使用特性
#              bmb17 LIKE bmb_file.bmb17,    #Feature
#              bmb29 LIKE bmb_file.bmb29,     #FUN-550095 add
#              bmb10_fac LIKE bmb_file.bmb10_fac
#          END RECORD,
#          l_cmd     LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(1000)
#          l_opd06   LIKE opd_file.opd06    
# 
#    IF p_level > 20 THEN
#	     CALL cl_err('','mfg2733',1) 
#             CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80070--add--
#	     EXIT PROGRAM     #TQC-B70047
#    END IF
#    LET p_level = p_level + 1
#    IF p_level = 1 THEN
#        INITIALIZE sr[1].* TO NULL
#        LET sr[1].bmb03 = p_key
#    END IF
#    LET arrno = 600
#    WHILE TRUE
#        LET l_cmd=
#            "SELECT bmb15,bmb16,bmb01,bmb03,ima05,ima08,",
#            "ima37,ima63,ima55,bmb02,bmb06/bmb07,bmb08,bmb10,",
#            "bmb04,bmb05,bmb14,",
#            "bmb17,bmb29,bmb10_fac ", #FUN-550095 add bmb29
#            " FROM bmb_file, ima_file",
#            " WHERE bmb03='", p_key,"' AND bmb02 > ",b_seq,
#            " AND bmb01 = ima01"
#        #生效日及失效日的判斷
#            LET l_cmd=l_cmd CLIPPED, " AND ((bmb04 <='",tm.bdate,
#            "' OR bmb04 IS NULL) OR (bmb05 >'",tm.bdate,
#            "' OR bmb05 IS NULL))"
#        PREPARE p940_ppp FROM l_cmd
#        IF SQLCA.sqlcode THEN 
#           CALL cl_err('P1:',SQLCA.sqlcode,1) 
#           CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
#           EXIT PROGRAM 
#        END IF
#        DECLARE p940_cur CURSOR for p940_ppp
#        LET l_ac = 1
#        FOREACH p940_cur INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
#            LET l_ac = l_ac + 1			# 但BUFFER不宜太大
#            IF l_ac >= arrno THEN 
#                EXIT FOREACH 
#            END IF
#        END FOREACH
#        FOR i = 1 TO l_ac-1			# 讀BUFFER傳給REPORT
#            #-------過去實際用量-------
#            LET l_sql = "SELECT SUM(tlf10) ",
#                        " FROM tlf_file",
#                        " WHERE tlf01 = '",sr[i].bmb01,"'",
#                        "   AND tlf907 = '-1' ",               #只取出庫
#                        "   AND tlf06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
#                        "   AND tlf13 NOT LIKE 'aimt32*'"    #排除調撥動作
#            PREPARE p940_tlf_p1 FROM l_sql
#            DECLARE p940_tlf_c1 SCROLL CURSOR WITH HOLD FOR p940_tlf_p1
#            OPEN p940_tlf_c1
#            FETCH p940_tlf_c1 INTO l_tlf_sum
#            IF STATUS THEN 
#                CALL s_errmsg('','','fetch:',STATUS,0) 
#                LET g_success = 'N'
#                ROLLBACK WORK
#            END IF 
#            IF cl_null(l_tlf_sum) THEN LET l_tlf_sum = 0 END IF
#            LET l_tlf_total=sr[i].bmb06*sr[i].bmb10_fac*l_tlf_sum
#            IF cl_null(l_tlf_total) THEN LET l_tlf_total = 0 END IF
#            LET g_tlf10 = g_tlf10 + l_tlf_total   
# 
#            LET g_bmb[g_i].bmb01 = sr[i].bmb01
#            LET g_bmb[g_i].bmb03 = sr[i].bmb03
#            LET g_i= g_i + 1
#            CALL p940_root_bom(p_level,sr[i].bmb01)
#        END FOR
#        IF l_ac < arrno OR l_ac=1 THEN         # BOM單身已讀完
#            EXIT WHILE
#        ELSE
#            LET b_seq = sr[arrno].bmb02
#        END IF
#    END WHILE
#END FUNCTION
#MOD-CA0077 mark--end
 
REPORT p940_rep(p_ima,p_ima38,p_ima88)
DEFINE l_last_sw   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE p_ima       RECORD LIKE ima_file.*
DEFINE p_oeb_sum   LIKE type_file.num20_6,
       p_rvb_sum   LIKE rvb_file.rvb07
DEFINE p_pur1      LIKE type_file.num20_6
DEFINE p_ima88     LIKE ima_file.ima88
DEFINE p_ima38     LIKE ima_file.ima38
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 
  ORDER BY p_ima.ima01
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
    BEFORE GROUP OF p_ima.ima01
      PRINT COLUMN g_c[31],p_ima.ima01 CLIPPED,
            COLUMN g_c[32],p_ima.ima02 CLIPPED;    
    
    ON EVERY ROW
      PRINT COLUMN g_c[33],cl_numfor(p_ima38,33,g_azi03),
            COLUMN g_c[34],cl_numfor(p_ima88,34,g_azi03),
            COLUMN g_c[35],p_ima.ima25
            #COLUMN g_c[36],cl_numfor(p_oeb_sum,36,g_azi03),
            #COLUMN g_c[37],cl_numfor(p_ima88,37,g_azi03)
 
   ON LAST ROW
      LET l_last_sw = 'y'
      PRINT g_dash
      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
 
END REPORT  
#No.FUN-A20044 ---end
 
