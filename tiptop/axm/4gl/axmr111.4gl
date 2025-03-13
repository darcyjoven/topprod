# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmr111.4gl
# Descriptions...: 產品分類價格表
# Date & Author..: 95/01/23 By Danny
# Modify.........: No.FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: No.FUN-550091 05/05/25 By Smapmin 新增地區欄位
# Modify.........: No.FUN-570184 05/08/08 By Sarah 增加欄位開窗功能
# Modify.........: No.MOD-580212 05/09/08 By ice  修改報表列印格式
# Modify.........: No.FUN-680137 06/09/05 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/23 By hongmei g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.TQC-6A0091 06/11/07 By ice 修正報表格式錯誤
# Modify.........: No.FUN-740023 07/04/11 By Sarah cl_prt_cs1()參數增加為四個
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
             # wc      VARCHAR(500),    # Where condition
              wc      STRING,    #TQC-630166  # Where condition
              more    LIKE type_file.chr1           #No.FUN-680137 VARCHAR(1)       # Input more condition(Y/N)
              END RECORD 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose    #No.FUN-680137 SMALLINT
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL axmr111_tm(0,0)        # Input print condition
      ELSE CALL axmr111()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION axmr111_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680137 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 7 LET p_col = 16
 
   OPEN WINDOW axmr111_w AT p_row,p_col WITH FORM "axm/42f/axmr111" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   #CONSTRUCT BY NAME tm.wc ON obg01,obg04,obg03,obg05,obg07,obg08,   #FUN-550091
   CONSTRUCT BY NAME tm.wc ON obg01,obg04,obg03,obg05,obg22,obg07,obg08,   #FUN-550091
                              obg09,obg10 
 
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
 
#start FUN-570184
     ON ACTION CONTROLP
        CASE
           WHEN INFIELD(obg01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_oba"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO obg01
              NEXT FIELD obg01
          WHEN INFIELD(obg04)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_oab"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO obg04
             NEXT FIELD obg04
          WHEN INFIELD(obg03)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_gfe"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO obg03
             NEXT FIELD obg03
          WHEN INFIELD(obg05)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_oah"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO obg05
             NEXT FIELD obg05
          WHEN INFIELD(obg07)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_geb"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO obg07
             NEXT FIELD obg07
          WHEN INFIELD(obg08)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_gea"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO obg08
             NEXT FIELD obg08
          WHEN INFIELD(obg09)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_azi"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO obg09
             NEXT FIELD obg09
          WHEN INFIELD(obg10)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_gec"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO obg10
             NEXT FIELD obg10
          WHEN INFIELD(obg22)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_geo"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO obg22
             NEXT FIELD obg22
        END CASE
#end FUN-570184
 
     ON ACTION exit
        LET INT_FLAG = 1
        EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
  END CONSTRUCT
  LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('obguser', 'obggrup') #FUN-980030
  IF g_action_choice = "locale" THEN
     LET g_action_choice = ""
     CALL cl_dynamic_locale()
     CONTINUE WHILE
  END IF
 
  IF INT_FLAG THEN
     LET INT_FLAG = 0 CLOSE WINDOW axmr111_w 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
     EXIT PROGRAM
        
  END IF
  IF tm.wc = ' 1=1' THEN 
     CALL cl_err('','9046',0) CONTINUE WHILE
  END IF
  #UI
  INPUT BY NAME tm.more WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
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
     LET INT_FLAG = 0 CLOSE WINDOW axmr111_w 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
     EXIT PROGRAM
        
  END IF
  IF g_bgjob = 'Y' THEN
     SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
            WHERE zz01='axmr111'
     IF SQLCA.sqlcode OR l_cmd IS NULL THEN
        CALL cl_err('axmr111','9031',1)
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
                        " '",tm.wc CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
        CALL cl_cmdat('axmr111',g_time,l_cmd)    # Execute cmd at later time
     END IF
     CLOSE WINDOW axmr111_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
     EXIT PROGRAM
  END IF
  CALL cl_wait()
  CALL axmr111()
  ERROR ""
END WHILE
   CLOSE WINDOW axmr111_w
END FUNCTION
 
FUNCTION axmr111()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                 #No.FUN-680137 VARCHAR(1000)
          l_chr        LIKE type_file.chr1,       #No.FUN-680137 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          l_order    ARRAY[5] OF LIKE type_file.chr20,         #No.FUN-680137  VARCHAR(20)
          sr               RECORD obg01  LIKE obg_file.obg01,  
                                  oba02  LIKE oba_file.oba02,  
                                  obg02  LIKE obg_file.obg02,  
                                  obg03  LIKE obg_file.obg03,  
                                  obg04  LIKE obg_file.obg04,  
                                  obg09  LIKE obg_file.obg09,
                                  obg10  LIKE obg_file.obg10,
                                  obg21  LIKE obg_file.obg21,  
                                  ima02  LIKE ima_file.ima02,
                                  ima021 LIKE ima_file.ima021
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
  #   SELECT azi03,azi04,azi05             #No.CHI-6A0004
  #    INTO g_azi03,g_azi04,g_azi05        #幣別檔小數位數讀取  #No.CHI-6A0004
  #    FROM azi_file                       #No.CHI-6A0004
  #   WHERE azi01=g_aza.aza17              #No.CHI-6A0004
   
     LET l_sql = "SELECT obg01,oba02,obg02,obg03,obg04,obg09,obg10,obg21,ima02,ima021 ",
" FROM obg_file LEFT OUTER JOIN oba_file ON obg_file.obg01 = oba_file.oba01 LEFT OUTER JOIN ima_file ON obg_file.obg02 = ima_file.ima01 WHERE ",tm.wc,
                 " ORDER BY obg01 "
 
   #str FUN-740023 modify
     CALL cl_prt_cs1('axmr111','axmr111',l_sql,'')
    ### *** 與 Crystal Reports 串聯段 2001/07/17 *** ##
    #IF g_aza.aza24 = 'Y' THEN
    #   CASE g_lang
    #     WHEN '0'
    #          IF cl_prt_cs1('axmr111_c',l_sql,g_x[1])='0' THEN RETURN END IF
    #     WHEN '2'
    #          IF cl_prt_cs1('axmr111_c',l_sql,g_x[1])='0' THEN RETURN END IF
    #     OTHERWISE
    #          IF cl_prt_cs1('axmr111_e',l_sql,g_x[1])='0' THEN RETURN END IF
    #   END CASE
    #END IF
    ### ******************************************** ##
 
    #PREPARE axmr111_prepare1 FROM l_sql
    #IF SQLCA.sqlcode != 0 THEN
    #   CALL cl_err('prepare:',SQLCA.sqlcode,1) 
    #   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
    #   EXIT PROGRAM 
    #      
    #END IF
    #DECLARE axmr111_curs1 CURSOR FOR axmr111_prepare1
 
    #CALL cl_outnam('axmr111') RETURNING l_name
    #START REPORT axmr111_rep TO l_name
 
    #LET g_pageno = 0
    #FOREACH axmr111_curs1 INTO sr.*
    #  IF SQLCA.sqlcode != 0 THEN 
    #     CALL cl_err('foreach:',SQLCA.sqlcode,1)
    #     EXIT FOREACH 
    #  END IF
    #  OUTPUT TO REPORT axmr111_rep(sr.*)
    #END FOREACH
 
    #FINISH REPORT axmr111_rep
 
    #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   #end FUN-740023 modify
END FUNCTION
 
REPORT axmr111_rep(sr)
   DEFINE l_last_sw   LIKE type_file.chr1,      #No.FUN-680137  VARCHAR(1)
          sr               RECORD obg01  LIKE obg_file.obg01,  
                                  oba02  LIKE oba_file.oba02,  
                                  obg02  LIKE obg_file.obg02,  
                                  obg03  LIKE obg_file.obg03,  
                                  obg04  LIKE obg_file.obg04,  
                                  obg09  LIKE obg_file.obg09,
                                  obg10  LIKE obg_file.obg10,
                                  obg21  LIKE obg_file.obg21, 
                                  ima02  LIKE ima_file.ima02,
                                  ima021 LIKE ima_file.ima021
                        END RECORD,
      l_chr        LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.obg01,sr.obg02
#FUN-4C0096 modify
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED   #No.TQC-6A0091
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED, pageno_total
 
      PRINT ''
 
      PRINT g_dash[1,g_len]
      PRINT g_x[31], 
            g_x[32],
            g_x[33],
            g_x[34],
            g_x[35],
            g_x[36],
            g_x[37],
            g_x[38],
            g_x[39] 
      PRINT g_dash1                                
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.obg01
      PRINT COLUMN g_c[31],sr.obg01,
            COLUMN g_c[32],sr.oba02
 
   ON EVERY ROW
      #no.4560 依幣別取位
      SELECT azi03 INTO t_azi03 FROM azi_file
       WHERE azi01 = sr.obg09
      PRINT COLUMN g_c[33],sr.obg02,
            COLUMN g_c[34],sr.ima02,
            COLUMN g_c[35],sr.ima021,
            COLUMN g_c[36],sr.obg03,
            COLUMN g_c[37],sr.obg04,
            COLUMN g_c[38],sr.obg10,
            COLUMN g_c[39],cl_numfor(sr.obg21,39,t_azi03)
 
   ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'obg01,obg131,obg06,obg03,obg134') RETURNING tm.wc
         PRINT g_dash[1,g_len]
       #       IF tm.wc[001,120] > ' ' THEN            # for 132
       #  PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
       #      IF tm.wc[121,240] > ' ' THEN
       #  PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
       #      IF tm.wc[241,300] > ' ' THEN
       #  PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
	#TQC-630166
	CALL cl_prt_pos_wc(tm.wc)
      END IF
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED  #No.MOD-580212
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED  #No.MOD-580212
         ELSE SKIP 2 LINE
      END IF
END REPORT
