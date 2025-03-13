# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: admr100.4gl
# Descriptions...: 訂單追蹤延遲警訊表(客戶別)
# Input parameter:
# Date & Author..: 02/07/22 By Kitty
# Modify.........: No.FUN-4C0099 05/01/17 By kim 報表轉XML功能
# Modify.........: No.MOD-580014 05/08/01 By kevin 取出金額小數欄給sr.azi04
# Modify.........: No.FUN-660090 06/06/23 By Douzh cl_err --> cl_err3
# Modify.........: No.FUN-680097 06/08/28 By chen 類型轉換
# Modify.........: No.FUN-690111 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Jackho 本（原）幣取位修改 
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.CHI-710043 07/03/01 By 過濾條件未考慮到tm.dd
# Modify.........: No.FUN-770008 07/07/05 By arman 報表改為使用crystal report
# Modify.........: NO.FUN-7A0020 07/11/07 By zhaijie添加是否打印選擇條件判斷
# Modify.........: No.MOD-960240 09/07/16 By Smapmin 應依訂單項次抓取最後出貨日 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.           09/10/19 By lilingyu r.c2編譯不過
# Modify.........: NO.TQC-A40116 10/04/26 BY liuxqa modify sql
# Modify.........: No:MOD-A70180 10/07/23 By Sarah 權限控管段抓取的欄位fakuser與fakgrup應改為oeauser與oeagrup
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				        # Print condition RECORD
              wc     STRING,                       # Where Condition No.TQC-630166   
              dd     LIKE type_file.num5,               # 最小延遲天數     #No.FUN-680097 SMALLINT
              more   LIKE type_file.chr1                # 特殊列印條件     #No.FUN-680097 VARCHAR(01)
              END RECORD,
          l_amt1        LIKE oeb_file.oeb14
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680097 SMALLINT
DEFINE   g_str           STRING                  #NO.FUN-770008
DEFINE   l_table         STRING                  #NO.FUN-770008
DEFINE   g_sql           STRING                  #NO.FUN-770008
 
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
#NO.FUN-770008  -------------begin------------
   LET g_sql = " oea03.oea_file.oea03,",
               " oea032.oea_file.oea032,",
               " oea01.oea_file.oea01,",
               " oeb03.oeb_file.oeb03,",
               " oeb15.oeb_file.oeb15,",
               " oga02.oga_file.oga02,",
               " oeb12.oeb_file.oeb12,",
               " oeb24.oeb_file.oeb24,",
               " oeb13.oeb_file.oeb13,",
               " ima02.ima_file.ima02,",
               " ima021.ima_file.ima021,",
               " ogb01.ogb_file.ogb01,",
               " oea23.oea_file.oea23,",
               " curr.oea_file.oea24,",
               " azi04.azi_file.azi04"
   LET l_table = cl_prt_temptable('admr100',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-A40116 mod
               " VALUES (?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
            CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#NO.FUN-770008  -------------end -------------
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.dd    = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r100_tm(0,0)	
      ELSE CALL r100()		
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
END MAIN
 
FUNCTION r100_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680097 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680097 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 11 END IF
   OPEN WINDOW r100_w AT p_row,p_col
        WITH FORM "adm/42f/admr100"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.more   = 'N'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
WHILE TRUE
   CONSTRUCT BY NAME  tm.wc ON oea03,oea14,oea15,oea02
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
      CLOSE WINDOW r100_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   INPUT BY NAME tm.dd,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD dd
         IF cl_null(tm.dd) THEN
            NEXT FIELD dd
         END IF
 
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
      CLOSE WINDOW r100_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='admr100'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('admr100','9031',1)   
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
                         " '",tm.dd CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('admr100',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r100_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r100()
   ERROR ""
END WHILE
   CLOSE WINDOW r100_w
END FUNCTION
 
FUNCTION r100()
   DEFINE l_name     LIKE type_file.chr20, 		# External(Disk) file name        #No.FUN-680097 VARCHAR(20)
#       l_time          LIKE type_file.chr8         #No.FUN-6A0100
          l_sql      STRING,		# RDSQL STATEMENT  
          l_za05     LIKE type_file.chr1000,          #No.FUN-680097 VARCHAR(40)
          l_rr       LIKE type_file.num5,             #No.FUN-680097 SMALLINT
          sr         RECORD
                     oea03     LIKE    oea_file.oea03,    #客戶編號
                     oea032    LIKE   oea_file.oea032,    #客戶名稱
                     oea01     LIKE    oea_file.oea01,    #訂單編號
                     oeb03     LIKE    oeb_file.oeb03,    #訂單序號
                     oeb15     LIKE    oeb_file.oeb15,    #預計出貨
                     oga02     LIKE    oga_file.oga02,    #最後出貨日
                     oeb12     LIKE    oeb_file.oeb12,    #訂單量
                     oeb24     LIKE    oeb_file.oeb24,    #已出貨量
                     oeb13     LIKE    oeb_file.oeb13,    #單價
                     ima02     LIKE    ima_file.ima02,    #品名規格
                     ima021    LIKE    ima_file.ima021,   #規格
                     ogb01     LIKE    ogb_file.ogb01,    #出貨單號
                     oea23     LIKE    oea_file.oea23,    #幣別
                     curr      LIKE    oea_file.oea24,    #匯率
                     azi04     LIKE    azi_file.azi04     #
                   END RECORD
     CALL cl_del_data(l_table)                                  #NO.FUN-7A0020
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='admr100'  #NO.FUN-7A0020
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
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')  #MOD-A70180
     #End:FUN-980030
 
     #-----MOD-960240---------
     #LET l_sql = " SELECT oea03,oea032,oea01,oeb03,oeb15,max(oga02),oeb12,oeb24,oeb13,",
     #            "        ima02,ima021,ogb01,oea23,1 ",
     #            " FROM oea_file LEFT OUTER JOIN oga_file ON oea01=oga_file.oga16 AND  oga_file.ogaconf='Y' AND oga_file.ogapost='Y', ",
#  "      oeb_file LEFT OUTER JOIN ogb_file ON oeb03=ogb_file.ogb32 AND oeb01=ogb_file.ogb31 ,ima_file,azi_file  ",   09/10/19
     #            " WHERE oea01=oeb01 AND ",tm.wc CLIPPED ,
     #            "  AND  oeb70='N' AND oeaconf='Y' AND (oeb12-oeb24)>0",
     #            " AND (TODAY - oeb15) > ",tm.dd ,  #CHI-710043 add
     #            " GROUP BY oea03,oea032,oea01,oeb03,oeb15,oeb12,oeb24,",
     #            " oeb13,ima02,ima021,ogb01,oea23"
     LET l_sql = " SELECT oea03,oea032,oea01,oeb03,oeb15,'',oeb12,oeb24,oeb13,",
                 "        ima02,ima021,'',oea23,1 ",
                 " FROM oea_file,oeb_file,ima_file,azi_file ",
                 " WHERE oea01=oeb01 AND ",tm.wc CLIPPED ,
                 "  AND  oeb04 = ima01 AND oea23=azi01",
                 "  AND  oeb70='N' AND oeaconf='Y' AND (oeb12-oeb24)>0",
                 "  AND  ",tm.wc CLIPPED ,
                 " AND (TODAY - oeb15) > ",tm.dd ,  #CHI-710043 add
                 " GROUP BY oea03,oea032,oea01,oeb03,oeb15,oeb12,oeb24,",
                 " oeb13,ima02,ima021,oea23"
     #-----END MOD-960240-----
 
 
     PREPARE r100_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
        EXIT PROGRAM
     END IF
     DECLARE r100_c1 CURSOR FOR r100_p1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('declare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
        EXIT PROGRAM
     END IF
#    CALL cl_outnam('admr100') RETURNING l_name        #NO.FUN-770008
 
#    START REPORT r100_rep TO l_name                   #NO.FUN-770008
     CALL cl_del_data(l_table)                         #NO.FUN-770008
     LET l_amt1 = 0
     LET g_pageno = 0
     FOREACH r100_c1 INTO sr.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       #-----MOD-960240---------
       SELECT max(oga02),ogb01 INTO sr.oga02,sr.ogb01 
         FROM oga_file,ogb_file
        WHERE ogb31 = sr.oea01 AND ogb32 = sr.oeb03 
          AND ogaconf = 'Y' AND ogapost = 'Y'  
          AND oga01 = ogb01
         GROUP BY ogb01
       #-----END MOD-960240-----
        # No.MOD-580014
       SELECT azi04 INTO sr.azi04 FROM azi_file               #No.CHI-6A0004
        WHERE azi01=sr.oea23
        # No.MOD-580014
 
       CALL s_curr3(sr.oea23,g_today,'B')
        RETURNING sr.curr
     EXECUTE insert_prep USING sr.oea03,sr.oea032,
                               sr.oea01,sr.oeb03,
                               sr.oeb15,sr.oga02,
                               sr.oeb12,sr.oeb24,
                               sr.oeb13,sr.ima02,
                               sr.ima021,sr.ogb01,
                               sr.oea23,sr.curr,
                               sr.azi04
                                
#      OUTPUT TO REPORT r100_rep(sr.*)                 #NO.FUN-770008
     END FOREACH
 
#    FINISH REPORT r100_rep                            #NO.FUN-770008
#    IF g_zz05 = 'Y'
#      CALL cl_prt_pos_wc(tm.wc)
#       RETURNING g_wc 
#       RETURNING  tm.wc
        LET g_str = tm.wc
#    END IF
#NO.FUN-7A0020 ----begin--是否打印選擇條件---
     IF g_zz05 ='Y' THEN
       CALL cl_wcchp(tm.wc,'oea03,oea14,oea15,oea02')
       RETURNING tm.wc
     END IF
     LET g_str=tm.wc
#NO.FUN-7A0020 ------end--  
     LET g_str = g_str
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED #NO.FUN-770008
     CALL cl_prt_cs3('admr100','admr100',l_sql,g_str)     #NO.FUN-770008
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)       #NO.FUN-770008
END FUNCTION
#NO.FUN-770008 ----------begin----------
{REPORT r100_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,             #No.FUN-680097 VARCHAR(1)
          l_aa          LIKE oeb_file.oeb14,
          l_amt         LIKE oeb_file.oeb14,
           sr        RECORD
                     oea03     LIKE    oea_file.oea03,    #客戶編號
                     oea032    LIKE    oea_file.oea032,   #客戶名稱
                     oea01     LIKE    oea_file.oea01,    #訂單編號
                     oeb03     LIKE    oeb_file.oeb03,    #訂單序號
                     oeb15     LIKE    oeb_file.oeb15,    #預計出貨
                     oga02     LIKE    oga_file.oga02,    #最後出貨日
                     oeb12     LIKE    oeb_file.oeb12,    #訂單量
                     oeb24     LIKE    oeb_file.oeb24,    #已出貨量
                     oeb13     LIKE    oeb_file.oeb13,    #單價
                     ima02     LIKE    ima_file.ima02,    #品名規格
                     ima021    LIKE    ima_file.ima021,   #規格
                     ogb01     LIKE    ogb_file.ogb01,    #出貨單號
                     oea23     LIKE    oea_file.oea23,    #幣別
                     curr      LIKE    oea_file.oea24,    #匯率
                     azi04     LIKE    azi_file.azi04     #No.CHI-6A0004    
                     END RECORD
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.oea03,sr.oea01,sr.oeb03
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      PRINT
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.oea03
      LET l_amt=0
      PRINT COLUMN g_c[31],sr.oea032;
 
   BEFORE GROUP OF sr.oea01
      PRINT COLUMN g_c[32],sr.oea01;
 
   AFTER GROUP OF sr.oeb03
      LET l_aa=(sr.oeb12-sr.oeb24)*sr.oeb13*sr.curr
      LET l_amt=l_amt+l_aa
      LET l_amt1=l_amt1+l_aa
      PRINT COLUMN g_c[33],sr.oeb15,
            COLUMN g_c[34],sr.oga02,
            COLUMN g_c[35],(g_today - sr.oeb15) CLIPPED USING '#####&',
            COLUMN g_c[36],cl_numfor(l_aa,36,sr.azi04),  #金額               #No.CHI-6A0004
            COLUMN g_c[37],sr.ima02 CLIPPED,
            COLUMN g_c[38],sr.ima021
 
   AFTER GROUP OF sr.oea03
      PRINT g_dash2
      PRINT COLUMN g_c[34],g_x[9] CLIPPED,
            COLUMN g_c[36],cl_numfor(l_amt,36,sr.azi04)
 
   ON LAST ROW
      PRINT g_dash2
      PRINT COLUMN g_c[34],g_x[10] CLIPPED,
            COLUMN g_c[36],cl_numfor(l_amt1,36,sr.azi04)
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
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[38], g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[38], g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
}
#NO.FUN-770008
