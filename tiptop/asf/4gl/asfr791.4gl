# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: asfr791.4gl
# Desc/riptions..: 下線入庫單
# Date & Author..: 00/11/27 By Wiky
# Modify.........: NO.FUN-550067 05/05/31 By day   單據編號加大
# Modify.........: No.FUN-570240 05/07/26 By Trisy 料件編號開窗
# Modify.........: No.FUN-580014 05/08/18 By jackie  轉xml
# Modify.........: NO.FUN-5B0015 05/11/02 BY yiting 將料號/品名/規格 欄位設成[1,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.FUN-5A0061 05/11/21 By Pengu 報表缺規格
# Modify.........: NO.FUN-590118 06/01/13 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-680121 06/08/31 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.TQC-6A0087 06/11/09 By king 改正報表中有關錯誤
# Modify.........: No.TQC-750041 07/05/11 By johnray 5.0版更，報表修改
# Modify.........: No.TQC-770004 07/07/03 By mike 幫組按鈕灰色
# Modify.........: No.FUN-760085 07/07/23 By sherry 報表改由Crystal Report輸出                                                     
# Modify.........: No.MOD-7A0016 07/10/04 By Sarah 改寫成CR時，漏了將當站下線資料(shd_file)寫入暫存檔
    
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A70095 11/06/14 By lixh1 撈取報工單(shb_file)的所有處理作業,必須過濾是已確認的單據
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                               # Print condition RECORD
                wc        LIKE type_file.chr1000,         #No.FUN-680121 VARCHAR(600)# Where condition
                 s        LIKE type_file.chr3,            #No.FUN-680121 VARCHAR(3)# Order by sequence
                 t        LIKE type_file.chr3,            #No.FUN-680121 VARCHAR(3)
                 u        LIKE type_file.chr3,            #No.FUN-680121 VARCHAR(3)
#                mtext    VARCHAR(10),    #申請單號
                 mtext    LIKE oea_file.oea01,          #No.FUN-680121 VARCHAR(16)#No.FUN-550067
                 c        LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)# Input more condition(Y/N)
              END RECORD
#No.FUN-550067 --start--
DEFINE g_orderA ARRAY[3] OF LIKE oea_file.oea01,        #No.FUN-680121 VARCHAR(16)
       g_mtext LIKE oea_file.oea01                      #No.FUN-680121 VARCHAR(16)
#No.FUN-550067 --end--
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
#FUN-760085--start                                                                                                                  
   DEFINE  l_table    STRING                                                                                                        
   DEFINE  l_sql      STRING                                                                                                        
   DEFINE  g_sql      STRING                                                                                                        
   DEFINE  g_str      STRING                                                                                                        
#FUN-760085--end      
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                           # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123 #FUN-BB0047 mark
#No.FUN-760085---Begin
   LET g_sql = "shbgrup.shb_file.shbgrup,",
               "shbuser.shb_file.shbuser,",
               "oea01.oea_file.oea01,",
               "shb05.shb_file.shb05,",
               "shb10.shb_file.shb10,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "ima55.ima_file.ima55,",
               "shb06.shb_file.shb06,",
               "shb081.shb_file.shb081,",
               "shb01.shb_file.shb01,",
               "shd02.shd_file.shd02,",
               "shd06.shd_file.shd06,",
               "shd03.shd_file.shd03,",
               "shd04.shd_file.shd04,",
               "shd05.shd_file.shd05,",
               "shd07.shd_file.shd07,"           
 
   LET l_table = cl_prt_temptable('asfr719',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "                                                                                                  
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
#No.FUN-760085---End     
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET g_pdate = ARG_VAL(1)                  # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'    # If background job sw is off
      THEN CALL r791_tm(0,0)            # Input print condition
      ELSE CALL asfr791()               # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION r791_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col   LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_cmd         LIKE type_file.chr1000        #No.FUN-680121 VARCHAR(400)
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 10 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 10
   END IF
   OPEN WINDOW r791_w AT p_row,p_col
        WITH FORM "asf/42f/asfr791"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.s    = '123'
   LET tm.t    = ''
   LET tm.u    = ''
   LET tm.mtext = ''
   LET tm.c    = 'Y'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
 
   CONSTRUCT BY NAME tm.wc ON shb05,shb081,shb03,shb10
#No.FUN-570240 --start--
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION controlp
            IF INFIELD(shb10) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO shb10
               NEXT FIELD shb10
            END IF
#No.FUN-570240 --end--
     ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
    ON ACTION help                                        #No.TQC-770004                                                                           
         #CALL cl_dynamic_locale()                        #No.TQC-770004                                                                              
          CALL cl_show_help()                   #No.FUN-550037 hmf                    #No.TQC-770004                                              
         LET g_action_choice = "help"                               #No.TQC-770004                                                                  
         CONTINUE CONSTRUCT                          #No.TQC-770004
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r791_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
         
   END IF
   IF tm.wc='1=1' THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.mtext # Condition
   INPUT BY NAME tm.mtext
                WITHOUT DEFAULTS
################################################################################
# START genero shell script ADD
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()        # Command execution
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
        ON ACTION help                                        #No.TQC-770004                                                            
         #CALL cl_dynamic_locale()                        #No.TQC-770004                                                            
          CALL cl_show_help()                   #No.FUN-550037 hmf                    #No.TQC-770004                                
         LET g_action_choice = "help"                               #No.TQC-770004                                                  
         CONTINUE INPUT                          #No.TQC-770004                 
   END INPUT
   LET g_mtext = tm.mtext
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r791_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
             WHERE zz01='asfr791'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asfr791','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,             #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('asfr791',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r791_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL asfr791()
END WHILE
   CLOSE WINDOW r791_w
END FUNCTION
 
FUNCTION asfr791()
DEFINE l_name        LIKE type_file.chr20,              #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time        LIKE type_file.chr8            #No.FUN-6A0090
       l_sql         LIKE type_file.chr1000,            # RDSQL STATEMENT        #No.FUN-680121 VARCHAR(1100)
       l_sql1        LIKE type_file.chr1000,            # RDSQL STATEMENT        #No.FUN-680121 VARCHAR(1100)
       l_za05        LIKE type_file.chr1000,            #No.FUN-680121 VARCHAR(40)
#       l_order       ARRAY[6] OF VARCHAR(10),
       l_order       ARRAY[6] OF LIKE type_file.chr20,           #No.FUN-680121 VARCHAR(20)#No.FUN-550067
       sr            RECORD order1 LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)
                            order2 LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)
                            order3 LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)
                            shb05  LIKE shb_file.shb05,
                            shb10  LIKE shb_file.shb10,
                            ima02  LIKE ima_file.ima02,
                            ima021 LIKE ima_file.ima021,     #No.FUN-5A0061 add
                            ima55  LIKE ima_file.ima55,
                            shb06  LIKE shb_file.shb06,
                            shb081 LIKE shb_file.shb081,
                            shb01  LIKE shb_file.shb01,
                            shb03  LIKE shb_file.shb03,
                            shb114 LIKE shb_file.shb114
                     END RECORD,
       sr1           RECORD shd01 LIKE shd_file.shd01,
                            shd02 LIKE shd_file.shd02,
                            shd06 LIKE shd_file.shd06,
                            shd03 LIKE shd_file.shd03,
                            shd04 LIKE shd_file.shd04,
                            shd05 LIKE shd_file.shd05,
                            shd07 LIKE shd_file.shd07
                     END RECORD
 
   CALL cl_del_data(l_table)
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #MOD-7A0016 add
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND shbuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND shbgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND shbgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('shbuser', 'shbgrup')
   #End:FUN-980030
 
   LET l_sql1 ="SELECT shd01,shd02,shd06,shd03,shd04,shd05,shd07",
               "  FROM shd_file, shb_file",
               " WHERE shd01 = shb01 ",
               "   AND shbconf = 'Y' ",   #FUN-A70095
               "   AND shd01 = ? ",
               "   AND shb06 = ? ",
               "   AND shb081= ? ",
               "   AND shb05 = ?"
   PREPARE r791_prep2 FROM l_sql1
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prep2:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   DECLARE r791_curs2 CURSOR FOR r791_prep2
 
   LET l_sql = "SELECT '','','',shb05,shb10,ima02,ima021,ima55,",
               "       shb06,shb081,shb01",    #No.FUN-5A0061 add ima021
               "  FROM shb_file ,OUTER ima_file",
               " WHERE shb_file.shb10 = ima_file.ima01 ",
               "   AND shbconf = 'Y' ",  #FUN-A70095
               "   AND shb114 > 0 AND ",tm.wc CLIPPED
   PREPARE r791_prep1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prep1:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   DECLARE r791_curs1 CURSOR FOR r791_prep1
 
#No.FUN-760085---Begin
#   CALL cl_outnam('asfr791') RETURNING l_name
#   START REPORT r791_rep TO l_name
#   LET g_pageno = 0
#No.FUN-760085---End
 
   FOREACH r791_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
#No.FUN-760085---Begin
#      OUTPUT TO REPORT r791_rep(sr.*)
      
      FOREACH r791_curs2 USING sr.shb01,sr.shb06,sr.shb081,sr.shb05 INTO sr1.*   #MOD-7A0016 add
         EXECUTE insert_prep USING 
            g_grup,g_user,g_mtext,sr.shb05,sr.shb10,
            sr.ima02,sr.ima021,sr.ima55,sr.shb06,
            sr.shb081,sr.shb01,sr1.shd02,sr1.shd06,  
            sr1.shd03,sr1.shd04,sr1.shd05,sr1.shd07 
      END FOREACH                                                                #MOD-7A0016 add
      
#No.FUN-760085---End
   END FOREACH
#No.FUN-760085---Begin 
#    FINISH REPORT r791_rep
 
   IF g_zz05 = 'Y' THEN                                                                                                            
      CALL cl_wcchp(tm.wc,'shb05,shb081,shb03,shb10')                                                                                      
           RETURNING tm.wc                                                                                                          
      LET g_str = tm.wc                                                                                                             
   END IF                                                                                                                          
   LET g_str = tm.wc                                                                                                                
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                                              
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   CALL cl_prt_cs3('asfr791','asfr791',l_sql,g_str)
#No.FUN-760085---End              
END FUNCTION
 
#No.FUN-760085---Begin
{
REPORT r791_rep(sr)
   DEFINE l_last_sw     LIKE type_file.chr1,                        #No.FUN-680121 VARCHAR(1)
          sr            RECORD order1 LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)
                               order2 LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)
                               order3 LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)
                               shb05  LIKE shb_file.shb05,
                               shb10  LIKE shb_file.shb10,
                               ima02  LIKE ima_file.ima02,
                               ima021 LIKE ima_file.ima021,     #No.FUN-5A0061 add
                               ima55  LIKE ima_file.ima55,
                               shb06  LIKE shb_file.shb06,
                               shb081 LIKE shb_file.shb081,
                               shb01  LIKE shb_file.shb01,
                               shb03  LIKE shb_file.shb03,
                               shb114 LIKE shb_file.shb114
                        END RECORD,
           sr1          RECORD shd01 LIKE shd_file.shd01,
                               shd02 LIKE shd_file.shd02,
                               shd06 LIKE shd_file.shd06,
                               shd03 LIKE shd_file.shd03,
                               shd04 LIKE shd_file.shd04,
                               shd05 LIKE shd_file.shd05,
                               shd07 LIKE shd_file.shd07
                        END RECORD,
   l_flag  LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
   l_sql   LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(600)
   l_amt_1 LIKE bed_file.bed07,          #No.FUN-680121 DECIMAL(12,3)
   l_amt_2 LIKE bed_file.bed07,          #No.FUN-680121 DECIMAL(12,3)
   l_amt_3 LIKE bed_file.bed07,          #No.FUN-680121 DECIMAL(12,3)
   l_amt_5 LIKE bed_file.bed07           #No.FUN-680121 DECIMAL(12,3)
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.shb05,sr.shb10,sr.shb081,sr.shb01
 
  FORMAT
   PAGE HEADER
#No.FUN-580014 --start--
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED #No.TQC-6A0087
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED, pageno_total
      PRINT g_x[30] CLIPPED,g_grup,'/',g_user ,
             COLUMN g_len-30,g_x[31] CLIPPED,g_mtext  #No.TQC-6A0087
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'n'
 
#No.FUN-550067-begin
   BEFORE GROUP OF sr.shb05
      SKIP TO TOP OF PAGE
#     PRINT g_x[11] CLIPPED,COLUMN 34, g_x[12] CLIPPED,COLUMN 71,g_x[13] CLIPPED
#     PRINT g_x[15] CLIPPED,COLUMN 34, g_x[16] CLIPPED,COLUMN 71,g_x[29] CLIPPED
      PRINTX name=H1 g_x[32],g_x[33],g_x[34],g_x[45],g_x[35],
                     g_x[36],g_x[37],g_x[38],g_x[39],   #No.FUN-5A0061 add
                     g_x[40],g_x[41],g_x[42],g_x[43],g_x[44]
      PRINT g_dash1
      PRINTX name=D1
             COLUMN g_c[32],sr.shb05 CLIPPED,
            #COLUMN g_c[33],sr.shb10[1,20] CLIPPED,
             COLUMN g_c[33],sr.shb10 CLIPPED,  #NO.FUN-5B0015
             COLUMN g_c[34],sr.ima02 CLIPPED,
             COLUMN g_c[45],sr.ima021 CLIPPED,   #No.FUN-5A0061 add
             COLUMN g_c[35],sr.ima55 CLIPPED,
             COLUMN g_c[36],sr.shb06 CLIPPED USING '###&',  #FUN-590118
             COLUMN g_c[37],sr.shb081 CLIPPED USING '########';
 
   BEFORE GROUP OF sr.shb01
      PRINTX name=D1 COLUMN g_c[38],sr.shb01 CLIPPED;
 
   AFTER GROUP OF sr.shb01
      FOREACH r791_curs2 USING sr.shb01,sr.shb06,sr.shb081,sr.shb05 INTO sr1.*
         PRINTX name=D1
                COLUMN g_c[39],sr1.shd02 USING '#####' CLIPPED,
                COLUMN g_c[40],sr1.shd06[1,20] CLIPPED,
                COLUMN g_c[41],sr1.shd03 CLIPPED,
                COLUMN g_c[42],sr1.shd04 CLIPPED,
                COLUMN g_c[43],sr1.shd05 CLIPPED,
                COLUMN g_c[44],sr1.shd07 CLIPPED USING '########.###'
      END FOREACH
#No.FUN-580014 --end--
#No.FUN-550067-end
     #PRINT
     #PRINT g_dash2[1,g_len]
      CLOSE r791_curs2
 
   ON LAST ROW
      PRINT ''
      LET l_last_sw = 'y'
      PRINT g_dash[1,g_len]
      PRINT g_x[4] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
 
   PAGE TRAILER
      PRINT
      IF l_last_sw = 'n' THEN
         PRINT g_dash[1,g_len]
         PRINT g_x[4] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED    #No.TQC-750041
      ELSE 
         SKIP 2 LINES
      END IF
END REPORT}
#No.FUN-760085---End
#Patch....NO.TQC-610037 <> #
