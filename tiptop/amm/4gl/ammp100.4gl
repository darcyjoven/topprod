# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: ammp100.4gl
# Descriptions...: 加工需求自動產生作業
# Date & Author..: 00/12/13 By Faith
# Modify.........: No.FUN-550054 05/05/17 By yoyo單據編號格式放大
# Modify.........: No.FUN-560060 05/06/17 By day 單據編號修改
# Modify.........: No.FUN-570124 06/03/07 By yiting 批次背景執行
# Modify.........: No.FUN-660094 06/06/12 By CZH cl_err-->cl_err3
# Modify.........: No.TQC-670008 06/07/05 By kim 將 g_sys 變數改成寫死系統別(要大寫)
# Modify.........: No.FUN-680100 06/08/28 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.TQC-720052 07/03/20 By Judy 開窗字段"需求類型"錄入任何值不報錯
# Modify.........: No.TQC-750221 07/05/29 By jamie '需求日期' 應為日期欄位但目前僅可輸入1碼
# Modify.........: No.FUN-980004 09/08/26 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2) 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc,g_sql       STRING                   #No.FUN-580092 HCN        #No.FUN-680100
DEFINE g_date           LIKE type_file.dat       #No.FUN-680100 DATE
#DEFINE g_needda        LIKE type_file.chr1      #No.TQC-750221 mark  #FUN-680100 DATE
DEFINE g_needda         LIKE type_file.dat       #No.TQC-750221 mod   #FUN-680100 DATE
DEFINE begin_no         LIKE oea_file.oea01      #No.FUN-680100 VARCHAR(16)#No.FUN-550054
DEFINE g_start,g_end    LIKE oea_file.oea01      #No.FUN-680100 VARCHAR(16)#No.FUN-550054 
DEFINE g_n_mma01        LIKE mma_file.mma01 
DEFINE g_t1             LIKE oay_file.oayslip    #No.FUN-550054        #No.FUN-680100 VARCHAR(5)
DEFINE ano              LIKE oay_file.oayslip    #No.FUN-680100 VARCHAR(5)#No.FUN-550054
DEFINE mma14            LIKE mma_file.mma14
 
DEFINE   g_i             LIKE type_file.num5      #count/index for any purpose        #No.FUN-680100 SMALLINT
DEFINE g_change_lang     LIKE type_file.chr1      #No.FUN-680100 VARCHAR(1)#No.FUN-570124
DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680100 SMALLINT
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0076
   DEFINE l_flag        LIKE type_file.chr1      #No.FUN-570124        #No.FUN-680100 VARCHAR(1)
   DEFINE ls_date       STRING                   #No.FUN-680100 #No.FUN-570124
 
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   #No.FUN-570124--start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc     = ARG_VAL(1)
   LET ls_date  = ARG_VAL(2)
   LET g_date   = cl_batch_bg_date_convert(ls_date)
   LET mma14    = ARG_VAL(3)
   LET ano      = ARG_VAL(4)
   LET ls_date  = ARG_VAL(5)
   LET g_needda = cl_batch_bg_date_convert(ls_date)
   LET g_bgjob  = ARG_VAL(6)
   IF cl_null(g_bgjob)THEN
       LET g_bgjob="N"
   END IF
   #No.FUN-570124--end--
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AMM")) THEN
      EXIT PROGRAM
   END IF
 
#NO.FUN-570123 MARK-------
#   OPEN WINDOW p100_w AT p_row,p_col WITH FORM "amm/42f/ammp100"
################################################################################
# START genero shell script ADD
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
#    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
#NO.FUN-570123 MARK--------                              
 
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
   WHILE TRUE
#NO.FUN-570123 --start--------
   IF g_bgjob="N" THEN
       CALL p100()
       IF cl_sure(21,21) THEN
          LET g_success='Y'
          BEGIN WORK
          CALL p100_p()
          IF g_success='Y' THEN
             COMMIT WORK
             CALL cl_end2(1) RETURNING l_flag
          ELSE
             ROLLBACK WORK
             CALL cl_end2(2) RETURNING l_flag
          END IF
          IF l_flag THEN
             CONTINUE WHILE
          ELSE
             CLOSE WINDOW p100_w
             EXIT WHILE
          END IF
      ELSE
         CONTINUE WHILE
      END IF
  ELSE
      LET g_success='Y'
      BEGIN WORK
      CALL p100_p()
      IF g_success="Y" THEN
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF
      CALL cl_batch_bg_javamail(g_success)
      EXIT WHILE
   END IF
END WHILE
#      CALL p100()
#      IF INT_FLAG THEN EXIT WHILE END IF
#   END WHILE
#   CLOSE WINDOW p100_w
# No.FUN-570142--end--
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
END MAIN
 
FUNCTION p100()
#No.FUN-550054--begin
DEFINE li_result     LIKE type_file.num5          #No.FUN-680100 SMALLINT
#No.FUN-550054--end   
DEFINE lc_cmd        LIKE type_file.chr1000       #No.FUN-680100 VARCHAR(500)#No.FUN-570142
DEFINE l_n           LIKE type_file.num5          #TQC-720052
   CLEAR FORM
   CALL cl_opmsg('w')
 
    #No.FUN-570124--start--
      OPEN WINDOW p100_w AT p_row,p_col WITH FORM "amm/42f/ammp100"
          ATTRIBUTE(STYLE=g_win_style)
      CALL cl_ui_init()
      CLEAR FORM
    #No.FUN-570124--end--
 
   WHILE TRUE
      CONSTRUCT BY NAME g_wc ON mmg01,mmg02,mmg04,mmh03 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
        #CALL cl_dynamic_locale()
        #CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_change_lang = TRUE        #->No.FUN-570124
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
 
      
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('mmguser', 'mmggrup') #FUN-980030
#NO.FUN-570124  start-------
      IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
            LET INT_FLAG=0
            CLOSE WINDOW p100_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
      END IF
 
#      IF INT_FLAG THEN
#         RETURN 
#      END IF
#      IF g_wc = ' 1=1' THEN
#         CALL cl_err('','9046',0) CONTINUE WHILE
#         ELSE
#            EXIT WHILE
#      END IF
#   END WHILE
 
   LET g_date=g_today
   LET g_needda = NULL
   LET ano = NULL
   LET g_bgjob = "N"         #No.FUN-570124
 
   CALL cl_opmsg('a')
 
   #INPUT BY NAME g_date,mma14,ano,g_needda WITHOUT DEFAULTS 
   INPUT BY NAME g_date,mma14,ano,g_needda,g_bgjob WITHOUT DEFAULTS   #NO.FUN-570124
      AFTER FIELD g_date
         IF cl_null(g_date) THEN
            LET g_date = g_today
            NEXT FIELD g_date
         END IF
 
      AFTER FIELD ano   
         IF NOT cl_null(ano) THEN
#No.FUN-550054--begin
#            LET g_t1 = ano[1,3]
            LET g_t1 = ano[1,g_doc_len]
            CALL s_check_no("asf",g_t1,"","M","","","")
            RETURNING li_result,ano
            LET ano = s_get_doc_no(ano)
            DISPLAY BY NAME ano
            IF (NOT li_result) THEN
               NEXT FIELD ano
            END IF
#           CALL s_mfgslip(g_t1,'asf','M')        #檢查單別
#           IF NOT cl_null(g_errno) THEN                  #抱歉, 有問題
#              CALL cl_err(g_t1,g_errno,0)
#              NEXT FIELD ano 
#           END IF
#           IF g_smy.smyauno='N' THEN
#            # CALL cl_err(g_t1,g_errno,0)
#              ERROR "輸入之單別必須為自動編號 !"
#              NEXT FIELD ano 
#           END IF
#No.FUN-550054--end
         END IF
#TQC-720052.....begin
      AFTER FIELD mma14
         IF NOT cl_null(mma14) THEN
            SELECT COUNT(*) INTO l_n FROM mmi_file
             WHERE mmi01 = mma14 AND mmi03 = '2'
            IF l_n = 0 THEN
               CALL cl_err(mma14,'amm-111',0) 
               NEXT FIELD mma14
            END IF
         END IF
#TQC-720052.....end
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         call cl_cmdask()
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ano) # Class
               CALL q_smy(FALSE,TRUE,ano,'ASF','M') RETURNING ano #TQC-670008
#               CALL FGL_DIALOG_SETBUFFER( ano )
               DISPLAY ano TO FORMONLY.ano 
               NEXT FIELD ano 
            WHEN INFIELD(mma14)
#              CALL q_mmi(0,0,mma14,'2') RETURNING mma14
#              CALL FGL_DIALOG_SETBUFFER( mma14 )
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_mmi02"
               LET g_qryparam.default1 = mma14
               LET g_qryparam.arg1 = "2"
               CALL cl_create_qry() RETURNING mma14
#               CALL FGL_DIALOG_SETBUFFER( mma14 )
               DISPLAY BY NAME mma14
               NEXT FIELD mma14
            END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
#FUN-570124 --start-- 
     ON ACTION exit
        LET INT_FLAG = 1
        EXIT INPUT
#FUN-570124 ---end---
 
#FUN-570124 --start--
     ON ACTION locale
        LET g_change_lang = TRUE
        EXIT INPUT
#FUN-570124 ---end---
 
   END INPUT
 
#NO.FUN-570124 start--------
      IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
            LET INT_FLAG=0
            CLOSE WINDOW p100_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
      END IF
 
#   IF INT_FLAG THEN
#      RETURN
#   END IF
#   CALL p100_p()
    IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "ammp100"
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
          CALL cl_err('ammp100','9031',1)
        ELSE
         LET g_wc = cl_replace_str(g_wc,"'","\"")
         LET lc_cmd = lc_cmd CLIPPED,
                   " '",g_wc CLIPPED,"'",
                   " '",g_date   CLIPPED,"'",
                   " '",mma14    CLIPPED,"'",
                   " '",ano      CLIPPED,"'",
                   " '",g_needda CLIPPED,"'",
                   " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('ammp100',g_time,lc_cmd CLIPPED)
       END IF
         CLOSE WINDOW p100_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
     END IF
    EXIT WHILE
   END WHILE
#No.FUN-570124--end---
END FUNCTION
 
FUNCTION p100_p()
   DEFINE l_mmg   RECORD LIKE mmg_file.*
   DEFINE l_mmh   RECORD LIKE mmh_file.*
   DEFINE l_mma   RECORD LIKE mma_file.*
   DEFINE l_mma01 LIKE mma_file.mma01
   DEFINE l_cnt   LIKE type_file.num5      #No.FUN-680100 SMALLINT
   DEFINE l_str   LIKE type_file.chr1000   #No.FUN-680100 VARCHAR(200)
DEFINE li_result     LIKE type_file.num5   #No.FUN-560060        #No.FUN-680100 SMALLINT
 
    LET g_sql="SELECT mmg_file.*,mmh_file.* FROM mmg_file,mmh_file  WHERE ",
              " mmg01=mmh01 AND mmg02 = mmh011 AND ",
             "   mmgacti='Y' AND ",g_wc CLIPPED
    PREPARE p100_prepare FROM g_sql
    DECLARE p100_cs CURSOR WITH HOLD FOR p100_prepare
    LET g_success = 'Y'
    LET begin_no  = NULL
    LET l_cnt=0
 
#    BEGIN WORK  #NO.FUN-570124 MARK
    FOREACH p100_cs INTO l_mmg.*,l_mmh.*
      IF STATUS THEN CALL cl_err('p100(foreach):',STATUS,1) EXIT FOREACH END IF
 
     #增加輸入單別並自動編號
     #IF ano IS NULL THEN
     #  LET g_n_mma01=l_mmg.mmg01
     #ELSE
#No.FUN-560060-begin
        CALL s_auto_assign_no("asf",ano,g_date,"M","mma_file","mma01","","","")
          RETURNING li_result,g_n_mma01
        IF (NOT li_result) THEN                                                   
           RETURN                                                                 
        END IF                                                                    
#       CALL s_smyauno(ano,g_date) RETURNING g_i,g_n_mma01
#       IF g_i THEN RETURN  END IF 
#No.FUN-560060-end                                                        
     #END IF
      DECLARE mma_cus CURSOR FOR
      SELECT mma01  FROM mma_file
        WHERE mma02 = l_mmg.mmg01 AND mma021 = l_mmg.mmg02
              and mma03 = l_mmh.mmh02
      OPEN mma_cus
      FETCH mma_cus INTO l_mma01
         IF SQLCA.SQLCODE <> 100 THEN
         LET l_str = l_mmg.mmg01,"+",l_mmg.mmg02,"+",l_mmh.mmh02
                     ,"已開",l_mma01,"之需求單","請自行在需求維護作業確認無誤"
         ERROR l_str
         CONTINUE FOREACH
      END IF    
 
      IF NOT cl_null(g_needda) THEN LET l_mmg.mmg07=g_needda END IF
      LET l_mma.mma01 = g_n_mma01
      LET l_mma.mma02 = l_mmg.mmg01
      LET l_mma.mma021 =l_mmg.mmg02
      LET l_mma.mma03 = l_mmh.mmh02
      LET l_mma.mma04 = 'N'
      LET l_mma.mma05 = l_mmh.mmh03
      LET l_mma.mma06 = l_mmg.mmg04
      LET l_mma.mma07 = g_today
      LET l_mma.mma08 = l_mmg.mmg07
      LET l_mma.mma09 = l_mmh.mmh05
      LET l_mma.mma10 = l_mmh.mmh12
      LET l_mma.mma11 = l_mmg.mmg07
      LET l_mma.mma12 = l_mmg.mmg08
      LET l_mma.mma13 = NULL
      LET l_mma.mma14 = mma14
      LET l_mma.mma15 = l_mmg.mmg09
      LET l_mma.mma16 = NULL
      LET l_mma.mma17 = 'N'
      LET l_mma.mma18 = NULL
      LET l_mma.mma19 = 'N'
      LET l_mma.mma20 = l_mmg.mmg03
      LET l_mma.mma21 = g_mmd.mmd16
      LET l_mma.mma211 =' ' 
      LET l_mma.mmaacti='Y'
      LET l_mma.mmauser=g_user
      LET l_mma.mmagrup=g_grup
      LET l_mma.mmadate=g_today
      LET l_mma.mmaplant = g_plant #FUN-980004 add
      LET l_mma.mmalegal = g_legal #FUN-980004 add
      
      LET l_mma.mmaoriu = g_user      #No.FUN-980030 10/01/04
      LET l_mma.mmaorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO mma_file VALUES (l_mma.*)
      IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err('',SQLCA.SQLCODE,0)  #No.FUN-660094
          CALL cl_err3("ins","mma_file",l_mma.mma01,"",SQLCA.SQLCODE,"","",0)        #NO.FUN-660094
         LET g_success='N'
      END IF
      LET l_cnt=l_cnt+1
      IF l_cnt=1 THEN LET begin_no = l_mma.mma01 END IF
      LET g_end=l_mma.mma01
     
    END FOREACH
    DISPLAY '模具零件需求單 From:',begin_no,' To:',g_end 
           AT 1,1 
 
#NO.FUN-570124 MARK-----
#    IF g_success='Y' 
#       THEN
#       CALL cl_cmmsg('M')
#       COMMIT WORK
#    ELSE
#       CALL cl_rbmsg('M')
#       ROLLBACK WORK
#    END IF
#    CALL cl_end(20,20)
#NO.FUN-570124 Mark----
END FUNCTION
