# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: asfp611.4gl
# Descriptions...: 備料資料刪除作業
# Date & Author..: 92/08/10 By Yen
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.FUN-680121 06/08/29 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-710026 07/01/15 By hongmei 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-710108 07/04/04 By chenl   程序未修改，僅修改了ORA文檔，此處僅為過單用
# Modify.........: No.FUN-7B0018 08/02/20 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-830132 08/04/01 By hellen 修改delete sfa_file
# Modify.........: No.CHI-7B0034 08/07/08 By sherry 增加被替代料為Key值
# Modify.........: No.FUN-7C0087 08/09/22 By sherry 刪除時的異動記錄寫入azo_file里
# Modify.........: No.FUN-8A0086 08/10/21 By baofei 完善FUN-710050的錯誤匯總的修改
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.TQC-950134 09/05/22 By Carrier rowid定義規範化
# Modify.........: No.FUN-980008 09/08/14 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0072 10/01/11 By vealxu 精簡程式碼
# Modify.........: No.TQC-A50027 10/05/14 By houlia sma8872刪除后程序做相應調整
# Modify.........: No.FUN-A60027 10/06/08 By vealxu 製造功能優化-平行制程（批量修改） 
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No:TQC-C10115 12/01/30 By jason  31區rebuild的結果錯誤排除
# Modify.........: No.TQC-D70074 13/07/22 By lujh 1.“工單編號”，“生產料件”欄位建議增加開窗
#                                                 2.無法ctrl+g
#                                                 3.幫助文檔為灰色，無法打開help文件



DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD   #TQC-C10115
          wc    LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(300)# Where condition
          a     LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)
          END RECORD,
#      g_sma8872   LIKE type_file.chr1,       #No.FUN-680121 VARCHAR(1)    #TQC-A50027   mark
       sr RECORD
          sfb01    LIKE sfb_file.sfb01,
          sfb02    LIKE sfb_file.sfb02,
          sfb04    LIKE sfb_file.sfb04,
          sfb05    LIKE sfb_file.sfb05
          END RECORD
 
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-7C0087 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123 
 
 
   IF s_shut(0) THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123 
      EXIT PROGRAM 
   END IF
   CALL p611_tm(0,0)                #
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION p611_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5          #No.FUN-680121 SMALLINT
   DEFINE l_flag LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
   LET p_row = 6
   LET p_col = 20
 
   OPEN WINDOW p611_w AT p_row,p_col WITH FORM "asf/42f/asfp611"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
   CALL cl_opmsg('q')
 
#  LET g_sma8872 = g_sma.sma887[2,2]              #TQC-A50027   mark
 
   WHILE TRUE
      CLEAR FORM
      INITIALIZE tm.* TO NULL            # Default condition
      LET tm.a = 'Y'
      CONSTRUCT BY NAME tm.wc ON sfb01,sfb05
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
         ON ACTION locale
            LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            EXIT CONSTRUCT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         #TQC-D70074--add--str--
         ON ACTION controlp
           CASE
              WHEN INFIELD(sfb01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form = "q_sfb01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfb01
                  NEXT FIELD sfb01
              WHEN INFIELD(sfb05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form = "q_sfb05_1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfb05
                  NEXT FIELD sfb05
              OTHERWISE
                 EXIT CASE
           END CASE

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION help
            CALL cl_show_help()
         #TQC-D70074--add--end--
      END CONSTRUCT
 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p611_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM
      END IF
      CALL p611_cnt() RETURNING g_cnt
      IF g_cnt = 0 THEN
         CALL cl_err('construct:','mfg6159',0)
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME tm.a  # Condition
 
      INPUT BY NAME tm.a WITHOUT DEFAULTS
 
         AFTER FIELD a
            IF tm.a NOT MATCHES "[YN]" THEN
               NEXT FIELD a
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
         #TQC-D70074--add--str--
         ON ACTION help
            CALL cl_show_help()
         #TQC-D70074--add--end--
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM
      END IF
 
      IF cl_sure(20,22) THEN
         CALL cl_wait()
         CALL asfp611()    #show 欲刪除之資料
         IF g_success = 'Y' THEN
            COMMIT WORK
            CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
         ELSE
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
         END IF
         IF l_flag THEN
            CONTINUE WHILE
         ELSE
            EXIT WHILE
         END IF
      END IF
      ERROR ""
   END WHILE
   CLOSE WINDOW p611_w
END FUNCTION
 
FUNCTION asfp611()
      DEFINE  l_sql     LIKE type_file.chr1000, #RDSQL STATEMENT       #No.FUN-680121 VARCHAR(611)   #No.FUN-6A0090
              l_count   LIKE type_file.num5,    #No.FUN-680121 SMALINT
              l_buf     LIKE type_file.chr1000  #No.FUN-680121 VARCHAR(80)
 
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
 
   LET l_sql = " SELECT sfb01,sfb02,sfb04,sfb05 ",
               " FROM sfb_file",
               " WHERE  sfb23  = 'Y'",
               "   AND  sfb02 != 5 AND sfb02 != 11",
               "   AND  sfbacti = 'Y' AND sfb87!='X' "
#TQC-A50027---------------------modify
      LET l_sql = l_sql CLIPPED," AND sfb04 = '1' ",
                 "   AND ",tm.wc CLIPPED
#  IF g_sma8872 ='Y' THEN
#     LET l_sql = l_sql CLIPPED," AND sfb04 IN ('1','2','3') ",
#                "   AND ",tm.wc CLIPPED
#  ELSE
#     LET l_sql = l_sql CLIPPED," AND sfb04 IN ('1','2') ",
#                "   AND ",tm.wc CLIPPED
#  END IF
#TQC-A50027---------------------end
   LET l_count = 0
   PREPARE p611_prepare1 FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      RETURN
   END IF
   LET g_success = 'Y'
   BEGIN WORK
   DECLARE p611_cs  CURSOR FOR p611_prepare1
   LET g_chr = ' '
   IF tm.a = 'N' THEN
      CALL p611_cnt() RETURNING g_cnt
      LET g_chr = 'Y'
      CALL p611_del()
   ELSE
      CALL p611_cnt() RETURNING g_cnt
      CALL p611_del()
   END IF
 
END FUNCTION
 
FUNCTION p611_del()
   DEFINE
      l_cnt1,l_cnt2    LIKE type_file.num5,       # Already-cnt, N-cnt  #No.FUN-680121 SMALLINT
      l_cnt3           LIKE type_file.num5        # 有委外代買否        #No.FUN-680121 SMALLINT
   DEFINE l_buf,l_buf1 LIKE type_file.chr1000                           #No.FUN-680121 VARCHAR(120)
   DEFINE l_sfa03      LIKE sfa_file.sfa03        #No.FUN-7B0018
   DEFINE l_sfa08      LIKE sfa_file.sfa08        #No.FUN-7B0018
   DEFINE l_sfa12      LIKE sfa_file.sfa12        #No.FUN-7B0018
   DEFINE l_sfa        RECORD LIKE sfa_file.*     #No.FUN-830132 080401 add
   DEFINE l_msg        LIKE type_file.chr1000     #No.FUN-7C0087 
   DEFINE l_msg1       LIKE type_file.chr1000     #No.FUN-7C0087 
   DEFINE l_msg2       LIKE type_file.chr1000     #No.FUN-7C0087 
   LET g_chr = ' '
   LET l_cnt1 = 0
   LET l_cnt2 = 0
   CALL s_showmsg_init()    #NO.FUN-710026
   FOREACH p611_cs INTO sr.*
          IF g_success='N' THEN                                                                                                          
             LET g_totsuccess='N'                                                                                                       
             LET g_success="Y"                                                                                                          
          END IF                    
 
      IF SQLCA.sqlcode THEN
         LET g_success= 'N' #No.FUN-8A0086
         CALL s_errmsg('','','foreach:',SQLCA.sqlcode,1)     #NO.FUN-710026
         EXIT FOREACH
      END IF
      SELECT COUNT(*) INTO l_cnt3 FROM rvp_file
       WHERE rvp01 = sr.sfb01
      IF tm.a = 'Y' THEN
         LET l_cnt1 = l_cnt1 + 1
         IF l_cnt1 > g_cnt THEN
            EXIT FOREACH
         END IF
         IF l_cnt3 = 0 THEN
           #清除資料總筆數:/明細--工單編號:工單型態: 料件編號:筆數:
            CALL cl_getmsg('mfg6155',g_lang) RETURNING l_buf1
 
            LET l_buf=l_buf1[1,15] CLIPPED,g_cnt USING '##&' CLIPPED
            LET l_buf=l_buf CLIPPED,' ',l_buf1[16,31] CLIPPED,sr.sfb01 CLIPPED
            LET l_buf=l_buf CLIPPED,' ',l_buf1[32,40] CLIPPED,sr.sfb02 CLIPPED
            LET l_buf=l_buf CLIPPED,' ',l_buf1[42,50] CLIPPED,sr.sfb05 CLIPPED
            LET l_buf=l_buf CLIPPED,' ',l_buf1[51,55] CLIPPED,l_cnt1 CLIPPED
            IF NOT cl_confirm(l_buf CLIPPED) THEN
               RETURN
            ELSE
               LET g_chr = 'Y'
            END IF
         ELSE
            LET g_chr ='N'
         END IF
      ELSE
         LET l_cnt1 = l_cnt1 + 1
         IF l_cnt1 > g_cnt THEN
            EXIT FOREACH
         END IF
         IF l_cnt3 = 0 THEN
            MESSAGE sr.sfb01
            CALL ui.Interface.refresh()
         ELSE
            LET g_chr ='N'
         END IF
      END IF
      IF g_chr MATCHES "[Yy]" OR cl_null(g_chr) THEN
         DECLARE sel_sfa CURSOR FOR
          SELECT * FROM sfa_file
           WHERE sfa01 = sr.sfb01
             AND sfa06 = 0
         FOREACH sel_sfa INTO l_sfa.*
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            DELETE FROM sfa_file
             WHERE sfa01 = l_sfa.sfa01
               AND sfa03 = l_sfa.sfa03
               AND sfa08 = l_sfa.sfa08
               AND sfa12 = l_sfa.sfa12
               AND sfa27 = l_sfa.sfa27      #CHI-7B0034
               AND sfa012  = l_sfa.sfa012   #FUN-A60027
               AND sfa013  = l_sfa.sfa013   #FUN-A60027 
            IF SQLCA.sqlcode THEN
               LET g_success = 'N'
               CALL s_errmsg('','','(asfp611:ckp#1)',SQLCA.sqlcode,1)                            #NO.FUN-710026
               CONTINUE FOREACH          #No.FUN-830132 080401 add
            ELSE
               IF NOT s_industry('std') THEN
                  IF NOT s_del_sfai(l_sfa.sfa01,l_sfa.sfa03,l_sfa.sfa08,
                                    l_sfa.sfa12,l_sfa.sfa27,'',l_sfa.sfa012,l_sfa.sfa013) THEN #CHI-7B0034   #FUN-A60027 add sfa012,sf013
                     LET g_success = 'N'
                     CONTINUE FOREACH    #No.FUN-830132 080401 add
                  END IF
               END IF
            END IF
         END FOREACH
         
         SELECT ze03 INTO l_msg1 FROM ze_file  
          WHERE ze01 = 'asf1001' AND ze02 = g_lang
         SELECT ze03 INTO l_msg2 FROM ze_file  
          WHERE ze01 = 'asf-124' AND ze02 = g_lang 
         LET l_msg = l_msg1,sr.sfb01 CLIPPED,l_msg2 
         LET g_msg=TIME
         INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)   #FUN-980008 add
                VALUES ('asfp611',g_user,g_today,g_msg,sr.sfb01,l_msg,g_plant,g_legal) #FUN-980008 add
         
         UPDATE sfb_file SET sfb23 = 'N' WHERE sfb01 = sr.sfb01                        #09/10/21 xiaofeizhu Add
         IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            CALL s_errmsg('','','(asfp611:ckp#2)',SQLCA.sqlcode,1)                            #NO.FUN-710026  
         END IF
         IF sr.sfb04 = '3' THEN
            UPDATE sfb_file SET sfb04 = '2' WHERE sfb01 = sr.sfb01                     #09/10/21 xiaofeizhu Add
            IF SQLCA.sqlcode THEN
               LET g_success = 'N'
               CALL s_errmsg('','','(asfp611:ckp#3)',SQLCA.sqlcode,1)                            #NO.FUN-710026
            END IF
         END IF
      ELSE
         IF tm.a = 'Y' THEN
            LET l_cnt2 = l_cnt2 + 1
           #DISPLAY l_cnt2 USING "###&" AT 2,53   #CHI-A70049 mark
         END IF
         LET g_success = 'N'
      END IF
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                         
      LET g_success="N"                                                                                                             
   END IF 
   CALL s_showmsg()
 
END FUNCTION
 
FUNCTION p611_cnt()
   DEFINE l_sql     LIKE type_file.chr1000    # RDSQL STATEMENT        #No.FUN-680121 VARCHAR(611)
   LET g_cnt = 0
   LET l_sql = " SELECT COUNT(*) FROM sfb_file ",
               " WHERE  sfb23  = 'Y'",
               "   AND  sfb02 != 5 AND sfb02 != 11 ",
               "   AND  sfbacti = 'Y'"
#TQC-A50027-----------------------modify
      LET l_sql = l_sql CLIPPED," AND sfb04 ='1' ",
                  "   AND ",tm.wc CLIPPED
#  IF g_sma8872 ='Y' THEN
#     LET l_sql = l_sql CLIPPED," AND sfb04 IN ('1','2','3') ",
#                 "   AND ",tm.wc CLIPPED
#  ELSE
#     LET l_sql = l_sql CLIPPED," AND sfb04 IN ('1','2') ",
#                 "   AND ",tm.wc CLIPPED
#  END IF
#TQC-A50027------------------------end
   PREPARE p611_precount FROM l_sql
   DECLARE p611_count CURSOR FOR p611_precount
   OPEN p611_count
   FETCH p611_count INTO g_cnt
   RETURN g_cnt
END FUNCTION
 
FUNCTION p611_ima()
   DEFINE
      l_sfa05 LIKE sfa_file.sfa05,
      l_sfa25 LIKE sfa_file.sfa25,
      l_sfa03 LIKE sfa_file.sfa03,
      l_sfa13 LIKE sfa_file.sfa13
 
   DECLARE p611_sfa_cs CURSOR WITH HOLD FOR
   SELECT sfa03,sfa05,sfa13,sfa25 FROM sfa_file
   WHERE sfa01 = sr.sfb01
   FOREACH  p611_sfa_cs INTO l_sfa03,l_sfa05,l_sfa13,l_sfa25
      IF SQLCA.sqlcode THEN
        CALL cl_err('SQLCA:',SQLCA.sqlcode,1)   
      END IF
      IF l_sfa13 IS NULL THEN
         LET l_sfa13 = 1
      END IF
   END FOREACH
END FUNCTION
#No.TQC-710108   過單用
#No.FUN-9C0072 精簡程式碼
