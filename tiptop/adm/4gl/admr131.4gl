# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: admr131.4gl
# Descriptions...: 接單/出貨/收款單價不符分析表
# Date & Author..: 02/09/02 By qazzaq
# Modify.........: No.FUN-4C0099 05/01/18 By kim 報表轉XML功能
# Modify.........: No.MOD-5C0076 05/12/14 By Nicola DECLARE admr131_ogb CURSOR FOR 多串oga_file將oga09='1' or '5' 的剔除
# Modify.........: No.FUN-610020 06/01/09 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.TQC-610083 06/04/03 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680097 06/08/28 By chen 類型轉換
# Modify.........: No.FUN-690111 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Jackho 本（原）幣取位修改
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.TQC-6A0079 06/10/30 By king 改正被誤定義為apm08類型的
# Modify.........: No.TQC-6A0116 06/11/08 By king 改正報表中有關錯誤
# Modify.........: No.FUN-750027 07/07/11 By TSD.liquor 報表改成Crystal Report方式
# Modify.........: No.TQC-760021 07/06/26 By Carol 報表格式/per調整,INPUT條件加open window查詢
# Modify.........: No.TQC-840028 08/04/15 By Carol 列印資料檢查邏輯調整
# Modify.........: No.TQC-860004 08/06/03 By Carol 列印資料檢查邏輯調整
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm      RECORD
                  wc      LIKE type_file.chr1000,          #No.FUN-680097 VARCHAR(300)
                  bdate   LIKE type_file.dat,              #No.FUN-680097 DATE
                  edate   LIKE type_file.dat,              #No.FUN-680097 DATE
                  more    LIKE type_file.chr1              #No.FUN-680097 VARCHAR(01)
               END RECORD
DEFINE g_i     LIKE type_file.num5     #count/index for any purpose        #No.FUN-680097 SMALLINT
DEFINE g_msg   LIKE type_file.chr1000       #No.FUN-680097 VARCHAR(72)
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
   LET g_sql = "oea03.oea_file.oea03,",
               "oea032.oea_file.oea032,",
               "oea01.oea_file.oea01,",
               "oea02.oea_file.oea02,",
               "oea14.oea_file.oea14,",
               "oea23.oea_file.oea23,",
               "oeb01.oeb_file.oeb01,",
               "oeb03.oeb_file.oeb03,",
               "oeb04.oeb_file.oeb04,",
               "oeb13.oeb_file.oeb13,",
               "oeb06.oeb_file.oeb06,",
               "gen02.gen_file.gen02,",
               "ogb13.ogb_file.ogb13,",
               "omb13.omb_file.omb13,",
               "ima021.ima_file.ima021,",
               "azi03.azi_file.azi03"
 
   LET l_table = cl_prt_temptable('admr131',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
   #end FUN-750027 add
 
#---------No.TQC-610083 modify
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
      CALL admr131_tm(0,0)             # Input print condition
   ELSE
      CALL admr131()                   # Read data and create out-file
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
END MAIN
 
FUNCTION admr131_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col  LIKE type_file.num5,         #No.FUN-680097 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680097 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   OPEN WINDOW admr131_w AT p_row,p_col
     WITH FORM "adm/42f/admr131"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
#---------No.TQC-610083 add
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET tm.edate =g_today 
   LET tm.bdate =g_today
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
#---------No.TQC-610083 end
   WHILE TRUE
#     CONSTRUCT BY NAME tm.wc ON oeb04,oea14,oea03   #TQC-760021 mark
      CONSTRUCT BY NAME tm.wc ON oeb04,oea03,oea14   #TQC-760021 modify
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
#TQC-760021-add
      ON ACTION CONTROLP
            IF INFIELD(oeb04) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oeb04
               NEXT FIELD oeb04
            END IF
            IF INFIELD(oea03) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_occ"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oea03
               NEXT FIELD oea03
            END IF
            IF INFIELD(oea14) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oea14
               NEXT FIELD oea14
            END IF
#TQC-760021-add-end
 
         ON ACTION locale
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
         CLOSE WINDOW admr131_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
         EXIT PROGRAM
      END IF
 
      IF tm.wc=" 1=1" THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
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
         CLOSE WINDOW admr131_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='admr131'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('admr131','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
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
                        #" '",tm.more CLIPPED,"'"  ,            #No.TQC-610083 mark
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('admr131',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW admr131_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
 
      CALL admr131()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW admr131_w
 
END FUNCTION
 
FUNCTION admr131()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680097 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0100
          l_sql     LIKE type_file.chr1000,       #No.FUN-680097 VARCHAR(3000)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680097 VARCHAR(40)
          l_n1      LIKE type_file.num5,          #No.FUN-680097 SMALLINT
          l_flag    LIKE type_file.chr1,          #TQC-840028-add
          sr        RECORD
                       oea03   LIKE oea_file.oea03,
                       oea032   LIKE oea_file.oea032,
                       oea01    LIKE oea_file.oea01,
                       oea02    LIKE oea_file.oea02,
                       oea14    LIKE oea_file.oea14,
                       oea23    LIKE oea_file.oea23,
                       oeb01    LIKE oeb_file.oeb01,
                       oeb03    LIKE oeb_file.oeb03,
                       oeb04    LIKE oeb_file.oeb04,
                       oeb13    LIKE oeb_file.oeb13,
                       oeb06    LIKE oeb_file.oeb06
       #               pmm04    LIKE pmm_file.pmm04,
       #               pmn041   LIKE pmn_file.pmn041,
       #               pmn02    LIKE pmn_file.pmn02,
       #               pmn04    LIKE pmn_file.pmn04
                    END RECORD
   #--------FUN-750027 TSD.liquor add start------------ 
   DEFINE l_n2      LIKE type_file.num5,     
          l_n       LIKE type_file.num5,     
          l_i       LIKE type_file.num5,     
          l_gen02   LIKE gen_file.gen02,
          l_ima021  LIKE ima_file.ima021,
          l_ogb     ARRAY[100]  OF RECORD   
                       ogb01    LIKE ogb_file.ogb01,
                       ogb03    LIKE ogb_file.ogb03,
                       ogb13    LIKE ogb_file.ogb13
                    END RECORD ,
          l_omb     ARRAY[100]  OF RECORD   
                       omb13    LIKE omb_file.omb13
                    END RECORD 
   #--------FUN-750027 add end--------------------
 
   #str FUN-750027 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 =  g_prog  #FUN-750027 add
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                   #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND oeauser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                   #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND oeagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
   #End:FUN-980030
 
 
   LET l_sql="SELECT oea03,oea032,oea01,oea02,oea14,oea23,oeb01,oeb03,oeb04,oeb13,oeb06 ",
             "  FROM oea_file, OUTER oeb_file ",
            " WHERE oea_file.oea01=oeb_file.oeb01 ",
             "   AND oea02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
             "   AND ",tm.wc CLIPPED
     #       "   AND pmm18 = 'Y' "  #採購單已確認的資料
   PREPARE admr131_prepare1 FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
   END IF
   DECLARE admr131_curs1 CURSOR FOR admr131_prepare1
 
#TQC-840028-add
   LET l_sql="SELECT ogb01,ogb03,ogb13 FROM ogb_file,oga_file ",
             " WHERE ogb31= ? ",
             "   AND ogb32= ? ",
             " AND oga01 = ogb01 ",
             " AND oga09 NOT IN ('1','5','9') ",
             " AND oga65 = 'N' "
   PREPARE r131_prepare2 FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare2:',STATUS,1)
   END IF
   DECLARE r131_ogb CURSOR FOR r131_prepare2
   IF STATUS THEN
      CALL cl_err('r131_ogb:',STATUS,1)
   END IF
 
   LET l_sql="SELECT omb13 FROM omb_file WHERE omb31= ? AND omb32= ? "
   PREPARE r131_prepare3 FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare3:',STATUS,1)
   END IF
   DECLARE r131_omb CURSOR FOR r131_prepare3
   IF STATUS THEN
      CALL cl_err('r131_omb:',STATUS,1)
   END IF
#TQC-840028-add-end
 
   CALL cl_outnam('admr131') RETURNING l_name
   LET g_pageno = 0
 
   FOREACH admr131_curs1 INTO sr.*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      #------FUN-750027 TSD.liquor add 原ON EVERY 段----------
      CALL l_ogb.clear()   
      CALL l_omb.clear()  
      SELECT gen02 INTO l_gen02 FROM gen_file
          WHERE gen01=sr.oea14
      SELECT azi03 INTO t_azi03 from azi_file  #抓幣別單價  
       WHERE azi01=sr.oea23
 
#TQC-840028-add
      SELECT ima021 INTO l_ima021 FROM ima_file
       WHERE ima01=sr.oeb04
      IF SQLCA.sqlcode THEN
         LET l_ima021 = NULL
      END IF
#TQC-840028-add-end
 
#TQC-840028-modify
#     DECLARE admr131_ogb CURSOR FOR           #抓收貨單價
#         SELECT ogb01,ogb03,ogb13
#           FROM ogb_file,oga_file  
#          WHERE ogb31=sr.oeb01
#            AND ogb32=sr.oeb03
#            AND oga01 = ogb01     
#            AND oga09 NOT IN ('1','5','9')
 
      LET l_n1=1
#     FOREACH admr131_ogb INTO l_ogb[l_n1].* 
      FOREACH r131_ogb USING sr.oeb01,sr.oeb03 INTO l_ogb[l_n1].* 
#        LET l_n1=l_n1+1                                    #TQC-860004-mark
#     END FOREACH
#TQC-840028-modify-end
 
#TQC-840028-add
         LET l_flag = 'Y'
         IF (sr.oeb13 != l_ogb[l_n1].ogb13) THEN 
             LET l_flag = 'N'
         END IF 
#TQC-840028-add-end
 
         LET l_n2=1                 
 
#TQC-840028-modify
#        CALL l_ogb.clear()              #TQC-860004-mark
#     DECLARE admr131_omb CURSOR FOR     #抓付款單價
#         SELECT omb13
#           FROM omb_file
#          WHERE omb31=l_ogb[l_n2].ogb01
#            AND omb32=l_ogb[l_n2].ogb03
 
#        FOREACH admr131_omb INTO l_omb[l_n2].*
         FOREACH r131_omb USING l_ogb[l_n1].ogb01,l_ogb[l_n1].ogb03 INTO l_omb[l_n2].* 
#           LET l_n2=l_n2+1                                    #TQC-860004-mark
#        END FOREACH
 
#     IF l_n1<l_n2 THEN                   #抓兩陣列最大數
#        LET l_n=l_n2
#     ELSE
#        LET l_n=l_n1
#     END IF
#
#     FOR l_i=1 TO l_n-1
#TQC-840028-modify-end
 
#TQC-760021-mark
#        IF l_ogb[l_i].ogb13 IS NULL THEN
#           LET l_ogb[l_i].ogb13=0
#        END IF
#
#        IF l_omb[l_i].omb13 IS NULL THEN
#           LET l_omb[l_i].omb13=0
#        END IF
 
#        SELECT ima021 INTO l_ima021 FROM ima_file
#         WHERE ima01=sr.oeb04
#        IF SQLCA.sqlcode THEN
#           LET l_ima021 = NULL
#        END IF
#TQC-760021-mark-end
 
#        IF (sr.oeb13 != l_ogb[l_n].ogb13) OR               #TQC-840028-mark
         IF l_flag = 'N' OR                                 #TQC-840028-modify
            (l_ogb[l_n1].ogb13 !=l_omb[l_n2].omb13)  THEN   #TQC-840028-modify
            ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
            EXECUTE insert_prep USING
                sr.*,l_gen02,l_ogb[l_n1].ogb13,l_omb[l_n2].omb13,
                l_ima021,t_azi03
            #------------------------------ CR (3) ------------------------------#
            #end FUN-750027 add
         END IF
         LET l_flag = 'Y'                                   #TQC-840028-add
#     END FOR                                               #TQC-840028-mark
      #--------FUN-750027 add end------------------------
            LET l_n2=l_n2+1                                 #TQC-860004-add
         END FOREACH                                        #TQC-840028-add
         LET l_n1=l_n1+1                                    #TQC-860004-add
      END FOREACH                                           #TQC-840028-add
   END FOREACH
 
   #str FUN-750027 add
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'oeb04,oea14,oea03') RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   LET g_str = g_str,";",tm.bdate,";",tm.edate 
   CALL cl_prt_cs3('admr131','admr131',l_sql,g_str)
   #------------------------------ CR (4) ------------------------------#
 
END FUNCTION
 
