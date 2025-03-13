# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: axmr680.4gl
# Descriptions...: 开票单
# Date & Author..: No.FUN-CB0040 12/11/12 by minpp
 
DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm   RECORD               
            wc       STRING
            END RECORD
DEFINE g_i        LIKE type_file.num5  
DEFINE g_str      STRING 
DEFINE g_sql      STRING 
DEFINE l_table    STRING 
DEFINE l_table2   STRING
DEFINE g_argv1    LIKE omf_file.omf00 
DEFINE g_argv2    LIKE type_file.chr1
DEFINE g_change_lang    LIKE type_file.chr1
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT       
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   WHENEVER ERROR CALL cl_err_msg_log
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF

   LET g_argv1 = ARG_VAL(1)    
   LET g_bgjob = ARG_VAL(2)

   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   LET g_sql="omf00.omf_file.omf00,",
             "omf01.omf_file.omf01,",
             "omf02.omf_file.omf02,",
             "omf03.omf_file.omf03,",
             "omf05.omf_file.omf05,",
             
             "omf051.omf_file.omf051,",
             "omf06.omf_file.omf06,",
             "omf061.omf_file.omf061,",
             "omf07.omf_file.omf07,",
             "omf22.omf_file.omf22,",
             
             "isa051.isa_file.isa051,",
             "isa052.isa_file.isa052,",
             "isa053.isa_file.isa053,",
             "isa054.isa_file.isa054,",
             "omf08.omf_file.omf08,",
             
             "omf24.omf_file.omf24,",
             "omfpost.omf_file.omfpost,",
             "omf21.omf_file.omf21,",
             "omf09.omf_file.omf09,",
             "omf10.omf_file.omf10,",
             
             "omf11.omf_file.omf11,",
             "omf12.omf_file.omf12,",
             "omf13.omf_file.omf13,",
             "omf14.omf_file.omf14,",
             "omf15.omf_file.omf15,",
             
             "omf23.omf_file.omf23,",
             "omf20.omf_file.omf20,",
             "omf201.omf_file.omf201,",
             "omf202.omf_file.omf202,",
             "omf16.omf_file.omf16,",
             
             "omf17.omf_file.omf17,",
             "omf28.omf_file.omf28,",
             "omf29.omf_file.omf29,",
             "omf29x.omf_file.omf29x,",
             "omf29t.omf_file.omf29t,",
             
             "omf18.omf_file.omf18,",
             "omf19.omf_file.omf19,",
             "omf19x.omf_file.omf19x,",
             "omf19t.omf_file.omf19t,",
             "omf04.omf_file.omf04,",
             
             "ogb31.ogb_file.ogb31,",
             "ogb32.ogb_file.ogb32,",
             "oea10.oea_file.oea10"
             

   LET l_table = cl_prt_temptable('axmr680',g_sql) CLIPPED  #建立temp table,回傳狀態值
   IF  l_table = -1 THEN EXIT PROGRAM END IF                #依照狀態值決定程式是否繼續

    LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?) "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF 

   IF cl_null(g_argv1) THEN 
      CALL axmr680_tm(0,0) 
   ELSE 
      LET tm.wc = " omf00 = '",g_argv1,"'"
      CALL axmr680()
   END IF               
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION axmr680_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01 
DEFINE p_row,p_col    LIKE type_file.num5, 
       l_cmd          LIKE type_file.chr1000

      LET p_row = 4 LET p_col = 16
      OPEN WINDOW axmr680_w AT p_row,p_col WITH FORM "axm/42f/axmr680"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
      CALL cl_ui_init()      
      CALL cl_opmsg('p')
      INITIALIZE tm.* TO NULL   
      WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON omf00,omf05,omf03

        BEFORE CONSTRUCT
           CALL cl_qbe_init()

           ON ACTION CONTROLP
              CASE
                WHEN INFIELD(omf00)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form = "q_omf"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO omf00 
                     NEXT FIELD omf00   
                WHEN INFIELD(omf05)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form = "q_occ"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO omf05 
                     NEXT FIELD omf05                                                                                                                                                                      
              END CASE
 
     ON ACTION locale
        LET g_change_lang = TRUE
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()                   
        EXIT CONSTRUCT

     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT

     ON ACTION CONTROLG 
        CALL cl_cmdask()    #No.TQC-740008 add
        ON ACTION exit
        LET INT_FLAG = 1
        EXIT CONSTRUCT
        
     ON ACTION qbe_select
        CALL cl_qbe_select()
    END CONSTRUCT
   
    IF g_action_choice = "locale" THEN
       LET g_action_choice = ""
       CALL cl_dynamic_locale()
    END IF

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW axmr680_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
      
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF

   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser','oeagrup')

   CALL cl_wait()
   CALL axmr680()
   ERROR ""
   END WHILE

 CLOSE WINDOW axmr680_w
END FUNCTION
 
FUNCTION axmr680()
DEFINE
    l_i             LIKE type_file.num5, 
    sr              RECORD
        omf00       LIKE omf_file.omf00, 
        omf01       LIKE omf_file.omf01, 
        omf02       LIKE omf_file.omf02, 
        omf03       LIKE omf_file.omf03, 
        omf05       LIKE omf_file.omf05,   
        omf051      LIKE omf_file.omf051, 
        omf06       LIKE omf_file.omf06, 
        omf061      LIKE omf_file.omf061, 
        omf07       LIKE omf_file.omf07, 
        omf22       LIKE omf_file.omf22, 
        isa051      LIKE ISa_file.isa051,
        isa052      LIKE ISa_file.isa052,
        isa053      LIKE ISa_file.isa053,
        isa054      LIKE ISa_file.isa054, 
        omf08       LIKE omf_file.omf08, 
        omf24       LIKE omf_file.omf24, 
        omfpost     LIKE omf_file.omfpost, 
        omf21       LIKE omf_file.omf21, 
        omf09       LIKE omf_file.omf09, 
        omf10       LIKE omf_file.omf10, 
        omf11       LIKE omf_file.omf11, 
        omf12       LIKE omf_file.omf12, 
        omf13       LIKE omf_file.omf13, 
        omf14       LIKE omf_file.omf14, 
        omf15       LIKE omf_file.omf15, 
        omf23       LIKE omf_file.omf23, 
        omf20       LIKE omf_file.omf20, 
        omf201      LIKE omf_file.omf201, 
        omf202      LIKE omf_file.omf202, 
        omf16       LIKE omf_file.omf16, 
        omf17       LIKE omf_file.omf17,  
        omf28       LIKE omf_file.omf28, 
        omf29       LIKE omf_file.omf29, 
        omf29x      LIKE omf_file.omf29x, 
        omf29t      LIKE omf_file.omf29t, 
        omf18       LIKE omf_file.omf18, 
        omf19       LIKE omf_file.omf19, 
        omf19x      LIKE omf_file.omf19x,
        omf19t      LIKE omf_file.omf19t,
        omf04       LIKE omf_file.omf04,
        ogb31       LIKE ogb_file.ogb31,
        ogb32       LIKE ogb_file.ogb32,
        oea10       LIKE oea_file.oea10
       END RECORD,
    l_name          LIKE type_file.chr20,  #External(Disk) file name  
    l_za05          LIKE za_file.za05,    
    l_azi03         LIKE azi_file.azi03,   
    l_wc            STRING
    DEFINE l_occ              RECORD LIKE occ_file.*
    DEFINE l_ocj03    LIKE ocj_file.ocj03
    DEFINE l_nmt02    LIKE nmt_file.nmt02   

     CALL cl_del_data(l_table) 

     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'axmr680'
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     
    LET g_sql="SELECT omf00,omf01,omf02,omf03,omf05,omf051,omf06,omf061,omf07,omf22,'','','','',",   
              "       omf08,omf24,omfpost,omf21,omf09,omf10,omf11,omf12,omf13,omf14,omf15,omf23,omf20, ", 
              "       omf201,omf202,omf16,omf17,omf28,omf29,omf29x,omf29t,omf18,omf19,omf19x,omf19t,omf04,'','','' ", 
              "  FROM omf_file ",     
              " WHERE ",tm.wc CLIPPED   
                    
    LET g_sql = g_sql CLIPPED," ORDER BY omf00,omf21 "  
    PREPARE r680_p1 FROM g_sql               
    IF STATUS THEN CALL cl_err('r680_p1',STATUS,0) END IF
 
    DECLARE r680_cs1                         # CURSOR
        CURSOR FOR r680_p1
 
 
    FOREACH r680_cs1 INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF

    IF sr.omf10 = '1' THEN 
       SELECT ogb31,ogb32 INTO sr.ogb31,sr.ogb32 FROM ogb_file
        WHERE ogb01 = sr.omf11
          AND ogb03 = sr.omf12
       SELECT oea10 INTO sr.oea10 FROM oea_file 
        WHERE oea01 = sr.ogb31
    END IF
    IF sr.omf10 = '2' THEN 
       SELECT ohb33,ohb34 INTO sr.ogb31,sr.ogb32 FROM ogb_file
        WHERE ohb01 = sr.omf11
          AND ohb03 = sr.omf12
       SELECT oea10 INTO sr.oea10 FROM oea_file 
        WHERE oea01 = sr.ogb31
    END IF
    #客户    
    SELECT * INTO l_occ.* FROM occ_file
     WHERE occ01=sr.omf05
    #抓银行账户，银行名称 
    DECLARE r680_curs22 CURSOR FOR
     SELECT ocj03,nmt02 FROM ocj_file,OUTER nmt_file
      WHERE ocj01 = sr.omf05 AND nmt_file.nmt01 = ocj02
    LET l_ocj03 = ''
    LET l_nmt02 = ''
    FOREACH r680_curs22 INTO l_ocj03,l_nmt02
       EXIT FOREACH
    END FOREACH
    LET sr.isa051 = l_occ.occ18      #客户全名
    LET sr.isa052 = l_occ.occ11      #客户税号
    LET sr.isa053 = l_occ.occ231 CLIPPED,l_occ.occ261 CLIPPED    #客户地址及电话
    LET sr.isa054 = l_nmt02 CLIPPED,l_ocj03 CLIPPED              #客户银行及账号
 
        EXECUTE insert_prep USING sr.*
    END FOREACH

    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," "

    CALL cl_prt_cs3('axmr680','axmr680',g_sql,g_str)     

END FUNCTION
#FUN-CB0040

