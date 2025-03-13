# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: acor212.4gl
# Descriptions...: 成品出入庫客戶明細帳
# Date & Author..: 05/02/05 by ice
# Modify.........: No.FUN-550036 05/05/19 By day   單據編號加大
# Modify.........: No.FUN-560011 05/06/03 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.MOD-560026 05/06/07 By wujie 增加對日期變量l_date_cnd為空時的判斷
# Modify.........: No.TQC-610082 06/04/19 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-840238 08/05/15 By TSD.lucasyeh
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
# Modify.........: No.TQC-930036 09/03/11 By mike 解決溢位問題
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
             wc     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(300)
             wc1    LIKE type_file.chr1000,        #No.FUN-680069 VARCHAR(100)
             y1     LIKE type_file.dat,          #No.FUN-680069 DATE
             y2     LIKE type_file.dat,          #No.FUN-680069 DATE
             y      LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
             more   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
           END RECORD
DEFINE  g_i         LIKE type_file.num5          #No.FUN-680069 SMALLINT
DEFINE  l_wc        LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(300)
DEFINE  l_i         LIKE type_file.num5          #No.FUN-680069 SMALLINT
DEFINE  g_sql       STRING,      #FUN-840238 add
        g_str       STRING,      #FUN-840238 add
        l_table     STRING       #FUN-840238 add
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.wc1   = ARG_VAL(8)
   LET tm.y1    = ARG_VAL(9)
   LET tm.y2    = ARG_VAL(10)
   LET tm.y     = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
 
  #FUN-840238 add-start
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
    LET g_sql = "coc03.coc_file.coc03,",    #手冊編號-sr
                "cob01.cob_file.cob01,",    #商品編號-sr
                "cob09.cob_file.cob09,",    #HS code-sr
                "cob02.cob_file.cob02,",    #品名-sr
                "cob021.cob_file.cob021,",  #規格-sr
                "cob04.cob_file.cob04,",    #合同單位-sr
                "coo05.coo_file.coo05,",    #客戶編號-sr
                "coo06.coo_file.coo06,",    #客戶簡稱-sr
                "dt.type_file.dat,",        #單據日期
                "smtdesc.gbc_file.gbc05,",  #單據名稱
                "billno.qcs_file.qcs01,",   #單據編號
                "unit.cob_file.cob04,",     #單位
                "coo14.coo_file.coo14,",    #異動數量
                "coo16.coo_file.coo16,",    #異動數量(合同)
                "cnp05.cnp_file.cnp05,",      #報關數量
                "l_sum1.coo_file.coo16,",   #合同結余
                "l_sum4.coo_file.coo16,",   #出貨合同累計
                "l_sum5.cnp_file.cnp05,",     #出貨累計
                "l_sum01.coo_file.coo16,",  #合同結余-頁首
                "l_sum04.coo_file.coo16,",  #出貨合同累計-頁首
                "l_sum05.cnp_file.cnp05"    #出貨累計-頁首
                                            #21 items
 
   LET l_table = cl_prt_temptable('acor212',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?)"
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
   INITIALIZE tm.* TO NULL                # Default condition
 
   IF cl_null(g_bgjob) or g_bgjob = 'N'
      THEN CALL acor212_tm(0,0)
      ELSE CALL acor212()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION acor212_tm(p_row,p_col)
 
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680069 SMALLINT
       l_cmd          LIKE type_file.chr1000        #No.FUN-680069 VARCHAR(400)
 
   OPEN WINDOW acor212_w WITH FORM "aco/42f/acor212"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.y    = 'N'
   LET tm.y1   = g_today
   LET tm.y2   = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies= '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON  cob09,coc03,cob01,coo05
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
            LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            EXIT CONSTRUCT
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
          ON ACTION help                    #MOD-4C0121
             CALL cl_show_help()            #MOD-4C0121
 
          ON ACTION controlg                #MOD-4C0121
             CALL cl_cmdask()               #MOD-4C0121
 
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
         LET INT_FLAG = 0 CLOSE WINDOW acor212_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
         EXIT PROGRAM
            
      END IF
      IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
      INPUT BY NAME tm.y1,tm.y2,tm.y,tm.more  WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIElD y1
         IF cl_null(tm.y1) THEN
            NEXT FIELD y1
         END IF
 
      AFTER FIELD y2
         IF cl_null(tm.y2) OR tm.y2 < tm.y1 THEN
            NEXT FIELD y2
         END IF
      AFTER FIELD y
         IF tm.y NOT MATCHES "[YN]"
            THEN NEXT FIELD FORMONLY.y
         END IF
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]"
            THEN NEXT FIELD FORMONLY.more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()     # Command execution
 
      AFTER INPUT
 
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
      LET INT_FLAG = 0 CLOSE WINDOW acor212_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
       WHERE zz01='acor212'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('acor212','9031',1)
      ELSE
         LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                    " '",g_pdate CLIPPED,"'",
                    " '",g_towhom CLIPPED,"'",
                    " '",g_lang CLIPPED,"'",
                    " '",g_bgjob CLIPPED,"'",
                    " '",g_prtway CLIPPED,"'",
                    " '",g_copies CLIPPED,"'",
                    " '",tm.wc CLIPPED,"'",
                    " '",tm.wc1 CLIPPED,"'",             #No.TQC-610082 add 
                    " '",tm.y1 CLIPPED,"'",              #No.TQC-610082 add
                    " '",tm.y2 CLIPPED,"'",              #No.TQC-610082 add
                    " '",tm.y  CLIPPED,"'",              #No.TQC-610082 add
                    " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                    " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                    " '",g_template CLIPPED,"'"            #No.FUN-570264
 
         CALL cl_cmdat('acor212',g_time,l_cmd)    # Execute cmd at later time
      END IF
   CLOSE WINDOW acor212_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
   EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL acor212()
   END WHILE
   CLOSE WINDOW acor212_w
END FUNCTION
 
FUNCTION acor212()
   DEFINE l_name    LIKE type_file.chr20,        #No.FUN-680069 VARCHAR(20) # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0063
          l_sql     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(1200)
          l_za05    LIKE za_file.za05,
          l_order   ARRAY[5] OF LIKE adj_file.adj02,  #No.FUN-680069 VARCHAR(20)
          sr        RECORD
                       coc03   LIKE coc_file.coc03,
                       cob01   LIKE cob_file.cob01,
                       cob09   LIKE cob_file.cob09,
                       cob02   LIKE cob_file.cob02,
                       cob021  LIKE cob_file.cob021,
                       cob04   LIKE cob_file.cob04,
                       coo05   LIKE coo_file.coo05,
                       coo06   LIKE coo_file.coo06
                    END RECORD,
          sr1       RECORD
                       dt      LIKE type_file.dat,     #No.FUN-680069 DATE
                      #smtdesc VARCHAR(20),               #No.FUN-550036
                       smtdesc LIKE gbc_file.gbc05,    #No.FUN-680069 VARCHAR(80) #No.FUN-560011
                       billno  LIKE qcs_file.qcs01,    #No.FUN-680069 VARCHAR(16) #No.FUN-550036
                       cob02   LIKE cob_file.cob02,
                       unit    LIKE cob_file.cob04,
                       coo14   LIKE coo_file.coo14,
                       coo16   LIKE coo_file.coo16,
                       cnp05   LIKE cnp_file.cnp05,
                       coc03   LIKE coc_file.coc03,
                       cob01   LIKE cob_file.cob01,
                       coo05   LIKE coo_file.coo05,
                       coo06   LIKE coo_file.coo06,
                       coo10   LIKE coo_file.coo10,   #控制cop14打印
                       cno031  LIKE cno_file.cno031   #控制cnp05打印
                    END RECORD
#FUN-840238 add-start
   DEFINE l_sum1       LIKE coo_file.coo16,         #No.FUN-680069 DEC(13,2) #合同結余
          l_sum4       LIKE coo_file.coo16,         #No.FUN-680069 DEC(13,2) #出貨合同累計
          l_sum5       LIKE cnp_file.cnp05,         #No.FUN-680069 DEC(13,2) #出貨累計
          l_sum01       LIKE coo_file.coo16,         #合同結余 CR頁首
          l_sum04       LIKE coo_file.coo16,         #出貨合同累計 CR頁首
          l_sum05       LIKE cnp_file.cnp05,         #出貨累計 CR頁首
          l_title      LIKE cob_file.cob08,         #No.FUN-680069 VARCHAR(30)
          l_yy         LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_mm         LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_py         LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_pm         LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_bdate      LIKE type_file.dat,          #No.FUN-680069 DATE
          l_edate      LIKE type_file.dat,          #No.FUN-680069 DATE
          l_date_cnd   LIKE type_file.num10,        #No.FUN-680069 INTEGER
          l_cob01_t    LIKE cob_file.cob01,
          l_cob09_t    LIKE cob_file.cob09,
          l_coc03_t    LIKE coc_file.coc03,
          l_coo05_t    LIKE coo_file.coo05
 
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
     CALL cl_del_data(l_table)
     #------------------------------ CR (2) ------------------------------#
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog #其他列印條件
 
#FUN-840238 add-end
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN
   #      LET tm.wc = tm.wc clipped," AND cobuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN
   #      LET tm.wc = tm.wc clipped," AND cobgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND cobgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('cobuser', 'cobgrup')
   #End:FUN-980030
 
   LET l_wc = tm.wc
 
#TQC-930036  -----start
  #FOR l_i = 1 TO 296
  #    IF l_wc[l_i,l_i+4] = 'coo05' THEN
  #       LET l_wc[l_i,l_i+4] = 'cno08'
  #    END IF
  #END FOR
   LET l_wc=cl_replace_str(l_wc,"coo05","cno08")
#TQC-930036  ----end
 
      LET l_sql = "SELECT DISTINCT coc03,cob01,cob09,cob02,cob021,cob04,     ",
                  "       coo05,coo06  ",
                  "  FROM coc_file,cod_file,cob_file,coo_file    ",
                  " WHERE cod03 = cob01 AND cod01 = coc01",
                  "   AND cob01 = coo11 ",
                  "   AND coo18 = coc03 ",
                  "   AND coo10 IN ('0','1','2','5','6','7') ",
                  "   AND coo03 BETWEEN '",tm.y1,"' AND '",tm.y2,"' ",
                  "   AND cooacti = 'Y'   ",
                  "   AND cooconf = 'Y'   ",
                  "   AND cocacti = 'Y'   ",
                  "   AND cobacti = 'Y'   ",
                  "   AND ", tm.wc CLIPPED,
                  " UNION      ",
                  "SELECT DISTINCT coc03,cob01,cob09,cob02,cob021,cob04,     ",
                  "       cno08,cno09  ",
                  "  FROM coc_file,cod_file,cob_file,cno_file,cnp_file   ",
                  " WHERE cod03 = cob01 AND cod01 = coc01",
                  "   AND cob01 = cnp03   AND cno10 = coc03    ",
                  "   AND cnp01 = cno01   ",
                  "   AND cnoacti = 'Y'    ",
                  "   AND cnoconf = 'Y'    ",
                  "   AND cocacti = 'Y'   ",
                  "   AND cobacti = 'Y'   ",
                  "   AND cno03 = '1' AND cno031 IN ('1','2')  ",
                  "   AND cno04 IN ('1','2','4') ",
                  "   AND cno02 BETWEEN '",tm.y1,"' AND '",tm.y2,"' ",
                  "   AND ", l_wc CLIPPED
     IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
     PREPARE acor212_pre1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM 
     END IF
     DECLARE acor212_cs1 CURSOR FOR acor212_pre1
 
     LET l_sql = "SELECT coo03,smydesc,coo01,cob02,coo15,coo14,  ",
                 "       coo16,0,coc03,cob01,coo05,coo06,coo10,''  ",
                 "  FROM cob_file,coc_file,cod_file,coo_file LEFT OUTER JOIN smy_file ON coo01 like ltrim(rtrim(smy_file.smyslip))||'-%' ",
                 " WHERE cod03 = cob01 AND cod01 = coc01    ",
                 "   AND coo18 = coc03  AND cob01 = coo11    ",
                 "   AND coo10 IN ('0','1','2','5','6','7') ",
#No.FUN-550036--begin
#                "   AND smy_file.smyslip = coo01[1,3]   ",
#No.FUN-550036--end
                 "   AND coo18 = ?  AND coo11 = ?  AND coo05 = ?  ",
                 "   AND cooacti = 'Y'   ",
                 "   AND cooconf = 'Y'   ",
                 "   AND cocacti = 'Y'   ",
                 "   AND cobacti = 'Y'   ",
                 "   AND coo03 BETWEEN '",tm.y1,"' AND '",tm.y2,"' ",
                 "   AND ", tm.wc CLIPPED,
                 " ORDER BY coo03 "
     PREPARE r212_pre2 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare2:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM 
     END IF
     DECLARE r212_cs2 CURSOR FOR r212_pre2
 
     LET l_sql = "SELECT cno02,smydesc, cno01,cob02,cnp06,  ",
                 "       0, 0,cnp05,coc03,cob01,cno08,cno09,'',cno031  ",
                 "  FROM cnp_file,cob_file,cod_file,coc_file, cno_file LEFT OUTER JOIN smy_file ON cno01 like ltrim(rtrim(smy_file.smyslip))||'-%' ",
                 " WHERE cod03 = cob01  AND cod01 = coc01 ",
                 "   AND cob01 = cnp03  AND cno10 = coc03   ",
                 "   AND cnp01 = cno01    ",
#No.FUN-550036--begin
#                "   AND smy_file.smyslip = cno01[1,3]  ",
#No.FUN-550036--end
                 "   AND cno10 = ? AND cnp03 = ? AND cno08 = ?   ",
                 "   AND cno03 = '1' AND cno031 IN ('1','2')  ",
                 "   AND cno04 IN ('1','2','4') ",
                 "   AND cnoacti = 'Y'    ",
                 "   AND cnoconf = 'Y'    ",
                 "   AND cocacti = 'Y'   ",
                 "   AND cobacti = 'Y'   ",
                 "   AND cno02 BETWEEN '",tm.y1,"' AND '",tm.y2,"' ",
                 "   AND ", l_wc CLIPPED,
                 "  ORDER BY cno02 "
     PREPARE r212_pre3 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare3:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM 
     END IF
     DECLARE r212_cs3 CURSOR FOR r212_pre3
#    CALL cl_outnam('acor212') RETURNING l_name    #FUN-840238 mark
 
     DROP TABLE r212_temp
#No.FUN-680069-begin
     CREATE TEMP TABLE r212_temp(
         dt      LIKE type_file.dat,   
         smtdesc LIKE type_file.chr1000,
         billno  LIKE type_file.chr1000,
         cob02   LIKE cob_file.cob02,
         unit    LIKE qcf_file.qcf062,
         coo14   LIKE coo_file.coo14,
         coo16   LIKE coo_file.coo16,
         cnp05   LIKE cnp_file.cnp05,
         coc03   LIKE coc_file.coc03,
         cob01   LIKE cob_file.cob01,
         coo05   LIKE coo_file.coo05,
         coo06   LIKE coo_file.coo06,
         coo10   LIKE coo_file.coo10,
         cno031  LIKE cno_file.cno031)
#No.FUN-680069-end
#    START REPORT acor212_rep TO l_name  #FUN-840238  mark
#    LET g_pageno = 0                    #FUN-840238  mark
#    DELETE FROM r212_temp               #FUN-840238  mark
     FOREACH acor212_cs1 INTO sr.*
        IF SQLCA.sqlcode  THEN
           CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
        END IF
   #FUN-840238 add---start
        DELETE FROM r212_temp
        LET l_cob01_t = ' '
        LET l_cob09_t = ' '
        LET l_coc03_t = ' '
        LET l_coo05_t = ' '
   #FUN-840238 add---end
        FOREACH r212_cs2 USING sr.coc03,sr.cob01,sr.coo05 INTO sr1.*
           IF SQLCA.sqlcode  THEN
              CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
           END IF
           IF (cl_null(sr1.coc03) AND cl_null(sr1.cob01) ) THEN
              CONTINUE FOREACH
           ELSE
              INSERT INTO r212_temp VALUES(sr1.*)
           END IF
        END FOREACH
        FOREACH r212_cs3 USING sr.coc03,sr.cob01,sr.coo05 INTO sr1.*
           IF SQLCA.sqlcode  THEN
              CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
           END IF
           IF (cl_null(sr1.coc03) AND cl_null(sr1.cob01) ) THEN
              CONTINUE FOREACH
           ELSE
              INSERT INTO r212_temp VALUES(sr1.*)
           END IF
        END FOREACH
 
        LET l_sql = " SELECT * FROM r212_temp ORDER BY dt"  #FUN840238 add ORDER BY ROW ID
        PREPARE r212_pre4 FROM l_sql
        DECLARE r212_cs4 CURSOR FOR r212_pre4
        FOREACH r212_cs4 INTO sr1.*
      #FUN-840238 add-start
          IF (sr.coc03 = sr1.coc03 AND sr.cob01 = sr1.cob01 AND sr.coo05 = sr1.coo05)  THEN
              IF (sr.coc03 <> l_coc03_t OR sr.cob01 <> l_cob01_t OR sr.coo05 <> l_coo05_t ) THEN
                 #OR sr.coo05 <> l_coo05_t ) THEN
 
                  LET l_cob01_t = ' '
                  LET l_cob09_t = ' '
                  LET l_coc03_t = ' '
                  LET l_coo05_t = ' '
                  LET l_sum1 = 0
                  LET l_sum4 = 0
                  LET l_sum5 = 0
 
                 # 出貨合同累計和出口累計
                  LET g_sql = "SELECT MAX(cnd03*12+cnd04) FROM cnd_file ",
                              " WHERE (cnd03*12+cnd04)<=YEAR('",tm.y1,"')*12+MONTH('",tm.y1,"')",
                              " AND cnd01 = '",sr.cob01,"' AND cnd02 = '",sr.coc03,"'",
                              " AND cnd05 = '4' AND cnd06 = '1' ",
                              " AND cndacti = 'Y' ",
                              " AND cnd07 = '",sr.coo05,"'"
 
                  PREPARE r212_cnd FROM g_sql
                  IF SQLCA.sqlcode !=0 THEN
                     CALL cl_err('r212_cnd:',SQLCA.sqlcode,1)
                     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
                     EXIT PROGRAM
                  END IF
                  DECLARE r212_cscnd CURSOR FOR r212_cnd
                  OPEN r212_cscnd
                  FETCH r212_cscnd INTO l_date_cnd
             #No.MOD-560026--begin
                  LET g_sql = "SELECT cnd10,cnd09 FROM cnd_file ",
                              " WHERE cnd01 = '",sr.cob01,"' AND cnd02 = '",sr.coc03,"'",
                              "   AND cnd05 = '4' AND cnd06 = '1' ",
                              "   AND cnd07 = '",sr.coo05 ,"'",
                              "   AND cndacti = 'Y' "
                  IF l_date_cnd THEN
                     LET g_sql = g_sql,"   AND (cnd03*12+cnd04) = ",l_date_cnd
                  END IF
            #No.MOD-560026--end
                  PREPARE r212_xx1 FROM g_sql
                  IF SQLCA.sqlcode !=0 THEN
                     CALL cl_err('xx1:',SQLCA.sqlcode,1)
                     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
                     EXIT PROGRAM
                  END IF
                  DECLARE r212_csxx CURSOR FOR r212_xx1
                  OPEN r212_csxx
                  FETCH r212_csxx INTO l_sum4,l_sum5
                  IF cl_null(l_sum4) THEN LET l_sum4 = 0 END IF
                  IF cl_null(l_sum5) THEN LET l_sum5 = 0 END IF
                  LET l_sum1 = l_sum4 - l_sum5
                  LET l_cob01_t = sr.cob01
                  LET l_cob09_t = sr.cob09
                  LET l_coc03_t = sr.coc03
                  LET l_coo05_t = sr.coo05
 
                  IF cl_null(l_sum1) THEN LET l_sum1=0 END IF
                  IF cl_null(l_sum4) THEN LET l_sum4=0 END IF
                  IF cl_null(l_sum5) THEN LET l_sum5=0 END IF
                  LET l_sum01 = l_sum1
                  LET l_sum04 = l_sum4
                  LET l_sum05 = l_sum5
 
              END IF
              IF (sr1.coo10 MATCHES '[012]') THEN
                 LET sr1.coo14 = sr1.coo14
                 LET sr1.coo16 = sr1.coo16
                 IF cl_null(sr1.coo14) THEN LET sr1.coo14=0 END IF
                 IF cl_null(sr1.coo16) THEN LET sr1.coo16=0 END IF
                 LET l_sum1 = l_sum1 + sr1.coo16
              END IF
              IF (sr1.coo10 MATCHES '[567]') THEN
                 LET sr1.coo14 = -sr1.coo14
                 LET sr1.coo16 = -sr1.coo16
                 IF cl_null(sr1.coo14) THEN LET sr1.coo14=0 END IF
                 IF cl_null(sr1.coo16) THEN LET sr1.coo16=0 END IF
                 LET l_sum1 = l_sum1 + sr1.coo16
              END IF
              IF (sr1.cno031 = '1') THEN
                 LET sr1.cnp05 = sr1.cnp05
                 IF cl_null(sr1.cnp05) THEN LET sr1.cnp05=0 END IF
                 LET l_sum1 = l_sum1 + sr1.cnp05
              END IF
              IF (sr1.cno031 = '2') THEN
                 LET sr1.cnp05 = -sr1.cnp05
                 IF cl_null(sr1.cnp05) THEN LET sr1.cnp05=0 END IF
                 LET l_sum1 = l_sum1 + sr1.cnp05
              END IF
              LET l_sum4 = l_sum4 + sr1.coo16
              LET l_sum5 = l_sum5 + sr1.cnp05
 
#             IF cl_null(l_sum1) THEN LET l_sum1=0 END IF
#             IF cl_null(l_sum4) THEN LET l_sum4=0 END IF
#             IF cl_null(l_sum5) THEN LET l_sum5=0 END IF
#             IF cl_null(l_sum01) THEN LET l_sum01 = 0 END IF
#             IF cl_null(l_sum04) THEN LET l_sum04 = 0 END IF
#             IF cl_null(l_sum05) THEN LET l_sum05 = 0 END IF
             ###----------------------與CR串聯段---------------------------###
              EXECUTE insert_prep USING sr.*,
             #EXECUTE insert_prep USING l_coc03_t, l_cob01_t,   l_cob09_t,
             #                          sr.cob02,  sr.cob021,   l_coo05_t,
             #                          sr.coo05,  sr.coo06,
                                        sr1.dt,    sr1.smtdesc, sr1.billno,
                                        sr1.unit,  sr1.coo14,   sr1.coo16,
                                        sr1.cnp05,
                                        l_sum1,   l_sum4,      l_sum5,
                                        l_sum01,  l_sum04,     l_sum05
              IF SQLCA.sqlcode  THEN
                 CALL cl_err('insert_prep:',STATUS,1) EXIT FOREACH
              END IF
           ###----------------------CR (3)----------------------------###
         ###----------------------與CR串聯段---------------------------###
          END IF
 
      #FUN-840238 add-end
 
#          OUTPUT TO REPORT acor212_rep(sr.*,sr1.*) #FUN-840238 mark
        END FOREACH
     END FOREACH
 
     #FUN-840238  ---start---
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED  
#                " ORDER BY coc03,cob01,cob09,coo05"
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'')
             RETURNING tm.wc
        LET g_str = tm.wc 
     END IF
     LET g_str = g_str,";",tm.y,";",tm.y1,";",tm.y2
     CALL cl_prt_cs3('acor212','acor212',l_sql,g_str)
        #------------------------------ CR (4) ------------------------------#
     #FUN-840238  ----end----  
 
#    FINISH REPORT acor212_rep                   #FUN-840238 mark
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len) #FUN-840238 mark
END FUNCTION
 
#FUN-840238 mark-start
{
REPORT acor212_rep(sr,sr1)
   DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
          l_sum1       LIKE coo_file.coo16,         #No.FUN-680069 DEC(13,2) #合同結余
          l_sum4       LIKE coo_file.coo16,         #No.FUN-680069 DEC(13,2) #出貨合同累計
          l_sum5       LIKE cnp_file.cnp05,         #No.FUN-680069 DEC(13,2) #出貨累計
          l_title      LIKE cob_file.cob08,         #No.FUN-680069 VARCHAR(30)
          l_yy         LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_mm         LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_py         LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_pm         LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_bdate      LIKE type_file.dat,          #No.FUN-680069 DATE
          l_edate      LIKE type_file.dat,          #No.FUN-680069 DATE
          l_date_cnd   LIKE type_file.num10,        #No.FUN-680069 INTEGER
          l_cob01_t    LIKE cob_file.cob01,
          l_cob09_t    LIKE cob_file.cob09,
          l_coc03_t    LIKE coc_file.coc03,
          l_coo05_t    LIKE coo_file.coo05,
          sr        RECORD
                       coc03   LIKE coc_file.coc03,
                       cob01   LIKE cob_file.cob01,
                       cob09   LIKE cob_file.cob09,
                       cob02   LIKE cob_file.cob02,
                       cob021  LIKE cob_file.cob021,
                       cob04   LIKE cob_file.cob04,
                       coo05   LIKE coo_file.coo05,
                       coo06   LIKE coo_file.coo06
                    END RECORD,
          sr1       RECORD
                       dt      LIKE type_file.dat,     #No.FUN-680069 DATE
                      # smtdesc VARCHAR(20),              #No.FUN-550036
                       smtdesc LIKE gbc_file.gbc05,    #No.FUN-680069 VARCHAR(80) #No.FUN-560011
                       billno  LIKE qcs_file.qcs01,    #No.FUN-680069 VARCHAR(16) #No.FUN-550036
                       cob02   LIKE cob_file.cob02,
                       unit    LIKE cob_file.cob04,
                       coo14   LIKE coo_file.coo14,
                       coo16   LIKE coo_file.coo16,
                       cnp05   LIKE cnp_file.cnp05,
                       coc03   LIKE coc_file.coc03,
                       cob01   LIKE cob_file.cob01,
                       coo05   LIKE coo_file.coo05,
                       coo06   LIKE coo_file.coo06,
                       coo10   LIKE coo_file.coo10,   #控制cop14打印
                       cno031  LIKE cno_file.cno031   #控制cnp05打印
                    END RECORD
 
   OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
   ORDER BY sr.coc03,sr.cob01,sr.cob09,sr.coo05
   FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<', "/pageno"
      PRINT g_head CLIPPED, pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1, g_x[1]
      PRINT g_x[9],sr.coc03
      IF (tm.y = 'N') THEN
          PRINT COLUMN 1,   g_x[10],sr.cob01,
                COLUMN 17,  g_x[11],sr.cob02
      ELSE
          PRINT COLUMN 1,   g_x[10],sr.cob09,
                COLUMN 17,  g_x[11],sr.cob02
      END IF
      PRINT COLUMN 01,g_x[20],sr.cob021
      PRINT COLUMN 01,g_x[12],sr.coo05,
            COLUMN length(g_x[12])+FGL_WIDTH(sr.coo05)+2, sr.coo06
      PRINT COLUMN 01,g_x[13],
            COLUMN (g_len-21)/2, g_x[14],
            COLUMN (g_len-32)/2, tm.y1,'-',tm.y2,
            COLUMN 121,     g_x[15],sr.cob04
      PRINT g_dash[1,g_len]
      PRINT COLUMN r212_getStartPos(36,38,g_x[16]),g_x[16],
            COLUMN r212_getStartPos(39,40,g_x[17]),g_x[17]
      PRINT COLUMN g_c[36],g_dash2[1,g_w[36]+g_w[37]+g_w[38]+2],
            COLUMN g_c[39],g_dash2[1,g_w[39]+g_w[40]+1]
      PRINT g_x[31],g_x[32],g_x[33],g_x[35],
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
            g_x[41]
      PRINT g_dash1
   LET l_last_sw='n'
   LET l_cob01_t = ' '
   LET l_cob09_t = ' '
   LET l_coc03_t = ' '
   LET l_coo05_t = ' '
   LET l_sum1 = 0
   LET l_sum4 = 0
   LET l_sum5 = 0
   BEFORE GROUP OF sr.coc03
         SKIP TO TOP OF PAGE
   BEFORE GROUP OF sr.cob01
         SKIP TO TOP OF PAGE
   BEFORE GROUP OF sr.coo05
         SKIP TO TOP OF PAGE
   ON EVERY ROW
   IF (sr.coc03 = sr1.coc03 AND sr.cob01 = sr1.cob01 AND sr.coo05 = sr1.coo05)  THEN
 # IF (sr1.coc03 = sr.coc03 AND sr1.cob01 = sr.cob01 AND sr1.coo05 = sr.coo05)  THEN
       IF (sr.coc03 <> l_coc03_t OR sr.cob01 <> l_cob01_t
            OR sr.coo05 <> l_coo05_t ) THEN
           # 出貨合同累計和出口累計
       LET g_sql = "SELECT MAX(cnd03*12+cnd04) FROM cnd_file ",
                   " WHERE (cnd03*12+cnd04)<=YEAR('",tm.y1,"')*12+MONTH('",tm.y1,"')",
                   " AND cnd01 = '",sr.cob01,"' AND cnd02 = '",sr.coc03,"'",
                   " AND cnd05 = '4' AND cnd06 = '1' ",
                   " AND cndacti = 'Y' ",
                   " AND cnd07 = '",sr.coo05,"'"
 
       PREPARE r212_cnd FROM g_sql
       IF SQLCA.sqlcode !=0 THEN
           CALL cl_err('r212_cnd:',SQLCA.sqlcode,1)
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
           EXIT PROGRAM
       END IF
       DECLARE r212_cscnd CURSOR FOR r212_cnd
       OPEN r212_cscnd
       FETCH r212_cscnd INTO l_date_cnd
 #No.MOD-560026--begin
       LET g_sql = "SELECT cnd10,cnd09 FROM cnd_file ",
                   " WHERE cnd01 = '",sr.cob01,"' AND cnd02 = '",sr.coc03,"'",
                   "   AND cnd05 = '4' AND cnd06 = '1' ",
                   "   AND cnd07 = '",sr.coo05 ,"'",
                   "   AND cndacti = 'Y' "
       IF l_date_cnd THEN
          LET g_sql = g_sql,"   AND (cnd03*12+cnd04) = ",l_date_cnd
       END IF
 #No.MOD-560026--end
       PREPARE r212_xx1 FROM g_sql
       IF SQLCA.sqlcode !=0 THEN
           CALL cl_err('xx1:',SQLCA.sqlcode,1)
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
           EXIT PROGRAM
       END IF
       DECLARE r212_csxx CURSOR FOR r212_xx1
       OPEN r212_csxx
       FETCH r212_csxx INTO l_sum4,l_sum5
       IF cl_null(l_sum4) THEN LET l_sum4 = 0 END IF
       IF cl_null(l_sum5) THEN LET l_sum5 = 0 END IF
       LET l_sum1 = l_sum4 - l_sum5
         PRINT COLUMN g_c[31],  g_x[19],
               COLUMN g_c[38],  l_sum4 USING '-----------&.&&',
               COLUMN g_c[40],  l_sum5 USING '-----------&.&&',
               COLUMN g_c[41],  l_sum1 USING '-----------&.&&'
         LET l_cob01_t = sr.cob01
         LET l_cob09_t = sr.cob09
         LET l_coc03_t = sr.coc03
         LET l_coo05_t = sr.coo05
      END IF
      IF (sr1.coo10 MATCHES '[012]') THEN
        LET sr1.coo14 = sr1.coo14
        LET sr1.coo16 = sr1.coo16
        LET l_sum1 = l_sum1 + sr1.coo16
      END IF
      IF (sr1.coo10 MATCHES '[567]') THEN
        LET sr1.coo14 = -sr1.coo14
        LET sr1.coo16 = -sr1.coo16
        LET l_sum1 = l_sum1 + sr1.coo16
      END IF
      IF (sr1.cno031 = '1') THEN
        LET sr1.cnp05 = sr1.cnp05
        LET l_sum1 = l_sum1 + sr1.cnp05
      END IF
      IF (sr1.cno031 = '2') THEN
        LET sr1.cnp05 = -sr1.cnp05
        LET l_sum1 = l_sum1 + sr1.cnp05
      END IF
      LET l_sum4 = l_sum4 + sr1.coo16
      LET l_sum5 = l_sum5 + sr1.cnp05
      PRINT COLUMN g_c[31], sr1.dt,
            COLUMN g_c[32], sr1.smtdesc ,
            COLUMN g_c[33], sr1.billno  ,
            COLUMN g_c[35], sr1.unit    ,
            COLUMN g_c[36], sr1.coo14   USING '-----------&.&&',
            COLUMN g_c[37], sr1.coo16   USING '-----------&.&&',
            COLUMN g_c[38], l_sum4      USING '-----------&.&&',
            COLUMN g_c[39], sr1.cnp05   USING '-----------&.&&',
            COLUMN g_c[40], l_sum5      USING '-----------&.&&',
            COLUMN g_c[41], l_sum1      USING '-----------&.&&'
   END IF
   ON LAST ROW
       LET l_last_sw = 'Y'
       PRINT g_dash[1,g_len] CLIPPED
       PRINT g_x[4] CLIPPED,
             COLUMN (g_len-9), g_x[7] CLIPPED
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4] CLIPPED,
              COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
 
FUNCTION r212_getStartPos(l_sta,l_end,l_str)
   DEFINE l_sta,l_end,l_length,l_pos,l_w_tot,l_i LIKE type_file.num5          #No.FUN-680069 SMALLINT
   DEFINE l_str        STRING       #No.FUN-680069
   LET l_str=l_str.trim()
   LET l_length=l_str.getLength()
   LET l_w_tot=0
   FOR l_i=l_sta to l_end
      LET l_w_tot=l_w_tot+g_w[l_i]
   END FOR
   LET l_pos=(l_w_tot/2)-(l_length/2)
   IF l_pos<0 THEN LET l_pos=0 END IF
   LET l_pos=l_pos+g_c[l_sta]+(l_end-l_sta)
   RETURN l_pos
END FUNCTION
}  #FUN-840238 mark-end
#No.FUN-870144
