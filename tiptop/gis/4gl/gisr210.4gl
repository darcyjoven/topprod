# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: gisr210.4gl
# Descriptions...: 進項發票底稿匯出前檢核表
# Date & Author..: 02/04/05 By Danny
# Modify.........: No.FUN-510024 05/01/28 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-690009 06/09/04 By Dxfwo  欄位類型定義
 
# Modify.........: No.FUN-6A0098 06/10/26 By atsea l_time轉g_time
# Modify.........: No.FUN-750110 07/06/19 By dxfwo CR報表的制作 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80047 11/08/04 By fengrui  程式撰寫規範修正 
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000, #NO FUN-690009 VARCHAR(1000) # Where condition
              more    LIKE type_file.chr1     #NO FUN-690009 VARCHAR(1)    # Input more condition(Y/N)
              END RECORD
 
DEFINE   g_i          LIKE type_file.num5     #NO FUN-690009 SMALLINT   #count/index for any purpose
DEFINE   l_table     STRING                    #No.FUN-750110                                                                       
DEFINE   g_sql       STRING                    #No.FUN-750110                                                                       
DEFINE   g_str       STRING                    #No.FUN-750110  
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   #No.FUN-750110 --begin--  
   LET g_sql = "ise01.ise_file.ise01,",                                                                                             
               "ze03.ze_file.ze03"                                                                                                  
    LET l_table = cl_prt_temptable('gisr210',g_sql) CLIPPED                                                                         
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?)"                                                                                                       
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
   #No.FUN-750110 --end--  
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GIS")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80047--add--
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL gisr210_tm(0,0)        # Input print condition
      ELSE CALL gisr210()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80047--add--
END MAIN
 
FUNCTION gisr210_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01          #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,         #NO FUN-690009 SMALLINT
          l_cmd          LIKE type_file.chr1000       #NO FUN-690009 VARCHAR(400)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 5 LET p_col = 15
   END IF
   OPEN WINDOW gisr210_w AT p_row,p_col
        WITH FORM "gis/42f/gisr210"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ise01,ise03,ise04,ise062
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
      LET INT_FLAG = 0 CLOSE WINDOW gisr210_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80047--add--
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
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
      LET INT_FLAG = 0 CLOSE WINDOW gisr210_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80047--add--
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='gisr210'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('gisr210','9031',1)
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
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('gisr210',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW gisr210_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80047--add--
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL gisr210()
   ERROR ""
END WHILE
   CLOSE WINDOW gisr210_w
END FUNCTION
 
FUNCTION gisr210()
   DEFINE l_name    LIKE type_file.chr20,    #NO FUN-690009 VARCHAR(20)    # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0098
          l_sql     LIKE type_file.chr1000,  #NO FUN-690009 VARCHAR(1000)  # RDSQL STATEMENT
          l_za05    LIKE type_file.chr1000,  #NO FUN-690009 VARCHAR(40)
          l_str     LIKE type_file.chr1000,  #NO FUN-690009 VARCHAR(70)
          sr        RECORD LIKE ise_file.*
       CALL cl_del_data(l_table)  #No.FUN-750110
       #No.FUN-B80047--mark--Begin---
       # CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0098
       #No.FUN-B80047--mark--End-----
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND iseuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND isegrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND isegrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('iseuser', 'isegrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT * FROM ise_file ",
                 " WHERE ",tm.wc CLIPPED
 
     PREPARE gisr210_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80047--add--
        EXIT PROGRAM
     END IF
     DECLARE gisr210_curs1 CURSOR FOR gisr210_prepare1
 
#    CALL cl_outnam('gisr210') RETURNING l_name   #No.FUN-750110
#    START REPORT gisr210_rep TO l_name           #No.FUN-750110 
 
     LET g_pageno = 0
     FOREACH gisr210_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       LET l_str = ''
       #-->可抵扣專用發票(S)不可抵扣專用發票(N)
       IF sr.ise062 MATCHES '[SN]' THEN
          #-->發票類別(ise02)不可為空白
          IF cl_null(sr.ise02) THEN
          #  LET l_str = l_str CLIPPED,g_x[9] clipped,';' END IF #No.FUN-750110
             LET l_str = l_str CLIPPED,'1' END IF                #No.FUN-750110 
          #-->入庫日期(ise09)不可為空白
          IF cl_null(sr.ise09) THEN
          #  LET l_str = l_str CLIPPED,g_x[10] clipped,';'END IF #No.FUN-750110
             LET l_str = l_str CLIPPED,'2' END IF                #No.FUN-750110 
          #-->憑證序號(ise10)不可為空白
          IF cl_null(sr.ise10) THEN
          #  LET l_str = l_str CLIPPED,g_x[11] clipped,';'END IF #No.FUN-750110
             LET l_str = l_str CLIPPED,'3' END IF                #No.FUN-750110 
          #-->付款單號不可為空白
          IF cl_null(sr.ise11) THEN
          #  LET l_str = l_str CLIPPED,g_x[14] clipped,';'END IF #No.FUN-750110
             LET l_str = l_str CLIPPED,'4' END IF                #No.FUN-750110 
          #-->付款日期(ise12)不可為空白
          IF cl_null(sr.ise12) THEN
          #  LET l_str = l_str CLIPPED,g_x[12] clipped,';'END IF #No.FUN-750110 
             LET l_str = l_str CLIPPED,'5' END IF                #No.FUN-750110 
          #-->付款金額(ise13)不可為空白
          IF cl_null(sr.ise13) THEN
          #  LET l_str = l_str CLIPPED,g_x[13] clipped,';'END IF #No.FUN-750110
             LET l_str = l_str CLIPPED,'6' END IF                #No.FUN-750110  
       END IF
       #-->海關代徵完稅憑證(G)
       IF sr.ise062 = 'G' THEN
          #-->憑證序號(ise10)不可為空白
          IF cl_null(sr.ise10) THEN
#            LET l_str = l_str CLIPPED,g_x[11] clipped,';'END IF #No.FUN-750110
             LET l_str = l_str CLIPPED,'3' END IF                #No.FUN-750110 
          #-->數量(ise15)不可為空白
          IF cl_null(sr.ise15) THEN
#            LET l_str = l_str CLIPPED,g_x[15] clipped,';'END IF #No.FUN-750110
             LET l_str = l_str CLIPPED,'7' END IF                #No.FUN-750110
          #-->單位(ise16)不可為空白
          IF cl_null(sr.ise16) THEN
#            LET l_str = l_str CLIPPED,g_x[16] clipped,';'END IF #No.FUN-750110
             LET l_str = l_str CLIPPED,'8' END IF                #No.FUN-750110
       END IF
       IF NOT cl_null(l_str) THEN
#         OUTPUT TO REPORT gisr210_rep(sr.*,l_str)    #No.FUN-750110
          EXECUTE insert_prep USING sr.ise01,l_str    #No.FUN-750110 
       END IF
     END FOREACH
 
#    FINISH REPORT gisr210_rep             #No.FUN-750110
#No.FUN-750110--------begin--------  
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                  
     CALL cl_wcchp(tm.wc,'ise01,ise03,ise04,ise062')                                                                                       
          RETURNING tm.wc                                                                                                           
     LET g_str = tm.wc                                                                                                              
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                                             
     CALL cl_prt_cs3('gisr210','gisr210',l_sql,g_str)
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-750110--------end--------  
     #No.FUN-BB0047--mark--Begin---
     #  CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0098
     #No.FUN-BB0047--mark--End-----
END FUNCTION
{                                #No.FUN-750110
REPORT gisr210_rep(sr)
  DEFINE  l_last_sw LIKE type_file.chr1,         #NO FUN-690009 VARCHAR(1)
          sr        RECORD
                    ise    RECORD LIKE ise_file.*,
                    str    LIKE type_file.chr1000 #NO FUN-690009 VARCHAR(70)
                    END RECORD
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.ise.ise01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      PRINT COLUMN g_c[31],sr.ise.ise01,
            COLUMN g_c[32],sr.str
 
   ON LAST ROW
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT  }     #No.FUN-750110
