# Prog. Version..: '5.30.07-13.05.30(00002)'     #
#
# Pattern name...: apmx411.4gl
# Descriptions...: 請購未轉採購清單
# Input parameter:
# Date & Author..: 97/08/26 By Kitty
# Modify.........: No.FUN-4C0095 05/01/04 By Mandy 報表轉XML
# Modify.........: No.MOD-530495 05/03/26 By Mandy 數量欄位沒印小數位數值
# Modify.........: No.FUN-570243 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-580004 05/08/03 By jackie 雙單位報表修改
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: No.TQC-640132 06/04/17 By Nicola 日期調整
# Modify.........: No.FUN-680136 06/09/04 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-7C0054 07/12/20 By baofei 報表輸出至Crystal Reports功能  
# Modify.........: No.MOD-910193 09/01/17 By Nicola l_sql定義為String
# Modify.........: No.TQC-940009 09/04/08 By sabrina 報表新增請購日期、請購人員兩個欄位
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-B30309 11/03/14 By Summer tm.b應改為LIKE type_file.num5
# Modify.........: No.MOD-C90195 12/09/27 By jt_chen 改用tw.wc去串權限
# Modify.........: No.FUN-CB0002 12/11/06 By lujh CR轉XtraGrid
# Modify.........: No.FUN-D40128 13/05/07 By wangrr 增加pmk12請購員开窗
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580004 --start--
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17    #FUN-560079
  DEFINE g_seq_item     LIKE type_file.num5    #No.FUN-680136 SMALLINT
END GLOBALS
#No.FUN-580004 --end--
 
   DEFINE tm  RECORD			   # Print condition RECORD
          #   wc   VARCHAR(500),              # Where Condition
              wc   STRING,                 #TQC-630166            # Where Condition
              a    LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1) # 排列項目
             #b    LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1) # 排列項目 #MOD-B30309 mark
              b    LIKE type_file.num5,    #排列項目 #MOD-B30309
              more  LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1) # 特殊列印條件
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680136 SMALLINT
#No.FUN-580004 --start--
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE   g_sma115        LIKE sma_file.sma115
DEFINE   g_sma116        LIKE sma_file.sma116
#No.FUN-580004 --end--
#No.FUN-7C0054---Begin                                                          
DEFINE l_table        STRING,
       l_table1       STRING,
       g_str          STRING,                                                   
       g_sql          STRING                                                  
                                                 
#No.FUN-7C0054---End
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
#No.FUN-7C0054---Begin                                                          
   LET g_sql = "pml01.pml_file.pml01,pml04.pml_file.pml04,pml041.pml_file.pml041,",
               "pml07.pml_file.pml07,pml18.pml_file.pml18,pml20.pml_file.pml20,",
               "pml21.pml_file.pml21,pml33.pml_file.pml33,pml34.pml_file.pml34,",
               "pml35.pml_file.pml35,pml41.pml_file.pml41,ima021.ima_file.ima021,",
               "l_str2.type_file.chr1000,pmk04.pmk_file.pmk04,gen02.gen_file.gen02,",     #TQC-940009 add pmk04,gen02
               "l_diff.pml_file.pml20"   #FUN-CB0002  add
   LET l_table = cl_prt_temptable('apmx411',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,              
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "   #TQC-940009 add 2個?   #FUN-CB0002  add ?     
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF  
#No.FUN-7C0054---End
 
    IF g_sma.sma31 matches'[Nn]' THEN    #無使用請購功能
       CALL cl_err(g_sma.sma31,'mfg0032',1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
       EXIT PROGRAM
    END IF
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.a     = ARG_VAL(8)
   LET tm.b     = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL x411_tm(0,0)	
      ELSE CALL x411()		
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION x411_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 11
 
   OPEN WINDOW x411_w AT p_row,p_col WITH FORM "apm/42f/apmx411"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a      = 'Y'
   LET tm.more   = 'N'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
WHILE TRUE
   CONSTRUCT BY NAME  tm.wc ON pmk01,pmk04,pmk12,pml04
#No.FUN-570243 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
        ON ACTION CONTROLP
            #FUN-CB0002--add--str--
            IF INFIELD (pmk01) THEN 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_pmk3"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmk01
               NEXT FIELD pmk01       
            END IF 
            #FUN-CB0002--add--end--

            #FUN-D40128--add--str--
            IF INFIELD(pmk12) THEN     #請購員
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.state = 'c'
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmk12
              NEXT FIELD pmk12
            END IF
            #FUN-D40128--add--end

            IF INFIELD(pml04) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pml04
               NEXT FIELD pml04
            END IF
#No.FUN-570243 --end
 
     ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
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
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW x411_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   INPUT BY NAME tm.a,tm.b,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF tm.a  NOT MATCHES'[YN]' OR cl_null(tm.a) THEN
            NEXT FIELD a
         END IF
      AFTER FIELD more
         IF tm.more NOT MATCHES'[YN]' THEN
            NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
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
      LET INT_FLAG = 0
      CLOSE WINDOW x411_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmx411'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmx411','9031',1)
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
                         " '",tm.a,"'",
                         " '",tm.b,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apmx411',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW x411_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL x411()
   ERROR ""
END WHILE
   CLOSE WINDOW x411_w
END FUNCTION
 
FUNCTION x411()
   DEFINE l_name     LIKE type_file.chr20, 		 # External(Disk) file name      #No.FUN-680136 VARCHAR(20)
          l_time     LIKE type_file.chr8,  		 # Used time for running the job #No.FUN-680136 VARCHAR(8)
         #l_sql      LIKE type_file.chr1000,		 # RDSQL STATEMENT               #No.FUN-680136 VARCHAR(1000)
          l_sql      STRING,   #No.MOD-910193
          l_za05     LIKE za_file.za05,                  #No.FUN-680136 VARCHAR(40)
          l_rr       LIKE type_file.num5,                #No.FUN-680136 SMALLINT
          i          LIKE type_file.num5,                #No.FUN-580004 #No.FUN-680136 SMALLINT
          sr         RECORD
                     pml01     LIKE    pml_file.pml01,   #請購單號
                     pml04     LIKE    pml_file.pml04,   #料件編號
                  #  ima02     LIKE    ima_file.ima02,   #品名
                     pml041    LIKE    pml_file.pml041,  #品名
                     pml41     LIKE    pml_file.pml41,   #PLT-NO
                     pml07     LIKE    pml_file.pml07,   #單位
                     pml33     LIKE    pml_file.pml33,   #交貨日
                     pml34     LIKE    pml_file.pml34,   #No.TQC-640132
                     pml35     LIKE    pml_file.pml35,   #No.TQC-640132
                     pml18     LIKE    pml_file.pml18,   #No.TQC-640132
                     pml20     LIKE    pml_file.pml20,   #訂購量
                     pml21     LIKE    pml_file.pml21,   #未轉採購量
#No.FUN-580004 --start--
                     pml80     LIKE    pml_file.pml80,
                     pml82     LIKE    pml_file.pml82,
                     pml83     LIKE    pml_file.pml83,
                     pml85     LIKE    pml_file.pml85,
                     pmk04     LIKE    pmk_file.pmk04,     #TQC-940009 add
                     pmk12     LIKE    pmk_file.pmk12      #TQC-940009 add
                     END RECORD
     DEFINE l_i,l_cnt          LIKE type_file.num5    #No.FUN-580004  #No.FUN-680136 SMALLINT
     DEFINE l_zaa02            LIKE zaa_file.zaa02    #NO.FUN-580004
#No.FUN-580004 --end--
#No.FUN-7C0054---Begin
     DEFINE l_ima906       LIKE ima_file.ima906                                                                                        
     DEFINE l_str2         LIKE type_file.chr1000                                                       
     DEFINE l_pml85        STRING                                                                                                      
     DEFINE l_pml82        STRING                                                                                                      
     DEFINE l_pml20        STRING
     DEFINE l_ima021       LIKE ima_file.ima021 
#No.FUN-7C0054---End
     DEFINE l_diff         LIKE pml_file.pml20   #FUN-CB0002  add
     DEFINE l_gen02        LIKE gen_file.gen02      #TQC-940009 add
     DEFINE l_msg1         LIKE type_file.chr100   #FUN-CB0002  add
     DEFINE l_msg2         LIKE type_file.chr100   #FUN-CB0002  add
     
     CALL cl_del_data(l_table)                                   #No.FUN-7C0054
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog    #No.FUN-7C0054
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file   #FUN-580004
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET l_sql = l_sql clipped," AND pmkuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET l_sql = l_sql clipped," AND pmkgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET l_sql = l_sql clipped," AND pmkgrup IN ",cl_chk_tgrup_list()
     #     END IF
    #LET l_sql = l_sql CLIPPED,cl_get_extra_cond('pmkuser', 'pmkgrup')   #MOD-C90195 mark
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmkuser', 'pmkgrup')   #MOD-C90195 add
     #End:FUN-980030
 
 
   # LET l_sql = " SELECT pml01,pml04,ima02,pml41,pml07,pml33,pml20,pml21 ",
     LET l_sql = " SELECT pml01,pml04,pml041,pml41,pml07,pml33,pml34,pml35,pml18,",  #No.TQC-640132
                 "        pml20,pml21,pml80,pml82,pml83,pml85,pmk04,pmk12 ",  #No.FUN-580004      #TQC-940009 add pmk04,pmk12
                 " FROM pmk_file,pml_file ",
               # " OUTER ima_file ",
               # " WHERE pmk01 = pml01 AND pml04=ima01 ",
                 " WHERE pmk01 = pml01 ",
                 "   AND pml16 NOT IN ('6','7','8','9') ",
                 "   AND ",tm.wc CLIPPED
 
     IF tm.a='Y' THEN LET l_sql=l_sql CLIPPED," AND (pml20-pml21)>0 " END IF
     PREPARE x411_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
     END IF
     DECLARE x411_c1 CURSOR FOR x411_p1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('declare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
     END IF
#     CALL cl_outnam('apmx411') RETURNING l_name    #No.FUN-7C0054
#No.FUN-580004 --start--
#     IF g_sma115 = "Y" THEN                        #No.FUN-7C0054
#            LET g_zaa[41].zaa06 = "N"              #No.FUN-7C0054
#     ELSE                                          #No.FUN-7C0054 
#            LET g_zaa[41].zaa06 = "Y"              #No.FUN-7C0054
#     END IF                                        #No.FUN-7C0054
#     CALL cl_prt_pos_len()                         #No.FUN-7C0054
#No.FUN-580004 --end
#     START REPORT x411_rep TO l_name               #No.FUN-7C0054
 
#    LET g_pageno = 0                               #No.FUN-7C0054
     IF g_sma115 = "Y" THEN                         #No.FUN-7C0054
        LET l_name = 'apmx411'                      #No.FUN-7C0054
     ELSE                                           #No.FUN-7C0054
        LET l_name = 'apmx411_1'                    #No.FUN-7C0054
     END IF                                         #No.FUN-7C0054
     FOREACH x411_c1 INTO sr.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       IF cl_null(sr.pml20) THEN LET sr.pml20=0 END IF
       IF cl_null(sr.pml21) THEN LET sr.pml21=0 END IF
       IF NOT cl_null(tm.b) THEN
          IF sr.pml20=0 THEN
             LET l_rr=0
          ELSE
             LET l_rr=(sr.pml20-sr.pml21)/sr.pml20*100
          END IF
          IF l_rr<tm.b THEN                #最小差異率判斷
             CONTINUE FOREACH
          END IF
       END IF
#No.FUN-7C0054---Begin
     SELECT ima021                                                                                                                 
       INTO l_ima021                                                                                                               
       FROM ima_file                                                                                                               
      WHERE ima01=sr.pml04                                                                                                         
     IF SQLCA.sqlcode THEN                                                                                                         
         LET l_ima021 = NULL                                                                                                       
     END IF                                                                                                                        
                                                                                                  
     SELECT ima906 INTO l_ima906 FROM ima_file                                                                                     
                        WHERE ima01=sr.pml04                                                                                       
     LET l_str2 = ""                                                                                                               
     IF g_sma115 = "Y" THEN                                                                                                        
        CASE l_ima906                                                                                                              
           WHEN "2"                                                                                                                
               CALL cl_remove_zero(sr.pml85) RETURNING l_pml85                                                                     
               LET l_str2 = l_pml85 , sr.pml83 CLIPPED                                                                             
               IF cl_null(sr.pml85) OR sr.pml85 = 0 THEN                                                                           
                   CALL cl_remove_zero(sr.pml82) RETURNING l_pml82                                                                 
                   LET l_str2 = l_pml82, sr.pml80 CLIPPED                                                                          
               ELSE                                            
                  IF NOT cl_null(sr.pml82) AND sr.pml82 > 0 THEN                                                                   
                     CALL cl_remove_zero(sr.pml82) RETURNING l_pml82                                                               
                     LET l_str2 = l_str2 CLIPPED,',',l_pml82, sr.pml80 CLIPPED                                                     
                  END IF                                                                                                           
               END IF                                                                                                              
           WHEN "3"                                                                                                                
               IF NOT cl_null(sr.pml85) AND sr.pml85 > 0 THEN                                                                      
                   CALL cl_remove_zero(sr.pml85) RETURNING l_pml85                                                                 
                   LET l_str2 = l_pml85 , sr.pml83 CLIPPED                                                                         
               END IF                                                                                                              
        END CASE                                                                                                                   
#     ELSE                                                                                                                          
     END IF
     IF cl_null(sr.pml18)  THEN            
       LET sr.pml18= ''
     END IF
    #TQC-940009---add---start---
     SELECT gen02 INTO l_gen02 FROM gen_file
      WHERE gen01 = sr.pmk12
    #TQC-940009---add---end---
     LET l_diff = sr.pml20 - sr.pml21     #FUN-CB0002  add
     EXECUTE insert_prep USING sr.pml01,sr.pml04,sr.pml041,sr.pml07,sr.pml18,
                               sr.pml20,sr.pml21,sr.pml33,sr.pml34,sr.pml35,
                               sr.pml41,l_ima021,l_str2,sr.pmk04,l_gen02,      #TQC-940009 add pmk04,gen02
                               l_diff    #FUN-CB0002  add
#       OUTPUT TO REPORT x411_rep(sr.*)
#No.FUN-7C0054---End
     END FOREACH
#No.FUN-7C0054---Begin
#     FINISH REPORT x411_rep
      #FUN-CB0002--mark--str--
      #IF g_zz05 = 'Y' THEN                                                      
      #   CALL cl_wcchp(tm.wc,'pmk01,pmk04,pmk12,pml04')                         
      #        RETURNING tm.wc                                                   
      #END IF    
      #FUN-CB0002--mark--end--      
###XtraGrid###      LET g_str=tm.wc,";",tm.a,";",tm.b 
###XtraGrid###     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
###XtraGrid###     CALL cl_prt_cs3('apmx411',l_name,l_sql,g_str)
    LET g_xgrid.table = l_table    ###XtraGrid###
    LET g_xgrid.template = l_name
    LET g_xgrid.order_field = "pml01,pml04"
    IF g_zz05 = 'Y' THEN                                                      
       CALL cl_wcchp(tm.wc,'pmk01,pmk04,pmk12,pml04')                         
          RETURNING tm.wc                                                   
    END IF  
    LET l_msg1 = cl_getmsg('apm-181',g_lang) 
    LET l_msg2 = cl_getmsg('apm-182',g_lang) 
    IF tm.a = 'Y' THEN 
       LET g_xgrid.footerinfo1 = l_msg1
    END IF 
    LET g_xgrid.footerinfo2 = l_msg2,tm.b,'%'
    LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc
    CALL cl_xg_view()    ###XtraGrid###
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-7C0054---End
END FUNCTION
#No.FUN-7C0054---Begin
#REPORT x411_rep(sr)
#   DEFINE l_ima021     LIKE ima_file.ima021    #FUN-4C0095
#   DEFINE l_last_sw	LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(1)
#         sr         RECORD
#                    pml01     LIKE    pml_file.pml01,   #請購單號
#                    pml04     LIKE    pml_file.pml04,   #料件編號
#                 #  ima02     LIKE    ima_file.ima02,   #品名
#                    pml041    LIKE    pml_file.pml041,  #品名
#                    pml41     LIKE    pml_file.pml41,   #PLT-NO
#                    pml07     LIKE    pml_file.pml07,   #單位
#                    pml33     LIKE    pml_file.pml33,   #交貨日
#                    pml34     LIKE    pml_file.pml34,   #No.TQC-640132
#                    pml35     LIKE    pml_file.pml35,   #No.TQC-640132
#                    pml18     LIKE    pml_file.pml18,   #No.TQC-640132
#                    pml20     LIKE    pml_file.pml20,   #訂購量
#                    pml21     LIKE    pml_file.pml21,   #未轉採購量
#No.FUN-580004 --start--
#                    pml80     LIKE    pml_file.pml80,
#                    pml82     LIKE    pml_file.pml82,
#                    pml83     LIKE    pml_file.pml83,
#                    pml85     LIKE    pml_file.pml85
#                    END RECORD
# DEFINE l_ima906       LIKE ima_file.ima906
# DEFINE l_str2         LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(100)
# DEFINE l_pml85        STRING
# DEFINE l_pml82        STRING
# DEFINE l_pml20        STRING
#No.FUN-580004 --end--
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.pml01,sr.pml04
 
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
#     PRINT ' '
#     PRINT g_dash
#     PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[41],g_x[36],g_x[37],   #No.FUN-580004
#           g_x[38],g_x[39],g_x[40],g_x[42],g_x[43],g_x[44]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.pml01
#     PRINT COLUMN g_c[31],sr.pml01;
 
#  ON EVERY ROW
#     SELECT ima021
#       INTO l_ima021
#       FROM ima_file
#      WHERE ima01=sr.pml04
#     IF SQLCA.sqlcode THEN
#         LET l_ima021 = NULL
#     END IF
#No.FUN-580004 --start--
#     SELECT ima906 INTO l_ima906 FROM ima_file
#                        WHERE ima01=sr.pml04
#     LET l_str2 = ""
#     IF g_sma115 = "Y" THEN
#        CASE l_ima906
#           WHEN "2"
#               CALL cl_remove_zero(sr.pml85) RETURNING l_pml85
#               LET l_str2 = l_pml85 , sr.pml83 CLIPPED
#               IF cl_null(sr.pml85) OR sr.pml85 = 0 THEN
#                   CALL cl_remove_zero(sr.pml82) RETURNING l_pml82
#                   LET l_str2 = l_pml82, sr.pml80 CLIPPED
#               ELSE
#                  IF NOT cl_null(sr.pml82) AND sr.pml82 > 0 THEN
#                     CALL cl_remove_zero(sr.pml82) RETURNING l_pml82
#                     LET l_str2 = l_str2 CLIPPED,',',l_pml82, sr.pml80 CLIPPED
#                  END IF
#               END IF
#           WHEN "3"
#               IF NOT cl_null(sr.pml85) AND sr.pml85 > 0 THEN
#                   CALL cl_remove_zero(sr.pml85) RETURNING l_pml85
#                   LET l_str2 = l_pml85 , sr.pml83 CLIPPED
#               END IF
#        END CASE
#     ELSE
#     END IF
#     PRINT COLUMN g_c[32],sr.pml04 CLIPPED, #FUN-5B0014 [1,20],  #No.FUN-580004
#           COLUMN g_c[33],sr.pml041,
#           COLUMN g_c[34],l_ima021,
#           COLUMN g_c[35],sr.pml41,
#           COLUMN g_c[41],l_str2 CLIPPED,   #No.FUN-580004
#           COLUMN g_c[36],sr.pml07,
#           COLUMN g_c[37],sr.pml33,
#           COLUMN g_c[42],sr.pml34,
#           COLUMN g_c[43],sr.pml35,
#           COLUMN g_c[44],sr.pml18,
#            COLUMN g_c[38],cl_numfor(sr.pml20,38,3),          #MOD-530495
#            COLUMN g_c[39],cl_numfor(sr.pml21,39,3),          #MOD-530495
#            COLUMN g_c[40],cl_numfor(sr.pml20-sr.pml21,40,3)  #MOD-530495
#No.FUN-580004 --end--
#  ON LAST ROW
#     IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
#        THEN PRINT g_dash
#          #   IF tm.wc[001,80] > ' ' THEN			# for 132
#	   #	 PRINT g_x[8] CLIPPED,tm.wc[001,80] CLIPPED END IF
#          #TQC-630166
#       	CALL cl_prt_pos_wc(tm.wc)
#     END IF
#     PRINT g_dash
#     LET l_last_sw = 'y'
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash[1,g_len]
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE SKIP 2 LINE
#      END IF
#END REPORT
#No.FUN-7C0054---End


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
