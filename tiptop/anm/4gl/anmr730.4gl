# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: anmr730.4gl
# Descriptions...: 金融機構授信明細表
# Input parameter:
# Return code....:
# Date & Author..: 98/10/29 BY Billy
# Modify.........: No.7354 03/10/28 By Kitty 配合改為小數4位
# Modify.........: No.8687 03/11/12 By Kitty 格式調整,加show單頭核准金額及幣別
# Modify.........: No.FUN-4C0098 05/02/02 By pengu 報表轉XML
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.MOD-7A0021 07/10/08 By Smapmin 合計金額會double
# Modify.........: No.FUN-7A0036 07/11/22 By baofei  報表輸出至Crystal Reports功能
# Modify.........: No.FUN-7B0143 07/12/03 By baofei  修改資料打印不出來 
# Modify.........: No.CHI-7C0007 07/12/06 By jamie 總計金額會重覆加
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80067 11/08/05 By fengrui  程式撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
            #   wc      VARCHAR(600),
                wc      STRING,                    #TQC-630166
                s       LIKE type_file.chr3,       #No.FUN-680107 VARCHAR(3)
                t       LIKE type_file.chr3,       #No.FUN-680107 VARCHAR(3)
                u       LIKE type_file.chr3,       #No.FUN-680107 VARCHAR(3)
                wdate   LIKE type_file.dat,        #No.FUN-680107 VARCHAR(5)
                void    LIKE type_file.chr1,       #No.FUN-680107 VARCHAR(1)
                more    LIKE type_file.chr1        #No.FUN-680107 VARCHAR(1)
              END RECORD,
          l_orderA      ARRAY[3] OF LIKE zaa_file.zaa08, #No.FUN-680107 ARRAY[3] OF VARCHAR(8)
          g_tot_bal     LIKE type_file.num20_6,    #No.FUN-680107 DEC(13,2)
          t_alg021      LIKE alg_file.alg021
 
   DEFINE g_i           LIKE type_file.num5        #count/index for any purpose  #No.FUN-680107 SMALLINT
   DEFINE g_head1       STRING
#No.FUN-7A0036---Begin                                                                                                              
DEFINE l_table        STRING,                                                                                                       
       l_table1       STRING,                                                                                                       
       g_str          STRING,                                                                                                       
       g_sql          STRING,                                                                                                       
       l_sql          STRING                                                                                                        
#No.FUN-7A0036---End  
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
#No.FUN-7A0036---Begin                                                                                                              
   LET g_sql = "alg021.alg_file.alg021,",                                                                                           
               "nnn01.nnn_file.nnn01,",                                                                                             
               "nnn02.nnn_file.nnn02,",                                                                                             
               "nno01.nno_file.nno01,",                                                                                             
               "nno02.nno_file.nno02,",                                                                                             
               "nno03.nno_file.nno03,",                                                                                             
               "nno04.nno_file.nno04,",                                                                                             
               "nno05.nno_file.nno05,",                                                                                             
               "nno06.nno_file.nno06,",                                                                                             
               "nno08.nno_file.nno08,",                                                                                             
               "nno09.nno_file.nno09,",                                                                                             
               "nnp01.nnp_file.nnp01,",                                                                                             
               "nnp02.nnp_file.nnp02,",                                                                                             
               "nnp03.nnp_file.nnp03,",                                                                                             
               "nnp05.nnp_file.nnp05,",                                                                                             
               "nnp06.nnp_file.nnp06,",                                                                                             
               "nnp07.nnp_file.nnp07,",                                                                                             
               "nnp09.nnp_file.nnp09,",                                                                                             
               "t_azi03.azi_file.azi03,",                                                                                           
               "l_azi04.azi_file.azi04,",                                                                                           
               "t_azi04.azi_file.azi04,",                                                                                           
               "t_azi05.azi_file.azi05,",     
               "l_azi07.azi_file.azi07,",                                                                                           
               "t_azi07.azi_file.azi07"                                                                                             
   LET l_table = cl_prt_temptable('anmr730',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "nnq01.nnq_file.nnq01,",                                                                                             
               "nnq02.nnq_file.nnq02,",                                                                                             
               "nnq03.nnq_file.nnq03,",                                                                                             
               "nnq04.nnq_file.nnq04,",                                                                                             
               "nnq05.nnq_file.nnq05"                                                                                               
   LET l_table1 = cl_prt_temptable('anmr7301',g_sql) CLIPPED                                                                        
   IF l_table1 = -1 THEN EXIT PROGRAM END IF                                                                                        
#No.FUN-7A0036---End  
 
   LET t_alg021= ' '
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   LET tm.wdate= ARG_VAL(11)
   LET tm.void = ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   #no.5195
#   DROP TABLE curr_tmp       #No.FUN-7A0036
#No.FUN-680107 --start 欄位類型修改
#  CREATE TEMP TABLE curr_tmp
# Prog. Version..: '5.30.06-13.03.12(04),                    #幣別
#    amt   DEC(20,6),                   #金額
#    order1  VARCHAR(20),
#    order2  VARCHAR(20),
#    order3  VARCHAR(20)
#   );
#No.FUN-7A0036---Begin
{   
   CREATE TEMP TABLE curr_tmp(
    curr LIKE azi_file.azi01,
     amt LIKE type_file.num20_6,
     order1 LIKE nno_file.nno01,
     order2 LIKE nno_file.nno01,
     order3 LIKE nno_file.nno01);
#No.FUN-680107 --end
   #no.5195(end)
}
#No.FUN-7A0036---End
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL anmr730_tm(0,0)
      ELSE CALL anmr730()
   END IF
   DROP TABLE r730_tmp
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr730_tm(p_row,p_col)
DEFINE lc_qbe_sn     LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col   LIKE type_file.num5,    #No.FUN-680107 SMALLINT
       l_cmd         LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(400)
       l_jmp_flag    LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 16
   ELSE LET p_row = 5 LET p_col = 14
   END IF
   OPEN WINDOW anmr730_w AT p_row,p_col
        WITH FORM "anm/42f/anmr730"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.wdate=g_today
   LET tm.void = 'N'
   LET tm.s    = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET l_jmp_flag = 'N'
 #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   LET tm2.u3   = tm.u[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nno02,nno01,nno03,nno04
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr730_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.wdate,tm.void,
                 tm2.s1,tm2.s2,tm2.s3,
                 tm2.t1,tm2.t2,tm2.t3,
                 tm2.u1,tm2.u2,tm2.u3,
                 tm.more
                 WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
     #AFTER FIELD wdate
     #   IF cl_null(tm.wdate) THEN NEXT FIELD wdate END IF
 
      AFTER FIELD void
         IF tm.void NOT MATCHES '[YN]' THEN NEXT FIELD void END IF
 
      AFTER FIELD more
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
      ON ACTION CONTROLG CALL cl_cmdask()        # Command execution
   AFTER INPUT
      IF cl_null(tm.wdate) THEN
         CALL cl_err('','mfg6138',1) NEXT FIELD wdate
      END IF
      LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
      LET tm.t = tm2.t1,tm2.t2,tm2.t3
      LET tm.u = tm2.u1,tm2.u2,tm2.u3
      LET l_jmp_flag = 'N'
      IF INT_FLAG THEN EXIT INPUT END IF
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr730_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='anmr730'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr730','9031',1)
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
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",   #TQC-160058
                         " '",tm.wdate CLIPPED,"'",
                         " '",tm.void CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('anmr730',g_time,l_cmd)  # Execute cmd at later time
      END IF
      CLOSE WINDOW anmr730_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr730()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr730_w
END FUNCTION
 
FUNCTION anmr730()
   DEFINE l_name        LIKE type_file.chr20,                # External(Disk) file name       #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8            #No.FUN-6A0082
          l_sql         LIKE type_file.chr1000,              # RDSQL STATEMENT #No.FUN-680107 VARCHAR(1200)
          l_chr         LIKE type_file.chr1,                 #No.FUN-680107 VARCHAR(1)
          l_azi04       LIKE azi_file.azi04,                 #No.FUN-7A0036                                                         
          l_azi07       LIKE azi_file.azi07,                 #No.FUN-7A0036  
          l_nnq         RECORD LIKE nnq_file.*,              #No.FUN-7A0036 
          l_za05        LIKE type_file.chr1000,              #No.FUN-680107 VARCHAR(40)
          l_order       ARRAY[5] OF LIKE nno_file.nno01,     #No.FUN-680107 ARRAY[5] OF VARCHAR(20)
          sr            RECORD order1 LIKE nno_file.nno01,   #No.FUN-680107 VARCHAR(20)
                               order2 LIKE nno_file.nno01,   #No.FUN-680107 VARCHAR(20)
                               order3 LIKE nno_file.nno01,   #No.FUN-680107 VARCHAR(20)
                               alg021 LIKE alg_file.alg021,
                               nnn01 LIKE nnn_file.nnn01,
                               nnp03 LIKE nnp_file.nnp03,
                               nnn02 LIKE nnn_file.nnn02,
                               nno04 LIKE nno_file.nno04,
                               nno05 LIKE nno_file.nno05,
                               nno06 LIKE nno_file.nno06,    #No:8687
                               nno08 LIKE nno_file.nno08,    #No:8687
                               nnp05 LIKE nnp_file.nnp05,
                               nnp06 LIKE nnp_file.nnp06,
                               nnp07 LIKE nnp_file.nnp07,
                               nnp09 LIKE nnp_file.nnp09,
                               nno02 LIKE nno_file.nno02,
                               nno01 LIKE nno_file.nno01,
                               nno03 LIKE nno_file.nno03,
                               nno09 LIKE nno_file.nno09,
                               nnp01 LIKE nnp_file.nnp01,
                               nnp02 LIKE nnp_file.nnp02
                        END RECORD
 
#No.FUN-7A0036---Begin                                                                                                              
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "                                                          
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
      EXIT PROGRAM                                                                             
   END IF                                                                                                                           
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                                 
               " VALUES(?,?,?,?,?) "                                                                                                
   PREPARE insert_prep1 FROM g_sql                                                                                                  
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep1:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
      EXIT PROGRAM                                                                            
   END IF                                                                                                                           
     CALL cl_del_data(l_table)                                                                                                      
     CALL cl_del_data(l_table1)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                                                     
#No.FUN-7A0036---End     
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = "SELECT * FROM nnq_file WHERE nnq01 = ? AND nnq02 = ? ",
                  " ORDER BY nnq03"
     PREPARE r730_prennq FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('r730_prennq:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
     END IF
     DECLARE nnq_curs CURSOR FOR r730_prennq
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND nnouser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND nnogrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND nnogrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nnouser', 'nnogrup')
     #End:FUN-980030
 
#No.FUN-7A0036---Begin
{
     #no.5195   (針對幣別加總)
     DELETE FROM curr_tmp;
 
     LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 1 小計
               "  WHERE order1=? ",
               "  GROUP BY curr"
     PREPARE tmp1_pre FROM l_sql
     IF SQLCA.sqlcode THEN CALL cl_err('pre_1:',SQLCA.sqlcode,1) RETURN END IF
     DECLARE tmp1_cs CURSOR FOR tmp1_pre
 
     LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 2 小計
               "  WHERE order1=? ",
               "    AND order2=? ",
               "  GROUP BY curr  "
     PREPARE tmp2_pre FROM l_sql
     IF SQLCA.sqlcode THEN CALL cl_err('pre_2:',SQLCA.sqlcode,1) RETURN END IF
     DECLARE tmp2_cs CURSOR FOR tmp2_pre
 
     LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 3 小計
               "  WHERE order1=? ",
               "    AND order2=? ",
               "    AND order3=? ",
               "  GROUP BY curr  "
     PREPARE tmp3_pre FROM l_sql
     IF SQLCA.sqlcode THEN CALL cl_err('pre_3:',SQLCA.sqlcode,1) RETURN END IF
     DECLARE tmp3_cs CURSOR FOR tmp3_pre
 
     LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #on last row 總計
               "  GROUP BY curr  "
     PREPARE tmp_pre FROM l_sql
     IF SQLCA.sqlcode THEN CALL cl_err('pre:',SQLCA.sqlcode,1) RETURN END IF
     DECLARE tmp_cs CURSOR FOR tmp_pre
     #no.5195(end)
}                                                                                                                                   
#No.FUN-7A0036---End  
      LET l_sql = "SELECT '','','', alg021, nnn01, nnp03,",
                 " nnn02, nno04, nno05, nno06, nno08, nnp05, nnp06, ",   #No:868
                 " nnp07, nnp09, nno02, nno01,",
                 " nno03, nno09, nnp01, nnp02 ",
                 "  FROM  nno_file LEFT OUTER JOIN nnp_file LEFT OUTER JOIN nnn_file ON nnp03 = nnn01 ON nno01 = nnp01 ",
                 " ,alg_file ",
                 " WHERE nno02 = alg01 ",  
                 "   AND ",tm.wc
 
     IF tm.void='N' THEN
     #CHI-7C0007---mod---str---
       #LET l_sql=l_sql CLIPPED," AND nno05>='",tm.wdate,"'"
        LET l_sql=l_sql CLIPPED,
                 " AND nno05>='",tm.wdate,"'",
                 "ORDER BY nno01 "     
     ELSE 
        LET l_sql=l_sql CLIPPED,
                 "ORDER BY nno01 "     
     #CHI-7C0007---mod---end---
     END IF
     PREPARE anmr730_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
     END IF
     DECLARE anmr730_curs1 CURSOR FOR anmr730_prepare1
 
#     CALL cl_outnam('anmr730') RETURNING l_name   #CHI-7C0007 mark
#     START REPORT anmr730_rep TO l_name        #No.FUN-7A0036  
 
     LET g_pageno = 0
     FOREACH anmr730_curs1 INTO sr.*
#No:7A0036---Begin                                                                                                                  
 { 
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       FOR g_i = 1 TO 3
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.nno02
                                        LET l_orderA[g_i] = g_x[12]
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.nno01
                                        LET l_orderA[g_i] = g_x[13]
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.nno03
                                                           USING 'yyyymmdd'
                                        LET l_orderA[g_i] = g_x[14]
               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.nno04
                                                           USING 'yyyymmdd'
                                        LET l_orderA[g_i] = g_x[15]
               OTHERWISE LET l_order[g_i] = '-'
                         LET l_orderA[g_i] = ' '
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
       IF sr.order1 IS NULL THEN LET sr.order1 = ' '  END IF
       IF sr.order2 IS NULL THEN LET sr.order2 = ' '  END IF
       IF sr.order3 IS NULL THEN LET sr.order3 = ' '  END IF
}                                                                                                                                   
      SELECT azi04,azi07 INTO l_azi04,l_azi07 FROM azi_file                                                                         
       WHERE azi01=sr.nno06                                                                                                         
      SELECT azi03,azi04,azi05,azi07                                                                                                
        INTO t_azi03,t_azi04,t_azi05,t_azi07                                                                                        
        FROM azi_file                                                                                                               
        WHERE azi01=sr.nnp07                                                                                                        
 
        FOREACH nnq_curs USING sr.nnp01,sr.nnp02 INTO l_nnq.*                                                                       
        EXECUTE insert_prep1 USING   sr.nnp01,                                                                                      
                                     sr.nnp02,l_nnq.nnq03,l_nnq.nnq04,l_nnq.nnq05                                                   
        END FOREACH                                                                                                                 
     #  OUTPUT TO REPORT anmr730_rep(sr.*)                                                                                          
      EXECUTE insert_prep USING   sr.alg021,sr.nnn01,sr.nnn02,sr.nno01,sr.nno02,                                                    
                                  sr.nno03,sr.nno04,sr.nno05,sr.nno06,sr.nno08,                                                     
                                  sr.nno09,sr.nnp01,sr.nnp02,sr.nnp03,sr.nnp05,sr.nnp06,                                            
     #                              sr.nnp07,sr.nnp09,t_azi03,l_azi04,t_azi04,    #No.FUN-7B0143 
                                  sr.nnp07,sr.nnp09,t_azi03,l_azi04,t_azi04,      #No.FUN-7B0143                                                           
                                  t_azi05,l_azi07,t_azi07                                                                           
#No.FUN-7A0036---End   
     END FOREACH
#No.FUN-7A0036---Begin                                                                                                              
 
   #  FINISH REPORT anmr730_rep                                                                                                     
         IF g_zz05 = 'Y' THEN                                                                                                       
         CALL cl_wcchp(tm.wc,'nno02,nno01,nno03,nno04')                                                                             
              RETURNING tm.wc                                                                                                       
      END IF                                                                                                                        
      LET g_str=tm.wc ,";",tm.wdate,";",tm.void,";",tm.s[1,1],";", tm.s[2,2],";",                                                   
                      tm.s[3,3],";",tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",                                                      
                      tm.u[1,1],";",tm.u[2,2],";",tm.u[3,3]                                                                         
                                                                                                                                    
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED, "|",                                                         
               "SELECT * FROM ", g_cr_db_str CLIPPED, l_table1 CLIPPED                                                              
 
   CALL cl_prt_cs3('anmr730','anmr730',l_sql,g_str)                                                                                 
    # CALL cl_prt(l_name,g_prtway,g_copies,g_len)                                                                                   
#No.FUN-7A0036---End 
 
END FUNCTION
#No.FUN-7A0036---Begin                                                                                                              
{    
REPORT anmr730_rep(sr)
   DEFINE l_last_sw        LIKE type_file.chr1,                   #No.FUN-680107 VARCHAR(1)
          sr               RECORD order1 LIKE nno_file.nno01,     #No.FUN-680107 VARCHAR(20)
                                  order2 LIKE nno_file.nno01,     #No.FUN-680107 VARCHAR(20)
                                  order3 LIKE nno_file.nno01,     #No.FUN-680107 VARCHAR(20)
                                  alg021 LIKE alg_file.alg021,
                                  nnn01 LIKE nnn_file.nnn01,
                                  nnp03 LIKE nnp_file.nnp03,
                                  nnn02 LIKE nnn_file.nnn02,
                                  nno04 LIKE nno_file.nno04,
                                  nno05 LIKE nno_file.nno05,
                                  nno06 LIKE nno_file.nno06,      #No:8687
                                  nno08 LIKE nno_file.nno08,      #No:8687
                                  nnp05 LIKE nnp_file.nnp05,
                                  nnp06 LIKE nnp_file.nnp06,
                                  nnp07 LIKE nnp_file.nnp07,
                                  nnp09 LIKE nnp_file.nnp09,
                                  nno02 LIKE nno_file.nno02,
                                  nno01 LIKE nno_file.nno01,
                                  nno03 LIKE nno_file.nno03,
                                  nno09 LIKE nno_file.nno09,
                                  nnp01 LIKE nnp_file.nnp01,
                                  nnp02 LIKE nnp_file.nnp02
                            END RECORD,
          sr1           RECORD
                        curr   LIKE azi_file.azi01,   #No.FUN-680107 VARCHAR(4)
                        amt    LIKE type_file.num20_6 #No.FUN-680107 DEC(20,6)
                        END RECORD,
          l_n           LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_amt         LIKE nno_file.nno08,          #No.FUN-680107 DECIMAL(15,3)
          l_type        LIKE type_file.chr50,         #No.FUN-680107 VARCHAR(24)
          l_chr         LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          l_sum         LIKE type_file.chr20,         #No.FUN-680107 VARCHAR(20)
          l_azi04       LIKE azi_file.azi04,          #No:8687
          l_nnq         RECORD LIKE nnq_file.*
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line   #No.MOD-580242
 
  ORDER BY sr.order1,sr.order2,sr.order3,sr.alg021,sr.nno01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
 
      LET g_head1=g_x[9] CLIPPED,tm.wdate,'         ',g_x[11] CLIPPED,' ',
            l_orderA[1] CLIPPED," - ",l_orderA[2] CLIPPED," - ",l_orderA[3]
      PRINT g_head1
      PRINT g_dash[1,g_len]
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
            g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED,g_x[42] CLIPPED,
            g_x[43] CLIPPED
      PRINT g_dash1
 
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
   BEFORE GROUP OF sr.order3
      IF tm.t[3,3] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   BEFORE GROUP OF sr.alg021
      PRINT COLUMN g_c[31],sr.nno02,
            COLUMN g_c[32],sr.alg021;
 
   BEFORE GROUP OF sr.nno01
     #No:8687
      SELECT azi04,azi07 INTO t_azi04,t_azi07 FROM azi_file
       WHERE azi01=sr.nno06
      PRINT COLUMN g_c[33],sr.nno01,
            COLUMN g_c[34],sr.nno04,
            COLUMN g_c[35],sr.nno05,
            COLUMN g_c[36],sr.nno06,
            COLUMN g_c[37],cl_numfor(sr.nno08,37,t_azi04),
            COLUMN g_c[38],sr.nno09;
      #-----MOD-7A0021---------
      
      #no.5195 No:8687 由ON EVERY ROW搬上來
#      INSERT INTO curr_tmp VALUES(sr.nno06,sr.nno08,                     #No:8687
#                                  sr.order1,sr.order2,sr.order3)
       #no.5195(end)
      
      #-----END MOD-7A0021-----
 
   ON EVERY ROW
      SELECT azi03,azi04,azi05,azi07
        INTO t_azi03,t_azi04,t_azi05,t_azi07
        FROM azi_file
       WHERE azi01=sr.nnp07
 
      LET l_type=sr.nnp03,' ',sr.nnn02
      #No:8687 modi
      PRINT COLUMN g_c[39],l_type,
            COLUMN g_c[40],sr.nnp05 USING '-&.----',      #No:7354
            COLUMN g_c[41],sr.nnp06 USING '--&.--',
            COLUMN g_c[42],sr.nnp07,
            COLUMN g_c[43],cl_numfor(sr.nnp09,43,t_azi04) CLIPPED
        FOREACH nnq_curs USING sr.nnp01,sr.nnp02 INTO l_nnq.*
          PRINT COLUMN g_c[32],l_nnq.nnq04 CLIPPED,
                COLUMN g_c[39],l_nnq.nnq05 CLIPPED
        END FOREACH
 
      #no.5195
      INSERT INTO curr_tmp VALUES(sr.nnp07,sr.nnp09,
                                  sr.order1,sr.order2,sr.order3)
      #no.5195(end)
 
   AFTER GROUP OF sr.order1
      IF tm.u[1,1] = 'Y' THEN
         LET l_amt = GROUP SUM(sr.nno08)           #No:8687
         IF cl_null(l_amt) THEN LET l_amt = 0 END IF
         PRINT ' '
         PRINT COLUMN g_c[32],l_orderA[1];
         #no.5195
         FOREACH tmp1_cs USING sr.order1 INTO sr1.*
             SELECT azi05 INTO t_azi05 FROM azi_file
              WHERE azi01 = sr1.curr
             LET l_sum=sr1.curr,' ',g_x[24] CLIPPED
             PRINT COLUMN g_c[34],l_sum,
                   COLUMN g_c[37],cl_numfor(sr1.amt,37,t_azi05)    #No:8687
         END FOREACH
         #no.5195(end)
         PRINT g_dash2[1,g_len]
      END IF
 
   AFTER GROUP OF sr.order2
      IF tm.u[2,2] = 'Y' THEN
         LET l_amt = GROUP SUM(sr.nno08)     #No:8687
         IF cl_null(l_amt) THEN LET l_amt = 0 END IF
         PRINT ' '
         PRINT COLUMN g_c[32],l_orderA[2];
         #no.5195
         FOREACH tmp2_cs USING sr.order1,sr.order2 INTO sr1.*
             SELECT azi05 INTO g_azi05 FROM azi_file  
              WHERE azi01 = sr1.curr
             LET l_sum=sr1.curr,' ',g_x[24] CLIPPED
             PRINT COLUMN g_c[34],l_sum,
                   COLUMN g_c[37],cl_numfor(sr1.amt,37,t_azi05)    #No:8687
         END FOREACH
         #no.5195(end)
         PRINT g_dash2[1,g_len]
      END IF
 
   AFTER GROUP OF sr.order3
      IF tm.u[3,3] = 'Y' THEN
         LET l_amt = GROUP SUM(sr.nno08)       #No:8687
         IF cl_null(l_amt) THEN LET l_amt = 0 END IF
         PRINT ' '
         PRINT COLUMN g_c[32],l_orderA[3];
         #no.5195
         FOREACH tmp3_cs USING sr.order1,sr.order2,sr.order3 INTO sr1.*
             SELECT azi05 INTO t_azi05 FROM azi_file
              WHERE azi01 = sr1.curr
             LET l_sum=sr1.curr,' ',g_x[24] CLIPPED
             PRINT COLUMN g_c[34],l_sum,
                   COLUMN g_c[37],cl_numfor(sr1.amt,37,t_azi05)     #No:8687
         END FOREACH
         #no.5195(end)
         PRINT g_dash2[1,g_len]
      END IF
 
   ON LAST ROW
      PRINT COLUMN g_c[37],g_dash2[1,g_w[37]]    #No:8687
 
       #依幣別總計
       #no.5195
       FOREACH tmp_cs INTO sr1.*
           SELECT azi05 INTO t_azi05 FROM azi_file
            WHERE azi01 = sr1.curr
           LET l_sum=sr1.curr,' ',g_x[23] CLIPPED
           PRINT COLUMN g_c[34],l_sum,
                 COLUMN g_c[37],cl_numfor(sr1.amt,37,t_azi05)    #No:8687
       END FOREACH
       #no.5195(end)
      PRINT
 
       PRINT g_dash[1,g_len]
       IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'nno02,nno01,nno03,nno04')
              RETURNING tm.wc
              # PRINT g_dash[1,g_len]
            # IF tm.wc[001,120] > ' ' THEN                      # for 132
            #    PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
            # IF tm.wc[121,240] > ' ' THEN
            #    PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
            # IF tm.wc[241,300] > ' ' THEN
            #    PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
            #TQC-630166
            CALL cl_prt_pos_wc(tm.wc)
      END IF
      LET l_last_sw = 'y'
      PRINT g_dash[1,g_len]
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
}#No.FUN-7A0036---End  
