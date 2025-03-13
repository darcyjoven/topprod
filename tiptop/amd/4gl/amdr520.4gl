# Prog. Version..: '5.30.06-13.03.27(00010)'     #
#
# Pattern name...: amdr520.4gl
# Descriptions...: 進項憑証與總帳不合檢核表
# Date & Author..: 99/03/16 By Linda
# Modify ........: 01/05/29 by plum 修正
# Modify.........: No:8178 03/09/10 By Wiky 多一個)號
# Modify.........: No:5878 03/11/06 By Kitty 倉退折讓不應再讀取付款單上的傳票號碼
# Modify.........: No.9017 04/01/12 By Kitty plant長度修改
# Modify.........: No.FUN-510019 05/01/11 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-560247 05/06/28 By jackie 單據編號加大
# Modify.........: No.MOD-5B0242 05/11/21 By Smapmin 進項稅別科目開窗
# Modify.........: No.TQC-610057 06/01/24 By Kevin 修改外部參數接收
# Modify.........: No.FUN-660093 06/06/15 By xumin  cl_err To cl_err3
# Modify.........: No.FUN-670006 06/07/10 By Jackho 帳別權限修改
# Modify.........: No.FUN-680074 06/08/25 By huchenghao 類型轉換
# Modify.........: No.FUN-690116 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題問題.
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.MOD-6C0151 06/12/22 By Smapmin 只要是進項資料就要抓進來
# Modify.........: No.FUN-730033 07/03/21 By Carrier 會計科目加帳套
# Modify.........: No.MOD-750055 07/05/15 By Smapmin 增加格式26,27的抓取.修改MATCHES語法
# Modify.........: No.FUN-750093 07/06/01 By ve  報表改為使用crystal report
# Modify.........: No.TQC-790091 07/09/17 By Mandy Primary Key的關係,原本SQLCA.sqlcode重複的錯誤碼-239，在informix不適用
# Modify.........: No.TQC-860019 08/06/09 By cliare ON IDLE 控制調整
# Modify.........: No.FUN-940102 09/04/20 By dxfwo  新增使用者對營運中心的權限管控
# Modify.........: No.TQC-950109 09/05/26 By baofei g_azi04,g_azi05不需要在程序里抓值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-9A0023 09/10/19 By sabrina 在給l_apa44值前都需先將l_apa44清空
# Modify.........: No:FUN-A10098 10/01/18 By shiwuying GP5.2跨DB報表--財務類
# Modify.........: No:MOD-B10037 11/01/06 By Dido 非請款折讓的傳票編號抓取調整 
# Modify.........: No.FUN-B10049 11/01/20 By destiny 科目查詢自動過濾
# Modify.........: No.FUN-B20054 11/02/24 By xianghui 先錄入帳套,科目根據帳套過濾;結構改為DIALOG
# Modify.........: No.CHI-D30022 13/03/18 By apo 同一張傳票的稅額只計算一次

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
            wc          LIKE type_file.chr1000,    #No.FUN-680074 VARCHAR(1000)
            sure        LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
            actno       LIKE aag_file.aag01,
            e           LIKE aaa_file.aaa01, #no.7277
            more        LIKE type_file.chr1        #No.FUN-680074 VARCHAR(1)
           END RECORD
#FUN-A10098 -BEGIN-----
#DEFINE    g_ary  ARRAY [08] OF RECORD
#              plant   LIKE azp_file.azp01,       #No.FUN-680074 VARCHAR(10)#No:9017
#              dbs_new LIKE type_file.chr21       #No.FUN-680074 CAHR(21)
#          END RECORD
#FUN-A10098 -END-------
DEFINE g_cal  DYNAMIC ARRAY OF RECORD
              mony  LIKE amd_file.amd08,
              tax   LIKE amd_file.amd07,
              cnt   LIKE type_file.num5          #No.FUN-680074 SMALLINT
           END RECORD
DEFINE g_amd08        LIKE amd_file.amd08
DEFINE g_amd07        LIKE amd_file.amd07
DEFINE g_dash_1       LIKE type_file.chr1000     #No.FUN-680074 VARCHAR(200)
DEFINE l_cnt          LIKE type_file.num5,       #No.FUN-680074 SMALLINT
       s_abb07        LIKE abb_file.abb07     #稅額
      #No.FUN-A10098 -BEGIN-----
      #g_plant_1      LIKE azp_file.azp01,
      #g_plant_2      LIKE azp_file.azp01,
      #g_plant_3      LIKE azp_file.azp01,
      #g_plant_4      LIKE azp_file.azp01,
      #g_plant_5      LIKE azp_file.azp01,
      #g_plant_6      LIKE azp_file.azp01,
      #g_plant_7      LIKE azp_file.azp01,
      #g_plant_8      LIKE azp_file.azp01
      #No.FUN-A10098 -END-------
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680074 SMALLINT
DEFINE   g_str           STRING,                 #No.FUN-750093
         g_sql           STRING,                 #No.FUN-750093
         l_table         STRING                  #No.FUN-750093
DEFINE   l_abb07_1       LIKE abb_file.abb07     #CHI-D30022
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMD")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690116
#No.FUN-750093--------------------begin--------------------
   LET g_sql = " amd28.amd_file.amd28,",    #傳票號碼
               " amd01.amd_file.amd01,",    #帳款單號
               " amd03.amd_file.amd03,",    #發票號碼
               " gen02.gen_file.gen02,",    #錄入人員
               " amd08.amd_file.amd08,",    #發票金額
               " amd07.amd_file.amd07,",    #發票稅額
               " abb07.abb_file.abb07,",    #異動金額
               " ze03.ze_file.ze03,",     #錯誤訊息內容
               " amduser.amd_file.amduser,",	
               " abb07_1.abb_file.abb07"    #CHI-D30022 
   LET l_table=cl_prt_temptable('amdr520',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                           
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?) "   #CHI-D30022 add 1?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF    
#No.FUN-750093--------------------end----------------------
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
#-----TQC-610057---------
   LET tm.wc    = ARG_VAL(7)
   LET tm.sure  = ARG_VAL(8)
   LET tm.actno = ARG_VAL(9)
   LET tm.e     = ARG_VAL(10)
  #FUN-A10098 -BEGIN-----
  #LET g_ary[1].plant = ARG_VAL(11)
  #LET g_ary[2].plant = ARG_VAL(12)
  #LET g_ary[3].plant = ARG_VAL(13)
  #LET g_ary[4].plant = ARG_VAL(14)
  #LET g_ary[5].plant = ARG_VAL(15)
  #LET g_ary[6].plant = ARG_VAL(16)
  #LET g_ary[7].plant = ARG_VAL(17)
  #LET g_ary[8].plant = ARG_VAL(18)
#-#---END TQC-610057-----
  ##No.FUN-570264 --start--
  #LET g_rep_user = ARG_VAL(19)
  #LET g_rep_clas = ARG_VAL(20)
  #LET g_template = ARG_VAL(21)
  #LET g_rpt_name = ARG_VAL(22)  #No.FUN-7C0078
  ##No.FUN-570264 ---end---
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)
  #FUN-A10098 -END-------
   LET g_amd08 = 0
   LET g_amd07 = 0
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r520_tm(0,0)
      ELSE CALL r520()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION r520_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680074 SMALLINT
          l_cmd          LIKE type_file.chr1000,       #No.FUN-680074 VARCHAR(1000)
          l_aag02        LIKE aag_file.aag02,
          li_chk_bookno  LIKE type_file.num5           #No.FUN-680074 SMALLINT#No.FUN-670006
   DEFINE li_result      LIKE type_file.num5           #No.FUN-940102
   
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 4 LET p_col = 18
   ELSE LET p_row = 4 LET p_col = 12
   END IF
   OPEN WINDOW r520_w AT p_row,p_col
        WITH FORM "amd/42f/amdr520"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.sure='Y'
   LET tm.more='N'
   LET tm.e = g_aza.aza81  #No.FUN-B20054
   SELECT aaz64 INTO tm.e FROM aaz_file WHERE aaz00='0' #no.7277
 
WHILE TRUE
#No.FUN-B20054--add-start--
      DIALOG ATTRIBUTE(unbuffered)
         INPUT BY NAME tm.e ATTRIBUTE(WITHOUT DEFAULTS)
            AFTER FIELD e
              IF NOT cl_null(tm.e) THEN
                   CALL s_check_bookno(tm.e,g_user,g_plant)
                    RETURNING li_chk_bookno
                IF (NOT li_chk_bookno) THEN
                    NEXT FIELD e
                END IF
                SELECT aaa02 FROM aaa_file WHERE aaa01 = tm.e
                IF STATUS THEN
                   CALL cl_err3("sel","aaa_file",tm.e,"","agl-043","","",0)
                   NEXT FIELD  e
                END IF
             END IF
         END INPUT

#No.FUN-B20054--add-end--

   CONSTRUCT BY NAME tm.wc ON  apa01, apa02,apa44,apa43,apa00,apauser
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
#No.FUN-B20054--mark--start-- 
#      ON ACTION locale
#          #CALL cl_dynamic_locale()
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#         LET g_action_choice = "locale"
#         EXIT CONSTRUCT
# 
#    ON IDLE g_idle_seconds
#       CALL cl_on_idle()
#       CONTINUE CONSTRUCT
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
#No.FUN-B20054--mark--end-- 
 END CONSTRUCT
#No.FUN-B20054--mark--start--
#       IF g_action_choice = "locale" THEN
#          LET g_action_choice = ""
#          CALL cl_dynamic_locale()
#          CONTINUE WHILE
#       END IF
# 
# 
#   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r520_w 
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
#      EXIT PROGRAM
#      
#   END IF
#   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
#   #資料權限的檢查
#   #Begin:FUN-980030
#   #   IF g_priv2='4' THEN                           #只能使用自己的資料
#   #       LET tm.wc = tm.wc clipped," AND apauser = '",g_user,"'"
#   #   END IF
#   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
#   #       LET tm.wc = tm.wc clipped," AND apkgrup MATCHES '",g_grup CLIPPED,"*'"
#   #   END IF
# 
#   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
#   #       LET tm.wc = tm.wc clipped," AND apkgrup IN ",cl_chk_tgrup_list()
#   #   END IF
#   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('apauser', 'apagrup')
#   #End:FUN-980030
# 
#  #No.FUN-A10098 -BEGIN-----
#  #LET g_plant_1 = g_plant
#  #INPUT g_plant_1,g_plant_2,g_plant_3,g_plant_4,
#  #      g_plant_5, g_plant_6,g_plant_7,g_plant_8,tm.sure,tm.e,tm.actno,tm.more  #No.FUN-730033
#  #      WITHOUT DEFAULTS
#  #  FROM plant_1, plant_2, plant_3, plant_4,
#  #       plant_5, plant_6, plant_7, plant_8,sure,e,actno,more  #No.FUN-730033
#   INPUT tm.sure,tm.e,tm.actno,tm.more WITHOUT DEFAULTS
#    FROM sure,e,actno,more
#No.FUN-B20054--mark--end-- 
    INPUT BY NAME tm.sure,tm.actno,tm.more   ATTRIBUTE(WITHOUT DEFAULTS)  #No.FUN-B20054
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
  #     BEFORE FIELD plant_1
  #         IF g_multpl='N' THEN  #不為多工廠環境
  #            LET g_plant_1= g_plant
  #            LET g_plant_new= NULL
  #            LET g_dbs_new=NULL
  #            LET g_ary[1].plant = g_plant_1
  #            LET g_ary[1].dbs_new = g_dbs_new CLIPPED
  #            DISPLAY g_plant_1 TO FORMONLY.plant_1
  #         #  EXIT INPUT       #將不會I/P plant_2 plant_3 plant_4
  #            NEXT FIELD s
  #         END IF
 
  #     AFTER FIELD plant_1
  #         LET g_plant_new= g_plant_1
  #         IF g_plant_1 = g_plant THEN
  #            LET g_dbs_new=''
  #            LET g_ary[1].plant = g_plant_1
  #            LET g_ary[1].dbs_new = g_dbs_new CLIPPED
  #         ELSE
  #            IF NOT cl_null(g_plant_1) THEN
  #               #檢查工廠並將新的資料庫放在g_dbs_new
  #               IF NOT s_chknplt(g_plant_1,'AAP','AAP') THEN
  #                  CALL cl_err(g_plant_new,g_errno,0)
  #                  NEXT FIELD plant_1
  #               END IF
  #               LET g_ary[1].plant = g_plant_1
  #               CALL s_getdbs()
  #               LET g_ary[1].dbs_new = g_dbs_new CLIPPED
  ##No.FUN-940102 --begin--
  #            CALL s_chk_demo(g_user,g_plant_1) RETURNING li_result
  #             IF not li_result THEN 
  #              NEXT FIELD plant_1
  #             END IF 
  ##No.FUN-940102 --end-- 
  #            ELSE                     #輸入之工廠編號為' '或NULL
  #               LET g_ary[1].plant = g_plant_1
  #            END IF
  #         END IF
 
  #     AFTER FIELD plant_2
  #         LET g_plant_2 = duplicate(g_plant_2,1)   #不使"工廠編號"重覆
  #         LET g_plant_new= g_plant_2
  #         IF g_plant_2 = g_plant THEN
  #            LET g_dbs_new=''
  #            LET g_ary[2].plant = g_plant_2
  #            LET g_ary[2].dbs_new = g_dbs_new CLIPPED
  #         ELSE
  #            IF NOT cl_null(g_plant_2) THEN
  #               #檢查工廠並將新的資料庫放在g_dbs_new
  #               IF NOT s_chknplt(g_plant_2,'AAP','AAP') THEN
  #                  CALL cl_err(g_plant_new,g_errno,0)
  #                  NEXT FIELD plant_2
  #               END IF
  #               LET g_ary[2].plant = g_plant_2
  #               CALL s_getdbs()
  #               LET g_ary[2].dbs_new = g_dbs_new CLIPPED
  ##No.FUN-940102 --begin--
  #            CALL s_chk_demo(g_user,g_plant_2) RETURNING li_result
  #             IF not li_result THEN 
  #              NEXT FIELD plant_2
  #             END IF 
  ##No.FUN-940102 --end-- 
  #            ELSE                     #輸入之工廠編號為' '或NULL
  #               LET g_ary[2].plant = g_plant_2
  #            END IF
  #         END IF
 
  #     AFTER FIELD plant_3
  #         LET g_plant_3 = duplicate(g_plant_3,2)   #不使"工廠編號"重覆
  #         LET g_plant_new= g_plant_3
  #         IF g_plant_3 = g_plant THEN
  #            LET g_dbs_new=''
  #            LET g_ary[3].plant = g_plant_3
  #            LET g_ary[3].dbs_new = g_dbs_new CLIPPED
  #         ELSE
  #            IF NOT cl_null(g_plant_3) THEN
  #               #檢查工廠並將新的資料庫放在g_dbs_new
  #               IF NOT s_chknplt(g_plant_3,'AAP','AAP') THEN
  #                  CALL cl_err(g_plant_new,g_errno,0)
  #                  NEXT FIELD plant_3
  #               END IF
  #               LET g_ary[3].plant = g_plant_3
  #               CALL s_getdbs()
  #               LET g_ary[3].dbs_new = g_dbs_new CLIPPED
  ##No.FUN-940102 --begin--
  #            CALL s_chk_demo(g_user,g_plant_3) RETURNING li_result
  #             IF not li_result THEN 
  #              NEXT FIELD plant_3
  #             END IF 
  ##No.FUN-940102 --end-- 
  #            ELSE                     #輸入之工廠編號為' '或NULL
  #               LET g_ary[3].plant = g_plant_3
  #            END IF
  #         END IF
 
  #     AFTER FIELD plant_4
  #         LET g_plant_4 = duplicate(g_plant_4,3)   #不使"工廠編號"重覆
  #         LET g_plant_new= g_plant_4
  #         IF g_plant_4 = g_plant THEN
  #            LET g_dbs_new=''
  #            LET g_ary[4].plant = g_plant_4
  #            LET g_ary[4].dbs_new = g_dbs_new CLIPPED
  #         ELSE
  #            IF NOT cl_null(g_plant_4) THEN
  #                                     #檢查工廠並將新的資料庫放在g_dbs_new
  #               IF NOT s_chknplt(g_plant_4,'AAP','AAP') THEN
  #                  CALL cl_err(g_plant_new,g_errno,0)
  #                  NEXT FIELD plant_4
  #               END IF
  #               LET g_ary[4].plant = g_plant_4
  #               CALL s_getdbs()
  #               LET g_ary[4].dbs_new = g_dbs_new CLIPPED
  ##No.FUN-940102 --begin--
  #            CALL s_chk_demo(g_user,g_plant_4) RETURNING li_result
  #             IF not li_result THEN 
  #              NEXT FIELD plant_4
  #             END IF 
  ##No.FUN-940102 --end-- 
  #            ELSE                     #輸入之工廠編號為' '或NULL
  #               LET g_ary[4].plant = g_plant_4
  #            END IF
  #         END IF
 
  #     AFTER FIELD plant_5
  #         LET g_plant_5 = duplicate(g_plant_5,3)   #不使"工廠編號"重覆
  #         LET g_plant_new= g_plant_5
  #         IF g_plant_5 = g_plant THEN
  #            LET g_dbs_new=''
  #            LET g_ary[5].plant = g_plant_5
  #            LET g_ary[5].dbs_new = g_dbs_new CLIPPED
  #         ELSE
  #            IF NOT cl_null(g_plant_5) THEN
  #               IF NOT s_chknplt(g_plant_5,'AAP','AAP') THEN
  #                  CALL cl_err(g_plant_new,g_errno,0)
  #                  NEXT FIELD plant_5
  #               END IF
  #               LET g_ary[5].plant = g_plant_5
  #               CALL s_getdbs()
  #               LET g_ary[5].dbs_new = g_dbs_new CLIPPED
  ##No.FUN-940102 --begin--
  #            CALL s_chk_demo(g_user,g_plant_5) RETURNING li_result
  #             IF not li_result THEN 
  #              NEXT FIELD plant_5
  #             END IF 
  ##No.FUN-940102 --end-- 
  #            ELSE LET g_ary[5].plant = g_plant_5
  #            END IF
  #         END IF
 
  #     AFTER FIELD plant_6
  #         LET g_plant_6 = duplicate(g_plant_6,3)   #不使"工廠編號"重覆
  #         LET g_plant_new= g_plant_6
  #         IF g_plant_6 = g_plant THEN
  #            LET g_dbs_new=''
  #            LET g_ary[6].plant = g_plant_6
  #            LET g_ary[6].dbs_new = g_dbs_new CLIPPED
  #         ELSE
  #            IF NOT cl_null(g_plant_6) THEN
  #               IF NOT s_chknplt(g_plant_6,'AAP','AAP') THEN
  #                  CALL cl_err(g_plant_new,g_errno,0)
  #                  NEXT FIELD plant_6
  #               END IF
  #               LET g_ary[6].plant = g_plant_6
  #               CALL s_getdbs()
  #               LET g_ary[6].dbs_new = g_dbs_new CLIPPED
  ##No.FUN-940102 --begin--
  #            CALL s_chk_demo(g_user,g_plant_6) RETURNING li_result
  #             IF not li_result THEN 
  #              NEXT FIELD plant_6
  #             END IF 
  ##No.FUN-940102 --end-- 
  #            ELSE LET g_ary[6].plant = g_plant_6
  #            END IF
  #         END IF
 
  #     AFTER FIELD plant_7
  #         LET g_plant_7 = duplicate(g_plant_7,3)   #不使"工廠編號"重覆
  #         LET g_plant_new= g_plant_7
  #         IF g_plant_7 = g_plant THEN
  #            LET g_dbs_new=''
  #            LET g_ary[7].plant = g_plant_7
  #            LET g_ary[7].dbs_new = g_dbs_new CLIPPED
  #         ELSE
  #            IF NOT cl_null(g_plant_7) THEN
  #               IF NOT s_chknplt(g_plant_7,'AAP','AAP') THEN
  #                  CALL cl_err(g_plant_new,g_errno,0)
  #                  NEXT FIELD plant_7
  #               END IF
  #               LET g_ary[7].plant = g_plant_7
  #               CALL s_getdbs()
  #               LET g_ary[7].dbs_new = g_dbs_new CLIPPED
  ##No.FUN-940102 --begin--
  #            CALL s_chk_demo(g_user,g_plant_7) RETURNING li_result
  #             IF not li_result THEN 
  #              NEXT FIELD plant_7
  #             END IF 
  ##No.FUN-940102 --end-- 
  #            ELSE LET g_ary[7].plant = g_plant_7
  #            END IF
  #         END IF
 
  #     AFTER FIELD plant_8
  #         LET g_plant_8 = duplicate(g_plant_8,3)   #不使"工廠編號"重覆
  #         LET g_plant_new= g_plant_8
  #         IF g_plant_8 = g_plant THEN
  #            LET g_dbs_new=''
  #            LET g_ary[8].plant = g_plant_8
  #            LET g_ary[8].dbs_new = g_dbs_new CLIPPED
  #         ELSE
  #            IF NOT cl_null(g_plant_8) THEN
  #               IF NOT s_chknplt(g_plant_8,'AAP','AAP') THEN
  #                  CALL cl_err(g_plant_new,g_errno,0)
  #                  NEXT FIELD plant_8
  #               END IF
  #               LET g_ary[8].plant = g_plant_8
  #               CALL s_getdbs()
  #               LET g_ary[8].dbs_new = g_dbs_new CLIPPED
  ##No.FUN-940102 --begin--
  #            CALL s_chk_demo(g_user,g_plant_8) RETURNING li_result
  #             IF not li_result THEN 
  #              NEXT FIELD plant_8
  #             END IF 
  ##No.FUN-940102 --end-- 
  #            ELSE LET g_ary[8].plant = g_plant_8
  #            END IF
  #         END IF
  #         IF cl_null(g_plant_1) AND cl_null(g_plant_2) AND
  #            cl_null(g_plant_3) AND cl_null(g_plant_4) AND
  #            cl_null(g_plant_5) AND cl_null(g_plant_6) AND
  #            cl_null(g_plant_7) AND cl_null(g_plant_8) THEN
  #            CALL cl_err(0,'aap-136',0)
  #            NEXT FIELD plant_1
  #         END IF
  #No.FUN-A10098 -END-------
 
      AFTER FIELD sure
         IF tm.sure IS NOT NULL AND tm.sure NOT MATCHES '[YN]' THEN
            NEXT FIELD sure
         END IF
      AFTER FIELD actno
         IF cl_null(tm.e) THEN NEXT FIELD e END IF  #No.FUN-730033
         IF cl_null(tm.actno) THEN NEXT FIELD actno END IF
         SELECT aag02 INTO l_aag02 FROM aag_file
          WHERE aag01 = tm.actno AND aagacti='Y'
            AND aag00 = tm.e  #No.FUN-730033
         IF SQLCA.sqlcode THEN
         #   CALL cl_err(tm.actno,'aap-021',0) #No.FUN-660093
             CALL cl_err3("sel","aag_file",tm.e,tm.actno,"aap-021","","",0)     #No.FUN-660093  #No.FUN-730033
             #FUN-B10049--begin
             CALL cl_init_qry_var()                                         
             LET g_qryparam.form ="q_aag"                                   
             LET g_qryparam.default1 = tm.actno  
             LET g_qryparam.construct = 'N'                
             LET g_qryparam.arg1 = tm.e  
             LET g_qryparam.where = " aagacti='Y' AND aag01 LIKE '",tm.actno CLIPPED,"%' "                               
             CALL cl_create_qry() RETURNING tm.actno
             DISPLAY BY NAME tm.actno 
             #FUN-B10049--end    
             NEXT FIELD actno
         END IF
#No.FUN-B20054--mark--start--
#      #no.7277
#      AFTER FIELD e
#         IF cl_null(tm.e) THEN NEXT FIELD e END IF
#         IF NOT cl_null(tm.e) THEN
#             #No.FUN-670006--begin
#             CALL s_check_bookno(tm.e,g_user,g_plant)
#                  RETURNING li_chk_bookno
#             IF (NOT li_chk_bookno) THEN
#                NEXT FIELD e
#             END IF
#          #No.FUN-670006--end
#         SELECT aaa02 FROM aaa_file WHERE aaa01=tm.e
#                                      #AND aaaacti IN ('Y','y')   #MOD-750055
#                                      AND aaaacti IN ('Y','y')   #MOD-750055
#         IF STATUS THEN
#         # CALL cl_err('sel aaa:',STATUS,0)  #No.FUN-660093
#           CALL cl_err3("sel","aaa_file",tm.e,"",STATUS,"","sel aaa:",0)   #No.FUN-660093
#         NEXT FIELD e END IF
#      #no.7277(end)
#      END IF
#No.FUN-B20054--mark--end-- 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
#No.FUN-B20054--mark--start--
##MOD-5B0242
#    ON ACTION CONTROLP
#       CASE
#           #No.FUN-730033  --Begin
#           WHEN INFIELD (e)
#                CALL cl_init_qry_var()
#                LET g_qryparam.form     ="q_aaa"
#                LET g_qryparam.state    ="i"
#                CALL cl_create_qry() RETURNING tm.e
#                DISPLAY BY NAME tm.e
#                NEXT FIELD e
#           #No.FUN-730033  --End  
#           WHEN INFIELD (actno)
#                CALL cl_init_qry_var()
#                LET g_qryparam.form     ="q_aag"
#                LET g_qryparam.arg1     = tm.e   #No.FUN-730033
#                LET g_qryparam.state    ="i"
#                CALL cl_create_qry() RETURNING tm.actno
#                DISPLAY BY NAME tm.actno
#                NEXT FIELD actno
#       END CASE
##END MOD-5B0242
# 
#      ON ACTION CONTROLR
#         CALL cl_show_req_fields()
#      ON ACTION CONTROLG CALL cl_cmdask()
# 
#          #TQC-860019-add
#          ON IDLE g_idle_seconds
#          CALL cl_on_idle()
#          CONTINUE INPUT
#          #TQC-860019-add
# 
#          ON ACTION exit
#          LET INT_FLAG = 1
#          EXIT INPUT
#         #No.FUN-580031 --start--
#         ON ACTION qbe_save
#            CALL cl_qbe_save()
#         #No.FUN-580031 ---end---
#No.FUN-B20054--mark--end-- 
   END INPUT
#No.FUN-B20054--add-start--
    ON ACTION CONTROLP
       CASE
           WHEN INFIELD (e)
                CALL cl_init_qry_var()
                LET g_qryparam.form     ="q_aaa"
                LET g_qryparam.state    ="i"
                CALL cl_create_qry() RETURNING tm.e
                DISPLAY BY NAME tm.e
                NEXT FIELD e
           WHEN INFIELD (actno)
                CALL cl_init_qry_var()
                LET g_qryparam.form     ="q_aag"
                LET g_qryparam.arg1     = tm.e   #No.FUN-730033
                LET g_qryparam.state    ="i"
                LET g_qryparam.where = " aag00 = '",tm.e CLIPPED,"'"
                CALL cl_create_qry() RETURNING tm.actno
                DISPLAY BY NAME tm.actno
                NEXT FIELD actno
            OTHERWISE EXIT CASE
       END CASE
       ON ACTION locale
          CALL cl_show_fld_cont()
          LET g_action_choice = "locale"
          EXIT DIALOG

       ON ACTION CONTROLR
          CALL cl_show_req_fields()

       ON ACTION CONTROLG
          CALL cl_cmdask()

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DIALOG

       ON ACTION about
          CALL cl_about()

       ON ACTION help
          CALL cl_show_help()

       ON ACTION exit
          LET INT_FLAG = 1
          EXIT DIALOG

       ON ACTION qbe_save
          CALL cl_qbe_save()

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
#No.FUn-B20054--add--end--
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r520_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF

  IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF       #No.FUn-B20054
  LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('apauser', 'apagrup')           #No.FUn-B20054
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='amdr520'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amdr520','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         #-----TQC-610057---------
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.sure CLIPPED,"'",
                         " '",tm.actno CLIPPED,"'",
                         " '",tm.e CLIPPED,"'",
                        #No.FUN-A10098 -BEGIN-----
                        #" '",g_ary[1].plant CLIPPED,"'",
                        #" '",g_ary[2].plant CLIPPED,"'",
                        #" '",g_ary[3].plant CLIPPED,"'",
                        #" '",g_ary[4].plant CLIPPED,"'",
                        #" '",g_ary[5].plant CLIPPED,"'",
                        #" '",g_ary[6].plant CLIPPED,"'",
                        #" '",g_ary[7].plant CLIPPED,"'",
                        #" '",g_ary[8].plant CLIPPED,"'",
                        #No.FUN-A10098 -END-------
                         #-----END TQC-610057-----
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
         CALL cl_cmdat('amdr520',g_time,l_cmd)
      END IF
      CLOSE WINDOW r520_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r520()
   ERROR ""
END WHILE
   CLOSE WINDOW r520_w
END FUNCTION

#No.FUN-A10098 -BEGIN------- 
#FUNCTION duplicate(l_plant,n)     #檢查輸入之工廠編號是否重覆
#  DEFINE l_plant      LIKE azp_file.azp01
#  DEFINE l_idx, n     LIKE type_file.num10      #No.FUN-680074 INTEGER
#
#  FOR l_idx = 1 TO n
#      IF g_ary[l_idx].plant = l_plant THEN
#         LET l_plant = ''
#      END IF
#  END FOR
#  RETURN l_plant
#END FUNCTION
#No.FUN-A10098 -END-------
 
FUNCTION r520()
   DEFINE l_name     LIKE type_file.chr20,      #No.FUN-680074 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8         #No.FUN-6A0068
          l_chr      LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
          l_za05     LIKE type_file.chr1000,    #No.FUN-680074 VARCHAR(40)
          l_idx      LIKE type_file.num5,       #No.FUN-680074 SMALLINT
         #sr         RECORD LIKE amd_file.*,
          l_abb07    LIKE abb_file.abb07,
          l_amd07    LIKE amd_file.amd07,
          l_amd28    LIKE amd_file.amd28,
          f_apa      RECORD LIKE apa_file.*,
          f_apf      RECORD LIKE apf_file.*,
          l_sql      STRING,                    #No.FUN-680074
          l_sql1     STRING,                    #No.FUN-680074
          l_buf      LIKE type_file.chr1000,    #No.FUN-680074 VARCHAR(400)
          l_str      LIKE type_file.chr1000,    #No.FUN-680074 VARCHAR(70)
          l_err      LIKE ze_file.ze03,         #No.FUN-680074 VARCHAR(16)
          l_k,l_l    LIKE type_file.num5,       #No.FUN-680074 SMALLINT
          t_apa      RECORD LIKE apa_file.*,
          l_apa      RECORD LIKE apa_file.*,
          l_apb      RECORD LIKE apb_file.*,
          l_apk      RECORD LIKE apk_file.*,
          g_ama      RECORD LIKE ama_file.*,
          l_apk26    LIKE apk_file.apk26,
          old_apk01  LIKE apk_file.apk01,
          l_num      LIKE type_file.num5,       #No.FUN-680074 SMALLINT
          l_apa00    LIKE apa_file.apa00,
          l_apa01    LIKE apa_file.apa01,
          l_apa02    LIKE apa_file.apa02,
          l_apa08    LIKE apa_file.apa08,
          l_apa15    LIKE apa_file.apa15,
          l_apa18    LIKE apa_file.apa18,
          l_apa09    LIKE apa_file.apa09,
          l_apa22    LIKE apa_file.apa22,
          l_apa31    LIKE apa_file.apa31,
          l_apa32    LIKE apa_file.apa32,
          l_apa34    LIKE apa_file.apa34,
          l_apa17    LIKE apa_file.apa17,
          l_apa171   LIKE apa_file.apa171,
          l_apa172   LIKE apa_file.apa172,
          l_apa41    LIKE apa_file.apa41,
          l_apauser  LIKE apa_file.apauser,
          l_apagrup  LIKE apa_file.apagrup,
          l_apk01    LIKE apk_file.apk01,
          l_apk02    LIKE apk_file.apk02,
          l_apkuser  LIKE apk_file.apkuser,
          l_apkgrup  LIKE apk_file.apkgrup,
          l_apa173   LIKE apa_file.apa173,
          l_apk171   LIKE apk_file.apk171,
          l_apk172   LIKE apk_file.apk172,
          l_apb02    LIKE apb_file.apb02,
          l_apb10    LIKE apb_file.apb10,
          l_apb11    LIKE apb_file.apb11,
          l_invoice  LIKE apk_file.apk03,  #BUGNO4197
          l_tax      LIKE apa_file.apa32,
          l_tot_tax  LIKE apa_file.apa32,
          l_apa16    LIKE apa_file.apa16,
          l_apa01_o  LIKE apa_file.apa01,
          l_gec06    LIKE gec_file.gec06,
          l_gec08    LIKE gec_file.gec08,
          l_amd22    LIKE amd_file.amd22,
          l_amd40    LIKE amd_file.amd40,
          l_amd41    LIKE amd_file.amd41,
          l_amd42    LIKE amd_file.amd42,
          l_amd43    LIKE amd_file.amd43,
          l_apa43    LIKE apa_file.apa43,
          l_apa44    LIKE apa_file.apa44,
          l_tran     LIKE type_file.chr3,           #No.FUN-680074 VARCHAR(3)
          l_tot      LIKE type_file.num10,          #No.FUN-680074 INTEGER
          t_bdate        LIKE type_file.dat,        #No.FUN-680074 DATE
          t_edate        LIKE type_file.dat,        #No.FUN-680074 DATE
          g_ama08        LIKE ama_file.ama08,
          g_ama09        LIKE ama_file.ama09,
          g_ama10        LIKE ama_file.ama10,
          l_guidate      LIKE amd_file.amd05,
          l_ama08        LIKE ama_file.ama08,
          l_ama09        LIKE ama_file.ama09,
          l_ama10        LIKE ama_file.ama10,
          l_apa58        LIKE apa_file.apa58,
          l_zx04         LIKE zx_file.zx04,
          l_smu02        LIKE smu_file.smu02,
          l_yy,l_mm      LIKE type_file.num5,       #No.FUN-680074 SMALLINT
          l_add_cnt      LIKE type_file.num5,       #No.FUN-680074 SMALLINT
          l_dbs          LIKE type_file.chr20,      #No.FUN-680074 VARCHAR(20)
          g_idx          LIKE type_file.num5,       #No.FUN-680074 SMALLINT
          l_gen02        LIKE gen_file.gen02,       #No.FUN-750093
          sr  RECORD
               amd01     LIKE amd_file.amd01,     #傳票編號
               amd02     LIKE amd_file.amd02,     #No.FUN-680074 SMALLINT#項次
               amd021    LIKE amd_file.amd021,    #來源
               amd03     LIKE amd_file.amd03,     #發票號碼
               amd04     LIKE amd_file.amd04,     #廠商統一編號
               amd05     LIKE amd_file.amd05,     #No.FUN-680074 DATE#發票日期/憑證日期
               amd06     LIKE amd_file.amd06,     #含稅金額
               amd07     LIKE amd_file.amd07,     #稅
               amd08     LIKE amd_file.amd08,     #未稅金額
               amd09     LIKE amd_file.amd09,     #彙加註記
               amd10     LIKE amd_file.amd10,     #洋菸酒註記
               amd17     LIKE amd_file.amd17,     #扣抵區分 (1,2)
               amd171    LIKE amd_file.amd171,    #格式(21,22,23,24,25,26,27)
               amd172    LIKE amd_file.amd172,    #課稅別(1應稅 2零稅率 3免稅)
               amd173    LIKE amd_file.amd173,    #資料年
               amd174    LIKE amd_file.amd174,    #資料月份
               amd175    LIKE amd_file.amd175,    #申報流水編號
               amd22     LIKE amd_file.amd22,     #申報部門
               amd25     LIKE amd_file.amd25,     #工廠編號
               amd26     LIKE amd_file.amd26,     #申報年度
               amd27     LIKE amd_file.amd27,     #申報月份
               amd28     LIKE amd_file.amd28,     #傳票號碼
               amd29     LIKE amd_file.amd29,     #是否檢查發票字軌(Y/N)
               amd30     LIKE amd_file.amd30,     #確認碼
               amdacti   LIKE amd_file.amdacti,   #資料有效碼
               amduser   LIKE amd_file.amduser,   #資料所有者
               amdgrup   LIKE amd_file.amdgrup,   #資料所有群
               amdmodu   LIKE amd_file.amdmodu,   #資料更改者
               amddate   LIKE amd_file.amddate,   #最近修改日
               apa00     LIKE apa_file.apa00,     #帳款性質
               apa41     LIKE apa_file.apa41      #確認否
               END RECORD
   DEFINE l_t1           LIKE apy_file.apyslip    #MOD-B10037
   DEFINE l_apydmy3      LIKE apy_file.apydmy3    #MOD-B10037
   DEFINE l_flag         LIKE type_file.num5      #CHI-D30022

       CALL cl_del_data(l_table)                             #No.FUN-750093
 
      #No.FUN-680074 --Begin
      CREATE TEMP TABLE r520_file(
          amd01   LIKE amd_file.amd01,
          amd02   LIKE amd_file.amd02,
          amd021  LIKE amd_file.amd021,
          amd03   LIKE amd_file.amd03,
          amd04   LIKE amd_file.amd04,
          amd05   LIKE amd_file.amd05,
          amd06   LIKE amd_file.amd06 NOT NULL,
          amd07   LIKE amd_file.amd07 NOT NULL,
          amd08   LIKE amd_file.amd08 NOT NULL,
          amd09   LIKE amd_file.amd09,
          amd10   LIKE amd_file.amd10,
          amd17   LIKE amd_file.amd17,
          amd171  LIKE amd_file.amd171,
          amd172  LIKE amd_file.amd172,
          amd173  LIKE amd_file.amd173,
          amd174  LIKE amd_file.amd174,
          amd175  LIKE amd_file.amd175,
          amd22   LIKE amd_file.amd22,
          amd25   LIKE amd_file.amd25,
          amd26   LIKE amd_file.amd26,
          amd27   LIKE amd_file.amd27,
          amd28   LIKE amd_file.amd28,
          amd29   LIKE amd_file.amd29,
          amd30   LIKE amd_file.amd30,
          amdacti LIKE amd_file.amdacti,
          amduser LIKE amd_file.amduser,
          amdgrup LIKE amd_file.amdgrup,
          amdmodu LIKE amd_file.amdmodu,
          amddate LIKE amd_file.amddate,
          apa00   LIKE apa_file.apa00,
          apa41   LIKE apa_file.apa41);
 
      #No.FUN-680074 --End
     DELETE FROM r520_file
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#NO.CHI-6A0004--BEGIN
#     SELECT azi04, azi05 INTO g_azi04, g_azi05 FROM azi_file
#                        WHERE azi01 = g_aza.aza17
#NO.CHI-6A0004--END
#    CALL cl_outnam('amdr520') RETURNING l_name         #No.FUN-750093
#    START REPORT r520_rep TO l_name                    #No.FUN-750093
#     LET g_pageno = 0                                  #No.FUN-750093 
     FOR l_idx = 1 TO 14
         LET g_cal[l_idx].mony = 0
         LET g_cal[l_idx].tax = 0
         LET g_cal[l_idx].cnt = 0
     END FOR
    #讀取資料
    message 'Wait....'
    CALL ui.Interface.refresh()
    LET g_success='Y'    #No:5878
   #No.FUN-A10098 -BEGIN-----
   #FOR g_idx = 1 TO 8
   #    IF cl_null(g_ary[g_idx].plant) THEN CONTINUE FOR END IF
   #No.FUN-A10098 -END-------
        #依發票帳款編號讀apa_file 資料
        LET l_sql="SELECT apa_file.*,gec06,gec08 ",
                 #No.FUN-A10098 -BEGIN-----
                 #"  FROM ",g_ary[g_idx].dbs_new CLIPPED," apa_file,",
                 #"    ",g_ary[g_idx].dbs_new CLIPPED," gec_file",
                  "  FROM apa_file,gec_file",
                 #No.FUN-A10098 -END-------
                  " WHERE  apa01 = ?  ",   #No.+111 010510 by plum
                  "   AND apa42 = 'N' ",
                  "   AND apa15 = gec_file.gec01 ",
                  "   AND gec011= '1' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        PREPARE p520_preapa FROM l_sql
        DECLARE p520_curapa SCROLL CURSOR WITH HOLD FOR p520_preapa
 
        #----抓傳票編號用--------------------------
        LET l_sql = "SELECT apa_file.* FROM apv_file,apa_file ",
                    " WHERE apv03 = ? ",
                    "   AND apa42 = 'N' ",
                    "   AND apv01 = apa01 "
        PREPARE show_ref_p2   FROM l_sql
      DECLARE show_ref_c2   CURSOR FOR show_ref_p2
 
        LET l_sql = "SELECT apf_file.* ",
                    "  FROM apf_file,aph_file ",
                    " WHERE aph04 = ? ",
                    "   AND apf01 = aph01 ",
                    "   AND apf41 <> 'X' "
        PREPARE show_ref_p3   FROM l_sql
        DECLARE show_ref_c3   CURSOR FOR show_ref_p3
 
        #-->進項資料(單一發票)--折讓
        LET l_sql ="SELECT apk01,apk03,apk17,apk171,apk172,apk04,apk05,apk26, ",
                    "SUM(apk06),SUM(apk07),SUM(apk08) ",
                  #No.FUN-A10098 -BEGIN-----
                  # "  FROM ",g_ary[g_idx].dbs_new CLIPPED," apa_file,",
                  # "",g_ary[g_idx].dbs_new CLIPPED," apb_file, apk_file",
                  # "  , ",g_ary[g_idx].dbs_new CLIPPED," gec_file",
                    "  FROM apa_file,apb_file,apk_file,gec_file",
                  #No.FUN-A10098 -END-------
                    " WHERE apa00 = '21' AND apaacti = 'Y' ",   
                    "   AND apa42 = 'N' ",
                    "   AND (apa175 IS NULL OR apa175 = 0) ",
                    "   AND apa15 = gec_file.gec01  AND gec011= '1' ",
                    "   AND apa01 = apb01  AND apb01=apk01  AND apb02=apk02 ",
                    "   AND apb11 IS NOT NULL AND apb11 <> ' '", #發票號碼   
                    "   AND ",tm.wc CLIPPED
        IF NOT cl_null(tm.sure) THEN
           LET l_sql = l_sql CLIPPED," AND apa41='",tm.sure,"' "
        END IF
        LET l_sql = l_sql CLIPPED,"  GROUP BY apk01,apk03,apk17,apk171,apk172,apk04,apk05,apk26 "
        #-----MOD-6C0151---------
        #                          "  ORDER BY 1,2 "
        LET l_sql = l_sql CLIPPED," UNION ", 
                    "SELECT apk01,apk03,apk17,apk171,apk172,apk04,apk05,apk26, ",
                    "SUM(apk06),SUM(apk07),SUM(apk08) ",
                  #No.FUN-A10098 -BEGIN-----
                  # "  FROM ",g_ary[g_idx].dbs_new CLIPPED," apa_file,apk_file",
                  # "  , ",g_ary[g_idx].dbs_new CLIPPED," gec_file",
                    "  FROM apa_file,apk_file,gec_file",
                  #No.FUN-A10098 -END-------
                    " WHERE apaacti = 'Y' ",  
                    "   AND apa08 <> 'MISC' ",
                    "   AND apa42 = 'N' ",
                    "   AND (apa175 IS NULL OR apa175 = 0) ",
                    "   AND apa15 = gec_file.gec01  AND gec011= '1' ",
                    "   AND apa01 = apk01 ",
                    "   AND ",tm.wc CLIPPED
        IF NOT cl_null(tm.sure) THEN
           LET l_sql = l_sql CLIPPED," AND apa41='",tm.sure,"' "
        END IF
        LET l_sql = l_sql CLIPPED,"  GROUP BY apk01,apk03,apk17,apk171,apk172,apk04,apk05,apk26 ",
                                  "  ORDER BY 1,2 "
        #-----END MOD-6C0151-----
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        PREPARE p520_21_apkp FROM l_sql
        DECLARE p520_21_apk SCROLL CURSOR WITH HOLD FOR p520_21_apkp
        LET old_apk01='@@@@@@@@'
        FOREACH p520_21_apk INTO l_apk.apk01 ,l_apk.apk03 ,l_apk.apk17,
                                 l_apk.apk171,l_apk.apk172,l_apk.apk04,
                                 l_apk.apk05 ,l_apk.apk26 ,l_apk.apk06,
                                 l_apk.apk07,l_apk.apk08
           IF SQLCA.sqlcode THEN
              CALL cl_err('p520_curapa',SQLCA.sqlcode,0)
              EXIT FOREACH
           END IF
           IF old_apk01<> l_apk.apk01 THEN LET l_num=0 END IF
           LET old_apk01=l_apk.apk01
           message l_apk.apk01
           CALL ui.Interface.refresh()
           #讀取該發票之帳款資料
           OPEN  p520_curapa  USING l_apk.apk01
           FETCH p520_curapa  INTO l_apa.*,l_gec06,l_gec08
           CLOSE p520_curapa
           IF cl_null(l_apa.apa171) THEN LET l_apa.apa171 = l_gec08 END IF
           IF cl_null(l_apa.apa172) THEN LET l_apa.apa172 = l_gec06 END IF
           #-----更改格式及應稅否
           IF l_apa.apa171 = '21' THEN   #進項三聯式
              LET l_apa.apa171 = '23'    #三聯式,退出折讓
           END IF
           IF l_apa.apa171 = '22' THEN   #載有稅額的其他憑證
              LET l_apa.apa171 = '24'    #二聯式
           END IF
           IF l_apa.apa171 = '25' THEN   #收銀機
              LET l_apa.apa171 = '23'    #三聯式,退出折讓
           END IF
           #----gec08 = 'XX' 不申報
          #IF cl_null(l_gec08) OR l_gec08 = 'XX' THEN CONTINUE FOREACH END IF               #No:5878
           IF cl_null(l_apa.apa171) OR l_apa.apa171 = 'XX' THEN CONTINUE FOREACH END IF     #No:5878
           LET l_invoice=l_apk.apk03    #發票號碼
           #-->憑證日期不可為兩期之前資料
           IF l_apa.apa00 = '21' THEN
              LET l_guidate = l_apa.apa02    #  帳款日
           ELSE
              LET l_guidate = l_apa.apa09    #  發票日
           END IF
           LET l_apa00=l_apa.apa00
           LET l_apa44 = ''          #MOD-9A0023 add
           #--------傳票號碼
           #-----MOD-6C0151---------
           #IF l_apa.apa58 = '1' THEN #請款折讓
           IF l_apa.apa58 = '1' OR l_apa.apa58 IS NULL THEN #請款折讓
              IF l_apa.apa58 IS NULL THEN
                 OPEN  p520_curapa  USING l_apk.apk01
                 FETCH p520_curapa  INTO t_apa.*,l_gec06,l_gec08
                 CLOSE p520_curapa
              ELSE
           #-----END MOD-6C0151-----
           #讀取該折讓單對應之請款資料
                 OPEN  p520_curapa  USING l_apk.apk26
                 FETCH p520_curapa  INTO t_apa.*,l_gec06,l_gec08
                 CLOSE p520_curapa
              END IF   #MOD-6C0151
              LET l_apa44 = t_apa.apa44
             #IF cl_null(l_apa44) THEN LET l_apa44=t_apa.apa44   END IF   #MOD-6C0151
              IF cl_null(t_apa.apa16) THEN LET t_apa.apa16 = 0   END IF
              #資料年月以傳票日期為主
              IF t_apa.apa43 IS NOT NULL THEN
                  LET l_yy  = YEAR(t_apa.apa43)
                  LET l_mm  = MONTH(t_apa.apa43)
              ELSE
                  LET l_yy  = YEAR(t_apa.apa02)
                  LET l_mm  = MONTH(t_apa.apa02)
              END IF
              LET l_num=l_num+1
              INSERT INTO r520_file VALUES(l_apk.apk01 ,l_num ,'2',l_invoice,
                           l_apk.apk04 ,l_apk.apk05 ,l_apk.apk06, l_apk.apk07,
                           l_apk.apk08 ,' ',' ', l_apk.apk17,l_apk.apk171,
                           l_apk.apk172,l_yy,l_mm,'','',
                         # g_ary[g_idx].plant, '','',l_apa44,'1', 'N', #No.FUN-A10098
                           '','','',l_apa44,'1', 'N',                  #No.FUN-A10098
                           'Y',l_apauser,l_apagrup,'',g_today,l_apa00,l_apa41)
             #IF SQLCA.sqlcode<> -239 AND SQLCA.SQLCODE <>0 THEN                     #TQC-790091 mark
              IF ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) AND SQLCA.SQLCODE <>0 THEN  #TQC-790091 mod
                 LET g_success='N' CALL cl_err(l_apk.apk01,SQLCA.SQLCODE,1)
                 EXIT FOREACH
              END IF
           ELSE
             #-MOD-B10037-add-
              LET l_apa44 = l_apa.apa44
              LET l_t1 = ''   
              LET l_apydmy3 = ''
              LET l_t1 = s_get_doc_no(l_apk.apk01)
              SELECT apydmy3 INTO l_apydmy3 
                FROM apy_file 
               WHERE apyslip = l_t1
             #-MOD-B10037-end-
              #非請款折讓
              LET l_yy  = YEAR(l_apa.apa02)
              LET l_mm  = MONTH(l_apa.apa02)
              #-抓傳票編號(先抓直接沖帳檔[apv_file)，再抓付款單[apf_file])---
              OPEN  show_ref_c2  USING l_apk.apk01
              FETCH show_ref_c2  INTO  f_apa.*
              IF STATUS THEN
                #No:5878
                 IF l_apydmy3 = 'N' THEN                                         #MOD-B10037 
                    OPEN  show_ref_c3  USING l_apk.apk01                         #MOD-B10037 remark
                    FETCH show_ref_c3  INTO  f_apf.*                             #MOD-B10037 remark
                    IF STATUS THEN SLEEP 0 ELSE LET l_apa44 = f_apf.apf44 END IF #MOD-B10037 remark
                    CLOSE show_ref_c3                                            #MOD-B10037 remark
                #-MOD-B10037-add-
                 ELSE                  
                    IF cl_null(l_apa44) THEN   
                       LET l_apa44 = f_apa.apa44  
                    END IF   
                 END IF   
                #-MOD-B10037-end-
              ELSE
                 LET l_apa44 = f_apa.apa44
              END IF
              CLOSE show_ref_c2
              LET l_num=l_num+1
              INSERT INTO r520_file VALUES(l_apk.apk01 ,l_num ,'2',l_invoice,
                            l_apk.apk04 ,l_apk.apk05 ,l_apk.apk06, l_apk.apk07,
                            l_apk.apk08 ,' ',' ', l_apk.apk17,l_apk.apk171,
                            l_apk.apk172,l_yy,l_mm,'','',
                          # g_ary[g_idx].plant, '','',l_apa44,'1', 'N', #No.FUN-A10098
                            '','','',l_apa44,'1', 'N',                  #No.FUN-A10098
                            'Y',l_apauser,l_apagrup,'',g_today,l_apa00,l_apa41)
              #IF SQLCA.sqlcode<> -239 AND SQLCA.SQLCODE <>0 THEN                     #TQC-790091 mark
               IF ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) AND SQLCA.SQLCODE <>0 THEN  #TQC-790091 mod
                  LET g_success='N' CALL cl_err(l_apk.apk01,SQLCA.SQLCODE,1)
                  EXIT FOREACH
               END IF
           END IF
        END FOREACH
       #IF g_success='N' THEN EXIT FOR END IF   #No.FUN-A10098
 
        INITIALIZE l_apk.* TO NULL
        #-->進項資料(多發票資料)
        #-->BUGNO4197 加取格式28 的資料
        LET l_sql="SELECT apk01,apk02,apk03,apk04,apk05,apk06,apk07,apk08,",
                  " apk09,apk10,apk17,apk171,apk172,apa02,",
                  " apa44,apa43,gec06,gec08,",
                  " apa06,apa07,apa02,apa02  ",
                 #No.FUN-A10098 -BEGIN-----
                 #" FROM  ",g_ary[g_idx].dbs_new CLIPPED," apk_file,",
                 #"  ",g_ary[g_idx].dbs_new CLIPPED," apa_file,",
                 #"  ",g_ary[g_idx].dbs_new CLIPPED," gec_file ",
                  " FROM apk_file,apa_file,gec_file ",
                 #No.FUN-A10098 END-------
                  " WHERE apk01 = apa01 AND apa08='MISC' ",     #No:5878 不然同資料會出現二筆
                  #"   AND apa41 = 'Y' AND apaacti = 'Y' ",   #MOD-6C0151
                  "   AND apaacti = 'Y' ",   #MOD-6C0151
                  "   AND apa00 <> '21' ",   #CHI-D30022
                  "   AND (apk175 IS NULL  OR apk175 = 0) ",
                  #-----MOD-750055---------
                  #"   AND ((apk171 = '21' AND apk172 IN ('1','2','3')) ",
                  #"    OR  (apk171 = '22' AND apk172 = '1') ",
                  #"    OR  (apk171 = '25' AND apk172 IN ('1','2','3')) ",
                  #"    OR  (apk171 = '28' AND apk172 IN ('1','2','3')) ",   #No:8178多一個)
                  #"    OR  (apk171 = '29' AND apk172 IN ('1','2','3')))",   #no:7393
                  "   AND ((apk171 = '21' AND apk172 IN ('1','2','3')) ",
                  "    OR  (apk171 = '22' AND apk172 = '1') ",
                  "    OR  (apk171 = '23' AND apk172 IN ('1','2','3')) ",   #MOD-B10037
                  "    OR  (apk171 = '24' AND apk172 = '1') ",              #MOD-B10037 
                  "    OR  (apk171 = '25' AND apk172 IN ('1','2','3')) ",
                  "    OR  (apk171 = '26' AND apk172 IN ('1','2','3')) ",   
                  "    OR  (apk171 = '27' AND apk172 = '1') ", 
                  "    OR  (apk171 = '28' AND apk172 IN ('1','2','3')) ",   #No:8178多一個)
                  "    OR  (apk171 = '29' AND apk172 IN ('1','2','3')))",   #no:7393
                  #-----END MOD-750055-----
                  "   AND apa15 = gec_file.gec01",
                  "   AND gec011= '1' ",
                  "   AND ",tm.wc CLIPPED
        IF NOT cl_null(tm.sure) THEN
           LET l_sql = l_sql CLIPPED," AND apa41='",tm.sure,"' "
        END IF
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        PREPARE p520_g_preapk FROM l_sql
        DECLARE p520_g_curapk CURSOR FOR p520_g_preapk
 
        LET l_sql = "SELECT apb11 ",
                  # "  FROM ",g_ary[g_idx].dbs_new CLIPPED,"apb_file", #No.FUN-A10098
                    "  FROM apb_file",                                 #No.FUN-A10098
                    " WHERE apb01 = ? ",
                    "   AND apb02 = ? "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        PREPARE p520_g_preapb2  FROM l_sql
        DECLARE p520_g_apbcur2  CURSOR FOR p520_g_preapb2
 
        FOREACH p520_g_curapk INTO l_apk.apk01,l_apk.apk02,l_apk.apk03,
                                   l_apk.apk04,
                                   l_apk.apk05,l_apk.apk06,l_apk.apk07,
                                   l_apk.apk08,l_apk.apk09,l_apk.apk10,
                                   l_apk.apk17,l_apk.apk171,l_apk.apk172,
                                   l_apa02,l_apa44,l_apa43,l_gec06,l_gec08,
                                   l_amd40,l_amd41,l_amd42,l_amd43
           IF SQLCA.sqlcode THEN
              CALL cl_err('p520_curapk',SQLCA.sqlcode,0)
              EXIT FOREACH
           END IF
           MESSAGE l_apk.apk01
           CALL ui.Interface.refresh()
           IF cl_null(l_apk.apk171) THEN LET l_apk.apk171 = l_gec08 END IF
           IF cl_null(l_apk.apk172) THEN LET l_apk.apk172 = l_gec06 END IF
          #IF cl_null(l_gec08) OR l_gec08 = 'XX' THEN CONTINUE FOREACH END IF             #No:5878
           IF cl_null(l_apk.apk171) OR l_apk.apk171 = 'XX' THEN CONTINUE FOREACH END IF   #No:5878
           IF l_apk.apk171 = '23' THEN
              OPEN p520_g_apbcur2 USING l_apk.apk01,l_apk.apk02
              FETCH p520_g_apbcur2 INTO l_invoice
              IF STATUS THEN LET l_invoice = '' END IF
           ELSE
              LET l_invoice = l_apk.apk03
           END IF
           #-->憑證日期不可為兩期之前資料
           LET l_guidate = l_apk.apk05    #  發票日
           CALL s_azn01(g_ama.ama08,g_ama.ama09) RETURNING t_bdate,t_edate
           LET t_bdate = t_bdate - g_ama.ama10 UNITS MONTH + 1 UNITS MONTH
           LET l_yy    =YEAR(l_apa43)
           LET l_mm    =MONTH(l_apa43)
           IF cl_null(l_apa44) THEN LET l_apa44 = ' ' END IF
           INSERT INTO r520_file VALUES(l_apk.apk01 ,l_apk.apk02 ,'5',l_invoice,
                           l_apk.apk04 ,l_apk.apk05 ,l_apk.apk06, l_apk.apk07,
                           l_apk.apk08 ,l_apk.apk09 ,l_apk.apk10, l_apk.apk17,
                           l_apk.apk171,l_apk.apk172,l_yy,l_mm,'', '',
                         # g_ary[g_idx].plant, '','',l_apa44,'1', 'N', #No.FUN-A10098
                           '','','',l_apa44,'1', 'N',                  #No.FUN-A10098
                           'Y',l_apauser,l_apagrup,'',g_today,l_apa00,l_apa41)
          #IF SQLCA.sqlcode <>0 AND SQLCA.SQLCODE <>-239 THEN                      #TQC-790091 mark
           IF SQLCA.sqlcode <>0 AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) )  THEN  #TQC-790091 mod
              CALL cl_err(l_apk.apk01,SQLCA.sqlcode,1)
              LET g_success = 'N'
              EXIT FOREACH
           END IF
        END FOREACH
  # END FOR        #No.FUN-A10098 mark
    LET s_abb07=0
    #讀取暫存中媒體申報資料
    DECLARE r520_cus3 CURSOR FOR
      SELECT * FROM r520_file WHERE amd28 IS NULL OR amd28=' '
    FOREACH r520_cus3 INTO sr.*,l_apa00,l_apa41
        IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF
           LET l_abb07=0
           LET l_err="無傳票編號"
           LET l_abb07_1=0   #CHI-D30022
#No.FUN-750093---------------begin--------------------
           LET l_gen02=''
           SELECT gen02 INTO l_gen02
               FROM gen_file
           WHERE gen01=sr.amduser
           IF SQLCA.SQLCODE OR cl_null(l_gen02) THEN
           LET l_gen02=sr.amduser
           END IF
           EXECUTE insert_prep USING
                  sr.amd28,sr.amd01,sr.amd03,l_gen02,sr.amd08,sr.amd07,
                 #l_abb07,l_err,sr.amduser             #CHI-D30022 mark
                  l_abb07,l_err,sr.amduser,l_abb07_1   #CHI-D30022
     #     OUTPUT TO REPORT r520_rep(sr.*,l_abb07,l_err)
#No.FUN-750093---------------end---------------------
    END FOREACH
    #依傳票編號加總其稅額
    DECLARE r520_cus4 CURSOR FOR
     SELECT amd28,SUM(amd07) FROM r520_file
      WHERE amd28 IS NOT NULL AND amd28<>' '
      GROUP BY amd28
    FOREACH r520_cus4 INTO l_amd28,l_amd07
        IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF
        #讀取該傳票之稅額
        LET l_abb07 =0
{
        SELECT sum(abb07) INTO l_abb07 FROM abb_file
         WHERE abb01=l_amd28 AND abb03='126400'
}
        #BUGNO4209
        SELECT sum(abb07) INTO l_abb07 FROM abb_file
         WHERE abb01=l_amd28 AND abb03=tm.actno
                             AND abb00=tm.e  #no.7277
        IF SQLCA.SQLCODE <>0 THEN LET l_abb07 = 0 END IF
        #判斷與該筆資料之稅額是否相同, 不同出檢查表
        IF l_amd07 <> l_abb07 THEN
             DECLARE r520_cus5 CURSOR FOR
               SELECT * FROM r520_file
                WHERE amd28 IS NOT NULL AND amd28<>' '
                  AND amd28=l_amd28
             LET l_abb07_1=0   #CHI-D30022
             LET l_flag=0      #CHI-D30022
             FOREACH r520_cus5 INTO sr.*,l_apa00,l_apa41
               LET l_err="稅額不合"
              #CHI-D30022--str
               IF l_flag=0 THEN
                  LET l_abb07_1=l_abb07
                  LET l_flag=1
               ELSE
                  LET l_abb07_1=0
               END IF
              #CHI-D30022--end
#No.FUN-750093---------------begin--------------------          
               LET l_gen02=''
               SELECT gen02 INTO l_gen02
                    FROM gen_file
               WHERE gen01=sr.amduser
               IF SQLCA.SQLCODE OR cl_null(l_gen02) THEN
               LET l_gen02=sr.amduser
               END IF                                                                    
           EXECUTE insert_prep USING                                                                                                
                  sr.amd28,sr.amd01,sr.amd03,l_gen02,sr.amd08,sr.amd07,                                                             
                 #l_abb07,l_err,sr.amduser             #CHI-D30022 mark                                        
                  l_abb07,l_err,sr.amduser,l_abb07_1   #CHI-D30022
          #    OUTPUT TO REPORT r520_rep(sr.*,l_abb07,l_err)
#No.FUN-750093------------------END-------------------
             END FOREACH
        END IF
    END FOREACH
#No.FUN-750093---------------begin--------------------   
#   FINISH REPORT r520_rep
#   DROP TABLE r520_file
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
#    SELECT azi04,azi05 INTO g_azi04,g_azi05 FROM azi_file   #TQC-950109 
    LET g_str=tm.wc,";",g_azi04,";",g_azi05
    LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    CALL cl_prt_cs3('amdr520','amdr520',l_sql,g_str)
#No.FUN-750093------------------END-------------------
END FUNCTION
#No.FUN-750093---------------begin-----------
{
REPORT r520_rep(sr,l_abb07,l_err)
DEFINE l_last_sw    LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
       l_idx        LIKE type_file.num5,       #No.FUN-680074 SMALLINT
       l_err        LIKE ze_file.ze03,         #No.FUN-680074 VARCHAR(16)
       l_str        LIKE type_file.chr1000,    #No.FUN-680074 VARCHAR(70)
       l_apa41      LIKE apa_file.apa41,          #確認碼
       l_apa00      LIKE apa_file.apa00,          #帳款性質
       l_cnt        LIKE type_file.num5,          #No.FUN-680074 SMALLINT
       s_amd07      LIKE abb_file.abb07,          #稅額
       l_abb07      LIKE abb_file.abb07,          #稅額
       l_gen02      LIKE gen_file.gen02,
      #sr           RECORD  LIKE amd_file.*
          sr  RECORD
               amd01     LIKE amd_file.amd01,     #傳票編號
               amd02     LIKE amd_file.amd02,     #No.FUN-680074 SMALLINT#項次
               amd021    LIKE amd_file.amd021,    #來源
               amd03     LIKE amd_file.amd03,     #發票號碼
               amd04     LIKE amd_file.amd04,     #廠商統一編號
               amd05     LIKE amd_file.amd05,     #No.FUN-680074 DATE#發票日期/憑證日期
               amd06     LIKE amd_file.amd06,     #含稅金額
               amd07     LIKE amd_file.amd07,     #稅
               amd08     LIKE amd_file.amd08,     #未稅金額
               amd09     LIKE amd_file.amd09,     #彙加註記
               amd10     LIKE amd_file.amd10,     #洋菸酒註記
               amd17     LIKE amd_file.amd17,     #扣抵區分 (1,2)
               amd171    LIKE amd_file.amd171,    #格式(21,22,23,24,25,26,27)
               amd172    LIKE amd_file.amd172,    #課稅別(1應稅 2零稅率 3免稅)
               amd173    LIKE amd_file.amd173,    #資料年
               amd174    LIKE amd_file.amd174,    #資料月份
               amd175    LIKE amd_file.amd175,    #申報流水編號
               amd22     LIKE amd_file.amd22,     #申報部門
               amd25     LIKE amd_file.amd25,     #工廠編號
               amd26     LIKE amd_file.amd26,     #申報年度
               amd27     LIKE amd_file.amd27,     #申報月份
               amd28     LIKE amd_file.amd28,     #傳票號碼
               amd29     LIKE amd_file.amd29,     #是否檢查發票字軌(Y/N)
               amd30     LIKE amd_file.amd30,     #確認碼
               amdacti   LIKE amd_file.amdacti,   #資料有效碼
               amduser   LIKE amd_file.amduser,   #資料所有者
               amdgrup   LIKE amd_file.amdgrup,   #資料所有群
               amdmodu   LIKE amd_file.amdmodu,   #資料更改者
               amddate   LIKE amd_file.amddate,   #最近修改日
               apa00     LIKE apa_file.apa00,     #帳款性質
               apa41     LIKE apa_file.apa41      #確認否
               END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.amduser,sr.amd28,sr.amd01,sr.amd03
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      #讀取輸入人員姓名
      LET l_gen02=''
      SELECT gen02 INTO l_gen02
        FROM gen_file
       WHERE gen01=sr.amduser
      IF SQLCA.SQLCODE OR cl_null(l_gen02) THEN
         LET l_gen02=sr.amduser
      END IF
      PRINT COLUMN g_c[31], sr.amd28,
#            COLUMN g_c[32],sr.amd01[1,10],
            COLUMN g_c[32],sr.amd01,   #No.FUN-560247
            COLUMN g_c[33],sr.amd03,
            COLUMN g_c[34],l_gen02[1,8],
            COLUMN g_c[35],cl_numfor(sr.amd08,35,g_azi04),
            COLUMN g_c[36],cl_numfor(sr.amd07,36,g_azi04),
            COLUMN g_c[37],cl_numfor(l_abb07,37,g_azi04),
            COLUMN g_c[38],l_err CLIPPED
 
   AFTER GROUP OF sr.amd28
      LET s_amd07 = GROUP SUM(sr.amd07)
      PRINT COLUMN g_c[31],g_x[10] CLIPPED,
            COLUMN g_c[32],g_x[11] CLIPPED,
            COLUMN g_c[33],cl_numfor(GROUP SUM(sr.amd08),33,g_azi05),
            COLUMN g_c[34],g_x[12] CLIPPED,
            COLUMN g_c[35],cl_numfor(GROUP SUM(sr.amd07),35,g_azi05),
            COLUMN g_c[36],g_x[13] CLIPPED,
            COLUMN g_c[37],cl_numfor(s_amd07-l_abb07,37,g_azi05)
      SKIP 1 LINE
      LET s_abb07 = s_abb07+l_abb07
 
 
   ON LAST ROW
      LET s_amd07 = SUM(sr.amd07)
      PRINT COLUMN g_c[31],g_x[14] CLIPPED,
            COLUMN g_c[32],g_x[15] CLIPPED,
            COLUMN g_c[33],cl_numfor(SUM(sr.amd07),33,g_azi05),
            COLUMN g_c[34],g_x[13] CLIPPED,
            COLUMN g_c[35],cl_numfor(s_amd07-s_abb07,35,g_azi05)
      PRINT g_dash[1,g_len]
      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
 
END REPORT
}
#No.FUN-750093------------------END-------------------    
#Patch....NO.TQC-610035 <001> #
