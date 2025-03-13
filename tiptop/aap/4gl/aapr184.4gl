# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aapr184.4gl
# Descriptions...: 應付帳款科目期報表列印作業
# Input parameter:
# Return code....:
# Date & Author..: 94/07/30 By Roger
# Modify.........: No.FUN-4C0097 04/12/27 By Nicola 報表架構修改
#                                                   增加列印部門名稱gem02
# Modify.........: No.MOD-5B0204 05/11/23 By Smapmin 資料未對齊,期別列印有誤
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.FUN-660060 06/06/26 By Rainy 期間置於中間
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/30 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.TQC-6B0039 06/11/15 By Smapmin 列印排列順序
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-730064 07/04/03 By arman   會計科目加帳套 
# Modify.........: No.TQC-770052 07/07/12 By Rayven 報表期間位置顯示有誤
# Modify.........: No.FUN-830103 08/03/24 By destiny 報表改為CR輸出 
# Modify.........: No.TQC-940038 09/06/10 By dxfwo   缺少apn09
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B20054 11/02/21 By lixiang 先錄入帳套,科目根據帳套過濾;結構改為DIALOG
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000,      # Where condition  #No.FUN-690028 VARCHAR(600)
              s       LIKE type_file.chr3,         # No.FUN-690028 VARCHAR(2),
              t,u     LIKE type_file.chr3,         # No.FUN-690028 
              yy,m1,m2 LIKE type_file.num10,       # No.FUN-690028 INTEGER,
              more    LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)         # Input more condition(Y/N)
              END RECORD 
   DEFINE l_order  ARRAY[3] OF LIKE apn_file.apn02     # No.FUN-690028 VARCHAR(20)
   DEFINE g_orderA ARRAY[3] OF LIKE zaa_file.zaa08      # No.FUN-690028 VARCHAR(20)
#FUN-B20054--add--str--
   DEFINE g_apn09 LIKE apn_file.apn09   

   DEFINE g_apn00 LIKE apn_file.apn00 
#FUN-B20054--add--end--     
   DEFINE g_i      LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
#     DEFINE   l_time    LIKE type_file.chr8         #No.FUN-6A0055
#No.FUN-830103--begin--                                                                                                             
   DEFINE g_sql       STRING                                                                                                        
   DEFINE l_table     STRING                                                                                                        
   DEFINE g_str       STRING                                                                                                        
   DEFINE l_title1    STRING                                                                                                        
#No.FUN-830103--end--
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055 #FUN-BB0047 mark
#No.FUN-830103--begin--                                                                                                             
   LET g_sql= "l_aag02.aag_file.aag02,",                                                                                            
              "apn00.apn_file.apn00,",                                                                                              
              "apn11.apn_file.apn11,",                                                                                              
              "apn12.apn_file.apn12,",                                                                                              
              "apn10.apn_file.apn10,",                                                                                              
              "apn01.apn_file.apn01,",                                                                                              
              "apn02.apn_file.apn02,",                                                                                              
              "apn03.apn_file.apn03,",                                                                                              
              "gem02.gem_file.gem02,",                                                                                              
              "apn13.apn_file.apn13,",                                                                                              
              "apn14.apn_file.apn14,",                                                                                              
              "apn15.apn_file.apn15,",                                                                                              
              "amt_b.apn_file.apn06,",                                                                                              
              "amt_d.apn_file.apn06,",                                                                                              
              "amt_c.apn_file.apn06,",                                                                                              
              "l_aag06.aag_file.aag06"                                                                                              
   LET l_table = cl_prt_temptable('aapr184',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",                                                                                     
               "        ?,?,?,?,?,?)"                                                                                               
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
                                                                                                                                    
#No.FUN-830103--end--
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s = ARG_VAL(8)
   LET tm.t = ARG_VAL(9)
   LET tm.u = ARG_VAL(10)
   LET tm.yy  = ARG_VAL(11)
   LET tm.m1  = ARG_VAL(12)
   LET tm.m2  = ARG_VAL(13)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   #No.FUN-570264 ---end---
   IF cl_null(g_apn09) THEN  LET g_apn09=g_aza.aza81  END IF    # No.FUN-B20054
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL aapr184_tm(0,0)
   ELSE
      CALL aapr184()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
END MAIN
 
FUNCTION aapr184_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690028 SMALLINT
       l_cmd          LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
DEFINE li_chk_bookno  LIKE type_file.num5   #FUN-B20054
 
   LET p_row = 4 LET p_col = 14
   OPEN WINDOW aapr184_w AT p_row,p_col
     WITH FORM "aap/42f/aapr184"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.yy   = YEAR(TODAY)
   LET tm.m1   = 1
   LET tm.m2   = MONTH(TODAY)
   LET tm.s = '24'
   LET tm.t = ' '
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
 
   WHILE TRUE
   #FUN-B20054--add--str--
   DIALOG ATTRIBUTE(unbuffered)
       #INPUT BY NAME g_apn09 ATTRIBUTE(WITHOUT DEFAULTS)
       INPUT g_apn09 FROM apn09 ATTRIBUTE(WITHOUT DEFAULTS)
          AFTER FIELD apn09 
            IF NOT cl_null(g_apn09) THEN
                   CALL s_check_bookno(g_apn09,g_user,g_plant)
                    RETURNING li_chk_bookno
                IF (NOT li_chk_bookno) THEN
                    NEXT FIELD apn09
                END IF
                SELECT aaa02 FROM aaa_file WHERE aaa01 = g_apn09
                IF STATUS THEN
                   CALL cl_err3("sel","aaa_file",g_apn09,"","agl-043","","",0)
                   NEXT FIELD apn09
                END IF
            END IF
      END INPUT
     #FUN-B20054--add--end

      CONSTRUCT BY NAME tm.wc ON apn00,apn01,apn02,apn03 
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---

#FUN-B20054--mark--str- 
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
#         ON ACTION exit
#            LET INT_FLAG = 1
#            EXIT CONSTRUCT
# 
#         #No.FUN-580031 --start--
#         ON ACTION qbe_select
#            CALL cl_qbe_select()
#         #No.FUN-580031 ---end---
# 
#FUN-B20054--mark--end

      END CONSTRUCT
#      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030

#FUN-B20054--mark--str-- 
#      IF g_action_choice = "locale" THEN
#         LET g_action_choice = ""
#         CALL cl_dynamic_locale()
#         CONTINUE WHILE
#      END IF
# 
#      IF INT_FLAG THEN
#         LET INT_FLAG = 0
#         CLOSE WINDOW aapr184_w
#         EXIT PROGRAM
#      END IF
#FUN-B20054--mark--end
 
#FUN-B20054--mark--str--
#      IF tm.wc = ' 1=1' THEN
#         CALL cl_err('','9046',0)
#         CONTINUE WHILE
#      END IF
#FUN-B20054--mark--end
 
      INPUT BY NAME tm.yy,tm.m2,tm2.s1,tm2.s2,tm2.t1,tm2.t2,
                      tm2.u1,tm2.u2,tm.more
            # WITHOUT DEFAULTS         #FUN-B20054
            ATTRIBUTE(WITHOUT DEFAULTS)  #FUN-B20054
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD yy
            IF cl_null(tm.yy) THEN
               CALL cl_err('','aap-099',0)
               NEXT FIELD yy
            END IF
 
         AFTER FIELD m2
#No.TQC-720032 -- begin --
            IF NOT cl_null(tm.m2) THEN
               SELECT azm02 INTO g_azm.azm02 FROM azm_file
                 WHERE azm01 = tm.yy
               IF g_azm.azm02 = 1 THEN
                  IF tm.m2 > 12 OR tm.m2 < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD m2
                  END IF
               ELSE
                  IF tm.m2 > 13 OR tm.m2 < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD m2
                  END IF
               END IF
            END IF
#No.TQC-720032 -- end --
            IF cl_null(tm.m2) THEN
               CALL cl_err('','aap-099',0)
               NEXT FIELD m2
            END IF
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF

         AFTER INPUT
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
            LET tm.t = tm2.t1,tm2.t2
            LET tm.u = tm2.u1,tm2.u2
 
#FUN-B20054--mark--str--
#         ON ACTION CONTROLR
#            CALL cl_show_req_fields()
# 
#         ON ACTION CONTROLG
#            CALL cl_cmdask()    # Command execution
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
#
#FUN-B20054--mark--end 
      END INPUT
  
    #FUN-B20054--add--str-- 
        ON ACTION CONTROLP
           CASE
             WHEN INFIELD(apn09)
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_aaa3'
                LET g_qryparam.default1 = g_apn09
                CALL cl_create_qry() RETURNING g_apn09
                DISPLAY g_apn09 TO FORMONLY.apn09
                NEXT FIELD apn09  
             WHEN INFIELD(apn00)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag02"
                LET g_qryparam.state = "c"
                LET g_qryparam.where = " aag00 = '",g_apn09 CLIPPED,"'"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO apn00
                NEXT FIELD apn00  
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

        #No.FUN-580031 --start--
        ON ACTION qbe_select
           CALL cl_qbe_select()
        #No.FUN-580031 ---end---

        #No.FUN-580031 --start--
        ON ACTION qbe_save
           CALL cl_qbe_save()
        #No.FUN-580031 ---end--- 

      END DIALOG
      #FUN-B20054--add--end

      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF     

      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         CLOSE WINDOW aapr184_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
     
      #FUN-B20054--add--str--
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030

      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      #FUN-B20054--add--end 

      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aapr184'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aapr184','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_lang CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.s CLIPPED,"'",
                        " '",tm.t CLIPPED,"'",
                        " '",tm.u CLIPPED,"'",
                        " '",tm.yy CLIPPED,"'",
                        " '",tm.m1 CLIPPED,"'",
                        " '",tm.m2 CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('aapr184',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW aapr184_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL aapr184()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW aapr184_w
 
END FUNCTION
 
FUNCTION aapr184()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#         l_time    LIKE type_file.chr8,           # Used time for running the job  #No.FUN-690028 VARCHAR(8)
          l_sql     STRING,          # RDSQL STATEMENT
          l_wc      LIKE type_file.chr1000,      #  #No.FUN-690028 VARCHAR(300)
          l_apy     RECORD LIKE apy_file.*,
          i         LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_chr     LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          sr        RECORD
                       order1,order2 LIKE apn_file.apn01,      # No.FUN-690028 VARCHAR(10),
                       apn00 LIKE apn_file.apn00,   #Act no
                       apn01 LIKE apn_file.apn01,   #付款廠商編號
                       apn02 LIKE apn_file.apn02,   #廠商簡稱
                       apn03 LIKE apn_file.apn03,   #DEPT
                       apn08 LIKE apn_file.apn08,   #DEPT
                       apn09 LIKE apn_file.apn09,   #帳套     #No.TQC-940038
                       apn10 LIKE apn_file.apn10,   #立沖單號
                       amt_b LIKE apn_file.apn06,
                       amt_d LIKE apn_file.apn06,
                       amt_c LIKE apn_file.apn06,
                       apn11 LIKE apn_file.apn11,   #帳款日
                       apn12 LIKE apn_file.apn12,   #
                       apn13 LIKE apn_file.apn13,   #
                       apn14 LIKE apn_file.apn14,   #
                       apn15 LIKE apn_file.apn15,   #
                       apn16 LIKE apn_file.apn16,   #
                       gem02 LIKE gem_file.gem02
                    END RECORD
DEFINE l_aag02     LIKE aag_file.aag02                #No.FUN-830103                                                                
DEFINE l_aag06     LIKE aag_file.aag06                #No.FUN-830103  
#    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog          #No.FUN-830103                                                 
   CALL cl_del_data(l_table)                                         #No.FUN-830103 
#No.CHI-6A0004--------Begin------
#   SELECT azi04,azi05 INTO g_azi04,g_azi05
#          FROM azi_file
#   WHERE azi01 = g_aza.aza17
#No.CHI-6A0004-------End--------   
#   CALL cl_outnam('aapr184') RETURNING l_name                       #No.FUN-830103  
#   LET g_pageno = 0                                                 #No.FUN-830103 
#   START REPORT aapr184_rep TO l_name                               #No.FUN-830103  
 
#No.TQC-940038 --begin-- 
#  LET l_sql = "SELECT '','',apn00,apn01,apn02,apn03,apn08,apn10, ",
#              " SUM(apn06-apn07),0,0,apn11,apn12,apn13,apn14,apn15,apn16,''",
#              " FROM apn_file WHERE ",tm.wc CLIPPED,
#              "  AND apn04=",tm.yy," AND apn05<",tm.m1,
#              " GROUP BY apn00,apn01,apn02,apn03,apn08,apn10,apn11,apn12,",
#              "          apn13,apn14,apn15,apn16 ",
#              " UNION ",
#              "SELECT '','',apn00,apn01,apn02,apn03,apn08,apn10, ",
#              " 0,SUM(apn06),SUM(apn07),apn11,apn12,apn13,apn14,apn15,apn16,''",
#              " FROM apn_file WHERE ",tm.wc CLIPPED,
#              " AND apn04=",tm.yy," AND apn05 BETWEEN ",tm.m1," AND ",tm.m2,
#              " GROUP BY apn00,apn01,apn02,apn03,apn08,apn10,apn11,apn12,",
#              "          apn13,apn14,apn15,apn16 "
   LET l_sql = "SELECT '','',apn00,apn01,apn02,apn03,apn08,apn09,apn10, ",                                                          
               " SUM(apn06-apn07),0,0,apn11,apn12,apn13,apn14,apn15,apn16,''",                                                      
               " FROM apn_file WHERE ",tm.wc CLIPPED,                                                                               
               "  AND apn04=",tm.yy," AND apn05<",tm.m1,                                                                            
               " GROUP BY apn00,apn01,apn02,apn03,apn08,apn09,apn10,apn11,apn12,",                                                    
               "          apn13,apn14,apn15,apn16 ",                                                                                
               " UNION ",                                                                                                           
               "SELECT '','',apn00,apn01,apn02,apn03,apn08,apn09,apn10, ",                                                          
               " 0,SUM(apn06),SUM(apn07),apn11,apn12,apn13,apn14,apn15,apn16,''",                                                    
               " FROM apn_file WHERE ",tm.wc CLIPPED,                                                                               
               " AND apn04=",tm.yy," AND apn05 BETWEEN ",tm.m1," AND ",tm.m2,                                                       
               " GROUP BY apn00,apn01,apn02,apn03,apn08,apn09,apn10,apn11,apn12,",                                                    
               "          apn13,apn14,apn15,apn16 "                                                                                 
#No.TQC-940038 --end-- 
   PREPARE aapr184_p1 FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare1:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   DECLARE aapr184_c1 CURSOR FOR aapr184_p1
 
   FOREACH aapr184_c1 INTO sr.*
      IF STATUS != 0 THEN
         CALL cl_err('fore1:',STATUS,1)
         EXIT FOREACH
      END IF
 
      SELECT gem02 INTO sr.gem02
        FROM gem_file
       WHERE gem01 = sr.apn03
 
      IF sr.amt_b = 0 AND sr.amt_d = 0 AND sr.amt_c = 0 THEN
         CONTINUE FOREACH
      END IF
 
      IF sr.apn03 IS NULL THEN
         LET sr.apn03 = ' '
      END IF
 
      INITIALIZE l_apy.* TO NULL            # Default condition
#No.FUN-830103--begin-- 
      SELECT aag02,aag06 INTO l_aag02,l_aag06 FROM aag_file WHERE aag01 = sr.apn00                                                  
                                                              AND aag00 = sr.apn09 
#      FOR g_i = 1 TO 2
#         CASE
#              WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.apn00   #TQC-6B0039
#                                       LET g_orderA[g_i]= g_x[14]    #TQC-6B0039
#              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.apn01
#                                       #LET g_orderA[g_i]= g_x[13]    #TQC-6B0039
#                                       LET g_orderA[g_i]= g_x[11]    #TQC-6B0039
#              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.apn02
#                                       #LET g_orderA[g_i]= g_x[14]   #TQC-6B0039
#                                       LET g_orderA[g_i]= g_x[12]   #TQC-6B0039
#              WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.apn03
#                                       #LET g_orderA[g_i]= g_x[15]   #TQC-6B0039
#                                       LET g_orderA[g_i]= g_x[13]   #TQC-6B0039
#              OTHERWISE                LET l_order[g_i] = '-'
#                                      LET g_orderA[g_i]= 'xxxx'
#         END CASE
#      END FOR
 
#      LET sr.order1=l_order[1]
#      LET sr.order2=l_order[2]
#      IF sr.order1 IS NULL THEN LET sr.order1 = ' '  END IF
#      IF sr.order2 IS NULL THEN LET sr.order2 = ' '  END IF
      EXECUTE insert_prep USING                                                                                                     
              l_aag02,sr.apn00,sr.apn11,sr.apn12,sr.apn10,sr.apn01,sr.apn02,sr.apn03,                                               
              sr.gem02,sr.apn13,sr.apn14,sr.apn15,sr.amt_b,sr.amt_d,sr.amt_c,l_aag06                                                
#No.FUN-830103--end--      
#     IF sr.amt_b < 0 THEN 
#        LET sr.amt_b = sr.amt_b * -1
#     END IF
 
#     OUTPUT TO REPORT aapr184_rep(sr.*)                                  #No.FUN-830103
   END FOREACH
 
#   FINISH REPORT aapr184_rep                                             #No.FUN-830103
 
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)                           #No.FUN-830103
     #No.FUN-BB0047--mark--Begin---
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
     #No.FUN-BB0047--mark--End-----
#No.FUN-830103--begin--                                                                                                             
     IF g_zz05 = 'Y' THEN                                                                                                           
        CALL cl_wcchp(tm.wc,'apn00,apn01,apn02,apn03,apn09')                                                                        
        RETURNING tm.wc                                                                                                             
        LET g_str = tm.wc                                                                                                           
     END IF                                                                                                                         
     LET l_title1=tm.yy USING '####/',tm.m2 USING '##'                                                                              
     LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",g_azi04,";",g_azi05,";",l_title1                                             
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                               
     CALL cl_prt_cs3('aapr184','aapr184',g_sql,g_str)                                                                               
#No.FUN-830103--end-- 
END FUNCTION
#No.FUN-830103--begin--
#REPORT aapr184_rep(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
#         l_aag        RECORD LIKE aag_file.*,
#         sr        RECORD
#                      order1,order2 LIKE apn_file.apn01,      # No.FUN-690028 VARCHAR(10),
#                      apn00 LIKE apn_file.apn00,   #Act no
#                      apn01 LIKE apn_file.apn01,   #付款廠商編號
#                      apn02 LIKE apn_file.apn02,   #廠商簡稱
#                      apn03 LIKE apn_file.apn03,   #DEPT
#                      apn08 LIKE apn_file.apn08,   #DEPT
#                      apn10 LIKE apn_file.apn10,   #立沖單號
#                      amt_b LIKE apn_file.apn06,
#                      amt_d LIKE apn_file.apn06,
#                      amt_c LIKE apn_file.apn06,
#                      apn11 LIKE apn_file.apn11,   #帳款日
#                      apn12 LIKE apn_file.apn12,   #
#                      apn13 LIKE apn_file.apn13,   #
#                      apn14 LIKE apn_file.apn14,   #
#                      apn15 LIKE apn_file.apn15,   #
#                      apn16 LIKE apn_file.apn16,   #
#                      gem02 LIKE gem_file.gem02
#                   END RECORD,
#     tot_b,tot_d,tot_c,tot_e,l_tot_e,l_tot_ex      LIKE apn_file.apn06,
#     l_aag02       LIKE aag_file.aag02
#  DEFINE g_head1      STRING
#  DEFINE g_head2       STRING   #TQC-6B0039
 
#  OUTPUT 
#     TOP MARGIN g_top_margin
#     LEFT MARGIN g_left_margin
#     BOTTOM MARGIN g_bottom_margin
#     PAGE LENGTH g_page_line
 
#  ORDER BY sr.apn00,sr.apn01,sr.apn10
 
#  FORMAT
#     PAGE HEADER
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
#        PRINT #No.TQC-770052
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
#        LET g_pageno = g_pageno + 1
#        LET pageno_total = PAGENO USING '<<<',"/pageno"
#        PRINT g_head CLIPPED,pageno_total   #No.TQC-770052 mark
#        SELECT * INTO l_aag.* FROM aag_file WHERE aag01 = sr.apn00
#                                              AND aag00 = sr.apn09                #NO.FUN-730064
#        LET g_head1 = g_x[10] CLIPPED,sr.apn00 CLIPPED,' ',l_aag.aag02
#        PRINT g_head1
#         LET g_head1 = g_x[9] CLIPPED,tm.yy USING '####/',tm.m1 USING '##',   #MOD-5B0204
#                       '-' ,tm.yy USING '####/',tm.m2 USING '##'   #MOD-5B0204
#        LET g_head1 = g_x[9] CLIPPED,tm.yy USING '####/',tm.m2 USING '##'   #MOD-5B0204
#        #PRINT g_head1                        #FUN-660060 remark
#        PRINT COLUMN (g_len-25)/2+1, g_head1  #FUN-660060 #No.TQC-770052 mark
#        PRINT COLUMN (g_len-12)/2-1, g_head1              #No.TQC-770052
#        LET g_head2 = g_x[18],g_orderA[1],'-',g_orderA[2]   #TQC-6B0039
#        PRINT g_head2   #TQC-6B0039
#        PRINT g_head CLIPPED,pageno_total     #No.TQC-770052
#        PRINT g_dash[1,g_len]
#        PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],
#              g_x[37],g_x[38],g_x[39],g_x[40],g_x[41]
#        PRINT g_dash1
#        LET l_last_sw = 'n'
#    
#     BEFORE GROUP OF sr.apn00
#        SKIP TO TOP OF PAGE
#        LET l_tot_ex = 0 
#    
#     AFTER GROUP OF sr.apn10
#        LET tot_b = GROUP SUM(sr.amt_b)
#        LET tot_d = GROUP SUM(sr.amt_d)
#        LET tot_c = GROUP SUM(sr.amt_c)
#        IF l_aag.aag06 = '1' THEN
#           LET tot_e = tot_b + tot_d - tot_c
#        ELSE
#           LET tot_e = tot_b + tot_c - tot_d
#        END IF
#        IF tot_e != 0 THEN
#           PRINT COLUMN g_c[31],sr.apn11,
#                 COLUMN g_c[32],sr.apn12,
#                 COLUMN g_c[33],sr.apn10,
#                 COLUMN g_c[34],sr.apn01,
#                 COLUMN g_c[35],sr.apn02,
#                 COLUMN g_c[36],sr.apn03,
#                 COLUMN g_c[37],sr.gem02,
#                 COLUMN g_c[38],sr.apn13,
#                 COLUMN g_c[39],sr.apn14,
#                 COLUMN g_c[40],cl_numfor(tot_e/sr.apn15,40,g_azi04),
#                 COLUMN g_c[41],cl_numfor(tot_e,41,g_azi04)
#           LET l_tot_e = l_tot_e + tot_e 
#           LET l_tot_ex = l_tot_ex + tot_e
#        END IF
#    
#     BEFORE GROUP OF sr.apn01
#        LET l_tot_e = 0 
#    
#     AFTER GROUP OF sr.apn01
#       #LET tot_b = GROUP SUM(sr.amt_b)
#       #LET tot_d = GROUP SUM(sr.amt_d)
#       #LET tot_c = GROUP SUM(sr.amt_c)
#       #IF l_aag.aag06 = '1' THEN
#       #   LET tot_e = tot_b + tot_d - tot_c
#       #ELSE
#       #   LET tot_e = tot_b + tot_c - tot_d
#       #END IF   
#        IF l_tot_e != 0 THEN 
#           PRINT COLUMN g_c[40],g_x[16] CLIPPED,
#                 COLUMN g_c[41],cl_numfor(l_tot_e,41,g_azi05)
#        END IF 
#    
#     AFTER GROUP OF sr.apn00
#       #LET tot_b = GROUP SUM(sr.amt_b)
#       #LET tot_d = GROUP SUM(sr.amt_d)
#       #LET tot_c = GROUP SUM(sr.amt_c)
#       #IF l_aag.aag06 = '1' THEN
#       #   LET tot_e = tot_b + tot_d - tot_c
#       #ELSE
#       #   LET tot_e = tot_b + tot_c - tot_d
#       #END IF  
#        IF l_tot_ex != 0 THEN 
#           PRINT COLUMN g_c[40],g_x[17] CLIPPED,
#                 COLUMN g_c[41],cl_numfor(l_tot_ex,41,g_azi05)
#        END IF 
 
#     ON LAST ROW   #TQC-6B0039
#        LET l_last_sw = 'y'
#    
#     PAGE TRAILER
#        PRINT g_dash[1,g_len]
#        IF l_last_sw = 'n' THEN
#           #PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[41],g_x[6] CLIPPED   #TQC-6B0039
#           PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED   #TQC-6B0039
#        ELSE
#           #PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[41],g_x[7] CLIPPED   #TQC-6B0039
#           PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED   #TQC-6B0039
#        END IF  
 
#END REPORT
#No.FUN-830103--end--
