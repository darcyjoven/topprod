# Prog. Version..:
#
# Pattern name...: csfr012.4gl
# Descriptions...: 成套发料单打印
# Date & Author..: 16/08/03 By jixf
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
  
   LET g_sql="tc_sfd01.tc_sfd_file.tc_sfd01,",
             "tc_sfe02.tc_sfe_file.tc_sfe02,",
             "tc_sfe03.tc_sfe_file.tc_sfe03,",
             "sfb05.sfb_file.sfb05,",
             "ima02.ima_file.ima02,",
             "ima021.ima_file.ima021,",
             "imaud07.ima_file.imaud07,",
             "imaud10.ima_file.imaud10,",
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
             "sfe11.sfe_file.sfe11,",
             
             "title.type_file.chr1000,",
             "tc_sfd06.tc_sfd_file.tc_sfd06,", 
             "tc_sff07.tc_sff_file.tc_sff07,",
             "ecd02.ecd_file.ecd02,",
             "ecd07.ecd_file.ecd07,",

             "eca02.eca_file.eca02"
             ,",sfe27.sfe_file.sfe27" #darcy:2022/10/11 add
             ,",tc_sfdud01.tc_sfd_file.tc_sfdud01"
   LET  l_table = cl_prt_temptable('csfr012',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"  
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
   LET tm.more = ARG_VAL(8)
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12) 
   
   IF cl_null(tm.wc)
      THEN CALL csfr012_tm(0,0)          
      ELSE
           CALL csfr012()                
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN


FUNCTION csfr012_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
DEFINE p_row,p_col    LIKE type_file.num5,        
       l_cmd        LIKE type_file.chr1000      
 
   LET p_row = 9 LET p_col = 8
 
   OPEN WINDOW csfr012_w AT p_row,p_col WITH FORM "csf/42f/csfr012"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
  
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1' 
 
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON tc_sfd01,tc_sfe02
                              
     
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
              WHEN INFIELD(tc_sfd01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "cq_tc_sfd"  #No.TQC-5B0095
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_sfd01
                 NEXT FIELD tc_sfd01
              WHEN INFIELD(tc_sfe02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_sfb03"  #No.TQC-5B0095
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_sfe02
                 NEXT FIELD tc_sfe02

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
      LET INT_FLAG = 0 CLOSE WINDOW csfr012_w 
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
      LET INT_FLAG = 0 CLOSE WINDOW csfr012_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='csfr012'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('csfr012','9031',1)
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
         CALL cl_cmdat('csfr012',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW csfr012_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL csfr012()
   ERROR ""
END WHILE
   CLOSE WINDOW csfr012_w
END FUNCTION


FUNCTION csfr012()
   DEFINE l_name    LIKE type_file.chr20,         
          l_sql     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(3000)
          l_sfa161  LIKE sfa_file.sfa161,
          sr        RECORD
             tc_sfd01   LIKE tc_sfd_file.tc_sfd01,
             tc_sfe02   LIKE tc_sfe_file.tc_sfe02,
             tc_sfe03   LIKE tc_sfe_file.tc_sfe03,
             sfb05   LIKE sfb_file.sfb05,
             ima02   LIKE ima_file.ima02,
             
             ima021  LIKE ima_file.ima021,
	     imaud07  LIKE ima_file.imaud07,
             imaud10  LIKE ima_file.imaud10,
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
             sfe11      LIKE sfe_file.sfe11,

             title      LIKE type_file.chr1000,
             tc_sfd06     LIKE tc_sfd_file.tc_sfd06,
             tc_sff07     LIKE tc_sff_file.tc_sff07,
             ecd02      LIKE ecd_file.ecd02,
             ecd07      LIKE ecd_file.ecd07,
             
             eca02      LIKE eca_file.eca02,
             sfe27      like sfe_file.sfe27,   #darcy:2022/10/11 add
             tc_sfdud01   LIKE tc_sfd_file.tc_sfdud01 
                    END RECORD
   DEFINE l_cnt     LIKE type_file.num5  
   DEFINE l_tc_sfe03   LIKE tc_sfe_file.tc_sfe03    #add by guanyao160912
 
     CALL cl_del_data(l_table) 
 
     #SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='csfr012' 
 
     LET tm.wc = tm.wc CLIPPED 
     LET l_sql=" SELECT tc_sfd01,tc_sff03,0,sfb05,m.ima02,m.ima021, m.imaud07,m.imaud10, sfb08,sfb22,tc_sff02,tc_sff04,n.ima02,   n.ima021,sfa05,sfa06,0,tc_sff05, ",
               " tc_sff06,tc_sffud02,'',tc_sff08,'',tc_sfd06,tc_sff07,'','','' ",   #add tc_sfd06 by guanyao160826
               " ,tc_sff27,tc_sfdud01 ", #darcy:2022/10/11 add
               " FROM tc_sfd_file,ima_file j,sfb_file LEFT JOIN ima_file m ON sfb05=m.ima01,sfa_file,tc_sff_file LEFT JOIN ima_file n ON tc_sff04=n.ima01 ", #darcy:2022/12/09 mod add ima_file
               " WHERE tc_sfd01=tc_sff01 AND sfb01=sfa01 AND tc_sff04=sfa03 AND tc_sff07=sfa08 ",#str---add by huanglf160823
               "  AND tc_sff03 = sfb01",
	       " AND sfa27 = tc_sff27 ", #darcy:220412 add s---
               " AND ",tm.wc,
               " and j.ima01 = tc_sff04 and ( (tc_sff04 not like '%-%' and sfb05 not like  '%-%') OR (sfb05  like '%-%') or (j.ima08 = 'S') )   "#darcy:2022/12/08 add
               
     --LET l_sql=l_sql," union "," SELECT tc_sfd01,sfe01,0,sfb05,m.ima02,m.ima021, m.imaud07,m.imaud10,  sfb08,sfb22,sfe28,sfe07,n.ima02,   n.ima021,sfa05,sfa06,0,sfe16, ",
               --" sfe17,sfeud02,'',sfe11,'',tc_sfd06 ", #add tc_sfd06 by guanyao160826
               --" FROM tc_sfd_file,sfb_file LEFT JOIN ima_file m ON sfb05=m.ima01,sfa_file,sfe_file LEFT JOIN ima_file n ON sfe07=n.ima01 ",
               --" WHERE tc_sfd01=sfe02 AND sfb01=sfa01 AND sfe07=sfa03 ",
               --" AND tc_sfdconf='Y' AND tc_sfd04='Y' ",
               --"  AND sfe01 = sfb01",
               --" AND ",tm.wc
              # "  order by tc_sfd01,sfe28" 
               #"ORDER BY tc_sfd01,sfe28"
 
     PREPARE csfr012_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM 
     END IF
     DECLARE csfr012_curs1 CURSOR FOR csfr012_prepare1
 
     FOREACH csfr012_curs1 INTO sr.*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        #str---add by guanyao160912
        SELECT tc_sfe03 INTO sr.tc_sfe03 FROM tc_sfe_file
         WHERE tc_sfe02 = sr.tc_sfe02 
           #AND tc_sfe04 = sr.tc_sff07 
           AND tc_sfe01 = sr.tc_sfd01
        IF cl_null(sr.tc_sfe03) THEN LET sr.tc_sfe03 = 0 END IF 
        #SELECT tc_sfe03 INTO l_tc_sfe03 FROM tc_sfe_file   #tianry mark  没看明白这段累加的意义
        # WHERE tc_sfe02 = sr.tc_sfe02  
        #   AND tc_sfe01 = sr.tc_sfd01
        #darcy:2022/10/17 add s---
        if sr.sfe27 = sr.sfe07 then
         let sr.sfe27 = ""
        end if
        #darcy:2022/10/17 add e---
        IF cl_null(l_tc_sfe03) THEN 
           LET l_tc_sfe03 = 0
        END IF 
        LET sr.tc_sfe03 = sr.tc_sfe03+l_tc_sfe03
        #end---add by guanyao160912
        SELECT sfa161 INTO l_sfa161 FROM sfa_file WHERE sfa01=sr.tc_sfe02 AND sfa03=sr.sfe07
        LET sr.num1=l_sfa161*sr.tc_sfe03
        LET sr.title='工单发料单'
        SELECT ecd02,ecd07 INTO sr.ecd02,sr.ecd07 FROM ecd_file WHERE ecd01 = sr.tc_sff07
        SELECT eca02 INTO sr.eca02 FROM eca_file WHERE eca01 = sr.ecd07
        EXECUTE insert_prep USING sr.*
     END FOREACH
 
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'shm01')
             RETURNING tm.wc
     END IF
     LET g_str = tm.wc

     CALL cl_prt_cs3('csfr012','csfr012',g_sql,g_str)

END FUNCTION



