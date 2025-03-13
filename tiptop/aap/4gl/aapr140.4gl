# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aapr140.4gl
# Descriptions...: 入庫退貨未匹配明細表列印作業
# Date & Author..: 94/03/29 By Roger
# Modify.........: No.8032 03/12/05 ching add "單價為零" 選項
# Modify.........: No.8855 04/01/13 Kammy 在 output to report 之前要處理
#                                       LET sr.amt = cl_digcut(sr.amt,sr.azi04)
#                                       因為總計時尾差問題。
# Modify.........: No.FUN-4C0097 04/12/27 By Nicola 報表架構修改
#                                                   增加印列單號+項次rvv01a、採購單號+項次rvb04a、類別名稱rvv03a、品名ima02、規格ima021、幣別pmm22
#
# Modify.........: No.FUN-540057 05/05/09 By Trisy 發票號碼調整
# Modify.........: No.FUN-550030 05/05/18 By ice 單據編號欄位放大
# Modify.........: No.FUN-560089 05/06/21 By Smapmin 單位數量改抓計價單位計價數量
# Modify.........: No.TQC-5B0120 05/11/29 By Echo 發票號碼調整由10放大至16時,列印資料應該也要一併修改而不是列印「11,20]
# Modify.........: No.TQC-630235 06/03/24 By Smapmin 拿掉CONTROLP
# Modify.........: No.FUN-640071 06/04/09 By Smapmin 數量不需取位
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.TQC-610053 06/07/03 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-650164 06/08/29 By rainy 取消 'RTN' 判斷
# Modify.........: No.TQC-690032 06/09/11 By cl    1.去除驗退                                                                       
#                                                  2.收貨單為空時，亦可打印出資料
# Modify.........: No.FUN-690028 06/09/15 By flowld 欄位類型修改為LIKE
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/10 By baogui 結束位置調整
# Modify.........: No.FUN-750097 07/06/14 By cheunl  報表轉成CR
# Modify.........: No.MOD-7A0062 07/10/15 By Smapmin 品名由原先的ima02改抓pmn041
# Modify.........: No.MOD-7B0083 07/11/09 By smapmin 若於apmt722維護無數量有金額的純金額折讓,尚未拋轉折讓AP.
#                                                    aapr140無法顯示未匹配的資料.
# Modify.........: No.TQC-7B0083 07/11/27 By Carrier add rvv88
# Modify.........: No.MOD-890054 08/09/09 By Sarah 若為大陸版時,倉退單無須對應收貨單發票,
#                                                  應抓取此倉退單+項次(rvw08+rvw09)對應的rvw01發票號碼
# Modify.........: No.MOD-8A0234 08/10/27 By wujie   SQL中沒有pmm_file的關聯
# Modify.........: No.MOD-8B0066 08/11/06 By sherry 報表打印單價小數位數取位不對
# Modify.........: No.FUN-940102 09/04/20 By dxfwo  新增使用者對營運中心的權限管控
# Modify.........: No.MOD-970036 09/07/06 By mike 改用rvv_file去OUTER pmm_file   
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0077 10/01/04 By baofei 程式精簡
# Modify.........: No.FUN-A10098 10/01/19 By wuxj 去掉plant，跨DB改為不跨DB
# Modify.........: No.FUN-A60056 10/06/22 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No:CHI-B30019 11/03/29 By Dido 若為多發票時,發票編號請顯示 MISC 
# Modify.........: No:MOD-B50185 11/05/24 By Dido 過濾 rvv89 != 'Y' 
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.FUN-BB0002 12/01/11 By pauline rvb22無資料時進入取rvv22 
# Modify.........: No:FUN-BB0173 12/01/17 by pauline 增加跨法人抓取資料
# Modify.........: No.FUN-C30202 12/05/28 By wangrr 報表中增加rvu08採購性質欄位
# Modify.........: No:TQC-CC0110 12/12/24 By qirl 欄位開窗

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
                 wc      STRING,        # Where condition   #TQC-630166
               # azp01 LIKE azp_file.azp01,#  #NO.FUN-A10098  mark
                 azp01 LIKE azp_file.azp01,   #FUN-BB0173 add
                 a     LIKE type_file.chr1,   #No.FUN-690028  VARCHAR(1),
                 b     LIKE type_file.chr1,   #No.FUN-690028  VARCHAR(1),        #No:8032
                 s     LIKE type_file.chr3,   #No.FUN-690028  VARCHAR(3),        # Order by sequence
                 t     LIKE type_file.chr3,   #No.FUN-690028  VARCHAR(3),        # Eject sw
                 u     LIKE type_file.chr3,   #No.FUN-690028  VARCHAR(3),        # Total sw
                 v     LIKE type_file.chr1,   #No.FUN-690028  VARCHAR(1),        #
                 j     LIKE type_file.chr1,   #No.FUN-690028  VARCHAR(1),        # Ex,rate transfer
                 more  LIKE type_file.chr1    #No.FUN-690028  VARCHAR(1)         # Input more condition(Y/N)
              END RECORD,
       l_orderA      ARRAY[4] OF LIKE zaa_file.zaa08   #No.FUN-690028 VARCHAR(16)  #排序名稱     #No.FUN-550030
DEFINE g_i           LIKE type_file.num5    #No.FUN-690028  SMALLINT   #count/index for any purpose
DEFINE l_table        STRING                  #No.FUN-750097                                                                        
DEFINE g_str          STRING                  #No.FUN-750097                                                                        
DEFINE g_sql          STRING                  #No.FUN-750097
DEFINE g_flag         LIKE type_file.chr1     #FUN-BB0173 add 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
  #NO.FUN-A10098 ---start---
  #LET tm.azp01 = ARG_VAL(8)
  #LET tm.a = ARG_VAL(9)
  #LET tm.b = ARG_VAL(10)
  #LET tm.v = ARG_VAL(11)
  #LET tm.s  = ARG_VAL(12)
  #LET tm.t  = ARG_VAL(13)
  #LET tm.u  = ARG_VAL(14)
  #LET g_rep_user = ARG_VAL(15)
  #LET g_rep_clas = ARG_VAL(16)
  #LET g_template = ARG_VAL(17)
  #LET g_rpt_name = ARG_VAL(18)  #No.FUN-7C0078
#FUN-BB0173 mark START
#  LET tm.a = ARG_VAL(8)
#  LET tm.b = ARG_VAL(9)
#  LET tm.v = ARG_VAL(10)
#  LET tm.s  = ARG_VAL(11)
#  LET tm.t  = ARG_VAL(12)
#  LET tm.u  = ARG_VAL(13)
#  LET g_rep_user = ARG_VAL(14)
#  LET g_rep_clas = ARG_VAL(15)
#  LET g_template = ARG_VAL(16)
#  LET g_rpt_name = ARG_VAL(17)
#FUN-BB0173 mark END
  #NO.FUN-A10098 ---end---
#FUN-BB0173 add START
   LET tm.azp01 = ARG_VAL(8)
   LET tm.a = ARG_VAL(9)
   LET tm.b = ARG_VAL(10)
   LET tm.v = ARG_VAL(11)
   LET tm.s  = ARG_VAL(12)
   LET tm.t  = ARG_VAL(13)
   LET tm.u  = ARG_VAL(14)
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   LET g_rpt_name = ARG_VAL(18)
#FUN-BB0173 add END
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_sql = " rvv01.rvv_file.rvv01,",
               " rvv02.rvv_file.rvv02,", 
               " rvv03.rvv_file.rvv03,", 
               " rvv06.rvv_file.rvv06,", 
               " rvv09.rvv_file.rvv09,", 
               " rvv23.rvv_file.rvv23,", 
               " rvv88.rvv_file.rvv88,",   #No.TQC-7B0083
               " rvv31.rvv_file.rvv31,", 
               " rvv38.rvv_file.rvv38,", 
               " rvv87.rvv_file.rvv87,", 
               " rvb03.rvb_file.rvb03,", 
               " rvb04.rvb_file.rvb04,", 
               " rvb22.rvb_file.rvb22,", 
               " ima02.ima_file.ima02,",    
               " ima021.ima_file.ima021,", 
               " pmc03.pmc_file.pmc03,", 
               " pmm20.pmm_file.pmm20,", 
               " pmm22.pmm_file.pmm22,",
               " azi03.azi_file.azi03,",                                                                        
               " azi04.azi_file.azi04,",                                                                        
               " azi05.azi_file.azi05,",
               " rvv39.rvv_file.rvv39,",   #MOD-7B0083
               " rvu08.rvu_file.rvu08"     #FUN-C30202 add rvu08
   LET l_table = cl_prt_temptable('aapr140',g_sql) CLIPPED   # 產生Temp Table                                                      
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      

    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                           
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",                                                                          
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? ,?,? )"    #MOD-7B0083 #No.TQC-7B0083 #FUN-C30202 add 1?
    PREPARE insert_prep FROM g_sql                                                                                                  

    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL aapr140_tm(0,0)
   ELSE
      CALL aapr140()
   END IF

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION aapr140_tm(p_row,p_col)
   DEFINE p_row,p_col  LIKE type_file.num5,    #No.FUN-690028  SMALLINT,
          l_cmd        LIKE type_file.chr1000  #No.FUN-690028  VARCHAR(400)
   DEFINE li_result    LIKE type_file.num5     #No.FUN-940102 
   
   OPEN WINDOW aapr140_w WITH FORM "aap/42f/aapr140"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   CALL r140_set_entry()              #FUN-BB0173 add
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '123'
   LET tm.u    = 'Y  '
   LET tm.v    = '3'
   LET tm.a    = 'N'
   LET tm.b    = 'Y'    #No:8032
   LET tm.more = 'N'
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
   LET tm.azp01 = g_plant   #FUN-BB0173 add
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
      CONSTRUCT BY NAME tm.wc ON rvv06,rvv09,rvv01,rvb22,rvv03,pmm22,rvb04,rva04
     #--TQC-CC0110--add---star---
      ON ACTION CONTROLP
        CASE
            WHEN INFIELD(rvv01)
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
              LET g_qryparam.form = "q_rvv01"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO rvv01
              NEXT FIELD rvv01
            WHEN INFIELD(rvv06)
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
              LET g_qryparam.form = "q_rvv06"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO rvv06
              NEXT FIELD rvv06
            WHEN INFIELD(rvb04)
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
              LET g_qryparam.form = "q_rvb04"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO rvb04
              NEXT FIELD rvb04
              WHEN INFIELD(pmm22)
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
              LET g_qryparam.form = "q_pmm22"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmm22
              NEXT FIELD pmm22
        OTHERWISE EXIT CASE
        END CASE
     #--TQC-CC0110--add---end---
 
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
         CLOSE WINDOW aapr140_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
     #INPUT BY NAME tm.azp01,tm.a,tm.b,tm.v,tm2.s1,tm2.s2,tm2.s3,    #NO.FUN-A10098 
     #INPUT BY NAME tm.a,tm.b,tm.v,tm2.s1,tm2.s2,tm2.s3,             #NO.FUN-A10098  #FUN-BB0173 mark
      INPUT BY NAME tm.azp01,tm.a,tm.b,tm.v,tm2.s1,tm2.s2,tm2.s3,    #FUN-BB0173 add
                      tm2.t1,tm2.t2,tm2.t3,tm2.u1,tm2.u2,tm2.u3,tm.more
                      WITHOUT DEFAULTS
 
     #NO.FUN-A10098 ---start---mark
     #   BEFORE FIELD azp01     # 工廠編號:
     #      IF g_apz.apz25='N' THEN
     #         LET tm.azp01=g_plant
     #         LET g_plant_new=tm.azp01
     #         LET g_dbs_new=''
     #         DISPLAY tm.azp01 TO FORMONLY.azp01
     #         NEXT FIELD a
     #      END IF
 
     #   AFTER FIELD azp01     # 工廠編號:
     #      IF cl_null(tm.azp01) THEN
     #         LET tm.azp01=g_plant
     #         LET g_plant_new=tm.azp01
     #         LET g_dbs_new=''
     #         DISPLAY tm.azp01 TO FORMONLY.azp01
     #         NEXT FIELD a
     #      END IF
     #      LET g_plant_new=tm.azp01
     #      IF tm.azp01 = g_plant THEN
     #         LET g_dbs_new=''
     #         CALL s_chk_demo(g_user,tm.azp01) RETURNING li_result
     #           IF not li_result THEN 
     #              NEXT FIELD azp01
     #           END IF 
     #      ELSE
     #          #檢查工廠並將新的資料庫放在g_dbs_new
     #         IF NOT s_chknplt(tm.azp01,'AAP','MFG') THEN
     #            CALL cl_err(g_plant_new,g_errno,0)
     #            NEXT FIELD azp01
     #         END IF
     #         CALL s_chk_demo(g_user,tm.azp01) RETURNING li_result                                                                 
     #           IF not li_result THEN                                                                                              
     #              NEXT FIELD azp01                                                                                                
     #           END IF                                                                                                             
     #      END IF
     #NO.FUN-A10098 ---end---mark

     #FUN-BB0173 add START
         BEFORE FIELD azp01     # 工廠編號:
            IF g_apz.apz25='N' THEN
               LET tm.azp01=g_plant
               LET g_plant_new=tm.azp01
               LET g_dbs_new=''
               DISPLAY tm.azp01 TO FORMONLY.azp01
               NEXT FIELD a
            END IF

         AFTER FIELD azp01     # 工廠編號:
            IF cl_null(tm.azp01) THEN
               LET tm.azp01=g_plant
               LET g_plant_new=tm.azp01
               LET g_dbs_new=''
               DISPLAY tm.azp01 TO FORMONLY.azp01
               NEXT FIELD a
            END IF
            LET g_plant_new=tm.azp01
            IF tm.azp01 = g_plant THEN
               LET g_dbs_new=''
               CALL s_chk_demo(g_user,tm.azp01) RETURNING li_result
                 IF not li_result THEN
                    NEXT FIELD azp01
                 END IF
            ELSE
                #檢查工廠並將新的資料庫放在g_dbs_new
               IF NOT s_chknplt(tm.azp01,'AAP','MFG') THEN
                  CALL cl_err(g_plant_new,g_errno,0)
                  NEXT FIELD azp01
               END IF
               CALL s_chk_demo(g_user,tm.azp01) RETURNING li_result
                 IF not li_result THEN
                    NEXT FIELD azp01
                 END IF
            END IF
     #FUN-BB0173 add END
 
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
            CALL cl_cmdask()    # Command execution
 
 
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
         CLOSE WINDOW aapr140_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aapr140'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aapr140','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                      # " '",tm.azp01 CLIPPED,"'",   #NO.FUN-A10098  mark
                       " '",tm.azp01 CLIPPED,"'",   #FUN-BB0173 add
                       " '",tm.a CLIPPED,"'",   #TQC-610053
                       " '",tm.b CLIPPED,"'",   #TQC-610053
                       " '",tm.v CLIPPED,"'",   #TQC-610053
                        " '",tm.s CLIPPED,"'",
                        " '",tm.t CLIPPED,"'",
                        " '",tm.u CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aapr140',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW aapr140_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL aapr140()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW aapr140_w
 
END FUNCTION
 
FUNCTION aapr140_wc()
   DEFINE l_wc STRING   #TQC-630166
 
   OPEN WINDOW aapr140_w2 AT 2,2
     WITH FORM "apm/42f/apmt100"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("apmt100")
   CALL cl_opmsg('q')
 
   CONSTRUCT BY NAME l_wc ON rva02,rva03,rva10,rva07,rva09,rvb05,rvb11,rvb12,
                             rvb08,rvb09,rvb07,rvb13,rvb14,rvb15,rvb16,
                             rvauser,rvagrup,rvamodu,rvadate
 
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
 
   CLOSE WINDOW aapr140_w2
 
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW aapr140_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
 
END FUNCTION
 
FUNCTION aapr140()
   DEFINE l_name    LIKE type_file.chr20,   #No.FUN-690028  VARCHAR(20),        # External(Disk) file name
          l_sql     STRING,      # RDSQL STATEMENT   #TQC-630166
          l_rvv23   LIKE rvv_file.rvv23,    #No.FUN-750097
          l_chr     LIKE type_file.chr1,    #No.FUN-690028  VARCHAR(1),
          l_order    ARRAY[5] OF  LIKE rvv_file.rvv01,  #No.FUN-690028 VARCHAR(16),         #No.FUN-540057
          sr               RECORD order1 LIKE rvv_file.rvv01,  #No.FUN-690028 VARCHAR(25),          #TQC-5B0120
                                  order2 LIKE rvv_file.rvv01,  #No.FUN-690028 VARCHAR(25),          #TQC-5B0120
                                  order3 LIKE rvv_file.rvv01,  #No.FUN-690028 VARCHAR(25),          #TQC-5B0120
                                  rvv06 LIKE rvv_file.rvv06,    # 廠商
                                  pmc03 LIKE pmc_file.pmc03,    # 簡稱
                                  rvv09 LIKE rvv_file.rvv09,    # 日期
                                  rvv01 LIKE rvv_file.rvv01,    # 入庫單號
                                  rvv02 LIKE rvv_file.rvv02,    #
                                  rvv03 LIKE rvv_file.rvv03,    #
                                  pmm02 LIKE pmm_file.pmm02,    #
                                  pmm20 LIKE pmm_file.pmm20,    #
                                  pmm22 LIKE pmm_file.pmm22,    #
                                  rvb05 LIKE rvb_file.rvb05,
                                  rvv38 LIKE rvv_file.rvv38,    # 採購單價
                                  rvv87 LIKE rvv_file.rvv87,    # 數量   #FUN-560089
                                  rvv88 LIKE rvv_file.rvv88,    # #No.TQC-7B0083
                                  rvv87_23 LIKE rvv_file.rvv87, # 未匹配數量   #FUN-560089
                                  amt   LIKE rvv_file.rvv39,    # 未匹配金額
                                  rvb22 LIKE rvb_file.rvb22,    # 發票
                                  rvb03 LIKE rvb_file.rvb03,    # 採購項次
                                  rvb04 LIKE rvb_file.rvb04,    # 採購單號
                                  azi03 LIKE azi_file.azi03,
                                  azi04 LIKE azi_file.azi04,
                                  azi05 LIKE azi_file.azi05,
                                  ima02 LIKE ima_file.ima02,   
                                  ima021 LIKE ima_file.ima021,
                                  rvv01a LIKE type_file.chr21,   #No.FUN-690028 VARCHAR(21),              #No.FUN-550030
                                  rvb04a LIKE type_file.chr21,   #No.FUN-690028 VARCHAR(21),              #No.FUN-550030
                                  rvv03a LIKE zaa_file.zaa08,   #No.FUN-690028 VARCHAR(8)
                                  rvu00  LIKE rvu_file.rvu00,    #MOD-7B0083
                                  rvv39  LIKE rvv_file.rvv39,    #MOD-7B0083
                                  rvu08  LIKE rvu_file.rvu08     #FUN-C30202 add rvu08
                        END RECORD
 
     DEFINE l_cnt LIKE type_file.num5   #MOD-7B0083
     DEFINE l_azw01 LIKE azw_file.azw01  #FUN-A60056 
     DEFINE l_azw02 LIKE azw_file.azw02  #FUN-BB0173 add
     CALL cl_del_data(l_table)                                                                                                      
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                       
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 

   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('rvuuser', 'rvugrup')
   #FUN-BB0173 add START
   SELECT azw02 INTO l_azw02 FROM azw_file WHERE azw01 = tm.azp01

   #FUN-BB0173 add END 
   #FUN-A60056--add--str-- 
   LET l_sql = "SELECT azw01 FROM azw_file",
               " WHERE azwacti = 'Y'",
              #"   AND azw02 = '",g_legal,"'"  #FUN-BB0173 mark
               "   AND azw02 = '",l_azw02,"'"  #FUN-BB0173 add 
   PREPARE sel_azw01 FROM l_sql
   DECLARE sel_azw CURSOR FOR sel_azw01
   FOREACH sel_azw INTO l_azw01
   #FUN-A60056--add--end
      LET l_sql = "SELECT '','','',",                                                                                 
                  "    rvv06,'',rvv09,rvv01,rvv02,rvv03,'','','',",                                                                    
                  "    rvv31,rvv38,rvv87,rvv88,rvv87-rvv23,rvv38*(rvv87-rvv23),", #No.TQC-7B0083
                  "    rvb22,rvb03,rvb04,'','','','','','','','',rvu00,rvv39,rvu08",   #MOD-7B0083 #FUN-C30202 add rvu08                                                                  
                 #NO.FUN-A10098 ----start----
                 #"  FROM ",g_dbs_new CLIPPED,"rvu_file A LEFT OUTER JOIN ",  #MOD-970036 mod
                 #"             ",g_dbs_new CLIPPED,"rva_file D ON(rvu02 = rva01 AND rvaconf!='X'),",   #MOD-970036 mod #No.TQC-690032 add
                 #"       ",g_dbs_new CLIPPED,"rvv_file B LEFT OUTER JOIN ",  #MOD-970036 mod
                 #"             ",g_dbs_new CLIPPED,"rvb_file C ON(rvv04 = rvb01 AND rvv05 = rvb02) ",  #MOD-970036 mod #No.TQC-690032 add                       
                 #"  LEFT OUTER JOIN ",g_dbs_new CLIPPED," pmm_file E ON(rvv36 = pmm01)",   #MOD-970036 mod #No.MOD-8A0234
                #FUN-A60056--mod--str--
                # "  FROM rvu_file A LEFT OUTER JOIN rva_file D ON(rvu02 = rva01 AND rvaconf!='X'),",
                # "       ","rvv_file B LEFT OUTER JOIN rvb_file C ON(rvv04 = rvb01 AND rvv05 = rvb02)",
                # "  LEFT OUTER JOIN pmm_file E ON(rvv36 = pmm01)",
                ##NO.FUN-A10098  ----end---- 
                  "  FROM ",cl_get_target_table(l_azw01,'rvu_file')," A LEFT OUTER JOIN ",
                  "       ",cl_get_target_table(l_azw01,'rva_file')," D ON(rvu02 = rva01 AND rvaconf!='X'),",
                  "       ",cl_get_target_table(l_azw01,'rvv_file')," B LEFT OUTER JOIN ",
                  "       ",cl_get_target_table(l_azw01,'rvb_file')," C ON(rvv04 = rvb01 AND rvv05 = rvb02)",
                  "  LEFT OUTER JOIN ",cl_get_target_table(l_azw01,'pmm_file ')," E ON(rvv36 = pmm01)",
                #FUN-A60056--mod--end
                  " WHERE ",tm.wc CLIPPED,
                  "   AND A.rvu01 = B.rvv01 AND A.rvuconf='Y' ",  #MOD-970036 mod   
                  "   AND B.rvv03!='2' ",  #MOD-970036 mod
                  "   AND B.rvv89!='Y' "   #MOD-B50185
    
      CASE WHEN tm.v = '1'
              LET l_sql = l_sql CLIPPED," AND ((B.rvv87 > B.rvv23+B.rvv88) OR ",    #MOD-7B0083  #No.TQC-7B0083  #MOD-970036 mod
                          " (A.rvu00='3' AND B.rvv87=0))"   #MOD-7B0083  #MOD-970036 mod
           WHEN tm.v = '2'
              LET l_sql = l_sql CLIPPED," AND ((B.rvv87 = B.rvv23+B.rvv88) OR ",   #MOD-7B0083  #No.TQC-7B0083  #MOD-970036 mod
                          " (A.rvu00='3' AND B.rvv87=0))"   #MOD-7B0083  #MOD-970036 mod
      END CASE
 
      IF tm.b = 'N' THEN
         LET l_sql = l_sql CLIPPED," AND NOT (B.rvv38 IS NULL OR B.rvv38=0)"  #MOD-970036 mod
      END IF
 
      #-->樣品是否列印
      IF tm.a = 'N' THEN
         LET l_sql = l_sql CLIPPED, " AND B.rvv25 = 'N' "  #MOD-970036 mod
      END IF
    	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      CALL cl_parse_qry_sql(l_sql,l_azw01) RETURNING l_sql   #FUN-A60056
      CALL cl_replace_str(l_sql,"rvu_file.rvuplant","A.rvuplant") RETURNING l_sql  #FUN-A60056
      CALL cl_replace_str(l_sql,"rva_file.rvaplant","D.rvaplant") RETURNING l_sql  #FUN-A60056
      CALL cl_replace_str(l_sql,"rvv_file.rvvplant","B.rvvplant") RETURNING l_sql  #FUN-A60056
      CALL cl_replace_str(l_sql,"rvb_file.rvbplant","C.rvbplant") RETURNING l_sql  #FUN-A60056
      CALL cl_replace_str(l_sql,"pmm_file.pmmplant","E.pmmplant") RETURNING l_sql  #FUN-A60056
      PREPARE aapr140_prepare1 FROM l_sql
      IF STATUS != 0 THEN
         CALL cl_err('prepare:',STATUS,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
      DECLARE aapr140_curs1 CURSOR FOR aapr140_prepare1
 
 
      LET g_pageno = 0
      DISPLAY "aarp140_curs1---------------------------------------------",TIME
      FOREACH aapr140_curs1 INTO sr.*
         IF STATUS != 0 THEN
            CALL cl_err('foreach:',STATUS,1)
            EXIT FOREACH
         END IF
         IF sr.rvu00 = '3' AND sr.rvv87=0 THEN
            LET l_cnt = 0 
            SELECT COUNT(*) INTO l_cnt FROM apb_file
               WHERE apb21 = sr.rvv01  
            IF tm.v = '1' AND l_cnt > 0 THEN 
               CONTINUE FOREACH
            END IF
            IF tm.v = '2' AND l_cnt = 0 THEN
               CONTINUE FOREACH
            END IF
         END IF
        #若為大陸版時,倉退單無須對應收貨單發票,
        #應抓取此倉退單+項次(rvw08+rvw09)對應的rvw01發票號碼
         IF g_aza.aza26='2' THEN
            SELECT rvw01 INTO sr.rvb22 FROM rvw_file
             WHERE rvw08=sr.rvv01
               AND rvw09=sr.rvv02
            IF SQLCA.SQLCODE THEN LET sr.rvb22 = ' ' END IF
     #FUN-BB0002 add START
         ELSE
            IF cl_null(sr.rvb22) THEN
               SELECT rvv22 INTO sr.rvb22 FROM rvv_file
                 WHERE rvv01 = sr.rvv01
                   AND rvv02 = sr.rvv02
            END IF
     #FUN-BB0002 add END
         END IF
        #-CHI-B30019-add-
         IF cl_null(sr.rvb22) THEN
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt
              FROM apa_file,apb_file
             WHERE apa01 = apb01 
               AND apa42 = 'N'
               AND apb21 = sr.rvv01
               AND apb22 = sr.rvv02
            IF l_cnt = 1 THEN
              #入庫單對應單筆帳款
               SELECT apa08 INTO sr.rvb22 
                 FROM apa_file,apb_file
                WHERE apa01 = apb01 
                  AND apa42 = 'N'
                  AND apb21 = sr.rvv01
                  AND apb22 = sr.rvv02
            END IF
           #入庫單對應多筆帳款
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt 
              FROM apa_file
             WHERE apa42 = 'N'
               AND apa01 IN (SELECT apa01 FROM apa_file,apb_file 
                              WHERE apa01 = apb01 AND apa42 = 'N' 
                                AND apb21 = sr.rvv01 AND apb22 = sr.rvv02)
            IF l_cnt > 1 THEN
               LET sr.rvb22 = 'MISC'
            END IF
         END IF
        #-CHI-B30019-end-
         LET sr.ima021 = ''   #MOD-7A0062
         SELECT ima021 INTO sr.ima021   #MOD-7A0062
           FROM ima_file
          WHERE ima01 = sr.rvb05
 
         LET sr.ima02 = ''   
        #FUN-A60056--mod--str--
        #SELECT pmn041 INTO sr.ima02 FROM pmn_file 
        #  WHERE pmn01 = sr.rvb04 AND pmn02 = sr.rvb03
         LET l_sql = "SELECT pmn041 FROM ",cl_get_target_table(l_azw01,'pmn_file'),
                     " WHERE pmn01 = '",sr.rvb04,"'",
                     "   AND pmn02 = '",sr.rvb03,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_azw01) RETURNING l_sql
         PREPARE sel_pmn041_cs FROM l_sql
         EXECUTE sel_pmn041_cs INTO sr.ima02
        #FUN-A60056--mod--end
 
         SELECT pmc03 INTO sr.pmc03 FROM pmc_file                                                                                      
          WHERE pmc01 = sr.rvv06                                                                                                       
                                                                                                                                    
        #FUN-A60056--mod--str--
        #SELECT pmm02,pmm20,pmm22 INTO sr.pmm02,sr.pmm20,sr.pmm22                                                                      
        #  FROM pmm_file                                                                                                               
        # WHERE pmm01 = sr.rvb04                                                                                                       
         LET l_sql = "SELECT pmm02,pmm20,pmm22 ",
                     "  FROM ",cl_get_target_table(l_azw01,'pmm_file'),
                     " WHERE pmm01 = '",sr.rvb04,"'" 
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_azw01) RETURNING l_sql
         PREPARE sel_pmm02_cs FROM l_sql
         EXECUTE sel_pmm02_cs INTO sr.pmm02,sr.pmm20,sr.pmm22
        #FUN-A60056--mod--end
                                                                                                                                    
         IF NOT cl_null(sr.pmm22) THEN                                                                                                 
            SELECT azi03,azi04,azi05 INTO sr.azi03,sr.azi04,sr.azi05                                                                   
              FROM azi_file                                                                                                            
             WHERE azi01=sr.pmm22                                                                                                      
         END IF                                                                                                                        
 
         IF cl_null(sr.azi03) THEN
           #FUN-A60056--mod--str--
           #SELECT azi03 INTO sr.azi03 FROM azi_file
           #  WHERE azi01 = (SELECT pmc22 FROM pmc_file 
           #                 WHERE pmc01=(SELECT rvu04 FROM rvu_file
           #                              WHERE rvu01=sr.rvv01))
            LET l_sql = "SELECT azi03 FROM ",cl_get_target_table(l_azw01,'azi_file'),
                        " WHERE azi01 = (SELECT pmc22 FROM ",cl_get_target_table(l_azw01,'pmc_file'),
                        "                 WHERE pmc01=(SELECT rvu04 FROM ",
                                                       cl_get_target_table(l_azw01,'rvu_file'),
                        "                               WHERE rvu01='",sr.rvv01,"'))"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,l_azw01) RETURNING l_sql 
            PREPARE sel_azi03 FROM l_sql
            EXECUTE sel_azi03 INTO sr.azi03
           #FUN-A60056--mod--end
         END IF 
         IF cl_null(sr.azi04) THEN
           #FUN-A60056--mod--str--
           #SELECT azi05 INTO sr.azi04 FROM azi_file
           #  WHERE azi01 = (SELECT pmc22 FROM pmc_file 
           #                 WHERE pmc01=(SELECT rvu04 FROM rvu_file
           #                              WHERE rvu01=sr.rvv01))
           LET l_sql ="SELECT azi05 FROM ",cl_get_target_table(l_azw01,'azi_file'),
                      " WHERE azi01 = (SELECT pmc22 FROM ",cl_get_target_table(l_azw01,'pmc_file'), 
                      "                WHERE pmc01=(SELECT rvu04 FROM ",cl_get_target_table(l_azw01,'rvu_file'),
                      "                              WHERE rvu01='",sr.rvv01,"'))" 
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql
           CALL cl_parse_qry_sql(l_sql,l_azw01) RETURNING l_sql
           PREPARE sel_azi05_cs FROM l_sql
           EXECUTE sel_azi05_cs INTO sr.azi04
           #FUN-A60056--mod--end
         END IF 
    
         IF cl_null(sr.azi05) THEN
           #FUN-A60056--mod--str--
           #SELECT azi05 INTO sr.azi05 FROM azi_file
           #  WHERE azi01 = (SELECT pmc22 FROM pmc_file 
           #                 WHERE pmc01=(SELECT rvu04 FROM rvu_file
           #                              WHERE rvu01=sr.rvv01))
            LET l_sql = "SELECT azi05 FROM ",cl_get_target_table(l_azw01,'azi_file'),
                        " WHERE azi01 = (SELECT pmc22 FROM ",cl_get_target_table(l_azw01,'pmc_file'),
                        "                 WHERE pmc01=(SELECT rvu04 FROM ",cl_get_target_table(l_azw01,'rvu_file'),
                        "                               WHERE rvu01='",sr.rvv01,"'))" 
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,l_azw01) RETURNING l_sql
            PREPARE sel_azi05 FROM l_sql
            EXECUTE sel_azi05 INTO sr.azi05
           #FUN-A60056--mod--end
         END IF 
         LET l_rvv23 = sr.rvv87 - sr.rvv87_23
         IF sr.azi03 IS NULL THEN LET sr.azi03 = g_azi03 END IF
         IF sr.azi04 IS NULL THEN LET sr.azi04 = g_azi04 END IF
         IF sr.azi05 IS NULL THEN LET sr.azi05 = g_azi05 END IF   

         IF sr.azi03 IS NULL THEN LET sr.azi03 = 0 END IF
         IF sr.azi04 IS NULL THEN LET sr.azi04 = 0 END IF
         IF sr.azi05 IS NULL THEN LET sr.azi05 = 0 END IF   #MOD-7B0083

 
         LET sr.amt = cl_digcut(sr.amt,sr.azi04)        #No.8855
         EXECUTE insert_prep USING
                   sr.rvv01,sr.rvv02,sr.rvv03,sr.rvv06,sr.rvv09,l_rvv23,sr.rvv88,sr.rvb05,  #No.TQC-7B0083
                   sr.rvv38,sr.rvv87,sr.rvb03,sr.rvb04,sr.rvb22,sr.ima02,sr.ima021,  
                   #sr.pmc03,sr.pmm20,sr.pmm22,sr.azi03,sr.azi04,sr.azi05   #MOD-7B0083
                   sr.pmc03,sr.pmm20,sr.pmm22,sr.azi03,sr.azi04,sr.azi05,sr.rvv39,sr.rvu08   #MOD-7B0083 #FUN-C30202 add sr.rvu08
      END FOREACH
      DISPLAY "aarp140_curs1END***************************************************",TIME
    END FOREACH   #FUN-A60056 
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                               
    LET g_str = ''
      #是否列印選擇條件                                                                                                              
     IF g_zz05 = 'Y' THEN                                                                                                           
        CALL cl_wcchp(tm.wc,'rvv01,rvv02,rvv06,rvv09,rvb22,rvv03,pmm22,rvb04,rva04')       #TQC-CC0110-add--
             RETURNING tm.wc                                                                                                        
       LET g_str = tm.wc                                                                                                           
     END IF                                                                                                                         
     LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t,";",tm.u,";",tm.v    #MOD-7B0083
     CALL cl_prt_cs3('aapr140','aapr140',l_sql,g_str)                                                                                 
 
 
END FUNCTION

#FUN-BB0173 add START
#流通業將營運中心隱藏
FUNCTION r140_set_entry()
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_azw05  LIKE azw_file.azw05

  SELECT azw05 INTO l_azw05 FROM azw_file WHERE azw01 = g_plant
  SELECT count(*) INTO l_cnt FROM azw_file
   WHERE azw05 = l_azw05

  IF l_cnt > 1 THEN
     CALL cl_set_comp_visible("azp01",FALSE)
     LET g_flag = 'Y'  #流通
     LET tm.azp01 = g_plant      #流通業則將array存入 g_plant
  END IF
END FUNCTION
#FUN-BB0173 add END 
#No.FUN-9C0077 程式精簡
