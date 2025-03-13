# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmr400.4gl
# Desc/riptions..: 分錄底稿/傳票檢查報表             
# Date & Author..: 97/01/08 By Charis
# Modify.........: No.MOD-510043 05/01/25 By kitty 增加判斷單據要拋傳票的才檢查
# Modify.........: No.FUN-4C0098 05/02/02 By pengu 報表轉XML
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.TQC-5A0087 05/10/27 By Smapmin 單別寫死
# Modify.........: No.MOD-660056 06/06/13 By Smapmin 修改SELECT條件
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-740049 07/04/12 By arman   會計科目加帳套
# Modify.........: No.FUN-750115 07/06/25 By sherry 報表改由Crystal Report輸出
# Modify.........: No.MOD-770039 07/07/10 依子系統角度判斷分錄已拋轉傳票但總帳卻不存在
# Modify.........: No.FUN-760085 07/07/18 By sherry  Crystal Report缺少打印條件
#                                                                  部分會計科目輸出為日期
# Modify.........: No.MOD-780044 07/08/08 By Smapmin 修改變數內容
# Modify.........: No.MOD-810117 08/01/17 By Smapmin 針對tm.p為2/3者,增加aag05的控管
# Modify.........: No.FUN-810069 08/02/27 By yaofs 項目預算取消abb15的管控   
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-DA0047 13/11/26 By wangrr 當tm.p=1應付時也將應付票據nmd_file抓出
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD            
              wc         LIKE type_file.chr1000,      #No.FUN-680107 VARCHAR(600)
              p          LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
              more       LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
              END RECORD,
          g_bookno        LIKE aaa_file.aaa01,
          g_aaz72         LIKE aaz_file.aaz72,
          g_aaa           RECORD LIKE aaa_file.*,
          g_dbs_gl        LIKE type_file.chr21,       #No.FUN-680107 VARCHAR(21)
          g_deptdesc      LIKE zaa_file.zaa08         #No.FUN-680107 VARCHAR(40)
DEFINE    g_i             LIKE type_file.num5         #count/index for any purpose #No.FUN-680107 SMALLINT
#FUN-750115--start                                                              
   DEFINE  g_sql      STRING                                                    
   DEFINE  l_table    STRING                                                    
   DEFINE  l_str      STRING                                                    
#FUN-750115--end    
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                           # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
 #No.FUN-750115---Begin                                                         
   LET g_sql = "abb01.abb_file.abb01,",
               "abb02.abb_file.abb02,",
               "abb03.abb_file.abb03,",
               "aag02.aag_file.aag02,",
               "abb07.abb_file.abb07,",
               "amt.abb_file.abb07,",
               "diff.abb_file.abb07,",
               "zaa08.zaa_file.zaa08,",   
               "l_reason.type_file.chr1000,"
        
   LET l_table = cl_prt_temptable('anmr400',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF                                     
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                        
               " VALUES(?,?,?,?,?,?,?,?,?) "                
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF                                                                       
 #No.FUN-750115--END 
       
 
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
   LET g_bookno   = g_nmz.nmz02b         
   LET g_plant_new = g_nmz.nmz02p
   CALL s_getdbs()
   LET g_dbs_gl = g_dbs_new 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' # If background job sw is off
      THEN CALL r400_tm(0,0)            # Input print condition
      ELSE CALL anmr400()               # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION r400_tm(p_row,p_col)
DEFINE lc_qbe_sn     LIKE gbm_file.gbm01           #No.FUN-580031
DEFINE p_row,p_col   LIKE type_file.num5,          #No.FUN-680107 SMALLINT
       l_flag        LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
       l_cmd         LIKE type_file.chr1000        #No.FUN-680107 VARCHAR(400)
 
   LET p_row = 4 LET p_col = 8
   OPEN WINDOW r400_w AT p_row,p_col
        WITH FORM "anm/42f/anmr400" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                     # Default condition
   LET tm.more = 'N'
   LET tm.p    = '1'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON npp01,npp02 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
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
 LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r400_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
 
   INPUT BY NAME tm.p,tm.more
            WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD p
         IF tm.p NOT MATCHES "[123]"
            THEN NEXT FIELD p
         END IF
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()        # Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW r400_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
             WHERE zz01='anmr400'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr400','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
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
         CALL cl_cmdat('anmr400',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r400_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr400()
   ERROR ""
END WHILE
   CLOSE WINDOW r400_w
END FUNCTION
   
FUNCTION r400_cur()
DEFINE l_sql STRING        #No.FUN-680107 VARCHAR(1000)
 
     LET l_sql="SELECT abb_file.*,aag_file.* ", 
               " FROM abb_file LEFT OUTER JOIN aag_file ON abb03=aag01 AND abb00 = aag00",
               " WHERE abb00='",g_bookno,"' AND abb01 = ? "           #NO.FUN-740049
     PREPARE r400_preact FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare:preact',SQLCA.sqlcode,1)
     END IF
     DECLARE r400_csact CURSOR FOR r400_preact
     CASE
        WHEN tm.p='1'
              #No.MOD-510043 add nmy_file
             LET l_sql="SELECT npp01,npp03  FROM npp_file,npl_file,nmy_file ",  
                  " WHERE nppsys = 'NM' AND npl01=npp01 AND npl09 = ? ",
#No.FUN-550057 --start--
#                  "   AND npl01[1,3] = nmyslip AND nmydmy3='Y' "    #TQC-5A0087                   
                  "   AND substring(npl01,1,g_doc_len) = nmyslip AND nmydmy3='Y' "    #TQC-5A0087                  
     #             "   AND npl01[1,g_doc_len] = nmyslip AND nmydmy3='Y' "                     
        WHEN tm.p='2'
             LET l_sql="SELECT npp01,npp03  FROM npp_file,npn_file,nmy_file ",
                  " WHERE nppsys = 'NM' AND npn01=npp01 AND npn09 = ? ",
#                 "   AND npn01[1,3] = nmyslip AND nmydmy3='Y' "     #TQC-5A0087                
                 "   AND substring(npn01,1,g_doc_len) = nmyslip AND nmydmy3='Y' "     #TQC-5A0087                
   #               "   AND npn01[1,g_doc_len] = nmyslip AND nmydmy3='Y' "                     
        WHEN tm.p='3'
             LET l_sql="SELECT npp01,npp03  FROM npp_file,nmg_file,nmy_file ",
                  " WHERE nppsys = 'NM' AND nmg00=npp01 AND nmg13 = ? ",
#                 "   AND nmg01[1,3] = nmyslip AND nmydmy3='Y' "     #TQC-5A0087                
                 #"   AND nmg01[1,",g_doc_len,"] = nmyslip AND nmydmy3='Y' "     #TQC-5A0087      #MOD-660056             
                 "   AND substring(nmg00,1,g_doc_len) = nmyslip AND nmydmy3='Y' "     #TQC-5A0087      #MOD-660056             
     #             "   AND nmg01[1,g_doc_len] = nmyslip AND nmydmy3='Y' "                     
#No.FUN-550057 ---end--
              #No.MOD-510043 end
     END CASE
     PREPARE r400_preactdat FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare:preactdat',SQLCA.sqlcode,1)
     END IF
     DECLARE r400_actdate CURSOR FOR r400_preactdat
END FUNCTION
   
FUNCTION anmr400()
   DEFINE l_name        LIKE type_file.chr20,         # External(Disk) file name #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8            #No.FUN-6A0082
          l_sql         LIKE type_file.chr1000,       # RDSQL STATEMENT #No.FUN-680107 VARCHAR(1000)
          l_chr         LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          l_za05        LIKE type_file.chr1000,       #No.FUN-680107 VARCHAR(40)
          l_nppglno     LIKE npp_file.nppglno,
          l_npp01       LIKE npp_file.npp01,
          l_npp03       LIKE npp_file.npp03,
          l_cnt,l_seq   LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_npp         RECORD LIKE npp_file.*,
          l_aba         RECORD LIKE aba_file.*,
          l_abb         RECORD LIKE abb_file.*,
          l_aag         RECORD LIKE aag_file.*,
          l_cramt,l_dramt      LIKE abb_file.abb07,
          l_cr,l_dr            LIKE abb_file.abb07,
          l_c_npp,l_d_npp      LIKE abb_file.abb07,
          l_c_abb,l_d_abb      LIKE abb_file.abb07,
          l_dept        LIKE type_file.num5,          #No.FUN-680107 SMALLINT
#No.FUN-750115---Begin
          l_aag02       LIKE aag_file.aag02,                                    
          l_reason      LIKE type_file.chr1000,    
          sr            RECORD                                                  
                        abb01  LIKE abb_file.abb01,                             
                        abb02  LIKE abb_file.abb02,                             
                        abb03  LIKE abb_file.abb03,                             
                        abb07  LIKE abb_file.abb07,                             
                        amt    LIKE abb_file.abb07,                             
                        errno  LIKE oay_file.oayslip
                        END RECORD    
#No.FUN-750115---End
DEFINE l_flag    LIKE type_file.chr1 #FUN-DA0047

     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = g_prog  #No.FUN-760085
     CALL cl_del_data(l_table)         #No.FUN-750115  
 
     CALL r400_cur()
     #--->依分錄角度
     CASE
        WHEN tm.p='1'
             LET l_sql="SELECT unique npl09 FROM npp_file,npl_file ",
                  " WHERE npp01=npl01 AND npl09 IS NOT NULL AND npl09 != ' ' ",
                  "   AND nppsys = 'NM' AND   ",tm.wc CLIPPED
                  #FUN-DA0047--add--str--
                 ," UNION ALL ",
                  " SELECT unique nmd27 FROM npp_file,nmd_file ",
                  "  WHERE npp01=nmd01 AND npp011=10 ",
                  "    AND nmd27 IS NOT NULL AND nmd27 != ' ' ",
                  "    AND nppsys = 'NM' AND   ",tm.wc CLIPPED
                  #FUN-DA0047--add--end
        WHEN tm.p='2'
             LET l_sql="SELECT unique npn09 FROM npp_file,npn_file ",
                  " WHERE npp01=npn01 AND npn09 IS NOT NULL AND npn09 != ' ' ",
                  "   AND nppsys='NM' AND   ",tm.wc CLIPPED
        WHEN tm.p='3'
             LET l_sql="SELECT unique nmg13 FROM npp_file,nmg_file ",
                  " WHERE npp01=nmg00 AND nmg13 IS NOT NULL AND nmg13 != ' ' ",
                  "   AND nppsys='NM' AND   ",tm.wc CLIPPED
     END CASE
     PREPARE r400_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM 
           
     END IF
     DECLARE r400_cs1 CURSOR FOR r400_prepare1
 
     #-->取總帳系統參數
     #LET g_dbs_gl = g_dbs_new CLIPPED,"."   #MOD-780044
     LET g_dbs_gl = g_dbs_new   #MOD-780044
     LET l_sql = "SELECT aaz72  FROM ",g_dbs_gl CLIPPED,
                 "aaz_file WHERE aaz00 = '0' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     PREPARE r400_pregl FROM l_sql
     DECLARE r400_curgl CURSOR FOR r400_pregl
     OPEN r400_curgl 
     FETCH r400_curgl INTO g_aaz72 
     IF SQLCA.sqlcode THEN LET g_aaz72 = '1' END IF
     IF g_aaz72 = '1' THEN 
#       LET g_deptdesc = g_x[36]      #No.FUN-750115
        LET g_deptdesc = '1'          #No.FUN-750115    
     ELSE 
#       LET g_deptdesc = g_x[37]      #No.FUN-750115  
        LET g_deptdesc = '2'          #No.FUN-750115
     END IF 
#No.FUN-750115---Begin
#    CALL cl_outnam('anmr400') RETURNING l_name      
#    START REPORT r400_rep TO l_name                 
#No.FUN-750115---End
     FOREACH r400_cs1 INTO l_nppglno
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
       END IF
       MESSAGE l_nppglno
       CALL ui.Interface.refresh()
       SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=l_abb.abb03  #No.FUN-750115      
                                               AND aag00 = g_bookno     #No.FUN-750115
       #FUN-DA0047--add--str--
       LET l_flag='N'
       IF tm.p=1 THEN
          SELECT COUNT(*) INTO l_cnt FROM npp_file,nmd_file
          WHERE nmd01=npp01 AND nmd27=l_nppglno
            AND nppsys='NM' AND npp011=10
          IF l_cnt>0 THEN
             LET l_flag='Y'
          END IF
       END IF
       #FUN-DA0047--add--end
       #-->1.分錄單頭借貸不等
       CASE
         WHEN tm.p='1' 
             #FUN-DA0047--add--str--
             IF l_flag='Y' THEN
                SELECT SUM(npq07) INTO l_dramt FROM npp_file,npq_file,nmd_file
                 WHERE nmd01=npq01 AND nmd27=l_nppglno
                   AND npq06 = '1' AND npp01=npq01
                   AND nppsys='NM' AND npp00=npq00
                   AND npp011=npq011 AND nppsys=npqsys
             ELSE
             #FUN-DA0047--add--end
                SELECT SUM(npq07) INTO l_dramt FROM npp_file,npq_file,npl_file
                 WHERE npl01=npq01 AND npl09=l_nppglno
                   AND npq06 = '1' AND npp01=npq01
                   AND nppsys='NM' AND npp00=npq00
                   AND npp011=npq011 AND nppsys=npqsys
             END IF #FUN-DA0047
         WHEN tm.p='2' 
             SELECT SUM(npq07) INTO l_dramt FROM npp_file,npq_file,npn_file
                            WHERE npn01=npq01 AND npn09=l_nppglno
                              AND npq06 = '1' AND npp01=npq01
                              AND nppsys='NM' AND npp00=npq00
                              AND npp011=npq011 AND nppsys=npqsys
         WHEN tm.p='3' 
             SELECT SUM(npq07) INTO l_dramt FROM npp_file,npq_file,nmg_file
                            WHERE nmg00=npq01 AND nmg13=l_nppglno
                              AND npq06 = '1' AND npp01=npq01
                              AND nppsys='NM' AND npp00=npq00
                              AND npp011=npq011 AND nppsys=npqsys
       END CASE
 
       CASE
         WHEN tm.p='1' 
             SELECT SUM(npq07) INTO l_cramt FROM npp_file,npq_file,npl_file
                            WHERE npl01=npq01 AND npl09=l_nppglno
                              AND npq06 = '2' AND npp01=npq01
                              AND nppsys='NM' AND npp00=npq00
                              AND npp011=npq011 AND nppsys=npqsys
         WHEN tm.p='2' 
             SELECT SUM(npq07) INTO l_cramt FROM npp_file,npq_file,npn_file
                            WHERE npn01=npq01 AND npn09=l_nppglno
                              AND npq06 = '2' AND npp01=npq01
                              AND nppsys='NM' AND npp00=npq00
                              AND npp011=npq011 AND nppsys=npqsys
         WHEN tm.p='3' 
             SELECT SUM(npq07) INTO l_cramt FROM npp_file,npq_file,nmg_file
                            WHERE nmg00=npq01 AND nmg13=l_nppglno
                              AND npq06 = '2' AND npp01=npq01
                              AND nppsys='NM' AND npp00=npq00
                              AND npp011=npq011 AND nppsys=npqsys
       END CASE
 
 
       IF l_dramt != l_cramt  THEN
#No.FUN-750115---Bergin
          LET l_reason = '1'
          EXECUTE insert_prep USING l_nppglno,'','','','',
                                    '','','',l_reason                     
#         OUTPUT TO REPORT r400_rep(l_nppglno,'','',0,0,'npp1')
#No.FUN-750115---End
          LET l_cnt = l_cnt + 1
       END IF
 
       #-->利用傳票與底稿比對
       FOREACH r400_csact USING l_nppglno INTO l_abb.*,l_aag.*
         IF SQLCA.sqlcode != 0 THEN 
            CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
         END IF
       {
         #-->b2.科目編號無效    
         IF l_aag.aagacti = 'N' THEN 
         OUTPUT TO REPORT r400_rep(l_abb.abb01,l_abb.abb02,l_abb.abb03,'act1')
         LET l_cnt = l_cnt + 1
         END IF
         #-->b3.科目性質不為帳戶
         IF l_aag.aag03 != '2' THEN 
         OUTPUT TO REPORT r400_rep(l_abb.abb01,l_abb.abb02,l_abb.abb03,'act2')
         LET l_cnt = l_cnt + 1
         END IF
         #-->b4.不為明細或獨立帳戶
         IF l_aag.aag07 = '1' THEN 
         OUTPUT TO REPORT r400_rep(l_abb.abb01,l_abb.abb02,l_abb.abb03,'act3')
         LET l_cnt = l_cnt + 1
         END IF
         #-->b3.部門管理
         IF l_aag.aag05 = 'Y' AND 
            (l_abb.abb05 = ' ' OR l_abb.abb05 IS NULL) THEN
         OUTPUT TO REPORT r400_rep(l_abb.abb01,l_abb.abb02,l_abb.abb03,'act4')
                LET l_cnt = l_cnt + 1
         END IF
 
         #-->b4.異動碼需存在
         IF l_aag.aag151 matches '[23]'  AND
            (l_abb.abb11 = ' ' OR l_abb.abb11 IS NULL) THEN
         OUTPUT TO REPORT r400_rep(l_abb.abb01,l_abb.abb02,l_abb.abb03,'act5')
                LET l_cnt = l_cnt + 1
         END IF
         IF l_aag.aag161 matches '[23]'  AND
            (l_abb.abb12 = ' ' OR l_abb.abb12 IS NULL) THEN
         OUTPUT TO REPORT r400_rep(l_abb.abb01,l_abb.abb03,l_abb.abb03,'act6')
              LET l_cnt = l_cnt + 1
         END IF
         IF l_aag.aag171 matches '[23]'  AND
            (l_abb.abb13 = ' ' OR l_abb.abb13 IS NULL) THEN
         OUTPUT TO REPORT r400_rep(l_abb.abb01,l_abb.abb03,l_abb.abb03,'act7')
         LET l_cnt = l_cnt + 1
         END IF
         IF l_aag.aag181 matches '[23]'  AND
            (l_abb.abb14 = ' ' OR l_abb.abb14 IS NULL) THEN
         OUTPUT TO REPORT r400_rep(l_abb.abb01,l_abb.abb03,l_abb.abb03,'act8')
         LET l_cnt = l_cnt + 1
         END IF
         #-->b4.異動碼需存在(aee_file)
         IF l_aag.aag151 ='3'  AND 
            (l_abb.abb11 = ' ' OR l_abb.abb11 IS NULL) 
         THEN SELECT count(*) INTO l_seq FROM aee_file 
                                    WHERE aee01 =l_abb.abb03
                                      AND aee02 ='1'
                                      AND aee03 =l_abb.abb11
              IF l_seq != 1 THEN 
                 OUTPUT TO REPORT r400_rep(l_abb.abb01,l_abb.abb03,
                                           l_abb.abb03,'act9') 
              END IF
              LET l_cnt = l_cnt + 1
         END IF
         IF l_aag.aag161 ='3'  AND 
            (l_abb.abb12 = ' ' OR l_abb.abb12 IS NULL)
         THEN SELECT count(*) INTO l_seq FROM aee_file 
                              WHERE aee01 =l_abb.abb03
                                AND aee02 ='2'
                                AND aee03 =l_abb.abb12
              IF l_seq != 1 THEN 
                 OUTPUT TO REPORT r400_rep(l_abb.abb01,l_abb.abb03,
                                     l_abb.abb03,'act10') 
              END IF
              LET l_cnt = l_cnt + 1
         END IF
         IF l_aag.aag171 ='3'  AND 
            (l_abb.abb13 = ' ' OR l_abb.abb13 IS NULL)
         THEN SELECT count(*) INTO l_seq FROM aee_file 
                              WHERE aee01 =l_abb.abb03
                                AND aee02 ='3'
                                AND aee03 =l_abb.abb13
              IF l_seq != 1 THEN 
                 OUTPUT TO REPORT r400_rep(l_abb.abb01,l_abb.abb03,
                                           l_abb.abb03,'act11') 
              END IF
              LET l_cnt = l_cnt + 1
         END IF
         IF l_aag.aag181 ='3'  AND 
            (l_abb.abb14 = ' ' OR l_abb.abb14 IS NULL)
         THEN SELECT count(*) INTO l_cnt FROM aee_file 
                              WHERE aee01 =l_abb.abb03
                                AND aee02 ='4'
                                AND aee03 =l_abb.abb14
              IF l_seq != 1 THEN 
                 OUTPUT TO REPORT r400_rep(l_abb.abb01,l_abb.abb03,
                                           l_abb.abb03,'act12') 
              END IF
              LET l_cnt = l_cnt + 1
         END IF
         #-->b5.預算控制
#---begin---    No.FUN-810069   
#         IF l_aag.aag21 ='Y'  AND
#            (l_abb.abb15 = ' ' OR l_abb.abb15 IS NULL)
#         THEN OUTPUT TO REPORT r400_rep(l_abb.abb01,l_abb.abb03,
#                                        l_abb.abb03,'act13') 
#              LET l_cnt = l_cnt + 1
#         END IF
#---end---      No.FUN-810069 
       }
       SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=sr.abb03     #No.FUN-
                                               AND aag00 = g_bookno     #No.FUN-
       
         #-->b2.科目金額不合
	 LET l_d_abb=0
	 LET l_c_abb=0
	 LET l_dept=0
         CASE
            WHEN tm.p='1' 
            #FUN-DA0047--add--str--
            IF l_flag='Y' THEN
               SELECT SUM(npq07) INTO l_dr FROM npq_file,nmd_file
                WHERE nmd01 = npq01
                  AND nmd27 = l_nppglno AND npq06 = '1'
                  AND npq03 = l_abb.abb03   #科目
                  AND npqsys='NM'

               SELECT SUM(npq07) INTO l_cr FROM npq_file,nmd_file
                WHERE nmd01 = npq01
                  AND nmd27 = l_nppglno AND npq06 = '2'
                  AND npq03 = l_abb.abb03   #科目
                  AND npqsys='NM'

               IF l_aag.aag05 = 'Y'  THEN       #No:9464
                  IF g_aaz72 = '2' THEN
                     SELECT COUNT(*) INTO l_dept FROM npq_file,nmd_file,aab_file
                      WHERE nmd27=l_nppglno AND  npq01=nmd01 AND
                            npq03=l_abb.abb03 AND
                            npqsys='NM' AND
                            npq05 NOT IN ( SELECT aab02 FROM aab_file
                                            WHERE aab01=l_abb.abb03 )
                  ELSE
                     SELECT COUNT(*) INTO l_dept FROM npq_file,nmd_file,aab_file
                      WHERE nmd27=l_nppglno AND  npq01=nmd01 AND
                            npq03=l_abb.abb03 AND
                            npqsys='NM' AND
                            npq05 IN ( SELECT aab02 FROM aab_file
                                        WHERE aab01=l_abb.abb03 )
                  END IF
               ELSE                            #No:9464
                  LET l_dept = 0
               END IF
            ELSE
            #FUN-DA0047--add--end
                 SELECT SUM(npq07) INTO l_dr FROM npq_file,npl_file
                             WHERE npl01 = npq01
                               AND npl09 = l_nppglno AND npq06 = '1'
                               AND npq03 = l_abb.abb03   #科目
                               AND npqsys='NM'
 
                  SELECT SUM(npq07) INTO l_cr FROM npq_file,npl_file
                             WHERE npl01 = npq01
                               AND npl09 = l_nppglno AND npq06 = '2'
                               AND npq03 = l_abb.abb03   #科目
                               AND npqsys='NM'
 
                 IF l_aag.aag05 = 'Y'  THEN       #No:9464
                  IF g_aaz72 = '2' THEN
                    SELECT COUNT(*) INTO l_dept FROM npq_file,npl_file,aab_file
                     WHERE npl09=l_nppglno AND  npq01=npl01 AND
                           npq03=l_abb.abb03 AND  
                           npqsys='NM' AND
                           npq05 NOT IN ( SELECT aab02 FROM aab_file 
                                       WHERE aab01=l_abb.abb03 ) 
                  ELSE 
                    SELECT COUNT(*) INTO l_dept FROM npq_file,npl_file,aab_file
                     WHERE npl09=l_nppglno AND  npq01=npl01 AND
                           npq03=l_abb.abb03 AND  
                           npqsys='NM' AND
                           npq05 IN ( SELECT aab02 FROM aab_file 
                                       WHERE aab01=l_abb.abb03 ) 
                  END IF 
                ELSE                            #No:9464
                  LET l_dept = 0
               END IF
            END IF #FUN-DA0047 
     
            WHEN tm.p='2' 
                  SELECT SUM(npq07) INTO l_dr FROM npq_file,npn_file
                             WHERE npn01 = npq01
                               AND npn09 = l_nppglno AND npq06 = '1'
                               AND npq03 = l_abb.abb03   #科目
                               AND npqsys='NM'
 
                   SELECT SUM(npq07) INTO l_cr FROM npq_file,npn_file
                             WHERE npn01 = npq01
                               AND npn09 = l_nppglno AND npq06 = '2'
                               AND npq03 = l_abb.abb03   #科目
                               AND npqsys='NM'
 
                   IF l_aag.aag05 = 'Y' THEN   #MOD-810117 
                      IF g_aaz72 = '2' THEN 
                           SELECT COUNT(*) INTO l_dept FROM npq_file,npn_file
                            WHERE npn09=l_nppglno AND  npq01=npn01 AND
                                  npq03=l_abb.abb03 AND  
                                  npqsys='NM' AND
                                  npq05 NOT IN ( SELECT aab02 FROM aab_file 
                                                 WHERE aab01=l_abb.abb03 ) 
                      ELSE SELECT COUNT(*) INTO l_dept FROM npq_file,npn_file
                            WHERE npn09=l_nppglno AND  npq01=npn01 AND
                                  npq03=l_abb.abb03 AND  
                                  npqsys='NM' AND
                                  npq05 IN ( SELECT aab02 FROM aab_file 
                                              WHERE aab01=l_abb.abb03 ) 
                      END IF 
                   #-----MOD-810117---------
                   ELSE
                      LET l_dept = 0 
                   END IF
                   #-----END MOD-810117-----
 
            WHEN tm.p='3' 
                  SELECT SUM(npq07) INTO l_dr FROM npq_file,nmg_file
                             WHERE nmg00 = npq01
                               AND nmg13 = l_nppglno AND npq06 = '1'
                               AND npq03 = l_abb.abb03   #科目
                               AND npqsys='NM'
 
                   SELECT SUM(npq07) INTO l_cr FROM npq_file,nmg_file
                             WHERE nmg00 = npq01
                               AND nmg13 = l_nppglno AND npq06 = '2'
                               AND npq03 = l_abb.abb03   #科目
                               AND npqsys='NM'
                   IF l_aag.aag05 = 'Y' THEN   #MOD-810117 
                      IF g_aaz72 = '2' THEN 
                           SELECT COUNT(*) INTO l_dept FROM npq_file,nmg_file
                            WHERE nmg13=l_nppglno AND  npq01=nmg00 AND
                                  npq03=l_abb.abb03 AND  
                                  npqsys='NM' AND
                                  npq05 NOT IN ( SELECT aab02 FROM aab_file 
                                                  WHERE aab01=l_abb.abb03 ) 
                      ELSE SELECT COUNT(*) INTO l_dept FROM npq_file,nmg_file
                            WHERE nmg13=l_nppglno AND  npq01=nmg00 AND
                                  npq03=l_abb.abb03 AND  
                                  npqsys='NM' AND
                                  npq05 IN ( SELECT aab02 FROM aab_file 
                                              WHERE aab01=l_abb.abb03 ) 
                      END IF 
                   #-----MOD-810117---------
                   ELSE
                      LET l_dept = 0 
                   END IF
                   #-----END MOD-810117-----
         END CASE
	 IF l_dr IS NULL THEN LET l_dr=0 END IF
	 IF l_cr IS NULL THEN LET l_cr=0 END IF
	 LET l_dr=l_dr - l_cr
         SELECT SUM(abb07) INTO l_d_abb FROM abb_file
                WHERE abb00=g_bookno and abb01=l_abb.abb01 and          
                      abb03=l_abb.abb03 and abb06="1"          
         SELECT SUM(abb07) INTO l_c_abb FROM abb_file
                WHERE abb00=g_bookno and abb01=l_abb.abb01 and          
                      abb03=l_abb.abb03 and abb06="2"          
	 IF l_d_abb IS NULL THEN LET l_d_abb=0 END IF
	 IF l_c_abb IS NULL THEN LET l_c_abb=0 END IF
	 LET l_abb.abb07=l_d_abb - l_c_abb
 
 #.......科目金額不合
         IF l_abb.abb07<>l_dr 
#No.FUN-750115---Begin
         THEN LET l_reason = '2'    
#        THEN OUTPUT TO REPORT r400_rep(l_abb.abb01,l_abb.abb02,
#                                       l_abb.abb03,l_abb.abb07,l_dr,'act14')
         EXECUTE insert_prep USING l_abb.abb01,l_abb.abb02,l_abb.abb03,l_aag.aag02,
                                   l_abb.abb07,l_dr,'','',l_reason
#No.FUN-750115---End
              LET l_cnt = l_cnt + 1
         END IF
 
#........科目拒絕部門
         IF l_dept > 0  
#No.FUN-750115---Begin
         THEN LET l_reason = '3'  
#        THEN OUTPUT TO REPORT r400_rep(l_abb.abb01,l_abb.abb02,
#                                       l_abb.abb03,l_abb.abb07,l_dr,'act18')
         EXECUTE insert_prep USING l_abb.abb01,l_abb.abb02,l_abb.abb03,
                                   l_aag.aag02,
                                   '','','',g_deptdesc,l_reason 
#No.FUN-750115---End
              LET l_cnt = l_cnt + 1
         END IF
       END FOREACH
 
       SELECT aba06   INTO l_aba.aba06   FROM aba_file WHERE aba00=g_bookno
                      AND aba01=l_abb.abb01
       IF l_aba.aba06 <> "NM"    
#No.FUN-750115---Begin
          THEN LET l_reason = '4'      
#      THEN OUTPUT TO REPORT r400_rep(l_abb.abb01,l_abb.abb02,
#                                       l_abb.abb03,l_abb.abb07,l_dr,'act1') 
          EXECUTE insert_prep USING l_abb.abb01,l_abb.abb02,l_abb.abb03,
                                    l_aag.aag02,l_abb.abb07,l_dr,'','',
                                    l_reason  
#No.FUN-750115---End
            LET l_cnt = l_cnt + 1
       END IF
       #-->E.傳票無效
      {
       SELECT abaacti INTO l_aba.abaacti FROM aba_file WHERE aba00="00"
                      AND aba01=l_abb.abb01
       IF l_aba.abaacti != 'Y' 
       THEN OUTPUT TO REPORT r400_rep(l_abb.abb01,l_abb.abb02,
                                        l_abb.abb03,'act15') 
            LET l_cnt = l_cnt + 1
       END IF
      }
     END FOREACH
 
     #-----MOD-770039---------
     {
     #--->依傳票角度(由子系統拋轉卻不存在子系統分錄中)
     CASE
       WHEN tm.p="1" 
           LET l_sql="SELECT aba_file.* FROM aba_file",
                     " WHERE aba06 = 'NM' ",
                     "  AND  aba00 = '",g_bookno,"'",
                     "  AND  aba01 NOT IN (SELECT npl09 FROM npl_file) "
       WHEN tm.p="2" 
            LET l_sql="SELECT aba_file.* FROM aba_file",
              " WHERE aba06 = 'NM' ",
              "  AND  aba00 = '",g_bookno,"'",
              "  AND  aba01 NOT IN (SELECT npn09 FROM npn_file) "
       WHEN tm.p="3" 
            LET l_sql="SELECT aba_file.* FROM aba_file",
              " WHERE aba06 = 'NM' ",
              "  AND  aba00 = '",g_bookno,"'",
              "  AND  aba01 NOT IN (SELECT nmg13 FROM nmg_file) "
     END CASE
     }
     #--->依子系統角度(分錄已拋轉傳票但總帳卻不存在)
     CASE
       WHEN tm.p="1" 
           LET l_sql="SELECT * FROM npp_file ",   
                     " WHERE nppsys = 'NM' AND npp00='1' ",
                     "   AND nppglno IS NOT NULL ",
                     "   AND nppglno NOT IN ",
                     " (SELECT aba01 FROM aba_file WHERE aba00='",g_bookno,"')"
       WHEN tm.p="2" 
           LET l_sql="SELECT * FROM npp_file ",   
                     " WHERE nppsys = 'NM' AND npp00='2' ",
                     "   AND nppglno IS NOT NULL ",
                     "   AND nppglno NOT IN ",
                     " (SELECT aba01 FROM aba_file WHERE aba00='",g_bookno,"')"
       WHEN tm.p="3" 
           LET l_sql="SELECT * FROM npp_file ",   
                     " WHERE nppsys = 'NM' AND npp00='3' ",
                     "   AND nppglno IS NOT NULL ",
                     "   AND nppglno NOT IN ",
                     " (SELECT aba01 FROM aba_file WHERE aba00='",g_bookno,"')"
     END CASE
     #-----END MOD-770039-----
     PREPARE r400_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM 
           
     END IF
     DECLARE r400_cs2 CURSOR FOR r400_prepare2
     #FOREACH r400_cs2 INTO l_aba.*   #MOD-770039
     FOREACH r400_cs2 INTO l_npp.*   #MOD-770039
          IF SQLCA.sqlcode != 0 THEN 
             CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
          END IF
          SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=l_abb.abb03     #No.FUN-
                                                  AND aag00 = g_bookno     #No.FUN-
#No.FUN-750115---Begin
          LET l_reason = '5'         
#         OUTPUT TO REPORT r400_rep(l_aba.aba01,'',
#                                   l_aba.aba02,0,0,'act16')
          #-----MOD-770039---------
     #    EXECUTE insert_prep USING l_aba.aba01,'',l_aba.aba02,
     #                              l_aag.aag02,'','','','',l_reason            
          EXECUTE insert_prep USING l_npp.nppglno,'',l_npp.npp03,   
                                    l_aag.aag02,'','','','',l_reason            
          #-----END MOD-770039-----
#No.FUN-750115---End
          LET l_cnt = l_cnt + 1
     END FOREACH
  {
     #---> 依傳票角度(由子系統拋轉其傳票編號一致但傳票日不相同)
     LET l_sql="SELECT aba01,aba02 FROM aba_file",
           " WHERE aba06 = 'NM' ",
           "  AND  aba00 = '",g_bookno,"'"
     PREPARE r400_prepare3 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM 
           
     END IF
     DECLARE r400_cs3 CURSOR FOR r400_prepare3
     FOREACH r400_cs3 INTO l_aba.*
          IF SQLCA.sqlcode != 0 THEN 
             CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
          END IF
          FOREACH r400_actdate USING l_aba.aba01 INTO l_npp01,l_npp03
             IF SQLCA.sqlcode != 0 THEN 
                CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
             END IF
             IF l_npp03 != l_aba.aba02 THEN
                OUTPUT TO REPORT r400_rep(l_npp01,'',l_npp03,'act17')
                LET l_cnt = l_cnt + 1
             END IF
          END FOREACH
     END FOREACH
  }
#No.FUN-750115---Begin
#    FINISH REPORT r400_rep
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED 
     #No.FUN-760085---Begin 
     IF g_zz05 = 'Y' THEN                                                
        CALL cl_wcchp(tm.wc,'npp01,npp02')                               
             RETURNING l_str                                                 
     END IF             
     #No.FUN-760085---End
     LET l_str =l_str,';',g_azi04
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     CALL cl_prt_cs3('anmr400','anmr400',l_sql,l_str)
#No.FUN-750115---End
END FUNCTION
 
#NO.FUN-750115---Begin   
{REPORT r400_rep(sr)
   DEFINE l_last_sw     LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
          l_dash        LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
          l_trailer_sw  LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
          l_aag02       LIKE aag_file.aag02,
          sr            RECORD 
                        abb01  LIKE abb_file.abb01,
                        abb02  LIKE abb_file.abb02,
                        abb03  LIKE abb_file.abb03,
                        abb07  LIKE abb_file.abb07,
                        amt    LIKE abb_file.abb07,
                        errno  LIKE oay_file.oayslip #No.FUN-680107 VARCHAR(5)
                        END RECORD
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line   #No.MOD-580242
 
    ORDER BY sr.abb01,sr.abb02,sr.abb03
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
 
            PRINT g_dash[1,g_len]
            PRINT g_x[41] CLIPPED,g_x[42] CLIPPED,g_x[43] CLIPPED,g_x[44] CLIPPED,
                  g_x[45] CLIPPED,g_x[46] CLIPPED,g_x[47] CLIPPED,g_x[48] CLIPPED
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
         SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=sr.abb03
                                                   AND aag00 = g_bookno     #NO.FUN-740049
         CASE sr.errno
           WHEN 'npp1' PRINT  COLUMN g_c[41],sr.abb01,
                              COLUMN g_c[42],sr.abb02 USING'####',
                              COLUMN g_c[43],sr.abb03[1,10],
                              COLUMN g_c[44],l_aag02,              
                              COLUMN g_c[48],g_x[13] CLIPPED        
           WHEN 'act1' PRINT  COLUMN g_c[41],sr.abb01,             
                              COLUMN g_c[42],sr.abb02 USING'####',
                              COLUMN g_c[43],sr.abb03[1,10],      
                              COLUMN g_c[44],l_aag02,            
                              COLUMN g_c[45],cl_numfor(sr.abb07,45,g_azi04),
                              COLUMN g_c[46],cl_numfor(sr.amt,46,g_azi04),
                              COLUMN g_c[48], g_x[34] CLIPPED
           WHEN 'act2'  PRINT COLUMN g_c[41],sr.abb01,           
                              COLUMN g_c[42],sr.abb02 USING'####',
                              COLUMN g_c[43],sr.abb03[1,10],      
                              COLUMN g_c[44],l_aag02,             
                              COLUMN g_c[48],g_x[15] CLIPPED      
           WHEN 'act3'  PRINT COLUMN g_c[41],sr.abb01,            
                              COLUMN g_c[42],sr.abb02 USING'####',
                              COLUMN g_c[43],sr.abb03[1,10],     
                              COLUMN g_c[44],l_aag02,             
                              COLUMN g_c[48],g_x[16] CLIPPED      
           WHEN 'act4'  PRINT COLUMN g_c[41],sr.abb01,             
                              COLUMN g_c[42],sr.abb02 USING'####',
                              COLUMN g_c[43],sr.abb03[1,10],       
                              COLUMN g_c[44],l_aag02,             
                              COLUMN g_c[48],g_x[17] CLIPPED      
           WHEN 'act5'  PRINT COLUMN g_c[41],sr.abb01,             
                              COLUMN g_c[42],sr.abb02 USING'####', 
                              COLUMN g_c[43],sr.abb03[1,10],       
                              COLUMN g_c[44],l_aag02,             
                              COLUMN g_c[48],g_x[18] CLIPPED      
           WHEN 'act6'  PRINT COLUMN g_c[41],sr.abb01,             
                              COLUMN g_c[42],sr.abb02 USING'####', 
                              COLUMN g_c[43],sr.abb03[1,10],       
                              COLUMN g_c[44],l_aag02,             
                              COLUMN g_c[48],g_x[19] CLIPPED      
           WHEN 'act7'  PRINT COLUMN g_c[41],sr.abb01,             
                              COLUMN g_c[42],sr.abb02 USING'####', 
                              COLUMN g_c[43],sr.abb03[1,10],       
                              COLUMN g_c[44],l_aag02,             
                              COLUMN g_c[48],g_x[20] CLIPPED      
           WHEN 'act8'  PRINT COLUMN g_c[41],sr.abb01,            
                              COLUMN g_c[42],sr.abb02 USING'####',
                              COLUMN g_c[43],sr.abb03[1,10],      
                              COLUMN g_c[44],l_aag02,             
                              COLUMN g_c[48],g_x[21] CLIPPED      
           WHEN 'act9'  PRINT COLUMN g_c[41],sr.abb01,             
                              COLUMN g_c[42],sr.abb02 USING'####', 
                              COLUMN g_c[43],sr.abb03[1,10],       
                              COLUMN g_c[44],l_aag02,             
                              COLUMN g_c[48],g_x[22] CLIPPED      
           WHEN 'act10' PRINT COLUMN g_c[41],sr.abb01,             
                              COLUMN g_c[42],sr.abb02 USING'####', 
                              COLUMN g_c[43],sr.abb03[1,10],       
                              COLUMN g_c[44],l_aag02,             
                              COLUMN g_c[48],g_x[23] CLIPPED      
           WHEN 'act11' PRINT COLUMN g_c[41],sr.abb01,             
                              COLUMN g_c[42],sr.abb02 USING'####', 
                              COLUMN g_c[43],sr.abb03[1,10],       
                              COLUMN g_c[44],l_aag02,             
                              COLUMN g_c[48],g_x[24] CLIPPED      
           WHEN 'act12' PRINT COLUMN g_c[41],sr.abb01,             
                              COLUMN g_c[42],sr.abb02 USING'####', 
                              COLUMN g_c[43],sr.abb03[1,10],       
                              COLUMN g_c[44],l_aag02,             
                              COLUMN g_c[48],g_x[25] CLIPPED      
           WHEN 'act13' PRINT COLUMN g_c[41],sr.abb01,             
                              COLUMN g_c[42],sr.abb02 USING'####', 
                              COLUMN g_c[43],sr.abb03[1,10],       
                              COLUMN g_c[44],l_aag02,             
                              COLUMN g_c[48],g_x[26] CLIPPED      
           WHEN 'act14' PRINT COLUMN g_c[41],sr.abb01,             
                              COLUMN g_c[42],sr.abb02 USING'####', 
                              COLUMN g_c[43],sr.abb03[1,10],       
                              COLUMN g_c[44],l_aag02,             
                              COLUMN g_c[45],cl_numfor(sr.abb07,45,g_azi04),
                              COLUMN g_c[46],cl_numfor(sr.amt,46,g_azi04), 
                              COLUMN g_c[47],cl_numfor((sr.abb07-sr.amt),47,g_azi04), 
                              COLUMN g_c[48],g_x[35] CLIPPED
           WHEN 'act15' PRINT COLUMN g_c[41],sr.abb01,             
                              COLUMN g_c[42],sr.abb02 USING'####', 
                              COLUMN g_c[43],sr.abb03[1,10],       
                              COLUMN g_c[44],l_aag02,             
                              COLUMN g_c[48],g_x[28] CLIPPED      
           WHEN 'act16' PRINT COLUMN g_c[41],sr.abb01,             
                              COLUMN g_c[42],sr.abb02 USING'####', 
                              COLUMN g_c[43],sr.abb03[1,10],       
                              COLUMN g_c[44],l_aag02,             
                              COLUMN g_c[48],g_x[29] CLIPPED      
           WHEN 'act17' PRINT COLUMN g_c[41],sr.abb01,             
                              COLUMN g_c[42],sr.abb02 USING'####', 
                              COLUMN g_c[43],sr.abb03[1,10],       
                              COLUMN g_c[44],l_aag02,             
                              COLUMN g_c[48],g_x[30] CLIPPED      
           WHEN 'act18' PRINT COLUMN g_c[41],sr.abb01,             
                              COLUMN g_c[42],sr.abb02 USING'####', 
                              COLUMN g_c[43],sr.abb03[1,10],       
                              COLUMN g_c[44],l_aag02,             
                              COLUMN g_c[48],g_deptdesc CLIPPED      
         OTHERWISE EXIT CASE             
         END CASE                       
                                         
        ON LAST ROW                     
            IF g_zz05 = 'Y' THEN                                                        
               CALL cl_wcchp(tm.wc,'npp01,npp02')         
               RETURNING tm.wc                                                     
               LET g_str = tm.wc                                                        
            END IF
            PRINT g_dash[1,g_len]        
            LET l_trailer_sw = 'n'
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT}
#No.FUN-750115---End
 
