# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aapr122.4gl
# Descriptions...: 應付帳款彙總表
# Date & Author..: 93/01/06  By  Felicity  Tseng
# Modify.........: No.FUN-4C0097 05/01/03 By Nicola 報表架構修改
#                                                   增加列印員工姓名gen02
# Modify.........: No.TQC-590047 05/10/05 By kim 列印沒有公司名稱
# Modify.........: No.MOD-5C0070 05/12/14 By Carrier apz27='N'-->apa34-apa35,
#                                                    apz27='Y'-->apa73
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.FUN-660117 06/06/16 By Rainy Char改為 Like
# Modify.........: No.TQC-610053 06/07/03 By Smapmin 修改外部參數接收
# Modify.........: No.MOD-690006 06/09/05 By Smapmin 修正TQC-610053
# Modify.........: No.FUN-690028 06/09/19 By flowld 欄位類型改為LIKE
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/09 By baogui 結束位置調整
# Modify.........: No.TQC-6A0022 06/11/28 By Smapmin 廠商代碼與付款廠商內容印錯
# Modify.........: No.TQC-6c0172 06/12/27 By wujie  去除打印多余的頁次
# Modify.........: No.TQC-860021 08/06/10 By Sarah INPUT段漏了ON IDLE控制
# Modify.........: No.FUN-940102 09/04/20 By dxfwo  新增使用者對營運中心的權限管控
# Modify.........: No.TQC-980104 09/08/14 By mike 修改REPORT r122_rep()                                                             
#                                                 1.ORDER BY sr.order1,sr.order2,sr.apa00,sr.apa11,sr.plant  -->最后增加sr.plant    
#                                                 2.BEFORE GROUP OF sr.apa11  -->改成BEFORE GROUP OF sr.plant                       
#                                                 3.AFTER GROUP OF sr.apa11   -->改成AFTER GROUP OF sr.plant                        
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A10098 10/01/18 By wuxj 去掉plant，跨DB改成不跨DB，去掉營運中心
# Modify.........: No.CHI-A40017 10/04/22 By liuxqa modify sql
# Modify.........: No.MOD-B40141 11/04/15 By wujie AFTER GROUP OF sr.plant后去掉分号
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                   # Print condition RECORD
                 #wc      VARCHAR(600),       # Where condition   #TQC-630166
                 wc      STRING,       # Where condition   #TQC-630166
                 s       LIKE type_file.chr2,   # Prog. Version..: '5.30.06-13.03.12(02),         # Order by sequence
                 t       LIKE type_file.chr2,   # Prog. Version..: '5.30.06-13.03.12(02),         # Eject sw
                 u       LIKE type_file.chr2,   # Prog. Version..: '5.30.06-13.03.12(02),         # Group total sw
                 w       LIKE type_file.chr1,   # Prog. Version..: '5.30.06-13.03.12(01),         #
                 more    LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)          # Input more condition(Y/N)
              END RECORD,
         #No.FUN-A10098 mark----start---
         # g_ary  ARRAY [08] OF RECORD    #被選擇之工廠(最多四個)
         # Prog. Version..: '5.30.06-13.03.12(08),         #FUN-660117 reamrk
         #        plant  LIKE azp_file.azp01,#FUN-660117
         #        dbs_new  LIKE type_file.chr21   #No.FUN-690028 VARCHAR(21)
         #     END RECORD,
         #No.FUN-A10098 mark----end---
          g_idx       LIKE type_file.num10,  #No.FUN-690028 INTEGER,
          g_out       LIKE type_file.num10,  #No.FUN-690028 INTEGER,
          g_orderA    ARRAY[2] OF LIKE zaa_file.zaa08 #,  #No.FUN-690028 VARCHAR(10), #排序名稱  #No.FUN-A10098 去掉','
        #No.FUN-A10098 mark----start---
        # l_plant_1      LIKE azp_file.azp01,
        # l_plant_2      LIKE azp_file.azp01,
        # l_plant_3      LIKE azp_file.azp01,
        # l_plant_4      LIKE azp_file.azp01,
        # l_plant_5      LIKE azp_file.azp01,
        # l_plant_6      LIKE azp_file.azp01,
        # l_plant_7      LIKE azp_file.azp01,
        # l_plant_8      LIKE azp_file.azp01
        #No.FUN-A10098 mark----end---
DEFINE   g_i             LIKE type_file.num5    #No.FUN-690028 SMALLINT   #count/index for any purpose
#     DEFINEl_time LIKE type_file.chr8         #No.FUN-6A0055
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055
#  # Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
#  DECLARE m_plant_c CURSOR FOR SELECT azq01 FROM azq_file
#                                WHERE azq03 = 'AAP' ORDER BY 1
#  LET g_idx = 1
#  FOREACH m_plant_c INTO g_ary[g_idx].plant
#     IF g_idx >= 8 THEN EXIT FOREACH END IF
#     LET g_idx = g_idx + 1
#  END FOREACH
 
   LET g_pdate = ARG_VAL(1)            # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
  #NO.FUN-A10098 mark ---start--- 
  #LET l_plant_1  = ARG_VAL(8)
  #LET l_plant_2  = ARG_VAL(9)
  #LET l_plant_3  = ARG_VAL(10)
  #LET l_plant_4  = ARG_VAL(11)
  #LET l_plant_5  = ARG_VAL(12)
  #LET l_plant_6  = ARG_VAL(13)
  #LET l_plant_7  = ARG_VAL(14)
  #LET l_plant_8  = ARG_VAL(15)
  #LET tm.s  = ARG_VAL(16)
  #LET tm.t  = ARG_VAL(17)
  #LET tm.u  = ARG_VAL(18)
  ##-----TQC-610053---------
  #LET tm.w  = ARG_VAL(19)
  ##No.FUN-570264 --start--
  #LET g_rep_user = ARG_VAL(20)
  #LET g_rep_clas = ARG_VAL(21)
  #LET g_template = ARG_VAL(22)
  ##No.FUN-570264 ---end---
  ##-----END TQC-610053-----
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   LET tm.w  = ARG_VAL(11)
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
  #NO.FUN-A10098 mark ---end--- 

   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r122_tm(0,0)
   ELSE
   #NO.FUN-A10098 mark---start---
   #  #-----MOD-690006---------
   #  FOR g_idx = 1 TO 8
   #      LET g_ary[g_idx].plant=ARG_VAL(g_idx+7)
   #      IF s_chknplt(g_ary[g_idx].plant,'AAP','AAP') THEN
   #         LET g_ary[g_idx].dbs_new = g_dbs_new
   #      END IF
   #  END FOR
   #  #-----END MOD-690006-----
   #NO.FUN-A10098 mark---end---
      CALL r122()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD 
END MAIN
 
FUNCTION r122_tm   (p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690028 SMALLINT,
          l_cmd          LIKE type_file.chr1000  #No.FUN-690028 VARCHAR(400)
   DEFINE li_result      LIKE type_file.num5     #No.FUN-940102 
 
   LET p_row = 2 LET p_col = 16
   OPEN WINDOW r122_w AT p_row,p_col
     WITH FORM "aap/42f/aapr122"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition

 #NO.FUN-A10098  mark---start--- 
 # IF g_apz.apz26 = 'N' THEN
 #    LET l_plant_1 = g_plant
 # ELSE
 #    LET l_plant_1 = g_ary[1].plant
 #    LET l_plant_2 = g_ary[2].plant
 #    LET l_plant_3 = g_ary[3].plant
 #    LET l_plant_4 = g_ary[4].plant
 #    LET l_plant_5 = g_ary[5].plant
 #    LET l_plant_6 = g_ary[6].plant
 #    LET l_plant_7 = g_ary[7].plant
 #    LET l_plant_8 = g_ary[8].plant
 # END IF
 #NO.FUN-A10098 mark---end---

   LET tm.s    = '24'
   LET tm.u    = 'Y '
   LET tm.w    = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
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
      CONSTRUCT BY NAME tm.wc ON apa21,apa06,apa36,apa02,apa00
 
         ON ACTION locale
            LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
         LET INT_FLAG = 0
         CLOSE WINDOW r122_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
  #NO.FUN-A10098  mark---start--- 
  #   INPUT l_plant_1,l_plant_2,l_plant_3,l_plant_4,l_plant_5,l_plant_6,
  #         l_plant_7,l_plant_8 WITHOUT DEFAULTS
  #    FROM plant_1,plant_2,plant_3,plant_4,plant_5,plant_6,plant_7,plant_8
 
  #      BEFORE FIELD plant_1
  #         IF g_multpl='N' THEN  #不為多工廠環境
  #            LET l_plant_1= g_plant
  #            LET g_plant_new= NULL
  #            LET g_dbs_new=NULL
  #            LET g_ary[1].plant = l_plant_1
  #            LET g_ary[1].dbs_new = g_dbs_new
  #            DISPLAY l_plant_1 TO FORMONLY.plant_1
  #            EXIT INPUT       #將不會I/P plant_2 plant_3 plant_4
  #         END IF
 
  #      AFTER FIELD plant_1
  #         LET g_plant_new= l_plant_1
  #         IF l_plant_1 = g_plant THEN
  #            LET g_dbs_new=''
  #            LET g_ary[1].plant = l_plant_1
  #            LET g_ary[1].dbs_new = g_dbs_new
  #         ELSE
  #            IF NOT cl_null(l_plant_1) THEN  #檢查工廠並將新的資料庫放在g_dbs_new
  #               IF NOT s_chknplt(l_plant_1,'AAP','AAP') THEN
  #                  CALL cl_err(g_plant_new,g_errno,0)
  #                  NEXT FIELD plant_1
  #               END IF
  #               LET g_ary[1].plant = l_plant_1
  #               LET g_ary[1].dbs_new = g_dbs_new
  #  #No.FUN-940102 --begin--                                                                                                       
  #            CALL s_chk_demo(g_user,l_plant_1) RETURNING li_result                                                                
  #              IF not li_result THEN                                                                                              
  #                 NEXT FIELD plant_1                                                                                              
  #              END IF                                                                                                             
  #  #No.FUN-940102 --end--
  #            ELSE                     #輸入之工廠編號為' '或NULL
  #               LET g_ary[1].plant = l_plant_1
  #            END IF
  #         END IF
 
  #      AFTER FIELD plant_2
  #         LET l_plant_2 = duplicate(l_plant_2,1)   #不使"工廠編號"重覆
  #         LET g_plant_new= l_plant_2
  #         IF l_plant_2 = g_plant THEN
  #            LET g_dbs_new=''
  #            LET g_ary[2].plant = l_plant_2
  #            LET g_ary[2].dbs_new = g_dbs_new
  #         ELSE
  #            IF NOT cl_null(l_plant_2) THEN  #檢查工廠並將新的資料庫放在g_dbs_new
  #               IF NOT s_chknplt(l_plant_2,'AAP','AAP') THEN
  #                  CALL cl_err(g_plant_new,g_errno,0)
  #                  NEXT FIELD plant_2
  #               END IF
  #               LET g_ary[2].plant = l_plant_2
  #               LET g_ary[2].dbs_new = g_dbs_new
  #  #No.FUN-940102 --begin--                                                                                                       
  #            CALL s_chk_demo(g_user,l_plant_2) RETURNING li_result                                                                
  #              IF not li_result THEN                                                                                              
  #                 NEXT FIELD plant_2                                                                                              
  #              END IF                                                                                                             
  #  #No.FUN-940102 --end--
  #            ELSE                     #輸入之工廠編號為' '或NULL
  #               LET g_ary[2].plant = l_plant_2
  #            END IF
  #         END IF
 
  #      AFTER FIELD plant_3
  #         LET l_plant_3 = duplicate(l_plant_3,2)   #不使"工廠編號"重覆
  #         LET g_plant_new= l_plant_3
  #         IF l_plant_3 = g_plant THEN
  #            LET g_dbs_new=''
  #            LET g_ary[3].plant = l_plant_3
  #            LET g_ary[3].dbs_new = g_dbs_new
  #         ELSE
  #            IF NOT cl_null(l_plant_3) THEN  #檢查工廠並將新的資料庫放在g_dbs_new
  #               IF NOT s_chknplt(l_plant_3,'AAP','AAP') THEN
  #                  CALL cl_err(g_plant_new,g_errno,0)
  #                  NEXT FIELD plant_3
  #               END IF
  #               LET g_ary[3].plant = l_plant_3
  #               LET g_ary[3].dbs_new = g_dbs_new
  #  #No.FUN-940102 --begin--                                                                                                       
  #            CALL s_chk_demo(g_user,l_plant_3) RETURNING li_result                                                                
  #              IF not li_result THEN                                                                                              
  #                 NEXT FIELD plant_3                                                                                              
  #              END IF                                                                                                             
  #  #No.FUN-940102 --end--
  #            ELSE                     #輸入之工廠編號為' '或NULL
  #               LET g_ary[3].plant = l_plant_3
  #            END IF
  #         END IF
 
  #      AFTER FIELD plant_4
  #         LET l_plant_4 = duplicate(l_plant_4,3)   #不使"工廠編號"重覆
  #         LET g_plant_new= l_plant_4
  #         IF l_plant_4 = g_plant THEN
  #            LET g_dbs_new=''
  #            LET g_ary[4].plant = l_plant_4
  #            LET g_ary[4].dbs_new = g_dbs_new
  #         ELSE
  #            IF NOT cl_null(l_plant_4) THEN  #檢查工廠並將新的資料庫放在g_dbs_new
  #               IF NOT s_chknplt(l_plant_4,'AAP','AAP') THEN
  #                  CALL cl_err(g_plant_new,g_errno,0)
  #                  NEXT FIELD plant_4
  #               END IF
  #               LET g_ary[4].plant = l_plant_4
  #               LET g_ary[4].dbs_new = g_dbs_new
  #  #No.FUN-940102 --begin--                                                                                                       
  #            CALL s_chk_demo(g_user,l_plant_4) RETURNING li_result                                                                
  #              IF not li_result THEN                                                                                              
  #                 NEXT FIELD plant_4                                                                                              
  #              END IF                                                                                                             
  #  #No.FUN-940102 --end--
  #            ELSE                     #輸入之工廠編號為' '或NULL
  #               LET g_ary[4].plant = l_plant_4
  #            END IF
  #         END IF
 
  #      AFTER FIELD plant_5
  #         LET l_plant_5 = duplicate(l_plant_5,3)   #不使"工廠編號"重覆
  #         LET g_plant_new= l_plant_5
  #         IF l_plant_5 = g_plant THEN
  #            LET g_dbs_new=''
  #            LET g_ary[5].plant = l_plant_5
  #            LET g_ary[5].dbs_new = g_dbs_new
  #         ELSE
  #            IF NOT cl_null(l_plant_5) THEN
  #               IF NOT s_chknplt(l_plant_5,'AAP','AAP') THEN
  #                  CALL cl_err(g_plant_new,g_errno,0)
  #                  NEXT FIELD plant_5
  #               END IF
  #               LET g_ary[5].plant = l_plant_5
  #               LET g_ary[5].dbs_new = g_dbs_new
  #  #No.FUN-940102 --begin--                                                                                                       
  #            CALL s_chk_demo(g_user,l_plant_5) RETURNING li_result                                                                
  #              IF not li_result THEN                                                                                              
  #                 NEXT FIELD plant_5                                                                                              
  #              END IF                                                                                                             
  #  #No.FUN-940102 --end--
  #            ELSE
  #               LET g_ary[5].plant = l_plant_5
  #            END IF
  #         END IF
 
  #      AFTER FIELD plant_6
  #         LET l_plant_6 = duplicate(l_plant_6,3)   #不使"工廠編號"重覆
  #         LET g_plant_new= l_plant_6
  #         IF l_plant_6 = g_plant THEN
  #            LET g_dbs_new=''
  #            LET g_ary[6].plant = l_plant_6
  #            LET g_ary[6].dbs_new = g_dbs_new
  #         ELSE
  #            IF NOT cl_null(l_plant_6) THEN
  #               IF NOT s_chknplt(l_plant_6,'AAP','AAP') THEN
  #                  CALL cl_err(g_plant_new,g_errno,0)
  #                  NEXT FIELD plant_6
  #               END IF
  #               LET g_ary[6].plant = l_plant_6
  #               LET g_ary[6].dbs_new = g_dbs_new
  #  #No.FUN-940102 --begin--                                                                                                       
  #            CALL s_chk_demo(g_user,l_plant_6) RETURNING li_result                                                                
  #              IF not li_result THEN                                                                                              
  #                 NEXT FIELD plant_6                                                                                              
  #              END IF                                                                                                             
  #  #No.FUN-940102 --end--
  #            ELSE
  #               LET g_ary[6].plant = l_plant_6
  #            END IF
  #         END IF
 
  #      AFTER FIELD plant_7
  #         LET l_plant_7 = duplicate(l_plant_7,3)   #不使"工廠編號"重覆
  #         LET g_plant_new= l_plant_7
  #         IF l_plant_7 = g_plant THEN
  #            LET g_dbs_new=''
  #            LET g_ary[7].plant = l_plant_7
  #            LET g_ary[7].dbs_new = g_dbs_new
  #         ELSE
  #            IF NOT cl_null(l_plant_7) THEN
  #               IF NOT s_chknplt(l_plant_7,'AAP','AAP') THEN
  #                  CALL cl_err(g_plant_new,g_errno,0)
  #                  NEXT FIELD plant_7
  #               END IF
  #               LET g_ary[7].plant = l_plant_7
  #               LET g_ary[7].dbs_new = g_dbs_new
  #  #No.FUN-940102 --begin--                                                                                                       
  #            CALL s_chk_demo(g_user,l_plant_7) RETURNING li_result                                                                
  #              IF not li_result THEN                                                                                              
  #                 NEXT FIELD plant_7                                                                                              
  #              END IF                                                                                                             
  #  #No.FUN-940102 --end--
  #            ELSE
  #               LET g_ary[7].plant = l_plant_7
  #            END IF
  #         END IF
 
  #      AFTER FIELD plant_8
  #         LET l_plant_8 = duplicate(l_plant_8,3)   #不使"工廠編號"重覆
  #         LET g_plant_new= l_plant_8
  #         IF l_plant_8 = g_plant THEN
  #            LET g_dbs_new=''
  #            LET g_ary[8].plant = l_plant_8
  #            LET g_ary[8].dbs_new = g_dbs_new
  #         ELSE
  #            IF NOT cl_null(l_plant_8) THEN
  #               IF NOT s_chknplt(l_plant_8,'AAP','AAP') THEN
  #                  CALL cl_err(g_plant_new,g_errno,0)
  #                  NEXT FIELD plant_8
  #               END IF
  #               LET g_ary[8].plant = l_plant_8
  #               LET g_ary[8].dbs_new = g_dbs_new
  #  #No.FUN-940102 --begin--                                                                                                       
  #            CALL s_chk_demo(g_user,l_plant_8) RETURNING li_result                                                                
  #              IF not li_result THEN                                                                                              
  #                 NEXT FIELD plant_8                                                                                              
  #              END IF                                                                                                             
  #  #No.FUN-940102 --end--
  #            ELSE
  #               LET g_ary[8].plant = l_plant_8
  #            END IF
  #         END IF
  #         IF cl_null(l_plant_1) AND cl_null(l_plant_2) AND
  #            cl_null(l_plant_3) AND cl_null(l_plant_4) AND
  #            cl_null(l_plant_5) AND cl_null(l_plant_6) AND
  #            cl_null(l_plant_7) AND cl_null(l_plant_8) THEN
  #            CALL cl_err(0,'aap-136',0)
  #            NEXT FIELD plant_1
  #         END IF

  #      ON ACTION exit
  #         LET INT_FLAG = 1
  #         EXIT INPUT
 
  #      ON ACTION controlg       #TQC-860021
  #         CALL cl_cmdask()      #TQC-860021
 
  #      ON IDLE g_idle_seconds   #TQC-860021
  #         CALL cl_on_idle()     #TQC-860021
  #         CONTINUE INPUT        #TQC-860021
 
  #      ON ACTION about          #TQC-860021
  #         CALL cl_about()       #TQC-860021
 
  #      ON ACTION help           #TQC-860021
  #         CALL cl_show_help()   #TQC-860021
  #   END INPUT
 
  #   IF INT_FLAG THEN
  #      LET INT_FLAG = 0
  #      CLOSE WINDOW r122_w
  #      EXIT PROGRAM
  #   END IF
  #NO.FUN-A10098 mark --end ---
 
      INPUT BY NAME tm.w,tm2.s1,tm2.s2,tm2.t1,tm2.t2,tm2.u1,tm2.u2,
                    tm.more WITHOUT DEFAULTS
 
         AFTER FIELD w
            IF tm.w NOT MATCHES "[123]" THEN
               NEXT FIELD w
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
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
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
         LET INT_FLAG = 0
         CLOSE WINDOW r122_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='aapr122'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aapr122','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_lang CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                      #NO.FUN-A10098 mark---start---
                      # " '",l_plant_1 CLIPPED,"'",
                      # " '",l_plant_2 CLIPPED,"'",
                      # " '",l_plant_3 CLIPPED,"'",
                      # " '",l_plant_4 CLIPPED,"'",
                      # " '",l_plant_5 CLIPPED,"'",
                      # " '",l_plant_6 CLIPPED,"'",
                      # " '",l_plant_7 CLIPPED,"'",
                      # " '",l_plant_8 CLIPPED,"'",
                      #NO.FUN-A10098 mark---end---

                        " '",tm.s CLIPPED,"'",
                        " '",tm.t CLIPPED,"'",
                        " '",tm.u CLIPPED,"'",
                        " '",tm.w CLIPPED,"'",   #TQC-610053
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('aapr122',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW r122_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL r122()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r122_w
 
END FUNCTION
 
FUNCTION r122()
   DEFINE l_name    LIKE type_file.chr20,   #No.FUN-690028 VARCHAR(20),        # External(Disk) file name
#         l_time    VARCHAR(8),         # Used time for running the job
          #l_sql     VARCHAR(1200),      # RDSQL STATEMENT   #TQC-630166
          l_sql     STRING,      # RDSQL STATEMENT   #TQC-630166
          l_chr     LIKE type_file.chr1,   #No.FUN-690028 VARCHAR(1),
          l_order   ARRAY[5] OF  LIKE type_file.chr20,  #No.FUN-690028 VARCHAR(10)
          sr        RECORD order1 LIKE type_file.chr20,  #No.FUN-690028 VARCHAR(20)
                           order2 LIKE type_file.chr20,  #No.FUN-690028 VARCHAR(20)
                           plant  LIKE azp_file.azp01,
                           apa00  LIKE apa_file.apa00,
                           apa02  LIKE apa_file.apa02,
                           apa05  LIKE apa_file.apa05,
                           apa06  LIKE apa_file.apa06,
                           apa07  LIKE apa_file.apa07,
                           apa11  LIKE apa_file.apa11,
                           apa12  LIKE apa_file.apa12,
                           apa13  LIKE apa_file.apa13,
                           apa21  LIKE apa_file.apa21,
                           apa24  LIKE apa_file.apa24,
                           apa36  LIKE apa_file.apa36,
                           apa64  LIKE apa_file.apa64,
                           azi05  LIKE azi_file.azi05,
                           gen02  LIKE gen_file.gen02,
                           apr02  LIKE apr_file.apr02,
                           pma02  LIKE pma_file.pma02,
                           un_pay LIKE apa_file.apa34
                    END RECORD
 
#    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND apauser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND apagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND apagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('apauser', 'apagrup')
   #End:FUN-980030
 
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang #TQC-590047
 
   CALL cl_outnam('aapr122') RETURNING l_name
   START REPORT r122_rep TO l_name

  #NO.FUN-A10098 mark ---start---
  #FOR g_idx = 1 TO 8
  #   IF cl_null(g_ary[g_idx].plant) THEN
  #      CONTINUE FOR
  #   END IF

  #   LET g_out = g_idx
  #NO.FUN-A10098 mark ---end----
 
      #No.MOD-5C0070  --Begin
      IF g_apz.apz27 = 'N' THEN
        #LET l_sql = "SELECT '','','',",        #NO,FUN-A10098
         LET l_sql = "SELECT '','',apa100,",    #NO,FUN-A10098
                     " apa00, apa02, apa05, apa06, apa07, apa11, apa12,",
                     " apa13, apa21, ",
                     " apa24, apa36, apa64, azi05,'','','',",
                     " SUM(apa34-apa35-apa20*apa14)",
                   #NO.FUN-A10098 ---start---
                   # " FROM ",g_ary[g_idx].dbs_new CLIPPED," apa_file,",
                   # " OUTER ",g_ary[g_idx].dbs_new CLIPPED," azi_file",
                     " FROM apa_file LEFT OUTER JOIN azi_file ON azi01 = apa13 ",  #CHI-A40017 mod
                   #  " OUTER azi_file",                                           #CHI-A40017 mark
                   #NO.FUN-A10098 ---end---
                     #" WHERE azi_file.azi01 = apa_file.apa13 AND apa41='Y' ", #CHI-A40017 mark
                     " WHERE  apa41='Y' ",  #CHI-A40017 mod
                     "   AND apa42 = 'N'",
                     " AND ", tm.wc CLIPPED,
                     " GROUP BY apa100,apa00,apa02,apa05,apa06,apa07,apa11,",  #NO.FUN-A10098 add apa100
                     "          apa12,apa13,apa21,apa24,apa36,apa64,azi05"
      ELSE
        #LET l_sql = "SELECT '','','',",         #NO,FUN-A10098
         LET l_sql = "SELECT '','',apa100,",
                     " apa00, apa02, apa05, apa06, apa07, apa11, apa12,",
                     " apa13, apa21, ",
                     " apa24, apa36, apa64, azi05,'','','',",
                     " SUM(apa73-apa20*apa14)",
                   #NO.FUN-A10098 ---start---
                   # " FROM ",g_ary[g_idx].dbs_new CLIPPED," apa_file,",
                   # " OUTER ",g_ary[g_idx].dbs_new CLIPPED," azi_file",
                     " FROM apa_file LEFT OUTER JOIN azi_file ON azi01 = apa13 ", #CHI-A40017 mod
                   #  " OUTER azi_file",  #CHI-A40017 mark
                   #NO.FUN-A10098 ---end---
                     #" WHERE azi_file.azi01 = apa_file.apa13 AND apa41='Y' ",  #CHI-A40017 mark
                     " WHERE apa41='Y' ",  #CHI-A40017 mod
                     "   AND apa42 = 'N'",
                     " AND ", tm.wc CLIPPED,
                     " GROUP BY apa100,apa00,apa02,apa05,apa06,apa07,apa11,",  ##NO.FUN-A10098 add apa100
                     "          apa12,apa13,apa21,apa24,apa36,apa64,azi05"
      END IF
      #No.MOD-5C0070  --End
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      PREPARE r122_prepare1 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
      DECLARE r122_curs1 CURSOR FOR r122_prepare1
 
      LET g_pageno = 0
 
      FOREACH r122_curs1 INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
 
         SELECT gen02 INTO sr.gen02 FROM gen_file
          WHERE gen01 = sr.apa21
 
         SELECT pma02 INTO sr.pma02 FROM pma_file
          WHERE pma01 =sr.apa11
 
         LET l_sql = " SELECT apr02",
                    #NO.FUN-A10098--- start----
                    #" FROM ",g_ary[g_out].dbs_new," apr_file",
                     " FROM apr_file",
                    #NO.FUN-A10098--- end----
                     " WHERE apr01 ='",sr.apa36,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         PREPARE r122_p FROM l_sql
         DECLARE r122_c CURSOR FOR r122_p
         OPEN r122_c
         FETCH r122_c INTO sr.apr02   # 帳款類別名稱
 
         IF tm.w = '1' AND sr.un_pay <= 0 THEN
            CONTINUE FOREACH
         END IF
 
         IF tm.w = '2' AND sr.un_pay > 0 THEN
            CONTINUE FOREACH
         END IF
 
         IF sr.apa00[1,1] ='2' THEN
            LET sr.un_pay = sr.un_pay * -1
         END IF
 
         IF cl_null(sr.azi05) THEN
            LET sr.azi05 = 0
         END IF
 
       # LET sr.plant = g_ary[g_idx].plant   #NO.FUN-A10098 mark 
 
         FOR g_i = 1 TO 2
            CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.apa21
                                          LET g_orderA[g_i]= g_x[13]
                 WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.apa06,
                                                             sr.apa07
                                          LET g_orderA[g_i]= g_x[14]
                 WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.apa36
                                          LET g_orderA[g_i]= g_x[15]
                 WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.apa02 USING 'YYYYMMDD'
                                          LET g_orderA[g_i]= g_x[16]
                 WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.apa00
                                          LET g_orderA[g_i]= g_x[17]
                 OTHERWISE LET l_order[g_i]  = '-'
                           LET g_orderA[g_i] = ' '       #清為空白
            END CASE
         END FOR
 
         LET sr.order1 = l_order[1]
         LET sr.order2 = l_order[2]
         IF sr.order1 IS NULL THEN LET sr.order1 = ' '  END IF
         IF sr.order2 IS NULL THEN LET sr.order2 = ' '  END IF
         IF sr.apa11 IS NULL THEN LET sr.apa11 = ' ' END IF
 
         OUTPUT TO REPORT r122_rep(sr.*)
 
      END FOREACH
 # END FOR     #NO.FUN-A10098 mark
 
   FINISH REPORT r122_rep
 
   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055     #FUN-B80105  MARK
 
END FUNCTION
 
REPORT r122_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1),
          #l_sql        VARCHAR(200),   #TQC-630166
          l_sql        STRING,   #TQC-630166
          sr           RECORD order1 LIKE type_file.chr20,   #No.FUN-690028 VARCHAR(20)
                              order2 LIKE type_file.chr20,   #No.FUN-690028 VARCHAR(20)
                              plant  LIKE azp_file.azp01,    
                              apa00  LIKE apa_file.apa00,
                              apa02  LIKE apa_file.apa02,
                              apa05  LIKE apa_file.apa05,
                              apa06  LIKE apa_file.apa06,
                              apa07  LIKE apa_file.apa07,
                              apa11  LIKE apa_file.apa11,
                              apa12  LIKE apa_file.apa12,
                              apa13  LIKE apa_file.apa13,
                              apa21  LIKE apa_file.apa21,
                              apa24  LIKE apa_file.apa24,
                              apa36  LIKE apa_file.apa36,
                              apa64  LIKE apa_file.apa64,
                              azi05  LIKE azi_file.azi05,
                              gen02  LIKE gen_file.gen02,
                              apr02  LIKE apr_file.apr02,
                              pma02  LIKE pma_file.pma02,
                              un_pay LIKE apa_file.apa34
                       END RECORD,
      l_amt        LIKE apa_file.apa34,    # 應付金額
      l_amt_1      LIKE apa_file.apa34,
      l_amt_2      LIKE apa_file.apa34,
      l_chr        LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
   DEFINE g_head1       STRING
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line

 #NO.FUN-A10098 ---START---
   ORDER BY sr.order1,sr.order2,sr.apa00,sr.apa11,sr.plant #TQC-980104 add 增加sr.plant  
 # ORDER BY sr.order1,sr.order2,sr.apa00,sr.apa11
 #NO.FUN-A10098 ---end---
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         LET g_head1 = g_x[12] CLIPPED,g_orderA[1] CLIPPED,
#                      '-',g_orderA[2] CLIPPED,COLUMN g_len-7,g_x[3] CLIPPED
                       '-',g_orderA[2] CLIPPED   #No.TQC-6C0172
         PRINT g_head1
         PRINT g_dash[1,g_len] CLIPPED
       # PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],    #NO.FUN-A10098
         PRINT g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],            #NO.FUN-A10098
               g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44]
         PRINT g_dash1
         LET l_last_sw = 'n'
         LET l_amt_2 =0
 
      BEFORE GROUP OF sr.order1
         IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9) THEN
            SKIP TO TOP OF PAGE
         END IF
 
      BEFORE GROUP OF sr.order2
         IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9) THEN
            SKIP TO TOP OF PAGE
         END IF

     BEFORE GROUP OF sr.plant  #TQC-980104 sr.apa11-->sr.plant         # 付款方式
   #    PRINT COLUMN g_c[31],sr.plant,     #NO.FUN-A10098
        PRINT COLUMN g_c[32],sr.apa21,
               COLUMN g_c[33],sr.gen02,
               COLUMN g_c[34],sr.apr02,
               COLUMN g_c[35],sr.apa02,
               COLUMN g_c[36],sr.apa00,
               COLUMN g_c[37],sr.apa06,   #TQC-6A0022
               COLUMN g_c[38],sr.apa07,   #TQC-6A0022
               COLUMN g_c[39],sr.apa13,
               COLUMN g_c[40],sr.pma02,
               COLUMN g_c[41],sr.apa24 USING '####&', #No:8229
               COLUMN g_c[42],sr.apa64;

     AFTER GROUP OF sr.plant  #TQC-980104 sr.apa11-->sr.plant #NO.FUN-A10098 mark 
         LET l_amt = GROUP SUM(sr.un_pay)
         PRINT COLUMN g_c[43],cl_numfor(l_amt,43,g_azi05),
#              COLUMN g_c[44],sr.apa12;
               COLUMN g_c[44],sr.apa12   #No.MOD-B40141
 
      AFTER GROUP OF sr.order1
         IF tm.u[1,1] = 'Y' THEN
            LET l_amt_1 = GROUP SUM(sr.un_pay)
            PRINT COLUMN g_c[40],g_orderA[1] CLIPPED,
                  COLUMN g_c[41],g_x[10] CLIPPED,
                  COLUMN g_c[43],cl_numfor(l_amt_1,43,g_azi05)
            SKIP 1 LINE
         END IF
 
      AFTER GROUP OF sr.order2
         IF tm.u[2,2] = 'Y' THEN
            LET l_amt_1 = GROUP SUM(sr.un_pay)
            PRINT COLUMN g_c[40],g_orderA[2] CLIPPED,
                  COLUMN g_c[41],g_x[9] CLIPPED,
                  COLUMN g_c[43],cl_numfor(l_amt_1,43,g_azi05)
            SKIP 1 LINE
         END IF
 
      ON LAST ROW
         LET l_amt_2 = SUM(sr.un_pay)
         PRINT COLUMN g_c[41],g_x[11] CLIPPED,
               COLUMN g_c[43],cl_numfor(l_amt_2,43,g_azi05)
 
         IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
            CALL cl_wcchp(tm.wc,'apa01,apa02,apa03,apa04,apa05') RETURNING tm.wc
            #TQC-630166
            #IF tm.wc[001,070] > ' ' THEN            # for 80
            #   PRINT COLUMN g_c[31],g_x[8] CLIPPED,
            #         COLUMN g_c[32],tm.wc[001,070] CLIPPED
            #END IF
            #IF tm.wc[071,140] > ' ' THEN
            #   PRINT COLUMN g_c[32],tm.wc[071,140] CLIPPED
            #END IF
            #IF tm.wc[141,210] > ' ' THEN
            #   PRINT COLUMN g_c[32],tm.wc[141,210] CLIPPED
            #END IF
            #IF tm.wc[211,280] > ' ' THEN
            #   PRINT COLUMN g_c[32],tm.wc[211,280] CLIPPED
            #END IF
            PRINT g_dash[1,g_len] CLIPPED
            CALL cl_prt_pos_wc(tm.wc)
            #END TQC-630166
         END IF
         PRINT g_dash[1,g_len] CLIPPED
         LET l_last_sw = 'y'
    #    PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[44],g_x[7] CLIPPED      #TQC-6A0088
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[7] CLIPPED      #TQC-6A0088
 
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len] CLIPPED
   #        PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[44],g_x[6] CLIPPED    #TQC-6A0088
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[6] CLIPPED    #TQC-6A0088
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT
 
#NO.FUN-A10098 mark---start---
#FUNCTION duplicate(l_plant,n)     #檢查輸入之工廠編號是否重覆
#   DEFINE l_plant      LIKE azp_file.azp01
#   DEFINE l_idx, n     LIKE type_file.num10   #No;FUN-690028 INTEGER
# 
#   FOR l_idx = 1 TO n
#      IF g_ary[l_idx].plant = l_plant THEN
#         LET l_plant = ''
#      END IF
#   END FOR
# 
#   RETURN l_plant
# 
#END FUNCTION
#NO.FUN-A10098 mark---end---
