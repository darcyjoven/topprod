# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: axrr621.4gl
# Descriptions...: 客戶應收帳款明細表
# Date & Author..: 95/03/04 by Nick
# Modify.........: No.FUN-4C0100 04/12/30 By Smapmin 報表轉XML格式
# Modify.........: No.MOD-540023 05/04/20 By Nicola 折讓未印出
# Modify.........: No.MOD-580211 05/09/07 By ice  修改報表列印格式
# Modify.........: No.MOD-5C0069 05/12/14 By Carrier ooz07='N'-->oma56t-oma57
#                                                    ooz07='Y'-->oma61
# Modify.........: No.TQC-610059 06/06/05 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0095 06/10/27 By Xumin l_time轉g_time
# Modify.........: No.TQC-6C0147 06/12/26 By Rayven 報表格式調整
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-B10029 11/01/20 By Summer INPUT選項增加應扣除折讓資料
# Modify.........: No.FUN-B20014 11/02/12 By lilingyu SQL增加ooa37='1'的條件
# Modify.........: No.FUN-C40001 12/04/12 By yinhy 增加開窗功能
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm     RECORD                         # Print condition RECORD
                 wc      LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(1000)            # Where condition
                 detail  LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(1)
                 e       LIKE type_file.chr1,          #CHI-B10029 add
                 edate   LIKE type_file.dat,           #No.FUN-680123 DATE
                 more    LIKE type_file.chr1           #No.FUN-680123 VARCHAR(1)              # Input more condition(Y/N)
              END RECORD,
       tot1   ARRAY[100] OF LIKE type_file.num20_6,    #No.FUN-680123 DEC(20,6)
       tot2   ARRAY[100] OF LIKE type_file.num20_6     #No.FUN-680123 DEC(20,6) 
DEFINE g_i    LIKE type_file.num5                      #count/index for any purpose        #No.FUN-680123 SMALLINT
DEFINE i      LIKE type_file.num5                      #No.FUN-680123 SMALLINT
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690127
 
   #-----TQC-610059---------
   LET g_pdate=ARG_VAL(1)
   LET g_towhom=ARG_VAL(2)
   LET g_rlang=ARG_VAL(3)
   LET g_bgjob=ARG_VAL(4)
   LET g_prtway=ARG_VAL(5)
   LET g_copies=ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.edate = ARG_VAL(8)
   LET tm.detail = ARG_VAL(9) 
   LET tm.e = ARG_VAL(10) #CHI-B10029 add
   #-----END TQC-610059-----
   #CHI-B10029 mod +1 --start--
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   #No.FUN-570264 ---end---
   #CHI-B10029 mod +1 --end--
 
   #no.5196   #No.FUN-680123
   DROP TABLE curr_tmp
   CREATE TEMP TABLE curr_tmp
      (curr  LIKE azi_file.azi01,
       amt1  LIKE type_file.num20_6,
       amt2  LIKE type_file.num20_6,
       ym    LIKE type_file.chr5,  
       oma03 LIKE oma_file.oma03,
       occ03 LIKE occ_file.occ03)
   #no.5196(end)  #No.FUN-680123 end
 
   IF cl_null(tm.wc) THEN
      CALL axrr621_tm(0,0)             # Input print condition
   ELSE
      CALL axrr621()                   # Read data and create out-file
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION axrr621_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680123 SMALLINT
          l_cmd          LIKE type_file.chr1000        #No.FUN-680123 VARCHAR(1000)
 
   LET p_row = 6 LET p_col =18
 
   OPEN WINDOW axrr621_w AT p_row,p_col
     WITH FORM "axr/42f/axrr621"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.detail='Y'
   LET tm.e='Y'  #CHI-B10029 add
   LET tm.edate=g_today
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON oma15,oma14,occ03,oma03
 
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
      #No.FUN-C40001  --Begin
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(oma15)
                 CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem1"   #No.MOD-530272
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oma15
                 NEXT FIELD oma15
            WHEN INFIELD(oma14)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oma14
                 NEXT FIELD oma14
            WHEN INFIELD(occ03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_oca"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO occ03
                 NEXT FIELD occ03
            WHEN INFIELD(oma03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_occ"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oma03
                 NEXT FIELD oma03
                 DISPLAY g_qryparam.multiret TO oma03
                 NEXT FIELD oma03
            END CASE
      #No.FUN-C40001  --End
 
      END CONSTRUCT
 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW axrr621_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
         EXIT PROGRAM
      END IF
 
      INPUT BY NAME tm.edate,tm.detail,tm.e,tm.more WITHOUT DEFAULTS #CHI-B10029 add tm.e
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---

         #CHI-B10029 add --start--
         AFTER FIELD e
            IF cl_null(tm.e) OR tm.e NOT MATCHES '[YN]' THEN
               NEXT FIELD e
            END IF
         #CHI-B10029 add --end--
 
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
         CLOSE WINDOW axrr621_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='axrr621'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('axrr621','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_lang CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'" ,
                        " '",tm.edate CLIPPED,"'" ,
                        " '",tm.detail CLIPPED,"'"  ,   #TQC-610059
                        " '",tm.e CLIPPED,"'" ,         #CHI-B10029 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('axrr621',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW axrr621_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL axrr621()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW axrr621_w
 
END FUNCTION
 
FUNCTION axrr621()
   DEFINE l_name      LIKE type_file.chr20,         #No.FUN-680123 VARCHAR(20)       # External(Disk) file name
#       l_time          LIKE type_file.chr8          #No.FUN-6A0095
          l_sql       LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(1000)
          amt1,amt2   LIKE type_file.num20_6,       #No.FUN-680123 DEC(20,6)
          l_omavoid   LIKE oma_file.omavoid,
          l_omaconf   LIKE oma_file.omaconf,
          l_oob03     LIKE oob_file.oob03,          #No.MOD-540023 
          l_bucket    LIKE type_file.num5,          #No.FUN-680123 SMALLINT
          l_order     ARRAY[5] OF  LIKE ooo_file.ooo01,          #No.FUN-680123 VARCHAR(10)
          sr          RECORD
                         occ03     LIKE occ_file.occ03,          #No.FUN-680123 VARCHAR(4)
                         oma00     LIKE oma_file.oma00,          #No.MOD-540023 
                         oma01     LIKE oma_file.oma01,
                         oma02     LIKE oma_file.oma02,
                         oma10     LIKE oma_file.oma10,          #
                         oma03     LIKE oma_file.oma03,          #客戶
                         oma032    LIKE oma_file.oma032,         #簡稱
                         oma23     LIKE oma_file.oma23,          #
                         ym        LIKE type_file.chr5,          #No.FUN-680123 VARCHAR(5)
                         amt1      LIKE type_file.num20_6,       #No.FUN-680123 DEC(20,6)
                         amt2      LIKE type_file.num20_6,       #No.FUN-680123 DEC(20,6)          #No.A057
                         age       LIKE type_file.num5           #No.FUN-680123 SMALLINT
                      END RECORD
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #====>資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND omauser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND omagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND omagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('omauser', 'omagrup')
   #End:FUN-980030
 
 
   #no.5196
   DELETE FROM curr_tmp;
   #no.5196
 
    #-----No.MOD-540023-----
   LET l_sql = "SELECT SUM(oob09),SUM(oob10)  ",
               "  FROM ooa_file,oob_file",
               " WHERE ooa01 = oob01 ",
               "   AND ooa02 > '",tm.edate,"' ",
               "   AND ooaconf = 'Y' ",
               "   AND ooa37 = '1'",            #FUN-B20014
               "   AND oob06 IS NOT NULL ",
               "   AND oob06 = ? ",
               "   AND oob03 = ? "
   PREPARE r621_poob FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare apg:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   DECLARE r621_coob CURSOR FOR r621_poob
    #-----No.MOD-540023 END-----
 
 
    #No.MOD-5C0057  --Begin
    IF g_ooz.ooz07 = 'N' THEN
       LET l_sql="SELECT occ03,oma00,oma01,oma02,oma10,oma03,oma032,oma23,",   #No.MOD-540023
                "       '',oma54t-oma55,oma56t-oma57,0",
                " FROM oma_file, occ_file",
                " WHERE oma03=occ01 AND ",tm.wc CLIPPED,
                "   AND omaconf='Y' AND omavoid='N'",       #No.MOD-540023
                "   AND oma02 <= '",tm.edate,"'",
                "   AND (oma54t>oma55 OR",
                "   oma01 IN (SELECT oob06 FROM ooa_file,oob_file",
                "   WHERE ooa01=oob01 AND ooaconf !='X' ",  #010804 增
                "   AND ooa37 = '1'",            #FUN-B20014                
                "   AND ooa02 > '",tm.edate,"' ))"
    ELSE
       LET l_sql="SELECT occ03,oma00,oma01,oma02,oma10,oma03,oma032,oma23,",   #No.MOD-540023
                "       '',oma54t-oma55,oma61,0",                     #No.A057
                " FROM oma_file, occ_file",
                " WHERE oma03=occ01 AND ",tm.wc CLIPPED,
                "   AND omaconf='Y' AND omavoid='N'",       #No.MOD-540023
                "   AND oma02 <= '",tm.edate,"'",
                "   AND (oma54t>oma55 OR",
                "   oma01 IN (SELECT oob06 FROM ooa_file,oob_file",
                "   WHERE ooa01=oob01 AND ooaconf !='X' ",  #010804 增
                "   AND ooa37 = '1'",            #FUN-B20014                
                "   AND ooa02 > '",tm.edate,"' ))"
    END IF
    #No.MOD-5C0057  --End
    #CHI-B10029 add --start--
    #讀取折讓金額
    IF tm.e = 'Y' THEN
       LET l_sql = l_sql CLIPPED,
                   " AND (oma00 like '1%' OR oma00 like '2%')"
    ELSE
       LET l_sql = l_sql CLIPPED,
                   " AND oma00 like '1%' "
    END IF
    #CHI-B10029 add --end--
 
   PREPARE axrr621_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
 
   DECLARE axrr621_curs1 CURSOR FOR axrr621_prepare1
 
   CALL cl_outnam('axrr621') RETURNING l_name
   START REPORT axrr621_rep TO l_name
 
   FOR i = 1 TO 100
      LET tot1[i] = 0
   END FOR
 
   LET g_pageno = 0
 
   FOREACH axrr621_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
       #-----No.MOD-540023-----
      IF sr.oma00[1,1]='1' THEN
         LET l_oob03 = '2'
      ELSE
         LET l_oob03 = '1'
      END IF
 
      LET amt1 = 0
      LET amt2 = 0
 
      OPEN r621_coob USING sr.oma01,l_oob03
 
      FETCH r621_coob INTO amt1,amt2
      IF SQLCA.SQLCODE <> 0 THEN
         LET amt1 =0
         LET amt2 =0
      END IF
 
      CLOSE r621_coob
 
      IF amt1 IS NULL THEN
         LET amt1 = 0
      END IF
 
      IF amt2 IS NULL THEN
         LET amt2 = 0
      END IF
 
     #LET amt1 = 0
     #LET amt2 = 0
 
     #SELECT SUM(oob09),SUM(oob10) INTO amt1,amt2
     #  FROM oob_file,ooa_file
     # WHERE oob06 = sr.oma01
     #   AND oob03 = '2'
     #   AND oob04 = '1'
     #   AND ooaconf = 'Y'
     #   AND ooa01 = oob01
     #   AND ooa02 > tm.edate
 
     #IF amt1 IS NULL THEN
     #   LET amt1 = 0
     #END IF
 
     #IF amt2 IS NULL THEN
     #   LET amt2 = 0
     #END IF
       #-----No.MOD-540023 END-----
 
      LET sr.ym = (YEAR(sr.oma02)-1900) USING '&&&',MONTH(sr.oma02) USING '&&'
      LET sr.amt1 = sr.amt1+amt1
      LET sr.amt2 = sr.amt2+amt2
 
       #-----No.MOD-540023-----
      IF sr.oma00[1,1] = '2' THEN
         LET sr.amt1 = sr.amt1 * -1
         LET sr.amt2 = sr.amt2 * -1
      END IF
       #-----No.MOD-540023 END-----
 
      LET sr.age = YEAR(tm.edate)*12+MONTH(tm.edate) - YEAR(sr.oma02)*12+MONTH(sr.oma02)
 
      #no.5196
      INSERT INTO curr_tmp VALUES(sr.oma23,sr.amt1,sr.amt2,sr.ym,sr.oma03,sr.occ03)
      #no.5196(end)
 
      OUTPUT TO REPORT axrr621_rep(sr.*)
   END FOREACH
 
   FINISH REPORT axrr621_rep
 
   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 
END FUNCTION
 
REPORT axrr621_rep(sr)
   DEFINE l_last_sw       LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(1)
          l_curr          LIKE type_file.chr4,          #No.FUN-680123 VARCHAR(4)
          l_amt1,l_amt2   LIKE type_file.num20_6,       #No.FUN-680123 DECIMAL(20,6)
          g_head1         STRING,
          sr              RECORD
                             occ03     LIKE occ_file.occ03,      #No.FUN-680123 VARCHAR(4)
                             oma00     LIKE oma_file.oma00,      #No.MOD-540023
                             oma01     LIKE oma_file.oma01,
                             oma02     LIKE oma_file.oma02,      #
                             oma10     LIKE oma_file.oma10,      #
                             oma03     LIKE oma_file.oma03,      #客戶
                             oma032    LIKE oma_file.oma032,     #簡稱
                             oma23     LIKE oma_file.oma23,
                             ym        LIKE type_file.chr4,          #No.FUN-680123 VARCHAR(5)
                             amt1      LIKE type_file.num20_6,       #No.FUN-680123 DEC(20,6)
                             amt2      LIKE type_file.num20_6,       #No.FUN-680123 DEC(20,6)           #No.A057
                             age       LIKE type_file.num5           #No.FUN-680123 SMALLINT
                          END RECORD
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.occ03,sr.oma03,sr.ym,sr.oma23,sr.oma02
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]  #No.TQC-6C0147 mark
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED, pageno_total
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]  #No.TQC-6C0147
         LET g_head1 = g_x[12] CLIPPED,tm.edate
         PRINT g_head1
         PRINT g_dash[1,g_len]
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
         PRINT g_dash1
         FOR i = 1 TO 100 LET tot2[i] = 0 END FOR
         LET l_last_sw = 'N'   #No.TQC-6C0147
 
      BEFORE GROUP OF sr.occ03
         PRINT COLUMN g_c[31],sr.occ03;
 
      BEFORE GROUP OF sr.oma03
         PRINT COLUMN g_c[32],sr.oma03,
               COLUMN g_c[33],sr.oma032;
 
      ON EVERY ROW
         SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05  #抓原幣取位
           FROM azi_file
          WHERE azi01=sr.oma23
 
         IF tm.detail='Y' THEN
            PRINT COLUMN g_c[34],sr.oma01,
                  COLUMN g_c[35],sr.oma10,
                  COLUMN g_c[36],sr.oma23,
                  COLUMN g_c[37],cl_numfor(sr.amt1,37,t_azi04),
                  COLUMN g_c[38],cl_numfor(sr.amt2,38,g_azi04)
         END IF
 
      AFTER GROUP OF sr.ym
         #no.5196
         DECLARE curr_temp4 CURSOR FOR SELECT curr,SUM(amt1),SUM(amt2)
                                         FROM curr_tmp
                                        WHERE oma03=sr.oma03
                                          AND occ03=sr.occ03
                                          AND ym=sr.ym
                                        GROUP BY curr
         PRINT
         FOREACH curr_temp4 INTO l_curr,l_amt1,l_amt2
            SELECT azi05 INTO t_azi05
              FROM azi_file
              WHERE azi01=l_curr
            PRINT COLUMN g_c[35],g_x[13] CLIPPED,
                  COLUMN g_c[36],sr.ym[2,5],
                  COLUMN g_c[37],cl_numfor(GROUP SUM(sr.amt1),37,t_azi05),
                  COLUMN g_c[38],cl_numfor(GROUP SUM(sr.amt2),38,g_azi05)
         END FOREACH
         #No.MOD-580211 -start--
         #PRINT COLUMN g_c[37],'------------------ ------------------'
         PRINT   COLUMN g_c[37],g_dash2[1,g_w[37]],
                 COLUMN g_c[38],g_dash2[1,g_w[38]]
         #No.MOD-580211 -end--
         #no.5196(end)
 
      AFTER GROUP OF sr.oma03
         #no.5196
         DECLARE curr_temp2 CURSOR FOR SELECT curr,SUM(amt1),SUM(amt2)
                                         FROM curr_tmp
                                        WHERE oma03 = sr.oma03
                                          AND occ03 = sr.occ03
                                        GROUP BY curr
         PRINT
 
         FOREACH curr_temp2 INTO l_curr,l_amt1,l_amt2
            SELECT azi05 INTO t_azi05
              FROM azi_file
              WHERE azi01=l_curr
            PRINT COLUMN g_c[35],g_x[14] CLIPPED,
                  COLUMN g_c[36],l_curr CLIPPED,
                  COLUMN g_c[37],cl_numfor(l_amt1,37,t_azi05),
                  COLUMN g_c[38],cl_numfor(l_amt2,38,g_azi05)
         END FOREACH
         PRINT COLUMN g_c[37],'------------------ ------------------'
         #no.5196(end)
 
      AFTER GROUP OF sr.occ03
         #no.5196
         DECLARE curr_temp3 CURSOR FOR SELECT curr,SUM(amt1),SUM(amt2)
                                         FROM curr_tmp
                                        WHERE occ03 = sr.occ03
                                        GROUP BY curr
         PRINT
 
         FOREACH curr_temp3 INTO l_curr,l_amt1,l_amt2
            SELECT azi05 INTO t_azi05
              FROM azi_file
              WHERE azi01 = l_curr
            PRINT COLUMN g_c[35],g_x[15] CLIPPED,
                  COLUMN g_c[36],l_curr CLIPPED,
                  COLUMN g_c[37],cl_numfor(l_amt1,37,t_azi05),
                  COLUMN g_c[38],cl_numfor(l_amt2,38,g_azi05)
         END FOREACH
         PRINT COLUMN g_c[37],'------------------ ------------------'
         #no.5196(end)
 
      ON LAST ROW
         #no.5196
         DECLARE curr_temp1 CURSOR FOR SELECT curr,SUM(amt1),SUM(amt2)
                                         FROM curr_tmp
                                        GROUP BY curr
         PRINT
         FOREACH curr_temp1 INTO l_curr,l_amt1,l_amt2
            SELECT azi05 INTO t_azi05
              FROM azi_file
             WHERE azi01=l_curr
 
            PRINT COLUMN g_c[35],g_x[16] CLIPPED,
                  COLUMN g_c[36],l_curr CLIPPED,
                  COLUMN g_c[37],cl_numfor(l_amt1,37,t_azi05),
                  COLUMN g_c[38],cl_numfor(l_amt2,38,g_azi05)
         END FOREACH
         #no.5196(end)
         LET l_last_sw = 'Y' #No.TQC-6C0147
 
      PAGE TRAILER
#        PRINT g_x[4]  #No.TQC-6C0147 mark
         PRINT g_dash[1,g_len]
         #No.TQC-6C0147 --start--                                                                                                   
         IF l_last_sw = 'Y' THEN                                                                                                    
         PRINT g_x[4],                                                                                                              
               COLUMN (g_len-9), g_x[10] CLIPPED                                                                                    
         ELSE                                                                                                                       
         PRINT g_x[4],                                                                                                              
               COLUMN (g_len-9), g_x[9] CLIPPED                                                                                     
         END IF                                                                                                                     
         PRINT                                                                                                                      
         #No.TQC-6C0147 --end--
         PRINT COLUMN g_c[31],g_x[5],
               COLUMN g_c[33],g_x[6],
               COLUMN g_c[35],g_x[7],
               COLUMN g_c[37],g_x[8]
END REPORT
