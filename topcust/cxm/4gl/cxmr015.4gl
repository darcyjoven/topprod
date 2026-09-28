# Prog. Version..:
#
# Pattern name...: cxmr015.4gl
# Descriptions...: 销售发票单打印
# Date & Author..: 16/08/30 By guanyao
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
 
   IF (NOT cl_setup("CXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  

   LET g_sql="omf21.omf_file.omf21,",
             "omf11.omf_file.omf11,",
             "omf25.omf_file.omf25,",
             "omf13.omf_file.omf13,",
             "omf14.omf_file.omf14,",

             "omf15.omf_file.omf15,",
             "omf17.omf_file.omf17,",
             "omf16.omf_file.omf16,",
             "omf28.omf_file.omf28,",
             "omf28_t.omf_file.omf28,",

             "omf29.omf_file.omf29,",
             "omf29x.omf_file.omf29x,",
             "omf29t.omf_file.omf29t,",
             "omf32.omf_file.omf32,",
             "gen02.gen_file.gen02,",
             
             "omf05.omf_file.omf05,",
             "occ18.occ_file.occ18,",
             "omf07.omf_file.omf07,",
             "omf03.omf_file.omf03,",
             "omf00.omf_file.omf00,",
             
             "omf061.omf_file.omf061,",
             "omf22.omf_file.omf22,",
             "omf30.omf_file.omf30,",
             "omf31.omf_file.omf31,",
             "oga03.oga_file.oga03"  #add by huanglf170314
             
             

   LET  l_table = cl_prt_temptable('cxmr015',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?)"                     
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
      THEN CALL cxmr015_tm(0,0)          
      ELSE
           CALL cxmr015()                
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN


FUNCTION cxmr015_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
DEFINE p_row,p_col    LIKE type_file.num5,        
       l_cmd        LIKE type_file.chr1000      
 
   LET p_row = 9 LET p_col = 8
 
   OPEN WINDOW cxmr015_w AT p_row,p_col WITH FORM "cxm/42f/cxmr015"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
  
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1' 
 
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON omf00,omf03
                              
     
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
            WHEN INFIELD(omf00)
               CALL q_omf1(TRUE,TRUE,'','') RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO omf00
               NEXT FIELD omf00
               OTHERWISE
               EXIT CASE
            END CASE
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      ON ACTION EXIT
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
      LET INT_FLAG = 0 CLOSE WINDOW cxmr015_w 
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
      LET INT_FLAG = 0 CLOSE WINDOW cxmr015_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='cxmr015'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('cxmr015','9031',1)
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
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('cxmr015',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW cxmr015_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL cxmr015()
   ERROR ""
END WHILE
   CLOSE WINDOW cxmr015_w
END FUNCTION


FUNCTION cxmr015()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
          l_sql     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(3000)
          l_sql1    LIKE type_file.chr1000,
          l_wc    LIKE type_file.chr1000,
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          l_zo041   LIKE zo_file.zo041,   #FUN-810029 add
          l_zo042   LIKE zo_file.zo042,
          l_zo05    LIKE zo_file.zo05,     #FUN-810029 add
          l_zo09    LIKE zo_file.zo09,     #FUN-810029 add
          l_ogb03   LIKE ogb_file.ogb03,
          l_ogb03_1 LIKE ogb_file.ogb03,
          l_oga01_t LIKE oga_file.oga01,
          l_ima06   LIKE ima_file.ima06,
          sr        RECORD
             omf21   LIKE omf_file.omf21,
             omf11   LIKE omf_file.omf11,
             omf25   LIKE omf_file.omf25,
             omf13   LIKE omf_file.omf13,
             omf14   LIKE omf_file.omf14,
             omf15   LIKE omf_file.omf15,
             omf17   LIKE omf_file.omf17,
             omf16   LIKE omf_file.omf16,
             omf28   LIKE omf_file.omf28,
             omf28_t LIKE omf_file.omf28,
             omf29   LIKE omf_file.omf29,
             omf29x  LIKE omf_file.omf29x,
             omf29t  LIKE omf_file.omf29t,
             omf32   LIKE omf_file.omf32,
             gen02   LIKE gen_file.gen02,
             omf05   LIKE omf_file.omf05,
             occ18   LIKE occ_file.occ18,
             omf07   LIKE omf_file.omf07,
             omf03   LIKE omf_file.omf03,
             omf00   LIKE omf_file.omf00,
             omf061  LIKE omf_file.omf061,
             omf22   LIKE omf_file.omf22,
             omf30   LIKE omf_file.omf30,
             omf31   LIKE omf_file.omf31,
             oga03   LIKE oga_file.oga03  #add by huanglf170314
                    END RECORD
   DEFINE l_cnt     LIKE type_file.num5                  
 

     CALL cl_del_data(l_table) 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='cxmr015' 
 
     LET tm.wc = tm.wc CLIPPED 
     
   #公司全名zo02、公司地址zo041、公司電話zo05、公司傳真zo09
   LET l_zo041 = NULL  LET l_zo05 = NULL  LET l_zo09 = NULL
 
   LET l_sql = "SELECT omf21,omf11,omf25,omf13,omf14,omf15,omf17,omf16,omf28,0,omf29,omf29x,omf29t,",
               "       omf32,gen02,omf05,occ18,omf07,omf03,omf00,omf061,omf22,omf30,omf31,oga03",
               "  FROM omf_file LEFT JOIN gen_file ON gen01 = omf32",
               "                LEFT JOIN occ_file ON occ01 = omf05",
               "                LEFT JOIN oga_file ON omf11 = oga01",  #add by huanglf170314
               " WHERE ",tm.wc,
               " ORDER BY omf21" 
    
     PREPARE cxmr015_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM 
     END IF 

     DECLARE cxmr015_curs1 CURSOR FOR cxmr015_prepare1
     FOREACH cxmr015_curs1 INTO sr.* 
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET sr.omf28_t = sr.omf28*(100+sr.omf061)/100 #modify darcy:2022/10/25
        EXECUTE insert_prep USING sr.*
     END FOREACH
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'oga01,oga02')
             RETURNING tm.wc
     END IF
     LET g_str = tm.wc
     CALL cl_prt_cs3('cxmr015','cxmr015',g_sql,g_str)

END FUNCTION
