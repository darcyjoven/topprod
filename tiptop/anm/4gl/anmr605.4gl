# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: anmr605.4gl
# Descriptions...: 投資狀況明細表
# Date & Author..: 2000/07/24 By Mandy
# Modify.........: 2002/01/07 By faith
# Modify.........: No.FUN-4C0098 05/02/24 By pengu 報表轉XML
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-590111 05/10/04 By Nicola 欄位變動
# Modify.........: No.MOD-650038 06/05/12 By Nicola 最後三個欄位取消小計、總計
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-660060 06/06/29 By Rainy 表頭期間置於中間
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.MOD-670077 06/07/18 By Smapmin 於頁首就抓取gsa02的值
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.MOD-740409 07/04/27 By Nicola 報表金額無法顯示
# Modify.........: No.FUN-7B0140 07/11/14 By Lutingting 報表改為用Crystal Report
# Modify.........: No.MOD-8B0204 08/11/20 By clover 不列印出未確認的; gsh_file 增加條件 gshconf = 'Y'
# Modify.........: No.MOD-970005 09/07/01 By mike 增加參數g_azi03     
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD		               # Print condition RECORD
               wc      STRING,                 #Where Condiction
               byy     LIKE type_file.num5,    #No.FUN-680107 SMALLINT
               bm      LIKE type_file.num5,    #No.FUN-680107 SMALLINT
               eyy     LIKE type_file.num5,    #No.FUN-680107 SMALLINT
               em      LIKE type_file.num5,    #No.FUN-680107 SMALLINT
               type    LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)#是否只列印有異動的資料
               more    LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)#是否列印其它條件
               END     RECORD
    #-----No.FUN-590111-----
    DEFINE g_gse05 LIKE gse_file.gse05,
           g_gse06 LIKE gse_file.gse06,
           g_gse24 LIKE gse_file.gse24,
           g_gse20 LIKE gse_file.gse20,
           g_gse23 LIKE gse_file.gse23,
           g_gsh05 LIKE gsh_file.gsh05,
           g_gsh06 LIKE gsh_file.gsh06,
    #-----No.FUN-590111 END-----
           g_cost1 LIKE type_file.num20_6,     #No.FUN-680107 DEC(20,6)
           g_cost2 LIKE type_file.num20_6,     #No.FUN-680107 DEC(20,6)
           g_cost  LIKE type_file.num20_6,     #No.FUN-680107 DEC(20,6)
           g_gsk04 LIKE gsk_file.gsk04,
           g_gsk05 LIKE gsk_file.gsk05
 
    DEFINE g_i     LIKE type_file.num5         #count/index for any purpose #No.FUN-680107 SMALLINT
    DEFINE g_head1 STRING
    DEFINE g_str   STRING                      #No.FUN-7B0140
    DEFINE g_sql   STRING                      #No.FUN-7B0140
    DEFINE l_table STRING                      #No.FUN-7B0140
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT			       # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
 
#No.FUN-7B0140--start--
    LET g_sql = "gsb01.gsb_file.gsb01,",
                "gsb05.gsb_file.gsb05,",
                "gsb03.gsb_file.gsb03,",
                "l_gsa02.gsa_file.gsa02,",
                "last_gsk04.gsk_file.gsk04,",
                "last_cost.type_file.num20_6,",
                "last_gsk05.gsk_file.gsk05,",
                "l_gse02.gse_file.gse02,",
                "l_gsh05.gsh_file.gsh05,",
                "l_cost1.type_file.num20_6,",
                "l_gsh06.gsh_file.gsh06,",
                "l_gse05.gse_file.gse05,",
                "l_cost2.type_file.num20_6,",
                "l_gse06.gse_file.gse06,",
                "l_gse23.gse_file.gse23,",
                "l_gse20.gse_file.gse20,",
                "l_gse24.gse_file.gse24,",
                "this_gsk04.gsk_file.gsk04,",
                "this_cost.type_file.num20_6,",
                "this_gsk05.gsk_file.gsk05,",
                "azi04.azi_file.azi04"
    LET l_table = cl_prt_temptable('anmr605',g_sql) CLIPPED
    IF l_table=-1 THEN EXIT PROGRAM END IF
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES (?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?, ?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF
#No.FUN-7B0140--end
 
    LET g_pdate = ARG_VAL(1)	        # Get arguments from command line
    LET g_towhom = ARG_VAL(2)
    LET g_rlang  = ARG_VAL(3)
    LET g_bgjob  = ARG_VAL(4)
    LET g_prtway = ARG_VAL(5)
    LET g_copies = ARG_VAL(6)
    LET tm.wc    = ARG_VAL(7)
    LET tm.byy   = ARG_VAL(8)
    LET tm.bm    = ARG_VAL(9)
    LET tm.eyy   = ARG_VAL(10)
    LET tm.em    = ARG_VAL(11)
    LET tm.type  = ARG_VAL(12)   #TQC-610058
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
 #-------------------------------
#FUN-680017--start
#   CREATE TEMP TABLE r605_temp
#    ( tmp01 VARCHAR(01),
#      tmp02 DATE,
#      tmp03 DEC(12,3),   #gse05
#      tmp04 DEC(20,6),   #gse06
#      tmp05 DEC(20,6),   #gse24
#      tmp06 DEC(20,6),   #gse20
#      tmp07 DEC(20,6),   #gse23
#      tmp08 DEC(12,3),   #gsh05
#      tmp09 DEC(20,6)    #gsh06
#    )
 
   #No.FUN-680107--欄位類型修改
   CREATE TEMP TABLE r605_temp(   #No.MOD-740409
    tmp01  LIKE  type_file.chr1,
    tmp02 LIKE type_file.dat,
    tmp03 LIKE gse_file.gse05,
    tmp04 LIKE gse_file.gse06,
    tmp05 LIKE gse_file.gse24,
    tmp06 LIKE gse_file.gse20,
    tmp07 LIKE gse_file.gse23,
    tmp08 LIKE gsh_file.gsh05,
    tmp09 LIKE gsh_file.gsh06);
#No.FUN-680107 --end
 #--------------------------------
 
    IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
        THEN CALL anmr605_tm()	        	# Input print condition
        ELSE CALL anmr605()			# Read data and create out-file
    END IF
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr605_tm()
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col LIKE type_file.num5,    #No.FUN-680107 SMALLINT
       l_cmd       LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(400)
       l_flag      LIKE type_file.chr1,    #是否必要欄位有輸入 #No.FUN-680107 VARCHAR(1)
       l_jmp_flag  LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
 
   LET p_row = 4 LET p_col = 15
    OPEN WINDOW anmr605_w AT p_row,p_col
         WITH FORM "anm/42f/anmr605"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL cl_opmsg('p')
    INITIALIZE tm.* TO NULL			# Default condition
    LET tm.byy    = YEAR(g_today)
    LET tm.bm     = MONTH(g_today)
    LET tm.eyy    = YEAR(g_today)
    LET tm.em     = MONTH(g_today)
    LET tm.type   = 'Y'
    LET tm.more   = 'N'
    LET g_pdate   = g_today
    LET g_rlang   = g_lang
    LET g_bgjob   = 'N'
    LET g_copies  = '1'
WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON gsb01,gsb05,gsb07
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
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
    IF INT_FLAG THEN
        LET INT_FLAG = 0 CLOSE WINDOW anmr605_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
 
    END IF
    IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
    INPUT BY NAME tm.byy,tm.bm,tm.eyy,tm.em,tm.type,tm.more
        WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
    AFTER FIELD byy
        IF cl_null(tm.byy) THEN NEXT FIELD byy END IF
    AFTER FIELD bm
        IF cl_null(tm.bm) THEN NEXT FIELD bm END IF
    AFTER FIELD eyy
        IF cl_null(tm.eyy) THEN NEXT FIELD eyy END IF
    AFTER FIELD em
        IF cl_null(tm.em) THEN NEXT FIELD em END IF
    AFTER FIELD type
        IF tm.type NOT MATCHES "[YN]" OR tm.type IS NULL OR
           tm.type = ' ' THEN
            NEXT FIELD type
        END IF
    AFTER FIELD more
        IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL OR tm.more = ' '
            THEN NEXT FIELD more
        END IF
        IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
                RETURNING g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies
        END IF
    AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
        LET l_flag='N'
        IF INT_FLAG THEN EXIT INPUT  END IF
        IF cl_null(tm.byy) THEN
            LET l_flag='Y'
            DISPLAY BY NAME tm.byy
            NEXT FIELD byy
        END IF
        IF cl_null(tm.bm) THEN
            LET l_flag='Y'
            DISPLAY BY NAME tm.bm
            NEXT FIELD bm
        END IF
        IF cl_null(tm.eyy)  THEN
            LET l_flag='Y'
            DISPLAY BY NAME tm.eyy
            NEXT FIELD eyy
        END IF
        IF cl_null(tm.em)  THEN
            LET l_flag='Y'
            DISPLAY BY NAME tm.em
            NEXT FIELD em
        END IF
        IF cl_null(tm.type)  THEN
            LET l_flag='Y'
            DISPLAY BY NAME tm.type
            NEXT FIELD type
        END IF
        IF l_flag='Y' THEN
            CALL cl_err('','9033',0)
            NEXT FIELD bdate
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
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
    END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0 CLOSE WINDOW anmr605_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
 
    END IF
    IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
            WHERE zz01='anmr605'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
             CALL cl_err('anmr605','9031',1)
        ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.byy CLIPPED,"'",
                         " '",tm.bm CLIPPED,"'",
                         " '",tm.eyy CLIPPED,"'",
                         " '",tm.em CLIPPED,"'",
                         " '",tm.type CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('anmr605',g_time,l_cmd)	# Execute cmd at later time
        END IF
        CLOSE WINDOW anmr605_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
    END IF
    CALL cl_wait()
    CALL anmr605()
    ERROR ""
END WHILE
    CLOSE WINDOW anmr605_w
END FUNCTION
 
FUNCTION anmr605()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0082
          #l_sql  VARCHAR(601),	        	# RDSQL STATEMENT   #MOD-670077
          l_sql 	STRING,		                # RDSQL STATEMENT   #MOD-670077
          l_za05	LIKE type_file.chr1000,         #標題內容  #No.FUN-680107 VARCHAR(40)
          l_order      ARRAY[2] OF LIKE cre_file.cre08, #No.FUN-680107 ARRAY[2] OF VARCHAR(10) #排列順序
          l_i          LIKE type_file.num5,             #No.FUN-680107 SMALLINT
          l_cnt        LIKE type_file.num5,             #No.FUN-680107 SMALLINT
          l_bdate      LIKE type_file.dat,              #No.FUN-680107 DATE
          l_edate      LIKE type_file.dat,              #No.FUN-680107 DATE
          sr           RECORD
                            gsb05    LIKE gsb_file.gsb05,
                            gsb03    LIKE gsb_file.gsb03,
                            gsb01    LIKE gsb_file.gsb01,
                            gsb06    LIKE gsb_file.gsb06,
                         #  gsb07    LIKE gsb_file.gsb07,   #No.FUN-590111 Mark
                            gsb10    LIKE gsb_file.gsb10,
                            gsb101   LIKE gsb_file.gsb101
                       END RECORD
#No.FUN-7B0022--start--
   DEFINE  l_trn       RECORD
                       type   LIKE type_file.chr1,  #No.FUN-680107 VARCHAR(1)
                       gse02  LIKE gse_file.gse02,
                       gse05 LIKE gse_file.gse05,
                       gse06 LIKE gse_file.gse06,
                       gse24 LIKE gse_file.gse24,
                       gse20 LIKE gse_file.gse20,
                       gse23 LIKE gse_file.gse23,
                       gsh05 LIKE gsh_file.gsh05,
                       gsh06 LIKE gsh_file.gsh06
                       END RECORD,
           l_type    LIKE type_file.chr1,              #No.FUN-680107 VARCHAR(1)
           l_gse02             LIKE gse_file.gse02,  #平倉日期
           l_gse05   LIKE gse_file.gse05,  #平倉數量
           l_gse06   LIKE gse_file.gse06,  #平倉金額
           l_gse24   LIKE gse_file.gse24,  #投資損益
           l_gse23   LIKE gse_file.gse23,  #投資損益
           l_gse20   LIKE gse_file.gse20,  #投資損益
           l_gsh05   LIKE gse_file.gse05,  #平倉數量
           l_gsh06   LIKE gse_file.gse06,  #平倉金額
           l_gsa02   LIKE gsa_file.gsa02,
           l_cost1,l_cost2     LIKE type_file.num20_6,
           l_last_yy,l_last_mm LIKE type_file.num5,
           last_gsk04  LIKE gsk_file.gsk04,
           last_gsk05  LIKE gsk_file.gsk05,
           last_cost   LIKE type_file.num20_6,
           this_gsk04  LIKE gsk_file.gsk04,
           this_gsk05  LIKE gsk_file.gsk05,
           this_cost   LIKE type_file.num20_6
#No.FUN-7B0140--end
   CALL cl_del_data(l_table)                                      #No.FUN-7B0140
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='anmr605'      #No.FUN-7B0140
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#NO.CHI-6A0004--BEGINE
#   SELECT azi04 INTO g_azi04 FROM azi_file WHERE azi01 = g_aza.aza17
#   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_azi04,SQLCA.sqlcode,0) #FUN-660148
#      CALL cl_err3("sel","azi_file",g_aza.aza17,"",STATUS,"","",0) #FUN-660148
#   END IF
#NO.CHI-6A0004--END
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #       LET tm.wc = tm.wc clipped," AND gsbuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET tm.wc = tm.wc clipped," AND gsbgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET tm.wc = tm.wc clipped," AND gsbgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('gsbuser', 'gsbgrup')
   #End:FUN-980030
 
 
   CALL s_ymtodate(tm.byy,tm.bm,tm.eyy,tm.em) RETURNING l_bdate,l_edate
   LET l_sql = "SELECT gsb05,gsb03,gsb01,gsb06,gsb10,gsb101,",   #No.FUN-590111
               "       gsb06,gsb07,gsb10,gsb101",
               "  FROM gsb_file",
               " WHERE ",tm.wc CLIPPED,
               "   AND gsb03 BETWEEN '",l_bdate,"' AND '",l_edate,"' ",
               " ORDER BY gsb05,gsb03,gsb01"
 
   PREPARE anmr605_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:anmr605_prepare1',SQLCA.sqlcode,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
       EXIT PROGRAM
 
   END IF
   DECLARE anmr605_curs1 CURSOR FOR anmr605_prepare1
 
#  CALL cl_outnam('anmr605') RETURNING l_name   #No.FUN-7B0140 Mark
#  START REPORT anmr605_rep TO l_name           #No.FUN-7B0140 Mark
 
   LET g_pageno = 0
   #-----No.FUN-590111-----
   LET g_gse05=0
   LET g_gse06=0
   LET g_gse24=0
   LET g_gse20=0
   LET g_gse23=0
   LET g_gsh05=0
   LET g_gsh06=0
   #-----No.FUN-590111 END-----
   LET g_cost1=0
   LET g_cost2=0
   LET g_cost=0
   LET g_gsk04=0
   LET g_gsk05=0
 
   FOREACH anmr605_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
#      OUTPUT TO REPORT anmr605_rep(sr.*)                            #No.FUN-7B0140 Mark
      SELECT gsa02 INTO l_gsa02 FROM gsa_file WHERE gsa01=sr.gsb05   #No.FUN-7B0140
      SELECT COUNT(*) INTO l_cnt FROM gse_file WHERE gse03=sr.gsb01  AND gseconf = 'Y' #MOD-8B0204 #No.FUN-7B0140
 
#No.FUN-7B0140--start--
      #以下自AFTER GROUP OF sr.gsb01處提上來
 
      #上期結餘
      IF tm.bm >1 THEN
         LET l_last_yy=tm.byy
         LET l_last_mm=tm.bm-1
      ELSE
         LET l_last_yy=tm.byy-1
         IF g_aza.aza02='1' THEN
            LET l_last_mm=12
         ELSE
            LET l_last_mm=13
         END IF
      END IF
      SELECT gsk04,gsk05
        INTO last_gsk04,last_gsk05 FROM gsk_file
       WHERE gsk01=sr.gsb01
         AND gsk02=l_last_yy
         AND gsk03=l_last_mm
      IF cl_null(last_gsk04) THEN LET last_gsk04=0 END IF
      IF cl_null(last_gsk05) THEN LET last_gsk05=0 END IF
      LET last_cost=last_gsk05/last_gsk04
      IF cl_null(last_cost) THEN LET last_cost=0 END IF
 
      #以下自ON EVERY ROW 處提上來
      LET l_cnt=0
      SELECT COUNT(*) INTO l_cnt FROM gse_file
       WHERE gse03=sr.gsb01    AND gseconf = 'Y'             #MOD-8B0204
      IF tm.type='Y' AND l_cnt>0 OR tm.type='N' THEN   # 只打印有異動資料
         CALL s_ymtodate(tm.byy,tm.bm,tm.eyy,tm.em) RETURNING l_bdate,l_edate
 
         #本期增加 '1'
         DECLARE gsh_curs CURSOR FOR
         SELECT '1',gsh02,0,0,0,0,0,gsh05,gsh06 FROM gsh_file
          WHERE gsh03 = sr.gsb01   AND gshconf = 'Y'             #MOD-8B0204
            AND gsh02 BETWEEN l_bdate AND l_edate
          ORDER BY gsh02
         FOREACH gsh_curs INTO l_trn.*
            IF STATUS THEN
               CALL cl_err('foreach:gsh_curs',STATUS,1) EXIT FOREACH
            END IF
            EXECUTE insert_prep USING
               sr.gsb01,sr.gsb05,sr.gsb03,l_gsa02,last_gsk04,last_cost,last_gsk05,
               l_trn.gse02,l_trn.gsh05,l_cost1,l_trn.gsh06,l_trn.gse05,l_cost2,
               l_trn.gse06,l_trn.gse23,l_trn.gse20,
               l_trn.gse24,this_gsk04,this_cost,this_gsk05,g_azi04
            IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
               CALL cl_err3("ins","r605_temp","","",STATUS,"","ins temp",0)
            END IF
         END FOREACH
 
         #本期減少 '2'
         DECLARE gse_curs CURSOR FOR
            SELECT '2',gse02,gse05,gse06,gse24,gse20,gse23,0,0 FROM gse_file
             WHERE gse03 = sr.gsb01 AND gseconf = 'Y'             #MOD-8B0204
               AND gse02 BETWEEN l_bdate AND l_edate
             ORDER BY gse02
         FOREACH gse_curs INTO l_trn.*
            IF STATUS THEN
               CALL cl_err('foreach:gse_curs',STATUS,1)
               EXIT FOREACH
            END IF
            EXECUTE insert_prep USING
               sr.gsb01,sr.gsb05,sr.gsb03,l_gsa02,last_gsk04,last_cost,last_gsk05,
               l_trn.gse02,l_trn.gsh05,l_cost1,l_trn.gsh06,l_trn.gse05,l_cost2,
               l_trn.gse06,l_trn.gse23,l_trn.gse20,
               l_trn.gse24,this_gsk04,this_cost,this_gsk05,g_azi04
            IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
               CALL cl_err3("ins","r605_temp","","",STATUS,"","ins temp",0)
            END IF
         END FOREACH
      END IF
   END FOREACH
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'gsb01,gsb05,gsb07') RETURNING tm.wc
      LET g_str=tm.wc
   END IF
   LET g_str = g_str,";",tm.byy,";",tm.bm,";",tm.eyy,";",tm.em,";",g_azi04,";",tm.type,";",g_azi03 #MOD-970005 add azi03 
   CALL cl_prt_cs3('anmr605','anmr605',g_sql,g_str)
#No.FUN-7B0140--end
#  FINISH REPORT anmr605_rep                                #No.FUN-7B0140 Mark
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)              #No.FUN-7B0140 Mark
END FUNCTION
 
#No.FUN-7B0140--start--
 
#REPORT anmr605_rep(sr)
#
#              CALL cl_err('ins temp',STATUS,0)   #No.FUN-660148
#              CALL cl_err3("ins","r605_temp","","",STATUS,"","ins temp",0) #No.FUN-660148
#           END IF
#       END FOREACH
 
#      #投資減少 '2'
#      DECLARE gse_curs CURSOR FOR
#          SELECT '2',gse02,gse05,gse06,gse24,gse20,gse23,0,0   #No.FUN-590111
#            FROM gse_file  AND gseconf = 'Y'             #MOD-8B0204
#           WHERE gse03 = sr.gsb01
#             AND gse02 BETWEEN l_bdate AND l_edate
#          ORDER BY gse02
#       FOREACH gse_curs INTO l_trn.*
#           IF STATUS THEN
#              CALL cl_err('foreach:gse_curs',STATUS,1)
#              EXIT FOREACH
#           END IF
#           INSERT INTO r605_temp VALUES(l_trn.*)
#           IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
##              CALL cl_err('ins temp',STATUS,0)   #No.FUN-660148
#              CALL cl_err3("ins","r605_temp","","",STATUS,"","ins temp",0) #No.FUN-660148
#           END IF
#       END FOREACH
 
#   AFTER GROUP OF sr.gsb01
#   #上期結餘 ---------------------------------------------
#      IF tm.bm >1 THEN
#         LET l_last_yy=tm.byy
#         LET l_last_mm=tm.bm-1
#      ELSE
#         LET l_last_yy=tm.byy-1
#         IF g_aza.aza02='1'
#            THEN LET l_last_mm=12
#            ELSE LET l_last_mm=13
#         END IF
#      END IF
#      SELECT gsk04,gsk05
#        INTO last_gsk04,last_gsk05 FROM gsk_file
#        WHERE gsk01=sr.gsb01
#          AND gsk02=l_last_yy
#          AND gsk03=l_last_mm
#      IF cl_null(last_gsk04) THEN LET last_gsk04=0 END IF
#      IF cl_null(last_gsk05) THEN LET last_gsk05=0 END IF
#      LET last_cost=last_gsk05/last_gsk04
#      IF cl_null(last_cost) THEN LET last_cost=0 END IF
#      IF tm.type='Y' AND l_cnt >0 OR tm.type='N' THEN
#         PRINT COLUMN g_c[31],g_x[19] CLIPPED,
#               COLUMN g_c[41],cl_numfor(last_gsk04,41,2),
#               COLUMN g_c[42],cl_numfor(last_cost,42,g_azi04),
#               COLUMN g_c[43],cl_numfor(last_gsk05,43,g_azi04)
#      END IF
#   #-------------------------------------------------------
#      DECLARE tmp_cur1 CURSOR FOR
#        SELECT tmp02,
#               SUM(tmp03),SUM(tmp04),SUM(tmp05),SUM(tmp06),SUM(tmp07),
#               SUM(tmp08),SUM(tmp09)
#          FROM r605_temp
#         GROUP BY tmp02
#         ORDER by 1
#      FOREACH tmp_cur1 INTO l_gse02,l_gse05,l_gse06,l_gse24,   #No.FUN-590111
#                            l_gse20,l_gse23,l_gsh05,l_gsh06    #No.FUN-590111
 
#          IF STATUS THEN
#             CALL cl_err('foreach:gsh_curs',STATUS,1) EXIT FOREACH
#          END IF
#          #-----No.FUN-590111-----
#          IF cl_null(l_gse05) THEN LET l_gse05=0 END IF
#          IF cl_null(l_gse06) THEN LET l_gse06=0 END IF
#          IF cl_null(l_gse24) THEN LET l_gse24=0 END IF
#          IF cl_null(l_gse20) THEN LET l_gse20=0 END IF
#          IF cl_null(l_gse23) THEN LET l_gse23=0 END IF
#          IF cl_null(l_gsh05) THEN LET l_gsh05=0 END IF
#          IF cl_null(l_gsh06) THEN LET l_gsh06=0 END IF
#          LET l_cost1 = l_gsh06 / l_gsh05
#          LET l_cost2 = l_gse06 / l_gse05
#          #-----No.FUN-590111 END-----
#          IF cl_null(l_cost1)  THEN LET l_cost1=0  END IF
#          IF cl_null(l_cost2)  THEN LET l_cost2=0  END IF
 
#         #是否要印異動資料
#          IF tm.type='Y' AND l_cnt>0 OR tm.type='N' THEN
#             #-----No.FUN-590111-----
#             PRINT COLUMN g_c[31],l_gse02 CLIPPED,
#                   COLUMN g_c[32],cl_numfor(l_gsh05,32,g_azi04),
#                   COLUMN g_c[33],cl_numfor(l_cost1,33,g_azi04),
#                   COLUMN g_c[34],cl_numfor(l_gsh06,34,g_azi04),
#                   COLUMN g_c[35],cl_numfor(l_gse05,35,g_azi04),
#                   COLUMN g_c[36],cl_numfor(l_cost2,36,g_azi04),
#                   COLUMN g_c[37],cl_numfor(l_gse06,37,g_azi04),
#                   COLUMN g_c[38],cl_numfor(l_gse23,38,g_azi04),
#                   COLUMN g_c[39],cl_numfor(l_gse20,39,g_azi04),
#                   COLUMN g_c[40],cl_numfor(l_gse24,40,g_azi04);
#            #期末結餘 --------------------------------------------
#             LET this_gsk04=this_gsk04+last_gsk04+l_gsh05-l_gse05
#             LET this_gsk05=this_gsk05+last_gsk05+l_gsh06-l_gse06
#             #-----No.FUN-590111 END-----
#             LET this_cost=this_gsk05/this_gsk04
#             IF cl_null(this_cost) THEN LET this_cost=0 END IF
#             PRINT COLUMN g_c[41],cl_numfor(this_gsk04 ,41,g_azi04),
#                   COLUMN g_c[42],cl_numfor(this_cost  ,42,g_azi04),
#                   COLUMN g_c[43],cl_numfor(this_gsk05  ,43,g_azi04)
 
#             LET tot_gsk04 =tot_gsk04 +this_gsk04
#             LET tot_gsk05 =tot_gsk05 +this_gsk05
#             LET tot_cost  =tot_gsk05/tot_gsk04
#             #-----No.FUN-590111-----
#             LET tot_gsh05 = tot_gsh05 + l_gsh05
#             LET tot_gsh06 = tot_gsh06 + l_gsh06
#             LET tot_gse05 = tot_gse05 + l_gse05
#             LET tot_gse06 = tot_gse06 + l_gse06
#             LET tot_gse24 = tot_gse24 + l_gse24
#             LET tot_gse20 = tot_gse20 + l_gse20
#             LET tot_gse23 = tot_gse23 + l_gse23
#             LET tot_cost1 = tot_gsh06 / tot_gsh05
#             LET tot_cost2 = tot_gse06 / tot_gse05
#             #-----No.FUN-590111 END-----
#             IF cl_null(tot_cost1) THEN LET tot_cost1=0 END IF
#             IF cl_null(tot_cost2) THEN LET tot_cost2=0 END IF
#             IF cl_null(tot_cost)  THEN LET tot_cost=0 END IF
#          #ON LAST ROW 總計用
#             #-----No.FUN-590111-----
#             LET g_gsh05 = g_gsh05 + l_gsh05
#             LET g_gsh06 = g_gsh06 + l_gsh06
#             LET g_cost1 = g_gsh06 / g_gsh05
#             LET g_gse05 = g_gse05 + l_gse05
#             LET g_gse06 = g_gse06 + l_gse06
#             LET g_cost2 = g_gse06 / g_gse05
#             LET g_gse24 = g_gse24 + l_gse24
#             LET g_gse20 = g_gse20 + l_gse20
#             LET g_gse23 = g_gse23 + l_gse23
#             #-----No.FUN-590111 END-----
#             LET g_gsk04 =g_gsk04 +this_gsk04
#             LET g_gsk05 =g_gsk05 +this_gsk05
#             LET g_cost  =g_gsk05/g_gsk04
#             IF cl_null(g_cost)  THEN LET g_cost=0 END IF
#             IF cl_null(g_cost1) THEN LET g_cost1=0 END IF
#             IF cl_null(g_cost2) THEN LET g_cost2=0 END IF
#           END IF
#       END FOREACH
#       #------- BY 投資編號小計 --------------------------------
#       IF tm.type='Y' AND l_cnt>0 OR tm.type='N' THEN
#          #-----No.FUN-590111-----
#          PRINT  COLUMN g_c[31],g_x[20] CLIPPED;
#          PRINT  COLUMN g_c[32],cl_numfor(tot_gsh05,32,g_azi04),
#                 COLUMN g_c[33],cl_numfor(tot_cost1,33,g_azi04),
#                 COLUMN g_c[34],cl_numfor(tot_gsh06,34,g_azi04),
#                 COLUMN g_c[35],cl_numfor(tot_gse05,35,g_azi04),
#                 COLUMN g_c[36],cl_numfor(tot_cost2,36,g_azi04),
#                 COLUMN g_c[37],cl_numfor(tot_gse06,37,g_azi04),
#                 COLUMN g_c[38],cl_numfor(tot_gse23,38,g_azi04),
#                 COLUMN g_c[39],cl_numfor(tot_gse20,39,g_azi04),
#                 COLUMN g_c[40],cl_numfor(tot_gse24,40,g_azi04)
#                #COLUMN g_c[41],cl_numfor(tot_gsk04,41,g_azi04),   #No.MOD-650038 Mark
#                #COLUMN g_c[42],cl_numfor(tot_cost ,42,g_azi04),   #No.MOD-650038 Mark
#                #COLUMN g_c[43],cl_numfor(tot_gsk05,43,g_azi04)    #No.MOD-650038 Mark
#          #-----No.FUN-590111 END-----
#          PRINT g_dash[1,g_len]
#          PRINT ''
#       END IF
 
 
#   ON LAST ROW
#       PRINT COLUMN 07,g_x[21] CLIPPED;
#      #-----No.FUN-590111-----
#      PRINT COLUMN g_c[32],cl_numfor(g_gsh05,32,g_azi04),
#            COLUMN g_c[33],cl_numfor(g_cost1,33,g_azi04),
#            COLUMN g_c[34],cl_numfor(g_gsh06,34,g_azi04),
#            COLUMN g_c[35],cl_numfor(g_gse05,35,g_azi04),
#            COLUMN g_c[36],cl_numfor(g_cost2,36,g_azi04),
#            COLUMN g_c[37],cl_numfor(g_gse06,37,g_azi04),
#            COLUMN g_c[38],cl_numfor(g_gse23,38,g_azi04),
#            COLUMN g_c[39],cl_numfor(g_gse20,39,g_azi04),
#            COLUMN g_c[40],cl_numfor(g_gse24,40,g_azi04)
#           #COLUMN g_c[41],cl_numfor(g_gsk04,41,g_azi04),   #No.MOD-650038 Mark
#           #COLUMN g_c[42],cl_numfor(g_cost ,42,g_azi04),   #No.MOD-650038 Mark
#           #COLUMN g_c[43],cl_numfor(g_gsk05,43,g_azi04)    #No.MOD-650038 Mark
#      #-----No.FUN-590111 END-----
#       PRINT g_dash[1,g_len]
#       IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
#           THEN #PRINT g_dash[1,g_len]
#           #TQC-630166
#           #IF tm.wc[001,120] > ' ' THEN			# for 132
#           #   PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#           #IF tm.wc[121,240] > ' ' THEN
#           #   PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#           #IF tm.wc[241,300] > ' ' THEN
#           #   PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#           #PRINT g_dash[1,g_len]
#           CALL cl_prt_pos_wc(tm.wc)
#           #END TQC-630166
 
#       END IF
#       LET l_last_sw = 'y'
#       PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#          THEN PRINT g_dash[1,g_len]
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#      ELSE SKIP 2 LINE
#      END IF
#END REPORT
 
#No.FUN-7B0140--end
