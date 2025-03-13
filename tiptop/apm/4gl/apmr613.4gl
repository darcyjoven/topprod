# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: apmr613.4gl
# Descriptions...: 採購退貨理由分析表
# Input parameter:
# Date & Author..: 94/07/05 By DANNY
# Modify.........: No.FUN-4C0095 04/12/27 By Mandy 報表轉XML
# Modify.........: No.MOD-530190 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式 or DEC(20,6)
# Modify.........: No.TQC-5B0037 05/11/07 By Rosayu 修改報表結束定位點
# Modify.........: No.TQC-5B0212 05/11/30 By kevin 合計沒對齊
# Modify.........: No.TQC-610085 06/04/06 By Claire Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680136 06/09/04 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-720010 07/02/06 BY TSD 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/28 By Sarah CR報表串cs3()增加傳一個參數,增加數字取位的處理
# Modify.........: No.MOD-7A0081 07/10/16 By claire 變數定義應為數值在ifx環境才能做SUM()
# Modify.........: No.MOD-7B0005 07/11/01 By Carol SQL調整 apb_file 改為OUTER
# Modify.........: No.TQC-960115 09/06/11 By Carrier 選擇'3.全部',rvu00 = '2|3' & OUTER處理
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-A50009 10/05/10 By liuxqa modify sql
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                          # Print condition RECORD
             #wc      VARCHAR(500),              # Where condition   #TQC-630166 mark
              wc      STRING,                 # Where condition   #TQC-630166
              a       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
              s       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1) 
              more    LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1) 
              END RECORD,
          l_cd        LIKE type_file.chr1,    #No.FUN-680136   #排列順序
          l_tot1      LIKE type_file.num5,    #No.FUN-680136   #退貨筆數合計
          l_tot2      LIKE apb_file.apb10,    #MOD-530190      #退貨金額合計
          new_03      LIKE type_file.num5,    #FUN-720010 add
          new_04      LIKE type_file.num20_6  #FUN-720010 add
   DEFINE  g_i        LIKE type_file.num5     #count/index for any purpose   #No.FUN-680136 SMALLINT
 
DEFINE   l_table         STRING                     ### FUN-720010 add ###
DEFINE   g_sql           STRING                     ### FUN-720010 add ###
DEFINE   g_str           STRING                     ### FUN-720010 add ###
 
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
 
   #str FUN-720010 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> FUN-720010 *** ##
   LET g_sql = "sr01.gsb_file.gsb05,",
               "sr02.aaf_file.aaf03,",
               "sr03.type_file.num5,",
               "sr04.type_file.num20_6,",
               "new_03.type_file.num5,",
               "new_04.type_file.num20_6,",
               "l_tot1.type_file.num5,",
               "l_tot2.apb_file.apb10,",
               "order1.tqw_file.tqw19"
 
   LET l_table = cl_prt_temptable('apmr613',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-A50009 mod
               " VALUES(?,?,?,?,?, ?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) -----------------------------------#
   #end FUN-720010 add
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
#---------------No.TQC-610085 modify
   LET tm.a  = ARG_VAL(8)
   LET tm.s  = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#---------------No.TQC-610085 end
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL apmr613_tm(0,0)             # Input print condition
      ELSE CALL apmr613()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION apmr613_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01       #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,      #No.FUN-680136 SMALLINT
          l_cmd          LIKE type_file.chr1000    #No.FUN-680136 VARCHAR(1000) 
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW apmr613_w AT p_row,p_col WITH FORM "apm/42f/apmr613"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '1'
   LET tm.a    = '3'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON rvu01,rvu03
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
      LET INT_FLAG = 0 CLOSE WINDOW apmr613_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.a,tm.s,tm.more         # Condition
   INPUT BY NAME tm.a,tm.s,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF tm.a NOT MATCHES '[123]' OR cl_null(tm.a) THEN
            NEXT FIELD a
         END IF
      AFTER FIELD s
         IF tm.s NOT MATCHES '[123]' OR cl_null(tm.s) THEN
            NEXT FIELD s
         END IF
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
      LET INT_FLAG = 0 CLOSE WINDOW apmr613_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='apmr613'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr613','9031',1)
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
                         " '",tm.a  CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apmr613',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW apmr613_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmr613()
   DELETE FROM tmp_file
   ERROR ""
END WHILE
   CLOSE WINDOW apmr613_w
END FUNCTION
 
FUNCTION apmr613()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name            #No.FUN-680136 VARCHAR(20)
          l_time    LIKE type_file.chr8,          # Used time for running the job       #No.FUN-680136 VARCHAR(8)
         #l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT   #TQC-630166 mark  #No.FUN-680136 VARCHAR(1000) 
          l_sql     STRING,                       # RDSQL STATEMENT   #TQC-630166
          l_chr     LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1)
          l_rvv26   LIKE rvv_file.rvv26,
          l_apb10   LIKE apb_file.apb10,
          l_za05    LIKE type_file.chr1000,       #No.FUN-680136 VARCHAR(40)
          sr            RECORD    order1  LIKE tqw_file.tqw19,     #No.FUN-680136 VARCHAR(15)
                                  sr01 LIKE gsb_file.gsb05,        #No.FUN-680136 VARCHAR(4)         #Reason code
                                  sr02 LIKE aaf_file.aaf03,        #No.FUN-680136 VARCHAR(30)        #Reason description
                                  sr03 LIKE type_file.num5,        #No.FUN-680136 SMALLINT        #count
                                  sr04 LIKE type_file.num20_6      #No.FUN-680136 DECIMAL(20,6)   #amount #MOD-530190
                        END RECORD
     
 
   #str FUN-720010 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-720010 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
   #end FUN-720010 add
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-720010 add ###
#No.CHI-6A0004---------Begin------------
#   SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
#          FROM azi_file WHERE azi01=g_aza.aza17
#No.CHI-6A0004---------End------------ 
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #       LET tm.wc = tm.wc clipped," AND rvuuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET tm.wc = tm.wc clipped," AND rvugrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET tm.wc = tm.wc clipped," AND rvugrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('rvuuser', 'rvugrup')
   #End:FUN-980030
 
   LET l_sql = "SELECT rvv26,apb10",
               "  FROM rvu_file,rvv_file,OUTER apb_file ",             #MOD-7B0005-modify add OUTER
               " WHERE rvu01=rvv01 AND rvv01=apb_file.apb21 AND rvv02=apb_file.apb22 ",  #MOD-7B0005-modify ora   #No.TQC-960115
               "   AND rvuconf ='Y' AND ", tm.wc CLIPPED
   IF tm.a='1' THEN
      LET l_sql = l_sql CLIPPED," AND rvu00='2' "
   END IF
   IF tm.a='2' THEN
      LET l_sql = l_sql CLIPPED," AND rvu00='3' "
   END IF
   #No.TQC-960115  --Begin
   IF tm.a='3' THEN
      LET l_sql = l_sql CLIPPED," AND (rvu00 = '2' OR rvu00 = '3') "
   END IF
   #No.TQC-960115  --End  
   PREPARE apmr613_p1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare1:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM 
   END IF
   DECLARE apmr613_c1 CURSOR FOR apmr613_p1
   IF STATUS THEN CALL cl_err('declare1:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM 
   END IF
 
   DROP TABLE tmp_file
#No.FUN-680136--begin
#     CREATE TEMP TABLE tmp_file
#                   ( tmp01   VARCHAR(4),             #理由
#                      tmp02   DEC(20,6)        #退貨AMT #MOD-530190
#                   )
   CREATE TEMP TABLE tmp_file(                                                                                                     
                tmp01   LIKE ade_file.ade04,                                                                       
                tmp02   LIKE type_file.num20_6)   #MOD-7A0081 modify  type_file.chr20                                                           
#No.FUN-680136--end
 
   DELETE FROM tmp_file
   LET l_tot1=0    LET l_tot2=0
   FOREACH apmr613_c1 INTO l_rvv26,l_apb10
      IF NOT cl_null(l_rvv26) THEN
#MOD-7B0005-add
         IF cl_null(l_apb10) THEN 
            LET l_apb10 = 0
         END IF 
#MOD-7B0005-add-end
         INSERT INTO tmp_file VALUES (l_rvv26,l_apb10)
         LET l_tot1=l_tot1+1
         LET l_tot2=l_tot2+l_apb10
      END IF
   END FOREACH
 
   LET l_sql = "SELECT 0,tmp01,azf03,COUNT(*),SUM(tmp02)",
               "  FROM tmp_file,OUTER azf_file",
               " WHERE tmp01 = azf_file.azf01",   #No.MOD-960115
               "   AND azf02='2'  ", #6818
              #" GROUP BY 1,2,3  "        #FUN-720010 mark
               " GROUP BY tmp01,azf03 "   #FUN-720010 modify
   PREPARE apmr613_p2 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare2:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM 
   END IF
   DECLARE apmr613_c2 CURSOR FOR apmr613_p2
   #CALL cl_outnam('apmr613') RETURNING l_name
 
   FOREACH apmr613_c2 INTO sr.*
      IF STATUS THEN CALL cl_err('foreach2:',STATUS,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
         EXIT PROGRAM 
      END IF
      IF tm.s='1' THEN LET sr.order1=sr.sr03 USING '########'
                       LET l_cd=g_x[18] CLIPPED,g_x[16] CLIPPED END IF
      IF tm.s='2' THEN LET sr.order1=sr.sr04 USING '########'
                       LET l_cd=g_x[18] CLIPPED,g_x[17] CLIPPED END IF
      IF tm.s='3' THEN LET sr.order1=sr.sr01
                       LET l_cd=g_x[18] CLIPPED,g_x[19] CLIPPED END IF
 
      LET new_03 = (sr.sr03/l_tot1)*100  #FUN-720010 add
      LET new_04 = (sr.sr04/l_tot2)*100  #FUN-720010 add
 
      #str FUN-720010 add
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-720010 *** ##
      EXECUTE insert_prep USING
         sr.sr01, sr.sr02,  sr.sr03,  sr.sr04,  new_03, new_04,
         l_tot1,  l_tot2,   sr.order1
      #------------------------------ CR (3) ------------------------------#
      #end FUN-720010 add
   END FOREACH
 
   #str FUN-720010 add
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-720010 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'rvu01,rvu03')
      RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   LET g_str = g_str,';',tm.s,";",g_azi04,";",g_azi05   #FUN-710080 modify
   CALL cl_prt_cs3('apmr613','apmr613',l_sql,g_str)     #FUN-710080 modify
   #------------------------------ CR (4) ------------------------------#
   #end FUN-720010 add
 
END FUNCTION
