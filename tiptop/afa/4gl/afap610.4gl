# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: afap610.4gl
# Descriptions...: 盤點過帳作業        
# Date & Author..: 96/05/15 By Sophia
# Modify.........: No.MOD-570172 05/07/27 By Smapmin 盤點過帳時如發現帳上與實際有差異,
#                  則提示訊息 '盤點數量與帳面有差異, 請執行固定資產盤點差異分析表(afar620),
#                  並處理差異數量!!'且不update回 faj_file主檔.
# Modify.........: No.FUN-570144 06/03/07 By yiting 批次背景執行
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.MOD-660116 06/06/28 By Smapmin  不update faj17
# Modify.........: No.TQC-670005 06/07/04 By Smapmin  盤點量不符時,仍需LET fca15='Y',以利後續數量異動
# Modify.........: No.MOD-670026 06/07/06 By Smapmin 盤點數量有差異的錯誤訊息僅
# Modify.........: No.FUN-680028 06/08/23 By Ray 多帳套修改
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-710028 07/01/22 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.MOD-720007 07/02/02 By Smapmin 增加開窗查詢條件
# Modify.........: No.FUN-8A0086 08/10/22 By chenmoyan 完善FUN-710050的錯誤匯總的修改
# Modify.........: No.FUN-980003 09/08/13 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A10101 10/01/18 By Sarah 若fca05/fca06/fca07/fca10/fca11/fca12為Null時給預設值空白
# Modify.........: No:CHI-A50030 10/06/08 By Summer 增加盤點過帳日
# Modify.........: No:TQC-B20169 11/02/24 By yinhy SELECT faj17-faj58 時缺少faj01的條件
# Modify.........: No:TQC-B20170 11/02/24 By yinhy 缺少faj01的條件
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-AB0088 11/04/07 By lixiang 固定资料財簽二功能
# Modify.........: No:TQC-B60043 11/06/09 By Dido 財簽二相關預設值調整 
# Modify.........: No:MOD-B90112 11/09/15 By johung 不使用財簽二時，財簽二相關必要欄位需給預設值
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_fca		RECORD LIKE fca_file.*,
          g_faj		RECORD LIKE faj_file.*,
         tm             RECORD
          fca01         LIKE fca_file.fca01,  #CHI-A50030 add , 
          posdate       LIKE type_file.dat    #CHI-A50030 add
          END RECORD,
         g_fap          RECORD LIKE fap_file.*,
         g_tmp          LIKE type_file.num10,        #No.FUN-680070 INTEGER
         g_flag         LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
         l_flag         LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          g_wc,g_wc2,g_sql string  #No.FUN-580092 HCN
DEFINE g_change_lang   LIKE type_file.chr1                 #是否有做語言切換 No.FUN-570144       #No.FUN-680070 VARCHAR(01)
DEFINE   g_cnt           LIKE type_file.num10           #No.FUN-680070 INTEGER

MAIN
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   #->No.FUN-570144 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.fca01  = ARG_VAL(1)
   LET tm.posdate = ARG_VAL(2)  #CHI-A50030 add
   LET g_bgjob = ARG_VAL(3)    #背景作業 #CHI-A50030 mod 2->3
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   #->No.FUN-570144 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6A0069 

   LET g_success = 'Y'
   WHILE TRUE
    IF g_bgjob = "N" THEN
      CALL p610_p1()
      IF cl_sure(18,20) THEN
         LET g_success = 'Y'
         BEGIN WORK
         CALL p610_s1()
         CALL s_showmsg()   #No.FUN-710028
         IF g_success = 'Y' THEN
            COMMIT WORK
            CALL cl_end2(1) RETURNING g_flag
         ELSE
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING g_flag
         END IF
        IF g_flag THEN
           CONTINUE WHILE
        ELSE
           CLOSE WINDOW p610_w
           EXIT WHILE
        END IF
    ELSE
        CONTINUE WHILE
    END IF
  ELSE
    BEGIN WORK
    LET g_success = 'Y'
    CALL p610_s1()
    CALL s_showmsg()   #No.FUN-710028
    IF g_success = "Y" THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
    CALL cl_batch_bg_javamail(g_success)
    EXIT WHILE
   END IF
   IF g_flag THEN
      CONTINUE WHILE
      ERROR ''
   ELSE
      EXIT WHILE
   END IF
 END WHILE

 CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p610_p1()

DEFINE   lc_cmd        LIKE type_file.chr1000           #No.FUN-570144       #No.FUN-680070 VARCHAR(500)
 
  OPEN WINDOW p610_w WITH FORM "afa/42f/afap610"
    ATTRIBUTE (STYLE = g_win_style CLIPPED)
  CALL cl_ui_init()
  LET tm.posdate = g_today #CHI-A50030 add

  CALL cl_opmsg('z')
  LET g_bgjob = 'N'  #NO.FUN-570144 
  #->No.FUN-570144 ---end---
   
   WHILE TRUE
     # INPUT BY NAME tm.fca01,tm.a WITHOUT DEFAULTS 
      #INPUT BY NAME tm.fca01 WITHOUT DEFAULTS 
      INPUT BY NAME tm.fca01,tm.posdate,g_bgjob  WITHOUT DEFAULTS   #NO.FUN-570144 #CHI-A50030 add tm.posdate
       ON ACTION locale
#          CALL cl_dynamic_locale()
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#          LET g_action_choice = "locale"
           LET g_change_lang = TRUE                  #NO.FUN-570144 
           EXIT INPUT    
      
         AFTER FIELD fca01
            IF cl_null(tm.fca01) THEN 
               NEXT FIELD fca01
            ELSE
               SELECT COUNT(*) INTO g_cnt
                 FROM fca_file
                WHERE fca01 = tm.fca01
                  AND fca15 = 'N'   #MOD-720007
               IF g_cnt = 0 THEN
                  CALL cl_err(tm.fca01,'afa-032',0)
                  NEXT FIELD fca01
               END IF
            END IF

         #CHI-A50030 add --start--
         AFTER FIELD posdate
            IF tm.posdate IS NULL OR tm.posdate = ' ' THEN
               NEXT FIELD posdate
            END IF
         #CHI-A50030 add --end--
     
{--Genero
         AFTER FIELD a
            IF cl_null(tm.a) OR tm.a NOT MATCHES '[YN]' THEN
               NEXT FIELD a
            END IF
---}
     
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(fca01)
#                 CALL q_fca(10,20,tm.fca01) RETURNING tm.fca01
#                 CALL FGL_DIALOG_SETBUFFER( tm.fca01 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_fca"
                  LET g_qryparam.where = "fca15 = 'N'"   #MOD-720007
                  LET g_qryparam.default1 = tm.fca01
                  CALL cl_create_qry() RETURNING tm.fca01
#                  CALL FGL_DIALOG_SETBUFFER( tm.fca01 )
                  DISPLAY BY NAME tm.fca01
            OTHERWISE EXIT CASE
         END CASE
     
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
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
 
#NO.FUN-570144 start---------------
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin) #NO.FUN-570112 MARK
         CONTINUE WHILE
      END IF
 
#      IF g_action_choice = "locale" THEN
#         LET g_action_choice = ""
#         CALL cl_dynamic_locale()
#         CONTINUE WHILE
#      END IF
 
#      IF INT_FLAG THEN
#         LET INT_FLAG=0 RETURN 
#      END IF
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          CLOSE WINDOW p610_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
          EXIT PROGRAM
       END IF
 
  IF g_bgjob = 'Y' THEN
     SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = 'afap610'
     IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
        CALL cl_err('afap610','9031',1) 
     ELSE
        LET lc_cmd = lc_cmd CLIPPED,
                     " '",tm.fca01 CLIPPED,"'",
                     " '",tm.posdate CLIPPED,"'",  #CHI-A50030 add
                     " '",g_bgjob CLIPPED,"'"
        CALL cl_cmdat('afap610',g_time,lc_cmd CLIPPED)
     END IF
     CLOSE WINDOW p610_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM
  END IF
  EXIT WHILE
END WHILE
#FUN-570123 ---end---
 
#NO.FUN-570144 MARK-----
    #  IF tm.a = 'Y' THEN
#         IF cl_sure(15,17) THEN
#            CALL p610_p2()
    #     END IF
#      ELSE
#         EXIT PROGRAM
#      END IF
#   END WHILE
#NO.FUN-570144 MARK---
 
END FUNCTION
 
FUNCTION p610_p2()
   BEGIN WORK
   LET g_success='Y'
   CALL p610_s1()
   IF g_success = 'Y'
      THEN # CALL cl_cmmsg(1)
           COMMIT WORK
           CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
      ELSE #CALL cl_rbmsg(1)
           ROLLBACK WORK
           CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
   END IF
   IF l_flag THEN
      RETURN            
   ELSE
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
END FUNCTION
 
FUNCTION p610_s1()
  DEFINE  l_fcaqty     LIKE type_file.num5,         #No.FUN-680070 SMALLINT
          l_cnt        LIKE type_file.num5,                #盤點盈虧       #No.FUN-680070 SMALLINT
          l_fap53      LIKE fap_file.fap53,
          l_fap56      LIKE fap_file.fap56,
          l_fap57      LIKE fap_file.fap57,
          l_fap532     LIKE fap_file.fap532,   #No:FUN-AB0088
          l_fap562     LIKE fap_file.fap562,   #No:FUN-AB0088
          l_fap572     LIKE fap_file.fap572,   #No:FUN-AB0088
          l_fap66      LIKE fap_file.fap66,
          l_fap67      LIKE fap_file.fap67,
          l_fap70      LIKE fap_file.fap70,
          l_fap73      LIKE fap_file.fap73,
          l_fap74      LIKE fap_file.fap74,
          l_faj17      LIKE faj_file.faj17,
          l_faj58      LIKE faj_file.faj58,
          l_faj31      LIKE faj_file.faj31,
          l_faj59      LIKE faj_file.faj59,
          l_faj60      LIKE faj_file.faj60,
          l_faj66      LIKE faj_file.faj66,
          l_faj69      LIKE faj_file.faj69,
          l_faj70      LIKE faj_file.faj70
  DEFINE  l_err        LIKE type_file.chr1     #MOD-670026       #No.FUN-680070 VARCHAR(01)
 
  LET g_sql = "SELECT * FROM fca_file ",
              " WHERE fca01 = '",tm.fca01,"' AND fca15='N'"
  PREPARE p610_s1_pre1 FROM g_sql
  DECLARE p610_s1_c CURSOR FOR p610_s1_pre1
  LET l_err = 'N'   #MOD-670026
  CALL s_showmsg_init()  #No.FUN-710028
  FOREACH p610_s1_c INTO g_fca.*
# IF STATUS THEN CALL cl_err('',STATUS,1) END IF          #No.FUN-710028
# IF STATUS THEN CALL s_errmsg('','','',STATUS,0) END IF  #No.FUN-710028 #No.FUN-8A0086
  IF STATUS THEN                                          #No.FUN-8A0086
     CALL s_errmsg('','','',STATUS,0)                     #No.FUN-8A0086
     LET g_success = 'N'                                  #No.FUN-8A0086
  END IF                                                  #No.FUN-8A0086
#No.FUN-710028 --begin                                                                                                              
  IF g_success='N' THEN                                                                                                         
     LET g_totsuccess='N'                                                                                                       
     LET g_success="Y"                                                                                                          
  END IF                                                                                                                        
#No.FUN-710028 -end
 
  INITIALIZE g_fap.* TO NULL
  SELECT faj17-faj58 INTO l_fcaqty
    FROM faj_file
   WHERE faj02  = g_fca.fca03
     AND faj022 = g_fca.fca031
     AND faj01 = g_fca.fca04   #No.TQC-B20169
  IF cl_null(g_fca.fca05) THEN LET g_fca.fca05=' ' END IF   #MOD-A10101 add
  IF cl_null(g_fca.fca06) THEN LET g_fca.fca06=' ' END IF   #MOD-A10101 add
  IF cl_null(g_fca.fca07) THEN LET g_fca.fca07=' ' END IF   #MOD-A10101 add
  IF cl_null(g_fca.fca10) THEN LET g_fca.fca10=' ' END IF   #MOD-A10101 add
  IF cl_null(g_fca.fca11) THEN LET g_fca.fca11=' ' END IF   #MOD-A10101 add
  IF cl_null(g_fca.fca12) THEN LET g_fca.fca12=' ' END IF   #MOD-A10101 add
  IF l_fcaqty != g_fca.fca09 OR g_fca.fca05 != g_fca.fca10 OR
     g_fca.fca06 != g_fca.fca11 OR g_fca.fca07 != g_fca.fca12 THEN
    # ------------------------(1.1)
      SELECT * INTO g_faj.* FROM faj_file
       WHERE faj02  = g_fca.fca03
         AND faj022 = g_fca.fca031
         AND faj01 = g_fca.fca04   #No.TQC-B20170
      LET g_cnt = 0
      LET l_cnt = g_fca.fca09 - l_fcaqty
      IF l_cnt >= 0 THEN           #盤盈
         LET l_fap53 = ''
         LET l_fap56 = ''
         LET l_fap57 = ''
         LET l_fap66 = l_cnt
         LET l_fap67 = 0
         LET l_fap70 = ''
         LET l_fap73 = ''
         LET l_fap74 = ''
         LET l_faj17 = g_faj.faj17 + l_cnt
         #-----No:FUN-AB0088-----
         IF g_faa.faa31 = 'Y' THEN
            LET l_fap532 = g_faj.faj312  #TQC-B60043 mod '' -> g_faj.faj312
            LET l_fap562 = g_faj.faj592  #TQC-B60043 mod '' -> g_faj.faj592 
            LET l_fap572 = g_faj.faj602  #TQC-B60043 mod '' -> g_faj.faj602 
         END IF
         #-----No:FUN-AB0088 END-----
      ELSE                          #盤虧
         LET g_cnt = g_cnt - l_cnt
         LET l_fap53 = g_faj.faj31 / (g_faj.faj17- g_faj.faj58) * g_cnt
         LET l_fap56 = (g_faj.faj14 - g_faj.faj59 - (g_faj.faj32 - g_faj.faj60))
                       / (g_faj.faj17 - g_faj.faj58) * g_cnt
         LET l_fap57 = g_faj.faj32 / (g_faj.faj17 - g_faj.faj58) * g_cnt
         LET l_fap66 = 0
         LET l_fap67 = g_cnt
         LET l_fap70 = g_faj.faj66 / (g_faj.faj17 - g_faj.faj58) * g_cnt
         LET l_fap73 = (g_faj.faj62 - g_faj.faj69 -(g_faj.faj67 - g_faj.faj70))
                       / (g_faj.faj17 - g_faj.faj58) * g_cnt
         LET l_fap74 = g_faj.faj67 / (g_faj.faj17 - g_faj.faj58) * g_cnt
         LET l_faj58 = g_faj.faj58 + g_cnt
         LET l_faj31 = g_faj.faj31 - g_faj.faj31 / (g_faj.faj17 - g_faj.faj58)
                       * g_cnt
         LET l_faj59 = g_faj.faj59 + (g_faj.faj62 - g_faj.faj69) /     
                       (g_faj.faj17 - g_faj.faj58) * g_cnt
         LET l_faj60 = g_faj.faj60 + g_faj.faj67 / (g_faj.faj17 - g_faj.faj58)
                       * g_cnt
         LET l_faj66 = g_faj.faj66 - g_faj.faj66 / (g_faj.faj17 - g_faj.faj58)
                       * g_cnt
         LET l_faj69 = g_faj.faj69 + (g_faj.faj62 - g_faj.faj69) / 
                       (g_faj.faj17 - g_faj.faj58) * g_cnt
         LET l_faj70 = g_faj.faj70 + g_faj.faj67 / (g_faj.faj17 - g_faj.faj58)
                       * g_cnt
         #-----No:FUN-AB0088-----
         IF g_faa.faa31 = 'Y' THEN
            LET l_fap532 = g_faj.faj312 / (g_faj.faj17- g_faj.faj582) * g_cnt
            LET l_fap562 = (g_faj.faj142 - g_faj.faj592 - (g_faj.faj322 - g_faj.faj602))
                          / (g_faj.faj17 - g_faj.faj582) * g_cnt
            LET l_fap572 = g_faj.faj322 / (g_faj.faj17 - g_faj.faj582) * g_cnt
         END IF
         #-----No:FUN-AB0088 END-----
      END IF
      LET g_fap.fap01 = g_fca.fca04
      LET g_fap.fap02 = g_fca.fca03
      LET g_fap.fap021= g_fca.fca031
      LET g_fap.fap03 = '2'
     #LET g_fap.fap04 = g_today #CHI-A50030 mark
      #CHI-A50030 add --start--
      #-->如有盤點日期則以此為基準
      IF tm.posdate IS NOT NULL AND tm.posdate !=' ' THEN
         LET g_fap.fap04 = tm.posdate 
      ELSE
         LET g_fap.fap04 = g_today
      END IF
      #CHI-A50030 add --end--
      LET g_fap.fap05 = g_faj.faj43
      LET g_fap.fap06 = g_faj.faj28
      LET g_fap.fap07 = g_faj.faj30
      LET g_fap.fap08 = g_faj.faj31
      LET g_fap.fap09 = g_faj.faj14
      LET g_fap.fap10 = g_faj.faj141
      LET g_fap.fap101= g_faj.faj33
      LET g_fap.fap11 = g_faj.faj32
      LET g_fap.fap12 = g_faj.faj53
      LET g_fap.fap13 = g_faj.faj54
      LET g_fap.fap14 = g_faj.faj55
      #No.FUN-680028 --begin
   #  IF g_aza.aza63 = 'Y' THEN
      IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088 
         LET g_fap.fap121= g_faj.faj531
         LET g_fap.fap131= g_faj.faj541
         LET g_fap.fap141= g_faj.faj551
      END IF
      #No.FUN-680028 --end
      LET g_fap.fap15 = g_faj.faj23
      LET g_fap.fap16 = g_faj.faj24
      LET g_fap.fap17 = g_faj.faj20
      LET g_fap.fap18 = g_faj.faj19
      LET g_fap.fap19 = g_faj.faj21
      LET g_fap.fap20 = g_faj.faj17
      LET g_fap.fap201= g_faj.faj171
      LET g_fap.fap21 = g_faj.faj58
      LET g_fap.fap22 = g_faj.faj59
      LET g_fap.fap23 = g_faj.faj60
      LET g_fap.fap24 = g_faj.faj34
      LET g_fap.fap25 = g_faj.faj35
      LET g_fap.fap26 = g_faj.faj36
      LET g_fap.fap30 = g_faj.faj61
      LET g_fap.fap31 = g_faj.faj65
      LET g_fap.fap32 = g_faj.faj66
      LET g_fap.fap33 = g_faj.faj62
      LET g_fap.fap34 = g_faj.faj63
      LET g_fap.fap341= g_faj.faj68
      LET g_fap.fap35 = g_faj.faj67
      LET g_fap.fap36 = g_faj.faj69
      LET g_fap.fap37 = g_faj.faj70
      LET g_fap.fap38 = g_faj.faj71
      LET g_fap.fap39 = g_faj.faj72
      LET g_fap.fap40 = g_faj.faj73
      LET g_fap.fap41 = g_faj.faj100
      LET g_fap.fap42 = ''
      LET g_fap.fap43 = ''
      LET g_fap.fap44 = ''
      LET g_fap.fap45 = ''
      LET g_fap.fap50 = g_fca.fca01
      LET g_fap.fap501= g_fca.fca02
      LET g_fap.fap51 = ''
      LET g_fap.fap52 = 0
      LET g_fap.fap53 = l_fap53
      LET g_fap.fap54 = 0
      LET g_fap.fap55 = 0
      LET g_fap.fap56 = l_fap56
      LET g_fap.fap57 = l_fap57
      LET g_fap.fap58 = ''
      LET g_fap.fap59 = ''
      LET g_fap.fap60 = ''
      LET g_fap.fap61 = ''
      LET g_fap.fap62 = ''
      LET g_fap.fap63 = g_fca.fca10
      LET g_fap.fap64 = g_fca.fca11
      LET g_fap.fap65 = g_fca.fca12
      LET g_fap.fap66 = l_fap66
      LET g_fap.fap661= 0
      LET g_fap.fap67 = l_fap67
      LET g_fap.fap68 = ''
      LET g_fap.fap69 = 0
      LET g_fap.fap70 = l_fap70
      LET g_fap.fap71 = 0
      LET g_fap.fap711= 0
      LET g_fap.fap72 = 0
      LET g_fap.fap73 = l_fap73
      LET g_fap.fap74 = l_fap74
      LET g_fap.fap75 = ''
      LET g_fap.fap76 = ''
      LET g_fap.fap77 = g_faj.faj43
      LET g_fap.fap78 = ''
      LET g_fap.fap79 = ''
      LET g_fap.fap80 = ''
      LET g_fap.faplegal = g_legal  #FUN-980003 add
     
#MOD-B90112 -- begin --
      LET g_fap.fap052  = '0'
      LET g_fap.fap062  = '1'
      LET g_fap.fap082  = 0
      LET g_fap.fap092  = 0
      LET g_fap.fap1012 = 0
      LET g_fap.fap103  = 0
      LET g_fap.fap112  = 0
      LET g_fap.fap152  = '1'
      LET g_fap.fap222  = 0
      LET g_fap.fap232  = 0
      LET g_fap.fap242  = 'N'
      LET g_fap.fap252  = 0
      LET g_fap.fap512  = '1'
      LET g_fap.fap532  = 0
      LET g_fap.fap542  = 0
      LET g_fap.fap552  = 0
      LET g_fap.fap562  = 0
      LET g_fap.fap572  = 0
      LET g_fap.fap612  = '1'
      LET g_fap.fap772  = '0'
      LET g_fap.fap802  = 0
      LET g_fap.fap6612 = 0
#MOD-B90112 -- end --

      #-----No:FUN-AB0088-----
      IF g_faa.faa31 = 'Y' THEN
         LET g_fap.fap052 = g_faj.faj432
         LET g_fap.fap062 = g_faj.faj282
         LET g_fap.fap072 = g_faj.faj302
         LET g_fap.fap082 = g_faj.faj312
         LET g_fap.fap092 = g_faj.faj142
        #LET g_fap.fap102 = g_faj.faj1412
         LET g_fap.fap103 = g_faj.faj1412   #No:FUN-B30036
         LET g_fap.fap1012= g_faj.faj332
         LET g_fap.fap112 = g_faj.faj322
         LET g_fap.fap152 = g_faj.faj232
         LET g_fap.fap162 = g_faj.faj242
         LET g_fap.fap212 = g_faj.faj582
         LET g_fap.fap222 = g_faj.faj592
         LET g_fap.fap232 = g_faj.faj602
         LET g_fap.fap242 = g_faj.faj342
         LET g_fap.fap252 = g_faj.faj352
         LET g_fap.fap262 = g_faj.faj362
         LET g_fap.fap512 = g_faj.faj282   #TQC-B60043 mod '' -> g_faj.faj282
         LET g_fap.fap522 = 0
         LET g_fap.fap532 = l_fap532
         LET g_fap.fap542 = 0
         LET g_fap.fap552 = 0
         LET g_fap.fap562 = l_fap562
         LET g_fap.fap572 = l_fap572
         LET g_fap.fap612 = g_faj.faj232   #TQC-B60043 mod '' -> g_faj.faj232 
         LET g_fap.fap622 = g_faj.faj242   #TQC-B60043 mod '' -> g_faj.faj242 
         LET g_fap.fap6612= 0
         LET g_fap.fap672 = l_fap67
         LET g_fap.fap772 = g_faj.faj432
         LET g_fap.fap802 = g_faj.faj1012  #TQC-B60043 mod '' -> g_faj.faj1012
      END IF
      #-----No:FUN-AB0088 END----- 
     INSERT INTO fap_file VALUES (g_fap.*)
     #---97/10/17 modify
     #INSERT INTO fap_file
     #  VALUES (g_fca.fca04,g_fca.fca03,g_fca.fca031,'2',g_today,g_faj.faj43,
     #          g_faj.faj28,g_faj.faj30,g_faj.faj31,g_faj.faj14,g_faj.faj141,
     #          g_faj.faj33,g_faj.faj32,g_faj.faj53,g_faj.faj54,g_faj.faj55,
     #          g_faj.faj23,g_faj.faj24,g_faj.faj20,g_faj.faj19,g_faj.faj21,
     #          g_faj.faj17,g_faj.faj171,g_faj.faj58,g_faj.faj59,g_faj.faj60,
     #          g_faj.faj34,g_faj.faj35,g_faj.faj36,g_faj.faj61,g_faj.faj65,
     #          g_faj.faj66,g_faj.faj62,g_faj.faj63,g_faj.faj68,g_faj.faj67,
     #          g_faj.faj69,g_faj.faj70,g_faj.faj71,g_faj.faj72,g_faj.faj73,
     #          g_faj.faj100,'','',' ',0,
     #          g_fca.fca01,g_fca.fca02,'',0,l_fap53,0,0,l_fap56,
     #          l_fap57,'','','','','',g_fca.fca10,g_fca.fca11,g_fca.fca12,
     #          l_fap66,0,l_fap67,'',0,l_fap70,0,0,0,l_fap73,l_fap74,
     #          '','',g_faj.faj43,'',' ',0)   
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#        CALL cl_err('Ins :',SQLCA.sqlcode,1)   #No.FUN-660136
#        CALL cl_err3("ins","fap_file",g_fap.fap02,g_fap.fap03,SQLCA.sqlcode,"","Ins :",1)   #No.FUN-660136 #No.FUN-710028
         LET g_showmsg = g_fap.fap02,"/",g_fap.fap021,"/",g_fap.fap03,"/",g_fap.fap04  #No.FUN-710028
         CALL s_errmsg('fap02,fap021,fap03,fap04',g_showmsg,'Ins :',SQLCA.sqlcode,1)   #No.FUN-710028
         LET g_success = 'N'
      END IF
 
     #-------------------------(1.2)
 #MOD-570172
      IF l_cnt = 0 THEN
         #UPDATE faj_file SET (faj17,faj19,faj20,faj21)   #MOD-660116
         #                  = (l_faj17,g_fca.fca11,g_fca.fca10,g_fca.fca12)   #MOD-660116
     UPDATE faj_file SET 
              faj19=g_fca.fca11,
              faj20=g_fca.fca10,faj21=g_fca.fca12
          WHERE faj02  = g_fca.fca03
            AND faj022 = g_fca.fca031
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#           CALL cl_err('Update1:',SQLCA.sqlcode,1)   #No.FUN-660136
#           CALL cl_err3("upd","faj_file",g_fca.fca03,g_fca.fca031,SQLCA.sqlcode,"","Update1:",1)   #No.FUN-660136 #No.FUN-710028
            LET g_showmsg = g_fca.fca03,"/",g_fca.fca031                        #No.FUN-710028
            CALL s_errmsg('faj02,faj022',g_Showmsg,'Update1:',SQLCA.sqlcode,1)  #No.FUN-710028
            LET g_success = 'N'
         END IF
      ELSE
         LET l_err = 'Y'   #MOD-670026
         #CALL cl_err('','afa-201',1)   #MOD-670026
         #LET g_success = 'N'   #TQC-670005
      END IF
{
      IF l_cnt >= 0 THEN
         UPDATE faj_file SET (faj17,faj19,faj20,faj21)
                           = (l_faj17,g_fca.fca11,g_fca.fca10,g_fca.fca12)
          WHERE faj02  = g_fca.fca03
            AND faj022 = g_fca.fca031
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#           CALL cl_err('Update1:',SQLCA.sqlcode,1)   #No.FUN-660136
            CALL cl_err3("upd","faj_file",g_fca.fca03,g_fca.fca031,SQLCA.sqlcode,"","Update1:",1)   #No.FUN-660136
            LET g_success = 'N'
         END IF
      ELSE
         UPDATE faj_file SET 
               faj19=g_fca.fca11,faj20=g_fca.fca10,
               faj21=g_fca.fca12,faj31=l_faj31,
               faj58=l_faj58,faj59=l_faj59,
               faj60=l_faj60,faj66=l_faj66,
               faj69=l_faj69,faj70=l_faj70
          WHERE faj02  = g_fca.fca03
            AND faj022 = g_fca.fca031
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#           CALL cl_err('Update2:',SQLCA.sqlcode,1)   #No.FUN-660136
            CALL cl_err3("upd","faj_file",g_fca.fca03,g_fca.fca031,SQLCA.sqlcode,"","Update2:",1)   #No.FUN-660136
            LET g_success = 'N'
         END IF
      END IF
}
 #END MOD-570172
  END IF
  #----------------(2)----------------- 
#  IF tm.a = 'Y' THEN
    IF g_success = 'Y' THEN    #MOD-570172
      UPDATE fca_file SET fca15 = 'Y'
       WHERE fca01 = tm.fca01
         AND fca02 = g_fca.fca02
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#        CALL cl_err('Update3:',SQLCA.sqlcode,1)   #No.FUN-660136
#        CALL cl_err3("upd","fca_file",tm.fca01,g_fca.fca02,SQLCA.sqlcode,"","Update3:",1)   #No.FUN-660136 #No,FUN-710028
         LET g_showmsg = tm.fca01,"/",g_fca.fca02                          #No.FUN-710028
         CALL s_errmsg('fca01,fca02',g_showmsg,'Update3:',SQLCA.sqlcode,1) #No.FUN-710028
         LET g_success = 'N'
      END IF
     END IF   #MOD-570172
#  END IF
 # IF g_success = 'Y'
 #    THEN CALL cl_cmmsg(1) COMMIT WORK
 #    ELSE CALL cl_rbmsg(1) ROLLBACK WORK
 # END IF
  END FOREACH
#No.FUN-710028 --begin                                                                                                              
  IF g_totsuccess="N" THEN                                                                                                        
     LET g_success="N"                                                                                                            
  END IF                                                                                                                          
#No.FUN-710028 --end
 
  #-----MOD-670026---------
  IF l_err = 'Y' THEN
#    CALL cl_err('','afa-201',1)         #No.FUN-710028
     CALL s_errmsg('','','','afa-201',1) #No.FUN-710028
  END IF
  #-----END MOD-670026-----
END FUNCTION
