# Prog. Version..: '5.30.06-13.03.14(00007)'     #
#
# Pattern name...: atmr171.4gl
# Descriptions...: 派車單明細列印
# Date & Author..: 06/05/16 By Rayven
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.TQC-790074 07/09/12 By lumxa 打印時程序抬頭名稱在“制表日期”下面
# Modify.........: No.FUN-860012 08/06/04 By lala    CR
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-CB0228 12/12/27 By jt_chen 報表程式漏加 CALL cl_del_data(l_table) 導致查詢時會出現上一次查詢的值
# Modify.........: No.CHI-C80041 12/12/28 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  
              wc      LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(500)
              a       LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
              more    LIKE type_file.chr1              #No.FUN-680120 VARCHAR(1)
              END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE   g_str      STRING     #No.FUN-860012 
DEFINE   g_sql      STRING     #No.FUN-860012 
DEFINE   l_table    STRING     #No.FUN-860012 
 
MAIN
   OPTIONS
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
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
   
#No.FUN-860012---start---
   LET g_sql="adk01.adk_file.adk01,",
             "adk02.adk_file.adk02,",
             "adk08.adk_file.adk08,",
             "adk13.adk_file.adk13,",
             "gen02.gen_file.gen02,",
             "adk09.adk_file.adk09,",
             "l_gen02a.gen_file.gen02,",
             "adk04.adk_file.adk04,",
             "adk05.adk_file.adk05,",
             "adk06.adk_file.adk06,",
             "adk07.adk_file.adk07,",
             "adk03.adk_file.adk03,",
             "adk15.adk_file.adk15,",
             "adk17.adk_file.adk17,",
             "l_desc.type_file.chr1000,",
             "adl02.adl_file.adl02,",
             "adl03.adl_file.adl03,",
             "adl04.adl_file.adl04,",
             "oga04.oga_file.oga04,",
             "l_occ02.occ_file.occ02,",
             "oga044.oga_file.oga044,",
             "ogb04.ogb_file.ogb04,",
             "ogb06.ogb_file.ogb06,",
             "l_ima021.ima_file.ima021,",
             "adl20.adl_file.adl20,",
             "adl05.adl_file.adl05,",
             "l_str.type_file.chr1000,",
             "adl06.adl_file.adl06,",
             "adl07.adl_file.adl07,",
             "adl08.adl_file.adl08,",
             "adl09.adl_file.adl09,",
             "adl10.adl_file.adl10"
 
   LET l_table = cl_prt_temptable('atmr171',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED, l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      EXIT PROGRAM
   END IF
#No.FUN-860012---end---
 
   IF NOT cl_null(tm.wc) THEN                                                   
      CALL r171()                                                               
   ELSE                                                                         
      CALL r171_tm(0,0)                                                         
   END IF 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION r171_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680120 SMALLINT
       l_cmd          LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 11
 
   OPEN WINDOW r171_w AT p_row,p_col
        WITH FORM "atm/42f/atmr171"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
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
 
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
      ON ACTION CONTROLP                                                                                                            
         CASE 
            WHEN INFIELD(adk01) 
               CALL cl_init_qry_var() 
               LET g_qryparam.state = "c" 
               LET g_qryparam.form ="q_adk01" 
               CALL cl_create_qry() RETURNING g_qryparam.multiret 
               DISPLAY g_qryparam.multiret TO adk01
            WHEN INFIELD(adk13) 
               CALL cl_init_qry_var() 
               LET g_qryparam.state = "c" 
               LET g_qryparam.form ="q_gen" 
               CALL cl_create_qry() RETURNING g_qryparam.multiret 
               DISPLAY g_qryparam.multiret TO adk13
            WHEN INFIELD(adk08) 
               CALL cl_init_qry_var() 
               LET g_qryparam.state = "c" 
               LET g_qryparam.form ="q_obw01" 
               CALL cl_create_qry() RETURNING g_qryparam.multiret 
               DISPLAY g_qryparam.multiret TO adk08
            OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION locale                                                          
         CALL cl_show_fld_cont()           
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
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
 
   END CONSTRUCT                                                                  
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('adkuser', 'adkgrup') #FUN-980030
 
   IF g_action_choice = "locale" THEN                                       
      LET g_action_choice = ""                                              
      CALL cl_dynamic_locale()                                              
      CONTINUE WHILE                                                        
   END IF                               
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW r171_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
   END IF
 
   IF tm.wc = ' 1=1' THEN 
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.a,tm.more WITHOUT DEFAULTS HELP 1
 
      BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
 
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
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW r171_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file  
             WHERE zz01='atmr171'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('atmr171','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,     
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,         
                         " '",tm.a CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",    
                         " '",g_rep_clas CLIPPED,"'",  
                         " '",g_template CLIPPED,"'"  
         CALL cl_cmdat('atmr171',g_time,l_cmd)   
      END IF
      CLOSE WINDOW r171_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r171()
   ERROR ""
 END WHILE
 CLOSE WINDOW r171_w
END FUNCTION
 
FUNCTION r171()
   DEFINE l_gen02a     LIKE gen_file.gen02
   DEFINE l_occ02      LIKE occ_file.occ02
   DEFINE l_ima021     LIKE ima_file.ima021
   DEFINE l_ima906     LIKE ima_file.ima906
   DEFINE l_adl17      LIKE adl_file.adl17
   DEFINE l_adl14      LIKE adl_file.adl14
   DEFINE l_name    LIKE type_file.chr20,            #No.FUN-680120 VARCHAR(20)
#         l_time          LIKE type_file.chr8        #No.FUN-6B0014
          l_str        LIKE type_file.chr1000,
          l_desc       LIKE type_file.chr1000,
          l_sql     LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(500)
          l_chr     LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
          l_za05    LIKE za_file.za05,   
          l_order   ARRAY[5] OF LIKE bnb_file.bnb06, #No.FUN-680120 VARCHAR(20)
          sr           RECORD 
                           adk01  LIKE adk_file.adk01,  
                           adk02  LIKE adk_file.adk02,  
                           adk08  LIKE adk_file.adk08,
                           adk13  LIKE adk_file.adk13,
                           gen02  LIKE gen_file.gen02,
                           adk09  LIKE adk_file.adk09,
                           adk04  LIKE adk_file.adk04,
                           adk05  LIKE adk_file.adk05,
                           adk06  LIKE adk_file.adk06,
                           adk07  LIKE adk_file.adk07,
                           adk03  LIKE adk_file.adk03,  
                           adk15  LIKE adk_file.adk15,
                           adk17  LIKE adk_file.adk17,
                           adl02  LIKE adl_file.adl02,  
                           adl03  LIKE adl_file.adl03,  
                           adl04  LIKE adl_file.adl04,  
                           oga04  LIKE oga_file.oga04,
                           oga044 LIKE oga_file.oga044,
                           ogb04  LIKE ogb_file.ogb04,
                           ogb06  LIKE ogb_file.ogb06,
                           adl20  LIKE adl_file.adl20,
                           adl05  LIKE adl_file.adl05,  
                           adl06  LIKE adl_file.adl06,  
                           adl07  LIKE adl_file.adl07,  
                           adl08  LIKE adl_file.adl08,  
                           adl09  LIKE adl_file.adl09,  
                           adl10  LIKE adl_file.adl10,
                           adl12  LIKE adl_file.adl12,
                           adl14  LIKE adl_file.adl14,
                           adl15  LIKE adl_file.adl15,
                           adl17  LIKE adl_file.adl17
                       END RECORD
 
     CALL cl_del_data(l_table)   #MOD-CB0228
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     CASE                                                                       
        WHEN tm.a = '0' LET tm.wc = tm.wc CLIPPED," AND adk17 = '0'"            
        WHEN tm.a = '1' LET tm.wc = tm.wc CLIPPED," AND adk17 = '1'"            
        WHEN tm.a = '2' LET tm.wc = tm.wc CLIPPED," AND adk17 = 'S'"            
        WHEN tm.a = '3' LET tm.wc = tm.wc CLIPPED," AND adk17 = 'R'"            
        WHEN tm.a = '4' LET tm.wc = tm.wc CLIPPED," AND adk17 = 'W'"            
     END CASE 
     LET l_sql = "SELECT adk01,adk02,adk08,adk13,gen02,adk09,adk04,",
                 "       adk05,adk06,adk07,adk03,adk15,adk17,adl02,",
                 "       adl03,adl04,oga04,oga044,ogb04,ogb06,adl20,",
                 "       adl05,adl06,adl07,adl08,adl09,adl10,adl12,",
                 "       adl14,adl15,adl17 ",
                 "  FROM adk_file,adl_file,OUTER gen_file,",
                 "          OUTER oga_file,OUTER ogb_file",
                 " WHERE adk01 = adl01 AND adk_file.adk13 = gen_file.gen01", 
                 "   AND adl_file.adl03 = oga_file.oga01 AND adl_file.adl03 = ogb_file.ogb01",
                 "   AND adl_file.adl04 = ogb_file.ogb03",
                 "   AND adkconf <> 'X' ",  #CHI-C80041
                 "   AND ",tm.wc CLIPPED,
                 " ORDER BY adk01,adl02 " 
     
     PREPARE r171_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
        EXIT PROGRAM 
     END IF
     DECLARE r171_curs1 CURSOR FOR r171_prepare1
 
#     CALL cl_outnam('atmr171') RETURNING l_name
 
     IF g_sma.sma115 = 'Y' THEN
        LET g_zaa[57].zaa06 = 'N'
     ELSE
        LET g_zaa[57].zaa06 = 'Y'
     END IF
 
     CALL cl_prt_pos_len()
#No.FUN-860012---start---
#     START REPORT r171_rep TO l_name
     LET g_pageno = 0
 
     FOREACH r171_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
       END IF
#       OUTPUT TO REPORT r171_rep(sr.*)
     SELECT gen02 INTO l_gen02a FROM gen_file 
        WHERE gen01 = sr.adk09
     SELECT occ02 INTO l_occ02 FROM occ_file
        WHERE occ01 = sr.oga04
     SELECT ima021 INTO l_ima021 FROM ima_file
        WHERE ima01 = sr.ogb04
     SELECT ima906 INTO l_ima906 FROM ima_file           
       WHERE ima01 = sr.ogb04
      LET l_str = ""         
      IF g_sma.sma115 = "Y" THEN 
         CASE l_ima906      
            WHEN "2"       
                CALL cl_remove_zero(sr.adl17) RETURNING l_adl17 
                LET l_str = l_adl17 USING '<<<<<<.<<' , sr.adl15 CLIPPED 
                IF cl_null(sr.adl17) OR sr.adl17 = 0 THEN          
                    CALL cl_remove_zero(sr.adl14) RETURNING l_adl14
                    LET l_str = l_adl14 USING '<<<<<<.<<', sr.adl12 CLIPPED        
                ELSE                                             
                   IF NOT cl_null(sr.adl14) AND sr.adl14 > 0 THEN   
                      CALL cl_remove_zero(sr.adl14) RETURNING l_adl14            
                      LET l_str = l_str CLIPPED,',',l_adl14 USING '<<<<<<.<<', sr.adl12 CLIPPED                                                 
                   END IF               
                END IF               
            WHEN "3"
                IF NOT cl_null(sr.adl17) AND sr.adl17 > 0 THEN
                   CALL cl_remove_zero(sr.adl17) RETURNING l_adl17
                   LET l_str = l_adl17 USING '<<<<<<.<<' , sr.adl15 CLIPPED 
                END IF 
         END CASE
      END IF
     EXECUTE insert_prep USING
        sr.adk01,sr.adk02,sr.adk08,sr.adk13,sr.gen02,sr.adk09,l_gen02a,sr.adk04,sr.adk05,sr.adk06,
        sr.adk07,sr.adk03,sr.adk15,sr.adk17,l_desc,sr.adl02,sr.adl03,sr.adl04,sr.oga04,l_occ02,sr.oga044,
        sr.ogb04,sr.ogb06,l_ima021,sr.adl20,sr.adl05,l_str,sr.adl06,sr.adl07,sr.adl08,sr.adl09,sr.adl10
     END FOREACH
     LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     CALL cl_wcchp(tm.wc,'adk01,adk02,adk13,adk08')
             RETURNING tm.wc
     LET g_str=tm.wc
     CALL cl_prt_cs3('atmr171','atmr171',g_sql,g_str)
 
#     FINISH REPORT r171_rep
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
#REPORT r171_rep(sr)
#  DEFINE l_gen02a     LIKE gen_file.gen02
#  DEFINE l_occ02      LIKE occ_file.occ02
#  DEFINE l_ima021     LIKE ima_file.ima021
#  DEFINE l_ima906     LIKE ima_file.ima906
#  DEFINE l_adl17      LIKE adl_file.adl17
#  DEFINE l_adl14      LIKE adl_file.adl14
#  DEFINE l_last_sw    LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
#         l_desc       LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(20)    
#         l_str        LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(100)
#         sr           RECORD 
#                          adk01  LIKE adk_file.adk01,  
#                          adk02  LIKE adk_file.adk02,  
#                          adk08  LIKE adk_file.adk08,
#                          adk13  LIKE adk_file.adk13,
#                          gen02  LIKE gen_file.gen02,
#                          adk09  LIKE adk_file.adk09,
#                          adk04  LIKE adk_file.adk04,
#                          adk05  LIKE adk_file.adk05,
#                          adk06  LIKE adk_file.adk06,
#                          adk07  LIKE adk_file.adk07,
#                          adk03  LIKE adk_file.adk03,  
#                          adk15  LIKE adk_file.adk15,
#                          adk17  LIKE adk_file.adk17,
#                          adl02  LIKE adl_file.adl02,  
#                          adl03  LIKE adl_file.adl03,  
#                          adl04  LIKE adl_file.adl04,  
#                          oga04  LIKE oga_file.oga04,
#                          oga044 LIKE oga_file.oga044,
#                          ogb04  LIKE ogb_file.ogb04,
#                          ogb06  LIKE ogb_file.ogb06,
#                          adl20  LIKE adl_file.adl20,
#                          adl05  LIKE adl_file.adl05,  
#                          adl06  LIKE adl_file.adl06,  
#                          adl07  LIKE adl_file.adl07,  
#                          adl08  LIKE adl_file.adl08,  
#                          adl09  LIKE adl_file.adl09,  
#                          adl10  LIKE adl_file.adl10,
#                          adl12  LIKE adl_file.adl12,
#                          adl14  LIKE adl_file.adl14,
#                          adl15  LIKE adl_file.adl15,
#                          adl17  LIKE adl_file.adl17
#                      END RECORD
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.adk01,sr.adl02
 
# FORMAT
#  PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]  #TQC-790074
 
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<',"/pageno" 
#           PRINT g_head CLIPPED,pageno_total     
 
##           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]  #TQC-790074
#           PRINT
#           PRINT g_dash[1,g_len]
#           PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#                 g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
#                 g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],
#                 g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],
#                 g_x[51],g_x[52],g_x[53],g_x[54],g_x[55],
#                 g_x[56],g_x[57],g_x[58],g_x[59],g_x[60],g_x[61],g_x[62]
#           PRINT g_dash1 
 
#  BEFORE GROUP OF sr.adk01
#           CASE sr.adk17
#                WHEN '0' CALL cl_getmsg('axd-061',g_lang) RETURNING l_desc
#                WHEN '1' CALL cl_getmsg('axd-062',g_lang) RETURNING l_desc
#                WHEN 'S' CALL cl_getmsg('axd-066',g_lang) RETURNING l_desc
#                WHEN 'R' CALL cl_getmsg('axd-067',g_lang) RETURNING l_desc
#                WHEN 'W' CALL cl_getmsg('axd-068',g_lang) RETURNING l_desc
#           END CASE
#     LET l_gen02a = ''
#     PRINT COLUMN  g_c[31],sr.adk01,
#           COLUMN  g_c[32],sr.adk02,
#           COLUMN  g_c[33],sr.adk08,
#           COLUMN  g_c[34],sr.adk13,
#           COLUMN  g_c[35],sr.gen02,
#           COLUMN  g_c[36],sr.adk09;
#     SELECT gen02 INTO l_gen02a FROM gen_file 
#      WHERE gen01 = sr.adk09
#     PRINT COLUMN g_c[37],l_gen02a,
#           COLUMN g_c[38],sr.adk04,
#           COLUMN g_c[39],sr.adk05,
#           COLUMN g_c[40],sr.adk06,
#           COLUMN g_c[41],sr.adk07,
#           COLUMN g_c[42],sr.adk03,
#           COLUMN g_c[43],sr.adk15,
#           COLUMN g_c[44],sr.adk17,
#           COLUMN g_c[45],l_desc;
 
#  ON EVERY ROW
#     PRINT COLUMN g_c[46],sr.adl02 USING '###&',
#           COLUMN g_c[47],sr.adl03,
#           COLUMN g_c[48],sr.adl04 USING '#########&',
#           COLUMN g_c[49],sr.oga04;
#     SELECT occ02 INTO l_occ02 FROM occ_file
#      WHERE occ01 = sr.oga04
#     PRINT COLUMN g_c[50],l_occ02, 
#           COLUMN g_c[51],sr.oga044,
#           COLUMN g_c[52],sr.ogb04,
#           COLUMN g_c[53],sr.ogb06;
#     SELECT ima021 INTO l_ima021 FROM ima_file
#      WHERE ima01 = sr.ogb04
#     PRINT COLUMN g_c[54],l_ima021,
#           COLUMN g_c[55],sr.adl20,
#           COLUMN g_c[56],sr.adl05 USING '-----------&.&&';
#     #單位注解            
#     SELECT ima906 INTO l_ima906 FROM ima_file           
#      WHERE ima01 = sr.ogb04
#     LET l_str = ""         
#     IF g_sma.sma115 = "Y" THEN 
#        CASE l_ima906      
#           WHEN "2"       
#               CALL cl_remove_zero(sr.adl17) RETURNING l_adl17 
#               LET l_str = l_adl17 USING '<<<<<<.<<' , sr.adl15 CLIPPED 
#               IF cl_null(sr.adl17) OR sr.adl17 = 0 THEN          
#                   CALL cl_remove_zero(sr.adl14) RETURNING l_adl14
#                   LET l_str = l_adl14 USING '<<<<<<.<<', sr.adl12 CLIPPED        
#               ELSE                                             
#                  IF NOT cl_null(sr.adl14) AND sr.adl14 > 0 THEN   
#                     CALL cl_remove_zero(sr.adl14) RETURNING l_adl14            
#                     LET l_str = l_str CLIPPED,',',l_adl14 USING '<<<<<<.<<', sr.adl12 CLIPPED                                                 
#                  END IF               
#               END IF               
#           WHEN "3"
#               IF NOT cl_null(sr.adl17) AND sr.adl17 > 0 THEN
#                  CALL cl_remove_zero(sr.adl17) RETURNING l_adl17
#                  LET l_str = l_adl17 USING '<<<<<<.<<' , sr.adl15 CLIPPED 
#               END IF 
#        END CASE
#        PRINT COLUMN g_c[57],l_str;
#     END IF       
#     PRINT COLUMN g_c[58],sr.adl06 USING '----&.&&',
#           COLUMN g_c[59],sr.adl07,
#           COLUMN g_c[60],sr.adl08,
#           COLUMN g_c[61],sr.adl09,
#           COLUMN g_c[62],sr.adl10
 
#  ON LAST ROW
#     PRINT g_dash[1,g_len]
#     PRINT g_x[4],g_x[5] CLIPPED, 
#           COLUMN (g_len-9), g_x[7] CLIPPED
#    LET l_last_sw = 'n'
 
#  PAGE TRAILER
#     IF l_last_sw = 'y'
#        THEN PRINT g_dash[1,g_len]
#             PRINT g_x[4],g_x[5] CLIPPED, 
#                   COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE SKIP 2 LINE
#     END IF
#END REPORT
#No.FUN-860012---end
