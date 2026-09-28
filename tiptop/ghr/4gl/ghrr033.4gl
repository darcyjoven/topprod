# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghrr033.4gl
# Descriptions...: 员工月度工资构成分析图
# Date & Author..: 13/09/28 by zhuzw

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE  tm    RECORD 
          hrct03     LIKE   hrct_file.hrct03,
          hrct04     LIKE   hrct_file.hrct04,
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
   
   LET g_sql = " month.type_file.num10,",
               " hrag07.hrag_file.hrag07,",
               " flje.hrdxa_file.hrdxa24, ",
               " renshu.type_file.num10 "
               
                                              
   LET l_table = cl_prt_temptable('ghrr033',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ? ,? )"
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
   LET tm.hrct03 = ARG_VAL(8)
   LET tm.hrct04 = ARG_VAL(9)
   #No:FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No:FUN-7C0078

   IF (cl_null(g_bgjob) OR g_bgjob = 'N') AND cl_null(tm.wc) THEN
      CALL ghrr033_tm(0,0)                     # Input print condition
   ELSE                                   
      CALL ghrr033()                                # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN 

FUNCTION ghrr033_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680137 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
   DEFINE l_hraa12       LIKE hraa_file.hraa12       
   DEFINE l_n            LIKE type_file.num5   


   LET p_row = 7
   LET p_col = 17

   OPEN WINDOW r033_w AT p_row,p_col WITH FORM "ghr/42f/ghrr033"
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
   	  INPUT BY NAME tm.hrct03,tm.hrct04,tm.more  WITHOUT DEFAULTS              

      AFTER FIELD hrct03
         IF NOT cl_null(tm.hrct03) THEN
            LET l_n=0
            SELECT COUNT(*) INTO l_n FROM hraa_file WHERE hraa01 = tm.hrct03 
                                                      AND hraaacti='Y'
            IF l_n=0 THEN
            	 CALL cl_err("无此公司编号","!",0)
            	 NEXT FIELD hrct03
            END IF
            SELECT hraa12 INTO l_hraa12 FROM hraa_file WHERE hraa01=tm.hrct03
            DISPLAY l_hraa12 TO hraa12		                                           
         END IF

      AFTER FIELD hrct04
        IF NOT cl_null(tm.hrct04) THEN
            LET l_n=0
            SELECT COUNT(*) INTO l_n FROM hrct_file WHERE hrct03=tm.hrct03
                                                      AND hrct04=tm.hrct04
            IF l_n=0 THEN
            	 CALL cl_err("无此基准年度","!",0)
            	 NEXT FIELD hrct04
            END IF
         ELSE 
         	    NEXT FIELD hrct04 	                                           
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
           WHEN INFIELD(hrct03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hraa01"
              LET g_qryparam.default1 = tm.hrct03
              CALL cl_create_qry() RETURNING tm.hrct03
              DISPLAY BY NAME tm.hrct03
              NEXT FIELD hrct03
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
         LET INT_FLAG = 0 CLOSE WINDOW r033_w
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
                   LET g_qryparam.arg1= tm.hrct03 
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
         LET INT_FLAG = 0 CLOSE WINDOW r033_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
         EXIT PROGRAM
      END IF
   	
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='ghrr033'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('ghrr033','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"") #"
            LET l_cmd = l_cmd CLIPPED,
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            " '",g_rlang CLIPPED,"'",
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                              " '",tm.wc CLIPPED,"'" ,
                            " '",tm.hrct03 CLIPPED,"'",
                            " '",tm.hrct04 CLIPPED,"'",
                            " '",g_rep_user CLIPPED,"'",
                            " '",g_rep_clas CLIPPED,"'",
                            " '",g_template CLIPPED,"'",
                            " '",g_rpt_name CLIPPED,"'"
            CALL cl_cmdat('ghrr033',g_time,l_cmd)      # Execute cmd at later time
         END IF
         CLOSE WINDOW r033_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-690126
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL ghrr033()
      ERROR ""
   END WHILE
   CLOSE WINDOW r033_w		
   
END FUNCTION


FUNCTION ghrr033()
DEFINE l_sql    STRING
DEFINE l_date    LIKE type_file.dat
DEFINE sr1    RECORD
         hrct05     LIKE     type_file.num10,
         hrdxa23    LIKE     hrdxa_file.hrdxa23,
         hrdxa24    LIKE     hrdxa_file.hrdxa24,
         hrdxa25    LIKE     hrdxa_file.hrdxa25,
         hrdxa26    LIKE     hrdxa_file.hrdxa26,
         hrdxa27    LIKE     hrdxa_file.hrdxa27,
         renshu     LIKE     type_file.num10
         
               END RECORD
DEFINE sr    RECORD 
       hrct05       LIKE    type_file.num10,
       hrag07       LIKE    hrag_file.hrag07,
       flje         LIKE    hrdxa_file.hrdxa23,
       renshu       LIKE     type_file.num10
              END RECORD    
DEFINE l_hraa12    LIKE     hraa_file.hraa12  
DEFINE l_sum,l_sum1,l_sum2       LIKE     type_file.num10           
        
        CALL cl_del_data(l_table)  
        SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog     
        SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
        SELECT  MDY('12','31',tm.hrct04) INTO l_date    FROM  dual
        SELECT  COUNT(*) INTO l_sum1  FROM  hrat_file,hrad_file  
         WHERE  hrat25 <= to_date(l_date,'yyyy/mm/dd')
           AND  hrat19 = hrad02
           AND  hrad01 != '003'                    
        SELECT  COUNT(*) INTO l_sum2  FROM  hrat_file,hrad_file   
         WHERE  hrat25 <= to_date(l_date,'yyyy/mm/dd')
           AND  hrat19 = hrad02
           AND  hrad01 = '003' 
           AND  hrat77 >= to_date(l_date,'yyyy/mm/dd')
           LET l_sum = l_sum1 + l_sum2           
        LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('hrctuser', 'hrctgrup')
        LET l_sql=  "  select to_number(hrct05),SUM(NVL(hrdxa23,0)),SUM(NVL(hrdxa24,0)),SUM(NVL(hrdxa25,0)),SUM(NVL(hrdxa26,0)),SUM(NVL(hrdxa27,0)),0 from hrdxa_file,hrdx_file,hrct_file", 
                    "   where hrdx01 = hrct11 and hrdx02 = hrct03 ",
                    "     and hrdx01 = hrdxa01 and hrdxa22= hrdx04 and hrct04 = '",tm.hrct04,"' ",
                    "     and hrct03 = '",tm.hrct03,"' and ",tm.wc CLIPPED, 
                    "   group by hrct05  order by to_number(hrct05)   "
                    
       PREPARE ghrr033_prepare1 FROM l_sql
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('prepare:',SQLCA.sqlcode,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
          EXIT PROGRAM
       END IF
       DECLARE ghrr033_curs1 CURSOR FOR ghrr033_prepare1        
       FOREACH ghrr033_curs1 INTO sr1.*
                      
         LET sr.hrct05 = sr1.hrct05
         LET sr.hrag07 = '固定收入'
         LET sr.flje = sr1.hrdxa23 
         LET sr.renshu = l_sum
         EXECUTE insert_prep USING sr.*   
         LET sr.hrct05 = sr1.hrct05
         LET sr.hrag07 = '浮动收入'
         LET sr.flje = sr1.hrdxa24
         LET sr.renshu = l_sum 
         EXECUTE insert_prep USING sr.* 
         LET sr.hrct05 = sr1.hrct05
         LET sr.hrag07 = '奖金收入'
         LET sr.flje = sr1.hrdxa25
         LET sr.renshu = l_sum
         EXECUTE insert_prep USING sr.* 
         LET sr.hrct05 = sr1.hrct05
         LET sr.hrag07 = '福利收入'
         LET sr.flje = sr1.hrdxa26
         LET sr.renshu = l_sum
         EXECUTE insert_prep USING sr.*          
         LET sr.hrct05 = sr1.hrct05
         LET sr.hrag07 = '其他收入'
         LET sr.flje = sr1.hrdxa27
         
         EXECUTE insert_prep USING sr.* 
          
       END FOREACH 
       
       
       SELECT hraa12 INTO l_hraa12 FROM hraa_file WHERE hraa01=tm.hrct03
       
       LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table
       LET g_str = ''
       LET g_str = g_str,";",l_hraa12,";",tm.hrct04
       CALL cl_prt_cs3('ghrr033','ghrr033',g_sql,g_str)
                                                           
END FUNCTION   

