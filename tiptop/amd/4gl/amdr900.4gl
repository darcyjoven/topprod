# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: amdr900.4gl
# Descriptions...: 媒體申報進項發票資料檢查表
# Date & Author..: 99/02/24 By Linda
# Note...........: 本作業主要為檢查在apa_file有發票號碼(單一發票)
#                  但未insert至發票檔(apk_file)中, 會影響媒體申報
# Date & Modify..: 03/08/12 By Wiky #No:7760 其錯誤訊息,請顯示狀況描述, 而非show 檔案名稱(rvw, apk...)
# Modify.........: No.9017 04/01/12 By Kitty plant長度修改
# Modify.........: No.FUN-510019 05/01/11 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-560209 05/06/23 By wujie   單號截位修改
# Modify.........: No.TQC-610057 06/01/24 By Kevin 修改外部參數接收
# Modify.........: No.FUN-660060 06/06/28 By Rainy 表頭期間置於中間
#
# Modify.........: No.FUN-680074 06/08/25 By huchenghao 類型轉換
# Modify.........: No.FUN-690116 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-750093 07/06/01 By jan報表改為使用crystal report
# Modify.........: No.FUN-760086 07/07/31 By jan報表打印條件修改
# Modify.........: No.TQC-780054 07/08/17 By sherry   to_date改為ifx語法        
# Modify.........: No.MOD-820025 08/02/13 By Smapmin 若rvw不存在,僅秀"收貨發票檔不存在該發票"
# Modify.........: No.TQC-860019 08/06/09 By cliare ON IDLE 控制調整
# Modify.........: No.FUN-940102 09/04/20 By dxfwo  新增使用者對營運中心的權限管控
# Modify.........: No.FUN-980004 09/08/26 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A10060 10/01/09 By wuxj   修改INSERT INTO加入oriu及orig這2個欄位
# Modify.........: No:FUN-A10098 10/01/18 By shiwuying GP5.2跨DB報表--財務類
# Modify.........: No.FUN-A70084 10/07/15 By lutingting GP5.2報表修改
# Modify.........: No.FUN-B80050 11/08/03 By minpp 程序撰写规范修改
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           wc          LIKE type_file.chr1000,    #No.FUN-680074 VARCHAR(1000)
           bdate       LIKE type_file.dat,        #No.FUN-680074 DATE
           edate       LIKE type_file.dat,        #No.FUN-680074 DATE
           sure        LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
           more        LIKE type_file.chr1        #No.FUN-680074 VARCHAR(1)
           END RECORD,
    g_ary  DYNAMIC ARRAY OF RECORD
	   plant       LIKE azp_file.azp01,       #No.FUN-680074 VARCHAR(10)#No:9017
	   dbs_new     LIKE type_file.chr21       #No.FUN-680074 VARCHAR(21)
	   END RECORD,
   #No.FUN-A10098 -BEGIN-----
   #l_plant_1      LIKE azp_file.azp01,
   #l_plant_2      LIKE azp_file.azp01,
   #l_plant_3      LIKE azp_file.azp01,
   #l_plant_4      LIKE azp_file.azp01,
   #l_plant_5      LIKE azp_file.azp01,
   #l_plant_6      LIKE azp_file.azp01,
   #l_plant_7      LIKE azp_file.azp01,
   #l_plant_8      LIKE azp_file.azp01,
   #l_plant_9      LIKE azp_file.azp01,
   #No.FUN-A10098 -END-------
    g_zo06 LIKE zo_file.zo06,
    g_zo11 LIKE zo_file.zo11,
    g_idx  LIKE type_file.num10      #No.FUN-680074 INTEGER
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680074 SMALLINT
DEFINE   g_str           STRING                  #No.FUN-750093
DEFINE   l_table         STRING                  #No.FUN-750093
DEFINE   g_sql           STRING                  #No.FUN_750093
 
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
 
   FOR g_idx = 1 TO 9
       LET g_ary[g_idx].plant  = NULL
       LET g_ary[g_idx].dbs_new  = NULL
   END FOR
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
#-----TQC-610057---------
   LET tm.wc    = ARG_VAL(7)
   LET tm.sure  = ARG_VAL(8)
   LET tm.bdate = ARG_VAL(9)
   LET tm.edate = ARG_VAL(10)
  #No.FUN-A10098 -BEGIN-----
  #LET g_ary[1].plant = ARG_VAL(11)
  #LET g_ary[2].plant = ARG_VAL(12)
  #LET g_ary[3].plant = ARG_VAL(13)
  #LET g_ary[4].plant = ARG_VAL(14)
  #LET g_ary[5].plant = ARG_VAL(15)
  #LET g_ary[6].plant = ARG_VAL(16)
  #LET g_ary[7].plant = ARG_VAL(17)
  #LET g_ary[8].plant = ARG_VAL(18)
  #LET g_ary[9].plant = ARG_VAL(19)
  ##No.FUN-570264 --start--
  #LET g_rep_user = ARG_VAL(20)
  #LET g_rep_clas = ARG_VAL(21)
  #LET g_template = ARG_VAL(22)
  #LET g_rpt_name = ARG_VAL(23)  #No.FUN-7C0078
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)
  #No.FUN-A10098 -END-------
#-----END TQC-610057-----
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'  THEN
      CALL r900_tm()
   ELSE
      CALL r900()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION r900_tm()
   DEFINE l_cmd        LIKE type_file.chr1000       #No.FUN-680074 VARCHAR(1000)
   DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680074 SMALLINT
   DEFINE li_result    LIKE type_file.num5          #No.FUN-940102
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 4 LET p_col = 15
   ELSE LET p_row = 4 LET p_col = 8
   END IF
 
   OPEN WINDOW r900_w AT p_row,p_col
        WITH FORM "amd/42f/amdr900"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET tm.sure='N'
#  LET l_plant_1= g_plant #No.FUN-A10098
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON  apa01, apa08
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
 END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r900_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
      
   END IF
 # IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
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
  #INPUT l_plant_1, l_plant_2, l_plant_3, l_plant_4, l_plant_5, l_plant_6,
  #      l_plant_7, l_plant_8,l_plant_9
  # WITHOUT DEFAULTS FROM plant_1, plant_2, plant_3, plant_4,
  #                       plant_5, plant_6, plant_7, plant_8, plant_9
 
  #     BEFORE FIELD plant_1
  #         IF g_multpl='N' THEN  #不為多工廠環境
  #            LET l_plant_1= g_plant
  #            LET g_plant_new= NULL
  #            LET g_dbs_new=NULL
  #            LET g_ary[1].plant = g_plant
  #            LET g_ary[1].dbs_new = g_dbs_new CLIPPED
  #            DISPLAY l_plant_1 TO FORMONLY.plant_1
  #            EXIT INPUT       #將不會I/P plant_2 plant_3 plant_4
  #         END IF
 
  #     AFTER FIELD plant_1
  #         LET g_plant_new= l_plant_1
  #         IF l_plant_1 = g_plant THEN
  #            LET g_dbs_new=''
  #            LET g_ary[1].plant = l_plant_1
  #            LET g_ary[1].dbs_new = g_dbs_new CLIPPED
  #         ELSE
  #            IF NOT cl_null(l_plant_1) THEN
  #               #檢查工廠並將新的資料庫放在g_dbs_new
  #               IF NOT s_chknplt(l_plant_1,'AAP','AAP') THEN
  #                  CALL cl_err(g_plant_new,g_errno,0)
  #                  NEXT FIELD plant_1
  #               END IF
  #               LET g_ary[1].plant = l_plant_1
  #               CALL s_getdbs()
  #               LET g_ary[1].dbs_new = g_dbs_new
  ##No.FUN-940102 --begin--
  #            CALL s_chk_demo(g_user,l_plant_1) RETURNING li_result
  #             IF not li_result THEN 
  #              NEXT FIELD plant_1
  #             END IF 
  ##No.FUN-940102 --end-- 
  #            ELSE                     #輸入之工廠編號為' '或NULL
  #               LET g_ary[1].plant = l_plant_1
  #            END IF
  #         END IF
 
  #     AFTER FIELD plant_2
  #         LET l_plant_2 = duplicate(l_plant_2,1)   #不使"工廠編號"重覆
  #         LET g_plant_new= l_plant_2
  #         IF l_plant_2 = g_plant THEN
  #            LET g_dbs_new=''
  #            LET g_ary[2].plant = l_plant_2
  #            LET g_ary[2].dbs_new = g_dbs_new CLIPPED
  #         ELSE
  #            IF NOT cl_null(l_plant_2) THEN
  #                                     #檢查工廠並將新的資料庫放在g_dbs_new
  #               IF NOT s_chknplt(l_plant_2,'AAP','AAP') THEN
  #                  CALL cl_err(g_plant_new,g_errno,0)
  #                  NEXT FIELD plant_2
  #               END IF
  #               LET g_ary[2].plant = l_plant_2
  #               CALL s_getdbs()
  #               LET g_ary[2].dbs_new = g_dbs_new
  ##No.FUN-940102 --begin--
  #            CALL s_chk_demo(g_user,l_plant_2) RETURNING li_result
  #             IF not li_result THEN 
  #              NEXT FIELD plant_2
  #             END IF 
  ##No.FUN-940102 --end-- 
  #            ELSE                     #輸入之工廠編號為' '或NULL
  #               LET g_ary[2].plant = l_plant_2
  #            END IF
  #         END IF
 
  #     AFTER FIELD plant_3
  #         LET l_plant_3 = duplicate(l_plant_3,2)   #不使"工廠編號"重覆
  #         LET g_plant_new= l_plant_3
  #         IF l_plant_3 = g_plant THEN
  #            LET g_dbs_new=''
  #            LET g_ary[3].plant = l_plant_3
  #            LET g_ary[3].dbs_new = g_dbs_new CLIPPED
  #         ELSE
  #            IF NOT cl_null(l_plant_3) THEN
  #                                     #檢查工廠並將新的資料庫放在g_dbs_new
  #               IF NOT s_chknplt(l_plant_3,'AAP','AAP') THEN
  #                  CALL cl_err(g_plant_new,g_errno,0)
  #                  NEXT FIELD plant_3
  #               END IF
  #               LET g_ary[3].plant = l_plant_3
  #               CALL s_getdbs()
  #               LET g_ary[3].dbs_new = g_dbs_new
  ##No.FUN-940102 --begin--
  #            CALL s_chk_demo(g_user,l_plant_3) RETURNING li_result
  #             IF not li_result THEN 
  #              NEXT FIELD plant_3
  #             END IF 
  ##No.FUN-940102 --end-- 
  #            ELSE                     #輸入之工廠編號為' '或NULL
  #               LET g_ary[3].plant = l_plant_3
  #            END IF
  #         END IF
 
  #     AFTER FIELD plant_4
  #         LET l_plant_4 = duplicate(l_plant_4,3)   #不使"工廠編號"重覆
  #         LET g_plant_new= l_plant_4
  #         IF l_plant_4 = g_plant THEN
  #            LET g_dbs_new=''
  #            LET g_ary[4].plant = l_plant_4
  #            LET g_ary[4].dbs_new = g_dbs_new CLIPPED
  #         ELSE
  #            IF NOT cl_null(l_plant_4) THEN
  #                                     #檢查工廠並將新的資料庫放在g_dbs_new
  #               IF NOT s_chknplt(l_plant_4,'AAP','AAP') THEN
  #                  CALL cl_err(g_plant_new,g_errno,0)
  #                  NEXT FIELD plant_4
  #               END IF
  #               LET g_ary[4].plant = l_plant_4
  #               CALL s_getdbs()
  #               LET g_ary[4].dbs_new = g_dbs_new
  ##No.FUN-940102 --begin--
  #            CALL s_chk_demo(g_user,l_plant_4) RETURNING li_result
  #             IF not li_result THEN 
  #              NEXT FIELD plant_4
  #             END IF 
  ##No.FUN-940102 --end-- 
  #            ELSE                     #輸入之工廠編號為' '或NULL
  #               LET g_ary[4].plant = l_plant_4
  #            END IF
  #         END IF
  #     AFTER FIELD plant_5
  #         LET l_plant_5 = duplicate(l_plant_5,4)   #不使"工廠編號"重覆
  #         LET g_plant_new= l_plant_5
  #         IF l_plant_5 = g_plant THEN
  #            LET g_dbs_new=''
  #            LET g_ary[5].plant = l_plant_5
  #            LET g_ary[5].dbs_new = g_dbs_new CLIPPED
  #         ELSE
  #            IF NOT cl_null(l_plant_5) THEN
  #                                     #檢查工廠並將新的資料庫放在g_dbs_new
  #               IF NOT s_chknplt(l_plant_5,'AAP','AAP') THEN
  #                  CALL cl_err(g_plant_new,g_errno,0)
  #                  NEXT FIELD plant_5
  #               END IF
  #               LET g_ary[5].plant = l_plant_5
  #               CALL s_getdbs()
  #               LET g_ary[5].dbs_new = g_dbs_new
  ##No.FUN-940102 --begin--
  #            CALL s_chk_demo(g_user,l_plant_5) RETURNING li_result
  #             IF not li_result THEN 
  #              NEXT FIELD plant_5
  #             END IF 
  ##No.FUN-940102 --end-- 
  #            ELSE                     #輸入之工廠編號為' '或NULL
  #               LET g_ary[5].plant = l_plant_5
  #            END IF
  #         END IF
  #     AFTER FIELD plant_6
  #         LET l_plant_6 = duplicate(l_plant_6,5)   #不使"工廠編號"重覆
  #         LET g_plant_new= l_plant_6
  #         IF l_plant_6 = g_plant THEN
  #            LET g_dbs_new=''
  #            LET g_ary[6].plant = l_plant_6
  #            LET g_ary[6].dbs_new = g_dbs_new CLIPPED
  #         ELSE
  #            IF NOT cl_null(l_plant_6) THEN
  #                                     #檢查工廠並將新的資料庫放在g_dbs_new
  #               IF NOT s_chknplt(l_plant_6,'AAP','AAP') THEN
  #                  CALL cl_err(g_plant_new,g_errno,0)
  #                  NEXT FIELD plant_6
  #               END IF
  #               LET g_ary[6].plant = l_plant_6
  #               CALL s_getdbs()
  #               LET g_ary[6].dbs_new = g_dbs_new
  ##No.FUN-940102 --begin--
  #            CALL s_chk_demo(g_user,l_plant_6) RETURNING li_result
  #             IF not li_result THEN 
  #              NEXT FIELD plant_6
  #             END IF 
  ##No.FUN-940102 --end-- 
  #            ELSE                     #輸入之工廠編號為' '或NULL
  #               LET g_ary[6].plant = l_plant_6
  #            END IF
  #         END IF
 
  #     AFTER FIELD plant_7
  #         LET l_plant_7 = duplicate(l_plant_7,4)   #不使"工廠編號"重覆
  #         LET g_plant_new= l_plant_7
  #         IF l_plant_7 = g_plant THEN
  #            LET g_dbs_new=''
  #            LET g_ary[7].plant = l_plant_7
  #            LET g_ary[7].dbs_new = g_dbs_new CLIPPED
  #         ELSE
  #            IF NOT cl_null(l_plant_7) THEN
  #                                     #檢查工廠並將新的資料庫放在g_dbs_new
  #               IF NOT s_chknplt(l_plant_7,'AAP','AAP') THEN
  #                  CALL cl_err(g_plant_new,g_errno,0)
  #                  NEXT FIELD plant_7
  #               END IF
  #               LET g_ary[7].plant = l_plant_7
  #               CALL s_getdbs()
  #               LET g_ary[7].dbs_new = g_dbs_new
  ##No.FUN-940102 --begin--
  #            CALL s_chk_demo(g_user,l_plant_7) RETURNING li_result
  #             IF not li_result THEN 
  #              NEXT FIELD plant_7
  #             END IF 
  ##No.FUN-940102 --end-- 
  #            ELSE                     #輸入之工廠編號為' '或NULL
  #               LET g_ary[7].plant = l_plant_7
  #            END IF
  #         END IF
  #     AFTER FIELD plant_8
  #         LET l_plant_8 = duplicate(l_plant_8,5)   #不使"工廠編號"重覆
  #         LET g_plant_new= l_plant_8
  #         IF l_plant_8 = g_plant THEN
  #            LET g_dbs_new=''
  #            LET g_ary[8].plant = l_plant_8
  #            LET g_ary[8].dbs_new = g_dbs_new CLIPPED
  #         ELSE
  #            IF NOT cl_null(l_plant_8) THEN
  #                                     #檢查工廠並將新的資料庫放在g_dbs_new
  #               IF NOT s_chknplt(l_plant_8,'AAP','AAP') THEN
  #                  CALL cl_err(g_plant_new,g_errno,0)
  #                  NEXT FIELD plant_8
  #               END IF
  #               LET g_ary[8].plant = l_plant_8
  #               CALL s_getdbs()
  #               LET g_ary[8].dbs_new = g_dbs_new
  ##No.FUN-940102 --begin--
  #            CALL s_chk_demo(g_user,l_plant_8) RETURNING li_result
  #             IF not li_result THEN 
  #              NEXT FIELD plant_8
  #             END IF 
  ##No.FUN-940102 --end-- 
  #            ELSE                     #輸入之工廠編號為' '或NULL
  #               LET g_ary[8].plant = l_plant_8
  #            END IF
  #         END IF
  #     AFTER FIELD plant_9
  #         LET l_plant_9 = duplicate(l_plant_9,5)   #不使"工廠編號"重覆
  #         LET g_plant_new= l_plant_9
  #         IF l_plant_9 = g_plant THEN
  #            LET g_dbs_new=''
  #            LET g_ary[9].plant = l_plant_9
  #            LET g_ary[9].dbs_new = g_dbs_new CLIPPED
  #         ELSE
  #            IF NOT cl_null(l_plant_9) THEN
  #                                     #檢查工廠並將新的資料庫放在g_dbs_new
  #               IF NOT s_chknplt(l_plant_9,'AAP','AAP') THEN
  #                  CALL cl_err(g_plant_new,g_errno,0)
  #                  NEXT FIELD plant_9
  #               END IF
  #               LET g_ary[9].plant = l_plant_9
  #               CALL s_getdbs()
  #               LET g_ary[9].dbs_new = g_dbs_new
  ##No.FUN-940102 --begin--
  #            CALL s_chk_demo(g_user,l_plant_9) RETURNING li_result
  #             IF not li_result THEN 
  #              NEXT FIELD plant_9
  #             END IF 
  ##No.FUN-940102 --end-- 
  #            ELSE                     #輸入之工廠編號為' '或NULL
  #               LET g_ary[9].plant = l_plant_9
  #            END IF
  #         END IF
  #         IF cl_null(l_plant_1) AND cl_null(l_plant_2) AND
  #            cl_null(l_plant_3) AND cl_null(l_plant_4) THEN
  #            CALL cl_err(0,'aap-136',0)
  #            NEXT FIELD plant_1
  #         END IF
 
  #       #TQC-860019-add
  #       ON IDLE g_idle_seconds
  #       CALL cl_on_idle()
  #       CONTINUE INPUT
  #       #TQC-860019-add
 
  #       ON ACTION exit
  #       LET INT_FLAG = 1
  #       EXIT INPUT
  #      END INPUT
  #     IF INT_FLAG THEN
  #        LET INT_FLAG = 0 CLOSE WINDOW r122_w
  #        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
  #        EXIT PROGRAM
  #     END IF
  #No.FUN-A10098 -END-------
 
   INPUT BY NAME tm.bdate,tm.edate,tm.sure, tm.more
                 WITHOUT DEFAULTS
      AFTER FIELD bdate
         IF tm.bdate IS NULL THEN
            NEXT FIELD bdate
         END IF
      AFTER FIELD edate
         IF tm.edate IS NULL OR tm.bdate > tm.edate THEN
            NEXT FIELD edate
         END IF
      AFTER FIELD sure
         IF tm.sure IS NULL OR tm.sure NOT MATCHES '[YN]' THEN
            NEXT FIELD sure
         END IF
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
         IF tm.bdate IS NULL THEN
            NEXT FIELD bdate
         END IF
         IF tm.edate IS NULL OR tm.bdate > tm.edate THEN
            NEXT FIELD edate
         END IF
         IF tm.sure IS NULL OR tm.sure NOT MATCHES '[YN]' THEN
            NEXT FIELD sure
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r900_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='amdr900'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amdr900','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'" ,
                         #-----TQC-610057---------
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.sure CLIPPED,"'",
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                        #No.FUN-A10098 -BEGIN-----
                        #" '",g_ary[1].plant CLIPPED,"'",
                        #" '",g_ary[2].plant CLIPPED,"'",
                        #" '",g_ary[3].plant CLIPPED,"'",
                        #" '",g_ary[4].plant CLIPPED,"'",
                        #" '",g_ary[5].plant CLIPPED,"'",
                        #" '",g_ary[6].plant CLIPPED,"'",
                        #" '",g_ary[7].plant CLIPPED,"'",
                        #" '",g_ary[8].plant CLIPPED,"'",
                        #" '",g_ary[9].plant CLIPPED,"'",
                        #No.FUN-A10098 -END-------
                         #-----END TQC-610057-----
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('amdr900',g_time,l_cmd)
      END IF
      CLOSE WINDOW r900_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r900()
   ERROR ""
END WHILE
   CLOSE WINDOW r900_w
END FUNCTION
 
FUNCTION r900()
   DEFINE l_name    LIKE type_file.chr20,      #No.FUN-680074 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0068
          l_sql     STRING,                    # RDSQL STATEMENT        #No.FUN-680074
          l_chr     LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,    #No.FUN-680074 VARCHAR(40)
          l_idx     LIKE type_file.num5,       #No.FUN-680074 SMALLINT
          l_apk01   LIKE apk_file.apk01,
          l_apk02   LIKE apk_file.apk02,
          l_apk03   LIKE apk_file.apk03,
          l_apk07   LIKE apk_file.apk07,
          l_apk08   LIKE apk_file.apk08,
          l_rvw     RECORD LIKE rvw_file.*,
          l_str     LIKE type_file.chr1000,    #No.FUN-680074 VARCHAR(40)
          sr    RECORD  LIKE apa_file.*
#No.FUN-560209--begin
   DEFINE l_aza41   LIKE aza_file.aza41,
          g_cnt     LIKE type_file.chr1        #No.FUN-680074 VARCHAR(01)
#No.FUN-560209--end
   DEFINE err       LIKE apa_file.apa25        #No.FUN-750093
 
     SELECT zo02,zo06,zo11 INTO g_company,g_zo06,g_zo11
                            FROM zo_file WHERE zo01 = g_rlang
#No.FUN-750093--Begin
    LET g_sql =  "apa01.apa_file.apa01,",
                 "apa02.apa_file.apa02,",
                 "apa08.apa_file.apa08,",
                 "apa41.apa_file.apa41,",
                 "apa25.apa_file.apa25,",
                 "l_str.type_file.chr1000,",
                 "plant.azp_file.azp01"
     LET l_table = cl_prt_temptable('amdr900',g_sql)CLIPPED
     IF l_table = -1 THEN 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80050    ADD
        EXIT PROGRAM 
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED," values(?,?,?,?,?,?,?) "
       PREPARE insert_prep FROM g_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err("insert_prep:",STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80050    ADD
        EXIT PROGRAM
     END IF
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
#No.FUN-750093--End
     LET g_success='Y'
#    CALL cl_outnam('amdr900') RETURNING l_name  #No.FUN-750093
#       START REPORT r900_rep TO l_name          #No.FUN-750093
    #No.FUN-A10098 -BEGIN-----
    #LET g_pageno = 0
    #FOR g_idx =  1 TO 9
    #   IF cl_null(g_ary[g_idx].plant) THEN
    #      CONTINUE FOR
    #   END IF
    #No.FUN-A10098 -END-------
#No.FUN560209--begin
       #No.FUN-A10098 -BEGIN-----
       #LET l_sql = "SELECT aza41 FROM ",g_ary[g_idx].dbs_new,"aza_file"
        LET l_sql = "SELECT aza41 FROM aza_file"
       #No.FUN-A10098 -END-------
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        PREPARE aza_cur FROM l_sql
        EXECUTE aza_cur INTO l_aza41
        CASE l_aza41
          WHEN '1'  LET  g_cnt ='4'
          WHEN '2'  LET  g_cnt ='5'
          WHEN '3'  LET  g_cnt ='6'
        END CASE
#No.FUN560209--end
        LET l_sql=" SELECT * ",   
                #" FROM ",g_ary[g_idx].dbs_new CLIPPED,"apa_file", #No.FUN-A10098
                 " FROM apa_file",                                 #No.FUN-A10098
                 " WHERE  apa08 is not null and apa08<>' ' ",
                 "   AND apa08<>apa01 ",        #不為帳單號碼
#                "   AND apa08[4]<>'-' ",
                #"   AND SUBSTRING(apa08,",g_cnt,",",g_cnt,")<>'-' ", #No.FUN-560209 #No.FUN-A10098
                 "   AND apa08[",g_cnt,",",g_cnt,"] <> '-' ",    #No.FUN-A10098
                #No.+145 BY PLUM 010528 不為收據或MISC或UNAP(暫估)
                #"   AND apa08 <> 'REC' AND apa08<>'MISC' ",
                 "   AND apa08 <>'REC' AND apa08<>'MISC' AND apa08 <>'UNAP' ",
                #No.+145..end
                 "   AND apa01 not in ",
                 "         (SELECT apk01  FROM ",
                #     g_ary[g_idx].dbs_new CLIPPED,"apk_file) ", #No.FUN-A10098
                 "    apk_file) ",                               #No.FUN-A10098
                 " AND apa00 matches '1*' ",  
                 "  AND apaacti='Y' ",     #確認/有效
                 "  AND apa42 = 'N' ",
#                "  AND apa02 BETWEEN CAST('",tm.bdate,"' AS DATETIME) AND CAST('",tm.edate,"' AS DATETIME) ",     #No.FUN-750093
                 #No.TQC-780054---Begin
                 #"  AND apa02 BETWEEN to_date('",tm.bdate,"','yy/mm/dd')",     #No.FUN-750093
                 #"  AND CAST('",tm.edate,"' AS DATETIME) ",                  #No.FUN_750093
                #"  AND apa02 BETWEEN CAST('",tm.bdate,"' AS DATETIME) AND CAST('",tm.edate,"' AS DATETIME) ",     #No.FUN-750093 #No.FUN-A10098
                 "  AND apa02 BETWEEN CAST('",tm.bdate,"' AS DATE) AND CAST('",tm.edate,"' AS DATE) ",   #No.FUN-A10098
                 #No.TQC-780054---End
                 "  AND ",tm.wc clipped ," ORDER BY apa01"                       
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        PREPARE r900_prepare1 FROM l_sql
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('prepare:',SQLCA.sqlcode,1)
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
           EXIT PROGRAM
        END IF
        DECLARE r900_curs1 CURSOR FOR r900_prepare1
        FOREACH r900_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          #新增至發票檔
          IF tm.sure = 'Y' THEN
          #  CALL r900_insapk(g_ary[g_idx].dbs_new,sr.*) #No.FUN-A10098
          #  CALL r900_insapk('',sr.*)                   #No.FUN-A10098    #FUN-A70084
             CALL r900_insapk(sr.*)                      #FUN-A70084
          END IF
#No.FUN-750093--Begin
#         OUTPUT TO REPORT r900_rep('1',g_ary[g_idx].plant,sr.*,'')    
          LET err = '1'
          EXECUTE insert_prep USING
         #        sr.apa01,sr.apa02,sr.apa08,sr.apa41,err,' ',g_ary[g_idx].plant #No.FUN-A10098
                  sr.apa01,sr.apa02,sr.apa08,sr.apa41,err,' ',''                 #No.FUN-A10098
#No>FUN-750093--End
        END FOREACH
        #檢查進項發票金額與rvw_file 資料不合時出報表`
        LET l_sql=" SELECT apa02,apa41,apk01,apk02,apk03,apk07,apk08 ",
                 #No.FUN-A10098 -BEGIN-----
                 #" FROM ",g_ary[g_idx].dbs_new CLIPPED,"apk_file,",
                 #    g_ary[g_idx].dbs_new CLIPPED,"apa_file ",
                  " FROM apk_file,apa_file ",
                 #No.FUN-A10098 -END-------
                 " WHERE  apa00='11' AND apa01=apk01 ",
                 "   AND apa08<>apa01 ",        #不為帳單號碼
                #No.+145 BY PLUM 010528 不為UNAP(暫估),因rvw_file不會有
                #"   AND (apa08 IS NOT NULL AND apa08<>' ') ",
                 "   AND (apa08 IS NOT NULL AND apa08<>' '  AND  ",
                 "        apa08 <>'UNAP') ",
                #No.+145..end
#                "   AND apa08[4]<>'-' ",
                #"   AND SUBSTRING(apa08,",g_cnt,",",g_cnt,")<>'-' ",    #No.FUN-560209 #No.FUN-A10098
                 "   AND apa08[",g_cnt,",",g_cnt,"] <> '-' ",            #No.FUN-A10098
                 "  AND apaacti='Y' ",     #確認/有效
                 "  AND apa42 = 'N' ",
#                "  AND apa02 BETWEEN CAST('",tm.bdate,"' AS DATETIME) AND CAST('",tm.edate,"' AS DATETIME) ",   #No.FUN-750093
                #No.FUN-A10098 -BEGIN-----
                #"  AND apa02 BETWEEN CAST('",tm.bdate,"' AS DATETIME) ",  #No.FUN_750093
                #"  AND CAST('",tm.edate,"' AS DATETIME) ",                #No.FUN-750093
                 "  AND apa02 BETWEEN CAST('",tm.bdate,"' AS DATE) ",
                 "  AND CAST('",tm.edate,"' AS DATE) ",
                #No.FUN-A10098 -END-------
                 "  AND ",tm.wc clipped
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        PREPARE r900_prepare2 FROM l_sql
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('prepare:',SQLCA.sqlcode,1)
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
           EXIT PROGRAM
        END IF
        DECLARE r900_curs2 CURSOR FOR r900_prepare2
        #讀取發票檔(rvw_file)
           LET l_sql=" SELECT * ",    
                    #" FROM ",g_ary[g_idx].dbs_new CLIPPED,"rvw_file ", #No.FUN-A10098
                     " FROM rvw_file ",                                 #No.FUN-A10098
                     " WHERE  rvw01=? "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
           PREPARE r900_rvwpre FROM l_sql
           DECLARE r900_rvw CURSOR FOR r900_rvwpre
 
        FOREACH r900_curs2 INTO sr.apa02,sr.apa41,l_apk01,
                                l_apk02,l_apk03,l_apk07,l_apk08
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          OPEN r900_rvw USING l_apk03
          FETCH r900_rvw INTO l_rvw.*
          IF SQLCA.SQLCODE <> 0 OR l_rvw.rvw01 IS NULL THEN
             LET sr.apa01=l_apk01
             LET sr.apa08=l_apk03
#No.FUN-750093--Begin
#            OUTPUT TO REPORT r900_rep('2',g_ary[g_idx].plant,sr.*,'')  
             LET err = '2'
             EXECUTE insert_prep USING                                  
                    #sr.apa01,sr.apa02,sr.apa08,sr.apa41,err,' ',g_ary[g_idx].plant #No.FUN-A10098
                     sr.apa01,sr.apa02,sr.apa08,sr.apa41,err,' ',''                 #No.FUN-A10098
#No.FUN-750093--End        
             CONTINUE FOREACH   #MOD-820025
          END IF
          #未稅金額不符
          IF l_rvw.rvw05 <>l_apk08   THEN
             LET sr.apa01=l_apk01
             LET sr.apa08=l_apk03
             LET l_str="(rvw05(Tax):",l_rvw.rvw05 USING "#######&",  #No:7760
                       " apk08(Tax):",l_apk08 USING "#######&",")"
#No.FUN-750093--Begin
#            OUTPUT TO REPORT r900_rep('4',g_ary[g_idx].plant,sr.*,l_str)  
             LET err = '4'
             EXECUTE insert_prep USING                                           
             #       sr.apa01,sr.apa02,sr.apa08,sr.apa41,err,l_str,g_ary[g_idx].plant #No.FUN-A10098
                     sr.apa01,sr.apa02,sr.apa08,sr.apa41,err,l_str,'' #No.FUN-A10098
#No.FUN-750093--End
          END IF
          #稅額不符
          IF l_rvw.rvw06 <>l_apk07   THEN
             LET sr.apa01=l_apk01
             LET sr.apa08=l_apk03
             LET l_str="(rvw06(Tax):",l_rvw.rvw06 USING "#######&",  #No:7760
                       " apk07(Tax):",l_apk07 USING "#######&",")"
#No.FUN-750093--Begin
#            OUTPUT TO REPORT r900_rep('3',g_ary[g_idx].plant,sr.*,l_str)  
             LET err = '3'
             EXECUTE insert_prep USING                                     
             #       sr.apa01,sr.apa02,sr.apa08,sr.apa41,err,l_str,g_ary[g_idx].plant #No.FUN-A10098
                     sr.apa01,sr.apa02,sr.apa08,sr.apa41,err,l_str,'' #No.FUN-A10098
#No.FUN-750093--End
          END IF
        END FOREACH
   # END FOR #No.FUN-A10098
#No.FUN-750093--Begin
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   
     LET g_str = '' 
#No.FUN-760086--Begin                                                           
     IF g_zz05 = 'Y' THEN                                                         
          CALL cl_wcchp(tm.wc,'apa01, apa08')                              
               RETURNING g_str
     END IF                                                   
     LET g_str = tm.bdate,';',tm.edate,';',g_str
#No.FUN_760086--End
     CALL cl_prt_cs3('amdr900','amdr900',l_sql,g_str) 
#No.FUN-750093--End                                       
#    FINISH REPORT r900_rep          #No.FUN-750093
 
     IF g_success = 'Y'
        THEN CALL cl_cmmsg(1) COMMIT WORK
        ELSE CALL cl_rbmsg(1) ROLLBACK WORK
     END IF
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)   #No.FUN-750093
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
 
#FUNCTION r900_insapk(l_dbs,l_apa)   #FUN-A70084
FUNCTION r900_insapk(l_apa)   #FUN-A70084
#DEFINE l_dbs LIKE type_file.chr1000   #No.FUN-680074 VARCHAR(1000)   #FUN-A70084
 DEFINE l_apk RECORD LIKE apk_file.*
 DEFINE l_apa RECORD LIKE apa_file.*
 DEFINE l_sql STRING        #No.FUN-680074
 DEFINE l_legal LIKE type_file.chr10 #No.FUN-980004
 
   #LET l_apk.apklegal = s_getlegal(g_ary[g_idx].plant)  #No.FUN-980004 #No.FUN-A10098
    LET l_apk.apklegal = s_getlegal(g_plant)             #No.FUN-A10098
 
    LET l_apk.apk01=l_apa.apa01
    LET l_apk.apk02=1
    LET l_apk.apk03=l_apa.apa08
    LET l_apk.apk04=l_apa.apa18
    LET l_apk.apk05=l_apa.apa09
    LET l_apk.apk06=l_apa.apa31+l_apa.apa32
    LET l_apk.apk07=l_apa.apa32
    LET l_apk.apk08=l_apa.apa31
    LET l_apk.apk17=l_apa.apa17
    LET l_apk.apk171=l_apa.apa171
    LET l_apk.apk172=l_apa.apa172
    LET l_apk.apkacti='Y'
    LET l_apk.apkgrup=l_apa.apagrup
    LET l_apk.apkuser=l_apa.apauser
    LET l_apk.apkdate=g_today
    LET l_apk.apkoriu=g_user     #TQC-A10060  add
    LET l_apk.apkorig=g_grup     #TQC-A10060  add
    #新增發票檔
   #LET l_sql="INSERT INTO ",l_dbs CLIPPED,"apk_file", #No.FUN-A10098
    LET l_sql="INSERT INTO apk_file",                  #No.FUN-A10098
               "(apk01,apk02,apk03,apk04,apk05,apk06,apk07, ",
               " apk08,apk17,apk171,apk172,apkacti,apkgrup,apkuser,apkdate,apklegal,apkoriu,opkorig ) ", #TQC-A10060 add apkoriu,opkorig #No.FUN-980004
               " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,? ,?,?,?) " #No.FUN-980004 add ?    #TQC-A10060 add ?,?
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    PREPARE ins_apk FROM l_sql
    EXECUTE ins_apk USING
               l_apk.apk01,l_apk.apk02,l_apk.apk03,l_apk.apk04,
               l_apk.apk05,l_apk.apk06,l_apk.apk07,l_apk.apk08,
               l_apk.apk17,l_apk.apk171,l_apk.apk172,l_apk.apkacti,
               l_apk.apkgrup,l_apk.apkuser,l_apk.apkdate,l_apk.apklegal,l_apk.apkoriu,l_apk.apkorig  #No.FUN-980004 #TQC-A10060 add l_apk.apkoriu,l_apk.apkorig
    IF SQLCA.sqlcode THEN
       CALL cl_err('ins apk:',SQLCA.sqlcode,1)
       LET g_success = 'N'
    END IF
END FUNCTION
 
#No.FUN-750093--Begin
{
REPORT r900_rep(l_kind,l_plant,sr,l_str)
DEFINE l_last_sw    LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
       l_idx        LIKE type_file.num5,       #No.FUN-680074 SMALLINT
       l_kind       LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
       l_str        LIKE type_file.chr1000,    #No.FUN-680074 VARCHAR(40)
       g_head1      STRING,                    #No.FUN-680074
       sr           RECORD  LIKE apa_file.*
DEFINE l_plant      LIKE azp_file.azp01
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY  l_plant,l_kind,sr.apa01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1] CLIPPED
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      LET g_head1 = g_x[13],tm.bdate," - ",tm.edate
      #PRINT g_head1                                         #FUN-660060 remark
      PRINT COLUMN ((g_len-FGL_WIDTH(g_head1))/2)+1, g_head1 #FUN-660060
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE  GROUP OF l_plant
      PRINT COLUMN g_c[31], l_plant;
 
   ON EVERY ROW
      PRINT COLUMN g_c[32],sr.apa01,
            COLUMN g_c[33],sr.apa02,
            COLUMN g_c[34],sr.apa08,
            COLUMN g_c[35],sr.apa41;
      CASE l_kind
        WHEN '1' PRINT COLUMN g_c[36],g_x[9] CLIPPED
        WHEN '2' PRINT COLUMN g_c[36],g_x[10] CLIPPED
        WHEN '3' PRINT COLUMN g_c[36],g_x[11] CLIPPED
                 PRINT COLUMN g_c[36],l_str CLIPPED
        WHEN '4' PRINT COLUMN g_c[36],g_x[12] CLIPPED
                 PRINT COLUMN g_c[36],l_str CLIPPED
      END CASE
 
   AFTER GROUP OF l_plant
	 SKIP 2 LINES
 
   ON LAST ROW
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4] CLIPPED, COLUMN (g_len-9),g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4] CLIPPED, COLUMN (g_len-9),g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT}
#No.FUN-750093--End
