# Prog. Version..: '5.30.06-13.03.18(00010)'     #
#
# Pattern name...: amdr510.4gl
# Descriptions...: 銷項憑證明細檢核表
# Date & Author..: 99/03/02 By Linda
# Modify.........: No.B602 010528 by linda modify 同amdp010.4gl
# Modify.........: No.9017 04/01/12 By Kitty plant長度修改
# Modify.........: No.FUN-510019 05/01/11 By Smapmin 報表轉XML格式
# Modify.........: No.MOD-5B0244 05/11/21 By Smapmin 程式執行第二次就會當
# Modify.........: No.FUN-610020 06/01/09 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.TQC-610057 06/01/24 By Kevin 修改外部參數接收
# Modify.........: No.MOD-640358 06/04/10 BY yiting 資料有誤
# Modify.........: No.FUN-680074 06/08/25 By huchenghao 類型轉換
# Modify.........: No.FUN-690116 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.TQC-6A0093 06/11/10 By Carrier 報表格式調整
# Modify.........: No.FUN-750112 06/06/20 By Jackho CR報表修改
# Modify.........: No.TQC-770115 07/07/24 By Dido 增加發票聯數
# Modify.........: No.TQC-790091 07/09/14 By Mandy Primary Key的關係,原本SQLCA.sqlcode重複的錯誤碼-239，在informix不適用
# Modify.........: No.TQC-790177 07/09/29 By Carrier 去掉全型字符
# Modify.........: No.MOD-830077 08/03/10 By Smapmin 修正SQL語法
# Modify.........: No.TQC-860019 08/06/09 By cliare ON IDLE 控制調整
# Modify.........: No.MOD-870169 08/07/17 By Sarah 折讓類型無法列印,單身合計也無法呈現
# Modify.........: No.FUN-940102 09/04/20 By dxfwo  新增使用者對營運中心的權限管控
# Modify.........: No.TQC-950074 09/06/09 By baofei 解決溢位問題 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990107 09/09/10 By mike amdr510在算銷退折讓金額時，計算發票金額的方式是用axrt300(oma00=21)單頭的發票金額，
#                                                        可是sql在撈值時，是有by到銷退單的項次的，如果by單頭金額計算，會造成金額成倍
# Modify.........: No.FUN-9B0002 09/11/02 By wujie 5.2SQL转标准语法
# Modify.........: No.TQC-9C0179 09/12/29 By tsai_yen EXECUTE裡不可有擷取字串的中括號[]
# Modify.........: No.TQC-A10005 10/01/05 By Sarah TQC-950074追單不完全
# Modify.........: No.FUN-A10098 10/01/21 By jan 1.拿掉畫面上的plant欄位 2.主sql的財務段和非財務段進行拆分
# Modify.........: No:MOD-A30092 10/03/15 By Smapmin 發票作廢時,amd172由'D'-->'F'
# Modify.........: No:TQC-A40101 10/04/22 By Carrier unmark 背景时wc2的传参
# Modify.........: No:MOD-A70054 10/07/07 By Dido 若稅別申報格式為XX即不申報
# Modify.........: No:MOD-A80216 10/08/27 By Dido g_wc4 應增加重組 g_wc1 部分 
# Modify.........: No:CHI-B20012 11/02/24 By Summer 若勾選"只印出有問題的資料",但整份報表都沒有有問題的資料時,報表應該就不要印出來 
# Modify.........: No.MOD-B80230 11/08/23 By Polly 增加判斷，修正三聯式零稅金額會double計算到銷售合計金額
# Modify.........: No.TQC-B90146 12/03/12 By Polly 調整g_tot172應延續使用，不可歸 0
# Modify.........: No.MOD-D30044 13/03/06 By apo 在mark8的判斷時,格式為32買受人統一發票(amd04)可空白不檢查

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           wc          LIKE type_file.chr1000,    #No.FUN-680074 VARCHAR(200)
           oma00       LIKE oma_file.oma00,
           order1      LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
           b           LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1) #是否只列印有問題的資料
           more        LIKE type_file.chr1        #No.FUN-680074 VARCHAR(1)
           END RECORD
DEFINE g_wc,g_wc1,g_wc2,g_wc3,g_wc4   STRING      #No.FUN-580092 HCN        #No.FUN-680074
DEFINE g_wc5  STRING                              #MOD-870169 add
DEFINE g_ary  DYNAMIC ARRAY OF RECORD             #FUN-A10098
                 plant   LIKE azp_file.azp01,     #No.FUN-680074 VARCHAR(10) #No:9017
                 dbs_new LIKE type_file.chr21     #No.FUN-680074 VARCHAR(21)
              END RECORD,
#      g_dash_1       VARCHAR(140),               #MOD-5B0244
#      g_dash_2       VARCHAR(140),               #MOD-5B0244
       g_dash_1       LIKE type_file.chr1000,     #No.FUN-680074  VARCHAR(300)#MOD-5B0244
       g_dash_2       LIKE type_file.chr1000,     #No.FUN-680074  VARCHAR(300)#MOD-5B0244
#FUN-A10098--begin--mark--------------------
#      g_plant_1      LIKE azp_file.azp01,
#      g_plant_2      LIKE azp_file.azp01,
#      g_plant_3      LIKE azp_file.azp01,
#      g_plant_4      LIKE azp_file.azp01,
#      g_plant_5      LIKE azp_file.azp01,
#      g_plant_6      LIKE azp_file.azp01,
#      g_plant_7      LIKE azp_file.azp01,
#      g_plant_8      LIKE azp_file.azp01,
#FUN-A10098--end--mark----------------------
       g_tot7       LIKE type_file.num20_6,       #No.FUN-680074 DECIMAL(20,6)
       g_tot15      LIKE type_file.num20_6,       #No.FUN-680074 DECIMAL(20,6)
       g_tot19      LIKE type_file.num20_6,       #No.FUN-680074 DECIMAL(20,6)
       g_tot25      LIKE type_file.num20_6,       #No.FUN-680074 DECIMAL(20,6)
       g_tot23      LIKE type_file.num20_6,       #No.FUN-680074 DECIMAL(20,6)
       g_abx        LIKE type_file.num20_6,       #No.FUN-680074 DECIMAL(20,6)
       l_cnt        LIKE type_file.num5           #No.FUN-680074 SMALLINT
 
DEFINE   g_i        LIKE type_file.num5          #count/index for any purpose        #No.FUN-680074 SMALLINT
DEFINE   g_msg      LIKE type_file.chr1000       #No.FUN-680074 VARCHAR(72)
DEFINE   l_table    STRING                       ### FUN-750112 ###
DEFINE   g_str      STRING                       ### FUN-750112 ###
DEFINE   g_sql      STRING                       ### FUN-750112 ###
DEFINE   g_flag1    LIKE type_file.chr1          #MOD-B80230  add
DEFINE   g_flag2    LIKE type_file.chr1          #MOD-B80230  add
DEFINE   g_tot172   LIKE type_file.num20_6       #MOD-B80230  add

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMD")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690116
 
 
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = ARG_VAL(1)
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
#-----TQC-610057---------
   LET g_wc1    = ARG_VAL(7)
   LET tm.oma00 = ARG_VAL(8)
   LET tm.order1= ARG_VAL(9)
   LET tm.b     = ARG_VAL(10)
#FUN-A10098--begin--mark-----------
#  LET g_ary[1].plant = ARG_VAL(11)
#  LET g_ary[2].plant = ARG_VAL(12)
#  LET g_ary[3].plant = ARG_VAL(13)
#  LET g_ary[4].plant = ARG_VAL(14)
#  LET g_ary[5].plant = ARG_VAL(15)
#  LET g_ary[6].plant = ARG_VAL(16)
#  LET g_ary[7].plant = ARG_VAL(17)
#  LET g_ary[8].plant = ARG_VAL(18)
#FUN-A10098--end--mark-------------
   LET g_wc2          = ARG_VAL(11)
 
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#-----END TQC-610057-----
   
#--------------------No.FUN-750112--begin----CR(1)----------------#
    LET g_sql = "amd01.amd_file.amd01,", 
                "amd07.amd_file.amd07,", 
                "amd08.amd_file.amd08,", 
                "amd171.amd_file.amd171,", 
                "amd172.amd_file.amd172,", 
               #"amd25.amd_file.amd25,",               #FUN-A10098
               #"amd36.amd_file.amd36,",   #amd25[1,8] #FUN-A10098
                "ome01.ome_file.ome01,",
                "ome042.ome_file.ome042,",
                "omeuser.ome_file.omeuser,",
                "oma00.oma_file.oma00,",
                "gen02.gen_file.gen02,",
                "amd28.amd_file.amd28,",
                "amd03.amd_file.amd03,",
                "chr20.type_file.chr20,",
                "mark1.type_file.chr1,",  
                "mark2.type_file.chr1,",  
                "mark3.type_file.chr1,",  
                "mark4.type_file.chr1,",  
                "mark5.type_file.chr1,",  
                "mark6.type_file.chr1,",  
                "mark7.type_file.chr1,",  
                "mark8.type_file.chr1,",  
                "mark9.type_file.chr1,",  
                "chr1.type_file.chr1,",
                "azi04.azi_file.azi04"
 
    LET l_table = cl_prt_temptable('amdr510',g_sql) CLIPPED 
    IF l_table = -1 THEN EXIT PROGRAM END IF               
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?  )"   #FUN-A10098
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF
#--------------------No.FUN-750112--end------CR (1) ------------#
   SELECT * INTO g_ooz.* FROM ooz_file WHERE ooz00='0'
   IF cl_null(g_bgjob) OR g_bgjob='N'  THEN
       CALL amdr510_tm(0,0)    # Input print condition
   ELSE
    #  LET tm.wc="amd28= '",tm.wc CLIPPED,"'"
       CALL r510()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
 
FUNCTION amdr510_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680074 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680074 VARCHAR(1000)
   DEFINE li_result      LIKE type_file.num5          #No.FUN-940102
 
   IF p_row = 0 THEN LET p_row = 2 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 3 LET p_col = 17
   ELSE LET p_row = 2 LET p_col = 15
   END IF
 
   OPEN WINDOW amdr510_w AT p_row,p_col
        WITH FORM "amd/42f/amdr510"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   LET tm.more= 'N'
   LET g_pdate=g_today
   LET g_rlang=g_lang
   LET g_bgjob='N'
   LET g_copies='1'
   LET tm.order1 ='1'
   LET tm.b ='Y'
WHILE TRUE
    CONSTRUCT BY NAME g_wc1 ON ome05,ome01
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
 
        IF INT_FLAG THEN
          LET INT_FLAG = 0 CLOSE WINDOW amdr510_w 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
          EXIT PROGRAM
             
        END IF
    CONSTRUCT BY NAME g_wc2 ON ome02,ome16,omeuser
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
        IF INT_FLAG THEN
          LET INT_FLAG = 0 CLOSE WINDOW amdr510_w 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
          EXIT PROGRAM
             
        END IF
    IF tm.wc=" 1=1" THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
     END IF
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #       LET g_wc1 = g_wc1 clipped," AND omeuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET g_wc1 = g_wc1 clipped," AND omegrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET g_wc1 = g_wc1 clipped," AND omegrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc1 = g_wc1 CLIPPED,cl_get_extra_cond('omeuser', 'omegrup')
   #End:FUN-980030
 
#  LET g_plant_1 = g_plant                          #FUN-A10098 mark
   INPUT  #g_plant_1,g_plant_2,g_plant_3,g_plant_4, #FUN-A10098 mark
          #g_plant_5, g_plant_6,g_plant_7,g_plant_8,#FUN-A10098 mark
           tm.oma00,tm.order1,tm.b,tm.more
           WITHOUT DEFAULTS
     FROM #plant_1, plant_2, plant_3, plant_4 ,     #FUN-A10098 mark
          #plant_5, plant_6, plant_7, plant_8  ,    #FUN-A10098 mark
           oma00,order1,b,more
 
#FUN-A10098--begin--mark-------------------------------
#       BEFORE FIELD plant_1
#           IF g_multpl='N' THEN  #不為多工廠環境
#              LET g_plant_1= g_plant
#              LET g_plant_new= NULL
#              LET g_dbs_new=NULL
#              LET g_ary[1].plant = g_plant_1
#              LET g_ary[1].dbs_new = g_dbs_new CLIPPED
#              DISPLAY g_plant_1 TO FORMONLY.plant_1
#           #  EXIT INPUT       #將不會I/P plant_2 plant_3 plant_4
#              NEXT FIELD s
#           END IF
#
#       AFTER FIELD plant_1
#           LET g_plant_new= g_plant_1
#           IF g_plant_1 = g_plant THEN
#              LET g_dbs_new=''
#              LET g_ary[1].plant = g_plant_1
#              LET g_ary[1].dbs_new = g_dbs_new CLIPPED
#           ELSE
#              IF NOT cl_null(g_plant_1) THEN
#                 #檢查工廠並將新的資料庫放在g_dbs_new
#                 IF NOT s_chknplt(g_plant_1,'AAP','AAP') THEN
#                    CALL cl_err(g_plant_new,g_errno,0)
#                    NEXT FIELD plant_1
#                 END IF
#                 LET g_ary[1].plant = g_plant_1
#                 CALL s_getdbs()
#                 LET g_ary[1].dbs_new = g_dbs_new
##No.FUN-940102 --begin--
#              CALL s_chk_demo(g_user,g_plant_1) RETURNING li_result
#               IF not li_result THEN 
#                NEXT FIELD plant_1
#               END IF 
##No.FUN-940102 --end-- 
#              ELSE                     #輸入之工廠編號為' '或NULL
#                 LET g_ary[1].plant = g_plant_1
#              END IF
#           END IF
#
#       AFTER FIELD plant_2
#           LET g_plant_2 = duplicate(g_plant_2,1)   #不使"工廠編號"重覆
#           LET g_plant_new= g_plant_2
#           IF g_plant_2 = g_plant THEN
#              LET g_dbs_new=''
#              LET g_ary[2].plant = g_plant_2
#              LET g_ary[2].dbs_new = g_dbs_new CLIPPED
#           ELSE
#              IF NOT cl_null(g_plant_2) THEN
#                 #檢查工廠並將新的資料庫放在g_dbs_new
#                 IF NOT s_chknplt(g_plant_2,'AAP','AAP') THEN
#                    CALL cl_err(g_plant_new,g_errno,0)
#                    NEXT FIELD plant_2
#                 END IF
#                 LET g_ary[2].plant = g_plant_2
#                 CALL s_getdbs()
#                 LET g_ary[2].dbs_new = g_dbs_new
##No.FUN-940102 --begin--
#              CALL s_chk_demo(g_user,g_plant_2) RETURNING li_result
#               IF not li_result THEN 
#                NEXT FIELD plant_2
#               END IF 
##No.FUN-940102 --end-- 
#              ELSE                     #輸入之工廠編號為' '或NULL
#                 LET g_ary[2].plant = g_plant_2
#              END IF
#           END IF
#
#       AFTER FIELD plant_3
#           LET g_plant_3 = duplicate(g_plant_3,2)   #不使"工廠編號"重覆
#           LET g_plant_new= g_plant_3
#           IF g_plant_3 = g_plant THEN
#              LET g_dbs_new=''
#              LET g_ary[3].plant = g_plant_3
#              LET g_ary[3].dbs_new = g_dbs_new CLIPPED
#           ELSE
#              IF NOT cl_null(g_plant_3) THEN
#                 #檢查工廠並將新的資料庫放在g_dbs_new
#                 IF NOT s_chknplt(g_plant_3,'AAP','AAP') THEN
#                    CALL cl_err(g_plant_new,g_errno,0)
#                    NEXT FIELD plant_3
#                 END IF
#                 LET g_ary[3].plant = g_plant_3
#                 CALL s_getdbs()
#                 LET g_ary[3].dbs_new = g_dbs_new
##No.FUN-940102 --begin--
#              CALL s_chk_demo(g_user,g_plant_3) RETURNING li_result
#               IF not li_result THEN 
#                NEXT FIELD plant_3
#               END IF 
##No.FUN-940102 --end-- 
#              ELSE                     #輸入之工廠編號為' '或NULL
#                 LET g_ary[3].plant = g_plant_3
#              END IF
#           END IF
#
#       AFTER FIELD plant_4
#           LET g_plant_4 = duplicate(g_plant_4,3)   #不使"工廠編號"重覆
#           LET g_plant_new= g_plant_4
#           IF g_plant_4 = g_plant THEN
#              LET g_dbs_new=''
#              LET g_ary[4].plant = g_plant_4
#              LET g_ary[4].dbs_new = g_dbs_new CLIPPED
#           ELSE
#              IF NOT cl_null(g_plant_4) THEN
#                                       #檢查工廠並將新的資料庫放在g_dbs_new
#                 IF NOT s_chknplt(g_plant_4,'AAP','AAP') THEN
#                    CALL cl_err(g_plant_new,g_errno,0)
#                    NEXT FIELD plant_4
#                 END IF
#                 LET g_ary[4].plant = g_plant_4
#                 CALL s_getdbs()
#                 LET g_ary[4].dbs_new = g_dbs_new
##No.FUN-940102 --begin--
#              CALL s_chk_demo(g_user,g_plant_4) RETURNING li_result
#               IF not li_result THEN 
#                NEXT FIELD plant_4
#               END IF 
##No.FUN-940102 --end-- 
#              ELSE                     #輸入之工廠編號為' '或NULL
#                 LET g_ary[4].plant = g_plant_4
#              END IF
#           END IF
#
#       AFTER FIELD plant_5
#           LET g_plant_5 = duplicate(g_plant_5,3)   #不使"工廠編號"重覆
#           LET g_plant_new= g_plant_5
#           IF g_plant_5 = g_plant THEN
#              LET g_dbs_new=''
#              LET g_ary[5].plant = g_plant_5
#              LET g_ary[5].dbs_new = g_dbs_new CLIPPED
#           ELSE
#              IF NOT cl_null(g_plant_5) THEN
#                 IF NOT s_chknplt(g_plant_5,'AAP','AAP') THEN
#                    CALL cl_err(g_plant_new,g_errno,0)
#                    NEXT FIELD plant_5
#                 END IF
#                 LET g_ary[5].plant = g_plant_5
#                 CALL s_getdbs()
#                 LET g_ary[5].dbs_new = g_dbs_new
##No.FUN-940102 --begin--
#              CALL s_chk_demo(g_user,g_plant_5) RETURNING li_result
#               IF not li_result THEN 
#                NEXT FIELD plant_5
#               END IF 
##No.FUN-940102 --end-- 
#              ELSE LET g_ary[5].plant = g_plant_5
#              END IF
#           END IF
#
#       AFTER FIELD plant_6
#           LET g_plant_6 = duplicate(g_plant_6,3)   #不使"工廠編號"重覆
#           LET g_plant_new= g_plant_6
#           IF g_plant_6 = g_plant THEN
#              LET g_dbs_new=''
#              LET g_ary[6].plant = g_plant_6
#              LET g_ary[6].dbs_new = g_dbs_new CLIPPED
#           ELSE
#              IF NOT cl_null(g_plant_6) THEN
#                 IF NOT s_chknplt(g_plant_6,'AAP','AAP') THEN
#                    CALL cl_err(g_plant_new,g_errno,0)
#                    NEXT FIELD plant_6
#                 END IF
#                 LET g_ary[6].plant = g_plant_6
#                 CALL s_getdbs()
#                 LET g_ary[6].dbs_new = g_dbs_new
##No.FUN-940102 --begin--
#              CALL s_chk_demo(g_user,g_plant_6) RETURNING li_result
#               IF not li_result THEN 
#                NEXT FIELD plant_6
#               END IF 
##No.FUN-940102 --end-- 
#              ELSE LET g_ary[6].plant = g_plant_6
#              END IF
#           END IF
#
#       AFTER FIELD plant_7
#           LET g_plant_7 = duplicate(g_plant_7,3)   #不使"工廠編號"重覆
#           LET g_plant_new= g_plant_7
#           IF g_plant_7 = g_plant THEN
#              LET g_dbs_new=''
#              LET g_ary[7].plant = g_plant_7
#              LET g_ary[7].dbs_new = g_dbs_new CLIPPED
#           ELSE
#              IF NOT cl_null(g_plant_7) THEN
#                 IF NOT s_chknplt(g_plant_7,'AAP','AAP') THEN
#                    CALL cl_err(g_plant_new,g_errno,0)
#                    NEXT FIELD plant_7
#                 END IF
#                 LET g_ary[7].plant = g_plant_7
#                 CALL s_getdbs()
#                 LET g_ary[7].dbs_new = g_dbs_new
##No.FUN-940102 --begin--
#              CALL s_chk_demo(g_user,g_plant_7) RETURNING li_result
#               IF not li_result THEN 
#                NEXT FIELD plant_7
#               END IF 
##No.FUN-940102 --end-- 
#              ELSE LET g_ary[7].plant = g_plant_7
#              END IF
#           END IF
#
#       AFTER FIELD plant_8
#           LET g_plant_8 = duplicate(g_plant_8,3)   #不使"工廠編號"重覆
#           LET g_plant_new= g_plant_8
#           IF g_plant_8 = g_plant THEN
#              LET g_dbs_new=''
#              LET g_ary[8].plant = g_plant_8
#              LET g_ary[8].dbs_new = g_dbs_new CLIPPED
#           ELSE
#              IF NOT cl_null(g_plant_8) THEN
#                 IF NOT s_chknplt(g_plant_8,'AAP','AAP') THEN
#                    CALL cl_err(g_plant_new,g_errno,0)
#                    NEXT FIELD plant_8
#                 END IF
#                 LET g_ary[8].plant = g_plant_8
#                 CALL s_getdbs()
#                 LET g_ary[8].dbs_new = g_dbs_new
##No.FUN-940102 --begin--
#              CALL s_chk_demo(g_user,g_plant_8) RETURNING li_result
#               IF not li_result THEN 
#                NEXT FIELD plant_8
#               END IF 
##No.FUN-940102 --end-- 
#              ELSE LET g_ary[8].plant = g_plant_8
#              END IF
#           END IF
#           IF cl_null(g_plant_1) AND cl_null(g_plant_2) AND
#              cl_null(g_plant_3) AND cl_null(g_plant_4) AND
#              cl_null(g_plant_5) AND cl_null(g_plant_6) AND
#              cl_null(g_plant_7) AND cl_null(g_plant_8) THEN
#              CALL cl_err(0,'aap-136',0)
#              NEXT FIELD plant_1
#           END IF
#FUN-A10098--end--mark----------------------------------

      AFTER FIELD order1
        IF tm.order1 IS NULL OR tm.order1 NOT MATCHES '[12]' THEN
           NEXT FIELD order1
        END IF
      AFTER FIELD b
        IF tm.b IS NULL OR tm.b NOT MATCHES '[YN]' THEN
           NEXT FIELD b
        END IF
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
 
          #TQC-860019-add
          ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
          #TQC-860019-add
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW amdr510_w        #FUN-A10098
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='amdr510'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amdr510','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET g_wc1=cl_replace_str(g_wc1, "'", "\"") #No.TQC-610057
         LET g_wc2=cl_replace_str(g_wc2, "'", "\"") #No.TQC-610057
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         #-----TQC-610057---------
                         " '",g_wc1 CLIPPED,"'" ,
                         " '",tm.oma00 CLIPPED,"'" ,
                         " '",tm.order1 CLIPPED,"'" ,
                         " '",tm.b CLIPPED,"'" ,
                        #" '",g_ary[1].plant CLIPPED,"'",      #FUN-A10098
                        #" '",g_ary[2].plant CLIPPED,"'",      #FUN-A10098
                        #" '",g_ary[3].plant CLIPPED,"'",      #FUN-A10098
                        #" '",g_ary[4].plant CLIPPED,"'",      #FUN-A10098
                        #" '",g_ary[5].plant CLIPPED,"'",      #FUN-A10098
                        #" '",g_ary[6].plant CLIPPED,"'",      #FUN-A10098
                        #" '",g_ary[7].plant CLIPPED,"'",      #FUN-A10098
                        #" '",g_ary[8].plant CLIPPED,"'",      #FUN-A10098
                         " '",g_wc2 CLIPPED,"'" ,              #No.TQC-A40101
                         #-----END TQC-610057-----
                         " '",g_rep_user CLIPPED,"'",          #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",          #No.FUN-570264
                         " '",g_template CLIPPED,"'",          #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"           #No.FUN-7C0078
         CALL cl_cmdat('amdr510',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW amdr510_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r510()
   ERROR ""
END WHILE
   CLOSE WINDOW amdr510_w
END FUNCTION
 
#FUN-A10098--begin--mark--------
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
#FUN-A1009800end--mark-----------
 
FUNCTION r510()
   DEFINE l_name    LIKE type_file.chr20,      #No.FUN-680074 VARCHAR(20) # External(Disk) file name
#         l_time    LIKE type_file.chr8        #No.FUN-6A0068
          l_chr     LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,    #No.FUN-680074 VARCHAR(40)
          l_idx     LIKE type_file.num5,       #No.FUN-680074 SMALLINT
          l_order1  LIKE ome_file.ome01,       #No.FUN-680074 VARCHAR(10)
          l_order2  LIKE ome_file.omeuser,     #No.FUN-680074 VARCHAR(10)
          sr        RECORD  LIKE amd_file.*
#DEFINE  l_sql   STRING,        #No.FUN-680074
 DEFINE  l_sql   STRING,        #No.FUN-680074
#        l_sql1  STRING,        #No.FUN-680074
         l_sql1  STRING,        #No.FUN-680074
         l_wc,l_wc2,l_buf  LIKE type_file.chr1000,       #No.FUN-680074 VARCHAR(1000)
         l_k,l_l    LIKE type_file.num5,                 #No.FUN-680074 SMALLINT
         l_ama      RECORD LIKE ama_file.*,
         l_oea901       LIKE oea_file.oea901,
         l_amd22        LIKE amd_file.amd22,
         l_oma00        LIKE oma_file.oma00,
         l_oma01        LIKE oma_file.oma01,
         l_oma33        LIKE oma_file.oma33,
         l_omauser      LIKE oma_file.omauser,
         l_omagrup      LIKE oma_file.omagrup,
         l_oma02        LIKE oma_file.oma02,
         l_ome01        LIKE ome_file.ome01,
         l_ome02        LIKE ome_file.ome02,
         l_ome04        LIKE ome_file.ome04,
         l_ome16        LIKE ome_file.ome16,
         l_ome17        LIKE ome_file.ome17,
         l_ome171       LIKE ome_file.ome171,
         l_ome172       LIKE ome_file.ome172,
         l_ome39        LIKE ome_file.ome39,
         l_ome21        LIKE ome_file.ome21,
         l_ome042       LIKE ome_file.ome042,
         l_ome59        LIKE ome_file.ome59,
         l_ome59x       LIKE ome_file.ome59x,
         l_ome59t       LIKE ome_file.ome59t,
         l_omevoid      LIKE ome_file.omevoid,
         l_omeuser      LIKE ome_file.omeuser,
         l_omegrup      LIKE ome_file.omegrup,
         l_oom01        LIKE oom_file.oom01,
         l_oom02        LIKE oom_file.oom02,
         l_oom07        LIKE oom_file.oom07,
         l_oom08        LIKE oom_file.oom08,
         l_amb03        LIKE amb_file.amb03,     #No.FUN-680074 VARCHAR(02)
         l_oma16        LIKE oma_file.oma16,
         l_omb03        LIKE omb_file.omb03,
         l_omb16        LIKE omb_file.omb16,
         l_omb16t       LIKE omb_file.omb16t,
         l_oma35        LIKE oma_file.oma35,
         l_oma36        LIKE oma_file.oma36,
         l_oma37        LIKE oma_file.oma37,
         l_oma38        LIKE oma_file.oma38,
         l_oma39        LIKE oma_file.oma39,
         l_amd40        LIKE amd_file.amd40,
         l_amd41        LIKE amd_file.amd41,
         l_amd42        LIKE amd_file.amd42,
         l_amd43        LIKE amd_file.amd43,
         l_amd031       LIKE amd_file.amd031, #TQC-770115
         l_kind         LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
         l_tax          LIKE omb_file.omb16t,
         l_gec06        LIKE gec_file.gec06,
         l_gec08        LIKE gec_file.gec08,
         l_yy,l_mm      LIKE type_file.num5,       #No.FUN-680074 SMALLINT
         g_idx,l_len    LIKE type_file.num5,       #No.FUN-680074 SMALLINT
         l_add_cnt      LIKE type_file.num5,       #No.FUN-680074 SMALLINT
         l_tot          LIKE type_file.num10       #No.FUN-680074 INTEGER
#No.FUN-750112--begin
 DEFINE  sr1 RECORD
	         mark1  LIKE type_file.chr1,       
	         mark2  LIKE type_file.chr1,       
	         mark3  LIKE type_file.chr1,
	         mark4  LIKE type_file.chr1, 
	         mark5  LIKE type_file.chr1,  
	         mark6  LIKE type_file.chr1,   
	         mark7  LIKE type_file.chr1,    
                 mark8  LIKE type_file.chr1,     
                 mark9  LIKE type_file.chr1       
              END RECORD,
# DEFINE  str1                              LIKE type_file.chr1000
# DEFINE  str2                              LIKE type_file.chr1000
# DEFINE  str3                              LIKE type_file.chr1000
# DEFINE  str4                              LIKE type_file.chr1000
# DEFINE  str5                              LIKE type_file.chr1000
# DEFINE  str6                              LIKE type_file.chr1000
# DEFINE  str7                              LIKE type_file.chr1000
# DEFINE  str8                              LIKE type_file.chr1000,
         l_a311,l_b311,l_a312,l_a313       LIKE amd_file.amd08, 
         l_a321,l_b321,l_a322,l_a323       LIKE amd_file.amd08,
         l_a331,l_b331,l_a332,l_a333       LIKE amd_file.amd08,
         l_a341,l_b341,l_a342,l_a343       LIKE amd_file.amd08, 
         l_a351,l_b351,l_a352,l_a353       LIKE amd_file.amd08,  
         l_sum1,l_sum2                     LIKE amd_file.amd08,    
         l_aa,l_ba                         LIKE amd_file.amd08,   
         l_ab,l_bb                         LIKE amd_file.amd08,  
         l_mask                            LIKE zaa_file.zaa08,
         l_gen02                           LIKE gen_file.gen02,
         l_byy                             LIKE type_file.num5,
         l_eyy                             LIKE type_file.num5,
         l_prt                             LIKE type_file.chr1,
         l_sum3,l_sum4,l_sum5              LIKE amd_file.amd08,
         l_date                            LIKE type_file.chr20
#No.FUN-750112--end
###TQC-9C0179 START ###
   DEFINE l_amd25    LIKE amd_file.amd25
   DEFINE l_ome042_1 LIKE ome_file.ome042
###TQC-9C0179 END ###
   DEFINE l_plant    LIKE azp_file.azp01  #FUN-A10098  

 
#--------------------No.FUN-750112--begin----CR(2)----------------#
     CALL cl_del_data(l_table)
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 99 END IF
#     FOR g_i = 1 TO g_len
#         LET g_dash_2[g_i,g_i] = '='
#         LET g_dash_1[g_i,g_i] = '-'
#     END FOR
#
#     CALL cl_outnam('amdr510') RETURNING l_name
#     START REPORT r510_rep TO l_name
#     LET g_pageno = 0
#--------------------No.FUN-750112--end------CR(2)----------------#
     LET g_tot7 = 0
     LET g_tot15 = 0
     LET g_tot19 = 0
     LET g_abx =0   #保稅
     LET l_mask = "-,---,---,---,--&"      #No.FUN-750112
     IF g_wc1 != " 1=1 " OR g_wc2 !=" 1=1"  THEN
        LET l_buf=g_wc1 CLIPPED," AND ",g_wc2 CLIPPED
#TQC-950074---BEGIN                                                                                                                 
#       LET l_l=length(l_buf)                                                                                                       
#       FOR l_k=1 TO l_l                                                                                                            
#          IF l_buf[l_k,l_k+4]='ome05' THEN                                                                                    
#             LET l_buf[l_k,l_k+4]='oma05'                                                                                     
#          END IF                                                                                                              
#          IF l_buf[l_k,l_k+4]='ome01' THEN                                                                                    
#             LET l_buf[l_k,l_k+4]='oma10'                                                                                     
#          END IF                                                                                                              
#          IF l_buf[l_k,l_k+4]='ome02' THEN                                                                                    
#             LET l_buf[l_k,l_k+4]='oma09'                                                                                     
#          END IF                                                                                                              
#          IF l_buf[l_k,l_k+4]='ome16' THEN                                                                                    
#             LET l_buf[l_k,l_k+4]='oma01'                                                                                     
#          END IF                                                                                                              
#        END FOR                                                                                                                     
         LET l_buf = cl_replace_str(l_buf,"ome05","oma05")                                                                           
         LET l_buf = cl_replace_str(l_buf,"ome01","oma10")                                                                           
         LET l_buf = cl_replace_str(l_buf,"ome02","oma09")                                                                           
         LET l_buf = cl_replace_str(l_buf,"ome16","oma01")                                                                           
#TQC-950074---END 
         LET g_wc3 = l_buf
     END IF
    #IF g_wc2 != " 1=1 " THEN                             #MOD-A80216 mark
    #   LET l_buf=g_wc2                                   #MOD-A80216 mark
     IF g_wc1 != " 1=1 " OR g_wc2 !=" 1=1"  THEN          #MOD-A80216
        LET l_buf=g_wc1 CLIPPED," AND ",g_wc2 CLIPPED     #MOD-A80216
       #str TQC-A10005 mod
       #LET l_l=length(l_buf)
       #FOR l_k=1 TO l_l
       #   IF l_buf[l_k,l_k+4]='ome02' THEN
       #      LET l_buf[l_k,l_k+4]='oga02'
       #   END IF
       #   IF l_buf[l_k,l_k+4]='ome16' THEN
       #      LET l_buf[l_k,l_k+4]='oga01'
       #   END IF
       #END FOR
        LET l_buf = cl_replace_str(l_buf,"ome05","oga05")   #MOD-A80216
        LET l_buf = cl_replace_str(l_buf,"ome01","oga01")   #MOD-A80216 #發票編號比照 oga01 條件   
        LET l_buf = cl_replace_str(l_buf,"ome02","oga02")                                                                           
        LET l_buf = cl_replace_str(l_buf,"ome16","oga01")                                                                           
       #end TQC-A10005 mod
        LET g_wc4 = l_buf
     END IF
     IF cl_null(g_wc4) THEN LET g_wc4= " 1=1 " END IF
    #str MOD-870169 add
     LET l_buf=g_wc1 CLIPPED," AND ",g_wc2 CLIPPED
    #str TQC-A10005 mod
    #LET l_l=length(l_buf)
    #FOR l_k=1 TO l_l
    #   IF l_buf[l_k,l_k+4]='ome05' THEN
    #      LET l_buf[l_k,l_k+4]='oma05'
    #   END IF
    #   IF l_buf[l_k,l_k+4]='ome01' THEN
    #      LET l_buf[l_k,l_k+4]='ohb30'
    #   END IF
    #   IF l_buf[l_k,l_k+4]='ome02' THEN
    #      LET l_buf[l_k,l_k+4]='oma09'
    #   END IF
    #   IF l_buf[l_k,l_k+4]='ome16' THEN
    #      LET l_buf[l_k,l_k+4]='oma01'
    #   END IF
    #END FOR
    LET l_buf = cl_replace_str(l_buf,"ome05","oma05")                                                                           
    LET l_buf = cl_replace_str(l_buf,"ome01","ohb30")                                                                           
    LET l_buf = cl_replace_str(l_buf,"ome02","oma09")                                                                           
    LET l_buf = cl_replace_str(l_buf,"ome16","oma01")                                                                           
   #end TQC-A10005 mod
    LET g_wc5 = l_buf
    IF cl_null(g_wc5) THEN
       LET g_wc5=" 1=1 "
    END IF
 
    LET l_a311=0  LET l_b311=0  LET l_a312=0
    LET l_a321=0  LET l_b321=0
    LET l_a331=0  LET l_b331=0
    LET l_a341=0  LET l_b341=0
    LET l_a351=0  LET l_b351=0
   #end MOD-870169 add
#FUN-A10098--begin--mark-----------------------
#   FOR g_idx = 1 TO 8                     
#       IF cl_null(g_ary[g_idx].plant) THEN
#          CONTINUE FOR                  
#       END IF                          
#       #依帳款編號讀單身資料
#       LET l_sql1="SELECT * ",
#                 "  FROM ",g_ary[g_idx].dbs_new CLIPPED," omb_file",
#                 " WHERE  omb01 = ? "
#	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
#       PREPARE r510_pomb FROM l_sql1
#       DECLARE r510_omb CURSOR FOR r510_pomb
#
#       #依出貨單號讀單身資料
#       LET l_sql1="SELECT * ",
#                 "  FROM ",g_ary[g_idx].dbs_new CLIPPED," ogb_file",
#                 " WHERE  ogb01 = ? "
#	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
#       PREPARE r510_pogb FROM l_sql1
#       DECLARE r510_ogb CURSOR FOR r510_pogb
#FUN-A10098--end--mark-------------------------------
 
     #-->銷貨部份 & 零稅率
     IF g_ooz.ooz64='Y' THEN
        LET l_sql="SELECT ome01,ome16,ome042,ome04,ome59,ome59x,ome59t,",
                  " ome17,ome171,ome172,ome02,ome21,omevoid,oma33,oma02,",
                  " gec06,gec08,oma35,oma36,oma37,oma38,oma39, ",
                  " oma03,oma032,oma02,oma02,'1' ",
                  " ,ome042,omeuser,omegrup,oma00 ",
                  " FROM ome_file ",   #FUN-A10098
                  " LEFT OUTER JOIN oma_file ON ome16 = oma01",   #FUN-A10098
                  " LEFT OUTER JOIN gec_file ON ome21 = gec01",   #FUN-A10098
                  " WHERE ome00 IN ('1','3') ", 
                  "   AND (ome175 IS NULL ) ", 
                  "   AND gec011 = '2' ",  
                  "   AND ",g_wc1 CLIPPED,
                  "   AND ",g_wc2 CLIPPED
                  #FUN-A10098--begin--mark---------
                  #  " UNION ",
                  #  "SELECT oga01,oga01,oga033,oga03,oga50*oga24,",
                  #  "   oga50*oga211/100*oga24,oga50*oga24*(1+oga211/100),",
                  #  " '1',gec08,gec06,oga02,oga21,'N',oga907,oga02,",
                  #  " gec06,gec08,oga35,oga36,oga37,oga38,oga39,",
                  #  " oga03,oga032,oga02,oga021,'3' ",
                  #  " ,oga033,ogauser,ogagrup,'12' ",
                  #  " FROM ",g_ary[g_idx].dbs_new CLIPPED," oga_file ",
                  #  " LEFT OUTER JOIN ",g_ary[g_idx].dbs_new CLIPPED," gec_file ",
                  #  "   ON oga21= gec01 ",
                  #  " WHERE oga00= '3' ",
                  #  "   AND ogaconf = 'Y'",
                  #  "   AND oga08='2' ",
                  #  "   AND oga09='2' ",
                  #  "   AND gec011 = '2' ",     #
                  #  "   AND ",g_wc4 CLIPPED
                  #FUN-A10098--end--mark----------
     #No.+076 010423 by linda add 
     ELSE
         LET l_sql="SELECT ome01,ome16,ome042,ome04,ome59,ome59x,ome59t,",
                 " ome17,ome171,ome172,ome02,ome21,omevoid,oma33,oma02,",
                 " gec06,gec08,oma35,oma36,oma37,oma38,oma39, ",
                 " oma03,oma032,oma02,oma02,'1' ",
                 " ,ome042,omeuser,omegrup,oma00,gec05 ",
                 " FROM ome_file ",                             #FUN-A10098
                 " LEFT OUTER JOIN oma_file ON ome16 = oma01",  #FUN-A10098
                 " LEFT OUTER JOIN gec_file ON ome21 = gec01",  #FUN-A10098
                 " WHERE ome00 IN ('1','3') ",
                 "   AND (ome175 IS NULL ) ",
                 "   AND gec011 = '2' ", 
                 "   AND ",g_wc1 CLIPPED,
                 "   AND ",g_wc2 CLIPPED,
                 "  UNION ",
                 "SELECT oma01,oma01,oma042,oma04,oma59,oma59x,oma59t,",
                 " oma17,oma171,oma172,oma02,oma21,omavoid,oma33,oma02,",
                 " gec06,gec08,oma35,oma36,oma37,oma38,oma39, ",
                 " oma03,oma032,oma02,oma02,'2' ",
                #" ,oma042,omauser,omagrup,oma00 ",       #TQC-770115
                 " ,oma042,omauser,omagrup,oma00,gec05 ", #TQC-770115
                 " FROM oma_file",                               #FUN-A10098
                 " LEFT OUTER JOIN gec_file ON oma21 = gec01 ",  #FUN-A10098
                 " WHERE oma00 LIKE '1%'",
                 "   AND oma175 IS NULL ",  
                 "   AND gec011 = '2' ",
                 "   AND oma10 IS NULL AND oma08='2' ",
                 "   AND omaconf='Y' ",
                 "   AND omavoid='N' ",
                 "   AND ",g_wc3 CLIPPED
             #FUN-A10098--begin--mark----------------------  
             #  " UNION ",
             # "SELECT oga01,oga01,oga033,oga03,oga50*oga24,",
             #   "   oga50*oga211/100*oga24,oga50*oga24*(1+oga211/100),",
             #   " '1',gec08,gec06,oga02,oga21,'N',oga907,oga02,",
             #   " gec06,gec08,oga35,oga36,oga37,oga38,oga39,",
             #   " oga03,oga032,oga02,oga021,'3' ",
             #   " ,oga033,ogauser,ogagrup,'12',gec05 ", 
             #   " FROM ",g_ary[g_idx].dbs_new CLIPPED," oga_file",
             #   " LEFT OUTER JOIN ",g_ary[g_idx].dbs_new CLIPPED," gec_file ON oga21 = gec01",
             #  " WHERE oga00= '3' ",  
             #  "   AND ogaconf = 'Y'",
             #  "   AND oga08='2' ",  
             #  "   AND oga09 IN ('2','8') ",
             #  "   AND gec011 = '2' ",
             #  "   AND ",g_wc4 CLIPPED
             #FUN-A10098--end--mark---------------------------
     END IF
     PREPARE r510_preome FROM l_sql
     DECLARE r510_curome CURSOR  FOR r510_preome
        LET l_sql = "SELECT UNIQUE ooa33 ",
                    "  FROM ooa_file,oob_file ",    #FUN-A10098
                    " WHERE oob06 = ?",    #帳款編號
                    "   AND oob03 = '1'  ",               #借
                    "   AND oob04 = '3'  ",               #貸 抵
                    "   AND oob01 = ooa01",
                    "   AND ooaconf = 'Y'"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        PREPARE r510_preooa1  FROM l_sql
        DECLARE r510_curooa1  CURSOR  FOR r510_preooa1
        LET g_tot172 = 0                            #TQC-B90146 add
        FOREACH r510_curome INTO l_ome01,l_ome16,l_ome042,l_ome04,l_ome59,
                                 l_ome59x,l_ome59t,l_ome17,l_ome171,l_ome172,
                                 l_ome02,l_ome21,l_omevoid,l_oma33,l_oma02,
                                 l_gec06,l_gec08,l_oma35,l_oma36,
                                 l_oma37,l_oma38,l_oma39,
                                 l_amd40,l_amd41,l_amd42,l_amd43,l_kind,
                                #l_ome042,l_omeuser,l_omegrup,l_oma00          #TQC-770115
                                 l_ome042,l_omeuser,l_omegrup,l_oma00,l_amd031 #TQC-770115
           message l_ome01
           CALL ui.Interface.refresh()
           IF SQLCA.sqlcode THEN
              CALL cl_err('r510_curome',SQLCA.sqlcode,0) EXIT FOREACH
           END IF
           LET l_prt='N'                  #No.FUN-750112
           IF NOT cl_null(tm.oma00) THEN
              IF l_oma00 <> tm.oma00 THEN
                 CONTINUE FOREACH
              END IF
           END IF
          #-MOD-A70054-add-
           IF cl_null(l_gec08) OR l_gec08 = 'XX' THEN
              CONTINUE FOREACH
           END IF
          #-MOD-A70054-end-
      #FUN-A10098--begin--mod-------------------
      #此處程序邏輯被移到FUNCTION r510_r1()中
           CALL r510_r1(l_ome01,l_ome16,l_ome042,l_ome04,l_ome59,l_ome59x,l_ome59t,
                        l_ome17,l_ome171,l_ome172,l_ome02,l_ome21,l_omevoid,l_oma33,l_oma02,
                        l_gec06,l_gec08,l_oma35,l_oma36,l_oma37,l_oma38,l_oma39,l_amd40,l_amd41,
                        l_amd42,l_amd43,l_kind,l_omeuser,l_omegrup,l_oma00,l_amd031,l_prt,
                        l_a311,l_b311,l_a312,l_a321,l_b321,l_a331,l_b331,l_a341,l_b341,l_a351,l_b351,
                        l_sum1,l_sum2,l_sum3,l_sum4,l_sum5)
           RETURNING l_a311,l_b311,l_a312,l_a321,l_b321,l_a351,l_b351,
                     l_sum1,l_sum2,l_sum3,l_sum4,l_sum5
       END FOREACH 
       #FUN-A10098--end--mod------------------------
       #FUN-A10098--begin--add----------
       LET l_plant = ''
       LET l_sql1 = " SELECT azw01 FROM azw_file ",
                    "  WHERE azw02 = '",g_legal,"'"
       PREPARE r510_azw_p  FROM l_sql1
       DECLARE r510_azw_c  CURSOR  FOR r510_azw_p
       FOREACH r510_azw_c INTO l_plant
          IF g_ooz.ooz64='Y' THEN
             LET l_sql = "SELECT oga01,oga01,oga033,oga03,oga50*oga24,",
                         "   oga50*oga211/100*oga24,oga50*oga24*(1+oga211/100),",
                         " '1',gec08,gec06,oga02,oga21,'N',oga907,oga02,",
                         " gec06,gec08,oga35,oga36,oga37,oga38,oga39,",
                         " oga03,oga032,oga02,oga021,'3' ",
                         " ,oga033,ogauser,ogagrup,'12' ",
                         " FROM ",cl_get_target_table(l_plant,'oga_file'),
                         " LEFT OUTER JOIN ",cl_get_target_table(l_plant,'gec_file'),
                         "   ON oga21= gec01 ",
                         " WHERE oga00= '3' ",
                         "   AND ogaconf = 'Y'",
                         "   AND oga08='2' ",
                         "   AND oga09='2' ",
                         "   AND gec011 = '2' ",
                         "   AND ",g_wc4 CLIPPED
          ELSE
             LET l_sql = "SELECT oga01,oga01,oga033,oga03,oga50*oga24,",
                         "   oga50*oga211/100*oga24,oga50*oga24*(1+oga211/100),",
                         " '1',gec08,gec06,oga02,oga21,'N',oga907,oga02,",
                         " gec06,gec08,oga35,oga36,oga37,oga38,oga39,",
                         " oga03,oga032,oga02,oga021,'3' ",
                         " ,oga033,ogauser,ogagrup,'12',gec05 ", 
                         " FROM ",cl_get_target_table(l_plant,'oga_file'),
                         " LEFT OUTER JOIN ",cl_get_target_table(l_plant,'gec_file')," ON oga21 = gec01",
                         " WHERE oga00= '3' ",  
                         "   AND ogaconf = 'Y'",
                         "   AND oga08='2' ",  
                         "   AND oga09 IN ('2','8') ",
                         "   AND gec011 = '2' ",
                         "   AND ",g_wc4 CLIPPED
          END IF
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql
          CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
          PREPARE r510_preome3 FROM l_sql
          DECLARE r510_curome3 CURSOR  FOR r510_preome3
 
          FOREACH r510_curome3 INTO l_ome01,l_ome16,l_ome042,l_ome04,l_ome59,
                                    l_ome59x,l_ome59t,l_ome17,l_ome171,l_ome172,
                                    l_ome02,l_ome21,l_omevoid,l_oma33,l_oma02,
                                    l_gec06,l_gec08,l_oma35,l_oma36,
                                    l_oma37,l_oma38,l_oma39,
                                    l_amd40,l_amd41,l_amd42,l_amd43,l_kind,
                                    l_ome042,l_omeuser,l_omegrup,l_oma00,l_amd031 #TQC-770115
             message l_ome01
             CALL ui.Interface.refresh()
             IF SQLCA.sqlcode THEN
                CALL cl_err('r510_curome3',SQLCA.sqlcode,0) EXIT FOREACH
             END IF
             LET l_prt='N'  
             IF NOT cl_null(tm.oma00) THEN
                IF l_oma00 <> tm.oma00 THEN
                   CONTINUE FOREACH
                END IF
             END IF
             CALL r510_r1(l_ome01,l_ome16,l_ome042,l_ome04,l_ome59,l_ome59x,l_ome59t,
                          l_ome17,l_ome171,l_ome172,l_ome02,l_ome21,l_omevoid,l_oma33,l_oma02,
                          l_gec06,l_gec08,l_oma35,l_oma36,l_oma37,l_oma38,l_oma39,l_amd40,l_amd41,
                          l_amd42,l_amd43,l_kind,l_omeuser,l_omegrup,l_oma00,l_amd031,l_prt,
                          l_a311,l_b311,l_a312,l_a321,l_b321,l_a331,l_b331,l_a341,l_b341,l_a351,l_b351,
                          l_sum1,l_sum2,l_sum3,l_sum4,l_sum5)
             RETURNING l_a311,l_b311,l_a312,l_a321,l_b321,l_a351,l_b351,
                       l_sum1,l_sum2,l_sum3,l_sum4,l_sum5
          END FOREACH 
       END FOREACH
       #FUN-A10098--end--add------------------------------------------
       #IF g_success='N' THEN   #FUN-A10098
       #   EXIT FOR             #FUN-A10098
       #END IF                  #FUN-A10098 
       #-->銷退折讓
       #FUN-A10098--begin--add----------
       LET l_plant = ''
       LET l_sql1 = " SELECT azw01 FROM azw_file ",
                    "  WHERE azw02 = '",g_legal,"'"
       PREPARE r510_azw_p1  FROM l_sql1
       DECLARE r510_azw_c1  CURSOR  FOR r510_azw_p1
       FOREACH r510_azw_c1 INTO l_plant
       #FUN-A10098--end--add------------
         LET l_sql = "SELECT oma00,oma16,oma10,oma01,oma03,occ11,",
                    #" oma59,oma59x,oma59t,oma17,oma171,oma172,",      #TQC-770115
                    #" oma59,oma59x,oma59t,oma17,oma171,oma172,gec05,", #TQC-770115   #MOD-830077 #MOD-990107                        
                     " omb18,(omb18t-omb18),omb18t,oma17,oma171,oma172,gec05,", #MOD-990107       #FUN-A10098 add oma17                  
                     " oma02,oma21,oma33,gec06,gec08, ",
                     " oma35,oma36,oma37,oma38,oma39, ",
                     " oma03,oma032,oma02,oma02 ",
                     " ,oma042,omauser,omagrup,oma00 ",
#No.FUN-9B0002 --begin
                    "  FROM oma_file ",  #FUN-A10098
                    "  LEFT OUTER JOIN gec_file ON oma21 = gec01",   #FUN-A10098
                    "  LEFT OUTER JOIN occ_file ON oma03 = occ01 ,", #FUN-A10098
                    "  omb_file,",   #MOD-870169 add                 #FUN-A10098 
                       cl_get_target_table(l_plant,'ohb_file'),      #FUN-A10098
#                   "  FROM ",g_ary[g_idx].dbs_new CLIPPED," oma_file,",
#                             g_ary[g_idx].dbs_new CLIPPED," omb_file,",   #MOD-870169 add
#                             g_ary[g_idx].dbs_new CLIPPED," ohb_file,",   #MOD-870169 add
#                   "       ",g_ary[g_idx].dbs_new CLIPPED," gec_file,",
#                   " OUTER ",g_ary[g_idx].dbs_new CLIPPED," occ_file",
#No.FUN-9B0002 --end
                    " WHERE (oma00 = '21' OR oma00 = '25')",  #銷退折讓
                    "   AND (oma175 IS NULL OR oma175 = ' ') ",    #流水號
                    "   AND oma01 = omb01 ",   #MOD-870169 add
                    "   AND omb31 = ohb01 ",   #MOD-870169 add
                    "   AND omb32 = ohb03 ",   #MOD-870169 add
#                   "   AND oma21 = gec01  ",  #No.FUN-9B0002
                    "   AND gec011 = '2' ",   #銷項
                    "   AND omavoid = 'N' ",
                    "   AND omaconf = 'Y' ",
#                   "   AND oms_file.oma03 = occ_file.occ01 ",  #No.FUN-9B0002
                   #"   AND ",g_wc3  CLIPPED   #MOD-870169 mark
                    "   AND ",g_wc5  CLIPPED   #MOD-870169
 	  CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #FUN-920032
          CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A10098
          PREPARE r510_preoma2 FROM l_sql
          DECLARE r510_curoma2 CURSOR  FOR r510_preoma2
 
          LET l_sql = "SELECT UNIQUE ooa33 ",
                      "  FROM ooa_file,oob_file ",   #FUN-A10098
                      " WHERE oob06 = ?",    #帳款編號
                      "   AND oob03 = '1'  ",               #借
                      "   AND oob04 = '3'  ",               #貸 抵
                      "   AND oob01 = ooa01",
                      "   AND ooaconf = 'Y'"
 	  CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
          PREPARE r510_preooa  FROM l_sql
          DECLARE r510_curooa  CURSOR  FOR r510_preooa
         #FUN-A10098--begin--mark--此cursor程式中并未使用----
         #LET l_sql = "SELECT UNIQUE oma33 ",
         #            "  FROM ",g_ary[g_idx].dbs_new CLIPPED,"oma_file,",
         #            " ",g_ary[g_idx].dbs_new CLIPPED,"oha_file",
         #            " WHERE oha01 = ? ",    #帳款編號
         #            "   AND ohaconf = 'Y'",
         #            "   AND oha16 = oma01",
         #            "   AND omaconf = 'Y'"
 	 #CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         #PREPARE r510_preooa2  FROM l_sql
         #DECLARE r510_curooa2  CURSOR  FOR r510_preooa2
         #FUN-A10098--end--mark-------------------------------
 
         #LET l_sql = "SELECT ome01,ome02,ome17,ome171,ome172 ",        #TQC-770115
          LET l_sql = "SELECT ome01,ome02,ome17,ome171,ome172,ome212 ", #TQC-770115
                      "  FROM oma_file,ome_file ",  #FUN-A10098
                      " WHERE oma01 = ?",    #帳款編號
                      "   AND oma10 = ome01"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
          PREPARE r510_preome1 FROM l_sql
          DECLARE r510_curome1 CURSOR  FOR r510_preome1
 
         #LET l_sql = "SELECT ome01,ome02,ome17,ome171,ome172",        #TQC-770115
          LET l_sql = "SELECT ome01,ome02,ome17,ome171,ome172,ome212", #TQC-770115
                      "  FROM ",cl_get_target_table(l_plant,'oha_file'),",", #FUN-A10098
                                cl_get_target_table(l_plant,'ohb_file'),",", #FUN-A10098
                                cl_get_target_table(l_plant,'oga_file'),",", #FUN-A10098
                      "         ome_file",  #FUN-A10098
                      " WHERE oha01 = ?",    #帳款編號
                      "   AND ohaconf = 'Y'",
                      "   AND oha01 = ohb01",
                      "   AND ohb31 = oga01",
                      "   AND oga10 = ome16"
       	  CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #FUN-920032
          CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A10098
          PREPARE r510_preome2 FROM l_sql
          DECLARE r510_curome2 CURSOR  FOR r510_preome2
          FOREACH r510_curoma2 INTO l_oma00,l_oma16,l_ome01,l_ome16,l_ome04,
                                    l_ome042,l_ome59,l_ome59x,l_ome59t,
                                   #l_ome17,l_ome171,l_ome172,          #TQC-770115
                                    l_ome17,l_ome171,l_ome172,l_amd031, #TQC-770115
                                    l_oma02,l_ome21,l_oma33,l_gec06,l_gec08,
                                    l_oma35,l_oma36,l_oma37,l_oma38,l_oma39,
                                    l_amd40,l_amd41,l_amd42,l_amd43,
                                    l_ome042,l_omeuser,l_omegrup,l_oma00
                IF SQLCA.sqlcode THEN
                   CALL cl_err('r510_curnoma2',SQLCA.sqlcode,0)
                   EXIT FOREACH
                END IF
                LET l_prt='N'                  #No.FUN-750112
                IF NOT cl_null(tm.oma00) THEN
                   IF l_oma00 <> tm.oma00 THEN
                      CONTINUE FOREACH
                   END IF
                END IF
                message l_ome01
                CALL ui.Interface.refresh()
                IF cl_null(l_ome01) THEN    #發票號碼
                   IF l_oma00 = '25' THEN     #銷退
                      OPEN r510_curome1 USING l_ome16
                      FETCH r510_curome1 INTO l_ome01,l_ome02,
                                             #l_ome17,l_ome171,l_ome172          #TQC-770115
                                              l_ome17,l_ome171,l_ome172,l_amd031 #TQC-770115
                      IF STATUS THEN
                         CALL cl_err('sel ome',STATUS,0) LET l_ome01=''
                      END IF
                   END IF
                   IF l_oma00 = '21' THEN    #銷折
                      OPEN r510_curome2 USING l_oma16
                      FETCH r510_curome2 INTO l_ome01,l_ome02,
                                             #l_ome17,l_ome171,l_ome172          #TQC-770115
                                              l_ome17,l_ome171,l_ome172,l_amd031 #TQC-770115
                      IF STATUS THEN
                         CALL cl_err('sel ome',STATUS,0) LET l_ome01=''
                      END IF
                   END IF
                END IF
                IF cl_null(l_gec08) OR l_gec08 = 'XX' THEN
                   CONTINUE FOREACH
                END IF
                IF cl_null(l_ome172) THEN LET l_ome172 = l_gec06 END IF
                IF cl_null(l_ome171) THEN LET l_ome171 = l_gec08 END IF
                IF l_ome171 = '31' THEN LET l_ome171 = '33' END IF
                IF l_ome171 = '32' THEN LET l_ome171 = '34' END IF
                IF l_ome171 = '36' THEN LET l_ome171 = '34' END IF
                LET l_yy    = YEAR(l_oma02)      #canny(9/1)
                LET l_mm    = MONTH(l_oma02)     #canny(9/1)
                #---98/08/07 modify若統一編號第一碼或第二碼為英文字母則清為空白
                IF l_ome042[1,1] MATCHES '[A-Z,a-z]' OR
                   l_ome042[2,2] MATCHES '[A-Z,a-z]' THEN
                   LET l_ome042 = ' '
                END IF
                #--->銷退之傳票號碼
                IF cl_null(l_oma33) THEN
                   IF l_oma00 = '25' THEN
                      OPEN r510_curooa USING l_ome16    #canny(9/1)
                      FETCH r510_curooa INTO l_oma33
                   END IF
                   IF l_oma00 = '21' THEN
                      OPEN r510_curooa USING l_ome16    #canny(9/1)
                      FETCH r510_curooa INTO l_oma33
                   END IF
                END IF
                IF cl_null(l_oma33) THEN LET l_oma33 = ' ' END IF
                IF tm.order1 ='1' THEN
                   LET l_order1 =l_omeuser
                   LET l_order2 =l_ome01
                ELSE
                   LET l_order1=l_ome01
                   LET l_order2=l_ome01
                END IF
                #計算零稅率之銷折
                IF (l_ome171='33' OR l_ome171='34')  AND l_ome172='2'  THEN
                   LET g_tot19 = g_tot19 + l_ome59
                END IF
#--------------------No.FUN-750112---begin---CR(3)----------------#
                LET sr.amd01=l_ome16 
                LET sr.amd02=1  
                LET sr.amd021='3' 
                LET sr.amd03=l_ome01  
                LET sr.amd031=l_amd031 #TQC-770115
                LET sr.amd04=l_ome042  
                LET sr.amd05=l_ome02  
                LET sr.amd06=l_ome59t  
                LET sr.amd07=l_ome59x  
                LET sr.amd08=l_ome59  
                LET sr.amd09=''  
                LET sr.amd10=''  
                LET sr.amd17=' '  
                LET sr.amd171=l_ome171  
                LET sr.amd172=l_ome172 
                LET sr.amd173=l_yy 
                LET sr.amd174=l_mm 
                LET sr.amd175=''
                LET sr.amd22=''  
               #LET sr.amd25=g_ary[g_idx].plant  #FUN-A10098
                LET sr.amd26=''  
                LET sr.amd27=''  
                LET sr.amd28=l_oma33  
                LET sr.amd29='1'  
                LET sr.amd30='N'  
                LET sr.amd35=l_oma35
                LET sr.amd36=l_oma36  
                LET sr.amd37=l_oma37  
                LET sr.amd38=l_oma38  
                LET sr.amd39=l_oma39  
                LET sr.amd40=l_amd40 
                LET sr.amd41=l_amd41  
                LET sr.amd42=l_amd42  
                LET sr.amd43=l_amd43  
                LET sr.amdacti='Y'
                LET sr.amduser=l_omeuser
                LET sr.amdgrup=l_omegrup
                LET sr.amdmodu=''
                LET sr.amddate=g_today
                #增加檢核功能
                CALL err_chk(sr.*) RETURNING sr1.*
                IF tm.b='N' OR (tm.b='Y' AND
                       (sr1.mark1='*' OR sr1.mark2='*' OR sr1.mark3='*'    OR
                       sr1.mark4='*' OR sr1.mark5='*' OR sr1.mark6='*'    OR
                       sr1.mark7='*' OR sr1.mark8='*' OR sr1.mark9='*') ) THEN
                #讀取輸入人員姓名
                  LET l_prt='Y'             #控制CR是否打印詳細資料
                  LET l_gen02=''
                  SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.amduser
                  IF SQLCA.SQLCODE OR cl_null(l_gen02) THEN
                     LET l_gen02=sr.amduser
                  END IF
#                  LET str1= sr1.mark2,sr.amd171
#                  LET str2= sr.amd01,sr1.mark1
#                  LET str3= sr.amd28,sr1.mark5
#                  LET str4= sr.amd03, sr1.mark8
#                  LET str5= l_ome042[1,10],sr1.mark3
#                  LET str6= sr.amd173 USING "&&&&",sr.amd174 USING '&&',sr1.mark6
#                  LET str7= sr.amd172,sr1.mark9
#                  LET str8= cl_numfor(sr.amd08,20,g_azi04),sr1.mark4 CLIPPED 
                END IF 
       #-----------------for last row------------------#
                IF sr.amd171='31' AND sr.amd172='1' THEN
                   LET l_a311=l_a311+sr.amd08
                   LET l_b311=l_b311+sr.amd07
                END IF   
                IF sr.amd171='31' AND sr.amd172='2' THEN
                   LET l_a312=(l_a312+sr.amd08) USING l_mask
                END IF   
                IF sr.amd171='32' AND sr.amd172='1' THEN
                   LET l_a321=l_a321+sr.amd08
                   LET l_b321=l_b321+sr.amd07
                END IF   
                IF sr.amd171='33' AND sr.amd172='1' THEN
                   LET l_a331=l_a331+sr.amd08
                   LET l_b331=l_b331+sr.amd07
                END IF   
                IF sr.amd171='34' AND sr.amd172='1' THEN
                   LET l_a341=l_a341+sr.amd08
                   LET l_b341=l_b341+sr.amd07
                END IF   
                IF sr.amd171='35' AND sr.amd172='1' THEN
                   LET l_a351=l_a351+sr.amd08
                   LET l_b351=l_b351+sr.amd07
                END IF   
                IF cl_null(l_a311) THEN LET l_a311=0 END IF
                IF cl_null(l_b311) THEN LET l_b311=0 END IF
                IF cl_null(l_a312) THEN LET l_a312=0 END IF
                IF cl_null(l_a321) THEN LET l_a321=0 END IF
                IF cl_null(l_b321) THEN LET l_b321=0 END IF
                IF cl_null(l_a331) THEN LET l_a331=0 END IF
                IF cl_null(l_b331) THEN LET l_b331=0 END IF
                IF cl_null(l_a341) THEN LET l_a341=0 END IF
                IF cl_null(l_b341) THEN LET l_b341=0 END IF
                IF cl_null(l_a351) THEN LET l_a351=0 END IF
                IF cl_null(l_b351) THEN LET l_b351=0 END IF
                LET l_sum1=l_a311+l_a321-l_a331-l_a341+l_a351+l_a312
                LET l_sum2=l_b311+l_b321-l_b331-l_b341+l_b351
                LET g_tot23=g_tot7+g_tot15-g_tot19
                LET l_sum3=l_a331+l_a341
                LET l_sum4=l_b331+l_b341
                LET l_sum5=g_tot23+l_sum1
                LET l_date=sr.amd173 USING "&&&&",sr.amd174 USING '&&'
       #-----------------for last row------------------#
                ###TQC-9C0179 START ###
               #LET l_amd25 = sr.amd25[1,8]  #FUN-A10098
                LET l_ome042_1 = l_ome042[1,10]
                ###TQC-9C0179 END ###
                IF tm.b ='Y' AND l_prt = 'N' THEN CONTINUE FOREACH END IF #CHI-B20012 add 
                EXECUTE insert_prep USING 
                    sr.amd01,sr.amd07,sr.amd08,sr.amd171,
                    #sr.amd172,sr.amd25,sr.amd25[1,8],         #TQC-9C0179 mark
                    sr.amd172,  #sr.amd25,l_amd25,             #TQC-9C0179  #FUN-A10098
                    #l_ome01,l_ome042[1,10],l_omeuser,l_oma00, #TQC-9C0179 mark
                    l_ome01,l_ome042_1,l_omeuser,l_oma00,      #TQC-9C0179
                    l_gen02,sr.amd28,sr.amd03,l_date,
                    sr1.mark1,sr1.mark2,sr1.mark3,sr1.mark4,sr1.mark5,
                    sr1.mark6,sr1.mark7,sr1.mark8,sr1.mark9,l_prt,g_azi04
#                OUTPUT TO REPORT r510_rep(l_ome16,1,'3',l_ome01,l_ome042,
#                                l_ome02,l_ome59t,l_ome59x,l_ome59,'','',
#                                ' ',l_ome171,l_ome172,l_yy,l_mm,
#                                '','',g_ary[g_idx].plant,
#                                '','',l_oma33,'1','N',
#                                l_oma35,l_oma36,l_oma37,l_oma38,l_oma39,
#                                 l_amd40,l_amd41,l_amd42,l_amd43,
#                                'Y',l_omeuser,l_omegrup,'',g_today,l_ome042,
#                                l_order1,l_order2,l_oma00)
#--------------------No.FUN-750112---end-----CR(3)----------------#
                #IF SQLCA.sqlcode<>0 AND SQLCA.SQLCODE <>-239  THEN                    #TQC-790091 mark
                 IF SQLCA.sqlcode<>0 AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN  #TQC-790091 mod
                    CALL cl_err(l_ome16,SQLCA.sqlcode,0)
                    LET g_success = 'N'
                    EXIT FOREACH
                 END IF
          END FOREACH
       END FOREACH      #FUN-A10098
#   END FOR             #FUN-A10098
 
#--------------------No.FUN-750112---begin---CR(4)----------------#
#     FINISH REPORT r510_rep
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'oem05,oem01')
            RETURNING tm.wc
       LET g_str = tm.wc
    END IF
    LET g_str=l_a311,";",l_b311,";",l_a312,";",l_a321,";",l_b321,";",
              l_a351,";",l_b351,";",g_tot7,";",g_tot15,";",g_tot19,";",
              g_tot23,";",l_sum1,";",l_sum2,";",l_sum3,";",l_sum4,";",
              l_sum5,";",tm.order1,";",g_str
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    CALL cl_prt_cs3('amdr510','amdr510',l_sql,g_str)
#--------------------No.FUN-750112---end-----CR(4)----------------#
END FUNCTION

#FUN-A10098--begin--add------------------------- 
FUNCTION r510_r1(l_ome01,l_ome16,l_ome042,l_ome04,l_ome59,l_ome59x,l_ome59t,
                 l_ome17,l_ome171,l_ome172,l_ome02,l_ome21,l_omevoid,l_oma33,l_oma02,
                 l_gec06,l_gec08,l_oma35,l_oma36,l_oma37,l_oma38,l_oma39,l_amd40,l_amd41,
                 l_amd42,l_amd43,l_kind,l_omeuser,l_omegrup,l_oma00,l_amd031,l_prt,
                 l_a311,l_b311,l_a312,l_a321,l_b321,l_a331,l_b331,l_a341,l_b341,l_a351,l_b351,
                 l_sum1,l_sum2,l_sum3,l_sum4,l_sum5)
DEFINE   l_oma00        LIKE oma_file.oma00,
         l_oma33        LIKE oma_file.oma33,
         l_oma02        LIKE oma_file.oma02,
         l_ome01        LIKE ome_file.ome01,
         l_ome02        LIKE ome_file.ome02,
         l_ome04        LIKE ome_file.ome04,
         l_ome16        LIKE ome_file.ome16,
         l_ome17        LIKE ome_file.ome17,
         l_ome171       LIKE ome_file.ome171,
         l_ome172       LIKE ome_file.ome172,
         l_ome21        LIKE ome_file.ome21,
         l_ome042       LIKE ome_file.ome042,
         l_ome59        LIKE ome_file.ome59,
         l_ome59x       LIKE ome_file.ome59x,
         l_ome59t       LIKE ome_file.ome59t,
         l_omevoid      LIKE ome_file.omevoid,
         l_omeuser      LIKE ome_file.omeuser,
         l_omegrup      LIKE ome_file.omegrup,
         l_oma35        LIKE oma_file.oma35,
         l_oma36        LIKE oma_file.oma36,
         l_oma37        LIKE oma_file.oma37,
         l_oma38        LIKE oma_file.oma38,
         l_oma39        LIKE oma_file.oma39,
         l_amd40        LIKE amd_file.amd40,
         l_amd41        LIKE amd_file.amd41,
         l_amd42        LIKE amd_file.amd42,
         l_amd43        LIKE amd_file.amd43,
         l_amd031       LIKE amd_file.amd031,
         l_kind         LIKE type_file.chr1,
         l_gec06        LIKE gec_file.gec06,
         l_gec08        LIKE gec_file.gec08,
         l_yy,l_mm      LIKE type_file.num5,
         l_cnt,l_i      LIKE type_file.num10,
         l_order1       LIKE ome_file.ome01, 
         l_order2       LIKE ome_file.omeuser,
         l_prt          LIKE type_file.chr1,
         l_a311,l_b311,l_a312      LIKE amd_file.amd08, 
         l_a321,l_b321             LIKE amd_file.amd08,
         l_a331,l_b331             LIKE amd_file.amd08,
         l_a341,l_b341             LIKE amd_file.amd08, 
         l_a351,l_b351             LIKE amd_file.amd08,  
         l_sum1,l_sum2             LIKE amd_file.amd08,    
         l_gen02                   LIKE gen_file.gen02,
         l_sum3,l_sum4,l_sum5      LIKE amd_file.amd08,
         l_date                    LIKE type_file.chr20
DEFINE  sr1 RECORD
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
DEFINE l_ome042_1 LIKE ome_file.ome042
DEFINE sr         RECORD  LIKE amd_file.*

           IF cl_null(l_ome172) THEN LET l_ome172 = l_gec06 END IF
           IF cl_null(l_ome171) THEN LET l_ome171 = l_gec08 END IF
           IF cl_null(l_oma02) THEN LET l_oma02 = l_ome02 END IF
           LET l_yy    = YEAR(l_oma02)
           LET l_mm    = MONTH(l_oma02)
           #---98/08/07 modify若統一編號第一碼或第二碼為英文字母則清為空白
           IF l_ome042[1,1] MATCHES '[A-Z,a-z]' OR
              l_ome042[2,2] MATCHES '[A-Z,a-z]' THEN
              LET l_ome042 = ' '
           END IF
           #--->作廢發票
           IF l_omevoid = 'Y' THEN
              LET l_ome042 = ''  LET l_ome17 = ' '
              LET l_ome59t = 0   LET l_ome59x= 0   LET l_ome59 =  0
              LET l_ome171 = ''  LET l_ome172= 'F'    #MOD-A30092   'D'-->'F'
           END IF
           #----->若傳票號碼為空白
           IF cl_null(l_oma33) THEN
              OPEN r510_curooa1 USING l_ome16
              FETCH r510_curooa1 INTO l_oma33
           END IF
           IF cl_null(l_oma33) THEN LET l_oma33 = ' ' END IF
           IF cl_null(l_ome16) THEN LET l_ome16 = ' ' END IF
           IF tm.order1 ='1' THEN
              LET l_order1 =l_omeuser
              LET l_order2 =l_ome01
           ELSE
              LET l_order1=l_ome01
              LET l_order2=l_ome01
           END IF
            ## 零稅率銷售額
            LET g_flag1 = 'N'                                  #No.MOD-B80230 add
            IF l_ome171 MATCHES '3*' AND l_ome172='2'
                 AND l_ome171<>'33'AND  l_ome171<>'34' THEN
               LET g_flag1 = 'Y'                               #No.MOD-B80230 add
               #經海關證明文件is not null 則為經海關
               IF NOT cl_null(l_oma38) OR NOT cl_null(l_oma39) THEN
                  #g_tot15:經海關出口免附證明文件者
                  LET g_tot15 = g_tot15 + l_ome59
               ELSE
                  #g_tot7:不經海關出口應附證明文件者
                  LET g_tot7 = g_tot7 + l_ome59
               END IF
             END IF
             #計算免稅金額
             IF l_ome171 MATCHES '3*' AND l_ome172='3'  THEN
                LET g_abx = g_abx + l_ome59
             END IF
             #g_tot19:零稅率之退回及折讓
             IF (l_ome171='33' OR l_ome171='34')  AND l_ome172='2'  THEN
                LET g_tot19 = g_tot19 + l_ome59
             END IF
#--------------------No.FUN-750112---begin---CR(3)----------------#
            LET sr.amd01=l_ome16  
            LET sr.amd02=1  
            LET sr.amd021='3' 
            LET sr.amd03=l_ome01  
            LET sr.amd031=l_amd031  #TQC-770115
            LET sr.amd04=l_ome042
            LET sr.amd05=l_ome02  
            LET sr.amd06=l_ome59t  
            LET sr.amd07=l_ome59x  
            LET sr.amd08=l_ome59  
            LET sr.amd09=''  
            LET sr.amd10=''  
            LET sr.amd17=l_ome17 
            LET sr.amd171=l_ome171  
            LET sr.amd172=l_ome172 
            LET sr.amd173=l_yy 
            LET sr.amd174=l_mm 
            LET sr.amd175='' 
            LET sr.amd22='' 
           #LET sr.amd25=g_ary[g_idx].plant  #FUN-A10098
            LET sr.amd26=''
            LET sr.amd27=''  
            LET sr.amd28=l_oma33  
            LET sr.amd29='1'  
            LET sr.amd30='N' 
            LET sr.amd35=l_oma35  
            LET sr.amd36=l_oma36  
            LET sr.amd37=l_oma37  
            LET sr.amd38=l_oma38  
            LET sr.amd39=l_oma39  
            LET sr.amd40=l_amd40  
            LET sr.amd41=l_amd41  
            LET sr.amd42=l_amd42  
            LET sr.amd43=l_amd43  
            LET sr.amdacti='Y'
            LET sr.amduser=l_omeuser
            LET sr.amdgrup=l_omegrup
            LET sr.amdmodu=''
            LET sr.amddate=g_today
            #增加檢核功能
            CALL err_chk(sr.*) RETURNING sr1.*
            IF tm.b='N' OR (tm.b='Y' AND
                       (sr1.mark1='*' OR sr1.mark2='*' OR sr1.mark3='*'    OR
                       sr1.mark4='*' OR sr1.mark5='*' OR sr1.mark6='*'    OR
                       sr1.mark7='*' OR sr1.mark8='*' OR sr1.mark9='*') ) THEN
            #讀取輸入人員姓名
               LET l_prt='Y'             #控制CR是否打印詳細資料
               LET l_gen02=''
               SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.amduser
              IF SQLCA.SQLCODE OR cl_null(l_gen02) THEN
                 LET l_gen02=sr.amduser
              END IF
#              LET str1= sr1.mark2,sr.amd171
#              LET str2= sr.amd01,sr1.mark1
#              LET str3= sr.amd28,sr1.mark5
#              LET str4= sr.amd03, sr1.mark8
#              LET str5= l_ome042[1,10],sr1.mark3
#              LET str6= sr.amd173 USING "&&&&",sr.amd174 USING '&&',sr1.mark6
#              LET str7= sr.amd172,sr1.mark9
#              LET str8= cl_numfor(sr.amd08,20,g_azi04),sr1.mark4 CLIPPED 
            END IF 
       #-----------------for last row------------------#
            IF sr.amd171='31' AND sr.amd172='1' THEN
               LET l_a311=l_a311+sr.amd08
               LET l_b311=l_b311+sr.amd07
            END IF   
            LET g_flag2 = 'N'                         #No.MOD-B80230 add
            IF sr.amd171='31' AND sr.amd172='2' THEN
               LET l_a312=l_a312+sr.amd08
               LET g_flag2 = 'Y'                      #No.MOD-B80230 add
            END IF   
            IF sr.amd171='32' AND sr.amd172='1' THEN
               LET l_a321=l_a321+sr.amd08
               LET l_b321=l_b321+sr.amd07
            END IF   
            IF sr.amd171='33' AND sr.amd172='1' THEN
               LET l_a331=l_a331+sr.amd08
               LET l_b331=l_b331+sr.amd07
            END IF   
            IF sr.amd171='34' AND sr.amd172='1' THEN
               LET l_a341=l_a341+sr.amd08
               LET l_b341=l_b341+sr.amd07
            END IF   
            IF sr.amd171='35' AND sr.amd172='1' THEN
               LET l_a351=l_a351+sr.amd08
               LET l_b351=l_b351+sr.amd07
            END IF   
            IF cl_null(l_a311) THEN LET l_a311=0 END IF
            IF cl_null(l_b311) THEN LET l_b311=0 END IF
            IF cl_null(l_a312) THEN LET l_a312=0 END IF
            IF cl_null(l_a321) THEN LET l_a321=0 END IF
            IF cl_null(l_b321) THEN LET l_b321=0 END IF
            IF cl_null(l_a331) THEN LET l_a331=0 END IF
            IF cl_null(l_b331) THEN LET l_b331=0 END IF
            IF cl_null(l_a341) THEN LET l_a341=0 END IF
            IF cl_null(l_b341) THEN LET l_b341=0 END IF
            IF cl_null(l_a351) THEN LET l_a351=0 END IF
            IF cl_null(l_b351) THEN LET l_b351=0 END IF
            #--------------------------No.MOD-B80230-----------------add
            IF g_flag1 = 'Y' and g_flag2 = 'Y' THEN
              #LET g_tot172 = l_a312                    #TQC-B90146 mark
               LET g_tot172 = g_tot172 + l_a312         #TQC-B90146 add
           #ELSE                                        #TQC-B90146 mark
           #   LET g_tot172 = 0                         #TQC-B90146 mark
            END IF
            #--------------------------No.MOD-B80230-----------------end
            LET l_sum1=l_a311+l_a321-l_a331-l_a341+l_a351+l_a312
            LET l_sum2=l_b311+l_b321-l_b331-l_b341+l_b351
            LET g_tot23=g_tot7+g_tot15-g_tot19
            LET l_sum3=l_a331+l_a341
            LET l_sum4=l_b331+l_b341
           #LET l_sum5=g_tot23+l_sum1                   #No.MOD-B80230 mark
            LET l_sum5=g_tot23+l_sum1-g_tot172          #No.MOD-B80230 add
            LET l_date=sr.amd173 USING "&&&&",sr.amd174 USING '&&'
       #-----------------for last row------------------#
            ###TQC-9C0179 START ###
           #LET l_amd25 = sr.amd25[1,8]    #FUN-A10098
            LET l_ome042_1 = l_ome042[1,10]
            ###TQC-9C0179 END ###
            IF tm.b = 'N' OR (tm.b ='Y' AND l_prt = 'Y') THEN #CHI-B20012 add 
               EXECUTE insert_prep USING 
                   sr.amd01,sr.amd07,sr.amd08,sr.amd171,sr.amd172,
                  #sr.amd25,sr.amd25[1,8],l_ome01,l_ome042[1,10], #TQC-9C0179 mark
                  #sr.amd25,l_amd25,l_ome01,l_ome042_1,           #TQC-9C0179  #FUN-A10098
                   l_ome01,l_ome042_1,                            #TQC-9C0179  #FUN-A10098
                   l_omeuser,l_oma00,l_gen02,sr.amd28,sr.amd03,
                   l_date,sr1.mark1,sr1.mark2,sr1.mark3,sr1.mark4,
                   sr1.mark5,sr1.mark6,sr1.mark7,sr1.mark8,sr1.mark9,
                   l_prt,g_azi04
            END IF #CHI-B20012 add
           RETURN l_a311,l_b311,l_a312,l_a321,l_b321,l_a351,l_b351,
                  l_sum1,l_sum2,l_sum3,l_sum4,l_sum5
END FUNCTION
#FUN-A10098--end--add-----------------------------------------------

#------------No.FUN-750112--begin--------#
#REPORT r510_rep(sr,l_ome042,l_order1,l_order2,l_oma00)
#DEFINE l_last_sw    LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
#       l_idx        LIKE type_file.num5,       #No.FUN-680074 SMALLINT
#       l_order1     LIKE ome_file.ome01,       #No.FUN-680074 VARCHAR(10)
#       l_order2     LIKE ome_file.omeuser,     #No.FUN-680074 VARCHAR(10)
#       l_oma00      LIKE oma_file.oma00,
#       l_ome042     LIKE ome_file.ome042,
#       str          STRING,                    #No.FUN-680074
#          sr        RECORD LIKE amd_file.*
#  DEFINE sr1 RECORD
#	            mark1  LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1) #無傳票號碼
#	            mark2  LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1) #格式為空白
#	            mark3  LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1) #資料年度/月份為空白
#	            mark4  LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1) #稅額事後 * 0.05 > 1
#	            mark5  LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1) #發票號碼為空白
#	            mark6  LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1) #稅額錯誤
#	            mark7  LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1) #統一編號錯誤
#                    mark8  LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1) #統一編號錯誤
#                    mark9  LIKE type_file.chr1        #No.FUN-680074 VARCHAR(1) #未金額為零錯誤
#              END RECORD,
#       l_a311,l_b311,l_a312,l_a313       LIKE amd_file.amd08,     #No.FUN-680074 DECIMAL(20,6)
#       l_a321,l_b321,l_a322,l_a323       LIKE amd_file.amd08,     #No.FUN-680074 DECIMAL(20,6)
#       l_a331,l_b331,l_a332,l_a333       LIKE amd_file.amd08,     #No.FUN-680074 DECIMAL(20,6)
#       l_a341,l_b341,l_a342,l_a343       LIKE amd_file.amd08,     #No.FUN-680074 DECIMAL(20,6)
#       l_a351,l_b351,l_a352,l_a353       LIKE amd_file.amd08,     #No.FUN-680074 DECIMAL(20,6)
#       l_sum1,l_sum2              LIKE amd_file.amd08,     #No.FUN-680074 DECIMAL(20,6)
#       l_aa,l_ba                  LIKE amd_file.amd08,     #No.FUN-680074 DECIMAL(20,6)
#       l_ab,l_bb                  LIKE amd_file.amd08,     #No.FUN-680074 DECIMAL(20,6)
#       l_mask       LIKE zaa_file.zaa08,     #No.FUN-680074 VARCHAR(15)
#       l_gen02      LIKE gen_file.gen02,
#       l_byy        LIKE type_file.num5,       #No.FUN-680074 SMALLINT
#       l_eyy        LIKE type_file.num5        #No.FUN-680074 SMALLINT
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
# # ORDER BY sr.amd25,sr.amduser,sr.amd171,sr.amd172,sr.amd03
#   ORDER BY sr.amd25,l_order1,l_order2,sr.amd171,sr.amd172
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED  #No.TQC-6A0093
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED, pageno_total
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#            g_x[39],g_x[40],g_x[41],g_x[42]
#      PRINT g_dash1 CLIPPED  #No.TQC-6A0093
#      LET l_last_sw = 'n'
# 
#   ON EVERY ROW
#      #增加檢核功能
#      CALL err_chk(sr.*) RETURNING sr1.*
#     #No.B399 010528 by plum
#      IF tm.b='N' OR (tm.b='Y' AND
#                      (sr1.mark1='*' OR sr1.mark2='*' OR sr1.mark3='*'    OR
#                       sr1.mark4='*' OR sr1.mark5='*' OR sr1.mark6='*'    OR
#                       sr1.mark7='*' OR sr1.mark8='*' OR sr1.mark9='*') ) THEN
#     #No.B399 ..end
#        #讀取輸入人員姓名
#         LET l_gen02=''
#         SELECT gen02 INTO l_gen02 FROM gen_file WHERE	 gen01=sr.amduser
#         IF SQLCA.SQLCODE OR cl_null(l_gen02) THEN
#            LET l_gen02=sr.amduser
#         END IF
#         PRINT COLUMN g_c[31],sr.amd25[1,8];
#         LET str = sr1.mark2,sr.amd171
#         PRINT COLUMN g_c[32],str;
#         LET str = sr.amd01,sr1.mark1
#         PRINT COLUMN g_c[33],str;
#         LET str = sr.amd28,sr1.mark5
#         PRINT COLUMN g_c[34],str;
#         LET str = sr.amd03, sr1.mark8
#         PRINT COLUMN g_c[35],str;
#         LET str = l_ome042[1,10],sr1.mark3
#         PRINT COLUMN g_c[36],str;
#         LET str = sr.amd173 USING "&&&&",sr.amd174 USING '&&',sr1.mark6
#         PRINT COLUMN g_c[37],str;
#         LET str = sr.amd172,sr1.mark9
#         PRINT COLUMN g_c[38],str;
#         LET str = cl_numfor(sr.amd08,39,g_azi04),sr1.mark4 CLIPPED  #No.TQC-6A0093
#         PRINT COLUMN g_c[39],str CLIPPED;  #No.TQC-6A0093
#         PRINT COLUMN g_c[40],cl_numfor(sr.amd07,40,g_azi04),
#               COLUMN g_c[41],l_gen02,
#               COLUMN g_c[42],l_oma00
#       END IF #No.B399..add
#
#   AFTER GROUP OF l_order1
#    IF tm.order1 ='1' THEN
#      PRINT COLUMN g_c[35],l_gen02,
#            COLUMN g_c[36],g_x[8],
#            COLUMN g_c[39],cl_numfor(group sum(sr.amd08),39,g_azi04),
#            COLUMN g_c[40],cl_numfor(group sum(sr.amd07),40,g_azi04)
#    END IF
#
#   ON LAST ROW
#      #-->銷項項目
#      LET l_a311=SUM(sr.amd08)  WHERE sr.amd171='31' AND sr.amd172='1'
#      LET l_b311=SUM(sr.amd07)  WHERE sr.amd171='31' AND sr.amd172='1'
#
#      LET l_a312=SUM(sr.amd08)  WHERE sr.amd171='31' AND sr.amd172='2'
#
#      LET l_a321=SUM(sr.amd08)  WHERE sr.amd171='32' AND sr.amd172='1'
#      LET l_b321=SUM(sr.amd07)  WHERE sr.amd171='32' AND sr.amd172='1'
#
#      LET l_a331=SUM(sr.amd08)  WHERE sr.amd171='33' AND sr.amd172='1'
#      LET l_b331=SUM(sr.amd07)  WHERE sr.amd171='33' AND sr.amd172='1'
#
#      LET l_a341=SUM(sr.amd08)  WHERE sr.amd171='34' AND sr.amd172='1'
#      LET l_b341=SUM(sr.amd07)  WHERE sr.amd171='34' AND sr.amd172='1'
#
#      LET l_a351=SUM(sr.amd08)  WHERE sr.amd171='35' AND sr.amd172='1'
#      LET l_b351=SUM(sr.amd07)  WHERE sr.amd171='35' AND sr.amd172='1'
#      IF cl_null(l_a311) THEN LET l_a311=0 END IF
#      IF cl_null(l_b311) THEN LET l_b311=0 END IF
#      IF cl_null(l_a312) THEN LET l_a312=0 END IF
#      IF cl_null(l_a321) THEN LET l_a321=0 END IF
#      IF cl_null(l_b321) THEN LET l_b321=0 END IF
#      IF cl_null(l_a331) THEN LET l_a331=0 END IF
#      IF cl_null(l_b331) THEN LET l_b331=0 END IF
#      IF cl_null(l_a341) THEN LET l_a341=0 END IF
#      IF cl_null(l_b341) THEN LET l_b341=0 END IF
#      IF cl_null(l_a351) THEN LET l_a351=0 END IF
#      IF cl_null(l_b351) THEN LET l_b351=0 END IF
#      LET l_sum1=l_a311+l_a321-l_a331-l_a341+l_a351+l_a312
#      LET l_sum2=l_b311+l_b321-l_b331-l_b341+l_b351
#      LET g_tot23 = g_tot7 + g_tot15 - g_tot19
#      LET l_mask = "-,---,---,---,--&"  #No.TQC-6A0093
# 
#      SKIP 2 LINES
#      #No.TQC-6A0093 g_x后加CLIPPED --Begin
# {35} PRINT COLUMN g_c[31],g_x[9] CLIPPED, 
#            COLUMN g_c[35],l_a311 USING l_mask,  
#            COLUMN g_c[39],g_x[20] CLIPPED,l_b311 USING l_mask 
#
# {31} PRINT COLUMN g_c[31],g_x[10] CLIPPED, 
#            COLUMN g_c[35],l_a312 USING l_mask
#
# {35} PRINT COLUMN g_c[31],g_x[11] CLIPPED,
#            COLUMN g_c[35],l_a351 USING l_mask,
#            COLUMN g_c[39],g_x[20] CLIPPED,l_b351 USING l_mask
#
# {35} PRINT COLUMN g_c[31],g_x[12] CLIPPED,
#            COLUMN g_c[35],l_a321 USING l_mask,
#            COLUMN g_c[39],g_x[20] CLIPPED,l_b321 USING l_mask
# {35} PRINT COLUMN g_c[31],g_x[13] CLIPPED,
#            COLUMN g_c[35],l_a331+l_a341 USING l_mask, #減銷退折讓
#            COLUMN g_c[39],g_x[20] CLIPPED,l_b331+l_b341 USING l_mask
# {35} PRINT COLUMN g_c[31],g_x[14] CLIPPED,
#            COLUMN g_c[35],l_sum1   USING l_mask,
#            COLUMN g_c[39],g_x[20] CLIPPED,l_sum2   USING l_mask
#      SKIP 1 LINE
#
# {35} PRINT COLUMN g_c[31],g_x[15] CLIPPED,
#            COLUMN g_c[35],g_tot7 USING l_mask   #非經海關
# {35} PRINT COLUMN g_c[31],g_x[16] CLIPPED,
#            COLUMN g_c[35],g_tot15  USING l_mask  #經海關
# {35} PRINT COLUMN g_c[31],g_x[17] CLIPPED,
#            COLUMN g_c[35],g_tot19  USING l_mask  #經海關
# {35} PRINT COLUMN g_c[31],g_x[18] CLIPPED,
#            COLUMN g_c[35],g_tot23  USING l_mask  #經海關
#      SKIP 1 LINE
#
# {35} PRINT COLUMN g_c[31],g_x[19] CLIPPED,
#            COLUMN g_c[35],l_sum1+g_tot23 USING l_mask,  #銷售額總計
#            COLUMN g_c[39],g_x[21] CLIPPED,l_sum2   USING l_mask
#      #No.TQC-6A0093 g_x后加CLIPPED --End  
#
#        PRINT g_dash[1,g_len]
#	SKIP 1 LINES
#
#     LET l_last_sw = 'y'
#     PRINT COLUMN g_c[31],g_x[4] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#         PRINT COLUMN g_c[31],g_x[4] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#------------No.FUN-750112--end----------#
 
FUNCTION err_chk(sr)
  DEFINE sr RECORD LIKE amd_file.*
  DEFINE sr1 RECORD
	            mark1  LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)#無傳票號碼
	            mark2  LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)#格式為空白
	            mark3  LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)#資料年度/月份為空白
	            mark4  LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)#稅額事後 * 0.05 > 1
	            mark5  LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)#發票號碼為空白
	            mark6  LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)#稅額錯誤
	            mark7  LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)#統一編號錯誤
                    mark8  LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)#統一編號錯誤
                    mark9  LIKE type_file.chr1        #No.FUN-680074 VARCHAR(1)#未金額為零錯誤
              END RECORD,
          l_amb03   LIKE amb_file.amb03,
          l_yy,l_mm LIKE type_file.num5,       #No.FUN-680074 SMALLINT
          l_flag  LIKE type_file.chr1          #No.FUN-680074 VARCHAR(1)
 
	     LET l_flag='N'
             INITIALIZE sr1.* TO NULL
	     IF  sr.amd172 NOT MATCHES '[123]' THEN
                 RETURN sr1.*
             END IF
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
 
             #----(9)-----申報格式不為'22'且廠商統一編號為空白或null-----
             IF sr.amd171 MATCHES '2*' AND sr.amd171!='22'
                AND (sr.amd04=' ' OR sr.amd04 IS NULL)
              THEN LET sr1.mark8='*'
                   LET l_flag='Y'
             END IF
             #----(10)-----統一編號為空白或null-----
             IF sr.amd171!='32'  THEN   #MOD-D30044
                IF NOT s_chkban(sr.amd04) THEN
                   LET sr1.mark8='*'
                   LET l_flag='Y'
                END IF
             END IF   #MOD-D30044
             #----(11)-----格式為 22 時，不為正確的發票字軌------------
	     IF sr.amd171='22'  THEN
		IF sr.amd172 = '2' THEN   #no:6374:sr.amd17 = '3'拿掉
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
		IF sr.amd172 = '2' THEN  #no:6374:sr.amd17 = '3'拿掉
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
#TQC-790177
