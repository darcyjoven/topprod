# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: ammp400.4gl
# Descriptions...: 開發執行單轉工單作業
# Date & Author..: 01/01/17 By Faith
# Modify.........: No.FUN-550054 05/05/17 By yoyo單據編號格式放大
# Modify.........: No.FUN-560060 05/06/17 By day 單據編號修改
# Modify.........: No.MOD-580222 05/08/23 By Rosayu cl_used只可以在main的進入點跟退出點呼叫兩次
# Modify.........: No.TQC-610003 06/01/17 By Nicola INSERT INTO sfb_file 時,特性代碼欄位(sfb95)應抓取該工單單頭生產料件在料件主檔(ima_file)設定的'主特性代碼'欄位(ima910)
# Modify.........: No.FUN-570124 06/03/07 By yiting 批次背景執行
# Modify.........: No.FUN-660094 06/06/14 By CZH cl_err-->cl_err3
# Modify.........: No.TQC-670008 06/07/05 By kim 將 g_sys 變數改成寫死系統別(要大寫)
# Modify.........: No.FUN-680100 06/08/28 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.FUN-6B0044 06/11/13 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.FUN-7B0018 08/02/26 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-840153 08/06/19 By sherry 增加抓 ammt100 單身資料產生備料(sfa_file)
# Modify.........: No.FUN-940008 09/05/06 By hongmei GP5.2發料改善
# Modify.........: No.FUN-980004 09/08/28 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A50087 10/05/20 By liuxqa sfb104 赋初值.
# Modify.........: No.FUN-A60027 10/06/07 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.TQC-AC0238 10/12/17 By Mengxw 工單單別的欄位檢查及開窗排除smy73='Y'的單別 
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No:MOD-B70030 11/07/05 By JoHung 修改sfb23 default值
# Modify.........: No:MOD-BB0327 12/01/10 By destiny 已转工单则不能再转

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_wc,g_sql      STRING  #No.FUN-580092 HCN   #No.FUN-680100
DEFINE   g_date          LIKE type_file.dat           #No.FUN-680100 DATE    
DEFINE   begin_no        LIKE oea_file.oea01          #No.FUN-680100 VARCHAR(16)#No.FUN-560060
DEFINE   g_start,g_end   LIKE oea_file.oea01          #No.FUN-680100 VARCHAR(16)#No.FUN-560060
DEFINE   g_t1            LIKE oay_file.oayslip        #No.FUN-550054        #No.FUN-680100 VARCHAR(5)
DEFINE   ano             LIKE oay_file.oayslip        #No.FUN-680100 VARCHAR(5)#No.FUN-550054
DEFINE   g_n_sfb01       LIKE sfb_file.sfb01
DEFINE   g_sfb           RECORD LIKE sfb_file.*
 
DEFINE   g_change_lang   LIKE type_file.chr1          #No.FUN-680100 VARCHAR(1) #No.FUN-570124
 
MAIN
#  DEFINE   l_time LIKE type_file.chr8               #No.FUN-6A0076
   DEFINE l_flag        LIKE type_file.chr1          #No.FUN-570124        #No.FUN-680100 VARCHAR(1)
   DEFINE ls_date       STRING                       #No.FUN-680100 #No.FUN-570124
 
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   #No.FUN-570124--start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc    = ARG_VAL(1)
   LET ls_date = ARG_VAL(2)
   LET g_date  = cl_batch_bg_date_convert(ls_date)
   LET ano     = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
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
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
 
#NO.FUN-570124 mark----------
#   OPEN WINDOW p400_w AT p_row,p_col WITH FORM "amm/42f/ammp400"
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
#       CALL cl_ui_init()
#NO.FUN-570124 mark----------
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No:BUG-580088  HCN 20050818 #MOD-580222 mark  #No.FUN-6A0076
#NO.FUN-570124  start---
   WHILE TRUE
     IF g_bgjob="N" THEN
         CALL p400()
       IF cl_sure(21,21) THEN
          CALL cl_wait()
          LET g_success='Y'
          BEGIN WORK
          CALL p400_p()
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
             CLOSE WINDOW p400_w
             EXIT WHILE
          END IF
      ELSE
         CONTINUE WHILE
      END IF
   ELSE
      LET g_success='Y'
      BEGIN WORK
      CALL p400_p()
      IF g_success="Y" THEN
         COMMIT WORK
      ELSE
        ROLLBACK WORK
      END IF
      CALL cl_batch_bg_javamail(g_success)
      EXIT WHILE
   END IF
  END WHILE
#      CALL p400()
#      IF INT_FLAG THEN EXIT WHILE END IF
#   END WHILE
#   CLOSE WINDOW p400_w
# No.FUN-570124--end--
CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
END MAIN
 #TQC-AC0238   --start
FUNCTION i400_ano()
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_slip    LIKE smy_file.smyslip
   DEFINE l_smy73   LIKE smy_file.smy73  
 
   LET g_errno = ' '
   IF  cl_null(ano) THEN RETURN END IF
   LET l_slip = s_get_doc_no(ano)
 
   SELECT smy73 INTO l_smy73 FROM smy_file
    WHERE smyslip = l_slip
   IF l_smy73 = 'Y' THEN
      LET g_errno = 'asf-875'
   END IF
END FUNCTION
#TQC-AC0238   --end 
FUNCTION p400()
   DEFINE p_cmd         LIKE type_file.chr1
#No.FUN-550054--begin
   DEFINE li_result     LIKE type_file.num5          #No.FUN-680100 SMALLINT
#No.FUN-550054--end  
   DEFINE lc_cmd        LIKE type_file.chr1000       #No.FUN-680100 VARCHAR(500)#No.FUN-570124
   DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-570124        #No.FUN-680100 SMALLINT
 
   #No.FUN-570124--start--
      OPEN WINDOW p400_w AT p_row,p_col WITH FORM "amm/42f/ammp400"
        ATTRIBUTE(STYLE=g_win_style)
      CALL cl_ui_init()
  #No.FUN-570124--end--
 
   CLEAR FORM
   CALL cl_opmsg('w')
 
   WHILE TRUE
      CONSTRUCT BY NAME g_wc ON mmg01,mmg02 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
#        CALL cl_dynamic_locale()
 #       CALL cl_show_fld_cont()   #FUN-550037(smin)
         LET g_change_lang=TRUE    #No.FUN-570124
         EXIT CONSTRUCT            #No.FUN-570124
 
 
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
      #No.FUN-570124--start--
      IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
        LET INT_FLAG=0
        CLOSE WINDOW p400_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM
      END IF
     #No.FUN-570124--end--
 
#NO.FUN-570142 mark--
#      IF INT_FLAG THEN
#         RETURN 
#      END IF
#      IF g_wc = ' 1=1' THEN
#        CALL cl_err('','9046',0) CONTINUE WHILE
#      ELSE
#         EXIT WHILE
#      END IF
#   END WHILE
#NO.FUN-570124 mark---
 
   LET g_date=g_today
   LET ano = NULL
   LET g_bgjob = "N"            #No.FUN-570124
 
   CALL cl_opmsg('a')
 
   #INPUT BY NAME g_date,ano WITHOUT DEFAULTS 
   INPUT BY NAME g_date,ano,g_bgjob  WITHOUT DEFAULTS  #NO.FUN-570124
   ON ACTION locale
#     CALL cl_dynamic_locale()
#     CALL cl_show_fld_cont()   #FUN-550037(smin)
      LET g_change_lang=TRUE    #No.FUN-570124
      EXIT INPUT                #No.FUN-570124
 
      AFTER FIELD g_date
         IF cl_null(g_date) THEN
         LET g_date = g_today
         NEXT FIELD g_date
         END IF
 
      AFTER FIELD ano   
         IF NOT cl_null(ano) THEN
#No.FUN-550054--begin
#           LET g_t1 = ano[1,3]
            LET g_t1 = ano[1,g_doc_len]
            CALL s_check_no("asf",g_t1,"","1","","","")
            RETURNING li_result,ano
            LET ano = s_get_doc_no(ano)
            DISPLAY ano TO FORMONLY.ano 
            IF (NOT li_result) THEN
               NEXT FIELD ano
            END IF
            #TQC-AC0238   --start    
            CALL i400_ano()          
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(ano,g_errno,0)
               LET  ano = NULL
               DISPLAY ano TO FORMONLY.ano
               NEXT FIELD ano
            END IF
            #TQC-AC0238   --end
                               
#           CALL s_mfgslip(g_t1,'asf','1')        #檢查單別
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
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
         call cl_cmdask()
      ON ACTION CONTROLP
            CASE WHEN INFIELD(ano) # Class
                LET g_t1 = s_get_doc_no(ano)     #TQC-AC0238   
                LET g_sql = " (smy73 <> 'Y' OR smy73 is null)"    #TQC-AC0238 
                CALL smy_qry_set_par_where(g_sql)                 #TQC-AC0238 
                CALL q_smy(FALSE,FALSE,g_t1,'ASF','1') RETURNING g_t1
                LET  ano = g_t1                        #TQC-AC0238 
#               CALL FGL_DIALOG_SETBUFFER( ano )
                DISPLAY ano TO FORMONLY.ano 
                NEXT FIELD ano 
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
 
   END INPUT
 
   #No.FUN-570124--start--
      IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
            LET INT_FLAG=0
            CLOSE WINDOW p400_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
      END IF
   #No.FUN-570124--end--
 
#NO.FUN-570124 start-------
#   IF INT_FLAG THEN 
#      RETURN 
#   END IF
#   CALL p400_p()
    IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "ammp400"
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
          CALL cl_err('ammp400','9031',1)
        ELSE
          LET g_wc = cl_replace_str(g_wc,"'","\"")
          LET lc_cmd = lc_cmd CLIPPED,
                   " '",g_wc CLIPPED,"'",
                   " '",g_date CLIPPED,"'",
                   " '",ano CLIPPED,"'",
                   " '",g_bgjob CLIPPED,"'"
          CALL cl_cmdat('ammp400',g_time,lc_cmd CLIPPED)
        END IF
          CLOSE WINDOW p400_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM
    END IF
   EXIT WHILE
 END WHILE
#No.FUN-570124--end---
END FUNCTION
 
FUNCTION p400_p()
   DEFINE l_mmg     RECORD LIKE mmg_file.*
   DEFINE l_sfb     RECORD LIKE sfb_file.*
   DEFINE l_sfb01   LIKE sfb_file.sfb01   
   DEFINE l_cnt     LIKE type_file.num5       #No.FUN-680100 SMALLINT
   DEFINE l_str     LIKE type_file.chr1000    #No.FUN-680100 VARCHAR(200)
   DEFINE li_result LIKE type_file.num5       #No.FUN-560060        #No.FUN-680100 SMALLINT
   DEFINE l_sfbi    RECORD LIKE sfbi_file.*   #No.FUN-7B0018
   DEFINE l_sfa     RECORD LIKE sfa_file.*    #No.FUN-840153
   DEFINE l_sfai    RECORD LIKE sfai_file.*   #No.FUN-840153
   DEFINE l_mmh     RECORD LIKE mmh_file.*    #No.FUN-840153
   DEFINE l_n       LIKE type_file.num5       #MOD-BB0327
   DEFINE l_t       LIKE type_file.num5       #MOD-BB0327
   DEFINE l_b       LIKE type_file.num5       #MOD-BB0327
   DEFINE l_a       LIKE type_file.num5       #MOD-BB0327
   DEFINE l_mmh27   LIKE mmh_file.mmh27       #MOD-BB0327

    LET g_sql="SELECT mmg_file.* FROM mmg_file  WHERE ",
            "   mmgacti='Y' AND ",g_wc CLIPPED
    PREPARE p400_prepare FROM g_sql
    DECLARE p400_cs CURSOR WITH HOLD FOR p400_prepare
#    LET g_success = 'Y'   #NO.FUN-570124
    LET begin_no  = NULL
    LET l_cnt=0
    LET l_a=0  #MOD-BB0327
 
#    BEGIN WORK  #NO.FUN-570124 MARK
    FOREACH p400_cs INTO l_mmg.*
      IF STATUS THEN CALL cl_err('p400(foreach):',STATUS,1) EXIT FOREACH END IF

        #MOD-BB0327--begin
        #判断一下单身的料号是否已经全部转成工单
        DECLARE p400_sfa_cs CURSOR FOR SELECT mmh27 FROM mmh_file
           WHERE mmh01=l_mmg.mmg01 AND mmh011=l_mmg.mmg02
        LET l_t=0
        FOREACH p400_sfa_cs INTO l_mmh27
           SELECT COUNT(*) INTO l_n FROM sfa_file,sfb_file
             WHERE sfa01=sfb01 AND sfb86=l_mmg.mmg02 AND sfa27=l_mmh27
           IF l_n=0 THEN
              LET l_t=1
           END IF
        END FOREACH
        IF l_t=0 THEN
           CONTINUE FOREACH
        END IF
        #MOD-BB0327--end
 
     #增加輸入單別並自動編號
     IF ano IS NULL THEN
       LET g_n_sfb01=l_mmg.mmg01
     ELSE
#No.FUN-560060-begin
        CALL s_auto_assign_no("asf",ano,g_date,"1","sfb_file","sfb01","","","")
          RETURNING li_result,g_n_sfb01
        IF (NOT li_result) THEN                                                   
           RETURN                                                                 
        END IF                                                                    
#       CALL s_smyauno(ano,g_date) RETURNING g_i,g_n_sfb01
#       IF g_i THEN RETURN  END IF 
#No.FUN-560060-end   
     END IF
    #  DECLARE sfb_cus CURSOR FOR
    #  SELECT sfb01  FROM sfb_file
    #    WHERE sfb05 = l_mmg.mmg04 
             
    #  OPEN sfb_cus
    #  FETCH sfb_cus INTO l_sfb01
    #  IF SQLCA.SQLCODE <> 100 THEN
    #  LET l_str = l_mmg.mmg01,"+",l_mmg.mmg02,"+",l_mmh.mmh02
    #              ,"已開",l_sfb01,"之工單","請自行在工單維護作業確認無誤"
    #  ERROR l_str
    #   CONTINUE FOREACH
    # END IF    
      LET l_sfb.sfb01 = g_n_sfb01
      LET l_sfb.sfb02 = '1'
      LET l_sfb.sfb03 = NULL      
      LET l_sfb.sfb04 = '1'         
      LET l_sfb.sfb05 = l_mmg.mmg04
      LET l_sfb.sfb06 = NULL       
      LET l_sfb.sfb07 = NULL       
      LET l_sfb.sfb071= g_date 
      LET l_sfb.sfb08 = l_mmg.mmg10
      LET l_sfb.sfb081= 0          
      LET l_sfb.sfb09 = 0          
      LET l_sfb.sfb10 = 0          
      LET l_sfb.sfb11 = 0          
      LET l_sfb.sfb111= 0   
      LET l_sfb.sfb12 = 0   
      LET l_sfb.sfb121= 0          
      LET l_sfb.sfb122= NULL
      LET l_sfb.sfb13 = g_date
      LET l_sfb.sfb14 = NULL
      LET l_sfb.sfb15 = g_date
      LET l_sfb.sfb16 = NULL       
      LET l_sfb.sfb17 = NULL       
      LET l_sfb.sfb18 = NULL
      LET l_sfb.sfb19 =NULL
      LET l_sfb.sfb20 =NULL
      LET l_sfb.sfb21 =NULL
      LET l_sfb.sfb22 =NULL
      LET l_sfb.sfb221=NULL
      LET l_sfb.sfb222=NULL
#     LET l_sfb.sfb23 ='N'   #MOD-B70030 mark
      LET l_sfb.sfb23 ='Y'   #MOD-B70030
      LET l_sfb.sfb24 ='N' 
      LET l_sfb.sfb25 =NULL
      LET l_sfb.sfb251=g_date
      LET l_sfb.sfb26 =NULL
      LET l_sfb.sfb27 =NULL
      LET l_sfb.sfb271=NULL
      LET l_sfb.sfb28 =NULL
      LET l_sfb.sfb29 ='Y' 
      LET l_sfb.sfb30 =NULL
      LET l_sfb.sfb31 =NULL
      LET l_sfb.sfb32 =NULL
      LET l_sfb.sfb33 =NULL
      LET l_sfb.sfb34 ='1' 
      LET l_sfb.sfb35 ='N' 
      LET l_sfb.sfb36 =NULL
      LET l_sfb.sfb37 =NULL
      LET l_sfb.sfb38 =NULL
      LET l_sfb.sfb39 ='1' 
      LET l_sfb.sfb40 =NULL
      LET l_sfb.sfb41 ='N' 
      LET l_sfb.sfb42 =NULL
      LET l_sfb.sfb81 =g_today
      LET l_sfb.sfb82 =NULL
      LET l_sfb.sfb85 =NULL
      LET l_sfb.sfb86 =l_mmg.mmg02
      LET l_sfb.sfb87 ='N' 
      LET l_sfb.sfb88 =NULL
      LET l_sfb.sfb91 =NULL
      LET l_sfb.sfb92 =NULL
      LET l_sfb.sfb93 =NULL
      LET l_sfb.sfb94 =NULL
      #-----No.TQC-610003-----
      SELECT ima910 INTO l_sfb.sfb95
        FROM ima_file
       WHERE ima01 = l_sfb.sfb05
      IF cl_null(l_sfb.sfb95) THEN
         LET l_sfb.sfb95 = ' '
      END IF
      #-----No.TQC-610003-----
      LET l_sfb.sfb95 =NULL
      LET l_sfb.sfb96 =NULL
      LET l_sfb.sfb97 =NULL
      LET l_sfb.sfb98 ='1' 
      LET l_sfb.sfb99 ='N' 
      LET l_sfb.sfbacti='Y'
      LET l_sfb.sfbuser=g_user
      LET l_sfb.sfbgrup=g_grup
      LET l_sfb.sfbmodu=NULL  
      LET l_sfb.sfbdate=g_today
      LET l_sfb.sfb1002='N' #FUN-6B0044
      LET l_sfb.sfbplant = g_plant #FUN-980004 add
      LET l_sfb.sfblegal = g_legal #FUN-980004 add
      
      LET l_sfb.sfboriu = g_user      #No.FUN-980030 10/01/04
      LET l_sfb.sfborig = g_grup      #No.FUN-980030 10/01/04
      LET l_sfb.sfb104 = 'N'         #TQC-A50087 add
      INSERT INTO sfb_file VALUES (l_sfb.*)
      IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err('',SQLCA.SQLCODE,0)  #No.FUN-660094
          CALL cl_err3("ins","sfb_file",l_sfb.sfb01,"",SQLCA.SQLCODE,"","",0)        #NO.FUN-660094
         LET g_success='N'
      #NO.FUN-7B0018 08/02/25 add --begin
      ELSE
         IF NOT s_industry('std') THEN
            INITIALIZE l_sfbi.* TO NULL
            LET l_sfbi.sfbi01 = l_sfb.sfb01
            IF NOT s_ins_sfbi(l_sfbi.*,'') THEN
               LET g_success = 'N'
            END IF
         END IF
      #NO.FUN-7B0018 08/02/25 add --end
      END IF
 
      LET l_cnt=l_cnt+1
      IF l_cnt=1 THEN LET begin_no = l_sfb.sfb01 END IF
      LET g_end=l_sfb.sfb01
      
      #No.FUN-840153---Begin
      LET g_sql="SELECT mmh_file.* FROM mmh_file  WHERE ",
                " mmh01='",l_mmg.mmg01,"' AND mmh011='",l_mmg.mmg02,"' "
                
      PREPARE p400_prepare1 FROM g_sql
      DECLARE p400_cs1 CURSOR WITH HOLD FOR p400_prepare1
      FOREACH p400_cs1 INTO l_mmh.*   
        #MOD-BB0327--begin
        LET l_b=0  #MOD-BB0327
        SELECT COUNT(*) INTO l_b FROM sfa_file,sfb_file
          WHERE sfa01=sfb01 AND sfb86=l_mmg.mmg02 AND sfa27=l_mmh27
        IF l_b>0 THEN
           CONTINUE FOREACH
        END IF
        #MOD-BB0327--end
 
        LET l_sfa.sfa01 = g_n_sfb01
        LET l_sfa.sfa02 = '1'
        LET l_sfa.sfa03 = l_mmh.mmh03      
        LET l_sfa.sfa04 = l_mmh.mmh04         
        LET l_sfa.sfa05 = l_mmh.mmh05
        LET l_sfa.sfa06 = l_mmh.mmh06  
        LET l_sfa.sfa061= l_mmh.mmh061
        LET l_sfa.sfa062= l_mmh.mmh062 
        LET l_sfa.sfa063= l_mmh.mmh063
        LET l_sfa.sfa064= l_mmh.mmh064
        LET l_sfa.sfa065= l_mmh.mmh065
        LET l_sfa.sfa066= l_mmh.mmh066    
#       LET l_sfa.sfa07 = l_mmh.mmh07     #No.FUN-940008 mark 
        LET l_sfa.sfa08 = l_mmh.mmh08
        LET l_sfa.sfa09 = l_mmh.mmh09          
        LET l_sfa.sfa10 = l_mmh.mmh10          
        LET l_sfa.sfa11 = l_mmh.mmh11          
        LET l_sfa.sfa12 = l_mmh.mmh12          
        LET l_sfa.sfa13 = l_mmh.mmh13          
        LET l_sfa.sfa14 = l_mmh.mmh14          
        LET l_sfa.sfa15 = l_mmh.mmh15          
        LET l_sfa.sfa16 = l_mmh.mmh16          
        LET l_sfa.sfa161= l_mmh.mmh161         
        LET l_sfa.sfa25 = l_mmh.mmh25          
        LET l_sfa.sfa26 = l_mmh.mmh26          
        LET l_sfa.sfa27 = l_mmh.mmh27          
        LET l_sfa.sfa28 = l_mmh.mmh28          
        LET l_sfa.sfa29 = l_mmh.mmh29          
        LET l_sfa.sfa30 = l_mmh.mmh30          
        LET l_sfa.sfa31 = l_mmh.mmh31          
        LET l_sfa.sfaplant = g_plant #FUN-980004 add
        LET l_sfa.sfalegal = g_legal #FUN-980004 add
        LET l_sfa.sfa012 =  ' '      #FUN-A60027 add
        LET l_sfa.sfa013 = '0'       #FUN-A60027 add   
 
        INSERT INTO sfa_file VALUES (l_sfa.*)
        IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("ins","sfa_file",l_sfa.sfa01,"",SQLCA.SQLCODE,"","",0)    
           LET g_success='N'
        ELSE                  #MOD-BB0327
           LET l_a=l_a+1      #MOD-BB0327
        END IF
      END FOREACH 
      #No.FUN-840153---End  
    END FOREACH
    #MOD-BB0327--begin
    IF l_a=0 THEN
       LET g_success='N'
    END IF
    #MOD-BB0327--end    
    IF g_bgjob = 'N' THEN  #NO.FUN-570124 
        DISPLAY '工單 From:',begin_no,' To:',g_end 
           AT 1,1 
    END IF
 
#NO.FUN-570124 mark---
#    IF g_success='Y' 
#       THEN
#       CALL cl_cmmsg('M')
#       COMMIT WORK
#    ELSE
#       CALL cl_rbmsg('M')
#       ROLLBACK WORK
#    END IF
#    CALL cl_end(20,20)
#NO.FUN-570124 mark---
END FUNCTION
