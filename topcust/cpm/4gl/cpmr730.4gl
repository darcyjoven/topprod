# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: cpmr730.4gl
# Descriptions...: 委外采购入库单
# Date & Author..: 2016/08/11 guanyao

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

#GLOBALS
#  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
#  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
#  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
#  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
#  DEFINE g_seq_item     LIKE type_file.num5 
#END GLOBALS
#No.FUN-580004--end
DEFINE tm  RECORD 
           wc        STRING
        END RECORD 
DEFINE g_tc_bwc07     VARCHAR(1000)
DEFINE  g_i             LIKE type_file.num5     
DEFINE  g_msg           LIKE type_file.chr1000    
DEFINE l_oaz23          LIKE oaz_file.oaz23 
DEFINE g_sma116         LIKE sma_file.sma116
DEFINE l_zaa02          LIKE zaa_file.zaa02
DEFINE i                LIKE type_file.num10       # No.FUN-680137 INTEGER
DEFINE l_i,l_cnt        LIKE type_file.num5         #No.FUN-680137 SMALLINT

#FUN-710081--start
DEFINE  g_sql      STRING
DEFINE  l_table    STRING
DEFINE  l_str      STRING
#FUN-710081--end
 
MAIN
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CPM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
 
   INITIALIZE tm.* TO NULL                # Default condition
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)
  
   DISPLAY "g_rpt_name:",g_rpt_name
  
    LET g_sql ="rvv18.rvv_file.rvv18,",
               "rvv31.rvv_file.rvv31,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,", 
               "rvv17.rvv_file.rvv17,",

               "rvv35.rvv_file.rvv35,",
               "imaud07.ima_file.imaud07,",
               "imaud10.ima_file.imaud10,",
               "l_num1.rvv_file.rvv17,",
               "ta_sgm01.sgm_file.ta_sgm01,",

               "rvu01.rvu_file.rvu01,",
               "rvu02.rvu_file.rvu02,",
               "rvu03.rvu_file.rvu03,",
               "rvv36.rvv_file.rvv36,",
               "rvv37.rvv_file.rvv37,",
               
               "ecd02.ecd_file.ecd02,",
               "num2.type_file.num5,",
               "pmn78.pmn_file.pmn78,",
               "rvuuser.rvu_file.rvuuser,",
               "gen02.gen_file.gen02,",  #add by huanglf161114

               "rvu04.rvu_file.rvu04,",  #add by huanglf161114
               "pmc081.pmc_file.pmc081,",  #add by huanglf161114
               "zo041.zo_file.zo041,",   #add by huanglf161114
               "zo05.zo_file.zo05"       #add by huanglf161114


   LET l_table = cl_prt_temptable('cpmr730',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   
   IF cl_null(tm.wc) THEN
      CALL cpmr730_tm(0,0)             
   ELSE      
      CALL cpmr730()
   END IF 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION cpmr730_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,         
          l_cmd          LIKE type_file.chr1000   
   DEFINE l_str          LIKE type_file.chr1000
   DEFINE l_sql          LIKE type_file.chr1000
    
 
   LET p_row = 7 LET p_col = 17
 
   OPEN WINDOW cpmr730_w AT p_row,p_col WITH FORM "cpm/42f/cpmr730"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)  
   CALL cl_ui_init()
   SELECT oaz23 INTO l_oaz23 FROM oaz_file
   CALL cl_opmsg('p')
 #--------------No.TQC-610089 modify  
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 #--------------No.TQC-610089 end 
   WHILE TRUE
   #DIALOG ATTRIBUTE (UNBUFFERED)
       
      CONSTRUCT BY NAME tm.wc ON rvu01,rvu03       
         BEFORE CONSTRUCT
             CALL cl_qbe_init() 
     
        ON ACTION locale 
          CALL cl_show_fld_cont()                    
          LET g_action_choice = "locale"
          EXIT CONSTRUCT
            
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(rvu01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_rvu1"  #MOD-4A0252異動單號開窗,新增q_rvu1
                    LET g_qryparam.state = 'c'
                    LET g_qryparam.arg1 = 1
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rvu01
                    NEXT FIELD rvu01
            END CASE        
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT  
 
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


         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END CONSTRUCT
      
      --ON ACTION ACCEPT  
          --ACCEPT DIALOG   
--
      --ON ACTION CANCEL  
          --LET INT_FLAG=1   
          --EXIT DIALOG      
          --
    --END DIALOG  
      --
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW cpmr730_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
      END IF 
      IF tm.wc=" 1=1" THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01 = 'cpmr730'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('cpmr730','9031',1)
         ELSE
#            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,       
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",                       
                        " '",g_rlang CLIPPED,"'", 
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'" ,                       
                        " '",g_rep_user CLIPPED,"'",          
                        " '",g_rep_clas CLIPPED,"'",           
                        " '",g_template CLIPPED,"'",           
                        " '",g_rpt_name CLIPPED,"'"           
            CALL cl_cmdat('cpmr730',g_time,l_cmd)
         END IF
 
         CLOSE WINDOW cpmr730_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
      END IF
 
      CALL cl_wait() 
      CALL cpmr730() 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW cpmr730_w
 
END FUNCTION
 
--FUNCTION cpmr730()
   --DEFINE sr        RECORD
               --rvv18    LIKE rvv_file.rvv18,
               --rvv31    LIKE rvv_file.rvv31,
               --ima02    LIKE ima_file.ima02,
               --ima021   LIKE ima_file.ima021,
               --rvv17    LIKE rvv_file.rvv17,
               --
               --rvv35    LIKE rvv_file.rvv35,
               --imaud07  LIKE ima_file.imaud07,
               --imaud10  LIKE ima_file.imaud10,
               --l_num1   LIKE rvv_file.rvv17,
               --ta_sgm01 LIKE sgm_file.ta_sgm01,
--
               --rvu01    LIKE rvu_file.rvu01,
               --rvu02    LIKE rvu_file.rvu02,
               --rvu03    LIKE rvu_file.rvu03,
               --rvv36    LIKE rvv_file.rvv36,
               --rvv37    LIKE rvv_file.rvv37,
--
               --ecd02    LIKE ecd_file.ecd02,
               --num2     LIKE type_file.num5,
               --pmn78    LIKE pmn_file.pmn78
                 --END RECORD
--
   --DEFINE l_zo041     LIKE zo_file.zo041 
   --DEFINE l_zo05      LIKE zo_file.zo05  
   --DEFINE l_zo09      LIKE zo_file.zo09
   --DEFINE l_occ01     LIKE occ_file.occ01
   --DEFINE l_sql,l_sql1,l_sql2,l_sql3    STRING
   --DEFINE l_cmd,g_wc2a,g_wc2b       STRING 
   --DEFINE l_imaud10   LIKE type_file.chr30
   --DEFINE l_pmn18     LIKE pmn_file.pmn18
   --DEFINE l_pmn32     LIKE pmn_file.pmn32
   --DEFINE l_pmn78     LIKE pmn_file.pmn78
   --DEFINE l_rvv18     LIKE rvv_file.rvv18
   --DEFINE l_rvu01     LIKE rvu_file.rvu01
   --DEFINE l_rvv36     LIKE rvv_file.rvv36
   --DEFINE l_rvv37     LIKE rvv_file.rvv37
   --DEFINE l_cnt       LIKE type_file.num5
   --
   --CALL r730_create_temp()   
   --CALL cl_del_data(l_table)  
   --LET tm.wc = tm.wc CLIPPED
   --LET l_cnt = 1 
   --LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                    
               --" values(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"  
   --PREPARE insert_prep FROM g_sql                                       
   --IF STATUS THEN                                                              
      --CALL cl_err("insert_prep:",STATUS,1)                              
      --CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      --EXIT PROGRAM
   --END IF   
   --LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('rvuuser', 'rvugrup')  
               --
   --LET l_sql2 = "SELECT rvv18,rvu01",
               --"  FROM rvu_file,rvv_file ",
               --"  WHERE rvu01 = rvv01 ",
               --"   AND ",tm.wc CLIPPED,
               --" GROUP BY rvv18,rvu01"
   --PREPARE prep_ccc FROM l_sql2
   --DECLARE decl_ccc CURSOR FOR prep_ccc
   --FOREACH decl_ccc INTO l_rvv18,l_rvu01
        --IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
--
        --LET l_sql3 = "SELECT rvv36,rvv37 FROM rvv_file 
                     --WHERE rvv01 = '",l_rvu01,"' AND rvv18 = '",l_rvv18,"'"
         --PREPARE prep_ddd FROM l_sql3
         --DECLARE decl_ddd CURSOR FOR prep_ddd
--
         --FOREACH decl_ddd INTO l_rvv36,l_rvv37 
           --
           #EXIT FOREACH 
         --END FOREACH 
--
         --SELECT pmn78 INTO l_pmn78 FROM pmn_file WHERE pmn01 = l_rvv36  AND pmn02 = l_rvv37
        --INSERT INTO pmn1_temp(rvu01,rvv18,pmn78) VALUES(l_rvu01,l_rvv18,l_pmn78)
   --END FOREACH 
--
--
   --LET l_sql = "SELECT rvv18,rvv31,ima02,ima021,sum(rvv17),rvv35,imaud07,imaud10,'','',rvu01,rvu02,rvu03,'','','','',''",
               --"  FROM rvv_file LEFT JOIN ima_file ON rvv31=ima01 , rvu_file",
               --"  WHERE rvu01 = rvv01 ",
               --"   AND ",tm.wc CLIPPED,
               --" GROUP BY rvv18,rvv31,ima02,ima021,rvv35,imaud07,imaud10,rvu01,rvu02,rvu03"   
   --
   --PREPARE prep_aaa FROM l_sql
   --DECLARE decl_aaa CURSOR FOR prep_aaa
   --FOREACH decl_aaa INTO sr.*
     --IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        --LET l_sql1 = "SELECT rvv36,rvv37 FROM rvv_file 
                     --WHERE rvv01 = '",sr.rvu01,"' AND rvv18 = '",sr.rvv18,"'"
         --PREPARE prep_bbb FROM l_sql1
         --DECLARE decl_bbb CURSOR FOR prep_bbb
         --FOREACH decl_bbb INTO sr.rvv36,sr.rvv37 
          --EXIT FOREACH 
         --END FOREACH 
         --
        --SELECT pmn18,pmn32,pmn78 INTO l_pmn18,l_pmn32,l_pmn78 FROM pmn_file WHERE pmn01 = sr.rvv36  AND pmn02 = sr.rvv37 
        --SELECT ta_sgm01 INTO sr.ta_sgm01 FROM sgm_file WHERE sgm01 = l_pmn18 AND sgm03 = l_pmn32
        --LET l_pmn78=l_pmn78[1,5]
        --LET l_pmn78 = l_pmn78,"0"
        --SELECT ecd02 INTO sr.ecd02 FROM ecd_file WHERE ecd01 =l_pmn78
--
        --LET l_sql3 = "SELECT rvv18,pmn78 FROM pmn1_temp WHERE pmn78 LIKE '%",l_pmn78,"%'  AND rvu01 = '",sr.rvu01,"'" 
         --PREPARE prep_eee FROM l_sql3
         --DECLARE decl_eee CURSOR FOR prep_eee
         --FOREACH decl_eee INTO l_rvv18
           --UPDATE pmn1_temp SET pmn78 = l_pmn78 WHERE rvu01 = sr.rvu01 AND rvv18 = l_rvv18 AND l_cnt IS NULL
           --UPDATE pmn1_temp SET num2 = l_cnt WHERE rvu01 = sr.rvu01 AND rvv18 = l_rvv18 AND l_cnt IS NULL 
         --END FOREACH 
        --LET l_cnt = l_cnt + 1
        --SELECT num2 INTO sr.num2 FROM pmn1_temp WHERE rvv18 = l_rvv18
        --SELECT pmn78 INTO sr.pmn78 FROM pmn1_temp WHERE rvv18 = l_rvv18
        --LET sr.l_num1 = sr.rvv17/sr.imaud10
     --EXECUTE insert_prep USING sr.*
   --END FOREACH                     
 --
    --LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     --IF g_zz05='Y' THEN
        --CALL cl_wcchp(tm.wc,'ecu01,ecu03')
             --RETURNING tm.wc
     --END IF
--
     --CALL cl_prt_cs3('cpmr730','cpmr730',g_sql,tm.wc)
--
--
--END FUNCTION




FUNCTION cpmr730()
   DEFINE sr        RECORD
               rvv18    LIKE rvv_file.rvv18,
               rvv31    LIKE rvv_file.rvv31,
               ima02    LIKE ima_file.ima02,
               ima021   LIKE ima_file.ima021,
               rvv17    LIKE rvv_file.rvv17,
               
               rvv35    LIKE rvv_file.rvv35,
               imaud07  LIKE ima_file.imaud07,
               imaud10  LIKE ima_file.imaud10,
               l_num1   LIKE rvv_file.rvv17,
               ta_sgm01 LIKE sgm_file.ta_sgm01,

               rvu01    LIKE rvu_file.rvu01,
               rvu02    LIKE rvu_file.rvu02,
               rvu03    LIKE rvu_file.rvu03,
               rvv36    LIKE rvv_file.rvv36,
               rvv37    LIKE rvv_file.rvv37,

               ecd02    LIKE ecd_file.ecd02,
               num2     LIKE type_file.num5,
               pmn78    LIKE pmn_file.pmn78,
               rvuuser  LIKE rvu_file.rvuuser,  #add by huanglf161114
               gen02    LIKE gen_file.gen02,    #add by huanglf161114
 
               rvu04    LIKE rvu_file.rvu04,    #add by huanglf161114
               pmc081    LIKE pmc_file.pmc081,    #add by huanglf161114
               zo041    LIKE zo_file.zo041,     #add by huanglf161114
               zo05     LIKE zo_file.zo05       #add by huanglf161114  
                 END RECORD

     DEFINE sr1        RECORD
               rvv18    LIKE rvv_file.rvv18,
               rvv31    LIKE rvv_file.rvv31,
               ima02    LIKE ima_file.ima02,
               ima021   LIKE ima_file.ima021,
               rvv17    LIKE rvv_file.rvv17,
               
               rvv35    LIKE rvv_file.rvv35,
               imaud07  LIKE ima_file.imaud07,
               imaud10  LIKE ima_file.imaud10,
               rvu01    LIKE rvu_file.rvu01,
               rvu02    LIKE rvu_file.rvu02,
               
               rvu03    LIKE rvu_file.rvu03,
               rvv36    LIKE rvv_file.rvv36,
               rvv37    LIKE rvv_file.rvv37,
               pmn78    LIKE pmn_file.pmn78
                 END RECORD

   DEFINE l_zo041     LIKE zo_file.zo041 
   DEFINE l_zo05      LIKE zo_file.zo05  
   DEFINE l_zo09      LIKE zo_file.zo09
   DEFINE l_occ01     LIKE occ_file.occ01
   DEFINE l_sql,l_sql1,l_sql2,l_sql3    STRING
   DEFINE l_cmd,g_wc2a,g_wc2b       STRING 
   DEFINE l_imaud10   LIKE type_file.chr30
   DEFINE l_pmn18     LIKE pmn_file.pmn18
   DEFINE l_pmn32     LIKE pmn_file.pmn32
   DEFINE l_pmn78     LIKE pmn_file.pmn78
   DEFINE l_rvv18     LIKE rvv_file.rvv18
   DEFINE l_rvu01     LIKE rvu_file.rvu01
   DEFINE l_rvv36     LIKE rvv_file.rvv36
   DEFINE l_rvv37     LIKE rvv_file.rvv37
   DEFINE l_cnt       LIKE type_file.num5
   DEFINE l_pmn78_o   LIKE pmn_file.pmn78
   DEFINE l_pmn78_s   LIKE pmn_file.pmn78
   
   CALL r730_create_temp1()   
   CALL cl_del_data(l_table)  
   LET tm.wc = tm.wc CLIPPED
   LET l_cnt = 1 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                    
               " values(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"  
   PREPARE insert_prep FROM g_sql                                       
   IF STATUS THEN                                                              
      CALL cl_err("insert_prep:",STATUS,1)                              
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF   
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('rvuuser', 'rvugrup')  
               
 
   LET l_sql1 = "SELECT rvv18,rvv31,ima02,ima021,rvv17,rvv35,imaud07,imaud10,rvu01,rvu02,rvu03,rvv36,rvv37,pmn78",  #add by huanglf161114
               "  FROM rvv_file LEFT JOIN ima_file ON rvv31=ima01 ",
               "  LEFT JOIN pmn_file ON pmn01 = rvv36 AND pmn02=rvv37 ",
               ",rvu_file",
               "  WHERE rvu01 = rvv01 ",
               "   AND ",tm.wc CLIPPED,
               "  ORDER BY rvv18,pmn78"
   
   PREPARE prep_bbb FROM l_sql1
   DECLARE decl_bbb CURSOR FOR prep_bbb
   FOREACH decl_bbb INTO sr1.*
      # tianry add 161201   化金 不合并 
       IF sr1.pmn78[1,5]= 'F2101' THEN
       ELSE
      #  tianry add end 
         LET sr1.pmn78 = sr1.pmn78[1,5]
         LET sr1.pmn78 = sr1.pmn78,"0"
       END IF 
       INSERT INTO pmn2_temp(rvv18,rvv31,ima02,ima021,rvv17,rvv35,imaud07,imaud10,rvu01,rvu02,rvu03,rvv36,rvv37,pmn78)
       VALUES(sr1.rvv18,sr1.rvv31,sr1.ima02,sr1.ima021,sr1.rvv17, 
              sr1.rvv35,sr1.imaud07,sr1.imaud10,sr1.rvu01,sr1.rvu02,
              sr1.rvu03,sr1.rvv36,sr1.rvv37,sr1.pmn78)
   
   END FOREACH 

   LET l_sql = "SELECT rvv18,rvv31,ima02,ima021,sum(rvv17),rvv35,imaud07,imaud10,'','',rvu01,rvu02,rvu03,'','','','',pmn78,'','','','','',''",
               "  FROM pmn2_temp",
               "  WHERE ",tm.wc CLIPPED,
               " GROUP BY rvv18,rvv31,ima02,ima021,rvv35,imaud07,imaud10,rvu01,rvu02,rvu03,pmn78"   
   PREPARE prep_aaa FROM l_sql
   DECLARE decl_aaa CURSOR FOR prep_aaa
   FOREACH decl_aaa INTO sr.*
     IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
         #LET l_sql2 = "SELECT rvv36,rvv37 FROM rvv_file 
         #            WHERE rvv01 = '",sr.rvu01,"' AND rvv18 = '",sr.rvv18,"'"
         #PREPARE prep_ccc FROM l_sql2
         #DECLARE decl_ccc CURSOR FOR prep_ccc
         #LET l_pmn78_s = sr.pmn78
         #FOREACH decl_ccc INTO sr.rvv36,sr.rvv37
         #    SELECT pmn78 INTO l_pmn78_o FROM pmn_file WHERE pmn01 = sr.rvv36  AND pmn02 = sr.rvv37 
         #    IF l_pmn78_o[1,5] = l_pmn78_s[1,5] THEN EXIT FOREACH END IF              
         #END FOREACH
         
        #SELECT pmn18,pmn32 INTO l_pmn18,l_pmn32 FROM pmn_file WHERE pmn01 = sr.rvv36  AND pmn02 = sr.rvv37 
        #SELECT ta_sgm01 INTO sr.ta_sgm01 FROM sgm_file WHERE sgm01 = l_pmn18 AND sgm03 = l_pmn32 AND pmn78=sr.pmn78
        LET l_pmn78_o = sr.pmn78
        LET l_pmn78_o = l_pmn78_o[1,5]
   
        #tianry add 170214
         

        SELECT ta_sgm01 INTO sr.ta_sgm01 FROM sgm_file WHERE sgm02=sr.rvv18  AND sgm04=sr.pmn78  AND ROWNUM = 1
        IF cl_null(sr.ta_sgm01) THEN  
           SELECT ta_sgm01 FROM sgm_file WHERE sgm02 = sr.rvv18 AND sgm04 LIKE 'F2101%' AND ROWNUM = 1
           LET l_sql2 = "SELECT ta_sgm01 FROM sgm_file",
                        " WHERE sgm02 = '",sr.rvv18,"' AND sgm04 LIKE '",l_pmn78_o,"%'"
           PREPARE prep_ccc FROM l_sql2
           DECLARE decl_ccc CURSOR FOR prep_ccc
           FOREACH decl_ccc INTO sr.ta_sgm01
              EXIT FOREACH           
           END FOREACH
        END IF 
      #tianry add end 
#str----add by huanglf161114
        SELECT rvuuser,rvu04 INTO sr.rvuuser,sr.rvu04 FROM rvu_file WHERE rvu01 = sr.rvu01
        SELECT gen02 INTO sr.gen02 FROM gen_file WHERE gen01 = sr.rvuuser
        SELECT pmc081 INTO sr.pmc081 FROM pmc_file WHERE pmc01 = sr.rvu04
        SELECT zo05,zo041 INTO sr.zo05,sr.zo041
        FROM zo_file WHERE zo01=g_rlang
#str----end by huanglf161114
        SELECT ecd02 INTO sr.ecd02 FROM ecd_file WHERE ecd01 =sr.pmn78
        LET sr.l_num1 = sr.rvv17/sr.imaud10
     EXECUTE insert_prep USING sr.*
   END FOREACH                     
 
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'ecu01,ecu03')
             RETURNING tm.wc
     END IF

     CALL cl_prt_cs3('cpmr730','cpmr730',g_sql,tm.wc)


END FUNCTION

FUNCTION r730_create_temp1()
DROP TABLE pmn2_temp
CREATE TEMP TABLE pmn2_temp(
               rvv18    LIKE rvv_file.rvv18,
               rvv31    LIKE rvv_file.rvv31,
               ima02    LIKE ima_file.ima02,
               ima021   LIKE ima_file.ima021,
               rvv17    LIKE rvv_file.rvv17,
               rvv35    LIKE rvv_file.rvv35,
               imaud07  LIKE ima_file.imaud07,
               imaud10  LIKE ima_file.imaud10,
               rvu01    LIKE rvu_file.rvu01,
               rvu02    LIKE rvu_file.rvu02,
               rvu03    LIKE rvu_file.rvu03,
               rvv36    LIKE rvv_file.rvv36,
               rvv37    LIKE rvv_file.rvv37,
               pmn78    LIKE pmn_file.pmn78)
END FUNCTION 

