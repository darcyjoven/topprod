# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: asfp311.4gl
# Descriptions...: RUN CARD 製程調整
# Date & Author..: 00/05/20 By Melody
# Modify.........: No.MOD-470041 04/07/16 By Wiky 修改INSERT INTO...
# Modify.........: No.MOD-4A0012 04/11/01 By Yuna 語言button沒亮
# Modify.........: No.FUN-550067 05/05/30 By Trisy 單據編號加大
# Modify.........: No.MOD-550136 05/05/20 By Carol line:451 應由 IF cl_null(g_s009) THEN ->IF cl_null(g_f09) THEN
# Modify.........: No.MOD-530549 05/07/27 By pengu  1. 已有 Runcard 報工資料者，製程順序不可刪除。(亦不可插入，會造成 WIP 數量錯亂)
#                                                   2. Stage(應改為作業編號) 在輸入時，應可查詢作業編號。
#                                                   3.單頭調整單號顯示欄位不足。
#                                                   4.選擇調整項目後，要先在其它欄位點一下，才能輸入要調整之製程順序。
#                                                   5.Flow(應改為製程編號)，輸入 Flow 時，亦應可查詢相同料件之製程編號
# Modify.........: No.MOD-640440 06/04/12 By pengu 當調整項目為3:插入FLOW時，應與工單在檢查製程編號的合理性時的方式相同.
# Modify.........: No.FUN-650111 06/05/19 By Sarah 增加執行成功後列印功能
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-680121 06/08/29 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/16 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-710026 07/01/15 By hongmei 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-770004 07/07/03 By mike 幫助按鈕灰色 
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.MOD-860081 08/06/06 By jamie ON IDLE問題
# Modify.........: No.TQC-940121 09/05/08 By mike 畫面不存在smydesc欄位  
# Modify.........: No.FUN-950012 09/06/10 By jan 改寫INSERT INTO sgm_file的寫法
# Modify.........: No.MOD-970118 09/07/14 By mike RUNCARD資料排除結案的情況   
# Modify.........: No.FUN-980008 09/08/14 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960001 09/10/12 By jan 畫面新增sho52,sho53,sho54欄位
# Modify.........: No.FUN-9A0063 09/11/16 By jan 新增在制程最后增加新制程的功能
# Modify.........: No.FUN-9C0072 10/01/11 By vealxu 精簡程式碼
# Modify.........: No.FUN-A60092 10/07/05 By lilingyu 平行工藝
# Modify.........: No.FUN-A70137 10/07/29 By lilingyu 畫面增加"組成用量 底數"等欄位
# Modify.........: No.TQC-AC0374 10/12/29 By Mengxw 從ecu_file撈取資料時，制程料號改用s_schdat_sel_ima571()撈取 
# Modify.........: No.FUN-B10056 11/02/22 By jan 平行工藝功能完善
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-A70095 11/06/14 By lixh1 撈取報工單(shb_file)的所有處理作業,必須過濾是已確認的單據
# Modify.........: No.CHI-B80005 11/12/17 By ck2yuan 判斷當刪除g_zo07後抓到的下一個數減掉間隔數會大於g_zo07上一個數字的話則維持原數字
# Modify.........: No.FUN-BB0085 11/01/30 By xianghui 增加數量欄位小數取位
# Modify.........: No.CHI-C90006 12/11/13 By bart 失效判斷

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_sho   RECORD LIKE sho_file.*,
    g_sho_t RECORD LIKE sho_file.*,
    g_sho_o RECORD LIKE sho_file.*,
    b_sgm   RECORD LIKE sgm_file.*,
    g_sgm           DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
        sgm03           LIKE sgm_file.sgm03, 
        sgm04           LIKE sgm_file.sgm04 
                    END RECORD,
    g_t1            LIKE oay_file.oayslip,                     #No.FUN-550067         #No.FUN-680121 VARCHAR(05)
    g_err_flag      LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680121 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT        #No.FUN-680121 SMALLINT
    l_sl            LIKE type_file.num5,          #No.FUN-680121  SMALLINT#目前處理的SCREEN LINE
    l_ecb44,l_ecb45 LIKE ecb_file.ecb44,          #No.FUN-680121  SMALLINT #TQC-840066
    f_unit_out,r_unit_in LIKE sgm_file.sgm58      #No.FUN-680121  VARCHAR(04)
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680121 SMALLINT
DEFINE g_sql        STRING
DEFINE 
    g_z07,g_s07,g_f07  LIKE sho_file.sho07,
    g_z08,g_s08,g_f08  LIKE sho_file.sho08,
    g_s09,g_f09        LIKE sho_file.sho09,   
    g_f10              LIKE sho_file.sho09,     #FUN-A60092
    g_sgm54            LIKE type_file.chr1,         #No.FUN-680121 VARCHAR(1)
    g_item             LIKE shm_file.shm05,
    p_row,p_col        LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680121 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211 
   LET p_row=1 LET p_col=1
   OPEN WINDOW p311_w AT p_row,p_col WITH FORM "asf/42f/asfp311" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
#FUN-A60092 --begin--
   IF g_sma.sma541 = 'Y' THEN 
      CALL cl_set_comp_visible("sho012,g_f10",TRUE)
   ELSE 
      CALL cl_set_comp_visible("sho012,g_f10",FALSE)
   END IF  
#FUN-A60092 --end--
 
   INITIALIZE g_sho.* TO NULL
   CALL p311()
   CLOSE WINDOW p311_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
 
END MAIN
 
FUNCTION p311()
    DEFINE   li_result   LIKE type_file.num5          #No.FUN-550067         #No.FUN-680121 SMALLINT
    DEFINE   l_flag      LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢幕欄位內容
    CALL g_sgm.clear()
    INITIALIZE g_sho.* LIKE sho_file.*
    CALL cl_opmsg('a')
 
    WHILE TRUE
        CLEAR FORM
        CALL g_sgm.clear()
        INITIALIZE g_sho.* TO NULL        
        LET g_z07 = ''
        LET g_z08 = ''
        LET g_s07 = ''
        LET g_s08 = ''
        LET g_s09 = ''
        LET g_f07 = ''
        LET g_f08 = ''
        LET g_f09 = ''
        LET g_f10 = ' ' #FUN-A60092
        LET g_sho.sho02 = g_today
        LET g_sho.sho10 = g_user
        LET g_sho.sho12 = 'N'    
        LET g_sho.sho52 = 'N'     #CHI-960001
        LET g_sho.sho53 = 'N'      #CHI-960001
        LET g_sho.sho54 = 'N'      #CHI-960001
        LET g_sho.shouser = g_user
        LET g_sho.shodate = g_today
 
        LET g_sho.shoplant = g_plant #FUN-980008 add
        LET g_sho.sholegal = g_legal #FUN-980008 add

#FUN-A60092 --begin--
        IF g_sma.sma541 = 'N' THEN
            LET g_sho.sho012 = ' ' 
        END IF 
#FUN-A60092 --end-- 
        CALL p311_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            CALL g_sgm.clear()
            EXIT WHILE
        END IF
        IF cl_null(g_sho.sho01) THEN CONTINUE WHILE END IF
        IF NOT cl_sure(19,0) THEN CONTINUE WHILE END IF
        BEGIN WORK
        LET g_success='Y' 
        CALL p311_process() 
        CALL s_showmsg()           #NO.FUN-710026
        CALL s_auto_assign_no("asf",g_sho.sho01,g_today,"","sho_file","sho01","","","") 
        RETURNING li_result,g_sho.sho01                                                    
        IF (NOT li_result) THEN  
              LET g_success='N' END IF	#有問題
           DISPLAY BY NAME g_sho.sho01
        CASE g_sho.sho06 
             WHEN '1' LET g_sho.sho07 = g_z07 
                      LET g_sho.sho08 = g_z08
                      LET g_sho.sho09 = ''    
             WHEN '2' LET g_sho.sho07 = g_s07 
                      LET g_sho.sho08 = g_s08
                      LET g_sho.sho09 = g_s09 
             WHEN '3' LET g_sho.sho07 = g_f07 
                      LET g_sho.sho08 = g_f08
                      LET g_sho.sho09 = g_f09                   
                      LET g_sho.sho112= g_f10   #FUN-A60092
             WHEN '4' LET g_sho.sho09 = g_f09   #FUN-9A0063
                      LET g_sho.sho112= g_f10   #FUN-A60092
                 
        END CASE
        LET g_sho.shooriu = g_user      #No.FUN-980030 10/01/04
        LET g_sho.shoorig = g_grup      #No.FUN-980030 10/01/04

#FUN-A60092 --begin--
        IF cl_null(g_sho.sho012) THEN 
           LET g_sho.sho012 = ' ' 
        END IF 
#FUN-A60092 --end--        
        
        INSERT INTO sho_file VALUES(g_sho.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL s_errmsg('sho01',g_sho.sho01,g_sho.sho01,SQLCA.sqlcode,1)         #NO.FUN-710026 
           LET g_success='N'
        END IF
         IF g_success='Y' THEN
            COMMIT WORK
            CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
            CALL p311_out()   #FUN-650111 add
         ELSE
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
         END IF
         IF l_flag THEN
            CONTINUE WHILE
         ELSE
            EXIT WHILE
         END IF
    END WHILE
END FUNCTION
 
FUNCTION p311_i(p_cmd)
   DEFINE   li_result   LIKE type_file.num5          #No.FUN-550067         #No.FUN-680121 SMALLINT
   DEFINE   p_cmd     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
            l_flag    LIKE type_file.chr1,                 #判斷必要欄位是否有輸入        #No.FUN-680121 VARCHAR(1)
            l_gen02   LIKE gen_file.gen02,
            l_ima571  LIKE ima_file.ima571,  #No.MOD-640440 add
            l_cnt     LIKE type_file.num5                #-No.MOD-530549 add        #No.FUN-680121 SMALLINT
   DEFINE   l_shm012  LIKE shm_file.shm012    #FUN-A60092
   DEFINE   l_sfb05   LIKE sfb_file.sfb05     #FUN-A60092
   DEFINE   l_sfb06   LIKE sfb_file.sfb06     #FUN-A60092
   DEFINE   l_flag1   LIKE type_file.num5     #TQC-AC0374

   DISPLAY BY NAME 
          g_sho.sho01,g_sho.sho02,g_sho.sho03,g_sho.sho06,
          g_z07,g_z08,g_s07,g_s08,g_s09,g_f07,g_f08,g_f09,
          g_f10,         #FUN-A60092 add
          g_sho.sho12,g_sho.sho10,g_sho.sho11,
          g_sho.sho52,g_sho.sho53,g_sho.sho54  #CHI-960001
          CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
 
   INPUT BY NAME
          g_sho.sho01,g_sho.sho02,g_sho.sho03,
          g_sho.sho012,   #FUN-A60092 add 
          g_sho.sho06,
          g_z07,g_z08,g_s07,g_s08,g_s09,g_f07,g_f08,g_f09,
          g_f10,   #FUN-A60092 add
          g_sho.sho12,
          g_sho.sho52,g_sho.sho53,g_sho.sho54, #CHI-960001
          g_sho.sho62,g_sho.sho63,g_sho.sho64,g_sho.sho16,g_sho.sho17,   #FUN-A70137
          g_sho.sho10,g_sho.sho11
       WITHOUT DEFAULTS
       
       ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()   #FUN-550037(smin)

        ON ACTION help                                 #No.TQC-770004
           LET g_action_choice="help"                  #No.TQC-770004
           CALL cl_show_help()                         #No.TQC-770004
           CONTINUE INPUT                              #No.TQC-770004
           
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL p311_set_no_entry(p_cmd)
         CALL p311_set_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("sho01")                                                                                          
 
      AFTER FIELD sho01 
         IF g_sho.sho01 != g_sho_t.sho01 OR g_sho_t.sho01 IS NULL THEN                                                                                             
            CALL s_check_no("asf",g_sho.sho01,g_sho_t.sho01,"G","sho_file","sho01","")  
            RETURNING li_result,g_sho.sho01                                                   
            DISPLAY BY NAME g_sho.sho01                                                                                             
            IF (NOT li_result) THEN                                                                                                 
               LET g_sho.sho01=g_sho_o.sho01                                                                                        
               NEXT FIELD sho01                                                                                                     
            END IF                                                                                                                  
         END IF
 
      AFTER FIELD sho03  
         IF cl_null(g_sho.sho03) THEN
            NEXT FIELD sho03
         END IF
         #-------- 須為存在之 RnuCard, 確認'Y'? 結案'N'?
         SELECT shm05 INTO g_item FROM shm_file 
          WHERE shm01=g_sho.sho03
            AND shm28 != 'Y' #MOD-970118    
         IF STATUS THEN    
            CALL cl_err3("sel","shm_file",g_sho.sho03,"","asf-588","","",0)    #MOD-970118    
            NEXT FIELD sho03
#FUN-A60092 --begin--            
#         ELSE
#            CALL p311_b_fill()
#            CALL p311_bp("G")
#FUN-A60092 --end--
         END IF
         CALL cl_qbe_init()
 
#FUN-A60092 --begin--
      AFTER FIELD sho012 
         IF g_sma.sma541 = 'Y' THEN 
            IF cl_null(g_sho.sho012) THEN 
               NEXT FIELD CURRENT 
            END IF 
         ELSE
      	   IF cl_null(g_sho.sho012) THEN 
              LET g_sho.sho012 = ' ' 
           END IF   
         END IF 
        #FUN-B10056--begin--mark----- 
        #SELECT shm012 INTO l_shm012 FROM shm_file
        # WHERE shm01 = g_sho.sho03
        #SELECT sfb06 INTO l_sfb06 FROM sfb_file    #TQC-AC0374  delete sfb05,l_sfb05
        # WHERE sfb01 = l_shm012
        #CALL s_schdat_sel_ima571(l_shm012) RETURNING l_flag1,l_sfb05  #TQC-AC0374    
        #SELECT COUNT(*) INTO l_cnt FROM ecu_file
        # WHERE ecu01 = l_sfb05   #TQC-AC0374
        #   AND ecu02 = l_sfb06
        #   AND ecu012= g_sho.sho012          
        #FUN-B10056--end--mark-----
         LET l_cnt = 0    #FUN-B10056
         SELECT COUNT(*) INTO l_cnt FROM sgm_file  #FUN-B10056
          WHERE sgm01=g_sho.sho03                  #FUN-B10056
            AND sgm012=g_sho.sho012                #FUN-B10056
         IF l_cnt = 0 THEN 
            CALL cl_err('','abm-214',0)
            NEXT FIELD CURRENT 
         ELSE
            CALL p311_b_fill()
            CALL p311_bp("G")               
         END IF           
#FUN-A60092 --end--

      BEFORE FIELD sho06
         CALL p311_set_no_entry(p_cmd)
 
      ON CHANGE sho06
         IF NOT cl_null(g_sho.sho06) THEN
            CALL p311_set_no_entry(p_cmd)
            IF g_sho.sho06 NOT MATCHES '[1234]' THEN  #FUN-9A0063
               NEXT FIELD sho06
            END IF
            CALL p311_set_entry(p_cmd)
         END IF

#FUN-A70137 --begin--
      AFTER FIELD sho62
        IF NOT cl_null(g_sho.sho62) THEN 
            IF g_sho.sho62 <= 0 THEN 
               CALL cl_err('','afa-037',0)
               NEXT FIELD CURRENT 
            END IF 
         ELSE 
            NEXT FIELD CURRENT 
         END IF 	
               
      AFTER FIELD sho63
         IF NOT cl_null(g_sho.sho63) THEN 
            IF g_sho.sho63 <= 0 THEN 
               CALL cl_err('','afa-037',0)
               NEXT FIELD CURRENT 
            END IF 
         ELSE 
            NEXT FIELD CURRENT 
         END IF 	 
               
      AFTER FIELD sho64
         IF NOT cl_null(g_sho.sho64) THEN 
            IF g_sho.sho64 <= 0 THEN 
               CALL cl_err('','afa-037',0)
               NEXT FIELD CURRENT 
            END IF 
         ELSE 
            NEXT FIELD CURRENT 
         END IF 	
               
      AFTER FIELD sho16
         IF cl_null(g_sho.sho16) THEN 
            NEXT FIELD CURRENT 
         ELSE
         	  IF g_sho.sho16 < 0 THEN 
         	     CALL cl_err('','aim-223',0)
         	     NEXT FIELD CURRENT 
         	  END IF               
         END IF 	
               
      AFTER FIELD sho17
         IF cl_null(g_sho.sho17) THEN 
            NEXT FIELD CURRENT 
         ELSE
         	  IF g_sho.sho17 < 0 THEN 
         	     CALL cl_err('','aim-223',0)
         	     NEXT FIELD CURRENT 
         	  END IF    
         END IF 	       
#FUN-A70137 --end--
 
      AFTER FIELD g_z07
         IF NOT cl_null(g_z07) THEN
            SELECT sgm54 INTO g_sgm54 FROM sgm_file 
             WHERE sgm01 = g_sho.sho03 AND sgm03=g_z07
               AND sgm012= g_sho.sho012   #FUN-A60092 add
            IF STATUS THEN 
               CALL cl_err3("sel","sgm_file",g_sho.sho03,g_z07,"asf-805","","",0)    #No.FUN-660128
               NEXT FIELD g_z07 
            END IF
#FUN-A60092 --begin--
#            #---- 前一站轉出單位(f_unit_out)
#            SELECT sgm58 INTO f_unit_out FROM sgm_file
#             WHERE sgm01=g_sho.sho03
#               AND sgm03=(SELECT MAX(sgm03) FROM sgm_file
#             WHERE sgm01=g_sho.sho03 AND sgm03<g_z07)
#            IF STATUS THEN LET f_unit_out=' ' END IF
#          
#            #---- 後一站轉入單位(r_unit_in)
#            SELECT sgm57 INTO r_unit_in FROM sgm_file
#             WHERE sgm01=g_sho.sho03
#               AND sgm03=(SELECT MIN(sgm03) FROM sgm_file
#             WHERE sgm01=g_sho.sho03 AND sgm03>g_z07)
#            IF STATUS THEN
#               LET r_unit_in=' '
#            END IF
#          
#            IF NOT cl_null(f_unit_out) AND NOT cl_null(r_unit_in) THEN
#               IF f_unit_out!=r_unit_in THEN
#                  CALL cl_err(g_sho.sho03,'asf-925',0)
#                  NEXT FIELD g_z07 
#               END IF
#            END IF
#            #-------------
#FUN-A60092 --end--
            CALL sgm_chk(g_sgm54,g_z07) RETURNING g_err_flag,g_z08
            IF g_err_flag=1 THEN
               CALL cl_err(g_sho.sho03,'asf-912',0)
               NEXT FIELD g_z07 
            ELSE
               DISPLAY g_z08 TO FORMONLY.g_z08 
            END IF
            IF NOT cl_null(g_z08) THEN
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM shb_file WHERE shb16 = g_sho.sho03
                   AND shb06 = g_z07 AND shb081 = g_z08
                   AND shb012= g_sho.sho012   #FUN-A60092 add
                   AND shbconf = 'Y'    #FUN-A70095 
               IF l_cnt > 0 THEN
                  CALL cl_err(g_z08,'asf-924',1)
                  NEXT FIELD g_z07
               END IF
            END IF 
         END IF 
          
      BEFORE FIELD g_s07
         IF g_sho.sho06 MATCHES '[13]' THEN
            NEXT FIELD g_f07
         END IF
 
      AFTER FIELD g_s07
         IF NOT cl_null(g_s07) THEN
            SELECT sgm54 INTO g_sgm54 FROM sgm_file 
             WHERE sgm01=g_sho.sho03 AND sgm03=g_s07
               AND sgm012=g_sho.sho012   #FUN-A60092 add
            IF STATUS THEN 
               CALL cl_err3("sel","sgm_file",g_sho.sho03,g_s07,"asf-805","","",0)    #No.FUN-660128
               NEXT FIELD g_s07 
            END IF
            CALL sgm_chk(g_sgm54,g_s07) RETURNING g_err_flag,g_s08
            IF g_err_flag=1 THEN
               CALL cl_err(g_sho.sho03,'asf-912',0)
               NEXT FIELD g_s07 
            ELSE
               DISPLAY g_s08 TO FORMONLY.g_s08 
            END IF
#FUN-A60092 --begin--
#            #-------------
#            #---- 轉出單位(f_unit_out)
#            SELECT sgm58 INTO f_unit_out FROM sgm_file
#             WHERE sgm01=g_sho.sho03
#               AND sgm03=(SELECT MAX(sgm03) FROM sgm_file
#             WHERE sgm01=g_sho.sho03 AND sgm03<g_s07)
#            IF STATUS THEN
#               LET f_unit_out=' '
#            END IF
#          
#            #---- 轉入單位(r_unit_in)
#            SELECT sgm57 INTO r_unit_in FROM sgm_file
#             WHERE sgm01=g_sho.sho03 AND sgm03=g_s07
#            IF STATUS THEN
#               LET r_unit_in=' '
#            END IF
#            IF f_unit_out=' ' THEN
#               LET f_unit_out=r_unit_in
#            END IF
#            IF r_unit_in=' ' THEN
#               LET r_unit_in=f_unit_out
#            END IF
#FUN-A60092 --end--
         END IF 
 
      AFTER FIELD g_s09
         IF NOT cl_null(g_s09) THEN
            SELECT COUNT(*) INTO g_cnt FROM ecd_file 
             WHERE ecd01=g_s09
            IF g_cnt=0 THEN 
               CALL cl_err(g_s09,'aec-015',0)
               NEXT FIELD g_s09 
            END IF
         END IF 
 
      BEFORE FIELD g_f07
         IF g_sho.sho06 MATCHES '[12]' THEN
            NEXT FIELD sho12
         END IF
 
      AFTER FIELD g_f07
         IF NOT cl_null(g_f07) THEN
            SELECT sgm54 INTO g_sgm54 FROM sgm_file 
             WHERE sgm01=g_sho.sho03 AND sgm03=g_f07
               AND sgm012=g_sho.sho012  #FUN-A60092 add
            IF STATUS THEN 
               CALL cl_err3("sel","sgm_file",g_sho.sho03,g_f07,"asf-805","","",0)    #No.FUN-660128
               NEXT FIELD g_f07 
            END IF
            SELECT COUNT(*) INTO g_cnt FROM shb_file
             WHERE shb16=g_sho.sho03 AND shb06=g_f07
               AND shb012=g_sho.sho012  #FUN-A60092 add
               AND shbconf = 'Y'   #FUN-A70095
            IF g_cnt>0 THEN 
               CALL cl_err(g_sho.sho03,'asf-924',0)
               NEXT FIELD g_f07 
            END IF
            CALL sgm_chk(g_sgm54,g_f07) RETURNING g_err_flag,g_f08
            IF g_err_flag=1 THEN
               CALL cl_err(g_sho.sho03,'asf-912',0)
               NEXT FIELD g_f07 
            ELSE
               DISPLAY g_f08 TO FORMONLY.g_f08 
            END IF
            IF NOT cl_null(g_f08) THEN
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM shb_file WHERE shb16 = g_sho.sho03
                   AND shb06 = g_f07 AND shb081 = g_f08
                   AND shb012= g_sho.sho012  #FUN-A60029 add
                   AND shbconf = 'Y'   #FUN-A70095  
               IF l_cnt > 0 THEN
                  CALL cl_err(g_f08,'asf-961',1)
                  NEXT FIELD g_f07
               END IF
            END IF
         END IF 
 
#FUN-A60092 --begin--
      AFTER FIELD g_f10
        IF g_f10 IS NOT NULL THEN 
           LET g_cnt = 0
           SELECT ima571 INTO l_ima571 FROM ima_file
            WHERE ima01=g_item 
            IF l_ima571 IS NULL THEN LET l_ima571=' ' END IF 
            SELECT COUNT(*) INTO g_cnt FROM ecu_file
             WHERE ecu01 = l_ima571 
               AND ecu02 = g_f09
               AND ecu012= g_f10 
               AND ecuacti = 'Y'  #CHI-C90006
            IF g_cnt=0 THEN 
               #FUN-B10056--begin--add---
               SELECT COUNT(*) INTO g_cnt FROM ecu_file
                WHERE ecu01=g_item AND ecu02=g_f09 AND ecu012=g_f10
                  AND ecuacti = 'Y'  #CHI-C90006
               IF g_cnt = 0 THEN
               #FUN-B10056--end--add-----
                  CALL cl_err('','abm-214',0)
                  NEXT FIELD g_f10
               END IF  #FUN-B10056
            END IF
        END IF 
#FUN-A60092 --end--
 
      AFTER FIELD g_f09
         IF NOT cl_null(g_f09) THEN  
            LET g_cnt = 0
            SELECT ima571 INTO l_ima571 FROM ima_file
                      WHERE ima01=g_item
             
            IF l_ima571 IS NULL THEN LET l_ima571=' ' END IF 
            SELECT COUNT(*) INTO g_cnt FROM ecu_file
             WHERE ecu01=l_ima571 AND ecu02=g_f09
               AND ecuacti = 'Y'  #CHI-C90006
             # AND ecu012= g_sho.sho012   #FUN-A60092 add
            IF g_cnt=0 THEN 
               SELECT COUNT(*) INTO g_cnt 
                 FROM ecu_file WHERE ecu01=g_item AND ecu02=g_f09
                  AND ecuacti = 'Y'  #CHI-C90006
                # AND ecu012= g_sho.sho012   #FUN-A60092 add                
               IF g_cnt=0 THEN 
                  CALL cl_err(g_f09,'mfg4030',0)
                  NEXT FIELD g_f09 
               ELSE 
                  LET l_ima571 = g_item
               END IF
            END IF
#FUN-A60092 --begin--
#            SELECT ecb44 INTO l_ecb44 FROM ecb_file 
#             WHERE ecb01=l_ima571 AND ecb02=g_f09     #No.MOD-640440 add  
#               AND ecb03=(SELECT MIN(ecb03) FROM ecb_file 
#             WHERE ecb01=l_ima571 AND ecb02=g_f09)    #No.MOD-640440 add
#            IF STATUS THEN 
#               LET l_ecb44=' ' 
#            END IF
#           
#            #---- 前一站轉出單位(f_unit_out)
#            SELECT sgm58 INTO f_unit_out FROM sgm_file
#             WHERE sgm01=g_sho.sho03 
#               AND sgm03=(SELECT MAX(sgm03) FROM sgm_file
#             WHERE sgm01=g_sho.sho03 AND sgm03<g_f07)
#            IF STATUS THEN
#               LET f_unit_out=' '
#            END IF
#            IF NOT cl_null(f_unit_out) THEN
#               IF f_unit_out!=l_ecb44 THEN
#                  CALL cl_err(g_sho.sho03,'asf-925',0)
#                  NEXT FIELD g_f09 
#               END IF
#            END IF
#           
#            SELECT ecb45 INTO l_ecb45 FROM ecb_file 
#             WHERE ecb01=l_ima571 AND ecb02=g_f09     #No.MOD-640440 add  
#               AND ecb03=(SELECT MAX(ecb03) FROM ecb_file 
#             WHERE ecb01=l_ima571 AND ecb02=g_f09)    #No.MOD-640440 add
#            IF STATUS THEN
#               LET l_ecb45=' '
#            END IF
#           
#            #---- 後一站轉入單位(r_unit_in)
#            SELECT sgm57 INTO r_unit_in FROM sgm_file
#               WHERE sgm01=g_sho.sho03 AND sgm03=g_f07
#            IF STATUS THEN
#               LET r_unit_in=' '
#            END IF
#            IF NOT cl_null(r_unit_in) THEN
#               IF r_unit_in!=l_ecb45 THEN
#                  CALL cl_err(g_sho.sho03,'asf-925',0)
#                  NEXT FIELD g_f09 
#               END IF
#            END IF
#FUN-A60092 --end--
         END IF 
 
      AFTER FIELD sho12 
         IF NOT cl_null(g_sho.sho12) THEN
            IF g_sho.sho12 NOT MATCHES '[YN]' THEN
               NEXT FIELD sho12
            END IF
         END IF
 
      AFTER FIELD sho10 
         SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_sho.sho10
         IF STATUS THEN 
            CALL cl_err3("sel","gen_file",g_sho.sho10,"","mfg1312","","",0)    #No.FUN-660128
            NEXT FIELD sho10
         ELSE
            DISPLAY l_gen02 TO FORMONLY.gen02 
         END IF 
             
      AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
         IF INT_FLAG THEN
            EXIT INPUT 
         END IF
         CASE g_sho.sho06 
             WHEN '1' 
                  IF cl_null(g_z07) THEN NEXT FIELD g_z07 END IF
                  IF cl_null(g_z08) THEN NEXT FIELD g_z08 END IF
             WHEN '2' 
                  IF cl_null(g_s07) THEN NEXT FIELD g_s07 END IF
                  IF cl_null(g_s08) THEN NEXT FIELD g_s08 END IF
                  IF cl_null(g_s09) THEN NEXT FIELD g_s09 END IF
             WHEN '3' 
                  IF cl_null(g_f07) THEN NEXT FIELD g_f07 END IF
                  IF cl_null(g_f08) THEN NEXT FIELD g_f08 END IF
                  IF cl_null(g_f09) THEN NEXT FIELD g_f09 END IF    #MOD-550136
                  IF cl_null(g_f10) THEN LET g_f10 = ' ' END IF     #FUN-A60092
             WHEN '4'                                               #FUN-9A0063
                  IF cl_null(g_f09) THEN NEXT FIELD g_f09 END IF    #FUN-9A0063
                  IF cl_null(g_f10) THEN LET g_f10 = ' ' END IF     #FUN-A60092                  
         END CASE
 
      ON ACTION CONTROLP
           CASE
              WHEN INFIELD(sho01) #查詢單据
                 LET g_t1 = s_get_doc_no(g_sho.sho01)     #No.FUN-550067
                 CALL q_smy(FALSE,FALSE,g_t1,'ASF','G') RETURNING g_t1  #TQC-670008
                 LET g_sho.sho01 = g_t1                 #No.FUN-550067 
                 DISPLAY BY NAME g_sho.sho01 
                 NEXT FIELD sho01
 
              WHEN INFIELD(sho03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_shm2" #MOD-970118     
                 LET g_qryparam.default1 = g_sho.sho03
                 CALL cl_create_qry() RETURNING g_sho.sho03
                 DISPLAY BY NAME g_sho.sho03 
                 NEXT FIELD sho03

#FUN-A60092 --begin--
              WHEN INFIELD(sho012)
                 CALL cl_init_qry_var()
                #LET g_qryparam.form = "q_sho012_2"  #FUN-B10056
                 LET g_qryparam.form = "q_sgm012"    #FUN-B10056
                 LET g_qryparam.default1 = g_sho.sho012
                 LET g_qryparam.arg1     = g_sho.sho03
                 CALL cl_create_qry() RETURNING g_sho.sho012
                 DISPLAY BY NAME g_sho.sho012 
                 NEXT FIELD sho012
#FUN-A60092 --end--

              WHEN INFIELD(g_s09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ecd3"
                 LET g_qryparam.default1 = g_s09
                 CALL cl_create_qry() RETURNING g_s09
                 DISPLAY BY NAME g_s09
                 NEXT FIELD g_s09
               WHEN INFIELD(g_f09)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_ecu02"
                  LET g_qryparam.default1 = g_f09
                  LET g_qryparam.arg1 = g_item
                  CALL cl_create_qry() RETURNING g_f09
                  DISPLAY BY NAME g_f09
                  NEXT FIELD g_f09
 
              WHEN INFIELD(sho10)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.default1 = g_sho.sho10
                 CALL cl_create_qry() RETURNING g_sho.sho10
                 DISPLAY BY NAME g_sho.sho10 
                 NEXT FIELD sho10
            END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION exit                            #加離開功能
         LET INT_FLAG = 1
         EXIT INPUT
   
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
END FUNCTION
 
FUNCTION p311_set_entry(p_cmd) 
DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
   IF NOT g_before_input_done OR INFIELD(sho06) THEN 
      CASE g_sho.sho06 
        WHEN '1' CALL cl_set_comp_entry("g_z07",TRUE) 
        WHEN '2' CALL cl_set_comp_entry("g_s07,g_s09,sho12,sho62,sho63,sho64,sho16,sho17",TRUE) 
                                        #FUN-A70137 add sho62,sho63,sho64,sho16,sho17
#FUN-A70137 --begin--
                 LET g_sho.sho62 = 1
                 LET g_sho.sho63 = 1
                 LET g_sho.sho64 = 1
                 LET g_sho.sho16 = 0
                 LET g_sho.sho17 = 0
                 DISPLAY BY NAME g_sho.sho62,g_sho.sho63,g_sho.sho64,g_sho.sho16,g_sho.sho17
#FUN-A70137 --end--                                        
        WHEN '3' CALL cl_set_comp_entry("g_f07,g_f09,sho12,g_f10",TRUE)  #FUN-A60092 add g_f10
        WHEN '4' CALL cl_set_comp_entry("g_f09,sho12,g_f10",TRUE)  #FUN-9A0063  #FUN-A60092 add g_f10
      END CASE
   END IF 
 
END FUNCTION
 
FUNCTION p311_set_no_entry(p_cmd) 
DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)
 
   IF NOT g_before_input_done OR INFIELD(sho06) THEN 
      CALL cl_set_comp_entry("g_z07,g_s07,g_f07,g_s09,g_f09,sho12,g_f10,sho62,sho63,sho64,sho16,sho17",FALSE) 
                            #FUN-A60092 add g_f10
                            #FUN-A70137 add sho62,sho63,sho64,sho16,sho17    
#FUN-A70137 --begin--
                 LET g_sho.sho62 = NULL  LET g_sho.sho63 = NULL
                 LET g_sho.sho64 = NULL  LET g_sho.sho16 = NULL 
                 LET g_sho.sho17 = NULL 
                 DISPLAY BY NAME g_sho.sho62,g_sho.sho63,g_sho.sho64,g_sho.sho16,g_sho.sho17
#FUN-A70137 --end--                                                        
   END IF   
END FUNCTION
 
FUNCTION sgm_chk(p_chkin,p_sgm03)       
DEFINE p_chkin   LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
       p_sgm03   LIKE type_file.num5,          #No.FUN-680121 SMALLINT
       l_wos     LIKE sho_file.sho08
 
    LET g_err_flag=0
    IF p_chkin='Y' THEN
       SELECT sgm04 INTO l_wos FROM sgm_file 
        WHERE sgm01=g_sho.sho03 AND sgm03=p_sgm03
          AND sgm012=g_sho.sho012   #FUN-A60092 add
         #AND sgm291=0 AND (sgm291-sgm59*(sgm311+sgm312+sgm313+sgm314+  #FUN-A60092
          AND sgm291=0 AND (sgm291-(sgm311+sgm312+sgm313+sgm314+        #FUN-A60092
                                            sgm316+sgm317))=0
    ELSE
       SELECT sgm04 INTO l_wos FROM sgm_file 
          WHERE sgm01=g_sho.sho03 AND sgm03=p_sgm03
            AND sgm012=g_sho.sho012   #FUN-A60092 add
            AND sgm291=0 AND (sgm301+sgm302+sgm303+sgm304-
                               (sgm311+sgm312+sgm313+sgm314+           #FUN-A60092
                                     sgm316+sgm317))=0
    END IF 
    IF STATUS THEN LET g_err_flag=1 LET l_wos='' END IF
    RETURN g_err_flag,l_wos
END FUNCTION
 
FUNCTION p311_process() 
    DEFINE l_sgm   RECORD LIKE sgm_file.*
    DEFINE l_ecd   RECORD LIKE ecd_file.*
    DEFINE l_ecb   RECORD LIKE ecb_file.*
    DEFINE l_sgm03 LIKE sgm_file.sgm03 
    DEFINE n       LIKE type_file.num5          #No.FUN-680121 SMALLINT
    DEFINE l_sgm1  RECORD LIKE sgm_file.*       #FUN-950012
    DEFINE l_shm01  LIKE shm_file.shm01          #FUN-9A0063
    DEFINE l_shm012 LIKE shm_file.shm012         #FUN-9A0063
    DEFINE l_shm05  LIKE shm_file.shm05          #FUN-9A0063
    DEFINE l_shm15  LIKE shm_file.shm01          #FUN-9A0063
    DEFINE l_sfb05  LIKE sfb_file.sfb05    #FUN-A60092 
    DEFINE l_sfb06  LIKE sfb_file.sfb06    #FUN-A60092
    DEFINE l_shm08  LIKE shm_file.shm08    #FUN-A70137 
    DEFINE l_sfb05a LIKE sfb_file.sfb05    #TQC-AC0374
    DEFINE l_flag   LIKE type_file.num5    #TQC-AC0374
    DEFINE l_sgm03p LIKE sgm_file.sgm03    #CHI-B80005
    DEFINE l_sgm03b LIKE sgm_file.sgm03    #CHI-B80005

    CALL s_showmsg_init()    #NO.FUN-710026
    CASE g_sho.sho06
         WHEN '1'    
              DELETE FROM sgm_file WHERE sgm01=g_sho.sho03 AND sgm03=g_z07
                                     AND sgm012= g_sho.sho012  #FUN-A60092 
              IF STATUS OR SQLCA.sqlerrd[3]=0 THEN LET g_success='N' END IF
              #------- 後面各站製程序往前挪 1*sma849

              #------- CHI-B80005 str add-----------------
              SELECT MAX(sgm03) INTO l_sgm03p  FROM sgm_file WHERE sgm01=g_sho.sho03 AND sgm03<g_z07 AND sgm012= g_sho.sho012
              SELECT MIN(sgm03) INTO l_sgm03b  FROM sgm_file WHERE sgm01=g_sho.sho03 AND sgm03>g_z07 AND sgm012= g_sho.sho012
              IF cl_null(l_sgm03p) OR cl_null(l_sgm03b) OR  (l_sgm03b-g_sma.sma849 < l_sgm03p) THEN
                 #刪除第一站,最後一站,或是下一個數減掉間隔數會大於g_zo7上一個數字 則不updat
                EXIT CASE
              END IF
              #------- CHI-B80005 end add-----------------

              DECLARE sgm_cur1 CURSOR FOR 
                 SELECT * FROM sgm_file 
                    WHERE sgm01=g_sho.sho03 AND sgm03>g_z07 
                      AND sgm012= g_sho.sho012  #FUN-A60092                       
              FOREACH sgm_cur1 INTO l_sgm.*
                  UPDATE sgm_file SET sgm03=sgm03-g_sma.sma849
                      WHERE sgm01=g_sho.sho03 AND sgm03=l_sgm.sgm03
                        AND sgm012= g_sho.sho012  #FUN-A60092                       
                  IF STATUS OR SQLCA.sqlerrd[3]=0 THEN 
                     LET g_success='N' 
                     CONTINUE FOREACH                    #NO.FUN-710026                    
                  ELSE
                     UPDATE sgn_file SET sgn03=sgn03-g_sma.sma849
                        WHERE sgn01=g_sho.sho03 AND sgn03=l_sgm.sgm03
                          AND sgn012= g_sho.sho012  #FUN-A60092                         
                  END IF
              END FOREACH
              
         WHEN '2'    
              #------- 後面各站製程序往後挪 1*sma849
              DECLARE sgm_cur2 CURSOR FOR 
                 SELECT * FROM sgm_file 
                    WHERE sgm01=g_sho.sho03 
                      AND sgm012= g_sho.sho012  #FUN-A60092                            
                      AND sgm03>=g_s07 ORDER BY sgm03 DESC
            
              FOREACH sgm_cur2 INTO l_sgm.*
                  UPDATE sgm_file SET sgm03=sgm03+g_sma.sma849
                      WHERE sgm01=g_sho.sho03 AND sgm03=l_sgm.sgm03
                        AND sgm012= g_sho.sho012  #FUN-A60092                       
                  IF STATUS OR SQLCA.sqlerrd[3]=0 THEN 
                     LET g_success='N' 
                     CONTINUE FOREACH                    #NO.FUN-710026 
                  ELSE
                     UPDATE sgn_file SET sgn03=sgn03+g_sma.sma849
                        WHERE sgn01=g_sho.sho03 AND sgn03=l_sgm.sgm03
                          AND sgn012= g_sho.sho012  #FUN-A60092                         
                  END IF
              END FOREACH
              
              SELECT * INTO l_ecd.* FROM ecd_file WHERE ecd01=g_s09
              INITIALIZE l_sgm1.* TO NULL
              LET l_sgm1.sgm01 = l_sgm.sgm01
              LET l_sgm1.sgm02 = l_sgm.sgm02
              LET l_sgm1.sgm03_par = l_sgm.sgm03_par
              LET l_sgm1.sgm03 = g_s07
              LET l_sgm1.sgm04 = g_s09
              LET l_sgm1.sgm05 = l_ecd.ecd06
              LET l_sgm1.sgm06 = l_ecd.ecd07
              LET l_sgm1.sgm07 = 0
              LET l_sgm1.sgm08 = 0
              LET l_sgm1.sgm09 = 0
              LET l_sgm1.sgm10 = 0
              LET l_sgm1.sgm11= l_sgm.sgm11
#             LET l_sgm1.sgm12 = l_ecd.ecd12   #FUN-A70137 mark
              LET l_sgm1.sgm121 = 'N'
              LET l_sgm1.sgm13 = l_ecd.ecd16
              LET l_sgm1.sgm14 = l_ecd.ecd17
              LET l_sgm1.sgm15 = l_ecd.ecd18
              LET l_sgm1.sgm16 = l_ecd.ecd19
              LET l_sgm1.sgm17 = l_ecd.ecd20
              LET l_sgm1.sgm18 = 0
              LET l_sgm1.sgm19 = 0
              LET l_sgm1.sgm20 = 0
              LET l_sgm1.sgm21 = 0
              LET l_sgm1.sgm22 = 0
              LET l_sgm1.sgm23 = 0
              LET l_sgm1.sgm24 = 0
              LET l_sgm1.sgm25 = 0
              LET l_sgm1.sgm26 = 0
              LET l_sgm1.sgm27 = 0
              LET l_sgm1.sgm28 = 0
              LET l_sgm1.sgm291 = 0
              LET l_sgm1.sgm292 = 0
              LET l_sgm1.sgm301 = 0
              LET l_sgm1.sgm302 = 0
              LET l_sgm1.sgm303 = 0
              LET l_sgm1.sgm304 = 0
              LET l_sgm1.sgm311= 0
              LET l_sgm1.sgm312 = 0
              LET l_sgm1.sgm313 = 0
              LET l_sgm1.sgm314 = 0
              LET l_sgm1.sgm315 = 0
              LET l_sgm1.sgm316 = 0
              LET l_sgm1.sgm317 = 0
              LET l_sgm1.sgm321 = 0
              LET l_sgm1.sgm322 = 0
#             LET l_sgm1.sgm34 = 0    #FUN-A70137 mark
              LET l_sgm1.sgm35 = 0
              LET l_sgm1.sgm36 = 0
              LET l_sgm1.sgm37 = l_ecd.ecd24
              LET l_sgm1.sgm38 = l_ecd.ecd25
              LET l_sgm1.sgm39 = l_ecd.ecd26
              LET l_sgm1.sgm40 = l_ecd.ecd13
              LET l_sgm1.sgm41 = l_ecd.ecd14
              LET l_sgm1.sgm42 = l_ecd.ecd09
              LET l_sgm1.sgm43 = l_ecd.ecd11
              LET l_sgm1.sgm45 = l_ecd.ecd02
              LET l_sgm1.sgm49 = 0
              LET l_sgm1.sgm50 = g_today
              LET l_sgm1.sgm51 = l_sgm.sgm51
              LET l_sgm1.sgm52 = g_sho.sho52
              LET l_sgm1.sgm53 = g_sho.sho53
              LET l_sgm1.sgm54 = g_sho.sho54
              LET l_sgm1.sgm55 = ''
              LET l_sgm1.sgm56 = ''
             #LET l_sgm1.sgm57 = f_unit_out  #FUN-A60092
              LET l_sgm1.sgm58 = r_unit_in
             #LET l_sgm1.sgm59 = 1           #FUN-A60092
              LET l_sgm1.sgmacti= 'Y'
              LET l_sgm1.sgmuser= g_user
              LET l_sgm1.sgmgrup= g_grup
              LET l_sgm1.sgmmodu= ''
 			       LET l_sgm1.sgmdate= g_today
              LET l_sgm1.sgmplant= g_plant #FUN-980008 add
              LET l_sgm1.sgmlegal= g_legal #FUN-980008 add
 
              LET l_sgm1.sgmoriu = g_user      #No.FUN-980030 10/01/04
              LET l_sgm1.sgmorig = g_grup      #No.FUN-980030 10/01/04
              LET l_sgm1.sgm012  = l_sgm.sgm012   #FUN-A60092 add
#FUN-A60092 --begin--
             #FUN-B10056--begin--modify-------
             #SELECT shm012 INTO l_shm012 FROM shm_file
             # WHERE shm01 = g_sho.sho03
             # SELECT sfb06 INTO l_sfb06 FROM sfb_file  #TQC-AC0374  delete sfb05,l_sfb05 
             #  WHERE sfb01 = l_shm012
             #CALL s_schdat_sel_ima571(l_shm012) RETURNING l_flag,l_sfb05a  #TQC-AC0374   
             #DECLARE ecu012_curs_1 CURSOR FOR 
             #SELECT ecu012 FROM ecu_file
             # WHERE ecu01 =  l_sfb05a  #TQC-AC0374                 
             #   AND ecu02 =  l_sfb06
             #   AND ecu015=  l_sgm.sgm012
              DECLARE sgm012_cs CURSOR FOR
               SELECT sgm012 FROM sgm_file
                WHERE sgm01=g_sho.sho03 AND sgm015=l_sgm.sgm012
              FOREACH sgm012_cs INTO l_sgm1.sgm011
            #FUN-B10056--end--modify-----------
                 EXIT FOREACH 
              END FOREACH    
#FUN-A60092 --end--      

#FUN-A70137 --begin--
              LET l_sgm1.sgm12 = g_sho.sho16
              LET l_sgm1.sgm34 = g_sho.sho17
              LET l_sgm1.sgm62 = g_sho.sho62
              LET l_sgm1.sgm63 = g_sho.sho63
              LET l_sgm1.sgm64 = g_sho.sho64

#工单编号，制程段号，制程序，生产数量，固定损耗量，变动损耗率，损耗批量,组成用量/底数,p_QPA
             SELECT shm08 INTO l_shm08 FROM shm_file
              WHERE shm01 = g_sho.sho03

             CALL cralc_eck_rate(l_sgm1.sgm02,l_sgm1.sgm012,l_sgm1.sgm03,l_shm08,
                                 l_sgm1.sgm12,l_sgm1.sgm34,l_sgm1.sgm64,
                                 l_sgm1.sgm62/l_sgm1.sgm63,1)              
               RETURNING l_sgm1.sgm65              
#FUN-A70137 --end--
              LET l_sgm1.sgm65 = s_digqty(l_sgm1.sgm65,l_sgm1.sgm58)   #FUN-BB0085
      
              IF cl_null(l_sgm1.sgm66) THEN LET l_sgm1.sgm66='N' END IF #TQC-AC0374
               #tianry add 170214
              SELECT ta_ecd05 INTO l_sgm1.ta_sgm06 FROM ecd_file WHERE ecd01=l_sgm1.sgm04
              IF cl_null(l_sgm1.ta_sgm06) THEN
                 LET l_sgm1.ta_sgm06='N' 
              END IF

              #tianry add 170214

              INSERT INTO sgm_file VALUES(l_sgm1.*)
              IF STATUS THEN 
	      CALL s_errmsg('ecd01',g_s09,'ins sgm:',STATUS,1)          #NO.FUN-710026
                 LET g_success='N' 
              END IF 
         WHEN '3'    
              #TQC-AC0374--begin--add---
              SELECT shm012 INTO l_shm012 FROM shm_file
               WHERE shm01 = g_sho.sho03
              CALL s_schdat_sel_ima571(l_shm012) RETURNING l_flag,l_sfb05a 
              #TQC-AC0374--end--add-----   
              SELECT COUNT(*) INTO n FROM ecb_file 
                 WHERE ecb01=l_sfb05a AND ecb02=g_f09 #TQC-AC0374
                   AND ecb012=g_f10     #FUN-A60092 add
              IF n=0 THEN RETURN END IF
              #------- 後面各站製程序往後挪 n*sma849
              DECLARE sgm_cur3 CURSOR FOR 
               SELECT * FROM sgm_file 
                WHERE sgm01=g_sho.sho03 
                  AND sgm012= g_sho.sho012  #FUN-A60092                     
                  AND sgm03>=g_f07 ORDER BY sgm03 DESC
              FOREACH sgm_cur3 INTO l_sgm.*
                  UPDATE sgm_file SET sgm03=sgm03+n*g_sma.sma849
                      WHERE sgm01=g_sho.sho03 AND sgm03=l_sgm.sgm03
                        AND sgm012= g_sho.sho012  #FUN-A60092                       
                  IF STATUS OR SQLCA.sqlerrd[3]=0 THEN 
                     LET g_success='N' 
                     CONTINUE FOREACH                    #NO.FUN-710026   
                  ELSE
                     UPDATE sgn_file SET sgn03=sgn03+n*g_sma.sma849
                      WHERE sgn01=g_sho.sho03 AND sgn03=l_sgm.sgm03
                        AND sgn012= g_sho.sho012  #FUN-A60092                         
                  END IF
              END FOREACH
              #----------------- insert into sgm 插入的各製程序
              LET l_sgm03=l_sgm.sgm03 
              DECLARE ecb_cur CURSOR FOR 
                  SELECT * FROM ecb_file 
                     WHERE ecb01=l_sfb05a #TQC-AC0374
                       AND ecb012= g_f10  #FUN-A60092                      
                       AND ecb02=g_f09 ORDER BY ecb03
              FOREACH ecb_cur INTO l_ecb.*
                 IF g_success='N' THEN                                                                                                          
                    LET g_totsuccess='N'                                                                                                       
                    LET g_success="Y"                                                                                                          
                 END IF                    
                CALL p311_ins_sgm(l_ecb.*,l_sgm.sgm01,l_sgm.sgm02,l_sgm.sgm03_par, #FUN-9A0063
                                  l_sgm.sgm51,l_sgm03)                             #FUN-9A0063
                LET l_sgm03=l_sgm03+g_sma.sma849                                   #FUN-9A0063
              END FOREACH
              IF g_totsuccess="N" THEN                                                                                                         
                 LET g_success="N"                                                                                                             
              END IF 
         WHEN '4'
              SELECT shm01,shm012,shm05,shm15
                INTO l_shm01,l_shm012,l_shm05,l_shm15
                FROM shm_file
               WHERE shm01=g_sho.sho03
              SELECT max(sgm03) INTO l_sgm03 FROM sgm_file 
               WHERE sgm01=g_sho.sho03
                 AND sgm012= g_sho.sho012  #FUN-A60092                             
              IF cl_null(l_sgm03) OR l_sgm03 = 0 THEN RETURN END IF
              LET l_sgm03 = l_sgm03+g_sma.sma849
              CALL s_schdat_sel_ima571(l_shm012) RETURNING l_flag,l_sfb05a  #TQC-AC0374
              DECLARE ecb_cur1 CURSOR FOR 
                  SELECT * FROM ecb_file 
                     WHERE ecb01=l_sfb05a #TQC-AC0374 
                       AND ecb012= g_f10  #FUN-A60092                      
                       AND ecb02=g_f09 ORDER BY ecb03
              FOREACH ecb_cur1 INTO l_ecb.*
                 IF g_success='N' THEN                                                                                                          
                    LET g_totsuccess='N'                                                                                                       
                    LET g_success="Y"                                                                                                          
                 END IF       
                 CALL p311_ins_sgm(l_ecb.*,l_shm01,l_shm012,l_shm05,l_shm15,l_sgm03)             
                 LET l_sgm03=l_sgm03+g_sma.sma849
              END FOREACH
              IF g_totsuccess="N" THEN                                                                                                         
                 LET g_success="N"                                                                                                             
              END IF 
    END CASE
END FUNCTION

FUNCTION p311_ins_sgm(l_ecb,p_sgm01,p_sgm02,p_sgm03_par,p_sgm51,p_sgm03)
DEFINE l_ecb        RECORD LIKE ecb_file.*
DEFINE l_sgm1       RECORD LIKE sgm_file.*
DEFINE p_sgm03      LIKE sgm_file.sgm03 
DEFINE p_sgm01      LIKE sgm_file.sgm01
DEFINE p_sgm02      LIKE sgm_file.sgm02
DEFINE p_sgm03_par  LIKE sgm_file.sgm03_par
DEFINE p_sgm51      LIKE sgm_file.sgm51
DEFINE l_shm08      LIKE shm_file.shm08    #FUN-A60092
DEFINE l_flag       LIKE type_file.num5    #TQC-AC0374
DEFINE l_sfb05      LIKE sfb_file.sfb05    #TQC-AC0374
DEFINE l_shm06      LIKE shm_file.shm06    #TQC-AC0374

             INITIALIZE l_sgm1.* TO NULL                                                                                   
             LET l_sgm1.sgm01 = p_sgm01
             LET l_sgm1.sgm02 = p_sgm02
             LET l_sgm1.sgm03_par = p_sgm03_par
             LET l_sgm1.sgm03 = p_sgm03
              LET l_sgm1.sgm04 = l_ecb.ecb06
              LET l_sgm1.sgm05 = l_ecb.ecb07
              LET l_sgm1.sgm06 = l_ecb.ecb08
              LET l_sgm1.sgm07 = 0
              LET l_sgm1.sgm08 = 0
              LET l_sgm1.sgm09 = 0
              LET l_sgm1.sgm10 = 0
              LET l_sgm1.sgm11 = g_f09
              LET l_sgm1.sgm12 = l_ecb.ecb14
              LET l_sgm1.sgm121 = l_ecb.ecb09
              LET l_sgm1.sgm13 = l_ecb.ecb18
              LET l_sgm1.sgm14 = l_ecb.ecb19
              LET l_sgm1.sgm15 = l_ecb.ecb20
              LET l_sgm1.sgm16 = l_ecb.ecb21
              LET l_sgm1.sgm17 = l_ecb.ecb22
              LET l_sgm1.sgm18 = l_ecb.ecb10
              LET l_sgm1.sgm19 = 0
              LET l_sgm1.sgm20 = 0
              LET l_sgm1.sgm21 = 0
              LET l_sgm1.sgm22 = 0
              LET l_sgm1.sgm23 = 0
              LET l_sgm1.sgm24 = 0
              LET l_sgm1.sgm25 = 0
              LET l_sgm1.sgm26 = 0
              LET l_sgm1.sgm27 = 0
              LET l_sgm1.sgm28 = 0
              LET l_sgm1.sgm291 = 0
              LET l_sgm1.sgm292 = 0
              LET l_sgm1.sgm301 = 0
              LET l_sgm1.sgm302 = 0
              LET l_sgm1.sgm303 = 0
              LET l_sgm1.sgm304 = 0
              LET l_sgm1.sgm311= 0
              LET l_sgm1.sgm312 = 0
              LET l_sgm1.sgm313 = 0
              LET l_sgm1.sgm314 = 0
              LET l_sgm1.sgm315 = 0
              LET l_sgm1.sgm316 = 0
              LET l_sgm1.sgm317 = 0
              LET l_sgm1.sgm321 = 0
              LET l_sgm1.sgm322 = 0
              LET l_sgm1.sgm34 = 0
              LET l_sgm1.sgm35 = 0
              LET l_sgm1.sgm36 = 0
              LET l_sgm1.sgm37 = l_ecb.ecb26
              LET l_sgm1.sgm38 = l_ecb.ecb27
              LET l_sgm1.sgm39 = l_ecb.ecb28
              LET l_sgm1.sgm40 = l_ecb.ecb15
              LET l_sgm1.sgm41 = l_ecb.ecb16
              LET l_sgm1.sgm42 = l_ecb.ecb11
              LET l_sgm1.sgm43 = l_ecb.ecb13
              LET l_sgm1.sgm45 = l_ecb.ecb17
              LET l_sgm1.sgm49 = l_ecb.ecb38
              LET l_sgm1.sgm50 = g_today
              LET l_sgm1.sgm51 = p_sgm51
              LET l_sgm1.sgm52 = g_sho.sho52
              LET l_sgm1.sgm53 = g_sho.sho53
              LET l_sgm1.sgm54 = g_sho.sho54
              LET l_sgm1.sgm55 = l_ecb.ecb42
              LET l_sgm1.sgm56 = l_ecb.ecb43
             #LET l_sgm1.sgm57 = l_ecb.ecb44  #FUN-A60092
              LET l_sgm1.sgm58 = l_ecb.ecb45
             #LET l_sgm1.sgm59 = l_ecb.ecb46  #FUN-A60092
              LET l_sgm1.sgmacti= 'Y'
              LET l_sgm1.sgmuser= g_user
              LET l_sgm1.sgmgrup= g_grup
              LET l_sgm1.sgmmodu= ''
              LET l_sgm1.sgmdate= g_today
              LET l_sgm1.sgmplant= g_plant #FUN-980008 add
              LET l_sgm1.sgmlegal= g_legal #FUN-980008 add
              LET l_sgm1.sgmoriu = g_user      #No.FUN-980030 10/01/04
              LET l_sgm1.sgmorig = g_grup      #No.FUN-980030 10/01/04               
              LET l_sgm1.sgm012 = g_sho.sho012  #FUN-A60092 add
#FUN-A60092 --begin--
              LET l_sgm1.sgm62 = l_ecb.ecb46  
              LET l_sgm1.sgm63 = l_ecb.ecb51
              LET l_sgm1.sgm12 = l_ecb.ecb52
              LET l_sgm1.sgm34 = l_ecb.ecb14
              LET l_sgm1.sgm64 = l_ecb.ecb53
              IF cl_null(l_sgm1.sgm66) THEN LET l_sgm1.sgm66='N' END IF #TQC-AC0374
              
     #工单编号，制程段号，制程序，生产数量，固定损耗量，变动损耗率，损耗批量,组成用量/底数,p_QPA
             SELECT shm08,shm06 INTO l_shm08,l_shm06 FROM shm_file #TQC-AC0374
              WHERE shm01 = g_sho.sho03

             CALL cralc_eck_rate(l_sgm1.sgm02,l_sgm1.sgm012,l_sgm1.sgm03,l_shm08,
                                 l_sgm1.sgm12,l_sgm1.sgm34,l_sgm1.sgm64,
                                 l_sgm1.sgm62/l_sgm1.sgm63,1)              
              RETURNING l_sgm1.sgm65
             LET l_sgm1.sgm65 = s_digqty(l_sgm1.sgm65,l_sgm1.sgm58)   #FUN-BB0085
              CALL s_schdat_sel_ima571(l_sgm1.sgm02) RETURNING l_flag,l_sfb05  #TQC-AC0374  
             #FUN-B10056--begin--modify----
             #DECLARE ecu012_curs CURSOR FOR 
             #SELECT ecu012 FROM ecu_file
             # WHERE ecu01 =  l_sfb05     #TQC-AC0374 
             #   AND ecu02 =  l_shm06     #TQC-AC0374
             #   AND ecu015=  g_sho.sho012
              DECLARE sgm012_cs1 CURSOR FOR
               SELECT sgm012 FROM sgm_file
                WHERE sgm01=g_sho.sho03
                  AND sgm015=g_sho.sho012
              FOREACH sgm012_cs1 INTO l_sgm1.sgm011
             #FUN-B10056--end--modify-----
                 EXIT FOREACH 
              END FOREACH   
#FUN-A60092 --end--                   
               INSERT INTO sgm_file VALUES(l_sgm1.*)
                  IF STATUS THEN 
                      LET g_showmsg=g_item,"/",g_f09                                                       #NO.FUN-710026         
                      CALL s_errmsg('ecb01,ecb02',g_showmsg,'ins sgm:',STATUS,1)                           #NO.FUN-710026
                     LET g_success='N' 
                  END IF
END FUNCTION
 
FUNCTION p311_b_fill()
 
    DECLARE sgm_cur CURSOR FOR
       SELECT sgm03,sgm04 FROM sgm_file 
        WHERE sgm01 = g_sho.sho03
          AND sgm012= g_sho.sho012   #FUN-A60092 add
        ORDER BY sgm03

    CALL g_sgm.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH sgm_cur INTO g_sgm[g_cnt].*
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_sgm.deleteElement(g_cnt)

    LET g_rec_b=g_cnt - 1
   
    DISPLAY g_rec_b TO FORMONLY.cnt
 
END FUNCTION
 
FUNCTION p311_bp(p_ud)
 
    DEFINE p_ud            LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
    IF p_ud <> "G" THEN
        RETURN
    END IF
 
    LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_sgm TO s_sgm.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         EXIT DISPLAY
 
           IF g_rec_b != 0 THEN
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
           IF g_rec_b != 0 THEN
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
           IF g_rec_b != 0 THEN
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
           IF g_rec_b != 0 THEN
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
           IF g_rec_b != 0 THEN
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
      AFTER DISPLAY
         CONTINUE DISPLAY
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DISPLAY
         
         ON ACTION about         
            CALL cl_about()      
         
         ON ACTION controlg      
            CALL cl_cmdask()     
         
         ON ACTION help          
            CALL cl_show_help()  
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#start FUN-650111 add 增加列印功能   
FUNCTION p311_out()
   DEFINE sr       RECORD
                    sho01       LIKE sho_file.sho01, 
                    sho02       LIKE sho_file.sho02, 
                    sho03       LIKE sho_file.sho03, 
                    sho06       LIKE sho_file.sho06, 
                    sho07       LIKE sho_file.sho07, 
                    sho08       LIKE sho_file.sho08, 
                    sho09       LIKE sho_file.sho09, 
                    sho10       LIKE sho_file.sho10, 
                    sho11       LIKE sho_file.sho11, 
                    sho12       LIKE sho_file.sho12,
                    sho52       LIKE sho_file.sho52, #CHI-960001
                    sho53       LIKE sho_file.sho53, #CHI-960001
                    sho54       LIKE sho_file.sho54, #CHI-960001
                    g_z07       LIKE sho_file.sho07, 
                    g_z08       LIKE sho_file.sho08, 
                    g_s07       LIKE sho_file.sho07, 
                    g_s08       LIKE sho_file.sho08, 
                    g_s09       LIKE sho_file.sho09, 
                    g_f07       LIKE sho_file.sho07, 
                    g_f08       LIKE sho_file.sho08, 
                    g_f09       LIKE sho_file.sho09,  
                    sho012      LIKE sho_file.sho012  #FUN-A60092 ADD
                   END RECORD,
          l_name   LIKE type_file.chr20         #No.FUN-680121 VARCHAR(20) # External(Disk) file name
 
    CALL cl_outnam(g_prog) RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    # 組合出 SQL 指令
    LET g_sql = "SELECT sho01,sho02,sho03,sho06,sho07,sho08,sho09,",
                "       sho10,sho11,sho12,sho52,sho53,sho54,'','','','','','','','',sho012", #CHI-960001 add sho52,53,54
                                                   #FUN-A60092 add sho012
                "  FROM sho_file ",
                " WHERE sho01 = '",g_sho.sho01,"'"
    PREPARE p311_pre FROM g_sql                     # RUNTIME 編譯
    DECLARE p311_cur CURSOR FOR p311_pre
 
    START REPORT p311_rep TO l_name
 
    FOREACH p311_cur INTO sr.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)  
          LET g_success = 'N'
          EXIT FOREACH
       END IF
 
       CASE sr.sho06 
            WHEN '1' LET sr.g_z07 = sr.sho07 
                     LET sr.g_z08 = sr.sho08
            WHEN '2' LET sr.g_s07 = sr.sho07 
                     LET sr.g_s08 = sr.sho08
                     LET sr.g_s09 = sr.sho09 
            WHEN '3' LET sr.g_f07 = sr.sho07 
                     LET sr.g_f08 = sr.sho08
                     LET sr.g_f09 = sr.sho09 
            WHEN '4' LET sr.g_f09 = sr.sho09  #FUN-9A0063
       END CASE
 
 #FUN-A60092--start---
      IF g_sma.sma541 = 'Y' THEN
          LET g_zaa[33].zaa06 = 'N'  
          LET g_zaa[34].zaa06 = 'N'
       ELSE
          LET g_zaa[33].zaa06 = 'Y'
          LET g_zaa[34].zaa06 = 'Y'
       END IF 
 #FUN-A60092 --end---  
  
       OUTPUT TO REPORT p311_rep(sr.*)
    END FOREACH
 
    FINISH REPORT p311_rep
 
    CLOSE p311_cur
    ERROR ""
    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 
END FUNCTION
 
REPORT p311_rep(sr) DEFINE sr       RECORD
                    sho01       LIKE sho_file.sho01, 
                    sho02       LIKE sho_file.sho02, 
                    sho03       LIKE sho_file.sho03, 
                    sho06       LIKE sho_file.sho06, 
                    sho07       LIKE sho_file.sho07, 
                    sho08       LIKE sho_file.sho08, 
                    sho09       LIKE sho_file.sho09, 
                    sho10       LIKE sho_file.sho10, 
                    sho11       LIKE sho_file.sho11, 
                    sho12       LIKE sho_file.sho12,
                    sho52       LIKE sho_file.sho52, #CHI-960001
                    sho53       LIKE sho_file.sho53, #CHI-960001
                    sho54       LIKE sho_file.sho54, #CHI-960001
                    g_z07       LIKE sho_file.sho07, 
                    g_z08       LIKE sho_file.sho08, 
                    g_s07       LIKE sho_file.sho07, 
                    g_s08       LIKE sho_file.sho08, 
                    g_s09       LIKE sho_file.sho09, 
                    g_f07       LIKE sho_file.sho07, 
                    g_f08       LIKE sho_file.sho08, 
                    g_f09       LIKE sho_file.sho09,  
                    sho012      LIKE sho_file.sho012   #FUN-A60092                     
                   END RECORD,
          sr2      RECORD
                    sgm03       LIKE sgm_file.sgm03,
                    sgm04       LIKE sgm_file.sgm04
                   END RECORD,
          l_gae04               LIKE gae_file.gae04,
          l_msg                 STRING,
          l_gen02               LIKE gen_file.gen02,
          l_trailer_sw          LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
    OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.sho01
 
    FORMAT
       PAGE HEADER
          PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
          PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
          LET g_pageno = g_pageno + 1
          LET pageno_total = PAGENO USING '<<<',"/pageno" 
          PRINT g_head CLIPPED,pageno_total     
          PRINT g_dash
          PRINT g_x[11] CLIPPED,sr.sho01 CLIPPED,5 SPACES,      #調整單號
                g_x[12] CLIPPED,sr.sho02                        #調整日期
          PRINT g_x[13] CLIPPED,sr.sho03 CLIPPED,5 SPACE,        #Run Card
                g_x[33] CLIPPED,sr.sho012 CLIPPED              #FUN-A60092
          PRINT ' '
          CASE sr.sho06
              WHEN "1"
                 SELECT gae04 INTO l_gae04 FROM gae_file
                  WHERE gae01='asfp311' AND gae02='sho06_1' AND gae03=g_lang
              WHEN "2"
                 SELECT gae04 INTO l_gae04 FROM gae_file
                  WHERE gae01='asfp311' AND gae02='sho06_2' AND gae03=g_lang
              WHEN "3"
                 SELECT gae04 INTO l_gae04 FROM gae_file
                  WHERE gae01='asfp311' AND gae02='sho06_3' AND gae03=g_lang
          END CASE
          LET l_msg = sr.sho06 CLIPPED,':',l_gae04 CLIPPED
          PRINT g_x[14] CLIPPED,l_msg                           #調整項目
          PRINT g_x[15] CLIPPED,COLUMN 26,sr.g_z07 CLIPPED,
                                COLUMN 33,sr.g_z08       
          PRINT g_x[16] CLIPPED,COLUMN 26,sr.g_s07 CLIPPED,
                                COLUMN 33,sr.g_s08 CLIPPED,      
                                COLUMN 40,g_x[17] CLIPPED,sr.g_s09
          PRINT g_x[18] CLIPPED,COLUMN 26,sr.g_f07 CLIPPED,
                                COLUMN 33,sr.g_f08 CLIPPED,      
                                COLUMN 40,g_x[19] CLIPPED,sr.g_f09
          PRINT                 COLUMN 40,g_x[34] CLIPPED,g_f10   #FUN-A60092                                
          PRINT ' '
          PRINT g_x[20] CLIPPED,sr.sho12                        
          PRINT g_x[23] CLIPPED,sr.sho52   #CHI-960001                        
          PRINT g_x[24] CLIPPED,sr.sho53   #CHI-960001                        
          PRINT g_x[25] CLIPPED,sr.sho54   #CHI-960001                        
          SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.sho10
          IF STATUS THEN LET l_gen02 = ' ' END IF
          PRINT g_x[21] CLIPPED,sr.sho10 CLIPPED,1 SPACES,l_gen02
          PRINT g_x[22] CLIPPED,sr.sho11 CLIPPED
          PRINT ' '
          PRINT g_x[31],g_x[32]
          PRINT g_dash1 
          LET l_trailer_sw = 'y'
 
       ON EVERY ROW
          LET g_sql = "SELECT sgm03,sgm04 FROM sgm_file",
                      " WHERE sgm01 ='",sr.sho03,"'",
                      "   AND sgm012='",sr.sho012,"'"   #FUN-A60092 add
          PREPARE p311_pre2 FROM g_sql
          DECLARE p311_cur2 CURSOR FOR p311_pre2
          FOREACH p311_cur2 INTO sr2.*
             IF STATUS THEN EXIT FOREACH END IF
 
             #順序     作業編號 
             #-------- -------- 
             #sgm01xxx sgm04xxx
             PRINT COLUMN g_c[31],sr2.sgm03,
                   COLUMN g_c[32],sr2.sgm04
          END FOREACH
 
        ON LAST ROW
           LET l_trailer_sw = 'n'
            
        PAGE TRAILER
           PRINT g_dash
           IF l_trailer_sw = 'y' THEN
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
           ELSE
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
           END IF
END REPORT
#No.FUN-9C0072 精簡程式碼
