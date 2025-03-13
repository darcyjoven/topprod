# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcr312.4gl
# Descriptions...: LCM 評價表
# Input parameter: 
# Return code....: 
# Date & Author..: 00/03/16 By Danny
# Modify.........: No.FUN-4C0099 05/01/25 By kim 報表轉XML功能
# Modify.........: No.MOD-530122 05/03/16 By Carol QBE欄位順序調整
# Modify.........: No.MOD-530181 05/03/23 By kim Define金額單價位數改為DEC(20,6)
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-570190 05/08/08 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.TQC-610051 06/02/23 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680122 06/09/01 By zdyllq 類型轉換
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.MOD-720042 07/02/14 By TSD.miki 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/30 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.FUN-730057 07/03/30 By bnlent 會計科目加帳套
# Modify.........: No.TQC-720032 07/04/01 By johnray 修正期別檢核方式
# Modify.........: No.TQC-770110 07/07/23 By wujie  下條件時,"原料科目,制成品科目,商品科目"應該能夠讓user開窗查詢
# Modify.........: No.TQC-780054 07/08/17 By zhoufeng 修改INSERT INTO temptable語法
# Modify.........: No.TQC-790019 07/09/03 By Sarah INSERT INT temptable部份寫法不符標準
# Mofify.........: No.FUN-7C0101 08/01/25 By lala 成本改善
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26*
# Modify.........: No.TQC-A40139 10/05/05 By Carrier FUN-9A0067 追单
# Modify.........: No.FUN-B10052 11/01/27 By lilingyu 科目查詢自動過濾
# Modify.........: No:CHI-C30012 12/07/27 By bart 金額取位改抓ccz26

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(300),     # Where condition
              yy      LIKE type_file.num5,          #No.FUN-680122SMALLINT
              mm      LIKE type_file.num5,          #No.FUN-680122SMALLINT
              type    LIKE ccc_file.ccc07,          #No.FUN-7C0101 add
              acct_1  LIKE aag_file.aag01,          #No.FUN-680122CHAR(24)
              acct_2  LIKE aag_file.aag01,          #No.FUN-680122CHAR(24)
              acct_3  LIKE aag_file.aag01,          #No.FUN-680122CHAR(24)
              more    LIKE type_file.chr1           #No.FUN-680122CHAR(1)       # Input more condition(Y/N)
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
#No.MOD-720042 TSD.miki-------------------------------------------------------------(S)
DEFINE   l_table         STRING
DEFINE   g_sql           STRING
DEFINE   g_str           STRING
DEFINE   g_tot           ARRAY[9] OF LIKE ccc_file.ccc92
#No.MOD-720042 TSD.miki-------------------------------------------------------------(E)
DEFINE   g_flag    LIKE type_file.chr1     #No.FUN-730057
DEFINE   g_bookno1 LIKE aza_file.aza81     #No.FUN-730057
DEFINE   g_bookno2 LIKE aza_file.aza82     #No.FUN-730057
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo 
 
  #No.MOD-720042 TSD.miki-----------------------------------------------------------(S)
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>
   LET g_sql = "ima12.ima_file.ima12,",
               "azf03.azf_file.azf03,",
               "ccc08.ccc_file.ccc08,",    #FUN-7C0101
               "tot01.ccc_file.ccc92,",
               "tot02.ccc_file.ccc92,",
               "tot03.ccc_file.ccc92,",
               "tot04.ccc_file.ccc92,",
               "tot05.ccc_file.ccc92,",
               "tot06.ccc_file.ccc92,",
               "tot07.ccc_file.ccc92,",
               "tot08.ccc_file.ccc92,",
               "tot09.ccc_file.ccc92,",
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05"
   LET l_table = cl_prt_temptable('axcr312',g_sql) CLIPPED   # 產生Temp Table
   IF l_table  = -1 THEN EXIT PROGRAM END IF                 # Temp Table產生
#  LET g_sql = "SELECT * FROM ds_report.",l_table CLIPPED,          #No.TQC-780054
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #No.TQC-780054   #TQC-790019 mod
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,? ,?)"   #No.FUN-7C0101 add ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      EXIT PROGRAM
   END IF
  #No.MOD-720042 TSD.miki-----------------------------------------------------------(E)
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   #TQC-610051-begin
   LET tm.yy   = ARG_VAL(8)
   LET tm.mm   = ARG_VAL(9)
   LET tm.acct_1  = ARG_VAL(10)
   LET tm.acct_2  = ARG_VAL(11)
   LET tm.acct_3  = ARG_VAL(12)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET tm.type = ARG_VAL(16)                 #FUN-7C0101
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(8)
   #LET g_rep_clas = ARG_VAL(9)
   #LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   ##No.FUN-570264 ---end---
   #TQC-610051-end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL axcr312_tm(0,0)        # Input print condition
      ELSE CALL axcr312()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr312_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680122CHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 6 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 15
   END IF
   OPEN WINDOW axcr312_w AT p_row,p_col
        WITH FORM "axc/42f/axcr312" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   #No.TQC-A40139  --Begin
#  LET tm.yy = YEAR(g_today)
#  LET tm.mm = MONTH(g_today)
   LET tm.yy = g_ccz.ccz01                                                       
   LET tm.mm = g_ccz.ccz02
   #No.TQC-A40139  --End  
   LET tm.type = g_ccz.ccz28          #No.FUN-7C0101 add
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #No.FUN-730057  --Begin
   CALL s_get_bookno(tm.yy) RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag = '1' THEN
      CALL cl_err(tm.yy,'aoo-081',1)
   END IF
   #No.FUN-730057  --End
WHILE TRUE
 #MOD-530122
   CONSTRUCT BY NAME tm.wc ON ccc01,ima08,ima12 
##
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
 
#No.FUN-570240 --start                                                          
     ON ACTION CONTROLP                                                      
        IF INFIELD(ccc01) THEN                                              
           CALL cl_init_qry_var()                                           
           LET g_qryparam.form = "q_ima"                                    
           LET g_qryparam.state = "c"                                       
           CALL cl_create_qry() RETURNING g_qryparam.multiret               
           DISPLAY g_qryparam.multiret TO ccc01                             
           NEXT FIELD ccc01                                                 
        END IF                                                              
#No.FUN-570240 --end     
 
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
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('cccuser', 'cccgrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axcr312_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN 
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.yy,tm.mm,tm.type,tm.acct_1,tm.acct_2,tm.acct_3,tm.more #No.FUN-7C0101 add tm.type
                 WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD yy
         IF cl_null(tm.yy) THEN NEXT FIELD yy END IF
      AFTER FIELD mm
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.mm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.mm > 12 OR tm.mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            ELSE
               IF tm.mm > 13 OR tm.mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            END IF
         END IF
#         IF cl_null(tm.mm) OR tm.mm < 1 OR tm.mm > 13 THEN NEXT FIELD mm END IF
#No.TQC-720032 -- end --
 
      AFTER FIELD type                                               #No.FUN-7C0101
         IF tm.type NOT MATCHES '[12345]' THEN NEXT FIELD type END IF#No.FUN-7C0101
         
      AFTER FIELD acct_1
         IF cl_null(tm.acct_1) THEN NEXT FIELD acct_1 END IF
         SELECT aag01 FROM aag_file WHERE aag01 = tm.acct_1 
                                      AND aag00 = g_bookno1    #No.FUN-730057
         IF STATUS THEN 
#           CALL cl_err(tm.acct_1,'agl-001',0)    #No.FUN-660127
            CALL cl_err3("sel","aag_file",tm.acct_1,"","agl-001","","",0)   #No.FUN-660127
#FUN-B10052 --begin--
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.default1 = tm.acct_1
               LET g_qryparam.arg1     = g_bookno1
               LET g_qryparam.construct= 'N' 
               LET g_qryparam.where = " aag01 LIKE '",tm.acct_1 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING tm.acct_1
               DISPLAY BY NAME tm.acct_1
#FUN-B10052 --end--
            NEXT FIELD acct_1
         END IF

      AFTER FIELD acct_2
         IF cl_null(tm.acct_2) THEN NEXT FIELD acct_2 END IF
         SELECT aag01 FROM aag_file WHERE aag01 = tm.acct_2 
                                      AND aag00 = g_bookno1    #No.FUN-730057
         IF STATUS THEN 
#           CALL cl_err(tm.acct_2,'agl-001',0)    #No.FUN-660127
            CALL cl_err3("sel","aag_file",tm.acct_2,"","agl-001","","",0)   #No.FUN-660127
#FUN-B10052 --begin--
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.default1 = tm.acct_2
               LET g_qryparam.arg1     = g_bookno1
               LET g_qryparam.construct= 'N'
               LET g_qryparam.where = " aag01 LIKE '",tm.acct_2 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING tm.acct_2
               DISPLAY BY NAME tm.acct_2
#FUN-B10052 --end--
            NEXT FIELD acct_2
         END IF

      AFTER FIELD acct_3
         IF cl_null(tm.acct_3) THEN NEXT FIELD acct_3 END IF
         SELECT aag01 FROM aag_file WHERE aag01 = tm.acct_3 
                                      AND aag00 = g_bookno1    #No.FUN-730057
         IF STATUS THEN 
#           CALL cl_err(tm.acct_3,'agl-001',0)    #No.FUN-660127
            CALL cl_err3("sel","aag_file",tm.acct_3,"","agl-001","","",0)   #No.FUN-660127
#FUN-B10052 --begin--
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.default1 = tm.acct_3
               LET g_qryparam.arg1     = g_bookno1
               LET g_qryparam.construct = 'N'
               LET g_qryparam.where = " aag01 LIKE '",tm.acct_3 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING tm.acct_3
               DISPLAY BY NAME tm.acct_3
#FUN-B10052 --end--
            NEXT FIELD acct_3
         END IF

      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
#No.TQC-770110--begin
      ON ACTION controlp                                                                                                            
         CASE 
            WHEN INFIELD(acct_1)                     
               CALL cl_init_qry_var()                      
               LET g_qryparam.form ="q_aag"                 
               LET g_qryparam.default1 = tm.acct_1
               LET g_qryparam.arg1     = g_bookno1                
               CALL cl_create_qry() RETURNING tm.acct_1
               DISPLAY BY NAME tm.acct_1
               NEXT FIELD acct_1   
            WHEN INFIELD(acct_2)                     
               CALL cl_init_qry_var()                      
               LET g_qryparam.form ="q_aag"                 
               LET g_qryparam.default1 = tm.acct_2
               LET g_qryparam.arg1     = g_bookno1                
               CALL cl_create_qry() RETURNING tm.acct_2
               DISPLAY BY NAME tm.acct_2
               NEXT FIELD acct_2   
            WHEN INFIELD(acct_3)                     
               CALL cl_init_qry_var()                      
               LET g_qryparam.form ="q_aag"                 
               LET g_qryparam.default1 = tm.acct_3
               LET g_qryparam.arg1     = g_bookno1                
               CALL cl_create_qry() RETURNING tm.acct_3
               DISPLAY BY NAME tm.acct_3
               NEXT FIELD acct_3   
            OTHERWISE EXIT CASE                                                                                                     
          END CASE    
#No.TQC-770110--end
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr312_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axcr312'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr312','9031',1)   
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
                         #TQC-610051-begin
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'",
                         " '",tm.type CLIPPED,"'" ,             #No.FUN-7C0101 add
                         " '",tm.acct_1 CLIPPED,"'",
                         " '",tm.acct_2 CLIPPED,"'",
                         " '",tm.acct_3 CLIPPED,"'",
                         #TQC-610051-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axcr312',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr312_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr312()
   ERROR ""
END WHILE
   CLOSE WINDOW axcr312_w
END FUNCTION
 
FUNCTION axcr312()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680122  VARCHAR(20),        # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0146
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680122CHAR(600)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(40)
          l_tmp     LIKE ccc_file.ccc92,
          l_ima12   LIKE ima_file.ima12,          #No.MOD-720042 TSD.miki
          l_azf03   LIKE azf_file.azf03,          #No.MOD-720042 TSD.miki
          sr        RECORD 
                    ccc01    LIKE ccc_file.ccc01,    #料件編號
                    ccc08    LIKE ccc_file.ccc08,    #FUN-7C0101
                    ccc91    LIKE ccc_file.ccc91,    #期末數量
                    ccc92    LIKE ccc_file.ccc92,    #期末成本
                    ima12    LIKE ima_file.ima12,    #分群碼一
                    ima39    LIKE ima_file.ima39,    #料件科目
                    ima91    LIKE ima_file.ima91,    #最近月加權進價
                    azf03    LIKE azf_file.azf03,    #分群碼說明
                    cost     LIKE ccc_file.ccc92,    #核定市價
                    type     LIKE type_file.chr1          # Prog. Version..: '5.30.06-13.03.12(01)              #1.原料 2.製成品 3.商品
                    END RECORD
 
    #No.MOD-720042 TSD.miki---------------------------------------------------------(S)
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>>
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    #No.MOD-720042 TSD.miki---------------------------------------------------------(E)
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql ="SELECT ccc01,ccc08,ccc91,ccc92,ima12,ima39,ima91,azf03,0,'' ",    #FUN-7C0101
                "  FROM ccc_file,ima_file LEFT OUTER JOIN azf_file ON ima12=azf01 AND azf02 = 'G' ",
                " WHERE ccc01 = ima01 ",
                "   AND ccc02 = ",tm.yy,
                "   AND ccc03 = ",tm.mm,
                "   AND ccc07 ='",tm.type,"'",       #FUN-7C0101
                "   AND ima39 IN ('",tm.acct_1,"','",tm.acct_2,"',",
                                 "'",tm.acct_3,"')",
                "   AND ",tm.wc CLIPPED
 
     PREPARE axcr312_pr FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE axcr312_cs1 CURSOR FOR axcr312_pr
 
    #CALL cl_outnam('axcr312') RETURNING l_name  #No.MOD-720042 TSD.miki mark
    #START REPORT axcr312_rep TO l_name          #No.MOD-720042 TSD.miki mark
 
     LET g_pageno = 0
     FOREACH axcr312_cs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       IF cl_null(sr.ima91) THEN LET sr.ima91 = 0 END IF
       LET sr.cost = sr.ccc91 * sr.ima91
       IF cl_null(sr.cost) THEN LET sr.cost = 0 END IF
       CASE 
         WHEN sr.ima39 = tm.acct_1  #原料
              LET sr.type = '1'    
         WHEN sr.ima39 = tm.acct_2  #製成品
              LET sr.type = '2'    
         WHEN sr.ima39 = tm.acct_3  #商品
              LET sr.type = '3'
       END CASE
      #OUTPUT TO REPORT axcr312_rep(sr.*)     #No.MOD-720042 TSD.miki mark
       CALL axcr312_data(sr.*)                #No.MOD-720042 TSD.miki
     END FOREACH
 
    #No.MOD-720042 TSD.miki---------------------------------------------------------(S)
    #FINISH REPORT axcr312_rep
 
    #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>>
    #str TQC-790019 mod
    #LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     LET l_sql = " SELECT ima12,azf03,ccc08,SUM(tot01) tot01,SUM(tot02) tot02,",    #FUN-7C0101
                 "        SUM(tot03) tot03,SUM(tot04) tot04,SUM(tot05) tot05,",
                 "        SUM(tot06) tot06,SUM(tot07) tot07,SUM(tot08) tot08,",
                 "        SUM(tot09) tot09,azi03,azi04,azi05 ",
                 "   FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 "  GROUP BY ima12,azf03,ccc08,azi03,azi04,azi05"          #FUN-7C0101
    #end TQC-790019 mod
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'ccc01,ima08,ima12')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str,";",tm.yy,";",tm.mm
     
#No.FUN-7C0101-------------BEGIN-----------------
   #CALL cl_prt_cs3('axcr312','axcr312',l_sql,g_str)    #FUN-710080 modify
   IF tm.type MATCHES '[12]' THEN
      CALL cl_prt_cs3('axcr312','axcr312_1',l_sql,g_str)
   END IF
   IF tm.type MATCHES '[345]' THEN
      CALL cl_prt_cs3('axcr312','axcr312',l_sql,g_str)
   END IF
#No.FUN-7C0101--------------END------------------
    #No.MOD-720042 TSD.miki---------------------------------------------------------(E)
END FUNCTION
 
#No.MOD-720042 TSD.miki-------------------------------------------------------------(S)
FUNCTION axcr312_data(sr)
   DEFINE sr        RECORD 
                    ccc01    LIKE ccc_file.ccc01,    #料件編號
                    ccc08    LIKE ccc_file.ccc08,    #FUN-7C0101
                    ccc91    LIKE ccc_file.ccc91,    #期末數量
                    ccc92    LIKE ccc_file.ccc92,    #期末成本
                    ima12    LIKE ima_file.ima12,    #分群碼一
                    ima39    LIKE ima_file.ima39,    #料件科目
                    ima91    LIKE ima_file.ima91,    #最近月加權進價
                    azf03    LIKE azf_file.azf03,    #分群碼說明
                    cost     LIKE ccc_file.ccc92,    #核定市價
                    type     LIKE type_file.chr1     #1.原料 2.製成品 3.商品
                    END RECORD
 
   LET g_tot[1] = 0
   LET g_tot[2] = 0
   LET g_tot[3] = 0
   LET g_tot[4] = 0
   LET g_tot[5] = 0
   LET g_tot[6] = 0
   LET g_tot[7] = 0
   LET g_tot[8] = 0
   LET g_tot[9] = 0
   CASE sr.type
        WHEN '1'
             LET g_tot[1] = sr.ccc92
             LET g_tot[2] = sr.cost
        WHEN '2'
             LET g_tot[3] = sr.ccc92
             LET g_tot[4] = sr.cost
        WHEN '3'
             LET g_tot[5] = sr.ccc92
             LET g_tot[6] = sr.cost
   END CASE
   LET g_tot[7] = g_tot[1] + g_tot[3] + g_tot[5]
   LET g_tot[8] = g_tot[2] + g_tot[4] + g_tot[6]
   #str TQC-790019 add
   IF g_tot[7] > g_tot[8] THEN
      LET g_tot[9] = g_tot[7] - g_tot[8]
   ELSE
      LET g_tot[9] = 0
   END IF
   #end TQC-790019 add
   IF cl_null(sr.ima12) THEN LET sr.ima12 = ' ' END IF   #TQC-790019 add
   IF cl_null(sr.azf03) THEN LET sr.azf03 = ' ' END IF   #TQC-790019 add
   EXECUTE insert_prep USING
           sr.ima12,sr.azf03,sr.ccc08,                         #FUN-7C0101
           g_tot[1],g_tot[2],g_tot[3],g_tot[4],g_tot[5],
           g_tot[6],g_tot[7],g_tot[8],g_tot[9],
           #g_azi03,g_azi04,g_azi05  #CHI-C30012
           g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26  #CHI-C30012
 
END FUNCTION
#No.MOD-720042 TSD.miki-------------------------------------------------------------(E)
 
 
REPORT axcr312_rep(sr)
 #  DEFINE qty  LIKE ima_file.ima26,           #No.FUN-680122DEC(15,3)#FUN-A20044
   DEFINE qty  LIKE type_file.num15_3,           #No.FUN-680122DEC(15,3)#FUN-A20044
          u_p  LIKE oeb_file.oeb13,           #No.FUN-680122DECIMAL(20,6)
          amt  LIKE oeb_file.oeb13            #No.FUN-680122 DECIMAL(20,6)
   DEFINE l_last_sw LIKE type_file.chr1,          #No.FUN-680122CHAR(1)
          sr        RECORD 
                    ccc01    LIKE ccc_file.ccc01,    #料件編號
                    ccc91    LIKE ccc_file.ccc91,    #期末數量
                    ccc92    LIKE ccc_file.ccc92,    #期末成本
                    ima12    LIKE ima_file.ima12,    #分群碼一
                    ima39    LIKE ima_file.ima39,    #料件科目
                    ima91    LIKE ima_file.ima91,    #最近月加權進價
                    azf03    LIKE azf_file.azf03,    #分群碼說明
                    cost     LIKE ccc_file.ccc92,    #核定市價
                    type     LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)               #1.原料 2.製成品 3.商品
                    END RECORD,
          l_tot11,l_tot21,l_tot31   LIKE ccc_file.ccc92,
          l_tot12,l_tot22,l_tot32   LIKE ccc_file.ccc92,
          l_total1,l_total2,l_tmp   LIKE ccc_file.ccc92 
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.ima12,sr.type
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      PRINT g_x[9] clipped,tm.yy USING '####','/',tm.mm USING '##'
      PRINT g_dash
      PRINT COLUMN r312_getStartPos(32,33,g_x[11]),g_x[11],
            COLUMN r312_getStartPos(34,35,g_x[12]),g_x[12],
            COLUMN r312_getStartPos(36,37,g_x[13]),g_x[13],
            COLUMN r312_getStartPos(38,40,g_x[14]),g_x[14]
      PRINT COLUMN g_c[32],g_dash2[1,g_w[32]+g_w[33]+1],
            COLUMN g_c[34],g_dash2[1,g_w[34]+g_w[35]+1],
            COLUMN g_c[36],g_dash2[1,g_w[36]+g_w[37]+1],
            COLUMN g_c[38],g_dash2[1,g_w[38]+g_w[39]+g_w[40]+2]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   AFTER GROUP OF sr.ima12
      LET l_tot11 = GROUP SUM(sr.ccc92) WHERE sr.type = '1'
      LET l_tot12 = GROUP SUM(sr.cost)  WHERE sr.type = '1'
      LET l_tot21 = GROUP SUM(sr.ccc92) WHERE sr.type = '2'
      LET l_tot22 = GROUP SUM(sr.cost)  WHERE sr.type = '2'
      LET l_tot31 = GROUP SUM(sr.ccc92) WHERE sr.type = '3'
      LET l_tot32 = GROUP SUM(sr.cost)  WHERE sr.type = '3'
      IF cl_null(l_tot11) THEN LET l_tot11 = 0 END IF
      IF cl_null(l_tot12) THEN LET l_tot12 = 0 END IF
      IF cl_null(l_tot21) THEN LET l_tot21 = 0 END IF
      IF cl_null(l_tot22) THEN LET l_tot22 = 0 END IF
      IF cl_null(l_tot31) THEN LET l_tot31 = 0 END IF
      IF cl_null(l_tot32) THEN LET l_tot32 = 0 END IF
      LET l_total1 = l_tot11 + l_tot21 + l_tot31
      LET l_total2 = l_tot12 + l_tot22 + l_tot32
      IF cl_null(l_total1) THEN LET l_total1 = 0 END IF
      IF cl_null(l_total2) THEN LET l_total2 = 0 END IF
      IF l_total1 > l_total2 THEN
         LET l_tmp = l_total1 - l_total2
      ELSE
         LET l_tmp = 0 
      END IF
      IF cl_null(l_tmp) THEN LET l_tmp = 0 END IF
      PRINT COLUMN g_c[31],sr.azf03,
            COLUMN g_c[32],cl_numfor(l_tot11,32,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[33],cl_numfor(l_tot12,33,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[34],cl_numfor(l_tot21,34,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[35],cl_numfor(l_tot22,35,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[36],cl_numfor(l_tot31,36,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[37],cl_numfor(l_tot32,37,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[38],cl_numfor(l_total1,38,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[39],cl_numfor(l_total2,39,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[40],cl_numfor(l_tmp,40,g_ccz.ccz26)    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
 
   ON LAST ROW
      LET l_tot11 = SUM(sr.ccc92) WHERE sr.type = '1'
      LET l_tot12 = SUM(sr.cost)  WHERE sr.type = '1'
      LET l_tot21 = SUM(sr.ccc92) WHERE sr.type = '2'
      LET l_tot22 = SUM(sr.cost)  WHERE sr.type = '2'
      LET l_tot31 = SUM(sr.ccc92) WHERE sr.type = '3'
      LET l_tot32 = SUM(sr.cost)  WHERE sr.type = '3'
      IF cl_null(l_tot11) THEN LET l_tot11 = 0 END IF
      IF cl_null(l_tot12) THEN LET l_tot12 = 0 END IF
      IF cl_null(l_tot21) THEN LET l_tot21 = 0 END IF
      IF cl_null(l_tot22) THEN LET l_tot22 = 0 END IF
      IF cl_null(l_tot31) THEN LET l_tot31 = 0 END IF
      IF cl_null(l_tot32) THEN LET l_tot32 = 0 END IF
      LET l_total1 = l_tot11 + l_tot21 + l_tot31
      LET l_total2 = l_tot12 + l_tot22 + l_tot32
      IF cl_null(l_total1) THEN LET l_total1 = 0 END IF
      IF cl_null(l_total2) THEN LET l_total2 = 0 END IF
      IF l_total1 > l_total2 THEN
         LET l_tmp = l_total1 - l_total2
      ELSE
         LET l_tmp = 0 
      END IF
      IF cl_null(l_tmp) THEN LET l_tmp = 0 END IF
      SKIP 1 LINE
      PRINT COLUMN g_c[31],g_x[10] clipped,
            COLUMN g_c[32],cl_numfor(l_tot11,32,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[33],cl_numfor(l_tot12,33,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[34],cl_numfor(l_tot21,34,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[35],cl_numfor(l_tot22,35,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[36],cl_numfor(l_tot31,36,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[37],cl_numfor(l_tot32,37,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[38],cl_numfor(l_total1,38,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[39],cl_numfor(l_total2,39,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[40],cl_numfor(l_tmp,40,g_ccz.ccz26)    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
 
#by kim 05/1/26
#函式說明:算出一字串,位於數個連續表頭的中央位置
#l_sta -  zaa起始序號   l_end - zaa結束序號  l_sta -字串長度
#傳回值 - 字串起始位置
FUNCTION r312_getStartPos(l_sta,l_end,l_str)
DEFINE l_sta,l_end,l_length,l_pos,l_w_tot,l_i LIKE type_file.num5          #No.FUN-680122 SMALLINT
DEFINE l_str STRING
   LET l_str=l_str.trim()
   LET l_length=l_str.getLength()
   LET l_w_tot=0
   FOR l_i=l_sta to l_end
      LET l_w_tot=l_w_tot+g_w[l_i]
   END FOR
   LET l_pos=(l_w_tot/2)-(l_length/2)
   IF l_pos<0 THEN LET l_pos=0 END IF
   LET l_pos=l_pos+g_c[l_sta]+(l_end-l_sta)
   RETURN l_pos
END FUNCTION
 
