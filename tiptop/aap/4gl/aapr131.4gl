# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: aapr131.4gl
# Descriptions...: 進貨發票金額差異明細表
# Date & Author..: 93/09/09  By  Roger
# Modify.........: No.FUN-4C0097 04/12/24 By Nicola 報表架構修改
#                                                   增加印列員工姓名gen02、差異名稱apa56a
# Modify.........: No.TQC-630236 06/03/24 By Smapmin 拿掉CONTROLP
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/09 By baogui 列印順序寫錯
# Modify.........: No.FUN-750095 07/05/25 By Lynn 報表功能改為使用CR
# Modify.........: No.TQC-760067 07/06/07 By Smapmin 增加開窗功能
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
              #wc      LIKE type_file.chr1000,  #TQC-630166  #No.FUN-690028 VARCHAR(600)
              wc       STRING,   #TQC-630166
              s       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(03), 
              t       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(03),
              u       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(03),
              more    LIKE type_file.chr1         # No.FUN-690028 VARCHAR(01)
           END RECORD
DEFINE   g_orderA ARRAY[3] OF LIKE zaa_file.zaa08      # No.FUN-690028 VARCHAR(10)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
#     DEFINEl_time LIKE type_file.chr8         #No.FUN-6A0055
DEFINE l_table        STRING,                 # No.FUN-750095                                                                
       g_str          STRING,                 # No.FUN-750095                                                                    
       g_sql          STRING                  # No.FUN-750095
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
# No.FUN-750095--begin--
   LET g_sql = " apa01.apa_file.apa01,",
               " apa02.apa_file.apa02,",
               " apa06.apa_file.apa06,",
               " apa08.apa_file.apa08,",
               " apa11.apa_file.apa11,",
               " apa12.apa_file.apa12,",
               " apa13.apa_file.apa13,",
               " apa15.apa_file.apa15,",
               " apa21.apa_file.apa21,",
               " apa22.apa_file.apa22,",
               " apa24.apa_file.apa24,",
               " apa31.apa_file.apa31,",
               " apa56.apa_file.apa56,",
               " apa57.apa_file.apa57,",
               " apa36.apa_file.apa36,",
               " apr02.apr_file.apr02,",
               " apa07.apa_file.apa07,",
#              " azi03.azi_file.azi03,",
#              " azi04.azi_file.azi04,",   
#              " azi05.azi_file.azi05,",   
#              " apa56a.zaa_file.zaa08,",   
               " gen02.gen_file.gen02 "   
 
   LET l_table = cl_prt_temptable('aapr131',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?,  ?, ?, ?, ?, ?,  ?, ?, ?, ?, ?,  ?, ?, ?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN                                                                                                                  
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
   END IF   
# No.FUN-750095--end--
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r131_tm(0,0)
   ELSE
      CALL r131()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
END MAIN
 
FUNCTION r131_tm(p_row,p_col)
DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
 
   LET p_row = 3 LET p_col = 13
   OPEN WINDOW r131_w AT p_row,p_col
     WITH FORM "aap/42f/aapr131"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.s    = '723'
   LET tm.u    = 'Y'
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
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   LET tm2.u3   = tm.u[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON apa21,apa06,apa02,apa01,apa22,apa36,apa56
 
         #-----TQC-760067---------
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(apa21)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_gen"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apa21
                  NEXT FIELD apa21
               WHEN INFIELD(apa06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_pmc11"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apa06
                  NEXT FIELD apa06
               WHEN INFIELD(apa01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_apa"
                  LET g_qryparam.arg1 = '11'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apa01
                  NEXT FIELD apa01
               WHEN INFIELD(apa22)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_gem"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apa22
                  NEXT FIELD apa22
               WHEN INFIELD(apa36)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_apr"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apa36
                  NEXT FIELD apa36
            END CASE
         #-----END TQC-760067-----
         ON ACTION locale
            LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
 
      END CONSTRUCT
 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r131_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,
                    tm2.u1,tm2.u2,tm2.u3,tm.more WITHOUT DEFAULTS
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         #ON ACTION CONTROLP   #TQC-630236
         #   CALL r131_wc()   #TQC-630236
 
         AFTER INPUT
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
            LET tm.t = tm2.t1,tm2.t2,tm2.t3
            LET tm.u = tm2.u1,tm2.u2,tm2.u3
 
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
 
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r131_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='aapr131'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aapr131','9031',1)
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
                        " '",tm.s CLIPPED,"'",
                        " '",tm.t CLIPPED,"'",
                        " '",tm.u CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aapr131',g_time,l_cmd)
         END IF
 
         CLOSE WINDOW r131_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL r131()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r131_w
 
END FUNCTION
 
FUNCTION r131_wc()
#DEFINE l_wc LIKE type_file.chr1000  #TQC-630166  #No.FUN-690028 VARCHAR(300)
DEFINE l_wc  STRING   #TQC-630166
 
   OPEN WINDOW r131_w2 AT 2,2
     WITH FORM "aap/42f/aapt110"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("aapt110")
   CALL cl_opmsg('q')
 
   CONSTRUCT BY NAME l_wc ON apa01,apa02,apa05,apa06,apa18,apa08,apa09,
                             apa11,apa12,apa13,apa14,apa15,apa16,apa55,
                             apa41,apa19,apa20,apa171,apa17,apa172,apa173,
                             apa174,apa21,apa22,apa24,apa25,apa44,apamksg,
                             apa36,apa31,apa51,apa32,apa52,apa31,apa54,
                             apa57,apa33,apa53,apainpd,apauser,apagrup,
                             apamodu,apadate,apaacti
 
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
 
   END CONSTRUCT
 
   CLOSE WINDOW r131_w2
 
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r131_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
 
END FUNCTION
 
FUNCTION r131()
DEFINE l_name    LIKE type_file.chr20          # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#DEFINE l_time    LIKE type_file.chr8            # Used time for running the job  #No.FUN-690028 VARCHAR(8)
#DEFINE l_sql     LIKE type_file.chr1000      # RDSQL STATEMENT   #TQC-630166  #No.FUN-690028 VARCHAR(1200)
DEFINE l_sql      STRING       # RDSQL STATEMENT   #TQC-630166
DEFINE l_order   ARRAY[5] OF LIKE apa_file.apa01      # No.FUN-690028 VARCHAR(10)
DEFINE sr        RECORD order1 LIKE apa_file.apa01,        # No.FUN-690028 VARCHAR(10),
                        order2 LIKE apa_file.apa01,        # No.FUN-690028 VARCHAR(10),
                        order3 LIKE apa_file.apa01,        # No.FUN-690028 VARCHAR(10),
                        apa01 LIKE apa_file.apa01,
                        apa02 LIKE apa_file.apa02,
                        apa06 LIKE apa_file.apa06,
                        apa08 LIKE apa_file.apa08,
                        apa11 LIKE apa_file.apa11,
                        apa12 LIKE apa_file.apa12,
                        apa13 LIKE apa_file.apa13,
                        apa15 LIKE apa_file.apa15,
                        apa21 LIKE apa_file.apa21,
                        apa22 LIKE apa_file.apa22,
                        apa24 LIKE apa_file.apa24,
                        apa31 LIKE apa_file.apa31,
                        apa56 LIKE apa_file.apa56,
                        apa57 LIKE apa_file.apa57,
                        diff  LIKE apa_file.apa57,
                        apa36 LIKE apa_file.apa36,
                        apr02 LIKE apr_file.apr02,
                        apa07 LIKE apa_file.apa07,
                        azi03 LIKE azi_file.azi03,
                        azi04 LIKE azi_file.azi04,
                        azi05 LIKE azi_file.azi05,
                        apa56a LIKE zaa_file.zaa08,   #No.FUN-690028 VARCHAR(8)
                        gen02 LIKE gen_file.gen02
                        END RECORD
 
#    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
# No.FUN-750095--begin--
 
   CALL cl_del_data(l_table)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
 
# No.FUN-750095--end--
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND apauser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND apagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND apagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('apauser', 'apagrup')
   #End:FUN-980030
 
 
   LET l_sql = "SELECT '','','',",
               " apa01, apa02, apa06, apa08, apa11, apa12,",
               " apa13, apa15, apa21,apa22, apa24, apa31, apa56, apa57, 0,",
               " apa36, apr02, apa07, azi03, azi04, azi05,'',''",
               " FROM apa_file,OUTER apr_file,OUTER azi_file",
               " WHERE apa00 ='11' ",              #帳款性質須為"11"
               "   AND (apa31 <> apa57 OR apa57 IS NULL)",
                 " AND azi_file.azi01 = apa_file.apa13 ",
                 " AND apa_file.apa36 = apr_file.apr01 ",
               "   AND apa41='Y' AND apa42='N' AND apa74='N'",
               "   AND ", tm.wc CLIPPED
   PREPARE r131_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   DECLARE r131_curs1 CURSOR FOR r131_prepare1
 
#  CALL cl_outnam('aapr131') RETURNING l_name     # No.FUN-750095
#  START REPORT r131_rep TO l_name     # No.FUN-750095
 
   LET g_pageno = 0
 
   FOREACH r131_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      SELECT gen02 INTO sr.gen02 FROM gen_file
       WHERE gen01 = sr.apa21
# No.FUN-750095--begin--
#     CASE WHEN sr.apa56 = '1' LET sr.apa56a = g_x[21]
#          WHEN sr.apa56 = '2' LET sr.apa56a = g_x[22]
#          WHEN sr.apa56 = '3' LET sr.apa56a = g_x[23]
#          WHEN sr.apa56 = '4' LET sr.apa56a = g_x[24]
#          WHEN sr.apa56 = '5' LET sr.apa56a = g_x[25]
#          OTHERWISE           LET sr.apa56a = ''
#     END CASE
# No.FUN-750095--end--
 
      IF cl_null(sr.azi03) THEN LET sr.azi03 = 0 END IF
      IF cl_null(sr.azi04) THEN LET sr.azi04 = 0 END IF
      IF cl_null(sr.azi05) THEN LET sr.azi05 = 0 END IF
      IF cl_null(sr.apa56) THEN LET sr.apa56 = ' ' END IF
      IF cl_null(sr.apa57) THEN LET sr.apa57 = 0 END IF
 
      LET sr.diff = sr.apa31 - sr.apa57
 
# No.FUN-750095--begin--
      FOR g_i = 1 TO 3
         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.apa21
                                       LET g_orderA[g_i]= g_x[14]
              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.apa06
                                       LET g_orderA[g_i]= g_x[15]
              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.apa02 USING 'YYYYMMDD'
                                       LET g_orderA[g_i]= g_x[16]
              WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.apa01
                                       LET g_orderA[g_i]= g_x[17]
              WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.apa22
                                       LET g_orderA[g_i]= g_x[18]
              WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.apa36
                                       LET g_orderA[g_i]= g_x[19]
              WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.apa56
                                       LET g_orderA[g_i]= g_x[20]
              OTHERWISE LET l_order[g_i]  = '-'
                        LET g_orderA[g_i] = ' '          #清為空白
         END CASE
      END FOR
# No.FUN-750095--end--
      LET sr.order1 = l_order[1]
      LET sr.order2 = l_order[2]
      LET sr.order3 = l_order[3]
      IF sr.order1 IS NULL THEN LET sr.order1 = ' '  END IF
      IF sr.order2 IS NULL THEN LET sr.order2 = ' '  END IF
      IF sr.order3 IS NULL THEN LET sr.order3 = ' '  END IF
 
# No.FUN-750095--begin--
#     OUTPUT TO REPORT r131_rep(sr.*)     
      EXECUTE insert_prep USING
              sr.apa01,sr.apa02,sr.apa06,sr.apa08,sr.apa11,sr.apa12,sr.apa13,
              sr.apa15,sr.apa21,sr.apa22,sr.apa24,sr.apa31,sr.apa56,sr.apa57,
              sr.apa36,sr.apr02,sr.apa07,sr.gen02
 
   END FOREACH
 
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = ''
   IF g_zz05 = 'Y' THEN                                                                                                            
      CALL cl_wcchp(tm.wc,'apa21,apa06,apa02,apa01,apa22,apa36,apa56')                                                                                           
           RETURNING tm.wc                                                                                                         
      LET g_str = tm.wc                                                                                                            
   END IF
   LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t,";",tm.u
                    ,";",g_azi03,";",g_azi04,";",g_azi05
   CALL cl_prt_cs3('aapr131','aapr131',l_sql,g_str)
#  FINISH REPORT r131_rep
 
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
# No.FUN-750095--end--
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055    #FUN_B80105
 
END FUNCTION
 
# No.FUN-750095--begin--
{
REPORT r131_rep(sr)
DEFINE l_last_sw    LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
DEFINE sr           RECORD order1 LIKE apa_file.apa01,        # No.FUN-690028 VARCHAR(10),
                           order2 LIKE apa_file.apa01,        # No.FUN-690028 VARCHAR(10),
                           order3 LIKE apa_file.apa01,        # No.FUN-690028 VARCHAR(10),
                           apa01 LIKE apa_file.apa01,
                           apa02 LIKE apa_file.apa02,
                           apa06 LIKE apa_file.apa06,
                           apa08 LIKE apa_file.apa08,
                           apa11 LIKE apa_file.apa11,
                           apa12 LIKE apa_file.apa12,
                           apa13 LIKE apa_file.apa13,
                           apa15 LIKE apa_file.apa15,
                           apa21 LIKE apa_file.apa21,
                           apa22 LIKE apa_file.apa22,
                           apa24 LIKE apa_file.apa24,
                           apa31 LIKE apa_file.apa31,
                           apa56 LIKE apa_file.apa56,
                           apa57 LIKE apa_file.apa57,
                           diff  LIKE apa_file.apa57,
                           apa36 LIKE apa_file.apa36,
                           apr02 LIKE apr_file.apr02,
                           apa07 LIKE apa_file.apa07,
                           azi03 LIKE azi_file.azi03,
                           azi04 LIKE azi_file.azi04,
                           azi05 LIKE azi_file.azi05,
                           apa56a LIKE zaa_file.zaa08,      # No.FUN-690028 VARCHAR(8),
                           gen02 LIKE gen_file.gen02
                    END RECORD
DEFINE l_apr02      LIKE apr_file.apr02     # 帳款類別名稱
DEFINE l_amt_1      LIKE apa_file.apa31
DEFINE l_amt_2      LIKE apa_file.apa57
DEFINE l_amt_3      LIKE apa_file.apa57
DEFINE g_head1      STRING
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.order1,sr.order2,sr.order3,sr.apa01
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         LET g_head1 = g_x[13] CLIPPED,g_orderA[1] CLIPPED,                 #TQC-6A0088
                       '-',g_orderA[2] CLIPPED,'-',g_orderA[3] CLIPPED
         PRINT g_head1
         PRINT g_dash[1,g_len]
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
               g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45]
         PRINT g_dash1
         LET l_last_sw = 'n'
 
      BEFORE GROUP OF sr.order1
         IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9) THEN
            SKIP TO TOP OF PAGE
         END IF
 
      BEFORE GROUP OF sr.order2
         IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9) THEN
            SKIP TO TOP OF PAGE
         END IF
 
      BEFORE GROUP OF sr.order3
         IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 9) THEN
            SKIP TO TOP OF PAGE
         END IF
 
      ON EVERY ROW
         PRINT COLUMN g_c[31],sr.apa21,
               COLUMN g_c[32],sr.gen02,
               COLUMN g_c[33],sr.apa06,
               COLUMN g_c[34],sr.apa07,
               COLUMN g_c[35],sr.apa02,
               COLUMN g_c[36],sr.apa08,
               COLUMN g_c[37],sr.apr02,
               COLUMN g_c[38],sr.apa01,
               COLUMN g_c[39],sr.apa15,
               COLUMN g_c[40],sr.apa13,
               COLUMN g_c[41],cl_numfor(sr.apa31,41,g_azi04),
               COLUMN g_c[42],cl_numfor(sr.apa57,42,g_azi04),
               COLUMN g_c[43],cl_numfor(sr.diff,43,g_azi04),
               COLUMN g_c[44],sr.apa56,
               COLUMN g_c[45],sr.apa56a
 
      AFTER GROUP OF sr.order1
         IF tm.u[1,1] = 'Y' THEN
            LET l_amt_1 = GROUP SUM(sr.apa31)
            LET l_amt_2 = GROUP SUM(sr.apa57)
            LET l_amt_3 = GROUP SUM(sr.diff)
            PRINT COLUMN g_c[38],g_dash2[1,g_w[38]+g_w[39]+g_w[40]+g_w[41]+g_w[42]+g_w[43]+5]
            PRINT COLUMN g_c[38],g_orderA[1] CLIPPED,
                  COLUMN g_c[39],g_x[11] CLIPPED,
                  COLUMN g_c[41],cl_numfor(l_amt_1,41,g_azi05),
                  COLUMN g_c[42],cl_numfor(l_amt_2,42,g_azi05),
                  COLUMN g_c[43],cl_numfor(l_amt_3,43,g_azi05)
            PRINT ''
         END IF
 
      AFTER GROUP OF sr.order2
         IF tm.u[2,2] = 'Y' THEN
            LET l_amt_1 = GROUP SUM(sr.apa31)
            LET l_amt_2 = GROUP SUM(sr.apa57)
            LET l_amt_3 = GROUP SUM(sr.diff)
            PRINT COLUMN g_c[38],g_orderA[2] CLIPPED,
                  COLUMN g_c[39],g_x[10] CLIPPED,
                  COLUMN g_c[41],cl_numfor(l_amt_1,41,g_azi05),
                  COLUMN g_c[42],cl_numfor(l_amt_2,42,g_azi05),
                  COLUMN g_c[43],cl_numfor(l_amt_3,43,g_azi05)
            PRINT ''
         END IF
 
      AFTER GROUP OF sr.order3
         IF tm.u[3,3] = 'Y' THEN
            LET l_amt_1 = GROUP SUM(sr.apa31)
            LET l_amt_2 = GROUP SUM(sr.apa57)
            LET l_amt_3 = GROUP SUM(sr.diff)
            PRINT COLUMN g_c[38],g_orderA[3] CLIPPED,
                  COLUMN g_c[39],g_x[9] CLIPPED,
                  COLUMN g_c[41],cl_numfor(l_amt_1,41,g_azi05),
                  COLUMN g_c[42],cl_numfor(l_amt_2,42,g_azi05),
                  COLUMN g_c[43],cl_numfor(l_amt_3,43,g_azi05)
            PRINT ''
         END IF
 
      ON LAST ROW
         LET l_amt_1 = SUM(sr.apa31)
         LET l_amt_2 = SUM(sr.apa57)
         LET l_amt_3 = SUM(sr.diff)
         PRINT COLUMN g_c[38],g_x[12] CLIPPED,
               COLUMN g_c[41],cl_numfor(l_amt_1,41,g_azi05),
               COLUMN g_c[42],cl_numfor(l_amt_2,42,g_azi05),
               COLUMN g_c[43],cl_numfor(l_amt_3,43,g_azi05)
 
         IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
            CALL cl_wcchp(tm.wc,'apa01,apa02,apa03,apa04,apa05') RETURNING tm.wc
            PRINT g_dash[1,g_len]
            #TQC-630166
            #IF tm.wc[001,070] > ' ' THEN            # for 80
            #   PRINT COLUMN g_c[31],g_x[8] CLIPPED,
            #         COLUMN g_c[32],tm.wc[001,070] CLIPPED
            #END IF
            #IF tm.wc[071,140] > ' ' THEN
            #   PRINT COLUMN g_c[32],tm.wc[071,140] CLIPPED
            #END IF
            #IF tm.wc[141,210] > ' ' THEN
            #   PRINT COLUMN g_c[32],tm.wc[141,210] CLIPPED
            #END IF
            #IF tm.wc[211,280] > ' ' THEN
            #   PRINT COLUMN g_c[32],tm.wc[211,280] CLIPPED
            #END IF
            CALL cl_prt_pos_wc(tm.wc)
            #END TQC-630166
         END IF
         PRINT g_dash[1,g_len]
         LET l_last_sw = 'y'
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[45],g_x[7] CLIPPED
 
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[45],g_x[6] CLIPPED
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT
}
# No.FUN-750095--end--
