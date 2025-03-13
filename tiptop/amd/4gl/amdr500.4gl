# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: amdr500.4gl
# Descriptions...: 進項憑証檢核表
# Date & Author..: 99/03/01 By Linda
# Modify.........: No.B601 010528 by linda modify 將讀資料之條件改成和
#                  amdp020.4gl 擷取之條件相同
# Modify.........: No.9017 04/01/12 By Kitty plant長度修改
# Modify.........: No.MOD-470603 04/07/30 By Wiky tm.b,tm.c要default
# Modify.........: No.FUN-510019 05/01/11 By Smapmin 報表轉XML格式
# Modify.........: No.TQC-610057 06/01/24 By Kevin 修改外部參數接收
# Modify.........: No.FUN-680074 06/08/25 By huchenghao 類型轉換
# Modify.........: No.FUN-690116 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.MOD-750055 07/05/15 By Smapmin 增加格式26,27的抓取
# Modify.........: No.FUN-750129 07/06/14 By Carrier 報表轉Crystal Report格式
# Modify.........: No.TQC-770115 07/07/24 By Dido 增加發票聯數
# Modify.........: NO.TQC-790093 07/09/20 BY yiting Primary Key的-268訊息 程式修改
# Modify.........: No.TQC-790177 07/09/29 By Carrier 去掉全型字符
# Modify.........: No.TQC-860019 08/06/09 By cliare ON IDLE 控制調整
# Modify.........: No.FUN-860041 08/06/11 By Carol 民國年欄位放大為3位
#
# Modify.........: No.FUN-940102 09/04/20 By dxfwo  新增使用者對營運中心的權限管控
# Modify.........: No.TQC-950074 09/06/09 By baofei 解決溢位問題
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-990228 09/09/24 By mike PREPARE p020_g_preapk的l_sql,请增加抓取apkuser   
# Modify.........: No:FUN-A10098 10/01/18 By shiwuying GP5.2跨DB報表--財務類
# Modify.........: No:CHI-B20012 11/02/24 By Summer 若勾選"只印出有問題的資料",但整份報表都沒有有問題的資料時,報表應該就不要印出來 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
            wc          LIKE type_file.chr1000,    #No.FUN-680074 VARCHAR(1000)
            sure        LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
            b           LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1) #是否只列印有問題的資料
            c           LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
            more        LIKE type_file.chr1        #No.FUN-680074 VARCHAR(1)
           END RECORD
#No.FUN-A10098 -BEGIN-----
#DEFINE    g_ary  ARRAY [08] OF RECORD
#              plant   LIKE azp_file.azp01,       #No.FUN-680074  VARCHAR(10)#No:9017
#              dbs_new LIKE type_file.chr21       #No.FUN-680074  VARCHAR(21)
#          END RECORD
#No.FUN-A10098 -END-------
DEFINE g_cal  DYNAMIC ARRAY OF RECORD
              mony  LIKE amd_file.amd08,
              tax   LIKE amd_file.amd07,
              cnt   LIKE type_file.num5       #No.FUN-680074 SMALLINT
           END RECORD
DEFINE g_amd08 LIKE amd_file.amd08
DEFINE g_amd07 LIKE amd_file.amd07
    DEFINE f_apa    RECORD LIKE apa_file.*
    DEFINE f_apf    RECORD LIKE apf_file.*
DEFINE g_dash_1 LIKE type_file.chr1000        #No.FUN-680074 VARCHAR(200)
DEFINE l_cnt    LIKE type_file.num5           #No.FUN-680074 SMALLINT
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
DEFINE g_tot48      LIKE type_file.num20_6,       #No.FUN-680074 DECIMAL(20,6)
       g_tot49      LIKE type_file.num20_6,       #No.FUN-680074 DECIMAL(20,6)
       o_tot48      LIKE type_file.num20_6,       #No.FUN-680074 DECIMAL(20,6)
       o_tot49      LIKE type_file.num20_6,       #No.FUN-680074 DECIMAL(20,6)
       l_tot48      LIKE type_file.num20_6,       #No.FUN-680074 DECIMAL(20,6)
       l_tot49      LIKE type_file.num20_6        #No.FUN-680074 DECIMAL(20,6)
DEFINE g_title      LIKE type_file.chr1000        #No.FUN-680074 VARCHAR(30)
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680074 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680074 VARCHAR(72)
#No.FUN-750129  --Begin
DEFINE l_table   STRING
DEFINE g_str     STRING
DEFINE g_str2    STRING
DEFINE g_sql     STRING
DEFINE g_str1    ARRAY [10] OF LIKE type_file.chr1000
DEFINE g_sr1     RECORD
	         mark1  LIKE type_file.chr1,
	         mark2  LIKE type_file.chr1,
	         mark3  LIKE type_file.chr1,
	         mark4  LIKE type_file.chr1,
	         mark5  LIKE type_file.chr1,
	         mark6  LIKE type_file.chr1,
	         mark7  LIKE type_file.chr1,
                 mark8  LIKE type_file.chr1,
                 mark9  LIKE type_file.chr1 
                 END RECORD 
#No.FUN-750129  --End  
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
 
   #No.FUN-750129  --Begin
   LET g_sql = " amd01.amd_file.amd01,",
               " amd03.amd_file.amd03,",
               " amd04.amd_file.amd04,",
               " amd05.amd_file.amd05,",
               " amd07.amd_file.amd07,",
               " amd08.amd_file.amd08,",
               " amd17.amd_file.amd17,",
               " amd171.amd_file.amd171,",
               " amd172.amd_file.amd172,",
               " amd173.amd_file.amd173,",
               " amd174.amd_file.amd174,",
               " amd28.amd_file.amd28,",
               " amduser.amd_file.amduser,",
               " apa00.apa_file.apa00,",
               " str.type_file.chr1000,",
               " str1.type_file.chr1000,",
               " str3.type_file.chr1000,",
               " str5.type_file.chr1000,",
               " str6.type_file.chr1000,",
               " str7.type_file.chr1000,",
               " str8.type_file.chr1000,",
               " str9.type_file.chr1000,",
               " str10.type_file.chr1000,",
               " apa41.apa_file.apa41,",
               " gen02.gen_file.gen02,",
               " mark1.type_file.chr1,",
               " mark2.type_file.chr1,",
               " mark3.type_file.chr1,",
               " mark4.type_file.chr1,",
               " mark5.type_file.chr1,",
               " mark6.type_file.chr1,",
               " mark7.type_file.chr1,",
               " mark8.type_file.chr1,",
               " mark9.type_file.chr1 " 
 
   LET l_table = cl_prt_temptable('amdr500',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?,  ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,  ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,  ",
               "        ?, ?, ?, ?  )                  " 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-750129  --End
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
#-----TQC-610057---------
  #No.FUN-A10098 -BEGIN-----
  #LET g_plant_1 = ARG_VAL(7)
  #LET g_plant_2 = ARG_VAL(8)
  #LET g_plant_3 = ARG_VAL(9)
  #LET g_plant_4 = ARG_VAL(10)
  #LET g_plant_5 = ARG_VAL(11)
  #LET g_plant_6 = ARG_VAL(12)
  #LET g_plant_7 = ARG_VAL(13)
  #LET g_plant_8 = ARG_VAL(14)
  #LET tm.sure   = ARG_VAL(15)
  #LET tm.b      = ARG_VAL(16)
  #LET tm.c      = ARG_VAL(17)
  #LET tm.wc     = ARG_VAL(18)
  ##No.FUN-570264 --start--
  #LET g_rep_user = ARG_VAL(19)
  #LET g_rep_clas = ARG_VAL(20)
  #LET g_template = ARG_VAL(21)
  #LET g_rpt_name = ARG_VAL(22)  #No.FUN-7C0078
  ##No.FUN-570264 ---end---
   LET tm.sure   = ARG_VAL(7)
   LET tm.b      = ARG_VAL(8)
   LET tm.c      = ARG_VAL(9)
   LET tm.wc     = ARG_VAL(10)
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)
  #No.FUN-A10098 -END-------
#-----END TQC-610057-----
   LET g_amd08 = 0
   LET g_amd07 = 0
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r500_tm(0,0)
      ELSE CALL r500()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION r500_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680074 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680074 VARCHAR(1000)
   DEFINE li_result      LIKE type_file.num5          #No.FUN-940102
 
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 12 END IF
        LET p_row = 3 LET p_col = 18
   OPEN WINDOW r500_w AT p_row,p_col
        WITH FORM "amd/42f/amdr500"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.sure ='Y'
   LET tm.b ='Y'
   LET tm.c ='3'
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON  apa01, apa02,apa171,apa17,apa172,
                              apa22,apa00,apauser
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
 END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r500_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
      
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #       LET tm.wc = tm.wc clipped," AND apauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET tm.wc = tm.wc clipped," AND apagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET tm.wc = tm.wc clipped," AND apagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('apauser', 'apagrup')
   #End:FUN-980030
 
  #No.FUN-A10098 -BEGIN-----
  #LET g_plant_1 = g_plant
  #INPUT g_plant_1,g_plant_2,g_plant_3,g_plant_4,
  #       g_plant_5, g_plant_6,g_plant_7,g_plant_8,
  #       tm.sure,tm.b,tm.c,tm.more WITHOUT DEFAULTS
  #  FROM plant_1, plant_2, plant_3, plant_4 ,
  #       plant_5, plant_6, plant_7, plant_8  ,
  #       sure,b,c,more
   INPUT tm.sure,tm.b,tm.c,tm.more WITHOUT DEFAULTS
     FROM sure,b,c,more
 
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
  #               LET g_ary[1].dbs_new = g_dbs_new
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
  #               LET g_ary[2].dbs_new = g_dbs_new
  # #No.FUN-940102 --begin--
  #            CALL s_chk_demo(g_user,g_plant_2) RETURNING li_result
  #             IF not li_result THEN 
  #              NEXT FIELD plant_2
  #             END IF 
  # #No.FUN-940102 --end-- 
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
  #               LET g_ary[3].dbs_new = g_dbs_new
  # #No.FUN-940102 --begin--
  #            CALL s_chk_demo(g_user,g_plant_3) RETURNING li_result
  #             IF not li_result THEN 
  #              NEXT FIELD plant_3
  #             END IF 
  # #No.FUN-940102 --end-- 
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
  #               LET g_ary[4].dbs_new = g_dbs_new
  #  #No.FUN-940102 --begin--
  #            CALL s_chk_demo(g_user,g_plant_4) RETURNING li_result
  #             IF not li_result THEN 
  #              NEXT FIELD plant_4
  #             END IF 
  #  #No.FUN-940102 --end-- 
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
  #               LET g_ary[5].dbs_new = g_dbs_new
  #  #No.FUN-940102 --begin--
  #            CALL s_chk_demo(g_user,g_plant_5) RETURNING li_result
  #             IF not li_result THEN 
  #              NEXT FIELD plant_5
  #             END IF 
  #  #No.FUN-940102 --end-- 
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
  #               LET g_ary[6].dbs_new = g_dbs_new
  #   #No.FUN-940102 --begin--
  #            CALL s_chk_demo(g_user,g_plant_6) RETURNING li_result
  #             IF not li_result THEN 
  #              NEXT FIELD plant_6
  #             END IF 
  #   #No.FUN-940102 --end-- 
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
  #               LET g_ary[7].dbs_new = g_dbs_new
  #   #No.FUN-940102 --begin--
  #            CALL s_chk_demo(g_user,g_plant_7) RETURNING li_result
  #             IF not li_result THEN 
  #              NEXT FIELD plant_7
  #             END IF 
  #   #No.FUN-940102 --end-- 
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
  #               LET g_ary[8].dbs_new = g_dbs_new
  #   #No.FUN-940102 --begin--
  #            CALL s_chk_demo(g_user,g_plant_8) RETURNING li_result
  #             IF not li_result THEN 
  #              NEXT FIELD plant_8
  #             END IF 
  #   #No.FUN-940102 --end-- 
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
      AFTER FIELD b
         IF tm.b IS NOT NULL AND tm.b NOT MATCHES '[YN]' THEN
            NEXT FIELD b
         END IF
      AFTER FIELD c
         IF tm.c IS NOT NULL AND tm.c NOT MATCHES '[123]' THEN
            NEXT FIELD c
         END IF
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
################################################################################
   # START genero shell script ADD
     ON ACTION CONTROLR
        CALL cl_show_req_fields()
   # END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()
 
          #TQC-860019-add
          ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
          #TQC-860019-add
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r500_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='amdr500'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amdr500','9031',1)
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
                        #No.FUN-A10098 -BEGIN-----
                        #" '",g_plant_1 CLIPPED,"'",
                        #" '",g_plant_2 CLIPPED,"'",
                        #" '",g_plant_3 CLIPPED,"'",
                        #" '",g_plant_4 CLIPPED,"'",
                        #" '",g_plant_5 CLIPPED,"'",
                        #" '",g_plant_6 CLIPPED,"'",
                        #" '",g_plant_7 CLIPPED,"'",
                        #" '",g_plant_8 CLIPPED,"'" ,
                        #No.FUN-A10098 -END-------
                         " '",tm.sure CLIPPED,"'" ,
                         " '",tm.b CLIPPED,"'",
                         " '",tm.c CLIPPED,"'" ,
                         " '",tm.wc CLIPPED,"'" ,               #No.TQC-610057
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('amdr500',g_time,l_cmd)
      END IF
      CLOSE WINDOW r500_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r500()
   ERROR ""
END WHILE
   CLOSE WINDOW r500_w
END FUNCTION

#No.FUN-A10098 -BEGIN----- 
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
 
FUNCTION r500()
   DEFINE l_name    LIKE type_file.chr20,      #No.FUN-680074 VARCHAR(20) # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0068
          l_chr     LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,    #No.FUN-680074 VARCHAR(40)
          l_idx     LIKE type_file.num5,       #No.FUN-680074 SMALLINT
          sr        RECORD LIKE amd_file.*
 DEFINE  l_sql      STRING,        #No.FUN-680074
         l_sql1     STRING,        #No.FUN-680074
         l_buf      LIKE type_file.chr1000,       #No.FUN-680074 VARCHAR(400)
         l_str      LIKE type_file.chr1000,       #No.FUN-680074 VARCHAR(70)
         l_k,l_l    LIKE type_file.num5,          #No.FUN-680074 SMALLINT
         l_apa      RECORD LIKE apa_file.*,
         t_apa      RECORD LIKE apa_file.*,
         l_apb      RECORD LIKE apb_file.*,
         l_apk      RECORD LIKE apk_file.*,
         l_ama      RECORD LIKE ama_file.*,
         l_apk26    LIKE apk_file.apk26,
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
         l_apa43    LIKE apa_file.apa43,
         l_apa44    LIKE apa_file.apa44,
         l_tran     LIKE type_file.chr3,                  #No.FUN-680074 VARCHAR(3)
         l_tot      LIKE type_file.num10,                 #No.FUN-680074 INTEGER
         t_bdate,t_edate       LIKE type_file.dat,        #No.FUN-680074 DATE
         l_guidate      LIKE amd_file.amd05,
         l_ama08        LIKE ama_file.ama08,
         l_ama09        LIKE ama_file.ama09,
         l_ama10        LIKE ama_file.ama10,
         l_apa58        LIKE apa_file.apa58,
         l_zx04         LIKE zx_file.zx04,
         l_smu02        LIKE smu_file.smu02,
         old_apk01      LIKE apk_file.apk01,
         l_amd40        LIKE amd_file.amd40,
         l_amd41        LIKE amd_file.amd41,
         l_amd42        LIKE amd_file.amd42,
         l_amd43        LIKE amd_file.amd43,
         l_amd031       LIKE amd_file.amd031,      #TQC-77011
         l_num          LIKE type_file.num5,       #No.FUN-680074 SMALLINT
         l_yy,l_mm      LIKE type_file.num5,       #No.FUN-680074 SMALLINT
         l_add_cnt      LIKE type_file.num5,       #No.FUN-680074 SMALLINT
         l_dbs          LIKE type_file.chr20,      #No.FUN-680074 VARCHAR(20)
         g_idx          LIKE type_file.num5        #No.FUN-680074 SMALLINT
DEFINE   l_gen02        LIKE gen_file.gen02        #No.FUN-750129
 
     #No.FUN-750129  --Begin
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     #No.FUN-750129  --End
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     CASE tm.c
       WHEN '1'
          LET g_title = '稅額500元以下(含)'
       WHEN '2'
          LET g_title = '稅額500元以上'
       WHEN '3'
          LET g_title = '全部'
     END CASE
#NO.CHI-6A0004--BEGIN
#     SELECT azi04, azi05 INTO g_azi04, g_azi05 FROM azi_file
#                        WHERE azi01 = g_aza.aza17
#NO.CHI-6A0004--END
     #No.FUN-750129  --Begin
     #CALL cl_outnam('amdr500') RETURNING l_name
     #START REPORT r500_rep TO l_name
     #LET g_pageno = 0
     #No.FUN-750129  --End  
     FOR l_idx = 1 TO 14
         LET g_cal[l_idx].mony = 0
         LET g_cal[l_idx].tax = 0
         LET g_cal[l_idx].cnt = 0
     END FOR
    #讀取資料
   #No.FUN-A10098 -BEGIN-----
   #FOR g_idx = 1 TO 8
   #    IF cl_null(g_ary[g_idx].plant) THEN CONTINUE FOR END IF
   #No.FUN-A10098 -END-------
        #依發票帳款編號讀apa_file 資料
       #LET l_sql="SELECT apa_file.*,gec06,gec08 ",        #TQC-770115
        LET l_sql="SELECT apa_file.*,gec06,gec08,gec05 ",  #TQC-770115
                 #No.FUN-A10098 -BEGIN-----
                 #"  FROM ",g_ary[g_idx].dbs_new CLIPPED," apa_file ",
                 #"       LEFT OUTER JOIN ",g_ary[g_idx].dbs_new CLIPPED," gec_file",
                  "  FROM apa_file LEFT OUTER JOIN gec_file",
                 #No.FUN-A10098 -END-------
                  "       ON apa15 = gec01 AND gec011= '1' ",
                  " WHERE  apa01 = ?  ",   #No.+111 010510 by plum
                  "   AND apa42 = 'N' "
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        PREPARE p020_preapa FROM l_sql
        DECLARE p020_curapa CURSOR FOR p020_preapa
 
        #----抓傳票編號用--------------------------
        LET l_sql = "SELECT apa_file.* ",
                    "  FROM apv_file,apa_file ",
                    " WHERE apv03 = ? ",
                    "   AND apv01 = apa01 ",
                    "   AND apa42 = 'N' "
        PREPARE show_ref_p2   FROM l_sql
        DECLARE show_ref_c2   CURSOR FOR show_ref_p2
 
        LET l_sql = "SELECT apf_file.* ",
                    "  FROM apf_file,aph_file ",
                    " WHERE aph04 = ? ",
                    "   AND apf01 = aph01 ",
                    "   AND apf41 <> 'X' "
        PREPARE show_ref_p3   FROM l_sql
        DECLARE show_ref_c3   CURSOR FOR show_ref_p3
        #-------------------------------------------
 
        #-->進項資料--折讓
        #No.+111 010524 mod by linda 同一發票之折讓要group,不同發票要明細
        LET l_sql = "SELECT apk01,apk03,apk17,apk171,apk172,",
                    "       apk04,apk05,apk26, ",
                    "       SUM(apk06),SUM(apk07),SUM(apk08) ",
                 #No.FUN-A10098 -BEGIN-----
                 #"  FROM ",g_ary[g_idx].dbs_new CLIPPED," apa_file ",
                 #"  LEFT OUTER JOIN ",g_ary[g_idx].dbs_new CLIPPED," gec_file",
                 #"        ON apa15 = gec01 AND gec011= '1' ,",
                 #"       ",g_ary[g_idx].dbs_new CLIPPED," apb_file,",
                 #                                       " apk_file",
                  "  FROM apa_file LEFT OUTER JOIN gec_file",
                  "    ON apa15 = gec01 AND gec011= '1',apb_file,apk_file",
                 #No.FUN-A10098 -END-------
                  " WHERE apa00 = '21' ",
                  "   AND apaacti = 'Y' ",
                  "   AND apa42   = 'N' ",
                  "   AND (apa175 IS NULL OR apa175 = '' OR apa175 = 0) ",
                  "   AND apa01 = apb01 ",
                  "   AND apb01 = apk01 ",  #No.+111 010510 by plum
                  "   AND apb02 = apk02 ",  #No.+111 010510 by plum
                  "   AND apb11 IS NOT NULL AND apb11 <> ' '", #發票號碼
                  "   AND ",tm.wc CLIPPED
        IF NOT cl_null(tm.sure) THEN
           LET l_sql = l_sql CLIPPED," AND apa41='",tm.sure,"' "
        END IF
        CASE
           WHEN tm.c ='1'
               LET l_sql = l_sql CLIPPED, " AND apk07 <=500 "
           WHEN tm.c ='2'
               LET l_sql = l_sql CLIPPED, " AND apk07 > 500 "
           OTHERWISE EXIT CASE
        END CASE
        LET l_sql = l_sql CLIPPED," GROUP BY apk01,apk03,apk17,apk171,apk172,apk04,apk05,apk26 ",
                                  " ORDER BY 1,2"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        PREPARE p020_21_apkp FROM l_sql
        DECLARE p020_21_apk CURSOR FOR p020_21_apkp
        LET old_apk01='@@@@@@@@'
        FOREACH p020_21_apk INTO l_apk.apk01,l_apk.apk03,
                                 l_apk.apk17,l_apk.apk171,
                                 l_apk.apk172,l_apk.apk04,
                                 l_apk.apk05,l_apk.apk26,
                                 l_apk.apk06,l_apk.apk07,l_apk.apk08
           IF SQLCA.sqlcode THEN
              CALL cl_err('p020_curapa',SQLCA.sqlcode,0)
              EXIT FOREACH
           END IF
           IF old_apk01<> l_apk.apk01 THEN
              LET l_num=0
           END IF
           LET old_apk01=l_apk.apk01
           message l_apk.apk01
           CALL ui.Interface.refresh()
           #讀取該發票之帳款資料
           OPEN  p020_curapa  USING l_apk.apk01
          #FETCH p020_curapa  INTO l_apa.*,l_gec06,l_gec08          #TQC-770115
           FETCH p020_curapa  INTO l_apa.*,l_gec06,l_gec08,l_amd031 #TQC-770115
           CLOSE p020_curapa
           IF cl_null(l_apk.apk171) THEN LET l_apk.apk171 = l_gec08 END IF
           IF cl_null(l_apk.apk172) THEN LET l_apk.apk172 = l_gec06 END IF
           #-----更改格式及應稅否
           IF l_apk.apk171 = '21' THEN
              LET l_apk.apk171 = '23'
           END IF
           IF l_apk.apk171 = '22' THEN
              LET l_apk.apk171 = '24'
           END IF
           IF l_apk.apk171 = '25' THEN
              LET l_apk.apk171 = '23'
           END IF
           IF l_apk.apk171 = '28' THEN    #no:7393
              LET l_apk.apk171 = '29'
           END IF
           #----gec08 = 'XX' 不申報
           IF cl_null(l_gec08) OR l_gec08 = 'XX' THEN CONTINUE FOREACH END IF
           #-->憑證日期不可為兩期之前資料
           IF l_apa.apa00 = '21'
           THEN LET l_guidate = l_apa.apa02    #  帳款日
           ELSE LET l_guidate = l_apa.apa09    #  發票日
           END IF
         # CALL s_azn01(g_ama.ama08,g_ama.ama09) RETURNING t_bdate,t_edate
         # LET t_bdate = t_bdate - g_ama.ama10 UNITS MONTH + 1 UNITS MONTH
           #modi by canny(981012)
           #  IF l_guidate < t_bdate THEN CONTINUE FOREACH END IF
    	   #end modi
           #--------傳票號碼
           IF l_apa.apa58 = '1' THEN #請款折讓
              #讀取該折讓單對應之請款資料
              OPEN  p020_curapa  USING l_apk.apk26
             #FETCH p020_curapa  INTO t_apa.*,l_gec06,l_gec08
              FETCH p020_curapa  INTO t_apa.*,l_gec06,l_gec08,l_amd031 #TQC-770115
              CLOSE p020_curapa
               IF cl_null(t_apa.apa44) THEN LET t_apa.apa44 = ' ' END IF
               IF cl_null(t_apa.apa16) THEN LET t_apa.apa16 = 0 END IF
               #----98/08/18 modify
               IF cl_null(l_apa.apa43) THEN
                  LET l_yy  = YEAR(l_apa.apa02)
                  LET l_mm  = MONTH(l_apa.apa02)
               ELSE
                  LET l_yy  = YEAR(t_apa.apa43)
                  LET l_mm  = MONTH(t_apa.apa43)
               END IF
               LET l_num=l_num+1
 
             #-TQC-770115 Begin
               LET sr.amd01  = l_apk.apk01
               LET sr.amd02  = l_num
               LET sr.amd021 = '2'
               LET sr.amd03  = l_apk.apk03
               LET sr.amd031 = l_amd031
               LET sr.amd04  = l_apk.apk04
               LET sr.amd05  = l_apk.apk05
               LET sr.amd06  = l_apk.apk06
               LET sr.amd07  = l_apk.apk07
               LET sr.amd08  = l_apk.apk08
               LET sr.amd09  = ' ' 
               LET sr.amd10  = ' '
               LET sr.amd17  = l_apk.apk17
               LET sr.amd171 = l_apk.apk171
               LET sr.amd172 = l_apk.apk172
               LET sr.amd173 = l_yy
               LET sr.amd174 = l_mm
               LET sr.amd175 = ''
               LET sr.amd22  = '' 
              #LET sr.amd25  = g_ary[g_idx].plant #No.FUN-A10098
               LET sr.amd25  = ''                 #No.FUN-A10098
               LET sr.amd26  = ''
               LET sr.amd27  = '' 
               LET sr.amd28  = t_apa.apa44
               LET sr.amd29  = '1'
               LET sr.amd30  = 'N' 
               LET sr.amd35  = ''
               LET sr.amd36  = ''
               LET sr.amd37  = ''
               LET sr.amd38  = ''
               LET sr.amd39  = '' 
               LET sr.amd40  = l_apa.apa06
               LET sr.amd41  = l_apa.apa07 
               LET sr.amd42  = l_apa.apa02 
               LET sr.amd43  = l_apa.apa02
               LET sr.amdacti = 'Y'
               LET sr.amddate = g_today
               LET sr.amdgrup = l_apa.apagrup
               LET sr.amdmodu = ''
               LET sr.amduser = l_apa.apauser
               
               #Ne.FUN-750129  --Begin
               #OUTPUT TO REPORT r500_rep(l_apk.apk01,l_num,'2',
               #    l_apk.apk03,l_apk.apk04,l_apk.apk05,
               #    l_apk.apk06,l_apk.apk07,l_apk.apk08,
               #    ' ',' ',l_apk.apk17,l_apk.apk171,l_apk.apk172,
               #    l_yy,l_mm,'','',g_ary[g_idx].plant,
               #    '','',t_apa.apa44,'1','N',
               #    '','','','','',
               #    l_apa.apa06,l_apa.apa07,
               #    l_apa.apa02,l_apa.apa02,
               #    'Y',l_apa.apauser,l_apa.apagrup,'',g_today,
               #    l_apa.apa00,'',l_apa.apa41)
               #CALL r500_cr(l_apk.apk01,l_num,'2',
               #    l_apk.apk03,l_apk.apk04,l_apk.apk05,
               #    l_apk.apk06,l_apk.apk07,l_apk.apk08,
               #    ' ',' ',l_apk.apk17,l_apk.apk171,l_apk.apk172,
               #    l_yy,l_mm,'','',g_ary[g_idx].plant,
               #    '','',t_apa.apa44,'1','N',
               #    '','','','','',
               #    l_apa.apa06,l_apa.apa07,
               #    l_apa.apa02,l_apa.apa02,
               #   'Y',l_apa.apauser,l_apa.apagrup,'',g_today,'')
               #    RETURNING l_gen02
               CALL r500_cr(sr.*)
                   RETURNING l_gen02
               #-TQC-770115 End
 
               IF cl_null(l_apk.apk07) THEN LET l_apk.apk07 = 0 END IF
               IF cl_null(l_apk.apk08) THEN LET l_apk.apk08 = 0 END IF
               #CHI-B20012 add --start--
               IF tm.b='N' OR (tm.b='Y' AND
                          (g_sr1.mark1='*' OR g_sr1.mark2='*' OR g_sr1.mark3='*'    OR
                          g_sr1.mark4='*' OR g_sr1.mark5='*' OR g_sr1.mark6='*'    OR
                          g_sr1.mark7='*' OR g_sr1.mark8='*' OR g_sr1.mark9='*') ) THEN
               #CHI-B20012 add --end--
                  EXECUTE insert_prep 
                       USING l_apk.apk01,l_apk.apk03,l_apk.apk04,l_apk.apk05,
                             l_apk.apk07,l_apk.apk08,l_apk.apk17,l_apk.apk171,
                             l_apk.apk172, l_yy,l_mm,t_apa.apa44,
                             l_apa.apauser,l_apa.apa00,'',g_str1[1],g_str1[3],
                             g_str1[5],g_str1[6],g_str1[7],g_str1[8],g_str1[9],
                             g_str1[10],l_apa.apa41,l_gen02,g_sr1.*
                  #No.FUN-750129  --End  
#                 IF SQLCA.sqlcode<> -239 AND SQLCA.SQLCODE <>0 THEN
                  IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN #NO.TQC-790093
                     LET g_success='N'
                     EXIT FOREACH
                  END IF
               END IF #CHI-B20012 add
           ELSE
              #非請款折讓
              LET l_yy  = YEAR(l_apa.apa02)
              LET l_mm  = MONTH(l_apa.apa02)
              #-抓傳票編號(先抓直接沖帳檔[apv_file)，再抓付款單[apf_file])---
              OPEN  show_ref_c2  USING l_apk.apk01
              FETCH show_ref_c2  INTO  f_apa.*
              IF STATUS THEN
                 OPEN  show_ref_c3  USING l_apk.apk01
                 FETCH show_ref_c3  INTO  f_apf.*
                 IF STATUS THEN SLEEP 0 ELSE LET l_apa44 = f_apf.apf44 END IF
                 CLOSE show_ref_c3
              ELSE
                 LET l_apa44 = f_apa.apa44
              END IF
              CLOSE show_ref_c2
              LET l_num=l_num+1
 
            #-TQC-770115 Begin
              LET sr.amd01  = l_apk.apk01
              LET sr.amd02  = l_num
              LET sr.amd021 = '2'
              LET sr.amd03  = l_apk.apk03
              LET sr.amd031 = l_amd031
              LET sr.amd04  = l_apk.apk04
              LET sr.amd05  = l_apk.apk05
              LET sr.amd06  = l_apk.apk06
              LET sr.amd07  = l_apk.apk07
              LET sr.amd08  = l_apk.apk08
              LET sr.amd09  = ' ' 
              LET sr.amd10  = ' '
              LET sr.amd17  = l_apk.apk17
              LET sr.amd171 = l_apk.apk171
              LET sr.amd172 = l_apk.apk172
              LET sr.amd173 = l_yy
              LET sr.amd174 = l_mm
              LET sr.amd175 = ''
              LET sr.amd22  = '' 
             #LET sr.amd25  = g_ary[g_idx].plant #No.FUN-A10098
              LET sr.amd25  = ''                 #No.FUN-A10098
              LET sr.amd26  = ''
              LET sr.amd27  = '' 
              LET sr.amd28  = l_apa44
              LET sr.amd29  = '1'
              LET sr.amd30  = 'N' 
              LET sr.amd35  = ''
              LET sr.amd36  = ''
              LET sr.amd37  = ''
              LET sr.amd38  = ''
              LET sr.amd39  = '' 
              LET sr.amd40  = l_apa.apa06
              LET sr.amd41  = l_apa.apa07 
              LET sr.amd42  = l_apa.apa02 
              LET sr.amd43  = l_apa.apa02
              LET sr.amdacti = 'Y'
              LET sr.amddate = g_today
              LET sr.amdgrup = l_apa.apagrup
              LET sr.amdmodu = ''
              LET sr.amduser = l_apa.apauser
           
              #No.FUN-750129  --End  
              #OUTPUT TO REPORT r500_rep(l_apk.apk01,l_num,'2',
              #      l_apk.apk03,l_apk.apk04,l_apk.apk05,
              #      l_apk.apk06,l_apk.apk07,l_apk.apk08,
              #      ' ',' ',l_apk.apk17,l_apk.apk171,l_apk.apk172,
              #      l_yy,l_mm,'','',g_ary[g_idx].plant,
              #      '','',l_apa44,'1','N',
              #      '','','','','',
              #      l_apa.apa06,l_apa.apa07,
              #      l_apa.apa02,l_apa.apa02,
              #      'Y',l_apa.apauser,l_apa.apagrup,'',g_today,
              #      l_apa.apa00,'',l_apa.apa41)
              #CALL r500_cr(l_apk.apk01,l_num,'2',
              #      l_apk.apk03,l_apk.apk04,l_apk.apk05,
              #      l_apk.apk06,l_apk.apk07,l_apk.apk08,
              #      ' ',' ',l_apk.apk17,l_apk.apk171,l_apk.apk172,
              #      l_yy,l_mm,'','',g_ary[g_idx].plant,
              #      '','',l_apa44,'1','N',
              #      '','','','','',
              #      l_apa.apa06,l_apa.apa07,
              #      l_apa.apa02,l_apa.apa02,
              #      'Y',l_apa.apauser,l_apa.apagrup,'',g_today,'')
              #      RETURNING l_gen02
              CALL r500_cr(sr.*)
                   RETURNING l_gen02
              #-TQC-770115 End
              IF cl_null(l_apk.apk07) THEN LET l_apk.apk07 = 0 END IF
              IF cl_null(l_apk.apk08) THEN LET l_apk.apk08 = 0 END IF
              #CHI-B20012 add --start--
              IF tm.b='N' OR (tm.b='Y' AND
                         (g_sr1.mark1='*' OR g_sr1.mark2='*' OR g_sr1.mark3='*'    OR
                         g_sr1.mark4='*' OR g_sr1.mark5='*' OR g_sr1.mark6='*'    OR
                         g_sr1.mark7='*' OR g_sr1.mark8='*' OR g_sr1.mark9='*') ) THEN
              #CHI-B20012 add --end--
                 EXECUTE insert_prep 
                      USING l_apk.apk01,l_apk.apk03,l_apk.apk04,l_apk.apk05,
                            l_apk.apk07,l_apk.apk08,l_apk.apk17,l_apk.apk171,
                            l_apk.apk172,l_yy,l_mm,l_apa44,
                            l_apa.apauser,l_apa.apa00,'',g_str1[1],g_str1[3],
                            g_str1[5],g_str1[6],g_str1[7],g_str1[8],g_str1[9],
                            g_str1[10],l_apa.apa41,l_gen02,g_sr1.*
                 #No.FUN-750129  --End  
#                IF SQLCA.sqlcode<> -239 AND SQLCA.SQLCODE <>0 THEN
                 IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN  #NO.TQC-790093
                    LET g_success='N'
                    EXIT FOREACH
                 END IF
              END IF #CHI-B20012 add
              #---------------------------------------------------------------
           END IF
        END FOREACH
       #No.FUN-A10098 -BEGIN-----
       #IF g_success='N' THEN
       #   EXIT FOR
       #END IF
       #No.FUN-A10098 -END-------
        INITIALIZE l_apk.* TO NULL
        IF tm.wc != " 1=1 " THEN
           LET l_buf=tm.wc
#TQC-950074---BEGIN                                                                                                                 
#           LET l_l=length(l_buf)                                                                                                   
#           FOR l_k=1 TO l_l                                                                                                        
#               IF l_buf[l_k,l_k+4]='apa01' THEN                                                                                    
#                  LET l_buf[l_k,l_k+4]='apk01'                                                                                     
#               END IF                                                                                                              
#               IF l_buf[l_k,l_k+4]='apa09' THEN                                                                                    
#                  LET l_buf[l_k,l_k+4]='apk05'                                                                                     
#               END IF                                                                                                              
#               IF l_buf[l_k,l_k+4]='apa08' THEN                                                                                    
#                  LET l_buf[l_k,l_k+4]='apk03'                                                                                     
#               END IF                                                                                                              
#           END FOR                                                                                                                 
           LET l_buf = cl_replace_str(l_buf,"apa01","apk01")                                                                        
           LET l_buf = cl_replace_str(l_buf,"apa09","apk05")                                                                        
           LET l_buf = cl_replace_str(l_buf,"apa08","apk03")                                                                        
#TQC-950074---END      
           LET tm.wc = l_buf
        END IF
        #-->進項資料(多發票資料)
        #BUGNO4197 加取格式28的資料
        LET l_sql="SELECT apk01,apk02,apk03,apk04,apk05,apk06,apk07,apk08,",
                  " apk09,apk10,apk17,apk171,apk172,apkuser,apa02,", #MOD-990228 add apkuser  
                  " apa44,apa43,gec06,gec08,",
                 #" apa06,apa07,apa02,apa02  ",           # TQC-770115
                  " apa06,apa07,apa02,apa02,gec05  ",     # TQC-770115
                 #No.FUN-A10098 -BEGIN-----
                 #" FROM  ",g_ary[g_idx].dbs_new CLIPPED," apk_file,",
                 #"  ",g_ary[g_idx].dbs_new CLIPPED," apa_file ",
                 #"  LEFT OUTER JOIN ",g_ary[g_idx].dbs_new CLIPPED," gec_file ",
                  " FROM apk_file,apa_file LEFT OUTER JOIN gec_file ",
                 #No.FUN-A10098 -END-------
                  "   ON apa15 = gec01 AND gec011= '1' ",
                  " WHERE apk01 = apa01 ",
                  "   AND apaacti = 'Y' ",
                  "   AND apa42   = 'N' ",
                   "   AND (apa175 IS NULL OR apa175 = '' OR apa175 = 0) ",
                  "   AND ((apk171 = '21' AND apk172 IN ('1','2','3')) ",
                  "    OR  (apk171 = '22' AND apk172 = '1') ",
                  "    OR  (apk171 = '25' AND apk172 IN ('1','2','3')) ",
                  "    OR  (apk171 = '26' AND apk172 IN ('1','2','3')) ",   #MOD-750055
                  "    OR  (apk171 = '27' AND apk172 = '1') ",   #MOD-750055
                  "    OR  (apk171 = '28' AND apk172 IN ('1','2','3')) ",  #no:7046 多')'
                  "    OR  (apk171 = '29' AND apk172 IN ('1','2','3')))",  #no:7393
                  "   AND ",tm.wc CLIPPED
        IF NOT cl_null(tm.sure) THEN
           LET l_sql = l_sql CLIPPED," AND apa41='",tm.sure,"' "
        END IF
        CASE
           WHEN tm.c ='1'
               LET l_sql = l_sql CLIPPED, " AND apk07 <=500 "
           WHEN tm.c ='2'
               LET l_sql = l_sql CLIPPED, " AND apk07 > 500 "
           OTHERWISE EXIT CASE
        END CASE
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        PREPARE p020_g_preapk FROM l_sql
        DECLARE p020_g_curapk CURSOR FOR p020_g_preapk
 
        #讀取發票相對應之帳單號碼
        LET l_sql = "SELECT  apk01,apk02 ",
                    "  FROM apk_file ",
                    " WHERE apk03 = ? " ,
                   "    AND apk01 <> ? "
        PREPARE r500_g_preapk6  FROM l_sql
        DECLARE r500_g_apkcur6  CURSOR FOR r500_g_preapk6
 
        LET l_sql = "SELECT apb11 ",
                  # "  FROM ",g_ary[g_idx].dbs_new CLIPPED,"apb_file", #No.FUN-A10098
                    "  FROM apb_file", #No.FUN-A10098
                    " WHERE apb01 = ? ",
                    "   AND apb02 = ? "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        PREPARE p020_g_preapb2  FROM l_sql
        DECLARE p020_g_apbcur2  CURSOR FOR p020_g_preapb2
 
        FOREACH p020_g_curapk INTO l_apk.apk01,l_apk.apk02,l_apk.apk03,
                                   l_apk.apk04,
                                   l_apk.apk05,l_apk.apk06,l_apk.apk07,
                                   l_apk.apk08,l_apk.apk09,l_apk.apk10,
                                   l_apk.apk17,l_apk.apk171,l_apk.apk172,
                                   l_apk.apkuser,  #MOD-990228          
                                   l_apa02,l_apa44,l_apa43,l_gec06,l_gec08,
                                  #l_amd40,l_amd41,l_amd42,l_amd43          #TQC-770115
                                   l_amd40,l_amd41,l_amd42,l_amd43,l_amd031 #TQC-770115
           IF SQLCA.sqlcode THEN
              CALL cl_err('p020_curapk',SQLCA.sqlcode,0)
              EXIT FOREACH
           END IF
           LET l_str=''
           message l_apk.apk01
           CALL ui.Interface.refresh()
           IF cl_null(l_apk.apk171) THEN LET l_apk.apk171 = l_gec08 END IF
           IF cl_null(l_apk.apk172) THEN LET l_apk.apk172 = l_gec06 END IF
           IF cl_null(l_gec08) OR l_gec08 = 'XX' THEN CONTINUE FOREACH END IF
           IF l_apk.apk171 = '23' THEN
              OPEN p020_g_apbcur2 USING l_apk.apk01,l_apk.apk02
              FETCH p020_g_apbcur2 INTO l_invoice
              IF STATUS THEN LET l_invoice = '' END IF
           ELSE
              LET l_invoice = l_apk.apk03
           END IF
           #-->憑證日期不可為兩期之前資料
           LET l_guidate = l_apk.apk05    #  發票日
        #  CALL s_azn01(g_ama.ama08,g_ama.ama09) RETURNING t_bdate,t_edate
        #  LET t_bdate = t_bdate - g_ama.ama10 UNITS MONTH + 1 UNITS MONTH
        #modi by canny(981012)
        #  IF l_guidate < t_bdate THEN CONTINUE FOREACH END IF
	#end modi
           LET l_yy    =YEAR(l_apa43)
           LET l_mm    =MONTH(l_apa43)
           IF cl_null(l_apa44) THEN LET l_apa44 = ' ' END IF
            #讀取發票號碼相對應之帳單號碼
            FOREACH r500_g_apkcur6
            USING l_apk.apk03,l_apk.apk01
            INTO l_apk01,l_apk02
             IF STATUS THEN CALL cl_err('sel apk err:',STATUS,0)
                            EXIT FOREACH END IF
             LET l_str=l_str CLIPPED,"(",l_apk01 CLIPPED,
                             "-",l_apk02 USING "##&",")"
            END FOREACH
 
        #-TQC-770115 Begin
            LET sr.amd01  = l_apk.apk01
            LET sr.amd02  = l_apk.apk02
            LET sr.amd021 = '5'
            LET sr.amd03  = l_invoice
            LET sr.amd031 = l_amd031 
            LET sr.amd04  = l_apk.apk04
            LET sr.amd05  = l_apk.apk05
            LET sr.amd06  = l_apk.apk06
            LET sr.amd07  = l_apk.apk07
            LET sr.amd08  = l_apk.apk08
            LET sr.amd09  = l_apk.apk09 
            LET sr.amd10  = l_apk.apk10
            LET sr.amd17  = l_apk.apk17
            LET sr.amd171 = l_apk.apk171
            LET sr.amd172 = l_apk.apk172
            LET sr.amd173 = l_yy
            LET sr.amd174 = l_mm
            LET sr.amd175 = ''
            LET sr.amd22  = l_amd22 
           #LET sr.amd25  = g_ary[g_idx].plant #No.FUN-A10098
            LET sr.amd25  = ''                 #No.FUN-A10098
            LET sr.amd26  = ''
            LET sr.amd27  = '' 
            LET sr.amd28  = l_apa44
            LET sr.amd29  = '1'
            LET sr.amd30  = 'N' 
            LET sr.amd35  = ''
            LET sr.amd36  = ''
            LET sr.amd37  = ''
            LET sr.amd38  = ''
            LET sr.amd39  = '' 
            LET sr.amd40  = l_amd40 
            LET sr.amd41  = l_amd41 
            LET sr.amd42  = l_amd42  
            LET sr.amd43  = l_amd43 
            LET sr.amdacti = 'Y'
            LET sr.amddate = g_today
            LET sr.amdgrup = l_apk.apkgrup
            LET sr.amdmodu = ''
            LET sr.amduser = l_apk.apkuser
           
            #No.FUN-750129  --End  
            #OUTPUT TO REPORT r500_rep(l_apk.apk01,l_apk.apk02,'5',
            #                           l_invoice,l_apk.apk04,
            #                           l_apk.apk05,l_apk.apk06,
            #                           l_apk.apk07,l_apk.apk08,
            #                           l_apk.apk09,l_apk.apk10,
            #                           l_apk.apk17,l_apk.apk171,
            #                           l_apk.apk172,l_yy,l_mm,'',
            #                           l_amd22,g_ary[g_idx].plant,
            #                           '','',l_apa44,'1', 'N',
            #                           '','','','','',  #No.+076 010423
            #                           l_amd40,l_amd41,l_amd42,l_amd43,
            #                           'Y',l_apk.apkuser,l_apk.apkgrup,'',g_today,
            #                           l_apa.apa00,l_str,l_apa.apa41)
            #CALL r500_cr(l_apk.apk01,l_apk.apk02,'5',
            #             l_invoice,l_apk.apk04,
            #             l_apk.apk05,l_apk.apk06,
            #             l_apk.apk07,l_apk.apk08,
            #             l_apk.apk09,l_apk.apk10,
            #             l_apk.apk17,l_apk.apk171,
            #             l_apk.apk172,l_yy,l_mm,'',
            #             l_amd22,g_ary[g_idx].plant,
            #             '','',l_apa44,'1', 'N',
            #             '','','','','',  #No.+076 010423
            #             l_amd40,l_amd41,l_amd42,l_amd43,
            #             'Y',l_apk.apkuser,l_apk.apkgrup,'',g_today,'')
            #             RETURNING l_gen02
            CALL r500_cr(sr.*)
                         RETURNING l_gen02
          #-TQC-770115 End
            IF cl_null(l_apk.apk07) THEN LET l_apk.apk07 = 0 END IF
            IF cl_null(l_apk.apk08) THEN LET l_apk.apk08 = 0 END IF
            #CHI-B20012 add --start--
            IF tm.b='N' OR (tm.b='Y' AND
                       (g_sr1.mark1='*' OR g_sr1.mark2='*' OR g_sr1.mark3='*'    OR
                       g_sr1.mark4='*' OR g_sr1.mark5='*' OR g_sr1.mark6='*'    OR
                       g_sr1.mark7='*' OR g_sr1.mark8='*' OR g_sr1.mark9='*') ) THEN
            #CHI-B20012 add --end--
               EXECUTE insert_prep 
                    USING l_apk.apk01,l_invoice,l_apk.apk04,l_apk.apk05,
                          l_apk.apk07,l_apk.apk08,l_apk.apk17,l_apk.apk171,
                          l_apk.apk172,l_yy,l_mm,l_apa44,
                          l_apk.apkuser,l_apa.apa00,l_str,g_str1[1],g_str1[3],
                          g_str1[5],g_str1[6],g_str1[7],g_str1[8],g_str1[9],
                          g_str1[10],l_apa.apa41,l_gen02,g_sr1.*
               #No.FUN-750129  --End  
#              IF SQLCA.sqlcode <>0 AND SQLCA.SQLCODE <>-239 THEN
               IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN  #NO.IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN
                  CALL cl_err(l_apk.apk01,SQLCA.sqlcode,0)   #generoe改為0
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
            END IF #CHI-B20012 add
        END FOREACH
  # END FOR   #No.FUN-A10098 mark
    #No.FUN-750129  --Begin
    # FINISH REPORT r500_rep
    # CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'apa01,apa02,apa171,apa17,apa172,apa22,apa00,apauser')
            RETURNING g_str2
    END IF
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    LET g_str = tm.b,";",g_title,";",g_azi04,";",g_str2
    CALL cl_prt_cs3('amdr500','amdr500',g_sql,g_str)
    #No.FUN-750129  --End  
END FUNCTION
 
#No.FUN-750129  --Begin
#REPORT r500_rep(sr,l_apa00,l_str,l_apa41)
#DEFINE l_last_sw    LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
#       l_idx        LIKE type_file.num5,       #No.FUN-680074 SMALLINT
#       l_str        LIKE type_file.chr1000,    #No.FUN-680074 VARCHAR(70)
#       l_apa41      LIKE apa_file.apa41,       #確認碼
#       l_apa00      LIKE apa_file.apa00,       #帳款性質
#       l_cnt        LIKE type_file.num5,       #No.FUN-680074 SMALLINT
#       l_gen02      LIKE gen_file.gen02,
#       g_head1      STRING,                    #No.FUN-680074
#       str          STRING,                    #No.FUN-680074
#       sr           RECORD  LIKE amd_file.*
#
#  DEFINE sr1 RECORD
#	            mark1  LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1) #無傳票號碼
#	            mark2  LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1) #格式為空白
#	            mark3  LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1) #資料年度/月份為空白
#	            mark4  LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1) #稅額事後 * 0.05 > 1
#	            mark5  LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1) #發票號碼為空白,或碼數不正確
#	            mark6  LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1) #稅額錯誤
#	            mark7  LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1) #統一編號錯誤
#                    mark8  LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1) #統一編號錯誤
#                    mark9  LIKE type_file.chr1        #No.FUN-680074 VARCHAR(1) #未稅金額為零錯誤
#              END RECORD,
#       XX            LIKE amd_file.amd17,             #No.FUN-680074 VARCHAR(2)
#       #-----MOD-750055---------
#       #l_a21a,l_a22a,l_a23a,l_a24a,l_a25a,l_a28a,l_a29a     INTEGER,  #no:7393
#       #l_a21b,l_a22b,l_a23b,l_a24b,l_a25b,l_a28b,l_a29b     INTEGER,  #no:7393
#       #l_b21a,l_b22a,l_b23a,l_b24a,l_b25a,l_b28a,l_b29a     INTEGER,  #no:7393
#       #l_b21b,l_b22b,l_b23b,l_b24b,l_b25b,l_b28b,l_b29b     INTEGER,  #no:7393
#       l_a21a,l_a22a,l_a23a,l_a24a,l_a25a,l_a26a,l_a27a,l_a28a,l_a29a     INTEGER,  #no:7393
#       l_a21b,l_a22b,l_a23b,l_a24b,l_a25b,l_a26b,l_a27b,l_a28b,l_a29b     INTEGER,  #no:7393
#       l_b21a,l_b22a,l_b23a,l_b24a,l_b25a,l_b26a,l_b27a,l_b28a,l_b29a     INTEGER,  #no:7393
#       l_b21b,l_b22b,l_b23b,l_b24b,l_b25b,l_b26b,l_b27b,l_b28b,l_b29b     INTEGER,  #no:7393
#       #-----END MOD-750055----- 
#       l_sum1,l_sum2              LIKE amd_file.amd08,     #No.FUN-680074 DECIMAL(20,6)
#       l_aa,l_ba                  LIKE amd_file.amd08,     #No.FUN-680074 DECIMAL(20,6)
#       l_ab,l_bb                  LIKE amd_file.amd08,     #No.FUN-680074 DECIMAL(20,6)
#       l_mask        LIKE zaa_file.zaa08,       #No.FUN-680074 VARCHAR(15)
#       l_byy         LIKE type_file.num5,       #No.FUN-680074 SMALLINT
#       l_eyy         LIKE type_file.num5        #No.FUN-680074 SMALLINT
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.amduser,l_apa00,sr.amd01,sr.amd03
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED, pageno_total
#      LET g_head1 = g_x[10] CLIPPED,g_title CLIPPED
#      PRINT g_head1
#      PRINT g_dash[1,g_len]
#      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],    #MOD-750055
#            g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   ON EVERY ROW
#      #增加檢核功能
#      CALL err_chk(sr.*) RETURNING sr1.*
#     #No.B399 010528 by plum
#      IF tm.b='N' OR (tm.b='Y' AND (sr1.mark1='*' OR sr1.mark2='*'
#              OR sr1.mark3='*' OR sr1.mark4='*' OR
#         sr1.mark5='*' OR sr1.mark6='*' OR sr1.mark7='*' OR sr1.mark8='*' OR
#         sr1.mark9='*' )) THEN
#     #No.B399 ..end
#         LET XX =sr.amd17,sr.amd172       #扣扺代號 + 課稅別
#         #讀取輸入人員姓名
#         LET l_gen02=''
#         SELECT gen02 INTO l_gen02 FROM gen_file WHERE	 gen01=sr.amduser
#         IF SQLCA.SQLCODE OR cl_null(l_gen02) THEN
#            LET l_gen02=sr.amduser
#         END IF
#         LET str = sr1.mark1,sr.amd28 CLIPPED
#         PRINT COLUMN g_c[31],str;
#         PRINT COLUMN g_c[32], sr.amd01;
#         LET str = sr1.mark5,sr.amd03
#         PRINT COLUMN g_c[33],str;
#         PRINT COLUMN g_c[34],sr.amd05;
#         LET str = sr1.mark2,sr.amd171
#         PRINT COLUMN g_c[35],str;
#         LET str = sr1.mark3,sr.amd173-1911 USING '&&',
#                   sr.amd174 USING '&&'
#         PRINT COLUMN g_c[36],str;
#         LET str =  sr1.mark8,sr.amd04
#         PRINT COLUMN g_c[37],str;
#         LET str = sr1.mark9,cl_numfor(sr.amd08,17,g_azi04) CLIPPED
#         PRINT COLUMN g_c[38],str;
#         LET str =  sr1.mark6,sr.amd172
#         PRINT COLUMN g_c[39],str;
#         LET str =  sr1.mark4,cl_numfor(sr.amd07,17,g_azi04) CLIPPED
#         PRINT COLUMN g_c[40],str;
#         PRINT COLUMN g_c[41],sr.amd17,
#               COLUMN g_c[42],l_apa00,
#               COLUMN g_c[43],l_gen02,     #sr.amduser
#               COLUMN g_c[44],l_apa41
#     #No.B399 010528 by plum
#              LET g_amd08 = g_amd08 + sr.amd08
#              LET g_amd07 = g_amd07 + sr.amd07
#      END IF
#     #No.B399 ...end
#      CASE XX
#           WHEN '11' LET g_cal[1].mony = g_cal[1].mony + sr.amd08
#                     LET g_cal[1].tax  = g_cal[1].tax  + sr.amd07
#                     LET g_cal[1].cnt  = g_cal[1].cnt  + 1
#           WHEN '12' LET g_cal[2].mony = g_cal[2].mony + sr.amd08
#                     LET g_cal[2].cnt  = g_cal[2].cnt  + 1
#           WHEN '13' LET g_cal[3].mony = g_cal[3].mony + sr.amd08
#                     LET g_cal[3].cnt  = g_cal[3].cnt  + 1
#           WHEN '21' LET g_cal[4].mony = g_cal[4].mony + sr.amd08
#                     LET g_cal[4].tax  = g_cal[4].tax  + sr.amd07
#                     LET g_cal[4].cnt  = g_cal[4].cnt  + 1
#           WHEN '22' LET g_cal[5].mony = g_cal[5].mony + sr.amd08
#                     LET g_cal[5].cnt  = g_cal[5].cnt  + 1
#           WHEN '23' LET g_cal[6].mony = g_cal[6].mony + sr.amd08
#                     LET g_cal[6].cnt  = g_cal[6].cnt  + 1
#           WHEN '31' LET g_cal[7].mony = g_cal[7].mony + sr.amd08
#                     LET g_cal[7].tax  = g_cal[7].tax  + sr.amd07
#                     LET g_cal[7].cnt  = g_cal[7].cnt  + 1
#           WHEN '32' LET g_cal[8].mony = g_cal[8].mony + sr.amd08
#                     LET g_cal[8].cnt  = g_cal[8].cnt  + 1
#           WHEN '33' LET g_cal[9].mony = g_cal[9].mony + sr.amd08
#                     LET g_cal[9].cnt  = g_cal[9].cnt  + 1
#           WHEN '41' LET g_cal[10].mony = g_cal[10].mony + sr.amd08
#                     LET g_cal[10].tax  = g_cal[10].tax  + sr.amd07
#                     LET g_cal[10].cnt  = g_cal[10].cnt  + 1
#           WHEN '42' LET g_cal[11].mony = g_cal[11].mony + sr.amd08
#                     LET g_cal[11].cnt  = g_cal[11].cnt  + 1
#           WHEN '43' LET g_cal[12].mony = g_cal[12].mony + sr.amd08
#                     LET g_cal[12].cnt  = g_cal[12].cnt  + 1
#      END CASE
#     #No.B399 010528 by plum
#      IF sr1.mark1='*' OR sr1.mark2='*' OR sr1.mark3='*' OR sr1.mark4='*' OR
#         sr1.mark5='*' OR sr1.mark6='*' OR sr1.mark7='*' OR sr1.mark8='*' OR
#         sr1.mark9='*' THEN
#     #No.B399 ..end
#        #判斷若發票對應多張帳單則show出
#         IF NOT cl_null(l_str) THEN
#            PRINT COLUMN g_c[31],g_x[8] CLIPPED,l_str CLIPPED
#         END IF
#     END IF  #No.B399 ..end
#
#   AFTER GROUP OF sr.amduser
#         IF g_amd08 >0 OR g_amd07 > 0 THEN
#            PRINT COLUMN g_c[34],l_gen02 CLIPPED,    #sr.amduser,
#                  COLUMN g_c[36],g_x[9] CLIPPED,
#                  COLUMN g_c[38],cl_numfor(g_amd08,38,g_azi04) CLIPPED,
#                  COLUMN g_c[40],cl_numfor(g_amd07,40,g_azi04) CLIPPED
#         END IF
#         LET g_amd07 = 0 LET g_amd08 = 0
#         SKIP 2 LINES
#
#   ON LAST ROW
#      #依401格式統計
#      LET l_mask = "--,---,---,--&"
#      LET l_a21a=SUM(sr.amd08) WHERE sr.amd171='21' AND sr.amd17 ='1'
#                                 AND sr.amd172='1'
#      LET l_b21a=SUM(sr.amd08) WHERE sr.amd171='21' AND sr.amd17 ='2'
#                                 AND sr.amd172='1'
#      LET l_a22a=SUM(sr.amd08) WHERE sr.amd171='22' AND sr.amd17 ='1'
#                                 AND sr.amd172='1'
#      LET l_b22a=SUM(sr.amd08) WHERE sr.amd171='22' AND sr.amd17 ='2'
#                                 AND sr.amd172='1'
#      LET l_a23a=SUM(sr.amd08) WHERE sr.amd171='23' AND sr.amd17 ='1'
#                                 AND sr.amd172='1'
#      LET l_b23a=SUM(sr.amd08) WHERE sr.amd171='23' AND sr.amd17 ='2'
#                                 AND sr.amd172='1'
#      LET l_a24a=SUM(sr.amd08) WHERE sr.amd171='24' AND sr.amd17 ='1'
#                                 AND sr.amd172='1'
#      LET l_b24a=SUM(sr.amd08) WHERE sr.amd171='24' AND sr.amd17 ='2'
#                                 AND sr.amd172='1'
#      LET l_a25a=SUM(sr.amd08) WHERE sr.amd171='25' AND sr.amd17 ='1'
#                                 AND sr.amd172='1'
#      LET l_b25a=SUM(sr.amd08) WHERE sr.amd171='25' AND sr.amd17 ='2'
#                                 AND sr.amd172='1'
#      #-----MOD-750055---------
#      LET l_a26a=SUM(sr.amd08) WHERE sr.amd171='26' AND sr.amd17 ='1'
#                                 AND sr.amd172='1'
#      LET l_b26a=SUM(sr.amd08) WHERE sr.amd171='26' AND sr.amd17 ='2'
#                                 AND sr.amd172='1'
#      LET l_a27a=SUM(sr.amd08) WHERE sr.amd171='27' AND sr.amd17 ='1'
#                                 AND sr.amd172='1'
#      LET l_b27a=SUM(sr.amd08) WHERE sr.amd171='27' AND sr.amd17 ='2'
#                                 AND sr.amd172='1'
#      #-----END MOD-750055-----
#      #BUGNO4197
#      LET l_a28a=SUM(sr.amd08) WHERE sr.amd171='28' AND sr.amd17 ='1'
#                                 AND sr.amd172='1'
#      LET l_b28a=SUM(sr.amd08) WHERE sr.amd171='28' AND sr.amd17 ='2'
#                                 AND sr.amd172='1'
#      LET l_a29a=SUM(sr.amd08) WHERE sr.amd171='29' AND sr.amd17 ='1'  #no:7393
#                                 AND sr.amd172='1'
#      LET l_b29a=SUM(sr.amd08) WHERE sr.amd171='29' AND sr.amd17 ='2'  #no:7393
#                                 AND sr.amd172='1'
#      #BUGNO4197
#
#      LET l_a21b=SUM(sr.amd07) WHERE sr.amd171='21' AND sr.amd17 ='1'
#                                 AND sr.amd172='1'
#      LET l_b21b=SUM(sr.amd07) WHERE sr.amd171='21' AND sr.amd17 ='2'
#                                 AND sr.amd172='1'
#      LET l_a22b=SUM(sr.amd07) WHERE sr.amd171='22' AND sr.amd17 ='1'
#                                 AND sr.amd172='1'
#      LET l_b22b=SUM(sr.amd07) WHERE sr.amd171='22' AND sr.amd17 ='2'
#                                 AND sr.amd172='1'
#      LET l_a23b=SUM(sr.amd07) WHERE sr.amd171='23' AND sr.amd17 ='1'
#                                 AND sr.amd172='1'
#      LET l_b23b=SUM(sr.amd07) WHERE sr.amd171='23' AND sr.amd17 ='2'
#                                 AND sr.amd172='1'
#      LET l_a24b=SUM(sr.amd07) WHERE sr.amd171='24' AND sr.amd17 ='1'
#                                 AND sr.amd172='1'
#      LET l_b24b=SUM(sr.amd07) WHERE sr.amd171='24' AND sr.amd17 ='2'
#                                 AND sr.amd172='1'
#      LET l_a25b=SUM(sr.amd07) WHERE sr.amd171='25' AND sr.amd17 ='1'
#                                 AND sr.amd172='1'
#      LET l_b25b=SUM(sr.amd07) WHERE sr.amd171='25' AND sr.amd17 ='2'
#                                 AND sr.amd172='1'
#      #-----MOD-750055---------
#      LET l_a26b=SUM(sr.amd07) WHERE sr.amd171='26' AND sr.amd17 ='1'
#                                 AND sr.amd172='1'
#      LET l_b26b=SUM(sr.amd07) WHERE sr.amd171='26' AND sr.amd17 ='2'
#                                 AND sr.amd172='1'
#      LET l_a27b=SUM(sr.amd07) WHERE sr.amd171='27' AND sr.amd17 ='1'
#                                 AND sr.amd172='1'
#      LET l_b27b=SUM(sr.amd07) WHERE sr.amd171='27' AND sr.amd17 ='2'
#                                 AND sr.amd172='1'
#      #-----END MOD-750055-----
#      #BUGNO4197
#      LET l_a28b=SUM(sr.amd07) WHERE sr.amd171='28' AND sr.amd17 ='1'
#                                 AND sr.amd172='1'
#      LET l_b28b=SUM(sr.amd07) WHERE sr.amd171='28' AND sr.amd17 ='2'
#                                 AND sr.amd172='1'
#      #BUGNO4197
#      LET l_a29b=SUM(sr.amd07) WHERE sr.amd171='29' AND sr.amd17 ='1'   #no:7393
#                                 AND sr.amd172='1'
#      LET l_b29b=SUM(sr.amd07) WHERE sr.amd171='29' AND sr.amd17 ='2'   #no:7393
#                                 AND sr.amd172='1'
#
#      IF cl_null(l_a21a) THEN LET l_a21a=0 END IF
#      IF cl_null(l_b21a) THEN LET l_b21a=0 END IF
#      IF cl_null(l_a22a) THEN LET l_a22a=0 END IF
#      IF cl_null(l_b22a) THEN LET l_b22a=0 END IF
#      IF cl_null(l_a23a) THEN LET l_a23a=0 END IF
#      IF cl_null(l_b23a) THEN LET l_b23a=0 END IF
#      IF cl_null(l_a24a) THEN LET l_a24a=0 END IF
#      IF cl_null(l_b24a) THEN LET l_b24a=0 END IF
#      IF cl_null(l_a25a) THEN LET l_a25a=0 END IF
#      IF cl_null(l_b25a) THEN LET l_b25a=0 END IF
#      #-----MOD-750055---------
#      IF cl_null(l_a26a) THEN LET l_a26a=0 END IF
#      IF cl_null(l_b26a) THEN LET l_b26a=0 END IF
#      IF cl_null(l_a27a) THEN LET l_a27a=0 END IF
#      IF cl_null(l_b27a) THEN LET l_b27a=0 END IF
#      #-----END MOD-750055-----
#      IF cl_null(l_a28a) THEN LET l_a28a=0 END IF
#      IF cl_null(l_b28a) THEN LET l_b28a=0 END IF
#      IF cl_null(l_a29a) THEN LET l_a29a=0 END IF   #no:7393
#      IF cl_null(l_b29a) THEN LET l_b29a=0 END IF   #no:7393
#      IF cl_null(l_a21b) THEN LET l_a21b=0 END IF
#      IF cl_null(l_b21b) THEN LET l_b21b=0 END IF
#      IF cl_null(l_a22b) THEN LET l_a22b=0 END IF
#      IF cl_null(l_b22b) THEN LET l_b22b=0 END IF
#      IF cl_null(l_a23b) THEN LET l_a23b=0 END IF
#      IF cl_null(l_b23b) THEN LET l_b23b=0 END IF
#      IF cl_null(l_a24b) THEN LET l_a24b=0 END IF
#      IF cl_null(l_b24b) THEN LET l_b24b=0 END IF
#      IF cl_null(l_a25b) THEN LET l_a25b=0 END IF
#      IF cl_null(l_b25b) THEN LET l_b25b=0 END IF
#      #-----MOD-750055---------
#      IF cl_null(l_a26b) THEN LET l_a26b=0 END IF
#      IF cl_null(l_b26b) THEN LET l_b26b=0 END IF
#      IF cl_null(l_a27b) THEN LET l_a27b=0 END IF
#      IF cl_null(l_b27b) THEN LET l_b27b=0 END IF
#      #-----END MOD-750055-----
#      IF cl_null(l_a28b) THEN LET l_a28b=0 END IF
#      IF cl_null(l_b28b) THEN LET l_b28b=0 END IF
#      IF cl_null(l_a29b) THEN LET l_a29b=0 END IF  #no:7393
#      IF cl_null(l_b29b) THEN LET l_b29b=0 END IF  #no:7393
#      #讀取進項免稅/零稅之金額
#      LET g_tot48=SUM(sr.amd08) WHERE sr.amd171 MATCHES '2*'
#                                        #AND sr.amd171<>'23' AND sr.amd171<>'24'   #MOD-750055
#                                        AND sr.amd171<>'23' AND sr.amd171<>'24' AND sr.amd171<>'29'  #MOD-750055
#                                        AND sr.amd17='1' AND sr.amd172<>'1'
#      LET g_tot49=SUM(sr.amd07+sr.amd08) WHERE  sr.amd171 MATCHES '2*'
#                                        #AND sr.amd171<>'23' AND sr.amd171<>'24'   #MOD-750055
#                                        AND sr.amd171<>'23' AND sr.amd171<>'24' AND sr.amd171<>'29'  #MOD-750055
#                                        AND sr.amd17='2' AND sr.amd172<>'1'
#      IF cl_null(g_tot48) THEN LET g_tot48 = 0 END IF
#      IF cl_null(g_tot49) THEN LET g_tot49 = 0 END IF
#      #記錄零稅金額
#      LET o_tot48=g_tot48
#      LET o_tot49=g_tot49
#      #讀取零稅率折讓金額
#      LET l_tot48=0  LET l_tot49=0
#      #LET l_tot48=SUM(sr.amd08) WHERE (sr.amd171='23' OR sr.amd171='24')   #MOD-750055
#      LET l_tot48=SUM(sr.amd08) WHERE (sr.amd171='23' OR sr.amd171='24' OR sr.amd171='29')   #MOD-750055
#                                        AND sr.amd17='1' AND sr.amd172<>'1'
#      IF cl_null(l_tot48) THEN LET l_tot48=0 END IF
#      #LET l_tot49=SUM(sr.amd08) WHERE (sr.amd171='23' OR sr.amd171='24')   #MOD-750055
#      LET l_tot49=SUM(sr.amd08) WHERE (sr.amd171='23' OR sr.amd171='24' OR sr.amd171='29')   #MOD-750055
#                                        AND sr.amd17='2' AND sr.amd172<>'1'
#      IF cl_null(l_tot49) THEN LET l_tot49=0 END IF
#      LET g_tot48 = g_tot48 - l_tot48
#      LET g_tot49 = g_tot49 - l_tot49
#
#      IF cl_null(g_tot48) THEN LET g_tot48 = 0 END IF
#      IF cl_null(g_tot49) THEN LET g_tot49 = 0 END IF
#
#      #-----MOD-750055---------
#      #LET l_aa = l_a21a+l_a22a-l_a23a-l_a24a-l_a29a+l_a25a+l_a28a #MODNO4197 no:7393
#      #LET l_ab = l_a21b+l_a22b-l_a23b-l_a24b-l_a29b+l_a25b+l_a28b #MODNO4197 no:7393
#      #LET l_ba = l_b21a+l_b22a-l_b23a-l_b24a-l_b29a+l_b25a+l_b28a #MODNO4197 no:7393
#      #LET l_bb = l_b21b+l_b22b-l_b23b-l_b24b-l_b29b+l_b25b+l_b28a #MODNO4197 no:7393
#      LET l_aa = l_a21a+l_a22a-l_a23a-l_a24a-l_a29a+l_a25a+l_a28a+l_a26a+l_a27a
#      LET l_ab = l_a21b+l_a22b-l_a23b-l_a24b-l_a29b+l_a25b+l_a28b+l_a26b+l_a27b
#      LET l_ba = l_b21a+l_b22a-l_b23a-l_b24a-l_b29a+l_b25a+l_b28a+l_b26a+l_b27a
#      LET l_bb = l_b21b+l_b22b-l_b23b-l_b24b-l_b29b+l_b25b+l_b28a+l_b26b+l_b27b
#      #-----END MOD-750055-----
#      LET g_tot48 = g_tot48 + l_aa
#      LET g_tot49 = g_tot49 + l_ba
#
#      SKIP 2 LINE
#      PRINT COLUMN g_c[31],g_x[11] CLIPPED,
#            COLUMN g_c[35] ,l_a21a USING l_mask,    # {21}
#            COLUMN g_c[37],g_x[23] CLIPPED,l_a21b USING l_mask
#      PRINT COLUMN g_c[31],g_x[12] CLIPPED,
#            COLUMN g_c[35],l_b21a USING l_mask,    # {21}
#            COLUMN g_c[37],g_x[23] CLIPPED,l_b21b USING l_mask
#      #-----MOD-750055---------
#      PRINT COLUMN g_c[31],g_x[24] CLIPPED,
#            COLUMN g_c[35] ,l_a26a USING l_mask,    # {26}
#            COLUMN g_c[37],g_x[23] CLIPPED,l_a26b USING l_mask
#      PRINT COLUMN g_c[31],g_x[14] CLIPPED,
#            COLUMN g_c[35],l_b26a USING l_mask,    # {26}
#            COLUMN g_c[37],g_x[23] CLIPPED,l_b26b USING l_mask
#      #-----END MOD-750055-----
#      PRINT COLUMN g_c[31],g_x[13] CLIPPED,
#            COLUMN g_c[35],l_a25a USING l_mask,    # {25}
#            COLUMN g_c[37],g_x[23] CLIPPED,l_a25b USING l_mask
#      PRINT COLUMN g_c[31],g_x[14] CLIPPED,
#            COLUMN g_c[35],l_b25a USING l_mask,    # {25}
#            COLUMN g_c[37],g_x[23] CLIPPED,l_b25b USING l_mask
#
#      PRINT COLUMN g_c[31],g_x[15] CLIPPED,
#            COLUMN g_c[35],l_a22a USING l_mask,    # {22}
#            COLUMN g_c[37],g_x[23] CLIPPED,l_a22b USING l_mask
#      PRINT COLUMN g_c[31],g_x[16] CLIPPED,
#            COLUMN g_c[35],l_b22a USING l_mask,    # {22}
#            COLUMN g_c[37],g_x[23] CLIPPED,l_b22b USING l_mask
#      #-----MOD-750055---------
#      PRINT COLUMN g_c[31],g_x[24] CLIPPED,
#            COLUMN g_c[35],l_a27a USING l_mask,    # {27}
#            COLUMN g_c[37],g_x[23] CLIPPED,l_a27b USING l_mask
#      PRINT COLUMN g_c[31],g_x[14] CLIPPED,
#            COLUMN g_c[35],l_b27a USING l_mask,    # {27}
#            COLUMN g_c[37],g_x[23] CLIPPED,l_b27b USING l_mask
#      #-----END MOD-750055-----  
#      #BUGNO4197
#      PRINT COLUMN g_c[31],g_x[17] CLIPPED,
#            COLUMN g_c[35],l_a28a USING l_mask,    # {28}
#            COLUMN g_c[37],g_x[23] CLIPPED,l_a28b USING l_mask
#      PRINT COLUMN g_c[31],g_x[14] CLIPPED,
#            COLUMN g_c[35],l_b28a USING l_mask,    # {28}
#            COLUMN g_c[37],g_x[23] CLIPPED,l_b28b USING l_mask
#      #BUGNO4197
#
#      PRINT COLUMN g_c[31],g_x[18] CLIPPED,
#            COLUMN g_c[35],l_a23a+l_a24a+l_a29a USING l_mask,    # {22}no:7393
#            COLUMN g_c[37],g_x[23] CLIPPED,l_a23b+l_a24b+l_a29b USING l_mask   #no:7393
#      PRINT COLUMN g_c[31],g_x[14] CLIPPED,
#            COLUMN g_c[35],l_b23a+l_b24a+l_b29a USING l_mask,    # {22}no:7393
#            COLUMN g_c[37],g_x[23] CLIPPED,l_b23b+l_b24b+l_b29b USING l_mask    #no:7393
#
#      PRINT COLUMN g_c[31],g_x[19] CLIPPED,
#            COLUMN g_c[35],l_aa USING l_mask,
#            COLUMN g_c[37],g_x[23] CLIPPED,l_ab USING l_mask
#      PRINT COLUMN g_c[31],g_x[14] CLIPPED,
#            COLUMN g_c[35],l_ba USING l_mask,
#            COLUMN g_c[37],g_x[23] CLIPPED,l_bb USING l_mask
#
#      SKIP 1 LINE
#      PRINT COLUMN g_c[31],g_x[20] CLIPPED,
#            COLUMN g_c[35],o_tot48 USING l_mask
#      PRINT COLUMN g_c[31],g_x[14] CLIPPED,
#            COLUMN g_c[35],o_tot49 USING l_mask
#      PRINT COLUMN g_c[31],g_x[21] CLIPPED,
#            COLUMN g_c[35],l_tot48 USING l_mask
#      PRINT COLUMN g_c[31],g_x[14] CLIPPED,
#            COLUMN g_c[35],l_tot49 USING l_mask
#      SKIP 1 LINE
#      PRINT COLUMN g_c[31],g_x[22] CLIPPED,
#            COLUMN g_c[35],g_tot48 USING l_mask,
#            COLUMN g_c[37],g_x[23] CLIPPED,l_ab USING l_mask
#      PRINT COLUMN g_c[31],g_x[14] CLIPPED,
#            COLUMN g_c[35],g_tot49 USING l_mask,
#            COLUMN g_c[37],g_x[23] CLIPPED,l_bb USING l_mask
#      SKIP 1 LINE
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#No.FUN-750129  --End
 
FUNCTION err_chk(sr)
  DEFINE sr RECORD LIKE amd_file.*
  DEFINE sr1 RECORD
	            mark1  LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1) #無傳票號碼
	            mark2  LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1) #格式為空白
	            mark3  LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1) #資料年度/月份為空白
	            mark4  LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1) #稅額事後 * 0.05 > 1
	            mark5  LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1) #發票號碼為空白
	            mark6  LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1) #稅額錯誤
	            mark7  LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1) #統一編號錯誤
                    mark8  LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1) #統一編號錯誤
                    mark9  LIKE type_file.chr1        #No.FUN-680074 VARCHAR(1) #未金額為零錯誤
              END RECORD,
          l_amb03   LIKE amb_file.amb03,
          l_num,l_yy,l_mm LIKE type_file.num5,       #No.FUN-680074 SMALLINT
          l_flag  LIKE type_file.chr1                #No.FUN-680074 VARCHAR(1)
 
	     LET l_flag='N'
             INITIALIZE sr1.* TO NULL
             #----(1)-----無傳票編號-------
	     IF sr.amd28=' ' OR sr.amd28 IS NULL THEN
                LET sr1.mark1='*'
                LET l_flag='Y'
             END IF
             #----(2)-----申報格式空白/不為'21'/'22'/'25'-----
              IF sr.amd171=' '  OR sr.amd171 IS NULL AND NOT
 	        (sr.amd171='21' OR sr.amd171='22' OR sr.amd171='23' OR
		 sr.amd171='24' OR sr.amd171='25' OR
 	         sr.amd171='31' OR sr.amd171='32' OR sr.amd171='33' OR
		 sr.amd171='34' OR sr.amd171='35' OR sr.amd171='36')
              THEN
                  LET sr1.mark2='*'
                  LET l_flag='Y'
             END IF
             #----(3)-----資料年度空白 --------------
             IF sr.amd173 IS NULL THEN
                LET sr1.mark3='*'
                LET l_flag='Y'
             END IF
             #----(4)-----資料月份空白 --------------
             IF sr.amd174 IS NULL THEN
                LET sr1.mark3='*'
                LET l_flag='Y'
             END IF
             #----(5)-----未稅金額 --------------
	     IF sr.amd172 = '1' THEN              #稅額
                IF (sr.amd08*0.05-sr.amd07)>1 THEN
                   LET sr1.mark4='*'
                   LET l_flag='Y'
                END IF
             END IF
             #----(6)-----申報格式21/25但發票號碼空白------------
	     IF (sr.amd171='21' OR sr.amd171='25') AND
	         (sr.amd03=' ' OR sr.amd03 IS NULL ) THEN
                LET sr1.mark5='*'
                LET l_flag='Y'
             END IF
             #----(6-2)-----格式為 28 時，要為14碼其他為10碼--------
              #BUGNO4197
              LET l_num = LENGTH(sr.amd03)
              IF sr.amd171 = '28'
              THEN
                 IF l_num != 14 THEN LET sr1.mark5='*' LET l_flag = 'Y' END IF
              ELSE
                 IF l_num != 10 THEN LET sr1.mark5='*' LET l_flag = 'Y' END IF
              END IF
              #BUGNO4197..end
             #----(7)-----是不為正確的發票字軌------------
	     IF (sr.amd171='21' OR sr.amd171='25')   THEN
                LET l_amb03=sr.amd03[1,2]
   	        IF l_amb03!=' ' AND l_amb03 IS NOT NULL THEN
		   IF sr.amd03[3,3] matches "[1234567890]" THEN
                      LET l_yy = YEAR(sr.amd05)
                      LET l_mm = MONTH(sr.amd05)
	              CALL s_apkchk(l_yy,l_mm,l_amb03,sr.amd171)
		         RETURNING g_errno,g_msg
                     IF g_errno MATCHES '[1234]' THEN
                        IF g_errno='4'  THEN
		           LET sr1.mark2='*'
                        ELSE
                          LET sr1.mark3='*'
                        END IF
                        LET sr1.mark5='*'
                        LET l_flag='Y'
                     END IF
                   ELSE
                        LET sr1.mark5='*'
                        LET l_flag='Y'
                   END IF
                END IF
             END IF
             #----(8)-----稅額------------
	     IF sr.amd172 = '1' THEN              #稅額
		IF sr.amd07 = 0 THEN
                   LET sr1.mark6='*'
                   LET l_flag='Y'
                END IF
             ELSE
		IF sr.amd07 != 0 THEN
                   LET sr1.mark6='*'
                   LET l_flag='Y'
                END IF
             END IF
             #BUGNO4197
             #----(9)--申報格式不為'22''28'且廠商統一編號為空白或null-----
             IF sr.amd171 MATCHES '2*' AND sr.amd171!='22'  AND sr.amd171!='28'
                AND (sr.amd04=' ' OR sr.amd04 IS NULL)
              THEN LET sr1.mark8='*'
                   LET l_flag='Y'
             END IF
             #BUGNO4197 ..end
             #----(10)-----統一編號為空白或null-----
              IF NOT s_chkban(sr.amd04) THEN
                 LET sr1.mark8='*'
                 LET l_flag='Y'
              END IF
             #----(11)-----格式為 22 時，不為正確的發票字軌------------
	     IF sr.amd171='22'  THEN
		IF sr.amd172 = '2' THEN #no:6374:sr.amd17 = '3'拿掉
		   SLEEP 0
                ELSE
                   LET l_amb03=sr.amd03[1,2]
   	           IF l_amb03!=' ' AND l_amb03 IS NOT NULL THEN
		      IF sr.amd03[3,3] matches "[1234567890]" THEN
                         LET l_yy = YEAR(sr.amd05)
                         LET l_mm = MONTH(sr.amd05)
	                 CALL s_apkchk(l_yy,l_mm,l_amb03,sr.amd171)
		            RETURNING g_errno,g_msg
                         IF g_errno MATCHES '[1234]' THEN
                            IF g_errno='4'  THEN
		               LET sr1.mark2='*'
                            ELSE
                               LET sr1.mark3='*'
                            END IF
                            LET sr1.mark5='*'
                            LET l_flag='Y'
                         END IF
                      ELSE
                            LET sr1.mark5='*'
                            LET l_flag='Y'
                      END IF
                   ELSE
                      LET sr1.mark5='*'
                      LET l_flag='Y'
                   END IF
                END IF
             END IF
             #----(12)-----扣抵為 '3' ，稅額為 '2' 不檢查統一編號是否完整性
	     #             且為銷項不用 check
	     IF sr.amd171[1,1] matches '2*'  THEN
		IF sr.amd172 = '2' THEN #no:6374:sr.amd17 = '3'拿掉
		   SLEEP 0
                ELSE
	           IF  NOT s_chkban(sr.amd04) THEN
                           LET sr1.mark8='*'
                           LET l_flag='Y'
                   END IF
                END IF
             END IF
             #----(13)-----格式 36/31/32/35 時，判斷資料年月與發票需同一月份
              IF   sr.amd171 = '36' OR sr.amd171 ='31'
	        OR sr.amd171 = '32' OR sr.amd171 = '35' THEN
                   LET l_yy = YEAR(sr.amd05)
                   LET l_mm = MONTH(sr.amd05)
		   IF (l_yy*l_mm) != (sr.amd173*sr.amd174) THEN
                       LET sr1.mark3='*'
                       LET l_flag='Y'
                   END IF
              END IF
						
             #----(14)-----格式 21/22/25 時，判斷發票年月 >= 申報年月
              IF   sr.amd171 ='21' OR sr.amd171 ='22' OR sr.amd171 ='25' THEN
                   LET l_yy = YEAR(sr.amd05)
                   LET l_mm = MONTH(sr.amd05)
		#  IF (l_yy*l_mm) >= (tm.ama08*tm.ama09) THEN
                #      LET sr1.mark3='*'
                #      LET l_flag='Y'
                #  END IF
              END IF
             #----(15)-----待抵金額(未稅金額)為零---99.03.08 add----
              IF sr.amd08 IS NULL OR sr.amd08=0 THEN
                 LET sr1.mark9='*'
                 LET l_flag='Y'
              END IF
           RETURN sr1.*
END FUNCTION
#Patch....NO.TQC-610035 <001> #
 
#No.FUN-750129  --Begin
FUNCTION r500_cr(sr)
DEFINE sr           RECORD  LIKE amd_file.*
DEFINE l_gen02      LIKE gen_file.gen02
 
    INITIALIZE g_sr1.* TO NULL
    CALL g_str1.clear()
 
    CALL err_chk(sr.*) RETURNING g_sr1.*
    LET l_gen02=''
    SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.amduser
    IF SQLCA.SQLCODE OR cl_null(l_gen02) THEN
       LET l_gen02=sr.amduser
    END IF
    LET g_str1[1] = g_sr1.mark1,sr.amd28 CLIPPED
    LET g_str1[3] = g_sr1.mark5,sr.amd03
    LET g_str1[5] = g_sr1.mark2,sr.amd171
#FUN-860041-modify
#   LET g_str1[6] = g_sr1.mark3,sr.amd173-1911 USING '&&',
    LET g_str1[6] = g_sr1.mark3,sr.amd173-1911 USING '&&&',
                    sr.amd174 USING '&&'
#FUN-860041-modify-end
    LET g_str1[7] = g_sr1.mark8,sr.amd04
    LET g_str1[8] = g_sr1.mark9,cl_numfor(sr.amd08,17,g_azi04) CLIPPED
    LET g_str1[9] = g_sr1.mark6,sr.amd172
    LET g_str1[10]= g_sr1.mark4,cl_numfor(sr.amd07,17,g_azi04) CLIPPED
    RETURN l_gen02
END FUNCTION
#No.FUN-750129  --End
#TQC-790177
