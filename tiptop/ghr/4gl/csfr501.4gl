# Prog. Version..: '5.25.02-11.05.04(00010)'     #
#
# Pattern name...: csfr501.4gl
# Descriptions...: 工单发料单
# Date & Author..: 11/10/24 By zhangym
 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE tm  RECORD		                # Print condition RECORD
            wc         STRING,  #No.FUN-680121 VARCHAR(600)# Where Condition
            p          LIKE type_file.chr1,     #No.FUN-680121 VARCHAR(1)
            q          LIKE type_file.chr1,     #No.FUN-680121 VARCHAR(1)
            c       LIKE type_file.chr1,    #No.FUN-860026  
            more       LIKE type_file.chr1      #No.FUN-680121 VARCHAR(1)# Input more condition(Y/N)
           END RECORD,
       g_argv1         LIKE sfp_file.sfp01,
       g_t1            LIKE type_file.chr3,     #No.FUN-680121 VARCHAR(3)
       g_no            LIKE type_file.num5      #No.FUN-680121 SMALLINT
DEFINE g_cnt           LIKE type_file.num10     #No.FUN-680121 INTEGER
DEFINE g_i             LIKE type_file.num5      #count/index for any purpose        #No.FUN-680121 SMALLINT
#No.FUN-710082--begin
DEFINE g_sql           STRING
DEFINE l_table         STRING
DEFINE l_table1        STRING                   #CHI-7A0044 add
DEFINE l_table2        STRING                   #CHI-7A0044 add
DEFINE l_table3        STRING                 #No.FUN-860026 
DEFINE g_str           STRING
DEFINE i,j,k,l_flag    LIKE type_file.num5
#No.FUN-710082--end  
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CSF")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123
 
   LET g_pdate  = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET g_argv1  = ARG_VAL(7)     #No.TQC-6C0143
   LET tm.p     = ARG_VAL(8)
   LET tm.q     = ARG_VAL(9)
   LET tm.c     = ARG_VAL(13)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)                   #MOD-B30718 add
 
 
   LET g_sql ="sfp01.sfp_file.sfp01,sfp02.sfp_file.sfp02,",
              "sfp03.sfp_file.sfp03,sfp06.sfp_file.sfp06,",
              "sfp07.sfp_file.sfp07,sfp08.sfp_file.sfp08,",
              "ima23.ima_file.ima23,gem02.gem_file.gem02,",
              "gen02.gen_file.gen02,flag.type_file.num5,",  
              "l_gem02.gem_file.gem02,",
              "sfq01.sfq_file.sfq01,  sfq02.sfq_file.sfq02,",
              "sfq03.sfq_file.sfq03,  sfq04.sfq_file.sfq04,",
              "sfb05.sfb_file.sfb05,  sfb08.sfb_file.sfb08,",
              "sfb081.sfb_file.sfb081,sfb09.sfb_file.sfb09,",
              "ima02a.ima_file.ima02, ima021a.ima_file.ima021,",
              "sfs01.sfs_file.sfs01,  sfs02.sfs_file.sfs02,",
              "sfs03.sfs_file.sfs03,  sfs04.sfs_file.sfs04,",
              "sfs05.sfs_file.sfs05,  sfs06.sfs_file.sfs06,",
              "sfs07.sfs_file.sfs07,  sfs08.sfs_file.sfs08,",
              "sfs09.sfs_file.sfs09,  sfs10.sfs_file.sfs10,",
              "sfs26.sfs_file.sfs26,  ima02.ima_file.ima02,",
              "ima021.ima_file.ima021,",
              "img10.img_file.img10,   sfs012.sfs_file.sfs012,",    
              "sfs013.sfs_file.sfs013,",                               
              "ta_ima04.ima_file.ta_ima04,",
              "ta_ima06.ima_file.ta_ima06,",
              "azf03.azf_file.azf03,",
              "l_agd03_3.agd_file.agd03,",
              "l_agd03_5.agd_file.agd03,",
              "sfa05.sfa_file.sfa05,",
              "sfa065.sfa_file.sfa065,",
              "a.type_file.chr1,",
              "b.type_file.chr1,",
              "c.type_file.chr1"
                                                
   LET l_table = cl_prt_temptable('csfr501',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF            

   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN       # If background job sw is off
         CALL r501_tm()
      #TQC-610080-end
   ELSE                                  	# Read data and create out-file
      LET tm.wc=" sfp01 = '",g_argv1,"'"
      CALL r501_out()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION r501_tm()
DEFINE lc_qbe_sn     LIKE gbm_file.gbm01          #No.FUN-580031
DEFINE l_cmd         LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(400)
DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
  LET p_row = 5 LET p_col = 20
  OPEN WINDOW r501_w AT p_row,p_col WITH FORM "csf/42f/csfr501"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
  CALL cl_ui_init()
 
  CALL cl_opmsg('p')
  INITIALIZE tm.* TO NULL			# Default condition
  LET tm.more = 'N'
  LET tm.p    = 'Y'
  LET tm.q    = '1'
  LET tm.c    = 'N'  #No.FUN-860026
  LET g_rlang = g_lang
  LET g_bgjob = 'N'
  LET g_copies= '1'
  LET g_pdate = g_today  #TQC-610080
 
  WHILE TRUE
     CONSTRUCT BY NAME tm.wc ON sfp01,sfp02,sfp03,sfp06,sfp07
        #No.FUN-580031 --start--
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
        #No.FUN-580031 ---end---
        ON ACTION locale
           LET g_action_choice = "locale"
           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           EXIT CONSTRUCT
        #### No.FUN-4A0005
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(sfp01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_sfp2"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sfp01
                 NEXT FIELD sfp01
              WHEN INFIELD(sfp07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sfp07
                 NEXT FIELD sfp07
           END CASE
        ### END  No.FUN-4A0005
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
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfpuser', 'sfpgrup') #FUN-980030
     IF g_action_choice = "locale" THEN
        LET g_action_choice = ""
        CALL cl_dynamic_locale()
        CONTINUE WHILE
     END IF
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        EXIT WHILE
     END IF
     IF tm.wc=" 1=1 " THEN
        CALL cl_err(' ','9046',0)
        CONTINUE WHILE
     END IF
 
     DISPLAY BY NAME tm.p,tm.q,tm.c,tm.more # Condition   #No.FUN-860026  add tm.c
     INPUT BY NAME tm.q,tm.p,tm.c,tm.more WITHOUT DEFAULTS   #CHI-7A0044  #No.FUN-860026  add tm.c 
        #No.FUN-580031 --start--
        BEFORE INPUT
           CALL cl_qbe_display_condition(lc_qbe_sn)
        #No.FUN-580031 ---end---
        AFTER FIELD p
           IF cl_null(tm.p) THEN NEXT FIELD p END IF
           IF tm.p NOT MATCHES '[YN]' THEN
              NEXT FIELD p
           END IF
        AFTER FIELD q
           IF cl_null(tm.q) THEN NEXT FIELD q END IF
           IF tm.q NOT MATCHES '[12]' THEN
              NEXT FIELD q
           END IF
#No.FUN-860026---BEGIN                                                                                                              
      AFTER FIELD c    #列印批序號明細                                                                                              
         IF tm.c NOT MATCHES "[YN]" OR cl_null(tm.c)                                                                                
            THEN NEXT FIELD c                                                                                                       
         END IF                                                                                                                     
#No.FUN-860026---END  
        AFTER FIELD more
           IF tm.more NOT MATCHES '[YN]' THEN
              NEXT FIELD more
           END IF
           IF tm.more = 'Y'
              THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                  g_bgjob,g_time,g_prtway,g_copies)
                        RETURNING g_pdate,g_towhom,g_rlang,
                                  g_bgjob,g_time,g_prtway,g_copies
           END IF
        ON ACTION CONTROLZ
           CALL cl_show_req_fields()
        ON ACTION CONTROLG
           CALL cl_cmdask()	# Command execution
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
 
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
               WHERE zz01='csfr501'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('csfr501','9031',1)   
        ELSE
           LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
           LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                           " '",g_pdate CLIPPED,"'",
                           " '",g_towhom CLIPPED,"'",
                           #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                           " '",g_bgjob CLIPPED,"'",
                           " '",g_prtway CLIPPED,"'",
                           " '",g_copies CLIPPED,"'",
                           " '",tm.wc CLIPPED,"'",
                           " '",tm.p CLIPPED,"'",                 #TQC-610080
                           " '",tm.q CLIPPED,"'",                 #TQC-610080
                           " '",tm.c CLIPPED,"'",                 #No.FUN-860026  
                           " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                           " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                           " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
           CALL cl_cmdat('csfr501',g_time,l_cmd)	# Execute cmd at later time
        END IF
        CLOSE WINDOW r501_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
     END IF
     CALL cl_wait()
     CALL r501_out()
     ERROR ""
  END WHILE
  CLOSE WINDOW r501_w
END FUNCTION
 
FUNCTION r501_out()
#DEFINE l_time       LIKE type_file.chr8       #No.FUN-6A0090
DEFINE l_name        LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)
       l_sql         LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(1000)
       l_sfp         RECORD LIKE sfp_file.*,
       sr            RECORD
           order1    LIKE sfs_file.sfs03,        #No.FUN-680121 VARCHAR(20)
           order2    LIKE sfs_file.sfs04,        #No.FUN-680121 VARCHAR(20)
           sfs02     LIKE sfs_file.sfs02,
           sfs03     LIKE sfs_file.sfs03,
           sfs04     LIKE sfs_file.sfs04,
           sfs05     LIKE sfs_file.sfs05,
           sfs06     LIKE sfs_file.sfs06,
           sfs07     LIKE sfs_file.sfs07,
           sfs08     LIKE sfs_file.sfs08,
           sfs09     LIKE sfs_file.sfs09,
           sfs10     LIKE sfs_file.sfs10,
           sfs26     LIKE sfs_file.sfs26,
           ima02     LIKE ima_file.ima02,
           ima021    LIKE ima_file.ima021,  #No.FUN-710082
           img10     LIKE img_file.img10,
           sfs012    LIKE sfs_file.sfs012,   #FUN-A60027
           sfs013    LIKE sfs_file.sfs013,    #FUN-A69027
           ta_ima04  LIKE ima_file.ta_ima04,
           ta_ima06  LIKE ima_file.ta_ima06,
           azf03     LIKE azf_file.azf03,
           sfa05    LIKE sfa_file.sfa05,
           sfa065   LIKE sfa_file.sfa065,
           sfa06    LIKE sfa_file.sfa06     #add by zhangym 130111                        
                     END RECORD
#No.FUN-710082--begin
DEFINE l_sfb         RECORD LIKE sfb_file.*
DEFINE l_sfq         RECORD LIKE sfq_file.*
DEFINE l_desc        LIKE smy_file.smydesc
DEFINE l_ima02       LIKE ima_file.ima02
DEFINE l_ima021      LIKE ima_file.ima021
DEFINE l_ima23       LIKE ima_file.ima23     #CHI-7A0044 add
DEFINE l_t1          LIKE oay_file.oayslip
DEFINE l_gen02       LIKE gen_file.gen02
DEFINE l_gem02       LIKE gem_file.gem02
DEFINE l_agd03_3     LIKE agd_file.agd03
DEFINE l_agd03_5     LIKE agd_file.agd03
#No.FUN-710082--end 
DEFINE l_a           LIKE type_file.chr1
DEFINE l_b           LIKE type_file.chr1
DEFINE l_c           LIKE type_file.chr1
DEFINE l_sfs04_t     LIKE sfs_file.sfs04
DEFINE l_sfpud02     LIKE sfp_file.sfpud02 
#No.FUN-860026---begin                                                                                                              
     DEFINE       l_rvbs         RECORD                                                                                             
                                  rvbs03   LIKE  rvbs_file.rvbs03,                                                                  
                                  rvbs04   LIKE  rvbs_file.rvbs04,                                                                  
                                  rvbs06   LIKE  rvbs_file.rvbs06,                                                                  
                                  rvbs021  LIKE  rvbs_file.rvbs021                                                                  
                                  END RECORD                                                                                        
     DEFINE        l_img09     LIKE img_file.img09                        
     DEFINE        flag        LIKE type_file.num5                                                        
#No.FUN-860026---end 
DEFINE l_sfs05     LIKE sfs_file.sfs05    
   CALL cl_del_data(l_table) 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,  ?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?  ,?,?,?, ?,?,?,?,? ,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1) EXIT PROGRAM
   END IF
 
   LET l_sql = " SELECT * FROM sfp_file",
               "  WHERE ",tm.wc CLIPPED,
               #"    AND sfp06 IN ('1','2','3','4') AND sfpconf!='X' ", #FUN-660106
               "    AND sfp06 IN ('1','2','3','4') AND sfpconf ='Y' ", #FUN-660106   #mod by zhangym 130109
               "  ORDER BY sfp01   "  #No.FUN-710082
   PREPARE r501_pr1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM 
   END IF
   DECLARE r501_cs1 CURSOR FOR r501_pr1
 
   FOREACH r501_cs1 INTO l_sfp.*
      IF STATUS THEN CALL cl_err('for sfp:',STATUS,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM 
      END IF
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=l_sfp.sfp07  #MOD-860286 add INTO     
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=l_sfp.sfp16  #MOD-860286 add INTO     
     #str CHI-7A0044 add
      IF l_sfp.sfp04='N' THEN   #sfp04:扣帳碼
         LET l_sql="SELECT ima23 FROM ima_file,sfs_file",
                   " WHERE sfs01='",l_sfp.sfp01,"'",
                   "   AND sfs04=ima01"
      ELSE
         LET l_sql="SELECT ima23 FROM ima_file,sfe_file",
                   " WHERE sfe02='",l_sfp.sfp01,"'",
                   "   AND sfe07=ima01"
      END IF
      PREPARE r501_pr11 FROM l_sql
      IF STATUS THEN CALL cl_err('prepare11:',STATUS,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM 
      END IF
      DECLARE r501_cs11 CURSOR FOR r501_pr11

      LET flag = 0   

      IF l_sfp.sfp04='N' THEN   #sfp04:扣帳碼
         LET l_sql="SELECT '','',sfs02,sfs03,sfs04,sfs05,sfs06,sfs07,",
                   "       sfs08,sfs09,sfs10,sfs26,ima02,ima021,img10,sfs012,sfs013,ta_ima04,ta_ima06,ecd02,sfa05,sfa065,sfa06 ", #No.FUN-710082 add ima021   #FUN-A60027 add sfs012,sfs013
                   "  FROM sfs_file left join ima_file on sfs_file.sfs04=ima_file.ima01 ",
                   "  left join ecd_file on sfs10=ecd01 ",
                   "  left join img_file on sfs_file.sfs04=img_file.img01  AND  sfs_file.sfs07=img_file.img02  AND  sfs_file.sfs08=img_file.img03  AND  sfs_file.sfs09=img_file.img04  ",
                   "  left join sfa_file on sfs_file.sfs03=sfa_file.sfa01 AND sfs_file.sfs04=sfa_file.sfa03 AND sfs_file.sfs06=sfa_file.sfa12 AND sfs_file.sfs10=sfa_file.sfa08 AND sfs_file.sfs27=sfa_file.sfa27 ",   
                   "  AND sfs_file.sfs012 = sfa_file.sfa012 AND sfs_file.sfs013 = sfa_file.sfa013 ", 
                   "  WHERE sfs01='",l_sfp.sfp01,"'",                  
                   "  ORDER BY sfs02"
      ELSE
         LET l_sql="SELECT '','',sfe28,sfe01,sfe07,sfe16,sfe17,sfe08,",
                   "       sfe09,sfe10,sfe14,sfe26,ima02,ima021,img10,sfe012,sfe013,ta_ima04,ta_ima06,ecd02,sfa05,sfa065,sfa06 ",  #No.FUN-710082 add ima021    #FUN-A60027 add sfe012,sfe013
                --   "  FROM sfe_file left join ima_file on sfe_file.sfe04=ima_file.ima01 ",
                   "  FROM sfe_file left join ima_file on sfe_file.sfe07=ima_file.ima01 ",
                   "  left join ecd_file on sfe14=ecd01 ",
                   "  left join img_file on sfe_file.sfe07=img_file.img01 AND sfe_file.sfe08=img_file.img02  AND sfe09=img_file.img03 AND  sfe_file.sfe10=img_file.img04 ", 
                   "  left join sfa_file on sfe_file.sfe01=sfa_file.sfa01 AND sfe_file.sfe07=sfa_file.sfa03 AND sfe_file.sfe17=sfa_file.sfa12 AND sfe_file.sfe14=sfa_file.sfa08 AND sfe_file.sfe27=sfa_file.sfa27",   #09/10/21 xiaofeizhu Add
                   "  AND  sfe_file.sfe012 = sfa_file.sfa012 AND sfe_file.sfe013 = sfa_file.sfa013 ",  #FUN-A60028                    
                   "  WHERE sfe02='",l_sfp.sfp01,"'",
                   "  ORDER BY sfe28"
      END IF
      PREPARE r501_pr2 FROM l_sql
      IF STATUS THEN CALL cl_err('prepare2:',STATUS,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM 
      END IF
      DECLARE r501_cs2 CURSOR FOR r501_pr2
      LET i=1
      LET l_sfs04_t = ''
      FOREACH r501_cs2 INTO sr.*
         #UPDATE列印碼
         #add by zhangym 130111 begin-----
         SELECT SUM(sfs05) INTO l_sfs05 FROM sfp_file,sfs_file 
          WHERE sfs01 = sfp01 AND sfs03 = sr.sfs03 
            AND sfs04 = sr.sfs04 AND sfp04 = 'N' 
            AND sfpconf != 'X'
         IF cl_null(l_sfs05) THEN  
            LET l_sfs05 = 0
         END IF
         #IF l_sfs05 + sr.sfa06 > sr.sfa05 THEN 
         #   CALL cl_err(sr.sfs04,'csf-916',1)
            #EXIT FOREACH 
         #END IF 
         #add by zhangym 130111 end-----         
        #mod by zhangym 120629 begin-----
         SELECT ta_ima21,ta_ima22 INTO l_agd03_3,l_agd03_5 FROM ima_file WHERE ima01 = sr.sfs04
        # SELECT DISTINCT agd03 INTO l_agd03_3 FROM agd_file WHERE agd02=sr.ta_ima04    
        # SELECT DISTINCT agd03 INTO l_agd03_5 FROM agd_file WHERE agd02=sr.ta_ima06
        #mod by zhangym 120629 end-----            
         UPDATE sfp_file SET sfp05='Y' WHERE sfp01=l_sfp.sfp01
         IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
            CALL cl_err3("upd","sfp_file",l_sfp.sfp01,"",STATUS,"","upd sfp_file",1)    #No.FUN-660128
         END IF
         IF sr.sfs04 = l_sfs04_t THEN
            LET l_a = 'Y'
         ELSE
            LET l_a = 'N'
         END IF 
         LET l_sfpud02 = ''
         SELECT sfpud02 INTO l_sfpud02 FROM sfp_file WHERE sfp01 = l_sfp.sfp01
         IF l_sfpud02 = 'Y' THEN 
            LET l_b = 'Y'
         ELSE
            LET l_b = 'N'
         END IF 
         LET l_c = 'N'
         EXECUTE insert_prep USING                                                                                                 
            l_sfp.sfp01,l_sfp.sfp02,l_sfp.sfp03,l_sfp.sfp06,l_sfp.sfp07,                                                           
            l_sfp.sfp08,l_ima23,    l_gem02,    l_gen02,flag ,l_gem02,
            l_sfq.sfq01,l_sfq.sfq02,l_sfq.sfq03,l_sfq.sfq04,
            l_sfb.sfb05,l_sfb.sfb08,l_sfb.sfb081,l_sfb.sfb09,
            l_ima02,l_ima021,
            l_sfp.sfp01,sr.sfs02,sr.sfs03, sr.sfs04,sr.sfs05,
            sr.sfs06,   sr.sfs07,sr.sfs08, sr.sfs09,sr.sfs10,
            sr.sfs26,   sr.ima02,sr.ima021,sr.img10,sr.sfs012,sr.sfs013    #FUN-A60027 add sfs012,sfs013
            ,sr.ta_ima04,sr.ta_ima06,sr.azf03,l_agd03_3,l_agd03_5 
            ,sr.sfa05,sr.sfa065,l_a,l_b,l_c   
          
         LET l_sfs04_t = sr.sfs04   
      END FOREACH

   END FOREACH
                                                  
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05 = 'Y' THEN                                                         
      CALL cl_wcchp(tm.wc,'sfp01,sfp02,sfp03,sfp06,sfp07')  
      RETURNING tm.wc                                                           
   ELSE
      LET tm.wc = ' '
   END IF                      
   LET g_str = tm.wc CLIPPED,";",g_zz05 CLIPPED,";",tm.q,";",tm.p,";",tm.c    #No.FUN-860026   add tm.c
 
   IF tm.p = 'N' THEN   #不依倉管員跳頁
      IF g_sma.sma541 = 'Y' THEN                                   #FUN-A60027
         CALL cl_prt_cs3('csfr501','csfr501',g_sql,g_str)        #FUN-A60027
      ELSE                                                         #FUN-A60027 
         CALL cl_prt_cs3('csfr501','csfr501',g_sql,g_str) 
      END IF                                                       #FUN-A60027	
   ELSE
      IF g_sma.sma541 = 'Y' THEN                                   #FUN-A60027
         CALL cl_prt_cs3('csfr501','csfr501',g_sql,g_str)        #FUN-A60027
      ELSE                                                         #FUN-A60027
         CALL cl_prt_cs3('csfr501','csfr501',g_sql,g_str) 
      END IF                                                       #FUN-A60027
   END IF

END FUNCTION
 


 




