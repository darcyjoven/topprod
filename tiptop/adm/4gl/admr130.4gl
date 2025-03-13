# Prog. Version..: '5.30.06-13.03.14(00010)'     #
#
# Pattern name...: admr130.4gl
# Descriptions...: 採購/收貨/付款單價不符分析表
# Date & Author..: 02/04/03 By Wiky
# Modify.........: No.FUN-4C0099 05/01/18 By kim 報表轉XML功能
# Modify.........: No.FUN-570243 05/07/25 By vivien 料件編號欄位增加controlp
# Modify.........: No.TQC-610083 06/04/03 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680097 06/08/28 By chen 類型轉換
# Modify.........: No.FUN-690111 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Jackho 本（原）幣取位修改
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.TQC-6A0079 06/10/30 By king 改正被誤定義為apm08類型的
# Modify.........: No.TQC-760025 07/06/26 By Carol 報表per調整,INPUT條件加open window查詢
# Modify.........: No.FUN-750027 07/07/11 By TSD.liquor 報表改成Crystal Report方式
# Modify.........: No.MOD-860187 08/06/17 By Smapmin 將l_rvb/l_apb改為DYNAMIC ARRAY
# Modify.........: No.MOD-970227 09/07/27 By Dido apb/rvb 應取其一即可
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.TQC-A40116 10/04/26 BY liuxqa modify sql
# Modify.........: No.MOD-C40083 12/04/11 By Elise 收貨單及付款單皆join單頭，抓取已確認的資料
# Modify.........: No.MOD-D10004 13/01/28 By Elise 有暫估、應付,單價又不同時因apb會抓到兩筆,導致另一筆對應不到rvb,調整排除暫估apb00=16
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc      LIKE type_file.chr1000,# Where condition   #No.FUN-680097 VARCHAR(300)
              bdate   LIKE type_file.dat,              #No.FUN-680097 DATE
              edate   LIKE type_file.dat,              #No.FUN-680097 DATE
              more    LIKE type_file.chr1              # Input more condition(Y/N)  #No.FUN-680097 VARCHAR(01)
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680097 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680097 VARCHAR(72)
DEFINE   l_table        STRING, #FUN-750027###
         g_str          STRING, #FUN-750027### 
         g_sql          STRING  #FUN-750027### 
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
 
   #str FUN-750027 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "pmm09.pmm_file.pmm09,",
               "pmm12.pmm_file.pmm12,",
               "pmm22.pmm_file.pmm22,",
               "pmn31.pmn_file.pmn31,",
               "pmm01.pmm_file.pmm01,",
               "pmm04.pmm_file.pmm04,",
               "pmn041.pmn_file.pmn041,",
               "pmn02.pmn_file.pmn02,",
               "pmn04.pmn_file.pmn04,",
               "pmc03.pmc_file.pmc03,",
               "gen02.gen_file.gen02,",
               "rvb10.rvb_file.rvb10,",
               "apb23.apb_file.apb23,",
               "ima021.ima_file.ima021,",
               "azi03.azi_file.azi03"
 
 
   LET l_table = cl_prt_temptable('admr130',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED, #TQC-A40116 mod
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
   #end FUN-750027 add
 
 
#------------No.TQC-610083 modify
#  LET tm.more = 'N'
#  LET tm.edate =g_today 
#  LET tm.bdate =g_today
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
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#------------No.TQC-610083 end
   IF cl_null(tm.wc) THEN
       CALL admr130_tm(0,0)             # Input print condition
   ELSE
       CALL admr130()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
END MAIN
 
FUNCTION admr130_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680097 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680097 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   OPEN WINDOW admr130_w AT p_row,p_col
        WITH FORM "adm/42f/admr130"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
#------------No.TQC-610083 add
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET tm.edate =g_today 
   LET tm.bdate =g_today
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
#------------No.TQC-610083 end
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pmn04,pmm12,pmm09
 
#No.FUN-570243 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION CONTROLP
            IF INFIELD(pmn04) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmn04
               NEXT FIELD pmn04
            END IF
#TQC-760025-add
            IF INFIELD(pmm09) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pmc1"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmm09
               NEXT FIELD pmm09
            END IF
            IF INFIELD(pmm12) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmm12
               NEXT FIELD pmm12
            END IF
#TQC-760025-add-end
 
#No.FUN-570243 --end
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
      LET INT_FLAG = 0 CLOSE WINDOW admr130_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.bdate,tm.edate,tm.more
   INPUT BY NAME tm.bdate,tm.edate,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD bdate
         IF cl_null(tm.bdate) THEN
             NEXT FIELD bdate
         END IF
 
      AFTER FIELD edate
        IF cl_null(tm.edate) OR tm.edate < tm.bdate THEN
            NEXT FIELD edate
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
      LET INT_FLAG = 0 CLOSE WINDOW admr130_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='admr130'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('admr130','9031',1)
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
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.bdate CLIPPED,"'" ,
                         " '",tm.edate CLIPPED,"'" ,
                        #" '",tm.more CLIPPED,"'"  ,        #No.TQC-610083 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('admr130',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW admr130_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL admr130()
   ERROR ""
END WHILE
   CLOSE WINDOW admr130_w
END FUNCTION
 
FUNCTION admr130()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680097 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0100
          l_sql     LIKE type_file.chr1000,       #No.FUN-680097 VARCHAR(3000)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680097 VARCHAR(40)
          l_n1      LIKE type_file.num5,          #No.FUN-680097 SMALLINT
          sr        RECORD
                    pmm09    LIKE pmm_file.pmm09,
                    pmm12    LIKE pmm_file.pmm12,
                    pmm22    LIKE pmm_file.pmm22,
                    pmn31    LIKE pmn_file.pmn31,
                    pmm01    LIKE pmm_file.pmm01,
                    pmm04    LIKE pmm_file.pmm04,
                    pmn041   LIKE pmn_file.pmn041,
                    pmn02    LIKE pmn_file.pmn02,
                    pmn04    LIKE pmn_file.pmn04
                    END RECORD
   #-------FUN-750027 TSD.liquor add start----------------
   DEFINE l_n2      LIKE type_file.num5,         
          l_n       LIKE type_file.num5,         
          l_i       LIKE type_file.num5,         
          l_pmc03   LIKE pmc_file.pmc03,
          l_gen02   LIKE gen_file.gen02,
          l_ima021  LIKE ima_file.ima021,
          #l_rvb     ARRAY[10]  OF RECORD   #MOD-860187
          l_rvb     DYNAMIC ARRAY  OF RECORD   #MOD-860187
                    rvb03    LIKE rvb_file.rvb03,
                    rvb04    LIKE rvb_file.rvb04,
                    rvb05    LIKE rvb_file.rvb05,
                    rvb10    LIKE rvb_file.rvb10
                    END RECORD ,
          #l_apb     ARRAY[10]  OF RECORD   #MOD-860187
          l_apb     DYNAMIC ARRAY  OF RECORD   #MOD-860187
                    apb06    LIKE apb_file.apb06,
                    apb07    LIKE apb_file.apb07,
                    apb23    LIKE apb_file.apb23
                    END RECORD 
     #------------FUN-750027 add end---------------------
 
     #str FUN-750027 add
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
     CALL cl_del_data(l_table)
     #------------------------------ CR (2) ------------------------------#
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 =  g_prog  #FUN-750027 add
 
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
 
     LET l_sql="SELECT pmm09,pmm12,pmm22,pmn31,pmm01,pmm04,pmn041,pmn02,pmn04 ",
               "  FROM pmm_file, OUTER pmn_file ",
              " WHERE pmm_file.pmm01=pmn_file.pmn01 ",
               "   AND pmm04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
               "   AND ",tm.wc CLIPPED,
               "   AND pmm18 = 'Y' "  #採購單已確認的資料
     PREPARE admr130_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
        EXIT PROGRAM 
     END IF
     DECLARE admr130_curs1 CURSOR FOR admr130_prepare1
 
     CALL cl_outnam('admr130') RETURNING l_name
 
     LET g_pageno = 0
 
     FOREACH admr130_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       #sr.pmm01 ='101-040005' THEN
       #------FUN-750027 TSD.liquor add start 原ON EVERY ROW段---------- 
         #-----MOD-860187---------
         #FOR l_n=1 TO 10
         #    INITIALIZE  l_rvb[l_n].* TO NULL
         #    INITIALIZE  l_apb[l_n].* TO NULL
         #END FOR
         CALL l_rvb.clear()
         CALL l_apb.clear()
         #-----END MOD-860187-----
 
         SELECT pmc03 INTO l_pmc03 FROM pmc_file
           WHERE pmc01=sr.pmm09
         SELECT gen02 INTO l_gen02 FROM gen_file
           WHERE gen01=sr.pmm12
         SELECT azi03 INTO t_azi03 from azi_file  #抓幣別單價   #No.CHI-6A0004
           WHERE azi01=sr.pmm22
 
         DECLARE admr130_rvb CURSOR FOR           #抓收貨單價
            #SELECT rvb03,rvb04,rvb05,rvb10		#MOD-970227 mark
             SELECT DISTINCT rvb03,rvb04,rvb05,rvb10  	#MOD-970227 
             FROM rvb_file,rva_file      #MOD-C40083 add rva_file 
              WHERE rvb03=sr.pmn02
                AND rvb04=sr.pmm01
                AND rvb05=sr.pmn04
                AND rva01 = rvb01   #MOD-C40083 add
                AND rvaconf='Y'     #MOD-C40083 add
         LET l_n1=1
         FOREACH admr130_rvb INTO l_rvb[l_n1].*
         LET l_n1=l_n1+1
         END FOREACH
         DECLARE admr130_apb CURSOR FOR     #抓付款單價
            #SELECT apb06,apb07,apb23			#MOD-970227 mark
             SELECT DISTINCT apb06,apb07,apb23		#MOD-970227 
             FROM  apb_file,apa_file     #MOD-C40083 add apa_file
              WHERE apb06=sr.pmm01
                AND apb07=sr.pmn02
                AND apa01 = apb01   #MOD-C40083 add
                AND apa41='Y'       #MOD-C40083 add
                AND apa00!='16'     #MOD-D10004 add
         LET l_n2=1
         FOREACH admr130_apb INTO l_apb[l_n2].*
         LET l_n2=l_n2+1
         END FOREACH
         IF l_n1<l_n2 THEN                   #抓兩陣列最大數
            LET l_n=l_n2
         ELSE
            LET l_n=l_n1
         END IF
         FOR l_i=1 TO l_n-1
             SELECT ima021 INTO l_ima021 FROM ima_file
                 WHERE ima01=sr.pmn04
             IF SQLCA.sqlcode THEN
                 LET l_ima021 = NULL
             END IF
 
             IF (sr.pmn31 != l_rvb[l_i].rvb10) OR
                (sr.pmn31 !=l_apb[l_i].apb23)  OR
                ( cl_null(l_rvb[l_i].rvb10) OR cl_null(l_apb[l_i].apb23))
             THEN
               ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
                EXECUTE insert_prep USING
                    sr.*,l_pmc03,l_gen02,l_rvb[l_i].rvb10,l_apb[l_i].apb23,
                    l_ima021,g_azi03
               #------------------------------ CR (3) ------------------------------#
               #end FUN-750027 add
             END IF
         END FOR 
         #-------------FUN-750027 add end----------------------
     END FOREACH
 
       #str FUN-750027 add
       ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
       LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
       #是否列印選擇條件
       IF g_zz05 = 'Y' THEN
          CALL cl_wcchp(tm.wc,'pmn04,pmm12,pmm09') RETURNING tm.wc
          LET g_str = tm.wc
       END IF
       LET g_str = g_str,";",tm.bdate,";",tm.edate 
       CALL cl_prt_cs3('admr130','admr130',l_sql,g_str)
       #------------------------------ CR (4) ------------------------------#
END FUNCTION
 
