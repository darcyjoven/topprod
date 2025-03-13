# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: asdp120.4gl
# Descriptions...: 成本系統月結作業
# Date & Author..: 99/01/20 By Eric
# Modify ........: No:9495 04/06/14 By Carol 未作單位換算動作,以至於造成後續報表皆不正確 
#                                            改數量 tlf10 -> tlf10 * tlf60
# Modify.........: MOD-470041 04/07/16 By Wiky  修改INSERT INTO...
# Modify.........: MOD-4B0223 04/07/16 By Carol 1.在 p120_p02( ) 中的條件中原為 tlf13='asft6101' 應改為 'asft6201'
#                                               2.在 p120_p02( ) 中搜尋關鍵字 sfb02,原程式在 SELECT sfb02 時
#                                                 WHERE 條件寫的 sfb01 = l_tlf026(或是 l_tlf036) 有些地方寫的是顛倒,  
#                                                 建議一律改為 WHERE sfb01 = l_tlf62　
# Modify.........: No.FUN-4C0026 04/12/06 By Mandy 單價金額位數改為dec(20,6) 或DEFINE 用LIKE方式
# Modify.........: No.MOD-4C0159 04/12/24 By ching p120_p02()領退 SQL有誤
# Modify.........: No.FUN-5100337 05/01/19 By pengu 報表轉XML
# Modify.........: No.MOD-580325 05/08/29 By day  將程序中寫死為中文的錯誤信息改由p_ze維護
# Modify ........: No.FUN-570150 06/03/13 By yiting 批次背景執行
# Modify.........: No.FUN-660120 06/06/16 By CZH cl_err --> cl_err3
# Modify.........: No.FUN-690010 06/09/05 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.MOD-970203 09/07/24 By Smapmin 計算時,不應以imd09做為是否為成本倉.建議以axci500為主
# Modify.........: No.FUN-980008 09/08/14 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0161 09/10/29 By Carrier SQL STANDARDIZE
# Modify.........: No:MOD-9C0462 10/01/04 By Smapmin 截止日期有錯
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2) 
# Modify.........: No:MOD-C60023 12/06/04 By ck2yuan stf04 stg04 給值地方統一給tlf62

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   tm      RECORD
                  wc    LIKE type_file.chr1000,      #No.FUN-690010 VARCHAR(300),
                 year   LIKE type_file.num5,         #No.FUN-690010SMALLINT,
                 month  LIKE type_file.num5,         #No.FUN-690010SMALLINT,
                 sw1    LIKE type_file.chr1,         #No.FUN-690010CHAR(01),
                 sw2    LIKE type_file.chr1,         #No.FUN-690010CHAR(01),
                 sw3    LIKE type_file.chr1,         #No.FUN-690010CHAR(01),
                 sw4    LIKE type_file.chr1,         #No.FUN-690010CHAR(01),
                 sw5    LIKE type_file.chr1          #No.FUN-690010CHAR(01)
                 END RECORD,
         last_y  LIKE type_file.num5,         #No.FUN-690010SMALLINT,
         last_m  LIKE type_file.num5,         #No.FUN-690010SMALLINT,
         b_date,e_date LIKE type_file.dat,     #No.FUN-690010 DATE
          g_sql   string,  #No.FUN-580092 HCN
         g_err   LIKE type_file.chr1000,      #No.FUN-690010CHAR(80),
         g_pmm   RECORD LIKE pmm_file.*,
         g_pmn   RECORD LIKE pmn_file.*,
         g_stj   RECORD LIKE stj_file.*,
         g_ste   RECORD LIKE ste_file.*,
         g_stf   RECORD LIKE stf_file.*,
         g_stg   RECORD LIKE stg_file.*,
         g_sth   RECORD LIKE sth_file.*
DEFINE   g_flag         LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
DEFINE   g_i            LIKE type_file.num5      #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   g_change_lang  LIKE type_file.chr1          # Prog. Version..: '5.30.06-13.03.12(01)    #No.FUN-570150
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0089
   DEFINE l_sl          LIKE type_file.num5          #No.FUN-690010SMALLINT
   DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   #-->No.FUN-570150 --start
    INITIALIZE g_bgjob_msgfile TO NULL
    LET tm.year  = ARG_VAL(1)                         #月結年
    LET tm.month = ARG_VAL(2)                         #月結月
    LET tm.sw1   = ARG_VAL(3)                         #清除資料.結轉上期
    LET tm.sw2   = ARG_VAL(4)                         #匯總本月領/退/入庫資料
    LET tm.sw3   = ARG_VAL(5)                         #匯總月統計資料
    LET g_bgjob  = ARG_VAL(6)
    IF cl_null(g_bgjob) THEN
       LET g_bgjob = 'N'
    END IF
   #--- No.FUN-570150 --end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASD")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
         RETURNING g_time    #No.FUN-6A0089
 
#NO.FUN-570150 start--
#    LET p_row = 4 LET p_col = 38
 
#    OPEN WINDOW p120_w AT p_row,p_col WITH FORM "asd/42f/asdp120" 
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
#    CALL cl_ui_init()
 
#    CALL p120_tm()
#    CLOSE WINDOW p120_w
   WHILE TRUE
      LET g_flag = 'Y'
      IF g_bgjob = "N" THEN         --> add FUN-570150
         CALL p120_tm()
         IF g_flag = 'N' THEN
            CONTINUE WHILE
         END IF
         IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
         IF cl_sure(21,21) THEN
            CALL cl_wait()
            LET g_success='Y'
            BEGIN WORK
            CALL p120_process()
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
            END IF
            IF g_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p120_w
               EXIT WHILE
            END IF
         END IF
      ELSE
        LET g_success = 'Y'
        BEGIN WORK
        CALL p120_process()
        IF g_success = "Y" THEN
           COMMIT WORK
        ELSE
           ROLLBACK WORK
        END IF
        CALL cl_batch_bg_javamail(g_success)
        EXIT WHILE
      END IF
      IF INT_FLAG THEN LET INT_FLAG=0 EXIT WHILE END IF
    END WHILE
#NO.FUN-570150 end-----------
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
         RETURNING g_time    #No.FUN-6A0089
END MAIN
 
FUNCTION p120_tm()
DEFINE   l_sl,p_row,p_col       LIKE type_file.num5                  #No.FUN-570150  #No.FUN-690010 SMALLINT
DEFINE   lc_cmd                 LIKE type_file.chr1000       #No.FUN-690010CHAR(500)               #No.FUN-570150
 
   #-->No.FUN-570150 --start----------------
    LET p_row = 4 LET p_col = 38
 
    OPEN WINDOW p120_w AT p_row,p_col WITH FORM "asd/42f/asdp120"
      ATTRIBUTE (STYLE = g_win_style)
 
    CALL cl_ui_init()
   #--- No.FUN-570150 --end-----------------
   
   WHILE TRUE
      CLEAR FORM
      CALL cl_opmsg('z')
      LET tm.sw1='Y'
      LET tm.sw2='Y'
      LET tm.sw3='Y'
      LET tm.sw4='Y'
      LET tm.sw5='Y'
 #MOD-4B0223 add default
      LET tm.year  = Year(g_today)
      LET tm.month = MONTH(g_today)
      LET g_bgjob  = 'N'             #No.FUN-570150
##
      #INPUT BY NAME tm.year,tm.month,tm.sw1,tm.sw2,tm.sw3 WITHOUT DEFAULTS
      INPUT BY NAME tm.year,tm.month,tm.sw1,tm.sw2,tm.sw3,g_bgjob WITHOUT DEFAULTS  #NO.FUN-570150
 
         AFTER FIELD month
            IF NOT cl_null(tm.month) THEN
               IF tm.month < 1 OR tm.month > 12 THEN
                  NEXT FIELD month
               END IF
            END IF
 
         AFTER FIELD sw1
            IF tm.sw1 NOT MATCHES '[YN]' THEN
               LET tm.sw1='Y'
               NEXT FIELD sw1
            END IF
 
         AFTER FIELD sw2
            IF tm.sw2 NOT MATCHES '[YN]' THEN
               LET tm.sw2='Y'
               NEXT FIELD sw2
            END IF
 
         AFTER FIELD sw3
            IF tm.sw3 NOT MATCHES '[YN]' THEN
               LET tm.sw3='Y'
               NEXT FIELD sw3
            END IF
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
         ON ACTION locale   #genero
#NO.FUN-570150 mark
#          LET g_action_choice = "locale"
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#NO.FUN-570150 mark
           LET g_change_lang = TRUE
           EXIT INPUT
     
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
#NO.FUN-570150 start--
#      IF g_action_choice = "locale" THEN  #genero
#         LET g_action_choice = ""
#         CALL cl_dynamic_locale()
#         CONTINUE WHILE
#      END IF
 
#      IF INT_FLAG THEN
#         LET INT_FLAG=0 
#         EXIT WHILE
#      END IF
 
    IF g_change_lang THEN
       LET g_change_lang = FALSE
       CALL cl_dynamic_locale()
       CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
       CONTINUE WHILE
    END IF
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLOSE WINDOW p120_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM
    END IF
#NO.FUN-570150 end---
 
#NO.FUN-570150 mark--
#      IF cl_sure(21,21) THEN 
#         CALL cl_wait()
#         LET g_success='Y'
#         BEGIN WORK 
#         CALL p120_process() 
#         IF g_success = 'Y' THEN
#            COMMIT WORK
#            CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
#         ELSE
#            ROLLBACK WORK
#            CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
#         END IF
#         IF g_flag THEN
#            CONTINUE WHILE
#         ELSE
#            EXIT WHILE
#         END IF
#      END IF
#   END WHILE
#   ERROR ''
#NO.FUN-570150 mark--
 
#NO.FUN-570150 start--
    IF g_bgjob = "Y" THEN
       SELECT zz08 INTO lc_cmd FROM zz_file
        WHERE zz01 = "asdp120"
       IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('asdp120','9031',1)   
          
       ELSE
          LET lc_cmd = lc_cmd CLIPPED,
                       " '",tm.year CLIPPED,"'",
                       " '",tm.month CLIPPED,"'",
                       " '",tm.sw1 CLIPPED,"'",
                       " '",tm.sw2 CLIPPED,"'",
                       " '",tm.sw3 CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'"
          CALL cl_cmdat('asdp120',g_time,lc_cmd CLIPPED)
       END IF
       CLOSE WINDOW p120_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM
    END IF
    EXIT WHILE
   #-- No.FUN-570150 --end---
   END WHILE
 
END FUNCTION
 
FUNCTION p120_process()
  DEFINE  l_ima01    LIKE ima_file.ima01
  DEFINE  l_za05     LIKE za_file.za05
  DEFINE  l_name     LIKE type_file.chr20   #No.FUN-690010 VARCHAR(20)
  LET g_pdate = g_today
  LET g_rlang = g_lang
  LET g_copies= '1'
  IF tm.month=1 THEN
     LET last_y=tm.year-1
     LET last_m=12
  ELSE
     LET last_y=tm.year
     LET last_m=tm.month-1
  END IF
  LET b_date=MDY(tm.month,1,tm.year)
  IF tm.month=12 THEN
     #LET e_date=MDY(1,1,tm.year+1)    #MOD-9C0462
     LET e_date=MDY(1,1,tm.year+1)-1   #MOD-9C0462
  ELSE
     LET e_date=MDY(tm.month+1,1,tm.year)-1
  END IF
  SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
  CALL cl_outnam('asdp120') RETURNING l_name
  START REPORT asdp120_rep TO l_name
  LET g_pageno = 0
  IF tm.sw1='Y' THEN CALL p120_p01() END IF       ## 清除相關檔案
  IF tm.sw2='Y' THEN CALL p120_p02() END IF       ## 彙總本月份領/退/入庫資料
  IF tm.sw3='Y' THEN CALL p120_p03() END IF       ## 彙總月統計資料
 
  OUTPUT TO REPORT asdp120_rep(l_ima01)
  FINISH REPORT asdp120_rep
  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
 
## 清除相關暫存檔
FUNCTION p120_p01()
#No.MOD-580325-begin                                                           
  CALL cl_err('','asd-001',0)                                                   
#    MESSAGE '01.清除相關資料'                                                  
#No.MOD-580325-end  
  CALL ui.Interface.refresh()
  DELETE FROM ste_file WHERE ste02=tm.year AND ste03=tm.month
  DELETE FROM stf_file WHERE stf02=tm.year AND stf03=tm.month
  DELETE FROM stg_file WHERE stg02=tm.year AND stg03=tm.month
#No.MOD-580325-begin                                                           
  CALL cl_err('','asd-004',0)                                                   
#MESSAGE "01.2結轉上期餘額!"                                                    
#No.MOD-580325-end   
  CALL ui.Interface.refresh()
  DECLARE p120_012 CURSOR FOR 
   SELECT * FROM ste_file WHERE ste02=last_y AND ste03=last_m AND ste31='N'
  FOREACH p120_012 INTO g_ste.*
    IF STATUS THEN 
       LET g_success='N'
       EXIT FOREACH 
    END IF
    LET g_ste.ste02=tm.year
    LET g_ste.ste03=tm.month
    LET g_ste.ste06=g_ste.ste26
    LET g_ste.ste07=g_ste.ste27
    LET g_ste.ste08=g_ste.ste28
    LET g_ste.ste09=g_ste.ste29
    LET g_ste.ste10=g_ste.ste30
    LET g_ste.ste11=0
    LET g_ste.ste12=0
    LET g_ste.ste13=0
    LET g_ste.ste14=0
    LET g_ste.ste15=0
    LET g_ste.ste16=0
    LET g_ste.ste17=0
    LET g_ste.ste18=0
    LET g_ste.ste19=0
    LET g_ste.ste20=0
    LET g_ste.ste22=0
    LET g_ste.ste23=0
    LET g_ste.ste24=0
    LET g_ste.ste25=0
    LET g_ste.ste26=0
    LET g_ste.ste27=0
    LET g_ste.ste28=0
    LET g_ste.ste29=0
    LET g_ste.ste30=0
    LET g_ste.ste32=0
    LET g_ste.steplant = g_plant #FUN-980008 add
    LET g_ste.stelegal = g_legal #FUN-980008 add
    INSERT INTO ste_file VALUES(g_ste.*)
    IF SQLCA.SQLCODE THEN
#      CALL cl_err('ins ste',STATUS,1)   #No.FUN-660120
       CALL cl_err3("ins","ste_file",g_ste.ste02,g_ste.ste03,STATUS,"","ins ste",1)   #No.FUN-660120
       LET g_success='N'
       EXIT FOREACH 
    END IF
  END FOREACH
END FUNCTION
 
## 彙總本月份領/退/入庫資料
FUNCTION p120_p02()
  DEFINE l_i      LIKE type_file.num5,    #No.FUN-690010 SMALLINT
         l_cnt    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
         l_total  LIKE alb_file.alb06,         #No.FUN-690010DEC(20,6), #FUN-4C0026
         l_imd09  LIKE type_file.chr1,         #No.FUN-690010CHAR(01),
         l_pmm02  LIKE pmm_file.pmm02,
         l_pmm22  LIKE pmm_file.pmm22,
         l_pmm42  LIKE pmm_file.pmm42,
         l_pmn31  LIKE pmn_file.pmn31,
         l_sfb02  LIKE sfb_file.sfb02,
         l_tlf02  LIKE tlf_file.tlf02,
         l_tlf01  LIKE tlf_file.tlf01,
         l_tlf026 LIKE tlf_file.tlf026,
         l_tlf027 LIKE tlf_file.tlf027,
         l_tlf037 LIKE tlf_file.tlf037,
         l_tlf03  LIKE tlf_file.tlf03,
         l_tlf036 LIKE tlf_file.tlf036,
         l_tlf06  LIKE tlf_file.tlf06,
         l_tlf10  LIKE tlf_file.tlf10,
         l_tlf13  LIKE tlf_file.tlf13,
         l_tlf021 LIKE tlf_file.tlf021,
         l_tlf031 LIKE tlf_file.tlf031,
         l_tlf62  LIKE tlf_file.tlf62
 
#No.MOD-580325-begin                                                           
  CALL cl_err('','asd-005',0)                                                   
#MESSAGE "02.1匯總本月份領/退/入庫資料"                                         
#No.MOD-580325-end    
  CALL ui.Interface.refresh()
  LET g_stf.stf02=tm.year
  LET g_stf.stf03=tm.month
  LET g_stg.stg02=tm.year
  LET g_stg.stg03=tm.month
  LET g_stg.stgplant = g_plant #FUN-980008 add
  LET g_stg.stglegal = g_legal #FUN-980008 add
  LET g_stf.stfplant = g_plant #FUN-980008 add
  LET g_stf.stflegal = g_legal #FUN-980008 add
 
 #CHI-A70049---mark---start---
 #DISPLAY "b_date",b_date
 #DISPLAY "e_date",e_date
 #CHI-A70049---mark---end---
  DECLARE p120_021 CURSOR FOR 
   SELECT tlf01,tlf02,tlf026,tlf03,tlf036,tlf06,tlf10*tlf60,   #No:9495
          tlf13,tlf62,tlf021,tlf031,tlf027,tlf037
     FROM tlf_file
   WHERE tlf06 >= b_date AND tlf06 <= e_date
    #AND tlf62='511-410022'
      #MOD-4C0159
     AND ((tlf02=50 AND tlf03>=60 AND tlf03<=66 AND tlf13 MATCHES 'asfi51*')
      OR  (tlf03=50 AND tlf02>=60 AND tlf02<=66 AND tlf13 MATCHES 'asfi52*')
     #--
      OR  (tlf02=60 AND tlf03=50 AND tlf13 MATCHES 'asft620*' ) #工單入庫  #genero有問題,工單單號'511-410022'
      OR  (tlf02=60 AND tlf03=50 AND tlf13 MATCHES 'asfp650*' ) #領料還原
      OR  (tlf02=50 AND tlf03=60 AND tlf13 MATCHES 'asft660*' ) #工單入庫退回
       OR  (tlf02=25 AND tlf03=50 AND tlf13 = 'asft6201' )  #MOD-4B0223  modify
      OR  (tlf02=50 AND tlf03>=31 AND tlf03<=32 AND tlf13 MATCHES 'apmt1071'))
  FOREACH p120_021 INTO l_tlf01,l_tlf02,l_tlf026,l_tlf03,l_tlf036,
                        l_tlf06,l_tlf10,l_tlf13,l_tlf62,l_tlf021,l_tlf031,
                        l_tlf027,l_tlf037
     IF STATUS <> 0 THEN
        LET g_err="ERR. Foreach error(p120_021 cur)"
        LET g_success='N'
        OUTPUT TO REPORT asdp120_rep(g_err)
        EXIT FOREACH
     END IF
     IF g_bgjob = 'N' THEN           #No.FUN-570150
         MESSAGE l_tlf01,l_tlf02
         CALL ui.Interface.refresh()
     END IF 
     IF l_tlf02=50 AND l_tlf03>=31 AND l_tlf03<=32 AND l_tlf13 = 'apmt1071' 
     THEN
        SELECT pmm02 INTO l_pmm02 FROM pmm_file WHERE pmm01=l_tlf036
        IF STATUS <> 0 THEN CONTINUE FOREACH END IF
        IF l_pmm02 IS NULL OR l_pmm02 <> 'SUB' THEN CONTINUE FOREACH END IF
     END IF
     ##-->入庫單
     IF l_tlf13 = 'asft6201' OR l_tlf13 = 'apmt1072' OR l_tlf13 = 'asft660'
     THEN 
        #-->判斷是否為成本庫別
        #-----MOD-970203---------
        #SELECT imd09 INTO l_imd09 FROM imd_file WHERE imd01=l_tlf031
        #IF SQLCA.sqlcode THEN LET l_imd09 = 'Y' END IF
        #IF l_imd09<>'Y' THEN LET l_tlf10=l_tlf10*-1 END IF
        LET l_cnt = 0 
        SELECT COUNT(*) INTO l_cnt FROM jce_file
         WHERE jce02 = l_tlf031
        IF l_cnt > 0 THEN LET l_tlf10=l_tlf10*-1 END IF
        #-----END MOD-970203----- 
 
        #-->工單完工入庫(一般委外(asft6201)  #genero
        IF l_tlf13 = 'asft6201' THEN 
              SELECT sfb02 INTO l_sfb02 FROM sfb_file
                WHERE sfb01=l_tlf62 AND sfb87!='X'   #MOD-4B0223  modify 
              IF STATUS <> 0 THEN LET l_sfb02=1 END IF
              LET g_stg.stg01=l_sfb02
              LET g_stg.stg04=l_tlf62  
              LET g_stg.stg07=l_tlf10
              LET g_stg.stg05=l_tlf036
              LET g_stg.stg051=l_tlf037
              LET g_stg.stg06=l_tlf06
              LET g_stg.stg20=l_tlf031
        ELSE 
            #-->工單入庫退回
              IF l_tlf13='apmt1072' THEN
                 LET g_stg.stg01='7'
                 LET g_stg.stg04=l_tlf62
                 LET g_stg.stg07 = -l_tlf10
                 LET g_stg.stg05=l_tlf026
                 LET g_stg.stg051=l_tlf027
                 LET g_stg.stg06=l_tlf06
                 LET g_stg.stg20=l_tlf021
              ELSE
                 SELECT sfb02 INTO l_sfb02 FROM sfb_file 
                   WHERE sfb01=l_tlf62 AND sfb87!='X'   #MOD-4B0223  modify
                 IF STATUS <> 0 THEN LET l_sfb02=1 END IF
                 LET g_stg.stg01=l_sfb02
                #LET g_stg.stg04=l_tlf036     #MOD-C60023 mark
                 LET g_stg.stg04=l_tlf62      #MOD-C60023 add
                 LET g_stg.stg07 = -l_tlf10
                 LET g_stg.stg05=l_tlf026
                 LET g_stg.stg051=l_tlf027
                 LET g_stg.stg06=l_tlf06
                 LET g_stg.stg20=l_tlf021
             END IF
        END IF
        ##--> 成本不計算倉, 等一下要刪掉
        #IF l_imd09<>'Y' THEN   LET g_stg.stg01='X' END IF   #MOD-970203
        IF l_cnt > 0 THEN   LET g_stg.stg01='X' END IF   #MOD-970203
        LET g_stg.stg21=' '
        LET g_stg.stg22=0
        LET g_stg.stg23=0
        LET g_stg.stg24=0
 
        SELECT stb07,stb08,stb09,stb09a,stb04,stb05,stb06,stb06a
          INTO g_stg.stg08,g_stg.stg09,g_stg.stg10,g_stg.stg11,
               g_stg.stg16,g_stg.stg17,g_stg.stg18,g_stg.stg19
          FROM stb_file
         WHERE stb01 = l_tlf01 AND stb02 = tm.year AND stb03 = tm.month
        IF STATUS <> 0 THEN
           LET g_stg.stg08=0 LET g_stg.stg09=0 LET g_stg.stg10=0
           LET g_stg.stg11=0 LET g_stg.stg16=0 LET g_stg.stg17=0
           LET g_stg.stg18=0 LET g_stg.stg19=0
        END IF
        #-->轉出部份改為以單階計算           
        LET l_total=(g_stg.stg08+g_stg.stg09+g_stg.stg10+g_stg.stg11)
                    *g_stg.stg07 
        LET g_stg.stg13=g_stg.stg17*g_stg.stg07 
        LET g_stg.stg14=g_stg.stg18*g_stg.stg07 
        LET g_stg.stg15=g_stg.stg19*g_stg.stg07 
        LET g_stg.stg12=l_total-g_stg.stg13-g_stg.stg14-g_stg.stg15
 
        #-->若為委外入庫則補單價資料
        SELECT pmm22,pmm42,pmn31 INTO l_pmm22,l_pmm42,l_pmn31 
          FROM pmn_file,pmm_file
         WHERE pmn41=g_stg.stg04 AND pmm01=pmn01 AND pmm18 <> 'X'
        IF STATUS = 0 THEN
           LET g_stg.stg21=l_pmm22
           LET g_stg.stg22=l_pmm42
           LET g_stg.stg23=l_pmn31
           IF cl_null(g_stg.stg22) OR g_stg.stg22=0 THEN
              LET g_stg.stg22=1
           END IF
           LET g_stg.stg24=g_stg.stg22*g_stg.stg23
           LET g_stg.stg25=g_stg.stg24*g_stg.stg07
        END IF
        INSERT INTO stg_file VALUES(g_stg.*)
     ELSE                                 ## 領/退料
        IF l_tlf13 MATCHES 'asfi5*' THEN  ## 領料單
           #-----MOD-970203---------
           #SELECT imd09 INTO l_imd09 FROM imd_file WHERE imd01=l_tlf021
           #IF l_imd09<>'Y' THEN CONTINUE FOREACH  END IF
           LET l_cnt = 0 
           SELECT COUNT(*) INTO l_cnt FROM jce_file
            WHERE jce02 = l_tlf021
           IF l_cnt > 0 THEN CONTINUE FOREACH END IF
           #-----END MOD-970203----- 
 
           SELECT sfb02 INTO l_sfb02 FROM sfb_file 
             WHERE sfb01=l_tlf62      #MOD-4B0223  modify
           IF STATUS <> 0 THEN LET l_sfb02=1 END IF
          #LET g_stf.stf04=l_tlf036     #MOD-C60023 mark
           LET g_stf.stf04=l_tlf62      #MOD-C60023 add
           LET g_stf.stf05=l_tlf026
           LET g_stf.stf08=l_tlf10
           LET g_stf.stf11=l_tlf021
        ELSE                              ## 退料單
           #-----MOD-970203---------
           #SELECT imd09 INTO l_imd09 FROM imd_file WHERE imd01=l_tlf031
           #IF l_imd09<>'Y' THEN CONTINUE FOREACH  END IF
           LET l_cnt = 0 
           SELECT COUNT(*) INTO l_cnt FROM jce_file
            WHERE jce02 = l_tlf031
           IF l_cnt > 0 THEN CONTINUE FOREACH END IF
           #-----END MOD-970203----- 
 
           SELECT sfb02 INTO l_sfb02 FROM sfb_file 
             WHERE sfb01=l_tlf62      #MOD-4B0223  modify
           IF STATUS <> 0 THEN LET l_sfb02=1 END IF
 
          #LET g_stf.stf04=l_tlf026     #MOD-C60023 mark
           LET g_stf.stf04=l_tlf62      #MOD-C60023 add
           LET g_stf.stf05=l_tlf036
           LET g_stf.stf08=l_tlf10*-1
           LET g_stf.stf11=l_tlf031
        END IF
        #-->檢查是否為成本不計算的倉庫
        #-----MOD-970203---------
        #SELECT imd09 INTO l_imd09 FROM imd_file WHERE imd01=g_stf.stf11
        #IF l_imd09<>'Y' THEN CONTINUE FOREACH END IF
        LET l_cnt = 0 
        SELECT COUNT(*) INTO l_cnt FROM jce_file
         WHERE jce02 = g_stf.stf11
        IF l_cnt > 0 THEN CONTINUE FOREACH END IF
        #-----END MOD-970203----- 
        LET g_stf.stf01=l_sfb02
        LET g_stf.stf06=l_tlf06
        LET g_stf.stf07=l_tlf01
        SELECT stb07+stb08+stb09+stb09a INTO g_stf.stf09 FROM stb_file
          WHERE stb01 = g_stf.stf07 AND stb02 = tm.year AND stb03 = tm.month
        IF STATUS <> 0 THEN LET g_stf.stf09=0 END IF
        LET g_stf.stf10=g_stf.stf09*g_stf.stf08
        INSERT INTO stf_file VALUES(g_stf.*)
     END IF
  END FOREACH
 
  #-->加工費用寫入sth_file(依實際工單發生寫入)
#No.MOD-580325-begin                                                           
  CALL cl_err('','asd-006',0)                                                   
# MESSAGE "02.2匯總委外加工費用!"                                               
#No.MOD-580325-end        
  CALL ui.Interface.refresh()
  DECLARE p120_stgcur CURSOR FOR
   SELECT * FROM stg_file WHERE stg01='7' AND stg02=tm.year AND stg03=tm.month
  FOREACH p120_stgcur INTO g_stg.*
     IF STATUS <> 0 THEN
        LET g_success='N'
        LET g_err="ERR. Foreach error(p120_stg cur)"
       CALL cl_err(g_err,STATUS,1)   
        
        OUTPUT TO REPORT asdp120_rep(g_err)
        EXIT FOREACH
     END IF
     IF g_bgjob = 'N' THEN           #No.FUN-570150
         MESSAGE g_stg.stg04
         CALL ui.Interface.refresh()
     END IF 
     SELECT * FROM sth_file 
      WHERE sth01=tm.year AND sth02=tm.month AND sth03=g_stg.stg04
     IF STATUS <> 0 THEN
         INSERT INTO sth_file(sth01,sth02,sth03,sth04,sth05,sth06,sth07,sthplant,sthlegal)  #No.MOD-470041 #FUN-980008 add
            VALUES(tm.year,tm.month,g_stg.stg04,0,g_stg.stg25,0,g_stg.stg25,g_plant,g_legal) #FUN-980008 add
     ELSE
        UPDATE sth_file SET sth05=sth05+g_stg.stg25,sth07=sth07+g_stg.stg25
         WHERE sth01=tm.year AND sth02=tm.month AND sth03=g_stg.stg04
        IF SQLCA.SQLCODE THEN
           LET g_success='N'
#          CALL cl_err('up_sth_file',SQLCA.SQLCODE,1)   #No.FUN-660120
           CALL cl_err3("upd","sth_file",tm.year,tm.month,SQLCA.sqlcode,"","up_sth_file",1)   #No.FUN-660120
           EXIT FOREACH
        END IF
     END IF
  END FOREACH
END FUNCTION
 
## 彙總月統計資料
FUNCTION p120_p03()
# DEFINE l_rowid  LIKE type_file.chr18    #No.TQC-9A0161
  DEFINE l_i      LIKE type_file.num5,    #No.FUN-690010 SMALLINT
         l_cnt    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
         l_cost   LIKE stb_file.stb04,
         l_stb04  LIKE stb_file.stb04,
         l_stb05  LIKE stb_file.stb05,
         l_stb06  LIKE stb_file.stb06,
         l_stb06a LIKE stb_file.stb06a,
         l_stb07  LIKE stb_file.stb07,
         l_stb08  LIKE stb_file.stb08,
         l_stb09  LIKE stb_file.stb09,
         l_stb09a LIKE stb_file.stb09a,
         l_ste27  LIKE ste_file.ste27,
         l_ste28  LIKE ste_file.ste28,
         l_ste29  LIKE ste_file.ste29,
         l_ste30  LIKE ste_file.ste30
  DEFINE l_sfb RECORD LIKE sfb_file.*
  #No.TQC-9A0161  --Begin
  DEFINE l_stg01  LIKE stg_file.stg01
  DEFINE l_stg02  LIKE stg_file.stg02
  DEFINE l_stg03  LIKE stg_file.stg03
  DEFINE l_stg05  LIKE stg_file.stg05
  DEFINE l_stg051 LIKE stg_file.stg051
  #No.TQC-9A0161  --End  
 
#No.MOD-580325-begin                                                           
  CALL cl_err('','asd-007',0)                                                   
#MESSAGE "03.1匯總本期投入材料"                                                 
#No.MOD-580325-end    
  CALL ui.Interface.refresh() 
  DECLARE p120_031 CURSOR FOR 
   SELECT stf04,SUM(stf10) FROM stf_file 
    WHERE stf02=tm.year AND stf03=tm.month GROUP BY stf04
  FOREACH p120_031 INTO g_stf.stf04,g_stf.stf10
     IF STATUS <> 0 THEN
        LET g_success='N'
        LET g_err="ERR. Foreach error(p120_031 cur)"
       CALL cl_err(g_err,STATUS,1)  
        
        OUTPUT TO REPORT asdp120_rep(g_err)
        EXIT FOREACH
     END IF
     MESSAGE g_stf.stf04
     CALL ui.Interface.refresh()
# 99/04/30 Eric修改:由於使用者在操作上可能會碰到上月工單已結案,結果到下月份
#                   發現需要領退料,會將工單取消結案領退完畢後再做結案,所以
#                   以下檢查改為檢查本月之前是否有ste_file
     LET l_cnt=0
     SELECT COUNT(*) INTO l_cnt FROM ste_file
      WHERE ((ste02=tm.year AND ste03<tm.month) OR (ste02<tm.year))
        AND ste04=g_stf.stf04
     IF STATUS <> 0 OR l_cnt IS NULL THEN
        LET l_cnt=0
     END IF
     SELECT * FROM ste_file 
      WHERE ste02=tm.year AND ste03=tm.month AND ste04=g_stf.stf04
     IF STATUS = 0 THEN
        UPDATE ste_file SET ste12=ste12+g_stf.stf10
         WHERE ste02=tm.year AND ste03=tm.month AND ste04=g_stf.stf04
        IF SQLCA.SQLCODE THEN
           LET g_success='N'
#          CALL cl_err('up_ste_file',SQLCA.SQLCODE,1)   #No.FUN-660120
           CALL cl_err3("upd","ste_file",tm.year,tm.month,SQLCA.sqlcode,"","up_ste_file",1)   #No.FUN-660120
           EXIT FOREACH
        END IF
     ELSE
        LET g_ste.ste02=tm.year
        LET g_ste.ste03=tm.month
        LET g_ste.ste04=g_stf.stf04
        LET g_ste.steplant = g_plant #FUN-980008 add
        LET g_ste.stelegal = g_legal #FUN-980008 add
        CALL p120_initste()
        IF l_cnt > 0 THEN
           LET g_ste.ste11=0
        END IF
        LET g_ste.ste12=g_stf.stf10
        INSERT INTO ste_file VALUES(g_ste.*)
     END IF
  END FOREACH 
#No.MOD-580325-begin                                                           
  CALL cl_err('','asd-008',0)                                                   
#MESSAGE "03.2匯總本期投入人工,制費"                                            
#No.MOD-580325-end       
  CALL ui.Interface.refresh()
  DECLARE p120_032 CURSOR FOR 
   SELECT sth03,sth04,sth05,sth06,sth07 FROM sth_file 
    WHERE sth01=tm.year AND sth02=tm.month
  FOREACH p120_032 INTO g_sth.sth03,g_sth.sth04,g_sth.sth05,g_sth.sth06,
                        g_sth.sth07
     IF STATUS <> 0 THEN
        LET g_success='N'
        LET g_err="ERR. Foreach error(p120_032 cur)"
       CALL cl_err(g_err,STATUS,1)   
        
        OUTPUT TO REPORT asdp120_rep(g_err)
        EXIT FOREACH
     END IF
     SELECT * FROM ste_file 
      WHERE ste02=tm.year AND ste03=tm.month AND ste04=g_sth.sth03
     IF STATUS = 0 THEN
        UPDATE ste_file 
           SET ste13=ste13+g_sth.sth04,
               ste14=ste14+g_sth.sth05,
               ste15=ste15+g_sth.sth06,
               ste32=ste32+g_sth.sth07
         WHERE ste02=tm.year AND ste03=tm.month AND ste04=g_sth.sth03
         IF SQLCA.SQLCODE THEN
            LET g_success='N'
#           CALL cl_err('up_ste_file',SQLCA.SQLCODE,1)   #No.FUN-660120
            CALL cl_err3("upd","ste_file",tm.year,tm.month,SQLCA.sqlcode,"","up_ste_file",1)   #No.FUN-660120
            EXIT FOREACH
         END IF
     ELSE
        LET g_ste.ste02=tm.year
        LET g_ste.ste03=tm.month
        LET g_ste.ste04=g_sth.sth03
        CALL p120_initste()
        LET g_ste.ste13=g_sth.sth04
        LET g_ste.ste14=g_sth.sth05
        LET g_ste.ste15=g_sth.sth06
        LET g_ste.ste32=g_sth.sth07
        LET g_ste.steplant = g_plant #FUN-980008 add
        LET g_ste.stelegal = g_legal #FUN-980008 add
        INSERT INTO ste_file VALUES(g_ste.*)
     END IF
  END FOREACH 
 
 
#No.MOD-580325-begin                                                           
  CALL cl_err('','asd-009',0)                                                   
#MESSAGE "03.2.1匯總本期成本調整"                                               
#No.MOD-580325-end          
  CALL ui.Interface.refresh()
  DECLARE p120_0321 CURSOR FOR 
   SELECT stj03,stj04,stj05,stj06,stj07,stj08 FROM stj_file 
    WHERE stj01=tm.year AND stj02=tm.month
  FOREACH p120_0321 INTO g_stj.stj03,g_stj.stj04,g_stj.stj05,g_stj.stj06,
                         g_stj.stj07,g_stj.stj08
     IF STATUS <> 0 THEN
        LET g_success='N'
        LET g_err="ERR. Foreach error(p120_0321 cur)"
       CALL cl_err(g_err,STATUS,1)   
        
        OUTPUT TO REPORT asdp120_rep(g_err)
        EXIT FOREACH
     END IF
     SELECT * FROM ste_file 
      WHERE ste02=tm.year AND ste03=tm.month AND ste04=g_stj.stj03
     IF STATUS = 0 THEN
        UPDATE ste_file 
           SET ste12=ste12+g_stj.stj04, ste13=ste13+g_stj.stj05,
               ste14=ste14+g_stj.stj06+g_stj.stj08, 
               ste15=ste15+g_stj.stj07,
               ste32=ste32+g_stj.stj08
         WHERE ste02=tm.year AND ste03=tm.month AND ste04=g_stj.stj03
         IF SQLCA.SQLCODE THEN
            LET g_success='N'
#           CALL cl_err('up_ste_file',SQLCA.SQLCODE,1)   #No.FUN-660120
            CALL cl_err3("upd","ste_file",tm.year,tm.month,SQLCA.sqlcode,"","up_ste_file",1)   #No.FUN-660120
            EXIT FOREACH
         END IF
     ELSE
        LET g_ste.ste02=tm.year
        LET g_ste.ste03=tm.month
        LET g_ste.ste04=g_stj.stj03
        CALL p120_initste()
        LET g_ste.ste12=g_stj.stj04
        LET g_ste.ste13=g_stj.stj05
        LET g_ste.ste14=g_stj.stj06+g_stj.stj08
        LET g_ste.ste15=g_stj.stj07
        LET g_ste.ste32=g_stj.stj08
        LET g_ste.steplant = g_plant #FUN-980008 add
        LET g_ste.stelegal = g_legal #FUN-980008 add
        INSERT INTO ste_file VALUES(g_ste.*)
     END IF
  END FOREACH 
 
#No.MOD-580325-begin                                                           
  CALL cl_err('','asd-010',0)                                                   
#MESSAGE "03.4匯總本期轉出資料"                                                 
#No.MOD-580325-end     
  CALL ui.Interface.refresh()
  DECLARE p120_034 CURSOR FOR 
   SELECT stg04,SUM(stg07),SUM(stg12),SUM(stg13),SUM(stg14),SUM(stg15) 
     FROM stg_file 
    WHERE stg02=tm.year AND stg03=tm.month AND stg01 <> 'X'
    GROUP BY stg04
  FOREACH p120_034 INTO g_stg.stg04,g_stg.stg07,g_stg.stg12,g_stg.stg13,
                        g_stg.stg14,g_stg.stg15
     IF STATUS <> 0 THEN
        LET g_success='N'
        LET g_err="ERR. Foreach error(p120_034 cur)"
       CALL cl_err(g_err,STATUS,1)   
        
        OUTPUT TO REPORT asdp120_rep(g_err)
        EXIT FOREACH
     END IF
     SELECT * FROM ste_file 
      WHERE ste02=tm.year AND ste03=tm.month AND ste04=g_stg.stg04
     IF STATUS = 0 THEN
        UPDATE ste_file 
           SET ste16=ste16+g_stg.stg07, ste17=ste17+g_stg.stg12,
               ste18=ste18+g_stg.stg13, ste19=ste19+g_stg.stg14,
               ste20=ste20+g_stg.stg15 
         WHERE ste02=tm.year AND ste03=tm.month AND ste04=g_stg.stg04
         IF SQLCA.SQLCODE THEN
            LET g_success='N'
#           CALL cl_err('up_ste_file',SQLCA.SQLCODE,1)   #No.FUN-660120
            CALL cl_err3("upd","ste_file",tm.year,tm.month,SQLCA.sqlcode,"","up_ste_file",1)   #No.FUN-660120
            EXIT FOREACH
         END IF
     ELSE
        LET g_ste.ste02=tm.year
        LET g_ste.ste03=tm.month
        LET g_ste.ste04=g_stg.stg04
        CALL p120_initste()
        LET g_ste.ste16=g_stg.stg07
        LET g_ste.ste17=g_stg.stg12 
        LET g_ste.ste18=g_stg.stg13
        LET g_ste.ste19=g_stg.stg14
        LET g_ste.ste20=g_stg.stg15 
        LET g_ste.steplant = g_plant #FUN-980008 add
        LET g_ste.stelegal = g_legal #FUN-980008 add
        INSERT INTO ste_file VALUES(g_ste.*)
     END IF
  END FOREACH 
# 扣掉入成本不計算倉的資料
  #No.TQC-9A0161  --Begin
  #DECLARE p120_034d CURSOR FOR 
  # SELECT ROWID,stg04,stg07 FROM stg_file 
  #  WHERE stg02=tm.year AND stg03=tm.month AND stg01 = 'X'
  #FOREACH p120_034d INTO l_rowid,g_stg.stg04,g_stg.stg07
  DECLARE p120_034d CURSOR FOR 
   SELECT stg01,stg02,stg03,stg04,stg05,stg051,stg07 FROM stg_file 
    WHERE stg02=tm.year AND stg03=tm.month AND stg01 = 'X'
  FOREACH p120_034d INTO l_stg01,l_stg02,l_stg03,g_stg.stg04,l_stg05,l_stg051,g_stg.stg07
  #No.TQC-9A0161  --End  
     IF STATUS <> 0 THEN
        LET g_success='N'
        LET g_err="ERR. Foreach error(p120_034d cur)"
       CALL cl_err(g_err,STATUS,1)   
        
        OUTPUT TO REPORT asdp120_rep(g_err)
        EXIT FOREACH
     END IF
     SELECT * FROM ste_file 
      WHERE ste02=tm.year AND ste03=tm.month AND ste04=g_stg.stg04
     IF STATUS = 0 THEN
        UPDATE ste_file 
           SET ste11=ste11+g_stg.stg07
         WHERE ste02=tm.year AND ste03=tm.month AND ste04=g_stg.stg04
         IF SQLCA.SQLCODE THEN
            LET g_success='N'
#           CALL cl_err('up_ste_file',SQLCA.SQLCODE,1)   #No.FUN-660120
            CALL cl_err3("upd","ste_file",tm.year,tm.month,SQLCA.sqlcode,"","up_ste_file",1)   #No.FUN-660120
            EXIT FOREACH
         END IF
     ELSE
        LET g_ste.ste02=tm.year
        LET g_ste.ste03=tm.month
        LET g_ste.ste04=g_stg.stg04
        CALL p120_initste()
        LET g_ste.ste11=g_stg.stg07
        LET g_ste.steplant = g_plant #FUN-980008 add
        LET g_ste.stelegal = g_legal #FUN-980008 add
        INSERT INTO ste_file VALUES(g_ste.*)
     END IF
     #No.TQC-9A0161  --Begin
     #DELETE FROM stg_file WHERE ROWID=l_rowid
     DELETE FROM stg_file 
      WHERE stg01 = l_stg01 
        AND stg02 = l_stg02
        AND stg03 = l_stg03
        AND stg04 = g_stg.stg04
        AND stg05 = l_stg05
        AND stg051= l_stg051
     #No.TQC-9A0161  --End  
  END FOREACH 
 
 
#No.MOD-580325-begin                                                           
  CALL cl_err('','asd-011',0)                                                   
#MESSAGE "03.6匯總本期期末資料"                                                 
#No.MOD-580325-end      
  CALL ui.Interface.refresh()
  DECLARE p120_036 CURSOR FOR 
   SELECT * FROM ste_file WHERE ste02=tm.year AND ste03=tm.month
  FOREACH p120_036 INTO g_ste.*
     IF STATUS <> 0 THEN
        LET g_success='N'
        LET g_err="ERR. Foreach error(p120_036 cur)"
       CALL cl_err(g_err,STATUS,1)   
        
        OUTPUT TO REPORT asdp120_rep(g_err)
        EXIT FOREACH
     END IF
     SELECT * INTO l_sfb.* FROM sfb_file WHERE sfb01=g_ste.ste04
     IF STATUS <> 0 THEN
        LET g_err="工單號碼不存在:",g_ste.ste04
        OUTPUT TO REPORT asdp120_rep(g_err)
        CONTINUE FOREACH
     END IF
     IF l_sfb.sfb04=8 AND l_sfb.sfb38 <= e_date THEN
        LET g_ste.ste31='Y'
     END IF
     LET g_ste.ste26=g_ste.ste06+g_ste.ste11-g_ste.ste16
     LET g_ste.ste27=g_ste.ste07+g_ste.ste12-g_ste.ste17
     LET g_ste.ste28=g_ste.ste08+g_ste.ste13-g_ste.ste18
     LET g_ste.ste29=g_ste.ste09+g_ste.ste14-g_ste.ste19
     LET g_ste.ste30=g_ste.ste10+g_ste.ste15-g_ste.ste20
     IF g_ste.ste31='Y' THEN
        LET g_ste.ste22=g_ste.ste27*-1
        LET g_ste.ste23=g_ste.ste28*-1
        LET g_ste.ste24=g_ste.ste29*-1
        LET g_ste.ste25=g_ste.ste30*-1
        LET g_ste.ste26=0
        LET g_ste.ste27=0
        LET g_ste.ste28=0
        LET g_ste.ste29=0
        LET g_ste.ste30=0
     ELSE
# 期末成本若大於期末數量*標準成本的金額時,超出的部份放到差異欄位
# 99/04/22 修改材料部份含下階人工,製費
        SELECT stb07,stb08,stb09,stb09a ,stb04,stb05,stb06,stb06a
          INTO l_stb07,l_stb08,l_stb09,l_stb09a,
               l_stb04,l_stb05,l_stb06,l_stb06a
          FROM stb_file
         WHERE stb01 = g_ste.ste05 AND stb02 = tm.year AND stb03 = tm.month
        IF STATUS <> 0 THEN
           LET l_stb04=0
           LET l_stb05=0
           LET l_stb06=0
           LET l_stb06a=0
           LET l_stb07=0
           LET l_stb08=0
           LET l_stb09=0
           LET l_stb09a=0
        END IF
        LET l_cost=l_stb07+l_stb08+l_stb09+l_stb09a
        LET l_stb08=l_stb05
        LET l_stb09=l_stb06
        LET l_stb09a=l_stb06a
        LET l_stb07=l_cost-l_stb08-l_stb09-l_stb09a
        LET l_ste27=g_ste.ste26*l_stb07
        LET l_ste28=g_ste.ste26*l_stb08
        LET l_ste29=g_ste.ste26*l_stb09
        LET l_ste30=g_ste.ste26*l_stb09a
        IF g_ste.ste27 < 0 THEN
           LET g_ste.ste22=g_ste.ste27 * -1
           LET g_ste.ste27=0
        END IF
        IF g_ste.ste27>l_ste27 THEN
           LET g_ste.ste22=l_ste27-g_ste.ste27
           LET g_ste.ste27=l_ste27
        END IF
        IF g_ste.ste28 < 0 THEN
           LET g_ste.ste23=g_ste.ste28 * -1
           LET g_ste.ste28=0
        END IF
        IF g_ste.ste28>l_ste28 THEN
           LET g_ste.ste23=l_ste28-g_ste.ste28
           LET g_ste.ste28=l_ste28
        END IF
        IF g_ste.ste29 < 0 THEN
           LET g_ste.ste24=g_ste.ste29 * -1
           LET g_ste.ste29=0
        END IF
        IF g_ste.ste29>l_ste29 THEN
           LET g_ste.ste24=l_ste29-g_ste.ste29
           LET g_ste.ste29=l_ste29
        END IF
        IF g_ste.ste30 < 0 THEN
           LET g_ste.ste25=g_ste.ste30 * -1
           LET g_ste.ste30=0
        END IF
        IF g_ste.ste30>l_ste30 THEN
           LET g_ste.ste25=l_ste30-g_ste.ste30
           LET g_ste.ste30=l_ste30
        END IF
     END IF
     UPDATE ste_file 
        SET ste22=g_ste.ste22, ste23=g_ste.ste23,
            ste24=g_ste.ste24, ste25=g_ste.ste25, ste26=g_ste.ste26,
            ste27=g_ste.ste27, ste28=g_ste.ste28, ste29=g_ste.ste29,
            ste30=g_ste.ste30, ste31=g_ste.ste31
      WHERE ste02=tm.year AND ste03=tm.month AND ste04=g_ste.ste04
      IF SQLCA.SQLCODE THEN
         LET g_success='N'
#        CALL cl_err('up_ste_file',SQLCA.SQLCODE,1)   #No.FUN-660120
         CALL cl_err3("upd","ste_file",tm.year,tm.month,SQLCA.sqlcode,"","up_ste_file",1)   #No.FUN-660120
         EXIT FOREACH
      END IF
  END FOREACH 
END FUNCTION
 
FUNCTION p120_initste()
  DEFINE l_sfb RECORD LIKE sfb_file.*
 
    LET g_ste.ste06=0
    LET g_ste.ste07=0
    LET g_ste.ste08=0
    LET g_ste.ste09=0
    LET g_ste.ste10=0
    LET g_ste.ste11=0
    LET g_ste.ste12=0
    LET g_ste.ste13=0
    LET g_ste.ste14=0
    LET g_ste.ste15=0
    LET g_ste.ste16=0
    LET g_ste.ste17=0
    LET g_ste.ste18=0
    LET g_ste.ste19=0
    LET g_ste.ste20=0
    LET g_ste.ste22=0
    LET g_ste.ste23=0
    LET g_ste.ste24=0
    LET g_ste.ste25=0
    LET g_ste.ste26=0
    LET g_ste.ste27=0
    LET g_ste.ste28=0
    LET g_ste.ste29=0
    LET g_ste.ste30=0
    LET g_ste.ste31='N'
    LET g_ste.ste32=0
    SELECT * INTO l_sfb.* FROM sfb_file WHERE sfb01=g_ste.ste04
    IF STATUS <> 0 THEN
      #LET g_success='N'
       LET g_err="wo no does not exist:",g_ste.ste04
#      CALL cl_err(g_err,STATUS,1)   #No.FUN-660120
       CALL cl_err3("sel","sfb_file",g_ste.ste04,"",STATUS,"","",1)   #No.FUN-660120
       OUTPUT TO REPORT asdp120_rep(g_err)
    END IF
    LET g_ste.ste01=l_sfb.sfb02
    LET g_ste.ste05=l_sfb.sfb05
    LET g_ste.ste11=l_sfb.sfb08
END FUNCTION
 
REPORT asdp120_rep(sr)
   DEFINE l_last_sw LIKE type_file.chr1,         #No.FUN-690010CHAR(1),
          sr        RECORD 
                    text    LIKE type_file.chr1000       #No.FUN-690010CHAR(80)
                    END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
 
      PRINT g_dash[1,g_len]
      PRINT g_x[31] clipped
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      PRINT COLUMN g_c[31],sr.text
 
   ON LAST ROW
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
