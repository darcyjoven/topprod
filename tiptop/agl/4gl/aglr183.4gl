# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: aglr183.4gl
# Descriptions...: 部門全年度實際預算比較報表列印
# Date & Author..: 96/09/05 By Melody
# Modify.........: No.FUN-510007 05/02/02 By Nicola 報表架構修改
# Modify.........: NO.FUN-590002 05/12/27By Monster radio type 應都要給預設值
# Modify.........: No.TQC-620001 06/02/07 By Smapmin 將CHAR(12)改為CHAR(13)
# Modify.........: No.FUN-660147 06/06/27 By Smapmin 修改部門輸入限制
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680098 06/08/31 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6C0012 06/12/26 By Judy 新增打印額外名稱欄位
# Modify.........: No.FUN-740020 07/04/12 By Lynn 會計科目加帳套
# Modify.........: No.MOD-740248 07/04/22 By Sarah 重新過單
# Modify.........: No.FUN-780060 07/09/04 By destiny 報表格式改為CR輸出
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B20054 11/02/23 By lixiang 先錄入帳套,科目根據帳套過濾;結構改為DIALOG 
# Modify.........: No:FUN-D70095 13/07/18 BY fengmy CE类凭证结转科目部门统计档，报表打印时应减回CE类凭证
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
                 wc     LIKE type_file.chr1000,      #No.FUN-680098  VARCHAR(200)
                 bdept,edept  LIKE type_file.chr8,   #No.FUN-680098  VARCHAR(8)  
                 defyy  LIKE type_file.num5,         #輸入基準年度   #No.FUN-680098  smallint
                 defbm  LIKE type_file.num5,         #輸入基準月份起 #No.FUN-680098  smallint
                 defem  LIKE type_file.num5,         #輸入基準月份止 #No.FUN-680098  smallint
                 comyy  LIKE type_file.num5,         #輸入比較年度   #No.FUN-680098  smallint   
                 combm  LIKE type_file.num5,         #輸入比較月份起 #No.FUN-680098  smallint
                 comem  LIKE type_file.num5,         #輸入比較月份止 #No.FUN-680098  smallint
                 type   LIKE type_file.chr1,         #費用類別       #No.FUN-680098  VARCHAR(1)
                 diff1  LIKE aah_file.aah04,         #差異金額       #No.FUN-680098  dec(20,6)
                 diff2  LIKE aah_file.aah04,         #差異金額百分比 #No.FUN-680098  dec(20,6)
                 e      LIKE type_file.chr1,         #列印額外名稱 #FUN-6C0012
                 more   LIKE type_file.chr1          #Input more condition(Y/N)#No.FUN-680098 VARCHAR(1)
              END RECORD,
          l_buf        LIKE type_file.chr1000,       #No.FUN-680098 VARCHAR(10)
          bookno     LIKE aah_file.aah00, #帳別    #No.FUN-740020
          t_defcharge  LIKE aao_file.aao05,
          l_flag       LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
   DEFINE g_i          LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098 SMALLINT
#No.FUN-780060--start--add                                                                                                          
   DEFINE g_sql       STRING                                                                                                        
   DEFINE l_table     STRING                                                                                                        
   DEFINE g_str       STRING                                                                                                        
#No.FUN-780060--end-- 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
#No.FUN-780060--start--add                                                                                                          
   LET g_sql="aao00.aao_file.aao00,",                                                                                               
             "aao01.aao_file.aao01,",
             "aao05.aao_file.aao05,",
             "aao06.aao_file.aao06,",
             "aag13.aag_file.aag13,",
             "lastcharge.aao_file.aao05"
   LET l_table = cl_prt_temptable('aglr183',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?,?)"                                                                                     
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
#No.FUN-780060--end--add
   LET bookno = ARG_VAL(1)      #No.FUN-740020
   LET g_pdate = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc    = ARG_VAL(8)
   LET tm.bdept = ARG_VAL(9)   #TQC-610056
   LET tm.edept = ARG_VAL(10)  #TQC-610056
   LET tm.defyy = ARG_VAL(11)
   LET tm.defbm = ARG_VAL(12)
   LET tm.defem = ARG_VAL(13)
   LET tm.comyy = ARG_VAL(14)
   LET tm.combm = ARG_VAL(15)
   LET tm.comem = ARG_VAL(16)
   LET tm.type  = ARG_VAL(17)
   LET tm.diff1 = ARG_VAL(18)
   LET tm.diff2 = ARG_VAL(19)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(20)
   LET g_rep_clas = ARG_VAL(21)
   LET g_template = ARG_VAL(22)
   #No.FUN-570264 ---end---
   LET tm.e     =ARG_VAL(23)   #FUN-6C0012
   LET g_rpt_name = ARG_VAL(24)  #No.FUN-7C0078
 
   IF cl_null(bookno) THEN   #No.FUN-740020
      LET bookno = g_aza.aza81   #No.FUN-740020
   END IF
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r183_tm()
   ELSE
      CALL r183()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION r183_tm()
   DEFINE lc_qbe_sn     LIKE gbm_file.gbm01     #No.FUN-580031
   DEFINE p_row,p_col   LIKE type_file.num5,    #No.FUN-680098 smallint
          l_sw          LIKE type_file.chr1,    #重要欄位是否空白 #No.FUN-680098 VARCHAR(1)
          l_cmd         LIKE type_file.chr1000  #No.FUN-680098  VARCHAR(400)
   DEFINE li_chk_bookno LIKE type_file.num5     #FUN-B20054
   
   CALL s_dsmark(bookno)   #No.FUN-740020
   LET p_row = 3 LET p_col = 26
   OPEN WINDOW r183_w AT p_row,p_col
     WITH FORM "agl/42f/aglr183"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL s_shwact(0,0,bookno)   #No.FUN-740020
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.defyy=YEAR(g_today)
   LET tm.defbm=MONTH(g_today)
   LET tm.defem=MONTH(g_today)
   LET tm.type = ' '
   LET tm.e    = 'N'   #FUN-6C0012
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET l_flag   ='Y'
   LET t_defcharge=0
 
   WHILE TRUE
    #NO.FUN-590002--START----
    LET tm.type = 'M'
    #NO.FUN-590002--END----

    #FUN-B20054--add--str--
    LET l_sw = 1
    DIALOG ATTRIBUTE(unbuffered)
       INPUT BY NAME bookno ATTRIBUTE(WITHOUT DEFAULTS)
          AFTER FIELD bookno 
            IF NOT cl_null(bookno) THEN
                   CALL s_check_bookno(bookno,g_user,g_plant)
                    RETURNING li_chk_bookno
                IF (NOT li_chk_bookno) THEN
                    NEXT FIELD bookno
                END IF
                SELECT aaa02 FROM aaa_file WHERE aaa01 = bookno
                IF STATUS THEN
                   CALL cl_err3("sel","aaa_file",bookno,"","agl-043","","",0)
                   NEXT FIELD bookno
                END IF
            END IF
       END INPUT
     #FUN-B20054--add--end
      CONSTRUCT BY NAME tm.wc ON aag01

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
#      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup') #FUN-980030
# 
#      IF g_action_choice = "locale" THEN
#         LET g_action_choice = ""
#         CALL cl_dynamic_locale()
#         CONTINUE WHILE
#      END IF
# 
#      IF INT_FLAG THEN
#         LET INT_FLAG = 0
#         CLOSE WINDOW aglr183_w
#         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#         EXIT PROGRAM
#      END IF
# 
#      LET l_sw = 1
#FUN-B20054--mark--end
         
#      INPUT BY NAME bookno,tm.bdept,tm.edept,tm.defyy,tm.defbm,tm.defem,tm.comyy,    #No.FUN-740020
#                    tm.combm,tm.comem,tm.diff1,tm.diff2,tm.type,tm.e,tm.more WITHOUT DEFAULTS   #FUN-6C0012 #FUN-B20054
      INPUT BY NAME tm.bdept,tm.edept,tm.defyy,tm.defbm,tm.defem,tm.comyy,
                    tm.combm,tm.comem,tm.diff1,tm.diff2,tm.type,tm.e,tm.more
                    ATTRIBUTE(WITHOUT DEFAULTS)  #FUN-B20054
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD bdept
            IF cl_null(tm.bdept) THEN
               NEXT FIELD bdept
            END IF
#FUN-B20054--mark--str--  
#         #No.FUN-740020 --begin                                                                                                     
#         AFTER FIELD bookno                                                                                                         
#            IF cl_null(bookno) THEN                                                                                              
#               NEXT FIELD bookno                                                                                                    
#            END IF                                                                                                                  
#         #No.FUN-740020 --end
#FUN-B20054--mark--end 

         AFTER FIELD edept
            IF cl_null(tm.edept) THEN
               NEXT FIELD edept
            END IF
            #-----FUN-660147---------
            IF tm.edept < tm.bdept THEN
               NEXT FIELD edept
            END IF
            #-----END FUN-660147
 
         AFTER FIELD defyy
            IF tm.defyy IS NULL THEN
               NEXT FIELD defyy
            END IF
 
         AFTER FIELD defbm
            IF tm.defbm IS NULL OR tm.defbm <= 0 OR tm.defbm > 13 THEN
               NEXT FIELD defbm
            END IF
 
         AFTER FIELD defem
            IF tm.defem IS NULL OR tm.defem <= 0 OR tm.defem > 13 OR
               tm.defem < tm.defbm THEN
               NEXT FIELD defem
            END IF
 
         AFTER FIELD comyy
            IF tm.comyy IS NULL THEN
               NEXT FIELD comyy
            END IF
 
         AFTER FIELD combm
            IF tm.combm IS NULL OR tm.combm <= 0 OR tm.combm > 12 THEN
               NEXT FIELD combm
            END IF
 
         AFTER FIELD comem
            IF tm.comem IS NULL OR tm.comem <= 0 OR tm.comem > 12 OR
               tm.comem < tm.combm THEN
               NEXT FIELD comem
            END IF
 
         AFTER FIELD type
            IF tm.type NOT MATCHES '[ MPRS]' THEN
               NEXT FIELD type
            END IF
 
         AFTER FIELD diff1
            IF tm.diff1 IS NULL OR tm.diff1 < 0 THEN
               NEXT FIELD diff1
            END IF
 
         AFTER FIELD diff2
            IF tm.diff2 IS NULL OR tm.diff2 < 0 THEN
               NEXT FIELD diff2
            END IF
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         AFTER INPUT
         #FUN-B20054--mark--str--
         #   IF INT_FLAG THEN
         #      EXIT INPUT
         #   END IF
         #FUN-B20054--mark--end 
            IF tm.defyy IS NULL OR tm.comyy IS NULL THEN
               LET l_sw = 0
               DISPLAY BY NAME tm.defyy,tm.comyy
               CALL cl_err('',9033,0)
            END IF
            IF l_sw = 0 THEN
               LET l_sw = 1
               NEXT FIELD defyy
               CALL cl_err('',9033,0)
            END IF
#FUN-B20054--mark--str-- 
#         ON ACTION CONTROLR
#            CALL cl_show_req_fields()
# 
#         ON ACTION CONTROLG
#            CALL cl_cmdask()
# 
#         #No.FUN-740020  --Begin                                                                                                    
#         ON ACTION CONTROLP                                                                                                         
#          CASE                                                                                                                      
#            WHEN INFIELD(bookno)                                                                                                    
#              CALL cl_init_qry_var()                                                                                                
#              LET g_qryparam.form = 'q_aaa'                                                                                         
#              LET g_qryparam.default1 = bookno                                                                                      
#              CALL cl_create_qry() RETURNING bookno                                                                                 
#              DISPLAY BY NAME bookno                                                                                                
#              NEXT FIELD bookno                                                                                                     
#          END CASE                                                                                                                  
#         #No.FUN-740020  --End
# 
#         ON IDLE g_idle_seconds
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
       ON ACTION CONTROLP
         #No.FUN-740020  --Begin                                                                                                    
          CASE                                                                                                                      
            WHEN INFIELD(bookno)                                                                                                    
              CALL cl_init_qry_var()                                                                                                
              LET g_qryparam.form = 'q_aaa'                                                                                         
              LET g_qryparam.default1 = bookno       #No.TQC-740145
              CALL cl_create_qry() RETURNING bookno                
              DISPLAY BY NAME bookno 
              NEXT FIELD bookno
        #No.FUN-740020  --End
            WHEN INFIELD(aag01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag02"
                LET g_qryparam.state = "c"
                LET g_qryparam.where = " aag00 = '",bookno CLIPPED,"'"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO aag01
                NEXT FIELD aag0    
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
       CLOSE WINDOW r182_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
       EXIT PROGRAM
    END IF

    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup') #FUN-980030
  
  #FUN-B20054--add--end 
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aglr183'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglr183','9031',1)   
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")  #"
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",bookno CLIPPED,"'" ,    #No.FUN-740020
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc    CLIPPED,"'",
                        " '",tm.bdept CLIPPED,"'",
                        " '",tm.edept CLIPPED,"'",
                        " '",tm.defyy CLIPPED,"'",
                        " '",tm.defbm CLIPPED,"'",
                        " '",tm.defem CLIPPED,"'",
                        " '",tm.comyy CLIPPED,"'",
                        " '",tm.combm CLIPPED,"'",
                        " '",tm.comem CLIPPED,"'",
                        " '",tm.type  CLIPPED,"'",
                        " '",tm.diff1 CLIPPED,"'",
                        " '",tm.diff1 CLIPPED,"'",
                        " '",tm.e     CLIPPED,"'",       #FUN-6C0012
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
            CALL cl_cmdat('aglr183',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW r183_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL r183()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r183_w
 
END FUNCTION
 
FUNCTION r183()
   DEFINE l_name    LIKE type_file.chr20,          # External(Disk) file name         #No.FUN-680098 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0073
          l_sql     LIKE type_file.chr1000,        # RDSQL STATEMENT                  #No.FUN-680098char(1000)
          l_aao05   LIKE aao_file.aao05,
          l_aao06   LIKE aao_file.aao06,
          l_aag01   LIKE aag_file.aag01,
          l_gem01   LIKE gem_file.gem01,           #MOD-740248
          sr        RECORD
                       aao00       LIKE aao_file.aao00,   #帳別
                       aao01       LIKE aao_file.aao01,   #科目
                       aao02       LIKE aao_file.aao02,   #部門
                       aao05       LIKE aao_file.aao05,   #借方總和
                       aao06       LIKE aao_file.aao06,   #貸方總和
                       aag02       LIKE aag_file.aag02,   #科目名稱
                       aag13       LIKE aag_file.aag13,   #額外名稱 #FUN-6C0012
                       lastcharge  LIKE aao_file.aao05    #(2)比較:上月實際費用
                    END RECORD
#No.FUN-780060--start--add                                                                                                          
   DEFINE l_tit1    LIKE type_file.chr1000                                                                                          
   DEFINE l_tit2    LIKE type_file.chr1000 
   DEFINE l_tit3    LIKE type_file.chr1000 
#No.FUN-780060--end--
   DEFINE l_CE_sum1    LIKE abb_file.abb07   #FUN-D70095 add
   DEFINE l_CE_sum2    LIKE abb_file.abb07   #FUN-D70095 add
   
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog       #No.FUN-780060                                                    
   CALL cl_del_data(l_table)                                      #No.FUN-780060
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   IF tm.diff1 IS NULL THEN
      LET tm.diff1 = 0
   END IF
 
   IF tm.diff2 IS NULL THEN
      LET tm.diff2 = 0
   END IF
 
   #-->取科目
   LET l_sql = "SELECT aag01,aag02,aag13  FROM aag_file",   #FUN-6C0012
               " WHERE aagacti = 'Y' ",
               "   AND aag03 = '2' AND aag07 IN ('2','3') ",
               "   AND aag00 = '",bookno,"'",     #No.FUN-740020
               "   AND ",tm.wc CLIPPED
 
   PREPARE r183_paag FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   DECLARE r183_caag CURSOR FOR r183_paag
 
   #-->取部門
   LET l_sql = "SELECT gem01 FROM gem_file",
               " WHERE gemacti = 'Y' ",
               "   AND (gem01 BETWEEN '",tm.bdept,"' AND '" ,tm.edept,"')"
 
   IF tm.type='M' THEN                              #管理費用
      LET l_sql=l_sql CLIPPED," AND gem07='M' "     
   END IF
 
   IF tm.type='P' THEN                              #製造費用
      LET l_sql=l_sql CLIPPED," AND gem07='P' "
   END IF
 
   IF tm.type='R' THEN                              #研發費用
      LET l_sql=l_sql CLIPPED," AND gem07='R' "
   END IF
 
   IF tm.type='S' THEN                              #銷售費用
      LET l_sql=l_sql CLIPPED," AND gem07='S' "
   END IF
 
   PREPARE r183_pgem FROM l_sql
   IF STATUS THEN
      CALL cl_err('pre gem:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   DECLARE r183_cgem CURSOR FOR r183_pgem
 
   #-->取基準月份
   LET l_sql="SELECT SUM(aao05),SUM(aao06)  FROM aao_file ",
             " WHERE aao00=? AND aao01=? AND aao02=? ",
             "   AND aao03=",tm.defyy,
             "   AND (aao04 BETWEEN ",tm.defbm ," AND ",tm.defem,")"
 
   PREPARE r183_paaodef FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare1:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   DECLARE r183_caaodef CURSOR FOR r183_paaodef
 
   #-->取基準月份
   LET l_sql="SELECT SUM(aao05),SUM(aao06)  FROM aao_file ",
             " WHERE aao00=? AND aao01=? AND aao02=? ",
             "   AND aao03=",tm.comyy,
             "   AND (aao04 BETWEEN ",tm.combm ," AND ",tm.comem,")"
 
   PREPARE r183_paaocom FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare1:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   DECLARE r183_caaocom CURSOR FOR r183_paaocom
#No.FUN-780060--start--mark
#  CALL cl_outnam('aglr183') RETURNING l_name
#  START REPORT aglr183_rep TO l_name
 
#  LET g_pageno = 0
 
#  CASE
#     WHEN tm.type='M'   #管理費用
#        LET l_buf=g_x[10] CLIPPED
#     WHEN tm.type='P'   #製造費用
#        LET l_buf=g_x[11] CLIPPED
#     WHEN tm.type='R'   #研發費用
#        LET l_buf=g_x[12] CLIPPED
#     WHEN tm.type='S'   #銷售費用
#        LET l_buf=g_x[13] CLIPPED
#     WHEN tm.type=' '   #全公司
#        LET l_buf=g_x[14] CLIPPED
#  END CASE
#No.FUN-780060--end--

#FUN-D70095--------------------------begin
    LET l_sql = "SELECT SUM(abb07) FROM abb_file,aba_file ",
                      " WHERE abb00 = ? ",
                      "   AND aba00 = abb00 AND aba01 = abb01",
                      "   AND abb03 = ? ",
                      "   AND abb05 = ? ",
                      "   AND aba06 = 'CE'  AND abb06 = ? AND aba03 = ? ",
                      "   AND aba04 BETWEEN ? AND ? ",
                      "   AND abapost = 'Y'"
      PREPARE r121_cesum FROM l_sql
      DECLARE r121_cesumc CURSOR FOR r121_cesum
#FUN-D70095--------------------------end


   FOREACH r183_caag INTO l_aag01,sr.aag02,sr.aag13       #FUN-6C0012
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      FOREACH r183_cgem INTO l_gem01
         LET sr.aao00 = bookno     #No.FUN-740020
         LET sr.aao01 = l_aag01
         LET sr.aao02 = l_gem01
 
         #-->(1)基準:實際費用
         OPEN r183_caaodef USING bookno,l_aag01,l_gem01   #No.FUN-740020
         FETCH r183_caaodef INTO sr.aao05,sr.aao06
         IF SQLCA.sqlcode THEN
            LET sr.aao05 = 0
            LET sr.aao06 = 0
         END IF
         CLOSE r183_caaodef
#FUN-D70095--------------------------begin         
         OPEN r121_cesumc USING bookno,l_aag01,l_gem01,'1',tm.defyy,tm.defbm,tm.defem
         FETCH r121_cesumc INTO l_CE_sum1   
         IF STATUS THEN CALL cl_err('sel abb:',STATUS,1) EXIT FOREACH END IF
         IF l_CE_sum1 IS NULL THEN LET l_CE_sum1 = 0 END IF
         
         OPEN r121_cesumc USING bookno,l_aag01,l_gem01,'2',tm.defyy,tm.defbm,tm.defem
         FETCH r121_cesumc INTO l_CE_sum2   
         IF STATUS THEN CALL cl_err('sel abb:',STATUS,1) EXIT FOREACH END IF
         IF l_CE_sum2 IS NULL THEN LET l_CE_sum2 = 0 END IF
         LET sr.aao05 = sr.aao05 - l_CE_sum1
         LET sr.aao06 = sr.aao06 - l_CE_sum2
#FUN-D70095--------------------------end 
         #-->(1)比較:實際費用
         OPEN r183_caaocom USING bookno,l_aag01,l_gem01    #No.FUN-740020
         FETCH r183_caaocom INTO l_aao05,l_aao06
         IF SQLCA.sqlcode THEN
            LET l_aao05 = 0
            LET l_aao06 = 0
         END IF
         CLOSE r183_caaocom
 
         IF l_aao05 IS NULL THEN
            LET l_aao05 = 0
         END IF
 
         IF l_aao06 IS NULL THEN
            LET l_aao06 = 0
         END IF

#FUN-D70095--------------------------begin         
         OPEN r121_cesumc USING bookno,l_aag01,l_gem01,'1',tm.comyy,tm.combm,tm.comem
         FETCH r121_cesumc INTO l_CE_sum1   
         IF STATUS THEN CALL cl_err('sel abb:',STATUS,1) EXIT FOREACH END IF
         IF l_CE_sum1 IS NULL THEN LET l_CE_sum1 = 0 END IF
         
         OPEN r121_cesumc USING bookno,l_aag01,l_gem01,'2',tm.comyy,tm.combm,tm.comem
         FETCH r121_cesumc INTO l_CE_sum2   
         IF STATUS THEN CALL cl_err('sel abb:',STATUS,1) EXIT FOREACH END IF
         IF l_CE_sum2 IS NULL THEN LET l_CE_sum2 = 0 END IF
         LET l_aao05 = l_aao05 - l_CE_sum1
         LET l_aao06 = l_aao06 - l_CE_sum2
#FUN-D70095--------------------------end  

         #-->(2)比較:上月實際費用
         LET sr.lastcharge = l_aao05 - l_aao06
 
         IF sr.lastcharge IS NULL THEN
            LET sr.lastcharge = 0
         END IF
 
         IF sr.aao05 IS NULL THEN
            LET sr.aao05 = 0
         END IF
 
         IF sr.aao06 IS NULL THEN
            LET sr.aao06 = 0
         END IF
 
#No.FUN-780060--start--add
         IF tm.e = 'N' THEN  
            LET sr.aag13 = sr.aag02 
         END IF 
         EXECUTE insert_prep USING 
                 sr.aao00,sr.aao01,sr.aao05,sr.aao06,sr.aag13,sr.lastcharge
#        OUTPUT TO REPORT aglr183_rep(sr.*)
 
      END FOREACH
   END FOREACH
 
#  FINISH REPORT aglr183_rep
 
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-780060--end--
#No.FUN-780060--start--add
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)                                                                                     
    IF g_zz05 = 'Y' THEN                                                                                                            
       CALL cl_wcchp(tm.wc,'aag01')                                                                                                 
       RETURNING tm.wc                                                                                                              
       LET g_str = tm.wc                                                                                                            
    END IF 
    LET l_tit1 = tm.defyy USING '####','/',tm.defbm USING '&#','-',
                 tm.defem USING '&#'
    LET l_tit2 = tm.comyy USING '####','/',tm.combm USING '&#','-',
                 tm.comem USING '&#'
    LET l_tit3 = tm.defyy USING '####','/',tm.defbm USING '&#','-',
                 tm.defem USING '&#' 
    LET g_str=g_str,";",tm.type,";",l_tit1,";",l_tit2,";",l_tit3,";",
              l_flag,";",bookno,";",tm.diff1,";",tm.diff2,";",g_azi04
              ,";",g_azi05
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    CALL cl_prt_cs3('aglr183','aglr183',g_sql,g_str)
#No.FUN-780060--end--
END FUNCTION
#No.FUN-780060--start--mark
{REPORT aglr183_rep(sr)
   DEFINE sr        RECORD
                      aao00       LIKE aao_file.aao00,   #帳別
                      aao01       LIKE aao_file.aao01,   #科目
                      aao02       LIKE aao_file.aao02,   #部門
                      aao05       LIKE aao_file.aao05,   #借方總和
                      aao06       LIKE aao_file.aao06,   #貸方總和
                      aag02       LIKE aag_file.aag02,   #科目名稱
                      aag13       LIKE aag_file.aag13,   #額外名稱 #FUN-6C0012
                      lastcharge  LIKE aao_file.aao05    #(2)比較:上月實際費用
                    END RECORD,
          l_last_sw LIKE type_file.chr1,     #No.FUN-680098 VARCHAR(1)
          l_st      LIKE type_file.chr1,     #No.FUN-680098 VARCHAR(1)
          l_gem02   LIKE gem_file.gem02,
          l_defcharge,l_lastcharge,l_diff1    LIKE aao_file.aao05,
          l_difpercent,l_difperyy,t_defcharge LIKE aao_file.aao05
   DEFINE g_head1   STRING
   DEFINE l_tit1    LIKE type_file.chr1000 #TQC-620001  #No.FUN-680098 VARCHAR(13) 
   DEFINE l_tit2    LIKE type_file.chr1000 #TQC-620001  #No.FUN-680098 VARCHAR(13)
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.aao00,sr.aao01    #帳別,科目
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         LET g_head1 = g_x[9] CLIPPED,l_buf CLIPPED               #費用類別
         PRINT g_head1
         LET g_head1 = g_x[15] CLIPPED,tm.defyy USING '####',' ',
                       tm.defbm USING '##',' - ',tm.defem USING '##'
         PRINT g_head1
         PRINT g_dash[1,g_len]
         LET l_tit1 = tm.defyy USING '####',':',tm.defbm USING '##','-',
                      tm.defem USING '##',g_x[17] CLIPPED
         LET l_tit2 = tm.comyy USING '####',':',tm.combm USING '##','-',
                      tm.comem USING '##',g_x[17] CLIPPED
         PRINT COLUMN g_c[33],l_tit1,
               COLUMN g_c[34],l_tit2
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
         PRINT g_dash1
         LET l_last_sw='n'
 
      BEFORE GROUP OF sr.aao01
         LET l_defcharge = 0
         LET l_lastcharge = 0
         LET l_diff1 = 0
         LET l_difpercent = 0
         LET l_difperyy = 0
 
      AFTER GROUP OF sr.aao01                        #科目
         #FUN-6C0012.....begin
         IF tm.e = 'N' THEN
            LET sr.aag13 = sr.aag02
         END IF
         #FUN-6C0012.....end
 
         IF l_flag='Y' THEN
            LET t_defcharge = SUM(sr.aao05 - sr.aao06)
            LET l_flag='N'
         END IF
 
         #A1:基準: tm.defbm-tm.defem 之實際費用
         LET l_defcharge = GROUP SUM(sr.aao05 - sr.aao06)
                               WHERE sr.aao00 = sr.aao00
                                 AND sr.aao01 = sr.aao01
                                 AND sr.aao00 = bookno
         IF l_defcharge IS NULL THEN
            LET l_defcharge = 0
         END IF
 
         #A2:比較: tm.combm-tm.comem 之實際費用
         LET l_lastcharge = GROUP SUM(sr.lastcharge)
                                WHERE sr.aao00 = sr.aao00
                                  AND sr.aao01 = sr.aao01
                                 AND sr.aao00 = bookno
         IF l_lastcharge IS NULL THEN
            LET l_defcharge = 0
         END IF
 
         #A3:差異 1-2(A1-A2)
         LET l_diff1 = l_defcharge - l_lastcharge
 
         #A4:差異百分比(A3/A2 * 100)
         LET l_difpercent = (l_diff1 / l_lastcharge) * 100
 
         #A5:年度百分比(A1/SUM(A1)  *100 )
         LET l_difperyy = (l_defcharge / t_defcharge) * 100
         LET l_st = ' '
 
         #差異金額 > tm.diff1   -> *
         IF l_diff1 > tm.diff1 THEN
            LET l_st = '*'
         END IF
 
         #差異百分比 > tm.diff2 -> %
         IF l_difpercent > tm.diff2 THEN
            LET l_st = '%'
         END IF
 
         #兩者均大於        -> &
         IF (l_diff1 > tm.diff1) AND (l_difpercent > tm.diff2) THEN
            LET l_st = '&'
         END IF
 
         LET sr.aao01 = l_st,sr.aao01
         PRINT COLUMN g_c[31],sr.aao01,
#               COLUMN g_c[32],sr.aag02,  #FUN-6C0012
               COLUMN g_c[32],sr.aag13,   #FUN-6C0012
               COLUMN g_c[33],cl_numfor(l_defcharge,33,g_azi04),
               COLUMN g_c[34],cl_numfor(l_lastcharge,34,g_azi04),
               COLUMN g_c[35],cl_numfor(l_diff1,35,g_azi04),
               COLUMN g_c[36],l_difpercent USING '-----&.-&',
               COLUMN g_c[37],l_difperyy USING '-----&.-&'
 
      ON LAST ROW
         #基準: tm.defbm-tm.defem 之實際費用
         LET l_defcharge = SUM(sr.aao05 - sr.aao06)
         IF l_defcharge IS NULL THEN
            LET l_defcharge = 0
         END IF
 
         #比較: tm.combm-tm.comem 之實際費用
         LET l_lastcharge = SUM(sr.lastcharge)
         IF l_lastcharge IS NULL THEN
            LET l_defcharge = 0
         END IF
 
         LET l_diff1 = l_defcharge - l_lastcharge             #差異 1-2
         LET l_difpercent = (l_diff1 / l_lastcharge) * 100      #差異百分比
        #LET l_difperyy = (l_defcharge / t_defcharge) * 100     #年度百分比
 
         PRINT g_dash2[1,g_len]
 
         PRINT COLUMN g_c[32],g_x[16] CLIPPED,
               COLUMN g_c[33],cl_numfor(l_defcharge,33,g_azi05),    #基準實際費用
               COLUMN g_c[34],cl_numfor(l_lastcharge,34,g_azi05),    #比較實際費用
               COLUMN g_c[35],cl_numfor(l_diff1,35,g_azi05),    #差異 1-2
               COLUMN g_c[36],l_difpercent USING '-----&.-&'
 
         LET l_last_sw = 'y'
         PRINT g_dash[1,g_len]
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
 
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT}
#No.FUN-780060--end--
#Patch....NO.TQC-610035 <001> #
