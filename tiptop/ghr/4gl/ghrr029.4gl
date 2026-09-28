# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghrr029.4gl
# Descriptions...: 职务薪资结构体系分析表
# Date & Author..: 13/09/27 by zhangbo

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE  tm    RECORD 
          hrdxa06    LIKE   hraa_file.hraa01,
          hrct04     LIKE   hrct_file.hrct04,
          wc         LIKE   type_file.chr1000,
          more       LIKE   type_file.chr1
              END RECORD
DEFINE l_table         STRING 
DEFINE l_table1        STRING 
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
   
   #LET g_sql = " renshu.type_file.num5,",                 #mark by zhangbo131008
   #            " hrar02.hrag_file.hrag07,",               #mark by zhangbo131008
   LET g_sql = " hrar02.hrag_file.hrag07,",                #add by zhangbo131008
               " renshu.type_file.num5,",                  #add by zhangbo131008
               " srfl.hrag_file.hrag07,",  
               " srje.hrdxa_file.hrdxa08 "
                                              
   LET l_table = cl_prt_temptable('ghrr029',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-750129  --End
   
   {
   LET g_sql = " hrdxa02.hrdxa_file.hrdxa02,",
               " hrdxa23.hrdxa_file.hrdxa23,",
               " hrdxa24.hrdxa_file.hrdxa24,",
               " hrdxa25.hrdxa_file.hrdxa25,",
               " hrdxa26.hrdxa_file.hrdxa26,",
               " hrdxa27.hrdxa_file.hrdxa27,",  
               " hrar02.hrar_file.hrar02 "
                                              
   LET l_table1 = cl_prt_temptable('ghrr0291',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-750129  --End
   }
   
   
   #-----TQC-610059---------
   LET g_pdate=ARG_VAL(1)
   LET g_towhom=ARG_VAL(2)
   LET g_rlang=ARG_VAL(3)
   LET g_bgjob=ARG_VAL(4)
   LET g_prtway=ARG_VAL(5)
   LET g_copies=ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.hrdxa06 = ARG_VAL(8)
   LET tm.hrct04 = ARG_VAL(9)
   #No:FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No:FUN-7C0078

   IF (cl_null(g_bgjob) OR g_bgjob = 'N') AND cl_null(tm.wc) THEN
      CALL ghrr029_tm(0,0)                     # Input print condition
   ELSE                                   
      CALL ghrr029()                                # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN

FUNCTION ghrr029_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680137 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
   DEFINE l_hraa12       LIKE hraa_file.hraa12       
   DEFINE l_n            LIKE type_file.num5   


   LET p_row = 7
   LET p_col = 17

   OPEN WINDOW r029_w AT p_row,p_col WITH FORM "ghr/42f/ghrr029"
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
   	  INPUT BY NAME tm.hrdxa06,tm.hrct04,tm.more  WITHOUT DEFAULTS              

      AFTER FIELD hrdxa06
         IF NOT cl_null(tm.hrdxa06) THEN
            LET l_n=0
            SELECT COUNT(*) INTO l_n FROM hraa_file WHERE hraa01=tm.hrdxa06 
                                                      AND hraaacti='Y'
            IF l_n=0 THEN
            	 CALL cl_err("无此公司编号","!",0)
            	 NEXT FIELD hrdxa06
            END IF
            SELECT hraa12 INTO l_hraa12 FROM hraa_file WHERE hraa01=tm.hrdxa06
            DISPLAY l_hraa12 TO hraa12		                                           
         END IF

      AFTER FIELD hrct04
         IF NOT cl_null(tm.hrct04) THEN
            LET l_n=0
            SELECT COUNT(*) INTO l_n FROM hrct_file WHERE hrct03=tm.hrdxa06
                                                      AND hrct04=tm.hrct04
            IF l_n=0 THEN
            	 CALL cl_err("无此基准年度","!",0)
            	 NEXT FIELD hrct04
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
           WHEN INFIELD(hrdxa06)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hraa01"
              LET g_qryparam.default1 = tm.hrdxa06
              CALL cl_create_qry() RETURNING tm.hrdxa06
              DISPLAY BY NAME tm.hrdxa06
              NEXT FIELD hrdxa06
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
         LET INT_FLAG = 0 CLOSE WINDOW r029_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
         EXIT PROGRAM
      END IF
   	
      CONSTRUCT BY NAME tm.wc ON hrdxa04
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
              WHEN INFIELD(hrdxa04) #查詢單据
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_hrao01"
                   LET g_qryparam.arg1= tm.hrdxa06 
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO hrdxa04
                   NEXT FIELD hrdxa04
           END CASE

      END CONSTRUCT
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW r029_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
         EXIT PROGRAM
      END IF
   	
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='ghrr029'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('ghrr029','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            " '",g_rlang CLIPPED,"'",
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.hrdxa06 CLIPPED,"'",
                            " '",tm.hrct04 CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'" ,
                            " '",g_rep_user CLIPPED,"'",
                            " '",g_rep_clas CLIPPED,"'",
                            " '",g_template CLIPPED,"'",
                            " '",g_rpt_name CLIPPED,"'"
            CALL cl_cmdat('ghrr029',g_time,l_cmd)      # Execute cmd at later time
         END IF
         CLOSE WINDOW r029_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-690126
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL ghrr029()
      ERROR ""
   END WHILE
   CLOSE WINDOW r029_w		
   
END FUNCTION 

FUNCTION ghrr029()
DEFINE l_sql    STRING
DEFINE sr    RECORD
         #renshu    LIKE     type_file.num5,             #mark by zhangbo131008
         #hrar02    LIKE     hrag_file.hrag07,           #mark by zhangbo131008
         hrar02    LIKE     hrag_file.hrag07,            #add by zhangbo131008 
         renshu    LIKE     type_file.num5,              #add by zhangbo131008
         srfl      LIKE     hrag_file.hrag07,      
         srje      LIKE     hrdxa_file.hrdxa08
               END RECORD
DEFINE sr1   RECORD
         hrdxa02   LIKE     hrdxa_file.hrdxa02,
         hrdxa23   LIKE     hrdxa_file.hrdxa23,
         hrdxa24   LIKE     hrdxa_file.hrdxa24,
         hrdxa25   LIKE     hrdxa_file.hrdxa25,
         hrdxa26   LIKE     hrdxa_file.hrdxa26,               
         hrdxa27   LIKE     hrdxa_file.hrdxa27,
         hrar02    LIKE     hrar_file.hrar02
               END RECORD
DEFINE l_hratid    LIKE     hrat_file.hratid
DEFINE l_hraa12    LIKE     hraa_file.hraa12
DEFINE l_hrar02    LIKE     hrar_file.hrar02

        CALL cl_del_data(l_table) 
        
        DROP TABLE r029_tmp
        CREATE TEMP TABLE r029_tmp(
        hrdxa02   LIKE hrdxa_file.hrdxa02,
        hrdxa23   LIKE hrdxa_file.hrdxa23,
        hrdxa24   LIKE hrdxa_file.hrdxa24,
        hrdxa25   LIKE hrdxa_file.hrdxa25,
        hrdxa26   LIKE hrdxa_file.hrdxa26,
        hrdxa27   LIKE hrdxa_file.hrdxa27,
        hrar02    LIKE hrar_file.hrar02)
        
         
        SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog     
        SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
        LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('hrdxauser', 'hrdxagrup')
        
        LET l_sql=" SELECT hrdxa02,SUM(NVL(hrdxa23,0)),SUM(NVL(hrdxa24,0)),SUM(NVL(hrdxa25,0)),",
                  "        SUM(NVL(hrdxa26,0)),SUM(NVL(hrdxa27,0)),hrar02 ",
                  #"   FROM hrdx_file,hrdxa_file,hrct_file,hrat_file,hras_file,hrar_file,hrad_file ",   #mark by zhangbo1301010
                  "   FROM hrdx_file,hrdxa_file,hrct_file,hrat_file,hras_file,hrar_file ",              #add by zhangbo131010 
                  "  WHERE hrdx01=hrdxa01 AND hrdx04=hrdxa22 ",
                  "    AND hrdx03=hrct04 AND  hrct04='",tm.hrct04,"' ",
                  "    AND hrdx01=hrct11 AND  hrdxa06='",tm.hrdxa06,"' ",
                  "    AND hrdxa02=hratid AND hrat05=hras01 AND hras03=hrar03 ",
                  #"    AND hrad02=hrat19 AND hrad01<>'003' ",                                          #mark by zhangbo1301010
                  "    AND ",tm.wc CLIPPED,
                  "   GROUP BY hrdxa02,hrar02 "
        
       PREPARE ghrr029_prepare1 FROM l_sql
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('prepare:',SQLCA.sqlcode,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
          EXIT PROGRAM
       END IF
       DECLARE ghrr029_curs1 CURSOR FOR ghrr029_prepare1 
       
       FOREACH ghrr029_curs1 INTO sr1.*
          
          INSERT INTO r029_tmp VALUES (sr1.*)
          
       END FOREACH
       
       
       LET l_sql="SELECT DISTINCT hrar02 FROM r029_tmp"
       
       PREPARE ghrr029_prepare2 FROM l_sql
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('prepare:',SQLCA.sqlcode,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
          EXIT PROGRAM
       END IF
       DECLARE ghrr029_curs2 CURSOR FOR ghrr029_prepare2
       
       FOREACH ghrr029_curs2 INTO l_hrar02
          SELECT hrag07 INTO sr.hrar02 FROM hrag_file WHERE hrag01='203' AND hrag06=l_hrar02
          #LET l_sql=" SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
          #          "  WHERE hrar02='",l_hrar02,"' "
          #PREPARE r029_count FROM l_sql
          #EXECUTE r029_count INTO sr.renshu
          
          #SELECT COUNT(*) INTO sr.renshu FROM r029_tmp WHERE hrar02=l_hrar02   #mark by zhangbo131010
          CALL r029_renshu(l_hrar02)  RETURNING sr.renshu
          
          #LET l_sql=" SELECT SUM(hrdxa23) FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
          #          "  WHERE hrar02='",l_hrar02,"' "
          #PREPARE r029_hrdxa23 FROM l_sql
          #EXECUTE r029_hrdxa23 INTO sr.srje
          SELECT SUM(hrdxa23) INTO sr.srje FROM r029_tmp WHERE hrar02=l_hrar02
          LET sr.srfl="固定收入"
          
          EXECUTE insert_prep USING sr.*
          
          #LET l_sql=" SELECT SUM(hrdxa24) FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
          #          "  WHERE hrar02='",l_hrar02,"' "
          #PREPARE r029_hrdxa24 FROM l_sql
          #EXECUTE r029_hrdxa24 INTO sr.srje
          SELECT SUM(hrdxa24) INTO sr.srje FROM r029_tmp WHERE hrar02=l_hrar02
          LET sr.srfl="浮动收入"
          
          EXECUTE insert_prep USING sr.*
          
          #LET l_sql=" SELECT SUM(hrdxa25) FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
          #          "  WHERE hrar02='",l_hrar02,"' "
          #PREPARE r029_hrdxa25 FROM l_sql
          #EXECUTE r029_hrdxa25 INTO sr.srje
          SELECT SUM(hrdxa25) INTO sr.srje FROM r029_tmp WHERE hrar02=l_hrar02
          LET sr.srfl="奖金收入"
          
          EXECUTE insert_prep USING sr.*
          
          #LET l_sql=" SELECT SUM(hrdxa26) FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
          #          "  WHERE hrar02='",l_hrar02,"' "
          #PREPARE r029_hrdxa26 FROM l_sql
          #EXECUTE r029_hrdxa26 INTO sr.srje
          SELECT SUM(hrdxa26) INTO sr.srje FROM r029_tmp WHERE hrar02=l_hrar02
          LET sr.srfl="员工福利"
          
          EXECUTE insert_prep USING sr.*
          
          #LET l_sql=" SELECT SUM(hrdxa27) FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
          #          "  WHERE hrar02='",l_hrar02,"' "
          #PREPARE r029_hrdxa27 FROM l_sql
          #EXECUTE r029_hrdxa27 INTO sr.srje
          SELECT SUM(hrdxa27) INTO sr.srje FROM r029_tmp WHERE hrar02=l_hrar02
          LET sr.srfl="其它收入"
          
          EXECUTE insert_prep USING sr.*
          
                                       
       END FOREACH 
       
       SELECT hraa12 INTO l_hraa12 FROM hraa_file WHERE hraa01=tm.hrdxa06
       
       LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
       LET g_str = ''
       LET g_str = g_str,";",l_hraa12
       CALL cl_prt_cs3('ghrr029','ghrr029',g_sql,g_str)
       
       
END FUNCTION       
       
#add by zhangbo131010---begin                    
FUNCTION r029_renshu(p_hrar02)
DEFINE l_sum,l_sum1,l_sum2       LIKE     type_file.num10
DEFINE l_date    LIKE type_file.dat
DEFINE p_hrar02  LIKE hrar_file.hrar02
DEFINE l_sql     STRING
DEFINE l_wc      STRING
        
        CALL cl_replace_str(tm.wc,'hrdxa04','hrat04') RETURNING l_wc

        SELECT  MDY('12','31',tm.hrct04) INTO l_date    FROM  dual

        LET l_sql=" SELECT  COUNT(*) FROM  hrat_file,hras_file,hrar_file,hrad_file,hrag_file",
                  "  WHERE  hrat25 <= to_date('",l_date,"','yyyy/mm/dd') ",
                  "    AND  hrat05=hras01 ",
                  "    AND  hras03=hrar03 ",
                  "    AND  hrar02 = hrag06 ",
                  "    AND  hrag01 = '203' ",
                  "    AND  hrar02 = '",p_hrar02,"' ",
                  "    AND  hrat19 = hrad02 ",
                  "    AND  hrad01 != '003' ",
                  "    AND ",l_wc CLIPPED
        PREPARE r029_sum1 FROM l_sql
        EXECUTE r029_sum1 INTO l_sum1

        LET l_sql=" SELECT  COUNT(*) FROM  hrat_file,hras_file,hrar_file,hrad_file,hrag_file ",
                  "  WHERE  hrat25 <= to_date('",l_date,"','yyyy/mm/dd') ",
                  "   AND  hrat05=hras01 ",
                  "   AND  hras03=hrar03 ",
                  "   AND  hrar02 = hrag06 ",
                  "   AND  hrag01 = '203' ",
                  "   AND  hrar02 = '",p_hrar02,"' ",
                  "   AND  hrat19 = hrad02 ",
                  "   AND  hrad01 = '003' ",
                  "   AND  hrat77 >= to_date('",l_date,"','yyyy/mm/dd') ",
                  "   AND ",l_wc CLIPPED
        PREPARE r029_sum2 FROM l_sql
        EXECUTE r029_sum2 INTO l_sum2

        LET l_sum = l_sum1 + l_sum2
        RETURN  l_sum
END FUNCTION
#add by zhangbo131010---end
                                            
