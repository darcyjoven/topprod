# Prog. Version..: '5.10.05-08.12.18(00009)'     #
# Pattern name...: apsp510.4gl 
# Descriptions...: APS 請購單產生作業
# Date & Author..: 03/03/27 By Kammy
# Modify.........: No:FUN-730056 07/03/27 By Mandy APS 相關調整,並刪除程式不相干的垃圾段
# Modify.........: No:TQC-750167 07/05/24 By Joe l_sql錯誤,造成資料無法轉出
# Modify.........: No:FUN-7B0018 08/01/31 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE

DATABASE ds

GLOBALS "../../config/top.global"

GLOBALS                                                                                                                             
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04 #FUN-730056
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10                                                                                         
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11                                                                                         
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17   
  DEFINE g_seq_item     LIKE type_file.num5  
END GLOBALS 

DEFINE g_apsspo		RECORD LIKE apsspo.*
DEFINE g_pmk		RECORD LIKE pmk_file.*
DEFINE g_pml		RECORD LIKE pml_file.*
DEFINE ver_no		LIKE type_file.chr2   
DEFINE mxno  		LIKE type_file.num10  
DEFINE summary_flag	LIKE type_file.chr1   
DEFINE g_t1    	        LIKE type_file.chr5   
DEFINE l_za05  	        LIKE type_file.chr1000
DEFINE g_wc,g_sql	string                
DEFINE i,j,k		LIKE type_file.num10  
DEFINE g_pmkmksg        LIKE pmk_file.pmkmksg
DEFINE g_pmksign        LIKE pmk_file.pmksign
DEFINE g_pmkdays        LIKE pmk_file.pmkdays
DEFINE g_pmkprit        LIKE pmk_file.pmkprit
DEFINE g_smydmy4        LIKE smy_file.smydmy4
DEFINE g_apsdb          LIKE type_file.chr21
DEFINE g_sma115         LIKE sma_file.sma115
DEFINE l_sql            LIKE type_file.chr1000  
DEFINE l_zaa02          LIKE zaa_file.zaa02
DEFINE g_change_lang    LIKE type_file.chr1     
DEFINE g_i              LIKE type_file.num5     
DEFINE g_msg            LIKE ze_file.ze03       
DEFINE g_pmk01          LIKE pmk_file.pmk01     
MAIN
   DEFINE   l_time      LIKE type_file.chr8     
   DEFINE   p_row,p_col LIKE type_file.num5     
   DEFINE   l_flag      LIKE type_file.chr1     
   DEFINE   ls_date     STRING                  

   OPTIONS
       FORM LINE     FIRST + 2,
       MESSAGE LINE  LAST,
       PROMPT LINE   LAST,
       INPUT NO WRAP
   DEFER INTERRUPT				 

   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc     = ARG_VAL(1)             #QBE條件
   LET ls_date  = ARG_VAL(2)
   LET g_pmk.pmk04 = cl_batch_bg_date_convert(ls_date)
   LET g_pmk.pmk01 = ARG_VAL(3)
   LET g_pmk.pmk12 = ARG_VAL(4)
   LET g_pmk.pmk13 = ARG_VAL(5)
   LET summary_flag = ARG_VAL(6)
   LET mxno = ARG_VAL(7)
   LET g_bgjob = ARG_VAL(8)    #背景作業
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF


   CALL cl_used(g_prog,l_time,1) RETURNING l_time 

   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang

   WHILE TRUE
      IF g_bgjob = "N" THEN
         INITIALIZE g_pmk.* TO NULL
         CALL s_getdbs_curr(aps_saz.saz01) RETURNING g_apsdb
         LET g_apsdb = g_apsdb CLIPPED
         SELECT MAX(smyslip) INTO g_pmk.pmk01 FROM smy_file
          WHERE smysys='apm' AND smykind='1'
         LET g_pmk.pmk04 = TODAY
         LET g_pmk.pmk12 = g_user
         LET summary_flag= '1'
         LET mxno      = 20
         SELECT gen03 INTO g_pmk.pmk13 FROM gen_file WHERE gen01=g_user

         CALL p510_ask()               # Ask for first_flag, data range or exist
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
            CALL p510()
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p510
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         BEGIN WORK
         CALL p510()
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
 END WHILE
 CALL cl_used(g_prog,l_time,2) RETURNING l_time 
END MAIN

FUNCTION p510_ask()
   DEFINE   l_gen02   LIKE gen_file.gen02,
            l_gen03   LIKE gen_file.gen03,
            l_gem02   LIKE gem_file.gem02
   DEFINE   li_result LIKE type_file.num5     
   DEFINE   lc_cmd    LIKE type_file.chr1000
   DEFINE   p_row,p_col LIKE type_file.num5 

   OPEN WINDOW p510_w AT p_row,p_col
        WITH FORM "aps/42f/apsp510" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   
   CALL cl_ui_init()

   INITIALIZE g_pmk.* TO NULL
   LET g_plant_new = aps_saz.saz01
   CALL s_getdbs()
   SELECT MAX(smyslip) INTO g_pmk.pmk01 FROM smy_file
         WHERE smysys='apm' AND smykind='1'
   LET g_pmk.pmk04 = TODAY
   LET g_pmk.pmk12 = g_user
   LET summary_flag= '1'
   LET mxno      = 20
   SELECT gen03 INTO g_pmk.pmk13 FROM gen_file WHERE gen01=g_user
   WHILE TRUE

   CONSTRUCT BY NAME g_wc ON pid,sup_id
      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION locale
         LET g_change_lang = TRUE       
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
 
      ON ACTION qbe_select
         CALL cl_qbe_select()

   END CONSTRUCT
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()    
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p510
      EXIT PROGRAM
   END IF
   LET g_bgjob = 'N' 
   INPUT BY NAME g_pmk.pmk04,g_pmk.pmk01,g_pmk.pmk12,g_pmk.pmk13,
                 summary_flag,mxno,
                 g_bgjob  
                 WITHOUT DEFAULTS  
      AFTER FIELD pmk04
         IF g_pmk.pmk04 IS NULL THEN
            NEXT FIELD pmk04
         END IF
      AFTER FIELD pmk01
         IF g_pmk.pmk01 IS NULL THEN
            NEXT FIELD pmk01
         END IF
         LET g_t1=g_pmk.pmk01[1,g_doc_len]
         CALL s_check_no("apm",g_pmk.pmk01,"","1","","","")
              RETURNING li_result,g_pmk.pmk01
         DISPLAY BY NAME g_pmk.pmk01
         IF (NOT li_result) THEN
              NEXT FIELD pmk01
         END IF

         CALL s_auto_assign_no("apm",g_pmk.pmk01,g_pmk.pmk04,"1","pmk_file","pmk01",
              "","","")
         RETURNING li_result,g_pmk.pmk01
         DISPLAY BY NAME g_pmk.pmk01

         SELECT smyapr,smysign,smydays,smyprit,smydmy4
           INTO g_pmkmksg,g_pmksign,g_pmkdays,g_pmkprit,g_smydmy4
           FROM smy_file WHERE smyslip=g_t1
         IF STATUS THEN 
            LET g_pmkmksg = 'N'
            LET g_pmksign = ''
            LET g_pmkdays = 0
            LET g_pmkprit = ''
         END IF 
         IF cl_null(g_pmkmksg) THEN
            LET g_pmkmksg = 'N' 
         END IF 

      AFTER FIELD pmk12
         IF cl_null(g_pmk.pmk12) THEN
            NEXT FIELD pmk12
         END IF
         SELECT gen02,gen03 INTO l_gen02,l_gen03
           FROM gen_file   WHERE gen01 = g_pmk.pmk12
            AND genacti = 'Y'
         IF SQLCA.sqlcode THEN
            CALL cl_err3("sel","gen_file",g_pmk.pmk12,"","mfg1312","","",0)  
            DISPLAY BY NAME g_pmk.pmk13 
            NEXT FIELD pmk12
         END IF

      BEFORE FIELD pmk13
         IF cl_null(g_pmk.pmk13) THEN
            LET g_pmk.pmk13 = l_gen03
         END IF

      AFTER FIELD pmk13
         IF cl_null(g_pmk.pmk13)  THEN
            NEXT FIELD pmk13
         END IF
         SELECT gem02 INTO l_gem02
           FROM gem_file  WHERE gem01 = g_pmk.pmk13
            AND gemacti = 'Y'
         IF SQLCA.sqlcode THEN
            CALL cl_err3("sel","gem_file",g_pmk.pmk13,"","mfg3097","","",0)  
            DISPLAY BY NAME g_pmk.pmk13 
            NEXT FIELD pmk13
         END IF

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pmk01) #order nubmer
                  LET g_t1=s_get_doc_no(g_pmk.pmk01)           
                  CALL q_smy(FALSE,FALSE,g_t1,'APM','1') RETURNING g_t1 
                  LET g_pmk.pmk01=g_t1                         
                  DISPLAY BY NAME g_pmk.pmk01 
                  NEXT FIELD pmk01
               WHEN INFIELD(pmk12) #請購員
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  LET g_qryparam.default1 = g_pmk.pmk12
                  CALL cl_create_qry() RETURNING g_pmk.pmk12
                  DISPLAY BY NAME g_pmk.pmk12 
                  NEXT FIELD pmk12
               WHEN INFIELD(pmk13) #請購Dept
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.default1 = g_pmk.pmk13
                  CALL cl_create_qry() RETURNING g_pmk.pmk13
                  DISPLAY BY NAME g_pmk.pmk13 
                  NEXT FIELD pmk13
               OTHERWISE
                  EXIT CASE
            END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
   
      ON ACTION qbe_save
         CALL cl_qbe_save()

      ON ACTION locale
        LET g_change_lang = TRUE       
        EXIT INPUT

   END INPUT
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p510
      EXIT PROGRAM
   END IF
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "apsp510"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('apsp510','9031',1)      
      ELSE
         LET g_wc=cl_replace_str(g_wc, "'", "\"")
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",g_wc CLIPPED,"'",
                      " '",g_pmk.pmk04 CLIPPED,"'",
                      " '",g_pmk.pmk01 CLIPPED,"'",
                      " '",g_pmk.pmk12 CLIPPED,"'",
                      " '",g_pmk.pmk13 CLIPPED,"'",
                      " '",summary_flag CLIPPED,"'",
                      " '",mxno CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('apsp510',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p510
      EXIT PROGRAM
   END IF
   EXIT WHILE
END WHILE
END FUNCTION

FUNCTION p510()
   DEFINE l_name	  LIKE type_file.chr20   
   DEFINE l_order         LIKE ima_file.ima43   
   DEFINE l_ima06         LIKE ima_file.ima06
   DEFINE l_ima43         LIKE ima_file.ima43
   DEFINE l_ima54         LIKE ima_file.ima54
  #DEFINE l_pmc15         LIKE pmc_file.pmc15   #TQC-750167
   DEFINE l_str           LIKE type_file.num5  
   DEFINE l_i,l_cnt       LIKE type_file.num5 

   ##TQC-750167-------------------------------------------------------------
   ##經與鼎誠討論確認,若PO中is_new='1',則不管是否有sup_id,統一抓ima54做為
   ##預設請購廠商
 ##LET g_sql="SELECT ",g_apsdb CLIPPED," apsspo.*,ima06,ima43,ima54,pmc15", #TQC-750167
   LET g_sql="SELECT apsspo.*,ima06,ima43,ima54",                     #TQC-750167
             "  FROM ",g_apsdb CLIPPED,"apsspo,ima_file,OUTER pmc_file",
             " WHERE pid=ima01 ",
             "   AND pur_qty > 0 ",
             "   AND sup_id = pmc_file.pmc01 ",
             "   AND po_id LIKE 'APS_PO%' ",    
             "   AND ",g_wc CLIPPED
   CASE WHEN summary_flag='1' 
          LET g_sql = g_sql CLIPPED," ORDER BY ima43,pid, fmrel_t"
        WHEN summary_flag='2' 
          LET g_sql = g_sql CLIPPED," ORDER BY ima06,pid, fmrel_t"
        OTHERWISE             
          LET g_sql = g_sql CLIPPED," ORDER BY pid, fmrel_t"
   END CASE
   PREPARE p510_p FROM g_sql
   DECLARE p510_c CURSOR FOR p510_p
   CALL cl_outnam('apsp510') RETURNING l_name
   SELECT sma115 INTO g_sma115 FROM sma_file   
   IF g_sma115 = 'Y' THEN
      LET g_zaa[38].zaa06 = 'N'
   ELSE
      LET g_zaa[38].zaa06 = 'Y'
   END IF
   CALL cl_prt_pos_len() 
   START REPORT p510_rep TO l_name
   FOREACH p510_c INTO g_apsspo.*,l_ima06,l_ima43,l_ima54 
      CALL p510_pmk_default(l_ima54)
      CASE 
         WHEN summary_flag='1'
              LET l_order=l_ima43
         WHEN summary_flag='2' 
              LET l_order=l_ima06
         OTHERWISE   
              LET l_order=' '
      END CASE
      OUTPUT TO REPORT p510_rep(l_order,g_apsspo.*)
   END FOREACH
   FINISH REPORT p510_rep
   CALL cl_prt(l_name,' ','1',g_len)  
   CALL cl_getmsg('amr-077',g_lang) RETURNING g_msg  
   IF cl_prompt(16,10,g_msg) THEN 
      LET g_success='Y'
   ELSE
      LET g_success='N'
   END IF
   CLOSE WINDOW p510_sure_w
END FUNCTION

REPORT p510_rep(l_order, l_apsspo)
  DEFINE l_apsspo	RECORD LIKE apsspo.*
  DEFINE l_order	LIKE ima_file.ima43 
  DEFINE l_ima49        LIKE ima_file.ima49
  DEFINE l_ima491       LIKE ima_file.ima491
  DEFINE l_date         LIKE type_file.dat 
  DEFINE l_pml80        STRING
  DEFINE l_pml82        STRING
  DEFINE l_pml83        STRING
  DEFINE l_pml85        STRING
  DEFINE l_ima44        LIKE ima_file.ima44
  DEFINE l_ima25        LIKE ima_file.ima25
  DEFINE l_ima906       LIKE ima_file.ima906
  DEFINE l_ima907       LIKE ima_file.ima907
  DEFINE l_cnt          LIKE type_file.num5    
  DEFINE l_factor       LIKE ima_file.ima44_fac
  DEFINE l_str2         LIKE zaa_file.zaa08 
  DEFINE l_pmli         RECORD LIKE pmli_file.*  #NO.FUN-7B0018

  OUTPUT TOP MARGIN    g_top_margin 
         LEFT MARGIN   g_left_margin
         BOTTOM MARGIN g_bottom_margin 
         PAGE LENGTH   g_page_line   

  ORDER EXTERNAL BY l_order, l_apsspo.pid, l_apsspo.fmrel_t
  FORMAT
    PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT g_dash[1,g_len] CLIPPED
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
            g_x[39] CLIPPED,g_x[40] CLIPPED       
      PRINT g_dash1

    BEFORE GROUP OF l_order
      CALL ins_pmk()
      PRINT
      PRINT COLUMN g_c[31],g_pmk01,             
            COLUMN g_c[32],l_order[1,6];

    ON EVERY ROW
      IF g_pml.pml02>=mxno THEN
         CALL ins_pmk()
         PRINT
         PRINT COLUMN g_c[31],g_pmk01,          
               COLUMN g_c[32],l_order[1,6];
      END IF
      LET g_pml.pml02 =g_pml.pml02+1
      IF g_bgjob = 'N' THEN 
          MESSAGE 'ins pml:',g_pml.pml01,' ',g_pml.pml02
      END IF
      LET g_pml.pml04  = l_apsspo.pid
      LET g_pml.pml041 = NULL
      LET g_pml.pml07  = NULL
      LET g_pml.pml08  = NULL
      LET g_pml.pml09  = 1
      SELECT ima02,ima39,ima44,ima25,ima44_fac,ima913,ima914   
        INTO g_pml.pml041,g_pml.pml40,g_pml.pml07,g_pml.pml08,g_pml.pml09,
             g_pml.pml190,g_pml.pml191   
        FROM ima_file 
       WHERE ima01=g_pml.pml04
      LET g_pml.pml192 = "N"   
      IF g_pml.pml07 != g_pml.pml08 THEN 
          LET l_apsspo.pur_qty = l_apsspo.pur_qty / g_pml.pml09
      END IF 
      LET g_pml.pml11 ='N'
      LET g_pml.pml13 =g_sma.sma401
      LET g_pml.pml14 =g_sma.sma886[1,1]         #部份交貨
      LET g_pml.pml15 =g_sma.sma886[2,2]         #提前交貨
      IF g_smydmy4='Y' THEN    #立即確認
         LET g_pml.pml16='1'
      ELSE
         LET g_pml.pml16='0'
      END IF
      LET g_pml.pml20 = l_apsspo.pur_qty
      LET g_pml.pml21 = 0
      LET g_pml.pml30 = 0
      LET g_pml.pml31 = 0
      LET g_pml.pml32 = 0
      SELECT ima49,ima491 INTO l_ima49,l_ima491
       FROM ima_file WHERE ima01=g_pml.pml04
      IF cl_null(l_ima49) THEN LET l_ima49=0 END IF
      IF cl_null(l_ima491) THEN LET l_ima491=0 END IF
      LET g_pml.pml34 = l_apsspo.pnava_t           ##到廠日  
      LET g_pml.pml33 = g_pml.pml34 - l_ima49      ##交貨日
      # 到廠日考慮是否工作日
      SELECT sme01 FROM sme_file
       WHERE sme01 = g_pml.pml34 AND sme02 IN ('Y','y')
      IF STATUS  # 非工作日
         THEN 
         SELECT max(sme01) INTO l_date FROM sme_file
          WHERE sme01 < g_pml.pml34 AND sme02 IN ('Y','y')
         IF NOT cl_null(l_date) THEN
            LET g_pml.pml34 = l_date
         END IF
      END IF
      LET g_pml.pml35=g_pml.pml34 + l_ima491     #入庫日
      LET g_pml.pml38 = 'Y'
      LET g_pml.pml42 = '0'
      LET g_pml.pml44 = 0
      LET g_pml.pml05 = l_apsspo.po_id
      IF g_sma.sma115 = 'Y' THEN
         SELECT ima25,ima44,ima906,ima907 INTO l_ima25,l_ima44,l_ima906,l_ima907
           FROM ima_file WHERE ima01=g_pml.pml04
         IF SQLCA.sqlcode =100 THEN                                                  
            IF g_pml.pml04 MATCHES 'MISC*' THEN                                
               SELECT ima25,ima44,ima906,ima907
                 INTO l_ima25,l_ima44,l_ima906,l_ima907
                 FROM ima_file WHERE ima01='MISC'                                    
            END IF                                                                   
         END IF                                                                      
         IF cl_null(l_ima44) THEN LET l_ima44 = l_ima25 END IF
         LET g_pml.pml80=g_pml.pml07
         LET l_factor = 1
         CALL s_umfchk(g_pml.pml04,g_pml.pml80,l_ima44) 
              RETURNING l_cnt,l_factor
         IF l_cnt = 1 THEN
            LET l_factor = 1
         END IF
         LET g_pml.pml81 = l_factor
         LET g_pml.pml82 = g_pml.pml20
         LET g_pml.pml83 = l_ima907
         LET l_factor = 1
         CALL s_umfchk(g_pml.pml04,g_pml.pml83,l_ima44) 
              RETURNING l_cnt,l_factor
         IF l_cnt = 1 THEN
            LET l_factor = 1
         END IF
         LET g_pml.pml84 = l_factor
         LET g_pml.pml85 = 0
         IF l_ima906 = '3' THEN
            LET l_factor = 1
            CALL s_umfchk(g_pml.pml04,g_pml.pml80,g_pml.pml83) 
                 RETURNING l_cnt,l_factor
            IF l_cnt = 1 THEN
               LET l_factor = 1
            END IF
            LET g_pml.pml85 = g_pml.pml82*l_factor
         END IF
      END IF
      LET g_pml.pml86 = g_pml.pml07
      LET g_pml.pml87 = g_pml.pml20
      SELECT ima906 INTO l_ima906 
        FROM ima_file                                                                     
       WHERE ima01=g_pml.pml04                                                                                      
      LET l_str2 = ""                                                                                                               
      IF g_sma115 = "Y" THEN                                                                                                        
         CASE l_ima906                                                                                                              
            WHEN "2"                                                                                                                
                CALL cl_remove_zero(g_pml.pml85) RETURNING l_pml85                                                                     
                LET l_str2 = l_pml85 , g_pml.pml83 CLIPPED                                                                             
                IF cl_null(g_pml.pml85) OR g_pml.pml85 = 0 THEN                                                                           
                    CALL cl_remove_zero(g_pml.pml82) RETURNING l_pml82                                                                 
                    LET l_str2 = l_pml82, g_pml.pml80 CLIPPED                                                                          
                ELSE                                                                                                                
                   IF NOT cl_null(g_pml.pml82) AND g_pml.pml82 > 0 THEN                                                                   
                      CALL cl_remove_zero(g_pml.pml82) RETURNING l_pml82                                                               
                      LET l_str2 = l_str2 CLIPPED,',',l_pml82, g_pml.pml80 CLIPPED                                                     
                   END IF                                                                                                           
                END IF   
            WHEN "3"                                                                                                                
                IF NOT cl_null(g_pml.pml85) AND g_pml.pml85 > 0 THEN                                                                      
                    CALL cl_remove_zero(g_pml.pml85) RETURNING l_pml85                                                                 
                    LET l_str2 = l_pml85 , g_pml.pml83 CLIPPED                                                                         
                END IF                                                                                                              
         END CASE                                                                                                                   
      ELSE                                                                                                                          
      END IF                 
      PRINT COLUMN g_c[33],g_pml.pml05,        
            COLUMN g_c[34],g_pml.pml02 USING '####',
            COLUMN g_c[35],g_pml.pml04[1,18],
            COLUMN g_c[36],g_pml.pml041,
            COLUMN g_c[37],g_pml.pml07,
            COLUMN g_c[38],l_str2 CLIPPED,    
            COLUMN g_c[39],cl_numfor(g_pml.pml20,39,g_azi03), 
            COLUMN g_c[40],g_pml.pml33
      LET g_pml.pml930=s_costcenter(g_pmk.pmk13) 
      INSERT INTO pml_file VALUES(g_pml.*)
      IF STATUS THEN
         CALL cl_err3("ins","pml_file",g_pml.pml01,g_pml.pml02,STATUS,"","ins pml:",1)  
         IF g_bgjob = 'Y' THEN CALL cl_batch_bg_javamail("N") END IF  
         EXIT PROGRAM 
      END IF
      #NO.FUN-7B0018 08/01/31 add --begin
      IF NOT s_industry('std') THEN
         INITIALIZE l_pmli.* TO NULL
         LET l_pmli.pmli01 = g_pml.pml01
         LET l_pmli.pmli02 = g_pml.pml02
         IF NOT s_ins_pmli(l_pmli.*,'') THEN
            LET g_success='N'
            IF g_bgjob = 'Y' THEN
               CALL cl_batch_bg_javamail("N") 
            END IF  
            EXIT PROGRAM 
         END IF
      END IF
      #NO.FUN-7B0018 08/01/31 add --end
      ON LAST ROW                                                                                                                   
         PRINT g_dash[1,g_len]                                                                                                      
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED                                                                  
                                                                                                                                    
      PAGE TRAILER                                                                                                                  
            PRINT g_dash[1,g_len]                                                                                                   
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED                                                               
END REPORT

FUNCTION p510_pmk_default(p_ima54)
      DEFINE  p_ima54   LIKE    ima_file.ima54

      LET g_pmk.pmk02 = 'REG'
      ##TQC-750167-------------------------------------------------------------
      ##經與鼎誠討論確認,若PO中is_new='1',則不管是否有sup_id,
      ##統一抓ima54做為預設請購廠商,若請購廠商不為空白時須帶出欄位預設值
      ##IF g_apsspo.sup_id = 'DEFAULT' THEN
      ##   LET g_pmk.pmk09 = p_ima54
      ##ELSE
      IF g_apsspo.is_new = '1' THEN
         LET g_pmk.pmk09 = p_ima54
         IF p_ima54 IS NOT NULL THEN
            SELECT pmc17,pmc49,pmc15,pmc16,pmc47,pmc22 
              INTO g_pmk.pmk20,g_pmk.pmk41,g_pmk.pmk10,g_pmk.pmk11,g_pmk.pmk21,g_pmk.pmk22
              FROM pmc_file
             WHERE pmc01 = p_ima54
         END IF
      END IF 
      ##TQC-750167------------------------------------------------------------
      IF g_smydmy4 = 'Y' THEN  #立即確認
         LET g_pmk.pmk18 = 'Y'
         LET g_pmk.pmk25 = '1'
      ELSE
         LET g_pmk.pmk18 = 'N'
         LET g_pmk.pmk25 = '0'
      END IF
      LET g_pmk.pmk27 = TODAY
      LET g_pmk.pmk30 = 'Y'
      LET g_pmk.pmk31 = YEAR(g_pmk.pmk04)
      LET g_pmk.pmk32 = MONTH(g_pmk.pmk04)
      LET g_pmk.pmk40 = 0
      LET g_pmk.pmk401= 0
      LET g_pmk.pmk42 = 1
      LET g_pmk.pmk43 = 0
      LET g_pmk.pmk45 = 'Y'
      LET g_pmk.pmkprsw = 'Y'
      LET g_pmk.pmkprno = 0
      LET g_pmk.pmkmksg = g_pmkmksg  
      LET g_pmk.pmksign = g_pmksign  
      LET g_pmk.pmkdays = g_pmkdays  
      LET g_pmk.pmkprit = g_pmkprit  
      LET g_pmk.pmkacti = 'Y'
      LET g_pmk.pmkuser = g_user
      LET g_pmk.pmkgrup = g_grup
      LET g_pmk.pmkdate = TODAY
END FUNCTION

FUNCTION ins_pmk()
  DEFINE li_result   LIKE type_file.num5             
      CALL s_auto_assign_no("apm",g_pmk.pmk01,g_pmk.pmk04,"1","pmk_file","pmk01",
           "","","")
      RETURNING li_result,g_pmk.pmk01
      IF (NOT li_result) THEN
         LET g_success='N' 
         IF g_bgjob = 'Y' THEN CALL cl_batch_bg_javamail("N") END IF  
         EXIT PROGRAM 
      END IF
      IF g_bgjob = 'N' THEN  
          MESSAGE 'ins pmk:',g_pmk.pmk01
      END IF
      INSERT INTO pmk_file VALUES(g_pmk.*)
      IF STATUS THEN 
          CALL cl_err3("ins","pmk_file",g_pmk.pmk01,"",STATUS,"","INS PMK:",1)  
          IF g_bgjob = 'Y' THEN 
              CALL cl_batch_bg_javamail("N") 
          END IF  
          EXIT PROGRAM 
      END IF
      LET g_pml.pml01  = g_pmk.pmk01
      LET g_pml.pml011 = g_pmk.pmk02
      LET g_pml.pml02  = 0
      LET g_pmk01    = g_pmk.pmk01      
      LET g_pmk.pmk01= g_t1            
END FUNCTION
