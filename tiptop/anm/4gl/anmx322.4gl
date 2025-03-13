# Prog. Version..: '5.30.07-13.05.30(00002)'     #
#
# Pattern name...: anmx322.4gl
# Descriptions...: 銀行存款餘額表列印作業
# Date & Author..: 94/01/25 By Roger
#                : 96/06/14 By Lynn   銀行編號(nma01) 取6碼
# Modify.........: No:9766 04/07/19 By Nicola 銀行編號(nma01) 取11碼
# Modify.........: No.FUN-4C0098 05/01/03 By pengu 報表轉XML
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
#
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-7A0036 07/11/05 By lutingting 報表改為使用Crystal Report
# Modify.........: No.CHI-830003 08/11/03 By xiaofeizhu 依程式畫面上的〔截止基准日〕回抓當月重評價匯率, 
# Modify.........:                                      若當月未產生重評價則往回抓前一月資料，若又抓不到再往上一個月找，找到有值為止
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990094 09/09/10 By mike 少了抓取l_d1,l_d2,l_c1,l_c2的段落,請參考5X程式追到5.1與5.2版                      
# Modify.........: No.TQC-9B0018 09/11/04 By xiaofeizhu 標準SQL修改
# Modify.........: NO.FUN-A30106 10/03/29 By wujie  增加银行编号开窗挑选功能,"选择"中默认为会计日期
# Modify.........: No:CHI-A50024 10/05/26 By Summer 1.aooi050資料刪除時,增加mfg3008錯誤訊息提示
#                                                   2.增加選項"列印餘額為零者"
# Modify.........: NO.MOD-A40100 10/08/03 By sabrina g_yy,g_mm改用s_yp函數抓取
# Modify.........: No:CHI-9C0021 10/11/25 By Summer 將npg_file開帳資料納入本月存款資料呈現
# Modify.........: No:TQC-B10083 11/01/18 By yinhy nme12抓取錯誤
# Modify.........: No:MOD-C60244 12/06/29 By Polly 當月有開帳時，不需抓取當月nme異動資料做計算
# Modify.........: No:TQC-CB0094 12/11/28 By xuxz 添加報表顯示類型名稱
# Modify.........: No:FUN-D30060 13/03/19 By wangrr CR转为XtraGrid報表
# Modify.........: No:FUN-D40128 13/05/16 By wangrr "幣種,銀行帳戶"增加開窗

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              wc      LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(600)
              edate   LIKE type_file.dat,    #No.FUN-680107 DATE
              bdate   LIKE type_file.dat,    #No.FUN-680107 DATE
              date_sw LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
              a       LIKE type_file.chr1,   #CHI-A50024 add
              more    LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
              END RECORD,
          g_dash_1    LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(100)
 
DEFINE   g_i          LIKE type_file.num5    #count/index for any purpose #No.FUN-680107 SMALLINT
DEFINE   g_head1      STRING
DEFINE   l_table      STRING                 #No.FUN-7A0036
DEFINE   g_str        STRING                 #No.FUN-7A0036
DEFINE   g_sql        STRING                 #No.FUN-7A0036
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
#No.FUN-7A0036--start--
   LET g_sql="nma01.nma_file.nma01,",
             "nma02.nma_file.nma02,",
             "nma04.nma_file.nma04,",
             "nma09.nma_file.nma09,",
             "nmb02.nmb_file.nmb02,",#TQC-CB0094 add
             "nma10.nma_file.nma10,",
             "rest1.nme_file.nme04,",
             "rest2.nme_file.nme04,",
             "azi04.azi_file.azi04,",
             "azi04_1.azi_file.azi04,", #FUN-D30060
             "str01.type_file.chr1000"  #FUN-D30060 add #存儲nma09+':'+nmb02組合值

   LET l_table = cl_prt_temptable('anmx322',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?)"#TQC-CB0094 add ? #FUN-D30060 add 2?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#No.FUN-7A0036--end--
   LET g_pdate = ARG_VAL(1)            # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.edate  = ARG_VAL(8)
   LET tm.date_sw  = ARG_VAL(9)
   LET tm.a  = ARG_VAL(10)   #CHI-A50024 add
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)  #CHI-A50024 mod 10->11
   LET g_rep_clas = ARG_VAL(12)  #CHI-A50024 mod 11->12
   LET g_template = ARG_VAL(13)  #CHI-A50024 mod 12->13
   LET g_rpt_name = ARG_VAL(14)  #No:FUN-7C0078  #CHI-A50024 mod 13->14
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL x322_tm(0,0)
      ELSE CALL x322()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION x322_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680107 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(400)
 
   LET p_row = 4 LET p_col = 16
   OPEN WINDOW x322_w AT p_row,p_col
        WITH FORM "anm/42f/anmx322"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)        #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                            # Default condition
   LET tm.more = 'N'
   LET tm.edate = g_today
#  LET tm.date_sw = '1'
   LET tm.date_sw = '2'                               #No.FUN-A30106
   LET tm.a = 'N'  #CHI-A50024 add
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nma10, nma01, nma04
#No.FUN-A30106  --begin                                                         
      ON ACTION CONTROLP                                                        
         CASE                                                                   
           WHEN INFIELD(nma01)                                                  
              CALL cl_init_qry_var()                                            
              LET g_qryparam.form = "q_nma"                                     
              LET g_qryparam.state = "c"                                        
              CALL cl_create_qry() RETURNING g_qryparam.multiret                
              DISPLAY g_qryparam.multiret TO nma01     
           #FUN-D40128--add--str---
              NEXT FIELD nma01
           WHEN INFIELD(nma10)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_nma10"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO nma10
              NExT FIELD nma10
           WHEN INFIELD(nma04)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_nma04"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO nma04
              NExT FIELD nma04
            #FUN-D40128--add--end                    
         END CASE                                                               
#No.FUN-A30106  --end  
      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                     #No.FUN-550037 hmf
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
 END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
		
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW x322_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.edate,tm.date_sw,tm.a,tm.more  #CHI-A50024 add tm.a
                 WITHOUT DEFAULTS
      AFTER FIELD edate
         IF cl_null(tm.edate) THEN
            CALL cl_err(0,'anm-003',0)
            NEXT FIELD edate
         END IF
      AFTER FIELD date_sw
         IF CL_NULL(tm.date_sw) OR tm.date_sw NOT MATCHES '[12]' THEN
            LET tm.date_sw = '1' NEXT FIELD date_sw
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
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
#     ON ACTION CONTROLP CALL x322_wc()      # Input detail Where Condition
    AFTER INPUT
        IF INT_FLAG THEN EXIT INPUT END IF
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
      LET INT_FLAG = 0 CLOSE WINDOW x322_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='anmx322'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmx322','9031',1)
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
                         " '",tm.edate CLIPPED,"'" ,
                         " '",tm.date_sw CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",          #CHI-A50024 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('anmx322',g_time,l_cmd)
      END IF
      CLOSE WINDOW x322_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL x322()
   ERROR ""
END WHILE
   CLOSE WINDOW x322_w
END FUNCTION
 
{
FUNCTION x322_wc()
   DEFINE l_wc LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(300)
 
   OPEN WINDOW x322_w2 AT 2,2
        WITH FORM "anm/42f/anmt110"
################################################################################
# START genero shell script ADD
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("anmt110")
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('q')
   CONSTRUCT BY NAME l_wc ON                      # 螢幕上取條件
              nme01, nme03, nme05,
              nme06, nme08, nme09, nme11, nme12,
              nme13, nme14, nme15, nme16,
              nme19, nme20, nme17, nme21, nme22,
              nme24, nme25, nme43, nme44, nmemksg, nme36,
              nme31, nme51, nme32, nme52, nme33, nme53, nme34, nme54,
              nme35,
              nmeinpd, nmeuser, nmegrup, nmemodu, nmedate, nmeacti
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
		
   CLOSE WINDOW x322_w2
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW x322_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
END FUNCTION
}
 
FUNCTION x322()
   DEFINE l_name    LIKE type_file.chr20,  # External(Disk) file name #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0082
          l_sql     LIKE type_file.chr1000,# RDSQL STATEMENT #No.FUN-680107 VARCHAR(1200)
          bal01     LIKE npg_file.npg06,        #CHI-9C0021 add
          bal02     LIKE npg_file.npg09,        #CHI-9C0021 add
          bal03     LIKE npg_file.npg16,        #CHI-9C0021 add
          bal04     LIKE npg_file.npg19,        #CHI-9C0021 add
          bal1      LIKE nmp_file.nmp06,
          bal2      LIKE nmp_file.nmp09,
          bal3      LIKE nmp_file.nmp16,
          bal4      LIKE nmp_file.nmp19,
          l_d1      LIKE nme_file.nme04,
          l_d2      LIKE nme_file.nme08,
          l_c1      LIKE nme_file.nme04,
          l_c2      LIKE nme_file.nme08,   #DECIMAL(13,3),
          g_yy0     LIKE type_file.num10,       #CHI-9C0021 add
          g_mm0     LIKE type_file.num10,       #CHI-9C0021 add
          g_yy,g_mm LIKE type_file.num10,  #No.FUN-680107 INTEGER
          c_date    LIKE type_file.chr8,   #No.FUN-680107 VARCHAR(8)
          l_chr     LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(40)
          sr               RECORD
                                  nma01 LIKE nma_file.nma01, #銀行編號
                                  nma02 LIKE nma_file.nma02, #銀行全名
                                  nma04 LIKE nma_file.nma04,
                                  nma09 LIKE nma_file.nma09,
                                  nma10 LIKE nma_file.nma10, #幣別
                                  rest1 LIKE nme_file.nme04, #原幣 餘額
                                  rest2 LIKE nme_file.nme04  #本幣 餘額
                        END RECORD
     DEFINE l_azi04_1  LIKE azi_file.azi04                #No.FUN-7A0036
     DEFINE l_oox01   STRING                           #CHI-830003 add
     DEFINE l_oox02   STRING                           #CHI-830003 add
     DEFINE l_sql_1   STRING                           #CHI-830003 add
     DEFINE l_sql_2   STRING                           #CHI-830003 add
     DEFINE l_sql_3   STRING                           #TQC-B10083 add
     DEFINE l_count   LIKE type_file.num5              #CHI-830003 add
     DEFINE l_nme07   LIKE nme_file.nme07              #CHI-830003 add
     DEFINE l_nme12   LIKE nme_file.nme12              #CHI-830003 add     
     DEFINE l_nmb02   LIKE nmb_file.nmb02              #TQC-CB0094 add
     DEFINE l_str01   LIKE type_file.chr1000 #FUN-D30060
 
     CALL cl_del_data(l_table)                            #No.FUN-7A0036
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'anmx322'  #No.FUN-7A0036
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND nmauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND nmagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND nmagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmauser', 'nmagrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT nma01,nma02,nma04,nma09,nma10,0,0 FROM nma_file",
                 " WHERE ", tm.wc CLIPPED
     PREPARE x322_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
           
     END IF
     DECLARE x322_curs1 CURSOR FOR x322_prepare1
#    LET l_name = 'anmx322.out'                      #No.FUN-7A0036   
#    CALL cl_outnam('anmx322') RETURNING l_name      #No.FUN-7A0036 
#    START REPORT x322_rep TO l_name                 #No.FUN-7A0036
     LET c_date = tm.edate USING 'yyyymmdd'
     LET c_date[7,8]='01'
     LET tm.bdate = MDY(c_date[5,6],c_date[7,8],c_date[1,4])
    #LET g_yy = YEAR(tm.edate) LET g_mm = MONTH(tm.edate)   #MOD-A40100 mark
     CALL s_yp(tm.edate) RETURNING g_yy,g_mm                #MOD-A40100 add
     CALL s_yp(tm.edate) RETURNING g_yy0,g_mm0 #CHI-9C0021 add
     LET g_mm = g_mm - 1
     IF g_mm = 0 THEN LET g_yy = g_yy - 1 LET g_mm = 12 END IF
#    LET g_pageno = 0                                #No.FUN-7A0036
     FOREACH x322_curs1 INTO sr.*
      #CHI-A50024 add --start--
      LET l_count = 0 
      SELECT COUNT(*) INTO l_count FROM azi_file WHERE azi01 = sr.nma10
      IF l_count = 0 THEN
         CALL cl_err(sr.nma10,'mfg3008',1)
         EXIT FOREACH
      END IF
      #CHI-A50024 add --end--

       SELECT azi04 INTO l_azi04_1 FROM azi_file WHERE azi01 = sr.nma10     #No.FUN-7A0036
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       
       #str CHI-9C0021 add
       #將npg_file開帳資料納入本月存款資料呈現
        LET bal01=0  LET bal02=0  LET bal03=0  LET bal04=0
        SELECT SUM(npg06),SUM(npg09),SUM(npg16),SUM(npg19)
          INTO bal01,bal02,bal03,bal04
          FROM npg_file
         WHERE npg01 = sr.nma01 AND npg02 = g_yy0 AND npg03 = g_mm0
        IF tm.date_sw='2' THEN
           LET bal01=bal03  LET bal02=bal04                                                                                      
        END IF                                                                                                                       
        IF bal01 IS NULL OR bal01 = ' ' THEN LET bal01 = 0 END IF                                                                       
        IF bal02 IS NULL OR bal02 = ' ' THEN LET bal02 = 0 END IF                                                                       
        IF bal03 IS NULL OR bal03 = ' ' THEN LET bal03 = 0 END IF                                                                       
        IF bal04 IS NULL OR bal04 = ' ' THEN LET bal04 = 0 END IF                                                                       
       #end CHI-9C0021 add

      #CHI-830003--Add--Begin--#    
      IF g_nmz.nmz20 = 'Y' THEN
         #No.TQC-B10083  --Begin
         #SELECT nme12 INTO l_nme12 FROM nme_file
         # WHERE nme01 = sr.nma01      
         LET l_oox01 = YEAR(tm.edate)
         LET l_oox02 = MONTH(tm.edate)                      	 
         IF tm.date_sw = '1' THEN
            LET l_sql_3 = "SELECT nme12 FROM nme_file",
                          " WHERE nme01 = '",sr.nma01,"'", 
                          "   AND nme02 <= '",tm.edate,"'",
                          "   AND nme12 IS NOT NULL",
                          " ORDER BY nme02 DESC"  
         END IF         
         IF tm.date_sw = '2' THEN
            LET l_sql_3 = "SELECT nme12 FROM nme_file",
                          " WHERE nme01 = '",sr.nma01,"'",
                          "   AND nme16 <= '",tm.edate,"'",
                          "   AND nme12 IS NOT NULL",
                          " ORDER BY nme16 DESC"
         END IF         
         PREPARE x322_prepare08 FROM l_sql_3
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('x322_prepare08:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
         END IF
         DECLARE x322_nme12 CURSOR FOR x322_prepare08
         
         LET l_nme07 = ''
         FOREACH x322_nme12 INTO l_nme12 
         #No.TQC-B10083  --End
            WHILE cl_null(l_nme07)
               LET l_sql_2 = "SELECT COUNT(*) FROM oox_file",
                             " WHERE oox00 = 'NM' AND oox01 <= '",l_oox01,"'",
#                            "   AND convert(decimal(8,2),oox02) <= '",l_oox02,"'",     #TQC-9B0018 Mark
                             "   AND cast(oox02 AS decimal(8,2)) <= '",l_oox02,"'",     #TQC-9B0018 Add
                             "   AND oox03 = '",l_nme12,"'",
                             "   AND oox04 = '0'",
                             "   AND oox041 = '0'"                             
               PREPARE x322_prepare7 FROM l_sql_2
               DECLARE x322_oox7 CURSOR FOR x322_prepare7
               OPEN x322_oox7
               FETCH x322_oox7 INTO l_count
               CLOSE x322_oox7                       
               IF l_count = 0 THEN
                  #LET l_nme07 = '1'   #TQC-B10083 mark
                  EXIT WHILE           #TQC-B10083 add 
               ELSE                  
                  LET l_sql_1 = "SELECT oox07 FROM oox_file",             
                                " WHERE oox00 = 'NM' AND oox01 = '",l_oox01,"'",
                                "   AND oox02 = '",l_oox02,"'",
                                "   AND oox03 = '",l_nme12,"'",
                                "   AND oox04 = '0'",
                                "   AND oox041 = '0'"
               END IF                  
               IF l_oox02 = '01' THEN
                  LET l_oox02 = '12'
                  LET l_oox01 = l_oox01-1
               ELSE    
                  LET l_oox02 = l_oox02-1
               END IF            
               
               IF l_count <> 0 THEN        
                  PREPARE x322_prepare07 FROM l_sql_1
                  DECLARE x322_oox07 CURSOR FOR x322_prepare07
                  OPEN x322_oox07
                  FETCH x322_oox07 INTO l_nme07
                  CLOSE x322_oox07
               END IF              
      #TQC-B10083  --Begin
            END WHILE
            IF NOT cl_null(l_nme07) THEN EXIT FOREACH END IF
         END FOREACH
      END IF 
      #IF cl_null(l_nme07) THEN LET l_nme07 = '1' END IF
      #TQC-B10083  --End
      #CHI-830003--Add--End--#       

       SELECT SUM(nmp06),SUM(nmp09),SUM(nmp16),SUM(nmp19)
              INTO bal1,bal2,bal3,bal4
              FROM nmp_file
              WHERE nmp01 = sr.nma01 AND nmp02 = g_yy AND nmp03 = g_mm
              
       #CHI-830003--Begin--#
       #IF g_nmz.nmz20 = 'Y' AND l_count <> 0 THEN     #TQC-B10083 mark
       IF g_nmz.nmz20 = 'Y' AND l_nme07 != '1' THEN    #TQC-B10083 add
          LET bal2 = bal1 * l_nme07
          LET bal4 = bal3 * l_nme07
       END IF    
       #CHI-830003--End--#              
      #MOD-990094   ---start        
       IF tm.date_sw = '2'
          THEN LET bal1 = bal3 LET bal2 = bal4
       END IF
       IF bal1 IS NULL OR bal1 = ' ' THEN LET bal1 = 0 END IF
       IF bal2 IS NULL OR bal2 = ' ' THEN LET bal2 = 0 END IF
       IF bal3 IS NULL OR bal3 = ' ' THEN LET bal3 = 0 END IF
       IF bal4 IS NULL OR bal4 = ' ' THEN LET bal4 = 0 END IF
       IF tm.date_sw = '1' THEN
          SELECT SUM(nme04),SUM(nme08) INTO l_d1,l_d2 FROM nme_file,nmc_file
                 WHERE nme01 = sr.nma01 AND nme03 = nmc01 AND nmc03 = '1'
                   AND nme02 BETWEEN tm.bdate AND tm.edate
          SELECT SUM(nme04),SUM(nme08) INTO l_c1,l_c2 FROM nme_file,nmc_file
                 WHERE nme01 = sr.nma01 AND nme03 = nmc01 AND nmc03 = '2'
                   AND nme02 BETWEEN tm.bdate AND tm.edate
       END IF                     
       IF tm.date_sw = '2' THEN
          SELECT SUM(nme04),SUM(nme08) INTO l_d1,l_d2 FROM nme_file,nmc_file
                 WHERE nme01 = sr.nma01 AND nme03 = nmc01 AND nmc03 = '1'
                   AND nme16 BETWEEN tm.bdate AND tm.edate
          SELECT SUM(nme04),SUM(nme08) INTO l_c1,l_c2 FROM nme_file,nmc_file
                 WHERE nme01 = sr.nma01 AND nme03 = nmc01 AND nmc03 = '2'
                   AND nme16 BETWEEN tm.bdate AND tm.edate
       END IF
      #MOD-990094   ---end 
       #CHI-830003--Begin--#
       #IF g_nmz.nmz20 = 'Y' AND l_count <> 0 THEN     #TQC-B10083 mark
       IF g_nmz.nmz20 = 'Y' AND l_nme07 != '1' THEN    #TQC-B10083 add
          LET l_d2 = l_d1 * l_nme07
          LET l_c2 = l_c1 * l_nme07
       END IF    
       #CHI-830003--End--#       
       
       IF l_d1 IS NULL THEN LET l_d1 = 0 END IF
       IF l_d2 IS NULL THEN LET l_d2 = 0 END IF
       IF l_c1 IS NULL THEN LET l_c1 = 0 END IF
       IF l_c2 IS NULL THEN LET l_c2 = 0 END IF
      #-------------MOD-C60244--------(S)
       IF bal01 > 0 THEN
          LET l_d1 = 0
          LET l_c1 = 0
       END IF
       IF bal02 > 0 THEN
          LET l_d2 = 0
          LET l_c2 = 0
       END IF
      #-------------MOD-C60244--------(E)
       LET sr.rest1 = bal1 + l_d1 - l_c1 + bal01   #CHI-9C0021 add bal01
       LET sr.rest2 = bal2 + l_d2 - l_c2 + bal02   #CHI-9C0021 add bal02
      #IF sr.rest1= 0 AND sr.rest2 = 0 THEN CONTINUE FOREACH END IF                #CHI-A50024 mark
       IF sr.rest1= 0 AND sr.rest2 = 0 AND tm.a = 'N' THEN CONTINUE FOREACH END IF #CHI-A50024
#      OUTPUT TO REPORT x322_rep(sr.*)                              #No.FUN-7A0036
      #TQC-CB0094 add--str
       LET l_nmb02 = ''
       SELECT nmb02 INTO l_nmb02 FROM nmb_file
       WHERE nmb01 = sr.nma09
       IF SQLCA.SQLCODE THEN LET l_nmb02 = '' END IF
       LET l_str01=sr.nma09,':',l_nmb02   #FUN-D30060 
      #TQC-CB0094 add--end
#No.FUN-7A0036--start--
       EXECUTE insert_prep USING
         sr.nma01,sr.nma02,sr.nma04,sr.nma09,l_nmb02,sr.nma10,#TQC-CB0094 add l_nmb02
         sr.rest1,sr.rest2,l_azi04_1,g_azi04,l_str01  #FUN-D30060 add g_azi04,l_str01 
     END FOREACH
###XtraGrid###     LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN
         CALL cl_wcchp(tm.wc,'nma10,nma01,nma04')
              RETURNING tm.wc
     ELSE
         LET tm.wc=""
     END IF
###XtraGrid###     LET g_str = tm.wc,";",g_azi04,";",tm.edate,";",tm.date_sw
###XtraGrid###     CALL cl_prt_cs3('anmx322','anmx322',g_sql,g_str) 
    LET g_xgrid.table = l_table    ###XtraGrid###
    #FUN-D30060--add--str--
    LET g_xgrid.order_field='nma10,nma01' 
    LET g_xgrid.grup_field='nma10' 
    LET g_xgrid.condition=cl_getmsg('lib-160',g_lang),tm.wc    
    LET g_xgrid.footerinfo1=cl_getmsg('anm-352',g_lang),':',tm.edate
    IF tm.date_sw='1' THEN
       LET g_xgrid.footerinfo1=g_xgrid.footerinfo1,'|',cl_getmsg('lib-035',g_lang),':',cl_getmsg('anm-353',g_lang)
    ELSE
       LET g_xgrid.footerinfo1=g_xgrid.footerinfo1,'|',cl_getmsg('lib-035',g_lang),':',cl_getmsg('anm-354',g_lang)
    END IF
    #FUN-D30060--add--end 
    CALL cl_xg_view()    ###XtraGrid###
#    FINISH REPORT x322_rep                                         #No.FUN-7A0036 
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)                    #No.FUN-7A0036 
#No.FUN-7A0036--end-- 
END FUNCTION
 
#No.FUN-7A0036--start--
{REPORT x322_rep(sr)
   DEFINE l_last_sw        LIKE type_file.chr1,              #No.FUN-680107 VARCHAR(1)
          sr               RECORD
                                  nma01 LIKE nma_file.nma01, #銀行編號
                                  nma02 LIKE nma_file.nma02, #銀行全名
                                  nma04 LIKE nma_file.nma04,
                                  nma09 LIKE nma_file.nma09,
                                  nma10 LIKE nma_file.nma10, #幣別
                                  rest1 LIKE nme_file.nme04, #原幣 餘額
                                  rest2 LIKE nme_file.nme04  #本幣 餘額
                        END RECORD,
      t_azi04_1,t_azi04_2         LIKE type_file.num5        #No.FUN-680107 SMALLINT  #NO.CHI-6A0004
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line   #No.MOD-580242
 
  ORDER BY sr.nma10, sr.nma01      #幣別、銀行
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      PRINT g_head CLIPPED,pageno_total
            IF tm.date_sw = '1' THEN
               LET g_head1=g_x[9] CLIPPED,tm.edate,COLUMN g_c[33],g_x[12]
               PRINT g_head1
            ELSE
               LET g_head1=g_x[9] CLIPPED,tm.edate,COLUMN g_c[33],g_x[13]
               PRINT g_head1
            END IF
      PRINT g_dash[1,g_len]
      #-----No:9766------
      PRINT g_x[31] CLIPPED,
            g_x[32] CLIPPED,
            g_x[33] CLIPPED,
            g_x[34] CLIPPED,
            g_x[35] CLIPPED,
            g_x[36] CLIPPED,
            g_x[37] CLIPPED
      PRINT g_dash1
      #-----END----------
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.nma10  #幣別
      SELECT azi04 INTO t_azi04_1 FROM azi_file WHERE azi01 = sr.nma10 #NO.CHI-6A0004
#      SELECT azi04 INTO g_azi04_2 FROM azi_file WHERE azi01 = g_aza.aza17  #NO.CHI-6A0004
   ON EVERY ROW
      #96-06-14 Modify By Lynn
      #-----No:9766------
      PRINT COLUMN g_c[31], sr.nma01[1,11],
            COLUMN g_c[32],sr.nma02,
            COLUMN g_c[33],sr.nma04,
            COLUMN g_c[34],sr.nma09,
            COLUMN g_c[35],sr.nma10,
            COLUMN g_c[36], cl_numfor(sr.rest1,36,t_azi04_1),  #NO.CHI-6A0004
            COLUMN g_c[37], cl_numfor(sr.rest2,37,g_azi04)
      #-----END----------
   AFTER GROUP OF sr.nma10
      SKIP 1 LINE
      #-----No:9766------
      PRINT COLUMN g_c[33], g_x[10] CLIPPED,
            COLUMN g_c[36], cl_numfor(GROUP SUM(sr.rest1),36,t_azi04_1), #NO.CHI-6A0004
            COLUMN g_c[37], cl_numfor(GROUP SUM(sr.rest2),37,g_azi04)
      #-----END----------
      PRINT g_dash[1,g_len]
   ON LAST ROW
      LET l_last_sw = 'y'
      #-----No:9766------
      PRINT COLUMN g_c[33], g_x[11] CLIPPED,
            COLUMN g_c[37], cl_numfor(SUM(sr.rest2),37,g_azi04)
      #-----END----------
      PRINT g_dash[1,g_len]
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
}
#No.FUN-7A0036--end--


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
