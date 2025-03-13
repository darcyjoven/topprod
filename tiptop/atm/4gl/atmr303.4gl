# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: amtr301.4gl
# Descriptions...: 客戶料件庫存數量表
# Date & Author..: 06/03/29 By Sarah
# Modify.........: No.FUN-630027 06/03/29 By Sarah 新增"客戶料件庫存數量表"
# Modify.........: No.FUN-680120 06/08/31 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.TQC-790074 07/09/12 By lumxa 打印時程序抬頭名稱在“制表日期”下面
# Modify.........: No.FUN-860020 08/06/04 By dxfwo  CR報表
# Modify.........: No.FUN-870144 08/07/29 By baofei   報表轉CR追到31區 
# Modify.........: No.FUN-8B0104 09/06/04 By liuxqa 增加送貨客戶欄位
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-B40056 11/07/05 By Summer tup09是No Use不使用的欄位,調整為tup12 
# Modify.........: No:FUN-C80050 12/08/13 By Lori g_program修正g_prog
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm        RECORD            
                  wc      STRING, 
                  more    LIKE type_file.chr1     #No.FUN-680120 VARCHAR(01)    
                 END RECORD 
DEFINE g_tup11   LIKE type_file.chr1              #No.FUN-680120 VARCHAR(1)
#DEFINE g_program LIKE gaz_file.gaz01             #No.FUN-680120 VARCHAR(10)     #FUN-C80050 mark
DEFINE g_gaz03   LIKE gaz_file.gaz03
DEFINE l_table   STRING                           #No.FUN-860020                                                             
DEFINE l_sql     STRING                           #No.FUN-860020 
DEFINE g_sql     STRING                           #No.FUN-860020                                                           
DEFINE g_str     STRING                           #No.FUN-860020
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT   
 
   LET g_tup11  = ARG_VAL(1)      
   LET g_pdate  = ARG_VAL(2)      
   LET g_towhom = ARG_VAL(3)
   LET g_rlang  = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc    = ARG_VAL(8)
 #-------------No.TQC-610088 modify
  #LET tm.more  = ARG_VAL(9)       
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
 #-------------No.TQC-610088end 
 
   CASE g_tup11
     #WHEN 1 LET g_program = 'atmr303'     #FUN-C80050 mark
     #WHEN 2 LET g_program = 'atmr313'     #FUN-C80050 mark
      WHEN 1 LET g_prog = 'atmr303'        #FUN-C80050 mark
      WHEN 2 LET g_prog = 'atmr313'        #FUN-C80050 mark
   END CASE
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   
#No.FUN-860020---Begin 
   LET g_sql = " tup02.tup_file.tup02,",
               " ima02.ima_file.ima02,",
               " ima021.ima_file.ima021,",
               " tup03.tup_file.tup03,",
               " tup01.tup_file.tup01,",
               " occ02.occ_file.occ02,",
               " tup04.tup_file.tup04,",
               " tup05.tup_file.tup05,",
               " tup06.tup_file.tup06,",
               " tup07.tup_file.tup07,",
              #" tup09.tup_file.tup09,",   #No.FUN-8B0104 add  #CHI-B40056 mark
               " tup12.tup_file.tup12,",                       #CHI-B40056
               " occ021.occ_file.occ02 "  #No.FUN-8B0104 add
 
   LET l_table = cl_prt_temptable('atmr302',g_sql) CLIPPED                                                                          
   IF  l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,?,  ?,?,?,?,? ,?,?)"  #No.FUN-8B0104 add   
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF
            
#No.FUN-860020---End    
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
   IF NOT cl_null(tm.wc) THEN  
      CALL r303()
   ELSE  
      CALL r303_tm(0,0)        
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION r303_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(1000)
 
   LET p_row = 5 LET p_col = 13
   OPEN WINDOW r303_w AT p_row,p_col
        WITH FORM "atm/42f/atmr303"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL        
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON tup02,tup03,tup01
                 HELP 1 
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
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      IF g_action_choice = "locale" THEN                                       
         LET g_action_choice = ""                                              
         CALL cl_dynamic_locale()                                              
         CONTINUE WHILE        
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         CLOSE WINDOW r303_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN 
         CALL cl_err('','9046',0) CONTINUE WHILE 
      END IF
 
      INPUT BY NAME tm.more WITHOUT DEFAULTS HELP 1  
    
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
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
    
         ON ACTION CONTROLG CALL cl_cmdask()  
                                                                                   
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
         LET INT_FLAG = 0 
         CLOSE WINDOW r303_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file WHERE zz01='atmr303'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('atmr303','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd=l_cmd CLIPPED,
                            " '",g_tup11  CLIPPED,"'",
                            " '",g_pdate  CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            " '",g_lang   CLIPPED,"'",
                            " '",g_bgjob  CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc    CLIPPED,"'",
                            " '",g_rep_user CLIPPED,"'",           #No.FUN-570264 "
                            " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                            " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('atmr303',g_time,l_cmd) 
         END IF
         CLOSE WINDOW r303_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r303()
      ERROR ""
   END WHILE
   CLOSE WINDOW r303_w
END FUNCTION
 
FUNCTION r303()
DEFINE l_name    LIKE type_file.chr20            #No.FUN-680120 VARCHAR(20)       # External(Disk) file name
#     DEFINEl_time LIKE type_file.chr8        #No.FUN-6B0014
DEFINE l_sql     STRING           # RDSQL STATEMENT
DEFINE sr        RECORD 
                  tup02    LIKE tup_file.tup02,
                  ima02    LIKE ima_file.ima02,
                  ima021   LIKE ima_file.ima021,
                  tup03    LIKE tup_file.tup03,
                  tup01    LIKE tup_file.tup01,
                  occ02    LIKE occ_file.occ02,
                  tup04    LIKE tup_file.tup04,
                  tup05    LIKE tup_file.tup05,
                  tup06    LIKE tup_file.tup06,
                  tup07    LIKE tup_file.tup07, 
                 #tup09    LIKE tup_file.tup09    #No.FUN-8B0104 add #CHI-B40056 mark 
                  tup12    LIKE tup_file.tup12                       #CHI-B40056   
                 END RECORD
DEFINE l_occ02   LIKE occ_file.occ02     #No.FUN-8B0104 
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
  #SELECT gaz03 INTO g_gaz03 FROM gaz_file WHERE gaz01=g_program AND gaz02=g_rlang     #FUN-C80050 mark
   SELECT gaz03 INTO g_gaz03 FROM gaz_file WHERE gaz01=g_prog AND gaz02=g_rlang        #FUN-C80050 add
 
   LET l_sql = "SELECT tup02,ima02,ima021,tup03,tup01,occ02,tup04,",
              #"       tup05,tup06,tup07,tup09",   #No.FUN-8B0104 #CHI-B40056 mark 
               "       tup05,tup06,tup07,tup12",                  #CHI-B40056 
               "  FROM tup_file,OUTER ima_file,OUTER occ_file ",
               " WHERE ima_file.ima01 = tup_file.tup02 ",
               "   AND occ_file.occ01 = tup_file.tup01 ",
               "   AND ", tm.wc CLIPPED,
               "   AND tup11 = '",g_tup11,"' ",
               " ORDER BY tup02,tup03,tup01,tup04"
   PREPARE r303_prepare1 FROM l_sql
   IF SQLCA.sqlcode !=0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
       EXIT PROGRAM 
   END IF
   DECLARE r303_curs1 CURSOR FOR r303_prepare1
 
#  CALL cl_outnam('atmr303') RETURNING l_name         #No.FUN-860020
#  START REPORT r303_rep TO l_name                    #No.FUN-860020
   CALL cl_del_data(l_table)                          #No.FUN-860020 
   LET g_pageno = 0    
 
   FOREACH r303_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN 
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
      END IF
#No.FUN-8B0104 add --begin
      SELECT occ02 INTO l_occ02 FROM occ_file
       #WHERE occ01 = sr.tup09 #CHI-B40056 mark
        WHERE occ01 = sr.tup12 #CHI-B40056
#No.FUN-8B0104 add --end
 
#No.FUN-860020---Begin 
#     OUTPUT TO REPORT r303_rep(sr.*)
      EXECUTE insert_prep USING sr.tup02, sr.ima02, sr.ima021, sr.tup03, sr.tup01, 
                                sr.occ02, sr.tup04, sr.tup05,  sr.tup06, sr.tup07, 
                               #sr.tup09, l_occ02     #No.FUN-8B0104 add #CHI-B40056 mark 
                                sr.tup12, l_occ02                        #CHI-B40056
   END FOREACH
 
#  FINISH REPORT r303_rep
 
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(tm.wc,'tup02,tup03,tup01')         
            RETURNING tm.wc                                                                                                           
    END IF                                                                                                                          
     LET g_str = tm.wc                                                         
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                              
     CALL cl_prt_cs3('atmr303','atmr303',l_sql,g_str) 
#No.FUN-860020---End     
END FUNCTION
#No.FUN-860020---Begin 
#REPORT r303_rep(sr)
#DEFINE l_last_sw    LIKE type_file.chr1             #No.FUN-680120 VARCHAR(1)
#DEFINE sr           RECORD 
#                     tup02    LIKE tup_file.tup02,
#                     ima02    LIKE ima_file.ima02,
#                     ima021   LIKE ima_file.ima021,
#                     tup03    LIKE tup_file.tup03,
#                     tup01    LIKE tup_file.tup01,
#                     occ02    LIKE occ_file.occ02,
#                     tup04    LIKE tup_file.tup04,
#                     tup05    LIKE tup_file.tup05,
#                     tup06    LIKE tup_file.tup06,
#                     tup07    LIKE tup_file.tup07 
#                    END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.tup02,sr.tup03,sr.tup01,sr.tup04
#
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED                     
#      PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]     #TQC-790074                           
#            LET g_pageno = g_pageno + 1                                         
#            LET pageno_total = PAGENO USING '<<<',"/pageno"                     
#            PRINT g_head CLIPPED,pageno_total                                   
#      IF NOT cl_null(g_gaz03) THEN LET g_x[1]=g_gaz03 END IF
##     PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]     #TQC-790074                           
#      PRINT ' '                                                                 
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   ON EVERY ROW
#      PRINT COLUMN g_c[31],sr.tup02 CLIPPED,  
#            COLUMN g_c[32],sr.ima02,   #MOD-4A0238
#            COLUMN g_c[33],sr.ima021,  #MOD-4A0238
#            COLUMN g_c[34],sr.tup03 CLIPPED,
#            COLUMN g_c[35],sr.tup01 CLIPPED,
#            COLUMN g_c[36],sr.occ02 CLIPPED,
#            COLUMN g_c[37],sr.tup04 CLIPPED,
#            COLUMN g_c[38],sr.tup05 USING "----------&.&&&",         
#            COLUMN g_c[39],sr.tup06,
#            COLUMN g_c[40],sr.tup07 
#
#   ON LAST ROW
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT "(", g_program CLIPPED,")",COLUMN (g_len-9), g_x[7] CLIPPED 
#
#   PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#         PRINT g_dash[1,g_len]
#         PRINT "(", g_program CLIPPED,")",COLUMN (g_len-9), g_x[6] CLIPPED 
#      ELSE 
#         SKIP 2 LINE
#      END IF
#END REPORT
#No.FUN-860020---End
#No.FUN-870144
