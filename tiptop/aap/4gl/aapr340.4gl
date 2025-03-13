# Prog. Version..: '5.30.06-13.03.18(00010)'     #
#
# Pattern name...: aapr340.4gl
# Descriptions...: 應付帳款明細表
# Date & Author..: 93/01/15 By Felicity Tseng
# Modify.........: No.B387 add 退貨折讓否,DM沖帳否,預付沖帳否
# Modify.........: No.9017 04/01/09 By Kitty plant長度修改
# Modify.........: No.FUN-4C0097 04/12/30 By Nicola 報表架構修改
#                                                   增加列印員工姓名gen02
# Modify.........: No.FUN-560011 05/06/03 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.MOD-5B0248 05/11/21 By Smapmin 總計小數位數取錯
# Modify.........: No.FUN-640097 06/04/13 By Smapmin 新增是否列印暫估帳款的條件
# Modify.........: No.MOD-660012 06/06/08 By Smapmin 小計有誤
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行時間
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-690080 06/10/11 By Czl 零用金賬款類型調整 
# Modify.........: No.FUN-6A0055 06/10/25 By ice l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/10 By baogui 結束位置調整
# Modify.........: No.FUN-720033 07/03/06 By jamie 增加本幣金額、本幣總計
# Modify.........: No.MOD-750024 07/05/07 By Smapmin 每頁表尾總合計取消
# Modify.........: No.TQC-750035 07/05/09 By Carrier 姓名的取法:零用金或是借款取cpf02,其他情況取gen02
# Modify.........: No.TQC-760029 07/06/06 By Smapmin 增加票到期日欄位,增加開窗功能
# Modify.........: No.TQC-770052 07/07/12 By Rayven 制表日期的位置在報表名之上
# Modify.........: No.CHI-780046 07/09/21 By sherry 賬款人員開窗由cpf_file改為gen_file
# Modify.........: No.TQC-7A0013 07/10/08 By sherry 報表改由CR輸出
# Modify.........: No.CHI-7B0051 07/12/03 By zhoufeng Crystal Report調整
# Modify.........: No.FUN-830108 08/03/26 By Smapmin 加入資料狀態的條件
# Modify.........: No.TQC-860021 08/06/10 By Sarah INPUT段漏了ON IDLE控制
# Modify.........: No.MOD-920138 09/02/11 By Sarah 當tm.z='N'時,SQL條件改為apa08<>'UNAP' OR apa08 IS NULL
# Modify.........: No.TQC-920069 09/02/20 By mike MSV BUG
# Modify.........: No.FUN-940102 09/04/20 By dxfwo  新增使用者對營運中心的權限管控
# Modify.........: No.FUN-970070 09/07/26 By hongmei 報表末尾增加列印apa44傳票編號
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990124 09/09/14 By mike sql錯誤   
# Modify.........: No:MOD-9B0115 09/11/19 By wujie 报表改抓多帐期资料
# Modify.........: No.FUN-9C0077 10/01/04 By baofei 程式精簡
# Modify.........: No:MOD-9C0414 09/12/28 By Sarah 修正MOD-990124,將UNION前的l_sql加上apa06!='EMPL'條件
# Modify.........: No.FUN-A10098 10/01/21 By chenls 跨DB語法改成不跨DB,pmc_file 改為 left outer join
# Modify.........: No:MOD-A30074 10/03/12 By sabrina 本幣金額未考慮月底重評價
# Modify.........: No:MOD-A80188 10/08/25 By Dido 多帳期資料抓取語法調整 
# Modify.........: No:MOD-AB0056 10/11/05 By Dido 付款日改用apc04 
# Modify.........: No:MOD-AB0257 10/11/30 By Dido 票據到期日改用apc05 
# Modify.........: No:TQC-B70203 11/07/28 By Sarah 未付金額計算應包含apc14與apc15
# Modify.........: No.FUN-BB0047 11/11/25 By fengrui  調整時間函數問題
# Modify.........: No.FUN-CC0093 13/01/21 By zhangweib 票期、憑證編號增加開窗

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                                 # Print condition RECORD
                 wc       STRING,                    # Where condition   #TQC-630166
                 sw_21   LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1)         #No.B387 add
                 sw_22   LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1)         #No.B387 add
                 sw_23   LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1)         #No.B387 add
                 a       LIKE type_file.chr2,        # No.FUN-690028 VARCHAR(2)         # apf_file.apf00
                 s       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(3)         # Order by sequence
                 t       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(3),         # Eject sw
                 u       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(3),         # Group total sw
                 z       LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1),         # Print UNAP   #FUN-640097
                 h       LIKE type_file.chr1,        #FUN-830108
                 more    LIKE type_file.chr1         # No.FUN-690028 VARCHAR(1)          # Input more condition(Y/N)
              END RECORD,
              g_ary   ARRAY [08] OF RECORD       #被選擇之工廠(最多四個)
              plant   LIKE azp_file.azp01,       #No:9017
              dbs_new LIKE type_file.chr21       # No.FUN-690028 VARCHAR(21)
              END RECORD,
          g_idx       LIKE type_file.num10,       # No.FUN-690028 INTEGER,
          g_orderA    ARRAY[3] OF LIKE zaa_file.zaa08      # No.FUN-690028 VARCHAR(10)  #排序名稱
DEFINE    g_i            LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
#No.FUN-A10098 --MARK BEGIN
#DEFINE    l_plant_1      LIKE azp_file.azp01,
#          l_plant_2      LIKE azp_file.azp01,
#          l_plant_3      LIKE azp_file.azp01,
#          l_plant_4      LIKE azp_file.azp01,
#          l_plant_5      LIKE azp_file.azp01,
#          l_plant_6      LIKE azp_file.azp01,
#          l_plant_7      LIKE azp_file.azp01,
#          l_plant_8      LIKE azp_file.azp01
#No.FUN-A10098 --MARK END
DEFINE l_table        STRING,                                                   
       g_str          STRING,                                                   
       g_sql          STRING                                                    
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                     # Supress DEL key function
 
   LET g_pdate = ARG_VAL(1)            # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.sw_21 = ARG_VAL(8)
   LET tm.sw_22 = ARG_VAL(9)
   LET tm.sw_23 = ARG_VAL(10)
   LET tm.s  = ARG_VAL(11)
   LET tm.t  = ARG_VAL(12)
   LET tm.u  = ARG_VAL(13)
#No.FUN-A10098 --BEGIN
#   LET l_plant_1 = ARG_VAL(14)
#   LET l_plant_2 = ARG_VAL(15)
#   LET l_plant_3 = ARG_VAL(16)
#   LET l_plant_4 = ARG_VAL(17)
#   LET l_plant_5 = ARG_VAL(18)
#   LET l_plant_6 = ARG_VAL(19)
#   LET l_plant_7 = ARG_VAL(20)
#   LET l_plant_8 = ARG_VAL(21)
#
#   LET tm.z = ARG_VAL(22)
#   LET tm.h = ARG_VAL(23)   #FUN-830108
#   LET g_rep_user = ARG_VAL(24)
#   LET g_rep_clas = ARG_VAL(25)
#   LET g_template = ARG_VAL(26)
#   LET g_rpt_name = ARG_VAL(27)  #No.FUN-7C0078
    LET tm.z = ARG_VAL(14)
    LET tm.h = ARG_VAL(15)
    LET g_rep_user = ARG_VAL(16)
    LET g_rep_clas = ARG_VAL(17)
    LET g_template = ARG_VAL(18)
    LET g_rpt_name = ARG_VAL(19)
#No.FUN-A10098 --END
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 mark

#No.FUN-A10098 ---begin 
#   LET g_sql = " azp01.azp_file.azp01,",                                         
#               " apa06.apa_file.apa06,",
   LET g_sql = " apa06.apa_file.apa06,",
#No.FUN-A10098 ---end
               " apa07.apa_file.apa07,", 
               " apa21.apa_file.apa21,",
               " gen02.gen_file.gen02,",
               " pma02.pma_file.pma02,",
               " apa24.apa_file.apa24,",
               " apa01.apa_file.apa01,",
               " apa36.apa_file.apa36,",
               " apa44.apa_file.apa44,",     #FUN-970070
               " apa00.apa_file.apa00,",
               " apa02.apa_file.apa02,",
               " apa12.apa_file.apa12,",
               " pay.apa_file.apa34,",
               " pay1.apa_file.apa34,",
               " apa64.apa_file.apa64,",
               " apa13.apa_file.apa13,",
               " apa41.apa_file.apa41,",
               " apa11.apa_file.apa11,",
               " azi04.azi_file.azi04,",
               " azi05.azi_file.azi05 "                                                 
   LET l_table = cl_prt_temptable('aapr340',g_sql) CLIPPED                      
   IF l_table = -1 THEN
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-BB0047 mark 
      EXIT PROGRAM
   END IF                                     
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                        
#               " VALUES(?,?,?,?,?, ?,?,?,?,?, ",                       #No.FUN-A10098 ---mark
               " VALUES(?,?,?,?, ?,?,?,?,?, ",                          #No.FUN-A10098 ---add
               "        ?,?,?,?,?, ?,?,?,?,?,?) " #FUN-970070 add? 
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1)
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-BB0047 mark 
      EXIT PROGRAM                         
   END IF                                                                       
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r340_tm(0,0)
   ELSE
      CALL r340()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
 
END MAIN
 
FUNCTION r340_tm(p_row,p_col)
   DEFINE p_row,p_col LIKE type_file.num5
   DEFINE l_zz08      LIKE zz_file.zz08
   DEFINE l_cmd       STRING 
   DEFINE li_result   LIKE type_file.num5  #No.FUN-940102 
   
   OPEN WINDOW r340_w WITH FORM "aap/42f/aapr340"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '123'
   LET tm.more = 'N'
   LET tm.sw_21 ='Y'         #No.B387 add
   LET tm.sw_22 ='Y'         #No.B387 add
   LET tm.sw_23 ='Y'         #No.B387 add
   LET tm.z = 'Y'            #FUN-640097
   LET tm.h = '3'            #FUN-830108
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   LET tm2.u3   = tm.u[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON apa06,apa21,apa11,apa24,apa12,apa64,apa02,apa01,apa13,apa00,apa36,apa44   #TQC-760029 #FUN-970070 add apa44
 
         ON ACTION CONTROLP
            CASE
            WHEN INFIELD(apa06) 
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_pmc1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apa06
               NEXT FIELD apa06
            WHEN INFIELD(apa21) 
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_gen"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apa21
               NEXT FIELD apa21
            WHEN INFIELD(apa11) 
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_pma"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apa11
               NEXT FIELD apa11
            WHEN INFIELD(apa01) 
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_apa07"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apa01
               NEXT FIELD apa01
            WHEN INFIELD(apa13) 
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_azi"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apa13
               NEXT FIELD apa13
            WHEN INFIELD(apa36) 
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_apr"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apa36
               NEXT FIELD apa36
           #No.FUN-CC0093 ---start--- Add
            WHEN INFIELD(apa24)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_apa24"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apa24
               NEXT FIELD apa24
            WHEN INFIELD(apa44)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_apa44"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apa44
               NEXT FIELD apa44
           #No.FUN-CC0093 ---end  --- Add
            END CASE
 
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
         CLOSE WINDOW r340_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
#No.FUN-A10098 --mark begin
# 
#     INPUT l_plant_1,l_plant_2,l_plant_3,l_plant_4,l_plant_5,l_plant_6,
#           l_plant_7,l_plant_8
#      FROM plant_1,plant_2,plant_3,plant_4,plant_5,plant_6,plant_7,plant_8
#
#        BEFORE FIELD plant_1
#           IF g_apz.apz26='N' THEN  #不為多工廠環境
#              LET l_plant_1= g_plant
#              LET g_plant_new= l_plant_1
#              LET g_dbs_new=''
#              LET g_ary[1].plant = l_plant_1
#              LET g_ary[1].dbs_new = g_dbs_new
#              DISPLAY l_plant_1 TO FORMONLY.plant_1
#              EXIT INPUT         #將不會I/P plant_2 plant_3 plant_4 #TQC-920069    
#           END IF
#
#        AFTER FIELD plant_1
#           LET g_plant_new= l_plant_1
#           IF l_plant_1 = g_plant THEN
#              LET g_dbs_new=''
#              LET g_ary[1].plant = l_plant_1
#              LET g_ary[1].dbs_new = g_dbs_new
#           ELSE
#              IF NOT cl_null(l_plant_1) THEN
#                 #檢查工廠並將新的資料庫放在g_dbs_new
#                 IF NOT s_chknplt(l_plant_1,'AAP','AAP') THEN
#                    CALL cl_err(g_plant_new,g_errno,0)
#                    NEXT FIELD plant_1
#                 END IF
#                 LET g_ary[1].plant = l_plant_1
#                 LET g_ary[1].dbs_new = g_dbs_new
#              CALL s_chk_demo(g_user,l_plant_1) RETURNING li_result
#                IF not li_result THEN 
#                   NEXT FIELD plant_1
#                END IF 
#              ELSE                     #輸入之工廠編號為' '或NULL
#                 LET g_ary[1].plant = l_plant_1
#              END IF
#           END IF
#
#        AFTER FIELD plant_2
#           LET l_plant_2 = duplicate(l_plant_2,1)   #不使"工廠編號"重覆
#           LET g_plant_new= l_plant_2
#           IF l_plant_2 = g_plant THEN
#              LET g_dbs_new=''
#              LET g_ary[2].plant = l_plant_2
#              LET g_ary[2].dbs_new = g_dbs_new
#           ELSE
#              IF NOT cl_null(l_plant_2) THEN
#                                       #檢查工廠並將新的資料庫放在g_dbs_new
#                 IF NOT s_chknplt(l_plant_2,'AAP','AAP') THEN
#                    CALL cl_err(g_plant_new,g_errno,0)
#                    NEXT FIELD plant_2
#                 END IF
#                 LET g_ary[2].plant = l_plant_2
#                 LET g_ary[2].dbs_new = g_dbs_new
#              CALL s_chk_demo(g_user,l_plant_2) RETURNING li_result                                                                
#                IF not li_result THEN                                                                                              
#                   NEXT FIELD plant_2                                                                                              
#                END IF                                                                                                             
#              ELSE                     #輸入之工廠編號為' '或NULL
#                 LET g_ary[2].plant = l_plant_2
#              END IF
#           END IF
#
#        AFTER FIELD plant_3
#           LET l_plant_3 = duplicate(l_plant_3,2)   #不使"工廠編號"重覆
#           LET g_plant_new= l_plant_3
#           IF l_plant_3 = g_plant THEN
#              LET g_dbs_new=''
#              LET g_ary[3].plant = l_plant_3
#              LET g_ary[3].dbs_new = g_dbs_new
#           ELSE
#              IF NOT cl_null(l_plant_3) THEN
#                                       #檢查工廠並將新的資料庫放在g_dbs_new
#                 IF NOT s_chknplt(l_plant_3,'AAP','AAP') THEN
#                    CALL cl_err(g_plant_new,g_errno,0)
#                    NEXT FIELD plant_3
#                 END IF
#                 LET g_ary[3].plant = l_plant_3
#                 LET g_ary[3].dbs_new = g_dbs_new
#              CALL s_chk_demo(g_user,l_plant_3) RETURNING li_result                                                                
#                IF not li_result THEN                                                                                              
#                   NEXT FIELD plant_3                                                                                              
#                END IF                                                                                                             
#              ELSE                     #輸入之工廠編號為' '或NULL
#                 LET g_ary[3].plant = l_plant_3
#              END IF
#           END IF
#
#        AFTER FIELD plant_4
#           LET l_plant_4 = duplicate(l_plant_4,3)   #不使"工廠編號"重覆
#           LET g_plant_new= l_plant_4
#           IF l_plant_4 = g_plant THEN
#              LET g_dbs_new=''
#              LET g_ary[4].plant = l_plant_4
#              LET g_ary[4].dbs_new = g_dbs_new
#           ELSE
#              IF NOT cl_null(l_plant_4) THEN
#                                       #檢查工廠並將新的資料庫放在g_dbs_new
#                 IF NOT s_chknplt(l_plant_4,'AAP','AAP') THEN
#                    CALL cl_err(g_plant_new,g_errno,0)
#                    NEXT FIELD plant_4
#                 END IF
#                 LET g_ary[4].plant = l_plant_4
#                 LET g_ary[4].dbs_new = g_dbs_new
#              CALL s_chk_demo(g_user,l_plant_4) RETURNING li_result                                                                
#                IF not li_result THEN                                                                                              
#                   NEXT FIELD plant_4                                                                                              
#                END IF                                                                                                             
#              ELSE                     #輸入之工廠編號為' '或NULL
#                 LET g_ary[4].plant = l_plant_4
#              END IF
#           END IF
#
#        AFTER FIELD plant_5
#           LET l_plant_5 = duplicate(l_plant_5,4)   #不使"工廠編號"重覆
#           LET g_plant_new= l_plant_5
#           IF l_plant_5 = g_plant THEN
#              LET g_dbs_new=''
#              LET g_ary[5].plant = l_plant_5
#              LET g_ary[5].dbs_new = g_dbs_new
#           ELSE
#              IF NOT cl_null(l_plant_5) THEN
#                                       #檢查工廠並將新的資料庫放在g_dbs_new
#                 IF NOT s_chknplt(l_plant_5,'AAP','AAP') THEN
#                    CALL cl_err(g_plant_new,g_errno,0)
#                    NEXT FIELD plant_5
#                 END IF
#                 LET g_ary[5].plant = l_plant_5
#                 LET g_ary[5].dbs_new = g_dbs_new
#              CALL s_chk_demo(g_user,l_plant_5) RETURNING li_result                                                                
#                IF not li_result THEN                                                                                              
#                   NEXT FIELD plant_5                                                                                              
#                END IF                                                                                                             
#              ELSE                     #輸入之工廠編號為' '或NULL
#                 LET g_ary[5].plant = l_plant_5
#              END IF
#           END IF
#
#        AFTER FIELD plant_6
#           LET l_plant_6 = duplicate(l_plant_6,5)   #不使"工廠編號"重覆
#           LET g_plant_new= l_plant_6
#           IF l_plant_6 = g_plant THEN
#              LET g_dbs_new=''
#              LET g_ary[6].plant = l_plant_6
#              LET g_ary[6].dbs_new = g_dbs_new
#           ELSE
#              IF NOT cl_null(l_plant_6) THEN
#                                       #檢查工廠並將新的資料庫放在g_dbs_new
#                 IF NOT s_chknplt(l_plant_6,'AAP','AAP') THEN
#                    CALL cl_err(g_plant_new,g_errno,0)
#                    NEXT FIELD plant_6
#                 END IF
#                 LET g_ary[6].plant = l_plant_6
#                 LET g_ary[6].dbs_new = g_dbs_new
#              CALL s_chk_demo(g_user,l_plant_6) RETURNING li_result                                                                
#                IF not li_result THEN                                                                                              
#                   NEXT FIELD plant_6                                                                                              
#                END IF                                                                                                             
#              ELSE                     #輸入之工廠編號為' '或NULL
#                 LET g_ary[6].plant = l_plant_6
#              END IF
#           END IF
#
#        AFTER FIELD plant_7
#           LET l_plant_7 = duplicate(l_plant_7,6)   #不使"工廠編號"重覆
#           LET g_plant_new= l_plant_7
#           IF l_plant_7 = g_plant THEN
#              LET g_dbs_new=''
#              LET g_ary[7].plant = l_plant_7
#              LET g_ary[7].dbs_new = g_dbs_new
#           ELSE
#              IF NOT cl_null(l_plant_7) THEN
#                                       #檢查工廠並將新的資料庫放在g_dbs_new
#                 IF NOT s_chknplt(l_plant_7,'AAP','AAP') THEN
#                    CALL cl_err(g_plant_new,g_errno,0)
#                    NEXT FIELD plant_7
#                 END IF
#                 LET g_ary[7].plant = l_plant_7
#                 LET g_ary[7].dbs_new = g_dbs_new
#              CALL s_chk_demo(g_user,l_plant_7) RETURNING li_result                                                                
#                IF not li_result THEN                                                                                              
#                   NEXT FIELD plant_7                                                                                              
#                END IF                                                                                                             
#              ELSE                     #輸入之工廠編號為' '或NULL
#                 LET g_ary[7].plant = l_plant_7
#              END IF
#           END IF
#
#        AFTER FIELD plant_8
#           LET l_plant_8 = duplicate(l_plant_8,7)   #不使"工廠編號"重覆
#           LET g_plant_new= l_plant_8
#           IF l_plant_8 = g_plant THEN
#              LET g_dbs_new=''
#              LET g_ary[8].plant = l_plant_8
#              LET g_ary[8].dbs_new = g_dbs_new
#           ELSE
#              IF NOT cl_null(l_plant_8) THEN
#                                       #檢查工廠並將新的資料庫放在g_dbs_new
#                 IF NOT s_chknplt(l_plant_8,'AAP','AAP') THEN
#                    CALL cl_err(g_plant_new,g_errno,0)
#                    NEXT FIELD plant_8
#                 END IF
#                 LET g_ary[8].plant = l_plant_8
#                 LET g_ary[8].dbs_new = g_dbs_new
#              CALL s_chk_demo(g_user,l_plant_8) RETURNING li_result                                                                
#                IF not li_result THEN                                                                                              
#                   NEXT FIELD plant_8                                                                                              
#                END IF                                                                                                             
#              ELSE                     #輸入之工廠編號為' '或NULL
#                 LET g_ary[8].plant = l_plant_8
#              END IF
#           END IF
#           IF cl_null(l_plant_1) AND cl_null(l_plant_2) AND
#              cl_null(l_plant_3) AND cl_null(l_plant_4) AND
#              cl_null(l_plant_5) AND cl_null(l_plant_6) AND
#              cl_null(l_plant_7) AND cl_null(l_plant_8) THEN
#              CALL cl_err(0,'aap-136',0)
#              NEXT FIELD plant_1
#           END IF
#
#        ON ACTION exit
#           LET INT_FLAG = 1
#           EXIT INPUT
#
#        ON ACTION controlg       #TQC-860021
#           CALL cl_cmdask()      #TQC-860021
#
#        ON IDLE g_idle_seconds   #TQC-860021
#           CALL cl_on_idle()     #TQC-860021
#           CONTINUE INPUT        #TQC-860021
#
#        ON ACTION about          #TQC-860021
#           CALL cl_about()       #TQC-860021
#
#        ON ACTION help           #TQC-860021
#           CALL cl_show_help()   #TQC-860021
#     END INPUT
#
#No.FUN-A10098 --mark end
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r340_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
 
      DISPLAY BY NAME tm.more         # Condition
 
      INPUT BY NAME tm.sw_21,tm.sw_23,tm.sw_22,tm.z,tm.h,tm2.s1,tm2.s2,tm2.s3,   #FUN-640097   #FUN-830108
                    tm2.t1,tm2.t2,tm2.t3,tm2.u1,tm2.u2,tm2.u3,
                    tm.more  WITHOUT DEFAULTS
 
         AFTER FIELD sw_21
            IF cl_null(tm.sw_21) OR tm.sw_21 NOT MATCHES '[YN]' THEN
               NEXT FIELD sw_21
            END IF
 
         AFTER FIELD sw_22
            IF cl_null(tm.sw_22) OR tm.sw_22 NOT MATCHES '[YN]' THEN
               NEXT FIELD sw_22
            END IF
 
         AFTER FIELD z
            IF cl_null(tm.z) OR tm.z NOT MATCHES '[YN]' THEN
               NEXT FIELD z
            END IF
 
         AFTER FIELD h
            IF tm.h NOT MATCHES '[123]' OR cl_null(tm.h) THEN 
               NEXT FIELD h 
            END IF
 
         AFTER FIELD sw_23
            IF cl_null(tm.sw_23) OR tm.sw_23 NOT MATCHES '[YN]' THEN
               NEXT FIELD sw_23
            END IF
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION CONTROLP
            CALL r340_wc()
 
         AFTER INPUT
           LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
           LET tm.t = tm2.t1,tm2.t2,tm2.t3
           LET tm.u = tm2.u1,tm2.u2,tm2.u3
 
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
         CLOSE WINDOW r340_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_zz08 FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aapr340'
         IF SQLCA.sqlcode OR l_zz08 IS NULL THEN
            CALL cl_err('aapr340','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc,'apa12','apc04')  #MOD-AB0056
            LET tm.wc = cl_replace_str(tm.wc,'apa64','apc05')  #MOD-AB0257
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_zz08 CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.sw_21 CLIPPED,"'",
                        " '",tm.sw_22 CLIPPED,"'",
                        " '",tm.sw_23 CLIPPED,"'",
                        " '",tm.s CLIPPED,"'",
                        " '",tm.t CLIPPED,"'",
                        " '",tm.u CLIPPED,"'",
#No.FUN-A10098 --mark start
#                        " '",l_plant_1 CLIPPED,"'",
#                        " '",l_plant_2 CLIPPED,"'",
#                        " '",l_plant_3 CLIPPED,"'",
#                        " '",l_plant_4 CLIPPED,"'",
#                        " '",l_plant_5 CLIPPED,"'",
#                        " '",l_plant_6 CLIPPED,"'",
#                        " '",l_plant_7 CLIPPED,"'",
#                        " '",l_plant_8 CLIPPED,"'",
#No.FUN-A10098 --mark end
                        " '",tm.z CLIPPED,"'",   #FUN-640097
                        " '",tm.h CLIPPED,"'",   #FUN-830108
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aapr340',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW r340_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL r340()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r340_w
 
END FUNCTION
 
FUNCTION r340_wc()
   DEFINE l_wc   STRING   #TQC-630166
 
   OPEN WINDOW r340_w2 AT 2,2
     WITH FORM "aap/42f/aapt110"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("aapt110")
   CALL cl_opmsg('q')
 
   CONSTRUCT BY NAME l_wc ON apa01,apa02,apa05,apa06,apa18,apa08,apa09,
                             apa11,apa12,apa13,apa14,apa15,apa16,apa55,
                             apa41,apa19,apa20,apa171,apa17,apa172,apa173,
                             apa174,apa21,apa22,apa24,apa25,apa44,apamksg,
                             apa36,apa44,apa31,apa51,apa32,apa52,apa34,apa54,   #FUN-970070 add apa44
                             apa35,apa33,apa53,apainpd,apauser,apagrup,
                             apamodu,apadate,apaacti
 
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
 
   CLOSE WINDOW r340_w2
 
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r340_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
 
END FUNCTION
 
FUNCTION r340()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
          l_sql  STRING,                          # RDSQL STATEMENT
          l_chr     LIKE type_file.chr1,          #No.FUN-690028 VARCHAR(1)
          l_curr    LIKE apa_file.apa13,          #No.TQC-7A0013
          l_amt_1   LIKE apa_file.apa34,          #No.TQC-7A0013
          l_amt_2   LIKE apa_file.apa34,          #No.TQC-7A0013         
          l_order   ARRAY[5] OF LIKE apa_file.apa01,        # No.FUN-690028 VARCHAR(30),             # FUN-560011
          sr        RECORD order1 LIKE apa_file.apa01,      # No.FUN-690028 VARCHAR(30),           # FUN-560011
                           order2 LIKE apa_file.apa01,      # No.FUN-690028 VARCHAR(30),           # FUN-560011
                           order3 LIKE apa_file.apa01,      # No.FUN-690028 VARCHAR(30),           # FUN-560011
                           plant LIKE azp_file.azp01,
                           apa00 LIKE apa_file.apa00,
                           apa01 LIKE apa_file.apa01,
                           apa02 LIKE apa_file.apa02,
                           apa06 LIKE apa_file.apa06,
                           apa11 LIKE apa_file.apa11,
                           apa12 LIKE apa_file.apa12,
                           apa13 LIKE apa_file.apa13,
                           apa21 LIKE apa_file.apa21,
                           apa24 LIKE apa_file.apa24,
                           apa36 LIKE apa_file.apa36,
                           apa44 LIKE apa_file.apa44, #FUN-970070
                           pay   LIKE apa_file.apa34, # 原幣應付金額
                           pay1  LIKE apa_file.apa34, # 本幣應付金額   #FUN-720033 add
                           apa07 LIKE apa_file.apa07, # 廠商簡稱
                           apa41 LIKE apa_file.apa41, # 確認碼
                           pmc51 LIKE pmc_file.pmc51, # 票據到期日
                           pmc52 LIKE pmc_file.pmc52, # 票據到期日
                           apa64 LIKE apa_file.apa64, # 到期日
                           azi03 LIKE azi_file.azi03,
                           azi04 LIKE azi_file.azi04,
                           azi05 LIKE azi_file.azi05,
                           pma02 LIKE pma_file.pma02,
                           gen02 LIKE gen_file.gen02,
                           mark  LIKE type_file.chr8        # No.FUN-690028 VARCHAR(05)
                    END RECORD
 
   CALL cl_del_data(l_table)    #No.TQC-7A0013
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = g_prog  #No.TQC-7A0013

   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('apauser', 'apagrup')
   LET tm.wc = cl_replace_str(tm.wc,'apa12','apc04')  #MOD-AB0056
   LET tm.wc = cl_replace_str(tm.wc,'apa64','apc05')  #MOD-AB0257
 
#No.FUN-A10098 ----mark start
#   FOR g_idx = 1 TO 8
#      IF cl_null(g_ary[g_idx].plant) THEN
#         CONTINUE FOR
#      END IF
#No.FUN-A10098 ----mark end
 
     #MOD-A30074---modify---start---
     #LET l_sql = "SELECT '','','','',",
     #            " apa00, apa01, apa02, apa06, apa11,",
     #            " apc04, apa13, apa21, apa24,",
     #            " apa36, apa44, (apc08-apc10-apc16), ",
     #            " (apc09-apc11-apc16*apc06), ", 
     #            " apa07, apa41, pmc51, pmc52,apa64,",
     #            " azi03, azi04, azi05,'','',''",
     #           #No.FUN-A10098 ----begin
     #           # " FROM ",g_ary[g_idx].dbs_new CLIPPED,"apa_file,",
     #           # g_ary[g_idx].dbs_new CLIPPED,"apc_file,",    #No.MOD-9B0115 
     #           # "       ",g_ary[g_idx].dbs_new CLIPPED,"pmc_file,",
     #           # "       ",g_ary[g_idx].dbs_new CLIPPED,"azi_file",
     #           # " WHERE pmc_file.pmc01=apa06 ",                      #MOD-990124
     #           # " AND azi_file.azi01 = apa_file.apa13 ",
     #            " FROM apa_file LEFT OUTER JOIN pmc_file ON apa06=pmc_file.pmc01,apc_file,azi_file",
     #            " WHERE azi_file.azi01 = apa_file.apa13 ",
     #           #No.FUN-A10098 ----end
     #            " AND apa06!='EMPL'",      #MOD-9C0414 add
     #            " AND apa01 =apc01",       #No.MOD-9B0115 
     #            " AND apa42 = 'N' ",
     #            " AND apa34f > (apa35f+apa20)",
     #            " AND ", tm.wc CLIPPED
      IF g_apz.apz27 = 'N' THEN 
         LET l_sql = "SELECT '','','','',",
                     " apa00, apa01, apa02, apa06, apa11,",
                     " apc04, apa13, apa21, apa24,",
                     " apa36, apa44, (apc08-apc10-apc14-apc16), ",  #TQC-B70203 add apc14
                     " (apc09-apc11-apc15-apc16*apa14), ",   #TQC-B70203 add apc15
                    #" apa07, apa41, pmc51, pmc52,apa64,",               #MOD-AB0257 mark
                     " apa07, apa41, pmc51, pmc52,apc05,",               #MOD-AB0257
                     " azi03, azi04, azi05,'','',''",
                     " FROM apa_file LEFT OUTER JOIN pmc_file ON apa06=pmc_file.pmc01,apc_file,azi_file",
                     " WHERE azi_file.azi01 = apa_file.apa13 ",
                     " AND apa06!='EMPL'",     
                     " AND apa01 =apc01",     
                     " AND apa42 = 'N' ",
                     " AND apa34f > (apa35f+apa20)",
                     " AND ", tm.wc CLIPPED
      ELSE
         LET l_sql = "SELECT '','','','',",
                     " apa00, apa01, apa02, apa06, apa11,",
                     " apc04, apa13, apa21, apa24,",
                     " apa36, apa44, (apc08-apc10-apc14-apc16), ",  #TQC-B70203 add apc14
                     " (apc13-apc16*apa72), ", 
                    #" apa07, apa41, pmc51, pmc52,apa64,",               #MOD-AB0257 mark
                     " apa07, apa41, pmc51, pmc52,apc05,",               #MOD-AB0257
                     " azi03, azi04, azi05,'','',''",
                     " FROM apa_file LEFT OUTER JOIN pmc_file ON apa06=pmc_file.pmc01,apc_file,azi_file",
                     " WHERE azi_file.azi01 = apa_file.apa13 ",
                     " AND apa06!='EMPL'",     
                     " AND apa01 =apc01",     
                     " AND apa42 = 'N' ",
                     " AND apa34f > (apa35f+apa20)",
                     " AND ", tm.wc CLIPPED
      END IF
     #MOD-A30074---modify---end---
      IF tm.z = 'N' THEN 
         LET l_sql = l_sql," AND (apa08 <> 'UNAP' OR apa08 IS NULL)"  #MOD-920138
      END IF
 
      IF tm.h = '1' THEN 
         LET l_sql = l_sql," AND apa41 = 'Y'"
      END IF
      IF tm.h = '2' THEN 
         LET l_sql = l_sql," AND apa41 = 'N'"
      END IF
 
     #MOD-A30074---modify---start---
     #LET l_sql = l_sql CLIPPED," UNION ",                                                                                          
     #            "SELECT '','','','',",                                                                                            
     #            " apa00, apa01, apa02, apa06, apa11,",                                                                            
     #            " apc04, apa13, apa21, apa24,",                                                                                   
     #            " apa36, apa44,(apc08-apc10-apc16), ", 
     #            " (apc09-apc11-apc16*apc06), ",
     #            " apa07, apa41, 0, '',apa64,",
     #            " azi03, azi04, azi05,'','',''",
     #           #No.FUN-A10098 ----begin
     #           # " FROM ",g_ary[g_idx].dbs_new CLIPPED,"apa_file,",
     #           # g_ary[g_idx].dbs_new CLIPPED,"apc_file,",    #No.MOD-9B0115 
     #           # "       ",g_ary[g_idx].dbs_new CLIPPED,"azi_file",
     #            " FROM apa_file,apc_file,azi_file",
     #           #No.FUN-A10098 ----end
     #            " WHERE apa06='EMPL'",                                                                                            
     #            " AND azi_file.azi01 = apa_file.apa13 ",       
     #            " AND apa01=apc01",   #No.MOD-9B0115                                                                                         
     #            " AND apa42 = 'N' ",                                                                                              
     #            " AND apa34f > (apa35f+apa20)",                                                                                   
     #            " AND ", tm.wc CLIPPED                                                                                            
      IF g_apz.apz27 = 'N' THEN
        #LET l_sql = l_sql CLIPPED," UNION ",                    #MOD-A80188 mark
         LET l_sql = l_sql CLIPPED," UNION ALL ",                #MOD-A80188
                     "SELECT '','','','',",                                                                                            
                     " apa00, apa01, apa02, apa06, apa11,",                                                                            
                     " apc04, apa13, apa21, apa24,",                                                                                   
                     " apa36, apa44,(apc08-apc10-apc14-apc16), ",  #TQC-B70203 add apc14
                     " (apc09-apc11-apc15-apc16*apa14), ",  #TQC-B70203 add apc15
                    #" apa07, apa41, 0, '',apa64,",              #MOD-AB0257 mark
                     " apa07, apa41, 0, '',apc05,",              #MOD-AB0257
                     " azi03, azi04, azi05,'','',''",
                     " FROM apa_file,apc_file,azi_file",
                     " WHERE apa06='EMPL'",                                                                                            
                     " AND azi_file.azi01 = apa_file.apa13 ",       
                     " AND apa01=apc01",  
                     " AND apa42 = 'N' ",                                                                                              
                     " AND apa34f > (apa35f+apa20)",                                                                                   
                     " AND ", tm.wc CLIPPED                                                                                            
      ELSE
        #LET l_sql = l_sql CLIPPED," UNION ",                    #MOD-A80188 mark
         LET l_sql = l_sql CLIPPED," UNION ALL ",                #MOD-A80188
                     "SELECT '','','','',",                                                                                            
                     " apa00, apa01, apa02, apa06, apa11,",                                                                            
                     " apc04, apa13, apa21, apa24,",                                                                                   
                     " apa36, apa44,(apc08-apc10-apc14-apc16), ",  #TQC-B70203 add apc14
                     " (apc13-apc16*apa72), ",
                    #" apa07, apa41, 0, '',apa64,",              #MOD-AB0257 mark
                     " apa07, apa41, 0, '',apc05,",              #MOD-AB0257
                     " azi03, azi04, azi05,'','',''",
                     " FROM apa_file,apc_file,azi_file",
                     " WHERE apa06='EMPL'",                                                                                            
                     " AND azi_file.azi01 = apa_file.apa13 ",       
                     " AND apa01=apc01",   
                     " AND apa42 = 'N' ",                                                                                              
                     " AND apa34f > (apa35f+apa20)",                                                                                   
                     " AND ", tm.wc CLIPPED                                                                                            
      END IF
     #MOD-A30074---modify---end---
      IF tm.z = 'N' THEN                                                                                                            
         LET l_sql = l_sql," AND (apa08 <> 'UNAP' OR apa08 IS NULL)"  #MOD-920138                                                   
      END IF                                                                                                                        
      IF tm.h = '1' THEN                                                                                                            
         LET l_sql = l_sql," AND apa41 = 'Y'"                                                                                       
      END IF                                                
      IF tm.h = '2' THEN                                                                                                            
         LET l_sql = l_sql," AND apa41 = 'N'"                                                                                       
      END IF                                                                                                                        
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      PREPARE r340_prepare1 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      DECLARE r340_curs1 CURSOR FOR r340_prepare1
 
      LET g_pageno = 0
 
      FOREACH r340_curs1 INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         

            SELECT gen02 INTO sr.gen02 FROM gen_file
             WHERE gen01 = sr.apa21

 
         SELECT pma02 INTO sr.pma02 FROM pma_file
          WHERE pma01= sr.apa11
 
         IF sr.apa41 != 'Y' THEN
            LET sr.mark = sr.apa13 CLIPPED,'*'
         ELSE
            LET sr.mark = sr.apa13
         END IF
 
         IF sr.apa00[1,1]='2' THEN
            LET sr.pay  = sr.pay  * -1
            LET sr.pay1 = sr.pay1 * -1  #FUN-720033 add 
         END IF
 
         IF tm.sw_21 ='N' AND sr.apa00='21' THEN
            CONTINUE FOREACH
         END IF
 
         IF tm.sw_22 ='N' AND sr.apa00='22' THEN
            CONTINUE FOREACH
         END IF
 
          IF tm.sw_23 ='N' AND (sr.apa00='23' or sr.apa00='25') THEN     #No.FUN-690080
            CONTINUE FOREACH
         END IF
 
         IF cl_null(sr.azi03) THEN LET sr.azi03 = 0 END IF
         IF cl_null(sr.azi04) THEN LET sr.azi04 = 0 END IF
         IF cl_null(sr.azi05) THEN LET sr.azi05 = 0 END IF
         IF sr.apa24 > 0 THEN LET sr.pmc51 = sr.pmc52 END IF
 
#         LET sr.plant = g_ary[g_idx].plant      #No.FUN-A10098 ----mark
 

#         EXECUTE insert_prep USING sr.plant,sr.apa06,sr.apa07,sr.apa21,       #No.FUN-A10098 ----mark
         EXECUTE insert_prep USING sr.apa06,sr.apa07,sr.apa21,                 #No.FUN-A10098 ----add
                                   sr.gen02,sr.pma02,sr.apa24,sr.apa01,sr.apa36,sr.apa44,  #FUN-970070 add apa44
                                   sr.apa00,sr.apa02,sr.apa12,sr.pay,           #No.CHI-7B0051
                                   sr.pay1,sr.apa64,sr.mark,sr.apa41,sr.apa11,  #No.CHI-7B0051
                                   sr.azi04,sr.azi05   

      END FOREACH
#   END FOR        #No.FUN-A10098 ----mark
 

   IF g_zz05 = 'Y' THEN                                                       
      CALL cl_wcchp(tm.wc,'apa06,apa21,apa11,apa24,apa12,apa64,apa02,apa01,apa13,apa00,apa36,apa44')   #FUN-970070 add apa44      
      RETURNING g_str                                                         
   END IF   
   LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
               tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",tm.u[1,1],";",
               tm.u[2,2],";",tm.u[3,3],";",g_azi04,";",g_azi05
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED           
   CALL cl_prt_cs3('aapr340','aapr340',l_sql,g_str)    
END FUNCTION


#No.FUN-A10098 ----mark 
#FUNCTION duplicate(l_plant,n)     #檢查輸入之工廠編號是否重覆
#   DEFINE l_plant      LIKE azp_file.azp01
#   DEFINE l_idx, n     LIKE type_file.num10       # No.FUN-690028 INTEGER
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
#No.FUN-A10098 ----mark end
 
FUNCTION r340_create_tmp()    #no.5197
   CREATE TEMP TABLE r340_tmp(
       curr      LIKE apa_file.apa13,
       amt1      LIKE type_file.num20_6,
       amt2      LIKE type_file.num20_6,   #FUN-720033 add
       order1    LIKE apa_file.apa01,
       order2    LIKE apa_file.apa01,
       order3    LIKE apa_file.apa01)
      
END FUNCTION
#No.FUN-9C0077 程式精簡
