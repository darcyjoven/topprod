# Prog. Version..: '5.30.06-13.03.12(00002)'     #
# 
# Pattern name...: aicr047.4gl
# Descriptions...: wafer轉code通知單
# Return code....:
# Date & Author..: No.FUN-7B0027 01/04/2008 zhangyajun 
# Modify FUN-7B0027
# Modify FUN-830068
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60027 10/06/07 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No:FUN-B90044 11/09/05 By lujh 程序撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global" 
 
   DEFINE tm  RECORD				
	      
	  wc  	STRING,		       
          more  LIKE type_file.chr1 		
              END RECORD
 
DEFINE   g_i  LIKE type_file.num5   
DEFINE   l_table STRING 
DEFINE   g_str   STRING 
DEFINE   g_sql   STRING
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CPM")) THEN
      EXIT PROGRAM
   END IF
 
   IF NOT s_industry("icd") THEN                                                
      CALL cl_err('','aic-999',1)                                               
      EXIT PROGRAM
   END IF
 
   LET g_sql="pmm01.pmm_file.pmm01,",
             "pmm09.pmm_file.pmm09,",
             "pmn02.pmn_file.pmn02,",
             "pmniicd14.pmni_file.pmniicd14,",
             "pmn04.pmn_file.pmn04,",
             "pmn87.pmn_file.pmn87,",
             "pmn86.pmn_file.pmn86,",
             "chr1000.type_file.chr1000,",
             "pmc03.pmc_file.pmc03,",
             "pmniicd01.pmni_file.pmniicd01,",
             "oeb03.oeb_file.oeb03,",
             "pmniicd04.pmni_file.pmniicd04,",
             "pmniicd05.pmni_file.pmniicd05,",
             "pmniicd15.pmni_file.pmniicd15,",
             "gen02.gen_file.gen02"
   LET l_table=cl_prt_temptable('aicr047',g_sql)CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?,?,?,?,?,",
                      "?,?,?,?,?,?)"                    
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
   LET g_pdate = ARG_VAL(1)		
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #FUN-B90044
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	
      THEN CALL r047_tm(0,0)	
      ELSE CALL aicr047()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
END MAIN
 
FUNCTION r047_tm(p_row,p_col)
   DEFINE lc_qbe_sn     LIKE gbm_file.gbm01   
   DEFINE p_row,p_col	LIKE type_file.num5,
          l_cmd	        LIKE type_file.chr1000
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW r047_w AT p_row,p_col WITH FORM "aic/42f/aicr047"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pmm01,pmm04
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
     ON ACTION locale
          CALL cl_show_fld_cont()                   
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r047_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.more 		
   INPUT BY NAME tm.more WITHOUT DEFAULTS
 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
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
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r047_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	
             WHERE zz01='aicr047'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aicr047','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",           
                         " '",g_rep_user CLIPPED,"'",          
                         " '",g_rep_clas CLIPPED,"'",           
                         " '",g_template CLIPPED,"'"            
         CALL cl_cmdat('aicr047',g_time,l_cmd)	
      END IF
      CLOSE WINDOW r047_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aicr047()
   ERROR ""
END WHILE
   CLOSE WINDOW r047_w
END FUNCTION
 
FUNCTION aicr047()
   DEFINE l_name LIKE type_file.chr20,		
          l_time LIKE type_file.chr8,		
          l_sql 	STRING,		        
          l_za05 LIKE za_file.za05,
          sr            RECORD
                               pmm01    LIKE pmm_file.pmm01,
                               pmm09    LIKE pmm_file.pmm09,
                               pmm22    LIKE pmm_file.pmm22, 
                               pmn02    LIKE pmn_file.pmn02,
                               pmn04    LIKE pmn_file.pmn04,
                               pmn041   LIKE pmn_file.pmn041,
                               pmn20    LIKE pmn_file.pmn20,     
                               pmn31    LIKE pmn_file.pmn31,
                               pmm04    LIKE pmm_file.pmm04,
                               pmn33    LIKE pmn_file.pmn33,
                               pmniicd16 LIKE pmni_file.pmniicd16,
                               pmniicd01 LIKE pmni_file.pmniicd01,
                               pmniicd02 LIKE pmni_file.pmniicd02,
                               pmniicd15 LIKE pmni_file.pmniicd15,
                               pmn41    LIKE pmn_file.pmn41,      
                               pmn86    LIKE pmn_file.pmn86,	  
                               pmn87    LIKE pmn_file.pmn87,
                               pmniicd04    LIKE pmni_file.pmniicd04,	#NewCode
                               pmniicd05    LIKE pmni_file.pmniicd05,	#LowYield
                               pmniicd14 LIKE pmni_file.pmniicd14,
                               pmniicd18 LIKE pmni_file.pmniicd18,	
                               pmn56    LIKE pmn_file.pmn56	
                        END RECORD
     DEFINE l_ima021        LIKE ima_file.ima021  
     DEFINE l_pmc03         LIKE pmc_file.pmc03 
     DEFINE icm02           LIKE icm_file.icm02		
     DEFINE l_username      LIKE gen_file.gen02
     DEFINE l_sfa30         LIKE sfa_file.sfa30
     DEFINE l_sfa31         LIKE sfa_file.sfa31
     DEFINE l_sfaiicd03     LIKE sfai_file.sfaiicd03
      DEFINE l_sfb08         LIKE sfb_file.sfb08
      DEFINE l_sfb081        LIKE sfb_file.sfb081
     DEFINE l_sfbiicd01      LIKE sfbi_file.sfbiicd01
     
     DEFINE l_oeb15         LIKE oeb_file.oeb15
     DEFINE l_oeb03         LIKE oeb_file.oeb03
     DEFINE l_oeb917        LIKE oeb_file.oeb917
     DEFINE l_oebiicd03       LIKE oebi_file.oebiicd03    
     DEFINE l_orderqty      LIKE oeb_file.oeb15
     DEFINE l_oao06         LIKE oao_file.oao06
     DEFINE l_img10         LIKE img_file.img10
     DEFINE l_mask_layer    LIKE type_file.chr1000
     DEFINE l_pmc03_2       LIKE pmc_file.pmc03
           
     DEFINE l_pmm01       LIKE pmm_file.pmm01
     DEFINE l_ice05       LIKE ice_file.ice05
     DEFINE l_pmniicd04   LIKE pmni_file.pmniicd04 
     DEFINE l_pmniicd05   LIKE pmni_file.pmniicd05
     DEFINE l_ice09       LIKE ice_file.ice09    
     DEFINE  l_ice06  LIKE ice_file.ice06
     DEFINE l_ima03 LIKE ima_file.ima03
 
     #CALL cl_used(g_prog,l_time,1) RETURNING l_time     #FUN-B90044   MARK
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                          
     #     END IF
     #     IF g_priv3='4' THEN                          
     #         LET tm.wc = tm.wc clipped," AND pmmgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    
     #         LET tm.wc = tm.wc clipped," AND pmmgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('user', 'grup')
     #End:FUN-980030
 
 
        LET l_sql = "SELECT ",
                 " pmm01,pmm09,pmm22,pmn02,pmn04,pmn041,pmn20,pmn31",
		 ",pmm04,pmn33,pmniicd16,pmniicd01,pmniicd02,pmniicd15,pmn41",
		 ",pmn86,pmn87,pmniicd04,pmniicd05,pmniicd14,pmniicd18,pmn56",
                 "  FROM pmm_file,pmn_file,pmni_file ",
                 " WHERE pmm01 = pmn01 ",
                 " AND pmn01 = pmni01 ",
                 " AND pmn02 = pmni02 ",
                 " AND pmm02='SUB' ",
                 "   AND pmn16 IN ('2') AND ",tm.wc
 
     PREPARE r047_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
        EXIT PROGRAM
     END IF
     DECLARE r047_curs1 CURSOR FOR r047_prepare1
 
     FOREACH r047_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
     
      SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
             FROM azi_file WHERE azi01=sr.pmm22
      SELECT ima021 INTO l_ima021 FROM ima_file WHERE ima01=sr.pmn04
      IF SQLCA.sqlcode THEN
          LET l_ima021 = NULL
      END IF
      
      SELECT sfa30,sfa31,sfaiicd03 INTO l_sfa30,l_sfa31,l_sfaiicd03 
              FROM sfa_file,sfai_file WHERE sfa01=sr.pmn41 AND sfa012 = sfai012
               AND afa013 = sfai013  #FUN-A60027 add sfa012,sfa013
      SELECT sfb08,sfb081 INTO l_sfb08,l_sfb081 FROM sfb_file WHERE sfb01=sr.pmn41 and sfb05=sr.pmn04
      SELECT oeb03,oeb15,oeb917,oebiicd03 INTO l_oeb03,l_oeb15,l_oeb917,l_oebiicd03 FROM oeb_file,oebi_file 
                 WHERE oeb01=sr.pmniicd01 and oeb03=sr.pmniicd02 
      LET l_orderqty=l_oeb917+(l_oeb917*l_oebiicd03/100)
      
      SELECT oao06 INTO l_oao06 FROM oao_file WHERE oao01=sr.pmniicd01 AND oao03=sr.pmniicd02
      IF SQLCA.sqlcode THEN  LET l_oao06 = NULL  END IF
      SELECT img10 INTO l_img10 FROM img_file WHERE img01 LIKE sr.pmn04+'%' AND img02=l_sfa30 
                                               AND img03 LIKE l_sfa31+'%' AND img04 LIKE sr.pmniicd16+'%'
      IF SQLCA.sqlcode THEN  LET l_img10 = NULL  END IF
      SELECT pmc03 INTO l_pmc03_2 FROM pmc_file WHERE pmc01=sr.pmniicd18
      IF SQLCA.sqlcode THEN  LET l_pmc03_2 = NULL  END IF   
      IF sr.pmniicd04='N' THEN
         LET l_pmniicd04=NULL 
         LET l_pmniicd05=NULL
      ELSE
         LET l_pmniicd04=sr.pmniicd04 
         LET l_pmniicd05=sr.pmniicd05
      END IF
 
      LET l_mask_layer=NULL
      DECLARE ima_cur2 CURSOR FOR	
      SELECT (ice05||ice06),ice09,ice06 FROM ice_file WHERE ice02=sr.pmniicd14 
      AND ice04 >=(SELECT ice04 FROM ice_file WHERE ice02=sr.pmniicd14 AND ice08='Y')
      ORDER BY ice04
      
      FOREACH ima_cur2 INTO l_ice05,l_ice09,l_ice06
        IF NOT cl_null(l_ice09) THEN
	   SELECT ima03 INTO l_ima03 FROM ima_file WHERE ima01=sr.pmn04
	   IF SQLCA.sqlcode THEN  LET l_ima03 = NULL  END IF 
	   LET l_ice05=l_ice05,'-',l_ima03
        END IF
        IF (l_ice06<>'A') OR (NOT cl_null(l_ice09))  then
	   IF NOT cl_null(l_mask_layer) then	        
	      LET l_mask_layer=l_mask_layer,',',l_ice05
	   ELSE
	      LET l_mask_layer=l_mask_layer,l_ice05
	   END IF
        END IF
      END FOREACH 
      
     SELECT gen02 INTO l_username FROM gen_file WHERE gen01=g_user    
     EXECUTE insert_prep USING sr.pmm01,sr.pmm09,
        sr.pmn02,sr.pmniicd14,sr.pmn04,sr.pmn87,sr.pmn86,
        l_mask_layer,l_pmc03_2,sr.pmniicd01,l_oeb03,l_pmniicd04,
        l_pmniicd05,sr.pmniicd15,l_username
     END FOREACH
     
     LET g_sql="SELECT  * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   
     CALL cl_wcchp(tm.wc,'pmm01,pmm04')
             RETURNING tm.wc
     LET g_str=tm.wc
     CALL cl_prt_cs3('aicr047','aicr047',g_sql,g_str)
END FUNCTION
# Modify FUN-7B0027
# Modify FUN-830068
