# Prog. Version..: '5.10.00-08.01.04(00003)'     #
# Pattern name...: axdr102.4gl
# Descriptions...: 客戶庫存數量表
# Date & Author..: 04/01/13 By Hawk
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.MOD-4B0067 04/11/17 By Elva 將變數用Like方式定義,報表拉成一行
# Modify.........: No.MOD-4B0267 04/11/25 By Carrier  AXD系統中客戶編號長度擴大至10碼
# Modify.........: No:FUN-520024 05/02/25 報表轉XML By wujie
# Modify.........: No.MOD-540145 05/05/10 By vivien  刪除HELP FILE   
# Modify.........: No:TQC-610088 06/02/10 By Pengu Review 所有報表程式接收的外部參數是否完整
# Modify.........: No:FUN-680108 06/08/28 By zhuying 欄位形態定義為LIKE

# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm  RECORD            
           wc      LIKE type_file.chr1000,#No.FUN-680108 VARCHAR(500) 
           more    LIKE type_file.chr1    #No.FUN-680108 VARCHAR(01)      
           END RECORD 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680108 SMALLINT
MAIN
   OPTIONS
       FORM LINE     FIRST + 2,
       MESSAGE LINE  LAST,
       PROMPT LINE   LAST,
       INPUT NO WRAP
   DEFER INTERRUPT   
   LET g_pdate  = ARG_VAL(1)      
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
#---------------No:TQC-610088 modify
  #LET tm.more  = ARG_VAL(8)  
   #No:FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   #No:FUN-570264 ---end---
#---------------No:TQC-610088 end
     IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXD")) THEN
      EXIT PROGRAM
   END IF
   IF NOT cl_null(tm.wc) THEN  
      CALL r102()
   ELSE  
      CALL r102_tm(0,0)        
   END IF
END MAIN

FUNCTION r102_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No:FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5     #No.FUN-680108 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000  #No.FUN-680108 VARCHAR(1000)

 LET p_row = 5 LET p_col = 13
   OPEN WINDOW r102_w AT p_row,p_col
        WITH FORM "axd/42f/axdr102" ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_init()
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL        
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON adp01,adp02,adp03

      #No:FUN-580031 --start--
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
      #No:FUN-580031 ---end---

      ON ACTION locale                                                          
          #CALL cl_dynamic_locale()                                             
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
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

      #No:FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      #No:FUN-580031 ---end---

 END CONSTRUCT         
       IF g_action_choice = "locale" THEN                                       
          LET g_action_choice = ""                                              
          CALL cl_dynamic_locale()                                              
          CONTINUE WHILE                                                        
       END IF  
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW r102_w 
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN 
      CALL cl_err('','9046',0) CONTINUE WHILE 
   END IF
   INPUT BY NAME tm.more WITHOUT DEFAULTS HELP 1  

      #No:FUN-580031 --start--
      BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No:FUN-580031 ---end---

      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                           g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLZ
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

      #No:FUN-580031 --start--
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No:FUN-580031 ---end---

 END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW r102_w 
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file   
             WHERE zz01='axdr102'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axdr102','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd=l_cmd CLIPPED,
                         " '",g_pdate  CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang   CLIPPED,"'",
                         " '",g_bgjob  CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No:FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No:FUN-570264
                         " '",g_template CLIPPED,"'"            #No:FUN-570264
         CALL cl_cmdat('axdr102',g_time,l_cmd) 
      END IF
      CLOSE WINDOW r102_w
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r102()
   ERROR ""
END WHILE
   CLOSE WINDOW r102_w
END FUNCTION

FUNCTION r102()
DEFINE l_name    LIKE type_file.chr20   #No.FUN-680108 VARCHAR(20)      
#     DEFINEl_time LIKE type_file.chr8        #No.FUN-6A0091
DEFINE l_sql     LIKE type_file.chr1000 #No.FUN-680108 VARCHAR(300)
DEFINE l_za05    LIKE za_file.za05      #NO.MOD-4B0067
DEFINE l_order   ARRAY[5] OF LIKE type_file.chr1000 #No.FUN-680108 VARCHAR(10) 
DEFINE sr        RECORD 
                     adp01    LIKE adp_file.adp01,
                     adp02    LIKE adp_file.adp02,
                     adp03    LIKE adp_file.adp03,
                     adp04    LIKE adp_file.adp04,
                     adp05    LIKE adp_file.adp05,
                     adp06    LIKE adp_file.adp06,
                     adp07    LIKE adp_file.adp07, 
                     occ02    LIKE occ_file.occ02, 
                     ima02    LIKE ima_file.ima02,
                     ima021   LIKE ima_file.ima021
                 END RECORD

       CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang

     LET l_sql = " SELECT adp01,adp02,adp03,adp04,adp05,",
                 "        adp06,adp07,occ02,ima02,ima021",
                 "   FROM adp_file,OUTER (occ_file,ima_file) ",
                 "  WHERE occ_file.occ01 = adp01 ",
                 "    AND ima01 = adp02 ",
                 "    AND ", tm.wc CLIPPED,
                 "  ORDER BY adp01,adp02,adp03"
     PREPARE r102_prepare1 FROM l_sql
     IF SQLCA.sqlcode !=0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1) 
         EXIT PROGRAM 
     END IF
     DECLARE r102_curs1 CURSOR FOR r102_prepare1

     CALL cl_outnam('axdr102') RETURNING l_name
     START REPORT r102_rep TO l_name
     LET g_pageno = 0

     FOREACH r102_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN 
             CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
          END IF
          OUTPUT TO REPORT r102_rep(sr.*)
     END FOREACH

     FINISH REPORT r102_rep

     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
       CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
END FUNCTION

REPORT r102_rep(sr)
DEFINE l_last_sw    LIKE type_file.chr1      #No.FUN-680108 VARCHAR(1)
DEFINE sr           RECORD 
                        adp01    LIKE adp_file.adp01,
                        adp02    LIKE adp_file.adp02,
                        adp03    LIKE adp_file.adp03,
                        adp04    LIKE adp_file.adp04,
                        adp05    LIKE adp_file.adp05,
                        adp06    LIKE adp_file.adp06,
                        adp07    LIKE adp_file.adp07, 
                        occ02    LIKE occ_file.occ02, 
                        ima02    LIKE ima_file.ima02,
                        ima021   LIKE ima_file.ima021
                    END RECORD

  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.adp01,sr.adp02,sr.adp03
  FORMAT
   PAGE HEADER
      PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            LET g_pageno = g_pageno + 1                                         
            LET pageno_total = PAGENO USING '<<<',"/pageno"                     
            PRINT g_head CLIPPED,pageno_total            
      PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      PRINT ' '
      PRINT g_dash[1,g_len]
 #MOD-4B0067  --begin
      PRINT g_x[31],g_x[32],g_x[33],
            g_x[34],g_x[35],g_x[36],
            g_x[37],g_x[38],g_x[39],
            g_x[40]
      PRINT g_dash1
      LET l_last_sw = 'n'

   ON EVERY ROW
    #No.MOD-4B0267  --begin
      PRINT COLUMN  g_c[31],sr.adp01,  
            COLUMN  g_c[32],sr.occ02;
      PRINT COLUMN  g_c[33],sr.adp02,
             COLUMN  g_c[34],sr.ima02 CLIPPED,   #MOD-4A0238
             COLUMN  g_c[35],sr.ima021 CLIPPED;   #MOD-4A0238
      PRINT COLUMN  g_c[36],sr.adp03 CLIPPED,
            COLUMN  g_c[37],sr.adp04,
            COLUMN  g_c[38],sr.adp05 USING "----------&.&&&",         
            COLUMN  g_c[39],sr.adp06,
            COLUMN  g_c[40],sr.adp07 
    #No.MOD-4B0267  --end    
 #MOD-4B0067  --end

   ON LAST ROW
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
   
   AFTER GROUP OF sr.adp01
      PRINT 

   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, 
              COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
