# Prog. Version..:
#
# Pattern name...: csfr007.4gl
# Descriptions...: 成套发料单打印
# Date & Author..: 16/08/03 By jixf
#HFBG-16030001
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

DEFINE tm  RECORD                               
              wc      LIKE type_file.chr1000,      
              more    LIKE type_file.chr30         
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
  
   LET g_sql="sfp01.sfp_file.sfp01,",
             "sfq02.sfq_file.sfqud01,", #mod darcy:2022/04/25
             "sfq03.sfq_file.sfqud01,", #mod darcy:2022/04/25
             "sfb05.sfb_file.sfb05,",
             "ima02.ima_file.ima02,",
             
             "ima021.ima_file.ima021,",
             "sfb08.sfb_file.sfb08,",
             "sfb22.sfb_file.sfb22,",
             "sfe28.sfe_file.sfe28,",
             "sfe07.sfe_file.sfe07,",

             "ima02_1.ima_file.ima02,",
             "ima021_1.ima_file.ima021,",
             "sfa05.sfa_file.sfa05,",
             "sfa06.sfa_file.sfa06,",
             "num1.sfa_file.sfa06,",

             "sfe16.sfe_file.sfe16,",
             "sfe17.sfe_file.sfe17,",
             "sfeud02.sfe_file.sfeud02,",
             "imd02.imd_file.imd02,",
             #darcy:2023/04/27 add s---
             "sfe08.sfe_file.sfe08,",

             "sfe09.sfe_file.sfe09,",
             "sfe10.sfe_file.sfe10,",
             #darcy:2023/04/27 add e---
             "sfe11.sfe_file.sfe11,",
             "title.type_file.chr1000,",
             "sfp06.sfp_file.sfp06,",   #add by guanyao160826

             "sfeud07.sfe_file.sfeud07,", #add by guanyao160909
             "num2.type_file.num5,",      #add by huanglf160913 
             "imaud10.ima_file.imaud10,",
             "l_flag.type_file.chr1,",
             "sfp02.sfp_file.sfp02,",  #add by huanglf161008

             "sfpuser.sfp_file.sfpuser,", #add by huanglf161008
             "gen02.gen_file.gen02"  #add by huanglf161008

   LET  l_table = cl_prt_temptable('csfr007',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,? ,?,?)"         #add ? by guanyao160826    #add ? by guanyao160909               
   PREPARE insert_prep FROM g_sql                               #add by huanglf160913
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
   LET tm.more = ARG_VAL(8)
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12) 
   
   IF cl_null(tm.wc)
      THEN CALL csfr007_tm(0,0)          
      ELSE
           CALL csfr007()                
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN


FUNCTION csfr007_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
DEFINE p_row,p_col    LIKE type_file.num5,        
       l_cmd        LIKE type_file.chr1000      
 
   LET p_row = 9 LET p_col = 8
 
   OPEN WINDOW csfr007_w AT p_row,p_col WITH FORM "csf/42f/csfr007"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
  
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1' 
 
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON sfp01,sfq02
                              
     
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
              WHEN INFIELD(sfp01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "cq_sfp"  #No.TQC-5B0095
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sfp01
                 NEXT FIELD sfp01
              WHEN INFIELD(sfq02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "cq_sfb"  #No.TQC-5B0095
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sfq02
                 NEXT FIELD sfq02

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
      LET INT_FLAG = 0 CLOSE WINDOW csfr007_w 
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
      LET INT_FLAG = 0 CLOSE WINDOW csfr007_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='csfr007'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('csfr007','9031',1)
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
                         " '",tm.more CLIPPED,"'"  ,            #MOD-650024 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('csfr007',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW csfr007_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL csfr007()
   ERROR ""
END WHILE
   CLOSE WINDOW csfr007_w
END FUNCTION


FUNCTION csfr007()
   DEFINE l_name    LIKE type_file.chr20,         
          l_sql     STRING,       #No.FUN-680137 VARCHAR(3000)
          l_sql1    STRING,                        #add by huanglf161008
          l_sfa161  LIKE sfa_file.sfa161,
          sr        RECORD
             sfp01   LIKE sfp_file.sfp01,
             sfq02   LIKE sfq_file.sfq02,
             sfq03   LIKE sfq_file.sfq03,
             sfb05   LIKE sfb_file.sfb05,
             ima02   LIKE ima_file.ima02,
             ima021  LIKE ima_file.ima021,
             sfb08   LIKE sfb_file.sfb08,
             sfb22   LIKE sfb_file.sfb22,
             sfe28   LIKE sfe_file.sfe28,
             sfe07   LIKE sfe_file.sfe07,
             ima02_1   LIKE ima_file.ima02,
             ima021_1   LIKE ima_file.ima021,
             sfa05      LIKE sfa_file.sfa05,
             sfa06      LIKE sfa_file.sfa06,
             num1       LIKE sfa_file.sfa06,
             sfe16      LIKE sfe_file.sfe16,
             sfe17      LIKE sfe_file.sfe17,
             sfeud02    LIKE sfe_file.sfeud02,
             imd02      LIKE imd_file.imd02,
             #darcy:2023/04/27 add s---
             sfe08      like sfe_file.sfe08,
             sfe09      like sfe_file.sfe09,
             sfe10      like sfe_file.sfe10,
             #darcy:2023/04/27 add e---
             sfe11      LIKE sfe_file.sfe11,
             title      LIKE type_file.chr1000,
             sfp06     LIKE sfp_file.sfp06,     #add by guanyao160826
             sfeud07   LIKE sfe_file.sfeud07,   #add by guanyao160909
             num2      LIKE type_file.num5,     #add by huanglf160913
             imaud10   LIKE ima_file.imaud10,   #add by huanglf160913
             l_flag    LIKE type_file.chr1,     #add by huanglf160913
             sfp02     LIKE sfp_file.sfp02,     #add by huanglf161008
             sfpuser   LIKE sfp_file.sfpuser,   #add by huanglf161008
             gen02     LIKE gen_file.gen02      #add by huanglf161008  
                    END RECORD
   DEFINE l_cnt     LIKE type_file.num5                       
   define l_where      string #darcy:2022/12/08 add
     CALL cl_del_data(l_table) 
 
     #SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='csfr007' 
 
     LET tm.wc = tm.wc CLIPPED 
     --LET l_sql=" SELECT sfp01,sfs03,0,sfb05,m.ima02,m.ima021,  sfb08,sfb22,sfs02,sfs04,n.ima02,   n.ima021,sfa05,sfa06,0,sfs05, ",
               --" sfs06,sfsud02,'',sfs21,'',sfp06,sfsud07,'','','' ",   #add sfp06 by guanyao160826  #add sfsud07 by guanyao160909 #add by huanglf160913
               --" FROM sfp_file,sfb_file LEFT JOIN ima_file m ON sfb05=m.ima01,sfa_file,sfs_file LEFT JOIN ima_file n ON sfs04=n.ima01 ",
               --" WHERE sfp01=sfs01 AND sfb01=sfa01 AND sfs04=sfa03 AND sfs10=sfa08 ",#str---add by huanglf160823
               --"  AND sfs03 = sfb01",
              # " AND sfpconf='N' ",
               --" AND ",tm.wc
               --"  order by sfp01,sfe28"
              # "ORDER BY sfp01,sfs02"
               --
     --LET l_sql=l_sql," union "," SELECT sfp01,sfe01,0,sfb05,m.ima02,m.ima021,  sfb08,sfb22,sfe28,sfe07,n.ima02,   n.ima021,sfa05,sfa06,0,sfe16, ",
               --" sfe17,sfeud02,'',sfe11,'',sfp06,sfeud07,'','','' ", #add sfp06 by guanyao160826 #add sfeud07 by guanyao160909 #add by huanglf160913
               --" FROM sfp_file,sfb_file LEFT JOIN ima_file m ON sfb05=m.ima01,sfa_file,sfe_file LEFT JOIN ima_file n ON sfe07=n.ima01 ",
               --" WHERE sfp01=sfe02 AND sfb01=sfa01 AND sfe07=sfa03 ",
               --" AND sfpconf='Y' AND sfp04='Y' ",
               --"  AND sfe01 = sfb01",
               --" AND ",tm.wc
              # "  order by sfp01,sfe28" 
               #"ORDER BY sfp01,sfe28"


#str----add by huanglf161008      # sum(sfa05)->sfa05  tianry  add 161114        这下面
# LET l_sql=" SELECT sfp01,'',0,'','','',sum(sfb08),'','',sfs04,n.ima02, n.ima021,sfa05,sum(sfa06),0,sum(sfs05), ",
       LET l_sql=" SELECT sfp01,'', ''  ,'','','',sfb08,'','',sfs04,n.ima02, n.ima021,sfa05,sfa06,0,sum(sfs05), ",
               " sfs06,sfsud02,'',sfs07,sfs08,sfs09,sfs21,'',sfp06,sum(sfsud07),'','','','','','' ",   #add by huanglf161008 #add sfp06 by guanyao160826  #add sfsud07 by guanyao160909 #add by huanglf160913
               " FROM sfp_file,sfb_file LEFT JOIN ima_file m ON sfb05=m.ima01,sfa_file,sfs_file LEFT JOIN ima_file n ON sfs04=n.ima01 ",
               # " LEFT JOIN sfq_file ON sfq01 =sfs01 AND sfq02 = sfs03 ",#darcy:2022/04/25 add #darcy:2022/04/26 mark
               " WHERE sfp01=sfs01 AND sfb01=sfa01 AND sfs04=sfa03 AND sfs10=sfa08 ",#str---add by huanglf160823
               " AND sfs27 = sfa27", #darcy:2022/07/29 add
               "  AND sfs03 = sfb01",
               " AND ",tm.wc,
               # " AND sfp01='",sr.sfp01,"' ", #darcy:2023/08/31 add
               # " AND ((sfp06 ='1' and sfsud02 in ('S001','S003','S005','K001','YP001','YP002')) or (sfp06 !='1')) ", #darcy:2022/12/08 add
               " GROUP BY sfp01,sfb08,sfs04,n.ima02,n.ima021,sfa05,sfa06,sfs06,sfsud02,sfs07,sfs08,sfs09,sfs21,sfp06"

                                               # sum(sfa05)->sfa05  tianry  add 161114        这下面
# LET l_sql=l_sql," union "," SELECT sfp01,'',0,'','','',sum(sfb08),'','',sfe07,n.ima02,n.ima021,sfa05,sum(sfa06),0,sum(sfe16),",

   LET l_sql=l_sql," union "," SELECT sfp01,'',''  ,'','','',sfb08,'','',sfe07,n.ima02,n.ima021,sfa05,sfa06,0,sum(sfe16),",
               " sfe17,sfeud02,'',sfe08,sfe09,sfe10,sfe11,'',sfp06,sum(sfeud07),'','','','','','' ", #add by huanglf161008 #add sfp06 by guanyao160826 #add sfeud07 by guanyao160909 #add by huanglf160913
               " FROM sfp_file,sfb_file LEFT JOIN ima_file m ON sfb05=m.ima01,sfa_file,sfe_file LEFT JOIN ima_file n ON sfe07=n.ima01 ",
               # " LEFT JOIN sfq_file ON sfq01 =sfe02 AND sfq02 = sfe01 ", #darcy:2022/04/25 add #darcy:2022/04/26 mark
               " WHERE sfp01=sfe02 AND sfb01=sfa01 AND sfe14=sfa08 AND sfe07=sfa03 ",
               " AND sfa27 = sfe27 ", #darcy:2022/07/29 add
               " AND sfpconf='Y' AND sfp04='Y' ",
               "  AND sfe01 = sfb01",
               " AND ",tm.wc,
               # " AND sfp01='",sr.sfp01,"' ", #darcy:2023/08/31 add
               # " AND ((sfp06 ='1' and sfeud02 in ('S001','S003','S005','K001','YP001','YP002')) or (sfp06 !='1')) ", #darcy:2022/12/08 add
               " GROUP BY sfp01,sfb08,sfe07,n.ima02,sfa05,sfa06,n.ima021,sfe17,sfeud02,sfe08,sfe09,sfe10,sfe11,sfp06"

    
#str----end by huanglf161008
  
     PREPARE csfr007_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM 
     END IF
     DECLARE csfr007_curs1 CURSOR FOR csfr007_prepare1
 
     FOREACH csfr007_curs1 INTO sr.*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF

#str----add by huanglf161008
LET l_sql1 =  "SELECT sfs03,sfb05,m.ima02,m.ima021,sfb22,sfs02",
               " FROM sfp_file,sfb_file LEFT JOIN ima_file m ON sfb05=m.ima01,sfa_file,sfs_file ",
               " WHERE sfp01=sfs01 AND sfb01=sfa01 AND sfs04=sfa03 AND sfs10=sfa08 ",#str---add by huanglf160823
               "  AND sfs03 = sfb01",
               " AND ",tm.wc," AND sfs04 = '",sr.sfe07,"'"
               ," AND sfp01='",sr.sfp01,"' " #darcy:2023/08/31 add

 LET l_sql1 = l_sql1," union "," SELECT sfe01,sfb05,m.ima02,m.ima021,sfb22,sfe28",
               " FROM sfp_file,sfb_file LEFT JOIN ima_file m ON sfb05=m.ima01,sfa_file,sfe_file ",
               " WHERE sfp01=sfe02 AND sfb01=sfa01 AND sfe07=sfa03 ",
               " AND sfpconf='Y' AND sfp04='Y' ",
               "  AND sfe01 = sfb01",
               " AND ",tm.wc," AND sfe07 = '",sr.sfe07,"'"
               ," AND sfp01='",sr.sfp01,"' " #darcy:2023/08/31 add
    PREPARE csfr007_prepare2 FROM l_sql1
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM 
     END IF
     DECLARE csfr007_curs2 CURSOR FOR csfr007_prepare2
 
     FOREACH csfr007_curs2 INTO sr.sfq02,sr.sfb05,sr.ima02,sr.ima021,sr.sfb22,sr.sfe28
     
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        EXIT FOREACH
     END FOREACH 
    SELECT sfp02,sfpuser INTO sr.sfp02,sr.sfpuser FROM sfp_file WHERE sfp01 = sr.sfp01
    SELECT gen02 INTO sr.gen02 FROM gen_file WHERE gen01 = sr.sfpuser
#str----end by huanglf161008
        SELECT sfa161 INTO l_sfa161 FROM sfa_file WHERE sfa01=sr.sfq02 AND sfa03=sr.sfe07
        LET sr.num1=l_sfa161*sr.sfq03
        IF tm.more = '1' THEN LET sr.title = '生产发料单' END IF 
        IF tm.more = '2' THEN LET sr.title = '超领发料单' END IF 
        IF tm.more = '3' THEN LET sr.title = '欠料补料单' END IF 
        IF tm.more = '6' THEN LET sr.title = '成套退料单' END IF 
        IF tm.more = '7' THEN LET sr.title = '超领退料单' END IF 
        IF tm.more = '8' THEN LET sr.title = '一般退料单' END IF 
        IF tm.more = '9' THEN LET sr.title = '工单领退料' END IF 
        IF tm.more = '10' THEN 
        SELECT imaud10 INTO sr.imaud10 FROM ima_file WHERE ima01 =sr.sfe07
               LET sr.title = '生产发料单' 
               IF sr.imaud10 IS NOT NULL THEN 
                  LET sr.num2 = sr.sfeud07/sr.imaud10 
               ELSE 
                  LET sr.num2 = ''
               END IF 
               LET sr.l_flag = '1'
        END IF         
        SELECT imd02 INTO sr.imd02 FROM imd_file WHERE imd01=sr.sfeud02
        #darcy:2023/04/27 add s---
        # 没有库位找调拨单
      #   if cl_null(sr.sfe09) then
         select imn05 into sr.sfe09 from imn_file,imm_file where imn01 =imm01 
            and imm09 = sr.sfp01 and imm03 ='Y' and imn03 = sr.sfe07 and imn06 = sr.sfe10
      #   end if
        
        if sr.sfeud02 = 'XBC' then
         let sr.sfe09 = ''
        end if

        #darcy:2023/04/27 add e---
        
        EXECUTE insert_prep USING sr.*
     END FOREACH

     #darcy:2022/04/25 s---
     LET g_sql = " MERGE INTO ",g_cr_db_str CLIPPED,l_table CLIPPED," a  USING ( ",
                 "  SELECT listagg(sfq02,',') within group(order by '') sfq02,listagg(sfq03,',') within group(order by '') sfq03 from ",
                 "( select unique sfq02,sfq03 from sfq_file,sfp_file where sfp01=sfq01 and  ",tm.wc," )",
                 "  ) b ON (1=1)  WHEN MATCHED THEN UPDATE SET a.sfq02 = b.sfq02 , a.sfq03=b.sfq03 "
     prepare r007_sfq03 FROM g_sql
     EXECUTE r007_sfq03
     #darcy:2022/04/25 e---
 
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'shm01')
             RETURNING tm.wc
     END IF
     LET g_str = tm.wc
     #CALL cl_prt_cs3('csfr007','csfr007',g_sql,g_str) #mark by wangxt170411
#add by wangxt170411--str
     CASE tm.more 
        WHEN '1' 
            CALL cl_prt_cs3('csfr007','csfr007',g_sql,g_str)
        WHEN '3' 
            CALL cl_prt_cs3('csfr007','csfr007_1',g_sql,g_str)
        OTHERWISE
            CALL cl_prt_cs3('csfr007','csfr007',g_sql,g_str)
     END CASE
#add by wangxt170411---end  
END FUNCTION



