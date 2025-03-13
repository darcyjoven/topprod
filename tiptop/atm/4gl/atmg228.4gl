# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Pattern name...: atmg228.4gl
# Descriptions...: 客戶訂價表打印
# Date & Author..: 06/03/08 By Ray
# Modify.........: TQC-640165 06/04/20 By Ray 修改報表打印格式
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換 
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.TQC-740129 07/04/24 By sherry 打印結果中"from"跟“頁次”不在同一行，“頁次”格式錯誤。
# Modify.........: No.TQC-7B0118 07/11/21 By wujie   atmi227的狀態碼取消“申請”狀態，相應作調整 
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-850152 08/05/30 By ChenMoyan 舊報表轉CR
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9A0192 09/10/29 By Sarah l_table請定義為STRING
# Modify.........: No:TQC-A50164 10/05/31 By Carrier MOD-9A0192 追单
# Modify.........: No:FUN-B80061 11/08/05 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-CB0074 12/12/06 By lujh  CR轉GR
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
  DEFINE g_seq_item     LIKE type_file.num5          #No.FUN-680120 SMALLINT
END GLOBALS
 
 DEFINE tm  RECORD                         # Print condition RECORD
            #wc     LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(500)            # Where condition   #FUN-CB0074 mark
            wc      STRING,                          #FUN-CB0074 add
            a       LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(01)            # 是否打印產品價格明細
            more    LIKE type_file.chr1              #No.FUN-680120 VARCHAR(01)            # Input more condition(Y/N)
            END RECORD
 DEFINE g_rpt_name  LIKE type_file.chr20,            #No.FUN-680120 VARCHAR(20)   # For TIPTOP 串 EasyFlow
        g_po_no,g_ctn_no1,g_ctn_no2        LIKE bnb_file.bnb06         #No.FUN-680120 VARCHAR(20)      
 DEFINE g_cnt           LIKE type_file.num10         #No.FUN-680120 INTEGER
 DEFINE g_i             LIKE type_file.num5      #count/index for any purpose        #No.FUN-680120 SMALLINT
 DEFINE g_msg           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(72)
 DEFINE l_dbs_new       LIKE type_file.chr21         #No.FUN-680120 VARCHAR(21)  
 DEFINE l_azp  RECORD LIKE azp_file.*
#No.FUN-850152 --Begin
 DEFINE #g_sql           LIKE type_file.chr1000
        g_sql,g_sql1,g_sql2    STRING     #NO.FUN-910082
 #DEFINE g_sql1          LIKE type_file.chr1000
 #DEFINE g_sql2          LIKE type_file.chr1000
 DEFINE g_str           STRING   #No.TQC-A50164
 DEFINE l_table1        STRING   #MOD-9A0192 mod chr1000->STRING
 DEFINE l_table2        STRING   #MOD-9A0192 mod chr1000->STRING
#No.FUN-850152 --End
  
###GENGRE###START
TYPE sr1_t RECORD
    tqo01 LIKE tqo_file.tqo01,
    tqo02 LIKE tqo_file.tqo02,
    occ02 LIKE occ_file.occ02,
    tqm01 LIKE tqm_file.tqm01,
    tqm02 LIKE tqm_file.tqm02,
    tqm03 LIKE tqm_file.tqm03,
    tqa02 LIKE tqa_file.tqa02,
    tqm05 LIKE tqm_file.tqm05,
    tqm06 LIKE tqm_file.tqm06,
    tqm04 LIKE tqm_file.tqm04
END RECORD

TYPE sr2_t RECORD
    tqn01 LIKE tqn_file.tqn01,
    tqn02 LIKE tqn_file.tqn02,
    tqn03 LIKE tqn_file.tqn03,
    ima02 LIKE ima_file.ima02,
    ima021 LIKE ima_file.ima021,
    tqn04 LIKE tqn_file.tqn04,
    tqn05 LIKE tqn_file.tqn05,
    tqn06 LIKE tqn_file.tqn06,
    tqn07 LIKE tqn_file.tqn07
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
#No.FUN-850152 --Begin
   LET g_sql1="tqo01.tqo_file.tqo01,",
             "tqo02.tqo_file.tqo02,",
             "occ02.occ_file.occ02,",
             "tqm01.tqm_file.tqm01,",
             "tqm02.tqm_file.tqm02,",
             "tqm03.tqm_file.tqm03,",
             "tqa02.tqa_file.tqa02,",
             "tqm05.tqm_file.tqm05,",
             "tqm06.tqm_file.tqm06,",
             "tqm04.tqm_file.tqm04"
   LET l_table1=cl_prt_temptable('atmg228',g_sql1)
   IF l_table1=-1 THEN EXIT PROGRAM END IF
   LET g_sql2="tqn01.tqn_file.tqn01,",
             "tqn02.tqn_file.tqn02,",
             "tqn03.tqn_file.tqn03,",
             "ima02.ima_file.ima02,",
             "ima021.ima_file.ima021,",
             "tqn04.tqn_file.tqn04,",
             "tqn05.tqn_file.tqn05,",
             "tqn06.tqn_file.tqn06,",
             "tqn07.tqn_file.tqn07"
   LET l_table2=cl_prt_temptable('atmg228_sub',g_sql2)
   IF l_table2=-1 THEN EXIT PROGRAM END IF
#No.FUN-850152 --End
 
   LET g_rpt_name = ''
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.a ='Y'
   LET tm.wc = ARG_VAL(1)
   LET g_rpt_name = ARG_VAL(2)   # 外部指定報表名稱
   LET g_rep_user = ARG_VAL(3)
   LET g_rep_clas = ARG_VAL(4)
   LET g_template = ARG_VAL(5)
   IF cl_null(tm.wc) THEN
        CALL atmg228_tm(0,0)             # Input print condition
   ELSE LET tm.wc="tqo01= '",tm.wc CLIPPED,"'"
        CALL atmg228()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION atmg228_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680120 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(1000)
 
   LET p_row = 7 LET p_col = 17
 
   OPEN WINDOW atmg228_w AT p_row,p_col WITH FORM "atm/42f/atmg228"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON tqo01,tqo02
       BEFORE CONSTRUCT
         CALL cl_qbe_init()
       ON ACTION controlp
          CASE
             WHEN INFIELD(tqo01) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form ="q_occ09"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tqo01
                 NEXT FIELD tqo01
             WHEN INFIELD(tqo02) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form ="q_tqm"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tqo02
                 NEXT FIELD tqo02
             OTHERWISE EXIT CASE
          END CASE
       
       ON ACTION locale
         CALL cl_show_fld_cont()           
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION help          
         CALL cl_show_help() 
 
      ON ACTION controlg    
         CALL cl_cmdask()  
  
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
      LET INT_FLAG = 0 CLOSE WINDOW atmg228_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.a,tm.more WITHOUT DEFAULTS 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[YN]' THEN
            NEXT FIELD a
         END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG 
         CALL cl_cmdask()    # Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
      ON ACTION about  
         CALL cl_about()
      ON ACTION help   
         CALL cl_show_help() 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW atmg228_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='atmg228'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('atmg228','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.a CLIPPED,"'" ,
                         " '",tm.more CLIPPED,"'"  ,
                         " '",g_rep_user CLIPPED,"'", 
                         " '",g_rep_clas CLIPPED,"'",
                         " '",g_template CLIPPED,"'"
         CALL cl_cmdat('atmg228',g_time,l_cmd)    
      END IF
      CLOSE WINDOW atmg228_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL atmg228()
   ERROR ""
END WHILE
   CLOSE WINDOW atmg228_w
END FUNCTION
 
FUNCTION atmg228()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680120 VARCHAR(20)       # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6B0014
          #l_sql    LIKE type_file.chr1000,       #No.FUN-680120 VARCHAR(3000) 
          l_sql     STRING,                       #FUN-CB0074 add
          l_za05    LIKE ima_file.ima01,          #No.FUN-680120 VARCHAR(40)
          l_tqn     RECORD LIKE tqn_file.*,       #No.FUN-850152 
          l_ima02   LIKE ima_file.ima02,          #No.FUN-850152
          l_ima021  LIKE ima_file.ima021,         #No.FUN-850152
          l_occ02   LIKE occ_file.occ02,          #No.FUN-850152 
          l_tqa02   LIKE tqa_file.tqa02,          #No.FUN-850152 
          sr        RECORD
                    tqo01     LIKE tqo_file.tqo01,
                    tqo02     LIKE tqo_file.tqo02,
                    tqm01     LIKE tqm_file.tqm01,
                    tqm02     LIKE tqm_file.tqm02,
                    tqm03     LIKE tqm_file.tqm03,
                    tqm04     LIKE tqm_file.tqm04,   
                    tqm05     LIKE tqm_file.tqm05,   
                    tqm06     LIKE tqm_file.tqm06
                    END RECORD
 
#No.FUN-850152 --Begin
     LET g_sql1=" INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                " VALUES(?,?,?,?,?, ?,?,?,?,?)"
     PREPARE insert_prep1 FROM g_sql1
     IF STATUS THEN
         CALL cl_err('insert_prep1:',status,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80061   ADD
         EXIT PROGRAM
     END IF
     LET g_sql2=" INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                " VALUES(?,?,?,?,?, ?,?,?,?)"
     PREPARE insert_prep2 FROM g_sql2
     IF STATUS THEN
         CALL cl_err('insert_prep2:',status,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80061   ADD
         EXIT PROGRAM
     END IF
     CALL cl_del_data(l_table1)
     CALL cl_del_data(l_table2)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='atmg228'
#No.FUN-850152 --End
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND tqouser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND tqogrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND tqogrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('tqouser', 'tqogrup')
     #End:FUN-980030
 
      LET l_sql="SELECT tqo01,tqo02,tqm01,tqm02,tqm03,tqm04,tqm05,tqm06",  
               "  FROM tqo_file ,tqm_file",
               " WHERE tqo02=tqm_file.tqm01",
                "  AND ",tm.wc CLIPPED,
               " ORDER BY tqo01,tqo02 "
     PREPARE atmg228_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
        EXIT PROGRAM 
     END IF
     DECLARE atmg228_curs1 CURSOR FOR atmg228_prepare1
     IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF
 
#No.FUN-850152 --Begin
#    IF NOT cl_null(g_rpt_name)   #已有外部指定報表名稱
#       THEN
#       LET l_name = g_rpt_name
#    ELSE
#       CALL cl_outnam('atmg228') RETURNING l_name
#    END IF
#    IF tm.a='Y' THEN
#           LET g_zaa[40].zaa06 = "N"
#           LET g_zaa[41].zaa06 = "N"
#           LET g_zaa[42].zaa06 = "N"
#           LET g_zaa[43].zaa06 = "N"
#           LET g_zaa[44].zaa06 = "N"
#           LET g_zaa[45].zaa06 = "N"
#           LET g_zaa[46].zaa06 = "N"
#           LET g_zaa[47].zaa06 = "N"
#           LET g_zaa[48].zaa06 = "N"
#    ELSE
#           LET g_zaa[40].zaa06 = "Y"
#           LET g_zaa[41].zaa06 = "Y"
#           LET g_zaa[42].zaa06 = "Y"
#           LET g_zaa[43].zaa06 = "Y"
#           LET g_zaa[44].zaa06 = "Y"
#           LET g_zaa[45].zaa06 = "Y"
#           LET g_zaa[46].zaa06 = "Y"
#           LET g_zaa[47].zaa06 = "Y"
#           LET g_zaa[48].zaa06 = "Y"
#    END IF
#     CALL cl_prt_pos_len()
 
#    START REPORT atmg228_rep TO l_name
 
#    LET g_pageno = 0
#No.FUN-850152 --End
     FOREACH atmg228_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
#No.FUN-850152 --Begin
       SELECT tqa02 INTO l_tqa02 FROM tqa_file WHERE tqa01=sr.tqm03 and tqa03='19'                                                
       SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01=sr.tqo01     
       IF tm.a = 'Y' THEN                                                                                                      
               LET l_sql = "SELECT * ",                                                                                             
                          " FROM tqn_file ",                                                                                        
                          " WHERE tqn01 = '",sr.tqm01,"' "                                                                          
               PREPARE tqn_p1 FROM l_sql                                                                                            
               IF SQLCA.SQLCODE THEN CALL cl_err('tqn_p1',SQLCA.SQLCODE,1) END IF                                                   
               DECLARE tqn_c1  CURSOR FOR tqn_p1                                                                                    
               FOREACH tqn_c1 INTO l_tqn.*                                                                                          
                  SELECT ima02,ima021 INTO l_ima02,l_ima021                                                                         
                    FROM ima_file WHERE ima01=l_tqn.tqn03                                                                           
                  EXECUTE insert_prep2 USING l_tqn.tqn01,l_tqn.tqn02,l_tqn.tqn03,l_ima02,
                                            l_ima021,l_tqn.tqn04,l_tqn.tqn05,l_tqn.tqn06,l_tqn.tqn07
               END FOREACH                                                                                                          
        END IF                                        
        EXECUTE insert_prep1 USING sr.tqo01,sr.tqo02,l_occ02,sr.tqm01,sr.tqm02,sr.tqm03,l_tqa02,
                                   sr.tqm05,sr.tqm06,sr.tqm04
#       OUTPUT TO REPORT atmg228_rep(sr.*)
#No.FUN-850152 --End
     END FOREACH
 
#No.FUN-850152 --Begin
#    FINISH REPORT atmg228_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     IF g_zz05='Y' THEN
         CALL cl_wcchp(tm.wc,'tqo01,tqo02')
                RETURNING tm.wc
     ELSE
         LET tm.wc=""
     END IF
###GENGRE###     LET g_str=tm.wc
     IF tm.a='Y' THEN
###GENGRE###         LET g_sql=" SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,'|',                                                          
###GENGRE###               " SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED
###GENGRE###         CALL cl_prt_cs3('atmg228','atmg228',g_sql,g_str)
       LET g_template = 'atmg228'     #FUN-CB0074  add
       CALL atmg228_grdata()    ###GENGRE###
     ELSE
         #LET g_sql=" SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED   #FUN-CB0074  mark
###GENGRE###         CALL cl_prt_cs3('atmg228','atmg228_1',g_sql,g_str)
       LET g_template = 'atmg228_1'   #FUN-CB0074  add
       CALL atmg228_grdata_1()    ###GENGRE###
     END IF
#No.FUN-850152 --End
END FUNCTION
 
#No.FUN-850152 --Begin
#REPORT atmg228_rep(sr)
#  DEFINE l_tqa02  LIKE tqa_file.tqa02
#  DEFINE l_occ02  LIKE occ_file.occ02
#  DEFINE l_ima02  LIKE ima_file.ima02
#  DEFINE l_ima02a LIKE ima_file.ima02
#  DEFINE l_ima021 LIKE ima_file.ima02
#  DEFINE l_ima021a LIKE ima_file.ima02
#  DEFINE l_tqn    RECORD LIKE tqn_file.*
#  DEFINE l_last_sw    LIKE type_file.chr1,       #No.FUN-680120 VARCHAR(1)
#         sr        RECORD
#                   tqo01     LIKE tqo_file.tqo01,
#                   tqo02     LIKE tqo_file.tqo02,
#                   tqm01     LIKE tqm_file.tqm01,
#                   tqm02     LIKE tqm_file.tqm02,
#                   tqm03     LIKE tqm_file.tqm03,
#                   tqm04     LIKE tqm_file.tqm04,   
#                   tqm05     LIKE tqm_file.tqm05,   
#                   tqm06     LIKE tqm_file.tqm06
#                   END RECORD,         
#         l_n        LIKE type_file.num10,         #No.FUN-680120 INTEGER
#         l_t1       STRING, 
#         l_t3       STRING, 
#         l_t4       STRING, 
#         l_t2       STRING, 
#         l_tqs04    LIKE bnb_file.bnb06,          #No.FUN-680120 VARCHAR(20)  
#         l_sql      LIKE type_file.chr1000,       #No.FUN-680120 VARCHAR(800)
#         l_tqn_n    LIKE type_file.num10,         #No.FUN-680120 INTEGER  
#         l_tqr_n    LIKE type_file.num10,         #No.FUN-680120 INTEGER
#         l_tqs_n    LIKE type_file.num10,         #No.FUN-680120 INTEGER
#         l_tqt_n    LIKE type_file.num10,         #No.FUN-680120 INTEGER
#         i          LIKE type_file.num10,         #No.FUN-680120 INTEGER#TQC-840066
#         l_tqr02    LIKE ade_file.ade04           #No.FUN-680120 VARCHAR(4)      
#  OUTPUT
#     TOP MARGIN g_top_margin
#     LEFT MARGIN g_left_margin
#     BOTTOM MARGIN g_bottom_margin
#     PAGE LENGTH g_page_line
 
#  ORDER BY sr.tqo01,sr.tqo02
#
#  FORMAT
#     PAGE HEADER
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED ))/2+1),g_company CLIPPED 
#     #  PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED   #No.TQC-740129
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#        PRINT ' '
#      #No.TQC-740129---begin
#      # PRINT g_x[2] CLIPPED,g_today,' ',TIME,
#      #       COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#        LET g_pageno = g_pageno + 1 
#        LET pageno_total = PAGENO USING '<<<','/pageno'                                                                         
#        PRINT g_head CLIPPED, pageno_total  
#      #No.TQC-740129---end
#  	 SELECT tqa02 INTO l_tqa02 FROM tqa_file WHERE tqa01=sr.tqm03 and tqa03='19'
#        SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01=sr.tqo01
#        PRINT g_dash[1,g_len]
#        PRINTX NAME=H1
#              g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#              g_x[36],g_x[37],g_x[38],g_x[39]
#        PRINTX NAME=H2
#              g_x[49],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],   #No.TQC-640165
#              g_x[45],g_x[46],g_x[47],g_x[48]
#        PRINT g_dash1
#        LET l_last_sw = 'y'
 
#     BEFORE GROUP OF sr.tqo01
#        LET l_t4=sr.tqo01 CLIPPED,' ',l_occ02 CLIPPED
#        PRINTX NAME=D1
#              COLUMN g_c[31],sr.tqo01 CLIPPED,
#              COLUMN g_c[32],l_occ02 CLIPPED;
 
#     ON EVERY ROW
#        CASE
#            WHEN sr.tqm06='1'
#                 LET l_t1=g_x[9]
#            WHEN sr.tqm06='2'
#                 LET l_t1=g_x[10]
#            WHEN sr.tqm06='3'
#                 LET l_t1=g_x[11]
#            WHEN sr.tqm06='4'    
#                 LET l_t1=g_x[12]
#            WHEN sr.tqm06='5'
#                 LET l_t1=g_x[13]
#        END CASE 
#        CASE
#No.TQC-7B0118 --begin
#            WHEN sr.tqm04='0'
#                 LET l_t2=g_x[14]
#            WHEN sr.tqm04='1'
#                 LET l_t2=g_x[16]
#            WHEN sr.tqm04='2'    
#                 LET l_t2=g_x[17]
#             WHEN sr.tqm04='1'
#                  LET l_t2=g_x[14]
#             WHEN sr.tqm04='2'
#                  LET l_t2=g_x[15]
#             WHEN sr.tqm04='3'
#                  LET l_t2=g_x[16]
#             WHEN sr.tqm04='4'    
#                  LET l_t2=g_x[17]
#No.TQC-7B0118 --end
#        END CASE 
#           PRINTX NAME=D1
#                 COLUMN g_c[33],sr.tqm01 CLIPPED,
#                 COLUMN g_c[34],sr.tqm02 CLIPPED,
#                 COLUMN g_c[35],sr.tqm03 CLIPPED,
#                 COLUMN g_c[36],l_tqa02  CLIPPED,
#                 COLUMN g_c[37],sr.tqm05 CLIPPED,
#                 COLUMN g_c[38],sr.tqm06 CLIPPED,'-',l_t1 CLIPPED,
#                 COLUMN g_c[39],sr.tqm04 CLIPPED,'-',l_t2 CLIPPED
#           
#           IF tm.a = 'Y' THEN
#              LET l_sql = "SELECT * ",                         
#                      	  " FROM tqn_file ",
#              		  " WHERE tqn01 = '",sr.tqm01,"' "
#              PREPARE tqn_p1 FROM l_sql
#              IF SQLCA.SQLCODE THEN CALL cl_err('tqn_p1',SQLCA.SQLCODE,1) END IF
#              DECLARE tqn_c1  CURSOR FOR tqn_p1
#              FOREACH tqn_c1 INTO l_tqn.*
#  	          SELECT ima02,ima021 INTO l_ima02,l_ima021
#                   FROM ima_file WHERE ima01=l_tqn.tqn03
#                   PRINTX NAME=D2
#                               COLUMN g_c[41],l_tqn.tqn02 USING '##########',     #No.TQC-640165
#                               COLUMN g_c[42],l_tqn.tqn03 CLIPPED,
#                               COLUMN g_c[43],l_ima02 CLIPPED,
#                               COLUMN g_c[44],l_ima021 CLIPPED,
#                               COLUMN g_c[45],l_tqn.tqn04 CLIPPED,
#                        	COLUMN g_c[46],cl_numfor(l_tqn.tqn05,46,6),
#                        	COLUMN g_c[47],l_tqn.tqn06 CLIPPED,
#                        	COLUMN g_c[48],l_tqn.tqn07 CLIPPED
#              END FOREACH
#           END IF
#     
#      ON LAST ROW
#        IF g_zz05 = 'Y' THEN     
#           CALL cl_wcchp(tm.wc,'tqh01,tqh02') RETURNING tm.wc
#           PRINT g_dash[1,g_len]
#           CALL cl_prt_pos_wc(tm.wc)
#        END IF
#        PRINT g_dash[1,g_len]
#        PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#        LET l_last_sw = 'n'
 
#      PAGE TRAILER
#          IF l_last_sw = 'y' THEN
#             PRINT g_dash[1,g_len]
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#          ELSE
#              SKIP 2 LINE
#          END IF
 
#END REPORT
#No.FUN-850152 --End


###GENGRE###START
FUNCTION atmg228_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table1)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("atmg228")
        IF handler IS NOT NULL THEN
            START REPORT atmg228_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
                        ," ORDER BY lower(tqo01),tqo02"  #FUN-CB0074 by yangtt
          
            DECLARE atmg228_datacur1 CURSOR FROM l_sql
            FOREACH atmg228_datacur1 INTO sr1.*
                OUTPUT TO REPORT atmg228_rep(sr1.*)
            END FOREACH
            FINISH REPORT atmg228_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT atmg228_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-CB007--add--str--
    DEFINE l_msg1   STRING 
    DEFINE l_msg2   STRING 
    DEFINE l_sql    STRING 
    #FUN-CB007--add--str--
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            PRINTX tm.*

        BEFORE GROUP OF sr1.tqo01
            LET l_lineno = 0
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            #FUN-CB0074--add--str--
            IF cl_null(sr1.tqm06) THEN 
               LET l_msg1 = ' '
            ELSE
               LET l_msg1 = sr1.tqm06, '-', cl_gr_getmsg("gre-328",g_lang,sr1.tqm06)
            END IF 
            PRINTX l_msg1

            IF cl_null(sr1.tqm04) THEN 
               LET l_msg2 = ' '
            ELSE
               LET l_msg2 = sr1.tqm04, '-', cl_gr_getmsg("gre-330",g_lang,sr1.tqm04)
            END IF 
            PRINTX l_msg2
            
            
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                        " WHERE tqn01='",sr1.tqm01,"'"
            START REPORT atmg228_subrep01
            DECLARE atmg228_subrep01 CURSOR FROM l_sql
            FOREACH atmg228_subrep01 INTO sr2.*
                OUTPUT TO REPORT atmg228_subrep01(sr2.*)
            END FOREACH
            FINISH REPORT atmg228_subrep01
            #FUN-CB0074--add--end--

            PRINTX sr1.*

        AFTER GROUP OF sr1.tqo01
        
        ON LAST ROW

END REPORT

#FUN-CB0074--add--str--
REPORT atmg228_subrep01(sr2)
    DEFINE sr2 sr2_t

    FORMAT
        ON EVERY ROW
           
           PRINTX sr2.*
END REPORT

FUNCTION atmg228_grdata_1()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table1)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("atmg228")
        IF handler IS NOT NULL THEN
            START REPORT atmg228_rep1 TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
                        ," ORDER BY lower(tqo01),tqo02"  #FUN-CB0074 by yangtt
          
            DECLARE atmg228_datacur2 CURSOR FROM l_sql
            FOREACH atmg228_datacur2 INTO sr1.*
                OUTPUT TO REPORT atmg228_rep1(sr1.*)
            END FOREACH
            FINISH REPORT atmg228_rep1
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT atmg228_rep1(sr1)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_msg1   STRING 
    DEFINE l_msg2   STRING 
    DEFINE l_sql    STRING 
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            PRINTX tm.*

        BEFORE GROUP OF sr1.tqo01
            LET l_lineno = 0
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            IF cl_null(sr1.tqm06) THEN 
               LET l_msg1 = ' '
            ELSE
               LET l_msg1 = sr1.tqm06, '-', cl_gr_getmsg("gre-328",g_lang,sr1.tqm06)
            END IF 
            PRINTX l_msg1

            IF cl_null(sr1.tqm04) THEN 
               LET l_msg2 = ' '
            ELSE
               LET l_msg2 = sr1.tqm04, '-', cl_gr_getmsg("gre-330",g_lang,sr1.tqm04)
            END IF 
            PRINTX l_msg2

            PRINTX sr1.*

        AFTER GROUP OF sr1.tqo01
        
        ON LAST ROW

END REPORT
#FUN-CB0074--add--end--
###GENGRE###END
