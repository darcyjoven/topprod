# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: amdr103.4gl  
# Descriptions...: 媒體申報與總帳金額差異報表
# Date & Author..: No.FUN-8B0082 09/09/09 By hongmei
# Date & Author..: No:MOD-AB0081 10/11/09 By Dido 反推未稅時計算邏輯調整;以應稅為主 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm       RECORD
                   wc          LIKE type_file.chr1000,    # VARCHAR(1000)
                   amd171      LIKE amd_file.amd171,      
                   byy         LIKE type_file.num10,      #INTEGER #年度
                   bmm         LIKE type_file.num10,      #INTEGER #月份
                   emm         LIKE type_file.num10,      #INTEGER #月份 
                   more        LIKE type_file.chr1        #CHAR(01)
                END RECORD,
       g_ama    RECORD LIKE ama_file.*,
       g_zo     RECORD LIKE zo_file.*
DEFINE g_i            LIKE type_file.num5     #count/index for any purpose   
DEFINE g_str          STRING
DEFINE g_sql          STRING  
DEFINE l_table        STRING   
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMD")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   LET g_sql = "amd22.amd_file.amd22,", 
               "amd173.amd_file.amd173,",
               "amd174.amd_file.amd174,",
               "amd171.amd_file.amd171,",
               "amd07.amd_file.amd07,",
               "amd08.amd_file.amd08,",
               "tot1.type_file.num20_6,",
               "tot2.type_file.num20_6,", 
               "tot3.type_file.num20_6,", 
               "tot4.type_file.num20_6"  
   LET l_table = cl_prt_temptable('amdr103',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
   LET g_pdate   = ARG_VAL(1)
   LET g_towhom  = ARG_VAL(2)
   LET g_rlang   = ARG_VAL(3)
   LET g_bgjob   = ARG_VAL(4)
   LET g_prtway  = ARG_VAL(5)
   LET g_copies  = ARG_VAL(6)
   LET tm.amd171 = ARG_VAL(7)
   LET tm.byy    = ARG_VAL(8)
   LET tm.bmm    = ARG_VAL(9)
   LET tm.emm    = ARG_VAL(10)
   LET tm.wc     = ARG_VAL(11)
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   IF cl_null(g_bgjob) OR g_bgjob = 'N'  THEN
      CALL r103_tm()
   ELSE
      CALL r103()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION r103_tm()
   DEFINE l_cmd        LIKE type_file.chr1000    
   DEFINE p_row,p_col  LIKE type_file.num5         
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 4 LET p_col = 18
   ELSE LET p_row = 4 LET p_col = 14
   END IF
   OPEN WINDOW r103_w AT p_row,p_col
        WITH FORM "amd/42f/amdr103"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET tm.byy  =  YEAR(g_today)
   LET tm.bmm  = MONTH(g_today)
   LET tm.emm  = MONTH(g_today)  
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON  amd22
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
             
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(amd22)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_amd"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO amd22
                 NEXT FIELD amd22
         END CASE
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT CONSTRUCT
   END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r103_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
 
   INPUT BY NAME tm.amd171,tm.byy,tm.bmm,tm.emm,tm.more  
            WITHOUT DEFAULTS  
 
        AFTER FIELD byy
            IF cl_null(tm.byy) THEN
               NEXT FIELD byy
            END IF
         
         AFTER FIELD bmm
            IF cl_null(tm.bmm) THEN
               NEXT FIELD bmm
            END IF
            IF tm.bmm> 12 OR tm.bmm< 1 THEN
               NEXT FIELD bmm
            END IF
 
         AFTER FIELD emm
           IF cl_null(tm.emm) THEN
              NEXT FIELD emm
           END IF
           IF tm.emm > 12 OR tm.emm < 1 THEN
              NEXT FIELD emm
           END IF
           IF tm.emm < tm.bmm THEN
              NEXT FIELD emm
           END IF
           
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                             g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,
                         g_bgjob,g_time,g_prtway,g_copies
            END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
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
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r103_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='amdr103'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amdr103','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.amd171 CLIPPED,"'",
                         " '",tm.byy CLIPPED,"'",
                         " '",tm.bmm CLIPPED,"'",
                         " '",tm.emm CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",   
                         " '",g_rep_user CLIPPED,"'",  
                         " '",g_rep_clas CLIPPED,"'", 
                         " '",g_template CLIPPED,"'"  
         CALL cl_cmdat('amdr103',g_time,l_cmd)
      END IF
      CLOSE WINDOW r103_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r103()
   ERROR ""
END WHILE
   CLOSE WINDOW r103_w
END FUNCTION
 
FUNCTION r103()
   DEFINE l_name    LIKE type_file.chr20,      # External(Disk) file name
          l_sql     STRING,                    # RDSQL STATEMENT 
          l_chr     LIKE type_file.chr1,      
          l_za05    LIKE type_file.chr1000,    
       sr           RECORD
                    amd22   LIKE amd_file.amd22,
                    amd173  LIKE amd_file.amd173,
                    amd174  LIKE amd_file.amd174,
                    amd171  LIKE amd_file.amd171,
                    amd06   LIKE amd_file.amd06,
                    amd07   LIKE amd_file.amd07,
                    amd08   LIKE amd_file.amd08 
                    END RECORD
   DEFINE l_tot1    LIKE type_file.num20_6 
   DEFINE l_tot2    LIKE type_file.num20_6 
   DEFINE l_tot3    LIKE type_file.num20_6
   DEFINE l_tot4    LIKE type_file.num20_6
   
     CALL cl_del_data(l_table)   
    
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
       
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog  
    
     LET l_sql = "SELECT amd22,amd173,amd174,amd171,SUM(amd06),SUM(amd07),SUM(amd08) ",
                 "  FROM amd_file ",
                 " WHERE amd173='",tm.byy,"' ",
                 "   AND amd174 BETWEEN '",tm.bmm,"' AND '",tm.emm,"' ",  
                 "   AND amd30 = 'Y' ",
                 "   AND amd172 = '1' ",        #MOD-AB0081
                 "   AND ",tm.wc    
     IF cl_null(tm.amd171) THEN
        LET l_sql = l_sql CLIPPED,
        "   AND (amd171 = '32' OR amd171 ='22' OR amd171 = '27') ",
        " GROUP BY amd22,amd173,amd174,amd171 ",
        " ORDER BY  amd22,amd173,amd174,amd171" 
     ELSE
        LET l_sql = l_sql CLIPPED,
        "   AND amd171 = '",tm.amd171,"'",
        " GROUP BY amd22,amd173,amd174,amd171",
        " ORDER BY amd22,amd173,amd174,amd171" 
     END IF
	   CALL cl_replace_sqldb(l_sql) RETURNING l_sql	
      PREPARE r103_prepare1 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      DECLARE r103_curs1 CURSOR FOR r103_prepare1
      FOREACH r103_curs1 INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF cl_null(sr.amd06) THEN 
            LET l_tot1 = 0
            LET l_tot2 = 0
            LET l_tot3 = 0
            LET l_tot4 = 0
         ELSE 
           #-MOD-AB0081-add- 
           #LET l_tot1 = cl_digcut((sr.amd06/1.05),0)
           #LET l_tot2 = l_tot1*0.05
            LET l_tot2 = sr.amd06/1.05*0.05                               
            LET l_tot2 = cl_digcut((l_tot2),0)                            
            LET l_tot1 = sr.amd06-l_tot2    
           #-MOD-AB0081-end- 
            LET l_tot3 = l_tot1-sr.amd08
            LET l_tot4 = l_tot2-sr.amd07
         END IF 
         	     
         EXECUTE insert_prep USING
            sr.amd22,sr.amd173,sr.amd174,sr.amd171,sr.amd07,sr.amd08,
            l_tot1,l_tot2,l_tot3,l_tot4
      END FOREACH
    
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED  
    
   IF g_zz05='Y' THEN                                                      
      CALL cl_wcchp(tm.wc,'amd22')                             
      RETURNING tm.wc                                                      
   END IF                                                                  
   LET g_str= tm.wc  
                          
   CALL cl_prt_cs3("amdr103","amdr103",l_sql,g_str) 
END FUNCTION
#FUN-8B0082---End
