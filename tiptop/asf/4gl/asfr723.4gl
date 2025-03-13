# Prog. Version..: '5.30.06-13.03.12(00002)'     #
# Pattern name...: asfr723.4gl
# Descriptions...: 效率月統計表(非制程)
# Date & Author..: 10/04/30 By jan (FUN-A30095)
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題

DATABASE ds

GLOBALS "../../config/top.global"

   DEFINE tm  RECORD
              wc      LIKE type_file.chr1000,     
              bdate   LIKE type_file.dat, 
              edate   LIKE type_file.dat,
              yy      LIKE type_file.num5,
              mm      LIKE type_file.num5, 
              a       LIKE type_file.chr1
              END RECORD,
          g_max       LIKE type_file.num5   

DEFINE   g_cnt           LIKE type_file.num10    
DEFINE   g_i             LIKE type_file.num5     
DEFINE   g_sql           STRING
DEFINE   g_str           STRING
DEFINE   l_table         STRING


MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 mark

   LET g_sql = "srf03.srf_file.srf03,",
               "eci06.eci_file.eci06,",
               "srg10.srg_file.srg10,",
               "sum1.srg_file.srg06,",
               "srg19.srg_file.srg19,",
               "sum2.srg_file.srg06,",
               "sum3.srg_file.srg06"
               
   LET l_table = cl_prt_temptable('asfr723',g_sql) CLIPPED
   IF  l_table =-1 THEN EXIT PROGRAM END IF
   LET g_sql ="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET g_sql = ''
   IF cl_null(g_bgjob) OR g_bgjob ='N' THEN
      CALL r723_tm(0,0)
   ELSE
      CALL asfr723()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION r723_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01  
DEFINE p_row,p_col    LIKE type_file.num5,
       l_cmd          LIKE type_file.chr1000 

   IF p_row = 0 THEN LET p_row = 4 LET p_col = 10 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 10
   END IF
   
   OPEN WINDOW r723_w AT p_row,p_col
      WITH FORM "asf/42f/asfr723"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.yy=YEAR(g_today)
   LET tm.mm=MONTH(g_today)
   LET tm.a = '1'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
CONSTRUCT BY NAME tm.wc ON srg16,srg03,srf03

         BEFORE CONSTRUCT
             CALL cl_qbe_init()

     ON ACTION controlp
            IF INFIELD(srg03) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO srg03
               NEXT FIELD srg03
            END IF

     ON ACTION locale
          CALL cl_show_fld_cont()                
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
         
     ON ACTION help      
         LET g_action_choice="help" 
         CALL cl_show_help()  
         CONTINUE CONSTRUCT 
         
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT

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
         CLOSE WINDOW r723_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      
   INPUT BY NAME tm.yy,tm.mm,tm.a WITHOUT DEFAULTS
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)

       AFTER FIELD mm
         IF tm.mm < 1 OR tm.mm > 12 THEN
            LET tm.mm=MONTH(g_today)
            NEXT FIELD mm
         END IF
         
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
         
      ON ACTION help                                                                         
         LET g_action_choice="help"                                                                            
         CALL cl_show_help()                                                                       
         CONTINUE INPUT         
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT

      ON ACTION qbe_save
         CALL cl_qbe_save()

   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r723_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL asfr723()
   ERROR ""
END WHILE
   CLOSE WINDOW r723_w
END FUNCTION

FUNCTION asfr723()      
DEFINE    l_sql  LIKE type_file.chr1000,       
          sr     RECORD
              srf03    LIKE srf_file.srf03, 
              srg10    LIKE srg_file.srg10,
              srg19    LIKE srg_file.srg19, 
              sra05    LIKE sra_file.sra05,
              sum      LIKE srg_file.srg05
                 END RECORD
DEFINE l_sum1    LIKE srg_file.srg05
DEFINE l_sum2    LIKE srg_file.srg05
DEFINE l_sum3    LIKE srg_file.srg05
DEFINE l_eci06   LIKE eci_file.eci06

    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     
    CALL cl_del_data(l_table)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='asfr723' 
     
    IF g_priv2='4' THEN                            # 只能使用自己的資料
        LET tm.wc= tm.wc clipped," AND shbuser = '",g_user,"'"
    END IF
    IF g_priv3='4' THEN                            # 只能使用相同群的資料
        LET tm.wc= tm.wc clipped," AND shbgrup MATCHES '",g_grup CLIPPED,"*'"
    END IF

    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
        LET tm.wc= tm.wc clipped," AND shbgrup IN ",cl_chk_tgrup_list()
    END IF


     LET tm.bdate=MDY(tm.mm,1,tm.yy)
     IF tm.mm=12 THEN
        LET tm.edate=MDY(1,1,tm.yy+1)-1
     ELSE
        LET tm.edate=MDY(tm.mm+1,1,tm.yy)-1
     END IF
     
     IF tm.a = '1' THEN
        LET l_sql=" SELECT srf03,COALESCE(SUM(srg10),0)/60,'',",
                  "        COALESCE(SUM(ima58),0),",
                  "        COALESCE(SUM(srg05+srg06+srg07),0),",
                  "        COALESCE(SUM(ima58*(srg05+srg06+srg07)),0),",
                  "        COALESCE(SUM((srg10/60)*(srg05+srg06+srg07)),0),",
                  "        COALESCE(SUM((srg10/60)*ima58*(srg05+srg06+srg07)),0)",
                  " FROM srf_file,srg_file,ima_file ",
                  "  WHERE srf05 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                  "    AND srf01 = srg01 AND srfconf = 'Y'",
                  "    AND srg03 = ima01",
                  "    AND ",tm.wc CLIPPED,
                  " GROUP BY srf03 "
     ELSE
        LET l_sql=" SELECT srf03,COALESCE(SUM(srg10),0)/60,'',",
                  "        COALESCE(SUM(sra05),0),",
                  "        COALESCE(SUM(srg05+srg06+srg07),0),",
                  "        COALESCE(SUM(sra05*(srg05+srg06+srg07)),0),",
                  "        COALESCE(SUM((srg10/60)*(srg05+srg06+srg07)),0),",
                  "        COALESCE(SUM((srg10/60)*sra05*(srg05+srg06+srg07)),0)",
                  " FROM srf_file,srg_file,sra_file",
                  "  WHERE srf05 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                  "    AND srf01 = srg01 AND srfconf = 'Y'",
                  "    AND srf03 = sra01",
                  "    AND srg03 = sra02",
                  "    AND ",tm.wc CLIPPED,
                  " GROUP BY srf03 "
     END IF

     PREPARE r723_pre1 FROM l_sql
     DECLARE r723_curs1 CURSOR FOR r723_pre1
     FOREACH r723_curs1 INTO sr.*,l_sum1,l_sum2,l_sum3
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        LET l_sql ="SELECT COALESCE(SUM(srh05),0)/60",
                   "  FROM srh_file,srg_file,srf_file",
                   " WHERE srh01=srg01 AND srh03=srg02",
                   "  AND srg01=srf01 AND srfconf='Y'",
                   "  AND srf03 = '",sr.srf03,"'",
                   "  AND srf05 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                   "  AND ",tm.wc CLIPPED,
                   " GROUP BY  srf03"
        PREPARE r723_srh_p FROM l_sql
        DECLARE r723_srh_c CURSOR FOR r723_srh_p
        OPEN r723_srh_c
        FETCH r723_srh_c INTO sr.srg19
        SELECT eci06 INTO l_eci06 FROM eci_file
         WHERE eci01 = sr.srf03
        EXECUTE insert_prep USING
             sr.srf03,l_eci06,sr.srg10,l_sum1,sr.srg19,l_sum2,l_sum3
     END FOREACH
 
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05 ='Y' THEN 
       CALL cl_wcchp(tm.wc,'srg16,srg03,srf03')
            RETURNING tm.wc
     END IF 
     LET  g_str=tm.wc,";",tm.bdate,";",tm.edate
     CALL cl_prt_cs3('asfr723','asfr723',g_sql,g_str)
END FUNCTION
#FUN-A30095
