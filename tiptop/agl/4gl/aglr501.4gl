# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglr501.4gl
# Descriptions...: 部門科目日記帳
# Modify.........: No.MOD-4A0338 04/10/28 By Smapmin 以za_file方式取代PRINT中文字的部份
# Modify.........: No.FUN-510007 05/01/10 By Nicola 報表架構修改
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-660060 06/06/26 By Rainy 表頭期間置於中間
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680098 06/08/31 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-6B0093 06/11/23 By wujie   調整“接下頁/結束”位置 
# Modify.........: No.FUN-6C0012 06/12/27 By Judy 新增打印額外名稱欄位
# Modify.........: No.FUN-740020 07/04/10 By Lynn 會計科目加帳套
# Modify.........: No.TQC-6C0098 07/04/22 By Sarah QBE加一選項"是否列印內部管理科目"(aag38)
# Modify.........: No.MOD-740243 07/04/22 By Sarah 重新過單
# Modify.........: No.FUN-760083 07/08/03 By mike 報表格式修改為crystal reports
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A80107 10/08/19 By xiaofeizhu SQL語句調整
# Modify.........: No.FUN-B20054 11/02/23 By lixiang 先錄入帳套,科目根據帳套過濾;結構改為DIALOG
# Modify.........: No.TQC-C40109 12/04/13 By wujie  不输入日期的时候，日期条件不加入sql 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD            # Print condition RECORD
              wc             LIKE type_file.chr1000,       #Where Condiction   #No.FUN-680098  VARCHAR(300)    
              bookno         LIKE aag_file.aag00,          #No.FUN-740020
              b_date, e_date LIKE type_file.dat,           #No.FUN-680098 date
              a              LIKE type_file.chr1,          #FUN-6C0012
              g              LIKE type_file.chr1,          #是否輸入其它特殊列印條件   #No.FUN-680098  VARCHAR(1)    
              aag38          LIKE aag_file.aag38           #TQC-6C0098 add
           END RECORD 
#       g_bookno  LIKE aba_file.aba00     #帳別編號     #No.FUN-740020
DEFINE g_aaa03   LIKE aaa_file.aaa03
DEFINE g_cnt     LIKE type_file.num10    #No.FUN-680098 integer
DEFINE g_i       LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098 smallint
DEFINE g_str     STRING                  #No.FUN-760083
 
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
 
   LET tm.bookno=ARG_VAL(1)               #No.FUN-740020
   LET g_pdate = ARG_VAL(2)            # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc  = ARG_VAL(8)
   LET tm.b_date = ARG_VAL(9)   #TQC-610056
   LET tm.e_date = ARG_VAL(10)  #TQC-610056
   LET tm.g  = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   #No.FUN-570264 ---end---
   LET tm.a       = ARG_VAL(15)  #FUN-6C0012
   LET tm.aag38 = ARG_VAL(16)    #TQC-6C0098 add
   LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
 
#No.FUN-740020  ---begin
    IF tm.bookno = ' ' OR tm.bookno IS NULL THEN
       LET tm.bookno = g_aza.aza81   #帳別若為空白則使用預設帳別
    END IF
#No.FUN-740020  ---end
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.bookno     #No.FUN-740020
   IF SQLCA.sqlcode THEN
      LET g_aaa03 = g_aza.aza17
   END IF     #使用本國幣別
 
   SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file WHERE azi01 = g_aaa03     #No.CHI-6A0004 g_azi-->t_azi
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_aaa03,SQLCA.sqlcode,0)   #No.FUN-660123
      CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","",0)   #No.FUN-660123
   END IF
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL aglr501_tm()
   ELSE
      CALL aglr501()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION aglr501_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01         #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,        #No.FUN-680098 smallint
       l_cmd          LIKE type_file.chr1000      #No.FUN-680098 VARCHAR(400)
DEFINE li_chk_bookno  LIKE type_file.num5         #FUN-B20054 
   CALL s_dsmark(tm.bookno)       #No.FUN-740020
   LET p_row = 4 LET p_col = 16
   OPEN WINDOW aglr501_w AT p_row,p_col
     WITH FORM "agl/42f/aglr501"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL s_shwact(0,0,tm.bookno)    #No.FUN-740020
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  # Default condition
   LET tm.a = 'N'  #FUN-6C0012
   LET tm.g = 'N'
   LET tm.aag38 = 'N'   #TQC-6C0098 add
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #No.FUN-20054  ---begin
    IF tm.bookno = ' ' OR tm.bookno IS NULL THEN
       LET tm.bookno = g_aza.aza81   #帳別若為空白則使用預設帳別
    END IF
#No.FUN-20054  ---end
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
      CONSTRUCT BY NAME tm.wc ON abb05,abb03,aba01
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
#           ON ACTION exit
#           LET INT_FLAG = 1
#           EXIT CONSTRUCT
# 
#         #No.FUN-580031 --start--
#         ON ACTION qbe_select
#            CALL cl_qbe_select()
#         #No.FUN-580031 ---end---
#FUN-B20054--mark--str--
 
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
#         CLOSE WINDOW aglr501_w
#         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#         EXIT PROGRAM
#      END IF
#FUN-B20054--mark--str-- 

  #  INPUT BY NAME tm.bookno,tm.b_date,tm.e_date,tm.a,tm.g,tm.aag38 WITHOUT DEFAULTS   #FUN-6C0012 #FUN-B20054      #No.FUN-740020   #TQC-6C0098 add tm.aag38
     INPUT BY NAME tm.b_date,tm.e_date,tm.a,tm.g,tm.aag38
                    ATTRIBUTE(WITHOUT DEFAULTS)  #FUN-B20054

#FUN-B20054--mark--str--
#     #No.FUN-740020 -- begin --                                                                                                          
#         AFTER FIELD bookno                                                                                                         
#            IF tm.bookno = '*' THEN                                                                                                 
#               NEXT FIELD bookno                                                                                                    
#            END IF                                                                                                                  
#     #No.FUN-740020 -- end -- 
#FUN-B20054--mark--str-- 
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD g
            IF tm.g NOT MATCHES "[YN]" THEN
               NEXT FIELD g
            END IF
 
            IF tm.g = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         #str TQC-6C0098 add
         AFTER FIELD aag38
            IF tm.aag38 NOT MATCHES "[YN]" THEN
               NEXT FIELD aag38
            END IF
         #end TQC-6C0098 add 
         
#FUN-B20054--mark--str-- 
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
#     #No.FUN-740020  ---begin 
#        ON ACTION controlp                                                                                                           
#           CASE                                                                                                                        
#              WHEN INFIELD(bookno)                                                                                                      
#                CALL cl_init_qry_var()                                                                                                 
#                LET g_qryparam.form = 'q_aaa'                                                                                          
#                LET g_qryparam.default1 = tm.bookno                                                                                    
#                CALL cl_create_qry() RETURNING tm.bookno                                                                               
#                DISPLAY BY NAME tm.bookno                                                                                              
#                NEXT FIELD bookno                                                                                                      
#          END CASE
#     #No.FUN-740020  ---end 
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
      #No.FUN-740020  ---begin 
      ON ACTION controlp                                                                                                           
         CASE                                                                                                                        
           WHEN INFIELD(bookno)                                                                                                      
              CALL cl_init_qry_var()                                                                                                 
              LET g_qryparam.form = 'q_aaa'                                                                                          
              LET g_qryparam.default1 = tm.bookno                                                                                    
              CALL cl_create_qry() RETURNING tm.bookno                                                                               
              DISPLAY BY NAME tm.bookno                                                                                              
              NEXT FIELD bookno
        #No.FUN-740020  ---end
           WHEN INFIELD(abb03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_aag02"
              LET g_qryparam.state = "c"
              LET g_qryparam.where = " aag00 = '",tm.bookno CLIPPED,"'"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO abb03
              NEXT FIELD abb03             
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
       CLOSE WINDOW aglr501_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
       EXIT PROGRAM
    END IF
   #FUN-B20054--add--end 
   
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aglr501'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglr501','9031',1)  
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,      #(at time fglgo xxxx p1 p2 p3)
#                        " '",g_bookno CLIPPED,"'" ,
                        " '",tm.bookno CLIPPED,"'",          #No.FUN-740020
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.b_date CLIPPED,"'",   #TQC-610056
                        " '",tm.e_date CLIPPED,"'",   #TQC-610056
                        " '",tm.a CLIPPED,"'",        #FUN-6C0012
                        " '",tm.g CLIPPED,"'",
                        " '",tm.aag38 CLIPPED,"'",             #TQC-6C0098 add
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aglr501',g_time,l_cmd)  # Execute cmd at later time
         END IF
 
         CLOSE WINDOW aglr501_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL aglr501()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW aglr501_w
 
END FUNCTION
 
FUNCTION aglr501()
   DEFINE l_name      LIKE type_file.chr20,            # External(Disk) file name        #No.FUN-680098 VARCHAR(20)
#       l_time          LIKE type_file.chr8          #No.FUN-6A0073
          l_sql       LIKE type_file.chr1000,          # RDSQL STATEMENT      #No.FUN-680098  VARCHAR(1000)    
          l_chr       LIKE type_file.chr1,             #No.FUN-680098   VARCHAR(1)    
          l_order     ARRAY[5] OF LIKE type_file.chr20,  #排列順序  #No.FUN-680098  VARCHAR(10)    
          l_i         LIKE type_file.num5,             #No.FUN-680098 smallint   #MOD-740243
          sr          RECORD
                         abb05     LIKE abb_file.abb05,
                         gem02     LIKE gem_file.gem02,
                         abb03     LIKE abb_file.abb03,#科目
                         aag02     LIKE aag_file.aag02,#科目名稱
                         aag13     LIKE aag_file.aag13,#額外名稱 #FUN-6C0012
                         aba02     LIKE aba_file.aba02,#傳票日期
                         aba01     LIKE aba_file.aba01,#傳票編號
                         abb04     LIKE abb_file.abb04,#摘要
                         abb06     LIKE abb_file.abb06,#借貸別
                         abb07     LIKE abb_file.abb07 #異動金額
                      END RECORD
 
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = tm.bookno        #No.FUN-740020
      AND aaf02 = g_rlang
 
   #====>資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND abauser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND abagrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND abagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('abauser', 'abagrup')
   #End:FUN-980030
 
 
   LET l_sql = "SELECT abb05, gem02, abb03, aag02, aag13, aba02, aba01,",   #FUN-6C0012
               "       abb04, abb06, abb07",
" FROM aba_file, ",
"      abb_file LEFT OUTER JOIN aag_file ON abb00 = aag00 AND abb03 = aag01 ",
"               LEFT OUTER JOIN gem_file ON abb05 = gem01 ",
               " WHERE aba00 = '",tm.bookno,"'", #若為空白使用預設帳別    #No.FUN-740020
               "   AND aba00 = abb00",
#              "   AND aba00 = aag00",     #No.FUN-740020      #No.FUN-760083 
               "   AND aba01 = abb01",
               "   AND abapost = 'Y'",
               "   AND abaacti = 'Y'",
#              "   AND aba02 BETWEEN cast('",tm.b_date,"' as datetime) AND cast('",tm.e_date,"' as datetime)",   #TQC-A80107 Mark
#               "   AND aba02 BETWEEN '",tm.b_date,"' AND '",tm.e_date,"' ",   #TQC-A80107 Add #No.TQC-C40109 mark
               "   AND ",tm.wc
   LET l_sql = l_sql CLIPPED," AND aag_file.aag38 = '",tm.aag38,"'"   #TQC-6C0098 add
#No.TQC-C40109 --begin
   IF NOT cl_null(tm.b_date) AND cl_null(tm.e_date) THEN
      LET l_sql=l_sql,"   AND aba02 >= '",tm.b_date,"'"
   END IF
   IF cl_null(tm.b_date) AND NOT cl_null(tm.e_date) THEN
      LET l_sql=l_sql,"   AND aba02 <= '",tm.e_date,"'"
   END IF
   IF NOT cl_null(tm.b_date) AND NOT cl_null(tm.e_date) THEN
      LET l_sql=l_sql,"   AND aba02 BETWEEN '",tm.b_date,"' AND '",tm.e_date,"' "
   END IF
#No.TQC-C40109 --end
#No.FUN-760083  --begin--
{
   PREPARE aglr501_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   DECLARE aglr501_curs1 CURSOR FOR aglr501_prepare1
 
   CALL cl_outnam('aglr501') RETURNING l_name
 
   #No.FUN-6C0012 --start--                                                     
   IF tm.a = 'Y' THEN                                                           
      LET g_zaa[32].zaa06 = 'Y'                                                 
   ELSE                                                                         
      LET g_zaa[38].zaa06 = 'Y'                                                 
   END IF                                                                       
                                                                                
   CALL cl_prt_pos_len()                                                        
   #No.FUN-6C0012 --end--
 
   START REPORT aglr501_rep TO l_name
 
   LET g_pageno = 0
   LET g_cnt    = 1
 
   FOREACH aglr501_curs1 INTO sr.*
      IF STATUS != 0 THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
 
      OUTPUT TO REPORT aglr501_rep(sr.*)
 
   END FOREACH
 
   FINISH REPORT aglr501_rep
 
   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
}
   LET g_str=''
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
   IF g_zz05='Y' THEN 
      CALL cl_wcchp(tm.wc,'abb05,abb03,aba01')
      RETURNING tm.wc
   END IF
   LET g_str=tm.wc,';',tm.a,';',tm.b_date,';',tm.e_date
   CALL cl_prt_cs1("aglr501","aglr501",l_sql,g_str)
#No.FUN-760083  --end--
   
END FUNCTION
 
#No.FUN-760083  --begin--
{
REPORT aglr501_rep(sr)
   DEFINE l_last_sw     LIKE type_file.chr1,   #No.FUN-680098 VARCHAR(1)
          amt1,amt2     LIKE abb_file.abb07,
          sr            RECORD
                           abb05     LIKE abb_file.abb05,
                           gem02     LIKE gem_file.gem02,
                           abb03     LIKE abb_file.abb03,#科目
                           aag02     LIKE aag_file.aag02,#科目名稱
                           aag13     LIKE aag_file.aag13,#額外名稱 #FUN-6C0012
                           aba02     LIKE aba_file.aba02,#傳票日期
                           aba01     LIKE aba_file.aba01,#傳票編號
                           abb04     LIKE abb_file.abb04,#摘要
                           abb06     LIKE abb_file.abb06,#借貸別
                           abb07     LIKE abb_file.abb07 #異動金額
                        END RECORD
   DEFINE g_head1       STRING
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.abb05,sr.abb03,sr.aba02
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
          LET g_head1 = g_x[8] CLIPPED,sr.abb05, ' ', sr.gem02   #MOD-4A0338
         PRINT g_head1
         LET g_head1 = g_x[9] CLIPPED,tm.b_date,'-',tm.e_date
         #PRINT g_head1                        #FUN-660060 remark
         PRINT COLUMN (g_len-25)/2+1, g_head1  #FUN-660060
         PRINT g_dash[1,g_len]
#        PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]         #FUN-6C0012
         PRINT g_x[31],g_x[32],g_x[38],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37] #FUN-6C0012  
         PRINT g_dash1
         LET l_last_sw = 'n'
 
      BEFORE GROUP OF sr.abb05
         SKIP TO TOP OF PAGE
 
      BEFORE GROUP OF sr.abb03
         PRINT COLUMN g_c[31],sr.abb03,
               COLUMN g_c[32],sr.aag02,   #MOD-4A0338
               COLUMN g_c[38],sr.aag13    #FUN-6C0012
 
      ON EVERY ROW
         PRINT COLUMN g_c[33],sr.aba02,
               COLUMN g_c[34],sr.aba01,
               COLUMN g_c[35],sr.abb04,
               COLUMN g_c[36],sr.abb06,
               COLUMN g_c[37],sr.abb07 USING '#,###,###,###,###'
 
      AFTER GROUP OF sr.abb03
         LET amt1=GROUP SUM(sr.abb07) WHERE sr.abb06='1'
         LET amt2=GROUP SUM(sr.abb07) WHERE sr.abb06='2'
         IF amt1 IS NULL THEN LET amt1=0 END IF
         IF amt2 IS NULL THEN LET amt2=0 END IF
 
          PRINT COLUMN g_c[35],g_x[10] CLIPPED,    #MOD-4A0338
               COLUMN g_c[37],(amt1-amt2) USING '#,###,###,###,###'
         PRINT g_dash2[1,g_len]
 
      AFTER GROUP OF sr.abb05
         LET amt1=GROUP SUM(sr.abb07) WHERE sr.abb06='1'
         LET amt2=GROUP SUM(sr.abb07) WHERE sr.abb06='2'
         IF amt1 IS NULL THEN LET amt1=0 END IF
         IF amt2 IS NULL THEN LET amt2=0 END IF
 
          PRINT COLUMN g_c[35],g_x[11] CLIPPED,     #MOD-4A0338
               COLUMN g_c[37],(amt1-amt2) USING '#,###,###,###,###'
         PRINT g_dash2[1,g_len]
 
      ON LAST ROW
         LET l_last_sw = 'y'
         #FUN-6C0012.....begin  mark
         #PRINT g_dash[1,g_len]
         #PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED         #No.TQC-6B0093
         #FUN-6C0012.....end
 
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED         #No.TQC-6B0093
         ELSE
            #FUN-6C0012.....begin
            PRINT g_dash[1,g_len]                                               
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
            #SKIP 2 LINE
            #FUN-6C0012.....end
         END IF
 
END REPORT
}
#No.FUN-760083  --end--
