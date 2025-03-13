# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: admr111.4gl
# Descriptions...: 出貨未達比率分析表
# Input parameter:
# Date & Author..: 02/07/22 By Kitty
# Modify.........: No.FUN-4C0099 05/01/17 By kim 報表轉XML功能
# Modify.........: No.MOD-530217 05/03/23 By kim informix prepare語法錯誤
# Modify.........: No.FUN-610020 06/01/09 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.FUN-680097 06/08/28 By chen 類型轉換
# Modify.........: No.FUN-690111 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.FUN-750137 07/07/07 By xufeng 1."百分比"欄位，數值后統一加上"%"
#                                                   2.加入"預計產量"\"已達數量"\"未達數量"\"百分比"的總計欄位
# Modify.........: No.FUN-750027 070713 by TSD.pinky Add CR report
# Modify.........: No.TQC-790177 07/09/29 By Carrier 去掉全型字符
# Modify.........: No.TQC-960341 09/06/23 By hongmei 修改l_sql
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.TQC-A40116 10/04/26 BY liuxqa modify sql
# Modify.........: No:MOD-A70180 10/07/23 By Sarah 權限控管段抓取的欄位fakuser與fakgrup應改為opmuser與opmgrup
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
              wc     STRING,                    # Where Condition  No.TQC-630166  
              opm02  LIKE opm_file.opm02,       # 最小延遲天數
              yy     LIKE type_file.num5,       #No.FUN-680097 SMALLINT
              mm1    LIKE type_file.num5,       #No.FUN-680097 SMALLINT
              mm2    LIKE type_file.num5,       #No.FUN-680097 SMALLINT
              ch     LIKE type_file.chr1,       #No.FUN-680097 VARCHAR(1)
              more   LIKE type_file.chr1        # 特殊列印條件  #No.FUN-680097 VARCHAR(1)
              END RECORD,
          l_i       LIKE type_file.num5,         #No.FUN-680097 SMALLINT
          l_j       LIKE type_file.num5          #No.FUN-680097 SMALLINT
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680097 SMALLINT
DEFINE   l_table        STRING, #FUN-750027###
        g_str          STRING, #FUN-750027###
        g_sql          STRING  #FUN-750027###
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ADM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690111
    #str FUN-750027 add
  ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
  LET g_sql=" opm01.opm_file.opm01,",    
            " oba02.oba_file.oba02," ,   
            " opn05.opn_file.opn05,"  , 
            " ogb16.ogb_file.ogb16 "   
   
  LET l_table = cl_prt_temptable('admr111',g_sql) CLIPPED   # 產生Temp Table
  IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
  #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
  LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-A40116 mod
              " VALUES(?,?,?,?)"
  PREPARE insert_prep FROM g_sql
  IF STATUS THEN
     CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
  END IF
  #------------------------------ CR (1) ------------------------------#
  #end FUN-750027 add
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.opm02 = ARG_VAL(8)
   LET tm.yy    = ARG_VAL(9)
   LET tm.mm1   = ARG_VAL(10)
   LET tm.mm2   = ARG_VAL(11)
   LET tm.ch    = ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r111_tm(0,0)	
      ELSE CALL r111()		
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
END MAIN
 
FUNCTION r111_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680097 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680097 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 11 END IF
   OPEN WINDOW r111_w AT p_row,p_col
        WITH FORM "adm/42f/admr111"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.more   = 'N'
   LET tm.ch     = 'Y'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
WHILE TRUE
   CONSTRUCT BY NAME  tm.wc ON opm01
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
      LET INT_FLAG = 0
      CLOSE WINDOW r111_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   INPUT BY NAME tm.opm02,tm.yy,tm.mm1,tm.mm2,tm.ch,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD opm02
         IF cl_null(tm.opm02) THEN NEXT FIELD opm02 END IF
      AFTER FIELD yy
         IF cl_null(tm.yy) THEN NEXT FIELD yy END IF
      AFTER FIELD mm1
         IF cl_null(tm.mm1) THEN NEXT FIELD mm1 END IF
         IF tm.mm1 < 1 AND tm.mm1 > 12 THEN NEXT FIELD mm1 END IF
      AFTER FIELD mm2
         IF cl_null(tm.mm2) THEN NEXT FIELD mm2 END IF
         IF tm.mm2 < 1 AND tm.mm2 > 12 THEN NEXT FIELD mm2 END IF
         IF tm.mm2 < tm.mm1 THEN NEXT FIELD mm1 END IF
      AFTER FIELD ch
         IF cl_null(tm.ch) OR tm.ch NOT MATCHES '[YN]' THEN NEXT FIELD ch END IF
      AFTER FIELD more
         IF tm.more NOT MATCHES'[YN]' THEN
            NEXT FIELD more
         END IF
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
      LET INT_FLAG = 0
      CLOSE WINDOW r111_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='admr111'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('admr111','9031',1)
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
                         " '",tm.opm02 CLIPPED,"'",
                         " '",tm.yy    CLIPPED,"'",
                         " '",tm.mm1   CLIPPED,"'",
                         " '",tm.mm2   CLIPPED,"'",
                         " '",tm.ch    CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('admr111',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r111_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r111()
   ERROR ""
END WHILE
   CLOSE WINDOW r111_w
END FUNCTION
 
FUNCTION r111()
   DEFINE l_name     LIKE type_file.chr20, 		# External(Disk) file name        #No.FUN-680097 VARCHAR(20)
#       l_time          LIKE type_file.chr8         #No.FUN-6A0100
          l_sql      LIKE type_file.chr1000,            # RDSQL STATEMENT #No.FUN-680097 VARCHAR(1000)      
          l_sql1     LIKE type_file.chr1000,		# RDSQL STATEMENT #No.FUN-680097 VARCHAR(1000)   
          l_sql2     LIKE type_file.chr1000,		# RDSQL STATEMENT #No.FUN-680097 VARCHAR(1000)  
          l_buf      LIKE type_file.chr1000,		# RDSQL STATEMENT #No.FUN-680097 VARCHAR(1000)
          l_za05     LIKE type_file.chr1000,       #No.FUN-680097 VARCHAR(40)
          l_date1    LIKE type_file.dat,           #No.FUN-680097 DATE
          l_date2    LIKE type_file.dat,           #No.FUN-680097 DATE
          b_date     LIKE type_file.dat,           #No.FUN-680097 DATE
          e_date     LIKE type_file.dat,           #No.FUN-680097 DATE
          sr         RECORD
                     opm01     LIKE    opm_file.opm01,    #產品別編號
                     oba02     LIKE    oba_file.oba02,    #產品別名稱
                     opn05     LIKE    opn_file.opn05,    #預計產量
                     ogb16     LIKE    ogb_file.ogb16     #已達數量
                     END RECORD
      #------------FUN-750027 add end---------------------
 
    #str FUN-750027 add
    ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
    CALL cl_del_data(l_table)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 =  g_prog  #FUN-750027 ad
    #------------------------------ CR (2) ------------------------------#
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND fakuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND oeagrup IN ",cl_chk_tgrup_list()
     #     END IF
    #LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fakuser', 'fakgrup')  #MOD-A70180 mark
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('opmuser', 'opmgrup')  #MOD-A70180
     #End:FUN-980030
 
     LET l_sql = " SELECT opm01,oba02,sum(opn05),0",
                 " FROM opm_file,oba_file,opn_file",
                 " WHERE opm01=oba01 AND opm01=opn01",
                 "  AND  opm02=opn02 AND opm03=opn03 ",
                 "  AND  ",tm.wc CLIPPED ,
             #   "  AND opm02 = '",tm.opm02,"' AND opn03=",tm.yy,        #TQC-960341 mark
                 "  AND opm02 = '",tm.opm02,"' AND opn03= '",tm.yy,"'",  #TQC-960341
                 "  AND opn04 between '",tm.mm1,"' AND '",tm.mm2,"'",
                 " GROUP BY opm01,oba02"
 
 
     PREPARE r111_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
        EXIT PROGRAM
     END IF
     DECLARE r111_c1 CURSOR FOR r111_p1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('declare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
        EXIT PROGRAM
     END IF
   #  CALL cl_outnam('admr111') RETURNING l_name
 
   #  START REPORT r111_rep TO l_name
 
     LET g_pageno = 0
     FOREACH r111_c1 INTO sr.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       #OUTPUT TO REPORT r111_rep(sr.*)
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 ***
         EXECUTE insert_prep USING sr.*
        #------------------------------ CR (3) ----------------------
 
     END FOREACH
     #--取起訖日期
     CALL s_azn01(tm.yy,tm.mm1) RETURNING b_date,l_date1
     CALL s_azn01(tm.yy,tm.mm2) RETURNING l_date2,e_date
     #---取出貨量
     LET l_sql1=" SELECT ima131,oba02,0,SUM(ogb12) ",
                " FROM ogb_file,oga_file,ima_file,oba_file ",
                " WHERE ogb01=oga01 AND ogb04=ima01 AND ima131=oba01 AND ",
                 " oga09 IN ('2','3','4','6','8') AND ogaconf='Y' AND ogapost='Y' AND ", #MOD-530217  #No.FUN-610020
                " oga02 between '",b_date,"' AND '",e_date,"' AND ",tm.wc CLIPPED,
                " GROUP BY ima131,oba02 "
         #----> 將opm01 轉換為ima131(產品別)
         LET l_buf = l_sql1
         LET l_j = length(l_buf)
         FOR l_i = 1 TO l_j
             IF l_buf[l_i,l_i+4] = 'opm01' THEN
                 LET l_buf[l_i,l_i+4] = 'ima13'
                 LET l_buf=l_buf[1,l_i+4],'1 ',l_buf[l_i+5,l_j]
             END IF
         END FOR
         LET l_sql1 = l_buf
 
     PREPARE r111_p2 FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
        EXIT PROGRAM
     END IF
     DECLARE r111_c2 CURSOR FOR r111_p2
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('declare2:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
        EXIT PROGRAM
     END IF
     FOREACH r111_c2 INTO sr.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach2:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
      # OUTPUT TO REPORT r111_rep(sr.*)
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 ***
         EXECUTE insert_prep USING sr.*
        #------------------------------ CR (3) ----------------------
     END FOREACH
     #---取待出貨量
     IF tm.ch='Y' THEN
         LET l_sql2=" SELECT ima131,oba02,0,SUM(ogb12) ",
                " FROM ogb_file,oga_file,ima_file,oba_file ",
                " WHERE ogb01=oga01 AND ogb04=ima01 AND ima131=oba01 AND ",
                " oga02 between '",b_date,"' AND '",e_date,"'",
                 " AND ((oga09 IN ('1','5') AND ogaconf='Y'", #MOD-530217
                " AND oga01 NOT IN (SELECT oga011 FROM oga_file))",
                 " OR (oga09 IN ('2','3','4','6','8') AND ogaconf='Y' AND ogapost='N')) AND ", #MOD-530217  #No.FUN-610020
                tm.wc CLIPPED," GROUP BY ima131,oba02 "
         #----> 將opm01 轉換為ima131(產品別)
         LET l_buf = l_sql2
         LET l_j = length(l_buf)
         FOR l_i = 1 TO l_j
             IF l_buf[l_i,l_i+4] = 'opm01' THEN
                 LET l_buf[l_i,l_i+4] = 'ima13'
                 LET l_buf=l_buf[1,l_i+4],'1 ',l_buf[l_i+5,l_j]
             END IF
         END FOR
         LET l_sql2 = l_buf
 
      PREPARE r111_p3 FROM l_sql2
      IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare2:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
        EXIT PROGRAM
      END IF
      DECLARE r111_c3 CURSOR FOR r111_p3
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('declare3:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
         EXIT PROGRAM
      END IF
      FOREACH r111_c3 INTO sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach3:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
       # OUTPUT TO REPORT r111_rep(sr.*)
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 ***
         EXECUTE insert_prep USING sr.*
        #------------------------------ CR (3) ----------------------
       END FOREACH
     END IF
 
#     FINISH REPORT r111_rep
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   #str FUN-750027 add
      ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
      LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
      #是否列印選擇條件
      IF g_zz05 = 'Y' THEN
         CALL cl_wcchp(tm.wc,'opm01') RETURNING tm.wc
         LET g_str = tm.wc
      END IF
      LET g_str = g_str CLIPPED,";",tm.opm02,";",tm.yy,";",tm.mm1,";",tm.mm2
      CALL cl_prt_cs3('admr111','admr111',l_sql,g_str)
   #------------------------------ CR (4) ------------------------------#
 
END FUNCTION
 
REPORT r111_rep(sr)
   DEFINE l_last_sw LIKE type_file.chr1,             #No.FUN-680097 VARCHAR(1)	
          l_aa      LIKE    opn_file.opn05,
          l_bb      LIKE    opn_file.opn05,
          sr         RECORD
                     opm01     LIKE    opm_file.opm01,    #產品別編號
                     oba02     LIKE    oba_file.oba02,    #產品別名稱
                     opn05     LIKE    opn_file.opn05,    #預計產量
                     ogb16     LIKE    ogb_file.ogb16     #已達數量
                     END RECORD
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
PAGE LENGTH g_page_line
  ORDER BY sr.opm01
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      PRINT g_x[9] CLIPPED,tm.opm02,' ',
            g_x[10] CLIPPED,tm.yy USING '####',' ',
            g_x[11] CLIPPED,tm.mm1 USING '##','-',tm.mm2 USING '##'
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   AFTER GROUP OF sr.opm01
      LET l_aa=GROUP SUM(sr.opn05)
      LET l_bb=GROUP SUM(sr.ogb16)
      PRINT COLUMN g_c[31],sr.oba02,
            COLUMN g_c[32],cl_numfor(l_aa,32,2),
            COLUMN g_c[33],cl_numfor(l_bb,33,2),
            COLUMN g_c[34],cl_numfor((l_aa-l_bb),34,2),
            COLUMN g_c[35],cl_numfor(((l_aa-l_bb)/l_aa)*100,11,2),"%"
   
 
   ON LAST ROW
      #No.FUN-750137   --begin
      let l_aa=SUM(sr.opn05)
      let l_bb=SUM(sr.ogb16)
      PRINT 
      PRINT COLUMN g_c[31],g_x[12],
            COLUMN g_c[32],cl_numfor(l_aa,32,2),
            COLUMN g_c[33],cl_numfor(l_bb,33,2),
            COLUMN g_c[34],cl_numfor(l_aa-l_bb,34,2),
            COLUMN g_c[35],cl_numfor(((l_aa-l_bb)/l_aa)*100,11,2),"%"
      #No.FUN-750137   --end  
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN PRINT g_dash
              #No.TQC-630166 --start--
#             IF tm.wc[001,80] > ' ' THEN			# for 132
#		 PRINT g_x[8] CLIPPED,tm.wc[001,80] CLIPPED END IF
              CALL cl_prt_pos_wc(tm.wc)
              #No.TQC-630166 ---end---
      END IF
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[35],g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[35],g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
#TQC-790177
