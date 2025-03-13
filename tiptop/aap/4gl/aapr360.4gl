# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aapr360.4gl
# Desc/riptions..: 分錄底稿/傳票檢查報表             
# Date & Author..: 97/01/08 By APPLE
# Modify.........: No.FUN-4C0097 04/12/31 By Nicola 報表架構修改
#                                                   增加列印科目名稱aag02
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/09 By baogui 結束位置調整
# Modify.........: No.TQC-6B0128 06/11/27 By Rayven 取消對act14和act16的mark
# Modify.........: No.MOD-710174 07/01/29 By jamie "原因分析"沒有顯示出來,在 act14段,(1)顯示位置不對,(2)沒有 g_x[15]
# Modify.........: No.FUN-730064 07/04/03 By arman  會計科目加賬套
# Modify.........: No.TQC-740139 07/04/19 By Smapmin 項次長度不對,資料未對齊,未印出科目名稱,原因分析不完整
# Modify.........: No.MOD-740058 07/04/19 By Smapmin 金額顯示有誤
# Modify.........: No.FUN-750095 07/06/06 By johnray 修改報表功能，使用CR打印報表
# Modify.........: No.FUN-750119 07/08/08 By xufeng QBE增加會計科目欄位 
# Modify.........: No.FUN-810069 08/02/27 By yaofs 項目預算取消abb15的管控 
# Modify.........: No.MOD-860283 08/07/04 By Sarah SQL中有抓apf_file的需增加條件apf00 = '33'
# Modify.........: No.MOD-950137 09/05/13 By lilingyu SQL中增加選擇npp01
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9A0111 09/10/16 By mike FUNCTION r360_cur()的l_sql,请多串aba_file,并加上aba06='AP'条件                    
# Modify.........: No:MOD-AC0248 10/12/21 By Dido SUM(npq07) 應增加 npp_file  
# Modify.........: No:FUN-B20014 11/02/12 By lilingyu QBE種類增加3.退款 4.調帳
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.FUN-BB0047 11/11/25 By fengrui  調整時間函數問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD            
                 wc       LIKE type_file.chr1000,  #No.FUN-690028 VARCHAR(600)
                 p        LIKE type_file.chr1,     # No.FUN-690028 VARCHAR(01),
                 more     LIKE type_file.chr1      # No.FUN-690028 VARCHAR(01)
              END RECORD,
          g_bookno        LIKE aaa_file.aaa01,
          g_aaa           RECORD LIKE aaa_file.*
   DEFINE g_i             LIKE type_file.num5      #count/index for any purpose  #No.FUN-690028 SMALLINT
#  DEFINE l_time          LIKE type_file.chr8      #No.FUN-6A0055
#No.FUN-750095 -- begin --
   DEFINE g_sql           STRING
   DEFINE l_table         STRING
   DEFINE g_str           STRING
#No.FUN-750095 -- end --
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                           # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055 #FUN-BB0047 add
   LET g_pdate  = ARG_VAL(1)                 
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.p  = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   LET g_bookno   = g_apz.apz02b         
#No.FUN-750095 -- begin --
   LET g_sql = "abb01.abb_file.abb01,",
               "abb02.abb_file.abb02,",
               "abb03.abb_file.abb03,",
               "abb07.abb_file.abb07,",
               "amt.abb_file.abb07,",
               "errno.ze_file.ze01,",
               "aag02.aag_file.aag02,",
               "npp01.npp_file.npp01"          #MOD-950137
   LET l_table = cl_prt_temptable('aapr360',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              # " VALUES(?,?,?,?,?,?,?)"       #MOD-950137 mark
                " VALUES(?,?,?,?,?,?,?,?)"     #MOD-950137     
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',STATUS,1) EXIT PROGRAM
   END IF
#No.FUN-750095 -- end --
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN 
      CALL r360_tm(0,0)
   ELSE
      CALL aapr360()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD 
END MAIN
 
FUNCTION r360_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col   LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_flag        LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          l_cmd         LIKE type_file.chr1000   #No.FUN-690028 VARCHAR(400)
 
   LET p_row = 3 LET p_col = 20
   OPEN WINDOW r360_w AT p_row,p_col
     WITH FORM "aap/42f/aapr360"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.more = 'N'
   LET tm.p    = '1'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON npp01,npp02,npq03 #add npq03 FUN-750119
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
            LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
     
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r360_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
        
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      
      INPUT BY NAME tm.p,tm.more WITHOUT DEFAULTS 
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD p
#           IF tm.p NOT MATCHES "[12]" THEN         #FUN-B20014 
            IF tm.p NOT MATCHES "[1234]" THEN       #FUN-B20014 
               NEXT FIELD p
            END IF
 
         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
               NEXT FIELD more
            END IF
 
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
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
         CLOSE WINDOW r360_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
          WHERE zz01='aapr360'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aapr360','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,             #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.p  CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aapr360',g_time,l_cmd)      # Execute cmd at later time
         END IF
 
         CLOSE WINDOW r360_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL aapr360()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r360_w
 
END FUNCTION
   
FUNCTION r360_cur()
DEFINE l_sql LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(1000)
 
  #LET l_sql="SELECT abb_file.*,aag_file.* ",    #MOD-740058
  LET l_sql="SELECT DISTINCT abb01,abb03,aag_file.* ",    #MOD-740058
             " FROM abb_file,aba_file,OUTER aag_file", #MOD-9A0111 add aba_file      
             " WHERE abb_file.abb03=aag_file.aag01 AND abb00='",g_bookno,"' AND abb01 = ? ",
             "   AND abb00=aba00 AND abb01=aba01 AND aba06='AP'", #MOD-9A0111      
             "  AND abb_file.abb00=aag_file.aag00 "        #NO.FUN-730064
   PREPARE r360_preact FROM l_sql
   IF SQLCA.sqlcode != 0 THEN 
      CALL cl_err('prepare:preact',SQLCA.sqlcode,1)
   END IF
   DECLARE r360_csact CURSOR FOR r360_preact
 
   IF tm.p='1' THEN
      LET l_sql="SELECT npp01,npp03  FROM npp_file,apa_file ",
                " WHERE apa01=npp01 AND nppsys='AP' AND apa44 = ? "
   ELSE
      IF tm.p = '2' THEN       #FUN-B20014 
         LET l_sql="SELECT npp01,npp03  FROM npp_file,apf_file ",
                  " WHERE apf01=npp01 AND nppsys='AP' AND apf00='33' AND apf44 = ? "   #MOD-860283 add apf00='33'
#FUN-B20014 --begin--                  
      ELSE
        IF tm.p = '3' THEN
           LET l_sql="SELECT npp01,npp03  FROM npp_file,apf_file ",
                    " WHERE apf01=npp01 AND nppsys='AP' AND apf00='32' AND apf44 = ? "         
        ELSE
           LET l_sql="SELECT npp01,npp03  FROM npp_file,apf_file ",
                    " WHERE apf01=npp01 AND nppsys='AP' AND apf00='36' AND apf44 = ? "         
        END IF 
      END IF         
#FUN-B20014 --end--          
   END IF
   
   PREPARE r360_preactdat FROM l_sql
   IF SQLCA.sqlcode != 0 THEN 
      CALL cl_err('prepare:preactdat',SQLCA.sqlcode,1)
   END IF
   DECLARE r360_actdate CURSOR FOR r360_preactdat
 
END FUNCTION
   
FUNCTION aapr360()
   DEFINE l_name        LIKE type_file.chr20,                # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#         l_time        LIKE type_file.chr8,                  # Used time for running the job  #No.FUN-690028 VARCHAR(8)
          l_sql         LIKE type_file.chr1000,            # RDSQL STATEMENT  #No.FUN-690028 VARCHAR(1200)
          l_chr         LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          l_nppglno     LIKE npp_file.nppglno,
          l_npp01       LIKE npp_file.npp01,
          l_npp03       LIKE npp_file.npp03,
          l_cnt,l_seq   LIKE type_file.num5,        # No.FUN-690028 SMALLINT,
          l_cnt2        LIKE type_file.num5,   #MOD-740058
          l_npp         RECORD LIKE npp_file.*,
          l_aba         RECORD LIKE aba_file.*,
          l_abb         RECORD LIKE abb_file.*,
          l_aag         RECORD LIKE aag_file.*,
          l_cramt,l_dramt      LIKE abb_file.abb07,
          l_cr,l_dr            LIKE abb_file.abb07,
          l_c_npp,l_d_npp      LIKE abb_file.abb07,
          l_c_abb,l_d_abb      LIKE abb_file.abb07
   DEFINE m_npp01              LIKE npp_file.npp01   #MOD-950137 
   
#    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   CALL cl_del_data(l_table)       #No.FUN-750095
   
   CALL r360_cur()
 
   #--->依分錄角度
   IF tm.p='1' THEN
      LET l_sql="SELECT unique apa44,npp01 FROM npp_file,apa_file,npq_file ", #FUN-750119 add npq_file  #MOD-950137 add npp01
                " WHERE npp01=apa01 AND apa44 IS NOT NULL AND apa44 != ' ' ",
                "   AND apa42 = 'N' AND apa75='N' ",
                #FUN-750119  add --begin--
                "   AND npp01 = npq01 AND nppsys=npqsys ",
                "   AND npp00=npq00 AND npp011=npq011 ",
                #FUN-750119  add --end----
                "   AND nppsys = 'AP' AND   ",tm.wc CLIPPED
   ELSE
      IF tm.p = '2' THEN            #fun-b20014
         LET l_sql="SELECT unique apf44,npp01 FROM npp_file,apf_file,npq_file ",   #MOD-860283 add npq_file  #MOD-950137 add npp01
                  " WHERE npp01=apf01 AND apf44 IS NOT NULL AND apf44 != ' ' ",
                  #FUN-750119  add --begin--
                  "   AND npp01 = npq01 AND nppsys=npqsys ",
                  "   AND npp00=npq00 AND npp011=npq011 ",
                  #FUN-750119  add --end----
                  "   AND apf00 = '33' ",   #MOD-860283 add
                  "   AND apf41 <> 'X' ",
                  "   AND nppsys='AP' AND   ",tm.wc CLIPPED
#FUN-B20014 --begin--
      ELSE
         IF tm.p = '3' THEN
            LET l_sql="SELECT unique apf44,npp01 FROM npp_file,apf_file,npq_file ",  
                      " WHERE npp01=apf01 AND apf44 IS NOT NULL AND apf44 != ' ' ",
                      "   AND npp01 = npq01 AND nppsys=npqsys ",
                      "   AND npp00=npq00 AND npp011=npq011 ",
                      "   AND apf00 = '32' ",   
                      "   AND apf41 <> 'X' ",
                      "   AND nppsys='AP' AND   ",tm.wc CLIPPED         
         ELSE
            LET l_sql="SELECT unique apf44,npp01 FROM npp_file,apf_file,npq_file ",   
                      " WHERE npp01=apf01 AND apf44 IS NOT NULL AND apf44 != ' ' ",
                      "   AND npp01 = npq01 AND nppsys=npqsys ",
                      "   AND npp00=npq00 AND npp011=npq011 ",
                      "   AND apf00 = '36' ",   
                      "   AND apf41 <> 'X' ",
                      "   AND nppsys='AP' AND   ",tm.wc CLIPPED             
         END IF 
      END IF 
#FUN-B20014 --end--                  
   END IF
   PREPARE r360_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN 
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM 
   END IF
   DECLARE r360_cs1 CURSOR FOR r360_prepare1
 
#No.FUN-750095 -- begin --
#   CALL cl_outnam('aapr360') RETURNING l_name
#   START REPORT r360_rep TO l_name
#No.FUN-750095 -- end --
 
  FOREACH r360_cs1 INTO l_nppglno,m_npp01               #MOD-950137 add m_npp01   
      IF SQLCA.sqlcode != 0 THEN 
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH 
      END IF
      
      DISPLAY l_nppglno AT 18,3
      
      #-->1.分錄單頭借貸不等
      IF tm.p='1' THEN
         SELECT SUM(npq07) INTO l_dramt FROM npp_file,npq_file,apa_file
                           WHERE apa01=npq01 AND apa44=l_nppglno
                             AND npq06 = '1' AND npp01=npq01
                             AND nppsys='AP' AND nppsys=npqsys
                             AND npp00 = npq00 AND npp011 = npq011
                             AND npptype = npqtype AND npptype = '0'  #MOD-AC0248 
      ELSE
         IF tm.p = '2' THEN       #FUN-B20014 
           SELECT SUM(npq07) INTO l_dramt FROM npp_file,npq_file,apf_file
                             WHERE apf01=npq01 AND apf44=l_nppglno
                               AND npq06 = '1' AND npp01=npq01
                               AND nppsys='AP' AND nppsys=npqsys
                               AND npp00 = npq00 AND npp011 = npq011
                               AND apf00 ='33'   #MOD-860283 add
                               AND npptype = npqtype AND npptype = '0'  #MOD-AC0248 
#FUN-B20014 --begin--
         ELSE
            IF tm.p = '3' THEN
              SELECT SUM(npq07) INTO l_dramt FROM npp_file,npq_file,apf_file
                               WHERE apf01=npq01 AND apf44=l_nppglno
                                 AND npq06 = '1' AND npp01=npq01
                                 AND nppsys='AP' AND nppsys=npqsys
                                 AND npp00 = npq00 AND npp011 = npq011
                                 AND apf00 ='32'   
                                 AND npptype = npqtype AND npptype = '0'  
            ELSE
              SELECT SUM(npq07) INTO l_dramt FROM npp_file,npq_file,apf_file
                               WHERE apf01=npq01 AND apf44=l_nppglno
                                 AND npq06 = '1' AND npp01=npq01
                                 AND nppsys='AP' AND nppsys=npqsys
                                 AND npp00 = npq00 AND npp011 = npq011
                                 AND apf00 ='36'   
                                 AND npptype = npqtype AND npptype = '0'  
            END IF 
         END IF 
#FUN-B20014 --end--                               
      END IF
      
      IF tm.p='1' THEN
         SELECT SUM(npq07) INTO l_cramt FROM npp_file,npq_file,apa_file
                           WHERE apa01=npq01 AND apa44=l_nppglno
                             AND npq06 = '2' AND npp01=npq01
                             AND nppsys='AP' AND nppsys=npqsys
                             AND npp00 = npq00 AND npp011 = npq011
                             AND npptype = npqtype AND npptype = '0'  #MOD-AC0248 
      ELSE
        IF tm.p = '2' THEN              #FUN-B20014 
           SELECT SUM(npq07) INTO l_cramt FROM npp_file,npq_file,apf_file
                             WHERE apf01=npq01 AND apf44=l_nppglno
                               AND npq06 = '2' AND npp01=npq01
                               AND nppsys='AP' AND nppsys=npqsys
                               AND npp00 = npq00 AND npp011 = npq011
                               AND apf00 ='33'   #MOD-860283 add
                               AND npptype = npqtype AND npptype = '0'  #MOD-AC0248 
#FUN-B20014 --begin--
       ELSE
           IF tm.p = '3' THEN
             SELECT SUM(npq07) INTO l_cramt FROM npp_file,npq_file,apf_file
                               WHERE apf01=npq01 AND apf44=l_nppglno
                                 AND npq06 = '2' AND npp01=npq01
                                 AND nppsys='AP' AND nppsys=npqsys
                                 AND npp00 = npq00 AND npp011 = npq011
                                 AND apf00 ='32'   
                                 AND npptype = npqtype AND npptype = '0'  
           ELSE
             SELECT SUM(npq07) INTO l_cramt FROM npp_file,npq_file,apf_file
                               WHERE apf01=npq01 AND apf44=l_nppglno
                                 AND npq06 = '2' AND npp01=npq01
                                 AND nppsys='AP' AND nppsys=npqsys
                                 AND npp00 = npq00 AND npp011 = npq011
                                 AND apf00 ='36'   
                                 AND npptype = npqtype AND npptype = '0'             
           END IF         
       END IF 
#FUN-B20014 --end--                               
      END IF
      
      IF l_dramt != l_cramt  THEN
         #OUTPUT TO REPORT r360_rep(l_nppglno,'','',0,0,'npp1',l_aag.aag02)   #MOD-740058
#No.FUN-750095 -- begin --
#         OUTPUT TO REPORT r360_rep(l_nppglno,'','',0,0,'npp1','')   #MOD-740058
          EXECUTE insert_prep USING l_nppglno,'','','0','0','npp1','',m_npp01   #MOD-950137 add m_npp01
          IF STATUS THEN
             CALL cl_err("execute insert_prep:",STATUS,1)
          END IF
#No.FUN-750095 -- end --
         LET l_cnt = l_cnt + 1
      END IF
      
      #-->利用傳票與底稿比對
      #FOREACH r360_csact USING l_nppglno INTO l_abb.*,l_aag.*   #MOD-740058
      FOREACH r360_csact USING l_nppglno INTO l_abb.abb01,l_abb.abb03,l_aag.*   #MOD-740058
         IF SQLCA.sqlcode != 0 THEN 
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH 
         END IF
 
#        #-->b2.科目編號無效    
#        IF l_aag.aagacti = 'N' THEN 
#           OUTPUT TO REPORT r360_rep(l_abb.abb01,l_abb.abb02,l_abb.abb03,'act1')
#           LET l_cnt = l_cnt + 1
#        END IF
 
#        #-->b3.科目性質不為帳戶
#        IF l_aag.aag03 != '2' THEN 
#           OUTPUT TO REPORT r360_rep(l_abb.abb01,l_abb.abb02,l_abb.abb03,'act2')
#           LET l_cnt = l_cnt + 1
#        END IF
 
#        #-->b4.不為明細或獨立帳戶
#        IF l_aag.aag07 = '1' THEN 
#           OUTPUT TO REPORT r360_rep(l_abb.abb01,l_abb.abb02,l_abb.abb03,'act3')
#           LET l_cnt = l_cnt + 1
#        END IF
 
#        #-->b3.部門管理
#        IF l_aag.aag05 = 'Y' AND (l_abb.abb05 = ' ' OR l_abb.abb05 IS NULL) THEN
#           OUTPUT TO REPORT r360_rep(l_abb.abb01,l_abb.abb02,l_abb.abb03,'act4')
#           LET l_cnt = l_cnt + 1
#        END IF
#        
#        #-->b4.異動碼需存在
#        IF l_aag.aag151 matches '[23]' AND (l_abb.abb11 = ' ' OR l_abb.abb11 IS NULL) THEN
#        OUTPUT TO REPORT r360_rep(l_abb.abb01,l_abb.abb02,l_abb.abb03,'act5')
#               LET l_cnt = l_cnt + 1
#        END IF
 
#        IF l_aag.aag161 matches '[23]' AND (l_abb.abb12 = ' ' OR l_abb.abb12 IS NULL) THEN
#           OUTPUT TO REPORT r360_rep(l_abb.abb01,l_abb.abb03,l_abb.abb03,'act6')
#           LET l_cnt = l_cnt + 1
#        END IF
 
#        IF l_aag.aag171 matches '[23]' AND (l_abb.abb13 = ' ' OR l_abb.abb13 IS NULL) THEN
#           OUTPUT TO REPORT r360_rep(l_abb.abb01,l_abb.abb03,l_abb.abb03,'act7')
#           LET l_cnt = l_cnt + 1
#        END IF
 
#        IF l_aag.aag181 matches '[23]' AND (l_abb.abb14 = ' ' OR l_abb.abb14 IS NULL) THEN
#           OUTPUT TO REPORT r360_rep(l_abb.abb01,l_abb.abb03,l_abb.abb03,'act8')
#           LET l_cnt = l_cnt + 1
#        END IF
 
#        #-->b4.異動碼需存在(aee_file)
#        IF l_aag.aag151 ='3' AND (l_abb.abb11 = ' ' OR l_abb.abb11 IS NULL) THEN 
#           SELECT count(*) INTO l_seq FROM aee_file 
#            WHERE aee01 =l_abb.abb03
#              AND aee02 ='1'
#              AND aee03 =l_abb.abb11
#           IF l_seq != 1 THEN 
#              OUTPUT TO REPORT r360_rep(l_abb.abb01,l_abb.abb03,l_abb.abb03,'act9') 
#           END IF
#           LET l_cnt = l_cnt + 1
#        END IF
 
#        IF l_aag.aag161 ='3' AND (l_abb.abb12 = ' ' OR l_abb.abb12 IS NULL) THEN
#           SELECT count(*) INTO l_seq FROM aee_file 
#            WHERE aee01 =l_abb.abb03
#              AND aee02 ='2'
#              AND aee03 =l_abb.abb12
#           IF l_seq != 1 THEN 
#              OUTPUT TO REPORT r360_rep(l_abb.abb01,l_abb.abb03,l_abb.abb03,'act10') 
#           END IF
#           LET l_cnt = l_cnt + 1
#        END IF
 
#        IF l_aag.aag171 ='3' AND (l_abb.abb13 = ' ' OR l_abb.abb13 IS NULL) THEN
#           SELECT count(*) INTO l_seq FROM aee_file 
#            WHERE aee01 =l_abb.abb03
#              AND aee02 ='3'
#              AND aee03 =l_abb.abb13
#           IF l_seq != 1 THEN 
#              OUTPUT TO REPORT r360_rep(l_abb.abb01,l_abb.abb03,l_abb.abb03,'act11') 
#           END IF
#           LET l_cnt = l_cnt + 1
#        END IF
 
#        IF l_aag.aag181 ='3' AND (l_abb.abb14 = ' ' OR l_abb.abb14 IS NULL) THEN
#           SELECT count(*) INTO l_cnt FROM aee_file 
#            WHERE aee01 =l_abb.abb03
#              AND aee02 ='4'
#              AND aee03 =l_abb.abb14
#           IF l_seq != 1 THEN 
#              OUTPUT TO REPORT r360_rep(l_abb.abb01,l_abb.abb03,l_abb.abb03,'act12') 
#           END IF
#           LET l_cnt = l_cnt + 1
#        END IF
 
#---begin---    No.FUN-810069 
#        #-->b5.預算控制
#        IF l_aag.aag21 ='Y' AND (l_abb.abb15 = ' ' OR l_abb.abb15 IS NULL) THEN
#           OUTPUT TO REPORT r360_rep(l_abb.abb01,l_abb.abb03,l_abb.abb03,'act13') 
#           LET l_cnt = l_cnt + 1
#        END IF
#---end---      No.FUN-810069 
         
         #-->b2.科目金額不合
         LET l_d_abb=0
         LET l_c_abb=0
         IF tm.p='1' THEN
            SELECT SUM(npq07) INTO l_dr FROM npq_file,apa_file,npp_file  #MOD-AC0248 add npp_file
             WHERE apa01 = npq01
               AND apa44 = l_nppglno AND npq06 = '1'
               AND npq03 = l_abb.abb03   #科目
               AND npp01 = npq01                                         #MOD-AC0248
               AND nppsys = 'AP' AND nppsys = npqsys                     #MOD-AC0248
               AND npp00 = npq00 AND npp011 = npq011                     #MOD-AC0248
               AND npptype = npqtype AND npptype = '0'                   #MOD-AC0248 
         
            SELECT SUM(npq07) INTO l_cr FROM npq_file,apa_file,npp_file  #MOD-AC0248 add npp_file
             WHERE apa01 = npq01
               AND apa44 = l_nppglno AND npq06 = '2'
               AND npq03 = l_abb.abb03   #科目
               AND npp01 = npq01                                         #MOD-AC0248
               AND nppsys = 'AP' AND nppsys = npqsys                     #MOD-AC0248
               AND npp00 = npq00 AND npp011 = npq011                     #MOD-AC0248
               AND npptype = npqtype AND npptype = '0'                   #MOD-AC0248 
         ELSE
           IF tm.p = '2' THEN         #FUN-B20014 
            SELECT SUM(npq07) INTO l_dr FROM npq_file,apf_file,npp_file  #MOD-AC0248 add npp_file
             WHERE apf01 = npq01
               AND apf44 = l_nppglno AND npq06 = '1'
               AND npq03 = l_abb.abb03   #科目
               AND apf00 ='33'   #MOD-860283 add
               AND npp01 = npq01                                         #MOD-AC0248
               AND nppsys = 'AP' AND nppsys = npqsys                     #MOD-AC0248
               AND npp00 = npq00 AND npp011 = npq011                     #MOD-AC0248
               AND npptype = npqtype AND npptype = '0'                   #MOD-AC0248 
         
            SELECT SUM(npq07) INTO l_cr FROM npq_file,apf_file,npp_file  #MOD-AC0248 add npp_file
             WHERE apf01 = npq01
               AND apf44 = l_nppglno AND npq06 = '2'
               AND npq03 = l_abb.abb03   #科目
               AND apf00 ='33'   #MOD-860283 add
               AND npp01 = npq01                                         #MOD-AC0248
               AND nppsys = 'AP' AND nppsys = npqsys                     #MOD-AC0248
               AND npp00 = npq00 AND npp011 = npq011                     #MOD-AC0248
               AND npptype = npqtype AND npptype = '0'                   #MOD-AC0248 
#FUN-B20014 --begin--
          ELSE
            IF tm.p = '3' THEN
            SELECT SUM(npq07) INTO l_dr FROM npq_file,apf_file,npp_file 
             WHERE apf01 = npq01
               AND apf44 = l_nppglno AND npq06 = '1'
               AND npq03 = l_abb.abb03   #科目
               AND apf00 ='32'   
               AND npp01 = npq01                                        
               AND nppsys = 'AP' AND nppsys = npqsys                
               AND npp00 = npq00 AND npp011 = npq011                  
               AND npptype = npqtype AND npptype = '0'              
         
            SELECT SUM(npq07) INTO l_cr FROM npq_file,apf_file,npp_file 
             WHERE apf01 = npq01
               AND apf44 = l_nppglno AND npq06 = '2'
               AND npq03 = l_abb.abb03   #科目
               AND apf00 ='32'   
               AND npp01 = npq01                                         
               AND nppsys = 'AP' AND nppsys = npqsys                   
               AND npp00 = npq00 AND npp011 = npq011                    
               AND npptype = npqtype AND npptype = '0'                
            ELSE
            SELECT SUM(npq07) INTO l_dr FROM npq_file,apf_file,npp_file 
             WHERE apf01 = npq01
               AND apf44 = l_nppglno AND npq06 = '1'
               AND npq03 = l_abb.abb03   #科目
               AND apf00 ='36'   
               AND npp01 = npq01                                         
               AND nppsys = 'AP' AND nppsys = npqsys                  
               AND npp00 = npq00 AND npp011 = npq011                    
               AND npptype = npqtype AND npptype = '0'                  
         
            SELECT SUM(npq07) INTO l_cr FROM npq_file,apf_file,npp_file 
             WHERE apf01 = npq01
               AND apf44 = l_nppglno AND npq06 = '2'
               AND npq03 = l_abb.abb03   #科目
               AND apf00 ='36' 
               AND npp01 = npq01                                       
               AND nppsys = 'AP' AND nppsys = npqsys                  
               AND npp00 = npq00 AND npp011 = npq011                   
               AND npptype = npqtype AND npptype = '0'                  
            END IF 
          END IF 
#FUN-B20014 --end--               
         END IF
 
         IF l_dr IS NULL THEN
            LET l_dr = 0
         END IF
 
         IF l_cr IS NULL THEN
            LET l_cr = 0
         END IF
 
         LET l_dr = l_dr - l_cr
 
         SELECT SUM(abb07) INTO l_d_abb FROM abb_file
          WHERE abb00=g_bookno
            AND abb01=l_abb.abb01
            AND abb03=l_abb.abb03
            AND abb06="1"          
 
         SELECT SUM(abb07) INTO l_c_abb FROM abb_file
          WHERE abb00=g_bookno
            AND abb01=l_abb.abb01
            AND abb03=l_abb.abb03
            AND abb06="2"          
 
         IF l_d_abb IS NULL THEN
            LET l_d_abb = 0
         END IF
 
         IF l_c_abb IS NULL THEN
            LET l_c_abb = 0
         END IF
 
         LET l_abb.abb07 = l_d_abb - l_c_abb
         
         IF l_abb.abb07<>l_dr THEN 
            #OUTPUT TO REPORT r360_rep(l_abb.abb01,l_abb.abb02,l_abb.abb03,   #MOD-740058
#No.FUN-750095 -- begin --
#            OUTPUT TO REPORT r360_rep(l_abb.abb01,'',l_abb.abb03,   #MOD-740058
#                                      l_abb.abb07,l_dr,'act14',l_aag.aag02)
            EXECUTE insert_prep USING l_abb.abb01,'',l_abb.abb03,l_abb.abb07,
                                      l_dr,'act14',l_aag.aag02,m_npp01   #MOD-950137 add m_npp01
            IF STATUS THEN
               CALL cl_err("execute insert_prep:",STATUS,1)
               EXIT FOREACH
            END IF
#No.FUN-750095 -- end --
            LET l_cnt = l_cnt + 1
         END IF
      END FOREACH
 
      SELECT aba06 INTO l_aba.aba06 FROM aba_file
       WHERE aba00=g_bookno
         AND aba01=l_abb.abb01
 
      IF l_aba.aba06 <> "AP" THEN
         #OUTPUT TO REPORT r360_rep(l_abb.abb01,l_abb.abb02,l_abb.abb03,   #MOD-740058
#No.FUN-750095 -- begin --
#         OUTPUT TO REPORT r360_rep(l_abb.abb01,'','',   #MOD-740058
#                                   #l_abb.abb07,l_dr,'act1',l_aag.aag02)    #MOD-740058
#                                   0,0,'act1','')    #MOD-740058
          EXECUTE insert_prep USING l_abb.abb01,'','','0','0','act1','',m_npp01   #MOD-950137 add m_npp01
          IF STATUS THEN
             CALL cl_err("execute insert_prep:",STATUS,1)
             EXIT FOREACH
          END IF
#No.FUN-750095 -- end --
         LET l_cnt = l_cnt + 1
      END IF
 
      #-----MOD-740058---------
      LET l_cnt2 = 0
      SELECT COUNT(*) INTO l_cnt2 FROM aba_file
        WHERE aba01 = l_nppglno
      IF l_cnt2 = 0 THEN
#No.FUN-750095 -- begin --
#         OUTPUT TO REPORT r360_rep(l_nppglno,'','',0,0,'act16','')
          EXECUTE insert_prep USING l_nppglno,'','','0','0','act16','',m_npp01   #MOD-950137 add m_npp01
          IF STATUS THEN
             CALL cl_err("execute insert_prep:",STATUS,1)
             EXIT FOREACH
          END IF
#No.FUN-750095 -- end --
      END IF
      #-----END MOD-740058-----
 
 
#     #-->E.傳票無效
#     SELECT abaacti INTO l_aba.abaacti FROM aba_file
#      WHERE aba00="00"
#        AND aba01=l_abb.abb01
#     
#     IF l_aba.abaacti != 'Y' THEN 
#        OUTPUT TO REPORT r360_rep(l_abb.abb01,l_abb.abb02,l_abb.abb03,'act15') 
#        LET l_cnt = l_cnt + 1
#     END IF
   END FOREACH
#-----MOD-740058---------
#  #--->依傳票角度(由子系統拋轉卻不存在子系統分錄中)
#  IF tm.p="1" THEN
#     LET l_sql="SELECT aba_file.* FROM aba_file",
#           " WHERE aba06 = 'AP' ",
#           "  AND  aba00 = '",g_bookno,"'",
#           "  AND  aba01 NOT IN (SELECT apa44 FROM apa_file) "
#  ELSE
#     LET l_sql="SELECT aba_file.* FROM aba_file",
#           " WHERE aba06 = 'AP' ",
#           "  AND  aba00 = '",g_bookno,"'",
#           "  AND  aba01 NOT IN (SELECT apf44 FROM apf_file) "
#  END IF
#  PREPARE r360_prepare2 FROM l_sql
#  IF SQLCA.sqlcode != 0 THEN 
#     CALL cl_err('prepare:',SQLCA.sqlcode,1)
#     EXIT PROGRAM 
#  END IF
#  DECLARE r360_cs2 CURSOR FOR r360_prepare2
 
#  FOREACH r360_cs2 INTO l_aba.*
#     IF SQLCA.sqlcode != 0 THEN 
#        CALL cl_err('foreach:',SQLCA.sqlcode,1)
#        EXIT FOREACH 
#     END IF
 
#     OUTPUT TO REPORT r360_rep(l_aba.aba01,'',l_aba.aba02,0,0,'act16',l_aag.aag02)
 
#     LET l_cnt = l_cnt + 1
#  END FOREACH
#-----END MOD-740058-----
 
#  #---> 依傳票角度(由子系統拋轉其傳票編號一致但傳票日不相同)
#  LET l_sql="SELECT aba01,aba02 FROM aba_file",
#            " WHERE aba06 = 'AP' ",
#            "  AND  aba00 = '",g_bookno,"'"
#  PREPARE r360_prepare3 FROM l_sql
#  IF SQLCA.sqlcode != 0 THEN 
#     CALL cl_err('prepare:',SQLCA.sqlcode,1)
#     EXIT PROGRAM 
#  END IF
#  DECLARE r360_cs3 CURSOR FOR r360_prepare3
 
#  FOREACH r360_cs3 INTO l_aba.*
#     IF SQLCA.sqlcode != 0 THEN 
#        CALL cl_err('foreach:',SQLCA.sqlcode,1)
#        EXIT FOREACH 
#     END IF
 
#     FOREACH r360_actdate USING l_aba.aba01 INTO l_npp01,l_npp03
#        IF SQLCA.sqlcode != 0 THEN 
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)
#           EXIT FOREACH 
#        END IF
 
#        IF l_npp03 != l_aba.aba02 THEN
#           OUTPUT TO REPORT r360_rep(l_npp01,'',l_npp03,'act17')
#           LET l_cnt = l_cnt + 1
#        END IF
#     END FOREACH
 
#  END FOREACH
 
#No.FUN-750095 -- begin --
#   FINISH REPORT r360_rep
#
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     CALL cl_wcchp(tm.wc,'npp01,npp02')                                                          
          RETURNING tm.wc                                                                                                          
     LET g_str = tm.wc
     LET g_str = g_azi04,";",tm.wc,";",g_zz05
     CALL cl_prt_cs3('aapr360','aapr360',g_sql,g_str)
#No.FUN-750095 -- end --
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055    #FUN-B80105 MARK
 
END FUNCTION
   
#No.FUN-750095 -- begin --
#REPORT r360_rep(sr)
#   DEFINE l_last_sw     LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
#          l_dash        LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1), 
#          l_trailer_sw  LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
#          sr            RECORD 
#                        abb01  LIKE abb_file.abb01,
#                        abb02  LIKE abb_file.abb02,
#                        abb03  LIKE abb_file.abb03,
#                        abb07  LIKE abb_file.abb07,
#                        amt    LIKE abb_file.abb07,
#                        errno  LIKE ze_file.ze01,      # No.FUN-690028 VARCHAR(05),
#                        aag02  LIKE aag_file.aag02
#                        END RECORD
#   OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
#
#   ORDER BY sr.abb01,sr.abb02,sr.abb03
#
#   FORMAT
#      PAGE HEADER
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
#         LET g_pageno = g_pageno + 1
#         LET pageno_total = PAGENO USING '<<<',"/pageno"
#         PRINT g_head CLIPPED,pageno_total
#         PRINT 
#         PRINT g_dash[1,g_len]
#         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
#         PRINT g_dash1
#         LET l_trailer_sw = 'y'
#
#      ON EVERY ROW
#         CASE sr.errno
##           WHEN 'npp1' PRINT COLUMN 01,sr.abb01,COLUMN 14,sr.abb02 USING'#####',   #TQC-740139
##                             COLUMN 19,sr.abb03[1,10],
##                             COLUMN 81,g_x[13] CLIPPED
#            WHEN 'npp1' PRINT COLUMN g_c[31],sr.abb01,
#                              COLUMN g_c[32],sr.abb02 USING'#####',   #TQC-740139
#                              COLUMN g_c[33],sr.abb03,
#                              COLUMN g_c[34],sr.aag02,
#                              COLUMN g_c[38],g_x[11] CLIPPED
#            WHEN 'act1' PRINT COLUMN g_c[31],sr.abb01,
#                              COLUMN g_c[32],sr.abb02 USING'#####',   #TQC-740139
#                              COLUMN g_c[33],sr.abb03,
#                              COLUMN g_c[34],sr.aag02,
#                              COLUMN g_c[35],cl_numfor(sr.abb07,35,g_azi04),
#                              COLUMN g_c[36],cl_numfor(sr.amt,36,g_azi04),
#                              COLUMN g_c[37],cl_numfor(sr.abb07-sr.amt,37,g_azi04),
#                              COLUMN g_c[38],g_x[9] CLIPPED
##-----TQC-740139---------
##資料抓取段已mark,故不需列印
##           WHEN 'act2' PRINT COLUMN g_c[31],sr.abb01,
##                             COLUMN g_c[32],sr.abb02 USING'#####',   #TQC-740139
##                             COLUMN g_c[33],sr.abb03,
##                             COLUMN g_c[34],sr.aag02,
##                             COLUMN g_c[38],g_x[10] CLIPPED
##-----END TQC-740139-----
##           WHEN 'act3'  PRINT COLUMN 01,sr.abb01,COLUMN 14,sr.abb02 USING'#####',   #TQC-740139
##                              COLUMN 19,sr.abb03,
##                              COLUMN 81,g_x[16] CLIPPED
##           WHEN 'act4'  PRINT COLUMN 01,sr.abb01,COLUMN 14,sr.abb02 USING'#####',   #TQC-740139
##                              COLUMN 19,sr.abb03,
##                              COLUMN 40,g_x[17] CLIPPED
##           WHEN 'act5'  PRINT COLUMN 01,sr.abb01,COLUMN 14,sr.abb02 USING'#####',   #TQC-740139                              COLUMN 19,sr.abb03,
##                              COLUMN 40,g_x[18] CLIPPED
##           WHEN 'act6'  PRINT COLUMN 01,sr.abb01,COLUMN 14,sr.abb02 USING'#####',   #TQC-740139
##                              COLUMN 19,sr.abb03,
##                              COLUMN 40,g_x[19] CLIPPED
##           WHEN 'act7'  PRINT COLUMN 01,sr.abb01,COLUMN 14,sr.abb02 USING'#####',   #TQC-740139
##                              COLUMN 19,sr.abb03,
##                              COLUMN 40,g_x[20] CLIPPED
##           WHEN 'act8'  PRINT COLUMN 01,sr.abb01,COLUMN 14,sr.abb02 USING'#####',   #TQC-740139
##                              COLUMN 19,sr.abb03,
##                              COLUMN 40,g_x[21] CLIPPED
##           WHEN 'act9'  PRINT COLUMN 01,sr.abb01,COLUMN 14,sr.abb02 USING'#####',   #TQC-740139
##                              COLUMN 19,sr.abb03,
##                              COLUMN 40,g_x[22] CLIPPED
##           WHEN 'act10' PRINT COLUMN 01,sr.abb01,COLUMN 14,sr.abb02 USING'#####',   #TQC-740139
##                              COLUMN 19,sr.abb03,
##                              COLUMN 40,g_x[23] CLIPPED
##           WHEN 'act11' PRINT COLUMN 01,sr.abb01,COLUMN 14,sr.abb02 USING'#####',   #TQC-740139
##                              COLUMN 19,sr.abb03,
##                              COLUMN 40,g_x[24] CLIPPED
##           WHEN 'act12' PRINT COLUMN 01,sr.abb01,COLUMN 14,sr.abb02 USING'#####',   #TQC-740139
##                              COLUMN 19,sr.abb03,
##                              COLUMN 40,g_x[25] CLIPPED
##           WHEN 'act13' PRINT COLUMN 01,sr.abb01,COLUMN 14,sr.abb02 USING'#####',   #TQC-740139
##                              COLUMN 19,sr.abb03,
##                              COLUMN 40,g_x[26] CLIPPED
##NO.MOD-710174---mod---str---
##No.TQC-6B0128 --start-- 取消mark
##           WHEN 'act14' PRINT COLUMN 01,sr.abb01,COLUMN 14,sr.abb02 USING'#####',   #TQC-740139
##                              COLUMN 19,sr.abb03[1,10],
##                              COLUMN 30,cl_numfor(sr.abb07,11,g_azi04),
##                              COLUMN 43,cl_numfor(sr.amt,11,g_azi04),
##                              COLUMN 56,cl_numfor(sr.abb07-sr.amt,9,g_azi04),
##                              COLUMN 68,g_x[15] CLIPPED  
##No.TQC-6B0128 --end--
#            WHEN 'act14' PRINT COLUMN g_c[31],sr.abb01,
#                               COLUMN g_c[32],sr.abb02 USING'#####',   #TQC-740139
#                               COLUMN g_c[33],sr.abb03,
#                               COLUMN g_c[34],sr.aag02,   
#                               COLUMN g_c[35],cl_numfor(sr.abb07,35,g_azi04),
#                               COLUMN g_c[36],cl_numfor(sr.amt,36,g_azi04),
#                               COLUMN g_c[37],cl_numfor(sr.abb07-sr.amt,37,g_azi04),
#                               COLUMN g_c[38],g_x[10] CLIPPED   
##NO.MOD-710174---mod---str---
##           WHEN 'act15' PRINT COLUMN 01,sr.abb01,COLUMN 14,sr.abb02 USING'#####',   #TQC-740139
##                              COLUMN 19,sr.abb03,
##                              COLUMN 40,g_x[28] CLIPPED
##No.TQC-6B0128 --start-- 取消mark
##-----TQC-740139---------
#            WHEN 'act16' PRINT COLUMN g_c[31],sr.abb01,
#                               COLUMN g_c[32],sr.abb02 USING'#####',   #TQC-740139
#                               COLUMN g_c[33],sr.abb03,
#                               COLUMN g_c[34],sr.aag02,   
#                               COLUMN g_c[38],g_x[29] CLIPPED
##-----END TQC-740139-----
##No.TQC-6B0128 --end--
##           WHEN 'act17' PRINT COLUMN 01,sr.abb01,COLUMN 14,sr.abb02 USING'#####',   #TQC-740139
##                              COLUMN 19,sr.abb03,
##                              COLUMN 40,g_x[30] CLIPPED
#            OTHERWISE EXIT CASE
#         END CASE
#
#      ON LAST ROW
#         PRINT g_dash[1,g_len]
#         LET l_trailer_sw = 'n'
#  #      PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[38],g_x[7] CLIPPED     #TQC-6A0088
#         PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[7] CLIPPED     #TQC-6A0088
#
#      PAGE TRAILER
#         IF l_trailer_sw = 'y' THEN
#            PRINT g_dash[1,g_len]
# #          PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[38],g_x[6] CLIPPED    #TQC-6A0088
#            PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[6] CLIPPED    #TQC-6A0088
#         ELSE
#            SKIP 2 LINE
#         END IF
#
#END REPORT
#No.FUN-750095 -- end --
 
