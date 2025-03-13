# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: aglg740.4gl
# Descriptions...: 部門總分類帳
# Date & Author..: 96/07/03 By Melody
# Modify.........: No.FUN-510007 05/02/14 By Nicola 報表架構修改
# Modify.........: No.FUN-5C0015 06/01/03 By miki
#                  列印l_buf異動碼值內容，加上abb11~36，放寬欄寬至60
# Modify.........: No.FUN-660147 06/06/27 By Smapmin 修改部門輸入限制
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680098 06/09/01 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6C0012 06/12/27 By Judy 新增打印額外名稱功能
# Modify.........: No.FUN-740020 07/04/11 By Lynn 會計科目加帳套
# Modify.........: No.TQC-6C0098 07/04/22 By Sarah QBE加一選項"是否列印內部管理科目"(aag38)
# Modify.........: No.MOD-740246 07/04/22 By Sarah 重新過單
# Modify.........: No.FUN-780059 07/09/04 By xiaofeizhu 報表改寫由Crystal Report產出
# Modify.........: No.TQC-820008 08/02/16 By baofei 修改INSERT INTO temptable語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A70007 10/07/13 By Summer 多帳期改用s_azmm,並依據畫面上的帳別傳遞使用
# Modify.........: No:MOD-B20028 11/02/10 By Dido 寫入 temptable 位數差異處理 
# Modify.........: No.FUN-B20054 11/02/24 By lixiang 先錄入帳套,科目根據帳套過濾;結構改為DIALOG
# Modify.........: No.MOD-B80220 11/08/22 By wujie   sql选取比sr少一个变量
# Modify.........: No.FUN-B80158 11/09/06 By yangtt 明細類CR轉換成GRW
# Modify.........: No.FUN-B80158 12/01/06 By qirl MOD-BC0203追單
#                                12/01/18 By chenying MOD-BC0280追單
# Modify.........: No.FUN-C50005 12/05/03 By qirl GR程式優化 
# Modify.........: No.CHI-C80041 12/12/22 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
                 wc        STRING,
                 bookno    LIKE aag_file.aag00,   #No.FUN-740020
                 t         LIKE type_file.chr1,   #No.FUN-680098  VARCHAR(1)   
                 u         LIKE type_file.chr1,   #No.FUN-680098  VARCHAR(1)   
                 s         LIKE type_file.chr1,   #No.FUN-680098  VARCHAR(1)   
                 v         LIKE type_file.chr1,   #No.FUN-680098  VARCHAR(1)   
                 x         LIKE type_file.chr1,   #No.FUN-680098  VARCHAR(1)   
                 e         LIKE type_file.chr1,   #FUN-6C0012
                 aag38     LIKE aag_file.aag38,   #TQC-6C0098 add
                 more      LIKE type_file.chr1    #No.FUN-680098  VARCHAR(1)
              END RECORD,
                yy         LIKE azn_file.azn02,           #No.FUN-680098 INTEGER
                mm         LIKE azn_file.azn04,           #No.FUN-680098 INTEGER  
          l_begin,l_end    LIKE type_file.dat,            #No.FUN-680098 DATE  
          babb05           LIKE aab_file.aab02,      
          eabb05           LIKE aab_file.aab02,
          bdate            LIKE type_file.dat,              # Begin date    #No.FUN-680098   DATE
          edate            LIKE type_file.dat,              # Ended date    #No.FUN-680098   DATE
          m_dept           LIKE abb_file.abb05,              #No.FUN-680098  VARCHAR(6)
#          g_bookno         LIKE aaa_file.aaa01,  #帳別      #No.FUN-740020
          l_flag           LIKE type_file.chr1,              #No.FUN-680098  VARCHAR(1)
          dept_d,dept_c    LIKE abb_file.abb07
   DEFINE g_cnt            LIKE type_file.num10              #No.FUN-680098 integer
   DEFINE g_i              LIKE type_file.num5     #count/index for any purpose      #No.FUN-680098 smallint
#--str FUN-780059 add--#                                                                                                            
   DEFINE   l_table      STRING                                                                                                        
   DEFINE   g_sql        STRING                                                                                                        
   DEFINE   g_str        STRING                                                                                                        
#--end FUN-780059 add--#
 
###GENGRE###START
TYPE sr1_t RECORD
    aea01 LIKE aea_file.aea01,
    aea02 LIKE aea_file.aea02,
    aea03 LIKE aea_file.aea03,
    aea04 LIKE aea_file.aea04,  #FUN-B80158
    abb04 LIKE abb_file.abb04,
    abb05 LIKE abb_file.abb05,
    abb06 LIKE abb_file.abb06,
    abb07 LIKE abb_file.abb07,
    aag02 LIKE aag_file.aag02,
    aag13 LIKE aag_file.aag13,
    azi04 LIKE azi_file.azi04,
    m_gem02 LIKE gem_file.gem02,
    l_bal LIKE abb_file.abb07,
    l_bal_1 LIKE abb_file.abb07,
    l_buf LIKE type_file.chr1000,
    l_chr LIKE type_file.chr1,
    l_abc04 LIKE abc_file.abc04,
    l_t_d LIKE abb_file.abb07,
    l_t_c LIKE abb_file.abb07,
    dept_d LIKE abb_file.abb07,
    dept_c LIKE abb_file.abb07,
    abb07_1 LIKE abb_file.abb07,    #FUN-B80158 add
    abb07_2 LIKE abb_file.abb07     #FUN-B80158 add
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
 #--str FUN-780059 add--#                                                                                                           
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##                                                          
   LET g_sql = "aea01.aea_file.aea01,",                                                                                             
               "aea02.aea_file.aea02,",                                                                                             
               "aea03.aea_file.aea03,",
               "aea04.aea_file.aea04,",  #FUN-B80158
               "abb04.abb_file.abb04,",                                                                                                 
               "abb05.abb_file.abb05,",                                                                                                 
               "abb06.abb_file.abb06,",                                                                                              
               "abb07.abb_file.abb07,",
               "aag02.aag_file.aag02,",                                                                                             
               "aag13.aag_file.aag13,",                                                                                             
               "azi04.azi_file.azi04,",                                                                                           
               "m_gem02.gem_file.gem02,",                                                                                           
               "l_bal.abb_file.abb07,",
               "l_bal_1.abb_file.abb07,",                                                                                           
               "l_buf.type_file.chr1000,",
               "l_chr.type_file.chr1,",
               "l_abc04.abc_file.abc04,",
               "l_t_d.abb_file.abb07,",
               "l_t_c.abb_file.abb07,",
               "dept_d.abb_file.abb07,",                                                                                           
               "dept_c.abb_file.abb07,",                                                                                               
               "abb07_1.abb_file.abb07,",    #FUN-B80158 add
               "abb07_2.abb_file.abb07"      #FUN-B80158 add
                                                                                                                                    
   LET l_table = cl_prt_temptable('aglg740',g_sql) CLIPPED   # 產生Temp Table                                                       
   IF l_table = -1 THEN
      CALL cl_gre_drop_temptable(l_table)                    #FUN-B80158
      EXIT PROGRAM
   END IF                  # Temp Table產生                                                       
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #No.TQC-820008                                                                          
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?)"  #FUN-B80158 add 2 ? #FUN-B80158 ?                                                                    
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1)
      CALL cl_gre_drop_temptable(l_table)                    #FUN-B80158
      EXIT PROGRAM
   END IF                                                                                                                           
   #------------------------------ CR (1) ------------------------------#
 
   LET tm.bookno= ARG_VAL(1)    #No.FUN-740020
   LET g_pdate = ARG_VAL(2)            # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc = ARG_VAL(8)
   #-----TQC-610056---------
   LET babb05 = ARG_VAL(9)
   LET eabb05 = ARG_VAL(10)
   LET bdate = ARG_VAL(11)
   LET edate = ARG_VAL(12)
   LET tm.t = ARG_VAL(13)
   LET tm.u = ARG_VAL(14)
   LET tm.s = ARG_VAL(15)
   LET tm.v = ARG_VAL(16)
   LET tm.x = ARG_VAL(17)
   #-----END TQC-610056-----
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(18)
   LET g_rep_clas = ARG_VAL(19)
   LET g_template = ARG_VAL(20)
   #No.FUN-570264 ---end---
   LET tm.e  = ARG_VAL(21)  #FUN-6C0012
   LET tm.aag38 = ARG_VAL(22)   #TQC-6C0098 add
   LET g_rpt_name = ARG_VAL(23)  #No.FUN-7C0078
 
#No.FUN-740020  ---begin
   IF tm.bookno IS NULL OR tm.bookno = ' ' THEN
      LET tm.bookno = g_aza.aza81
   END IF
#No.FUN-740020  ---end
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL aglg740_tm()
   ELSE
      CALL aglg740()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
   CALL cl_gre_drop_temptable(l_table)                    #FUN-B80158
END MAIN
 
FUNCTION aglg740_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01          #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680098 smallint
       l_cmd          LIKE type_file.chr1000       #No.FUN-680098 VARCHAR(400)
DEFINE li_chk_bookno  LIKE type_file.num5          #FUN-B20054 
   CALL s_dsmark(tm.bookno)
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW aglg740_w AT p_row,p_col
     WITH FORM "agl/42f/aglg740"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL s_shwact(0,0,tm.bookno)
   CALL cl_opmsg('p')
   LET dept_d=0
   LET dept_c=0
   INITIALIZE tm.* TO NULL                  # Default condition
   LET tm.bookno = g_aza.aza81              #FUN-B20054 
   LET bdate   = NULL
   LET edate   = NULL
   LET babb05  = NULL
   LET eabb05  = NULL
   LET tm.t    = 'Y'
   LET tm.u    = 'N'
   LET tm.s    = 'Y'
   LET tm.v    = 'N'
   LET tm.x    = 'N'
   LET tm.e    = 'N'  #FUN-6C0012
   LET tm.aag38= 'N'  #TQC-6C0098 add
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'

   DISPLAY BY NAME tm.t,tm.u,tm.s,tm.v,tm.x,tm.e,tm.more   #FUN-B20054   
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
#         ON ACTION locale
#            LET g_action_choice = "locale"
#            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
#              ON ACTION exit
#              LET INT_FLAG = 1
#              EXIT CONSTRUCT
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
#         CLOSE WINDOW aglg740_w
#         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#         CALL cl_gre_drop_temptable(l_table)                    #FUN-B80158
#         EXIT PROGRAM
#      END IF
# 
#      IF tm.wc = ' 1=1' THEN
#         CALL cl_err('','9046',0)
#         CONTINUE WHILE
#      END IF
#FUN-B20054--mark--end 
    #  DISPLAY BY NAME tm.t,tm.u,tm.s,tm.v,tm.x,tm.e,tm.more   #FUN-6C0012  #FUN-B20054
 
    #  INPUT BY NAME tm.bookno,babb05,eabb05,bdate,edate,tm.t,tm.u,tm.s,tm.v,tm.x,tm.e,tm.aag38,tm.more WITHOUT DEFAULTS   #FUN-B20054  #FUN-6C0012  #No.FUN-740020   #TQC-6C0098 add tm.aag38
       INPUT BY NAME babb05,eabb05,bdate,edate,tm.t,tm.u,tm.s,tm.v,tm.x,tm.e,tm.aag38,tm.more
                    ATTRIBUTE(WITHOUT DEFAULTS)  #FUN-B20054
                    
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
     #FUN-B20054--mark--str-- 
     #   #No.FUN-740020   ---begin
     #    AFTER FIELD bookno
     #       IF cl_null(tm.bookno) THEN
     #          NEXT FIELD bookno
     #       END IF
     #    #No.FUN-740020   ---end
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
               LET edate = g_lastdat
            END IF
            IF edate < bdate THEN
               CALL cl_err(' ','agl-031',0)
               NEXT FIELD edate
            END IF
 
         AFTER FIELD t
            IF tm.t NOT MATCHES "[YN]" THEN
               NEXT FIELD t
            END IF
 
         AFTER FIELD u
            IF tm.u NOT MATCHES "[YN]" THEN
               NEXT FIELD u
            END IF
 
         AFTER FIELD s
            IF tm.s NOT MATCHES "[YN]" THEN
               NEXT FIELD s
            END IF
 
         AFTER FIELD v
            IF tm.v NOT MATCHES "[YN]" THEN
               NEXT FIELD v
            END IF
 
         AFTER FIELD x
            IF tm.x NOT MATCHES "[YN]" THEN
               NEXT FIELD x
            END IF
 
         #str TQC-6C0098 add
         AFTER FIELD aag38
            IF tm.aag38 NOT MATCHES "[YN]" THEN
               NEXT FIELD aag38
            END IF
         #end TQC-6C0098 add
 
         AFTER FIELD more
           IF tm.more = 'Y' THEN
              CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                             g_bgjob,g_time,g_prtway,g_copies)
                   RETURNING g_pdate,g_towhom,g_rlang,
                             g_bgjob,g_time,g_prtway,g_copies
           END IF

#FUN-B20054--mark--str-- 
#        ON ACTION CONTROLR
#           CALL cl_show_req_fields()
# 
#        ON ACTION CONTROLG
#           CALL cl_cmdask()
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
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE INPUT
# 
#         ON ACTION about         #MOD-4C0121
#            CALL cl_about()      #MOD-4C0121
# 
#         ON ACTION help          #MOD-4C0121
#            CALL cl_show_help()  #MOD-4C0121
# 
#        ON ACTION exit
#           LET INT_FLAG = 1
#           EXIT INPUT
# 
#         #No.FUN-580031 --start--
#         ON ACTION qbe_save
#            CALL cl_qbe_save()
#         #No.FUN-580031 ---end---
#FUN-B20054--mark--end
 
      END INPUT
    #FUN-B20054--add--str--
      ON ACTION CONTROLP                                                                                                         
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
               #LET g_qryparam.form = "q_aag02"   #FUN-B80158 mark(MOD-BC0280追單)
                LET g_qryparam.form = "q_aag16"   #FUN-B80158 add(MOD-BC0280追單)
                LET g_qryparam.state = "c"
                LET g_qryparam.where = " aag00 = '",tm.bookno CLIPPED,"'"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO aag01
                NEXT FIELD aag01              
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
         CLOSE WINDOW aglg740_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         CALL cl_gre_drop_temptable(l_table)                    #FUN-B80158
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 #FUN-B20054--add--end
 
      SELECT azn02,azn04 INTO yy,mm
        FROM azn_file
       WHERE azn01 = bdate
 
      #CALL s_azm(yy,mm) RETURNING l_flag,l_begin,l_end #CHI-A70007 mark
      #CHI-A70007 add --start--
      IF g_aza.aza63 = 'Y' THEN
         CALL s_azmm(yy,mm,g_plant,tm.bookno) RETURNING l_flag,l_begin,l_end
      ELSE
         CALL s_azm(yy,mm) RETURNING l_flag,l_begin,l_end
      END IF
      #CHI-A70007 add --end--
 
      IF l_begin = bdate THEN
         LET l_begin = '9999/12/31'
      END IF
 #FUN-B20054--mark--str
 #     IF INT_FLAG THEN
 #        LET INT_FLAG = 0
 #        CLOSE WINDOW aglg740_w
 #        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
 #        CALL cl_gre_drop_temptable(l_table)                    #FUN-B80158
 #        EXIT PROGRAM
 #     END IF
 #FUN-B20054--mark--end
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file      #get exec cmd (fglgo xxxx)
          WHERE zz01='aglg740'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglg740','9031',1)   
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,            #(at time fglgo xxxx p1 p2 p3)
                        " '",tm.bookno CLIPPED,"' ",     #No.FUN-740020
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        #-----TQC-610056---------
                        " '",babb05 CLIPPED,"'",
                        " '",eabb05 CLIPPED,"'",
                        " '",bdate CLIPPED,"'",
                        " '",edate CLIPPED,"'",
                        #-----END TQC-610056-----
                        " '",tm.t CLIPPED,"'",
                        " '",tm.u CLIPPED,"'",
                        " '",tm.s CLIPPED,"'",
                        " '",tm.v CLIPPED,"'",
                        " '",tm.x CLIPPED,"'",
                        " '",tm.e CLIPPED,"'",  #FUN-6C0012
                        " '",tm.aag38 CLIPPED,"'",             #TQC-6C0098 add
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aglg740',g_time,l_cmd)      # Execute cmd at later time
         END IF
 
         CLOSE WINDOW aglg740_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         CALL cl_gre_drop_temptable(l_table)                    #FUN-B80158
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL aglg740()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW aglg740_w
 
END FUNCTION
 
FUNCTION aglg740()
   DEFINE l_name        LIKE type_file.chr20,             # External(Disk) file name        #No.FUN-680098 VARCHAR(20)
#       l_time          LIKE type_file.chr8               #No.FUN-6A0073
          l_chr         LIKE type_file.chr1,              #No.FUN-680098  VARCHAR(1)   #MOD-740246
          l_sql         STRING,           # RDSQL STATEMENT        #No.FUN-680098 VARCHAR(1000) #FUN-B80158 mod 1000 -> STRING
          l_sql1        STRING,           # RDSQL STATEMENT       #No.FUN-680098  VARCHAR(1000) #FUN-B80158 mod 1000 -> STRING
          l_c,l_d,l_bal LIKE abb_file.abb07,              #No.FUN-780059  
          l_bal_1       LIKE abb_file.abb07,              #No.FUN-780059                                                         
          l_t_d,l_t_c   LIKE abb_file.abb07,              #No.FUN-780059                                                           
          l_buf         LIKE type_file.chr1000,           #No.FUN-780059                                  
          l_abc04       LIKE abc_file.abc04,              #No.FUN-780059   VARCHAR(30)                                            
          m_gem02       LIKE gem_file.gem02,              #No.FUN-780059   VARCHAR(10)
          sr1         RECORD
                         aag01 LIKE aag_file.aag01,   # course no
                         aag02 LIKE aag_file.aag02,   # course name
                         aag13 LIKE aag_file.aag13,   #FUN-6C0012
                         aag07 LIKE aag_file.aag07    # course type
                      END RECORD,
          sr          RECORD
                         aea01 LIKE aea_file.aea01,   # acct. kinds
                         aea02 LIKE aea_file.aea02,   # trans date
                         aea03 LIKE aea_file.aea03,   # trans no
                         aea04 LIKE aea_file.aea04,   # trans seq
                         aba05 LIKE aba_file.aba05,   # input date
                         aba06 LIKE aba_file.aba06,   # Source code
                         abb04 LIKE abb_file.abb04,   # remark
                         abb05 LIKE abb_file.abb05,   # Dept
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
                         aag13 LIKE aag_file.aag13,   #FUN-6C0012
                         amt   LIKE type_file.num5,    #No.FUN-680098   smallint
                         azi04 LIKE azi_file.azi04,
                         gem02 LIKE gem_file.gem02, #FUN-C50005  add 
                         abb07_1 LIKE abb_file.abb07,    #FUN-B80158 add
                         abb07_2 LIKE abb_file.abb07     #FUN-B80158 add
                      END RECORD
   #--str FUN-780059 add--#                                                                                                         
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##                                                            
   CALL cl_del_data(l_table)  
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                                                      
   #------------------------------ CR (2) ------------------------------#                                                           
   #--end FUN-780059 add--#
 
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = tm.bookno
      AND aaf02 = g_rlang
 
   #====>資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND aaguser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND aaggrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
   #End:FUN-980030
 
 
   LET l_sql1= "SELECT aag01,aag02,aag13,aag07 ",  #FUN-6C0012
               "  FROM aag_file ",
               " WHERE aag03 ='2' AND aag07 IN ('1','3') ",
               "   AND aag00 = '",tm.bookno,"'",           #No.FUN-740020
               "   AND aag05='Y' AND ",tm.wc
   LET l_sql1= l_sql1 CLIPPED," AND aag38 = '",tm.aag38,"'"   #TQC-6C0098 add
 
   PREPARE aglg740_prepare2 FROM l_sql1
   IF STATUS != 0 THEN
      CALL cl_err('prepare:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)                    #FUN-B80158
      EXIT PROGRAM
   END IF
   DECLARE aglg740_curs2 CURSOR FOR aglg740_prepare2
 
#  CALL cl_outnam('aglg740') RETURNING l_name                      #FUN-780059-mark
#  START REPORT aglg740_rep TO l_name                              #FUN-780059-mark
   
   #FUN-C50005--ADD--STR
    LET l_sql = "SELECT aea01,aea02,aea03,aea04,aba05,aba06,abb04,abb05,",
                  "       abb06,abb07,abb11,abb12,abb13,abb14,",
                  "       abb31,abb32,abb33,abb34,abb35,abb36,",
                  "       '','',0,azi04, gem02,",  
                  "       0,0 ",       
                  "  FROM aea_file,aba_file,abb_file LEFT OUTER JOIN gem_file ON (gem01=abb05 and gem05='Y' and gemacti='Y'),azi_file,aaa_file ",
                  " WHERE aea01 = ? ",
                  "   AND aea00 = '",tm.bookno,"' ",    
                  "   AND aba00 = '",tm.bookno,"' ",    
                  "   AND aba00 = abb00 ",
                  "   AND aea02 BETWEEN '",bdate,"' AND '",edate,"' ",
                  "   AND abb01 = aea03 AND abb02 = aea04 ",
                  "   AND abb05 !=' ' AND abb05 IS NOT NULL ",
                  "   AND aea00 = aaa01 AND aaa03 = azi01 ",
                  "   AND aba01 = aea03 ",
                  "   AND aba19 <> 'X' "  #CHI-C80041

      IF babb05 IS NOT NULL AND eabb05 IS NOT NULL THEN
         LET l_sql = l_sql CLIPPED," AND abb05 BETWEEN '",babb05,"' AND '",eabb05,"' "
      END IF

      PREPARE aglg740_prepare1 FROM l_sql
      IF STATUS != 0 THEN
         CALL cl_err('prepare:',STATUS,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         CALL cl_gre_drop_temptable(l_table)                    #FUN-B80158
         EXIT PROGRAM
      END IF
      DECLARE aglg740_curs1 CURSOR FOR aglg740_prepare1
# No.FUN-C50005 add-------------star-------------
      DECLARE abc_curs CURSOR FOR SELECT abc04 FROM abc_file
                                   WHERE abc00 = tm.bookno
                                     AND abc01 = sr.aea03
                                     AND abc02 = sr.aea04
# No.FUN-C50005 add------------end-----------------------
 
   LET g_pageno = 0
 
   FOREACH aglg740_curs2 INTO sr1.*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
 
      IF tm.x = 'N' AND sr1.aag07 = '3' THEN
         CONTINUE FOREACH
      END IF
 
      LET g_cnt = 0
      #FUN-C50005--MRK--STR
    # LET l_sql = "SELECT aea01,aea02,aea03,aea04,aba05,aba06,abb04,abb05,",
    #            #FUN-5C0015-----------------------------------------------(S)
    #            #"       abb06,abb07,abb11,abb12,abb13,abb14,'',0,azi04 ",
    #             "       abb06,abb07,abb11,abb12,abb13,abb14,",
    #             "       abb31,abb32,abb33,abb34,abb35,abb36,",
#   #             "       '',0,azi04 ",
    #             "       '','',0,azi04, ",  #No.MOD-B80220
    #             "       0,0 ",       #FUN-B80158 add
    #            #FUN-5C0015-----------------------------------------------(E)
    #             "  FROM aea_file,aba_file,abb_file,azi_file,aaa_file ",
    #             " WHERE aea01 = '",sr1.aag01,"'",
    #             "   AND aea00 = '",tm.bookno,"' ",    #No.FUN-740020
    #             "   AND aba00 = '",tm.bookno,"' ",    #No.FUN-740020
    #             "   AND aba00 = abb00 ",
    #             "   AND aea02 BETWEEN '",bdate,"' AND '",edate,"' ",
    #             "   AND abb01 = aea03 AND abb02 = aea04 ",
    #             "   AND abb05 !=' ' AND abb05 IS NOT NULL ",
    #             "   AND aea00 = aaa01 AND aaa03 = azi01 ",
    #             "   AND aba01 = aea03 "
 
    # IF babb05 IS NOT NULL AND eabb05 IS NOT NULL THEN
    #    LET l_sql = l_sql CLIPPED," AND abb05 BETWEEN '",babb05,"' AND '",eabb05,"' "
    # END IF
 
    # PREPARE aglg740_prepare1 FROM l_sql
    # IF STATUS != 0 THEN
    #    CALL cl_err('prepare:',STATUS,1)
    #    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
    #    CALL cl_gre_drop_temptable(l_table)                    #FUN-B80158
    #    EXIT PROGRAM
    # END IF
    # DECLARE aglg740_curs1 CURSOR FOR aglg740_prepare1
     #FUN-C50005--MRK--end
      LET l_flag='N'
 
    #  FOREACH aglg740_curs1 INTO sr.*   #FUN-C50005 mark
       FOREACH aglg740_curs1  USING sr1.aag01 INTO sr.*              # No.FUN-C50005 add
         IF cl_null(sr.gem02) THEN   # No.FUN-C50005 add
             LET sr.gem02 = ' '      # No.FUN-C50005 add
         END IF                      # No.FUN-C50005 add
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         LET l_flag = 'Y'
         LET sr.aag02 = sr1.aag02
         LET sr.aag13 = sr1.aag13   #FUN-6C0012
 
#--str-FUN-780059--add--#
         LET dept_d = 0                                                                                                             
         LET dept_c = 0
         LET l_bal = 0                                                                                                              
         SELECT sum(aao05-aao06) INTO l_bal                                                                                         
           FROM aao_file                                                                                                            
          WHERE aao01 = sr.aea01                                                                                                    
            AND aao03 = yy                                                                                                          
            AND aao04 < mm                                                                                                          
            AND aao00 = tm.bookno    #No.FUN-740020                                                                                 
            AND aao02 = sr.abb05                                                                                                    
                                                                                                                                    
         IF l_bal IS NULL THEN                                                                                                      
            LET l_bal = 0                                                                                                           
         END IF                                                                                                                     
                                                                                                                                    
         SELECT sum(abb07) INTO l_d                                                                                                 
           FROM aag_file,abb_file,aba_file                                                                                          
          WHERE aag08 = sr.aea01                                                                                                    
            AND aag01 = abb03                                                                                                       
            AND aba01 = abb01
            AND aba02 >= l_begin                                                                                                    
            AND aba02 < bdate                                                                                                       
            AND abb05 = sr.abb05                                                                                                    
            AND abb06 = '1'                                                                                                         
            AND abapost = 'Y'                                                                                                       
            AND aag00 = abb00     #No.FUN-740020                                                                                    
            AND aag00 = aba00     #No.FUN-740020                                                                                    
            AND aba00 = tm.bookno     #No.FUN-740020                                                                                
                                                                                                                                    
         IF l_d IS NULL THEN                                                                                                        
            LET l_d = 0                                                                                                             
         END IF                                                                                                                     
                                                                                                                                    
         LET l_t_d = 0                                                                                                              
         LET l_t_c = 0                                                                                                              
                                                                                                                                    
         SELECT sum(abb07) INTO l_c                                                                                                 
           FROM aag_file,aba_file,abb_file                                                                                          
          WHERE aag08 = sr.aea01                                                                                                    
            AND aag01 = abb03                                                                                                       
            AND aba01 = abb01                                                                                                       
            AND aba02 >= l_begin
            AND aba02 < bdate                                                                                                       
            AND abb05 = sr.abb05                                                                                                    
            AND abb06 = '2'                                                                                                         
            AND abapost = 'Y'                                                                                                       
            AND aag00 = aba00    #No.FUN-740020                                                                                     
            AND aag00 = abb00    #No.FUN-740020                                                                                     
            AND aba00 = tm.bookno  #No.FUN-740020                                                                                   
                                                                                                                                    
         IF l_c IS NULL THEN                                                                                                        
            LET l_c = 0                                                                                                             
         END IF                                                                                                                     
                                                                                                                                    
         LET l_bal = l_bal + l_d - l_c  # 期初餘額                                                                                  
         LET l_bal_1 = l_bal            #FUN-780059
      #FUN-C50005--mark--str                                                                                                                     
      #  SELECT gem02 INTO m_gem02                                                                                                  
      #    FROM gem_file                                                                                                            
      #   WHERE gem01 = sr.abb05                                                                                                    
      #     AND gem05 = 'Y'                                                                                                         
      #     AND gemacti = 'Y'                                                                                                       
                                                                                                                              
      #  IF STATUS = 100 THEN                                                                                                       
      #     LET m_gem02 = ' '                                                                                                       
      #  END IF
       #FUN-C50005--mark--end
         IF sr.abb06 = '1' THEN                                                                                                     
            LET l_bal = l_bal + sr.abb07                                                                                            
            LET l_t_d = l_t_d + sr.abb07                                                                                            
         ELSE                                                                                                                       
            LET l_bal = l_bal - sr.abb07                                                                                            
            LET l_t_c = l_t_c + sr.abb07                                                                                            
         END IF                                                                                                                     
         LET l_buf = ''                                                                                                             
         IF sr.abb11 IS NOT NULL THEN                                                                                               
            LET l_buf = sr.abb11                                                                                                    
         END IF                                                                                                                     
         IF sr.abb12 IS NOT NULL THEN                                                                                               
            LET l_buf = l_buf CLIPPED," ",sr.abb12                                                                                  
         END IF                                                                                                                     
         IF sr.abb13 IS NOT NULL THEN                                                                                               
            LET l_buf = l_buf CLIPPED," ",sr.abb13                                                                                  
         END IF                                                                                                                     
         IF sr.abb14 IS NOT NULL THEN                                                                                               
            LET l_buf = l_buf CLIPPED," ",sr.abb14                                                                                  
         END IF
         IF sr.abb31 IS NOT NULL THEN                                                                                               
            LET l_buf = l_buf CLIPPED," ",sr.abb31                                                                                  
         END IF                                                                                                                     
         IF sr.abb32 IS NOT NULL THEN                                                                                               
            LET l_buf = l_buf CLIPPED," ",sr.abb32                                                                                  
         END IF                                                                                                                     
         IF sr.abb33 IS NOT NULL THEN                                                                                               
            LET l_buf = l_buf CLIPPED," ",sr.abb33                                                                                  
         END IF                                                                                                                     
         IF sr.abb34 IS NOT NULL THEN                                                                                               
            LET l_buf = l_buf CLIPPED," ",sr.abb34                                                                                  
         END IF                                                                                                                     
         IF sr.abb35 IS NOT NULL THEN                                                                                               
            LET l_buf = l_buf CLIPPED," ",sr.abb35                                                                                  
         END IF                                                                                                                     
         IF sr.abb36 IS NOT NULL THEN                                                                                               
            LET l_buf = l_buf CLIPPED," ",sr.abb36                                                                                  
         END IF
            IF tm.v = 'Y' THEN 
               #FUN-C50005--MARK--STR                                                                                                     
              #DECLARE abc_curs CURSOR FOR SELECT abc04 FROM abc_file                                                               
              #                             WHERE abc00 = tm.bookno                                            
              #                               AND abc01 = sr.aea03                                                                  
              #                               AND abc02 = sr.aea04            
              #FOREACH abc_curs INTO l_abc04                                                                                        
              ##FUN-C50005--MARK--END
               FOREACH abc_curs  USING sr.aea03,sr.aea04 INTO l_abc04
                  IF l_abc04 IS NOT NULL THEN                                                                                       
                     PRINT COLUMN g_c[32],l_abc04                                                                                   
                  END IF                                                                                                            
               END FOREACH                                                                                                          
            END IF
         LET dept_d = dept_d + l_t_d                                                                                                
         LET dept_c = dept_c + l_t_c
 #--end-FUN-780059--add--#
 
         #FUN-B80158-----add----str---
         IF sr.abb06 = '1' THEN
            LET sr.abb07_1 = sr.abb07
         END IF
         IF sr.abb06 = '2' THEN
            LET sr.abb07_2 = sr.abb07
         END IF
         #FUN-B80158-----add----end---

#        OUTPUT TO REPORT aglg740_rep(sr.*)                       #FUN-780059-mark
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-770052 *** ##                                                   
           EXECUTE insert_prep USING      
                   sr.aea01,sr.aea02,sr.aea03,sr.aea04,sr.abb04,sr.abb05,sr.abb06,sr.abb07,sr.aag02,sr.aag13,  #FUN-B80158 sr.aea04
                  # sr.azi04,m_gem02,l_bal,l_bal_1,l_buf,l_chr,l_abc04,l_t_d,l_t_c,dept_d,dept_c,  #FUN-C50005 MARK          
                   sr.azi04,sr.gem02,l_bal,l_bal_1,l_buf,l_chr,l_abc04,l_t_d,l_t_c,dept_d,dept_c,  #FUN-C50005 ADD                                                                            
                   sr.abb07_1,sr.abb07_2                #FUN-B80158 add
          #------------------------------ CR (3) ------------------------------#
 
      END FOREACH
 
      IF l_flag = 'Y' THEN
         IF tm.t = 'Y' THEN
            LET m_dept = sr.abb05
            INITIALIZE sr.* TO NULL
            LET sr.aea01 = sr1.aag01
            LET sr.aag02 = sr1.aag02
            LET sr.aag13 = sr1.aag13  #FUN-6C0012
            LET sr.abb05 = m_dept
            LET sr.abb07 = 0
            LET sr.azi04 = 0
 
#           OUTPUT TO REPORT aglg740_rep(sr.*)                    #FUN-780059-mark
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-770052 *** ##                                                   
           EXECUTE insert_prep USING                                                                                                
                   sr.aea01,sr.aea02,sr.aea03,sr.aea04,sr.abb04,sr.abb05,sr.abb06,sr.abb07,sr.aag02,sr.aag13,  #FUN-B80158 sr.aea04
                  #sr.azi04,m_gem02,l_bal,l_buf,l_chr,l_abc04,l_t_d,l_t_c,dept_d,dept_c          #MOD-B20028 mark 
                   sr.azi04,sr.gem02,l_bal,l_bal_1,l_buf,l_chr,l_abc04,l_t_d,l_t_c,dept_d,dept_c  #MOD-B20028 #FUN-C50005 mod m_gem02-->sr.gem02
                   ,sr.abb07_1,sr.abb07_2                #FUN-B80158 add
          #------------------------------ CR (3) ------------------------------#
 
         END IF
      END IF
   END FOREACH
 
#  FINISH REPORT aglg740_rep                                      #FUN-780059-mark
#-str-FUN-780059--add--#
         IF g_zz05 = 'Y' THEN                                                                                                       
            CALL cl_wcchp(tm.wc,'aag01') RETURNING tm.wc
         END IF
#-end-FUN-780059--add--#
 
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)                    #FUN-780059-mark
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-770052 **** ##                                                        
###GENGRE###    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''                                                                                                                  
###GENGRE###    LET g_str = tm.wc,";",bdate,";",edate,";",tm.u,";",tm.e,";",                                                              
###GENGRE###                tm.s,";",tm.v                                                                        
###GENGRE###    CALL cl_prt_cs3('aglg740','aglg740',l_sql,g_str)                                                                                
    CALL aglg740_grdata()    ###GENGRE###
    #------------------------------ CR (4) ------------------------------#
 
END FUNCTION
 
#-str-FUN-780059--mark--#
#REPORT aglg740_rep(sr)
#  DEFINE sr       RECORD
#                     aea01 LIKE aea_file.aea01,
#                     aea02 LIKE aea_file.aea02,
#                     aea03 LIKE aea_file.aea03,
#                     aea04 LIKE aea_file.aea04,
#                     aba05 LIKE aba_file.aba05,
#                     aba06 LIKE aba_file.aba06,
#                     abb04 LIKE abb_file.abb04,
#                     abb05 LIKE abb_file.abb05,
#                     abb06 LIKE abb_file.abb06,
#                     abb07 LIKE abb_file.abb07,
#                     abb11 LIKE abb_file.abb11,
#                     abb12 LIKE abb_file.abb12,
#                     abb13 LIKE abb_file.abb13,
#                     abb14 LIKE abb_file.abb14,
#                     abb31 LIKE abb_file.abb31,  #FUN-5C0015---(S)
#                     abb32 LIKE abb_file.abb32,
#                     abb33 LIKE abb_file.abb33,
#                     abb34 LIKE abb_file.abb34,
#                     abb35 LIKE abb_file.abb35,
#                     abb36 LIKE abb_file.abb36,  #FUN-5C0015---(E)
#                     aag02 LIKE aag_file.aag02,
#                     aag13 LIKE aag_file.aag13,  #FUN-6C0012
#                     amt   LIKE type_file.num5,     #No.FUN-680098   smallint
#                     azi04 LIKE azi_file.azi04
#                  END RECORD,
#         l_amt,l_c,l_d,l_bal          LIKE abb_file.abb07,
#         l_t_d,l_t_c                  LIKE abb_file.abb07,
#         l_last_sw                    LIKE type_file.chr1,     #No.FUN-680098   VARCHAR(1)
#         l_abb07,l_aah04,l_aah05      LIKE abb_file.abb07,
#         l_chr,l_abb06,l_continue     LIKE type_file.chr1,     #No.FUN-680098   VARCHAR(1)
#        #l_buf                        VARCHAR(15)  #FUN-5C0015     
#         l_buf                        LIKE type_file.chr1000, #FUN-5C0015    No.FUN-680098 VARCHAR(60)
#         l_abc04                      LIKE abc_file.abc04,    #No.FUN-680098   VARCHAR(30)
#         m_gem02                      LIKE gem_file.gem02     #No.FUN-680098   VARCHAR(10)
#  DEFINE g_head1                      STRING
 
#  OUTPUT
#     TOP MARGIN g_top_margin
#     LEFT MARGIN g_left_margin
#     BOTTOM MARGIN g_bottom_margin
#     PAGE LENGTH g_page_line
 
#  ORDER BY sr.abb05,sr.aea01,sr.aea02
 
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
#     BEFORE GROUP OF sr.abb05    #部門
#        IF tm.u = 'Y' THEN
#           SKIP TO TOP OF PAGE
#        END IF
#        LET dept_d = 0
#        LET dept_c = 0
#
#     BEFORE GROUP OF sr.aea01    #科目
#        LET l_bal = 0
#        SELECT sum(aao05-aao06) INTO l_bal
#          FROM aao_file
#         WHERE aao01 = sr.aea01
#           AND aao03 = yy
#           AND aao04 < mm
#           AND aao00 = tm.bookno    #No.FUN-740020
#           AND aao02 = sr.abb05
 
#        IF l_bal IS NULL THEN
#           LET l_bal = 0
#        END IF
 
#        SELECT sum(abb07) INTO l_d
#          FROM aag_file,abb_file,aba_file
#         WHERE aag08 = sr.aea01
#           AND aag01 = abb03
#           AND aba01 = abb01
#           AND aba02 >= l_begin
#           AND aba02 < bdate
#           AND abb05 = sr.abb05
#           AND abb06 = '1'
#           AND abapost = 'Y'
#           AND aag00 = abb00     #No.FUN-740020
#           AND aag00 = aba00     #No.FUN-740020
#           AND aba00 = tm.bookno     #No.FUN-740020
 
#        IF l_d IS NULL THEN
#           LET l_d = 0
#        END IF
 
#        LET l_t_d = 0
#        LET l_t_c = 0
 
#        SELECT sum(abb07) INTO l_c
#          FROM aag_file,aba_file,abb_file
#         WHERE aag08 = sr.aea01
#           AND aag01 = abb03
#           AND aba01 = abb01
#           AND aba02 >= l_begin
#           AND aba02 < bdate
#           AND abb05 = sr.abb05
#           AND abb06 = '2'
#           AND abapost = 'Y'
#           AND aag00 = aba00    #No.FUN-740020
#           AND aag00 = abb00    #No.FUN-740020
#           AND aba00 = tm.bookno  #No.FUN-740020
 
#        IF l_c IS NULL THEN
#           LET l_c = 0
#        END IF
 
#        LET l_bal = l_bal + l_d - l_c  # 期初餘額
 
#        SELECT gem02 INTO m_gem02
#          FROM gem_file
#         WHERE gem01 = sr.abb05
#           AND gem05 = 'Y'
#           AND gemacti = 'Y'
 
#        IF STATUS = 100 THEN
#           LET m_gem02 = ' '
#        END IF
 
#        IF l_bal >= 0 THEN
#           PRINT COLUMN g_c[31],g_x[11] CLIPPED,
#                 COLUMN g_c[32],sr.abb05,
#                 COLUMN g_c[33],m_gem02
#           PRINT COLUMN g_c[31],g_x[12] CLIPPED,
#                 COLUMN g_c[32],sr.aea01 CLIPPED;
#                  COLUMN g_c[33],sr.aag02 CLIPPED,   #FUN-6C0012
#           #FUN-6C0012.....begin
#           IF tm.e = 'N' THEN
#              PRINT COLUMN g_c[33],sr.aag02 CLIPPED;
#           ELSE
#              PRINT COLUMN g_c[33],sr.aag13 CLIPPED;
#           END IF
#           #FUN-6C0012.....end  
#           PRINT COLUMN g_c[34],l_chr CLIPPED,
#                 COLUMN g_c[36],cl_numfor(l_bal,36,sr.azi04),
#                 COLUMN g_c[37],'D'
#        ELSE
#           LET l_bal = l_bal * (-1)
#           PRINT COLUMN g_c[31],g_x[11] CLIPPED,
#                 COLUMN g_c[32],sr.abb05,
#                 COLUMN g_c[33],m_gem02
#           PRINT COLUMN g_c[31],g_x[12] CLIPPED,
#                 COLUMN g_c[32],sr.aea01 CLIPPED;
#                  COLUMN g_c[33],sr.aag02 CLIPPED,   #FUN-6C0012
#           #FUN-6C0012.....begin
#           IF tm.e = 'N' THEN
#              PRINT COLUMN g_c[33],sr.aag02 CLIPPED;
#           ELSE
#              PRINT COLUMN g_c[33],sr.aag13 CLIPPED;
#           END IF
#           #FUN-6C0012.....end
#           PRINT COLUMN g_c[34],l_chr CLIPPED,
#                 COLUMN g_c[36],cl_numfor(l_bal,36,sr.azi04),
#                 COLUMN g_c[37],'C'
#           LET l_bal = l_bal * (-1)
#        END IF
#        PRINT ' '
#
#     ON EVERY ROW
#        IF sr.abb06 = '1' THEN
#           LET l_bal = l_bal + sr.abb07
#           LET l_t_d = l_t_d + sr.abb07
#        ELSE
#           LET l_bal = l_bal - sr.abb07
#           LET l_t_c = l_t_c + sr.abb07
#        END IF
#        LET l_buf = ''
#        IF sr.abb11 IS NOT NULL THEN
#           LET l_buf = sr.abb11
#        END IF
#        IF sr.abb12 IS NOT NULL THEN
#           LET l_buf = l_buf CLIPPED," ",sr.abb12
#        END IF
#        IF sr.abb13 IS NOT NULL THEN
#           LET l_buf = l_buf CLIPPED," ",sr.abb13
#        END IF
#        IF sr.abb14 IS NOT NULL THEN
#           LET l_buf = l_buf CLIPPED," ",sr.abb14
#        END IF
#       #FUN-5C0015---------------------------------(S)
#        IF sr.abb31 IS NOT NULL THEN
#           LET l_buf = l_buf CLIPPED," ",sr.abb31
#        END IF
#        IF sr.abb32 IS NOT NULL THEN
#           LET l_buf = l_buf CLIPPED," ",sr.abb32
#        END IF
#        IF sr.abb33 IS NOT NULL THEN
#           LET l_buf = l_buf CLIPPED," ",sr.abb33
#        END IF
#        IF sr.abb34 IS NOT NULL THEN
#           LET l_buf = l_buf CLIPPED," ",sr.abb34
#        END IF
#        IF sr.abb35 IS NOT NULL THEN
#           LET l_buf = l_buf CLIPPED," ",sr.abb35
#        END IF
#        IF sr.abb36 IS NOT NULL THEN
#           LET l_buf = l_buf CLIPPED," ",sr.abb36
#        END IF
#       #FUN-5C0015---------------------------------(E)
#        IF sr.abb07 != 0 THEN
#           LET l_continue = 'Y'
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
#              LET l_bal = l_bal * (-1)
#              PRINT COLUMN g_c[36],cl_numfor(l_bal,36,sr.azi04),
#                    COLUMN g_c[37],'C'
#              LET l_bal = l_bal * (-1)
#           END IF
#           IF tm.s ='Y' THEN
#              PRINT COLUMN g_c[31],sr.abb04
#           END IF
#           IF tm.v = 'Y' THEN
#              DECLARE abc_curs CURSOR FOR SELECT abc04 FROM abc_file
#                                           WHERE abc00 = tm.bookno    #No.FUN-740020
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
#     AFTER GROUP OF sr.aea01
#        LET g_pageno = 0   #FUN-6C0012
#        PRINT '  '
#        PRINT COLUMN g_c[33],g_x[13] CLIPPED,
#              COLUMN g_c[34],cl_numfor(l_t_d,34,sr.azi04),
#              COLUMN g_c[35],cl_numfor(l_t_c,35,sr.azi04)
#        IF tm.u = 'N' THEN
#           PRINT g_dash2[1,g_len]
#        END IF
#        LET dept_d = dept_d + l_t_d
#        LET dept_c = dept_c + l_t_c
#
#     AFTER GROUP OF sr.abb05
#        LET g_pageno = 0   #FUN-6C0012
#        PRINT '  '
#        PRINT COLUMN g_c[33],g_x[14] CLIPPED,
#              COLUMN g_c[34],cl_numfor(dept_d,34,sr.azi04),
#              COLUMN g_c[35],cl_numfor(dept_c,35,sr.azi04)
#        IF tm.u = 'N' THEN
#           PRINT g_dash2[1,g_len]
#        END IF
#
#     ON LAST ROW
#        IF g_zz05 = 'Y' THEN
#           CALL cl_wcchp(tm.wc,'aag01') RETURNING tm.wc
#           PRINT g_dash[1,g_len]
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
#         #-- TQC-630166 end
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

###GENGRE###START
FUNCTION aglg740_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg740")
        IF handler IS NOT NULL THEN
            START REPORT aglg740_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY abb05,aea01,aea02,aea04" #FUN-B80158 add  #FUN-B80158 aea04
          
            DECLARE aglg740_datacur1 CURSOR FROM l_sql
            FOREACH aglg740_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg740_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg740_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg740_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B80158-----add----str---
    DEFINE g_c33    LIKE aag_file.aag02
    DEFINE g_c37    LIKE type_file.chr1
    DEFINE l_bal_1  LIKE abb_file.abb07
    DEFINE l_bal1   LIKE abb_file.abb07
    DEFINE l_riqi   STRING
    DEFINE l_AccTot_c  LIKE abb_file.abb07   
    DEFINE l_AccTot_d  LIKE abb_file.abb07   
    DEFINE l_DepTot_c  LIKE abb_file.abb07   
    DEFINE l_DepTot_d  LIKE abb_file.abb07   
    DEFINE l_abb07_fmt STRING
    DEFINE l_bal_1_fmt STRING
    DEFINE l_AccTot_fmt STRING
    DEFINE l_DepTot_fmt STRING
    DEFINE l_DepTot     LIKE abb_file.abb07   #FUN-B80158 add 
    DEFINE l_balance    LIKE abb_file.abb07   #FUN-B80158 add
    DEFINE l_balance_1  LIKE abb_file.abb07   #FUN-B80158 add
    DEFINE l_AccTot_c_sum  LIKE abb_file.abb07   
    DEFINE l_AccTot_d_sum  LIKE abb_file.abb07   
    #FUN-B80158-----add----end---

    
    ORDER EXTERNAL BY sr1.abb05,sr1.aea01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B80158 add g_ptime,g_user_name
            PRINTX tm.*
            LET l_riqi = bdate,'-',edate    #FUN-B80158 add
            PRINTX l_riqi                   #FUN-B80158 add
              
        BEFORE GROUP OF sr1.abb05
        BEFORE GROUP OF sr1.aea01
            #FUN-B80158-----add----str---
            LET l_bal_1_fmt = cl_gr_numfmt('abb_file','abb07',sr1.azi04)
            PRINTX l_bal_1_fmt
            IF tm.e = 'N' THEN
               LET g_c33 = sr1.aag02
            ELSE 
               LET g_c33 = sr1.aag13
            END IF
            PRINTX g_c33

            IF sr1.l_bal_1 < 0 THEN
               LET l_bal_1 = sr1.l_bal_1 * (-1)
            ELSE
               LET l_bal_1 = sr1.l_bal_1
            END IF
            PRINTX l_bal_1

            #FUN-B80158-----add----end---

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #FUN-B80158-----add----str---
            LET l_abb07_fmt = cl_gr_numfmt('abb_file','abb07',sr1.azi04)
            PRINTX l_abb07_fmt
            IF sr1.l_bal < 0 THEN
               LET l_bal1 = sr1.l_bal * (-1)
            ELSE
               LET l_bal1 = sr1.l_bal
            END IF
            PRINTX l_bal1

            IF sr1.l_bal >= 0 THEN
               LET g_c37 = 'D'
            ELSE
               LET g_c37 = 'C'
            END IF
            PRINTX g_c37
            #FUN-B80158-----add----end---
            #FUN-B80158-----add---str----
            IF cl_null(l_DepTot) THEN LET l_DepTot = 0 END IF     
            IF cl_null(l_AccTot_d_sum) THEN LET l_AccTot_d_sum = 0 END IF
            IF cl_null(l_AccTot_c_sum) THEN LET l_AccTot_c_sum = 0 END IF
            LET l_DepTot = sr1.l_bal_1 +  l_DepTot               
            PRINTX l_DepTot                                       
            LET l_AccTot_d_sum = sr1.abb07_1 +  l_AccTot_d_sum     
            PRINTX l_AccTot_d                                       
            LET l_AccTot_c_sum = sr1.abb07_2 +  l_AccTot_c_sum       
            PRINTX l_AccTot_c                                         
            LET l_balance = l_DepTot + l_AccTot_d_sum - l_AccTot_c_sum 
            PRINTX l_balance
            IF l_balance < 0 THEN
               LET l_balance_1 = l_balance * (-1)
            ELSE
               LET l_balance_1 = l_balance
            END IF
            PRINTX l_balance_1
            #FUN-B80158-----add---end----

            PRINTX sr1.*

        AFTER GROUP OF sr1.abb05
            #FUN-B80158-----add----str---
            LET l_DepTot_fmt = cl_gr_numfmt('abb_file','abb07',sr1.azi04)
            PRINTX l_DepTot_fmt
            LET l_DepTot_c = GROUP SUM(sr1.abb07_2)
            LET l_DepTot_d = GROUP SUM(sr1.abb07_1)
            PRINTX l_DepTot_c
            PRINTX l_DepTot_d
            LET l_DepTot = 0     
            #FUN-B80158-----add----end---
        AFTER GROUP OF sr1.aea01
            #FUN-B80158-----add----str---
            LET l_AccTot_fmt = cl_gr_numfmt('abb_file','abb07',sr1.azi04)
            PRINTX l_AccTot_fmt
            LET l_AccTot_c = GROUP SUM(sr1.abb07_2)
            LET l_AccTot_d = GROUP SUM(sr1.abb07_1)
            PRINTX l_AccTot_c
            PRINTX l_AccTot_d
            LET l_AccTot_c_sum = 0
            LET l_AccTot_d_sum = 0
            #FUN-B80158-----add----end---

        
        ON LAST ROW

END REPORT
###GENGRE###END
