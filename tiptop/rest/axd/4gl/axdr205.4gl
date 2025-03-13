# Prog. Version..: '5.10.00-08.01.04(00004)'     #
# Pattern name...: axdr205.4gl
# Descriptions...: 派車單列印
# Date & Author..: 04/1/13	By Hawk
# Modify.........: No.MOD-4B0067 04/11/09 By Elva 將變數用Like方式定義,報表拉成一行
# Modify.........: No:FUN-520024 05/02/28 報表轉XML By wujie
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No:TQC-610088 06/02/10 By Pengu Review 所有報表程式接收的外部參數是否完整
# Modify.........: No:FUN-680108 06/08/29 By zhuying 欄位形態定義為LIKE
# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
# Modify.........: No:TQC-6A0095 06/11/13 By xumin 時間問題更改
DATABASE ds

GLOBALS "../../config/top.global"

   DEFINE tm  RECORD                  
              wc      LIKE type_file.chr1000,   #No.FUN-680108 VARCHAR(500)     
              a       LIKE type_file.chr1,      #No.FUN-680108 VARCHAR(1)      
              more    LIKE type_file.chr1       #No.FUN-680108 VARCHAR(1)       
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
   LET tm.a     = ARG_VAL(8)
   #No:FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   #No:FUN-570264 ---end---
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXD")) THEN
      EXIT PROGRAM
   END IF
   IF NOT cl_null(tm.wc) THEN                                                   
      CALL r205()                                                               
   ELSE                                                                         
      CALL r205_tm(0,0)                                                         
   END IF 
END MAIN

FUNCTION r205_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01          #No:FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680108 SMALLINT
       l_cmd          LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(1000)

       LET p_row = 4 LET p_col = 11
   OPEN WINDOW r205_w AT p_row,p_col
        WITH FORM "axd/42f/axdr205"        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
    
    CALL cl_ui_init()

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL         
   LET tm.more = 'N'
   LET tm.a    = '5'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON adk01,adk02,adk13,adk08
                HELP 1

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
      CLOSE WINDOW r205_w 
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN 
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.a,tm.more WITHOUT DEFAULTS HELP 1

      #No:FUN-580031 --start--
      BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No:FUN-580031 ---end---

      AFTER FIELD a
         IF cl_null(tm.a) THEN NEXT FIELD a END IF
         IF tm.a NOT MATCHES '[012345]' THEN NEXT FIELD a END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
      CLOSE WINDOW r205_w 
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file  
             WHERE zz01='axdr205'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axdr205','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,     
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,       #No:TQC-610088 add
                         " '",tm.a CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No:FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No:FUN-570264
                         " '",g_template CLIPPED,"'"            #No:FUN-570264
         CALL cl_cmdat('axdr205',g_time,l_cmd)   
      END IF
      CLOSE WINDOW r205_w
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r205()
   ERROR ""
END WHILE
   CLOSE WINDOW r205_w
END FUNCTION

FUNCTION r205()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680108 VARCHAR(20)     
#       l_time          LIKE type_file.chr8        #No.FUN-6A0091
          l_sql     LIKE type_file.chr1000,        #No.FUN-680108 VARCHAR(500)
          l_chr     LIKE type_file.chr1,           #No.FUN-680108 VARCHAR(1)
          l_za05    LIKE za_file.za05,             #NO.MOD-4B0067
          l_order   ARRAY[5] OF LIKE type_file.chr1000,#No.FUN-680108 VARCHAR(20) 
          sr           RECORD 
                           adk01  LIKE adk_file.adk01,  
                           adk02  LIKE adk_file.adk02,  
                           adk03  LIKE adk_file.adk03,  
                           adk04  LIKE adk_file.adk04,
                           adk05  LIKE adk_file.adk05,
                           adk06  LIKE adk_file.adk06,
                           adk07  LIKE adk_file.adk07,
                           adk08  LIKE adk_file.adk08,
                           adk09  LIKE adk_file.adk09,
                           adk13  LIKE adk_file.adk13,
                           adk14  LIKE adk_file.adk14,
                           adk15  LIKE adk_file.adk15,
                           adk16  LIKE adk_file.adk16,
                           gen02  LIKE gen_file.gen02,
                           gem02  LIKE gem_file.gem02, 
                           adl02  LIKE adl_file.adl02,  
                           adl03  LIKE adl_file.adl03,  
                           adl04  LIKE adl_file.adl04,  
                           adl05  LIKE adl_file.adl05,  
                           adl06  LIKE adl_file.adl06,  
                           adl07  LIKE adl_file.adl07,  
                           adl08  LIKE adl_file.adl08,  
                           adg09  LIKE adg_file.adg09,  
                           adg10  LIKE adg_file.adg10,
                           adg11  LIKE adg_file.adg11
                       END RECORD

       CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     CASE                                                                       
        WHEN tm.a = '0' LET tm.wc = tm.wc CLIPPED," AND adk17 = '0'"            
        WHEN tm.a = '1' LET tm.wc = tm.wc CLIPPED," AND adk17 = '1'"            
        WHEN tm.a = '2' LET tm.wc = tm.wc CLIPPED," AND adk17 = 'S'"            
        WHEN tm.a = '3' LET tm.wc = tm.wc CLIPPED," AND adk17 = 'R'"            
        WHEN tm.a = '4' LET tm.wc = tm.wc CLIPPED," AND adk17 = 'W'"            
     END CASE 
     LET l_sql = "SELECT adk01,adk02,adk03,adk04,adk05,adk06,adk07,adk08,",
                 "       adk09,adk13,adk14,adk15,adk16,gen02,gem02,",
                 "       adl02,adl03,adl04,adl05,adl06,adl07,adl08,",
                 "       adg09,adg10,adg11 ",
                 "  FROM adk_file,adl_file,OUTER gen_file,",
                 "          OUTER gem_file,OUTER adg_file",
                 " WHERE adk01 = adl01 AND adk13 = gen_file.gen01", 
                 "   AND adk14 = gem_file.gem01 AND adl03 = adg_file.adg01",
                 "   AND adl04 = adg_file.adg02",
                 "   AND ",tm.wc CLIPPED,
                 " ORDER BY adk01,adl02 " 
     
     PREPARE r205_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        EXIT PROGRAM 
     END IF
     DECLARE r205_curs1 CURSOR FOR r205_prepare1

     CALL cl_outnam('axdr205') RETURNING l_name
     START REPORT r205_rep TO l_name
     LET g_pageno = 0

     FOREACH r205_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
       END IF
       OUTPUT TO REPORT r205_rep(sr.*)
     END FOREACH

     FINISH REPORT r205_rep

     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
       CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
END FUNCTION

REPORT r205_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,           #No.FUN-680108 VARCHAR(1)
          sr           RECORD 
                           adk01  LIKE adk_file.adk01,  
                           adk02  LIKE adk_file.adk02,  
                           adk03  LIKE adk_file.adk03,  
                           adk04  LIKE adk_file.adk04,
                           adk05  LIKE adk_file.adk05,
                           adk06  LIKE adk_file.adk06,
                           adk07  LIKE adk_file.adk07,
                           adk08  LIKE adk_file.adk08,
                           adk09  LIKE adk_file.adk09,
                           adk13  LIKE adk_file.adk13,
                           adk14  LIKE adk_file.adk14,
                           adk15  LIKE adk_file.adk15,
                           adk16  LIKE adk_file.adk16,
                           gen02  LIKE gen_file.gen02,
                           gem02  LIKE gem_file.gem02, 
                           adl02  LIKE adl_file.adl02,  
                           adl03  LIKE adl_file.adl03,  
                           adl04  LIKE adl_file.adl04,  
                           adl05  LIKE adl_file.adl05,  
                           adl06  LIKE adl_file.adl06,  
                           adl07  LIKE adl_file.adl07,  
                           adl08  LIKE adl_file.adl08,  
                           adg09  LIKE adg_file.adg09,  
                           adg10  LIKE adg_file.adg10,
                           adg11  LIKE adg_file.adg11
                       END RECORD
  DEFINE l_gen02a      LIKE gen_file.gen02

  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.adk01,sr.adl02
  FORMAT
   PAGE HEADER
      PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED                     
            LET g_pageno = g_pageno + 1                                         
            LET pageno_total = PAGENO USING '<<<',"/pageno"                     
            PRINT g_head CLIPPED,pageno_total                                   
      PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]                           
      PRINT ' '                                                                 
      PRINT g_dash[1,g_len]
 #NO.MOD-4B0067  --begin      
#     SKIP TO TOP OF PAGE
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
            g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],
            g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],
            g_x[51],g_x[52],g_x[53],g_x[54],g_x[55],g_x[56] 

      LET l_last_sw = 'n'
      PRINT g_dash1
  BEFORE GROUP OF sr.adk01

   ON EVERY ROW
      PRINT COLUMN  g_c[31],sr.adk01 CLIPPED,  #TQC-6A0095
            COLUMN  g_c[32],sr.adk02 CLIPPED,  #TQC-6A0095
            COLUMN  g_c[33],sr.adk08 CLIPPED,  #TQC-6A0095
            COLUMN  g_c[34],sr.adk13 CLIPPED,  #TQC-6A0095
            COLUMN  g_c[35],sr.gen02 CLIPPED,  #TQC-6A0095
            COLUMN  g_c[36],sr.adk14 CLIPPED,  #TQC-6A0095 
            COLUMN  g_c[37],sr.gem02 CLIPPED;  #TQC-6A0095

      SELECT gen02 INTO l_gen02a FROM gen_file 
       WHERE gen01 = sr.adk09
      PRINT COLUMN  g_c[38],sr.adk09 CLIPPED, #TQC-6A0095
            COLUMN  g_c[39],l_gen02a CLIPPED, #TQC-6A0095
            COLUMN  g_c[40],sr.adk04 CLIPPED, #TQC-6A0095
            COLUMN  g_c[41],sr.adk05 USING '##:##',    #TQC-6A0095
            COLUMN  g_c[42],sr.adk06 CLIPPED,  #TQC-6A0095
            COLUMN  g_c[43],sr.adk07 USING '##:##',    #TQC-6A0095
            COLUMN  g_c[44],sr.adk03 CLIPPED,  #TQC-6A0095
            COLUMN  g_c[45],sr.adk15 CLIPPED,  #TQC-6A0095
            COLUMN  g_c[46],sr.adk16 CLIPPED;  #TQC-6A0095
      PRINT COLUMN  g_c[47],sr.adl02 USING '###&', #FUN-590118
            COLUMN  g_c[48],sr.adl03 CLIPPED,  #TQC-6A0095
            COLUMN  g_c[49],sr.adl04 USING '#########&', #FUN-590118
            COLUMN  g_c[50],sr.adg09 CLIPPED, #TQC-6A0095
            COLUMN  g_c[51],sr.adg10 CLIPPED, #TQC-6A0095
            COLUMN  g_c[52],sr.adg11 CLIPPED, #TQC-6A0095
            COLUMN  g_c[53],sr.adl05 USING '-----------&.&&',
            COLUMN  g_c[54],sr.adl06 USING '----&.&&',
            COLUMN  g_c[55],sr.adl07 CLIPPED,  #TQC-6A0095
            COLUMN  g_c[56],sr.adl08 CLIPPED   #TQC-6A0095
 #NO.MOD-4B0067  --end        

   ON LAST ROW
      LET l_last_sw = 'y'

   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4] CLIPPED,COLUMN 31,g_x[5] CLIPPED, 
                    COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE 
         PRINT g_dash[1,g_len]
         PRINT g_x[4] CLIPPED,COLUMN 31,g_x[5] CLIPPED, 
               COLUMN (g_len-9), g_x[7] CLIPPED
      END IF
END REPORT
