# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglr741.4gl
# Descriptions...: 部門明細分類帳
# Date & Author..: 96/07/04 By Melody
# Modify.........: No.FUN-510007 05/02/14 By Nicola 報表架構修改
# Modify.........: No.FUN-5C0015 06/01/03 By miki
#                  列印l_buf異動碼值內容，加上abb11~36，放寬欄寬至60
# Modify.........: No.TQC-660021 06/06/19 By Smapmin 報表總頁次空白
# Modify.........: No.FUN-660147 06/06/27 By Smapmin 修改部門輸入限制
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680098 06/09/01 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-740020 07/04/11 By Lynn 會計科目加帳套
# Modify.........: No.TQC-6C0098 07/04/22 By Sarah QBE加一選項"是否列印內部管理科目"(aag38)
# Modify.........: No.MOD-740247 07/04/22 By Sarah 重新過單
# Modify.........: No.FUN-780059 07/09/06 By xiaofeizhu 報表改寫由Crystal Report產出
# Modify.........: No.MOD-7B0259 07/12/20 By Smapmin 科目期初金額/幣別取位有誤
# Modify.........: No.TQC-810009 08/01/04 By xiaofeizhu 報表合計出錯
# Modify.........: No.MOD-8A0130 08/10/16 By Sarah bdate,edate預設值g_today
# Modify.........: No.FUN-940013 09/04/30 By jan aag01 欄位增加開窗功能
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A40133 10/05/07 By liuxqa modify sql
# Modify.........: No:CHI-A70007 10/07/13 By Summer 多帳期改用s_azmm,並依據畫面上的帳別傳遞使用
# Modify.........: No.FUN-B20054 11/02/24 By lixiang 先錄入帳套,科目根據帳套過濾;結構改為DIALOG
# Modify.........: No.MOD-BC0203 11/12/21 By Dido l_sql/l_sql1 變數型態調整
# Modify.........: No.MOD-BC0280 11/12/30 By Polly 科目開窗改開q_aag02
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
                 wc        STRING,
                 bookno    LIKE aag_file.aag00,  #No.FUN-740020
                 t         LIKE type_file.chr1,  #No.FUN-680098 VARCHAR(1)
                 u         LIKE type_file.chr1,  #No.FUN-680098 VARCHAR(1)
                 s         LIKE type_file.chr1,  #No.FUN-680098 VARCHAR(1)
                 v         LIKE type_file.chr1,  #No.FUN-680098 VARCHAR(1)
                 x         LIKE type_file.chr1,  #No.FUN-680098 VARCHAR(1)
                 aag38     LIKE aag_file.aag38,  #TQC-6C0098 add
                 more      LIKE type_file.chr1   #No.FUN-680098 VARCHAR(1)
              END RECORD,
                yy         LIKE azn_file.azn02,        #No.FUN-680098 INTEGER
                mm         LIKE azn_file.azn04,        #No.FUN-680098 INTEGER
          l_begin,l_end    LIKE type_file.dat,         #No.FUN-680098 DATE
          bdate            LIKE type_file.dat,         # Begin #No.FUN-680098 date
          edate            LIKE type_file.dat,         # Ended #No.FUN-680098 date
          babb05           LIKE abb_file.abb05,        #No.FUN-680098 VARCHAR(6)
          eabb05           LIKE abb_file.abb05,        #No.FUN-680098 VARCHAR(6)
          l_abb05_old      LIKE abb_file.abb05,        #No.FUN-680098 VARCHAR(6)
          dept_d,dept_c   LIKE abb_file.abb07,
          l_flag          LIKE type_file.chr1,         #No.FUN-680098 VARCHAR(1)
          g_bookno        LIKE aaa_file.aaa01
   DEFINE g_cnt           LIKE type_file.num10         #No.FUN-680098  INTEGER
   DEFINE g_i             LIKE type_file.num5          #count/index for any purpose    #No.FUN-680098 SMALLINT
#--str FUN-780059 add--#                                                                                                            
   DEFINE   l_table      STRING                                                                                                     
   DEFINE   g_sql        STRING                                                                                                     
   DEFINE   g_str        STRING                                                                                                     
#--end FUN-780059 add--#
 
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
 #--str FUN-780059 add--#                                                                                                           
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##                                                          
   LET g_sql = "aea05.aea_file.aea05,",                                                                                             
               "aea02.aea_file.aea02,",                                                                                             
               "aea03.aea_file.aea03,",                                                                                             
               "abb04.abb_file.abb04,",                                                                                             
               "abb05.abb_file.abb05,",                                                                                             
               "abb06.abb_file.abb06,",                                                                                             
               "abb07.abb_file.abb07,",                                                                                             
               "aag02.aag_file.aag02,",                                                                                             
               "azi04.azi_file.azi04,",                                                                                             
               "m_gem02.gem_file.gem02,",
               "l_chr.type_file.chr1,",                                                                                           
               "l_bal.abb_file.abb07,",                                                                                             
               "l_bal_1.abb_file.abb07,",                                                                                           
               "l_buf.type_file.chr1000,",                                                                                          
               "l_abc04.abc_file.abc04,",                                                                                           
               "l_t_d.abb_file.abb07,",                                                                                             
               "l_t_c.abb_file.abb07,",                                                                                             
               "dept_d.abb_file.abb07,",                                                                                            
               "dept_c.abb_file.abb07,",
               "l_d.abb_file.abb07,",
               "l_c.abb_file.abb07"
 
   LET l_table = cl_prt_temptable('aglr741',g_sql) CLIPPED   # 產生Temp Table                                                       
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                       
   #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,     #TQC-A40133 mark                                                                       
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,   #TQC-A40133 mod
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"                                                
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
   #------------------------------ CR (1) ------------------------------#
 
   LET tm.bookno = ARG_VAL(1)    #No.FUN-740020
   LET g_pdate   = ARG_VAL(2)    # Get arguments from command line
   LET g_towhom  = ARG_VAL(3)
   LET g_rlang   = ARG_VAL(4)
   LET g_bgjob   = ARG_VAL(5)
   LET g_prtway  = ARG_VAL(6)
   LET g_copies  = ARG_VAL(7)
   LET tm.wc     = ARG_VAL(8)
   LET tm.t      = ARG_VAL(9)
   LET tm.u      = ARG_VAL(10)
   LET tm.s      = ARG_VAL(11)   #TQC-610056
   LET tm.v      = ARG_VAL(12)
   LET tm.x      = ARG_VAL(13)
   LET tm.aag38  = ARG_VAL(14)   #TQC-6C0098 add
   LET babb05    = ARG_VAL(15)   #TQC-610056
   LET eabb05    = ARG_VAL(16)   #TQC-610056
   LET bdate     = ARG_VAL(17)   #TQC-610056
   LET edate     = ARG_VAL(18)   #TQC-610056
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(19)
   LET g_rep_clas = ARG_VAL(20)
   LET g_template = ARG_VAL(21)
   LET g_rpt_name = ARG_VAL(22)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
#No.FUN-740020 --begin
   IF tm.bookno IS NULL OR tm.bookno = ' ' THEN
      LET tm.bookno = g_aza.aza81
   END IF
#No.FUN-740020  --end
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL aglr741_tm()
   ELSE
      CALL aglr741()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION aglr741_tm()
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01        #No.FUN-580031
DEFINE p_row,p_col       LIKE type_file.num5,       #No.FUN-680098 SMALLINT
       l_cmd             LIKE type_file.chr1000     #No.FUN-680098 VARCHAR(400)
DEFINE li_chk_bookno     LIKE type_file.num5        #FUN-B20054
 
   CALL s_dsmark(tm.bookno)   #No.FUN-740020
   LET p_row = 3 LET p_col = 20
   OPEN WINDOW aglr741_w AT p_row,p_col
     WITH FORM "agl/42f/aglr741"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL s_shwact(0,0,tm.bookno)    #No.FUN-740020
   CALL cl_opmsg('p')
   LET dept_d=0
   LET dept_c=0
   INITIALIZE tm.* TO NULL                  # Default condition
   LET tm.bookno = g_aza.aza81              #FUN-B20054
   LET bdate   = g_today   #MOD-8A0130 mod #NULL
   LET edate   = g_today   #MOD-8A0130 mod #NULL
   LET babb05  = NULL
   LET eabb05  = NULL
   LET tm.t    = 'N'
   LET tm.u    = 'N'
   LET tm.s    = 'Y'
   LET tm.v    = 'N'
   LET tm.x    = 'Y'
   LET tm.aag38= 'N'   #TQC-6C0098 add
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'

   DISPLAY BY NAME tm.t,tm.u,tm.s,tm.v,tm.x,tm.more   #FUN-B20054
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
#        LET INT_FLAG = 0 CLOSE WINDOW aglr741_w 
#        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#        EXIT PROGRAM
#           
#    END IF
#    IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
#FUN-B20054--mark--end
    
    #  DISPLAY BY NAME tm.t,tm.u,tm.s,tm.v,tm.x,tm.more   #FUN-B20054
    #  INPUT BY NAME tm.bookno,babb05,eabb05,bdate,edate,tm.t,tm.u,tm.s,tm.v,tm.x,tm.aag38,tm.more    #No.FUN-740020   #TQC-6C0098 add tm.aag38
    #              WITHOUT DEFAULTS   #FUN-B20054
      INPUT BY NAME babb05,eabb05,bdate,edate,tm.t,tm.u,tm.s,tm.v,tm.x,tm.aag38,tm.more
                   ATTRIBUTE(WITHOUT DEFAULTS)  #FUN-B20054
    
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---

   #FUN-B20054--mark--str-- 
   #      #No.FUN-740020 --begin
   #      AFTER FIELD bookno
   #         IF cl_null(tm.bookno) THEN
   #            NEXT FIELD bookno
   #         END IF     
         #No.FUN-740020 --end
   #FUN-B20054--mark--end
 
         #-----FUN-660147---------
         AFTER FIELD babb05
            IF cl_null(babb05) THEN
               NEXT FIELD babb05
            END IF
         #-----END FUN-660147-----
 
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
          AFTER FIELD u
            IF tm.u NOT MATCHES "[YN]" THEN NEXT FIELD u END IF
          AFTER FIELD s
            IF tm.s NOT MATCHES "[YN]" THEN NEXT FIELD s END IF
          AFTER FIELD v
            IF tm.v NOT MATCHES "[YN]" THEN NEXT FIELD v END IF
          AFTER FIELD x
            IF tm.x NOT MATCHES "[YN]" THEN NEXT FIELD x END IF
          #str TQC-6C0098 add
          AFTER FIELD aag38
            IF tm.aag38 NOT MATCHES "[YN]" THEN NEXT FIELD aag38 END IF
          #end TQC-6C0098 add
          AFTER FIELD more
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                         g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,
                         g_bgjob,g_time,g_prtway,g_copies
            END IF

#FUN-B20054--mark--str-- 
#    ON ACTION CONTROLR
#        CALL cl_show_req_fields()
# 
#    ON ACTION CONTROLG 
#       CALL cl_cmdask()      # Command execution
#         #No.FUN-740020  --Begin                                                                                                    
#    ON ACTION CONTROLP                                                                                                         
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
#     ON IDLE g_idle_seconds
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
    #FUN-940013--begin--add
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
                  #LET g_qryparam.form = "q_aag"                               #MOD-BC0280 mark
                   LET g_qryparam.form = "q_aag02"                             #MOD-BC0280 add 
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
        LET INT_FLAG = 0 CLOSE WINDOW aglr741_w 
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
    IF l_begin=bdate THEN LET l_begin='9999/21/31' END IF

 #FUN-B20054--mark--str--
 #   IF INT_FLAG THEN
 #      LET INT_FLAG = 0 CLOSE WINDOW aglr741_w 
 #      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
 #      EXIT PROGRAM
 #         
 #   END IF
 #FUN-B20054--mark--end
    
    IF g_bgjob = 'Y' THEN
       SELECT zz08 INTO l_cmd FROM zz_file      #get exec cmd (fglgo xxxx)
             WHERE zz01='aglr741'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('aglr741','9031',1)   
       ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
          LET l_cmd = l_cmd CLIPPED,            #(at time fglgo xxxx p1 p2 p3)
                         " '",tm.bookno CLIPPED,"'",   #No.FUN-740020
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.v CLIPPED,"'",
                         " '",tm.x CLIPPED,"'" ,
                         " '",tm.aag38 CLIPPED,"'",              #TQC-6C0098 add
                         #-----TQC-610056---------
                         " '",babb05 CLIPPED,"'" ,
                         " '",eabb05 CLIPPED,"'" ,
                         " '",bdate CLIPPED,"'" ,
                         " '",edate CLIPPED,"'" ,
                         #-----END TQC-610056-----
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
          CALL cl_cmdat('aglr741',g_time,l_cmd)      # Execute cmd at later time
       END IF
       CLOSE WINDOW aglr741_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
       EXIT PROGRAM
    END IF
    CALL cl_wait()
    CALL aglr741()
    ERROR ""
  END WHILE
  CLOSE WINDOW aglr741_w
END FUNCTION
 
FUNCTION aglr741()
   DEFINE l_name        LIKE type_file.chr20,             # External(Disk) file name        #No.FUN-680098 VARCHAR(20)
#       l_time          LIKE type_file.chr8               #No.FUN-6A0073
          l_sql         STRING,           # RDSQL STATEMENT        #No.FUN-680098 VARCHAR(1000) #MOD-BC0203 mod 1000 -> STRING 
          l_sql1        STRING,           # RDSQL STATEMENT       #No.FUN-680098  VARCHAR(1000) #MOD-BC0203 mod 1000 -> STRING
          l_chr         LIKE type_file.chr1,              #No.FUN-680098 VARCHAR(1)   #MOD-740247
          l_c,l_d,l_bal LIKE abb_file.abb07,              #No.FUN-780059                                                            
          l_bal_1       LIKE abb_file.abb07,              #No.FUN-780059   
          g_sum         LIKE abb_file.abb07,              #No.FUN-780059                                                         
          l_t_d,l_t_c   LIKE abb_file.abb07,              #No.FUN-780059                                                            
          l_buf         LIKE type_file.chr1000,           #No.FUN-780059                                                            
          l_abc04       LIKE abc_file.abc04,              #No.FUN-780059   VARCHAR(30)                                                 
          m_gem02       LIKE gem_file.gem02,              #No.FUN-780059   VARCHAR(10)
          sr1    RECORD
                    aag223 LIKE aag_file.aag223,  #No.FUN-680098  VARCHAR(5)
                    aag224 LIKE aag_file.aag224,  #No.FUN-680098  VARCHAR(5)
                    aag225 LIKE aag_file.aag225,  #No.FUN-680098  VARCHAR(5)
                    aag226 LIKE aag_file.aag226,  #No.FUN-680098  VARCHAR(5)
                    aag01 LIKE aag_file.aag01,   # course no
                    aag02 LIKE aag_file.aag02,   # course name
                    aag07 LIKE aag_file.aag07    # course type
                 END RECORD,
          sr     RECORD
                    aea05 LIKE aea_file.aea05,   # acct. kinds
                    aea02 LIKE aea_file.aea02,   # trans date
                    aea03 LIKE aea_file.aea03,   # trans no
                    aea04 LIKE aea_file.aea04,   # trans seq
                    aba05 LIKE aba_file.aba05,   # input date
                    aba06 LIKE aba_file.aba06,   # Source code
                    abb04 LIKE abb_file.abb04,   #
                    abb05 LIKE abb_file.abb05,   #
                    abb06 LIKE abb_file.abb06,   # D or  C
                    abb07 LIKE abb_file.abb07,   # amount
                    abb11 LIKE abb_file.abb11,   #
                    abb12 LIKE abb_file.abb12,   #
                    abb13 LIKE abb_file.abb13,   #
                    abb14 LIKE abb_file.abb14,   #
                    abb31 LIKE abb_file.abb31,   #FUN-5C0015---(S)
                    abb32 LIKE abb_file.abb32,
                    abb33 LIKE abb_file.abb33,
                    abb34 LIKE abb_file.abb34,
                    abb35 LIKE abb_file.abb35,
                    abb36 LIKE abb_file.abb36,   #FUN-5C0015---(E)
                    aag02 LIKE aag_file.aag02,   # course name
                    amt    LIKE type_file.num5,      #No.FUN-680098  smallint
                    azi04 LIKE azi_file.azi04,
                    l_bal      LIKE abb_file.abb07,
                    l_d        LIKE abb_file.abb07,
                    l_c        LIKE abb_file.abb07
                 END RECORD
   #--str FUN-780059 add--#                                                                                                         
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##                                                            
   CALL cl_del_data(l_table)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                                                        
   #------------------------------ CR (2) ------------------------------#                                                           
   #--end FUN-780059 add--#
 
     SELECT aaf03 INTO g_company FROM aaf_file
      WHERE aaf01 = tm.bookno
        AND aaf02 = g_lang
 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #        LET tm.wc = tm.wc clipped," AND aaguser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #        LET tm.wc = tm.wc clipped," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #        LET tm.wc = tm.wc clipped," AND aaggrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
     #End:FUN-980030
 
 
     LET l_sql1= "SELECT ",
                 "  aag223,aag224,aag225,aag226,aag01,aag02,aag07 ",
                 "  FROM aag_file ",
                 " WHERE aag03 ='2' AND aag07 IN ('2','3')",
                 "   AND aag00 = '",tm.bookno,"'",    #No.FUN-740020
                 "   AND aag05='Y' AND ",tm.wc
     LET l_sql1= l_sql1 CLIPPED," AND aag38 = '",tm.aag38,"'"   #TQC-6C0098 add
 
     PREPARE aglr741_prepare2 FROM l_sql1
        IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
        DECLARE aglr741_curs2 CURSOR FOR aglr741_prepare2
#       CALL cl_outnam('aglr741') RETURNING l_name              #FUN-780059-mark
#       START REPORT aglr741_rep TO l_name                      #FUN-780059-mark
        LET g_pageno = 0
        FOREACH aglr741_curs2 INTO sr1.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           IF tm.x = 'N' AND sr1.aag07 = '3' THEN CONTINUE FOREACH END IF
           LET g_cnt = 0
           LET l_sql = "SELECT ",
              "  aea05,aea02,aea03,aea04,aba05,aba06,abb04,abb05,abb06,abb07,",
             #FUN-5C0015--------------------------------------------(S)
             #"  abb11,abb12,abb13,abb14,'',0,azi04,0,0,0",
              "  abb11,abb12,abb13,abb14,",
              "  abb31,abb32,abb33,abb34,abb35,abb36,",
              "  '',0,azi04,0,0,0",
             #FUN-5C0015--------------------------------------------(E)
              "  FROM aea_file,aba_file,abb_file,azi_file,aaa_file ",
              " WHERE aea05 = '",sr1.aag01,"'",
            "   AND aea00 = '",tm.bookno,"' ",    #No.FUN-740020
            "   AND aea00 = aba00 ",
            "   AND aba00 = abb00 ",
              "   AND aea02 BETWEEN '",bdate,"' AND '",edate,"' ",
              "   AND abb01 = aea03 AND abb02 = aea04 ",
              "   AND abb05 !=' ' AND abb05 IS NOT NULL ",
              "   AND aea00 = aaa01 AND aaa03 = azi01 ",
              "   AND aba01 = aea03"
## No:2429 modify 1998/09/22 ----------
            CASE
               WHEN NOT cl_null(babb05) AND NOT cl_null(eabb05)
                    LET l_sql=l_sql CLIPPED,
                        " AND abb05 >='",babb05,"'",
                        " AND abb05 <='",eabb05,"'"
               WHEN NOT cl_null(babb05) AND cl_null(eabb05)
                    LET l_sql=l_sql CLIPPED,
                        " AND abb05 >='",babb05,"'"
               WHEN cl_null(babb05) AND NOT cl_null(eabb05)
                    LET l_sql=l_sql CLIPPED,
                        " AND abb05 <='",eabb05,"'"
            END CASE
            LET l_sql=l_sql CLIPPED," ORDER BY abb05"
## -------
           PREPARE aglr741_prepare1 FROM l_sql
           IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
            EXIT PROGRAM
         END IF
           DECLARE aglr741_curs1 CURSOR FOR aglr741_prepare1
           LET l_flag='N'
           LET l_abb05_old='---'
           FOREACH aglr741_curs1 INTO sr.*
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1)
                 EXIT FOREACH
              END IF
              LET l_flag='Y'
              LET sr.aag02=sr1.aag02
#-str--FUN-780059--add--#
#        LET dept_d = 0                                                                                                             
#        LET dept_c = 0
#        LET l_bal = l_bal + sr.l_bal                                #TQC-810009                                                                       
#        LET l_d   = sr.l_d                                                                                                         
#        LET l_c   = sr.l_c                                                                                                         
#        LET l_t_d = 0                                                                                                              
#        LET l_t_c = 0                                                                                                              
#        LET l_bal = l_bal + l_d - l_c  # 期初餘額
#        LET l_bal_1 = l_bal
 
         SELECT gem02 INTO m_gem02 FROM gem_file                                                                                    
          WHERE gem01 = sr.abb05                                                                                                    
            AND gem05 = 'Y'                                                                                                         
            AND gemacti = 'Y'                                                                                                       
         IF STATUS = 100 THEN                                                                                                       
            LET m_gem02 = ' '                                                                                                       
         END IF
#        IF sr.abb07 != 0 THEN        #異動金額                                                                                     
#           IF sr.abb06 = '1' THEN     #借方                                                                                        
#              LET l_bal = l_bal + sr.abb07                                                                                         
#              LET l_t_d = l_t_d + sr.abb07                                                                                         
#           ELSE                       #貸方                                                                                        
#              LET l_bal = l_bal - sr.abb07                                                                                         
#              LET l_t_c = l_t_c + sr.abb07                                                                                         
#           END IF                                                                                                                  
#        END IF
                                                                                                                             
            LET l_buf = ' '                                                                                                         
                                                                                                                                    
            IF sr.abb11 IS NOT NULL THEN LET l_buf = sr.abb11 END IF    #異動碼-1                                                   
            IF sr.abb12 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb12 END IF    #異動碼-2                                 
            IF sr.abb13 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb13 END IF    #異動碼-3                                 
            IF sr.abb14 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb14 END IF    #異動碼-4 
            IF sr.abb31 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb31 END IF  #異動碼-5                                   
            IF sr.abb32 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb32 END IF  #異動碼-6                                   
            IF sr.abb33 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb33 END IF  #異動碼-7                                   
            IF sr.abb34 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb34 END IF  #異動碼-8                                   
            IF sr.abb35 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb35 END IF  #異動碼-9                                   
            IF sr.abb36 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb36 END IF  #異動碼-10                                  
            IF tm.v = 'Y' THEN                                                                                                      
               DECLARE abc_curs CURSOR FOR SELECT abc04 FROM abc_file                                                               
                                            WHERE abc00 = tm.bookno                                                   
                                              AND abc01 = sr.aea03                                                                  
                                              AND abc02 = sr.aea04                                                                  
               FOREACH abc_curs INTO l_abc04
               END FOREACH                                                                                                          
            END IF
#        LET g_sum = g_sum + l_bal                                                                                                  
#        LET dept_d = dept_d + l_t_d                                                                                                
#        LET dept_c = dept_c + l_t_c
 
#-end--FUN-780059--add--#
#             OUTPUT TO REPORT aglr741_rep(sr.*)                #FUN-780059-mark
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-770052 *** ##                                                   
           EXECUTE insert_prep USING                                                                                                
                   sr.aea05,sr.aea02,sr.aea03,sr.abb04,sr.abb05,sr.abb06,sr.abb07,'',        #TQC-810009                       
                   sr.azi04,m_gem02,l_chr,'0',l_bal_1,l_buf,l_abc04,l_t_d,l_t_c,dept_d,      #TQC-810009
                   dept_c,'0','0'                                                            #TQC-810009
          #------------------------------ CR (3) ------------------------------#
         
#         END FOREACH
         IF l_abb05_old<>sr.abb05 THEN
           LET l_abb05_old=sr.abb05
 
           SELECT sum(aao05-aao06) INTO sr.l_bal FROM aao_file
              WHERE aao01 = sr1.aag01 AND aao03 = yy AND aao04 <= mm-1
                AND aao00 = tm.bookno AND aao02=sr.abb05   #No.FUN-740020
         IF sr.l_bal IS NULL THEN LET sr.l_bal = 0 END IF
           SELECT sum(abb07) INTO sr.l_d FROM abb_file,aba_file
              WHERE abb03 = sr1.aag01 AND aba01 = abb01 AND abb06='1'
                AND aba02 >= l_begin AND aba02 < bdate AND abb05=sr.abb05
                AND aba00 = tm.bookno AND abapost='Y'     #No.FUN-740020
                AND aba03=yy AND aba04<=mm   #MOD-7B0259
           IF sr.l_d IS NULL THEN LET sr.l_d =0 END IF
           SELECT sum(abb07) INTO sr.l_c FROM aba_file,abb_file
              WHERE abb03 = sr1.aag01 AND aba01 = abb01 AND abb06='2'
                AND aba02 >= l_begin AND aba02 < bdate AND abb05=sr.abb05
                AND aba00 = tm.bookno AND abapost='Y'     #No.FUN-740020
                AND aba03=yy AND aba04<=mm   #MOD-7B0259
           IF sr.l_c IS NULL THEN LET sr.l_c =0 END IF
           IF tm.t='N' AND l_flag='N' AND
              sr.l_bal=0 AND sr.l_d=0 AND sr.l_c = 0 THEN
              CONTINUE FOREACH
           END IF
           IF  l_flag='N' AND
              sr.l_bal=0 AND sr.l_d=0 AND sr.l_c = 0 THEN
              CONTINUE FOREACH
           END IF
           LET sr.aea05=sr1.aag01
           #LET sr.aea02=NULL   #MOD-7B0259
           LET sr.aea02=bdate-1   #MOD-7B0259
           LET sr.aag02=sr1.aag02
           #LET sr.azi04=0   #MOD-7B0259
           LET sr.abb07=0
#          OUTPUT TO REPORT aglr741_rep(sr.*)                       #FUN-780059_mark
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-770052 *** ##                                                   
           EXECUTE insert_prep USING                                                                                                
                   sr.aea05,sr.aea02,sr.aea03,sr.abb04,sr.abb05,sr.abb06,sr.abb07,sr.aag02,                                         
                   sr.azi04,m_gem02,l_chr,sr.l_bal,l_bal_1,l_buf,l_abc04,l_t_d,l_t_c,dept_d,      #TQC-810009
                   dept_c,sr.l_d,sr.l_c                                     
          #------------------------------ CR (3) ------------------------------#
         END IF
           END FOREACH
        END FOREACH
#       FINISH REPORT aglr741_rep                                   #FUN-780059_mark
 
#       CALL cl_prt(l_name,g_prtway,g_copies,g_len)                 #FUN-780059_mark
#-str-FUN-780059--add--#                                                                                                            
    IF g_zz05 = 'Y' THEN                                                                                                       
       CALL cl_wcchp(tm.wc,'aag01') RETURNING tm.wc                                                                            
    ELSE
       LET tm.wc = ''
    END IF                                                                                                                     
#-end-FUN-780059--add--#
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-770052 **** ##                                                        
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''                                                                                                                  
    LET g_str = tm.wc,";",bdate,";",edate,";",tm.u,";",'',";",                                                                    
                tm.s                                                                                                                
    CALL cl_prt_cs3('aglr741','aglr741',l_sql,g_str)                                                                                
    #------------------------------ CR (4) ------------------------------#
END FUNCTION
 
#-str-FUN-780059--mark--#
#REPORT aglr741_rep(sr)
#  DEFINE
#         sr     RECORD
#                   aea05 LIKE aea_file.aea05,
#                   aea02 LIKE aea_file.aea02,
#                   aea03 LIKE aea_file.aea03,
#                   aea04 LIKE aea_file.aea04,
#                   aba05 LIKE aba_file.aba05,
#                   aba06 LIKE aba_file.aba06,
#                   abb04 LIKE abb_file.abb04,
#                   abb05 LIKE abb_file.abb05,
#                   abb06 LIKE abb_file.abb06,
#                   abb07 LIKE abb_file.abb07,
#                   abb11 LIKE abb_file.abb11,
#                   abb12 LIKE abb_file.abb12,
#                   abb13 LIKE abb_file.abb13,
#                   abb14 LIKE abb_file.abb14,
#                   abb31 LIKE abb_file.abb31,       #FUN-5C0015---(S)
#                   abb32 LIKE abb_file.abb32,
#                   abb33 LIKE abb_file.abb33,
#                   abb34 LIKE abb_file.abb34,
#                   abb35 LIKE abb_file.abb35,
#                   abb36 LIKE abb_file.abb36,      #FUN-5C0015---(E)
#                   aag02 LIKE aag_file.aag02,
#                   amt   LIKE type_file.num5,      #No.FUN-680098  SMALLINT
#                   azi04 LIKE azi_file.azi04,
#                   l_bal      LIKE abb_file.abb07,
#                   l_d        LIKE abb_file.abb07,
#                   l_c        LIKE abb_file.abb07
#                END RECORD,
#         l_amt,l_c,l_d,l_bal  LIKE abb_file.abb07,
#         l_t_d,l_t_c          LIKE abb_file.abb07,
#         g_sum                LIKE abb_file.abb07,
#         l_last_sw            LIKE type_file.chr1,      #No.FUN-680098  VARCHAR(1)
#         l_abb07              LIKE abb_file.abb07,
#         l_chr                LIKE type_file.chr1,      #No.FUN-680098  VARCHAR(1)
#         l_abb06              LIKE abb_file.abb06,      #No.FUN-680098  VARCHAR(1)
#         l_continue           LIKE type_file.chr1,      #No.FUN-680098  VARCHAR(1)
#         l_sql2               LIKE type_file.chr1000,   #No.FUN-680098  VARCHAR(100)
#        #l_buf                VARCHAR(15)                  #FUN-5C0015    
#         l_buf                LIKE type_file.chr1000,   #FUN-5C0015   #No.FUN-680098 VARCHAR(60)
#         l_abc04              LIKE abc_file.abc04,      #No.FUN-680098  VARCHAR(30)
#         m_gem02              LIKE gem_file.gem02       #No.FUN-680098  VARCHAR(10)
#  DEFINE g_head1              STRING
 
#  OUTPUT
#     TOP MARGIN g_top_margin
#     LEFT MARGIN g_left_margin
#     BOTTOM MARGIN g_bottom_margin
#     PAGE LENGTH g_page_line
 
#  ORDER BY sr.abb05,sr.aea05,sr.aea02
 
#  FORMAT
#     PAGE HEADER
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
#        LET g_pageno = g_pageno + 1
#        LET pageno_total = PAGENO USING '<<<',"/pageno"
#        PRINT g_head CLIPPED,pageno_total
#        LET g_head1 = g_x[9] CLIPPED,bdate,'-',edate
#        PRINT g_head1
#        PRINT g_dash[1,g_len]
#        PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
#        PRINT g_dash1
#        LET l_last_sw = 'n'
#        LET l_continue = 'N'
#
#     BEFORE GROUP OF sr.abb05
#        IF tm.u = 'Y' THEN
#           SKIP TO TOP OF PAGE
#        END IF
#        LET dept_d = 0
#        LET dept_c = 0
#
#     BEFORE GROUP OF sr.aea05     #明細科目
#        IF tm.u = 'Y' THEN
#           SKIP TO TOP OF PAGE
#        END IF
 
#        LET l_bal = sr.l_bal
#        LET l_d   = sr.l_d
#        LET l_c   = sr.l_c
#        LET l_t_d = 0
#        LET l_t_c = 0
#        LET l_bal = l_bal + l_d - l_c  # 期初餘額
 
#        SELECT gem02 INTO m_gem02 FROM gem_file
#         WHERE gem01 = sr.abb05
#           AND gem05 = 'Y'
#           AND gemacti = 'Y'
#        IF STATUS = 100 THEN
#           LET m_gem02 = ' '
#        END IF
#        IF l_bal >= 0 THEN
#           PRINT COLUMN g_c[31],g_x[10] CLIPPED,
#                 COLUMN g_c[32],sr.abb05,
#                 COLUMN g_c[33],m_gem02
#           PRINT COLUMN g_c[31],g_x[11] CLIPPED,
#                 COLUMN g_c[32],sr.aea05 CLIPPED,
#                 COLUMN g_c[33],sr.aag02 CLIPPED,
#                 COLUMN g_c[34],l_chr CLIPPED,
#                 COLUMN g_c[36],cl_numfor(l_bal,36,sr.azi04),
#                 COLUMN g_c[37],'D'
#        ELSE
#           LET l_amt =l_bal * (-1)
#           PRINT COLUMN g_c[31],g_x[10] CLIPPED,
#                 COLUMN g_c[32],sr.abb05,
#                 COLUMN g_c[33],m_gem02
#           PRINT COLUMN g_c[31],g_x[11] CLIPPED,
#                 COLUMN g_c[32],sr.aea05 CLIPPED,
#                 COLUMN g_c[33],sr.aag02 CLIPPED,
#                 COLUMN g_c[34],l_chr CLIPPED,
#                 COLUMN g_c[36],cl_numfor(l_bal,36,sr.azi04),
#                 COLUMN g_c[37],'C'
#        END IF
#        PRINT
#
#     ON EVERY ROW
#        IF sr.abb07 != 0 THEN        #異動金額
#           LET l_continue = 'Y'
#           IF sr.abb06 = '1' THEN     #借方
#              LET l_bal = l_bal + sr.abb07
#              LET l_t_d = l_t_d + sr.abb07
#           ELSE                       #貸方
#              LET l_bal = l_bal - sr.abb07
#              LET l_t_c = l_t_c + sr.abb07
#           END IF
 
#           LET l_buf = ' '
 
#          #FUN-5C0015------------------------------------------------------(S)
#           IF sr.abb11 IS NOT NULL THEN LET l_buf = sr.abb11 END IF    #異動碼-1
#          #IF sr.abb12 IS NOT NULL THEN LET l_buf = sr.abb12 END IF    #異動碼-2
#          #IF sr.abb13 IS NOT NULL THEN LET l_buf = sr.abb13 END IF    #異動碼-3
#          #IF sr.abb14 IS NOT NULL THEN LET l_buf = sr.abb14 END IF    #異動碼-4
#           IF sr.abb12 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb12 END IF    #異動碼-2
#           IF sr.abb13 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb13 END IF    #異動碼-3
#           IF sr.abb14 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb14 END IF    #異動碼-4
#           IF sr.abb31 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb31 END IF  #異動碼-5
#           IF sr.abb32 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb32 END IF  #異動碼-6
#           IF sr.abb33 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb33 END IF  #異動碼-7
#           IF sr.abb34 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb34 END IF  #異動碼-8
#           IF sr.abb35 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb35 END IF  #異動碼-9
#           IF sr.abb36 IS NOT NULL THEN LET l_buf = l_buf CLIPPED," ",sr.abb36 END IF  #異動碼-10
#          #FUN-5C0015------------------------------------------------------(E)
 
#           PRINT COLUMN g_c[31],sr.aea02,
#                 COLUMN g_c[32],sr.aea03,
#                 COLUMN g_c[33],l_buf;
#           IF sr.abb06 = '1' THEN
#              PRINT COLUMN g_c[34],cl_numfor(sr.abb07,34,sr.azi04);
#           ELSE
#              PRINT COLUMN g_c[35],cl_numfor(sr.abb07,35,sr.azi04);
#           END IF
 
#           IF l_bal >=0 THEN
#              PRINT COLUMN g_c[36],cl_numfor(l_bal,36,sr.azi04),
#                    COLUMN g_c[37],'D'
#           ELSE
#              LET l_amt = l_bal * (-1)
#              PRINT COLUMN g_c[36],cl_numfor(l_bal,36,sr.azi04),
#                    COLUMN g_c[37],'C'
#           END IF
 
#           #Print 摘要
#           IF tm.s = 'Y' THEN
#              PRINT COLUMN g_c[31],sr.abb04
#           END IF
#
#           IF tm.v = 'Y' THEN
#              DECLARE abc_curs CURSOR FOR SELECT abc04 FROM abc_file
#                                           WHERE abc00 = tm.bookno   #No.FUN-740020
#                                             AND abc01 = sr.aea03
#                                             AND abc02 = sr.aea04
#              FOREACH abc_curs INTO l_abc04
#                 IF l_abc04 IS NOT NULL THEN
#                    PRINT COLUMN g_c[32],l_abc04
#                 END IF
#              END FOREACH
#           END IF
#           LET l_continue = 'N'
#        END IF
#
#     AFTER GROUP OF sr.aea05
#        #LET g_pageno = 0   #TQC-660021
#        IF l_t_d != 0 OR l_t_c != 0 THEN
#           PRINT
#           PRINT COLUMN g_c[33],g_x[12] CLIPPED,
#                 COLUMN g_c[34],cl_numfor(l_t_d,34,sr.azi04),
#                 COLUMN g_c[35],cl_numfor(l_t_c,35,sr.azi04)
#        END IF
#        IF tm.u = 'N' THEN
#           PRINT g_dash2[1,g_len]
#        END IF
#        LET g_sum = g_sum + l_bal
#        LET dept_d = dept_d + l_t_d
#        LET dept_c = dept_c + l_t_c
#
#     AFTER GROUP OF sr.abb05
#        #LET g_pageno = 0   #TQC-660021
#        PRINT COLUMN g_c[33],g_x[13] CLIPPED,
#              COLUMN g_c[34],cl_numfor(dept_d,34,sr.azi04),
#              COLUMN g_c[35],cl_numfor(dept_c,35,sr.azi04)
#        IF tm.u = 'N' THEN
#           PRINT g_dash2[1,g_len]
#        END IF
#
#     ON LAST ROW
#        IF g_zz05 = 'Y' THEN
#           CALL cl_wcchp(tm.wc,'aag01') RETURNING tm.wc
#         #-- TQC-630166 begin
#           #IF tm.wc[001,070] > ' ' THEN                  # for 80
#           #   PRINT COLUMN g_c[31],g_x[8] CLIPPED,
#           #         COLUMN g_c[32],tm.wc[001,070] CLIPPED
#           #END IF
#           #IF tm.wc[071,140] > ' ' THEN
#           #   PRINT COLUMN g_c[32],tm.wc[071,140] CLIPPED
#           #END IF
#           #IF tm.wc[141,210] > ' ' THEN
#           #   PRINT COLUMN g_c[32],tm.wc[141,210] CLIPPED
#           #END IF
#           #IF tm.wc[211,280] > ' ' THEN
#           #   PRINT COLUMN g_c[32],tm.wc[211,280] CLIPPED
#           #END IF
#           CALL cl_prt_pos_wc(tm.wc)
#         #-- TQC-630166
#        END IF
#        PRINT g_dash[1,g_len]
#        LET l_last_sw = 'y'
#        PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
#
#     PAGE TRAILER
#        IF l_last_sw = 'n' THEN
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
#        ELSE
#           SKIP 2 LINE
#        END IF
 
#END REPORT}
#-end-FUN-780059--mark--#
