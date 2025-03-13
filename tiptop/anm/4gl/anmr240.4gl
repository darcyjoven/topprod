# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: anmr240.4gl
# Descriptions...: 客戶應收票據帳齡分析表
# Date & Author..: 94/05/21  By  Felicity  Tseng
#                    增加選項(1).原幣 (2).本幣
# Modify.........: No.9435 04/04/12 By Kitty 改為只判斷nmh38='Y'
# Modify.........: No.FUN-580010 05/08/02 By will 報表轉XML格式
# Modify.........: No.MOD-640033 06/04/08 By Sarah 依原幣顯示應依幣別分別計算顯示,QBE應加幣別
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: NO.FUN-720013 07/04/02 BY TSD.c123k 改為Crystal Report
# Modify.........: No.FUN-770063 07/07/24 By Sarah 金額小數取位全部都以g_azi05取位
# Modify.........: No.TQC-830031 08/03/27 By Carol l_cmd 型態改為type_file.chr1000
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A40124 10/04/21 By sabrina 若票據未到期，不應印出
# Modify.........: No:TQC-C40085 12/04/13 By yinhy 票齡計算應該為票據到期日期-截止日期
# Modify.........: No:MOD-C40143 12/04/19 By Elise PREPARE r240_prepare1 增加條件 nmh05 >= tm.bdate
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
            wc         STRING, #TQC-630166
            bdate      LIKE type_file.dat,    #No.FUN-680107 DATE
            c          LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
            more       LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
           END RECORD,
	   m_azi05     LIKE azi_file.azi05,
	   m_tot1      LIKE nmh_file.nmh32,
	   m_tot2      LIKE nmh_file.nmh32,
	   m_tot3      LIKE nmh_file.nmh32,
	   m_tot4      LIKE nmh_file.nmh32,
	   m_tot5      LIKE nmh_file.nmh32
 
DEFINE   g_i           LIKE type_file.num5      #count/index for any purpose #No.FUN-680107 SMALLINT
#No.FUN-580010  --begin
#DEFINE   g_dash        VARCHAR(400)   #Dash line
#DEFINE   g_len         SMALLINT    #Report width(79/132/136)
#DEFINE   g_pageno      SMALLINT    #Report page no
#DEFINE   g_zz05        VARCHAR(1)     #Print tm.wc ?(Y/N)
#No.FUN-580010  --end
DEFINE   l_table       STRING       #FUN-720013
DEFINE   g_sql         STRING       #FUN-720013
DEFINE   g_str         STRING       #FUN-720013
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
 
   #FUN-720013 - START
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> FUN-720013 *** ##
   LET g_sql = "tm_c.type_file.chr1,",
               "bdate.type_file.dat,",
               "nmh11.nmh_file.nmh11,",
               "occ02.occ_file.occ02,",
               "nmh03.nmh_file.nmh03,",
               "nmh32.nmh_file.nmh32,",
               "nmh02.nmh_file.nmh02,",
               "l_days.type_file.num5,",
               "nmz23.nmz_file.nmz23,",
               "nmz24.nmz_file.nmz24,",
               "nmz25.nmz_file.nmz25,",
               "nmz26.nmz_file.nmz26,",
               "amt_1.nmh_file.nmh32,",
               "amt_2.nmh_file.nmh32,",
               "amt_3.nmh_file.nmh32,",
               "amt_4.nmh_file.nmh32,",
               "amt_5.nmh_file.nmh32,",
               "g_azi05.azi_file.azi05"   #FUN-770063 add
 
   LET l_table = cl_prt_temptable('anmr240',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?)"   #FUN-770063 add ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------------ CR (1) ------------------------------#
   #FUN-720013 - END
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.bdate  = ARG_VAL(8)
   LET tm.c  = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r240_tm(0,0)
      ELSE CALL r240()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION r240_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01          #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680107 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000       #TQC-830031-modify  #No.FUN-680107 VARCHAR(400)
 
   LET p_row = 4 LET p_col = 12
   OPEN WINDOW r240_w AT p_row,p_col
        WITH FORM "anm/42f/anmr240"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.bdate = g_today
   LET tm.c = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nmh11,nmh16,nmh01,nmh12,nmh04,nmh03   #MOD-640033 add nmh03
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
      CLOSE WINDOW r240_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
 
   DISPLAY BY NAME tm.more
   INPUT BY NAME tm.bdate,tm.c,tm.more  WITHOUT DEFAULTS
      #No.FUN-580031 --start--
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 ---end---
 
      AFTER FIELD bdate
	 IF cl_null(tm.bdate) THEN
	    LET tm.bdate = g_today
	    NEXT FIELD tm.bdate
	 END IF
 
      AFTER FIELD c
         IF tm.c NOT MATCHES '[12]' THEN
            NEXT FIELD c
         END IF
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                           g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
         ON ACTION CONTROLG CALL cl_cmdask()
 
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
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
      CLOSE WINDOW r240_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='anmr240'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr240','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.c CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('anmr240',g_time,l_cmd)
      END IF
      CLOSE WINDOW r240_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r240()
   ERROR ""
END WHILE
   CLOSE WINDOW r240_w
END FUNCTION
 
FUNCTION r240()
DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680107 VARCHAR(20)
#      l_time    LIKE type_file.chr8           #No.FUN-6A0082
       l_sql     LIKE type_file.chr1000,       #No.FUN-680107 VARCHAR(1200)
       l_za05    LIKE type_file.chr1000,       #No.FUN-680107 VARCHAR(40)
       l_nmh05   LIKE nmh_file.nmh05,
       sr   RECORD      nmh11 LIKE nmh_file.nmh11,     	       #客戶
       			nmh03 LIKE nmh_file.nmh03,	       #幣別   #MOD-640033 add
       			nmh32 LIKE nmh_file.nmh32,	       #金額
       			nmh02 LIKE nmh_file.nmh02,	       #金額
			days  LIKE type_file.num5,             #No.FUN-680107 SMALLINT #票齡
                       #FUN-720013 add --------------------------------
                        occ02 LIKE occ_file.occ02,             #簡稱 
       			amt_1 LIKE nmh_file.nmh32,	       #金額
       			amt_2 LIKE nmh_file.nmh32,	       #金額
       			amt_3 LIKE nmh_file.nmh32,	       #金額
       			amt_4 LIKE nmh_file.nmh32,	       #金額
       			amt_5 LIKE nmh_file.nmh32 	       #金額
                       #FUN-720013 end --------------------------------
                 END RECORD,
      #start MOD-640033 add
       sr1  RECORD      nmh11 LIKE nmh_file.nmh11,  	       #客戶
       			nmh03 LIKE nmh_file.nmh03,	       #幣別
       			amt_1 LIKE nmh_file.nmh32,	       #金額
       			amt_2 LIKE nmh_file.nmh32,	       #金額
       			amt_3 LIKE nmh_file.nmh32,	       #金額
       			amt_4 LIKE nmh_file.nmh32,	       #金額
       			amt_5 LIKE nmh_file.nmh32 	       #金額
                 END RECORD 
      #end MOD-640033 add
 
   #FUN-720013 - add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-720013 *** ##
   CALL cl_del_data(l_table)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   #------------------------------ CR (2) ----------------------------------#
   #FUN-720013 - END
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
  #No.FUN-580010  --begin
  #SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'anmr240'
  #IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
  #FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
  #No.FUN-580010  --end
 
  #start MOD-640033 add
   DROP TABLE r240_tmp
  #No.FUN-680107 --start
  #CREATE TEMP TABLE r240_tmp
  #       (nmh11 VARCHAR(10),
  #        nmh03 VARCHAR(4),
  #        amt_1 DEC(20,6),
  #        amt_2 DEC(20,6),
  #        amt_3 DEC(20,6),
  #        amt_4 DEC(20,6),
  #        amt_5 DEC(20,6))
   #No.FUN-680107--欄位類型修改                                                    
   CREATE TEMP TABLE r240_tmp(
    nmh11 LIKE nmh_file.nmh11,
    nmh03 LIKE nmh_file.nmh03,
    amt_1 LIKE type_file.num20_6,
    amt_2 LIKE type_file.num20_6,
    amt_3 LIKE type_file.num20_6,
    amt_4 LIKE type_file.num20_6,
    amt_5 LIKE type_file.num20_6)
   #No.FUN-680107 --end
   #end MOD-640033 add
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND nmhuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND nmhgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN              #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND nmhgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmhuser', 'nmhgrup')
   #End:FUN-980030
 
  #FUN-720013 modify ---------------------------------------------------------------
  #LET l_sql = "SELECT nmh11, nmh03, nmh32, nmh02, nmh05 ",   #MOD-640033 add nmh03
   LET l_sql = "SELECT nmh11, nmh03, nmh32, nmh02, nmh05,'','','','','','' ", 
  #FUN-720013 end -------------------------------------------------------------
               " FROM nmh_file ",
               " WHERE ", tm.wc CLIPPED,
               "   AND nmh04 <= '",tm.bdate,"'",
               "   AND nmh05 >= '",tm.bdate,"'",  #MOD-C40143 add
               "   AND nmh38 =  'Y' ",     #No:9435
               "   AND (nmh35 IS NULL OR nmh35 > '",tm.bdate,"')"
              ," ORDER BY nmh11,nmh03"   #MOD-640033 add
#  LET l_sql = l_sql CLIPPED," ORDER BY apa01"
   PREPARE r240_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   DECLARE r240_curs1 CURSOR FOR r240_prepare1
 
   SELECT azi05 INTO g_azi05 FROM azi_file WHERE azi01 = g_aza.aza17    
   LET m_tot1 = 0 LET m_tot2 = 0 LET m_tot3 = 0 LET m_tot4 = 0
   LET m_tot5 = 0
 
   FOREACH r240_curs1 INTO sr.nmh11,sr.nmh03,sr.nmh32,sr.nmh02,l_nmh05   #MOD-640033 add sr.nmh03
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      IF cl_null(sr.nmh32) OR sr.nmh32 = 0 THEN CONTINUE FOREACH END IF
      IF cl_null(sr.nmh02) OR sr.nmh02 = 0 THEN CONTINUE FOREACH END IF
      IF tm.c='1' THEN
         LET sr.nmh32=sr.nmh02
      END IF
      #LET sr.days = tm.bdate - l_nmh05  #TQC-C40085 mark
      LET sr.days = l_nmh05 - tm.bdate   #TQC-C40085 
   
     # FUN-720013 mod ------------------------------------
      #先將變數值都清為0
      LET sr.amt_1 = 0
      LET sr.amt_2 = 0
      LET sr.amt_3 = 0
      LET sr.amt_4 = 0
      LET sr.amt_5 = 0
 
     #MOD-A40124---add---start---
      IF sr.days < 0 THEN
         CONTINUE FOREACH
      END IF
     #MOD-A40124---add---end---
      IF sr.days <= g_nmz.nmz23 THEN
         LET sr.amt_1 = sr.nmh32
      END IF
      IF sr.days > g_nmz.nmz23  AND sr.days <= g_nmz.nmz24 THEN
         LET sr.amt_2 = sr.nmh32
      END IF
      IF sr.days > g_nmz.nmz24  AND sr.days <= g_nmz.nmz25 THEN
         LET sr.amt_3 = sr.nmh32
      END IF
      IF sr.days > g_nmz.nmz25  AND sr.days <= g_nmz.nmz26 THEN
         LET sr.amt_4 = sr.nmh32
      END IF
      IF sr.days > g_nmz.nmz26 THEN
         LET sr.amt_5 = sr.nmh32
      END IF
 
      IF cl_null(sr.amt_1) THEN LET sr.amt_1 = 0 END IF
      IF cl_null(sr.amt_2) THEN LET sr.amt_2 = 0 END IF
      IF cl_null(sr.amt_3) THEN LET sr.amt_3 = 0 END IF
      IF cl_null(sr.amt_4) THEN LET sr.amt_4 = 0 END IF
      IF cl_null(sr.amt_5) THEN LET sr.amt_5 = 0 END IF
 
      #客戶簡稱
      SELECT occ02 INTO sr.occ02 FROM occ_file WHERE occ01 = sr.nmh11
 
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-720013 *** #
      EXECUTE insert_prep USING
         tm.c,       tm.bdate,   sr.nmh11,sr.occ02,   sr.nmh03, 
         sr.nmh32,   sr.nmh02,   sr.days, g_nmz.nmz23,g_nmz.nmz24,
         g_nmz.nmz25,g_nmz.nmz26,sr.amt_1,sr.amt_2,   sr.amt_3,     
         sr.amt_4,   sr.amt_5,   g_azi05   #FUN-770063 add g_azi05
      #------------------------------ CR (3) -------------------------------
     # FUN-720013 end ------------------------------------
 
   END FOREACH
 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = ''
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'nmh11,nmh16,nmh01,nmh12,nmh04,nmh03')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
 
   IF tm.c = '1' THEN   #原幣
      CALL cl_prt_cs3('anmr240','anmr240',l_sql,g_str) 
   ELSE                 #本幣
      CALL cl_prt_cs3('anmr240','anmr240_2',l_sql,g_str) 
   END IF
   #------------------------------ CR (4) ------------------------------#
 
END FUNCTION
