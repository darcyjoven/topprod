# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: amrp520.4gl 
# Descriptions...: MRP 工單產生作業
# Date & Author..: 96/06/10 By Roger
# Modify.........: No.FUN-4A0009 04/10/02 By Yuna 料件編號要開窗
# Modify.........: No.MOD-4B0079 04/11/18 By Mandy Oracle 版本產生模擬工單報表明細之後,選擇不產生工單,結果並沒有ROLLBACK WORK 將工單清除還原
# Modify.........: No.MOD-4B0175 04/11/22 By Mandy [製造部門] 該欄位改為可輸可不輸入,若不輸入時 , 應該DEFAULT 為料件主檔的主要供應商.
# Modify.........: No.MOD-4B0215 04/11/30 By Carol 續 bug-4B0079, 重覆執行(不離開程式),工單號碼會因rollback造成空號
# Modify.........: No.FUN-510046 05/02/22 By pengu 報表轉XML
# Modify.........: No.FUN-550055 05/05/25 By Will 單據編號放大
# Modify.........: No.FUN-550110 05/05/26 By ching 特性BOM功能修改
# Modify.........: No.FUN-560060 05/06/17 By day  單據編號修改
# Modify.........: No.FUN-560106 05/06/19 By wujie單據編號修改
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-590067 05/10/12 By Sarah 將p520_ask()裡AFTER FIELD sfb01下的BEGIN WORK,CALL s_auto_assign_no MARK掉
# Mofify.........: NO.TQC-5B0061 05/11/08 BY yiting 製造部門無自動帶出(開窗)
# Modify.........: No.TQC-610003 06/01/17 By Nicola INSERT INTO sfb_file 時,特性代碼欄位(sfb95)應抓取該工單單頭生產料件在料件主檔(ima_file)設定的'主特性代碼'欄位(ima910)
# Modify.........: No.FUN-570125 06/03/07 By yiting 批次作業背景執行
# Modify.........: No.MOD-640187 06/04/09 By Mandy 預設委外型態sfb100=smy57[6,6]
# Modify.........: No.TQC-640143 06/04/17 By Mandy DEFINE l_smy57 VARCHAR(05) 改成LIKE smy57
# Modify.........: No.FUN-660107 06/06/14 By CZH cl_err-->cl_err3
# Modify.........: No.TQC-670008 06/07/05 By kim 將 g_sys 變數改成寫死系統別(要大寫)
# Modify.........: No.FUN-670041 06/08/10 By Pengu 將sma29 [虛擬產品結構展開與否] 改為 no use
# Modify.........: No.FUN-680101 06/09/04 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.FUN-6B0044 06/11/13 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.FUN-6B0064 07/01/25 By rainy 無資料時要秀訊息
# Modify.........: No.TQC-710025 07/03/06 By pengu 1.產生工單時實際開工日欄位日期會被default為"99/12/31
#                                                  2.抓不到單別時程式會當出
# Modify.........: No.TQC-760014 07/06/05 By xufeng 根據MRP的建議生產量轉工單時，應該考慮庫存單位和生產單位的單位換算率。
# Modify.........: No.TQC-770031 07/07/06 By chenl  修正日期錯誤。
# Modify.........: No.MOD-780079 07/08/20 By pengu sfb99重工否應預設為'N'
# Modify.........: No.MOD-790071 07/09/17 By Pengu 若sfb02='7'則才去check料件供應商是否須存在料件主檔中.
# Modify.........: No.CHI-740001 07/09/27 By rainy bma_file要判斷有效碼
# Modify.........: No.MOD-790143 07/10/17 By Pengu 若單身備料皆為消耗性料件, 單頭扣帳方式應為2.領料(事後扣帳)
# Modify.........: No.FUN-7B0018 08/02/26 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.MOD-7C0215 08/03/25 By Pengu 報表列印時料號不應限制只印15碼
# Modify.........: No.MOD-8A0124 08/10/14 By chenl 修正多人操作時，程序會卡住的情況。
# Modify.........: No.FUN-920183 09/04/20 By shiwuying MRP功能改善
# Modify.........: No.FUN-980004 09/08/12 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-970027 09/11/12 By jan 拋轉工單時,單別先抓料件主檔的,如果料件主檔沒設單別，才抓畫面上的工單單別
# Modify.........: No:TQC-9B0118 09/11/18 By sherry 生成工單時，沒有給簽核碼賦值
# Modify.........: No.TQC-A50087 10/05/20 By liuxqa sfb104 赋初值.
# Modify.........: No:MOD-A60099 10/06/15 By Sarah 以g_user當申請人(sfb44)的預設值
# Modify.........: No:MOD-A90066 10/09/08 By Carrier sfb18/sfb19 default '',sfb251 default g_today
# Modify.........: No.FUN-A80102 10/09/20 By kim GP5.25號機管理
# Modify.........: No.FUN-A90057 10/09/27 By kim GP5.25號機管理
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No:TQC-AB0143 10/11/30 By jan sfb92 default ''
# Modify.........: No:TQC-AC0238 10/12/17 By Mengxw 工單單號的欄位檢查以開窗都要排除smy73=‘Y’的單別
# Modify.........: No:TQC-AC0240 10/12/17 By jan sfb43 給預設值'N'
# Modify.........: No:CHI-AC0040 10/12/30 By sabrina 無法同時多人執行程式 
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-A70095 11/06/14 By lixh1 撈取報工單(shb_file)的所有處理作業,必須過濾是已確認的單據
# Modify.........: No.MOD-B80037 11/08/03 By Carrier g_bgjob='Y'时,少了cl_outnam
# Modify.........: No:CHI-B80053 11/10/06 By johung 成本中心是null時，帶入輸入料號的ima34
# Modify.........: No.FUN-BC0008 11/12/02 By zhangll s_cralc4整合成s_cralc,s_cralc增加傳參
# Modify.........: No.TQC-C50063 12/05/09 By fengrui AFTER INPUT斷添加相應的欄位檢查,sfb01預設值改寫抓法
# Modify.........: No:MOD-C40122 12/04/17 By destiny 报表列印后允许用户选择是否产生工单
# Modify.........: No.CHI-C90006 12/11/13 By bart 失效判斷
# Modify.........: No.MOD-D10279 13/01/30 By bart MRP轉工單時應根據單別給予工單sfbmksg值
# Modify.........: No:MOD-D50269 13/05/30 By suncx 生成委外工單時，如畫面沒有錄入製造部門且生產料件沒有維護主供應商時不需要報apm-571错误
# Modify.........: No:TQC-D70003 13/07/01 By qirl 來源碼、計劃員、模擬版本建議增加開窗。來源碼和計劃員欄位支持可以多選

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE mss		RECORD LIKE mss_file.*
DEFINE sfb		RECORD LIKE sfb_file.*
DEFINE g_wc,g_sql	string  #No.FUN-580092 HCN
DEFINE g_t1             LIKE sfb_file.sfb01     #No.FUN-560060    #NO FUN-680082 VARCHAR(5)
DEFINE i,j,k		LIKE type_file.num10    #NO FUN-680082 INTEGER 
DEFINE g_flag           LIKE type_file.chr1     #NO FUN-680082 VARCHAR(01)
DEFINE g_chr            LIKE type_file.chr1     #NO FUN-680082 VARCHAR(1)
DEFINE g_cnt            LIKE type_file.num10    #NO FUN-680082 INTEGER
DEFINE g_i              LIKE type_file.num5     #NO FUN-680082 SMALLINT #count/index for any purpose
DEFINE g_msg            LIKE type_file.chr1000  #NO FUN-680082 VARCHAR(72)
DEFINE g_sfb01          LIKE sfb_file.sfb01     #No.FUN-560060
DEFINE g_null_sfb82    LIKE type_file.chr1     #NO FUN-680082 VARCHAR(1)
 #MOD-4B0215 add
DEFINE tm               RECORD   
   ver_no               LIKE mss_file.mss_v,    #NO FUN-680082 VARCHAR(2)
   msr919               LIKE msr_file.msr919,   #FUN-A80102  #FUN-A90057
   sfb01                LIKE sfb_file.sfb01,
   sfb81                LIKE sfb_file.sfb81,
   sfb82                LIKE sfb_file.sfb82
                        END RECORD
#No.FUN-570125  --begin
DEFINE   g_change_lang  LIKE type_file.chr1     # Prog. Version..: '5.30.06-13.03.12(01)   #是否有做語言切換 No.FUN-570125
#No.FUN-570125  --end
DEFINE g_name    LIKE type_file.chr20    #No.MOD-8A0124 
 
MAIN
   DEFINE p_row,p_col LIKE type_file.num5     #NO FUN-680082 SMALLINT
#       l_time        LIKE type_file.chr8          #No.FUN-6A0076
#No.FUN-570125  --begin
   DEFINE   l_flag     LIKE type_file.chr1      #NO FUN-680082 VARCHAR(01)
   DEFINE   ls_date    STRING
   DEFINE   ls_cmd     STRING
   DEFINE   li_result  LIKE type_file.num5      #NO FUN-680082 SMALLINT
#No.FUN-570125  --end
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				 
 
#No.FUN-570125  --begin
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc     = ARG_VAL(1)             #QBE條件
   LET tm.ver_no = ARG_VAL(2)
   LET tm.sfb01 = ARG_VAL(3)
   LET ls_date = ARG_VAL(4)
   LET tm.sfb81 = cl_batch_bg_date_convert(ls_date)
   LET tm.sfb82 = ARG_VAL(5)
   LET g_bgjob = ARG_VAL(6)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
#No.FUN-570125  --end
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AMR")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
#NO.FUN-570125 start---
#   LET p_row = 5 LET p_col = 17
 
#   OPEN WINDOW p520_w AT p_row,p_col WITH FORM "amr/42f/amrp520" 
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
#    CALL cl_ui_init()
 
#    INITIALIZE tm.*,sfb.* TO NULL   #MOD-4B0215 modify
 
#   SELECT MAX(smyslip) INTO tm.sfb01 FROM smy_file
#    WHERE smysys='asf' AND smykind='1'
#    LET tm.sfb81 = g_today          #MOD-4B0215 modify
#    SELECT gen03 INTO tm.sfb82 FROM gen_file WHERE gen01=g_user  #MOD-4B0215 modify
#NO.FUN-570125 end------
 
#NO.FUN-570125 start-------
   WHILE TRUE
      IF g_bgjob = "N" THEN
         #TQC-C50063--modify--str--
         #SELECT MAX(smyslip) INTO tm.sfb01 FROM smy_file
         # WHERE smysys='asf' AND smykind='1'
         LET g_sql=" SELECT MAX(smyslip) FROM smy_file",
                   "  WHERE smysys = 'asf' AND smykind='1' ",
                   "    AND length(smyslip) = ",g_doc_len
         PREPARE r520_smy FROM g_sql
         EXECUTE r520_smy INTO tm.sfb01
         #TQC-C50063--modify--end--
         LET tm.sfb81 = g_today          #BUG-4B0215 modify
         SELECT gen03 INTO tm.sfb82 FROM gen_file WHERE gen01=g_user  #BUG-4B021
         CALL p520_ask()               # Ask for first_flag, data range or exist
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            CALL cl_outnam('amrp520') RETURNING g_name  #No.MOD-8A0124
            BEGIN WORK
            CALL p520()
            #MOD-C40122--begin
            IF g_success='Y' THEN
               CALL cl_prt(g_name,' ','1',g_len)          #CHI-AC0040 add
               IF cl_confirm('amr-078') THEN
                  LET g_success = 'Y'
               ELSE
                  LET g_success = 'N'
               END IF
            END IF
            #MOD-C40122--end
            IF g_success = 'Y' THEN
               COMMIT WORK
              # CALL cl_prt(g_name,' ','1',g_len)          #CHI-AC0040 add #MOD-C40122
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p520
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         CALL cl_outnam('amrp520') RETURNING g_name  #No.MOD-B80037
         BEGIN WORK
         CALL p520()
         IF g_success = "Y" THEN
            COMMIT WORK
            CALL cl_prt(g_name,' ','1',g_len)          #CHI-AC0040 add
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
END WHILE
#No.FUN-570125  --end------------
 
#NO.FUN-570125 mark---
#      LET g_flag = 'Y'
#      CALL p520_ask()
#      IF g_flag = 'N' THEN
#         CONTINUE WHILE
#      END IF
#      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
#      IF cl_sure(20,20) THEN 
#         CALL cl_wait()
#         BEGIN WORK
#         LET g_success='Y'
#         CALL p520()
#         IF INT_FLAG THEN LET INT_FLAG = 0 LET g_success='N' END IF
#         IF g_success = 'Y' THEN
#            COMMIT WORK
#            CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
#         ELSE
#            ROLLBACK WORK
#            CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
#         END IF
#         IF g_flag THEN
#            CONTINUE WHILE
#            ERROR ''
#         ELSE
#           EXIT WHILE
#         END IF
#      END IF
#   END WHILE
#   CLOSE WINDOW p520_w
#NO.FUN-570125 MARK----
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
END MAIN
#TQC-AC0238   --start
FUNCTION i520_sfb01()
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_slip    LIKE smy_file.smyslip
   DEFINE l_smy73   LIKE smy_file.smy73    
 
   LET g_errno = ' '
   IF cl_null(tm.sfb01) THEN RETURN END IF
   LET l_slip = s_get_doc_no(tm.sfb01)
 
   SELECT smy73 INTO l_smy73 FROM smy_file
    WHERE smyslip = l_slip
   IF l_smy73 = 'Y' THEN
      LET g_errno = 'asf-875'
   END IF 
END FUNCTION
#TQC-AC0238   --end 
FUNCTION p520_ask()
   DEFINE p_cmd          LIKE type_file.chr1
#  DEFINE li_result      LIKE type_file.num5   #No.FUN-550055   #NO FUN-680082 SMALLINT  #TQC-C50063 mark
#->No.FUN-570125 --start--
   DEFINE   lc_cmd    LIKE type_file.chr1000   #NO FUN-680082 VARCHAR(500)
   DEFINE   p_row,p_col LIKE type_file.num5    #NO FUN-680082 SMALLINT
   DEFINE   l_sql     STRING                   #FUN-A80102
#->No.FUN-570125 ---end---
 
#->No.FUN-570125 --start--
   LET p_row = 2 LET p_col = 23
   OPEN WINDOW p520 AT p_row,p_col WITH FORM "amr/42f/amrp520"
        ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
   CALL cl_opmsg('z')
   #FUN-A80102(S)
   IF g_sma.sma1421='Y' THEN
      CALL cl_set_comp_visible("msr919",TRUE)
   ELSE
      CALL cl_set_comp_visible("msr919",FALSE)
   END IF
   #FUN-A80102(E)
WHILE TRUE
#->No.FUN-570125 ---end---
   CONSTRUCT BY NAME g_wc ON mss01, ima08, ima67, mss03, mss11 
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION locale                    #genero
#        LET g_action_choice = "locale"
#        CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_change_lang = TRUE       #->No.FUN-570125
         EXIT CONSTRUCT
      ON ACTION exit              #加離開功能genero
         LET INT_FLAG = 1
         EXIT CONSTRUCT
      #--No.FUN-4A0009--------
      ON ACTION CONTROLP
         CASE WHEN INFIELD(mss01) #料件編號
#FUN-AA0059 --Begin--
               #  CALL cl_init_qry_var()
               #  LET g_qryparam.state    = "c"
               #  LET g_qryparam.form     = "q_ima2"
               #  CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_sel_ima( TRUE, "q_ima2","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                 DISPLAY g_qryparam.multiret TO mss01
                  NEXT FIELD mss01
#TQC-D70003---add--star---
             WHEN INFIELD(ima08) 
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form = "q_ima7"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ima08
                NEXT FIELD ima08
             WHEN INFIELD(ima67) 
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form = "q_ima67"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ima67
                NEXT FIELD ima67
#TQC-D70003--add---end---
              OTHERWISE EXIT CASE
        END CASE
      #--END---------------
         #No.FUN-580031 --start--
      ON ACTION qbe_select
           CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
#NO.FUN-570125 start------
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p520
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
 
#   IF g_action_choice = "locale" THEN  #genero
#      LET g_action_choice = ""
#      CALL cl_dynamic_locale()
#      LET g_flag = 'N'
#      RETURN
#   END IF
#   IF INT_FLAG THEN
#      RETURN
#   END IF
#->No.FUN-570125 ---end---
 
 #MOD-4B0215 modify
   LET g_bgjob = "N"   #NO.FUN-570125 
   #INPUT BY NAME tm.ver_no,tm.sfb01,tm.sfb81,tm.sfb82 WITHOUT DEFAULTS 
   INPUT BY NAME tm.ver_no,tm.msr919,tm.sfb01,tm.sfb81,    #FUN-A90057
                 tm.sfb82,g_bgjob  WITHOUT DEFAULTS   #NO.FUN-570125   #FUN-A80102 
      #FUN-A80102(S)
      AFTER FIELD ver_no
         IF (NOT cl_null(tm.ver_no)) AND (g_sma.sma1431='Y') THEN
            LET tm.msr919 = NULL
            SELECT msr919 INTO tm.msr919
              FROM msr_file WHERE msr_v = tm.ver_no
            DISPLAY BY NAME tm.msr919
         ELSE
            LET tm.msr919=NULL
            DISPLAY BY NAME tm.msr919
         END IF
      #FUN-A80102(E)

      AFTER FIELD sfb01
         IF NOT p520_check_sfb01() THEN NEXT FIELD sfb01 END IF  #TQC-C50063 add 

#TQC-C50063--mark--str--
#         IF NOT cl_null(tm.sfb01) THEN 
##No.FUN-550055  --start             
#            LET g_t1=tm.sfb01[1,g_doc_len]                                            
#            CALL s_check_no("asf",g_t1,g_today,"1","sfb_file","sfb01","")          
#              RETURNING li_result,tm.sfb01                                     
#            IF (NOT li_result) THEN                                             
#               NEXT FIELD sfb01                                                 
#            END IF  
#    #TQC-AC0238   --start        
#            CALL i520_sfb01()          
#            IF NOT cl_null(g_errno) THEN
#              CALL cl_err(tm.sfb01,g_errno,0)
#              LET  tm.sfb01 = NULL
#              DISPLAY BY NAME tm.sfb01
#              NEXT FIELD sfb01
#            END IF                                                                  
#    #TQC-AC0238   --end            
### No:2525 modify 1998/12/13 --------------------------
##           LET g_t1=tm.sfb01[1,3]
##           CALL s_mfgslip(g_t1,'asf','1')
##           IF NOT cl_null(g_errno) THEN                        #抱歉, 有問題
##              CALL cl_err(g_t1,g_errno,0) NEXT FIELD sfb01
##           END IF
### -------------------------------------------------------
##           CALL s_smyauno(tm.sfb01,tm.sfb81) RETURNING i,tm.sfb01
##           DISPLAY BY NAME tm.sfb01
#           #start FUN-590067 remark
#           ##No.FUN-560106--begin
#           #BEGIN WORK 
#           ##No.FUN-560106--end   
#           #CALL s_auto_assign_no("asf",tm.sfb01,tm.sfb81,"1","sfb_file","sfb01","","","")
#           #  RETURNING li_result,tm.sfb01                                     
#           #DISPLAY BY NAME tm.sfb01
#           #end FUN-590067 remark                                           
##NO.Fun-550055 --end    
#         END IF
#       #MOD-4B0175
#TQC-C50063--mark--end--

      AFTER FIELD sfb82
         CALL p520_check_sfb82()   #TQC-C50063 add
         #TQC-C50063--mark--str--
         #IF cl_null(tm.sfb82) THEN
         #    LET g_null_sfb82 = 'Y'
         #ELSE
         #    LET g_null_sfb82 = 'N'
         #END IF
         #TQC-C50063--mark--end-- 
       #MOD-4B0175(end)
 ##MOD-4B0215 end -------------------------------------------------
 
     #--------------No.TQC-710025 add
      AFTER INPUT
         #TQC-C50063--add--str--
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            CLOSE WINDOW p520
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      
            EXIT PROGRAM
         END IF
         IF NOT p520_check_sfb01() THEN NEXT FIELD sfb01 END IF 
         CALL p520_check_sfb82()
         #TQC-C50063--add--end--
         IF NOT cl_null(tm.sfb01) THEN 
            LET g_t1=tm.sfb01[1,g_doc_len]                                            
         END IF
     #--------------No.TQC-710025 end
 
 
      ON ACTION CONTROLP
         CASE
#TQC-D70003---add--star---
            WHEN INFIELD(ver_no)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_mss_v"
               CALL cl_create_qry() RETURNING tm.ver_no 
               DISPLAY BY NAME tm.ver_no
               NEXT FIELD ver_no
#TQC-D70003--add---end------
            WHEN INFIELD(sfb01) #order nubmer
#              LET g_t1=sfb.sfb01[1,3]
               LET g_t1=sfb.sfb01[1,g_doc_len]             #No.FUN-550055
               LET g_sql = " (smy73 <> 'Y' OR smy73 is null)"   #TQC-AC0238
               CALL smy_qry_set_par_where(g_sql)                #TQC-AC0238
               CALL q_smy(FALSE,FALSE,g_t1,'ASF','1') RETURNING g_t1 #TQC-670008
               LET tm.sfb01=g_t1         #MOD-4B0215  modify
               DISPLAY BY NAME tm.sfb01  #MOD-4B0215  modify 
               NEXT FIELD sfb01
            WHEN INFIELD(sfb82) #製造部門
#              CALL q_gem(10,2,sfb.sfb82) RETURNING sfb.sfb82
#              CALL FGL_DIALOG_SETBUFFER( sfb.sfb82 )
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem"
               #LET g_qryparam.default1 = sfb.sfb82
               #CALL cl_create_qry() RETURNING sfb.sfb82
               #NO.TQC-5B0061 START--
               LET g_qryparam.default1 = tm.sfb82
               CALL cl_create_qry() RETURNING tm.sfb82
#              CALL FGL_DIALOG_SETBUFFER( sfb.sfb82 )
               #DISPLAY BY NAME sfb.sfb82
               DISPLAY BY NAME tm.sfb82
               #NO.TQC-5B0061 END---
               NEXT FIELD sfb82
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      ON ACTION exit  #加離開功能genero
         LET INT_FLAG = 1
         EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
         LET g_change_lang = TRUE        #->No.FUN-570125
         EXIT INPUT
 
   END INPUT
#NO.FUN-570125 start----
#   IF INT_FLAG THEN
#      RETURN
#   END IF
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p520
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "amrp520"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('amrp520','9031',1)
      ELSE
         LET g_wc=cl_replace_str(g_wc, "'", "\"")
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",g_wc CLIPPED,"'",
                      " '",tm.ver_no CLIPPED,"'",
                      " '",tm.sfb01 CLIPPED,"'",
                      " '",tm.sfb81 CLIPPED,"'",
                      " '",tm.sfb82 CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('amrp520',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p520
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
   EXIT WHILE
END WHILE
#->No.FUN-570125 ---end---
 
#NO.FUN-570125 MARK-- 
# #MOD-4B0215 add
#   LET sfb.sfb01 = tm.sfb01
#   LET sfb.sfb81 = tm.sfb81
#   LET sfb.sfb82 = tm.sfb82
#NO.FUN-570125 MARK-- 


 
END FUNCTION
 
FUNCTION p520()
   DEFINE l_name           LIKE type_file.chr20,   #NO FUN-680082 VARCHAR(20)  # External(Disk) file name
          l_sql            LIKE type_file.chr1000, #NO FUN-680082 VARCHAR(600) # RDSQL STATEMENT
          l_chr            LIKE type_file.chr1,    #NO FUN-680082 VARCHAR(1)
          l_za05           LIKE za_file.za05       #NO FUN-680082 VARCHAR(40)
   DEFINE l_cnt0           LIKE type_file.num5     #FUN-6B0064
   DEFINE l_ima111         LIKE ima_file.ima111    #FUN-970027
   DEFINE l_lot_no         STRING                  #FUN-A80102
   DEFINE l_cnt            LIKE type_file.num5     #FUN-A80102
   DEFINE l_snum,l_enum    STRING                  #FUN-A80102
   DEFINE l_ssn,l_esn      LIKE type_file.num20    #FUN-A80102
   DEFINE l_avg_sfb08,l_tol_sfb08,l_sum_sfb08  LIKE sfb_file.sfb08    #FUN-A80102
   DEFINE l_sfb919         LIKE sfb_file.sfb919    #FUN-A80102
   DEFINE l_str            STRING                  #FUN-A90057
   DEFINE tok1             base.StringTokenizer    #FUN-A90057

#NO.FUN-570125 START--
   IF g_bgjob = 'Y' THEN
      LET g_t1=tm.sfb01[1,g_doc_len]
   END IF
 
#BUG-4B0215 add
  #LET sfb.sfb01 = tm.sfb01    #FUN-970027
   LET sfb.sfb81 = tm.sfb81
   LET sfb.sfb82 = tm.sfb82
##
#NO.FUN-570125 end------
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   DECLARE amrp520_za_cur CURSOR FOR
   SELECT za02,za05 FROM za_file
    WHERE za01 = "amrp520" AND za03 = g_lang
   FOREACH amrp520_za_cur INTO g_i,l_za05
    LET g_x[g_i] = l_za05
   END FOREACH
  #SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'amrp520'  #FUN-970027
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'amrp520' #FUN-970027
  #IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF #FUN-970027
  #FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR #FUN-970027
 
  LET g_sql="SELECT mss_file.*,ima111 FROM mss_file,ima_file,bma_file", #FUN-970027 add ima111
            " WHERE mss01=ima01 AND mss09 > 0 AND mss10='N'",
            "   AND ima08<>'P'",   #採購料件 (Purchase)
             "   AND mss_v='",tm.ver_no,"'",    #MOD-4B0215 modify
            "   AND ",g_wc CLIPPED,
            "   AND bmaacti = 'Y'",  #CHI-740001
            "   AND bma05 IS NOT NULL ",#BugNo:3596
           # "   AND bma05 <= '",sfb.sfb81,"'",
            "   AND bma01 = mss01 ",
             "  AND bma06 = ima910 ",  #FUN-550110
             " ORDER BY mss01,mss03"     #MOD-4B0079 ORDER BY 回歸到g_sql內
 
   PREPARE p520_p FROM g_sql
   DECLARE p520_c CURSOR FOR p520_p
   #LET l_name='amrp520.out'
  #CALL cl_outnam('amrp520') RETURNING l_name  #No.MOD-8A0124 mark
   LET l_name = g_name   #No.MOD-8A0124
   START REPORT p520_rep TO l_name
   LET g_pageno = 0
 
   LET l_cnt0 = 0  #FUN-6B0064
   FOREACH p520_c INTO mss.*,l_ima111  #FUN-970027 add ima111
      #FUN-970027--begin--add--
      IF NOT cl_null(l_ima111) THEN
         LET sfb.sfb01 = l_ima111
      ELSE
         LET sfb.sfb01 = tm.sfb01
      END IF
      #FUN-970027--end--add--
      #FUN-A80102(S)
      IF g_sma.sma1431='Y' THEN   
        #工單不展開號機,因為此處無法指定號機數量
        #LET tok1 = base.StringTokenizer.create(tm.msr919,",")
        #WHILE tok1.hasMoreTokens()
        #   LET l_lot_no = tok1.nextToken()
        #   IF l_lot_no.getlength() > 0 THEN
        #      CALL s_machine_de_code(mss.mss01,l_lot_no) RETURNING l_snum,l_enum
        #      LET l_ssn = l_snum
        #      LET l_esn = l_enum
        #      IF l_esn < l_ssn THEN
        #         CONTINUE FOREACH
        #      END IF
        #      LET l_sum_sfb08 = mss.mss09
        #      LET l_avg_sfb08 = s_trunc(l_sum_sfb08 / (l_esn - l_ssn + 1),0)
        #      LET l_tol_sfb08 = 0
        #      LET mss.mss09 = l_avg_sfb08
        #      FOR l_cnt = l_ssn TO l_esn
        #         LET l_tol_sfb08 = l_tol_sfb08 + l_avg_sfb08
        #         IF (l_cnt = l_esn) AND (l_tol_sfb08 < l_sum_sfb08) THEN
        #            #將數量尾差寫到最後一筆
        #            LET mss.mss09 = l_sum_sfb08 - l_tol_sfb08
        #         END IF
        #         LET l_sfb919 = s_machine_en_code(mss.mss01,l_cnt)
        #         OUTPUT TO REPORT p520_rep(mss.*,l_sfb919)
        #      END FOR
        #   END IF      
        #END WHILE   
        OUTPUT TO REPORT p520_rep(mss.*,tm.msr919)
      ELSE   
      #FUN-A80102(E)
         OUTPUT TO REPORT p520_rep(mss.*,'')         
      END IF
      LET l_cnt0 = l_cnt0 + 1  #FUN-6B0064
   END FOREACH
   FINISH REPORT p520_rep
  #FUN-6B0064--begin
   IF l_cnt0 = 0 THEN
     CALL cl_err('','mfg3160',1)
     LET g_success = 'N'
     RETURN
   END IF
  #FUN-6B0064--end
   #bug:4306 modify by Carol.......................................
  #CHI-AC0040---mark---start---
  #CALL cl_prt(l_name,' ','1',g_len)
  #
  #WHILE TRUE
  #   IF cl_confirm('amr-078') THEN 
  #      LET g_success = 'Y' EXIT WHILE
  #   ELSE
  #      LET g_success = 'N' EXIT WHILE
  #   END IF
  #END WHILE
  #CHI-AC0040---mark---end---
   # bug end .................................................
 
END FUNCTION
 
REPORT p520_rep(mss,l_sfb919)
DEFINE mss		RECORD LIKE mss_file.*
DEFINE l_ima08          LIKE ima_file.ima08,
         l_smy57        LIKE smy_file.smy57,#TQC-640143
         l_ima02        LIKE ima_file.ima02,
         l_chr          LIKE type_file.chr3,    #NO FUN-680082 VARCHAR(03)
         l_last_sw      LIKE type_file.chr1     #NO FUN-680082 VARCHAR(01)
DEFINE li_result        LIKE type_file.num5     #NO FUN-680082 VARCHAR(1)  #No.FUN-550060
DEFINE l_factor         LIKE type_file.num20_6  #No.TQC-760014 
DEFINE l_ima25          LIKE ima_file.ima25     #No.TQC-760014 
DEFINE l_ima55          LIKE ima_file.ima55     #No.TQC-760014 
DEFINE g_sw             LIKE type_file.chr1     #No.TQC-760014 
DEFINE l_cnt1           LIKE type_file.num5     #No.MOD-790143 add
DEFINE l_cnt2           LIKE type_file.num5     #No.MOD-790143 add
DEFINE l_sfbi           RECORD LIKE sfbi_file.* #No.FUN-7B0018
DEFINE l_ima111         LIKE ima_file.ima111    #No.FUN-920183 add
DEFINE l_t1             LIKE sfb_file.sfb01     #No.FUN-920183 add
DEFINE l_sfb919         LIKE sfb_file.sfb919    #FUN-A80102
#darcy:2024/08/02 add s---
define l_rate           like sfb_file.sfb08     
define l_date           date
define l_imaud10        like ima_file.imaud10
#darcy:2024/08/02 add e---

  OUTPUT TOP MARGIN g_top_margin 
         LEFT MARGIN g_left_margin 
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line   #No.MOD-580242
 
  #ORDER BY mss.mss01,mss.mss03                    #MOD-4B0079   在此加ORDER BY ,ORACLE版本會COMMIT WORK
  FORMAT
    PAGE HEADER
      LET l_last_sw = 'n'
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT g_dash[1,g_len] CLIPPED
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED
      PRINT g_dash1
 
    ON EVERY ROW
#No.FUN-920183 begin ------
    #如果ima_file中存在缺省工單單別，則使用ima111作為工單單別
    SELECT ima111 INTO l_ima111
      FROM ima_file 
     WHERE ima01 = mss.mss01
    IF NOT cl_null(l_ima111) THEN
       LET sfb.sfb01 = l_ima111
       LET l_t1 = g_t1
       LET g_t1 = l_ima111
    END IF
#No.FUN-920183 end --------
#No.FUN-560060-begin
      IF cl_null(sfb.sfb01[g_no_sp,g_no_ep]) THEN
        CALL s_auto_assign_no("asf",sfb.sfb01,sfb.sfb81,"1","sfb_file","sfb01","","","")
          RETURNING li_result,sfb.sfb01
        IF (NOT li_result) THEN                                                   
           LET g_success='N' 
           CALL cl_batch_bg_javamail("N")     # No.FUN-570125
           CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
           EXIT PROGRAM
        END IF                                                                    
#     IF cl_null(sfb.sfb01[5,10]) THEN
#        CALL s_smyauno(sfb.sfb01,sfb.sfb81) RETURNING i,sfb.sfb01
#        IF i THEN LET g_success='N' EXIT PROGRAM END IF
      END IF
      LET g_sfb01 = sfb.sfb01
#No.FUN-560060-end   
## No:2367 modify 1998/07/14 ------------------------
#     SELECT ima08 INTO l_ima08 FROM ima_file WHERE ima01=sfb.sfb05
      SELECT ima08 INTO l_ima08 FROM ima_file WHERE ima01=mss.mss01
#     IF STATUS THEN LET l_ima08='1' END IF
      IF STATUS THEN LET l_ima08='M' END IF
### -------------------------------------------------
      IF l_ima08='M' OR l_ima08='T' THEN LET sfb.sfb02='1' END IF
      IF l_ima08='S' THEN LET sfb.sfb02='7' END IF
      LET sfb.sfb04  ='1'
      LET sfb.sfb05  =mss.mss01
      #SELECT smy57 INTO l_smy57 FROM smy_file WHERE smyslip=g_t1  #MOD-D10279        
      SELECT smy57,smyapr INTO l_smy57,sfb.sfbmksg FROM smy_file WHERE smyslip=g_t1  #MOD-D10279        
      IF l_smy57[1,1]='Y' THEN 
         SELECT ima94 INTO sfb.sfb06 FROM ima_file WHERE ima01=sfb.sfb05
      END IF
       #MOD-4B0175     
      IF g_null_sfb82 = 'Y' AND sfb.sfb02 = '7'  THEN    #No.MOD-790071 modify
          LET sfb.sfb82 = NULL
          SELECT ima54 INTO sfb.sfb82
            FROM ima_file
           WHERE ima01 = sfb.sfb05
          #MOD-D50269 mark begin------------------
          #IF cl_null(sfb.sfb82) THEN
          #    CALL cl_err(sfb.sfb05,'apm-571',1)
          #END IF
          #MOD-D50269 mark end--------------------
      END IF
       #MOD-4B0175
      #No.TQC-760014    --begin
       SELECT ima25,ima55 INTO l_ima25,l_ima55 
         FROM ima_file
        WHERE ima01=sfb.sfb05
       CALL s_umfchk(sfb.sfb05,l_ima25,l_ima55) RETURNING g_sw,l_factor 
       IF cl_null(l_factor) THEN LET l_factor=1 END IF
      #No.TQC-760014    --end  
      LET sfb.sfb071 =mss.mss03
     #LET sfb.sfb08  =mss.mss09    #No.TQC-760014 mark
      LET sfb.sfb08  =mss.mss09*l_factor  #No.TQC-760014 
      LET sfb.sfb081 =0
      LET sfb.sfb09  =0
      LET sfb.sfb10  =0
      LET sfb.sfb11  =0
      LET sfb.sfb111 =0
      LET sfb.sfb12  =0
      LET sfb.sfb13  =mss.mss11
      LET sfb.sfb15  =mss.mss03
      LET sfb.sfb20  =mss.mss03
      LET sfb.sfb22  ='MRP',mss.mss_v,'-',mss.mss00 USING '&&&&'
      LET sfb.sfb23  ='N'
      LET sfb.sfb24  ='N'
      LET sfb.sfb29  ='Y'
      LET sfb.sfb32  =0
      LET sfb.sfb34  =1
      LET sfb.sfb35  ='N'
      LET sfb.sfb39  ='1'
      LET sfb.sfb41  ='N'
      LET sfb.sfb42  =0
      LET sfb.sfb44  =g_user    #MOD-A60099 add
      LET sfb.sfb87  ='N'
      #LET sfb.sfbmksg  ='N'     #TQC-9B0118 add #MOD-D10118
      IF cl_null(sfb.sfbmksg) THEN LET sfb.sfbmksg = 'N' END IF  #MOD-D10279
      LET sfb.sfb93  =l_smy57[1,1]           #NO:4636 製程否
      LET sfb.sfb94  =l_smy57[2,2]           #NO:4636 FQC否 
      LET sfb.sfb1002='N'                    #保稅核銷否 #FUN-6B0044
      LET sfb.sfb25  =NULL                   #實際開工日 #No.TQC-710025 add
      #-----No.TQC-610003-----
      LET sfb.sfb36  =NULL                   #工單發料結束日期      #No.TQC-770031 add    
      LET sfb.sfb37  =NULL                   #工單發料及工時結束日  #No.TQC-770031 add   
      LET sfb.sfb38  =NULL                   #工單成本會計結束日期  #No.TQC-770031 add  
      LET sfb.sfbdate=NULL                   #最近修改日            #No.TQC-770031 add   
      LET sfb.sfb99  ='N'                    #重工否                #No.MOD-780079 add  
      LET sfb.sfb919 =l_sfb919               #FUN-A80102
      SELECT ima910 INTO sfb.sfb95
        FROM ima_file
       WHERE ima01 = sfb.sfb05
      IF cl_null(sfb.sfb95) THEN
         LET sfb.sfb95 = ' '
      END IF
      #-----No.TQC-610003-----
## No:2367 modify 1998/07/14 ----
      LET sfb.sfb98  =' ' 
## ------------------------------
      LET sfb.sfbacti = 'Y'
      LET sfb.sfbuser = g_user
      LET sfb.sfbgrup = g_grup
      LET sfb.sfbdate = g_today   #FUN-970027
      LET sfb.sfbplant = g_plant #FUN-980004 add
      LET sfb.sfblegal = g_legal #FUN-980004 add
      SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01=sfb.sfb05
      PRINT COLUMN g_c[31],g_sfb01,                #No.FUN-560060
            COLUMN g_c[32],sfb.sfb05,              #No.MOD-7C0215 modify
            COLUMN g_c[33],l_ima02,
            COLUMN g_c[34],cl_numfor(sfb.sfb08,34,g_azi03), 
            COLUMN g_c[35],sfb.sfb13,
            COLUMN g_c[36],sfb.sfb15,
            COLUMN g_c[37],sfb.sfb22
      #MOD-640187 -----add-----
      #預設委外型態sfb100
      IF cl_null(sfb.sfb100) THEN
          SELECT smy57 
            INTO l_smy57 
            FROM smy_file  
           WHERE smyslip=g_t1
          LET sfb.sfb100=l_smy57[6,6]
          IF STATUS = 100 THEN
              LET sfb.sfb100='1'
          END IF
      END IF
      #MOD-640187 -----end-----
      
#CHI-B80053 -- begin --
      IF cl_null(sfb.sfb98) THEN
         SELECT ima34 INTO sfb.sfb98 FROM ima_file
          WHERE ima01 = sfb.sfb05
      END IF
#CHI-B80053 -- end --

      LET sfb.sfboriu = g_user      #No.FUN-980030 10/01/04
      LET sfb.sfborig = g_grup      #No.FUN-980030 10/01/04
      LET sfb.sfb104 = 'N'          #No.TQC-A50087 add
      #No.MOD-A90066  --Begin                                                   
      LET sfb.sfb18  = ''                                                       
      LET sfb.sfb19  = ''                                                       
      LET sfb.sfb92  = ''           #TQC-AB0143                                              
      LET sfb.sfb251 = g_today                                                  
      LET sfb.sfb43  = '0'   #TQC-AC0240
      #No.MOD-A90066  --End
      #darcy:2024/08/02 add s---
      # 增加工单的客制字段
      # 按照排版数和生产良率进行整数PNL开单
      let sfb.sfbud08 = sfb.sfb08  # 记录原始数量

      let l_rate = 0
      select imaud10 into l_imaud10 from ima_file where ima01 = sfb.sfb05
      call i255_get_roduct_rate(new[g_i].new_part) returning l_rate,l_date
      if not cl_null(l_rate) and l_rate >0 and l_rate < 100 then
         #有维护良率 
         select ceil((sfb.sfb08/(l_rate/100))/l_imaud10)*l_imaud10 into sfb.sfb08 from dual
      end if
      let sfb.sfbud09 = l_rate  # 记录损耗率
      let sfb.sfbud07 = sfb.sfb08 / l_imaud10
      let sfb.sfbud10 = l_imaud10

      # 更新订单已转数量
      # TODO

      #darcy:2024/08/02 add e---
      INSERT INTO sfb_file VALUES(sfb.*)
      IF STATUS THEN 
#         CALL cl_err('ins sfb:',STATUS,1) #No.FUN-660107
          CALL cl_err3("ins","sfb_file",sfb.sfb01,"",STATUS,"","ins sfb:",1)        #NO.FUN-660107 
          CALL cl_batch_bg_javamail("N")     # No.FUN-570125
          CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
          EXIT PROGRAM 
      END IF
      #NO.FUN-7B0018 08/02/26 add --begin
      IF NOT s_industry('std') THEN
         INITIALIZE l_sfbi.* TO NULL
         LET l_sfbi.sfbi01 = sfb.sfb01
         IF NOT s_ins_sfbi(l_sfbi.*,'') THEN
            CALL cl_batch_bg_javamail("N")
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
         END IF
      END IF
      #NO.FUN-7B0018 08/02/26 add --end
      IF g_sma.sma27='1' THEN   #
         #-------------No.FUN-670041 modify
         #CALL s_cralc(sfb.sfb01,sfb.sfb02,sfb.sfb05,g_sma.sma29,
         CALL s_cralc(sfb.sfb01,sfb.sfb02,sfb.sfb05,'Y',
         #-------------No.FUN-670041 end
                     #sfb.sfb08,sfb.sfb071,'Y',g_sma.sma71,0,sfb.sfb95)  #No.TQC-610003
                     sfb.sfb08,sfb.sfb071,'Y',g_sma.sma71,0,'',sfb.sfb95)  #No.TQC-610003 FUN-BC0008 mod
                     RETURNING g_cnt
         CALL p301(sfb.sfb01, sfb.sfb81, 99, 'N', TRUE) #darcy:2024/08/05 add
      END IF
     #-----------No.MOD-790143 add
       #單身總筆數
       SELECT COUNT(*) INTO l_cnt1 FROM sfa_file WHERE sfa01 = sfb.sfb01 
       
       #單身sfa11='E'筆數
       SELECT COUNT(*) INTO l_cnt2 FROM sfa_file WHERE sfa01 = sfb.sfb01 
                                                   AND sfa11 = 'E'
 
       IF cl_null(l_cnt1) THEN LET l_cnt1 = 0 END IF
       IF cl_null(l_cnt2) THEN LET l_cnt2 = 0 END IF
       IF l_cnt2 >= l_cnt1 AND l_cnt1 > 0 THEN
          UPDATE sfb_file SET sfb39 = '2'
                          WHERE sfb01 = sfb.sfb01
       END IF
     #-----------No.MOD-790143 end
      #-- modi in 01/05/07--
      #---- 使用製程追蹤 -----
      IF g_sma.sma26='2' THEN
         CALL p520_crrut()
      END IF
      #-----------------------
      UPDATE mss_file SET mss10='Y'
         WHERE mss01=mss.mss01 AND mss02=mss.mss02 AND mss03=mss.mss03
      IF STATUS THEN 
#      CALL cl_err('upd mss10:',STATUS,1)  #No.FUN-660107
       CALL cl_err3("upd","mss_file",mss.mss01,mss.mss02,STATUS,"","upd mss10:",1)        #NO.FUN-660107
          CALL cl_batch_bg_javamail("N")     # No.FUN-570125
          CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
          EXIT PROGRAM 
      END IF
#No.FUN-560060
#     LET sfb.sfb01[8,10]=(sfb.sfb01[8,10]+1) USING '&&&'    
#No.FUN-920183 begin ------
    #如果ima_file中存在缺省工單單別，則使用ima111作為工單單別
    #還原g_t1 
    IF NOT cl_null(l_ima111) THEN
       LET g_t1 = l_t1
    END IF
#No.FUN-920183 end --------
      LET sfb.sfb01 = g_t1                                  
#end No.FUN-560060
 
   ON LAST ROW
      LET l_last_sw = 'y'
      PRINT g_dash CLIPPED
      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7]
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash CLIPPED
         PRINT g_x[4] CLIPPED,g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6]
         ELSE SKIP 2 LINE
      END IF
 
END REPORT
 
FUNCTION p520_crrut()
  DEFINE l_ecb RECORD LIKE ecb_file.*
  DEFINE l_ima571  LIKE ima_file.ima571
  DEFINE l_ecu01   LIKE ecu_file.ecu01
  DEFINE l_ecu02   LIKE ecu_file.ecu02
 
  IF NOT cl_null(sfb.sfb06) THEN
      #---->check 製程追蹤是否有投入等量
      SELECT COUNT(*) INTO g_cnt FROM ecm_file
       WHERE ecm01=sfb.sfb01
         AND (ecm301+ecm302+ecm303)<>0  #(良入 + 重入)
      IF g_cnt > 0 THEN CALL cl_err('','asf-386',0) RETURN END IF
      #生產日報已有資料
      SELECT COUNT(*) INTO g_cnt FROM shb_file WHERE shb05 = sfb.sfb01
                                                 AND shbconf = 'Y'   #FUN-A70095
      IF g_cnt > 0 THEN CALL cl_err('','asf-025',0) RETURN END IF
 
      SELECT COUNT(*) INTO g_cnt FROM ecm_file WHERE ecm01=sfb.sfb01 
      IF g_cnt > 0 THEN
           DELETE FROM ecm_file WHERE ecm01=sfb.sfb01
           IF SQLCA.sqlerrd[3]=0 THEN 
#              CALL cl_err('','asf-026',0) #No.FUN-660107
               CALL cl_err3("del","ecm_file",sfb.sfb01,"","asf-026","","",0)        #NO.FUN-660107 
              RETURN
           END IF  
      END IF
      #99/06/23----展追蹤先用--->ima571產品料號+ecu02製程編號
      SELECT ima571 INTO l_ima571 FROM ima_file 
       WHERE ima01=sfb.sfb05
 
      IF cl_null(l_ima571) THEN LET l_ima571=' ' END IF # when ima571=''
 
      SELECT ecu01 FROM ecu_file
       WHERE ecu01=l_ima571 AND ecu02=sfb.sfb06
         AND ecuacti = 'Y'  #CHI-C90006
      IF STATUS THEN
         SELECT ecu01 FROM ecu_file
                WHERE ecu01=sfb.sfb05 
                  AND ecu02=sfb.sfb06
                  AND ecuacti = 'Y'  #CHI-C90006
         IF STATUS THEN
#            CALL cl_err('sel ecu:',STATUS,0) #No.FUN-660107
             CALL cl_err3("sel","ecu_file",sfb.sfb05,sfb.sfb06,STATUS,"","sel ecu:",0)        #NO.FUN-660107
            RETURN
         ELSE
            LET l_ecu01=sfb.sfb05
         END IF
      ELSE
         LET l_ecu01=l_ima571
      END IF
      CALL s_schdat(0,sfb.sfb13,sfb.sfb15,sfb.sfb071,
                    sfb.sfb01,sfb.sfb06,sfb.sfb02,l_ecu01,    
                    sfb.sfb08,2)
         RETURNING g_cnt,sfb.sfb13,sfb.sfb15,sfb.sfb32,sfb.sfb24
      #---------------------------------------------------
         DISPLAY BY NAME sfb.sfb13,sfb.sfb15,sfb.sfb24
    SELECT count(*) INTO g_cnt FROM ecm_file WHERE ecm01 = sfb.sfb01
    IF g_cnt > 0 THEN LET sfb.sfb24 = 'Y' ELSE LET sfb.sfb24 = 'N' END IF
    SELECT count(*) INTO g_cnt FROM sfb_file
               WHERE sfb01=sfb.sfb01
                 AND (sfb13 IS NOT NULL AND sfb15 IS NOT NULL )
    IF g_cnt > 0 THEN
      UPDATE sfb_file SET sfb24=sfb.sfb24 WHERE sfb01=sfb.sfb01
      SELECT sfb13,sfb15 INTO sfb.sfb13,sfb.sfb15 FROM sfb_file
                WHERE sfb01 = sfb.sfb01
      DISPLAY BY NAME sfb.sfb13,sfb.sfb15,sfb.sfb24
    ELSE
      UPDATE sfb_file SET sfb13=sfb.sfb13,
                          sfb15=sfb.sfb15,
                          sfb24=sfb.sfb24
                WHERE sfb01 = sfb.sfb01
    END IF
   END IF
END FUNCTION 
#TQC-C50063--add--str--  
FUNCTION p520_check_sfb01()
   DEFINE li_result        LIKE type_file.num5  

   IF NOT cl_null(tm.sfb01) THEN 
#No.FUN-550055  --start             
      LET g_t1=tm.sfb01[1,g_doc_len]                                            
      CALL s_check_no("asf",g_t1,g_today,"1","sfb_file","sfb01","")          
         RETURNING li_result,tm.sfb01                                     
      IF (NOT li_result) THEN                                             
         #NEXT FIELD sfb01                                                 
         RETURN FALSE 
      END IF  
    #TQC-AC0238   --start        
      CALL i520_sfb01()          
      IF NOT cl_null(g_errno) THEN
         CALL cl_err(tm.sfb01,g_errno,0)
         LET  tm.sfb01 = NULL
         DISPLAY BY NAME tm.sfb01
         #NEXT FIELD sfb01
         RETURN FALSE
      END IF                                                                  
    #TQC-AC0238   --end            
## No:2525 modify 1998/12/13 --------------------------
#           LET g_t1=tm.sfb01[1,3]
#           CALL s_mfgslip(g_t1,'asf','1')
#           IF NOT cl_null(g_errno) THEN                        #抱歉, 有問題
#              CALL cl_err(g_t1,g_errno,0) NEXT FIELD sfb01
#           END IF
## -------------------------------------------------------
#           CALL s_smyauno(tm.sfb01,tm.sfb81) RETURNING i,tm.sfb01
#           DISPLAY BY NAME tm.sfb01
           #start FUN-590067 remark
           ##No.FUN-560106--begin
           #BEGIN WORK 
           ##No.FUN-560106--end   
           #CALL s_auto_assign_no("asf",tm.sfb01,tm.sfb81,"1","sfb_file","sfb01","","","")
           #  RETURNING li_result,tm.sfb01                                     
           #DISPLAY BY NAME tm.sfb01
           #end FUN-590067 remark                                           
#NO.Fun-550055 --end    
   END IF
       #MOD-4B0175
   RETURN TRUE
END FUNCTION

FUNCTION p520_check_sfb82()
    IF cl_null(tm.sfb82) THEN
        LET g_null_sfb82 = 'Y'
    ELSE
        LET g_null_sfb82 = 'N'
    END IF
END FUNCTION
#TQC-C50063--add--end--
