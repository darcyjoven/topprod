# Prog. Version..: '5.30.06-13.03.19(00010)'     #
#
# Pattern name...: axmr660.4gl
# Descriptions...: 出貨未轉應收明細表
# Input parameter:
# Return code....:
# Date & Author..: 06/08/02 By rainy
# 本程式與axmr630非常相似
# Modify.........: No.FUN-680137 06/09/14 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-750095 07/06/26 By johnray 修改報表功能，使用CR打印報表
# Modify.........: No.CHI-880035 08/08/26 By Smapmin 改由出貨單單號/項次是否存在omb_file來判斷是否轉應收
# Modify.........: No.MOD-8C0155 09/02/10 By liuxqa 應扣除不換貨銷退的數量
# Modify.........: No.MOD-930092 09/03/09 By rainy 列印應排除axmi010設定非產生應收之單別資料
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A80003 10/08/25 By Summer 調整"報表單價*數量取位後的結果相加總"與"總金額欄位"數值不同
# Modify.........: No:MOD-B20018 11/02/10 By Summer 畫面多一選項選擇是否要排除單價為0的單據
# Modify.........: No:TQC-B50065 11/05/16 By lixia “部門編號”開窗第一頁資料全選報錯
# Modify.........: No.FUN-B80089 11/08/09 By minpp程序撰寫規範修改
# Modify.........: No:MOD-C40056 12/04/06 By Vampire CHI-880035已將程式改為直接檢查應收帳款檔(oma_file,omb_file)，故此條件(oga53>oga54)應一併mark 
# Modify.........: No.TQC-C40098 12/04/16 By zhuhao 出貨單的銷退方式為3.不折讓不換貨的出貨單，不應再在axmr660裡列印出
# Modify.........: No.FUN-C50129 12/06/06 By suncx 增加顯示銷退數據
# Modify.........: No.TQC-C70045 12/07/06 By zhuhao TQC-C40098 BUG 修改
# Modify.........: No.MOD-C60216 12/07/23 By SunLM 報表增加含稅金額
# Modify.........: No.TQC-C80012 12/08/01 By suncx 還原FUN-C50129的修改
# Modify.........: No.MOD-D10030 13/01/06 By SunLM mark掉TQC-C70045,因为即使全部销退,原出货单还是要立账
# Modify.........: No.MOD-D20088 13/03/12 By Elise 排除 ogb917 = 0 的出貨單

DATABASE ds
 
GLOBALS "../../config/top.global"
 
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
END GLOBALS
 
  DEFINE tm  RECORD                  # Print condition RECORD
              wc      STRING,         # Where condition
              a       LIKE type_file.chr1,    #MOD-B20018 add
             #b       LIKE type_file.chr1,    #FUN-C50129 add   #TQC-C80012 mark
              s       LIKE type_file.chr3,    #No.FUN-680137 VARCHAR(3)   # Order by sequence
              t       LIKE type_file.chr3,    #No.FUN-680137 VARCHAR(3)   # Eject sw
              u       LIKE type_file.chr3,    #No.FUN-680137  VARCHAR(3)  # Group total sw
              more    LIKE type_file.chr1     #No.FUN-680137 VARCHAR(1)   # Input more condition(Y/N)
              END RECORD
DEFINE    g_i           LIKE type_file.num5     #count/index for any purpose  #No.FUN-680137 SMALLINT
DEFINE g_sma115         LIKE sma_file.sma115
DEFINE g_sma116         LIKE sma_file.sma116
DEFINE l_sql            LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1000)
DEFINE l_zaa02          LIKE zaa_file.zaa02
DEFINE i                LIKE type_file.num10   #No.FUN-680137 INTEGER
#No.FUN-750095 -- begin --
DEFINE g_sql      STRING
DEFINE l_table    STRING
DEFINE g_str      STRING
#No.FUN-750095 -- end --
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway =ARG_VAL(5)
   LET g_copies =ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8) #MOD-B20018 add
  #LET tm.b  = ARG_VAL(9) #FUN-C50129 add #TQC-C80012 mark
  #MOD-B20018 mod +1 --start--
   LET tm.s  = ARG_VAL(10)
   LET tm.t  = ARG_VAL(11)
   LET tm.u  = ARG_VAL(12)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
  #MOD-B20018 mod +1 --end--

#No.FUN-750095 --begin
   LET g_sql = "oga01.oga_file.oga01,",
               "oga02.oga_file.oga02,",
               "oga03.oga_file.oga03,",
               "oga032.oga_file.oga032,",
               "oga04.oga_file.oga04,",
               "occ02.occ_file.occ02,",
               "oga14.oga_file.oga14,",
               "l_gen02.gen_file.gen02,",
               "oga15.oga_file.oga15,",
               "l_gem02.gem_file.gem02,",
               "ogb03.ogb_file.ogb03,",
               "ogb31.ogb_file.ogb31,",
               "ogb04.ogb_file.ogb04,",
               "ogb06.ogb_file.ogb06,",
               "l_ima021.ima_file.ima021,",
               "l_str2.type_file.chr1000,",
               "ogb916.ogb_file.ogb916,",
               "ogb917.ogb_file.ogb917,",
               "ogb05.ogb_file.ogb05,",
               "ogb13.ogb_file.ogb13,",
               "ogb14.ogb_file.ogb14,",
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,",
               "ogb14t.ogb_file.ogb14t" #MOD-C60216
   LET l_table = cl_prt_temptable('axmr660',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?)"  ##MOD-C60216?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#No.FUN-750095 --end
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-B80089    ADD
   IF cl_null(g_bgjob) OR g_bgjob = 'N'       # If background job sw is off
      THEN CALL axmr660_tm(0,0)               # Input print condition
      ELSE CALL axmr660()                     # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
END MAIN
 
FUNCTION axmr660_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-680137 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 5 LET p_col = 17
 
   OPEN WINDOW axmr660_w AT p_row,p_col WITH FORM "axm/42f/axmr660"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.a = 'N' #MOD-B20018 add
  #LET tm.b = 'N' #FUN-C50129 add  #TQC-C80012 mark
   LET tm2.s1  = '1'
   LET tm2.s2  = '2'
   LET tm2.s3  = '3'
   LET tm2.u1  = 'N'
   LET tm2.u2  = 'N'
   LET tm2.u3  = 'N'
   LET tm2.t1  = 'N'
   LET tm2.t2  = 'N'
   LET tm2.t3  = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   #CONSTRUCT BY NAME tm.wc ON oga01,oga02,oga03,oga04,oga14,oga15
   CONSTRUCT BY NAME tm.wc ON oga01,oga02,oga03,oga04,oga14,oga15   #,oha01   #FUN-C50129 oha01  #TQC-C80012 mark oha01
 
     BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
     ON ACTION CONTROLP
           IF INFIELD(oga03) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_occ"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oga03
              NEXT FIELD oga03
           END IF
           IF INFIELD(oga04) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_occ"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oga04
              NEXT FIELD oga04
           END IF
           IF INFIELD(oga14) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oga14
              NEXT FIELD oga14
           END IF
           IF INFIELD(oga15) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gem"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oga15
              NEXT FIELD oga15
           END IF
           #TQC-C80012 mark begin----------------
           ##FUN-C50129 add str--------------
           #IF INFIELD(oha01) THEN
           #   CALL cl_init_qry_var()
           #   LET g_qryparam.form = "q_oha01"
           #   LET g_qryparam.state = "c"
           #   CALL cl_create_qry() RETURNING g_qryparam.multiret
           #   DISPLAY g_qryparam.multiret TO oha01
           #   NEXT FIELD oha01
           #END IF
           ##FUN-C50129 add end-----------------
           ##TQC-C80012 mark end-------------------------
 
     ON ACTION locale
         LET g_action_choice = "locale"
         CALL cl_show_fld_cont()
         EXIT CONSTRUCT
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
     ON ACTION about
        CALL cl_about()
 
     ON ACTION help
        CALL cl_show_help()
 
     ON ACTION controlg
        CALL cl_cmdask()
 
     ON ACTION exit
        LET INT_FLAG = 1
        EXIT CONSTRUCT
 
     ON ACTION qbe_select
        CALL cl_qbe_select()
 
  END CONSTRUCT
 
  IF g_action_choice = "locale" THEN
     LET g_action_choice = ""
     CALL cl_dynamic_locale()
     CONTINUE WHILE
  END IF
 
 
  IF INT_FLAG THEN
     LET INT_FLAG = 0
     CLOSE WINDOW axmr660_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
     EXIT PROGRAM
  END IF
  IF tm.wc = ' 1=1' THEN
     CALL cl_err('','9046',0)
     CONTINUE WHILE
  END IF
 
  DISPLAY BY NAME tm.more         # Condition
 
  #INPUT BY NAME tm.a,tm2.s1,tm2.s2,tm2.s3, #MOD-B20018 add tm.a
  #INPUT BY NAME tm.a,tm.b,tm2.s1,tm2.s2,tm2.s3,   #FUN-C50129 add tm.b  #TQC-C80012 mark
  INPUT BY NAME tm.a,tm2.s1,tm2.s2,tm2.s3,      #TQC-C80012 add
                tm2.t1,tm2.t2,tm2.t3,
                tm2.u1,tm2.u2,tm2.u3,
                tm.more WITHOUT DEFAULTS
      BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF

      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      #UI
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axmr660_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axmr660'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmr660','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")  #"
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.a CLIPPED,"'", #MOD-B20018 add
                        #" '",tm.b CLIPPED,"'", #FUN-C50129 add  #TQC-C80012 mark
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",
                         " '",g_rep_clas CLIPPED,"'",
                         " '",g_template CLIPPED,"'"
         CALL cl_cmdat('axmr660',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axmr660_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axmr660()
   ERROR ""
END WHILE
   CLOSE WINDOW axmr660_w
END FUNCTION

FUNCTION axmr660()
   DEFINE l_name    LIKE type_file.chr20        # External(Disk) file name  #No.FUN-680137 VARCHAR(20)
#         l_time    LIKE type_file.chr8         #No.FUN-6A0094
   #DEFINE l_sql     LIKE type_file.chr1000      # RDSQL STATEMENT  #No.FUN-680137 VARCHAR(1000)
   DEFINE l_sql     STRING                      #TQC-B50065
   DEFINE l_chr     LIKE type_file.chr1         #No.FUN-680137 VARCHAR(1)
   DEFINE l_order   ARRAY[5] OF LIKE oga_file.oga01 #No.FUN-680137 VARCHAR(16)
   DEFINE sr        RECORD order1  LIKE oga_file.oga01, #No.FUN-680137 VARCHAR(16)
                           order2  LIKE oga_file.oga01, #No.FUN-680137 VARCHAR(16)
                           order3  LIKE oga_file.oga01, #No.FUN-680137 VARCHAR(16)
                           oga01   LIKE oga_file.oga01,
                           oga02   LIKE oga_file.oga02,
                           oga03   LIKE oga_file.oga03,
                           oga032  LIKE oga_file.oga032,
                           oga04   LIKE oga_file.oga04,
                           occ02   LIKE occ_file.occ02,
                           oga14   LIKE oga_file.oga14,
                           oga15   LIKE oga_file.oga15,
                           oga24   LIKE oga_file.oga24,
                           ogb03   LIKE ogb_file.ogb03,   #單身項次
                           ogb31   LIKE ogb_file.ogb31,
                           ogb04   LIKE ogb_file.ogb04,
                           ogb06   LIKE ogb_file.ogb06,
                           ogb05   LIKE ogb_file.ogb05,
                           ogb13   LIKE ogb_file.ogb13,
                           balance LIKE ogb_file.ogb12,
                           ogb14   LIKE ogb_file.ogb14,
                           ogb910  LIKE ogb_file.ogb910,
                           ogb912  LIKE ogb_file.ogb912,
                           ogb913  LIKE ogb_file.ogb913,
                           ogb915  LIKE ogb_file.ogb915,
                           ogb916  LIKE ogb_file.ogb916,
                           ogb917  LIKE ogb_file.ogb917,
                           azi03   LIKE azi_file.azi03,
                           azi04   LIKE azi_file.azi04,
                           azi05   LIKE azi_file.azi05,
                           ogb14t  LIKE ogb_file.ogb14t  #MOD-C60216
                    END RECORD
#No.FUN-750095 -- begin --
   DEFINE l_amt     LIKE ogb_file.ogb14
   DEFINE l_ima021  LIKE ima_file.ima021
   DEFINE l_gen02   LIKE gen_file.gen02
   DEFINE l_gem02   LIKE gem_file.gem02
   DEFINE l_ogb915  STRING
   DEFINE l_ogb912  STRING
   DEFINE l_ogb12   STRING
   DEFINE l_str2    LIKE type_file.chr1000
   DEFINE l_ima906  LIKE ima_file.ima906
#No.FUN-750095 -- end --
   DEFINE l_cnt     LIKE type_file.num5   #CHI-880035 
  #DEFINE l_oha09   LIKE oha_file.oha09   #FUN-C50129  #TQC-C80012 mark
   
   CALL cl_del_data(l_table)     #No.FUN-750095
  # CALL  cl_used(g_prog,g_time,1) RETURNING g_time   #No.FUN-6A0094    #FUN-B80089  MARK
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND ogauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND ogagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN
   #      LET tm.wc = tm.wc clipped," AND ogagrup IN ",cl_chk_tgrup_list()
   #   END IF
   
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup')
   #End:FUN-980030
   
 
   LET l_sql = "SELECT DISTINCT '','','',",
               "       oga01,oga02,oga03,oga032,oga04,occ02,oga14, ",
               "       oga15,oga24,ogb03,ogb31,ogb04,ogb06,ogb05, ",
#               "       ogb13,ogb12-ogb60,0,ogb910,ogb912,ogb913,ogb915,ogb916,ogb917, ",  #No.MOD-8C0155 mark by liuxqa
               "       ogb13,ogb12-ogb60-ogb64,0,ogb910,ogb912,ogb913,ogb915,ogb916,ogb917, ",  #No.MOD-8C0155 mod by liuxqa  #FUN-C50129 mark  #TQC-C80012 remark
              #"       ogb13,(ogb12-ogb60)*ogb13,0,ogb910,ogb912,ogb913,ogb915,ogb916,ogb917, ", #FUN-C50129 add  #TQC-C80012 mark
               #"       azi03,azi04,azi05,''",#MOD-C60216
               "       azi03,azi04,azi05,CASE oga213 WHEN 'N' THEN (ogb12-ogb60)*ogb13*(100+oga211)/100 ELSE (ogb12-ogb60)*ogb13 END", #MOD-C60216
               #"  FROM oga_file,OUTER occ_file,ogb_file,azi_file ",         #MOD-930092       
               #"  FROM oga_file,OUTER occ_file,ogb_file,azi_file,oay_file ", #MOD-930092   #FUN-C50129 mark
               "  FROM oga_file LEFT OUTER JOIN occ_file ON oga04 = occ01,", #FUN-C50129 add
               #"                LEFT JOIN ohb_file ON oga01 = ohb31 ", #FUN-C50129 add  #TQC-C80012 mark
               #"                LEFT JOIN oha_file ON oha01 = ohb01,", #FUN-C50129 add  #TQC-C80012 mark
               "       ogb_file,azi_file,oay_file ", #MOD-930092       #FUN-C50129 add
               "  WHERE oga01 = ogb01 AND oga09 !='1' AND oga09!='5' ",
               "    AND oga01 like trim(oayslip)||'-%' AND oay11='Y' ",   #MOD-930092 add
               "    AND oga09 !='7' AND oga09!='9' ",
               #"    AND (oga10 = ' ' OR oga10 IS NULL) ", #帳單編號為Null或空白   #CHI-880035
               "    AND oga65='N' ",
               #"    AND oga_file.oga04 = occ_file.occ01 ",   #FUN-C50129 mark
               #"    AND oga53 > oga54 ", #MOD-C40056 mark
               "    AND oga23 = azi01 ",
               "    AND ogb60 =0      ",
               "    AND ogb917 > 0    ",   #MOD-D20088 add
               "    AND (oga00 ='1'    ",  # 換貨出貨不應列出
               "    OR oga00 ='4')   ",
               "    AND ogapost='Y'   ",
              #"    AND (oga01 NOT IN (SELECT ohb31 FROM oha_file,ohb_file WHERE oha01 = ohb01 AND ohb31 IS NOT NULL AND oha09='3' AND ohaconf='Y'))  ", #TQC-C40098 add  #TQC-C70045 mark
              # "    AND ogb64 < ogb12  ",        #TQC-C70045 add #MOD-D10030 mark
               "    AND ",tm.wc

   #MOD-B20018 add --start--
   IF tm.a = 'N' THEN
      LET l_sql = l_sql CLIPPED," AND NOT (ogb13 IS NULL OR ogb13=0)"
   END IF
   #MOD-B20018 add --end--

   #TQC-C80012 mark begin-----------------
   ##FUN-C50129 add --str------
   #IF tm.b = 'Y' THEN 
   #   LET tm.wc=cl_replace_str(tm.wc, "oga02", "oha02")
   #   LET tm.wc=cl_replace_str(tm.wc, "oga03", "oha03")
   #   LET tm.wc=cl_replace_str(tm.wc, "oga04", "oha04")
   #   LET tm.wc=cl_replace_str(tm.wc, "oga14", "oha14")
   #   LET tm.wc=cl_replace_str(tm.wc, "oga15", "oha15")
   #   LET l_sql = l_sql,
   #               " UNION ALL ",
   #               "SELECT DISTINCT '','','',",
   #               "       oha01,oha02,oha03,oha032,oha04,occ02,oha14,",
   #               "       oha15,oha24,ohb03,ohb33,ohb04,ohb06,ohb05,",
   #               "       ohb13,CASE oha09 WHEN '5' THEN -1*ohb14t ELSE -1*(ohb12-ohb60)*ohb13 END,0,",
   #               "       ohb910,ohb912,ohb913,ohb915,ohb916,ohb917,",
   #               #"       azi03,azi04,azi05,oha09", #MOD-C60216
   #                "       azi03,azi04,azi05,CASE oha09 WHEN '5' THEN -1*ohb14t ELSE ",
   #               "   CASE oha213 WHEN 'N' THEN -1*(ohb12-ohb60)*ohb13*(100+oga211)/100 ELSE -1*(ohb12-ohb60)*ohb13 END END", #MOD-C60216 add
   #               "  FROM oha_file LEFT JOIN occ_file ON occ01=oha04,",
   #               "       ohb_file LEFT JOIN oga_file ON oga01=ohb31,azi_file,oay_file ",
   #               " WHERE oha01 = ohb01 AND oha09 NOT IN ('2','3','6')",
   #               "   AND oha01 like trim(oayslip)||'-%' AND oay11='Y' ",
   #               "   AND (oha10 = ' ' OR oha10 IS NULL)",
   #               "   AND oha23 = azi01",
   #               "   AND ohb60 =0",
   #               "   AND ohapost='Y'",
   #               "   AND ",tm.wc
   #   IF tm.a = 'N' THEN
   #      LET l_sql = l_sql CLIPPED," AND NOT (ohb13 IS NULL OR ohb13=0)"
   #   END IF
   #END IF 
   ##FUN-C50129 add --end------
   #TQC-C80012 mark end -----------------------

   PREPARE axmr660_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF
   DECLARE axmr660_curs1 CURSOR FOR axmr660_prepare1
 
#No.FUN-750095 -- begin --
#   CALL cl_outnam('axmr660') RETURNING l_name
#
#   SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file
#   IF g_sma.sma116 MATCHES '[23]' THEN
#      LET g_zaa[46].zaa06 = "Y"
#      LET g_zaa[52].zaa06 = "N"
#      LET g_zaa[53].zaa06 = "N"
#   ELSE
#      LET g_zaa[46].zaa06 = "N"
#      LET g_zaa[52].zaa06 = "Y"
#      LET g_zaa[53].zaa06 = "Y"
#   END IF
#   IF g_sma115 = "Y" OR g_sma.sma116 MATCHES '[23]' THEN
#      LET g_zaa[51].zaa06 = "N"
#   ELSE
#      LET g_zaa[51].zaa06 = "Y"
#   END IF
#   CALL cl_prt_pos_len()
#
#   START REPORT axmr660_rep TO l_name
#   LET g_pageno = 0
#No.FUN-750095 -- end --
 
   FOREACH axmr660_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
#No.FUN-750095 --begin
#      FOR g_i = 1 TO 3
#         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.oga01
#              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.oga02 USING 'yyyymmdd'
#              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.oga03
#              WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.oga04
#              WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.oga14
#              WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.oga15
#              OTHERWISE LET l_order[g_i] = '-'
#          END CASE
#       END FOR
#       LET sr.ogb14  = sr.balance*sr.ogb13*sr.oga24
#       LET sr.order1 = l_order[1]
#       LET sr.order2 = l_order[2]
#       LET sr.order3 = l_order[3]
#       OUTPUT TO REPORT axmr660_rep(sr.*)
      #-----CHI-880035---------
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM oma_file,omb_file
        WHERE oma01 = omb01 
          AND omb31 = sr.oga01 
          AND omb32 = sr.ogb03
          AND omavoid = 'N'
      IF l_cnt > 0 THEN
         CONTINUE FOREACH
      END IF
      #-----END CHI-880035-----
      #LET sr.ogb14  = sr.balance*sr.ogb13*sr.oga24  #FUN-C50129  mark 
      #LET sr.ogb14  = sr.balance*sr.oga24   #FUN-C50129  add  #TQC-C80012 mark
      LET sr.ogb14  = sr.balance*sr.ogb13*sr.oga24   #TQC-C80012 add
      
      LET sr.ogb14  = cl_digcut(sr.ogb14,sr.azi04) #CHI-A80003 add
      #MOD-C60216 add beg
      LET sr.ogb14t  = sr.ogb14t*sr.oga24
      LET sr.ogb14t  = cl_digcut(sr.ogb14t,sr.azi04)
      #MOD-C60216  add end      
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.oga14
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.oga15
      IF sr.ogb04[1,4] !='MISC' THEN
         SELECT ima021 INTO l_ima021 FROM ima_file
            WHERE ima01 = sr.ogb04
      ELSE
         LET l_ima021 = ''
      END IF
 
      SELECT ima021,ima906 INTO l_ima021,l_ima906 FROM ima_file
                         WHERE ima01=sr.ogb04
      LET l_str2 = ""
      IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
                CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915
                LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED
                IF cl_null(sr.ogb915) OR sr.ogb915 = 0 THEN
                   CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912
                   LET l_str2 = l_ogb912, sr.ogb910 CLIPPED
                ELSE
                   IF NOT cl_null(sr.ogb912) AND sr.ogb912 > 0 THEN
                      CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912
                      LET l_str2 = l_str2 CLIPPED,',',l_ogb912, sr.ogb910 CLIPPED
                   END IF
                END IF
            WHEN "3"
               IF NOT cl_null(sr.ogb915) AND sr.ogb915 > 0 THEN
                  CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915
                  LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED
               END IF
         END CASE
      END IF
      IF g_sma.sma116 MATCHES '[23]' THEN
         IF sr.ogb910 <> sr.ogb916 THEN
            CALL cl_remove_zero(sr.balance) RETURNING l_ogb12
            LET l_str2 = l_str2 CLIPPED,"(",l_ogb12,sr.ogb05 CLIPPED,")"
         END IF
      END IF
 
      EXECUTE insert_prep USING sr.oga01,sr.oga02,sr.oga03,sr.oga032,sr.oga04,
              sr.occ02,sr.oga14,l_gen02,sr.oga15,l_gem02,sr.ogb03,sr.ogb31,
              sr.ogb04,sr.ogb06,l_ima021,l_str2,sr.ogb916,sr.ogb917,sr.ogb05,
              sr.ogb13,sr.ogb14,sr.azi03,sr.azi04,sr.azi05,sr.ogb14t  ##MOD-C60216 add sr.ogb14t
      IF STATUS THEN
         CALL cl_err("execute insert_prep:",STATUS,1)
         EXIT FOREACH
      END IF
#No.FUN-750095 -- end --
   END FOREACH
 
#No.FUN-750095 -- begin --
#   FINISH REPORT axmr660_rep
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   CALL cl_wcchp(tm.wc,'oga01,oga04,oga02,oga14,oga03,oga15') RETURNING tm.wc
   LET g_str = tm.wc,";",g_zz05,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t,";",tm.u
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file
   IF g_sma.sma116 MATCHES '[23]' THEN
      CALL cl_prt_cs3('axmr660','axmr660',g_sql,g_str)
   ELSE
      IF g_sma115 = "Y" THEN
         CALL cl_prt_cs3('axmr660','axmr660_1',g_sql,g_str)
      ELSE
         CALL cl_prt_cs3('axmr660','axmr660_2',g_sql,g_str)
      END IF
   END IF
#No.FUN-750095 -- end --
 #  CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-6A0094   #FUN-B80089  MARK
END FUNCTION
 
#No.FUN-750095 -- begin --
#REPORT axmr660_rep(sr)
#   DEFINE l_last_sw   LIKE type_file.chr1,   #No.FUN-680137  VARCHAR(1)
#          sr               RECORD order1  LIKE oga_file.oga03, #No.FUN-680137 VARCHAR(10)
#                                  order2  LIKE oga_file.oga03, #No.FUN-680137 VARCHAR(10)
#                                  order3  LIKE oga_file.oga03, #No.FUN-680137 VARCHAR(10)
#                                  oga01   LIKE oga_file.oga01,    #
#                                  oga02   LIKE oga_file.oga02,
#                                  oga03   LIKE oga_file.oga03,
#                                  oga032  LIKE oga_file.oga032,
#                                  oga04   LIKE oga_file.oga04,
#                                  occ02   LIKE occ_file.occ02,
#                                  oga14   LIKE oga_file.oga14,
#                                  oga15   LIKE oga_file.oga15,
#                                  oga24   LIKE oga_file.oga24,
#                                  ogb03   LIKE ogb_file.ogb03,   #單身項次
#                                  ogb31   LIKE ogb_file.ogb31,
#                                  ogb04   LIKE ogb_file.ogb04,
#                                  ogb06   LIKE ogb_file.ogb06,
#                                  ogb05   LIKE ogb_file.ogb05,
#                                  ogb13   LIKE ogb_file.ogb13,
#                                  balance LIKE ogb_file.ogb12,
#                                  ogb14   LIKE ogb_file.ogb14,
#                                  ogb910  LIKE ogb_file.ogb910,
#                                  ogb912  LIKE ogb_file.ogb912,
#                                  ogb913  LIKE ogb_file.ogb913,
#                                  ogb915  LIKE ogb_file.ogb915,
#                                  ogb916  LIKE ogb_file.ogb916,
#                                  ogb917  LIKE ogb_file.ogb917,
#                                  azi03  LIKE azi_file.azi03,
#                                  azi04  LIKE azi_file.azi04,
#                                  azi05  LIKE azi_file.azi05
#                        END RECORD,
#      l_amt     LIKE ogb_file.ogb14,
#      l_ima021  LIKE ima_file.ima021,
#      l_gen02   LIKE gen_file.gen02,
#      l_gem02   LIKE gem_file.gem02,
#      l_chr        LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
#
#   DEFINE  l_ogb915    STRING
#   DEFINE  l_ogb912    STRING
#   DEFINE  l_ogb12     STRING
#   DEFINE  l_str2      STRING
#   DEFINE  l_ima906    LIKE ima_file.ima906
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.order1,sr.order2,sr.order3,sr.oga01
#
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED, pageno_total
#      PRINT ''
#
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
#            g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],
#            g_x[45],g_x[46],g_x[47],g_x[49],g_x[51],g_x[52],g_x[53]
#
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.order1
#      IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr.order2
#      IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr.order3
#      IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr.oga01
#      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.oga14
#      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.oga15
#      PRINT COLUMN g_c[31], sr.oga01,
#            COLUMN g_c[32],sr.oga02,
#            COLUMN g_c[33],sr.oga03,
#            COLUMN g_c[34],sr.oga032,
#            COLUMN g_c[35],sr.oga04,
#            COLUMN g_c[36],sr.occ02,
#            COLUMN g_c[37],sr.oga14,
#            COLUMN g_c[38],l_gen02,
#            COLUMN g_c[39],sr.oga15,
#            COLUMN g_c[40],l_gem02;
#   ON EVERY ROW
#      IF sr.ogb04[1,4] !='MISC' THEN
#         SELECT ima021 INTO l_ima021 FROM ima_file
#          WHERE ima01 = sr.ogb04
#      ELSE
#         LET l_ima021 = ''
#      END IF
#
#
#
#      SELECT ima021,ima906 INTO l_ima021,l_ima906 FROM ima_file
#                         WHERE ima01=sr.ogb04
#      LET l_str2 = ""
#      IF g_sma115 = "Y" THEN
#         CASE l_ima906
#            WHEN "2"
#                CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915
#                LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED
#                IF cl_null(sr.ogb915) OR sr.ogb915 = 0 THEN
#                    CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912
#                    LET l_str2 = l_ogb912, sr.ogb910 CLIPPED
#                ELSE
#                   IF NOT cl_null(sr.ogb912) AND sr.ogb912 > 0 THEN
#                      CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912
#                      LET l_str2 = l_str2 CLIPPED,',',l_ogb912, sr.ogb910 CLIPPED
#                   END IF
#                END IF
#            WHEN "3"
#                IF NOT cl_null(sr.ogb915) AND sr.ogb915 > 0 THEN
#                    CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915
#                    LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED
#                END IF
#         END CASE
#      ELSE
#      END IF
#      IF g_sma.sma116 MATCHES '[23]' THEN
#            IF sr.ogb910 <> sr.ogb916 THEN
#               CALL cl_remove_zero(sr.balance) RETURNING l_ogb12
#               LET l_str2 = l_str2 CLIPPED,"(",l_ogb12,sr.ogb05 CLIPPED,")"
#            END IF
#      END IF
#
#      PRINT COLUMN g_c[41],sr.ogb03 USING '###&',
#            COLUMN g_c[42],sr.ogb31,
#            COLUMN g_c[43],sr.ogb04 CLIPPED,
#            COLUMN g_c[44],sr.ogb06,
#            COLUMN g_c[45],l_ima021,
#            COLUMN g_c[51],l_str2 CLIPPED,
#            COLUMN g_c[52],sr.ogb916,
#            COLUMN g_c[53],sr.ogb917 USING '###########&.&&',
#            COLUMN g_c[46],sr.ogb05,
#            COLUMN g_c[47],cl_numfor(sr.ogb13,47,sr.azi03),
#            COLUMN g_c[49],cl_numfor(sr.ogb14,49,sr.azi04) CLIPPED
#
#   AFTER GROUP OF sr.oga01
#      LET l_amt = GROUP SUM(sr.ogb14)
#      PRINT COLUMN g_c[47],g_x[09] CLIPPED,
#            COLUMN g_c[49], cl_numfor(l_amt,49,sr.azi05) CLIPPED
#      PRINT ''
#      LET l_chr = 'Y'
#
#   AFTER GROUP OF sr.order1
#      IF tm.u[1,1] = 'Y' THEN
#         LET l_amt = GROUP SUM(sr.ogb14)
#         PRINT COLUMN g_c[47],g_x[09] CLIPPED,
#               COLUMN g_c[49], cl_numfor(l_amt,49,sr.azi05) CLIPPED
#         PRINT g_dash2[1,g_len]
#         LET l_chr = 'N'
#      END IF
#
#   AFTER GROUP OF sr.order2
#      IF tm.u[2,2] = 'Y' THEN
#         LET l_amt = GROUP SUM(sr.ogb14)
#         PRINT COLUMN g_c[47],g_x[09] CLIPPED,
#               COLUMN g_c[49], cl_numfor(l_amt,49,sr.azi05) CLIPPED
#         PRINT g_dash2[1,g_len]
#         LET l_chr = 'N'
#      END IF
#
#   AFTER GROUP OF sr.order3
#      IF tm.u[3,3] = 'Y' THEN
#         LET l_amt = GROUP SUM(sr.ogb14)
#         PRINT COLUMN g_c[47],g_x[09] CLIPPED,
#               COLUMN g_c[49], cl_numfor(l_amt,49,sr.azi05) CLIPPED
#         PRINT g_dash2[1,g_len]
#         LET l_chr = 'N'
#      END IF
#
#   ON LAST ROW
#      LET l_amt = SUM(sr.ogb14)
#      IF l_chr = 'Y' THEN
#         PRINT g_dash2[1,g_len]
#      END IF
#      PRINT COLUMN g_c[47],g_x[10] CLIPPED,
#            COLUMN g_c[49], cl_numfor(l_amt,49,sr.azi05) CLIPPED
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#         CALL cl_wcchp(tm.wc,'oga01,oga02,oga03,oga04,oga14,oga15')
#              RETURNING tm.wc
#         PRINT g_dash[1,g_len]
#         CALL cl_prt_pos_wc(tm.wc)
#
#      END IF
#      LET l_last_sw = 'y'
#      PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#No.FUN-750095 -- end --
 
