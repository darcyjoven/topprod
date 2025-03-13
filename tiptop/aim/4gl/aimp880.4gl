# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aimp880.4gl
# Descriptions...: 盤點過帳作業
# Date & Author..: 93/06/15 By Apple
# NOTE...........: 目前尚未處理領料系統的在製工單盤點
# 1993/12/06(Apple):盤盈虧(異動數量)不再有負值狀況因此,會計科目,來源狀況
#                   目的狀況皆依據盤盈虧有所變動
# Modify.........: NO.MOD-490217 04/09/10 by yiting 料號欄位放大
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式
# Modify.........: No.FUN-560183 05/06/22 By kim 移除ima86成本單位
# Modify.........: No.FUN-570082 05/07/18 By Carrier 多單位現有庫存盤點
# Modify.........: NO.FUN-5C0001 05/12/22 BY yiting 加上是否顯示執行過程選項及cl_progress_bar()
# Modify.........: No.FUN-5A0199 05/12/29 By Sarah 標籤編號放大至16碼
# Modify.........: No.MOD-610134 06/01/23 By Pengu 939行中的g_tlf.tlf12應恆等應恆等於1，因為tlf12是異動數量單位與異動目的數量單位轉換率
                                     #             但pia10是此標籤單位與料件庫存單位的轉換率兩者不應該相等 
# Modify.........: No.FUN-570122 06/02/20 BY Yiting 背景執行
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: No.TQC-660091 06/06/20 By Elva tlf025=pia07->tlf025=pia09
# Modify.........: NO.FUN-660156 06/06/22 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-670093 06/07/27 By kim GP3.5 利潤中心
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.CHI-6A0032 06/11/08 By rainy 過帳只update工單盤盈虧數量, 程式中原本的其它段落的update均取消
# Modify.........: No.TQC-6C0153 06/12/26 By Ray 語言功能無效
# Modify.........: No.TQC-740198 07/04/22 By Ray 光標放在“盤點過賬日期”上時，按確定按鈕，退出本程序。
# Modify.........: No.FUN-760040 07/06/13 By kim MSV環境必須移除ROWID,p880_prepare3需select 出sfa01,sfa03,sfa08,sfa12 出來給後面的UPDATE sfa_file使用
# Modify.........: No.MOD-7B0105 07/11/13 By Pengu 若pia04,pia05 儲佔或批號為null值時,應增加判斷給予一個空白
# Modify.........: No.FUN-870051 08/07/16 By sherry 增加被替代料(sfa27)為Key
# Modify.........: No.MOD-8A0063 08/10/08 By claire 先做CONSTRUCT 再做INPUT 輸入順序
# Modify.........: No.FUN-8A0147 08/12/10 By douzh 批序號-盤點調整參數傳入邏輯
# Modify.........: No.FUN-8C0084 08/12/22 By jan s_upimg相關改以 料倉儲批為參數傳入 ,不使用 ROWID 
# Modify.........: No.MOD-8C0294 09/01/04 By sherry 料件作廢盤點可以過賬 
# Modify.........: No.CHI-910008 09/01/17 By jan 是否check ime_file Y要考慮sma42='3' 的設定
# Modify.........: No.MOD-930040 09/03/04 By chenyu LET g_success = 'Y'應該拿到FOREACH外面
# Modify.........: No.TQC-930155 09/03/30 By Sunyanchun Lock img_file,imgg_file時，若報錯，不要rollback ，要放g_success ='N'
# Modify.........: No.FUN-980004 09/08/06 By TSD.Ken GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.MOD-980095 09/08/22 By mike 刪除多余FROM   
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0011 09/11/03 By liuxqa 调整语法。
# Modify.........: No:MOD-9B0040 09/11/09 By Smapmin 過帳日不可小於等於關帳日
# Modify.........: No.FUN-9C0072 10/01/15 By vealxu 精簡程式碼
# Modify.........: No.FUN-A20044 10/03/23 By vealxu ima26x 調整
# Modify.........: No.FUN-A60027 10/06/07 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No:MOD-A70062 10/07/08 By Sarah 調整TRANSACTION語法(BEGIN/COMMIT/ROLLBACK WORK)的位置
# Modify.........: No.FUN-A60095 10/07/19 By kim GP5.25 平行工藝
# Modify.........: No.FUN-B40082 11/05/12 By jason 盤盈時產生雜收單(+發料單) 盤虧時產生雜發單+退料單
# Modify.........: No.TQC-B60302 11/06/23 By jan 產生發料單前應判斷發料數量>0才產生
# Modify.........: No:FUN-B70074 11/07/20 By fengrui 添加行業別表的新增於刪除(sfsi_file by lixh1)
# Modify.........: No:FUN-B70032 11/08/16 By jason 新增ICD刻號/BIN盤點過帳
# Modify.........: No.FUN-B80119 11/09/14 By fengrui  增加調用s_icdpost的p_plant參數
# Modify.........: No:FUN-BB0083 11/12/12 By xujing 增加數量欄位小數取位
# Modify.........: No.FUN-BB0085 11/12/12 By xianghui 增加數量欄位小數取位
# Modify.........: No.FUN-BB0084 11/12/13 By lixh1 增加數量欄位小數取位(sfs_file)
# Modify.........: No.CHI-C10036 12/01/16 By bart tlfs15給一個空白
# Modify.........: No.TQC-C40079 12/04/13 By xianghui 給t370sub_y_chk()增加第三個參數
# Modify.........: No.TQC-C60079 12/06/11 By fengrui 函數i501sub_y_chk添加參數
# Modify.........: No.MOD-C70062 12/07/09 By Sakura 取替代時應考慮替代率
# Modify.........: No:MOD-C70091 12/07/11 By ck2yuan 當空白標籤新增資料時,過帳需update imgg
# Modify.........: No:FUN-C70014 12/07/16 By suncx 新增sfs014
# Modify.........: No.TQC-C80011 12/08/01 By fengrui 處理無法開啟問題
# Modify.........: No:MOD-CA0151 12/10/29 By Elise 若是空白標籤，則需計算盤點單與倉庫單位之間的轉換率
# Modify.........: No:FUN-CB0087 12/12/07 By qiull 庫存單據理由碼改善 12/12/20 By fengrui 倉庫單據理由碼改善
# Modify.........: No:MOD-CC0207 13/01/11 By Elise 過帳時檢核第一二組數量不可不一致
# Modify.........: No:CHI-C80015 13/03/05 By Alberti 選擇繼續執行後,則不清空上次輸入的值
# Modify.........: No:MOD-D30051 13/03/07 By bart 1.INSERT INTO imgs_file改寫2.LET l_imgs.imgs08 = l_qty2
# Modify.........: No:MOD-C80038 13/03/15 By Alberti 應盤數量直接拿pie153來計算
# Modify.........: No:MOD-D40041 13/04/09 By bart 在p880_cs1 sql指定自己本身的plantcode及legalcode
# Modify.........: No:CHI-C80013 13/04/12 By Alberti p880_cs中錯誤訊息改用彙總訊息
# Modify.........: No.FUN-D40103 13/05/07 By fengrui 抓ime_file資料添加imeacti='Y'條件
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD			    	 # Print condition RECORD
                stk       LIKE type_file.chr1,   # 現有庫存是否過帳  #No.FUN-690026 VARCHAR(1)
       		    wip       LIKE type_file.chr1,   # 在製工單是否過帳  #No.FUN-690026 VARCHAR(1)
                sw        LIKE type_file.chr1,   #NO.FUN-5C0001 ADD  #No.FUN-690026 VARCHAR(1)
                posdate   LIKE type_file.dat,    #No.FUN-690026 DATE
                wc1,wc2   LIKE type_file.chr1000,#No.FUN-690026 VARCHAR(400)
                ina01_1   LIKE ina_file.ina01,    #FUN-B40082
                ina01_2   LIKE ina_file.ina01,    #FUN-B40082
                sfp01_1   LIKE sfp_file.sfp01,    #FUN-B40082
                sfp01_2   LIKE sfp_file.sfp01,    #FUN-B40082
                sfp01_3   LIKE sfp_file.sfp01,    #FUN-B40082
                inb930    LIKE inb_file.inb930,   #FUN-B40082
                inb15     LIKE inb_file.inb15,    #FUN-B40082
                inb15_1   LIKE inb_file.inb15     #FUN-B40082
               END RECORD ,
          g_pia           RECORD LIKE pia_file.*,
          g_pid           RECORD LIKE pid_file.*,
          g_pie           RECORD LIKE pie_file.*,
          g_img           RECORD LIKE img_file.*,
          g_ima           RECORD LIKE ima_file.* ,
#         g_diff1,g_diff2 LIKE ima_file.ima26,    #MOD-530179    #FUN-A20044
#         l_qty,l_qty2    LIKE ima_file.ima26,    #MOD-530179    #FUN-A20044
          g_diff1,g_diff2 LIKE type_file.num15_3, #FUN-A20044
          l_qty,l_qty2    LIKE type_file.num15_3, #FUN-A20044 
          s_flag          LIKE type_file.num10,   #No.FUN-690026 INTEGER
          g_piaa          RECORD LIKE piaa_file.*,#No.FUN-570082
          g_imgg          RECORD LIKE imgg_file.*,#No.FUN-570082
          gs_wc           STRING,                 #No.FUN-570082
          l_factor        LIKE img_file.img20     #MOD-530179
DEFINE g_change_lang      LIKE type_file.chr1     #是否有做語言切換 No.FUN-570122           #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt              LIKE type_file.num10    #No.FUN-690026 INTEGER
DEFINE g_sw               LIKE type_file.num10    #NO.FUN-5C0001 ADD  #No.FUN-690026 INTEGER
DEFINE g_sw1              LIKE type_file.num10    #NO.FUN-5C0001 ADD  #No.FUN-690026 INTEGER
DEFINE g_sw2              LIKE type_file.num10    #NO.FUN-5C0001 ADD  #No.FUN-690026 INTEGER
DEFINE g_sql              LIKE type_file.chr1000  #NO.FUN-5C0001 ADD  #No.FUN-690026 VARCHAR(1000)
DEFINE g_sw3              LIKE type_file.num10    #NO.FUN-5C0001 ADD  #No.FUN-690026 INTEGER
DEFINE g_cnt1             LIKE type_file.num10    #NO.FUN-5C0001 ADD  #No.FUN-690026 INTEGER
DEFINE g_cnt2             LIKE type_file.num10    #NO.FUN-5C0001 ADD  #No.FUN-690026 INTEGER
DEFINE g_count            LIKE type_file.num10    #NO.FUN-5C0001 ADD  #No.FUN-690026 INTEGER
DEFINE g_pias             RECORD LIKE pias_file.* #No.FUN-8A0147
DEFINE g_t1               LIKE smy_file.smyslip   #NO.FUN-B40082
DEFINE g_ina              RECORD LIKE ina_file.*  #NO.FUN-B40082
DEFINE g_chr              LIKE type_file.chr1     #NO.FUN-B40082
DEFINE g_def_flag         LIKE type_file.chr1     #CHI-C80015 add 
DEFINE g_sfp RECORD       LIKE sfp_file.*         #NO.FUN-B40082
DEFINE g_sfa013_where     STRING                  #FUN-B40082
MAIN
DEFINE l_flag LIKE type_file.chr1    #FUN-570122  #No.FUN-690026 VARCHAR(1)
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.stk = ARG_VAL(1)
   LET tm.wip = ARG_VAL(2)
   LET tm.posdate = ARG_VAL(3)
   LET tm.wc1 = ARG_VAL(4)
   LET tm.wc2 = ARG_VAL(5)
   LET g_bgjob = ARG_VAL(6)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
 
   IF s_shut(0) THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM 
   END IF   

   LET g_def_flag = 'N'       #CHI-C80015 add
   
   WHILE TRUE
      LET g_success = 'Y'
      IF g_bgjob = 'N' THEN
         BEGIN WORK   #MOD-A70062 add
         CALL p880_tm(0,0)                     # Input print condition
         IF cl_sure(0,0) THEN
             IF tm.stk = 'Y'  OR tm.wip = 'Y' THEN
                 IF tm.sw = 'N' THEN
                     LET g_count = 1
                     LET g_sw  = 0
                     LET g_sw1 = 0
                     LET g_sw2 = 0
                     LET g_sw3 = 0
                     LET g_sql = "SELECT COUNT(*) ",
                                 " FROM  pia_file",
                                 "   WHERE (pia19 = 'N' OR pia19 IS NULL )",
                                 "   AND (pia02 IS NOT NULL AND pia02 != ' ')",
                                 "   AND (pia03 IS NOT NULL AND pia03 != ' ')",
                                 "   AND (pia30 IS NOT NULL OR pia50 IS NOT NULL) ",
                                 "   AND ",tm.wc1 CLIPPED
                     PREPARE p880_sw_p1 FROM g_sql
                     DECLARE p880_sw_c1 CURSOR WITH HOLD FOR p880_sw_p1
                     OPEN p880_sw_c1
                     FETCH p880_sw_c1 INTO g_sw1
    
                     #FUN-B40082(S)
                     IF g_sma.sma542='Y' THEN
                        LET g_sfa013_where = " AND pie012 = sfa012 AND pie013 = sfa013 "
                     ELSE
                        LET g_sfa013_where = " "
                     END IF
                     #FUN-B40082(E)
                     LET g_sql = "SELECT COUNT(*)",
                                 " FROM  pid_file,pie_file, ",
                                 "       sfa_file,sfb_file, ",
                                 "       OUTER ima_file ",
                                 " WHERE pid01=pie01 ",
                                 "   AND pid02=sfa01 AND pie02=sfa03 ",
                                 "   AND pie03=sfa08 AND pie04=sfa12 " ,
                                #"   AND pie012 = sfa012 ",  #FUN-A60095 #FUN-B40082
                                #"   AND pie013 = sfa013 ",  #FUN-A60095 #FUN-B40082
                                 g_sfa013_where,  #FUN-B40082
                                 "   AND sfa01 = sfb01 ",
                                 "   AND pie_file.pie02 = ima_file.ima01 ",
                                 "   AND (pie16 = 'N' OR pie16 IS NULL )",
                                 "   AND (pie02 IS NOT NULL AND pie02 != ' ')",
                                 "   AND (pie30 IS NOT NULL OR pie50 IS NOT NULL ) ",
                                 "   AND ",tm.wc2 CLIPPED
                     PREPARE p880_sw_p2 FROM g_sql
                     DECLARE p880_sw_c2 CURSOR WITH HOLD FOR p880_sw_p2
                     OPEN p880_sw_c2
                     FETCH p880_sw_c2 INTO g_sw2
 
                     CASE
                         WHEN tm.stk = 'Y' AND tm.wip = 'Y'
                             LET g_sw3 = g_sw1 + g_sw2
                             IF g_sw3>0 THEN
                                 CALL cl_progress_bar(g_sw3)
                             END IF
                         WHEN tm.stk = 'Y' AND tm.wip = 'N'
                             IF g_sw1>0 THEN
                                CALL cl_progress_bar(g_sw1)
                             END IF
                         WHEN tm.stk = 'N' AND tm.wip = 'Y'
                             IF g_sw2>0 THEN
                                 CALL cl_progress_bar(g_sw2)
                             END IF
                     END CASE
                 END IF
             END IF
             IF tm.stk='Y' OR tm.wip = 'Y' THEN
                 CALL cl_wait()
                 #FUN-B40082 --START--
                 IF tm.posdate <= g_sma.sma53 THEN 
                    CALL cl_err(g_sma.sma53,'axm-167',0)
                    LET g_def_flag = 'Y'       #CHI-C80015 add
                    CONTINUE WHILE
                 END IF
                 #FUN-B40082 --END--
                 #多倉使用者
                 IF g_sma.sma12='Y' THEN
                     CALL p880_stk1() 
                     IF g_sma.sma115='Y' THEN
                         CALL p880_multi_unit()
                     END IF    
                     CALL p880_wip()
                 ELSE
                     CALL p880_stk2()
                     CALL p880_wip()
                 END IF
             END IF
             IF g_success='Y' THEN
                 COMMIT WORK
                 CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
             ELSE
                 ROLLBACK WORK
                 CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
             END IF
             IF l_flag THEN
                LET g_def_flag = 'Y'       #CHI-C80015 add
                CONTINUE WHILE
             ELSE
                CLOSE WINDOW p880_w
                EXIT WHILE
             END IF
         ELSE
             LET g_def_flag = 'Y'       #CHI-C80015 add
             CONTINUE WHILE
         END IF
      ELSE
         BEGIN WORK   #MOD-A70062 add
         IF tm.stk='Y' OR tm.wip = 'Y' THEN
             #多倉使用者
             IF g_sma.sma12='Y' THEN
                 CALL p880_stk1() 
                 IF g_sma.sma115='Y' THEN
                     CALL p880_multi_unit()
                 END IF    
                 CALL p880_wip()
             ELSE
                 CALL p880_stk2()
                 CALL p880_wip()
             END IF
         END IF
         IF g_success = "Y" THEN
             COMMIT WORK
         ELSE
             ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
  CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION p880_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num10,   #No.FUN-690026 INTEGER
          l_direct      LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_flag        LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_factor      LIKE img_file.img20,
          l_cmd		LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(400)
   DEFINE lsb_wc        base.StringBuffer       #No.FUN-570082
   DEFINE lc_cmd        LIKE type_file.chr1000  #No.FUN-570122 #No.FUN-690026 VARCHAR(500)
   #DEFINE l_ima15       LIKE ima_file.ima15     #FUN-B40082
   DEFINE p_cmd         LIKE type_file.chr1     #FUN-B40082 
 
   LET p_row = 3 LET p_col = 30
 
   OPEN WINDOW p880_w AT p_row,p_col WITH FORM "aim/42f/aimp880" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_opmsg('p')
 
WHILE TRUE
 
   CALL cl_ui_init()
   IF g_def_flag ='N' THEN  #CHI-C80015 add
     INITIALIZE tm.* TO NULL			# Default condition
     LET tm.stk = 'N'
     LET tm.wip = 'N'
     LET tm.posdate = g_today
     LET tm.sw = 'Y' #NO.FUN-5C0001 
     LET g_bgjob = 'N'   #FUN-570122
   END IF                   #CHI-C80015 add
   
   CALL cl_set_comp_visible("inb930",g_aaz.aaz90='Y')  #FUN-B40082
   CALL cl_set_comp_visible("inb15_1",g_sma.sma79='Y') #FUN-B40082
 
   CONSTRUCT BY NAME tm.wc1 ON pia01
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   END CONSTRUCT
   LET tm.wc1 = tm.wc1 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p880_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
 
   CONSTRUCT BY NAME tm.wc2 ON pie01
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   END CONSTRUCT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW p880_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   #INPUT BY NAME tm.stk,tm.wip,tm.sw,tm.posdate,g_bgjob WITHOUT DEFAULTS  #NO.FUN-570122 #FUN-B40082 mark
   INPUT BY NAME tm.stk,tm.wip,tm.ina01_1,tm.ina01_2,tm.sfp01_1,tm.sfp01_2,tm.sfp01_3
                    ,tm.inb930,tm.inb15,tm.inb15_1,tm.sw,tm.posdate,g_bgjob  WITHOUT DEFAULTS #FUN-B40082 
 
      ON ACTION locale
          CALL cl_dynamic_locale()     #No.TQC-6C0153
          CALL cl_show_fld_cont()     #No.TQC-6C0153
          LET g_change_lang = TRUE
          CONTINUE INPUT     #No.TQC-6C0153
      BEFORE INPUT #FUN-B40082         
         CALL p880_set_entry(p_cmd)    #FUN-B40082
         CALL p880_set_no_entry(p_cmd) #FUN-B40082
        #CHI-C80015 str add-----
         IF g_def_flag ='Y' THEN
            IF tm.wip = "Y" THEN
               CALL p880_set_entry(p_cmd)
            ELSE
               CALL p880_set_no_entry(p_cmd)
            END IF            
         END IF
        #CHI-C80015 end add-----
      AFTER FIELD stk
         IF tm.stk NOT MATCHES "[YN]" OR tm.stk IS NULL THEN
            NEXT FIELD stk
         ELSE
            IF tm.stk = 'Y' THEN 
               SELECT COUNT(*) INTO g_cnt FROM pia_file
               IF g_cnt = 0 OR g_cnt IS NULL THEN
                  CALL cl_err('','mfg0117',1)
                  NEXT FIELD stk
               END IF
            END IF
         END IF
 
      AFTER FIELD wip
         IF tm.wip NOT MATCHES "[YN]" OR tm.wip IS NULL THEN
            NEXT FIELD wip
         ELSE
            IF tm.wip = 'Y' THEN 
               SELECT COUNT(*) INTO g_cnt FROM pid_file
               IF g_cnt = 0 OR g_cnt IS NULL THEN
                  CALL cl_err('','mfg0118',1)
                  NEXT FIELD wip
               END IF
            END IF
         END IF
 
      AFTER FIELD posdate
         IF tm.posdate IS NULL OR tm.posdate = ' ' THEN
            NEXT FIELD posdate   #MOD-9B0040
         END IF
         
                     
         IF tm.posdate <= g_sma.sma53 THEN
            CALL cl_err(g_sma.sma53,'axm-167',0)
            NEXT FIELD posdate
         END IF
         IF tm.stk = 'N' AND tm.wip = 'N' THEN
            CALL cl_err('','aim-319',0)      #No.TQC-740198
            NEXT FIELD stk      #No.TQC-740198
         END IF 
 
      ON CHANGE g_bgjob
         IF g_bgjob = "Y" THEN
             LET tm.sw = "N"
             DISPLAY BY NAME tm.sw
             CALL cl_set_comp_entry("sw",FALSE)
         ELSE
             CALL cl_set_comp_entry("sw",TRUE)
          END IF
      #FUN-B40082 --START--
      ON CHANGE wip
         IF tm.wip = "Y" THEN
            CALL p880_set_entry(p_cmd) 
         ELSE            
            CALL p880_set_no_entry(p_cmd)
         END IF         
      #FUN-B40082 --END--
      AFTER FIELD g_bgjob
          IF g_bgjob NOT MATCHES "[YN]"  OR cl_null(g_bgjob) THEN
              NEXT FIELD g_bgjob
          END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()	# Command execution
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

      #FUN-B40082 --START--
      ON ACTION controlp 
         CASE WHEN INFIELD(ina01_1) #雜收
                      LET g_t1=s_get_doc_no(tm.ina01_1)
                      CALL q_smy(FALSE,FALSE,g_t1,'AIM','2') RETURNING g_t1   
                      LET tm.ina01_1=g_t1                
                      DISPLAY tm.ina01_1 TO ina01_1 
                      NEXT FIELD ina01_1
              WHEN INFIELD(ina01_2) #雜發
                      LET g_t1=s_get_doc_no(tm.ina01_2)                        
                      CALL q_smy(FALSE,FALSE,g_t1,'AIM','1') RETURNING g_t1   
                      LET tm.ina01_2=g_t1                
                      DISPLAY tm.ina01_2 TO ina01_2 
                      NEXT FIELD ina01_2
              WHEN INFIELD(sfp01_1) #發料
                      LET g_t1=s_get_doc_no(tm.sfp01_1)
                      CALL q_smy(FALSE,TRUE,g_t1,'ASF','3') RETURNING g_t1   
                      LET tm.sfp01_1=g_t1                
                      DISPLAY tm.sfp01_1 TO sfp01_1 
                      NEXT FIELD sfp01_1                       
              WHEN INFIELD(sfp01_2) #退料
                      LET g_t1=s_get_doc_no(tm.sfp01_2)                        
                      CALL q_smy(FALSE,TRUE,g_t1,'ASF','4') RETURNING g_t1   
                      LET tm.sfp01_2=g_t1                
                      DISPLAY tm.sfp01_2 TO sfp01_2 
                      NEXT FIELD sfp01_2 
              WHEN INFIELD(sfp01_3) #超領
                      LET g_t1=s_get_doc_no(tm.sfp01_3)                        
                      CALL q_smy(FALSE,TRUE,g_t1,'ASF','3') RETURNING g_t1   
                      LET tm.sfp01_3=g_t1                
                      DISPLAY tm.sfp01_3 TO sfp01_3 
                      NEXT FIELD sfp01_3 
              WHEN INFIELD(inb15)  #理由碼 
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_azf01a"
                      LET g_qryparam.default1 = tm.inb15
                      LET g_qryparam.arg1 = "4"
                      CALL cl_create_qry() RETURNING tm.inb15
                      DISPLAY tm.inb15 TO inb15
                      NEXT FIELD inb15 
              WHEN INFIELD(inb15_1) #保稅理由碼   
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_azf"
                      LET g_qryparam.default1 = tm.inb15_1
                      LET g_qryparam.arg1 = "A2"
                      CALL cl_create_qry() RETURNING tm.inb15_1                
                      DISPLAY tm.inb15_1 TO inb15_1   
                      NEXT FIELD inb15_1
              WHEN INFIELD(inb930) #成本中心
                      CALL cl_init_qry_var()                                                                                            
                      LET g_qryparam.form ="q_gem4"                                                                                     
                      LET g_qryparam.default1 = tm.inb930
                      CALL cl_create_qry() RETURNING tm.inb930 
                      DISPLAY BY NAME tm.inb930
                      NEXT FIELD inb930
                OTHERWISE EXIT CASE             
            END CASE
      #FUN-B40082 --END--
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p880_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   IF tm.stk = 'N' AND tm.wip = 'N' THEN
      CALL cl_err('','aim-319',0)
      CONTINUE WHILE
   END IF 
   EXIT WHILE
 END WHILE
   LET gs_wc=tm.wc1 CLIPPED                                                     
   LET lsb_wc=base.StringBuffer.create()                                      
   CALL lsb_wc.append(gs_wc.trim())                                           
   CALL lsb_wc.replace("pia","piaa",0)                                        
   LET gs_wc=lsb_wc.toString()        
 
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
        WHERE zz01 = "aimp880"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('aimp880','9031',1)
      ELSE
         LET tm.wc1=cl_replace_str(tm.wc1, "'", "\"")
         LET tm.wc2=cl_replace_str(tm.wc2, "'", "\"")
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",tm.stk CLIPPED,"'",
                      " '",tm.wip CLIPPED,"'",
                      " '",tm.posdate CLIPPED,"'",
                      " '",tm.wc1 CLIPPED,"'",
                      " '",tm.wc2 CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('aimp880',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p880_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
END FUNCTION
 
#多倉處理作業
FUNCTION p880_stk1() 
   DEFINE l_name    LIKE type_file.chr20,    #External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#         l_qty     LIKE ima_file.ima26,     #MOD-530179        #FUN-A20044
          l_qty     LIKE type_file.num15_3,                     #FUN-A20044        
          l_date    LIKE type_file.dat,      #No.FUN-690026 DATE
          l_img07   LIKE img_file.img07,
          l_img20   LIKE img_file.img20,
          l_img34   LIKE img_file.img34,
          l_imf04   LIKE imf_file.imf04,
          l_ime     RECORD LIKE ime_file.*,
          l_sql     LIKE type_file.chr1000   #No.FUN-690026 VARCHAR(600)
   DEFINE l_imaacti LIKE ima_file.imaacti    #No.MOD-8C0294 add 
   DEFINE l_piadqty LIKE type_file.num15_3   #FUN-B70032   
   DEFINE l_str        STRING                #MOD-CC0207

#======================== 現有庫存 ===========================
     IF tm.stk = 'N' THEN RETURN END IF
     LET l_sql = "SELECT * ",
                 " FROM  pia_file",
                 "   WHERE (pia19 = 'N' OR pia19 IS NULL )",
                 "   AND (pia02 IS NOT NULL AND pia02 != ' ')",
                 "   AND (pia03 IS NOT NULL AND pia03 != ' ')",
                 "   AND (pia30 IS NOT NULL OR pia50 IS NOT NULL) ",
                 "   AND ",tm.wc1 CLIPPED,
                 "   AND piaplant = '",g_plant,"' AND pialegal = '",g_legal,"'",  #MOD-D40041
                 "   FOR UPDATE "
     LET l_sql=cl_forupd_sql(l_sql)
 
     PREPARE p880_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_batch_bg_javamail("N")     #FUN-570122
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE p880_cs1 CURSOR FOR p880_prepare1
 
     CALL s_showmsg_init() #FUN-B70032
 
     #處理要點:1.當初盤與複盤數量皆為NULL時,不更新其庫存數量
     #         2.更新數量以複盤數量為主,當複盤數量為NULL時,才以初盤數量更新
     #         3.若資料不存在於[倉庫庫存明細檔]中,則必須新增一筆[倉庫庫存明細]
     #         4.數量更新時,必須考慮是否為可用倉,及MRP/MPS可用否
    #BEGIN WORK   #MOD-A70062 mark
     #LET g_success = 'Y'  #No.MOD-930040 add #FUN-B70032 mark 外層已有=Y 此處再給Y會蓋掉其它FUNC給的N
     FOREACH p880_cs1 INTO g_pia.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1) 
          LET g_success = 'N'                      #No.TQC-930155---add---
          EXIT FOREACH 
       END IF
       LET g_cnt1 = g_cnt1 + 1
       IF tm.sw = 'Y' OR g_bgjob = 'N' THEN  #NO.FUN-570122
           MESSAGE g_pia.pia01,' ',g_pia.pia02
           CALL ui.Interface.refresh()
       END IF
     WHILE TRUE
              
      IF g_pia.pia04 IS NULL THEN LET g_pia.pia04=' ' END IF
      IF g_pia.pia05 IS NULL THEN LET g_pia.pia05=' ' END IF
      #-->倉庫檢查 
      IF g_pia.pia03 IS NULL OR g_pia.pia03 = ' '
      THEN CALL p880_err(g_pia.pia01,g_pia.pia02,'mfg0142')
           LET g_success ='N'
           EXIT WHILE
      END IF 
      #-->轉換率檢查 
      IF g_pia.pia10 IS NULL OR g_pia.pia10 = ' ' OR g_pia.pia10 = 0 THEN
         CALL p880_err(g_pia.pia01,g_pia.pia02,'mfg0142')
         LET g_success  ='N'
         EXIT WHILE
      END IF
   
      SELECT imaacti INTO l_imaacti FROM ima_file                                                                                  
        WHERE ima01=g_pia.pia02 
      IF l_imaacti MATCHES '[nN]' THEN                                                                                             
          CALL p880_err(g_pia.pia01,g_pia.pia02,'aim-502')                                                                          
          LET g_success  ='N'                                                                                                       
          EXIT WHILE                                                                                                                
      END IF  

     #MOD-CC0207---add---S
     #---->過帳第一、二組數量有差異時不允許過帳      
      IF NOT cl_null(g_pia.pia50) AND NOT cl_null(g_pia.pia60) THEN
         IF g_pia.pia50 <> g_pia.pia60 THEN
            LET l_str='複盤'
            CALL cl_err(l_str,'aim1165',1)         
            LET g_success  ='N'
            EXIT WHILE
         END IF
      ELSE
         IF NOT cl_null(g_pia.pia30) AND NOT cl_null(g_pia.pia40) THEN
            IF g_pia.pia30 <> g_pia.pia40 THEN
               LET l_str='初盤'
               CALL cl_err(l_str,'aim1165',1)
               LET g_success  ='N'
               EXIT WHILE
            END IF
         END IF 
      END IF
     #MOD-CC0207---add---E

      #---->決定盤點數量
      IF g_pia.pia50 IS NOT NULL THEN LET g_pia.pia30 = g_pia.pia50 END IF
      LET l_qty  = g_pia.pia30  * g_pia.pia10  #料件(ima)數量
      LET l_qty2 = g_pia.pia30                 #倉庫(img)數量
      #FUN-B70032 --START--
      IF s_industry('icd') THEN
         #確認
         CALL p880_piadqty_chk(g_pia.pia01,g_pia.pia02,g_pia.pia03,
                               g_pia.pia04,g_pia.pia05) RETURNING l_piadqty
         IF g_pia.pia30 <> l_piadqty THEN            
            LET g_showmsg=g_pia.pia01,"/",g_pia.pia02,"/",g_pia.pia03,"/",
                           g_pia.pia04,"/",g_pia.pia05 
            CALL s_errmsg('pia01,pia02,pia03,pia04,pia05 ',g_showmsg,'','aim-038',1)
            LET g_success='N'
            EXIT WHILE
         END IF 
         
         IF NOT p880_uppiad(g_pia.pia01,g_pia.pia02) THEN            
            LET g_showmsg=g_pia.pia01,"/",g_pia.pia02,"/",g_pia.pia03,"/",
                         g_pia.pia04,"/",g_pia.pia05 
            CALL s_errmsg('pia01,pia02,pia03,pia04,pia05 ',g_showmsg,'','apc-112',1)
            LET g_success='N' 
            EXIT WHILE 
         END IF        
      END IF 
      #FUN-B70032 --END--
      #-->如有盤點日期則以此為基準
      IF tm.posdate IS NOT NULL AND tm.posdate !=' ' THEN
         LET l_date = tm.posdate 
      ELSE
         LET l_date = g_today
      END IF
      #-->料件數量
      IF l_qty IS NULL OR l_qty = ' ' THEN
         CALL p880_err(g_pia.pia01,g_pia.pia02,'mfg0143')
         LET g_success  ='N'
         EXIT WHILE
      END IF
      #-->倉庫數量
      IF l_qty2 IS NULL OR l_qty2 = ' ' THEN
         CALL p880_err(g_pia.pia01,g_pia.pia02,'mfg0144')
         LET g_success  ='N'
         EXIT WHILE
      END IF
      #---->讀取料件基本資料
      SELECT *  INTO g_ima.*  
        FROM ima_file
       WHERE ima01=g_pia.pia02
      IF SQLCA.sqlcode THEN
         LET g_success ='N'
         CALL cl_err3("sel","ima_file",g_pia.pia02,"",SQLCA.sqlcode,
                      "","Cannot select ima_file",1)   #NO.FUN-640266 #No.FUN-660156
         EXIT WHILE
      END IF
 
      #---->讀取倉庫明細資料
      LET g_sql = "SELECT img_file.* FROM img_file ",   
                  " WHERE img01 = '",g_pia.pia02,"' ",
                  "   AND img02 = '",g_pia.pia03,"' ",
                  "   AND img03 = '",g_pia.pia04,"' ",
                  "   AND img04 = '",g_pia.pia05,"' ", 
                  " FOR UPDATE "             
      LET g_sql=cl_forupd_sql(g_sql)

      DECLARE img_lock_t1 CURSOR FROM g_sql   
      OPEN img_lock_t1     
      IF STATUS THEN        
         CALL cl_err("OPEN img_lock_t1:", STATUS, 1) 
         CLOSE img_lock_t1     
         LET g_success = 'N'    
         EXIT WHILE   
      END IF           
      FETCH img_lock_t1 INTO g_img.*  
      #不存在時, insert 一筆資料
      IF SQLCA.sqlcode THEN   
         IF SQLCA.sqlcode <> 100 THEN   
            CALL cl_err("sel img_file:", STATUS, 1) 
            CLOSE img_lock_t1 
            LET g_success = 'N'
            EXIT WHILE 
         END IF
         #---->讀取最高存量限制
         SELECT imf04  INTO l_imf04 FROM imf_file
          WHERE imf01=g_pia.pia02 
            AND imf02=g_pia.pia03
            AND imf03=g_pia.pia04
         IF l_imf04 IS NULL THEN LET l_imf04 = 0 END IF
 
         #---->倉庫/存放位置資料主檔
         IF g_sma.sma42 != '3' THEN     #CHI-910008
          SELECT * INTO l_ime.*  
            FROM ime_file
           WHERE ime01=g_pia.pia03 AND ime02=g_pia.pia04
	  AND imeacti='Y'  #FUN-D40103 add
          IF STATUS THEN
             CALL cl_err3("sel","ime_file",g_pia.pia03,g_pia.pia04,
                           SQLCA.sqlcode,"","sel",1)   #NO.FUN-640266 #No.FUN-660156
             LET g_success='N'
             EXIT WHILE
          END IF
         END IF                         #CHI-910008
 
         #庫存/成本轉換率  allways = 1
         LET l_factor=1
                        #1   #2 #3    #4     #5          #6
          CALL s_upimg(g_pia.pia02,g_pia.pia03,g_pia.pia04,g_pia.pia05,1,l_qty2,l_date,g_pia.pia02,g_pia.pia03,#FUN-8C0084
                       #7          #8          #9          #10
                       g_pia.pia04,g_pia.pia05,g_pia.pia01,'',
                       #11         #12    #13         #14 #15
                       g_pia.pia09,l_qty2,g_pia.pia09,1  ,g_pia.pia10,
                       #16      #17         #18  #19        #20
                       l_factor,g_pia.pia07,' ',l_ime.ime10,l_ime.ime11,
                       #21          #22
                        g_pia.pia06,' ')
          IF g_success = 'N' THEN 
             EXIT WHILE 
          END IF  
          CALL p880_upimgs(l_qty2,l_date)       #No.FUN-8A0147
          IF g_success='N' THEN
             EXIT WHILE
          END IF
 
 
          #---->料件主檔
           IF s_udima(g_pia.pia02,              #料件編號
                      l_ime.ime05,              #是否可用倉儲
		      l_ime.ime06,              #是否為MRP可用倉儲
		      l_qty,                    #數量(換算為庫存單位)
		      l_date,                   #最近一次盤點日期
		      +2)                       #表盤點
            THEN LET g_success = 'N' 
                 CALL cl_err('(p880_1:ima_file)',SQLCA.sqlcode,1)  #TQC-9B0011 mod
                 EXIT WHILE 
            END IF
 
          #---->產生一筆異動資料
           IF l_qty2 != 0 THEN 
              CALL p880_log('','',g_pia.pia02,l_qty2,l_date)
              IF g_success ='N' THEN 
                 CALL cl_err('(p880_1:log)',SQLCA.sqlcode,1)
                 EXIT WHILE 
              END IF
           END IF
       ELSE
          IF g_img.img10 IS NULL OR g_img.img10 = ' ' THEN
             CALL p880_err(g_pia.pia01,g_pia.pia02,'mfg0146')
             LET g_success  ='N'
             EXIT WHILE
          END IF
           LET g_diff2 = l_qty2 - g_pia.pia08    
 
          #數量差量(ima_file 料件庫存單位)
           LET g_diff1 = g_diff2 * g_pia.pia10 
           IF g_diff1 IS NULL THEN LET g_diff1 = 0 END IF
 
          #---->更新庫存明細檔
                        #1         #2  #3      #4     #5        
          CALL s_upimg(g_pia.pia02,g_pia.pia03,g_pia.pia04,g_pia.pia05,2,  g_diff2,l_date,g_pia.pia02, #FUN-8C0084
                       #6          #7          #8          
                       g_pia.pia03,g_pia.pia04,g_pia.pia05,
                       #9          #10  #11         #12  
                       g_pia.pia01,'',  g_pia.pia09,g_diff2,
                       #13         #14  #15         #16    
                       g_pia.pia09,1  , g_pia.pia10,l_factor,
                       #17         #18  #19         #20
                       g_pia.pia07,' ', l_ime.ime10,l_ime.ime11,
                       #21         #22
                       g_pia.pia06,' ')
          IF g_success = 'N' THEN 
             EXIT WHILE     
          END IF           
          CALL p880_upimgs(g_diff2,l_date)
          IF g_success ='N' THEN EXIT WHILE END IF
 
          #---->更新料件主檔
          IF s_udima(g_pia.pia02,               #料件編號
                     g_img.img23,              #是否可用倉儲
		     g_img.img24,              #是否為MRP可用倉儲
		     g_diff1,                  #數量(換算為庫存單位)
		     l_date,                   #最近一次盤點日期
		     +2)                    #表盤點
           THEN LET g_success ='N' 
                EXIT WHILE 
           END IF
 
          #---->產生一筆異動資料
              CALL p880_log('','',g_pia.pia02,g_diff2,l_date)
              IF g_success='N' THEN EXIT WHILE END IF
       END IF
 
       #---->更新 [盤點標籤明細檔] 之 POSTING FLAG = 'Y'
        UPDATE pia_file
           SET pia19='Y'
          WHERE pia01 = g_pia.pia01
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           LET g_success='N' 
           CALL cl_err3("upd","pia_file",g_pia.pia01,"",SQLCA.sqlcode,"","(p880_1:ckp#9)",1)  #No.FUN-660156
           EXIT WHILE 
        END IF
        EXIT WHILE
     END WHILE 
     IF tm.sw = 'N' THEN
        CALL cl_progressing(" ")
     END IF
 
    END FOREACH
    CALL s_showmsg()   #FUN-B70032
   #str MOD-A70062 mark
   #IF g_success = 'Y' THEN
   #   COMMIT WORK
   #ELSE
   #   CALL cl_rbmsg(4)
   #   ROLLBACK WORK
   #END IF
   #end MOD-A70062 mark
END FUNCTION
 
#單倉資料處理
FUNCTION p880_stk2()
END FUNCTION
 
#======================== 在製工單 ===========================
FUNCTION p880_wip()
  DEFINE  l_tagqty     LIKE pie_file.pie30,   #實地盤點數量
          l_uninv      LIKE pie_file.pie30,   #應盤數量
          l_diffqty    LIKE pie_file.pie30,  
          l_over       LIKE pie_file.pie30,
          l_actuse     LIKE pie_file.pie30,
          l_sfb03      LIKE sfb_file.sfb03,
          l_sfb93      LIKE sfb_file.sfb93,
          l_sfb27      LIKE sfb_file.sfb27,
          l_sfb28      LIKE sfb_file.sfb28,  #FUN-B40082
          l_sfa13      LIKE sfa_file.sfa13,
          l_sfa26      LIKE sfa_file.sfa26,
          l_date       LIKE type_file.dat,     #No.FUN-690026 DATE
          l_sql        STRING  #No.FUN-690026 VARCHAR(800) #FUN-760040
  DEFINE  l_sfa01      LIKE sfa_file.sfa01,  #FUN-760040
          l_sfa03      LIKE sfa_file.sfa03,  #FUN-760040
          l_sfa08      LIKE sfa_file.sfa08,  #FUN-760040
          l_sfa12      LIKE sfa_file.sfa12,  #FUN-760040
          l_sfa27      LIKE sfa_file.sfa27,  #FUN-870051
          l_sfa012     LIKE sfa_file.sfa012, #FUN-A60027
          l_sfa013     LIKE sfa_file.sfa013  #FUN-A60027 
  DEFINE  l_sfa05      LIKE sfa_file.sfa05,  #FUN-B40082
          l_sfa06      LIKE sfa_file.sfa06   #FUN-B40082
  DEFINE  l_ima25      LIKE ima_file.ima25,  #FUN-B40082
          l_ima15      LIKE ima_file.ima15   #FUN-B40082
  DEFINE  p_type       LIKE ina_file.ina00,  #FUN-B40082
          p_type2      LIKE ina_file.ina00   #FUN-B40082
  DEFINE  l_qty1       LIKE pie_file.pie30,  #FUN-B40082
          l_qty2       LIKE pie_file.pie30   #FUN-B40082  
  DEFINE  l_prog       LIKE type_file.chr20  #FUN-B40082
  DEFINE  l_smy79      LIKE smy_file.smy79   #FUN-B40082
  DEFINE  l_sfa064     LIKE sfa_file.sfa064  #FUN-BB0083 add
  DEFINE  l_sfa28      LIKE sfa_file.sfa28   #MOD-C70062 add
          
     IF tm.wip = 'N' THEN RETURN END IF
     #FUN-B40082(S)
     IF g_sma.sma542='Y' THEN
        LET g_sfa013_where = " AND pie012=sfa012 AND pie013=sfa013 "
     ELSE
        LET g_sfa013_where = " "
     END IF
     #FUN-B40082(E)
     LET l_sql = "SELECT pid02, pid13, pid17,",
                 " pie01,pie02, pie03, pie04, pie05,",
                 " pie07, pie11, ",
                 " pie12,pie13, pie14, pie15, pie151,pie152,pie153,",  #MOD-C80038 add pie153,
                 " pie30,pie32, pie50, pie52, sfb03, sfb27, sfb28, ",  #FUN-B40082 add sfb28
                 " sfa26,sfa13, sfb93, ", #FUN-560183 del ima86
                 " sfa01,sfa03,sfa08,sfa12,sfa27,sfa012,sfa013, ", #FUN-760040 #No.FUN-870051 add sfa27  #FUN-A60027 add sfa012,sfa013
                 " sfa05,sfa06,ima25,ima15,smy79 ", #FUN-B40082
                 " FROM  pid_file,pie_file, ",
                 "       sfa_file,sfb_file, ",
                 "       smy_file,",           #FUN-B40082
                 "       OUTER ima_file ",
                 " WHERE pid01=pie01 ",
                 "   AND pid02=sfa01 AND pie02=sfa03 ",
                 "   AND pie03=sfa08 AND pie04=sfa12 " ,
                #"   AND pie012=sfa012 ",  #FUN-A60095 #FUN-B40082
                #"   AND pie013=sfa013 ",  #FUN-A60095 #FUN-B40082
                 g_sfa013_where,  #FUN-B40082
                 "   AND pie900=sfa27  ",  #FUN-A60095
                 "   AND pie01[1,", g_doc_len, "] = smyslip ", #FUN-B40082
                 "   AND sfa01 = sfb01 ",
                 "   AND pie_file.pie02 = ima_file.ima01 ",
                 "   AND (pie16 = 'N' OR pie16 IS NULL )",
                 "   AND (pie02 IS NOT NULL AND pie02 != ' ')",
                 "   AND (pie30 IS NOT NULL OR pie50 IS NOT NULL ) ",                 
                 "   AND ",tm.wc2 CLIPPED
 
  PREPARE p880_prepare3 FROM l_sql
  IF SQLCA.sqlcode != 0 THEN 
     CALL cl_err('prepare:',SQLCA.sqlcode,1) 
     CALL cl_batch_bg_javamail("N")     #FUN-570122
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
     EXIT PROGRAM 
  END IF
  DECLARE p880_cs3 CURSOR FOR p880_prepare3
 
 #BEGIN WORK   #MOD-A70062 mark
  #LET g_success = 'Y'  #No.MOD-930040 add #FUN-B70032 mark 外層已有=Y 此處再給Y會蓋掉其它FUNC給的N
  LET l_prog = g_prog  #FUN-B40082
  CALL s_showmsg_init()              #CHI-C80013 add
  CALL t370sub_aimp880()             #CHI-C80013 add
  CALL i501sub_aimp880()             #CHI-C80013 add
  FOREACH p880_cs3 INTO g_pid.pid02,g_pid.pid13,g_pid.pid17,
                        g_pie.pie01,g_pie.pie02,g_pie.pie03,g_pie.pie04,
                        g_pie.pie05,g_pie.pie07,g_pie.pie11,g_pie.pie12, 
                        g_pie.pie13,g_pie.pie14,g_pie.pie15,g_pie.pie151,
                        g_pie.pie152,g_pie.pie153,g_pie.pie30,g_pie.pie32,g_pie.pie50,       #MOD-C80038 add g_pie.pie153,
                        g_pie.pie52,l_sfb03,l_sfb27,l_sfb28,l_sfa26,     #FUN-B40082 add l_sfb28
                        l_sfa13,l_sfb93,l_sfa01,l_sfa03,l_sfa08,l_sfa12, #FUN-560183 del ima86 #FUN-760040 
                        l_sfa27,l_sfa012,l_sfa013,    #No.FUN-870051      #FUN-A60027 sfa012,sfa013
                        l_sfa05,l_sfa06,l_ima25,l_ima15,l_smy79 #FUN-B40082
    IF SQLCA.sqlcode != 0 THEN 
       CALL cl_err('foreach:',SQLCA.sqlcode,1) 
       LET g_success = 'N'   #NO.TQC-930155----add----
       EXIT FOREACH 
    END IF

    #FUN-B40082 --START--    
    IF NOT cl_null(l_sfb28) THEN
       CALL p880_err(g_pie.pie01,g_pie.pie02,'aim-887') #工單資料已結案,不可過帳!
       LET g_success='N'       
    END IF                 
    #FUN-B40082 --END-- 
 
    LET g_cnt2= g_cnt2 + 1
    IF tm.sw = 'Y' OR g_bgjob = 'N' THEN  #NO.FUN-570122 
        MESSAGE g_pid.pid01,' ',g_pid.pid03
    END IF
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_success = 'N'   #NO.TQC-930155----add----
       EXIT FOREACH
    END IF
 
    #WHILE TRUE #FUN-B40082 mark 
      #-->應發數量檢查
      IF g_pie.pie11  IS NULL OR g_pie.pie11 = ' ' OR g_pie.pie11 = 0 THEN
         CALL p880_err(g_pie.pie01,g_pie.pie02,'mfg0133')
         LET g_pie.pie11  = 0 
      END IF 
      #-->已發數量檢查
      IF g_pie.pie12  IS NULL OR g_pie.pie12 = ' ' THEN
         CALL p880_err(g_pie.pie01,g_pie.pie02,'mfg0134')
         LET g_pie.pie12  = 0 
      END IF 
      #-->當已發量 > 應發量時表示有誤
      IF g_pie.pie12 > g_pie.pie11 THEN 
         CALL p880_err(g_pie.pie01,g_pie.pie02,'mfg0135')
         IF g_bgerr THEN                                              #CHI-C80013 add
            CALL s_errmsg('pie01',g_pie.pie01,'ckp#2','mfg0135',1)    #CHI-C80013 add
         ELSE                                                         #CHI-C80013 add
            CALL cl_err('ckp#2','mfg0135',1)
         END IF                                                       #CHI-C80013 add   
         LET g_success ='N'   
         #EXIT WHILE #FUN-B40082 mark 
      END IF
      #-->超領數量
      IF g_pie.pie13  IS NULL OR g_pie.pie13  = ' ' THEN
         CALL p880_err(g_pie.pie01,g_pie.pie02,'mfg0136')
         LET g_pie.pie13  = 0 
      END IF
##No.2945 modify 1998/12/21 判斷標準用量不可為0但當有取替代時可為0
      #-->標準單位用量
      IF g_pie.pie14  IS NULL OR g_pie.pie14 = ' ' THEN
         IF l_sfa26 NOT MATCHES '[346]' AND g_pie.pie14 = 0 THEN #bugno:7111 add '6'
            CALL p880_err(g_pie.pie01,g_pie.pie02,'mfg0138')
            IF g_bgerr THEN                                              #CHI-C80013 add
               CALL s_errmsg('pie01',g_pie.pie01,'ckp#2','mfg0135',1)    #CHI-C80013 add
            ELSE                                                         #CHI-C80013 add
               CALL cl_err('ckp#2','mfg0135',1)
            END IF                                                       #CHI-C80013 add   
            LET g_success ='N'   
            #EXIT WHILE #FUN-B40082 mark
         END IF
      END IF 
      #-->決定實際盤點數量(皆以盤點員一)
      IF g_pie.pie50 IS NULL  
      THEN LET l_tagqty = g_pie.pie30
      ELSE LET l_tagqty = g_pie.pie50
      END IF 
      IF tm.posdate IS NOT NULL AND tm.posdate != ' ' 
      THEN LET l_date = tm.posdate
      ELSE LET l_date = g_today
      END IF
 
      IF l_tagqty IS NULL OR l_tagqty = ' ' 
      THEN CALL p880_err(g_pie.pie01,g_pie.pie02,'mfg0139')
           IF g_bgerr THEN                                              #CHI-C80013 add
              CALL s_errmsg('pie01',g_pie.pie01,'ckp#2.1','mfg0139',1)  #CHI-C80013 add
           ELSE                                                         #CHI-C80013 add
              CALL cl_err('ckp#2.1','mfg0139',1)
           END IF                                                       #CHI-C80013 add   
           LET g_success ='N' 
           #EXIT WHILE #FUN-B40082 mark
      END IF 
    #MOD-C80038 str mark-----  
    # #--->計算未入庫數量(應盤數量)
    # #    實際已用量=((完工入庫量 + 報廢數量) * qpa ) + 下階報廢 
    # #    應盤數量  = 已發數量 + 超領數量 - 實際已用量
    # SELECT sfa28 INTO l_sfa28 FROM sfa_file WHERE sfa01 = g_pid.pid02 AND sfa03 = g_pie.pie02 #MOD-C70062 add
    ##LET l_actuse = ((g_pid.pid13 + g_pid.pid17) * g_pie.pie14) + g_pie.pie15                  #MOD-C70062 mark
    # LET l_actuse = ((g_pid.pid13 + g_pid.pid17) * g_pie.pie14 * l_sfa28) + g_pie.pie15        #MOD-C70062 add
    # LET l_uninv = g_pie.pie12 + g_pie.pie13 - l_actuse
    # IF l_uninv  < 0  OR l_uninv IS NULL
    #  THEN CALL p880_err(g_pie.pie01,g_pie.pie02,'mfg0140')
    #       CALL cl_err('ckp#2.2','mfg0140',1)
    #      LET g_success ='N' 
    #      #EXIT WHILE #FUN-B40082 mark
    # END IF
    #MOD-C80038 end mark-----
      LET l_uninv = g_pie.pie153           #MOD-C80038 add
      #--->計算出應調整數量 = 盤點數量 - 應盤數量
      LET l_diffqty = l_tagqty - l_uninv  
 
      IF l_diffqty != 0 THEN 
          #---->在製工單盤盈時調整原則
          #     * 先調整已發量(sfa06) = 應發量，如有剩則調整超領量(sfa062)
         IF l_diffqty > 0 THEN  
       ELSE 
          #---->在製工單盤虧時調整原則
          #     * 先調整超領數量至零為止，再調整已發數量 
           LET l_diffqty = l_diffqty * -1
           LET l_diffqty = l_diffqty * -1
       END IF 
     END IF
        
 #---->更新備料檔上的盤點差異量
    #IF l_sfb93!='Y' THEN  #FUN-A60095 mark
    LET l_sfa064 = s_digqty(l_diffqty,l_sfa12) #FUN-BB0083 add
       UPDATE sfa_file SET sfa064 = l_sfa064 #l_diffqty FUN-BB0083 mark
                      WHERE sfa01=l_sfa01 AND sfa03=l_sfa03 AND sfa08=l_sfa08 AND sfa12=l_sfa12
                        AND sfa012  = l_sfa012 AND sfa013 = l_sfa013    #FUN-A60027 add 
                        AND sfa27 = l_sfa27  #FUN-A60095
       IF SQLCA.sqlerrd[3]=0 OR SQLCA.sqlcode THEN 
          LET g_success ='N'
          CALL p880_err(g_pie.pie01,g_pie.pie02,'mfg0141')
          IF g_bgerr THEN                                                         #CHI-C80013 add
             CALL s_errmsg('sfa_file',g_pie.pie01,'ckp#2.8 upd sfa','mfg0141',1)  #CHI-C80013 add
          ELSE                                                                    #CHI-C80013 add
             CALL cl_err3("upd","sfa_file","","",
                       "mfg0141","","ckp#2.8",1)  #No.FUN-660156
          END IF                                                                  #CHI-C80013 add             
          #EXIT WHILE #FUN-B40082 mark
       END IF
 
 #---->產生異動記錄
      #FUN-A60095 mark(S)
      #CALL p880_log2('','',l_diffqty,l_date,l_sfb03,l_sfb27,l_sfa13,l_sfa012,l_sfa013,l_sfa27)  #FUN-A60095
      #IF g_success='N' THEN 
      #   CALL cl_err('ckp#2.9',9052,1)
      #   EXIT WHILE 
      #END IF
      #FUN-A60095 mark(E)
 #---->更新 [在製工單盤點標籤明細檔] 之 POSTING FLAG = 'Y'
    #END IF #FUN-A60095 mark
       #FUN-B40082 --START--
       IF l_diffqty <> 0 THEN                 
          IF l_diffqty > 0 THEN #盤盈
             LET p_type = '3'  #雜收
             LET p_type2 = '4' #發料                          
             IF l_diffqty > ( l_sfa05 - l_sfa06 ) THEN #超領 
                LET l_qty1 = l_sfa05 - l_sfa06  #發料數量
                LET l_qty2 = l_diffqty - l_qty1 #超領數量                           
             ELSE
                LET l_qty1 = l_diffqty
                LET l_qty2 = 0
             END IF
             #雜收單新增  
             IF NOT p880_ins_ina(p_type,l_diffqty,l_sfa12,l_ima25,l_ima15,l_smy79) THEN
                EXIT FOREACH
             END IF

             #雜收單確認、過帳          
             IF NOT p880_ina_chk_upd(p_type) THEN
                #EXIT FOREACH 
             END IF 
          
             #發料單新增
             IF l_qty1 > 0 THEN #TQC-B60302
                IF NOT p880_ins_sfp(p_type2,l_qty1,l_sfa01,l_sfa03,l_sfa08,
                                    l_sfa12,l_sfa012,l_sfa013,l_sfa27,l_smy79) THEN
                   EXIT FOREACH
                END IF
                
                #發料單確認、過帳          
                IF NOT p880_sfp_chk_upd(p_type2) THEN
                   EXIT FOREACH 
                END IF 
             END IF   #TQC-B60302

             #超領單新增
             IF l_qty2 > 0 THEN 
                LET p_type2 = '2'
                IF NOT p880_ins_sfp(p_type2,l_qty2,l_sfa01,l_sfa03,l_sfa08,
                                    l_sfa12,l_sfa012,l_sfa013,l_sfa27,l_smy79) THEN                
                   EXIT FOREACH
                END IF
                #超領單確認、過帳             
                IF NOT p880_sfp_chk_upd(p_type2) THEN
                   EXIT FOREACH 
                END IF 
             END IF  
          ELSE #盤虧
             LET p_type = '1'  #雜發
             LET p_type2 = '9' #退料             
             LET l_diffqty  = l_diffqty  * -1
             LET l_qty1 = l_diffqty  
             LET l_qty2 = 0        
             #退料單新增
             IF NOT p880_ins_sfp(p_type2,l_qty1,l_sfa01,l_sfa03,l_sfa08,
                                 l_sfa12,l_sfa012,l_sfa013,l_sfa27,l_smy79) THEN
                EXIT FOREACH
             END IF

             #退料單確認、過帳          
             IF NOT p880_sfp_chk_upd(p_type2) THEN
                EXIT FOREACH 
             END IF 

             #雜發單新增  
             IF NOT p880_ins_ina(p_type,l_diffqty,l_sfa12,l_ima25,l_ima15,l_smy79) THEN
                EXIT FOREACH
             END IF

             #雜發單確認、過帳 
             IF NOT p880_ina_chk_upd(p_type) THEN
                EXIT FOREACH 
             END IF 
          
          END IF
       END IF       
       #FUN-B40082 --END--       
       UPDATE pie_file
          SET pie16='Y' ,
              piedate = tm.posdate   #FUN-A60095
        WHERE pie01=g_pie.pie01 AND pie07=g_pie.pie07
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              LET g_success='N' 
               IF g_bgerr THEN                                                            #CHI-C80013 add
                 CALL s_errmsg('pie_file',g_pie.pie01,'ckp#2.10 upd pie',SQLCA.sqlcode,1) #CHI-C80013 add
              ELSE                                                                        #CHI-C80013 add
                 CALL cl_err3("upd","pie_file",g_pie.pie01,"",
                            SQLCA.sqlcode,"","(p880:ckp#2.10)",1)  #No.FUN-660156
              END IF                                                                      #CHI-C80013 add              
              #EXIT WHILE #FUN-B40082 mark 
           END IF
       #EXIT WHILE        #FUN-B40082 mark
    #END WHILE            #FUN-B40082 mark 
    IF tm.sw = 'N' THEN
       CALL cl_progressing(" ")
    END IF
 END FOREACH
 CALL s_showmsg()     #CHI-C80013 add
 LET g_prog = l_prog  #FUN-B40082
#str MOD-A70062 mark
#IF g_success = 'Y' THEN
#   COMMIT WORK
#ELSE
#   CALL cl_rbmsg(4) ROLLBACK WORK
#END IF
#end MOD-A70062 mark
END FUNCTION 
   
FUNCTION p880_err(p_tag,p_part,p_code)
 DEFINE  p_tag    LIKE pif_file.pif01,  #FUN-5A0199 10碼放大成16碼 #No.FUN-690026 VARCHAR(16)
         p_part   LIKE pia_file.pia02,  #NO.MOD-490217
         p_code   LIKE ze_file.ze01,    #No.FUN-690026 VARCHAR(07)
         l_str    LIKE ze_file.ze03     #No.FUN-690026 VARCHAR(40)
 
 CALL cl_getmsg(p_code,g_lang) RETURNING l_str
 INSERT INTO pif_file VALUES(p_tag,p_part,l_str,g_plant,g_legal) #No.FUN-980004
 IF SQLCA.sqlcode THEN 
    IF g_bgerr THEN                                              #CHI-C80013 add
       CALL s_errmsg('pif_file',p_tag,'ins pif',SQLCA.sqlcode,1) #CHI-C80013 add
    ELSE                                                         #CHI-C80013 add
       CALL cl_err3("ins","pif_file",p_tag,"",SQLCA.sqlcode,"","insert pif_file error",1)   #NO.FUN-640266  #No.FUN-660156
    END IF                                                       #CHI-C80013 add
    LET g_success = 'N'    #NO.TQC-930155----add----   
 END IF
END FUNCTION 
 
#處理現有庫存異動記錄
FUNCTION p880_log(p_stdc,p_reason,p_item,p_qty,p_date)
DEFINE
    l_pmn02         LIKE pmn_file.pmn02, #採購單性質
    p_stdc          LIKE type_file.num10, 		     #是否需取得標準成本  #No.FUN-690026 INTEGER
    p_reason        LIKE type_file.num10, 		     #是否需取得異動原因  #No.FUN-690026 INTEGER
    p_item          LIKE pia_file.pia01, #No.MOD-490217
#   p_qty           LIKE ima_file.ima26, #MOD-530179	     #異動數量   #FUN-A20044
    p_qty           LIKE type_file.num15_3, #FUN-A20044              
    l_ima25         LIKE ima_file.ima25,
    l_flag          LIKE type_file.num10,  #No.FUN-690026 INTEGER
    p_date          LIKE type_file.dat     #No.FUN-690026 DATE
DEFINE l_img09      LIKE img_file.img09,     #MOD-CA0151 add
       l_fac        LIKE ima_file.ima31_fac  #MOD-CA0151 add
 
    IF g_img.img10 IS NULL THEN LET g_img.img10=0 END IF
    IF g_pia.pia04 IS NULL THEN LET g_pia.pia04=' ' END IF
    IF g_pia.pia05 IS NULL THEN LET g_pia.pia05=' ' END IF
    IF p_qty < 0     
    THEN 
        LET l_qty      =p_qty * -1
        #----來源----
        LET g_tlf.tlf02=50         	             #來源為倉庫(盤虧)
        LET g_tlf.tlf020=g_plant                 #工廠別
        LET g_tlf.tlf021=g_pia.pia03  	         #倉庫別
        LET g_tlf.tlf022=g_pia.pia04  	         #儲位別
        LET g_tlf.tlf023=g_pia.pia05  	         #入庫批號
        LET g_tlf.tlf024=g_pia.pia30             #(+/-)異動後庫存數量
        LET g_tlf.tlf025=g_pia.pia09             #庫存單位(ima or img) #TQC-660091     
    	LET g_tlf.tlf026=g_pia.pia01             #參考單据(盤點單)
    	LET g_tlf.tlf027=''
        #----目的----
        LET g_tlf.tlf03=0          	 	         #目的為盤點
        LET g_tlf.tlf030=g_plant       	         #工廠別
        LET g_tlf.tlf031=''            	         #倉庫別
        LET g_tlf.tlf032=''         	         #儲位別
        LET g_tlf.tlf033=''         	         #批號
        LET g_tlf.tlf034=''                      #異動後庫存數量
    	LET g_tlf.tlf035=''                   
    	LET g_tlf.tlf036='Physical'     
    	LET g_tlf.tlf037=''
 
        LET g_tlf.tlf15=''                       #貸方會計科目(盤虧)
        LET g_tlf.tlf16=g_pia.pia07              #料件會計科目(存貨)
    ELSE 
        LET l_qty      =p_qty
        #----來源----
        LET g_tlf.tlf02=0          	             #來源為盤點(盤盈)
        LET g_tlf.tlf020=g_plant       	         #倉庫別
        LET g_tlf.tlf021=''            	         #倉庫別
        LET g_tlf.tlf022=''         	         #儲位別
        LET g_tlf.tlf023=''         	         #批號
        LET g_tlf.tlf024=''                      #異動後庫存數量
    	LET g_tlf.tlf025=''                   
    	LET g_tlf.tlf026='Physical'     
    	LET g_tlf.tlf027=''
        #----目的----
        LET g_tlf.tlf03=50         	 	         #目的為倉庫
        LET g_tlf.tlf030=g_plant      	         #工廠別
        LET g_tlf.tlf031=g_pia.pia03  	         #倉庫別
        LET g_tlf.tlf032=g_pia.pia04  	         #儲位別
        LET g_tlf.tlf033=g_pia.pia05  	         #入庫批號
        LET g_tlf.tlf034=g_pia.pia30             #(+/-)異動後庫存數量
        LET g_tlf.tlf035=g_pia.pia09             #庫存單位(ima or img)
    	LET g_tlf.tlf036=g_pia.pia01             #參考單据
    	LET g_tlf.tlf037=''
 
        LET g_tlf.tlf15=g_pia.pia07          #料件會計科目(存貨)
        LET g_tlf.tlf16=' '                  #貸方會計科目(盤盈)
    END IF
 
    LET g_tlf.tlf01=g_pia.pia02     	     #異動料件編號
##--->異動數量
    LET g_tlf.tlf04=' '                      #工作站
    LET g_tlf.tlf05=' '                      #作業序號
    LET g_tlf.tlf06=p_date                   #盤點日期
    LET g_tlf.tlf07=g_today                  #異動資料產生日期  
    LET g_tlf.tlf08=TIME                     #異動資料產生時:分:秒
    LET g_tlf.tlf09=g_user                   #產生人
    LET g_tlf.tlf10=l_qty                    #異動數量
    LET g_tlf.tlf11=g_pia.pia09              #庫存單位    #No.FUN-8A0147
   #MOD-CA0151------S
    LET l_img09 =''
    IF g_pia.pia16= 'Y' THEN
       SELECT img09 INTO l_img09 FROM img_file
        WHERE img01= g_pia.pia02
          AND img02= g_pia.pia03
       CALL s_umfchk(g_pia.pia02,l_img09,g_pia.pia09)
            RETURNING l_flag,l_fac
       IF l_flag = 1 THEN    #無此轉換率
           LET g_success = 'N'
           CALL cl_err(g_pia.pia01,'abm-731',1)
           LET l_fac = 1
       END IF
       LET g_tlf.tlf12 = l_fac
    ELSE
       LET g_tlf.tlf12=1                        #單位轉換率  #No.MOD-610134 add
    END IF
   #MOD-CA0151------E
    LET g_tlf.tlf13='aimp880'                #異動命令代號
    #LET g_tlf.tlf14=''                       #異動原因      #FUN-CB0087 mark
    LET g_tlf.tlf14=tm.inb15                                 #FUN-CB0087 add
    CALL s_imaQOH(g_pia.pia02)
         RETURNING g_tlf.tlf18               #異動後總庫存量
    LET g_tlf.tlf19= ' '                     #異動廠商/客戶編號
    LET g_tlf.tlf20= ' '                     #project no.      
    LET g_tlf.tlf930=g_pia.pia930            #FUN-670093    
    CALL s_tlf(p_stdc,p_reason)
    CALL p880_updtlfs()                      #No.FUN-8A0147
END FUNCTION
 
FUNCTION p880_upimgs(p_qty,p_date)
DEFINE p_qty    LIKE imgs_file.imgs08    
DEFINE p_date   LIKE imgs_file.imgs09   
DEFINE l_imgs   RECORD LIKE imgs_file.*  
DEFINE l_sql    STRING
DEFINE l_n      LIKE type_file.num5         
DEFINE l_qty    LIKE imgs_file.imgs08      
DEFINE l_qty2   LIKE imgs_file.imgs08     
DEFINE l_diff2  LIKE imgs_file.imgs08     
 
   IF g_success = "N" THEN
      RETURN
   END IF
 
   LET l_imgs.imgs08 = NULL
   
      LET l_sql = "SELECT * FROM pias_file ",
                  " WHERE pias01 = '",g_pia.pia01,"' " 
      
      PREPARE pias1_pre FROM l_sql
      DECLARE pias1_cs CURSOR FOR pias1_pre
      
      FOREACH pias1_cs INTO g_pias.*
         IF STATUS THEN 
            IF g_bgerr THEN 
               CALL s_errmsg('','','foreach:',STATUS,1)
            ELSE
               CALL cl_err('foreach:',STATUS,1)
            END IF
            EXIT FOREACH
         END IF
      
         LET l_imgs.imgs01 = g_pias.pias02
         LET l_imgs.imgs02 = g_pias.pias03
         LET l_imgs.imgs03 = g_pias.pias04
         LET l_imgs.imgs04 = g_pias.pias05
         LET l_imgs.imgs05 = g_pias.pias06
         LET l_imgs.imgs06 = g_pias.pias07
         LET l_imgs.imgs07 = g_pias.pias10
         LET l_imgs.imgs09 = p_date
         LET l_imgs.imgs10 = ''
         LET l_imgs.imgs11 = ' '
 
         LET l_imgs.imgs08 = NULL
 
         LET l_imgs.imgsplant = g_plant
         LET l_imgs.imgslegal = g_legal
      
         IF g_pias.pias50 IS NOT NULL THEN LET g_pias.pias30 = g_pias.pias50 END IF
         LET l_qty  = g_pias.pias30  * g_pias.pias10  #料件(ima)數量
         LET l_qty2 = g_pias.pias30                 #倉庫(imgs)數量
         LET l_imgs.imgs08 = l_qty2   #MOD-D30051
 
         SELECT COUNT(*) INTO l_n FROM imgs_file 
          WHERE imgs01 = l_imgs.imgs01
            AND imgs02 = l_imgs.imgs02
            AND imgs03 = l_imgs.imgs03
            AND imgs04 = l_imgs.imgs04
            AND imgs05 = l_imgs.imgs05
            AND imgs06 = l_imgs.imgs06
            AND imgs11 = l_imgs.imgs11
         
         IF l_n = 0 THEN
             
            #INSERT INTO imgs_file VALUES(l_imgs.imgs01,l_imgs.imgs02,l_imgs.imgs03,l_imgs.imgs04, #MOD-D30051
            #                             l_imgs.imgs05,l_imgs.imgs06,l_imgs.imgs07,l_qty2,  #MOD-D30051
            #                             l_imgs.imgs09,l_imgs.imgs10,l_imgs.imgs11,l_imgs.imgsplant,l_imgs.imgslegal) #No.FUN-980004  #MOD-D30051
            INSERT INTO imgs_file VALUES(l_imgs.*) #MOD-D30051
            
            IF SQLCA.sqlcode THEN
               LET g_success='N' 
               IF g_bgerr THEN
                  CALL s_errmsg('imgs01',l_imgs.imgs01,'(s_upimgs)',SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("ins","imgs_file","","",SQLCA.sqlcode,"","s_upimgs",1)
               END IF
               RETURN
            END IF
         ELSE
            #數量差量(imgs_file 庫存單位)
            LET l_diff2 = l_qty2 - g_pias.pias09    
            LET g_sql = "SELECT imgs08 FROM imgs_file ",      
                        " WHERE imgs01 = '",l_imgs.imgs01,"' ",  
                        "   AND imgs02 = '",l_imgs.imgs02,"' ", 
                        "   AND imgs03 = '",l_imgs.imgs03,"' ",
                        "   AND imgs04 = '",l_imgs.imgs04,"' ", 
                        "   AND imgs05 = '",l_imgs.imgs05,"' ", 
                        "   AND imgs06 = '",l_imgs.imgs06,"' ", 
                        "   AND imgs11 = '",l_imgs.imgs11,"' ", 
                        "  FOR UPDATE "                  
            LET g_sql=cl_forupd_sql(g_sql)

            DECLARE img_lock_t2 CURSOR FROM g_sql       
            OPEN img_lock_t2                           
            IF STATUS THEN                            
               CALL cl_err("OPEN img_lock_t2:", STATUS, 1) 
               CLOSE img_lock_t2                          
               LET g_success = 'N'                       
               RETURN                                   
            END IF                                     
            FETCH img_lock_t2 INTO l_imgs.imgs08      
            IF STATUS OR l_imgs.imgs08 IS NULL THEN
               LET g_success='N'
               IF g_bgerr THEN
                  CALL s_errmsg('ima01',l_imgs.imgs01,'imgs_file','asf-375',1)
               ELSE
                  CALL cl_err('imgs_file','asf-375',1)
               END IF
               RETURN
            ELSE
               IF cl_null(l_imgs.imgs08) THEN LET l_imgs.imgs08 = 0 END IF
               LET l_imgs.imgs08 = l_imgs.imgs08 + l_diff2
               UPDATE imgs_file
                  SET imgs08=l_imgs.imgs08       #庫存數量
                WHERE imgs01 = l_imgs.imgs01
                  AND imgs02 = l_imgs.imgs02
                  AND imgs03 = l_imgs.imgs03
                  AND imgs04 = l_imgs.imgs04
                  AND imgs05 = l_imgs.imgs05
                  AND imgs06 = l_imgs.imgs06
                  AND imgs11 = l_imgs.imgs11
               
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                  LET g_success='N' 
                  IF g_bgerr THEN
                     CALL s_errmsg('ima01',l_imgs.imgs01,'upd imgs','asf-375',1)
                  ELSE
                     CALL cl_err('upd imgs','asf-375',1)
                  END IF
                  RETURN
               END IF
            END IF 
         END IF
         
      END FOREACH
 
END FUNCTION
 
 
FUNCTION p880_updtlfs()
DEFINE l_tlfs   RECORD LIKE tlfs_file.*  
DEFINE l_sql    STRING
DEFINE l_qty    LIKE tlfs_file.tlfs13
DEFINE l_qty2   LIKE tlfs_file.tlfs13
DEFINE l_diff2  LIKE tlfs_file.tlfs13
 
 
   IF g_success = "N" THEN
      RETURN
   END IF
 
   LET l_sql = "SELECT * FROM pias_file ",
               " WHERE pias01 = '",g_pia.pia01,"' " 
   
   PREPARE pias2_pre FROM l_sql
   DECLARE pias2_cs CURSOR FOR pias2_pre
   
   FOREACH pias2_cs INTO g_pias.*
      IF STATUS THEN 
         IF g_bgerr THEN 
            CALL s_errmsg('','','foreach:',STATUS,1)
         ELSE
            CALL cl_err('foreach:',STATUS,1)
         END IF
         EXIT FOREACH
      END IF
      
      IF g_pias.pias50 IS NOT NULL THEN LET g_pias.pias30 = g_pias.pias50 END IF
      LET l_qty  = g_pias.pias30  * g_pias.pias10  #料件(ima)數量
      LET l_qty2 = g_pias.pias30                 #倉庫(imgs)數量
      #數量差量(imgs_file 庫存單位)
      LET l_diff2 = l_qty2 - g_pias.pias09    
 
      LET l_tlfs.tlfs01 = g_pias.pias02
      LET l_tlfs.tlfs02 = g_pias.pias03
      LET l_tlfs.tlfs03 = g_pias.pias04
      LET l_tlfs.tlfs04 = g_pias.pias05
      LET l_tlfs.tlfs05 = g_pias.pias06
      LET l_tlfs.tlfs06 = g_pias.pias07
      LET l_tlfs.tlfs07 = g_pias.pias10
      LET l_tlfs.tlfs08 = 'aimp880'
      LET l_tlfs.tlfs10 = g_pias.pias01    
      LET l_tlfs.tlfs11 = ''
      LET l_tlfs.tlfs111 = g_tlf.tlf06  
      LET l_tlfs.tlfs12 = g_tlf.tlf07 
      IF l_diff2 <0 THEN 
         LET l_tlfs.tlfs09 = -1
         LET l_tlfs.tlfs13 = l_diff2 * -1
      ELSE
         LET l_tlfs.tlfs09 = 1
         LET l_tlfs.tlfs13 = l_diff2
      END IF
      LET l_tlfs.tlfs14 = ''
      LET l_tlfs.tlfs15 = ' '   #CHI-C10036加空白
 
      LET l_tlfs.tlfsplant = g_plant
      LET l_tlfs.tlfslegal = g_legal
 
      INSERT INTO tlfs_file VALUES(l_tlfs.*)
 
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         IF g_bgerr THEN
            CALL s_errmsg('tlfs01',l_tlfs.tlfs01,'s_tlfs:ins tlfs',STATUS,1)
         ELSE
             CALL cl_err3("sel","tlfs_file",l_tlfs.tlfs01,"",STATUS,"","",1)
         END IF
         LET g_success='N'
         RETURN
      ELSE
         #---->更新 [盤點標籤明細檔] 之 POSTING FLAG = 'Y'
         UPDATE pias_file
            SET pias19='Y'
           WHERE pias01 = g_pia.pia01
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            LET g_success='N' 
            CALL cl_err3("upd","pias_file",g_pias.pias01,"",SQLCA.sqlcode,"","(p880_pias:ckp#9)",1)  
            RETURN
         END IF
      END IF
 
   END FOREACH
 
 
END FUNCTION
 
#處理在製工單異動記錄
#FUN-A60095 mark(S)
#FUNCTION p880_log2(p_stdc,p_reason,p_qty,p_date,p_credit,p_project,p_sfa13,p_sfa012,p_sfa013,p_sfa27)  #FUN-A60095
#DEFINE
#    l_pmn02         LIKE pmn_file.pmn02,     #採購單性質
#    p_stdc          LIKE type_file.num10,    #是否需取得標準成本  #No.FUN-690026 INTEGER
#    p_reason        LIKE type_file.num10,    #是否需取得異動原因  #No.FUN-690026 INTEGER
##   p_qty           LIKE ima_file.ima26,     #MOD-530179  #異動數量  #FUN-A20044
#    p_qty           LIKE type_file.num15_3,                          #FUN-A20044
#    p_date          LIKE type_file.dat,      #異動日期    #No.FUN-690026 DATE
#    p_credit        LIKE tlf_file.tlf15,     #會計科目
#    p_project       LIKE tlf_file.tlf20,
#    p_sfa13         LIKE sfa_file.sfa13,
#    p_sfa012        LIKE sfa_file.sfa012,    #FUN-A60095
#    p_sfa013        LIKE sfa_file.sfa013,    #FUN-A60095
#    p_sfa27         LIKE sfa_file.sfa27      #FUN-A60095
# 
#    IF p_sfa13 IS NULL OR p_sfa13 = ' '
#    THEN LET p_sfa13 = 1
#    END IF
#    IF p_qty < 0     
#    THEN 
#        LET l_qty       =p_qty * -1
#        LET g_tlf.tlf02 =60        	         #來源為工單(盤虧)
#	    LET g_tlf.tlf026=g_pid.pid02         #參考單据(工單編號)
#    	LET g_tlf.tlf027=' '                 #項次
#        LET g_tlf.tlf03 =0         	 	     #目的為盤點
#    	LET g_tlf.tlf036=g_pie.pie01         #參考單據(盤點單號)
#    	LET g_tlf.tlf037=g_pie.pie07         #項次
#        LET g_tlf.tlf15 =''                  #貸方會計科目(盤虧)
#        LET g_tlf.tlf16 =p_credit            #料件會計科目(存貨)
#    ELSE 
#        LET l_qty      =p_qty     
#        LET g_tlf.tlf02=0          	         #來源為盤點(盤盈)
#    	LET g_tlf.tlf026=g_pie.pie01         #參考單據(盤點單號)
#    	LET g_tlf.tlf027=g_pie.pie07         #項次
#        LET g_tlf.tlf03=60         	 	     #目的為工單
#	    LET g_tlf.tlf036=g_pid.pid02         #參考單据(工單編號)
#    	LET g_tlf.tlf037=' '                 #項次
#        LET g_tlf.tlf15=p_credit             #料件會計科目(存貨)
#        LET g_tlf.tlf16=''                   #貸方會計科目(盤盈)
#    END IF
# 
##----來源----
#    LET g_tlf.tlf01=g_pie.pie02        	 #異動料件編號
# 
#    LET g_tlf.tlf021=' '          	     #倉庫別
#    LET g_tlf.tlf022=' '                 #儲位別
#    LET g_tlf.tlf023=' '          	     #入庫批號
#    LET g_tlf.tlf024=' '                 #異動後庫存數量
#    LET g_tlf.tlf025=' '                 #庫存單位(ima_file or img_file)
##----目的----
#    LET g_tlf.tlf031=''            	     #倉庫別
#    LET g_tlf.tlf032=''         	     #儲位別
#    LET g_tlf.tlf033=''         	     #批號
#    LET g_tlf.tlf034=''                  #異動後庫存數量
#	LET g_tlf.tlf035=''                  #庫存單位(ima_file or img_file)
# 
##--->異動數量
#    LET g_tlf.tlf04=g_pie.pie05          #工作站
#    LET g_tlf.tlf05=g_pie.pie03          #作業編號
#    LET g_tlf.tlf06=p_date               #盤點日期
#    LET g_tlf.tlf07=g_today              #異動資料產生日期  
#    LET g_tlf.tlf08=TIME                 #異動資料產生時:分:秒
#    LET g_tlf.tlf09=g_user               #產生人
#    LET g_tlf.tlf10=l_qty                #異動數量
#    LET g_tlf.tlf11=g_pie.pie04          #異動單位
#    LET g_tlf.tlf12=p_sfa13              #(發料/庫存轉換率)
#    LET g_tlf.tlf13='aimp880'            #異動命令代號
#    LET g_tlf.tlf14=''                   #異動原因
#    CALL s_imaQOH(g_pie.pie02)         
#         RETURNING g_tlf.tlf18           #異動後總庫存量
#	  LET g_tlf.tlf19=' '                  #異動廠商/客戶編號
#	  LET g_tlf.tlf20=p_project            #專案號碼         
#	  LET g_tlf.tlf930=g_pia.pia930        #FUN-670093
#	  LET g_tlf.tlf012=p_sfa012            #FUN-A60095
#	  LET g_tlf.tlf013=p_sfa013            #FUN-A60095
#	  LET g_tlf.tlf27 =p_sfa27             #FUN-A60095
#    CALL s_tlf(p_stdc,p_reason)
#END FUNCTION
#FUN-A60095 mark(E)

FUNCTION p880_multi_unit()
   DEFINE l_name	LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#         l_qty         LIKE ima_file.ima26,    #MOD-530179       #FUN-A20044
          l_qty         LIKE type_file.num15_3,                   #FUN-A20044
          l_img09       LIKE img_file.img09,
          l_sw          LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_factor      LIKE img_file.img21,
          l_ima906      LIKE ima_file.ima906,
          l_ima907      LIKE ima_file.ima907,
          l_date        LIKE type_file.dat,     #No.FUN-690026 DATE
          l_imgg07      LIKE imgg_file.imgg07,
          l_imgg20      LIKE imgg_file.imgg20,
          l_imgg34      LIKE imgg_file.imgg34,
          l_imf04       LIKE imf_file.imf04,
          l_ime         RECORD LIKE ime_file.*,
          l_sql         LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(600)
 
#======================== 多單位現有庫存 ===========================
     IF tm.stk = 'N' THEN RETURN END IF
     LET l_sql = "SELECT piaa_file.* ",
                 " FROM  piaa_file",
                 "   WHERE (piaa19 = 'N' OR piaa19 IS NULL )",
                 "   AND (piaa02 IS NOT NULL AND piaa02 != ' ')",
                 "   AND (piaa03 IS NOT NULL AND piaa03 != ' ')",
                 "   AND (piaa09 IS NOT NULL AND piaa09 != ' ')",
                 "   AND (piaa30 IS NOT NULL OR piaa50 IS NOT NULL) ",
                 "   AND ",gs_wc.trim(),
                 "   FOR UPDATE "
     LET l_sql=cl_forupd_sql(l_sql)
 
     PREPARE p880_pre1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_batch_bg_javamail("N")     #FUN-570122
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE p880_mcs1 CURSOR FOR p880_pre1
 
     #處理要點:1.當初盤與複盤數量皆為NULL時,不更新其庫存數量
     #         2.更新數量以複盤數量為主,當複盤數量為NULL時,才以初盤數量更新
     #         3.若資料不存在於[倉庫庫存明細檔]中,則必須新增一筆[倉庫庫存明細]
     #         4.數量更新時,必須考慮是否為可用倉,及MRP/MPS可用否
    #BEGIN WORK   #MOD-A70062 mark
     #LET g_success = 'Y'  #No.MOD-930040 add #FUN-B70032 mark 外層已有=Y 此處再給Y會蓋掉其它FUNC給的N
     FOREACH p880_mcs1 INTO g_piaa.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1) 
          LET g_success = 'N'                    #TQC-930155
          EXIT FOREACH 
       END IF
       IF tm.sw = 'Y' OR g_bgjob = 'N' THEN  #NO.FUN-570122 
       MESSAGE g_piaa.piaa01,' ',g_piaa.piaa02,' ',g_piaa.piaa09
       CALL ui.Interface.refresh()
       END IF  #NO.FUN-570122 
       WHILE TRUE
         IF g_piaa.piaa04 IS NULL THEN LET g_piaa.piaa04=' ' END IF
         IF g_piaa.piaa05 IS NULL THEN LET g_piaa.piaa05=' ' END IF
         #-->倉庫檢查 
         IF g_piaa.piaa03 IS NULL OR g_piaa.piaa03 = ' ' THEN
            CALL p880_err(g_piaa.piaa01,g_piaa.piaa02,'mfg0142')
            LET g_success ='N'
            EXIT WHILE
         END IF
         #-->轉換率檢查 
         IF g_piaa.piaa10 IS NULL OR g_piaa.piaa10 = ' ' OR g_piaa.piaa10 = 0 THEN
            CALL p880_err(g_piaa.piaa01,g_piaa.piaa02,'mfg0142')
            LET g_success  ='N'
            EXIT WHILE
         END IF
         #-->單位檢查 
         IF g_piaa.piaa09 IS NULL OR g_piaa.piaa03 = ' ' THEN
            CALL p880_err(g_piaa.piaa01,g_piaa.piaa02,'mfg0142')
            LET g_success ='N'
            EXIT WHILE
         END IF 
 
         #---->決定盤點數量
         IF g_piaa.piaa50 IS NOT NULL THEN LET g_piaa.piaa30 = g_piaa.piaa50 END IF
         LET l_qty2 = g_piaa.piaa30                 #倉庫(imgg)數量
         #-->如有盤點日期則以此為基準
         IF tm.posdate IS NOT NULL AND tm.posdate !=' '
         THEN LET l_date = tm.posdate 
         ELSE LET l_date = g_today
         END IF
         #-->倉庫數量
         IF l_qty2 IS NULL OR l_qty2 = ' ' THEN
            CALL p880_err(g_piaa.piaa01,g_piaa.piaa02,'mfg0144')
            LET g_success  ='N'
            EXIT WHILE
         END IF
 
         SELECT ima906,ima907 INTO l_ima906,l_ima907 FROM ima_file
          WHERE ima01=g_piaa.piaa02
         #---->讀取倉庫明細資料
         LET g_sql ="SELECT imgg_file.* FROM imgg_file ",
                   #"  FROM imgg_file ", #MOD-980095
                    "  WHERE imgg01 = '",g_piaa.piaa02,"' ",                                                                        
                    "    AND imgg02 = '",g_piaa.piaa03,"' ",                                                                        
                    "    AND imgg03 = '",g_piaa.piaa04,"' ",                                                                        
                    "    AND imgg04 = '",g_piaa.piaa05,"' ",                                                                        
                    "    AND imgg09 = '",g_piaa.piaa09,"' ",                                                                        
                    "    FOR UPDATE "                                                                                               
         LET g_sql=cl_forupd_sql(g_sql)

         DECLARE img_lock_t3 CURSOR FROM g_sql                                                                                      
         OPEN img_lock_t3                                                                                                           
         IF STATUS THEN                                                                                                             
            CALL cl_err("OPEN img_lock_t3:", STATUS, 1)                                                                             
            CLOSE img_lock_t3                                                                                                       
            LET g_success = 'N'                                                                                                     
            EXIT WHILE                                                                                                              
         END IF                                                                                                                     
         FETCH img_lock_t3 INTO g_imgg.*                                                                               
         #不存在時, insert 一筆資料
         IF SQLCA.sqlcode THEN  
            IF SQLCA.sqlcode <> 100 THEN                                                                                            
               CALL cl_err("fetch img_file",STATUS, 1)                                                                              
               CLOSE img_lock_t3                                                                                                    
               LET g_success = 'N'                                                                                                  
               EXIT WHILE                                                                                                           
            END IF
            SELECT img09 INTO l_img09 FROM img_file
             WHERE img01=g_piaa.piaa02 AND img02=g_piaa.piaa03
               AND img03=g_piaa.piaa04 AND img04=g_piaa.piaa05
            LET l_factor = 1
            IF l_img09 <> g_piaa.piaa09 THEN
               CALL s_umfchk(g_piaa.piaa02,g_piaa.piaa09,l_img09)
                    RETURNING l_sw,l_factor
               IF l_sw = 1 AND NOT (l_ima906='3' AND l_ima907=g_piaa.piaa09) THEN
                  LET g_success='N'
                  CALL cl_err('imgg09/img09','mfg3075',1)
                  EXIT WHILE
               END IF
            END IF
            CALL s_add_imgg(g_piaa.piaa02,g_piaa.piaa03,           
                            g_piaa.piaa04,g_piaa.piaa05,
                            g_piaa.piaa09,l_factor,         
                            g_piaa.piaa01,'',g_piaa.piaa10) RETURNING l_sw
            IF l_sw = 1 THEN
               LET g_success='N'
               CALL cl_err('add_imgg',SQLCA.sqlcode,1)
               EXIT WHILE
            END IF  

           #MOD-C70091 str add-----
            #---->更新庫存明細檔
            CALL s_upimgg(g_piaa.piaa02,g_piaa.piaa03,g_piaa.piaa04,g_piaa.piaa05,g_piaa.piaa09,
                          2,l_qty2,l_date,
                          g_piaa.piaa02,g_piaa.piaa03,g_piaa.piaa04,g_piaa.piaa05,'','','','',g_piaa.piaa09,'',l_factor,'','','','','','','',g_piaa.piaa10)
            IF g_success ='N' THEN EXIT WHILE END IF
           #MOD-C70091 end add----- 

            #---->產生一筆異動資料
            IF l_qty2 != 0 THEN 
               CALL p880_tlff('','',g_piaa.piaa02,l_qty2,l_date)
               IF g_success ='N' THEN 
                  CALL cl_err('(p880_1:log)',SQLCA.sqlcode,1)
                  EXIT WHILE 
               END IF
            END IF
         ELSE
            IF g_imgg.imgg10 IS NULL OR g_imgg.imgg10 = ' ' THEN
               CALL p880_err(g_piaa.piaa01,g_piaa.piaa02,'mfg0146')
               LET g_success  ='N'
               EXIT WHILE
            END IF
            #數量差量(imgg_file 庫存單位)
            LET g_diff2 = l_qty2 - g_piaa.piaa08    
 
            SELECT img09 INTO l_img09 FROM img_file
             WHERE img01=g_piaa.piaa02 AND img02=g_piaa.piaa03
               AND img03=g_piaa.piaa04 AND img04=g_piaa.piaa05
            LET l_factor = 1
            IF l_img09 <> g_piaa.piaa09 THEN
               CALL s_umfchk(g_piaa.piaa02,g_piaa.piaa09,l_img09)
                    RETURNING l_sw,l_factor
               IF l_sw = 1 AND NOT (l_ima906='3' AND l_ima907=g_piaa.piaa09) THEN
                  LET g_success='N'
                  CALL cl_err('imgg09/img09','mfg3075',1)
                  EXIT WHILE
               END IF
            END IF
 
            #---->更新庫存明細檔
            CALL s_upimgg(g_piaa.piaa02,g_piaa.piaa03,g_piaa.piaa04,g_piaa.piaa05,g_piaa.piaa09, #FUN-8C0084
                          2,g_diff2,l_date,                          
                          g_piaa.piaa02,g_piaa.piaa03,g_piaa.piaa04,g_piaa.piaa05,'','','','',g_piaa.piaa09,'',l_factor,'','','','','','','',g_piaa.piaa10)
            IF g_success ='N' THEN EXIT WHILE END IF
 
            #---->產生一筆異動資料
            CALL p880_tlff('','',g_piaa.piaa02,g_diff2,l_date)
            IF g_success='N' THEN EXIT WHILE END IF
         END IF
 
         #---->更新 [盤點標籤明細檔] 之 POSTING FLAG = 'Y'
         UPDATE piaa_file
            SET piaa19='Y'
          WHERE piaa01=g_piaa.piaa01 AND piaa09=g_piaa.piaa09
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            LET g_success='N' 
            CALL cl_err3("upd","piaa_file","","",
                          SQLCA.sqlcode,"","(p880_1:ckp#9)",1)  #No.FUN-660156
            EXIT WHILE 
         END IF
         EXIT WHILE
       END WHILE 
    END FOREACH
   #str MOD-A70062 mark
   #IF g_success = 'Y' THEN
   #   COMMIT WORK
   #ELSE
   #   CALL cl_rbmsg(4)
   #   ROLLBACK WORK
   #END IF
   #end MOD-A70062 mark
END FUNCTION
 
#處理多單位現有庫存異動記錄
FUNCTION p880_tlff(p_stdc,p_reason,p_item,p_qty,p_date)
DEFINE
    l_pmn02         LIKE pmn_file.pmn02,    #採購單性質
    p_stdc          LIKE type_file.num10,   #是否需取得標準成本  #No.FUN-690026 INTEGER
    p_reason        LIKE type_file.num10,   #是否需取得異動原因  #No.FUN-690026 INTEGER
    p_item          LIKE piaa_file.piaa01,  #NO.MOD-490217
#   p_qty           LIKE ima_file.ima26,    #MOD-530179	     #異動數量  #FUN-A20044
    p_qty           LIKE type_file.num15_3,                             #FUN-A20044
    l_ima25         LIKE ima_file.ima25,
    l_flag          LIKE type_file.num10,   #No.FUN-690026 INTEGER
    p_date          LIKE type_file.dat      #No.FUN-690026 DATE
 
    IF g_imgg.imgg10 IS NULL THEN LET g_imgg.imgg10=0 END IF
    IF p_qty < 0 THEN 
       LET l_qty =p_qty * -1
       #----來源----
       LET g_tlff.tlff02=50         	             #來源為倉庫(盤虧)
       LET g_tlff.tlff020=g_plant                    #工廠別
       LET g_tlff.tlff021=g_piaa.piaa03  	     #倉庫別
       LET g_tlff.tlff022=g_piaa.piaa04  	     #儲位別
       LET g_tlff.tlff023=g_piaa.piaa05  	     #入庫批號
       LET g_tlff.tlff024=g_piaa.piaa30              #(+/-)異動後庫存數量
       LET g_tlff.tlff025=g_piaa.piaa09              #庫存單位(ima or imgg)
       LET g_tlff.tlff026=g_piaa.piaa01              #參考單据(盤點單)
       LET g_tlff.tlff027=''
        #----目的----
       LET g_tlff.tlff03=0          	 	     #目的為盤點
       LET g_tlff.tlff030=g_plant       	     #工廠別
       LET g_tlff.tlff031=''            	     #倉庫別
       LET g_tlff.tlff032=''         	             #儲位別
       LET g_tlff.tlff033=''         	             #批號
       LET g_tlff.tlff034=''                         #異動後庫存數量
       LET g_tlff.tlff035=''                   
       LET g_tlff.tlff036='Physical'     
       LET g_tlff.tlff037=''
 
       LET g_tlff.tlff15=''                          #貸方會計科目(盤虧)
       LET g_tlff.tlff16=g_piaa.piaa07               #料件會計科目(存貨)
    ELSE 
       LET l_qty      =p_qty
       #----來源----
       LET g_tlff.tlff02=0          	             #來源為盤點(盤盈)
       LET g_tlff.tlff020=g_plant       	     #倉庫別
       LET g_tlff.tlff021=''            	     #倉庫別
       LET g_tlff.tlff022=''         	             #儲位別
       LET g_tlff.tlff023=''         	             #批號
       LET g_tlff.tlff024=''                         #異動後庫存數量
       LET g_tlff.tlff025=''                   
       LET g_tlff.tlff026='Physical'     
       LET g_tlff.tlff027=''
       #----目的----
       LET g_tlff.tlff03=50         	 	     #目的為倉庫
       LET g_tlff.tlff030=g_plant      	             #工廠別
       LET g_tlff.tlff031=g_piaa.piaa03  	     #倉庫別
       LET g_tlff.tlff032=g_piaa.piaa04  	     #儲位別
       LET g_tlff.tlff033=g_piaa.piaa05  	     #入庫批號
       LET g_tlff.tlff034=g_piaa.piaa30              #(+/-)異動後庫存數量
       LET g_tlff.tlff035=g_piaa.piaa09              #庫存單位(ima or imgg)
       LET g_tlff.tlff036=g_piaa.piaa01              #參考單据
       LET g_tlff.tlff037=''
 
       LET g_tlff.tlff15=g_piaa.piaa07               #料件會計科目(存貨)
       LET g_tlff.tlff16=' '                         #貸方會計科目(盤盈)
    END IF
 
    LET g_tlff.tlff01=g_piaa.piaa02     	     #異動料件編號
#--->異動數量
    LET g_tlff.tlff04=' '                            #工作站
    LET g_tlff.tlff05=' '                            #作業序號
    LET g_tlff.tlff06=p_date                         #盤點日期
    LET g_tlff.tlff07=g_today                        #異動資料產生日期  
    LET g_tlff.tlff08=TIME                           #異動資料產生時:分:秒
    LET g_tlff.tlff09=g_user                         #產生人
    LET g_tlff.tlff10=l_qty                          #異動數量
    LET g_tlff.tlff11=g_piaa.piaa09                  #庫存單位
    LET g_tlff.tlff12=1                              #單位轉換率
    LET g_tlff.tlff13='aimp880'                      #異動命令代號
    LET g_tlff.tlff14=''                             #異動原因
    CALL s_imaQOH(g_piaa.piaa02)
         RETURNING g_tlff.tlff18                     #異動後總庫存量
    LET g_tlff.tlff19= ' '                           #異動廠商/客戶編號
    LET g_tlff.tlff20= ' '                           #project no.      
	  LET g_tlff.tlff930=g_pia.pia930 #FUN-670093
    CALL s_tlff('2','')
END FUNCTION

#FUN-B40082 add
FUNCTION p880_set_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
CALL cl_set_comp_entry("ina01_1,ina01_2,sfp01_1,sfp01_2
                        ,inb930,sfp01_3,inb15,inb15_1",TRUE)
END FUNCTION

#FUN-B40082 add
FUNCTION p880_set_no_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
CALL cl_set_comp_entry("ina01_1,ina01_2,sfp01_1,sfp01_2
                        ,inb930,sfp01_3,inb15,inb15_1",FALSE)
END FUNCTION  

#FUN-B40082 add
FUNCTION p880_ins_ina(p_type,l_diffqty,l_sfa12,l_ima25,l_ima15,l_smy79)
   DEFINE p_type LIKE ina_file.ina00
   DEFINE l_diffqty    LIKE pie_file.pie30 
   DEFINE l_sfa12      LIKE sfa_file.sfa12   
   DEFINE l_ima25      LIKE ima_file.ima25
   DEFINE l_ima15      LIKE ima_file.ima15
   DEFINE l_smy79      LIKE smy_file.smy79
   
   INITIALIZE g_ina.* TO NULL

   CASE p_type
      WHEN '1'
         LET g_ina.ina01 = tm.ina01_2
      WHEN '3'
         LET g_ina.ina01 = tm.ina01_1
   END CASE 
   
   LET g_ina.ina00 = p_type   
   LET g_ina.ina02 = tm.posdate
   LET g_ina.ina03 = tm.posdate
   IF cl_null(g_ina.ina04) THEN 
      LET g_ina.ina04 = g_grup  
   END IF
   LET g_ina.ina08 = '0'
   LET g_ina.ina10 = g_pie.pie01
   LET g_ina.ina11= g_user   
   LET g_ina.ina12= 'N'
   LET g_ina.inapost= 'N'
   LET g_ina.inaconf= 'N'     
   LET g_ina.inaspc = '0'     
   LET g_ina.inauser= g_user
   LET g_ina.inaoriu = g_user 
   LET g_ina.inaorig = g_grup
   LET g_ina.inagrup= g_grup
   LET g_ina.inadate= tm.posdate   
   LET g_ina.inamksg = 'N'   
   LET g_ina.inapos= '1'
   LET g_ina.inacont= ''
   LET g_ina.inaconu= ''   
   LET g_data_plant = g_plant
   LET g_ina.inaplant = g_plant 
   LET g_ina.inalegal = g_legal 
   
   IF NOT p880_a_inschk() THEN
      LET g_success = 'N'
      RETURN FALSE  
   END IF
   
   INSERT INTO ina_file VALUES (g_ina.*)
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("ins","ina_file",g_ina.ina01,"",SQLCA.sqlcode,
                   "","ins ina",1)
      LET g_success = 'N'
      RETURN FALSE
   END IF

   #單身  
   IF NOT p880_ins_inb(p_type,l_diffqty,l_sfa12,l_ima25,l_ima15,l_smy79) THEN
      LET g_success = 'N'
      RETURN FALSE
   END IF  

   RETURN TRUE   
END FUNCTION

#FUN-B40082 add
FUNCTION p880_a_inschk()
   DEFINE li_result LIKE type_file.num5
   CALL s_auto_assign_no("aim",g_ina.ina01,g_ina.ina03,g_chr,"ina_file","ina01","","","")
     RETURNING li_result,g_ina.ina01
   IF (NOT li_result) THEN
      RETURN FALSE
   END IF   
   RETURN TRUE
END FUNCTION

#FUN-B40082 add
FUNCTION p880_ins_inb(p_type,l_diffqty,l_sfa12,l_ima25,l_ima15,l_smy79)
   DEFINE p_type LIKE ina_file.ina00
   DEFINE l_diffqty    LIKE pie_file.pie30 
   DEFINE l_sfa12      LIKE sfa_file.sfa12
   DEFINE l_i          LIKE type_file.num5
   DEFINE l_ima25      LIKE ima_file.ima25
   DEFINE l_ima15      LIKE ima_file.ima15
   DEFINE l_inb RECORD LIKE inb_file.*
   DEFINE l_cnt        LIKE type_file.num10
   DEFINE l_smy79      LIKE smy_file.smy79
   DEFINE l_inbi       RECORD LIKE inbi_file.*  #FUN-B70074 add
   DEFINE l_ina04   LIKE ina_file.ina04          #FUN-CB0087 xj
   DEFINE l_ina10   LIKE ina_file.ina10          #FUN-CB0087 xj
   DEFINE l_ina11   LIKE ina_file.ina11          #FUN-CB0087 xj   
 
   INITIALIZE l_inb.* TO NULL   
   
   LET l_inb.inb01 = g_ina.ina01
   LET l_inb.inb03 = 1
   LET l_inb.inb04 = g_pie.pie02
   LET l_inb.inb05 = l_smy79   
   LET l_inb.inb06 = ' '
   LET l_inb.inb07 = ' '
   LET l_inb.inb08 = l_sfa12   
   LET l_inb.inb09 = l_diffqty
   LET l_inb.inb10 = 'N'
   LET l_inb.inb16 = l_inb.inb09
   LET l_inb.inb922 = l_inb.inb08
   LET l_inb.inb923 = 1
   LET l_inb.inbplant = g_plant
   LET l_inb.inblegal = g_legal
      
   CALL s_umfchk(g_pie.pie02,l_sfa12,l_ima25) RETURNING l_i,l_inb.inb08_fac

   IF g_sma.sma79='Y' AND l_ima15 = 'Y' THEN
      LET l_inb.inb15 = tm.inb15_1
   ELSE
      LET l_inb.inb15 = tm.inb15
   END IF

   IF g_aaz.aaz90='Y' THEN
      LET l_inb.inb930 = tm.inb930 
   END IF   
   LET l_inb.inb09 = s_digqty(l_inb.inb09,l_inb.inb08)     #FUN-BB0085
   LET l_inb.inb16 = s_digqty(l_inb.inb16,l_inb.inb08)     #FUN-BB0085
  #FUN-CB0087-xj---add---str
   IF g_aza.aza115 = 'Y' THEN
     SELECT ina04,ina10,ina11 INTO l_ina04,l_ina10,l_ina11 FROM ina_file WHERE ina01 = l_inb.inb01 
     CALL s_reason_code(l_inb.inb01,l_ina10,'',l_inb.inb04,l_inb.inb05,l_ina04,l_ina11) RETURNING l_inb.inb15
     IF cl_null(l_inb.inb15) THEN
        CALL cl_err('','aim-425',1)
        RETURN FALSE
     END IF
  END IF
  #FUN-CB0087-xj---add---end    
   INSERT INTO inb_file VALUES(l_inb.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","inb_file","","",SQLCA.sqlcode,"",
                   "ins inb",1)  #No.FUN-660156
      RETURN FALSE
#FUN-B70074--add--insert--
   ELSE
      IF NOT s_industry('std') THEN
         INITIALIZE l_inbi.* TO NULL
         LET l_inbi.inbi01 = l_inb.inb01
         LET l_inbi.inbi03 = l_inb.inb03
         IF NOT s_ins_inbi(l_inbi.*,l_inb.inbplant ) THEN
            RETURN FALSE 
         END IF
      END IF 
#FUN-B70074--add--insert--
   END IF

   IF p_type = '3' THEN
      SELECT COUNT(*) INTO l_cnt FROM img_file
        WHERE img01 = l_inb.inb04
        AND img02 = l_inb.inb05
        IF l_cnt = 0 THEN
           CALL p880_add_img(l_inb.inb04,l_inb.inb05,l_inb.inb01,l_inb.inb03)
        END IF
   END IF 
   
   RETURN TRUE

END FUNCTION

#FUN-B40082 add
FUNCTION p880_ins_sfp(p_type2,l_diffqty,l_sfa01,l_sfa03,l_sfa08,
                      l_sfa12,l_sfa012,l_sfa013,l_sfa27,l_smy79)
   DEFINE p_type2   LIKE sfp_file.sfp06   
   DEFINE li_result LIKE type_file.num5
   DEFINE l_smy70   LIKE smy_file.smy70
   DEFINE l_diffqty     LIKE pie_file.pie30   
   DEFINE l_sfa01       LIKE sfa_file.sfa01,
          l_sfa03       LIKE sfa_file.sfa03,
          l_sfa08       LIKE sfa_file.sfa08,
          l_sfa12       LIKE sfa_file.sfa12,
          l_sfa012      LIKE sfa_file.sfa012,
          l_sfa013      LIKE sfa_file.sfa013,
          l_sfa27       LIKE sfa_file.sfa27
   DEFINE l_smy79       LIKE smy_file.smy79
   INITIALIZE g_sfp.* TO NULL
   CASE p_type2   
      WHEN "4" #發料
         LET l_smy70 = tm.sfp01_1
      WHEN "9" #退料
         LET l_smy70 = tm.sfp01_2
      WHEN "2" #超領
         LET l_smy70 = tm.sfp01_3
   END CASE   

   CALL s_auto_assign_no('asf',l_smy70,tm.posdate,'3','sfp_file','sfp01','','','')
        RETURNING li_result,g_sfp.sfp01
   IF (NOT li_result) THEN
      CALL cl_err(l_smy70,'asf-377',1)
      LET g_success = 'N'
      RETURN FALSE   
   END IF

   LET g_sfp.sfp02 = tm.posdate
   LET g_sfp.sfp03 = tm.posdate
   LET g_sfp.sfp04 = 'N'
   LET g_sfp.sfp05 = 'N'
   LET g_sfp.sfp06 = p_type2
   LET g_sfp.sfp09 = 'N'
   LET g_sfp.sfp13 = 'N'
   LET g_sfp.sfp14 = g_pie.pie01 
   #LET g_sfp.sfp16 = g_user 
   LET g_sfp.sfp15 = '0' 
   LET g_sfp.sfpconf = 'N' 
   LET g_sfp.sfpuser = g_user
   LET g_sfp.sfpgrup = g_grup
   LET g_sfp.sfpdate = tm.posdate
   LET g_sfp.sfpplant = g_plant
   LET g_sfp.sfplegal = g_legal
   LET g_sfp.sfporiu = g_user 
   LET g_sfp.sfporig = g_grup
   IF cl_null(g_smy.smyapr) THEN
      LET g_sfp.sfpmksg = 'N'
   ELSE  
      LET g_sfp.sfpmksg = g_smy.smyapr
   END IF 

   INSERT INTO sfp_file VALUES(g_sfp.*)   
   IF SQLCA.sqlcode THEN
      CALL cl_err3('ins','sfp_file',g_sfp.sfp01,'',SQLCA.sqlcode,'','','1')
      LET g_success = 'N'
      RETURN FALSE
   END IF

   #單身
   IF NOT p880_ins_sfs(p_type2,l_diffqty,l_sfa01,l_sfa03,l_sfa08,
                       l_sfa12,l_sfa012,l_sfa013,l_sfa27,l_smy79) THEN
      LET g_success = 'N'
      RETURN FALSE   
   END IF
          
   RETURN TRUE
END FUNCTION

#FUN-B40082 add
FUNCTION p880_ins_sfs(p_type2,l_diffqty,l_sfa01,l_sfa03,l_sfa08
                      ,l_sfa12,l_sfa012,l_sfa013,l_sfa27,l_smy79)
   DEFINE p_type2       LIKE sfp_file.sfp06
   DEFINE l_diffqty     LIKE pie_file.pie30
   DEFINE l_sfs RECORD  LIKE sfs_file.*
   DEFINE l_sfa01       LIKE sfa_file.sfa01,
          l_sfa03       LIKE sfa_file.sfa03,
          l_sfa08       LIKE sfa_file.sfa08,
          l_sfa12       LIKE sfa_file.sfa12,
          l_sfa012      LIKE sfa_file.sfa012,
          l_sfa013      LIKE sfa_file.sfa013,
          l_sfa27       LIKE sfa_file.sfa27
   DEFINE l_cnt         LIKE type_file.num10   
   DEFINE l_smy79       LIKE smy_file.smy79
   DEFINE l_sfsi RECORD  LIKE sfsi_file.*    #FUN-B70074   

   LET l_sfs.sfs01=g_sfp.sfp01
   
   SELECT MAX(sfs02) +1 INTO l_sfs.sfs02 FROM sfs_file
       WHERE sfs01 = l_sfs.sfs01
   IF cl_null(l_sfs.sfs02) OR l_sfs.sfs02 = 0 THEN
      LET l_sfs.sfs02 = 1
   END IF   

   LET l_sfs.sfs03 = l_sfa01
   LET l_sfs.sfs04 = l_sfa03   
   LET l_sfs.sfs05 = l_diffqty       #發料數量
   LET l_sfs.sfs06 = l_sfa12         #發料單位   
   LET l_sfs.sfs05 = s_digqty(l_sfs.sfs05,l_sfs.sfs06)   #FUN-BB0084
   LET l_sfs.sfs07 = l_smy79
   LET l_sfs.sfs08 = ' '
   LET l_sfs.sfs09 = ' '
   LET l_sfs.sfs10 = l_sfa08
   LET l_sfs.sfs012 = l_sfa012
   LET l_sfs.sfs013 = l_sfa013
   LET l_sfs.sfs014 = ' '     #FUN-C70014 add  
   LET l_sfs.sfsud13 = NULL 
   LET l_sfs.sfsud14 = NULL 
   LET l_sfs.sfsud15 = NULL
   LET l_sfs.sfs27 = l_sfa27   
   LET l_sfs.sfsplant = g_plant
   LET l_sfs.sfslegal = g_legal

   IF cl_null(l_sfs.sfs07) THEN
      LET l_sfs.sfs07 = ' '
   END IF  
   
   #FUN-CB0087---add---str---
   IF g_aza.aza115 = 'Y' THEN
      CALL s_reason_code(l_sfs.sfs01,l_sfs.sfs03,'',l_sfs.sfs04,l_sfs.sfs07,g_sfp.sfp16,g_sfp.sfp07) RETURNING l_sfs.sfs37
      IF cl_null(l_sfs.sfs37) THEN
         CALL cl_err('','aim-425',1)
         RETURN FALSE
      END IF
   END IF
   #FUN-CB0087---add---end--
   INSERT INTO sfs_file VALUES(l_sfs.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err3('ins','sfs_file',l_sfs.sfs01,l_sfs.sfs04,SQLCA.sqlcode,'','','1')
      RETURN FALSE
#FUN-B70074 ------------------Begin-----------------------
   ELSE
      IF NOT s_industry('std') THEN
         INITIALIZE l_sfsi.* TO NULL
         LET l_sfsi.sfsi01 = l_sfs.sfs01
         LET l_sfsi.sfsi02 = l_sfs.sfs02
         IF NOT s_ins_sfsi(l_sfsi.*,l_sfs.sfsplant) THEN
            RETURN FALSE
         END IF
      END IF
#FUN-B70074 ------------------End-------------------------
   END IF

   IF p_type2 = '9' THEN
      SELECT COUNT(*) INTO l_cnt FROM img_file
        WHERE img01 = l_sfs.sfs04
        AND img02 = l_sfs.sfs07
        IF l_cnt = 0 THEN
           CALL p880_add_img(l_sfs.sfs04,l_sfs.sfs07,l_sfs.sfs01,l_sfs.sfs02)
        END IF
   END IF 
   RETURN TRUE   
END FUNCTION

#FUN-B40082 add
FUNCTION p880_sfp_chk_upd(p_type2)
DEFINE p_type2 LIKE ina_file.ina00
DEFINE p_argv1 LIKE type_file.chr1
   CASE p_type2
      WHEN '2'
         LET p_argv1 = '1'
         LET g_prog = 'asfi512'      
      WHEN '4'
         LET p_argv1 = '1'
         LET g_prog = 'asfi514'
      WHEN '9'
         LET p_argv1 = '2'   
         LET g_prog = 'asfi529'   
   END CASE     

   #發/退料單、超領單確認
   CALL i501sub_y_chk(g_sfp.sfp01,NULL)  #TQC-C60079
   IF g_success = 'N' THEN
      RETURN FALSE
   END IF
   
   CALL i501sub_y_upd(g_sfp.sfp01,NULL,TRUE) RETURNING g_sfp.*
   IF g_success = 'N' THEN
      RETURN FALSE
   END IF

   #發/退料單、超領單過帳
   CALL i501sub_s(p_argv1,g_sfp.sfp01,TRUE,'N')
   IF g_success = 'N' THEN
     RETURN FALSE
   END IF
   
   RETURN TRUE   
END FUNCTION 

#FUN-B40082 add
FUNCTION p880_ina_chk_upd(p_type)
DEFINE p_type LIKE ina_file.ina00
DEFINE p_argv1 LIKE type_file.chr1
   CASE p_type
      WHEN '3'
         LET p_argv1 = '3'
      WHEN '1'
         LET p_argv1 = '1'          
   END CASE

   #雜收/發單確認
   CALL t370sub_y_chk(g_ina.ina01,p_argv1,'N')      #TQC-C40079  add 'N'
   IF g_success = 'N' THEN
      RETURN FALSE
   END IF  
   CALL t370sub_y_upd(g_ina.ina01,'N',TRUE)
   IF g_success = 'N' THEN
      RETURN FALSE
   END IF  

   #雜收/發單過帳
   CALL t370sub_s_chk(g_ina.ina01,'N',TRUE,tm.posdate)
   IF g_success = 'N' THEN
      RETURN FALSE
   END IF  
   CALL t370sub_s_upd(g_ina.ina01,p_argv1,TRUE)
   IF g_success = 'N' THEN
      RETURN FALSE
   END IF
   RETURN TRUE   
END FUNCTION 

#FUN-B70032 --START--
FUNCTION p880_piadqty_chk(l_pia01,l_pia02,l_pia03,l_pia04,l_pia05)
   DEFINE l_sql   STRING 
   DEFINE l_qty   LIKE type_file.num15_3
   DEFINE l_qty2  LIKE type_file.num15_3          
   DEFINE l_pia01 LIKE pia_file.pia01
   DEFINE l_pia02 LIKE pia_file.pia02
   DEFINE l_pia03 LIKE pia_file.pia03
   DEFINE l_pia04 LIKE pia_file.pia04
   DEFINE l_pia05 LIKE pia_file.pia05

   LET l_sql = "SELECT sum(piad30),sum(piad50) FROM  piad_file",
               " WHERE piad01 = '" ,l_pia01, "'",
               "   AND piad02 = '" ,l_pia02, "'",
               "   AND piad03 = '" ,l_pia03, "'",
               "   AND piad04 = '" ,l_pia04, "'",
               "   AND piad05 = '" ,l_pia05, "'"
   PREPARE p880_piad_p FROM l_sql           
   DECLARE p880_piad_c CURSOR FOR p880_piad_p
   OPEN p880_piad_c 
   FETCH p880_piad_c INTO l_qty,l_qty2   
   IF SQLCA.sqlcode THEN
      CLOSE p880_piad_c 
      RETURN 0
   END IF 
   #以複盤數量為主,當複盤數量為NULL時,才以初盤數量更新
   IF NOT cl_null(l_qty2) AND l_qty2 > 0 THEN
      LET l_qty = l_qty2
   END IF   
   IF cl_null(l_qty) THEN
      LET l_qty = 0 
   END IF
   CLOSE p880_piad_c 
   RETURN l_qty 
END FUNCTION 

FUNCTION p880_uppiad(l_pia01,l_pia02) 
   DEFINE l_sql      STRING  
   DEFINE l_pia01    LIKE pia_file.pia01
   DEFINE l_pia02    LIKE pia_file.pia02      
   DEFINE l_imaicd01 LIKE imaicd_file.imaicd01 
   DEFINE l_piad     RECORD LIKE piad_file.*
   DEFINE l_qty      LIKE type_file.num15_3
   DEFINE p_in_out   LIKE type_file.num5
   DEFINE l_cnt      LIKE type_file.num10

   #母體料號    
   SELECT imaicd01 INTO l_imaicd01 FROM imaicd_file WHERE imaicd00 = l_pia02    
   IF SQLCA.sqlcode THEN RETURN FALSE END IF
   
   #刻號/BIN盤點資料
   LET l_sql = "SELECT * FROM piad_file WHERE piad01 = '" ,l_pia01, "'"              
               
   PREPARE p880_piad_p1 FROM l_sql           
   DECLARE p880_paid_c1 CURSOR FOR p880_piad_p1

   LET l_cnt = 0
   
   FOREACH p880_paid_c1 INTO l_piad.*
      IF SQLCA.sqlcode THEN         
         RETURN FALSE 
      END IF 
      
      #給預設值
      IF cl_null(l_piad.piad09) THEN LET l_piad.piad09 = 0 END IF        
      IF cl_null(l_piad.piad30) THEN LET l_piad.piad30 = 0 END IF
      IF cl_null(l_piad.piad50) THEN LET l_piad.piad50 = 0 END IF      
      #若有複盤以複盤數量為主
      IF l_piad.piad50 > 0 THEN LET l_piad.piad30 = l_piad.piad50 END IF

      #盤點量<>庫存量
      IF l_piad.piad30 <> l_piad.piad09 THEN
         #建立ICD料件出/入庫紀錄檔
         IF l_piad.piad30 - l_piad.piad09 > 0 THEN   #盤盈
            LET l_qty = l_piad.piad30 - l_piad.piad09
            LET p_in_out = 1
            IF NOT icd_ins_ida(l_piad.piad02,l_piad.piad03,l_piad.piad04,l_piad.piad05,
                               l_piad.piad06,l_piad.piad07,l_pia01,
                               0,l_piad.piad12,l_qty,l_piad.piad10,' ',' ',l_imaicd01,'') THEN  #FUN-B80119--傳入p_plant參數---
               RETURN FALSE
            END IF    
         ELSE                                        #盤虧
            LET l_qty = l_piad.piad09 - l_piad.piad30
            LET p_in_out = -1
            IF NOT icd_ins_idb(l_piad.piad02,l_piad.piad03,l_piad.piad04,l_piad.piad05,
                               l_piad.piad06,l_piad.piad07,l_pia01,
                               0,l_piad.piad12,l_qty,l_piad.piad10,' ',' ',l_imaicd01,'') THEN  #FUN-B80119--傳入p_plant參數---  
               RETURN FALSE                
            END IF                           
         END IF  
   
         #過帳
         IF NOT s_icdpost(p_in_out,l_piad.piad02,l_piad.piad03,l_piad.piad04,l_piad.piad05,
                          l_piad.piad10,l_qty,l_pia01,0,l_piad.piad12,'Y','','',' ',' ','') THEN   #FUN-B80119--傳入p_plant參數---
            RETURN FALSE              
         END IF  
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH

   IF l_cnt > 0 THEN
      #更新盤點過帳狀態
      UPDATE piad_file SET piad19='Y' WHERE piad01 = l_pia01 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         RETURN FALSE
      END IF       
   END IF 
   
   RETURN TRUE 
END FUNCTION 
#FUN-B70032 --END--

#FUN-B40082 add
FUNCTION p880_add_img(p_img01,p_img02,p_img05,p_img06)
   DEFINE l_img   RECORD LIKE img_file.*
   DEFINE p_img01        LIKE img_file.img01
   DEFINE p_img02        LIKE img_file.img02
   DEFINE p_img05        LIKE img_file.img05
   DEFINE p_img06        LIKE img_file.img06
   DEFINE g_i            LIKE type_file.num5 
   DEFINE l_img09        LIKE img_file.img09
   DEFINE l_ima71        LIKE ima_file.ima71

   INITIALIZE l_img.* TO NULL
   LET l_img.img01=p_img01              #料號
   LET l_img.img02=p_img02              #倉庫
   LET l_img.img03=' '                  #儲位
   LET l_img.img04=' '                  #批號
   LET l_img.img05=p_img05              #參考號碼
   LET l_img.img06=p_img06              #序號

   IF s_joint_venture( p_img01,g_plant) OR NOT s_internal_item( p_img01,g_plant ) THEN
       RETURN
   END IF
   
   # 檢查是否有相對應的倉庫/儲位資料存在,若無則自動新增一筆資料
   CALL s_locchk(l_img.img01,l_img.img02,l_img.img03) RETURNING g_i,l_img.img26
   IF g_i = 0 THEN
      LET g_errno='N' 
      RETURN
   END IF
 
   SELECT ima25,ima71 INTO l_img09,l_ima71 FROM ima_file
          WHERE ima01=l_img.img01
   IF SQLCA.sqlcode OR l_ima71 IS NULL THEN
      LET l_ima71=0 
   END IF
   LET l_img.img09 = l_img09
   LET l_img.img10=0
   LET l_img.img17=tm.posdate      
   LET l_img.img13=null                      
   IF l_ima71 =0 THEN 
      LET l_img.img18=g_lastdat
   ELSE 
      LET l_img.img13=tm.posdate  
      LET l_img.img18=tm.posdate + l_ima71
   END IF
   SELECT ime04,ime05,ime06,ime07,ime09
         ,ime10,ime11                  
     INTO l_img.img22,l_img.img23,l_img.img24,l_img.img25,l_img.img26
         ,l_img.img27,l_img.img28     
     FROM ime_file
    WHERE ime01 = p_img02 AND ime02 = p_img03
	AND imeacti = 'Y'  #FUN-D40103 add
   IF SQLCA.sqlcode THEN 
      SELECT imd10,imd11,imd12,imd13,imd08
            ,imd14,imd15               
        INTO l_img.img22, l_img.img23, l_img.img24, l_img.img25,l_img.img26
            ,l_img.img27,l_img.img28   
        FROM imd_file WHERE imd01=l_img.img02
      IF SQLCA.SQLCODE THEN 
         LET l_img.img22 = 'S'  LET l_img.img23 = 'Y'
         LET l_img.img24 = 'Y'  LET l_img.img25 = 'N'
      END IF
   END IF
   LET l_img.img20=1         LET l_img.img21=1
   LET l_img.img30=0         LET l_img.img31=0
   LET l_img.img32=0         LET l_img.img33=0
   LET l_img.img34=1         LET l_img.img37=tm.posdate  
   LET l_img.img14=tm.posdate    
   LET g_errno=' '

   IF l_img.img02 IS NULL THEN LET l_img.img02 = ' ' END IF
   IF l_img.img03 IS NULL THEN LET l_img.img03 = ' ' END IF
   IF l_img.img04 IS NULL THEN LET l_img.img04 = ' ' END IF
   LET l_img.imgplant = g_plant 
   LET l_img.imglegal = g_legal 
 
   INSERT INTO img_file VALUES (l_img.*)
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN      
      CALL cl_err3("ins","img_file","","",SQLCA.SQLCODE,"","",0)
      LET g_errno='N' 
   END IF   
END FUNCTION 
#No.FUN-9C0072 精簡程式碼   
