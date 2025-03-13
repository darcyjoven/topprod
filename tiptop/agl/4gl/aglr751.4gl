# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglr751.4gl
# Descriptions...: 部門明細分類帳
# Date & Author..: 99/01/02 By plum
# Modify.........: No.FUN-510007 05/02/18 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-5C0015 06/01/03 By miki
#                  將表頭說明組在單身，加上abb31~abb36(增加zaa22~27)，
#                  序號35放寬至60，報表寬度修改
# Modify.........: No.FUN-660147 06/06/27 By Smapmin 修改部門輸入限制
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680098 06/09/01 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6C0012 06/12/27 By Judy 新增打印額外名稱功能
# Modify.........: No.FUN-740020 07/04/11 By Lynn 會計科目加帳套
# Modify.........: No.TQC-6C0098 07/04/22 By Sarah QBE加一選項"是否列印內部管理科目"(aag38)
# Modify.........: NO.MOD-740225 輸入完QBE條件後 無法輸入條件選項 程式會直接跑報表
# Modify.........: NO.FUN-810091 08/03/21 By johnray 報表改為使用CR打印
# Modify.........: NO.FUN-940013 09/04/30 By jan aag01 欄位增加開窗功能
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A70007 10/07/13 By Summer 多帳期改用s_azmm,並依據畫面上的帳別傳遞使用
# Modify.........: No.FUN-B20054 11/02/24 By lixiang 先錄入帳套,科目根據帳套過濾;結構改為DIALOG
# Modify.........: No.FUN-B80057 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                            # Print condition RECORD  #NO.MOD-740225
           wc      STRING,                 # Where condition
           bookno  LIKE aag_file.aag00,    #No.FUN-740020
           babb05  LIKE abb_file.abb05,    # 起始部門
           eabb05  LIKE abb_file.abb05,    # 截止部門
           bdate   LIKE type_file.dat,     # 傳票起始日期    #No.FUN-680098  DATE
           edate   LIKE type_file.dat,     # 傳票截止日期    #No.FUN-680098  DATE
           t       LIKE type_file.chr2,    # none trans print (Y/N) ?   #No.FUN-680098  VARCHAR(1)
           x       LIKE type_file.chr1,    # 獨立列印否 (Y/N   #No.FUN-680098  VARCHAR(1)
           s       LIKE type_file.chr1,    # abb05 print or not (Y/N) #No.FUN-680098 VARCHAR(1)
           e       LIKE type_file.chr1,    #FUN-6C0012
           aag38   LIKE aag_file.aag38,    #TQC-6C0098 add
           more    LIKE type_file.chr1     # Input more condition(Y/N) #No.FUN-680098 VARCHAR(1)
           END RECORD,
       yy        LIKE azn_file.azn02,      #No.FUN-680098 INTEGER
       mm        LIKE azn_file.azn04,      #No.FUN-680098 INTEGER
       l_begin,l_end   LIKE type_file.dat,       #No.FUN-680098 DATE
       bdate           LIKE type_file.dat,       #Begin date    #No.FUN-680098 DATE
       edate           LIKE type_file.dat,       #Ended date    #No.FUN-680098 DATE
       babb05          LIKE  abb_file.abb05,     #No.FUN-680098  VARCHAR(6)
       eabb05          LIKE abb_file.abb05,      #No.FUN-680098  VARCHAR(6)
       l_flag          LIKE type_file.chr1,      #No.FUN-680098  VARCHAR(1)
       g_order         LIKE type_file.chr20,     #No.FUN-680098  VARCHAR(20)
       l_abb05_old     LIKE abb_file.abb05       #No.FUN-680098  VARCHAR(6)  
#       g_bookno        LIKE aaa_file.aaa01    #No.FUN-740020
DEFINE g_cnt           LIKE type_file.num10         #No.FUN-680098  integer
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098  smallint
#NO.FUN-810091 -- begin --
DEFINE g_sql           STRING
DEFINE g_str           STRING
DEFINE l_table         STRING
DEFINE l_table1        STRING
DEFINE l_table2        STRING
DEFINE l_table3        STRING
#NO.FUN-810091 -- end --
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                              # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114 #FUN-BB0047 mark
 
#NO.FUN-810091 -- begin --
   # 匯總REPORT需要用到的數據庫字段數據,對應sr.*
   LET g_sql = "abb03.abb_file.abb03,",
               "order1.abb_file.abb05,",
               "order2.aba_file.aba02,",
               "abb01.abb_file.abb01,",
               "abb02.abb_file.abb02,",
               "aag02.aag_file.aag02,",
               "aag13.aag_file.aag13,",
               "abb11.abb_file.abb11,",
               "abb12.abb_file.abb12,",
               "abb13.abb_file.abb13,",
               "abb14.abb_file.abb14,",
               "abb31.abb_file.abb31,",
               "abb32.abb_file.abb32,",
               "abb33.abb_file.abb33,",
               "abb34.abb_file.abb34,",
               "abb35.abb_file.abb35,",
               "abb36.abb_file.abb36,",
               "abb06.abb_file.abb06,",
               "aba02.aba_file.aba02,",
               "abb05.abb_file.abb05,",
               "abb07.abb_file.abb07,",
               "abb04.abb_file.abb04"
   LET l_table = cl_prt_temptable('aglr751',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   
   # 匯總CR主表字段數據,對應sr2.*
   LET g_sql = "abb03.abb_file.abb03,",
               "f_dep_d.aao_file.aao05,",
               "f_dep_c.aao_file.aao05,",
               "f_dep_bal.aao_file.aao05,",
               "l_dep_d.aao_file.aao05,",
               "l_dep_c.aao_file.aao05,",
               "l_dep_bal.aao_file.aao05,",
               "t_d.aao_file.aao05,",
               "t_c.aao_file.aao05,",
               "t_bal.aao_file.aao05,",
               "order1.abb_file.abb05,",
               "order2.aba_file.aba02,",
               "abb01.abb_file.abb01,",
               "abb02.abb_file.abb02,",
               "aag02.aag_file.aag02,",
               "aag13.aag_file.aag13,",
               "abb06.abb_file.abb06,",
               "dep_d.abb_file.abb07,",
               "dep_c.abb_file.abb07,",
               "dep_bal.abb_file.abb07,",
               "aba02.aba_file.aba02,",
               "abb05.abb_file.abb05,",
               "l_gem03.gem_file.gem03,",
               "l_str.type_file.chr1000,",
               "abb07.abb_file.abb07"
   LET l_table1 = cl_prt_temptable('aglr7511',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
 
   # 匯總期初數據子表,aao01關聯到sr2.abb03
   LET g_sql = "aao01.aao_file.aao01,",
               "l_aao02.aao_file.aao02,",
               "l_gem03.gem_file.gem03,",
               "l_pred.aao_file.aao05,",
               "l_prec.aao_file.aao05,",
               "l_prebal.aao_file.aao05"
   LET l_table2 = cl_prt_temptable('aglr7512',g_sql) CLIPPED
   IF l_table2 = -1 THEN EXIT PROGRAM END IF
 
   # 匯總額外摘要子表,abc01,abc02分別關聯到sr2.abb01和sr2.abb02
   LET g_sql = "abc01.abc_file.abc01,",
               "abc02.abc_file.abc02,",
               "l_abc03.abc_file.abc03,",
               "l_abc04.abc_file.abc04"
   LET l_table3 = cl_prt_temptable('aglr7513',g_sql) CLIPPED
   IF l_table3 = -1 THEN EXIT PROGRAM END IF
#NO.FUN-810091 -- end --
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET tm.bookno = ARG_VAL(1)   #No.FUN-740020
   LET g_pdate = ARG_VAL(2)             # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc = ARG_VAL(8)
   LET tm.babb05 = ARG_VAL(9)   #TQC-610056
   LET tm.eabb05 = ARG_VAL(10)  #TQC-610056
   LET tm.bdate = ARG_VAL(11)  #TQC-610056
   LET tm.edate = ARG_VAL(12)  #TQC-610056
   LET tm.t  = ARG_VAL(13)
   LET tm.x  = ARG_VAL(14)
   LET tm.s  = ARG_VAL(15)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(16)
   LET g_rep_clas = ARG_VAL(17)
   LET g_template = ARG_VAL(18)
   #No.FUN-570264 ---end---
   LET tm.e     = ARG_VAL(19)  #FUN-6C0012
   LET tm.aag38 = ARG_VAL(20)   #TQC-6C0098 add
   LET g_rpt_name = ARG_VAL(21)  #No.FUN-7C0078
 
#No.FUN-740020  ---begin
   IF tm.bookno IS NULL OR tm.bookno = ' ' THEN
          LET tm.bookno = g_aza.aza81
   END IF
#No.FUN-740020  ---end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'            # If background job sw is off
      THEN CALL aglr751_tm()                    # Input print condition
      ELSE CALL aglr751()                       # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION aglr751_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-680098 SMALLINT
          l_cmd       LIKE type_file.chr1000  #No.FUN-680098 VARCHAR(400)
DEFINE li_chk_bookno  LIKE type_file.num5     #FUN-B20054 
   CALL s_dsmark(tm.bookno)
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 12
   END IF
   OPEN WINDOW aglr751_w AT p_row,p_col
        WITH FORM "agl/42f/aglr751"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL s_shwact(0,0,tm.bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL     # Default condition
   LET tm.bookno = g_aza.aza81 #FUN-B20054 
   LET bdate   = NULL
   LET edate   = NULL
   LET babb05  = NULL
   LET eabb05  = NULL
   LET tm.t    = 'N'
   LET tm.s    = 'Y'
   LET tm.x    = 'Y'
   LET tm.e    = 'N' #FUN-6C0012
   LET tm.aag38= 'N'   #TQC-6C0098 add
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'

   DISPLAY BY NAME tm.t,tm.s,tm.x,tm.e,tm.more  #FUN-B20054 
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
     
    CONSTRUCT BY NAME tm.wc ON aag01
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
         
#FUN-B20054--mark--str-- 
#       #FUN-940013--begin--add
#       ON ACTION controlp 
#           CASE 
#              WHEN INFIELD(aag01)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state    = "c" 
#                   LET g_qryparam.form = "q_aag" 
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret 
#                   DISPLAY g_qryparam.multiret TO aag01
#                   NEXT FIELD aag01
#              OTHERWISE EXIT CASE
#           END CASE
#       #FUN-940013--end--add 
# 
#       ON ACTION locale
#           #CALL cl_dynamic_locale()
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#         LET g_action_choice = "locale"
#         EXIT CONSTRUCT
# 
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE CONSTRUCT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
# 
# 
#           ON ACTION exit
#           LET INT_FLAG = 1
#           EXIT CONSTRUCT
#         #No.FUN-580031 --start--
#         ON ACTION qbe_select
#            CALL cl_qbe_select()
#         #No.FUN-580031 ---end---
#FUN-B20054--mark--end
 
  END CONSTRUCT

#FUN-B20054--mark--str--
#       IF g_action_choice = "locale" THEN
#          LET g_action_choice = ""
#          CALL cl_dynamic_locale()
#          CONTINUE WHILE
#       END IF
# 
#    IF INT_FLAG THEN
#        LET INT_FLAG = 0 CLOSE WINDOW aglr751_w 
#        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#        EXIT PROGRAM
#           
#    END IF
#   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
#FUN-B20054--mark--end

    #  DISPLAY BY NAME tm.t,tm.s,tm.x,tm.e,tm.more  #FUN-6C0012 #FUN-B20054 
    #INPUT BY NAME tm.bookno,babb05,eabb05,bdate,edate,tm.t,tm.x,tm.s,tm.e,tm.aag38,tm.more  #FUN-6C0012   #No.FUN-740020   #TQC-6C0098 add tm.aag38
              #    WITHOUT DEFAULTS    #FUN-B20054
     INPUT BY NAME babb05,eabb05,bdate,edate,tm.t,tm.x,tm.s,tm.e,tm.aag38,tm.more
                  ATTRIBUTE(WITHOUT DEFAULTS)  #FUN-B20054
                  
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         #-----FUN-660147---------
         AFTER FIELD babb05
            IF cl_null(babb05) THEN
               NEXT FIELD babb05
            END IF
         #-----END FUN-660147-----
         
 #FUN-B20054--mark--str--
 #       #No.FUN-740020 --begin                                                                                                     
 #        AFTER FIELD bookno                                                                                                         
 #           IF cl_null(tm.bookno) THEN                                                                                              
 #              NEXT FIELD bookno                                                                                                    
 #           END IF                                                                                                                  
 #        #No.FUN-740020 --end
 #FUN-B20054--mark--end
          AFTER FIELD eabb05
            #-----FUN-660147---------
            IF cl_null(eabb05) THEN
               NEXT FIELD eabb05
            END IF
            #-----END FUN-660147-----
            IF eabb05 < babb05 THEN
               NEXT FIELD eabb05
            END IF
 
          AFTER FIELD bdate
            IF bdate IS NULL THEN
               NEXT FIELD bdate
            END IF
          AFTER FIELD edate
            IF edate IS NULL THEN
               LET edate =g_lastdat
            END IF
            IF edate < bdate THEN
               CALL cl_err(' ','agl-031',0)
               NEXT FIELD edate
            END IF
          AFTER FIELD t
            IF tm.t NOT MATCHES "[YN]" THEN NEXT FIELD t END IF
          AFTER FIELD s
            IF tm.s NOT MATCHES "[YN]" THEN NEXT FIELD s END IF
          AFTER FIELD x
            IF tm.x NOT MATCHES "[YN]" THEN NEXT FIELD x END IF
          #str TQC-6C0098 add
          AFTER FIELD aag38
             IF tm.aag38 NOT MATCHES "[YN]" THEN
                NEXT FIELD aag38
             END IF
          #end TQC-6C0098 add
          AFTER FIELD more
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                         g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,
                         g_bgjob,g_time,g_prtway,g_copies
            END IF

#FUN-B20054--mark--str--
#      ################################################################################
#      # START genero shell script ADD
#         ON ACTION CONTROLR
#            CALL cl_show_req_fields()
#      # END genero shell script ADD
#      ################################################################################
#            ON ACTION CONTROLG CALL cl_cmdask()  # Command execution
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
#       ON IDLE g_idle_seconds
#          CALL cl_on_idle()
#          CONTINUE INPUT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
# 
#          ON ACTION exit
#          LET INT_FLAG = 1
#          EXIT INPUT
#         #No.FUN-580031 --start--
#         ON ACTION qbe_save
#            CALL cl_qbe_save()
#         #No.FUN-580031 ---end---
#FUN-B20054--mark--end
 
    END INPUT

    #FUN-B20054--add--str--
     ON ACTION controlp 
           CASE 
              WHEN INFIELD(bookno)                                                                                                    
                   CALL cl_init_qry_var()                                                                                                
                   LET g_qryparam.form = 'q_aaa'                                                                                         
                   LET g_qryparam.default1 = tm.bookno                                                                                      
                   CALL cl_create_qry() RETURNING tm.bookno                                                                                 
                   DISPLAY BY NAME tm.bookno                                                                                                
                   NEXT FIELD bookno 
              WHEN INFIELD(aag01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c" 
                   LET g_qryparam.form = "q_aag" 
                   LET g_qryparam.where = " aag00 = '",tm.bookno CLIPPED,"'"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret 
                   DISPLAY g_qryparam.multiret TO aag01
                   NEXT FIELD aag01
              OTHERWISE EXIT CASE
           END CASE
       #FUN-940013--end--add 
 
     ON ACTION locale
      #CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        LET g_action_choice = "locale"
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
         LET INT_FLAG = 0 CLOSE WINDOW aglr751_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
    
      IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
  #FUN-B20054--add--end  
  
    SELECT azn02,azn04 INTO yy,mm FROM azn_file WHERE azn01 = bdate
    #CALL s_azm(yy,mm) RETURNING l_flag,l_begin,l_end #CHI-A70007 mark
    #CHI-A70007 add --start--
    IF g_aza.aza63 = 'Y' THEN
       CALL s_azmm(yy,mm,g_plant,tm.bookno) RETURNING l_flag,l_begin,l_end
    ELSE
       CALL s_azm(yy,mm) RETURNING l_flag,l_begin,l_end
    END IF
    #CHI-A70007 add --end--
    IF l_begin=bdate THEN LET l_begin='9999/12/31' END IF

  #FUN-B20054--mark--str--
  #  IF INT_FLAG THEN
  #     LET INT_FLAG = 0 CLOSE WINDOW aglr751_w 
  #     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
  #     EXIT PROGRAM
  #        
  #  END IF
  #FUN-B20054--mark--end  
    IF g_bgjob = 'Y' THEN
       SELECT zz08 INTO l_cmd FROM zz_file      #get exec cmd (fglgo xxxx)
             WHERE zz01='aglr751'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('aglr751','9031',1)   
       ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
          LET l_cmd = l_cmd CLIPPED,            #(at time fglgo xxxx p1 p2 p3)
                         " '",tm.bookno CLIPPED,"'",    #No.FUN-740020
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.babb05 CLIPPED,"'",   #TQC-610056
                         " '",tm.eabb05 CLIPPED,"'",   #TQC-610056
                         " '",tm.bdate CLIPPED,"'",   #TQC-610056
                         " '",tm.edate CLIPPED,"'",   #TQC-610056
                         " '",tm.t CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.x CLIPPED,"'" ,
                         " '",tm.e CLIPPED,"'",    #FUN-6C0012
                         " '",tm.aag38 CLIPPED,"'",             #TQC-6C0098 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
          CALL cl_cmdat('aglr751',g_time,l_cmd) # Execute cmd at later time
       END IF
       CLOSE WINDOW aglr751_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
       EXIT PROGRAM
    END IF
    CALL cl_wait()
    CALL aglr751()
    ERROR ""
  END WHILE
  CLOSE WINDOW aglr751_w
END FUNCTION
 
FUNCTION aglr751()
   DEFINE l_name        LIKE type_file.chr20,                # External(Disk) file name        #No.FUN-680098 VARCHAR(20)
#       l_time          LIKE type_file.chr8            #No.FUN-6A0073
          l_sql         LIKE type_file.chr1000,              # RDSQL STATEMENT        #No.FUN-680098  VARCHAR(1000)
          l_sql1        LIKE type_file.chr1000,              # RDSQL STATEMENT        #No.FUN-680098  VARCHAR(1000) 
          l_za05        LIKE za_file.za05,    #No.FUN-680098 VARCHAR(40)
          g_aaa     RECORD LIKE aaa_file.*,
          l_aao     RECORD LIKE aao_file.*,
          l_prem    LIKE type_file.num5,          #No.FUN-680098 smallint
          l_cnt     LIKE type_file.num5,          #No.FUN-680098 smallint
          sr1    RECORD
                    aag01 LIKE aag_file.aag01,   # course no
                    aag02 LIKE aag_file.aag02,   # course name
                    aag13 LIKE aag_file.aag13,   #FUN-6C0012
                    aag07 LIKE aag_file.aag07    # course type
                 END RECORD,
          sr     RECORD
                    order1 LIKE abb_file.abb05,  #No.FUN-680098 VARCHAR(20)
                    order2 LIKE aba_file.aba02,  #No.FUN-680098 VARCHAR(20)
                    aba02 LIKE aba_file.aba02,   # 傳票日期
                    aba06 LIKE aba_file.aba06,   # Source codea來源碼
                    abb01 LIKE abb_file.abb01,   # 傳票編號
                    abb02 LIKE abb_file.abb02,   # 傳票編號項次
                    abb03 LIKE abb_file.abb03,   # 科目編號
                    abb04 LIKE abb_file.abb04,   # 摘要
                    abb05 LIKE abb_file.abb05,   # 部門
                    abb06 LIKE abb_file.abb06,   # 借:1,D or  貸:2,C
                    abb07 LIKE abb_file.abb07,   # amount 異動金額
                    abb11 LIKE abb_file.abb11,   # 異動碼1
                    abb12 LIKE abb_file.abb12,   # 異動碼2
                    abb13 LIKE abb_file.abb13,   # 異動碼3
                    abb14 LIKE abb_file.abb14,   # 異動碼4
                    abb31 LIKE abb_file.abb31,   #異動5 #FUN-5C0015-(S)
                    abb32 LIKE abb_file.abb32,   #異動6
                    abb33 LIKE abb_file.abb33,   #異動7
                    abb34 LIKE abb_file.abb34,   #異動8
                    abb35 LIKE abb_file.abb35,   #異動9
                    abb36 LIKE abb_file.abb36,   #異動10#FUN-5C0015-(E)
                    aag02 LIKE aag_file.aag02,   # course name
                    aag13 LIKE aag_file.aag13    #FUN-6C0012
                 END RECORD
#NO.FUN-810091 -- begin --
DEFINE sr2    RECORD
                 abb03    LIKE abb_file.abb03,
                 order1   LIKE abb_file.abb05,
                 order2   LIKE aba_file.aba02,
                 abb01    LIKE abb_file.abb01,
                 abb02    LIKE abb_file.abb02,
                 aag02    LIKE aag_file.aag02,
                 aag13    LIKE aag_file.aag13,
                 abb06    LIKE abb_file.abb06,
                 aba02    LIKE aba_file.aba02,
                 abb05    LIKE abb_file.abb05,
                 abb07    LIKE abb_file.abb07
              END RECORD
DEFINE l_pred     LIKE aao_file.aao05  #abb07
DEFINE l_prec     LIKE aao_file.aao05
DEFINE l_prebal   LIKE aao_file.aao05
DEFINE f_dep_d    LIKE aao_file.aao05  #期初餘額
DEFINE f_dep_c    LIKE aao_file.aao05
DEFINE f_dep_bal  LIKE aao_file.aao05
DEFINE dep_d      LIKE aao_file.aao05  #科目本期小計
DEFINE dep_c      LIKE aao_file.aao05
DEFINE dep_bal    LIKE aao_file.aao05
DEFINE l_dep_d    LIKE aao_file.aao05  #部門小計
DEFINE l_dep_c    LIKE aao_file.aao05
DEFINE l_dep_bal  LIKE aao_file.aao05
DEFINE t_d        LIKE aao_file.aao05  #科目合計(期初+本期)
DEFINE t_c        LIKE aao_file.aao05
DEFINE t_bal      LIKE aao_file.aao05
DEFINE l_abb03    LIKE abb_file.abb03  # GROUP abb03 判斷
DEFINE l_order1   LIKE abb_file.abb05  # GROUP order1判斷
DEFINE l_first    LIKE type_file.num5  # 判斷是否第一筆記錄
DEFINE l_chg_abb03 LIKE type_file.num5  # 組變更標識
DEFINE l_chg_order1 LIKE type_file.num5 #
DEFINE l_gem03    LIKE gem_file.gem03
DEFINE l_str      LIKE type_file.chr1000
DEFINE l_aao02    LIKE aao_file.aao02
DEFINE l_abc03    LIKE abc_file.abc03
DEFINE l_abc04    LIKE abc_file.abc04
#NO.FUN-810091 --end--
 
#NO.FUN-810091 -- begin --
   CALL cl_del_data(l_table)
   CALL cl_del_data(l_table1)
   CALL cl_del_data(l_table2)
   CALL cl_del_data(l_table3)
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80057--add--
      EXIT PROGRAM
   END IF
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80057--add--
      EXIT PROGRAM
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?,?,?,?,?, ?)"
   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep2:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80057--add--
      EXIT PROGRAM
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
               " VALUES(?,?,?,?)"
   PREPARE insert_prep3 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep3:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80057--add--
      EXIT PROGRAM
   END IF
 
#NO.FUN-810091 --end--
 
     SELECT aaf03 INTO g_company FROM aaf_file
      WHERE aaf01 = tm.bookno AND aaf02 = g_lang    #No.FUN-740020
     SELECT * INTO g_aaa.* FROM aaa_file WHERE aaa01 = tm.bookno    #No.FUN-740020
     SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file          #No.CHI-6A0004 g_azi-->t_azi 
      WHERE azi01 = g_aaa.aaa03
 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND aaguser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND aaggrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
     #End:FUN-980030
 
 
     LET l_prem = mm -1
     #--->取部門期初
      LET  l_sql = " SELECT aao02,sum(aao05),sum(aao06),sum(aao05-aao06)  ",
                   " FROM aao_file ",
                   " WHERE aao03 = ",yy," AND aao04 <= ",l_prem,
                   " AND aao00 = '",tm.bookno,"'",
                   " AND aao01 =  ? "
 
     #--->部門判斷
     CASE
         WHEN NOT cl_null(babb05) AND NOT cl_null(eabb05)
              LET l_sql=l_sql CLIPPED,
              " AND (aao02  BETWEEN '",babb05,"'", " AND '",eabb05,"') "
         WHEN NOT cl_null(babb05) AND cl_null(eabb05)
              LET l_sql=l_sql CLIPPED, " AND aao02 >='",babb05,"'"
         WHEN cl_null(babb05) AND NOT cl_null(eabb05)
              LET l_sql=l_sql CLIPPED, " AND aao02 <='",eabb05,"'"
     END CASE
     LET l_sql=l_sql CLIPPED," GROUP BY aao02  ORDER BY aao02  "
 
     PREPARE r751_preaao FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('pre r751_preaao:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        EXIT PROGRAM
     END IF
     DECLARE r751_cursaao CURSOR FOR r751_preaao
 
     #--->取當期傳票明細
     LET l_sql = "SELECT ' ',' ',",
        " aba02,aba06,abb01,abb02,abb03,abb04,abb05,abb06,abb07,",
       #FUN-5C0015-----------------------------------------------(S)
       #" abb11,abb12,abb13,abb14,'',0,0,0,0",
        " abb11,abb12,abb13,abb14,",
        " abb31,abb32,abb33,abb34,abb35,abb36,",
        " '',0,0,0,0",
       #FUN-5C0015-----------------------------------------------(S)
        "  FROM aba_file,abb_file ",
        " WHERE abb03 = ? ",
        "   AND aba00 = '",tm.bookno,"' ",     #No.FUN-740020
        "   AND aba00 = abb00 ",
        "   AND aba01 = abb01 ",
        "   AND aba19 = 'Y' AND abapost = 'Y'  AND abaacti = 'Y'",
        "   AND aba02 BETWEEN '",bdate,"' AND '",edate,"' "
 
     #--->部門判斷
     CASE
         WHEN NOT cl_null(babb05) AND NOT cl_null(eabb05)
              LET l_sql=l_sql CLIPPED,
              " AND (abb05  BETWEEN '",babb05,"'", " AND '",eabb05,"') "
         WHEN NOT cl_null(babb05) AND cl_null(eabb05)
              LET l_sql=l_sql CLIPPED, " AND abb05 >='",babb05,"'"
         WHEN cl_null(babb05) AND NOT cl_null(eabb05)
              LET l_sql=l_sql CLIPPED, " AND abb05 <='",eabb05,"'"
     END CASE
     LET l_sql=l_sql CLIPPED," ORDER BY abb05"
 
     PREPARE r751_preabb FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('r751_preabb:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        EXIT PROGRAM
     END IF
     DECLARE r751_cursabb CURSOR FOR r751_preabb
 
    #-->取要列印的科目
     LET l_sql1= "SELECT aag01,aag02,aag13,aag07 ",  #FUN-6C0012
                 "  FROM aag_file ",
                 " WHERE ",tm.wc CLIPPED,
                 "   AND  aag00 = '",tm.bookno,"'",     #No.FUN-740020
                 "   AND  aag03 ='2' "
     IF tm.x = 'N' THEN
        LET l_sql1 = l_sql1 clipped," AND aag07 = '2' "
     END IF
     IF tm.x = 'Y' THEN
        LET l_sql1 = l_sql1 clipped," AND aag07 IN ('2','3') "
     END IF
     LET l_sql1= l_sql1 CLIPPED," AND aag38 = '",tm.aag38,"'"   #TQC-6C0098 add
 
     PREPARE aglr751_prepare2 FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare2:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        EXIT PROGRAM
     END IF
     DECLARE aglr751_curs2 CURSOR FOR aglr751_prepare2
 
#    CALL cl_outnam('aglr751') RETURNING l_name          #NO.FUN-810091 Mark
#NO.FUN-810091 -- begin --
#     START REPORT aglr751_rep TO l_name
#     LET g_pageno = 0
#NO.FUN-810091 -- end --
     #-->取科目
     FOREACH aglr751_curs2 INTO sr1.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach aag:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        #-->取當期傳票資料
        LET l_cnt = 0
        FOREACH r751_cursabb USING sr1.aag01 INTO sr.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach abb:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           LET l_cnt = l_cnt + 1
           LET sr.aag02=sr1.aag02
           LET sr.aag13=sr1.aag13  #FUN-6C0012
           IF tm.s='N' THEN LET sr.order1=' ' LET sr.order2=sr.aba02 END IF
           IF tm.s='Y' THEN
              LET sr.order1=sr.abb05 LET sr.order2=sr.aba02
           END IF
#NO.FUN-810091 -- begin --
#        OUTPUT TO REPORT aglr751_rep(sr.*)
         EXECUTE insert_prep USING sr.abb03,sr.order1,sr.order2,sr.abb01,sr.abb02,
                                   sr.aag02,sr.aag13,sr.abb11,sr.abb12,sr.abb13,
                                   sr.abb14,sr.abb31,sr.abb32,sr.abb33,sr.abb34,
                                   sr.abb35,sr.abb36,sr.abb06,sr.aba02,sr.abb05,
                                   sr.abb07,sr.abb04
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('execute insert_prep:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
#NO.FUN-810091 -- end --
        END FOREACH
        IF tm.t = 'Y' AND l_cnt = 0 THEN
           INITIALIZE sr.* TO NULL   #99.04.02 add 否則會帶上一筆資料
           LET sr.aag02=sr1.aag02
           LET sr.aag13=sr1.aag13   #FUN-6C0012
           LET sr.aba02=' '
           LET sr.abb03 = sr1.aag01
#NO.FUN-810091 -- begin --
#        OUTPUT TO REPORT aglr751_rep(sr.*)
         EXECUTE insert_prep USING sr.abb03,sr.order1,sr.order2,sr.abb01,sr.abb02,
                                   sr.aag02,sr.aag13,sr.abb11,sr.abb12,sr.abb13,
                                   sr.abb14,sr.abb31,sr.abb32,sr.abb33,sr.abb34,
                                   sr.abb35,sr.abb36,sr.abb06,sr.aba02,sr.abb05,
                                   sr.abb07,sr.abb04
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('execute insert_prep:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
#NO.FUN-810091 -- end --
        END IF
     END FOREACH
#NO.FUN-810091 -- begin --
#   FINISH REPORT aglr751_rep
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," ORDER BY abb03,order1,order2,abb01,abb02"
   PREPARE r751_prep1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('r751_prep1:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE r751_curs1 CURSOR FOR r751_prep1
   LET l_sql = "SELECT SUM(abb07) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " WHERE abb03=? AND abb05=? AND abb06='1'"
   PREPARE r751_prep_l_dep_d FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('r751_prep_l_dep_d:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE r751_curs_l_dep_d CURSOR FOR r751_prep_l_dep_d
   LET l_sql = "SELECT SUM(abb07) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " WHERE abb03=? AND abb05=? AND abb06='2'"
   PREPARE r751_prep_l_dep_c FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('r751_prep_l_dep_c:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE r751_curs_l_dep_c CURSOR FOR r751_prep_l_dep_c
   LET l_first = 1
   LET l_abb03 = NULL
   LET l_order1= NULL
   LET l_chg_abb03=0
   LET l_chg_order1=0
   FOREACH r751_curs1 INTO sr.abb03,sr.order1,sr.order2,sr.abb01,sr.abb02,
                           sr.aag02,sr.aag13,sr.abb11,sr.abb12,sr.abb13,
                           sr.abb14,sr.abb31,sr.abb32,sr.abb33,sr.abb34,
                           sr.abb35,sr.abb36,sr.abb06,sr.aba02,sr.abb05,
                           sr.abb07,sr.abb04
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach r751_curs1:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      INITIALIZE sr2.* TO NULL
      LET sr2.abb03  = sr.abb03
      LET sr2.order1 = sr.order1
      LET sr2.order2 = sr.order2
      LET sr2.abb01  = sr.abb01
      LET sr2.abb02  = sr.abb02
      LET sr2.aag02 = sr.aag02
      LET sr2.aag13 = sr.aag13
      LET sr2.abb06 = sr.abb06
      LET sr2.aba02 = sr.aba02
      LET sr2.abb05 = sr.abb05
      LET sr2.abb07 = sr.abb07
 
      #--->GROUP 切換標識符
      IF l_first = 1 THEN                # 第一筆記錄
         LET l_first = 0                 # 第一筆記錄只出現一次
         IF sr.abb03 IS NULL THEN        # key字段為空
            LET l_chg_abb03 = 1          # 置標識符
         ELSE                            # key字段不為空
            LET l_chg_abb03 = 1          # 置標識符
            LET l_abb03 = sr.abb03       # 備份舊值
         END IF
      ELSE                               # 非第一筆記錄
         IF sr.abb03 IS NOT NULL         # 且不為空值
            AND l_abb03<>sr.abb03 THEN   # 且不等于舊值
            LET l_chg_abb03 = 1          # 置標識符
            LET l_abb03 = sr.abb03       # 備份舊值
         END IF
      END IF
      
      CASE l_chg_abb03                   # GROUP order1 變更標識符
         WHEN 1
            IF sr.order1 IS NULL THEN
               LET l_chg_order1 = 1
            ELSE
               LET l_order1 = sr.order1
            	LET l_chg_order1 = 1
            END IF
         WHEN 0
            IF sr.order1 IS NOT NULL AND l_order1<>sr.order1 THEN
               LET l_chg_order1 = 1
               LET l_order1 = sr.order1
            END IF
         OTHERWISE
            EXIT CASE                    # BEFORE GROUP 標識符置0.5,AFTER GROUP 標識符置0
      END CASE
 
      #--->取期初
      IF l_chg_abb03=1 THEN              # GROUP abb03 判斷
         LET l_chg_abb03 = 0             # BEFORE GROUP
         LET dep_d=0 LET dep_c=0 LET dep_bal=0
         LET f_dep_d=0 LET f_dep_c=0 LET f_dep_bal=0
         LET t_d=0 LET t_c=0 LET t_bal=0
         #--->依部門匯總期初余額資料至l_table2
         FOREACH r751_cursaao USING sr.abb03 INTO l_aao02,l_pred,l_prec,l_prebal
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach r751_cursaao:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            IF l_pred IS NULL THEN LET l_pred = 0 END IF
            IF l_prec IS NULL THEN LET l_prec = 0 END IF
            IF l_prebal IS NULL THEN LET l_prebal = 0 END IF
            SELECT gem03 INTO l_gem03 FROM gem_file WHERE gem01=l_aao02
            IF SQLCA.sqlcode THEN LET l_gem03 = ' ' END IF
            EXECUTE insert_prep2 USING sr.abb03,l_aao02,l_gem03,l_pred,l_prec,l_prebal
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('execute insert_prep2:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            LET f_dep_d  =f_dep_d  +l_pred
            LET f_dep_c  =f_dep_c  +l_prec
            LET f_dep_bal=f_dep_bal+l_prebal
         END FOREACH
      END IF
 
      #--->生成異動碼字符串
      LET l_str=''
      IF NOT cl_null(sr.abb11) THEN
         LET l_str = l_str CLIPPED,g_x[16] CLIPPED,sr.abb11
      END IF
      IF NOT cl_null(sr.abb12) THEN
         LET l_str = l_str CLIPPED,g_x[17] CLIPPED,sr.abb12
      END IF
      IF NOT cl_null(sr.abb13) THEN
         LET l_str = l_str CLIPPED,g_x[18] CLIPPED,sr.abb13
      END IF
      IF NOT cl_null(sr.abb14) THEN
         LET l_str = l_str CLIPPED,g_x[19] CLIPPED,sr.abb14
      END IF
      IF NOT cl_null(sr.abb31) THEN
         LET l_str = l_str CLIPPED,g_x[22] CLIPPED,sr.abb31
      END IF
      IF NOT cl_null(sr.abb32) THEN
         LET l_str = l_str CLIPPED,g_x[23] CLIPPED,sr.abb32
      END IF
      IF NOT cl_null(sr.abb33) THEN
         LET l_str = l_str CLIPPED,g_x[24] CLIPPED,sr.abb33
      END IF
      IF NOT cl_null(sr.abb34) THEN
         LET l_str = l_str CLIPPED,g_x[25] CLIPPED,sr.abb34
      END IF
      IF NOT cl_null(sr.abb35) THEN
         LET l_str = l_str CLIPPED,g_x[26] CLIPPED,sr.abb35
      END IF
      IF NOT cl_null(sr.abb36) THEN
         LET l_str = l_str CLIPPED,g_x[27] CLIPPED,sr.abb36
      END IF
      IF cl_null(l_str) THEN
         LET l_str=sr.abb04
      END IF
 
      SELECT gem03 INTO l_gem03 FROM gem_file WHERE gem01=sr.abb05   # 部門名稱
 
      #--->本期金額統計
      IF sr.abb06 = '1' THEN     #借方      
         LET dep_d = dep_d + sr.abb07
      ELSE                       #貸方
         LET dep_c = dep_c + sr.abb07
      END IF
      LET dep_bal = dep_d - dep_c
 
      #--->部門金額統計
      IF l_chg_order1 = 1 THEN   # GROUP order1 判斷
         LET l_chg_order1=0
         LET l_dep_d = 0
         LET l_dep_c = 0
         OPEN r751_curs_l_dep_d USING sr.abb03,sr.abb05
         FETCH r751_curs_l_dep_d INTO l_dep_d
         IF l_dep_d IS NULL THEN LET l_dep_d = 0 END IF
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('fetch r751_curs_l_dep_d:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         CLOSE r751_curs_l_dep_d
         OPEN r751_curs_l_dep_c USING sr.abb03,sr.abb05
         FETCH r751_curs_l_dep_c INTO l_dep_c
         IF l_dep_c IS NULL THEN LET l_dep_c = 0 END IF
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('fetch r751_curs_l_dep_c:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         CLOSE r751_curs_l_dep_c
         LET l_dep_bal=l_dep_d - l_dep_c
      END IF
 
      #--->期初 + 本期金額
      LET t_d  =f_dep_d  +dep_d
      LET t_c  =f_dep_c  +dep_c
      LET t_bal=f_dep_bal+dep_bal
 
      EXECUTE insert_prep1 USING sr2.abb03,f_dep_d,f_dep_c,f_dep_bal,l_dep_d,l_dep_c,l_dep_bal,
                                 t_d,t_c,t_bal,sr2.order1,sr2.order2,sr2.abb01,sr2.abb02,sr2.aag02,sr2.aag13,
                                 sr2.abb06,dep_d,dep_c,dep_bal,sr2.aba02,sr2.abb05,l_gem03,l_str,sr2.abb07
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('execute insert_prep1:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #--->匯總額外摘要至l_table3
      LET l_cnt = 0
      DECLARE abc_curs CURSOR FOR
       SELECT abc03,abc04 FROM abc_file
        WHERE abc00 = tm.bookno AND abc01 = sr2.abb01 AND abc02 = sr2.abb02
      FOREACH abc_curs INTO l_abc03,l_abc04
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach aao:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         LET l_cnt = l_cnt + 1
         EXECUTE insert_prep3 USING sr.abb01,sr.abb02,l_abc03,l_abc04
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('execute insert_prep3:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
      END FOREACH
 
      IF l_cnt = 0 THEN    #無額外摘要abc04時
         EXECUTE insert_prep3 USING sr.abb01,sr.abb02,'',sr.abb04
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('execute insert_prep3:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
      END IF
 
   END FOREACH
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aglr751'
   IF g_zz05 = 'Y' THEN 
      CALL cl_wcchp(tm.wc,'aag01') RETURNING tm.wc
   ELSE
   	  LET tm.wc = ''
   END IF
   # 畫面上的選項條件除tm.e和tm.s外均嵌入SQL中實現,故此處只需傳這兩個條件參數
   LET g_str = tm.wc CLIPPED,";",tm.bdate,";",tm.edate,";",tm.babb05,";",
               tm.eabb05,";",tm.e,";",tm.s,";",t_azi04,";",t_azi05
   LET g_sql = " SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
               " SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",
               " SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED               
   CALL cl_prt_cs3('aglr751','aglr751',g_sql,g_str)
#NO.FUN-810091 -- end --
END FUNCTION
 
#NO.FUN-810091 -- begin --
#REPORT aglr751_rep(sr)
#   DEFINE
#          sr               RECORD
#                    order1 LIKE abb_file.abb05,  #No.FUN-680098 VARCHAR(20)
#                    order2 LIKE aba_file.aba02,  #No.FUN-680098 VARCHAR(20)
#                    aba02 LIKE aba_file.aba02,   # 傳票日期
#                    aba06 LIKE aba_file.aba06,   # Source codea來源碼
#                    abb01 LIKE abb_file.abb01,   # 傳票編號
#                    abb02 LIKE abb_file.abb02,   # 傳票編號項次
#                    abb03 LIKE abb_file.abb03,   # 科目編號
#                    abb04 LIKE abb_file.abb04,   # 摘要
#                    abb05 LIKE abb_file.abb05,   # 部門
#                    abb06 LIKE abb_file.abb06,   # 借:1,D or  貸:2,C
#                    abb07 LIKE abb_file.abb07,   # amount 異動金額
#                    abb11 LIKE abb_file.abb11,   # 異動碼1
#                    abb12 LIKE abb_file.abb12,   # 異動碼2
#                    abb13 LIKE abb_file.abb13,   # 異動碼3
#                    abb14 LIKE abb_file.abb14,   # 異動碼4
#                    abb31 LIKE abb_file.abb31,   #異動5 #FUN-5C0015-(S)
#                    abb32 LIKE abb_file.abb32,   #異動6
#                    abb33 LIKE abb_file.abb33,   #異動7
#                    abb34 LIKE abb_file.abb34,   #異動8
#                    abb35 LIKE abb_file.abb35,   #異動9
#                    abb36 LIKE abb_file.abb36,   #異動10#FUN-5C0015-(E)
#                    aag02 LIKE aag_file.aag02,   # course name
#                    aag13 LIKE aag_file.aag13    #FUN-6C0012
#                    END RECORD,
#          l_aao02                     LIKE aao_file.aao02,
#          dep_d,dep_c,dep_bal         LIKE aao_file.aao05,  #科目本期小計
#          t_d,t_c,t_bal               LIKE aao_file.aao05,  #科目合計(期初+本期)
#          l_dep_d,l_dep_c,l_dep_bal   LIKE aao_file.aao05,  #部門小計
#          f_dep_d,f_dep_c,f_dep_bal   LIKE aao_file.aao05,  #期初餘額
#          l_pred,l_prec,l_prebal      LIKE aao_file.aao05,  #abb07
#          l_dramt,l_cramt,l_balamt    LIKE aao_file.aao05,
#          l_gem03                     LIKE gem_file.gem03,
#          l_last_sw                   LIKE type_file.chr1,       #No.FUN-680098 VARCHAR(1)
#          l_str                       LIKE type_file.chr1000,    #No.FUN-680098 VARCHAR(60)
#          m,l_no,l_no2                LIKE type_file.num5,       #No.FUN-680098 smallint
#          l_abc04                     LIKE abc_file.abc04,       #No.FUN-680098 VARCHAR(30)
#          g_head1                     STRING
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#
#  #order1:部門  order2:傳票日期
#  ORDER BY sr.abb03,sr.order1,sr.order2,sr.abb01,sr.abb02
#  FORMAT
#    PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED, pageno_total
#      LET g_head1 = g_x[11] CLIPPED,bdate,'-',edate,'       ',
#                    g_x[9] CLIPPED,babb05,'-',eabb05
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_head1))/2)+1,g_head1
#      PRINT g_dash[1,g_len]
##      PRINT g_x[10] CLIPPED,sr.abb03 CLIPPED,' ',sr.aag02  #FUN-6C0012
#      #FUN-6C0012.....begin
#      IF tm.e = 'N' THEN
#         PRINT g_x[10] CLIPPED,sr.abb03 CLIPPED,' ',sr.aag02
#      ELSE
#         PRINT g_x[10] CLIPPED,sr.abb03 CLIPPED,' ',sr.aag13
#      END IF
#      #FUN-6C0012.....end
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#            g_x[39],g_x[40]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.abb03    #科目
#      SKIP TO TOP OF PAGE
#       LET f_dep_d=0 LET f_dep_c=0 LET f_dep_bal=0
#       LET l_dep_d=0 LET l_dep_c=0 LET l_dep_bal=0
#       LET dep_d=0 LET dep_c=0 LET dep_bal=0
#       LET t_d=0 LET t_c=0 LET t_bal=0
#      #-->取期初
#       FOREACH r751_cursaao USING sr.abb03 INTO l_aao02,l_pred,l_prec,l_prebal
#           IF SQLCA.sqlcode != 0 THEN
#              CALL cl_err('foreach aao:',SQLCA.sqlcode,1)
#              EXIT FOREACH
#           END IF
#           SELECT gem03 INTO l_gem03 FROM gem_file WHERE gem01=l_aao02
#           IF SQLCA.sqlcode THEN LET l_gem03 = ' ' END IF
#           PRINT COLUMN g_c[33],l_aao02,COLUMN g_c[34],l_gem03,
#                 COLUMN g_c[38],g_x[12] CLIPPED,
#                 COLUMN g_c[39],cl_numfor(l_pred,39,t_azi04),          #No.CHI-6A0004 g_azi-->t_azi
#                 COLUMN g_c[40],cl_numfor(l_prec,40,t_azi04)           #No.CHI-6A0004 g_azi-->t_azi
#           LET f_dep_d  =f_dep_d  +l_pred
#           LET f_dep_c  =f_dep_c  +l_prec
#           LET f_dep_bal=f_dep_bal+l_prebal
#       END FOREACH
#       PRINT COLUMN g_dash2
#       PRINT COLUMN g_c[35],g_x[13] CLIPPED,
#             COLUMN g_c[36],cl_numfor(f_dep_d,36,t_azi05),
#             COLUMN g_c[37],g_x[14] CLIPPED,
#             COLUMN g_c[38],cl_numfor(f_dep_c,38,t_azi05),
#             COLUMN g_c[39],g_x[15] CLIPPED,
#             COLUMN g_c[40],cl_numfor(f_dep_bal,40,t_azi05)
#
#   ON EVERY ROW
#     #科目本期小計:  dep_d,dep_c,dep_bal
#      LET l_no=0
#      IF NOT cl_null(sr.abb11) THEN LET l_no=l_no+1 END IF
#      IF NOT cl_null(sr.abb12) THEN LET l_no=l_no+1 END IF
#      IF NOT cl_null(sr.abb13) THEN LET l_no=l_no+1 END IF
#      IF NOT cl_null(sr.abb14) THEN LET l_no=l_no+1 END IF
#     #FUN-5C0015-----------------------------------------------(S)
#      IF NOT cl_null(sr.abb31) THEN LET l_no=l_no+1 END IF
#      IF NOT cl_null(sr.abb32) THEN LET l_no=l_no+1 END IF
#      IF NOT cl_null(sr.abb33) THEN LET l_no=l_no+1 END IF
#      IF NOT cl_null(sr.abb34) THEN LET l_no=l_no+1 END IF
#      IF NOT cl_null(sr.abb35) THEN LET l_no=l_no+1 END IF
#      IF NOT cl_null(sr.abb36) THEN LET l_no=l_no+1 END IF
#     #FUN-5C0015-----------------------------------------------(E)
#      LET m=0
#      IF sr.abb06 = '1' THEN     #借方
#         LET m = g_c[39]
#        #LET dep_bal = dep_bal + sr.abb07
#         LET dep_d   = dep_d   + sr.abb07
#      ELSE                       #貸方
#         LET m = g_c[40]
#        #LET dep_bal = dep_bal - sr.abb07
#         LET dep_c   = dep_c   + sr.abb07
#      END IF
#      SELECT gem03 INTO l_gem03 FROM gem_file WHERE gem01=sr.abb05
#      PRINT COLUMN g_c[31],sr.abb01,COLUMN g_c[32],sr.aba02,
#            COLUMN g_c[33],sr.abb05,COLUMN g_c[34],l_gem03;
#      CASE
#          WHEN  l_no = 1    #1:異動1+abb04
#                LET l_str = g_x[16] CLIPPED,sr.abb11,' ',sr.abb04
#          WHEN  l_no = 2    #2:異動1+異動2
#                LET l_str = g_x[16] CLIPPED,sr.abb11,' ',
#                            g_x[17] CLIPPED,sr.abb12
#          WHEN  l_no = 3    #3:異動1+異動2+異動3
#                LET l_str = g_x[16] CLIPPED,sr.abb11,' ',
#                            g_x[17] CLIPPED,sr.abb12,' ',
#                            g_x[18] CLIPPED,sr.abb13
#          WHEN  l_no = 4    #4:異動1+異動2+異動3
#                LET l_str = g_x[16] CLIPPED,sr.abb11,' ',
#                            g_x[17] CLIPPED,sr.abb12,' ',
#                            g_x[18] CLIPPED,sr.abb13,' ',
#                            g_x[19] CLIPPED,sr.abb14     #FUN-5C0015
#         #->FUN-5C0015-----------------------------------------------(S)
#          WHEN  l_no = 5    #5:異動1+異動2+異動3+異動4+異動5
#                LET l_str = g_x[16] CLIPPED,sr.abb11,' ',
#                            g_x[17] CLIPPED,sr.abb12,' ',
#                            g_x[18] CLIPPED,sr.abb13,' ',
#                            g_x[19] CLIPPED,sr.abb14,' ',
#                            g_x[22] CLIPPED,sr.abb31
#          WHEN  l_no = 6    #6:異動1+異動2+異動3+異動4+異動5+異動6
#                LET l_str = g_x[16] CLIPPED,sr.abb11,' ',
#                            g_x[17] CLIPPED,sr.abb12,' ',
#                            g_x[18] CLIPPED,sr.abb13,' ',
#                            g_x[19] CLIPPED,sr.abb14,' ',
#                            g_x[22] CLIPPED,sr.abb31,' ',
#                            g_x[23] CLIPPED,sr.abb32
#          WHEN  l_no = 7    #7:異動1+異動2+異動3+異動4+異動5+異動6+異動7
#                LET l_str = g_x[16] CLIPPED,sr.abb11,' ',
#                            g_x[17] CLIPPED,sr.abb12,' ',
#                            g_x[18] CLIPPED,sr.abb13,' ',
#                            g_x[19] CLIPPED,sr.abb14,' ',
#                            g_x[22] CLIPPED,sr.abb31,' ',
#                            g_x[23] CLIPPED,sr.abb32,' ',
#                            g_x[24] CLIPPED,sr.abb33
#          WHEN  l_no = 8    #8:異動1+異動2+異動3+異動4+異動5+異動6+異動7+異動8
#                LET l_str = g_x[16] CLIPPED,sr.abb11,' ',
#                            g_x[17] CLIPPED,sr.abb12,' ',
#                            g_x[18] CLIPPED,sr.abb13,' ',
#                            g_x[19] CLIPPED,sr.abb14,' ',
#                            g_x[22] CLIPPED,sr.abb31,' ',
#                            g_x[23] CLIPPED,sr.abb32,' ',
#                            g_x[24] CLIPPED,sr.abb33,' ',
#                            g_x[25] CLIPPED,sr.abb34
#          WHEN  l_no = 9    #9:異動1+異動2+異動3+異動4+異動5+異動6+異動7+異動8+異動9
#                LET l_str = g_x[16] CLIPPED,sr.abb11,' ',
#                            g_x[17] CLIPPED,sr.abb12,' ',
#                            g_x[18] CLIPPED,sr.abb13,' ',
#                            g_x[19] CLIPPED,sr.abb14,' ',
#                            g_x[22] CLIPPED,sr.abb31,' ',
#                            g_x[23] CLIPPED,sr.abb32,' ',
#                            g_x[24] CLIPPED,sr.abb33,' ',
#                            g_x[25] CLIPPED,sr.abb34,' ',
#                            g_x[26] CLIPPED,sr.abb35
#          WHEN  l_no = 10   #10:異動1+異動2+異動3+異動4+異動5+異動6+異動7+異動8+異動9+異動10
#                LET l_str = g_x[16] CLIPPED,sr.abb11,' ',
#                            g_x[17] CLIPPED,sr.abb12,' ',
#                            g_x[18] CLIPPED,sr.abb13,' ',
#                            g_x[19] CLIPPED,sr.abb14,' ',
#                            g_x[22] CLIPPED,sr.abb31,' ',
#                            g_x[23] CLIPPED,sr.abb32,' ',
#                            g_x[24] CLIPPED,sr.abb33,' ',
#                            g_x[25] CLIPPED,sr.abb34,' ',
#                            g_x[26] CLIPPED,sr.abb35,' ',
#                            g_x[27] CLIPPED,sr.abb36
#         #->FUN-5C0015-----------------------------------------------(E)
#          OTHERWISE LET l_str = sr.abb04  #0:abb04
#      END CASE
#      IF #l_no=0                            OR   #無異動
#         (l_no=1 AND NOT cl_null(sr.abb04)) OR   #1:異動1+abb04
#          l_no=2 OR                              #2:異動1+異動2
#          l_no=3 OR                              #3:異動1+異動2+異動3
#         #->FUN-5C0015-----------------------------------------------(E)
#         #l_no=4 THEN                            #4:異動1+異動2+異動3
#          l_no=4 OR                              #4:異動1+異動2+異動3
#          l_no=5 OR    #5:異動1+異動2+異動3+異動4+異動5
#          l_no=6 OR    #6:異動1+異動2+異動3+異動4+異動5+異動6
#          l_no=7 OR    #7:異動1+異動2+異動3+異動4+異動5+異動6+異動7
#          l_no=8 OR    #8:異動1+異動2+異動3+異動4+異動5+異動6+異動7+異動8
#          l_no=9 OR    #9:異動1+異動2+異動3+異動4+異動5+異動6+異動7+異動8+異動9
#          l_no=10 THEN #10:異動1+異動2+異動3+異動4+異動5+異動6+異動7+異動8+異動9+異動10
#         #->FUN-5C0015-----------------------------------------------(E)
#          PRINT COLUMN g_c[35],l_str CLIPPED,
#                COLUMN m, cl_numfor(sr.abb07,18,t_azi04) CLIPPED             #No.CHI-6A0004 g_azi-->t_azi
#      END IF
#     #--->列印額外摘要
#      LET l_no2 = 0  LET g_cnt=0
#      DECLARE abc_curs CURSOR FOR
#       SELECT abc04 FROM abc_file
#        WHERE abc00 = tm.bookno AND abc01 = sr.abb01 AND abc02 = sr.abb02
#      FOREACH abc_curs INTO l_abc04
#         IF g_cnt=0 THEN        #處理摘要,金額的情形
#            CASE
#                 WHEN l_no=0
#                      IF cl_null(sr.abb04) THEN  LET l_str=l_abc04
#                      ELSE
#                         PRINT COLUMN g_c[35],l_str CLIPPED,COLUMN g_c[36],l_abc04,
#                               COLUMN m,
#                               cl_numfor(sr.abb07,18,t_azi04) CLIPPED   #No.CHI-6A0004 g_azi-->t_azi
#                      END IF
#                 WHEN l_no=1
#                      IF cl_null(sr.abb04) THEN
#                         PRINT COLUMN g_c[35],l_str CLIPPED,COLUMN g_c[36],l_abc04,
#                               COLUMN m,
#                               cl_numfor(sr.abb07,18,t_azi04) CLIPPED    #No.CHI-6A0004 g_azi-->t_azi
#                      ELSE
#                         PRINT COLUMN g_c[35],l_abc04;
#                         LET l_no2=1
#                      END IF
#                 WHEN l_no=2 OR l_no=3
#                      IF NOT cl_null(sr.abb04) THEN
#                         PRINT COLUMN g_c[35],sr.abb04,COLUMN g_c[36],l_abc04
#                      ELSE
#                         PRINT COLUMN g_c[35],l_abc04;
#                         LET l_no2=1
#                      END IF
#                 WHEN l_no=4
#                      PRINT COLUMN g_c[35],g_x[19] CLIPPED,COLUMN g_c[36],sr.abb14,' ';
#                      IF NOT cl_null(sr.abb04) THEN
#                         PRINT COLUMN g_c[35],sr.abb04
#                         PRINT COLUMN g_c[35],l_abc04
#                         LET l_no2=1
#                      ELSE
#                         PRINT COLUMN g_c[35],l_abc04
#                      END IF
#                OTHERWISE EXIT CASE
#            END CASE
#            LET g_cnt=g_cnt+1
#            CONTINUE FOREACH
#         END IF
#         IF g_cnt=1 AND l_no=0 AND cl_null(sr.abb04) THEN
#            PRINT COLUMN g_c[35],l_str CLIPPED,COLUMN g_c[36],l_abc04 ,
#                  COLUMN m,cl_numfor(sr.abb07,18,t_azi04) CLIPPED     #No.CHI-6A0004 g_azi-->t_azi
#            LET g_cnt=g_cnt+1
#            CONTINUE FOREACH
#         END IF
#         LET l_no2 = l_no2 + 1
#         CASE
#             WHEN l_no2 = 1  PRINT column g_c[35],l_abc04;
#             WHEN l_no2 = 2  PRINT column g_c[36],l_abc04
#                  LET l_no2 = 0
#             OTHERWISE  EXIT CASE
#         END CASE
#         LET g_cnt=g_cnt+1
#     END FOREACH
#     IF g_cnt=0 THEN    #無額外摘要abc04時
#         CASE
#           WHEN l_no=0
#                PRINT COLUMN g_c[35],l_str CLIPPED,
#                      COLUMN m,cl_numfor(sr.abb07,18,t_azi04) CLIPPED   #No.CHI-6A0004 g_azi-->t_azi
#                LET l_no2=2
#           WHEN l_no=1
#                IF cl_null(sr.abb04) THEN
#                   PRINT COLUMN g_c[35],l_str CLIPPED,
#                         COLUMN m,cl_numfor(sr.abb07,18,t_azi04) CLIPPED  #No.CHI-6A0004 g_azi-->t_azi
#                   LET l_no2=2
#                END IF
#           WHEN l_no=2 OR l_no=3
#                IF NOT cl_null(sr.abb04) THEN
#                   PRINT COLUMN g_c[35],sr.abb04 CLIPPED
#                   LET l_no2=2
#                END IF
#           WHEN l_no=4
#                PRINT COLUMN g_c[35],g_x[19],
#                      COLUMN g_c[36],sr.abb14,COLUMN g_c[37],sr.abb04
#                LET l_no2=2
#           OTHERWISE EXIT CASE
#         END CASE
#     END IF
#     IF l_no2!=2 AND g_cnt>1 THEN PRINT END IF
#
#   AFTER GROUP OF sr.order1      #部門
#    IF tm.s='Y' THEN
#     LET l_dep_d=0 LET l_dep_c=0 LET l_dep_bal=0
#     LET l_dep_d=GROUP SUM(sr.abb07) WHERE sr.abb03=sr.abb03
#                                 AND sr.abb05=sr.order1
#                                 AND sr.abb06='1'
#     LET l_dep_c=GROUP SUM(sr.abb07) WHERE sr.abb03=sr.abb03
#                                 AND sr.abb05=sr.order1
#                                 AND sr.abb06='2'
#     IF cl_null(l_dep_d)   THEN LET l_dep_d=0   END IF
#     IF cl_null(l_dep_c)   THEN LET l_dep_c=0   END IF
#     IF cl_null(l_dep_bal) THEN LET l_dep_bal=0 END IF
#     LET l_dep_bal=l_dep_d - l_dep_c
#     PRINT g_dash2
#     PRINT COLUMN g_c[34],g_x[9] CLIPPED,
#           COLUMN g_c[35],g_x[13] CLIPPED,
#           COLUMN g_c[36],cl_numfor(l_dep_d,36,t_azi05),
#           COLUMN g_c[37],g_x[14] CLIPPED,
#           COLUMN g_c[38],cl_numfor(l_dep_c,38,t_azi05),
#           COLUMN g_c[39],g_x[15] CLIPPED,
#           COLUMN g_c[40],cl_numfor(l_dep_bal,40,t_azi05)
#    END IF
#
#   AFTER GROUP OF sr.abb03       #科目總計:t_d,t_c,t_bal
#      LET dep_bal=dep_d - dep_c
#      PRINT g_dash2
#      PRINT COLUMN g_c[35],g_x[13] CLIPPED,
#            COLUMN g_c[36],cl_numfor(dep_d,36,t_azi05),
#            COLUMN g_c[37],g_x[14] CLIPPED,
#            COLUMN g_c[38],cl_numfor(dep_c,38,t_azi05),
#            COLUMN g_c[39],g_x[15] CLIPPED,
#            COLUMN g_c[40],cl_numfor(dep_bal,40,t_azi05)
#      PRINT g_dash[1,g_len]
#      LET t_d  =f_dep_d  +dep_d     #期初 + 本期金額
#      LET t_c  =f_dep_c  +dep_c
#      LET t_bal=f_dep_bal+dep_bal
#      PRINT COLUMN g_c[35],g_x[13] CLIPPED,
#            COLUMN g_c[36],cl_numfor(t_d,36,t_azi05),
#            COLUMN g_c[37],g_x[14] CLIPPED,
#            COLUMN g_c[38],cl_numfor(t_c,38,t_azi05),
#            COLUMN g_c[39],g_x[15] CLIPPED,
#            COLUMN g_c[40],cl_numfor(t_bal,40,t_azi05)
#
#   ON LAST ROW
#      IF g_zz05 = 'Y' THEN
#         CALL cl_wcchp(tm.wc,'aag01') RETURNING tm.wc
#            #-- TQC-630166 begin
#              #IF tm.wc[001,070] > ' ' THEN
#              #   PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#              #IF tm.wc[071,140] > ' ' THEN
#              #   PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#              #IF tm.wc[141,210] > ' ' THEN
#              #   PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#              #IF tm.wc[211,280] > ' ' THEN
#              #   PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#              CALL cl_prt_pos_wc(tm.wc)
#            #-- TQC-630166 end
#      END IF
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#         PRINT g_dash[1,g_len]
#         PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#      ELSE
#         SKIP 2 LINE
#      END IF
#END REPORT
#Patch....NO.TQC-610035 <001> #
#NO.FUN-810091 -- end --
