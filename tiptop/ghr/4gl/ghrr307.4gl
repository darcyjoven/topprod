# Prog. Version..: '5.30.03-12.09.18(00010)'     #
#
# Pattern name...: ghrr307.4gl
# Descriptions...: 员工周考勤表
# Date & Author..: 17/07/05 by nixiang


DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc      STRING,                #TQC-630166    # Where condition
              bdate   LIKE   type_file.dat,           #No.FUN-680137 DATE
              edate   LIKE   type_file.dat            #No.FUN-680137 DATE
              --,hrat20  LIKE   hrat_file.hrat20        
            END RECORD
DEFINE    l_table     STRING,                      ### FUN-710071 ###
          g_sql       STRING                        ### FUN-710071 ###          
DEFINE    g_str       STRING
DEFINE    g_i         LIKE  type_file.num5           #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE    g_rec_b     LIKE  type_file.num10          #No.FUN-680137   INTEGER
DEFINE    m_plant     LIKE  hrat_file.hrat03           #No.FUN-A70084 
DEFINE    g_wc        LIKE  type_file.chr1000        #No.FUN-A70084

DEFINE 
        g_wc2           STRING,
        l_ac            LIKE type_file.num5,                
        l_cmd           LIKE type_file.chr1000      

DEFINE g_forupd_sql         STRING       
DEFINE g_before_input_done  LIKE type_file.num5        
DEFINE p_row,p_col          LIKE type_file.num5          
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


   
   LET g_sql =  "no.type_file.num5,  ",
                "hrat02.hrat_file.hrat02,",
                "hrat01.hrat_file.hrat01,", 
                "hrao02.hrao_file.hrao02,",
                "hras04.hras_file.hras04,",
                "hrat25.hrat_file.hrat25,",
                "hrat77.hrat_file.hrat77,",
                "hrag07.hrag_file.hrag07,",
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
                "jt.type_file.num5,  ",
                "prjb.hrcp_file.hrcp09,", 
                "jejb.hrcp_file.hrcp09,", 
                "jajb.hrcp_file.hrcp09,", 
 
                "day1.hrcp_file.hrcp09,",   
                "day2.hrcp_file.hrcp09,",   
                "day3.hrcp_file.hrcp09,",   
                "day4.hrcp_file.hrcp09,",   
                "day5.hrcp_file.hrcp09,",   
                "day6.hrcp_file.hrcp09,",   
                "day7.hrcp_file.hrcp09"

    LET l_table = cl_prt_temptable('ghrr307',g_sql) CLIPPED   # 產生Temp Table
    IF l_table = -1 THEN 
        EXIT PROGRAM 
    END IF                 
 
 
      INITIALIZE tm.* TO NULL                # Default condition

    IF cl_null(tm.wc) THEN
      CALL ghrr307_tm(0,0)               # Input print condition
    ELSE
      CALL ghrr307()                     # Read data and create out-file
    END IF
    

   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION ghrr307_tm(p_row,p_col)
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
   DEFINE l_hrat20     LIKE hrat_file.hrat20        
   LET p_row = 4 LET p_col = 10
   
   OPEN WINDOW ghrr307_w AT p_row,p_col WITH FORM "ghr/42f/ghrr307"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
       
   CALL cl_ui_init()
   
   LET tm.bdate = g_today
   LET tm.edate = g_today+7

   CALL cl_opmsg('p')
   WHILE TRUE
   
   CONSTRUCT BY NAME tm.wc ON hrat03,hrat04,hrat01,hrat20

      BEFORE CONSTRUCT
          CALL cl_qbe_init()
          
      CALL cl_set_comp_required("hrat20",TRUE)
      
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
        
      AFTER FIELD hrat20 
        LET l_hrat20 = GET_FLDBUF(hrat20)
        IF cl_null(l_hrat20) THEN 
           CALL cl_err("员工属性一栏必填","!",0)
           NEXT FIELD hrat20
        END IF 
   
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
        CLOSE WINDOW ghrr307_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
    END IF
               
    INPUT BY NAME tm.bdate, tm.edate WITHOUT DEFAULTS

      AFTER FIELD bdate
         IF cl_null(tm.edate) THEN 
             NEXT FIELD edate 
         ELSE 
             LET tm.edate=tm.bdate+7
         END IF
      AFTER FIELD edate
        IF cl_null(tm.edate) THEN 
            NEXT FIELD edate 
        END IF
        IF tm.bdate > tm.edate THEN 
            NEXT FIELD edate 
        END IF
      --AFTER FIELD hrat20
         --IF cl_null(tm.hrat20) THEN 
            --NEXT FIELD hrat20 
         --END IF
         
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
        CLOSE WINDOW ghrr307_w 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
    END IF
      
      CALL cl_wait()
      CALL ghrr307()
     
      END WHILE
   CLOSE WINDOW ghrr307_w
 END FUNCTION
 
FUNCTION ghrr307()
   DEFINE l_name    LIKE type_file.chr20,        
          l_sql      STRING,       #No.FUN-680137 VARCHAR(1000)
          l_sql1     STRING, 
          --l_rate    LIKE oea_file.oea24,  #No.MOD-640559 add
          --l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          --l_dbs     LIKE azp_file.azp03,  #No.FUN-680137 VARCHAR(22)
          --j         LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          --l_occ01   LIKE occ_file.occ01,
          --l_amt     LIKE occ_file.occ63,
          --g_hrao02  LIKE hrao_file.hrao02,
          
          sr        RECORD 
                    hrat02  LIKE hrat_file.hrat02,
                    hrat01  LIKE hrat_file.hrat01, 
                    hrao02  LIKE hrao_file.hrao02,
                    hras04  LIKE hras_file.hras04,
                    hrat25  LIKE hrat_file.hrat25,
                    
                    hrat77  LIKE hrat_file.hrat77,
                    hrag07  LIKE hrag_file.hrag07,
                    --wcq     LIKE type_file.num5,
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
                    
                    --qqj     LIKE type_file.num5,
                    jt      LIKE type_file.num5,
                    prjb    LIKE hrcp_file.hrcp09,
                    jejb    LIKE hrcp_file.hrcp09,
                    jajb    LIKE hrcp_file.hrcp09,
                    --sytx    LIKE hrcp_file.hrcp09,   
                    day1    LIKE hrcp_file.hrcp09,
                    
                    day2    LIKE hrcp_file.hrcp09,   
                    day3    LIKE hrcp_file.hrcp09,   
                    day4    LIKE hrcp_file.hrcp09,   
                    day5    LIKE hrcp_file.hrcp09,   
                    day6    LIKE hrcp_file.hrcp09,
                    
                    day7    LIKE hrcp_file.hrcp09   
                
                    END RECORD
    DEFINE         l_hratid  like hrat_file.hratid     
    DEFINE          l_cnt  LIKE type_file.num5    #FUN-A80097
    DEFINE          l_img_blob     LIKE type_file.blob
    DEFINE         l_n,l_no,l_a,l_b,i,l_pb  LIKE type_file.num5
    DEFINE         l_wc STRING
    DEFINE l_hrat20    LIKE hrat_file.hrat20 
    DEFINE l_hrcp03 LIKE hrcp_file.hrcp03
    LET l_n=0
    CALL cl_del_data(l_table)        ### FUN-710071 ###
    
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?,
                         ?,?,?,?,?,
                         ?,?,?,?,?,
                         ?,?,?,?,?,
                         ?,?,?,?,?,
                         ?,?,?,?,?,
                         ?,?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF

 #   LOCATE l_img_blob IN MEMORY #blob初始化 #No.FUN-940042
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('hratuser', 'hratgrup')    
     LET l_sql =  " select hrat02,
                   hrat01,
                   hrao02,
                   hras04,
                   hrat25,
                   hrat77,
                   hrag07,
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
                   sum(nvl(hrcp40, 0)),
                   sum(nvl(hrcp41, 0)),
                   sum(nvl(hrcp42, 0))
                   ,0,0,0,0,0,0,0
              from hrcp_file, hrat_file, hrao_file, hras_file, hrag_file ",
          "   where hratid = hrcp02  and " ,tm.wc CLIPPED,
          --"    and hrat20 = '",tm.hrat20,"' ",
          "    and hrat04 = hrao01
               and hrat20 = hrag06
               and hrag01 = '313'
               and hras01 = hrat05 ",
          "    and hrcp03 between '",tm.bdate,"' and '",tm.edate,"' ",
          "   group by hrat02, hrat01, hrao02, hras04, hrat25, hrat77, hrag07 "
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql              
    PREPARE ghrr307_p1 FROM l_sql
    
    IF SQLCA.sqlcode != 0 THEN
        CALL cl_err( 'ghrr307_p1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
    END IF

    DECLARE ghrr307_curs1 CURSOR FOR ghrr307_p1
    LET l_no=0
    FOREACH ghrr307_curs1 INTO sr.*        
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
       #未出勤天数
       --LET sr.wcq=0
       --SELECT  hrat25-hrbl06,hrbl07-hrat77 INTO l_a,l_b FROM hrbl_file 
       --left join hrat_file on 1=1
       --WHERE hrbl04=g_hrbl04 and hrbl05=g_hrbl05 and hrat01=sr.hrat01
       --IF l_a>0 THEN #ben yue ru zhi 
        --LET sr.qqj=0
        --SELECT COUNT(*) INTO sr.wcq FROM hrbk_file
        --left join hrbl_file ON hrbk03 BETWEEN hrbl06 AND hrbl07 
        --left join hrat_file ON hrat01=sr.hrat01
         --WHERE hrbk03 >=hrbl06 AND hrbk03 <=hrat25 AND hrbl04=g_hrbl04 and hrbl05=g_hrbl05 AND hrbk05='001'
#       	LET sr.wcq=sr.wcq+l_a
       --END IF
       --IF l_b>0 THEN #ben yue li zhi 
        --LET sr.qqj=0
        --SELECT COUNT(*) INTO sr.wcq FROM hrbk_file
        --left join hrbl_file ON hrbk03 BETWEEN hrbl06 AND hrbl07 
        --left join hrat_file ON hrat01=sr.hrat01
         --WHERE hrbk03 <=hrbl07 AND hrbk03 >=hrat77 AND hrbl04=g_hrbl04 and hrbl05=g_hrbl05 AND hrbk05='001'
#       	LET sr.wcq=sr.wcq+l_b 
       --END IF 
       #全勤奖
       --IF sr.bj +sr.sj+sr.kg + sr.wcq >0 THEN 
          --LET sr.qqj = 0
       --ELSE 
       	  --SELECT COUNT(*) INTO l_pb FROM hrcp_file,hrat_file,hrbl_file 
       	  --WHERE hrcp02 = hratid AND hrcp03 BETWEEN hrbl06 AND hrbl07
       	    --AND hrat01 = sr.hrat01
       	    --AND hrbl04 = g_hrbl04
       	    --AND hrbl05 = g_hrbl05
       	    --AND hrcp08 = '93'      	  
       	  --IF l_pb = 0 THEN 
       	     --LET sr.qqj = 100   
       	  --END IF 
       --END IF     
       #中夜班津贴
       SELECT COUNT(*) INTO sr.jt FROM hrcq_file,hrat_file 
        WHERE hrcq05 = '012' AND  hratid = hrcq02 AND hrcq02=sr.hrat01
          AND hrcq03 BETWEEN tm.bdate AND tm.edate                       
       #每日工作时数
       SELECT hrat20 INTO l_hrat20 FROM hrat_file WHERE hrat01=sr.hrat01
       IF l_hrat20='001' THEN 
          LET l_sql =" SELECT nvl(hrcp40,0) + nvl(hrcp41,0)  + nvl(hrcp42,0) FROM hrcp_file,hrat_file ",
                     "  WHERE hrcp03 = ? AND hrcp02 = hratid  AND hrat01 = '",sr.hrat01,"'"
       ELSE 
          LET l_sql =" SELECT nvl(hrcp09,0) + nvl(hrcp40,0) + nvl(hrcp41,0) + nvl(hrcp42,0) FROM hrcp_file,hrat_file ",
                     "  WHERE hrcp03 = ? AND hrcp02 = hratid  AND hrat01 = '",sr.hrat01,"'"
       END IF 
       PREPARE day_pre FROM l_sql
       LET l_hrcp03=tm.bdate
       EXECUTE day_pre USING l_hrcp03 INTO sr.day1
       LET l_hrcp03=tm.bdate+1
       EXECUTE day_pre USING l_hrcp03 INTO sr.day2
       LET l_hrcp03=tm.bdate+2
       EXECUTE day_pre USING l_hrcp03 INTO sr.day3  
       LET l_hrcp03=tm.bdate+3
       EXECUTE day_pre USING l_hrcp03 INTO sr.day4  
       LET l_hrcp03=tm.bdate+4
       EXECUTE day_pre USING l_hrcp03 INTO sr.day5
       LET l_hrcp03=tm.bdate+5
       EXECUTE day_pre USING l_hrcp03 INTO sr.day6  
       LET l_hrcp03=tm.bdate+6
       EXECUTE day_pre USING l_hrcp03 INTO sr.day7      
       --SELECT nvl(hrcp40,0) + nvl(hrcp41,0)  + nvl(hrcp42,0) INTO sr.day1 FROM hrcp_file,hrat_file
        --WHERE hrcp03 = l_hrbl06 
         --AND hrcp02 = hratid  AND hrat01 = sr.hrat01
       --IF cl_NULL(sr.day1) THEN LET sr.day1 = 0    END IF 
       LET l_no=l_no+1       
       EXECUTE insert_prep USING l_no,sr.*
    END FOREACH
    
    LET g_str=''
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED ,l_table CLIPPED,' order by hrao02'

    CALL cl_prt_cs3("ghrr307","ghrr307",l_sql,"") 


END FUNCTION


