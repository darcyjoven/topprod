# Prog. Version..: '5.30.06-13.04.02(00010)'     #
#
# Pattern name...: afap130.4gl
# Descriptions...: 資產出售應收帳款產生作業
# Date & Author..: 97/10/06 By Sophia
# Date & Modify..: 03/07/16 By Wiky #No:7160 begin_no /g_end 為空白,未秀出單號
#                : 加g_firstno_ck 來抓begin_no資料
# Modify.........: No.MOD-4A0297 04/11/11 By Nicola AR立帳日需與出售日為同一月份資料
# Modify.........: No.MOD-530824 05/05/04 By Smapmin 有ERROR訊息仍出現拋轉成功訊
# Modify.........: NO.FUN-550034 05/05/17 By jackie 單據編號加大
# Modify.........: NO.FUN-560002 05/06/06 By jackie 單據編號修改
# Modify.........: NO.FUN-560146 05/06/20 By Nicola 自動取得單據號碼時，傳入參數錯誤
# Modify.........: No.MOD-590230 05/09/29 By Smapmin 含稅出售金額計算
# Modify.........: No.FUN-5A0124 05/10/20 By elva insert帳款資料時新增oma65
# Modify.........: No.FUN-570144 06/03/02 By yiting 批次作業背景執行
# Modify.........: NO.FUN-630015 06/05/24 BY yiting s_rdate2改call s_rdatem.4gl 多工廠
# Modify.........: No.FUN-5C0015 06/05/30 By rainy 新增欄位oma67存放Invoice No.
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680006 06/08/02 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-680022 06/08/30 By Tracy s_rdatem()增加一個參數 
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690012 06/10/16 By rainy omb33<--oba11
# Modify.........: No.CHI-6A0004 06/10/27 By Jackho 本（原）幣取位修改
# Modify.........: No.FUN-6A0069 06/10/30 By yjkhero l_time轉g_time 
# Modify.........: No.TQC-680074 06/12/27 By Smapmin 為因應s_rdatem.4gl程式內對於dbname的處理,故LET g_dbs2=g_dbs,'.'
# Modify.........: No.FUN-710028 07/01/16 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.MOD-720105 07/02/14 By Smapmin 參考單號已存在應收,不可再產生!-->應排除應收單據作廢者
# Modify.........: No.TQC-750246 07/05/30 By rainy 立AR收款客戶,名稱 未寫入,沖帳資料未寫入 oma51f,oma51!"
# Modify.........: No.MOD-7B0082 07/11/08 By Smapmin 匯率應該以原出售單匯率為主
# Modify.........: No.TQC-7B0056 07/11/12 By Rayven 產生的雜項應收中，如果“收款條件”沒有用多帳款，但在插入資料時，也應該插入一筆多帳期資料，現在沒有插入
# Modify.........: No.TQC-7B0060 07/11/13 By Rayven 不選取“科目分類碼”。產生的axrt300的單頭“會計科目”直接賦為出售作業分錄底稿里的值為出售含稅金額的那個科目。“會計科目二”亦是如此。這樣方便在收款衝款時，直接把科目對衝掉
# Modify.........: No.TQC-7B0146 07/11/27 By chenl  未對oma64賦值
# Modify.........: No.FUN-840127 08/04/25 By bnlent CALL此程序時自動帶出出售單號
# Modify.........: No.MOD-870228 08/07/22 By Sarah 拋轉後執行成功/失敗的訊息只需提示一次
# Modify.........: No.FUN-920166 09/02/20 By alex g_dbs2改為使用s_dbstring
# Modify.........: No.MOD-940330 09/04/24 By chenl 科目類型欄位調整為必輸欄位。
# Modify.........: No.FUN-910117 09/05/12 By jan 程式中用到feb03,fbe04的原本在簡稱都是抓取occ02 ，改以fbe031,fbe041取代
# Modify.........: No.FUN-980003 09/08/13 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980020 09/09/01 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-A60056 10/07/06 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No:MOD-A20116 10/10/05 By sabrina oma171的值應抓取gec08
# Modify.........: No:CHI-AB0015 10/11/19 By Summer 使用 ooy10 做法
# Modify.........: No:FUN-AB0034 10/12/16 By wujie   oma73/oma73f预设0
# Modify.........: No:MOD-B30290 11/03/17 By huangrh oma70预设2
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No:MOD-B40047 11/04/12 By Dido 開窗單別應為非拋轉傳票單別;確認碼預設為 'Y' 
# Modify.........: No:MOD-B70056 11/07/07 By JoHung oma175給預設值
# Modify.........: No:MOD-B70158 11/07/15 By Polly  oma172的值應抓取gec06
# Modify.........: No:MOD-BC0013 11/12/10 By johung 計算omb14/omb14t未作取位
# Modify.........: No:FUN-BB0083 11/12/19 By xujing 增加數量欄位小數取位
# Modify.........: No:MOD-C10024 12/01/04 By wujie faa='Y'时，oma18改取fbz18  
# Modify.........: No:MOD-BC0308 11/12/30 By Carrier omc13 赋值
# Modify.........: No:MOD-C30647 12/03/13 By wangrr 設置oma64='1'
# Modify.........: No:MOD-C50206 12/05/25 By suncx faa29='Y'時，應收單別應選擇拋轉憑證的單別
# Modify.........: No:MOD-C60007 12/06/01 By suncx 確認碼預設為'N'
# Modify.........: No:TQC-C60115 12/06/13 By lujh 運行成功后  彈出'運行成功，是否繼續'對話框，點是，下面顯示'更新異動不成功'
# Modify.........: No:TQC-C60113 12/06/13 By lujh 國萍建議，afat100拋轉應收最好是未審核狀態，這樣oma64應該為0，這樣做便于做直接收款
# Modify.........: No:TQC-C60117 12/06/13 By lujh “出售單號”欄位應提供開窗方便輸入執行產生賬款。
# Modify.........: No:MOD-C60196 12/06/27 By Vampire CALL s_rdatem的第二個參數l_omc03調整為l_omc.omc03
# Modify.........: No:MOD-D10112 13/01/09 By suncx 生成賬款時科目抓取錯誤
# Modify.........: No.FUN-D10101 13/01/22 By lujh axrt300單身新增已開票數量欄位，賦默認值0

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc,g_sql       STRING                  #No.FUN-580092 HCN
DEFINE g_date           LIKE type_file.dat      # 應收立帳日                    #No.FUN-680070 DATE
DEFINE g_no             LIKE type_file.chr5     # 單別                          #No.FUN-680070 VARCHAR(5)
DEFINE g_type           LIKE oma_file.oma13     #科目分類碼
DEFINE g_date2          LIKE type_file.dat      #開立發票日期                   #No.FUN-680070 DATE
DEFINE g_fbe            RECORD LIKE fbe_file.*
DEFINE g_fbf            RECORD LIKE fbf_file.*
DEFINE g_faj            RECORD LIKE faj_file.*
DEFINE g_oma            RECORD LIKE oma_file.*
DEFINE g_omb            RECORD LIKE omb_file.*
DEFINE begin_no         LIKE type_file.chr20    #No.FUN-550034                  #No.FUN-680070 VARCHAR(16)
DEFINE g_firstno_ck     LIKE type_file.chr1     #No.FUN-680070 VARCHAR(01)
DEFINE g_argv           LIKE fbe_file.fbe01     #No.FUN-550034                  #No.FUN-680070 VARCHAR(16)
DEFINE g_start,g_end    LIKE type_file.chr20    #No.FUN-550034                  #No.FUN-680070 VARCHAR(16)
DEFINE g_cnt            LIKE type_file.num10    #No.FUN-680070 INTEGER
DEFINE g_i              LIKE type_file.num5     #count/index for any purpose    #No.FUN-680070 SMALLINT
DEFINE g_msg            LIKE type_file.chr1000  #No.FUN-680070 VARCHAR(72)
DEFINE l_flag           LIKE type_file.chr1,    #No.FUN-570144                  #No.FUN-680070 VARCHAR(1)
       g_change_lang    LIKE type_file.chr1,    #No.FUN-570144 是否有做語言切換 #No.FUN-680070 VARCHAR(01)
       ls_date          STRING                  #No.FUN-570144
DEFINE g_dbs2           LIKE type_file.chr30    #TQC-680074
DEFINE g_wc1            STRING                  #No.FUN-840127 
DEFINE g_plant2         LIKE type_file.chr10    #FUN-980020

MAIN
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_argv = ARG_VAL(1)
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc   = ARG_VAL(2)
   LET g_wc1  = ARG_VAL(2)     #No.FUN-840127
   LET g_no   = ARG_VAL(3)
   LET ls_date = ARG_VAL(4)
   LET g_date  = cl_batch_bg_date_convert(ls_date)
   LET g_type = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(6)
 
   IF cl_null(g_bgjob) THEN
      LET g_bgjob= "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
#NO.FUN-570144 START--
#   LET g_argv = ARG_VAL(1)
 
#   OPEN WINDOW p130_w WITH FORM "afa/42f/afap130"
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
#    CALL cl_ui_init()
#NO.FUN-570144 END--
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #NO.FUN-6A0069
 
#NO.FUN-570144 START--
#   CALL p130()
#   CLOSE WINDOW p130_w
 
   LET g_plant2 = g_plant                    #FUN-980020
   LET g_dbs2 = s_dbstring(g_dbs CLIPPED)    #FUN-920166
#  #-----TQC-680074--------- 
#  IF cl_db_get_database_type() = 'IFX' THEN
#     LET g_dbs2 = g_dbs CLIPPED,':'
#  ELSE
#     LET g_dbs2 = g_dbs CLIPPED,'.'
#  END IF
#  #-----END TQC-680074-----
 
   LET g_success = 'Y'
   WHILE TRUE
     IF g_bgjob = "N" THEN
        IF cl_null(g_argv) THEN
           CALL p130()
        ELSE
           LET g_wc = " fbe01='",g_argv,"'"
        END IF
        IF cl_sure(18,20) THEN
           LET g_success = 'Y'
           BEGIN WORK
           CALL p130_process()
           #若無傳入值時
           CALL s_showmsg()   #No.FUN-710028

           #TQC-C60115--mark--str--
           #IF g_success = 'Y' AND cl_null(g_argv) THEN
           #   COMMIT WORK
           #   CALL cl_end2(1) RETURNING l_flag
           #ELSE
           #   ROLLBACK WORK
           #   CALL cl_end2(2) RETURNING l_flag
           #END IF
           #若有傳入值時
           #IF g_success = 'Y' AND NOT cl_null(g_argv) THEN
           #   CALL cl_cmmsg(1) COMMIT WORK
           #ELSE
           #   CALL cl_rbmsg(1) ROLLBACK WORK
           #END IF
           #TQC-C60115--mark--end--

           #TQC-C60115--add--str--
           IF g_success = 'Y' THEN
              COMMIT WORK
              CALL cl_end2(1) RETURNING l_flag
           ELSE
              ROLLBACK WORK
              CALL cl_end2(2) RETURNING l_flag
           END IF 
           #TQC-C60115--add--end--

           IF l_flag THEN
              CONTINUE WHILE
           ELSE
              CLOSE WINDOW p130_w
              EXIT WHILE
           END IF
        ELSE
           CONTINUE WHILE
        END IF
     ELSE
        LET g_success = 'Y'
        BEGIN WORK
        CALL p130_process()
        CALL s_showmsg()   #No.FUN-710028
        IF g_success = "Y" THEN
           CALL cl_cmmsg(1)  #TQC-C60115  add
           COMMIT WORK
        ELSE
           CALL cl_rbmsg(1)  #TQC-C60115  add
           ROLLBACK WORK
        END IF
        CALL cl_batch_bg_javamail(g_success)
        EXIT WHILE
     END IF
   END WHILE
#->No.FUN-570144 ---end---
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818   #NO.FUN-6A0069
END MAIN
 
FUNCTION p130()
DEFINE   l_order   ARRAY[4] OF LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(10)
         l_fbe01   LIKE fbe_file.fbe01,
         l_fbe02   LIKE fbe_file.fbe02,         #No.MOD-4A0297
         l_flag    LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
         sr RECORD
            order1 LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(10)
            order2 LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(10)
            oga01  LIKE oga_file.oga01,
            oga011 LIKE oga_file.oga011,
            oga03  LIKE oga_file.oga03,
            oga05  LIKE oga_file.oga05,
            oga21  LIKE oga_file.oga21,
            oga15  LIKE oga_file.oga15,
            oga14  LIKE oga_file.oga14,
            oga23  LIKE oga_file.oga23,
            oga02  LIKE oga_file.oga02,
            oga11  LIKE oga_file.oga11
            END RECORD
DEFINE li_result   LIKE type_file.num5          #No.FUN-560002       #No.FUN-680070 SMALLINT
DEFINE lc_cmd      LIKE type_file.chr1000       #No.FUN-570144       #No.FUN-680070 VARCHAR(500)
DEFINE l_str       STRING                       #No.FUN-840127
 
#->No.FUN-570144 --start--
   OPEN WINDOW p130_w WITH FORM "afa/42f/afap130"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()
#->No.FUN-570144 ---end---
 
   CLEAR FORM
   CALL cl_opmsg('w')
#   IF cl_null(g_argv) THEN  #NO.FUN-570144
      WHILE TRUE
         #No.FUN-840127 ...begin
         LET l_str =NULL 
         IF NOT cl_null(g_wc1) THEN
            LET l_str = g_wc1 CLIPPED
         END IF
         #No.FUN-840127 ...end
         CONSTRUCT BY NAME g_wc ON fbe01,fbe02,fbe03
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             DISPLAY l_str TO fbe01   #No.FUN-840127
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
#        CALL cl_dynamic_locale()
       # CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #LET g_action_choice = "locale"
          LET g_change_lang = TRUE        #->No.FUN-570144
          EXIT CONSTRUCT

      #TQC-C60117--add--str--
      ON ACTION CONTROLP
         CASE 
            WHEN INFIELD(fbe01)
            CALL cl_init_qry_var()
            LET g_qryparam.state = "c"
            LET g_qryparam.form ="q_fbe01"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO fbe01
            NEXT FIELD fbe01
         END CASE
      #TQC-C60117--add--str--  

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
       END CONSTRUCT
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fbeuser', 'fbegrup') #FUN-980030
 
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          CONTINUE WHILE
       END IF
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          CLOSE WINDOW p130_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
          EXIT PROGRAM
       END IF
 
#NO.FUN-570144 MARK--
#         IF INT_FLAG THEN
#            RETURN
#         END IF
#         IF g_wc = ' 1=1' THEN
#            CALL cl_err('','9046',0) CONTINUE WHILE
#         ELSE
#            EXIT WHILE
#         END IF
#      END WHILE
#   ELSE
#      LET g_wc = " fbe01='",g_argv,"'"
#   END IF
#NO.FUN-570144 MARK---
 
   #03/07/16 By Wiky No:7160 加g_firstno_ck來抓begin_no
   LET g_firstno_ck='Y'
   LET g_date=g_today
   LET g_date2=NULL
   CALL cl_opmsg('a')
 
   LET g_bgjob = "N"  #NO.FUN-570144 
   INPUT BY NAME g_no,g_date,g_type,g_bgjob WITHOUT DEFAULTS   #NO.FUN-570144
   #INPUT BY NAME g_no,g_date,g_type WITHOUT DEFAULTS
     #No.MOD-940330--begin--
      BEFORE INPUT
         CALL cl_set_comp_required("g_type",TRUE)
     #No.MOD-940330---end--- 
 
      AFTER FIELD g_no
         IF cl_null(g_no) THEN
            NEXT FIELD g_no
         END IF
 #No.FUN-560002 --start--
         CALL s_check_no("axr",g_no,"","14","","","")
           RETURNING li_result,g_no
         IF (NOT li_result) THEN
            CALL cl_err(g_no,g_errno,0)
            NEXT FIELD g_no
         END IF
#         CALL s_axrslip(g_no,'14','AXR')        #檢查單別NO:6842
#         IF NOT cl_null(g_errno) THEN              #抱歉, 有問題
#            CALL cl_err(g_no,g_errno,0)
#            NEXT FIELD g_no
#         END IF
#No.FUN-560002 ---end--
        #MOD-C50206 mark begin----------------
        ##-MOD-B40047-add-
        # IF g_ooy.ooydmy1 = 'Y' THEN
        #    CALL cl_err3("sel","ooy_file",g_no,"",'anm-701',"","select ooy:",0) 
        #    NEXT FIELD g_no
        # END IF
        ##-MOD-B40047-end-
        #MOD-C50206 mark end------------------
 
      AFTER FIELD g_date
         IF g_date IS NULL THEN
            NEXT FIELD g_date
         END IF
 
      #no.4218 add依劃面指定科目代碼
      AFTER FIELD g_type
         IF NOT cl_null(g_type) THEN
            SELECT * FROM ool_file WHERE ool01 = g_type
            IF STATUS THEN
#              CALL cl_err('select ool:',STATUS,0)   #No.FUN-660136
               CALL cl_err3("sel","ool_file",g_type,"",STATUS,"","select ool:",0)   #No.FUN-660136
               NEXT FIELD g_type
            END IF
         END IF
        #no.4218(end)
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         call cl_cmdask()
 
      ON ACTION CONTROLP
            CASE 
                 WHEN INFIELD(g_no) # Class
#                     CALL q_ooy(05,11,g_no,'14','AXR') RETURNING g_no  #NO:6842
                     #CALL q_ooy(FALSE,TRUE,g_no,'14','AXR') RETURNING g_no  #MOD-B40047 mark
                     #-MOD-B40047-add-
                      CALL cl_init_qry_var()
                     #LET g_qryparam.form = 'q_ooy1'  #MOD-C50206 mark
                     #MOD-C50206 add begin---------------
                      IF g_faa.faa29 ='Y' THEN 
                         LET g_qryparam.form = 'q_ooy5'
                      ELSE
                         LET g_qryparam.form = 'q_ooy1'
                      END IF
                     #MOD-C50206 add end-----------------
                      LET g_qryparam.default1 = g_no
                      CALL cl_create_qry() RETURNING g_no
                     #-MOD-B40047-end-
#                      CALL FGL_DIALOG_SETBUFFER( g_no )
                      DISPLAY BY NAME g_no
                 WHEN INFIELD(g_type)
#                     CALL q_ool(05,11,g_type) RETURNING g_type
#                     CALL FGL_DIALOG_SETBUFFER( g_type )
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = 'q_ool'
                      LET g_qryparam.default1 = g_type
                      CALL cl_create_qry() RETURNING g_type
#                      CALL FGL_DIALOG_SETBUFFER( g_type )
                      DISPLAY BY NAME g_type
                      NEXT FIELD g_type
            END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
      ON ACTION exit                            #加離開功能
         LET INT_FLAG = 1
         EXIT INPUT
 
      #No.FUN-580031 --start--
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
 
   END INPUT
#NO.FUN-570144 START---
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
          LET INT_FLAG = 0
          CLOSE WINDOW p130_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
          EXIT PROGRAM
      END IF
      IF g_bgjob = "Y" THEN
          SELECT zz08 INTO lc_cmd FROM zz_file
           WHERE zz01 = "afap130"
          IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
             CALL cl_err('afap130','9031',1)  
          ELSE
             LET g_wc=cl_replace_str(g_wc, "'", "\"")
             LET lc_cmd = lc_cmd CLIPPED,
                          " '",g_wc   CLIPPED,"'",
                          " '",g_no   CLIPPED,"'",
                          " '",g_date CLIPPED,"'",
                          " '",g_type CLIPPED,"'",
                          " '",g_bgjob  CLIPPED,"'"
             CALL cl_cmdat('afap130',g_time,lc_cmd CLIPPED)
          END IF
          CLOSE WINDOW p130_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
          EXIT PROGRAM
      END IF
   EXIT WHILE
  #->No.FUN-570144 ---end---
 
#NO.FUN-570144 MARK-----------
#   IF INT_FLAG THEN
#      RETURN
#   END IF
#   IF NOT cl_sure(19,20) THEN
#      RETURN
#   END IF
#    LET g_sql= "SELECT fbe01,fbe02 ",     #No.MOD-4A0297
#              "  FROM fbe_file",
#              " WHERE ",g_wc CLIPPED,
#              "   AND fbeconf<>'X' "
#       #      "   AND fbeconf='Y' ",
#       #      "   AND fbepost='Y' "
#   PREPARE p130_prepare FROM g_sql
#   DECLARE p130_cs CURSOR FOR p130_prepare
#   LET begin_no  = NULL
#   INITIALIZE g_fbe.* TO NULL
#   INITIALIZE g_fbf.* TO NULL
#   SELECT * INTO g_ooz.* FROM ooz_file WHERE ooz00 = '0'
#   BEGIN WORK
#   LET g_success = 'Y'
#
#    FOREACH p130_cs INTO l_fbe01,l_fbe02    #No.MOD-4A0297
#      IF STATUS THEN
#         CALL cl_err('p130(foreach):',STATUS,1)
#         LET g_success='N'
#         EXIT FOREACH
#      END IF
#       #-----No.MOD-4A0297-----
#      IF (YEAR(l_fbe02)*12+MONTH(l_fbe02)) <> (YEAR(g_date)*12+MONTH(g_date)) THEN
#          LET g_success = 'N'   #MOD-530824
#         CALL cl_err(g_fbe.fbe01,'afa-168',1)
#         CONTINUE FOREACH
#      END IF
#       #-----No.MOD-4A0297 END-----
#      MESSAGE '單號:',l_fbe01
#      CALL ui.Interface.refresh()
#      SELECT * INTO g_fbe.* FROM fbe_file WHERE fbe01= l_fbe01
#      IF STATUS THEN
#         LET g_success = 'N'
#        EXIT FOREACH
#      END IF
#      #---------------------------------------------------------- 產生應收
#       #---參考單號已存在應收,則不可再產生
#      SELECT COUNT(*) INTO g_cnt FROM oma_file WHERE oma16 = g_fbe.fbe01
#      IF g_cnt > 0 THEN
#          LET g_success = 'N'   #MOD-530824
#         CALL cl_err(g_fbe.fbe01,'afa-950',1)
#         CONTINUE FOREACH
#      END IF
#      CALL p130_g_oma()
#      LET g_omb.omb03 = 0
#      DECLARE p130_fbf_cs CURSOR FOR
#       SELECT * FROM fbf_file WHERE fbf01=g_fbe.fbe01
#      FOREACH p130_fbf_cs INTO g_fbf.*
#         LET g_omb.omb03 = g_omb.omb03 + 1
#         IF (g_oma.oma08 = '1' AND g_omb.omb03 >= g_ooz.ooz121) OR
#            (g_oma.oma08 = '2' AND g_omb.omb03 >= g_ooz.ooz122) THEN
#            CALL p130_g_bu()
#            CALL p130_g_oma()
#            LET g_omb.omb03 = 1
#            #No.3374 010820 by plum
#            IF g_start IS NULL THEN
#               LET g_start= g_oma.oma01
#            END IF
#            LET g_end  = g_oma.oma01
#            #No.3374...end
#         END IF
#         CALL p130_g_omb()
#      END FOREACH
#
#      CALL p130_g_bu()
#      #NO:7382 回寫A/R單號
#      UPDATE fbe_file SET fbe11 = g_oma.oma01
#      WHERE fbe01 = g_oma.oma16
#      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#         CALL cl_err('update fbe',STATUS,0)
#         LET g_success = 'N'
#         EXIT FOREACH
#      END IF
#      #NO:7382 end
#   END FOREACH
#
#   IF STATUS THEN
#      CALL cl_err('foreach fbf',STATUS,0)
#      LET g_success = 'N'
#   END IF
#   IF begin_no IS NULL THEN
#      LET begin_no = g_oma.oma01
#   END IF  #021218
#   #03/07/16 By Wiky No:7160 修改 LET g_end = g_oma.oma01 不是begin_no
#   IF g_end IS NULL THEN
#      LET g_end = g_oma.oma01
#   END IF
#   ##
#   MESSAGE g_start,'-',g_end
#   CALL ui.Interface.refresh()
#   #NO:8067 031009 modify
#   MESSAGE 'AR NO. from ',begin_no,' to ',g_end
#   CALL ui.Interface.refresh()
#   IF g_success = 'Y' THEN
#      COMMIT WORK
#      CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#   ELSE
#      ROLLBACK WORK #RETURN
#      CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
#   END IF
#   IF l_flag THEN
#      MESSAGE 'AR NO. from ',begin_no,' to ',g_end
#      CALL ui.Interface.refresh()
#   ELSE
#       RETURN
#   END IF
#   #CALL cl_end(20,20)
#NO.FUN-570144 MARK----------
END WHILE
END FUNCTION
 
FUNCTION p130_g_oma()
DEFINE li_result   LIKE type_file.num5      #No.FUN-550034       #No.FUN-680070 SMALLINT
   CALL p130_g_oma_default()
   #--- 輸入單別並自動編號
#No.FUN-550034 --start--
   CALL s_auto_assign_no("axr",g_no,g_date,"14","","","","","")  #No.FUN-560146
      RETURNING li_result,g_oma.oma01
#   CALL s_axrauno(g_no,g_date,'14') RETURNING g_i,g_oma.oma01
#No.FUN-550034 ---end--
   #-----
   LET g_oma.oma03 = g_fbe.fbe03
  #SELECT occ02 INTO g_oma.oma032 FROM occ_file WHERE occ01 = g_oma.oma03  #FUN-910117
   SELECT fbe031 INTO g_oma.oma032 FROM fbe_file WHERE fbe01 = g_fbe.fbe01 #FUN-910117
   LET g_oma.oma04 = g_fbe.fbe03
 #TQC-750246 begin
   LET g_oma.oma68 = g_fbe.fbe03
  #SELECT occ02 INTO g_oma.oma69 FROM occ_file WHERE occ01 = g_oma.oma68  #FUN-910117
   SELECT fbe031 INTO g_oma.oma69 FROM fbe_file WHERE fbe01 = g_fbe.fbe01 #FUN-910117
   LET g_oma.oma51f = 0
   LET g_oma.oma51 = 0
 #TQC-750246 end
 
   SELECT occ08,occ11,occ18,occ43,occ45,occ231
     INTO g_oma.oma05,g_oma.oma042,g_oma.oma043,g_oma.oma25,
          g_oma.oma32,g_oma.oma044
     FROM occ_file WHERE occ01=g_oma.oma04
 
  #no.4218 依畫面指定科目代碼
  #LET g_oma.oma13 = NULL  #科目
  #IF cl_null(g_oma.oma13) THEN LET g_oma.oma13='1' END IF
   IF NOT cl_null(g_type) THEN
      LET g_oma.oma13 = g_type
#No.TQC-7B0060 --start-- mark
#     SELECT ool11 INTO g_oma.oma18 FROM ool_file
#      WHERE ool01 = g_oma.oma13
#No.TQC-7B0060 --end--
     #MOD-D10112 add begin------------------
      SELECT ool11 INTO g_oma.oma18 FROM ool_file
       WHERE ool01 = g_oma.oma13
     #MOD-D10112 add end--------------------
#  END IF   #MOD-D10112 mark
   ELSE     #MOD-D10112 add
   #no.4218 (end)
#No.MOD-C10024 --begin
      IF g_faa.faa29 ='Y' THEN
         SELECT fbz18,fbz181 INTO g_oma.oma18,g_oma.oma181
           FROM fbz_file
          WHERE fbz00 = '0'
      ELSE 
         SELECT fbz10,fbz101 INTO g_oma.oma18,g_oma.oma181
           FROM fbz_file
         WHERE fbz00 = '0'
      END IF
   END IF    #MOD-D10112 add
   #No.TQC-7B0060 --start--
#   SELECT fbz10,fbz101 INTO g_oma.oma18,g_oma.oma181
#     FROM fbz_file
#    WHERE fbz00 = '0'
   #No.TQC-7B0060 --end--
#No.MOD-C10024 --end
   LET g_oma.oma14 = g_user
 # LET g_oma.oma15 = g_oga.oga15   #部門
   LET g_oma.oma15 = g_grup        #部門  #FUN-680006
   LET g_oma.oma16 = g_fbe.fbe01   #參考單號
   LET g_oma.oma161= 0        LET g_oma.oma162= 0
   LET g_oma.oma163= 0
   LET g_oma.oma21 = g_fbe.fbe07  #稅別
   LET g_oma.oma211= g_fbe.fbe071 LET g_oma.oma212= g_fbe.fbe072
   LET g_oma.oma213= g_fbe.fbe073 LET g_oma.oma23 = g_fbe.fbe05
   IF g_oma.oma23 = g_aza.aza17
     THEN LET g_oma.oma24 = 1
          LET g_oma.oma58 = 1
     ELSE #CALL s_curr3(g_oma.oma23,g_oma.oma02,'B') RETURNING g_oma.oma24   #MOD-7B0082
          #CALL s_curr3(g_oma.oma23,g_oma.oma09,'B') RETURNING g_oma.oma58   #MOD-7B0082
          LET g_oma.oma24 = g_fbe.fbe06   #MOD-7B0082
          LET g_oma.oma58 = g_fbe.fbe06   #MOD-7B0082
          IF g_oma.oma58 IS NULL THEN LET g_oma.oma58=g_oma.oma24 END IF
   END IF
   LET g_oma.oma60 = g_oma.oma24     #bug no:A060
   LET g_oma.oma11 = g_oma.oma02 LET g_oma.oma12  =g_oma.oma02
   LET g_oma.oma65 = '1'   #FUN-5A0124
 
#FUN-A60056--mark--str--
##FUN-5C0014 --start--
#  SELECT oga27 INTO g_oma.oma67 FROM oga_file
#   WHERE oga01 = g_oma.oma16
##FUN-5C0014 --end ---
#FUN-A60056--mark--end
   #LET g_oma.oma64 = '0'     #No.TQC-7B0146 #MOD-C30647 mark--
   #LET g_oma.oma64 = '1'      #MOD-C30647 add--     #TQC-C60113  mark
   LET g_oma.oma64 = '0'      #TQC-C60113  add
   LET g_oma.oma930=s_costcenter(g_oma.oma15) #FUN-680006
   #CALL s_rdate2(g_oma.oma03,g_oma.oma32,g_oma.oma02,g_oma.oma09)
   CALL s_rdatem(g_oma.oma03,g_oma.oma32,g_oma.oma02,g_oma.oma09,
                 #g_oma.oma02,g_dbs)   #NO.FUN-630015#No.FUN-680022 add oma02   #TQC-680074
                 #g_oma.oma02,g_dbs2)  #NO.FUN-630015#No.FUN-680022 add oma02   #TQC-680074 #FUN-980020
                 g_oma.oma02,g_plant2) #No.FUN-980020
                     RETURNING g_oma.oma11,g_oma.oma12
 
   LET g_oma.omalegal = g_legal  #FUN-980003 add
 
   LET g_oma.omaoriu = g_user      #No.FUN-980030 10/01/04
   LET g_oma.omaorig = g_grup      #No.FUN-980030 10/01/04
#No.FUN-AB0034 --begin
   IF cl_null(g_oma.oma73) THEN LET g_oma.oma73 =0 END IF
   IF cl_null(g_oma.oma73f) THEN LET g_oma.oma73f =0 END IF
   IF cl_null(g_oma.oma74) THEN LET g_oma.oma74 ='1' END IF
#No.FUN-AB0034 --end
   IF cl_null(g_oma.oma70) THEN LET g_oma.oma70 ='2' END IF  #MOD-B30290
   LET g_oma.oma175 = ''   #MOD-B70056 add
   INSERT INTO oma_file VALUES(g_oma.*)
   IF STATUS THEN 
      LET g_msg='ins oma:(',g_oma.oma01,')'
#                 CALL cl_err(g_msg,STATUS,1)   #No.FUN-660136
#                 CALL cl_err3("ins","oma_file",g_oma.oma01,"",STATUS,"",g_msg,1)   #No.FUN-660136 #No.FUN-710028
                  CALL s_errmsg('oma01',g_oma.oma01,g_msg,STATUS,1)   #No.FUN-660136
                  LET g_success='N'
   END IF
   #03/07/16 By Wiky No:7160 加g_firstno_ck來抓begin_no
   IF g_firstno_ck='Y' THEN
      LET begin_no=g_oma.oma01
   END IF
   LET g_firstno_ck='N'
   ##
END FUNCTION
 
FUNCTION p130_g_omb(p_qty) #CHI-AB0015 add p_qty
 DEFINE  l_str     LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(30)
         l_omb13   LIKE omb_file.omb13
 DEFINE  l_oba11   LIKE oba_file.oba11       #FUN-690012         
 #CHI-AB0015 add --start--
 DEFINE l_omb18t   LIKE omb_file.omb18t
 DEFINE l_amt      LIKE omb_file.omb18t
 DEFINE l_qty      LIKE omb_file.omb12 
 DEFINE p_flag     LIKE type_file.chr1 
 DEFINE p_qty      LIKE omb_file.omb12
 DEFINE l_qty2     LIKE omb_file.omb12
 #CHI-AB0015 add --end--
 
     LET l_omb13 = 0
     IF g_fbf.fbf04 = 0 THEN
        LET l_omb13 = g_fbf.fbf06
     ELSE
        LET l_omb13 = g_fbf.fbf06 / g_fbf.fbf04
     END IF
     SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05             #No.CHI-6A0004 g_azi-->t_azi
       FROM azi_file
      WHERE azi01 = g_fbe.fbe05
 
     LET g_omb.omb00 = g_oma.oma00
     LET g_omb.omb01 = g_oma.oma01
     LET g_omb.omb31 = g_fbe.fbe01  #參考單號
     LET g_omb.omb32 = g_fbf.fbf02  #項次
     LET g_omb.omb04 = 'MISC'
     SELECT * INTO g_faj.* FROM faj_file
      WHERE faj02 = g_fbf.fbf03 AND faj022 = g_fbf.fbf031
     LET g_omb.omb05 = g_faj.faj18  #單位
     LET l_str = g_faj.faj02 CLIPPED,g_faj.faj022 CLIPPED,g_faj.faj06 CLIPPED
     LET g_omb.omb06 = l_str[1,30]
     LET g_omb.omb12 = g_fbf.fbf04
     #CHI-AB0015 add --start--
     IF g_aza.aza26 = '2' AND g_ooy.ooy10 = 'Y' AND p_qty > 0 THEN
        LET g_omb.omb12 = p_qty
     END IF
     LET g_omb.omb12 = s_digqty(g_omb.omb12,g_omb.omb05) #FUN-BB0083 add
     #CHI-AB0015 add --end--
 #   LET g_omb.omb13 = g_fbf.fbf07   #default出售金額
##No.2989 modify 1998/12/29
     LET g_omb.omb13 = l_omb13       #default出售金額
     LET g_omb.omb15 = l_omb13 * g_oma.oma24
     LET g_omb.omb17 = l_omb13 * g_oma.oma58
 
    #FUN-690012 add--begin
     IF g_oma.oma00='12' THEN
       LET l_oba11 = ''
       SELECT oba11 INTO l_oba11 
         FROM oba_file,ima_file
        WHERE oba01 = ima_file.ima131
          AND ima01 = g_omb.omb04
       IF SQLCA.sqlcode THEN
          LET l_oba11 = ''
#         CALL cl_err3("sel","oba_file",g_omb.omb04,"",STATUS,"","sel oba",0)  #No.FUN-710028 
          CALL s_errmsg('ima01',g_omb.omb04,'sel oba',STATUS,0)  #No.FUN-710028
       END IF 
       LET g_omb.omb33 = l_oba11
     END IF
    #FUN-690012 add--end
 
     IF g_oma.oma213 = 'Y' THEN          #No:9491含稅部份修改
#MOD-590230 將原本的mark拿掉,沒有mark的mark起來
      LET g_omb.omb14 =(g_omb.omb13*g_omb.omb12)/(1+(g_oma.oma211/100))
#        LET g_omb.omb14 = g_omb.omb13*g_omb.omb12
      LET g_omb.omb14t= g_omb.omb13*g_omb.omb12
#        LET g_omb.omb14t=(g_omb.omb15*g_omb.omb12)*(1+(g_oma.oma211/100))
      LET g_omb.omb16 =(g_omb.omb15*g_omb.omb12)/(1+(g_oma.oma211/100))
#        LET g_omb.omb16 =g_omb.omb15*g_omb.omb12
      LET g_omb.omb16t= g_omb.omb15*g_omb.omb12
#        LET g_omb.omb16t=(g_omb.omb17*g_omb.omb12)*(1+(g_oma.oma211/100))
      LET g_omb.omb18 =(g_omb.omb17*g_omb.omb12)/(1+(g_oma.oma211/100))
#        LET g_omb.omb18 =g_omb.omb17*g_omb.omb12
      LET g_omb.omb18t= g_omb.omb17*g_omb.omb12
#        LET g_omb.omb18t=(g_omb.omb17*g_omb.omb12)*(1+(g_oma.oma211/100))
#END MOD-590230
     ELSE
        LET g_omb.omb14t=(g_omb.omb13*g_omb.omb12)*(1+(g_oma.oma211/100))
        LET g_omb.omb14 = g_omb.omb13*g_omb.omb12
        LET g_omb.omb16t=(g_omb.omb15*g_omb.omb12)*(1+(g_oma.oma211/100))
        LET g_omb.omb16 = g_omb.omb15*g_omb.omb12
        LET g_omb.omb18t=(g_omb.omb17*g_omb.omb12)*(1+(g_oma.oma211/100))
        LET g_omb.omb18 = g_omb.omb17*g_omb.omb12
     END IF
     CALL cl_digcut(g_omb.omb14,t_azi04) RETURNING g_omb.omb14      #MOD-BC0013 add
     CALL cl_digcut(g_omb.omb14t,t_azi04) RETURNING g_omb.omb14t    #MOD-BC0013 add
     CALL cl_digcut(g_omb.omb15,g_azi03) RETURNING g_omb.omb15      #No.CHI-6A0004 g_azi-->t_azi   #MOD-BC0013 改回g_azi
     CALL cl_digcut(g_omb.omb16,g_azi04) RETURNING g_omb.omb16      #No.CHI-6A0004 g_azi-->t_azi   #MOD-BC0013 改回g_azi
     CALL cl_digcut(g_omb.omb16t,g_azi04)RETURNING g_omb.omb16t     #No.CHI-6A0004 g_azi-->t_azi   #MOD-BC0013 改回g_azi
     CALL cl_digcut(g_omb.omb17,g_azi03) RETURNING g_omb.omb17      #No.CHI-6A0004 g_azi-->t_azi   #MOD-BC0013 改回g_azi
     CALL cl_digcut(g_omb.omb18,g_azi04) RETURNING g_omb.omb18      #No.CHI-6A0004 g_azi-->t_azi   #MOD-BC0013 改回g_azi
     CALL cl_digcut(g_omb.omb18t,g_azi04)RETURNING g_omb.omb18t     #No.CHI-6A0004 g_azi-->t_azi   #MOD-BC0013 改回g_azi
##----------------------------------------------
     #CHI-AB0015 add --start--
     #超過發票限額則拆數量
     LET p_flag = 'N'
     LET p_qty = 0
     IF g_aza.aza26 = '2' AND g_ooy.ooy10 = 'Y' THEN   #MOD-630073
        SELECT SUM(omb18t) INTO l_omb18t FROM omb_file WHERE omb01=g_oma.oma01
        IF cl_null(l_omb18t) THEN LET l_omb18t = 0 END IF
        IF l_omb18t + g_omb.omb18t > g_ooy.ooy11 THEN
           LET p_flag = 'Y'
           LET l_amt = g_ooy.ooy11
        ELSE
           LET p_flag = 'N' 
           LET l_amt = l_omb18t + g_omb.omb18t 
        END IF
        IF p_flag = 'Y' THEN     
           IF g_omb.omb12 > 1 THEN
              LET l_qty = (l_amt - l_omb18t) / (g_omb.omb18t / g_omb.omb12)
              LET p_qty = g_omb.omb12 - l_qty
              LET g_omb.omb12 = l_qty
           ELSE  
              LET l_qty2 = (l_amt - l_omb18t)/ (g_omb.omb18t / g_omb.omb12)
              LET p_qty = g_omb.omb12 - l_qty2
              LET g_omb.omb12 = l_qty2
           END IF
           LET g_omb.omb12 = s_digqty(g_omb.omb12,g_omb.omb05) #FUN-BB0083 add
           IF g_oma.oma213 = 'N' THEN
              IF g_omb.omb12 != 0 THEN
                 LET g_omb.omb14 =g_omb.omb12*g_omb.omb13
              END IF
              CALL cl_digcut(g_omb.omb14,t_azi04) RETURNING g_omb.omb14 
              LET g_omb.omb14t=g_omb.omb14*(1+g_oma.oma211/100)
              CALL cl_digcut(g_omb.omb14t,t_azi04)RETURNING g_omb.omb14t 
           ELSE 
              IF g_omb.omb12 != 0 THEN
                 LET g_omb.omb14t=g_omb.omb12*g_omb.omb13
              END IF
              CALL cl_digcut(g_omb.omb14t,t_azi04)RETURNING g_omb.omb14t   
              LET g_omb.omb14 =g_omb.omb14t/(1+g_oma.oma211/100)
              CALL cl_digcut(g_omb.omb14,t_azi04) RETURNING g_omb.omb14   
           END IF
           LET g_omb.omb15 =g_omb.omb13 *g_oma.oma24
           LET g_omb.omb16 =g_omb.omb14 *g_oma.oma24
           LET g_omb.omb16t=g_omb.omb14t*g_oma.oma24
           LET g_omb.omb17 =g_omb.omb13 *g_oma.oma58
           LET g_omb.omb18 =g_omb.omb14 *g_oma.oma58
           LET g_omb.omb18t=g_omb.omb14t*g_oma.oma58
           CALL cl_digcut(g_omb.omb15,g_azi03) RETURNING g_omb.omb15  
           CALL cl_digcut(g_omb.omb16,g_azi04) RETURNING g_omb.omb16 
           CALL cl_digcut(g_omb.omb16t,g_azi04)RETURNING g_omb.omb16t 
           CALL cl_digcut(g_omb.omb17,g_azi03) RETURNING g_omb.omb17 
           CALL cl_digcut(g_omb.omb18,g_azi04) RETURNING g_omb.omb18   
           CALL cl_digcut(g_omb.omb18t,g_azi04)RETURNING g_omb.omb18t 
        END IF                                                     
     END IF
     #CHI-AB0015 add --end--
     #03/07/16 By Wiky #No:7630 omb34/omb35 數值not null for oracle
     IF cl_null(g_omb.omb34) THEN
        LET g_omb.omb34=0
     END IF
     IF cl_null(g_omb.omb35) THEN
        LET g_omb.omb35=0
     END IF
     LET g_omb.omb36=g_oma.oma60
     LET g_omb.omb37=g_oma.oma61
     ##
     IF g_bgjob = "N" THEN
         MESSAGE g_omb.omb03,' ',g_omb.omb04,' ',g_omb.omb12
         CALL ui.Interface.refresh()
     END IF
     LET g_omb.omb930=g_oma.oma930 #FUN-680006
 
     LET g_omb.omblegal = g_legal  #FUN-980003 add
     LET g_omb.omb48 = 0   #FUN-D10101 add 
     INSERT INTO omb_file VALUES(g_omb.*)
     IF STATUS THEN 
#       CALL cl_err('ins omb',STATUS,1)   #No.FUN-660136
#       CALL cl_err3("ins","omb_file",g_omb.omb01,g_omb.omb03,STATUS,"","ins omb",1)   #No.FUN-660136 #No.FUN-710028
        LET g_showmsg = g_omb.omb01,"/",g_omb.omb03                 #No.FUN-710028
        CALL s_errmsg('omb01,omb03',g_showmsg,'ins omb',STATUS,1)   #No.FUN-710028
        LET g_success='N' 
     END IF
     RETURN p_flag,p_qty #CHI-AB0015 add
END FUNCTION
 
FUNCTION p130_g_bu()
#CHI-AB0015 add --start--
 DEFINE l_omb14    LIKE omb_file.omb14
 DEFINE l_omb14t   LIKE omb_file.omb14t
 DEFINE l_omb16    LIKE omb_file.omb16
 DEFINE l_omb16t   LIKE omb_file.omb16t
 DEFINE l_omb18    LIKE omb_file.omb18
 DEFINE l_omb18t   LIKE omb_file.omb18t
#CHI-AB0015 add --end--

   LET g_oma.oma50 = 0 LET g_oma.oma50t= 0
   SELECT SUM(omb14),SUM(omb14t) INTO g_oma.oma50,g_oma.oma50t
          FROM omb_file WHERE omb01=g_oma.oma01
   IF g_oma.oma50 IS NULL THEN LET g_oma.oma50=0 END IF
   IF g_oma.oma50t IS NULL THEN LET g_oma.oma50t=0 END IF
   IF g_oma.oma213='N'
      THEN LET g_oma.oma50t=g_oma.oma50 *(1+g_oma.oma211/100)
      ELSE LET g_oma.oma50 =g_oma.oma50t*100/(100+g_oma.oma211)
   END IF
   LET g_oma.oma52 = 0 LET g_oma.oma53 = 0

  #CHI-AB0015 add --start--
   SELECT SUM(omb14),SUM(omb14t),SUM(omb16),SUM(omb16t),SUM(omb18),SUM(omb18t)
     INTO l_omb14,l_omb14t,l_omb16,l_omb16t,l_omb18,l_omb18t
     FROM omb_file
     WHERE omb01=g_oma.oma01

   IF l_omb14  IS NULL THEN LET l_omb14  = 0 END IF
   IF l_omb14t IS NULL THEN LET l_omb14t = 0 END IF
   IF l_omb16  IS NULL THEN LET l_omb16  = 0 END IF
   IF l_omb16t IS NULL THEN LET l_omb16t = 0 END IF
   IF l_omb18  IS NULL THEN LET l_omb18  = 0 END IF
   IF l_omb18t IS NULL THEN LET l_omb18t = 0 END IF

   LET g_oma.oma54 = l_omb14 
   LET g_oma.oma54t= l_omb14t 
   LET g_oma.oma54x= l_omb14t - l_omb14 

   LET g_oma.oma56 = l_omb16 
   LET g_oma.oma56t= l_omb16t 
   LET g_oma.oma56x= l_omb16t - l_omb16 

   LET g_oma.oma59 = l_omb18 
   LET g_oma.oma59t= l_omb18t 
   LET g_oma.oma59x= l_omb18t - l_omb18 
  #CHI-AB0015 add --end--
  #CHI-AB0015 mark --start--
  #LET g_oma.oma54 = g_fbe.fbe08
  #LET g_oma.oma54t= g_fbe.fbe08t
  #LET g_oma.oma54x= g_fbe.fbe08x
  ##------------------------------------------------------------
  #LET g_oma.oma56 = 0 LET g_oma.oma56t= 0
  #LET g_oma.oma56 = g_fbe.fbe09
  #IF g_oma.oma56  IS NULL THEN LET g_oma.oma56 =0 END IF
  #IF g_oma.oma56t IS NULL THEN LET g_oma.oma56t=0 END IF
  #LET g_oma.oma56x=g_fbe.fbe09x
  #LET g_oma.oma56t=g_fbe.fbe09t
  ##------------------------------------------------------------
  #LET g_oma.oma59 = 0 LET g_oma.oma59t= 0
  #LET g_oma.oma59 = g_fbe.fbe09
  #IF g_oma.oma59  IS NULL THEN LET g_oma.oma59 =0 END IF
  #IF g_oma.oma59t IS NULL THEN LET g_oma.oma59t=0 END IF
  #LET g_oma.oma59x=g_fbe.fbe09x
  #LET g_oma.oma59t=g_fbe.fbe09t
  #CHI-AB0015 mark --end--
   LET g_oma.oma61 = g_oma.oma56t - g_oma.oma57   #bug no:A060
   #------------------------------------------------------------
   UPDATE oma_file SET
         (oma50,oma50t,oma52,oma53,
          oma54,oma54x,oma54t,
          oma56,oma56x,oma56t,
          oma59,oma59x,oma59t,
          oma55,oma57,oma61)                   #bug no:A060
             =(g_oma.oma50,g_oma.oma50t,g_oma.oma52,g_oma.oma53,
               g_oma.oma54,g_oma.oma54x,g_oma.oma54t,
               g_oma.oma56,g_oma.oma56x,g_oma.oma56t,
               g_oma.oma59,g_oma.oma59x,g_oma.oma59t,
               g_oma.oma55,g_oma.oma57,g_oma.oma61)          #bug no:A060
          WHERE oma01=g_oma.oma01
     IF STATUS THEN 
#       CALL cl_err('upd oma50',STATUS,1)   #No.FUN-660136
#       CALL cl_err3("upd","oma_file",g_oma.oma01,"",STATUS,"","upd oma50",1)    #No.FUN-660136 #No.FUN-710028
        CALL s_errmsg('oma01',g_oma.oma01,'upd oma50',STATUS,1)   #No.FUN-710028
        LET g_success='N'
     END IF
END FUNCTION
 
FUNCTION p130_g_oma_default()
DEFINE l_gec08      LIKE gec_file.gec08    #MOD-A20116 add
DEFINE l_gec06      LIKE gec_file.gec06    #MOD-B70158 add

        LET g_oma.oma00 = '14'
        LET g_oma.oma01  =NULL
        LET g_oma.oma02 = g_date
        LET g_oma.oma09  =NULL
        LET g_oma.oma08  ='1'
        LET g_oma.oma07  ='N' LET g_oma.oma17  ='1'
  #MOD-A20116-------modify------------------------------start---
       #LET g_oma.oma171 ='31' LET g_oma.oma172 ='1'
        LET l_gec08 = ' '
     #MOD-B70158------------------------------------start
        LET l_gec06 = ' '                
       #SELECT gec08 INTO l_gec08 FROM gec_file
       # WHERE gec01 = g_fbe.fbe07
        SELECT gec08,gec06 INTO l_gec08,l_gec06 FROM gec_file
         WHERE gec01 = g_fbe.fbe07
        LET g_oma.oma171 = l_gec08
        LET g_oma.oma172 = l_gec06
     #MOD-B70158-------------------------------------end
       #LET g_oma.oma172 = '1'
  #MOD-A20116-------modify------------------------------end---
        LET g_oma.oma173 = YEAR(g_oma.oma02)
        LET g_oma.oma174 = MONTH(g_oma.oma02)
        LET g_oma.oma20  ='Y'
        LET g_oma.oma50  =0 LET g_oma.oma50t =0
        LET g_oma.oma52  =0 LET g_oma.oma53  =0
        LET g_oma.oma54  =0 LET g_oma.oma54x =0
        LET g_oma.oma54t =0 LET g_oma.oma55  =0
        LET g_oma.oma56  =0 LET g_oma.oma56x =0
        LET g_oma.oma56t =0 LET g_oma.oma57  =0
        LET g_oma.oma59  =0 LET g_oma.oma59x =0
        LET g_oma.oma59t =0
        LET g_oma.oma61 =0      #bug no:A060
       #LET g_oma.omaconf='Y'           #MOD-B40047 mod 'N' -> 'Y'  #MOD-C60007 mark
        LET g_oma.omaconf='N'           #MOD-B40047 mod 'N' -> 'Y'  #MOD-C60007 'Y'->'N'
        LET g_oma.omavoid='N'
        LET g_oma.omaprsw=0
        LET g_oma.omauser=g_user
        LET g_oma.omagrup=g_grup
        LET g_oma.omadate=TODAY
END FUNCTION
 
#NO.FUN-570144 START----
FUNCTION p130_process()
   DEFINE   l_order   ARRAY[4] of LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(10)
            l_fbe01   LIKE fbe_file.fbe01,
            l_fbe02   LIKE fbe_file.fbe02,    #No:BUG-4A0297
            l_flag    LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
            sr        RECORD
            order1    LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(10)
            order2    LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(10)
            oga01     LIKE oga_file.oga01,
            oga011    LIKE oga_file.oga011,
            oga03     LIKE oga_file.oga03,
            oga05     LIKE oga_file.oga05,
            oga21     LIKE oga_file.oga21,
            oga15     LIKE oga_file.oga15,
            oga14     LIKE oga_file.oga14,
            oga23     LIKE oga_file.oga23,
            oga02     LIKE oga_file.oga02,
            oga11     LIKE oga_file.oga11
                      END RECORD
  DEFINE l_flag1      LIKE type_file.chr1000 #CHI-AB0015 add 
  DEFINE l_qty        LIKE omb_file.omb12    #CHI-AB0015 add
 
    LET g_sql= "SELECT fbe01,fbe02 ",     #No.MOD-4A0297
              "  FROM fbe_file",
              " WHERE ",g_wc CLIPPED,
              "   AND fbeconf<>'X' "
       #      "   AND fbeconf='Y' ",
       #      "   AND fbepost='Y' "
   PREPARE p130_prepare FROM g_sql
   DECLARE p130_cs CURSOR FOR p130_prepare
   LET begin_no  = NULL
   INITIALIZE g_fbe.* TO NULL
   INITIALIZE g_fbf.* TO NULL
   SELECT * INTO g_ooz.* FROM ooz_file WHERE ooz00 = '0'
   BEGIN WORK
   LET g_success = 'Y'
    CALL s_showmsg_init()                   #No.FUN-710028
    FOREACH p130_cs INTO l_fbe01,l_fbe02    #No.MOD-4A0297
      IF STATUS THEN
#        CALL cl_err('p130(foreach):',STATUS,1)         #No.FUN-710028
         CALL s_errmsg('','','p130(foreach):',STATUS,1) #No.FUN-710028
         LET g_success='N'
         EXIT FOREACH
      END IF
#No.FUN-710028 --begin       
      IF g_success='N' THEN                                                                                                          
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                    
#No.FUN-710028 -end  
 
       #-----No.MOD-4A0297-----
      IF (YEAR(l_fbe02)*12+MONTH(l_fbe02)) <> (YEAR(g_date)*12+MONTH(g_date)) THEN
         LET g_success = 'N'   #MOD-530824
#        CALL cl_err(g_fbe.fbe01,'afa-168',1)          #No.FUN-710028
         CALL s_errmsg('','',g_fbe.fbe01,'afa-168',1)  #No.FUN-710028
        #FUN-690012
         #CONTINUE FOREACH
         LET g_success='N'
#        EXIT FOREACH       #No.FUN-710028
         CONTINUE FOREACH   #No.FUN-710028
        #FUN-690012 end
      END IF
       #-----No.MOD-4A0297 END-----
      IF g_bgjob = "N" THEN
          MESSAGE '單號:',l_fbe01
          CALL ui.Interface.refresh()
      END IF
      SELECT * INTO g_fbe.* FROM fbe_file WHERE fbe01= l_fbe01
      IF STATUS THEN
         LET g_success = 'N'
         CALL s_errmsg('fbe01',l_fbe01,g_fbe.fbe01,STATUS,1)  #No.FUN-710028
#        EXIT FOREACH       #No.FUN-710028
         CONTINUE FOREACH   #No.FUN-710028
      END IF
      #---------------------------------------------------------- 產生應收
       #---參考單號已存在應收,則不可再產生
      SELECT COUNT(*) INTO g_cnt FROM oma_file WHERE oma16 = g_fbe.fbe01
                                                 AND omavoid != 'Y'   #MOD-720105
      IF g_cnt > 0 THEN
         LET g_success = 'N'   #MOD-530824
#        CALL cl_err(g_fbe.fbe01,'afa-950',1)  #No.FUN-710028
         CALL s_errmsg('oma16',g_fbe.fbe01,g_fbe.fbe01,'afa-950',1)  #No.FUN-710028
         CONTINUE FOREACH
      END IF
      CALL p130_g_oma()
      LET g_omb.omb03 = 0
      DECLARE p130_fbf_cs CURSOR FOR
       SELECT * FROM fbf_file WHERE fbf01=g_fbe.fbe01
      FOREACH p130_fbf_cs INTO g_fbf.*
         LET g_omb.omb03 = g_omb.omb03 + 1
         IF (g_oma.oma08 = '1' AND g_omb.omb03 >= g_ooz.ooz121) OR
            (g_oma.oma08 = '2' AND g_omb.omb03 >= g_ooz.ooz122) THEN
            CALL p130_g_bu()
            CALL p130_g_oma()
            LET g_omb.omb03 = 1
            #No.3374 010820 by plum
            IF g_start IS NULL THEN
               LET g_start= g_oma.oma01
            END IF
            LET g_end  = g_oma.oma01
            #No.3374...end
         END IF
         #CALL p130_g_omb() #CHI-AB0015 mark
         #CHI-AB0015 add --start--
         LET l_qty = 0
         CALL p130_g_omb(l_qty) RETURNING l_flag1,l_qty
         WHILE TRUE 
         IF g_aza.aza26='2' AND g_ooy.ooy10 = 'Y' AND l_flag1 = 'Y' AND l_qty > 0 THEN 
            CALL p130_g_bu()
            CALL p130_g_oma()
            LET g_omb.omb03 = 1
            CALL p130_g_omb(l_qty) RETURNING l_flag1,l_qty    
         ELSE 
            EXIT WHILE 
         END IF
         END WHILE   
         #CHI-AB0015 add --end--
      END FOREACH
 
      CALL p130_g_bu()
      CALL p130_g_omc()  #No.TQC-7B0056
      #NO:7382 回寫A/R單號
      UPDATE fbe_file SET fbe11 = g_oma.oma01
      WHERE fbe01 = g_oma.oma16
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#        CALL cl_err('update fbe',STATUS,0)   #No.FUN-660136
#        CALL cl_err3("upd","fbe_file",g_oma.oma16,"",STATUS,"","update fbe",0)   #No.FUN-660136 #No.FUN-710028
         CALL s_errmsg('fbe01',g_oma.oma16,'update fbe',STATUS,1)   #No.FUN-710028
         LET g_success = 'N'
#        EXIT FOREACH       #No.FUN-710028
         CONTINUE FOREACH   #No.FUN-710028
      END IF
      #NO:7382 end
   END FOREACH
#No.FUN-710028 --begin
   IF g_totsuccess="N" THEN                                                                                                         
      LET g_success="N"                                                                                                             
   END IF 
#No.FUN-710028 --end
 
 
   IF STATUS THEN
#     CALL cl_err('foreach fbf',STATUS,0)         #No.FUN-710028
      CALL s_errmsg('','','foreach fbf',STATUS,1) #No.FUN-710028
      LET g_success = 'N'
   END IF
   IF begin_no IS NULL THEN
      LET begin_no = g_oma.oma01
   END IF  #021218
   #03/07/16 By Wiky No:7160 修改 LET g_end = g_oma.oma01 不是begin_no
   IF g_end IS NULL THEN
      LET g_end = g_oma.oma01
   END IF
   ##
 
   MESSAGE g_start,'-',g_end
   CALL ui.Interface.refresh()
   #NO:8067 031009 modify
   MESSAGE 'AR NO. from ',begin_no,' to ',g_end
   CALL ui.Interface.refresh()
  #str MOD-870228 mark
  #IF g_success = 'Y' THEN
  #   COMMIT WORK
  #   CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
  #ELSE
  #   ROLLBACK WORK #RETURN
  #   CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
  #END IF
  #IF l_flag THEN
  #   MESSAGE 'AR NO. from ',begin_no,' to ',g_end
  #   CALL ui.Interface.refresh()
  #END IF
  #end MOD-870228 mark
END FUNCTION
#NO.FUN-570144 END---------
 
#No.TQC-7B0056 --start--
FUNCTION p130_g_omc()
DEFINE l_omc        RECORD LIKE omc_file.*
DEFINE l_oas        RECORD LIKE oas_file.*
DEFINE l_omc03      LIKE omc_file.omc03
DEFINE l_oas02      LIKE oas_file.oas02
DEFINE l_sql        STRING
DEFINE l_n          LIKE type_file.num5
DEFINE l_omc08      LIKE omc_file.omc08
DEFINE l_omc09      LIKE omc_file.omc09
DEFINE l_omc02      LIKE omc_file.omc02
 
  SELECT DISTINCT(oas02) INTO l_oas02 FROM oas_file WHERE oas01=g_oma.oma32
  INITIALIZE l_omc.* TO NULL
 
  LET l_omc.omclegal = g_legal  #FUN-980003 add
 
  IF l_oas02='1' THEN
     LET l_n=1
     LET l_sql=" SELECT * FROM oas_file WHERE oas01='",g_oma.oma32,"'"
     PREPARE p130_omc_p  FROM l_sql
     DECLARE p130_omc_cs CURSOR FOR p130_omc_p
     FOREACH p130_omc_cs INTO l_oas.*
       LET l_omc.omc01=g_oma.oma01
       LET l_omc.omc02=l_n
       LET l_omc.omc03=l_oas.oas04
#      CALL s_rdatem(g_oma.oma03,l_omc03,g_oma.oma02,g_oma.oma09,g_oma.oma02,g_dbs)    #FUN-980020 mark
       #CALL s_rdatem(g_oma.oma03,l_omc03,g_oma.oma02,g_oma.oma09,g_oma.oma02,g_plant)  #FUN-980020 #MOD-C60196 mark
       CALL s_rdatem(g_oma.oma03,l_omc.omc03,g_oma.oma02,g_oma.oma09,g_oma.oma02,g_plant)  #MOD-C60196 add
            RETURNING l_omc.omc04,l_omc.omc05
       LET l_omc.omc06=g_oma.oma24
       LET l_omc.omc07=g_oma.oma60
       LET l_omc.omc08=0
       LET l_omc.omc09=0
       LET l_omc.omc10=0
       LET l_omc.omc11=0
       LET l_omc.omc12=g_oma.oma10
       LET l_omc.omc13=0
       LET l_omc.omc14=0
       LET l_omc.omc15=0
       INSERT INTO omc_file VALUES(l_omc.*)
       IF SQLCA.sqlcode THEN
          CALL s_errmsg('oma01',l_omc.omc01,"insert omc_file",SQLCA.sqlcode,1)
          LET g_success='N'
          EXIT FOREACH
       ELSE
          LET l_n=l_n+1
       END IF
     END FOREACH
  END IF
  IF l_oas02='2' OR cl_null(l_oas02) THEN
     LET l_omc.omc01=g_oma.oma01
     LET l_omc.omc02=1
     LET l_omc.omc03=g_oma.oma32
     LET l_omc.omc04=g_oma.oma11
     LET l_omc.omc05=g_oma.oma12
     LET l_omc.omc06=g_oma.oma24
     LET l_omc.omc07=g_oma.oma60
     LET l_omc.omc08=0
     LET l_omc.omc09=0
     LET l_omc.omc10=0
     LET l_omc.omc11=0
     LET l_omc.omc12=g_oma.oma10
     LET l_omc.omc13=0
     LET l_omc.omc14=0
     LET l_omc.omc15=0
     INSERT INTO omc_file VALUES(l_omc.*)
     IF SQLCA.sqlcode THEN
        CALL s_errmsg('omc01',l_omc.omc01,"insert omc_file",SQLCA.sqlcode,1)
        LET g_success='N'
     END IF
  END IF
  SELECT SUM(omc08),SUM(omc09),MAX(omc02) INTO l_omc08,l_omc09,l_omc02
    FROM omc_file
   WHERE omc01 = g_oma.oma01
  IF SQLCA.sqlcode THEN
     CALL cl_err3("sel","omc_file",g_oma.oma01,"",SQLCA.sqlcode,"","",1)
     LET g_success ='N'
     RETURN
  END IF
  IF cl_null(l_omc08) THEN
     LET l_omc08 = 0
  END IF
  IF cl_null(l_omc09) THEN
     LET l_omc09 = 0
  END IF
  IF l_omc08 <> g_oma.oma54t THEN 
     UPDATE omc_file SET omc08 = omc08-(l_omc08-g_oma.oma54t)
      WHERE omc01 = g_oma.oma01
        AND omc02 = l_omc02
     IF SQLCA.sqlcode THEN
        CALL cl_err3("upd","omc_file",g_oma.oma01,l_omc02,SQLCA.sqlcode,"","",1)
        LET g_success ='N'
        RETURN
     END IF
  END IF
  IF l_omc09 <> g_oma.oma56t THEN
     UPDATE omc_file SET omc09 = omc09-(l_omc09-g_oma.oma56t),
                         omc13 = omc09-(l_omc09-g_oma.oma56t)    #No.MOD-BC0308
      WHERE omc01 = g_oma.oma01
        AND omc02 = l_omc02
     IF SQLCA.sqlcode THEN
        CALL cl_err3("upd","omc_file",g_oma.oma01,l_omc02,SQLCA.sqlcode,"","",1)
        LET g_success ='N'
        RETURN
     END IF
  END IF
END FUNCTION
#No.TQC-7B0056 --end--
#Patch....NO.TQC-610035 <001> #
