# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: axmg410.4gl
# Descriptions...: S/C訂單出貨明細狀況報表列印
# Date & Author..: 12/07/05 By qiaozy  FUN-C70020
# Modify.........: No:FUN-C70020 12/07/11 By qiaozy 程序过单
 
#FUN-C70020----BEGIN-----
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                           # Print condition RECORD
            wc      STRING, # Where condition 
            a       LIKE type_file.chr1,
            b       LIKE type_file.chr1,
            more    LIKE type_file.chr1
           END RECORD
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose  
DEFINE g_sma115     LIKE sma_file.sma115 
DEFINE g_sma116     LIKE sma_file.sma116
DEFINE l_table      STRING
DEFINE l_table1     STRING
DEFINE l_table2     STRING
DEFINE g_sql        STRING
 
###GENGRE###START
TYPE sr1_t RECORD
    oebslk01   LIKE oebslk_file.oebslk01,
    oea032     LIKE oea_file.oea032,
    oea02      LIKE oea_file.oea02,
    oea14      LIKE oea_file.oea14,
    oebslk04   LIKE oebslk_file.oebslk04,
    oebslk06   LIKE oebslk_file.oebslk06,
    oebslk13   LIKE oebslk_file.oebslk13,
    oebslk1006 LIKE oebslk_file.oebslk1006,
    oebslk14   LIKE oebslk_file.oebslk14,
    oebslk14t  LIKE oebslk_file.oebslk14t,
    oebslk12   LIKE oebslk_file.oebslk12,
    oebslk23   LIKE oebslk_file.oebslk23,
    oebslk24   LIKE oebslk_file.oebslk24,
    oebslk03   LIKE oebslk_file.oebslk03
END RECORD
TYPE sr2_t RECORD
    agd03_1  LIKE agd_file.agd03,
    agd03_2  LIKE agd_file.agd03,  
    agd03_3  LIKE agd_file.agd03,
    agd03_4  LIKE agd_file.agd03,
    agd03_5  LIKE agd_file.agd03,
    agd03_6  LIKE agd_file.agd03,
    agd03_7  LIKE agd_file.agd03,
    agd03_8  LIKE agd_file.agd03,
    agd03_9  LIKE agd_file.agd03,
    agd03_10 LIKE agd_file.agd03,
    agd03_11 LIKE agd_file.agd03,
    agd03_12 LIKE agd_file.agd03,
    agd03_13 LIKE agd_file.agd03,
    agd03_14 LIKE agd_file.agd03,
    agd03_15 LIKE agd_file.agd03,
    oebslk04 LIKE oebslk_file.oebslk04
END RECORD

TYPE sr3_t RECORD
    imx01    LIKE imx_file.imx01, 
    number1  LIKE type_file.num5,
    number11 LIKE type_file.num5,
    number12 LIKE type_file.num5,
    number2  LIKE type_file.num5,
    number21 LIKE type_file.num5,
    number22 LIKE type_file.num5,
    number3  LIKE type_file.num5,
    number31 LIKE type_file.num5,
    number32 LIKE type_file.num5,
    number4  LIKE type_file.num5,
    number41 LIKE type_file.num5,
    number42 LIKE type_file.num5,
    number5  LIKE type_file.num5,
    number51 LIKE type_file.num5,
    number52 LIKE type_file.num5,
    number6  LIKE type_file.num5,
    number61 LIKE type_file.num5,
    number62 LIKE type_file.num5,
    number7  LIKE type_file.num5,
    number71 LIKE type_file.num5,
    number72 LIKE type_file.num5,
    number8  LIKE type_file.num5,
    number81 LIKE type_file.num5,
    number82 LIKE type_file.num5,
    number9  LIKE type_file.num5,
    number91 LIKE type_file.num5,
    number92 LIKE type_file.num5,
    number10 LIKE type_file.num5,
    number101 LIKE type_file.num5,
    number102 LIKE type_file.num5,
    oebslk01 LIKE oebslk_file.oebslk01,
    oebslk03 LIKE oebslk_file.oebslk03,
    oebslk04 LIKE oebslk_file.oebslk04
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF

   LET g_sql="oebslk01.oebslk_file.oebslk01,",
             "oea032.oea_file.oea032,",
             "oea02.oea_file.oea02,",
             "oea14.oea_file.oea14,",
             "oebslk04.oebslk_file.oebslk04,",
             "oebslk06.oebslk_file.oebslk06,",
             "oebslk13.oebslk_file.oebslk13,",
             "oebslk1006.oebslk_file.oebslk1006,",
             "oebslk14.oebslk_file.oebslk14,",
             "oebslk14t.oebslk_file.oebslk14t,",
             "oebslk12.oebslk_file.oebslk12,",
             "oebslk23.oebslk_file.oebslk23,",
             "oebslk24.oebslk_file.oebslk24,oebslk03.oebslk_file.oebslk03"
   LET l_table = cl_prt_temptable('axmg410',g_sql) CLIPPED 
   IF l_table = -1 THEN 
      EXIT PROGRAM 
   END IF
   LET g_sql="agd03_1.agd_file.agd03,agd03_2.agd_file.agd03,",
             "agd03_3.agd_file.agd03,agd03_4.agd_file.agd03,",
             "agd03_5.agd_file.agd03,agd03_6.agd_file.agd03,",
             "agd03_7.agd_file.agd03,agd03_8.agd_file.agd03,",
             "agd03_9.agd_file.agd03,agd03_10.agd_file.agd03,",
             "agd03_11.agd_file.agd03,agd03_12.agd_file.agd03,",
             "agd03_13.agd_file.agd03,agd03_14.agd_file.agd03,",
             "agd03_15.agd_file.agd03,oebslk04.oebslk_file.oebslk04"
   LET l_table1 = cl_prt_temptable('axmg4101',g_sql) CLIPPED 
   IF l_table1 = -1 THEN 
      EXIT PROGRAM 
   END IF 
   LET g_sql="imx01.imx_file.imx01,number1.type_file.num5,",
             "number11.type_file.num5,number12.type_file.num5,", 
             "number2.type_file.num5,number21.type_file.num5,",
             "number22.type_file.num5,number3.type_file.num5,",
             "number31.type_file.num5,number32.type_file.num5,",
             "number4.type_file.num5,number41.type_file.num5,",
             "number42.type_file.num5,number5.type_file.num5,",
             "number51.type_file.num5,number52.type_file.num5,",
             "number6.type_file.num5,number61.type_file.num5,",
             "number62.type_file.num5,number7.type_file.num5,",
             "number71.type_file.num5,number72.type_file.num5,",
             "number8.type_file.num5,number81.type_file.num5,",
             "number82.type_file.num5,number9.type_file.num5,",
             "number91.type_file.num5,number92.type_file.num5,",
             "number10.type_file.num5,number101.type_file.num5,",
             "number102.type_file.num5,oebslk01.oebslk_file.oebslk01,",
             "oebslk03.oebslk_file.oebslk03,oebslk04.oebslk_file.oebslk04"
   LET l_table2 = cl_prt_temptable('axmg4102',g_sql) CLIPPED 
   IF l_table2 = -1 THEN 
      EXIT PROGRAM 
   END IF          
  
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.b    = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)
   
   IF cl_null(tm.wc) THEN
      CALL axmg410_tm(0,0)             # Input print condition
   ELSE 
      CALL axmg410()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #
   CALL cl_gre_drop_temptable(l_table)
END MAIN
 
FUNCTION axmg410_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01    #
DEFINE p_row,p_col    LIKE type_file.num5    
DEFINE l_cmd          LIKE type_file.chr1000 #
 
   LET p_row = 4 LET p_col = 15
 
   OPEN WINDOW axmg410_w AT p_row,p_col WITH FORM "axm/42f/axmg410"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #
 
   CALL cl_ui_init()
   IF s_industry('slk') AND g_azw.azw04='2' THEN
      CALL cl_set_comp_visible("b",TRUE)
      CALL cl_set_comp_visible("more",FALSE)
   ELSE
      CALL cl_set_comp_visible("b",FALSE)
      CALL cl_set_comp_visible("more",TRUE)
   END IF
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.b    = 'Y'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.a ='3'
 
   WHILE TRUE
      DIALOG ATTRIBUTE(UNBUFFERED)
      CONSTRUCT BY NAME tm.wc ON oea01,oea02,oea14,oebslk04
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
             DISPLAY tm.a TO a  
 
         ON ACTION CONTROLP    
            IF INFIELD(oea01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_oea11"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oea01
               NEXT FIELD oea01
            END IF
            IF INFIELD(oea14) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oea14
               NEXT FIELD oea14
            END IF
            IF INFIELD(oebslk04) THEN
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                IF s_industry('slk') and g_azw.azw04='2' THEN 
                   LET g_qryparam.form ="q_oebslk041"
                ELSE
                   LET g_qryparam.form ="q_ima01"
                END IF 
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oebslk04
                NEXT FIELD oebslk04
            END IF    
 
      END CONSTRUCT
 
      
      INPUT BY NAME tm.a,tm.b,tm.more
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
             DISPLAY tm.a TO a
             
         AFTER FIELD a
            IF cl_null(tm.a) OR tm.a NOT MATCHES '[1-3]' THEN
               NEXT FIELD a
            END IF
         AFTER FIELD b
            IF cl_null(tm.b) OR tm.b NOT MATCHES '[YN]' THEN
               NEXT FIELD b
            END IF
            
         AFTER FIELD more
            IF cl_null(tm.more) OR tm.more NOT MATCHES '[YN]' THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
      END INPUT
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
            
      ON ACTION about
         CALL cl_about()
 
      ON ACTION HELP
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
      ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()
 
      ON ACTION EXIT
         LET INT_FLAG = 1
         EXIT DIALOG 

      ON ACTION ACCEPT
         ACCEPT DIALOG
         
      ON ACTION CANCEL
         LET INT_FLAG = 1
         EXIT DIALOG
         
      END DIALOG 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW axmg410_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
         EXIT PROGRAM
      END IF 
      CALL cl_wait()
      CALL axmg410()
      ERROR ""
   END WHILE
   CLOSE WINDOW axmg410_w
END FUNCTION
 
FUNCTION axmg410()
DEFINE l_name     LIKE type_file.chr20,    # External(Disk) file name  
  #    l_time     LIKE type_file.chr8,     # Used time for running the job  	
       l_sql      LIKE type_file.chr1000, 
       l_za05     LIKE type_file.chr1000,  
       l_count    LIKE type_file.num5,     #N
       sr         RECORD
                  oebslk01     LIKE oebslk_file.oebslk01,
                  oea032       LIKE oea_file.oea032,
                  oea02        LIKE oea_file.oea02,
                  oea14        LIKE oea_file.oea14,
                  oebslk04     LIKE oebslk_file.oebslk04,
                  oebslk06     LIKE oebslk_file.oebslk06,
                  oebslk13     LIKE oebslk_file.oebslk13,
                  oebslk1006   LIKE oebslk_file.oebslk1006,
                  oebslk14     LIKE oebslk_file.oebslk14,
                  oebslk14t    LIKE oebslk_file.oebslk14t,
                  oebslk12     LIKE oebslk_file.oebslk12,  #No.FUN-710090
                  oebslk23     LIKE oebslk_file.oebslk23,
                  oebslk24     LIKE oebslk_file.oebslk24                  
                  END RECORD
DEFINE sr1        RECORD
                  agd03_1      LIKE agd_file.agd03,
                  agd03_2      LIKE agd_file.agd03,
                  agd03_3      LIKE agd_file.agd03,
                  agd03_4      LIKE agd_file.agd03,
                  agd03_5      LIKE agd_file.agd03,
                  agd03_6      LIKE agd_file.agd03,
                  agd03_7      LIKE agd_file.agd03,
                  agd03_8      LIKE agd_file.agd03,
                  agd03_9      LIKE agd_file.agd03,
                  agd03_10      LIKE agd_file.agd03,
                  agd03_11      LIKE agd_file.agd03,
                  agd03_12      LIKE agd_file.agd03,
                  agd03_13      LIKE agd_file.agd03,
                  agd03_14      LIKE agd_file.agd03,
                  agd03_15      LIKE agd_file.agd03
                  END RECORD
DEFINE l_num_t        RECORD
                  number1       LIKE type_file.num5,
                  number11      LIKE type_file.num5,
                  number12      LIKE type_file.num5,
                  number2       LIKE type_file.num5,
                  number21      LIKE type_file.num5,
                  number22      LIKE type_file.num5,
                  number3       LIKE type_file.num5,
                  number31      LIKE type_file.num5,
                  number32      LIKE type_file.num5,
                  number4       LIKE type_file.num5,
                  number41      LIKE type_file.num5,
                  number42      LIKE type_file.num5,
                  number5       LIKE type_file.num5,
                  number51      LIKE type_file.num5,
                  number52      LIKE type_file.num5,
                  number6       LIKE type_file.num5,
                  number61      LIKE type_file.num5,
                  number62      LIKE type_file.num5,
                  number7       LIKE type_file.num5,
                  number71      LIKE type_file.num5,
                  number72      LIKE type_file.num5,
                  number8       LIKE type_file.num5,
                  number81      LIKE type_file.num5,
                  number82      LIKE type_file.num5,
                  number9       LIKE type_file.num5,
                  number91      LIKE type_file.num5,
                  number92      LIKE type_file.num5,
                  number10      LIKE type_file.num5,
                  number101     LIKE type_file.num5,
                  number102     LIKE type_file.num5
                  END RECORD
                  
DEFINE l_oebslk03 LIKE oebslk_file.oebslk03
DEFINE l_oeb04    LIKE oeb_file.oeb04
DEFINE l_imx_t  RECORD
       agd03_1  LIKE agd_file.agd03,
       agd03_2  LIKE agd_file.agd03,  
       agd03_3  LIKE agd_file.agd03,
       agd03_4  LIKE agd_file.agd03,
       agd03_5  LIKE agd_file.agd03,
       agd03_6  LIKE agd_file.agd03,
       agd03_7  LIKE agd_file.agd03,
       agd03_8  LIKE agd_file.agd03,
       agd03_9  LIKE agd_file.agd03,
       agd03_10 LIKE agd_file.agd03,
       agd03_11 LIKE agd_file.agd03,
       agd03_12 LIKE agd_file.agd03,
       agd03_13 LIKE agd_file.agd03,
       agd03_14 LIKE agd_file.agd03,
       agd03_15 LIKE agd_file.agd03
                END RECORD

DEFINE l_n           LIKE type_file.num5
DEFINE l_ima151      LIKE ima_file.ima151
DEFINE  l_num   DYNAMIC ARRAY OF RECORD
                 number  LIKE type_file.num5,
                 number1 LIKE oeb_file.oeb23,
                 number2 LIKE oeb_file.oeb24
                END RECORD
DEFINE  l_imx   DYNAMIC ARRAY OF RECORD
                imx01    LIKE type_file.chr10
                END RECORD
DEFINE  l_sql2  STRING
DEFINE  l_imx02 LIKE imx_file.imx02
DEFINE  l_imx01 LIKE imx_file.imx01
DEFINE  l_agd04 LIKE agd_file.agd04
DEFINE  l_i     LIKE type_file.num5
DEFINE  l_agd03 LIKE agd_file.agd03
DEFINE  l_ps    LIKE sma_file.sma46
DEFINE  l_ima01 LIKE ima_file.ima01

DEFINE l_zo12     LIKE zo_file.zo12        #FUN-740057 add
DEFINE l_zo041    LIKE zo_file.zo041       #FUN-810029 add
DEFINE l_zo05     LIKE zo_file.zo05        #FUN-810029 add
DEFINE l_zo09     LIKE zo_file.zo09        #FUN-810029 add
DEFINE oao        RECORD LIKE oao_file.*   #MOD-7C0033 add
DEFINE l_img_blob LIKE type_file.blob      #FUN-C40026 add
DEFINE l_wc      STRING                    

   LOCATE l_img_blob      IN MEMORY            #FUN-C40026 add
 
   CALL cl_del_data(l_table)
   CALL cl_del_data(l_table1)
   CALL cl_del_data(l_table2)
  #No.FUN-710090--begin--
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN  
      CALL cl_err('insert_prep1:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
      EXIT PROGRAM 
   END IF

   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                       "?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"
   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN  
      CALL cl_err('insert_prep2:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)     #
      EXIT PROGRAM 
   END IF
   
  
   #LET g_rlang = '1'   #FUN-5C0036   #MOD-680086
   SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file   #
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='axmg410'   #

   SELECT zo12 INTO l_zo12 FROM zo_file WHERE zo01='1'   #公司對外全名
   IF cl_null(l_zo12) THEN
      SELECT zo12 INTO l_zo12 FROM zo_file WHERE zo01='0'
   END IF

  #公司地址zo041、公司電話zo05、公司傳真zo09
   LET l_zo041 = NULL  LET l_zo05 = NULL  LET l_zo09 = NULL
   SELECT zo041,zo05,zo09 INTO l_zo041,l_zo05,l_zo09
     FROM zo_file WHERE zo01='1'   #英文版報表
  #end FUN-810029 mod
 
   IF tm.a='1' THEN
      LET tm.wc = tm.wc ," AND oeaconf='Y' " 
   END IF
   IF tm.a='2' THEN
      LET tm.wc = tm.wc ," AND oeaconf='N' " 
   END IF
     
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
   #End:FUN-980030
   IF tm.b='Y' AND s_industry('slk') AND g_azw.azw04='2' THEN
      LET l_sql="SELECT oea01,oea032,oea02,oea14,oebslk04,oebslk06,oebslk13,oebslk1006,",
                 "      oebslk14,oebslk14t,oebslk12,oebslk23,oebslk24,oebslk03",
                 "  FROM oea_file,oebslk_file",
                 " WHERE oea01=oebslk01 ",
                 "   AND oeaconf != 'X' ",
                 "   AND ",tm.wc CLIPPED,
                 " ORDER BY oea01,oebslk03 "
      
   ELSE
      IF tm.b='N' AND s_industry('slk') AND g_azw.azw04='2' THEN
         LET l_sql="SELECT distinct oea01,oea032,oea02,oea14,oeb04,oeb06,oeb13,oeb1006,oeb14,oeb14t,oeb12,oeb23,oeb24,oeb03",
                " FROM oeb_file,oea_file,oebi_file,oebslk_file ",
                " WHERE oea01=oeb01 ",
                "   AND oea01=oebslk01 ",
                "   AND oea01=oebi01 ",
                "   AND oeb01=oebi01 AND oeb03=oebi03 ",
                "   AND oebslk03=oebislk03 ",
                "   AND oeaconf != 'X' ",
                "   AND oebplant=oeaplant ",
                "   AND oebslkplant=oebiplant ",
                "   AND oebplant=oebslkplant ",
                "   AND oeaplant='",g_plant,"' ", 
                "   AND ",tm.wc CLIPPED,
                " ORDER BY oea01,oeb03 "
         IF tm.wc.getIndexOf("oebslk04",1) <= 0 THEN
            LET l_sql="SELECT oea01,oea032,oea02,oea14,oeb04,oeb06,oeb13,oeb1006,oeb14,oeb14t,oeb12,oeb23,oeb24,oeb03",
                   " FROM oeb_file,oea_file ",
                   " WHERE oea01=oeb01 ",
                   "   AND oeaconf != 'X' ",
                   "   AND ",tm.wc CLIPPED,
                   " ORDER BY oea01,oeb03 "
         END IF 
      ELSE 
         LET l_wc=tm.wc
         LET l_wc=cl_replace_str(l_wc,"oebslk04","oeb04")
         LET l_sql="SELECT oea01,oea032,oea02,oea14,oeb04,oeb06,oeb13,oeb1006,oeb14,oeb14t,oeb12,oeb23,oeb24,oeb03",
                   " FROM oeb_file,oea_file ",
                   " WHERE oea01=oeb01 ",
                   "   AND oeaconf != 'X' ",
                   "   AND ",l_wc CLIPPED,
                   " ORDER BY oea01,oeb03 " 
      END IF
   END IF               
   PREPARE axmg410_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   DECLARE axmg410_curs1 CURSOR FOR axmg410_prepare1
     
 
   FOREACH axmg410_curs1 INTO sr.*,l_oebslk03
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      EXECUTE insert_prep USING 
         sr.oebslk01,sr.oea032,sr.oea02,sr.oea14,sr.oebslk04,sr.oebslk06,sr.oebslk13,
         sr.oebslk1006,sr.oebslk14,sr.oebslk14t,sr.oebslk12,sr.oebslk23,sr.oebslk24,l_oebslk03

      SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01=sr.oebslk04
      IF l_ima151='Y' AND tm.b='Y' AND sr.oebslk12>0 THEN
         LET l_sql = "SELECT DISTINCT(imx02),agd04 FROM imx_file,agd_file",
               " WHERE imx00 = '",sr.oebslk04,"'",
               "   AND imx02=agd02",
               "   AND agd01 IN ",
               " (SELECT ima941 FROM ima_file WHERE ima01='",sr.oebslk04,"')",
               " ORDER BY agd04"
           PREPARE g410_slk_sr2_pre FROM l_sql
           DECLARE g410_slk_sr2_cs CURSOR FOR g410_slk_sr2_pre 
           LET l_imx02 = NULL 
           INITIALIZE l_imx_t.* TO NULL
           FOR l_i = 1 TO 15
               LET l_imx[l_i].imx01 =NULL
           END FOR   
           LET l_i = 1
            
           FOREACH g410_slk_sr2_cs INTO l_imx02,l_agd04
              LET l_imx[l_i].imx01=' '
              SELECT agd03 INTO l_imx[l_i].imx01  FROM agd_file,ima_file
               WHERE agd01 = ima941 AND agd02 = l_imx02 
                 AND ima01 = sr.oebslk04 
              LET l_i = l_i + 1
           END FOREACH 
           FOR l_i = 1 TO 15 
              IF cl_null(l_imx[l_i].imx01) THEN
                 LET l_imx[l_i].imx01 = ' '
              END IF
           END FOR 
           LET l_imx_t.agd03_1 = l_imx[1].imx01
           LET l_imx_t.agd03_2 = l_imx[2].imx01
           LET l_imx_t.agd03_3 = l_imx[3].imx01
           LET l_imx_t.agd03_4 = l_imx[4].imx01
           LET l_imx_t.agd03_5 = l_imx[5].imx01
           LET l_imx_t.agd03_6 = l_imx[6].imx01
           LET l_imx_t.agd03_7 = l_imx[7].imx01
           LET l_imx_t.agd03_8 = l_imx[8].imx01
           LET l_imx_t.agd03_9 = l_imx[9].imx01
           LET l_imx_t.agd03_10 = l_imx[10].imx01
           LET l_imx_t.agd03_11 = l_imx[11].imx01
           LET l_imx_t.agd03_12 = l_imx[12].imx01
           LET l_imx_t.agd03_13 = l_imx[13].imx01
           LET l_imx_t.agd03_14 = l_imx[14].imx01
           LET l_imx_t.agd03_15 = l_imx[15].imx01
           EXECUTE insert_prep1 USING 
           l_imx_t.*,sr.oebslk04
#子報表2
           LET l_sql = "SELECT DISTINCT(imx01),agd04 FROM imx_file,agd_file",
                " WHERE imx00 = '",sr.oebslk04,"'",
               "   AND imx01=agd02",
               "   AND agd01 IN ",
               " (SELECT ima940 FROM ima_file WHERE ima01='",sr.oebslk04,"')",
               " ORDER BY agd04"
           PREPARE g410_slk_colslk_pre FROM l_sql
           DECLARE g410_slk_colslk_cs CURSOR FOR g410_slk_colslk_pre
           LET l_imx01 = NULL

           FOREACH g410_slk_colslk_cs INTO l_imx01,l_agd04
              SELECT agd03 INTO l_agd03 FROM agd_file,ima_file
               WHERE agd01 = ima940 AND agd02 = l_imx01
                 AND ima01 = sr.oebslk04 
   
              LET l_sql2 = "SELECT DISTINCT(imx02),agd04 FROM imx_file,agd_file",
                   " WHERE imx00 = '",sr.oebslk04,"'",
                   "   AND imx02=agd02",
                   "   AND agd01 IN ",
                   " (SELECT ima941 FROM ima_file WHERE ima01='",sr.oebslk04,"')",
                   " ORDER BY agd04"
              PREPARE g410_slk_sr3_pre FROM l_sql2
              DECLARE g410_slk_sr3_cs CURSOR FOR g410_slk_sr3_pre
              LET l_imx02 = NULL
              LET l_i = 1
              FOR l_i=1 TO 10
                  LET l_num[l_i].number=null
                  LET l_num[l_i].number1=null
                  LET l_num[l_i].number2=null
              END FOR
              LET l_i = 1
              FOREACH g410_slk_sr3_cs INTO l_imx02,l_agd04
                 LET l_imx[l_i].imx01=' ' 
                 SELECT agd03 INTO l_imx[l_i].imx01  FROM agd_file,ima_file
                  WHERE agd01 = ima941 AND agd02 = l_imx02
                    AND ima01 = sr.oebslk04
          
                 SELECT sma46 INTO l_ps FROM sma_file
                 IF cl_null(l_ps) THEN LET l_ps = ' ' END IF
                 LET l_ima01 = sr.oebslk04,l_ps,l_imx01,l_ps,l_imx02
                 SELECT count(*) INTO l_n FROM oeb_file WHERE oeb01=sr.oebslk01 AND oeb04=l_ima01
                 IF l_n>0 THEN
                    SELECT oeb12,oeb23,oeb24 INTO l_num[l_i].number,l_num[l_i].number1,l_num[l_i].number2
                      FROM oeb_file,oebslk_file,oebi_file 
                     WHERE oeb01=oebi01 AND oeb03=oebi03
                       AND oebslk01=oebi01 AND oebislk03=l_oebslk03
                       AND oeb01=sr.oebslk01 AND oeb04=l_ima01
                 ELSE
                    LET l_num[l_i].number=0
                    LET l_num[l_i].number1=0
                    LET l_num[l_i].number2=0
                 END IF     
                 LET l_i=l_i+1   
                 LET l_imx02=null
              END FOREACH
              LET l_num_t.number1=l_num[1].number
              LET l_num_t.number11=l_num[1].number1
              LET l_num_t.number12=l_num[1].number2
              LET l_num_t.number2=l_num[2].number
              LET l_num_t.number21=l_num[2].number1 
              LET l_num_t.number22=l_num[2].number2
              LET l_num_t.number3=l_num[3].number
              LET l_num_t.number31=l_num[3].number1 
              LET l_num_t.number32=l_num[4].number2
              LET l_num_t.number4=l_num[4].number
              LET l_num_t.number41=l_num[4].number1
              LET l_num_t.number42=l_num[4].number2
              LET l_num_t.number5=l_num[5].number
              LET l_num_t.number51=l_num[5].number1
              LET l_num_t.number52=l_num[5].number2
              LET l_num_t.number6=l_num[6].number
              LET l_num_t.number61=l_num[6].number1 
              LET l_num_t.number62=l_num[6].number2
              LET l_num_t.number7=l_num[7].number
              LET l_num_t.number71=l_num[7].number1
              LET l_num_t.number72=l_num[7].number2 
              LET l_num_t.number8=l_num[8].number
              LET l_num_t.number81=l_num[8].number1
              LET l_num_t.number82=l_num[8].number2
              LET l_num_t.number9=l_num[9].number
              LET l_num_t.number91=l_num[9].number1
              LET l_num_t.number92=l_num[9].number2
              LET l_num_t.number10=l_num[10].number
              LET l_num_t.number101=l_num[10].number1
              LET l_num_t.number102=l_num[10].number2
              IF cl_null(l_num_t.number1) THEN LET l_num_t.number1=0 END IF
              IF cl_null(l_num_t.number11) THEN LET l_num_t.number11=0 END IF
              IF cl_null(l_num_t.number12) THEN LET l_num_t.number12=0 END IF
              IF cl_null(l_num_t.number2) THEN LET l_num_t.number2=0 END IF
              IF cl_null(l_num_t.number21) THEN LET l_num_t.number21=0 END IF
              IF cl_null(l_num_t.number22) THEN LET l_num_t.number22=0 END IF
              IF cl_null(l_num_t.number3) THEN LET l_num_t.number3=0 END IF
              IF cl_null(l_num_t.number31) THEN LET l_num_t.number31=0 END IF
              IF cl_null(l_num_t.number32) THEN LET l_num_t.number32=0 END IF
              IF cl_null(l_num_t.number4) THEN LET l_num_t.number4=0 END IF
              IF cl_null(l_num_t.number41) THEN LET l_num_t.number41=0 END IF
              IF cl_null(l_num_t.number42) THEN LET l_num_t.number42=0 END IF
              IF cl_null(l_num_t.number5) THEN LET l_num_t.number5=0 END IF
              IF cl_null(l_num_t.number51) THEN LET l_num_t.number51=0 END IF
              IF cl_null(l_num_t.number52) THEN LET l_num_t.number52=0 END IF
              IF cl_null(l_num_t.number6) THEN LET l_num_t.number6=0 END IF
              IF cl_null(l_num_t.number61) THEN LET l_num_t.number61=0 END IF
              IF cl_null(l_num_t.number62) THEN LET l_num_t.number62=0 END IF
              IF cl_null(l_num_t.number7) THEN LET l_num_t.number7=0 END IF
              IF cl_null(l_num_t.number71) THEN LET l_num_t.number71=0 END IF
              IF cl_null(l_num_t.number72) THEN LET l_num_t.number72=0 END IF
              IF cl_null(l_num_t.number8) THEN LET l_num_t.number8=0 END IF
              IF cl_null(l_num_t.number81) THEN LET l_num_t.number81=0 END IF
              IF cl_null(l_num_t.number82) THEN LET l_num_t.number82=0 END IF
              IF cl_null(l_num_t.number9) THEN LET l_num_t.number9=0 END IF
              IF cl_null(l_num_t.number91) THEN LET l_num_t.number91=0 END IF
              IF cl_null(l_num_t.number92) THEN LET l_num_t.number92=0 END IF
              IF cl_null(l_num_t.number10) THEN LET l_num_t.number10=0 END IF
              IF cl_null(l_num_t.number101) THEN LET l_num_t.number101=0 END IF
              IF cl_null(l_num_t.number102) THEN LET l_num_t.number102=0 END IF
              IF  l_num_t.number1=0 AND l_num_t.number11=0 AND
              l_num_t.number12=0 AND l_num_t.number2=0 AND
              l_num_t.number21=0 AND l_num_t.number22=0 AND 
              l_num_t.number3=0 AND
              l_num_t.number31=0 AND
              l_num_t.number32=0 AND
              l_num_t.number4=0 AND 
              l_num_t.number41=0 AND
              l_num_t.number42=0 AND
              l_num_t.number5=0 AND
              l_num_t.number51=0 AND
              l_num_t.number52=0 AND
              l_num_t.number6=0 AND
              l_num_t.number61=0 AND
              l_num_t.number62=0 AND
              l_num_t.number7=0 AND
              l_num_t.number71=0 AND
              l_num_t.number72=0 AND
              l_num_t.number8=0 AND
              l_num_t.number81=0 AND
              l_num_t.number82=0 AND
              l_num_t.number9=0 AND
              l_num_t.number91=0 AND
              l_num_t.number92=0 AND
              l_num_t.number10=0 AND
              l_num_t.number101=0 AND
              l_num_t.number102=0 THEN
                 CONTINUE FOREACH
              ELSE 
                 EXECUTE insert_prep2 USING 
              l_imx01,l_num_t.*,sr.oebslk01,l_oebslk03,sr.oebslk04
              END IF
           END FOREACH 
        END IF   
   END FOREACH
   IF s_industry('slk') AND g_azw.azw04='2' AND tm.b='Y' THEN
      LET g_template="axmg410_slk"
      CALL axmg410_slk_grdata() 
   ELSE 
      LET g_template="axmg410"
      CALL axmg410_grdata()    ###GENGRE###
   END IF  

END FUNCTION

###GENGRE###START

FUNCTION axmg410_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING
    DEFINE l_oebslk03  LIKE oebslk_file.oebslk03

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
   
    
    CALL cl_gre_init_apr()           #FUN-C40026 add
 
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("axmg410")
        IF handler IS NOT NULL THEN
            START REPORT axmg410_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," ORDER BY oebslk01,oebslk03,oebslk04"
          
            DECLARE axmg410_datacur1 CURSOR FROM l_sql
            FOREACH axmg410_datacur1 INTO sr1.*
                OUTPUT TO REPORT axmg410_rep(sr1.*)
            END FOREACH
            FINISH REPORT axmg410_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT axmg410_rep(sr1)
    DEFINE l_oebslk01   LIKE oebslk_file.oebslk01
    DEFINE l_oebslk03   LIKE oebslk_file.oebslk03
    DEFINE l_oebslk04   LIKE oebslk_file.oebslk04 
    DEFINE sr2 sr2_t
    DEFINE sr3 sr3_t

    DEFINE l_n           LIKE type_file.num5
    DEFINE l_ima151      LIKE ima_file.ima151
    DEFINE l_sql         STRING
               
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_display  LIKE type_file.chr1 
   
    ORDER EXTERNAL BY sr1.oebslk01,sr1.oebslk04
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.oebslk01
        BEFORE GROUP OF sr1.oebslk04

            

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            PRINTX sr1.*
            
            
        
           ON LAST ROW

END REPORT


FUNCTION axmg410_slk_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING
    DEFINE l_oebslk03  LIKE oebslk_file.oebslk03

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
   
    
    CALL cl_gre_init_apr()           #FUN-C40026 add
 
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("axmg410")
        IF handler IS NOT NULL THEN
            START REPORT axmg410_slk_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," ORDER BY oebslk01,oebslk03,oebslk04"
          
            DECLARE axmg410_slk_datacur1 CURSOR FROM l_sql
            FOREACH axmg410_slk_datacur1 INTO sr1.*
                OUTPUT TO REPORT axmg410_slk_rep(sr1.*)
            END FOREACH
            FINISH REPORT axmg410_slk_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT axmg410_slk_rep(sr1)
    DEFINE l_oebslk01   LIKE oebslk_file.oebslk01
    DEFINE l_oebslk03   LIKE oebslk_file.oebslk03
    DEFINE l_oebslk04   LIKE oebslk_file.oebslk04 
    DEFINE sr2 sr2_t
    DEFINE sr3 sr3_t

    DEFINE l_n           LIKE type_file.num5
    DEFINE l_ima151      LIKE ima_file.ima151
    DEFINE l_sql         STRING
               
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_display  LIKE type_file.chr1 
   
    ORDER EXTERNAL BY sr1.oebslk01,sr1.oebslk04
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.oebslk01
        BEFORE GROUP OF sr1.oebslk04

            

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            PRINTX sr1.*
            
            SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01=sr1.oebslk04
            IF tm.b='Y' AND l_ima151='Y' AND sr1.oebslk12>0 THEN
               LET l_display = 'Y'
            ELSE 
               LET l_display = 'N'
            END IF 
            PRINTX l_display   
            LET l_sql = "SELECT distinct * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " WHERE oebslk04 = '",sr1.oebslk04 CLIPPED,"'"
               START REPORT axmg410_slk_subrep01
               DECLARE axmg410_slk_repcur1 CURSOR FROM l_sql
               FOREACH axmg410_slk_repcur1 INTO sr2.*
                  OUTPUT TO REPORT axmg410_slk_subrep01(sr2.*)
               END FOREACH
               FINISH REPORT axmg410_slk_subrep01

#子報表2
               LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                        " WHERE oebslk01 = '",sr1.oebslk01 CLIPPED,"'",
                        " AND oebslk03 = ",sr1.oebslk03 CLIPPED
               START REPORT axmg410_slk_subrep02
               DECLARE axmg410_slk_repcur2 CURSOR FROM l_sql
               FOREACH axmg410_slk_repcur2 INTO sr3.*
                   OUTPUT TO REPORT axmg410_slk_subrep02(sr3.*,sr2.*)
               END FOREACH
               FINISH REPORT axmg410_slk_subrep02
        
           ON LAST ROW

END REPORT


REPORT axmg410_slk_subrep01(sr2)
    DEFINE sr2 sr2_t

    FORMAT
        ON EVERY ROW
            PRINTX sr2.*

END REPORT
REPORT axmg410_slk_subrep02(sr3,sr2)
    DEFINE sr3 sr3_t
    DEFINE sr2 sr2_t
    DEFINE l_color  LIKE agd_file.agd03


    FORMAT
        ON EVERY ROW
        SELECT agd03 INTO l_color FROM agd_file,ima_file
           WHERE agd01 = ima940 AND agd02 = sr3.imx01
             AND ima01 = sr3.oebslk04
            PRINTX l_color
            PRINTX sr2.*  
            PRINTX sr3.*

END REPORT
###GENGRE###END
#FUN-C70020-----END-----
