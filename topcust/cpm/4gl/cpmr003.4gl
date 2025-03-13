# Prog. Version..:
#
# Pattern name...: cpmr003.4gl
# Descriptions...: 送货单打印
# Date & Author..: 16/03/03 By yaolf
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
  
   LET g_sql="zo05.zo_file.zo05,",
             "zo041.zo_file.zo041,",
             "pmc081.pmc_file.pmc081,",
             "pmm09.pmm_file.pmm09,",
             "pmc11.pmc_file.pmc11,",
             
             "pmc10.pmc_file.pmc10,",
             "pmd03.pmd_file.pmd03,",
             "pmd02.pmd_file.pmd02,",
             "pmm01.pmm_file.pmm01,",
             "pmm16.pmm_file.pmm16,",

             "pmm04.pmm_file.pmm04,",
             "pmm20.pmm_file.pmm20,",
             "pma02.pma_file.pma02,",
             "pmn04.pmn_file.pmn04,",
             "pmn041.pmn_file.pmn041,",

             "ima021.ima_file.ima021,",
             "pmn20.pmn_file.pmn20,",
             "pmn07.pmn_file.pmn07,",
             "pmm43.pmm_file.pmm43,",
             "pmn31.pmn_file.pmn31,", #add ly180503
             "pmn31t.pmn_file.pmn31t,",
             "pmn88.pmn_file.pmn88,", #add ly180503
             "pmn88t.pmn_file.pmn88t,",
             "pmn34.pmn_file.pmn34,",
             "pmm12.pmm_file.pmm12,",
             "pmm22.pmm_file.pmm22,",
             "pmnud01.pmn_file.pmnud01,",

             "pmm40t.pmm_file.pmm40t"
             #darcy add 2022年1月13日 s---
             ,",ecd02.ecd_file.ecd02,",
             "ta_sgm01.sgm_file.ta_sgm01,",
             "ta_sgm02.sgm_file.ta_sgm02,",
             "pmnud07.pmn_file.pmnud07,",
             "gen02.gen_file.gen02" 
             #darcy add 2022年1月13日 e---
              ,",pmn02.pmn_file.pmn02" 
              ,",pmn18.pmn_file.pmn18" #darcy:2022/11/11 add
              ,",sfb07.sfb_file.sfb07" #darcy:2024/02/29 add
              #darcy:2024/06/17 add s---
              ,",pmkud02.pmk_file.pmkud02,",
              "pmkud03.pmk_file.pmkud03"
              #darcy:2024/06/17 add e---

   LET  l_table = cl_prt_temptable('cpmr003',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,? ,?,?,?)"      #add ly180503 2       #darcy 220113 add 5 ?      
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
      THEN CALL cpmr003_tm(0,0)          
      ELSE
           CALL cpmr003()                
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN


FUNCTION cpmr003_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
DEFINE p_row,p_col    LIKE type_file.num5,        
       l_cmd        LIKE type_file.chr1000      
 
   LET p_row = 9 LET p_col = 8
 
   OPEN WINDOW cpmr003_w AT p_row,p_col WITH FORM "cpm/42f/cpmr003"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
  
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1' 
 
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pmm01,pmm04
                              
     
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
              WHEN INFIELD(pmm01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pmm12"  #No.TQC-5B0095
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmm01
                 NEXT FIELD pmm01
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
      LET INT_FLAG = 0 CLOSE WINDOW cpmr003_w 
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
      LET INT_FLAG = 0 CLOSE WINDOW cpmr003_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='cpmr003'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('cpmr003','9031',1)
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
         CALL cl_cmdat('cpmr003',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW cpmr003_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL cpmr003()
   ERROR ""
END WHILE
   CLOSE WINDOW cpmr003_w
END FUNCTION


FUNCTION cpmr003()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
          l_sql     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(3000)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          l_zo041   LIKE zo_file.zo041,   #FUN-810029 add
          l_zo042   LIKE zo_file.zo042,
          l_zo05    LIKE zo_file.zo05,     #FUN-810029 add
          l_zo09    LIKE zo_file.zo09,     #FUN-810029 add
          sr        RECORD
                    zo05     LIKE zo_file.zo05,     #公司电话
                    zo041    LIKE zo_file.zo041,    #公司地址
                    pmc081   LIKE pmc_file.pmc081,  #供应商名称
                    pmm09    LIKE pmm_file.pmm09,   #英文供应商名称
                    pmc11    LIKE pmc_file.pmc11,   #传真号码

                    pmc10    LIKE pmc_file.pmc10,   #电话
                    pmd03    LIKE pmd_file.pmd03,   #英文电话
                    pmd02    LIKE pmd_file.pmd02,   #联络人
                    pmm01    LIKE pmm_file.pmm01,   #采购单号
                    pmm16    LIKE pmm_file.pmm16,   #最后交货日期

                    pmm04    LIKE pmm_file.pmm04,   #订购日期
                    pmm20    LIKE pmm_file.pmm20,   #付款方式
                    pma02    LIKE pma_file.pma02,   #付款条件
                    pmn04    LIKE pmn_file.pmn04,   #物料代码
                    pmn041   LIKE pmn_file.pmn041,  #物料名称

                    ima021   LIKE ima_file.ima021,  #规格型号
                    pmn20    LIKE pmn_file.pmn20,   #数量 
                    pmn07    LIKE pmn_file.pmn07,   #单位
                    pmm43    LIKE pmm_file.pmm43,   #税率
                    pmn31    LIKE pmn_file.pmn31,
                    pmn31t   LIKE pmn_file.pmn31t,  #单价
                    
                    pmn88    LIKE pmn_file.pmn88,
                    pmn88t   LIKE pmn_file.pmn88t,  #金额
                    pmn34    LIKE pmn_file.pmn34,   #交货日期
                    pmm12    LIKE pmm_file.pmm12,   #采购员
                    pmm22    LIKE pmm_file.pmm22,   #币制
                    pmnud01  LIKE pmn_file.pmnud01, #备注

                    pmm40t   LIKE pmm_file.pmm40t   #含税总金额
                    #darcy 2022年1月13日 add s---
                    ,ecd02    LIKE ecd_file.ecd02,
                    ta_sgm01 LIKE sgm_file.ta_sgm01,
                    ta_sgm02 LIKE sgm_file.ta_sgm02,
                    pmnud07  LIKE pmn_file.pmnud07,
                    gen02    LIKE gen_file.gen02
                    #darcy 2022年1月13日 add e---
                    ,pmn02  like pmn_file.pmn02  #darcy:2022/11/07 l_add1
                    ,pmn18  like pmn_file.pmn18  #darcy:2022/11/11 add
                    ,sfb07  like sfb_file.sfb07  #darcy:2024/02/29 add
                    #darcy:2024/06/17 add s---
                    ,pmkud02   like pmk_file.pmkud02,
                    pmkud03   like pmk_file.pmkud03
                    #darcy:2024/06/17 add e---
                    END RECORD 
   DEFINE i   LIKE type_file.num5   
   DEFINE j   LIKE type_file.num5
   DEFINE l_cnt     LIKE type_file.num5  
   DEFINE l_num       LIKE type_file.num5 
  
   DEFINE l_pmm01  LIKE pmm_file.pmm01
   DEFINE l_price LIKE ogb_file.ogb13
   DEFINE l_num1   LIKE type_file.num5

   DEFINE l_img_blob     LIKE type_file.blob
   DEFINE l_imaud07      LIKE ima_file.imaud07,
          l_imaud10      LIKE ima_file.imaud10,
          l_pmn01        LIKE pmn_file.pmn01,
          l_pmn02        LIKE pmn_file.pmn02
   define l_sfb01        like sfb_file.sfb01 #darcy:2024/02/29 add
   LOCATE l_img_blob IN MEMORY    
  

     CALL cl_del_data(l_table) 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='cpmr003' 
 
     LET tm.wc = tm.wc CLIPPED 
LET i = 1
LET j = 1
LET l_sql="select '','',pmc081,pmm09,pmc11,pmc10,pmd03,pmd02,pmm01,pmm16,pmm04,pmm20,pma02,pmn04,pmn041,ima021,pmn20,pmn07,pmm43,pmn31,pmn31t,pmn88,pmn88t,pmn34,pmm12,pmm22,trim(pmnud01),pmm40t",
          ",ecd02,ta_sgm01,ta_sgm02,pmnud07,gen02,pmn02,pmn18,'',imaud34,imaud33,imaud07,imaud10,pmn01", #darcy add 2022年1月13日  #darcy:2022/11/07 add pmn02 #darcy:2022/11/11 add pmn18
           " from pmm_file left join pmc_file on pmc01 = pmm09 ",
           " left join pmd_file on pmc01 = pmd01 ",
           " and pmd05='Y' ", #darcy:2022/07/22 add 
           " left join pma_file on pmm20 = pma01 ",
           " LEFT JOIN gen_file ON gen01 = pmm12 ", #darcy add 2022年1月13日
           ",pmn_file left join ima_file on pmn04=ima01",
           " LEFT JOIN ecd_file ON ecd01 = pmn78  ", #darcy add 2022年1月13日
	        " LEFT JOIN sgm_file ON sgm01 = pmn18 AND sgm04 = pmn78 ", #darcy add 2022年1月13日
           " where ",tm.wc ,
           "   AND pmm01=pmn01 "
           ,"order by pmm01,pmn02" #darcy:2022/11/07 add
           
        #   " AND pmn16 not in ('9') "
        #   " AND pmn16 not in ('6','7','8','9') "  #add by jixf 160803 排除结案
 
     PREPARE cpmr003_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM   
     END IF
     DECLARE cpmr003_curs1 CURSOR FOR cpmr003_prepare1
 
     FOREACH cpmr003_curs1 INTO sr.*,l_imaud07,l_imaud10,l_pmn01
     IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
     let l_pmn02 = sr.pmn02  #darcy:2022/11/07 add
     --IF i =1 THEN 
         --LET l_pmm01 = sr.pmm01
         --LET i = i+1
     --ELSE 
         --IF l_pmm01 != sr.pmm01 THEN 
             --LET i = 1
             --LET i = i + 1
         --ELSE 
             --LET i = i + 1
         --END IF 
     --END IF
--
     --IF i>5 THEN  
      --LET i = i-5
      --LET j = j + 1
     --END IF 
     --LET sr.num1  = j 
     #darcy 2022年1月14日 add s---
     LET sr.ta_sgm01 = sr.ta_sgm01 CLIPPED,"|尺寸:",l_imaud07 CLIPPED,"|排版量:",l_imaud10 
     IF cl_null(sr.pmnud07)  then   
         let sr.pmnud07=sr.pmn20/l_imaud10  
         update pmn_file set pmnud07=sr.pmnud07  where pmn01=l_pmn01 and pmn02=l_pmn02 
     END  IF 
     #darcy 2022年1月14日 add e---

     #darcy:2024/02/29 add s---
     let l_sfb01 = sr.pmn18[1,12]
      select sfb06 into sr.sfb07 from sfb_file
       where sfb01 = l_sfb01
     #darcy:2024/02/29 add e---
     
     SELECT zo05,zo041 INTO sr.zo05,sr.zo041
     FROM zo_file WHERE zo01=g_rlang
       EXECUTE insert_prep USING sr.*
     END FOREACH
      --LET l_sql = "SELECT pmm01,count(*) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," group by pmm01"
     --PREPARE cpmr003_prepare2 FROM l_sql
     --DECLARE cpmr003_curs2 CURSOR FOR cpmr003_prepare2
     --FOREACH cpmr003_curs2 INTO l_pmm01,l_num
     --LET l_num=5-(l_num MOD 5)
     --FOR i=1 TO l_num
     --INITIALIZE sr.* TO NULL
     --LET sr.pmm01 = l_pmm01
     --LET sr.pmn04 ='ZZZZZZZZZZ'
      --EXECUTE insert_prep USING sr.*
      --END FOR 
     --END FOREACH 

     
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'pmm01,pmm04')
             RETURNING tm.wc
     END IF
     LET g_str = tm.wc

     CALL cl_prt_cs3('cpmr003','cpmr003',g_sql,g_str)

END FUNCTION



