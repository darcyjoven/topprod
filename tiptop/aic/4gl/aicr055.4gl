# Prog. Version..: '5.30.06-13.03.12(00003)'     #
# Pattern name...: aicr055.4gl
# Descriptions...: 批號追蹤作業
# Date & Author..: 11/12/01 By jason(FUN-BC0005)
# Modify.........: TQC-C40282 By chenjing 修改點擊確定后出現的controlz按鈕
# Modify.........: NO.TQC-C50082 12/05/10 By fengrui 把必要字段controlz換成controlr

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
     tm RECORD
        wc      STRING,
        estyle  LIKE type_file.chr1,         
        more    LIKE type_file.chr1
        END RECORD
DEFINE  g_lot   LIKE idc_file.idc04
                
DEFINE  g_cnt           LIKE type_file.num10
DEFINE  g_msg           LIKE type_file.chr1000
DEFINE  g_row_count     LIKE type_file.num10
DEFINE  g_curs_index    LIKE type_file.num10
DEFINE  g_jump          LIKE type_file.num10
DEFINE  mi_no_ask       LIKE type_file.num5
DEFINE  g_no_ask        LIKE type_file.num5
DEFINE  lc_qbe_sn       LIKE gbm_file.gbm01 
DEFINE  g_wc,g_wc1      STRING 
DEFINE  l_table    STRING
DEFINE  g_str      STRING
DEFINE  g_sql      STRING
        

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

   LET g_sql = "qlot.idc_file.idc04,",
               "part.idc_file.idc01,",
               "idc01.idc_file.idc01,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "idc09.idc_file.idc09,",
               "ima06.ima_file.ima06,",
               "ima08.ima_file.ima08,",
               "idc19.idc_file.idc19,",
               "ima02_2.ima_file.ima02,",
               "idc07.idc_file.idc07,",
               "idc02.idc_file.idc02,",
               "idc03.idc_file.idc03,",
               "idc04.idc_file.idc04,",
               "idc10.idc_file.idc10,",
               "idc08.idc_file.idc08,",
               "idc12.idc_file.idc12,",
               "idc17.idc_file.idc17"
      
   LET l_table = cl_prt_temptable('aicr055',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?, ?,?, ?,?, ?,?, ?,?, ?,?, ?,?, ?,?, ?,?) "
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',STATUS,1) 
      EXIT PROGRAM                                                                             
   END IF

   IF NOT r055_create_tmp() THEN
      CALL cl_err('create_tmp:',STATUS,1)
      EXIT PROGRAM 
   END IF
   
   LET g_pdate  = ARG_VAL(1) 
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.estyle= ARG_VAL(8)   
   LET tm.more  = ARG_VAL(9)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  

   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r055_tm()
   ELSE 
      CALL r055()   
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION r055_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
DEFINE p_row, p_col   LIKE type_file.num5
DEFINE l_cmd          LIKE type_file.chr1000  

   LET p_row = 0 LET p_col = 0
   
   OPEN WINDOW r055_w AT p_row, p_col
        WITH FORM "aic/42f/aicr055" ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL         
   LET tm.more = 'N'   
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.estyle = '1'
   WHILE TRUE
     CONSTRUCT tm.wc ON idc01,idc09,idc04,idc11 FROM a1,a2,a3,a4
              
      BEFORE CONSTRUCT
        CALL cl_qbe_init()
       
      ON ACTION CONTROLP
         CASE 
            WHEN INFIELD(a1)    #料號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_idc"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO a1
                 NEXT FIELD a1
            WHEN INFIELD(a2)    #母體
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_idc08"
                 LET g_qryparam.arg1 = "0"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO a2
                 NEXT FIELD a2
            WHEN INFIELD(a3)    #批號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_idc09"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO a3
                 NEXT FIELD a3
            WHEN INFIELD(a4)    #date code
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_idc11"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO a4
                 NEXT FIELD a4              
          END CASE

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
         LET INT_FLAG = 0 CLOSE WINDOW r055_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
            
      END IF

      DISPLAY BY NAME tm.more,tm.estyle
      INPUT tm.estyle,tm.more WITHOUT DEFAULTS FROM estyle,MORE
      
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
           IF tm.estyle NOT MATCHES '[123]' THEN
              NEXT FIELD estyle
           END IF    

     #TQC-C40282--mark--
     #  ON ACTION CONTROLZ
     #     CALL cl_show_req_fields()
     #TQC-C40282--mark--
         ON ACTION CONTROLR             #TQC-C50082 add
            CALL cl_show_req_fields()   #TQC-C50082 add

        ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
       
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
         LET INT_FLAG = 0 CLOSE WINDOW r055_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM            
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file   
                WHERE zz01='aicr055'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aicr055','9031',1)   
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
                            " '",tm.more CLIPPED,"'" ,
                            " '",g_rep_user CLIPPED,"'", 
                            " '",g_rep_clas CLIPPED,"'",  
                            " '",g_template CLIPPED,"'",
                            " '",g_rpt_name CLIPPED,"'"  
             CALL cl_cmdat('aicr055',g_time,l_cmd)    
         END IF
         CLOSE WINDOW r055_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r055()
      ERROR ""
   END WHILE
   CLOSE WINDOW r055_w
END FUNCTION

FUNCTION r055()
DEFINE l_sql   STRING
DEFINE l_idc   RECORD
                qlot         LIKE idc_file.idc04,
                part         LIKE idc_file.idc01,
                idc01        LIKE idc_file.idc01,
                ima02        LIKE ima_file.ima02,
                ima021       LIKE ima_file.ima021,
                idc09        LIKE idc_file.idc09,
                ima06        LIKE ima_file.ima06,
                ima08        LIKE ima_file.ima08,
                idc19        LIKE idc_file.idc19,
                ima02_2      LIKE ima_file.ima02,
                idc07        LIKE idc_file.idc07,
                idc02        LIKE idc_file.idc02,
                idc03        LIKE idc_file.idc03,
                idc04        LIKE idc_file.idc04,
                idc10        LIKE idc_file.idc10,
                idc08        LIKE idc_file.idc08,
                idc12        LIKE idc_file.idc12,
                idc17        LIKE idc_file.idc17
               END RECORD
   
   DELETE FROM r055_tmp
   CALL cl_del_data(l_table)
   
   LET g_sql = "SELECT DISTINCT idc04 FROM idc_file ",
               " WHERE idc04 IS NOT NULL AND idc10 IS NOT NULL ",
               "   AND ",tm.wc,
               " ORDER BY idc04 "               
   PREPARE r055_pre FROM g_sql
   DECLARE r055_cs CURSOR WITH HOLD FOR r055_pre
   
   FOREACH r055_cs INTO g_lot
      CALL r055_ins_tmp()
   END FOREACH

   IF tm.estyle = '2' THEN
      LET l_sql = "SELECT DISTINCT qlot,part,idc01,idc02, ",
                  "                idc03,idc04,seq ",
                  "  FROM r055_tmp ",
                  " ORDER BY part,seq DESC "
   ELSE
      LET l_sql = "SELECT DISTINCT qlot,part,idc01,idc02, ",
                  "                idc03,idc04,seq ",
                  "  FROM r055_tmp ",
                  " ORDER BY part ,seq "
   END IF
   PREPARE r055_p1_pre FROM l_sql
   DECLARE r055_c1 CURSOR FOR r055_p1_pre
   
   FOREACH r055_c1 INTO l_idc.qlot,l_idc.part,l_idc.idc01, 
                        l_idc.idc02,l_idc.idc03,
                        l_idc.idc04
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF      
 
      SELECT SUM(idc08),SUM(idc12) 
        INTO l_idc.idc08,l_idc.idc12
        FROM idc_file
       WHERE idc01 = l_idc.idc01
         AND idc02 = l_idc.idc02
         AND idc03 = l_idc.idc03
         AND idc04 = l_idc.idc04 
 
      DECLARE r055_c2 CURSOR FOR
       SELECT a.ima02,a.ima021, idc09,a.ima06,a.ima08,idc19,b.ima02,idc07,idc10,idc17
        FROM idc_file, OUTER ima_file a, OUTER ima_file b
         WHERE idc01 = l_idc.idc01 
           AND idc02 = l_idc.idc02 
           AND idc03 = l_idc.idc03 
           AND idc04 = l_idc.idc04 
           AND idc_file.idc01 = a.ima01 
           AND idc_file.idc19 = b.ima01
           
      FOREACH r055_c2 INTO l_idc.ima02,l_idc.ima021,
                           l_idc.idc09,l_idc.ima06,
                           l_idc.ima08,l_idc.idc19,
                           l_idc.ima02_2,l_idc.idc07,
                           l_idc.idc10,l_idc.idc17
         IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH r055_c2',SQLCA.sqlcode,0)
            EXIT FOREACH            
         END IF         
      END FOREACH     
      
      EXECUTE insert_prep USING l_idc.* 
   END FOREACH
   LET g_str=tm.wc,";",g_towhom
   LET g_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
   DISPLAY g_sql                                                     
   CALL cl_prt_cs3('aicr055','aicr055',g_sql,g_str) 
END FUNCTION

FUNCTION r055_ins_tmp()
   DEFINE l_sql     STRING,
          l_rec     LIKE type_file.num5
   DEFINE l_data    RECORD                    
                    idc01 LIKE idc_file.idc01, 
                    idc02 LIKE idc_file.idc02,
                    idc03 LIKE idc_file.idc03,
                    idc04 LIKE idc_file.idc04,
                    lot       LIKE idc_file.idc04,
                    type      LIKE type_file.chr1,
                    seq       LIKE type_file.num5
                    END RECORD
                    
   CASE 
       WHEN tm.estyle = '1'
            LET l_sql = "INSERT INTO r055_tmp ",
                        "SELECT DISTINCT '", g_lot, "' qlot,idc01 part,idc01,idc02, ",
                        "       idc03,idc04,idc04 lot,'1',0 ",
                        "  FROM idc_file ",
                        " WHERE idc04 IS NOT NULL ",
                        "   AND idc10 IS NOT NULL ",
                        "   AND idc04 = '",g_lot,"' AND ",tm.wc
       WHEN tm.estyle = '2'
            LET l_sql = "INSERT INTO r055_tmp ",
                        "SELECT DISTINCT '", g_lot, "' qlot,idc01 part,idc01,idc02, ",
                        "       idc03,idc04,idc10 lot,'2',0 ",
                        "  FROM idc_file ",
                        " WHERE idc04 IS NOT NULL ",
                        "   AND idc10 IS NOT NULL ",
                        "   AND idc04 = '",g_lot,"' AND ",tm.wc
       WHEN tm.estyle = '3'
            LET l_sql = "INSERT INTO r055_tmp ",
                        "SELECT DISTINCT '", g_lot, "' qlot, idc01 part,idc01,idc02, ",
                        "       idc03,idc04,idc04 lot,'1' type,0",
                        "  FROM idc_file ",
                        " WHERE idc04 IS NOT NULL ",
                        "   AND idc10 IS NOT NULL ",
                        "   AND idc04 = '",g_lot,"' AND ",tm.wc,
                        " UNION ",
                        "SELECT DISTINCT '", g_lot, "' qlot, idc01 part,idc01,idc02,",
                        "       idc03,idc04,idc10 lot,'2' type,0",
                        "  FROM idc_file ",
                        " WHERE idc04 IS NOT NULL ",
                        "   AND idc10 IS NOT NULL ",
                        "   AND idc04 = '",g_lot,"' AND ",tm.wc
   END CASE
   PREPARE r055_ins_pre FROM l_sql
   EXECUTE r055_ins_pre
 
   LET l_sql = "SELECT part,idc02,idc03,idc04,lot,type,seq ",
               "  FROM r055_tmp"
   PREPARE r055_pre1 FROM l_sql
   DECLARE r055_cs1 CURSOR FOR r055_pre1
 
   LET l_rec = 1
   FOREACH r055_cs1 INTO l_data.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH r055_cs1',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
      CALL r055_ex(l_data.idc01,l_data.*)
      LET l_rec = l_rec + 1
      IF l_rec > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH  
                    
END FUNCTION

FUNCTION r055_ex(p_key,p_data)
   DEFINE l_sql     STRING 
   DEFINE p_key     LIKE idc_file.idc01
   DEFINE p_data    RECORD                    
                    idc01 LIKE idc_file.idc01,
                    idc02 LIKE idc_file.idc02, 
                    idc03 LIKE idc_file.idc03,
                    idc04 LIKE idc_file.idc04,
                    lot       LIKE idc_file.idc10,
                    type      LIKE type_file.chr1,
                    seq       LIKE type_file.num5
                    END RECORD
   DEFINE l_data    DYNAMIC ARRAY OF RECORD
                    idc01   LIKE idc_file.idc01,
                    idc02   LIKE idc_file.idc02,
                    idc03   LIKE idc_file.idc03,
                    idc04   LIKE idc_file.idc04,
                    lot     LIKE idc_file.idc10,
                    type    LIKE type_file.chr1,
                    seq     LIKE type_file.num5
                    END RECORD
   DEFINE l_rec     LIKE type_file.num5
   DEFINE l_i       LIKE type_file.num5
 
   CASE p_data.type
        WHEN '1' 
             LET l_sql = "SELECT DISTINCT idc01,idc02,idc03, ",
                         "       idc04,idc04,'1' ",
                         " FROM  idc_file",
                         " WHERE idc10='",p_data.lot,"'",
                         "   AND idc04 IS NOT NULL ",
                         "   AND idc10 IS NOT NULL ",
                         "   AND(idc01||idc02||idc03||idc04) ",
                         "   NOT IN(SELECT idc01||idc02|| ",
                         "                 idc03||idc04 ",
                         "           FROM r055_tmp ",
                         "           WHERE part = '",p_key,"' )"
        WHEN '2'
             LET l_sql = "SELECT DISTINCT idc01,idc02,idc03, ",
                         "       idc04,idc10,'2' ",
                         " FROM  idc_file",
                         " WHERE idc04='",p_data.lot,"'",
                                  "   AND idc04 IS NOT NULL ",
                         "   AND idc10 IS NOT NULL ",
                         "   AND(idc01||idc02||idc03||idc04) ",
                         "   NOT IN(SELECT idc01||idc02|| ",
                         "                 idc03||idc04 ",
                         "            FROM r055_tmp ",
                         "           WHERE part = '",p_key,"' )"
   END CASE
 
   PREPARE r055_pre2 FROM l_sql
   DECLARE r055_cs2 CURSOR FOR r055_pre2
   LET l_rec = 1
   FOREACH r055_cs2 INTO l_data[l_rec].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH r055_cs2',SQLCA.sqlcode,0)
          EXIT FOREACH
       END IF      
       CASE p_data.type
            WHEN '1'  LET l_data[l_rec].seq = p_data.seq + 1
            WHEN '2'  LET l_data[l_rec].seq = p_data.seq - 1
       END CASE
       INSERT INTO r055_tmp VALUES(g_lot,p_key,
                                   l_data[l_rec].idc01,
                                   l_data[l_rec].idc02,
                                   l_data[l_rec].idc03,
                                   l_data[l_rec].idc04,
                                   l_data[l_rec].lot,
                                   l_data[l_rec].type,
                                   l_data[l_rec].seq)
       LET l_rec = l_rec + 1
       IF l_rec > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL l_data.deleteElement(l_rec)
   LET l_rec = l_rec - 1
 
   FOR l_i = 1 TO l_rec
       CALL r055_ex(p_key,l_data[l_i].*)
   END FOR
END FUNCTION

FUNCTION r055_create_tmp()
   DROP TABLE r055_tmp
   CREATE TEMP TABLE r055_tmp(
          qlot   LIKE idc_file.idc04,
          part   LIKE ima_file.ima01,
          idc01  LIKE idc_file.idc01,
          idc02  LIKE idc_file.idc02,
          idc03  LIKE idc_file.idc03,
          idc04  LIKE idc_file.idc04,
          lot    LIKE idc_file.idc04,
          type   LIKE type_file.chr1,
          seq    LIKE type_file.num5) 
   IF SQLCA.sqlcode THEN 
      RETURN 0
   ELSE
      RETURN 1
   END IF
END FUNCTION
#FUN-BC0005

