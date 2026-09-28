# Prog. Version..:
#
# Pattern name...: csfr325.4gl
# Descriptions...: 产品入库单打印
# Date & Author..: 16/08/04 By huanglf
#HFBG-16030001
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

DEFINE tm  RECORD                               
              wc      LIKE type_file.chr1000,      
              more    LIKE type_file.chr1          
              END RECORD  
 
DEFINE   g_cnt           LIKE type_file.num10      
DEFINE   g_i             LIKE type_file.num5       
DEFINE   g_msg           LIKE type_file.chr1000   
 
DEFINE   l_table         STRING
DEFINE   g_str           STRING
DEFINE   g_sql           STRING

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                      
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("csf")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  
  
   LET g_sql="tc_sna04.tc_sna_file.tc_sna04,",
             "gem02.gem_file.gem02,",
             "tc_sna01.tc_sna_file.tc_sna01,",
             "tc_sna02.tc_sna_file.tc_sna02,",
             "tc_snb05.tc_snb_file.tc_snb05,",
             
             "imd02.imd_file.imd02,",
             "tc_snb20.tc_snb_file.tc_snb20,",
             "tc_snb04.tc_snb_file.tc_snb04,",
             "ima02.ima_file.ima02,",
             "tc_snb07.tc_snb_file.tc_snb07,",

             "tc_snb08.tc_snb_file.tc_snb08,",
             "tc_snb09.tc_snb_file.tc_snb09,",
             "tc_snb12.tc_snb_file.tc_snb12,",
             "tc_snauser.tc_sna_file.tc_snauser,",
             "tc_snaoriu.tc_sna_file.tc_snaoriu,",

             "gen02.gen_file.gen02"

             
             
             

   LET  l_table = cl_prt_temptable('csfr325',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,  ?)"                     
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
   INITIALIZE tm.* TO NULL         
   LET g_pdate = ARG_VAL(1)       
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11) 
   
   IF cl_null(tm.wc)
      THEN CALL csfr325_tm(0,0)          
      ELSE
           CALL csfr325()                
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN


FUNCTION csfr325_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
DEFINE p_row,p_col    LIKE type_file.num5,        
       l_cmd        LIKE type_file.chr1000      
 
   LET p_row = 9 LET p_col = 8
 
   OPEN WINDOW csfr325_w AT p_row,p_col WITH FORM "csf/42f/csfr325"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
  
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1' 
 
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON tc_sna01,tc_sna02,tc_snb20,tc_snb11,tc_snauser
                              
     
         BEFORE CONSTRUCT
             CALL cl_qbe_init() 
 
       ON ACTION locale 
          CALL cl_show_fld_cont()                    
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION controlp
           CASE
              WHEN INFIELD(tc_sna01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_tc_sna"  #No.TQC-5B0095
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_sna01
                 NEXT FIELD tc_sna01
              WHEN INFIELD(tc_snb20)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "cq_tc_snb20"  #No.TQC-5B0095
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_snb20
                 NEXT FIELD tc_snb20
               WHEN INFIELD(tc_snb11)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "cq_tc_snb11"  #No.TQC-5B0095
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_snb11
                 NEXT FIELD tc_snb11
                WHEN INFIELD(tc_snauser)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "cq_tc_snauser"  #No.TQC-5B0095
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_snauser
                 NEXT FIELD tc_snauser
                OTHERWISE
                 EXIT CASE
           END CASE
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
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
      LET INT_FLAG = 0 CLOSE WINDOW csfr325_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
  #UI
   INPUT BY NAME tm.more  WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW csfr325_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='csfr325'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('csfr325','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc,'\\\"', "'")
         LET l_cmd = l_cmd CLIPPED,        
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                        #" '",tm.more CLIPPED,"'"  ,            #MOD-650024 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('csfr325',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW csfr325_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL csfr325()
   ERROR ""
END WHILE
   CLOSE WINDOW csfr325_w
END FUNCTION


FUNCTION csfr325()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
          l_sql     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(3000)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          l_zo041   LIKE zo_file.zo041,   #FUN-810029 add
          l_zo042   LIKE zo_file.zo042,
          l_zo05    LIKE zo_file.zo05,     #FUN-810029 add
          l_zo09    LIKE zo_file.zo09,     #FUN-810029 add
          sr        RECORD
                    tc_sna04    LIKE tc_sna_file.tc_sna04,    #部门编号
                    gem02    LIKE gem_file.gem02,    #部门名称
                    tc_sna01    LIKE tc_sna_file.tc_sna01,    #入库单号
                    tc_sna02    LIKE tc_sna_file.tc_sna02,    #入库日期
                    tc_snb05    LIKE tc_snb_file.tc_snb05,    #仓库编号 

                    imd02    LIKE imd_file.imd02,    #仓库名称
                    tc_snb20    LIKE tc_snb_file.tc_snb20,    #lot单号
                    tc_snb04    LIKE tc_snb_file.tc_snb04,    #物料编号
                    ima02    LIKE ima_file.ima02,    #物料名称
                    tc_snb07    LIKE tc_snb_file.tc_snb07,    #批号

                    tc_snb08    LIKE tc_snb_file.tc_snb08,    #单位
                    tc_snb09    LIKE tc_snb_file.tc_snb09,    #数量
                    tc_snb12    LIKE tc_snb_file.tc_snb12,    #备注
                    tc_snauser  LIKE tc_sna_file.tc_snauser,  #制单人
                    tc_snaoriu  LIKE tc_sna_file.tc_snaoriu,

                    gen02    LIKE gen_file.gen02
                    
        
            
                    END RECORD
   DEFINE l_cnt     LIKE type_file.num5            

   DEFINE l_price LIKE ogb_file.ogb13

   DEFINE l_img_blob     LIKE type_file.blob
   LOCATE l_img_blob IN MEMORY             
 

     CALL cl_del_data(l_table) 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='csfr325' 
     
     
     LET tm.wc = tm.wc CLIPPED 
     
LET l_sql="select tc_sna04,'',tc_sna01,tc_sna02,tc_snb06,'',tc_snb20,tc_snb04,ima02,tc_snb07,tc_snb08,tc_snb09,'',tc_snauser,tc_snaoriu,''",
           " from tc_snb_file left join ima_file on ima01 = tc_snb04,tc_sna_file ",
           " where ",tm.wc ,
           "   AND tc_sna01=tc_snb01 "
         #,  "   GROUP BY tc_sna04,tc_sna01,tc_sna02,tc_snb05,tc_snb20,tc_snb04,ima02,tc_snb07,tc_snb08,tc_snauser,tc_snaoriu"

     PREPARE csfr325_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM 
     END IF
     DECLARE csfr325_curs1 CURSOR FOR csfr325_prepare1
 
     FOREACH csfr325_curs1 INTO sr.*
     IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       
        SELECT ima02 INTO sr.ima02 FROM ima_file WHERE ima01 = sr.tc_snb04
        SELECT gem02 INTO sr.gem02 FROM gem_file WHERE gem01 = sr.tc_sna04
        SELECT ecd02 INTO sr.imd02 FROM ecd_file WHERE ecd01 = sr.tc_snb05
        SELECT gen02 INTO sr.gen02 FROM gen_file WHERE gen01 = sr.tc_snaoriu
    
           
       EXECUTE insert_prep USING sr.*
     END FOREACH
 
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'tc_sna01')
             RETURNING tm.wc
     END IF
     LET g_str = tm.wc

     CALL cl_prt_cs3('csfr325','csfr325',g_sql,g_str)

END FUNCTION



