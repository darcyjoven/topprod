# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aapr800.4gl
# Descriptions...: 提貨通知單
# Date & Author..: 96/01/10 By Roegr
# Modify.........: No.FUN-550030 05/05/20 By ice 單據編號欄位放大
# Modify.........: No.FUN-550099 05/05/25 By echo 新增報表備註
# Modify.........: No.FUN-580003 05/08/02 By jackie voucher轉XML,雙單位報表修改
# Modify.........: No.MOD-5A0394 05/10/26 By Smapmin L/C No. 的名稱和參考單號的名稱印顛倒
# Modify.........: No.TQC-5B0139 05/11/28 By Rosayu 參數有多單位報表有單位註解時單頭資料會在左半邊
# Modify.........: No.TQC-5C0037 05/12/08 By kevin 結束位置調整
# Modify.........: NO.FUN-590118 06/01/19 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.FUN-660117 06/06/16 By Rainy Char改為 Like
# Modify.........: No.TQC-610053 06/07/03 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0128 06/11/24 By xufeng 修改報表
# Modify.........: No.TQC-710088 07/01/30 By Smapmin 修改列印位置
# Modify.........: NO.FUN-710029 07/01/16 By Yiting 外購多單位
# Modify.........: No.FUN-710086 07/02/07 By Rayven 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/22 By Nicole 新增CR參數
# Modify.........: No.TQC-920069 09/02/20 By mike MSV BUG
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-B50022 11/05/05 By Dido 單價改用 azi03 取位 
# Modify.........: No.FUN-BB0047 11/11/25 By fengrui  調整時間函數問題
# Modify.........: No.TQC-C10034 12/01/18 By zhuhao 簽核處理 
# Modify.........: No:TQC-BC0013 12/02/10 By Elise 加入部門編號、付款條件說明欄位
# Modify.........: No.CHI-C80041 12/12/19 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
  DEFINE g_seq_item     LIKE type_file.num5        # No.FUN-690028 SMALLINT
END GLOBALS
 
   DEFINE tm  RECORD                   # Print condition RECORD
              wc      LIKE type_file.chr1000,      # Where condition  #No.FUN-690028 VARCHAR(600)
              price   LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1),         #
              more    LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)          # Input more condition(Y/N)
              END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(72)
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_sma115        LIKE sma_file.sma115
DEFINE   g_sma116    LIKE sma_file.sma116      #FUN-710029
DEFINE   l_table     STRING                    #No.FUN-710086
DEFINE   g_sql       STRING                    #No.FUN-710086
DEFINE   g_str       STRING                    #No.FUN-710086
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 mark 
 
   #No.FUN-710086 --start--
   LET g_sql = "als05.als_file.als05,pmc03_1.pmc_file.pmc03,ala03.ala_file.ala03,",
               "als06.als_file.als06,pmc03_2.pmc_file.pmc03,als07.als_file.als07,",
               "als04.als_file.als04,als02.als_file.als02,als10.als_file.als10,",
               "als01.als_file.als01,als11.als_file.als11,als22.als_file.als22,",
               "als23.als_file.als23,als21.als_file.als21,als03.als_file.als03,",
               "als08.als_file.als08,als09.als_file.als09,als14.als_file.als14,",
               "alt02.alt_file.alt02,alt14.alt_file.alt14,alt15.alt_file.alt15,",
               "alt11.alt_file.alt11,pmn07.pmn_file.pmn07,alt06.alt_file.alt06,",
               "alt05.alt_file.alt05,alt07.alt_file.alt07,pmn041.pmn_file.pmn041,",
               "als13.als_file.als13,als31.als_file.als31,als32.als_file.als32,",
               "als33.als_file.als33,als34.als_file.als34,als35.als_file.als35,",
               "als36.als_file.als36,alt86.alt_file.alt86,alt87.alt_file.alt87,",
               "str.type_file.chr1000,azi03.azi_file.azi03,azi04.azi_file.azi04,", #MOD-B50022 add azi03 
               "azi05.azi_file.azi05,",
              #TQC-C10034---add---begin
               "sign_type.type_file.chr1,sign_img.type_file.blob,", 
               "sign_show.type_file.chr1,sign_str.type_file.chr1000,",
              #TQC-C10034---add---end
               "l_als04.gem_file.gem02,l_als10.pma_file.pma02"  #TQC-BC0013 add als04,als10
 
   LET l_table = cl_prt_temptable('aapr800',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"       #MOD-B50022 add ?  #TQC-C10034 add 4?  #TQC-BC0013 add ?,?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-710086 --end--
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add 
   LET tm.price = 'N'
   LET g_pdate = ARG_VAL(1)            # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.price = ARG_VAL(8)   #TQC-610053
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file #FUN-710029
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r800_tm(0,0)        # Input print condition
   ELSE
      CALL r800()              # Read data and create out-file
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
 
END MAIN
 
FUNCTION r800_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
 
   OPEN WINDOW r800_w WITH FORM "aap/42f/aapr800"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET tm.price = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies= '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc  ON als01,als02
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
      LET INT_FLAG = 0
      CLOSE WINDOW r800_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.price,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
      LET INT_FLAG = 0 CLOSE WINDOW r800_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aapr800'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aapr800','9031',1)
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
                         " '",tm.price CLIPPED,"'",   #TQC-610053
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
         CALL cl_cmdat('aapr800',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r800_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r800()
   ERROR ""
END WHILE
   CLOSE WINDOW r800_w
END FUNCTION
 
FUNCTION r800()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#         l_time    LIKE type_file.chr8,           # Used time for running the job  #No.FUN-690028 VARCHAR(8)
          l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT  #No.FUN-690028 VARCHAR(1200)
          l_za05    LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(40)
          l_order   ARRAY[5] OF LIKE zaa_file.zaa08,      # No.FUN-690028 VARCHAR(10),
          als	RECORD LIKE als_file.*,
          alt	RECORD LIKE alt_file.*,
          ala	RECORD LIKE ala_file.*,
          sr   RECORD
               pmc03 LIKE pmc_file.pmc03, # 廠商簡稱
               pmn041 LIKE pmn_file.pmn041,
               pmn07  LIKE pmn_file.pmn07,
               azi03  LIKE azi_file.azi03,         #MOD-B50022
               azi04  LIKE azi_file.azi04,
               azi05  LIKE azi_file.azi05,
#No.FUN-580003 --start--
               pmn80 LIKE pmn_file.pmn80,
               pmn82 LIKE pmn_file.pmn81,
               pmn83 LIKE pmn_file.pmn83,
               pmn85 LIKE pmn_file.pmn85,
               pmn20 LIKE pmn_file.pmn20   #FUN-710029
              END RECORD
     DEFINE l_i,l_cnt          LIKE type_file.num5    #No.FUN-690028 SMALLINT
     DEFINE l_zaa02            LIKE zaa_file.zaa02
     DEFINE i                  LIKE type_file.num5    #No.FUN-690028 SMALLINT
#No.FUN-580003 --end--
 
     #No.FUN-710086 --start--
     DEFINE    l_pmc03         LIKE pmc_file.pmc03
     DEFINE    l_ima906        LIKE ima_file.ima906
     DEFINE    l_str2          LIKE type_file.chr1000
     DEFINE    l_pmn85         STRING
     DEFINE    l_pmn82         STRING
     #TQC-BC0013---add---str---
     DEFINE l_als04 LIKE gem_file.gem02
     DEFINE l_als10 LIKE pma_file.pma01
     #TQC-BC0013---add---end---
     #No.FUN-710086 --end--
     #TQC-C10034--add--begin
     DEFINE l_img_blob     LIKE type_file.blob
     LOCATE l_img_blob IN MEMORY
     #TQC-C10034--add--end 
     CALL cl_del_data(l_table)  #No.FUN-710086
 
     SELECT sma115 INTO g_sma115 FROM sma_file   #FUN-580003
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#     LET g_len = 101   #No.FUN-550030
#     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND alsuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND alsgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND alsgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('alsuser', 'alsgrup')
     #End:FUN-980030
 
     LET l_sql= "SELECT als_file.*, alt_file.*, ala_file.*, ",
                "       pmc03, pmn041, pmn07,azi03,azi04,azi05,pmn80,pmn82,pmn83,pmn85, ",  #No.FUN-580003 #MOD-B50022 add azi03
                "       pmn20 ",  #FUN-710029
                 " FROM als_file LEFT OUTER JOIN ala_file ON als03=ala01 ",
                               " LEFT OUTER JOIN pmc_file ON als05=pmc01 ",
                               " LEFT OUTER JOIN azi_file ON als11=azi01, ",
                      " alt_file LEFT OUTER JOIN pmn_file ON alt14=pmn01 AND alt15=pmn02 ",
                " WHERE als01=alt01 AND alafirm<>'X' AND ",tm.wc CLIPPED,
                "   AND alsfirm <> 'X' "  #CHI-C80041
 
     PREPARE r800_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
     END IF
     DECLARE r800_curs1 CURSOR FOR r800_prepare1
 
#No.FUN-710086 --start-- mark
#    CALL cl_outnam('aapr800') RETURNING l_name
##FUN-710029 start------#zaa06隱藏否
#    IF g_sma116 MATCHES '[13]' THEN
#        LET g_zaa[47].zaa06 = "N" #計價單位
#        LET g_zaa[48].zaa06 = "N" #計價數量
#        LET g_zaa[36].zaa06 = "Y" #單位
#        LET g_zaa[37].zaa06 = "Y" #數量
#    ELSE
#        LET g_zaa[47].zaa06 = "Y" #計價單位
#        LET g_zaa[48].zaa06 = "Y" #計價數量
#        LET g_zaa[36].zaa06 = "N" #單位
#        LET g_zaa[37].zaa06 = "N" #數量
#    END IF
##FUN-710029 end------------
##No.FUN-580003  --start
#    #IF g_sma115 = "Y" THEN
#    IF g_sma115 = "Y" OR g_sma116 MATCHES '[13]' THEN   #FUN-710029
#        LET g_zaa[46].zaa06 = "N"
#    ELSE
#        LET g_zaa[46].zaa06 = "Y"
#    END IF
#    CALL cl_prt_pos_len()
##No.FUN-580003 --end--
#    START REPORT r800_rep TO l_name
#    LET g_pageno = 0
#No.FUN-710086 --end--
 
     FOREACH r800_curs1 INTO als.*, alt.*, ala.*, sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          IF tm.price='N' THEN LET alt.alt05=NULL LET alt.alt07=NULL END IF
          IF tm.price='N' THEN LET als.als13=NULL                    END IF
 
          #No.FUN-710086 --start--
          SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01 = als.als06
         #SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=sr.pmn04  #TQC-920069
          SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=sr.pmn041 #TQC-920069
          LET l_str2 = ""
          IF g_sma115 = "Y" THEN
             CASE l_ima906
                WHEN "2"
                    CALL cl_remove_zero(sr.pmn85) RETURNING l_pmn85
                    LET l_str2 = l_pmn85 , sr.pmn83 CLIPPED
                    IF cl_null(sr.pmn85) OR sr.pmn85 = 0 THEN
                        CALL cl_remove_zero(sr.pmn82) RETURNING l_pmn82
                        LET l_str2 = l_pmn82, sr.pmn80 CLIPPED
                    ELSE
                       IF NOT cl_null(sr.pmn82) AND sr.pmn82 > 0 THEN
                          CALL cl_remove_zero(sr.pmn82) RETURNING l_pmn82
                          LET l_str2 = l_str2 CLIPPED,',',l_pmn82, sr.pmn80 CLIPPED
                       END IF
                    END IF
                WHEN "3"
                    IF NOT cl_null(sr.pmn85) AND sr.pmn85 > 0 THEN
                        CALL cl_remove_zero(sr.pmn85) RETURNING l_pmn85
                        LET l_str2 = l_pmn85 , sr.pmn83 CLIPPED
                    END IF
             END CASE
          END IF
          IF als.als31 IS NULL THEN LET als.als31=0 END IF
          IF als.als32 IS NULL THEN LET als.als32=0 END IF
          IF als.als33 IS NULL THEN LET als.als33=0 END IF
          IF als.als34 IS NULL THEN LET als.als34=0 END IF
          IF als.als35 IS NULL THEN LET als.als35=0 END IF
          IF als.als36 IS NULL THEN LET als.als36=0 END IF
          
          #TQC-BC0013 ---add-----start---
          LET l_als04 = ''
          SELECT gem02 INTO l_als04 FROM gem_file
           WHERE gem01 = als.als04

          LET l_als10 = ''
          SELECT pma02 INTO l_als10 FROM pma_file
           WHERE pma01 = als.als10
          #TQC-BC0013 ---add-----end--- 
          EXECUTE insert_prep USING als.als05,sr.pmc03,ala.ala03,als.als06,
                                    l_pmc03,als.als07,als.als04,als.als02,
                                    als.als10,als.als01,als.als11,als.als22,
                                    als.als23,als.als21,als.als03,als.als08,
                                    als.als09,als.als14,alt.alt02,alt.alt14,
                                    alt.alt15,alt.alt11,sr.pmn07,alt.alt06,
                                    alt.alt05,alt.alt07,sr.pmn041,als.als13,
                                    als.als31,als.als32,als.als33,als.als34,
                                    als.als35,als.als36,alt.alt86,alt.alt87,
                                    l_str2,sr.azi03,sr.azi04,sr.azi05         #MOD-B50022 add azi03
                                    ,"",  l_img_blob,   "N","",           #TQC-C10034  add
                                    l_als04,l_als10                       #TQC-BC0013 add l_als04, l_als10
          #No.FUN-710086 --end--
 
#         OUTPUT TO REPORT r800_rep(als.*, alt.*, ala.*, sr.*)       #No.FUN-710086 mark
     END FOREACH
 
#    FINISH REPORT r800_rep                        #No.FUN-710086
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)   #No.FUN-710086
 
     #No.FUN-710086 --start--
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(tm.wc,'als01,als02')
          RETURNING tm.wc
     LET g_str = tm.price,";",tm.wc,";",g_zz05,";",g_sma116,";",g_sma115
   # LET l_sql = "SELECT * FROM ",l_table CLIPPED  #TQC-730088
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
   # CALL cl_prt_cs3('aapr800',l_sql,g_str)        #TQC-730088
    #TQC-C10034--add--begin
     LET g_cr_table = l_table
     LET g_cr_apr_key_f = "als01" 
    #TQC-C10034--add--end
     CALL cl_prt_cs3('aapr800','aapr800',l_sql,g_str)
     #No.FUN-710086 --end--
 
END FUNCTION
 
#No.FUN-710086 --start-- mark
{REPORT r800_rep(als, alt, ala, sr)
   DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          als	RECORD LIKE als_file.*,
          alt	RECORD LIKE alt_file.*,
          ala	RECORD LIKE ala_file.*,
          sr   RECORD
               pmc03 LIKE pmc_file.pmc03, # 廠商簡稱
               pmn041 LIKE pmn_file.pmn041,
               pmn07  LIKE pmn_file.pmn07,
               azi04  LIKE azi_file.azi04,
               azi05  LIKE azi_file.azi05,
#No.FUN-580003 --start--
               pmn80 LIKE pmn_file.pmn80,
               pmn82 LIKE pmn_file.pmn81,
               pmn83 LIKE pmn_file.pmn83,
               pmn85 LIKE pmn_file.pmn85,
               pmn20 LIKE pmn_file.pmn20   #FUN-710029
               END RECORD,
         #l_pmc03     VARCHAR(12),            #FUN-660117 remark
         l_pmc03     LIKE pmc_file.pmc03,  #FUN-660117
         l_chr       LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
  DEFINE l_ima906    LIKE ima_file.ima906
  DEFINE l_str2      LIKE type_file.chr1000     # No.FUN-690028 VARCHAR(100)
  DEFINE l_pmn85     STRING
  DEFINE l_pmn82     STRING
#No.FUN-580003 --end--
  DEFINE l_ima021     LIKE ima_file.ima021,   #FUN-710029 
         l_alb85      LIKE alb_file.alb85,    #FUN-710029
         l_alb82      LIKE alb_file.alb82,    #FUN-710029
         l_pmn20      LIKE pmn_file.pmn20     #FUN-710029
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY als.als01, alt.alt02
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2+1),g_company CLIPPED
      PRINT ' '
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2+1),g_x[1] CLIPPED
      PRINT ' '
 
      LET g_msg = NULL
      SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01 = als.als06
      PRINT g_x[11] CLIPPED,als.als05,' ',sr.pmc03,
            COLUMN 89,g_x[12] CLIPPED,als.als01    #TQC-5B0139   #TQC-710088
      PRINT g_x[13] CLIPPED,als.als06,' ',l_pmc03,
            COLUMN 89,g_x[14] CLIPPED,als.als02    #TQC-5B0139   #TQC-710088
      PRINT g_x[15] CLIPPED,als.als04
#      PRINT 'L/C No. :',als.als03,  #MOD-5A0394
#            COLUMN 90,g_x[16] CLIPPED,ala.ala03   #MOD-5A0394 #TQC-5B0139 50-90
      PRINT 'L/C No. :',ala.ala03,   #MOD-5A0394
            COLUMN 89,g_x[16] CLIPPED,als.als03    #MOD-5A0394 #TQC-5B0139   #TQC-710088
      PRINT g_x[17] CLIPPED,als.als07
      PRINT g_x[18] CLIPPED,als.als21,
            COLUMN 89,g_x[19] CLIPPED,als.als10    #TQC-5B0139   #TQC-710088
      PRINT g_x[20] CLIPPED,als.als22,' ',als.als23,
            COLUMN 89,g_x[21] CLIPPED,als.als11    #TQC-5B0139   #TQC-710088
      PRINT g_x[22] CLIPPED,als.als08,als.als09
      PRINT '         ',als.als14
      PRINT g_dash[1,g_len]
#No.FUN-580003 --start--
#      PRINT g_x[23] CLIPPED,g_x[24] CLIPPED,g_x[25] CLIPPED
#No.FUN-550030 start
#      PRINT ' -- -------------------- -------------------- ---- --------------- ',
#            '--------------- ------------------'
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],
                     g_x[47],g_x[48],  #FUN-710029
                     g_x[36],g_x[37],  #No.FUN-580003
                     g_x[40],g_x[41],
                     g_x[46]           #FUN-710029
      PRINTX name=H2 g_x[42],g_x[43],g_x[44],g_x[45]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF als.als01
      SKIP TO TOP OF PAGE
 
   ON EVERY ROW
#No.FUN-580003 --start--
      SELECT ima906 INTO l_ima906 FROM ima_file
      #                   WHERE ima01=sr.pmn04  #TQC-920069
                          WHERE ima01=sr.pmn041 #TQC-920069 
      LET l_str2 = ""
      IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
                CALL cl_remove_zero(sr.pmn85) RETURNING l_pmn85
                LET l_str2 = l_pmn85 , sr.pmn83 CLIPPED
                IF cl_null(sr.pmn85) OR sr.pmn85 = 0 THEN
                    CALL cl_remove_zero(sr.pmn82) RETURNING l_pmn82
                    LET l_str2 = l_pmn82, sr.pmn80 CLIPPED
                ELSE
                   IF NOT cl_null(sr.pmn82) AND sr.pmn82 > 0 THEN
                      CALL cl_remove_zero(sr.pmn82) RETURNING l_pmn82
                      LET l_str2 = l_str2 CLIPPED,',',l_pmn82, sr.pmn80 CLIPPED
                   END IF
                END IF
            WHEN "3"
                IF NOT cl_null(sr.pmn85) AND sr.pmn85 > 0 THEN
                    CALL cl_remove_zero(sr.pmn85) RETURNING l_pmn85
                    LET l_str2 = l_pmn85 , sr.pmn83 CLIPPED
                END IF
         END CASE
      ELSE
      END IF
      PRINTX name=D1
            COLUMN g_c[31],alt.alt02 USING '###&', #FUN-590118
            COLUMN g_c[32],alt.alt14,
            COLUMN g_c[33],alt.alt15 USING '###&', #FUN-590118
            COLUMN g_c[34],alt.alt11,
            COLUMN g_c[47],alt.alt86,              #FUN-710029
            COLUMN g_c[48],cl_numfor(alt.alt87,48,sr.azi04),  #FUN-710029
            COLUMN g_c[36],sr.pmn07,
            COLUMN g_c[37],cl_numfor(alt.alt06,37,sr.azi04),
            COLUMN g_c[40],cl_numfor(alt.alt05,40,sr.azi04),
            COLUMN g_c[41],cl_numfor(alt.alt07,41,sr.azi04),
            COLUMN g_c[46],l_str2 CLIPPED  #No.FUN-580003
      PRINTX name=D2
            COLUMN g_c[45],sr.pmn041
#No.FUN-580003 --end--
 
   AFTER GROUP OF als.als01
      PRINTX name=S1
            COLUMN g_c[40],g_x[26] CLIPPED,
            COLUMN g_c[41],cl_numfor(als.als13,41,sr.azi05)
#No.FUN-580003 --end--
#No.FUN-550030 end
      IF tm.price='Y' THEN
         PRINT
         PRINT COLUMN g_c[31],
           g_x[27] CLIPPED,cl_numfor(als.als31,8,sr.azi04),
                           cl_numfor(als.als32,8,sr.azi04),
                           cl_numfor(als.als33,8,sr.azi04),
                           cl_numfor(als.als34,8,sr.azi04),
                           cl_numfor(als.als35,8,sr.azi04),
                           cl_numfor(als.als36,8,sr.azi04);
         IF als.als31 IS NULL THEN LET als.als31=0 END IF
         IF als.als32 IS NULL THEN LET als.als32=0 END IF
         IF als.als33 IS NULL THEN LET als.als33=0 END IF
         IF als.als34 IS NULL THEN LET als.als34=0 END IF
         IF als.als35 IS NULL THEN LET als.als35=0 END IF
         IF als.als36 IS NULL THEN LET als.als36=0 END IF
         PRINT COLUMN g_c[40],g_x[28] CLIPPED,
               COLUMN g_c[41],cl_numfor((als.als31+als.als32+als.als33+
                     als.als34+als.als35+als.als36),18,sr.azi04)
      END IF
 
## FUN-550099
ON LAST ROW
      LET l_last_sw = 'y'
 
PAGE TRAILER
      PRINT g_dash[1,g_len]
#     PRINT        #No.TQC-6B0128
      #PRINT g_x[29] CLIPPED,COLUMN 25,g_x[30] CLIPPED,COLUMN 50,g_x[31] CLIPPED
      IF l_last_sw = 'n' THEN
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED #No.TQC-6B0128
         IF g_memo_pagetrailer THEN
             PRINT g_memo
             PRINT g_x[29]
         ELSE
             PRINT
             PRINT
         END IF
#        PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED #No.TQC-5C0037
      ELSE
             PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED #No.TQC-TQC-6B0128
             PRINT g_memo
             PRINT g_x[29]
#            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED #No.TQC-5C0037 #No.TQC-6B0128
      END IF
## END FUN-550099
 
END REPORT}
#No.FUN-710086 --end--
#Patch....NO.TQC-610035 <> #
