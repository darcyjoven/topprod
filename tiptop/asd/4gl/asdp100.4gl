# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: asdp100.4gl
# Descriptions...: 直接人工、間接製費分攤率整批修改作業
# Date & Author..: 96/06/27 By Danny
# Modify.........: No.FUN-510037 05/02/23 By pengu 報表轉XML
# Modify.........: No.MOD-530850 05/03/31 By Will 增加料件的開窗
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify ........: No.FUN-570150 06/03/13 By yiting 批次背景執行
# Modify.........: No.FUN-690010 06/09/05 By zdyllq 類型轉換 
 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管 
# Modify.........: No.FUN-AB0025 10/11/10 By vealxu FUNCTION p100_tm()中 tm.wc 加上企業料號條件 
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE   tm       RECORD
                   wc     LIKE type_file.chr1000,      #No.FUN-690010CHAR(300),
                  a      LIKE type_file.chr1,         #No.FUN-690010CHAR(01),              
                  b      LIKE type_file.chr1,         #No.FUN-690010CHAR(01),
                  c      LIKE type_file.chr1,         #No.FUN-690010CHAR(01),
                  sta03  LIKE sta_file.sta03,    #標準工時
                  sta05  LIKE sta_file.sta05,    #直接人工分攤率
                  sta06  LIKE sta_file.sta06     #間接製造費用分攤率
                  END RECORD,
          g_sql    string    #No.FUN-580092 HCN
 
DEFINE g_before_input_done LIKE type_file.num5    #No.FUN-690010 SMALLINT
DEFINE ls_date         STRING,                  #No.FUN-570150
       g_change_lang   LIKE type_file.chr1         #No.FUN-690010CHAR(01)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   g_flag          LIKE type_file.chr1     #No.FUN-690010 VARCHAR(1)
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0089
   DEFINE l_sl		LIKE type_file.num5         #No.FUN-690010SMALLINT
   DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   #-->No.FUN-570150 --start
    INITIALIZE g_bgjob_msgfile TO NULL
    LET tm.wc    = ARG_VAL(1)                         #QBE條件
    LET tm.a     = ARG_VAL(2)                         #
    LET tm.b     = ARG_VAL(3)                         #
    LET tm.c     = ARG_VAL(4)                         #
    LET tm.sta03 = ARG_VAL(5)                         #標準工時
    LET tm.sta05 = ARG_VAL(6)                         #直接人工分攤率
    LET tm.sta06 = ARG_VAL(7)                         #間接製造費用分攤率
    LET g_bgjob = ARG_VAL(8)
    IF cl_null(g_bgjob) THEN
       LET g_bgjob = 'N'
    END IF
   #--- No.FUN-570150 --end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASD")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
         RETURNING g_time    #No.FUN-6A0089
 
#NO.FUN-570150 mark--
#    LET p_row = 4 LET p_col = 20
 
#    OPEN WINDOW p100_w AT p_row,p_col WITH FORM "asd/42f/asdp100" 
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
#    CALL cl_ui_init()
 
#    CALL p100_tm()
#    CLOSE WINDOW p100_w
#NO.FUN-570150 mark--
 
#NO.FUN-570150 start--
   WHILE TRUE
     IF g_bgjob = 'N' THEN
        CALL p100_tm()
        LET g_success = 'Y'
        IF cl_sure(21,21) THEN
           CALL cl_wait()
           CALL p100_process()
           IF g_success = 'Y' THEN
              CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
           ELSE
               CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
           END IF
           IF g_flag THEN
              CONTINUE WHILE
           ELSE
              CLOSE WINDOW p100_w
              EXIT WHILE
           END IF
        END IF
     ELSE
        LET g_success = 'Y'
        CALL p100_process()
        CALL cl_batch_bg_javamail(g_success)
        EXIT WHILE
     END IF
   END WHILE
#--- No.FUN-570150 --end---
   CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
         RETURNING g_time    #No.FUN-6A0089
END MAIN
 
FUNCTION p100_tm()
#-->No.FUN-570150 --start--
DEFINE lc_cmd        LIKE type_file.chr1000       #No.FUN-690010CHAR(500)
DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-690010 SMALLINT
    LET p_row = 4 LET p_col = 20
 
    OPEN WINDOW p100_w AT p_row,p_col WITH FORM "asd/42f/asdp100"
      ATTRIBUTE (STYLE = g_win_style)
 
    CALL cl_ui_init()
#--- No.FUN-570150 --end---
 
   WHILE TRUE
      CLEAR FORM
      CALL cl_opmsg('z')
      INITIALIZE tm.* TO NULL
      CONSTRUCT BY NAME tm.wc ON ima01,ima11,ima12,ima08  
 
      #MOD-530850                                                                
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION CONTROLP                                                         
        CASE                                                                    
          WHEN INFIELD(ima01)
#FUN-AA0059---------mod------------str-----------------                                                             
#            CALL cl_init_qry_var()                                              
#            LET g_qryparam.form = "q_ima"                                       
#            LET g_qryparam.state = "c"                                          
#            CALL cl_create_qry() RETURNING g_qryparam.multiret 
             CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------                 
            DISPLAY g_qryparam.multiret TO ima01                                
            NEXT FIELD ima01                                                    
         OTHERWISE                                                              
            EXIT CASE                                                           
       END CASE                                                                 
    #--
 
     ON ACTION locale                    #genero
#NO.FUN-570150 MARK
#        LET g_action_choice = "locale"
#        CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#NO.FUN-570150 MARK
        LET g_change_lang = TRUE                    #No.FUN-570150
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
 
 
     ON ACTION exit              #加離開功能genero
        LET INT_FLAG = 1
        EXIT CONSTRUCT
      
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
 
#NO.FUN-570150  START--
#      IF g_action_choice = "locale" THEN  #genero
#         LET g_action_choice = ""
#         CALL cl_dynamic_locale()
#         CONTINUE WHILE
#      END IF
 
#      IF INT_FLAG THEN
#         LET INT_FLAG = 0 RETURN
#      END IF
       IF g_change_lang THEN
          LET g_change_lang = FALSE
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          CONTINUE WHILE
       END IF
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          CLOSE WINDOW p100_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
          EXIT PROGRAM
       END IF
#NO.FUN-570150 end----
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE 
      END IF
      LET tm.wc = tm.wc CLIPPED," AND (ima120='1' OR ima120=' ' OR ima120 IS NULL) "  #FUN-AB0025 add
      LET tm.a = 'N'
      LET tm.b = 'N'
      LET tm.c = 'N'
      LET g_bgjob = 'N'      #No.FUN-570150
 
      #INPUT BY NAME tm.a,tm.sta05,tm.b,tm.sta06,tm.c,tm.sta03 WITHOUT DEFAULTS
      INPUT BY NAME tm.a,tm.sta05,tm.b,tm.sta06,tm.c,tm.sta03,g_bgjob WITHOUT DEFAULTS  #NO.FUN-570150 
 
         BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL p100_set_entry()
           CALL p100_set_no_entry()
           LET g_before_input_done = TRUE
 
         BEFORE FIELD a
           CALL p100_set_entry()
 
         AFTER FIELD a
            IF cl_null(tm.a) OR tm.a NOT MATCHES '[YN]' THEN
               NEXT FIELD a
            END IF
            CALL p100_set_no_entry()
 
         BEFORE FIELD b 
           CALL p100_set_entry()
 
         AFTER FIELD b
            IF cl_null(tm.b) OR tm.b NOT MATCHES '[YN]' THEN
               NEXT FIELD b
            END IF
            CALL p100_set_no_entry()
 
         BEFORE FIELD c 
           CALL p100_set_entry()
 
         AFTER FIELD c
            IF cl_null(tm.c) OR tm.c NOT MATCHES '[YN]' THEN
               NEXT FIELD c
            END IF
            CALL p100_set_no_entry()
 
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
 
        ON ACTION locale
           LET g_change_lang = TRUE
           EXIT INPUT
       #---No.FUN-570150 --end--
 
         ON ACTION exit  #加離開功能genero
            LET INT_FLAG = 1
            EXIT INPUT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
#NO.FUN-570150 start--
#      IF INT_FLAG THEN 
#         LET INT_FLAG=0 RETURN 
#      END IF
       IF g_change_lang THEN
          LET g_change_lang = FALSE
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          CLOSE WINDOW p100_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
          EXIT PROGRAM
       END IF
#NO.FUN-570150 end--
   IF g_bgjob = 'N' AND   #NO.FUN-570150 
   tm.a = 'N' AND tm.b = 'N' AND tm.c = 'N' THEN 
      RETURN 
   END IF 
 
#NO.FUN-570150 mark--
#   IF cl_sure(21,21) THEN
#      CALL cl_wait()
#      CALL p100_process()
#      IF g_success = 'Y' THEN
#           CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
#        ELSE
#           CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
#        END IF
#        IF g_flag THEN
#           CONTINUE WHILE
#        ELSE
#           EXIT WHILE
#        END IF
#   END IF
#   END WHILE
#   ERROR ''
#NO.FUN-570150 MARK--
 
#NO.FUN-570150  start--
       IF g_bgjob = "Y" THEN
          SELECT zz08 INTO lc_cmd FROM zz_file
           WHERE zz01 = "asdp100"
          IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('asdp100','9031',1)   
            
          ELSE
             LET tm.wc = cl_replace_str(tm.wc,"'","\"")
             LET lc_cmd = lc_cmd CLIPPED,
                          " '",tm.wc CLIPPED,"'",
                          " '",tm.a CLIPPED,"'",
                          " '",tm.b CLIPPED,"'",
                          " '",tm.c CLIPPED,"'",
                          " '",tm.sta03 CLIPPED,"'",
                          " '",tm.sta05 CLIPPED,"'",
                          " '",tm.sta06 CLIPPED,"'",
                          " '",g_bgjob CLIPPED,"'"
             CALL cl_cmdat('asdp100',g_time,lc_cmd CLIPPED)
          END IF
          CLOSE WINDOW p100_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
          EXIT PROGRAM
       END IF
       EXIT WHILE
#-- No.FUN-570150 --end---
   END WHILE
   ERROR ''
END FUNCTION
 
FUNCTION p100_set_entry()
 DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF INFIELD(a) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("sta05",TRUE)
   END IF
   IF INFIELD(b) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("sta06",TRUE)
   END IF
   IF INFIELD(c) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("sta03",TRUE)
   END IF
END FUNCTION
FUNCTION p100_set_no_entry()
 
    IF INFIELD(a) OR (NOT g_before_input_done) THEN
        IF tm.a='N' THEN
           CALL cl_set_comp_entry("sta05",FALSE)
        END IF
    END IF
    IF INFIELD(b) OR (NOT g_before_input_done) THEN
        IF tm.b='N' THEN
           CALL cl_set_comp_entry("sta06",FALSE)
        END IF
    END IF
    IF INFIELD(c) OR (NOT g_before_input_done) THEN
        IF tm.c='N' THEN
           CALL cl_set_comp_entry("sta03",FALSE)
        END IF
    END IF
END FUNCTION
 
 
FUNCTION p100_process()
  DEFINE  l_ima01    LIKE ima_file.ima01
  DEFINE  l_name        LIKE type_file.chr20   #No.FUN-690010 VARCHAR(20)
  LET g_sql ="SELECT ima01 FROM ima_file LEFT OUTER JOIN sta_file ON ima_file.ima01=sta_file.sta01  ",
             " WHERE ",tm.wc CLIPPED," AND ima08 IN ('M','P','S','m','p','s') ",
             "  ORDER BY ima01 " 
  PREPARE p100_pre FROM g_sql
  IF STATUS THEN 
  CALL cl_err('p100_pre',STATUS,1)
   
  RETURN END IF
  DECLARE p100_curs CURSOR WITH HOLD FOR p100_pre
 
  LET g_pdate = g_today
  LET g_rlang = g_lang
  LET g_copies= '1'
  SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
  CALL cl_outnam('asdp100') RETURNING l_name
  START REPORT asdp100_rep TO l_name
  LET g_pageno = 0
  BEGIN WORK   #NO.FUN-570150 
  LET g_success='Y'
  FOREACH p100_curs INTO l_ima01 
     IF STATUS THEN CALL cl_err('p100_pre',STATUS,1) RETURN END IF
     IF tm.a = 'Y' THEN 
        UPDATE sta_file SET sta05 = tm.sta05 WHERE sta01 = l_ima01
        IF STATUS OR SQLCA.SQLERRD[3]=0 THEN 
           ROLLBACK WORK
           LET g_success='N'
           OUTPUT TO REPORT asdp100_rep(l_ima01)
           CONTINUE FOREACH 
        END IF
     END IF
     IF tm.b = 'Y' THEN 
        UPDATE sta_file SET sta06 = tm.sta06 WHERE sta01 = l_ima01
        IF STATUS OR SQLCA.SQLERRD[3]=0 THEN 
           ROLLBACK WORK
           LET g_success='N'
           OUTPUT TO REPORT asdp100_rep(l_ima01)
           CONTINUE FOREACH 
        END IF
     END IF
     IF tm.c = 'Y' THEN 
        UPDATE sta_file SET sta03 = tm.sta03 WHERE sta01 = l_ima01
        IF STATUS OR SQLCA.SQLERRD[3]=0 THEN 
           ROLLBACK WORK
           LET g_success='N'
           OUTPUT TO REPORT asdp100_rep(l_ima01)
           CONTINUE FOREACH 
        END IF
     END IF
     COMMIT WORK 
  END FOREACH      
  FINISH REPORT asdp100_rep
  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 # CALL cl_prt('asdp100.out',g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT asdp100_rep(sr)
   DEFINE l_last_sw LIKE type_file.chr1,         #No.FUN-690010CHAR(1),
          sr        RECORD 
                    ima01   LIKE ima_file.ima01
                    END RECORD,
          l_ima02   LIKE ima_file.ima02
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line   #No.MOD-580242
 
  ORDER BY sr.ima01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT g_dash[1,g_len]
      PRINT g_x[31] clipped,g_x[32] clipped 
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01 = sr.ima01
      IF STATUS THEN LET l_ima02 = '' END IF
      PRINT COLUMN g_c[31],sr.ima01,
            COLUMN g_c[32],l_ima02
 
   ON LAST ROW
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
