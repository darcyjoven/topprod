# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: acor711.4gl
# Descriptions...: 進口材料彙總表
# Date & Author..: 00/05/08 By Kammy
# Modify.........: NO.MOD-490398 04/11/22 BY DAY  add HS Code,coc10,Customs No.
# Modify.........: NO.MOD-490398 05/02/28 BY Elva 修改數量
# Modify.........: No.MOD-580212 05/09/08 By ice 小數位數根據azi檔的設置來取位
# Modify.........: No.TQC-610082 06/04/19 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-750026 07/07/09 By TSD.liquor 報表改成Crystal Report方式
# Modify.........: No.FUN-870128 08/07/29 By jamie CR不應call cl_outnam
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(600) # Where condition
               y      LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1) # NO.MOD-490398
              more    LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1) # Input more condition(Y/N)
              END RECORD,
          l_order   ARRAY[2] OF LIKE qcs_file.qcs03 #No.FUN-680069 VARCHAR(10)
DEFINE   g_i          LIKE type_file.num5     #count/index for any purpose        #No.FUN-680069 SMALLINT
DEFINE   l_table        STRING, #FUN-750026###
         g_str          STRING, #FUN-750026### 
         g_sql          STRING  #FUN-750026### 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
   #str FUN-750026 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "coc03.coc_file.coc03,",  #手冊編號 
               "coe01.coe_file.coe01,",  #申請編號
               "coe02.coe_file.coe02,",  #序號
               "coe03.coe_file.coe03,",  #商品編號
               "cob09.cob_file.cob09,",
               "coe05.coe_file.coe05,",  #申請數量
               "coe07.coe_file.coe07,",  #單價
               "coe08.coe_file.coe08,",  #金額
               "coeqty.coe_file.coe05,", #已進口量
               "coe10.coe_file.coe10,",  #加簽數量
               "cob02.cob_file.cob02,",
               "cob021.cob_file.cob021,",
               "A.coe_file.coe05,",
               "B.coe_file.coe05,",
               "C.coe_file.coe05,",
               "D.coe_file.coe05,",
               "Bcost.coe_file.coe08,",
               "Ccost.coe_file.coe08,",
               "Dcost.coe_file.coe08,",
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04"
 
   LET l_table = cl_prt_temptable('acor711',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,? ,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
   #end FUN-750026 add
 
   INITIALIZE tm.* TO NULL                # Default condition
   LET tm.more = 'N'
#---------------No.TQC-610082 modify
  #LET tm.y = 'N'                         #MOD-490398
   LET g_pdate = ARG_VAL(1)
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.y  = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#---------------No.TQC-610082 end
 
   IF cl_null(g_bgjob) or g_bgjob = 'N'
      THEN CALL acor711_tm(0,0)
      ELSE CALL acor711()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION acor711_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680069 SMALLINT
          l_cmd          LIKE type_file.chr1000        #No.FUN-680069 VARCHAR(400)
 
   LET p_row = 7 LET p_col = 20
 
   OPEN WINDOW acor711_w AT p_row,p_col WITH FORM "aco/42f/acor711"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more= 'N'
    LET tm.y = 'N'                         #MOD-490398
   LET g_pdate= g_today
   LET g_rlang= g_lang
   LET g_bgjob= 'N'
   LET g_copies= '1'
 
 WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON coc04,coc10,coc03,coc05,coe03 #MOD-490398
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
      LET INT_FLAG = 0 CLOSE WINDOW acor711_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
    INPUT BY NAME tm.y,tm.more WITHOUT DEFAULTS   #MOD-490398
 
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
      ON ACTION CONTROLG CALL cl_cmdask()     # Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW acor711_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='acor711'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('acor711','9031',1)
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
                         " '",tm.y CLIPPED,"'",             #No.TQC-610082 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
         CALL cl_cmdat('acor711',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW acor711_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL acor711()
   ERROR ""
END WHILE
   CLOSE WINDOW acor711_w
END FUNCTION
 
FUNCTION acor711()
   DEFINE l_name    LIKE type_file.chr20,        #No.FUN-680069 VARCHAR(20) # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0063
          l_sql     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(1200)
          l_chr     LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
          l_za05    LIKE za_file.za05, #MOD-490398
          l_order    ARRAY[5] OF LIKE qcs_file.qcs03,       #No.FUN-680069 VARCHAR(10)
          sr            RECORD coc03  LIKE coc_file.coc03,   #No.MOD-490398
                               coe01  LIKE coe_file.coe01,  #申請編號
                               coe02  LIKE coe_file.coe02,  #序號
                               coe03  LIKE coe_file.coe03,  #商品編號
                               cob09  LIKE cob_file.cob09,  #MOD-490398
                               coe05  LIKE coe_file.coe05,  #申請數量
                               coe07  LIKE coe_file.coe07,  #單價
                               coe08  LIKE coe_file.coe08,  #金額
                               coeqty LIKE coe_file.coe05,  #已進口量
                               coe10  LIKE coe_file.coe10   #加簽數量
                        END RECORD
  #--FUN-750026 TSD.liquor add start---------
  DEFINE  l_cod03      LIKE cod_file.cod03,
          l_cod041     LIKE cod_file.cod041,
          l_codqty     LIKE cod_file.cod05,
          l_con05      LIKE con_file.con05,
          l_con06      LIKE con_file.con06,
          l_cob02      LIKE cob_file.cob02,
          l_cob021     LIKE cob_file.cob021,
          l_A,l_B,l_C,l_D                  LIKE coe_file.coe05,
          l_Bcost,l_Ccost,l_Dcost          LIKE coe_file.coe08
  #FUN-750026 add end-----------------------
 
     #str FUN-750026 add
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
     CALL cl_del_data(l_table)
     #------------------------------ CR (2) ------------------------------#
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #FUN-750026 add
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     #--->取合同出口成品
     #maggie
 #NO.MOD-490398--050228--begin
#    LET l_sql="SELECT cod03,cod041,(cod09+cod101+cod106+cod105+cod103-cod104)",
     LET l_sql="SELECT cod03,cod041,(cod09+cod101+cod106-cod091-cod102-cod104)",
 #NO.MOD-490398--050228--end
               "  FROM cod_file  ",
               " WHERE cod01 = ? "
     #end maggie
 
     PREPARE r711_cod_pre FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM 
     END IF
     DECLARE r711_cod_cur CURSOR FOR r711_cod_pre
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND cocuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND cocgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND cocgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('cocuser', 'cocgrup')
     #End:FUN-980030
 
 #NO.MOD-490398--050228--begin
#    LET l_sql = "SELECT coc04,coe01,coe02,coe03,coe05,coe07,coe08,",
#                " (coe09+coe101+coe103),coe10 ",
     LET l_sql = "SELECT coc03,coe01,coe02,coe03,'',coe05,coe07,coe08,",
                 " (coe051+coe09+coe101+coe107-coe103-coe104-coe108-coe109),",
                 " coe10 ",
 #NO.MOD-490398--050228--end
                 "  FROM coe_file,coc_file",
                 " WHERE coe01 = coc01 ",
                 "   AND cocacti = 'Y' ",
                 "   AND ",tm.wc CLIPPED
 
     PREPARE acor711_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM 
     END IF
     DECLARE acor711_curs1 CURSOR FOR acor711_prepare1
 
     #CALL cl_outnam('acor711') RETURNING l_name   #FUN-870128 mark
     LET g_pageno = 0
     FOREACH acor711_curs1 INTO sr.*
       IF SQLCA.sqlcode  THEN
          CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
       END IF
       IF cl_null(sr.coeqty) THEN LET sr.coeqty = 0 END IF
 #NO.MOD-490398--050228--begin
       IF cl_null(sr.coe05) THEN LET sr.coe05 = 0 END IF
       IF cl_null(sr.coe10) THEN LET sr.coe10 = 0 END IF
 #NO.MOD-490398--050228--end
       #FUN-750026 TSD.liquor add start
       LET l_C = 0
       FOREACH r711_cod_cur USING sr.coe01 INTO l_cod03,l_cod041,l_codqty
          IF SQLCA.sqlcode THEN
             CALL cl_err('r711_cod_cur',SQLCA.sqlcode,0)
             EXIT FOREACH
          END IF
          #-->取出口成品其標準BOM 是否有此料號存在
          SELECT con05,con06 INTO l_con05,l_con06 FROM con_file
           WHERE con01 =l_cod03 AND con013 = l_cod041
             AND con08 =(SELECT UNIQUE coc10 FROM coc_file WHERE coc01=sr.coe01)
             AND con03=sr.coe03
 
          IF SQLCA.sqlcode THEN CONTINUE FOREACH END IF
 
          #-->已轉出數量
           LET l_C = l_C + (l_codqty * (l_con05/(1- (l_con06/100))))  #No.MOD-490398
       END FOREACH
 
       SELECT cob02,cob021 INTO l_cob02,l_cob021 FROM cob_file
                   WHERE cob01 = sr.coe03
       IF SQLCA.sqlcode THEN LET l_cob02 = ' ' END IF
 
       LET l_A = sr.coe05 + sr.coe10            #申請數量
       LET l_B = l_A - sr.coeqty                #未進口數量
       LET l_Bcost = l_B * sr.coe07             #未進口金額
 
       LET l_Ccost = l_C * sr.coe07             #已轉出金額
 
       LET l_D = l_A - l_C                      #未轉出數量
       LET l_Dcost = l_D * sr.coe07             #未轉出金額
       SELECT cob09 INTO sr.cob09 FROM cob_file WHERE cob01=sr.coe03
       #FUN-750026 add end
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
       EXECUTE insert_prep USING 
         sr.*,l_cob02,l_cob021,l_A,l_B,l_C,l_D,l_Bcost,l_Ccost,l_Dcost,
         g_azi03,g_azi04
       #------------------------------ CR (3) ------------------------------#
       #end FUN-750026 add
     END FOREACH
 
     #str FUN-750026 add
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'coc03,coc04,coc05,coc10,coe03') RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str,";",tm.y 
     CALL cl_prt_cs3('acor711','acor711',l_sql,g_str)
     #------------------------------ CR (4) ------------------------------#
 
 
END FUNCTION
 
