# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglr159.4gl
# Descriptions...: 科目部門分類帳
# Input parameter: 
# Return code....: 
# Date & Author..: 95/12/04 By Roger
#
# modify by:Susanl Lee
# modify date:02/14/1996
# description:原期初金額之抓法.dbo.select table aao_file (部門科目餘額檔)
#             變更為:
#                    因aao_file無期初金額, 但資產、負債、股東權益需以累
#                    計show出期初金額。
#                    if accout no first character = "1" or "2" or "3" 者
#                                                   資產  負債   股東權益
#                       期初金額select table aah_file
#                    ELSE
#                       期初金額select table aao_file 
#                    end if
# Modify.........: No.FUN-510007 05/01/10 By Nicola 報表架構修改
# Modify.........: No.MOD-570354 05/07/28 By Smapmin 以MDY()方式取代DATE()
# Modify.........: NO.FUN-570250 05/12/23 By Rosayu 將日期取消寫死YY/MM/DD
# Modify.........: NO.FUN-5C0015 檢查abb11寬度原c(15)，改為c(30)
# Modify.........: No.FUN-660060 06/06/28 By Rainy 表頭期間置於中間
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680098 06/08/31 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-6B0093 06/11/23 By wujie   修改“接下頁/結束”的位置 
# Modify.........: No.FUN-6B0022 06/12/04 By yjkhero 打印 sr.aba01 為#######的錯誤修改   
# Modify.........: No.FUN-6C0012 06/12/26 By Judy 新增打印額外名稱欄位
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740020 07/04/12 By Lynn 會計科目加帳套
# Modify.........: No.TQC-740093 07/04/18 By johnray 報表打印中不需加aba00帳套,違反原有邏輯
# Modify.........: No.TQC-6C0098 07/04/22 By Sarah QBE加一選項"是否列印內部管理科目"(aag38)
# Modify.........: No.FUN-760083 07/08/01 By mike   報表格式修改為crystal reports
# Modify.........: No.MOD-880020 08/08/04 By liuxqa 修改部門名稱
# Modify.........: No.TQC-960290 09/06/22 By Sarah 當系統參數DBDATE=Y4MD時,畫面上若輸入2008年1月,計算出來的s_date會變成0008/1/1
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A40133 10/05/07 By liuxqa modify sql
# Modify.........: No.MOD-A80152 10/08/20 By Dido 置換 tm.wc 變數調整 
# Modify.........: No.FUN-B20054 11/02/23 By lixiang 先錄入帳套,科目根據帳套過濾;結構改為DIALOG
# Modify.........: No.CHI-C80041 12/12/24 By bart 排除作廢
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                  # Print condition RECORD
                 wc    LIKE type_file.chr1000,  #Where Condiction       #No.FUN-680098  VARCHAR(300)
                 yy1   LIKE type_file.num5,     #No.FUN-680098    smallint
                  m1   LIKE type_file.num5,     #No.FUN-680098     smallint
                 yy2   LIKE type_file.num5,     #No.FUN-680098     smallint
                 m2    LIKE type_file.num5,     #No.FUN-680098     smallint
                 d     LIKE type_file.chr1,     #過帳別 (1)未過帳(2)已過帳(3)全部 #No.FUN-680098    VARCHAR(1) 
                 e     LIKE type_file.chr1,     #列印額外名稱 #FUN-6C0012
                 aag38 LIKE aag_file.aag38,     #TQC-6C0098 add
                 more  LIKE type_file.chr1      #是否輸入其它特殊列印條件  #No.FUN-680098     VARCHAR(1)
              END RECORD,
       g_bookno    LIKE aba_file.aba00 #帳別編號
DEFINE s_date,e_date  LIKE type_file.dat           #No.FUN-680098 date
DEFINE t_azm          RECORD LIKE azm_file.*
DEFINE t_l_begin,t_t_amt_d,t_t_amt_c LIKE abb_file.abb07
DEFINE g_i            LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098 smallint
DEFINE g_str          STRING                  #No.FUN-760083
DEFINE g_sql          STRING                  #No.FUN-760083
DEFINE l_table        STRING                  #No.FUN-760083
DEFINE l_table1       STRING                  #No.FUN-760083
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
#No.FUN-760083   --begin--
   LET g_sql="aag01.aag_file.aag01,",
             "aba00.aba_file.aba00,",
             "aba01.aba_file.aba01,",
             "aba14.aba_file.aba14,",
             "aba02.aba_file.aba02,",
             "abb02.abb_file.abb02,",
             "abb03.abb_file.abb03,",
             "aag02.aag_file.aag02,",
             "aag13.aag_file.aag13,",
             "abb04.abb_file.abb04,",
             "abb05.abb_file.abb05,",
             "abb06.abb_file.abb06,",
             "abb07.abb_file.abb07,",
             "abb11.abb_file.abb11,",
             "amt_d.abb_file.abb07,",
             "amt_c.abb_file.abb07"
  LET l_table = cl_prt_temptable("aglr159",g_sql) CLIPPED
  IF l_table=-1 THEN EXIT PROGRAM END IF
  LET g_sql="aag01.aag_file.aag01,",                                                                                               
             "aba00.aba_file.aba00,",                                                                                               
             "aba01.aba_file.aba01,",                                                                                               
             "aba14.aba_file.aba14,",                                                                                               
             "aba02.aba_file.aba02,",                                                                                               
             "abb02.abb_file.abb02,",                                                                                               
             "abb03.abb_file.abb03,",                                                                                               
             "aag02.aag_file.aag02,",                                                                                               
             "aag13.aag_file.aag13,",                                                                                               
             "abb04.abb_file.abb04,",                                                                                               
             "abb05.abb_file.abb05,",                                                                                               
             "abb06.abb_file.abb06,",                                                                                               
             "abb07.abb_file.abb07,",                                                                                               
             "abb11.abb_file.abb11,",                                                                                               
             "amt_d.abb_file.abb07,",                                                                                               
             "amt_c.abb_file.abb07,",                                                                                               
             "l_begin.abb_file.abb07,",                                                                                             
             "s_count.type_file.num5,",                                                                                             
             "l_gem02.gem_file.gem02"    
  LET l_table1 = cl_prt_temptable("aglr1591",g_sql) CLIPPED                                                                          
  IF l_table1=-1 THEN EXIT PROGRAM END IF    
#No.FUN-760083  --END--
 
   LET g_bookno = ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)            # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc  = ARG_VAL(8)
   #-----TQC-610056---------
   LET tm.yy1 = ARG_VAL(9)
   LET tm.m1  = ARG_VAL(10)
   LET tm.yy2 = ARG_VAL(11)
   LET tm.m2  = ARG_VAL(12)
   #-----END TQC-610056-----
   LET tm.d  = ARG_VAL(13)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   #No.FUN-570264 ---end---
   LET tm.e = ARG_VAL(17)   #FUN-6C0012
   LET tm.aag38 = ARG_VAL(18)   #TQC-6C0098 add
   LET g_rpt_name = ARG_VAL(19)  #No.FUN-7C0078
 
   IF g_bookno = ' ' OR g_bookno IS NULL THEN 
      LET g_bookno = g_aza.aza81       #No.FUN-740020              #帳別若為空白則使用預設帳別
   END IF
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL aglr159_tm()
   ELSE
      CALL aglr159()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION aglr159_tm()
   DEFINE lc_qbe_sn        LIKE gbm_file.gbm01           #No.FUN-580031
   DEFINE p_row,p_col      LIKE type_file.num5,          #No.FUN-680098 smallint
          l_cmd            LIKE type_file.chr1000        #No.FUN-680098 VARCHAR(400)
   DEFINE li_chk_bookno    LIKE type_file.num5           #FUN-B20054
   
   CALL s_dsmark(g_bookno)
   LET p_row = 4 LET p_col = 18
   OPEN WINDOW aglr159_w AT p_row,p_col
     WITH FORM "agl/42f/aglr159"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   SELECT azi05 INTO t_azi05 FROM azi_file WHERE azi01 = g_aaa03   #No.CHI-6A0004 g_azi-->t_azi
 
   CALL s_shwact(3,2,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  # Default condition
   LET tm.d = '3'
   LET tm.e = 'N'   #FUN-6C0012
   LET tm.aag38 = 'N'   #TQC-6C0098 add
   LET tm.more = 'N'    
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
    #FUN-B20054--add--str--
    DIALOG ATTRIBUTE(unbuffered)
     #  INPUT BY NAME g_bookno ATTRIBUTE(WITHOUT DEFAULTS)
        INPUT g_bookno FROM aba00 ATTRIBUTE(WITHOUT DEFAULTS)
          AFTER FIELD aba00
            IF NOT cl_null(g_bookno) THEN
                   CALL s_check_bookno(g_bookno,g_user,g_plant)
                    RETURNING li_chk_bookno
                IF (NOT li_chk_bookno) THEN
                    NEXT FIELD aba00
                END IF
                SELECT aaa02 FROM aaa_file WHERE aaa01 = g_bookno
                IF STATUS THEN
                   CALL cl_err3("sel","aaa_file",g_bookno,"","agl-043","","",0)
                   NEXT FIELD aba00
                END IF
            END IF
       END INPUT
     #FUN-B20054--add--end
     # CONSTRUCT BY NAME tm.wc ON aag01,abb05,aba00   #No.FUN-B20054
       CONSTRUCT BY NAME tm.wc ON aag01,abb05  #No.FUN-B20054
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
#          ON ACTION CONTROLG      #MOD-4C0121
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
#         CLOSE WINDOW aglr159_w
#         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#         EXIT PROGRAM
#      END IF
#FUN-B20054--mark--end
      
      INPUT BY NAME tm.yy1,tm.m1,tm.yy2,tm.m2,tm.d,tm.e,tm.aag38,tm.more 
                  # WITHOUT DEFAULTS  #FUN-6C0012   #TQC-6C0098 add tm.aag38 #FUN-B20054
                  ATTRIBUTE(WITHOUT DEFAULTS)  #FUN-B20054
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD d
            IF tm.d NOT MATCHES "[123]" THEN
               NEXT FIELD d
            END IF
      
         AFTER FIELD yy1
            IF tm.yy1 IS NULL THEN
               NEXT FIELD yy1
            END IF
 
            IF tm.yy1 < 1900 THEN 
               NEXT FIELD yy1
            END IF 
      
         AFTER FIELD m1
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.m1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy1
            IF g_azm.azm02 = 1 THEN
               IF tm.m1 > 12 OR tm.m1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1
               END IF
            ELSE
               IF tm.m1 > 13 OR tm.m1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
            IF tm.m1 IS NULL THEN
               NEXT FIELD m1
            END IF
      
         AFTER FIELD yy2
            IF tm.yy2 IS NULL THEN
               NEXT FIELD yy2
            END IF
 
            IF tm.yy2 < tm.yy1 THEN 
               NEXT FIELD yy2 
            END IF
 
            INITIALIZE t_azm.* TO NULL
 
            SELECT azm_file.* INTO t_azm.*
              FROM azm_file WHERE azm01 = tm.yy2
 
            IF t_azm.azm01 IS NULL THEN
               ERROR "azm_file TABLE NOT FOUND"
               NEXT FIELD yy2 
            END IF
 
         AFTER FIELD m2
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.m2) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy1
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
            IF tm.m2 IS NULL THEN
               NEXT FIELD m2
            END IF
 
            IF tm.yy1 = tm.yy2 THEN
               IF tm.m2 < tm.m1 THEN
                  NEXT FIELD m2 
               END IF
            END IF
 
         #str TQC-6C0098 add
         AFTER FIELD aag38
            IF tm.aag38 NOT MATCHES "[YN]" THEN
               NEXT FIELD aag38
            END IF
         #end TQC-6C0098 add
 
         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" THEN
               NEXT FIELD more 
            END IF
 
            IF tm.more = 'Y' THEN 
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
            
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
          CASE
             WHEN INFIELD(aba00)
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_aaa3'
                LET g_qryparam.default1 = g_bookno
                CALL cl_create_qry() RETURNING g_bookno
                DISPLAY g_bookno TO FORMONLY.aba00
                NEXT FIELD aba00
             WHEN INFIELD(aag01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag02"
                LET g_qryparam.state = "c"
                LET g_qryparam.where = " aag00 = '",g_bookno CLIPPED,"'"
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
         
      ON ACTION CONTROLG      #MOD-4C0121
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
       CLOSE WINDOW aglr159_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
       EXIT PROGRAM
    END IF
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup') #FUN-980030
    #FUN-B20054--add--end
    
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file      #get exec cmd (fglgo xxxx)
          WHERE zz01='aglr159'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglr159','9031',1)   
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,            #(at time fglgo xxxx p1 p2 p3)
                        " '",g_bookno CLIPPED,"'",
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        #-----TQC-610056---------
                        " '",tm.yy1 CLIPPED,"'",
                        " '",tm.m1 CLIPPED,"'",
                        " '",tm.yy2 CLIPPED,"'",
                        " '",tm.m2 CLIPPED,"'",
                        #-----END TQC-610056-----
                        " '",tm.d CLIPPED,"'",
                        " '",tm.e CLIPPED,"'",                  #FUN-6C0012
                        " '",tm.aag38 CLIPPED,"'",              #TQC-6C0098 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aglr159',g_time,l_cmd)      # Execute cmd at later time
         END IF
 
         CLOSE WINDOW aglr159_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL aglr159()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW aglr159_w
 
END FUNCTION
 
FUNCTION aglr159()
   DEFINE l_name      LIKE type_file.chr20,   # External(Disk) file name        #No.FUN-680098  VARCHAR(20)
#       l_time          LIKE type_file.chr8          #No.FUN-6A0073
          l_sql       LIKE type_file.chr1000, # RDSQL STATEMENT                 #No.FUN-680098  VARCHAR(1000)  
          l_chr       LIKE type_file.chr1,    #No.FUN-680098     VARCHAR(1)
          l_i,i       LIKE type_file.num5,    #No.FUN-680098     smallint
          sr          RECORD 
                         aag01     like aag_file.aag01,#科目編號
                         aba00     LIKE aba_file.aba00,#帳別
                         aba01     LIKE aba_file.aba01,#傳票編號
                         aba14     LIKE aba_file.aba14,#cd傳票編號
                         aba02     LIKE aba_file.aba02,#傳票日期
                         abb02     LIKE abb_file.abb02,#Seq
                         abb03     LIKE abb_file.abb03,#科目
                         aag02     LIKE aag_file.aag02,#科目名稱
                         aag13     LIKE aag_file.aag13,#額外名稱  #FUN-6C0012
                         abb04     LIKE abb_file.abb04,#摘要  
                         abb05     LIKE abb_file.abb05,#部門
                         abb06     LIKE abb_file.abb06,#借貸別 
                         abb07     LIKE abb_file.abb07,#異動金額
                         abb11     LIKE abb_file.abb11,#異動碼-1
                         amt_d     LIKE abb_file.abb07,
                         amt_c     LIKE abb_file.abb07
                       END RECORD
DEFINE s_char          LIKE type_file.chr20     #No.FUN-680098  VARCHAR(10)    
DEFINE g_head1         STRING 
DEFINE l_mm,l_dd,l_yy LIKE type_file.num10    #MOD-570354 #No.FUN-680098   INTEGER 
DEFINE l_begin         LIKE abb_file.abb07    #No.FUN-760083
DEFINE s_count         LIKE type_file.num5    #No.FUN-760083
DEFINE l_gem02         LIKE gem_file.gem02    #No.FUN-760083
   LET t_l_begin = 0
   LET t_t_amt_d = 0
   LET t_t_amt_c = 0 
   LET l_gem02 = ' '
   LET s_count = 0
 
   SELECT aaf03 INTO g_company FROM aaf_file 
    WHERE aaf01 = g_bookno
      AND aaf02 = g_rlang
 #MOD-570354
  #IF tm.yy1 >=2000 THEN 
  #   LET s_char = (tm.yy1 - 2000) USING "&&","/",tm.m1 USING "&&","/01"
  #ELSE 
  #   LET s_char = (tm.yy1 - 1900) USING "&&","/",tm.m1 USING "&&","/01"
  #END IF 
  #LET s_date = DATE(s_char)
  #str TQC-960290 mod
  #IF tm.yy1 >= 2000 THEN
  #   LET l_mm = tm.m1 USING "&&"
  #   LET l_dd = 01
  #   LET l_yy = (tm.yy1 - 2000) USING "&&"
  #ELSE
  #   LET l_mm = tm.m1 USING "&&"
  #   LET l_dd = 01
  #   LET l_yy = (tm.yy1 - 1900) USING "&&"
  #END IF
   LET l_yy = tm.yy1 USING "&&&&"
   LET l_mm = tm.m1 USING "&&"
   LET l_dd = 01
  #end TQC-960290 mod
 
   LET s_date = MDY(l_mm,l_dd,l_yy)
 #END MOD-570354
 
   CASE 
      WHEN tm.m2 = 1
         LET e_date = t_azm.azm012 
      WHEN tm.m2 = 2
         LET e_date = t_azm.azm022 
      WHEN tm.m2 = 3
         LET e_date = t_azm.azm032 
      WHEN tm.m2 = 4
         LET e_date = t_azm.azm042 
      WHEN tm.m2 = 5
         LET e_date = t_azm.azm052 
      WHEN tm.m2 = 6
         LET e_date = t_azm.azm062 
      WHEN tm.m2 = 7
         LET e_date = t_azm.azm072 
      WHEN tm.m2 = 8
         LET e_date = t_azm.azm082 
      WHEN tm.m2 = 9
         LET e_date = t_azm.azm092 
      WHEN tm.m2 = 10
         LET e_date = t_azm.azm102 
      WHEN tm.m2 = 11
         LET e_date = t_azm.azm112 
      WHEN tm.m2 = 12
         LET e_date = t_azm.azm122 
   END CASE
 
   LET l_sql = "SELECT aag01,aba00,aba01,aba14,aba02,",
               " abb02,abb03,aag02,aag13,abb04,abb05,abb06,abb07,abb11,0,0",   #FUN-6C0012
               " FROM aag_file LEFT OUTER JOIN aba_file LEFT OUTER JOIN abb_file ON aba_file.aba01 = abb_file.abb01 AND aba_file.aba00 = abb_file.abb00 ON aag_file.aag01 = abb_file.abb03  ",
 
 
               "  WHERE aba00 = aag00",
 
               "   AND aag00 = '",g_bookno,"'",     #No.FUN-740020
               "   AND abaacti='Y'",
               "   AND aba19 <> 'X' ",  #CHI-C80041
          #####"   AND aba03=",tm.yy1," AND aba04=",tm.m1,
               "   AND aba_file.aba02 >='",s_date,"' ",
               "   AND aba_file.aba02 <='",e_date,"' ",
               "   AND ",tm.wc
 
   CASE 
      WHEN tm.d = '1'
         LET l_sql = l_sql CLIPPED," AND abapost = 'N' "
      WHEN tm.d = '2'
         LET l_sql = l_sql CLIPPED," AND abapost = 'Y' "
   END CASE
   LET l_sql = l_sql CLIPPED," AND aag38 = '",tm.aag38,"'"   #TQC-6C0098 add
 
   PREPARE aglr159_prepare1 FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   DECLARE aglr159_curs1 CURSOR FOR aglr159_prepare1
 
   #CALL cl_outnam('aglr159') RETURNING l_name   #No.FUN-760083
   #START REPORT aglr159_rep TO l_name           #No.FUN-760083
   LET g_str=''                                  #No.FUN-760083
   CALL cl_del_data(l_table)                     #No.FUN-760083
   CALL cl_del_data(l_table1)                    #No.FUN-760083
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog   #No.FUN-760083
#No.FUN-760083  --begin--
   #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,                                                                             
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,   #TQC-A40133 mod
              " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"                                                                            
  PREPARE insert_prep FROM g_sql                                                                                                    
  IF STATUS THEN                                                                                                                    
     CALL cl_err("insert_prep:",status,1)                                                                                           
  END IF                        
   #LET g_sql = "INSERT INTO ds_report.",l_table1 CLIPPED,                            
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,   #TQC-A40133 mod                                                
              " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"                                                                      
  PREPARE insert_prep1 FROM g_sql                                                                                                   
  IF STATUS THEN                                                                                                                    
     CALL cl_err("insert_prep1:",status,1)                                                                                          
  END IF                                            
#No.FUN-760083  --end--
 
   FOREACH aglr159_curs1 INTO sr.*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
      IF sr.abb06='1' THEN
         LET sr.amt_d = sr.abb07
         LET sr.amt_c = 0
      ELSE
         LET sr.amt_c = 0
         LET sr.amt_c = sr.abb07
      END IF
 
      #OUTPUT TO REPORT aglr159_rep(sr.*)                                #No.FUN-760083
      EXECUTE insert_prep USING  sr.aag01,sr.aba00,sr.aba01,sr.aba14,    #No.FUN-760083
                                 sr.aba02,sr.abb02,sr.abb03,sr.aag02,    #No.FUN-760083
                                 sr.aag13,sr.abb04,sr.abb05,sr.abb06,    #No.FUN-760083
                                 sr.abb07,sr.abb11,sr.amt_d,sr.amt_c    #No.FUN-760083
   END FOREACH
 
  #-MOD-A80152-mark-
  #FOR i=1 TO 290
  #   IF tm.wc[i,i+4] = 'aag01' THEN
  #      LET tm.wc[i,i+4] = 'aao01'
  #   END IF
  # 
  #   IF tm.wc[i,i+4] = 'abb05' THEN 
  #      LET tm.wc[i,i+4]='aao02'
  #   END IF
  #
  #   IF tm.wc[i,i+4] = 'aba00' THEN
  #      LET tm.wc[i,i+4]='aao00'
  #   END IF
  #END FOR
  #-MOD-A80152-end-
   CALL cl_replace_str(tm.wc,"aag01","aao01") RETURNING tm.wc      #MOD-A80152
   CALL cl_replace_str(tm.wc,"abb05","aao02") RETURNING tm.wc      #MOD-A80152
   CALL cl_replace_str(tm.wc,"aba00","aao00") RETURNING tm.wc      #MOD-A80152
 
   LET l_sql = "SELECT aag01,aag02,aag13,aao02,SUM(aao05-aao06)",  #FUN-6C0012
               "  FROM aag_file LEFT OUTER JOIN aao_file ON aag_file.aag01 = aao_file.aao01 AND aag_file.aag00 = aao_file.aao00 ",
               " WHERE aao00='",g_bookno,"'",
               "   AND aao03=",tm.yy1,
               "   AND aao04<",tm.m1,
               "   AND ",tm.wc CLIPPED,
 
 
               " GROUP BY aag01,aag02,aag13,aao02 ",  #FUN-6C0012
               " HAVING SUM(aao05-aao06)!=0"
 
   PREPARE aglr159_prepare2 FROM l_sql                                        
   IF STATUS THEN                                                             
      CALL cl_err('aglr159_prepare2',STATUS,0)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   DECLARE aglr159_curs2 CURSOR FOR aglr159_prepare2
 
   INITIALIZE sr.* TO NULL
   LET sr.amt_d = 0
   LET sr.amt_c = 0
 
   FOREACH aglr159_curs2 INTO sr.aag01,sr.aag02,sr.aag13,sr.abb05  #FUN-6C0012
 
     #OUTPUT TO REPORT aglr159_rep(sr.*)   #No.FUN-760083
     EXECUTE insert_prep  USING sr.aag01,sr.aba00,sr.aba01,sr.aba14,     #No.FUN-760083
                                sr.aba02,sr.abb02,sr.abb03,sr.aag02,     #No.FUN-760083
                                sr.aag13,sr.abb04,sr.abb05,sr.abb06,     #No.FUN-760083
                                sr.abb07,sr.abb11,sr.amt_d,sr.amt_c     #No.FUN-760083
                              
                                                                 
   END FOREACH
 
   #FINISH REPORT aglr159_rep   #No.FUN-760083
 
   #CALL cl_prt(l_name,g_prtway,g_copies,g_len)   #No.FUN-760083
#No.FUN-760083  --begin--
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   PREPARE aglr159_prepare3 FROM g_sql 
   IF STATUS THEN                                                                                                                   
      CALL cl_err('aglr159_prepare3',STATUS,0)                                                                                      
      CALL cl_used(g_prog,g_time,2) RETURNING g_time                                                             
      EXIT PROGRAM                                                                                                                  
   END IF                                                                                                                           
   DECLARE aglr159_curs3 CURSOR FOR aglr159_prepare3
 
   FOREACH aglr159_curs3 INTO sr.*
      SELECT COUNT(*) INTO s_count                                                                                               
           FROM aba_file, abb_file                                                                                                  
          WHERE aba00 = abb00                                                                                                       
            AND aba01 = abb01                                                                                                       
#            AND aba00 = g_bookno     #No.FUN-740020     #No.TQC-740093                                                             
            AND abaacti='Y' 
            AND aba19 <> 'X'   #CHI-C80041            
            AND aba02 >= s_date                                                                                                     
            AND aba02 <= e_date                                                                                                     
            AND abb03 = sr.aag01                                                                                                    
                                                                                                                                    
         IF s_count IS NULL THEN                                                                                                    
            LET s_count = 0                                                                                                         
         END IF                                                                                                                     
                                                                                                                                    
         SELECT SUM(aao05-aao06) INTO l_begin FROM aao_file                                                                         
          WHERE aao00=g_bookno                                                                                                      
            AND aao01=sr.aag01                                                                                                      
            AND aao02=sr.abb05                                                                                                      
            AND aao03=tm.yy1                                                                                                        
            AND aao04<tm.m1                                                                                                         
         IF STATUS OR l_begin IS NULL THEN 
            LET l_begin = 0                                                                                                         
         END IF                                                                                                                     
         LET l_gem02 = ''  #MOD-880020 modify by liuxqa                                                                                                                           
         IF NOT(s_count = 0 and l_begin = 0) THEN                                                                                   
            SELECT gem02 INTO l_gem02 FROM gem_file                                                                                 
             WHERE gem01 = sr.abb05 
         END IF 
      EXECUTE insert_prep1 USING  sr.aag01,sr.aba00,sr.aba01,sr.aba14,
                                  sr.aba02,sr.abb02,sr.abb03,sr.aag02,
                                  sr.aag13,sr.abb04,sr.abb05,sr.abb06,
                                  sr.abb07,sr.abb11,sr.amt_d,sr.amt_c,
                                  l_begin,s_count,l_gem02
   END FOREACH
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1  CLIPPED
   IF g_zz05 ='Y' THEN
     CALL cl_wcchp(tm.wc,'aag01,abb05,aba00') 
     RETURNING  tm.wc
   END IF
   LET g_str=tm.wc,';',tm.yy1,';',tm.m1,';',tm.yy2,';',tm.m2,';',tm.e,';',t_azi05
   CALL cl_prt_cs3("aglr159","aglr159",g_sql,g_str)
#No.FUN-760083  --end--
END FUNCTION
 
#No.FUN-760083 --begin--
{
REPORT aglr159_rep(sr)
  DEFINE l_begin       LIKE abb_file.abb07
  DEFINE l_last_sw     LIKE type_file.chr1,    #No.FUN-680098     VARCHAR(1)
         sr             RECORD 
                           aag01     like aag_file.aag01,#科目編號
                           aba00     LIKE aba_file.aba00,#帳別
                           aba01     LIKE aba_file.aba01,#傳票編號
                           aba14     LIKE aba_file.aba14,#傳票編號
                           aba02     LIKE aba_file.aba02,#傳票日期
                           abb02     LIKE abb_file.abb02,#Seq
                           abb03     LIKE abb_file.abb03,#科目
                           aag02     LIKE aag_file.aag02,#科目名稱
                           aag13     LIKE aag_file.aag13,#額外名稱 #FUN-6C0012
                           abb04     LIKE abb_file.abb04,#摘要  
                           abb05     LIKE abb_file.abb05,#部門
                           abb06     LIKE abb_file.abb06,#借貸別 
                           abb07     LIKE abb_file.abb07,#異動金額
                           abb11     LIKE abb_file.abb11,#異動碼-1
                           amt_d     LIKE abb_file.abb07,
                           amt_c     LIKE abb_file.abb07
                        END RECORD
  DEFINE t_amt_c,t_amt_d LIKE abb_file.abb07
  DEFINE s_count LIKE type_file.num5      #No.FUN-680098     SMALLINT
  DEFINE g_head1 STRING   
  DEFINE l_gem02 LIKE gem_file.gem02
 
   OUTPUT 
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin 
      BOTTOM MARGIN g_bottom_margin 
      PAGE LENGTH g_page_line
 
   ORDER BY sr.aag01,sr.abb05,sr.aba02,sr.aba14
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         LET g_head1 = g_x[10] CLIPPED,tm.yy1 USING '&&&&',
                       g_x[11] CLIPPED,tm.m1 USING '&&',' ',
                       g_x[12] CLIPPED,tm.yy2 USING '&&&&',
                       g_x[11] CLIPPED,tm.m2 USING '&&'
         #PRINT g_head1                                         #FUN-660060 remark      
         PRINT COLUMN ((g_len-FGL_WIDTH(g_head1))/2)+1, g_head1 #FUN-660060
         PRINT g_dash[1,g_len]
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
         PRINT g_dash1
         LET l_last_sw = 'n'
 
      BEFORE GROUP OF sr.abb05
         LET l_gem02 = ''
         LET s_count = 0
         SELECT COUNT(*) INTO s_count 
           FROM aba_file, abb_file
          WHERE aba00 = abb00
            AND aba01 = abb01
#            AND aba00 = g_bookno     #No.FUN-740020     #No.TQC-740093
            AND abaacti='Y'
            AND aba02 >= s_date
            AND aba02 <= e_date
            AND abb03 = sr.aag01
 
         IF s_count IS NULL THEN
            LET s_count = 0
         END IF
        
         SELECT SUM(aao05-aao06) INTO l_begin FROM aao_file
          WHERE aao00=g_bookno
            AND aao01=sr.aag01
            AND aao02=sr.abb05
            AND aao03=tm.yy1
            AND aao04<tm.m1
         IF STATUS OR l_begin IS NULL THEN
            LET l_begin = 0
         END IF
         
         IF NOT(s_count = 0 and l_begin = 0) THEN
            SELECT gem02 INTO l_gem02 FROM gem_file
             WHERE gem01 = sr.abb05
            #FUN-6C0012....begin
            IF tm.e = 'Y' THEN
               PRINT COLUMN g_c[31],g_x[16],
                     COLUMN g_c[32],sr.aag01,
                     COLUMN g_c[33],sr.aag13,
                     COLUMN g_c[35],g_x[17],sr.abb05,   
                     COLUMN g_c[36],l_gem02
            ELSE
            #FUN-6C0012.....end
               PRINT COLUMN g_c[31],g_x[16],
                     COLUMN g_c[32],sr.aag01,
                     COLUMN g_c[33],sr.aag02,
                     #FUN-6C0012....begin
#                    COLUMN g_c[34],g_x[17],      
#                    COLUMN g_c[35],sr.abb05,     
                     COLUMN g_c[35],g_x[17],sr.abb05,
                     #FUN-6C0012.....end
                     COLUMN g_c[36],l_gem02
            END IF     #FUN-6C0012
            PRINT
         END IF
     
      ON EVERY ROW
         IF sr.aba02 IS NOT NULL THEN
            #PRINT COLUMN g_c[31],sr.aba02 USING "yy/mm/dd", #FUN-570250 mark
            PRINT COLUMN g_c[31],sr.aba02, #FUN-570250 add
                  COLUMN g_c[32],sr.aba01,
                  COLUMN g_c[33],cl_numfor(sr.amt_d,33,t_azi05),     #No.CHI-6A0004 g_azi-->t_azi 
                  COLUMN g_c[34],cl_numfor(sr.amt_c,34,t_azi05),     #No.CHI-6A0004 g_azi-->t_azi 
                  COLUMN g_c[35],sr.abb11,
                  COLUMN g_c[36],sr.abb04 
         END IF
     
      AFTER GROUP OF sr.abb05
         IF NOT(s_count = 0 AND l_begin = 0) THEN
            PRINT
         END IF
 
         IF GROUP SUM(sr.amt_d) IS NULL THEN
            LET t_amt_d = 0
         ELSE
            LET t_amt_d = GROUP SUM(sr.amt_d)
         END IF
 
         IF GROUP SUM(sr.amt_c) IS NULL THEN
            LET t_amt_c = 0
         ELSE
            LET t_amt_c = GROUP SUM(sr.amt_c)
         END IF
 
         IF NOT(s_count = 0 and l_begin = 0) THEN
            PRINT COLUMN g_c[31],g_x[13] CLIPPED,
    #            COLUMN g_c[32],cl_numfor(l_begin,33,t_azi05),       #No.CHI-6A0004 g_azi-->t_azi 
                 COLUMN g_c[32],cl_numfor(l_begin,32,t_azi05),       #No.CHI-6A0004 g_azi-->t_azi #NO.FUN-6B0022 
                 COLUMN g_c[33],cl_numfor(t_amt_d,33,t_azi05),       #No.CHI-6A0004 g_azi-->t_azi 
                 COLUMN g_c[34],cl_numfor(t_amt_c,34,t_azi05),       #No.CHI-6A0004 g_azi-->t_azi 
                 COLUMN g_c[35],g_x[14] CLIPPED,
    #            COLUMN g_c[36],cl_numfor(l_begin+t_amt_d-t_amt_c,34,t_azi05)     #No.CHI-6A0004 g_azi-->t_azi 
                 COLUMN g_c[36],cl_numfor(l_begin+t_amt_d-t_amt_c,36,t_azi05)     #No.CHI-6A0004 g_azi-->t_azi #NO.FUN-6B0022
           PRINT g_dash2 
            SKIP 2 LINES
            LET t_l_begin = t_l_begin + l_begin
            LET t_t_amt_d = t_t_amt_d + t_amt_d
            LET t_t_amt_c = t_t_amt_c + t_amt_c
         END IF
 
      ON LAST ROW
         PRINT COLUMN g_c[31],g_x[15]  
         PRINT COLUMN g_c[31],g_x[13] CLIPPED,
  #          COLUMN g_c[32],cl_numfor(t_l_begin,33,t_azi05),    #No.CHI-6A0004 g_azi-->t_azi #NO.FUN-6B0022
             COLUMN g_c[32],cl_numfor(t_l_begin,32,t_azi05),    #No.CHI-6A0004 g_azi-->t_azi #NO.FUN-6B0022
             COLUMN g_c[33],cl_numfor(t_t_amt_d,33,t_azi05),    #No.CHI-6A0004 g_azi-->t_azi 
             COLUMN g_c[34],cl_numfor(t_t_amt_c,34,t_azi05),    #No.CHI-6A0004 g_azi-->t_azi 
             COLUMN g_c[35],g_x[14] CLIPPED,
  #          COLUMN g_c[36],cl_numfor(t_l_begin+t_t_amt_d-t_t_amt_c,34,t_azi05)    #No.CHI-6A0004 g_azi-->t_azi 
             COLUMN g_c[36],cl_numfor(t_l_begin+t_t_amt_d-t_t_amt_c,36,t_azi05)    #No.CHI-6A0004 g_azi-->t_azi
         PRINT g_dash 
         LET l_last_sw = 'y'
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED         #No.TQC-6B0093
     
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED         #No.TQC-6B0093
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT
}
#No.FUN-760083  --end--
