# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: armp100.4gl
# Descriptions...: 新舊S/N轉檔作業
# Date & Author..: 
# Modify.........: MOD-490222 04/09/13 By Smapmin 列印資料表頭
# Modify.........: No.FUN-580098 05/10/26 By CoCo BOTTOM MARGIN g_bottom_margin改5
# Modify.........: FUN-570149 06/03/13 BY yiting 背景作業
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
 
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD            
           bdate   LIKE type_file.dat,    #No.FUN-690010 DATE,
           edate   LIKE type_file.dat     #No.FUN-690010 DATE
           END RECORD
 
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   l_flag          LIKE type_file.chr1           #No.FUN-570149  #No.FUN-690010 VARCHAR(1)
DEFINE   g_change_lang   LIKE type_file.chr1           # Prog. Version..: '5.30.06-13.03.12(01)        #No.FUN-570149
DEFINE   ls_date         STRING          #No.FUN-570149
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8        #No.FUN-6A0085
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT   
 
#FUN-570149 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET ls_date  = ARG_VAL(1)
   LET tm.bdate = cl_batch_bg_date_convert(ls_date)
   LET ls_date  = ARG_VAL(2)
   LET tm.edate = cl_batch_bg_date_convert(ls_date)
   LET g_rlang  = ARG_VAL(3)
   LET g_copies = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
#FUN-570149 --end---
 
   LET g_pdate  = ARG_VAL(1)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ARM")) THEN
      EXIT PROGRAM
   END IF
 
   IF s_shut(0) THEN CALL cl_err('',9037,0) EXIT PROGRAM END IF
#NO.FUN-570146 start-
#   CALL p100_tm(0,0)             
 #  CALL cl_used('armp100',g_time,1) RETURNING g_time    #No.FUN-6A0085
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
    WHILE TRUE
      LET g_success = 'Y'
      IF g_bgjob = "N" THEN
         CALL p100_tm(0,0)
         IF cl_sure(21,21) THEN
            CALL cl_wait()
            CALL p100()
            CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p100_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p100_w
      ELSE
         CALL p100()
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
 # CALL cl_used('armp100',g_time,2) RETURNING g_time  #No.FUN-6A0085
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
   #No.FUN-570149 ---end---
 
END MAIN
 
FUNCTION p100_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5     #No.FUN-690010 SMALLINT
   DEFINE   l_cmd         LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
   DEFINE   l_flag        LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
   DEFINE   lc_cmd        LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(500)             #No.FUN-570149
 
   LET p_row = 8 LET p_col = 40
 
   OPEN WINDOW p100_w AT p_row,p_col WITH FORM "arm/42f/armp100" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL        
   LET tm.bdate = g_today
   LET tm.edate = g_today
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET g_bgjob = "N"                         #No.FUN-570149
 
   WHILE TRUE
      LET g_action_choice = ''
 
      #INPUT BY NAME tm.bdate,tm.edate  WITHOUT DEFAULTS 
      INPUT BY NAME tm.bdate,tm.edate,g_bgjob  WITHOUT DEFAULTS   #NO.FUN-570149
 
         AFTER FIELD bdate
            IF cl_null(tm.bdate) THEN
               NEXT FIELD bdate 
            END IF
 
         AFTER FIELD edate
            IF cl_null(tm.edate) THEN
               NEXT FIELD edate 
            END IF
            IF tm.edate < tm.bdate THEN
               CALL cl_err('armp100','aap-100',0)
               LET tm.edate=g_today
              #DISPLAY tm.edate   #CHI-A70049 mark
               NEXT FIELD bdate
            END IF
 
         ON ACTION locale
        #->No.FUN-570149--end---
       #  LET g_action_choice='locale'
       #  CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          LET g_change_lang = TRUE
          #->No.FUN-570149--end---
            EXIT INPUT
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
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
 
      
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
#NO.FUN-570149 start 
#      IF g_action_choice = 'locale' THEN
#         CALL cl_dynamic_locale()
#        CONTINUE WHILE
#      END IF
 
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
#No.FUN-570149 --end--
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         CLOSE WINDOW p100_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
#NO.FUN-570149 start--
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "armp100"
         IF SQLCA.sqlcode OR cl_null(lc_cmd) THEN
           CALL cl_err('armp100','9031',1) #FUN-660111          
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
           CALL cl_cmdat('armp100',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p100_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      ERROR ""
      EXIT WHILE
   END WHILE
 
#      IF cl_sure(20,20) THEN
#         CALL cl_wait()
#         CALL p100()
#      END IF
#      ERROR ""
#   END WHILE
#   CLOSE WINDOW p100_w
#NO.FUN-570149 end----------
END FUNCTION
 
FUNCTION p100()
DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
#       l_time       LIKE type_file.chr8        #No.FUN-6A0085
       l_sql     LIKE type_file.chr1000,      # RDSQL STATEMENT  #No.FUN-690010 VARCHAR(600)
       sr        RECORD
                        rmc07   LIKE rmc_file.rmc07,   #原S/N
                        rmd07   LIKE rmd_file.rmd07    #新S/N
                        END RECORD 
 
       CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
 #MOD-490222 列印表頭資料
     #抓取公司名稱
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 #MOD-490222
#------------產生 armp100.out------------
     LET l_sql = " SELECT rmc07,rmd07 ",
                 " FROM rmc_file,rmd_file ",
                 " WHERE rmd01=rmc01 AND rmd03=rmc02 ",
                 " AND rmc07 is not null AND rmd07 is not null ",
                 " AND (rmc08 BETWEEN '",tm.bdate,
                 "'  AND '",tm.edate,"')"
 
     PREPARE p100_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare:',STATUS,1) 
     END IF
     DECLARE p100_cs1 CURSOR FOR p100_prepare1
     LET l_name = 'armp100.out'
     CALL cl_outnam('armp100') RETURNING l_name
     START REPORT p100_rep TO l_name
     FOREACH p100_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
       END IF
       OUTPUT TO REPORT p100_rep(sr.*)
     END FOREACH
     FINISH REPORT p100_rep
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
       CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
 
END FUNCTION
 
REPORT p100_rep(sr)
DEFINE l_last_sw    LIKE type_file.chr1,   #No.FUN-690010 VARCHAR(1),
       sr        RECORD
                        rmc07   LIKE rmc_file.rmc07,   #原S/N
                        rmd07   LIKE rmd_file.rmd07    #新S/N
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin #FUN-580098 
         PAGE LENGTH g_page_line
 
  ORDER BY sr.rmc07
  FORMAT
 #MOD-490222 列印標題並修改資料顯示位置
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1 , g_company
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno" 
      PRINT g_head CLIPPED,pageno_total     
      PRINT 
      PRINT g_dash
      PRINT g_x[31],g_x[32]
      PRINT g_dash1 
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      PRINT COLUMN g_c[31] ,sr.rmc07 CLIPPED,
            COLUMN g_c[32],sr.rmd07
   ON LAST ROW
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      PRINT g_dash
      IF l_last_sw = 'n'
         THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      END IF
 
 
 #MOD-490222
END REPORT
