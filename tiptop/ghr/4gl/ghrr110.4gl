# Prog. Version..: '5.30.03-12.09.18(00009)'     
#
# Pattern name...: ghrr110.4gl
# Descriptions...: 圣奥花名册
# Date & Author..: 13/08/21   by ye'anping

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                # Print condition RECORD         #TQC-BA0010
            wc     STRING,                 #No.TQC-630166 VARCHAR(600) #Where condition
            more   LIKE type_file.chr1     #No.FUN-680121 VARCHAR(1)# Input more condition(Y/N)
           END RECORD
DEFINE g_count     LIKE type_file.num5     #No.FUN-680121 SMALLINT
DEFINE g_i         LIKE type_file.num5     #No.FUN-680121 SMALLINT #count/index for any purpose
DEFINE g_msg       LIKE type_file.chr1000  #No.FUN-680121 VARCHAR(72)
DEFINE g_po_no     LIKE oea_file.oea10     #No.MOD-530401
DEFINE g_ctn_no1,g_ctn_no2   LIKE type_file.chr20         #No.FUN-680121 VARCHAR(20) #MOD-530401
DEFINE g_sql       STRING                                                   
DEFINE l_table     STRING                                                 
DEFINE g_str       STRING 
DEFINE g_hrat03    LIKE hraa_file.hraa01 
DEFINE g_hraa12    LIKE hraa_file.hraa12 
DEFINE g_hrat04    LIKE hrao_file.hrao01  
DEFINE g_hrao02    LIKE hrao_file.hrao02
DEFINE g_hrat01    LIKE hrat_file.hrat01
DEFINE g_hrat02    LIKE hrat_file.hrat02
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway =ARG_VAL(5)
   LET g_copies =ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
 
   display "g_pdate  =",g_pdate
   display "g_towhom =",g_towhom
   display "g_rlang  =",g_rlang
   display "g_bgjob  =",g_bgjob
   display "g_prtway =",g_prtway
   display "g_copies =",g_copies
   display "tm.wc    =",tm.wc
   
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   LET g_sql ="cr01.hrat_file.hrat01,",
               "cr02.hrat_file.hrat02,",
               "cr03.hrag_file.hrag07,",
               "cr04.hrag_file.hrag07,",
               "cr05.hrat_file.hrat15,",
               "cr06.hrag_file.hrag07,",
               "cr07.hrad_file.hrad03,",
               "cr08.hrag_file.hrag07,",
               "cr09.hrag_file.hrag07,",
               "cr10.hratc_file.hratc04,",
               "cr11.hrat_file.hrat23,",
               "cr12.hrat_file.hrat04,",
               "cr13.hrao_file.hrao02,",
               "cr14.hrao_file.hrao02,",
               "cr15.hrao_file.hrao02,",
               "cr16.hrao_file.hrao02,",
               "cr17.type_file.chr100,",
               "cr18.hraf_file.hraf02,",
               "cr19.hras_file.hras04,",
               "cr20.hrag_file.hrag07,",
               "cr21.hrat_file.hrat02,",
               "cr22.hrag_file.hrag07,",
               "cr23.hrat_file.hrat25,",
               "cr24.hrat_file.hrat26,",
               "cr25.type_file.chr100,",
               "cr26.hrat_file.hrat77,",
               "cr27.hrat_file.hrat36,",
               "cr28.hrag_file.hrag07,",
               "cr29.hrbf_file.hrbf08,",
               "cr30.hrbf_file.hrbf09,",
               "cr31.type_file.chr100,",
               "cr32.type_file.num26_10,",
               "cr33.hrat_file.hrat13,",
               "cr34.hrat_file.hrat14,",
               "cr35.hraqa_file.hraqa03,",
               "cr36.hrag_file.hrag07,",
               "cr37.hrag_file.hrag07,",
               "cr38.type_file.chr100,",
               "cr39.hrag_file.hrag07,",
               "cr40.hrat_file.hrat18,",
               "cr41.hrag_file.hrag07,",
               "cr42.hrat_file.hrat45,",
               "cr43.hrat_file.hrat46,",
               "cr44.hrat_file.hrat51,",
               "cr45.hrat_file.hrat49,",
               "cr46.hrath_file.hrath02,",
               "cr47.hrath_file.hrath05"
   LET l_table = cl_prt_temptable('ghrr110',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
    
    
   IF STATUS THEN CALL cl_err('create',STATUS,1) EXIT PROGRAM END IF  #yeap

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN        # If background job sw is off
      CALL ghrr110_tm(0,0)        # Input print condition
   ELSE
      CALL ghrr110()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION ghrr110_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01         #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,        #No.FUN-680121 SMALLINT
       l_dir          LIKE type_file.chr1,        #No.FUN-680121 VARCHAR(1)#Direction Flag
       l_cmd          LIKE type_file.chr1000      #No.FUN-680121 VARCHAR(400)
DEFINE l_hrat03    LIKE hraa_file.hraa01 
DEFINE l_hraa12    LIKE hraa_file.hraa12 
DEFINE l_hrat04    LIKE hrao_file.hrao01  
DEFINE l_hrao02    LIKE hrao_file.hrao02
DEFINE l_hrat01    LIKE hrat_file.hrat01
DEFINE l_hrat02    LIKE hrat_file.hrat02
DEFINE l_hrat19    LIKE hrat_file.hrat19

  LET p_row = 6 LET p_col = 20
  OPEN WINDOW ghrr110_w AT p_row,p_col WITH FORM "ghr/42f/ghrr110"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
  CALL cl_ui_init()
  CALL cl_opmsg('p')
 
  INITIALIZE tm.* TO NULL            # Default condition

  LET tm.more = 'N'
  LET g_pdate = g_today
  LET g_rlang = g_lang
  LET g_bgjob = 'N'
  LET g_copies = '1'
  WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON hrat03,hrat04,hrat01,hrat19,hraoud02

       BEFORE CONSTRUCT
          CALL cl_qbe_init()
          
       AFTER FIELD hrat03
          LET l_hrat03 = GET_FLDBUF(hrat03)
          IF NOT cl_null(l_hrat03) THEN 
             SELECT hraa12 INTO l_hraa12 FROM hraa_file WHERE hraa01 = l_hrat03
             DISPLAY l_hraa12 TO FORMONLY.hraa12
          END IF 
                   
       AFTER FIELD hrat04
          LET l_hrat04 = GET_FLDBUF(hrat04)
          IF NOT cl_null(l_hrat04) THEN 
             SELECT hrao02 INTO l_hrao02 FROM hrao_file WHERE hrao01 = l_hrat04
             DISPLAY l_hrao02 TO FORMONLY.hrao02
          END IF 
          
       AFTER FIELD hrat01
          LET l_hrat01 = GET_FLDBUF(hrat01)
          IF NOT cl_null(l_hrat01) THEN 
          	--CALL cl_err('员工工号不能为空','!',1)
             --NEXT FIELD hrat01
          --ELSE 
             SELECT hrat02 INTO l_hrat02 FROM hrat_file WHERE hrat01 = l_hrat01
             DISPLAY l_hrat02 TO FORMONLY.hrat02
          END IF 
          
          
       ON ACTION controlp
          CASE 
              WHEN INFIELD(hrat03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hraa01"
                 CALL cl_create_qry() RETURNING l_hrat03
                 DISPLAY l_hrat03 TO hrat03
                 NEXT FIELD hrat03
              WHEN INFIELD(hrat04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrao01"
                 LET g_qryparam.arg1 = l_hrat03
                 CALL cl_create_qry() RETURNING l_hrat04
                 DISPLAY l_hrat04 TO hrat04
                 NEXT FIELD hrat04
              WHEN INFIELD(hrat01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"                 
                 LET g_qryparam.form = "q_hrat01"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret 
                 DISPLAY g_qryparam.multiret  TO hrat01
                 NEXT FIELD hrat01
              WHEN INFIELD(hrat19)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"   
                 LET g_qryparam.form = "q_hrad02"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret 
                 DISPLAY g_qryparam.multiret  TO hrat19
                 NEXT FIELD hrat19                 
              OTHERWISE
                 EXIT CASE
           END CASE
 
       ON ACTION locale
          LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          EXIT CONSTRUCT
  
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
  
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT CONSTRUCT
 
       #No.FUN-580031 --start--
       ON ACTION qbe_select
          CALL cl_qbe_select()
       #No.FUN-580031 ---end---
 
    END CONSTRUCT
 
    IF g_action_choice = "locale" THEN
       LET g_action_choice = ""
       CALL cl_dynamic_locale()
       CONTINUE WHILE
    END IF
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       EXIT WHILE
    END IF
 
    IF tm.wc=" 1=1 " THEN
       CALL cl_err('没有录入员工信息','!',0)
       CONTINUE WHILE
    END IF
    DISPLAY BY NAME tm.more                  
    INPUT BY NAME tm.more WITHOUT DEFAULTS  
       
       BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
 
       AFTER FIELD more
          IF tm.more = 'Y' THEN
             CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies)
                  RETURNING g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies
          END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG 
          CALL cl_cmdask()    # Command execution
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
 
       #No.FUN-580031 --start--
       ON ACTION qbe_save
          CALL cl_qbe_save()
       #No.FUN-580031 ---end---
 
    END INPUT
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       EXIT WHILE
    END IF
 
    IF g_bgjob = 'Y' THEN
       SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
              WHERE zz01='ghrr110'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('ghrr110','9031',1)  
       ELSE
           LET tm.wc=cl_replace_str(tm.wc, "'", "\"") #"
          LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                          " '",g_pdate CLIPPED,"'",
                          " '",g_towhom CLIPPED,"'",
                          #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                          " '",g_bgjob CLIPPED,"'",
                          " '",g_prtway CLIPPED,"'",
                          " '",g_copies CLIPPED,"'",
                          " '",tm.wc CLIPPED,"'",               #FUN-750047 add
                       #   " '",g_argv1 CLIPPED,"'",
                       #   " '",g_argv2 CLIPPED,"'"
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
          CALL cl_cmdat('ghrr110',g_time,l_cmd)    # Execute cmd at later time
       END IF
       CLOSE WINDOW ghrr110_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
       EXIT PROGRAM
    END IF
 
    CALL cl_wait()
    CALL ghrr110()
    ERROR ""
  END WHILE
 
  CLOSE WINDOW ghrr110_w
END FUNCTION
 
FUNCTION ghrr110()
   DEFINE l_name    LIKE type_file.chr20,             #No.FUN-680121 VARCHAR(20)# External(Disk) file name
          l_sql     STRING,                           # RDSQL STATEMENT   TQC-630166
          l_chr     LIKE type_file.chr1,              #No.FUN-680121 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,           #No.FUN-680121 VARCHAR(40)
          l_sfb02doc LIKE type_file.chr30,            #No:TQC-A60097 add
          sr        RECORD
                                 cr01   LIKE hrat_file.hrat01,
                                 cr02   LIKE hrat_file.hrat02,
                                 cr03   LIKE hrag_file.hrag07,
                                 cr04   LIKE hrag_file.hrag07,
                                 cr05   LIKE hrat_file.hrat15,
                                 cr06   LIKE hrag_file.hrag07,
                                 cr07   LIKE hrad_file.hrad03,
                                 cr08   LIKE hrag_file.hrag07,
                                 cr09   LIKE hrag_file.hrag07,
                                 cr10   LIKE hratc_file.hratc04,
                                 cr11   LIKE hrat_file.hrat23,
                                 cr12   LIKE hrat_file.hrat04,
                                 cr13   LIKE hrao_file.hrao02,
                                 cr14   LIKE hrao_file.hrao02,
                                 cr15   LIKE hrao_file.hrao02,
                                 cr16   LIKE hrao_file.hrao02,
                                 cr17   LIKE type_file.chr100,
                                 cr18   LIKE hraf_file.hraf02,
                                 cr19   LIKE hras_file.hras04,
                                 cr20   LIKE hrag_file.hrag07,
                                 cr21   LIKE hrat_file.hrat02,
                                 cr22   LIKE hrag_file.hrag07,
                                 cr23   LIKE hrat_file.hrat25,
                                 cr24   LIKE hrat_file.hrat26,
                                 cr25   LIKE type_file.chr100,
                                 cr26   LIKE hrat_file.hrat77,
                                 cr27   LIKE hrat_file.hrat36,
                                 cr28   LIKE hrag_file.hrag07,
                                 cr29   LIKE hrbf_file.hrbf08,
                                 cr30   LIKE hrbf_file.hrbf09,
                                 cr31   LIKE type_file.chr100,
                                 cr32   LIKE type_file.num26_10,
                                 cr33   LIKE hrat_file.hrat13,
                                 cr34   LIKE hrat_file.hrat14,
                                 cr35   LIKE hraqa_file.hraqa03,
                                 cr36   LIKE hrag_file.hrag07,
                                 cr37   LIKE hrag_file.hrag07,
                                 cr38   LIKE type_file.chr100,
                                 cr39   LIKE hrag_file.hrag07,
                                 cr40   LIKE hrat_file.hrat18,
                                 cr41   LIKE hrag_file.hrag07,
                                 cr42   LIKE hrat_file.hrat45,
                                 cr43   LIKE hrat_file.hrat46,
                                 cr44   LIKE hrat_file.hrat51,
                                 cr45   LIKE hrat_file.hrat49,
                                 cr46   LIKE hrath_file.hrath02,
                                 cr47   LIKE hrath_file.hrath05
                    END RECORD
   DEFINE l_fdm,l_fdf,l_fim,l_fif LIKE type_file.num5  #foreign,direct/indirect,male/female
   DEFINE l_ldfm,l_ldff,l_ldpm,l_ldpf,l_lifm,l_liff,l_lipm,l_lipf LIKE type_file.num5  #local,direct/indirect,formal/probation,male/female
   DEFINE l_n   LIKE type_file.num5
   DEFINE            l_img_blob     LIKE type_file.blob
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog

   CALL cl_del_data(l_table) 
   
   LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,
                        ?,?,?,?,?,
                        ?,?,?,?,?,
                        ?,?,?,?,?,
                        ?,?,?,?,?,
                        ?,?,?,?,?,
                        ?,?,?,?,?,
                        ?,?,?,?,?,
                        ?,?,?,?,?,?,?) "
   PREPARE insert_prep FROM l_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1) EXIT PROGRAM
   END IF
   
   
   LOCATE l_img_blob IN MEMORY #blob初始化 #No.FUN-940042
   #------------------------------ CR (2) ------------------------------#

   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('hratuser', 'hratgrup')
   
    LET l_sql = " SELECT 
                  a.hrat01 cr01,a.hrat02 cr02,ag333.hrag07 cr03,ag301.hrag07 cr04,a.hrat15 cr05,ag313.hrag07 cr06,i.hrad03 cr07,ag317.hrag07 cr08,
                  ag316.hrag07 cr09,h.hratc04 cr10,a.hrat23 cr11,a.hrat04 cr12,nvl(NVL(l.hrao02,k.hrao02),j.hrao02) cr13,NVL(k.hrao02,j.hrao02) cr14,
                  j.hrao02 cr15,g.hrao02 cr16,N'班组'  cr17,b.hraf02 cr18,c.hras04 cr19, cr20,d.hrat02 cr21,ag337.hrag07 cr22,
                  a.hrat25 cr23,a.hrat26 cr24,N'转正考核分数' cr25,CASE WHEN a.hrat77>SYSDATE THEN NULL ELSE a.hrat77 END cr26,
                  a.hrat36 cr27,e.hrag07 cr28,e.hrbf08 cr29,e.hrbf09 cr30,e.col3 cr31,e.col2 cr32,
                  a.hrat13 cr33,a.hrat14 cr34,m.hraqa03 cr35,ag319.hrag07 cr36,
                  ag320.hrag07 cr37,CASE WHEN a.hrat54 = 'Y' THEN N'是' ELSE N'否' END  cr38,ag334.hrag07 cr39,a.hrat18 cr40,ag321.hrag07 cr41,
                  a.hrat45 cr42,a.hrat46 cr43,a.hrat51 cr44,a.hrat49 cr45,f.hrath02 cr46,f.hrath05 cr47
                  FROM (select hrat_file.* from hrat_file,hrao_file where hrat04=hrao01 and ",tm.wc,") a
                  LEFT JOIN hrag_file ag333 ON ag333.hrag06=a.hrat17 AND ag333.hrag01='333'
                  LEFT JOIN hrag_file ag301 ON ag301.hrag06=a.hrat29 AND ag301.hrag01='301'
                  LEFT JOIN hrag_file ag313 ON ag313.hrag06=a.hrat20 AND ag313.hrag01='313'
                  LEFT JOIN hrag_file ag317 ON ag317.hrag06=a.hrat22 AND ag317.hrag01='317'
                  LEFT JOIN hrao_file g ON g.hrao01=a.hrat04
                  LEFT JOIN hraf_file b ON b.hraf01=a.hrat40
                  LEFT JOIN hras_file c ON c.hras01=a.hrat05
                  LEFT JOIN hrat_file d ON d.hrat01=a.hrat06
                  LEFT JOIN (SELECT hrbf02,hrag07,hrbf08,hrbf09,CASE WHEN hrbf05='Y' THEN N'不固定' ELSE N'固定' END col3,tab1.col2 FROM hrbf_file 
                  LEFT JOIN hrag_file ON hrag06=hrbf11 AND hrag01='339'
                  LEFT JOIN (SELECT hrbf02 AS col1,COUNT(hrbf02) col2 FROM hrbf_file GROUP BY hrbf02) tab1 ON tab1.col1=hrbf02
                  WHERE SYSDATE BETWEEN hrbf08 AND hrbf09) e ON e.hrbf02=a.hratid
                  LEFT JOIN hrag_file ag319 ON ag319.hrag06=a.hrat43 AND ag319.hrag01='319'
                  LEFT JOIN hrag_file ag320 ON ag320.hrag06=a.hrat34 AND ag320.hrag01='320'
                  LEFT JOIN hrag_file ag334 ON ag334.hrag06=a.hrat24 AND ag334.hrag01='334'
                  LEFT JOIN hrag_file ag321 ON ag321.hrag06=a.hrat30 AND ag321.hrag01='321'
                  LEFT JOIN hrath_file f ON f.hrath01=a.hrat01
                  LEFT JOIN (SELECT hratc01,hratc04,hratc09 FROM hratc_file WHERE EXISTS(SELECT 1 FROM (SELECT hratc01 col1,MAX(hratc03) col2 FROM hratc_file GROUP BY hratc01) tab2 WHERE tab2.col1=hratc01 AND tab2.col2=hratc03)) h ON h.hratc01=a.hrat01
                  LEFT JOIN hrag_file ag316 ON ag316.hrag06=h.hratc09 AND ag316.hrag01='316'
                  LEFT JOIN hrad_file i ON i.hrad02=a.hrat19
                  LEFT JOIN hrao_file j ON j.hrao01=g.hrao06
                  LEFT JOIN hrao_file k ON k.hrao01=j.hrao06
                  LEFT JOIN hrao_file l ON l.hrao01=k.hrao06
                  LEFT JOIN hrag_file ag337 ON ag337.hrag06=a.hrat21 AND ag337.hrag01='337'
                  LEFT JOIN (SELECT hratg01,hraqa03 FROM hratg_file LEFT JOIN hraqa_file ON hraqa06=hratg02 WHERE EXISTS(SELECT 1 FROM (SELECT hratg01 col1,MAX(hratg03) col2 FROM hratg_file GROUP BY hratg01)tab3 WHERE  tab3.col1=hratg01 AND tab3.col2=hratg03)) m ON m.hratg01=a.hrat01 
                  LEFT JOIN (SELECT DISTINCT HRAG07 || HRDEUD02 CR20,hrdp04
                               FROM HRDP_FILE
                               LEFT JOIN HRDPC_FILE ON HRDPC01 = HRDP01 AND TRUNC(SYSDATE) BETWEEN HRDPC06 AND HRDPC07
                               LEFT JOIN HRDE_FILE ON HRDE03 = HRDPC03 AND HRDE05 = HRDPC04
                               LEFT JOIN HRAG_FILE ON HRAG06 = HRDE03 AND HRAG01 = '649') M ON hrdp04=A.hratid "
                  #LEFT JOIN (SELECT DISTINCT CASE WHEN HRDP03 = '003' THEN HRDEUD01 || HRDEUD02 ELSE HRAG07 || HRDEUD02 END AS CR20,hrdp04
      PREPARE r017_p FROM l_sql 
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('ghrr110_p:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM
      END IF
      DECLARE r017_curs CURSOR FOR r017_p
      FOREACH r017_curs INTO sr.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
          EXECUTE insert_prep USING sr.*
      END FOREACH
    LET g_str=''
    LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    CALL cl_prt_cs3('ghrr110','ghrr110',l_sql,g_str)
   
END FUNCTiON      
