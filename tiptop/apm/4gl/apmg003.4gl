# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Pattern name...: apmg003.4gl
# Descriptions...: 關係人對帳交易明細表
# Date & Author..: 09/01/06 By jamie #FUN-890070 新增程式
# Modify.........: No.FUN-980020 09/09/01 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-A10098 10/01/20 By chenls 跨DB語法改成 cl_get_target_table(plant,table) ，
#                                                    且 prepare 前 CALL cl_parse_qry_sql(sql,plant )
# Modify.........: No.FUN-B80088 11/08/09 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-CB0073 12/12/02 By chenjing CR轉GR
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                      # Print condition RECORD
            wc      STRING,               # Where condition
            choice  LIKE type_file.chr1,
            d       LIKE type_file.chr1,                                  
            s       LIKE type_file.chr1,            
            bdate   LIKE type_file.dat,
            edate   LIKE type_file.dat,
            more    LIKE type_file.chr1            # Input more condition(Y/N)
          END RECORD,
    g_rec_plant     LIKE type_file.num5,              #工廠個數
    g_rec_b1        LIKE type_file.num5,              
    gg_aza17        LIKE aza_file.aza17,   #第一站的aza17
    g_plant_1       DYNAMIC ARRAY OF RECORD
                         no        LIKE azp_file.azp01,
                         db_name   LIKE azp_file.azp03,
                         cu_name   LIKE poz_file.poz04
                    END RECORD,
    sr_dy dynamic array of RECORD
       order1       LIKE type_file.chr20,    #merits add排列順序-1
       order2       LIKE type_file.chr20,    #merits add排列順序-2
       order3       LIKE type_file.chr20,    #merits add排列順序-3
       flow         LIKE poz_file.poz01,     
       flow_sn      LIKE oea_file.oea99,     
       ds_sn        LIKE type_file.num5,     
       oga02        LIKE oga_file.oga02,     #出貨日
       oma67        LIKE oma_file.oma67,     #invoice
       omb31        LIKE omb_file.omb31,     #出貨單號 
       oma03        LIKE oma_file.oma03,     #客戶號
       oma032       LIKE oma_file.oma032,    #客戶名稱
       oga021       LIKE oga_file.oga021,    #結關日
       oma54t       LIKE oma_file.oma54t,    #銷售金額 
       oma23        LIKE oma_file.oma23,     #幣別
       azj041       LIKE azj_file.azj041,    #匯率
       moneyntd     LIKE type_file.num20_6,  #銷貨NTD
       oma54t_1     LIKE oma_file.oma54t,    #高聯原幣(流程的第一站不顯示)
       commi        LIKE type_file.num20_6,  #佣金
       misc_ori     LIKE type_file.num20_6,  #MISC原幣
       misc_ntd     LIKE type_file.num20_6,  #MISC本幣
       azi07        LIKE azi_file.azi07,     #匯率取位
       azi04        LIKE azi_file.azi04,     #金額取位
       azicom       LIKE azi_file.azi04      #佣金取位
                      END RECORD
DEFINE   g_i        LIKE type_file.num5   #count/index for any purpose
DEFINE   g_sql      STRING
DEFINE   g_str      STRING
DEFINE   l_table    STRING
DEFINE   l_table1   STRING
DEFINE   l_table2   STRING
 
###GENGRE###START
TYPE sr1_t RECORD
    order1 LIKE type_file.chr20,
    order2 LIKE type_file.chr20,
    order3 LIKE type_file.chr20,
    flow LIKE poz_file.poz01,
    flow_sn LIKE oea_file.oea99,
    ds_sn LIKE type_file.num5,
    oga02 LIKE oga_file.oga02,
    oma67 LIKE oma_file.oma67,
    omb31 LIKE omb_file.omb31,
    oma03 LIKE oma_file.oma03,
    oma032 LIKE oma_file.oma032,
    oga021 LIKE oga_file.oga021,
    oma54t LIKE oma_file.oma54t,
    oma23 LIKE oma_file.oma23,
    azj041 LIKE azj_file.azj041,
    moneyntd LIKE type_file.num20_6,
    oma54t_1 LIKE oma_file.oma54t,
    commi LIKE type_file.num20_6,
    misc_ori LIKE type_file.num20_6,
    misc_ntd LIKE type_file.num20_6,
    azi07 LIKE azi_file.azi07,
    azi04 LIKE azi_file.azi04,
    azicom LIKE azi_file.azi04
 #  cu_name LIKE poz_file.poz04,     #FUN-CB0073 add
 #  poz02 LIKE poz_file.poz02 ,      #FUN-CB0073 add
 #  ds_sn1 LIKE type_file.num5       #FUN-CB0073 add    
END RECORD

TYPE sr2_t RECORD
    flow LIKE poz_file.poz01,
    flow_sn LIKE oea_file.oea99,
    ds_sn LIKE type_file.num5,
    aza17 LIKE aza_file.aza17,
    cu_name LIKE poz_file.poz04,
    poz02 LIKE poz_file.poz02
END RECORD

TYPE sr3_t RECORD
    l_flow LIKE poz_file.poz01,
    l_ds_sn LIKE type_file.num5,
    l_desc LIKE type_file.chr50,
    l_oma23 LIKE oma_file.oma23,
    l_oma54t LIKE oma_file.oma54t,
    l_moneyntd LIKE type_file.num20_6,
    l_commi LIKE type_file.num20_6,
    l_misc_ori LIKE type_file.num20_6,
    l_misc_ntd LIKE type_file.num20_6,
    l_azi05 LIKE azi_file.azi05,
    l_aza17 LIKE aza_file.aza17,
    l_azi05_2 LIKE azi_file.azi05
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                  # Supress DEL key function
 
   LET g_pdate = ARG_VAL(1)         # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.choice = ARG_VAL(8)   
   LET tm.d = ARG_VAL(9)   
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   LET g_sql = "order1.type_file.chr20,    order2.type_file.chr20,",
               "order3.type_file.chr20,    flow.poz_file.poz01,",
               "flow_sn.oea_file.oea99,    ds_sn.type_file.num5,",       
               "oga02.oga_file.oga02,      oma67.oma_file.oma67,",
               "omb31.omb_file.omb31,      oma03.oma_file.oma03,",
               "oma032.oma_file.oma032,    oga021.oga_file.oga021,",
               "oma54t.oma_file.oma54t,    oma23.oma_file.oma23,",
               "azj041.azj_file.azj041,    moneyntd.type_file.num20_6,",
               "oma54t_1.oma_file.oma54t,  commi.type_file.num20_6,",
               "misc_ori.type_file.num20_6,misc_ntd.type_file.num20_6,",
               "azi07.azi_file.azi07,      azi04.azi_file.azi04,",
               "azicom.azi_file.azi04,"
           #   "cu_name.poz_file.poz04,   poz02.poz_file.poz02,",     #FUN-CB0073 add
           #   "ds1_sn.type_file.num5"                                #FUN-CB0073 add 
   LET l_table = cl_prt_temptable('apmg003',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
 
  #變動表頭 
   LET g_sql = "flow.poz_file.poz01,      flow_sn.oea_file.oea99, ",
               "ds_sn.type_file.num5,     aza17.aza_file.aza17,",       
               "cu_name.poz_file.poz04,   poz02.poz_file.poz02"
   LET l_table1 = cl_prt_temptable('apmg0031',g_sql) CLIPPED
   IF  l_table1 = -1 THEN EXIT PROGRAM END IF
 
  #總計銷貨
   LET g_sql = "l_flow.poz_file.poz01,        l_ds_sn.type_file.num5,",       
               "l_desc.type_file.chr50,",
               "l_oma23.oma_file.oma23,       l_oma54t.oma_file.oma54t,", 
               "l_moneyntd.type_file.num20_6, l_commi.type_file.num20_6,",
               "l_misc_ori.type_file.num20_6, l_misc_ntd.type_file.num20_6,",  
               "l_azi05.azi_file.azi05,       l_aza17.aza_file.aza17,",  
               "l_azi05_2.azi_file.azi05"  
 
   LET l_table2 = cl_prt_temptable('apmg0032',g_sql) CLIPPED
   IF  l_table2 = -1 THEN EXIT PROGRAM END IF
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'    # If background job sw is off
      THEN CALL apmg003_tm(0,0)            # Input print condition
      ELSE CALL apmg003()                  # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
   CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)   #FUN-CB0073
END MAIN
 
FUNCTION apmg003_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd		 LIKE type_file.chr1000 
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 14 END IF
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 14
   ELSE 
      LET p_row = 4 LET p_col = 14
   END IF
 
   OPEN WINDOW apmg003_w AT p_row,p_col
        WITH FORM "apm/42f/apmg003"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.choice='1'
   LET tm.d = 'N'   
   LET tm.more = 'N'
   LET tm.bdate = g_today
   LET tm.edate = g_today
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.s = '1'
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON poz01,oea03
 
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(poz01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_poz5"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO poz01
                  NEXT FIELD poz01
         
               WHEN INFIELD(oea03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_occ"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO oea03
                    NEXT FIELD oea03
               OTHERWISE EXIT CASE
            END CASE
      
        ON ACTION locale
           CALL cl_show_fld_cont()      
           LET g_action_choice = "locale"
           EXIT CONSTRUCT
        
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
        
        ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
 
        ON ACTION help          #FUN-CB0073 
           CALL cl_show_help()  #FUN-CB0073
        ON ACTION qbe_select
           CALL cl_qbe_select()
 
        ON ACTION controlg                 
           CALL cl_cmdask()                
 
   END CONSTRUCT
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pozuser', 'pozgrup') #FUN-980030
 
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r630_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)   #FUN-CB0073
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
  
   INPUT BY NAME tm.bdate, tm.edate,tm.s, tm.more  
                   WITHOUT DEFAULTS
 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
   #################################                                               
   # START genero shell script ADD
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
   # END genero shell script ADD
   #################################                                               
 
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW apmg003_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)   #FUN-CB0073
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='apmg003'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmg003','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.choice CLIPPED,"'",   
                         " '",tm.d CLIPPED,"'",   
                         " '",tm.s CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",          
                         " '",g_rep_clas CLIPPED,"'",                         
                         " '",g_template CLIPPED,"'"                          
         CALL cl_cmdat('apmg003',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW apmg003_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)   #FUN-CB0073
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmg003()
   ERROR ""
END WHILE
   CLOSE WINDOW apmg003_w
END FUNCTION
 
FUNCTION apmg003()
   DEFINE l_name       LIKE type_file.chr20,        # External(Disk) file name
          l_sql        STRING,                      # RDSQL STATEMENT
          l_chr        LIKE type_file.chr1,
          l_poy02      LIKE poy_file.poy02,
          l_za05       LIKE type_file.chr50,
          l_v_str      LIKE type_file.chr50,
          l_order        ARRAY[3] OF LIKE type_file.chr20,
          l_oea904     LIKE oea_file.oea904,
          l_oea99      LIKE oea_file.oea99,
          l_poz01      LIKE poz_file.poz01,
          l_i          LIKE type_file.num5,
          l_str        STRING,
          l_str_plant  STRING,                      #FUN-980020
          l_oma          RECORD LIKE oma_file.*,
          l_oga01      LIKE oga_file.oga01,
          sr    RECORD
             order1    LIKE type_file.chr20,        #merits add排列順序-1
             order2    LIKE type_file.chr20,        #merits add排列順序-2
             order3    LIKE type_file.chr20,        #merits add排列順序-3
             flow      LIKE poz_file.poz01,
             flow_sn   LIKE oea_file.oea99,
             ds_sn     LIKE type_file.num5,
             oga02     LIKE oga_file.oga02,         #出貨日
             oma67     LIKE oma_file.oma67,         #invoice
             omb31     LIKE omb_file.omb31,         #出貨單號 
             oma03     LIKE oma_file.oma03,         #客戶號
             oma032    LIKE oma_file.oma032,        #客戶名稱
             oga021    LIKE oga_file.oga021,        #結關日
             oma54t    LIKE oma_file.oma54t,        #銷售金額 
             oma23     LIKE oma_file.oma23,         #幣別
             azj041    LIKE azj_file.azj041,        #匯率
             moneyntd  LIKE type_file.num20_6,      #銷貨NTD
             oma54t_1  LIKE oma_file.oma54t,        #高聯原幣(流程的第一站不顯示)
             commi     LIKE type_file.num20_6,      #佣金
             misc_ori  LIKE type_file.num20_6,      #MISC原幣
             misc_ntd  LIKE type_file.num20_6,      #MISC本幣
             azi07     LIKE azi_file.azi07,         #匯率取位
             azi04     LIKE azi_file.azi04,         #金額取位
             azicom    LIKE azi_file.azi04          #佣金取位
          END RECORD
   DEFINE l_apa14      LIKE apa_file.apa14,         # ap匯率
          l_wc         STRING              
 
   DEFINE l_flow       LIKE poz_file.poz01,
          l_ds_sn      LIKE type_file.num5,
          l_desc       LIKE type_file.chr50,
          l_oma23      LIKE oma_file.oma23,
          l_oma54t     LIKE oma_file.oma54t, 
          l_moneyntd   LIKE type_file.num20_6,
          l_commi      LIKE type_file.num20_6,
          l_misc_ori   LIKE type_file.num20_6, 
          l_misc_ntd   LIKE type_file.num20_6,  
          l_azi05      LIKE azi_file.azi05,         #原幣的總計小數取位
          l_aza17      LIKE aza_file.aza17, 
          l_azi05_2    LIKE azi_file.azi05          #本幣的總計小數取位
 
   DEFINE l_poz02      LIKE poz_file.poz02 
 
     DROP TABLE apmg003_tmp
#No.FUN-A10098 -----mark start
#     CREATE TEMP TABLE apmg003_tmp
#     ( t001   VARCHAR(40), #流程代號
#       t002   VARCHAR(40), #多角序號
#       t003   DEC(5,0),    #流程多角DB順序
#       t004   DEC(5,0),    #位置
#       t005   VARCHAR(40)  #表頭內容
#     )
#No.FUN-A10098 -----mark end
#No.FUN-A10098 -----add start
     CREATE TEMP TABLE apmg003_tmp
     ( t001   LIKE type_file.chr50,
       t002   LIKE type_file.chr50,
       t003   LIKE type_file.num5,
       t004   LIKE type_file.num5,
       t005   LIKE type_file.chr50)
#No.FUN-A10098 -----add end

 
     DELETE FROM apmg003_tmp
 
     #紀錄AFTER GROUP OF 流程代碼的總計值 STR
     DROP TABLE apmg003_tmp2
#No.FUN-A10098 -----mark start
#     CREATE TEMP TABLE apmg003_tmp2
#     (
#      flow       VARCHAR(10),    #流程
#      flow_sn    VARCHAR(17),    #多角序號
#      ds_sn      DEC(5,0),       #順序 
#      ds_sn_desc VARCHAR(40),    #poz04, poy03
#      oma23      VARCHAR(04),    #幣別
#      commi      DEC(20,6),      #佣金
#      misc_ori   DEC(20,6),      #misc_ori
#      misc_ntd   DEC(20,6),      #misc_ntd
#      moneyntd   DEC(20,6),      #moneyntd
#      oma54      DEC(20,6),      #銷貨原幣
#      azi01      VARCHAR(04)     #幣別
#     )
#No.FUN-A10098 -----mark end
#No.FUN-A10098 -----add start
     CREATE TEMP TABLE apmg003_tmp2(
      flow       LIKE type_file.chr10,
      flow_sn    LIKE type_file.chr20,
      ds_sn      LIKE type_file.num5,
      ds_sn_desc LIKE type_file.chr50,
      oma23      LIKE type_file.chr4,
      commi      LIKE type_file.num20_6,
      misc_ori   LIKE type_file.num20_6,
      misc_ntd   LIKE type_file.num20_6,
      moneyntd   LIKE type_file.num20_6,
      oma54      LIKE type_file.num20_6,
      azi01      LIKE type_file.chr10)
#No.FUN-A10098 -----add end
     DELETE FROM apmg003_tmp2
     #紀錄AFTER GROUP OF 流程代碼的總計值 END
 
     CALL cl_del_data(l_table)                                    
     CALL cl_del_data(l_table1)                                     
     CALL cl_del_data(l_table2)                                     
 
    #CR
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                 "        ?,?,? )"    #FUN-CB0073 add 3?
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert_prep:",STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)   #FUN-CB0073
        EXIT PROGRAM
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                 " VALUES(?,?,?,?,? ,?)"
     PREPARE insert_prep1 FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert_prep1:",STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)   #FUN-CB0073
        EXIT PROGRAM
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?)"
     PREPARE insert_prep2 FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert_prep2:",STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
        EXIT PROGRAM
     END IF
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'apmg003'
 
     LET l_sql = "SELECT DISTINCT poz01 FROM poz_file,oea_file ",
                 " WHERE ",tm.wc CLIPPED,
                 "   AND oea904 = poz01"
 
     DECLARE r003_cs1 CURSOR FROM l_sql
 
     FOREACH r003_cs1 INTO l_poz01
 
        #此流程要走的db由g_plant_1紀錄 Start
 
        CALL g_plant_1.clear()
        CALL sr_dy.clear()
        LET g_rec_plant = 1 #流程的第一筆
 
        SELECT poy04,poy03 
          INTO g_plant_1[g_rec_plant].no,  
               g_plant_1[g_rec_plant].cu_name #客戶編號
          FROM poy_file
         WHERE poy01 = l_poz01
           AND poy02 = '0'
 
        IF SQLCA.SQLCODE THEN
           CALL cl_err3("sel","poz_file",l_poz01,"","TSD0004","","",0) 
        ELSE
          SELECT azp03 INTO g_plant_1[g_rec_plant].db_name
             FROM azp_file WHERE azp01 = g_plant_1[g_rec_plant].no
        
          LET g_rec_plant = g_rec_plant + 1
        
          DECLARE r002_plant_cs CURSOR FOR
            SELECT poy02,poy04,poy03 FROM poy_file
             WHERE poy01 = l_poz01
               AND poy02 <> '0'
             ORDER BY poy02
        
          FOREACH r002_plant_cs INTO l_poy02,
                                     g_plant_1[g_rec_plant].no,
                                     g_plant_1[g_rec_plant].cu_name
            IF STATUS THEN
               CALL cl_err(l_poz01,'TSD0004',0) 
               EXIT FOREACH
            END IF
        
            SELECT azp03 INTO g_plant_1[g_rec_plant].db_name
              FROM azp_file WHERE azp01 = g_plant_1[g_rec_plant].no
        
            LET g_rec_plant = g_rec_plant + 1
 
          END FOREACH
 
          LET g_rec_plant = g_rec_plant - 1
        END IF
        #此流程要走的db由g_plant_1紀錄 END
 
        #抓此流程代碼合乎條件的多角序號 STR
        #LET l_sql = "SELECT DISTINCT oea99 FROM ",
        #第0站
        LET l_sql = "SELECT DISTINCT oma99 FROM ",
#No.FUN-A10098 -----mark start
#                     g_plant_1[1].db_name CLIPPED,".dbo.oma_file,",
#                     g_plant_1[1].db_name CLIPPED,".dbo.omb_file,",
#                     g_plant_1[1].db_name CLIPPED,".dbo.oea_file,",
#                     g_plant_1[1].db_name CLIPPED,".dbo.poz_file,",
#                     g_plant_1[1].db_name CLIPPED,".dbo.oga_file,",
#                     g_plant_1[1].db_name CLIPPED,".dbo.ogb_file",
#No.FUN-A10098 -----mark end
#No.FUN-A10098 -----add start
                     cl_get_target_table(g_plant_1[1].no,'oma_file'),",",
                     cl_get_target_table(g_plant_1[1].no,'omb_file'),",",
                     cl_get_target_table(g_plant_1[1].no,'oea_file'),",",
                     cl_get_target_table(g_plant_1[1].no,'poz_file'),",",
                     cl_get_target_table(g_plant_1[1].no,'oga_file'),",",
                     cl_get_target_table(g_plant_1[1].no,'ogb_file'),
#No.FUN-A10098 -----add end
                    " WHERE oea904 = poz01",
                    "   AND poz01 = '",l_poz01,"'",
                    "   AND oma00 = '12'",
                    "   AND oma01 = omb01",
                    "   AND omb31 = oga01",                 #出貨單
                    "   AND oga01 = ogb01",                 
                    "   AND ogb31 = oea01",                 #訂單
                    "   AND oga02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                    "   AND oma99 LIKE '",l_poz01,"%'"      #merits add
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #No.FUN-A10098  ---ADD
        CALL cl_parse_qry_sql(l_sql,g_plant_1[1].no) RETURNING l_sql  #FUN-A10098
        PREPARE r003_prepare1 FROM l_sql                  #FUN-A10098--add
#        DECLARE oea99_cs CURSOR FROM l_sql              #FUN-A10098---mark
        DECLARE oea99_cs CURSOR FOR r003_prepare1        #FUN-A10098--add                    
        FOREACH oea99_cs INTO l_oea99
          IF SQLCA.SQLCODE THEN
             CALL cl_err('foreach1:',SQLCA.SQLCODE,0)  
             EXIT FOREACH
          END IF
 
          INITIALIZE sr.* TO NULL
 
          #開始抓應收 -- 要照流程的db跑。STR
           FOR l_i = 1 TO g_rec_plant
 
             LET sr.flow = l_poz01
             LET sr.flow_sn = l_oea99
             LET sr.ds_sn = l_i
 
             LET l_sql = "SELECT *",
#                         "  FROM ",g_plant_1[l_i].db_name CLIPPED,".dbo.oma_file ",     #No.FUN-A10098
                         "  FROM ",cl_get_target_table(g_plant_1[l_i].no,'oma_file'),   #No.FUN-A10098 ---add
                         " WHERE oma00 = '12' ",
                         "   AND oma99 IN ('",l_oea99 CLIPPED,"')",
                         " ORDER BY oma01 "
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #No.FUN-A10098  ---ADD
             CALL cl_parse_qry_sql(l_sql,g_plant_1[l_i].no) RETURNING l_sql  #FUN-A10098
             PREPARE r003_prepare2 FROM l_sql                                #FUN-A10098--add

#             DECLARE r002_oma CURSOR FROM l_sql                             #FUN-A10098---mark
             DECLARE r002_oma CURSOR FOR r003_prepare2                       #FUN-A10098--add
             FOREACH r002_oma INTO l_oma.*
                EXIT FOREACH  
             END FOREACH
 
           #第一筆處理 STR
           IF l_i = 1 THEN
 
             #出貨日，抓omb31第一筆的oga02 STR
             LET l_sql = "SELECT omb31 ",
#                         "  FROM ",g_plant_1[l_i].db_name CLIPPED,".dbo.omb_file ",    #No.FUN-A10098
                         "  FROM ",cl_get_target_table(g_plant_1[l_i].no,'omb_file'),   #No.FUN-A10098 ---add
                         " WHERE omb01='",l_oma.oma01,"'",
                         " ORDER BY omb03"
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #No.FUN-A10098  ---ADD
             CALL cl_parse_qry_sql(l_sql,g_plant_1[l_i].no) RETURNING l_sql  #FUN-A10098
             PREPARE r003_prepare3 FROM l_sql                                #FUN-A10098--add

#             DECLARE r002_omb31 CURSOR FROM l_sql                           #FUN-A10098--mark
             DECLARE r002_omb31 CURSOR FOR r003_prepare3                     #FUN-A10098--add
             LET l_oga01 = ''
             FOREACH r002_omb31 INTO l_oga01
                EXIT FOREACH
             END FOREACH
 
             #merits HA 抓AP立帳匯率 
#             LET l_sql = "SELECT apa14 FROM ", g_plant_1[l_i].db_name CLIPPED,".dbo.apa_file ",      #No.FUN-A10098
             LET l_sql = "SELECT apa14 FROM ",cl_get_target_table(g_plant_1[l_i].no,'apa_file'),  #No.FUN-A10098 ---add
                         " WHERE apa99='",l_oma.oma99,"'"
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #No.FUN-A10098  ---ADD
             CALL cl_parse_qry_sql(l_sql,g_plant_1[l_i].no) RETURNING l_sql  #FUN-A10098

             PREPARE r003_prepare4 FROM l_sql                                #FUN-A10098--add

#             DECLARE r002_apa14 CURSOR FROM l_sql                           #FUN-A10098--mark
             DECLARE r002_apa14 CURSOR FOR r003_prepare4                      #FUN-A10098--add
             LET l_apa14 = ''
             FOREACH r002_apa14 INTO l_apa14
                EXIT FOREACH
             END FOREACH
 
             #merits end
 
             #出貨日，抓omb31第一筆的oga02
             LET sr.oga02 = ''   
             LET sr.oga021= ''
             LET l_sql = "SELECT oga02,oga021 ", 
#                         "  FROM ",g_plant_1[l_i].db_name CLIPPED,".dbo.oga_file ",     #No.FUN-A10098
                         "  FROM ",cl_get_target_table(g_plant_1[l_i].no,'oga_file'),   #No.FUN-A10098 ---add
                         " WHERE oga01 ='",l_oga01,"'"
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #No.FUN-A10098  ---ADD
             CALL cl_parse_qry_sql(l_sql,g_plant_1[l_i].no) RETURNING l_sql  #FUN-A10098

             PREPARE r003_prepare5 FROM l_sql                                #FUN-A10098--add

#             DECLARE get_oga02 CURSOR FROM l_sql                             #FUN-A10098--mark
             DECLARE get_oga02 CURSOR FOR r003_prepare5                      #FUN-A10098--add
             FOREACH get_oga02 INTO sr.oga02, sr.oga021
                EXIT FOREACH
             END FOREACH 
 
             #如果這筆出貨日不在符合區間，跳出此多角序號
             IF sr.oga02 > tm.edate OR sr.oga02 < tm.bdate THEN
                CONTINUE FOREACH
             END IF
 
             #invoice
             LET sr.oma67 = l_oma.oma67
 
             #oga01
             LET sr.omb31 = l_oga01 
 
             #oma03, oma032
             LET sr.oma03 = l_oma.oma03
             LET sr.oma032= l_oma.oma032
 
             #oga021
             LET sr.oga021 = sr.oga021 #結關日 
 
             #寫入CR第一筆
 
           END IF
          #第一筆處理 END
 
          #金額
           LET sr.oma54t = l_oma.oma54t
 
          #幣別
           LET sr.oma23 = l_oma.oma23
 
          #有幣別，抓取位
           LET sr.azi07 = 0
           LET sr.azi04 = 0
           SELECT azi07, azi04 INTO sr.azi07, sr.azi04
             FROM azi_file WHERE azi01 = sr.oma23
           IF cl_null(sr.azi07) THEN LET sr.azi07 = 0 END IF
           IF cl_null(sr.azi04) THEN LET sr.azi04 = 0 END IF
 
          #佣金取位第一筆照幣別
           LET sr.azicom = sr.azi04
 
          #merits add
           CASE WHEN l_i=1
                     LET sr.azj041=l_oma.oma24 
                WHEN l_i=2
                     LET sr.azj041=l_apa14     
                WHEN l_i=3
                    LET l_str = s_dbstring(g_plant_1[1].db_name CLIPPED)
                    LET l_str_plant = g_plant_1[1].no             #FUN-980020
#                   CALL s_currm(sr.oma23,l_oma.oma02,'C',l_str)  #FUN-980020 mark
                    CALL s_currm(sr.oma23,l_oma.oma02,'C',l_str_plant)  #FUN-980020
                         RETURNING sr.azj041
                OTHERWISE
                     LET sr.azj041=l_oma.oma24  
           END CASE
          #merits end
 
          #銷貨NTD
           LET sr.moneyntd = sr.oma54t * sr.azj041
 
          #銷貨原幣 STR
           LET sr.oma54t_1 = sr.oma54t
           IF l_i = 1 THEN
              LET sr.oma54t_1 = ' ' #流程第一筆不show
           END IF
          #銷貨原幣 END
 
          #MISC料號原幣
           LET sr.misc_ori = 0
           LET l_sql = "SELECT SUM(omb14)",
#                       "  FROM ",g_plant_1[l_i].db_name CLIPPED,".dbo.omb_file ",                  #No.FUN-A10098
                       "  FROM ",cl_get_target_table(g_plant_1[l_i].no,'omb_file'),   #No.FUN-A10098 ---add
                       " WHERE omb01 ='",l_oma.oma01,"'",
                       "   AND omb04 LIKE 'MISC%'"
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #No.FUN-A10098  ---ADD
           CALL cl_parse_qry_sql(l_sql,g_plant_1[l_i].no) RETURNING l_sql  #FUN-A10098
           PREPARE r003_prepare6 FROM l_sql                                #FUN-A10098--add

#           DECLARE get_omb14 CURSOR FROM l_sql                            #FUN-A10098--mark
           DECLARE get_omb14 CURSOR FOR r003_prepare6                      #FUN-A10098--add
           FOREACH get_omb14 INTO sr.misc_ori
             EXIT FOREACH
           END FOREACH
           IF cl_null(sr.misc_ori) THEN LET sr.misc_ori = 0 END IF
 
          #MISC料號本幣
           LET sr.misc_ntd = 0
           LET sr.misc_ntd = sr.misc_ori * sr.azj041
           IF cl_null(sr.misc_ntd) THEN LET sr.misc_ntd = 0 END IF
 
           LET sr_dy[l_i].* = sr.*
 
          #抓header欄位 STR
           #表頭的幣別代碼 STR
            LET gg_aza17 = ''
            LET l_sql = "SELECT aza17 ",
#                        "  FROM ",g_plant_1[1].db_name CLIPPED,".dbo.aza_file "                    #No.FUN-A10098
                        "  FROM ",cl_get_target_table(g_plant_1[1].no,'aza_file')   #No.FUN-A10098 ---add
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #No.FUN-A10098  ---ADD
            CALL cl_parse_qry_sql(l_sql,g_plant_1[1].no) RETURNING l_sql  #FUN-A10098
            PREPARE r003_prepare7 FROM l_sql                                #FUN-A10098--add

#            DECLARE aza17_get CURSOR FROM l_sql                            #FUN-A10098--mark
            DECLARE aza17_get CURSOR FOR r003_prepare7                     #FUN-A10098--add
            FOREACH aza17_get INTO gg_aza17
              EXIT FOREACH
            END FOREACH
           #表頭的幣別代碼 END
 
           #流程說明
            LET l_poz02=''
            LET l_sql = "SELECT poz02 ",
#                        "  FROM ",g_plant_1[l_i].db_name CLIPPED,".dbo.poz_file ",                 #No.FUN-A10098
                        "  FROM ",cl_get_target_table(g_plant_1[l_i].no,'poz_file'),   #No.FUN-A10098 ---add
                        " WHERE poz01='",sr.flow,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #No.FUN-A10098  ---ADD
            CALL cl_parse_qry_sql(l_sql,g_plant_1[l_i].no) RETURNING l_sql  #FUN-A10098
            PREPARE r003_prepare8 FROM l_sql                                #FUN-A10098--add

#            DECLARE poz02_get CURSOR FROM l_sql                             #FUN-A10098--mark
            DECLARE poz02_get CURSOR FOR r003_prepare8                       #FUN-A10098--add
            FOREACH poz02_get INTO l_poz02
              EXIT FOREACH
            END FOREACH
 
            IF l_i = 1 THEN
               EXECUTE insert_prep1 USING sr.flow,sr.flow_sn,sr.ds_sn,gg_aza17,' ',l_poz02
            ELSE 
               EXECUTE insert_prep1 USING sr.flow,sr.flow_sn,sr.ds_sn,gg_aza17,g_plant_1[l_i].cu_name,l_poz02
            END IF
          #抓header欄位 END
 
         ##抓header欄位 STR
         # IF l_i = 1 THEN
         #   #表頭的幣別代碼 STR
         #    LET gg_aza17 = ''
         #    LET l_sql = "SELECT aza17 ",
         #                "  FROM ",g_plant_1[l_i].db_name CLIPPED,".dbo.aza_file "
         #    DECLARE aza17_get CURSOR FROM l_sql
         #    FOREACH aza17_get INTO gg_aza17
         #      EXIT FOREACH
         #    END FOREACH
         #   #表頭的幣別代碼 END
 
         #   #流程說明
         #    LET l_poz02=''
         #    LET l_sql = "SELECT poz02 ",
         #                "  FROM ",g_plant_1[l_i].db_name CLIPPED,".dbo.poz_file ",
         #                " WHERE poz01='",sr.flow,"'"
         #    DECLARE poz02_get CURSOR FROM l_sql
         #    FOREACH poz02_get INTO l_poz02
         #      EXIT FOREACH
         #    END FOREACH
 
         #    EXECUTE insert_prep1 USING sr.flow,sr.flow_sn,sr.ds_sn,gg_aza17,' ',l_poz02
 
         # ELSE
         #   
         #   #流程說明
         #    LET l_poz02=''
         #    LET l_sql = "SELECT poz02 ",
         #                "  FROM ",g_plant_1[l_i].db_name CLIPPED,".dbo.poz_file ",
         #                " WHERE poz01='",sr.flow,"'"
         #    DECLARE poz02_get1 CURSOR FROM l_sql
         #    FOREACH poz02_get1 INTO l_poz02
         #      EXIT FOREACH
         #    END FOREACH
         #    EXECUTE insert_prep1 USING sr.flow,sr.flow_sn,sr.ds_sn,gg_aza17,g_plant_1[l_i].cu_name,l_poz02
         # END IF
         ##抓header欄位 END
 
         END FOR   #jamie---header
        #開始抓應收 -- 要照流程的db跑。END
 
      
        #佣金處理移到最後才處理，邏輯不太適合在上面做。
        #佣金第一筆 STR
         LET sr_dy[1].commi = sr_dy[1].moneyntd - sr_dy[2].moneyntd
         LET sr_dy[1].commi = sr_dy[1].commi / sr_dy[1].azj041
        #佣金第一筆 END
 
        #佣金第二筆 STR
         FOR l_i = 2 TO g_rec_plant
            #merits add
             LET sr_dy[l_i].oma03=sr_dy[1].oma03
             LET sr_dy[l_i].oma032=sr_dy[1].oma032          
            #merits end 
 
             LET sr_dy[l_i].commi = sr_dy[l_i-1].moneyntd - sr_dy[l_i].moneyntd
            #LET sr_dy[l_i].commi = sr_dy[l_i].commi / sr_dy[l_i].azj041
             
            #佣金取位第二筆以後移到這邊取
             LET sr_dy[l_i].azicom = sr_dy[1].azicom 
            
            #高原，太倉的原幣算法改變 STR 
             LET sr_dy[l_i].oma54t_1 = sr_dy[l_i].moneyntd / 
                                       sr_dy[1].azj041
            #高原，太倉的原幣算法改變 END
         END FOR
        #佣金第二筆 END
         
         FOR l_i = 1 TO g_rec_plant
            #merits add
             CASE WHEN tm.s='1'
                       LET sr_dy[l_i].order1=sr_dy[l_i].oga02
                       LET sr_dy[l_i].order2=sr_dy[l_i].oma67
                       LET sr_dy[l_i].order3=sr_dy[l_i].oma03
                  WHEN tm.s='2'
                       LET sr_dy[l_i].order1=sr_dy[l_i].oma03
                       LET sr_dy[l_i].order2=sr_dy[l_i].oga02
                       LET sr_dy[l_i].order3=sr_dy[l_i].oma67
                  WHEN tm.s='3'
                       LET sr_dy[l_i].order1=sr_dy[l_i].oma67
                       LET sr_dy[l_i].order2=sr_dy[l_i].oga02
                       LET sr_dy[l_i].order3=sr_dy[l_i].oma03
 
             END CASE
            #寫入CR
          # IF l_i = 1 THEN                                #FUN-CB0073
               EXECUTE insert_prep USING sr_dy[l_i].*   #FUN-CB0073 add ' ',l_poz02,sr.ds_sn
          # ELSE                                           #FUN-CB0073
          #    EXECUTE insert_prep USING sr_dy[l_i].* ,g_plant_1[l_i].cu_name,l_poz02,sr.ds_sn   #FUN-CB0073
          # END IF                                         #FUN-CB0073
 
            #總計在AFTER GROUP OF flow STR
            IF l_i = g_rec_plant THEN
 
            INSERT INTO apmg003_tmp2 VALUES (
               sr_dy[l_i].flow,
               sr_dy[l_i].flow_sn,
               sr_dy[l_i].ds_sn,
               g_plant_1[l_i].cu_name,
               sr_dy[l_i].oma23,        
               0, #最後一筆，佣金算法不同
               sr_dy[l_i].misc_ori,
               sr_dy[l_i].misc_ntd,
               sr_dy[l_i].moneyntd,
               sr_dy[l_i].oma54t,
               gg_aza17
            )
            ELSE
            INSERT INTO apmg003_tmp2 VALUES (
               sr_dy[l_i].flow,
               sr_dy[l_i].flow_sn,
               sr_dy[l_i].ds_sn,
               g_plant_1[l_i].cu_name,
               sr_dy[l_i].oma23,        
               sr_dy[l_i].moneyntd-sr_dy[l_i+1].moneyntd, 
               sr_dy[l_i].misc_ori,
               sr_dy[l_i].misc_ntd,
               sr_dy[l_i].moneyntd,
               sr_dy[l_i].oma54t,
               gg_aza17
            )
            END IF
            #總計在AFTER GROUP OF flow END
            
         END FOR
         CALL sr_dy.clear()
         #處理佣金 END
 
        END FOREACH
        #抓此流程代碼合乎條件的多角序號 END
 
     END FOREACH
 
    #總計另外從temptable抓資料
     LET l_sql = "SELECT DISTINCT poz01 FROM poz_file,oea_file ",
                 " WHERE ",tm.wc CLIPPED,
                 "   AND oea904 = poz01"
 
     DECLARE r003_cs2 CURSOR FROM l_sql
     FOREACH r003_cs2 INTO l_poz01
 
        CALL g_plant_1.clear()
        LET g_rec_plant = 1 #流程的第一筆
 
        SELECT poy04,poy03 
          INTO g_plant_1[g_rec_plant].no,  
               g_plant_1[g_rec_plant].cu_name #客戶編號
          FROM poy_file
         WHERE poy01 = l_poz01
           AND poy02 = '0'
 
        IF SQLCA.SQLCODE THEN
           CALL cl_err3("sel","poz_file",l_poz01,"","TSD0004","","",0) 
        ELSE
          SELECT azp03 INTO g_plant_1[g_rec_plant].db_name
             FROM azp_file WHERE azp01 = g_plant_1[g_rec_plant].no
        
          LET g_rec_plant = g_rec_plant + 1
        
          DECLARE r003_cs3  CURSOR FOR
            SELECT poy02,poy04,poy03 FROM poy_file
             WHERE poy01 = l_poz01
               AND poy02 <> '0'
             ORDER BY poy02
        
          FOREACH r003_cs3 INTO l_poy02,
                                g_plant_1[g_rec_plant].no,
                                g_plant_1[g_rec_plant].cu_name
            IF STATUS THEN
               CALL cl_err(l_poz01,'TSD0004',0) 
               EXIT FOREACH
            END IF
        
            LET g_rec_plant = g_rec_plant + 1
 
          END FOREACH
 
          LET g_rec_plant = g_rec_plant - 1
        END IF
 
        #此流程要走的db由g_plant_1紀錄 END
         FOR g_rec_b1 = 1 TO g_rec_plant           #最多只有六個拋轉db
             IF g_rec_b1=1 THEN 
                LET l_sql = "SELECT flow,ds_sn,ds_sn_desc,oma23,",
                            "       SUM(oma54),SUM(commi),SUM(misc_ori)", 
                            "  FROM apmg003_tmp2 ",
                            " WHERE flow='",l_poz01,"'",
                            "   AND ds_sn='",g_rec_b1,"'",
                            " GROUP BY flow,ds_sn,ds_sn_desc,oma23 "
 
                DECLARE r003_cs4 CURSOR FROM l_sql
                
                FOREACH r003_cs4 INTO l_flow,l_ds_sn,l_desc,l_oma23,
                                      l_oma54t,                                                 
                                      l_commi,l_misc_ori                                  
                  IF STATUS THEN
                     CALL cl_err(l_poz01,'TSD0004',0) 
                     EXIT FOREACH
                  END IF
 
                  SELECT SUM(moneyntd),SUM(misc_ntd) 
                    INTO l_moneyntd,l_misc_ntd  
                    FROM apmg003_tmp2 
                   WHERE flow=l_poz01
                     AND ds_sn= g_rec_b1
 
                  SELECT DISTINCT azi01 INTO l_aza17 FROM apmg003_tmp2 WHERE flow=l_poz01
                  SELECT azi05 INTO l_azi05 FROM azi_file WHERE azi01=l_oma23 
                  SELECT azi05 INTO l_azi05_2 FROM azi_file WHERE azi01=l_aza17
                
                  EXECUTE insert_prep2 USING l_flow,l_ds_sn,l_desc,l_oma23,
                                             l_oma54t, l_moneyntd,                 
                                             l_commi,l_misc_ori,l_misc_ntd, 
                                             l_azi05,l_aza17,l_azi05_2
                END FOREACH
             ELSE 
                LET l_sql = "SELECT flow,ds_sn,ds_sn_desc,oma23,",
                            "       SUM(oma54),SUM(misc_ori)", 
                            "  FROM apmg003_tmp2 ",
                            " WHERE flow='",l_poz01,"'",
                            "   AND ds_sn='",g_rec_b1,"'",
                            " GROUP BY flow,ds_sn,ds_sn_desc,oma23,azi01 "
 
                DECLARE r003_cs5 CURSOR FROM l_sql
                
                FOREACH r003_cs5 INTO l_flow,l_ds_sn,l_desc,l_oma23,
                                      l_oma54t,l_misc_ori                                  
                  IF STATUS THEN
                     CALL cl_err(l_poz01,'TSD0004',0) 
                     EXIT FOREACH
                  END IF
 
                  SELECT SUM(moneyntd),SUM(commi),SUM(misc_ntd) 
                    INTO l_moneyntd,l_commi,l_misc_ntd  
                    FROM apmg003_tmp2 
                   WHERE flow=l_poz01
                     AND ds_sn= g_rec_b1
 
                  SELECT DISTINCT azi01 INTO l_aza17 FROM apmg003_tmp2 WHERE flow=l_poz01
                  SELECT azi05 INTO l_azi05 FROM azi_file WHERE azi01=l_oma23 
                  SELECT azi05 INTO l_azi05_2 FROM azi_file WHERE azi01=l_aza17
                
                  EXECUTE insert_prep2 USING l_flow,l_ds_sn,l_desc,l_oma23,
                                             l_oma54t, l_moneyntd,                 
                                             l_commi,l_misc_ori,l_misc_ntd, 
                                             l_azi05,l_aza17,l_azi05_2
                END FOREACH
 
             END IF
         END FOR
     END FOREACH 
 
   #CR
###GENGRE###    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
###GENGRE###                "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
###GENGRE###                "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED
 
    LET l_wc = ""  
    IF g_zz05 = 'Y' THEN                         #是否列印列印條件
       CALL cl_wcchp(tm.wc,'poz01,oea03')
            RETURNING tm.wc                #FUN-CB0073 l_wc--->tm.wc
    END IF
   
###GENGRE###    LET g_str =tm.wc,";",tm.bdate,";",tm.edate     #FUN-CB0073 l_wc--->tm.wc   
    
###GENGRE###    CALL cl_prt_cs3('apmg003','apmg003',g_sql,g_str)
    CALL apmg003_grdata()    ###GENGRE###
    #No.FUN-B80088--mark--Begin--- 
    #CALL cl_used(g_prog,g_time,2) RETURNING g_time 
    #No.FUN-B80088--mark--End-----
END FUNCTION
#FUN-890070 


###GENGRE###START
FUNCTION apmg003_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("apmg003")
        IF handler IS NOT NULL THEN
            START REPORT apmg003_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY ",g_cr_db_str CLIPPED,l_table CLIPPED,".flow",",",
                                     g_cr_db_str CLIPPED,l_table CLIPPED,".order1",",",
                                     g_cr_db_str CLIPPED,l_table CLIPPED,".order2",",",
                                     g_cr_db_str CLIPPED,l_table CLIPPED,".order3",",",
                                     g_cr_db_str CLIPPED,l_table CLIPPED,".flow_sn",",",
                                     g_cr_db_str CLIPPED,l_table CLIPPED,".ds_sn"
                       
          
            DECLARE apmg003_datacur1 CURSOR FROM l_sql
            FOREACH apmg003_datacur1 INTO sr1.*
                OUTPUT TO REPORT apmg003_rep(sr1.*)
            END FOREACH
            FINISH REPORT apmg003_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT apmg003_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE sr3 sr3_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_sql STRING     #FUN-CB0073
    DEFINE l_azj041_fmt,l_oma54t_1_fmt,l_commi_fmt STRING  #FUN-CB0073

    
    ORDER EXTERNAL BY sr1.flow
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.flow
#FUN-CB0073--add--str--
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " WHERE flow_sn =  '",sr1.flow_sn,"'"
                     #  " ORDER BY ",g_cr_db_str CLIPPED,l_table1 CLIPPED,".flow",","
                     #              ,g_cr_db_str CLIPPED,l_table CLIPPED,".ds_sn"

            START REPORT apmg003_subrep01
            DECLARE apmg003_repcur2 CURSOR FROM l_sql
            FOREACH apmg003_repcur2 INTO sr2.*
                OUTPUT TO REPORT apmg003_subrep01(sr2.*)
            END FOREACH
            FINISH REPORT apmg003_subrep01
  #FUN-CB0073--add--end--
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*
       #FUN-CB0073--add--str--
            LET l_azj041_fmt = cl_gr_numfmt('azj_file','azj041',sr1.azi07)
            LET l_azj041_fmt = cl_replace_str(l_azj041_fmt,"&.","#.")
            PRINTX l_azj041_fmt
            LET l_oma54t_1_fmt = cl_gr_numfmt('oma_file','oma54t',sr1.azi04)
            LET l_oma54t_1_fmt = cl_replace_str(l_oma54t_1_fmt,"&.","#.")
            PRINTX l_oma54t_1_fmt
            LET l_commi_fmt = cl_gr_numfmt('type_file','num20_6',sr1.azicom)
            LET l_commi_fmt = cl_replace_str(l_commi_fmt,"&.","#.")
            PRINTX l_commi_fmt
       #FUN-CB0073--add--end--

        AFTER GROUP OF sr1.flow
  #FUN-CB0073--add--str--
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                        " WHERE l_flow =  '",sr1.flow,"'"
                    #   " ORDER BY ",g_cr_db_str CLIPPED,l_table CLIPPED,".l_ds_sn",","
                    #               ,g_cr_db_str CLIPPED,l_table CLIPPED,".l_oma23"

            START REPORT apmg003_subrep02
            DECLARE apmg003_repcur1 CURSOR FROM l_sql
            FOREACH apmg003_repcur1 INTO sr3.*
                OUTPUT TO REPORT apmg003_subrep02(sr3.*)
            END FOREACH
            FINISH REPORT apmg003_subrep02
  #FUN-CB0073--add--end--     

        
        ON LAST ROW

END REPORT

#FUN-CB0073--add--str--
REPORT apmg003_subrep01(sr2)
   DEFINE sr2 sr2_t
   DEFINE l_str1,l_str2,l_str3,l_str4,l_str5  STRING  #FUN-CB0073
   ORDER EXTERNAL BY sr2.flow
   FORMAT
      BEFORE GROUP OF sr2.flow
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            PRINTX tm.*

      ON EVERY ROW
         LET l_str1 = cl_gr_getmsg('gre-329',g_lang,1)
         LET l_str2 = cl_gr_getmsg('gre-329',g_lang,2)
         LET l_str3 = cl_gr_getmsg('gre-329',g_lang,3)
         LET l_str4 = cl_gr_getmsg('gre-329',g_lang,4)
         LET l_str5 = cl_gr_getmsg('gre-329',g_lang,5)
         PRINTX l_str1,l_str2,l_str3,l_str4,l_str5
         PRINTX sr2.*
END REPORT
REPORT apmg003_subrep02(sr3)
   DEFINE sr3 sr3_t
   DEFINE sr3_o sr3_t                      
   DEFINE l_display1 LIKE type_file.chr1,
          l_display2 LIKE type_file.chr1,
    l_oma54t_fmt           STRING,        
    l_moneyntd_fmt         STRING,    
    l_commi_fmt            STRING, 
    l_misc_ori_fmt         STRING,    
    l_misc_ntd_fmt         STRING     
   FORMAT
      ON EVERY ROW
         LET l_oma54t_fmt = cl_gr_numfmt('oma_file','oma54t',sr3.l_azi05)
         LET l_oma54t_fmt = cl_replace_str(l_oma54t_fmt,"&.","#.")
         LET l_commi_fmt = cl_gr_numfmt('type_file','num20_6',sr3.l_azi05)
         LET l_commi_fmt = cl_replace_str(l_commi_fmt,"&.","#.")
         LET l_misc_ori_fmt = cl_gr_numfmt('type_file','num20_6',sr3.l_azi05)
         LET l_misc_ori_fmt = cl_replace_str(l_misc_ori_fmt,"&.","#.")
         LET l_moneyntd_fmt = cl_gr_numfmt('type_file','num20_6',sr3.l_azi05_2)
         LET l_moneyntd_fmt = cl_replace_str(l_moneyntd_fmt,"&.","#.")
         LET l_misc_ntd_fmt = cl_gr_numfmt('type_file','num20_6',sr3.l_azi05_2)
         LET l_misc_ntd_fmt = cl_replace_str(l_misc_ntd_fmt,"&.","#.")
         PRINTX l_oma54t_fmt,l_commi_fmt,l_misc_ori_fmt,l_moneyntd_fmt,l_misc_ntd_fmt
         IF NOT cl_null(sr3_o.l_ds_sn) AND NOT cl_null(sr3_o.l_oma23) THEN
            IF sr3_o.l_ds_sn = sr3.l_ds_sn AND sr3_o.l_oma23 = sr3.l_oma23 THEN
               LET l_display1 = "N"
            ELSE 
               LET l_display1 = "Y"
            END IF   
         ELSE
            LET l_display1 = "Y"
         END IF
         PRINTX l_display1
         IF NOT cl_null(sr3_o.l_ds_sn) AND NOT cl_null(sr3_o.l_aza17) THEN
            IF sr3_o.l_ds_sn = sr3.l_ds_sn AND sr3_o.l_aza17 = sr3.l_aza17 THEN
               LET l_display2 = "N"
            ELSE
               LET l_display2 = "Y"
            END IF
         ELSE
            LET l_display2 = "Y"
         END IF
         PRINTX l_display2

         PRINTX sr3.*
         LET sr3_o.* = sr3.*

END REPORT
#FUN-CB0073--add--end--
###GENGRE###END
