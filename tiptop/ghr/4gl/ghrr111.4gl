# Prog. Version..: '5.30.03-12.09.18(00009)'     
#
# Pattern name...: cghrr001.4gl
# Descriptions...: 月考勤统计表
# Date & Author..: 14/09/28   by zhuzw

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                # Print condition RECORD         #TQC-BA0010
            wc     STRING,#No.TQC-630166 VARCHAR(600) #Where condition
            hrcj03   LIKE hrcj_file.hrcj03
           END RECORD
DEFINE g_count     LIKE type_file.num5     #No.FUN-680121 SMALLINT
DEFINE g_i         LIKE type_file.num5     #No.FUN-680121 SMALLINT #count/index for any purpose
DEFINE g_msg       LIKE type_file.chr1000  #No.FUN-680121 VARCHAR(72)
DEFINE g_po_no     LIKE oea_file.oea10     #No.MOD-530401
DEFINE g_ctn_no1,g_ctn_no2   LIKE type_file.chr20         #No.FUN-680121 VARCHAR(20) #MOD-530401
DEFINE g_sql       STRING                                                   
DEFINE l_table     STRING                                                 
DEFINE g_str       STRING
DEFINE g_hrag    RECORD LIKE hrag_file.*   
DEFINE g_byear        LIKE type_file.chr100
DEFINE g_bmonth       LIKE type_file.chr100
DEFINE g_qmonth       LIKE type_file.num10
DEFINE l_rep_name  STRING 
DEFINE s_year  LIKE type_file.chr4
DEFINE s_month LIKE type_file.chr2
DEFINE l_m     LIKE type_file.chr200

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function

   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF 
   LET g_sql ="hrao02.hrao_file.hrao02,",
              "hrat01.hrat_file.hrat01,",
              "hrat02.hrat_file.hrat02,",
              "hrat21.hrat_file.hrat21,",
              #"hraoud02.hrao_file.hraoud02,",
              "col1.hrcp_file.hrcp09,",
              "col2.hrcp_file.hrcp09,",
              "col3.hrcp_file.hrcp09,",
              "col4.hrcp_file.hrcp09,",
              "col5.hrcp_file.hrcp09,",
              "col6.hrcp_file.hrcp09,",
              "col7.hrcp_file.hrcp09,",
              "col8.hrcp_file.hrcp09,",
              "col9.hrcp_file.hrcp09,",
              "col10.hrcp_file.hrcp09,",
              "col11.hrcp_file.hrcp09,",
              "col12.hrcp_file.hrcp09,",
              "col13.hrcp_file.hrcp09,",
              "col14.hrcp_file.hrcp09,",
              "col15.hrcp_file.hrcp09,",
              "col16.hrcp_file.hrcp09,",
              "col17.hrcp_file.hrcp09,",
              "col18.hrcp_file.hrcp09,",
              "col19.hrcp_file.hrcp09,",
              "col20.hrcp_file.hrcp09,",
              "col21.hrcp_file.hrcp09,",
              "col22.hrcp_file.hrcp09,",
              "col23.hrcp_file.hrcp09,",
              "col24.hrcp_file.hrcp09"

   LET l_table = cl_prt_temptable('ghrr111',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   	
   	
   IF STATUS THEN CALL cl_err('create',STATUS,1) EXIT PROGRAM END IF  #yeap

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   CALL cghrr001_tm(0,0)        # Input print condition
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION cghrr001_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01         #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,        #No.FUN-680121 SMALLINT
       l_dir          LIKE type_file.chr1,        #No.FUN-680121 VARCHAR(1)#Direction Flag
       l_cmd          LIKE type_file.chr1000      #No.FUN-680121 VARCHAR(400)
      ,l_hrat01       LIKE hrat_file.hrat01
      ,l_hrao01       LIKE hrao_file.hrao01
      ,l_byear        LIKE type_file.chr100
      ,l_bmonth       LIKE type_file.chr100
      ,l_hrat02       LIKE hrat_file.hrat02
      ,l_hrat04       LIKE hrat_file.hrat04
      ,l_hrao02       LIKE hrao_file.hrao02 
      ,l_n            LIKE type_file.num5 
      ,i              LIKE type_file.num5

    #  l_x             LIKE type_file.chr200
  LET p_row = 6 LET p_col = 20
  OPEN WINDOW cghrr001_w AT p_row,p_col WITH FORM "ghr/42f/ghrr111"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
  CALL cl_ui_init()
  CALL cl_opmsg('p')
 
  INITIALIZE tm.* TO NULL            # Default condition          
  WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON hrat04,hrat01,hraoud02,hrat21
       BEFORE CONSTRUCT
          CALL cl_qbe_init()                   	
       AFTER FIELD hrat04
          LET l_hrat04 = GET_FLDBUF(hrat04)
          IF NOT cl_null(l_hrat04) THEN
             SELECT hrao02 INTO l_hrao02 FROM hrao_file WHERE hrao01 = l_hrat04
            # DISPLAY l_hrao02 TO FORMONLY.hrao02
          END IF
          

       ON ACTION controlp
          CASE 
          	  WHEN INFIELD(hrat04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrao01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat04
                 NEXT FIELD hrat04
            
              WHEN INFIELD(hrat01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrat01" 
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat01
                 NEXT FIELD hrat01

              WHEN INFIELD(hrat21)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '337'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat21
                 NEXT FIELD hrat21

            WHEN INFIELD(hraoud02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrag08"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hraoud02
                 NEXT FIELD hraoud02


             
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
    INPUT BY NAME tm.hrcj03 WITHOUT DEFAULTS  
       
       BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
        
    
 
                 
       AFTER FIELD hrcj03
       IF NOT cl_null(tm.hrcj03) THEN 
       LET s_year=tm.hrcj03[1,4]
       LET s_month=tm.hrcj03[5,6]
 SELECT hrbl02 INTO g_qmonth FROM hrbl_file WHERE hrbl04=s_year AND hrbl05 = to_number(s_month)
         SELECT COUNT(*) INTO l_n FROM hrcj_file
           WHERE hrcj03 =  g_qmonth
         { IF l_n = 0 THEN 
             CALL cl_err(tm.hrcj03,'cghr003',0)
             NEXT FIELD hrcj03
          END IF }
       END IF 

       
{ON ACTION controlp
          CASE 
           WHEN INFIELD(hrat01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrat01" 
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING tm.hrat01
                 DISPLAY BY NAME tm.hrat01  
                  OTHERWISE
                 EXIT CASE
           END CASE}


 {#工号解析         
       IF NOT cl_null(tm.hrat01) THEN 
       LET l_m="'",tm.hrat01[1,6],"'",',',"'"
          FOR i=1 TO length(tm.hrat01)
                IF tm.hrat01[i,i] = '|' THEN
               # LET tm.hrat01[i,i+6]="'",",",","
                LET l_m =l_m,tm.hrat01[i+1,i+6],'''',',',''''
                END IF
          END FOR 
          LET l_m=l_m[1,length(l_m)-2]
        END IF }
        
        
           
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
 
    CALL cl_wait()
    CALL cghrr001()
    ERROR ""
  END WHILE
 
  CLOSE WINDOW cghrr001_w
END FUNCTION
 
FUNCTION cghrr001()
   DEFINE l_name    LIKE type_file.chr20,             #No.FUN-680121 VARCHAR(20)# External(Disk) file name
          l_sql     STRING,                           # RDSQL STATEMENT   TQC-630166
          l_chr     LIKE type_file.chr1,              #No.FUN-680121 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,           #No.FUN-680121 VARCHAR(40)
          l_sfb02doc LIKE type_file.chr30,            #No:TQC-A60097 add
          sr        RECORD
                     hrao02      LIKE hrao_file.hrao02,
                     hrat01      LIKE hrat_file.hrat01,
                     hrat02      LIKE hrat_file.hrat02,
                     hrat21      LIKE hrat_file.hrat21,
                     #hraoud02    LIKE hrao_file.hraoud02,
                     cl1         LIKE hrcp_file.hrcp09,
                     cl2         LIKE hrcp_file.hrcp09,
                     cl3         LIKE hrcp_file.hrcp09,                     
                     cl4         LIKE hrcp_file.hrcp09,
                     cl5         LIKE hrcp_file.hrcp09,
                     cl6         LIKE hrcp_file.hrcp09,
                     cl7         LIKE hrcp_file.hrcp09,
                     cl8         LIKE hrcp_file.hrcp09,
                     cl9         LIKE hrcp_file.hrcp09,
                     cl10        LIKE hrcp_file.hrcp09,
                    cl11         LIKE hrcp_file.hrcp09,
                    cl12         LIKE hrcp_file.hrcp09,
                    cl13         LIKE hrcp_file.hrcp09, 
                    cl14         LIKE hrcp_file.hrcp09,
                    cl15         LIKE hrcp_file.hrcp09,
                    cl16         LIKE hrcp_file.hrcp09,
                    cl17         LIKE hrcp_file.hrcp09,
                    cl18         LIKE hrcp_file.hrcp09,
                    cl19         LIKE hrcp_file.hrcp09,
                    cl20         LIKE hrcp_file.hrcp09,
                    cl21         LIKE hrcp_file.hrcp09,
                    cl22         LIKE hrcp_file.hrcp09,
                    cl23         LIKE hrcp_file.hrcp09,
                    cl24         LIKE hrcp_file.hrcp09

                    END RECORD

   DEFINE l_li     LIKE type_file.num5
   DEFINE l_hraa12  LIKE hraa_file.hraa12
   DEFINE l_fdm,l_fdf,l_fim,l_fif LIKE type_file.num5  #foreign,direct/indirect,male/female
   DEFINE l_ldfm,l_ldff,l_ldpm,l_ldpf,l_lifm,l_liff,l_lipm,l_lipf LIKE type_file.num5  #local,direct/indirect,formal/probation,male/female
   DEFINE l_n   LIKE type_file.num5

   DEFINE            l_img_blob     LIKE type_file.blob

  


   




   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog

   CALL cl_del_data(l_table) 
   
   LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "
   PREPARE insert_prep FROM l_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1) EXIT PROGRAM
   END IF
   
   
   LOCATE l_img_blob IN MEMORY #blob初始化 #No.FUN-940042
   #------------------------------ CR (2) ------------------------------#
   
 
  
   IF cl_null(tm.wc) THEN LET tm.wc = '1=1'    END IF 
   
   LET l_sql = "  SELECT hrao02,hrat01,hrat02,hrat21,                                                                  ",                                  
                " a.col1,a.col2,a.col3,a.col4,a.col5,a.col6,a.col7,a.col8,a.col9,a.col10+a.col24 col10,                             ",
                " a.col11,a.col12,a.col13,a.col14,a.col15,a.col16,a.col17,a.col18,a.col19,a.col20,a.col22-a.col1-a.col2-a.col3-a.col4-a.col5-a.col6-a.col8-a.col12-a.col9-a.col19/2-a.col20 col21, a.col22,",
                " a.col23                                                                                             ",
                " FROM (                                                                                              ",
                " SELECT hrcja03,                                                                                     ",
                " SUM(CASE WHEN hrcja04='005' THEN NVL(hrcja06,0) ELSE 0 END) col1,                                        ",
                " SUM(CASE WHEN hrcja04='006' THEN NVL(hrcja06,0) ELSE 0 END) col2,                                        ",
                " SUM(CASE WHEN hrcja04='010' THEN NVL(hrcja06,0) ELSE 0 END) col3,                                          ",
                " SUM(CASE WHEN hrcja04='019' THEN NVL(hrcja06,0) ELSE 0 END) col4,                                        ",
                " SUM(CASE WHEN hrcja04='027' THEN NVL(hrcja06,0) ELSE 0 END) col5,                                        ",
                " SUM(CASE WHEN hrcja04='XXX' THEN NVL(hrcja07,0) ELSE 0 END)/8 col6,                                        ",
                " SUM(CASE WHEN hrcja04='011' THEN NVL(hrcja06,0) ELSE 0 END) col7,                                        ",
                " SUM(CASE WHEN hrcja04='024' THEN NVL(hrcja06,0) ELSE 0 END) col8,                                        ",
                " SUM(CASE WHEN hrcja04='007' THEN NVL(hrcja06,0) ELSE 0 END) col9,                                        ",
                " SUM(CASE WHEN hrcja04='025' THEN NVL(hrcja06,0) ELSE 0 END) col10,                                       ",
                " SUM(CASE WHEN hrcja04='034' THEN NVL(hrcja05,0) ELSE 0 END) col11,                                         ",
                " SUM(CASE WHEN hrcja04='021' THEN NVL(hrcja06,0) ELSE 0 END) col12,                                       ",
                " SUM(CASE WHEN hrcja04='001' THEN NVL(hrcja05,0) ELSE 0 END) col13,                                         ",
                " SUM(CASE WHEN hrcja04='004' THEN NVL(hrcja05,0) ELSE 0 END) col14,                                         ",
                " SUM(CASE WHEN hrcja04='009' THEN NVL(hrcja05,0) ELSE 0 END) col15,                                         ",
                " SUM(CASE WHEN hrcja04='013' THEN NVL(hrcja05,0) ELSE 0 END) col16,                                         ",
                " SUM(CASE WHEN hrcja04='014' THEN NVL(hrcja05,0) ELSE 0 END) col17,                                         ",
                " SUM(CASE WHEN hrcja04='002' THEN NVL(hrcja05,0) ELSE 0 END) col18,                                         ",
                " SUM(CASE WHEN hrcja04='026' THEN NVL(hrcja05,0) ELSE 0 END) col19,                                         ",
                " SUM(CASE WHEN hrcja04='003' THEN NVL(hrcja05,0) ELSE 0 END) col20,                                         ",
                " SUM(CASE WHEN hrbo06='N' THEN NVL(hrcja05,0) ELSE 0 END)-SUM(CASE WHEN hrcja04='022' THEN NVL(hrcja07,0) ELSE 0 END)/8 col22,  ",
                " SUM(CASE WHEN hrcja04='015' OR hrcja04='016' OR hrcja04='017' THEN NVL(hrcja07,0) ELSE 0 END) col23,        ",
                " SUM(CASE WHEN hrcja04='022' THEN NVL(hrcja07,0) ELSE 0 END)/8 col24 ",
                " FROM hrcja_file                                                                                     ",
                " LEFT JOIN hrcj_file ON hrcj01=hrcja01                                                               ",
                " LEFT JOIN hrbo_file ON hrbo02=SUBSTR(hrcja04,2,10) ",
                " WHERE hrcj03=TRIM('",g_qmonth,"')                                                                        ",
                " GROUP BY hrcja03)a                                                                                  ",
                " LEFT JOIN hrat_file ON hrcja03=hratid                                                               ",
                " LEFT JOIN hrao_file ON hrao01=hrat04",
                " WHERE ",tm.wc ,"  and hrat04 in(select tc_hraa03 from tc_hraa_file where tc_hraa01='",g_user,"') order by hrat04 " #or hrat01 in(",l_m,") "                 
      PREPARE r100_p FROM l_sql 
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('cghrr001_p:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM
      END IF
      DECLARE r100_curs CURSOR FOR r100_p
      
      FOREACH r100_curs INTO sr.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
       
          EXECUTE insert_prep USING sr.*
       
                 
      END FOREACH

    LET l_rep_name="ghr/ghrr111.cpt&p1=",s_year,"&p2=",s_month    
    LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    CALL cl_prt_fine(l_rep_name,l_sql,l_table)    
   
END FUNCTION      
