# Prog. Version..: '5.30.06-13.04.16(00010)'     #
#
# Pattern name...: anmp730.4gl
# Descriptions...: 每月利息暫估作業
# Date & Author..: 96/11/25 By paul
# Modify.........: 03/01/24 By Kitty 參考榮成大幅修改
#                  主要修改 CP與銀行承兌匯票另外處理
# Modify.........: No.8609 03/12/15 By Kitty 利息計算配合參數是否回轉及基本資料
#                  每月付息或本息併還修改
# Modify........: No.TQC-5A0134 05/10/31 By Rosayu VARCHAR-> CHAR
# Modify.........: No.MOD-5C0047 05/12/13 By Smapmin 當月融資單號(nnm01)
#                              已於 anmt730 存在且確認時則不可再重新產生
# Modify.........: NO.FUN-590002 05/12/27By Monster radio type 應都要給預設值
# Modify.........: No.MOD-630008 06/03/02 By Smapmin 統一利息起算日期邏輯寫法
# Modify.........: No.FUN-570127 06/03/08 By yiting 批次背景執行
# Modify.........: No.MOD-640004 06/04/04 By Smapmin 若nne22+1的日期變為NULL,則抓取該月份的最後一天
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改.
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.MOD-6B0096 06/11/20 By Smapmin 以前已還款,不應出現在暫估中
# Modify.........: No.FUN-710024 07/01/17 By Jackho 增加批處理錯誤統整功能
# Modify.........: No.TQC-830031 08/04/03 By Carol lc_cmd 型態改為type_file.chr1000
# Modify.........: No.MOD-8C0251 08/12/31 By Sarah 利息計算的方式應是算頭不算尾,第一個月計息應從借款日~月底,最後一個月計息應從月初~還款日前一天
# Modify.........: No.MOD-940046 09/04/03 By Dido 中長貸匯率抓取問題
# Modify.........: No.MOD-950209 09/05/20 By lilingyu 暫估利息產生,須為確認資料才可產生
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990072 09/09/08 By mike 中長貸融資,若提前還款完畢,不應再產生利息暫估 
# Modify.........: No.CHI-9A0021 09/10/16 By Lilan 將程式段多餘的DISPLAY給MARK
# Modify.........: No:MOD-A30043 10/03/08 By sabrina 若為月底最後一天，不可+1，日期會變null
# Modify.........: No:MOD-A30107 10/03/17 By sabrina 利息天數計算方式有誤
# Modify.........: No:CHI-A10014 10/10/19 By sabrina 若aza26='0'且幣別=aza17時，利息以365天計算，其餘則用360天計算
# Modify.........: No:MOD-B80128 11/08/11 By johung 將nne22+1改成nne22 nng13+1改成nng13
# Modify.........: No.MOD-BB0070 11/11/07 By Polly 短期的暫估財務分攤費用加入交割服務費用(本幣)(nne46)
# Modify.........: No.MOD-C40137 12/04/18 By Elise 當借款為外幣時，anmp730會帶入每日匯率為買入的匯率，因該帶賣出匯率才對。
# Modify.........: No.TQC-C60158 12/06/20 By lujh  由anmp730批處理產生到anmt730的單據應自動產生分錄底稿，建議改善拋轉時自動產生分錄底稿。
# Modify.........: No.MOD-CA0014 12/10/02 by Polly 無成功產生anmt730單據，需秀出拋轉失敗訊息
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_nng         RECORD LIKE nng_file.*,
       g_nne         RECORD LIKE nne_file.*,
       g_sql         STRING,                 #No.FUN-580092 HCN 
       g_sw          LIKE nnm_file.nnm04,    #No.FUN-680107 #1.融資 2.合約
       g_flag        LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
       g_yy,g_mm     LIKE type_file.num5,    #No.FUN-680107 SMALLINT
       g_date        LIKE type_file.dat,     #No.FUN-680107 DATE
       g_dbs_gl	     LIKE type_file.chr21,   #No.FUN-680107 VARCHAR(21)
       g_wc          STRING,                 #No.FUN-580092 HCN   
       g_buf         LIKE type_file.chr1000, #TQC-5A0134 VARCHAR-->CHAR #No.FUN-680107 VARCHAR(100)
       g_start,g_end LIKE nnm_file.nnm01
DEFINE p_row,p_col   LIKE type_file.num5     #No.FUN-680107 SMALLINT
DEFINE g_cnt         LIKE type_file.num10    #No.FUN-680107 INTEGER
DEFINE g_i           LIKE type_file.num5     #count/index for any purpose #No.FUN-680107 SMALLINT
DEFINE g_msg         LIKE type_file.chr1000  #No.FUN-680107 VARCHAR(72)
DEFINE ls_date       STRING,                 #No.FUN-570127
       g_change_lang LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
#TQC-C60158--add--str--       
DEFINE g_npq25       LIKE npq_file.npq25     
DEFINE g_bookno1     LIKE aza_file.aza81 
DEFINE g_bookno2     LIKE aza_file.aza82
DEFINE g_chr         LIKE type_file.chr1
DEFINE g_npp1       RECORD LIKE npp_file.*
DEFINE p_trno        LIKE npp_file.npp01
DEFINE l_nnm		RECORD LIKE nnm_file.*
#TQC-C60158--add--end--   
       
MAIN
#     DEFINE    l_time LIKE type_file.chr8        #No.FUN-6A0082
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   #-->No.FUN-570127 --start
    INITIALIZE g_bgjob_msgfile TO NULL
    LET g_wc    = ARG_VAL(1)                         #QBE條件
    LET ls_date = ARG_VAL(2)                         #匯率日期
    LET g_date  = cl_batch_bg_date_convert(ls_date)
    LET g_yy    = ARG_VAL(3)                         #利息年
    LET g_mm    = ARG_VAL(4)                         #利息月
    LET g_sw    = ARG_VAL(5)
    LET g_bgjob = ARG_VAL(6)
    IF cl_null(g_bgjob) THEN
       LET g_bgjob = 'N'
    END IF
   #--- No.FUN-570127 --end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
 
#NO.FUN-570127 mark--
#   OPEN WINDOW p730 AT p_row,p_col WITH FORM "anm/42f/anmp730" 
#         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
#   CALL cl_ui_init()
 
#   CALL cl_opmsg('z')
#   LET g_yy=YEAR(TODAY) USING '&&&&'
#   LET g_mm=MONTH(TODAY)
#   LET g_date=TODAY
 
#   CALL p730()
#NO.FUN-570127 mark---
 
#NO.FUN-570127 start--
   WHILE TRUE
     IF g_bgjob = "N" THEN
        CALL p730()             #得出總帳 database name
        CALL p730_ask()         # Ask for data range
        LET g_success = 'Y'
        BEGIN WORK
        IF cl_sure(10,10) THEN
           IF g_sw = '1' THEN
              CALL p730_nne()
              IF g_cnt = 0 THEN             #MOD-CA0014 add
                 LET g_success = 'N'        #MOD-CA0014 add
              END IF                        #MOD-CA0014 add
           ELSE
              CALL p730_nng()
              IF g_cnt = 0 THEN             #MOD-CA0014 add
                 LET g_success = 'N'        #MOD-CA0014 add
              END IF                        #MOD-CA0014 add
           END IF
           CALL s_showmsg()          #No.FUN-710024
           IF g_success = 'Y' THEN
              COMMIT WORK
              CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
           ELSE
              ROLLBACK WORK
              CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
           END IF
           IF g_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
        ELSE
           CONTINUE WHILE
        END IF
     ELSE
        LET g_success = 'Y'
        BEGIN WORK
        CALL p730()   #得出總帳 database name
        IF g_sw = '1' THEN
            CALL p730_nne()
            IF g_cnt = 0 THEN             #MOD-CA0014 add
               LET g_success = 'N'        #MOD-CA0014 add
            END IF                        #MOD-CA0014 add
        ELSE
            CALL p730_nng()
            IF g_cnt = 0 THEN             #MOD-CA0014 add
               LET g_success = 'N'        #MOD-CA0014 add
            END IF                        #MOD-CA0014 add
        END IF
        CALL s_showmsg()          #No.FUN-710024
        IF g_success = "Y" THEN
           COMMIT WORK
        ELSE
           ROLLBACK WORK
        END IF
        CALL cl_batch_bg_javamail(g_success)
        EXIT WHILE
     END IF
   END WHILE
  #--- No.FUN-570127 --end------------------------------------
  # CLOSE WINDOW p730 #NO.FUN-570127 
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION p730()
  #得出總帳 database name 
  #g_nmz.nmz02p -> g_plant_new -> s_getdbs() -> g_dbs_new --> g_dbs_gl
   LET g_plant_new = g_nmz.nmz02p  #總帳管理系統所在工廠編號
   CALL s_getdbs()
   LET g_dbs_gl=g_dbs_new
   
#NO.FUN-570127 mark--
#   WHILE TRUE
#     #NO.FUN-590002-start----
#    LET g_sw = '1'
#     #NO.FUN-590002-end----
#     LET g_flag = 'Y' 
#     CALL p730_ask()		# Ask for data range
#     IF g_flag = 'N' THEN 
#        CONTINUE WHILE
#     END IF
#     IF INT_FLAG THEN 
#        LET INT_FLAG = 0
#        EXIT WHILE 
#     END IF
#
#     IF cl_sure(10,10) THEN 
#        IF g_sw = '1' THEN
#           CALL p730_nne()
#        ELSE
#           CALL p730_nng()
#        END IF
#     END IF
#
#     IF g_success = 'Y' THEN 
#        COMMIT WORK
#        CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
#     ELSE
#        ROLLBACK WORK
#        CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
#     END IF 
#     IF g_flag THEN
#        CONTINUE WHILE
#     ELSE
#        EXIT WHILE
#     END IF
#
#   END WHILE 
#NO.FUN-570127 mark-----
 
END FUNCTION
 
FUNCTION p730_ask()
   DEFINE l_no       LIKE type_file.chr1000,   #No.FUN-680107 VARCHAR(100)
          l_i,l_j    LIKE type_file.num5       #No.FUN-680107 SMALLINT
    #-->No.FUN-570127 --start--
   DEFINE lc_cmd        LIKE type_file.chr1000 #TQC-830031-modify #No.FUN-680107 VARCHAR(500) #No.FUN-570127
   DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-680107 SMALLINT
 
    LET p_row=5
    LET p_col=25
 
    OPEN WINDOW p730 AT p_row,p_col WITH FORM "anm/42f/anmp730"
        ATTRIBUTE (STYLE = g_win_style)
 
    CALL cl_ui_init()
    CALL cl_opmsg('z')
    WHILE TRUE
       MESSAGE ""
       CALL ui.Interface.refresh()
       LET g_yy=YEAR(TODAY) USING '&&&&'
       LET g_mm=MONTH(TODAY)
       LET g_date=TODAY
       LET g_bgjob = 'N'
    #--- No.FUN-570127 --end--------------------------------------
       
 
      CONSTRUCT BY NAME g_wc ON nne01,nne04 
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
#NO.FUN-570127 mark--
#           LET g_action_choice = "locale"
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#NO.FUN-570127 mark--
           LET g_change_lang = TRUE         #No.FUN-570127
           EXIT CONSTRUCT
        
        ON ACTION exit              #加離開功能genero
           LET INT_FLAG = 1
           EXIT CONSTRUCT
     
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('nneuser', 'nnegrup') #FUN-980030
 
#NO.FUN-570127 start--
#      IF g_action_choice = "locale" THEN  #genero
#         LET g_action_choice = ""
#         CALL cl_dynamic_locale()
#         LET g_flag = 'N'
#         RETURN
#      END IF
      
#      IF INT_FLAG THEN
#         RETURN
#      END IF
       IF g_change_lang THEN
          LET g_change_lang = FALSE
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          CONTINUE WHILE
       END IF
 
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          CLOSE WINDOW p730
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
          EXIT PROGRAM
       END IF
#-- No.FUN-570127 --end---
     
      #INPUT g_date,g_yy,g_mm,g_sw WITHOUT DEFAULTS FROM bdate,yy,mm,a
      INPUT g_date,g_yy,g_mm,g_sw,g_bgjob WITHOUT DEFAULTS FROM bdate,yy,mm,a,g_bgjob  #NO.FUN-570127
                                  
         AFTER FIELD mm        
           IF NOT cl_null(g_mm) THEN 
              IF g_mm > 13 OR g_mm <= 0 THEN 
                 NEXT FIELD mm       
              END IF
           END IF
 
         AFTER FIELD a        
           IF NOT cl_null(g_sw) THEN 
              IF g_sw  NOT MATCHES "[12]" THEN 
                 NEXT FIELD a        
              END IF
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
 
 
         ON ACTION exit  #加離開功能genero
            LET INT_FLAG = 1
            EXIT INPUT
      
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
         #-->No.FUN-570127 --start--
          ON ACTION locale
             LET g_change_lang = TRUE
             EXIT INPUT
         #---No.FUN-570127 --end--
 
      END INPUT
 
#NO.FUN-570127 start---
       IF g_change_lang THEN
          LET g_change_lang = FALSE
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          CONTINUE WHILE
       END IF
 
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          CLOSE WINDOW p730
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
          EXIT PROGRAM
       END IF
#NO.FUN-570127 END-----
 
      #IF INT_FLAG THEN RETURN END IF   #NO.FUN-570127 mark
 
      IF g_sw = '2' THEN
         LET g_buf=g_wc 
         LET l_j=length(g_buf)
         FOR l_i=1 TO l_j
             IF g_buf[l_i,l_i+4]='nne01' THEN 
                LET g_buf[l_i,l_i+4]='nng01' 
             END IF
         END FOR
         FOR l_i=1 TO l_j
             IF g_buf[l_i,l_i+4]='nne04' THEN 
                LET g_buf[l_i,l_i+4]='nng04' 
             END IF
         END FOR
         LET g_wc  = g_buf
      END IF
 
#NO.FUN-570127 start--
       IF g_bgjob = "Y" THEN
          LET lc_cmd = NULL
          SELECT zz08 INTO lc_cmd FROM zz_file
           WHERE zz01 = "anmp730"
         IF SQLCA.sqlcode OR cl_null(lc_cmd) THEN
             CALL cl_err('anmp730','9031',1)   
         ELSE
            LET g_wc = cl_replace_str(g_wc, "'", "\"")
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",g_wc CLIPPED,"'",
                         " '",g_date CLIPPED,"'",
                         " '",g_yy CLIPPED,"'",
                         " '",g_mm CLIPPED,"'",
                         " '",g_sw CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('anmp730',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p730
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
         EXIT PROGRAM
       END IF
       EXIT WHILE
   END WHILE
#---No.FUN-570127 --end--
 
END FUNCTION
 
FUNCTION p730_nne()
   DEFINE l_nne		RECORD LIKE nne_file.*,
          #l_nnm        RECORD LIKE nnm_file.*,    #TQC-C60158  mark
          l_nnm13 	LIKE nnm_file.nnm13,
          l_nnn03       LIKE nnn_file.nnn03,
          l_nnn06       LIKE nnn_file.nnn06,    # Jason 020415 類別
          l_nnl12       LIKE nnl_file.nnl12,
          l_str		LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(40)
          l_begin,l_end	LIKE type_file.dat,     #No.FUN-680107 DATE
          l_yy,t_yy	LIKE type_file.num5,    #No.FUN-680107 SMALLINT
          l_mm,l_dd,j	LIKE type_file.num5,    #No.FUN-680107 SMALLINT
          l_ins		LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
          amt_nnm17     LIKE nnm_file.nnm17 
 
   LET l_begin = MDY(g_mm,1,g_yy)   # 以g_yy g_mm 之年月,找出來該月之第一天
   LET l_mm = g_mm + 1              # 及最後一天之日期, 
   LET l_yy = g_yy                  # 下月第一天減一,即為該月之月底日期
   IF  l_mm = 13 THEN               # ex:8611 則l_begin = 861101
       LET l_mm = 1                 #           l_end =   861130
       LET l_yy = l_yy + 1          # 在 g_sql 中檢查,確保8611 落在起訖範圍內
   END IF                           # 若年月拆開個自檢查,在g_sql中會有bug
   LET l_end = MDY(l_mm,1,l_yy)
   LET l_end = l_end - 1
                                    
   LET g_sql   ="SELECT * ",               
                " FROM nne_file  ",        
                " WHERE ",g_wc CLIPPED,    
                "   AND nne111 <= '",l_end,"'",                             
                "   AND nne112 >= '",l_begin,"'",
                "   AND (nne26 IS NULL OR nne26 >= '",l_end,"')",   #MOD-6B0096
              # "   AND nneconf <> 'X' "    #MOD-950209 mark
                "   AND nneconf = 'Y' "     #MOD-950209 
              # "   AND nne27 < nne12 "    #99/02/26 modify已還金額應<融資金額
                                           #若已還在本月,則會錯誤
              # " AND nne08='1'"
                         
   PREPARE p730_nne_p  FROM g_sql
   IF STATUS THEN 
      CALL cl_err('prepare p730_nne_p',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM 
   END IF
   DECLARE p730_nne_c  CURSOR WITH HOLD FOR p730_nne_p 
 
#   BEGIN WORK              #No.FUN-710024 mark
 
   LET g_success = 'Y'
   WHILE TRUE
      IF g_bgjob = 'N' THEN  #NO.FUN-570127 
          LET p_row = 18 LET p_col = 42
          OPEN WINDOW p730_nne_w AT p_row,p_col WITH 5 rows, 30 COLUMNS 
          CALL cl_getmsg('anm-289',g_lang) RETURNING l_str #No:8609
         #DISPLAY l_str AT 3,5  #CHI-9A0021
      END IF
      LET g_cnt=0
      CALL s_showmsg_init()   #No.FUN-710024
      FOREACH p730_nne_c  INTO l_nne.*          
         INITIALIZE l_nnm.* TO NULL
         #---modi by kitty BUG NO:2032 增加判斷還款若已還完,則不產生暫估
         SELECT SUM(nnl12/nnk23) INTO l_nnl12 FROM nnk_file,nnl_file
          WHERE nnk01=nnl01 AND nnl03='1' AND nnl04=l_nne.nne01 
            AND nnk02 < l_begin AND nnkconf='Y'
 
         IF cl_null(l_nnl12) THEN LET l_nnl12=0 END IF
         IF l_nne.nne12-l_nnl12<=0 THEN 
            CONTINUE FOREACH 
         END IF
         #----
 
         LET g_cnt = g_cnt + 1
         #--- NO:0269 (融資種類的計算方式若為0->不計，則不做暫估) -------#
        # Jason 020415
       # SELECT nnn03 INTO l_nnn03 FROM nnn_file WHERE nnn01=l_nne.nne06
         SELECT nnn03,nnn06 INTO l_nnn03,l_nnn06 FROM nnn_file WHERE nnn01=l_nne.nne06
         IF l_nnn03='0' THEN CONTINUE FOREACH END IF
         #---------------------------------------------------------------#
         SELECT * INTO l_nnm.*
            FROM nnm_file                                         
	   WHERE nnm01 = l_nne.nne01 AND nnm02 = g_yy AND nnm03 = g_mm
         IF STATUS=0 THEN
            IF l_nnm.nnmglno IS NOT NULL THEN CONTINUE FOREACH END IF
            IF l_nnm.nnm13   IS NOT NULL THEN CONTINUE FOREACH END IF
            IF l_nnm.nnmconf ='Y' THEN CONTINUE FOREACH END IF     #No:8989
            DELETE FROM nnm_file                                         
                   WHERE nnm01 = l_nne.nne01 AND nnm02 = g_yy AND nnm03 = g_mm AND nnmconf='N'   #No:8989
         END IF
 
         LET l_nnm.nnm01 = l_nne.nne01              
         LET l_nnm.nnm02 = g_yy
         LET l_nnm.nnm03 = g_mm
         LET l_nnm.nnm04 = g_sw
         LET l_nnm.nnm15 = 1
         LET l_nnm.nnm17 = 0
         LET l_nnm.nnmconf='N'              #No:8989
         LET l_nnm.nnmuser = g_user
         LET l_nnm.nnmgrup = g_grup
         LET l_nnm.nnmdate = g_today
 
         #利息計算的方式應是算頭不算尾,
         #第一個月計息應從借款日~月底,最後一個月計息應從月初~還款日前一天
                   #********第一月份 計息為day(起息日)-當月最後一天   ******#
         CASE WHEN (YEAR(l_nne.nne111) = g_yy AND MONTH(l_nne.nne111) = g_mm)
                 IF l_nne.nne22 < DAY(l_nne.nne111) THEN
                    #No:8609 若起息日(28日)比每月還息日(25日)後面,則用起息日
                    LET l_dd = DAY(l_nne.nne111)
                 ELSE
                   #利息計算的方式應是算頭不算尾
                   #LET l_dd = l_nne.nne22+1  #No:8609每月還息日+1天開始估(26到月底)  #MOD-8C0251 mark
                    LET l_dd = l_nne.nne22    #No:8609每月還息日開始估(25到月底)      #MOD-8C0251
                 END IF
              #  LET l_nnm.nnm05 = MDY(g_mm,l_dd,g_yy)
                 LET l_nnm.nnm06 = s_monend(g_yy,g_mm)
 
                 ###-------- 99/05/07  NO:0086   -----------------#
                 IF l_nne.nne08 = '1' THEN
                    LET l_nnm.nnm05 = MDY(g_mm,l_dd,g_yy)
                    #-----MOD-640004---------
                    IF cl_null(l_nnm.nnm05) THEN
                       LET l_nnm.nnm05 = s_monend(g_yy,g_mm)
                    END IF
                    #-----END MOD-640004-----
                 ELSE
                    LET l_nnm.nnm05 = l_nne.nne111 
                  # LET l_nnm.nnm07 = l_nnm.nnm06 - l_nnm.nnm05
                 END IF
                 ####---------------------------------------------#
                #MOD-A30107---modify---start---
                #LET l_nnm.nnm07 = l_nnm.nnm06 - l_nnm.nnm05 + 1 
                 IF l_nnm.nnm06 = l_nne.nne112 THEN   #止算日期=融資截止日期   
                    LET l_nnm.nnm07 = l_nnm.nnm06 - l_nnm.nnm05
                 ELSE
                    LET l_nnm.nnm07 = l_nnm.nnm06 - l_nnm.nnm05 + 1
                 END IF
                #MOD-A30107---modify---end---
                 IF l_nnm.nnm07 < 0 THEN LET l_nnm.nnm07=0 END IF     #No:8609
                 # Jason 020415 For CP 暫估財務分攤費用
                 IF l_nnn06  ='2'  THEN
                    #暫估財務分攤費用=(折價+保證+承銷+簽證+交割服務費)/發行天數*暫估天數
                    LET l_nnm.nnm17 =(l_nne.nne25+l_nne.nne29+
                                      l_nne.nne24+l_nne.nne37+l_nne.nne46) #MOD-BB0070 add nne46
                                    /(l_nne.nne112-l_nne.nne111)
                                    * l_nnm.nnm07
                    LET l_nnm.nnm17=cl_digcut(l_nnm.nnm17,g_azi04)   #No:8989
                 END IF
                 # -----end
                   #********最後月份 計息為1 -day(到息日)-1 **********#
              WHEN (YEAR(l_nne.nne112) = g_yy AND MONTH(l_nne.nne112) = g_mm)
                 IF l_nne.nne22 < DAY(l_nne.nne112) THEN
                   #No:8609 若到息日(28日)比每月還息日(25日)後面,則用到息日
                   #LET l_dd = l_nne.nne22+1       #MOD-630008
                    LET l_dd = DAY(l_nne.nne112)   #MOD-630008
                 ELSE
                   #LET l_dd = DAY(l_nne.nne112)   #MOD-630008
                   #LET l_dd = l_nne.nne22+1       #MOD-630008  #MOD-8C0251 mark
                    LET l_dd = l_nne.nne22         #MOD-630008  #MOD-8C0251
                 END IF
                 LET l_nnm.nnm06 = MDY(g_mm,l_dd,g_yy)
                 #-----MOD-640004---------
                 IF cl_null(l_nnm.nnm06) THEN
                    LET l_nnm.nnm06 = s_monend(g_yy,g_mm)
                 END IF
                 #-----END MOD-640004-----
                 ###-------- 99/05/07  NO:0086   -----------------#
                 IF l_nne.nne08 = '1' THEN    #No:8609
#                   LET l_nnm.nnm05 = MDY(g_mm,l_nne.nne22+1,g_yy)   #No:8609   #MOD-B80128 mark
                    LET l_nnm.nnm05 = MDY(g_mm,l_nne.nne22,g_yy)     #MOD-B80128
                    #-----MOD-640004---------
                    IF cl_null(l_nnm.nnm05) THEN
                       LET l_nnm.nnm05 = s_monend(g_yy,g_mm)
                    END IF
                    #-----END MOD-640004-----
                   #MOD-A30107---modify---start---
                   #LET l_nnm.nnm07 = l_nnm.nnm06 - l_nnm.nnm05 + 1 
                    IF l_nnm.nnm06 = l_nne.nne112 THEN   #止算日期=融資截止日期   
                       LET l_nnm.nnm07 = l_nnm.nnm06 - l_nnm.nnm05
                    ELSE
                       LET l_nnm.nnm07 = l_nnm.nnm06 - l_nnm.nnm05 + 1
                    END IF
                   #MOD-A30107---modify---end---
                 ELSE
                    IF g_nmz.nmz52='Y' THEN
                       IF cl_null(l_nne.nne33) THEN    #用上次還息日當開始日期
                         #LET l_nnm.nnm05 = l_nne.nne111+1 #MOD-C40137 mark
                          LET l_nnm.nnm05 = l_nne.nne111   #MOD-C40137
                       ELSE
                         #LET l_nnm.nnm05 = l_nne.nne33+1  #MOD-C40137 mark
                          LET l_nnm.nnm05 = l_nne.nne33    #MOD-C40137 
                       END IF
                    ELSE
                       LET l_nnm.nnm05 = MDY(g_mm,1,g_yy)
                    END IF
                   #MOD-A30107---modify---start---
                   #LET l_nnm.nnm07 = l_nnm.nnm06 - l_nnm.nnm05 + 1 
                    IF l_nnm.nnm06 = l_nne.nne112 THEN   #止算日期=融資截止日期   
                       LET l_nnm.nnm07 = l_nnm.nnm06 - l_nnm.nnm05
                    ELSE
                       LET l_nnm.nnm07 = l_nnm.nnm06 - l_nnm.nnm05 + 1
                    END IF
                   #MOD-A30107---modify---end---
                 END IF
                 ####---------------------------------------------#
                #LET l_nnm.nnm05 = MDY(g_mm,1,g_yy)
                #LET l_nnm.nnm07 = l_nnm.nnm06 - l_nnm.nnm05 
                # Jason 020415 For CP 暫估財務分攤費用
                 IF l_nnm.nnm07 < 0 THEN LET l_nnm.nnm07=0 END IF     #No:8609
                 IF l_nnn06  ='2'  THEN
                    #暫估財務分攤費用=(折價+保證+承銷+簽證+交割服務費) - 累計已攤提金額
                    SELECT SUM(nnm17) INTO amt_nnm17 FROM nnm_file
                    WHERE nnm01 = l_nne.nne01
                    LET l_nnm.nnm17 =(l_nne.nne25+l_nne.nne29+
                                      l_nne.nne24+l_nne.nne37+l_nne.nne46) #MOD-BB0070 add nne46
                                    - amt_nnm17
                    LET l_nnm.nnm17=cl_digcut(l_nnm.nnm17,g_azi04)   #No:8989
                 END IF
                # -----end
                   #********中間月份 計息為1~當月月底 ***************#
              OTHERWISE
                 IF l_nne.nne08 = '1' THEN   #No:8609
# Joan 020703 中間月份 計息為1~31,30 or 31天 --------------------------
                    LET l_nnm.nnm06 = s_monend(g_yy,g_mm)
#                   LET l_nnm.nnm05 = MDY(g_mm,l_nne.nne22+1,g_yy)   #MOD-B80128 mark
                    LET l_nnm.nnm05 = MDY(g_mm,l_nne.nne22,g_yy)     #MOD-B80128
                    #-----MOD-640004---------
                    IF cl_null(l_nnm.nnm05) THEN
                       LET l_nnm.nnm05 = s_monend(g_yy,g_mm)
                    END IF
                    #-----END MOD-640004-----
                   #MOD-A30107---modify---start---
                   #LET l_nnm.nnm07 = l_nnm.nnm06 - l_nnm.nnm05 + 1 
                    IF l_nnm.nnm06 = l_nne.nne112 THEN   #止算日期=融資截止日期   
                       LET l_nnm.nnm07 = l_nnm.nnm06 - l_nnm.nnm05
                    ELSE
                       LET l_nnm.nnm07 = l_nnm.nnm06 - l_nnm.nnm05 + 1
                    END IF
                   #MOD-A30107---modify---end---
# Joan 020703 end -----------------------------------------------------
                 ELSE    #本息併還
                    IF g_nmz.nmz52='Y' THEN   #No:8609
                       IF cl_null(l_nne.nne33) THEN    #用上次還息日當開始日期
                         #LET l_nnm.nnm05 = l_nne.nne111+1 #MOD-C40137 mark
                          LET l_nnm.nnm05 = l_nne.nne111   #MOD-C40137
                       ELSE
                         #LET l_nnm.nnm05 = l_nne.nne33+1  #MOD-C40137 mark
                          LET l_nnm.nnm05 = l_nne.nne33    #MOD-C40137
                       END IF
                       LET l_nnm.nnm06 = s_monend(g_yy,g_mm)
                      #MOD-A30107---modify---start---
                      #LET l_nnm.nnm07 = l_nnm.nnm06 - l_nnm.nnm05 + 1 
                       IF l_nnm.nnm06 = l_nne.nne112 THEN   #止算日期=融資截止日期   
                          LET l_nnm.nnm07 = l_nnm.nnm06 - l_nnm.nnm05
                       ELSE
                          LET l_nnm.nnm07 = l_nnm.nnm06 - l_nnm.nnm05 + 1
                       END IF
                      #MOD-A30107---modify---end---
                    ELSE                      #No:8609不回轉固定估整個月
                       LET l_nnm.nnm06 = s_monend(g_yy,g_mm)
                       LET l_nnm.nnm05 = MDY(g_mm,1,g_yy)
                      #MOD-A30107---modify---start---
                      #LET l_nnm.nnm07 = l_nnm.nnm06 - l_nnm.nnm05 + 1 
                       IF l_nnm.nnm06 = l_nne.nne112 THEN   #止算日期=融資截止日期   
                          LET l_nnm.nnm07 = l_nnm.nnm06 - l_nnm.nnm05
                       ELSE
                          LET l_nnm.nnm07 = l_nnm.nnm06 - l_nnm.nnm05 + 1
                       END IF
                      #MOD-A30107---modify---end---
                    END IF
                 END IF
                 ####---------------------------------------------#
                 IF l_nnm.nnm07 < 0 THEN LET l_nnm.nnm07=0 END IF     #No:8609
# End
                # Jason 020415 For CP 暫估財務分攤費用
                 IF l_nnn06  ='2'  THEN
                    #暫估財務分攤費用=(折價+保證+承銷+簽證+交割服務費)/發行天數*暫估天數
                    LET l_nnm.nnm17 =(l_nne.nne25+l_nne.nne29+
                                      l_nne.nne24+l_nne.nne37+l_nne.nne46) #MOD-BB0070 add nne46
                                    /(l_nne.nne112-l_nne.nne111)
                                    * l_nnm.nnm07
                    LET l_nnm.nnm17=cl_digcut(l_nnm.nnm17,g_azi04)    #No:8989
                 END IF
                # -----end
         END CASE
# Thomas 020103
         LET l_nnm.nnm08 = l_nne.nne13
        #IF l_nne.nne14 IS NULL
        #   THEN LET l_nnm.nnm08 = l_nne.nne13
        #   ELSE LET l_nnm.nnm08 = l_nne.nne14
        #END IF
# End 
         LET l_nnm.nnm09 = l_nne.nne16
       # LET l_nnm.nnm10 = l_nne.nne17
         #-----------   99/05/07 NO:0086     -----------------------#
        #CALL s_curr3(l_nnm.nnm09,g_date,'B') RETURNING l_nnm.nnm10 #MOD-C40137 mark
         CALL s_curr3(l_nnm.nnm09,g_date,'S') RETURNING l_nnm.nnm10 #MOD-C40137 
         #---------
        #IF l_nnm.nnm09 = g_aza.aza17                             #CHI-A10014 mark
         IF g_aza.aza26='0' AND l_nnm.nnm09 = g_aza.aza17         #CHI-A10014 add
            THEN LET g_i=365	# 本幣一年採365天
            ELSE LET g_i=360	# 外幣一年採360天
         END IF
         ##-- 99/05/07 NO:0086  [ 若採浮動匯率計息 ]----------------#
# Thomas 020115
        #IF l_nne.nne09 = '2' THEN      
        #   SELECT azx04 INTO l_nnm.nnm08 FROM azx_file
        #    WHERE azx01 = l_nnm.nnm09
        #      AND azx02 = l_nnm.nnm02
        #      AND azx03 = l_nnm.nnm03
        #   IF STATUS AND (cl_null(l_nnm.nnm08) OR l_nnm.nnm08 <=0) THEN
#       #      CALL cl_err(l_nnm.nnm08,'anm-961',0)  
        #      LET g_success = 'N'
        #      EXIT FOREACH
        #   END IF
        #   IF cl_null(l_nnm.nnm08) THEN LET l_nnm.nnm08 = 0 END IF
        #END IF
# End
         ##---------------------------------------------------------#
 
  #************ 原幣利息=(貸款金額-已還金額)*(利率/100/365)*天數 **************#
   #------- NO:0271 modify in 99/05/30 -------------------#
    SELECT SUM(nnl12/nnk23) INTO l_nnl12 FROM nnl_file,nnk_file
     WHERE nnl01=nnk01 AND nnl03='1' AND nnl04=l_nnm.nnm01 
       AND nnk02 > l_nnm.nnm06 AND nnkconf='Y'
    IF cl_null(l_nnl12) THEN LET l_nnl12=0 END IF
    LET l_nne.nne27 = l_nne.nne27 - l_nnl12    #已還金額
    IF cl_null(l_nne.nne27) THEN LET l_nne.nne27=0 END IF
   #------------------------------------------------------#
# Joan 020719 若為CP折價,利息原/本幣= 0 (只計算暫估財務費用)------- 
#   LET l_nnm.nnm11=(l_nne.nne12-l_nne.nne27)*(l_nnm.nnm08/100/g_i)*l_nnm.nnm07
    LET l_nnm.nnm11 = 0 
    IF l_nnn06 != '2'  THEN
        LET l_nnm.nnm11=(l_nne.nne12-l_nne.nne27)*(l_nnm.nnm08/100/g_i)*l_nnm.nnm07
    END IF
# Joan 020719 end -------------------------------------------------
         SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file   #NO.CHI-6A0004
          WHERE azi01=l_nnm.nnm09
         CALL cl_digcut(l_nnm.nnm11,t_azi04) RETURNING l_nnm.nnm11  #NO.CHI-6A0004
         #-- 本幣利息=原幣利息*Ex.Rate
    # Jason 020415 利息=0 不產生暫估
# Joan 020604 利息& 暫估財務費用=0 不產生暫估---------------------------------
         IF cl_null(l_nnm.nnm11) OR l_nnm.nnm11 = 0 THEN 
            IF cl_null(l_nnm.nnm17) OR l_nnm.nnm17 = 0 THEN
#No.FUN-710024--begin
#                CALL cl_err(l_nnm.nnm01,'anm-289',1)             #No:8609
                CALL s_errmsg('','',l_nnm.nnm01,'anm-289',0)
#No.FUN-710024--end
                #LET g_msg = l_nnm.nnm01,'利息&暫估財務費用=0'   #No:8609
                #ERROR g_msg
                 CONTINUE FOREACH
            END IF 
         END IF
# Joan 020604 end--------------------------------------------------------------
    # ------end
         LET l_nnm.nnm12 = l_nnm.nnm11 * l_nnm.nnm10
#NO.CHI-6A0004--BEGIN
#         SELECT azi03,azi04 INTO g_azi03,g_azi04 FROM azi_file 
#          WHERE azi01=g_aza.aza17
#NO.CHI-6A0004 --END 
          LET l_nnm.nnm12=cl_digcut(l_nnm.nnm12,g_azi04)
         LET l_nnm.nnm14 = l_nne.nne04
# Thomas 01/12/03
         IF l_nne.nne25 != 0 THEN
            LET l_nnm.nnm16 = '1'
         END IF
# End #
          LET l_nnm.nnm17=cl_digcut(l_nnm.nnm17,g_azi04)
 
         #FUN-980005  add legal 
         LET l_nnm.nnmlegal = g_legal
         #FUN-980005  end legal 
 
         LET l_nnm.nnmoriu = g_user      #No.FUN-980030 10/01/04
         LET l_nnm.nnmorig = g_grup      #No.FUN-980030 10/01/04
         INSERT INTO nnm_file VALUES (l_nnm.*)
         IF SQLCA.SQLCODE THEN
#           CALL cl_err("ins nnm ",SQLCA.SQLCODE,1)    #No.FUN-660148
#No.FUN-710024--begin
#            CALL cl_err3("ins","nnm_file",l_nnm.nnm01,l_nnm.nnm02,SQLCA.sqlcode,"","ins nnm",1) #No.FUN-660148
            LET g_showmsg=l_nnm.nnm01,"/",l_nnm.nnm02,l_nnm.nnm03   
            CALL s_errmsg('nnm01,nnm02,nnm03',g_showmsg,"ins nnm ",SQLCA.SQLCODE,1)
#No.FUN-710024--end
            LET g_success = 'N'
         END IF
         IF g_cnt = 1 THEN LET g_start = l_nnm.nnm01 END IF
         #lujh--add--end--
         LET p_trno=l_nnm.nnm01,l_nnm.nnm02 USING '&&&&',l_nnm.nnm03 USING '&#'
         CALL p730_v(p_trno,'0')
         IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
            CALL p730_v(p_trno,'1')
         END IF
         CALL p730_gen_diff()
         #lujh--add--end--
      END FOREACH
      IF SQLCA.sqlcode THEN
#No.FUN-710024--begin
#         CALL cl_err('Foreach nne error !',SQLCA.sqlcode,1)
         CALL s_errmsg('','','Foreach nne error !',SQLCA.sqlcode,1)
#No.FUN-710024--end
         LET g_success = 'N' 
      END IF
      CLOSE WINDOW p730_nne_w
      LET g_end = l_nnm.nnm01
      EXIT WHILE
   END WHILE
   IF g_bgjob ='N' THEN   #No.FUN-570127
       MESSAGE 'nnm01 from ',g_start, ' to ',g_end 
       CALL ui.Interface.refresh()
   END IF
END FUNCTION
 
FUNCTION p730_nng()
   DEFINE l_nng		RECORD LIKE nng_file.*,
          #l_nnm        RECORD LIKE nnm_file.*,   #TQC-C60158  mark
          l_nnm13 	LIKE nnm_file.nnm13,
          l_nnl12       LIKE nnl_file.nnl12,
          l_nnn03       LIKE nnn_file.nnn03,
# Joan 020826 -----------------------------------*
          l_nnn06       LIKE nnn_file.nnn06,
# Joan 020826 end -------------------------------*
          l_str		LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(40)
          l_begin,l_end	LIKE type_file.dat,     #No.FUN-680107 DATE
          l_yy,t_yy	LIKE type_file.num5,    #No.FUN-680107 SMALLINT
          l_mm,l_dd,j	LIKE type_file.num5,    #No.FUN-680107 SMALLINT
          l_aa,l_cc,l_aa_old  LIKE type_file.num5,    #No.FUN-680107 SMALLINT
          l_nnl12_1,l_nnl12_2 LIKE nnl_file.nnl12,
          l_bb          LIKE nnl_file.nnl12,
          l_nnk02       LIKE nnk_file.nnk02,
# Joan 020826 -----------------------------------*
          amt_nnm17     LIKE nnm_file.nnm17,     
# Joan 020826 end -------------------------------*
          l_ins,l_flag  LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
 
   LET l_begin = MDY(g_mm,1,g_yy)   # 以g_yy g_mm 之年月,找出來該月之第一天
   LET l_mm = g_mm + 1              # 及最後一天之日期, 
   LET l_yy = g_yy                  # 下月第一天減一,即為該月之月底日期
   IF  l_mm = 13 THEN               # ex:8611 則l_begin = 861101
       LET l_mm = 1                 #           l_end =   861130
       LET l_yy = l_yy + 1          # 在 g_sql 中檢查,確保8611 落在起訖範圍內
   END IF                           # 若年月拆開個自檢查,在g_sql中會有bug
   LET l_end = MDY(l_mm,1,l_yy)
   LET l_end = l_end - 1
                                    
   LET g_sql   ="SELECT * ",            # ex 起:861120 訖:871120
                " FROM nng_file  ",     # 8611 ->l_begin=861101 l_end=861130
                " WHERE ",g_wc CLIPPED,  # 8711 l_begin= 871101 l_end=871130
# Joan 020702 中長借,利息=0---> 不產生暫估----------------------
# Joan 021105 若已還在本月,則會錯誤
#               " AND nng21 < nng20 ",   # 已還原幣 < 借款原幣                 
# Joan 020702 end ----------------------------------------------
                " AND nng081 <= '",l_end,"'",     
                " AND nngconf = 'Y'",     #MOD-950209 add                                           
                " AND (nng20-nng21>0 OR nng22-nng23>0) ",  #MOD-990072貸款金額-還款金額>0,表示還有未還金額,才需產生利息暫估         
                " AND nng082 >= '",l_begin,"'" #,
#               " AND nng16='1'"
   PREPARE p730_nng_p  FROM g_sql
   IF STATUS THEN 
      CALL cl_err('prepare p730_nng_p',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM 
   END IF
   DECLARE p730_nng_c  CURSOR WITH HOLD FOR p730_nng_p 
   #BEGIN WORK    #NO.FUN-570127 mark
   LET g_success = 'Y'
   WHILE TRUE
      IF g_bgjob = 'N' THEN  #NO.FUN-570127 
          OPEN WINDOW p730_nng_w AT 18,26 WITH 5 rows, 30 COLUMNS 
          CALL cl_getmsg('anm-221',g_lang) RETURNING l_str
         #DISPLAY l_str AT 5,8   #CHI-9A0021
      END IF
      
      LET g_cnt = 0                    
      CALL s_showmsg_init()   #No.FUN-710024
      FOREACH p730_nng_c  INTO l_nng.*          
         INITIALIZE l_nnm.* TO NULL
         #- modi in 00/03/16 (融資種類的計算方式若為0->不計，則不做暫估)-#
#        Joan 020826 ----------------------------------------------------*
#        SELECT nnn03 INTO l_nnn03 FROM nnn_file WHERE nnn01=l_nng.nng24
         SELECT nnn03,nnn06 INTO l_nnn03,l_nnn06
              FROM nnn_file WHERE nnn01=l_nng.nng24
#        Joan 020826 end ------------------------------------------------*
         IF l_nnn03='0' THEN CONTINUE FOREACH END IF
         #---------------------------------------------------------------#
         LET g_cnt = g_cnt + 1
         SELECT * INTO l_nnm.*
            FROM nnm_file                                         
	   WHERE nnm01 = l_nng.nng01 AND nnm02 = g_yy AND nnm03 = g_mm
         IF STATUS=0 THEN
            IF l_nnm.nnmglno IS NOT NULL THEN CONTINUE FOREACH END IF
            IF l_nnm.nnm13   IS NOT NULL THEN CONTINUE FOREACH END IF
            IF l_nnm.nnmconf ='Y' THEN CONTINUE FOREACH END IF   #MOD-5C0047
            DELETE FROM nnm_file                                         
	           WHERE nnm01 = l_nng.nng01 AND nnm02 = g_yy AND nnm03 = g_mm
                         AND nnmconf = 'N'   #MOD-5C0047
         END IF
{
         LET l_yy = g_yy LET l_mm = g_mm - 1
         IF l_mm = 0 THEN
            LET l_mm = 12 LET l_yy = l_yy - 1
         END IF
         LET l_nnm13='x'
         SELECT nnm13 INTO l_nnm13 FROM nnm_file
           WHERE nnm01=l_nng.nng01 AND nnm02=l_yy AND nnm03=l_mm
         IF l_nnm13 IS NULL THEN     #上期尚未還息,不可執行
            CALL cl_err('last and nnm13=n',0,1) LET g_success='N' EXIT FOREACH
         END IF
}
         LET l_nnm.nnm01 = l_nng.nng01              
         LET l_nnm.nnm02 = g_yy
         LET l_nnm.nnm03 = g_mm
         LET l_nnm.nnm04 = g_sw
         LET l_nnm.nnm15 = 2
         LET l_nnm.nnm17 = 0
         LET l_nnm.nnmconf = 'N'       #No:8989
         LET l_nnm.nnmuser = g_user
         LET l_nnm.nnmgrup = g_grup
         LET l_nnm.nnmdate = g_today
 
         #利息計算的方式應是算頭不算尾,
         #第一個月計息應從借款日~月底,最後一個月計息應從月初~還款日前一天
                   #********第一月份 計息為day(起息日)-當月最後一天   ******#
         CASE WHEN (YEAR(l_nng.nng081) = g_yy AND MONTH(l_nng.nng081) = g_mm)
                 IF l_nng.nng13 < DAY(l_nng.nng081) THEN
                    #No:8609 若起息日(28日)比每月還息日(25日)後面,則用起息日
                    LET l_dd = DAY(l_nng.nng081)
                 ELSE
                   #LET l_dd = l_nng.nng13+1  #No:8609每月還息日+1天開始估(26到月底)  #MOD-8C0251 mark
                    LET l_dd = l_nng.nng13    #No:8609每月還息日開始估(25到月底)      #MOD-8C0251
                 END IF
                 #No:8609
                 IF l_nng.nng16='2' THEN
                    LET l_nnm.nnm05 = l_nng.nng081
                 ELSE
                    LET l_nnm.nnm05 = MDY(g_mm,l_dd,g_yy)
                 END IF
                 #End
                 LET l_nnm.nnm06 = s_monend(g_yy,g_mm)
                #MOD-A30107---modify---start---
                #LET l_nnm.nnm07 = l_nnm.nnm06 - l_nnm.nnm05 + 1 
                 IF l_nnm.nnm06 = l_nng.nng102 THEN   #止算日期=融資截止日期   
                    LET l_nnm.nnm07 = l_nnm.nnm06 - l_nnm.nnm05
                 ELSE
                    LET l_nnm.nnm07 = l_nnm.nnm06 - l_nnm.nnm05 + 1
                 END IF
                #MOD-A30107---modify---end---
                 IF l_nnm.nnm07 < 0 THEN LET l_nnm.nnm07=0 END IF    #No:8609表示不用計息
                 ####---------------------------------------------#
 
# Thomas 020826
                 #暫估財務分攤費用=(折價+保證+承銷+簽證) / 發行天數 * 暫估天數
                 LET l_nnm.nnm17 =(l_nng.nng55+l_nng.nng57+
                                   l_nng.nng59+l_nng.nng61)
                                 /(l_nng.nng082-l_nng.nng081)
                                 * l_nnm.nnm07
                 LET l_nnm.nnm17 =cl_digcut(l_nnm.nnm17,g_azi04)    #No:8989
# End
                   #********最後月份 計息為1 -day(到息日)-1 **********#
              WHEN (YEAR(l_nng.nng082) = g_yy AND MONTH(l_nng.nng082) = g_mm)
                 IF l_nng.nng13 < DAY(l_nng.nng082) THEN
                   #No:8609 若到息日(28日)比每月還息日(25日)後面,則用到息日
                   #LET l_dd = l_nng.nng13+1       #MOD-630008
                    LET l_dd = DAY(l_nng.nng082)   #MOD-630008
                 ELSE
                   #LET l_dd = DAY(l_nng.nng082)   #MOD-630008
                   #LET l_dd = l_nng.nng13+1       #MOD-630008   #MOD-8C0251 mark
                    LET l_dd = l_nng.nng13         #MOD-630008   #MOD-8C0251
                 END IF
                 LET l_nnm.nnm06 = MDY(g_mm,l_dd,g_yy)
                 ###-------- 99/05/07  NO:0086   -----------------#
                 IF l_nng.nng16 = '1' THEN    #No:8609 付息方式不同
#                   LET l_nnm.nnm05 = MDY(g_mm,l_nng.nng13+1,g_yy)   #No:8609   #MOD-B80128 mark
                    LET l_nnm.nnm05 = MDY(g_mm,l_nng.nng13,g_yy)     #MOD-B80128
                    #MOD-A30043---add---start
                    IF cl_null(l_nnm.nnm05) THEN
                       LET l_nnm.nnm05 = s_monend(g_yy,g_mm)
                    END IF
                    #MOD-A30043---add---end
                   #MOD-A30107---modify---start---
                   #LET l_nnm.nnm07 = l_nnm.nnm06 - l_nnm.nnm05 + 1 
                    IF l_nnm.nnm06 = l_nng.nng102 THEN   #止算日期=融資截止日期   
                       LET l_nnm.nnm07 = l_nnm.nnm06 - l_nnm.nnm05
                    ELSE
                       LET l_nnm.nnm07 = l_nnm.nnm06 - l_nnm.nnm05 + 1
                    END IF
                   #MOD-A30107---modify---end---
                 ELSE
                    IF g_nmz.nmz52='Y' THEN
                       IF cl_null(l_nng.nng26) THEN    #用上次還息日當開始日期
                         #LET l_nnm.nnm05 = l_nng.nng081+1      #如果上次還息日空白則用借款起始日 #MOD-C40137 mark
                          LET l_nnm.nnm05 = l_nng.nng081        #MOD-C40137
                       ELSE
                         #LET l_nnm.nnm05 = l_nng.nng26+1  #MOD-C40137 mark
                          LET l_nnm.nnm05 = l_nng.nng26    #MOD-C40137
                       END IF
                    ELSE
                       LET l_nnm.nnm05 = MDY(g_mm,1,g_yy)
                    END IF
                   #MOD-A30107---modify---start---
                   #LET l_nnm.nnm07 = l_nnm.nnm06 - l_nnm.nnm05 + 1 
                    IF l_nnm.nnm06 = l_nng.nng102 THEN   #止算日期=融資截止日期   
                       LET l_nnm.nnm07 = l_nnm.nnm06 - l_nnm.nnm05
                    ELSE
                       LET l_nnm.nnm07 = l_nnm.nnm06 - l_nnm.nnm05 + 1
                    END IF
                   #MOD-A30107---modify---end---
                 END IF
                 IF l_nnm.nnm07 < 0 THEN LET l_nnm.nnm07=0 END IF    #No:8609表示不用計息
 
                 SELECT SUM(nnm17) INTO amt_nnm17 FROM nnm_file
                  WHERE nnm01 = l_nng.nng01
                 LET l_nnm.nnm17 =(l_nng.nng55+l_nng.nng57 +l_nng.nng59+l_nng.nng61) -amt_nnm17
                 LET l_nnm.nnm17 =cl_digcut(l_nnm.nnm17,g_azi04)    #No:8989
# End
                   #********中間月份 計息為1~當月月底 ***************#
              OTHERWISE
                 IF l_nng.nng16 = '1' THEN   #No:8609 依付息方式不同算
# Joan 020703 中間月份 計息為1~31,30 or 31天 --------------------------
                    LET l_nnm.nnm06 = s_monend(g_yy,g_mm)
#                   LET l_nnm.nnm05 = MDY(g_mm,l_nng.nng13+1,g_yy)   #MOD-B80128 mark
                    LET l_nnm.nnm05 = MDY(g_mm,l_nng.nng13,g_yy)     #MOD-B80128
                    #MOD-A30043---add---start
                    IF cl_null(l_nnm.nnm05) THEN
                       LET l_nnm.nnm05 = s_monend(g_yy,g_mm)
                    END IF
                    #MOD-A30043---add---end
                   #MOD-A30107---modify---start---
                   #LET l_nnm.nnm07 = l_nnm.nnm06 - l_nnm.nnm05 + 1 
                    IF l_nnm.nnm06 = l_nng.nng102 THEN   #止算日期=融資截止日期   
                       LET l_nnm.nnm07 = l_nnm.nnm06 - l_nnm.nnm05
                    ELSE
                       LET l_nnm.nnm07 = l_nnm.nnm06 - l_nnm.nnm05 + 1
                    END IF
                   #MOD-A30107---modify---end---
# Joan 020703 end -----------------------------------------------------
                 ELSE    #本息併還
                    IF g_nmz.nmz52='Y' THEN   #No:8609
                       IF cl_null(l_nng.nng26) THEN    #用上次還息日當開始日期
                         #LET l_nnm.nnm05 = l_nng.nng081+1 #MOD-C40137 mark
                          LET l_nnm.nnm05 = l_nng.nng081   #MOD-C40137
                       ELSE
                         #LET l_nnm.nnm05 = l_nng.nng26+1  #MOD-C40137 mark
                          LET l_nnm.nnm05 = l_nng.nng26    #MOD-C40137
                       END IF
                       LET l_nnm.nnm06 = s_monend(g_yy,g_mm)
                      #MOD-A30107---modify---start---
                      #LET l_nnm.nnm07 = l_nnm.nnm06 - l_nnm.nnm05 + 1 
                       IF l_nnm.nnm06 = l_nng.nng102 THEN   #止算日期=融資截止日期   
                          LET l_nnm.nnm07 = l_nnm.nnm06 - l_nnm.nnm05
                       ELSE
                          LET l_nnm.nnm07 = l_nnm.nnm06 - l_nnm.nnm05 + 1
                       END IF
                      #MOD-A30107---modify---end---
                    ELSE                      #No:8609不回轉固定估整個月
                       LET l_nnm.nnm06 = s_monend(g_yy,g_mm)
                       LET l_nnm.nnm05 = MDY(g_mm,1,g_yy)
                      #MOD-A30107---modify---start---
                      #LET l_nnm.nnm07 = l_nnm.nnm06 - l_nnm.nnm05 + 1 
                       IF l_nnm.nnm06 = l_nng.nng102 THEN   #止算日期=融資截止日期   
                          LET l_nnm.nnm07 = l_nnm.nnm06 - l_nnm.nnm05
                       ELSE
                          LET l_nnm.nnm07 = l_nnm.nnm06 - l_nnm.nnm05 + 1
                       END IF
                      #MOD-A30107---modify---end---
                    END IF
                 END IF
                 IF l_nnm.nnm07 < 0 THEN LET l_nnm.nnm07=0 END IF    #No:8609表示不用計息
# Thomas 020826
                 #暫估財務分攤費用=(折價+保證+承銷+簽證)/發行天數*暫估天數
                 LET l_nnm.nnm17 =(l_nng.nng55+l_nng.nng57+
                                   l_nng.nng59+l_nng.nng61)
                                 /(l_nng.nng082-l_nng.nng081)
                                 * l_nnm.nnm07
                 LET l_nnm.nnm17=cl_digcut(l_nnm.nnm17,g_azi04)    #No:8989
# End
         END CASE
         IF l_nng.nng09 IS NULL
            THEN LET l_nnm.nnm08 = l_nng.nng09
            ELSE LET l_nnm.nnm08 = l_nng.nng09
         END IF
         LET l_nnm.nnm09 = l_nng.nng18
        #LET l_nnm.nnm10 = l_nng.nng19                                #MOD-940046 mark
        #CALL s_curr3(l_nnm.nnm09,g_date,'B') RETURNING l_nnm.nnm10   #MOD-940046 add #MOD-C40137 mark
         CALL s_curr3(l_nnm.nnm09,g_date,'S') RETURNING l_nnm.nnm10   #MOD-C40137  
        #IF l_nnm.nnm09 = g_aza.aza17                             #CHI-A10014 mark
         IF g_aza.aza26='0' AND l_nnm.nnm09 = g_aza.aza17         #CHI-A10014 add
            THEN LET g_i=365	# 本幣一年採365天
            ELSE LET g_i=360	# 外幣一年採360天
         END IF
         ##-- 99/05/07 NO:0086  [ 若採浮動匯率計息 ]----------------#
# Thomas 020115 浮動利率不處理, 同固定利率
        #IF l_nng.nng14 = '2' THEN      
        #   SELECT azx04 INTO l_nnm.nnm08 FROM azx_file
        #    WHERE azx01 = l_nnm.nnm09
        #      AND azx02 = l_nnm.nnm02
        #      AND azx03 = l_nnm.nnm03
        #   IF STATUS AND (cl_null(l_nnm.nnm08) OR l_nnm.nnm08 <=0) THEN
#       #      CALL cl_err(l_nnm.nnm08,'anm-961',0)  
        #      LET g_success = 'N'
        #      EXIT FOREACH
        #   END IF
        #   IF cl_null(l_nnm.nnm08) THEN LET l_nnm.nnm08 = 0 END IF
        #END IF
# End
         ##---------------------------------------------------------#
 
 #********* 原幣利息=(貸款金額-已還金額)*(利率*/100/365)*天數 *****************#
   #------- NO:0271 modify in 99/05/30 判斷是否有止算日之後的還款金額 #
    SELECT SUM(nnl12/nnk23) INTO l_nnl12 FROM nnl_file,nnk_file
     WHERE nnl01=nnk01 AND nnl03='2' AND nnl04=l_nnm.nnm01 
       AND nnk02 > l_nnm.nnm06 AND nnkconf='Y'
    IF cl_null(l_nnl12) THEN LET l_nnl12=0 END IF
    LET l_nng.nng21 = l_nng.nng21 - l_nnl12   #已還金額
   #--- 判斷是否有本月還款之金額 
    LET l_nnl12_1=0
    SELECT SUM(nnl12/nnk23) INTO l_nnl12_1 FROM nnl_file,nnk_file
     WHERE nnl01=nnk01 AND nnl03='2' AND nnl04=l_nnm.nnm01 
       AND nnk02 BETWEEN l_nnm.nnm05 AND l_nnm.nnm06 AND nnkconf='Y'
    IF cl_null(l_nnl12_1) THEN LET l_nnl12_1=0 END IF
# Joan 020826 若為CP折價,利息原/本幣= 0 (只計算暫估財務費用)-----------*
  LET l_nnm.nnm11=0
  IF l_nnn06 != '2' THEN
# Joan 020826 end -----------------------------------------------------*
    IF l_nnl12_1>0 THEN      #如果本月有還款,則須分段計算
       LET l_flag='1'        #判斷是否第一筆還本
       LET l_bb  =0          #還本金額(累計當月已)
       LET l_nnm.nnm11=0
       LET g_sql   ="SELECT nnk02,nnl12 ",
                    " FROM nnl_file,nnk_file  ",        
                    " WHERE nnl04 ='",l_nnm.nnm01,"' AND ",
                    "   nnk02 BETWEEN '",l_nnm.nnm05,"' AND '",l_nnm.nnm06,"'", 
                    "   AND nnl01=nnk01",
                    "   AND nnkconf='Y' ORDER BY nnk02"
       PREPARE p730_nnk_p  FROM g_sql
       DECLARE p730_nnk_c  CURSOR WITH HOLD FOR p730_nnk_p 
       FOREACH p730_nnk_c INTO l_nnk02,l_nnl12_2
          LET l_aa=DAY(l_nnk02)      #取日期
          IF l_flag='1' THEN                       #第一筆算法不同
             LET l_flag='2'
             LET l_aa_old=l_aa
             LET l_nnm.nnm11=l_nnm.nnm11+(l_nng.nng20-l_nng.nng21)*(l_nnm.nnm08/100/g_i)*(l_aa-1)  
             LET l_bb=l_bb+l_nnl12_2
          ELSE                                     #中間段
             LET l_nnm.nnm11=l_nnm.nnm11+(l_nng.nng20-l_nng.nng21-l_bb)*(l_nnm.nnm08/100/g_i)*(l_aa-l_aa_old)  
             LET l_aa_old=l_aa
             LET l_bb=l_bb+l_nnl12_2
          END IF
       END FOREACH 
       LET l_cc=DAY(l_nnm.nnm06)                   #最後一段
       LET l_nnm.nnm11=l_nnm.nnm11+(l_nng.nng20-l_nng.nng21-l_bb)*(l_nnm.nnm08/100/g_i)*(l_cc-l_aa)  
    ELSE
     LET l_nnm.nnm11=(l_nng.nng20-l_nng.nng21)*(l_nnm.nnm08/100/g_i)*l_nnm.nnm07
    END IF
# Joan 020826 --------*
  END IF
# Joan 020826 end ----*
   #------------------------------------------------------#
         SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file  #NO.CHI-6A0004
          WHERE azi01=l_nnm.nnm09
         CALL cl_digcut(l_nnm.nnm11,t_azi04) RETURNING l_nnm.nnm11   #No.CHI-6A0004
# Joan 020826 利息& 暫估財務費用=0 不產生暫估 ------------------------*
         IF cl_null(l_nnm.nnm11) OR l_nnm.nnm11 = 0 THEN
            IF cl_null(l_nnm.nnm17) OR l_nnm.nnm17 = 0 THEN
#No.FUN-710024--begin
#                CALL cl_err(l_nnm.nnm01,'anm-289',1)
                CALL s_errmsg('azi01',l_nnm.nnm09,l_nnm.nnm01,'anm-289',0)
#No.FUN-710024--end
                #LET g_msg = l_nnm.nnm01,'利息&暫估財務費用=0'
                #ERROR g_msg
                 CONTINUE FOREACH
            END IF
         END IF
# Joan 020826 end-----------------------------------------------------*
         #-- 本幣利息=原幣利息*Ex.Rate
         LET l_nnm.nnm12 = l_nnm.nnm11 * l_nnm.nnm10
         LET l_nnm.nnm14 = l_nng.nng04
# Joan 021105 if CP ,nnm16='1' --------*
         IF l_nng.nng55 != 0 THEN
            LET l_nnm.nnm16 = '1'
         END IF
# Joan 021105 end ---------------------*
         LET l_nnm.nnm17=cl_digcut(l_nnm.nnm17,t_azi04)   #No.CHI-6A0004
 
         #FUN-980005  add legal 
         LET l_nnm.nnmlegal = g_legal
         #FUN-980005  end legal 
 
         LET l_nnm.nnmoriu = g_user      #No.FUN-980030 10/01/04
         LET l_nnm.nnmorig = g_grup      #No.FUN-980030 10/01/04
         INSERT INTO nnm_file VALUES (l_nnm.*)
         IF SQLCA.SQLCODE THEN
#           CALL cl_err("ins nnm ",SQLCA.SQLCODE,1)   #No.FUN-660148
#No.FUN-710024--begin
#            CALL cl_err3("ins","nnm_file",l_nnm.nnm01,l_nnm.nnm01,SQLCA.sqlcode,"","ins nnm",1) #No.FUN-660148
            LET g_showmsg=l_nnm.nnm01,"/",l_nnm.nnm02,"/",l_nnm.nnm03
            CALL s_errmsg('nnm01,nnm02,nnm03',g_showmsg,"ins nnm ",SQLCA.SQLCODE,1)
#No.FUN-710024--end
            LET g_success = 'N' 
         END IF
         IF g_cnt=1 THEN LET g_start = l_nnm.nnm01 END IF
         #lujh--add--end--
         LET p_trno=l_nnm.nnm01,l_nnm.nnm02 USING '&&&&',l_nnm.nnm03 USING '&#'
         CALL p730_v(p_trno,'0')
         IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
            CALL p730_v(p_trno,'1')
         END IF
         CALL p730_gen_diff()
         #lujh--add--end--
      END FOREACH
      IF SQLCA.sqlcode THEN
#No.FUN-710024--begin
#         CALL cl_err('Foreach nng error !',SQLCA.sqlcode,1) LET g_success = 'N' 
         CALL s_errmsg('','','Foreach nng error !',SQLCA.sqlcode,1) 
         LET g_success = 'N'
#No.FUN-710024--end
      END IF
      LET g_end = l_nnm.nnm01
      CLOSE WINDOW p730_nng_w 
      EXIT WHILE
   END WHILE
   IF g_bgjob ='N' THEN   #No.FUN-570127
       MESSAGE 'nnm01 from ',g_start, ' to ',g_end 
       CALL ui.Interface.refresh()
   END IF
#No.FUN-710024--begin    --mark
#   IF g_success = 'Y' THEN
#      COMMIT WORK
#   ELSE 
#      ROLLBACK WORK
#   END IF
#No.FUN-710024--end      --mark
END FUNCTION

#TQC-C60158--add--str--
FUNCTION p730_v(p_trno,p_npptype)  
   DEFINE p_npptype   LIKE npp_file.npptype    
   DEFINE l_n         LIKE type_file.num10,    
          p_trno      LIKE npp_file.npp01,    
          l_buf       LIKE type_file.chr1000,  
          l_nmq       RECORD LIKE nmq_file.*,
          g_npp       RECORD LIKE npp_file.*,
          g_npq       RECORD LIKE npq_file.*,
          l_aag05     LIKE aag_file.aag05
   DEFINE l_aaa03     LIKE aaa_file.aaa03    
   DEFINE l_azi04_2   LIKE azi_file.azi04
                                                                                   
   CALL s_get_bookno(l_nnm.nnm02) RETURNING g_flag,g_bookno1,g_bookno2                                       
        IF g_flag =  '1' THEN  #抓不到帳別                                                                                       
           CALL cl_err(l_nnm.nnm02,'aoo-081',1)                                                                                  
         END IF                                                                                                                   
   SELECT * INTO l_nnm.* FROM nnm_file
   WHERE nnm01 = l_nnm.nnm01 AND nnm02=l_nnm.nnm02 AND nnm03=l_nnm.nnm03
   IF p_trno IS NULL THEN RETURN END IF
   IF l_nnm.nnmconf='Y' THEN CALL cl_err(l_nnm.nnm01,'anm-232',0) RETURN END IF
   IF NOT cl_null(l_nnm.nnmglno) THEN
      CALL s_errmsg('','',l_nnm.nnm01,'aap-122',0) RETURN  
   END IF

   #重新抓取關帳日期
   SELECT nmz10 INTO g_nmz.nmz10 FROM nmz_file WHERE nmz00='0'

   #-->起算日期不可小於關帳日期
    IF l_nnm.nnm05 <= g_nmz.nmz10 AND g_nmz.nmz52 = 'N' THEN  
      CALL s_errmsg('','',l_nnm.nnm01,'aap-176',0) RETURN  
   END IF
   #-->止算日期不可小於關帳日期
   IF l_nnm.nnm06 <= g_nmz.nmz10 THEN
      CALL s_errmsg('','',l_nnm.nnm01,'aap-176',0) RETURN   
   END IF
   #單號每月相同,所以要加上年月
   #--判斷是否已有分錄底稿
   IF p_npptype = '0' THEN 
      SELECT COUNT(*) INTO l_n FROM npq_file
       WHERE npqsys='NM' AND npq00=18 AND npq01=p_trno AND npq011=0
      IF l_n > 0 THEN
         CALL cl_getmsg('axm-056',g_lang) RETURNING g_msg
         LET l_buf = '(',p_trno CLIPPED,')',"\n",g_msg  #加單號會太長會當掉
         WHILE TRUE
            PROMPT l_buf CLIPPED FOR CHAR g_chr
            IF g_chr MATCHES "[12]" THEN EXIT WHILE END IF
         END WHILE
         IF g_chr = '1' THEN RETURN END IF
         DELETE FROM npq_file
          WHERE npqsys='NM' AND npq00=18 AND npq01=p_trno AND npq011=0
         
         DELETE FROM tic_file WHERE tic04 = p_trno
       
      END IF
   END IF   
   INITIALIZE g_npp.* TO NULL

   SELECT aaa03 INTO l_aaa03 FROM aaa_file
    WHERE aaa01 = g_bookno2
   SELECT azi04 INTO l_azi04_2 FROM azi_file
    WHERE azi01 = l_aaa03

   LET g_npp.nppsys='NM'
   LET g_npp.npp00 =18
   LET g_npp.npp01 =p_trno
   LET g_npp.npp011=0
   LET g_npp.npp02 =l_nnm.nnm06
   LET g_npp.npptype = p_npptype   
 
   LET g_npp.npplegal= g_legal
   INSERT INTO npp_file VALUES(g_npp.*)
   IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
      UPDATE npp_file SET npp02=g_npp.npp02
          WHERE nppsys='NM' AND npp00=18 AND npp01=p_trno AND npp011=0
            AND npptype = p_npptype 
      IF SQLCA.SQLCODE THEN 
         LET g_showmsg = 'NM',"/",18,"/",p_trno,"/",0,"/",p_npptype      
         CALL s_errmsg('nppsys,npp00,npp011,npptype',g_showmsg,'upd npp:',STATUS,0) 
         RETURN END IF
   END IF
   IF SQLCA.SQLCODE THEN 
      LET g_showmsg = g_npp.npp01,"/",g_npp.npp011,"/",g_npp.nppsys,"/",g_npp.npp00 
      CALL s_errmsg('npp01,npp011,nppsys,npp00',g_showmsg,'ins npp:',STATUS,0)       
      RETURN END IF
   #--單身
   INITIALIZE g_npq.* TO NULL
   LET g_npq.npqsys = g_npp.nppsys
   LET g_npq.npq00  = g_npp.npp00
   LET g_npq.npq01  = g_npp.npp01
   LET g_npq.npq011 = g_npp.npp011
   LET g_npq.npqtype = p_npptype   
   SELECT * INTO l_nmq.* FROM nmq_file
   IF l_nnm.nnm12<>0 THEN
      #---------------------利息費用------------------------------#
      #分錄底稿單身檔 借:利息費用
         LET g_npq.npq02 = 1             #項次
         LET g_npq.npq04 = NULL                        
         LET g_npq.npq06 = '1'           #借貸別 (1.借 2.貸)
         LET g_npq.npq07 = l_nnm.nnm12   #本幣金額
         LET g_npq.npq07f= l_nnm.nnm11   #原幣金額
 
         LET g_npq.npq24 = l_nnm.nnm09   #原幣幣別
         LET g_npq.npq25 = l_nnm.nnm10   #匯率
         LET g_npq25     = g_npq.npq25   
         IF p_npptype = '0' THEN
            LET g_npq.npq03 = l_nmq.nmq01   #利息科目
         ELSE
            LET g_npq.npq03 = l_nmq.nmq011  #利息科目
         END IF
         SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
                                                   AND aag00=g_bookno1     
         IF l_aag05='N' THEN
            LET g_npq.npq05 = ''
         ELSE
            IF l_nnm.nnm15='1' THEN
               SELECT nne44 INTO g_npq.npq05 FROM nne_file
                WHERE nne01=l_nnm.nnm01
            ELSE
               LET g_npq.npq05=l_nnm.nnmgrup    #長貸沒打部門取不到
            END IF
         END IF
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,l_nnm.nnm01,l_nnm.nnm02,l_nnm.nnm03,g_bookno1)   
              RETURNING  g_npq.*
         CALL s_def_npq31_npq34(g_npq.*,g_bookno1) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34    
         LET g_npq.npqlegal= g_legal

         IF p_npptype = '1' THEN
            CALL s_newrate(g_bookno1,g_bookno2,
                           g_npq.npq24,g_npq25,g_npp.npp02)
            RETURNING g_npq.npq25
            LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)
         ELSE
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  
         END IF

         INSERT INTO npq_file VALUES (g_npq.*)
         IF STATUS THEN
            LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq.npqsys,"/",g_npq.npq00   
            CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq_1:',STATUS,1) 
            LET g_success='N'
         END IF
      #--貸方:--------------應付利息------------------------------#
         LET g_npq.npq02 = g_npq.npq02+1
         IF p_npptype = '0' THEN
            LET g_npq.npq03 = l_nmq.nmq10
         ELSE
            LET g_npq.npq03 = l_nmq.nmq101
         END IF
         LET g_npq.npq04 = NULL                         
         LET g_npq.npq06 = '2'
         LET g_npq.npq07 = l_nnm.nnm12
         LET g_npq.npq07f= l_nnm.nnm11
         SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
                                                   AND aag00=g_bookno1     
         IF l_aag05='N' THEN
            LET g_npq.npq05 = ''
         ELSE
            IF l_nnm.nnm15='1' THEN
               SELECT nne44 INTO g_npq.npq05 FROM nne_file
                WHERE nne01=l_nnm.nnm01
            ELSE
               LET g_npq.npq05=l_nnm.nnmgrup    #長貸沒打部門取不到
            END IF
         END IF
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,l_nnm.nnm01,l_nnm.nnm02,l_nnm.nnm03,g_bookno1)  
              RETURNING  g_npq.*
           
         CALL s_def_npq31_npq34(g_npq.*,g_bookno1) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34    
 

         IF p_npptype = '1' THEN
            CALL s_newrate(g_bookno1,g_bookno2,
                           g_npq.npq24,g_npq25,g_npp.npp02)
            RETURNING g_npq.npq25
            LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)
         ELSE
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  
         END IF

         LET g_npq.npqlegal= g_legal
         INSERT INTO npq_file VALUES (g_npq.*)
         IF STATUS THEN 
            LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq.npqsys,"/",g_npq.npq00    
            CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq_c1:',STATUS,1) 
            LET g_success='N' END IF
   END IF
   IF l_nnm.nnm17<>0 THEN
      #---------------------其他費用------------------------------#
      #分錄底稿單身檔 借:其他費用
         IF cl_null(g_npq.npq02) THEN LET g_npq.npq02=0 END IF
         LET g_npq.npq02 = g_npq.npq02+1 #項次
         IF p_npptype = '0' THEN
            LET g_npq.npq03 = l_nmq.nmq02   #其他費用
         ELSE
            LET g_npq.npq03 = l_nmq.nmq021  #其他費用
         END IF
         LET g_npq.npq04 = NULL                        
         LET g_npq.npq06 = '1'           #借貸別 (1.借 2.貸)
         LET g_npq.npq07 = l_nnm.nnm17   #本幣金額
         SELECT azi04 INTO t_azi04 FROM azi_file                             
          WHERE azi01=l_nnm.nnm09
         LET g_npq.npq07f= cl_digcut(l_nnm.nnm17/l_nnm.nnm10,t_azi04)   #原幣金額 
         LET g_npq.npq24 = l_nnm.nnm09   #原幣幣別
         LET g_npq.npq25 = l_nnm.nnm10   #匯率
         LET g_npq25     = g_npq.npq25  
         SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
                                                   AND aag00=g_bookno1    
         IF l_aag05='N' THEN
            LET g_npq.npq05 = ''
         ELSE
            IF l_nnm.nnm15='1' THEN
               SELECT nne44 INTO g_npq.npq05 FROM nne_file
                WHERE nne01=l_nnm.nnm01
            ELSE
               LET g_npq.npq05=l_nnm.nnmgrup    #長貸沒打部門取不到
            END IF
         END IF
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,l_nnm.nnm01,l_nnm.nnm02,l_nnm.nnm03,g_bookno1)   
              RETURNING  g_npq.*
                
         CALL s_def_npq31_npq34(g_npq.*,g_bookno1) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34    
         LET g_npq.npqlegal= g_legal

         IF p_npptype = '1' THEN
            CALL s_newrate(g_bookno1,g_bookno2,
                           g_npq.npq24,g_npq25,g_npp.npp02)
            RETURNING g_npq.npq25
            LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)
         ELSE
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  
         END IF

         INSERT INTO npq_file VALUES (g_npq.*)
         IF STATUS THEN
            LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq.npqsys,"/",g_npq.npq00   
            CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq_1:',STATUS,1) 
            LET g_success='N'
         END IF
      #--貸方:--------------預付利息------------------------------#
         LET g_npq.npq02 = g_npq.npq02+1
         IF p_npptype = '0' THEN
            LET g_npq.npq03 = l_nmq.nmq11
         ELSE
            LET g_npq.npq03 = l_nmq.nmq111
         END IF
         LET g_npq.npq04 = NULL                        
         LET g_npq.npq06 = '2'
         LET g_npq.npq07 = l_nnm.nnm17   #本幣金額
         SELECT azi04 INTO t_azi04 FROM azi_file     
          WHERE azi01=l_nnm.nnm09
         LET g_npq.npq07f= cl_digcut(l_nnm.nnm17/l_nnm.nnm10,t_azi04)#原幣金額  
         SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
                                                   AND aag00=g_bookno1     
         IF l_aag05='N' THEN
            LET g_npq.npq05 = ''
         ELSE
            IF l_nnm.nnm15='1' THEN
               SELECT nne44 INTO g_npq.npq05 FROM nne_file
                WHERE nne01=l_nnm.nnm01
            ELSE
               LET g_npq.npq05=l_nnm.nnmgrup    #長貸沒打部門取不到
            END IF
         END IF
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,l_nnm.nnm02,l_nnm.nnm03,g_bookno1)  
              RETURNING  g_npq.*
         
         CALL s_def_npq31_npq34(g_npq.*,g_bookno1) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34   
         LET g_npq.npqlegal= g_legal

         IF p_npptype = '1' THEN
            CALL s_newrate(g_bookno1,g_bookno2,
                           g_npq.npq24,g_npq25,g_npp.npp02)
            RETURNING g_npq.npq25
            LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)
         ELSE
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  
         END IF

         INSERT INTO npq_file VALUES (g_npq.*)
         IF STATUS THEN 
            LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq.npqsys,"/",g_npq.npq00    
            CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq_c1:',STATUS,1) 
            LET g_success='N' END IF
     END IF
     CALL s_flows('3','',g_npq.npq01,g_npp.npp02,'N',g_npq.npqtype,TRUE)  
   #--產生完成
   CALL cl_getmsg('aap-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED

   LET g_npp1.* = g_npp.*   
END FUNCTION

FUNCTION p730_gen_diff()
DEFINE l_aaa   RECORD LIKE aaa_file.*
DEFINE l_npq1           RECORD LIKE npq_file.*
DEFINE l_sum_cr         LIKE npq_file.npq07
DEFINE l_sum_dr         LIKE npq_file.npq07
DEFINE l_nnm		RECORD LIKE nnm_file.*
   IF g_npp1.npptype = '1' THEN
      CALL s_get_bookno(YEAR(l_nnm.nnm02)) RETURNING g_flag,g_bookno1,g_bookno2
      IF g_flag = '1' THEN
         CALL cl_err(YEAR(l_nnm.nnm02),'aoo-081',1)
         RETURN
      END IF
      SELECT * INTO l_aaa.* FROM aaa_file WHERE aaa01 = g_bookno2
      LET l_sum_cr = 0
      LET l_sum_dr = 0
      SELECT SUM(npq07) INTO l_sum_dr
        FROM npq_file
       WHERE npqtype = '1'
         AND npq00 = g_npp1.npp00
         AND npq01 = g_npp1.npp01
         AND npq011= g_npp1.npp011
         AND npqsys= g_npp1.nppsys
         AND npq06 = '1'
      SELECT SUM(npq07) INTO l_sum_cr
        FROM npq_file
       WHERE npqtype = '1'
         AND npq00 = g_npp1.npp00
         AND npq01 = g_npp1.npp01
         AND npq011= g_npp1.npp011
         AND npqsys= g_npp1.nppsys
         AND npq06 = '2'
      IF l_sum_dr <> l_sum_cr THEN
         SELECT MAX(npq02)+1 INTO l_npq1.npq02
           FROM npq_file
          WHERE npqtype = '1'
            AND npq00 = g_npp1.npp00
            AND npq01 = g_npp1.npp01
            AND npq011= g_npp1.npp011
            AND npqsys= g_npp1.nppsys
         LET l_npq1.npqtype = g_npp1.npptype
         LET l_npq1.npq00 = g_npp1.npp00
         LET l_npq1.npq01 = g_npp1.npp01
         LET l_npq1.npq011= g_npp1.npp011
         LET l_npq1.npqsys= g_npp1.nppsys
         LET l_npq1.npq07 = l_sum_dr-l_sum_cr
         LET l_npq1.npq24 = l_aaa.aaa03
         LET l_npq1.npq25 = 1
         
         IF l_npq1.npq07 < 0 THEN
            LET l_npq1.npq03 = l_aaa.aaa11
            LET l_npq1.npq07 = l_npq1.npq07 * -1
            LET l_npq1.npq06 = '1'
         ELSE
            LET l_npq1.npq03 = l_aaa.aaa12
            LET l_npq1.npq06 = '2'
         END IF
         LET l_npq1.npq07f  = l_npq1.npq07
         LET l_npq1.npqlegal= g_legal
         INSERT INTO npq_file VALUES(l_npq1.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","npq_file",g_npp1.npp01,"",STATUS,"","",1) #FUN-670091
            LET g_success = 'N'
         END IF
      END IF
   END IF   
END FUNCTION
#TQC-C60158--add--end--
