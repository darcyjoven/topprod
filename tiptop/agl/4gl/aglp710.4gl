# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglp710.4gl
# Descriptions...: 常用傳票複製作業
# Input parameter: 
# Return code....: 
# Date & Author..: 92/08/06 BY MAY
# Modify.........: 92/09/24 By PIN
#                  加二欄位(簽核處理修正)--->aba_file
# Modify.........: By Melody    配合 aglp102、aglp103 新增兩參數傳至 s_post()
# Modify.........: 97/04/16 By Melody aaa07 改為關帳日期
# Modify.........: 97/05/29 By Melody 新增 tm.a='N' 時的判斷(原無作用)
# Modify.........: No.MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-490344 04/09/20 By Kitty Controlp 未加display
# Modify.........: No.MOD-490294 04/09/15 By Carrier 
# Modify.........: No.FUN-4C0009 04/12/03 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.MOD-510064 05/01/11 By Carrier 修改cl_confirm后的回傳值判斷
# Modify.........: No.MOD-530433 05/04/13 By Smapmin 傳票產生後,雖然有成功,但顯示
#                                                    畫面未將產生的傳票號碼顯示出來
# Modify.........: No.FUN-560060 05/06/13 By day  單據編號修改
# Modify.........: No.FUN-5C0015 060104 BY GILL 處理abb31~abb37
# Modify.........: No.FUN-570145 06/02/27 By yiting 批次作業修改
# Modify.........: No.MOD-640204 06/04/10 By Echo 新增至 aglt110 時須帶申請人預設值,並減何該單別是否需要簽核
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/08/29 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.CHI-680026 06/12/05 By Smapmin 修改分攤比率的算法
# Modify.........: No.FUN-710023 07/01/22 By yjkhero 錯誤訊息匯整
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740065 07/04/13 By Carrier 會計科目加帳套 - 財務
# Modify.........: No.FUN-740218 07/04/27 By cheunl  摘要的拋轉
# Modify.........: No.MOD-770132 07/07/27 By Smampin 變數為NULL時設為0
# Modify.........: No.MOD-7B0215 07/12/04 By Smapmin 修改transaction流程
# Modify.........: No.MOD-820072 08/02/18 By Smapmin Default年度/期別
# Modify.........: No.FUN-810069 08/02/26 By lynn 項目預算取消abb15的管控
# Modify.........: No.FUN-830139 08/04/07 By bnlent 去掉預算項目字段
# Modify.........: No.MOD-840527 08/04/25 By bnlent 傳票產生後,雖然有成功,但顯示
#                                                   畫面未將產生的傳票號碼顯示出來(主要爭對變動比率）
# Modify.........: No.MOD-890037 08/09/08 By Sarah 產生分攤傳票時,有產生分攤傳票
# Modify.........: No.CHI-890005 08/09/11 By Sarah 當來源科目全為貸餘科目時,借貸方值需反轉回來
# Modify.........: No.MOD-8A0157 08/10/17 By Sarah 依據bookno重新抓取aaa04,aaa05至y1,m1中
# Modify.........: No.FUN-8A0086 08/10/17 By zhaijie添加錯誤匯總函數s_showmsg()
# Modify.........: No.MOD-910008 09/01/04 By wujie 拋轉傳票時，應該抓取單頭來源科目部門的金額總和，然后按照單身比例分攤
# Modify.........: No.FUN-920155 09/02/20 By shiwuying 程序名稱由s_post改為aglp102_post
# Modify.........: No.MOD-930280 09/04/09 By Sarah 若aao_file該部門餘額=0,則不應加入分攤
# Modify.........: No.FUN-980003 09/08/11 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980094 09/09/14 By TSD.hoho GP5.2 跨資料庫語法修改
# Modify.........: No.MOD-9C0270 10/01/07 By jan abaoriu,abaorig應與abauser,abagrup預設值一致 ，aba18 給予預設值0
# Modify.........: No.FUN-9C0072 10/10/18 By vealxu 精簡程式碼
# Modify.........: No:CHI-A70007 10/07/13 By Summer 多帳期改用s_azmm,並依據畫面上的帳別傳遞使用
# Modify.........: No:FUN-AB0068 11/01/06 By Carrier s_eoy多加一个叁数'N'
# Modify.........: No:CHI-B50049 11/07/04 By Dido 若金額為負數時,則借貸需轉換金額為正數 
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file
# Modify.........: No.FUN-CB0096 13/01/10 by zhangweib 增加log檔記錄程序運行過程

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
      tm        RECORD
			   y1      LIKE aaa_file.aaa04,
			   m1      LIKE aaa_file.aaa05,
                           bookno  LIKE aaa_file.aaa01,         #No.FUN-740065
               aha02   LIKE aha_file.aha02,
			   y2      LIKE aaa_file.aaa04,
			   m2      LIKE aaa_file.aaa05,
			   date_1  LIKE type_file.dat,          #No.FUN-680098    date 
               b      LIKE type_file.chr1                       #No.FUN-680098    VARCHAR(1)  
               END RECORD,
     g_bookno  LIKE aha_file.aha00,      #帳別
      g_sql     STRING,  #No.FUN-580092 HCN        
     l_azn02   LIKE  azn_file.azn02,
     l_azn04   LIKE  azn_file.azn04,
     l_aac     RECORD LIKE aac_file.*,
     l_aha     RECORD LIKE aha_file.*,
     l_aba     RECORD LIKE aba_file.*,
     l_ans     LIKE type_file.chr1,        #No.FUN-680098    VARCHAR(1)    
     g_ans     LIKE type_file.chr1,        #No.FUN-680098    VARCHAR(1)  
     g_aaa     RECORD LIKE  aaa_file.*,
     l_aba01   LIKE aba_file.aba01,
     g_digit   LIKE type_file.num5         #No.FUN-680098     smallint
DEFINE g_row,g_col LIKE type_file.num5     #No.FUN-680098     smallint
DEFINE g_cnt       LIKE type_file.num10    #No.FUN-680098     integer
DEFINE g_i         LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098 smallint
DEFINE g_chr       LIKE type_file.chr1     #No.FUN-680098  VARCHAR(1) 
DEFINE g_change_lang    LIKE type_file.chr1,     #FUN-570145         #No.FUN-680098   VARCHAR(1) 
      l_flag            LIKE type_file.chr1      #FUN-570145         #No.FUN-680098   VARCHAR(1) 
DEFINE g_t1             LIKE oay_file.oayslip    #MOD-640204         #No.FUN-680098   VARCHAR(5)
#No.FUN-CB0096 ---start--- Add
DEFINE g_id     LIKE azu_file.azu00
DEFINE l_id     STRING
DEFINE l_time   LIKE type_file.chr8
DEFINE t_no     LIKE aba_file.aba01
DEFINE g_azu    RECORD LIKE azu_file.*
#No.FUN-CB0096 ---end  --- Add
 
MAIN
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   LET tm.bookno = ARG_VAL(1)                         #No.FUN-740065
   INITIALIZE g_bgjob_msgfile TO NULL                 #FUN-570145
  LET tm.y1     = ARG_VAL(2)
  LET tm.m1     = ARG_VAL(3)
  LET tm.aha02  = ARG_VAL(4)
  LET tm.y2     = ARG_VAL(5)
  LET tm.m2     = ARG_VAL(6)
  LET tm.date_1 = ARG_VAL(7)
  LET tm.b      = ARG_VAL(8)
  LET g_bgjob   = ARG_VAL(9)
 
  IF cl_null(g_bgjob) THEN LET g_bgjob = 'N' END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF s_aglshut(0) THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM 
   END IF           #FUN-570145  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
 
    IF tm.bookno IS NULL OR tm.bookno = ' ' THEN
       LET tm.bookno= g_aza.aza81
    END IF
    SELECT * INTO g_aaa.* FROM aaa_file WHERE aaa01 = tm.bookno
    SELECT azi04 INTO g_digit FROM azi_file WHERE azi01 = g_aaa.aaa03

   #No.FUN-CB0096 ---start--- Add
    LET l_time = TIME
    LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
    LET l_id = g_plant CLIPPED , g_prog CLIPPED , '100' , g_user CLIPPED , g_today USING 'YYYYMMDD' , l_time
    LET g_sql = "SELECT azu00 + 1 FROM azu_file ",
                " WHERE azu00 LIKE '",l_id,"%' "
    PREPARE aglt110_sel_azu FROM g_sql
    EXECUTE aglt110_sel_azu INTO g_id
    IF cl_null(g_id) THEN
       LET g_id = l_id,'000000'
    ELSE
       LET g_id = g_id + 1
    END IF
    CALL s_log_data('I','100',g_id,'1',l_time,'','')
   #No.FUN-CB0096 ---end  --- Add
 
  WHILE TRUE
     LET g_change_lang = FALSE
     IF g_bgjob = 'N' THEN
        CALL aglp710_tm(0,0)
        IF cl_sure(21,21) THEN
           LET g_success = 'Y'
           CALL cl_wait()
           BEGIN WORK
           CALL aglp710_copy()
           CALL s_showmsg()                        #NO.FUN-8A0086
           IF g_success='Y' THEN
              COMMIT WORK
              CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
           ELSE
              ROLLBACK WORK
              CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
           END IF
           IF l_flag THEN
              CONTINUE WHILE
           ELSE
              CLOSE WINDOW p710_w
              EXIT WHILE
           END IF
        ELSE
           CONTINUE WHILE
        END IF
        CLOSE WINDOW p710_w
     ELSE
        LET g_success = 'Y'
        BEGIN WORK
        SELECT azn02,azn04 INTO l_azn02,l_azn04 FROM azn_file
         WHERE azn01 = tm.date_1
        CALL aglp710_copy()
        CALL s_showmsg()                        #NO.FUN-8A0086
        IF g_success='Y' THEN
           COMMIT WORK
        ELSE
           ROLLBACK WORK
        END IF
        CALL cl_batch_bg_javamail(g_success)
        EXIT WHILE
     END IF
  END WHILE
 
 #No.FUN-CB0096 ---start--- add
  LET l_time = TIME
  LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
  CALL s_log_data('U','100',g_id,'1',l_time,'','')
 #No.FUN-CB0096 ---end  --- add
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION aglp710_tm(p_row,p_col)
   DEFINE   p_row,p_col    LIKE type_file.num5,           #No.FUN-680098 smallint
            l_str          LIKE type_file.chr1000,        #No.FUN-680098 VARCHAR(31)     
            l_flag         LIKE type_file.chr1            #No.FUN-680098  VARCHAR(1) 
   DEFINE  lc_cmd          LIKE type_file.chr1000         #FUN-570145   #No.FUN-680098    VARCHAR(500) 
 
 
   CALL s_dsmark(tm.bookno)  #No.FUN-740065
 
   LET p_row = 3 LET p_col = 20
 
   OPEN WINDOW aglp710_w AT p_row,p_col WITH FORM "agl/42f/aglp710" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
 
   CALL s_shwact(0,0,tm.bookno)  #No.FUN-740065
   CALL cl_opmsg('q')
      CLEAR FORM 
      INITIALIZE tm.* TO NULL            # Default condition
      LET tm.bookno = g_aza.aza81        #No.FUN-740065
      LET tm.y1  = g_aaa.aaa04
      LET tm.m1  = g_aaa.aaa05
      LET tm.b  = 'Y'
      LET tm.date_1  =  g_today
      SELECT azn02,azn04 INTO l_azn02,l_azn04 FROM azn_file    
             WHERE azn01 = tm.date_1
      DISPLAY l_azn02,l_azn04 TO yy,mm
      LET tm.y2  = g_aaa.aaa04
      LET tm.m2  = g_aaa.aaa05
   WHILE TRUE 
      IF s_aglshut(0) THEN RETURN END IF
      LET g_bgjob = 'N'                    #FUN-570145
 
      INPUT BY NAME tm.y1, tm.m1, tm.bookno, tm.aha02,      #No.FUN-740065
                    tm.y2, tm.m2, tm.date_1, tm.b, g_bgjob  #FUN-570145
                WITHOUT DEFAULTS
   
      ON ACTION locale
         LET g_change_lang = TRUE                  #FUN-570145
         
      AFTER FIELD bookno
         IF NOT cl_null(tm.bookno) THEN
            CALL p710_bookno(tm.bookno)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(tm.bookno,g_errno,0)
               LET tm.bookno = g_aza.aza81
               DISPLAY BY NAME tm.bookno
               NEXT FIELD bookno
            END IF
         END IF
 
      AFTER FIELD y2
		 IF tm.y2 > g_aaa.aaa04 THEN #不可大於現行年度
			CALL cl_err(tm.y2,'agl-108',0)
			NEXT FIELD  y2
         END IF
 
      AFTER FIELD m2
         IF NOT cl_null(tm.m2) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.y2
            IF g_azm.azm02 = 1 THEN
               IF tm.m2 > 12 OR tm.m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            ELSE
               IF tm.m2 > 13 OR tm.m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            END IF
         END IF
         IF tm.y2 = g_aaa.aaa04 AND 
		    tm.m2 > g_aaa.aaa05 THEN #不可大於現行年度、期別
			CALL cl_err(tm.m2,'agl-108',0)
			NEXT FIELD m2
         END IF
      AFTER FIELD aha02 
         IF tm.aha02 IS NULL OR tm.aha02  = ' ' THEN
            NEXT FIELD aha02 
         ELSE SELECT * FROM aca_file
                  WHERE aca01 = tm.aha02 AND acaacti IN ('Y','y')
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("sel","aca_file",tm.aha02,"","agl-090","","",1) # NO.FUN-660123
                 LET tm.aha02 = ' '
                 DISPLAY BY NAME tm.aha02
                 NEXT FIELD aha02 
              END IF
         END IF
 
       AFTER FIELD date_1
         IF tm.date_1 IS NULL OR tm.date_1 = ' ' THEN
            NEXT FIELD date_1
         ELSE 
            SELECT azn02,azn04 INTO l_azn02,l_azn04 FROM azn_file 
                   WHERE azn01 = tm.date_1
            IF SQLCA.sqlcode THEN 
               CALL cl_err3("sel","azn_file",tm.date_1,"","agl-101","","",0)   #No.FUN-660123
               NEXT FIELD date_1 
            ELSE
               IF tm.date_1 <= g_aaa.aaa07 THEN    #判斷關帳日期
                  CALL cl_err(tm.date_1,'agl-104',0)   
                  NEXT FIELD date_1
               END IF
            END  IF
            DISPLAY l_azn02,l_azn04 TO yy,mm
         END IF 
 
       AFTER FIELD b
          IF tm.b IS NULL OR tm.b NOT MATCHES '[YN]' then
             NEXT FIELD b
          END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
        CALL cl_cmdask()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(bookno)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aaa"
               LET g_qryparam.default1 = tm.bookno
               CALL cl_create_qry() RETURNING tm.bookno
               DISPLAY BY NAME tm.bookno
               NEXT FIELD bookno
            WHEN INFIELD(aha02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aca"
               LET g_qryparam.default1 = tm.aha02
               CALL cl_create_qry() RETURNING tm.aha02
                DISPLAY BY NAME tm.aha02          #No.MOD-490344
               NEXT FIELD aha02
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
   
         BEFORE INPUT
             CALL cl_qbe_init()
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
  IF INT_FLAG THEN
     LET INT_FLAG = 0
     CLOSE WINDOW p710_w        #FUN-570145
    #No.FUN-CB0096 ---start--- add
     LET l_time = TIME
     LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
     CALL s_log_data('U','100',g_id,'1',l_time,'','')
    #No.FUN-CB0096 ---end  --- add
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
     EXIT PROGRAM
  END IF
 
  IF g_change_lang THEN
     LET g_change_lang = FALSE
     CALL cl_dynamic_locale()
     CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
     CONTINUE WHILE
  END IF
 
  IF g_bgjob = 'Y' THEN
     SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = 'aglp710'
     IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
        CALL cl_err('aglp710','9031',1)   
     ELSE
        LET lc_cmd = lc_cmd CLIPPED,
                     " '",tm.bookno CLIPPED,"'",  #No.FUN-740065
                     " '",tm.y1 CLIPPED,"'",
                     " '",tm.m1 CLIPPED,"'",
                     " '",tm.aha02 CLIPPED,"'",
                     " '",tm.y2 CLIPPED,"'",
                     " '",tm.m2 CLIPPED,"'",
                     " '",tm.date_1 CLIPPED,"'",
                     " '",tm.b CLIPPED,"'",
                     " '",g_bgjob CLIPPED,"'"
        CALL cl_cmdat('aglp710',g_time,lc_cmd CLIPPED)
     END IF
     CLOSE WINDOW p710_w
    #No.FUN-CB0096 ---start--- add
     LET l_time = TIME
     LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
     CALL s_log_data('U','100',g_id,'1',l_time,'','')
    #No.FUN-CB0096 ---end  --- add
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
     EXIT PROGRAM
  END IF
  EXIT WHILE
END WHILE
 
END FUNCTION
 
FUNCTION p710_bookno(p_bookno)
   DEFINE p_bookno   LIKE aaa_file.aaa01,
          l_aaaacti  LIKE aaa_file.aaaacti
 
   LET g_errno = ' '
   SELECT aaaacti,aaa04,aaa05 INTO l_aaaacti,tm.y1,tm.m1
     FROM aaa_file WHERE aaa01=p_bookno
   CASE
      WHEN l_aaaacti = 'N' LET g_errno = '9028'
      WHEN STATUS=100      LET g_errno = 'anm-062' #No.7926
      OTHERWISE LET g_errno = SQLCA.sqlcode USING'-------'
   END CASE
   DISPLAY tm.y1,tm.m1 TO y1,m1   #MOD-8A0157 add
END FUNCTION
 
FUNCTION aglp710_copy()
DEFINE   l_ahb     RECORD LIKE ahb_file.*,
         l_aba06   LIKE aba_file.aba06,
         l_bdate   LIKE type_file.dat,           #No.FUN-680098   date  
         l_edate   LIKE type_file.dat,           #No.FUN-680098   date  
         l_flag    LIKE type_file.chr1,          #No.FUN-680098   VARCHAR(1) 
         l_cnt     LIKE type_file.num5,          #No.FUN-680098   smallint
          l_msg     STRING,                      #No.MOD-480210  
         l_str     LIKE zaa_file.zaa08           #No.FUN-680098   VARCHAR(40)   
DEFINE   l_ahc     RECORD LIKE ahc_file.*
DEFINE li_result     LIKE type_file.num5   #No.FUN-560060        #No.FUN-680098 smallint
 
    IF g_bgjob = 'N' THEN                       #FUN-57014
         OPEN WINDOW copy_g_w AT 18,30
               WITH FORM "agl/42f/aglp7101"                 #No.MOD-480210
         CALL cl_ui_locale("aglp7101")
    END IF
     DECLARE copy_cs1  CURSOR WITH HOLD FOR
             SELECT * FROM aha_file 
                 WHERE aha02 = tm.aha02
                   AND aha00 = tm.bookno  #No.FUN-740065
                   AND ahaacti IN ('y','Y')
                   AND aha05 <= tm.date_1 #所要複製的日期大於等於起始日期
                   AND aha06 >= tm.date_1 #所要複製的日期小於等於有效日期
                   ORDER BY aha03,aha01     #自動產生順序
     LET l_cnt = 0              #No.MOD-480210
     CALL s_showmsg_init()      #NO.FUN-710023 
     FOREACH copy_cs1 INTO l_aha.*
       IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y' 
       END IF                                                     
     	IF SQLCA.sqlcode THEN LET g_success = 'N' EXIT FOREACH  END IF
        INITIALIZE l_aba.* TO NULL
        IF tm.b = 'N' AND l_aha.aha04 IS NOT NULL AND l_aha.aha04 = tm.date_1
           THEN CONTINUE FOREACH
        END IF
         LET l_cnt = l_cnt + 1   #No.MOD-480210
     	#定義單號
     	LET l_aba01[1,g_doc_len+1] = l_aha.aha07,'-'   #總帳傳票單別
     	SELECT * INTO l_aac.* FROM aac_file 
               WHERE aac01 = l_aha.aha07 
                 AND aacacti IN ('y','Y')
     	IF SQLCA.sqlcode THEN 
        	INITIALIZE l_aac.* TO  NULL 
                CALL s_errmsg('aac01',l_aha.aha07,l_aha.aha07,'agl-103',1)     #NO.FUN-710023     
                LET g_success = 'N'
        	EXIT  FOREACH
     	END IF
        LET g_ans = ''
        LET l_aba06 = ''
        CASE WHEN l_aha.aha000 = '1' LET l_aba06 = 'FC'
             WHEN l_aha.aha000 = '2' LET l_aba06 = 'FP'
             WHEN l_aha.aha000 = '3' LET l_aba06 = 'VP'
        END CASE
        SELECT COUNT(*) INTO g_cnt FROM aba_file
         WHERE aba00 = tm.bookno  #No.FUN-740065
           AND aba06 = l_aba06
           AND aba07 = l_aha.aha01
           AND aba02 = tm.date_1
        IF g_cnt> 0 THEN
           CALL cl_getmsg('agl-400',g_lang) RETURNING l_msg
           LET l_msg = l_aha.aha01," ",l_msg CLIPPED
           IF g_bgjob = 'N' THEN            #FUN-570145
               IF cl_confirm(l_msg) THEN 
                  LET g_ans = 'Y' ELSE LET g_ans = 'N'
               END IF
           ELSE
             LET g_ans='Y'
           END IF
        END IF
        IF g_cnt = 0 THEN LET g_ans = 'Y' END IF
        IF g_ans = 'N' THEN
            DECLARE p710_rege CURSOR FOR
             SELECT * FROM aba_file 
              WHERE aba00 = tm.bookno  #No.FUN-740065
                AND aba06 = l_aba06
                AND aba07 = l_aha.aha01
                AND aba02 = tm.date_1
            FOREACH p710_rege INTO l_aba.*
               IF STATUS THEN 
                  LET g_showmsg=tm.bookno,"/",l_aba06,"/",l_aha.aha01,"/",tm.date_1  #No.FUN-740065
                  CALL s_errmsg('aba00,aba06,aba07,aba02',g_showmsg,'p710_reg',STATUS,0)
                  EXIT FOREACH 
               END IF
               IF l_aba.abapost = 'Y' THEN
                  LET g_showmsg=tm.bookno,"/",l_aba06,"/",l_aha.aha01,"/",tm.date_1  #No.FUN-740065
                  CALL s_errmsg('aba00,aba06,aba07,aba02',g_showmsg,l_aba.aba01,'agl-208',1)
                  CONTINUE FOREACH
               END IF 
               IF l_aba.aba06 = 'FC' THEN
                  UPDATE aba_file SET aba02 = tm.date_1,
                                      aba03 = l_azn02,
                                      aba04 = l_azn04,
                                      aba05 = g_today,
                                      aba06 = 'FC',
                                      aba07 = l_aha.aha01,
                                      aba08 = l_aha.aha11,
                                      aba09=l_aha.aha12
                   WHERE aba00 = tm.bookno  AND aba01 = l_aba.aba01  #No.FUN-740065
                   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN 
                  LET g_showmsg=tm.bookno,"/",l_aba.aba01  #No.FUN-740065
                  CALL s_errmsg('aba00,aba01',g_showmsg,'ckp#t1:FA',SQLCA.sqlcode,1)
                      LET g_success = 'N'
                      EXIT FOREACH
                   END IF
      	           #傳票單身的複製
       	           DECLARE update_abb CURSOR WITH HOLD FOR 
                    SELECT * FROM ahb_file WHERE ahb00 = tm.bookno  #No.FUN-740065
                                             AND ahb000 = l_aha.aha000
                                             AND ahb01 = l_aha.aha01 
                                           ORDER BY  ahb02
                   FOREACH update_abb INTO l_ahb.*
                       IF STATUS THEN 
                  LET g_showmsg=tm.bookno,"/",l_aha.aha000,"/",l_aha.aha01  #No.FUN-740065
                  CALL s_errmsg('ahb00,ahb000,ahb01',g_showmsg,'fore upd abb',STATUS,0)
                  EXIT FOREACH  
                       END IF
                       UPDATE abb_file SET abb03 = l_ahb.ahb03,
                                           abb04 = l_ahb.ahb04,
                                           abb05 = l_ahb.ahb05,
                                           abb06 = l_ahb.ahb06,
                                           abb07 = l_ahb.ahb07,
                                           abb08 = l_ahb.ahb08,
                                           abb11 = l_ahb.ahb11,
                                           abb12 = l_ahb.ahb12,
                                           abb13 = l_ahb.ahb13,
                                           abb14 = l_ahb.ahb14,
              
                                           abb31 = l_ahb.ahb31,
                                           abb32 = l_ahb.ahb32,
                                           abb33 = l_ahb.ahb33,
                                           abb34 = l_ahb.ahb34,
                                           abb35 = l_ahb.ahb35,
                                           abb36 = l_ahb.ahb36,
                                           abb37 = l_ahb.ahb37             #FUN-810069
 
                        WHERE abb00 = tm.bookno  #No.FUN-740065
                          AND abb01 = l_aba.aba01
                          AND abb02 = l_ahb.ahb02
                        IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                  LET g_showmsg=tm.bookno,"/",l_aba.aba01,"/",l_ahb.ahb02  #No.FUN-740065
                  CALL s_errmsg('abb00,abb01,abb02',g_showmsg,'ckp#t2:FA',SQLCA.sqlcode,1)
                           LET g_success = 'N'
                           EXIT FOREACH
                        END IF
                   END FOREACH
             END IF
     	     IF l_aba.aba06 = 'FP' THEN #固定比率
                CALL copy_fp(l_aba.aba01) 
     	     END IF
             IF l_aba.aba06 = 'VP' THEN #變動比率
                CALL copy_vp(l_aba.aba01) 
     	     END IF
         END FOREACH
      END IF
      IF g_ans = 'Y' THEN    #重複產生
       	IF l_aha.aha000 = '1' THEN  #來源碼一律為'FA'(Fixed Amount)
     	   IF l_aac.aacauno = 'Y' THEN
              #No.FUN-CB0096 ---start--- Add
               LET t_no = Null
               CALL s_log_check(l_aha.aha01) RETURNING t_no
               IF NOT cl_null(t_no) THEN
                  LET l_aba01 = t_no
                  LET li_result = '1'
               ELSE
              #No.FUN-CB0096 ---end  --- Add
               CALL s_auto_assign_no("agl",l_aha.aha07,tm.date_1,"","","",g_plant,"",tm.bookno)  #No.FUN-740065 #FUN-980094
                 RETURNING li_result,l_aba01                                         
               END IF   #No.FUN-CB0096   Add
               IF (NOT li_result) THEN                                                   
                   LET g_success = 'N'
                   EXIT FOREACH
               END IF                                                                    
     	   END IF
          LET g_t1 = s_get_doc_no(l_aba01)
          SELECT aac08 INTO l_aba.abamksg FROM aac_file WHERE aac01=g_t1
          IF cl_null(l_aba.abamksg) THEN
             LET l_aba.abamksg = 'N'
          END IF
 
     	   #輸入日期一律為輸入的傳票日期,並更新'上次產生日期'為今天的日期
        	   INSERT INTO aba_file(aba00,aba01,aba02,aba03,aba04,aba05,   #No.MOD-470041
                                aba06,aba07,aba08,aba09,aba10,aba11,
                                aba12,aba13,aba14,aba15,aba16,aba17,
                                aba18,aba19,aba20,aba21,aba22,aba23,
                                 abamksg,abasign,abadays,abaprit,abasmax, #No.MOD-480210
                                abasseq,abaprno,abapost,abaacti,abauser,
                                abagrup,abamodu,abadate,aba24,abalegal,abaoriu,abaorig)  #MOD-640204 #FUN-980003 add abalegal
                VALUES (tm.bookno,l_aba01,tm.date_1,l_azn02,l_azn04,g_today,  #No.FUN-740065
                        'FC',l_aha.aha01,l_aha.aha11,l_aha.aha12,'','','N',
                        0,'','','','','0','N','0','','','',   #NO:7572 aba19 default 'N' #NOD-9C0270
                        l_aba.abamksg,                       #aba20 default '0'  #MOD-640204     
                        l_aha.ahasign,l_aha.ahadays,l_aha.ahaprit,0,0,0,'N',
                        'Y',g_user,g_grup,' ',g_today,g_user,g_legal, g_user, g_grup)   #MOD-640204 #FUN-980003 add g_legal      #No.FUN-980030 10/01/04  insert columns oriu, orig
       	   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN 
              LET g_showmsg=tm.bookno,"/",l_aba01      #NO.FUN-710023           #No.FUN-740065
              CALL s_errmsg('aba00,aba01',g_showmsg,'ckp#1:FA',SQLCA.sqlcode,1)
              LET g_success = 'N'
              EXIT FOREACH
      	   END IF
	   LET g_sql = "SELECT * FROM ahc_file WHERE ahc00 = '",tm.bookno,"'", 
                       " AND ahc01 = '",l_aha.aha01,"'"
           PREPARE ahc_p1 FROM g_sql
           DECLARE ahc_c1 CURSOR WITH HOLD FOR ahc_p1
       	   FOREACH ahc_c1 INTO l_ahc.*
             INSERT INTO abc_file(abc00,abc01,abc02,abc03,abc04,abclegal)         #No.FUN-740218  #FUN-980003 add abclegal
             VALUES (l_ahc.ahc00,l_aba01,l_ahc.ahc02,l_ahc.ahc03,l_ahc.ahc04,g_legal)          #No.FUN-740218 #FUN-980003 add g_legal
           END FOREACH
           IF g_bgjob = 'N' THEN         #FUN-570145
               DISPLAY l_aha.aha01 TO FORMONLY.no
       	       DISPLAY l_aba01 TO FORMONLY.vou
       	       DISPLAY l_cnt TO FORMONLY.page
           END IF
      	   #傳票單身的複製
       	   DECLARE copy_cs4 CURSOR WITH HOLD FOR 
            SELECT * FROM ahb_file WHERE ahb00 = tm.bookno AND  #No.FUN-740065
                                        ahb000 = l_aha.aha000 AND
                                         ahb01 = l_aha.aha01 
                                        ORDER BY  ahb02
       	   FOREACH copy_cs4 INTO l_ahb.*
           IF SQLCA.sqlcode THEN  
           LET g_showmsg=tm.bookno,"/",l_aha.aha01  #No.FUN-740065
           CALL s_errmsg('ahb00,ahb01',g_showmsg,'select *',SQLCA.sqlcode,0) 
           LET g_success = 'N'
           EXIT FOREACH
           END IF  
    	      INSERT INTO abb_file(abb00,abb01,abb02,abb03,abb04,abb05,  #No.MOD-470041
                                   abb06,abb07f,abb07,abb08,abb11,abb12,
                                   abb13,abb14,
                                   abb31,abb32,abb33,abb34,abb35,abb36,abb37,#FUN-5C0015 BY GILL
                                   abb24,abb25,abblegal)                      #FUN-810069 #FUN-980003 add abblegal
	           VALUES(tm.bookno,l_aba01,l_ahb.ahb02,l_ahb.ahb03,l_ahb.ahb04,  #No.FUN-740065
                          l_ahb.ahb05,l_ahb.ahb06,l_ahb.ahb07,l_ahb.ahb07,
                          l_ahb.ahb08,l_ahb.ahb11,l_ahb.ahb12,l_ahb.ahb13,
                          l_ahb.ahb14,
 
                          l_ahb.ahb31,l_ahb.ahb32,l_ahb.ahb33,l_ahb.ahb34,
                          l_ahb.ahb35,l_ahb.ahb36,l_ahb.ahb37,
                          g_aaa.aaa03,1,g_legal)                          #FUN-810069 #FUN-980003 add g_legal
               IF g_bgjob = 'N 'THEN            #FUN-570145
                   DISPLAY l_ahb.ahb02 TO FORMONLY.seq   #No.MOD-480210
               END IF
      	   END FOREACH
           CALL s_flows('2',tm.bookno,l_aba01,tm.date_1,'N','',TRUE)   #No.TQC-B70021  
        END IF
     	IF l_aha.aha000 = '2' THEN #固定比率
           CALL copy_fp('') 
           IF g_bgjob = 'N' THEN            #FUN-570145
               DISPLAY l_cnt TO FORMONLY.page   #MOD-530433
           END IF
     	END IF
     	IF l_aha.aha000 = '3' THEN #變動比率
           CALL copy_vp('') 
           IF g_bgjob = 'N' THEN  
               DISPLAY l_cnt TO FORMONLY.page   
           END IF
     	END IF
      END IF
     	#更新'上次產生日期'---->常用傳票(固定金額)檔
     	UPDATE aha_file SET aha04 = tm.date_1 WHERE aha00 = tm.bookno AND   #No.FUN-740065
                                               aha01 = l_aha.aha01 AND
                                               aha000= l_aha.aha000
     	#CALL s_azm(l_azn02,l_azn04) RETURNING l_flag,l_bdate,l_edate #CHI-A70007 mark
        #CHI-A70007 add --start--
        IF g_aza.aza63 = 'Y' THEN
           CALL s_azmm(l_azn02,l_azn04,g_plant,tm.bookno) RETURNING l_flag,l_bdate,l_edate
        ELSE
     	   CALL s_azm(l_azn02,l_azn04) RETURNING l_flag,l_bdate,l_edate
        END IF
        #CHI-A70007 add --end--
     	IF l_ans MATCHES '[yY]' THEN #要自動過帳
           CALL aglp102_post(tm.bookno,tm.date_1,tm.date_1,l_aba01,l_aba01,'N','1=1')           #No.FUN-920155
           #請再check roger 因為若為已過帳期別時應刪除巳產生的月結傳票
           CALL s_eom(tm.bookno,l_bdate,l_edate,l_azn02,l_azn04,'N')  #No.FUN-740065
            IF g_aza.aza26<>'2' THEN #No.MOD-490294 -begin
               CALL cl_confirm('agl-181') RETURNING g_chr #No.MOD-490294
               IF g_chr = '1' THEN  #No.MOD-510064
                 WHILE tm.y1 > l_azn02 
                       #No.FUN-AB0068  --Begin                                  
                       #CALL s_eoy(tm.bookno,l_azn02)  #No.FUN-740065           
                       CALL s_eoy(tm.bookno,l_azn02,'N')                        
                       #No.FUN-AB0068  --End 
                       CALL cl_err('','agl-034',1) 
               	       LET l_azn02 = l_azn02 + 1
                 END WHILE
              END IF
            END IF #No.MOD-490294 -end
     	END IF
       #No.FUN-CB0096 ---start--- Add
        LET l_time = TIME
        LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
        CALL s_log_data('I','104',g_id,'2',l_time,l_aba.aba01,'')
       #No.FUN-CB0096 ---end  --- Add
     END FOREACH
     IF g_totsuccess="N" THEN                                                        
        LET g_success="N"                                                           
     END IF                                                                          
     IF g_success = 'Y' THEN
         IF l_cnt = 0 THEN   #MOD-530433
            CALL cl_err('','axc-034',0) #COMMIT WORK   #MOD-530433   #MOD-7B0215
         ELSE   #MOD-530433
           CALL cl_cmmsg(1) #COMMIT WORK   #MOD-7B0215
         END IF   #MOD-530433
     ELSE 
        CALL cl_rbmsg(1) #ROLLBACK WORK   #MOD-7B0215
     END IF
     CALL cl_end(13,20)
 
   CLOSE WINDOW copy_g_w
END FUNCTION
#固定比率
FUNCTION copy_fp(p_aba01)
DEFINE  li_result     LIKE type_file.num5   #No.FUN-560060        #No.FUN-680098 smallint
DEFINE  l_total  LIKE aah_file.aah04,
        p_aba01  LIKE aba_file.aba01,
        l_uaba01 LIKE aba_file.aba01,                            #CHI-B50049
        l_tal    LIKE type_file.num20_6,                         #No.FUN-680098  decimal(20,6)   
        l_deb    LIKE ahb_file.ahb07,                            #No.FUN-680098  DECIMAL(20,6)  
        l_crd    LIKE ahb_file.ahb07,                            #No.FUN-680098  DECIMAL(20,6)                  
        l_ahb    RECORD LIKE ahb_file.*,
        l_abb07  LIKE abb_file.abb07,
        l_modabb07  LIKE abb_file.abb07,                         #CHI-B50049
        l_sumabb07_d  LIKE abb_file.abb07,                       #CHI-B50049
        l_sumabb07_c  LIKE abb_file.abb07,                       #CHI-B50049
        l_aba08  LIKE aba_file.aba08,
        l_aba09  LIKE aba_file.aba09,
        l_seq    LIKE type_file.num5,                               #No.FUN-680098    SMALLINT 
        l_cnt1_t,l_cnt2_t LIKE type_file.num5,                      #No.FUN-680098    SMALLINT 
        l_cnt1,l_cnt2,l_cnt3,l_cnt4   LIKE type_file.num5,          #No.FUN-680098    SMALLINT
        r_total1,r_total2  LIKE type_file.num20_6,  #No.FUN-4C0009  #No.FUN-680098    DECIMAL(20,6)
        l_abb07_t1 LIKE abb_file.abb07,
        l_abb07_t2 LIKE abb_file.abb07
DEFINE  l_ahb07  LIKE ahb_file.ahb07   #CHI-680026
DEFINE  l_cnt    LIKE type_file.num5   #CHI-680026
DEFINE  l_amt    LIKE abb_file.abb07
DEFINE  l_ahd03  LIKE ahd_file.ahd03
DEFINE  l_ahd04  LIKE ahd_file.ahd04
 
     CALL ahd_amt() RETURNING l_total  #金額來源科目的計算
     LET l_ahb07 = 0
     SELECT SUM(ahb07) INTO l_ahb07 FROM ahb_file
       WHERE ahb00=tm.bookno AND ahb000=l_aha.aha000 AND ahb01=l_aha.aha01 AND  #No.FUN-740065
             ahb06='2' AND
             ahb03 NOT IN (SELECT ahd03 FROM ahd_file
                             WHERE ahd00 = tm.bookno AND  #No.FUN-740065
                                   ahd000 = l_aha.aha000 AND
                                   ahd01 = l_aha.aha01)
     IF cl_null(l_ahb07) THEN LET l_ahb07=0 END IF   #MOD-770132 
     LET l_total = l_total + l_total*l_ahb07/100
     IF l_aha.aha13 = '2' THEN LET l_total = l_total * -1 END IF
     IF l_total > 0
        THEN LET r_total1 = l_total
             LET r_total1 = cl_digcut(r_total1,g_digit)
             LET r_total2 = l_total
             LET r_total2 = cl_digcut(r_total2,g_digit)
        ELSE LET r_total1 = l_total * -1
             LET r_total1 = cl_digcut(r_total1,g_digit)
             LET r_total2 = l_total * -1
             LET r_total2 = cl_digcut(r_total2,g_digit)
     END IF
     #一般傳票單頭的複製
     #來源碼一律為'FP'
     #輸入日期一律為TODAY,並更新'上次產生日期'為今天的日期
     WHILE TRUE 
        IF g_ans MATCHES '[Yy]' THEN
           IF l_aac.aacauno = 'Y' THEN
              #No.FUN-CB0096 ---start--- Add
               LET t_no = Null
               CALL s_log_check(l_aha.aha01) RETURNING t_no
               IF NOT cl_null(t_no) THEN
                  LET l_aba01 = t_no
                  LET li_result = '1'
               ELSE
              #No.FUN-CB0096 ---end  --- Add
               CALL s_auto_assign_no("agl",l_aha.aha07,tm.date_1,"","","",g_plant,"",tm.bookno)  #No.FUN-740065 #FUN-980094
                 RETURNING li_result,l_aba01                                         
               END IF   #No.FUN-CB0096   Add
               IF (NOT li_result) THEN                                                   
                   LET g_success = 'N'
                   EXIT WHILE
               END IF                                                                    
           END IF
        
          LET g_t1 = s_get_doc_no(l_aba01)
          SELECT aac08 INTO l_aba.abamksg FROM aac_file WHERE aac01=g_t1
          IF cl_null(l_aba.abamksg) THEN
             LET l_aba.abamksg = 'N'
          END IF
 
            INSERT INTO aba_file(aba00,aba01,aba02,aba03,aba04,aba05,   #No.MOD-470041
                                aba06,aba07,aba08,aba09,aba10,aba11,
                                aba12,aba13,aba14,aba15,aba16,aba17,
                                aba18,aba19,aba20,aba21,aba22,aba23,
                                 abamksg,abasign,abadays,abaprit,abasmax, #No.MOD-480210
                                abasseq,abaprno,abapost,abaacti,abauser,
                                abagrup,abamodu,abadate,aba24,abalegal,abaoriu,abaorig)     #MOD-640204 #FUN-980003 add abalegal
                VALUES (tm.bookno,l_aba01,tm.date_1,l_azn02,l_azn04,  #No.FUN-740065
                         g_today,'FP',l_aha.aha01,r_total1,r_total2,
                         #for 大陸版
                         '','','N',0,'','','','','0','N','0','','','', #NO:7572 aba19 default 'N'  #MOD-9C0270
                         l_aba.abamksg,l_aha.ahasign,0,0,0,0,0,'N',   #aba20 default '0'  #MOD-640204
                        'Y',g_user,g_grup,' ',g_today,g_user,g_legal, g_user, g_grup)  #MOD-640204 #FUN-980003 add g_legal      #No.FUN-980030 10/01/04  insert columns oriu, orig
           IF SQLCA.sqlcode THEN 
              LET g_showmsg=tm.bookno,"/",l_aba01  #No.FUN-740065
              CALL s_errmsg('aba00,aba01',g_showmsg,'ckp#3:fp',SQLCA.sqlcode,1)
              LET g_success = 'N'
              EXIT WHILE
           END IF
           LET l_uaba01 = l_aba01   #CHI-B50049 
        END IF
        IF g_ans MATCHES '[Nn]' THEN
           UPDATE aba_file SET aba02 = tm.date_1,
                               aba03 = l_azn02,
                               aba04 = l_azn04,
                               aba05 = g_today,
                               aba06 = 'FP',
                               aba07 = l_aha.aha01,
                               aba08 = r_total1,   
                               aba09 = r_total2    
            WHERE aba00 = tm.bookno  AND aba01 = p_aba01  #No.FUN-740065
           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN 
              LET g_showmsg=tm.bookno,"/",p_aba01  #No.FUN-740065
              CALL s_errmsg('aba00,aba01',g_showmsg,'ckp#t1:FA',SQLCA.sqlcode,1)
              LET g_success = 'N'
              EXIT WHILE  
           END IF
           LET l_uaba01 = p_aba01   #CHI-B50049 
        END IF
        EXIT WHILE
     END WHILE
     IF g_bgjob = 'N' THEN            #FUN-570145 
        DISPLAY l_aha.aha01 TO FORMONLY.no
        DISPLAY l_aba01 TO FORMONLY.vou
     END IF
 
     #傳票單身的複製
     SELECT SUM(ahb07),COUNT(*) INTO l_deb,l_cnt1 FROM ahb_file#計算借方比率總合
      WHERE ahb00 = tm.bookno      #No.FUN-740065
        AND ahb000= l_aha.aha000
        AND ahb01 = l_aha.aha01
        AND ahb06 = '1' 
     IF SQLCA.sqlcode OR l_deb IS NULL THEN LET l_deb = 0 END IF
     SELECT SUM(ahb07),COUNT(*) INTO l_crd,l_cnt2 FROM ahb_file#計算貸方比率總合
                       WHERE ahb00 = tm.bookno AND  #No.FUN-740065
                             ahb000 = l_aha.aha000 AND 
                             ahb01 = l_aha.aha01 AND 
                             ahb06 = '2' 
     IF SQLCA.sqlcode OR l_crd IS NULL THEN LET l_crd = 0 END IF
     LET l_cnt3 = l_cnt1
     LET l_cnt4 = l_cnt2
     IF l_total < 0 THEN LET l_cnt1 = l_cnt4 LET l_cnt2 = l_cnt3 END IF
     LET l_abb07_t1 = 0
     LET l_abb07_t2 = 0
     LET l_cnt1_t = 1
     LET l_cnt2_t = 1
     LET l_seq    = 0
     LET l_sumabb07_d = 0    #CHI-B50049
     LET l_sumabb07_c = 0    #CHI-B50049
     LET g_sql = "SELECT * FROM ahb_file WHERE ahb00 = '",tm.bookno,"' AND",  #No.FUN-740065
                 " ahb000= '",l_aha.aha000,"' AND ahb01 = '",l_aha.aha01,"'"
     IF l_total > 0
	    THEN LET g_sql = g_sql CLIPPED," ORDER BY ahb06,ahb02"
	    ELSE LET g_sql = g_sql CLIPPED," ORDER BY ahb06 desc,ahb02"
     END IF
     PREPARE copy_p3 FROM g_sql
     DECLARE copy_cs3 CURSOR WITH HOLD FOR copy_p3
 
     FOREACH copy_cs3 INTO l_ahb.*
        IF SQLCA.sqlcode THEN LET g_success = 'N' 
        LET g_showmsg=tm.bookno,"/",l_aha.aha000,"/",l_aha.aha01                                   #No.FUN-740065
        CALL s_errmsg('ahb00,ahb000,ahb01',g_showmsg,'select *',SQLCA.sqlcode,0)   
        EXIT FOREACH
        END IF
        IF l_total < 0 THEN
           IF l_ahb.ahb06 = '1'
              THEN LET l_ahb.ahb06 = '2'
              ELSE LET l_ahb.ahb06 = '1'
           END IF
        END IF
        LET l_modabb07 = 0   #CHI-B50049 
        IF l_ahb.ahb06 = '1' THEN
           IF l_cnt1_t = l_cnt1 THEN #最後一筆借方資料
              LET r_total1 = r_total1 + l_sumabb07_d    #CHI-B50049
              LET l_abb07 = r_total1 - l_abb07_t1
             #-CHI-B50049-add-
              IF l_abb07 < 0 THEN
                 IF l_ahb.ahb06 = '1' THEN
                    LET l_ahb.ahb06 = '2'
                 ELSE 
                    LET l_ahb.ahb06 = '1'
                 END IF
                 LET l_abb07 = l_abb07 * -1
              END IF
             #-CHI-B50049-end-
           ELSE
              LET l_abb07 = r_total1 * (l_ahb.ahb07/l_deb) #本項次的金額借方   #CHI-680026
              LET l_abb07 = cl_digcut(l_abb07,g_digit)
             #-CHI-B50049-add-
              IF l_abb07 < 0 THEN
                 IF l_ahb.ahb06 = '1' THEN
                    LET l_ahb.ahb06 = '2'
                 ELSE 
                    LET l_ahb.ahb06 = '1'
                 END IF
                 LET l_abb07 = l_abb07 * -1
                 LET l_modabb07 = l_modabb07 + l_abb07 
                 LET l_sumabb07_d = l_sumabb07_d + l_abb07 
              END IF
              IF l_modabb07 > 0 THEN    
                 LET l_abb07 = 0       
              END IF          
             #-CHI-B50049-end-
              LET l_abb07_t1 = l_abb07_t1 + l_abb07
              LET l_cnt1_t = l_cnt1_t + 1
           END IF
        ELSE
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt FROM ahd_file
             WHERE ahd00 = tm.bookno AND  #No.FUN-740065
                   ahd000 = l_aha.aha000 AND
                   ahd01 = l_aha.aha01 AND
                   ahd03 = l_ahb.ahb03
           IF l_cnt > 0 THEN
              DECLARE p710_cs3 CURSOR FOR
              SELECT ahd03,ahd04 FROM ahd_file
                WHERE ahd00 = tm.bookno
                  AND ahd000 = l_aha.aha000 
                  AND ahd01 = l_aha.aha01 
                  AND ahd03 = l_ahb.ahb03 
              LET l_abb07 =0
              LET l_amt   =0
              FOREACH p710_cs3 INTO l_ahd03,l_ahd04    
                CALL ahd_amt2(l_ahd03,l_ahd04) RETURNING l_amt
                LET l_abb07 =l_abb07+l_amt
              END FOREACH
              IF l_cnt2_t = l_cnt2 THEN #最後一筆貸方資料
                 LET r_total2 = r_total2 + l_sumabb07_c    #CHI-B50049
                 LET l_abb07 = r_total2 - l_abb07_t2
                #-CHI-B50049-add-
                 IF l_abb07 < 0 THEN
                    IF l_ahb.ahb06 = '1' THEN
                       LET l_ahb.ahb06 = '2'
                    ELSE 
                       LET l_ahb.ahb06 = '1'
                    END IF
                    LET l_abb07 = l_abb07 * -1
                 END IF
                #-CHI-B50049-end-
              ELSE
                 LET l_abb07 = (r_total2*100/(100+l_ahb07)) * (l_ahb.ahb07/100) #本項次的金額貸方    #CHI-680026
                 LET l_abb07 = cl_digcut(l_abb07,g_digit)
                #-CHI-B50049-add-
                 IF l_abb07 < 0 THEN
                    IF l_ahb.ahb06 = '1' THEN
                       LET l_ahb.ahb06 = '2'
                    ELSE 
                       LET l_ahb.ahb06 = '1'
                    END IF
                    LET l_abb07 = l_abb07 * -1
                    LET l_modabb07 = l_modabb07 + l_abb07 
                    LET l_sumabb07_c = l_sumabb07_c + l_abb07 
                 END IF
                 IF l_modabb07 > 0 THEN    
                    LET l_abb07 = 0       
                 END IF          
                #-CHI-B50049-end-
                 LET l_abb07_t2 = l_abb07_t2 + l_abb07
                 LET l_cnt2_t = l_cnt2_t + 1
              END IF
           ELSE
              IF l_cnt2_t = l_cnt2 THEN #最後一筆貸方資料
                 LET r_total2 = r_total2 + l_sumabb07_c    #CHI-B50049
                 LET l_abb07 = r_total2 - l_abb07_t2
                #-CHI-B50049-add-
                 IF l_abb07 < 0 THEN
                    IF l_ahb.ahb06 = '1' THEN
                       LET l_ahb.ahb06 = '2'
                    ELSE 
                       LET l_ahb.ahb06 = '1'
                    END IF
                    LET l_abb07 = l_abb07 * -1
                 END IF
                #-CHI-B50049-end-
              ELSE
                 LET l_abb07 = (r_total2*100/(100+l_ahb07)) * (l_ahb.ahb07/100) #本項次的金額貸方    #CHI-680026
                 LET l_abb07 = cl_digcut(l_abb07,g_digit)
                #-CHI-B50049-add-
                 IF l_abb07 < 0 THEN
                    IF l_ahb.ahb06 = '1' THEN
                       LET l_ahb.ahb06 = '2'
                    ELSE 
                       LET l_ahb.ahb06 = '1'
                    END IF
                    LET l_abb07 = l_abb07 * -1
                    LET l_modabb07 = l_modabb07 + l_abb07 
                    LET l_sumabb07_c = l_sumabb07_c + l_abb07 
                 END IF
                 IF l_modabb07 > 0 THEN    
                    LET l_abb07 = 0       
                 END IF          
                #-CHI-B50049-end-
                 LET l_abb07_t2 = l_abb07_t2 + l_abb07
                 LET l_cnt2_t = l_cnt2_t + 1
              END IF
           END IF   #CHI-680026
        END IF
        LET l_seq = l_seq + 1
        IF g_ans MATCHES '[Yy]' THEN
       	INSERT INTO abb_file(abb00,abb01,abb02,abb03,abb04,abb05,  #No.MOD-470041
                                abb06,abb07f,abb07,abb08,abb11,abb12,
                                abb13,abb14,
                                abb31,abb32,abb33,abb34,abb35,abb36,abb37,#FUN-5C0015 BY GILL
                                abb24,abb25,abblegal)                       #FUN-810069 #FUN-980003 add abblegal
                VALUES(tm.bookno,l_aba01,l_seq,l_ahb.ahb03,l_ahb.ahb04,  #No.FUN-740065
                       l_ahb.ahb05,l_ahb.ahb06,l_abb07,l_abb07,l_ahb.ahb08,
                       l_ahb.ahb11,l_ahb.ahb12,l_ahb.ahb13,l_ahb.ahb14,
       
                       l_ahb.ahb31,l_ahb.ahb32,l_ahb.ahb33,l_ahb.ahb34,
                       l_ahb.ahb35,l_ahb.ahb36,l_ahb.ahb37,
       
                       g_aaa.aaa03,1,g_legal)                               #FUN-810069 #FUN-980003 add g_legal
        END IF
        IF g_ans MATCHES '[Nn]' THEN
           UPDATE abb_file SET abb03 = l_ahb.ahb03,
                               abb04 = l_ahb.ahb04,
                               abb05 = l_ahb.ahb05,
                               abb06 = l_ahb.ahb06,
                               abb07 = l_abb07,    
                               abb08 = l_ahb.ahb08,
                               abb11 = l_ahb.ahb11,
                               abb12 = l_ahb.ahb12,
                               abb13 = l_ahb.ahb13,
                               abb14 = l_ahb.ahb14,
       
                               abb31 = l_ahb.ahb31,
                               abb32 = l_ahb.ahb32,
                               abb33 = l_ahb.ahb33,
                               abb34 = l_ahb.ahb34,
                               abb35 = l_ahb.ahb35,
                               abb36 = l_ahb.ahb36,
                               abb37 = l_ahb.ahb37        #FUN-810069
       
            WHERE abb00 = tm.bookno  #No.FUN-740065
              AND abb01 = p_aba01
              AND abb02 = l_seq      
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
               LET g_showmsg=tm.bookno,"/",p_aba01,"/",l_seq                                     #NO.FUN-710023    #No.FUN-740065
               CALL s_errmsg('abb00,abb01,abb02',g_showmsg,'ckp#t2:FA',SQLCA.sqlcode,1)         #NO.FUN-710023   
               LET g_success = 'N'
               EXIT FOREACH
            END IF
        END IF
        IF g_bgjob = 'N' THEN            #FUN-570145
           DISPLAY l_ahb.ahb02 TO FORMONLY.seq
        END IF
     END FOREACH
     CALL s_flows('2',tm.bookno,p_aba01,tm.date_1,'N','',TRUE)   #No.TQC-B70021
    #-CHI-B50049-add-
     LET r_total1 = 0
     SELECT SUM(abb07) INTO r_total1 
       FROM abb_file
      WHERE abb00 = tm.bookno   
        AND abb01 = l_uaba01
        AND abb06 = '1' 
     IF cl_null(r_total1) THEN LET r_total1 = 0 END IF

     LET r_total2 = 0
     SELECT SUM(abb07) INTO r_total2
       FROM abb_file
      WHERE abb00 = tm.bookno   
        AND abb01 = l_uaba01
        AND abb06 = '2' 
     IF cl_null(r_total2) THEN LET r_total2 = 0 END IF

     UPDATE aba_file SET aba08 = r_total1,aba09 = r_total2
      WHERE aba00 = tm.bookno
        AND aba01 = l_uaba01
     IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
        LET g_showmsg=tm.bookno,"/",l_uaba01
        CALL s_errmsg('abb00,abb01,abb02',g_showmsg,'ckp#t3:FA',SQLCA.sqlcode,1)
        LET g_success = 'N'
     END IF
    #-CHI-B50049-end-
     IF g_ans MATCHES '[Yy]' THEN
        IF g_bgjob = 'N' THEN            #FUN-570145
           DISPLAY l_aha.aha01 TO FORMONLY.no
           DISPLAY l_aba01 TO FORMONLY.vou
           DISPLAY l_seq TO FORMONLY.seq
        END IF
     END IF
 
END FUNCTION
 
#變動比率
FUNCTION copy_vp(p_aba01)
DEFINE li_result   LIKE type_file.num5   #No.FUN-560060        #No.FUN-680098 SMALLINT
DEFINE l_total     LIKE aah_file.aah04,
       p_aba01     LIKE aba_file.aba01,
       l_uaba01    LIKE aba_file.aba01,                            #CHI-B50049
       l_tol1      LIKE aah_file.aah04,
       l_tol2      LIKE aah_file.aah04,
       l_total1    LIKE aah_file.aah04,
       l_total2    LIKE aah_file.aah04,
       l_tal       LIKE type_file.num20_6,                      #No.FUN-680098  DECIMAL(20,6)   
       l_deb       LIKE ahb_file.ahb07,                         #No.FUN-680098  DECIMAL(20,6)   
       l_crd       LIKE ahb_file.ahb07,                         #No.FUN-680098  DECIMAL(20,6)   
       l_ahb       RECORD LIKE ahb_file.*,
       l_aba       RECORD LIKE aba_file.*,
       l_abb07     LIKE abb_file.abb07,
       l_modabb07  LIKE abb_file.abb07,                         #CHI-B50049
       l_sumabb07_d  LIKE abb_file.abb07,                       #CHI-B50049
       l_sumabb07_c  LIKE abb_file.abb07,                       #CHI-B50049
       l_aba08     LIKE aba_file.aba08,
       l_aba09     LIKE aba_file.aba09,
       l_aag04     LIKE aag_file.aag04,
       l_seq       LIKE type_file.num5,                            #No.FUN-680098    SMALLINT 
       l_cnt1_t,l_cnt2_t  LIKE type_file.num5,                     #No.FUN-680098    SMALLINT 
       l_cnt1,l_cnt2,l_cnt3,l_cnt4   LIKE type_file.num5,          #No.FUN-680098 SMALLINT
       r_total1,r_total2  LIKE type_file.num20_6,  #No.FUN-4C0009  #No.FUN-680098 DECIMAL(20,6)    
       l_abb07_t1  LIKE abb_file.abb07,
       l_abb07_t2  LIKE abb_file.abb07,
       m_cnt1      LIKE type_file.num5,   #CHI-890005 add
       m_cnt2      LIKE type_file.num5    #CHI-890005 add
 
   CALL ahd_amt() RETURNING l_total  #金額來源科目的計算
   IF l_aha.aha13 = '2' THEN LET l_total = l_total * -1 END IF
   IF l_total > 0
      THEN LET r_total1 = l_total    LET r_total2 = l_total
           LET r_total1 = cl_digcut(r_total1,g_digit)
           LET r_total2 = cl_digcut(r_total2,g_digit)
      ELSE LET r_total1 = l_total*-1 LET r_total2 = l_total*-1
           LET r_total1 = cl_digcut(r_total1,g_digit)
           LET r_total2 = cl_digcut(r_total2,g_digit)
   END IF
   WHILE TRUE 
      IF g_ans MATCHES '[Yy]' THEN
         IF l_aac.aacauno = 'Y' THEN
           #No.FUN-CB0096 ---start--- Add
            CALL s_log_check(l_aha.aha01) RETURNING l_aba01
            IF NOT cl_null(l_aba01) THEN
               LET li_result = '1'
            ELSE
           #No.FUN-CB0096 ---end  --- Add
            CALL s_auto_assign_no("agl",l_aha.aha07,tm.date_1,"","","",g_plant,"",tm.bookno)  #No.FUN-740065 #FUN-980094
                 RETURNING li_result,l_aba01                                         
            END IF   #No.FUN-CB0096   Add
            IF (NOT li_result) THEN                                                   
               LET g_success = 'N'
               EXIT WHILE
            END IF                                                                    
     	 END IF
         LET l_aba.aba00=tm.bookno  #No.FUN-740065
         LET l_aba.aba01=l_aba01
         LET l_aba.aba02=tm.date_1
         LET l_aba.aba03=l_azn02
         LET l_aba.aba04=l_azn04
         LET l_aba.aba05=g_today
         LET l_aba.aba06='VP'
         LET l_aba.aba07=l_aha.aha01
         LET l_aba.aba08=r_total1
         LET l_aba.aba09=r_total2
         LET l_aba.aba19='N'    #NO:7572
         LET l_aba.aba20='0'    #NO:7572 
         LET l_aba.aba18='0'    #MOD-9C0270
         LET l_aba.abapost='N'
 
         LET g_t1 = s_get_doc_no(l_aba.aba01)
         SELECT aac08 INTO l_aba.abamksg FROM aac_file WHERE aac01=g_t1
         IF cl_null(l_aba.abamksg) THEN
            LET l_aba.abamksg = 'N'
         END IF
         LET l_aba.aba24 = g_user
 
         LET l_aba.abasign=l_aha.ahasign
         LET l_aba.abaprno=0
         LET l_aba.abaacti='Y'
         LET l_aba.abauser=g_user
         LET l_aba.abagrup=g_grup
         LET l_aba.abadate=g_today
         LET l_aba.abalegal=g_legal #FUN-980003 add g_legal
         LET l_aba.abaoriu = g_user      #No.FUN-980030 10/01/04
         LET l_aba.abaorig = g_grup      #No.FUN-980030 10/01/04
         INSERT INTO aba_file VALUES (l_aba.*)
         IF SQLCA.sqlcode THEN 
            LET g_showmsg=tm.bookno,"/",l_aba01                                  #NO.FUN-710023  #No.FUN-740065
            CALL s_errmsg('aba00,aba01',g_showmsg,'ckp#4:fp',SQLCA.sqlcode,1)   #NO.FUN-710023           
            LET g_success = 'N'
            EXIT WHILE
         END IF
         LET l_uaba01 = l_aba01   #CHI-B50049 
      END IF   #CHI-B50049 
      IF g_ans MATCHES '[Nn]' THEN
         UPDATE aba_file SET aba02 = tm.date_1,
                             aba03 = l_azn02,
                             aba04 = l_azn04,
                             aba05 = g_today,
                             aba06 = 'VP',
                             aba07 = l_aha.aha01,
                             aba08 = r_total1,   
                             aba09 = r_total2    
          WHERE aba00 = tm.bookno  AND aba01 = p_aba01  #No.FUN-740065
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN 
            LET g_showmsg=tm.bookno,"/",p_aba01                                               #NO.FUN-710023     #No.FUN-740065
            CALL s_errmsg('aba00,aba01',g_showmsg,'ckp#t1:FA',SQLCA.sqlcode,1)               #NO.FUN-710023    
            LET g_success = 'N'
            EXIT WHILE  
         END IF
         LET l_uaba01 = p_aba01   #CHI-B50049 
      END IF
     #END IF   #CHI-B50049 mark
      EXIT WHILE
   END WHILE
   IF g_bgjob = 'N' THEN            #FUN-570145
      DISPLAY l_aha.aha01 TO FORMONLY.no
      DISPLAY l_aba01 TO FORMONLY.vou
   END IF
   #處理變動比率，利用本科目的科目餘額檔(aah_file)註:不抓取預算檔...注意
   #金額匯總再除以單身各項次的金額作為比率
   #計算借方筆數，因為在用比率計算時會有誤差故計算時才差額算在借方、貸方的最後
   #一筆
   SELECT COUNT(*) INTO l_cnt1 FROM ahb_file
    WHERE ahb00 = tm.bookno AND  #No.FUN-740065
          ahb000 = l_aha.aha000 AND
          ahb01 = l_aha.aha01 AND 
          ahb06 = '1'
   IF SQLCA.sqlcode OR l_cnt1 IS NULL THEN LET l_cnt1 = 0 END IF
   SELECT COUNT(*) INTO l_cnt2 FROM ahb_file
    WHERE ahb00 = tm.bookno AND  #No.FUN-740065
          ahb000 = l_aha.aha000 AND
          ahb01 = l_aha.aha01 AND 
          ahb06 = '2'
   IF SQLCA.sqlcode OR l_cnt2 IS NULL THEN LET l_cnt2 = 0 END IF
   LET l_cnt3 = l_cnt1
   LET l_cnt4 = l_cnt2
   IF l_total < 0 THEN LET l_cnt1 = l_cnt4 LET l_cnt2 = l_cnt3 END IF
   LET l_total1 = 0   #計算借方比率的金額的加總
   LET l_total2 = 0   #計算貸方比率的金額的加總
   LET l_tol1 = 0   LET l_tol2 = 0   LET l_seq = 0
 
  #計算來源科目是否皆為貸餘科目
   LET m_cnt1 = 0   LET m_cnt2 = 0
   SELECT COUNT(*) INTO m_cnt1 FROM ahd_file
    WHERE ahd00 = tm.bookno
      AND ahd000= l_aha.aha000
      AND ahd01 = l_aha.aha01
   IF cl_null(m_cnt1) THEN LET m_cnt1 = 0 END IF
   SELECT COUNT(*) INTO m_cnt2 FROM ahd_file,aag_file
    WHERE ahd00 = tm.bookno
      AND ahd000= l_aha.aha000
      AND ahd01 = l_aha.aha01
      AND ahd00 = aag00
      AND ahd03 = aag01
      AND aag06 = '2'
   IF cl_null(m_cnt2) THEN LET m_cnt2 = 0 END IF
 
   LET g_sql = "SELECT * FROM ahb_file WHERE ahb00 = '",tm.bookno,"' AND",  #No.FUN-740065
               " ahb000= '",l_aha.aha000,"' AND ahb01 = '",l_aha.aha01,"'"
   IF l_total > 0
      THEN LET g_sql = g_sql CLIPPED," ORDER BY ahb06,ahb02"
      ELSE LET g_sql = g_sql CLIPPED," ORDER BY ahb06 desc,ahb02"
   END IF
   PREPARE copy_vp_p2 FROM g_sql
   DECLARE copy_vp_cs2 CURSOR WITH HOLD FOR copy_vp_p2
 
   FOREACH copy_vp_cs2 INTO l_ahb.*
     IF SQLCA.sqlcode THEN EXIT FOREACH END IF 
   
     IF l_total < 0 THEN
        IF l_ahb.ahb06 = '1'
           THEN LET l_ahb.ahb06 = '2'
           ELSE LET l_ahb.ahb06 = '1'
        END IF
     END IF
     IF l_ahb.ahb06 = '1' THEN  #借方(若無變動科目則讓其值等於1)
        IF l_ahb.ahb16 IS NULL OR l_ahb.ahb16 = ' ' THEN 
           LET l_tol1 = 1 
        ELSE 
           SELECT aag04 INTO l_aag04 FROM aag_file
            WHERE aag01 = l_ahb.ahb16
              AND aag00 = tm.bookno  #No.FUN-740065
           IF SQLCA.sqlcode OR l_aag04 IS NULL THEN 
              LET l_aag04 = ' ' 
              CALL s_errmsg('aag01',l_ahb.ahb16,l_ahb.ahb16,'agl-027',1)    #NO.FUN-710023    
              EXIT FOREACH
           END IF
           IF l_ahb.ahb05 IS NOT NULL THEN
              IF l_aag04 = '1' THEN  #資產類   
                 SELECT SUM(aao05-aao06) INTO l_tol1 FROM aao_file 
                  WHERE aao00 = tm.bookno AND  #No.FUN-740065
                        aao01 = l_ahb.ahb16 AND
                        aao02 = l_ahb.ahb05 AND 
                        aao03 = tm.y2 AND
                        aao04 <= tm.m2
              ELSE  #損益類
                 SELECT SUM(aao05-aao06) INTO l_tol1 FROM aao_file 
                  WHERE aao00 = tm.bookno AND  #No.FUN-740065
                        aao01 = l_ahb.ahb16 AND
                        aao02 = l_ahb.ahb05 AND 
                        aao03 = tm.y2 AND
                        aao04 = tm.m2
              END IF
           ELSE
              IF l_aag04 = '1' THEN  #資產類   
                 SELECT SUM(aah04-aah05) INTO l_tol1 FROM aah_file 
                  WHERE aah00 = tm.bookno AND  #No.FUN-740065
                        aah01 = l_ahb.ahb16 AND
                        aah02 = tm.y2 AND
                        aah03 <= tm.m2
              ELSE  #損益類
                 SELECT SUM(aah04-aah05) INTO l_tol1 FROM aah_file 
                  WHERE aah00 = tm.bookno AND  #No.FUN-740065
                        aah01 = l_ahb.ahb16 AND
                        aah02 = tm.y2 AND
                        aah03 = tm.m2
              END IF
           END IF
           IF SQLCA.sqlcode OR l_tol1 IS NULL THEN LET l_tol1 = 0 END IF	
        END IF
        LET l_total1 = l_tol1 + l_total1
     END IF
     IF l_ahb.ahb06 = '2' THEN  #借方(若無變動科目則讓其值等於1)
        IF l_ahb.ahb16 IS NULL OR l_ahb.ahb16 = ' ' THEN 
           LET l_tol2 = 1 
        ELSE 
           SELECT aag04 INTO l_aag04 FROM aag_file
            WHERE aag01 = l_ahb.ahb16
              AND aag00 = tm.bookno  #No.FUN-740065
           IF l_ahb.ahb05 IS NOT NULL THEN
              IF l_aag04 = '1' THEN  #資產類   
                 SELECT SUM(aao05-aao06) INTO l_tol2 FROM aao_file 
                  WHERE aao00 = tm.bookno AND  #No.FUN-740065
                        aao01 = l_ahb.ahb16 AND
                        aao02 = l_ahb.ahb05 AND 
                        aao03 = tm.y2 AND
                        aao04 <= tm.m2
              ELSE  #損益類
                 SELECT SUM(aao05-aao06) INTO l_tol2 FROM aao_file 
                  WHERE aao00 = tm.bookno AND  #No.FUN-740065
                        aao01 = l_ahb.ahb16 AND
                        aao02 = l_ahb.ahb05 AND 
                        aao03 = tm.y2 AND
                        aao04 = tm.m2
              END IF
           ELSE
              IF l_aag04 = '1' THEN  #資產類   
                 SELECT SUM(aah04-aah05) INTO l_tol2 FROM aah_file 
                  WHERE aah00 = tm.bookno AND  #No.FUN-740065
                        aah01 = l_ahb.ahb16 AND
                        aah02 = tm.y2 AND
                        aah03 <= tm.m2
              ELSE  #損益類
                 SELECT SUM(aah04-aah05) INTO l_tol2 FROM aah_file 
                  WHERE aah00 = tm.bookno AND  #No.FUN-740065
                        aah01 = l_ahb.ahb16 AND
                        aah02 = tm.y2 AND
                        aah03 = tm.m2
              END IF
           END IF
           IF SQLCA.sqlcode OR l_tol1 IS NULL THEN LET l_tol1 = 0 END IF	
        END IF
        LET l_total2 = l_tol2 + l_total2
     END IF
   END FOREACH
   ####以上是在抓取借方、貸方的比率金額合計
   # 以下才利用下面所抓取的總金額除以各項次的金額得到比率再乘上金額來源l_total
   LET l_abb07_t1 = 0
   LET l_abb07_t2 = 0
   LET l_tol1 = 0
   LET l_tol2 = 0
   LET l_cnt1_t = 1
   LET l_cnt2_t = 1
   LET l_sumabb07_d = 0    #CHI-B50049
   LET l_sumabb07_c = 0    #CHI-B50049
   FOREACH copy_vp_cs2 INTO l_ahb.*
     IF SQLCA.sqlcode THEN EXIT FOREACH END IF
     IF l_total < 0 THEN
        IF l_ahb.ahb06 = '1'
           THEN LET l_ahb.ahb06 = '2'
           ELSE LET l_ahb.ahb06 = '1'
        END IF
     END IF
     IF l_ahb.ahb06 = '1' THEN #借方
        IF l_cnt1_t = l_cnt1 THEN    #若為借方的最後一筆時
           LET r_total1 = r_total1 + l_sumabb07_d    #CHI-B50049
           LET l_abb07_t1 = r_total1 - l_abb07_t1
           #來源科目全為貸餘科目,將借貸方反轉
           IF m_cnt1>0 AND m_cnt1=m_cnt2 THEN
              IF l_ahb.ahb06 = '1'
                 THEN LET l_ahb.ahb06 = '2'
                 ELSE LET l_ahb.ahb06 = '1'
              END IF
           END IF
          #-CHI-B50049-add-
           IF l_abb07_t1 < 0 THEN
              IF l_ahb.ahb06 = '1' THEN
                 LET l_ahb.ahb06 = '2'
              ELSE 
                 LET l_ahb.ahb06 = '1'
              END IF
              LET l_abb07_t1 = l_abb07_t1 * -1
           END IF
          #-CHI-B50049-end-
           IF g_ans MATCHES '[Yy]' THEN
              LET l_seq = l_seq + 1    #No.MOD-840527
    	      INSERT INTO abb_file(abb00,abb01,abb02,abb03,abb04,abb05,  #No.MOD-470041
                                   abb06,abb07f,abb07,abb08,abb11,abb12,
                                   abb13,abb14,
                                   abb31,abb32,abb33,abb34,abb35,abb36,abb37,#FUN-5C0015 BY GILL
                                   abb24,abb25,abblegal)                 #FUN-810069 #FUN-980003 add abblegal
                   VALUES(tm.bookno,l_aba01,l_ahb.ahb02,l_ahb.ahb03,l_ahb.ahb04,  #No.FUN-740065
                          l_ahb.ahb05,l_ahb.ahb06,l_abb07_t1,l_abb07_t1,
                          l_ahb.ahb08,l_ahb.ahb11,l_ahb.ahb12,l_ahb.ahb13,
                          l_ahb.ahb14,
 
                          l_ahb.ahb31,l_ahb.ahb32,l_ahb.ahb33,l_ahb.ahb34,
                          l_ahb.ahb35,l_ahb.ahb36,l_ahb.ahb37,
 
                          g_aaa.aaa03,1,g_legal)                          #FUN-810069 #FUN-980003 add g_legal
           END IF
           IF g_ans MATCHES '[Nn]' THEN
              UPDATE abb_file SET abb03 = l_ahb.ahb03,
                                  abb04 = l_ahb.ahb04,
                                  abb05 = l_ahb.ahb05,
                                  abb06 = l_ahb.ahb06,
                                  abb07 = l_abb07_t1,    
                                  abb08 = l_ahb.ahb08,
                                  abb11 = l_ahb.ahb11,
                                  abb12 = l_ahb.ahb12,
                                  abb13 = l_ahb.ahb13,
                                  abb14 = l_ahb.ahb14,
 
                                  abb31 = l_ahb.ahb31,
                                  abb32 = l_ahb.ahb32,
                                  abb33 = l_ahb.ahb33,
                                  abb34 = l_ahb.ahb34,
                                  abb35 = l_ahb.ahb35,
                                  abb36 = l_ahb.ahb36,
                                  abb37 = l_ahb.ahb37                  #FUN-810069
                       
               WHERE abb00 = tm.bookno  #No.FUN-740065
                 AND abb01 = p_aba01
                 AND abb02 = l_ahb.ahb02
           END IF
           #將借貸方反轉回來
           IF m_cnt1>0 AND m_cnt1=m_cnt2 THEN
              IF l_ahb.ahb06 = '1'
                 THEN LET l_ahb.ahb06 = '2'
                 ELSE LET l_ahb.ahb06 = '1'
              END IF
           END IF
        ELSE
           IF l_ahb.ahb16 IS NULL OR l_ahb.ahb16 = ' ' THEN 
              LET l_tol2 = 1 
           ELSE 
              SELECT aag04 INTO l_aag04 FROM aag_file
               WHERE aag01 = l_ahb.ahb16
                 AND aag00 = tm.bookno  #No.FUN-740065
              IF SQLCA.sqlcode OR l_aag04 IS NULL THEN 
                 LET l_aag04 = ' ' 
                 CALL s_errmsg('aag01',l_ahb.ahb16,l_ahb.ahb16,'agl-027',1)      #NO.FUN-710023                 
                 LET g_success = 'N'                     
                 EXIT FOREACH 
              END IF
              IF l_ahb.ahb05 IS NOT NULL THEN
                 IF l_aag04 = '1' THEN  #資產類   
                    SELECT SUM(aao05-aao06) INTO l_tol1 FROM aao_file 
                     WHERE aao00 = tm.bookno AND  #No.FUN-740065
                           aao01 = l_ahb.ahb16 AND
                           aao02 = l_ahb.ahb05 AND 
                           aao03 = tm.y2 AND
                           aao04 <= tm.m2
                 ELSE  #損益類
                    SELECT SUM(aao05-aao06) INTO l_tol1 FROM aao_file 
                     WHERE aao00 = tm.bookno AND  #No.FUN-740065
                           aao01 = l_ahb.ahb16 AND
                           aao02 = l_ahb.ahb05 AND 
                           aao03 = tm.y2 AND
                           aao04 = tm.m2
                 END IF
              ELSE
                 IF l_aag04 = '1' THEN  #資產類   
                    SELECT SUM(aah04 - aah05) INTO l_tol1 FROM aah_file 
                     WHERE aah00 = tm.bookno AND  #No.FUN-740065
                           aah01 = l_ahb.ahb16 AND
                           aah02 = tm.y2 AND
                           aah03 <= tm.m2
                 ELSE  #損益類
                    SELECT SUM(aah04 - aah05) INTO l_tol1 FROM aah_file 
                     WHERE aah00 = tm.bookno AND  #No.FUN-740065
                           aah01 = l_ahb.ahb16 AND
                           aah02 = tm.y2 AND
                           aah03 = tm.m2
                 END IF
              END IF
              IF l_tol1 IS NULL THEN LET l_tol1 = 0 END IF
           END IF
           IF l_tol1 = 0 OR l_tol1 IS NULL THEN LET l_tol1 = 0 END IF   #MOD-930280
           IF l_tol1 = 0 THEN   #金額為0時該筆不需分攤
              LET l_cnt1 = l_cnt1 - 1
              CONTINUE FOREACH
           END IF
           IF l_total1 = 0 THEN 
              LET l_abb07=0
           ELSE 
              LET l_abb07 = r_total1 * l_tol1/l_total1
              LET l_abb07 = cl_digcut(l_abb07,g_digit)
           END IF
           #來源科目全為貸餘科目,將借貸方反轉
           IF m_cnt1>0 AND m_cnt1=m_cnt2 THEN
              IF l_ahb.ahb06 = '1'
                 THEN LET l_ahb.ahb06 = '2'
                 ELSE LET l_ahb.ahb06 = '1'
              END IF
           END IF
          #-CHI-B50049-add-
           LET l_modabb07 = 0 
           IF l_abb07 < 0 THEN
              IF l_ahb.ahb06 = '1' THEN
                 LET l_ahb.ahb06 = '2'
              ELSE 
                 LET l_ahb.ahb06 = '1'
              END IF
              LET l_abb07 = l_abb07 * -1
              LET l_modabb07 = l_abb07 
              LET l_sumabb07_d = l_sumabb07_d + l_abb07 
           END IF
          #-CHI-B50049-end-
           IF g_ans MATCHES '[Yy]' THEN
              LET l_seq = l_seq + 1    #No.MOD-840527
              INSERT INTO abb_file(abb00,abb01,abb02,abb03,abb04,abb05,  #No.MOD-470041
                                   abb06,abb07f,abb07,abb08,abb11,abb12,
                                   abb13,abb14,
                                   abb31,abb32,abb33,abb34,abb35,abb36,abb37,#FUN-5C0015 BY GILL
                                   abb24,abb25,abblegal)                    #FUN-810069 #FUN-980003 add abblegal
                  VALUES(tm.bookno,l_aba01,l_ahb.ahb02,l_ahb.ahb03,l_ahb.ahb04,  #No.FUN-740065
                         l_ahb.ahb05,l_ahb.ahb06,l_abb07,l_abb07,l_ahb.ahb08,
                         l_ahb.ahb11,l_ahb.ahb12,l_ahb.ahb13,l_ahb.ahb14,
 
                         l_ahb.ahb31,l_ahb.ahb32,l_ahb.ahb33,l_ahb.ahb34,
                         l_ahb.ahb35,l_ahb.ahb36,l_ahb.ahb37,
 
                         g_aaa.aaa03,1,g_legal)                        #FUN-810069 #FUN-980003 add g_legal
           END IF
           IF g_ans MATCHES '[Nn]' THEN
              UPDATE abb_file SET abb03 = l_ahb.ahb03,
                                  abb04 = l_ahb.ahb04,
                                  abb05 = l_ahb.ahb05,
                                  abb06 = l_ahb.ahb06,
                                  abb07 = l_abb07,    
                                  abb08 = l_ahb.ahb08,
                                  abb11 = l_ahb.ahb11,
                                  abb12 = l_ahb.ahb12,
                                  abb13 = l_ahb.ahb13,
                                  abb14 = l_ahb.ahb14,
             
                                  abb31 = l_ahb.ahb31,
                                  abb32 = l_ahb.ahb32,
                                  abb33 = l_ahb.ahb33,
                                  abb34 = l_ahb.ahb34,
                                  abb35 = l_ahb.ahb35,
                                  abb36 = l_ahb.ahb36,
                                  abb37 = l_ahb.ahb37              #FUN-810069
 
               WHERE abb00 = tm.bookno  #No.FUN-740065
                 AND abb01 = p_aba01
                 AND abb02 = l_ahb.ahb02
               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                  LET g_showmsg=tm.bookno,"/",p_aba01,"/",l_ahb.ahb02  #No.FUN-740065
                  CALL s_errmsg('abb00,abb01,abb02',g_showmsg,'ckp#t2:FA',SQLCA.sqlcode,1)
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
           END IF
           #將借貸方反轉回來
           IF m_cnt1>0 AND m_cnt1=m_cnt2 THEN
              IF l_ahb.ahb06 = '1'
                 THEN LET l_ahb.ahb06 = '2'
                 ELSE LET l_ahb.ahb06 = '1'
              END IF
           END IF
           IF l_modabb07 > 0 THEN     #CHI-B50049
              LET l_abb07 = 0         #CHI-B50049
           END IF                     #CHI-B50049
           LET l_abb07_t1 = l_abb07 + l_abb07_t1
        END IF
        LET l_cnt1_t = l_cnt1_t + 1   
     END IF
     IF l_ahb.ahb06 = '2' THEN #貸方
        IF l_cnt2 = l_cnt2_t THEN
           LET r_total2 = r_total2 + l_sumabb07_c    #CHI-B50049
           LET l_abb07_t2 = r_total2 - l_abb07_t2
           #來源科目全為貸餘科目,將借貸方反轉
           IF m_cnt1>0 AND m_cnt1=m_cnt2 THEN
              IF l_ahb.ahb06 = '1'
                 THEN LET l_ahb.ahb06 = '2'
                 ELSE LET l_ahb.ahb06 = '1'
              END IF
           END IF
          #-CHI-B50049-add-
           IF l_abb07_t2 < 0 THEN
              IF l_ahb.ahb06 = '1' THEN
                 LET l_ahb.ahb06 = '2'
              ELSE 
                 LET l_ahb.ahb06 = '1'
              END IF
              LET l_abb07_t2 = l_abb07_t2 * -1
           END IF
          #-CHI-B50049-end-
           IF g_ans MATCHES '[Yy]' THEN
              LET l_seq = l_seq + 1    #No.MOD-840527
    	      INSERT INTO abb_file(abb00,abb01,abb02,abb03,abb04,abb05,  #No.MOD-470041
                                   abb06,abb07f,abb07,abb08,abb11,abb12,
                                   abb13,abb14,
                                   abb31,abb32,abb33,abb34,abb35,abb36,abb37,#FUN-5C0015 BY GILL
                                   abb24,abb25,abblegal)                 #FUN-810069 #FUN-980003 add abblegal
                   VALUES(tm.bookno,l_aba01,l_ahb.ahb02,l_ahb.ahb03,l_ahb.ahb04,  #No.FUN-740065
                          l_ahb.ahb05,l_ahb.ahb06,l_abb07_t2,l_abb07_t2,
                          l_ahb.ahb08,l_ahb.ahb11,l_ahb.ahb12,l_ahb.ahb13,
                          l_ahb.ahb14,
 
                          l_ahb.ahb31,l_ahb.ahb32,l_ahb.ahb33,l_ahb.ahb34,
                          l_ahb.ahb35,l_ahb.ahb36,l_ahb.ahb37,
 
                          g_aaa.aaa03,1,g_legal)                  #FUN-810069 #FUN-980003 add g_legal
           END IF
           IF g_ans MATCHES '[Nn]' THEN
              UPDATE abb_file SET abb03 = l_ahb.ahb03,
                                  abb04 = l_ahb.ahb04,
                                  abb05 = l_ahb.ahb05,
                                  abb06 = l_ahb.ahb06,
                                  abb07 = l_abb07_t2,    
                                  abb08 = l_ahb.ahb08,
                                  abb11 = l_ahb.ahb11,
                                  abb12 = l_ahb.ahb12,
                                  abb13 = l_ahb.ahb13,
                                  abb14 = l_ahb.ahb14,
    
                                  abb31 = l_ahb.ahb31,
                                  abb32 = l_ahb.ahb32,
                                  abb33 = l_ahb.ahb33,
                                  abb34 = l_ahb.ahb34,
                                  abb35 = l_ahb.ahb35,
                                  abb36 = l_ahb.ahb36,
                                  abb37 = l_ahb.ahb37       #FUN-810069
 
               WHERE abb00 = tm.bookno  #No.FUN-740065
                 AND abb01 = p_aba01
                 AND abb02 = l_ahb.ahb02
              IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                 LET g_showmsg=tm.bookno,"/",p_aba01,"/",l_ahb.ahb02                               #NO.FUN-710023  #No.FUN-740065
                 CALL s_errmsg('abb00,abb01,abb02',g_showmsg,'ckp#t2:FA',SQLCA.sqlcode,1)         #NO.FUN-710023    
                 LET g_success = 'N'
                 EXIT FOREACH
              END IF
              #將借貸方反轉回來
              IF m_cnt1>0 AND m_cnt1=m_cnt2 THEN
                 IF l_ahb.ahb06 = '1'
                    THEN LET l_ahb.ahb06 = '2'
                    ELSE LET l_ahb.ahb06 = '1'
                 END IF
              END IF
           END IF
        ELSE
           IF l_ahb.ahb16 IS NULL OR l_ahb.ahb16 = ' ' THEN 
              LET l_tol2 = 1 
           ELSE 
              SELECT aag04 INTO l_aag04 FROM aag_file
               WHERE aag01 = l_ahb.ahb16
                 AND aag00 = tm.bookno  #No.FUN-740065
              IF SQLCA.sqlcode OR l_aag04 IS NULL THEN 
                 LET l_aag04 = ' ' 
                 CALL cl_err3("sel","aag_file",l_ahb.ahb16,"","agl-027","","",1)   #No.FUN-660123
                 EXIT FOREACH
              END IF
              IF l_ahb.ahb05 IS NOT NULL THEN
              IF l_aag04 = '1' THEN  #資產類   
                 SELECT SUM(aao05-aao06) INTO l_tol2 FROM aao_file 
                  WHERE aao00 = tm.bookno AND  #No.FUN-740065
                        aao01 = l_ahb.ahb16 AND
                        aao02 = l_ahb.ahb05 AND 
                        aao03 = tm.y2 AND
                        aao04 <= tm.m2
              ELSE  #損益類
                 SELECT SUM(aao05-aao06) INTO l_tol2 FROM aao_file 
                  WHERE aao00 = tm.bookno AND  #No.FUN-740065
                        aao01 = l_ahb.ahb16 AND
                        aao02 = l_ahb.ahb05 AND 
                        aao03 = tm.y2 AND
                        aao04 = tm.m2
              END IF
              ELSE
              IF l_aag04 = '1' THEN  #資產類   
                 SELECT SUM(aah04 - aah05) INTO l_tol2 FROM aah_file 
                  WHERE aah00 = tm.bookno AND  #No.FUN-740065
                        aah01 = l_ahb.ahb16 AND
                        aah02 = tm.y2 AND
                        aah03 <= tm.m2
              ELSE  #損益類
                 SELECT SUM(aah04 - aah05) INTO l_tol2 FROM aah_file 
                  WHERE aah00 = tm.bookno AND  #No.FUN-740065
                        aah01 = l_ahb.ahb16 AND
                        aah02 = tm.y2 AND
                        aah03 = tm.m2
              END IF
              END IF
              IF l_tol2 IS NULL THEN LET l_tol2 = 0 END IF
           END IF
           IF l_tol2 = 0 OR l_tol2 IS NULL THEN LET l_tol2 = 0 END IF   #MOD-930280
           IF l_tol2 = 0 THEN   #金額為0時該筆不需分攤
              LET l_cnt2 = l_cnt2 - 1
              CONTINUE FOREACH
           END IF
           IF l_total2 = 0 THEN 
              LET l_abb07=0
           ELSE 
              LET l_abb07 = r_total2 * l_tol2/l_total2
              LET l_abb07 = cl_digcut(l_abb07,g_digit)
           END IF
           #來源科目全為貸餘科目,將借貸方反轉
           IF m_cnt1>0 AND m_cnt1=m_cnt2 THEN
              IF l_ahb.ahb06 = '1'
                 THEN LET l_ahb.ahb06 = '2'
                 ELSE LET l_ahb.ahb06 = '1'
              END IF
           END IF
          #-CHI-B50049-add-
           LET l_modabb07 = 0 
           IF l_abb07 < 0 THEN
              IF l_ahb.ahb06 = '1' THEN
                 LET l_ahb.ahb06 = '2'
              ELSE 
                 LET l_ahb.ahb06 = '1'
              END IF
              LET l_abb07 = l_abb07 * -1
              LET l_modabb07 = l_abb07 
              LET l_sumabb07_c = l_sumabb07_c + l_abb07 
           END IF
          #-CHI-B50049-end-
           IF g_ans MATCHES '[Yy]' THEN
              LET l_seq = l_seq + 1    #No.MOD-840527
              INSERT INTO abb_file(abb00,abb01,abb02,abb03,abb04,abb05,  #No.MOD-470041
                                   abb06,abb07f,abb07,abb08,abb11,abb12,
                                   abb13,abb14,
                                   abb31,abb32,abb33,abb34,abb35,abb36,abb37,#FUN-5C0015 BY GILL
                                   abb24,abb25,abblegal)               #FUN-810069 #FUN-980003 add abblegal
                   VALUES(tm.bookno,l_aba01,l_ahb.ahb02,l_ahb.ahb03,l_ahb.ahb04,  #No.FUN-740065
                          l_ahb.ahb05,l_ahb.ahb06,l_abb07,l_abb07,l_ahb.ahb08,
                          l_ahb.ahb11,l_ahb.ahb12,l_ahb.ahb13,l_ahb.ahb14,
 
                          l_ahb.ahb31,l_ahb.ahb32,l_ahb.ahb33,l_ahb.ahb34,
                          l_ahb.ahb35,l_ahb.ahb36,l_ahb.ahb37,
 
                          g_aaa.aaa03,1,g_legal)               #FUN-810069 #FUN-980003 add g_legal
           END IF
           IF g_ans MATCHES '[Nn]' THEN
              UPDATE abb_file SET abb03 = l_ahb.ahb03,
                                  abb04 = l_ahb.ahb04,
                                  abb05 = l_ahb.ahb05,
                                  abb06 = l_ahb.ahb06,
                                  abb07 = l_abb07,    
                                  abb08 = l_ahb.ahb08,
                                  abb11 = l_ahb.ahb11,
                                  abb12 = l_ahb.ahb12,
                                  abb13 = l_ahb.ahb13,
                                  abb14 = l_ahb.ahb14,
 
                                  abb31 = l_ahb.ahb31,
                                  abb32 = l_ahb.ahb32,
                                  abb33 = l_ahb.ahb33,
                                  abb34 = l_ahb.ahb34,
                                  abb35 = l_ahb.ahb35,
                                  abb36 = l_ahb.ahb36,
                                  abb37 = l_ahb.ahb37     #FUN-810069
 
               WHERE abb00 = tm.bookno  #No.FUN-740065
                 AND abb01 = p_aba01
                 AND abb02 = l_ahb.ahb02
              IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                 LET g_showmsg=tm.bookno,"/",p_aba01,"/",l_ahb.ahb02                               #NO.FUN-710023  #No.FUN-740065
                 CALL s_errmsg('abb00,abb01,abb02',g_showmsg,'ckp#t2:FA',SQLCA.sqlcode,1)         #NO.FUN-710023 
                 LET g_success = 'N'
                 EXIT FOREACH
              END IF
           END IF
           #將借貸方反轉回來
           IF m_cnt1>0 AND m_cnt1=m_cnt2 THEN
              IF l_ahb.ahb06 = '1'
                 THEN LET l_ahb.ahb06 = '2'
                 ELSE LET l_ahb.ahb06 = '1'
              END IF
           END IF
           IF l_modabb07 > 0 THEN     #CHI-B50049
              LET l_abb07 = 0         #CHI-B50049
           END IF                     #CHI-B50049
           LET l_abb07_t2 = l_abb07 + l_abb07_t2
        END IF
        LET l_cnt2_t = l_cnt2_t + 1   #MOD-930280  
     END IF
     IF g_bgjob = 'N' THEN   
        DISPLAY l_ahb.ahb02 TO FORMONLY.seq
     END IF
   END FOREACH
#No.TQC-B70021 --begin 
   IF g_ans  MATCHES '[Yy]' THEN  
      CALL s_flows('2',tm.bookno,l_aba01,tm.date_1,'N','',TRUE)   #No.TQC-B70021
   END IF 
#No.TQC-B70021 --end
  #-CHI-B50049-add-
   LET r_total1 = 0
   SELECT SUM(abb07) INTO r_total1 
     FROM abb_file
    WHERE abb00 = tm.bookno   
      AND abb01 = l_uaba01
      AND abb06 = '1' 
   IF cl_null(r_total1) THEN LET r_total1 = 0 END IF

   LET r_total2 = 0
   SELECT SUM(abb07) INTO r_total2
     FROM abb_file
    WHERE abb00 = tm.bookno   
      AND abb01 = l_uaba01
      AND abb06 = '2' 
   IF cl_null(r_total2) THEN LET r_total2 = 0 END IF

   UPDATE aba_file SET aba08 = r_total1,aba09 = r_total2
    WHERE aba00 = tm.bookno
      AND aba01 = l_uaba01
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      LET g_showmsg=tm.bookno,"/",l_uaba01
      CALL s_errmsg('abb00,abb01,abb02',g_showmsg,'ckp#t3:FA',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
  #-CHI-B50049-end-
   IF g_ans MATCHES '[Yy]' THEN
      IF g_bgjob = 'N' THEN      
         DISPLAY l_aha.aha01 TO FORMONLY.no
         DISPLAY l_aba01 TO FORMONLY.vou
         DISPLAY l_seq TO FORMONLY.seq
      END IF
   END IF
END FUNCTION
 
#金額來源科目的金額計算
FUNCTION ahd_amt()
  DEFINE l_total  LIKE aah_file.aah04,
         l_aahtal LIKE aah_file.aah04,
         l_ahd    RECORD LIKE ahd_file.*,
         l_aag06  LIKE aag_file.aag06   #借餘或貸餘
 
   #作比率科目的加總
   DECLARE p710_cs2 CURSOR FOR 
      SELECT ahd_file.* FROM ahd_file 
       WHERE ahd00 = tm.bookno AND      #No.FUN-740065
             ahd000 = l_aha.aha000 AND
             ahd01 = l_aha.aha01 
   LET l_total = 0
   #以比率科目計算出票面金額--->抓取ahd_file的會計科目
   FOREACH p710_cs2 INTO l_ahd.*
     IF SQLCA.sqlcode THEN EXIT FOREACH END IF
     #餘額來源分(aha08)兩種1:實際科目餘額2:固定預算
     #第一部分:科目餘額的處理
     #####################################################
     #加總時必需分1:累計餘額2:本期異動 兩部份            # 
     #累計餘額:由期初額開始作加總,將每期本科目的餘額累計 #
     #本期異動:將每期本科目的餘額累計                        #
     #####################################################
     IF l_aha.aha08 = '1' THEN  #實際科目餘額
        IF l_aha.aha10 = '1' THEN #累計餘額由本年度期初(第０期)開始計算
           IF l_ahd.ahd04 IS NULL
              THEN SELECT SUM(aah04-aah05) INTO l_aahtal FROM aah_file 
                    WHERE aah00 = tm.bookno  #No.FUN-740065
                      AND aah01 = l_ahd.ahd03
                      AND aah02 = tm.y2 AND aah03 <= tm.m2
              ELSE SELECT SUM(aao05-aao06) INTO l_aahtal FROM aao_file 
                    WHERE aao00 = tm.bookno  #No.FUN-740065
                      AND aao01 = l_ahd.ahd03 AND aao02 = l_ahd.ahd04
                      AND aao03 = tm.y2 AND aao04 <= tm.m2
           END IF
           IF SQLCA.sqlcode OR l_aahtal IS NULL THEN LET l_aahtal = 0 END IF
        END IF
        IF l_aha.aha10 = '2' THEN #本期異動
           IF l_ahd.ahd04 IS NULL
              THEN SELECT SUM(aah04-aah05) INTO l_aahtal FROM aah_file 
                    WHERE aah00 = tm.bookno  #No.FUN-740065
                      AND aah01 = l_ahd.ahd03
                      AND aah02 = tm.y2 AND aah03 = tm.m2
              ELSE SELECT SUM(aao05-aao06) INTO l_aahtal FROM aao_file 
                    WHERE aao00 = tm.bookno  #No.FUN-740065
                      AND aao01 = l_ahd.ahd03 AND aao02 = l_ahd.ahd04
                      AND aao03 = tm.y2 AND aao04 = tm.m2
           END IF
           IF SQLCA.sqlcode OR l_aahtal IS NULL THEN LET l_aahtal = 0 END IF
        END IF
     END IF
     IF l_aha.aha08 = '2' THEN #固定預算由afc_file直接抓取各期預算(afc06)
        IF cl_null(l_ahd.ahd04) OR l_ahd.ahd04 = ' ' THEN   #科目預算
           SELECT afc06 INTO l_aahtal FROM afc_file 		#不考慮遞延預算
            WHERE afc00 = tm.bookno AND   #No.FUN-740065
                  afc02 = l_ahd.ahd03 AND
                  afc04 = '@'   AND
                  afc03 = tm.y2 AND 
                  afc05 = tm.m2
        ELSE   
           SELECT afc06 INTO l_aahtal FROM afc_file 		#不考慮遞延預算
            WHERE afc00 = tm.bookno AND   #No.FUN-740065
                  afc02 = l_ahd.ahd03 AND
                  afc04 = l_ahd.ahd04 AND
                  afc03 = tm.y2 AND 
                  afc05 = tm.m2
        END IF
        IF SQLCA.sqlcode  OR l_aahtal IS NULL THEN LET l_aahtal = 0 END IF
     END IF
     LET l_total = l_total + l_aahtal  #票面金額
   END FOREACH
   RETURN l_total
END FUNCTION
 
#金額來源科目的金額計算
FUNCTION ahd_amt2(l_ahd03,l_ahd04)
  DEFINE l_aahtal LIKE aah_file.aah04,
         l_ahd03  LIKE ahd_file.ahd03,
         l_ahd04  LIKE ahd_file.ahd04
 
   #以比率科目計算出票面金額--->抓取ahd_file的會計科目
   #餘額來源分(aha08)兩種1:實際科目餘額2:固定預算
   #第一部分:科目餘額的處理
   #####################################################
   #加總時必需分1:累計餘額2:本期異動 兩部份            #
   #累計餘額:由期初額開始作加總,將每期本科目的餘額累計 #
   #本期異動:將每期本科目的餘額累計                    #
   #####################################################
   IF l_aha.aha08 = '1' THEN  #實際科目餘額
      IF l_aha.aha10 = '1' THEN #累計餘額由本年度期初(第０期)開始計算
         IF l_ahd04 IS NULL
            THEN SELECT SUM(aah04-aah05) INTO l_aahtal FROM aah_file
                  WHERE aah00 = tm.bookno  #No.FUN-740065
                    AND aah01 = l_ahd03
                    AND aah02 = tm.y2 AND aah03 <= tm.m2
            ELSE SELECT SUM(aao05-aao06) INTO l_aahtal FROM aao_file
                  WHERE aao00 = tm.bookno  #No.FUN-740065
                    AND aao01 = l_ahd03 AND aao02 = l_ahd04
                    AND aao03 = tm.y2 AND aao04 <= tm.m2
         END IF
         IF SQLCA.sqlcode OR l_aahtal IS NULL THEN LET l_aahtal = 0 END IF
      END IF
      IF l_aha.aha10 = '2' THEN #本期異動
         IF l_ahd04 IS NULL
            THEN SELECT SUM(aah04-aah05) INTO l_aahtal FROM aah_file
                  WHERE aah00 = tm.bookno  #No.FUN-740065
                    AND aah01 = l_ahd03
                    AND aah02 = tm.y2 AND aah03 = tm.m2
            ELSE SELECT SUM(aao05-aao06) INTO l_aahtal FROM aao_file
                  WHERE aao00 = tm.bookno  #No.FUN-740065
                    AND aao01 = l_ahd03 AND aao02 = l_ahd04
                    AND aao03 = tm.y2 AND aao04 = tm.m2
         END IF
         IF SQLCA.sqlcode OR l_aahtal IS NULL THEN LET l_aahtal = 0 END IF
      END IF
   END IF
   IF l_aha.aha08 = '2' THEN #固定預算由afc_file直接抓取各期預算(afc06)
      IF cl_null(l_ahd04) OR l_ahd04 = ' ' THEN   #科目預算
         SELECT afc06 INTO l_aahtal FROM afc_file             #不考慮遞延預算
          WHERE afc00 = tm.bookno AND  #No.FUN-740065
                afc02 = l_ahd03 AND
                afc04 = '@'   AND
                afc03 = tm.y2 AND
                afc05 = tm.m2
      ELSE
         SELECT afc06 INTO l_aahtal FROM afc_file             #不考慮遞延預算
          WHERE afc00 = tm.bookno AND  #No.FUN-740065
                afc02 = l_ahd03 AND
                afc04 = l_ahd04 AND
                afc03 = tm.y2 AND
                afc05 = tm.m2
      END IF
      IF SQLCA.sqlcode  OR l_aahtal IS NULL THEN LET l_aahtal = 0 END IF
   END IF
   RETURN l_aahtal
END FUNCTION
#No.FUN-9C0072 精簡程式碼
