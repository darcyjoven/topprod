# Prog. Version..: '5.30.06-13.03.28(00004)'     #
# Pattern name...: aicr036.4gl
# Descriptions...: 批號追蹤作業
# Date & Author..: 10/03/26 By jan(FUN-A10138)
# Modify.........: No.FUN-B80083 11/08/08 By minpp程序撰寫規範修改:
# Modify.........: No.FUN-C40014 12/04/06 By bart 批號追踨筆數應相同
# Modify.........: No.MOD-CC0082 12/12/11 By Elise 修改sql條件

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
     tm  RECORD
         wc      STRING,
         estyle  LIKE type_file.chr1,
         bdate   LIKE type_file.dat,
         edate   LIKE type_file.dat,
         more    LIKE type_file.chr1
         END RECORD
DEFINE  p_row,p_col     LIKE type_file.num5
DEFINE  g_cnt           LIKE type_file.num10
DEFINE  g_msg           LIKE type_file.chr1000
DEFINE  g_row_count     LIKE type_file.num10
DEFINE  g_curs_index    LIKE type_file.num10
DEFINE  g_jump          LIKE type_file.num10
DEFINE  mi_no_ask       LIKE type_file.num5
DEFINE  g_no_ask        LIKE type_file.num5
DEFINE  lc_qbe_sn       LIKE gbm_file.gbm01 
DEFINE  g_wc,g_wc1      STRING 
DEFINE l_table    STRING
DEFINE g_str      STRING
DEFINE g_sql      STRING          

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                         # Supress DEL key function

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   LET g_sql = "p_level.type_file.num5,",
               "tlf01.tlf_file.tlf01,",
               "sfe10.sfe_file.sfe10,",
               "tlf904.tlf_file.tlf904,",
               "tlf05.tlf_file.tlf05,",
               "tlf10.tlf_file.tlf10,",
               "tlf11.tlf_file.tlf11,",
               "tlf905.tlf_file.tlf905,",
               "tlf906.tlf_file.tlf906"

   LET l_table = cl_prt_temptable('aicr036',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF 

   DROP TABLE r036_temp

   CREATE TEMP TABLE r036_temp(
       p_level  LIKE type_file.num5,
       tlf01    LIKE tlf_file.tlf01,
       sfe10    LIKE sfe_file.sfe10,
       tlf904   LIKE tlf_file.tlf904,
       tlf05    LIKE tlf_file.tlf05,
       tlf10    LIKE tlf_file.tlf10,
       tlf11    LIKE tlf_file.tlf11,
       tlf905   LIKE tlf_file.tlf905,
       tlf906   LIKE tlf_file.tlf906)
   CREATE UNIQUE INDEX r036_01 on r036_temp (p_level,tlf904)

   LET g_pdate  = ARG_VAL(1) 
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.estyle= ARG_VAL(8)
   LET tm.bdate = ARG_VAL(9)
   LET tm.edate = ARG_VAL(10)
   LET tm.more  = ARG_VAL(11)
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  

   IF cl_null(g_bgjob) OR g_bgjob = 'N'  
      THEN CALL aicr036_tm(0,0)
      ELSE CALL aicr036()   
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION aicr036_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     
DEFINE p_row,p_col    LIKE type_file.num5,      
       l_cmd          LIKE type_file.chr1000  

   OPEN WINDOW r036_w AT p_row,p_col
        WITH FORM "aic/42f/aicr036"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL         
   LET tm.more = 'N'
   LET tm.bdate = g_today
   LET tm.edate = g_today
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.estyle = '1'
   WHILE TRUE
     CONSTRUCT tm.wc ON img01,img04
       FROM a1,a3       #單頭條件
              
      BEFORE CONSTRUCT
        CALL cl_qbe_init()
       
      ON ACTION CONTROLP
         CASE 
   	       WHEN INFIELD(a1)    #料號
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ima"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO a1
                NEXT FIELD a1
          END CASE

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

      ON ACTION qbe_select
         CALL cl_qbe_select()


     END CONSTRUCT
     IF g_action_choice = "locale" THEN
        LET g_action_choice = ""
        CALL cl_dynamic_locale()
        CONTINUE WHILE
     END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW r036_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
            
      END IF

      DISPLAY BY NAME tm.more,tm.estyle,tm.bdate,tm.edate
      INPUT tm.estyle,tm.bdate,tm.edate,tm.more 
        WITHOUT DEFAULTS FROM estyle,bdate,edate,more

         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)

         AFTER FIELD more
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies)
                         RETURNING g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies
            END IF
            
        AFTER FIELD estyle
	        IF tm.estyle NOT MATCHES '[12]' THEN
	           NEXT FIELD estyle
          END IF    

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

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

        ON ACTION qbe_save
           CALL cl_qbe_save()

      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW r036_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file   
                WHERE zz01='aicr036'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aicr036','9031',1)   
         ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            " '",g_rlang CLIPPED,"'", 
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'" ,
                            " '",tm.estyle CLIPPED,"'" ,
                            " '",tm.bdate CLIPPED,"'" ,
                            " '",tm.edate CLIPPED,"'" ,
                            " '",tm.more CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'", 
                         " '",g_rep_clas CLIPPED,"'",  
                         " '",g_template CLIPPED,"'",
                         " '",g_rpt_name CLIPPED,"'"  
             CALL cl_cmdat('aicr036',g_time,l_cmd)    
         END IF
         CLOSE WINDOW r036_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL aicr036()
      ERROR ""
   END WHILE
   CLOSE WINDOW r036_w
END FUNCTION


FUNCTION aicr036()
   DEFINE l_sql   LIKE type_file.chr1000 
   DEFINE l_img01 LIKE img_file.img01
   DEFINE l_img04 LIKE img_file.img04
   DEFINE l_gem02 LIKE gem_file.gem02  
   DEFINE g_sfe02 LIKE sfe_file.sfe02
   DEFINE g_sfe28 LIKE sfe_file.sfe28
   DEFINE g_sfe01 LIKE sfe_file.sfe01
   DEFINE g_sfe10 LIKE sfe_file.sfe10
   DEFINE g_sfe14 LIKE sfe_file.sfe14
   DEFINE g_sfe16 LIKE sfe_file.sfe16
   DEFINE g_sfe17 LIKE sfe_file.sfe17
   DEFINE l_tlf   RECORD  
                  p_level   LIKE type_file.num5,
                  tlf01     LIKE tlf_file.tlf01,
                  sfe10     LIKE sfe_file.sfe10,
                  tlf904    LIKE tlf_file.tlf904,
                  tlf05     LIKE tlf_file.tlf05,
                  tlf10     LIKE tlf_file.tlf10,
                  tlf11     LIKE tlf_file.tlf11,
                  tlf905    LIKE tlf_file.tlf905,
                  tlf906    LIKE tlf_file.tlf906
                  END RECORD
   DEFINE l_flag  LIKE type_file.chr1  #FUN-C40014

   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?) "                                                                                                
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80083    ADD
      EXIT PROGRAM                                                                             
   END IF        

   CALL cl_del_data(l_table)   
   DELETE FROM r036_temp
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aicr036'

   IF cl_null(tm.bdate) AND cl_null(tm.edate) THEN 
      LET g_wc = " 1=1"
      LET g_wc1 = " 1=1"
   ELSE
      IF cl_null(tm.bdate) THEN
         LET g_wc = " sfp02 <= '",tm.edate,"'"
         LET g_wc1= " tlf06 <= '",tm.edate,"'"
      END IF
      IF cl_null(tm.edate) THEN
         LET g_wc = " sfp02 >= '",tm.bdate,"'"
         LET g_wc1= " tlf06 >= '",tm.bdate,"'"
      END IF
      IF NOT cl_null(tm.bdate) AND NOT cl_null(tm.edate) THEN
         LET g_wc = " sfp02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
         LET g_wc1 = " tlf06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
      END IF
   END IF

   LET l_sql = "SELECT UNIQUE img01,img04",
               " FROM img_file,imaicd_file WHERE  ",tm.wc,
               #"  AND img04 <> ' '",  #FUN-C40014
               "  AND imaicd00 = img01"
   IF tm.estyle = '1' THEN
  #MOD-CC0082---S
      LET l_sql = l_sql CLIPPED," AND img01 IN (SELECT bmb03 FROM bmb_file) AND img01 NOT IN (SELECT bma01 FROM bma_file)"
   ELSE
      LET l_sql = l_sql CLIPPED," AND img01 NOT IN (SELECT bmb03 FROM bmb_file) AND img01 IN (SELECT bma01 FROM bma_file)"
   END IF
  #MOD-CC0082---E
  #MOD-CC0082---mark---S
  #   LET l_sql = l_sql CLIPPED," AND imaicd04 = '1' "
  #ELSE
  #   LET l_sql = l_sql CLIPPED," AND imaicd04 = '4' "
  #END IF
  #MOD-CC0082---mark---E
   LET l_sql = l_sql CLIPPED," ORDER BY img01 "
   
   PREPARE aicr036_p1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare1:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   DECLARE aicr036_curs1 CURSOR FOR aicr036_p1

   FOREACH aicr036_curs1 INTO l_img01,l_img04
	      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
     IF tm.estyle = '1' THEN
          LET l_sql = "SELECT DISTINCT sfe01,sfe10,'WAFER',sfe16,sfe17,sfe02,sfe28 ",
                      "  FROM sfe_file,sfp_file ",
                      " WHERE sfe07 = '",l_img01,"' ",
                      #"   AND sfe10 <> ' '",   #FUN-C40014
                      "   AND sfe10 IS NOT NULL",
                      "   AND sfe10 = '",l_img04,"'",
                      "   AND sfp01=sfe02",
                      "   AND ",g_wc
     ELSE
        LET l_sql = "SELECT DISTINCT tlf62,tlf904,sfbiicd09,tlf10,tlf11,tlf905,tlf906 ",
                    "  FROM tlf_file ",
                    "  LEFT OUTER JOIN sfbi_file ON (sfbi01=tlf62)",
                    " WHERE tlf01 = '",l_img01,"' ",
                    #"   AND tlf904 <> ' '",    #FUN-C40014
                    "   AND tlf904 IS NOT NULL",
                    "   AND tlf904 = '",l_img04,"'",
                    "   AND tlf13='asft6201' ",
                    "   AND ",g_wc1
     END IF
     PREPARE r036_sfe_pre FROM l_sql 
     DECLARE r036_sfe_curs CURSOR FOR r036_sfe_pre
     LET l_flag = 'N'
     FOREACH r036_sfe_curs INTO g_sfe01,g_sfe10,g_sfe14,g_sfe16,g_sfe17,g_sfe02,g_sfe28
        EXECUTE insert_prep USING '0',l_img01,'',g_sfe10,g_sfe14,g_sfe16,g_sfe17,g_sfe02,g_sfe28
        #FUN-C40014---begin
        IF SQLCA.SQLERRD[3] >0 THEN
           IF l_flag = 'N' THEN
              LET l_flag = 'Y'
           END IF 
        END IF 
        #FUN-C40014---end
        IF tm.estyle = '1' THEN
           CALL r036_bom(0,g_sfe01,g_sfe10)
        ELSE
           CALL r036_bom1(0,g_sfe01,g_sfe10)
        END IF
     END FOREACH
     #FUN-C40014---begin
     IF l_flag = 'N' THEN
        EXECUTE insert_prep USING '0',l_img01,'',l_img04,'','','','',''
     END IF 
     #FUN-C40014---end
   END FOREACH
   IF g_zz05 = 'Y' THEN                                                                                                           
      CALL cl_wcchp(tm.wc,'img01,img04')                                                                           
      RETURNING tm.wc                                                                                                           
   END IF
   LET g_str = tm.wc
   #以下做法是為了確保打印效果的准確-------
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   PREPARE r036_sfe_pre3 FROM l_sql 
   DECLARE r036_sfe_curs3 CURSOR FOR r036_sfe_pre3
   FOREACH r036_sfe_curs3 INTO l_tlf.*
     INSERT INTO r036_temp VALUES (l_tlf.*)
     IF SQLCA.sqlcode THEN CONTINUE FOREACH END IF
   END FOREACH
   LET l_sql = "DELETE FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   PREPARE insert_prep3 FROM l_sql
   EXECUTE insert_prep3
   LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " SELECT * FROM r036_temp"
   PREPARE insert_prep2 FROM l_sql
   EXECUTE insert_prep2
   #------------------------------------------
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
   CALL cl_prt_cs3('aicr036','aicr036',l_sql,g_str)
END FUNCTION

FUNCTION r036_bom(p_level,p_key,p_key1)
   DEFINE p_level    LIKE type_file.num5,          
          p_key      LIKE sfe_file.sfe01,
          p_key1     LIKE sfe_file.sfe10,
          l_ac       LIKE type_file.num5,          
          l_ac3      LIKE type_file.num5,          
          arrno      LIKE type_file.num5,          
          l_cmd      LIKE type_file.chr1000,       
          sr DYNAMIC ARRAY OF RECORD  
             tlf01   LIKE tlf_file.tlf01,
             tlf904  LIKE tlf_file.tlf904,
             tlf905  LIKE tlf_file.tlf905,
             tlf906  LIKE tlf_file.tlf906,
             tlf05   LIKE tlf_file.tlf05,
             tlf10   LIKE tlf_file.tlf10,
             tlf11   LIKE tlf_file.tlf11,
             sfe01   DYNAMIC ARRAY OF LIKE sfe_file.sfe01,
             sfe10   DYNAMIC ARRAY OF LIKE sfe_file.sfe10
          END RECORD
   DEFINE l_sql      STRING
   DEFINE i,n        LIKE type_file.num5
          
   IF p_level>20 THEN CALL cl_err('','mfg2733',1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM 
   END IF
   LET p_level=p_level+1
   IF p_level=1 THEN
      INITIALIZE sr[1].* TO NULL
      LET g_pageno=0
   END IF
   LET arrno=600
   WHILE TRUE
      LET l_cmd="SELECT DISTINCT tlf01,tlf904,tlf905,tlf906,sfbiicd09,tlf10,tlf11 ",
                "  FROM tlf_file ",
                "  LEFT OUTER JOIN sfbi_file ON (sfbi01=tlf62)",
                " WHERE tlf62='",p_key,"' ",
                #"   AND tlf904 <> ' '",   #FUN-C40014
                "   AND tlf904 IS NOT NULL",
                "   AND (tlf13='asft6201' OR tlf13 = 'apmt150')",
                "   AND ",g_wc1
      PREPARE r036_tlf_pre FROM l_cmd
      DECLARE r036_tlf_cur CURSOR FOR r036_tlf_pre
 
      LET l_ac=1
      FOREACH r036_tlf_cur INTO sr[l_ac].tlf01,sr[l_ac].tlf904,sr[l_ac].tlf905,
                                sr[l_ac].tlf906,sr[l_ac].tlf05,sr[l_ac].tlf10,sr[l_ac].tlf11
         IF SQLCA.sqlcode != 0 THEN                                                                                                
            CALL cl_err('r036_tlf_cur',SQLCA.sqlcode,1)                                                                                
            EXIT FOREACH                                                                                                           
         END IF                                                                                                                    
         LET l_sql = "SELECT DISTINCT sfe01,sfe10 ",
                     " FROM sfe_file",
                     " WHERE sfe07 = '",sr[l_ac].tlf01,"'",
                     "   AND sfe10 = '",sr[l_ac].tlf904,"'"
          PREPARE r036_sfe_pre2 FROM l_sql
          DECLARE r036_sfe_cur2 CURSOR WITH HOLD FOR r036_sfe_pre2
          LET l_ac3 = 1
          FOREACH r036_sfe_cur2 INTO sr[l_ac].sfe01[l_ac3],sr[l_ac].sfe10[l_ac3]
              LET l_ac3 = l_ac3 + 1
          END FOREACH
         LET l_ac=l_ac+1                                                                                                           
         IF  l_ac=arrno THEN EXIT FOREACH END IF                                                                                   
      END FOREACH                                                                                                                   
      FOR i=1 TO l_ac-1
          EXECUTE insert_prep USING p_level,sr[i].tlf01,p_key1,sr[i].tlf904,
                                    sr[i].tlf05,sr[i].tlf10,sr[i].tlf11,
                                    sr[i].tlf905,sr[i].tlf906
          IF SQLCA.SQLCODE THEN CONTINUE FOR END IF
          FOR n=1 TO l_ac3 -1
              CALL r036_bom(p_level,sr[i].sfe01[n],sr[i].tlf904)
          END FOR
      END FOR
      IF l_ac < arrno THEN EXIT WHILE END IF
   END WHILE
END FUNCTION

FUNCTION r036_bom1(p_level,p_key,p_key1)
   DEFINE p_level    LIKE type_file.num5,          
          p_key      LIKE sfe_file.sfe01,
          p_key1     LIKE sfe_file.sfe10,
          l_ac       LIKE type_file.num5,          
          l_ac3      LIKE type_file.num5,          
          arrno      LIKE type_file.num5,          
          l_cmd      LIKE type_file.chr1000,       
          sr DYNAMIC ARRAY OF RECORD  
             sfe07   LIKE sfe_file.sfe07,
             sfe10   LIKE sfe_file.sfe10,
             sfe02   LIKE sfe_file.sfe02,
             sfe28   LIKE sfe_file.sfe28,
             sfe14   LIKE sfe_file.sfe14,
             sfe16   LIKE sfe_file.sfe16,
             sfe17   LIKE sfe_file.sfe17,
             imaicd04 LIKE imaicd_file.imaicd04,
             tlf62   DYNAMIC ARRAY OF LIKE tlf_file.tlf62,
             tlf904  DYNAMIC ARRAY OF LIKE tlf_file.tlf904
          END RECORD
   DEFINE l_sql      STRING
   DEFINE i,n        LIKE type_file.num5
    
   IF p_level>20 THEN CALL cl_err('','mfg2733',1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM 
   END IF
   LET p_level=p_level+1
   IF p_level=1 THEN
      INITIALIZE sr[1].* TO NULL
      LET g_pageno=0
   END IF
   LET arrno=600
   WHILE TRUE
      LET l_cmd="SELECT DISTINCT sfe07,sfe10,sfe02,sfe28,sfe14,sfe16,sfe17,imaicd04 ",
                "  FROM sfe_file,sfp_file,imaicd_file ",
                " WHERE sfe01='",p_key,"' ",
                #"   AND sfe10 <> ' '",   #FUN-C40014
                "   AND sfe10 IS NOT NULL",
                "   AND sfp01=sfe02",
                "   AND imaicd00=sfe07",
                "   AND ",g_wc
      PREPARE r036_sfe_pre1 FROM l_cmd
      DECLARE r036_sfe_cur1 CURSOR FOR r036_sfe_pre1
 
      LET l_ac=1
      FOREACH r036_sfe_cur1 INTO sr[l_ac].sfe07,sr[l_ac].sfe10,sr[l_ac].sfe02,
                                sr[l_ac].sfe28,sr[l_ac].sfe14,sr[l_ac].sfe16,
                                sr[l_ac].sfe17,sr[l_ac].imaicd04
         IF SQLCA.sqlcode != 0 THEN                                                                                                
            CALL cl_err('r036_sfe_cur1',SQLCA.sqlcode,1)                                                                                
            EXIT FOREACH                                                                                                           
         END IF  
         IF sr[l_ac].imaicd04 = '1' THEN LET sr[l_ac].sfe14 = 'WAFER' END IF  
                                                                                                                        
         LET l_sql = "SELECT DISTINCT tlf62,tlf904 ",
                     " FROM tlf_file ",
                     " WHERE tlf01 = '",sr[l_ac].sfe07,"' ",
                     "   AND tlf904 = '",sr[l_ac].sfe10,"'",
                     "   AND tlf13='asft6201' ",
                     "   AND ",g_wc1
          PREPARE r036_tlf_pre2 FROM l_sql
          DECLARE r036_tlf_cur2 CURSOR WITH HOLD FOR r036_tlf_pre2
          LET l_ac3 = 1
          FOREACH r036_tlf_cur2 INTO sr[l_ac].tlf62[l_ac3],sr[l_ac].tlf904[l_ac3]
              LET l_ac3 = l_ac3 + 1
          END FOREACH
         LET l_ac=l_ac+1                                                                                                           
         IF  l_ac=arrno THEN EXIT FOREACH END IF                                                                                   
      END FOREACH                                                                                                                   
      FOR i=1 TO l_ac-1
          EXECUTE insert_prep USING p_level,sr[i].sfe07,p_key1,sr[i].sfe10,
                                        sr[i].sfe14,sr[i].sfe16,sr[i].sfe17,
                                        sr[i].sfe02,sr[i].sfe28
          IF SQLCA.SQLCODE THEN CONTINUE FOR END IF
          FOR n=1 TO l_ac3 -1
              CALL r036_bom1(p_level,sr[i].tlf62[n],sr[i].sfe10)
          END FOR
      END FOR
      IF l_ac < arrno THEN EXIT WHILE END IF
   END WHILE
END FUNCTION
#FUN-A10138

