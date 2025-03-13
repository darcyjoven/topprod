# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: amdr111.4gl(仿amdr110.4gl)
# Descriptions...: 進項憑証折讓明細表列印作業(一)
# Date & Author..: 01/08/06  By  Chien
# Modify.........: No.FUN-510019 05/01/10 By Smapmin 報表轉XML格式
# Modify.........: No.TQC-610057 06/01/20 By Kevin 修改外部參數接收
# Modify.........: No.MOD-650069 06/05/15 By Smapmin 修正變數定義
# Modify.........: No.FUN-660060 06/06/36 By rainy 期間置於中間
# Modify.........: No.FUN-680074 06/08/24 By huchenghao 類型轉換
# Modify.........: No.FUN-690116 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.TQC-860019 08/06/09 By cliare ON IDLE 控制調整
# Modify.........: No.FUN-850053 08/05/13 By sherry 報表改由CR輸出
#                                08/09/25 By Cockroach CR 21-->31
# Modify.........: No.FUN-940102 09/04/20 By dxfwo  新增使用者對營運中心的權限管控
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A10098 10/01/19 By shiwuying GP5.2跨DB報表--財務類
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           wc          LIKE type_file.chr1000,    #No.FUN-680074 VARCHAR(1000)
           amd173_b    LIKE type_file.num10,      #No.FUN-680074 INTEGER
           amd174_b    LIKE type_file.num10,      #No.FUN-680074 INTEGER
           amd173_e    LIKE type_file.num10,      #No.FUN-680074 INTEGER
           amd174_e    LIKE type_file.num10,      #No.FUN-680074 INTEGER
           f           LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
           more        LIKE type_file.chr1        #No.FUN-680074 VARCHAR(1)
           END RECORD,
   #No.FUN-A10098 -BEGIN-----
   #g_ary  DYNAMIC ARRAY OF RECORD
   # Prog. Version..: '5.30.06-13.03.12(08),   #MOD-650069
   #       plant       LIKE azp_file.azp01,   #MOD-650069
   #       dbs_new     LIKE type_file.chr21   #No.FUN-680074 VARCHAR(21)
   #       END RECORD,
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
    g_idx  LIKE type_file.num10,       #No.FUN-680074 INTEGER
    g_dash_1 LIKE type_file.chr1000,   #No.FUN-680074 VARCHAR(140)
    g_dash_2 LIKE type_file.chr1000    #No.FUN-680074 VARCHAR(140)
DEFINE g_title      LIKE zaa_file.zaa08       #No.FUN-680074 VARCHAR(30)
 
DEFINE   g_i        LIKE type_file.num5       #count/index for any purpose        #No.FUN-680074 SMALLINT
#No.FUN-850053---Begin
DEFINE g_sql        STRING
DEFINE g_str        STRING
DEFINE l_table      STRING
#No.FUN-850053---End
 
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
   #No.FUN-850053---Begin
   LET g_sql = "l_no.type_file.num5,",
               "l_ser.type_file.num5,",
               "amd28.amd_file.amd28,",
               "amd01.amd_file.amd01,",
               "amd03.amd_file.amd03,",
               "amd171.amd_file.amd171,",
               "amd173.amd_file.amd173,",
               "amd174.amd_file.amd174,",
               "amd04.amd_file.amd04,",
               "amd08.amd_file.amd08,",
               "amd172.amd_file.amd172,",
               "amd07.amd_file.amd07,",
               "amd17.amd_file.amd17"
                
   LET l_table = cl_prt_temptable('amdr111',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF                                     
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,              
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,? )"          
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF                                                                       
   #NO.FUN-850053---End      

  #No.FUN-A10098 -BEGIN----- 
  #FOR g_idx = 1 TO 9
  #    LET g_ary[g_idx].plant  = NULL
  #    LET g_ary[g_idx].dbs_new  = NULL
  #END FOR
  #No.FUN-A10098 -END-------
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
#-----TQC-610057---------
   LET tm.wc= ARG_VAL(7)
   LET tm.amd173_b = ARG_VAL(8)
   LET tm.amd174_b = ARG_VAL(9)
   LET tm.amd173_e = ARG_VAL(10)
   LET tm.amd174_e = ARG_VAL(11)
  #No.FUN-A10098 -BEGIN-----
  #LET g_ary[1].plant = ARG_VAL(12)
  #LET g_ary[2].plant = ARG_VAL(13)
  #LET g_ary[3].plant = ARG_VAL(14)
  #LET g_ary[4].plant = ARG_VAL(15)
  #LET g_ary[5].plant = ARG_VAL(16)
  #LET g_ary[6].plant = ARG_VAL(17)
  #LET g_ary[7].plant = ARG_VAL(18)
  #LET g_ary[8].plant = ARG_VAL(19)
  #LET g_ary[9].plant = ARG_VAL(20)
  #LET tm.f = ARG_VAL(21)
  ##No.FUN-570264 --start--
  #LET g_rep_user = ARG_VAL(22)
  #LET g_rep_clas = ARG_VAL(23)
  #LET g_template = ARG_VAL(24)
  ##No.FUN-570264 ---end---
   LET tm.f = ARG_VAL(12)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
  #No.FUN-A10098 -END-------
#-----END TQC-610057-----
   IF cl_null(g_bgjob) OR g_bgjob = 'N'  THEN
      CALL r111_tm()
   ELSE
      CALL r111()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION r111_tm()
   DEFINE l_cmd        LIKE type_file.chr1000       #No.FUN-680074 VARCHAR(1000)
   DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680074 SMALLINT
   DEFINE li_result    LIKE type_file.num5          #No.FUN-940102 
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 3 LET p_col = 16
   ELSE LET p_row = 4 LET p_col = 12
   END IF
   OPEN WINDOW r111_w AT p_row,p_col
        WITH FORM "amd/42f/amdr111"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET tm.amd173_b = YEAR(g_today)
   LET tm.amd174_b = MONTH(g_today) - 1
   LET tm.amd173_e = YEAR(g_today)
   LET tm.amd174_e = MONTH(g_today) - 1
  #LET l_plant_1= g_plant  #No.FUN-A10098
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.f ='3'
 
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON  amd01, amd03,amd28
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
 
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r111_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
      
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF

#No.FUN-A10098 -BEGIN----- 
#  INPUT l_plant_1, l_plant_2, l_plant_3, l_plant_4, l_plant_5, l_plant_6,
#        l_plant_7, l_plant_8,l_plant_9
#   WITHOUT DEFAULTS FROM plant_1, plant_2, plant_3, plant_4,
#                         plant_5, plant_6, plant_7, plant_8, plant_9
#
#       BEFORE FIELD plant_1
#           IF g_multpl='N' THEN  #不為多工廠環境
#              LET l_plant_1= g_plant
#              LET g_plant_new= NULL
#              LET g_dbs_new=NULL
#              LET g_ary[1].plant = g_plant
#              LET g_ary[1].dbs_new = g_dbs_new CLIPPED
#              DISPLAY l_plant_1 TO FORMONLY.plant_1
#              EXIT INPUT       #將不會I/P plant_2 plant_3 plant_4
#           END IF
#
#       AFTER FIELD plant_1
#           LET g_plant_new= l_plant_1
#           IF l_plant_1 = g_plant THEN
#              LET g_dbs_new=''
#              LET g_ary[1].plant = l_plant_1
#              LET g_ary[1].dbs_new = g_dbs_new CLIPPED
#           ELSE
#              IF NOT cl_null(l_plant_1) THEN
#                 #檢查工廠並將新的資料庫放在g_dbs_new
#                 IF NOT s_chknplt(l_plant_1,'AAP','AAP') THEN
#                    CALL cl_err(g_plant_new,g_errno,0)
#                    NEXT FIELD plant_1
#                 END IF
#                 LET g_ary[1].plant = l_plant_1
#                 CALL s_getdbs()
#                 LET g_ary[1].dbs_new = g_dbs_new
#No.FUN-940102 --begin--
#              CALL s_chk_demo(g_user,l_plant_1) RETURNING li_result
#               IF not li_result THEN 
#                NEXT FIELD plant_1
#               END IF 
#No.FUN-940102 --end-- 
#              ELSE                     #輸入之工廠編號為' '或NULL
#                 LET g_ary[1].plant = l_plant_1
#              END IF
#           END IF
#
#       AFTER FIELD plant_2
#           LET l_plant_2 = duplicate(l_plant_2,1)   #不使"工廠編號"重覆
#           LET g_plant_new= l_plant_2
#           IF l_plant_2 = g_plant THEN
#              LET g_dbs_new=''
#              LET g_ary[2].plant = l_plant_2
#              LET g_ary[2].dbs_new = g_dbs_new CLIPPED
#           ELSE
#              IF NOT cl_null(l_plant_2) THEN
#                                       #檢查工廠並將新的資料庫放在g_dbs_new
#                 IF NOT s_chknplt(l_plant_2,'AAP','AAP') THEN
#                    CALL cl_err(g_plant_new,g_errno,0)
#                    NEXT FIELD plant_2
#                 END IF
#                 LET g_ary[2].plant = l_plant_2
#                 CALL s_getdbs()
#                 LET g_ary[2].dbs_new = g_dbs_new
#No.FUN-940102 --begin--
#              CALL s_chk_demo(g_user,l_plant_2) RETURNING li_result
#               IF not li_result THEN 
#                NEXT FIELD plant_2
#               END IF 
#No.FUN-940102 --end-- 
#              ELSE                     #輸入之工廠編號為' '或NULL
#                 LET g_ary[2].plant = l_plant_2
#              END IF
#           END IF
#
#       AFTER FIELD plant_3
#           LET l_plant_3 = duplicate(l_plant_3,2)   #不使"工廠編號"重覆
#           LET g_plant_new= l_plant_3
#           IF l_plant_3 = g_plant THEN
#              LET g_dbs_new=''
#              LET g_ary[3].plant = l_plant_3
#              LET g_ary[3].dbs_new = g_dbs_new CLIPPED
#           ELSE
#              IF NOT cl_null(l_plant_3) THEN
#                                       #檢查工廠並將新的資料庫放在g_dbs_new
#                 IF NOT s_chknplt(l_plant_3,'AAP','AAP') THEN
#                    CALL cl_err(g_plant_new,g_errno,0)
#                    NEXT FIELD plant_3
#                 END IF
#                 LET g_ary[3].plant = l_plant_3
#                 CALL s_getdbs()
#                 LET g_ary[3].dbs_new = g_dbs_new
#No.FUN-940102 --begin--
#              CALL s_chk_demo(g_user,l_plant_3) RETURNING li_result
#               IF not li_result THEN 
#                NEXT FIELD plant_3
#               END IF 
#No.FUN-940102 --end-- 
#              ELSE                     #輸入之工廠編號為' '或NULL
#                 LET g_ary[3].plant = l_plant_3
#              END IF
#           END IF
#
#       AFTER FIELD plant_4
#           LET l_plant_4 = duplicate(l_plant_4,3)   #不使"工廠編號"重覆
#           LET g_plant_new= l_plant_4
#           IF l_plant_4 = g_plant THEN
#              LET g_dbs_new=''
#              LET g_ary[4].plant = l_plant_4
#              LET g_ary[4].dbs_new = g_dbs_new CLIPPED
#           ELSE
#              IF NOT cl_null(l_plant_4) THEN
#                                       #檢查工廠並將新的資料庫放在g_dbs_new
#                 IF NOT s_chknplt(l_plant_4,'AAP','AAP') THEN
#                    CALL cl_err(g_plant_new,g_errno,0)
#                    NEXT FIELD plant_4
#                 END IF
#                 LET g_ary[4].plant = l_plant_4
#                 CALL s_getdbs()
#                 LET g_ary[4].dbs_new = g_dbs_new
#No.FUN-940102 --begin--
#              CALL s_chk_demo(g_user,l_plant_4) RETURNING li_result
#               IF not li_result THEN 
#                NEXT FIELD plant_4
#               END IF 
#No.FUN-940102 --end-- 
#              ELSE                     #輸入之工廠編號為' '或NULL
#                 LET g_ary[4].plant = l_plant_4
#              END IF
#           END IF
#       AFTER FIELD plant_5
#           LET l_plant_5 = duplicate(l_plant_5,4)   #不使"工廠編號"重覆
#           LET g_plant_new= l_plant_5
#           IF l_plant_5 = g_plant THEN
#              LET g_dbs_new=''
#              LET g_ary[5].plant = l_plant_5
#              LET g_ary[5].dbs_new = g_dbs_new CLIPPED
#           ELSE
#              IF NOT cl_null(l_plant_5) THEN
#                                       #檢查工廠並將新的資料庫放在g_dbs_new
#                 IF NOT s_chknplt(l_plant_5,'AAP','AAP') THEN
#                    CALL cl_err(g_plant_new,g_errno,0)
#                    NEXT FIELD plant_5
#                 END IF
#                 LET g_ary[5].plant = l_plant_5
#                 CALL s_getdbs()
#                 LET g_ary[5].dbs_new = g_dbs_new
#No.FUN-940102 --begin--
#              CALL s_chk_demo(g_user,l_plant_5) RETURNING li_result
#               IF not li_result THEN 
#                NEXT FIELD plant_5
#               END IF 
#No.FUN-940102 --end-- 
#              ELSE                     #輸入之工廠編號為' '或NULL
#                 LET g_ary[5].plant = l_plant_5
#              END IF
#           END IF
#       AFTER FIELD plant_6
#           LET l_plant_6 = duplicate(l_plant_6,5)   #不使"工廠編號"重覆
#           LET g_plant_new= l_plant_6
#           IF l_plant_6 = g_plant THEN
#              LET g_dbs_new=''
#              LET g_ary[6].plant = l_plant_6
#              LET g_ary[6].dbs_new = g_dbs_new CLIPPED
#           ELSE
#              IF NOT cl_null(l_plant_6) THEN
#                                       #檢查工廠並將新的資料庫放在g_dbs_new
#                 IF NOT s_chknplt(l_plant_6,'AAP','AAP') THEN
#                    CALL cl_err(g_plant_new,g_errno,0)
#                    NEXT FIELD plant_6
#                 END IF
#                 LET g_ary[6].plant = l_plant_6
#                 CALL s_getdbs()
#                 LET g_ary[6].dbs_new = g_dbs_new
#No.FUN-940102 --begin--
#              CALL s_chk_demo(g_user,l_plant_6) RETURNING li_result
#               IF not li_result THEN 
#                NEXT FIELD plant_6
#               END IF 
#No.FUN-940102 --end-- 
#              ELSE                     #輸入之工廠編號為' '或NULL
#                 LET g_ary[6].plant = l_plant_6
#              END IF
#           END IF
#
#       AFTER FIELD plant_7
#           LET l_plant_7 = duplicate(l_plant_7,4)   #不使"工廠編號"重覆
#           LET g_plant_new= l_plant_7
#           IF l_plant_7 = g_plant THEN
#              LET g_dbs_new=''
#              LET g_ary[7].plant = l_plant_7
#              LET g_ary[7].dbs_new = g_dbs_new CLIPPED
#           ELSE
#              IF NOT cl_null(l_plant_7) THEN
#                                       #檢查工廠並將新的資料庫放在g_dbs_new
#                 IF NOT s_chknplt(l_plant_7,'AAP','AAP') THEN
#                    CALL cl_err(g_plant_new,g_errno,0)
#                    NEXT FIELD plant_7
#                 END IF
#                 LET g_ary[7].plant = l_plant_7
#                 CALL s_getdbs()
#                 LET g_ary[7].dbs_new = g_dbs_new
#No.FUN-940102 --begin--
#              CALL s_chk_demo(g_user,l_plant_7) RETURNING li_result
#               IF not li_result THEN 
#                NEXT FIELD plant_7
#               END IF 
#No.FUN-940102 --end-- 
#              ELSE                     #輸入之工廠編號為' '或NULL
#                 LET g_ary[7].plant = l_plant_7
#              END IF
#           END IF
#       AFTER FIELD plant_8
#           LET l_plant_8 = duplicate(l_plant_8,5)   #不使"工廠編號"重覆
#           LET g_plant_new= l_plant_8
#           IF l_plant_8 = g_plant THEN
#              LET g_dbs_new=''
#              LET g_ary[8].plant = l_plant_8
#              LET g_ary[8].dbs_new = g_dbs_new CLIPPED
#           ELSE
#              IF NOT cl_null(l_plant_8) THEN
#                                       #檢查工廠並將新的資料庫放在g_dbs_new
#                 IF NOT s_chknplt(l_plant_8,'AAP','AAP') THEN
#                    CALL cl_err(g_plant_new,g_errno,0)
#                    NEXT FIELD plant_8
#                 END IF
#                 LET g_ary[8].plant = l_plant_8
#                 CALL s_getdbs()
#                 LET g_ary[8].dbs_new = g_dbs_new
#No.FUN-940102 --begin--
#              CALL s_chk_demo(g_user,l_plant_8) RETURNING li_result
#               IF not li_result THEN 
#                NEXT FIELD plant_8
#               END IF 
#No.FUN-940102 --end-- 
#              ELSE                     #輸入之工廠編號為' '或NULL
#                 LET g_ary[8].plant = l_plant_8
#              END IF
#           END IF
#       AFTER FIELD plant_9
#           LET l_plant_9 = duplicate(l_plant_9,5)   #不使"工廠編號"重覆
#           LET g_plant_new= l_plant_9
#           IF l_plant_9 = g_plant THEN
#              LET g_dbs_new=''
#              LET g_ary[9].plant = l_plant_9
#              LET g_ary[9].dbs_new = g_dbs_new CLIPPED
#           ELSE
#              IF NOT cl_null(l_plant_9) THEN
#                                       #檢查工廠並將新的資料庫放在g_dbs_new
#                 IF NOT s_chknplt(l_plant_9,'AAP','AAP') THEN
#                    CALL cl_err(g_plant_new,g_errno,0)
#                    NEXT FIELD plant_9
#                 END IF
#                 LET g_ary[9].plant = l_plant_9
#                 CALL s_getdbs()
#                 LET g_ary[9].dbs_new = g_dbs_new
#No.FUN-940102 --begin--
#              CALL s_chk_demo(g_user,l_plant_9) RETURNING li_result
#               IF not li_result THEN 
#                NEXT FIELD plant_9
#               END IF 
#No.FUN-940102 --end-- 
#              ELSE                     #輸入之工廠編號為' '或NULL
#                 LET g_ary[9].plant = l_plant_9
#              END IF
#           END IF
#           IF cl_null(l_plant_1) AND cl_null(l_plant_2) AND
#              cl_null(l_plant_3) AND cl_null(l_plant_4) THEN
#              CALL cl_err(0,'aap-136',0)
#              NEXT FIELD plant_1
#           END IF
#
#         #TQC-860019-add
#         ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
#         #TQC-860019-add
#
#         ON ACTION exit
#         LET INT_FLAG = 1
#         EXIT INPUT
#        END INPUT
#       IF INT_FLAG THEN
#          LET INT_FLAG = 0 CLOSE WINDOW r122_w
#          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
#          EXIT PROGRAM
#       END IF
#No.FUN-A10098 -END-------
 
   INPUT BY NAME tm.amd173_b,tm.amd174_b,tm.amd173_e,tm.amd174_e,tm.f,
                 tm.more
                 WITHOUT DEFAULTS
      AFTER FIELD amd173_b
         IF cl_null(tm.amd173_b) THEN NEXT FIELD amd173_b END IF
      AFTER FIELD amd174_b
         IF cl_null(tm.amd174_b) THEN NEXT FIELD amd174_b END IF
      AFTER FIELD amd173_e
         IF cl_null(tm.amd173_e) THEN NEXT FIELD amd173_e END IF
      AFTER FIELD amd174_e
# genero  script marked          IF cl_ku() THEN NEXT FIELD PREVIOUS END IF
         IF cl_null(tm.amd174_e) THEN NEXT FIELD amd174_e END IF
         IF tm.amd173_b+tm.amd174_b > tm.amd173_e+tm.amd174_e THEN
            NEXT FIELD amd174_e
         END IF
      AFTER FIELD f
         IF tm.f IS NOT NULL AND tm.f NOT MATCHES '[123]' THEN
            NEXT FIELD f
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
      LET INT_FLAG = 0 CLOSE WINDOW r111_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='amdr111'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amdr111','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         #-----TQC-610057---------
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.amd173_b CLIPPED,"'",
                         " '",tm.amd174_b CLIPPED,"'",
                         " '",tm.amd173_e CLIPPED,"'",
                         " '",tm.amd174_e CLIPPED,"'",
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
                         " '",tm.f CLIPPED,"'",
                         #-----END TQC-610057-----
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('amdr111',g_time,l_cmd)
      END IF
      CLOSE WINDOW r111_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r111()
   ERROR ""
END WHILE
   CLOSE WINDOW r111_w
END FUNCTION
 
FUNCTION r111()
   DEFINE l_name    LIKE type_file.chr20,      #No.FUN-680074 VARCHAR(20)  # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0068
          l_sql     STRING,     # RDSQL STATEMENT        #No.FUN-680074 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,    #No.FUN-680074 VARCHAR(40)
          l_idx     LIKE type_file.num5,       #No.FUN-680074 SMALLINT
       sr           RECORD
                    order1 LIKE type_file.chr20,      #No.FUN-680074 VARCHAR(20)
                    order2 LIKE type_file.chr20,      #No.FUN-680074 VARCHAR(20)
                    order3 LIKE type_file.chr20,      #No.FUN-680074 VARCHAR(20)
		    mark   LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(01)
                    amd01  LIKE amd_file.amd01,
                    amd28  LIKE amd_file.amd28,   #傳票號碼
                    amd03  LIKE amd_file.amd03,   #發票號碼
                    amd171 LIKE amd_file.amd171,  #格式
                    amd173 LIKE amd_file.amd173,  #申報年度
                    amd174 LIKE amd_file.amd174,  #申報月份
                    amd04  LIKE amd_file.amd04,   #賣方統一編號
                    amd08  LIKE amd_file.amd08,   #貨款(應付帳款)
                    amd172 LIKE amd_file.amd172,  #課稅別
                    amd07  LIKE amd_file.amd07,   #稅額
                    amd17  LIKE amd_file.amd17    #扣扺代號
                    END RECORD,
     l_ser          LIKE type_file.num5,          #No.FUN-680074 SMALLINT
     l_no           LIKE type_file.num5           #No.FUN-680074 SMALLINT
 
     CALL cl_del_data(l_table)                   #No.FUN-850053                 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog  #No.FUN-850053  
     SELECT zo02,zo06,zo11 INTO g_company,g_zo06,g_zo11
                            FROM zo_file WHERE zo01 = g_rlang
     #No.FUN-850053---Begin
     #CASE tm.f
     #  WHEN '1'
     #     LET g_title = '稅額500元以下(含)'
     #  WHEN '2'
     #     LET g_title = '稅額500元以上'
     #  WHEN '3'
     #     LET g_title = '全部'
     #END CASE
     #CALL cl_outnam('amdr111') RETURNING l_name
     #   START REPORT r111_rep TO l_name
     #LET g_pageno = 0
     #No.FUN-850053---End

     LET l_ser = -1
     LET l_no  = 0
    #No.FUN-A10098 -BEGIN-----
    #FOR g_idx =  1 TO 9
    #   IF cl_null(g_ary[g_idx].plant) THEN
    #      CONTINUE FOR
    #   END IF
    #No.FUN-A10098 -END-------
        #Begin:FUN-980030
        #        IF g_priv2='4' THEN                           #只能使用自己的資料
        #          LET tm.wc = tm.wc clipped," AND amduser = '",g_user,"'"
        #        END IF
        #        IF g_priv3='4' THEN                           #只能使用相同群的資料
        #          LET tm.wc = tm.wc clipped," AND amdgrup MATCHES '",g_grup CLIPPED,"*'"
        #        END IF
 
        #        IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
        #          LET tm.wc = tm.wc clipped," AND amdgrup IN ",cl_chk_tgrup_list()
        #        END IF
        LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('amduser', 'amdgrup')
        #End:FUN-980030
 
        LET l_sql=" SELECT '','','','',amd01,amd28,amd03,amd171,amd173,amd174,",
		  "        amd04,amd08,amd172,amd07,amd17",
                 #" FROM ",g_ary[g_idx].dbs_new CLIPPED,"amd_file",  #No.FUN-A10098
                  " FROM amd_file",                                  #No.FUN-A10098
                  " WHERE (amd173*12+amd174) BETWEEN ",
                          (tm.amd173_b*12+tm.amd174_b)," AND ",
                          (tm.amd173_e*12+tm.amd174_e),
                  "  AND (amd171 ='23' OR amd171 = '24')",
                 #"  AND amd25 = '",g_ary[g_idx].plant  CLIPPED,"'", #No.FUN-A10098
                  "  AND ",tm.wc clipped
        IF tm.f = '1' THEN
           LET l_sql = l_sql CLIPPED," AND amd07 <= 500 "
        END IF
        IF tm.f = '2' THEN
           LET l_sql = l_sql CLIPPED," AND amd07 > 500 "
        END IF
        LET l_sql = l_sql CLIPPED, " ORDER BY amd28 "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        PREPARE r111_prepare1 FROM l_sql
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('prepare:',SQLCA.sqlcode,1)
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
           EXIT PROGRAM
        END IF
        DECLARE r111_curs1 CURSOR FOR r111_prepare1
        FOREACH r111_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          IF l_ser = 99  THEN
             LET l_ser = -1
             LET l_no  = l_no + 1
          END IF
          LET l_ser = l_ser + 1
          #No.FUN-850053---Begin          
          #OUTPUT TO REPORT r111_rep(l_no,l_ser,sr.*)
          EXECUTE insert_prep USING l_no,l_ser,sr.amd28,sr.amd01,sr.amd03,
                                    sr.amd171,sr.amd173,sr.amd174,sr.amd04,
                                    sr.amd08,sr.amd172,sr.amd07,sr.amd17
          #No.FUN-850053---End
        END FOREACH
    #END FOR  #No.FUN-A10098
     #No.FUN-850053---Begin
     #FINISH REPORT r111_rep
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     IF g_zz05='Y' THEN                                                         
        LET g_str = " "                                                         
        CALL cl_wcchp(tm.wc,'amd01,amd03,amd28')                               
        RETURNING g_str                                                         
     END IF                                                                     
     LET g_str=g_str,";",g_azi04,";",g_azi05,";",tm.amd174_b,";",tm.amd174_e    
               ,";",tm.amd173_b,";",tm.amd173_e,";",tm.f           
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                       
     CALL cl_prt_cs3("amdr111","amdr111",l_sql,g_str)                           
     #No.FUN-850053---End
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
 
#No.FUN-850053---Begin
#REPORT r111_rep(l_no,l_ser,sr)
#DEFINE l_last_sw    LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
#      l_idx        LIKE type_file.num5,       #No.FUN-680074 SMALLINT
#      g_head1      STRING,                    #No.FUN-680074
#      str1         STRING,                    #No.FUN-680074
#      sr           RECORD
#                   order1 LIKE type_file.chr20,      #No.FUN-680074 VARCHAR(20)
#                   order2 LIKE type_file.chr20,      #No.FUN-680074 VARCHAR(20)
#                   order3 LIKE type_file.chr20,      #No.FUN-680074 VARCHAR(20)
#       	    mark   LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
#                   amd01  LIKE amd_file.amd01,
#                   amd28  LIKE amd_file.amd28,   #傳票號碼
#                   amd03  LIKE amd_file.amd03,   #發票號碼
#                   amd171 LIKE amd_file.amd171,  #格式
#                   amd173 LIKE amd_file.amd173,  #申報年度
#                   amd174 LIKE amd_file.amd174,  #申報月份
#                   amd04  LIKE amd_file.amd04,   #賣方統一編號
#                   amd08  LIKE amd_file.amd08,   #貨款(應付帳款)
#                   amd172 LIKE amd_file.amd172,  #課稅別
#                   amd07  LIKE type_file.num20_6,#No.FUN-680074  DEC(20,6)#稅額
#                   amd17  LIKE amd_file.amd17    #扣扺代號
#                   END RECORD,
#      l_amt_11     LIKE amd_file.amd08,
#      l_amt_12     LIKE amd_file.amd07,
#      l_amt_21     LIKE amd_file.amd08,
#      l_amt_22     LIKE amd_file.amd07,
#      l_amt_31     LIKE amd_file.amd08,
#      l_amt_32     LIKE amd_file.amd07,
#      l_byy        LIKE type_file.num5,       #No.FUN-680074 SMALLINT
#      l_eyy        LIKE type_file.num5,       #No.FUN-680074 SMALLINT
#      l_no         LIKE type_file.num5,       #No.FUN-680074 SMALLINT
#      l_ser        LIKE type_file.num5,       #No.FUN-680074 SMALLINT
#      l_azi04      LIKE azi_file.azi04,
#      l_azi05      LIKE azi_file.azi05
 
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY l_no,l_ser,sr.amd28,sr.amd03
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED, pageno_total
#     LET l_byy = tm.amd173_b - 1911
#     LET l_eyy = tm.amd173_e - 1911
#     LET g_head1 = g_x[9] CLIPPED, l_byy USING '##',
#                   g_x[12] CLIPPED, tm.amd174_b USING '##',
#                   g_x[13] CLIPPED,' ',g_x[14],' ', l_eyy  USING '##',
#                   g_x[12] CLIPPED, tm.amd174_e USING '##', g_x[13] CLIPPED
#                  # g_x[15] CLIPPED,g_title CLIPPED  #FUN-660060 remark
#     PRINT g_x[15] CLIPPED,g_title CLIPPED,COLUMN (g_len-25)/2+1,g_head1  #FUN-660060 add
#     PRINT g_dash[1,g_len]
#     PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#           g_x[39],g_x[40],g_x[41],g_x[42]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
#
#  BEFORE GROUP OF l_no
#    SKIP TO TOP OF PAGE
 
#  ON EVERY ROW
#    PRINT  COLUMN g_c[31], l_ser USING '  &&',
#           COLUMN g_c[32], sr.amd28,
#           COLUMN g_c[33], sr.amd01,
#           COLUMN g_c[34], sr.amd03[1,10],
#           COLUMN g_c[35], sr.amd171,
#           COLUMN g_c[36], sr.amd173-1911 USING '&&',
#           COLUMN g_c[37], sr.amd174      USING '&&',
#           COLUMN g_c[38], sr.amd04,
#           COLUMN g_c[39], cl_numfor(sr.amd08,39,g_azi04) CLIPPED,
#           COLUMN g_c[40], sr.amd172,
#           COLUMN g_c[41], cl_numfor(sr.amd07,41,g_azi04) CLIPPED,
#           COLUMN g_c[42], sr.amd17
 
#  AFTER GROUP OF l_no
#        LET l_amt_11 = GROUP SUM(sr.amd08)
#        LET l_amt_12 = GROUP SUM(sr.amd07)
#        PRINT COLUMN g_c[38],g_x[10] CLIPPED,
#              COLUMN g_c[39],cl_numfor(l_amt_11,39,g_azi05) CLIPPED,
#              COLUMN g_c[41],cl_numfor(l_amt_12,41,g_azi05);
#
#  ON LAST ROW
#     SKIP 3 LINE
#     LET l_amt_11 = SUM(sr.amd08)
#     LET l_amt_12 = SUM(sr.amd07)
#     PRINT COLUMN g_c[38],g_x[11] CLIPPED,
#           COLUMN g_c[39],cl_numfor(l_amt_11,39,g_azi05) CLIPPED,
#           COLUMN g_c[41],cl_numfor(l_amt_12,41,g_azi05)
#     PRINT g_dash_2[1,g_len]
#     PRINT g_dash[1,g_len] CLIPPED
#     LET l_last_sw = 'y'
#     PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash[1,g_len] CLIPPED
#             PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE SKIP 2 LINE
#     END IF
#END REPORT
#No.FUN-850053---End
