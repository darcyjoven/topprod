# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: acor307.4gl
# Descriptions...: 手冊成品出口數量表
# Date & Author..: 03/01/15 By Carrier
#                  modified by carrier 03/02/21
# Modify.........: No:6887 03/08/06 By Wiky cno06 放寬欄位24
# Modify.........: NO.MOD-490398 04/11/22 BY DAY  add HS Code,cno20,去cnp04
# Modify.........: NO.MOD-490398 04/12/24 BY Carrier 修改cno10之后的影響
# Modify.........: No.TQC-610082 06/04/19 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.TQC-6A0085 06/11/08 By ice 修正IFX執行錯誤
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global" #CKP
DEFINE   g_i    LIKE type_file.num5         #CKP #No.FUN-680069 SMALLINT
DEFINE   g_cnt  LIKE type_file.num5         #No.FUN-680069 SMALLINT #CKP
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(600) # Where condition
              a       LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
              y       LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1) # NO.MOD-490398
              more    LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1) # Input more condition(Y/N)
              END RECORD,
#因為全部SR共用一個g_cnp,所以每個SR用的g_cnp的範圍是sr.g_t至sr.g_cnt+sr.g_t
#目的:對于不同的手冊它要求打印的cnp03,cnp04的內容是不同的(變動的打印頭)
          g_number    LIKE type_file.num5,         #No.FUN-680069 SMALLINT #030224
          g_line_1    LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(300) #輸入打印報表頭的橫線
          g_cnp03     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(112) #報表頭的g_line上的cnp03
          g_cob09     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(132) #報表頭的g_line上的cob09 #NO.MOD-490398
 #          g_cnp04 VARCHAR(112),  #報表頭的g_line上的cnp04 #MOD-490398
          g_cnp05     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(112) #on every row中的金額數
          g_no        LIKE type_file.num5,         #No.FUN-680069 SMALLINT #序號數
          g_t         LIKE type_file.num5,         #No.FUN-680069 SMALLINT #(7-((g_cnt+1) mod 7 ))+g_cnt
          g_cnp ARRAY[300] OF RECORD #cnp03,cnp04組合的矩陣
                cnp03 LIKE cnp_file.cnp03,  #MOD-490398
                cob09 LIKE cob_file.cob09,  #MOD-490398
 #              cnp04 LIKE cnp_file.cnp04,  #BUG-490398 #MOD-490398
               cnptot LIKE cnp_file.cnp05   #該cnp03,cnp04的sum(cnp05)  #MOD-490398
                END RECORD
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   #CKP
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
   INITIALIZE tm.* TO NULL                # Default condition
#---------------No.TQC-610082 modify
#  LET tm.more = 'N'
#   LET tm.y = 'N'                         #MOD-490398
   LET g_pdate = ARG_VAL(1)
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.y  = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
#---------------No.TQC-610082 end
   LET g_trace = 'N'                       # default trace off
 
   IF cl_null(g_bgjob) or g_bgjob = 'N'
      THEN CALL acor307_tm(0,0)
      ELSE CALL acor307()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION acor307_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680069 SMALLINT
         l_cmd        LIKE type_file.chr1000        #No.FUN-680069 VARCHAR(400)
 
IF p_row = 0 THEN LET p_row = 5 LET p_col = 12 END IF
   LET p_row = 4 LET p_col = 30
   OPEN WINDOW acor307_w AT p_row,p_col
      #CKP
      WITH FORM "aco/42f/acor307"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.a = '1'
    LET tm.y = 'N'                         #MOD-490398
   LET tm.more= 'N'
   LET g_pdate= g_today
   LET g_rlang= g_lang
   LET g_bgjob= 'N'
   LET g_copies= '1'
 
 WHILE TRUE
 CONSTRUCT BY NAME tm.wc ON cno06,cnp03  #MOD-490398
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
    #CKP
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
   IF g_action_choice = "locale" THEN
        LET g_action_choice = ""
        CALL cl_dynamic_locale()
        CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW acor307_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
 INPUT BY NAME tm.a,tm.y,tm.more WITHOUT DEFAULTS HELP 1  #MOD-490398
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
        IF cl_null(tm.a) OR tm.a NOT MATCHES '[123]' THEN
           NEXT FIELD a
        END IF
      AFTER FIELD more
         IF tm.more NOT MATCHES '[YN]' OR tm.more IS NULL THEN
            NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      #CKP
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW acor307_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='acor307'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('acor307','9031',1)
      ELSE
         LET tm.wc=cl_wcsub(tm.wc)
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate  CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang   CLIPPED,"'",
                         " '",g_bgjob  CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'",
                         " '",tm.a     CLIPPED,"'",
                         " '",tm.y     CLIPPED,"'",  #MOD-490398
                        #" '",tm.more  CLIPPED,"'",   #No.TQC-610082 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
 
         IF g_trace = 'Y' THEN ERROR l_cmd END IF
         CALL cl_cmdat('acor307',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW acor307_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL acor307()
   ERROR ""
END WHILE
   CLOSE WINDOW acor307_w
END FUNCTION
 
FUNCTION acor307()
   DEFINE l_name    LIKE type_file.chr20,        #No.FUN-680069 VARCHAR(50) # External(Disk) file name
          l_name1   LIKE type_file.chr20,        #No.FUN-680069 VARCHAR(50)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0063
          l_sql     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(1200)
          l_za05    LIKE za_file.za05,           #MOD-490398
          l_i       LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_len     LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_len1    LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_space1  LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_space2  LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_space3  LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_j       LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_report  LIKE type_file.num5,         #No.FUN-680069 SMALLINT
 #        l_cno11   LIKE cno_file.cno11,         #No.MOD-490398
          l_cno10   LIKE cno_file.cno10,         #No.MOD-490398
          l_temp    LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(300)
          l_cnp05   LIKE cnp_file.cnp05,
          l_total   LIKE cnp_file.cnp05,
          l_cmd,l_cmd1,l_cmd2  LIKE type_file.chr1000,       #No.FUN-680069 VARCHAR(400)
       sr        RECORD
                            cno20  LIKE cno_file.cno20,  #MOD-490398
 #                          cno11  LIKE cno_file.cno11, #No.MOD-490398
                            cno10  LIKE cno_file.cno10, #No.MOD-490398
                            cno06  LIKE cno_file.cno06,
                            l_amt  LIKE cnp_file.cnp05,
                            l_no   LIKE type_file.num5,         #No.FUN-680069 SMALLINT
                           cnp03_s LIKE zaa_file.zaa08,         #No.FUN-680069 VARCHAR(112)  #No.TQC-6A0085
          #                cnp04_s VARCHAR(112),  #MOD-490398
                           cnp05_s LIKE zaa_file.zaa08,         #No.FUN-680069 VARCHAR(112)  #No.TQC-6A0085
                           line    LIKE zaa_file.zaa08,         #No.FUN-680069 VARCHAR(132)  #No.TQC-6A0085
                           g_cnt   LIKE type_file.num5,         #No.FUN-680069 SMALLINT
                           g_t     LIKE type_file.num5,         #No.FUN-680069 SMALLINT
                           g_total LIKE type_file.num5          #No.FUN-680069 SMALLINT
                    END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'acor307'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 132 END IF
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND cnouser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND cnogrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND cnogrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('cnouser', 'cnogrup')
     #End:FUN-980030
 
#####sr丟到report
     IF tm.a = '1' THEN LET l_temp = l_temp CLIPPED," AND cno04 = '1'" END IF
     IF tm.a = '2' THEN LET l_temp = l_temp CLIPPED," AND cno04 = '2'" END IF
     IF tm.a = '3' THEN
        LET l_temp = l_temp CLIPPED," AND (cno04 = '1' OR cno04 = '2')"
     END IF
 #     LET l_sql = "SELECT unique cno20,cno11,cno06,SUM(cnp05),0,'','','',0,0 ", #MOD-490398
      LET l_sql = "SELECT unique cno20,cno10,cno06,SUM(cnp05),0,'','','',0,0 ", #MOD-490398
                 "  FROM cno_file,cnp_file  ",
                 " WHERE cno01 = cnp01 ",
                 "   AND cnoconf = 'Y' AND cnoacti = 'Y' ",
                 "   AND cno03 = '1' AND cno031 = '1' ",
 #                 "   AND cno11 = ? ", #No.MOD-490398
                  "   AND cno10 = ? ", #No.MOD-490398
                 "   AND ",tm.wc CLIPPED
     LET l_sql = l_sql CLIPPED,' ',l_temp CLIPPED,   #No.TQC-6A0085
 #                 " GROUP BY cno20,cno11,cno06 " ,  #MOD-490398
                  " GROUP BY cno20,cno10,cno06 " ,  #MOD-490398
 #                 " ORDER BY cno20,cno11,cno06"     #MOD-490398
                  " ORDER BY cno20,cno10,cno06"     #MOD-490398
 
     IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
     PREPARE acor307_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM 
     END IF
     DECLARE acor307_curs1 CURSOR FOR acor307_prepare1
#######################
 #     LET l_sql = "SELECT unique cno11 ", #No.MOD-490398
      LET l_sql = "SELECT unique cno10 ", #No.MOD-490398
                 "  FROM cno_file,cnp_file  ",
                 " WHERE cno01 = cnp01 ",
                 "   AND cnoconf = 'Y' AND cnoacti = 'Y' ",
                 "   AND cno03 = '1' AND cno031 = '1' ",
                 "   AND ",tm.wc CLIPPED,' ',l_temp
 
     IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
     PREPARE acor307_prepare5 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM 
     END IF
     DECLARE acor307_curs2 CURSOR FOR acor307_prepare5
#####cnp03,cnp04丟到g_cnp矩陣中
      LET l_sql = "SELECT unique cnp03,SUM(cnp05) ",            #MOD-490398
                 "  FROM cno_file,cnp_file  ",
                 " WHERE cno01 = cnp01 ",
                 "   AND cnoconf = 'Y' AND cnoacti = 'Y' ",
                 "   AND cno03 = '1' AND cno031 = '1' ",
 #                 "   AND cno11 = ? ", #No.MOD-490398
                  "   AND cno10 = ? ", #No.MOD-490398
                 "   AND ",tm.wc CLIPPED
     LET l_sql = l_sql CLIPPED,' ',l_temp CLIPPED,  #No.TQC-6A0085
                  " GROUP BY cnp03 ",  #MOD-490398
                  " ORDER BY cnp03 "   #MOD-490398
     PREPARE acor307_prepare2 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM 
     END IF
     DECLARE acor307_cno1 CURSOR FOR acor307_prepare2
#####當前cnp03,cnp04,cno10丟到g_cnp矩陣中
     LET l_sql = "SELECT SUM(cnp05) ",
                 "  FROM cno_file,cnp_file  ",
 #                 " WHERE cno01 = cnp01 AND cno11 = ? ", #No.MOD-490398
                  " WHERE cno01 = cnp01 AND cno10 = ? ", #No.MOD-490398
                  "   AND cnp03 = ? ",  #MOD-490398
                 "   AND cnoconf = 'Y' AND cnoacti = 'Y' ",
                 "   AND cno03 = '1' AND cno031 = '1' ",
                 "   AND ",tm.wc CLIPPED,' ',l_temp
     PREPARE acor307_prepare4 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM 
     END IF
     DECLARE acor307_cno3 CURSOR FOR acor307_prepare4
#####sum(cnp05)丟至sr中,表示為當前cnp03,cnp04的cnp05
     LET l_sql = "SELECT SUM(cnp05) ",
                 "  FROM cno_file,cnp_file  ",
 #                 " WHERE cno01 = cnp01 AND cno11 = ? ", #No.MOD-490398
                  " WHERE cno01 = cnp01 AND cno10 = ? ", #No.MOD-490398
                  "   AND cno06 = ? AND cnp03 = ? ",  #MOD-490398
                 "   AND cnoconf = 'Y' AND cnoacti = 'Y' ",
                 "   AND cno03 = '1' AND cno031 = '1' ",
                 "   AND ",tm.wc CLIPPED,' ',l_temp
     PREPARE acor307_prepare3 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM 
     END IF
     DECLARE acor307_cno2 CURSOR FOR acor307_prepare3
     CALL cl_outnam('acor307') RETURNING l_name
     LET g_number = 0
     FOR l_i = 1 TO 200
         INITIALIZE g_cnp[l_i] TO NULL
     END FOR
     LET l_i = 1
 START REPORT acor307_rep TO l_name
 # FOREACH acor307_curs2 INTO l_cno11 #No.MOD-490398
  FOREACH acor307_curs2 INTO l_cno10 #No.MOD-490398
   IF SQLCA.sqlcode  THEN
      CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
   END IF
   LET l_i = g_number + 1
####cnp03,cnp04
 #     FOREACH acor307_cno1 USING l_cno11 INTO g_cnp[l_i].* #No.MOD-490398
      FOREACH acor307_cno1 USING l_cno10 INTO g_cnp[l_i].* #No.MOD-490398
       IF SQLCA.sqlcode  THEN
          CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
       END IF
       LET l_i = l_i + 1
     END FOREACH
     LET g_cnt = l_i - 1 - g_number   #cnp03,cnp04總數
     LET g_no = 1
     LET g_pageno = 0
####g_t=7-((g_cnt+1) mod 7) + (g_cnt+1) 多出的1指的是最后打印的小計
     LET l_i = (g_cnt + 1)/ 7
     IF (g_cnt+ 1) MOD 7 = 0 THEN
        LET g_t = g_cnt + 1
     ELSE
        LET g_t = (l_i + 1) * 7
     END IF
   FOR l_i = 1 TO g_t STEP 7   #每次7個cnp03,cnp04
         LET g_cnp03=''
          LET g_cob09=''               #MOD-490398
 #         LET g_cnp04=''   #MOD-490398
         LET g_line_1 = '---- ------------------------' #No:6887
         LET l_space1 = 0
         LET l_space2 = 0
         FOR l_j = 0 TO 6 #組g_cnp03,g_cnp04,g_line
 #NO.MOD-490398--begin
       IF tm.y = 'N' THEN
                  LET g_cnp03=g_cnp03 CLIPPED,' ',l_space1 SPACES,
                              g_cnp[l_i+l_j+g_number].cnp03 CLIPPED
       ELSE
          SELECT cob09 INTO g_cob09 FROM cob_file WHERE cob01=g_cnp03
          SELECT cob09 INTO g_cnp[l_i+l_j].cob09 FROM cob_file WHERE cob01=g_cnp[l_i+l_j].cnp03
                  LET g_cob09=g_cob09 CLIPPED,' ',l_space1 SPACES,
                              g_cnp[l_i+l_j].cob09[1,15] CLIPPED
       END IF
#             LET g_cnp03=g_cnp03 CLIPPED,' ',l_space1 SPACES,
#                         g_cnp[l_i+l_j+g_number].cnp03 CLIPPED
#             LET g_cnp04=g_cnp04 CLIPPED,' ',l_space2 SPACES,
#                         g_cnp[l_i+l_j+g_number].cnp04 CLIPPED
             LET l_len = 0
             LET l_space1=0
       IF tm.y = 'N' THEN
                  LET l_len  = LENGTH(g_cnp[l_i+l_j+g_number].cnp03[1,15])
       ELSE
                  LET l_len  = LENGTH(g_cnp[l_i+l_j+g_number].cob09[1,15])
       END IF
#             LET l_len  = LENGTH(g_cnp[l_i+l_j+g_number].cnp03)
 #NO.MOD-490398--end
             LET l_space1 = 15 - l_len
             IF l_space1 <> 15 THEN LET l_space3 = l_space1 END IF
 #             LET l_len1 = LENGTH(g_cnp[l_i+l_j+g_number].cnp04)  #MOD-490398
             LET l_space2 = 15 - l_len1
             IF l_len1 <>0 OR l_len <>0 THEN
                LET g_line_1 = g_line_1 CLIPPED,' ---------------'
             END IF
         END FOR
 #     FOREACH acor307_curs1 USING l_cno11 INTO sr.* #No.MOD-490398
      FOREACH acor307_curs1 USING l_cno10 INTO sr.* #No.MOD-490398
       IF SQLCA.sqlcode  THEN
          CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
       END IF
       LET g_cnp05 = ''
       LET l_cnp05 = 0
       FOR l_j = 0 TO 6
           #當前cnp03,cnp04,cno10,cno06的cnp05
 #           FOREACH acor307_cno2 USING sr.cno11,sr.cno06, #No.MOD-490398
            FOREACH acor307_cno2 USING sr.cno10,sr.cno06, #No.MOD-490398
                             g_cnp[l_i+l_j+g_number].cnp03  #bug-490398
                  INTO l_cnp05
              IF SQLCA.sqlcode  THEN
                 CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
              END IF
           END FOREACH
           IF cl_null(l_cnp05) THEN LET l_cnp05 = 0 END IF
           #不打多余的0
           IF l_i + l_j <= g_cnt THEN
              LET g_cnp05 = g_cnp05 CLIPPED,l_cnp05 USING " ---,---,--&.&&&"
           END IF
       END FOR
       LET sr.l_no = l_i
       LET sr.g_t = g_number
       LET sr.g_total = g_t
       LET sr.g_cnt = g_cnt
       LET sr.cnp05_s = g_cnp05
 #NO.MOD-490398--begin
            IF tm.y = 'N' THEN
                  LET sr.cnp03_s = g_cnp03
            ELSE
                  LET sr.cnp03_s = g_cob09
            END IF
#       LET sr.cnp04_s = g_cnp04
 #NO.MOD-490398--end
       LET sr.line = g_line_1
       #打完全部cnp03,cnp04之后的小計
       IF l_i > (g_cnt+1) - 7 THEN
          IF l_i = g_cnt + 1 THEN   #該行只有小計
             LET sr.cnp03_s = sr.cnp03_s CLIPPED,' ',g_x[12] CLIPPED
          ELSE
             LET sr.cnp03_s = sr.cnp03_s CLIPPED,' ',l_space3 SPACES,g_x[12] CLIPPED
          END IF
          LET sr.cnp05_s = sr.cnp05_s CLIPPED,sr.l_amt USING " ---,---,--&.&&&"
          LET sr.line = sr.line CLIPPED,' ---------------'
       END IF
       OUTPUT TO REPORT acor307_rep(sr.*)
     END FOREACH
   END FOR
   LET g_number = g_number + g_cnt
 END FOREACH
 FINISH REPORT acor307_rep
   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT acor307_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
       sr        RECORD
                            cno20   LIKE cno_file.cno20,  #MOD-490398
 #                          cno11   LIKE cno_file.cno11, #No.MOD-490398
                            cno10   LIKE cno_file.cno10, #No.MOD-490398
                            cno06   LIKE cno_file.cno06,
                            l_amt   LIKE cnp_file.cnp05,
                            l_no    LIKE type_file.num5,         #No.FUN-680069 SMALLINT
                            cnp03_s LIKE zaa_file.zaa08,         #No.FUN-680069 VARCHAR(112)  #No.TQC-6A0085
 #                          cnp04_s  VARCHAR(112),  #MOD-490398
                            cnp05_s LIKE zaa_file.zaa08,         #No.FUN-680069 VARCHAR(112)  #No.TQC-6A0085
                            line    LIKE zaa_file.zaa08,         #No.FUN-680069 VARCHAR(132)  #No.TQC-6A0085
                            g_cnt   LIKE type_file.num5,         #No.FUN-680069 SMALLINT
                            g_t     LIKE type_file.num5,         #No.FUN-680069 SMALLINT
                            g_total LIKE type_file.num5          #No.FUN-680069 SMALLINT
                    END RECORD,
          l_j       LIKE type_file.num5,          #No.FUN-680069 SMALLINT
          l_tmp     LIKE type_file.num5,          #No.FUN-680069 SMALLINT
          l_cna02   LIKE cna_file.cna02,
          n_cnp05   LIKE cnp_file.cnp05,
          l_cnp05   LIKE cnp_file.cnp05,
          t_cnp05   LIKE type_file.chr1000        #No.FUN-680069 VARCHAR(112)
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
 #  ORDER BY sr.cno20,sr.cno11,sr.cnp03_s  #MOD-490398
   ORDER BY sr.cno20,sr.cno10,sr.cnp03_s  #MOD-490398
 
  FORMAT
   PAGE HEADER
         PRINT
         PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
         IF g_towhom IS NULL OR g_towhom = ' ' THEN PRINT '';
         ELSE PRINT 'TO:',g_towhom;
         END IF
         PRINT COLUMN (g_len-FGL_WIDTH(g_user CLIPPED)-5),'FROM:',g_user CLIPPED   #No.TQC-6A0085
         PRINT (g_len-FGL_WIDTH(g_x[1] CLIPPED))/2 SPACES,g_x[1] CLIPPED  #No.TQC-6A0085
         PRINT ' '
 #MOD-490398(BEGIN)
         SELECT cna02 INTO l_cna02 FROM cna_file
         WHERE cna01=sr.cno20
         IF SQLCA.sqlcode THEN
            LET l_cna02 = ' '
         END IF
         PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
               COLUMN g_len/2-(FGL_WIDTH(sr.cno20)+9)/2,g_x[16] CLIPPED,sr.cno20 CLIPPED,' ',l_cna02 CLIPPED,'   ',
 #               g_x[15] CLIPPED,sr.cno11, #No.MOD-490398
                g_x[15] CLIPPED,sr.cno10 CLIPPED, #No.MOD-490398  #No.TQC-6A0085
               COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
         PRINT g_dash[1,g_len] CLIPPED  #No.TQC-6A0085
         PRINT COLUMN 1,g_x[11] CLIPPED,COLUMN 32,sr.cnp03_s CLIPPED #No.TQC-6A0085
         PRINT COLUMN 1,sr.line CLIPPED
 #MOD-490398(END)
      LET l_last_sw = 'n'
 #   BEFORE GROUP OF sr.cno11 #No.MOD-490398
    BEFORE GROUP OF sr.cno10 #No.MOD-490398
      LET g_no = 1
      LET n_cnp05 = 0
      SKIP TO TOP OF PAGE
   BEFORE GROUP OF sr.cnp03_s
      LET g_no = 1
      SKIP TO TOP OF PAGE
 
   ON EVERY ROW
        PRINT COLUMN 1,g_no USING "###&",
              COLUMN 6,sr.cno06 CLIPPED,      #No.TQC-6A0085
              COLUMN 30,sr.cnp05_s CLIPPED    #No:6887      #No.TQC-6A0085
        LET g_no = g_no + 1
#打印合計
   AFTER GROUP OF sr.cnp03_s
       LET t_cnp05 = ''
       LET l_cnp05 = 0
       FOR l_j = 0 TO 6
           LET l_tmp = sr.l_no + l_j + sr.g_t
 #           FOREACH acor307_cno3 USING sr.cno11, #No.MOD-490398
            FOREACH acor307_cno3 USING sr.cno10, #No.MOD-490398
                              g_cnp[l_tmp].cnp03  #MOD-490398
                  INTO l_cnp05
              IF SQLCA.sqlcode  THEN
                 CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
              END IF
           END FOREACH
           IF cl_null(l_cnp05) THEN LET l_cnp05 = 0 END IF
           LET n_cnp05 = n_cnp05 + l_cnp05
           IF sr.l_no + l_j <= sr.g_cnt THEN
              LET t_cnp05 = t_cnp05 CLIPPED,l_cnp05 USING " ---,---,--&.&&&"
           END IF
           IF sr.l_no + l_j > sr.g_cnt AND sr.l_no + l_j <= sr.g_total THEN
 #這所以要減去一個l_cnp05,因為存在著不同手冊之間有相同的cnp03,cnp04，多
 #加了最后一個g_cnp[sr.l_no + l_j + sr.g_t]的l_cnp05的值
              LET n_cnp05 = n_cnp05 - l_cnp05
              IF cl_null(n_cnp05) THEN LET n_cnp05 = 0 END IF
              LET t_cnp05 = t_cnp05 CLIPPED,n_cnp05 USING " ---,---,--&.&&&"
              EXIT FOR
           END IF
       END FOR
       PRINT
          PRINT COLUMN 12,g_x[14] CLIPPED,COLUMN 30,t_cnp05 CLIPPED #No:6887 #No.TQC-6A0085
 
   ON LAST ROW
#因為是由多個報表合起來的，所以不應該在每個報表的最后打印結束，而應該在最后一個
       PRINT g_dash[1,g_len] CLIPPED
       LET l_last_sw = 'y'
       PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED   #No.TQC-6A0085
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash[1,g_len] CLIPPED
         PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED   #No.TQC-6A0085
      ELSE SKIP 2 LINE
      END IF
END REPORT
 
#Patch....NO.TQC-610035 <001,002,003,004,005> #
