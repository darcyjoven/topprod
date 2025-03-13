# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: asfr550.4gl
# Descriptions...: 工單用料備料用量差異表
# Date & Author..: 91/12/13 By Keith
# Modify.........: 01/08/21 By Carol:add tm.a,tm.b
# Modify.........: NO.MOD-4A0041 04/10/05 By Mandy l_rowid無用到,所以刪除
# Note ..........:
# Modify.........: No.FUN-4B0043 04/11/15 By Nicola 加入開窗功能
# Modify.........: NO.FUN-510029 05/01/13 By Carol 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: No.MOD-580185 05/08/22 By Claire 增加條件
# Modify.........: No.TQC-5B0107 05/11/11 By Pengu 報表料件、品名、規格之格式調整
# Modify.........: NO.TQC-5B0125 05/11/14 BY yiting 欄位不齊
# Modify.........: No.MOD-5B0024 05/12/12 By Pengu 1.388行當sr.sfa05 = 0 時,應改為(exhaust-sr.sfa05) *100 USING '----.##
                                        #          2.g_x[34]與g_x[35]欄位對調
# Modify.........: No.TQC-610080 06/03/03 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680121 06/08/31 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.MOD-6A0125 06/10/26 By eric757 因發料asfi501  已將sfe06異動別改為1,2,3,4 需調整 asfr540,asfr550 倒扣料程式段 
# Modify.........: No.FUN-6A0090 06/11/07 By douzh l_time轉g_time
# Modify.........: No.TQC-6A0087 06/11/09 By king 改正報表中有關錯誤
# Modify.........: No.TQC-710016 07/01/08 By ray "接下頁"和"結束"位置有誤
# Modify.........: No.FUN-760046 07/05/25 By hellen 報表功能改為使用CR
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60027 10/06/12 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No:MOD-A90155 10/09/23 By sabrina 在計算實際耗用量時應依作業編號不同而做計算
# Modify.........: No:MOD-B80115 12/02/15 By bart DECLARE和FOREACH欄位順序有誤
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                        # Print condition RECORD
#             wc      VARCHAR(600),            # Where condition   #TQC-630166
              wc      STRING,               # Where condition   #TQC-630166
              a       LIKE type_file.chr1,  #No.FUN-680121 VARCHAR(1)#是否只列印已完工工單
              b       LIKE type_file.chr1,  #No.FUN-680121 VARCHAR(1)#是否只列印有差異料件
              more    LIKE type_file.chr1   #No.FUN-680121 VARCHAR(1)# 是否輸入其它特殊列印條件?
              END RECORD
DEFINE g_i            LIKE type_file.num5   #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE l_table        STRING                #No.FUN-760046
DEFINE g_str          STRING                #No.FUN-760046
DEFINE g_sql          STRING                #No.FUN-760046
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
# No.FUN-760046--begin
   LET g_sql = " sfb01.sfb_file.sfb01,",
               " sfb04.sfb_file.sfb04,",
               " sfb02.sfb_file.sfb02,",
               " sfb39.sfb_file.sfb39,",
               " sfb13.sfb_file.sfb13,",
               " sfb15.sfb_file.sfb15,",
               " sfb36.sfb_file.sfb36,",
               " sfb05.sfb_file.sfb05,",
               " sfb08.sfb_file.sfb08,",
               " sfa03.sfa_file.sfa03,",
               " sfa05.sfa_file.sfa05,",
               " sfa012.sfa_file.sfa012,",      #FUN-A60027
               " sfa013.sfa_file.sfa013,",      #FUN-A60027 
               " ima55.ima_file.ima55,",
               " ima02.ima_file.ima02,",
               " ima021.ima_file.ima021,",
               " exhaust.sfa_file.sfa04,",
               " l_ima02.ima_file.ima02,",
               " l_ima021.ima_file.ima021"
               
   LET l_table = cl_prt_temptable('asfr550',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"   #FUN-A60027 add 2?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN                                                                                                                  
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
   END IF   
# No.FUN-760046--end
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
  #LET tm.more  = ARG_VAL(8)  #TQC-610080 以下順序調整
   LET tm.a     = ARG_VAL(8)
   LET tm.b     = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL asfr550_tm(0,0)        # Input print condition
      ELSE CALL asfr550()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION asfr550_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680121 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(400)
 
   IF p_row = 0 THEN
      LET p_row = 4 LET p_col = 10
   END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 10
   END IF
   OPEN WINDOW asfr550_w AT p_row,p_col
        WITH FORM "asf/42f/asfr550"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.a       = 'Y'
   LET tm.b       = 'Y'
   LET tm.more    = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON sfb01,sfb05,sfb85
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
        ON ACTION CONTROLP    #FUN-4B0043
           IF INFIELD(sfb05) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ima"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO sfb05
              NEXT FIELD sfb05
           END IF
 
     ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
#No.FUN-760046 --begin
      ON ACTION CONTROLG
         CALL cl_cmdask() 
#No.FUN-760046 --end
 
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
      CLOSE WINDOW asfr550_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.a,tm.b,tm.more      # Condition
   INPUT BY NAME tm.a,tm.b,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF tm.a NOT MATCHES "[YN]" OR cl_null(tm.a)
            THEN NEXT FIELD a
         END IF
      AFTER FIELD b
         IF tm.b NOT MATCHES "[YN]" OR cl_null(tm.b)
            THEN NEXT FIELD b
         END IF
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
            THEN NEXT FIELD more
         END IF
         IF tm.more = "Y" THEN
                 CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
             CALL cl_cmdask()    # Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
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
      CLOSE WINDOW asfr550_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='asfr550'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asfr550','9031',1)
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
                        #" '",tm.more CLIPPED,"'",              #TQC-610080
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
         CALL cl_cmdat('asfr550',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW asfr550_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL asfr550()
   ERROR ""
END WHILE
CLOSE WINDOW asfr550_w
END FUNCTION
 
FUNCTION asfr550()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
#         l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT  #TQC-630166     #No.FUN-680121 VARCHAR(1000)
          l_sql     STRING,                       # RDSQL STATEMENT  #TQC-630166
#         exhaust   LIKE sfa_file.sfa04,          #No.FUN-680121 DECIMAL(12,3)
          l_exhaust LIKE sfa_file.sfa04,          #No.FUN-760046
          l_amt     LIKE sfa_file.sfa04,          #No.FUN-680121 DECIMAL(12,3)
          l_chr     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
          l_order   ARRAY[5] OF LIKE ima_file.ima34,        #No.FUN-680121 VARCHAR(10)
          l_ima02s  LIKE ima_file.ima02,          #No.FUN-760046
          l_ima021s LIKE ima_file.ima021,         #No.FUN-760046
          sr        RECORD
                       sfb01 LIKE sfb_file.sfb01,
                       sfb04 LIKE sfb_file.sfb04,
                       sfb02 LIKE sfb_file.sfb02,
                       sfb13 LIKE sfb_file.sfb13,
                       sfb15 LIKE sfb_file.sfb15,
                       sfb39 LIKE sfb_file.sfb39,
                       sfb36 LIKE sfb_file.sfb36,
                       sfb05 LIKE sfb_file.sfb05,
                       ima55 LIKE ima_file.ima55,
                       sfb08 LIKE sfb_file.sfb08,
                       sfa03 LIKE sfa_file.sfa03,
                       ima02 LIKE ima_file.ima02,
                       ima021 LIKE ima_file.ima021,
                       sfa05 LIKE sfa_file.sfa05,
                       sfa012 LIKE sfa_file.sfa012,    #FUN-A60027
                       sfa013 LIKE sfa_file.sfa013,    #FUN-A60027 
                       sfa08 LIKE sfa_file.sfa08       #MOD-A90155 add
                    END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file
               WHERE zo01 = g_rlang
               
# No.FUN-760046--begin
   CALL cl_del_data(l_table)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
# No.FUN-760046--end
 
     LET l_sql = "SELECT sfe06,sfe16 FROM sfe_file,sfa_file ", #bugno:6141 add sfa_file
                 " WHERE sfe01 = ? AND sfe07 = ? ",
                 "   AND sfe14 = ? ",            #MOD-A90155 add
                  "   AND sfe07 = sfa03",        #MOD-580185
                  "   AND sfe012 = ? AND sfe013 = ? ",     #FUN-A60027
                 "   AND sfe01 = sfa01 AND sfe14=sfa08"  #bugno:6141 add SQL
     PREPARE asfr550_pre1 FROM l_sql
     IF STATUS THEN CALL cl_err('',STATUS,0) RETURN END IF
     DECLARE asfr550_cur1 CURSOR FOR asfr550_pre1
     IF STATUS THEN CALL cl_err('',STATUS,0) RETURN END IF
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND sfbuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND sfbgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND sfbgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
     #End:FUN-980030
 
     IF tm.a = 'Y' THEN
         LET tm.wc = tm.wc clipped," AND sfb04='7' " CLIPPED
     END IF
     LET l_sql = "SELECT sfb01, sfb04, sfb02, sfb13, sfb15, sfb39, ",
                 " sfb36, sfb05, ima55, sfb08, sfa03, ima02, ima021, sfa05, sfa012, sfa013, sfa08 ",   #FUN-A60027 add sfa012,sfa013 #MOD-A90155 add sfa08
                 "  FROM sfa_file,sfb_file,OUTER(ima_file) ",
                 " WHERE sfa01 = sfb01",
                 "   AND  sfb_file.sfb05 = ima_file.ima01  AND sfb87!='X' ",
                 "   AND ",tm.wc CLIPPED," ORDER BY sfb01,sfa03"
     PREPARE asfr550_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM
     END IF
     DECLARE asfr550_curs1 CURSOR FOR asfr550_prepare1
 
#    CALL cl_outnam('asfr550') RETURNING l_name  #No.FUN-760046
#    START REPORT asfr550_rep TO l_name          #No.FUN-760046
 
     LET g_pageno = 0
     FOREACH asfr550_curs1 INTO sr.*
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       IF cl_null(sr.sfb08) THEN LET sr.sfb08 = 0 END IF
       IF cl_null(sr.sfa05) THEN LET sr.sfa05 = 0 END IF
 
#      CALL r550_amt(sr.sfb01,sr.sfa03,sr.sfb39) RETURNING exhaust     #No.FUN-760046
       CALL r550_amt(sr.sfb01,sr.sfa03,sr.sfb39,sr.sfa012,sr.sfa013,sr.sfa08) RETURNING l_exhaust   #No.FUN-760046   #FUN-A60027 add sfa012.sfa013 #MOD-A90155 add
       #差異數量計算
#      LET l_amt= exhaust-sr.sfa05    #No.FUN-760046
       LET l_amt= l_exhaust-sr.sfa05  #No.FUN-760046
       IF tm.b = 'Y' AND l_amt=0 THEN CONTINUE FOREACH END IF
# No.FUN-760046 --begin       
#      OUTPUT TO REPORT asfr550_rep(sr.*,exhaust)
 
       SELECT ima02,ima021 INTO l_ima02s,l_ima021s FROM ima_file
        WHERE ima01 = sr.sfa03
{       
       EXECUTE insert_prep USING
               sr.sfb01,sr.sfb04,sr.sfb02,sr.sfb39,sr.sfb13,sr.sfb15,
               sr.sfb36,sr.sfb05,sr.sfb08,sr.sfa03,sr.sfa05,sr.ima55,
               sr.ima02,sr.ima021,l_exhaust,l_ima02s,l_ima021s
}
       EXECUTE insert_prep USING                                                                                                     
              sr.sfb01,sr.sfb04,sr.sfb02,sr.sfb39,sr.sfb13,sr.sfb15,                                                       
              sr.sfb36,sr.sfb05,sr.sfb08,sr.sfa03,sr.sfa05,sr.sfa012,sr.sfa013,sr.ima55,    #FUN-A60027 add sfa012,sfa013
              sr.ima02,sr.ima021,l_exhaust,l_ima02s,l_ima021s
#No.FUN-760046 --end
               
     END FOREACH
 
#No.FUN-760046 --begin     
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
     IF g_zz05 = 'Y' THEN                                                                                                            
        CALL cl_wcchp(tm.wc,'sfb01,sfb05,sfb85')                                                                                           
             RETURNING tm.wc                                                                                                         
        LET g_str = tm.wc                                                                                                            
     END IF
    #CALL cl_prt_cs3('asfr550','asfr550',l_sql,g_str)        #FUN-A60027 mark
    #FUN-A60027 --------------------start------------------------- 
     IF g_sma.sma541 = 'Y' THEN
        CALL cl_prt_cs3('asfr550','asfr550_1',l_sql,g_str) 
     ELSE
        CALL cl_prt_cs3('asfr550','asfr550',l_sql,g_str) 
     END IF 
    #FUN-A60027 -------------------end------------------------------- 
#    FINISH REPORT asfr550_rep
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-760046 --end
 
END FUNCTION
 
#No.FUN-760046 --begin
{
REPORT asfr550_rep(sr,exhaust)
   DEFINE l_last_sw    LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          exhaust      LIKE sfa_file.sfa04,          #No.FUN-680121 DECIMAL(12,3)
          l_amt        LIKE sfa_file.sfa04,          #No.FUN-680121 DECIMAL(12,3)
          l_sfe06      LIKE sfe_file.sfe06,
          l_sfe16      LIKE sfe_file.sfe16,
          l_ima02      LIKE ima_file.ima02,
          l_ima021     LIKE ima_file.ima021,
          sr           RECORD
                       sfb01 LIKE sfb_file.sfb01,
                       sfb04 LIKE sfb_file.sfb04,
                       sfb02 LIKE sfb_file.sfb02,
                       sfb13 LIKE sfb_file.sfb13,
                       sfb15 LIKE sfb_file.sfb15,
                       sfb39 LIKE sfb_file.sfb39,
                       sfb36 LIKE sfb_file.sfb36,
                       sfb05 LIKE sfb_file.sfb05,
                       ima55 LIKE ima_file.ima55,
                       sfb08 LIKE sfb_file.sfb08,
                       sfa03 LIKE sfa_file.sfa03,
                       ima02 LIKE ima_file.ima02,
                       ima021 LIKE ima_file.ima021,
                       sfa05 LIKE sfa_file.sfa05
                       END RECORD
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.sfb01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED, pageno_total
      PRINT ''
 
#----------No.TQC-5B0107 begin #&051112
      PRINT COLUMN 01,g_x[09] CLIPPED,' ',sr.sfb01,
            COLUMN 53,g_x[10] CLIPPED,' ',sr.sfb04,
#NO.TQC-5B0125 START
            #COLUMN 68,g_x[11] CLIPPED,' ',sr.sfb02
            COLUMN 88,g_x[11] CLIPPED,' ',sr.sfb02,' ';
#NO.TQC-5B0125 END
       IF sr.sfb39 = "1"  THEN
         PRINT COLUMN 83,g_x[12] CLIPPED,' ',sr.sfb39,'/PUSH'
      ELSE
         IF sr.sfb39 = "2" THEN
            PRINT COLUMN 83,g_x[12] CLIPPED,' ',sr.sfb39,'/PULL'
         ELSE
            PRINT COLUMN 83,g_x[12] CLIPPED,' ',sr.sfb39
         END IF
      END IF
 
      PRINT COLUMN 01,g_x[13] CLIPPED,' ',sr.sfb13,
            COLUMN 53,g_x[14] CLIPPED,' ',sr.sfb15,
            COLUMN 88,g_x[15] CLIPPED,' ',sr.sfb36
      PRINT COLUMN 01,g_x[16] CLIPPED,' ',sr.sfb05 CLIPPED,
            COLUMN 53,g_x[20] CLIPPED,' ',sr.sfb08,
            COLUMN 88,g_x[19] CLIPPED,' ',sr.ima55
      PRINT COLUMN 01,g_x[17] CLIPPED,' ',sr.ima02 CLIPPED
      PRINT COLUMN 01,g_x[18] CLIPPED,' ',sr.ima021 CLIPPED
   #-------No.TQC-5B0107 end #&051112
      PRINT g_dash
      PRINT g_x[31],
            g_x[32],
            g_x[33],
            g_x[34],
            g_x[35],
            g_x[36],
            g_x[37]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.sfb01
     IF  (PAGENO > 1 OR LINENO > 9)
        THEN SKIP TO TOP OF PAGE
     END IF
 
   ON EVERY ROW
    #----No.MOD-5B0024 mark
    # IF cl_null(sr.sfa05) OR sr.sfa05=0 THEN     ##Modify By Jackson
    #    LET sr.sfa05=1
    # END IF
    #----No.MOD-5B0024 end
      LET l_ima02 = ''
      LET l_ima021= ''
      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
       WHERE ima01 = sr.sfa03
      PRINT COLUMN g_c[31],sr.sfa03,
            COLUMN g_c[32],l_ima02,
            COLUMN g_c[33],l_ima021,
           #COLUMN g_c[34],sr.sfa05 USING '-----------.###',   #No.MOD-5B0024 mark
           #COLUMN g_c[35],exhaust  USING '-----------.###',   #No.MOD-5B0024 mark
            COLUMN g_c[34],exhaust  USING '-----------.###',   #No.MOD-5B0024 add
            COLUMN g_c[35],sr.sfa05 USING '-----------.###',   #No.MOD-5B0024 add
            COLUMN g_c[36],exhaust-sr.sfa05 USING '-----------.###';
           #COLUMN g_c[37],(exhaust-sr.sfa05)/sr.sfa05 *100 USING '----.##'  #No.MOD-5B0024 mark
      #--------#No.MOD-5B0024 add
            IF cl_null(sr.sfa05) OR sr.sfa05=0 THEN
               PRINT COLUMN g_c[37],((exhaust-sr.sfa05) *100) USING '------------.##' #No.TQC-6A0087 add虛線長度
            ELSE
               PRINT COLUMN g_c[37],((exhaust-sr.sfa05)/sr.sfa05 *100) USING '------------.##' #No.TQC-6A0087 add虛線長度
            END IF
      #-----------No.MOD-5B0024 end
 
   ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'sfb01,sfb05,sfb85')
              RETURNING tm.wc
         PRINT g_dash
 
#TQC-630166-start
         CALL cl_prt_pos_wc(tm.wc) 
#        IF tm.wc[001,070] > ' ' THEN            # for 80
#             PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#        IF tm.wc[071,140] > ' ' THEN
#             PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#        IF tm.wc[141,210] > ' ' THEN
#             PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#        IF tm.wc[211,280] > ' ' THEN
#             PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#TQC-630166-end
      END IF
      PRINT g_dash
#     PRINT g_x[4] CLIPPED, COLUMN g_c[37], g_x[7] CLIPPED     #No.TQC-710016
      PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED     #No.TQC-710016
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash
#        PRINT g_x[4] CLIPPED, COLUMN g_c[37], g_x[6] CLIPPED     #No.TQC-710016
         PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED     #No.TQC-710016
      ELSE
         SKIP 2 LINE
      END IF
END REPORT
}
#No.FUN-760046 --end
 
FUNCTION r550_amt(p_sfb01,p_sfa03,p_sfb39,p_sfa012,p_sfa013,p_sfa08)        #FUN-A60027 add p_sfa012,p_sfa013 #MOD-A90155 add sfa08
#DEFINE  exhaust      LIKE sfa_file.sfa04,        #No.FUN-680121 DECIMAL(12,3)
 DEFINE  l_exhaust    LIKE sfa_file.sfa04,        #No.FUN-760046
         p_sfb01      LIKE sfb_file.sfb01,
         p_sfa03      LIKE sfa_file.sfa03,
         p_sfb39      LIKE sfb_file.sfb39,
         p_sfa012     LIKE sfa_file.sfa012,     #FUN-A60027
         p_sfa013     LIKE sfa_file.sfa013,     #FUN-A60027
         l_sfe06      LIKE sfe_file.sfe06,
         l_sfe16      LIKE sfe_file.sfe16,
         p_sfa08      LIKE sfa_file.sfa08       #MOD-A90155 add 
 
#   LET exhaust = 0   #No.FUN-760046
    LET l_exhaust = 0 #No.FUN-760046
   #FOREACH asfr550_cur1 USING p_sfb01,p_sfa03,p_sfa012,p_sfa013,p_sfa08  INTO l_sfe06,l_sfe16   #FUN-A60027 add sfa012,sfa013 #MOD-A90155 add sfa08 #MOD-B80115 mark
    FOREACH asfr550_cur1 USING p_sfb01,p_sfa03,p_sfa08,p_sfa012,p_sfa013  INTO l_sfe06,l_sfe16   #MOD-B80115 add
#No.FUN-760046 --begin 
#將exhaust變成l_exhaust
#      IF STATUS THEN LET exhaust = 0  RETURN exhaust END IF
       IF STATUS THEN LET l_exhaust = 0  RETURN l_exhaust END IF
            IF p_sfb39 = "1" THEN
               IF l_sfe06 MATCHES '[1235]' THEN
#                 LET exhaust = exhaust + l_sfe16
                  LET l_exhaust = l_exhaust + l_sfe16
               END IF
               IF l_sfe06 = "4" THEN
#                 LET exhaust = exhaust - l_sfe16
                  LET l_exhaust = l_exhaust - l_sfe16
               END IF
            END IF
            IF p_sfb39 = "2" THEN
               #-------No.MOD-6A0125 modify
               #IF l_sfe06 MATCHES '[6780]' THEN
               IF l_sfe06 MATCHES '[123]' THEN
#                 LET exhaust = exhaust + l_sfe16
                  LET l_exhaust = l_exhaust + l_sfe16
               END IF
               #IF l_sfe06 = "9" THEN
               IF l_sfe06 = "4" THEN
               #-------No.MOD-6A0125 end
#                 LET exhaust = exhaust - l_sfe16
                  LET l_exhaust = l_exhaust - l_sfe16
               END IF
            END IF
         END FOREACH
#  RETURN exhaust
   RETURN l_exhaust
END FUNCTION
