# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: apjr501.4gl
# Descriptions...: 專案請購未轉採購清單
# Input parameter:
# Date & Author..: 00/01/27 By Alex Lin
# Modify.........: No.FUN-4C0099 05/01/14 By kim 報表轉XML功能
# Modify.........: No.FUN-570243 05/07/25 By vivien 料件編號欄位增加controlp
# Modify.........: No.FUN-580004 05/08/08 By wujie 雙單位報表格式修改
# Modify.........: No.MOD-590003 05/09/05 By DAY 報表結束未對齊
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: NO.FUN-680103 06/08/26 BY hongmei 欄位型態轉換
# Modify.........: No.FUN-690118 06/10/16 By xumin cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0083 06/10/27 By hellen l_time轉g_time
# Modify.........: No.TQC-6A0080 06/11/23 By xumin 表尾結束靠右
# Modify.........: No.FUN-750115 07/06/05 By sherry 報表改為使用Crystal Reports 
# Modify.........: No.FUN-760085 07/07/18 By sherry 報表打印條件錯誤
# Modify.........: No.FUN-830107 08/03/27 By ChenMoyan 項目管理報表部分
# Modify.........: No.MOD-930101 09/03/10 By rainy 同一筆資料重覆印出很多筆
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-AC0268 10/12/17 By yinhy 增加開窗功能
# Modify.........: No.TQC-B80004 11/08/01 By lixia 開窗全選報錯
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580004--begin
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
END GLOBALS
#No.FUN-580004--end
 
   DEFINE tm  RECORD			     # Print condition RECORD
             #wc   VARCHAR(500),                # Where Condition
              wc   STRING,   #TQC-630166     # Where Condition
              a    LIKE type_file.chr1,      # Prog. Version..: '5.30.06-13.03.12(01),  # 排列項目 
              b    LIKE type_file.chr1000,   #No.FUN-680103 SMALLINT,  # 排列項目  
              more LIKE type_file.chr1       # Prog. Version..: '5.30.06-13.03.12(01)   # 特殊列印條件
              END RECORD
 
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose #No.FUN-680103 SMALLINT
#FUN-580004--begin
DEFINE g_sma115         LIKE sma_file.sma115
DEFINE g_sma116         LIKE sma_file.sma116
DEFINE l_zaa02          LIKE zaa_file.zaa02
DEFINE i                LIKE type_file.num10    #No.FUN-680103 INTEGER
#FUN-580004--end
#FUN-750115--start                                                              
DEFINE  g_sql      STRING                                                       
DEFINE  l_table    STRING                                                       
DEFINE  l_str      STRING                                                       
#FUN-750115--end   
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APJ")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690118
 
 
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
      THEN CALL r501_tm(0,0)	
      ELSE CALL r501()		
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690118
END MAIN
 
FUNCTION r501_tm(p_row,p_col)
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01     #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,    #No.FUN-680103 SMALLINT
          l_cmd		LIKE type_file.chr1000  #No.FUN-680103 VARCHAR(1000)
 
      IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
           LET p_row = 5 LET p_col = 18
      ELSE LET p_row = 4 LET p_col = 11
      END IF
   OPEN WINDOW r501_w AT p_row,p_col
        WITH FORM "apj/42f/apjr501"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a      = 'Y'
   LET tm.more   = 'N'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
WHILE TRUE
#  CONSTRUCT BY NAME  tm.wc ON pml12,pmk01,pmk04,pmk12,pml04        #No.FUN-830107
   CONSTRUCT BY NAME  tm.wc ON pml12,pml121,pmk01,pmk04,pmk12,pml04 #No.FUN-830107
 
#No.FUN-570243 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      #No.TQC-AC0268  --Begin
     ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pml12)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_pja"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pml12
               NEXT FIELD pml12
            WHEN INFIELD(pml121)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_pjb"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pml121
               NEXT FIELD pml121
            WHEN INFIELD(pmk12)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_gen"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmk12
               NEXT FIELD pmk12
            WHEN INFIELD(pml04)
               CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pml04
               NEXT FIELD pml04
               OTHERWISE EXIT CASE
         END CASE
      #ON ACTION CONTROLP
      #   IF INFIELD(pml04) THEN
      #      CALL cl_init_qry_var()
      #      LET g_qryparam.form = "q_ima"
      #      LET g_qryparam.state = "c"
      #      CALL cl_create_qry() RETURNING g_qryparam.multiret
      #      DISPLAY g_qryparam.multiret TO pml04
      #      NEXT FIELD pml04
      #   END IF
#No.FUN-570243 --end
     #No.TQC-AC0268  --End
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
      CLOSE WINDOW r501_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690118
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
     INPUT BY NAME tm.a,tm.b,tm.more  WITHOUT DEFAULTS
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
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
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
      CLOSE WINDOW r501_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690118
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apjr501'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apjr501','9031',1)
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
         CALL cl_cmdat('apjr501',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r501_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690118
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r501()
   ERROR ""
END WHILE
   CLOSE WINDOW r501_w
END FUNCTION
 
FUNCTION r501()
   DEFINE
          l_name     LIKE type_file.chr20,       #No.FUN-680103 VARCHAR(20),    # External(Disk) file name
#         l_time          LIKE type_file.chr8         #No.FUN-6A0083
#          l_sql      LIKE type_file.chr1000,     # RDSQL STATEMENT        #No.FUN-680103 VARCHAR(1000)
          l_sql      STRING,                     #TQC-B80004
          l_za05     LIKE type_file.chr1000,     #No.FUN-680103 VARCHAR(40),
          l_rr       LIKE type_file.num5,        #No.FUN-680103 SMALLINT,
          sr         RECORD
                     pml12     LIKE    pml_file.pml12,   #專案代號
                     pml121    LIKE    pml_file.pml121,  #專案順序
#                    pml122    LIKE    pml_file.pml122,  #專案項次#No.FUN-830107
                     pml04     LIKE    pml_file.pml04,   #料件編號
#                    pjf04     LIKE    pjf_file.pjf04,   #品名#No.FUN-830107
#                    pjf041    LIKE    pjf_file.pjf041,  #規格#No.FUN-830107
                     pml041    LIKE    pml_file.pml041,  #No.FUN-830107
                     pml01     LIKE    pml_file.pml01,   #請購單號
                     pml02     LIKE    pml_file.pml02,   #請購單號項次
                     pml07     LIKE    pml_file.pml07,   #請購單位
                     pml35     LIKE    pml_file.pml35,   #到庫日期
                     pml20     LIKE    pml_file.pml20,   #請購數量
                     pml21     LIKE    pml_file.pml21    #採購購量#No.FUN-830107 
#No.FUN-830107 --Begin
#                    pml21     LIKE    pml_file.pml21,   #采購購量
#                    pml80     LIKE    pml_file.pml80,       #No.FUN-580004
#                    pml82     LIKE    pml_file.pml82,       #No.FUN-580004
#                    pml83     LIKE    pml_file.pml83,       #No.FUN-580004
#                    pml85     LIKE    pml_file.pml85        #No.FUN-580004
#No.FUN-830107 --End
                     END RECORD
#No.FUN-750115--begin
   DEFINE l_pml82    STRING                                                     
   DEFINE l_pml85    STRING                                                     
   DEFINE l_str2     LIKE type_file.chr50
   DEFINE l_ima906   LIKE ima_file.ima906                                      
#  DEFINE l_pjb03    LIKE pjb_file.pjb03            #No.FUN-830107                                               
#  DEFINE l_pjb031   LIKE pjb_file.pjb031           #No.FUN-830107                                                
#No.FUN-750115--end   
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = g_prog #No.FUN-760085
     #No.FUN-750115---Begin
     LET g_sql = "pml12.pml_file.pml12,",
                 "pml121.pml_file.pml121,",
#                "pjb031.pjb_file.pjb031,",         #No.FUN-830107
#                "pml122.pml_file.pml122,",         #No.FUN-830107
                 "pml04.pml_file.pml04,",
#                "pjf04.pjf_file.pjf04,",           #No.FUN-830107 
#                "pjf041.pjf_file.pjf041,",         #No.FUN-830107 
                 "pml041.pml_file.pml041,",         #No.FUN-830107
                 "pml01.pml_file.pml01,",
                 "pml02.pml_file.pml02,",
                 "pml07.pml_file.pml07,",
                 "pml35.pml_file.pml35,",
                 "pml20.pml_file.pml20,",
                 "pml21.pml_file.pml21"
#No.FUN-830107  --Begin
#                "pml21.pml_file.pml21,",
#                "pml80.pml_file.pml80,",
#                "pml82.pml_file.pml82,",
#                "pml83.pml_file.pml83,",
#                "pml85.pml_file.pml85,",
#                "l_str2.type_file.chr50,"
#No.FUN-830107  --End
     LET l_table = cl_prt_temptable('apjr501',g_sql)CLIPPED                       
     IF l_table = -1 THEN 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM 
     END IF                                     
                                                                                
#    LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED," values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "  #No.FUN-830107
     LET g_sql = "INSERT INTO ",g_cr_db_str  CLIPPED,l_table CLIPPED,
                 " VALUES(?,?,?,?,?,?,?,?,?,?) "              #No.FUN-830107
       PREPARE insert_prep FROM g_sql                                             
     IF SQLCA.sqlcode THEN                                                        
       CALL cl_err("insert_prep:",STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
       EXIT PROGRAM                         
     END IF               
     #No.FUN-750115---End
    
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pjfuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND pjfgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND pjfgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pjfuser', 'pjfgrup')
     #End:FUN-980030
 
#    LET l_sql = " SELECT pml12,pml121,pml122,pml04,pjf04,pjf041,pml01,pml02,",            #No.FUN-830107
#                " pml07,pml35,pml20,pml21,pml80,pml82,pml83,pml85 ",        #No.FUN-580004#No.FUN-830107
#                " FROM pml_file,pjf_file,pmk_file ",    #no:6434#No.FUN-830107
     LET l_sql = " SELECT pml12,pml121,pml04,pml041,pml01,pml02,",           #No.FUN-830107
                 " pml07,pml35,pml20,pml21 ",                                #No.FUN-830107
                 " FROM pml_file,pmk_file ",    #No.FUN-830107
#                " WHERE pjf01=pml12 ",                  #No.FUN-830107
#                " AND   pmk01=pml01 ",                  #no:6434#No.FUN-830107
#                " AND pjf02=pml121 AND pjf021=pml122 ", #No.FUN-830107
#                " AND pml16 NOT IN ('6','7','8','9')",      #No.FUN-830107
                 #" WHERE pml16 NOT MATCHES '[6789]'",    #No.FUN-830107   #MOD-930101
                 " WHERE pml01 = pmk01 AND pml16 NOT IN ('6','7','8','9')",    #No.FUN-830107   #MOD-930101 add pmk01=pml01
                 " AND ",tm.wc CLIPPED
     
     IF tm.a='Y' THEN LET l_sql=l_sql CLIPPED," AND (pml20-pml21)>0 " END IF
     PREPARE r501_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
  #     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690118
        EXIT PROGRAM
     END IF
     DECLARE r501_c1 CURSOR FOR r501_p1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('declare:',SQLCA.sqlcode,1)
  #     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690118
        EXIT PROGRAM
     END IF
  #  CALL cl_outnam('apjr501') RETURNING l_name    #No.FUN-750115
 
#FUN-580004--begin
#    SELECT sma115 INTO g_sma115 FROM sma_file#No.FUN-830107
#    IF g_sma115 = "Y" THEN                   #No.FUN-830107
#           LET g_zaa[43].zaa06 = "N"         #No.FUN-750115         
#           LET l_name = 'apjr501_1'                     #No.FUN-750115  
#    ELSE                                     #No.FUN-830107
#           LET g_zaa[43].zaa06 = "Y"         #No.FUN-750115  
            LET l_name = 'apjr501'   
#    END IF                                   #No.FUN-830107
#     CALL cl_prt_pos_len()                #No.FUN-750115
#No.FUN-580004--end
#No.FUN-750115---Begin 
 #   START REPORT r501_rep TO l_name
 #   LET g_pageno = 0
     CALL cl_del_data(l_table)
#No.FUN-750115---End  
     FOREACH r501_c1 INTO sr.*
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
          #-->最小差異率判斷
          IF l_rr<tm.b THEN CONTINUE FOREACH END IF
       END IF
#No.FUN-750115---Begin
#No.FUN-830107 --Begin
#      SELECT ima906 INTO l_ima906 FROM ima_file                                  
#                    WHERE ima01=sr.pml04                                    
#      LET l_str2 = ""                                                            
#      IF g_sma115 = "Y" THEN                                                     
#         CASE l_ima906                                                           
#           WHEN "2"                                                             
#             CALL cl_remove_zero(sr.pml85) RETURNING l_pml85                  
#             LET l_str2 = l_pml85 , sr.pml83 CLIPPED                          
#             IF cl_null(sr.pml85) OR sr.pml85 = 0 THEN                        
#                CALL cl_remove_zero(sr.pml82) RETURNING l_pml82              
#                LET l_str2 = l_pml82, sr.pml80 CLIPPED                       
#             ELSE                                                             
#                IF NOT cl_null(sr.pml82) AND sr.pml82 > 0 THEN                
#                   CALL cl_remove_zero(sr.pml82) RETURNING l_pml82            
#                   LET l_str2 = l_str2 CLIPPED,',',l_pml82, sr.pml80 CLIPPED  
#                END IF                                                        
#             END IF                                                           
#           WHEN "3"                                                             
#             IF NOT cl_null(sr.pml85) AND sr.pml85 > 0 THEN                   
#                CALL cl_remove_zero(sr.pml85) RETURNING l_pml85              
#                LET l_str2 = l_pml85 , sr.pml83 CLIPPED                      
#             END IF                                                           
#         END CASE       
#      ELSE                                                                       
#      END IF
#No.FUN-830107 --End
#      OUTPUT TO REPORT r501_rep(sr.*)
#No.FUN-830107  --Begin
#      SELECT pjb03,pjb031 INTO l_pjb03,l_pjb031 FROM pjb_file                   
#      WHERE pjb01 = sr.pml12 AND pjb02 = sr.pml121                            
#      EXECUTE insert_prep USING sr.pml12,sr.pml121,l_pjb031,sr.pml122,sr.pml04,
#                                sr.pjf04,sr.pjf041,sr.pml01,sr.pml02,sr.pml07,
#                                sr.pml35,sr.pml20,sr.pml21,'','','','',l_str2
       EXECUTE insert_prep USING sr.*
#No.FUN-830107  --End
#No.FUN-750115---End   
     END FOREACH
 
   #No.FUN-750115---Begin       
   # FINISH REPORT r501_rep
     IF g_zz05 = 'Y' THEN                                                         
   #    CALL cl_wcchp(tm.wc,'apa01,apa02,apa03,apa04,apa05')       #No.FUN-760085                                          
   #    CALL cl_wcchp(tm.wc,'pml12,pmk01,pmk04,pmk12,pml04')       #No.FUN-760085 #No.FUN-830107
        CALL cl_wcchp(tm.wc,'pml12,pml121,pmk01,pmk04,pmk12,pml04')#No.FUN-830107                                
        RETURNING l_str                                                          
     END IF                                                                       
   #No.FUN-760085---End
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED 
   # CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     CALL cl_prt_cs3('apjr501',l_name,l_sql,l_str)      
   #No.FUN-750115---End
END FUNCTION
 
#No.FUN-750115---Begin
{REPORT r501_rep(sr)
   DEFINE
          l_last_sw     LIKE type_file.chr1,        #No.FUN-680103 VARCHAR(1)
           sr        RECORD
                     pml12     LIKE    pml_file.pml12,   #專案代號
                     pml121    LIKE    pml_file.pml121,  #專案順序
                     pml122    LIKE    pml_file.pml122,  #專案項次
                     pml04     LIKE    pml_file.pml04,   #料件編號
                     pjf04     LIKE    pjf_file.pjf04,   #品名
                     pjf041    LIKE    pjf_file.pjf041,  #規格
                     pml01     LIKE    pml_file.pml01,   #請購單號
                     pml02     LIKE    pml_file.pml02,   #請購單號項次
                     pml07     LIKE    pml_file.pml07,   #請購單位
                     pml35     LIKE    pml_file.pml35,   #到庫日期
                     pml20     LIKE    pml_file.pml20,   #請購數量
                     pml21     LIKE    pml_file.pml21,   #採購購量
                     pml80     LIKE    pml_file.pml80,       #No.FUN-580004
                     pml82     LIKE    pml_file.pml82,       #No.FUN-580004
                     pml83     LIKE    pml_file.pml83,       #No.FUN-580004
                     pml85     LIKE    pml_file.pml85        #No.FUN-580004
                     END RECORD,
          l_cnt      LIKE type_file.num5,          #No.FUN-680103 SMALLINT
          l_pjb03    LIKE pjb_file.pjb03,
          l_pjb031   LIKE pjb_file.pjb031
#No.FUN-580004--begin
   DEFINE l_pml82    STRING
   DEFINE l_pml85    STRING
   DEFINE l_str2     STRING
   DEFINE  l_ima906   LIKE ima_file.ima906
#No.FUN-580004--end
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.pml12,sr.pml121,sr.pml122
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      PRINT
      PRINT g_dash[1,g_len]  #TQC-6A0080
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
            g_x[41],g_x[42],g_x[43]              #No.FUN-580004
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.pml12  #專案代號
      PRINT COLUMN g_c[31],sr.pml12;
   BEFORE GROUP OF sr.pml121 #專案順序
      SELECT pjb03,pjb031 INTO l_pjb03,l_pjb031 FROM pjb_file
        WHERE pjb01 = sr.pml12 AND pjb02 = sr.pml121
      IF SQLCA.sqlcode THEN LET l_pjb03 = ' ' LET l_pjb031 = ' ' END IF
      PRINT COLUMN g_c[32],sr.pml121 USING '####',
            COLUMN g_c[33],l_pjb031;
 
   BEFORE GROUP OF sr.pml122 #項次
      PRINT COLUMN g_c[34],sr.pml122 USING '####';
 
   ON EVERY ROW
 
#FUN-580004--begin
 
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
      ELSE
      END IF
#FUN-580004--end
      PRINT COLUMN g_c[35],sr.pml04 CLIPPED, #FUN-5B0014 [1,20],    #No.FUN-580004
            COLUMN g_c[43],l_str2 CLIPPED,    #No.FUN-580004
            COLUMN g_c[36],sr.pml01,
            COLUMN g_c[37],sr.pml02 USING '####',
            COLUMN g_c[38],sr.pml07,
            COLUMN g_c[39],sr.pml35,
            COLUMN g_c[40],cl_numfor(sr.pml20,40,2) CLIPPED,
            COLUMN g_c[41],cl_numfor(sr.pml21,41,2) CLIPPED,
            COLUMN g_c[42],cl_numfor(sr.pml20-sr.pml21,42,2) CLIPPED
      PRINT COLUMN g_c[35],sr.pjf04,
            COLUMN g_c[37],sr.pjf041 CLIPPED
 
   ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN PRINT g_dash[1,g_len]  #TQC-6A0080
           #   IF tm.wc[001,80] > ' ' THEN			# for 132
 	   #	 PRINT g_x[8] CLIPPED,tm.wc[001,80] CLIPPED END IF
	#TQC-630166
	CALL cl_prt_pos_wc(tm.wc)
      END IF
      PRINT g_dash[1,g_len]  #TQC-6A0080
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED  #No.MOD-590003
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]  #TQC-6A0080
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED  #No.MOD-590003
         ELSE SKIP 2 LINE
      END IF
END REPORT}
#No.FUN-750115---End
