# Prog. Version..: '5.30.06-13.04.01(00010)'     #
#
# Pattern name...: abmp100.4gl
# Descriptions...: 工程BOM 轉正式BOM   
# Date & Author..: 94/06/15 By Apple
# Modify.........: 2000/01/05 By Kammy (加入版本的判斷)
# Modify.........: No.MOD-470041 04/07/16 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-480233 04/08/10 Kammy 產生單身時應加 sma100 判斷
# Modify.........: No.MOD-480376 04/08/16 ching 執行有錯
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.MOD-4C0090 05/01/18 By Mandy AFTER ROW 段語法上不可加l_ac,NEXT FIELD
# Modify.........: No.MOD-530351 05/03/28 By kim 已存在之正式料號不應該再可以輸入正式料號
# Modify.........: No.MOD-540087 05/04/12 By Mandy INSERT INTO ima_file的檢驗否欄位(ima24)請給default 'N'
# Modify.........: No.MOD-540142 05/04/25 By pengu 單身元件若是已經有存在正式料號，不應該再允許使用者去指定為另一個正式料號
# Modify.........: No.MOD-540102 05/05/06 By pengu 1.修改p100_b_fill()中的SQL
                                                      #  2.若E-bom單身有一顆料已有正式料號，在自動展單身時應帶ima01到正式料號
# Modify.........: No.FUN-550079 05/05/18 By kim 配方BOM,加bmo06特性代碼
# Modify.........: No.FUN-560021 05/06/07 By kim 配方BOM,視情況 隱藏/顯示 "特性代碼"欄位
# Modify.........: No.FUN-560030 05/06/13 By kim 測試BOM : bmo_file新增 bmo06 ,相關程式需修改
# Modify.........: No.FUN-560119 05/06/20 By saki 料件編號長度限制
# Modify.........: No.TQC-650066 06/05/16 By Claire ima79 mark
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/17 By hellen 新增單頭折疊功能
# Modify.........: No.FUN-710014 07/01/11 By douzh 錯誤訊息匯整 
# Modify.........: No.MOD-740179 07/04/26 By kim 新增ima_file時,沒給確認碼
# Modify.........: No.TQC-750170 07/05/29 By rainy 已是正式料的不可再輸入
#                                                  聯產品及重覆性生產default 'N'
# Modify.........: No.CHI-710051 07/06/07 By jamie 將ima21欄位放大至21
# Modify.........: No.CHI-790004 07/09/03 By kim 新增段PK值不可為NULL
# Modify.........: No.MOD-790002 07/09/03 By Joe 程式段INSERT時,增加欄位(PK)預設值
# Modify.........: No.MOD-780061 07/10/17 By pengu INSERT ima_file時ima911欄位未default值
# Modify.........: No.MOD-7B0030 07/11/07 By Pengu 1.ima915給初始值
#                                                  2.單身若是正是料則不允許維護"正式編號欄位"
# Modify.........: No.FUN-7B0018 08/03/04 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-830132 08/03/28 By hellen 將imaicd_file變成icd專用
# Modify.........: No.MOD-840111 08/04/16 By Pengu 測試料號拋轉為正式料號時ima913統購否欄位應預設給N
# Modify.........: No.FUN-830116 08/04/18 By jan 增加bmb33賦值
# Modify.........: No.MOD-840292 08/04/21 By kim ima_file新增不可空白欄位
# Modify.........: No.MOD-840422 08/04/25 By jan 如果拋轉過去的ima沒有insert 或update成功，應該把產生的正式BOM rollback
# Modify.........: No.FUN-840194 08/06/24 By sherry 增加變動前置時間批量（ima061）
# Modify.........: No.MOD-890124 08/09/12 By claire 依料件分群碼給值
# Modify.........: No.FUN-8A0086 08/10/22 By chenmoyan 完善FUN-710050的錯誤匯總的修改
# Modify.........: No.MOD-910241 09/01/21 By jan 1.系統沒有把取替代料件的 生效日期 失效日期 一并帶入
#...............................................:2.且產生的正式bom其確認碼是null，因此系統無法在針對這張bom進行確認與取消確認
# Modify.........: No.MOD-920023 09/02/02 By jan INSERT INTO bma_file時增加bma08欄位
# Modify.........: No.FUN-920040 09/02/04 By jan EBOM轉BOM 寫入取替代料時, 應一并DEF bmddate最近修改日
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.TQC-950134 09/05/22 By Carrier rowid定義規範化
# Modify.........: No.MOD-960298 09/06/24 By Carrier insert ima_file前對ima918/ima919/ima921/ima922做賦值
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0155 09/10/28 By liuxqa OUTER 和 ORDER 修改。
# Modify.........: No:FUN-9C0077 09/12/16 By baofei 程序精簡
# Modify.........: No:MOD-9C0253 09/12/23 By Pengu 單身無法產生資料
# Modify.........: No:FUN-A20044 10/03/19 By vealxu ima26畫面清單
# Modify.........: No:MOD-A50091 10/05/14 By Sarah 將p100_b_fill()裡的g_cnt換成l_ac
# Modify.........: No:FUN-A80150 10/09/20 By sabrina 在insert into ima_file之前，當ima156/ima158為null時要給"N"值
# Modify.........: No.FUN-AA0014 10/10/06 By Nicola 預設ima927
# Modify.........: No:MOD-AA0039 10/10/08 By sabrina 拋轉正式BOM時，bmb14、bmb19沒有給預設值
# Modify.........: No:MOD-AB0014 10/11/02 By sabrina 若單身的料件均是正式料時，且會變無窮迴圈
# Modify.........: No:MOD-AB0064 10/11/08 By zhangll sql错误导单身无法产生资料
# Modify.........: No:FUN-AB0025 10/11/11 By lixh1   全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No.FUN-AB0059 10/11/15 By vealxu AFTER FIELD firm 沒控卡
# Modify.........: No.TQC-AC0015 10/12/13 By destiny 參數未管控e-bom需存在于p_bom中，應該可以輸入e-bom料號
# Modify.........: No:TQC-AC0157 10/12/13 By zhangll 1.增加ima120非空栏位赋值
#                                                    2.给bmb31赋值
# Modify.........: No.TQC-AC0183 10/12/22 By liweie  新增bmp081,bmp082字段
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting 離開MAIN時沒有cl_used(1)和cl_used(2)
# Modify.........: No:FUN-B70060 11/07/18 By zhangll 控管料號前不能有空格
# Modify.........: No:MOD-BA0041 11/10/07 By johung 取l_bmq011前先清空
# Modify.........: No:TQC-BB0009 11/11/01 By lilingyu 給ima159 增加賦默認值
# Modify.........: No:FUN-BB0083 11/12/14 By xujing 增加數量欄位小數取位
# Modify.........: No.TQC-C20131 12/02/13 By zhuhao 在insert into ima_file之前給ima928賦值,在insert into bmd_file之前給bmd11賦值
# Modify.........: No.TQC-C20180 12/02/14 By bart ima928為not null欄位
# Modify.........: No:MOD-C20125 12/02/16 By ck2yuan q_bmo改用q_bmo4查詢
# Modify.........: No:TQC-C50028 12/05/07 By lixh1 將bmq903的選項值帶入到ima_file表中;自動產生的料件“批號管控方式”ima159默認值為3
# Modify.........: No:FUN-C50036 12/05/21 By yangxf 新增ima160字段，给预设值
# Modify.........: No:CHI-C50068 12/11/06 By bart 新增ima721
# Modify.........: No:MOD-D10116 13/01/29 By bart item欄位控制
# Modify.........: No.CHI-D10044 13/03/04 By bart s_uima146()參數變更
# Modify.........: No.TQC-D40115 13/07/17 By yangtt 新增時給ima934賦初值

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   tm            RECORD                    #CHI-710051      
            bmo01      LIKE bmo_file.bmo01,   
            bmo011     LIKE bmo_file.bmo011,
            firm       LIKE bmo_file.bmo01,
            bmo06      LIKE bmo_file.bmo06, #FUN-550079
            bdate      LIKE type_file.dat,     #No.FUN-680096 DATE
            edate      LIKE type_file.dat      #No.FUN-680096 DATE
                       END RECORD,
         g_bmo         RECORD LIKE bmo_file.*,
         g_bmp  DYNAMIC ARRAY OF RECORD 
            bmp03      LIKE bmp_file.bmp03,
            bmq02      LIKE bmq_file.bmq02,
            bmq021     LIKE bmq_file.bmq021,
            item       LIKE ima_file.ima01,
            bmp28      LIKE bmp_file.bmp28 #FUN-550079
                   END RECORD,
         g_bmp_t       RECORD 
            bmp03      LIKE bmp_file.bmp03,
            bmq02      LIKE bmq_file.bmq02,
            bmq021     LIKE bmq_file.bmq021,
            item       LIKE ima_file.ima01,
            bmp28      LIKE bmp_file.bmp28 #FUN-550079
                   END RECORD,
         b_bmp  DYNAMIC ARRAY OF RECORD 
            sou        LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
            bmp02      LIKE bmp_file.bmp02
                   END RECORD,
         g_rec_b       LIKE type_file.num10,    #No.FUN-680096 INTEGER
         l_n           LIKE type_file.num5,     #目前處理的ARRAY CNT   #No.FUN-680096 SMALLINT
         l_ac          LIKE type_file.num5,     #目前處理的ARRAY CNT   #No.FUN-680096 SMALLINT
         l_flag        LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
         g_change_lang LIKE type_file.chr1,     #是否有做語言切換  #No.FUN-680096 VARCHAR(1)
         g_imz  RECORD LIKE imz_file.*          #INSERT ima_file時給default值  
DEFINE   g_cnt         LIKE type_file.num10     #No.FUN-680096 INTEGER
DEFINE   g_before_input_done LIKE type_file.num5       #No.FUN-680096 SMALLINT
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT	         		# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time          #FUN-B30211
 
   CALL s_decl_bmb()
   WHILE TRUE
     BEGIN WORK
     LET g_success = 'Y'
     LET g_change_lang = FALSE
 
     CALL g_bmp.clear()
     CALL b_bmp.clear()
 
     CALL p100_tm()			
 
     IF g_change_lang = TRUE THEN 
         CONTINUE WHILE
     END IF
 
     IF INT_FLAG THEN LET INT_FLAG = 0  EXIT WHILE END IF
     CALL p100_b_fill()
    #MOD-AB0014---add---start---
     CALL cl_set_act_visible("accept,cancel", FALSE)
     DISPLAY ARRAY g_bmp TO s_bmp.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)    
     BEFORE ROW
       EXIT DISPLAY
     END DISPLAY
     IF g_cnt <> g_rec_b THEN  
    #MOD-AB0014---add---end---
        CALL p100_array()
     END IF                      #MOD-AB0014 add
 
     IF INT_FLAG THEN LET INT_FLAG = 0  EXIT WHILE END IF
 
     #-->正式資料拋轉
     IF cl_sure(0,0) THEN
        CALL cl_wait()
        CALL p100() 
        IF g_success = 'Y' THEN
           COMMIT WORK
           CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
        ELSE
           ROLLBACK WORK
           CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
        END IF
        IF l_flag THEN
           CLEAR FORM
           CALL g_bmp.clear()
           CALL b_bmp.clear()
           CONTINUE WHILE
        ELSE
           EXIT WHILE
        END IF
     END IF
     CLEAR FORM
     CALL g_bmp.clear()
     CALL b_bmp.clear()
     ERROR ""
   END WHILE
   CLOSE WINDOW p100_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B30211
END MAIN
   
FUNCTION p100_tm()
   DEFINE   p_row,p_col	  LIKE type_file.num5,   #No.FUN-680096 SMALLINT
            l_cnt         LIKE type_file.num5,   #No.FUN-680096 SMALLINT
            l_firm_y      LIKE type_file.chr1,   #存放主件已有正式料號(bmq011)否  #No.FUN-680096 VARCHAR(1)
            l_bmq011      LIKE bmq_file.bmq011,
            l_bmq02       LIKE bmq_file.bmq02,
            l_bmq021      LIKE bmq_file.bmq021,
            l_ima02       LIKE ima_file.ima02,
            l_ima021      LIKE ima_file.ima021
   DEFINE   lc_sma119     LIKE sma_file.sma119, #No.FUN-560119
            li_len        LIKE type_file.num5   #No.FUN-680096 SMALLINT
 
   LET p_row = 3 LET p_col = 18
 
   OPEN WINDOW p100_w AT p_row,p_col WITH FORM "abm/42f/abmp100" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_set_comp_visible("bmo06,bmp28",g_sma.sma118='Y')
 
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.bdate = g_today
   LET l_firm_y = 'N'
 
   CALL cl_set_comp_entry("bmo06,bmp28",g_sma.sma118='Y') #FUN-550079
   SELECT sma119 INTO lc_sma119 FROM sma_file
   CASE lc_sma119
      WHEN "0"
         LET li_len = 20
      WHEN "1"
         LET li_len = 30
      WHEN "2"
         LET li_len = 40
   END CASE
   CALL cl_set_head_visible("grid01,grid02,grid03","YES")     #No.FUN-6B0033
 
   INPUT BY NAME tm.bmo01,tm.bmo011,tm.firm,tm.bmo06,tm.bdate,tm.edate WITHOUT DEFAULTS #FUN-550079
 
      BEFORE INPUT
         CALL cl_chg_comp_att("formonly.bmo01","WIDTH|GRIDWIDTH|SCROLL",li_len || "|" || li_len || "|0")
         CALL cl_chg_comp_att("formonly.firm","WIDTH|GRIDWIDTH|SCROLL",li_len || "|" || li_len || "|0")
 
      AFTER FIELD bmo01
         IF NOT cl_null(tm.bmo01) THEN 
            SELECT COUNT(*) INTO g_cnt FROM bmo_file WHERE bmo01 = tm.bmo01
            IF g_cnt = 0 OR SQLCA.sqlcode THEN 
               CALL cl_err(tm.bmo01,'mfg2757',0)
               NEXT FIELD bmo01
            END IF
 
            #主件編號(bmo01)已存在正式bom中..
            IF g_sma.sma118<>'Y' THEN  #FUN-560030
               SELECT COUNT(*) INTO g_cnt FROM bma_file WHERE bma01 = tm.bmo01
               IF g_cnt > 0 THEN 
                  CALL cl_err(tm.bmo01,'mfg2773',0)
                  NEXT FIELD bmo01
               END IF
            END IF
 
            #檢查該主件已有正式料號(bmq011)否?
            SELECT bmq02,bmq021,bmq011 
              INTO l_bmq02,l_bmq021,tm.firm 
              FROM bmq_file 
             WHERE bmq01 = tm.bmo01
            IF STATUS = 0 AND NOT cl_null(tm.firm) THEN 
               DISPLAY tm.firm TO firm 
               LET l_firm_y = 'Y'
            END IF
            DISPLAY l_bmq02  TO FORMONLY.bmq02
            DISPLAY l_bmq021 TO FORMONLY.bmq021
 
           #若該主件已有正式料號,則不可修改正式料號,一主件只可有一種正式料號 
            CALL cl_set_comp_entry("firm",cl_null(tm.firm))  
         END IF
      
      AFTER FIELD bmo06
         #主件編號(bmo01)已存在正式bom中..
         IF g_sma.sma118='Y' THEN  #FUN-560030
            IF tm.bmo06 IS NULL THEN
               LET tm.bmo06=' '
            END IF
            SELECT COUNT(*) INTO g_cnt FROM bma_file WHERE bma01 = tm.bmo01
                                                       AND bma06 = tm.bmo06
            IF g_cnt > 0 THEN 
               CALL cl_err(tm.bmo01,'mfg2773',0)
               NEXT FIELD bmo01
            END IF
 
            SELECT bmo_file.*
              INTO g_bmo.*
              FROM bmo_file 
             WHERE bmo01 = tm.bmo01 AND bmo011= tm.bmo011
               AND bmo06 = tm.bmo06
            
            IF SQLCA.sqlcode THEN 
               CALL cl_err('','mfg2757',0)
               NEXT FIELD bmo01 
            END IF
            
            IF not cl_null(g_bmo.bmo05) THEN 
               CALL cl_err('','mfg2760',0)
               NEXT FIELD bmo01 
            END IF
         END IF
     
      AFTER FIELD bmo011
         IF g_sma.sma118<>'Y' THEN  #FUN-560030
            IF NOT cl_null(tm.bmo011) THEN
               SELECT bmo_file.*
                 INTO g_bmo.*
                 FROM bmo_file 
                WHERE bmo01 = tm.bmo01 AND bmo011= tm.bmo011
            
               IF SQLCA.sqlcode THEN 
                  CALL cl_err('','mfg2757',0)
                  NEXT FIELD bmo011
               END IF
            
               IF not cl_null(g_bmo.bmo05) THEN 
                  CALL cl_err('','mfg2760',0)
                  NEXT FIELD bmo011
               END IF
            END IF
         ELSE
            #此段在 AFTER FIELD bmo06 中處理
         END IF
 
      AFTER FIELD firm 
         IF NOT cl_null(tm.firm) THEN
            IF g_sma.sma100='Y' AND NOT cl_null(tm.firm) THEN #TQC-AC0015
               #FUN-AB0059 ----------------add start----------
               IF NOT s_chk_item_no(tm.firm,'') THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD firm
               END IF
               #FUN-AB0059 ---------------add end------------  
            END IF #TQC-AC0015
            IF g_sma.sma100='Y' AND NOT cl_null(tm.firm) THEN #E-BOM轉P-BOM時料件編號需存料件主檔中
               SELECT COUNT(*) INTO l_cnt FROM ima_file WHERE ima01 = tm.firm
               IF SQLCA.sqlcode OR l_cnt <= 0 THEN
                  #E-BOM轉P-BOM時料件編號需存料件主檔中
                  CALL cl_err(tm.firm,'abm-110',0)
                  NEXT FIELD firm
               END IF
            END IF
            IF g_sma.sma100='N' AND NOT cl_null(tm.firm) THEN
               SELECT COUNT(*) INTO l_cnt FROM ima_file WHERE ima01 = tm.firm
               IF SQLCA.sqlcode OR l_cnt <= 0 THEN
               
               ELSE
                  CALL cl_err(tm.firm,'abm-802',0)
                  NEXT FIELD firm
               END IF
            END IF
            #FUN-B70060 add
            IF tm.firm[1,1] = ' ' THEN
               CALL cl_err(tm.firm,"aim-671",1)
               NEXT FIELD firm
            END IF
            #FUN-B70060 add--end
            SELECT ima02,ima021 
              INTO l_ima02,l_ima021
              FROM ima_file
             WHERE ima01 = tm.firm
            DISPLAY l_ima02  TO FORMONLY.ima02
            DISPLAY l_ima021 TO FORMONLY.ima021
            SELECT COUNT(*) INTO l_cnt FROM bma_file WHERE bma01 = tm.firm
            IF l_cnt > 0 THEN
               CALL cl_err(tm.firm,'mfg2760',1)
               NEXT FIELD firm
            END IF
         END IF
 

         
      AFTER FIELD edate 
         IF NOT cl_null(tm.edate) AND tm.edate <=tm.bdate THEN 
            CALL cl_err(tm.edate,'mfg2604',0)
            NEXT FIELD bdate
         END IF
 
      AFTER INPUT   

         IF tm.bmo06 IS NULL THEN
            LET tm.bmo06=' '
         END IF
         IF INT_FLAG THEN 
            EXIT INPUT 
         END IF
         
        ON ACTION CONTROLP     #查詢條件 
            CASE
               WHEN INFIELD(bmo01) 

                  CALL cl_init_qry_var()
                 #LET g_qryparam.form = 'q_bmo'      #MOD-C20125 mark
                  LET g_qryparam.form = 'q_bmo4'     #MOD-C20125 add
                  LET g_qryparam.default1 = tm.bmo01
                  LET g_qryparam.default1 = tm.bmo011
                  CALL cl_create_qry() RETURNING tm.bmo01,tm.bmo011

                  DISPLAY BY NAME tm.bmo01 
                  DISPLAY BY NAME tm.bmo011 
                  NEXT FIELD bmo01
               WHEN INFIELD(firm) 
#FUN-AB0025 ------------------------Begin--------------------------
               #   CALL cl_init_qry_var()
               #   LET g_qryparam.form = 'q_ima'
               #   LET g_qryparam.default1 = tm.firm
               #   CALL cl_create_qry() RETURNING tm.firm
                  CALL q_sel_ima(FALSE, "q_ima", "", tm.firm, "", "", "", "" ,"",'' )  RETURNING tm.firm 
#FUN-AB0025 ------------------------End----------------------------
                  DISPLAY tm.firm TO FORMONLY.firm
                  NEXT FIELD firm
               OTHERWISE EXIT CASE
             END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          LET g_change_lang = TRUE
          EXIT INPUT
      ON ACTION exit                            #加離開功能
          LET INT_FLAG = 1
          EXIT INPUT
   END INPUT
END FUNCTION
 
   
FUNCTION p100_b_fill()
   DEFINE l_sql    LIKE type_file.chr1000   #No.FUN-680096 CHAR(900)
   DEFINE l_ac     LIKE type_file.num5      #No.FUN-680096 SMALLINT
   DEFINE l_cnt    LIKE type_file.num5      #MOD-AB0014 add
 
   IF g_sma.sma100 = 'N' THEN
      LET l_sql = "SELECT '1',bmp02,bmp03,bmq02,bmq021,",
                  "       bmq01,bmp28 ", #FUN-550079      #No:MOD-9C0253 modify
                  "  FROM bmp_file,bmq_file ",
                  " WHERE bmp03 = bmq01 ",
                  "   AND (bmq011 IS NULL OR bmq011= ' ' )",
                  "   AND bmp01 = '",tm.bmo01,"'",
                  "   AND bmp011= '",tm.bmo011,"'",
                  "   AND bmp28='",tm.bmo06,"'", #FUN-560030
                  " UNION ",  
                  "SELECT '2',bmp02,bmp03,ima02,ima021,",
                  "       ima01,bmp28 ", #FUN-550079
                  "   FROM bmp_file,ima_file,bmq_file ",
                  "   WHERE ((bmq011 = ima01 ",
                  "   AND bmp03 = bmq01 ) ",
                  "   OR( bmp03 = ima01) ) ",
                  "   AND bmp01 = '",tm.bmo01,"'",
                  "   AND bmp011= '",tm.bmo011,"'",
                  "   AND bmp28='",tm.bmo06,"'", #FUN-560030
                  "  ORDER BY bmp03 "   #No.TQC-9A0155 mod 
    ELSE
       #已有正式料號，所以僅直接抓 bmp_file OUTER ima_file 
       #並且 Flag 設為 2:正式料，後續就不會再 INSERT ima_file
       LET l_sql ="SELECT '2',bmp02,bmp03,ima02,ima021, ",
                 #"       bmq01,bmp28 ", #FUN-550079          #No:MOD-9C0253 modify
                  "       '',bmp28 ", #FUN-550079          #No:MOD-9C0253 modify  #Mod No.MOD-AB0064
                  "  FROM bmp_file LEFT OUTER JOIN ima_file ON bmp03=ima01",   #No.TQC-9A0155 mod
                  "   WHERE bmp01 = '",tm.bmo01,"'",
                  "   AND bmp011= '",tm.bmo011,"'",
                  "   AND bmp28='",tm.bmo06,"'", #FUN-560030
                  "  ORDER BY bmp03 "  #NO.TQC-9A0155 mod
    END IF
 
    PREPARE p100_bmp FROM l_sql 
    DECLARE p100_bmpcur
              CURSOR WITH HOLD FOR p100_bmp
    CALL b_bmp.clear()
    CALL g_bmp.clear()
 
    LET l_ac = 1
  
    CALL s_showmsg_init()   #No.FUN-710014  
 
    LET g_cnt = 0     #MOD-AB0014 add
    FOREACH p100_bmpcur INTO b_bmp[l_ac].*,g_bmp[l_ac].*
       IF SQLCA.sqlcode THEN 

         CALL s_errmsg('','','p100_bmpcur',SQLCA.sqlcode,1)
          LET g_success='N'            #No.FUN-8A0086
         LET g_totsuccess='N'
         CONTINUE FOREACH
       END IF
       LET g_bmp[l_ac].item = g_bmp[l_ac].bmp03 #Add No.MOD-AB0064
       IF g_sma.sma100 = 'Y' THEN
          IF cl_null(g_bmp[l_ac].bmq02) THEN
             SELECT bmq02,bmq021 INTO g_bmp[l_ac].bmq02,g_bmp[l_ac].bmq021
               FROM bmq_file WHERE bmq01 = g_bmp[l_ac].bmp03
          END IF
       END IF
      #MOD-AB0014---add---start---
       LET l_cnt = 0
       SELECT COUNT(*) INTO l_cnt FROM ima_file
        WHERE ima01=g_bmp[l_ac].bmp03
       IF l_cnt > 0 THEN
          LET g_cnt=g_cnt + 1
       END IF
      #MOD-AB0014---add---end---
       LET l_ac = l_ac + 1
       IF l_ac > g_max_rec THEN   #MOD-A50091 mod g_cnt->l_ac
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
   IF g_totsuccess="N" THEN 
      LET g_success="N"
   END IF
 
   CALL s_showmsg()
   CALL g_bmp.deleteElement(l_ac)   #MOD-A50091 mod g_cnt->l_ac
   CALL SET_COUNT(l_ac-1)               #告訴I.單身筆數
   LET g_rec_b = l_ac -1
END FUNCTION
   
FUNCTION p100_array()
  DEFINE  l_ac_t          LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          l_cnt           LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          l_allow_insert  LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          l_allow_delete  LIKE type_file.num5     #No.FUN-680096 SMALLINT
   DEFINE l_bmq011        LIKE bmq_file.bmq011    #MOD-540142
   DEFINE j               LIKE type_file.num5,    #MOD-AB0014 add
          l_c             LIKE type_file.num5     #MOD-AB0014 add 
 
   CALL cl_opmsg('s')
 
   LET l_ac_t = 0
   LET l_allow_insert = FALSE
   LET l_allow_delete = FALSE
 
     CALL cl_set_act_visible("accept,cancel", TRUE)     #MOD-AB0014 add
     INPUT ARRAY g_bmp WITHOUT DEFAULTS FROM s_bmp.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
          LET g_before_input_done = FALSE
          LET g_before_input_done = TRUE
 
      BEFORE ROW
          LET l_ac = ARR_CURR()
          LET l_n  = ARR_COUNT()
          LET g_bmp_t.* = g_bmp[l_ac].*
 
          #若該測試料號已經轉過正式料號,則不可再轉,也不可以改,所以設為NoEntry
          #MOD-D10116---begin
          #SELECT COUNT(*) INTO l_cnt FROM bmq_file
          #   WHERE bmq011=g_bmp_t.bmp03
          #IF l_cnt>0 THEN
          #   CALL cl_set_comp_entry("item",FALSE)
          #ELSE
          #MOD-D10116---end
             CALL cl_set_comp_entry("item",TRUE)
          #END IF  #MOD-D10116
 
          CALL cl_show_fld_cont()     #FUN-550037(smin)
 
      AFTER FIELD item
         IF NOT cl_null(g_bmp[l_ac].item) THEN # BugNo:6542
            IF g_sma.sma100='Y' AND NOT cl_null(g_bmp[l_ac].item) THEN #E-BOM轉P-BOM時料件編號需存料件主檔中
               SELECT COUNT(*) INTO l_cnt
                 FROM ima_file
                WHERE ima01 = g_bmp[l_ac].item
 
               IF SQLCA.sqlcode OR l_cnt <= 0 THEN
                   #E-BOM轉P-BOM時料件編號需存料件主檔中
                   CALL cl_err(g_bmp[l_ac].item,'abm-110',0)
                   NEXT FIELD item
               END IF
             END IF
             #FUN-B70060 add
             IF g_bmp[l_ac].item[1,1] = ' ' THEN
                CALL cl_err(g_bmp[l_ac].item,"aim-671",0)
                NEXT FIELD item
             END IF
             #FUN-B70060 add--end
         END IF
 
         LET l_bmq011 = ''   #MOD-BA0041 add
         SELECT bmq011 INTO l_bmq011 FROM bmq_file WHERE bmq01=g_bmp[l_ac].bmp03
         IF NOT cl_null(l_bmq011) THEN
            IF l_bmq011 <> g_bmp[l_ac].item THEN
               CALL cl_err(l_bmq011,'abm-743',1)
               LET g_bmp[l_ac].item=l_bmq011
               NEXT FIELD item
            END IF 
         END IF   
      BEFORE FIELD item
         #MOD-D10116---begin
         SELECT COUNT(*) INTO l_cnt FROM bmq_file
            WHERE bmq011=g_bmp_t.bmp03
         IF l_cnt>0 THEN
            CALL cl_set_comp_entry("item",FALSE)
         ELSE
            CALL cl_set_comp_entry("item",TRUE)
         END IF
         #MOD-D10116---end
         IF NOT cl_null(g_bmp[l_ac].bmp03) THEN
               SELECT COUNT(*) INTO l_cnt
                 FROM ima_file
                WHERE ima01 = g_bmp[l_ac].bmp03
             IF l_cnt > 0 THEN
                CALL p100_set_no_entry()
             ELSE
                CALL p100_set_entry()
             END IF
         END IF
            
 
      AFTER ROW
        #MOD-AB0014---add---start---
        #若其他筆的料號皆為正式料號，則跳出INPUT ARRAY
         LET l_c = 0
         FOR j = l_ac +1 to g_rec_b
            SELECT COUNT(*) INTO l_cnt
              FROM ima_file
             WHERE ima01 = g_bmp[j].bmp03
            IF l_cnt = 0 THEN
               LET l_c = l_c + 1 
            END IF
         END FOR
         IF l_c = 0 THEN EXIT INPUT END IF
        #MOD-AB0014---add---end---
         IF INT_FLAG THEN EXIT INPUT END IF
 

 
        ON ACTION CONTROLP     #查詢條件 
            CASE
               WHEN INFIELD(item)
#FUN-AB0025 --------------------Begin----------------
                #  CALL cl_init_qry_var()
                #  LET g_qryparam.form = 'q_ima'
                #  LET g_qryparam.default1 = g_bmp[l_ac].item
                #  CALL cl_create_qry() RETURNING g_bmp[l_ac].item
                   CALL q_sel_ima(FALSE, "q_ima", "", g_bmp[l_ac].item, "", "", "", "" ,"",'' )  RETURNING g_bmp[l_ac].item 
#FUN-AB0025 --------------------End-------------------
                   DISPLAY g_bmp[l_ac].item TO item             #No.MOD-490371
                  NEXT FIELD item
               OTHERWISE EXIT CASE
             END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION controls                                             #No.FUN-6B0033
         CALL cl_set_head_visible("grid01,grid02,grid03","AUTO")     #No.FUN-6B0033
   END INPUT
END FUNCTION
   
FUNCTION p100()
   DEFINE  # l_time LIKE type_file.chr8        #No.FUN-6A0060
          l_sql     LIKE type_file.chr1000,  # RDSQL STATEMENT   #No.FUN-680096 VARCHAR(600)
          l_bmp     RECORD LIKE bmp_file.*,
          l_bec     RECORD LIKE bec_file.*,
          l_k       LIKE type_file.num5,     #No.FUN-680096 SMALLINT
          l_bmo06   LIKE bmo_file.bmo06,     #FUN-550079
          l_bmp28   LIKE bmp_file.bmp28,     #FUN-550079
          l_cnt     LIKE type_file.num5      #No.FUN-680096 SMALLINT
 
     LET l_bmo06=tm.bmo06
     IF l_bmo06 IS NULL THEN
       LET l_bmo06=' '
     END IF
 
     #-->更新 工程BOM單頭檔(bmo_file) 
      UPDATE bmo_file SET bmo05 = tm.bdate    #生效日期
              WHERE bmo01=tm.bmo01 AND bmo011=tm.bmo011 AND bmo06=tm.bmo06
           IF SQLCA.sqlerrd[3] = 0 THEN 
              CALL cl_err('ckp#01',SQLCA.sqlcode,1)
              LET g_success='N'
              RETURN
           END IF
 
     #-->更新 工程BOM單身檔(bmp_file)(生效日期) 
      UPDATE bmp_file SET bmp04 = tm.bdate    #生效日期
              WHERE bmp01 =tm.bmo01
                AND bmp011=tm.bmo011
           IF SQLCA.sqlerrd[3] = 0 THEN 
              CALL cl_err('ckp#1.2',SQLCA.sqlcode,1)
              LET g_success='N'
              RETURN
           END IF
 
     #-->產生BOM 單頭檔(bma_file)
       INSERT INTO bma_file (bma01,bma02,bma03,bma04,bma05,bmauser,bmagrup,  #No.MOD-470041
                            bmamodu,bmadate,bmaacti,bma06,bma10,bma08,bmaoriu,bmaorig) #FUN-550079  #MOD-910241 add bma10 #Mod-920023 add bma08
           VALUES(tm.firm,g_bmo.bmo02,g_bmo.bmo03,g_bmo.bmo04,NULL,
                  g_bmo.bmouser,g_bmo.bmogrup,g_bmo.bmomodu,
                  g_bmo.bmodate,g_bmo.bmoacti,l_bmo06,'0',g_plant, g_user, g_grup) #FUN-550079        #MOD-910241 #Mod-920023 add g_plant      #No.FUN-980030 10/01/04  insert columns oriu, orig
          IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
             CALL cl_err('ckp#02',SQLCA.sqlcode,1)
             LET g_success = 'N'
             RETURN 

          END IF 
      SELECT COUNT(*) INTO g_cnt FROM ima_file WHERE ima01=tm.firm
      IF g_cnt = 0 THEN
         CALL p100_ima(tm.bmo01,tm.firm,l_bmo06) #FUN-550079
      END IF
      CALL p100_up_bmq011(tm.bmo01,tm.firm) #BugNo:6542
      IF g_success ='N' THEN RETURN END IF
 
      FOR l_k = 1 TO g_rec_b
 
          #因為在arry 中的測試料號可能會改成另外的正式料號但 
          #必須要保留原來的元件料號,後續要 insert 的其他檔案必須以原來的
          #元件料號才能取到資料,
          SELECT * INTO l_bmp.* FROM bmp_file
           WHERE bmp01=tm.bmo01 AND bmp02=b_bmp[l_k].bmp02 AND bmp03=g_bmp[l_k].bmp03 AND bmp011=tm.bmo011 AND bmp28=tm.bmo06  #No.TQC-950134
 
          IF SQLCA.sqlcode THEN
            LET g_showmsg=' '  #No.TQC-950134
            CALL s_errmsg(" ",g_showmsg,"sel bmp",SQLCA.sqlcode,1)
            LET g_totsuccess = 'N'
            CONTINUE FOR     
          END IF
 
          LET l_bmp.bmp01   = tm.firm    
          LET l_bmp.bmp04   = tm.bdate
          LET l_bmp.bmp05   = tm.edate
          LET l_bmp.bmpmodu = g_user   
          LET l_bmp.bmpdate = g_today  
          LET l_bmp.bmpcomm = 'abmp100'
          LET l_bmp28 = g_bmp[l_k].bmp28  #FUN-550079
          IF l_bmp28 IS NULL THEN
            LET l_bmp28=' ' 
          END IF
 
          IF cl_null(l_bmp.bmp02)  THEN
             LET l_bmp.bmp02=' '
          END IF
         #MOD-AA0039---add---start---
          IF cl_null(l_bmp.bmp14) THEN LET l_bmp.bmp14='0' END IF
          IF cl_null(l_bmp.bmp19) THEN 
             SELECT ima110 INTO l_bmp.bmp19 FROM ima_file
              WHERE ima01 = g_bmp[l_k].item
          END IF
          IF cl_null(l_bmp.bmp19) THEN LET l_bmp.bmp19 = '1' END IF
         #MOD-AA0039---add---end---
 
          #-->產生(bmb_file)
           INSERT INTO bmb_file (bmb01,bmb02,bmb03,bmb04,bmb05,bmb06,  #No:BUG-470041 #No.MOD-480013
                                bmb07,bmb08,bmb081,bmb082,bmb09,bmb10,bmb10_fac,bmb10_fac2,    #TQC-AC0183 add bmb081,bmb082
                                bmb11,bmb13,bmb14,bmb15,bmb16,bmb17,bmb18,
                                bmb19,bmb20,bmb21,bmb22,bmb23,bmb24,bmb25,
                                bmb26,bmb27,bmb28,bmbmodu,bmbdate,bmbcomm,bmb29,bmb30,bmb33,bmb31)   #No.MOD-480013 #FUN-550079 #FUN-560030 #No.FUN-830116  #Mod No:TQC-AC0157 add bmb31
               VALUES(l_bmp.bmp01,l_bmp.bmp02,g_bmp[l_k].item,l_bmp.bmp04,
                      l_bmp.bmp05,l_bmp.bmp06,l_bmp.bmp07,l_bmp.bmp08,l_bmp.bmp081,l_bmp.bmp082,   #TQC-AC0183 add bmp081,bmp082
                      l_bmp.bmp09,l_bmp.bmp10,l_bmp.bmp10_fac,l_bmp.bmp10_fac2,
                      l_bmp.bmp11,l_bmp.bmp13,l_bmp.bmp14,l_bmp.bmp15,
                      l_bmp.bmp16,l_bmp.bmp17,l_bmp.bmp18,l_bmp.bmp19,
                      l_bmp.bmp20,l_bmp.bmp21,l_bmp.bmp22,l_bmp.bmp23,
                      l_bmp.bmp24,l_bmp.bmp25,l_bmp.bmp26,l_bmp.bmp27,
                      0,g_user,g_today,'abmp100',l_bmo06,l_bmp.bmp29,0,'N') #FUN-550079 #FUN-560030  #No.FUN-830116  #Mod No:TQC-AC0157 add 'N'
              IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
  
                 LET g_showmsg=l_bmp.bmp01,"/",l_bmp.bmp02,"/",
                               g_bmp[l_k].item,"/",l_bmp.bmp04,"/",0
                 CALL s_errmsg("bmp01,bmp02,bmp03,bmp04,bmp28",g_showmsg,"(ckp#03)",SQLCA.sqlcode,1)
                 LET g_totsuccess = 'N'
                 CONTINUE FOR
               END IF     
 
          #-->產生(ima_file)
          SELECT COUNT(*) INTO g_cnt FROM ima_file 
           WHERE ima01=g_bmp[l_k].item
          IF b_bmp[l_k].sou = '1' AND g_cnt = 0 THEN    
             CALL p100_ima(l_bmp.bmp03,g_bmp[l_k].item,l_bmp28) #FUN-550079
          END IF
          CALL p100_up_bmq011(l_bmp.bmp03,g_bmp[l_k].item)
           IF g_totsuccess ='N' THEN CONTINUE FOR END IF              #No.FUN-710014
 
          #-->低階碼可否部份重計
          IF g_sma.sma845='Y'
          THEN LET g_success='Y'
               #CALL s_uima146(g_bmp[l_k].item)  #CHI-D10044
               CALL s_uima146(g_bmp[l_k].item,0)  #CHI-D10044
               MESSAGE ""
               CALL ui.Interface.refresh()
          END IF
 
          #-->產生插件位置(bmt_file) --> copy from bmu_file TO bmt_file
          CALL p100_ins_bmt(l_bmp.*,g_bmp[l_k].item) 
           IF g_totsuccess ='N' THEN CONTINUE FOR END IF              #No.FUN-710014
 
          #-->產生元件廠牌(bml_file) --> copy from bel_file TO bml_file
          CALL p100_ins_bml(l_bmp.*,g_bmp[l_k].item)
           IF g_totsuccess ='N' THEN CONTINUE FOR END IF              #No.FUN-710014
 
          #-->產生BOM說明檔(bmc_file) -->copy from bec_file TO bmc_file
          CALL p100_ins_bmc(l_bmp.*,g_bmp[l_k].item)
           IF g_totsuccess ='N' THEN CONTINUE FOR END IF              #No.FUN-710014
 
          #-->產生取替代檔(bmd_file) -->copy from bed_file TO bmd_file
          CALL p100_ins_bmd(l_bmp.*,g_bmp[l_k].item)
           IF g_totsuccess ='N' THEN CONTINUE FOR END IF              #No.FUN-710014
       END FOR     
   IF g_totsuccess="N" THEN 
      LET g_success="N"
   END IF
 
   CALL s_showmsg()
END FUNCTION
   
FUNCTION p100_ima(p_item,p_firm,p_acode) #FUN-550079 加 特性代碼 參數
  DEFINE  p_item   LIKE ima_file.ima01,
          p_firm   LIKE ima_file.ima01,
          p_acode  LIKE ima_file.ima910, #FUN-550079
          l_bmq    RECORD LIKE bmq_file.*,
          l_ima    RECORD LIKE ima_file.*,
          l_ans    LIKE type_file.chr1,      #No.FUN-680096 VARCHAR(1)
          l_msg    LIKE type_file.chr1000    #No.FUN-680096 VARCHAR(100)
  DEFINE  l_imaicd RECORD LIKE imaicd_file.* #No.FUN-7B0018
  DEFINE  l_flag   LIKE type_file.chr1       #No.FUN-7B0018
 
  #--->取測試料件基本資料
  SELECT * INTO l_bmq.* FROM bmq_file WHERE bmq01 = p_item  
  IF SQLCA.sqlcode THEN RETURN END IF 
 
  IF p_acode IS NULL THEN 
    LET p_acode=' ' 
  END IF
 
  INITIALIZE l_ima.* TO NULL 
  IF cl_null(l_bmq.bmq06) THEN 
      #測試料件沒有輸入分群碼(bmq06),是否確定執行?
      ERROR ""
      IF NOT cl_confirm('abm-009') THEN #不執行
          LET g_success = 'N'
          RETURN
      ELSE
          #要執行
          CALL cl_wait()
          LET l_ima.ima01 = p_firm
          LET l_ima.ima02 = l_bmq.bmq02
          LET l_ima.ima021= l_bmq.bmq021
          LET l_ima.ima05 = l_bmq.bmq05
          LET l_ima.ima06 = l_bmq.bmq06
          LET l_ima.ima08 = l_bmq.bmq08
          LET l_ima.ima09 = l_bmq.bmq09
          LET l_ima.ima10 = l_bmq.bmq10
          LET l_ima.ima11 = l_bmq.bmq11
          LET l_ima.ima12 = l_bmq.bmq12
          LET l_ima.ima15 = l_bmq.bmq15
          LET l_ima.ima25 = l_bmq.bmq25
          LET l_ima.ima31 = l_bmq.bmq31
          LET l_ima.ima37 = l_bmq.bmq37
          LET l_ima.ima44 = l_bmq.bmq44
          LET l_ima.ima53 = l_bmq.bmq53
          LET l_ima.ima531= l_bmq.bmq531
          LET l_ima.ima55 = l_bmq.bmq55
          LET l_ima.ima63 = l_bmq.bmq63
          LET l_ima.ima91 = l_bmq.bmq91
          LET l_ima.ima103= l_bmq.bmq103
          LET l_ima.ima105= l_bmq.bmq105
          LET l_ima.ima31_fac= l_bmq.bmq31_fac
          LET l_ima.ima44_fac= l_bmq.bmq44_fac
          LET l_ima.ima55_fac= l_bmq.bmq55_fac
          LET l_ima.ima63_fac= l_bmq.bmq63_fac
          LET l_ima.ima86 = l_bmq.bmq25
          LET l_ima.ima903 = l_bmq.bmq903   #TQC-C50028
          LET l_ima.ima07 = 'A'
          LET l_ima.ima14 = 'N'
          LET l_ima.ima16 = 99
          LET l_ima.ima18 = 0
          LET l_ima.ima20 = 0
          LET l_ima.ima22 = 0
#          LET l_ima.ima26 = 0         #FUN-A20044
#          LET l_ima.ima262 = 0        #FUN-A20044
#          LET l_ima.ima261 = 0        #FUN-A20044  
          LET l_ima.ima27 = 0
          LET l_ima.ima271 = 0
          LET l_ima.ima28 = 0
          LET l_ima.ima29 = g_sma.sma30
          LET l_ima.ima30 = g_sma.sma30
          LET l_ima.ima32 = 0
          LET l_ima.ima33 = 0
          LET l_ima.ima38 = 0
          LET l_ima.ima130 ='1' 
          LET l_ima.ima140 ='N' 
          LET l_ima.ima121 =0 LET l_ima.ima122 =0 LET l_ima.ima123 =0
          LET l_ima.ima124 =0 LET l_ima.ima125 =0 LET l_ima.ima126 =0
          LET l_ima.ima127 =0 LET l_ima.ima128 =0 
          LET l_ima.ima40 = 0
          LET l_ima.ima41 = 0
          LET l_ima.ima42 = '0'
          LET l_ima.ima45 = 0
          LET l_ima.ima46 = 0
          LET l_ima.ima47 = 0
          LET l_ima.ima48 = 0
          LET l_ima.ima49 = 0
          LET l_ima.ima491 = 0
          LET l_ima.ima50 = 0
          LET l_ima.ima51 = 1
          LET l_ima.ima52 = 1
          LET l_ima.ima56 = 1
          LET l_ima.ima561 = 1 
          LET l_ima.ima562 = 0
          LET l_ima.ima58 = 0
          LET l_ima.ima59 = 0
          LET l_ima.ima60 = 0
          LET l_ima.ima61 = 0
          LET l_ima.ima62 = 0
          LET l_ima.ima64  = 0
          LET l_ima.ima641 = 0
          LET l_ima.ima65  = 0
          LET l_ima.ima66  = 0
          LET l_ima.ima68  = 0
          LET l_ima.ima69  = 0
          LET l_ima.ima70  = 'N'
          LET l_ima.ima71  = 0
          LET l_ima.ima72  = 0
          LET l_ima.ima721  = 0  #CHI-C50068
          LET l_ima.ima75  = ''
          LET l_ima.ima76  = ''
          LET l_ima.ima77  = 0
          LET l_ima.ima78  = 0
          LET l_ima.ima80  = 0
          LET l_ima.ima81  = 0
          LET l_ima.ima82  = 0
          LET l_ima.ima83  = 0
          LET l_ima.ima84  = 0
          LET l_ima.ima85  = 0
          LET l_ima.ima94  = ''
          LET l_ima.ima95  = 0
          LET l_ima.ima96  = 0
          LET l_ima.ima97  = 0
          LET l_ima.ima98  = 0
          LET l_ima.ima99  = 0
          LET l_ima.ima100 = 'N'
          LET l_ima.ima101 = '1'
          LET l_ima.ima102 = 0
          LET l_ima.ima139 = 'N' 
          LET l_ima.ima852 = 'N'
          LET l_ima.ima853 = 'N'
          LET l_ima.ima86_fac = 1
          LET l_ima.ima871 = 0
          LET l_ima.ima873 = 0
          LET l_ima.ima910 = p_acode; #FUN-550079
          LET l_ima.ima911 = 'N'       #No.MOD-780061 add
          LET l_ima.ima99  = 0
          LET l_ima.ima93  = "NNNNNNNN"
          LET l_ima.imauser = g_user
          LET l_ima.imagrup = g_grup  
          LET l_ima.imadate = g_today
          LET l_ima.ima901 = g_today               #料件建檔日期
          LET l_ima.imaacti='P' #MOD-740179
          LET l_ima.ima1010='0' #MOD-740179 0:開立
          LET l_ima.ima906 = g_imz.imz906  #MOD-890124 add
          LET l_ima.ima907 = g_imz.imz907  #MOD-890124 add
          LET l_ima.ima908 = g_imz.imz908  #MOD-890124 add
      END IF
  ELSE    #bmq06 IS NOT NULL
      SELECT *  INTO g_imz.*
        FROM  imz_file
       WHERE imz01   = l_bmq.bmq06
         AND imzacti = 'Y'
      IF NOT STATUS THEN 
          IF g_imz.imz99 IS NULL THEN LET g_imz.imz99 = 0 END IF
          IF g_imz.imz17 IS NULL THEN LET g_imz.imz17 = g_imz.imz31 END IF
 
          LET l_ima.ima01 = p_firm
          LET l_ima.ima02 = l_bmq.bmq02
          LET l_ima.ima021= l_bmq.bmq021
          LET l_ima.ima05 = l_bmq.bmq05
          LET l_ima.ima06 = l_bmq.bmq06
          LET l_ima.ima08 = l_bmq.bmq08
          LET l_ima.ima09 = l_bmq.bmq09
          LET l_ima.ima10 = l_bmq.bmq10
          LET l_ima.ima11 = l_bmq.bmq11
          LET l_ima.ima12 = l_bmq.bmq12
          LET l_ima.ima15 = l_bmq.bmq15
          LET l_ima.ima25 = l_bmq.bmq25
          LET l_ima.ima31 = l_bmq.bmq31
          LET l_ima.ima37 = l_bmq.bmq37
          LET l_ima.ima44 = l_bmq.bmq44
          LET l_ima.ima53 = l_bmq.bmq53
          LET l_ima.ima531= l_bmq.bmq531
          LET l_ima.ima55 = l_bmq.bmq55
          LET l_ima.ima63 = l_bmq.bmq63
          LET l_ima.ima91 = l_bmq.bmq91
          LET l_ima.ima103= l_bmq.bmq103
          LET l_ima.ima105= l_bmq.bmq105
          LET l_ima.ima31_fac= l_bmq.bmq31_fac
          LET l_ima.ima44_fac= l_bmq.bmq44_fac
          LET l_ima.ima55_fac= l_bmq.bmq55_fac
          LET l_ima.ima63_fac= l_bmq.bmq63_fac
          #***************
          #利用分群碼bmq06找到imz_file的相關資料給ima_file預設值 
          #**************
          LET l_ima.ima03 = g_imz.imz03
          LET l_ima.ima04 = g_imz.imz04
          LET l_ima.ima07 = g_imz.imz07
          LET l_ima.ima14 = g_imz.imz14
          LET l_ima.ima16 = 99
          LET l_ima.ima18 = 0
          LET l_ima.ima19 = g_imz.imz19
          LET l_ima.ima20 = 0
          LET l_ima.ima21 = g_imz.imz21
          LET l_ima.ima22 = 0
          LET l_ima.ima23 = g_imz.imz23
          LET l_ima.ima24 = 'N' #MOD-540087
#          LET l_ima.ima26 = 0  #FUN-A20044
#          LET l_ima.ima262= 0  #FUN-A20044
#          LET l_ima.ima261= 0  #FUN-A20044 
          LET l_ima.ima27 = g_imz.imz27
          LET l_ima.ima27 = s_digqty(l_ima.ima27,l_ima.ima25) #FUN-BB0083 add
          LET l_ima.ima271= 0
          LET l_ima.ima28 = g_imz.imz28
          LET l_ima.ima28 = s_digqty(l_ima.ima28,l_ima.ima25) #FUN-BB0083 add
          LET l_ima.ima29 = g_sma.sma30
          LET l_ima.ima30 = g_sma.sma30
          LET l_ima.ima32 = 0
          LET l_ima.ima33 = 0
          LET l_ima.ima34 = g_imz.imz34
          LET l_ima.ima35 = g_imz.imz35
          LET l_ima.ima36 = g_imz.imz36
          LET l_ima.ima38 = g_imz.imz38
          LET l_ima.ima38 = s_digqty(l_ima.ima38,l_ima.ima25) #FUN-BB0083 add
          LET l_ima.ima39 = g_imz.imz39
          LET l_ima.ima130='1' 
          LET l_ima.ima140='N' 
          LET l_ima.ima121=0 LET l_ima.ima122 =0 LET l_ima.ima123 =0
          LET l_ima.ima124=0 LET l_ima.ima125 =0 LET l_ima.ima126 =0
          LET l_ima.ima127=0 LET l_ima.ima128 =0 
          LET l_ima.ima40 = 0
          LET l_ima.ima41 = 0
          LET l_ima.ima42 = g_imz.imz42
          LET l_ima.ima43 = g_imz.imz43
          LET l_ima.ima45 = g_imz.imz45
          LET l_ima.ima45 = s_digqty(l_ima.ima45,l_ima.ima44) #FUN-BB0083 add
          LET l_ima.ima46 = g_imz.imz46
          LET l_ima.ima46 = s_digqty(l_ima.ima46,l_ima.ima44) #FUN-BB0083 add
          LET l_ima.ima47 = g_imz.imz47
          LET l_ima.ima48 = g_imz.imz48
          LET l_ima.ima49 = g_imz.imz49
          LET l_ima.ima491= g_imz.imz491
          LET l_ima.ima50 = g_imz.imz50
          LET l_ima.ima51 = g_imz.imz51
          LET l_ima.ima51 = s_digqty(l_ima.ima51,l_ima.ima44) #FUN-BB0083 add
          LET l_ima.ima52 = g_imz.imz52
          LET l_ima.ima52 = s_digqty(l_ima.ima52,l_ima.ima44) #FUN-BB0083 add
          LET l_ima.ima54 = g_imz.imz54
          LET l_ima.ima56 = g_imz.imz56
          LET l_ima.ima56 = s_digqty(l_ima.ima56,l_ima.ima55) #FUN-BB0083 add
          LET l_ima.ima561= g_imz.imz561
          LET l_ima.ima561= s_digqty(l_ima.ima561,l_ima.ima55) #FUN-BB0083 add
          LET l_ima.ima562= g_imz.imz562
          LET l_ima.ima571= g_imz.imz571
          LET l_ima.ima58 = 0
          LET l_ima.ima59 = g_imz.imz59
          LET l_ima.ima60 = g_imz.imz60
          LET l_ima.ima61 = g_imz.imz61
          LET l_ima.ima62 = g_imz.imz62
          LET l_ima.ima64 = g_imz.imz64
          LET l_ima.ima64 = s_digqty(l_ima.ima64,l_ima.ima63) #FUN-BB0083 add
          LET l_ima.ima641= g_imz.imz641
          LET l_ima.ima641= s_digqty(l_ima.ima641,l_ima.ima63) #FUN-BB0083 add
          LET l_ima.ima65 = g_imz.imz65
          LET l_ima.ima65 = s_digqty(l_ima.ima65,l_ima.ima25) #FUN-BB0083 add
          LET l_ima.ima66 = g_imz.imz66
          LET l_ima.ima67 = g_imz.imz67
          LET l_ima.ima68 = g_imz.imz68
          LET l_ima.ima69 = g_imz.imz69
          LET l_ima.ima70 = g_imz.imz70
          LET l_ima.ima71 = g_imz.imz71
          LET l_ima.ima72 = 0
          LET l_ima.ima721 = 0  #CHI-C50068
          LET l_ima.ima75 = ''
          LET l_ima.ima76 = ''
          LET l_ima.ima77 = 0
          LET l_ima.ima78 = 0
          LET l_ima.ima80 = 0
          LET l_ima.ima81 = 0
          LET l_ima.ima82 = 0
          LET l_ima.ima83 = 0
          LET l_ima.ima84 = 0
          LET l_ima.ima85 = 0
          LET l_ima.ima852= 'N'
          LET l_ima.ima853= 'N'
          LET l_ima.ima86 = g_imz.imz86
          LET l_ima.ima86_fac = g_imz.imz86_fac
          LET l_ima.ima87 = g_imz.imz87
          LET l_ima.ima871= g_imz.imz871
          LET l_ima.ima872= g_imz.imz872
          LET l_ima.ima873= g_imz.imz873
          LET l_ima.ima874= g_imz.imz874
          LET l_ima.ima88 = g_imz.imz88
          LET l_ima.ima88 = s_digqty(l_ima.ima88,l_ima.ima44) #FUN-BB0083 add
          LET l_ima.ima89 = g_imz.imz89
          LET l_ima.ima90 = g_imz.imz90
          LET l_ima.ima910 = p_acode; #FUN-550079
          LET l_ima.ima93 = "NNNNNNNN"
          LET l_ima.ima94 = ''
          LET l_ima.ima95 = 0
          LET l_ima.ima96 = 0
          LET l_ima.ima97 = 0
          LET l_ima.ima98 = 0
          LET l_ima.ima99 = g_imz.imz99
          LET l_ima.ima99 = s_digqty(l_ima.ima99,l_ima.ima44) #FUN-BB0083 add
          LET l_ima.ima100= 'N'
          LET l_ima.ima101= '1'
          LET l_ima.ima102= 0
          LET l_ima.ima107= l_bmq.bmq107 #BugNo:6165 插件位置
          LET l_ima.ima147= l_bmq.bmq147 #BugNo:6542 插件位置
          LET l_ima.ima139= 'N' 
          LET l_ima.imauser= g_user
          LET l_ima.imagrup= g_grup  
          LET l_ima.imadate= g_today
          LET l_ima.ima901 = g_today               #料件建檔日期
          LET l_ima.imaacti='P' #MOD-740179
          LET l_ima.ima1010='0' #MOD-740179 0:開立
         #LET l_ima.ima903 = 'N'            #TQC-C50028 mark
          LET l_ima.ima903 = l_bmq.bmq903   #TQC-C50028
          LET l_ima.ima911 = 'N'
          LET l_ima.ima913 = 'N'     #No.MOD-840111 add
          LET l_ima.ima915 = '0'     #No.MOD-7B0030 add
      END IF
  END IF
 
  IF cl_null(l_ima.ima915) THEN
     LET l_ima.ima915='0'
  END IF
  IF cl_null(l_ima.ima916) THEN
     LET l_ima.ima916=g_plant #No.MOD-960298  --Begin
  END IF
  IF cl_null(l_ima.ima150) THEN
     LET l_ima.ima150=' '
  END IF
  IF cl_null(l_ima.ima151) THEN
     LET l_ima.ima151=' '
  END IF
  IF cl_null(l_ima.ima152) THEN
     LET l_ima.ima152=' '
  END IF
#TQC-C20180---begin
  IF cl_null(l_ima.ima928) THEN
     LET l_ima.ima928=' '
  END IF
#TQC-C20180---end

#TQC-C50028 ------Begin--------
  IF cl_null(l_ima.ima903) THEN
     LET l_ima.ima903 = 'N'
  END IF
#TQC-C50028 ------End----------
  
  #-->產生料件基本資料
  LET l_ima.ima601 = 1     #No.FUN-840194
# IF cl_null(l_ima.ima26 ) THEN LET l_ima.ima26  = 0 END IF  #FUN-A20066
# IF cl_null(l_ima.ima261) THEN LET l_ima.ima261 = 0 END IF  #FUN-A20066
# IF cl_null(l_ima.ima262) THEN LET l_ima.ima262 = 0 END IF  #FUN-A20066
  IF cl_null(l_ima.ima915) THEN LET l_ima.ima915 = '0' END IF
  IF cl_null(l_ima.ima916) THEN LET l_ima.ima916 = g_plant END IF
  IF cl_null(l_ima.ima150) THEN LET l_ima.ima150 = '0' END IF
  IF cl_null(l_ima.ima151) THEN LET l_ima.ima151 = 'N' END IF
  IF cl_null(l_ima.ima152) THEN LET l_ima.ima152 = '0' END IF
  IF cl_null(l_ima.ima926) THEN LET l_ima.ima926 = 'N' END IF
  IF cl_null(l_ima.ima918) THEN LET l_ima.ima918 = 'N' END IF
  IF cl_null(l_ima.ima919) THEN LET l_ima.ima919 = 'N' END IF
  IF cl_null(l_ima.ima921) THEN LET l_ima.ima921 = 'N' END IF
  IF cl_null(l_ima.ima922) THEN LET l_ima.ima922 = 'N' END IF
  IF cl_null(l_ima.ima924) THEN LET l_ima.ima924 = 'N' END IF
  IF cl_null(l_ima.ima022) THEN LET l_ima.ima022 = 0   END IF   #FUN-A20037
  IF cl_null(l_ima.ima120) THEN LET l_ima.ima120 = '1' END IF   #Add No:TQC-AC0157
 
  #-->產生料件基本資料
  LET l_ima.imaoriu = g_user      #No.FUN-980030 10/01/04
  LET l_ima.imaorig = g_grup      #No.FUN-980030 10/01/04
 #FUN-A80150---add---start---
  IF cl_null(l_ima.ima156) THEN 
     LET l_ima.ima156 = 'N'
  END IF
  IF cl_null(l_ima.ima158) THEN 
     LET l_ima.ima158 = 'N'
  END IF
 #FUN-A80150---add---end---
  LET l_ima.ima927='N'   #No:FUN-AA0014

#TQC-BB0009 --begin--
# LET l_ima.ima159 = '1'   #TQC-C50028 mark 
#TQC-BB0009 --end--
  LET l_ima.ima159 = '3'   #TQC-C50028
  IF cl_null(l_ima.ima928) THEN LET l_ima.ima928 = 'N' END IF      #TQC-C20131  add
  IF cl_null(l_ima.ima160) THEN LET l_ima.ima160 = 'N' END IF      #FUN-C50036  add
  IF cl_null(l_ima.ima934) THEN LET l_ima.ima934 = 'N' END IF      #No.TQC-D40115   Add
  INSERT INTO ima_file VALUES(l_ima.*)
  IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
     CALL cl_err('ins ima',SQLCA.sqlcode,0)
     LET g_totsuccess = 'N' #No.MOD-840422
  ELSE
     IF s_industry('icd') THEN       #No.FUN-830132 add
        INITIALIZE l_imaicd.* TO NULL
        LET l_imaicd.imaicd00 = l_ima.ima01
        LET l_flag = s_ins_imaicd(l_imaicd.*,'')
     END IF
  END IF

END FUNCTION
 
#-->產生插件位置(bmt_file) --> copy from bmu_file TO bmt_file
FUNCTION p100_ins_bmt(p_bmp,l_part)
DEFINE p_bmp RECORD like bmp_file.*,
       l_bmu RECORD LIKE bmu_file.*,
       l_bmt RECORD LIKE bmt_file.*,
       l_bmo06 LIKE bmo_file.bmo06, #FUN-550079
       l_part LIKE bmb_file.bmb03,  
       l_sql LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(400)
       l_cnt LIKE type_file.num5     #No.FUN-680096 SMALLINT
 
       LET l_bmo06=tm.bmo06
       IF l_bmo06 IS NULL THEN
         LET l_bmo06=' '
       END IF
       LET l_sql = " SELECT bmu_file.* FROM bmu_file ",
                   " WHERE bmu01 = ","'",tm.bmo01,"'",
                   "   AND bmu011= ","'",tm.bmo011,"'",
                   "   AND bmu02 =  ",p_bmp.bmp02,
                   "   AND bmu03 = ","'",p_bmp.bmp03,"'",
                   "   AND bmu08 = '",l_bmo06,"'"  #FUN-560030
 
       PREPARE p100_pbmu FROM l_sql 
       DECLARE p100_bmu_cs CURSOR FOR p100_pbmu
       FOREACH p100_bmu_cs INTO l_bmu.*
           LET l_bmt.bmt01 = tm.firm       #主件
           LET l_bmt.bmt02 = l_bmu.bmu02   #項次
           LET l_bmt.bmt03 = l_part        #元件 
           LET l_bmt.bmt04 = tm.bdate      #生效日期
           LET l_bmt.bmt05 = l_bmu.bmu05   #行序
           LET l_bmt.bmt06 = l_bmu.bmu06   #插件位置
           LET l_bmt.bmt07 = l_bmu.bmu07   #QPA
           LET l_bmt.bmt08 = l_bmo06       #FUN-550079
           IF cl_null(l_bmt.bmt02) THEN
              LET l_bmt.bmt02=0
           END IF
           INSERT INTO bmt_file VALUES(l_bmt.*) 
           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN

              LET g_showmsg=tm.firm,"/",l_bmu.bmu02,"/",
                            l_part,"/",tm.bdate,"/",
                            l_bmu.bmu05,"/",l_bmo06
              CALL s_errmsg("bmt01,bmt02,bmt03,bmt04,bmt05,bmt08",
                            g_showmsg,"ins bmt_file",SQLCA.sqlcode,1)
              LET g_totsuccess = 'N'
            CONTINUE FOREACH
           END IF     
        END FOREACH
END FUNCTION
 
#-->產生元件廠牌(bml_file) --> copy from bel_file TO bml_file
FUNCTION p100_ins_bml(p_bmp,l_part)
DEFINE p_bmp RECORD LIKE bmp_file.*,
       l_bel RECORD LIKE bel_file.*,
       l_bml RECORD LIKE bml_file.*,
       l_part LIKE bmb_file.bmb03,
       l_sql LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(400)
       l_cnt LIKE type_file.num5      #No.FUN-680096 SMALLINT
 
       LET l_sql = " SELECT bel_file.* FROM bel_file ",
                   " WHERE bel02 = ","'",tm.bmo01,"'",
                   "   AND bel011= ","'",tm.bmo011,"'",
                   "   AND bel01=  ","'",p_bmp.bmp03,"'"
 
       PREPARE p100_pbel FROM l_sql 
       DECLARE p100_bel_cs CURSOR FOR p100_pbel
       FOREACH p100_bel_cs INTO l_bel.*
           LET l_bml.bml01 = l_part         #元件
           LET l_bml.bml02 = tm.firm        #主件
           LET l_bml.bml03 = l_bel.bel03    #項次
           LET l_bml.bml04 = l_bel.bel04    #元件廠牌
           LET l_bml.bml05 = l_bel.bel05    #核准文號
           LET l_bml.bml06 = l_bel.bel06    #主要供應商
           INSERT INTO bml_file VALUES(l_bml.*)
           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN

              LET g_showmsg=l_part,"/",tm.firm,"/",l_bel.bel03
              CALL s_errmsg("bml01,bml02,bml03",
                            g_showmsg,"ins bml_file",SQLCA.sqlcode,1)
              LET g_totsuccess = 'N'
            CONTINUE FOREACH
           END IF     
       END FOREACH
END FUNCTION
 
#-->產生BOM說明檔(bmc_file) -->copy from bec_file TO bmc_file
FUNCTION p100_ins_bmc(p_bmp,l_part)
DEFINE p_bmp RECORD LIKE bmp_file.*,
       l_bec RECORD LIKE bec_file.*,
       l_bmc RECORD LIKE bmc_file.*,
       l_bmo06 LIKE bmo_file.bmo06, #FUN-550079
       l_part LIKE bmb_file.bmb03,
       l_sql LIKE type_file.chr1000,   #No.FUN-680096 VARCHAR(400)
       l_cnt LIKE type_file.num5       #No.FUN-680096 SMALLINT
 
       LET l_bmo06=tm.bmo06
       IF l_bmo06 IS NULL THEN
         LET l_bmo06=' '
       END IF
       LET l_sql = " SELECT bec_file.* FROM bec_file",
                   " WHERE bec01 = ","'",tm.bmo01,"'",
                   "   AND bec011= ","'",tm.bmo011,"'",
                   "   AND bec02=  ",p_bmp.bmp02,
                   "   AND bec021=  ","'",p_bmp.bmp03,"'",
                   "   AND bec06='",l_bmo06,"'"  #FUN-560030
 
       PREPARE p100_pbmc FROM l_sql 
       DECLARE p100_bmc_cs CURSOR FOR p100_pbmc
       FOREACH p100_bmc_cs INTO l_bec.*
           LET l_bmc.bmc01 = tm.firm
           LET l_bmc.bmc02 = l_bec.bec02
           LET l_bmc.bmc021= l_part      
           LET l_bmc.bmc03 = tm.bdate
           LET l_bmc.bmc04 = l_bec.bec04
           LET l_bmc.bmc05 = l_bec.bec05
           LET l_bmc.bmc06 = l_bmo06       #FUN-550079
           INSERT INTO bmc_file VALUES(l_bmc.*) 
           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
              LET g_showmsg=tm.firm,"/",l_bec.bec02,"/",
                            tm.bdate,"/",l_bec.bec04,"/",
                            l_bmo06
              CALL s_errmsg("bml01,bml02,bml03,bmc04,bmc06",
                            g_showmsg,"ins bmc_file",SQLCA.sqlcode,1)
              LET g_totsuccess = 'N'
            CONTINUE FOREACH
           END IF
       END FOREACH
END FUNCTION
 
#-->產生取替代檔(bmd_file) -->copy from bed_file TO bmd_file
FUNCTION p100_ins_bmd(p_bmp,l_part)
DEFINE p_bmp RECORD LIKE bmp_file.*,
       l_bed RECORD LIKE bed_file.*,
       l_bmd RECORD LIKE bmd_file.*,
       l_part   LIKE bmb_file.bmb03,
       l_sql LIKE type_file.chr1000,   #No.FUN-680096 VARCHAR(400)
       l_cnt LIKE type_file.num5       #No.FUN-680096 SMALLINT
 
       LET l_sql = " SELECT bed_file.* FROM bed_file",
                   " WHERE bed01 = ","'",tm.bmo01,"'",  #主件
                   "   AND bed011= ","'",tm.bmo011,"'", #版號
                   "   AND bed012= ",p_bmp.bmp02        #項次
       PREPARE p100_pbed FROM l_sql 
       DECLARE p100_bed_cs CURSOR FOR p100_pbed
       FOREACH p100_bed_cs INTO l_bed.*
           LET l_bmd.bmd01 = l_part         #元件
           LET l_bmd.bmd02 = l_bed.bed02    #檔案類別
           LET l_bmd.bmd03 = l_bed.bed03    #替代序號
           LET l_bmd.bmd04 = l_bed.bed04    
           LET l_bmd.bmd05 = l_bed.bed05       #MOD-910241
           LET l_bmd.bmd06 = l_bed.bed06       #MOD-910241
           LET l_bmd.bmd07 = l_bed.bed07
           LET l_bmd.bmd08 = tm.firm 
           LET l_bmd.bmd09 = l_bed.bed09       #MOD-910241
           LET l_bmd.bmdacti = 'Y'             #MOD-910241
           LET l_bmd.bmdgrup = g_grup          #MOD-910241
           LET l_bmd.bmduser = g_user          #MOD-910241
           LET l_bmd.bmddate = g_today         #FUN-920040
           LET l_bmd.bmdoriu = g_user      #No.FUN-980030 10/01/04
           LET l_bmd.bmdorig = g_grup      #No.FUN-980030 10/01/04
           IF cl_null(l_bmd.bmd11) THEN LET l_bmd.bmd11 = 'N' END IF      #TQC-C20131  add
           INSERT INTO bmd_file VALUES(l_bmd.*) 
           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 

              LET g_showmsg=l_part,"/",l_bed.bed02,"/",
                            l_bed.bed03,"/",l_bed.bed04,"/",
                            tm.firm
              CALL s_errmsg("bmd01,bmd02,bmd03,bmd04,bmd08",
                            g_showmsg,"ins bmd:",SQLCA.sqlcode,1)
              LET g_totsuccess = 'N'
            CONTINUE FOREACH
           END IF
       END FOREACH
END FUNCTION
 
FUNCTION p100_up_bmq011(p_bmq01,p_bmq011)
  DEFINE p_bmq01    LIKE bmq_file.bmq01,
         p_bmq011   LIKE bmq_file.bmq011,
         l_cnt      LIKE type_file.num10    #No.FUN-680096 INTEGER
 
         SELECT COUNT(*) INTO l_cnt
           FROM bmq_file
          WHERE bmq01 = p_bmq01
         IF l_cnt > 0 THEN
             UPDATE bmq_file SET bmq011 = p_bmq011
              WHERE bmq01= p_bmq01
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err('update bmq011 error',SQLCA.sqlcode,0)
                 LET g_success = 'N'
             END IF
         END IF
END FUNCTION
FUNCTION p100_set_entry()
   CALL cl_set_comp_entry("item",TRUE)
END FUNCTION
 
FUNCTION p100_set_no_entry()
   CALL cl_set_comp_entry("item",FALSE)
END FUNCTION
#No:FUN-9C0077
