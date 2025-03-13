# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: acor206.4gl
# Descriptions...: 原材料出入庫明細帳
# Date & Author..: 05/02/02 by ice
# Modify.........: No.FUN-550036 05/05/19 By day   單據編號加大
# Modify.........: No.FUN-560011 05/06/03 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.TQC-610082 06/04/07 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.TQC-6A0085 06/11/08 By ice 修正報表格式錯誤
# Modify.........: No.FUN-770006 07/07/23 By zhoufeng 報表輸出轉為Crystal Reports
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-C80041 12/12/21 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   tm  RECORD
             wc      LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(300)
             wc1     LIKE gbc_file.gbc05,         #No.FUN-680069 VARCHAR(100)
             y1      LIKE type_file.dat,          #No.FUN-680069 DATE
             y2      LIKE type_file.dat,          #No.FUN-680069 DATE
             y       LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
             more    LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
             END RECORD
DEFINE   g_i         LIKE type_file.num5          #No.FUN-680069 SMALLINT
DEFINE   l_wc        LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(300)
DEFINE   l_i         LIKE type_file.num5          #No.FUN-680069 SMALLINT
DEFINE   g_sql       STRING                       #No.FUN-770006
DEFINE   g_str       STRING                       #No.FUN-770006
DEFINE   l_table     STRING                       #No.FUN-770006
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
#No.FUN-770006 --start--
   LET g_sql="coc03.coc_file.coc03,cob01.cob_file.cob01,cob09.cob_file.cob09,",
             "cob02.cob_file.cob02,cob021.cob_file.cob021,",
             "cob04.cob_file.cob04,dat.type_file.dat,gbc05.gbc_file.gbc05,",
             "qcs01.qcs_file.qcs01,cob07.cob_file.cob07,cnl05.cnl_file.cnl05,",
             "cnl06.cnl_file.cnl06,cnl07.cnl_file.cnl07,cnl08.cnl_file.cnl08,",
             "cnl09.cnl_file.cnl09,cnl10.cnl_file.cnl10"
 
   LET l_table = cl_prt_temptable('acor206',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep',status,1) EXIT PROGRAM
   END IF
#No.FUN-770006 --end--
 
 
   INITIALIZE tm.* TO NULL                # Default condition
   LET tm.more  = 'N'
   LET tm.y = 'N'
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
#-------------------No.TQC-610082 modify
   LET tm.wc1   = ARG_VAL(8)
   LET tm.y1    = ARG_VAL(9)
   LET tm.y2    = ARG_VAL(10)
   LET tm.y     = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#-------------------No.TQC-610082 end
 
   IF cl_null(g_bgjob) or g_bgjob = 'N'
      THEN CALL acor206_tm(0,0)
      ELSE CALL acor206()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION acor206_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680069 SMALLINT
       l_cmd          LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(400)
 
   LET p_row = 5 LET p_col = 20
 
   OPEN WINDOW acor206_w AT p_row,p_col WITH FORM "aco/42f/acor206"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.y    = 'N'
   LET tm.y1   = g_today
   LET tm.y2   = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies= '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON  cob09,coc03,cob01
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
          ON ACTION help                    #MOD-4C0121
             CALL cl_show_help()            #MOD-4C0121
 
          ON ACTION controlg                #MOD-4C0121
             CALL cl_cmdask()               #MOD-4C0121
 
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
         LET INT_FLAG = 0 CLOSE WINDOW acor206_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
         EXIT PROGRAM
            
      END IF
      IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
      INPUT BY NAME tm.y1,tm.y2,tm.y,tm.more  WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIElD y1
         IF cl_null(tm.y1) THEN
            NEXT FIELD y1
         END IF
 
      AFTER FIELD y2
         IF cl_null(tm.y2) OR tm.y2 < tm.y1 THEN
            NEXT FIELD y2
         END IF
      AFTER FIELD y
         IF tm.y NOT MATCHES "[YN]"
            THEN NEXT FIELD FORMONLY.y
         END IF
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]"
            THEN NEXT FIELD FORMONLY.more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()     # Command execution
 
      AFTER INPUT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
      IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW acor206_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
       WHERE zz01='acor206'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
        CALL cl_err('acor206','9031',1)    
      ELSE
         LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                     " '",g_pdate CLIPPED,"'",
                     " '",g_towhom CLIPPED,"'",
                     #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                     " '",g_bgjob CLIPPED,"'",
                     " '",g_prtway CLIPPED,"'",
                     " '",g_copies CLIPPED,"'",
                     " '",tm.wc CLIPPED,"'",
                     " '",tm.wc1 CLIPPED,"'",          #No.TQC-610082 add 
                     " '",tm.y1 CLIPPED,"'",           #No.TQC-610082 add 
                     " '",tm.y2 CLIPPED,"'",           #No.TQC-610082 add 
                     " '",tm.y CLIPPED,"'",            #No.TQC-610082 add
                     " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                     " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                     " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
         CALL cl_cmdat('acor206',g_time,l_cmd)    # Execute cmd at later time
      END IF
   CLOSE WINDOW acor206_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
   EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL acor206()
   END WHILE
   CLOSE WINDOW acor206_w
END FUNCTION
 
FUNCTION acor206()
   DEFINE l_name    LIKE type_file.chr20,        #No.FUN-680069 VARCHAR(20) # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0063
          l_sql     STRING,      #No.FUN-680069 VARCHAR(1200) #No.TQC-6A0085
          l_za05    LIKE za_file.za05,
          l_order   ARRAY[5] OF LIKE adj_file.adj02,       #No.FUN-680069 VARCHAR(20)
          sr        RECORD
                       coc03   LIKE coc_file.coc03,
                       cob01   LIKE cob_file.cob01,
                       cob09   LIKE cob_file.cob09,
                       cob02   LIKE cob_file.cob02,
                       cob04   LIKE cob_file.cob04
                    END RECORD,
          sr1       RECORD
                       dt      LIKE type_file.dat,         #No.FUN-680069 DATE
                      #smtdesc VARCHAR(20),      #No.FUN-550036
                       smtdesc LIKE gbc_file.gbc05,        #No.FUN-680069 VARCHAR(80)  #No.FUN-560011
                       inno    LIKE qcs_file.qcs01,        #No.FUN-680069 VARCHAR(16) #No.FUN-550036
                       num021  LIKE cob_file.cob07,        #No.FUN-680069 DEC(15,3)
                       num022  LIKE cob_file.cob07,        #No.FUN-680069 DEC(15,3)
                       num023  LIKE cob_file.cob07,        #No.FUN-680069 DEC(15,3)
                       coc03   LIKE coc_file.coc03,        #No.FUN-680069 VARCHAR(15)
                       cob01   LIKE cob_file.cob01         #No.FUN-680069 VARCHAR(15)
                    END RECORD
#FUN-770006 --start--
   DEFINE l_sum1       LIKE eca_file.eca60,       
          l_sum2       LIKE eca_file.eca60,       
          l_sum3       LIKE eca_file.eca60,       
          l_sum4       LIKE eca_file.eca60,       
          l_sum401     LIKE eca_file.eca60,       
          l_sum402     LIKE eca_file.eca60,       
          l_sum403     LIKE eca_file.eca60,       
          l_sum404     LIKE eca_file.eca60,       
          l_sum5       LIKE eca_file.eca60,       
          l_xx         LIKE coc_file.coc02,       
          l_title      LIKE cob_file.cob08,       
          l_yy         LIKE type_file.num5,       
          l_mm         LIKE type_file.num5,       
          l_py         LIKE type_file.num5,       
          l_pm         LIKE type_file.num5,       
          l_bdate      LIKE type_file.dat,        
          l_edate      LIKE type_file.dat,        
          l_cob021     LIKE cob_file.cob021,                            
          l_cob01_t    LIKE cob_file.cob01,                               
          l_cob09_t    LIKE cob_file.cob09,                             
          l_coc03_t    LIKE coc_file.coc03
#No.FUN-770006 --end--
 
   CALL cl_del_data(l_table)                         #No.FUN-770006
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN
   #      LET tm.wc = tm.wc clipped," AND cobuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN
   #      LET tm.wc = tm.wc clipped," AND cobgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND cobgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('cobuser', 'cobgrup')
   #End:FUN-980030
 
      LET l_sql = "SELECT DISTINCT coc03,cob01,cob09,cob02,cob04 ",
                  "  FROM coc_file,cob_file,coe_file,coo_file,col_file  ",
                  " WHERE coe03 = cob01 AND coc01=coe01 ",
                  "   AND coo01=col01  AND coo02=col02        ",
                  "   AND (coo10='3' OR coo10='4')          ",
                  "   AND col04=cob01 AND coo18=coc03 AND cooconf = 'Y' ",
                  "   AND cocacti='Y' AND cooacti = 'Y' AND cobacti = 'Y' ",
                  "   AND coo03 BETWEEN '",tm.y1,"' AND '",tm.y2,"'  ",
                  "   AND ",tm.wc CLIPPED,
                  " UNION ",
                  "SELECT DISTINCT coc03,cob01,cob09,cob02,cob04 ",
                  "  FROM coc_file,cob_file,coe_file,cop_file   ",
                  " WHERE coe03 = cob01 AND coc01=coe01     ",
                  "   AND cop10='7' AND cop11=cob01 AND cop18=coc03 ",
                  "   AND copconf = 'Y' AND copacti = 'Y' ",
                  "   AND cocacti='Y' AND cobacti = 'Y' ",
                  "   AND cop03 BETWEEN  '",tm.y1,"' AND '",tm.y2,"'  ",
                  "   AND ",tm.wc CLIPPED,
                  " UNION ",
                  "SELECT DISTINCT coc03,cob01,cob09,cob02,cob04 ",
                  "  FROM coc_file,cob_file,coe_file,cno_file,cnp_file   ",
                  " WHERE coe03 = cob01 AND coc01=coe01     ",
                  "   AND cno03='2' AND cno031='3' AND cno04='0'  ",
                  "   AND cnp01=cno01 AND cnp03=cob01 AND cno10=coc03 ",
                  "   AND cnoconf = 'Y' AND cnoacti = 'Y' ",
                  "   AND cocacti='Y' AND cobacti = 'Y' ",
                  "   AND cno02 BETWEEN  '",tm.y1,"' AND '",tm.y2,"'  ",
                  "   AND ",tm.wc CLIPPED
 
   IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
   PREPARE acor206_pre1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM 
   END IF
   DECLARE acor206_cs1 CURSOR FOR acor206_pre1
 
   LET l_sql = "SELECT coo03,smydesc,coo01,col10,0,col10,coo18,coo11 ",
               "  FROM col_file,coc_file,cob_file,coe_file, coo_file LEFT OUTER JOIN smy_file ON coo01 LIKE LTRIM(RTRIM(smy_file.smyslip))||'-%'  ",
#No.FUN-550036--begin
#              " WHERE smy_file.smyslip=substr(coo01,1,3)  ",
               " WHERE 1 = 1 ",
#No.FUN-550036--end
               "   AND coo18 = coc03  AND col04 = cob01 AND coe03 = cob01 ",
               "   AND coo18 = ?  AND coo11 = ?  AND coc01=coe01",
               "   AND coo01=col01  AND coo02=col02  ",
               "   AND (coo10='3' OR coo10='4')  ",
               "   AND coo03 BETWEEN '",tm.y1,"' AND '",tm.y2,"'  ",
               "   AND cocacti = 'Y' AND cooacti = 'Y' ",
               "   AND cooconf = 'Y' AND cobacti = 'Y' "
   PREPARE r206_pre2 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare2:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM 
   END IF
   DECLARE r206_cs2 CURSOR FOR r206_pre2
 
   LET l_sql = "SELECT cop03,smydesc,cop01,cop16,0,0,cop18,cop11 ",
               "  FROM coc_file,cob_file,coe_file,cop_file LEFT OUTER JOIN smy_file ON cop01 like LTRIM(RTRIM(smy_file.smyslip))||'-%'",
#No.FUN-550036--begin
#              " WHERE smy_file.smyslip=substr(cop01,1,3) ",
               " WHERE 1 = 1 ",
#No.FUN-550036--end
               "   AND cop18 = coc03  AND cop11 = cob01 AND coe03 = cob01  ",
               "   AND cop18 = ?  AND cop11 = ? AND coc01=coe01 ",
               "   AND cop10='7'    ",
               "   AND cop03 BETWEEN  '",tm.y1,"' AND '",tm.y2,"'  ",
               "   AND copconf = 'Y' AND copacti = 'Y' ",
               "   AND cocacti='Y' AND cobacti = 'Y' "
   PREPARE r206_pre3 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare3:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM 
   END IF
   DECLARE r206_cs3 CURSOR FOR r206_pre3
 
   LET l_sql = "SELECT cno02, smydesc, cno01,0,cnp05,0,cno10,cnp03 ",
               "  FROM cno_file,cnp_file ,smy_file,coc_file,cob_file,coe_file  ",
#No.FUN-550036--begin
#              " WHERE smyslip=cno01[1,3]   ",
               "  WHERE cno01 like ltrim(rtrim(smyslip))||'-%' ",
#No.FUN-550036--end
               "   AND cno10 = coc03   AND   cnp03 = cob01 AND coe03 = cob01  ",
               "   AND cno10 = ?   AND   cnp03 = ? AND coc01=coe01 ",
               "   AND cnp01=cno01 ",
               "   AND cno03='2'   AND cno031='3' AND cno04='0' ",
               "   AND cno02 BETWEEN  '",tm.y1,"' AND '",tm.y2,"'  ",
               "   AND cnoconf = 'Y' AND cnoacti = 'Y' ",
               "   AND cocacti='Y' AND cobacti = 'Y' "
   PREPARE r206_pre4 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare4:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM 
   END IF
   DECLARE r206_cs4 CURSOR FOR r206_pre4
 
#  CALL cl_outnam('acor206') RETURNING l_name        #No.FUN-770006
 
   DROP TABLE r206_temp
#No.FUN-680069-begin
   CREATE TEMP TABLE r206_temp(
        dt      LIKE type_file.dat,   
        smtdesc LIKE type_file.chr1000,
        inno    LIKE type_file.chr1000,
        num021  LIKE cob_file.cob07,
        num022  LIKE cob_file.cob07,
        num023  LIKE cob_file.cob07,
        coc03   LIKE coc_file.coc03,
        cob01   LIKE cob_file.cob01)
#No.FUN-680069-end
#  START REPORT acor206_rep TO l_name               #No.FUN-770006
#  LET g_pageno = 0                                 #No.FUN-770006
#  DELETE FROM r206_temp
   FOREACH acor206_cs1 INTO sr.*
      IF SQLCA.sqlcode  THEN
         CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
      END IF
      FOREACH r206_cs2 USING sr.coc03,sr.cob01 INTO sr1.*
         IF SQLCA.sqlcode  THEN
            CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
         END IF
#No.FUN-770006 --start--
         LET l_cob01_t = 'NULL'                                                 
         LET l_cob09_t = 'NULL'                                                 
         LET l_coc03_t = 'NULL'                                                 
         LET l_xx = YEAR(tm.y1) - 1                                             
         LET l_sum1 = 0                                                         
         LET l_sum2 = 0                                                         
         LET l_sum3 = 0                                                         
         LET l_sum4 = 0                                                         
         LET l_sum5 = 0 
#No.FUN-770006 --end--
         IF (cl_null(sr1.coc03) AND cl_null(sr1.cob01)) THEN
            CONTINUE FOREACH
         ELSE
            INSERT INTO r206_temp VALUES(sr1.*)
         END IF
      END FOREACH
      FOREACH r206_cs3 USING sr.coc03,sr.cob01 INTO sr1.*
         IF SQLCA.sqlcode  THEN
            CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
         END IF
         IF (cl_null(sr1.coc03) AND cl_null(sr1.cob01)) THEN
            CONTINUE FOREACH
         ELSE
            INSERT INTO r206_temp VALUES(sr1.*)
         END IF
      END FOREACH
      FOREACH r206_cs4 USING sr.coc03,sr.cob01 INTO sr1.*
         IF SQLCA.sqlcode  THEN
            CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
         END IF
         IF (cl_null(sr1.coc03) AND cl_null(sr1.cob01)) THEN
            CONTINUE FOREACH
         ELSE
            INSERT INTO r206_temp VALUES(sr1.*)
         END IF
      END FOREACH
      LET l_sql = " SELECT * FROM r206_temp "
      PREPARE r206_pre6 FROM l_sql
      DECLARE r206_cs5 CURSOR FOR r206_pre6
      FOREACH r206_cs5 INTO sr1.*
#        OUTPUT TO REPORT acor206_rep(sr.*,sr1.*)           #No.FUN-770006
#No.FUN-770006 --start--
         IF (sr.coc03 = sr1.coc03 AND sr.cob01 = sr1.cob01)  THEN
            IF (sr.coc03 <> l_coc03_t OR sr.cob01 <> l_cob01_t ) THEN
               CALL s_yp(tm.y1) RETURNING l_yy,l_mm
               CALL s_lsperiod(YEAR(tm.y1),MONTH(tm.y1)) RETURNING l_py,l_pm
               CALL s_azn01(l_yy,l_mm) RETURNING l_bdate,l_edate
               SELECT SUM(cnl16) INTO l_sum401
                      FROM cnl_file
               WHERE cnl01 = sr.coc03 AND cnl02 = sr.cob01
                     AND cnl03 = l_py AND cnl04 = l_pm
               IF cl_null(l_sum401) THEN LET l_sum401 = 0 END IF
               SELECT SUM(col10) INTO l_sum402
                      FROM coo_file,col_file
               WHERE coo01=col01 AND coo02=col02
                     AND (coo10='3' OR coo10='4')
                     AND coo18=sr.coc03  AND coo11=sr.cob01
                     AND coo03 between l_bdate and tm.y1
               IF cl_null(l_sum402) THEN LET l_sum402 = 0 END IF
               SELECT SUM(cop16)  INTO l_sum403
                      FROM cop_file
               WHERE cop10='7' AND cop18=sr.coc03  AND cop11=sr.cob01
                     AND cop03 between l_bdate and tm.y1
               IF cl_null(l_sum403) THEN LET l_sum403 = 0 END IF
               SELECT SUM(cnp05)  INTO l_sum404
                      FROM cno_file,cnp_file
               WHERE cnp01=cno01 AND cno03='2'  AND cno031='3' AND cno04='0'
                     AND cno10=sr.coc03 AND cnp03=sr.cob01
                     AND cno02 between l_bdate and tm.y1
                     AND cnoconf <> 'X'  #CHI-C80041
               IF cl_null(l_sum404) THEN LET l_sum404 = 0 END IF
               LET l_sum4 = l_sum401+l_sum402+l_sum403-l_sum404
               LET l_sum5 = l_sum401+l_sum403
               LET l_sum1 = l_sum4
               LET l_sum2 = l_sum5
               LET l_cob01_t = sr.cob01
               LET l_cob09_t = sr.cob09
               LET l_coc03_t = sr.coc03
            END IF
            LET l_sum4 = sr1.num021-sr1.num022+l_sum4
            LET l_sum5 = sr1.num021-sr1.num023+l_sum5
            EXECUTE insert_prep USING sr.coc03,sr.cob01,sr.cob09,sr.cob02,
                                      l_cob021,sr.cob04,sr1.dt,sr1.smtdesc,
                                      sr1.inno,sr1.num021,sr1.num022,
                                      sr1.num023,l_sum4,l_sum5,l_sum1,l_sum2
         END IF
#No.FUN-770006 --end--
      END FOREACH
   END FOREACH
 
#  FINISH REPORT acor206_rep                        #No.FUN-770006  
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)      #No.FUN-770006
#No.FUN-770006 --start--
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05 ='Y' THEN
      CALL cl_wcchp(tm.wc,'cob09,coc03,cob01')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   LET g_str = tm.y1,";",tm.y2,";",tm.y,";",g_str
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
   CALL cl_prt_cs3('acor206','acor206',l_sql,g_str)
#No.FUN-770006 --end--
END FUNCTION
#No.FUN-770006 --start--
{REPORT acor206_rep(sr,sr1)
   DEFINE l_last_sw    LIKE type_file.chr1,        #No.FUN-680069 VARCHAR(1) 
          l_sum1       LIKE eca_file.eca60,        #No.FUN-680069 DEC(13,2)
          l_sum2       LIKE eca_file.eca60,        #No.FUN-680069 DEC(13,2)
          l_sum3       LIKE eca_file.eca60,        #No.FUN-680069 DEC(13,2)
          l_sum4       LIKE eca_file.eca60,        #No.FUN-680069 DEC(13,2)
          l_sum401     LIKE eca_file.eca60,        #No.FUN-680069 DEC(13,2)
          l_sum402     LIKE eca_file.eca60,        #No.FUN-680069 DEC(13,2)
          l_sum403     LIKE eca_file.eca60,        #No.FUN-680069 DEC(13,2)
          l_sum404     LIKE eca_file.eca60,        #No.FUN-680069 DEC(13,2)
          l_sum5       LIKE eca_file.eca60,        #No.FUN-680069 DEC(13,2)
          l_xx         LIKE coc_file.coc02,        #No.FUN-680069 VARCHAR(4)
          l_title      LIKE cob_file.cob08,        #No.FUN-680069 VARCHAR(30)
          l_yy         LIKE type_file.num5,        #No.FUN-680069 SMALLINT
          l_mm         LIKE type_file.num5,        #No.FUN-680069 SMALLINT
          l_py         LIKE type_file.num5,        #No.FUN-680069 SMALLINT
          l_pm         LIKE type_file.num5,        #No.FUN-680069 SMALLINT
          l_bdate      LIKE type_file.dat,         #No.FUN-680069 DATE
          l_edate      LIKE type_file.dat,         #No.FUN-680069 DATE
          l_cob021     LIKE cob_file.cob021,
          l_cob01_t    LIKE cob_file.cob01,
          l_cob09_t    LIKE cob_file.cob09,
          l_coc03_t    LIKE coc_file.coc03,
          sr        RECORD
                       coc03  LIKE coc_file.coc03,
                       cob01  LIKE cob_file.cob01,
                       cob09  LIKE cob_file.cob09,
                       cob02  LIKE cob_file.cob02,
                       cob04  LIKE cob_file.cob04
                    END RECORD,
          sr1       RECORD
                       dt      LIKE type_file.dat,          #No.FUN-680069 DATE
                       smtdesc LIKE gbc_file.gbc05,         #No.FUN-680069 VARCHAR(80) #No.FUN-560011
                      #smtdesc VARCHAR(20),  #No.FUN-550036
                       inno    LIKE qcs_file.qcs01,       #No.FUN-680069 VARCHAR(16)  #No.FUN-550036
                       num021  LIKE cob_file.cob07,       #No.FUN-680069 DEC(15,3)
                       num022  LIKE cob_file.cob07,       #No.FUN-680069 DEC(15,3)
                       num023  LIKE cob_file.cob07,       #No.FUN-680069 DEC(15,3)
                       coc03   LIKE coc_file.coc03,       #No.FUN-680069 VARCHAR(15)
                       cob01   LIKE cob_file.cob01        #No.FUN-680069 VARCHAR(15)  
                    END RECORD
 
   OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
   ORDER BY sr.coc03,sr.cob01,sr.cob09
   FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
 
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
 
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1 ,g_x[1] CLIPPED   #No.TQC-6A0085
      PRINT
      SELECT cob021 INTO l_cob021 FROM cob_file WHERE cob01=sr.cob01
      PRINT COLUMN 1,  g_x[9]  CLIPPED,
            COLUMN 10, sr.coc03
            IF (tm.y = 'N') THEN
               PRINT COLUMN 1,   g_x[10] CLIPPED,sr.cob01,
                     COLUMN 18,  g_x[11] CLIPPED,sr.cob02
               PRINT COLUMN 1,   g_x[17] CLIPPED,l_cob021,
                     COLUMN 45,  g_x[12] CLIPPED,tm.y1,'-',tm.y2,
                     COLUMN 88,  g_x[13] CLIPPED,sr.cob04
            ELSE
               PRINT COLUMN 1,   g_x[10] CLIPPED,sr.cob09,
                     COLUMN 18,  g_x[11] CLIPPED,sr.cob02
               PRINT COLUMN 1,   g_x[17] CLIPPED,l_cob021,
                     COLUMN 45,  g_x[12] CLIPPED,tm.y1,'-',tm.y2,
                     COLUMN 88,  g_x[13] CLIPPED,sr.cob04
            END IF
      PRINT g_dash[1,g_len]
 
      PRINT COLUMN r206_getStartPos(31,33,g_x[14]),g_x[14],
            COLUMN r206_getStartPos(37,38,g_x[15]),g_x[15]
      PRINT COLUMN g_c[31],g_dash2[1,g_w[31]+g_w[32]+g_w[33]+2],
            COLUMN g_c[37],g_dash2[1,g_w[37]+g_w[38]+1]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38]
      PRINT g_dash1
   LET l_last_sw='n'
   LET l_cob01_t = 'NULL'
   LET l_cob09_t = 'NULL'
   LET l_coc03_t = 'NULL'
   LET l_xx = YEAR(tm.y1) - 1
   LET l_sum1 = 0
   LET l_sum2 = 0
   LET l_sum3 = 0
   LET l_sum4 = 0
   LET l_sum5 = 0
   BEFORE GROUP OF sr.coc03
        SKIP TO TOP OF PAGE
   BEFORE GROUP OF sr.cob01
        SKIP TO TOP OF PAGE
   ON EVERY ROW
   IF (sr.coc03 = sr1.coc03 AND sr.cob01 = sr1.cob01)  THEN
      IF (sr.coc03 <> l_coc03_t OR sr.cob01 <> l_cob01_t ) THEN
         CALL s_yp(tm.y1) RETURNING l_yy,l_mm
         CALL s_lsperiod(YEAR(tm.y1),MONTH(tm.y1)) RETURNING l_py,l_pm
         CALL s_azn01(l_yy,l_mm) RETURNING l_bdate,l_edate
         SELECT SUM(cnl16) INTO l_sum401
           FROM cnl_file
          WHERE cnl01 = sr.coc03 AND cnl02 = sr.cob01
            AND cnl03 = l_py AND cnl04 = l_pm
         IF cl_null(l_sum401) THEN LET l_sum401 = 0 END IF
         SELECT SUM(col10) INTO l_sum402
           FROM coo_file,col_file
          WHERE coo01=col01 AND coo02=col02
            AND (coo10='3' OR coo10='4')
            AND coo18=sr.coc03  AND coo11=sr.cob01
            AND coo03 between l_bdate and tm.y1
         IF cl_null(l_sum402) THEN LET l_sum402 = 0 END IF
         SELECT SUM(cop16)  INTO l_sum403
           FROM cop_file
          WHERE cop10='7'
            AND cop18=sr.coc03  AND cop11=sr.cob01
            AND cop03 between l_bdate and tm.y1
         IF cl_null(l_sum403) THEN LET l_sum403 = 0 END IF
         SELECT SUM(cnp05)  INTO l_sum404
           FROM cno_file,cnp_file
          WHERE cnp01=cno01
            AND cno03='2'  AND cno031='3' AND cno04='0'
            AND cno10=sr.coc03     AND cnp03=sr.cob01
            AND cno02 between l_bdate and tm.y1
         IF cl_null(l_sum404) THEN LET l_sum404 = 0 END IF
         LET l_sum4 = l_sum401+l_sum402+l_sum403-l_sum404
         LET l_sum5 = l_sum401+l_sum403
 
         PRINTX name=S1 COLUMN g_c[31],g_x[16] CLIPPED,
               COLUMN g_c[37],  l_sum4 USING '-----------&.&&',
               COLUMN g_c[38],  l_sum5 USING '-----------&.&&'
 
         LET l_cob01_t = sr.cob01
         LET l_cob09_t = sr.cob09
         LET l_coc03_t = sr.coc03
      END IF
      LET l_sum4 = sr1.num021-sr1.num022+l_sum4
      LET l_sum5 = sr1.num021-sr1.num023+l_sum5
      PRINT  COLUMN g_c[31], sr1.dt     ,
             COLUMN g_c[32], sr1.smtdesc,
             COLUMN g_c[33], sr1.inno   ,
             COLUMN g_c[34], sr1.num021  USING '-----------&.&&',
             COLUMN g_c[35], sr1.num022  USING '-----------&.&&',
             COLUMN g_c[36], sr1.num023  USING '------------&.&&',
             COLUMN g_c[37], l_sum4      USING '-----------&.&&',
             COLUMN g_c[38], l_sum5      USING '-----------&.&&'
   END IF
   ON LAST ROW
      LET l_last_sw = 'Y'
      PRINT g_dash[1,g_len] CLIPPED
      PRINT g_x[4] CLIPPED,
            COLUMN (g_len-9), g_x[7] CLIPPED
   PAGE TRAILER
      LET l_xx = 'n'
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4] CLIPPED,
              COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
FUNCTION r206_getStartPos(l_sta,l_end,l_str)
DEFINE l_sta,l_end,l_length,l_pos,l_w_tot,l_i LIKE type_file.num5          #No.FUN-680069 SMALLINT
DEFINE l_str         STRING       #No.FUN-680069
   LET l_str=l_str.trim()
   LET l_length=l_str.getLength()
   LET l_w_tot=0
   FOR l_i=l_sta to l_end
      LET l_w_tot=l_w_tot+g_w[l_i]
   END FOR
   LET l_pos=(l_w_tot/2)-(l_length/2)
   IF l_pos<0 THEN LET l_pos=0 END IF
   LET l_pos=l_pos+g_c[l_sta]+(l_end-l_sta)
   RETURN l_pos
END FUNCTION}
#No.FUN-770006 --end--
