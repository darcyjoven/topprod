# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: acor311.4gl
# Descriptions...: 出口成品耗用表
# Date & Author..: 03/02/12 By Carrier
# Modify.........: NO.MOD-490398 04/11/23 BY Elva add HS Code,coo12,Customs No.
# Modify.........: NO.MOD-490398 04/12/24 BY Carrier 修改cno10之后的影響
# Modify.........: No.TQC-610082 06/04/19 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-750026 07/07/09 By TSD.Ken報表改寫由Crystal Report產出
# Modify.........: No.TQC-950025 09/06/09 By baofei 解決溢位問題                
# Modify.........: No.TQC-950031 09/06/09 By baofei 在產生table前就先call刪除資>
  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B80045 11/08/04 By Lujh 模組程序撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(600) # Where condition
               y      LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1) # NO.MOD-490398
              a       LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
              b       LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
              more    LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1) # Input more condition(Y/N)
              END RECORD,
          g_wc        LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(600)
          g_line_1    LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(200) #輸入打印報表頭的橫線
          g_cob01     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(200) #報表頭的g_line上的cob01
          g_cob09     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(200) #報表頭的g_line上的cob09 #NO.MOD-490398
          g_col06     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(200) #報表頭的g_line上的col06
          g_col07     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(200) #on every row中的金額數
          g_col10     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(200) #on every row中的金額數
          g_no        LIKE type_file.num5,         #No.FUN-680069 SMALLINT #序號數
          g_t         LIKE type_file.num5,         #No.FUN-680069 SMALLINT #(7-((g_cnt+1) mod 7 ))+g_cnt
          g_cot DYNAMIC ARRAY OF RECORD #cob01,col06組合的矩陣
              cob01   LIKE cob_file.cob01,         #No.FUN-680069 VARCHAR(40)
              cob09   LIKE cob_file.cob09, #NO.MOD-490398
              col06   LIKE col_file.col06,   #NO.MOD-490398
              coltot  LIKE col_file.col10,         #No.FUN-680069 DEC(12,3) #該cob01,col06的sum(col07)
              col10   LIKE col_file.col10          #No.FUN-680069 DEC(12,3)
              END RECORD,
              g_sql   STRING     #No.FUN-580092 HCN        #No.FUN-680069
DEFINE   g_cnt           LIKE type_file.num10      #No.FUN-680069 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680069 SMALLINT
DEFINE l_table      STRING                       ### FUN-750026 add ###
DEFINE l_table1     STRING                       ### FUN-750026 add ###
DEFINE g_str       STRING                       ### FUN-750026 add ###
 
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
#---------------No.TQC-610082 modify
   LET tm.y   = ARG_VAL(8)
   LET tm.a   = ARG_VAL(9)
   LET tm.b   = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#---------------No.TQC-610082 end
#TQC-950031---BEGIN                                                             
   LET g_sql  =    "cob09.cob_file.cob09,",                                     
                   "coo12.coo_file.coo12,",                                     
                   "cna02.cna_file.cna02,",                                     
                   "coo18.coo_file.coo18,",                                     
                   "col04.col_file.col04,",                                     
                   "cob02.cob_file.cob02,",                                     
                   "cob021.cob_file.cob021,",                                   
                   "cnp06.cnp_file.cnp06,",                                     
                   "np05count.cnp_file.cnp05,",                                 
                   "ol10count.col_file.col10,",                                 
                   "count.col_file.col10"                                       
                                                                                
   LET l_table1 = cl_prt_temptable('acor311',g_sql) CLIPPED                     
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
   LET g_sql  =           "cob09.cob_file.cob09,",                              
                          "coo12.coo_file.coo12,",                              
                          "cna02.cna_file.cna02,",                              
                          "coo18.coo_file.coo18,",                              
                          "coo11.coo_file.coo11,",                              
                          "cob02.cob_file.cob02,",                              
                          "cob021.cob_file.cob021,",                            
                          "oo14count.coo_file.coo14,",                          
                          "l_no.type_file.num5,",                               
                          "cob01_s.type_file.chr1000,",                         
                          "col06_s.type_file.chr1000,",                         
                          "col07_s.type_file.chr1000,",                         
                          "col10_s.type_file.chr1000,",                         
                          "line.type_file.chr1000,",                            
                          "g_cnt.type_file.num5,",                              
                          "g_t.type_file.num5,",                                
                          "A.type_file.chr1000,",                               
                          "B.type_file.chr1000,",                               
                          "C.type_file.num20_6,",                               
                          "D.type_file.num20_6,",                               
                          "g_seq.type_file.num5,",                              
                          "g_seq1.type_file.num5"  
   LET l_table = cl_prt_temptable('acor311',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF                                     
#TQC-950031---END   
   IF cl_null(g_bgjob) or g_bgjob = 'N'
      THEN CALL acor311_tm(0,0)
      ELSE CALL acor311()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION acor311_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680069 SMALLINT
         l_cmd        LIKE type_file.chr1000        #No.FUN-680069 VARCHAR(400)
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW acor311_w AT p_row,p_col WITH FORM "aco/42f/acor311"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
    LET tm.y = 'N'    #NO.MOD-490398
   LET tm.a = '0'
   LET tm.b = '1'
   LET tm.more= 'N'
   LET g_pdate= g_today
   LET g_rlang= g_lang
   LET g_bgjob= 'N'
   LET g_copies= '1'
 
 WHILE TRUE
    #CONSTRUCT BY NAME tm.wc ON cno11,cno10,cnp03  #No.MOD-490398
    CONSTRUCT BY NAME tm.wc ON cno10,cnp03  #No.MOD-490398
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
 LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('cnouser', 'cnogrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW acor311_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
    INPUT BY NAME tm.y,tm.b,tm.a,tm.more WITHOUT DEFAULTS  #NO.MOD-490398
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD b
        IF cl_null(tm.b) OR tm.b NOT MATCHES '[12]' THEN
           NEXT FIELD b
        END IF
        IF tm.b = '1' THEN
           LET tm.a = '0' DISPLAY BY NAME tm.a NEXT FIELD more
        END IF
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
      LET INT_FLAG = 0 CLOSE WINDOW acor311_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='acor311'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('acor311','9031',1)
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
                         " '",tm.y     CLIPPED,"'",        #No.TQC-610082 add
                         " '",tm.a     CLIPPED,"'",
                         " '",tm.b     CLIPPED,"'",
                        #" '",tm.more  CLIPPED,"'",        #No.TQC-610082 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
         CALL cl_cmdat('acor311',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW acor311_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL acor311()
   ERROR ""
END WHILE
   CLOSE WINDOW acor311_w
END FUNCTION
 
FUNCTION acor311()
   DEFINE l_name           LIKE type_file.chr20,        #No.FUN-680069 VARCHAR(50) # External(Disk) file name
          l_name1          LIKE type_file.chr20,        #No.FUN-680069 VARCHAR(50)
#       l_time          LIKE type_file.chr8               #No.FUN-6A0063
          l_sql            LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(1200)
          l_za05           LIKE za_file.za05,           # NO.MOD-490398
          l_temp           LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(40)
          l_coo12          LIKE coo_file.coo12,         #NO.MOD-490398
          l_coo18          LIKE coo_file.coo18,
          l_i              LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_k              LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_k1             LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_len            LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_len1           LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_space1         LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_space2         LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_space3         LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_j              LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_report         LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_cnp051,l_cnp052 LIKE cnp_file.cnp05,
          l_col07          LIKE col_file.col07,
          l_col10          LIKE col_file.col10,
          l_total          LIKE col_file.col07,
          l_cmd,l_cmd1,l_cmd2  LIKE type_file.chr1000,  #No.FUN-680069 VARCHAR(400)
          l_cno01          LIKE cno_file.cno01,
          l_ol10count      LIKE col_file.col10,         #No.FUN-680069 DEC(13,3)
          l_serial         LIKE type_file.num5,
          sr2              RECORD
                           cob01  LIKE cob_file.cob01,
                           col06  LIKE col_file.col06,
                           l_amt  LIKE col_file.col07,
                           col10  LIKE col_file.col10
                           END RECORD,
          sra              RECORD       #repa
                            cob09       LIKE cob_file.cob09, #NO.FUN-0026##
                            cno20       LIKE cno_file.cno20, #NO.MOD-490398
                            cna02       LIKE cna_file.cna02,        #NO.FUN-750026
                           #cno11       LIKE cno_file.cno11, #No.MOD-490398
                            cno10       LIKE cno_file.cno10, #No.MOD-490398
                            cnp03       LIKE cnp_file.cnp03,
                            cob02       LIKE cob_file.cob02,
                            cob021      LIKE cob_file.cob021,
                            cnp06       LIKE cnp_file.cnp06,
                            np05count   LIKE cnp_file.cnp05, #No.FUN-680069 DEC(12,3)
                            ol10count   LIKE col_file.col10, #No.FUN-680069 DEC(13,3)
                            count       LIKE col_file.col10  #No.FUN-680069 DEC(13,3)
                            END RECORD,
          sr               RECORD
                           cob09       LIKE cob_file.cob09, #NO.FUN-0026##
                           coo12       LIKE coo_file.coo12,        #NO.MOD-490398
                           cna02       LIKE cna_file.cna02,        #NO.FUN-750026
                           coo18       LIKE coo_file.coo18,
                           coo11       LIKE coo_file.coo11,
                           cob02       LIKE cob_file.cob02,
                           cob021      LIKE cob_file.cob021,
                           oo14count   LIKE coo_file.coo14,
                           l_no        LIKE type_file.num5,         #No.FUN-680069 SMALLINT
                           cob01_s     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(200)
                           col06_s     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(200)
                           col07_s     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(200)
                           col10_s     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(200)
                           line        LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(200)
                           g_cnt       LIKE type_file.num5,         #No.FUN-680069 SMALLINT
                           g_t         LIKE type_file.num5          #No.FUN-680069 SMALLINT
                           END RECORD
  DEFINE lst_token     base.StringTokenizer
  DEFINE ls_token LIKE     type_file.chr1000,
         ls_token_num LIKE type_file.num20_6,
         A        LIKE     type_file.chr1000,
         B        LIKE     type_file.chr1000, 
         C        LIKE     type_file.num20_6,
         D        LIKE     type_file.num20_6
 
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-750026 *** ##
   CALL cl_del_data(l_table)
   CALL cl_del_data(l_table1)
   #------------------------------ CR (2) ------------------------------#
   #end FUN-750026  add
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-750026 add ###
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'acor311'
     LET g_wc = tm.wc
#TQC-950025---BEGEIN                                                            
#     FOR l_i = 1 TO 596                                                        
#      #No.MOD-490398  --begin                                                  
#         IF g_wc[l_i,l_i+4] = 'cno10' THEN LET g_wc[l_i,l_i+4] = 'coo18' END IF
#         IF g_wc[l_i,l_i+4] = 'cnp03' THEN LET g_wc[l_i,l_i+4] = 'coo11' END IF
#     END FOR                                                                   
    LET g_wc=cl_replace_str(g_wc,"cno10","coo18")                               
    LET g_wc=cl_replace_str(g_wc,"cnp03","coo11")                               
#TQC-950025---END   
     CASE
         WHEN tm.a = '0' LET l_temp = "coo10 IN ('0','1','2','3','5','6','7') "
         WHEN tm.a = '1' LET l_temp = "coo10 = '1'"
         WHEN tm.a = '2' LET l_temp = "coo10 = '2'"
         WHEN tm.a = '3' LET l_temp = "coo10 = '4'"
         OTHERWISE
     END CASE
      #No.MOD-490398  --end
#####sra丟到reporta
     IF tm.b = '1' THEN  #統計
#TQC-950031---BEGIN
#   LET g_sql  =    "cob09.cob_file.cob09,",
#                   "coo12.coo_file.coo12,", 
#                   "cna02.cna_file.cna02,",       
#                   "coo18.coo_file.coo18,",
#                   "col04.col_file.col04,",
#                   "cob02.cob_file.cob02,",
#                   "cob021.cob_file.cob021,",
#                   "cnp06.cnp_file.cnp06,",
#                   "np05count.cnp_file.cnp05,",
#                   "ol10count.col_file.col10,",
#                   "count.col_file.col10"
 
#   LET l_table1 = cl_prt_temptable('acor311',g_sql) CLIPPED   # 產生Temp Table
#   IF l_table1 = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
#TQC-950031---END
#   LET g_sql = "INSERT INTO ds_report.",l_table1 CLIPPED,   #TQC-950031        
  LET g_sql =  "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED, #TQC-950031
              " VALUES(?,?,?,?,?,",
              "        ?,?,?,?,?,",
              "        ?)"
 
  PREPARE insert_prep1 FROM g_sql
  IF STATUS THEN
     CALL cl_err('insert_prep1:',status,1)
     CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80045   ADD
     EXIT PROGRAM
  END IF
  #------------------------------ CR (1) ------------------------------#
      #No.MOD-490398  --begin
         LET l_sql = " SELECT UNIQUE '',cno20,'',cno10,cnp03,cob02,cob021,cnp06,",#NO.MOD-490398
                    "        SUM(cnp05),0,0 ",
                    "   FROM cob_file,cnp_file,cno_file ",
                    "  WHERE cno01 = cnp01 ",
                    "    AND cob01 = cnp03 ",
                    "    AND cno03 = '1' AND cno031 = '1' ",
                    "    AND cno04 IN ('1','2','4') ", #No.MOD-490398
                    "    AND cnoconf = 'Y' AND cnoacti = 'Y' ",
                    "    AND ",tm.wc CLIPPED,
                    "  GROUP BY cno20,cno10,cnp03,cob02,cob021,cnp06 ", #NO.MOD-490398
                    "  ORDER BY cno20,cno10,cnp03,cob02,cnp06 " #NO.MOD-490398
        PREPARE acor311_prepare1 FROM l_sql
        IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
           EXIT PROGRAM 
        END IF
        DECLARE acor311_curs1 CURSOR FOR acor311_prepare1
 
        LET l_sql = " SELECT cno01,SUM(cnp05) ",
                    "   FROM cno_file,cnp_file,cob_file ",
                    "  WHERE cno01 = cnp01 ",
                    "    AND cob01 = cnp03 ",
                    "    AND cno03 = '1' ",
                    "    AND cno031 IN ('1','3') ",
                    "    AND cno04 IN ('1','2','4') ",
                    "    AND cnoconf = 'Y' AND cnoacti = 'Y' ",
                     "    AND cno20 = ? AND cno10 = ? AND cnp03 = ? ",#NO.MOD-490398
                    "  GROUP BY cno01"
        PREPARE acor311_prepare2 FROM l_sql
        IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
           EXIT PROGRAM 
        END IF
        DECLARE acor311_curs2 CURSOR FOR acor311_prepare2
      #No.MOD-490398  --end
     ELSE
####取出手冊編號
   #str FUN-750026 add
#TQC-950031---BEGIN  
#   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> FUN-750026 *** ##
#   LET g_sql  =           "cob09.cob_file.cob09,",
#                          "coo12.coo_file.coo12,",
#                          "cna02.cna_file.cna02,",       
#                          "coo18.coo_file.coo18,",
#                          "coo11.coo_file.coo11,",
#                          "cob02.cob_file.cob02,",
#                          "cob021.cob_file.cob021,",
#                          "oo14count.coo_file.coo14,",
#                          "l_no.type_file.num5,",         
#                          "cob01_s.type_file.chr1000,",  
#                          "col06_s.type_file.chr1000,",  
#                          "col07_s.type_file.chr1000,",  
#                          "col10_s.type_file.chr1000,",  
#                          "line.type_file.chr1000,",    
#                          "g_cnt.type_file.num5,",      
#                          "g_t.type_file.num5,",
#                          "A.type_file.chr1000,",
#                          "B.type_file.chr1000,",
#                          "C.type_file.num20_6,",
#                          "D.type_file.num20_6,",
#                          "g_seq.type_file.num5,",
#                          "g_seq1.type_file.num5"
 
#   LET l_table = cl_prt_temptable('acor311',g_sql) CLIPPED   # 產生Temp Table
#   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
#TQC-950031---END 
#   LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,  #TQC-950031          
   LET g_sql =  "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-950031
 
              "  VALUES (?,?,?,?,?,",
                        "?,?,?,?,?,",
                        "?,?,?,?,?,",
                        "?,?,?,?,?,?,?)"
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80045   ADD
      EXIT PROGRAM
   END IF
   
   DROP TABLE r311_tmp
   CREATE TEMP TABLE r311_tmp
              (serial LIKE type_file.num5,
               A LIKE type_file.chr1000,
               B LIKE type_file.chr1000,
               C LIKE type_file.chr1000,
               D LIKE type_file.chr1000)
 
         LET l_sql = " SELECT UNIQUE coo12,coo18 ", #NO.MOD-490398
                    "   FROM col_file,coo_file,cob_file ",
                    "  WHERE col01 = coo01 AND col02 = coo02 ",
                    "    AND cob01 = coo11 ",
                    "    AND cooconf = 'Y' AND cooacti = 'Y' ",
                    "    AND coo20 = 'Y' ",
                    "    AND ",g_wc CLIPPED,
                    "    AND ",l_temp CLIPPED,
                     "  ORDER BY coo12,coo18"   #NO.MOD-490398
        PREPARE acor311_prepare6 FROM l_sql
        IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
           EXIT PROGRAM 
        END IF
        DECLARE acor311_curs5 CURSOR FOR acor311_prepare6
        ####取出該手冊編號下的sr
         LET l_sql = " SELECT UNIQUE '',coo12,'',coo18,coo11,cob02,cob021,0,", #NO.MOD-490398 #NO.FUN-750026 
                    "               0,'','','','','',0,0 ",
                    "   FROM col_file,coo_file,cob_file ",
                    "  WHERE col01 = coo01 AND col02 = coo02 ",
                    "    AND cob01 = coo11 ",
                    "    AND cooconf = 'Y' AND cooacti = 'Y' ",
                    "    AND coo20 = 'Y' ",
                     "    AND coo12 = ? AND coo18 = ?  ",  #NO.MOD-490398
                    "    AND ",g_wc CLIPPED,
                    "    AND ",l_temp CLIPPED,
                     "  GROUP BY coo12,coo18,coo11,cob02,cob021 ",  #NO.MOD-490398
                     "  ORDER BY coo12,coo18,coo11 "   #NO.MOD-490398
        PREPARE acor311_prepare3 FROM l_sql
        IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
           EXIT PROGRAM 
        END IF
        DECLARE acor311_curs3 CURSOR FOR acor311_prepare3
 
        LET l_sql = " SELECT SUM(coo14)",
                    "   FROM coo_file,cob_file ",
                    "  WHERE cob01 = coo11 ",
                    "    AND cooconf = 'Y' AND cooacti = 'Y' ",
                    "    AND coo20 = 'Y' ",
                     "    AND coo12 = ? AND coo18 = ? AND coo11 = ? ", #NO.MOD-490398
                    "    AND ",g_wc CLIPPED,
                    "    AND ",l_temp CLIPPED
        PREPARE acor311_prepare7 FROM l_sql
        IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
           EXIT PROGRAM 
        END IF
        DECLARE acor311_curs4 CURSOR FOR acor311_prepare7
        #####cob01,col06丟到g_cnp矩陣中
        LET l_sql = "SELECT unique cob01,col06,SUM(col07),SUM(col10) ",
                    "  FROM col_file,coo_file,cob_file ",
                    " WHERE col01 = coo01 AND col02 = coo02 ",
                    "   AND cooconf = 'Y' AND cooacti = 'Y' ",
                    "   AND coo20 = 'Y' ",
                    "   AND cob01 = col04 ",
                     "   AND coo12 = ? AND coo18 = ? ",  #NO.MOD-490398
                    "   AND ",l_temp CLIPPED,
                    "   AND ",g_wc CLIPPED,
                    "  GROUP BY cob01,col06 ",
                    "  ORDER BY cob01,col06 "
        PREPARE acor311_prepare4 FROM l_sql
        IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
           EXIT PROGRAM 
        END IF
        DECLARE acor311_cno1 CURSOR FOR acor311_prepare4
 
        #####sum(col07)丟至sr中,表示為當前cob01,col06的col07
        LET l_sql = "SELECT SUM(col07),SUM(col10) ",
                    "  FROM col_file,coo_file,cob_file ",
                    " WHERE col01 = coo01 AND col02 = coo02 ",
                    "   AND cooconf = 'Y' AND cooacti = 'Y' ",
                    "   AND coo20 = 'Y' ",
                    "   AND cob01 = col04 ",
                     "   AND coo12 = ? AND coo18 = ? AND coo11 = ? ",#NO.MOD-490398
                    "   AND ",l_temp CLIPPED,
                    "   AND cob01 = ? ",
                    "   AND col06 = ? ",
                    "   AND ",g_wc CLIPPED
        PREPARE acor311_prepare5 FROM l_sql
        IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
           EXIT PROGRAM 
        END IF
        DECLARE acor311_cno2 CURSOR FOR acor311_prepare5
     END IF
 
     LET g_len=219
     IF tm.b = '1' THEN
         LET g_len = 152 #NO.MOD-490398
     ELSE LET g_len = 219 END IF
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     IF tm.b = '1' THEN
        FOREACH acor311_curs1 INTO sra.*
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
            END IF
            #FUN-750026 ADD
            SELECT cna02 INTO sra.cna02 FROM cna_file
            WHERE cna01=sra.cno20
            IF SQLCA.sqlcode THEN
               LET sra.cna02 = ' '
            END IF
            #FUN-750026 END
            IF cl_null(sra.np05count) THEN LET sra.np05count = 0 END IF
            LET l_ol10count=0
             #FOREACH acor311_curs2 USING sra.cno20,sra.cno11,sra.cnp03 #No.MOD-490398
             FOREACH acor311_curs2 USING sra.cno20,sra.cno10,sra.cnp03 #No.MOD-490398
                    INTO l_cno01,sra.ol10count
               IF SQLCA.sqlcode != 0 THEN
                  CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
               END IF
               LET l_ol10count= l_ol10count + sra.ol10count
            END FOREACH
            LET sra.ol10count = l_ol10count
            IF cl_null(sra.ol10count) THEN LET sra.ol10count = 0 END IF
 
            SELECT SUM(cnp05) INTO l_cnp051 FROM cnp_file,cno_file
             WHERE cno01 = cnp01 AND cnp03 = sra.cnp03
               AND cno03 = '2' AND cno031 = '1' AND cno04 = '3'
                #AND cno11 = sra.cno11 #No.MOD-490398
                AND cno10 = sra.cno10 #No.MOD-490398
               AND cnoconf = 'Y' AND cnoacti = 'Y'
            IF cl_null(l_cnp051) THEN LET l_cnp051 = 0 END IF
 
            SELECT SUM(cnp05) INTO l_cnp052 FROM cnp_file,cno_file
             WHERE cno01 = cnp01 AND cnp03 = sra.cnp03
               AND cno03 = '2' AND cno031 = '2' AND cno04 = '3'
                #AND cno11 = sra.cno11 #No.MOD-490398
                AND cno10 = sra.cno10 #No.MOD-490398
               AND cnoconf = 'Y' AND cnoacti = 'Y'
            IF cl_null(l_cnp052) THEN LET l_cnp052 = 0 END IF
 
            LET sra.np05count = sra.np05count - l_cnp051
            LET sra.ol10count = sra.ol10count - l_cnp052
            LET sra.count = sra.np05count - sra.ol10count
            IF cl_null(sra.count) THEN LET sra.count = 0 END IF
            IF tm.y = 'N' THEN
               LET sra.cob09 = sra.cnp03 CLIPPED
            ELSE
               SELECT cob09 INTO sra.cob09 FROM cob_file WHERE cob01=sra.cnp03
            END IF
 
            EXECUTE insert_prep1 USING sra.cob09,
                                       sra.cno20,
                                       sra.cna02,
                                       sra.cno10,
                                       sra.cnp03,
                                       sra.cob02,
                                       sra.cob021,
                                       sra.cnp06,
                                       sra.np05count,
                                       sra.ol10count,
                                       sra.count     
            IF STATUS THEN CALL cl_err('',STATUS,1)
               CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80045   ADD
               EXIT PROGRAM
            END IF                                       
        END FOREACH
        #str FUN-750026 add
        ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-750026 **** ##
        LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
        #是否列印選擇條件
        IF g_zz05 = 'Y' THEN
           CALL cl_wcchp(tm.wc,'cno10,cnp03')
                RETURNING tm.wc
           LET g_str = tm.wc
        END IF
        LET g_str = g_str,";",tm.b
        CALL cl_prt_cs3('acor311','acor311_1',l_sql,g_str)
        #------------------------------ CR (4) ------------------------------#
     ELSE
        DELETE FROM r311_tmp   #FUN-750026
        LET g_pageno = 0
         FOREACH acor311_curs5 INTO l_coo12,l_coo18  #NO.MOD-490398
          IF SQLCA.sqlcode  THEN
             CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
          END IF
          FOR l_k = 1 TO 60
              INITIALIZE g_cot[l_k] TO NULL
          END FOR
          LET l_k1 = 1
          LET g_cnt = 0
          LET g_t = 0
           FOREACH acor311_cno1 USING l_coo12,l_coo18 INTO sr2.* #NO.MOD-490398
            IF SQLCA.sqlcode  THEN
               CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
            END IF
            LET g_cot[l_k1].cob01 = sr2.cob01
            LET g_cot[l_k1].col06 = sr2.col06
            LET g_cot[l_k1].coltot = sr2.l_amt
            LET g_cot[l_k1].col10 = sr2.l_amt
            LET l_k1 = l_k1 + 1
           END FOREACH
          LET g_cnt = l_k1 - 1   #cob01,col06總數
          LET g_no = 1
          ####g_t=6-((g_cnt+1) mod 6) + (g_cnt+1) 多出的1指的是最后打印的小計
          LET l_i = (g_cnt + 1)/ 6
          IF (g_cnt+ 1) MOD 6 = 0 THEN
             LET g_t = g_cnt + 1
          ELSE
             LET g_t = (l_i + 1) * 6
          END IF
          FOR l_i = 1 TO g_t STEP 6   #每次5個cob01,col06
              LET g_cob01=''
               LET g_cob09='' #NO.MOD-490398
              LET g_col06=''
              LET g_line_1 = '-------------------------- ---------------------------------------- ---------------------------------------- --------------'
              LET l_space1 = 0
              LET l_space2 = 0
              FOR l_j = 0 TO 5 #組g_cob01,g_col06,g_line
 #NO.MOD-490398--begin
       IF tm.y = 'N' THEN
                  LET g_cob01=g_cob01 CLIPPED,' ',l_space1 SPACES,
                              g_cot[l_i+l_j].cob01 CLIPPED
       ELSE
          SELECT cob09 INTO g_cob09 FROM cob_file WHERE cob01=g_cob01
          SELECT cob09 INTO g_cot[l_i+l_j].cob09 FROM cob_file WHERE cob01=g_cot[l_i+l_j].cob01
                  LET g_cob09=g_cob09 CLIPPED,' ',l_space1 SPACES,
                              g_cot[l_i+l_j].cob09[1,15] CLIPPED
       END IF
       #          LET g_cob01=g_cob01 CLIPPED,' ',l_space1 SPACES,
       #                      g_cot[l_i+l_j].cob01 CLIPPED
 #NO.MOD-490398--end
                  LET g_col06=g_col06 CLIPPED,' ',l_space2 SPACES,
                              g_cot[l_i+l_j].col06 CLIPPED
                  LET l_len = 0
                  LET l_space1 = 0
 #NO.MOD-490398--begin
       IF tm.y = 'N' THEN
                  LET l_len  = LENGTH(g_cot[l_i+l_j].cob01[1,15])
       ELSE
                  LET l_len  = LENGTH(g_cot[l_i+l_j].cob09[1,15])
       END IF
 #NO.MOD-490398--end
                  LET l_space1 = 15 - l_len
                  IF l_space1 <> 15 THEN LET l_space3 = l_space1 END IF
                  LET l_len1 = LENGTH(g_cot[l_i+l_j].col06[1,4])
                  LET l_space2 = 15 - l_len1
                  IF l_len1 <>0 OR l_len <>0 THEN
                     LET g_line_1 = g_line_1 CLIPPED,' ---------------'
                  END IF
              END FOR
               FOREACH acor311_curs3 USING l_coo12,l_coo18 INTO sr.* #NO.MOD-490398
                  IF SQLCA.sqlcode  THEN
                     CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
                  END IF
                  FOREACH acor311_curs4 USING sr.coo12,sr.coo18,sr.coo11 #NO.MOD-490398
                          INTO sr.oo14count
                     IF SQLCA.sqlcode  THEN
                        CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
                     END IF
                  END FOREACH
                  #FUN-750026 ADD
                  SELECT cna02 INTO sr.cna02 FROM cna_file
                  WHERE cna01=sr.coo12
                  IF SQLCA.sqlcode THEN
                     LET sr.cna02 = ' '
                  END IF
                  #FUN-750026 END
                  IF cl_null(sr.oo14count) THEN LET sr.oo14count = 0 END IF
                  LET g_col07 = ''
                  LET l_col07 = 0
                  LET g_col10 = ''
                  LET l_col10 = 0
                  FOR l_j = 0 TO 5
                      #當前cob01,col06,cno10,cno06的col07
                       FOREACH acor311_cno2 USING sr.coo12,sr.coo18,sr.coo11,#NO.MOD-490398
                              g_cot[l_i+l_j].cob01,g_cot[l_i+l_j].col06
                              INTO l_col07,l_col10
                         IF SQLCA.sqlcode  THEN
                            CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
                         END IF
                      END FOREACH
                      LET l_col07 = l_col10 / sr.oo14count
                      IF cl_null(l_col07) THEN LET l_col07 = 0 END IF
                      IF cl_null(l_col10) THEN LET l_col10 = 0 END IF
                      #不打多余的0
                      IF l_i + l_j <= g_cnt THEN
                         LET g_col07 = g_col07 CLIPPED,
                                       l_col07 USING " ---,---,--&.&&&"
                         LET g_col10 = g_col10 CLIPPED,
                                       l_col10 USING " ---,---,--&.&&&"
                      END IF
                  END FOR
                  LET sr.g_cnt = g_cnt
                  LET sr.g_t = g_t
                  LET sr.l_no = l_i
                  LET sr.col07_s = g_col07
                  LET sr.col10_s = g_col10
 #NO.MOD-490398--begin
            IF tm.y = 'N' THEN
                  LET sr.cob01_s = g_cob01
            ELSE
                  LET sr.cob01_s = g_cob09
            END IF
 #NO.MOD-490398--end
                  LET sr.col06_s = g_col06
                  LET sr.line = g_line_1
                  IF tm.y = 'N' THEN
                     LET sr.cob09 = sr.coo11 CLIPPED
                  ELSE
                     SELECT cob09 INTO sr.cob09 FROM cob_file 
                      WHERE cob01 = sr.coo11
                  END IF
                
              ## *** 與 Crystal Reports  FUN-750026 *** ## 
              #拆解字串，insert到temp table，ex：A B 10 11 insert 到r311_tmp
 
                  LET l_serial = 1
                  LET lst_token = base.StringTokenizer.create(sr.cob01_s, ' ')
                  WHILE lst_token.hasMoreTokens()
                     LET ls_token = lst_token.nextToken()
                     INSERT INTO r311_tmp VALUES (l_serial,ls_token,' ',' ',' ')
                     LET l_serial = l_serial + 1
                  END WHILE
 
                  LET l_serial = 1
                  LET lst_token = base.StringTokenizer.create(sr.col06_s, ' ')
                  WHILE lst_token.hasMoreTokens()
                     LET ls_token = lst_token.nextToken()
                     UPDATE r311_tmp SET B = ls_token
                      WHERE serial = l_serial
                     LET l_serial = l_serial + 1
                  END WHILE
 
                  LET l_serial = 1
                  LET lst_token = base.StringTokenizer.create(sr.col07_s, ' ')
                  WHILE lst_token.hasMoreTokens()
                     LET ls_token_num = lst_token.nextToken()
                     LET ls_token = ls_token_num USING "---,--&.&&&"
                     UPDATE r311_tmp SET C = ls_token
                      WHERE serial = l_serial
                     LET l_serial = l_serial + 1
                  END WHILE
 
                  LET l_serial = 1
                  LET lst_token = base.StringTokenizer.create(sr.col10_s, ' ')
                  WHILE lst_token.hasMoreTokens()
                     LET ls_token_num = lst_token.nextToken()
                     LET ls_token = ls_token_num USING "---,--&.&&&"
                     UPDATE r311_tmp SET D = ls_token
                      WHERE serial = l_serial
                     LET l_serial = l_serial + 1
                  END WHILE
                  LET l_sql = "SELECT A,B,C,D FROM r311_tmp Order By serial"
                  LET l_serial = 1
                  DECLARE r311_tmp_cs CURSOR FROM l_sql
                  FOREACH r311_tmp_cs INTO A,B,C,D,l_serial
                    EXECUTE insert_prep USING sr.cob09, sr.coo12, sr.cna02,
                                              sr.coo18, sr.coo11, sr.cob02,
                                              sr.cob021, sr.oo14count, sr.l_no,
                                              sr.cob01_s, sr.col06_s, sr.col07_s,
                                              sr.col10_s, sr.line, sr.g_cnt,
                                              sr.g_t,A,B,C,D,l_serial,l_serial
                    IF STATUS THEN CALL cl_err('',STATUS,1)
                       CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80045   ADD
                       EXIT PROGRAM
                    END IF                                       
                    LET l_serial = l_serial + 1
                  END FOREACH
                  DELETE FROM r311_tmp
              END FOREACH
          END FOR
         END FOREACH
         #str FUN-750026 add
         ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-750026 **** ##
         LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," Order by g_seq"
         #是否列印選擇條件
         IF g_zz05 = 'Y' THEN
            CALL cl_wcchp(tm.wc,'cno10,cnp03')
                 RETURNING tm.wc
            LET g_str = tm.wc
         END IF
         LET g_str = g_str,";",tm.b
         CALL cl_prt_cs3('acor311','acor311',l_sql,g_str)
         #------------------------------ CR (4) ------------------------------#
     END IF
END FUNCTION
 
