# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: asfr718.4gl
# Descriptions...: 工單預計最大產量狀況表列印  
# Date & Author..: 00/04/24 By Carol
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima021
# Modify.........: NO.FUN-510040 05/02/15 By Echo 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.FUN-680121 06/08/31 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-720005 07/02/28 BY TSD.c123k 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/30 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.TQC-770004 07/07/03 By mike 幫助按鈕灰色
# Modify.........: No.TQC-940157 09/05/11 By mike ds_report-->g_cr_db_str   
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A50156 10/05/28 By Carrier main结构调整
# Modify.........: No.FUN-A60076 10/06/25 By vealxu 製造功能優化-平行制程（批量修改）
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
              wc       STRING,      #NO.TQC-630166 	
              s        LIKE type_file.chr3,          #No.FUN-680121 VARCHAR(3)# Order by sequence
              t        LIKE type_file.chr3,          #No.FUN-680121 VARCHAR(3)# Eject sw
              more     LIKE type_file.chr1           #No.FUN-680121 CAHR(1)# Input more condition(Y/N)
              END RECORD
DEFINE    g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE   l_table         STRING                  ### TSD.c123k add FUN-720005 ###
DEFINE   g_sql           STRING                  ### TSD.c123k add FUN-720005 ###
DEFINE   g_str           STRING                  ### TSD.c123k add FUN-720005 ###
 
MAIN
   OPTIONS
       INPUT NO WRAP,
       FIELD ORDER FORM
   DEFER INTERRUPT                # Supress DEL key function
 
   #No.TQC-A50156  --Begin
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> TSD.c123k *** ##
   LET g_sql = "sfb01.sfb_file.sfb01,",
               "sfb05.sfb_file.sfb05,",
               "sfb08.sfb_file.sfb08,",
               "sfb09.sfb_file.sfb09,",
               "sfb15.sfb_file.sfb15,",
               "sfb82.sfb_file.sfb82,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "wipqty.sfb_file.sfb09,",
               "w_ecm012_1.ecm_file.ecm012,",  #FUN-A60076
               "w_ecm012_2.ecm_file.ecm012,",  #FUN-A60076
               "w_ecm012_3.ecm_file.ecm012,",  #FUN-A60076
               "w_ecm012_4.ecm_file.ecm012,",  #FUN-A60076
               "w_ecm012_5.ecm_file.ecm012,",  #FUN-A60076
               "w_ecm012_6.ecm_file.ecm012,",  #FUN-A60076
               "w_ecm012_7.ecm_file.ecm012,",  #FUN-A60076
               "w_ecm012_8.ecm_file.ecm012,",  #FUN-A60076
               "w_ecm012_9.ecm_file.ecm012,",  #FUN-A60076  
               "w_ecm012_10.ecm_file.ecm012,", #FUN-A60076
               "w_ecm45_1.ecm_file.ecm45,",  #作業項目01
               "w_ecm45_2.ecm_file.ecm45,",  #作業項目02
               "w_ecm45_3.ecm_file.ecm45,",  #作業項目03
               "w_ecm45_4.ecm_file.ecm45,",  #作業項目04
               "w_ecm45_5.ecm_file.ecm45,",  #作業項目05
               "w_ecm45_6.ecm_file.ecm45,",  #作業項目06
               "w_ecm45_7.ecm_file.ecm45,",  #作業項目07
               "w_ecm45_8.ecm_file.ecm45,",  #作業項目08
               "w_ecm45_9.ecm_file.ecm45,",  #作業項目09
               "w_ecm45_10.ecm_file.ecm45,", #作業項目10
               "w_wipqty_1.sfb_file.sfb09,",
               "w_wipqty_2.sfb_file.sfb09,",
               "w_wipqty_3.sfb_file.sfb09,",
               "w_wipqty_4.sfb_file.sfb09,",
               "w_wipqty_5.sfb_file.sfb09,",
               "w_wipqty_6.sfb_file.sfb09,",
               "w_wipqty_7.sfb_file.sfb09,",
               "w_wipqty_8.sfb_file.sfb09,",
               "w_wipqty_9.sfb_file.sfb09,",
               "w_wipqty_10.sfb_file.sfb09"
 
   LET l_table = cl_prt_temptable('asfr718',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
  #LET g_sql = "INSERT  INTO ds_report.",l_table CLIPPED,     #TQC-940157                                                            
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,     #TQC-940157  
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"    #FUN-A60076 add 10?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------------ CR (1) ------------------------------#
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123
 
   #No.TQC-A50156  --End  
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL r718_tm(0,0)        # Input print condition
      ELSE CALL r718()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION r718_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_cmd          LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(400)
          l_n,l_cnt      LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_a            LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col =20
   ELSE LET p_row = 4 LET p_col = 12
   END IF
 
   OPEN WINDOW r718_w AT p_row,p_col
        WITH FORM "asf/42f/asfr718" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '123'
   LET tm.t    = ''
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON sfb01,sfb05,sfb15,sfb82 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
     ON ACTION help                 #No.TQC-770004
       LET g_action_choice="help"  #No.TQC-770004 
       CALL cl_show_help()         #No.TQC-770004 
       CONTINUE CONSTRUCT           #No.TQC-770004 
 
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
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r718_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN 
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
 
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,
                   tm2.t1,tm2.t2,tm2.t3,
                   tm.more WITHOUT DEFAULTS 
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
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      AFTER INPUT  
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
      ON ACTION help                 #No.TQC-770004                                                                                  
           LET g_action_choice="help"  #No.TQC-770004                                                                                   
           CALL cl_show_help()         #No.TQC-770004                                                                                   
           CONTINUE  INPUT          #No.TQC-770004   
         ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
          
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r718_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='asfr718'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asfr718','9031',1)
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
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('asfr718',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r718_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r718()
   ERROR ""
END WHILE
   CLOSE WINDOW r718_w
END FUNCTION
 
FUNCTION r718()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 CAHR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680121 CAHR(1100)
          l_chr     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_n       LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_n2      LIKE type_file.num5,          #TSD.c123k add FUN-720005
          l_za05    LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
          l_order   ARRAY[2] OF LIKE sfb_file.sfb05,         #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
          i         LIKE type_file.num5,    #TSD.c123k add FUN-720005
          sr        RECORD       #TSD.c123k mark 
                                 #order1 LIKE sfb_file.sfb05,#No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                                 #order2 LIKE sfb_file.sfb05,#No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                                 ###--------------------------------------------
                                  sfb01  LIKE sfb_file.sfb01,  
                                  sfb05  LIKE sfb_file.sfb05,  
                                  sfb08  LIKE sfb_file.sfb08,  
                                  sfb09  LIKE sfb_file.sfb09,  
                                  sfb15  LIKE sfb_file.sfb15,  
                                  sfb82  LIKE sfb_file.sfb82,  
                                  ima02  LIKE ima_file.ima02,
                                  ima021 LIKE ima_file.ima021,
                                  wipqty LIKE sfb_file.sfb09   #TSD.c123k add FUN-720005
                    END RECORD,
         #TSD.c123k add FUN-720005 -------------------------------------- 
          sr1       DYNAMIC ARRAY OF RECORD
                                  ecm012 LIKE ecm_file.ecm012,   #FUN-A60076  
                                  ecm03  LIKE ecm_file.ecm03,
                                  ecm45  LIKE ecm_file.ecm45,
                                  wipqty LIKE sfb_file.sfb09
                    END RECORD
         ##---------------------------------------------------
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> TSD.c123k *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ----------------------------------#
 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'asfr718'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 180 END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### TSD.c123k add FUN-720005##
 
    ##TSD.c123k modify -----------------------------------------------
    {
     LET l_sql = "SELECT '','',sfb01,sfb05,sfb08,sfb09,sfb15,sfb82,",
                 "ima02,ima021 ",
                 "  FROM sfb_file,OUTER ima_file ",
                 " WHERE ",tm.wc CLIPPED," AND sfb04 IN ('4','5','6','7') ", 
                 "  AND sfb_file.sfb05 = ima_file.ima01 " CLIPPED 
    }
     LET l_sql = "SELECT sfb01,sfb05,sfb08,sfb09,sfb15,sfb82,ima02,ima021,0 ", 
                 "  FROM sfb_file,OUTER ima_file ",
                 " WHERE ",tm.wc CLIPPED," AND sfb04 IN ('4','5','6','7') ", 
                 "  AND sfb_file.sfb05 = ima_file.ima01 " CLIPPED 
    ##TSD.c123k end ---------------------------------------------------
 
     PREPARE r718_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1) RETURN
     END IF
     DECLARE r718_curs1 CURSOR FOR r718_prepare1
 
     #WIP量(wipqty)= 總投入量(良品轉入量ecm301+重工轉入量ecm302)
     #               -總轉出量(良品轉出量ecm311+重工轉出量ecm312)
     #               -當站報廢量ecm313
     #               -當站下線量(入庫量)ecm314
     LET l_sql = "SELECT ecm012,ecm03,ecm45,",    #FUN-A60076 add ecm012
                 "SUM((ecm301+ecm302+ecm303)-(ecm311+ecm312+ecm316)-ecm313-ecm314) ", 
                 "  FROM ecm_file WHERE ecm01 = ? ",
                #" GROUP BY ecm03,ecm45 ",          #FUN-A60076 mark
                #" ORDER BY ecm03" CLIPPED          #FUN-A60076 mark
                 " GROUP BY ecm012,ecm03,ecm45 ",   #FUN-A60076
                 " ORDER BY ecm012,ecm03" CLIPPED   #FUN-A60076   
 
     PREPARE r718_prepare2 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare2:',SQLCA.sqlcode,1) RETURN
     END IF
     DECLARE r718_curs2 CURSOR FOR r718_prepare2      
 
     LET g_pageno = 0
     FOREACH r718_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH 
       END IF
  
       ## TSD.c123k add FUN-720005 ------------------------------------------------------#
       LET l_n2 = 1 
       #預計最大數量
       LET sr.wipqty = sr.sfb09   
 
       FOR i = 1 TO 10
           INITIALIZE sr1[i].* TO NULL
       END FOR
       FOREACH r718_curs2 USING sr.sfb01 INTO sr1[l_n2].*
          IF STATUS THEN EXIT FOREACH END IF
 
          IF NOT cl_null(sr1[l_n2].wipqty) THEN
             IF cl_null(sr1[l_n2].wipqty)  THEN 
                LET sr1[l_n2].wipqty = 0 
             END IF
 
             LET sr.wipqty = sr.wipqty + sr1[l_n2].wipqty
             LET l_n2 = l_n2 + 1
             IF l_n2 > 10 THEN EXIT FOREACH END IF
          END IF
       END FOREACH
 
      
       ## TSD.c123k end ------------------------------------------------------#
 
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> TSD.c123k *** ##
       EXECUTE insert_prep USING
          sr.sfb01,      sr.sfb05,      sr.sfb08,      sr.sfb09,    
          sr.sfb15,      sr.sfb82,      sr.ima02,      sr.ima021,   
          sr.wipqty,
          sr1[1].ecm012, sr1[2].ecm012, sr1[3].ecm012, sr1[4].ecm012,    #FUN-A60076
          sr1[5].ecm012, sr1[6].ecm012, sr1[7].ecm012, sr1[8].ecm012,    #FUN-A60076
          sr1[9].ecm012, sr1[10].ecm012,                                 #FUN-A60076
          sr1[1].ecm45,  sr1[2].ecm45,  sr1[3].ecm45,  sr1[4].ecm45,
          sr1[5].ecm45,  sr1[6].ecm45,  sr1[7].ecm45,  sr1[8].ecm45,
          sr1[9].ecm45,  sr1[10].ecm45,
          sr1[1].wipqty, sr1[2].wipqty, sr1[3].wipqty, sr1[4].wipqty,
          sr1[5].wipqty, sr1[6].wipqty, sr1[7].wipqty, sr1[8].wipqty,
          sr1[9].wipqty, sr1[10].wipqty
       #-------------------------------- CR (3) ------------------------------#
 
     END FOREACH
 
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> TSD.c123k **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'sfb01,sfb131,sfb06,sfb133,sfb134')
        RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     #傳per檔的排序、跳頁、小計、帳款截止日等參數
     LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t
    #CALL cl_prt_cs3('asfr718','asfr718',l_sql,g_str)   #FUN-710080 modify  #FUN-A60076 mark
    #FUN-A60076 --------------------------start------------------------
     IF g_sma.sma541 = 'Y' THEN
        CALL cl_prt_cs3('asfr718','asfr718_1',l_sql,g_str)
     ELSE
        CALL cl_prt_cs3('asfr718','asfr718',l_sql,g_str)
     END IF 
    #FUN-A60076 -------------------------end-------------------------- 
     #------------------------------ CR (4) ----------------------------------#
 
 
END FUNCTION
 
