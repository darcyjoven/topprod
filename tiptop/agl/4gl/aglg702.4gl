# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aglg702.4gl
# Descriptions...: 專案明細表
# Input parameter:
# Return code....:
# Date & Author..: 01/09/28 By Wiky
# Modify.........: No.FUN-510007 05/02/03 By Nicola 報表架構修改
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680098 06/08/31 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6C0012 06/12/27 By Judy 新增打印額外名稱欄位
# Modify.........: No.FUN-740020 07/04/10 By Lynn 會計科目加帳套
# Modify.........: NO.FUN-830094 08/03/27 By zhaijie報表輸出改為CR
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9B0158 09/11/24 By Sarah 依照專案編號跟畫面上選的排序選項先將資料排序後再計算餘額
# Modify.........: No.FUN-B20054 11/02/24 By lixiang 先錄入帳套,科目根據帳套過濾;結構改為DIALOG 
# Modify.........: No.FUN-B90028 11/09/07 By qirl  明細CR報表轉GR

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
                 wc         STRING,
                 bookno     LIKE aag_file.aag00,   #No.FUN-740020
                 a          LIKE type_file.chr1,   #FUN-6C0012 
                 s          LIKE type_file.chr2,   #No.FUN-680098 VARCHAR(2)
                 t          LIKE type_file.chr1,   #No.FUN-680098 VARCHAR(1)
                 u          LIKE type_file.chr1,   #No.FUN-680098 VARCHAR(1)
                 more       LIKE type_file.chr1    #No.FUN-680098 VARCHAR(1)
              END RECORD 
#         g_bookno                       LIKE aaa_file.aaa01,    #No.FUN-740020
   DEFINE l_s_d,l_s_c,l_t_d,l_t_c,l_bal  LIKE abb_file.abb07
   DEFINE g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098 smallint
#NO.FUN-830094----START-----
   DEFINE g_sql           STRING
   DEFINE g_str           STRING
   DEFINE l_table         STRING
#NO.FUN-830094----END-----
###GENGRE###START
TYPE sr1_t RECORD
    order1 LIKE aeg_file.aeg01,
    order2 LIKE aeg_file.aeg01,
    order3 LIKE aeg_file.aeg01,
    aeg05 LIKE aeg_file.aeg05,
    aeg02 LIKE aeg_file.aeg02,
    aag02 LIKE aag_file.aag02,
    aag13 LIKE aag_file.aag13,
    aeg01 LIKE aeg_file.aeg01,
    aeg03 LIKE aeg_file.aeg03,
    abb06 LIKE abb_file.abb06,
    abb07 LIKE abb_file.abb07,
    azi04 LIKE azi_file.azi04,
    l_bal LIKE abb_file.abb07,
    l_n LIKE type_file.num5,
    l_c35 LIKE abb_file.abb07,  #FUN-B90028
    l_c36 LIKE abb_file.abb07   #FUN-B90028
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
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
#NO.FUN-830094----START-----
   LET g_sql = "order1.aeg_file.aeg01,order2.aeg_file.aeg01,",
               "order3.aeg_file.aeg01,aeg05.aeg_file.aeg05,",
               "aeg02.aeg_file.aeg02,aag02.aag_file.aag02,",
               "aag13.aag_file.aag13,aeg01.aeg_file.aeg01,",
               "aeg03.aeg_file.aeg03,abb06.abb_file.abb06,",
               "abb07.abb_file.abb07,azi04.azi_file.azi04,",
               "l_bal.abb_file.abb07,l_n.type_file.num5,",   #MOD-9B0158 add l_n
               "l_c35.abb_file.abb07,",  #FUN-B90028
               "l_c36.abb_file.abb07"    #FUN-B90028
   LET l_table = cl_prt_temptable('aglg702',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?,?)"  #MOD-9B0158 add ?   #FUN-B90028 2?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF         
#NO.FUN-830094----END-----
   LET tm.bookno = ARG_VAL(1)        #No.FUN-740020
   LET g_pdate = ARG_VAL(2)            # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc = ARG_VAL(8)
   LET tm.s  = ARG_VAL(9)
   LET tm.t  = ARG_VAL(10)
   LET tm.u  = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   #No.FUN-570264 ---end---
   LET tm.a = ARG_VAL(15)   #FUN-6C0012
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
#No.FUN-740020   ---begin
   IF tm.bookno = ' ' OR tm.bookno IS NULL THEN
      LET tm.bookno = g_aza.aza81 
   END IF
#No.FUN-740020  ---end
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL aglg702_tm(0,0)
   ELSE
      CALL aglg702()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
   CALL cl_gre_drop_temptable(l_table)           #FUN-B90028
END MAIN
 
FUNCTION aglg702_tm(p_row,p_col)
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col      LIKE type_file.num5,          #No.FUN-680098 SMALLINT
       l_cmd            LIKE type_file.chr1000        #No.FUN-680098 VARCHAR(400)
DEFINE li_chk_bookno    LIKE type_file.num5           #FUN-B20054 
   CALL s_dsmark(tm.bookno)      #No.FUN-740020
   LET p_row = 3 LET p_col = 16
   OPEN WINDOW aglg702_w AT p_row,p_col
     WITH FORM "agl/42f/aglg702"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL s_shwact(0,0,tm.bookno)   #No.FUN-740020
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  # Default condition
   LET tm.bookno = g_aza.aza81         #FUN-B20054
   LET tm.a    = 'N'  #FUN-6C0012
   LET tm.s    = '23'
   LET tm.t    = '1'
   LET tm.u    = 'Y'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF

   DISPLAY BY NAME tm2.s1,tm2.s2,tm.t,tm.u,tm.a,tm.more         # Condition     #FUN-B20054
   WHILE TRUE
    #FUN-B20054--add--str--
    DIALOG ATTRIBUTE(unbuffered)
       INPUT BY NAME tm.bookno ATTRIBUTE(WITHOUT DEFAULTS)
          AFTER FIELD bookno
            IF NOT cl_null(tm.bookno) THEN
                   CALL s_check_bookno(tm.bookno,g_user,g_plant)
                    RETURNING li_chk_bookno
                IF (NOT li_chk_bookno) THEN
                    NEXT FIELD bookno
                END IF
                SELECT aaa02 FROM aaa_file WHERE aaa01 = tm.bookno
                IF STATUS THEN
                   CALL cl_err3("sel","aaa_file",tm.bookno,"","agl-043","","",0)
                   NEXT FIELD bookno
                END IF
            END IF
       END INPUT
     #FUN-B20054--add--end
      CONSTRUCT BY NAME tm.wc ON aeg05,aeg02,aeg01
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
         
#FUN-B20054--mark--str-- 
#         ON ACTION locale
#            LET g_action_choice = "locale"
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#            EXIT CONSTRUCT
# 
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE CONSTRUCT
# 
#          ON ACTION about         #MOD-4C0121
#             CALL cl_about()      #MOD-4C0121
# 
#          ON ACTION help          #MOD-4C0121
#             CALL cl_show_help()  #MOD-4C0121
# 
#          ON ACTION controlg      #MOD-4C0121
#             CALL cl_cmdask()     #MOD-4C0121
# 
#         ON ACTION exit
#            LET INT_FLAG = 1
#            EXIT CONSTRUCT
# 
#         #No.FUN-580031 --start--
#         ON ACTION qbe_select
#            CALL cl_qbe_select()
#         #No.FUN-580031 ---end---
#FUN-B20054--mark--end
 
      END CONSTRUCT
#FUN-B20054--mark--str-- 
#      IF g_action_choice = "locale" THEN
#         LET g_action_choice = ""
#         CALL cl_dynamic_locale()
#         CONTINUE WHILE
#      END IF
# 
#      IF INT_FLAG THEN
#         LET INT_FLAG = 0
#         CLOSE WINDOW aglg702_w
#         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#         EXIT PROGRAM
#      END IF
# 
#      IF tm.wc = ' 1=1' THEN
#         CALL cl_err('','9046',0)
#         CONTINUE WHILE
#      END IF
#FUN-B20054--mark--end
 
   #   DISPLAY BY NAME tm2.s1,tm2.s2,tm.t,tm.u,tm.a,tm.more             # Condition   #FUN-6C0012  #FUN-B20054
 
   #   INPUT BY NAME tm.bookno,tm2.s1,tm2.s2,tm.t,tm.u,tm.a,tm.more WITHOUT DEFAULTS   #FUN-6C0012   #No.FUN-740020  #FUN-B20054
       INPUT BY NAME tm2.s1,tm2.s2,tm.t,tm.u,tm.a,tm.more
                     ATTRIBUTE(WITHOUT DEFAULTS)  #FUN-B20054
                     
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
         
#FUN-B20054--mark--str-- 
#      #No.FUN-740020 --begin
#         AFTER FIELD bookno
#            IF tm.bookno IS NULL THEN
#               NEXT FIELD bookno
#            END IF
#      #No.FUN-740020 --end
#FUN-B20054--mark--end 
         AFTER FIELD s1
            IF tm2.s1 IS NULL THEN
               NEXT FIELD s1
            END IF
 
         AFTER FIELD t
            IF tm.t  NOT MATCHES '[12]' THEN
               NEXT FIELD t
            END IF
 
         AFTER FIELD u
            IF tm.u  NOT MATCHES '[YN]' THEN
               NEXT FIELD u
            END IF
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
        #FUN-B20054--add--str--
         AFTER INPUT              
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
        #FUN-B20054--add--end
        
#FUN-B20054--mark--str--         
#         ON ACTION CONTROLR
#            CALL cl_show_req_fields()
# 
#         ON ACTION CONTROLG
#            CALL cl_cmdask()
# 
#         AFTER INPUT
#            LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
# 
#         #No.FUN-740020  --Begin                                                                                                    
#         ON ACTION CONTROLP                                                                                                         
#          CASE                                                                                                                      
#            WHEN INFIELD(bookno)                                                                                                    
#              CALL cl_init_qry_var()                                                                                                
#              LET g_qryparam.form = 'q_aaa'                                                                                         
#              LET g_qryparam.default1 = tm.bookno                                                                                      
#              CALL cl_create_qry() RETURNING tm.bookno                                                                                 
#              DISPLAY BY NAME tm.bookno                                                                                                
#              NEXT FIELD bookno                                                                                                     
#          END CASE                                                                                                                  
#         #No.FUN-740020  --End         
# 
#          ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE INPUT
# 
#          ON ACTION about         #MOD-4C0121
#             CALL cl_about()      #MOD-4C0121
# 
#          ON ACTION help          #MOD-4C0121
#             CALL cl_show_help()  #MOD-4C0121
# 
#         ON ACTION exit
#            LET INT_FLAG = 1
#            EXIT INPUT
# 
#         #No.FUN-580031 --start--
#         ON ACTION qbe_save
#            CALL cl_qbe_save()
#         #No.FUN-580031 ---end---
#FUN-B20054--mark--end 
 
      END INPUT
      
   #FUN-B20054--add--str--
      #No.FUN-740020  --Begin                                                                                                    
         ON ACTION CONTROLP                                                                                                         
          CASE                                                                                                                      
            WHEN INFIELD(bookno)                                                                                                    
              CALL cl_init_qry_var()                                                                                                
              LET g_qryparam.form = 'q_aaa'                                                                                         
              LET g_qryparam.default1 = tm.bookno                                                                                      
              CALL cl_create_qry() RETURNING tm.bookno                                                                                 
              DISPLAY BY NAME tm.bookno                                                                                                
              NEXT FIELD bookno 
      #No.FUN-740020  --End
            WHEN INFIELD(aeg01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_aag"
              LET g_qryparam.state = "c"
              LET g_qryparam.where = " aag00 = '",tm.bookno   CLIPPED,"'"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO aeg01
              NEXT FIELD aeg01              
          END CASE                                                                                                                  

      ON ACTION locale
          LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121

      ON ACTION CONTROLR
         CALL cl_show_req_fields()  
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT DIALOG
 
      #No.FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      #No.FUN-580031 ---end---

      ON ACTION accept
         EXIT DIALOG

      ON ACTION cancel
         LET INT_FLAG=1
         EXIT DIALOG
    END DIALOG
    
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW aglg702_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         CALL cl_gre_drop_temptable(l_table)           #FUN-B90028
         EXIT PROGRAM
      END IF

      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
  #FUN-B20054--add--end
  
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file      #get exec cmd (fglgo xxxx)
          WHERE zz01='aglg702'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglg702','9031',1)   
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,            #(at time fglgo xxxx p1 p2 p3)
                        " '",tm.bookno CLIPPED,"'",   #No.FUN-740020
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'" ,
                        " '",tm.s CLIPPED,"'" ,   #TQC-610056
                        " '",tm.t CLIPPED,"'" ,   #TQC-610056
                        " '",tm.u CLIPPED,"'" ,   #TQC-610056
                        " '",tm.a CLIPPED,"'" ,   #FUN-6C0012
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aglg702',g_time,l_cmd)      # Execute cmd at later time
         END IF
 
         CLOSE WINDOW aglg702_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         CALL cl_gre_drop_temptable(l_table)           #FUN-B90028
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL aglg702()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW aglg702_w
 
END FUNCTION
 
FUNCTION aglg702()
   DEFINE l_name   LIKE type_file.chr20,             # External(Disk) file name        #No.FUN-680098 VARCHAR(20)
#         l_time   LIKE type_file.chr8               #No.FUN-6A0073
          l_sql    LIKE type_file.chr1000,           # RDSQL STATEMENT                 #No.FUN-680098 VARCHAR(1000)
          l_chr    LIKE type_file.chr1,              #No.FUN-680098 VARCHAR(1)
          l_order  ARRAY[5] OF LIKE aeg_file.aeg01,  #No.FUN-680098 VARCHAR(10)
          l_n      LIKE type_file.num5,              #MOD-9B0158 add
          sr       RECORD
                    order1 LIKE aeg_file.aeg01,      #No.FUN-680098 VARCHAR(10)
                    order2 LIKE aeg_file.aeg01,      #No.FUN-680098 VARCHAR(10)
                    order3 LIKE aeg_file.aeg01,      #No.FUN-680098 VARCHAR(10)
                    aeg05 LIKE aeg_file.aeg05,
                    aeg02 LIKE aeg_file.aeg02,
                    aag02 LIKE aag_file.aag02,
                    aag13 LIKE aag_file.aag13,       #FUN-6C0012
                    aeg01 LIKE aeg_file.aeg01,
                    aeg03 LIKE aeg_file.aeg03,
                    abb06 LIKE abb_file.abb06,
                    abb07 LIKE abb_file.abb07,
                    azi04 LIKE azi_file.azi04,
                    l_c35  LIKE abb_file.abb07,       #FUN-B90028  
                    l_c36  LIKE abb_file.abb07        #FUN-B90028  
                   END RECORD
 
   LET l_bal = 0
   LET l_s_d = 0
   LET l_s_c = 0
   LET l_t_d = 0
   LET l_t_c = 0

   CALL cl_del_data(l_table)                     #NO.FUN-830094

   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang #NO.FUN-830094  
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aglg702'  #NO.FUN-830094
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = tm.bookno    #No.FUN-740020
      AND aaf02 = g_rlang
 
  #====>資料權限的檢查
  #Begin:FUN-980030
  #IF g_priv2='4' THEN                           #只能使用自己的資料
  #   LET tm.wc = tm.wc clipped," AND aaguser = '",g_user,"'"
  #END IF
  #IF g_priv3='4' THEN                           #只能使用相同群的資料
  #   LET tm.wc = tm.wc clipped," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
  #END IF
  #IF g_priv3 MATCHES "[5678]" THEN              #TQC-5C0134群組權限
  #   LET tm.wc = tm.wc clipped," AND aaggrup IN ",cl_chk_tgrup_list()
  #END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
  #End:FUN-980030
 
   LET l_sql = "SELECT '','','',aeg05,aeg02,aag02,aag13,aeg01,aeg03,",  #FUN-6C0012
               "       abb06,abb07,azi04,0,0 ",      #FUN-B90028 2 0
               "  FROM aeg_file,aaa_file,abb_file,aag_file,azi_file ",
               " WHERE aeg00 = '",tm.bookno,"'",  #No.FUN-740020
               "   AND aeg00 = abb00 ",
               "   AND aeg00 = aaa01 ",          #No.FUN-740020
               "   AND aeg00 = aag00 ",          #No.FUN-740020
               "   AND abb01 = aeg03 ",
               "   AND abb03 = aeg01 AND abb02 = aeg04 ",
               "   AND aeg00 = aaa01 AND aaa03 = azi01 "
   IF tm.t ='1' THEN
      LET l_sql =l_sql CLIPPED," AND aeg01 =aag01 AND aag07 IN ('1','3')"
   ELSE
      LET l_sql =l_sql CLIPPED," AND aeg01 =aag01 AND aag07 ='2' "
   END IF
   LET l_sql =l_sql CLIPPED, "   AND ",tm.wc CLIPPED
  #str MOD-9B0158 add
  #資料要先排序,再算餘額
   LET l_sql =l_sql CLIPPED, " ORDER BY aeg05" 
   FOR g_i = 1 TO 2
      CASE
         WHEN tm.s[g_i,g_i] = '2'  LET l_sql =l_sql CLIPPED, ",aeg02"
         WHEN tm.s[g_i,g_i] = '3'  LET l_sql =l_sql CLIPPED, ",aeg01"
      END CASE
   END FOR
  #end MOD-9B0158 add
   PREPARE aglg702_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)           #FUN-B90028
      EXIT PROGRAM
   END IF
   DECLARE aglg702_curs1 CURSOR FOR aglg702_prepare1
 
#  CALL cl_outnam('aglg702') RETURNING l_name         #NO.FUN-830094  
#  #No.FUN-6C0012 --start--                                                     
#NO.FUN-830094-----START--MARK---
#  IF tm.a = 'Y' THEN                                                           
#     LET g_zaa[33].zaa06 = 'Y'                       #NO.FUN-830094
#  ELSE                                                                         
#     LET g_zaa[39].zaa06 = 'Y'                       #NO.FUN-830094
#  END IF                                                                       
#NO.FUN-830094----END----MARK----                                 
#  CALL cl_prt_pos_len()                                                        
#  #No.FUN-6C0012 --end--
#  START REPORT aglg702_rep TO l_name                 #NO.FUN-830094
#  LET g_pageno = 0                                   #NO.FUN-830094
   LET l_n = 0   #MOD-9B0158 add
   FOREACH aglg702_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      FOR g_i = 1 TO 2
         CASE
            WHEN tm.s[g_i,g_i] = '2'
               LET l_order[g_i] = sr.aeg02 USING 'yyyymmdd'
            WHEN tm.s[g_i,g_i] = '3'
               LET l_order[g_i] = sr.aeg01
            OTHERWISE
               LET l_order[g_i] = '-'
         END CASE
      END FOR
      LET sr.order1 = sr.aeg05   #MOD-9B0158 add
      LET sr.order2 = l_order[1]
      LET sr.order3 = l_order[2]
 
#     OUTPUT TO REPORT aglg702_rep(sr.*)              #NO.FUN-830094
#NO.FUN-830094----START-----
      IF sr.abb06 = '1' THEN
         LET l_bal = l_bal + sr.abb07
      ELSE
         LET l_bal = l_bal - sr.abb07
      END IF
      LET l_n = l_n + 1   #MOD-9B0158 add

      #FUN-B90028----add----str-----
      IF sr.abb06 = '1' THEN
         LET sr.l_c35 = sr.abb07
      ELSE
         LET sr.l_c35 = 0
      END IF

      IF sr.abb06 = '2' THEN
         LET sr.l_c36 = sr.abb07
      ELSE
         LET sr.l_c36 = 0
      END IF
      #FUN-B90028----add----end-----

      EXECUTE insert_prep USING
         sr.order1,sr.order2,sr.order3,sr.aeg05,sr.aeg02,
         sr.aag02,sr.aag13,sr.aeg01,sr.aeg03,sr.abb06,
         sr.abb07,sr.azi04,l_bal,l_n,  #MOD-9B0158 add l_n
         sr.l_c35,sr.l_c36             #FUN-B90028 add
#NO.FUN-830094---END----         
   END FOREACH
 
#  FINISH REPORT aglg702_rep                          #NO.FUN-830094
 
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)        #NO.FUN-830094
#NO.FUN-830094----START-----
###GENGRE###   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   IF g_zz05 = 'Y' THEN 
      CALL cl_wcchp(tm.wc,'aeg05,aeg02,aeg01') RETURNING tm.wc
   END IF
###GENGRE###   LET g_str = tm.wc,";",tm.u[1,1],";",tm.a
###GENGRE###   CALL cl_prt_cs3('aglg702','aglg702',g_sql,g_str) 
    CALL aglg702_grdata()    ###GENGRE###
#NO.FUN-830094----END-----
END FUNCTION
 
#NO.FUN-830094----START-----
#REPORT aglg702_rep(sr)
#   DEFINE l_last_sw     LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
#          sr            RECORD
#                           order1 LIKE aeg_file.aeg01,   #No.FUN-680098 VARCHAR(10)
#                           order2 LIKE aeg_file.aeg01,   #No.FUN-680098 VARCHAR(10)
#                           order3 LIKE aeg_file.aeg01,   #No.FUN-680098 VARCHAR(10)
#                           aeg05 LIKE aeg_file.aeg05,      #
#                           aeg02 LIKE aeg_file.aeg02,      #
#                           aag02 LIKE aag_file.aag02,      #
#                           aag13 LIKE aag_file.aag13,      #FUN-6C0012
#                           aeg01 LIKE aeg_file.aeg01,      #
#                           aeg03 LIKE aeg_file.aeg03,      #
#                           abb06 LIKE abb_file.abb06,      #
#                           abb07 LIKE abb_file.abb07,      #
#                           azi04 LIKE azi_file.azi04
#                        END RECORD
 
#   OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.aeg05,sr.order2,sr.order3
 
#   FORMAT
#      PAGE HEADER
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
#         LET g_pageno = g_pageno + 1
#         LET pageno_total = PAGENO USING '<<<',"/pageno"
#         PRINT g_head CLIPPED,pageno_total
#         PRINT
#         PRINT g_dash[1,g_len]
##        PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]          #FUN-6C0012
#         PRINT g_x[31],g_x[32],g_x[33],g_x[39],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]  #FUN-6C0012
#         PRINT g_dash1
#         LET l_last_sw = 'n'
# 
#      BEFORE GROUP OF sr.aeg05
#         IF tm.u[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9) THEN
#            SKIP TO TOP OF PAGE
#         END IF
#         PRINT COLUMN g_c[31],g_x[9] CLIPPED,
#               COLUMN g_c[32],sr.aeg05
#         PRINT '  '
 
#      ON EVERY ROW
#         PRINT COLUMN g_c[31],sr.aeg02,
#               COLUMN g_c[32],sr.aeg01,
#               COLUMN g_c[33],sr.aag02,
#               COLUMN g_c[39],sr.aag13,   #FUN-6C0012
#               COLUMN g_c[34],sr.aeg03;
#         IF sr.abb06 = '1' THEN
#            LET l_bal = l_bal + sr.abb07
#            LET l_s_d = l_s_d + sr.abb07
#            LET l_t_d = l_t_d + sr.abb07
#            PRINT COLUMN g_c[35],cl_numfor(sr.abb07,35,sr.azi04);
#         ELSE
#            LET l_bal = l_bal - sr.abb07
#            LET l_s_c = l_s_c + sr.abb07
#            LET l_t_c = l_t_c + sr.abb07
#            PRINT COLUMN g_c[36],cl_numfor(sr.abb07,36,sr.azi04);
#         END IF
#
#         IF l_bal>=0 THEN
#            PRINT COLUMN g_c[37],cl_numfor(l_bal,37,sr.azi04),
#                  COLUMN g_c[38],'D'
#         ELSE
#            LET l_bal = l_bal * (-1)
#            PRINT COLUMN g_c[37],cl_numfor(l_bal,37,sr.azi04),
#                  COLUMN g_c[38],'C'
#            LET l_bal = l_bal * (-1)
#         END IF
 
#      AFTER GROUP OF sr.aeg05
#         PRINT '  '
#         PRINT COLUMN g_c[34],g_x[10] CLIPPED,
#               COLUMN g_c[35],cl_numfor(l_s_d,35,sr.azi04),
#               COLUMN g_c[36],cl_numfor(l_s_c,36,sr.azi04)
#         PRINT '  '
#         LET l_s_d = 0
#         LET l_s_c = 0
# 
#      ON LAST ROW
#         PRINT '  '
#         PRINT COLUMN g_c[34],g_x[11] CLIPPED,
#               COLUMN g_c[35],cl_numfor(l_t_d,35,sr.azi04),
#               COLUMN g_c[36],cl_numfor(l_t_c,36,sr.azi04)
#         PRINT '  '
#         IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#            CALL cl_wcchp(tm.wc,'aeg051,aeg05,aeg02,aeg01') RETURNING tm.wc
#            PRINT g_dash[1,g_len]
          #-- TQC-630166 begin
            #IF tm.wc[001,070] > ' ' THEN                  # for 80
            #   PRINT COLUMN g_c[31],g_x[8] CLIPPED,
            #         COLUMN g_c[32],tm.wc[001,070] CLIPPED
            #END IF
            #IF tm.wc[071,140] > ' ' THEN
            #   PRINT COLUMN g_c[32],tm.wc[071,140] CLIPPED
            #END IF
            #IF tm.wc[141,210] > ' ' THEN
            #   PRINT COLUMN g_c[32],tm.wc[141,210] CLIPPED
            #END IF
            #IF tm.wc[211,280] > ' ' THEN
            #   PRINT COLUMN g_c[32],tm.wc[211,280] CLIPPED
            #END IF
#            CALL cl_prt_pos_wc(tm.wc)
          #-- TQC-630166 end
#         END IF
#         PRINT g_dash[1,g_len]
#         LET l_last_sw = 'y'
#         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
# 
#      PAGE TRAILER
#         IF l_last_sw = 'n' THEN
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
#         ELSE
#            SKIP 2 LINES
#         END IF
 
#      END REPORT
#NO.FUN-830094----END-----

###GENGRE###START
FUNCTION aglg702_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg702")
        IF handler IS NOT NULL THEN
            START REPORT aglg702_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
          
            DECLARE aglg702_datacur1 CURSOR FROM l_sql
            FOREACH aglg702_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg702_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg702_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg702_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
#FUN-B90028--------START---
    DEFINE l_g_c33    STRING
    DEFINE l_g_x33    STRING
    DEFINE l_g_c35    LIKE abb_file.abb07
    DEFINE l_g_c36    LIKE abb_file.abb07 
    DEFINE l_g_c37    LIKE abb_file.abb07
    DEFINE l_g_c38    STRING 
    DEFINE l_name     STRING
    DEFINE l_name1    STRING
    DEFINE l_g_c35sum LIKE abb_file.abb07    
    DEFINE l_g_c35tot LIKE abb_file.abb07   
    DEFINE l_g_c36tot LIKE abb_file.abb07   
    DEFINE l_g_c36sum LIKE abb_file.abb07   
    DEFINE l_fmt      STRING
    DEFINE l_sql1     STRING
    DEFINE l_cnt2     LIKE type_file.num5
    DEFINE l_cnt3     LIKE type_file.num5
    DEFINE l_display  LIKE type_file.chr1 
#FUN-B90028-------END----
    
    ORDER EXTERNAL BY sr1.aeg05
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name #FUN-B90028 add  g_ptime,g_user_name
            PRINTX tm.*
            LET l_cnt3 = 0
              


        BEFORE GROUP OF sr1.aeg05
#FUN-B90028------STAR-----
            LET l_sql1 = "SELECT COUNT(aeg05) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
            DECLARE aglg702_datacur2 CURSOR FROM l_sql1
            FOREACH aglg702_datacur2 INTO l_cnt2 
            END FOREACH

            LET l_name = cl_gr_getmsg("gre-212",g_lang,'1')
            LET l_name1 = cl_gr_getmsg("gre-213",g_lang,'1')
            IF tm.a = 'Y'  THEN
               LET l_g_c33 = l_name 
            ELSE 
               LET l_g_c33 = l_name1
            END IF
            PRINTX l_g_c33
#FUN-B90028------END---------
 
        
        ON EVERY ROW
#FUN-B90028---------STAR--------
            LET l_cnt3 = l_cnt3 + 1

            LET l_fmt = cl_gr_numfmt("abb_file","abb07",sr1.azi04)
            PRINTX l_fmt
            IF sr1.abb06 = '1' THEN
               LET l_g_c35 = sr1.abb07
            ELSE 
               LET l_g_c35 = 0
            END IF
            PRINTX l_g_c35

            IF sr1.abb06 = '2' THEN
               LET l_g_c36 = sr1.abb07
            ELSE
               LET l_g_c36 = 0
            END IF
            PRINTX l_g_c36
           
            
            IF sr1.l_bal >= 0 THEN
               LET l_g_c37 = sr1.l_bal
            ELSE 
               LET l_g_c37 = sr1.l_bal * (-1)
            END IF
               PRINTX l_g_c37

            IF l_bal >= 0 THEN
               LET l_g_c38 = 'D'
            ELSE
               LET l_g_c38 ='C'
            END IF 
               PRINTX l_g_c38

            IF tm.a = 'Y'  THEN
               LET l_g_x33 = sr1.aag13
            ELSE 
               LET l_g_x33 = sr1.aag02
            END IF 
               PRINTX l_g_x33
#FUN-B90028------END---------
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        AFTER GROUP OF sr1.aeg05
#FUN-B90028-----STAR-----
            IF l_cnt3 = l_cnt2 THEN
               LET l_display = 'N'
            ELSE
               LET l_display = 'Y'
            END IF
            PRINTX l_display
 
            LET l_g_c35sum = GROUP SUM (sr1.l_c35)
            LET l_g_c36sum = GROUP SUM (sr1.l_c36)
            PRINTX l_g_c35sum
            PRINTX l_g_c36sum
#FUN-B90028-----END-----
        
        ON LAST ROW
#FUN-B90028-------STAR------
           LET l_g_c35tot = SUM(sr1.l_c35)
           LET l_g_c36tot = SUM(sr1.l_c36)
           PRINTX l_g_c35tot
           PRINTX l_g_c36tot
#FUN-B90028-------END------

END REPORT
###GENGRE###END
