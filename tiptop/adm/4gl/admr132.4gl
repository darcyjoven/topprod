# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: admr132.4gl
# Descriptions...: 異常付款警訊
# Date & Author..: 02/08/14 By qazzaq
# Modify.........: No.FUN-550035 05/05/18 By Trisy 單據編號格式放大
# Modify.........: No.TQC-610083 06/04/03 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680097 06/08/28 By chen 類型轉換
# Modify.........: No.FUN-690111 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.FUN-850111 08/05/21 By lala  CR
# Modify.........: No.MOD-940398 09/05/04 By Smapmin 報表temptable未刪除,報表未依群組列印,金額未取位,未依畫面條件跳頁,資料列印重複等問題
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc      LIKE type_file.chr1000,# Where condition   #No.FUN-680097 VARCHAR(300)
              a       LIKE type_file.chr1,             #No.FUN-680097 VARCHAR(01)
              b       LIKE type_file.chr1,             #No.FUN-680097 VARCHAR(01)
              c       LIKE type_file.chr1,             #No.FUN-680097 VARCHAR(01)
              d       LIKE type_file.chr1,             #No.FUN-680097 VARCHAR(01)
              e       LIKE type_file.chr1,             #No.FUN-680097 VARCHAR(01)
              more    LIKE type_file.chr1    # Input more condition(Y/N)   #No.FUN-680097 VARCHAR(01)
              END RECORD,
          g_n         LIKE type_file.num5              #No.FUN-680097 SMALLINT
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680097 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680097 VARCHAR(72)
DEFINE   g_str      STRING          #No.FUN-850111
DEFINE   g_sql      STRING          #No.FUN-850111
DEFINE   l_table    STRING          #No.FUN-850111
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ADM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690111
 
#No.FUN-850111---start---
   LET g_sql="pma02.pma_file.pma02,",
             "l_pma02.pma_file.pma02,",
             "pmc03.pmc_file.pmc03,",
             "apa13.apa_file.apa13,",
             "apa34f.apa_file.apa34f,",
             "apa01.apa_file.apa01,",
             "paydate.type_file.dat,",
             "apa12.apa_file.apa12,",
             "apa07.apa_file.apa07,",
             "apa64.apa_file.apa64,",
             "nmd05.nmd_file.nmd05,",
             "apf02.apf_file.apf02,",
             "apf01.apf_file.apf01,",
             "flag.type_file.chr1,",
             "azi03.azi_file.azi03"   #MOD-940398
 
   LET l_table = cl_prt_temptable('admr132',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED, l_table CLIPPED,
             #" VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"   #MOD-940398
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"   #MOD-940398
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      EXIT PROGRAM
   END IF
#No.FUN-850111---end---
 
   LET g_n=0
#-------------No.TQC-610083 modify
#  LET tm.a = 'Y'
#  LET tm.b = 'Y'
#  LET tm.c = 'Y'
#  LET tm.d = 'Y'
#  LET tm.e = 'N'
#  LET tm.more = 'N'
#  LET g_pdate = g_today
#  LET g_rlang = g_lang
#  LET g_bgjob = 'N'
#  LET g_copies = '1'
#  LET tm.wc    = ARG_VAL(1)
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.a     = ARG_VAL(8)
   LET tm.b     = ARG_VAL(9)
   LET tm.c     = ARG_VAL(10)
   LET tm.d     = ARG_VAL(11)
   LET tm.e     = ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   #No.FUN-570264 ---end---
#-------------No.TQC-610083 end
   IF cl_null(tm.wc) THEN
       CALL admr132_tm(0,0)             # Input print condition
   ELSE
       CALL admr132()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
END MAIN
 
FUNCTION admr132_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680097 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680097 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   OPEN WINDOW admr132_w AT p_row,p_col
        WITH FORM "adm/42f/admr132"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
#------------No.TQC-610083 add
   INITIALIZE tm.* TO NULL                # Default condition
   LET tm.a = 'Y'
   LET tm.b = 'Y'
   LET tm.c = 'Y'
   LET tm.d = 'Y'
   LET tm.e = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
#------------No.TQC-610083 end
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON apa01,apa06,apa02,apa11
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
      LET INT_FLAG = 0 CLOSE WINDOW admr132_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   LET tm.a='Y'
   LET tm.b='Y'
   LET tm.c='Y'
   LET tm.d='Y'
   DISPLAY BY NAME tm.a,tm.b,tm.c,tm.d,tm.e,tm.more
   INPUT BY NAME tm.a,tm.b,tm.c,tm.d,tm.e,tm.more WITHOUT DEFAULTS
 
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a                             #abcde的欄位控管
        IF tm.a MATCHES "[YN]" THEN
        ELSE
           NEXT FIELD a
        END IF
      AFTER FIELD b
        IF tm.b MATCHES "[YN]" THEN
        ELSE
           NEXT FIELD b
        END IF
      AFTER FIELD c
        IF tm.c MATCHES "[YN]" THEN
        ELSE
           NEXT FIELD c
        END IF
      AFTER FIELD d
        IF tm.d MATCHES "[YN]" THEN
           IF tm.a MATCHES "[Y]" OR tm.b MATCHES "[Y]" OR tm.c MATCHES "[Y]"
              OR tm.d MATCHES "[Y]" THEN
           ELSE
              NEXT FIELD a
           END IF
        ELSE
           NEXT FIELD d
        END IF
      AFTER FIELD e
        IF tm.e MATCHES "[YN]" THEN
        ELSE
           NEXT FIELD e
        END IF
 
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
      LET INT_FLAG = 0 CLOSE WINDOW admr132_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
 
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='admr132'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('admr132','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.a CLIPPED,"'" ,
                         " '",tm.b CLIPPED,"'" ,
                         " '",tm.c CLIPPED,"'" ,
                         " '",tm.d CLIPPED,"'" ,
                         " '",tm.e CLIPPED,"'" ,
                        #" '",tm.more CLIPPED,"'",              #No.TQC-610083 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('admr132',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW admr132_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL admr132()
   ERROR ""
   END WHILE
   CLOSE WINDOW admr132_w
END FUNCTION
 
FUNCTION admr132()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680097 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0100
          l_apa24   LIKE apa_file.apa24,
          l_sql1    LIKE type_file.chr1000,       #No.FUN-680097 VARCHAR(3000)
          l_sql2    LIKE type_file.chr1000,       #No.FUN-680097 VARCHAR(3000)
          l_sql3    LIKE type_file.chr1000,       #No.FUN-680097 VARCHAR(3000)
          l_sql4    LIKE type_file.chr1000,       #No.FUN-680097 VARCHAR(3000)
          l_n1      LIKE type_file.num5,          #No.FUN-680097 SMALLINT
          l_pma02   LIKE pma_file.pma02,
          sr        RECORD
                    flag     LIKE type_file.chr1,          #No.FUN-680097 VARCHAR(1)
                    paydate  LIKE type_file.dat,           #No.FUN-680097 DATE
                    pmm01    LIKE pmm_file.pmm01,
                    apa01    LIKE apa_file.apa01,
                    pmm20    LIKE pmm_file.pmm20,
                    pma02    LIKE pma_file.pma02,
                    apa11    LIKE apa_file.apa11,
                    pmc03    LIKE pmc_file.pmc03,
                    apa13    LIKE apa_file.apa13,
                    apa34f   LIKE apa_file.apa34f,
                    apa09    LIKE apa_file.apa09,
                    apa02    LIKE apa_file.apa02,
                    apa06    LIKE apa_file.apa06,
                    apa12    LIKE apa_file.apa12,
                    apa64    LIKE apa_file.apa64,
                    apf01    LIKE apf_file.apf01,
                    apf02    LIKE apf_file.apf02,
                    nmd05    LIKE nmd_file.nmd05,
                    apa07    LIKE apa_file.apa07
                    END RECORD
 
     CALL cl_del_data(l_table)   #MOD-940398
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'admr132'
     IF g_len = 0 OR g_len IS NULL THEN
        LET g_len = 93          #No.FUN-550035
     END IF
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pmmuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND pmmgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND pmmgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup')
     #End:FUN-980030
 
#No.FUN-850111---start--- 
#     CALL cl_outnam('admr132') RETURNING l_name
#     START REPORT admr132_rep TO l_name
   WHILE tm.a MATCHES "[Y]" OR tm.b MATCHES "[Y]" OR tm.c MATCHES "[Y]" OR tm.d MATCHES "[Y]"
     CASE
        WHEN tm.a MATCHES "[Y]"
          LET l_sql1="SELECT DISTINCT '1','',pmm01,apa01,pmm20,pma02,apa11,pmc03,apa13,apa34f,'','','','','','','','','' ",   #MOD-940398加上DISTINCT
               "  FROM pmm_file,apb_file,apa_file,pma_file, OUTER pmc_file ",
               " WHERE pmm01=apb06 ",        #比對出單號相同
               "   AND apb01=apa01 ",
               "   AND pmm20<>apa11",
               "   AND pmm20=pma01 ",
              "   AND pmm_file.pmm09=pmc_file.pmc01 ",
               "   AND ",tm.wc CLIPPED,      #QBE條件
               "   AND pmm18 = 'Y' "         #採購單已確認的資料
          PREPARE admr132_prepare1 FROM l_sql1
          IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
             EXIT PROGRAM 
          END IF
          DECLARE admr132_curs1 CURSOR FOR admr132_prepare1
 
          LET g_pageno = 0
 
          FOREACH admr132_curs1 INTO sr.*
            IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#               OUTPUT TO REPORT admr132_rep(sr.*)
            #END IF
            #-----MOD-940398---------
            LET l_pma02 = NULL
            SELECT pma02 INTO l_pma02 FROM pma_file  
                 WHERE pma01=sr.apa11  
            LET t_azi03 = NULL
            SELECT azi03 INTO t_azi03 from azi_file
                 WHERE azi01=sr.apa13
            EXECUTE insert_prep USING
               sr.pma02,l_pma02,sr.pmc03,sr.apa13,sr.apa34f,sr.apa01,sr.paydate,sr.apa12,
               sr.apa07,sr.apa64,sr.nmd05,sr.apf02,sr.apf01,sr.flag,t_azi03
            #-----END MOD-940398-----
          END FOREACH
          LET tm.a="N"
        EXIT CASE
        WHEN tm.b MATCHES "[Y]"
          LET l_sql2="SELECT DISTINCT '2','',pmm01,apa01,pmm20,pma02,apa11,'',apa13,apa34f,apa09,apa02,apa06,apa12,'','','','',apa07 ",   #MOD-940398加上DISTINCT
               "  FROM pmm_file,apb_file,apa_file,pma_file ",
               " WHERE pmm01=apb06 ",       #先找出需要的資料再準備修改
               "   AND apb01=apa01 ",
               "   AND pmm20=pma01 ",
               "   AND ",tm.wc CLIPPED,      #QBE條件
               "   AND pmm18 = 'Y' "         #採購單已確認的資料
          PREPARE admr132_prepare2 FROM l_sql2
          IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
             EXIT PROGRAM 
          END IF
          DECLARE admr132_curs2 CURSOR FOR admr132_prepare2
 
          LET g_pageno = 0              #pageno有問題還要再修
 
          FOREACH admr132_curs2 INTO sr.*
            IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
            CALL s_paydate('a','',sr.apa09,sr.apa02,sr.apa11,sr.apa06)
                 RETURNING sr.paydate,sr.apa64,l_apa24
            IF sr.paydate <> sr.apa12 THEN
#               OUTPUT TO REPORT admr132_rep(sr.*)
               #-----MOD-940398---------
               LET l_pma02 = NULL
               SELECT pma02 INTO l_pma02 FROM pma_file  
                    WHERE pma01=sr.apa11  
               LET t_azi03 = NULL
               SELECT azi03 INTO t_azi03 from azi_file
                    WHERE azi01=sr.apa13
               EXECUTE insert_prep USING
                  sr.pma02,l_pma02,sr.pmc03,sr.apa13,sr.apa34f,sr.apa01,sr.paydate,sr.apa12,
                  sr.apa07,sr.apa64,sr.nmd05,sr.apf02,sr.apf01,sr.flag,t_azi03
               #-----END MOD-940398-----
            ELSE
               CONTINUE FOREACH
            END IF
          END FOREACH
          LET tm.b="N"
        EXIT CASE
        WHEN tm.c MATCHES "[Y]"
          LET l_sql3="SELECT DISTINCT '3','','',apa01,pmm20,pma02,apa11,'',apa13,apa34f,apa09,apa02,apa06,apa12,'','','',nmd05,apa07 ",   #MOD-940398加上DISTINCT
               "  FROM pmm_file,apb_file,apa_file,apg_file,apf_file,nmd_file,pma_file ",
               " WHERE pmm01 = apb06 ",       #先找出需要的資料再準備修改
               "   AND apb01 = apa01 ",
               "   AND apa01 = apg04 ",
               "   AND apg01 = apf01 ",
               "   AND apf01 = nmd10 ",
               "   AND pmm20 = pma01 ",
               "   AND ",tm.wc CLIPPED,      #QBE條件
               "   AND apf00 = '33' ",   #MOD-940398
               "   AND pmm18 = 'Y' "         #採購單已確認的資料
          PREPARE admr132_prepare3 FROM l_sql3
          IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
             EXIT PROGRAM 
          END IF
          DECLARE admr132_curs3 CURSOR FOR admr132_prepare3
 
          LET g_pageno = 0              #pageno有問題還要再修
 
          FOREACH admr132_curs3 INTO sr.*
            IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
            CALL s_paydate('a','',sr.apa09,sr.apa02,sr.apa11,sr.apa06)
                 RETURNING sr.paydate,sr.apa64,l_apa24
            IF sr.apa64 <> sr.nmd05 THEN
#               OUTPUT TO REPORT admr132_rep(sr.*)
               #-----MOD-940398---------
               LET l_pma02 = NULL
               SELECT pma02 INTO l_pma02 FROM pma_file  
                    WHERE pma01=sr.apa11  
               LET t_azi03 = NULL
               SELECT azi03 INTO t_azi03 from azi_file
                    WHERE azi01=sr.apa13
               EXECUTE insert_prep USING
                  sr.pma02,l_pma02,sr.pmc03,sr.apa13,sr.apa34f,sr.apa01,sr.paydate,sr.apa12,
                  sr.apa07,sr.apa64,sr.nmd05,sr.apf02,sr.apf01,sr.flag,t_azi03
               #-----END MOD-940398-----
            ELSE
               CONTINUE FOREACH
            END IF
          END FOREACH
          LET tm.c="N"
        EXIT CASE
        WHEN tm.d MATCHES "[Y]"
          LET l_sql4="SELECT DISTINCT '4','','',apa01,'','','','',apa13,apa34f,'','',apa06,apa12,'',apf01,apf02,'',apa07 ",   #MOD-940398加上DISTINCT
               "  FROM apa_file,apg_file,apf_file ",
               " WHERE apa01 = apg04 ",       #先找出需要的資料再準備修改
               "   AND apg01 = apf01 ",
               #"   AND apa12 <> apf02 ",   #MOD-940398
               "   AND apa12 > apf02 ",   #MOD-940398
               "   AND apf00 = '33' ",   #MOD-940398
               "   AND ",tm.wc CLIPPED        #QBE條件
          PREPARE admr132_prepare4 FROM l_sql4
          IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
             EXIT PROGRAM 
          END IF
          DECLARE admr132_curs4 CURSOR FOR admr132_prepare4
 
          LET g_pageno = 0              #pageno有問題還要再修
 
          FOREACH admr132_curs4 INTO sr.*
            IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#            OUTPUT TO REPORT admr132_rep(sr.*)
             LET l_pma02 = NULL   #MOD-940398
             SELECT pma02 INTO l_pma02 FROM pma_file
                  WHERE pma01=sr.apa11
             LET t_azi03 = NULL   #MOD-940398
             SELECT azi03 INTO t_azi03 from azi_file
                  WHERE azi01=sr.apa13
             EXECUTE insert_prep USING
                sr.pma02,l_pma02,sr.pmc03,sr.apa13,sr.apa34f,sr.apa01,sr.paydate,sr.apa12,
                #sr.apa07,sr.apa64,sr.nmd05,sr.apf02,sr.apf01,sr.flag   #MOD-940398
                sr.apa07,sr.apa64,sr.nmd05,sr.apf02,sr.apf01,sr.flag,t_azi03   #MOD-940398
     END FOREACH
     LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     CALL cl_wcchp(tm.wc,'apa01,apa06,apa02,apa11')
             RETURNING tm.wc
     #LET g_str=tm.wc   #MOD-940398
     LET g_str=tm.wc,";",tm.e   #MOD-940398
     CALL cl_prt_cs3('admr132','admr132',g_sql,g_str)
          LET tm.d="N"
        EXIT CASE
      END CASE
   END WHILE
 
#     FINISH REPORT admr132_rep
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
#REPORT admr132_rep(sr)
#  DEFINE l_last_sw LIKE type_file.chr1,          #No.FUN-680097 VARCHAR(1)
#         l_i       LIKE type_file.num5,          #No.FUN-680097 SMALLINT
#         l_pma02   LIKE pma_file.pma02,
#         sr        RECORD
#                   flag     LIKE type_file.chr1,          #No.FUN-680097 VARCHAR(1)
#                   paydate  LIKE type_file.dat,           #No.FUN-680097 DATE
#                   pmm01    LIKE pmm_file.pmm01,
#                   apa01    LIKE apa_file.apa01,
#                   pmm20    LIKE pmm_file.pmm20,
#                   pma02    LIKE pma_file.pma02,
#                   apa11    LIKE apa_file.apa11,
#                   pmc03    LIKE pmc_file.pmc03,
#                   apa13    LIKE apa_file.apa13,
#                   apa34f   LIKE apa_file.apa34f,
#                   apa09    LIKE apa_file.apa09,
#                   apa02    LIKE apa_file.apa02,
#                   apa06    LIKE apa_file.apa06,
#                   apa12    LIKE apa_file.apa12,
#                   apa64    LIKE apa_file.apa64,
#                   apf01    LIKE apf_file.apf01,
#                   apf02    LIKE apf_file.apf02,
#                   nmd05    LIKE nmd_file.nmd05,
#                   apa07    LIKE apa_file.apa07
#                   END RECORD
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.flag
# FORMAT
#  PAGE HEADER
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#     PRINT (g_len-FGL_WIDTH(g_x[1] CLIPPED))/2 SPACES,g_x[1] CLIPPED
#     PRINT ' '
#     LET g_pageno= g_pageno+1
#     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,' ',g_msg CLIPPED,
#           COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
#     PRINT g_dash[1,g_len]
 
# BEFORE GROUP OF sr.flag
#   CASE
#     WHEN sr.flag = "1"
#       PRINT COLUMN 1, g_x[11] CLIPPED
#       PRINT
#       PRINT COLUMN 2, g_x[17] CLIPPED,COLUMN 45, g_x[18] CLIPPED
#       PRINT COLUMN 1, g_x[25] CLIPPED,COLUMN 42, g_x[26] CLIPPED
#       LET l_last_sw = 'n'
#       LET g_n=g_n+1
#     EXIT CASE
#     WHEN sr.flag = "2"
#       IF tm.e MATCHES "[Y]" THEN SKIP TO TOP OF PAGE END IF
#       IF g_n>0 THEN PRINT END IF
#       PRINT COLUMN 1, g_x[12] CLIPPED,COLUMN 30, g_x[13] CLIPPED
#       PRINT
#       PRINT COLUMN 2, g_x[19] CLIPPED,COLUMN 24, g_x[20] CLIPPED,
#             COLUMN 40,g_x[21] CLIPPED
#       PRINT COLUMN 1, g_x[27] CLIPPED,COLUMN 19, g_x[28] CLIPPED,
#             COLUMN 40,g_x[29] CLIPPED
#       LET l_last_sw = "n"
#       LET g_n=g_n+1
#     EXIT CASE
#     WHEN sr.flag = "3"
#       IF tm.e MATCHES "[Y]" THEN SKIP TO TOP OF PAGE END IF
#       IF g_n>0 THEN PRINT END IF
#       PRINT COLUMN 1, g_x[14] CLIPPED,COLUMN 32, g_x[15] CLIPPED
#       PRINT
#       PRINT COLUMN 2, g_x[22] CLIPPED,COLUMN 24, g_x[20] CLIPPED,
#             COLUMN 40,g_x[21] CLIPPED
#       PRINT COLUMN 1, g_x[27] CLIPPED,COLUMN 19, g_x[28] CLIPPED,
#             COLUMN 40,g_x[29] CLIPPED
#       LET l_last_sw = 'n'
#       LET g_n=g_n+1
#     EXIT CASE
#     WHEN sr.flag = "4"
#       IF tm.e MATCHES "[Y]" THEN SKIP TO TOP OF PAGE END IF
#       IF g_n>0 THEN PRINT END IF
#       PRINT COLUMN 1, g_x[16] CLIPPED
#       PRINT
#       PRINT COLUMN 1, g_x[23] CLIPPED,COLUMN 38, g_x[24] CLIPPED
#       PRINT COLUMN 1, g_x[30] CLIPPED,COLUMN 35, g_x[31] CLIPPED
#       LET l_last_sw = 'n'
#     EXIT CASE
#   END CASE
#
#  ON EVERY ROW
 
#     LET l_i=LINENO
#     CASE
#     WHEN sr.flag = "1" AND l_i>57
#        SKIP TO TOP OF PAGE
#        PRINT COLUMN 1, g_x[11] CLIPPED
#        PRINT
#        PRINT COLUMN 2, g_x[17] CLIPPED,COLUMN 45, g_x[18] CLIPPED
#        PRINT COLUMN 1, g_x[25] CLIPPED,COLUMN 42, g_x[26] CLIPPED
#     EXIT CASE
#     WHEN sr.flag = "2" AND l_i>57
#        SKIP TO TOP OF PAGE
#        PRINT COLUMN 1, g_x[12] CLIPPED,COLUMN 30, g_x[13] CLIPPED
#        PRINT
#        PRINT COLUMN 2, g_x[19] CLIPPED,COLUMN 24, g_x[20] CLIPPED,
#              COLUMN 40,g_x[21] CLIPPED
#        PRINT COLUMN 1, g_x[27] CLIPPED,COLUMN 19, g_x[28] CLIPPED,
#              COLUMN 40,g_x[29] CLIPPED
#     EXIT CASE
#     WHEN sr.flag="3" AND l_i>57
#        SKIP TO TOP OF PAGE
#        PRINT COLUMN 1, g_x[14] CLIPPED,COLUMN 32, g_x[15] CLIPPED
#        PRINT
#        PRINT COLUMN 2, g_x[22] CLIPPED,COLUMN 24, g_x[20] CLIPPED,
#              COLUMN 40,g_x[21] CLIPPED
#        PRINT COLUMN 1, g_x[27] CLIPPED,COLUMN 19, g_x[28] CLIPPED,
#              COLUMN 40,g_x[29] CLIPPED
#     EXIT CASE
#     WHEN sr.flag="4" AND l_i>57
#        SKIP TO TOP OF PAGE
#        PRINT COLUMN 1, g_x[16] CLIPPED
#        PRINT
#        PRINT COLUMN 1, g_x[23] CLIPPED,COLUMN 38, g_x[24] CLIPPED
#        PRINT COLUMN 1, g_x[30] CLIPPED,COLUMN 35, g_x[31] CLIPPED
#     EXIT CASE
#     END CASE
#     CASE
#       WHEN sr.flag="1"
#         SELECT pma02 INTO l_pma02 FROM pma_file
#          WHERE pma01=sr.apa11
#         SELECT azi03 INTO t_azi03 from azi_file  #抓幣別單價
#          WHERE azi01=sr.apa13
#         PRINT COLUMN 1,sr.pma02[1,19] CLIPPED,
#               COLUMN 21,l_pma02[1,20] CLIPPED,
#               COLUMN 42,sr.pmc03 CLIPPED,
#               COLUMN 53,sr.apa13 CLIPPED,
#               COLUMN 57,cl_numfor(sr.apa34f,18,t_azi03) CLIPPED,
#               COLUMN 77,sr.apa01 CLIPPED       #No.FUN-550035
#       let l_i=l_i+1
#       EXIT CASE
#       WHEN sr.flag="2"
#         SELECT azi03 INTO t_azi03 from azi_file  #抓幣別單價
#          WHERE azi01=sr.apa13
#         PRINT COLUMN 1,sr.paydate CLIPPED,
#               COLUMN 10,sr.apa12 CLIPPED,
#               COLUMN 19,sr.pma02 CLIPPED,
#               COLUMN 40,sr.apa07 CLIPPED,
#               COLUMN 51,sr.apa13 CLIPPED,
#               COLUMN 55,cl_numfor(sr.apa34f,18,t_azi03) CLIPPED,
#               COLUMN 75,sr.apa01 CLIPPED       #No.FUN-550035
#       let l_i=l_i+1
#       EXIT CASE
#       WHEN sr.flag="3"
#         SELECT azi03 INTO t_azi03 from azi_file  #抓幣別單價
#          WHERE azi01=sr.apa13
#         PRINT COLUMN 1,sr.apa64 CLIPPED,
#               COLUMN 10,sr.nmd05 CLIPPED,
#               COLUMN 19,sr.pma02 CLIPPED,
#               COLUMN 40,sr.apa07 CLIPPED,
#               COLUMN 51,sr.apa13 CLIPPED,
#               COLUMN 55,cl_numfor(sr.apa34f,18,t_azi03) CLIPPED,
#               COLUMN 75,sr.apa01 CLIPPED
#       let l_i=l_i+1
#       EXIT CASE
#       WHEN sr.flag="4"
#         SELECT azi03 INTO t_azi03 from azi_file  #抓幣別單價
#          WHERE azi01=sr.apa13
#         PRINT COLUMN 1,sr.apf02 CLIPPED,
#               COLUMN 10,sr.apa12 CLIPPED,
#               COLUMN 19,sr.apa07 CLIPPED,
#               COLUMN 30,sr.apa13 CLIPPED,
#               COLUMN 34,cl_numfor(sr.apa34f,18,t_azi03) CLIPPED,
#               COLUMN 54,sr.apf01 CLIPPED,
#               COLUMN 71,sr.apa01 CLIPPED
#       let l_i=l_i+1
#       EXIT CASE
#   END CASE
 
 
#  ON LAST ROW
#     LET l_last_sw = 'y'
 
#  PAGE TRAILER
#     PRINT g_dash[1,g_len]
#     IF l_last_sw = 'n'
#        THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#     END IF
#END REPORT
#Patch....NO.TQC-610035 <001,002,003> #
#No.FUN-850111---end---
