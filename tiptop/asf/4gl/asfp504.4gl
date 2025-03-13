# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: asfp504.4gl
# Descriptions...: 消耗性料件發料單產生作業
# Date & Author..: 97/06/28 BY Roger
# Modify.........: 97/10/06 By Sophia產生時更新入庫單asft620上的耗材單號
# Modify.........: 99/10/05 BY Kammy 增加 倉庫、儲位 兩欄位
# Modify.........: MOD-470507(9793) 04/07/23 Carol insert add sfpuser/sfpdate
# Modify.........: No.MOD-4A0063 04/10/06 By Mandy q_ime 的參數傳的有誤
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.MOD-4B0169 04/11/22 By Mandy check imd_file 的程式段...應加上 imdacti 的判斷
# Modify.........: No.FUN-550067 05/05/30 By Trisy 單據編號加大
# Modify.........: No.FUN-580119 05/08/23 By Carrier 產生領料單的多單位內容
# Modify.........: NO.MOD-580262 05/10/13 By Rosayu asfi301的單身若有多筆料件是"消耗性料件"的話.asfp504會使這些消耗性料件的發料數量成倍增加
# Modify.........: No.FUN-570151 06/03/13 By yiting 批次作業背景執行功能
# Modify.........: No.MOD-640013 06/04/25 By pengu 生成領料單時,未考慮取替代料的情況
# Modify.........: No.FUN-660106 06/06/16 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-670103 06/07/31 By kim GP3.5 利潤中心
# Modify.........: No.TQC-680032 06/08/14 By pengu 入庫時分多張入庫單入庫，且入庫數量一樣時，執行asfp504工單領料單
                                   #               產生作業時所產生的發料量會出現異常。
# Modify.........: No.TQC-680112 06/08/24 By pengu 生成領料單時,取替代料的情況會出現異常
# Modify.........: No.TQC-680048 06/08/29 By rainy p504() CALL s_auto_assign_no()少傳參數
# Modify.........: No.FUN-680121 06/09/13 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-710026 07/01/15 By hongmei 錯誤訊息匯總顯示修改
# Modify.........: No.MOD-770102 07/07/23 By pengu insert sfp時sfpgrup未給值
# Modify.........: No.MOD-840136 08/04/17 By chenl 1.資料拋轉時，對批號賦空格，以保証資料拋轉后，在審核時，不會因為批號字段值為NULL而報錯。 
# Modify.........:                                 2.回傳領料單單號，賦值給對應的完工入庫單。
# Modify.........: No.MOD-8B0086 08/11/07 By chenyu 沒有取替代時，讓sfs27=sfa27
# Modify.........: No.FUN-980008 09/08/14 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-930062 09/08/20 By lutingting產生委外采購得領料單時,回寫委外采購單頭得領料單號欄位
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No.FUN-A20037 10/03/15 By lilingyu 替代碼sfa26加上"7,8,Z"的條件
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No.FUN-A60027 10/06/07 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.MOD-A70001 10/07/05 By liuxqa 修改l_sql長度
# Modify.........: No.FUN-AA0062 10/11/05 By yinhy 倉庫權限使用控管修改
# Modify.........: No:MOD-AB0098 10/11/11 By sabrina 同一張完工入庫單的工單並未全部寫入領料單裡
# Modify.........: No.TQC-AC0293 10/12/20 By vealxu sfp01的開窗/檢查要排除smy73='Y'的單據 
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-AB0001 11/04/25 By Lilan 因asfi510新增EasyFlow整合功能影響INSERT INTO sfp_file
# Modify.........: No:MOD-B50215 11/05/25 By sabrina q_mid_1只能開當前門店的倉庫
# Modify.........: No:FUN-B70074 11/07/25 By lixh1 增加行業別TABLE(sfsi_file)的處理
# Modify.........: No:FUN-BB0084 11/12/13 By lixh1 增加數量欄位小數取位
# Modify.........: No:MOD-C30029 12/03/06 By Elise 在update領料單號回工單完工入庫單頭或委外採購入庫的條件，改為用工單單號取得相關的入庫單作update
# Modify.........: No:MOD-C30282 12/03/10 By xujing 修改asfp504，在START REPORT前加上LET g_page_line = 1,並且修改START REPORT 的報表輸出名稱
# Modify.........: No:MOD-C40024 12/04/09 By Elise 修正無窮迴圈及回寫錯誤問題
# Modify.........: No:FUN-C70014 12/07/16 By suncx 新增sfs014
# Modify.........: No:TQC-C80059 12/08/08 By chenjing 修改asf-826報錯信息
# Modify.........: No.FUN-CB0087 12/12/20 By fengrui 倉庫單據理由碼改善
# Modify.........: No:MOD-C80267 13/02/26 By Elise (1)應考慮入庫日期符合所下的日期區間
#                                                  (2)若領料留有殘值,應再判斷該領料單號是否存在領料單
#                                                  (3)修正工單領料單產生作業(asfp504)產生領料單時數量會異常的問題
# Modify.........: No:CHI-D10039 13/03/22 By bart QBE加上入庫單號
# Modify.........: No:FUN-D40103 13/05/08 By lixh1 增加儲位有效性檢查
# Modify.........: No:FUN-D60013 13/06/05 By lixiang 欄位增加開窗
# Modify.........: No:TQC-D70067 13/07/22 By lujh 1.無法ctrl+g 2.幫助按鈕灰色，無法開啟help

IMPORT os   #No.FUN-9C0009 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
           tm RECORD
               wc     LIKE type_file.chr1000, #No.FUN-680121 VARCHAR(300),
               bdate  LIKE type_file.dat,     #No.FUN-680121 DATE,
               edate  LIKE type_file.dat,     #No.FUN-680121 DATE,
               iss_no LIKE oea_file.oea01,       #No.FUN-680121 VARCHAR(16),      #No.FUN-550067
               iss_date  LIKE type_file.dat,     #No.FUN-680121 DATE,
               iss_store LIKE sfs_file.sfs07,
               iss_locat LIKE sfs_file.sfs08
          END RECORD,
         g_t1   LIKE oay_file.oayslip,                     #No.FUN-550067  #No.FUN-680121 VARCHAR(05)
         g_back LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1),
         g_sfp	RECORD LIKE sfp_file.*,
         g_sfq	RECORD LIKE sfq_file.*,
         g_sfs	RECORD LIKE sfs_file.*
DEFINE   g_sfsi RECORD LIKE sfsi_file.*   #FUN-B70074
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-680121 INTEGER
DEFINE   g_count         LIKE type_file.num10   #No.FUN-680121 INTEGER    #計算insert 單身筆數,若沒單身單頭不產生(genero)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680121 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000  #No.FUN-680121 VARCHAR(72)
DEFINE   l_flag          LIKE type_file.chr1,                  #No.FUN-570151  #No.FUN-680121 VARCHAR(1)
         g_change_lang   LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(01),               #是否有做語言切換 No.FUN-570151
         ls_date        STRING                  #->No.FUN-570151
DEFINE   g_ima25         LIKE ima_file.ima25,
         g_ima55         LIKE ima_file.ima55,
         g_ima906        LIKE ima_file.ima906,
         g_ima907        LIKE ima_file.ima907,
         g_factor        LIKE sfv_file.sfv31
#MOD-C80267---add---S
DEFINE   g_sfu    DYNAMIC ARRAY OF RECORD
           sfu01   LIKE sfu_file.sfu01,
           sfu09   LIKE sfu_file.sfu09
         END RECORD
DEFINE   g_rvu    DYNAMIC ARRAY OF RECORD
           rvu01   LIKE rvu_file.rvu01,
           rvu16   LIKE rvu_file.rvu16
         END RECORD
#MOD-C80267---add---E
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
#->No.FUN-570151 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.wc        = ARG_VAL(1)
   LET ls_date      = ARG_VAL(2)
   LET tm.bdate     = cl_batch_bg_date_convert(ls_date)   #
   LET ls_date      = ARG_VAL(3)
   LET tm.edate     = cl_batch_bg_date_convert(ls_date)   #
   LET tm.iss_no    = ARG_VAL(4)
   LET ls_date      = ARG_VAL(5)
   LET tm.iss_date  = cl_batch_bg_date_convert(ls_date)   #
   LET tm.iss_store = ARG_VAL(6)
   LET tm.iss_locat = ARG_VAL(7)
   LET g_bgjob  = ARG_VAL(8)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
#->No.FUN-570151 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   WHILE TRUE
      LET g_success = 'Y'
      LET g_change_lang = FALSE
      IF g_bgjob = 'N' THEN
         CALL p504_tm()
         IF cl_sure(21,21) THEN
            BEGIN WORK
            CALL p504()
            CALL s_showmsg()           #NO.FUN-710026 
            IF g_count=0 THEN LET g_success='N' END IF #不產生單頭
            IF g_success = 'Y' THEN
               COMMIT WORK
               LET g_msg="asfi510 4 '",g_sfp.sfp01,"'"
               CALL cl_end2(1) RETURNING l_flag
               LET g_count = 0        #MOD-AB0098 add
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
               LET g_count = 0        #MOD-AB0098 add
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p504_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         BEGIN WORK
         CALL p504()
         CALL s_showmsg()           #NO.FUN-710026
         IF g_count=0 THEN LET g_success='N' END IF #不產生單頭
         IF g_success = 'Y' THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0090
END MAIN
 
FUNCTION p504_tm()
   DEFINE   li_result     LIKE type_file.num5    #No.FUN-550067  #No.FUN-680121 SMALLINT
   DEFINE   l_flag        LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
   DEFINE   lc_cmd        LIKE type_file.chr1000 #No.FUN-680121  VARCHAR(500)    #FUN-570151
   DEFINE   l_smy73       LIKE smy_file.smy73    #TQC-AC0293 
   DEFINE   l_sql         STRING                 #TQC-AC0293

   OPEN WINDOW p504_w WITH FORM "asf/42f/asfp504"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   CLEAR FORM
 
   WHILE TRUE
      INITIALIZE tm.* TO NULL			# Default condition
      DISPLAY BY NAME tm.bdate,tm.edate,tm.iss_date,tm.iss_no,tm.iss_store,
                      tm.iss_locat
      CONSTRUCT BY NAME tm.wc ON sfb01,sfb05,sfb82,sfu01  #CHI-D10039
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---

     #FUN-D60013--add---begin----
           ON ACTION CONTROLP
              CASE
                 WHEN INFIELD (sfb01)   
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_sfb01"
                    LET g_qryparam.state = "c"          
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO FORMONLY.sfb01
                    NEXT FIELD sfb01
                 WHEN INFIELD (sfb05)             
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_sfb15"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO FORMONLY.sfb05
                    NEXT FIELD sfb05            
                 WHEN INFIELD (sfb82)             
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_sfb16"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO FORMONLY.sfb82
                    NEXT FIELD sfb82
                 WHEN INFIELD (sfu01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_sfu"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO FORMONLY.sfu01
                    NEXT FIELD sfu01
                OTHERWISE EXIT CASE
            END CASE
     #FUN-D60013--add---end----
 
      ON ACTION locale
#NO.FUN-570151 mark
#          CALL cl_dynamic_locale()
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#NO.FUN-570151 mark
          LET g_change_lang = TRUE          #FUN-570151
          EXIT CONSTRUCT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #TQC-D70067--add--str--
         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION help
            CALL cl_show_help()
         #TQC-D70067--add--end--
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup') #FUN-980030
 
#NO.FUN-570151 start
#      IF INT_FLAG THEN
#         LET INT_FLAG = 0
#         EXIT PROGRAM
#      END IF
#->No.FUN-570151 ---start---
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG=0
      CLOSE WINDOW p504_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
#->No.FUN-570151 ---end---
 
      INPUT BY NAME tm.bdate,tm.edate,tm.iss_date,tm.iss_no,tm.iss_store,
                 #tm.iss_locat WITHOUT DEFAULTS
                 tm.iss_locat,g_bgjob WITHOUT DEFAULTS  #NO.FUN-570151
 
         AFTER FIELD bdate
            IF tm.bdate IS NULL THEN
               NEXT FIELD bdate
            END IF
 
         AFTER FIELD edate
            IF tm.edate IS NULL THEN
               NEXT FIELD edate
            END IF
            IF tm.iss_date IS NULL THEN
               LET tm.iss_date=tm.edate
               DISPLAY BY NAME tm.iss_date
            END IF
 
         AFTER FIELD iss_date
            IF tm.iss_date IS NULL THEN
               NEXT FIELD iss_date
            END IF
 
         AFTER FIELD iss_no
            IF tm.iss_no IS NULL THEN
               NEXT FIELD iss_no
            END IF
      #No.FUN-550067 --start--
            LET g_t1=tm.iss_no[1,g_doc_len]
            CALL s_check_no("asf",g_t1,"","3","","","")
            RETURNING li_result,tm.iss_no
            LET tm.iss_no = s_get_doc_no(tm.iss_no)
            DISPLAY BY NAME tm.iss_no
            IF (NOT li_result) THEN
               NEXT FIELD iss_no
            END IF
        
           #TQC-AC0293 --------------add start--------------
           SELECT smy73 INTO l_smy73 FROM smy_file
            WHERE smyslip = g_t1
           IF l_smy73 = 'Y' THEN
              CALL cl_err('','asf-874',0)
              NEXT FIELD iss_no 
           END IF
           #TQC-AC0293 --------------add end--------------------
 
#           CALL s_mfgslip(g_t1,'asf','3')
#	    IF NOT cl_null(g_errno) THEN	 		#抱歉, 有問題
#               CALL cl_err(g_t1,g_errno,0)
#               NEXT FIELD iss_no
#	    END IF
            #No.BANN
	    #CALL s_smyauno(tm.iss_no,tm.iss_date) RETURNING g_i,tm.iss_no
            #IF g_i THEN NEXT FIELD iss_no END IF
         #No.FUN-550067 ---end---
	    DISPLAY BY NAME tm.iss_no
 
         AFTER FIELD iss_store
            IF NOT cl_null(tm.iss_store) THEN
               SELECT imd02 FROM imd_file WHERE imd01=tm.iss_store
                                             AND imdacti = 'Y' #MOD-4B0169
               IF STATUS THEN
#                 CALL cl_err('sel imd:',STATUS,0)   #No.FUN-660128
                  CALL cl_err3("sel","imd_file",tm.iss_store,"",STATUS,"","sel imd:",0)   #No.FUN-660128
                  NEXT FIELD iss_store
               END IF
               #No.FUN-AA0062 --Begin
               IF NOT s_chk_ware(tm.iss_store) THEN
                  NEXT FIELD iss_store
               END IF
               #No.FUN-AA0062 --End
            END IF
            #FUN-D40103 -----Begin-----
            IF NOT s_imechk(tm.iss_store,tm.iss_locat) THEN
               NEXT FIELD iss_locat 
            END IF
            #FUN-D40103 -----End-------
 
         AFTER FIELD iss_locat
            IF NOT cl_null(tm.iss_locat) AND cl_null(tm.iss_store) THEN
               NEXT FIELD iss_store
            END IF
            IF NOT cl_null(tm.iss_locat) THEN
               SELECT ime02 FROM ime_file
                WHERE ime01=tm.iss_store AND ime02=tm.iss_locat
               IF STATUS THEN
#                 CALL cl_err('sel ime:',STATUS,0)  #No.FUN-660128
                  CALL cl_err3("sel","ime_file",tm.iss_store,tm.iss_locat,STATUS,"","sel ime:",0)   #No.FUN-660128
                    NEXT FIELD iss_locat  
               END IF
            END IF
           #FUN-D40103 -----Begin-----
            IF NOT s_imechk(tm.iss_store,tm.iss_locat) THEN
               NEXT FIELD iss_locat 
            END IF
           #FUN-D40103 -----End-------
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(iss_no)
#                 LET g_t1=tm.iss_no[1,3]
                  LET g_t1 = s_get_doc_no(tm.iss_no)     #No.FUN-550067
                 #CALL q_smy(FALSE,FALSE,g_t1,'asf','3') RETURNING g_t1   #TQC-670008
                  LET l_sql = " (smy73 <> 'Y' OR smy73 is null) "           #TQC-AC0293
                  CALL smy_qry_set_par_where(l_sql)      #TQC-AC0293 
                  CALL q_smy(FALSE,FALSE,g_t1,'ASF','3') RETURNING g_t1   #TQC-670008
#                  CALL FGL_DIALOG_SETBUFFER( g_t1 )
#                  LET tm.iss_no[1,3] = g_t1
                   LET tm.iss_no = g_t1          #No.FUN-550067
                  DISPLAY tm.iss_no TO iss_no
                  NEXT FIELD iss_no
               WHEN INFIELD(iss_store)
#                 CALL q_imd(0,0,tm.iss_store,'A') RETURNING tm.iss_store
#                 CALL FGL_DIALOG_SETBUFFER( tm.iss_store )
#No.FUN-AA0062  --Begin
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_imd"
#                  LET g_qryparam.default1 = tm.iss_store
#                  LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
#                  CALL cl_create_qry() RETURNING tm.iss_store
                 #CALL q_imd_1(FALSE,TRUE,tm.iss_store,"","","","") RETURNING tm.iss_store        #MOD-B50215 mark
                  CALL q_imd_1(FALSE,TRUE,tm.iss_store,"",g_plant,"","") RETURNING tm.iss_store   #MOD-B50215 add
#No.FUN-AA0062  --End
#                  CALL FGL_DIALOG_SETBUFFER( tm.iss_store )
                  DISPLAY tm.iss_store TO iss_store
                  NEXT FIELD iss_store
               WHEN INFIELD(iss_locat)
#                 CALL q_ime(0,0,tm.iss_locat,tm.iss_store,'A') RETURNING tm.iss_locat
#                 CALL FGL_DIALOG_SETBUFFER( tm.iss_locat )
#No.FUN-AA0062  --Begin
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_ime"
#                  LET g_qryparam.default1 = tm.iss_locat
#                   LET g_qryparam.arg1     = tm.iss_store #倉庫編號 #MOD-4A0063
#                   LET g_qryparam.arg2     = 'SW'         #倉庫類別 #MOD-4A0063
#                  CALL cl_create_qry() RETURNING tm.iss_locat
                  CALL q_ime_1(FALSE,TRUE,tm.iss_locat,tm.iss_store,"","","","","") RETURNING tm.iss_locat
#No.FUN-AA0062  --End
#                  CALL FGL_DIALOG_SETBUFFER( tm.iss_locat )
                  DISPLAY tm.iss_locat TO iss_locat
                  NEXT FIELD iss_locat
               OTHERWISE EXIT CASE
            END CASE
 
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
#NO.FUN-570151 start--
         ON ACTION locale        #FUN-570151
            LET g_change_lang = TRUE
            EXIT INPUT
 
#NO.FUN-570151 end--

         #TQC-D70067--add--str--
         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION help
            CALL cl_show_help()
         #TQC-D70067--add--end-- 

      END INPUT
 
#NO.FUN-570151 start--
#      IF INT_FLAG THEN
#         LET INT_FLAG = 0
#         CONTINUE WHILE
#      END IF
#      IF NOT cl_sure(19,0) THEN
#         EXIT PROGRAM
#      END IF
#      LET g_success='Y'
#      BEGIN WORK
#      CALL asfp504()
#      IF g_count=0 THEN LET g_success='N' END IF #不產生單頭
#         IF g_success='Y' THEN
#           COMMIT WORK
#            LET g_msg="asfi510 4 '",g_sfp.sfp01,"'"
#            CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#         ELSE
#            ROLLBACK WORK
#            CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
#         END IF
#         IF l_flag THEN
#            CONTINUE WHILE
#         ELSE
#            EXIT WHILE
#         END IF
#      ERROR ""
#   END WHILE
#   CLOSE WINDOW p504_w
#NO.FUN-570151 MARK
 
#NO.FUN-570151 start--
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p504_w              #FUN-570151
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM                     #FUN-570151
   END IF
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = 'asfp504'
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
          CALL cl_err('asfp504','9031',1)   
        ELSE
           LET tm.wc = cl_replace_str(tm.wc,"'","\"")
           LET lc_cmd = lc_cmd CLIPPED,
                        " '",tm.wc        CLIPPED, "'",
                        " '",tm.bdate     CLIPPED, "'",
                        " '",tm.edate     CLIPPED, "'",
                        " '",tm.iss_no    CLIPPED, "'",
                        " '",tm.iss_date  CLIPPED, "'",
                        " '",tm.iss_store CLIPPED, "'",
                        " '",tm.iss_locat CLIPPED, "'",
                        " '",g_bgjob CLIPPED, "'"
           CALL cl_cmdat('asfp504',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW p504_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
     EXIT WHILE
 END WHILE
#FUN-570151 --end--
END FUNCTION
 
FUNCTION p504()
   DEFINE   li_result   LIKE type_file.num5          #No.FUN-550067  #No.FUN-680121 SMALLINT
   #DEFINE l_sql	LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(600) #MOD-A70001 mark
   DEFINE l_sql	        STRING                   #No.MOD-A70001 mod 
   DEFINE l_cmd	LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(30)
   DEFINE sr	RECORD
               #tlf026  LIKE tlf_file.tlf026,    #No.MOD-840136 mark
                tlf905  LIKE tlf_file.tlf905,    #No.MOD-840136
   		tlf62	LIKE tlf_file.tlf62,
   		tlf10	LIKE tlf_file.tlf10,
   		tlf02	LIKE tlf_file.tlf02,
   		tlf03	LIKE tlf_file.tlf03,
   		u_type	LIKE type_file.num5    #No.FUN-680121 SMALLINT
   		END RECORD
   DEFINE l_tlf905 LIKE tlf_file.tlf905         #MOD-AB0098 add
   DEFINE l_name   LIKE type_file.chr20         #MOD-C30282 add
   DEFINE l_cnt2,i,i2   LIKE type_file.num5    #MOD-C80267 add

   #No.BANN
       #No.FUN-550067 --start--
        #CALL s_auto_assign_no("asf",tm.iss_no,tm.iss_date,"","","","","","")               #TQC-680048
        CALL s_auto_assign_no("asf",tm.iss_no,tm.iss_date,"","sfp_file","sfp01","","","")   #TQC-680048
        RETURNING li_result,tm.iss_no
      IF (NOT li_result) THEN
#  CALL s_smyauno(tm.iss_no,tm.iss_date) RETURNING g_i,tm.iss_no
#  IF g_i THEN
      #No.FUN-550067 --end--
 
   LET g_success='N' RETURN END IF
 
#------------No.TQC-680112 add
   DROP TABLE tmp
#FUN-680121-BEGIN 
  CREATE TEMP TABLE tmp(
    a         LIKE oea_file.oea01,
    b         LIKE ima_file.ima01,
    c         LIKE alh_file.alh33);
#FUN-680121-END
#------------No.TQC-680112 end
 
   #No.BANN ENC
   LET g_sfp.sfp01=tm.iss_no
   LET g_sfp.sfp02=tm.iss_date
   LET g_sfp.sfp03=tm.iss_date
   LET g_sfp.sfp04='N'
   LET g_sfp.sfpconf='N' #FUN-660106
   LET g_sfp.sfp05='N'
   LET g_sfp.sfp06='4'
   LET g_sfp.sfp07=g_grup #FUN-670103
 #MOD-470507(9793)
   LET g_sfp.sfpuser=g_user
   LET g_sfp.sfpdate=g_today
   LET g_sfp.sfpgrup=g_grup          #No.MOD-770102 add
##
 
   LET g_sfp.sfpplant = g_plant #FUN-980008 add
   LET g_sfp.sfplegal = g_legal #FUN-980008 add
 
   LET g_sfp.sfporiu = g_user      #No.FUN-980030 10/01/04
   LET g_sfp.sfporig = g_grup      #No.FUN-980030 10/01/04
   #FUN-AB0001--add---str---
   LET g_sfp.sfpmksg = g_smy.smyapr #是否簽核
   LET g_sfp.sfp15 = '0'            #簽核狀況
   LET g_sfp.sfp16 = g_user         #申請人
   #FUN-AB0001--add---end---
   INSERT INTO sfp_file VALUES(g_sfp.*)
   IF STATUS THEN
#     CALL cl_err('ins sfp:',STATUS,1)  #No.FUN-660128 
#     CALL cl_err3("ins","sfp_file",g_sfp.sfp01,"",STATUS,"","ins sfp:",1)   #No.FUN-660128 #NO.FUN-710026
      CALL s_errmsg('sfp01',g_sfp.sfp01,'ins sfp:',STATUS,1)                 #NO.FUN-710026
      LET g_success='N' RETURN  
   END IF
   LET g_sfs.sfs02=0
   INITIALIZE g_sfs.* TO NULL
 
#---------No.TQC-680032 modify
  #LET l_sql=
  #  #No.FUN-580119  --begin
  #  #"SELECT tlf026,tlf62,tlf10,tlf02,tlf03,0",
  #  "SELECT DISTINCT tlf026,tlf62,tlf10,tlf02,tlf03,0", #MOD-580262
  #  #No.FUN-580119  --end
  #  "  FROM tlf_file, sfb_file,sfa_file",
  #  " WHERE tlf06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
  #  "   AND tlf13 MATCHES 'asft62*'",
  #  "   AND tlf62 = sfb01",
  #  "   AND sfa01=sfb01 ",
  #  "   AND sfa11='E' AND sfb87!='X' ",
  #  "   AND sfb81 <= '",tm.iss_date,"'",     ##NO:0813
  #  "   AND ",tm.wc CLIPPED,
  #  " ORDER BY tlf62"
  ##No.BANN END
 
  LET l_sql=                                                                   
   # "SELECT tlf026,tlf62,tlf10,tlf02,tlf03,0",   #MOD-580262 #No.MOD-840136 mark
     "SELECT tlf905,tlf62,tlf10,tlf02,tlf03,0",   #MOD-840136
     "  FROM tlf_file ",                                                        
     " WHERE tlf06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",                  
     "   AND tlf13 LIKE 'asft62%'",                                          
     "   AND tlf62 IN (",                                                       
     #"   SELECT UNIQUE sfb01 FROM sfb_file,sfa_file ",  #CHI-D10039  
     "   SELECT UNIQUE sfb01 FROM sfb_file,sfa_file,sfu_file,sfv_file ",  #CHI-D10039      
     "   WHERE sfa01=sfb01 ",                                                   
     "   AND sfa11='E' AND sfb87!='X' ", 
     "   AND sfv11=sfb01 AND sfv01=sfu01 ",  #CHI-D10039       
     "   AND sfb81 <= '",tm.iss_date,"'",     ##NO:0813                         
     "   AND ",tm.wc CLIPPED," )",   
     #CHI-D10039---begin   
     "   AND tlf905 IN (",   
     "   SELECT UNIQUE sfu01 FROM sfb_file,sfa_file,sfu_file,sfv_file ",  
     "   WHERE sfa01=sfb01 ",                                                     
     "   AND sfa11='E' AND sfb87!='X' ",   
     "   AND sfv11=sfb01 AND sfv01=sfu01 ",
     "   AND sfb81 <= '",tm.iss_date,"'",                          
     "   AND ",tm.wc CLIPPED," )", 
     #CHI-D10039 ---end      
     " ORDER BY tlf62"            
#---------No.TQC-680032 end
 
 
 
   PREPARE p504_p1 FROM l_sql
   DECLARE p504_c1 CURSOR FOR p504_p1
   LET g_page_line = 1                      #MOD-C30282
  #START REPORT p504_rep TO 'asfp504.out'   #MOD-C30282 mark
   CALL cl_outnam(g_prog) RETURNING l_name  #MOD-C30282
   START REPORT p504_rep TO l_name          #MOD-C30282
   LET l_tlf905 = NULL            #MOD-AB0098 add  
   INITIALIZE sr.* TO NULL        #MOD-AB0098 add   
   FOREACH p504_c1 INTO sr.*
      #FUN-930062--mod--str--        #已產生領料單不可重復產生                                                                      
      SELECT COUNT(*) INTO g_cnt FROM sfu_file                                                                                      
       WHERE sfu01 = sr.tlf905    #入庫單號                                                                                         
         AND sfu09 IS NOT NULL                                                                                                      
     #IF g_cnt > 0 THEN                      #MOD-AB0098 mark
      IF g_cnt > 0 AND ((sr.tlf905 != l_tlf905) OR cl_null(l_tlf905)) THEN   #MOD-AB0098 add                                                                                                          
        #MOD-C80267---add---S
        #領料單欄位可能因先前的bug留有殘值,應再去判斷該領料單號是否存在領料單(asfi514)
        #若不存在,則將領料單欄位清空
         LET l_cnt2=0 
         SELECT COUNT(*) INTO l_cnt2 FROM sfu_file
          WHERE sfu01 = sr.tlf905 
            AND sfu09 IN (SELECT sfp01 FROM sfp_file WHERE sfp06='4')
         IF l_cnt2 = 0 THEN
            UPDATE sfu_file SET sfu09 = "" WHERE sfu01 = sr.tlf905
         ELSE
        #MOD-C80267---add---E
           #CALL cl_err('','asf-826',0)      #TQC-C80059--mark                                                                                          
            CALL cl_err('','asf-776',0)      #TQC-C80059--add                                                                                         
            CONTINUE FOREACH                                                                                                           
         END IF                              #MOD-C80267 add
      END IF                                                                                                                        

      SELECT COUNT(*) INTO g_cnt FROM rvu_file                                                                                      
       WHERE rvu01 = sr.tlf905    #入庫單號tlf905                                                                                   
         AND rvu16 IS NOT NULL                                                                                                      
     #IF g_cnt > 0 THEN                      #MOD-AB0098 mark
      IF g_cnt > 0 AND ((sr.tlf905 != l_tlf905) OR cl_null(l_tlf905)) THEN   #MOD-AB0098 add                                                                                                          
        #MOD-C80267---add---S
        #領料單欄位可能因先前的bug留有殘值,應再去判斷該領料單號是否存在領料單(asfi514)
        #若不存在,則將領料單欄位清空
         LET l_cnt2=0
         SELECT COUNT(*) INTO l_cnt2 FROM rvu_file
          WHERE rvu01 = sr.tlf905
            AND rvu16 IN (SELECT sfp01 FROM sfp_file WHERE sfp06='4')
         IF l_cnt2 = 0 THEN
            UPDATE rvu_file SET rvu16 = "" WHERE rvu01 = sr.tlf905
         ELSE
        #MOD-C80267---add---E
           #CALL cl_err('','asf-826',0)      #TQC-C80059--mark                                                                                          
            CALL cl_err('','asf-776',0)      #TQC-C80059--add
            CONTINUE FOREACH                                                                                                           
         END IF                              #MOD-C80267 add
      END IF                                                                                                                        
      #FUN-930062--mod--end 
      IF sr.tlf03=50
         THEN LET sr.u_type=+1
         ELSE LET sr.u_type=-1
      END IF
      LET l_tlf905 = sr.tlf905        #MOD-AB0098 add
      OUTPUT TO REPORT p504_rep(sr.*)
   END FOREACH
   FINISH REPORT p504_rep

  #MOD-C80267---add---S
   FOR i = 1 TO g_sfu.getlength()
       UPDATE sfu_file SET sfu09 = g_sfu[i].sfu09 WHERE sfu01 = g_sfu[i].sfu01
   END FOR

   FOR i2 = 1 TO g_rvu.getlength()
       UPDATE rvu_file SET rvu16 = g_rvu[i2].rvu16 WHERE rvu01 = g_rvu[i2].rvu01
   END FOR
  #MOD-C80267---add---E

  #No.+366 010709 by plum
#  LET l_cmd="chmod 777 asfp504.out"                 #No.FUN-9C0009 
#  RUN l_cmd                                         #No.FUN-9C0009   
#  IF os.Path.chrwx("asfp504.out",511) THEN END IF   #No.FUN-9C0009   #MOD-C30282 mark
   IF os.Path.chrwx(l_name,511) THEN END IF          #MOD-C30282
  #No.+366...end
END FUNCTION
 
REPORT p504_rep(sr)
   DEFINE sr	RECORD
#               tlf026  VARCHAR(10),
#   		tlf62 VARCHAR(10),
               #tlf026  LIKE tlf_file.tlf026,  #No.FUN-680121 VARCHAR(16),       #No.FUN-550067 #No.MOD-840136 mark
                tlf905  LIKE tlf_file.tlf905,  #No.MOD-840136
                tlf62   LIKE tlf_file.tlf026,  #No.FUN-680121 VARCHAR(16),       #No.FUN-550067
   		tlf10	LIKE tlf_file.tlf10,   #No.FUN-680121 DEC(15,3),
   		tlf02	LIKE type_file.num10,  #No.FUN-680121 INTEGER,
   		tlf03	LIKE type_file.num10,  #No.FUN-680121 INTEGER,
   		u_type	LIKE type_file.num5    #No.FUN-680121 SMALLINT
   		END RECORD
#  DEFINE qty		LIKE ima_file.ima26    #No.FUN-680121 DEC(15,3)
   DEFINE qty           LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
   DEFINE l_ima35	LIKE ima_file.ima35    #No.FUN-680121 VARCHAR(10)
   DEFINE l_ima36	LIKE ima_file.ima36    #No.FUN-680121 VARCHAR(10)
   DEFINE l_sfa		RECORD LIKE sfa_file.*
   DEFINE l_qpa         LIKE sfa_file.sfa161        #No.MOD-640013 add
   DEFINE l_qty         LIKE sfs_file.sfs05         #No.MOD-640013 add
   DEFINE l_str         STRING                      #MOD-C40024 add
   DEFINE l_sfu01       LIKE sfu_file.sfu01         #MOD-C40024 add
   DEFINE l_rvu01       LIKE rvu_file.rvu01         #MOD-C40024 add
   DEFINE l_i,l_i2      LIKE type_file.num5         #MOD-C80267 add
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER EXTERNAL BY sr.tlf62
 
  FORMAT
   AFTER GROUP OF sr.tlf62
      IF g_bgjob = "N" THEN        #FUN-570151
          MESSAGE sr.tlf62, qty
          CALL ui.Interface.refresh()
      END IF
      LET qty=GROUP SUM(sr.tlf10*sr.u_type)
   #   LET g_sfq.sfq01=tm.iss_no
   #   LET g_sfq.sfq02=sr.tlf62
#     LET g_sfq.sfq04=0
   #   LET g_sfq.sfq04=' '
   #   LET g_sfq.sfq03=qty
   #   INSERT INTO sfq_file VALUES(g_sfq.*)
   #   IF STATUS THEN CALL cl_err('ins sfq:',STATUS,1) LET g_success='N' END IF
      DECLARE c2 CURSOR FOR
          SELECT sfa_file.*, ima35,ima36
               FROM sfa_file, ima_file
              WHERE sfa01=sr.tlf62 AND sfa03=ima01 AND sfa11='E'
              ORDER BY sfa26  #No.MOD-640013 add
      #No.FUN-AA0062  --Begin
      IF NOT s_chk_ware(l_ima35) THEN
          LET l_ima35 = ''
          LET l_ima36 = ''
      END IF 
      #No.FUN-AA0062  --End
      LET g_count=0
      FOREACH c2 INTO l_sfa.*, l_ima35, l_ima36
         LET g_sfs.sfs01=tm.iss_no
         IF cl_null(g_sfs.sfs02) THEN LET g_sfs.sfs02=0 END IF
         LET g_sfs.sfs02=g_sfs.sfs02+1
         LET g_sfs.sfs03=l_sfa.sfa01
       # LET g_sfs.sfs04=sr.tlf62
         LET g_sfs.sfs04=l_sfa.sfa03
      #  LET g_sfs.sfs05=qty*l_sfa.sfa161
      #No.B515 010511 by linda mod
        #LET g_sfs.sfs05=qty*l_sfa.sfa161 - l_sfa.sfa06   #No.MOD-640013 mark
         LET g_sfs.sfs05=qty*l_sfa.sfa161                 #No.MOD-640013 add
         LET g_sfs.sfs06=l_sfa.sfa12
        #------------No.MOD-640013 add
         IF l_sfa.sfa26 MATCHES '[SUTZ]' THEN    #MODNO:7111 add 'T'   #FUN-A20037 add 'Z' 
            LET g_sfs.sfs26 = l_sfa.sfa26
            LET g_sfs.sfs27 = l_sfa.sfa27
            LET g_sfs.sfs28 = l_sfa.sfa28
            SELECT (sfa161 * sfa28) INTO l_qpa FROM sfa_file
               WHERE sfa01 = l_sfa.sfa01 AND sfa03 = l_sfa.sfa27
                 AND sfa012 = l_sfa.sfa012 AND sfa013 = l_sfa.sfa013  #FUN-A60027
            LET g_sfs.sfs05 = qty*l_qpa
            SELECT SUM(c) INTO l_qty FROM tmp WHERE a = l_sfa.sfa01
               AND b = l_sfa.sfa27
            IF g_sfs.sfs05 < l_qty THEN
               LET g_sfs.sfs05 = 0
            ELSE
               LET g_sfs.sfs05 = g_sfs.sfs05 - l_qty
            END IF
         ELSE                               #No.MOD-8B0086 add
            LET g_sfs.sfs27 = l_sfa.sfa27   #No.MOD-8B0086 add
         END IF
         #判斷發料是否大於可發料數(sfa05-sfa06)
         IF g_sfs.sfs05 > (l_sfa.sfa05 - l_sfa.sfa06) THEN
            LET g_sfs.sfs05 = l_sfa.sfa05 - l_sfa.sfa06
         END IF
         LET g_sfs.sfs05 = s_digqty(g_sfs.sfs05,g_sfs.sfs06)       #FUN-BB0084
 
         INSERT INTO tmp
           VALUES(l_sfa.sfa01,l_sfa.sfa27,g_sfs.sfs05)
        #------------No.MOD-640013 end

         #---- modi in 99/10/05 NO:0643 --
         IF NOT cl_null(tm.iss_store) THEN
            LET g_sfs.sfs07 = tm.iss_store
         ELSE
            LET g_sfs.sfs07=l_ima35
         END IF
         IF NOT cl_null(tm.iss_locat) THEN
            LET g_sfs.sfs08 = tm.iss_locat
         ELSE
            LET g_sfs.sfs08=l_ima36
         END IF
         #--------------------------------
         LET g_sfs.sfs10=l_sfa.sfa08
         LET g_sfs.sfs09=' '           #No.MOD-840136 
         #No.FUN-580119  --begin
         IF g_sma.sma115 = 'Y' THEN
            SELECT ima25,ima55,ima906,ima907
              INTO g_ima25,g_ima55,g_ima906,g_ima907
              FROM ima_file
             WHERE ima01=g_sfs.sfs04
            IF SQLCA.sqlcode THEN
#              CALL cl_err('sel ima',SQLCA.sqlcode,1)   #No.FUN-660128
               CALL cl_err3("sel","ima_file",g_sfs.sfs04,"",SQLCA.sqlcode,"","sel ima",1)   #No.FUN-660128
               LET g_success = 'N'
            END IF
            IF cl_null(g_ima55) THEN LET g_ima55 = g_ima25 END IF
            LET g_sfs.sfs30=g_sfs.sfs06
            LET g_factor = 1
            CALL s_umfchk(g_sfs.sfs04,g_sfs.sfs30,g_ima55)
              RETURNING g_cnt,g_factor
            IF g_cnt = 1 THEN
               LET g_factor = 1
            END IF
            LET g_sfs.sfs31=g_factor
            LET g_sfs.sfs32=g_sfs.sfs05
            LET g_sfs.sfs33=g_ima907
            LET g_factor = 1
            CALL s_umfchk(g_sfs.sfs04,g_sfs.sfs33,g_ima55)
              RETURNING g_cnt,g_factor
            IF g_cnt = 1 THEN
               LET g_factor = 1
            END IF
            LET g_sfs.sfs34=g_factor
            LET g_sfs.sfs35=0
            IF g_ima906 = '3' THEN
               LET g_factor = 1
               CALL s_umfchk(g_sfs.sfs04,g_sfs.sfs30,g_sfs.sfs33)
                 RETURNING g_cnt,g_factor
               IF g_cnt = 1 THEN
                  LET g_factor = 1
               END IF
               LET g_sfs.sfs35=g_sfs.sfs32*g_factor
               LET g_sfs.sfs35=s_digqty(g_sfs.sfs35,g_sfs.sfs33)    #FUN-BB0084
            END IF
            IF g_ima906='1' THEN
               LET g_sfs.sfs33=NULL
               LET g_sfs.sfs34=NULL
               LET g_sfs.sfs35=NULL
            END IF
         END IF
         #No.FUN-580119  --end
         #FUN-670103...............begin
         IF g_aaz.aaz90='Y' THEN
            SELECT sfb98 INTO g_sfs.sfs930 FROM sfb_file
                                          WHERE sfb01=l_sfa.sfa01
            IF SQLCA.sqlcode THEN
               LET g_sfs.sfs930=NULL
            END IF
         END IF
         #FUN-670103...............end
 
         LET g_sfs.sfsplant = g_plant #FUN-980008 add
         LET g_sfs.sfslegal = g_legal #FUN-980008 add
         LET g_sfs.sfs012 = l_sfa.sfa012   #FUN-A60027
         LET g_sfs.sfs013 = l_sfa.sfa013   #FUN-A60027  
#FUN-C70014 add begin-------------
         IF cl_null(g_sfs.sfs014) THEN 
            LET g_sfs.sfs014 = ' '     
         END IF 
#FUN-C70014 add end -------------- 
         #FUN-CB0087---add---str---
         IF g_aza.aza115 = 'Y' THEN
            CALL s_reason_code(g_sfs.sfs01,g_sfs.sfs03,'',g_sfs.sfs04,g_sfs.sfs07,g_sfp.sfp16,g_sfp.sfp07) RETURNING g_sfs.sfs37
            IF cl_null(g_sfs.sfs37) THEN
               CALL cl_err('','aim-425',1)
               LET g_success = 'N'
            END IF
         END IF
         #FUN-CB0087---add---end--
         INSERT INTO sfs_file VALUES(g_sfs.*)
         IF SQLCA.SQLCODE THEN 
           CALL cl_err('i sfs:',STATUS,1)  #No.FUN-660128
           CALL cl_err3("ins","sfs_file",g_sfs.sfs01,g_sfs.sfs02,STATUS,"","i sfs:",1)    #No.FUN-660128
           LET g_success='N'
#FUN-B70074 --------------Begin-----------------
         ELSE
            IF NOT s_industry('std') THEN
               LET g_sfsi.sfsi01 = g_sfs.sfs01
               LET g_sfsi.sfsi02 = g_sfs.sfs02
               IF NOT s_ins_sfsi(g_sfsi.*,g_sfs.sfsplant) THEN
                  LET g_success='N'
               END IF   
            END IF
#FUN-B70074 --------------End-------------------
         END IF
         LET g_count=g_count+1
      END FOREACH


#工單完工入庫領料-------------------------------------------------------------------
     #------97/10/03 modify產生時更新入庫單上的耗材單號(sfu09)
     #MOD-C30029---mark---str---
     #SELECT COUNT(*) INTO g_cnt FROM sfu_file
      #WHERE sfu01 = sr.tlf026    #入庫單號  #No.MOD-840136 mark
     # WHERE sfu01 = sr.tlf905    #入庫單號  #No.MOD-840136
     #MOD-C30029---mark---end---
     #MOD-C30029---str---
     #FOREACH p504_c1 INTO sr.*   #MOD-C40024 mark
   #MOD-C40024---mod---str---
        LET g_cnt = 0
        SELECT COUNT(*) INTO g_cnt FROM sfu_file,sfv_file
         WHERE sfu_file.sfu01 = sfv_file.sfv01
           AND sfv_file.sfv11 = sr.tlf62
           AND sfu_file.sfupost='Y'
           AND sfu_file.sfu09 IS NULL
     #MOD-C30029---end---
    IF g_cnt > 0 THEN
        #UPDATE sfu_file SET sfu09 = tm.iss_no
        ##WHERE sfu01 = sr.tlf026    #入庫單號  #No.MOD-840136 mark
        # WHERE sfu01 = sr.tlf905    #入庫單號  #No.MOD-840136

       LET l_str = "SELECT sfu_file.sfu01 FROM sfu_file,sfv_file ",
                   "WHERE sfu_file.sfu01 = sfv_file.sfv01 ",         #AND sfv_file.sfv11 = '",sr.tlf62,"' ", #MOD-C80267 mark
                   " AND sfu_file.sfupost ='Y' AND sfu_file.sfu09 IS NULL ",
                  #MOD-C80267 add---S
                   "   AND sfu_file.sfu02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                   "   AND sfv_file.sfv11 IN (",
                   #"   SELECT UNIQUE sfb01 FROM sfb_file,sfa_file ",   #CHI-D10039  
                   "   SELECT UNIQUE sfb01 FROM sfb_file,sfa_file,sfu_file,sfv_file ",   #CHI-D10039  
                   "   WHERE sfa01=sfb01 ",
                   "   AND sfa11='E' AND sfb87!='X' ",
                   "   AND sfv11=sfb01 AND sfv01=sfu01 ",  #CHI-D10039 
                   "   AND sfb81 <= '",tm.iss_date,"'",
                   "   AND ",tm.wc CLIPPED," )"
                  #MOD-C80267 add---E

       PREPARE p504_c3 FROM l_str
       DECLARE c3 CURSOR FOR p504_c3
      #FOREACH c3 INTO l_sfu01         #MOD-C40024---add #MOD-C80267 mark
       LET l_i =1                      #MOD-C80267
       FOREACH c3 INTO g_sfu[l_i].*    #MOD-C80267
          #MOD-C80267 mark---S
          #UPDATE sfu_file SET sfu09 = tm.iss_no
          # WHERE sfu01 = l_sfu01
          #MOD-C80267 mark---E
           LET g_sfu[l_i].sfu09 = tm.iss_no      #MOD-C80267 add
  #MOD-C40024---mod---end---

          #IF STATUS OR SQLCA.sqlerrd[3]=0 THEN  #MOD-C80267 mark
           IF STATUS THEN                        #MOD-C80267
             #CALL cl_err('upd sfu',STATUS,0) 
             #CALL cl_err3("upd","sfu_file",sr.tlf026,"",STATUS,"","upd sfu",0)   #No.FUN-660128 #No.MOD-840136 mark
              CALL cl_err3("upd","sfu_file",sr.tlf905,"",STATUS,"","upd sfu",0)   #No.MOD-840136
              LET g_success = 'N'   #No.FUN-660128
              EXIT FOREACH          #MOD-C80267 add
           END IF
           LET l_i=l_i+1            #MOD-C80267 add
       END FOREACH  #MOD-C40024---add
    END IF
     #END FOREACH       #MOD-C30029 add  #MOD-C40024 mark 


#委外入庫領料-----------------------------------------------------------------------
    #FUN-930062--mod--str--
   #MOD-C30029---mark---str---                                                                                                         
   #SELECT COUNT(*) INTO g_cnt FROM rvu_file                                                                                        
   # WHERE rvu01 = sr.tlf905    #入庫單號tlf905   
   #MOD-C30029---mark---end---
   #MOD-C30029---str---
  # FOREACH p504_c1 INTO sr.*   #MOD-C40024 mark
      LET g_cnt = 0
      SELECT COUNT(*) INTO g_cnt FROM rvu_file,rvv_file
      #WHERE rvu01 = sr.tlf905    #MOD-C40024 mark
      #  AND rvu01 = rvv01        #MOD-C40024 mark
       WHERE rvu_file.rvu01 = rvv_file.rvv01
         AND rvv_file.rvv18 = sr.tlf62
         AND rvu_file.rvuconf='Y'
         AND rvu_file.rvu16 IS NULL
   #MOD-C30029---end---                                                                                  
    IF g_cnt>0 THEN      
  #MOD-C40024---mod---str---
       LET l_str = "SELECT rvu_file.rvu01 FROM rvu_file,rvv_file ",
                   "WHERE rvu_file.rvu01 = rvv_file.rvv01 ",        #AND rvv_file.rvv18 = '",sr.tlf62,"' ", #MOD-C80267 mark
                   " AND rvu_file.rvuconf = 'Y' AND rvu_file.rvu16 IS NULL ",
                  #MOD-C80267 add---S
                   "   AND rvu_file.rvu03 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                   "   AND rvv_file.rvv18 IN (",
                   #"   SELECT UNIQUE sfb01 FROM sfb_file,sfa_file ",  #CHI-D10039
                   "   SELECT UNIQUE sfb01 FROM sfb_file,sfa_file,sfu_file,sfv_file ",  #CHI-D10039  
                   "   WHERE sfa01=sfb01 ",
                   "   AND sfa11='E' AND sfb87!='X' ",
                   "   AND sfv11=sfb01 AND sfv01=sfu01 ",  #CHI-D10039  
                   "   AND sfb81 <= '",tm.iss_date,"'",
                   "   AND ",tm.wc CLIPPED," )"
                  #MOD-C80267 add---E

       PREPARE p504_c4 FROM l_str
       DECLARE c4 CURSOR FOR p504_c4

      #FOREACH c4 INTO l_rvu01             #MOD-C80267 mark
       LET l_i2 =1                         #MOD-C80267 
       FOREACH c4 INTO g_rvu[l_i2].*       #MOD-C80267
         #MOD-C80267 mark---S                                                                                                            
         #UPDATE rvu_file SET rvu16 = tm.iss_no                                                                                         
         ##WHERE rvu01 = sr.tlf905    #入庫單號      
         # WHERE rvu01 = l_rvu01      
         #MOD-C80267 mark---E
          LET g_rvu[l_i2].rvu16 = tm.iss_no              #MOD-C80267 add
                                                                                 
         #IF STATUS OR SQLCA.sqlerrd[3]=0 THEN           #MOD-C80267 mark                                                                                 
          IF STATUS THEN                                 #MOD-C80267
             CALL cl_err3("upd","sfu_file",sr.tlf905,"",STATUS,"","upd sfu",0)                                                          
             LET g_success = 'N'                                                                                                        
             EXIT FOREACH                                #MOD-C80267 add
          END IF
          LET l_i2=l_i2+1                                #MOD-C80267 add
       END FOREACH   
  #MOD-C40024---mod---end---                                                                                                                     
    END IF             

   #END FOREACH      #MOD-C30029 add  #MOD-C40024 mark                                                                                                       
   #FUN-930062--mod--end
END REPORT
#Patch....NO.TQC-610037 <001> #
