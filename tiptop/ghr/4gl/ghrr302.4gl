# Prog. Version..: '5.30.03-12.09.18(00010)'     #
#
# Pattern name...: ghrr302.4gl
# Descriptions...: 正式月考勤表
# Date & Author..: 16/12/23 by nihaun


DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc      STRING,                #TQC-630166    # Where condition
              firm   LIKE    hrat_file.hrat03,
              dpt    LIKE    hrat_file.hrat04,
              staff  LIKE    hrat_file.hrat01,
              sdate   LIKE   type_file.dat,           #No.FUN-680137 DATE
              edate   LIKE   type_file.dat           #No.FUN-680137 DATE
        
            END RECORD,
          g_rank      LIKE type_file.num5,          #No.FUN-680137 SMALLINT              # Rank
         #g_atot      LIKE type_file.num5,          #No.FUN-680137 SMALLINT              # total array   #FUN-A70084
          g_dash_1    LIKE type_file.chr1000        #No.FUN-680137 VARCHAR(400)

DEFINE    l_table     STRING,                       ### FUN-710071 ###
          g_sql       STRING                        ### FUN-710071 ###          
DEFINE    g_str       STRING
DEFINE    g_i         LIKE  type_file.num5           #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE    g_rec_b     LIKE  type_file.num10          #No.FUN-680137   INTEGER
DEFINE    m_plant     LIKE  hrat_file.hrat03           #No.FUN-A70084 
DEFINE    g_wc        LIKE  type_file.chr1000        #No.FUN-A70084

DEFINE 
        g_wc2           string,
        l_ac            LIKE type_file.num5,                
        l_cmd           LIKE type_file.chr1000      

DEFINE g_forupd_sql    string      
DEFINE g_before_input_done  LIKE type_file.num5        
DEFINE p_row,p_col     LIKE type_file.num5          
DEFINE g_hrbl04        LIKE hrbl_file.hrbl04,
       g_hrbl05        LIKE hrbl_file.hrbl05

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 


   
   LET g_sql =  "nu.type_file.num5,  ",
                "hrat02.hrat_file.hrat02,",
                "hrat01.hrat_file.hrat01,", 
                "hrao02.hrao_file.hrao02,",
                "hras04.hras_file.hras04,",
                "hrat25.hrat_file.hrat25,",
                "hrat77.hrat_file.hrat77,",
                "hrag07.hrag_file.hrag07,",
                "wcq.type_file.num5,",
                "sj.hrcp_file.hrcp09,",
                "bj.hrcp_file.hrcp09,",
                "saj.hrcp_file.hrcp09,",
                "cj.hrcp_file.hrcp09,",
                "gsj.hrcp_file.hrcp09,",
                "gxj.hrcp_file.hrcp09,",
                "ccj.hrcp_file.hrcp09,",
                "hj.hrcp_file.hrcp09,",
                "pcj.hrcp_file.hrcp09,",
                "ftj.hrcp_file.hrcp09,",
                "jsj.hrcp_file.hrcp09,",
                "kg.hrcp_file.hrcp09,",
                "txj.hrcp_file.hrcp09,",
                "qqj.type_file.num5,  ",
                "jt.type_file.num5,  ",
                "prjb.hrcp_file.hrcp09,", 
                "jejb.hrcp_file.hrcp09,", 
                "jajb.hrcp_file.hrcp09,", 
                "sytx.hrcp_file.hrcp09,",   
                "day1.hrcp_file.hrcp09,",   
                "day2.hrcp_file.hrcp09,",   
                "day3.hrcp_file.hrcp09,",   
                "day4.hrcp_file.hrcp09,",   
                "day5.hrcp_file.hrcp09,",   
                "day6.hrcp_file.hrcp09,",   
                "day7.hrcp_file.hrcp09,",   
                "day8.hrcp_file.hrcp09,",   
                "day9.hrcp_file.hrcp09,",   
                "day10.hrcp_file.hrcp09,",   
                "day11.hrcp_file.hrcp09,",   
                "day12.hrcp_file.hrcp09,",   
                "day13.hrcp_file.hrcp09,",   
                "day14.hrcp_file.hrcp09,",   
                "day15.hrcp_file.hrcp09,",   
                "day16.hrcp_file.hrcp09,",   
                "day17.hrcp_file.hrcp09,",   
                "day18.hrcp_file.hrcp09,",   
                "day19.hrcp_file.hrcp09,",   
                "day20.hrcp_file.hrcp09,",   
                "day21.hrcp_file.hrcp09,",   
                "day22.hrcp_file.hrcp09,",   
                "day23.hrcp_file.hrcp09,",   
                "day24.hrcp_file.hrcp09,",   
                "day25.hrcp_file.hrcp09,",   
                "day26.hrcp_file.hrcp09,",   
                "day27.hrcp_file.hrcp09,",   
                "day28.hrcp_file.hrcp09,",   
                "day29.hrcp_file.hrcp09,",   
                "day30.hrcp_file.hrcp09,",   
                "day31.hrcp_file.hrcp09,",
                "hrbl04.hrbl_file.hrbl04,",
                "hrbl05.hrbl_file.hrbl05"
                
 
    LET l_table = cl_prt_temptable('ghrr302',g_sql) CLIPPED   # 產生Temp Table
    IF l_table = -1 THEN 
        EXIT PROGRAM 
    END IF                 
 
 
      INITIALIZE tm.* TO NULL                # Default condition

    IF cl_null(tm.wc) THEN
      CALL ghrr302_tm(0,0)               # Input print condition
    ELSE
      CALL ghrr302()                     # Read data and create out-file
    END IF
    

   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION ghrr302_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
   DEFINE p_row,p_col  LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          i            LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_ac         LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_cmd        LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(1000)
          l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680137 SMALLINT
          l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680137 SMALLINT
   DEFINE l_cnt           LIKE type_file.num5                 #FUN-A80097 
   DEFINE l_hrat04     LIKE hrat_file.hrat04, 
          l_hrat03     LIKE hrat_file.hrat03
   
   LET p_row = 4 LET p_col = 10
   
   OPEN WINDOW ghrr302_w AT p_row,p_col WITH FORM "ghr/42f/ghrr302"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
       
   CALL cl_ui_init()
   
   LET tm.sdate = g_today
   LET tm.edate = g_today
   LET g_pdate = g_today

   CALL cl_opmsg('p')
   WHILE TRUE
   
   CONSTRUCT BY NAME tm.wc ON hrat03,hrat04,hrat01,hrat20,hrbl04,hrbl05

      BEFORE CONSTRUCT
          CALL cl_qbe_init()

      ON ACTION controlp 
         CASE
#            WHEN INFIELD(hrat01) 
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_hrat"
#               LET g_qryparam.state = "c"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO hrat01
#               NEXT FIELD hrat01
              WHEN INFIELD(hrat01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrat01"
                 #LET g_qryparam.construct = 'N'
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat01
                 NEXT FIELD hrat01
              WHEN INFIELD(hrat03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hraa01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat03
                 NEXT FIELD hrat03
              WHEN INFIELD(hrat04)
              CALL cl_init_qry_var()
              IF NOT cl_null(l_hrat03) THEN
              	 CASE
#                   WHEN NOT cl_null(l_hrat03)
#                     LET g_qryparam.form = "cq_hrao01_0"
#                     LET g_qryparam.arg1 = l_hrat03
#                     LET g_qryparam.arg2 = '1'
#                     LET g_qryparam.arg3 = g_hrat.hrat94
                    WHEN NOT cl_null(l_hrat03)
                     LET g_qryparam.arg1 = l_hrat03
                     LET g_qryparam.arg2 = '1'
                     LET g_qryparam.form = "cq_hrao01_0_1"
                 END CASE
#               LET g_qryparam.arg1 = g_hrat.hrat03
#               LET g_qryparam.arg2 = '1'
#               LET g_qryparam.form = "cq_hrao01_0_1"
              ELSE
              LET g_qryparam.state = "c"
              LET g_qryparam.arg2 = '1'
               LET g_qryparam.form = "cq_hrao01_1_1"
              END IF
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO hrat04
              NEXT FIELD hrat04
              
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.arg2 = '1'
#                 LET g_qryparam.form = "cq_hrao01_1_1"
#                 LET g_qryparam.state = "c"
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO hrat04
#                 NEXT FIELD hrat04    
              WHEN INFIELD(hrat20)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '313'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat20
                 NEXT FIELD hrat20                   
               OTHERWISE
                  EXIT CASE
            END CASE

      AFTER FIELD hrat03 
        LET l_hrat03 = GET_FLDBUF(hrat03)
      AFTER FIELD hrat04 
        LET l_hrat04 = GET_FLDBUF(hrat04)
      AFTER FIELD hrbl04
        LET g_hrbl04 = GET_FLDBUF(hrbl04)
        IF cl_null(g_hrbl04) THEN 
           CALL cl_err('年不可为空','!',0)
           NEXT FIELD hrbl04
        END IF     
      AFTER FIELD hrbl05
        LET g_hrbl05 = GET_FLDBUF(hrbl05)
#        IF cl_null(g_hrbl05) THEN 
#           CALL cl_err('月不可为空','!',0)
#           NEXT FIELD hrbl05
#        END IF

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
        LET INT_FLAG = 0
        CLOSE WINDOW ghrr302_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
    END IF


   LET g_rank = 0
               
    INPUT BY NAME tm.sdate, tm.edate WITHOUT DEFAULTS

      AFTER FIELD sdate
         IF cl_null(tm.edate) THEN 
             NEXT FIELD edate 
         END IF
      AFTER FIELD edate
        IF cl_null(tm.edate) THEN 
            NEXT FIELD edate 
        END IF
        IF tm.sdate > tm.edate THEN 
            NEXT FIELD edate 
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
      END INPUT
 
     IF INT_FLAG THEN
        LET INT_FLAG = 0 
        CLOSE WINDOW ghrr302_w 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
    END IF
      
      CALL cl_wait()
      CALL ghrr302()
     
      END WHILE
   CLOSE WINDOW ghrr302_w
 END FUNCTION
 
FUNCTION ghrr302()
   DEFINE l_name    LIKE type_file.chr20,           # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
          l_sql      STRING,       #No.FUN-680137 VARCHAR(1000)
          l_sql1     STRING, 
          l_rate    LIKE oea_file.oea24,  #No.MOD-640559 add
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          l_dbs     LIKE azp_file.azp03,  #No.FUN-680137 VARCHAR(22)
          j         LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_occ01   LIKE occ_file.occ01,
          l_amt     LIKE occ_file.occ63,
          g_hrao02  LIKE hrao_file.hrao02,
          
          sr        RECORD 
                    hrat02  LIKE hrat_file.hrat02,
                    hrat01  LIKE hrat_file.hrat01, 
                    hrao02  LIKE hrao_file.hrao02,
                    hras04  LIKE hras_file.hras04,
                    hrat25  LIKE hrat_file.hrat25,
                    hrat77  LIKE hrat_file.hrat77,
                    hrag07  LIKE hrag_file.hrag07,
                    wcq     LIKE type_file.num5,
                    sj      LIKE hrcp_file.hrcp09,
                    bj      LIKE hrcp_file.hrcp09,
                    saj     LIKE hrcp_file.hrcp09,
                    cj      LIKE hrcp_file.hrcp09,
                    gsj     LIKE hrcp_file.hrcp09,
                    gxj     LIKE hrcp_file.hrcp09,
                    ccj     LIKE hrcp_file.hrcp09,
                    hj      LIKE hrcp_file.hrcp09,
                    pcj     LIKE hrcp_file.hrcp09,
                    ftj     LIKE hrcp_file.hrcp09,
                    jsj     LIKE hrcp_file.hrcp09,
                    kg      LIKE hrcp_file.hrcp09,
                    txj     LIKE hrcp_file.hrcp09,
                    qqj     LIKE type_file.num5,
                    jt      LIKE type_file.num5,
                    prjb    LIKE hrcp_file.hrcp09,
                    jejb    LIKE hrcp_file.hrcp09,
                    jajb    LIKE hrcp_file.hrcp09,
                    sytx    LIKE hrcp_file.hrcp09,   
                    day1    LIKE hrcp_file.hrcp09,   
                    day2    LIKE hrcp_file.hrcp09,   
                    day3    LIKE hrcp_file.hrcp09,   
                    day4    LIKE hrcp_file.hrcp09,   
                    day5    LIKE hrcp_file.hrcp09,   
                    day6    LIKE hrcp_file.hrcp09,   
                    day7    LIKE hrcp_file.hrcp09,   
                    day8    LIKE hrcp_file.hrcp09,   
                    day9    LIKE hrcp_file.hrcp09,   
                    day10   LIKE hrcp_file.hrcp09,   
                    day11   LIKE hrcp_file.hrcp09,   
                    day12   LIKE hrcp_file.hrcp09,   
                    day13   LIKE hrcp_file.hrcp09,   
                    day14   LIKE hrcp_file.hrcp09,   
                    day15   LIKE hrcp_file.hrcp09,   
                    day16   LIKE hrcp_file.hrcp09,   
                    day17   LIKE hrcp_file.hrcp09,   
                    day18   LIKE hrcp_file.hrcp09,   
                    day19   LIKE hrcp_file.hrcp09,   
                    day20   LIKE hrcp_file.hrcp09,   
                    day21   LIKE hrcp_file.hrcp09,   
                    day22   LIKE hrcp_file.hrcp09,   
                    day23   LIKE hrcp_file.hrcp09,   
                    day24   LIKE hrcp_file.hrcp09,   
                    day25   LIKE hrcp_file.hrcp09,   
                    day26   LIKE hrcp_file.hrcp09,   
                    day27   LIKE hrcp_file.hrcp09,   
                    day28   LIKE hrcp_file.hrcp09,   
                    day29   LIKE hrcp_file.hrcp09,   
                    day30   LIKE hrcp_file.hrcp09,   
                    day31   LIKE hrcp_file.hrcp09                  
                    END RECORD
    DEFINE         l_hratid  like hrat_file.hratid     
    DEFINE          l_cnt  LIKE type_file.num5    #FUN-A80097
    DEFINE          l_sd   LIKE type_file.chr1    #FUN-A80097 l_sd ='Y' 為single db
    DEFINE          l_img_blob     LIKE type_file.blob
    DEFINE         l_n,l_nu,l_a,l_b,i,l_xy,l_pb  LIKE type_file.num5
    DEFINE         l_wc STRING
    DEFINE         g_hrbl06,l_hrbl06 LIKE hrbl_file.hrbl06
    DEFINE l_day  LIKE hrcp_file.hrcp09 
    LET l_n=0
    CALL cl_del_data(l_table)        ### FUN-710071 ###
    
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?,
                         ?,?,?,?,?,
                         ?,?,?,?,?,
                         ?,?,?,?,?,
                         ?,?,?,?,?,
                         ?,?,?,?,?,
                         ?,?,?,?,?,
                         ?,?,?,?,?,
                         ?,?,?,?,?,
                         ?,?,?,?,?,
                         ?,?,?,?,?,
                         ?,?,?,?,?,?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF

 #   LOCATE l_img_blob IN MEMORY #blob初始化 #No.FUN-940042
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('hratuser', 'hratgrup')    
    SELECT hrbl07 - hrbl06,hrbl06 INTO  l_xy,l_hrbl06 FROM hrbl_file WHERE hrbl05 = g_hrbl05 AND hrbl04 = g_hrbl04
     LET l_sql =  " select hrat02,
                   hrat01,
                   hrao02,
                   hras04,
                   hrat25,
                   hrat77,
                   hrag07,
                   0,
                   sum(nvl(hrcp14, 0)),
                   sum(nvl(hrcp15, 0)),
                   sum(nvl(hrcp21, 0)),
                   sum(nvl(hrcp16, 0)),
                   sum(nvl(hrcp20, 0)),
                   sum(nvl(hrcp44, 0)),
                   sum(nvl(hrcp13, 0)),
                   sum(nvl(hrcp18, 0)),
                   sum(nvl(hrcp17, 0)),
                   sum(nvl(hrcp19, 0)),
                   sum(nvl(hrcp45, 0)),
                   sum(nvl(hrcp12, 0)),
                   sum(nvl(hrcp39, 0)),
                   0,
                   0,
                   sum(nvl(hrcp40, 0)),
                   sum(nvl(hrcp41, 0)),
                   sum(nvl(hrcp42, 0)),
                   sum(nvl(hrcp41, 0)) -  sum(nvl(hrcp39, 0))
                   ,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
              from hrcp_file, hrat_file, hrao_file, hras_file, hrag_file, hrbl_file ",
          "   where hratid = hrcp02  and " ,tm.wc CLIPPED,
          "     and hrat20 ='001'
               and hrat04 = hrao01
               and hrat20 = hrag06
               and hrag01 = '313'
               and hras01 = hrat05
               and hrcp03 between hrbl06 and hrbl07
             group by hrat02, hrat01, hrao02, hras04, hrat25, hrat77, hrag07 "
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql              
    PREPARE ghrr302_p1 FROM l_sql
    
    IF SQLCA.sqlcode != 0 THEN
        CALL cl_err( 'ghrr302_p1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
    END IF

    DECLARE ghrr302_curs1 CURSOR FOR ghrr302_p1
    LET l_nu=0
    FOREACH ghrr302_curs1 INTO sr.*        
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
       #未出勤天数
       LET sr.wcq=0
       SELECT  hrat25-hrbl06,hrbl07-hrat77 INTO l_a,l_b FROM hrbl_file 
       left join hrat_file on 1=1
       WHERE hrbl04=g_hrbl04 and hrbl05=g_hrbl05 and hrat01=sr.hrat01
       IF l_a>0 THEN #ben yue ru zhi 
        LET sr.qqj=0
        SELECT COUNT(*) INTO sr.wcq FROM hrbk_file
        left join hrbl_file ON hrbk03 BETWEEN hrbl06 AND hrbl07 
        left join hrat_file ON hrat01=sr.hrat01
         WHERE hrbk03 >=hrbl06 AND hrbk03 <=hrat25 AND hrbl04=g_hrbl04 and hrbl05=g_hrbl05 AND hrbk05='001'
#       	LET sr.wcq=sr.wcq+l_a
       END IF
       IF l_b>0 THEN #ben yue li zhi 
        LET sr.qqj=0
        SELECT COUNT(*) INTO sr.wcq FROM hrbk_file
        left join hrbl_file ON hrbk03 BETWEEN hrbl06 AND hrbl07 
        left join hrat_file ON hrat01=sr.hrat01
         WHERE hrbk03 <=hrbl07 AND hrbk03 >=hrat77 AND hrbl04=g_hrbl04 and hrbl05=g_hrbl05 AND hrbk05='001'
#       	LET sr.wcq=sr.wcq+l_b 
       END IF 
       #全勤奖
       IF sr.bj +sr.sj+sr.kg + sr.wcq >0 THEN 
          LET sr.qqj = 0
       ELSE 
       	  SELECT COUNT(*) INTO l_pb FROM hrcp_file,hrat_file,hrbl_file 
       	  WHERE hrcp02 = hratid AND hrcp03 BETWEEN hrbl06 AND hrbl07
       	    AND hrat01 = sr.hrat01
       	    AND hrbl04 = g_hrbl04
       	    AND hrbl05 = g_hrbl05
       	    AND hrcp08 = '93'      	  
       	  IF l_pb = 0 THEN 
       	     LET sr.qqj = 100   
       	  END IF 
       END IF     
       #中夜班津贴
       SELECT COUNT(*) INTO sr.jt FROM hrcq_file,hrat_file,hrbl_file 
        WHERE hrcq05 = '012' AND  hratid = hrcq02 
          AND hrcq03 BETWEEN hrbl06 AND hrbl07 
          AND hrbl04 = g_hrbl04 AND hrbl05 = g_hrbl05                        
       #每日加班
       LET i = 0 
       #mark by zhanghui 2017/06/02 ----start
       #FOR i = 1 TO l_xy 
       #    SELECT  nvl(hrcp40,0) + nvl(hrcp41,0)  + nvl(hrcp42,0) INTO l_day FROM hrcp_file,hrat_file
       #     WHERE hrcp03 = l_hrbl06  + i 
       #      AND hrcp02 = hratid  AND hrat01 = sr.hrat01
       #    IF cl_NULL(l_day) THEN LET l_day = 0    END IF   
       #    IF i = 1 THEN LET sr.day2 = l_day END IF   
       #    IF i = 2 THEN LET sr.day3 = l_day END IF    
       #    IF i = 3 THEN LET sr.day4 = l_day END IF   
       #    IF i = 4 THEN LET sr.day5 = l_day END IF   
       #    IF i = 5 THEN LET sr.day6 = l_day END IF   
       #    IF i = 6 THEN LET sr.day7 = l_day END IF   
       #    IF i = 7 THEN LET sr.day8 = l_day END IF   
       #    IF i = 8 THEN LET sr.day9 = l_day END IF   
       #    IF i = 9 THEN LET sr.day10 = l_day END IF   
       #    IF i = 10 THEN LET sr.day11 = l_day END IF   
       #    IF i = 11 THEN LET sr.day12 = l_day END IF   
       #    IF i = 12 THEN LET sr.day13 = l_day END IF   
       #    IF i = 13 THEN LET sr.day14 = l_day END IF   
       #    IF i = 14 THEN LET sr.day15 = l_day END IF   
       #    IF i = 15 THEN LET sr.day16 = l_day END IF   
       #    IF i = 16 THEN LET sr.day17 = l_day END IF   
       #    IF i = 17 THEN LET sr.day18 = l_day END IF   
       #    IF i = 18 THEN LET sr.day19 = l_day END IF   
       #    IF i = 19 THEN LET sr.day20 = l_day END IF   
       #    IF i = 20 THEN LET sr.day21 = l_day END IF   
       #    IF i = 21 THEN LET sr.day22 = l_day END IF   
       #    IF i = 22 THEN LET sr.day23 = l_day END IF   
       #    IF i = 23 THEN LET sr.day24 = l_day END IF   
       #    IF i = 24 THEN LET sr.day25 = l_day END IF   
       #    IF i = 25 THEN LET sr.day26 = l_day END IF   
       #    IF i = 26 THEN LET sr.day27 = l_day END IF   
       #    IF i = 27 THEN LET sr.day28 = l_day END IF   
       #    IF i = 28 THEN LET sr.day29 = l_day END IF   
       #    IF i = 29 THEN LET sr.day30 = l_day END IF   
       #    IF i = 30 THEN LET sr.day31 = l_day END IF   
       #END FOR  
      #mark by zhanghui 2017/06/02 ------end 
        #add by zhanghui 2017/06/02 -----start
       LET l_sql =" SELECT nvl(hrcp09,0) + nvl(hrcp40,0) + nvl(hrcp41,0)  + nvl(hrcp42,0) FROM hrcp_file,hrat_file ",
                  "  WHERE hrcp03 = ? AND hrcp02 = hratid  AND hrat01 = '",sr.hrat01,"'"
       PREPARE day_pre FROM l_sql
       LET g_hrbl06=l_hrbl06+2
       EXECUTE day_pre USING g_hrbl06 INTO sr.day3  
       LET g_hrbl06=l_hrbl06+3
       EXECUTE day_pre USING g_hrbl06 INTO sr.day4  
       LET g_hrbl06=l_hrbl06+4
       EXECUTE day_pre USING g_hrbl06 INTO sr.day5
       LET g_hrbl06=l_hrbl06+5
       EXECUTE day_pre USING g_hrbl06 INTO sr.day6  
       LET g_hrbl06=l_hrbl06+6
       EXECUTE day_pre USING g_hrbl06 INTO sr.day7  
       LET g_hrbl06=l_hrbl06+7
       EXECUTE day_pre USING g_hrbl06 INTO sr.day8  
       LET g_hrbl06=l_hrbl06+8
       EXECUTE day_pre USING g_hrbl06 INTO sr.day9  
       LET g_hrbl06=l_hrbl06+9
       EXECUTE day_pre USING g_hrbl06 INTO sr.day10  
       LET g_hrbl06=l_hrbl06+10
       EXECUTE day_pre USING g_hrbl06 INTO sr.day11  
       LET g_hrbl06=l_hrbl06+11
       EXECUTE day_pre USING g_hrbl06 INTO sr.day12  
       LET g_hrbl06=l_hrbl06+12
       EXECUTE day_pre USING g_hrbl06 INTO sr.day13  
       LET g_hrbl06=l_hrbl06+13
       EXECUTE day_pre USING g_hrbl06 INTO sr.day14  
       LET g_hrbl06=l_hrbl06+14
       EXECUTE day_pre USING g_hrbl06 INTO sr.day15  
       LET g_hrbl06=l_hrbl06+15
       EXECUTE day_pre USING g_hrbl06 INTO sr.day16  
       LET g_hrbl06=l_hrbl06+16
       EXECUTE day_pre USING g_hrbl06 INTO sr.day17  
       LET g_hrbl06=l_hrbl06+17
       EXECUTE day_pre USING g_hrbl06 INTO sr.day18  
       LET g_hrbl06=l_hrbl06+18
       EXECUTE day_pre USING g_hrbl06 INTO sr.day19  
       LET g_hrbl06=l_hrbl06+19
       EXECUTE day_pre USING g_hrbl06 INTO sr.day20 
       LET g_hrbl06=l_hrbl06+20
       EXECUTE day_pre USING g_hrbl06 INTO sr.day21  
       LET g_hrbl06=l_hrbl06+21
       EXECUTE day_pre USING g_hrbl06 INTO sr.day22  
       LET g_hrbl06=l_hrbl06+22
       EXECUTE day_pre USING g_hrbl06 INTO sr.day23  
       LET g_hrbl06=l_hrbl06+23
       EXECUTE day_pre USING g_hrbl06 INTO sr.day24  
       LET g_hrbl06=l_hrbl06+24
       EXECUTE day_pre USING g_hrbl06 INTO sr.day25  
       LET g_hrbl06=l_hrbl06+25
       EXECUTE day_pre USING g_hrbl06 INTO sr.day26  
       LET g_hrbl06=l_hrbl06+26
       EXECUTE day_pre USING g_hrbl06 INTO sr.day27  
       LET g_hrbl06=l_hrbl06+27
       EXECUTE day_pre USING g_hrbl06 INTO sr.day28  
       LET g_hrbl06=l_hrbl06+28
       EXECUTE day_pre USING g_hrbl06 INTO sr.day29 
       LET g_hrbl06=l_hrbl06+29
       EXECUTE day_pre USING g_hrbl06 INTO sr.day30 
       LET g_hrbl06=l_hrbl06+30
       EXECUTE day_pre USING g_hrbl06 INTO sr.day31      
      #add by zhanghui 2017/06/02 -----edd
       SELECT nvl(hrcp40,0) + nvl(hrcp41,0)  + nvl(hrcp42,0) INTO sr.day1 FROM hrcp_file,hrat_file
        WHERE hrcp03 = l_hrbl06 
         AND hrcp02 = hratid  AND hrat01 = sr.hrat01
       IF cl_NULL(sr.day1) THEN LET sr.day1 = 0    END IF 
       LET l_nu=l_nu+1       
       EXECUTE insert_prep USING l_nu,sr.*,g_hrbl04,g_hrbl05
    END FOREACH
    
    LET g_str=''
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED ,l_table CLIPPED,' order by hrao02'

    CALL cl_prt_cs3("ghrr302","ghrr302",l_sql,"") 


END FUNCTION


