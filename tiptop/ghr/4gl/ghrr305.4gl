# Prog. Version..: '5.30.03-12.09.18(00010)'     #
#
# Pattern name...: ghrr305.4gl
# Descriptions...: 人员名单
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


   
   LET g_sql =  "cr01.hrao_file.hrao02,",
                "cr02.hrao_file.hrao02,",
                "hrat02.hrat_file.hrat02,",
                "hrat01.hrat_file.hrat01,",
                "hrap06.hrap_file.hrap06,",
                "hrbl04.hrbl_file.hrbl04,",
                "hrbl05.hrbl_file.hrbl05"
                
 
    LET l_table = cl_prt_temptable('ghrr305',g_sql) CLIPPED   # 產生Temp Table
    IF l_table = -1 THEN 
        EXIT PROGRAM 
    END IF                 
 
 
      INITIALIZE tm.* TO NULL                # Default condition

    IF cl_null(tm.wc) THEN
      CALL ghrr305_tm(0,0)               # Input print condition
    ELSE
      CALL ghrr305()                     # Read data and create out-file
    END IF
    

   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION ghrr305_tm(p_row,p_col)
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
   
   OPEN WINDOW ghrr305_w AT p_row,p_col WITH FORM "ghr/42f/ghrr305"
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
        CLOSE WINDOW ghrr305_w
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
        CLOSE WINDOW ghrr305_w 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
    END IF
      
      CALL cl_wait()
      CALL ghrr305()
     
      END WHILE
   CLOSE WINDOW ghrr305_w
 END FUNCTION
 
FUNCTION ghrr305()
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
                    cr01    LIKE hrat_file.hrat02,
                    cr02    LIKE hrat_file.hrat02,
                    hrat02  LIKE hrat_file.hrat02,
                    hrat01  LIKE hrat_file.hrat01, 
                    hrap06  LIKE hrap_file.hrap06                  
                    END RECORD
    DEFINE         l_hratid  like hrat_file.hratid     
    DEFINE          l_cnt  LIKE type_file.num5    #FUN-A80097
    DEFINE          l_sd   LIKE type_file.chr1    #FUN-A80097 l_sd ='Y' 為single db
    DEFINE          l_img_blob     LIKE type_file.blob
    DEFINE         l_n,l_nu,l_a,l_b  LIKE type_file.num5
    DEFINE         l_wc STRING
    LET l_n=0
    CALL cl_del_data(l_table)        ### FUN-710071 ###
    
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?,
                         ?,?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF

 #   LOCATE l_img_blob IN MEMORY #blob初始化 #No.FUN-940042
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('hratuser', 'hratgrup')    
     LET l_sql = "select distinct b.hrao02,a.hrao02,hrat02,hrat01,hrap06,'','' from hrat_file
                 left join hrao_file a on hrat04=a.hrao01 
                 left join hrao_file b on a.hrao10=b.hrao01
                 left join hrap_file on hrap05=hrat05
                  where hrat19='2001' and  ",tm.wc CLIPPED,
                 "order by b.hrao02,a.hrao02,hrat01,hrat02,hrap06"
                  
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql              
    PREPARE ghrr305_p1 FROM l_sql
    
    IF SQLCA.sqlcode != 0 THEN
        CALL cl_err( 'ghrr305_p1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
    END IF

    DECLARE ghrr305_curs1 CURSOR FOR ghrr305_p1
    LET l_nu=0
    FOREACH ghrr305_curs1 INTO sr.*        
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF      
       EXECUTE insert_prep USING sr.*,g_hrbl04,g_hrbl05
    END FOREACH
    
    LET g_str=''
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED ,l_table CLIPPED

    CALL cl_prt_cs3("ghrr305","ghrr305",l_sql,"") 


END FUNCTION


