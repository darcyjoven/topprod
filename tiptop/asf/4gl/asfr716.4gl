# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: asfr716.4gl
# Descriptions...: 工單在製量狀況表列印
# Date & Author..: 99/07/29 By Carol
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02,ima021
# Modify.........: NO.FUN-510040 05/02/15 By Echo 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.FUN-680121 06/08/31 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-720005 07/02/13 By TSD.Martin 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/30 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.TQC-770004 07/07/03 By mike 幫組按鈕是灰色的
# Modify.........: No.FUN-7B0059 08/06/23 By jamie 1. QBE 增加開窗功能 2. 報表產出欄位title調整
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60027 10/06/23 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
#             wc       VARCHAR(600),   # Where condition   #TQC-630166
              wc       STRING,      # Where condition   #TQC-630166
              s        LIKE type_file.chr2,          #No.FUN-680121 VARCHAR(2)# Order by sequence
              t        LIKE type_file.chr2,          #No.FUN-680121 VARCHAR(2)# Eject sw
              more     LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)# Input more condition(Y/N)
              END RECORD
 
#DEFINE   g_dash          VARCHAR(400)   #Dash line
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE    l_table     STRING,                 ### FUN-720005 ###
          g_str       STRING,                 ### FUN-720005 ###
          g_sql       STRING                  ### FUN-720005 ###
#DEFINE   g_len           SMALLINT   #Report width(79/132/136)
#DEFINE   g_pageno        SMALLINT   #Report page no
#DEFINE   g_zz05          VARCHAR(1)   #Print tm.wc ?(Y/N)
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
 
## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> 2007/02/13 TSD.Martin  *** ##
          LET g_sql = " sfb01.sfb_file.sfb01,",
                      " sfb05.sfb_file.sfb05,",
                      " sfb82.sfb_file.sfb82,",
                      " ecm03.ecm_file.ecm03,",
                      " ecm012.ecm_file.ecm012,",   #FUN-A60027 
                      " ecm04.ecm_file.ecm04,",
                      " ecm06.ecm_file.ecm06,",
                      " ecm45.ecm_file.ecm45,",
                      " ecm301.ecm_file.ecm301,",
                      " ecm302.ecm_file.ecm302,",
                      " ecm303.ecm_file.ecm303,",
                      " ecm311.ecm_file.ecm311,",
                      " ecm312.ecm_file.ecm312,",
                      " ecm313.ecm_file.ecm313,",
                      " ecm314.ecm_file.ecm314,",
                      " ecm315.ecm_file.ecm315,",
                      " ecm316.ecm_file.ecm316,",
                      " ecm321.ecm_file.ecm321,",
                      " ecm322.ecm_file.ecm322,",
                      " ecm291.ecm_file.ecm291,",
                      " ecm54.ecm_file.ecm54,",
                      " ecm57.ecm_file.ecm57,",
                      " ecm58.ecm_file.ecm58,",
                      " ecm59.ecm_file.ecm59,",
                      " eca02.eca_file.eca02,",
                      " ima02.ima_file.ima02,",
                      " ima021.ima_file.ima021,",
                      " wipqty.ecm_file.ecm302,",    
                      " waitqty.ecm_file.ecm302,",    
                      " woqty.ecm_file.ecm302"
 
    LET l_table = cl_prt_temptable('asfr716',g_sql) CLIPPED   # 產生Temp Table
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?, ?, ?, ?, ?,  ?, ? , ?, ? ,? ,", 
                "        ?, ?, ?, ?, ?,  ?, ? , ?, ? ,? ,",
                "        ?, ?, ?, ?, ?,  ?, ? , ?, ? ,?)"         #FUN-A60027 add 1?
 
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF
#----------------------------------------------------------CR (1) ------------#
 
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
      THEN CALL r716_tm(0,0)        # Input print condition
      ELSE CALL r716()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION r716_tm(p_row,p_col)
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
 
   OPEN WINDOW r716_w AT p_row,p_col
        WITH FORM "asf/42f/asfr716"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '12'
   LET tm.t    = ''
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON sfb01,sfb05,sfb82
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
           
         ON ACTION help                 #No.TQC-770004  
            LET g_action_choice="help"  #No.TQC-770004  
            CALL cl_show_help()        #No.TQC-770004  
            CONTINUE CONSTRUCT          #No.TQC-770004
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #FUN-7B0059---add---str--- 
         ON ACTION controlp
            CASE
 
               WHEN INFIELD(sfb01)  #工單單號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_ecm9"
                    LET g_qryparam.state    = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO sfb01
                    NEXT FIELD sfb01
 
               WHEN INFIELD(sfb05) #生產料件
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_ima18"
                    LET g_qryparam.state    = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO sfb05
                    NEXT FIELD sfb05
 
               WHEN INFIELD(sfb82) #製造部門
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gem"
                    LET g_qryparam.state    = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO sfb82
                    NEXT FIELD sfb82
          OTHERWISE EXIT CASE 
         END CASE 
         #FUN-7B0059---add---end--- 
 
END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r716_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
 
   INPUT BY NAME tm2.s1,tm2.s2,
                   tm2.t1,tm2.t2,
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
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
         LET tm.t = tm2.t1,tm2.t2
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
 
      ON ACTION help                    #No.TQC-770004  
         LET g_action_choice="help"    #No.TQC-770004  
         CALL cl_show_help()           #No.TQC-770004  
         CONTINUE INPUT                 #No.TQC-770004  
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r716_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='asfr716'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asfr716','9031',1)
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
         CALL cl_cmdat('asfr716',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r716_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r716()
   ERROR ""
END WHILE
   CLOSE WINDOW r716_w
END FUNCTION
 
FUNCTION r716()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
#         l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT   #TQC-630166        #No.FUN-680121 VARCHAR(1200)
          l_sql     STRING,          # RDSQL STATEMENT   #TQC-630166
          l_wipqty     LIKE ecm_file.ecm302,          #No.FUN-680121 DEC(11,3)
          l_waitqty    LIKE ecm_file.ecm302,          #No.FUN-680121 DEC(11,3)
          l_woqty      LIKE ecm_file.ecm302,          #No.FUN-680121 DEC(11,3)
          l_chr     LIKE type_file.chr1,                 #No.FUN-680121 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,              #No.FUN-680121 VARCHAR(40)
          l_order   ARRAY[2] OF LIKE sfb_file.sfb05,     #No.FUN-680121 VARCHAR(40)#FUN-5B0205 20->40
          sr        RECORD        order1 LIKE sfb_file.sfb05,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                                  order2 LIKE sfb_file.sfb05,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                                  sfb01  LIKE sfb_file.sfb01,
                                  sfb05  LIKE sfb_file.sfb05,
                                  sfb82  LIKE sfb_file.sfb82,
                                  ecm03  LIKE ecm_file.ecm03,
                                  ecm012 LIKE ecm_file.ecm012,  #FUN-A60027  
                                  ecm04  LIKE ecm_file.ecm04,
                                  ecm06  LIKE ecm_file.ecm06,
                                  ecm45  LIKE ecm_file.ecm45,
                                  ecm301 LIKE ecm_file.ecm301,
                                  ecm302 LIKE ecm_file.ecm302,
                                  ecm303 LIKE ecm_file.ecm303,
                                  ecm311 LIKE ecm_file.ecm311,
                                  ecm312 LIKE ecm_file.ecm312,
                                  ecm313 LIKE ecm_file.ecm313,
                                  ecm314 LIKE ecm_file.ecm314,
                                  ecm315 LIKE ecm_file.ecm315,
                                  ecm316 LIKE ecm_file.ecm316,
                                  ecm321 LIKE ecm_file.ecm321,
                                  ecm322 LIKE ecm_file.ecm322,
                                  ecm291 LIKE ecm_file.ecm291,
                                  ecm54  LIKE ecm_file.ecm54,
                                  ecm57  LIKE ecm_file.ecm57,
                                  ecm58  LIKE ecm_file.ecm58,
                                  ecm59  LIKE ecm_file.ecm59,
                                  eca02  LIKE eca_file.eca02,
                                  ima02  LIKE ima_file.ima02,
                                  ima021 LIKE ima_file.ima021
                        END RECORD,
          sr1     RECORD
                  sfb06  LIKE sfb_file.sfb06,     #製程編號
                  shb10  LIKE shb_file.shb10,     #生產料件
                  shb14  LIKE shb_file.shb14,
                  shb15  LIKE shb_file.shb15,
                  ima02  LIKE ima_file.ima02,     #料件名稱
                  ima021 LIKE ima_file.ima021,    #料件規格
                  wip_qty LIKE ecm_file.ecm301,   # WIP量
                  ecm_k  LIKE ste_file.ste06      #No.FUN-680121 DEC(9,2)#生產良率
                  END RECORD
 
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-720005 *** ##
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-720005 add ###
     #------------------------------ CR (2) ------------------------------#
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'asfr716'
#     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 132 END IF
#     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            # 只能使用自己的資料
    #        LET tm.wc= tm.wc clipped," AND sfbuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                            # 只能使用相同群的資料
    #        LET tm.wc= tm.wc clipped," AND sfbgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET tm.wc= tm.wc clipped," AND sfbgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
    #End:FUN-980030
 
 
     LET l_sql = "SELECT '','',sfb01,sfb05,sfb82,ecm03,ecm012,ecm04,ecm06,ecm45,",           #FUN-A60027 add ecm012
                 "ecm301,ecm302,ecm303,ecm311,ecm312,ecm313,ecm314,ecm315,ecm316,ecm321,",
                 "ecm322,ecm291,ecm54,ecm57,ecm58,ecm59,eca02,ima02,ima021 ",
                 "  FROM sfb_file,ecm_file,OUTER eca_file,OUTER ima_file ",
                 " WHERE ",tm.wc CLIPPED," AND sfb04 !='8' ",
                 "   AND ecm01 = sfb01 ",
                 "   AND ecm_file.ecm06 = eca_file.eca01  AND  sfb_file.sfb05 = ima_file.ima01 AND sfb87!='X' ",
                 " ORDER BY sfb01,ecm03 " CLIPPED
 
     PREPARE r716_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
     #  CALL cl_err('prepare:',SQLCA.sqlcode,1) EXIT PROGRAM
        CALL cl_err('prepare:',SQLCA.sqlcode,1) RETURN
     END IF
     DECLARE r716_curs1 CURSOR FOR r716_prepare1
 
     #CALL cl_outnam('asfr716') RETURNING l_name
     #START REPORT r716_rep TO l_name
 
     LET g_pageno = 0
     FOREACH r716_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       FOR g_i = 1 TO 2
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.sfb01
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.sfb05
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       #OUTPUT TO REPORT r716_rep(sr.*)
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-720005 *** ##
        #WIP量(wipqty)= 總投入量(良品轉入量ecm301+重工轉入量ecm302)
        #               -總轉出量(良品轉出量ecm311+重工轉出量ecm312)
        #               -當站報廢量ecm313
        #               -當站下線量(入庫量)ecm314
        #等待上線數量(Waitqyt)=總投入量(良品轉入量ecm301+重工轉入量ecm302)
        #                      -Check In量ecm291
        #上線處理數量(Woqty)=Check In量ecm291
        #                   -總轉出量(良品轉出量ecm311+重工轉出量ecm312)
        #                   -當站報廢量ecm313
        #                   -當站下線量(入庫量)ecm314
        LET l_wipqty = 0 LET l_waitqty = 0 LET l_woqty = 0  
        LET l_wipqty = (sr.ecm301 + sr.ecm302 + sr.ecm303) -
                       (sr.ecm311 + sr.ecm312 + sr.ecm316) * sr.ecm59
                       - sr.ecm313 * sr.ecm59 - sr.ecm314 * sr.ecm59
        IF sr.ecm54='Y'   # need check in
           THEN
           LET l_waitqty = (sr.ecm301 + sr.ecm302 + sr.ecm303) - sr.ecm291
           LET l_woqty  = sr.ecm291 - (sr.ecm311 + sr.ecm312 + sr.ecm316) * sr.ecm59
                          - sr.ecm313*sr.ecm59 - sr.ecm314*sr.ecm59
        ELSE    #不用 check in
           LET l_waitqty = 0
           LET l_woqty  = l_wipqty
        END IF
        EXECUTE insert_prep USING 
                sr.sfb01  ,sr.sfb05  ,sr.sfb82  ,sr.ecm03  ,sr.ecm012 ,sr.ecm04  ,     #FUN-A60027 add ecm012
                sr.ecm06  ,sr.ecm45  ,sr.ecm301 ,sr.ecm302 ,sr.ecm303 ,sr.ecm311 ,
                sr.ecm312 ,sr.ecm313 ,sr.ecm314 ,sr.ecm315 ,sr.ecm316 ,
                sr.ecm321 ,sr.ecm322 ,sr.ecm291 ,sr.ecm54  ,sr.ecm57  ,
                sr.ecm58  ,sr.ecm59  ,sr.eca02  ,sr.ima02  ,sr.ima021 , 
                l_wipqty  ,l_waitqty ,l_woqty
                                 
      #------------------------------ CR (3) ------------------------------#
     END FOREACH
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-720005 **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'sfb01,sfb05,sfb82') 
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str ,';',tm.s[1,1],';',tm.s[2,2],';',tm.t
    #CALL cl_prt_cs3('asfr716','asfr716',l_sql,g_str)   #FUN-710080 modify
    #FUN-A60027------------------start---------------
     IF g_sma.sma541 = 'Y' THEN
        CALL cl_prt_cs3('asfr716','asfr716_1',l_sql,g_str)
     ELSE
        CALL cl_prt_cs3('asfr716','asfr716',l_sql,g_str)
     END IF 
    #FUN-A60027 -----------------end----------------
 
     #------------------------------ CR (4) ------------------------------#
     #FINISH REPORT r716_rep
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r716_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,           #No.FUN-680121 VARCHAR(1)
          l_wipqty     LIKE ecm_file.ecm302,          #No.FUN-680121 DEC(11,3)
          l_waitqty    LIKE ecm_file.ecm302,          #No.FUN-680121 DEC(11,3)
          l_woqty      LIKE ecm_file.ecm302,          #No.FUN-680121 DEC(11,3)
          l_ima02      LIKE ima_file.ima02,
          l_ima021     LIKE ima_file.ima021,
          sr        RECORD        order1 LIKE sfb_file.sfb05,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                                  order2 LIKE sfb_file.sfb05,        #No.FUN-680121 CAHR(40)#FUN-5B0105 20->40
                                  sfb01  LIKE sfb_file.sfb01,
                                  sfb05  LIKE sfb_file.sfb05,
                                  sfb82  LIKE sfb_file.sfb82,
                                  ecm03  LIKE ecm_file.ecm03,
                                  ecm04  LIKE ecm_file.ecm04,
                                  ecm06  LIKE ecm_file.ecm06,
                                  ecm45  LIKE ecm_file.ecm45,
                                  ecm301 LIKE ecm_file.ecm301,
                                  ecm302 LIKE ecm_file.ecm302,
                                  ecm303 LIKE ecm_file.ecm303,
                                  ecm311 LIKE ecm_file.ecm311,
                                  ecm312 LIKE ecm_file.ecm312,
                                  ecm313 LIKE ecm_file.ecm313,
                                  ecm314 LIKE ecm_file.ecm314,
                                  ecm315 LIKE ecm_file.ecm315,
                                  ecm316 LIKE ecm_file.ecm316,
                                  ecm321 LIKE ecm_file.ecm321,
                                  ecm322 LIKE ecm_file.ecm322,
                                  ecm291 LIKE ecm_file.ecm291,
                                  ecm54  LIKE ecm_file.ecm54,
                                  ecm57  LIKE ecm_file.ecm57,
                                  ecm58  LIKE ecm_file.ecm58,
                                  ecm59  LIKE ecm_file.ecm59,
                                  eca02  LIKE eca_file.eca02,
                                  ima02  LIKE ima_file.ima02,
                                  ima021 LIKE ima_file.ima021
                        END RECORD,
      l_chr        LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line   #No.MOD-580242
 
  ORDER BY sr.order1,sr.order2,sr.sfb01,sr.ecm03
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      PRINT ' '
      PRINT g_dash[1,g_len]
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],g_x[41]
      PRINTX name=H2 g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],g_x[51],g_x[52],g_x[53]
      PRINTX name=H3 g_x[54],g_x[55],g_x[56],g_x[57],g_x[58],g_x[59],g_x[60],g_x[61],g_x[62],g_x[63],g_x[64]
 
      PRINT g_dash1
      LET l_last_sw = 'n'
      LET l_chr = 'Y'
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
      LET l_chr = 'Y'
 
 
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
   ON EVERY ROW
 
      #WIP量(wipqty)= 總投入量(良品轉入量ecm301+重工轉入量ecm302)
      #               -總轉出量(良品轉出量ecm311+重工轉出量ecm312)
      #               -當站報廢量ecm313
      #               -當站下線量(入庫量)ecm314
      #等待上線數量(Waitqyt)=總投入量(良品轉入量ecm301+重工轉入量ecm302)
      #                      -Check In量ecm291
      #上線處理數量(Woqty)=Check In量ecm291
      #                   -總轉出量(良品轉出量ecm311+重工轉出量ecm312)
      #                   -當站報廢量ecm313
      #                   -當站下線量(入庫量)ecm314
#bugno:4857 wip/woqty add * sr.ecm59 ...........................
      LET l_wipqty = (sr.ecm301 + sr.ecm302 + sr.ecm303) -
                     (sr.ecm311 + sr.ecm312 + sr.ecm316) * sr.ecm59
                     - sr.ecm313 * sr.ecm59 - sr.ecm314 * sr.ecm59
      IF sr.ecm54='Y'   # need check in
         THEN
         LET l_waitqty = (sr.ecm301 + sr.ecm302 + sr.ecm303) - sr.ecm291
         LET l_woqty  = sr.ecm291 - (sr.ecm311 + sr.ecm312 + sr.ecm316) * sr.ecm59
                        - sr.ecm313*sr.ecm59 - sr.ecm314*sr.ecm59
#bugno:4857 end................................................
      ELSE    #不用 check in
         LET l_waitqty = 0
         LET l_woqty  = l_wipqty
      END IF
      NEED 3 LINES
      IF l_chr = 'Y'   THEN
         PRINTX name=D1 COLUMN g_c[31],sr.sfb01, COLUMN g_c[32],sr.sfb05;
      END IF
      IF  l_chr = 'Y' THEN
          LET l_ima02 = sr.ima02
          LET l_ima021= sr.ima021
      ELSE
          LET l_ima02 = ''
          LET l_ima021= ''
      END IF
      PRINTX name=D1 COLUMN g_c[33],sr.ecm03 USING '####',
            COLUMN g_c[34],sr.ecm06,
            COLUMN g_c[35],sr.ecm04,
            COLUMN g_c[36],sr.ecm301 USING '------.-',
            COLUMN g_c[37],sr.ecm311 USING '------.-',
            COLUMN g_c[38],sr.ecm313 USING '------.-',
            COLUMN g_c[39],sr.ecm315 USING '------.-',
            COLUMN g_c[40],sr.ecm321 USING '------.-',
            COLUMN g_c[41],sr.ecm291 USING '------.-'
      PRINTX name=D2 COLUMN g_c[42],' ',
             COLUMN g_c[43],l_ima02 CLIPPED,  #MOD-4A0238
            COLUMN g_c[44],' ',
            COLUMN g_c[45],sr.eca02[1,15],
            COLUMN g_c[46],sr.ecm45[1,16],
            COLUMN g_c[47],sr.ecm302 USING '------.-',
            COLUMN g_c[48],sr.ecm312 USING '------.-',
            COLUMN g_c[49],sr.ecm314 USING '------.-',
            COLUMN g_c[50],l_wipqty  USING '------.-',
            COLUMN g_c[51],sr.ecm322 USING '------.-',
            COLUMN g_c[52],l_waitqty USING '------.-',
            COLUMN g_c[53],l_woqty   USING '------.-'
      PRINTX name=D3 COLUMN g_c[54], ' ',
             COLUMN g_c[55],l_ima021 CLIPPED,  #MOD-4A0238
            COLUMN g_c[59],sr.ecm303 USING '------.-',
            COLUMN g_c[60],sr.ecm316 USING '------.-',
            COLUMN g_c[63],sr.ecm57,
            COLUMN g_c[64],sr.ecm58
      LET l_chr = 'N'
 
   AFTER GROUP OF sr.order1
      PRINT ''
 
   ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'sfb01,sfb05,sfb82') RETURNING tm.wc  #TQC-630166
         PRINT g_dash[1,g_len]
#TQC-630166-start
         CALL cl_prt_pos_wc(tm.wc) 
#            IF tm.wc[001,120] > ' ' THEN            # for 132
#         PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#             IF tm.wc[121,240] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#             IF tm.wc[241,300] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#TQC-630166-end
      END IF
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
