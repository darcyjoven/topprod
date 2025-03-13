# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: asfr717.4gl
# Descriptions...: 工作中心在製量狀況表列印
# Date & Author..: 99/07/30 By Carol
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: NO.FUN-550067 05/05/31 By day   單據編號加大
# Modify.........: No.TQC-5A0037 05/10/13 By Rosayu 1.料號 / 品名 / 規格放大
#                  2.不對齊,需調整 3.報表寬度錯誤
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: NO.MOD-640165 06/04/08 By Echo 列印時會出異一堆異常訊息(與p_zaa有關)
# Modify.........: No.FUN-670067 06/07/18 By Jackho voucher型報表轉template1
# Modify.........: No.FUN-680121 06/08/31 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-720005 07/02/26 BY TSD.c123k 改成crystal report
# Modify.........: No.FUN-710080 07/03/30 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.TQC-770004 07/07/04 By mike 幫組按鈕是灰色的
# Modify.........: No.FUN-7B0060 08/04/02 By jamie 1. QBE 增加開窗功能 2. 報表產出欄位title調整
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60027 10/06/23 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
#             wc       VARCHAR(600),   # Where condition   #TQC-630166
              wc       STRING,      # Where condition   #TQC-630166
              s        LIKE type_file.chr3,          #No.FUN-680121 VARCHAR(3)# Order by sequence
              t        LIKE type_file.chr3,          #No.FUN-680121 VARCHAR(3)# Eject sw
              more     LIKE type_file.chr1           #No.FUN-680121 CAHR(1)# Input more condition(Y/N)
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE   l_table         STRING                  ### TSD.c123k add FUN-720005 ###
DEFINE   g_sql           STRING                  ### TSD.c123k add FUN-720005 ###
DEFINE   g_str           STRING                  ### TSD.c123k add FUN-720005 ###
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123 #FUN-BB0047 mark
 
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> TSD.c123k *** ##
   LET g_sql = "ecm01.ecm_file.ecm01,",
               "sfb05.sfb_file.sfb05,",
               "sfb08.sfb_file.sfb08,",
               "ecm03.ecm_file.ecm03,",
               "ecm012.ecm_file.ecm012,",       #FUN-A60027  
               "ecm04.ecm_file.ecm04,",
               "ecm06.ecm_file.ecm06,",
               "ecm45.ecm_file.ecm45,",
               "ecm301.ecm_file.ecm301,",
               "ecm302.ecm_file.ecm302,",
               "ecm303.ecm_file.ecm303,",
               "ecm311.ecm_file.ecm311,",
               "ecm312.ecm_file.ecm312,",
               "ecm313.ecm_file.ecm313,",
               "ecm314.ecm_file.ecm314,",
               "ecm315.ecm_file.ecm315,",
               "ecm316.ecm_file.ecm316,",
               "ecm321.ecm_file.ecm321,",
               "ecm322.ecm_file.ecm322,",
               "ecm291.ecm_file.ecm291,",
               "ecm54.ecm_file.ecm54,",
               "ecm57.ecm_file.ecm57,",
               "ecm58.ecm_file.ecm58,",
               "eca02.eca_file.eca02,",
               "ima02.ima_file.ima02,",
               "work.eca_file.eca02,",
               "waitqty.ecm_file.ecm302,",
               "wipqty.ecm_file.ecm302,",
               "woqty.ecm_file.ecm302"
 
   LET l_table = cl_prt_temptable('asfr717',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?)"               #FUN-A60027 add 1?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------------ CR (1) ------------------------------#
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
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
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL r717_tm(0,0)        # Input print condition
      ELSE CALL r717()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION r717_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_cmd          LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(400)
          l_n,l_cnt      LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_a            LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)
 
   IF p_row = 0 THEN LET p_row = 6 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 6 LET p_col = 12
   END IF
 
   OPEN WINDOW r717_w AT p_row,p_col
        WITH FORM "asf/42f/asfr717"
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
   CONSTRUCT BY NAME tm.wc ON ecm06,ecm01,ecm03_par
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
 
     ON ACTION help                #No.TQC-770004  
        LET g_action_choice="help"   #No.TQC-770004  
        CALL cl_show_help()           #No.TQC-770004  
        CONTINUE CONSTRUCT            #No.TQC-770004 
 
    #FUN-7B0060---add---str--- 
     ON ACTION controlp
        CASE
           WHEN INFIELD(ecm06)     #工作站
                CALL q_eca(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ecm06
                NEXT FIELD ecm06
 
           WHEN INFIELD(ecm01)     #工單單號
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ecm9"
                LET g_qryparam.state    = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ecm01
                NEXT FIELD ecm01
 
           WHEN INFIELD(ecm03_par) #生產料件
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ima18"
                LET g_qryparam.state    = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ecm03_par
                NEXT FIELD ecm03_par
      OTHERWISE EXIT CASE 
                END CASE 
    #FUN-7B0060---add---end--- 
 
END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r717_w 
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
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
          ON ACTION help                      #No.TQC-770004  
            LET g_action_choice="help"        #No.TQC-770004  
            CALL cl_show_help()               #No.TQC-770004  
            CONTINUE INPUT                   #No.TQC-770004  
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r717_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='asfr717'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asfr717','9031',1)
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
         CALL cl_cmdat('asfr717',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r717_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r717()
   ERROR ""
END WHILE
   CLOSE WINDOW r717_w
END FUNCTION
 
FUNCTION r717()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
#         l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT  #TQC-630166         #No.FUN-680121 VARCHAR(1200)
          l_sql     STRING,          # RDSQL STATEMENT  #TQC-630166
          l_chr     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
          l_order   ARRAY[3] OF LIKE sfb_file.sfb05,         #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
          sr        RECORD       ## TSD.c123k mark -------------------------------------------------##
                                 #order1 LIKE sfb_file.sfb05,#No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                                 #order2 LIKE sfb_file.sfb05,#No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                                 #order3 LIKE sfb_file.sfb05,#No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                                 ## TSD.c123k end --------------------------------------------------##
                                  ecm01   LIKE ecm_file.ecm01,
                                  sfb05   LIKE sfb_file.sfb05,
                                  sfb08   LIKE sfb_file.sfb08,
                                  ecm03   LIKE ecm_file.ecm03,
                                  ecm012  LIKE ecm_file.ecm012,   #FUN-A60027 
                                  ecm04   LIKE ecm_file.ecm04,
                                  ecm06   LIKE ecm_file.ecm06,
                                  ecm45   LIKE ecm_file.ecm45,
                                  ecm301  LIKE ecm_file.ecm301,
                                  ecm302  LIKE ecm_file.ecm302,
                                  ecm303  LIKE ecm_file.ecm303,
                                  ecm311  LIKE ecm_file.ecm311,
                                  ecm312  LIKE ecm_file.ecm312,
                                  ecm313  LIKE ecm_file.ecm313,
                                  ecm314  LIKE ecm_file.ecm314,
                                  ecm315  LIKE ecm_file.ecm315,
                                  ecm316  LIKE ecm_file.ecm316,
                                  ecm321  LIKE ecm_file.ecm321,
                                  ecm322  LIKE ecm_file.ecm322,
                                  ecm291  LIKE ecm_file.ecm291,
                                  ecm54   LIKE ecm_file.ecm54,
                                  ecm57   LIKE ecm_file.ecm57,
                                  ecm58   LIKE ecm_file.ecm58,
                                  eca02   LIKE eca_file.eca02,
                                  ima02   LIKE ima_file.ima02,
                                  work    LIKE eca_file.eca02,   ## TSD.c123k add FUN-720005 ##
                                  waitqty LIKE ecm_file.ecm302,  ## TSD.c123k add FUN-720005 ##
                                  wipqty  LIKE ecm_file.ecm302,  ## TSD.c123k add FUN-720005 ##
                                  woqty   LIKE ecm_file.ecm302   ## TSD.c123k add FUN-720005 ##
                        END RECORD
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> TSD.c123k *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ----------------------------------#
 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'asfr717' #No.FUN-670067
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### TSD.c123k add FUN-720005 ###
 
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            # 只能使用自己的資料
    #        LET tm.wc= tm.wc clipped," AND ecmuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                            # 只能使用相同群的資料
    #        LET tm.wc= tm.wc clipped," AND ecmgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET tm.wc= tm.wc clipped," AND ecmgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ecmuser', 'ecmgrup')
    #End:FUN-980030
 
    ## TSD.c123k modify ----------------------------------------------------##
    {
     LET l_sql = "SELECT '','','',ecm01,sfb05,sfb08,ecm03,ecm04,ecm06,ecm45,",       
                 "ecm301,ecm302,ecm303,ecm311,ecm312,ecm313,ecm314,ecm315,ecm316,ecm321,",
                 "ecm322,ecm291,ecm54,ecm57,ecm58,eca02,ima02 ",  
                 "  FROM ecm_file,sfb_file,eca_file,ima_file ",
                 " WHERE ",tm.wc CLIPPED,
                 "   AND sfb01 = ecm01 ",
                 "   AND sfb04 !='8' AND sfb87!='X' ",
                 "   AND ecm06 = eca_file.eca01 AND sfb05 = ima_file.ima01 ",
                 " ORDER BY ecm06,ecm01,ecm03 " CLIPPED
    }
     LET l_sql = "SELECT ecm01,sfb05,sfb08,ecm03,ecm012,ecm04,ecm06,ecm45,",   #FUN-A60027 add ecm012
                 "       ecm301,ecm302,ecm303,ecm311,ecm312,ecm313, ",
                 "       ecm314,ecm315,ecm316,ecm321,",
                 "       ecm322,ecm291,ecm54,ecm57,ecm58,eca02,ima02, ",  
                 "       '',0,0,0 ",
                 "  FROM ecm_file,sfb_file,eca_file,ima_file ",
                 " WHERE ",tm.wc CLIPPED,
                 "   AND sfb01 = ecm01 ",
                 "   AND sfb04 !='8' AND sfb87!='X' ",
                 "   AND ecm06 = eca_file.eca01 AND sfb05 = ima_file.ima01 ",
                 " ORDER BY ecm06,ecm01,ecm03 " CLIPPED
    ## TSD.c123k end -------------------------------------------------------##
 
     PREPARE r717_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) RETURN
     END IF
     DECLARE r717_curs1 CURSOR FOR r717_prepare1
 
    # CALL cl_outnam('asfr717') RETURNING l_name  #TSD.c123k mark
#No.FUN-550067-begin
     #LET g_len = 139  #TQC-5A0037 mark
#     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-550067-end
 
     LET g_pageno = 0
     FOREACH r717_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       FOR g_i = 1 TO 3
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.ecm06
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.ecm01
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.sfb05
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
 
       ## TSD.c123k add FUN-720005 ---------------------------------------------------------##
       LET sr.wipqty = (sr.ecm301 + sr.ecm302 + sr.ecm303) 
                       - (sr.ecm311 + sr.ecm312 + sr.ecm316) - sr.ecm313 - sr.ecm314
       IF sr.ecm54='Y'   # 須check in
          THEN
          LET sr.waitqty = (sr.ecm301 + sr.ecm302 + sr.ecm303) - sr.ecm291
          LET sr.woqty  = sr.ecm291 - (sr.ecm311 + sr.ecm312 + sr.ecm316)
                          - sr.ecm313 - sr.ecm314
       ELSE
          LET sr.waitqty = 0
          LET sr.woqty  = sr.wipqty
       END IF
       LET sr.work = sr.ecm06 CLIPPED, sr.eca02
       ##------------------------------------------------------------------------##
 
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> TSD.c123k *** ##
       EXECUTE insert_prep USING
           sr.ecm01,    sr.sfb05,    sr.sfb08,    sr.ecm03,   sr.ecm012, sr.ecm04,     #FUN-A60027 add ecm012
           sr.ecm06,    sr.ecm45,    sr.ecm301,   sr.ecm302,  sr.ecm303,
           sr.ecm311,   sr.ecm312,   sr.ecm313,   sr.ecm314,  sr.ecm315,
           sr.ecm316,   sr.ecm321,   sr.ecm322,   sr.ecm291,  sr.ecm54,
           sr.ecm57,    sr.ecm58,    sr.eca02,    sr.ima02,   sr.work,
           sr.waitqty,  sr.wipqty,   sr.woqty 
       #-------------------------------- CR (3) ------------------------------#
 
     END FOREACH
 
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> TSD.c123k **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'ecm06,ecm01,ecm03_par')
        RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     #傳per檔的排序、跳頁、小計、帳款截止日等參數
     LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t
    #CALL cl_prt_cs3('asfr717','asfr717',l_sql,g_str)   #FUN-710080 modify    #FUN-A60027
     #FUN-A60027 ----------------start------------------
      IF g_sma.sma541 = 'Y' THEN 
         CALL cl_prt_cs3('asfr717','asfr717_1',l_sql,g_str)
      ELSE
         CALL cl_prt_cs3('asfr717','asfr717',l_sql,g_str)
      END IF 
     #FUN-A60027 ----------------end-------------------
     #------------------------------ CR (4) ----------------------------------#
 
 
END FUNCTION
 
