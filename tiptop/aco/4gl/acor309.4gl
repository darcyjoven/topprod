# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: acor309.4gl
# Descriptions...: 手冊料件進口情況表
# Date & Author..: 03/01/23 By Carrier
# Modify.........: NO.MOD-490398 04/11/24 BY Elva add HS Code,coc10,Customs No.
# Modify.........: NO.MOD-490398 04/12/24 BY Carrier 修改cno10之后的影響
#                  modify qty error
# Modify.........: No.FUN-550036 05/05/26 By Trisy 單據編號加大
# Modify.........: No.TQC-610082 06/04/19 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.TQC-6A0085 06/11/08 By ice 修正報表格式錯誤
# Modify.........: NO.FUN-750026 07/08/02 BY TSD.c123k 改為crystal report
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(600) # Where condition
              y       LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1) # NO.MOD-490398
              a       LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
              more    LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1) # Input more condition(Y/N)
              END RECORD,
#因為全部SR共用一個g_cot,所以每個SR用的g_cot的範圍是sr.g_t至sr.g_cnt+sr.g_t
#目的:對于不同的手冊它要求打印的cob02,cnp06的內容是不同的(變動的打印頭)
          g_number    LIKE type_file.num5,         #No.FUN-680069 SMALLINT #030224
          g_line_1    LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(132) #輸入打印報表頭的橫線
          g_cnp03     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(112) #報表頭的g_line上的cob02
          g_cob09     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(112) #報表頭的g_line上的cob09 #NO.MOD-490398
          g_cnp06     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(112) #報表頭的g_line上的cnp06
          g_cnp05     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(112) #on every row中的金額數
          g_no        LIKE type_file.num5,         #No.FUN-680069 SMALLINT #序號數
          g_t         LIKE type_file.num5,         #No.FUN-680069 SMALLINT #(7-((g_cnt+1) mod 7 ))+g_cnt
          g_cot DYNAMIC ARRAY OF RECORD #cob02,cnp06組合的矩陣
                 cnp03  LIKE cnp_file.cnp03, #NO.MOD-490398
                 cob09  LIKE cob_file.cob09, #NO.MOD-490398
                 cnp06  LIKE cnp_file.cnp06, #NO.MOD-490398
                 cnptot LIKE cnp_file.cnp05  #該cob02,cnp06的sum(cnp05)NO.MOD-490398
                END RECORD
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680069 SMALLINT
DEFINE   g_sql       STRING                  # FUN-750026 TSD.c123k
DEFINE   g_str       STRING                  # FUN-750026 TSD.c123k
DEFINE   l_table     STRING                  # FUN-750026 TSD.c123k
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
   # add FUN-750026
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> TSD.c123k *** ##
   LET g_sql = "coc10.coc_file.coc10,",
               "l_cna02.cna_file.cna02,",
               "coc03.coc_file.coc03,",
               "coc07.coc_file.coc07,",
               "cno07.cno_file.cno07,",
               "cno06.cno_file.cno06,",
               "cop05.cop_file.cop05,",
               "cop06.cop_file.cop06,",
               "l_cnp03.cnp_file.cnp03,",
               "l_cnp06.cnp_file.cnp06,",
               "l_cnp05.cnp_file.cnp05,",
               "t_cnp05.cnp_file.cnp05,",
               "n_cnp05.cnp_file.cnp05,",
               "p_cnp05.cnp_file.cnp05"
 
   LET l_table = cl_prt_temptable('acor309',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?) "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------------ CR (1) ------------------------------#
   # end FUN-750026
 
   INITIALIZE tm.* TO NULL                # Default condition
    LET tm.y    = 'N'    #NO.MOD-490398
   LET tm.more = 'N'
   LET g_pdate = ARG_VAL(1)
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
#-----------------No.TQC-610082 modify
   LET tm.a  = ARG_VAL(8)
   LET tm.y  = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#-----------------No.TQC-610082 end
 
   IF cl_null(g_bgjob) or g_bgjob = 'N'
      THEN CALL acor309_tm(0,0)
      ELSE CALL acor309()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION acor309_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680069 SMALLINT
         l_cmd        LIKE type_file.chr1000        #No.FUN-680069 VARCHAR(400)
 
   LET p_row = 3 LET p_col = 20
 
   OPEN WINDOW acor309_w AT p_row,p_col WITH FORM "aco/42f/acor309"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.a = '0'
    LET tm.y = 'N'    #NO.MOD-490398
   LET tm.more= 'N'
   LET g_pdate= g_today
   LET g_rlang= g_lang
   LET g_bgjob= 'N'
   LET g_copies= '1'
 
 WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON coc10,coc03,coc04,cno06,cop05,cnp03,coc07 #NO.MOD-490398
 
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
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW acor309_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
    INPUT BY NAME tm.y,tm.a,tm.more WITHOUT DEFAULTS #NO.MOD-490398
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
        IF cl_null(tm.a) OR tm.a NOT MATCHES '[012345]' THEN
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
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()     # Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW acor309_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='acor309'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('acor309','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate  CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang   CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob  CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'",
                         " '",tm.a     CLIPPED,"'",
                         " '",tm.y     CLIPPED,"'",         #No.TQC-610082 add
                        #" '",tm.more  CLIPPED,"'",         #No.TQC-610082 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
         CALL cl_cmdat('acor309',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW acor309_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL acor309()
   ERROR ""
END WHILE
   CLOSE WINDOW acor309_w
END FUNCTION
 
FUNCTION acor309()
   DEFINE l_name    LIKE type_file.chr20,        #No.FUN-680069 VARCHAR(50) # External(Disk) file name
          l_name1   LIKE type_file.chr20,        #No.FUN-680069 VARCHAR(50)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0063
          l_sql     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(1200)
          l_za05    LIKE za_file.za05,           # NO.MOD-490398
          l_temp    LIKE type_file.chr1000,      #No.FUN-680069
          l_i       LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_k       LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_k1      LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_len     LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_len1    LIKE type_file.num5,         #No.FUN-680069 SMALLINT 
          l_space1  LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_space2  LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_space3  LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_j       LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_report  LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_coc10   LIKE coc_file.coc10, #NO.MOD-490398
          l_coc03   LIKE coc_file.coc03,
          l_cnp05   LIKE cnp_file.cnp05,
          l_total   LIKE cnp_file.cnp05,
          l_cmd,l_cmd1,l_cmd2  LIKE type_file.chr1000,#No.FUN-680069 VARCHAR(400)
          #FUN-750026 TSD.c123k add ----------
          l_cna02   LIKE cna_file.cna02,
          l_cnp06   LIKE cnp_file.cnp06,
          l_cnp03   LIKE cnp_file.cnp03, 
          l_prepare LIKE coe_file.coe05,  
          l_coe05   LIKE coe_file.coe05,
          l_coe10   LIKE coe_file.coe10,
          l_coc01   LIKE coc_file.coc01,
          g_coe05   LIKE coe_file.coe05,
          g_coe10   LIKE coe_file.coe10,
          t_cnp05   LIKE type_file.chr1000,   
          n_cnp05   LIKE type_file.chr1000,  
          p_cnp05   LIKE type_file.chr1000,
          c_cnp05   LIKE cnp_file.cnp05,
          #FUN-750026 TSD.c123k end ----------  
          sr2       RECORD
                           cnp03   LIKE cnp_file.cnp03,
                           cnp06   LIKE cnp_file.cnp06,
                           l_amt   LIKE cnp_file.cnp05
                    END RECORD,
          sr        RECORD
                           coc10   LIKE coc_file.coc10, #NO.MOD-490398
                           coc03   LIKE coc_file.coc03,
                           coc07   LIKE coc_file.coc07,
                           cno07   LIKE cno_file.cno07,
                           cno06   LIKE cno_file.cno06,
                           cop05   LIKE cop_file.cop05,
                           cop06   LIKE cop_file.cop06,
                           cnp03   LIKE cnp_file.cnp03,
                           l_no    LIKE type_file.num5,         #No.FUN-680069 SMALLINT
                           cnp03_s LIKE zaa_file.zaa08,         #No.FUN-680069 VARCHAR(112)  #No.TQC-6A0085
                           cnp06_s LIKE zaa_file.zaa08,         #No.FUN-680069 VARCHAR(112)  #No.TQC-6A0085
                           cnp05_s LIKE zaa_file.zaa08,         #No.FUN-680069 VARCHAR(112)  #No.TQC-6A0085
                           line    LIKE zaa_file.zaa08,         #No.FUN-680069 VARCHAR(132)  #No.TQC-6A0085
                           g_cnt   LIKE type_file.num5,         #No.FUN-680069 SMALLINT
                           g_t     LIKE type_file.num5          #No.FUN-680069 SMALLINT
                    END RECORD
 
     # add FUN-750026
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> TSD.c123k *** ##
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     #------------------------------ CR (2) ----------------------------------#
     # end FUN-750026
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'acor309'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 126 END IF
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
 
      #No.MOD-490398  --begin
     DROP TABLE r309_cnp #No.MOD-490398 #No.TQC-6A0085
     LET l_sql=" SELECT cnp_file.*,cno_file.cno031 aa1,cno_file.cno04 aa2 FROM cnp_file,cno_file WHERE cno01=cnp01 AND cno03='2' INTO temp  r309_cnp "
     PREPARE cre_cnp FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare create cnp',SQLCA.sqlcode,0)
        RETURN
     END IF
     EXECUTE cre_cnp
     IF SQLCA.sqlcode THEN
        CALL cl_err('execute create cnp',SQLCA.sqlcode,0)
        RETURN
     END IF
     UPDATE r309_cnp SET cnp05=cnp05*(-1) WHERE aa1='1'
     IF SQLCA.sqlcode THEN
        CALL cl_err('update r309_cnp',SQLCA.sqlcode,0)
        RETURN
     END IF
      #No.MOD-490398  --end
#####sr丟到report
     #maggie
     IF tm.a = '1' THEN LET l_temp = l_temp CLIPPED," AND cno04 = '1'" END IF
     IF tm.a = '2' THEN LET l_temp = l_temp CLIPPED," AND cno04 = '2'" END IF
     IF tm.a = '3' THEN LET l_temp = l_temp CLIPPED," AND cno04 = '3'" END IF
     IF tm.a = '4' THEN LET l_temp = l_temp CLIPPED," AND cno04 = '5'" END IF
     IF tm.a = '5' THEN LET l_temp = l_temp CLIPPED," AND cno04 = '6'" END IF
     IF tm.a = '0' THEN
        LET l_temp = l_temp CLIPPED,
                     " AND (cno04='1' OR cno04='2' OR cno04='3' OR cno04='5' OR cno04='6')"
     END IF
 
      LET l_sql = "SELECT UNIQUE coc10,coc03,coc07,cno07,cno06,cop05,cop06,",#NO.MOD-490398
                 "       '','',0,'','','','' ",
                  "  FROM cob_file,coc_file,cop_file,cno_file,r309_cnp ", #No.MOD-490398
                 " WHERE cob01 = cnp03 ",
                 "   AND cno01 = cnp01 ",
                 "   AND cop_file.cop01 = cnp12 AND cop_file.cop02 = cnp13 ",
                  #"   AND coc03 = cno11 AND coc04 = cno10 ", #No.MOD-490398
                  "   AND coc03 = cno10 ", #No.MOD-490398
                  "   AND coc10 = cno20 ", #NO.MOD-490398
                 "   AND cno03 = 2 AND (cno031 = 2 OR cno031 = 1) ",
                  "   AND coc10 = ? AND coc03 = ? ", #NO.MOD-490398
                 "   AND cnoconf = 'Y' AND cnoacti = 'Y' ",
                 "   AND ",tm.wc CLIPPED
     LET l_sql = l_sql CLIPPED,' ',l_temp CLIPPED,
                  " GROUP BY coc10,coc03,coc07,cno07,cno06,cop05,cop06 ",#NO.MOD-490398
                  " ORDER BY coc10,coc03,coc07,cno07,cno06,cop05,cop06 " #NO.MOD-490398
     #end maggie
     PREPARE acor309_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM 
     END IF
     DECLARE acor309_curs1 CURSOR FOR acor309_prepare1
 
     #maggie
      LET l_sql = "SELECT UNIQUE coc10,coc03 ",#NO.MOD-490398
                  "  FROM cob_file,coc_file,cop_file,cno_file,r309_cnp ", #No.MOD-490398
                 " WHERE cob01 = cnp03 ",
                 "   AND cno01 = cnp01 ",
                 "   AND cop_file.cop01 = cnp12 AND cop_file.cop02 = cnp13 ",
                  #"   AND coc03 = cno11 AND coc04 = cno10 ", #No.MOD-490398
                  "   AND coc03 = cno10 ", #No.MOD-490398
                  "   AND coc10 = cno20 ",  #NO.MOD-490398
                 "   AND cno03 = 2 AND (cno031 = 2 OR cno031 = 1) ",
                 "   AND cnoconf = 'Y' AND cnoacti = 'Y' ",
                 "   AND ",tm.wc CLIPPED,' ',l_temp
     #end maggie
     PREPARE acor309_prepare4 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM 
     END IF
     DECLARE acor309_curs2 CURSOR FOR acor309_prepare4
 
#####cob02,cnp06丟到g_cnp矩陣中
     #maggie
     LET l_sql = "SELECT UNIQUE cnp03,cnp06,SUM(cnp05) ",
                  "  FROM cob_file,coc_file,cop_file,cno_file,r309_cnp ", #No.MOD-490398
                 " WHERE cob01 = cnp03 ",
                 "   AND cno01 = cnp01 ",
                 "   AND cop_file.cop01 = cnp12 AND cop_file.cop02 = cnp13 ",
                  #"   AND coc03 = cno11 AND coc04 = cno10 ", #No.MOD-490398
                  "   AND coc03 = cno10 ", #No.MOD-490398
                  "   AND coc10 = ? AND coc03 = ? ", #NO.MOD-490398
                  "   AND coc10 = cno20 ", #NO.MOD-490398
                 "   AND cno03 = 2 AND (cno031 = 2 OR cno031 = 1) ",
                 "   AND cnoconf = 'Y' AND cnoacti = 'Y' ",
                 "   AND ",tm.wc CLIPPED
     LET l_sql = l_sql CLIPPED,' ',l_temp CLIPPED,
                 " GROUP BY cnp03,cnp06 ",
                 " ORDER BY cnp03,cnp06 "
     #end maggie
     PREPARE acor309_prepare2 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM 
     END IF
     DECLARE acor309_cno1 CURSOR FOR acor309_prepare2
 
#####sum(cnp05)丟至sr中,表示為當前cob02,cnp06的cnp05
     #maggie
     LET l_sql = "SELECT SUM(cnp05) ",
                  "  FROM cob_file,coc_file,cop_file,cno_file,r309_cnp ", #No.MOD-490398
                 " WHERE cob01 = cnp03 ",
                 "   AND cno01 = cnp01 ",
                  "   AND coc10 = ? ",#NO.MOD-490398
                 "   AND coc03 = ? AND cno07 = ? ",
                 "   AND cno06 = ? AND cop_file.cop05 = ? ",
                 "   AND cnp03 = ? AND cnp06 = ? ",
                 "   AND cop_file.cop01 = cnp12 AND cop_file.cop02 = cnp13 ",
                  #"   AND coc03 = cno11 AND coc04 = cno10 ", #No.MOD-490398
                  "   AND coc03 = cno10 ", #No.MOD-490398
                  "   AND coc10 = cno20 ", #NO.MOD-490398
                 "   AND cno03 = 2 AND (cno031 = 2 OR cno031 = 1) ",
                 "   AND cnoconf = 'Y' AND cnoacti = 'Y' ",
                 "   AND ",tm.wc CLIPPED,' ',l_temp
     #end maggie
     PREPARE acor309_prepare3 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM 
     END IF
     DECLARE acor309_cno2 CURSOR FOR acor309_prepare3
     LET l_sql = "SELECT unique coc01 ",
                 "  FROM coc_file ",
                  " WHERE coc10 = ? AND coc03 = ? "  #NO.MOD-490398
     PREPARE acor309_prepare6 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM 
     END IF
     DECLARE acor309_coe02 CURSOR FOR acor309_prepare6
 
     #maggie
     LET l_sql = "SELECT SUM(cnp05) ",
                  "  FROM cob_file,coc_file,cop_file,cno_file,r309_cnp ", #No.MOD-490398
                 " WHERE cob01 = cnp03 ",
                  "   AND cno01 = cnp01 AND coc10 = ? AND coc03 = ? ",#NO.MOD-490398
                 "   AND cnp03 = ? AND cnp06 = ? ",
                 "   AND cop_file.cop01 = cnp12 AND cop_file.cop02 = cnp13 ",
                  #"   AND coc03 = cno11 AND coc04 = cno10 ", #No.MOD-490398
                  "   AND coc03 = cno10 ", #No.MOD-490398
                  "   AND coc10 = cno20 ", #NO.MOD-490398
                 "   AND cno03 = 2 AND (cno031 = 2 OR cno031 = 1) ",
                 "   AND cnoconf = 'Y' AND cnoacti = 'Y' ",
                 "   AND ",tm.wc CLIPPED,' ',l_temp
     #end maggie
     PREPARE acor309_prepare7 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM 
     END IF
     DECLARE acor309_cnp1 CURSOR FOR acor309_prepare7
 
     #FUN-750026 TSD.c123k add
     LET l_sql = "SELECT UNIQUE cnp03,cnp06,SUM(cnp05) ",
                 "  FROM cob_file,coc_file,cop_file,cno_file,r309_cnp ",
                 " WHERE cob01 = cnp03 ",
                 "   AND cno01 = cnp01 ",
                 "   AND cop_file.cop01 = cnp12 AND cop_file.cop02 = cnp13 ",
                 "   AND coc03 = cno10 ",
                 "   AND coc10 = ? AND coc03 = ? ",
                 "   AND cno06 = ? ",
                 "   AND coc10 = cno20 ",
                 "   AND cno03 = 2 AND (cno031 = 2 OR cno031 = 1) ",
                 "   AND cnoconf = 'Y' AND cnoacti = 'Y' ",
                 "   AND ",tm.wc CLIPPED
     LET l_sql = l_sql CLIPPED,' ',l_temp CLIPPED,
                 " GROUP BY cnp03,cnp06 ",
                 " ORDER BY cnp03,cnp06 "
     PREPARE acor309_prepare5 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM 
     END IF
     DECLARE acor309_cno_n CURSOR FOR acor309_prepare5
     #FUN-750026 TSD.c123k end 
 
     #CALL cl_outnam('acor309') RETURNING l_name  #FUN-750026 TSD.c123k mark
     LET g_number = 0
     FOR l_k = 1 TO 300
         INITIALIZE g_cot[l_k] TO NULL
     END FOR
     LET l_k1 = 1
     #START REPORT acor309_rep TO l_name  #FUN-750026 TSD.c123k mark
      FOREACH acor309_curs2 INTO l_coc10,l_coc03 #NO.MOD-490398
       IF SQLCA.sqlcode  THEN
          CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
       END IF
       LET g_cnt = 0
       LET l_k1 = g_number + 1
        FOREACH acor309_cno1 USING l_coc10,l_coc03 INTO sr2.* #NO.MOD-490398
          IF SQLCA.sqlcode  THEN
             CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
          END IF
          LET g_cot[l_k1].cnp03 = sr2.cnp03
          LET g_cot[l_k1].cnp06 = sr2.cnp06
          LET g_cot[l_k1].cnptot = sr2.l_amt
          LET l_k1 = l_k1 + 1
       END FOREACH
       LET g_cnt = l_k1 - 1-g_number   #cob02,cnp06總數
       LET g_no = 1
       LET g_pageno = 0
####g_t=5-((g_cnt+1) mod 5) + (g_cnt+1) 多出的1指的是最后打印的小計
       LET l_i = g_cnt / 5
       IF g_cnt MOD 5 = 0 THEN
          LET g_t = g_cnt
       ELSE
          LET g_t = (l_i + 1) * 5
       END IF
      # FOR l_i = 1 TO g_t STEP 5   #每次5個cob02,cnp06 #FUN-750026 TSD.c123k mark
       FOR l_i = 1 TO g_cnt  #FUN-750026 TSD.c123k modify
           LET g_cnp03=''
           LET g_cob09='' #NO.MOD-490398
           LET g_cnp06=''
           LET g_line = '-------- ---------------- ---------- ----------'
           LET l_space1 = 0
           LET l_space2 = 0
           FOR l_j = 0 TO 4 #組g_cnp03,g_cnp06,g_line
               #NO.MOD-490398--begin
               IF tm.y = 'N' THEN
                  LET g_cnp03=g_cnp03 CLIPPED,' ',l_space1 SPACES,
                              g_cot[l_i+l_j+g_number].cnp03 CLIPPED
               ELSE
                  SELECT cob09 INTO g_cob09 FROM cob_file WHERE cob01=g_cnp03
                  SELECT cob09 INTO g_cot[l_i+l_j+g_number].cob09 FROM cob_file
                   WHERE cob01=g_cot[l_i+l_j+g_number].cnp03
                  LET g_cob09=g_cob09 CLIPPED,' ',l_space1 SPACES,
                              g_cot[l_i+l_j+g_number].cob09[1,15] CLIPPED
               END IF
  #            LET g_cnp03=g_cnp03 CLIPPED,' ',l_space1 SPACES,
  #                        g_cot[l_i+l_j+g_number].cnp03 CLIPPED
               #NO.MOD-490398--end
               LET g_cnp06=g_cnp06 CLIPPED,' ',l_space2 SPACES,
                           g_cot[l_i+l_j+g_number].cnp06 CLIPPED
               LET l_len = 0
               LET l_space1 = 0
               #NO.MOD-490398--begin
               IF tm.y = 'N' THEN
                  LET l_len  = LENGTH(g_cot[l_i+l_j+g_number].cnp03[1,15])
               ELSE
                  LET l_len  = LENGTH(g_cot[l_i+l_j+g_number].cob09[1,15])
               END IF
               #NO.MOD-490398--end
               LET l_space1 = 15 - l_len
               IF l_space1 <> 15 THEN LET l_space3 = l_space1 END IF
               LET l_len1 = LENGTH(g_cot[l_i+l_j+g_number].cnp06[1,4])
               LET l_space2 = 15 - l_len1
               IF l_len1 <>0 OR l_len <>0 THEN
                  LET g_line_1 = g_line_1 CLIPPED,' ---------------'
               END IF
           END FOR
          FOREACH acor309_curs1 USING l_coc10,l_coc03 INTO sr.* #NO.MOD-490398
           IF SQLCA.sqlcode  THEN
              CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
           END IF
           LET g_cnp05 = ''
           LET l_cnp05 = 0
           FOR l_j = 0 TO 4
               #當前cob02,cnp06,cno10,cno06的cnp05
                FOREACH acor309_cno2 USING sr.coc10,sr.coc03,sr.cno07,sr.cno06,#NO.MOD-490398
                       sr.cop05,g_cot[l_i+l_j+g_number].cnp03,
                       g_cot[l_i+l_j+g_number].cnp06
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
           LET sr.g_cnt = g_cnt
           LET sr.cnp05_s = g_cnp05
 #NO.MOD-490398--begin
           IF tm.y = 'N' THEN
              LET sr.cnp03_s = g_cnp03
           ELSE
              LET sr.cnp03_s = g_cob09
           END IF
 #NO.MOD-490398--end
           LET sr.cnp06_s = g_cnp06
           LET sr.line = g_line_1
           #OUTPUT TO REPORT acor309_rep(sr.*)  #FUN-750026 TSD.c123k mark
           LET g_line_1 = NULL   #No.TQC-6A0085
         END FOREACH
 
  
         #FUN-750026 add TSD.c123k
         ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
         LET sr.coc10 = ''     LET sr.coc03 = ''
         LET sr.coc07 = ''     LET sr.cno07 = ''
         LET sr.cno06 = ''     LET sr.cop05 = ''
         LET sr.cop06 = ''    
         FOREACH acor309_curs1 USING l_coc10,l_coc03 INTO sr.*
           IF SQLCA.sqlcode  THEN
              CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
           END IF
         
           LET l_cna02 = ''
           SELECT cna02 INTO l_cna02 FROM cna_file WHERE cna01=sr.coc10
 
           LET sr.cno07 = sr.cno07 USING 'YY/MM/DD'
           
           LET l_cnp05 = ''
           IF g_number = 0 THEN 
              LET g_number = l_i
           ELSE
              LET g_number = g_number + 1
           END IF 
 
           FOREACH acor309_cno2 USING sr.coc10,sr.coc03,sr.cno07,sr.cno06,
                                      sr.cop05,g_cot[g_number].cnp03,
                                      g_cot[g_number].cnp06
                                 INTO l_cnp05
              IF SQLCA.sqlcode  THEN
                 CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
              END IF
 
              IF cl_null(l_cnp05) THEN LET l_cnp05 = 0 END IF
 
              IF tm.y = 'Y' THEN   #HS Code
                 LET g_cob09 = ''
                 LET l_cnp03 = g_cot[g_number].cnp03
 
                 SELECT cob09 INTO g_cob09 FROM cob_file WHERE cob01 = l_cnp03
                 LET l_cnp03 = g_cob09
                 IF cl_null(l_cnp03) THEN LET l_cnp03 = ' ' END IF
              ELSE
                 LET l_cnp03 = g_cot[g_number].cnp03
                 IF cl_null(l_cnp03) THEN LET l_cnp03 = ' ' END IF
              END IF
 
              LET l_cnp06 = g_cot[g_number].cnp06
 
              FOREACH acor309_coe02 USING sr.coc10,sr.coc03 INTO l_coc01
                 IF SQLCA.sqlcode  THEN
                    CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
                 END IF
 
                 LET l_coe05 = 0
                 LET l_coe10 = 0
 
                 SELECT UNIQUE coe05,coe10 INTO l_coe05,l_coe10
                   FROM coe_file,coc_file,cob_file,cnp_file
                  WHERE coc01 = coe01 AND coc01 = l_coc01
                    AND cob01 = coe03 AND cnp03 = g_cot[g_number].cnp03
                    AND cnp03 = coe03
                    AND cnp06 = g_cot[g_number].cnp06
 
                 IF cl_null(l_coe05) THEN LET l_coe05 = 0 END IF
                 IF cl_null(l_coe10) THEN LET l_coe10 = 0 END IF
 
                 LET g_coe05 = g_coe05 + l_coe05
                 LET g_coe10 = g_coe10 + l_coe10
              END FOREACH
 
              IF cl_null(g_coe05) THEN LET g_coe05 = 0 END IF
              IF cl_null(g_coe10) THEN LET g_coe10 = 0 END IF
 
              FOREACH acor309_cnp1 USING sr.coc10,sr.coc03,g_cot[g_number].cnp03,
                                         g_cot[g_number].cnp06
                                    INTO c_cnp05
                 IF SQLCA.sqlcode  THEN
                    CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
                 END IF
              END FOREACH
              IF cl_null(c_cnp05) THEN LET c_cnp05 = 0 END IF
 
              LET l_prepare = g_coe05 + g_coe10
              LET p_cnp05 = l_prepare - c_cnp05
 
              LET t_cnp05 = l_prepare
              IF cl_null(t_cnp05) THEN LET t_cnp05 = 0 END IF
 
              IF NOT cl_null(l_cnp03) THEN
                 EXECUTE insert_prep USING 
                   sr.coc10,  l_cna02,   sr.coc03,   sr.coc07,   sr.cno07,
                   sr.cno06,  sr.cop05,  sr.cop06,   l_cnp03,    l_cnp06,
                   l_cnp05,   t_cnp05,   c_cnp05,    p_cnp05               
              END IF
           END FOREACH
         END FOREACH
         #------------------------------ CR (3) ------------------------------#
         #FUN-750026 end
 
         END FOR
         LET g_number = g_number + g_cnt
     END FOREACH
     #FINISH REPORT acor309_rep  #FUN-750026 TSD.c123k mark
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)  #FUN-750026 TSD.c123k mark
 
     DROP TABLE r309_cnp #No.MOD-490398
 
    # FUN-750026 add
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    LET g_str = ''
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'coc10,coc03,coc04,cno06,cop05,cnp03,coc07')
            RETURNING tm.wc
       LET g_str = tm.wc
    END IF
    LET g_str = g_str,";",tm.a
 
    CALL cl_prt_cs3('acor309','acor309',l_sql,g_str)
    #------------------------------ CR (4) ------------------------------#
    # FUN-750026 end
END FUNCTION
