# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aapp900.4gl
# Descriptions...: 委花旗代付款產生作業
# Date & Author..: 98/10/19 by plum
# Modify ........: No.FUN-4B0079 04/11/30 By ching 單價,金額改成 DEC(20,6)
# Modify.........: No.FUN-550030 05/05/18 By ice 單據編號欄位放大
# Modify.........: No.FUN-560011 05/06/03 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.MOD-590411 05/09/23 By Smapmin 更改download的方式
# Modify.........: No.FUN-580098 05/10/26 By CoCo BOTTOM MARGIN g_bottom_margin改5
# Modify.........: NO.FUN-570250 05/12/22 By Rosayu 將日期取消寫死YY/MM/DD
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行時間
# Modify.........: No.FUN-660122 06/06/16 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/30 By Jackho  本（原）幣取位修改
# Modify.........: No.FUN-710014 07/01/10 By bnlent 錯誤訊息匯整
# Modify.........: No.FUN-8A0086 08/10/17 By chenmoyan 將給g_success賦值和調用s_showmsg_init()的語句調換位置。不然如果一次失敗，以后都無法成功
# Modify.........: No.TQC-940178 09/05/12 By Cockroach 跨庫SQL一律改為調用s_dbstring() 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-990048 09/09/14 By sabrina 不需join rvb_file 
# Modify.........: No.FUN-9C0008 09/12/02 By alex 處理環境變數
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No.FUN-A50102 10/06/01 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現 
IMPORT os
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD                          # Print condition RECORD
              wc  LIKE type_file.chr1000,      #Where Condiction  #No.FUN-690028 VARCHAR(300)
              fname  LIKE type_file.chr20,       # No.FUN-690028 VARCHAR(16)
              more   LIKE type_file.chr1       # No.FUN-690028 VARCHAR(1)                   #是否列印其它條件
              END RECORD,
          l_cmd     LIKE type_file.chr1000,           #No.+366 010705 by plum  #No.FUN-690028 VARCHAR(30)
          g_code    LIKE type_file.chr3,       # Prog. Version..: '5.30.06-13.03.12(03) #代碼
          g_apf01   LIKE apf_file.apf01,
          l_apf01   LIKE apf_file.apf01,
          g_nma14   LIKE nma_file.nma14,
          g_nma15   LIKE nma_file.nma15,
          g_year    LIKE type_file.num10,       # No.FUN-690028 INTEGER
          g_month   LIKE type_file.num10,       # No.FUN-690028 INTEGER
          g_date    LIKE type_file.num10        # No.FUN-690028 INTEGER
DEFINE   g_i        LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                              # Supress DEL key function
 
   LET g_pdate = ARG_VAL(1)             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.more  = ARG_VAL(10)
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   LET g_apf01=' '
   LET l_apf01=' '
   LET g_rlang = g_lang
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL aapp900_tm()                    # Input print condition
   ELSE
      CALL aapp900()                       # Read data and create out-file
   END IF

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION aapp900_tm()
   DEFINE   l_cmd         LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(400)
            l_flag        LIKE type_file.chr1,               #是否必要欄位有輸入  #No.FUN-690028 VARCHAR(1)
            l_jmp_flag    LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   OPEN WINDOW aapp900_w WITH FORM "aap/42f/aapp900"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.fname='dsc-ap.txt'
   LET g_code='CHU'
 
   WHILE TRUE
      LET g_action_choice = ""
 
      CONSTRUCT BY NAME tm.wc ON apf01,apf02,aph08
 
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
        ON ACTION locale
           LET g_action_choice='locale'
           EXIT CONSTRUCT
        ON ACTION exit
           LET INT_FLAG = 1
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
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('apfuser', 'apfgrup') #FUN-980030
      IF g_action_choice = 'locale' THEN
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW aapp900_w
         RETURN    #EXIT PROGRAM
      END IF
      IF tm.wc = ' 1=1 ' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      INPUT BY NAME tm.fname,tm.more WITHOUT DEFAULTS
 
         AFTER FIELD fname
            IF cl_null(tm.fname) THEN
               NEXT FIELD fname
            END IF
 
         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,
                         g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
            LET l_flag='N'
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF tm.fname IS NULL THEN
               DISPLAY BY NAME tm.fname
               NEXT FIELD fname
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()        # Command execution
 
         ON ACTION locale
            LET g_action_choice='locale'
            EXIT INPUT
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
      IF g_action_choice = 'locale' THEN
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW aapp900_w
         RETURN      #EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
          WHERE zz01='aapp900'
         IF STATUS OR l_cmd IS NULL THEN
            CALL cl_err('aapp900','9031',1)  
         ELSE
            LET l_cmd = l_cmd CLIPPED,             #(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            " '",g_lang CLIPPED,"'",
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.fname CLIPPED,"'",
                            " '",tm.more CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('aapp900',g_time,l_cmd)  # Execute cmd at later time
         END IF
         CLOSE WINDOW aapp900_w
         RETURN    #EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL aapp900()
      ERROR ""
   END WHILE
   CLOSE WINDOW aapp900_w
END FUNCTION
 
FUNCTION aapp900()
   DEFINE l_name    LIKE type_file.chr20,           # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
          l_sql     LIKE type_file.chr1000,         # RDSQL STATEMENT  #No.FUN-690028 VARCHAR(600)
          l_za05    LIKE type_file.chr1000,         #標題內容  #No.FUN-690028 VARCHAR(40)
          l_msg     LIKE type_file.chr1000,     # No.FUN-690028 VARCHAR(40)               #標題內容
          l_str     LIKE type_file.chr1000,     # No.FUN-690028 VARCHAR(40)
          l_str1    LIKE type_file.chr20,     # No.FUN-690028 VARCHAR(20)
          l_ans     LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1)
          l_inv     LIKE type_file.chr1000,     # No.FUN-690028 VARCHAR(80)
          l_cmd     LIKE type_file.chr50,   #No.FUN-690028 VARCHAR(50)
          l_date    LIKE type_file.dat,     #No.FUN-690028 DATE
          l_flag    LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          l_count   LIKE type_file.num10,   #總筆  #No.FUN-690028 INTEGER
          l_amt     LIKE type_file.num20_6, # No.FUN-690028 DEC(20,6)  #FUN-4B0079#總金額
          l_chr     LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          sr        RECORD
             f1     LIKE type_file.chr3,        # Prog. Version..: '5.30.06-13.03.12(03)  #代碼
             f2     LIKE type_file.chr8,          # Prog. Version..: '5.30.06-13.03.12(06)  #公司代碼
             nma04  LIKE type_file.chr20,       # No.FUN-690028 VARCHAR(10)   #受扣帳號
             pmc081 LIKE pmc_file.pmc081,      # No.FUN-690028 VARCHAR(80)   #支票抬頭
             aph05  LIKE type_file.num20_6,     # No.FUN-690028 dec(20,6)  #支票金額
             apf01  LIKE apf_file.apf01,      # No.FUN-690028 VARCHAR(16)  #付款單號
                               #No.FUN-550030
             apf03  LIKE apf_file.apf03,      # No.FUN-690028 VARCHAR(10)  #廠商編號
             pmc082 LIKE pmc_file.pmc082,      # No.FUN-690028 VARCHAR(40)  #收件人名稱
             pmc52  LIKE pmc_file.pmc52,      # No.FUN-690028 VARCHAR(40)  #發票地址
             pmc53  LIKE pmc_file.pmc53,      # No.FUN-690028 VARCHAR(40)  #收件人地址
             apf02  LIKE apf_file.apf02,      # Prog. Version..: '5.30.06-13.03.12(08)  #交易日
             f3     LIKE type_file.chr4        # Prog. Version..: '5.30.06-13.03.12(04)   #MAIL
             END RECORD
 
     LET l_sql=" SELECT '','','',pmc081,aph05, ",
               "        apf01,apf03,pmc082,pmc52,pmc53,apf02,'' ",
               "   FROM apf_file LEFT OUTER JOIN pmc_file ON apf_file.apf03=pmc_file.pmc01,aph_file ",
               "  WHERE apf01=aph01  ",
               "    AND aph03='Z' AND apf00='33' ",
               "    AND (aph09<>'Y' or aph09 is null) ",
               "    AND apf41='Y' AND ",tm.wc clipped,
               "  ORDER BY apf01 "
 
     PREPARE aapp900_prepare1 FROM l_sql
     IF STATUS != 0 THEN CALL cl_err('prepare:',STATUS,1) 
        RETURN    #EXIT PROGRAM
     END IF
     DECLARE aapp900_curs1 CURSOR FOR aapp900_prepare1
     CALL cl_outnam('aapp900') RETURNING l_name  #l_name=aapp900.out
     LET l_count = 0
     LET l_amt = 0
     LET g_pageno = 0
     START REPORT aapp900_rep TO l_name   #downlink: 'aapp900.out'
     BEGIN WORK
#    CALL s_showmsg_init()       #No.FUN-710014
     LET g_success = 'Y' LET l_chr = '1'
     CALL s_showmsg_init()       #No.FUN-8A0086
 
 
     FOREACH aapp900_curs1 INTO sr.*
       MESSAGE g_x[49] CLIPPED,sr.apf03
       CALL ui.Interface.refresh()
       IF STATUS != 0 THEN
#No.FUN-710014--Begin--
#      CALL cl_err('foreach:',STATUS,1) EXIT FOREACH LET g_success = 'N'
       CALL s_errmsg('','','foreach',STATUS,1)
       LET g_success = 'N'               #No.FUN-8A0086
       LET g_totsuccess = 'N'
       CONTINUE FOREACH
#No.FUN-710014--End--
       END IF
       IF cl_null(sr.pmc081) THEN
          ERROR sr.apf03, g_x[50]
          CONTINUE FOREACH
       END IF
       IF sr.aph05 <0 OR sr.aph05=0 OR sr.aph05 IS NULL THEN
          ERROR sr.apf01,g_x[51]
          CONTINUE FOREACH
       END IF
       IF sr.apf02 IS NULL OR sr.apf02=' ' THEN
          ERROR sr.apf01,g_x[52]
          CONTINUE FOREACH
       END IF
       CALL s_wkday(sr.apf02) RETURNING l_flag,l_date
       IF l_flag='N' THEN
          ERROR sr.apf02,g_x[53]
          CONTINUE FOREACH
       END IF
       LET g_code='CHU'
       LET sr.f1=g_code
       LET sr.f2='020926'
       LET sr.nma04='0020926007'
       LET sr.f3='MAIL'
       LET l_inv=NULL
       IF sr.pmc53 IS NULL OR sr.pmc53=' ' THEN
          LET sr.pmc53=sr.pmc52 #發票地址
       END IF
       IF sr.pmc53 IS NULL OR sr.pmc53=' ' THEN
          ERROR sr.apf03,g_x[54]
          CONTINUE FOREACH
       END IF
       LET l_count=l_count+1
       LET l_amt=l_amt+sr.aph05
       OUTPUT TO REPORT aapp900_rep(sr.*,l_inv)   #downlaod:aapp900.out
       CALL p900(sr.apf01,'aapp9001.out')         #aapp9001.out
       DROP TABLE aapp9001
# No.FUN-690028 --start--
       CREATE TEMP TABLE aapp9001 (
                   l_inv LIKE type_file.chr1000)
# No.FUN-690028 ---end---       
       LOAD FROM 'aapp9001.out' INSERT INTO aapp9001
       DECLARE q_cur2 CURSOR FOR SELECT * FROM aapp9001
       FOREACH q_cur2 INTO l_inv
         IF STATUS != 0 THEN
#No.FUN-710014--Begin--
       CALL cl_err('foreach q_cur2:',STATUS,1) EXIT FOREACH
       CALL s_errmsg('','','foreach q_cur2:',STATUS,1)
       LET g_totsuccess = 'N'
       CONTINUE FOREACH
#No.FUN-710014--End--
         END IF
         OUTPUT TO REPORT aapp900_rep(sr.*,l_inv)
       END FOREACH
      #因為aapp9001.out 為單張付款單資料, cat aapp9001.out >> aapp900x.out
      #所以真正給使用者看的報表名稱為 aapp900x.out
      #No.+366 010705 plum
      #LET l_cmd = "chmod 777 aapp900x.out"
      #RUN l_cmd
       IF os.Path.chrwx("aapp900x.out",511) THEN END IF     #FUN-9C0008
 
       #No.+366..end
       IF l_chr = '1' THEN
          #LET l_cmd = 'cat $TEMPDIR/aapp9001.out>$TEMPDIR/aapp900x.out'    #FUN-9C0008
           LET l_cmd = 'cat ',os.Path.join(FGL_GETENV("TEMPDIR"),"aapp9001.out"),
                          '>',os.Path.join(FGL_GETENV("TEMPDIR"),"aapp900x.out")
           LET l_chr = ' '
           LET l_apf01=g_apf01
       ELSE
          IF g_apf01 != l_apf01 THEN
          #LET l_cmd = 'cat $TEMPDIR/aapp9001.out>>$TEMPDIR/aapp900x.out'
           LET l_cmd = 'cat ',os.Path.join(FGL_GETENV("TEMPDIR"),"aapp9001.out"),
                         '>>',os.Path.join(FGL_GETENV("TEMPDIR"),"aapp900x.out")
           LET l_apf01=g_apf01
          END IF
       END IF
       RUN l_cmd
       UPDATE aph_file SET aph09='Y'
          WHERE aph01=sr.apf01 AND aph03='Z'
       IF SQLCA.sqlcode THEN
#         CALL cl_err('update aph09:',SQLCA.sqlcode,0)   #No.FUN-660122
#No.FUN-710014--Begin--
#         CALL cl_err3("upd","aph_file","","",SQLCA.sqlcode,"","",0) #No.FUN-660122
#         LET g_success='N'
#         EXIT FOREACH
          LET g_showmsg = sr.apf01,"/","Z"
          CALL s_errmsg("aph01,aph03",g_showmsg,"",SQLCA.sqlcode,0)
          LET g_totsuccess = 'N'
          CONTINUE FOREACH
#No.FUN-710014--End--
       END IF
     END FOREACH
#No.FUN-710014  --Begin                                                                                                          
   IF g_totsuccess="N" THEN                                                                                                         
      LET g_success="N"                                                                                                             
   END IF                                                                                                                           
                                                                                                                                    
   CALL s_showmsg()                                                                                                                 
#No.FUN-710014  --End   
     FINISH REPORT aapp900_rep
    #No.+366 010705 plum
#    LET l_cmd = "chmod 777 ", l_name                   #No.FUN-9C0009
#    RUN l_cmd                                          #No.FUN-9C0009
     IF os.Path.chrwx(l_name CLIPPED,511) THEN END IF   #No.FUN-9C0009  add by dxfwo
    #No.+366..end
 
     IF g_success = 'N' THEN ROLLBACK WORK RETURN END IF
     MESSAGE g_x[55] CLIPPED,l_count,g_x[56] CLIPPED,l_amt
     CALL ui.Interface.refresh()
     IF l_count !=0 THEN
        CALL cl_prt('aapp900x.out',g_prtway,g_copies,g_len)
        #------------ Download 至 PC C:/tiptop 目錄下
        IF NOT cl_confirm('aap-773') THEN ROLLBACK WORK RETURN END IF
        COMMIT WORK
       #No.+366 010705 plum
#       LET l_cmd = "chmod 777 ", tm.fname                   #No.FUN-9C0009 
#       RUN l_cmd                                            #No.FUN-9C0009   
        IF os.Path.chrwx(tm.fname CLIPPED,511) THEN END IF   #No.FUN-9C0009  add by dxfwo 
       #No.+366..end
        LET l_cmd="cp ",l_name CLIPPED," ",tm.fname CLIPPED
        RUN l_cmd
#MOD-590411
#       #ps. dtcput 放在 bin之下
#        LET l_cmd="dtcput $TEMPDIR/dsc-ap.txt 'c:\\tiptop\\dsc-ap.txt' "
#        RUN l_cmd

         IF NOT cl_download_file(os.Path.join(FGL_GETENV("TEMPDIR"),"dsc-ap.txt"),"c:/tiptop/"|| tm.fname CLIPPED) THEN
            CALL cl_err('tmp_sz','',1)
         END IF
#END MOD-590411
        ERROR ""
     ELSE
        COMMIT WORK
     END IF
END FUNCTION
 
REPORT aapp900_rep(sr,l_inv)
   DEFINE l_last_sw     LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          l_p_flag      LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          l_flag1       LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          l_nmd14       LIKE gsb_file.gsb05,      # No.FUN-690028 VARCHAR(4)
          g_pmc081      LIKE pmc_file.pmc081,      # No.FUN-690028 VARCHAR(80)
          l_inv         LIKE type_file.chr1000,     # No.FUN-690028 VARCHAR(80)
          sr        RECORD
             f1     LIKE type_file.chr3,        # Prog. Version..: '5.30.06-13.03.12(03)  #代碼
             f2     LIKE type_file.chr8,        # Prog. Version..: '5.30.06-13.03.12(06)  #公司代碼
             nma04  LIKE type_file.chr20,       # No.FUN-690028 VARCHAR(10)  #受扣帳號
             pmc081 LIKE pmc_file.pmc081,    # No.FUN-690028 VARCHAR(80)  #支票抬頭
             aph05  LIKE type_file.num20_6,     # No.FUN-690028 dec(20,6) #支票金額
#            apf01  VARCHAR(10),  #付款單號
             apf01  LIKE apf_file.apf01,      # No.FUN-690028 VARCHAR(16)  #付款單號
                               #No.FUN-550030
             apf03  LIKE apf_file.apf03,      # No.FUN-690028 VARCHAR(10)  #廠商編號
             pmc082 LIKE pmc_file.pmc082,      # No.FUN-690028 VARCHAR(40)  #收件人名稱
             pmc52  LIKE pmc_file.pmc52,      # No.FUN-690028 VARCHAR(40)  #發票地址
             pmc53  LIKE pmc_file.pmc53,      # No.FUN-690028 VARCHAR(40)  #收件人地址
             apf02  LIKE apf_file.apf02,      # Prog. Version..: '5.30.06-13.03.12(08)  #交易日
             f3     LIKE type_file.chr4        # Prog. Version..: '5.30.06-13.03.12(04)   #MAIL
             END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  FORMAT
 
   ON EVERY ROW
      LET g_pmc081=sr.pmc081 clipped,sr.pmc082 clipped
      IF l_inv IS NULL THEN
         PRINT sr.f1,
            COLUMN 04,sr.f2 CLIPPED ,
            COLUMN 10,sr.nma04 CLIPPED,
            COLUMN 20,g_pmc081[1,70],
            COLUMN 90,sr.aph05 USING '###############',
            COLUMN 105,sr.apf03,'  ',
            COLUMN 115,g_pmc081[1,34],
            COLUMN 151,sr.pmc53,
            COLUMN 256,YEAR(sr.apf02) USING '&&&&',
            COLUMN 260,MONTH(sr.apf02) USING '&&',
            COLUMN 262,DAY(sr.apf02) USING '&&',
            COLUMN 264,sr.f3 CLIPPED
      ELSE
         PRINT 'INV',l_inv[1,75]
      END IF
END REPORT
 
FUNCTION p900(l_apf01,l_name1)
   DEFINE l_name1   LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0055
          l_sql     LIKE type_file.chr1000,      # RDSQL STATEMENT  #No.FUN-690028 VARCHAR(900)
          l_za05    LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(40)
          l_apf01   LIKE apf_file.apf01,
#         l_order   ARRAY[5] OF VARCHAR(10),
          l_order   ARRAY[5] OF LIKE oea_file.oea01,      # No.FUN-690028 VARCHAR(16)  #No.FUN-550030
          sr1              RECORD apf01 LIKE apf_file.apf01, #付款單單頭檔
                                  apf02 LIKE apf_file.apf02,
                                  apf03 LIKE apf_file.apf03,
                                  apf04 LIKE apf_file.apf04,
                                  apf05 LIKE apf_file.apf05,
                                  apf06 LIKE apf_file.apf06,
                                  apf07 LIKE apf_file.apf07,
                                  apf08f LIKE apf_file.apf08f,
                                  apf09f LIKE apf_file.apf09f,
                                  apf10f LIKE apf_file.apf10f,
                                  apf08 LIKE apf_file.apf08,
                                  apf09 LIKE apf_file.apf09,
                                  apf10 LIKE apf_file.apf10,
                                  apf43 LIKE apf_file.apf43,
                                  apf44 LIKE apf_file.apf44,
                                  apf41 LIKE apf_file.apf41,
                                  apfmksg LIKE apf_file.apfmksg,
                                  apfprno LIKE apf_file.apfprno,
                                  apf12 LIKE apf_file.apf12,
                                  apg02 LIKE apg_file.apg02,
                                  apg03 LIKE apg_file.apg03,
                                  apg04 LIKE apg_file.apg04,
                                  apg05f LIKE apg_file.apg05f,
                                  apg05 LIKE apg_file.apg05
                        END RECORD
    #DEFINE    l_dbs_aap,l_dbs LIKE type_file.chr20       # No.FUN-690028 VARCHAR(20)   #FUN-A50102
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aapp900'
     LET g_len=90
     FOR g_i = 1 TO g_len
         LET g_dash[g_i,g_i] = '='
     END FOR
     LET l_sql = "SELECT ",
                 " apf01, apf02, apf03, apf04, apf05, apf06,",
                 " apf07, apf08f,apf09f,apf10f,",
                 " apf08, apf09, apf10, apf43, apf44,",
                 " apf41, apfmksg, apfprno, apf12,",
                 " apg02, apg03,  apg04, apg05f,apg05f   ",
                 " FROM apf_file, apg_file ",
                 " WHERE apf01 = apg01 ",
                 " AND apf01 ='",l_apf01 CLIPPED,"'",
                 " AND apf00 ='33' ",
                 " ORDER BY apf01 "
     PREPARE p900_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)  
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
     END IF
     DECLARE p900_curs1 CURSOR FOR p900_prepare1
 
     #-->列印付款單的貸方
   #FUN-A50102--mark--str--
   # SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = g_apz.apz04p
   # IF l_dbs IS NOT NULL AND l_dbs != ' '
   ##THEN LET l_dbs_aap = s_dbstring(l_dbs)   #TQC-940178 MARK
   # THEN LET l_dbs_aap = s_dbstring(l_dbs clipped)   #TQC-940178 ADD
   # ELSE LET l_dbs_aap = ' '
   # END IF
   #FUN-A50102--mark--end
     LET l_sql = " SELECT aph_file.*,nma02 ",
                #FUN-A50102--mod--str--
                #"   FROM aph_file LEFT OUTER JOIN ",l_dbs_aap clipped," nma_file ON aph_file.aph08 = nma_file.nma01 ",
                 "   FROM aph_file LEFT OUTER JOIN ",cl_get_target_table(g_apz.apz04p,'nma_file'),
                 "                      ON aph_file.aph08 = nma_file.nma01",
                #FUN-A50102--mod--end
                 " WHERE aph01 = ?  ",
                 "    AND aph03='Z' "
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #FUN-A50102
     CALL cl_parse_qry_sql(l_sql,g_apz.apz04p) RETURNING l_sql   #FUN-A50102
     PREPARE aph_prepare FROM l_sql
     DECLARE aph_curs CURSOR FOR aph_prepare
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('perpare aph_fiie error!',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
     START REPORT p900_rep TO l_name1  #report name='aapp9001.out'
     LET g_pageno = 0
     FOREACH p900_curs1 INTO sr1.*
       IF SQLCA.sqlcode != 0 THEN
       #No.FUN-710014--Begin--
       #  CALL cl_err('foreach:',SQLCA.sqlcode,1)
          CALL s_errmsg('','','foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       #No.FUN-710014--End--
       END IF
       OUTPUT TO REPORT p900_rep(sr1.*)
       LET g_apf01=sr1.apf01
     END FOREACH
 
     FINISH REPORT p900_rep
    #No.+366 010705 plum
#    LET l_cmd = "chmod 777 ", l_name1                   #No.FUN-9C0009
#    RUN l_cmd                                           #No.FUN-9C0009    
     IF os.Path.chrwx(l_name1 CLIPPED,511) THEN END IF   #No.FUN-9C0009  add by dxfwo
    #No.+366..end
END FUNCTION
 
REPORT p900_rep(sr1)
   DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          sr1              RECORD apf01 LIKE apf_file.apf01, #付款單單頭檔
                                  apf02 LIKE apf_file.apf02,
                                  apf03 LIKE apf_file.apf03,
                                  apf04 LIKE apf_file.apf04,
                                  apf05 LIKE apf_file.apf05,
                                  apf06 LIKE apf_file.apf06,
                                  apf07 LIKE apf_file.apf07,
                                  apf08f LIKE apf_file.apf08f,
                                  apf09f LIKE apf_file.apf09f,
                                  apf10f LIKE apf_file.apf10f,
                                  apf08 LIKE apf_file.apf08,
                                  apf09 LIKE apf_file.apf09,
                                  apf10 LIKE apf_file.apf10,
                                  apf43 LIKE apf_file.apf43,
                                  apf44 LIKE apf_file.apf44,
                                  apf41 LIKE apf_file.apf41,
                                  apfmksg LIKE apf_file.apfmksg,
                                  apfprno LIKE apf_file.apfprno,
                                  apf12 LIKE apf_file.apf12,
                                  apg02 LIKE apg_file.apg02,
                                  apg03 LIKE apg_file.apg03,
                                  apg04 LIKE apg_file.apg04,
                                  apg05f LIKE apg_file.apg05f,
                                  apg05 LIKE apg_file.apg05
                           END RECORD,
          sr12             RECORD apa02 LIKE apa_file.apa02,
                                  apa08 LIKE apa_file.apa08,
                                  apa09 LIKE apa_file.apa09,
                                  apa12 LIKE apa_file.apa12,
                                  apa13 LIKE apa_file.apa13,
                                  apa14 LIKE apa_file.apa14,
                                  apa24 LIKE apa_file.apa24,
                                  apa31 LIKE apa_file.apa31,
                                  apa32 LIKE apa_file.apa32,
                                  apa60 LIKE apa_file.apa60,
                                  apa61 LIKE apa_file.apa61,
                                  apb04 LIKE apb_file.apb04, #應付帳款單身檔
                                  apb06 LIKE apb_file.apb06,
                                  apb08 LIKE apb_file.apb08,
                                  apb09 LIKE apb_file.apb09,
                                  apb10 LIKE apb_file.apb10,
                                  apb13 LIKE apb_file.apb13,
                                  apb15 LIKE apb_file.apb15,
                                  apb14 LIKE apb_file.apb14,
                                 #rvb05 LIKE rvb_file.rvb05, #驗收單身檔      #TQC-990048 mark
                                  azi03 LIKE azi_file.azi03, #幣別檔
                                  azi04 LIKE azi_file.azi04,
                                  azi05 LIKE azi_file.azi05
                       END RECORD,
            sr2              RECORD
                                  aph01  LIKE aph_file.aph01,
                                  aph02  LIKE aph_file.aph02,
                                  aph03  LIKE aph_file.aph03,
                                  aph04  LIKE aph_file.aph04,
                                  aph05f LIKE aph_file.aph05f,
                                  aph05  LIKE aph_file.aph05,
                                  aph06  LIKE aph_file.aph06,
                                  aph07  LIKE aph_file.aph07,
                                  aph08  LIKE aph_file.aph08,
                                  aph09  LIKE aph_file.aph09,
                                  aph13  LIKE aph_file.aph13,
                                  aph14  LIKE aph_file.aph14,
                                  nma02  LIKE nma_file.nma02
                       END RECORD,
      l_sql         LIKE type_file.chr1000,     # No.FUN-690028 CHAR (600)
      l_cnt         LIKE type_file.num5,    #No.FUN-690028 SMALLINT
      l_pritem      LIKE type_file.num5,        # No.FUN-690028 SMALLINT
      l_miscnum     LIKE type_file.num5,        # No.FUN-690028 SMALLINT
      l_amt	    LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
      l_tot1,l_tot2,l_tot3,l_tot4,l_tot3f   LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
      l_apk03      LIKE apk_file.apk03,
      l_apk05      LIKE apk_file.apk05,
      l_apk06      LIKE apk_file.apk06,
      l_apk07      LIKE apk_file.apk07,
      l_apk08      LIKE apk_file.apk08,
      l_apd03      LIKE apd_file.apd03    #備註檔
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin  #FUN-580098
         PAGE LENGTH g_page_line
  ORDER BY sr1.apf01,sr1.apg02
 
  FORMAT
   PAGE HEADER
      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
      IF g_towhom IS NULL OR g_towhom = ' '
         THEN PRINT '';
         ELSE PRINT 'TO:',g_towhom;
      END IF
      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
      PRINT ' '
      LET g_pageno = g_pageno + 1
      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
            COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
      PRINT g_dash[1,g_len]
 
   BEFORE GROUP OF sr1.apf01    #付款單號
      IF PAGENO > 1 OR LINENO > 9
         THEN SKIP TO TOP OF PAGE
      END IF
      LET l_tot1 = 0 LET l_tot2 = 0 LET l_tot3 = 0 LET l_tot4=0 LET l_tot3f=0
      PRINT COLUMN 1,  g_x[11] CLIPPED , sr1.apf01,
            COLUMN 41, g_x[23] CLIPPED , sr1.apf44
      PRINT COLUMN 1,  g_x[14] CLIPPED , sr1.apf02,
            COLUMN 25, g_x[48] CLIPPED , sr1.apf06,
            COLUMN 41, g_x[13] CLIPPED , cl_numfor(sr1.apf08f,14,         3),
                                         cl_numfor(sr1.apf08 ,14,   g_azi04)    #No.CHI-6A0004 t_azi-->g_azi
      PRINT COLUMN 1,  g_x[17] CLIPPED , sr1.apf03,
            COLUMN 41, g_x[18] CLIPPED , cl_numfor(sr1.apf09f,14,         3),
                                         cl_numfor(sr1.apf09 ,14,   g_azi04)    #No.CHI-6A0004 t_azi-->g_azi    
      PRINT COLUMN 1,  g_x[21] CLIPPED , sr1.apf12,
            COLUMN 41, g_x[22] CLIPPED , cl_numfor(sr1.apf10f,14,         3),
                                         cl_numfor(sr1.apf10 ,14,   g_azi04)    #No.CHI-6A0004 t_azi-->g_azi 
      PRINT '-------------------------------------------',
            '------------------------------------------'
      PRINT COLUMN 01,g_x[24] CLIPPED, g_x[25] CLIPPED,COLUMN 59,g_x[57] CLIPPED
      PRINT COLUMN 1,'------ ------------ ------------ -------- ---- ---------- ------------ ------------'
      LET l_last_sw = 'n'
 
      #--->列印付款單貸方資料
      FOREACH  aph_curs USING sr1.apf01 INTO sr2.*
        IF SQLCA.sqlcode != 0 THEN
        #No.FUN-710014--Begin--
        #  CALL cl_err('foreach apf_file error !',SQLCA.sqlcode,1)
           CALL s_errmsg('','','foreach apf_file error !',SQLCA.sqlcode,1)
           LET g_totsuccess = 'N'
           EXIT FOREACH
        #No.FUN-710014--End--
        END IF
        IF cl_null(sr2.nma02) THEN LET sr2.nma02=' ' END IF
        PRINT COLUMN 3, sr2.aph03,
              COLUMN 8, sr2.aph04[1,12],' ',
              COLUMN 21,sr2.aph08,
              COLUMN 34,sr2.aph07,
              COLUMN 43,sr2.aph13,
              COLUMN 48,sr2.aph14 using '####&.&&&&',
              COLUMN 55,cl_numfor(sr2.aph05f,11,sr12.azi04) CLIPPED ,
              COLUMN 68,cl_numfor(sr2.aph05,11,sr12.azi04) CLIPPED
        LET l_tot1 = l_tot1 + sr2.aph05
        LET l_tot4 = l_tot4 + sr2.aph05
      END FOREACH
 
      #--->付款單借方資料表頭
      PRINT COLUMN 49,g_x[43] CLIPPED,
            COLUMN 55,cl_numfor(l_tot1,11,sr12.azi04) CLIPPED,
            COLUMN 68,cl_numfor(l_tot4,11,sr12.azi04) CLIPPED
      PRINT '----------------------------------------',
            '-------------------------------------------'
      PRINT g_x[26] CLIPPED,4 SPACES,g_x[27] CLIPPED,g_x[28] CLIPPED
      PRINT "-- ---------- -------------- ---------- ----------- ----------- ----------- -----------"
 
   BEFORE GROUP OF sr1.apg02                  #借方項次
 
     LET l_sql=" SELECT apk03,apk05,apk06,apk07,apk08 ",
               " FROM  apk_file WHERE apk01 =  ? "
     PREPARE p900_premisc FROM l_sql
     DECLARE p900_misc CURSOR FOR p900_premisc
     #-->各廠的請款資料讀取
    #FUN-A50102--mark--str--
    #LET g_plant_new = sr1.apg03
    #CALL s_getdbs()
    #LET g_dbs_new=g_dbs_new
    #FUN-A50102--mark--end
 
     LET l_sql = " SELECT apa02, apa08, apa09, apa12, apa13,apa14,apa24,",
                 " apa31, apa32, apa60, apa61,",
                 " apb04, apb06, apb08, apb09, apb10, apb13, apb15, apb14,",
                #TQC-990048---modify---start---
                #" rvb05, azi03, azi04, azi05 ",
                 " azi03, azi04, azi05 ",
#FUN-A50102--mod--str--------
#                " FROM  ",g_dbs_new CLIPPED," apa_file,OUTER ",
#                          g_dbs_new CLIPPED," apb_file,",
#               #" OUTER ",g_dbs_new CLIPPED," rvb_file),",
#               #TQC-990048---modify---end---
#                " OUTER ",g_dbs_new CLIPPED," azi_file ",
                 " FROM  ",cl_get_target_table(sr1.apg03,'apa_file'),
                 "      LEFT OUTER JOIN ",cl_get_target_table(sr1.apg03,'apb_file'),
                 "           ON apa01 = apb01 ",
                 "      LEFT OUTER JOIN ",cl_get_target_table(sr1.apg03,'azi_file'),      
                 "           ON apa13 = azi01 ",
#FUN-A50102--mod--end
                 " WHERE apa01 = '",sr1.apg04,"' AND apa41='Y' AND apa42='N' " 
#wujie 091019 --begin mark
#                "   AND apa01 = '",sr1.apg04,"' AND apa41='Y' ",
#                "   AND apa42='N'",
#wujie 091019 --begin end 
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,sr1.apg03) RETURNING l_sql   #FUN-A50102
     PREPARE p900_ppay FROM l_sql
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('prepare:',SQLCA.sqlcode,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time 
          EXIT PROGRAM
       END IF
     LET l_pritem = 1
     DECLARE p900_cpay CURSOR FOR p900_ppay
     FOREACH p900_cpay INTO sr12.*
        IF SQLCA.sqlcode THEN
        #No.FUN-710014--Begin--
        #  CALL cl_err('foreac p900_cpay',SQLCA.sqlcode,0)
           CALL s_errmsg('','','foreac p900_cpay',SQLCA.sqlcode,0)
        #No.FUN-710014--End--
           EXIT FOREACH
        END IF
         LET l_amt = sr12.apa31 + sr12.apa32 - sr12.apa60 - sr12.apa61
         IF l_pritem = 1 THEN
            IF sr12.apa08 = 'MISC' THEN
               LET l_miscnum = 1
               FOREACH p900_misc USING sr1.apg04
                                 INTO l_apk03,l_apk05,l_apk06,l_apk07,l_apk08
                  IF SQLCA.sqlcode THEN
                  #No.FUN-710014--Begin--
                  #  CALL cl_err('misc invoice',SQLCA.sqlcode,0)
                     CALL s_errmsg('','','misc invoice',SQLCA.sqlcode,0)
                  #No.FUN-710014--End--
                     EXIT FOREACH
                  END IF
                  IF l_miscnum = 1 THEN
                      PRINT COLUMN 1,sr1.apg02 USING '##',       #借方項次
                            COLUMN 4,sr1.apg04;                      #帳款編號
                  ELSE
                      PRINT
                  END IF
                  PRINT COLUMN 15,l_apk03,                         #發票號碼
                        #COLUMN 30,l_apk05 USING 'YY/MM/DD' , #發票日期#FUN-570250 mark
                        COLUMN 30,l_apk05,     #發票日期 #FUN-570250 add
                        COLUMN 41,l_apk08 USING '###,###,##&',
                        COLUMN 53,l_apk07 USING '###,###,##&',
                        COLUMN 65,l_apk06 USING '###,###,##&';
                  let l_miscnum = l_miscnum + 1
               END FOREACH
               IF l_miscnum = 1 THEN                        #未讀到 apk_file
                  PRINT COLUMN 01,sr1.apg02 USING '##',    #借方項次
                        COLUMN 04,sr1.apg04,                  #帳款編號
                        COLUMN 15,sr12.apa08,              #發票號碼
                        #COLUMN 30,sr12.apa09 USING 'YY/MM/DD' , #發票日期#FUN-570250 mark
                        COLUMN 30,sr12.apa09, #發票日期#FUN-570250 add
                        COLUMN 41,sr12.apa31 USING '###,###,##&',#未稅
                        COLUMN 53,sr12.apa32 USING '###,###,##&',#稅
                        COLUMN 65,(sr12.apa31+sr12.apa32) USING '###,###,##&'; #合計
	       END IF
               PRINT COLUMN 77,sr1.apg05 USING '###,###,##&'          #沖帳金額
            ELSE
               PRINT COLUMN 01,sr1.apg02 USING '##',    #借方項次
                     COLUMN 04, sr1.apg04,               #帳款編號
                     COLUMN 15,sr12.apa08,              #發票號碼
                     #COLUMN 30,sr12.apa09 USING 'YY/MM/DD' , #發票日期#FUN-570250 mark
                     COLUMN 30,sr12.apa09, #發票日期#FUN-570250 add
                     COLUMN 41,sr12.apa31 USING '###,###,##&',#未稅
                     COLUMN 53,sr12.apa32 USING '###,###,##&',#稅
                     COLUMN 65,(sr12.apa31+sr12.apa32) USING '###,###,##&', #合計
                     COLUMN 77,sr1.apg05 USING '###,###,##&'          #沖帳金額
            END IF
            LET l_tot3f = l_tot3f + (sr12.apa31+sr12.apa32)   #canny(980725)
            LET l_tot3  = l_tot3  + sr1.apg05
         END IF
         #-->已開立折讓資料
          IF sr12.apa60 > 0 AND l_pritem = 1 THEN
             LET sr12.apa60 = sr12.apa60 * -1
             LET sr12.apa61 = sr12.apa61 * -1
             PRINT COLUMN 27,g_x[44] CLIPPED, COLUMN 38,
                   cl_numfor(sr12.apa60,12,sr12.azi04),
                   cl_numfor(sr12.apa61,11,sr12.azi04)
          END IF
          LET l_pritem = l_pritem + 1
     END FOREACH
 
   AFTER GROUP OF sr1.apf01
      #-->合計資料列印
      PRINT COLUMN 40, g_x[43] CLIPPED,
            COLUMN 65,cl_numfor(l_tot3f   ,10,   g_azi04) CLIPPED,  #No.CHI-6A0004 t_azi-->g_azi 
            COLUMN 75,cl_numfor(l_tot3    ,11,   g_azi04) CLIPPED  #canny(980725)  #No.CHI-6A0004 t_azi-->g_azi 
      LET l_last_sw = 'y'
      LET g_pageno = 0
 
     ON LAST ROW
      IF l_last_sw = 'n'
         THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      END IF
      LET l_last_sw = 'n'
      PRINT g_dash[1,g_len]
      PRINT g_x[33],g_x[34]
END REPORT
#Patch....NO.TQC-610035 <001,002,003,004> #
