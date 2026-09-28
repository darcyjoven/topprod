# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghrr027.4gl
# Descriptions...: 扣缴个人所得税报告表
# Date & Author..: 13/09/26 by zhangbo

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE  tm    RECORD 
          hraa01     LIKE   hraa_file.hraa01,
          hrct04     LIKE   hrct_file.hrct04,
          hrct05     LIKE   hrct_file.hrct05,
          wc         LIKE   type_file.chr1000,
          more       LIKE   type_file.chr1
              END RECORD
DEFINE l_table         STRING  
DEFINE g_str           STRING
DEFINE g_sql           STRING

MAIN
   OPTIONS
          INPUT NO WRAP
   DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119 
   
   LET g_sql = " xuhao.type_file.num5,",
               " hrat02.hrat_file.hrat02,",
               " hrat12.hrag_file.hrag07,",
               " hrat13.hrat_file.hrat13,", 
               " hrat28.hrag_file.hrag07,", 
               " sdxm.type_file.chr1000,", 
               " hrdx01.hrdx_file.hrdx01,", 
               " hrdxa08.hrdxa_file.hrdxa08,", 
               " mssr.hrdxa_file.hrdxa08,",
               " yxkcsf.hrdxa_file.hrdxa08,", 
               " fykcbz.hrdxa_file.hrdxa08,",   #MOD-840050
               " zykcjz.hrdxa_file.hrdxa08,", 
               " hrdxa09.hrdxa_file.hrdxa09,", 
               " hrdxa11.hrdxa_file.hrdxa11,", 
               " hrdxa10.hrdxa_file.hrdxa10,", 
               " hrdxa12.hrdxa_file.hrdxa12,",
               " hrdxa12a.hrdxa_file.hrdxa12,", 
               " beizhu.type_file.chr1000 "
                                              
   LET l_table = cl_prt_temptable('ghrr027',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?  )"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-750129  --End

   #-----TQC-610059---------
   LET g_pdate=ARG_VAL(1)
   LET g_towhom=ARG_VAL(2)
   LET g_rlang=ARG_VAL(3)
   LET g_bgjob=ARG_VAL(4)
   LET g_prtway=ARG_VAL(5)
   LET g_copies=ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.hraa01 = ARG_VAL(8)
   LET tm.hrct04 = ARG_VAL(9)
   LET tm.hrct05 = ARG_VAL(10)
   #No:FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No:FUN-7C0078

   IF (cl_null(g_bgjob) OR g_bgjob = 'N') AND cl_null(tm.wc) THEN
      CALL ghrr027_tm(0,0)                     # Input print condition
   ELSE                                   
      CALL ghrr027()                                # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN 

FUNCTION ghrr027_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680137 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
   DEFINE l_hraa12       LIKE hraa_file.hraa12       
   DEFINE l_n            LIKE type_file.num5   


   LET p_row = 7
   LET p_col = 17

   OPEN WINDOW r027_w AT p_row,p_col WITH FORM "ghr/42f/ghrr027"
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
   	  INPUT BY NAME tm.hraa01,tm.hrct04,tm.hrct05,tm.more  WITHOUT DEFAULTS              

      AFTER FIELD hraa01
         IF NOT cl_null(tm.hraa01) THEN
            LET l_n=0
            SELECT COUNT(*) INTO l_n FROM hraa_file WHERE hraa01=tm.hraa01 
                                                      AND hraaacti='Y'
            IF l_n=0 THEN
            	 CALL cl_err("无此公司编号","!",0)
            	 NEXT FIELD hraa01
            END IF
            SELECT hraa12 INTO l_hraa12 FROM hraa_file WHERE hraa01=tm.hraa01
            DISPLAY l_hraa12 TO hraa12		                                           
         END IF

      AFTER FIELD hrct04
         IF NOT cl_null(tm.hrct04) THEN
            LET l_n=0
            SELECT COUNT(*) INTO l_n FROM hrct_file WHERE hrct03=tm.hraa01
                                                      AND hrct04=tm.hrct04
            IF l_n=0 THEN
            	 CALL cl_err("无此基准年度","!",0)
            	 NEXT FIELD hrct04
            END IF	                                           
         END IF
         	
      AFTER FIELD hrct05
         IF NOT cl_null(tm.hrct05) THEN
            LET l_n=0
            SELECT COUNT(*) INTO l_n FROM hrct_file WHERE hrct03=tm.hraa01
                                                      AND hrct04=tm.hrct04
                                                      AND hrct05=tm.hrct05
            IF l_n=0 THEN
            	 CALL cl_err("无此基准月度","!",0)
            	 NEXT FIELD hrct05
            END IF	                                           
         END IF 
         	
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF

      ON ACTION controlp
        CASE
           WHEN INFIELD(hraa01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hraa01"
              LET g_qryparam.default1 = tm.hraa01
              CALL cl_create_qry() RETURNING tm.hraa01
              DISPLAY BY NAME tm.hraa01
              NEXT FIELD hraa01
        END CASE   	  	


      #ON ACTION CONTROLZ
      #   CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

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

      END INPUT
   
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW r027_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
         EXIT PROGRAM
      END IF
   	
      CONSTRUCT BY NAME tm.wc ON hrao01
         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         ON ACTION locale
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
         #-----CHI-A10024---------
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #-----END CHI-A10024-----
         ON ACTION controlp
           CASE
              WHEN INFIELD(hrao01) #查詢單据
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_hrao01"
                   LET g_qryparam.arg1= tm.hraa01 
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO hrao01
                   NEXT FIELD hrao01
           END CASE

      END CONSTRUCT
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW r027_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
         EXIT PROGRAM
      END IF
   	
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='ghrr027'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('ghrr027','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            " '",g_rlang CLIPPED,"'",
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.hraa01 CLIPPED,"'",
                            " '",tm.hrct04 CLIPPED,"'",
                            " '",tm.hrct05 CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'" ,
                            " '",g_rep_user CLIPPED,"'",
                            " '",g_rep_clas CLIPPED,"'",
                            " '",g_template CLIPPED,"'",
                            " '",g_rpt_name CLIPPED,"'"
            CALL cl_cmdat('ghrr027',g_time,l_cmd)      # Execute cmd at later time
         END IF
         CLOSE WINDOW r027_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-690126
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL ghrr027()
      ERROR ""
   END WHILE
   CLOSE WINDOW r027_w		
   
END FUNCTION


FUNCTION ghrr027()
DEFINE l_sql    STRING
DEFINE sr    RECORD
         xuhao     LIKE     type_file.num5,
         hrat02    LIKE     hrat_file.hrat02,
         hrat12    LIKE     hrag_file.hrag07,
         hrat13    LIKE     hrat_file.hrat13,
         hrat28    LIKE     hrag_file.hrag07,
         sdxm      LIKE     type_file.chr1000,
         hrdx01    LIKE     hrdx_file.hrdx01,
         hrdxa08   LIKE     hrdxa_file.hrdxa08,
         mssr      LIKE     hrdxa_file.hrdxa08,
         yxkcfy    LIKE     hrdxa_file.hrdxa08,
         fykcbz    LIKE     hrdxa_file.hrdxa08,
         zykcjz    LIKE     hrdxa_file.hrdxa08,
         hrdxa09   LIKE     hrdxa_file.hrdxa09,
         hrdxa11   LIKE     hrdxa_file.hrdxa11,
         hrdxa10   LIKE     hrdxa_file.hrdxa10,
         hrdxa12   LIKE     hrdxa_file.hrdxa12,
         hrdxa12a  LIKE     hrdxa_file.hrdxa12,
         beizhu    LIKE     type_file.chr1000
               END RECORD
DEFINE l_hratid    LIKE     hrat_file.hratid
DEFINE l_hraa12    LIKE     hraa_file.hraa12             
        
        CALL cl_del_data(l_table)  
        SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog     
        SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
        
        LET sr.xuhao=0
        LET sr.sdxm='工资、薪金所得'
        LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('hraauser', 'hraagrup')
        LET l_sql=" SELECT hrdxa02,hrdx01,hrdxa08,hrdxa09,hrdxa10,hrdxa11,hrdxa12,hrdxa12 ",
                  "   FROM hrdx_file,hrdxa_file,hrat_file,hrao_file,hraa_file,hrct_file ",
                  "  WHERE hrdxa01=hrdx01 AND hrdxa02=hratid AND hrat03=hraa01",
                  "    AND hrat04=hrao01 AND hrdxa22=hrdx04 AND hrdx01=hrct11 ",
                  "    AND hraa01='",tm.hraa01,"'",
                  "    AND hrct04='",tm.hrct04,"'",
                  "    AND to_number(hrct05)<=to_number('",tm.hrct05,"')",
                  "    AND ",tm.wc CLIPPED,
                  "    ORDER BY hrdxa02,hrct04,hrct05 "
                    
       PREPARE ghrr027_prepare1 FROM l_sql
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('prepare:',SQLCA.sqlcode,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
          EXIT PROGRAM
       END IF
       DECLARE ghrr027_curs1 CURSOR FOR ghrr027_prepare1 
       
       FOREACH ghrr027_curs1 INTO l_hratid,sr.hrdx01,sr.hrdxa08,sr.hrdxa09,
                                  sr.hrdxa10,sr.hrdxa11,sr.hrdxa12,sr.hrdxa12a
          
          LET sr.xuhao=sr.xuhao+1
          
          SELECT hrat02 INTO sr.hrat02 FROM hrat_file WHERE hratid=l_hratid
          SELECT hrag07 INTO sr.hrat12 FROM hrat_file,hrag_file
           WHERE hratid=l_hratid AND hrag01='314' AND hrag06=hrat12
          SELECT hrat13 INTO sr.hrat13 FROM hrat_file WHERE hratid=l_hratid
          SELECT hrag07 INTO sr.hrat28 FROM hrat_file,hrag_file
           WHERE hratid=l_hratid AND hrag01='302' AND hrag06=hrat28 
      
          EXECUTE insert_prep USING sr.*
          
       END FOREACH 
       
       
       SELECT hraa12 INTO l_hraa12 FROM hraa_file WHERE hraa01=tm.hraa01
       
       LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," ORDER BY xuhao"
       LET g_str = ''
       LET g_str = g_str,";",l_hraa12,";",tm.hrct04,";",tm.hrct05
       CALL cl_prt_cs3('ghrr027','ghrr027',g_sql,g_str)
                                                           
END FUNCTION   
            
              
