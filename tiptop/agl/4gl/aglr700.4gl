# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglr700.4gl
# Descriptions...: 專案試算表
# Date & Author..: 01/10/02 By Wiky
# Modify.........: 01/10/03 By Kammy
# Modify.........: No.FUN-510007 05/01/10 By Nicola 報表架構修改
# Modify.........: No.MOD-580107 05/09/08 By Smapmin 單身餘額不準確
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-660060 06/06/29 By Rainy 表頭期間置於中間
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-670005 06/07/07 By Hellen 帳別權限修改
# Modify.........: No.FUN-680098 06/08/31 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-6B0011 06/12/04 By Sarah (接下頁)、(結束)沒有靠右
# Modify.........: No.FUN-6C0012 06/12/27 By Judy 新增打印額外名稱欄位
# Modify.........: No.TQC-720032 07/04/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740020 07/04/10 By Lynn 會計科目加帳套
# Modify.........: No.TQC-740093 07/04/18 By johnray 部分語句仍使用g_bookno,而非從畫面取值
# Modify.........: No.TQC-740145 07/04/18 By johnray g_bookno 這個變量沒有定義
# Modify.........: No.FUN-810010 08/01/30 By baofei報表輸出改為Crystal Report
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B20054 11/02/24 By lixiang 先錄入帳套,科目根據帳套過濾;結構改為DIALOG
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                        # Print condition RECORD
              wc    LIKE type_file.chr1000,#科目&專案編號範圍   #No.FUN-680098 VARCHAR(400)
              wc2   LIKE type_file.chr1000,#科目&專案編號範圍   #No.FUN-680098 VARCHAR(400)
              yy    LIKE aef_file.aef03,  #輸入年度
              bm    LIKE aef_file.aef04,  #起始期別
              em    LIKE aef_file.aef04,  #截止期別
              aef00 LIKE aef_file.aef00,  #帳別
              d     LIKE azi_file.azi05,  #小數位數    #No.FUN-680098 smallint
              e     LIKE type_file.chr1,  #異動額及餘額為0者是否列印 #No.FUN-680098 VARCHAR(1)
              f     LIKE type_file.chr1,  #額外名稱 #FUN-6C0012
              more  LIKE type_file.chr1   #Input more condition(Y/N) #No.FUN-680098  VARCHAR(1)
           END RECORD,
       g_bookno  LIKE aef_file.aef00  #帳別    #No.TQC-740145
DEFINE g_aaa03   LIKE aaa_file.aaa03   
DEFINE g_i       LIKE type_file.num5     #count/index for any purpose   #No.FUN-680098 smallint
 
#No.FUN-810010---Begin
DEFINE g_sql     STRING
DEFINE g_str     STRING
DEFINE l_table   STRING
 
#No.FUN-810010---End
 
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
#No.FUN-810010---begin
   LET g_sql = " aef01.aef_file.aef01,",
               " aef02.aef_file.aef02,",
               " aag02.aag_file.aag02,",
               " aag13.aag_file.aag13,",
               " bdr.aef_file.aef05,",
               " bcr.aef_file.aef05,",
               " dr.aef_file.aef05,",
               " cr.aef_file.aef05,",
               " edr.aef_file.aef05,",
               " ecr.aef_file.aef05"
  LET l_table = cl_prt_temptable('aglr700',g_sql) CLIPPED
  IF l_table = -1 THEN EXIT PROGRAM  END IF
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                     
                 " VALUES(?,?,?,?,?, ?,?,?,?,?) "                      
     PREPARE insert_prep FROM g_sql                                             
     IF STATUS THEN                                                             
        CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                       
     END IF                
#No.FUN-810010---End
 
   LET g_bookno = ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)            # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc  = ARG_VAL(8) 
   LET tm.wc2 = ARG_VAL(9) 
   LET tm.yy = ARG_VAL(10)
   LET tm.bm = ARG_VAL(11)
   LET tm.em = ARG_VAL(12)
   LET tm.aef00 = ARG_VAL(13)   #TQC-610056
   LET tm.d  = ARG_VAL(14)
   LET tm.e  = ARG_VAL(15)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(16)
   LET g_rep_clas = ARG_VAL(17)
   LET g_template = ARG_VAL(18)
   #No.FUN-570264 ---end---
   LET tm.f  = ARG_VAL(19)   #FUN-6C0012
   LET g_rpt_name = ARG_VAL(20)  #No.FUN-7C0078
 
   IF cl_null(g_bookno) THEN 
      LET g_bookno = g_aaz.aaz64
   END IF
#No.FUN-740020 --begin
   IF cl_null(tm.aef00) THEN
      LET tm.aef00 = g_aza.aza81
   END IF
#No.FUN-740020 --end
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN 
      CALL aglr700_tm()
   ELSE 
      CALL aglr700()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION aglr700_tm()
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680098 smallint
          l_sw           LIKE type_file.chr1,          #重要欄位是否空白 #No.FUN-680098 VARCHAR(2)
          l_cmd          LIKE type_file.chr1000        #No.FUN-680098 VARCHAR(400)
   DEFINE li_chk_bookno  LIKE type_file.num5           #No.FUN-670005 #No.FUN-680098 smallint
#   CALL s_dsmark(g_bookno)    #No.TQC-740093
   CALL s_dsmark(tm.aef00)     #No.TQC-740093
   LET p_row = 3 LET p_col = 16
   OPEN WINDOW aglr700_w AT p_row,p_col
     WITH FORM "agl/42f/aglr700"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
# Prog. Version..: '5.30.06-13.03.12(0,0,g_bookno)   #No.TQC-740093
   CALL s_shwact(0,0,tm.aef00)    #No.TQC-740093
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  # Default condition
   LET tm.aef00 = g_aza.aza81     #No.TQC-740093
   #使用預設帳別之幣別
#   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno   #No.TQC-740093
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.aef00    #No.TQC-740093
   IF SQLCA.sqlcode THEN
#     CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660123
#      CALL cl_err3("sel"," aaa_file",g_bookno,"",SQLCA.sqlcode,"","",0)   #No.FUN-660123   #No.TQC-740093
      CALL cl_err3("sel"," aaa_file",tm.aef00,"",SQLCA.sqlcode,"","",0)    #No.TQC-740093
   END IF
 
   SELECT azi04,azi05 INTO g_azi04,tm.d FROM azi_file 
    WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN
#     CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660123
      CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","",0)   #No.FUN-660123
   END IF
 
#  LET tm.aef00= g_bookno     #No.FUN-740020
   LET tm.more = 'N'
   LET tm.d    = '1'
   LET tm.e    = 'N'
   LET tm.f    = 'N'  #FUN-6C0012
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies= '1'
   LET l_sw    = 1
 
   WHILE TRUE
    #FUN-B20054--add--str--
    DIALOG ATTRIBUTE(unbuffered)
       INPUT BY NAME tm.aef00 ATTRIBUTE(WITHOUT DEFAULTS)
          AFTER FIELD aef00
            IF NOT cl_null(tm.aef00) THEN
                   CALL s_check_bookno(tm.aef00,g_user,g_plant)
                    RETURNING li_chk_bookno
                IF (NOT li_chk_bookno) THEN
                    NEXT FIELD aef00
                END IF
                SELECT aaa02 FROM aaa_file WHERE aaa01 = tm.aef00
                IF STATUS THEN
                   CALL cl_err3("sel","aaa_file",tm.aef00,"","agl-043","","",0)
                   NEXT FIELD aef00
                END IF
            END IF
       END INPUT
     #FUN-B20054--add--end
     
      CONSTRUCT BY NAME tm.wc ON aef01 
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
#FUN-B20054--mark--end
  
      END CONSTRUCT
#FUN-B20054--mark--str--
#      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
#  
#      IF g_action_choice = "locale" THEN
#         LET g_action_choice = ""
#         CALL cl_dynamic_locale()
#         CONTINUE WHILE
#      END IF
#FUN-B20054--mark--end 
      CONSTRUCT BY NAME tm.wc2 ON aef02 
      
#FUN-B20054--mark--str-- 
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
#         CLOSE WINDOW aglr700_w 
#         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#         EXIT PROGRAM 
#     END IF
#FUN-B20054--mark--end 
      
   #   INPUT BY NAME tm.yy,tm.aef00,tm.bm,tm.em,tm.d,tm.e,tm.f,tm.more WITHOUT DEFAULTS   #FUN-6C0012 #FUN-B20054
      INPUT BY NAME tm.yy,tm.bm,tm.em,tm.d,tm.e,tm.f,tm.more
                    ATTRIBUTE(WITHOUT DEFAULTS)  #FUN-B20054
         AFTER FIELD bm
    #No.TQC-720032 -- begin --
         IF NOT cl_null(tm.bm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.bm > 12 OR tm.bm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bm
               END IF
            ELSE
               IF tm.bm > 13 OR tm.bm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bm
               END IF
            END IF
         END IF
    #No.TQC-720032 -- end --
            IF tm.bm IS NULL THEN
               NEXT FIELD bm 
            END IF
 
#No.TQC-720032 -- begin --
#            IF tm.bm <1 OR tm.bm > 13 THEN
#               CALL cl_err('','agl-013',0)
#               NEXT FIELD bm
#            END IF
#No.TQC-720032 -- end --
 
         AFTER FIELD em
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.em) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.em > 12 OR tm.em < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em
               END IF
            ELSE
               IF tm.em > 13 OR tm.em < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
            IF tm.em IS NULL THEN
               NEXT FIELD em
            END IF
 
#No.TQC-720032 -- begin --
#            IF tm.em <1 OR tm.em > 13 THEN
#               CALL cl_err('','agl-013',0)
#               NEXT FIELD em
#            END IF
#No.TQC-720032 -- end --
 
            IF tm.bm > tm.em THEN 
               CALL cl_err('',9011,0)
               NEXT FIELD bm
            END IF
 #FUN-B20054--mark-str--   
 #        AFTER FIELD aef00
 #           IF tm.aef00 IS NULL THEN
 #              NEXT FIELD aef00
 #           END IF
 #           #No.FUN-670005--begin
 #            CALL s_check_bookno(tm.aef00,g_user,g_plant) 
 #                 RETURNING li_chk_bookno
 #            IF (NOT li_chk_bookno) THEN
 #                 NEXT FIELD aef00 
 #            END IF 
 #           #No.FUN-670005--end  
 #           SELECT aaa02 FROM aaa_file
 #            WHERE aaa01 = tm.aef00
 #              AND aaaacti IN ('Y','y')
 #           IF STATUS THEN 
 #   #           CALL cl_err('sel aaa:',STATUS,0)   #No.FUN-660123
 #              CALL cl_err3("sel","aaa_file",tm.aef00,"",STATUS,"","sel aaa:",0)   #No.FUN-660123
 #              NEXT FIELD aef00
 #           END IF
 #FUN-B20054--mark--end     
         AFTER FIELD d
            IF tm.d IS NULL OR tm.d < 0  THEN
               LET tm.d = 0
               DISPLAY BY NAME tm.d
               NEXT FIELD d
            END IF
      
         AFTER FIELD e
            IF tm.e IS NULL OR tm.e NOT MATCHES "[YN]" THEN
               NEXT FIELD e
            END IF
      
         AFTER FIELD more
            IF tm.more = 'Y' THEN 
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
      
         AFTER INPUT 
        #FUN-B20054--mark-str--  
        #    IF INT_FLAG THEN
        #       EXIT INPUT
        #    END IF
        #FUN-B20054--mark--end
            IF tm.yy IS NULL THEN 
               LET l_sw = 0 
               DISPLAY BY NAME tm.yy 
            END IF
 
            IF tm.bm IS NULL THEN 
               LET l_sw = 0 
               DISPLAY BY NAME tm.bm 
            END IF
 
            IF tm.em IS NULL THEN 
               LET l_sw = 0 
               DISPLAY BY NAME tm.em 
            END IF
 
            IF l_sw = 0 THEN 
               LET l_sw = 1 
               NEXT FIELD a
               CALL cl_err('',9033,0)
            END IF
            
#FUN-B20054--mark-str--      
#         ON ACTION CONTROLR
#            CALL cl_show_req_fields()
# 
#         ON ACTION CONTROLG
#            CALL cl_cmdask() 
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
#FUN-B20054--mark--end
     
      END INPUT
      #FUN-B20054--add--str--
         ON ACTION CONTROLP
          CASE
             WHEN INFIELD(aef00)
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_aaa3'
                LET g_qryparam.default1 = tm.aef00
                CALL cl_create_qry() RETURNING tm.aef00
                DISPLAY tm.aef00 TO FORMONLY.aef00
                NEXT FIELD aef00
             WHEN INFIELD(aef01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag02"
                LET g_qryparam.state = "c"
                LET g_qryparam.where = " aag00 = '",tm.aef00 CLIPPED,"'"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO aef01
                NEXT FIELD aef01
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
       CLOSE WINDOW aglr700_w 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
       EXIT PROGRAM
    END IF

    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   #FUN-B20054--add--end  
   
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file      #get exec cmd (fglgo xxxx)
          WHERE zz01='aglr700'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglr700','9031',1)   
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,            #(at time fglgo xxxx p1 p2 p3)
#                        " '",g_bookno CLIPPED,"'",       #No.TQC-740093
                        " '",tm.aef00 CLIPPED,"'",        #No.TQC-740093
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.wc2 CLIPPED,"'",
                        " '",tm.yy CLIPPED,"'",
                        " '",tm.bm CLIPPED,"'",
                        " '",tm.em CLIPPED,"'",
                        " '",tm.aef00 CLIPPED,"'",   #TQC-610056
                        " '",tm.d CLIPPED,"'",
                        " '",tm.e CLIPPED,"'",
                        " '",tm.f CLIPPED,"'",        #FUN-6C0012
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aglr700',g_time,l_cmd)      # Execute cmd at later time
         END IF
 
         CLOSE WINDOW aglr700_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL aglr700()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW aglr700_w
 
END FUNCTION
 
FUNCTION aglr700()
   DEFINE l_name      LIKE type_file.chr20,             # External(Disk) file name      #No.FUN-680098 VARCHAR(20)
#       l_time          LIKE type_file.chr8          #No.FUN-6A0073
          l_sql       LIKE type_file.chr1000,           # RDSQL STATEMENT               #No.FUN-680098 VARCHAR(1000)
          l_chr       LIKE type_file.chr1,              #No.FUN-680098  VARCHAR(1)
          l_k         LIKE type_file.chr1000,           #No.FUN-810010
          sr          RECORD 
                         aef01     LIKE aef_file.aef01,#
                         aag02     LIKE aag_file.aag02,#
                         aag13     LIKE aag_file.aag13,#額外名稱 #FUN-6C0012
                         aef02     LIKE aef_file.aef02,#
                         bdr       LIKE aef_file.aef05,#期初借方金額
                         bcr       LIKE aef_file.aef05,#期初貸方金額
                         dr        LIKE aef_file.aef05,#本期借方金額
                         cr        LIKE aef_file.aef05,#本期貸方金額
                         edr       LIKE aef_file.aef05,#期末借方金額
                         ecr       LIKE aef_file.aef05 #期末貸方金額
                      END RECORD
   CALL cl_del_data(l_table)   #No.FUN-810010   
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #No.FUN-810010
 
   SELECT aaf03 INTO g_company FROM aaf_file
#    WHERE aaf01 = g_bookno    #No.TQC-740093
    WHERE aaf01 = tm.aef00     #No.TQC-740093
      AND aaf02 = g_rlang
 
   LET l_sql = " SELECT DISTINCT(aef01),aag02,aag13 ",
               "  FROM aef_file LEFT OUTER JOIN aag_file ON aef01=aag01 AND aef00=aag00 ",
 
               " WHERE aef00='",tm.aef00,"'", #no.7277
               "   AND ",tm.wc CLIPPED
 
   PREPARE aglr700_prepare1 FROM l_sql
   IF STATUS THEN 
      CALL cl_err('prepare:',STATUS,1)   
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   DECLARE aglr700_curs1 CURSOR FOR aglr700_prepare1
   
   LET l_sql = " SELECT UNIQUE(aef02) FROM aef_file ",
               "  WHERE ",tm.wc2 CLIPPED,
               "    AND aef00='",tm.aef00,"'"  #no.7277
 
   PREPARE aglr700_prepare2 FROM l_sql
   IF STATUS THEN 
      CALL cl_err('prepare:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   DECLARE aglr700_curs2 CURSOR FOR aglr700_prepare2
 
#   CALL cl_outnam('aglr700') RETURNING l_name             #NO.FUN-810010
#   START REPORT aglr700_rep TO l_name                     #NO.FUN-810010
 
#   LET g_pageno = 0                                       #NO.FUN-810010
 
   FOREACH aglr700_curs1 INTO sr.aef01,sr.aag02,sr.aag13  #FUN-6C0012
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1) 
         EXIT FOREACH 
      END IF
 
      FOREACH aglr700_curs2 INTO sr.aef02
         LET sr.bdr = 0
         LET sr.bcr = 0 
         LET sr.dr  = 0
         LET sr.cr  = 0 
         LET sr.edr = 0
         LET sr.ecr = 0
 
         SELECT SUM(aef05-aef06) INTO sr.bdr
           FROM aef_file
          WHERE aef01 = sr.aef01
            AND aef02 = sr.aef02
            AND aef03 = tm.yy
            AND aef04 < tm.bm
            AND aef00 = tm.aef00 #no.7277
 
         SELECT SUM(aef05),SUM(aef06) INTO sr.dr,sr.cr
           FROM aef_file
          WHERE aef01 = sr.aef01
            AND aef02 = sr.aef02
            AND aef03 = tm.yy 
            AND aef04 BETWEEN tm.bm AND tm.em
            AND aef00 = tm.aef00 #no.7277
 
         IF sr.bdr IS NULL THEN
            LET sr.bdr = 0
         END IF
 
         IF sr.bdr < 0 THEN
            LET sr.bcr = sr.bdr
            LET sr.bdr = 0
         END IF
 
         IF sr.dr IS NULL THEN 
            LET sr.dr = 0
         END IF
 
         IF sr.cr IS NULL THEN
            LET sr.cr = 0
         END IF
 
         LET sr.edr = sr.bdr - sr.bcr + sr.dr - sr.cr
 
         IF sr.edr < 0 THEN
            LET sr.ecr = sr.edr
            LET sr.edr = 0
         END IF
 
         IF sr.bdr=0 AND sr.bcr=0 AND sr.dr=0 AND sr.cr=0 THEN
             CONTINUE FOREACH
         END IF
 
#         OUTPUT TO REPORT aglr700_rep(sr.*)               #NO.FUN-810010
#No.FUN-810010---Begin 
          EXECUTE insert_prep USING sr.aef01,sr.aef02,sr.aag02,sr.aag13,sr.bdr,
                                    sr.bcr,sr.dr,sr.cr,sr.edr,sr.ecr
#No.FUN-810010---End 
 
      END FOREACH
   END FOREACH
 
#   FINISH REPORT aglr700_rep                              #NO.FUN-810010
 
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)            #NO.FUN-810010
#No.FUN-810010---Begin 
     LET l_k =   tm.yy USING '<<<<','/',tm.bm USING'&&','-',                                                                  
                 tm.yy USING '<<<<','/',tm.em USING'&&'  
      IF g_zz05 = 'Y' THEN                                                      
         CALL cl_wcchp(tm.wc,'aef01')                         
              RETURNING tm.wc                                                   
      END IF                                                                    
      LET g_str=tm.wc ,";",tm.yy,";",tm.bm,";",tm.em,";", tm.d,";",tm.f,";",l_k
                                                                          
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
   CALL cl_prt_cs3('aglr700','aglr700',l_sql,g_str)
#No.FUN-810010---End 
END FUNCTION
 
#No.FUN-810010---Begin
#REPORT aglr700_rep(sr)
#   DEFINE l_last_sw   LIKE type_file.chr1,       #No.FUN-680098 VARCHAR(1)
#          sr          RECORD 
#                         aef01     LIKE aef_file.aef01,#
#                         aag02     LIKE aag_file.aag02,#
#                         aag13     LIKE aag_file.aag13,#額外名稱 #FUN-6C0012
#                         aef02     LIKE aef_file.aef02,#
#                         bdr       LIKE aef_file.aef05,#期初借方金額
#                         bcr       LIKE aef_file.aef05,#期初貸方金額
#                         dr        LIKE aef_file.aef05,#本期借方金額
#                         cr        LIKE aef_file.aef05,#本期貸方金額
#                         edr       LIKE aef_file.aef05,#期末借方金額
#                         ecr       LIKE aef_file.aef05 #期末貸方金額
#                      END RECORD
#   DEFINE g_head1    STRING
#                        
#   OUTPUT
#      TOP MARGIN g_top_margin 
#      LEFT MARGIN g_left_margin 
#      BOTTOM MARGIN g_bottom_margin 
#      PAGE LENGTH g_page_line
#
#   ORDER BY sr.aef01,sr.aef02
#
#   FORMAT
#      PAGE HEADER
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
#         LET g_pageno = g_pageno + 1
#         LET pageno_total = PAGENO USING '<<<',"/pageno"
#         PRINT g_head CLIPPED,pageno_total
#         LET g_head1 = g_x[9] CLIPPED,
#                       tm.yy USING '<<<<','/',tm.bm USING'&&','-',
#                       tm.yy USING '<<<<','/',tm.em USING'&&'
#         #PRINT g_head1                                       #FUN-660060 remark
#         PRINT COLUMN (g_len-FGL_WIDTH(g_head1))/2-1, g_head1 #FUN-660060
#         PRINT g_dash[1,g_len]
#         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
#         PRINT g_dash1 
#         LET l_last_sw = 'n'
#   
#      BEFORE GROUP OF sr.aef01
#         #No.FUN-6C0012 --start--                                               
#         IF tm.f = 'N' THEN                                                     
#            LET sr.aag13 = sr.aag02                                             
#         END IF                                                                 
#         #No.FUN-6C0012 --end--
#         PRINT COLUMN g_c[31],sr.aef01,
#               COLUMN g_c[32],sr.aag02
#               COLUMN g_x[32],sr.aag13     #FUN-6C0012
#   
#      ON EVERY ROW             
#         PRINT COLUMN g_c[31],sr.aef02,
#               COLUMN g_c[32],cl_numfor(sr.bdr,32,tm.d), 
#               COLUMN g_c[33],cl_numfor(sr.bcr,33,tm.d), 
#               COLUMN g_c[34],cl_numfor(sr.dr,34,tm.d), 
#               COLUMN g_c[35],cl_numfor(sr.cr,35,tm.d), 
#               COLUMN g_c[36],cl_numfor(sr.ecr,36,tm.d),    #MOD-580107
#               COLUMN g_c[36],cl_numfor(sr.edr,36,tm.d),    #MOD-580107
#               COLUMN g_c[37],cl_numfor(sr.ecr,37,tm.d) 
#   
#      AFTER GROUP OF sr.aef01
#         PRINT COLUMN g_c[31],g_x[10] CLIPPED,
#               COLUMN g_c[32],cl_numfor(GROUP SUM(sr.bdr),32,tm.d), 
#               COLUMN g_c[33],cl_numfor(GROUP SUM(sr.bcr),33,tm.d), 
#               COLUMN g_c[34],cl_numfor(GROUP SUM(sr.dr),34,tm.d), 
#               COLUMN g_c[35],cl_numfor(GROUP SUM(sr.cr),35,tm.d), 
#               COLUMN g_c[36],cl_numfor(GROUP SUM(sr.edr),36,tm.d), 
#               COLUMN g_c[37],cl_numfor(GROUP SUM(sr.ecr),37,tm.d) 
#         PRINT g_dash2[1,g_len]
#
#      ON LAST ROW
#         PRINT COLUMN g_c[31],g_x[11] CLIPPED,
#               COLUMN g_c[32],cl_numfor(SUM(sr.bdr),32,tm.d), 
#               COLUMN g_c[33],cl_numfor(SUM(sr.bcr),33,tm.d), 
#               COLUMN g_c[34],cl_numfor(SUM(sr.dr),34,tm.d), 
#               COLUMN g_c[35],cl_numfor(SUM(sr.cr),35,tm.d), 
#               COLUMN g_c[36],cl_numfor(SUM(sr.edr),36,tm.d), 
#               COLUMN g_c[37],cl_numfor(SUM(sr.ecr),37,tm.d) 
#         PRINT g_dash[1,g_len]
#        #PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[37],g_x[7] CLIPPED     #TQC-6B0011 mark
#         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED   #TQC-6B0011
#         LET l_last_sw = 'y'
#   
#      PAGE TRAILER
#         IF l_last_sw = 'n' THEN 
#            PRINT g_dash[1,g_len]
#           #PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[37],g_x[6] CLIPPED     #TQC-6B0011 mark
#            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED   #TQC-6B0011
#         ELSE 
#            SKIP 2 LINE
#         END IF
#
#END REPORT
#NO.DUN-810010------End----
