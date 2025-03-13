# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglp201.4gl
# Descriptions...: 期末結轉作業 (整批資料處理作業)
# Input parameter: 
# Return code....: 
# Date & Author..: 92/03/11 BY MAY
# Modify.........: 92/09/21 By Nora
#            (**):若當期之傳票, 尚有未過帳之傳票, 則不能進行結轉作業
# Modify.........: No.MOD-490294 04/09/15 By Carrier 
# Modify.........: No.MOD-4A0291 04/10/21 By Nicola top99->No:9938
# Modify.........: No.MOD-510058 05/01/11 By Carrier 如果沒有KEY月份,則不會CALL s_azm
#                                         增加AFTER INPUT,把s_azm加于其后,修改cl_confirm后的回傳值判斷
# Modify ........: No.FUN-570145 06/02/27 By yiting 批次背景執行
# Modify.........: No.FUN-680098 06/08/28 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-710023 07/01/22 By yjkhero 錯誤訊息匯整
# Modify.........: No.MOD-720067 07/02/08 By Smapmin 期別應抓取會計期間設定
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740020 07/04/13 By Carrier 會計科目加帳套 - 財務
# Modify.........: No.MOD-7B0215 07/12/04 By Smapmin 修改transaction流程
# Modify.........: No.FUN-8A0086 08/10/17 By zhaijie錯誤匯總加s_showmsg_init()
# Modify.........: No.MOD-930186 09/03/19 By Sarah 輸入帳別後，應重新依帳別抓取aaa_file帳別參數檔
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990010 09/09/01 By mike 月結輸入年月時應限制不可小於關帳日期
# Modify.........: No:CHI-A70007 10/07/13 By Summer 多帳期改用s_azmm,並依據畫面上的帳別傳遞使用
# Modify.........: No:FUN-AB0068 11/01/06 By Carrier s_eoy多加一个叁数'N'
# Modify.........: No:TQC-C50055 12/05/23 By Dido 過帳前先刪除 CE 傳票 
# Modify.........: No:FUN-C80094 12/10/16 By xuxz 增加axcp332的處理

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE bookno         LIKE aaa_file.aaa01,     #No.FUN-740020
       close_y        LIKE type_file.num5,     #closing year & month   #No.FUN-680098 smallint
       close_m        LIKE type_file.num5,     #closing year & month   #No.FUN-680098 smallint
       g_aaa04        LIKE aaa_file.aaa04,     #現行會計年度           #No.FUN-680098 smallint
       g_aaa05        LIKE aaa_file.aaa05,     #現行期別               #No.FUN-680098 smallint
       b_date         LIKE type_file.dat,      #期間起始日期           #No.FUN-680098 date       
       e_date         LIKE type_file.dat,      #期間起始日期           #No.FUN-680098 date
       g_bookno       LIKE aea_file.aea00,     #帳別 
       bno            LIKE type_file.chr6,     #起始傳票編號           #No.FUN-680098 VARCHAR(6) 
       eno            LIKE type_file.chr6,     #截止傳票編號           #No.FUN-680098 VARCHAR(6)
       g_chr          LIKE type_file.chr1,     #No.FUN-680098CHAR(1)
       ls_date        STRING,                  #No.FUN-570145
       l_flag         LIKE type_file.chr1,     #No.FUN-680098 VARCHAR(01)
       g_change_lang  LIKE type_file.chr1      #No.FUN-680098 VARCHAR(01)
 
MAIN
#   DEFINE    l_time LIKE type_file.chr8        #No.FUN-6A0073
   #-TQC-C50055-add-
    DEFINE l_aba01_arr  DYNAMIC ARRAY OF RECORD            
                             aba01   LIKE aba_file.aba01  
                             END RECORD              
    DEFINE l_arr_i      LIKE type_file.num5      
    DEFINE l_arr_cnt    LIKE type_file.num5      
    DEFINE l_cmd        LIKE type_file.chr1000  
    DEFINE l_aba01_ce   LIKE aba_file.aba01    
   #-TQC-C50055-end-
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   LET bookno = ARG_VAL(1)  #No.FUN-740020
  #-->No.FUN-570145 --start
   INITIALIZE g_bgjob_msgfile TO NULL
   LET close_y  = ARG_VAL(2)
   LET close_m  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   IF cl_null(g_bgjob) THEN LET g_bgjob = 'N' END IF
  #--- No.FUN-570145 --end---
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   #No.FUN-740020  --Begin
   IF bookno IS NULL OR bookno = ' ' THEN
#     SELECT aaz64 INTO g_bookno FROM aaz_file
      LET bookno = g_aza.aza81
   END IF
   #No.FUN-740020  --End  
 
  #--- No.FUN-570145 --start---
   #CALL aglp201_tm(0,0)
   WHILE TRUE
      LET g_change_lang = FALSE
      IF g_bgjob = 'N' THEN
         CALL aglp201_tm(0,0)
         IF cl_sure(21,21) THEN
            CALL cl_wait()
            LET g_success = 'Y'   #MOD-7B0215
           #-TQC-C50055-add-
            DECLARE aba01_arr CURSOR FOR
             SELECT aba01 FROM aba_file
                WHERE aba00 = bookno AND aba02 = e_date AND aba06 = 'CE'
                  AND abapost = 'Y' 
            LET l_arr_i = 1
            CALL l_aba01_arr.clear()
            FOREACH aba01_arr INTO l_aba01_ce
               LET l_aba01_arr[l_arr_i].aba01 = l_aba01_ce
               LET l_arr_i = l_arr_i + 1
            END FOREACH
            LET l_arr_cnt = l_arr_i - 1
            FOR l_arr_i = 1 TO l_arr_cnt
               #已有CE类凭证时，需先还原过账
               IF NOT cl_null(l_aba01_arr[l_arr_i].aba01) THEN
                  LET l_cmd = "aglp109 '",bookno,"' '",e_date,"' '",l_aba01_arr[l_arr_i].aba01,"' ''  'Y'" 
                  CALL cl_cmdrun_wait(l_cmd)   
               END IF
            END FOR
           #-TQC-C50055-end-
            BEGIN WORK
            CALL s_showmsg_init()       #NO.FUN-710023
            CALL p201_process()
            CALL s_showmsg()            #NO.FUN-710023
            IF g_success='Y' THEN
               COMMIT WORK
               CALL p201_axcp332()#FUN-C80094 add
               CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW aglp201_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         #CALL s_azm(close_y,close_m) RETURNING  l_flag,b_date,e_date #CHI-A70007 mark
         #CHI-A70007 add --start--
         IF g_aza.aza63 = 'Y' THEN
            CALL s_azmm(close_y,close_m,g_plant,bookno) RETURNING l_flag,b_date,e_date
         ELSE
            CALL s_azm(close_y,close_m) RETURNING  l_flag,b_date,e_date
         END IF
         #CHI-A70007 add --end--
         LET g_success = 'Y'
         BEGIN WORK
         CALL s_showmsg_init()       #NO.FUN-8A0086
         CALL p201_process()
         CALL s_showmsg()                           #NO.FUN-710023     
         IF g_success = 'Y' THEN
            COMMIT WORK
            CALL p201_axcp332()#FUN-C80094 add
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
#FUN-570145 END----
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION aglp201_tm(p_row,p_col)
   DEFINE  p_row,p_col    LIKE type_file.num5     #No.FUN-680098 SMALLINT
         # Prog. Version..: '5.30.06-13.03.12(01)                #FUN-570145
   DEFINE  lc_cmd         LIKE type_file.chr1000   #No.FUN-570145 #No.FUN-680098 VARCHAR(500)
   DEFINE  l_aaa07        LIKE aaa_file.aaa07     #MOD-990010         
   CALL s_dsmark(bookno)  #No.FUN-740020
 
   LET p_row = 4 LET p_col = 26
 
   OPEN WINDOW aglp201_w AT p_row,p_col WITH FORM "agl/42f/aglp201" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL s_shwact(0,0,bookno)  #No.FUN-740020
   CALL cl_opmsg('q')
   WHILE TRUE 
      IF s_shut(0) THEN RETURN END IF
      CLEAR FORM 
      LET bookno = g_aza.aza81  #No.FUN-740020
      DISPLAY BY NAME bookno    #No.FUN-740020
      SELECT aaa04,aaa05 INTO g_aaa04,g_aaa05 FROM aaa_file
       WHERE aaa01 = bookno  #No.FUN-740020
      LET close_y = g_aaa04
      LET close_m = g_aaa05
      LET g_bgjob = 'N'   #No.FUN-570145
 #    DISPLAY BY NAME close_y,close_m   #No.MOD-4A0291 Mark
     #INPUT close_y,close_m WITHOUT DEFAULTS FROM aaa04,aaa05  #FUN-570145
      INPUT bookno,close_y,close_m,g_bgjob WITHOUT DEFAULTS FROM bookno,aaa04,aaa05,g_bgjob  #No.FUN-740020
 
      #-->No.FUN-570145 --start--
        #ON ACTION locale
        #   CALL cl_dynamic_locale()
        #   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      #---No.FUN-570145 --end--
 
         #No.FUN-740020  --Begin
         AFTER FIELD bookno
            IF NOT cl_null(bookno) THEN
               CALL p201_bookno(bookno)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(bookno,g_errno,0)
                  LET bookno = g_aza.aza81
                  DISPLAY BY NAME bookno
                  NEXT FIELD bookno
               END IF
            END IF
         #No.FUN-740020  --End  
 
         AFTER FIELD aaa04
            IF close_y  IS NULL OR close_y = ' ' THEN
               NEXT FIELD aaa04
            END IF
 
         AFTER FIELD aaa05 
#No.TQC-720032 -- begin --
            IF NOT cl_null(close_m) THEN
               SELECT azm02 INTO g_azm.azm02 FROM azm_file
                 WHERE azm01 = close_y
               IF g_azm.azm02 = 1 THEN
                  IF close_m > 12 OR close_m < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD aaa05
                  END IF
               ELSE
                  IF close_m > 13 OR close_m < 1 THEN
                     NEXT FIELD aaa05
                  END IF
               END IF
            END IF
#No.TQC-720032 -- end --
            IF close_m IS NULL OR close_m = ' ' THEN
               NEXT FIELD aaa05
            END IF
	    #取得會計年度,期別之起始,截止日期
      	    #CALL s_azm(close_y,close_m) RETURNING  l_flag,b_date,e_date #CHI-A70007 mark
            #CHI-A70007 add --start--
            IF g_aza.aza63 = 'Y' THEN
               CALL s_azmm(close_y,close_m,g_plant,bookno) RETURNING l_flag,b_date,e_date
            ELSE
               CALL s_azm(close_y,close_m) RETURNING  l_flag,b_date,e_date
            END IF
            #CHI-A70007 add --end--
            SELECT aaa07 INTO l_aaa07 FROM aaa_file        #MOD-990010                                                              
             WHERE aaa01=bookno                            #MOD-990010                                                              
            IF b_date<l_aaa07 THEN CALL cl_err('','agl-993',0) NEXT FIELD aaa05 END IF #MOD-990010  
           #ADD BY Nora
           ##若此一期間內之傳票資料尚有未過帳傳票,則不允許執行本作業
           #LET g_cnt = 0
           #SELECT COUNT(*) INTO g_cnt FROM aba_file
           #       	WHERE abapost = 'N' AND abaacti = 'Y'
           #       		  AND aba00 = g_bookno AND abb00 = g_bookno
           #       		  AND aba02 BETWEEN b_date AND e_date
           #IF g_cnt > 0 THEN
           #       LET g_msg = b_date,':',e_date,' cnt:',g_cnt using '<<<<<'
           #       CALL cl_err(g_msg,'agl-156',0)
           #       NEXT FIELD aaa05
           #END IF
           #
 
         #No.FUN-740020  --Begin
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(bookno) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aaa"
                  LET g_qryparam.default1 = bookno
                  CALL cl_create_qry() RETURNING bookno
                  DISPLAY BY NAME bookno
                  NEXT FIELD bookno
            END CASE
         #No.FUN-740020  --End  
 
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
 
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
 
         #-->No.FUN-570145 --start--
         ON ACTION locale
#           CALL cl_show_fld_cont()
            LET g_change_lang = TRUE
            EXIT INPUT
         #-->No.FUN-570145 --end----
 
         #MOD-510058  --begin
         AFTER INPUT
            #CALL s_azm(close_y,close_m) RETURNING  l_flag,b_date,e_date #CHI-A70007 mark
            #CHI-A70007 add --start--
            IF g_aza.aza63 = 'Y' THEN
               CALL s_azmm(close_y,close_m,g_plant,bookno) RETURNING l_flag,b_date,e_date
            ELSE
               CALL s_azm(close_y,close_m) RETURNING  l_flag,b_date,e_date
            END IF
            #CHI-A70007 add --end--
         #MOD-510058  --end   
 
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
 
     #-->No.FUN-570145 --start--
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW aglp201_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
 
#     IF cl_sure(21,21) THEN
#        CALL cl_wait()
#        #期末結轉(END OF MONTH)
#        LET g_success = 'Y'
#        BEGIN WORK        
#-----------------------------月結
#        CALL s_eom(g_bookno,b_date,e_date,close_y,close_m,'Y')
#        IF g_success = 'N' THEN 
#           CALL cl_rbmsg(1)
#           ROLLBACK WORK 
#           EXIT WHILE 
#        END IF
#-----------------------------立沖月結
#        CALL s_ins_abi(g_bookno,b_date,e_date,close_y,close_m,'Y')
#        IF g_success = 'N' THEN 
#           CALL cl_rbmsg(1) 
#           ROLLBACK WORK   
#           EXIT WHILE 
#        END IF
#-----------------------------年結
#        IF ((g_aza.aza02 = '1' AND close_m = 12) OR
#            (g_aza.aza02 = '2' AND close_m = 13)   ) THEN
#             IF g_aza.aza26<>'2' THEN #No.MOD-490294 -begin
#                CALL cl_confirm('agl-181') RETURNING g_chr #No.MOD-490294
#                #IF g_chr = 'Y' THEN  #MOD-510058
#                IF g_chr = '1' THEN  #MOD-510058
#                  CALL s_eoy(g_bookno,close_y)       #年結
#                  CALL cl_err('','agl-034',1) 
#               END IF
#             END IF #No.MOD-490294 -end
#        END IF
#        IF g_success = 'N' 
#           THEN CALL cl_rbmsg(1) 
#           ROLLBACK WORK
#           EXIT WHILE 
#        END IF
##-----------------------------UPDATE 現行年度、期別(以帳別資料中之年度、期別)
#        IF close_y = g_aaa04 AND close_m = g_aaa05 THEN
#           IF ((g_aza.aza02 = '1' AND close_m < 12) OR
#               (g_aza.aza02 = '2' AND close_m < 13)   )
#              THEN UPDATE aaa_file SET aaa05 = aaa05+1 WHERE aaa01 = g_bookno
#              ELSE 
#                    #No.MOD-510058  --begin
#                    #IF g_aza.aza26<>'2' AND g_chr = 'Y' THEN     #No.MOD-490294
#                    IF g_aza.aza26<>'2' AND g_chr = '1' THEN     #No.MOD-490294
#                    #No.MOD-510058  --end    
#                      UPDATE aaa_file SET aaa04 = aaa04+1, aaa05 = 1
#                       WHERE aaa01 = g_bookno
#                   END IF
#           END IF
#           IF SQLCA.sqlcode THEN CALL cl_err('(s_eom:ckp#16)',SQLCA.sqlcode,1)
#           END IF
#        END IF
#----------------------------- commit work
#        IF g_success='Y' THEN
#           COMMIT WORK 
#           CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#        ELSE
#           ROLLBACK WORK 
#           CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
#        END IF
#        IF l_flag THEN
#           CONTINUE WHILE
#        ELSE
#           EXIT WHILE
#        END IF
#     END IF
      IF g_bgjob = "Y" THEN
         LET lc_cmd = NULL
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "aglp201"
         IF SQLCA.sqlcode OR cl_null(lc_cmd) THEN
            CALL cl_err('aglp201','9031',1)  
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " ''",
                         " '",close_y CLIPPED,"'",
                         " '",close_m CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('aglp201',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW aglp201_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
      EXIT WHILE
      #-- No.FUN-570145 --end---
      ERROR ""
   END WHILE
#  CLOSE WINDOW aglp201_w
END FUNCTION
 
#No.FUN-740020  --Begin
FUNCTION p201_bookno(p_bookno)
   DEFINE p_bookno   LIKE aaa_file.aaa01,
          l_aaaacti  LIKE aaa_file.aaaacti
 
   LET g_errno = ' '
  #str MOD-930186 mod
  #SELECT aaaacti INTO l_aaaacti FROM aaa_file WHERE aaa01=p_bookno
   SELECT aaaacti,aaa04,aaa05 INTO l_aaaacti,g_aaa04,g_aaa05
     FROM aaa_file
    WHERE aaa01 = p_bookno
   LET close_y = g_aaa04
   LET close_m = g_aaa05
  #end MOD-930186 mod
   CASE
      WHEN l_aaaacti = 'N' LET g_errno = '9028'
      WHEN STATUS=100      LET g_errno = 'anm-062' #No.7926
      OTHERWISE            LET g_errno = SQLCA.sqlcode USING'-------'
   END CASE
  #str MOD-930186 add
   IF cl_null(g_errno) THEN
      DISPLAY g_aaa04,g_aaa05 TO aaa04,aaa05
   END IF
  #end MOD-930186 add
END FUNCTION
#No.FUN-740020  --End  
 
#FUN-570145 ----start---
FUNCTION p201_process()
  DEFINE l_azm02        LIKE azm_file.azm02   #MOD-720067
 
  #-----------------------------月結
  CALL s_eom(bookno,b_date,e_date,close_y,close_m,'Y')  #No.FUN-740020
  IF g_success = 'N' THEN
     IF g_bgjob = 'N' THEN CALL cl_rbmsg(1) END IF
     RETURN
  END IF
  #-----------------------------立沖月結
  CALL s_ins_abi(bookno,b_date,e_date,close_y,close_m,'Y')  #No.FUN-740020
  IF g_success = 'N' THEN
     IF g_bgjob = 'N' THEN CALL cl_rbmsg(1) END IF
     RETURN
  END IF
  #-----------------------------年結
  #-----MOD-720067---------
  SELECT azm02 INTO l_azm02 FROM azm_file WHERE azm01=close_y   
  #IF ((g_aza.aza02 = '1' AND close_m = 12) OR
  #    (g_aza.aza02 = '2' AND close_m = 13)   ) THEN
  IF ((l_azm02 = '1' AND close_m = 12) OR
      (l_azm02 = '2' AND close_m = 13)   ) THEN
  #-----END MOD-720067-----
     IF g_aza.aza26<>'2' THEN #No:BUG-490294 -begin
        IF g_bgjob = 'N' THEN
            CALL cl_confirm('agl-181') RETURNING g_chr #No:BUG-490294
        ELSE
            LET g_chr = '1'
        END IF
 
        IF g_chr = '1' THEN  #BUG-510058
           #No.FUN-AB0068  --Begin
           #CALL s_eoy(bookno,close_y)       #年結  #No.FUN-740020
           CALL s_eoy(bookno,close_y,'N')
           #No.FUN-AB0068  --End  
           CALL cl_err('','agl-034',1)
        END IF
     END IF #No:BUG-490294 -end
  END IF
  IF g_success = 'N' THEN
     IF g_bgjob = 'N' THEN CALL cl_rbmsg(1) END IF
     RETURN
  END IF
  #-----------------------------UPDATE 現行年度、期別(以帳別資料中之年度、期別)
  IF close_y = g_aaa04 AND close_m = g_aaa05 THEN
     #-----MOD-720067--------- 
     #IF ((g_aza.aza02 = '1' AND close_m < 12) OR
     #    (g_aza.aza02 = '2' AND close_m < 13)   ) THEN
     IF ((l_azm02 = '1' AND close_m < 12) OR
         (l_azm02 = '2' AND close_m < 13)   ) THEN
     #-----END MOD-720067-----
        UPDATE aaa_file SET aaa05 = aaa05+1 WHERE aaa01 = bookno  #No.FUN-740020
     ELSE
         #No.BUG-510058  --begin
         #IF g_aza.aza26<>'2' AND g_chr = 'Y' THEN     #No:BUG-490294
          IF g_aza.aza26<>'2' AND g_chr = '1' THEN     #No:BUG-490294
             #No.BUG-510058  --end
             UPDATE aaa_file SET aaa04 = aaa04+1, aaa05 = 1
              WHERE aaa01 = bookno  #No.FUN-740020
          END IF
     END IF
     IF SQLCA.sqlcode THEN
#       CALL cl_err('(s_eom:ckp#16)',SQLCA.sqlcode,1)                      #NO.FUN-710023
        CALL s_errmsg('aaa01',bookno,'(s_eom:ckp#16)',SQLCA.sqlcode,1) #NO.FUN-710023  #No.FUN-740020
        LET g_success = 'N'       #FUN-570145
     END IF
  END IF
 
END FUNCTION
#NO.FUN-570145 END---------
#FUN-C80094--add--str
FUNCTION p201_axcp332()
  DEFINE l_aba02 LIKE aba_file.aba02
  DEFINE l_next_year     LIKE type_file.num5,
          l_next_month    LIKE type_file.num5,
          l_n             LIKE type_file.num5,
          l_cmd           STRING
  SELECT oaz92,oaz93,oaz107 INTO g_oaz.oaz92,g_oaz.oaz93,g_oaz.oaz107 FROM oaz_file
   IF g_oaz.oaz92='Y' AND g_oaz.oaz93='Y' AND g_oaz.oaz107='Y' THEN
      IF g_aza.aza02 = 1 THEN
         IF close_m = 12 THEN
            LET l_next_year = close_y +1
            LET l_next_month = 1
         ELSE
            LET l_next_year = close_y
            LET l_next_month = close_m +1
         END IF 
      END IF 
      IF g_aza.aza02 = 2 THEN
         IF close_m = 13 THEN
            LET l_next_year = close_y+1
            LET l_next_month = 1
         ELSE
            LET l_next_year = close_y
            LET l_next_month = close_m+1
         END IF 
      END IF 
      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM aba_file
       WHERE aba00 = bookno
         AND aba03 = l_next_year AND aba04 = l_next_month
         AND aba07 IN (SELECT cdj13 FROM cdj_file
                        WHERE cdj00 = '2' AND cdj01 = bookno
                          AND cdj02 = close_y 
                          AND cdj03 = close_m
                          AND cdjconf = 'Y')
      IF l_n = 0 THEN     
        #IF (cl_confirm("axc-218")) THEN #xuxz mark 20120910
            LET l_cmd = "axcp332 '",bookno,"' '",close_y,"' '",close_m,"' 'Y' '",g_aaz.aaz68,"'"
            CALL cl_cmdrun_wait(l_cmd )
        #END IF #xuxz mark 20120910
      END IF 
   END IF
END FUNCTION 
  #FUN-C80094--add--end


