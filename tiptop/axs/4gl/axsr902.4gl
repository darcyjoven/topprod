# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: axsr902.4gl
# Descriptions...: 售價分析表
# Date & Author..: 99/12/20 By Snow
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02,ima021
# Modify.........: No.FUN-580013 05/08/15 By vivien 報表轉XML格式
# Modify.........: NO.FUN-570250 05/12/23 By Rosayu 將日期取消寫死YY/MM/DD
# Modify.........: No.TQC-630166 06/03/16 By 整批修改，將g_wc[1,70]改為g_wc.subString(1,......)寫法
# Modify.........: No.TQC-610090 06/02/06 By Pengu Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-660155 06/06/22 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680130 06/08/31 By Xufeng 字段類型定義改為LIKE     
# Modify.........: No.CHI-6A0004 06/10/23 By hongmei g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0095 06/10/26 By xumin l_time轉g_time
# Modify.........: No.MOD-950210 09/05/26 By Pengu “寄銷出貨”不應納入 “銷貨收入”
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80059 11/08/03 By minpp 程序撰寫規範修改
# Modify.........: No.FUN-BB0047 11/11/15 By fengrui  調整時間函數重複關閉問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                              # Print condition RECORD
             #wc       LIKE type_file.chr1000,    # Where condition  #No.FUN-680130 VARCHAR(500)
	      wc       STRING,                    # TQC-630166
              bdate    LIKE type_file.dat,        # 出貨期間-起  #No.FUN-680130 DATE
              edate    LIKE type_file.dat         # 出貨期間-訖  #No.FUN-680130 DATE
              END RECORD
DEFINE   g_i           LIKE type_file.num5        #count/index for any purpose   #No.FUN-680130 SMALLINT
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXS")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-B80059    ADD

   LET g_pdate = ARG_VAL(1)         # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc     = ARG_VAL(7)         #No.TQC-610090 add
   LET tm.bdate  = ARG_VAL(8)
   LET tm.edate  = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL r902_tm(0,0)        # Input print condition
      ELSE CALL r902()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
END MAIN
 
#--------------------------r902_tm()-----------------------------------
FUNCTION r902_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01          #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680130 SMALLINT
          l_cmd       LIKE type_file.chr1000       #No.FUN-680130 VARCHAR(1000)
 
   LET p_row = 5 LET p_col = 6
   OPEN WINDOW r902_w AT p_row,p_col
        WITH FORM "axs/42f/axsr902"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ogb04,oga03,ogb09,ogb091,ogb092,oga25,ima57,
                              ima08,ima06,ima09,ima10,ima11,ima12
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r902_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
      EXIT PROGRAM
   END IF
 
   INPUT BY NAME tm.bdate,tm.edate WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD bdate
         IF cl_null(tm.bdate) THEN
            NEXT FIELD bdate
         END IF
         #IF cl_null(tm.bdate) OR
         #
         #   ((NOT cl_null(tm.bdate)) AND
         #   (NOT cl_null(tm.edate)) AND
         #   (tm.bdate>tm.edate)) THEN
         #   NEXT FIELD bdate
         #END IF
      AFTER FIELD edate
         IF cl_null(tm.edate) OR
            ((NOT cl_null(tm.bdate)) AND
            (NOT cl_null(tm.edate)) AND
            (tm.bdate>tm.edate)) THEN
            NEXT FIELD edate
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
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
      LET INT_FLAG = 0 CLOSE WINDOW r902_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axsr902'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axsr902','9031',1)   
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
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('axsr902',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r902_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r902()
   ERROR ""
END WHILE
   CLOSE WINDOW r902_w
END FUNCTION
#------------------------------FUNCTION r902()-------------------------------
FUNCTION r902()
   DEFINE l_name    LIKE type_file.chr20,              # External(Disk) file name      #No.FUN-680130 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0095
          l_sql     LIKE type_file.chr1000,            # RDSQL STATEMENT               #No.FUN-680130 VARCHAR(1000)
          l_za05    LIKE type_file.chr1000,            #No.FUN-680130 VARCHAR(40)
          l_order   ARRAY[2] OF LIKE oeb_file.oeb04,   #No.FUN-680130 VARCHAR(20) 
          l_index   LIKE type_file.num5,               #No.FUN-680130 SMALLINT
          sr        RECORD
                        fno     LIKE type_file.num5,   #流水號   #No.FUN-680130 SMALLINT
                        ima02   LIKE ima_file.ima02,   #品名
                        ima021  LIKE ima_file.ima021,  #規格
                        ogb04   LIKE ogb_file.ogb04,   #貨號
                        ogb05   LIKE ogb_file.ogb05,   #單位
                        d1      LIKE oga_file.oga02,   #上期日期
                        d2      LIKE ogb_file.ogb14,   #上期售價
                        d3      LIKE oga_file.oga02,   #最後日期
                        d4      LIKE ogb_file.ogb14,   #最後售價
                        ogb12   LIKE ogb_file.ogb12,   #本期總量
                        money   LIKE ogb_file.ogb14,   #本期總金額
                        bal     LIKE ogb_file.ogb14    #平均售價
                    END RECORD
     #No.FUN-BB0047--mark--Begin---
     #  CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
     #No.FUN-BB0047--mark--End-----
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#-------- #No.CHI-6A0004 Begin----------  
     #幣別小數位的讀取#
#    SELECT azi03,azi04,azi05
#    INTO g_azi03,g_azi04,g_azi05
#    FROM azi_file
#    WHERE azi01=g_aza.aza17
#-------- #No.CHI-6A0004 End--------- 
#----------------------------------l_sql-------------------------------
 #只先select料
      LET l_sql ="SELECT '',ima02,ima021,ogb04,ogb05,'','','','', ",
                 " sum(ogb12),sum(ogb14*oga24), ",
                 " ''",
                 #" sum(ogb12)/sum(ogb14*oga24) ",
                 " FROM oga_file,ogb_file,ima_file ",
                 " WHERE oga01=ogb01 AND ogb04=ima01 ",
                #------------No.MOD-950210 modify
                #" AND oga00 <> '3' ",   #出至境外倉
                 " AND oga00 NOT IN ('A','3','7') ",   #出至境外倉
                #------------No.MOD-950210 end
                 " AND ogapost='Y' AND ogaconf ='Y' ",
                 " AND (oga02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"') ",
                 " AND ",tm.wc CLIPPED,
                 " GROUP BY ogb04,ima02,ima021,ogb05 ",
                 " ORDER BY ogb04,ogb05"
 
     PREPARE r902_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
          #CALL cl_err('prepare:',SQLCA.sqlcode,1) EXIT PROGRAM 
          CALL cl_err('prepare:',SQLCA.sqlcode,1) RETURN  
     END IF
     DECLARE r902_curs1 CURSOR FOR r902_prepare1
     CALL cl_outnam('axsr902') RETURNING l_name
     #------------------START REPORT--------------------------
     START REPORT r902_rep TO l_name
     LET g_pageno = 0
 
     LET l_index=0
     FOREACH r902_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       #------------------------------------------------
       #計算平均售價
       IF (sr.ogb12=0) OR (sr.money=0) THEN
          LET sr.bal=0
       ELSE
          LET sr.bal=sr.money/sr.ogb12
       END IF
 
       #取得『上期日期』& 『上期售價』
       CALL r902_get1(sr.ogb04) RETURNING sr.d1,sr.d2
 
       #取得『最後日期』& 『最後售價』
       CALL r902_get2(sr.ogb04) RETURNING sr.d3,sr.d4
 
       #計算流水號
       LET l_index=l_index+1
       LET sr.fno=l_index
 
 
       OUTPUT TO REPORT r902_rep(sr.*)
     END FOREACH
     FINISH REPORT r902_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #No.FUN-BB0047--mark--Begin---
     #  CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
     #No.FUN-BB0047--mark--End-----
END FUNCTION
#----------------------------REPORT r902_rep()----------------------------------
REPORT r902_rep(sr)
   DEFINE l_last_sw  LIKE type_file.chr1,              #No.FUN-680130 VARCHAR(1)
          l_chr      LIKE type_file.chr1,              #No.FUN-680130 VARCHAR(1)
          l_p1       LIKE ogb_file.ogb13,              #本期總量本頁小計
          l_p2       LIKE ogb_file.ogb13,              #本期總金額本頁小計
          l_a1       LIKE ogb_file.ogb13,              #本期總量總計
          l_a2       LIKE ogb_file.ogb13,              #本期總金額總計
 
          sr        RECORD
                        fno     LIKE type_file.num5,   #流水號  #No.FUN-680130 SMALLINT
                        ima02   LIKE ima_file.ima02,   #品名
                        ima021  LIKE ima_file.ima021,  #規格
                        ogb04   LIKE ogb_file.ogb04,   #貨號
                        ogb05   LIKE ogb_file.ogb05,   #單位
                        d1      LIKE oga_file.oga02,   #上期日期
                        d2      LIKE ogb_file.ogb14,   #上期售價
                        d3      LIKE oga_file.oga02,   #最後日期
                        d4      LIKE ogb_file.ogb14,   #最後售價
                        ogb12   LIKE ogb_file.ogb12,   #本期總量
                        money   LIKE ogb_file.ogb14,   #本期總金額
                        bal     LIKE ogb_file.ogb14    #平均售價
                    END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.ogb04
#----------------------------PAGE HEADER-----------------------------
  FORMAT
   PAGE HEADER
#No.FUN-580013  --begin
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
 
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT g_dash[1,g_len]
      PRINTX name=H1
            g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
            g_x[41]
      PRINTX name=H2
            g_x[42],g_x[43],g_x[44]
      PRINT g_dash1
      LET l_last_sw = 'n'                #FUN-550127
      LET l_p1=0
      LET l_p2=0
#No.FUN-580013  --end
 
   ON EVERY ROW
#No.FUN-580013  --begin
         PRINTX name=D1
               COLUMN g_c[31],  sr.fno USING '###' CLIPPED,        #流水號
               COLUMN g_c[32],  sr.ogb04[1,15] CLIPPED,            #貨號
                COLUMN g_c[33], sr.ima02 CLIPPED,                  #品名  #MOD-4A0238
               COLUMN g_c[34], sr.ogb05 CLIPPED,                  #單位
               #COLUMN g_c[35], sr.d1 USING 'yy/mm/dd' CLIPPED,    #上期日期#FUN-570250 mark
               COLUMN g_c[35], sr.d1,    #上期日期#FUN-570250 add
               COLUMN g_c[36], cl_numfor(sr.d2,36,g_azi03) CLIPPED, #上期售價
               COLUMN g_c[37], cl_numfor(sr.ogb12,37,g_azi03) CLIPPED; #本期總量
               LET l_p1=l_p1+sr.ogb12
         PRINTX name=D1
               COLUMN g_c[38], cl_numfor(sr.money,38,g_azi04) CLIPPED; #本期總金額
               LET l_p2=l_p2+sr.money
         PRINTX name=D1
               COLUMN g_c[39], cl_numfor(sr.bal,39,g_azi03) CLIPPED, #平均售價
               #COLUMN g_c[40], sr.d3 USING 'yy/mm/dd' CLIPPED,    #最後日期#FUN-570250 mark
               COLUMN g_c[40], sr.d3,    #最後日期#FUN-570250 add
               COLUMN g_c[41], cl_numfor(sr.d4,41,g_azi03) CLIPPED    #最後售價
         PRINTX name=D2
                COLUMN g_c[44], sr.ima021 CLIPPED                 #規格  #MOD-4A0238
#No.FUN-580013  --end
 
       #五筆印一條線
       IF (sr.fno MOD 5)=0 THEN
          PRINT g_dash2[1,g_len]
       END IF
 
   ON LAST ROW
      #總計
      PRINT g_dash2[1,g_len]
      LET l_a1=sum(sr.ogb12)
      LET l_a2=sum(sr.money)
      #本頁小計
#No.FUN-580013  --start
      PRINTX name=S1
            COLUMN g_c[33],g_x[23] CLIPPED,
            COLUMN g_c[37], cl_numfor(l_p1,37,g_azi05), #本期總量
            COLUMN g_c[38], cl_numfor(l_p2,38,g_azi05) #本期總金額
#No.FUN-580013  --end
#No.FUN-580013  --start
      PRINTX name=S1
            COLUMN g_c[33],g_x[22] CLIPPED,
            COLUMN g_c[37], cl_numfor(l_a1,37,g_azi05), #本期總量
            COLUMN g_c[38], cl_numfor(l_a2,38,g_azi05) CLIPPED #本期總金額
#No.FUN-580013  --end
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280 / (132)-120,240,300
       CALL cl_wcchp(tm.wc,'ogb04,oga03,ogb09,ogb091,ogb092,oga25,ima57,ima08,ima06,ima09,ima10,ima11,ima12') RETURNING tm.wc
       # CALL cl_wcchp(tm.wc,'sfb01,sfb131,sfb06,sfb133,sfb134') RETURNING tm.wc
         PRINT g_dash2[1,g_len]
	#TQC-630166
        #      IF tm.wc[001,120] > ' ' THEN            # for 132
        # PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
        #      IF tm.wc[121,240] > ' ' THEN
        # PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
        #      IF tm.wc[241,300] > ' ' THEN
        # PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
          CALL cl_prt_pos_wc(tm.wc)
        #END TQC-630166
      END IF
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'  THEN
      #本頁小計
#No.FUN-580013  --start
      PRINTX name=S1
            COLUMN g_c[33],g_x[23] CLIPPED,
            COLUMN g_c[37], cl_numfor(l_p1,37,g_azi05), #本期總量
            COLUMN g_c[38], cl_numfor(l_p2,38,g_azi05) #本期總金額
#No.FUN-580013  --end
      PRINT g_dash[1,g_len]
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 3 LINE
      END IF
 
      LET l_p1=0
      LET l_p2=0
 
END REPORT
#--------------------------FUNCTION r902_get1()---------------------
#INPUT :料號
#OUTPUT:上期日期 & 上期售價
FUNCTION r902_get1(p_ogb04)
   DEFINE P_ogb04 LIKE ogb_file.ogb04,           #料號
          l_date  LIKE oga_file.oga02,           #日期
          l_price LIKE ogb_file.ogb14,           #售價
          fr RECORD  oga02  LIKE oga_file.oga02, #日期
                     oga01  LIKE oga_file.oga01, #出貨單號
                     ogb03  LIKE ogb_file.ogb03  #項次
             END RECORD,
          l_sql   LIKE type_file.chr1000         #No.FUN-680130 VARCHAR(1000)
 
   #以料號取出日期範圍之前，所有符合的出貨單、項次
   #對日期、出貨單、項次做GROUP BY
   #再對日期、出貨單、項次做ORDER BY(由大到小)
   #則第一筆為所需的資料
   LET l_sql= "SELECT oga02,oga01,ogb03 ",
             " FROM oga_file,ogb_file,ima_file ",
             " WHERE oga01=ogb01 AND ogb04='",p_ogb04,"'" ,
             " AND ogb04=ima01 ",
             " AND ogapost='Y' AND ogaconf='Y' ",
             " AND oga02<'",tm.bdate,"' ",
             " AND ", tm.wc CLIPPED,
             " GROUP BY oga02,oga01,ogb03 ",
             " ORDER BY oga02 DESC,oga01 DESC,ogb03 DESC "
 
   PREPARE r902_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) RETURN
     END IF
   DECLARE r902_curs2 SCROLL CURSOR FOR r902_prepare2
   OPEN r902_curs2
   FETCH FIRST r902_curs2 INTO fr.*
   #沒有符合的資料
   IF status=NOTFOUND THEN
      LET l_date=''
      LET l_price=''
      CLOSE r902_curs2
      RETURN l_date,l_price
   ELSE
      #以FETCH出的日期、出貨單、項次計算其上期售價
      SELECT ogb13*oga24 INTO l_price
      FROM oga_file,ogb_file
      WHERE oga01=ogb01
           AND oga02=fr.oga02
           AND oga01=fr.oga01
           AND ogb03=fr.ogb03
      IF SQLCA.sqlcode THEN
#        CALL cl_err('SELECT:',SQLCA.sqlcode,1)   #No.FUN-660155
         CALL cl_err3("sel","oga_file,ogb_file",fr.oga01,fr.oga02,SQLCA.sqlcode,"","SELECT:",1)   #No.FUN-660155
      END IF
      LET l_date=fr.oga02
   END IF
   CLOSE r902_curs2
   RETURN l_date,l_price
END FUNCTION
#--------------------------FUNCTION r902_get2()---------------------
#INPUT :料號
#OUTPUT:最後日期 & 最後售價
FUNCTION r902_get2(p_ogb04)
   DEFINE P_ogb04 LIKE ogb_file.ogb04,           #料號
          l_date  LIKE oga_file.oga02,           #日期
          l_price LIKE ogb_file.ogb14,           #售價
          fr RECORD  oga02  LIKE oga_file.oga02, #日期
                     oga01  LIKE oga_file.oga01, #出貨單號
                     ogb03  LIKE ogb_file.ogb03  #項次
             END RECORD,
          l_sql   LIKE type_file.chr1000         #No.FUN-680130 VARCHAR(1000)
 
   #以料號取出日期範圍之內，所有符合的出貨單、項次
   #對日期、出貨單、項次做GROUP BY
   #再對日期、出貨單、項次做ORDER BY(由大到小)
   #則第一筆為所需的資料
   LET l_sql= "SELECT oga02,oga01,ogb03 ",
             " FROM oga_file,ogb_file,ima_file ",
             " WHERE oga01=ogb01 AND ogb04='",p_ogb04,"'" ,
             " AND ogb04=ima01 ",
             " AND ogapost='Y' AND ogaconf='Y' ",
             " AND (oga02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"') ",
             " AND ", tm.wc CLIPPED,
             " GROUP BY oga02,oga01,ogb03 ",
             " ORDER BY oga02 DESC,oga01 DESC,ogb03 DESC "
 
   PREPARE r902_prepare3 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) RETURN
     END IF
   DECLARE r902_curs3 SCROLL CURSOR FOR r902_prepare3
   OPEN r902_curs3
   FETCH FIRST r902_curs3 INTO fr.*
   #沒有符合的資料
   IF status=NOTFOUND THEN
      LET l_date=''
      LET l_price=''
      CLOSE r902_curs3
      RETURN l_date,l_price
   ELSE
      #以FETCH出的日期、出貨單、項次計算其最後售價
      SELECT ogb13*oga24 INTO l_price
      FROM oga_file,ogb_file
      WHERE oga01=ogb01
           AND oga02=fr.oga02
           AND oga01=fr.oga01
           AND ogb03=fr.ogb03
      IF SQLCA.sqlcode THEN
#        CALL cl_err('SELECT:',SQLCA.sqlcode,1)   #No.FUN-660155
         CALL cl_err3("sel","oga_file,ogb_file",fr.oga01,fr.oga02,SQLCA.sqlcode,"","SELECT:",1)   #No.FUN-660155
      END IF
      LET l_date=fr.oga02
   END IF
   CLOSE r902_curs3
   RETURN l_date,l_price
END FUNCTION
#Patch....NO.TQC-610037 <> #
