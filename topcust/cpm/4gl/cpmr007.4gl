# Prog. Version..:
#
# Pattern name...: cpmr007.4gl
# Descriptions...: 委外申请单报表打印
# Date & Author..: 17/08/10 ly
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
 
   IF (NOT cl_setup("CPM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  
  
   LET g_sql="tc_pmm01.tc_pmm_file.tc_pmm01,",
             "tc_pmm02.tc_pmm_file.tc_pmm02,",
             "tc_pmm11.tc_pmm_file.tc_pmm11,",
             "tc_pmm06.tc_pmm_file.tc_pmm06,",
             "sgm45.sgm_file.sgm45,",

             "tc_pmmud10.tc_pmm_file.tc_pmmud10,",
             "tc_pmm03.tc_pmm_file.tc_pmm03,",
             "tc_pmm08.tc_pmm_file.tc_pmm08,",
             "tc_pmm04.tc_pmm_file.tc_pmm04,",
             "tc_pmm05.tc_pmm_file.tc_pmm05,",

             "ima02.ima_file.ima02,",
             "ima021.ima_file.ima021,",
             "tc_pmm07.tc_pmm_file.tc_pmm07,",
             "pmc03.pmc_file.pmc03,",
             "tc_pmm09.tc_pmm_file.tc_pmm09,",

             "tc_pmm10.tc_pmm_file.tc_pmm10,",
             "tc_pmmacti.tc_pmm_file.tc_pmmacti,",
             "tc_pmmud02.tc_pmm_file.tc_pmmud02,",
             "tc_pmmud03.tc_pmm_file.tc_pmmud03,",
             "tc_pmmud07.tc_pmm_file.tc_pmmud07"

   LET  l_table = cl_prt_temptable('cpmr007',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"                     
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
      THEN CALL cpmr007_tm(0,0)          
      ELSE
           CALL cpmr007()                
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN


FUNCTION cpmr007_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
DEFINE p_row,p_col    LIKE type_file.num5,        
       l_cmd        LIKE type_file.chr1000      
 
   LET p_row = 9 LET p_col = 8
 
   OPEN WINDOW cpmr007_w AT p_row,p_col WITH FORM "cpm/42f/cpmr006"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
  
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1' 
 
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON tc_pmm01,tc_pmm02
                              
     
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
              WHEN INFIELD(tc_pmm01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "cq_tc_pmm01"  #No.TQC-5B0095
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_pmm01
                 NEXT FIELD tc_pmm01
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
      LET INT_FLAG = 0 CLOSE WINDOW cpmr007_w 
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
      LET INT_FLAG = 0 CLOSE WINDOW cpmr007_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='cpmr007'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('cpmr007','9031',1)
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
         CALL cl_cmdat('cpmr007',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW cpmr007_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL cpmr007()
   ERROR ""
END WHILE
   CLOSE WINDOW cpmr007_w
END FUNCTION


FUNCTION cpmr007()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
          l_sql     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(3000)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          l_oea03   LIKE oea_file.oea03,
          l_imaud07  LIKE ima_file.imaud07,
          l_imaud10  LIKE ima_file.imaud10,
          l_sfb05   LIKE sfb_file.sfb05,
          sr        RECORD
                    tc_pmm01    LIKE tc_pmm_file.tc_pmm01,     #委外单号
                    tc_pmm02    LIKE tc_pmm_file.tc_pmm02,     #录入日期
                    tc_pmm11    LIKE tc_pmm_file.tc_pmm11,     #审核码
                    tc_pmm06    LIKE tc_pmm_file.tc_pmm06,     #工艺编号
                    sgm45       LIKE sgm_file.sgm45,           #作业名称

                    tc_pmmud10  LIKE tc_pmm_file.tc_pmmud10,   #项次
                    tc_pmm03    LIKE tc_pmm_file.tc_pmm03,     #Run Card编号
                    tc_pmm08    LIKE tc_pmm_file.tc_pmm08,     #工艺序号
                    tc_pmm04    LIKE tc_pmm_file.tc_pmm04,     #工单单号
                    tc_pmm05    LIKE tc_pmm_file.tc_pmm05,     #产品料号

                    ima02    LIKE ima_file.ima02,              #品名
                    ima021   LIKE ima_file.ima021,             #规格
                    tc_pmm07    LIKE tc_pmm_file.tc_pmm07,     #委外供应商
                    pmc03    LIKE pmc_file.pmc03,              #简称
                    tc_pmm09    LIKE tc_pmm_file.tc_pmm09,     #委外数量

                    tc_pmm10    LIKE tc_pmm_file.tc_pmm10,     #备注
                    tc_pmmacti  LIKE tc_pmm_file.tc_pmmacti,   #资料有效码
                    tc_pmmud02  LIKE tc_pmm_file.tc_pmmud02,   #生产说明
                    tc_pmmud03  LIKE tc_pmm_file.tc_pmmud03,    #使用工具
                    tc_pmmud07  LIKE tc_pmm_file.tc_pmmud07    #PNL
                    END RECORD
   DEFINE l_cnt     LIKE type_file.num5            

   DEFINE l_price LIKE ogb_file.ogb13

   DEFINE l_img_blob     LIKE type_file.blob
   LOCATE l_img_blob IN MEMORY             
 

     CALL cl_del_data(l_table) 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='cpmr007' 
 
     LET tm.wc = tm.wc CLIPPED 
    
LET l_sql="select tc_pmm01,tc_pmm02,tc_pmm11,tc_pmm06,'',tc_pmmud10,tc_pmm03,tc_pmm08,tc_pmm04,tc_pmm05,ima02,ima021,tc_pmm07,'',tc_pmm09,tc_pmm10,tc_pmmacti,tc_pmmud02,tc_pmmud03,tc_pmmud07",
           " from tc_pmm_file,ima_file ",
           " where ",tm.wc ,
           "   AND tc_pmm05=ima01 "
     PREPARE cpmr007_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM 
     END IF
     DECLARE cpmr007_curs1 CURSOR FOR cpmr007_prepare1
 
     FOREACH cpmr007_curs1 INTO sr.*
     IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
     SELECT pmc03 INTO sr.pmc03 FROM pmc_file WHERE pmc01 = sr.tc_pmm07
     SELECT sgm45 INTO sr.sgm45 FROM sgm_file WHERE sgm11 = sr.tc_pmm06

  #str---add by ly170919
     SELECT imaud07,imaud10 INTO l_imaud07,l_imaud10 FROM ima_file WHERE ima01 = sr.tc_pmm05
     LET sr.tc_pmmud02 = sr.tc_pmmud02 CLIPPED," 尺寸：",l_imaud07 CLIPPED," 排版数：",l_imaud10 CLIPPED
     #end---add by ly170909



     EXECUTE insert_prep USING sr.*
     END FOREACH
 
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,',tc_pmm01,tc_pmm02')
             RETURNING tm.wc
     END IF
     LET g_str = tm.wc

     CALL cl_prt_cs3('cpmr007','cpmr007',g_sql,g_str)

END FUNCTION
