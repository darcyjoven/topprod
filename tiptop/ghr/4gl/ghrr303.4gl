# Prog. Version..: '5.30.03-12.09.18(00010)'     #
#
# Pattern name...: ghrr303.4gl
# Descriptions...: 在离职人员统计表
# Date & Author..: 17/02/08 by nihaun


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


   
   LET g_sql =  "hrat20.hrat_file.hrat20,","hrag07.hrag_file.hrag07,",
                "r1.type_file.num5,","r16.type_file.num5,", 
                "r2.type_file.num5,","r17.type_file.num5,",
                "r3.type_file.num5,","r18.type_file.num5,",
                "r4.type_file.num5,","r19.type_file.num5,",
                "r5.type_file.num5,","r20.type_file.num5,",
                "r6.type_file.num5,","r21.type_file.num5,",
                "r7.type_file.num5,","r22.type_file.num5,",
                "r8.type_file.num5,","r23.type_file.num5,",
                "r9.type_file.num5,","r24.type_file.num5,",
                "r10.type_file.num5,","r25.type_file.num5,",
                "r11.type_file.num5,","r26.type_file.num5,",
                "r12.type_file.num5,","r27.type_file.num5,",
                "r13.type_file.num5,","r28.type_file.num5,",
                "r14.type_file.num5,","r29.type_file.num5,",
                "r15.type_file.num5,","r30.type_file.num5,",
                "r31.type_file.num5,","r_sum.type_file.num5,",
                "c1.type_file.num5,","c16.type_file.num5,", 
                "c2.type_file.num5,","c17.type_file.num5,",
                "c3.type_file.num5,","c18.type_file.num5,",
                "c4.type_file.num5,","c19.type_file.num5,",
                "c5.type_file.num5,","c20.type_file.num5,",
                "c6.type_file.num5,","c21.type_file.num5,",
                "c7.type_file.num5,","c22.type_file.num5,",
                "c8.type_file.num5,","c23.type_file.num5,",
                "c9.type_file.num5,","c24.type_file.num5,",
                "c10.type_file.num5,","c25.type_file.num5,",
                "c11.type_file.num5,","c26.type_file.num5,",
                "c12.type_file.num5,","c27.type_file.num5,",
                "c13.type_file.num5,","c28.type_file.num5,",
                "c14.type_file.num5,","c29.type_file.num5,",
                "c15.type_file.num5,","c30.type_file.num5,",
                "c31.type_file.num5,","c_sum.type_file.num5,",
                "z1.type_file.num5,","z16.type_file.num5,", 
                "z2.type_file.num5,","z17.type_file.num5,",
                "z3.type_file.num5,","z18.type_file.num5,",
                "z4.type_file.num5,","z19.type_file.num5,",
                "z5.type_file.num5,","z20.type_file.num5,",
                "z6.type_file.num5,","z21.type_file.num5,",
                "z7.type_file.num5,","z22.type_file.num5,",
                "z8.type_file.num5,","z23.type_file.num5,",
                "z9.type_file.num5,","z24.type_file.num5,",
                "z10.type_file.num5,","z25.type_file.num5,",
                "z11.type_file.num5,","z26.type_file.num5,",
                "z12.type_file.num5,","z27.type_file.num5,",
                "z13.type_file.num5,","z28.type_file.num5,",
                "z14.type_file.num5,","z29.type_file.num5,",
                "z15.type_file.num5,","z30.type_file.num5,",
                "z31.type_file.num5,",
                "hrbl04.hrbl_file.hrbl04,",
                "hrbl05.hrbl_file.hrbl05"
                
 
    LET l_table = cl_prt_temptable('ghrr303',g_sql) CLIPPED   # 產生Temp Table
    IF l_table = -1 THEN 
        EXIT PROGRAM 
    END IF                 
 

    CALL ghrr303_tm(0,0)               # Input print condition

    

   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION ghrr303_tm(p_row,p_col)
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
   
   OPEN WINDOW ghrr303_w AT p_row,p_col WITH FORM "ghr/42f/ghrr303"
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
        IF cl_null(g_hrbl05) THEN 
           CALL cl_err('月不可为空','!',0)
           NEXT FIELD hrbl05
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
        CLOSE WINDOW ghrr303_w
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
        CLOSE WINDOW ghrr303_w 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
    END IF
      
      CALL cl_wait()
      CALL ghrr303()
     
      END WHILE
   CLOSE WINDOW ghrr303_w
 END FUNCTION
 
FUNCTION ghrr303()
   DEFINE l_name    LIKE type_file.chr20,           # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
          l_sql      STRING,       #No.FUN-680137 VARCHAR(1000)
          l_sql1     STRING, 
          l_rate    LIKE oea_file.oea24,  #No.MOD-640559 add
          l_a05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          j         LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_occ01   LIKE occ_file.occ01,
          l_amt     LIKE occ_file.occ63,
          g_hrao02  LIKE hrao_file.hrao02,
          
          sr        RECORD 
                    z1      LIKE type_file.num5,
                    z2      LIKE type_file.num5,
                    z3      LIKE type_file.num5,
                    z4      LIKE type_file.num5,
                    z5      LIKE type_file.num5,
                    z6      LIKE type_file.num5,
                    z7      LIKE type_file.num5,
                    z8      LIKE type_file.num5,
                    z9      LIKE type_file.num5,
                    z10     LIKE type_file.num5,
                    z11     LIKE type_file.num5,
                    z12     LIKE type_file.num5,
                    z13     LIKE type_file.num5,
                    z14     LIKE type_file.num5,
                    z15     LIKE type_file.num5,
                    z16     LIKE type_file.num5,
                    z17     LIKE type_file.num5,
                    z18     LIKE type_file.num5,
                    z19     LIKE type_file.num5,
                    z20     LIKE type_file.num5,
                    z21     LIKE type_file.num5,
                    z22     LIKE type_file.num5,
                    z23     LIKE type_file.num5,
                    z24     LIKE type_file.num5,
                    z25     LIKE type_file.num5,
                    z26     LIKE type_file.num5,
                    z27     LIKE type_file.num5,
                    z28     LIKE type_file.num5,
                    z29     LIKE type_file.num5,
                    z30     LIKE type_file.num5,
                    z31     LIKE type_file.num5
                    END RECORD 
        DEFINE   cr   RECORD      
                    hrat20  LIKE hrat_file.hrat20,   
                    hrag07  LIKE hrag_file.hrag07,    
                    r1      LIKE type_file.num5,
                    r2      LIKE type_file.num5,
                    r3      LIKE type_file.num5,
                    r4      LIKE type_file.num5,
                    r5      LIKE type_file.num5,
                    r6      LIKE type_file.num5,
                    r7      LIKE type_file.num5,
                    r8      LIKE type_file.num5,
                    r9      LIKE type_file.num5,
                    r10     LIKE type_file.num5,
                    r11     LIKE type_file.num5,
                    r12     LIKE type_file.num5,
                    r13     LIKE type_file.num5,
                    r14     LIKE type_file.num5,
                    r15     LIKE type_file.num5,
                    r16     LIKE type_file.num5,
                    r17     LIKE type_file.num5,
                    r18     LIKE type_file.num5,
                    r19     LIKE type_file.num5,
                    r20     LIKE type_file.num5,
                    r21     LIKE type_file.num5,
                    r22     LIKE type_file.num5,
                    r23     LIKE type_file.num5,
                    r24     LIKE type_file.num5,
                    r25     LIKE type_file.num5,
                    r26     LIKE type_file.num5,
                    r27     LIKE type_file.num5,
                    r28     LIKE type_file.num5,
                    r29     LIKE type_file.num5,
                    r30     LIKE type_file.num5,
                    r31     LIKE type_file.num5,
                    r_sum   LIKE type_file.num5,
                    c1      LIKE type_file.num5,
                    c2      LIKE type_file.num5,
                    c3      LIKE type_file.num5,
                    c4      LIKE type_file.num5,
                    c5      LIKE type_file.num5,
                    c6      LIKE type_file.num5,
                    c7      LIKE type_file.num5,
                    c8      LIKE type_file.num5,
                    c9      LIKE type_file.num5,
                    c10     LIKE type_file.num5,
                    c11     LIKE type_file.num5,
                    c12     LIKE type_file.num5,
                    c13     LIKE type_file.num5,
                    c14     LIKE type_file.num5,
                    c15     LIKE type_file.num5,
                    c16     LIKE type_file.num5,
                    c17     LIKE type_file.num5,
                    c18     LIKE type_file.num5,
                    c19     LIKE type_file.num5,
                    c20     LIKE type_file.num5,
                    c21     LIKE type_file.num5,
                    c22     LIKE type_file.num5,
                    c23     LIKE type_file.num5,
                    c24     LIKE type_file.num5,
                    c25     LIKE type_file.num5,
                    c26     LIKE type_file.num5,
                    c27     LIKE type_file.num5,
                    c28     LIKE type_file.num5,
                    c29     LIKE type_file.num5,
                    c30     LIKE type_file.num5,
                    c31     LIKE type_file.num5,
                    c_sum   LIKE type_file.num5                 
                    END RECORD
    DEFINE         l_hratid  like hrat_file.hratid     
    DEFINE          l_cnt  LIKE type_file.num5    #FUN-A80097
    DEFINE          l_sd   LIKE type_file.chr1    #FUN-A80097 l_sd ='Y' 為single db
    DEFINE          l_img_blob     LIKE type_file.blob
    DEFINE         l_n,l_nu,l_a,l_b  LIKE type_file.num5
    DEFINE         l_wc,l_dat STRING
    DEFINE         l_hrat20  LIKE hrat_file.hrat20
    
    LET l_n=0
    CALL cl_del_data(l_table)        ### FUN-710071 ###
    
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?,?,?,?,?,?,
                         ?,?,?,?,?,?,?,?,?,?,
                         ?,?,?,?,?,?,?,?,?,?,
                         ?,?,?,?,?,?,?,?,?,?,
                         ?,?,?,?,?,?,?,?,?,?,
                         ?,?,?,?,?,?,?,?,?,?,
                         ?,?,?,?,?,?,?,?,?,?,
                         ?,?,?,?,?,?,?,?,?,?,
                         ?,?,?,?,?,?,?,?,?,?,
                         ?,?,?,?,?,?,?,?,?
                         )"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF

 #   LOCATE l_img_blob IN MEMORY #blob初始化 #No.FUN-940042
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('hratuser', 'hratgrup')   
     LET l_dat=g_hrbl04,g_hrbl05 
     LET l_dat=cl_replace_str(l_dat," ","") 
     LET l_sql = "
     select hrat20,hrag07,
            sum(case when year(hrat25)='",g_hrbl04,"' and month(hrat25)='",g_hrbl05,"' and day(hrat25)=1 then 1 else 0 end) r1,
            sum(case when year(hrat25)='",g_hrbl04,"' and month(hrat25)='",g_hrbl05,"' and day(hrat25)=2 then 1 else 0 end) r2,
            sum(case when year(hrat25)='",g_hrbl04,"' and month(hrat25)='",g_hrbl05,"' and day(hrat25)=3 then 1 else 0 end) r3,
            sum(case when year(hrat25)='",g_hrbl04,"' and month(hrat25)='",g_hrbl05,"' and day(hrat25)=4 then 1 else 0 end) r4,
            sum(case when year(hrat25)='",g_hrbl04,"' and month(hrat25)='",g_hrbl05,"' and day(hrat25)=5 then 1 else 0 end) r5,
            sum(case when year(hrat25)='",g_hrbl04,"' and month(hrat25)='",g_hrbl05,"' and day(hrat25)=6 then 1 else 0 end) r6,
            sum(case when year(hrat25)='",g_hrbl04,"' and month(hrat25)='",g_hrbl05,"' and day(hrat25)=7 then 1 else 0 end) r7,
            sum(case when year(hrat25)='",g_hrbl04,"' and month(hrat25)='",g_hrbl05,"' and day(hrat25)=8 then 1 else 0 end) r8,
            sum(case when year(hrat25)='",g_hrbl04,"' and month(hrat25)='",g_hrbl05,"' and day(hrat25)=9 then 1 else 0 end) r9,
            sum(case when year(hrat25)='",g_hrbl04,"' and month(hrat25)='",g_hrbl05,"' and day(hrat25)=10 then 1 else 0 end) r10,
            sum(case when year(hrat25)='",g_hrbl04,"' and month(hrat25)='",g_hrbl05,"' and day(hrat25)=11 then 1 else 0 end) r11,
            sum(case when year(hrat25)='",g_hrbl04,"' and month(hrat25)='",g_hrbl05,"' and day(hrat25)=12 then 1 else 0 end) r12,
            sum(case when year(hrat25)='",g_hrbl04,"' and month(hrat25)='",g_hrbl05,"' and day(hrat25)=13 then 1 else 0 end) r13,
            sum(case when year(hrat25)='",g_hrbl04,"' and month(hrat25)='",g_hrbl05,"' and day(hrat25)=14 then 1 else 0 end) r14,
            sum(case when year(hrat25)='",g_hrbl04,"' and month(hrat25)='",g_hrbl05,"' and day(hrat25)=15 then 1 else 0 end) r15,
            sum(case when year(hrat25)='",g_hrbl04,"' and month(hrat25)='",g_hrbl05,"' and day(hrat25)=16 then 1 else 0 end) r16,
            sum(case when year(hrat25)='",g_hrbl04,"' and month(hrat25)='",g_hrbl05,"' and day(hrat25)=17 then 1 else 0 end) r17,
            sum(case when year(hrat25)='",g_hrbl04,"' and month(hrat25)='",g_hrbl05,"' and day(hrat25)=18 then 1 else 0 end) r18,
            sum(case when year(hrat25)='",g_hrbl04,"' and month(hrat25)='",g_hrbl05,"' and day(hrat25)=19 then 1 else 0 end) r19,
            sum(case when year(hrat25)='",g_hrbl04,"' and month(hrat25)='",g_hrbl05,"' and day(hrat25)=20 then 1 else 0 end) r20,
            sum(case when year(hrat25)='",g_hrbl04,"' and month(hrat25)='",g_hrbl05,"' and day(hrat25)=21 then 1 else 0 end) r21,
            sum(case when year(hrat25)='",g_hrbl04,"' and month(hrat25)='",g_hrbl05,"' and day(hrat25)=22 then 1 else 0 end) r22,
            sum(case when year(hrat25)='",g_hrbl04,"' and month(hrat25)='",g_hrbl05,"' and day(hrat25)=23 then 1 else 0 end) r23,
            sum(case when year(hrat25)='",g_hrbl04,"' and month(hrat25)='",g_hrbl05,"' and day(hrat25)=24 then 1 else 0 end) r24,
            sum(case when year(hrat25)='",g_hrbl04,"' and month(hrat25)='",g_hrbl05,"' and day(hrat25)=25 then 1 else 0 end) r25,
            sum(case when year(hrat25)='",g_hrbl04,"' and month(hrat25)='",g_hrbl05,"' and day(hrat25)=26 then 1 else 0 end) r26,
            sum(case when year(hrat25)='",g_hrbl04,"' and month(hrat25)='",g_hrbl05,"' and day(hrat25)=27 then 1 else 0 end) r27,
            sum(case when year(hrat25)='",g_hrbl04,"' and month(hrat25)='",g_hrbl05,"' and day(hrat25)=28 then 1 else 0 end) r28,
            sum(case when year(hrat25)='",g_hrbl04,"' and month(hrat25)='",g_hrbl05,"' and day(hrat25)=29 then 1 else 0 end) r29,
            sum(case when year(hrat25)='",g_hrbl04,"' and month(hrat25)='",g_hrbl05,"' and day(hrat25)=30 then 1 else 0 end) r30,
            sum(case when year(hrat25)='",g_hrbl04,"' and month(hrat25)='",g_hrbl05,"' and day(hrat25)=31 then 1 else 0 end) r31,
            sum(case when year(hrat25)='",g_hrbl04,"' and month(hrat25)='",g_hrbl05,"' then 1 else 0 end) r_sum,
            sum(case when year(hrat77)='",g_hrbl04,"' and month(hrat77)='",g_hrbl05,"' and day(hrat77)=1 then 1 else 0 end) c1,
            sum(case when year(hrat77)='",g_hrbl04,"' and month(hrat77)='",g_hrbl05,"' and day(hrat77)=2 then 1 else 0 end) c2,
            sum(case when year(hrat77)='",g_hrbl04,"' and month(hrat77)='",g_hrbl05,"' and day(hrat77)=3 then 1 else 0 end) c3,
            sum(case when year(hrat77)='",g_hrbl04,"' and month(hrat77)='",g_hrbl05,"' and day(hrat77)=4 then 1 else 0 end) c4,
            sum(case when year(hrat77)='",g_hrbl04,"' and month(hrat77)='",g_hrbl05,"' and day(hrat77)=5 then 1 else 0 end) c5,
            sum(case when year(hrat77)='",g_hrbl04,"' and month(hrat77)='",g_hrbl05,"' and day(hrat77)=6 then 1 else 0 end) c6,
            sum(case when year(hrat77)='",g_hrbl04,"' and month(hrat77)='",g_hrbl05,"' and day(hrat77)=7 then 1 else 0 end) c7,
            sum(case when year(hrat77)='",g_hrbl04,"' and month(hrat77)='",g_hrbl05,"' and day(hrat77)=8 then 1 else 0 end) c8,
            sum(case when year(hrat77)='",g_hrbl04,"' and month(hrat77)='",g_hrbl05,"' and day(hrat77)=9 then 1 else 0 end) c9,
            sum(case when year(hrat77)='",g_hrbl04,"' and month(hrat77)='",g_hrbl05,"' and day(hrat77)=10 then 1 else 0 end) c10,
            sum(case when year(hrat77)='",g_hrbl04,"' and month(hrat77)='",g_hrbl05,"' and day(hrat77)=11 then 1 else 0 end) c11,
            sum(case when year(hrat77)='",g_hrbl04,"' and month(hrat77)='",g_hrbl05,"' and day(hrat77)=12 then 1 else 0 end) c12,
            sum(case when year(hrat77)='",g_hrbl04,"' and month(hrat77)='",g_hrbl05,"' and day(hrat77)=13 then 1 else 0 end) c13,
            sum(case when year(hrat77)='",g_hrbl04,"' and month(hrat77)='",g_hrbl05,"' and day(hrat77)=14 then 1 else 0 end) c14,
            sum(case when year(hrat77)='",g_hrbl04,"' and month(hrat77)='",g_hrbl05,"' and day(hrat77)=15 then 1 else 0 end) c15,
            sum(case when year(hrat77)='",g_hrbl04,"' and month(hrat77)='",g_hrbl05,"' and day(hrat77)=16 then 1 else 0 end) c16,
            sum(case when year(hrat77)='",g_hrbl04,"' and month(hrat77)='",g_hrbl05,"' and day(hrat77)=17 then 1 else 0 end) c17,
            sum(case when year(hrat77)='",g_hrbl04,"' and month(hrat77)='",g_hrbl05,"' and day(hrat77)=18 then 1 else 0 end) c18,
            sum(case when year(hrat77)='",g_hrbl04,"' and month(hrat77)='",g_hrbl05,"' and day(hrat77)=19 then 1 else 0 end) c19,
            sum(case when year(hrat77)='",g_hrbl04,"' and month(hrat77)='",g_hrbl05,"' and day(hrat77)=20 then 1 else 0 end) c20,
            sum(case when year(hrat77)='",g_hrbl04,"' and month(hrat77)='",g_hrbl05,"' and day(hrat77)=21 then 1 else 0 end) c21,
            sum(case when year(hrat77)='",g_hrbl04,"' and month(hrat77)='",g_hrbl05,"' and day(hrat77)=22 then 1 else 0 end) c22,
            sum(case when year(hrat77)='",g_hrbl04,"' and month(hrat77)='",g_hrbl05,"' and day(hrat77)=23 then 1 else 0 end) c23,
            sum(case when year(hrat77)='",g_hrbl04,"' and month(hrat77)='",g_hrbl05,"' and day(hrat77)=24 then 1 else 0 end) c24,
            sum(case when year(hrat77)='",g_hrbl04,"' and month(hrat77)='",g_hrbl05,"' and day(hrat77)=25 then 1 else 0 end) c25,
            sum(case when year(hrat77)='",g_hrbl04,"' and month(hrat77)='",g_hrbl05,"' and day(hrat77)=26 then 1 else 0 end) c26,
            sum(case when year(hrat77)='",g_hrbl04,"' and month(hrat77)='",g_hrbl05,"' and day(hrat77)=27 then 1 else 0 end) c27,
            sum(case when year(hrat77)='",g_hrbl04,"' and month(hrat77)='",g_hrbl05,"' and day(hrat77)=28 then 1 else 0 end) c28,
            sum(case when year(hrat77)='",g_hrbl04,"' and month(hrat77)='",g_hrbl05,"' and day(hrat77)=29 then 1 else 0 end) c29,
            sum(case when year(hrat77)='",g_hrbl04,"' and month(hrat77)='",g_hrbl05,"' and day(hrat77)=30 then 1 else 0 end) c30,
            sum(case when year(hrat77)='",g_hrbl04,"' and month(hrat77)='",g_hrbl05,"' and day(hrat77)=31 then 1 else 0 end) c31,
            sum(case when year(hrat77)='",g_hrbl04,"' and month(hrat77)='",g_hrbl05,"' then 1 else 0 end) c_sum
            from hrat_file 
            left join hrag_file on hrag01='313' and hrag06=hrat20
            group by hrat20,hrag07            "
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql              
    PREPARE ghrr303_p1 FROM l_sql
    
    IF SQLCA.sqlcode != 0 THEN
        CALL cl_err( 'ghrr303_p1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
    END IF

    DECLARE ghrr303_curs1 CURSOR FOR ghrr303_p1
    LET l_nu=0
    FOREACH ghrr303_curs1 INTO cr.*        
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
           LET l_sql="
           select 
           sum(case when to_date('",l_dat,'01',"','yyyymmdd') between hrat25 and hrat77 then 1 else 0 end) z1 ,
           SUM(case when to_date('",l_dat,'02',"','yyyymmdd') between hrat25 and hrat77 then 1 else 0 end) z2 ,
           sum(case when to_date('",l_dat,'03',"','yyyymmdd') between hrat25 and hrat77 then 1 else 0 end) z3 ,
           sum(case when to_date('",l_dat,'04',"','yyyymmdd') between hrat25 and hrat77 then 1 else 0 end) z4 ,
           sum(case when to_date('",l_dat,'05',"','yyyymmdd') between hrat25 and hrat77 then 1 else 0 end) z5 ,
           sum(case when to_date('",l_dat,'06',"','yyyymmdd') between hrat25 and hrat77 then 1 else 0 end) z6 ,
           sum(case when to_date('",l_dat,'07',"','yyyymmdd') between hrat25 and hrat77 then 1 else 0 end) z7 ,
           sum(case when to_date('",l_dat,'08',"','yyyymmdd') between hrat25 and hrat77 then 1 else 0 end) z8 ,
           sum(case when to_date('",l_dat,'09',"','yyyymmdd') between hrat25 and hrat77 then 1 else 0 end) z9 ,
           sum(case when to_date('",l_dat,'10',"','yyyymmdd') between hrat25 and hrat77 then 1 else 0 end) z10,
           sum(case when to_date('",l_dat,'11',"','yyyymmdd') between hrat25 and hrat77 then 1 else 0 end) z11,
           sum(case when to_date('",l_dat,'12',"','yyyymmdd') between hrat25 and hrat77 then 1 else 0 end) z12,
           sum(case when to_date('",l_dat,'13',"','yyyymmdd') between hrat25 and hrat77 then 1 else 0 end) z13,
           sum(case when to_date('",l_dat,'14',"','yyyymmdd') between hrat25 and hrat77 then 1 else 0 end) z14,
           sum(case when to_date('",l_dat,'15',"','yyyymmdd') between hrat25 and hrat77 then 1 else 0 end) z15,
           sum(case when to_date('",l_dat,'16',"','yyyymmdd') between hrat25 and hrat77 then 1 else 0 end) z16,
           sum(case when to_date('",l_dat,'17',"','yyyymmdd') between hrat25 and hrat77 then 1 else 0 end) z17,
           sum(case when to_date('",l_dat,'18',"','yyyymmdd') between hrat25 and hrat77 then 1 else 0 end) z18,
           sum(case when to_date('",l_dat,'19',"','yyyymmdd') between hrat25 and hrat77 then 1 else 0 end) z19,
           sum(case when to_date('",l_dat,'20',"','yyyymmdd') between hrat25 and hrat77 then 1 else 0 end) z20,
           sum(case when to_date('",l_dat,'21',"','yyyymmdd') between hrat25 and hrat77 then 1 else 0 end) z21,
           sum(case when to_date('",l_dat,'22',"','yyyymmdd') between hrat25 and hrat77 then 1 else 0 end) z22,
           sum(case when to_date('",l_dat,'23',"','yyyymmdd') between hrat25 and hrat77 then 1 else 0 end) z23,
           sum(case when to_date('",l_dat,'24',"','yyyymmdd') between hrat25 and hrat77 then 1 else 0 end) z24,
           sum(case when to_date('",l_dat,'25',"','yyyymmdd') between hrat25 and hrat77 then 1 else 0 end) z25,
           sum(case when to_date('",l_dat,'26',"','yyyymmdd') between hrat25 and hrat77 then 1 else 0 end) z26,
           sum(case when to_date('",l_dat,'27',"','yyyymmdd') between hrat25 and hrat77 then 1 else 0 end) z27,
           sum(case when to_date('",l_dat,'28',"','yyyymmdd') between hrat25 and hrat77 then 1 else 0 end) z28,
           sum(case when to_date('",l_dat,'29',"','yyyymmdd') between hrat25 and hrat77 then 1 else 0 end) z29,
           sum(case when to_date('",l_dat,'30',"','yyyymmdd') between hrat25 and hrat77 then 1 else 0 end) z30,
           sum(case when to_date('",l_dat,'31',"','yyyymmdd') between hrat25 and hrat77 then 1 else 0 end) z31
           from hrat_file where hrat20='",cr.hrat20,"'    
           "
           PREPARE ghrr303_p2 FROM l_sql
    
           IF SQLCA.sqlcode != 0 THEN
               CALL cl_err( 'ghrr303_p2:',SQLCA.sqlcode,1)
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
               EXIT PROGRAM
           END IF
           
           DECLARE ghrr303_curs2 CURSOR FOR ghrr303_p2

           FOREACH ghrr303_curs2 INTO sr.*        
               IF STATUS THEN
                  CALL cl_err('foreach:',STATUS,1)
                  EXIT FOREACH
               END IF
           END FOREACH     

       EXECUTE insert_prep USING cr.*,sr.*,g_hrbl04,g_hrbl05
    END FOREACH
    
    LET g_str=''
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED ,l_table CLIPPED,' order by hrat20'

    CALL cl_prt_cs3("ghrr303","ghrr303",l_sql,"") 


END FUNCTION


