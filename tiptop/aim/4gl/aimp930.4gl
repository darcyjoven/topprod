# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: aimp930.4gl
# Descriptions...: 安全存量計算
# Date & Author..: FUN-730042 07/03/21 BY yiting 
# Modify.........: TQC-740056 07/04/12 by Yiting
# Modify.........: NO.TQC-750003 07/05/04 by Yiting 預測量計算(目前相同的料號+廠商為key時，抓出單身資料，以單頭的計劃日期為主，重複資料只抓最新的)
# Modify.........: NO.MOD-780193 07/08/22 BY yiting CONTROLF
# Modify.........: No.FUN-840194 08/06/23 By sherry 增加變動前置時間批量（ima061）
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/29 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: NO.TQC-AB0018 10/11/03 By Kevin 報表需使用ORDER EXTERNAL BY
# Modify.........: No.FUN-AB0025 10/11/11 By vealxu p930_tm() 中 tm.wc 加上 企業料號的條件 
# Modify.........: No.FUN-B30211 11/04/01By yangtingting   1、離開MAIN時沒有cl_used(1)和cl_used(2)
#                                                           2、未加離開前得cl_used(2)
# Modify.........: No.FUN-C30315 13/01/09 By Nina 只要程式有UPDATE ima_file 的任何一個欄位時,多加imadate=g_today

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD			 # Print condition RECORD
            wc     LIKE type_file.chr1000, #FUN-730042
            ima01  LIKE ima_file.ima01,
            ima06  LIKE ima_file.ima06,
            bdate  LIKE type_file.dat,
            edate  LIKE type_file.dat,
            fac    LIKE type_file.chr1,
            buk    LIKE type_file.chr1, 
            sty    LIKE type_file.chr1,
            upd    LIKE type_file.chr1
           END RECORD 
DEFINE g_change_lang   LIKE type_file.chr1     #是否有做語言切換 No.FUN-570122  #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num5     #FUN-5B0016 #No.FUN-690026 SMALLINT
DEFINE #g_sql           LIKE type_file.chr1000 
       g_sql      STRING     #NO.FUN-910082        
DEFINE g_total         LIKE type_file.num10
DEFINE g_i             LIKE type_file.num5
DEFINE g_bmb           DYNAMIC ARRAY OF RECORD       #每階存放資料
                       bmb01   LIKE bmb_file.bmb01,
                       bmb03   LIKE bmb_file.bmb03,
                       total   LIKE type_file.num20_6
                       END RECORD
DEFINE g_diff          LIKE type_file.num20_6
DEFINE g_day           DYNAMIC ARRAY OF RECORD     
                       bdate       LIKE type_file.dat, 
                       edate       LIKE type_file.dat,
                       opd_total   LIKE opd_file.opd08,
                       tlf_total   LIKE tlf_file.tlf10
                       END RECORD
DEFINE g_amt           LIKE type_file.num20_6
DEFINE g_standard      LIKE type_file.num20_6
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
   LET tm.fac   = ARG_VAL(6)
   LET tm.buk   = ARG_VAL(7)
   LET tm.sty   = ARG_VAL(8)
   LET tm.upd   = ARG_VAL(9)
   LET g_bgjob = ARG_VAL(10)
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
         CALL p930_tm(0,0)                   # Input print condition
         IF cl_sure(0,0) THEN
            CALL p930_p1()
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
               CLOSE WINDOW p930_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         CALL p930_p1()
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
 
FUNCTION p930_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num5     #No.FUN-690026 SMALLINT
   DEFINE lc_cmd        LIKE type_file.chr1000  #No.FUN-570122 #No.FUN-690026 VARCHAR(500)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 16 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 4 LET p_col = 36
   ELSE
       LET p_row = 4 LET p_col = 16
   END IF
 
   OPEN WINDOW p930_w AT p_row,p_col
        WITH FORM "aim/42f/aimp930" 
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
 
#NO.TQC-740056 start--
     ON ACTION controlp
        CASE
           WHEN INFIELD(ima01) #料件編號   
#FUN-AA0059 --Begin--
             # CALL cl_init_qry_var()
             # LET g_qryparam.form     = "q_ima"
             # LET g_qryparam.state    = "c"
             # CALL cl_create_qry() RETURNING g_qryparam.multiret
              CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
              DISPLAY g_qryparam.multiret TO ima01
              NEXT FIELD ima01
           WHEN INFIELD(ima06) #分群碼
             #CALL q_imz(10,3,g_ima.ima06) RETURNING g_ima.ima06
              CALL cl_init_qry_var()
              LET g_qryparam.form     = "q_imz"
              LET g_qryparam.state    = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ima06
              NEXT FIELD ima06
        END CASE
#NO.TQC-740056 end-------
 
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
 
   END CONSTRUCT
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
   IF INT_FLAG THEN 
       LET INT_FLAG = 0 CLOSE WINDOW p930_w 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM 
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   LET tm.wc = tm.wc CLIPPED," AND (ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL ) "    #FUN-AB0025
   
   LET tm.bdate = g_today
   LET tm.edate = g_today
   LET tm.fac = '1'
   LET tm.buk = '1'
   LET tm.sty = '1'
   LET g_bgjob = 'N'   #FUN-570122
   LET tm.upd = 'Y'
   INPUT BY NAME tm.bdate,tm.edate,tm.fac,tm.buk,tm.sty,tm.upd,g_bgjob
                  WITHOUT DEFAULTS
 
      AFTER FIELD g_bgjob
          IF g_bgjob NOT MATCHES "[YN]"  OR cl_null(g_bgjob) THEN
              NEXT FIELD g_bgjob
          END IF
 
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
 
#NO.MOD-780193 start--
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
#NO.MOD-780193 end------
   END INPUT
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW p930_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM END IF
 
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
        WHERE zz01 = "aimp930"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('aimp930','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",tm.wc CLIPPED,"'",
                      " '",tm.ima01 CLIPPED,"'",
                      " '",tm.ima06 CLIPPED,"'",
                      " '",tm.bdate CLIPPED,"'",
                      " '",tm.edate CLIPPED,"'",
                      " '",tm.fac CLIPPED,"'",
                      " '",tm.buk CLIPPED,"'",
                      " '",tm.sty CLIPPED,"'",
                      " '",tm.upd CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('aimp930',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p930_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM
   END IF
  EXIT WHILE
 END WHILE  
END FUNCTION
 
FUNCTION p930_p1()
    DEFINE l_name       LIKE type_file.chr20         # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
    DEFINE l_sql        STRING
    DEFINE l_ima        RECORD LIKE ima_file.*
    DEFINE l_fac        LIKE type_file.num20_6
    DEFINE l_leadtime      LIKE type_file.num5
    DEFINE l_leadtime_root LIKE type_file.num20_6
    DEFINE l_cnt1       LIKE type_file.num5
    DEFINE l_opd08_sum  LIKE opd_file.opd08
    DEFINE l_bmb_tot    LIKE type_file.num10
    DEFINE l_amt   LIKE type_file.num20_6
    DEFINE i       LIKE type_file.num5,     #No.FUN-680137 SMALLINT
           j       LIKE type_file.num5,     #No.FUN-680137 SMALLINT
           k       LIKE type_file.num5,     #FUN-650137 add       #No.FUN-680137 SMALLINT
           m,n     LIKE type_file.num5,
           l_m1    LIKE type_file.num5,     #FUN-650137 add       #No.FUN-680137 SMALLINT
           l_mm    LIKE type_file.num5,     #月                   #No.FUN-680137 SMALLINT
           l_dd    LIKE type_file.num5,     #日                   #No.FUN-680137 SMALLINT
           l_yy    LIKE type_file.num5      #年                   #No.FUN-680137 SMALLINT
    DEFINE l_ima27 LIKE ima_file.ima27
    DEFINE l_n     LIKE type_file.num5
 
    #--安全係數--
    CASE 
        WHEN tm.fac = '1'
             LET l_fac = 1.3
        WHEN tm.fac = '2'
             LET l_fac = 1.6
        WHEN tm.fac = '3'
             LET l_fac = 2.4
    END CASE
    #--期數-----
    LET i = 1 
    WHILE TRUE
        LET g_day[i].bdate = i
        CASE tm.buk
             WHEN '4' #天
                  LET g_day[i].bdate = tm.bdate + (i-1)*1
                  LET g_day[i].edate = g_day[i].bdate
             WHEN '3' #週
                  LET g_day[i].bdate = tm.bdate + (i-1)*7
                  LET g_day[i].edate = g_day[i].bdate + 6
             WHEN '2' #旬
                 #當提列方式3.旬, 起始日期應為該月1號,
                 #以該月之最後一天為下旬最後一天
                  IF i = 1 THEN
                      LET l_mm = MONTH(tm.bdate)
                      LET l_dd = 1
                      LET l_yy = YEAR(tm.bdate)
                      LET g_day[i].bdate = MDY(l_mm,l_dd,l_yy)
                  ELSE
                      LET g_day[i].bdate = g_day[i-1].edate + 1
                  END IF
                  LET k = i MOD 3
                  IF k != 0 THEN
                     LET g_day[i].edate = g_day[i].bdate + 9
                  ELSE   #日期應抓當月最後一天
                     LET l_mm = MONTH(g_day[i].bdate)
                     IF l_mm + 1 > 12 THEN 
                         LET g_day[i].edate = MDY((l_mm+1)-12,l_dd,l_yy+1) -1
                     ELSE
                         LET g_day[i].edate = MDY(l_mm+1,l_dd,l_yy) - 1
                     END IF
                  END IF
                  LET l_mm = MONTH(g_day[i].bdate)
                  LET l_yy = YEAR(g_day[i].bdate)
             WHEN '1' #月
                  IF i = 1 THEN
                      LET l_mm = MONTH(tm.bdate)
                      LET l_dd = 1
                      LET l_yy = YEAR(tm.bdate)
                      LET g_day[i].bdate = MDY(l_mm,l_dd,l_yy)
                  ELSE
                      LET g_day[i].bdate = g_day[i-1].bdate + 1 UNITS MONTH
                  END IF
                  LET l_mm = MONTH(g_day[i].bdate)
                  LET l_yy = YEAR(g_day[i].bdate)
                  CASE
                      WHEN l_mm = 1 OR l_mm = 3  OR l_mm = 5 OR l_mm = 7 OR
                           l_mm = 8 OR l_mm = 10 OR l_mm = 12
                           LET l_dd = 31
                      WHEN l_mm = 4 OR l_mm = 6 OR l_mm = 9 OR l_mm = 11
                           LET l_dd = 30
                      WHEN l_mm = 2
                           LET l_dd = 29
                           IF l_yy mod 4 = 0 THEN      #計算是否為潤年
                               IF l_yy mod 100 = 0 THEN
                                   IF l_yy mod 400 = 0 THEN
                                       LET l_dd = 29
                                   ELSE
                                       LET l_dd = 28
                                   END IF
                               ELSE
                                   LET l_dd = 29
                               END IF
                           ELSE
                               LET l_dd = 28
                           END IF
                      END CASE
                      LET g_day[i].edate = MDY(l_mm,l_dd,l_yy)
        END CASE
        IF g_day[i].bdate > tm.edate THEN 
            INITIALIZE g_day[i].* TO NULL                         # Default cond
            CALL g_day.deleteElement(i)
            EXIT WHILE 
        END IF
        LET i = i + 1    #期數
    END WHILE
    LET i = i - 1
 
    #--依條件找出符合料件資料-------------
    LET l_sql = "SELECT *",
                " FROM ima_file",
                " WHERE imaacti = 'Y'",
                "   AND ",tm.wc
    PREPARE p930_pb FROM l_sql
    DECLARE p930_cs CURSOR WITH HOLD FOR p930_pb
    CALL cl_outnam('aimp930') RETURNING l_name
    START REPORT p930_rep TO l_name
    CALL s_showmsg_init()   
    FOREACH p930_cs INTO l_ima.*
	IF STATUS THEN 
            CALL s_errmsg('','','foreach:',STATUS,0) 
            LET g_success = 'N'
            EXIT FOREACH 
        END IF
        #--前置時間---
        IF (l_ima.ima08 = 'P' OR l_ima.ima08 = 'Z' OR l_ima.ima08 = 'V'
           OR l_ima.ima08 = 'K') THEN
           LET l_leadtime = (l_ima.ima48 + l_ima.ima49 + l_ima.ima491 + l_ima.ima50)
        ELSE
           #LET l_leadtime = (l_ima.ima59 + l_ima.ima61 + (l_ima.ima60*l_ima.ima56)) #No.FUN-840194
           LET l_leadtime = (l_ima.ima59 + l_ima.ima61 + (l_ima.ima60/l_ima.ima601*l_ima.ima56))  #No.FUN-840194
        END IF
        IF cl_null(l_leadtime) THEN LET l_leadtime = 1 END IF
        IF tm.sty = '1' THEN
           CALL p930_bom(0,l_ima.ima01)
        END IF
        #--期數算法--
        IF i > 30 THEN 
            LET l_n = i  
        ELSE
            LET l_n = i - 1
        END IF
        IF cl_null(l_n) OR l_n = 0 THEN LET l_n=1 END IF
 
        LET n = g_day.getLength()
        LET g_amt = 0
        LET l_amt = 0
        FOR m = 1 TO n 
            #標準差=(sum((每一期預測用量)-(實際用量))平方)/期數------
            LET l_amt = (g_day[m].opd_total - g_day[m].tlf_total) * (g_day[m].opd_total - g_day[m].tlf_total)
            LET g_amt = g_amt + l_amt
        END FOR
        IF cl_null(g_amt) THEN LET g_amt = 0 END IF
        CALL s_root(g_amt,2) RETURNING g_diff
        IF cl_null(g_diff) THEN LET g_diff = 0 END IF
        CALL cl_digcut(g_diff,0) RETURNING g_diff   #NO.TQC-740056
        LET g_standard = g_diff / l_n
        IF cl_null(g_standard) THEN LET g_standard = 0 END IF
        CALL cl_digcut(g_standard,0) RETURNING g_standard   #NO.TQC-740056
 
        #--安全存量---
        CALL s_root(l_leadtime,2) RETURNING l_leadtime_root
        CALL cl_digcut(l_leadtime_root,0) RETURNING l_leadtime_root  #NO.TQC-740056
        LET l_ima27 =  l_fac * l_leadtime_root * g_diff
        CALL cl_digcut(l_ima27,0) RETURNING l_ima27   #NO.TQC-740056
        
        IF tm.upd = 'Y' THEN
            UPDATE ima_file SET ima27 = l_ima27,
                                imadate = g_today     #FUN-C30315 add
             WHERE ima01=l_ima.ima01
            IF SQLCA.SQLERRD[3]=0 OR STATUS THEN
               LET g_success='N'
               CALL cl_err3("upd","ima_file",l_ima.ima01,'',STATUS,"","upd ima27",1)   #NO.FUN-640266
               ROLLBACK WORK
            END IF
        END IF
        OUTPUT TO REPORT p930_rep(l_ima.*,l_ima27)
    END FOREACH
    FINISH REPORT p930_rep
    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT p930_rep(p_ima,p_ima27)
DEFINE l_last_sw   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE p_ima       RECORD LIKE ima_file.*
DEFINE p_ima27     LIKE ima_file.ima27
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 
  ORDER EXTERNAL BY p_ima.ima01   #TQC-AB0018
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT
      PRINT g_x[35],tm.bdate,'-',tm.edate CLIPPED
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
    BEFORE GROUP OF p_ima.ima01
      PRINT COLUMN g_c[31],p_ima.ima01 CLIPPED,
            COLUMN g_c[32],p_ima.ima02 CLIPPED;    
    
    ON EVERY ROW
      PRINT COLUMN g_c[33],cl_numfor(p_ima27,33,0),
            COLUMN g_c[34],p_ima.ima25
 
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
 
FUNCTION p930_bom(p_level,p_key)
DEFINE p_level	LIKE type_file.num5    #No.FUN-680096 SMALLINT
DEFINE l_sql    STRING,
       p_key    LIKE bma_file.bma01    #主件料件編號
DEFINE i,j,k    LIKE type_file.num5
DEFINE l_sum    LIKE type_file.num20_6
DEFINE l_bmb01  LIKE bmb_file.bmb01
DEFINE l_bmb03  LIKE bmb_file.bmb03
DEFINE l_opd08_sum  LIKE opd_file.opd08
DEFINE l_opd_sum    LIKE opd_file.opd08
DEFINE l_cnt1       LIKE type_file.num5
DEFINE l_opd_cnt    LIKE type_file.num5
DEFINE l_opd08      LIKE opd_file.opd08
DEFINE l_opd08_1    LIKE opd_file.opd08   #NO.TQC-750003
DEFINE l_opd06      LIKE opd_file.opd06
DEFINE l_tlf10      LIKE tlf_file.tlf10
DEFINE l_cnt        LIKE type_file.num5   #no.TQC-750003
 
     LET j =g_day.getlength()  #找出期距的array總筆數
     FOR k = 1 TO j            #依每一期距找出預測用量及實際用量
         #---QBE料件本身銷售預測量---(最新的計劃日期數量)
         LET l_sql = "SELECT SUM(opd08) ",
                     "  FROM opd_file,opc_file",
                     " WHERE opc01 = opd01 ",
                     "   AND opc01 = '",p_key,"'",
                     "   AND opc02 = opd02 ",
                     "   AND opc03 = opd03 ",
                     "   and opd06 BETWEEN '",g_day[k].bdate,"' and '",g_day[k].edate,"'", #單身起始日介於本次資料範圍中
#NO.TQC-750003 start--
                     "   AND opc03 IN (SELECT MAX(opc03) FROM opd_file,opc_file
                                        WHERE opc01 = opd01
                                          AND opc01 = '",p_key,"'
                                          AND opd06 BETWEEN '",g_day[k].bdate,"' and '",g_day[k].edate,"')" #單身起始日介於本次資料範圍中
#NO.TQC-750003 end---
        PREPARE p930_opd_p2 FROM l_sql
        DECLARE p930_opd_c2 SCROLL CURSOR WITH HOLD FOR p930_opd_p2
#NO.TQC-750003 start--
        OPEN p930_opd_c2
        FETCH p930_opd_c2 INTO l_opd08   #axmi171銷售預測單身用量
        IF cl_null(l_opd08) THEN LET l_opd08 = 0 END IF
        LET g_day[k].opd_total = l_opd08
 
        #--再算出相同的料件+客戶編號為主，計劃數量(非最新日期),如目前時距
        #--範圍內無存在數量的話，則寫入此時距範圍內數量
        IF l_opd08 = 0 THEN
            LET l_sql = "SELECT SUM(opd08) ",
                        "  FROM opd_file,opc_file",
                        " WHERE opc01 = opd01 ",
                        "   AND opc01 = '",p_key,"'",
                        "   AND opc02 = opd02 ",
                        "   AND opc03 = opd03 ",
                        "   and opd06 BETWEEN '",g_day[k].bdate,"' and '",g_day[k].edate,"'", #單身起始日介於本次資料範圍中
                        "   AND opc03 <> (SELECT MAX(opc03) FROM opd_file,opc_file
                                           WHERE opc01 = opd01
                                             AND opc01 = '",p_key,"'
                                             AND opd06 BETWEEN '",g_day[k].bdate,"' and '",g_day[k].edate,"')" #單身起始日介於本次資料範圍中
            PREPARE p930_opd_p3 FROM l_sql
            DECLARE p930_opd_c3 SCROLL CURSOR WITH HOLD FOR p930_opd_p3
            OPEN p930_opd_c3
            FETCH p930_opd_c3 INTO l_opd08_1   #axmi171銷售預測單身用量
            IF l_opd08 = 0 THEN LET g_day[k].opd_total = l_opd08_1 END IF
        END IF
#NO.TQC-750003 end-------
 
         #-------過去實際用量-------
         LET l_sql = "SELECT SUM(tlf10) ",
                     " FROM tlf_file",
                     " WHERE tlf01 = '",p_key,"'",
                     "   AND tlf907 = '-1' ",               #只取出庫
                     "   AND tlf06 BETWEEN '",g_day[k].bdate,"' AND '",g_day[k].edate,"'",
                     "   AND tlf13 NOT LIKE 'aimt32*'"    #排除調撥動作
         PREPARE p930_tlf_p FROM l_sql
         DECLARE p930_tlf_c SCROLL CURSOR WITH HOLD FOR p930_tlf_p
         CALL s_showmsg_init()   
         OPEN p930_tlf_c
         FETCH p930_tlf_c INTO l_tlf10
         IF STATUS THEN 
             CALL s_errmsg('','','fetch:',STATUS,0) 
             LET g_success = 'N'
             ROLLBACK WORK
         END IF 
         IF cl_null(l_tlf10) THEN LET l_tlf10 = 0 END IF
         LEt g_day[k].tlf_total = l_tlf10
         SELECT COUNT(*) INTO l_cnt1  
           FROM bmb_file
          WHERE bmb03 = p_key
         IF l_cnt1 > 0 THEN   #存於元件中時展到主件資料
             #--展階--
             LET g_i = 1
             CALL p930_root_bom(0,p_key,l_opd08,l_tlf10,k) 
         ELSE
             LET g_total = 0 
         END IF
     END FOR
END FUNCTION
 
FUNCTION p930_root_bom(p_level,p_key,p_opd08,p_tlf10,p_i)
   DEFINE l_opd_sum    LIKE opd_file.opd08
   DEFINE l_opd_sum_1  LIKE opd_file.opd08   #NO.TQC-750003
   DEFINE l_cnt        LIKE type_file.num5   #no.TQC-750003
   DEFINE l_sql        STRING
   DEFINE l_tlf_sum    LIKE tlf_file.tlf10
   DEFINE l_opd_total  LIKE opd_file.opd08
   DEFINE l_tlf_total  LIKE tlf_file.tlf10
   DEFINE p_i          LIKE type_file.num5
   DEFINE p_level      LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          p_opd08      LIKE opd_file.opd08,
          p_tlf10      LIKE tlf_file.tlf10,
          l_total      LIKE csa_file.csa0301,  #No.FUN-680096 DEC(13,5)
          p_key	       LIKE bmb_file.bmb03,    
          l_ac,i       LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          arrno	       LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          b_seq	       LIKE bmb_file.bmb02,    #滿時,重新讀單身之起始序號
          l_chr	       LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
          l_ima06      LIKE ima_file.ima06,    #分群碼
          j,k          LIKE type_file.num5,
          sr DYNAMIC ARRAY OF RECORD       #每階存放資料
              bmb15 LIKE bmb_file.bmb15,    #元件耗用特性
              bmb16 LIKE bmb_file.bmb16,    #替代特性
              bmb01 LIKE bmb_file.bmb01,
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              ima05 LIKE ima_file.ima05,    #版本
              ima08 LIKE ima_file.ima08,    #來源
              ima37 LIKE ima_file.ima37,    #補貨
              ima63 LIKE ima_file.ima63,    #發料單位
              ima55 LIKE ima_file.ima55,    #生產單位
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb06 LIKE bmb_file.bmb06,    #QPA
              bmb08 LIKE bmb_file.bmb08,    #損耗率%
              bmb10 LIKE bmb_file.bmb10,    #發料單位
              bmb04 LIKE bmb_file.bmb04,    #有效日期
              bmb05 LIKE bmb_file.bmb05,    #失效日期
              bmb14 LIKE bmb_file.bmb14,    #元件使用特性
              bmb17 LIKE bmb_file.bmb17,    #Feature
              bmb29 LIKE bmb_file.bmb29,     #FUN-550095 add
              bmb10_fac LIKE bmb_file.bmb10_fac
          END RECORD,
          l_cmd     LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(1000)
          l_opd06   LIKE opd_file.opd06    
 
    IF p_level > 20 THEN
	CALL cl_err('','mfg2733',1) 
        END IF
    LET p_level = p_level + 1
    IF p_level = 1 THEN
        INITIALIZE sr[1].* TO NULL
        LET sr[1].bmb03 = p_key
    END IF
    LET arrno = 600
    WHILE TRUE
        LET l_cmd=
            "SELECT bmb15,bmb16,bmb01,bmb03,ima05,ima08,",
            "ima37,ima63,ima55,bmb02,bmb06/bmb07,bmb08,bmb10,",
            "bmb04,bmb05,bmb14,",
            "bmb17,bmb29,bmb10_fac ", #FUN-550095 add bmb29
            " FROM bmb_file, ima_file",
            " WHERE bmb03='", p_key,"' AND bmb02 > ",b_seq,
            " AND bmb01 = ima01"
        #生效日及失效日的判斷
            LET l_cmd=l_cmd CLIPPED, " AND ((bmb04 <='",tm.bdate,
            "' OR bmb04 IS NULL) OR (bmb05 >'",tm.bdate,
            "' OR bmb05 IS NULL))"
        PREPARE p930_ppp FROM l_cmd
        IF SQLCA.sqlcode THEN 
           CALL cl_err('P1:',SQLCA.sqlcode,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
           EXIT PROGRAM 
        END IF
        DECLARE p930_cur CURSOR for p930_ppp
        LET l_ac = 1
        FOREACH p930_cur INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
            LET l_ac = l_ac + 1			# 但BUFFER不宜太大
            IF l_ac >= arrno THEN 
                EXIT FOREACH 
            END IF
        END FOREACH
        FOR i = 1 TO l_ac-1			# 讀BUFFER傳給REPORT
            #--預測用量-----
            LET g_sql = " SELECT SUM(opd08) ",
                        "   FROM opd_file,opc_file",
                        " WHERE opc01 = opd01 ",
                        "   AND opc01 = '",sr[i].bmb01,"'",
                        "   AND opc02 = opd02 ",
                        "   AND opc03 = opd03 ",
                        "   AND opd06 BETWEEN '",g_day[p_i].bdate,"' AND '",g_day[p_i].edate,"'", #單身起始日介於本次資料範圍中
#NO.TQC-750003 start--
                        "   AND opc03 IN (SELECT MAX(opc03) FROM opd_file,opc_file
                                           WHERE opc01 = opd01
                                             AND opc01 = '",sr[i].bmb01,"'
                                             AND opd06 BETWEEN '",g_day[p_i].bdate,"' and '",g_day[p_i].edate,"')" #單身起始日介於本次資料範圍中
#NO.TQC-750003 end---
            PREPARE p930_opd_p1 FROM g_sql
            DECLARE p930_opd_c1 SCROLL CURSOR WITH HOLD FOR p930_opd_p1
            OPEN p930_opd_c1
            FETCH p930_opd_c1 INTO l_opd_sum   #axmi171銷售預測單身用量
            IF sr[i].bmb10_fac IS NULL THEN LET sr[i].bmb10_fac = 1 END IF
            IF cl_null(l_opd_sum) THEN LET l_opd_sum = 0 END IF
 
#NO.TQC-750003 start------------------------------------------------------------
            IF l_opd_sum = 0 THEN 
                LET g_sql = "SELECT SUM(opd08) ",
                            "  FROM opd_file,opc_file",
                            " WHERE opc01 = opd01 ",
                            "   AND opc01 = '",sr[i].bmb01,"'",
                            "   AND opc02 = opd02 ",
                            "   AND opc03 = opd03 ",
                            "   AND opd06 BETWEEN '",g_day[p_i].bdate,"' AND '",g_day[p_i].edate,"'", #單身起始日介於本次資料範圍中
                            "   AND opc03 <> (SELECT MAX(opc03) FROM opd_file,opc_file
                                               WHERE opc01 = opd01
                                                 AND opc01 = '",sr[i].bmb01,"'
                                                 AND opd06 BETWEEN '",g_day[p_i].bdate,"' and '",g_day[p_i].edate,"')" #單身起始日介於本次資料範圍中
                PREPARE p930_opd_p4 FROM g_sql
                DECLARE p930_opd_c4 SCROLL CURSOR WITH HOLD FOR p930_opd_p4
                OPEN p930_opd_c4
                FETCH p930_opd_c4 INTO l_opd_sum_1   #axmi171銷售預測單身用量
            END IF
            #如果最新計劃日期抓不到此時距範圍資料時，則以非最新計劃日期去抓
            IF l_opd_sum = 0 THEN           
                LET l_opd_total=sr[i].bmb06*sr[i].bmb10_fac*l_opd_sum_1
                IF cl_null(l_opd_total) THEN LET l_opd_total = 0 END IF
                LET g_day[p_i].opd_total = g_day[p_i].opd_total + l_opd_total   
            ELSE
                LET l_opd_total=sr[i].bmb06*sr[i].bmb10_fac*l_opd_sum
                IF cl_null(l_opd_total) THEN LET l_opd_total = 0 END IF
                LET g_day[p_i].opd_total = g_day[p_i].opd_total + l_opd_total   
            END IF
#NO.TQC-750003 end--------------------------------------------------------------
 
            #-------過去實際用量-------
            LET l_sql = "SELECT SUM(tlf10) ",
                        " FROM tlf_file",
                        " WHERE tlf01 = '",sr[i].bmb01,"'",
                        "   AND tlf907 = '-1' ",               #只取出庫
                        "   AND tlf06 BETWEEN '",g_day[p_i].bdate,"' AND '",g_day[p_i].edate,"'",
                        "   AND tlf13 NOT LIKE 'aimt32*'"    #排除調撥動作
            PREPARE p930_tlf_p1 FROM l_sql
            DECLARE p930_tlf_c1 SCROLL CURSOR WITH HOLD FOR p930_tlf_p1
            OPEN p930_tlf_c1
            FETCH p930_tlf_c1 INTO l_tlf_sum
            IF STATUS THEN 
                CALL s_errmsg('','','fetch:',STATUS,0) 
                LET g_success = 'N'
                ROLLBACK WORK
            END IF 
            IF cl_null(l_tlf_sum) THEN LET l_tlf_sum = 0 END IF
            LET l_tlf_total=sr[i].bmb06*sr[i].bmb10_fac*l_tlf_sum
            IF cl_null(l_tlf_total) THEN LET l_tlf_total = 0 END IF
            LET g_day[p_i].tlf_total = g_day[p_i].tlf_total + l_tlf_total   
 
            LET g_bmb[g_i].bmb01 = sr[i].bmb01
            LET g_bmb[g_i].bmb03 = sr[i].bmb03
            LET g_bmb[g_i].total = l_total
            LET g_i= g_i + 1
            CALL p930_root_bom(p_level,sr[i].bmb01,l_opd_total,l_tlf_total,p_i)
        END FOR
        IF l_ac < arrno OR l_ac=1 THEN         # BOM單身已讀完
            EXIT WHILE
        ELSE
            LET b_seq = sr[arrno].bmb02
        END IF
    END WHILE
END FUNCTION
 
