# Prog. Version..: '5.30.06-13.03.18(00010)'     #
#
# Pattern name...: aglr931.4gl
# Desc/riptions..: 拋轉傳票檢查報表
# Date & Author..: 96/06/25 By Melody
# Modify.........: 97/07/30 By Melody 增加'輸入人員'INPUT,空白表全部
# Modify.........: No.FUN-510007 05/01/17 By Nicola 報表架構修改
# Modify.........: No.FUN-550028 05/05/16 By Will 單據編號放大
# Modify.........: No.FUN-5C0015 06/01/03 By miki 加abb31~abb37的檢查
# Modify.........: NO.FUN-590118 06/01/19 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-670005 06/07/07 By Hellen 帳別權限修改
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680098 06/09/01 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-6B0011 06/12/04 By Sarah (接下頁)、(結束)沒有靠右
# Modify.........: No.FUN-750129 07/06/28 By Carrier 報表轉Crystal Report格式
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-C30026 12/03/03 By Polly 修正拋轉成功仍秀出「無對應原始傳票」錯誤
# Modify.........: No:FUN-C40112 12/07/26 By Lori 傳票拋轉記錄變更為abm_file
# Modify.........: NO.TQC-CB0077 12/12/13 BY Yiting r931_cs1 的FOREACH變數錯誤 
# Modify.........: NO.FUN-CC0093 13/01/07 By zhangweib 程序AFTER FIELD控管優化
# Modify.........: No.CHI-C80041 13/01/18 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                        # Print condition RECORD
               o_aba00   LIKE aaa_file.aaa01,      #No.FUN-670039 
#              o_aba01   VARCHAR(03),
               o_aba01   LIKE aac_file.aac01,      #No.FUN-550028   #No.FUN-680098 VARCHAR(5)
               n_aba00   LIKE aaa_file.aaa01,      #No.FUN-670039 
#              n_aba01  VARCHAR(03),
               n_aba01   LIKE  oay_file.oayslip,   #No.FUN-550028
               b_aba02   LIKE aba_file.aba02,      #No.FUN-680098  date
               e_aba02   LIKE aba_file.aba02,      #No.FUN-680098  date 
#              b_aba01  VARCHAR(12),
               b_aba01  LIKE  aba_file.aba01,      #No.FUN-550028 #No.FUN-680098 VARCHAR(16)
#              e_aba01  VARCHAR(12),
               e_aba01  LIKE  aba_file.aba01,      #No.FUN-550028 #No.FUN-680098 VARCHAR(16)
              pers     LIKE type_file.chr8,      #No.FUN-680098
              more     LIKE type_file.chr1       # Input more condition(Y/N) #No.FUN-680098 VARCHAR(1)
           END RECORD,
       g_bookno        LIKE aaa_file.aaa01,
       g_aaa           RECORD LIKE aaa_file.*
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098 smallint
DEFINE l_table         STRING  #No.FUN-750129
DEFINE g_str           STRING  #No.FUN-750129
DEFINE g_sql           STRING  #No.FUN-750129
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                       # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
   #No.FUN-750129  --Begin
   LET g_sql = " aba02.aba_file.aba02,",
               " aba01.aba_file.aba01,",
               " abb02.abb_file.abb02,",
               " aba06.aba_file.aba06,",
               " aba16.aba_file.aba16,",
               " aba17.aba_file.aba17,",
               " err.type_file.chr1   "
   LET l_table = cl_prt_temptable('aglr931',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?  )"             
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-750129  --End
 
   LET g_bookno  = ARG_VAL(1)  #帳別
   LET g_pdate  = ARG_VAL(2)                   # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang  = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.o_aba00  = ARG_VAL(8)
   LET tm.o_aba01  = ARG_VAL(9)
   LET tm.n_aba00  = ARG_VAL(10)
   LET tm.n_aba01  = ARG_VAL(11)
   LET tm.b_aba02  = ARG_VAL(12)
   LET tm.e_aba02  = ARG_VAL(13)
   LET tm.b_aba01  = ARG_VAL(14)
   LET tm.e_aba01  = ARG_VAL(15)
   LET tm.pers     = ARG_VAL(16)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(17)
   LET g_rep_clas = ARG_VAL(18)
   LET g_template = ARG_VAL(19)
   LET g_rpt_name = ARG_VAL(20)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   IF g_bookno IS NULL OR g_bookno = ' ' THEN
      SELECT aaz64 INTO g_bookno FROM aaz_file
   END IF
 
   SELECT * INTO g_aaa.* FROM aaa_file WHERE aaa01 = g_bookno
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r931_tm(0,0)
   ELSE
      CALL aglr931()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION r931_tm(p_row,p_col)
   DEFINE p_row,p_col      LIKE type_file.num5,          #No.FUN-680098 SMALLINT
          l_flag           LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
          l_cmd            LIKE type_file.chr1000        #No.FUN-680098  VARCHAR(400)
   DEFINE li_chk_bookno    LIKE type_file.num5     #No.FUN-670005    #No.FUN-680098 smallint
   CALL s_dsmark(g_bookno)
   LET p_row = 4 LET p_col = 24
   OPEN WINDOW r931_w AT p_row,p_col
     WITH FORM "agl/42f/aglr931"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL s_shwact(3,2,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  # Default condition
   LET tm.more = 'N'
   LET tm.b_aba02= g_today
   LET tm.e_aba02= g_today
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
 
      DISPLAY BY NAME tm.more
 
      INPUT BY NAME tm.o_aba00,tm.o_aba01,tm.n_aba00,tm.n_aba01,tm.b_aba02,
                    tm.e_aba02,tm.b_aba01,tm.e_aba01,tm.pers,tm.more
                    WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         AFTER FIELD o_aba00
           #No.FUN-CC0093 ---start--- Mark
           #IF cl_null(tm.o_aba00) THEN
           #   NEXT FIELD o_aba00
           #END IF
           #No.FUN-CC0093 ---end  --- Mark
            IF NOT cl_null(tm.o_aba00) THEN   #No.FUN-CC0093   Add
            #No.FUN-670005--begin
             CALL s_check_bookno(tm.o_aba00,g_user,g_plant) 
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                  NEXT FIELD o_aba00 
             END IF 
            #No.FUN-670005--end  
            SELECT aaa01 FROM aaa_file
             WHERE aaa01 = tm.o_aba00
               AND aaaacti= 'Y'
 
            IF SQLCA.sqlcode THEN
#              CALL cl_err(tm.o_aba00,'agl-095',0)   #No.FUN-660123
               CALL cl_err3("sel","aaa_file",tm.o_aba00,"","agl-095","","",0)   #No.FUN-660123
               NEXT FIELD o_aba00
            END IF
            END IF         #No.FUN-CC0093   Add
 
         AFTER FIELD o_aba01
           #No.FUN-CC0093 ---start--- Mark
           #IF cl_null(tm.o_aba01) THEN
           #   NEXT FIELD o_aba01
           #END IF
           #No.FUN-CC0093 ---end  --- Mark
            IF NOT cl_null(tm.o_aba01) THEN   #No.FUN-CC0093   Add 
            SELECT aac01 FROM aac_file
             WHERE aac01 = tm.o_aba01
               AND aacacti= 'Y'
 
            IF SQLCA.sqlcode THEN
#              CALL cl_err(tm.o_aba01,'agl-095',0)   #No.FUN-660123
               CALL cl_err3("sel","aac_file",tm.o_aba01,"","agl-095","","",0)   #No.FUN-660123
               NEXT FIELD o_aba01
            END IF
            END IF        #No.FUN-CC0093   Add
 
         AFTER FIELD n_aba00
           #No.FUN-CC0093 ---start--- Mark
           #IF cl_null(tm.n_aba00) THEN
           #   NEXT FIELD n_aba00
           #END IF
           #No.FUN-CC0093 ---end  --- Mark
            IF NOT cl_null(tm.n_aba00) THEN   #No.FUN-CC0093   Add
            #No.FUN-670005--begin
             CALL s_check_bookno(tm.n_aba00,g_user,g_plant) 
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                  NEXT FIELD n_aba00 
             END IF 
            #No.FUN-670005--end  
            SELECT aaa01 FROM aaa_file
             WHERE aaa01 = tm.n_aba00
               AND aaaacti= 'Y'
 
            IF SQLCA.sqlcode THEN
#              CALL cl_err(tm.n_aba00,'agl-095',0)   #No.FUN-660123
               CALL cl_err3("sel","aaa_file",tm.n_aba00,"","agl-095","","",0)   #No.FUN-660123
               NEXT FIELD n_aba00
            END IF
            END IF    #No.FUN-CC0093   Add
 
         AFTER FIELD n_aba01
           #No.FUN-CC0093 ---start--- Mark
           #IF cl_null(tm.n_aba01) THEN
           #   NEXT FIELD n_aba01
           #END IF
           #No.FUN-CC0093 ---end  --- Mark
            IF NOT cl_null(tm.n_aba01) THEN   #No.FUN-CC0093   Add 
            SELECT aac01 FROM aac_file
             WHERE aac01 = tm.n_aba01
               AND aacacti= 'Y'
 
            IF SQLCA.sqlcode THEN
#              CALL cl_err(tm.n_aba01,'agl-095',0)   #No.FUN-660123
               CALL cl_err3("sel","aac_file",tm.n_aba01,"","agl-095","","",0)   #No.FUN-660123
               NEXT FIELD n_aba01
            END IF
            END IF     #No.FUN-CC0093    Add
 
         AFTER FIELD b_aba02
           #No.FUN-CC0093 ---start--- Mark
           #IF cl_null(tm.b_aba02) THEN
           #   NEXT FIELD b_aba02
           #END IF
           #No.FUN-CC0093 ---end  --- Mark
           #No.FUN-CC0093 ---start--- Add
            IF NOT cl_null(tm.b_aba02) AND NOT cl_null(tm.e_aba02) THEN
               IF tm.e_aba02 < tm.b_aba02 THEN
                  NEXT FIELD b_aba02
               END IF
            END IF
           #No.FUN-CC0093 ---end  --- Add
 
         AFTER FIELD e_aba02
           #No.FUN-CC0093 ---start--- Mark
           #IF cl_null(tm.e_aba02) THEN
           #   NEXT FIELD e_aba02
           #END IF
           #IF tm.e_aba02 < tm.b_aba02 THEN
           #   NEXT FIELD e_aba02
           #END IF
           #No.FUN-CC0093 ---end  --- Mark
             
           #No.FUN-CC0093 ---start--- Add
            IF NOT cl_null(tm.b_aba02) AND NOT cl_null(tm.e_aba02) THEN
               IF tm.e_aba02 < tm.b_aba02 THEN
                  NEXT FIELD e_aba02
               END IF
            END IF
           #No.FUN-CC0093 ---end  --- Add
 
         AFTER FIELD b_aba01
            LET tm.e_aba01=tm.b_aba01
            DISPLAY tm.e_aba01 TO FORMONLY.e_aba01
 
         AFTER FIELD e_aba01
            IF tm.e_aba01 < tm.b_aba01 THEN
               NEXT FIELD e_aba01
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
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(o_aba00) #帳別
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_aaa'
                  LET g_qryparam.default1 = tm.o_aba00
                  CALL cl_create_qry() RETURNING tm.o_aba00
                  DISPLAY tm.o_aba00 TO FORMONLY.o_aba00
                  NEXT FIELD o_aba00
               WHEN INFIELD(n_aba00) #帳別
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_aaa'
                  LET g_qryparam.default1 = tm.n_aba00
                  CALL cl_create_qry() RETURNING tm.n_aba00
                  DISPLAY tm.n_aba00 TO FORMONLY.n_aba00
                  NEXT FIELD n_aba00
               WHEN INFIELD(o_aba01) #單據性質
                 #CALL q_aac(FALSE,TRUE,tm.o_aba01,'','','',g_sys) RETURNING tm.o_aba01  #TQC-670008 remark
                  CALL q_aac(FALSE,TRUE,tm.o_aba01,'','','','AGL') RETURNING tm.o_aba01  #TQC-670008
                  DISPLAY tm.o_aba01 TO FORMONLY.o_aba01
                  NEXT FIELD o_aba01
               WHEN INFIELD(n_aba01) #單據性質
                 #CALL q_aac(FALSE,TRUE,tm.n_aba01,' ',' ',' ',g_sys)  RETURNING tm.n_aba01  #TQC-670008
                  CALL q_aac(FALSE,TRUE,tm.n_aba01,' ',' ',' ','AGL')  RETURNING tm.n_aba01  #TQC-670008
                   DISPLAY tm.n_aba01 TO FORMONLY.n_aba01
                   NEXT FIELD n_aba01
            END CASE
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION locale
            CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            LET g_action_choice = "locale"
 
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
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r931_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file      #get exec cmd (fglgo xxxx)
          WHERE zz01='aglr931'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglr931','9031',1)   
         ELSE
            LET l_cmd = l_cmd CLIPPED,            #(at time fglgo xxxx p1 p2 p3)
                        " '",g_bookno  CLIPPED,"'",
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.o_aba00 CLIPPED,"'",
                        " '",tm.o_aba01 CLIPPED,"'",
                        " '",tm.n_aba00 CLIPPED,"'",
                        " '",tm.n_aba01 CLIPPED,"'",
                        " '",tm.b_aba02 CLIPPED,"'",
                        " '",tm.e_aba02 CLIPPED,"'",
                        " '",tm.b_aba01 CLIPPED,"'",
                        " '",tm.e_aba01 CLIPPED,"'",
                        " '",tm.pers CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aglr931',g_time,l_cmd)      # Execute cmd at later time
         END IF
 
         CLOSE WINDOW r931_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL aglr931()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r931_w
 
END FUNCTION
 
FUNCTION aglr931()
   DEFINE l_name      LIKE type_file.chr20,             # External(Disk) file name        #No.FUN-680098  VARCHAR(20)
#       l_time          LIKE type_file.chr8          #No.FUN-6A0073
          l_sql       LIKE type_file.chr1000,           # RDSQL STATEMENT        #No.FUN-680098   VARCHAR(1000)
          l_chr       LIKE type_file.chr1,          #No.FUN-680098char(1)
#         b_aba01     VARCHAR(12),
          b_aba01     LIKE aba_file.aba01,            #NO.Fun-550028 #No.FUN-680098 VARCHAR(16)
#         e_aba01     VARCHAR(12),
          e_aba01      LIKE aba_file.aba01,          #NO.Fun-550028  #No.FUN-680098 VARCHAR(16)  
          l_aba       RECORD LIKE aba_file.*,
          l_abb       RECORD LIKE abb_file.*,
          l_abm       RECORD LIKE abm_file.*         #FUN-C40112 Add
          
   #No.FUN-750129  --Begin
   CALL cl_del_data(l_table)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   #No.FUN-750129  --End
   
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = g_bookno
      AND aaf02 = g_lang
 
   #FUN-C40112-mark begin---
   #LET l_sql="SELECT *",
   #          "  FROM aba_file,abb_file",
   #          " WHERE aba00=abb00 AND aba01=abb01 AND aba00='",tm.o_aba00,"'",
   #         #"   AND aba01[1,5]='",tm.o_aba01,"'",
   #          "   AND aba01 like '",tm.o_aba01 CLIPPED,"-%'",   #NO.Fun-550028
   #          "   AND aba02 BETWEEN '",tm.b_aba02,"' AND '",tm.e_aba02,"' "
   #FUN-C40112-mark end-----

   #FUN-C40112-add begin---
   LET l_sql = "SELECT *",
               "  FROM aba_file, abm_file, abb_file",
               " WHERE aba00 = abm02 AND aba01 = abm03",
               "   AND aba00 = abb00 AND aba01=abb01",
               "   AND aba00 = '",tm.o_aba00,"'",
               "   AND aba01 like '",tm.o_aba01 CLIPPED,"-%'",
               "   AND aba02 BETWEEN '",tm.b_aba02,"' AND '",tm.e_aba02,"' ",
               "   AND abm05 = '",tm.n_aba00,"'",
               "   AND abm06 like '",tm.n_aba01 CLIPPED,"-%'"
   #FUN-C40112-add end-----

   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET l_sql = l_sql CLIPPED," AND abauser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET l_sql = l_sql CLIPPED," AND abagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET l_sql = l_sql CLIPPED," AND abagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET l_sql = l_sql CLIPPED,cl_get_extra_cond('abauser', 'abagrup')
   #End:FUN-980030
 
 
   IF tm.b_aba01 IS NOT NULL AND tm.e_aba01 IS NOT NULL THEN
      LET l_sql = l_sql CLIPPED,
                  " AND aba01 BETWEEN '",tm.b_aba01,"' AND '",tm.e_aba01,"'"
   END IF
 
   IF tm.pers IS NOT NULL AND tm.pers IS NOT NULL THEN
      LET l_sql = l_sql CLIPPED, " AND abauser= '",tm.pers,"'"
   END IF
 
   PREPARE r931_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   DECLARE r931_cs1 CURSOR FOR r931_prepare1
 
   #No.FUN-750129  --Begin
   #CALL cl_outnam('aglr931') RETURNING l_name
   #START REPORT r931_rep TO l_name
   #No.FUN-750129  --End
 
   #FOREACH r931_cs1 INTO l_aba.*,l_abb.*,l_abm.*      #FUN-C40112 add l_abm.*  #TQC-CB0077 mark
   FOREACH r931_cs1 INTO l_aba.*,l_abm.*,l_abb.*       #TQC-CB0077 mod
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #No.FUN-750129  --Begin
      #OUTPUT TO REPORT r931_rep(l_aba.*,l_abb.*)
      #CALL r931_insert(l_aba.*,l_abb.*)              #FUN-C40112 mark
      CALL r931_insert(l_aba.*,l_abb.*,l_abm.*)       #FUN-C40112 add
      #No.FUN-750129  --End
 
   END FOREACH
 
   #-- 找出無對應'原始傳票'者 -----------------
   IF tm.b_aba01 IS NOT NULL AND tm.e_aba01 IS NOT NULL THEN
#      LET b_aba01=tm.n_aba01,'-',tm.b_aba01[5,12]
      LET b_aba01=tm.n_aba01,'-',tm.b_aba01[g_no_sp,g_no_ep]  #No.FUN-550028
#      LET e_aba01=tm.n_aba01,'-',tm.e_aba01[5,12]
      LET e_aba01=tm.n_aba01,'-',tm.e_aba01[g_no_sp,g_no_ep]  #No.FUN-550028
   ELSE
      LET b_aba01='000000000000' # 配合l_sql使用 NOT IN 作法故賦予起始截止編號
      LET e_aba01='ZZZZZZZZZZZZ'
   END IF
 
   #FUN-C40112-mark begin---
   #LET l_sql="SELECT *,'','','','','','','','','','','','','','','',''",
   #          " FROM aba_file",
   #         #" WHERE aba00='",tm.n_aba00,"' AND aba01[1,5]='",tm.n_aba01,"'",
   #          " WHERE aba00='",tm.n_aba00,"' AND aba01 like '",tm.n_aba01,"-%'",  #No.FUN-550028
   #          "   AND aba02 BETWEEN '",tm.b_aba02,"' AND '",tm.e_aba02,"' " ,
   #          "   AND aba01 NOT IN (SELECT aba17 FROM aba_file",
   #          "       WHERE aba17 BETWEEN '",b_aba01,"' AND '",e_aba01,"'",
   #         #"         AND aba00='",tm.n_aba00,"')"                              #no.7277 #MOD-C30026 mark
   #          "         AND aba00='",tm.o_aba00,"')"                              #MOD-C30026 add
   #FUN-C40112-mark end-----

   #FUN-C40112-add begin---
   LET l_sql = "SELECT *,'','','','','','','','','','','','','','','',''",
               "  FROM aba_file",
               " WHERE aba00='",tm.o_aba00,"' AND aba01 like '",tm.o_aba01,"-%'",
               "   AND aba02 BETWEEN '",tm.b_aba02,"' AND '",tm.e_aba02,"' " ,
               "   AND aba19 <> 'X'",   #CHI-C80041
               "   AND aba01 NOT IN (SELECT abm03 FROM abm_file",
               "                      WHERE abm02 ='",tm.o_aba00,"'",
               "                        AND abm03 like '",tm.o_aba01 CLIPPED,"-%'",
               "                        AND abm03 BETWEEN '",b_aba01,"' AND '",e_aba01,"'",
               "                        AND abm05 ='",tm.n_aba00,"'",
               "                        AND abm06 like '",tm.n_aba01 CLIPPED,"-%')"
   #FUN-C40112-add end-----

   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET l_sql = l_sql clipped," AND abauser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET l_sql=l_sql clipped," AND abagrup MATCHES '", g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET l_sql=l_sql clipped," AND abagrup IN ",cl_chk_tgrup_list()
   #   END IF
   #End:FUN-980030
 
 
   PREPARE r931_prepare2 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare2:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   DECLARE r931_cs2 CURSOR FOR r931_prepare2
 
   FOREACH r931_cs2 INTO l_aba.*,l_abb.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #No.FUN-750129  --Begin
      #OUTPUT TO REPORT r931_rep(l_aba.*,l_abb.*)
      #CALL r931_insert(l_aba.*,l_abb.*)           #FUN-C40112 Mark
      CALL r931_insert(l_aba.*,l_abb.*,l_abm.*)    #FUN-C40112 Add
      #No.FUN-750129  --End
   END FOREACH
   #-----------------------------------------
 
   #No.FUN-750129  --Begin
   #FINISH REPORT r931_rep
   #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = ''
   CALL cl_prt_cs3('aglr931','aglr931',g_sql,g_str)
   #No.FUN-750129  --End
 
END FUNCTION
 
#No.FUN-750129  --Begin
FUNCTION r931_insert(p_aba,p_abb,p_abm)        #FUN-C40112 add p_abm
#FUNCTION r931_insert(p_aba,p_abb)             #FUN-C40112 mark
DEFINE p_aba    RECORD LIKE aba_file.*
DEFINE p_abb    RECORD LIKE abb_file.*
DEFINE p_abm    RECORD LIKE abm_file.*       #FUN-C40112 Add
DEFINE m_aba    RECORD LIKE aba_file.*
DEFINE m_abb    RECORD LIKE abb_file.*
DEFINE m_abm    RECORD LIKE abm_file.*       #FUN-C40112 Add
DEFINE flag     LIKE type_file.num5
 
      IF p_abb.abb00!=' ' AND p_abb.abb00 IS NOT NULL AND
         p_abb.abb01!=' ' AND p_abb.abb01 IS NOT NULL THEN
         LET flag=0
        #FUN-C40112-Mark Begin---
        #SELECT * INTO m_aba.* FROM aba_file
        # WHERE aba00 = p_aba.aba16
        #   AND aba01 = p_aba.aba17
        #FUN-C40112-Mark End-----

        #FUN-C40112-Add Begin---
         SELECT * INTO m_aba.*,m_abm.* FROM aba_file,abm_file
          WHERE aba00 = abm02 AND aba01 = abm03
            AND abm05 = p_abm.abm05
            AND abm06 = p_abm.abm06
        #FUN-C40112-Add End-----

         IF STATUS=100 THEN
            EXECUTE insert_prep USING
                    p_aba.aba02,p_aba.aba01,p_abb.abb02,p_aba.aba06,
                   #p_aba.aba16,p_aba.aba17,'1'                        #FUN-C40112 Mark     #g_x[11]
                    p_abm.abm05,p_abm.abm06,'1'                        #FUN-C40112 Add
            LET flag=1
         ELSE
            IF p_aba.aba08!=m_aba.aba08 OR p_aba.aba09!=m_aba.aba09 THEN
               EXECUTE insert_prep USING
                       p_aba.aba02,p_aba.aba01,p_abb.abb02,p_aba.aba06,
                      #p_aba.aba16,p_aba.aba17,'2'                     #FUN-C40112 Mark     #g_x[9]
                       p_abm.abm05,p_abm.abm06,'2'                     #FUN-C40112 Add
            END IF
         END IF
      END IF
      IF (p_abb.abb00=' ' OR p_abb.abb00 IS NULL) AND
         (p_abb.abb01=' ' OR p_abb.abb01 IS NULL) THEN
         EXECUTE insert_prep USING
                 p_aba.aba02,p_aba.aba01,'',p_aba.aba06,
                 '','','3'  #g_x[17]
      ELSE
         IF flag=0 THEN
            SELECT * INTO m_abb.* FROM abb_file
            #WHERE abb00 = p_aba.aba16              #FUN-C40112 Mark
            #  AND abb01 = p_aba.aba17              #FUN-C40112 Mark
             WHERE abb00 = p_abm.abm05              #FUN-C40112 Add
               AND abb01 = p_abm.abm06              #FUN-C40112 Add
               AND abb02 = p_abb.abb02
            IF STATUS=100 THEN
               EXECUTE insert_prep USING
                       p_aba.aba02,p_aba.aba01,p_abb.abb02,p_aba.aba06,
                      #p_aba.aba16,p_aba.aba17,'4'                    #FUN-C40112 Mark      #g_x[10]
                       p_abm.abm05,p_abm.abm06,'4'                    #FUN-C40112 Add
            ELSE
               IF p_abb.abb03!=m_abb.abb03 THEN
                  EXECUTE insert_prep USING
                          p_aba.aba02,p_aba.aba01,p_abb.abb02,p_aba.aba06,
                         #p_aba.aba16,p_aba.aba17,'5'                 #FUN-C40112 Mark      #g_x[12]
                          p_abm.abm05,p_abm.abm06,'5'                 #FUN-C40112 Add
               END IF
               IF p_abb.abb11!=m_abb.abb11 OR p_abb.abb12!=m_abb.abb12 OR
                  p_abb.abb13!=m_abb.abb13 OR p_abb.abb14!=m_abb.abb14 OR
                  p_abb.abb31!=m_abb.abb31 OR p_abb.abb32!=m_abb.abb32 OR
                  p_abb.abb33!=m_abb.abb33 OR p_abb.abb34!=m_abb.abb34 OR
                  p_abb.abb35!=m_abb.abb35 OR p_abb.abb36!=m_abb.abb36 OR
                  p_abb.abb37!=m_abb.abb37 THEN
                  EXECUTE insert_prep USING
                          p_aba.aba02,p_aba.aba01,p_abb.abb02,p_aba.aba06,
                         #p_aba.aba16,p_aba.aba17,'6'                 #FUN-C40112 Mark      #g_x[13]
                          p_abm.abm05,p_abm.abm06,'6'                 #FUN-C40112 Add
               END IF
               IF p_abb.abb05!=m_abb.abb05 THEN
                  EXECUTE insert_prep USING
                          p_aba.aba02,p_aba.aba01,p_abb.abb02,p_aba.aba06,
                         #p_aba.aba16,p_aba.aba17,'7'                 #FUN-C40112 Mark      #g_x[14]
                          p_abm.abm05,p_abm.abm06,'7'                 #FUN-C40112 Add
               END IF
               IF p_abb.abb06!=m_abb.abb06 THEN
                  EXECUTE insert_prep USING
                          p_aba.aba02,p_aba.aba01,p_abb.abb02,p_aba.aba06,
                         #p_aba.aba16,p_aba.aba17,'8'                 #FUN-C40112 Mark      #g_x[15]
                          p_abm.abm05,p_abm.abm06,'8'                 #FUN-C40112 Add
               END IF
               IF p_abb.abb07!=m_abb.abb07 THEN
                  EXECUTE insert_prep USING
                          p_aba.aba02,p_aba.aba01,p_abb.abb02,p_aba.aba06,
                         #p_aba.aba16,p_aba.aba17,'9'                 #FUN-C40112 Mark      #g_x[16]
                          p_abm.abm05,p_abm.abm06,'9'                 #FUN-C40112 Add
               END IF
            END IF
         END IF
      END IF
 
END FUNCTION
{
REPORT r931_rep(sr,sr1)
   DEFINE l_last_sw     LIKE type_file.chr1,     #No.FUN-680098   VARCHAR(1)
          l_dash        LIKE type_file.chr1,     #No.FUN-680098   VARCHAR(1)
          l_trailer_sw  LIKE type_file.chr1,     #No.FUN-680098   VARCHAR(1)
          sr            RECORD LIKE aba_file.*,
          sr1           RECORD LIKE abb_file.*,
          l_sql         LIKE type_file.chr1000,   #No.FUN-680098 VARCHAR(600)
          flag          LIKE type_file.num5,      #No.FUN-680098  smallint 
          l_aba         RECORD LIKE aba_file.*,
          m_aba         RECORD LIKE aba_file.*,
          m_abb         RECORD LIKE abb_file.*
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.aba02,sr.aba01
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         PRINT
         PRINT g_dash[1,g_len]
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
         PRINT g_dash1
         LET l_trailer_sw = 'y'
 
      BEFORE GROUP OF sr.aba01
         IF sr1.abb00!=' ' AND sr1.abb00 IS NOT NULL AND
            sr1.abb01!=' ' AND sr1.abb01 IS NOT NULL THEN
            LET flag=0
            SELECT * INTO m_aba.* FROM aba_file
             WHERE aba00 = sr.aba16
               AND aba01 = sr.aba17
            IF STATUS=100 THEN
               PRINT COLUMN g_c[31],sr.aba02,
                     COLUMN g_c[32],sr.aba01,
                     COLUMN g_c[33],sr1.abb02 USING '###&', #FUN-590118
                     COLUMN g_c[34],sr.aba06,
                     COLUMN g_c[35],sr.aba16,
                     COLUMN g_c[36],sr.aba17,
                     COLUMN g_c[37],g_x[11] CLIPPED
               LET flag=1
            ELSE
               IF sr.aba08!=m_aba.aba08 OR sr.aba09!=m_aba.aba09 THEN
                  PRINT COLUMN g_c[31],sr.aba02,
                        COLUMN g_c[32],sr.aba01,
                        COLUMN g_c[33],sr1.abb02 USING '--&',
                        COLUMN g_c[34],sr.aba06,
                        COLUMN g_c[35],sr.aba16,
                        COLUMN g_c[36],sr.aba17,
                        COLUMN g_c[37],g_x[9] CLIPPED
               END IF
            END IF
         END IF
 
      ON EVERY ROW
         IF (sr1.abb00=' ' OR sr1.abb00 IS NULL) AND
            (sr1.abb01=' ' OR sr1.abb01 IS NULL) THEN
            PRINT COLUMN g_c[31],sr.aba02,
                  COLUMN g_c[32],sr.aba01,
                  COLUMN g_c[34],sr.aba06,
                  COLUMN g_c[37],g_x[17] CLIPPED
         ELSE
            IF flag=0 THEN
               SELECT * INTO m_abb.* FROM abb_file
                WHERE abb00 = sr.aba16
                  AND abb01 = sr.aba17
                  AND abb02 = sr1.abb02
               IF STATUS=100 THEN
                  PRINT COLUMN g_c[31],sr.aba02,
                        COLUMN g_c[32],sr.aba01,
                        COLUMN g_c[33],sr1.abb02 USING '###&', #FUN-590118
                        COLUMN g_c[34],sr.aba06,
                        COLUMN g_c[35],sr.aba16,
                        COLUMN g_c[36],sr.aba17,
                        COLUMN g_c[37],g_x[10] CLIPPED
               ELSE
                  IF sr1.abb03!=m_abb.abb03 THEN
                     PRINT COLUMN g_c[31],sr.aba02,
                           COLUMN g_c[32],sr.aba01,
                           COLUMN g_c[33],sr1.abb02 USING '###&', #FUN-590118
                           COLUMN g_c[34],sr.aba06,
                           COLUMN g_c[35],sr.aba16,
                           COLUMN g_c[36],sr.aba17,
                           COLUMN g_c[37],g_x[12] CLIPPED
                  END IF
                 #FUN-5C0015-----------------------------------------------(S)
                 #IF sr1.abb11!=m_abb.abb11 OR sr1.abb12!=m_abb.abb12 OR
                 #   sr1.abb13!=m_abb.abb13 OR sr1.abb14!=m_abb.abb14 THEN
                  IF sr1.abb11!=m_abb.abb11 OR sr1.abb12!=m_abb.abb12 OR
                     sr1.abb13!=m_abb.abb13 OR sr1.abb14!=m_abb.abb14 OR
                     sr1.abb31!=m_abb.abb31 OR sr1.abb32!=m_abb.abb32 OR
                     sr1.abb33!=m_abb.abb33 OR sr1.abb34!=m_abb.abb34 OR
                     sr1.abb35!=m_abb.abb35 OR sr1.abb36!=m_abb.abb36 OR
                     sr1.abb37!=m_abb.abb37 THEN
                 #FUN-5C0015-----------------------------------------------(E)
                     PRINT COLUMN g_c[31],sr.aba02,
                           COLUMN g_c[32],sr.aba01,
                           COLUMN g_c[33],sr1.abb02 USING '###&', #FUN-590118
                           COLUMN g_c[34],sr.aba06,
                           COLUMN g_c[35],sr.aba16,
                           COLUMN g_c[36],sr.aba17,
                           COLUMN g_c[37],g_x[13] CLIPPED
                  END IF
                  IF sr1.abb05!=m_abb.abb05 THEN
                     PRINT COLUMN g_c[31],sr.aba02,
                           COLUMN g_c[32],sr.aba01,
                           COLUMN g_c[33],sr1.abb02 USING '###&', #FUN-590118
                           COLUMN g_c[34],sr.aba06,
                           COLUMN g_c[35],sr.aba16,
                           COLUMN g_c[36],sr.aba17,
                           COLUMN g_c[37],g_x[14] CLIPPED
                  END IF
                  IF sr1.abb06!=m_abb.abb06 THEN
                     PRINT COLUMN g_c[31],sr.aba02,
                           COLUMN g_c[32],sr.aba01,
                           COLUMN g_c[33],sr1.abb02 USING '###&', #FUN-590118
                           COLUMN g_c[34],sr.aba06,
                           COLUMN g_c[35],sr.aba16,
                           COLUMN g_c[36],sr.aba17,
                           COLUMN g_c[37],g_x[15] CLIPPED
                  END IF
                  IF sr1.abb07!=m_abb.abb07 THEN
                     PRINT COLUMN g_c[31],sr.aba02,
                           COLUMN g_c[32],sr.aba01,
                           COLUMN g_c[33],sr1.abb02 USING '###&', #FUN-590118
                           COLUMN g_c[34],sr.aba06,
                           COLUMN g_c[35],sr.aba16,
                           COLUMN g_c[36],sr.aba17,
                           COLUMN g_c[37],g_x[16] CLIPPED
                  END IF
               END IF
            END IF
         END IF
 
      ON LAST ROW
         PRINT g_dash[1,g_len]
         LET l_trailer_sw = 'n'
        #PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[37],g_x[7] CLIPPED     #TQC-6B0011 mark
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED   #TQC-6B0011
 
      PAGE TRAILER
         IF l_trailer_sw = 'y' THEN
            PRINT g_dash[1,g_len]
           #PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[37],g_x[6] CLIPPED     #TQC-6B0011 mark
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED   #TQC-6B0011
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT
}
#No.FUN-750129  --End
