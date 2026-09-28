# Prog. Version..:
#
# Pattern name...: cxmr400.4gl
# Descriptions...: 预测单打印
# Date & Author..: 16/07/11 By huanglf
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
 
   IF (NOT cl_setup("CXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  
  
   LET g_sql="oea03.oea_file.oea03,",
             "oea032.oea_file.oea032,",
             "oea02.oea_file.oea02,",
             "zo05.zo_file.zo05,",
             "zo09.zo_file.zo09,",
             
             "oea23.oea_file.oea23,",
             "oeb11.oeb_file.oeb11,",
             "oeb12.oeb_file.oeb12,",
             "oeb13.oeb_file.oeb13,",
             "oeb13t.oeb_file.oeb13,",
             
             "oeb14.oeb_file.oeb14,",
             "oeb14t.oeb_file.oeb14t,",
             "oeb15.oeb_file.oeb15,",
             "oea01.oea_file.oea01,",
             "oeb03.oeb_file.oeb03,",

             "oeb04.oeb_file.oeb04,",
             "occ18.occ_file.occ18,",
             "oea10.oea_file.oea10,",
             "oeb06.oeb_file.oeb06,",
             "oebud04.oeb_file.oebud04,",
             "ima94.ima_file.ima94,",
             
             "oebud11.oeb_file.oebud11"
   LET  l_table = cl_prt_temptable('cxmr400',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)"                     
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
      THEN CALL cxmr400_tm(0,0)          
      ELSE
           CALL cxmr400()                
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN


FUNCTION cxmr400_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
DEFINE p_row,p_col    LIKE type_file.num5,        
       l_cmd        LIKE type_file.chr1000      
 
   LET p_row = 9 LET p_col = 8
 
   OPEN WINDOW cxmr400_w AT p_row,p_col WITH FORM "cxm/42f/cxmr400"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
  
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1' 
 
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oea01,oea02
                              
     
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
              WHEN INFIELD(oea01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_oea11"  #No.TQC-5B0095
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oea01
                 NEXT FIELD oea01
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
      LET INT_FLAG = 0 CLOSE WINDOW cxmr400_w 
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
      LET INT_FLAG = 0 CLOSE WINDOW cxmr400_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='cxmr400'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('cxmr400','9031',1)
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
         CALL cl_cmdat('cxmr400',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW cxmr400_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL cxmr400()
   ERROR ""
END WHILE
   CLOSE WINDOW cxmr400_w
END FUNCTION


FUNCTION cxmr400()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
          l_sql     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(3000)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          l_zo041   LIKE zo_file.zo041,   #FUN-810029 add
          l_zo042   LIKE zo_file.zo042,
          l_zo05    LIKE zo_file.zo05,     #FUN-810029 add
          l_zo09    LIKE zo_file.zo09,     #FUN-810029 add
          sr        RECORD
                    oea03    LIKE oea_file.oea03,    #客户编号
                    oea032   LIKE oea_file.oea032,   #客户名称
                    oea02    LIKE oea_file.oea02,    #合约单号
                    zo05     LIKE zo_file.zo05,      #电话
                    zo09     LIKE zo_file.zo09,      #传真

                    oea23    LIKE oea_file.oea23,    #币别
                    oeb11    LIKE oeb_file.oeb11,    #客户料号
                    oeb12    LIKE oeb_file.oeb12,    #数量
                    oeb13    LIKE oeb_file.oeb13,    #税前单价
                    oeb13t   LIKE oeb_file.oeb13,    #税后单价

                    oeb14    LIKE oeb_file.oeb14,    #税前金额
                    oeb14t   LIKE oeb_file.oeb14t,   #税后金额
                    oeb15    LIKE oeb_file.oeb15,    #交货日期
                    oea01    LIKE oea_file.oea01,    #订单单号
                    oeb03    LIKE oeb_file.oeb03,    #项次
                    
                    oeb04    LIKE oeb_file.oeb04,     #Forewin料号
                    occ18    LIKE occ_file.occ18,    #
                    oea10    LIKE oea_file.oea10,    #客户订单
                    oeb06    LIKE oeb_file.oeb06,    #品名
                    oebud04  LIKE oeb_file.oebud04,
                    ima94    LIKE ima_file.ima94,

                    oebud11  LIKE oeb_file.oebud11
                    END RECORD
   DEFINE l_cnt     LIKE type_file.num5  
   DEFINE l_tc_ogd08  LIKE type_file.chr20
   DEFINE l_tc_ogd07  LIKE type_file.chr20

   DEFINE l_price LIKE ogb_file.ogb13

   DEFINE l_img_blob     LIKE type_file.blob
   LOCATE l_img_blob IN MEMORY             
 

     CALL cl_del_data(l_table) 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='cxmr400' 
 
     LET tm.wc = tm.wc CLIPPED 
     
--LET l_sql="select oea03,oea032,oea02,'','',oea23,oeb11,oeb12,
                       --(case
                         --when oea213 = 'Y' then
                          --case
                         --when oeb12 = 0 then
                          --0
                         --else
                          --oeb14 / oeb12
                       --end when oea213 = 'N' then oeb13 end) as oeb13,
                       --(case
                         --when oea213 = 'Y' then
                          --oeb13
                         --when oea213 = 'N' then
                          --case
                         --when oeb12 = 0 then
                          --0
                         --else
                          --oeb14 / oeb12
                       --end end) as oeb13t,oeb14,oeb14t,oeb15,oea01,oeb03,oeb04,occ18,oea10,oeb06,oebud04,oebud11",
           --" from oea_file left join occ_file on occ01=oea03,oeb_file",
           --" where ",tm.wc,"and oea01=oeb01"
    LET l_sql="select oea03,oea032,oea02,'','',oea23,oeb11,oeb12,oeb13,'',oeb14,oeb14t,oeb15,oea01,oeb03,oeb04,occ18,oea10,oeb06,oebud04,ima94,oebud11",
           " from oea_file left join occ_file on occ01=oea03,oeb_file,ima_file",
           " where ",tm.wc,"and oea01=oeb01 and oeb04=ima01 "
 
     PREPARE cxmr400_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM 
     END IF
     DECLARE cxmr400_curs1 CURSOR FOR cxmr400_prepare1
    
     FOREACH cxmr400_curs1 INTO sr.*
     IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF  
        SELECT zo05,zo09 INTO sr.zo05,sr.zo09 FROM zo_file
        EXECUTE insert_prep USING sr.*
     END FOREACH
  
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'oea01')
             RETURNING tm.wc
     END IF
     LET g_str = tm.wc

     CALL cl_prt_cs3('cxmr400','cxmr400',g_sql,g_str)

END FUNCTION



