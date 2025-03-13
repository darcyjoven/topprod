# Prog. Version..: '5.30.07-13.05.30(00002)'     #
#
# Pattern name...: atmx170.4gl
# Descriptions...:
# Date & Author..: 06/05/17  by cl
# Modify.........: No.FUN-660104 06/06/15 By Rayven cl_err改成cl_err3
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換 
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/31 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.FUN-6B0014 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-720014 07/03/02 By rainy s_addr傳回5個參數
# Modify.........: No.TQC-790033 07/09/10 By lumxa 打印時選擇“派車單打印”程序抬頭名稱顯示在“制表日期”的下面
# Modify.........: No.FUN-860012 08/06/04 By lala    CR
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-B90169 11/09/22 By Vampire 未清除上次報表殘留值
# Modify.........: No.FUN-CB0002 12/11/09 By lujh CR轉XtraGrid
# Modify.........: No.FUN-D40129 13/05/23 By yangtt 添加小數取位欄位 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  
              wc      LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(500)
              a       LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
              more    LIKE type_file.chr1              #No.FUN-680120 VARCHAR(1)
              END RECORD
DEFINE   g_i          LIKE type_file.num5,         #count/index for any purpose        #No.FUN-680120 SMALLINT
         g_msg        LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(72)
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
             "adk13.adk_file.adk13,",
             "gen02.gen_file.gen02,",
             "adk04.adk_file.adk04,",
             "adk05.adk_file.adk05,",
             "l_adj02.adj_file.adj02,",
             "adk02.adk_file.adk02,",
             "adk14.adk_file.adk14,",
             "gem02.gem_file.gem02,",
             "adk06.adk_file.adk06,",
             "adk07.adk_file.adk07,",
             "adk15.adk_file.adk15,",
             "adk08.adk_file.adk08,",
             "adk09.adk_file.adk09,",
             "l_gen02a.gen_file.gen02,",
             "adk16.adk_file.adk16,",
             "adl02.adl_file.adl02,",
             "adl11.adl_file.adl11,",
             "adl03.adl_file.adl03,",
             "adl04.adl_file.adl04,",
             "oga04.oga_file.oga04,",
             "occ02.occ_file.occ02,",
             "adr.oap_file.oap041,",
             "ogb04.ogb_file.ogb04,",
             "ogb06.ogb_file.ogb06,",
             "ima021.ima_file.ima021,",
             "adl20.adl_file.adl20,",
             "adl05.adl_file.adl05,",
             "l_str.bnb_file.bnb06,",
             "adl06.adl_file.adl06,",
             "adl07.adl_file.adl07,",
             "adl08.adl_file.adl08,",
             "l_adl11.type_file.chr20,",   #FUN-CB0002 add
             "l_n1.type_file.num5"   #FUN-D40129
             
   LET l_table = cl_prt_temptable('atmx170',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED, l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"   #FUN-CB0002 add ?   #FUN-D40129 add 1?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      EXIT PROGRAM
   END IF
#No.FUN-860012---end---
 
   IF NOT cl_null(tm.wc) THEN  
      CALL r205()
   ELSE                                                                         
      CALL r205_tm(0,0)                                                         
   END IF 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION r205_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680120 SMALLINT
       l_cmd          LIKE type_file.chr1000        #No.FUN-680120 VARCHAR(1000)
 
       LET p_row = 4 LET p_col = 11
   OPEN WINDOW r100_w AT p_row,p_col
        WITH FORM "atm//42f/atmx170"       ATTRIBUTE (STYLE = g_win_style CLIPPED)
            
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
           WHEN INFIELD (adk01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_adk01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO adk01
               NEXT FIELD adk01           
           WHEN INFIELD (adk13)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gen"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO adk13
               NEXT FIELD adk13           
           WHEN INFIELD (adk08)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_obw01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO adk08
               NEXT FIELD adk08           
           OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION locale                                                          
          #CALL cl_dynamic_locale()                                             
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
      CLOSE WINDOW r100_w
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
      CLOSE WINDOW r205_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file  
             WHERE zz01='atmr100'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('atmr100','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,     
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,       #No.TQC-610088 add
                         " '",tm.a CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('atmr100',g_time,l_cmd)   
      END IF
      CLOSE WINDOW r100_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r205()
   ERROR ""
END WHILE
   CLOSE WINDOW r100_w
END FUNCTION
 
FUNCTION r205()
   DEFINE l_name    LIKE type_file.chr20,            #No.FUN-680120 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6B0014
          l_sql1    LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(1000)
          l_sql2    LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
          l_za05    LIKE za_file.za05,
          l_order   ARRAY[5] OF LIKE bnb_file.bnb06, #No.FUN-680120 VARCHAR(20) 
          l_occ02   LIKE   occ_file.occ02,
          l_ima021  LIKE   ima_file.ima021,
          l_oap01   LIKE   oap_file.oap01,
          l_oap02   LIKE   oap_file.oap02,
          l_oap03   LIKE   oap_file.oap03,
          l_oap044   LIKE   oap_file.oap044,  #FUN-720014
          l_oap045   LIKE   oap_file.oap045,  #FUN-720014
          l_str      LIKE   bnb_file.bnb06,
          l_gen02a      LIKE gen_file.gen02,
          l_adj02       LIKE adj_file.adj02,
          l_ima906      LIKE ima_file.ima906,
          l_adl14       LIKE adl_file.adl14,
          l_adl17       LIKE adl_file.adl17,
          l_adl08       LIKE adl_file.adl08 ,     #FUN-CB0002  add
          l_adl08_1     LIKE adl_file.adl08 ,     #FUN-CB0002  add
          l_adl08_2     LIKE adl_file.adl08 ,     #FUN-CB0002  add
          l_adl11       LIKE type_file.chr20,     #FUN-CB0002  add
          g_oga     RECORD LIKE oga_file.*,
          g_ogb     RECORD LIKE ogb_file.*,  
          sr1       RECORD 
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
                        gem02  LIKE gem_file.gem02
                    END RECORD,
          sr2       RECORD 
                        adl02  LIKE adl_file.adl02,  
                        adl03  LIKE adl_file.adl03,  
                        adl04  LIKE adl_file.adl04,  
                        adl05  LIKE adl_file.adl05,  
                        adl06  LIKE adl_file.adl06,  
                        adl07  LIKE adl_file.adl07,  
                        adl08  LIKE adl_file.adl08,  
                        adl11  LIKE adl_file.adl11,
                        adl20  LIKE adl_file.adl20,
                        oga04  LIKE oga_file.oga04,
                        adr    LIKE oap_file.oap041,    #No.FUN-680120 VARCHAR(40) 
                        occ02  LIKE occ_file.occ02,
                        ogb04  LIKE ogb_file.ogb04,
                        ogb06  LIKE ogb_file.ogb06,
                        ima021 LIKE ima_file.ima021,
                        adl15  LIKE adl_file.adl15,
                        adl17  LIKE adl_file.adl17,
                        adl12  LIKE adl_file.adl12,
                        adl14  LIKE adl_file.adl14
 
                    END RECORD
     DEFINE l_n1    LIKE type_file.num5   #FUN-D40129 


     CALL cl_del_data(l_table)   #MOD-B90169 add
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     CASE                                                                       
        WHEN tm.a = '0' LET tm.wc = tm.wc CLIPPED," AND adk17 = '0'"            
        WHEN tm.a = '1' LET tm.wc = tm.wc CLIPPED," AND adk17 = '1'"            
        WHEN tm.a = '2' LET tm.wc = tm.wc CLIPPED," AND adk17 = 'S'"            
        WHEN tm.a = '3' LET tm.wc = tm.wc CLIPPED," AND adk17 = 'R'"            
        WHEN tm.a = '4' LET tm.wc = tm.wc CLIPPED," AND adk17 = 'W'"            
     END CASE 
     LET l_sql1 ="SELECT adk01,adk02,adk03,adk04,adk05,adk06,adk07,adk08,",
                 "       adk09,adk13,adk14,adk15,adk16,gen02,gem02",
                 "  FROM adk_file, OUTER gen_file,",
                 "       OUTER gem_file",
                 " WHERE adk_file.adk13 = gen_file.gen01 ", 
                 "   AND adk_file.adk14 = gem_file.gem01 ",
                 "   AND ",tm.wc CLIPPED,
                 " ORDER BY adk01  "
                 
     
     PREPARE r205_prepare1 FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
        EXIT PROGRAM 
     END IF
     DECLARE r205_curs1 CURSOR FOR r205_prepare1
     
#     CALL cl_outnam('atmx170') RETURNING l_name
 
     IF g_sma.sma115 = 'Y' THEN                                                                                                     
        LET g_zaa[59].zaa06 = 'N'                                                                                                   
     ELSE                                                                                                                           
        LET g_zaa[59].zaa06 = 'Y'                                                                                                   
     END IF                                                                                                                         
                                                                                                                                    
     CALL cl_prt_pos_len() 
#No.FUN-860012---start---
#     START REPORT r205_rep TO l_name
     LET g_pageno = 0
 
     FOREACH r205_curs1 INTO sr1.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach_adk:',SQLCA.sqlcode,1) EXIT FOREACH 
       END IF
       LET l_sql2 =" SELECT adl02,adl03,adl04,adl05,adl06,adl07,adl08,adl11, ",
                   " adl20,'','','','','','',adl15,adl17,adl12,adl14  ",
                   " FROM adl_file ",
                   " WHERE adl01 = '",sr1.adk01,"'" ,
                   " ORDER BY adl02 "
       PREPARE r100_prepare2 FROM l_sql2
       IF SQLCA.sqlcode !=0 THEN
          CALL cl_err('prepare2:',SQLCA.sqlcode,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
          EXIT PROGRAM
       END IF
       DECLARE r100_curs2 CURSOR FOR r100_prepare2
    
       IF NOT cl_null(sr1.adk01) THEN
          FOREACH r100_curs2 INTO sr2.*
            IF SQLCA.sqlcode !=0 THEN
               CALL cl_err('foreach_adl:',SQLCA.sqlcode,1) EXIT FOREACH
            END IF 
            IF (NOT cl_null(sr2.adl03)) AND 
               (NOT cl_null(sr2.adl04)) THEN
                SELECT oga_file.*,ogb_file.* INTO g_oga.*,g_ogb.*
                  FROM oga_file,ogb_file
                 WHERE oga01=ogb01 
                   AND oga01=sr2.adl03
                   AND ogb03=sr2.adl04
                IF SQLCA.sqlcode != 100 AND SQLCA.sqlcode !=0 THEN
#                  CALL cl_err('',SQLCA.sqlcode,1)  #No.FUN-660104 MARK
                   CALL cl_err3("sel","oga_file,ogb_file",sr2.adl03,sr2.adl04,SQLCA.sqlcode,"","",1)  #No.FUN-660104
                END IF
                LET sr2.oga04=g_oga.oga04
                IF NOT cl_null(g_oga.oga04) THEN
                   SELECT occ02 INTO l_occ02 FROM occ_file
                    WHERE occ01=g_oga.oga04
                   IF SQLCA.sqlcode = 0 THEN
                      LET sr2.occ02 = l_occ02
                   END IF
                END IF
                CALL s_addr(g_oga.oga01,g_oga.oga04,g_oga.oga044)
                     RETURNING l_oap01,l_oap02,l_oap03,l_oap044,l_oap045   #FUN-720014 add 044/045
                LET sr2.adr = l_oap01 CLIPPED,'',l_oap02 CLIPPED,'',
                              l_oap03 CLIPPED,'',
                              l_oap044 CLIPPED,'',l_oap045 CLIPPED
                LET sr2.ogb04 = g_ogb.ogb04
                IF NOT cl_null(g_ogb.ogb04) THEN
                   SELECT ima021 INTO l_ima021 FROM ima_file
                    WHERE ima01 = g_ogb.ogb04
                   IF SQLCA.sqlcode = 0 THEN
                      LET sr2.ima021=l_ima021
                   END IF
                END IF
                LET sr2.ogb06=g_ogb.ogb06
            END IF
 
#            OUTPUT TO REPORT r205_rep(sr1.*,sr2.*)
          IF NOT cl_null(sr1.adk09) THEN
             SELECT gen02 INTO l_gen02a
               FROM gen_file
              WHERE gen01=sr1.adk09
          END IF
          IF NOT cl_null(sr1.adk03) THEN
             SELECT adj02 INTO l_adj02
               FROM adj_file
              WHERE adj01=sr1.adk03
          END IF
          SELECT ima906 INTO l_ima906 FROM ima_file
             WHERE ima01 = sr2.ogb04
          IF g_sma.sma115 = "Y" THEN
               CASE l_ima906
                  WHEN "2"
                      CALL cl_remove_zero(sr2.adl17) RETURNING l_adl17
                      LET l_str = l_adl17 USING '<<<<<<.<<' , sr2.adl15 CLIPPED 
                      IF cl_null(sr2.adl17) OR sr2.adl17 = 0 THEN          
                          CALL cl_remove_zero(sr2.adl14) RETURNING l_adl14
                          LET l_str = l_adl14 USING '<<<<<<.<<', sr2.adl12 CLIPPED        
                      ELSE                                             
                        IF NOT cl_null(sr2.adl14) AND sr2.adl14 > 0 THEN   
                           CALL cl_remove_zero(sr2.adl14) RETURNING l_adl14            
                           LET l_str = l_str CLIPPED,',',l_adl14 USING '<<<<<<.<<', sr2.adl12 CLIPPED                                                 
                        END IF               
                      END IF               
                  WHEN "3"
                      IF NOT cl_null(sr2.adl17) AND sr2.adl17 > 0 THEN
                         CALL cl_remove_zero(sr2.adl17) RETURNING l_adl17
                         LET l_str = l_adl17 USING '<<<<<<.<<' , sr2.adl15 CLIPPED 
                      END IF 
               END CASE
           END IF
     #FUN-CB0002--add--str--  
     IF cl_null(sr2.adl08) THEN 
        LET l_adl08 = ''
     ELSE 
        LET l_adl08_1 = sr2.adl08[1,2]  
        LET l_adl08_2 = sr2.adl08[3,4]    
        LET l_adl08 = l_adl08_1,':',l_adl08_2
     END IF 
     IF sr2.adl11 = '1' THEN 
        LET l_adl11 = cl_getmsg('axm-485',g_lang)
     END IF 
     IF sr2.adl11 = '2' THEN 
        LET l_adl11 = cl_getmsg('axm-486',g_lang)
     END IF
     IF sr2.adl11 = '3' THEN 
        LET l_adl11 = cl_getmsg('atm-085',g_lang)
     END IF 
     #FUN-CB0002--add--end--
     LET l_n1 = 2   #FUN-D40129
     EXECUTE insert_prep USING
        sr1.adk01,sr1.adk13,sr1.gen02,sr1.adk04,sr1.adk05,l_adj02,sr1.adk02,sr1.adk14,sr1.gem02,sr1.adk06,
        sr1.adk07,sr1.adk15,sr1.adk08,sr1.adk09,l_gen02a,sr1.adk16,sr2.adl02,sr2.adl11,sr2.adl03,sr2.adl04,
        sr2.oga04,sr2.occ02,sr2.adr,sr2.ogb04,sr2.ogb06,sr2.ima021,sr2.adl20,sr2.adl05,l_str,
        sr2.adl06,sr2.adl07,l_adl08,l_adl11
        ,l_n1    #FUN-D40129
     END FOREACH
     END IF
     END FOREACH
###XtraGrid###     LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     #FUN-CB0002--mark--str--
     #CALL cl_wcchp(tm.wc,'adk01,adk02,adk13,adk08')
     #        RETURNING tm.wc
     #FUN-CB0002--mark--end--
###XtraGrid###     LET g_str=tm.wc
###XtraGrid###     CALL cl_prt_cs3('atmx170','atmx170',g_sql,g_str)
    LET g_xgrid.table = l_table    ###XtraGrid###
    LET g_xgrid.order_field = "adk01,adk02,adk13,adk08"
    LET g_xgrid.grup_field = "adk01"
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'adk01,adk02,adk13,adk08') 
            RETURNING tm.wc
    END IF
    LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc
    CALL cl_xg_view()    ###XtraGrid###
 
 
#     FINISH REPORT r205_rep
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
#REPORT r205_rep(sr1,sr2)
#  DEFINE l_last_sw    LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
#         sr1          RECORD
#                          adk01  LIKE adk_file.adk01,  
#                          adk02  LIKE adk_file.adk02,  
#                          adk03  LIKE adk_file.adk03,  
#                          adk04  LIKE adk_file.adk04,
#                          adk05  LIKE adk_file.adk05,
#                          adk06  LIKE adk_file.adk06,
#                          adk07  LIKE adk_file.adk07,
#                          adk08  LIKE adk_file.adk08,
#                          adk09  LIKE adk_file.adk09,
#                          adk13  LIKE adk_file.adk13,
#                          adk14  LIKE adk_file.adk14,
#                          adk15  LIKE adk_file.adk15,
#                          adk16  LIKE adk_file.adk16,
#                          gen02  LIKE gen_file.gen02,
#                          gem02  LIKE gem_file.gem02
#                      END RECORD,
#         sr2          RECORD
#                          adl02  LIKE adl_file.adl02,
#                          adl03  LIKE adl_file.adl03,
#                          adl04  LIKE adl_file.adl04,
#                          adl05  LIKE adl_file.adl05,
#                          adl06  LIKE adl_file.adl06,
#                          adl07  LIKE adl_file.adl07,
#                          adl08  LIKE adl_file.adl08,
#                          adl11  LIKE adl_file.adl11,
#                          adl20  LIKE adl_file.adl20,
#                          oga04  LIKE oga_file.oga04,
#                          adr    LIKE oap_file.oap041,                #No.FUN-680120 VARCHAR(40)
#                          occ02  LIKE occ_file.occ02,
#                          ogb04  LIKE ogb_file.ogb04,
#                          ogb06  LIKE ogb_file.ogb06,
#                          ima021 LIKE ima_file.ima021,
#                          adl15  LIKE adl_file.adl15,
#                          adl17  LIKE adl_file.adl17,
#                          adl12  LIKE adl_file.adl12,
#                          adl14  LIKE adl_file.adl14
#                      END RECORD
# DEFINE l_gen02a      LIKE gen_file.gen02,
#        l_adj02       LIKE adj_file.adj02,
#        l_ima906      LIKE ima_file.ima906,
#        l_str         LIKE bnb_file.bnb06,      #No.FUN-680120 VARCHAR(20) 
#        l_adl14       LIKE adl_file.adl14,
#        l_adl17       LIKE adl_file.adl17
##        l_adl_1       LIKE apm_file.apm08,      #No.FUN-680120 VARCHAR(10) # TQC-6A0079 
##        l_adl_2       LIKE apm_file.apm08       #No.FUN-680120 VARCHAR(10) # TQC-6A0079
 
  
# OUTPUT TOP MARGIN g_top_margin                                                                                                               
#        LEFT MARGIN g_left_margin                                                                                                              
#        BOTTOM MARGIN g_bottom_margin                                                                                                            
#        PAGE LENGTH g_page_line  
 
# ORDER BY sr1.adk01 ,sr2.adl02
# 
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED                     
#     PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]      #TQC-790033                     
#           LET g_pageno = g_pageno + 1                                         
#           LET pageno_total = PAGENO USING '<<<',"/pageno"                     
#           PRINT g_head CLIPPED,pageno_total                                   
##     PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]   #TQC-790033                           
#     PRINT ' '                                                                 
#     PRINT g_dash[1,g_len]
#     
#     BEFORE GROUP OF sr1.adk01
#         SKIP TO TOP OF PAGE
#         
#         IF NOT cl_null(sr1.adk09) THEN
#            SELECT gen02 INTO l_gen02a
#              FROM gen_file
#             WHERE gen01=sr1.adk09
#         END IF
#         IF NOT cl_null(sr1.adk03) THEN
#            SELECT adj02 INTO l_adj02
#              FROM adj_file
#             WHERE adj01=sr1.adk03
#         END IF
#         
#     PRINT COLUMN  1,g_x[31] CLIPPED, sr1.adk01 CLIPPED,
#           COLUMN 35,g_x[34] CLIPPED, sr1.adk13 CLIPPED,
#           COLUMN 50,sr1.gen02 CLIPPED,
#           COLUMN 86,g_x[37] CLIPPED, sr1.adk04 CLIPPED,' ',sr1.adk05,
#           COLUMN 117,g_x[39] CLIPPED, l_adj02
#     PRINT COLUMN  1,g_x[32] CLIPPED, sr1.adk02 CLIPPED,
#           COLUMN 35,g_x[35] CLIPPED, sr1.adk14 CLIPPED,
#           COLUMN 50,sr1.gem02 CLIPPED,
#           COLUMN 86,g_x[38] CLIPPED, sr1.adk06 CLIPPED,' ',sr1.adk07,
#           COLUMN 117,g_x[40] CLIPPED, sr1.adk15
#     PRINT COLUMN  1,g_x[33] CLIPPED, sr1.adk08,
#           COLUMN 35,g_x[36] CLIPPED, sr1.adk09,
#           COLUMN 50,l_gen02a CLIPPED,
#           COLUMN 86,g_x[41] CLIPPED, sr1.adk16
#     PRINT 
#     PRINT  g_dash2[1,g_len]
#     PRINTX name=H1 g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],
#                    g_x[49],g_x[50],g_x[51],g_x[52],g_x[53],g_x[59],g_x[54],g_x[55],g_x[56]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
#     
#     ON EVERY ROW
#        PRINTX name=D1
#           COLUMN g_c[42], sr2.adl02 USING '###&';
#           IF NOT cl_null(sr2.adl11) THEN
#              CASE
#              WHEN sr2.adl11='1'
#                PRINTX name=D1 
#                COLUMN g_c[43], g_x[57] CLIPPED;
#              WHEN sr2.adl11='2'
#                PRINTX name=D1 
#                COLUMN g_c[43], g_x[58] CLIPPED;
#               OTHERWISE EXIT CASE 
#             END CASE
#           END IF
#        PRINTX name= D1
#           COLUMN g_c[44], sr2.adl03 CLIPPED,
#           COLUMN g_c[45], sr2.adl04 USING '#######&',
#           COLUMN g_c[46], sr2.oga04 CLIPPED,
#           COLUMN g_c[47], sr2.occ02 CLIPPED,
#           COLUMN g_c[48], sr2.adr   CLIPPED,
#           COLUMN g_c[49], sr2.ogb04 CLIPPED,
#           COLUMN g_c[50], sr2.ogb06 CLIPPED,
#           COLUMN g_c[51], sr2.ima021 CLIPPED,
#           COLUMN g_c[52], sr2.adl20 CLIPPED,
#           COLUMN g_c[53], sr2.adl05 USING '-----------&.&&';
#           #單位注解 
#           SELECT ima906 INTO l_ima906 FROM ima_file
#            WHERE ima01 = sr2.ogb04
#           IF g_sma.sma115 = "Y" THEN
#              CASE l_ima906
#                 WHEN "2"
#                     CALL cl_remove_zero(sr2.adl17) RETURNING l_adl17
#                     LET l_str = l_adl17 USING '<<<<<<.<<' , sr2.adl15 CLIPPED 
#                     IF cl_null(sr2.adl17) OR sr2.adl17 = 0 THEN          
#                         CALL cl_remove_zero(sr2.adl14) RETURNING l_adl14
#                         LET l_str = l_adl14 USING '<<<<<<.<<', sr2.adl12 CLIPPED        
#                     ELSE                                             
#                       IF NOT cl_null(sr2.adl14) AND sr2.adl14 > 0 THEN   
#                          CALL cl_remove_zero(sr2.adl14) RETURNING l_adl14            
#                          LET l_str = l_str CLIPPED,',',l_adl14 USING '<<<<<<.<<', sr2.adl12 CLIPPED                                                 
#                       END IF               
#                     END IF               
#                 WHEN "3"
#                     IF NOT cl_null(sr2.adl17) AND sr2.adl17 > 0 THEN
#                        CALL cl_remove_zero(sr2.adl17) RETURNING l_adl17
#                        LET l_str = l_adl17 USING '<<<<<<.<<' , sr2.adl15 CLIPPED 
#                     END IF 
#              END CASE
#              PRINT COLUMN g_c[59],l_str;
#           END IF       
#           PRINT  COLUMN g_c[54], sr2.adl06 USING '-----------&.&&',
#                  COLUMN g_c[55], sr2.adl07 CLIPPED,
#                  COLUMN g_c[56], sr2.adl08 CLIPPED
#           
#           
#           
#           
#           
#     
#  ON LAST ROW
#     LET l_last_sw = 'y'
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash[1,g_len]
#             PRINT g_x[4] CLIPPED,COLUMN 31,g_x[5] CLIPPED, 
#                   COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE 
#        PRINT g_dash[1,g_len]
#        PRINT g_x[4] CLIPPED,COLUMN 31,g_x[5] CLIPPED, 
#              COLUMN (g_len-9), g_x[7] CLIPPED
#     END IF
#        
#     
#           
#END REPORT             
#No.FUN-860012---e


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
