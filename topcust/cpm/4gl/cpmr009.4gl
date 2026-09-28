# Prog. Version..:
#
# Pattern name...: cpmr009.4gl
# Descriptions...: 委外申请单报表打印
# Date & Author..: 16/06/22 By huanglf
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
DEFINE   l_table1        STRING 
DEFINE   g_str           STRING
DEFINE   g_sql           STRING
DEFINE   g_sql1          STRING 

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
  
   LET g_sql="pmn01.pmn_file.pmn01,",
             "pmm04.pmm_file.pmm04,",
             "pmn78.pmn_file.pmn78,",
             "ecd02.ecd_file.ecd02,",
             "pmn02.pmn_file.pmn02,",

             "pmn18.pmn_file.pmn18,",
             "pmn32.pmn_file.pmn32,",
             "pmn41.pmn_file.pmn41,",
             "pmn04.pmn_file.pmn04,",
             "pmn041.pmn_file.pmn041,",

             "ima021.ima_file.ima021,",
             "ta_sgm01.sgm_file.ta_sgm01,",
             "ta_sgm02.sgm_file.ta_sgm02,",
             "pmn20.pmn_file.pmn20,",
            "pmnud07.pmn_file.pmnud07,",
             "pmn100.pmn_file.pmn100,",
             
             "tc_sfs01.tc_sfs_file.tc_sfs01,",
             "tc_sfs02.tc_sfs_file.tc_sfs02,",
             "tc_sfs03.tc_sfs_file.tc_sfs03,",
             "ima02_1.ima_file.ima02,",
             "ima021_1.ima_file.ima021,",

             "tc_sfs04.tc_sfs_file.tc_sfs04,",
             "tc_sfs05.tc_sfs_file.tc_sfs05,",
             "tc_sfs06.tc_sfs_file.tc_sfs06,",
             "tc_sfp06.tc_sfp_file.tc_sfp06,",
             "img10.img_file.img10,",
             
             "img10_1.img_file.img10,",
             "pmm09.pmm_file.pmm09,",
             "pmc081.pmc_file.pmc081,",
             "pmn07.pmn_file.pmn07,",
             "zo041.zo_file.zo041,",

             "zo05.zo_file.zo05,",
             "gen02.gen_file.gen02"


        
   LET  l_table = cl_prt_temptable('cpmr009',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   
 
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
      THEN CALL cpmr009_tm(0,0)          
      ELSE
           CALL cpmr009()                
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN


FUNCTION cpmr009_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
DEFINE p_row,p_col    LIKE type_file.num5,        
       l_cmd        LIKE type_file.chr1000      
 
   LET p_row = 9 LET p_col = 8
 
   OPEN WINDOW cpmr009_w AT p_row,p_col WITH FORM "cpm/42f/cpmr009"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
  
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1' 
 
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pmn01,pmm04
                              
     
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
              WHEN INFIELD(pmn01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pmm9"  #No.TQC-5B0095
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmn01
                 NEXT FIELD pmn01
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
      LET INT_FLAG = 0 CLOSE WINDOW cpmr009_w 
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
      LET INT_FLAG = 0 CLOSE WINDOW cpmr009_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='cpmr009'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('cpmr009','9031',1)
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
         CALL cl_cmdat('cpmr009',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW cpmr009_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL cpmr009()
   ERROR ""
END WHILE
   CLOSE WINDOW cpmr009_w
END FUNCTION


FUNCTION cpmr009()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
          l_sql     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(3000)
          l_sql1    LIKE type_file.chr1000,
          l_sql2    LIKE type_file.chr1000,    
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          l_oea03   LIKE oea_file.oea03, 
          l_sfb05   LIKE sfb_file.sfb05,
          l_imaud07 LIKE ima_file.imaud07,
          l_imaud10 LIKE ima_file.imaud10,
          sr        RECORD
                    pmn01    LIKE pmn_file.pmn01,     #委外单号
                    pmm04    LIKE pmm_file.pmm04,     #录入日期
                    pmn78    LIKE pmn_file.pmn78,     #工艺编号
                    ecd02    LIKE ecd_file.ecd02,     #作业说明
                    pmn02    LIKE pmn_file.pmn02,     #项次

                    pmn18    LIKE pmn_file.pmn18,     #Run Card编号
                    pmn32    LIKE pmn_file.pmn32,     #工艺序号
                    pmn41    LIKE pmn_file.pmn41,     #工单单号
                    pmn04    LIKE pmn_file.pmn04,     #产品料号
                    pmn041   LIKE pmn_file.pmn041,    #品名

                    ima021   LIKE ima_file.ima021,    #规格
                    ta_sgm01 LIKE sgm_file.ta_sgm01,  #生产说明
                    ta_sgm02 LIKE sgm_file.ta_sgm02,  #使用工具
                    pmn20    LIKE pmn_file.pmn20,     #数量
                    pmnud07    LIKE pmn_file.pmnud07,     #PNL数量
                    pmn100   LIKE pmn_file.pmn100,    #备注
                    
                    tc_sfs01    LIKE tc_sfs_file.tc_sfs01,     #工艺委外发料单单号
                    tc_sfs02    LIKE tc_sfs_file.tc_sfs02,     #项次
                    tc_sfs03    LIKE tc_sfs_file.tc_sfs03,     #料号
                    ima02_1     LIKE ima_file.ima02,           #品名
                    ima021_1    LIKE ima_file.ima021,          #规格

                    tc_sfs04    LIKE tc_sfs_file.tc_sfs04,     #应收数量
                    tc_sfs05    LIKE tc_sfs_file.tc_sfs05,     #实收数量
                    tc_sfs06    LIKE tc_sfs_file.tc_sfs06,     #发料单位
                    tc_sfp06    LIKE tc_sfp_file.tc_sfp06,     #工单单号
                    img10       LIKE img_file.img10,
                    
                    img10_1     LIKE img_file.img10,
                    pmm09       LIKE pmm_file.pmm09,
                    pmc081      LIKE pmc_file.pmc081,
                    pmn07       LIKE pmn_file.pmn07,
                    zo041       LIKE zo_file.zo041,

                    zo05        LIKE zo_file.zo05,
                    gen02       LIKE gen_file.gen02

                    END RECORD
  
   DEFINE   sr1        RECORD
                    pmn01    LIKE pmn_file.pmn01,     #委外单号
                    pmm04    LIKE pmm_file.pmm04,     #录入日期
                    pmn78    LIKE pmn_file.pmn78,     #工艺编号
                    ecd02    LIKE ecd_file.ecd02,     #作业说明
                    pmn02    LIKE pmn_file.pmn02,     #项次

                    pmn18    LIKE pmn_file.pmn18,     #Run Card编号
                    pmn32    LIKE pmn_file.pmn32,     #工艺序号
                    pmn41    LIKE pmn_file.pmn41,     #工单单号
                    pmn04    LIKE pmn_file.pmn04,     #产品料号
                    pmn041   LIKE pmn_file.pmn041,    #品名

                    ima021   LIKE ima_file.ima021,    #规格
                    ta_sgm01 LIKE sgm_file.ta_sgm01,  #生产说明
                    ta_sgm02 LIKE sgm_file.ta_sgm02,  #使用工具
                    pmn20    LIKE pmn_file.pmn20,     #数量
                    pmnud07    LIKE pmn_file.pmnud07,     #PNL数量
                    pmn100   LIKE pmn_file.pmn100,    #备注
                    
                    tc_sfs01    LIKE tc_sfs_file.tc_sfs01,     #工艺委外发料单单号
                    tc_sfs02    LIKE tc_sfs_file.tc_sfs02,     #项次
                    tc_sfs03    LIKE tc_sfs_file.tc_sfs03,     #料号
                    ima02_1     LIKE ima_file.ima02,           #品名
                    ima021_1    LIKE ima_file.ima021,          #规格

                    tc_sfs04    LIKE tc_sfs_file.tc_sfs04,     #应收数量
                    tc_sfs05    LIKE tc_sfs_file.tc_sfs05,     #实收数量
                    tc_sfs06    LIKE tc_sfs_file.tc_sfs06,     #发料单位
                    tc_sfp06    LIKE tc_sfp_file.tc_sfp06,     #工单单号
                    img10       LIKE img_file.img10,
                    
                    img10_1     LIKE img_file.img10,
                    pmm09       LIKE pmm_file.pmm09,
                    pmc081      LIKE pmc_file.pmc081,
                    pmn07       LIKE pmn_file.pmn07,
                    zo041       LIKE zo_file.zo041,

                    zo05        LIKE zo_file.zo05,
                    gen02       LIKE gen_file.gen02
                    

                    END RECORD
   DEFINE l_cnt     LIKE type_file.num5            
   DEFINE num1      LIKE type_file.num5
   DEFINE l_price LIKE ogb_file.ogb13
   DEFINE l_tc_sfp01  LIKE tc_sfp_file.tc_sfp01
   DEFINE l_img_blob     LIKE type_file.blob
   LOCATE l_img_blob IN MEMORY             
 

     CALL cl_del_data(l_table) 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='cpmr009' 
     
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"                     
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF   
    
     LET tm.wc = tm.wc CLIPPED 
     LET num1 = 0
     ### '','',sum(pmn20),sum(pmnud07),'','',0,'','','','','','','',0,0,pmm09,'',pmn07,'','',pmm12",
LET l_sql="select pmn01,pmm04,pmn78,'','','',pmn32,'',pmn04,pmn041,ima021,
              
                       '','',sum(pmn20),sum(pmnud07),'','',0,'','','','','','','',0,0,pmm09,'',pmn07,'','',pmm12",
           " from pmn_file,pmm_file,ima_file",
           " where ",tm.wc ,
           "   AND pmn04=ima01 AND pmn01 = pmm01 ",
           "    group by pmn01,pmn04,pmm04,pmn78,pmn32,pmn041,ima021,pmm09,pmn07,pmm12 "
    PREPARE cpmr009_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM 
     END IF
     DECLARE cpmr009_curs1 CURSOR FOR cpmr009_prepare1
  FOREACH cpmr009_curs1 INTO sr.*
     IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
     LET num1 = num1+100
     LET sr.pmn02 = num1
     LET sr.tc_sfs02 = num1
     
     
     SELECT gen02 INTO sr.gen02 FROM gen_file WHERE gen01=sr.gen02
     SELECT pmn18 INTO sr.pmn18 FROM pmn_file WHERE pmn01 = sr.pmn01 AND pmn04 = sr.pmn04
     SELECT ecd02 INTO sr.ecd02 FROM ecd_file WHERE ecd01 = sr.pmn78  
     SELECT ta_sgm01,ta_sgm02 INTO sr.ta_sgm01,sr.ta_sgm02 FROM sgm_file WHERE sgm01 = sr.pmn18 AND sgm04 = sr.pmn78
     SELECT img10 INTO sr.img10 FROM img_file WHERE img01 = sr.pmn04 AND img02 = sr.pmm09
     SELECT pmc081 INTO sr.pmc081 FROM pmc_file WHERE pmc01 = sr.pmm09
     SELECT  zo041,zo05 INTO sr.zo041,sr.zo05  FROM zo_file WHERE zo01 = g_rlang
     SELECT imaud07,imaud10 INTO l_imaud07,l_imaud10 FROM ima_file WHERE ima01=sr.pmn04    
     LET sr.ta_sgm01 = sr.ta_sgm01 CLIPPED,"|尺寸:",l_imaud07 CLIPPED,"|排版量:",l_imaud10
     IF cl_null(sr.pmnud07)  then   let sr.pmnud07=sr.pmn20/l_imaud10 
        update pmn_file set pmnud07=sr.pmnud07  where pmn01=sr.pmn01 and pmn02=sr.pmn02 
    END  IF 

     EXECUTE insert_prep USING sr.* 

     
 LET l_sql1=" select '','','','','','','','','','','','','',0,'','',
                     tc_sfs01,tc_sfs02,tc_sfs03,ima02,ima021,tc_sfs04,tc_sfs05,tc_sfs06,'',0,0,'','','','','',''",
           " from tc_sfs_file,ima_file,tc_sfp_file ",
           " where tc_sfs03 = ima01 and tc_sfs01 = tc_sfp01 and tc_sfp03 = '",sr.pmn01,"'"," and tc_sfp08 = '",sr.pmn04,"'" 
     PREPARE cpmr009_prepare2 FROM l_sql1
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM 
     END IF
     DECLARE cpmr009_curs2 CURSOR FOR cpmr009_prepare2
 
     FOREACH cpmr009_curs2 INTO sr1.*
     LET sr1.pmn01 = sr.pmn01
     LET sr1.tc_sfp06 = sr.pmn01
     LET sr1.tc_sfs02 = sr1.tc_sfs02+ sr.pmn02
     LET sr1.pmm04 =sr.pmm04
     SELECT ecd02 INTO sr1.ecd02 FROM ecd_file WHERE ecd01 = sr.pmn78  
     SELECT ta_sgm01,ta_sgm02 INTO sr1.ta_sgm01,sr.ta_sgm02 FROM sgm_file WHERE sgm01 = sr.pmn18 AND sgm03 = sr.pmn32
     SELECT img10 INTO sr1.img10 FROM img_file WHERE img01 = sr.pmn04 AND img02 = sr.pmm09
     SELECT pmc081 INTO sr1.pmc081 FROM pmc_file WHERE pmc01 = sr.pmm09
     SELECT img10 INTO sr1.img10_1 FROM img_file WHERE img01 = sr.tc_sfs03 AND img02 = sr.pmm09
     SELECT  zo041,zo05 INTO sr1.zo041,sr1.zo05  FROM zo_file WHERE zo01 = g_rlang    
     EXECUTE insert_prep USING sr1.*
     END FOREACH 
   
  END FOREACH
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," order by tc_sfs02"
     --LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
                 --"SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,',pmn01,pmm04')
             RETURNING tm.wc
     END IF
     LET g_str = tm.wc

     CALL cl_prt_cs3('cpmr009','cpmr009',g_sql,g_str)

END FUNCTION
