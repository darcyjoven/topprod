# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aglg182.4gl
# Descriptions...: 部門全年度實際預算比較報表列印
# Date & Author..: 96/09/05 By Melody
# Modify.........: No.FUN-510007 05/02/02 By Nicola 報表架構修改
# Modify.........: No.MOD-5A0313 05/10/27 By Nicola 有做"預算控管"才列印
# Modify.........: No.TQC-630238 06/03/28 By Smapmin 增加afbacti='Y'的判斷
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-660147 06/06/27 By Smapmin 修改部門輸入限制
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680098 06/08/31 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6C0012 06/12/26 By Judy 新增額外名稱列印欄位
# Modify.........: No.FUN-740020 07/04/12 By Lynn 會計科目加帳套
# Modify.........: No.TQC-740093 07/04/18 By johnray 未加帳套限制
# Modify.........: No.TQC-740145 07/04/22 By johnray bookno未定義
# Modify.........: No.MOD-740221 07/04/25 By kim 補過單
# Modify.........: No.FUN-780060 07/08/30 By destiny 報表格式改為CR輸出
# Modify.........: NO.FUN-810069 08/02/28 By destiny 取消預算編號改為預算項目
# Modify.........: No.FUN-830139 08/04/07 By bnlent 去掉預算項目字段
# Modify.........: No.TQC-950103 09/06/05 By chenmoyan 將零時表中的merge字段名稱改掉
 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9C0100 09/12/24 By sabrina 無法顯示出預算金額 
# Modify.........: No:FUN-AB0020 10/11/08 By lixh1   增加預算編號(afc01)欄位
# Modify.........: No.FUN-B20054 11/02/23 By lixiang 先錄入帳套,科目根據帳套過濾;結構改為DIALOG
# Modify.........: No.FUN-B80161 11/09/02 By chenying 明細類報表轉GR
# Modify.........: No.FUN-C30178 12/03/14 By yangtt GR調整      
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
                 wc           LIKE type_file.chr1000,  #No.FUN-680098     VARCHAR(200)
                 bdept,edept   LIKE gem_file.gem01,    #No.FUN-680098     VARCHAR(6) 
                 defyy         LIKE type_file.num5,    #輸入基準年度 #No.FUN-680098  SMALLINT  
                 defmm         LIKE type_file.num5,    #輸入基準月份 #No.FUN-680098  SMALLINT  
                 comyy         LIKE type_file.num5,    #輸入比較年度 #No.FUN-680098  SMALLINT  
                 commm         LIKE type_file.num5,    #輸入比較月份 #No.FUN-680098  SMALLINT 
                 afc01         LIKE afc_file.afc01,    #輸入預算項目 #N0.FUN-AB0020 
                 merge         LIKE type_file.chr1,    #部門合併否   #No.FUN-680098  VARCHAR(1) 
                 #budget        LIKE afa_file.afa01,    #預算編號     #No.FUN-680098  VARCHAR(4) #No.FUN-830139 
                 zero_sw       LIKE type_file.chr1,    #金額為零者是否列印 #No.FUN-680098   VARCHAR(1)
                 c             LIKE type_file.chr1,    #列印額外名稱 #FUN-6C0012
                 more          LIKE type_file.chr1,    #Input more condition(Y/N)#No.FUN-680098  VARCHAR(1) 
                 bookno  LIKE aah_file.aah00  #帳別    #No.TQC-740093
              END RECORD,
#          bookno  LIKE aah_file.aah00, #帳別    #No.FUN-740020   #No.TQC-740093
          g_tot     ARRAY[5] OF LIKE type_file.num20_6,     #No.FUN-680098  dec(20,6)     
          g_change  ARRAY[5] OF LIKE type_file.num20_6,     #No.FUN-680098  dec(20,6)  
          t_tot1,t_tot2,t_tot3,t_tot4,t_tot5                LIKE aao_file.aao05,
          t_change1,t_change2,t_change3,t_change4,t_change5 LIKE aao_file.aao05,
          t_fix1,t_fix2,t_fix3,t_fix4,t_fix5                LIKE aao_file.aao05,
          t_other1,t_other2,t_other3,t_other4,t_other5      LIKE aao_file.aao05,
          g_fix     ARRAY[5] OF LIKE type_file.num20_6,    #No.FUN-680098 dec(20,6)   
          g_other   ARRAY[5] OF LIKE type_file.num20_6     #No.FUN-680098 dec(20,6)   
   DEFINE g_i       LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098  SMALLINT
#No.FUN-780060--start--add                                                                                                          
   DEFINE g_sql       STRING                                                                                                        
   DEFINE g_sql1      STRING                                                                                                        
   DEFINE l_table     STRING                                                                                                        
   DEFINE g_str       STRING                                                                                                        
#No.FUN-780060--end-- 
###GENGRE###START
TYPE sr1_t RECORD
    aao00 LIKE aao_file.aao00,
    aao01 LIKE aao_file.aao01,
    aao02 LIKE aao_file.aao02,
    aao03 LIKE aao_file.aao03,
    aao04 LIKE aao_file.aao04,
    aag13 LIKE aag_file.aag13,
    aag221 LIKE aag_file.aag221,
    defcharge LIKE aao_file.aao05,
    defcharge_1 LIKE aao_file.aao05,
    merge_2 LIKE aao_file.aao05,
    merge_1 LIKE aao_file.aao05,
    lastcharge LIKE aao_file.aao05,
    lastcharge_1 LIKE aao_file.aao05,
    l_gem02 LIKE gem_file.gem02
END RECORD
###GENGRE###END

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
             "aao02.aao_file.aao02,",                                                                                             
             "aao03.aao_file.aao03,",                                                                                             
             "aao04.aao_file.aao04,",                                                                                             
             "aag13.aag_file.aag13,",                                                                                             
             "aag221.aag_file.aag221,",                                                                                             
             "defcharge.aao_file.aao05,",                                                                                                
             "defcharge_1.aao_file.aao05,",                                                                                                
#            "merge.aao_file.aao05,",       #TQC-950103                                                                                             
             "merge_2.aao_file.aao05,",     #TQC-950103                                                                                           
             "merge_1.aao_file.aao05,",                                                                                                
             "lastcharge.aao_file.aao05,",                                                                                                
             "lastcharge_1.aao_file.aao05,",                                                                                                
             "l_gem02.gem_file.gem02"                                                                                             
   LET l_table = cl_prt_temptable('aglg182',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80161 add
      CALL cl_gre_drop_temptable(l_table)               #FUN-B80161 add
      EXIT PROGRAM 
   END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?)"                                                                                             
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80161 add
      CALL cl_gre_drop_temptable(l_table)               #FUN-B80161 add
      EXIT PROGRAM                                                                             
   END IF                                                                                                                           
#No.FUN-780060--end--add 
#  LET bookno  = ARG_VAL(1)    #No.FUN-740020
   LET tm.bookno    = ARG_VAL(1)  #No.TQC-740093
   LET g_pdate   = ARG_VAL(2)       # Get arguments from command line
   LET g_towhom  = ARG_VAL(3)
   LET g_rlang   = ARG_VAL(4)
   LET g_bgjob   = ARG_VAL(5)
   LET g_prtway  = ARG_VAL(6)
   LET g_copies  = ARG_VAL(7)
   LET tm.wc     = ARG_VAL(8)
   LET tm.bdept  = ARG_VAL(9)   #TQC-610056
   LET tm.edept  = ARG_VAL(10)  #TQC-610056
   LET tm.defyy  = ARG_VAL(11)
   LET tm.defmm  = ARG_VAL(12)
   LET tm.comyy  = ARG_VAL(13)
   LET tm.commm  = ARG_VAL(14)
   LET tm.merge  = ARG_VAL(15)
   LET tm.zero_sw= ARG_VAL(16)
   LET tm.afc01  =  ARG_VAL(17)  #FUN-AB0020
   #LET tm.budget = ARG_VAL(17) #No.FUN-830139
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(18)
   LET g_rep_clas = ARG_VAL(19)
   LET g_template = ARG_VAL(20)
   #No.FUN-570264 ---end---
   LET tm.c = ARG_VAL(21)   #FUN-6C0012
   LET g_rpt_name = ARG_VAL(22)  #No.FUN-7C0078
 
   LET t_tot1 = 0
   LET t_tot2 = 0
   LET t_tot3 = 0
   LET t_tot4 = 0
   LET t_tot5 = 0
   LET t_change1 = 0
   LET t_change2 = 0
   LET t_change3 = 0
   LET t_change4 = 0
   LET t_change5 = 0
   LET t_fix1 = 0
   LET t_fix2 = 0
   LET t_fix3 = 0
   LET t_fix4 = 0
   LET t_fix5 = 0
   LET t_other1 = 0
   LET t_other2 = 0
   LET t_other3 = 0
   LET t_other4 = 0
   LET t_other5 = 0
 
#  IF cl_null(bookno) THEN   #No.FUN-740020
#     LET bookno = g_aza.aza81   #No.FUN-740020
#  END IF
   IF cl_null(tm.bookno) THEN LET tm.bookno = g_aza.aza81 END IF         #No.TQC-740093
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL g182_tm()
   ELSE
      CALL g182()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
   CALL cl_gre_drop_temptable(l_table)               #FUN-B80161 add
END MAIN
 
FUNCTION g182_tm()
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-680098 smallint
          l_sw           LIKE type_file.chr1,    #重要欄位是否空白  #No.FUN-680098  VARCHAR(1)
          l_cmd          LIKE type_file.chr1000   #No.FUN-680098    VARCHAR(400)
   DEFINE l_azfacti      LIKE azf_file.azfacti    #FUN-AB0020
   DEFINE li_chk_bookno LIKE type_file.num5   #FUN-B20054
   
#   CALL s_dsmark(bookno)   #No.FUN-740020
   CALL s_dsmark(tm.bookno)   #No.TQC-740093
   LET p_row = 3 LET p_col = 30
   OPEN WINDOW g182_w AT p_row,p_col
     WITH FORM "agl/42f/aglg182"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
# Prog. Version..: '5.30.06-13.03.12(0,0,bookno)    #No.FUN-740020
   CALL s_shwact(0,0,tm.bookno)     #No.TQC-740093
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.bookno= g_aza.aza81   #No.TQC-740093
   LET tm.defyy = YEAR(g_today)
   LET tm.defmm = MONTH(g_today)
   LET tm.zero_sw = 'Y'
   LET tm.merge = 'N'
   LET tm.c     = 'N'   #FUN-6C0012
   LET tm.more  = 'N'
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
    #FUN-B20054--add--str--
    LET l_sw = 1
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
#         CLOSE WINDOW aglg182_w
#         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#         EXIT PROGRAM
#      END IF
# 
#      LET l_sw = 1
#FUN-B20054--mark--end
 
#      INPUT BY NAME bookno,tm.bdept,tm.edept,tm.defyy,tm.defmm,tm.comyy,tm.commm,    #No.FUN-740020   #No.TQC-740093
#      INPUT BY NAME tm.bookno,tm.bdept,tm.edept,tm.defyy,tm.defmm,tm.comyy,tm.commm,tm.afc01,   #No.TQC-740093  #FUN-AB0020 add tm.afc01
#                    tm.merge,tm.zero_sw,tm.c,tm.more WITHOUT DEFAULTS       #FUN-6C0012 #No.FUN-830139 去掉tm.budget  #FUN-B20054
       INPUT BY NAME tm.bdept,tm.edept,tm.defyy,tm.defmm,tm.comyy,tm.commm,tm.afc01,
                     tm.merge,tm.zero_sw,tm.c,tm.more
                     ATTRIBUTE(WITHOUT DEFAULTS)  #FUN-B20054
                     
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
#FUN-B20054--mark--str-- 
#
#         #No.FUN-740020 --begin                                                                                                     
#         AFTER FIELD bookno                                                                                                         
#       #     IF cl_null(bookno) THEN     #No.TQC-740093
#            IF cl_null(tm.bookno) THEN     #No.TQC-740093
#               NEXT FIELD bookno                                                                                                    
#            END IF                                                                                                                  
#         #No.FUN-740020 --end
#FUN-B20054--mark--end 
 
         AFTER FIELD bdept
            IF cl_null(tm.bdept) THEN
               NEXT FIELD bdept
            END IF
 
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
 
         AFTER FIELD defmm
            IF tm.defmm IS NULL OR tm.defmm <= 0 OR tm.defmm >13 THEN
               NEXT FIELD defmm
            END IF
 
         AFTER FIELD comyy
            IF tm.comyy IS NULL THEN
               NEXT FIELD comyy
            END IF
 
         AFTER FIELD commm
            IF tm.commm IS NULL OR tm.commm <= 0 OR tm.commm > 12 THEN
               NEXT FIELD commm
            END IF

#FUN-AB0020 --------------------Begin----------------------------  
         AFTER FIELD afc01
            IF NOT cl_null(tm.afc01) THEN
               SELECT azf01 FROM azf_file
                WHERE azf01 = tm.afc01  AND azf02 = '2'
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","azf_file",tm.afc01,"","agl-005","","",0)
                  NEXT FIELD afc01
               ELSE
                  SELECT azfacti INTO l_azfacti FROM azf_file
                   WHERE azf01 = tm.afc01 AND azf02 = '2'
                  IF l_azfacti = 'N' THEN
                     CALL cl_err(tm.afc01,'agl1002',0)
                  END IF
               END IF
            END IF                 
#FUN-AB0020 --------------------End------------------------------                     
 
         AFTER FIELD merge
            IF tm.merge NOT MATCHES '[YN]' THEN
               NEXT FIELD merge
            END IF
 
         AFTER FIELD zero_sw
            IF tm.zero_sw NOT MATCHES '[YN]' OR tm.zero_sw IS NULL THEN
               NEXT FIELD zero_sw
            END IF
 
         #No.FUN-830139 ...begin
         #AFTER FIELD budget
         #   SELECT * FROM afa_file
         #    WHERE afa01 = tm.budget
         #      AND afaacti IN ('Y','y')
         #      AND afa00 = tm.bookno               #No.TQC-740093
         #   IF STATUS THEN
#        #      CALL cl_err('sel afa:',STATUS,0)   #No.FUN-660123
         #      CALL cl_err3("sel","afa_file",tm.budget,"",STATUS,"","sel afa:",0)   #No.FUN-660123
         #      NEXT FIELD budget
         #   END IF
         #No.FUN-830139 ...end
 
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
         #FUN-B20054--mark--end-

            IF tm.defyy IS NULL THEN
               LET l_sw = 0
               DISPLAY BY NAME tm.defyy
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
#         ON ACTION CONTROLP
#         #No.FUN-740020  --Begin                                                                                                    
#          CASE                                                                                                                      
#            WHEN INFIELD(bookno)                                                                                                    
#              CALL cl_init_qry_var()                                                                                                
#              LET g_qryparam.form = 'q_aaa'                                                                                         
#              LET g_qryparam.default1 = tm.bookno       #No.TQC-740145
#              CALL cl_create_qry() RETURNING tm.bookno                
#              DISPLAY BY NAME tm.bookno 
#              NEXT FIELD bookno    
#     #FUN-AB0020 --------------Begin--------------------
#            WHEN INFIELD(afc01)
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = 'q_azf'    
#                LET g_qryparam.default1 = tm.afc01
#                LET g_qryparam.arg1 = '2'        
#                CALL cl_create_qry() RETURNING tm.afc01
#                DISPLAY BY NAME tm.afc01
#                NEXT FIELD afc01
#    #FUN-AB0020 ---------------End---------------------                            
#         #No.FUN-740020  --End
#         #No.FUN-830139 ...begin
#         #   WHEN INFIELD(budget)
#         #      CALL cl_init_qry_var()
#        #      LET g_qryparam.form = 'q_afa'        #No.FUN-810069    
#         #      LET g_qryparam.form = 'q_azf'        #No.FUN-810069    
#         #      LET g_qryparam.default1 = tm.budget
#         #      LET g_qryparam.arg1 ='2'             #No.FUN-810069
#        #      LET g_qryparam.arg1 = tm.bookno      #No.FUN-740020  #No.FUN-810069
#         #      CALL cl_create_qry() RETURNING tm.budget
#         #      DISPLAY BY NAME tm.budget
#         #      NEXT FIELD budget
#         #No.FUN-830139 ...begin
#         END CASE
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
              LET g_qryparam.default1 = tm.bookno       #No.TQC-740145
              CALL cl_create_qry() RETURNING tm.bookno                
              DISPLAY BY NAME tm.bookno 
              NEXT FIELD bookno
           WHEN INFIELD(aag01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag02"
                LET g_qryparam.state = "c"
                LET g_qryparam.where = " aag00 = '",tm.bookno CLIPPED,"'"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO aag01
                NEXT FIELD aag01    
#FUN-AB0020 --------------Begin--------------------
            WHEN INFIELD(afc01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_azf'    
                LET g_qryparam.default1 = tm.afc01
                LET g_qryparam.arg1 = '2'        
                CALL cl_create_qry() RETURNING tm.afc01
                DISPLAY BY NAME tm.afc01
                NEXT FIELD afc01
#FUN-AB0020 ---------------End---------------------                            
         #No.FUN-740020  --End
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
       CLOSE WINDOW g182_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
       CALL cl_gre_drop_temptable(l_table)               #FUN-B80161 add
       EXIT PROGRAM
    END IF

    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup') #FUN-980030
   
  #FUN-B20054--add--end 
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aglg182'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglg182','9031',1)   
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",tm.bookno CLIPPED,"'" ,     #No.FUN-740020
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
                        " '",tm.defmm CLIPPED,"'",
                        " '",tm.comyy CLIPPED,"'",
                        " '",tm.commm CLIPPED,"'",
                        " '",tm.afc01 CLIPPED,"'",   #FUN-AB0020                     
                        " '",tm.merge CLIPPED,"'",
                        " '",tm.zero_sw CLIPPED,"'",
                        " '",tm.c     CLIPPED,"'",       #FUN-6C0012
                        #" '",tm.budget CLIPPED,"'",     #No.FUN-830139 
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aglg182',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW g182_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         CALL cl_gre_drop_temptable(l_table)               #FUN-B80161 add
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL g182()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW g182_w
 
END FUNCTION
 
FUNCTION g182()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name      #No.FUN-680098   VARCHAR(20) 
#       l_time          LIKE type_file.chr8        #No.FUN-6A0073
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT               #No.FUN-680098   VARCHAR(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-680098   VARCHAR(1)
          l_gem01   LIKE gem_file.gem01,
          l_aag01   LIKE aag_file.aag01,
          l_aag02   LIKE aag_file.aag02,
          l_aag13   LIKE aag_file.aag13,  #FUN-6C0012
          l_aag221  LIKE aag_file.aag221,
          l_aao05   LIKE aao_file.aao05,
          l_aao06   LIKE aao_file.aao06,
          sr        RECORD
                       aao  RECORD LIKE aao_file.*,
                       aag02       LIKE aag_file.aag02,   #科目名稱
                       aag13       LIKE aag_file.aag13,   #額外名稱 #FUN-6C0012
                       aag221      LIKE aag_file.aag221,  #科目分類碼一
                       defcharge   LIKE aao_file.aao05,   #(1)基準:實際費用
                       merge       LIKE aao_file.aao05,   #(2)基準:預算
                       lastcharge  LIKE aao_file.aao05,   #(3)比較:上月實際費用
                       diff1       LIKE aao_file.aao05,   #差異1-2
                       diff2       LIKE aao_file.aao05    #差異1-3
                    END RECORD
#No.FUN-780060--start--add
   DEFINE l_tit1    LIKE type_file.chr1000                                               
   DEFINE l_tit2    LIKE type_file.chr1000 
   DEFINE l_gem02   LIKE gem_file.gem02                          
#No.FUN-780060--end--
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog       #No.FUN-780060
   CALL cl_del_data(l_table)                                      #No.FUN-780060
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #-->取科目
   LET l_sql = "SELECT aag01,aag02,aag13,aag221  FROM aag_file",  #FUN-6C0012
               " WHERE aagacti = 'Y' ",
               "   AND aag03 = '2' AND aag07 IN ('2','3') ",
               "   AND aag21 = 'Y'",   #No.MOD-5A0313
               "   AND aag00 = '",tm.bookno,"'",    #No.FUN-740020
               "   AND ",tm.wc CLIPPED
 
   PREPARE g182_paag FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare:',STATUS,1)   
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)               #FUN-B80161 add
      EXIT PROGRAM
   END IF
   DECLARE g182_caag CURSOR FOR g182_paag
 
   #-->取部門
   LET l_sql = "SELECT gem01 FROM gem_file",
               " WHERE gemacti = 'Y' ",
               "   AND (gem01 BETWEEN '",tm.bdept,"' AND '" ,tm.edept,"')"
 
   PREPARE g182_pgem FROM l_sql
   IF STATUS THEN
      CALL cl_err('pre gem:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)               #FUN-B80161 add
      EXIT PROGRAM
   END IF
   DECLARE g182_cgem CURSOR FOR g182_pgem
 
   LET l_sql = "SELECT aao_file.*,' ',' ',0,0,0,0,0 ",  
               "  FROM aao_file ",
               " WHERE aao01=?  AND aao02=? ",
               "   AND aao03=",tm.defyy," AND aao04=",tm.defmm,
               "   AND aao00='",tm.bookno,"'" #no.7277    #No.FUN-740020
 
   PREPARE g182_paao FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare aao:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)               #FUN-B80161 add
      EXIT PROGRAM
   END IF
   DECLARE g182_caao CURSOR FOR g182_paao
 
#  CALL cl_outnam('aglg182') RETURNING l_name               #No.FUN-780060
#  START REPORT aglg182_rep TO l_name                       #No.FUN-780060  
 
#  LET g_pageno = 0                                         #No.FUN-780060
 
   FOREACH g182_caag INTO l_aag01,l_aag02,l_aag13,l_aag221  #FUN-6C0012
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      FOREACH g182_cgem INTO l_gem01
         INITIALIZE sr.* TO NULL            # Default condition
         #-->取基準月份
         OPEN g182_caao USING l_aag01,l_gem01
         FETCH g182_caao INTO sr.*
         IF STATUS THEN  #No.7926
            LET sr.aao.aao00 = tm.bookno    #No.FUN-740020
            LET sr.aao.aao01 = l_aag01
            LET sr.aao.aao02 = l_gem01
            LET sr.aao.aao03 = tm.defyy
            LET sr.aao.aao04 = tm.defmm
            LET sr.aao.aao05 = 0
            LET sr.aao.aao06 = 0
            LET sr.aao.aao07 = 0
            LET sr.aao.aao08 = 0
            LET sr.defcharge = 0
            LET sr.merge = 0
            LET sr.lastcharge = 0
            LET sr.diff1 = 0
            LET sr.diff2 = 0
         END IF
 
         LET sr.aag02 = l_aag02
         LET sr.aag13 = l_aag13   #FUN-6C0012
         LET sr.aag221 = l_aag221
 
         IF sr.aao.aao05 IS NULL THEN
            LET sr.aao.aao05 = 0
         END IF
 
         IF sr.aao.aao06 IS NULL THEN
            LET sr.aao.aao06 = 0
         END IF
 
         #-->抓基準:  預算
#FUN-AB0020 --------------------Begin--------------         
         IF NOT cl_null(tm.afc01) THEN
            SELECT afc06 INTO sr.merge
              FROM afb_file,afc_file
             WHERE afb02 = sr.aao.aao01 
               AND afb03 = tm.defyy
               AND afb041 = sr.aao.aao02  
               AND afb00 = afc00
               AND afb01 = afc01
               AND afb02 = afc02
               AND afb03 = afc03
               AND afb04 = afc04
               AND afb041=afc041                     
               AND afb042=afc042                     
               AND afc05 = tm.defmm
               AND afb00 = tm.bookno     
               AND afbacti = 'Y'  
               AND afc01 = tm.afc01 
         ELSE   
#FUN-AB0020 --------------------End----------------            
            SELECT afc06 INTO sr.merge
            FROM afb_file,afc_file
            #WHERE afb01 = tm.budget   #No.FUN-830139
            WHERE afb02 = sr.aao.aao01 #No.FUN-830139
              AND afb03 = tm.defyy
              AND afb041 = sr.aao.aao02     #MOD-9C0100 afb04 modify afb041
             #AND afb15 = '2'               #MOD-9C0100 mark
              AND afb00 = afc00
              AND afb01 = afc01
              AND afb02 = afc02
              AND afb03 = afc03
              AND afb04 = afc04
              AND afb041=afc041                     #No.FUN-810069--add    
              AND afb042=afc042                     #No.FUN-810069--add
              AND afc05 = tm.defmm
              AND afb00 = tm.bookno     #no.7277    #No.FUN-740020
              AND afbacti = 'Y'   #TQC-630238
         END IF     #FUN-AB0020
         IF sr.merge IS NULL THEN
            LET sr.merge = 0
         END IF
 
         #-->抓比較:  實際費用
         LET l_aao05 = 0
         LET l_aao06 = 0
 
         SELECT aao05,aao06 INTO l_aao05,l_aao06
           FROM aao_file
          WHERE aao01 = sr.aao.aao01
            AND aao02 = sr.aao.aao02
            AND aao03 = tm.comyy
            AND aao04 = tm.commm
            AND aao00 = tm.bookno     #no.7277    #No.FUN-740020
 
         IF l_aao05 IS NULL THEN
            LET l_aao05 = 0
         END IF
 
         IF l_aao06 IS NULL THEN
            LET l_aao06 = 0
         END IF
 
         LET sr.lastcharge = l_aao05 - l_aao06              #(3)比較:上月實際費用
         LET sr.defcharge = sr.aao.aao05 - sr.aao.aao06     #(1)基準:實際費用
         LET sr.diff1 = sr.defcharge - sr.merge           #差異1-2
         LET sr.diff2 = sr.defcharge - sr.lastcharge      #差異1-3
 
         IF sr.lastcharge IS NULL THEN
            LET sr.lastcharge = 0
         END IF
 
         IF sr.defcharge IS NULL THEN
            LET sr.defcharge = 0
         END IF
 
         IF sr.diff1 IS NULL THEN
            LET sr.diff1 = 0
         END IF
 
         IF sr.diff2 IS NULL THEN
            LET sr.diff2 = 0
         END IF
 
         IF cl_null(sr.aao.aao02) THEN
            LET sr.aao.aao02 = ' '
         END IF
 
         IF tm.merge = 'Y' THEN
            LET sr.aao.aao02 = ' '
         END IF
 
         IF sr.aag221 IS NULL THEN
            LET sr.aag221 = ' '
         END IF
#No.FUN-780060--start--add
         SELECT gem02 INTO l_gem02 FROM gem_file 
                WHERE gem01 = sr.aao.aao02 
         IF tm.c = 'N' THEN  
            LET sr.aag13 = sr.aag02 
         END IF 
       
          
         EXECUTE insert_prep USING
                 sr.aao.aao00,sr.aao.aao01,sr.aao.aao02,sr.aao.aao03,
                 sr.aao.aao04,sr.aag13,sr.aag221,sr.defcharge,sr.defcharge,
                 sr.merge,sr.merge,sr.lastcharge,sr.lastcharge,l_gem02
#No.FUN-780060--end--
#        OUTPUT TO REPORT aglg182_rep(sr.*)
 
      END FOREACH
   END FOREACH
 
#   FINISH REPORT aglg182_rep
#No.FUN-780060--start--add
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    IF g_zz05 = 'Y' THEN                                                                                                           
       CALL cl_wcchp(tm.wc,'aag01')                                                                 
       RETURNING tm.wc                                                                                                             
       LET g_str = tm.wc                                                                                                           
    END IF 
    LET l_tit1 = tm.defyy USING '####','/',tm.defmm USING '&#'
    LET l_tit2 = tm.comyy USING '####','/',tm.commm USING '&#'
###GENGRE###    LET g_str=g_str,";'';",tm.defyy,";",tm.defmm,";",tm.comyy,";",tm.commm,";", #No.FUN-830139 tm.budget -> ''
###GENGRE###              tm.merge,";",tm.bookno,";",tm.zero_sw,";",g_azi05,";",l_tit1,";",l_tit2
###GENGRE###    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                               
###GENGRE###    CALL cl_prt_cs3('aglg182','aglg182',g_sql,g_str)
    CALL aglg182_grdata()    ###GENGRE###
#No.FUN-780060--end--
END FUNCTION
#No.FUN-780060--start--mark
{REPORT aglg182_rep(sr)
   DEFINE sr        RECORD
                       aao  RECORD LIKE aao_file.*,
                       aag02       LIKE aag_file.aag02,   #科目名稱
                       aag13       LIKE aag_file.aag13,   #額外名稱 #FUN-6C0012
                       aag221      LIKE aag_file.aag221,  #科目分類碼一
                       defcharge   LIKE aao_file.aao05,   #(1)基準:實際費用
                       merge       LIKE aao_file.aao05,   #(2)基準:預算
                       lastcharge  LIKE aao_file.aao05,   #(3)比較:上月實際費用
                       diff1       LIKE aao_file.aao05,   #差異1-2
                       diff2       LIKE aao_file.aao05    #差異1-3
                    END RECORD,
          l_last_sw LIKE type_file.chr1,       #No.FUN-680098     VARCHAR(1)
          l_gem02   LIKE gem_file.gem02,
          l_defcharge,l_merge,l_lastcharge,l_diff1,l_diff2 LIKE aao_file.aao05
   DEFINE g_head1   STRING 
   DEFINE l_tit1    LIKE type_file.chr1000     #No.FUN-680098 VARCHAR(12) 
   DEFINE l_tit2    LIKE type_file.chr1000     #No.FUN-680098 VARCHAR(12)
   DEFINE l_tit3    LIKE type_file.chr1000     #No.FUN-680098 VARCHAR(12)
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.aao.aao02,sr.aao.aao01,sr.aag221    #部門,科目,科目分類碼1
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         LET g_head1 = g_x[9] CLIPPED,tm.budget
         PRINT g_head1
         LET g_head1 = g_x[12] CLIPPED,tm.defyy USING '####',
                       '/',tm.defmm USING '##'
         PRINT g_head1
         PRINT g_dash[1,g_len]
         LET l_tit1 = tm.defyy USING '####',':',tm.defmm USING '##',g_x[17] CLIPPED
         LET l_tit2 = tm.defyy USING '####',':',tm.defmm USING '##',g_x[17] CLIPPED
         LET l_tit3 = tm.comyy USING '####',':',tm.commm USING '##',g_x[17] CLIPPED
         PRINT COLUMN g_c[33],l_tit1,
               COLUMN g_c[34],l_tit2,
               COLUMN g_c[35],l_tit3
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
         PRINT g_dash1
         LET l_last_sw='n'
 
      BEFORE GROUP OF sr.aao.aao02    #部門: 若tm.merge='N'->sr.aao02=' '
         IF tm.merge = 'N' THEN
            SKIP TO TOP OF PAGE
            SELECT gem02 INTO l_gem02 FROM gem_file
             WHERE gem01 = sr.aao.aao02
            PRINT COLUMN g_c[31],g_x[11] CLIPPED,
                  COLUMN g_c[32],sr.aao.aao02 CLIPPED,
                  COLUMN g_c[33],l_gem02
            PRINT
         END IF
 
      AFTER GROUP OF sr.aao.aao01     #科目
         #FUN-6C0012.....begin
         IF tm.c = 'N' THEN
            LET sr.aag13 = sr.aag02 
         END IF
         #FUN-6C0012.....end
         LET l_defcharge = 0
         LET l_merge = 0
         LET l_lastcharge = 0
         LET l_diff1 = 0
         LET l_diff2 = 0
 
         IF tm.merge = 'N' THEN
            LET l_defcharge = GROUP SUM(sr.defcharge )
                                  WHERE sr.aao.aao02 = sr.aao.aao02
                                    AND sr.aao.aao01 = sr.aao.aao01
                                    AND sr.aao.aao03 = tm.defyy
                                    AND sr.aao.aao04 = tm.defmm
                                    AND sr.aao.aao00 = tm.bookno    #No.FUN-740020
            LET l_merge = GROUP SUM(sr.merge)
                              WHERE sr.aao.aao02 = sr.aao.aao02
                                AND sr.aao.aao01 = sr.aao.aao01
                                AND sr.aao.aao03 = tm.defyy
                                AND sr.aao.aao04 = tm.defmm
                                AND sr.aao.aao00 = tm.bookno    #No.FUN-740020
            LET l_lastcharge = GROUP SUM(sr.lastcharge)
                                   WHERE sr.aao.aao02 = sr.aao.aao02
                                     AND sr.aao.aao01 = sr.aao.aao01
                                     AND sr.aao.aao03 = tm.defyy
                                     AND sr.aao.aao04 = tm.defmm
                                    AND sr.aao.aao00 = tm.bookno    #No.FUN-740020
         ELSE
            LET l_defcharge = GROUP SUM(sr.defcharge)
                                  WHERE sr.aao.aao01 = sr.aao.aao01
                                    AND sr.aao.aao00 = tm.bookno    #No.FUN-740020
            LET l_merge = GROUP SUM(sr.merge)
                              WHERE sr.aao.aao01 = sr.aao.aao01
                                    AND sr.aao.aao00 = tm.bookno    #No.FUN-740020
            LET l_lastcharge = GROUP SUM(sr.lastcharge)
                                   WHERE sr.aao.aao01 = sr.aao.aao01
                                    AND sr.aao.aao00 = tm.bookno    #No.FUN-740020
         END IF
 
         LET l_diff1 = l_defcharge - l_merge
         LET l_diff2 = l_defcharge - l_lastcharge
 
         IF tm.zero_sw = 'Y' OR (tm.zero_sw = 'N' AND (l_defcharge <> 0
            OR l_merge <> 0 OR l_lastcharge <> 0 OR l_diff1 <> 0
            OR l_diff2 <> 0)) THEN
            PRINT COLUMN g_c[31],sr.aao.aao01,
#                  COLUMN g_c[32],sr.aag02,    #FUN-6C0012
                  COLUMN g_c[32],sr.aag13,     #FUN-6C0012
                  COLUMN g_c[33],cl_numfor(l_defcharge ,33,g_azi05),
                  COLUMN g_c[34],cl_numfor(l_merge,34,g_azi05),
                  COLUMN g_c[35],cl_numfor(l_lastcharge,35,g_azi05),
                  COLUMN g_c[36],cl_numfor(l_diff1,36,g_azi05),
                  COLUMN g_c[37],cl_numfor(l_diff2,37,g_azi05)
          END IF
 
      AFTER GROUP OF sr.aao.aao02    #部門: 若tm.merge='N'->sr.aao.aao02=' '
         IF tm.merge = 'N' THEN
            LET t_tot1 = GROUP SUM(sr.defcharge)
                             WHERE sr.aao.aao02 = sr.aao.aao02
                                    AND sr.aao.aao00 = tm.bookno    #No.FUN-740020
            LET t_tot2 = GROUP SUM(sr.merge)
                             WHERE sr.aao.aao02 = sr.aao.aao02
                                    AND sr.aao.aao00 = tm.bookno    #No.FUN-740020
            LET t_tot3 = GROUP SUM(sr.lastcharge)
                             WHERE sr.aao.aao02 = sr.aao.aao02
                                    AND sr.aao.aao00 = tm.bookno    #No.FUN-740020
            LET t_tot4 = t_tot1 - t_tot2
            LET t_tot5 = t_tot1 - t_tot3
 
            LET t_change1 = GROUP SUM(sr.defcharge)
                                WHERE sr.aao.aao02 = sr.aao.aao02
                                  AND sr.aag221[1,1] = 'V'
                                    AND sr.aao.aao00 = tm.bookno    #No.FUN-740020
            LET t_change2 = GROUP SUM(sr.merge)
                                WHERE sr.aao.aao02 = sr.aao.aao02
                                  AND sr.aag221[1,1] = 'V'
                                    AND sr.aao.aao00 = tm.bookno    #No.FUN-740020
            LET t_change3 = GROUP SUM(sr.lastcharge)
                                WHERE sr.aao.aao02 = sr.aao.aao02
                                  AND sr.aag221[1,1] = 'V'
                                    AND sr.aao.aao00 = tm.bookno    #No.FUN-740020
            LET t_change4 = t_change1 - t_change2
            LET t_change5 = t_change1 - t_change3
 
            LET t_fix1 = GROUP SUM(sr.defcharge)
                             WHERE sr.aao.aao02 = sr.aao.aao02
                               AND sr.aag221[1,1] = 'F'
                                    AND sr.aao.aao00 = tm.bookno    #No.FUN-740020
            LET t_fix2 = GROUP SUM(sr.merge)
                             WHERE sr.aao.aao02 = sr.aao.aao02
                               AND sr.aag221[1,1] = 'F'
                                    AND sr.aao.aao00 = tm.bookno    #No.FUN-740020
            LET t_fix3 = GROUP SUM(sr.lastcharge)
                             WHERE sr.aao.aao02 = sr.aao.aao02
                               AND sr.aag221[1,1] = 'F'
                                    AND sr.aao.aao00 = tm.bookno    #No.FUN-740020
            LET t_fix4 = t_fix1 - t_fix2
            LET t_fix5 = t_fix1 - t_fix3
 
            LET t_other1 = GROUP SUM(sr.defcharge)
                               WHERE sr.aao.aao02 = sr.aao.aao02
                                 AND sr.aag221[1,1] <> 'V' AND sr.aag221 <> 'F'
                                    AND sr.aao.aao00 = tm.bookno    #No.FUN-740020
            LET t_other2 = GROUP SUM(sr.merge)
                               WHERE sr.aao.aao02 = sr.aao.aao02
                                 AND sr.aag221[1,1] <> 'V' AND sr.aag221 <> 'F'
                                    AND sr.aao.aao00 = tm.bookno    #No.FUN-740020
            LET t_other3 = GROUP SUM(sr.lastcharge)
                               WHERE sr.aao.aao02 = sr.aao.aao02
                                 AND sr.aag221[1,1] <> 'V' AND sr.aag221 <> 'F'
                                    AND sr.aao.aao00 = tm.bookno    #No.FUN-740020
            LET t_other4 = t_other1 - t_other2
            LET t_other5 = t_other1 - t_other3
 
            IF t_change1 IS NULL THEN LET t_change1 = 0 END IF
            IF t_change2 IS NULL THEN LET t_change2 = 0 END IF
            IF t_change3 IS NULL THEN LET t_change3 = 0 END IF
            IF t_change4 IS NULL THEN LET t_change4 = 0 END IF
            IF t_change5 IS NULL THEN LET t_change5 = 0 END IF
 
            IF t_fix1 IS NULL THEN LET t_fix1 = 0 END IF
            IF t_fix2 IS NULL THEN LET t_fix2 = 0 END IF
            IF t_fix3 IS NULL THEN LET t_fix3 = 0 END IF
            IF t_fix4 IS NULL THEN LET t_fix4 = 0 END IF
            IF t_fix5 IS NULL THEN LET t_fix5 = 0 END IF
 
            IF t_other1 IS NULL THEN LET t_other1 = 0 END IF
            IF t_other2 IS NULL THEN LET t_other2 = 0 END IF
            IF t_other3 IS NULL THEN LET t_other3 = 0 END IF
            IF t_other4 IS NULL THEN LET t_other4 = 0 END IF
            IF t_other5 IS NULL THEN LET t_other5 = 0 END IF
 
            PRINT g_dash2[1,g_len]
 
            PRINT COLUMN g_c[32],g_x[13] CLIPPED,
                  COLUMN g_c[33],cl_numfor(t_tot1,33,g_azi05),
                  COLUMN g_c[34],cl_numfor(t_tot2,34,g_azi05),
                  COLUMN g_c[35],cl_numfor(t_tot3,35,g_azi05),
                  COLUMN g_c[36],cl_numfor(t_tot4,36,g_azi05),
                  COLUMN g_c[37],cl_numfor(t_tot5,37,g_azi05)
 
            PRINT COLUMN g_c[32],g_x[14] CLIPPED,
                  COLUMN g_c[33],cl_numfor(t_change1,33,g_azi05),
                  COLUMN g_c[34],cl_numfor(t_change2,34,g_azi05),
                  COLUMN g_c[35],cl_numfor(t_change3,35,g_azi05),
                  COLUMN g_c[36],cl_numfor(t_change4,36,g_azi05),
                  COLUMN g_c[37],cl_numfor(t_change5,37,g_azi05)
 
            PRINT COLUMN g_c[32],g_x[15] CLIPPED,
                  COLUMN g_c[33],cl_numfor(t_fix1,33,g_azi05),
                  COLUMN g_c[34],cl_numfor(t_fix2,34,g_azi05),
                  COLUMN g_c[35],cl_numfor(t_fix3,35,g_azi05),
                  COLUMN g_c[36],cl_numfor(t_fix4,36,g_azi05),
                  COLUMN g_c[37],cl_numfor(t_fix5,37,g_azi05)
 
            PRINT COLUMN g_c[32],g_x[16] CLIPPED,
                  COLUMN g_c[33],cl_numfor(t_other1,33,g_azi05),
                  COLUMN g_c[34],cl_numfor(t_other2,34,g_azi05),
                  COLUMN g_c[35],cl_numfor(t_other3,35,g_azi05),
                  COLUMN g_c[36],cl_numfor(t_other4,36,g_azi05),
                  COLUMN g_c[37],cl_numfor(t_other5,37,g_azi05)
         END IF
 
      ON LAST ROW
         IF tm.merge='Y' THEN
            LET t_tot1 = SUM(sr.defcharge)
            LET t_tot2 = SUM(sr.merge)
            LET t_tot3 = SUM(sr.lastcharge)
            LET t_tot4 = t_tot1 - t_tot2
            LET t_tot5 = t_tot1 - t_tot3
 
            LET t_change1 = SUM(sr.defcharge) WHERE sr.aag221[1,1] = 'V'
            LET t_change2 = SUM(sr.merge) WHERE sr.aag221[1,1] = 'V'
            LET t_change3 = SUM(sr.lastcharge) WHERE sr.aag221[1,1] = 'V'
            LET t_change4 = t_change1 - t_change2
            LET t_change5 = t_change1 - t_change3
 
            LET t_fix1 = SUM(sr.defcharge) WHERE sr.aag221[1,1] = 'F'
            LET t_fix2 = SUM(sr.merge) WHERE sr.aag221[1,1] = 'F'
            LET t_fix3 = SUM(sr.lastcharge) WHERE sr.aag221[1,1] = 'F'
            LET t_fix4 = t_fix1 - t_fix2
            LET t_fix5 = t_fix1 - t_fix3
 
            LET t_other1 = SUM(sr.defcharge) WHERE sr.aag221[1,1] <> 'V' AND sr.aag221 <> 'F'
            LET t_other2 = SUM(sr.merge) WHERE sr.aag221[1,1] <> 'V' AND sr.aag221 <> 'F'
            LET t_other3 = SUM(sr.lastcharge) WHERE sr.aag221[1,1] <> 'V' AND sr.aag221 <> 'F'
            LET t_other4 = t_other1 - t_other2
            LET t_other5 = t_other1 - t_other3
 
            IF t_change1 IS NULL THEN LET t_change1 = 0 END IF
            IF t_change2 IS NULL THEN LET t_change2 = 0 END IF
            IF t_change3 IS NULL THEN LET t_change3 = 0 END IF
            IF t_change4 IS NULL THEN LET t_change4 = 0 END IF
            IF t_change5 IS NULL THEN LET t_change5 = 0 END IF
 
            IF t_fix1 IS NULL THEN LET t_fix1 = 0 END IF
            IF t_fix2 IS NULL THEN LET t_fix2 = 0 END IF
            IF t_fix3 IS NULL THEN LET t_fix3 = 0 END IF
            IF t_fix4 IS NULL THEN LET t_fix4 = 0 END IF
            IF t_fix5 IS NULL THEN LET t_fix5 = 0 END IF
 
            IF t_other1 IS NULL THEN LET t_other1 = 0 END IF
            IF t_other2 IS NULL THEN LET t_other2 = 0 END IF
            IF t_other3 IS NULL THEN LET t_other3 = 0 END IF
            IF t_other4 IS NULL THEN LET t_other4 = 0 END IF
            IF t_other5 IS NULL THEN LET t_other5 = 0 END IF
 
            PRINT g_dash2[1,g_len]
 
            PRINT COLUMN g_c[32],g_x[13] CLIPPED,
                  COLUMN g_c[33],cl_numfor(t_tot1,33,g_azi05),
                  COLUMN g_c[34],cl_numfor(t_tot2,34,g_azi05),
                  COLUMN g_c[35],cl_numfor(t_tot3,35,g_azi05),
                  COLUMN g_c[36],cl_numfor(t_tot4,36,g_azi05),
                  COLUMN g_c[37],cl_numfor(t_tot5,37,g_azi05)
 
            PRINT COLUMN g_c[32],g_x[14] CLIPPED,
                  COLUMN g_c[33],cl_numfor(t_change1,33,g_azi05),
                  COLUMN g_c[34],cl_numfor(t_change2,34,g_azi05),
                  COLUMN g_c[35],cl_numfor(t_change3,35,g_azi05),
                  COLUMN g_c[36],cl_numfor(t_change4,36,g_azi05),
                  COLUMN g_c[37],cl_numfor(t_change5,37,g_azi05)
 
            PRINT COLUMN g_c[32],g_x[15] CLIPPED,
                  COLUMN g_c[33],cl_numfor(t_fix1,33,g_azi05),
                  COLUMN g_c[34],cl_numfor(t_fix2,34,g_azi05),
                  COLUMN g_c[35],cl_numfor(t_fix3,35,g_azi05),
                  COLUMN g_c[36],cl_numfor(t_fix4,36,g_azi05),
                  COLUMN g_c[37],cl_numfor(t_fix5,37,g_azi05)
 
            PRINT COLUMN g_c[32],g_x[16] CLIPPED,
                  COLUMN g_c[33],cl_numfor(t_other1,33,g_azi05),
                  COLUMN g_c[34],cl_numfor(t_other2,34,g_azi05),
                  COLUMN g_c[35],cl_numfor(t_other3,35,g_azi05),
                  COLUMN g_c[36],cl_numfor(t_other4,36,g_azi05),
                  COLUMN g_c[37],cl_numfor(t_other5,37,g_azi05)
         END IF
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
#MOD-740221

###GENGRE###START
FUNCTION aglg182_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    LET g_sql1 = "SELECT COUNT(DISTINCT aao02) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    DECLARE aglg182_repcur01 CURSOR FROM g_sql1  

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg182")
        IF handler IS NOT NULL THEN
            START REPORT aglg182_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY aao02,aao01"                       #FUN-B80161
          
            DECLARE aglg182_datacur1 CURSOR FROM l_sql
            FOREACH aglg182_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg182_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg182_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg182_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B80161---add-----str--------------
    DEFINE l_dif1   LIKE aao_file.aao05 
    DEFINE l_dif2   LIKE aao_file.aao05 
    DEFINE l_dif3   LIKE aao_file.aao05 
    DEFINE l_dif4   LIKE aao_file.aao05 
    DEFINE l_dif5   LIKE aao_file.aao05 
    DEFINE l_dif6   LIKE aao_file.aao05
    DEFINE l_dif7   LIKE aao_file.aao05
    DEFINE l_dif8   LIKE aao_file.aao05 
    DEFINE l_dif9   LIKE aao_file.aao05 
    DEFINE l_dif10  LIKE aao_file.aao05 
    DEFINE l_dif11  LIKE aao_file.aao05 
    DEFINE l_dif12  LIKE aao_file.aao05 
    DEFINE l_dif13  LIKE aao_file.aao05 
    DEFINE l_dif14  LIKE aao_file.aao05 
    DEFINE l_dif15  LIKE aao_file.aao05 
    DEFINE l_dif16  LIKE aao_file.aao05 
    DEFINE l_dif17  LIKE aao_file.aao05 
    DEFINE l_dif18  LIKE aao_file.aao05 
    DEFINE l_dif19  LIKE aao_file.aao05
    DEFINE l_dif20  LIKE aao_file.aao05 
    DEFINE l_total0 LIKE aao_file.aao05 
    DEFINE l_total1 LIKE aao_file.aao05 
    DEFINE l_total2 LIKE aao_file.aao05 
    DEFINE l_total3 LIKE aao_file.aao05 
    DEFINE l_total4 LIKE aao_file.aao05 
    DEFINE l_total5 LIKE aao_file.aao05 
    DEFINE l_total6 LIKE aao_file.aao05 
    DEFINE l_total7 LIKE aao_file.aao05 
    DEFINE l_total8 LIKE aao_file.aao05 
    DEFINE l_total9 LIKE aao_file.aao05 
    DEFINE l_total10 LIKE aao_file.aao05 
    DEFINE l_total11 LIKE aao_file.aao05 
    DEFINE l_total12 LIKE aao_file.aao05 
    DEFINE l_total13 LIKE aao_file.aao05 
    DEFINE l_total14 LIKE aao_file.aao05 
    DEFINE l_total15 LIKE aao_file.aao05 
    DEFINE l_total16 LIKE aao_file.aao05 
    DEFINE l_total17 LIKE aao_file.aao05 
    DEFINE l_total18 LIKE aao_file.aao05 
    DEFINE l_total19 LIKE aao_file.aao05 
    DEFINE l_total20 LIKE aao_file.aao05 
    DEFINE l_total21 LIKE aao_file.aao05 
    DEFINE l_total22 LIKE aao_file.aao05 
    DEFINE l_total23 LIKE aao_file.aao05 
    DEFINE l_total24 LIKE aao_file.aao05 
    DEFINE l_total25 LIKE aao_file.aao05 
    DEFINE l_total26 LIKE aao_file.aao05 
    DEFINE l_sum_defcharge  LIKE aao_file.aao05
    DEFINE l_sum_merge_2    LIKE aao_file.aao05
    DEFINE l_sum_lastcharge LIKE aao_file.aao05
    DEFINE l_tit1    LIKE type_file.chr1000                                               
    DEFINE l_tit11   LIKE type_file.chr1000                                               
    DEFINE l_tit22   LIKE type_file.chr1000 
    DEFINE l_tit2    LIKE type_file.chr1000 
    DEFINE l_display STRING
    DEFINE l_display1 STRING
    DEFINE l_total_fmt STRING
    DEFINE l_skip    LIKE type_file.chr1
    DEFINE l_cnt1    LIKE type_file.num10
    DEFINE l_aao02_cnt  LIKE type_file.num10
    #FUN-B80161---add-----end--------------
    
    ORDER EXTERNAL BY sr1.aao02,sr1.aao01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name  #FUN-B80161 add g_ptime,g_user_name
            PRINTX tm.*
            #FUN-B80161---add---str-------------- 
            FOREACH aglg182_repcur01 INTO l_cnt1 END FOREACH
            LET l_aao02_cnt = 0
            LET l_tit1 = tm.defyy USING '####','/',tm.defmm USING '&#'  
            LET l_tit11 = tm.defyy USING '####','/',tm.defmm USING '&#'
            LET l_tit22 = tm.comyy USING '####','/',tm.commm USING '&#' 
            LET l_tit2 = tm.comyy USING '####','/',tm.commm USING '&#'  
            LET l_tit1 = l_tit1,cl_gr_getmsg("gre-201",g_lang,1)
            LET l_tit2 = l_tit2,cl_gr_getmsg("gre-201",g_lang,1)
            PRINTX l_tit1     
            PRINTX l_tit11   
            PRINTX l_tit22  
            PRINTX l_tit2  
            PRINTX g_azi05
            #FUN-B80161---add---end------------
              
        BEFORE GROUP OF sr1.aao02

        BEFORE GROUP OF sr1.aao01

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        AFTER GROUP OF sr1.aao02
            #FUN-B80161---add-----str----------
            LET l_aao02_cnt = l_aao02_cnt + 1
            IF l_aao02_cnt = l_cnt1 THEN
               LET l_skip = 'N'
            ELSE
               LET l_skip = 'Y'
            END IF
            PRINTX l_skip
            IF sr1.aao00 = tm.zero_sw THEN 
               LET l_total6 = GROUP SUM(sr1.defcharge)
               LET l_total7 = GROUP SUM(sr1.merge_2)
               LET l_total8 = GROUP SUM(sr1.lastcharge)
            ELSE
               LET l_total6 = 0
               LET l_total7 = 0 
               LET l_total8 = 0
            END IF
            PRINTX l_total6
            PRINTX l_total7
            PRINTX l_total8

            LET l_dif5 = l_total6 - l_total7
            LET l_dif6 = l_total6 - l_total8
            PRINTX l_dif5
            PRINTX l_dif6
        
            IF sr1.aao00 = tm.zero_sw AND sr1.aag221 = 'V' THEN 
               LET l_total9 = GROUP SUM(sr1.defcharge)
               LET l_total10= GROUP SUM(sr1.merge_2)
               LET l_total11= GROUP SUM(sr1.lastcharge)
            END IF
            PRINTX l_total9
            PRINTX l_total10
            PRINTX l_total11
           
            LET l_dif7 = l_total9 - l_total10
            LET l_dif8 = l_total9 - l_total11
            PRINTX l_dif7
            PRINTX l_dif8

            IF sr1.aao00 = tm.zero_sw AND sr1.aag221 = 'F' THEN 
               LET l_total12= GROUP SUM(sr1.defcharge)
               LET l_total13= GROUP SUM(sr1.merge_2)
               LET l_total14= GROUP SUM(sr1.lastcharge)
            ELSE
               LET l_total12= 0
               LET l_total13= 0
               LET l_total14= 0 
            END IF
            PRINTX l_total12
            PRINTX l_total13
            PRINTX l_total14

            LET l_dif9 = l_total12 - l_total3
            LET l_dif10= l_total12 - l_total4
            PRINTX l_dif9
            PRINTX l_dif10
        
            IF sr1.aao00 = tm.zero_sw AND sr1.aag221 != 'V' AND sr1.aag221 != 'F' THEN 
               LET l_total15= GROUP SUM(sr1.defcharge)
               LET l_total16= GROUP SUM(sr1.merge_2)
               LET l_total17= GROUP SUM(sr1.lastcharge)
            ELSE
               LET l_total15= 0 
               LET l_total16= 0
               LET l_total17= 0
            END IF
            PRINTX l_total15
            PRINTX l_total16
            PRINTX l_total17
            
            LET l_dif11= l_total15 - l_total6
            LET l_dif12= l_total15 - l_total7
            PRINTX l_dif11
            PRINTX l_dif12
            #FUN-B80161---add-----end----------

        AFTER GROUP OF sr1.aao01
            #FUN-B80161---add------str-----------
            LET l_total_fmt = cl_gr_numfmt("aao_file","aao05",g_azi05)
            PRINTX l_total_fmt
            IF tm.merge="N" AND (tm.zero_sw="Y" OR (tm.zero_sw="N" AND (l_total0!=0 OR l_total1!=0 OR l_total2!=0 OR l_dif1!=0 OR l_dif2!=0))) THEN
               LET l_display = "Y"
            ELSE
               LET l_display = "N"
            END IF
            PRINTX l_display

            IF tm.merge="Y" AND (tm.zero_sw="Y" OR (tm.zero_sw="N" AND (l_total0!=0 OR l_total1!=0 OR l_total2!=0 OR l_dif1!=0 OR l_dif2!=0))) THEN
               LET l_display1 = "Y"
            ELSE
               LET l_display1 = "N"
            END IF
            PRINTX l_display1
 
            IF sr1.aao03 = tm.defyy AND sr1.aao04 = tm.defmm AND sr1.aao00 = tm.bookno THEN
               LET l_total0 = GROUP SUM(sr1.defcharge)
               LET l_total1 = GROUP SUM(sr1.merge_2)
               LET l_total2 = GROUP SUM(sr1.lastcharge)
            ELSE
               LET l_total0 = 0 
               LET l_total1 = 0 
               LET l_total2 = 0 
            END IF
            PRINTX l_total0
            PRINTX l_total1
            PRINTX l_total2
             
            LET l_dif1 = l_total0 - l_total1
            LET l_dif2 = l_total0 - l_total2
            PRINTX l_dif1
            PRINTX l_dif2
  
            IF sr1.aao00 = tm.bookno THEN 
               LET l_total3 = GROUP SUM(sr1.defcharge_1)
               LET l_total4 = GROUP SUM(sr1.merge_1)
               LET l_total5 = GROUP SUM(sr1.lastcharge_1)
            ELSE
               LET l_total3 = 0 
               LET l_total4 = 0 
               LET l_total5 = 0 
            END IF
            PRINTX l_total3
            PRINTX l_total4
            PRINTX l_total5
            
            LET l_dif3 = l_total3 - l_total4
            LET l_dif4 = l_total3 - l_total5
            PRINTX l_dif3
            PRINTX l_dif4  
            #FUN-B80161---add------end-----------
        
        ON LAST ROW
            #FUN-B80161---add----str----------
            LET l_sum_defcharge = SUM(sr1.defcharge)
            LET l_sum_merge_2   = SUM(sr1.merge_2)
            LET l_sum_lastcharge = SUM(sr1.lastcharge)
            PRINTX l_sum_defcharge
            PRINTX l_sum_merge_2
            PRINTX l_sum_lastcharge

            LET l_dif13 = l_sum_defcharge - l_sum_merge_2
            LET l_dif14 = l_sum_defcharge - l_sum_lastcharge
            PRINTX l_dif13  
            PRINTX l_dif14  
           
            IF sr1.aag221 = 'V' THEN  
               LET l_total18= SUM(sr1.defcharge)
               LET l_total19= SUM(sr1.merge_2)
               LET l_total20= SUM(sr1.lastcharge)
            END IF
            PRINTX l_total18
            PRINTX l_total19
            PRINTX l_total20

            LET l_dif15= l_total18 - l_total19
            LET l_dif16= l_total18 - l_total20
            PRINTX l_dif15
            PRINTX l_dif16 
       
            IF sr1.aag221 = 'F' THEN  
               LET l_total21= SUM(sr1.defcharge)
               LET l_total22= SUM(sr1.merge_2)
               LET l_total23= SUM(sr1.lastcharge)
            ELSE
               LET l_total21 = 0 
               LET l_total22 = 0 
               LET l_total23 = 0 
            END IF 
            PRINTX l_total21
            PRINTX l_total22
            PRINTX l_total23

            LET l_dif17= l_total21 - l_total22
            LET l_dif18= l_total21 - l_total23
            PRINTX l_dif17
            PRINTX l_dif18
      
            IF sr1.aag221 != 'V' AND sr1.aag221 != 'F' THEN  
               LET l_total24= SUM(sr1.defcharge)
               LET l_total25= SUM(sr1.merge_2)
               LET l_total26= SUM(sr1.lastcharge)
            ELSE
               LET l_total24 = 0 
               LET l_total25 = 0 
               LET l_total26 = 0 
            END IF 
            PRINTX l_total24
            PRINTX l_total25
            PRINTX l_total26

            LET l_dif19= l_total24 - l_total25
            LET l_dif20= l_total24 - l_total26
            PRINTX l_dif19
            PRINTX l_dif20 
            #FUN-B80161---add----end----------
END REPORT
###GENGRE###END
#FUN-C30178
