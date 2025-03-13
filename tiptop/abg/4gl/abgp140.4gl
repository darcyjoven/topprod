# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abgp140.4gl
# Descriptions...: 預計折舊計算作業
# Date & Author..: 02/10/07 By nicola
# Modi...........: ching 031112 No.7370
# Modify.........: No.FUN-4C0007 04/12/03 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.FUN-570113 06/02/27 By yiting 加入背景作業功能
# Modify.........: NO.TQC-630200 06/03/29 BY yiting 
#                                                   1.無法產生舊有固定資產折舊金額
#                                                   2.預計固定資產 / 固定資產 帳務類別設錯
#                                                   3.預計固定資產金額期別分攤錯誤
# Modify.........: No.FUN-660105 06/06/16 By hellen      cl_err --> cl_err3
# Modify.........: No.FUN-680061 06/08/25 By cheunl 欄位型態定義,改為LIKE 
# Modify.........: No.FUN-690106 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.MOD-7B0179 07/11/22 By Smapmin 折舊金額依本幣取位
# Modify.........: No.MOD-870119 08/07/10 By Sarah 將a_mm,l_yy定義成chr2,chr4
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-980061 09/09/02 By Sarah 採定率遞減法時(faj32/faj60)累折/銷帳累折的金額重新予以計算
# Modify.........: No:MOD-9A0068 09/10/09 By mike 1.耐用年限计算时,未考虑同年度计算时,其公式会造成错误m_faj30期数错误,              
#                                                 2.已为最后一期折旧则将剩余净值一并视为该期折旧   
# Modify.........: No:MOD-9A0091 09/10/16 By Sarah 當目前資產尚在折舊中,但下一年度就會變成折舊再提時,本作業算出之折舊金額有誤
# Modify.........: No:MOD-9A0153 09/10/26 By Sarah 續MOD-9A0091,一般提列折舊計算每期折舊時應該要再加入l_depr_amt
# Modify.........: No:CHI-9A0045 09/10/27 By mike bgw11科目抓取时,若是资产类别时.程式中少判断了若faa20=2时,应抓取afai080的fbi02     
# Modify.........: No:TQC-9A0146 09/10/27 By Sarah 續MOD-9A0153,若執行年度與資產目前折舊年度相同,且折舊狀態沒變,需將l_depr_amt歸零
# Modify.........: No:MOD-9A0199 09/11/02 By Sarah FUNCTION p140_g1(),計算bgw09時,應參考afai100先將預留殘值算出,再將(原始金額-預留殘值)/耐用年限
# Modify.........: No:FUN-9B0067 09/11/10 By lilingyu 去掉ATTRIBUTE
# Modify.........: No:FUN-9C0077 09/12/15 By baofei 程序精簡
# Modify.........: No:TQC-A10007 10/01/05 By Sarah 預計折舊金額計算錯誤
# Modify.........: No:MOD-A10009 10/01/05 By Sarah 預留殘值為0但要做折畢再提的資產不可排除
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No:MOD-A90192 10/09/30 By Dido 大陸版折舊計算調整 
# Modify.........: No.FUN-AB0088 11/04/07 By lixiang 固定资料財簽二功能
# Modify.........: No.MOD-BC0022 11/12/02 By Dido 變數應用調整;未用年限為0不須推算 
# Modify.........: No.MOD-C40013 12/04/19 By Elise 1.當月中途為折畢再提狀況
#                                                  2.新的財編未有最近折舊年度期別問題
# Modify.........: No.MOD-C30788 12/04/23 By Polly 調整折畢再提的折舊金額算法
# Modify.........: No.MOD-C70086 12/07/09 By Polly 增加附號條件寫入bgw_file，調整key值重覆

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_faj         RECORD LIKE faj_file.*,
       g_fae         RECORD LIKE fae_file.*,
       g_bgw         RECORD LIKE bgw_file.*,
       g_bgo         RECORD
                      bgo01      LIKE bgo_file.bgo01,
                      bgo02      LIKE bgo_file.bgo02,
                      bgo03      LIKE bgo_file.bgo03,
                      bgo032     LIKE bgo_file.bgo032,
                      bgo033     LIKE bgo_file.bgo033,
                      bgo06      LIKE bgo_file.bgo06,
                      bgo07      LIKE bgo_file.bgo07,
                      bgo10      LIKE bgo_file.bgo10,
                      fab01      LIKE fab_file.fab01,
                      fab04      LIKE fab_file.fab04,
                      fab05      LIKE fab_file.fab05,
                      fab13      LIKE fab_file.fab13
                     END RECORD,
       g_type        LIKE type_file.chr1,     #No.FUN-680061 VARCHAR(01)
       g_type1       LIKE type_file.chr1,     #MOD-9A0091 add
       g_sql         STRING,                  #No.FUN-580092 HCN
       g_wc,g_wc1    STRING,                  #No.FUN-580092 HCN
       g_bgo01       LIKE bgo_file.bgo01,     # 版本
       g_bgo06       LIKE bgo_file.bgo06,     # 年度
       g_change_lang LIKE type_file.chr1,     #No.FUN-570113  #No.FUN-680061 VARCHAR(01)
       ls_date       STRING,                  #No.FUN-570113
       l_flag        LIKE type_file.chr1,     #No.FUN-570113  #No.FUN-680061 VARCHAR(01)
       g_ent         LIKE type_file.num5,     #NO.FUN-680061  SMALLINT
       m_tot,m_aao   LIKE type_file.num20_6,  #NO.FUN-680061  DEC(20,6)
       m_amt,m_amt2  LIKE type_file.num20_6,  #NO.FUN-680061 DEC(20,6)
       m_cost,m_accd LIKE type_file.num20_6,  #NO.FUN-680061 DEC(20,6)
       m_curr        LIKE type_file.num20_6,  #NO.FUN-680061 DEC(20,6)
       m_tot_bgw10   LIKE bgw_file.bgw10,     #NO.FUN-680061 DEC(20,6)
       m_bgw10       LIKE bgw_file.bgw10,     #NO.FUN-680061 DEC(20,6)
       m_ratio       LIKE con_file.con06,     #NO.FUN-680061 DEC(8,5)
       mm_ratio      LIKE con_file.con06,     #NO.FUN-680061 DEC(8,5)
       m_faj24       LIKE faj_file.faj24,
       m_faj30       LIKE faj_file.faj30,
       m_faj203      LIKE faj_file.faj203,
       mm_bgw10      LIKE bgw_file.bgw10,
       m_fad05       LIKE fad_file.fad05,
       m_fae08       LIKE fae_file.fae08,
       mm_fae08      LIKE fae_file.fae08,
       l_first       LIKE type_file.num5,     #No.FUN-680061 SMALLINT
       l_last        LIKE type_file.num5,     #No.FUN-680061 SMALLINT
       l_cnt         LIKE type_file.num5      #No.FUN-680061 SMALLINT
DEFINE g_er1         LIKE type_file.chr1000   #NO.FUN-680061 VARCHAR(300)
DEFINE g_msg         LIKE type_file.chr1000   #No.FUN-680061 VARCHAR(100)
DEFINE g_chr         LIKE type_file.chr1      #No.FUN-680061 VARCHAR(01)
DEFINE g_i           LIKE type_file.num5      #count/index for any purpose  #No.FUN-680061 SMALLINT
DEFINE g_cnt         LIKE type_file.num5      #No.FUN-680061 SMALLINT
DEFINE g_flag        LIKE type_file.chr1      #CHI-980061 add
DEFINE g_bookno1     LIKE aza_file.aza81      #CHI-980061 add
DEFINE g_bookno2     LIKE aza_file.aza82      #CHI-980061 add
DEFINE l_aag04       LIKE aag_file.aag04      #CHI-980061 add
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_bgo01 = ARG_VAL(1)
   LET g_bgo06 = ARG_VAL(2)
   LET g_bgjob = ARG_VAL(3)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = 'N'
   END IF
 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABG")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690106
 

   #取固資參數檔
   SELECT * INTO g_faa.* FROM faa_file WHERE faa00='0'
   IF SQLCA.sqlcode THEN 
   CALL cl_err3("sel","faa_file","","","abg-013","","",1) #FUN-660105 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
   EXIT PROGRAM END IF
   DROP TABLE p140_err_tmp
   CREATE TEMP TABLE p140_err_tmp (
     err01  LIKE type_file.chr1000)
  CREATE UNIQUE INDEX p140_err_tmp_01 ON p140_err_tmp(err01)

   WHILE TRUE
      IF g_bgjob="N" THEN
         CALL p140_i()
         IF cl_sure(0,0) THEN
            CALL cl_wait()
            LET g_success="Y"
            BEGIN WORK
            CALL p140_del()
            CALL p140_g1()
            CALL p140_g2()
            CALL p140_list_err()
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
               CLOSE WINDOW p140_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p140_w
      ELSE
         LET g_success="Y"
         BEGIN WORK
         CALL p140_del()
         CALL p140_g1()
         CALL p140_g2()
         IF g_success="Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
END MAIN
 
FUNCTION p140_i()
  DEFINE   lc_cmd      LIKE type_file.chr1000 #NO.FUN-680061 VARCHAR(500)
  DEFINE   p_row,p_col LIKE type_file.num5    #No.FUN-570113 #No.FUN-680061 SMALLINT
  #No.FUN-570113 --start--
   LET p_row=5
   LET p_col=25
 
   OPEN WINDOW p140_w AT p_row,p_col WITH FORM "abg/42f/abgp140"
   ATTRIBUTE(STYLE=g_win_style)  
 
   CALL cl_ui_init()
 
   CLEAR FORM
   CALL cl_opmsg('a')
  #-MOD-A90192-add-
   IF g_aza.aza26 = '2' THEN                                                   
      CALL cl_err('','afa-397',0)                                              
   END IF                                                                      
  #-MOD-A90192-end-
 
   LET g_bgo06 = YEAR(g_today)
   LET g_bgo06 = YEAR(g_today)
   LET g_bgjob = "N"                            #No.FUN-570113
   WHILE TRUE                                   #No.FUN-570113
      INPUT g_bgo01,g_bgo06,g_bgjob WITHOUT DEFAULTS
        FROM bgo01,bgo06,g_bgjob HELP 1           #No.FUN-570113
 
      AFTER FIELD bgo01
         IF cl_null(g_bgo01) THEN LET g_bgo01 = ' ' END IF
 
        ON ACTION locale                             #No.FUN-570113
           LET g_change_lang = TRUE                  #No.FUN-570113
           EXIT INPUT                                #No.FUN-570113
 
 
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
 
         BEFORE INPUT
             CALL cl_qbe_init()
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()   
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG=0
      CLOSE WINDOW p140_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
   END IF
 

   IF g_bgjob="Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
         WHERE zz01="abgp140"
      IF SQLCA.sqlcode OR cl_null(lc_cmd) THEN
         CALL cl_err('abgp140','9031',1) 
      ELSE
         LET lc_cmd=lc_cmd CLIPPED,
                    " '",g_bgo01 CLIPPED,"'",
                    " '",g_bgo06 CLIPPED,"'",
                    " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('abgp140',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p140_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
    END IF
    EXIT WHILE
  END WHILE
 
END FUNCTION
 
FUNCTION p140_del()
   IF s_shut(0) THEN RETURN END IF
   DELETE FROM bgw_file
         WHERE bgw01=g_bgo01
           AND bgw05=g_bgo06
   IF SQLCA.sqlcode THEN
      CALL cl_err3("del","bgw_file",g_bgo01,g_bgo06,SQLCA.sqlcode,"","BODY DELETE:",0) #FUN-660105  
   END IF
 
END FUNCTION
 
FUNCTION p140_g1()
   DEFINE l_bgw        RECORD LIKE bgw_file.*
   DEFINE l_bgw12      LIKE bgw_file.bgw12
   DEFINE l_fab11      LIKE fab_file.fab11      #TQC-A10007 add
   DEFINE t_rate       LIKE type_file.num26_10  #TQC-A10007 add
   DEFINE t_rate2      LIKE type_file.num26_10  #TQC-A10007 add
 
   CALL s_get_bookno(g_bgo06) RETURNING g_flag,g_bookno1,g_bookno2  #CHI-980061 add
 
   LET g_sql= "SELECT bgo01,bgo02,bgo03,bgo032,bgo033,bgo06,",
              "       bgo07,bgo10,fab01,fab04,fab05,fab13 ",
              "  FROM bgo_file,fab_file ",
              " WHERE bgo03 = fab01 ",
              "   AND fab04 <> 0    ",
              "   AND fab04 <> 5    ",
              "   AND bgo01 ='",g_bgo01,"'",
              "   AND bgo06 =",g_bgo06,
              " ORDER BY bgo01,bgo02,bgo03,bgo032,bgo033,bgo06,bgo07"  #TQC-A10007 add
   PREPARE p140_prebgo FROM g_sql
   DECLARE p140_bgo CURSOR FOR p140_prebgo
   FOREACH p140_bgo INTO g_bgo.*
      IF STATUS THEN
         CALL cl_err('bgo cs:',STATUS,1) LET g_success='N' EXIT FOREACH
      END IF
      FOR l_bgw12 = g_bgo.bgo07 TO 12   
         #檢查未耐用年限 - 預計折舊檔(bgw_file)之已攤提次數
         IF g_bgo.bgo032='1' THEN
            SELECT COUNT(*) INTO g_cnt FROM bgw_file
             WHERE bgw01 = g_bgo01 AND bgw05 = g_bgo06
               AND bgw02 = g_bgo.fab01
               AND bgw08 = '1'
              #AND bgw04 = '1'  #NO.TQC-630200 MARK
               AND bgw04 = '2'
               AND bgw12 = g_bgo.bgo07
               AND bgw07 = g_bgo.bgo033   #TQC-A10007 add
               AND bgw03 = g_bgo.bgo02    #TQC-A10007 add
         ELSE
            SELECT COUNT(*) INTO g_cnt FROM bgw_file
             WHERE bgw01 = g_bgo01
               AND bgw02 = g_bgo.fab01
              #AND bgw04 = '1'  #NO.TQC-630200 MARK
               AND bgw04 = '2'
               AND bgw05 = g_bgo06
               AND bgw08 = '2'
               AND bgw12 = g_bgo.bgo07
               AND bgw07 = g_bgo.bgo033   #TQC-A10007 add
               AND bgw03 = g_bgo.bgo02    #TQC-A10007 add
         END IF
         IF g_bgo.fab05 - g_cnt <= 0 THEN CONTINUE FOREACH END IF
         LET g_bgw.bgw01 = g_bgo01
         LET g_bgw.bgw02 = g_bgo.bgo03
         LET g_bgw.bgw03 = g_bgo.bgo02
         LET g_bgw.bgw04 = '2'
         LET g_bgw.bgw05 = g_bgo06
         LET g_bgw.bgw06 = l_bgw12
         LET g_bgw.bgw08 = g_bgo.bgo032
         IF g_faa.faa20='2' THEN   #依部门                                                                                          
            IF g_bgw.bgw08  = "1" THEN  #单一部门                                                                                   
               LET g_bgw.bgw07 = g_bgo.bgo033                                                                                       
               SELECT fbi02                                                                                                         
                 INTO g_bgw.bgw11                                                                                                   
                 FROM fbi_file                                                                                                      
                WHERE fbi01=g_bgw.bgw07                                                                                             
                  AND fbi03=g_bgw.bgw02                                                                                             
           #str TQC-A10007 add
            ELSE
               LET g_bgw.bgw07 = g_bgo.bgo033
               LET g_bgw.bgw11 = g_bgo.fab13
           #end TQC-A10007 add
            END IF                                                                                                                  
         ELSE                                                                                                                       
            IF g_bgw.bgw08  = "1" THEN  #單一部門
               LET g_bgw.bgw07 = g_bgo.bgo033
               LET g_bgw.bgw11 = g_bgo.fab13
            ELSE
               LET g_bgw.bgw07 = g_bgo.bgo033
               SELECT fad03 INTO g_bgw.bgw11 FROM fad_file
                WHERE fad01 = g_bgo06 AND fad02 = g_bgo.bgo07
                  AND fad04 = g_bgo.bgo033
                  AND fad07 = "1"    #No:FUN-AB0088
               IF STATUS THEN
                  CALL cl_err3("sel","fad_file",g_bgo06,g_bgo.bgo07,STATUS,"","sel fad03:",0) #FUN-660105  
                  CONTINUE FOREACH
               END IF
            END IF
         END IF  #CHI-9A0045     
        #str TQC-A10007 mod
        #IF g_bgo.fab04="1" THEN
        #  #LET g_bgw.bgw09=(g_bgo.bgo10-g_bgo.bgo10*0.1)/g_bgo.fab05                   #MOD-9A0199 mark
        #   LET g_bgw.bgw09=(g_bgo.bgo10-(g_bgo.bgo10/(g_bgo.fab05/12+1)))/g_bgo.fab05  #MOD-9A0199
        #ELSE
        #   LET g_bgw.bgw09=g_bgo.bgo10/g_bgo.fab05
        #END IF
         LET g_bgw.bgw09   = 0
         CASE g_bgo.fab04
           WHEN "1"   #平均有殘值
             LET g_bgw.bgw09=(g_bgo.bgo10-(g_bgo.bgo10/(g_bgo.fab05/12+1)))/g_bgo.fab05
           WHEN "3"  #定率遞減
             LET t_rate = 0
             LET t_rate2= 0
             SELECT power(g_bgo.bgo10*0.1/g_bgo.bgo10,
                          (1/(g_bgo.fab05/12))) INTO t_rate
               FROM faa_file
              WHERE faa00 = '0'
             LET t_rate2 = ((1 - t_rate) / 12) * 100
             LET g_bgw.bgw09=g_bgo.bgo10*t_rate2/100
           OTHERWISE
             LET g_bgw.bgw09=g_bgo.bgo10/g_bgo.fab05
         END CASE
        #end TQC-A10007 mod
         LET g_bgw.bgw10   = 0
         LET g_bgw.bgw12   = g_bgo.bgo07
         LET g_bgw.bgwuser = g_user
         LET g_bgw.bgwgrup = g_grup
         LET g_bgw.bgwmodu = ""
         LET g_bgw.bgwdate = g_today
         IF cl_null(g_bgw.bgw11) THEN
            LET g_er1=g_bgw.bgw04[1,1],' ',
                      g_bgw.bgw02[1,10],' ',
                      g_bgw.bgw03[1,20],' ',
                      g_bgw.bgw08[1,01],' ',
                      g_bgw.bgw07[1,10]
            INSERT INTO p140_err_tmp VALUES (g_er1)
         END IF
         LET g_bgw.bgw09 = cl_digcut(g_bgw.bgw09,g_azi04)   #MOD-7B0179
         LET g_bgw.bgw10 = cl_digcut(g_bgw.bgw10,g_azi04)   #MOD-7B0179
         LET g_bgw.bgworiu = g_user      #No.FUN-980030 10/01/04
         LET g_bgw.bgworig = g_grup      #No.FUN-980030 10/01/04
         INSERT INTO bgw_file VALUES (g_bgw.*)
         IF STATUS THEN
            CALL cl_err3("ins","bgw_file",g_bgw.bgw01,g_bgw.bgw02,STATUS,"","ins bgw:",1) #FUN-660105  
            LET g_success='N' RETURN
         END IF
         #針對多部門分攤折舊金額
         IF g_bgw.bgw08 = '2' THEN
            LET g_sql="SELECT * FROM bgw_file ",
                      " WHERE bgw05 = ",g_bgo06,
                      "   AND bgw06 = ",g_bgw.bgw06,
                      "   AND bgw08 = '2' ",
                      "   AND bgw04 = '2' ",
                      "   AND bgw01 = '",g_bgo01,"'",
                      "   AND bgw02 = '",g_bgw.bgw02,"'" ,
                      "   AND bgw12 = '",g_bgw.bgw12,"'"
            PREPARE p140_pre3 FROM g_sql
            DECLARE p140_cur3 CURSOR WITH HOLD FOR p140_pre3
            FOREACH p140_cur3 INTO g_bgw.*
               IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
              #str TQC-A10007 add
               SELECT fab11 INTO l_fab11 FROM fab_file
                WHERE fab01=g_bgo.bgo03 
                  AND fab04 <> 0 AND fab04 <> 5
              #end TQC-A10007 add
               #-->讀取分攤方式
               SELECT fad05 INTO m_fad05 FROM fad_file
                WHERE fad01=g_bgw.bgw05 AND fad02=g_bgw.bgw06
              #   AND fad03=g_bgw.bgw11 AND fad04=g_bgw.bgw07  #TQC-A10007 mark
                  AND fad03=l_fab11     AND fad04=g_bgo.bgo033 #TQC-A10007
                  AND fad07 = "1"    #No:FUN-AB0088
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","fad_file",g_bgw.bgw05,g_bgw.bgw06,SQLCA.sqlcode,"","sel fad05:",1) #FUN-660105  
                  CONTINUE FOREACH
               END IF
               #-->讀取分母
               IF m_fad05='1' THEN
                  SELECT SUM(fae08) INTO m_fae08 FROM fae_file
                   WHERE fae01=g_bgw.bgw05 AND fae02=g_bgw.bgw06
                 #   AND fae03=g_bgw.bgw11 AND fae04=g_bgw.bgw07  #TQC-A10007 mark
                     AND fae03=l_fab11     AND fae04=g_bgo.bgo033 #TQC-A10007
                  IF SQLCA.sqlcode OR cl_null(m_fae08) THEN
                     CALL cl_err('sel fae',SQLCA.sqlcode,1) 
                     CONTINUE FOREACH
                  END IF
                  LET mm_fae08 = m_fae08            # 分攤比率合計
               END IF
               LET mm_bgw10=g_bgw.bgw09          # 被分攤金額
               LET m_tot=0
               DECLARE p140_cur4 CURSOR WITH HOLD FOR
                  SELECT * FROM fae_file
                   WHERE fae01=g_bgw.bgw05 AND fae02=g_bgw.bgw06
                 #   AND fae03=g_bgw.bgw11 AND fae04=g_bgw.bgw07  #TQC-A10007 mark
                     AND fae03=l_fab11     AND fae04=g_bgo.bgo033 #TQC-A10007
               FOREACH p140_cur4 INTO g_fae.*
                  IF SQLCA.sqlcode OR (cl_null(m_fae08) AND m_fad05='1') THEN
                     CALL cl_err('foreach p140_cur4',SQLCA.sqlcode,0)
                     CONTINUE FOREACH
                  END IF
                  CASE
                    WHEN m_fad05 = '1'
                      SELECT bgw01,bgw02,bgw03,bgw04,bgw05,bgw06,bgw07,bgw08,bgw12
                        INTO g_bgw.bgw01,g_bgw.bgw02,g_bgw.bgw03,g_bgw.bgw04,g_bgw.bgw05,
                             g_bgw.bgw06,g_bgw.bgw07,g_bgw.bgw08,g_bgw.bgw12
                        FROM bgw_file
                       WHERE bgw01=g_bgw.bgw01
                         AND bgw02=g_bgw.bgw02
                         AND bgw03=g_bgw.bgw03
                        #AND bgw04='1'   #NO.TQC-630200 MARK
                         AND bgw04='2'
                         AND bgw05=g_bgw.bgw05
                         AND bgw06=g_bgw.bgw06
                         AND bgw07=g_fae.fae06
                         AND bgw08='3'
                         AND bgw12=g_bgw.bgw12
                      IF STATUS=100 THEN LET g_bgw.bgw01=NULL LET g_bgw.bgw02=NULL LET g_bgw.bgw03=NULL LET g_bgw.bgw04=NULL LET g_bgw.bgw05=NULL LET g_bgw.bgw06=NULL LET g_bgw.bgw07=NULL LET g_bgw.bgw08=NULL LET g_bgw.bgw12=NULL END IF
                      LET mm_ratio= g_fae.fae08/mm_fae08*100    # 分攤比率
                      LET m_ratio = g_fae.fae08/m_fae08*100     # 分攤比率
                      LET m_bgw10 = mm_bgw10*m_ratio/100        # 分攤金額
                      LET m_fae08 = m_fae08 - g_fae.fae08       # 總分攤比率減少
                      LET m_bgw10 = cl_digcut(m_bgw10,2)
                      LET mm_bgw10= mm_bgw10 - m_bgw10          # 被分攤總數減少
                      IF g_bgw.bgw01 IS NOT NULL AND        
                         g_bgw.bgw02 IS NOT NULL AND        
                         g_bgw.bgw03 IS NOT NULL AND        
                         g_bgw.bgw04 IS NOT NULL AND        
                         g_bgw.bgw05 IS NOT NULL AND        
                         g_bgw.bgw06 IS NOT NULL AND        
                         g_bgw.bgw07 IS NOT NULL AND        
                         g_bgw.bgw08 IS NOT NULL AND        
                         g_bgw.bgw12 IS NOT NULL THEN       
                         UPDATE bgw_file SET (bgw10)=(m_bgw10)     
                          WHERE bgw01 = g_bgw.bgw01 AND            
                                bgw02 = g_bgw.bgw02 AND            
                                bgw03 = g_bgw.bgw03 AND            
                                bgw04 = g_bgw.bgw04 AND            
                                bgw05 = g_bgw.bgw05 AND            
                                bgw06 = g_bgw.bgw06 AND            
                                bgw07 = g_bgw.bgw07 AND            
                                bgw08 = g_bgw.bgw08 AND            
                                bgw12 = g_bgw.bgw12    
                         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                            LET g_success='N' 
                            CALL cl_err3("upd","bgw_file",g_bgw.bgw01,g_bgw.bgw02,STATUS,"","upd bgw:",1) #FUN-660105  
                            EXIT FOREACH
                         END IF
                      ELSE
                         LET l_bgw.bgw01 = g_bgo01
                         LET l_bgw.bgw02 = g_bgw.bgw02
                         LET l_bgw.bgw03 = g_bgw.bgw03
                         LET l_bgw.bgw04 = '2'
                         LET l_bgw.bgw05 = g_bgw.bgw05
                         LET l_bgw.bgw06 = g_bgw.bgw06
                         LET l_bgw.bgw07 = g_fae.fae06
                         LET l_bgw.bgw08 = '3'
                         LET l_bgw.bgw09 = 0
                         LET l_bgw.bgw10 = m_bgw10
                         LET l_bgw.bgw11 = g_fae.fae07
                         LET l_bgw.bgw12 = g_bgw.bgw12
                         LET l_bgw.bgwuser = g_user
                         LET l_bgw.bgwgrup = g_grup
                         LET l_bgw.bgwmodu = ''
                         LET l_bgw.bgwdate = g_today
                         IF cl_null(g_bgw.bgw11) THEN
                            LET g_er1=g_bgw.bgw04[1,1],' ',
                                      g_bgw.bgw02[1,10],' ',
                                      g_bgw.bgw03[1,20],' ',
                                      g_bgw.bgw08[1,01],' ',
                                      g_bgw.bgw07[1,10]
                            INSERT INTO p140_err_tmp VALUES (g_er1)
                         END IF
                         LET l_bgw.bgw09 = cl_digcut(l_bgw.bgw09,g_azi04)   #MOD-7B0179
                         LET l_bgw.bgw10 = cl_digcut(l_bgw.bgw10,g_azi04)   #MOD-7B0179
                         LET l_bgw.bgworiu = g_user      #No.FUN-980030 10/01/04
                         LET l_bgw.bgworig = g_grup      #No.FUN-980030 10/01/04
                         INSERT INTO bgw_file VALUES(l_bgw.*)
                         IF STATUS THEN
                            LET g_success='N' 
                            CALL cl_err3("ins","bgw_file",l_bgw.bgw01,l_bgw.bgw02,STATUS,"","ins4 bgw:",1) #FUN-660105  
                            EXIT FOREACH
                         END IF
                      END IF
                    WHEN m_fad05 = '2'
                      LET l_aag04 = ''
                      SELECT aag04 INTO l_aag04 FROM aag_file
                       WHERE aag01=g_fae.fae09 AND aag00=g_bookno1
                      IF l_aag04='1' THEN
                         SELECT SUM(aao05-aao06) INTO m_aao FROM aao_file
                          WHERE aao00 = g_faa.faa02b AND aao01 = g_fae.fae09
                            AND aao02 = g_fae.fae06  AND aao03 = g_bgo06
                            AND aao04<= g_bgw.bgw06
                      ELSE
                         SELECT aao05-aao06 INTO m_aao FROM aao_file
                          WHERE aao00 = g_faa.faa02b AND aao01 = g_fae.fae09
                            AND aao02 = g_fae.fae06  AND aao03 = g_bgo06
                            AND aao04 = g_bgw.bgw06
                      END IF   #CHI-980061 add
                      IF STATUS=100 OR m_aao IS NULL THEN LET m_aao=0 END IF  #CHI-980061 add
                      LET m_tot = m_tot + m_aao
                 END CASE
               END FOREACH
               #----- 若為變動比率, 重新 foreach 一次 insert into bgw_file -----------
               IF m_fad05='2' THEN
                  FOREACH p140_cur4 INTO g_fae.*
                     LET l_aag04 = ''
                     SELECT aag04 INTO l_aag04 FROM aag_file
                      WHERE aag01=g_fae.fae09 AND aag00=g_bookno1
                     IF l_aag04='1' THEN
                        SELECT SUM(aao05-aao06) INTO m_aao FROM aao_file
                         WHERE aao00 = g_faa.faa02b AND aao01 = g_fae.fae09
                           AND aao02 = g_fae.fae06  AND aao03 = g_bgo06
                           AND aao04<= g_bgw.bgw06
                     ELSE
                        SELECT aao05-aao06 INTO m_aao FROM aao_file
                         WHERE aao00 = g_faa.faa02b AND aao01 = g_fae.fae09
                           AND aao02 = g_fae.fae06  AND aao03 = g_bgo06
                           AND aao04 = g_bgw.bgw06
                     END IF   #CHI-980061 add
                     IF STATUS=100 OR m_aao IS NULL THEN LET m_aao=0 END IF
                     LET m_ratio = m_aao / m_tot*100
                     LET m_bgw10 = g_bgw.bgw10 * m_ratio / 100
                     LET m_tot_bgw10 = m_tot_bgw10+m_bgw10
                     SELECT COUNT(*) INTO l_cnt FROM bgw_file
                      WHERE bgw01=g_bgo01
                        AND bgw02=g_bgw.bgw02
                        AND bgw03=g_bgw.bgw03
                       #AND bgw04='1'
                        AND bgw04='2'   #NO.TQC-630200 MARK
                        AND bgw05=g_bgw.bgw05
                        AND bgw06=g_bgw.bgw06
                        AND bgw07=g_fae.fae06
                        AND bgw08='3'
                        AND bgw12=g_bgw.bgw12
                     IF l_cnt>0 THEN
                        UPDATE bgw_file SET (bgw10)=(m_bgw10)
                         WHERE bgw01=g_bgo01
                           AND bgw02=g_bgw.bgw02
                           AND bgw03=g_bgw.bgw03
                          #AND bgw04='1'
                           AND bgw04='2'    #NO.TQC-630200 MARK
                           AND bgw05=g_bgw.bgw05
                           AND bgw06=g_bgw.bgw06
                           AND bgw07=g_fae.fae06
                           AND bgw08='3'
                           AND bgw12=g_bgw.bgw12
                        IF STATUS THEN
                           LET g_success='N' 
                           CALL cl_err3("upd","bgw_file",g_bgo01,g_bgw.bgw02,STATUS,"","upd bgw",1) #FUN-660105  
                           EXIT FOREACH
                        END IF
                     ELSE
                        LET l_bgw.bgw01 = g_bgo01
                        LET l_bgw.bgw02 = g_bgw.bgw02
                        LET l_bgw.bgw03 = g_bgw.bgw03
                        LET l_bgw.bgw04 = '2'
                        LET l_bgw.bgw05 = g_bgw.bgw05
                        LET l_bgw.bgw06 = g_bgw.bgw06
                        LET l_bgw.bgw07 = g_fae.fae06
                        LET l_bgw.bgw08 = '3'
                        LET l_bgw.bgw09 = 0
                        LET l_bgw.bgw10 = m_bgw10
                        LET l_bgw.bgw11 = g_fae.fae07
                        LET l_bgw.bgw12 = g_bgw.bgw12
                        LET l_bgw.bgwuser = g_user
                        LET l_bgw.bgwgrup = g_grup
                        LET l_bgw.bgwmodu = ''
                        LET l_bgw.bgwdate = g_today
                        IF cl_null(g_bgw.bgw11) THEN
                           LET g_er1=g_bgw.bgw04[1,1],' ',
                                     g_bgw.bgw02[1,10],' ',
                                     g_bgw.bgw03[1,20],' ',
                                     g_bgw.bgw08[1,01],' ',
                                     g_bgw.bgw07[1,10]
                           INSERT INTO p140_err_tmp VALUES (g_er1)
                        END IF
                        LET l_bgw.bgw09 = cl_digcut(l_bgw.bgw09,g_azi04)   #MOD-7B0179
                        LET l_bgw.bgw10 = cl_digcut(l_bgw.bgw10,g_azi04)   #MOD-7B0179
                        INSERT INTO bgw_file VALUES(l_bgw.*)
                        IF STATUS THEN
                           LET g_success='N' 
                           CALL cl_err3("ins","bgw_file",l_bgw.bgw01,l_bgw.bgw02,STATUS,"","ins5 bgw",1) #FUN-660105  
                           EXIT FOREACH
                        END IF
                     END IF
                  END FOREACH
               END IF
            END FOREACH
         END IF
      END FOR
   END FOREACH
 
END FUNCTION
 
FUNCTION p140_g2()
DEFINE l_bgw RECORD LIKE bgw_file.*
DEFINE a_mm         LIKE type_file.chr2      # Prog. Version..: '5.30.06-13.03.12(02)   #MOD-870119 mod bgw_file.bgw06->type_file.chr2 
DEFINE l_yy         LIKE type_file.chr4      # Prog. Version..: '5.30.06-13.03.12(04)   #MOD-870119 mod bgo_file.bgo06->type_file.chr4
DEFINE l_fbi02      LIKE fbi_file.fbi02
DEFINE l_rate       LIKE ima_file.ima18      #攤提比率
DEFINE t_rate       LIKE type_file.num26_10  #CHI-980061 mod #LIKE csd_file.csd04    #NO.FUN-680061 DEC(7,3)
DEFINE t_rate2      LIKE type_file.num26_10  #CHI-980061 mod #LIKE tpo_file.tpo16    #NO.FUN-680061 DEC(7,4)
DEFINE l_mm         LIKE bgw_file.bgw06      #No.FUN-680061 SMALLINT
DEFINE l_ym         LIKE faj_file.faj27      #NO.FUN-680061 VARCHAR(6)
DEFINE l_depr_mm    LIKE type_file.num5      #TQC-A10007 add
DEFINE l_depr_mm1   LIKE type_file.num5      #TQC-A10007 add
DEFINE l_depr_amt1  LIKE type_file.num10     #TQC-A10007 add
DEFINE l_depr_amt0  LIKE type_file.num10     #TQC-A10007 add
DEFINE l_depr_amt01 LIKE type_file.num10     #TQC-A10007 add
DEFINE l_depr_amt02 LIKE type_file.num10     #TQC-A10007 add
DEFINE l_depr_amt   LIKE type_file.num10     #CHI-980061 add
DEFINE l_year1      LIKE type_file.chr4      #CHI-980061 add 
DEFINE l_year_new   LIKE type_file.chr4      #CHI-980061 add 
DEFINE l_year2      LIKE type_file.chr4      #CHI-980061 add 
DEFINE l_month1     LIKE type_file.chr2      #CHI-980061 add
DEFINE l_month2     LIKE type_file.chr2      #CHI-980061 add
DEFINE l_date       STRING                   #CHI-980061 add
DEFINE l_date2      DATE                     #CHI-980061 add  
DEFINE l_date_old   DATE                     #CHI-980061 add       
DEFINE l_date_new   DATE                     #CHI-980061 add       
DEFINE l_date_today DATE                     #CHI-980061 add
DEFINE l_rate_y     LIKE type_file.num20_6   #CHI-980061 add
DEFINE l_amt_y      LIKE faj_file.faj31      #CHI-980061 add
DEFINE l_fgj05      LIKE fgj_file.fgj05      #MOD-A90192
DEFINE l_m          LIKE type_file.num10     #MOD-C30788 add
 
   FOR l_mm = 1 TO 12   
      LET l_yy = g_bgo06 using '&&&&'
      LET a_mm = l_mm using '&&'
      LET l_ym = l_yy,a_mm
 
   CALL s_get_bookno(l_yy) RETURNING g_flag,g_bookno1,g_bookno2  #CHI-980061 add
   #------------------ 資產主檔 SQL ----------------------------------
   # 判斷 資產狀態, 折舊方法, 剩餘月數, 確認碼, 開始折舊年月
   LET g_sql="SELECT '1',faj_file.* FROM faj_file ",
            #" WHERE faj43 NOT IN ('0','5','6','7','C','X') ",   #MOD-A90192 mark
             " WHERE faj43 NOT IN ('0','4','5','6','7','X') ",   #MOD-A90192
            #" AND faj28 IN ('1','2','3') ",                     #MOD-A90192 mark
             " AND faj27 <= '",l_ym,"'",    #NO.TQC-630200
             " AND faj33+faj331-(faj101-faj102) > 0 ",           #MOD-A90192                
             " AND fajconf='Y' "
  #-MOD-A90192-add-
   IF g_aza.aza26 = '2' THEN                                                   
      LET g_sql = g_sql CLIPPED," AND faj28 IN ('1','2','3','4')"                 
   ELSE                                                                        
      LET g_sql = g_sql CLIPPED," AND faj28 IN ('1','2','3')"                  
   END IF                                                                      
   #已停用資產是否提列折舊                                                       
   IF g_faa.faa30 = 'N' THEN                                                   
      LET g_sql = g_sql CLIPPED," AND (faj105 = 'N' OR faj105 IS NULL)"        
   END IF                                                                      
   LET g_sql = g_sql CLIPPED," UNION ALL ", 
  #-MOD-A90192-end-
            #" UNION ALL ",                                   #MOD-A90192 mark
             "SELECT '2',faj_file.* FROM faj_file ",   #折畢再提/續提
            #" WHERE faj43 IN ('7','C') ",                    #MOD-A90192 mark
             " WHERE faj43 IN ('7') ",                        #MOD-A90192
            #" AND faj28 = '1' ",            #CHI-980061 mark
            #" AND faj28 IN ('1','2','3') ",  #CHI-980061     #MOD-A90192 mark
             " AND faj33-(faj101-faj102) > 0 ",               #MOD-A90192                          
             " AND fajconf='Y' "
  #-MOD-A90192-add-
   IF g_aza.aza26 = '2' THEN                                                   
      LET g_sql = g_sql CLIPPED," AND faj28 IN ('1','2','3','4')"                 
   ELSE                                                                        
      LET g_sql = g_sql CLIPPED," AND faj28 IN ('1','2','3')"                  
   END IF                                                                      
   #已停用資產是否提列折舊                                                       
   IF g_faa.faa30 = 'N' THEN                                                   
      LET g_sql = g_sql CLIPPED," AND (faj105 = 'N' OR faj105 IS NULL)"        
   END IF                                                                      
  #LET g_sql = g_sql CLIPPED," ORDER BY faj02,faj021 "        #MOD-C30788 mark
   LET g_sql = g_sql CLIPPED," ORDER BY 3,4,5 "               #MOD-C30788 add
  #-MOD-A90192-end-
            #" ORDER BY faj02,faj021 "     #NO.TQC-630200 MARK
            #" ORDER BY faj02,faj021 "      #MOD-A90192 mark
 
   PREPARE p140_pfaj FROM g_sql
   DECLARE p140_faj CURSOR WITH HOLD FOR p140_pfaj

      FOREACH p140_faj INTO g_type,g_faj.*
         IF SQLCA.sqlcode THEN
            CALL cl_err('p140_faj foreach:',STATUS,1) EXIT FOREACH
         END IF
         MESSAGE g_faj.faj02,' ',g_faj.faj022
        #str MOD-A10009 mod
        #IF g_faj.faj31=0 THEN CONTINUE FOREACH END IF   #TQC-A10007 add
         IF NOT (g_faj.faj33+g_faj.faj31<=g_faj.faj31 OR g_faj.faj43='7')
           #AND g_faj.faj31=0 THEN   #MOD-BC0022 mark 
            AND g_faj.faj30=0 THEN   #MOD-BC0022
            CONTINUE FOREACH
         END IF
        #end MOD-A10009 mod
         IF cl_null(g_faj.faj201) THEN LET g_faj.faj201 = 0 END IF
         IF g_faj.faj33<g_faj.faj31 THEN LET g_type='2' END IF   #TQC-A10007 add
         LET l_depr_amt = 0
         LET g_type1=g_type   #記錄目前狀態
        #MOD-C40013---str---
        #新的財編未有最近折舊年度期別
         IF (cl_null(g_faj.faj57) OR g_faj.faj57=' ') AND (cl_null(g_faj.faj571) OR g_faj.faj571=' ') THEN
            LET g_faj.faj57 = g_faj.faj27[1,4]
            LET g_faj.faj571 = g_faj.faj27[5,6]
         END IF
        #MOD-C40013---end---
         #目前資產狀態為折舊中,資產設定要折畢再提,且下一個年度應該是用折畢再提
         IF g_type='1' THEN   #一般折舊
            IF g_bgo06 > g_faj.faj57 THEN          #輸入年度>最近折舊年度
               #今年一般折舊就會提完,下一年度會變成折畢再提
               IF g_faj.faj30+g_faj.faj571<12 THEN
                  LET g_type='2'
               END IF
            ELSE
               IF g_bgo06=g_faj.faj57 THEN   #輸入年度=最近折舊年度
                  #今年的後面某幾個月份應該是用折畢再提的方式算折舊
                  IF g_faj.faj30+g_faj.faj571<12 THEN
                     IF l_mm<=g_faj.faj30+g_faj.faj571 THEN
                        LET g_type='1'   #一般折舊
                     ELSE
                        LET g_type='2'   #折畢提列
                     END IF
                  END IF
               END IF
            END IF
         END IF
         #計算後面幾個月份的折舊(實際未提折舊的部分)
         LET l_depr_amt = 0
         LET l_depr_mm  = 0   #TQC-A10007 add
         LET g_sql = "SELECT SUM(bgw09) ",
                     "  FROM bgw_file ",
                     " WHERE bgw01 = '",g_bgo01,"'",
                     "   AND bgw02 = '",g_faj.faj02,"'",
                     "   AND bgw03 = '",g_faj.faj022,"'",
                     "   AND bgw04 = '1'",
                    #"   AND bgw07 = '",g_faj.faj24,"'",  #TQC-A10007 mark
                     "   AND bgw08 = '",g_faj.faj23,"'",
                     "   AND bgw12 = 1"
         IF g_bgo06=g_faj.faj57 THEN   #輸入年度=最近折舊年度
            LET g_sql = g_sql CLIPPED,
                        "   AND bgw05 = ",g_bgo06,
                        "   AND bgw06 BETWEEN ",g_faj.faj571+1," AND ",l_mm-1
            LET l_depr_mm=(l_mm-1)-(g_faj.faj571+1)+1  #TQC-A10007 add
         ELSE
            LET g_sql = g_sql CLIPPED,
                        "   AND bgw05 < ",g_bgo06,
                        "   AND bgw06 BETWEEN ",g_faj.faj571+1," AND 12"
            LET l_depr_mm=((g_bgo06-g_faj.faj57)*12)-(g_faj.faj571+1)+1   #TQC-A10007 add
         END IF
        #-MOD-BC0022-add-
         IF g_faj.faj28 <> '3' THEN
            LET l_depr_mm = 0 
         END IF
        #-MOD-BC0022-end-
        #str TQC-A10007 add
         IF g_faj.faj23 = '1' THEN
            LET g_sql = g_sql CLIPPED," AND bgw07='",g_faj.faj24,"'"   # 單一部門 -> 折舊部門
         ELSE
            LET g_sql = g_sql CLIPPED," AND bgw07='",g_faj.faj20,"'"   # 多部門分攤 -> 保管部門
         END IF
        #end TQC-A10007 add
         PREPARE p140_amt_p2 FROM g_sql
         DECLARE p140_amt_c2 CURSOR WITH HOLD FOR p140_amt_p2
         OPEN p140_amt_c2 
         FETCH p140_amt_c2 INTO l_depr_amt
         IF cl_null(l_depr_amt) THEN LET l_depr_amt=0 END IF
        #str TQC-A10007 add
         IF l_depr_amt=0 THEN LET l_depr_mm=0 END IF
         IF g_type!=g_type1 THEN
            LET l_depr_amt1 = 0
            LET l_depr_mm1 = 0 
            IF g_bgo06 > g_faj.faj57 + 1   THEN              #MOD-C30788 add
               LET g_sql = "SELECT SUM(bgw09) ",
                           "  FROM bgw_file ",
                           " WHERE bgw01 = '",g_bgo01,"'",
                           "   AND bgw02 = '",g_faj.faj02,"'",  
                           "   AND bgw03 = '",g_faj.faj022,"'",
                           "   AND bgw04 = '1'",
                           "   AND bgw07 = '",g_faj.faj24,"'",
                           "   AND bgw08 = '",g_faj.faj23,"'",
                           "   AND bgw12 = 1",
                          #-----------MOD-C30788------------------------------------- (S)
                          #"   AND bgw05 = ",g_bgo06,
                          #"   AND bgw06 BETWEEN 1 AND ",l_mm-1
                           "   AND bgw05 BETWEEN ",g_faj.faj57+1," AND ",g_bgo06-1,
                           "   AND bgw06 BETWEEN 1 AND ",g_faj.faj571
                          #-----------MOD-C30788------------------------------------- (S)
               LET l_depr_mm1=l_mm-1 
               PREPARE p140_amt_p3 FROM g_sql
               DECLARE p140_amt_c3 CURSOR WITH HOLD FOR p140_amt_p3
               OPEN p140_amt_c3 
               FETCH p140_amt_c3 INTO l_depr_amt1
               IF cl_null(l_depr_amt1) THEN LET l_depr_amt1=0 END IF
               IF l_depr_amt1=0 THEN LET l_depr_mm1=0 END IF
            END IF                                             #MOD-C30788 add
           #MOD-C40013---str--- 
            IF g_bgo06 = g_faj.faj57 + 1 THEN
               LET g_sql = "SELECT SUM(bgw09) ",
                           "  FROM bgw_file ",
                           " WHERE bgw01 = '",g_bgo01,"'",
                           "   AND bgw02 = '",g_faj.faj02,"'",
                           "   AND bgw03 = '",g_faj.faj022,"'",
                           "   AND bgw04 = '1'",
                           "   AND bgw07 = '",g_faj.faj24,"'",
                           "   AND bgw08 = '",g_faj.faj23,"'",
                           "   AND bgw12 = 1",
                           "   AND bgw05 = ",g_faj.faj57+1,
                           "   AND bgw06 BETWEEN 1 AND ",g_faj.faj571
               LET l_depr_mm1=l_mm-1
               IF g_faj.faj28 <> '3' THEN
                  LET l_depr_mm1 = 0
               END IF 
               PREPARE p140_amt_p4 FROM g_sql
               DECLARE p140_amt_c4 CURSOR WITH HOLD FOR p140_amt_p4
               OPEN p140_amt_c4
               FETCH p140_amt_c4 INTO l_depr_amt1
               IF cl_null(l_depr_amt1) THEN LET l_depr_amt1=0 END IF
               IF l_depr_amt1=0 THEN LET l_depr_mm1=0 END IF
            END IF
           #MOD-C40013---end---
            LET l_depr_amt = l_depr_amt + l_depr_amt1 
         END IF
        #end TQC-A10007 add
         #---檢查未耐用年限-----------------------------------------------
         IF g_type=g_type1 THEN
            LET m_faj30=g_faj.faj30-(((g_bgo06-g_faj.faj57)*12)-g_faj.faj571) 
         ELSE
           #LET m_faj30=g_faj.faj36+g_faj.faj30-(((g_bgo06-g_faj.faj57)*12)-g_faj.faj571)              #TQC-A10007 mark 
            LET m_faj30=g_faj.faj36+g_faj.faj30-(((g_bgo06-g_faj.faj57)*12)-g_faj.faj571)-l_depr_mm1   #TQC-A10007
         END IF
         IF m_faj30-l_mm < 0 THEN
            LET m_faj30=0 CONTINUE FOREACH
         END IF
         #-------已為最後一期折舊則將剩餘淨值一併視為該期折舊
                                                                                 
            IF m_faj30-l_mm < 0 THEN   #MOD-9A0068   
               LET m_amt = 0
            ELSE
               IF g_bgo06=g_faj.faj57 THEN   #输入年度=最近折旧年度     
                  IF g_type=g_type1 THEN
                     LET m_faj30=g_faj.faj30
                     LET l_depr_amt=0   #TQC-9A0146 add
                  ELSE
                    #LET m_faj30=g_faj.faj36                                                 #MOD-C30788 mark
                     LET m_faj30 = g_faj.faj36 - (l_mm - g_faj.faj571 - g_faj.faj30 - 1)     #MOD-C30788 add
                  END IF
                  LET m_faj30 = m_faj30-l_depr_mm   #TQC-A10007 add
              #MOD-C40013---str---
               ELSE
                  IF g_bgo06 > g_faj.faj57 AND g_type != g_type1 THEN
                     LET m_faj30 = g_faj.faj36
                  END IF
                  IF g_bgo06 > g_faj.faj57 + 1 AND g_type != g_type1 THEN
                     LET m_faj30 = g_faj.faj36+g_faj.faj30-(((g_bgo06-g_faj.faj57)*12)-g_faj.faj571)
                  END IF
              #MOD-C40013---end---
               END IF                                                                                                               
               CASE g_faj.faj28
                  WHEN '1'    #有殘值
                     IF g_type = '1' THEN   #一般提列
                        LET m_amt=(g_faj.faj14+g_faj.faj141-g_faj.faj59-
                                  (g_faj.faj32+l_depr_amt-g_faj.faj60)-g_faj.faj31)/   #MOD-9A0153 mod
                                   m_faj30
                     ELSE                   #折畢提列
                        LET m_amt=(g_faj.faj14+g_faj.faj141-g_faj.faj59-
                                  (g_faj.faj32+l_depr_amt-g_faj.faj60)-g_faj.faj35)/   #MOD-9A0091 mod
                                   m_faj30
                     END IF
                  WHEN '2'    #無殘值
                     IF g_aza.aza26 = '2' THEN      #雙倍餘額遞減法             
                        IF m_faj30 > 24 THEN                                    
                           IF g_faj.faj108 = 0 OR (g_faj.faj30 MOD 12 = 0) THEN   #TQC-690087                        
                              LET l_rate_y = (2/(g_faj.faj29/12))               
                              LET l_amt_y = (g_faj.faj14+g_faj.faj141-          
                                             g_faj.faj59-                       
                                            (g_faj.faj32+l_depr_amt-g_faj.faj60))*l_rate_y   #MOD-9A0153 mod
                              LET m_amt = l_amt_y / 12                          
                           ELSE                                                 
                              LET m_amt = g_faj.faj108 / 12                     
                           END IF                                               
                        ELSE                                                    
                           IF m_faj30 = 24 THEN                                 
                              LET l_amt_y = (g_faj.faj14+g_faj.faj141-          
                                             g_faj.faj59-                      
                                            (g_faj.faj32+l_depr_amt-g_faj.faj60)-   #MOD-9A0091 mod       
                                             g_faj.faj31) / 2                   
                              LET m_amt = l_amt_y / 12                          
                           ELSE                                                 
                              LET m_amt = g_faj.faj108 / 12                     
                           END IF                                               
                        END IF          
                     ELSE
                        LET m_amt=(g_faj.faj14+g_faj.faj141-g_faj.faj59-
                                  (g_faj.faj32+l_depr_amt-g_faj.faj60))/m_faj30   #MOD-9A0153 mod
                     END IF   #CHI-980061 add
                  WHEN '3'    #定率餘額遞減法
                     IF g_aza.aza26 = '2' THEN    #年數總合法                   
                        IF g_faj.faj108 = 0 OR (g_faj.faj30 MOD 12 = 0) THEN                         
                           LET l_rate_y = (m_faj30/12)/((g_faj.faj29/12)*       
                                          ((g_faj.faj29/12)+1)/2)               
                           LET l_amt_y = (g_faj.faj14+g_faj.faj141-g_faj.faj31) 
                                          * l_rate_y                            
                           LET m_amt = l_amt_y / 12                             
                        ELSE                                                    
                           LET m_amt = g_faj.faj108 / 12                        
                        END IF                                                  
                     ELSE           
                        #--計算前期日期範圍-----------
                        LET l_date = g_faj.faj27
                        LET l_year1 = l_date.substring(1,4)   #前期累折開始年度
                        LET l_month1 = l_date.substring(5,6)  #前期累折開始月份  
                        LET l_date_old = MDY(l_month1,01,l_year1)
                        LET l_date_new = MDY(l_month1,01,l_year1+1)
                        LET l_date_new = MDY(l_month1,01,l_year1+1)
                        LET l_date_today = MDY(a_mm,01,l_yy)
                        IF l_date_new <= l_date_today THEN
                            LET l_date_new = l_date_old
                            WHILE TRUE
                            IF l_date_new > l_date_today THEN  
                                LET l_date2 = l_date_old
                                EXIT WHILE
                            END IF
                            LET l_date_old = l_date_new
                            LET l_year_new = YEAR(l_date_new)+1
                            LET l_date_new = MDY(l_month1,01,l_year_new)
                            END WHILE
                       
                            LET l_year2 = YEAR(l_date2) 
                            LET l_month2 = MONTH(l_date2) USING '&&'
                           #str TQC-A10007 mark
                           ##抓取小於此次輸入年度的折舊金額加總SUM(bgw09),
                           ##就是該筆資產的前期累折金額
                           #LET l_depr_amt = 0
                           #LET g_sql = "SELECT SUM(bgw09) ",
                           #            "  FROM bgw_file ",
                           #            " WHERE bgw01 = '",g_bgo01,"'",
                           #            "   AND bgw02 = '",g_faj.faj02,"'",
                           #            "   AND bgw03 = '",g_faj.faj022,"'",
                           #            "   AND bgw04 = '1'",
                           #            "   AND bgw05>= ",l_year1,
                           #            "   AND bgw05 < ",l_year2,
                           #            "   AND bgw07 = '",g_faj.faj24,"'",
                           #            "   AND bgw08 = '",g_faj.faj23,"'",
                           #            "   AND bgw12 = 1"
                           #PREPARE p140_amt_p FROM g_sql
                           #DECLARE p140_amt_c CURSOR WITH HOLD FOR p140_amt_p
                           #OPEN p140_amt_c 
                           #FETCH p140_amt_c INTO l_depr_amt      #前期累折
                           #IF cl_null(l_depr_amt) THEN LET l_depr_amt=0 END IF
                           #end TQC-A10007 mark
                           #str TQC-A10007 mod
#假設資產的定率遞減計算範圍是10月~次年9月
#若要計算2010年預計折舊,
#則前期累折計算範圍需算到為2009年/9月
#例1.目前資產實際提列折舊至2008年/5月 
#    1.資產主檔(~2008/5)的累計折舊faj32=l_depr_amt0
#    2.預計折舊檔(2008/5~2009/9)的預計折舊加總SUM(bgw09)=l_depr_amt01
#    則前期累折金額=l_depr_amt0+l_depr_amt01
#   實際折舊    前期折舊計算截止月
#──────┼────────────────┼────────────
#    2008/5          2009/9
#
#例2.目前資產實際提列折舊至2009年/12月 
#    1.資產主檔(~2009/12)的累計折舊faj32=l_depr_amt0
#    3.折舊檔(>=2009/10~2009/12)的折舊加總SUM(fan07)=l_depr_amt
#    則前期累折=l_depr_amt0-l_depr_amt
#    4.若系統是半途開帳,3.抓不到折舊金額,則改抓預計折舊檔SUM(bgw09)=l_depr_amt02
#    則前期累折=l_depr_amt0-l_depr_amt02
#               前期折舊計算截止月  實際折舊
#──────────────────────┼────────────────┼────
#                    2009/9          2009/12
                            LET l_depr_amt  = 0
                            LET l_depr_amt0 = 0
                            LET l_depr_amt01= 0
                            LET l_depr_amt02= 0
                            LET g_sql = "SELECT faj32 FROM faj_file",
                                        " WHERE faj02 = '",g_faj.faj02,"'",
                                        "   AND faj022= '",g_faj.faj022,"'"
                            PREPARE p140_amt_p0 FROM g_sql
                            DECLARE p140_amt_c0 CURSOR WITH HOLD FOR p140_amt_p0
                            OPEN p140_amt_c0 
                            FETCH p140_amt_c0 INTO l_depr_amt0
                            IF cl_null(l_depr_amt0) THEN LET l_depr_amt0=0 END IF

                            #實際提列折舊最近年月<前期累折計算截止年月
                            IF g_faj.faj57<l_year2 OR
                              (g_faj.faj57=l_year2 AND g_faj.faj571<l_month2) THEN
                               LET g_sql = "SELECT SUM(bgw09) ",
                                           "  FROM bgw_file ",
                                           " WHERE bgw01 = '",g_bgo01,"'",
                                           "   AND bgw02 = '",g_faj.faj02,"'",
                                           "   AND bgw03 = '",g_faj.faj022,"'",
                                           "   AND bgw04 = '1'",
                                           "   AND bgw05*12+bgw06> ",g_faj.faj57*12+g_faj.faj571, 
                                           "   AND bgw05*12+bgw06< ",l_year2*12+l_month2,
                                           "   AND bgw07 = '",g_faj.faj24,"'",
                                           "   AND bgw08 = '",g_faj.faj23,"'",
                                           "   AND bgw12 = 1"
                               PREPARE p140_amt_p01 FROM g_sql
                               DECLARE p140_amt_c01 CURSOR WITH HOLD FOR p140_amt_p01
                               OPEN p140_amt_c01 
                               FETCH p140_amt_c01 INTO l_depr_amt01
                               IF cl_null(l_depr_amt01) THEN LET l_depr_amt01=0 END IF
                               LET l_depr_amt = l_depr_amt0+l_depr_amt01
                            ELSE
                               LET l_cnt = 0
                               SELECT COUNT(*) INTO l_cnt FROM fan_file
                                WHERE fan01 = g_faj.faj02
                                  AND fan02 = g_faj.faj022
                                  AND fan03 = l_year2
                                  AND fan04 = l_month2
                                  AND fan041= '1'
                               IF cl_null(l_cnt) THEN LET l_cnt=0 END IF
                               IF l_cnt > 0 THEN   #實際折舊檔抓的到折舊金額
                                  LET g_sql = "SELECT SUM(fan07) ",
                                              "  FROM fan_file ",
                                              " WHERE fan01 = '",g_faj.faj02,"'",
                                              "   AND fan02 = '",g_faj.faj022,"'",
                                              "   AND fan03*12+fan04> ",l_year2*12+l_month2,
                                              "   AND fan03*12+fan04< ",g_faj.faj57*12+g_faj.faj571, 
                                              "   AND fan041 = '1'"
                                  PREPARE p140_amt_p1 FROM g_sql
                                  DECLARE p140_amt_c1 CURSOR WITH HOLD FOR p140_amt_p1
                                  OPEN p140_amt_c1 
                                  FETCH p140_amt_c1 INTO l_depr_amt      #前期累折   
                                  IF cl_null(l_depr_amt) THEN LET l_depr_amt=0 END IF
                                  LET l_depr_amt = l_depr_amt0-l_depr_amt
                               ELSE
                                  LET g_sql = "SELECT SUM(bgw09) ",
                                              "  FROM bgw_file ",
                                              " WHERE bgw01 = '",g_bgo01,"'",
                                              "   AND bgw02 = '",g_faj.faj02,"'",
                                              "   AND bgw03 = '",g_faj.faj022,"'",
                                              "   AND bgw04 = '1'",
                                              "   AND bgw05*12+bgw06> ",l_year2*12+l_month2,
                                              "   AND bgw05*12+bgw06< ",g_faj.faj57*12+g_faj.faj571, 
                                              "   AND bgw07 = '",g_faj.faj24,"'",
                                              "   AND bgw08 = '",g_faj.faj23,"'",
                                              "   AND bgw12 = 1"
                                  PREPARE p140_amt_p02 FROM g_sql
                                  DECLARE p140_amt_c02 CURSOR WITH HOLD FOR p140_amt_p02
                                  OPEN p140_amt_c02 
                                  FETCH p140_amt_c02 INTO l_depr_amt02
                                  IF cl_null(l_depr_amt02) THEN LET l_depr_amt02=0 END IF
                                  LET l_depr_amt = l_depr_amt0-l_depr_amt02
                               END IF
                            END IF
                           #end TQC-A10007 mod
                        ELSE
                            LET l_depr_amt = 0
                        END IF
                        IF g_type = '1' THEN   #一般提列
                           LET t_rate = 0
                           LET t_rate2= 0
                           SELECT pow(g_faj.faj31/(g_faj.faj14+g_faj.faj141),
                                      1/(g_faj.faj29/12)) INTO t_rate   
                             FROM faa_file
                            WHERE faa00 = '0'
                           LET t_rate2 = ((1 - t_rate) /12) * 100   
                           LET m_amt=(g_faj.faj14+g_faj.faj141-g_faj.faj59-
                                     (l_depr_amt)) *                #CHI-980061
                                     t_rate2 / 100
                        ELSE                   #折畢提列
                           LET t_rate = 0
                           LET t_rate2= 0
                           SELECT pow(g_faj.faj35/(g_faj.faj14+g_faj.faj141),
                                      1/(g_faj.faj29/12)) INTO t_rate  
                             FROM faa_file
                            WHERE faa00 = '0'
                           LET t_rate2 = ((1 - t_rate) / 12) * 100   
                           LET m_amt=(g_faj.faj14+g_faj.faj141-g_faj.faj59-
                                     (l_depr_amt)) *                #CHI-980061
                                     t_rate2 / 100
                        END IF
                     END IF   #CHI-980061 add
                  OTHERWISE EXIT CASE
               END CASE
            END IF
        #-MOD-A90192-add- 
         IF g_aza.aza26 = '2' THEN                                                
            IF g_faj.faj28 = '4' THEN      #工作量法                              
               LET l_fgj05 = 0                                                    
               SELECT fgj05 INTO l_fgj05 FROM fgj_file                            
                WHERE fgj01 = l_yy AND fgj02 = l_mm   
                  AND fgj03 = g_faj.faj02 AND fgj04 = g_faj.faj022                
                  AND fgjconf = 'Y'                                               
               IF cl_null(l_fgj05) THEN LET l_fgj05 = 0 END IF                    
               LET l_rate_y = (g_faj.faj14+g_faj.faj141-g_faj.faj31)/g_faj.faj106 
               LET m_amt = l_rate_y * l_fgj05                                     
            END IF                                                                
            LET l_amt_y = cl_digcut(l_amt_y,g_azi04)                          
            IF l_amt_y = 0 THEN LET l_amt_y = g_faj.faj108 END IF                 
            IF g_faj.faj28 NOT MATCHES '[23]' THEN                                
               LET l_amt_y = 0                                                    
            END IF                                                                
         ELSE                                                                     
            LET l_amt_y = 0                                                       
         END IF                                                                   
        #-MOD-A90192-end- 
         #---1-3 新增一筆折舊費用資料 ----------------------------------------
         IF g_faj.faj23 = '1' THEN
            LET m_faj24 = g_faj.faj24   # 單一部門 -> 折舊部門
         ELSE
            LET m_faj24 = g_faj.faj20   # 多部門分攤 -> 保管部門
         END IF
         IF cl_null(m_faj24) THEN LET m_faj24=' ' END IF   #TQC-A10007 add
         LET m_cost=g_faj.faj14+g_faj.faj141-g_faj.faj59  #成本
         ##若開始提列折舊(faa15='4' 入帳日至月底比率)
         IF g_faa.faa15 = '4' THEN
            IF l_ym = g_faj.faj27 THEN    #第一期攤提
               LET l_first = l_last - DAY(g_faj.faj26) + 1
               LET l_rate = l_first / l_last   #攤提比率
               IF cl_null(l_rate) THEN LET l_rate = 1 END IF
               LET m_amt = m_amt * l_rate
            END IF
         END IF
         IF cl_null(m_amt) THEN LET m_amt = 0 END IF
         # 折舊金額四捨五入
         LET m_amt = cl_digcut(m_amt,g_azi04)   #TQC-A10007 mod 2->g_azi04
         LET m_accd=g_faj.faj32-g_faj.faj60+m_amt         #累折
         #--->本期累折改由(faj_file)讀取
         #--->本期累折 - 本期銷帳累折
         IF g_faj.faj203 = 0 THEN
            LET m_curr   = m_amt
            LET m_faj203 = m_amt
         ELSE
            LET m_curr=(g_faj.faj203 - g_faj.faj204) + m_amt
            LET m_faj203 = g_faj.faj203 + m_amt
         END IF
         IF m_amt < 0 THEN
            let g_msg = 'faj30_01:',g_faj.faj14,'-',g_faj.faj141,'-',
                        g_faj.faj59,
                        g_faj.faj32,'-',g_faj.faj60,'-',g_faj.faj31,'-',
                        g_faj.faj35,'-',m_faj30  clipped
            CALL cl_err(g_msg,'aap-999',0)
            CONTINUE FOREACH
         END IF
         LET g_bgw.bgw01 = g_bgo01
         LET g_bgw.bgw02 = g_faj.faj02
         LET g_bgw.bgw03 = g_faj.faj022
         LET g_bgw.bgw04 = '1'    #NO.TQC-630200 MARK
         LET g_bgw.bgw05 = g_bgo06
         LET g_bgw.bgw06 = l_mm
         LET g_bgw.bgw07 = g_faj.faj24
         LET g_bgw.bgw07 = m_faj24      #TQC-A10007 mod g_faj.faj24->m_faj24
         LET g_bgw.bgw08 = g_faj.faj23
         LET g_bgw.bgw09 = m_amt
         LET g_bgw.bgw10 = 0
         IF g_faa.faa20='2' THEN   #依部门                                                                                          
            IF g_bgw.bgw08  = "1" THEN  #单一部门                                                                                   
               SELECT fbi02                                                                                                         
                 INTO g_bgw.bgw11                                                                                                   
                 FROM fbi_file                                                                                                      
                WHERE fbi01=g_bgw.bgw07                                                                                             
                  AND fbi03=g_faj.faj04                                                                                             
            ELSE                               #TQC-A10007 add
               LET g_bgw.bgw11 = g_faj.faj55   #TQC-A10007 add
            END IF                                                                                                                  
         ELSE                                                                                                                       
            IF g_bgw.bgw08  = "1" THEN  #單一部門
               LET g_bgw.bgw11 = g_faj.faj55
            ELSE
               LET g_bgw.bgw11 = g_faj.faj55   #TQC-A10007 mod faj53->faj55
            END IF
         END IF #CHI-9A0045  
         LET g_bgw.bgw12 = 1
         LET g_bgw.bgwuser = g_user
         LET g_bgw.bgwgrup = g_grup
         LET g_bgw.bgwmodu = ''
         LET g_bgw.bgwdate = g_today
         IF cl_null(g_bgw.bgw11) THEN
            LET g_er1=g_bgw.bgw04[1,1],' ',
                      g_bgw.bgw02[1,10],' ',
                      g_bgw.bgw03[1,20],' ',
                      g_bgw.bgw08[1,01],' ',
                      g_bgw.bgw07[1,10]
            INSERT INTO p140_err_tmp VALUES (g_er1)
         END IF
         LET g_bgw.bgw09 = cl_digcut(g_bgw.bgw09,g_azi04)   #MOD-7B0179
         LET g_bgw.bgw10 = cl_digcut(g_bgw.bgw10,g_azi04)   #MOD-7B0179
         LET g_bgw.bgworiu = g_user      #No.FUN-980030 10/01/04
         LET g_bgw.bgworig = g_grup      #No.FUN-980030 10/01/04
         INSERT INTO bgw_file VALUES(g_bgw.*)
         IF SQLCA.sqlcode THEN
            LET g_success='N' 
            CALL cl_err3("ins","bgw_file",g_bgw.bgw01,g_bgw.bgw02,STATUS,"","ins bgw",1) #FUN-660105  
            CONTINUE FOREACH
         END IF
         IF g_faj.faj23 = '2' THEN
         #-------- 折舊明細檔 SQL (針對多部門分攤折舊金額) ---------------
            LET g_sql="SELECT * FROM bgw_file ",
                      " WHERE bgw05=",g_bgo06,
                      "   AND bgw06=",l_mm,
                      "   AND bgw08='2' ",
                      "   AND bgw04='1' ",
                      "   AND bgw01='",g_bgo01,"'",
                      "   AND bgw02='",g_faj.faj02,"'",
                      "   AND bgw03='",g_faj.faj022,"'"          #MOD-C70086 add
            PREPARE p140_pre1 FROM g_sql
            DECLARE p140_cur1 CURSOR WITH HOLD FOR p140_pre1
            FOREACH p140_cur1 INTO g_bgw.*
               IF STATUS THEN CALL cl_err('cur1',STATUS,1) EXIT FOREACH END IF
               #-->讀取分攤方式
               SELECT fad05 INTO m_fad05 FROM fad_file
                WHERE fad01=g_bgw.bgw05 AND fad02=g_bgw.bgw06
              #   AND fad03=g_bgw.bgw11 AND fad04=g_bgw.bgw07 #TQC-A10007 mark
                  AND fad03=g_faj.faj53 AND fad04=g_faj.faj24 #TQC-A10007
                  AND fad07 = "1"    #No:FUN-AB0088
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","fad_file",g_bgw.bgw05,g_bgw.bgw06,SQLCA.sqlcode,"","sel fad05:",0) #FUN-660105  
                  CONTINUE FOREACH
               END IF
               #-->讀取分母
               IF m_fad05='1' THEN
                  SELECT SUM(fae08) INTO m_fae08 FROM fae_file
                   WHERE fae01=g_bgw.bgw05 AND fae02=g_bgw.bgw06
                 #   AND fae03=g_bgw.bgw11 AND fae04=g_bgw.bgw07 #TQC-A10007 mark
                     AND fae03=g_faj.faj53 AND fae04=g_faj.faj24 #TQC-A10007
                  IF SQLCA.sqlcode OR cl_null(m_fae08) THEN
                     CALL cl_err3("sel","fae_file",g_bgw.bgw05,g_bgw.bgw06,SQLCA.sqlcode,"","sel fae:",0) #FUN-660105  
                     CONTINUE FOREACH
                  END IF
                  LET mm_fae08 = m_fae08            # 分攤比率合計
               END IF
               #-->保留金額以便處理尾差
               LET mm_bgw10=g_bgw.bgw09          # 被分攤金額
               #------- 找 fae_file 分攤單身檔 ---------------
               LET m_tot=0
               DECLARE p140_cur2 CURSOR WITH HOLD FOR
                   SELECT * FROM fae_file
                    WHERE fae01=g_bgw.bgw05 AND fae02=g_bgw.bgw06
                  #   AND fae03=g_bgw.bgw11 AND fae04=g_bgw.bgw07  #TQC-A10007 mark
                      AND fae03=g_faj.faj53 AND fae04=g_faj.faj24  #TQC-A10007
                    ORDER BY fae08   #TQC-A10007 add
               FOREACH p140_cur2 INTO g_fae.*
                 IF SQLCA.sqlcode OR (cl_null(m_fae08) AND m_fad05='1') THEN
                    CALL cl_err('cur2',SQLCA.sqlcode,0) CONTINUE FOREACH
                 END IF
                 CASE
                   WHEN m_fad05 = '1'
                       #str TQC-A10007 mark
                       #SELECT bgw01,bgw02,bgw03,bgw04,bgw05,bgw06,bgw07,bgw08,bgw12
                       #  INTO g_bgw.bgw01,g_bgw.bgw02,g_bgw.bgw03,g_bgw.bgw04,g_bgw.bgw05,
                       #       g_bgw.bgw06,g_bgw.bgw07,g_bgw.bgw08,g_bgw.bgw12
                       #  FROM bgw_file
                       # WHERE bgw01=g_bgw.bgw01 AND bgw02=g_bgw.bgw02
                       #   #AND bgw03=g_bgw.bgw03 AND bgw04='2'  #NO.TQC-630200 MARK
                       #   AND bgw03=g_bgw.bgw03 AND bgw04='1'   
                       #   AND bgw05=g_bgw.bgw05 AND bgw06=g_bgw.bgw06
                       #   AND bgw08='3'
                       #IF STATUS=100 THEN LET g_bgw.bgw01=NULL LET g_bgw.bgw02=NULL LET g_bgw.bgw03=NULL LET g_bgw.bgw04=NULL LET g_bgw.bgw05=NULL LET g_bgw.bgw06=NULL LET g_bgw.bgw07=NULL LET g_bgw.bgw08=NULL LET g_bgw.bgw12=NULL END IF
                       #end TQC-A10007 mark
                        LET mm_ratio= g_fae.fae08/mm_fae08*100 # 分攤比率
                        LET m_ratio = g_fae.fae08/m_fae08*100  # 分攤比率
                        LET m_bgw10 = mm_bgw10*m_ratio/100     # 分攤金額
                        LET m_fae08 = m_fae08 - g_fae.fae08    # 總分攤比率減少
                        LET m_bgw10 = cl_digcut(m_bgw10,g_azi04)  #TQC-A10007 2->g_azi04 
                        LET mm_bgw10= mm_bgw10 - m_bgw10       # 被分攤總數減少
                       #str TQC-A10007 mark
                       #IF g_bgw.bgw01 IS NOT NULL AND        
                       #   g_bgw.bgw02 IS NOT NULL AND        
                       #   g_bgw.bgw03 IS NOT NULL AND        
                       #   g_bgw.bgw04 IS NOT NULL AND        
                       #   g_bgw.bgw05 IS NOT NULL AND        
                       #   g_bgw.bgw06 IS NOT NULL AND        
                       #   g_bgw.bgw07 IS NOT NULL AND        
                       #   g_bgw.bgw08 IS NOT NULL AND        
                       #   g_bgw.bgw12 IS NOT NULL THEN       
                       #   UPDATE bgw_file SET (bgw10)=(m_bgw10)     
                       #    WHERE bgw01 = g_bgw.bgw01 AND            
                       #          bgw02 = g_bgw.bgw02 AND            
                       #          bgw03 = g_bgw.bgw03 AND            
                       #          bgw04 = g_bgw.bgw04 AND            
                       # 	  bgw05 = g_bgw.bgw05 AND            
                       #          bgw06 = g_bgw.bgw06 AND            
                       #          bgw07 = g_bgw.bgw07 AND            
                       #          bgw08 = g_bgw.bgw08 AND            
	               #          bgw12 = g_bgw.bgw12    
                       #   IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                       #      LET g_success='N' 
                       #      CALL cl_err3("upd","bgw_file",g_bgw.bgw01,g_bgw.bgw02,STATUS,"","upd bgw:",1) #FUN-660105
                       #      EXIT FOREACH
                       #   END IF
                       #ELSE
                       #end TQC-A10007 mark
                           LET l_bgw.bgw01 = g_bgo01
                           LET l_bgw.bgw02 = g_bgw.bgw02
                           LET l_bgw.bgw03 = g_bgw.bgw03
                           LET l_bgw.bgw04 = '1'    #NO.TQC-630200 MARK
                           LET l_bgw.bgw05 = g_bgw.bgw05
                           LET l_bgw.bgw06 = g_bgw.bgw06
                           LET l_bgw.bgw07 = g_fae.fae06
                           LET l_bgw.bgw08 = '3'
                           LET l_bgw.bgw09 = 0
                           LET l_bgw.bgw10 = m_bgw10
                           LET l_bgw.bgw11 = g_fae.fae07
                           LET l_bgw.bgw12 = 1
                           LET l_bgw.bgwuser = g_user
                           LET l_bgw.bgwgrup = g_grup
                           LET l_bgw.bgwmodu = ''
                           LET l_bgw.bgwdate = g_today
                           IF cl_null(g_bgw.bgw11) THEN
                              LET g_er1=g_bgw.bgw04[1,1],' ',
                                        g_bgw.bgw02[1,10],' ',
                                        g_bgw.bgw03[1,20],' ',
                                        g_bgw.bgw08[1,01],' ',
                                        g_bgw.bgw07[1,10]
                              INSERT INTO p140_err_tmp VALUES (g_er1)
                           END IF
                           LET l_bgw.bgw09 = cl_digcut(l_bgw.bgw09,g_azi04)   #MOD-7B0179
                           LET l_bgw.bgw10 = cl_digcut(l_bgw.bgw10,g_azi04)   #MOD-7B0179
                           LET l_bgw.bgworiu = g_user      #No.FUN-980030 10/01/04
                           LET l_bgw.bgworig = g_grup      #No.FUN-980030 10/01/04
                           INSERT INTO bgw_file VALUES(l_bgw.*)
                           IF STATUS THEN
                              LET g_success='N' 
                              CALL cl_err3("ins","bgw_file",l_bgw.bgw01,l_bgw.bgw02,STATUS,"","ins2 bgw:",1) #FUN-660105
                              EXIT FOREACH
                           END IF
                       #END IF  #TQC-A10007 mark
                   WHEN m_fad05 = '2'
                     LET l_aag04 = ''
                     SELECT aag04 INTO l_aag04 FROM aag_file
                      WHERE aag01=g_fae.fae09 AND aag00=g_bookno1
                     IF l_aag04='1' THEN
                        SELECT SUM(aao05-aao06) INTO m_aao FROM aao_file
                         WHERE aao00 =g_faa.faa02b AND aao01=g_fae.fae09
                           AND aao02 =g_fae.fae06  AND aao03=g_bgo06
                           AND aao04<=l_mm
                     ELSE
                        SELECT aao05-aao06 INTO m_aao FROM aao_file
                         WHERE aao00=g_faa.faa02b AND aao01=g_fae.fae09
                           AND aao02=g_fae.fae06  AND aao03=g_bgo06
                           AND aao04=l_mm
                     END IF   #CHI-980061 add
                     IF STATUS=100 OR m_aao IS NULL THEN LET m_aao=0 END IF  #CHI-980061 add
                     LET m_tot = m_tot + m_aao
                END CASE
             END FOREACH
             #----- 若為變動比率, 重新 foreach 一次 insert into bgw_file -----
             IF m_fad05='2' THEN
                FOREACH p140_cur2 INTO g_fae.*
                   LET l_aag04 = ''
                   SELECT aag04 INTO l_aag04 FROM aag_file
                    WHERE aag01=g_fae.fae09 AND aag00=g_bookno1
                   IF l_aag04='1' THEN
                      SELECT SUM(aao05-aao06) INTO m_aao FROM aao_file
                       WHERE aao00=g_faa.faa02b AND aao01=g_fae.fae09
                         AND aao02=g_fae.fae06  AND aao03=g_bgo06 AND aao04<=l_mm
                   ELSE
                      SELECT aao05-aao06 INTO m_aao FROM aao_file
                       WHERE aao00=g_faa.faa02b AND aao01=g_fae.fae09
                         AND aao02=g_fae.fae06 AND aao03=g_bgo06 AND aao04=l_mm
                   END IF   #CHI-980061 add
                   IF STATUS=100 OR m_aao IS NULL THEN LET m_aao=0 END IF
                   LET m_ratio = m_aao/m_tot*100
                   LET m_bgw10=g_bgw.bgw10*m_ratio/100
                   LET m_tot_bgw10=m_tot_bgw10+m_bgw10
                   SELECT COUNT(*) INTO l_cnt FROM bgw_file
                    WHERE bgw01=g_bgo01     AND bgw02=g_bgw.bgw02
                      AND bgw03=g_bgw.bgw03 AND bgw04='1'   #NO.TQC-630200 MARK
                      AND bgw05=g_bgw.bgw05 AND bgw06=g_bgw.bgw06
                      AND bgw08='3'
                   IF l_cnt>0 THEN
                      UPDATE bgw_file SET (bgw10)=(m_bgw10)
                       WHERE bgw01=g_bgo01     AND bgw02=g_bgw.bgw02
                         AND bgw03=g_bgw.bgw03 AND bgw04='1'   
                         AND bgw05=g_bgw.bgw05 AND bgw06=g_bgw.bgw06
                         AND bgw07=g_bgw.bgw07 AND bgw08='3'
                      IF STATUS THEN
                         LET g_success='N' 
                         CALL cl_err3("upd","bgw_file",g_bgo01,g_bgw.bgw02,STATUS,"","upd bgw",1) #FUN-660105
                         EXIT FOREACH
                      END IF
                   ELSE
                      LET l_bgw.bgw01 = g_bgo01
                      LET l_bgw.bgw02 = g_bgw.bgw02
                      LET l_bgw.bgw03 = g_bgw.bgw03
                      LET l_bgw.bgw04 = '1'
                      LET l_bgw.bgw05 = g_bgw.bgw05
                      LET l_bgw.bgw06 = g_bgw.bgw06
                      LET l_bgw.bgw07 = g_fae.fae06
                      LET l_bgw.bgw08 = '3'
                      LET l_bgw.bgw09 = 0
                      LET l_bgw.bgw10 = m_bgw10
                      LET l_bgw.bgw11 = g_fae.fae07
                      LET l_bgw.bgw12 = 1
                      LET l_bgw.bgwuser = g_user
                      LET l_bgw.bgwgrup = g_grup
                      LET l_bgw.bgwmodu = ''
                      LET l_bgw.bgwdate = g_today
                      IF cl_null(g_bgw.bgw11) THEN
                         LET g_er1=g_bgw.bgw04[1,1],' ',
                                   g_bgw.bgw02[1,10],' ',
                                   g_bgw.bgw03[1,20],' ',
                                   g_bgw.bgw08[1,01],' ',
                                   g_bgw.bgw07[1,10]
                         INSERT INTO p140_err_tmp VALUES (g_er1)
                      END IF
                      LET l_bgw.bgw09 = cl_digcut(l_bgw.bgw09,g_azi04)   #MOD-7B0179
                      LET l_bgw.bgw10 = cl_digcut(l_bgw.bgw10,g_azi04)   #MOD-7B0179
                      INSERT INTO bgw_file VALUES(l_bgw.*)
                      IF STATUS THEN
                         LET g_success='N' 
                         CALL cl_err3("ins","bgw_file",l_bgw.bgw01,l_bgw.bgw02,STATUS,"","ins3 bgw",1) #FUN-660105
                         EXIT FOREACH
                      END IF
                   END IF
                END FOREACH
             END IF
           END FOREACH
         END IF
      END FOREACH
   END FOR
END FUNCTION
 
FUNCTION p140_list_err()
   DEFINE p_row,p_col LIKE type_file.num5     #No.FUN-680061 SMALLINT
   DEFINE l_msg       LIKE ze_file.ze03       #No.FUN-680061 VARCHAR(72)
   DEFINE l_x         ARRAY[20] OF LIKE type_file.chr50  #No.FUN-680061 VARCHAR(40)
   DEFINE l_za05      LIKE za_file.za05
   DEFINE l_er1       LIKE type_file.chr1000  #No.FUN-680061 VARCHAR(300)
   DEFINE l_er2       LIKE type_file.chr1000  #No.FUN-680061 VARCHAR(300)
   DEFINE l_er3       LIKE type_file.chr1000  #No.FUN-680061 VARCHAR(300)
   DEFINE l_cnt1      LIKE type_file.num5     #No.FUN-680061 SMALLINT
   DEFINE l_cnt2      LIKE type_file.num5     #No.FUN-680061 SMALLINT
   DEFINE l_cnt3      LIKE type_file.num5     #No.FUN-680061 SMALLINT
 
   CLEAR FORM
   ERROR ''
   SELECT COUNT(*) INTO g_cnt FROM p140_err_tmp
   IF g_cnt = 0 THEN RETURN END IF
   IF cl_fglgui() MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4  LET p_col = 14
   ELSE
      LET p_row = 4  LET p_col = 2
   END IF
   OPEN WINDOW p140_err_w AT p_row,p_col
         WITH 10 ROWS, 76 COLUMNS   # ATTRIBUTE(BORDER)  #FUN-9B0067
   LET l_msg=cl_getmsg('afa-361',g_lang)
   LET l_er1='No.',
             l_x[11] CLIPPED,' ',
             l_x[12] CLIPPED,'                            ',
             l_x[13] CLIPPED
  #DISPLAY l_er1 AT 1,1        #CHI-A70049 mark
   LET l_er2=' '
   LET l_er3=' '
   LET l_cnt1=1
   LET l_cnt2=0
   DECLARE p140_list_cs  CURSOR FOR
      SELECT * FROM p140_err_tmp ORDER BY err01
   FOREACH p140_list_cs INTO l_er2
      LET l_cnt2=l_cnt2 + 1
      IF l_cnt1=1 THEN
         FOR g_cnt=2 TO 9
           #DISPLAY l_er3 AT g_cnt,1    #CHI-A70049 mark
         END FOR
      END IF
      LET l_cnt1=l_cnt1 + 1
      #CHI-A70049---mark---start---
      #DISPLAY l_cnt2 USING '###' AT l_cnt1,1   
      #DISPLAY l_er2 CLIPPED AT l_cnt1,7
      #DISPLAY l_msg CLIPPED AT l_cnt1,53
      #CHI-A70049---mark---end---
      IF l_cnt1 > 8 THEN
         PROMPT 'PRESS ANY KEY TO SEE MORE DATA !' FOR g_chr
         LET l_cnt1=1
      END IF
   END FOREACH
   PROMPT 'PRESS ANY KEY TO CONTINUE !' FOR g_chr
   CLOSE WINDOW p140_err_w
END FUNCTION
#No:FUN-9C0077
