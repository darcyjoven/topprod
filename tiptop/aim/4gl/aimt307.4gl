# Prog. Version..: '5.30.06-13.03.22(00010)'     #
#
# Pattern name...: aimt307.4gl
# Descriptions...: 週期盤點作業
# Date & Author..: 91/11/02 By Carol
# Modify ........: 92/06/04 By Wu
# Modify ........: 92/09/29 By David img36
#--------------------------------------------------------------------------
# 1992/10/17(pin): 倉庫與儲位檢查方式與所提供之功能完全依照參數來決定
#                  與按協理(1992/10/05)所說來修改凡屬收至倉庫之所有程式
#--------------------------------------------------------------------------
# 1993/12/06(Apple):盤盈虧(異動數量)不再有負值狀況因此,會計科目,來源狀況
#                   目的狀況皆依據盤盈虧有所變動
#--------------------------------------------------------------------------
# Modify.........: MOD-4A0252 04/10/26 By Smapmin 儲位開窗
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式
# Modify.........: No.FUN-550029 05/05/30 By vivien 單據編號格式放大
# Modify.........: No.FUN-560183 05/06/22 By kim 移除ima86成本單位
# Modify.........: No.FUN-570249 05/08/02 By Carrier 多單位內容修改
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.TQC-670008 06/07/05 By kim 將 g_sys 變數改成寫死系統別(要大寫)
# Modify.........: No.FUN-670093 06/07/27 By kim GP3.5 利潤中心
# Modify.........: No.FUN-690026 06/09/12 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.CHI-690066 06/12/13 By rainy CALL s_daywk() 改判斷非工作日/工作日/無設定 
# Modify.........: No.CHI-6A0015 06/12/19 By rainy 輸入料號後帶出預設倉庫/儲位
# Modify.........: No.FUN-730033 07/03/21 By Carrier 會計科目加帳套
# Modify.........: No.TQC-740042 07/04/09 By bnlent 用年度取帳套
# Modify.........: No.TQC-750018 07/05/04 By rainy 更改狀態無更改料號時，不重帶倉庫儲位
# Modify.........: No.TQC-750014 07/08/15 By pengu 庫存轉換率異常
# Modify.........: No.FUN-8C0084 08/12/22 By jan s_upimg相關改以 料倉儲批為參數傳入 ,不使用 ROWID
# Modify.........: No.TQC-930155 09/03/30 By Sunyanchun Lock img_file,imgg_file時，若報錯，不要rollback ，要放g_success ='N' 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Moidfy.........: No:TQC-9A0126 09/10/26 By liuxqa 修改ROWID
# Modify.........: No.FUN-A40023 10/03/22 By dxfwo ima26x维护
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No.FUN-AA0049 10/10/21 by destiny  增加倉庫的權限控管
# Modify.........: No.FUN-AA0059 10/10/29 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No.FUN-AA0059 10/10/29 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No.FUN-B10049 11/01/20 By destiny 科目查詢自動過濾
# Modify.........: No.FUN-B80070 11/08/08 By fanbj FOR UPDATE 下一行調用cl_forupd_sql 函式
# Modify.........: No:FUN-C80107 12/09/18 By suncx 增可按倉庫進行負庫存判斷
# Modify.........: No:FUN-CB0087 12/12/06 By qiull 庫存單據理由碼改善
# Modify.........: No.FUN-D20060 13/02/22 By chenying 設限倉庫控卡
# Modify.........: No.TQC-D20042 13/02/25 By qiull 修改理由碼改善測試問題
# Modify.........: No.FUN-D30024 13/03/12 By qiull 負庫存依據imd23判斷
# Modify.........: No.FUN-D40103 13/05/07 By fengrui 添加庫位有效性檢查;抓ime_file資料添加imeacti='Y'條件
# Modify.........: No.TQC-D50124 13/05/28 By lixiang 修正FUN-D40103部份邏輯控管
# Modify.........: No:TQC-D40078 13/04/28 By xujing 負庫存函数添加营运中心参数 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_chlang     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_t1         LIKE smy_file.smyslip, #No.FUN-550029 #No.FUN-690026 VARCHAR(5)
       g_before_input_done LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       g_sql        string,                 #No.FUN-580092 HCN
       g_img01_t    LIKE img_file.img01, 
       g_desc       LIKE ze_file.ze03,      #No.FUN-690026 VARCHAR(25)
       sn1,sn2      LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       g_status     LIKE type_file.chr1,    #{0,1,2}  #No.FUN-690026 VARCHAR(1)
       l_year,l_prd LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       h_qty        LIKE ima_file.ima271,
       tno          LIKE tlf_file.tlf026,   #No.FUN-550029 #No.FUN-690026 VARCHAR(16)
       tno_seq      LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       g_imf05      LIKE imf_file.imf05,
#       g_ima26      LIKE ima_file.ima26,    #No.FUN-A40023    #會計科目
       g_ima25      LIKE ima_file.ima25,        #主檔庫存單位
       g_ima25_fac  LIKE img_file.img20,        #庫存單位對主檔庫存單位轉換率
       g_img19      LIKE ima_file.ima271,       #CLASS
       g_img23      LIKE img_file.img23,        #是否為可用倉儲
       g_img24      LIKE img_file.img24,        #是否為MRP可用倉儲
       g_img21      LIKE img_file.img21,        #庫存單位對料件庫存單位轉換率
       g_img        RECORD 
                    img14     LIKE img_file.img14, #盤點日期
                    credit    LIKE img_file.img26, #借方會計科目
                    dept      LIKE gem_file.gem10, #FUN-670093
                    img01     LIKE img_file.img01, #料件編號
                    img02     LIKE img_file.img02, #倉庫
                    img03     LIKE img_file.img03, #儲位
                    img04     LIKE img_file.img04, #存放批號
                    img09     LIKE img_file.img09, #庫存單位
                    img19     LIKE img_file.img19, #Class   
                    img36     LIKE img_file.img36, #
                    img10     LIKE img_file.img10, #庫存數量
                    img08     LIKE img_file.img08, #盤點數量
                    img26     LIKE img_file.img26, #倉儲所用之會計科目
                    diff      LIKE img_file.img10, #MOD-530179       #盤盈虧數量
                    reason    LIKE azf_file.azf01,                   #FUN-CB0087
                    azf03     LIKE azf_file.azf03,                   #FUN-CB0087
                    aqty      LIKE img_file.img10, #可用數量
                    img09_fac LIKE img_file.img20, #收料對庫存單位專換率
                    ima39     LIKE ima_file.ima39,
                    ima25_fac LIKE ima_file.ima63_fac,
                    ima25     LIKE ima_file.ima25,
                   #ima86_fac LIKE ima_file.ima86_fac, #FUN-560183
                   #ima86     LIKE ima_file.ima86,     #FUN-560183
                    img27     LIKE img_file.img27,
                    img28     LIKE img_file.img28,
                    img35     LIKE img_file.img35,
                    img35_2   LIKE img_file.img35
                    END RECORD,
       g_ima906     LIKE ima_file.ima906,  #No.FUN-570249 
       t_img02      LIKE img_file.img02, #倉庫
       t_img03      LIKE img_file.img03  #儲位
 
DEFINE g_bookno1    LIKE aza_file.aza81   #No.FUN-730033
DEFINE g_bookno2    LIKE aza_file.aza82   #No.FUN-730033
DEFINE g_flag       LIKE type_file.chr1   #No.FUN-730033
DEFINE p_row,p_col     LIKE type_file.num5    #No.FUN-690026 SMALLINT
#--------------------------------------------------------------------
DEFINE g_forupd_sql    STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_chr           LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_i             LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_imgno      LIKE type_file.num5   #No.TQC-9A0126 rowid  
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0074
 
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
 
 
    IF g_sma.sma01='N' THEN
        CALL cl_err('',9037,2)
        EXIT PROGRAM
    END IF
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
       LET p_row = 2 LET p_col = 27
 
    OPEN WINDOW t307_w AT p_row,p_col
        WITH FORM "aim/42f/aimt307" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
    CALL cl_set_comp_visible("dept,gem02",g_aaz.aaz90='Y')  #FUN-670093
    CALL cl_set_comp_required("reason",g_aza.aza115='Y')    #FUN-CB0087
    
    CALL t307_p()
    CLOSE WINDOW t307_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
END MAIN
 
#--------------------------------------------------------------------
FUNCTION t307_p()
 
    CALL cl_opmsg('a')
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_img.* TO NULL
    LET tno = NULL
    LET g_img.img14 = g_sma.sma30     
#---->迴路一
    WHILE TRUE
        LET g_chlang='N'
        IF s_shut(0) THEN EXIT WHILE END IF     #檢查權限
        CALL t307_i()                           # 各欄位輸入
        IF INT_FLAG THEN                        # 若按了DEL鍵
            LET INT_FLAG = 0
            EXIT WHILE
        END IF
        IF g_chlang='Y' THEN CONTINUE WHILE END IF
        LET g_img01_t=''
#---->迴路二
        WHILE TRUE
            LET g_success = 'Y'
            BEGIN WORK
            CALL t307_i1()                      # 各欄位輸入
            IF INT_FLAG THEN                         # 若按了DEL鍵
                LET INT_FLAG = 0
                CALL t307_c1()
                EXIT WHILE
            END IF
            LET g_img01_t=g_img.img01
#---->迴路三
            WHILE TRUE
                IF s_shut(0) THEN EXIT WHILE END IF     #檢查權限
                LET g_success = 'Y'
                BEGIN WORK
                CALL t307_i2()                          #各欄位輸入
                LET g_img01_t=''
                IF INT_FLAG THEN                        #若按了DEL鍵
                    LET INT_FLAG = 0
                    CALL t307_c2()
                    CALL t307_free()
                    EXIT WHILE
                END IF
                IF NOT cl_sure(16,19) THEN
                    CONTINUE WHILE
                END IF
                IF t307_t() THEN
		   CALL cl_err('','mfg0073',0)
		   CONTINUE WHILE 
		END IF
                IF g_success = 'Y'
                      THEN CALL cl_cmmsg(1) COMMIT WORK
                      ELSE CALL cl_rbmsg(1) ROLLBACK WORK
                END IF
                CALL t307_c2()
                IF g_sma.sma12 !='Y' THEN #單倉管理
                    EXIT WHILE
                END IF
                EXIT WHILE         # 去掉 Loop level 3 93/04/26 By roger
            END WHILE
        END WHILE
        CALL t307_c1()
        LET g_img.img02=''
        LET g_img.credit=''
        CLEAR img02,credit
    END WHILE
END FUNCTION
 
FUNCTION t307_c1()
    LET g_img.img01=''
    CLEAR img01,ima02,ima05,ima08,ima30
END FUNCTION
 
FUNCTION t307_c2()
    LET g_img.img02=''
    LET g_img.img03=''
    LET g_img.img04=''
    LET g_img.img19=''
    LET g_img.img36=''
    LET g_img.img09=''
    LET g_img.img10=''
    LET g_img.img08=''
    LET g_img.diff=''
    LET g_img.reason=''      #FUN-CB0087
    LET g_img.azf03=''       #FUN-CB0087
    #CLEAR img02,img03,img04,desc,img09,img10,img08,diff,img19,img36    #FUN-CB0087--mark
    CLEAR img02,img03,img04,desc,img09,img10,img08,diff,reason,azf03,img19,img36    #FUN-CB0087--add
END FUNCTION
 
#--------------------------------------------------------------------
FUNCTION t307_i()
DEFINE p_cmd           LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE li_result       LIKE type_file.num5    #No.FUN-550029  #No.FUN-690026 SMALLINT
 
#    LET tno[5,10]=''
    LET tno[g_no_sp,g_no_ep]=''              #No.FUN-550029
    DISPLAY BY NAME g_img.img14,tno,g_img.credit,g_img.dept #FUN-670093
         
    INPUT BY NAME g_img.img14, tno, g_img.credit,g_img.dept #FUN-670093
        WITHOUT DEFAULTS 
 
            #No.FUN-550029 --start--
    BEFORE INPUT
        CALL cl_set_docno_format("tno")
               #No.FUN-550029  --end--
 
       ON ACTION locale
           ROLLBACK WORK
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           CALL cl_dynamic_locale()
           LET g_chlang='Y' EXIT INPUT
      
 
        AFTER FIELD img14                    #盤點日期
        IF g_img.img14 IS NULL THEN LET g_img.img14=g_today END IF
            DISPLAY g_img.img14 to img14
            #CHI-690066--begin
			#IF  NOT s_daywk(g_img.img14)   
			#	THEN CALL cl_err(g_img.img14,'mfg3152',0)
			#		 NEXT FIELD img14
			#END IF
              LET li_result = 0
              CALL s_daywk(g_img.img14) RETURNING li_result
              IF li_result = 0 THEN  #0:非工作日
		 CALL cl_err(g_img.img14,'mfg3152',0)
		 NEXT FIELD img14
              END IF
              IF li_result = 2 THEN  #2:非工作日
		 CALL cl_err(g_img.img14,'mfg3153',0)
		 NEXT FIELD img14
              END IF
            #CHI-690066--end

                        
            CALL s_yp(g_img.img14) RETURNING l_year,l_prd
#---->與目前會計年度,期間比較,如日期大於目前會計年度,期間則不可過
            IF (l_year*12+l_prd) > (g_sma.sma51*12+g_sma.sma52)
               THEN CALL cl_err(l_year,'mfg6091',0) NEXT FIELD img14
            END IF
	    IF g_sma.sma53 IS NOT NULL AND g_img.img14 <= g_sma.sma53 THEN 
		CALL cl_err('','mfg9999',0) NEXT FIELD img14
	    END IF
            #No.FUN-730033  --Begin
            CALL s_get_bookno(YEAR(g_img.img14))   #TQC-740042
                 RETURNING g_flag,g_bookno1,g_bookno2
            IF g_flag =  '1' THEN  #抓不到帳別
               CALL cl_err(g_img.img14,'aoo-081',1)
               NEXT FIELD img14 
            END IF
            #No.FUN-730033  --End  
 
        AFTER FIELD tno   #調整單號
        #No.FUN-550029 --start--
#            LET tno[4,4]='-'                
#           DISPLAY BY NAME tno
#           IF tno = '   -' THEN LET tno='' END IF
#           IF tno = '   -' THEN NEXT FIELD tno END IF
            IF NOT cl_null(tno)  THEN
               CALL s_check_no("aim",tno,"","B","","","")
                    RETURNING li_result,tno
               DISPLAY BY NAME tno
               IF (NOT li_result) THEN
                    NEXT FIELD tno
               END IF
            END IF
#            IF NOT cl_null(tno[1,3])  # AND tno[5,10] =' '
#			   THEN
#                LET g_t1=tno[1,3]
#		CALL s_mfgslip(g_t1,'aim','B')	#檢查單別
#               	IF NOT cl_null(g_errno) THEN	 		#抱歉, 有問題
#                   	CALL cl_err(g_t1,g_errno,0)
#                   	NEXT FIELD tno
#               	END IF
#			END IF
#            IF g_smy.smyauno MATCHES '[nN]'
#               THEN IF cl_null(tno[5,10])
#                       THEN CALL cl_err(tno,'mfg6089',0)
#                            NEXT FIELD tno
#                    END IF
#                    IF NOT cl_chk_data_continue(tno[5,10]) THEN
#                       CALL cl_err('','9056',0)
#                       NEXT FIELD tno
#                    END IF
#            END IF
        #No.FUN-550029 --end--  
            BEGIN WORK   #No.FUN-560060
            CALL s_auto_assign_no("aim",tno,g_img.img14,"","","",
                    "","","")
                 RETURNING li_result,tno
            IF (NOT li_result) THEN
                 NEXT FIELD tno 
            END IF
            DISPLAY BY NAME tno
	    LET tno_seq = 0
#			IF g_smy.smyauno='Y'  AND cl_null(tno[5,10]) THEN
#			   CALL s_smyauno(tno,g_img.img14) RETURNING g_i,tno
#               IF g_i THEN NEXT FIELD tno END IF
#			   DISPLAY BY NAME tno 
#			   LET tno_seq = 0
#			END IF
 
        AFTER FIELD credit
            IF g_img.credit IS NOT NULL THEN
               IF g_sma.sma03='Y' THEN
                  IF NOT s_actchk3(g_img.credit,g_bookno1) THEN #檢查會計科目  #No.FUN-730033
                     CALL cl_err(g_img.credit,'mfg0018',0)
                     #FUN-B10049--begin
                     CALL cl_init_qry_var()                                         
                     LET g_qryparam.form ="q_aag"                                   
                     LET g_qryparam.default1 = g_img.credit  
                     LET g_qryparam.construct = 'N'                
                     LET g_qryparam.arg1 = g_aza.aza81  
                     LET g_qryparam.where = " aagacti='Y' AND aag01 LIKE '",g_img.credit CLIPPED,"%' "       
                     CALL cl_create_qry() RETURNING g_img.credit
                     DISPLAY BY NAME g_img.credit  
                     #FUN-B10049--end                       
                     NEXT FIELD credit
                  END IF
               END IF
            END IF
       #FUN-670093...............begin
       AFTER FIELD dept
           IF NOT s_costcenter_chk(g_img.dept) THEN
              NEXT FIELD dept
           ELSE
              DISPLAY s_costcenter_desc(g_img.dept) TO FORMONLY.gem02
           END IF
       #FUN-670093...............end
       
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
            IF NOT INT_FLAG AND
               g_img.img14 IS NULL THEN
                DISPLAY BY NAME g_img.img14 
                CALL cl_err('',9033,0)
                NEXT FIELD img14
            END IF
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
 
        ON ACTION controlp                                                      
           CASE                                                                 
              WHEN INFIELD(tno) #查詢單                                         
{
                 LET g_t1=tno[1,3]                                              
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form     ="q_smy"                               
                 LET g_qryparam.default1 = g_t1                                 
                 LET g_qryparam.arg1     = "aim"                                
                 LET g_qryparam.arg2     = "B"                                  
                 CALL cl_create_qry() RETURNING g_t1                            
#                 CALL FGL_DIALOG_SETBUFFER( g_t1 )
                 LET tno[1,3]=g_t1                                              
                 DISPLAY BY NAME tno                                            
                 NEXT FIELD tno              
}
#                 LET g_t1=tno[1,3]                                              
                 LET g_t1=s_get_doc_no(tno)        #No.FUN-550029
                 LET g_chr='B'
                 LET g_qryparam.state = "c"
                 CALL q_smy(FALSE,FALSE,g_t1,'AIM',g_chr) #TQC-670008
                 RETURNING g_t1
#                 CALL FGL_DIALOG_SETBUFFER( g_t1 )
#                 LET tno[1,3]=g_t1                                              
                 LET tno=g_t1                      #No.FUN-550029
                 DISPLAY BY NAME tno                                            
                 NEXT FIELD tno              
 
              WHEN INFIELD(credit) #會計科目                                    
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form     = "q_aag"                              
                 LET g_qryparam.default1 = g_img.credit                         
                 LET g_qryparam.arg1 = g_bookno1  #No.FUN-730033
                 CALL cl_create_qry() RETURNING g_img.credit                    
#                 CALL FGL_DIALOG_SETBUFFER( g_img.credit )
                 DISPLAY BY NAME g_img.credit                                   
                 NEXT FIELD credit                                              
              #FUN-670093...............begin
              WHEN INFIELD(dept)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gem4"
                 CALL cl_create_qry() RETURNING g_img.dept
                 DISPLAY BY NAME g_img.dept
                 NEXT FIELD dept
              #FUN-670093...............end
              OTHERWISE EXIT CASE                                               
           END CASE                                                             
                         
 
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
 
    
    END INPUT
END FUNCTION
 
FUNCTION t307_i1()
 
    DISPLAY BY NAME g_img.img01 
    INPUT BY NAME g_img.img01
        WITHOUT DEFAULTS 
 
 
        BEFORE FIELD img01
        IF g_sma.sma60 = 'Y'		# 若須分段輸入
          THEN CALL s_inp5(12,22,g_img.img01) RETURNING g_img.img01
               DISPLAY BY NAME g_img.img01 
               IF INT_FLAG THEN LET INT_FLAG = 0 END IF
   	    END IF
 
        AFTER FIELD img01 #料件編號
          IF g_img.img01 IS NOT NULL THEN
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_img.img01,"") THEN
               CALL cl_err('',g_errno,1)
               LET g_img.img01= g_img01_t
               NEXT FIELD img01
            END IF
#FUN-AA0059 ---------------------end-------------------------------
            IF g_img01_t IS NULL OR g_img01_t != g_img.img01 THEN
{*}             CALL t307_img01()
{*}             IF g_chr='L' THEN #Locked
                    CALL cl_err(g_img.img01,'aoo-060',0)
                    NEXT FIELD img01
                END IF
                IF g_chr='E' THEN
                    CALL cl_err(g_img.img01,'mfg0016',0)
                    NEXT FIELD img01
                END IF
                #No.FUN-570249  --begin
                SELECT ima906 INTO g_ima906 FROM ima_file
                 WHERE ima01=g_img.img01
                IF g_ima906='2' THEN
                   CALL cl_err(g_img.img01,'asm-399',1)
                   NEXT FIELD img01
                END IF
                #No.FUN-570249  --end   
            END IF
          END IF
 
        ON ACTION controlp                                                      
           CASE                                                                 
              WHEN INFIELD(img01) #料號                                         
#FUN-AA0059 --Begin--
              #   CALL cl_init_qry_var()                                         
              #   LET g_qryparam.form     = "q_ima"                              
              #   LET g_qryparam.default1 = g_img.img01                          
              #   CALL cl_create_qry() RETURNING g_img.img01                     
                 CALL q_sel_ima(FALSE, "q_ima", "", g_img.img01, "", "", "", "" ,"",'' )  RETURNING g_img.img01
#FUN-AA0059 --End--
#                 CALL FGL_DIALOG_SETBUFFER( g_img.img01 )
                 DISPLAY BY NAME g_img.img01                                    
                 CALL t307_img01()                                              
                 NEXT FIELD img01                                               
              OTHERWISE EXIT CASE                                               
           END CASE 
 
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
 
    
    END INPUT
END FUNCTION
 
FUNCTION t307_loc()
    #取得儲位性質
    IF g_img.img03 IS NOT NULL THEN
        SELECT ime05,ime06
            INTO g_img23,g_img24
            FROM ime_file
            WHERE ime01=g_img.img02 AND
                  ime02=g_img.img03
		  AND imeacti='Y'        #FUN-D40103 add
    ELSE
        SELECT imd11,imd12
            INTO g_img23,g_img24
            FROM imd_file
            WHERE imd01=g_img.img02
    END IF
    IF SQLCA.sqlcode THEN LET g_img23=' ' LET g_img24=' ' END IF
 
END FUNCTION
 
FUNCTION t307_img01() {*}
DEFINE
    l_ima02 LIKE ima_file.ima02, #品名規格
    l_ima05 LIKE ima_file.ima05, #目前版本
    l_ima08 LIKE ima_file.ima08, #來源碼
    l_ima30 LIKE ima_file.ima30,
    p_aqty  LIKE img_file.img10  #MOD-530179
DEFINE l_ima35 LIKE ima_file.ima35,    #CHI-6A0015
       l_ima36 LIKE ima_file.ima36     #CHI-6A0015
 
DEFINE   l_n1        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
DEFINE   l_n2        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
DEFINE   l_n3        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044  
 
    LET g_chr=''
#--->單倉管理時,為顯示料件來源碼,版本,品名規格,庫存單位,庫存數量
#.........在此處無法顯示多倉之資料
    IF g_sma.sma12='N' THEN #單倉管理時, 須要將該筆資料鎖住
 
#        LET g_forupd_sql = " SELECT ima02,ima05,ima08,ima25,(ima261+ima262),",
#                           " 0,ima39,ima30,ima35,ima36 ", #FUN-560183 del ima86,ima86_fac  #CHI-5A0015 add ima35/36
#                           " FROM ima_file ",             #No.TQC-930155--ADD---
#                           " WHERE ima01= ?  AND imaacti='Y' FOR UPDATE"
#        LET g_forupd_sql = " SELECT ima02,ima05,ima08,ima25,",   #NO.FUN-A20044
         LET g_forupd_sql = " SELECT ima02,ima05,ima08,ima25,0",  #NO.FUN-A20044
                            " 0,ima39,ima30,ima35,ima36 ", #FUN-560183 del ima86,ima86_fac  #CHI-5A0" 0,ima39,ima30,ima35,ima36 ", #FUN-560183 del ima86,ima86_fac  #CHI-5A0
                            " FROM ima_file ",
                            " WHERE ima01= ?  AND imaacti='Y' FOR UPDATE"
        #--LOCK CURSOR
        LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
        DECLARE img01_lock CURSOR FROM g_forupd_sql
 
        OPEN img01_lock USING g_img.img01
        IF STATUS THEN
           CALL cl_err("OPEN img01_lock:", STATUS, 1)
           CLOSE img01_lock
           ROLLBACK WORK
           RETURN
        END IF
        FETCH img01_lock
            INTO l_ima02,l_ima05,l_ima08,g_img.img09,g_img.img10,
                 p_aqty,g_img.ima39, #g_ima86,g_img.ima86_fac, #FUN-560183
                 l_ima30,l_ima35,l_ima36  #CHI-6A0015 add ima35/36
        IF SQLCA.sqlcode THEN
            IF SQLCA.sqlcode=-250 OR SQLCA.sqlcode=-263 THEN #LOCKED By another user    #TQC-930155--add -263
                LET g_chr='L'
            ELSE
                LET g_chr='E'
            END IF
            RETURN
        END IF
        #No.FUN-AA0049--begin
        IF NOT s_chk_ware(l_ima35) THEN
           LET l_ima35=' '
           LET l_ima36=' '
        END IF 
        #No.FUN-AA0049--end        
        CALL s_getstock(g_img.img01,g_plant) RETURNING  l_n1,l_n2,l_n3  ###GP5.2  #NO.FUN-A20044
        LET g_img.img10 = l_n3+l_n2                                     #NO.FUN-A20044  
        IF p_aqty IS NULL THEN
            LET p_aqty=0
        END IF
        LET g_img.aqty=g_img.img10-p_aqty   #可收料數量=可用量-備製量
        DISPLAY         l_ima02,     #品名規格
						l_ima05,     #版本
						l_ima08,     #來源碼
						g_img.img09, #庫存單位
						g_img.img10, #庫存數量
                        l_ima30
                       #,l_ima35,l_ima36    #CHI-6A0015 add ima35/36  #TQC-750018
		  TO            ima02,
						ima05,
						ima08,
						img09,
						img10,
                        ima30
                       #,img02,img03        #CHI-6A0015 add img02/03  #TQC-750018
						
         LET g_desc='單倉管理.....'
         DISPLAY g_desc TO FORMONLY.desc
		 ELSE
            SELECT   ima02,  ima05,  ima08, ima25,
		 ima30,ima35,ima36   #FUN-560183 del ima86,ima86_fac   #CHI-6A0015 add ima35/36
			  INTO l_ima02,l_ima05,l_ima08,g_img.img09,   
                   l_ima30,l_ima35,l_ima36   #FUN-560183 del g_ima86,g_img.ima86_fac   #CHI-6A0015 add ima35/36
              FROM ima_file
              WHERE ima01=g_img.img01 AND imaacti='Y'
              IF SQLCA.sqlcode THEN LET  g_chr='E' RETURN END IF
              #No.FUN-AA0049--begin
              IF NOT s_chk_ware(l_ima35) THEN
                 LET l_ima35=' '
                 LET l_ima36=' '
              END IF 
              #No.FUN-AA0049--end                 
              DISPLAY l_ima02,l_ima05,l_ima08, l_ima30
                 TO     ima02,  ima05,  ima08, ima30
         LET g_desc='多倉管理.....'
         DISPLAY g_desc TO FORMONLY.desc
	END IF
		LET g_ima25=g_img.img09  #料件庫存單位(保留當多倉時檢查)
        LET g_img21=  1
        LET g_img.ima25=g_ima25
        IF cl_null(g_img01_t) OR g_img01_t <> g_img.img01 THEN   #TQC-750018
          LET g_img.img02=l_ima35 #CHI-6A0015
          LET g_img.img03=l_ima36 #CHI-6A0015
          DISPLAY BY NAME g_img.img02,g_img.img03   #TQC-750018
        END IF   #TQC-750018
       #LET g_img.ima86=g_ima86
END FUNCTION
 
FUNCTION t307_i2()
DEFINE
    l_img04  LIKE img_file.img04,
    l_cmd    LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(30)
    l_direct LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    l_code   LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    p_cmd    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    l_qty    LIKE img_file.img10,    #MOD-530179
    l_flag   LIKE type_file.chr1     #FUN-C80107 add
DEFINE l_where    STRING             #FUN-CB0087
 
    LET t_img02=' '
    LET t_img03=' '
    DISPLAY BY NAME 
        g_img.img02,g_img.img03,g_img.img04,g_img.img09,
        g_img.img10,g_img.img08,g_img.diff,
        g_img.reason                               #FUN-CB0087--ADD>g_img.reason  
        
 
    INPUT BY NAME
        g_img.img02,g_img.img03,g_img.img04,g_img.img09,
        g_img.img10,g_img.img08,g_img.diff,
        g_img.reason                               #FUN-CB0087--ADD>g_img.reason
        WITHOUT DEFAULTS 
 
      BEFORE INPUT                                                              
         LET g_before_input_done = FALSE                                        
         CALL i110_set_entry(p_cmd)                                             
         CALL i110_set_no_entry(p_cmd)                                          
         LET g_before_input_done = TRUE
 
#        BEFORE FIELD img02  #倉庫編號
#若非多倉庫使用者, 則倉庫及儲位資料不用輸入
{
            IF g_sma.sma12!='Y' THEN
                NEXT FIELD img09
            END IF
}
 
        AFTER FIELD img02  #倉庫
          IF g_img.img02 IS NOT NULL THEN
             #FUN-D20060--add--str---
             IF NOT s_chksmz(g_img.img01,tno,g_img.img02, g_img.img03) THEN
                NEXT FIELD img02
             END IF
             #FUN-D20060--add--str---
            #No.FUN-AA0049--begin
            IF NOT s_chk_ware(g_img.img02) THEN
               NEXT FIELD img02
            END IF 
            #No.FUN-AA0049--end          
 #------>check-1
            IF NOT s_imfchk1(g_img.img01,g_img.img02)
               THEN CALL cl_err(g_img.img02,'mfg9036',0)
                    NEXT FIELD img02
            END IF
 #------>check-2
             CALL s_stkchk(g_img.img02,'A') RETURNING l_code
             IF NOT l_code THEN 
                CALL cl_err(g_img.img02,'mfg1100',0) 
                NEXT FIELD img02
             END IF
             CALL  s_swyn(g_img.img02) RETURNING sn1,sn2
             IF sn1=1 AND g_img.img02!=t_img02
               THEN CALL cl_err(g_img.img02,'mfg6080',0) 
               LET t_img02=g_img.img02
               NEXT FIELD img02
             ELSE 
               IF sn2=2 AND g_img.img02!=t_img02
                  THEN CALL cl_err(g_img.img02,'mfg6085',0) 
                       LET t_img02=g_img.img02
                       NEXT FIELD img02
               END IF
            END IF
            LET sn1=0 LET sn2=0
            IF g_img.img02 IS NULL THEN LET g_img.img02=' ' END IF
          END IF
	#IF NOT s_imechk(g_img.img02,g_img.img03) THEN NEXT FIELD img03 END IF  #FUN-D40103 add #TQC-D50124 mark
          NEXT FIELD img03      #No.TQC-750014 add
 
        AFTER FIELD img03  #儲位
           IF g_img.img03 IS NULL THEN LET g_img.img03=' ' END IF
           #------------------------------------ 檢查料號預設倉儲及單別預設倉儲
           IF NOT cl_null(g_img.img02) THEN  #FUN-D20060
              IF NOT s_chksmz(g_img.img01,tno,g_img.img02, g_img.img03) THEN
                 NEXT FIELD img02
              END IF
           END IF #FUN-D20060
           #------------------------------------------------------ 970715 roger
#------>chk-1
           IF NOT s_imfchk(g_img.img01,g_img.img02,g_img.img03)
              THEN CALL cl_err(g_img.img03,'mfg6095',0)
                   NEXT FIELD img03
           END IF
#------>chk-2
            IF g_img.img03 IS NOT NULL THEN
                CALL s_hqty(g_img.img01,g_img.img02,g_img.img03)
                    RETURNING g_cnt,g_img19,g_imf05
                IF g_img19 IS NULL THEN LET g_img19=0 END IF
                LET h_qty=g_img19
                CALL  s_lwyn(g_img.img02,g_img.img03) RETURNING sn1,sn2
			   IF sn1=1 AND g_img.img03!=t_img03
                  THEN CALL cl_err(g_img.img03,'mfg6081',0)
                       LET t_img03=g_img.img03
                       NEXT FIELD img03
                  ELSE IF sn2=2 AND g_img.img03!=t_img03
                          THEN CALL cl_err(g_img.img03,'mfg6086',0)
                          LET t_img03=g_img.img03
                       NEXT FIELD img03
                       END IF
               END IF
            END IF
            LET sn1=0 LET sn2=0
            LET l_direct='D'
{&}      IF g_img.img03 IS NULL THEN LET g_img.img03=' ' END IF
	#IF NOT s_imechk(g_img.img02,g_img.img03) THEN NEXT FIELD img03 END IF  #FUN-D40103 add #TQC-D50124 mark
         NEXT FIELD img04      #No.TQC-750014 add
 
        AFTER FIELD img04  #批號
{&}         IF g_img.img04 IS NULL THEN LET g_img.img04=' ' END IF
            IF g_sma.sma26='Y' AND g_img.img04 IS NULL THEN  #使用批號管理
                NEXT FIELD img04
            END IF
            CALL aimt307_img04_a()
            IF INT_FLAG THEN RETURN END IF
{+}         IF g_chr='L' THEN #Locked
                CALL cl_err(g_img.img04,'aoo-060',0)
                NEXT FIELD img04
            END IF
#----->-3333 表該批號不存在, 則庫存單位預設為料件預設庫存單位
#                              借方會計科目預設為{0,1,2}
            IF g_imgno ='-3333' AND g_img.img09 IS NULL
               THEN LET g_img.img09=g_imf05 END IF
            IF g_imgno ='-3333' THEN 
               CALL s_act(g_img.img01,g_img.img02,
                          g_img.img03) RETURNING  g_img.img26,g_status
            END IF
            DISPLAY BY NAME g_img.img09 
            IF g_img.img02 IS NULL AND g_img.img03 IS NULL 
                                   AND g_img.img04 IS NULL
               THEN CALL cl_err(' ','mfg6097',0)
                    NEXT FIELD img02 
           END IF 
 
         AFTER FIELD img08  #盤點數量
            IF g_img.img08 < 0 THEN
               NEXT FIELD img08
            ELSE LET g_img.diff = g_img.img08 - g_img.img10  #盤盈/虧數量
                 DISPLAY BY NAME g_img.diff
                 IF g_img.diff < 0 THEN 
                    LET l_qty = g_img.diff * -1 
                   #IF l_qty > g_img.aqty AND g_sma.sma894[8,8]='N'  #FUN-C80107 mark
                    LET l_flag = NULL    #FUN-C80107 add
                    #CALL s_inv_shrt_by_warehouse(g_sma.sma894[8,8],g_img.img02) RETURNING l_flag   #FUN-C80107 add #FUN-D30024--mark
                   CALL s_inv_shrt_by_warehouse(g_img.img02,g_plant) RETURNING l_flag              #FUN-D30024 add #TQC-D40078 g_plant
                    IF l_qty > g_img.aqty AND l_flag = 'N' #FUN-C80107 add
                       THEN   #盤虧時考慮備料/備置數量
                       CALL cl_err(' ','mfg6111',0)
                       NEXT FIELD img08
                    END IF
                 END IF
            END IF
          #FUN-CB0087--add--str
          BEFORE FIELD reason
             IF g_aza.aza115 = 'Y' AND cl_null(g_img.reason) THEN
                CALL s_reason_code(tno,'','',g_img.img01,g_img.img02,'','') RETURNING g_img.reason
                CALL t307_reason()
                DISPLAY BY NAME g_img.reason
             END IF

          AFTER FIELD reason
             IF NOT t307_reason_chk() THEN
                NEXT FIELD reason
             ELSE
                CALL t307_reason()
             END IF
          #FUN-CB0087--add--end
 
        AFTER INPUT
            IF g_img.img02 IS NULL THEN LET g_img.img02= ' ' END IF
            IF g_img.img03 IS NULL THEN LET g_img.img03= ' ' END IF
            IF g_img.img04 IS NULL THEN LET g_img.img04= ' ' END IF
{@}         IF NOT INT_FLAG AND g_sma.sma12 ='Y' AND
               (g_img.img02 IS NULL OR
                g_img.img08 IS NULL) THEN
                DISPLAY BY NAME g_img.img02,g_img.img08 
                CALL cl_err('',9033,0)
                NEXT FIELD img02
            END IF
            #FUN-CB0087---add---str---
            IF NOT t307_reason_chk() THEN
               NEXT FIELD reason
            END IF
            #FUN-CB0087--add--end
 
 
        ON ACTION controlp                                                      
           CASE                                                                 
              WHEN INFIELD(img02) #倉庫    
                 #No.FUN-AA0049--begin                                     
                 #CALL cl_init_qry_var()                                         
                 #LET g_qryparam.form     = "q_imfd"                             
                 #LET g_qryparam.default1 = g_img.img02                          
                 #LET g_qryparam.arg1     = "A"                                  
                 #LET g_qryparam.arg2     = g_img.img01                          
                 #CALL cl_create_qry() RETURNING g_img.img02    
                 CALL q_imd_1(FALSE,TRUE,g_img.img02,"","","","") RETURNING g_img.img02
                 #No.FUN-AA0049--end                 
#                 CALL FGL_DIALOG_SETBUFFER( g_img.img02 )
                 DISPLAY BY NAME g_img.img02                                    
                 NEXT FIELD img02                                               
              WHEN INFIELD(img03) #儲位                                         
                 CALL cl_init_qry_var()                                         
                  LET g_qryparam.form     = "q_imfe03"  #MOD-4A0252 儲位開窗                    
                 LET g_qryparam.default1 = g_img.img03                          
                 LET g_qryparam.arg1     = "A"                                  
                 LET g_qryparam.arg2     = g_img.img02                          
                 CALL cl_create_qry() RETURNING g_img.img03                     
#                CALL FGL_DIALOG_SETBUFFER( g_img.img03 )
                 DISPLAY BY NAME g_img.img02,g_img.img03                        
                 NEXT FIELD img03                                               
              WHEN INFIELD(img04) #LOTS                                         
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form     = "q_img"                              
                 LET g_qryparam.default1 = g_img.img04  
                 LET g_qryparam.arg1     = g_img.img01                          
                 LET g_qryparam.arg2     = g_img.img02                          
                 LET g_qryparam.arg3     = g_img.img03                          
                 LET g_qryparam.arg4     = g_img.img04                          
                 CALL cl_create_qry() RETURNING g_img.img04                     
#                CALL FGL_DIALOG_SETBUFFER( g_img.img04 )
                 DISPLAY BY NAME g_img.img04                                    
                 NEXT FIELD img04        
              #FUN-CB0087---add---str---
              WHEN INFIELD(reason)
                 CALL s_get_where(tno,'','',g_img.img01,g_img.img02,'','') RETURNING l_flag,l_where
                 IF g_aza.aza115='Y' AND l_flag THEN  
                    CALL cl_init_qry_var()
                    LET g_qryparam.form     ="q_ggc08"
                    LET g_qryparam.where = l_where
                    LET g_qryparam.default1 = g_img.reason
                 ELSE
                    CALL cl_init_qry_var()
                    LET g_qryparam.form     ="q_azf41"
                    LET g_qryparam.default1 = g_img.reason
                 END IF
                 CALL cl_create_qry() RETURNING g_img.reason
                 DISPLAY BY NAME g_img.reason
                 CALL t307_reason()
                 NEXT FIELD reason                    
              #FUN-CB0087---add---end---                                     
              OTHERWISE EXIT CASE                                               
           END CASE                    
 
 
       ON ACTION mntn_stock
             #    INFIELD(img02) #建立倉庫別
                   LET l_cmd = 'aimi200 x'
                   CALL cl_cmdrun(l_cmd)
      ON ACTION mntn_loc
             #    INFIELD(imp12) #建立儲位別
                   LET l_cmd = "aimi201 '",g_img.img02,"'" #BugNo:6598
                   CALL cl_cmdrun(l_cmd)
 
 
{
          CASE
             WHEN INFIELD(img02) #Warehouse
    CALL cl_init_qry_var()
    LET g_qryparam.form = 
    LET g_qryparam.default1 = 
    CALL cl_create_qry() RETURNING 
#    CALL FGL_DIALOG_SETBUFFER(  )
                          g_img.img36
                DISPLAY BY NAME g_img.img02,g_img.img03,g_img.img04,
                                g_img.img19,g_img.img36  
             WHEN INFIELD(img03) #儲位
    CALL cl_init_qry_var()
    LET g_qryparam.form = 
    LET g_qryparam.default1 = 
    CALL cl_create_qry() RETURNING 
#    CALL FGL_DIALOG_SETBUFFER(  )
                           g_img.img36
                DISPLAY BY NAME g_img.img02,g_img.img03,g_img.img04,
                      g_img.img19,g_img.img36  
             WHEN INFIELD(img04) #Warehouse
    CALL cl_init_qry_var()
    LET g_qryparam.form = 
    LET g_qryparam.default1 = 
    CALL cl_create_qry() RETURNING 
#    CALL FGL_DIALOG_SETBUFFER(  )
                          g_img.img36
                DISPLAY BY NAME g_img.img02,g_img.img03,g_img.img04,
                      g_img.img19,g_img.img36  
               OTHERWISE EXIT CASE
            END CASE
}
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
 
    
    END INPUT
END FUNCTION
 
FUNCTION i110_set_entry(p_cmd)                                                  
DEFINE   p_cmd   LIKE type_file.chr1                                                            #No.FUN-690026 VARCHAR(1)
                                                                                
   IF NOT g_before_input_done THEN                          
      CALL cl_set_comp_entry("img02,img03,img04",TRUE)              
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i110_set_no_entry(p_cmd)                                               
DEFINE   p_cmd   LIKE type_file.chr1                                                            #No.FUN-690026 VARCHAR(1)
                                                                                
   IF NOT g_before_input_done THEN                          
      IF g_sma.sma12!='Y' THEN                                                 
         CALL cl_set_comp_entry("img02,img03,img04",FALSE)          
      END IF                                                                    
   END IF                            
END FUNCTION
   
#取得該倉庫/ 儲位的相關數量資料
FUNCTION aimt307_img04_a()
DEFINE
#    c       LIKE ima_file.ima262,
    c       LIKE type_file.num15_3,    #No.FUN-A40023
    l_img19 LIKE img_file.img19   #庫存等級  
 
    LET g_chr=''
{&}   IF g_img.img02 IS NULL THEN LET g_img.img02 = ' ' END IF
{&}   IF g_img.img03 IS NULL THEN LET g_img.img03=' ' END IF
{&}   IF g_img.img04 IS NULL THEN LET g_img.img04=' ' END IF
    LET g_sql=
        "SELECT ' ',img09,img10,img19,img26,img23,img24,img21,img36 ",
        " FROM img_file",
        " WHERE img01='",g_img.img01,"'" 
    IF g_img.img02 IS NOT NULL THEN
        LET g_sql=g_sql CLIPPED," AND img02='", g_img.img02,"'"
    ELSE
        LET g_sql=g_sql CLIPPED," AND img02 IS NULL"
    END IF
    IF g_img.img03 IS NOT NULL THEN
        LET g_sql=g_sql CLIPPED," AND img03='", g_img.img03,"'"
    ELSE
        LET g_sql=g_sql CLIPPED," AND img03 IS NULL"
    END IF
    IF g_img.img04 IS NOT NULL THEN
        LET g_sql=g_sql CLIPPED," AND img04='", g_img.img04,"'"
    ELSE
        LET g_sql=g_sql CLIPPED," AND img04 IS NULL"
    END IF
    LET g_sql=g_sql CLIPPED," FOR UPDATE"    
    LET g_sql=cl_forupd_sql(g_sql)    #FUN-B80070
    PREPARE img04_p FROM g_sql
{+} DECLARE img04_lock CURSOR FOR img04_p
{+} OPEN img04_lock
    IF SQLCA.sqlcode THEN     
{+}    IF SQLCA.sqlcode=-250 OR SQLCA.sqlcode=-263 THEN #LOCKED By another user         
           LET g_chr='L'       
       ELSE                     
           LET g_chr='E'         
           LET g_imgno='-3333'  
           CALL t307_get_img()
       END IF    
       RETURN     
    END IF         
    #NO.TQC-930155-------end---------
{+} FETCH img04_lock 
        INTO g_imgno,g_img.img09,g_img.img10,
             g_img.img19,g_img.img26,g_img23,g_img24,g_img21,g_img.img36
    IF SQLCA.sqlcode THEN
{+}     IF SQLCA.sqlcode=-250 OR SQLCA.sqlcode= -263 THEN #LOCKED By another user    #NO.TQC-930155---add -263
            LET g_chr='L'
        ELSE
            LET g_chr='E'
            LET g_imgno='-3333'
            #NO.TQC-930155---------begin---------------
            CALL t307_get_img()
            #SELECT ime05,ime06 INTO g_img23,g_img24
            # FROM ime_file WHERE ime01=g_img.img02
            #                AND  ime02=g_img.img03
            #IF STATUS THEN LET g_img23=' ' LET g_img24=' ' END IF
            #----->為新增的庫存明細,開窗輸入相關資料
            #CALL aimt3071()    
            #NO.TQC-930155---------end---------------
        END IF
        #LET g_img.img10=0     #NO.TQC-930155
        RETURN
    END IF
    #NO.TQC-930155---------begin---------------
    #LET g_img.aqty=g_img.img10
    #LET g_desc=' '   DISPLAY g_desc TO FROMONLY.desc
    #IF g_img_rowid='-3333'
    #   THEN LET g_desc='尚未存在之倉庫/儲位/批號'
    #   ELSE CALL s_wardesc(g_img23,g_img24) RETURNING g_desc
    #END IF
    #IF g_img_rowid='-3333'
    #   THEN CALL t307_loc() 
    #END IF
    #DISPLAY BY NAME g_img.img09,g_img.img10,g_img.img19,
    #                                        g_img.img36 
    #DISPLAY g_desc TO FORMONLY.desc
    #NO.TQC-930155---------end---------------
END FUNCTION
#NO.TQC-930155----------------------begin-----------------------    
FUNCTION t307_get_img()                         
                                                                                                                                    
    IF NOT cl_null(g_chr) THEN                   
       SELECT ime05,ime06 INTO g_img23,g_img24    
          FROM ime_file WHERE ime01=g_img.img02    
                          AND  ime02=g_img.img03    
			   AND imeacti='Y'       #FUN-D40103 add
       IF STATUS THEN LET g_img23=' ' LET g_img24=' ' END IF 
       #----->為新增的庫存明細,開窗輸入相關資料      
       CALL aimt3071()   
       LET g_img.img10=0  
    END IF       
                                                                                                                                    
    LET g_img.aqty=g_img.img10    
    LET g_desc=' '   DISPLAY g_desc TO FROMONLY.desc 
    IF g_imgno='-3333' THEN       
       LET g_desc='尚未存在之倉庫/儲位/批號'  
    ELSE                    
       CALL s_wardesc(g_img23,g_img24) RETURNING g_desc   
    END IF                                     
    IF g_imgno='-3333' THEN CALL t307_loc() END IF  
    DISPLAY BY NAME g_img.img09,g_img.img10,g_img.img19,g_img.img36    
    DISPLAY g_desc TO FORMONLY.desc
END FUNCTION 
#NO.TQC-930155-----------------------end----------------------
#--------------------------------------------------------------------
#更新相關的檔案
FUNCTION t307_t()
DEFINE
    l_qty   LIKE img_file.img08,
    l_code  LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    LET l_qty=g_img.diff * g_img21    #料件庫存數量
	IF l_qty IS NULL THEN RETURN 1 END IF
#更新倉庫庫存明細資料
#--->單倉與多倉已在(s_upimg.4gl 處理掉)
#                1           2  3     4
   #CALL s_upimg(g_img_rowid,2,g_img.diff,g_img.img14, #FUN-8C0084
    CALL s_upimg(g_img.img01,g_img.img02,g_img.img03,g_img.img04,2,g_img.diff,g_img.img14, #FUN-8C0084
#       5           6           7           8           9
        g_img.img01,g_img.img02,g_img.img03,g_img.img04,'CYCLE CNT',
#       10 11          12          13
        '',g_img.img09,g_img.diff,g_img.img09,
#       14              15          16
        g_img.img09_fac,g_img.ima25_fac,1, #FUN-560183 g_img.ima86_fac->1
#       17          18         19           20             21
        g_img.img26,g_img.img35_2,g_img.img27,g_img.img28,g_img.img19,
#       22
         g_img.img36)
    IF g_success = 'N' THEN RETURN 1 END IF
 
#  若庫存異動後其庫存量小於等於零時將該筆資料刪除
     CALL s_delimg(g_img.img01,g_img.img02,g_img.img03,g_img.img04)  #FUN-8C0084
#更新庫存主檔之庫存數量 (單位為主檔之庫存單位)
    IF s_udima(g_img.img01,            #料件編號
			   g_img23,                #是否可用倉儲
			   g_img24,                #是否為MRP可用倉儲
			   l_qty,                  #盤盈/虧數量(庫存單位)
			   g_img.img14,            #最近一次盤點日期
			   2 )                     #表盤點
    	THEN RETURN 1 
	END IF
    IF g_success = 'N' THEN RETURN 1 END IF
 
#產生異動記錄資料
    CALL t307_free()
    CALL t307_log(1,0,'',g_img.img01)
	RETURN 0
END FUNCTION
 
FUNCTION t307_free()
{*} IF g_sma.sma12='N' THEN
        CLOSE img01_lock
    ELSE
        CLOSE img04_lock #將已鎖住之資料釋放出來
    END IF
END FUNCTION
 
#--------------------------------------------------------------------
#處理異動記錄
FUNCTION t307_log(p_stdc,p_reason,p_code,p_item)
DEFINE
    l_pmn02         LIKE pmn_file.pmn02,       #採購單性質
    p_stdc          LIKE type_file.num5,       #是否需取得標準成本  #No.FUN-690026 SMALLINT
    p_reason        LIKE type_file.num5,       #是否需取得異動原因  #No.FUN-690026 SMALLINT
    p_code          LIKE type_file.chr20,      #No.FUN-690026 VARCHAR(04)
    p_item          LIKE ima_file.ima01,       #No.FUN-690026 VARCHAR(20)
    l_qty           LIKE img_file.img08        #MOD-530179 #異動數量
 
#----來源----
#-----modify by pin 1992/05/25
    IF g_img.img03 IS NULL THEN LET g_img.img03=' ' END IF
    IF g_img.img04 IS NULL THEN LET g_img.img04=' ' END IF
    IF g_img.diff < 0     
    THEN 
        LET l_qty      =g_img.diff * -1
        #----來源----
        LET g_tlf.tlf02 =50        	             #來源為倉庫(盤虧)
        LET g_tlf.tlf020=g_plant                 #工廠別
        LET g_tlf.tlf021=g_img.img02           	 #倉庫別
        LET g_tlf.tlf022=g_img.img03  	         #儲位別
        LET g_tlf.tlf023=g_img.img04  	         #入庫批號
        LET g_tlf.tlf024=g_img.img10+ g_img.diff #(+/-)異動後庫存數量
        LET g_tlf.tlf025=g_img.img09             #庫存單位(ima or img)
    	LET g_tlf.tlf026=tno                     #調整單號
    	LET tno_seq     =tno_seq + 1
    	LET g_tlf.tlf027=tno_seq                 #調整項次
        #----目的----
        LET g_tlf.tlf03 =0         	 	         #目的為盤點
        LET g_tlf.tlf030=g_plant                 #工廠別
        LET g_tlf.tlf031=''            	         #倉庫別
        LET g_tlf.tlf032=''         	         #儲位別
        LET g_tlf.tlf033=''                 	 #批號
        LET g_tlf.tlf034=''                      #異動後庫存數量
	    LET g_tlf.tlf035=' '                     #庫存單位
    	LET g_tlf.tlf036='CYCLE'                 #週期盤點
    	LET g_tlf.tlf037=''
 
        LET g_tlf.tlf15=g_img.credit             #貸方會計科目(盤虧)
        LET g_tlf.tlf16=g_img.ima39              #料件會計科目(存貨)
    ELSE 
        LET l_qty      =g_img.diff
        #----來源----
        LET g_tlf.tlf02=0          	             #來源為盤點(盤盈)
        LET g_tlf.tlf020=g_plant                 #工廠別
        LET g_tlf.tlf021=''            	         #倉庫別
        LET g_tlf.tlf022=''         	         #儲位別
        LET g_tlf.tlf023=''                 	 #批號
        LET g_tlf.tlf024=''                      #異動後庫存數量
    	LET g_tlf.tlf025=' '                     #庫存單位
    	LET g_tlf.tlf026='CYCLE'                 #週期盤點
    	LET g_tlf.tlf027=''
        #----目的----
        LET g_tlf.tlf03=50         	 	         #目的為倉庫
        LET g_tlf.tlf030=g_plant                 #工廠別
        LET g_tlf.tlf031=g_img.img02           	 #倉庫別
        LET g_tlf.tlf032=g_img.img03  	         #儲位別
        LET g_tlf.tlf033=g_img.img04  	         #入庫批號
        LET g_tlf.tlf034=g_img.img10+ g_img.diff #(+/-)異動後庫存數量
        LET g_tlf.tlf035=g_img.img09             #庫存單位(ima or img)
    	LET g_tlf.tlf036=tno                     #調整單號
    	LET tno_seq     =tno_seq + 1
    	LET g_tlf.tlf037=tno_seq                 #調整項次
 
        LET g_tlf.tlf15=g_img.ima39              #料件會計科目(存貨)
        LET g_tlf.tlf16=g_img.credit             #貸方會計科目(盤盈)
    END IF
 
    LET g_tlf.tlf01=p_item               	 #異動料件編號
#--->異動數量
    LET g_tlf.tlf04=' '                      #工作站
    LET g_tlf.tlf05=' '                      #作業序號
    LET g_tlf.tlf06=g_img.img14              #盤點日期
	LET g_tlf.tlf07=g_today                  #異動資料產生日期  
	LET g_tlf.tlf08=TIME                     #異動資料產生時:分:秒
	LET g_tlf.tlf09=g_user                   #產生人
	LET g_tlf.tlf10=l_qty                    #盤盈/虧數量(皆為正值)
	LET g_tlf.tlf11=g_img.img09              #庫存單位
	LET g_tlf.tlf12=1                        #單位轉換率
	LET g_tlf.tlf13='aimt307'                #異動命令代號
	#LET g_tlf.tlf14=''                       #異動原因         #FUN-CB0087---mark
        LET g_tlf.tlf14=g_img.reason                                #FUN-CB0087---add
    	LET g_tlf.tlf905=tno                     #調整單號
    CALL s_imaQOH(g_img.img01)
         RETURNING g_tlf.tlf18               #異動後總庫存量
	LET g_tlf.tlf19= ' '                     #異動廠商/客戶編號
	LET g_tlf.tlf20= ' '                     #project no.      
   #LET g_tlf.tlf61= g_ima86                 #成本單位 #FUN-560183
    LET g_tlf.tlf930= g_img.dept #FUN-670093
    CALL s_tlf(p_stdc,p_reason)
END FUNCTION
   
FUNCTION aimt3071()
  DEFINE l_img26  LIKE img_file.img26,
         l_status LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
         l_direct LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
 
    OPEN WINDOW t3071_w AT 8,21
        WITH FORM "aim/42f/aimt3021" 
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("aimt3021")
 
    IF g_img.img28 IS NULL THEN  LET g_img.img28=99 END IF
    IF g_img.img19 IS NULL THEN LET g_img.img19 = g_img.img19 END IF
    IF g_img.img36 IS NULL THEN LET g_img.img36 = g_img.img36 END IF
    IF g_img.img35 IS NULL THEN LET g_img.img35 = g_img.img35 END IF
 
    DISPLAY g_img.img35_2 TO img35_2
    INPUT BY NAME g_img.ima25_fac,g_img.ima25    #,g_img.ima86_fac,
                  ,g_img.img26,g_img.img19,g_img.img36,  #FUN-560183 del g_img.ima86
                  g_img.img27,g_img.img28,g_img.img35_2
         WITHOUT DEFAULTS 
 
        BEFORE FIELD ima25_fac 
           IF g_img.ima25 = g_img.img09
              THEN LET g_img.ima25_fac=1
                   DISPLAY g_img.ima25_fac TO ima25_fac
           END IF
 
       #FUN-560183................begin
       #BEFORE FIELD ima86_fac 
       #   IF g_img.ima86 = g_img.img09
       #      THEN LET g_img.ima86_fac=1
       #           DISPLAY g_img.ima86_fac TO ima86_fac
       #   END IF
       #FUN-560183................end
 
        BEFORE FIELD img26
            CALL s_act(g_img.img01,g_img.img02,g_img.img03)
                 RETURNING l_img26,l_status
            IF l_status ='0' AND g_img.img26 IS NULL 
               THEN CALL cl_err(g_img.img26,'mfg6112',0)
            END IF
            IF l_status MATCHES '[12]' THEN
               LET g_img.img26=l_img26 
               DISPLAY BY NAME g_img.img26
            END IF
            IF l_direct='D' THEN
               #FUN-560183................begin
              #THEN IF l_status MATCHES '[12]' THEN NEXT FIELD img19 END IF
              #ELSE IF l_status MATCHES '[12]' THEN NEXT FIELD ima86_fac END IF
               NEXT FIELD img19
               #FUN-560183................end
            END IF
                     
        AFTER FIELD img26   #會計科目
           IF l_status ='0' THEN
              IF g_sma.sma03='Y' THEN
                IF NOT s_actchk3(g_img.img26,g_bookno1) THEN  #No.FUN-730033
                    CALL cl_err(g_img.img26,'mfg0018',0)
                    NEXT FIELD img26 
                END IF
              END IF
            END IF
         AFTER FIELD img27
            LET l_direct='U'
 
        AFTER FIELD img35_2   #專案號碼
            IF NOT cl_null(g_img.img35_2) THEN
                SELECT gja01 FROM gja_file
                    WHERE gja01=g_img.img35_2
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_img.img35,'mfg3064',0) #No.FUN-660156
                   CALL cl_err3("sel","gja_file",g_img.img35,"","mfg3064","","",0)  #No.FUN-660156
                   NEXT FIELD img35_2
                END IF
            END IF
 
 
        ON ACTION controlp                                                      
           CASE                                                                 
              WHEN INFIELD(img26) #會計科目                                     
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form     = "q_aag"                              
                 LET g_qryparam.default1 = g_img.img26                          
                 LET g_qryparam.arg1 = g_bookno1  #No.FUN-730033
                 CALL cl_create_qry() RETURNING g_img.img26                     
#                 CALL FGL_DIALOG_SETBUFFER( g_img.img26 )
                 DISPLAY BY NAME g_img.img26                                    
                 NEXT FIELD img26                                               
              WHEN INFIELD(img35_2) #專案名稱                                   
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form     = "q_gja"  
                 LET g_qryparam.default1 = g_img.img35_2                        
                 CALL cl_create_qry() RETURNING g_img.img35_2                   
#                 CALL FGL_DIALOG_SETBUFFER( g_img.img35_2 )
                 DISPLAY BY NAME g_img.img35_2                                  
                 NEXT FIELD img35_2                                             
               OTHERWISE EXIT CASE                                              
            END CASE                                                            
                                
      ON ACTION mntn_prj
              #WHEN INFIELD(img35_2) #專案名稱
                  CALL cl_cmdrun('aooi200')
 
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
 
    
    END INPUT
    CLOSE WINDOW t3071_w
    DISPLAY BY NAME g_img.img19,g_img.img36
END FUNCTION

#FUN-CB0087---add---str---
FUNCTION t307_reason()

IF NOT cl_null(g_img.reason) THEN      #TQC-D20042---add
   SELECT azf03 INTO g_img.azf03
     FROM azf_file
    WHERE azf01 = g_img.reason
      AND azf02 = '2'
ELSE                                   #TQC-D20042---add
   LET g_img.azf03 = ' '               #TQC-D20042---add
END IF                                 #TQC-D20042---add
   DISPLAY BY NAME g_img.azf03
END FUNCTION

FUNCTION t307_reason_chk()
DEFINE  l_flag          LIKE type_file.chr1,
        l_n             LIKE type_file.num5,
        l_where         STRING,
        l_sql           STRING
   IF NOT cl_null(g_img.reason) THEN
      LET l_n = 0
      LET l_flag = FALSE
      IF g_aza.aza115='Y' THEN
         CALL s_get_where(tno,'','',g_img.img01,g_img.img02,'','') RETURNING l_flag,l_where
      END IF
      IF g_aza.aza115='Y' AND l_flag THEN
         LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_img.reason,"' AND ",l_where
         PREPARE ggc08_pre FROM l_sql
         EXECUTE ggc08_pre INTO l_n
         IF l_n < 1 THEN
            CALL cl_err(g_img.reason,'aim-425',0)
            RETURN FALSE
         END IF
      ELSE
         SELECT COUNT(*) INTO l_n FROM azf_file WHERE azf01 = g_img.reason AND azf02 = '2'
         IF l_n < 1 THEN
            CALL cl_err(g_img.reason,'aim-425',0)
            RETURN FALSE
         END IF
      END IF
   ELSE                                   #TQC-D20042
      LET g_img.azf03 = ' '               #TQC-D20042
      DISPLAY BY NAME g_img.azf03         #TQC-D20042
   END IF 
   RETURN TRUE    
END FUNCTION
#FUN-CB0087---add---end---

