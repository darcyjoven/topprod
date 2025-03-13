# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimt310.4gl
# Descriptions...: 庫存調撥調整作業
# Date & Author..: 92/06/23 By Lin
#
#-Revision Log----------------------------------------------------------
# 1992/10/29(Lee): 新增若自動編號又輸入流水號的檢查s_mfgckno()
#-----------------------------------------------------------------------
# 1992/12/15(Pin): 調整方法異動(凡撥出!=撥入即調整)
#                  1.一律調整撥出倉之料帳(FROM)
#                  2.調整科目一律放至貸方
#                  3.以＋�－表示其性質
#                      ＋:撥入<撥出 
#                      －:撥入>撥出 
#-----------------------------------------------------------------------
# 1993/12/06(Apple): 異動記錄檔區分為(aimt3101,aimt3102)
#                    盈虧為不同異動記錄 
#-----------------------------------------------------------------------
# 1993/12/30(Apple): 調撥調整只適用兩階段調撥
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式
# Modify.........: No.FUN-550029 05/06/01 By vivien 單據編號格式放大
# Modify.........: No.FUN-540059 05/06/19 By wujie  單據編號格式放大
# Modify.........: No.FUN-560183 05/06/22 By kim 移除ima86成本單位
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: NO.FUN-660156 06/06/23 By Tracy cl_err -> cl_err3 
# Modify.........: No.TQC-670008 06/07/05 By kim 將 g_sys 變數改成寫死系統別(要大寫)
# Modify.........: No.FUN-690026 06/09/12 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690022 06/09/15 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.CHI-690066 06/12/13 By rainy CALL s_daywk() 要判斷未設定或非工作日
# Modify.........: No.FUN-730033 07/03/21 By Carrier 會計科目加帳套
# Modify.........: No.TQC-740042 07/04/09 By bnlent 用年度取帳套
# Modify.........: No.FUN-8C0084 08/12/22 By jan s_delimg相關改以 料倉儲批為參數傳入 ,不使用 rowid
# Modify.........: No.FUN-920186 09/03/18 By lala 理由碼azf01必須為庫存調撥 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A40023 10/03/22 By dxfwo ima26x改善
# Modify.........: No:FUN-A70120 10/08/03 BY alex 調整rowid為type_file.row_id
# Modify.........: No:FUN-AA0062 10/10/26 By yinhy 倉庫權限使用控管修改
# Modify.........: No.FUN-AA0059 10/10/29 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No.FUN-AA0059 10/10/29 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B10049 11/01/20 By destiny 科目查詢自動過濾
# Modify.........: No.TQC-C60108 12/07/24 By fengrui 修改報錯信息不顯示問題
# Modify.........: No.FUN-CB0087 12/11/29 By xianghui 倉庫單據理由碼改善
# Modify.........: No.FUN-D20060 13/02/21 By chenying 設限倉庫控卡
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_wo         LIKE type_file.chr1,       #單據是否為工單  #No.FUN-690026 VARCHAR(1)
    g_sql        string,                    #No.FUN-580092 HCN
    g_t1         LIKE smy_file.smyslip,     #單別 #No.FUN-690026 VARCHAR(05),                  
                                            #No.FUN-550029
    g_flag       LIKE type_file.chr1,       #判斷是否為新增的自動編號  #No.FUN-690026 VARCHAR(1)
    g_diff       LIKE img_file.img08,       #MOD-530179             #調整數量
    g_ima25      LIKE ima_file.ima25,       #主檔庫存單位
    g_img21      LIKE img_file.img21,       #轉換率
    g_img23      LIKE img_file.img23,       #可用倉儲
    g_img24      LIKE img_file.img24,       #MRP 可用倉儲
    g_img10      LIKE img_file.img10,       #庫存數量
    g_argv1      LIKE img_file.img05,       #調撥單號
    g_argv2      LIKE img_file.img12,       #調撥日期 #No.FUN-690026 DATE
    g_argv3      LIKE img_file.img01,       #料件編號
    g_argv4      LIKE img_file.img02,       #倉庫編號
    g_argv5      LIKE img_file.img03,       #存放位置
    g_argv6      LIKE img_file.img04,       #批號
    g_argv7      LIKE img_file.img09,       #庫存單位
    g_argv8      LIKE img_file.img08,       #MOD-530179            #撥出數量
    g_argv9      LIKE img_file.img10,       #MOD-530179             #撥入數量
    g_imm10      LIKE imm_file.imm10,       #資料來源  #No.FUN-690026 VARCHAR(1)
    l_year,l_prd LIKE type_file.num5,       #No.FUN-690026 SMALLINT
    g_img36      LIKE img_file.img36,
    g_img26      LIKE img_file.img26,
    g_img        RECORD
        adjno    LIKE img_file.img05,     #調整日期
        img05    LIKE img_file.img05,     #單據單號
        img16    LIKE img_file.img16,     #調撥日期
        debit    LIKE img_file.img26,     #調整科目
        img01    LIKE img_file.img01,     #料件編號
        img02    LIKE img_file.img02,     #倉庫
        img03    LIKE img_file.img03,     #儲位
        img04    LIKE img_file.img04,     #存放批號
        img19    LIKE img_file.img19,     #Inv Grade
        img36    LIKE img_file.img36,     #        
        img09    LIKE img_file.img09,     #庫存單位
        img08    LIKE img_file.img08,     #調撥數量
        adjqty   LIKE img_file.img10,    #調整數量
        azf01    LIKE azf_file.azf01      #理由碼
    END RECORD 
DEFINE g_bookno1            LIKE aza_file.aza81    #No.FUN-730033
DEFINE g_bookno2            LIKE aza_file.aza82    #No.FUN-730033
DEFINE g_forupd_sql         STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_chr                LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt                LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_i                  LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg                LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_tlf_rowid          LIKE type_file.row_id  #chr18  FUN-A70120
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
 
    #若非多倉儲管理,無法執行本程式
    IF g_sma.sma12 MATCHES '[Nn]'  THEN
       OPEN WINDOW t310_w1 AT 16,20 WITH 3 ROWS, 40 COLUMNS
             
       CALL cl_getmsg('mfg1007',g_lang) RETURNING g_msg
       DISPLAY g_msg clipped AT 2,1
#      SLEEP 3
       CLOSE WINDOW t310_w1
       EXIT PROGRAM 
    END IF
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
    INITIALIZE g_img.* TO NULL
    LET g_argv1 = ARG_VAL(1)      #調整單號
    LET g_argv2 = ARG_VAL(2)      #調撥日期
    LET g_argv3 = ARG_VAL(3)      #料件編號
    LET g_argv4 = ARG_VAL(4)      #倉庫編號
    LET g_argv5 = ARG_VAL(5)      #存放位置
    LET g_argv6 = ARG_VAL(6)      #批號
    LET g_argv7 = ARG_VAL(7)      #庫存單位
    LET g_argv8 = ARG_VAL(8)      #撥出數量
    LET g_argv9 = ARG_VAL(9)      #撥入數量
 
    OPEN WINDOW aimt310_w WITH FORM "aim/42f/aimt310" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    IF g_argv1 IS NULL THEN LET g_argv1=' ' END IF
    IF g_argv4 IS NULL THEN LET g_argv4=' ' END IF
    IF g_argv5 IS NULL THEN LET g_argv5=' ' END IF
    IF g_argv6 IS NULL THEN LET g_argv6=' ' END IF
    LET g_img.img05=g_argv1
    LET g_img.img16=g_argv2
    LET g_img.img01=g_argv3
    LET g_img.img02=g_argv4
    LET g_img.img03=g_argv5
    LET g_img.img04=g_argv6
    LET g_img.img09=g_argv7
    LET g_img.img08=g_argv8
    LET g_img.adjqty=g_argv9
    IF g_aza.aza115 ='Y' THEN                    #FUN-CB0087
       CALL cl_set_comp_required('azf01',TRUE)   #FUN-CB0087 
    END IF                                       #FUN-CB0087
 
    #主程式
    CALL t310_p()
 
    CLOSE WINDOW aimt310_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
END MAIN
 
#--------------------------------------------------------------------
FUNCTION t310_p()
  DEFINE l_yn LIKE type_file.num5     #No.FUN-690026 SMALLINT
#No.FUN-550029--start--
  DEFINE li_result LIKE type_file.num5     #No.FUN-690026 SMALLINT
#No.FUN-550029--end--
    CALL cl_opmsg('a')
    MESSAGE ""
    CLEAR FORM                                   # 清螢幕欄位內容
    IF g_argv3 IS NULL OR g_argv3 =' ' THEN      # 料件編號
       LET g_img.img16=g_today #調撥日期為系統日期
    END IF
    WHILE TRUE
        LET g_action_choice = ""
        IF s_shut(0) THEN EXIT WHILE END IF      # 檢查權限
        BEGIN WORK
        LET g_success = 'Y'
        LET g_action_choice=''
        CALL t310_i()                            # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            EXIT WHILE
        END IF
        IF g_action_choice='locale' THEN CONTINUE WHILE END IF
        IF NOT cl_sure(21,20) THEN
           CONTINUE WHILE
        END IF
        CALL cl_wait()
         #更新[單據性質檔]的已使用單號
#No.FUN-550029--start--
        CALL s_auto_assign_no("aim",g_img.adjno,g_img.img16,"7","","","","","")
        RETURNING li_result,g_img.adjno
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
#       IF g_smy.smyauno='Y'  AND cl_null(g_img.adjno[5,10])
#		   THEN CALL s_smyauno(g_img.adjno,g_img.img16) 
#		   		 RETURNING g_i,g_img.adjno
#                 IF g_i THEN 
#                    CALL cl_err('Cannot update smy_file',SQLCA.sqlcode,0)
#                    CONTINUE WHILE
#                 END IF
		         DISPLAY BY NAME g_img.adjno 
#        END IF
#No.FUN-550029--end--
        CALL t310_t()    #更新相關檔案
        IF g_success = 'Y' THEN 
           CALL cl_cmmsg(1) COMMIT WORK
        ELSE 
           CALL cl_rbmsg(1) ROLLBACK WORK
        END IF
        CALL t310_c1()
        LET g_img.img02=''
        LET g_img.img05=''
        CLEAR img02,img05
        #ERROR ""  #TQC-C60108 mark
        IF g_argv3 IS NOT NULL AND g_argv3 !=' ' THEN
           CALL cl_end(10,20)
           EXIT WHILE
        END IF
        IF g_action_choice = "exit" THEN
          EXIT WHILE
       END IF
    END WHILE
END FUNCTION
 
FUNCTION t310_c1()
    LET g_img.img01=''
    LET g_img.azf01=''
    LET g_img.img02=''
    LET g_img.img03=''
    LET g_img.img04=''
    LET g_img.debit=' '
    LET g_img.img09=''
    LET g_img.adjqty=''
    LET g_img.adjno =''
    LET g_img.img08=''
    CLEAR img01,ima02,ima05,ima08,azf01,azf03,
          img02,img03,img04,img19,img36,debit,img09,img08,adjqty
END FUNCTION
 
FUNCTION t310_i()
DEFINE
    l_img02 LIKE img_file.img02,  #倉庫
    l_img03 LIKE img_file.img03,  #倉庫儲位
    l_img04 LIKE img_file.img04,  #批號
    l_img19 LIKE img_file.img19,  #庫存等級
    l_img36 LIKE img_file.img36,  #代號
    l_n     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    l_dir   LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    p_cmd   LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    l_dir2  LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    l_dir3  LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
DEFINE l_doc_len       LIKE type_file.num5     #No.FUN-550029  #No.FUN-690026 SMALLINT
DEFINE li_result       LIKE type_file.num5     #No.FUN-690026 SMALLINT
DEFINE l_flag          LIKE type_file.chr1     #FUN-CB0087
DEFINE l_where         STRING                  #FUN-CB0087   
DEFINE l_sql           STRING                  #FUN-CB0087 qiull
 
    DISPLAY BY NAME 
              g_img.adjno,g_img.img05,g_img.img16,g_img.debit,
              g_img.img01,g_img.img02,g_img.img03,g_img.img04,
              g_img.img19,g_img36,
              g_img.img09,g_img.img08,g_img.adjqty,
              g_img.azf01   
 
    INPUT BY NAME 
              g_img.adjno,g_img.img05,g_img.img16,g_img.debit,
              g_img.img01,g_img.img02,g_img.img03,g_img.img04,
              g_img.img09,g_img.img08,g_img.adjqty,
              g_img.azf01   WITHOUT DEFAULTS 
 
        ON ACTION locale
           ROLLBACK WORK
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           CALL cl_dynamic_locale()
           LET g_action_choice = "locale"
           EXIT INPUT
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t310_set_entry(p_cmd)
            CALL t310_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE 
#No.FUN-550029 --start--
            CALL cl_set_docno_format("img05")
#No.FUN-550029 --end--
 
        BEFORE FIELD adjno  #調整單號
            IF NOT cl_null(g_argv3) THEN
               CALL t310_img01()
            ELSE
               CALL t310_img04()
            END IF
            CALL t310_set_entry(p_cmd)
 
        AFTER FIELD adjno   #調整單號
            IF NOT cl_null(g_img.adjno) THEN
#No.FUN-550029 --start--
#              LET g_img.adjno[4,4]='-'
#              DISPLAY BY NAME g_img.adjno
#              IF g_img.adjno = '   -' THEN
#                 LET g_img.adjno=''
#              END IF
#              IF NOT cl_null(g_img.adjno[1,3]) THEN
#                 LET g_t1=g_img.adjno[1,3]
                  CALL s_check_no("aim",g_img.adjno,"","7","","","")       #No.FUN-540059
                     RETURNING li_result,g_img.adjno
                  IF (NOT li_result) THEN                                             
                     NEXT FIELD adjno
                  END IF 
#	          CALL s_mfgslip(g_t1,'aim','7')	#檢查單別
#                    IF NOT cl_null(g_errno) THEN	 		#抱歉, 有問題
#                       CALL cl_err(g_t1,g_errno,0)
#                       NEXT FIELD adjno
#                    END IF
#              END IF
#               IF g_smy.smyauno MATCHES '[nN]' THEN 
#                 IF cl_null(g_img.adjno[5,10]) THEN 
#	          IF cl_null(g_img.adjno[g_no_sp,g_no_ep]) THEN   #No.FUN-550029
#                     CALL cl_err(g_img.adjno,'mfg6089',0)
#                     NEXT FIELD adjno
#                  END IF
#                 IF NOT cl_chk_data_continue(g_img.adjno[5,10]) THEN
#                     CALL cl_err('','9056',0)
#                     NEXT FIELD adjno
#                 END IF
#               END IF
	       #進行輸入之單號檢查
 	       CALL s_mfgchno(g_img.adjno) RETURNING g_i,g_img.adjno
 	       DISPLAY BY NAME g_img.adjno
 	       IF NOT g_i THEN NEXT FIELD adjno END IF
#No.FUN-550029 --end--
               LET l_dir='D'
            END IF
            CALL t310_set_no_entry(p_cmd)
 
{
        BEFORE FIELD img05   #調撥單號
            IF g_argv3 IS NOT NULL AND g_argv3 !=' ' THEN
               IF l_dir='D' THEN
                  NEXT FIELD debit
               ELSE
                  NEXT FIELD adjno
               END IF
            END IF 
}
 
        AFTER FIELD img05   #調撥單號
#No.FUN-550029--start--
#           LET g_img.img05[4,4]='-'
            DISPLAY BY NAME g_img.img05
#           IF g_img.img05 = '   -      ' THEN
#               LET g_img.img05=' '
#           END IF
#No.FUN-550029--end--
            #先check是否存在[庫存調撥單單身檔],
            #若不存在,則再check[異動記錄檔](tlf_file)
            IF g_img.img05 IS NOT NULL  AND g_img.img05 !=' ' THEN
               CALL t310_imn01('a') RETURNING l_n
               IF l_n IS NULL OR l_n=0 THEN
                  CALL t310_img05('a')
                  IF NOT cl_null(g_errno) THEN	 		#抱歉, 有問題
                      	CALL cl_err(g_t1,g_errno,0)
                      	NEXT FIELD img05
                  END IF
               END IF
        	END IF
 
        #有傳參數時, 不可輸入調撥日期
{
        BEFORE FIELD img16   #調撥日期
            IF g_argv3 IS NOT NULL AND g_argv3 !=' ' THEN
               IF l_dir='D' THEN
                  NEXT FIELD debit
               ELSE
                  NEXT FIELD adjno
               END IF
            END IF 
}
 
        AFTER FIELD img16   #調撥日期
	   IF g_img.img16 IS NULL THEN LET g_img.img16=g_sma.sma30 END IF
           DISPLAY BY NAME g_img.img16 
         #CHI-690066--begn
	   #IF NOT s_daywk(g_img.img16)    #是否為工作日
	   #   THEN CALL cl_err(g_img.img16,'mfg3152',0)
           #        NEXT FIELD img16
           #END IF
           LET li_result = 0
           CALL s_daywk(g_img.img16) RETURNING li_result
	   IF li_result = 0 THEN #非工作日
              CALL cl_err(g_img.img16,'mfg3152',0)
	      NEXT FIELD img16
	   END IF
	   IF li_result = 2 THEN #未設定
              CALL cl_err(g_img.img16,'mfg3153',0)
	      NEXT FIELD img16
	   END IF
         #CHI-690066--end
           IF g_img.img16 > g_today THEN    #調撥日期不可大於系統日期
              CALL cl_err(g_img.img16,'mfg6115',0)
              NEXT FIELD img16
           END IF

                       
            CALL s_yp(g_img.img16) RETURNING l_year,l_prd
#---->與目前會計年度,期間比較,如日期大於目前會計年度,期間則不可過
            IF (l_year*12+l_prd) > (g_sma.sma51*12+g_sma.sma52) THEN
               CALL cl_err('','mfg6091',0) NEXT FIELD img16
            END IF
	    IF g_sma.sma53 IS NOT NULL AND g_img.img16 <= g_sma.sma53 THEN 
		CALL cl_err('','mfg9999',0) NEXT FIELD img16
	    END IF
            #No.FUN-730033  --Begin
            CALL s_get_bookno(YEAR(g_img.img16)) RETURNING g_flag,g_bookno1,g_bookno2  #TQC-740042
            IF g_flag =  '1' THEN  #抓不到帳別
               CALL cl_err(g_img.img16,'aoo-081',1)
               NEXT FIELD img16 
            END IF
            #No.FUN-730033  --End  
        
        BEFORE FIELD debit
            CALL t310_set_entry(p_cmd)
 
        AFTER FIELD debit   #調整科目
            IF g_img.debit IS NULL THEN
               LET g_img.debit=' ' 
            ELSE
               IF g_sma.sma03='Y' THEN
                  IF NOT s_actchk3(g_img.debit,g_bookno1) THEN  #No.FUN-730033
                     CALL cl_err(g_img.debit,'mfg0018',0)
                     #FUN-B10049--begin
                     CALL cl_init_qry_var()                                         
                     LET g_qryparam.form ="q_aag"                                   
                     LET g_qryparam.default1 = g_img.debit  
                     LET g_qryparam.construct = 'N'                
                     LET g_qryparam.arg1 = g_bookno1  
                     LET g_qryparam.where = " aagacti='Y' AND aag01 LIKE '",g_img.debit CLIPPED,"%' "            
                     CALL cl_create_qry() RETURNING g_img.debit
                     DISPLAY BY NAME g_img.debit  
                     #FUN-B10049--end                         
                     NEXT FIELD debit 
                  END IF
               END IF
            END IF
            LET l_dir='U'
            LET l_dir2='D'
            CALL t310_set_no_entry(p_cmd)
 
        BEFORE FIELD img01
            #有傳參數時,不可輸入
{
            IF g_argv3 IS NOT NULL AND g_argv3 !=' ' THEN
               IF l_dir2='D' THEN
                  NEXT FIELD azf01
               ELSE
                  NEXT FIELD debit
               END IF
            END IF 
}
	        IF g_sma.sma60 = 'Y'		# 若須分段輸入
	          THEN CALL s_inp5(9,14,g_img.img01) RETURNING g_img.img01
	               DISPLAY BY NAME g_img.img01 
                   IF INT_FLAG THEN LET INT_FLAG = 0 END IF
      	    END IF
 
        AFTER FIELD img01 #料件編號
#FUN-AA0059 ---------------------start----------------------------
            IF NOT cl_null(g_img.img01) THEN
               IF NOT s_chk_item_no(g_img.img01,"") THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD img01
               END IF
            END IF
#FUN-AA0059 ---------------------end-------------------------------
{*}         CALL t310_img01()
           	IF NOT cl_null(g_errno) THEN	 		#抱歉, 有問題
               	CALL cl_err(g_img.img01,g_errno,0)
                NEXT FIELD img01
            END IF
 
        AFTER FIELD img02  #倉庫
            IF g_img.img02 IS NOT NULL THEN
               #FUN-D20060--add--str---
               IF NOT s_chksmz(g_img.img01, g_img.adjno,
                               g_img.img02, g_img.img03) THEN
                  NEXT FIELD img02
               END IF
               #FUN-D20060--add--end---
               IF NOT s_stkchk(g_img.img02,'A') THEN
                  CALL cl_err(g_img.img02,'mfg6076',0)
                  NEXT FIELD img02 
               END IF
               #檢查是否存在[庫存資料明細檔]中
               CALL t310_img02()
               IF NOT cl_null(g_errno) THEN 
                  CALL cl_err(g_img.img02,g_errno,0)
                  DISPLAY BY NAME g_img.img02
                  NEXT FIELD img02
               END IF
#No.FUN-AA0062  --start--
               IF NOT s_chk_ware(g_img.img02) THEN
                  NEXT FIELD img02
               END IF
#No.FUN-AA0062  --END--
            END IF
 
        AFTER FIELD img03  #儲位
            IF g_img.img03 IS NULL THEN LET g_img.img03=' ' END IF
           #------------------------------------ 檢查料號預設倉儲及單別預設倉儲
           IF NOT cl_null(g_img.img02) THEN   #FUN-D20060
              IF NOT s_chksmz(g_img.img01, g_img.adjno,
                              g_img.img02, g_img.img03) THEN
                 NEXT FIELD img02
              END IF  #FUN-D20060
           END IF
           #------------------------------------------------------ 970715 roger
            #---->需存存倉庫/儲位檔中
            IF g_img.img03 IS NOT NULL THEN
                CALL s_imfchk(g_img.img01,g_img.img02,g_img.img03)
                    RETURNING g_cnt
                IF NOT g_cnt THEN
                    CALL cl_err(g_img.img03,'mfg1102',0)
                    NEXT FIELD img02
                END IF
                #檢查是否存在[庫存資料明細檔]中
               CALL t310_img03()
               IF NOT cl_null(g_errno) THEN 
                  CALL cl_err(g_img.img03,g_errno,0)
                  DISPLAY BY NAME g_img.img03
                  NEXT FIELD img03
               END IF
            END IF
 
        AFTER FIELD img04  #
            IF g_img.img04 IS NULL THEN LET g_img.img04=' ' END IF
   		    #檢查是否存在[庫存資料明細檔]中
            CALL t310_img04()
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err(g_img.img04,g_errno,0)
               NEXT FIELD img04
            END IF
            #先check是否存在[庫存調撥單單身檔],
            #若不存在,則再check[異動記錄檔](tlf_file)
            IF g_img.img05 IS NOT NULL AND g_img.img05 != ' ' THEN
               CALL t310_imn() RETURNING l_n
               IF l_n IS NULL OR l_n=0 THEN
                  CALL t310_tlf()
                  IF NOT cl_null(g_errno) THEN 
                     CALL cl_err(g_img.img04,g_errno,0)
                     NEXT FIELD img04
                  END IF
               END IF
            END IF
            LET l_dir3='D'
 
        #調撥數量
        BEFORE FIELD img08
            #有傳參數時,不可輸入
{
            IF g_argv3 IS NOT NULL AND g_argv3 !=' ' THEN
               IF l_dir2='D' THEN
                  NEXT FIELD azf01
               ELSE
                  NEXT FIELD debit
               END IF
            END IF 
}
            #有打調撥單號時,調撥數量不可更改
            IF g_img.img05 IS NOT NULL AND g_img.img05 != ' ' 
               AND g_img.img05 != '   -      '
            THEN IF l_dir3='D' THEN
                    NEXT FIELD adjqty
                 ELSE
                    NEXT FIELD img04
                 END IF
            END IF 
 
        AFTER FIELD img08  #調撥數量
            IF g_img.img08 IS NULL OR g_img.img08 <= 0 THEN
                CALL cl_err('','mfg1322',0)
                NEXT FIELD img08
            END IF
 
        BEFORE FIELD adjqty  #調整後數量
{
            IF g_argv3 IS NOT NULL AND g_argv3 !=' ' THEN
               IF l_dir2='D' THEN
                  NEXT FIELD azf01
               ELSE
                  NEXT FIELD debit
               END IF
            END IF 
}
            LET l_dir3='U'
 
        AFTER FIELD adjqty  #調撥數量
            IF g_img.adjqty <= 0 THEN
                CALL cl_err('','mfg1322',0)
                NEXT FIELD adjqty
            END IF
            LET l_dir3='U'
 
        #FUN-CB0087---add---str---
        BEFORE FIELD azf01
            IF g_aza.aza115 = 'Y' AND cl_null(g_img.azf01) THEN 
               CALL s_reason_code(g_img.adjno,g_img.img05,'',g_img.img01,g_img.img02,'','') RETURNING g_img.azf01
               DISPLAY BY NAME g_img.azf01
            END IF
        #FUN-CB0087---end---end---

        AFTER FIELD azf01  #理由
            IF g_img.azf01 IS NOT NULL THEN
               CALL t310_azf01()
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err(g_img.azf01,g_errno,0)
                  NEXT FIELD azf01
               END IF
            END IF
            LET l_dir2='U'
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
            IF g_img.img04 IS NULL THEN LET g_img.img04=' ' END IF
            IF g_img.img03 IS NULL THEN LET g_img.img03=' ' END IF
            IF g_img.img05 IS NULL THEN LET g_img.img05=' ' END IF
            IF g_img.debit IS NULL THEN LET g_img.debit=' ' END IF
            LET g_flag='N'
            IF INT_FLAG THEN
                EXIT INPUT  
            END IF
            IF g_img.img01 IS NULL THEN  #料號
               LET g_flag='Y'
               DISPLAY BY NAME g_img.img01 
            END IF    
            IF g_img.adjqty IS NULL OR g_img.adjqty = ' ' THEN 
               LET g_flag='Y'
               DISPLAY BY NAME g_img.adjqty 
            END IF    
            IF g_flag='Y' THEN    
                 CALL cl_err('','9033',0)
                 NEXT FIELD adjno
            END IF
            #FUN-CB0087--qiull--str--
            IF g_aza.aza115='Y' THEN
               IF NOT cl_null(g_img.azf01) THEN
                  CALL t310_azf01()
                  IF NOT cl_null(g_errno)  THEN
                     CALL cl_err(g_img.azf01,g_errno,0)
                     NEXT FIELD azf01
                  END IF
               END IF
            END IF
            #FUN-CB0087--qiull--end--
 
        ON ACTION controlp                                                      
           CASE                                                                 
              WHEN INFIELD(adjno) #查詢單                                       
{
#                LET g_t1=g_img.adjno[1,3]                                      
                 LET g_t1=s_get_doc_no(g_img.adjno)   #No.FUN-550029
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form     = "q_smy"                              
                 LET g_qryparam.default1 = g_t1                                 
                 LET g_qryparam.arg1     = "7"                                  
                 LET g_qryparam.arg2     = "aim"                                
                 CALL cl_create_qry() RETURNING g_t1                            
#                 CALL FGL_DIALOG_SETBUFFER( g_t1 )
#                LET g_img.adjno[1,3]=g_t1                                      
                 LET g_img.adjno=g_t1    #No.FUN-550029
                 DISPLAY BY NAME g_img.adjno                                    
                 NEXT FIELD adjno                                               
}
#               LET g_t1=g_img.adjno[1,3]
                LET g_t1=s_get_doc_no(g_img.adjno)   #No.FUN-550029
                LET g_chr='7'
                LET g_qryparam.state = "c"
                CALL q_smy(FALSE,FALSE,g_t1,'AIM',g_chr) #TQC-670016
                RETURNING g_t1
#                CALL FGL_DIALOG_SETBUFFER( g_t1 )
#               LET g_img.adjno[1,3]=g_t1                                        
                LET g_img.adjno=g_t1    #No.FUN-550029
                DISPLAY BY NAME g_img.adjno                                    
                NEXT FIELD adjno                                               
 
              WHEN INFIELD(img05) #撥出單號                                     
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form     = "q_imm"                              
                 LET g_qryparam.default1 = '2'                                  
                 CALL cl_create_qry() RETURNING g_img.img05                     
#                 CALL FGL_DIALOG_SETBUFFER( g_img.img05 )
                 DISPLAY BY NAME g_img.img05                                    
                 NEXT FIELD img05                                               
              WHEN INFIELD(img01) #料件編號                                     
#FUN-AA0059 --Begin--
             #    CALL cl_init_qry_var()                                         
             #    LET g_qryparam.form     = "q_ima" 
             #    LET g_qryparam.default1 = g_img.img01                          
             #    CALL cl_create_qry() RETURNING g_img.img01                     
                  CALL q_sel_ima(FALSE, "q_ima", "",g_img.img01, "", "", "", "" ,"",'' )  RETURNING g_img.img01
#FUN-AA0059 --End--
#                 CALL FGL_DIALOG_SETBUFFER( g_img.img01 )
                 DISPLAY BY NAME g_img.img01                                    
                 NEXT FIELD img01                                               
              WHEN INFIELD(debit)  #會計科目                                    
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form     ="q_aag"                               
                 LET g_qryparam.default1 = g_img.debit                          
                 LET g_qryparam.arg1 = g_bookno1  #No.FUN-730033
                 CALL cl_create_qry() RETURNING g_img.debit                     
#                 CALL FGL_DIALOG_SETBUFFER( g_img.debit )
                 DISPLAY BY NAME g_img.debit                                    
                 NEXT FIELD debit                                               
              WHEN INFIELD(azf01) #理由  
                 #FUN-CB0087---add---str---         
                 CALL s_get_where(g_img.adjno,g_img.img05,'',g_img.img01,g_img.img02,'','') RETURNING l_flag,l_where
                 IF l_flag AND g_aza.aza115 = 'Y' THEN 
                    CALL cl_init_qry_var()
                    LET g_qryparam.form     ="q_ggc08"
                    LET g_qryparam.where = l_where
                    LET g_qryparam.default1 = g_img.azf01
                 ELSE
                 #FUN-CB0087---add---end---
                    CALL cl_init_qry_var()                                         
                    #LET g_qryparam.form     ="q_azf"       #FUN-920186   
                    LET g_qryparam.form     ="q_azf01a"     #FUN-920186                       
                    LET g_qryparam.default1 = g_img.azf01                          
                    #LET g_qryparam.arg1     = "2"          #FUN-920186 
                    LET g_qryparam.arg1     = "6"           #FUN-920186                       
                    #LET g_qryparam.arg2     = g_img.azf01       
                 END IF                                         #FUN-CB0087 add                   
                 CALL cl_create_qry() RETURNING g_img.azf01                     
#                 CALL FGL_DIALOG_SETBUFFER( g_img.azf01 )
                 DISPLAY BY NAME g_img.azf01                                    
                 NEXT FIELD azf01                                                
              WHEN INFIELD(img02) #倉庫                                         
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_img1"    
                # LET g_qryparam.default1 = g_img.img01  #No.FUN-AA0062 mark                        
                 LET g_qryparam.default1 = g_img.img02   #No.FUN-AA0062  add                      
                 LET g_qryparam.default2 = g_img.img03   #No.FUN-AA0062  add                      
                 LET g_qryparam.default3 = g_img.img04   #No.FUN-AA0062  add                      
                # LET g_qryparam.arg1     = "A"          #No.FUN-AA0062 mark                                
                 LET g_qryparam.arg1     = g_img.img01   #No.FUN-AA0062 add                               
                 CALL cl_create_qry() RETURNING l_img02,l_img03,l_img04         
#                 CALL FGL_DIALOG_SETBUFFER( l_img02 )
#                 CALL FGL_DIALOG_SETBUFFER( l_img03 )
#                 CALL FGL_DIALOG_SETBUFFER( l_img04 )
                 IF l_img02 IS NOT NULL AND l_img02 !=' ' THEN                  
                    LET g_img.img02=l_img02                                     
                    LET g_img.img03=l_img03                                     
                    LET g_img.img04=l_img04                                     
                 END IF                                                         
                 DISPLAY BY NAME g_img.img02,g_img.img03,g_img.img04            
                 NEXT FIELD img02                                               
               WHEN INFIELD(img03) #儲位                                        
                  CALL cl_init_qry_var()                                        
                  LET g_qryparam.form     = "q_img1"                            
                  LET g_qryparam.default1 = l_img02                             
                  LET g_qryparam.default2 = l_img03                             
                  LET g_qryparam.default3 = l_img04                             
                 # LET g_qryparam.arg1     = "A"         #No.FUN-AA0062 mark                                
                 # LET g_qryparam.arg2     = g_img.img01 #No.FUN-AA0062 mark                        
                 # LET g_qryparam.arg3     = g_img.img02 #No.FUN-AA0062 mark                        
                  LET g_qryparam.arg1     = g_img.img01  #No.FUN-AA0062 add
                  CALL cl_create_qry() RETURNING l_img02,l_img03,l_img04        
#                  CALL FGL_DIALOG_SETBUFFER( l_img02 )
#                  CALL FGL_DIALOG_SETBUFFER( l_img03 )
#                  CALL FGL_DIALOG_SETBUFFER( l_img04 )
                  IF l_img03 IS NOT NULL AND l_img03 !=' ' THEN                 
                     LET g_img.img03=l_img03                                    
                     LET g_img.img04=l_img04  
                  END IF                                                        
                  DISPLAY BY NAME g_img.img02,g_img.img03,g_img.img04           
                  NEXT FIELD img03                                              
               WHEN INFIELD(img04) #LOTS                                        
                  CALL cl_init_qry_var()                                        
                  LET g_qryparam.form     ="q_img1"                             
                  LET g_qryparam.default1 = l_img02                             
                  LET g_qryparam.default2 = l_img03                             
                  LET g_qryparam.default3 = l_img04                             
                 # LET g_qryparam.arg1     = "A"         #No.FUN-AA0062 mark
                 # LET g_qryparam.arg2     = g_img.img01 #No.FUN-AA0062 mark
                 # LET g_qryparam.arg3     = g_img.img02 #No.FUN-AA0062 mark
                   LET g_qryparam.arg1     = g_img.img01  #No.FUN-AA0062 add
                   CALL cl_create_qry() RETURNING l_img02,l_img03,l_img04        
#                  CALL FGL_DIALOG_SETBUFFER( l_img02 )
#                  CALL FGL_DIALOG_SETBUFFER( l_img03 )
#                  CALL FGL_DIALOG_SETBUFFER( l_img04 )
                  IF l_img04 IS NOT NULL AND l_img04 !=' ' THEN                 
                     LET g_img.img04=l_img04                                    
                  END IF                                                        
                  NEXT FIELD img04                                              
               OTHERWISE EXIT CASE                                              
            END CASE            
 
        ON ACTION mntn_reason #理由
                CALL cl_cmdrun("aooi301")   #6818
 
 
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
 
      #ON ACTION exit
      #   LET g_action_choice = "exit"
      #   LET INT_FLAG = 1
      #   EXIT INPUT
    END INPUT
END FUNCTION
 
FUNCTION t310_set_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN 
       CALL cl_set_comp_entry("npx01",TRUE)
    END IF 
 
END FUNCTION
 
FUNCTION t310_set_no_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
  DEFINE l_dir   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
  IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN 
     CALL cl_set_comp_entry("npx01",FALSE) 
  END IF 
 
  IF INFIELD(adjno) OR (NOT g_before_input_done) THEN
    IF g_argv3 IS NOT NULL AND g_argv3 !=' ' THEN                               
       IF l_dir='D' THEN 
          CALL cl_set_comp_entry("img05,img16",FALSE)
       END IF
    END IF
  END IF
 
  IF INFIELD(img01) OR (NOT g_before_input_done) THEN 
    IF g_argv3 IS NOT NULL AND g_argv3 !=' ' THEN 
       IF l_dir='D' THEN                                                        
          CALL cl_set_comp_entry("img01,img02,img03,img04,img09,img08,adjqty",FALSE)       
       END IF                                                                   
    END IF  
  END IF
 
END FUNCTION
#check [庫存調撥單單身檔]-------------------------
FUNCTION t310_imn01(p_cmd)  #調撥單號
    DEFINE p_cmd    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_n      LIKE type_file.num5,    #No.FUN-690026 SMALLINT
           l_imn10  LIKE imn_file.imn10,
           l_imn11  LIKE imn_file.imn11
 
    LET g_errno = ' '
    LET l_n=0
    LET g_sql="SELECT imn03,imn04,imn05,imn06,imn09,", 
              " imn10,imn11,imm10 ",
              "  FROM imn_file,imm_file ",          # 組合出 SQL 指令
              " WHERE imm01=imn01 AND imm10 != '3' ",
              "   AND imn01='",g_img.img05,"' ",
              "   AND imn12 IN ('Y','y') ",
              "   AND imn24 IN ('Y','y') ",
              "   AND immacti = 'Y' " #mandy
 
    PREPARE t310_imnp FROM g_sql                # RUNTIME 編譯
    DECLARE t310_imn SCROLL CURSOR WITH HOLD FOR t310_imnp
    FOREACH t310_imn INTO g_img.img01,g_img.img02,g_img.img03,
                          g_img.img04,g_img.img09,l_imn10,l_imn11,
                          g_imm10
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            LET g_imm10 =' '
            EXIT FOREACH
        END IF
        LET l_n=1
        IF g_imm10 = '1'  
        THEN LET g_img.img08 = l_imn10    #--->一階段調撥 
        ELSE LET g_img.img08 = l_imn11    #--->二階段調撥
        END IF
        EXIT FOREACH
    END FOREACH
    DISPLAY BY NAME  g_img.img01,g_img.img02,g_img.img03,g_img.img04,
                     g_img.img09,g_img.img08 
    RETURN l_n
END FUNCTION
   
FUNCTION t310_img05(p_cmd)  #調撥單號
    DEFINE p_cmd    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_n      LIKE type_file.num5,    #No.FUN-690026 SMALLINT
           l_sql    LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(300)
 
    LET g_errno = ' '
    LET l_n=''
    LET l_sql="SELECT tlf01,tlf021,tlf022,tlf023,tlf025,tlf10,rowid ",
              "  FROM tlf_file ",          # 組合出 SQL 指令
              " WHERE tlf036='",g_img.img05,"' "
    PREPARE t310_tlfp FROM l_sql                # RUNTIME 編譯
    DECLARE t310_tlf SCROLL CURSOR FOR t310_tlfp
    FOREACH t310_tlf INTO g_img.img01,g_img.img02,g_img.img03,
                          g_img.img04,g_img.img09,g_img.img08,g_tlf_rowid
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET l_n=1
        EXIT FOREACH
    END FOREACH
    IF SQLCA.sqlcode OR l_n IS NULL OR l_n=0 THEN
       LET g_errno = 'mfg6114'
    END IF
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY BY NAME  g_img.img01,g_img.img02,g_img.img03,g_img.img04,
                       g_img.img09,g_img.img08 
    END IF
END FUNCTION
 
#---------------------------------------------------------------
FUNCTION t310_img01() {*}
DEFINE
    l_ima02 LIKE ima_file.ima02,    #品名規格
    l_ima05 LIKE ima_file.ima05,    #目前版本
    l_ima08 LIKE ima_file.ima08,    #來源碼
    l_imaacti LIKE ima_file.imaacti #有效碼
 
    LET g_errno = ' '
    SELECT   ima02,  ima05,  ima08, imaacti #FUN-560183 del ima86
      INTO l_ima02,l_ima05,l_ima08, l_imaacti  #FUN-560183 del g_ima86
      FROM ima_file 
     WHERE ima01=g_img.img01 
    CASE WHEN SQLCA.SQLCODE 
              LET g_errno = 'mfg0002'
              LET l_ima02 =' '  LET l_ima05 = ' '
              LET l_ima08 =' ' #LET g_ima86 = ' ' #FUN-560183
         WHEN l_imaacti='N' LET g_errno = '9028'
     #FUN-690022------mod-------
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
     #FUN-690022------mod-------
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    DISPLAY l_ima02 TO FORMONLY.ima02 
    DISPLAY l_ima05 TO FORMONLY.ima05 
    DISPLAY l_ima08 TO FORMONLY.ima08 
END FUNCTION
   
FUNCTION t310_azf01()   #理由碼
DEFINE
    l_azf03   LIKE azf_file.azf03,     #說明內容
    l_azf02   LIKE azf_file.azf02,     #說明內容
    l_azf09   LIKE azf_file.azf09,     #FUN-920186
    l_azf09_mark   LIKE azf_file.azf09,#FUN-920186
    l_azfacti LIKE azf_file.azfacti,
    l_n       LIKE type_file.num5,    #FUN-CB0087
    l_sql     STRING,                 #FUN-CB0087
    l_where   STRING,                 #FUN-CB0087          
    l_flag    LIKE type_file.chr1     #FUN-CB0087 
 
    #FUN-CB0087--add--str--
    LET l_n = 0 
    LET g_errno = ' '   #FUN-CB0087
    CALL s_get_where(g_img.adjno,g_img.img05,'',g_img.img01,g_img.img02,'','') RETURNING l_flag,l_where       
    IF g_aza.aza115='Y' AND l_flag THEN 
       LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_img.azf01,"' AND ",l_where
       PREPARE ggc08_pre FROM l_sql
       EXECUTE ggc08_pre INTO l_n 
       IF l_n < 1 THEN 
          LET g_errno = 'aim-425'
       ELSE
          SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01=g_img.azf01 AND azf02='2'
       END IF
    ELSE
    #FUN-CB0087--add--end--
      #LET g_errno = ' '   #FUN-CB0087
       IF g_img.azf01 IS NULL THEN RETURN END IF
       LET l_azf03=' '
       LET g_chr=' '
       #SELECT azf03,azfacti INTO l_azf03,l_azfacti       #FUN-920186
       SELECT azf09,azf03,azfacti INTO l_azf09,l_azf03,l_azfacti    #FUN-920186
         FROM azf_file
        WHERE azf01=g_img.azf01 AND azf02='2' 
       CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg3088'
                               LET l_azf03 =  NULL
            WHEN l_azfacti='N' LET g_errno = '9028'
            WHEN l_azf09 != '6' LET g_errno = 'aoo-405'      #FUN-920186
            OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE
   
    END IF  #FUN-CB0087
    DISPLAY l_azf03 TO azf03 
END FUNCTION
   
FUNCTION t310_img02()  #倉庫編號
    DEFINE p_cmd   LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
	   l_n     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
           l_img22 LIKE img_file.img22 
 
    LET g_errno = ' '
	LET l_n=''
    SELECT COUNT(*) INTO l_n
           FROM img_file WHERE img01 = g_img.img01 AND img02=g_img.img02
    CASE WHEN SQLCA.SQLCODE = 100 OR l_n IS NULL OR l_n =0
							LET g_errno = 'mfg6067'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
   
FUNCTION t310_img03()  
    DEFINE p_cmd   LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
	   l_n     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
           l_img22 LIKE img_file.img22 
 
    LET g_errno = ' '
	LET l_n=''
    SELECT COUNT(*) INTO l_n
           FROM img_file WHERE img01 = g_img.img01 AND img02=g_img.img02
                               AND img03=g_img.img03
    CASE WHEN SQLCA.SQLCODE = 100 OR l_n IS NULL OR l_n =0
							LET g_errno = 'mfg6068'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
   
FUNCTION t310_img04()  
    DEFINE p_cmd   LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
	   l_n     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
           l_img22 LIKE img_file.img22 
 
    LET g_errno = ' '
	LET l_n=''
    SELECT img09,img21,img23,img24,img10,img19,img36,img26
      INTO g_img.img09,g_img21,g_img23,g_img24,g_img10,
           g_img.img19,g_img.img36,g_img26
      FROM img_file WHERE img01 = g_img.img01 AND img02=g_img.img02
                          AND img03=g_img.img03 AND img04=g_img.img04
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg6069'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    DISPLAY BY NAME g_img.img09,g_img.img19,g_img.img36 
END FUNCTION
   
FUNCTION t310_imn()    #批號
    DEFINE p_cmd   LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
	   l_n     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
	   l_sw    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
           l_img22 LIKE img_file.img22 
 
    LET g_errno = ' '
	LET l_n=''
    LET l_sw=1    #表存在
    #檢查此調撥單號是否存在[庫存調撥單單身檔]中 ( 註: 此倉庫/儲位/批號,
    #只要存在來源 或 目的 的資料中即可 )
    #來源
    SELECT COUNT(*) INTO l_n
      FROM imn_file 
      WHERE imn01 = g_img.img05 AND imn03=g_img.img01
            AND imn04=g_img.img02 AND imn05= g_img.img03
            AND imn06=g_img.img04
    IF SQLCA.sqlcode OR l_n IS NULL OR l_n=0 THEN
       #目的
	   LET l_n=''
       SELECT COUNT(*) INTO l_n
         FROM imn_file 
         WHERE imn01 = g_img.img05 AND imn03=g_img.img01
               AND imn15=g_img.img02 AND imn16= g_img.img03
               AND imn17=g_img.img04
       IF SQLCA.sqlcode OR l_n IS NULL OR l_n=0 THEN
           LET l_sw=0
       ELSE
           LET l_sw=1
       END IF
    END IF
    RETURN l_sw
END FUNCTION
     
#檢查[異動記錄檔] 中有無此資料 ---------------------------  
FUNCTION t310_tlf()    #批號
    DEFINE p_cmd   LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
	   l_n     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
           l_img22 LIKE img_file.img22 
 
    LET g_errno = ' '
	LET l_n=''
    #檢查此調撥單號是否有此倉庫/儲位/批號,( 註: 此倉庫/儲位/批號,
    #只要存在來源 或 目的 的資料中即可 )
    #來源
    SELECT COUNT(*) INTO l_n
      FROM tlf_file 
      WHERE tlf036 = g_img.img05 AND tlf01=g_img.img01
            AND tlf021=g_img.img02 AND tlf022= g_img.img03
            AND tlf023=g_img.img04
    IF SQLCA.sqlcode OR l_n IS NULL OR l_n=0 THEN
       #目的
       LET g_errno = ' '
       LET l_n=''
       SELECT COUNT(*) INTO l_n
         FROM tlf_file 
         WHERE tlf036 = g_img.img05 AND tlf01=g_img.img01
               AND tlf031=g_img.img02 AND tlf032= g_img.img03
               AND tlf033=g_img.img04
       CASE WHEN SQLCA.SQLCODE = 100 OR l_n IS NULL OR l_n=0
                               LET g_errno = 'mfg6116'
            OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE
    END IF
END FUNCTION
     
#--------------------------------------------------------------------
#更新相關的檔案
FUNCTION t310_t()
DEFINE
    l_qty   LIKE img_file.img10, 
    l_code  LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    IF g_img.img04 IS NULL THEN LET g_img.img04=' ' END IF
    IF g_img.img03 IS NULL THEN LET g_img.img03=' ' END IF
 
#---->如果 g_diff 為正值,則表示多撥出去,其庫存量應加回
#     反之 g_diff 為負值,則表示少撥出去,其庫存量應再扣
#     g_diff = 撥出量-實際撥入量
 
    LET g_diff= g_img.img08 - g_img.adjqty   #需調整的數量
    IF g_img21 IS NULL THEN LET g_img21=1 END IF
    LET l_qty=g_diff * g_img21               #需調整數量 * 轉換率
#------------------>更新料件主檔<------------------------------------------
       IF g_img23 MATCHES '[Yy]' THEN            #可用倉
            IF g_img24 MATCHES '[Yy]'     #mps/mrp 可用
     {ckp#1}    THEN UPDATE   ima_file SET
#                        ima26=ima26+l_qty,  #No.FUN-A40023 #MPS/MRP可用數量{l_qty--->+/-}
#                        ima262=ima262+l_qty,#No.FUN-A40023   #可用庫存數量
                        ima29=g_img.img16  #異動日期
                    WHERE ima01=g_img.img01
                    IF SQLCA.sqlcode THEN
                       LET g_success='N' 
#                      CALL cl_err('(t310_t:ckp#1)',SQLCA.sqlcode,1)
                       CALL cl_err3("upd","ima_file",g_img.img01,"",
                                     sqlca.sqlcode,"","(t310_t:ckp#1)",1)   #NO.FUN-640266 #No.FUN-660156
                       RETURN
                    END IF
            ELSE
      {ckp#2}       UPDATE   ima_file SET  #mps/mrp 不可用
#                        ima262=ima262+l_qty,#No.FUN-A40023   #可用庫存數量{l_qty---->+/-}
                        ima29=g_img.img16  #異動日期
                    WHERE ima01=g_img.img01
                    IF SQLCA.sqlcode THEN
                       LET g_success='N' 
#                      CALL cl_err('(t310_t:ckp#2)',SQLCA.sqlcode,1)
                       CALL cl_err3("upd","ima_file",g_img.img01,"",
                                     sqlca.sqlcode,"","(t310_t:ckp#2)",1)   #NO.FUN-640266 #No.FUN-660156
                       RETURN
                    END IF
            END IF
        ELSE
  {ckp#3}   UPDATE   ima_file SET         #不可用倉
#                ima261=ima261+l_qty,#No.FUN-A40023  #不可用庫存數量{1_qty--->+/-}
                ima29=g_img.img16  #異動日期
            WHERE ima01=g_img.img01
            IF SQLCA.sqlcode THEN
               LET g_success='N' 
#              CALL cl_err('(t310_t:ckp#3)',SQLCA.sqlcode,1)
               CALL cl_err3("upd","ima_file",g_img.img01,"",sqlca.sqlcode,
                            "","(t310_t:ckp#3)",1)   #NO.FUN-640266 #No.FUN-660156
               RETURN
            END IF
        END IF
#---------------------->更新 [庫存明細檔] <-------------------------
  {ckp#4} UPDATE img_file
           SET img10=img10 + g_diff, {g_diff--->+/-}
               img17=g_img.img16
         WHERE img01 = g_img.img01 AND img02 = g_img.img02 AND img03 = g_img.img03 AND img04 = g_img.img04
        IF SQLCA.sqlcode THEN
           LET g_success='N' 
#          CALL cl_err('(t310_t:ckp#4)',SQLCA.sqlcode,1)
           CALL cl_err3("upd","img_file",g_img.img01,"",sqlca.sqlcode,
                        "","(t310_t:ckp#4)",1)   #NO.FUN-640266 #No.FUN-660156
           RETURN
        END IF
#---------------------->更新 [料件統計檔] <-------------------------
#                      (單位為主檔之庫存單位)
     CALL s_delimg(g_img.img01,g_img.img02,g_img.img03,g_img.img04) #FUN-8C0084
 
    
    CALL t310_log(1,0,'',g_img.img01)
END FUNCTION
 
#--------------------------------------------------------------------
#處理異動記錄
FUNCTION t310_log(p_stdc,p_reason,p_code,p_item)
DEFINE
    p_stdc          LIKE type_file.num5,   #是否需取得標準成本  #No.FUN-690026 SMALLINT
    p_reason        LIKE type_file.num5,   #是否需取得異動原因  #No.FUN-690026 SMALLINT
    p_code          LIKE type_file.chr20,  #No.FUN-690026 VARCHAR(04),
    p_item          LIKE ima_file.ima01,   #No.FUN-690026 VARCHAR(20),
    l_qty           LIKE tlf_file.tlf024 
 
#----來源----
#-----modify by pin 1992/05/25
    IF g_img.img04 IS NULL THEN LET g_img.img04=' ' END IF
    IF g_img.img03 IS NULL THEN LET g_img.img03=' ' END IF
    IF g_imm10 IS NULL OR g_imm10 = ' '
    THEN SELECT imm10 INTO g_imm10 FROM imm_file 
                     WHERE imm01 =g_img.img05
    END IF
    #-----modify by apple 1993/12/06所有異動量不為負值
    IF g_diff < 0 
    THEN LET l_qty      =g_diff * -1
 
         #--->來源(盤虧)
         LET g_tlf.tlf02=50        	           #資料來源為倉庫(盤虧)
         LET g_tlf.tlf020=g_plant              #工廠別
         LET g_tlf.tlf021=g_img.img02          #倉庫別
         LET g_tlf.tlf022=g_img.img03	       #儲位別
         LET g_tlf.tlf023=g_img.img04	       #批號
         LET g_tlf.tlf024=g_img10+g_diff {+/-} #異動後庫存數量
      	 LET g_tlf.tlf025=g_img.img09          #庫存單位(ima or img)
	 LET g_tlf.tlf026=g_img.adjno          #調整單號
      	 LET g_tlf.tlf027=''
 
         #--->目的(盤虧)
         LET g_tlf.tlf03=0         	           #資料目的為調整
         LET g_tlf.tlf030=g_plant              #工廠別
         LET g_tlf.tlf031=' '                  #倉庫別
         LET g_tlf.tlf032=' '                  #儲位別
         LET g_tlf.tlf033=' '                  #入庫批號
         LET g_tlf.tlf034=''                   #異動後庫存量
         LET g_tlf.tlf035=''                   #庫存單位(ima or img)
         LET g_tlf.tlf036=g_img.img05          #參考號碼(撥出單號)
     	 LET g_tlf.tlf037=''                   #項次      
 
         LET g_tlf.tlf15=g_img.debit           #借方會計科目(調撥調整)
         LET g_tlf.tlf16=g_img26               #貸方會計科目(存貨)
    ELSE LET l_qty      =g_diff
 
         #--->來源(盤盈)
         LET g_tlf.tlf02=0        	        #資料來源為調整(盤盈)
         LET g_tlf.tlf020=g_plant              #工廠別
         LET g_tlf.tlf021=''                   #倉庫別
         LET g_tlf.tlf022=''         	       #儲位別
         LET g_tlf.tlf023=''                   #批號
         LET g_tlf.tlf024=''                   #異動後庫存數量
       	 LET g_tlf.tlf025=''                   #庫存單位(ima or img)
         LET g_tlf.tlf026=g_img.img05          #參考號碼(撥出單號)
      	 LET g_tlf.tlf027=''
 
         #--->目的
         LET g_tlf.tlf03=50        	       #資料目的為倉庫
         LET g_tlf.tlf030=g_plant              #工廠別
         LET g_tlf.tlf031=g_img.img02          #倉庫別
         LET g_tlf.tlf032=g_img.img03          #儲位別
         LET g_tlf.tlf033=g_img.img04          #入庫批號
         LET g_tlf.tlf034=g_img10+g_diff {+/-} #異動後庫存數量
         LET g_tlf.tlf035=g_img.img09          #庫存單位(ima or img)
         LET g_tlf.tlf036=g_img.adjno          #調整單號
     	 LET g_tlf.tlf037=''                   #項次      
 
         LET g_tlf.tlf15=g_img26               #借方會計科目(存貨)
         LET g_tlf.tlf16=g_img.debit           #貸方會計科目(調撥調整)
    END IF
 
    LET g_tlf.tlf01 =g_img.img01 	       #異動料件編號
#--->異動數量
    LET g_tlf.tlf04=' '                    #工作站
    LET g_tlf.tlf05=' '                    #作業序號
    LET g_tlf.tlf06=g_img.img16            #調整日期
	LET g_tlf.tlf07=g_today                #異動資料產生日期  
	LET g_tlf.tlf08=TIME                   #異動資料產生時:分:秒
	LET g_tlf.tlf09=g_user                 #產生人
	LET g_tlf.tlf10=l_qty                  #異動數量
	LET g_tlf.tlf11=g_img.img09            #撥出單位
	LET g_tlf.tlf12=1                      #撥出/撥入庫存轉換率
    IF g_imm10 = '1' THEN 
       LET g_tlf.tlf13='aimt3101'          #異動命令代號(單階段)
    ELSE 
       LET g_tlf.tlf13='aimt3102'          #異動命令代號(兩階段)
    END IF
	LET g_tlf.tlf14=g_img.azf01            #異動原因
	LET g_tlf.tlf17=' '                    #非庫存性料件編號
    CALL s_imaQOH(g_img.img01)
         RETURNING g_tlf.tlf18             #異動後總庫存量
	LET g_tlf.tlf19= ' '                   #異動廠商/客戶編號
	LET g_tlf.tlf20= ''                    #project no.      
   #LET g_tlf.tlf61= g_ima86 #FUN-560183
    CALL s_tlf(p_stdc,p_reason)
END FUNCTION
