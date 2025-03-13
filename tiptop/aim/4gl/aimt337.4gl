# Prog. Version..: '5.30.06-13.03.22(00010)'     #
#
# Pattern name...: aimt337.4gl
# Descriptions...: 多單位週期盤點作業
# Date & Author..: 05/08/01 By Carrier 
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.TQC-670008 06/07/05 By kim 將 g_sys 變數改成寫死系統別(要大寫)
# Modify.........: No.FUN-670093 06/07/27 By kim GP3.5 利潤中心
# Modify.........: No.FUN-690026 06/09/12 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.CHI-690066 06/12/13 By rainy CALL s_daywk() 要判斷未設定或非工作日
# Modify.........: No.CHI-6A0015 06/12/19 By rainy 輸入料號後，要自動帶出預設倉庫儲位
# Modify.........: No.FUN-730033 07/03/21 By Carrier 會計科目加帳套
# Modify.........: No.TQC-740042 07/04/09 By bnlent 用年度取帳套
# Modify.........: No.TQC-750018 07/05/07 By rainy 更改狀態無更改料號時，不重帶倉庫儲位
# Modify.........: No.FUN-810045 08/03/03 By rainy 項目管理:專案table gja_file 改為pja_file
# Modify.........: No.FUN-8C0084 08/12/22 By jan s_upimg相關改以 料倉儲批為參數傳入 ,不使用 ROWID 
# Modify.........: No.TQC-930155 09/04/14 By Zhangyajun OPEN CURSOR出錯也要報錯
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 增加"專案未結案"的判斷
# Modify.........: No.TQC-9A0134 09/10/26 By liuxqa 修改ROWID
# Modify.........: No.FUN-9B0040 10/03/22 By wangj ima26x改善 
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No.FUN-AA0062 10/10/24 By yinhy 倉庫權限使用控管修改
# Modify.........: No.FUN-AA0059 10/10/29 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No.FUN-AA0059 10/10/29 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No.TQC-AC0033 10/12/03 By yinhy mark掉AA0062增加的倉庫默認值
# Modify.........: No.FUN-B10049 11/01/24 By destiny 科目查詢自動過濾
# Modify.........: No:FUN-C80107 12/09/18 By suncx 增可按倉庫進行負庫存判斷
# Modify.........: No:FUN-CB0087 12/12/07 By qiull 庫存單據理由碼改善
# Modify.........: No.FUN-D20060 13/02/22 By yangtt 設限倉庫控卡
# Modify.........: No.TQC-D20042 13/02/25 By qiull 修改理由碼改善測試問題
# Modify.........: No.FUN-D30024 13/03/12 By qiull 負庫存依據imd23判斷
# Modify.........: No.FUN-D40103 13/05/07 By fengrui 添加庫位有效性檢查;抓ime_file資料添加imeacti='Y'條件
# Modify.........: No.TQC-D50124 13/05/28 By lixiang 修正FUN-D40103部份邏輯控管
# Modify.........: No:TQC-D40078 13/04/28 By xujing 負庫存函数添加营运中心参数 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_chlang  LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE
    g_t1          LIKE smy_file.smyslip,  #No.FUN-690026 VARCHAR(5)
    g_sql         string,  #No.FUN-580092 HCN
    g_imgg01_t    LIKE imgg_file.imgg01, 
    g_desc        LIKE ze_file.ze03,      #No.FUN-690026 VARCHAR(25)
    sn1,sn2       LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    g_status      LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    l_year,l_prd  LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    h_qty         LIKE ima_file.ima271,
    tno           LIKE imn_file.imn01,    #No.FUN-690026 VARCHAR(16)
    tno_seq       LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    g_ima906      LIKE ima_file.ima906,
    g_ima907      LIKE ima_file.ima907,
    g_flag        LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    g_imf05       LIKE imf_file.imf05,
#    g_ima26       LIKE ima_file.ima26,  #No.FUN-9B0040        #會計科目
    g_img         RECORD 
                  img09     LIKE img_file.img09,
                  img10     LIKE img_file.img10,
                  img21     LIKE img_file.img21,
                  img23     LIKE img_file.img23,
                  img24     LIKE img_file.img24,
                  aqty      LIKE img_file.img10, #可用數量
                  img09_fac LIKE img_file.img20, #收料對庫存單位專換率
                  ima39     LIKE ima_file.ima39,
                  ima25_fac LIKE ima_file.ima63_fac,
                  ima25     LIKE ima_file.ima25,
                  img26     LIKE img_file.img26, #倉儲所用之會計科目
                  img19     LIKE img_file.img19,
                  img36     LIKE img_file.img36,
                  img27     LIKE img_file.img27,
                  img28     LIKE img_file.img28,
                  img35     LIKE img_file.img35,
                  img35_2   LIKE img_file.img35
          END RECORD,
    g_imgg19      LIKE ima_file.ima271,         #CLASS
    g_imgg23      LIKE imgg_file.imgg23,        #是否為可用倉儲
    g_imgg24      LIKE imgg_file.imgg24,        #是否為MRP可用倉儲
    g_imgg21      LIKE imgg_file.imgg21,        #庫存單位對料件庫存單位轉換率
    g_imgg211     LIKE imgg_file.imgg21,        #庫存單位對料件庫存單位轉換率
    g_imgg        RECORD 
                  imgg14     LIKE imgg_file.imgg14,     #盤點日期
                  credit     LIKE imgg_file.imgg26,     #借方會計科目
                  dept       LIKE gem_file.gem10,       #FUN-670093
                  imgg01     LIKE imgg_file.imgg01,     #料件編號
                  imgg02     LIKE imgg_file.imgg02,     #倉庫
                  imgg03     LIKE imgg_file.imgg03,     #儲位
                  imgg04     LIKE imgg_file.imgg04,     #存放批號
                  imgg09     LIKE imgg_file.imgg09,     #庫存單位
                  imgg19     LIKE imgg_file.imgg19,     #Class   
                  imgg36     LIKE imgg_file.imgg36,     #
                  imgg10     LIKE imgg_file.imgg10,     #庫存數量
                  imgg08     LIKE imgg_file.imgg08,     #盤點數量
                  imgg26     LIKE imgg_file.imgg26,     #倉儲所用之會計科目
                  diff       LIKE imgg_file.imgg10,     #盤盈虧數量
                  reason     LIKE azf_file.azf01,       #FUN-CB0087---add---理由碼
                  azf03      LIKE azf_file.azf03,       #FUN-CB0087---add---說明
                  aqty       LIKE imgg_file.imgg10,     #可用數量
                  imgg09_fac LIKE imgg_file.imgg20,     #收料對庫存單位專換率
                  ima39      LIKE ima_file.ima39,
                  ima25_fac  LIKE ima_file.ima63_fac,
                  ima25      LIKE ima_file.ima25,
                  img09_fac  LIKE img_file.img21,
                  img09      LIKE img_file.img09,
                  imgg27     LIKE imgg_file.imgg27,
                  imgg28     LIKE imgg_file.imgg28,
                  imgg35     LIKE imgg_file.imgg35,
                  imgg35_2   LIKE imgg_file.imgg35
                  END RECORD,
                  t_imgg02 LIKE imgg_file.imgg02, #倉庫
                  t_imgg03 LIKE imgg_file.imgg03  #儲位
 
DEFINE g_bookno1           LIKE aza_file.aza81    #No.FUN-730033
DEFINE g_bookno2           LIKE aza_file.aza82    #No.FUN-730033
DEFINE p_row,p_col         LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_forupd_sql        STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_chr               LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt               LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_i                 LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_imggno     LIKE type_file.num5    #No.TQC-9A0134 mod
DEFINE g_imgno      LIKE type_file.num5    #No.TQC-9A0134 mod 
 
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
 
    IF g_sma.sma01='N' THEN
       CALL cl_err('',9037,2)
       EXIT PROGRAM
    END IF
    IF g_sma.sma115 IS NULL OR g_sma.sma115='N' THEN
       CALL cl_err('','asm-383',1)
       EXIT PROGRAM
    END IF
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
    LET p_row = 2 LET p_col = 27
 
    OPEN WINDOW t337_w AT p_row,p_col
         WITH FORM "aim/42f/aimt337"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
    CALL cl_set_comp_visible("dept,gem02",g_aaz.aaz90='Y')  #FUN-670093
    CALL cl_set_comp_required("reason",g_aza.aza115='Y')    #FUN-CB0087
    CALL t337_p()
    CLOSE WINDOW t337_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
END MAIN
 
#--------------------------------------------------------------------
FUNCTION t337_p()
 
    CALL cl_opmsg('a')
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_imgg.* TO NULL
    LET tno = NULL
    LET g_imgg.imgg14 = g_sma.sma30     
#---->迴路一
    WHILE TRUE
        LET g_chlang='N'
        IF s_shut(0) THEN EXIT WHILE END IF     #檢查權限
        CALL t337_i()                           # 各欄位輸入
        IF INT_FLAG THEN                        # 若按了DEL鍵
            LET INT_FLAG = 0
            EXIT WHILE
        END IF
        IF g_chlang='Y' THEN CONTINUE WHILE END IF
        LET g_imgg01_t=''
#---->迴路二
        WHILE TRUE
            LET g_success = 'Y'
            BEGIN WORK
            CALL t337_i1()                      # 各欄位輸入
            IF INT_FLAG THEN                    # 若按了DEL鍵
               LET INT_FLAG = 0
               CALL t337_c1()
               EXIT WHILE
            END IF
            LET g_imgg01_t=g_imgg.imgg01
#---->迴路三
            WHILE TRUE
                IF s_shut(0) THEN EXIT WHILE END IF     #檢查權限
                LET g_success = 'Y'
                BEGIN WORK
                CALL t337_i2()                          #各欄位輸入
                LET g_imgg01_t=''
                IF INT_FLAG THEN                        #若按了DEL鍵
                   LET INT_FLAG = 0
                   CALL t337_c2()
                   CALL t337_free()
                   EXIT WHILE
                END IF
                IF NOT cl_sure(16,19) THEN
                   CONTINUE WHILE
                END IF
                IF t337_t() THEN
                   CALL cl_err('','mfg0073',0)
                   CONTINUE WHILE 
                END IF
                IF g_success = 'Y'
                   THEN CALL cl_cmmsg(1) COMMIT WORK
                   ELSE CALL cl_rbmsg(1) ROLLBACK WORK
                END IF
                CALL t337_c2()
                IF g_sma.sma12 !='Y' THEN #單倉管理
                   EXIT WHILE
                END IF
                EXIT WHILE         # 去掉 Loop level 3 93/04/26 By roger
            END WHILE
        END WHILE
        CALL t337_c1()
        LET g_imgg.imgg02=''
        LET g_imgg.credit=''
        CLEAR imgg02,credit
    END WHILE
END FUNCTION
 
FUNCTION t337_c1()
    LET g_imgg.imgg01=''
    CLEAR imgg01,ima02,ima05,ima08,ima30
END FUNCTION
 
FUNCTION t337_c2()
    LET g_imgg.imgg02=''
    LET g_imgg.imgg03=''
    LET g_imgg.imgg04=''
    LET g_imgg.imgg19=''
    LET g_imgg.imgg36=''
    LET g_imgg.imgg09=''
    LET g_imgg.imgg10=''
    LET g_imgg.imgg08=''
    LET g_imgg.diff=''
    LET g_imgg.reason=''        #FUN-CB0087
    LET g_imgg.azf03=''         #FUN-CB0087
    #CLEAR imgg02,imgg03,imgg04,desc,imgg09,imgg10,imgg08,diff,imgg19,imgg36      #FUN-CB0087--mark
    CLEAR imgg02,imgg03,imgg04,desc,imgg09,imgg10,imgg08,diff,reason,azf03,imgg19,imgg36    #FUN-CB0087--add>-reason,azf03
END FUNCTION
 
#--------------------------------------------------------------------
FUNCTION t337_i()
DEFINE p_cmd           LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE li_result       LIKE type_file.num5    #No.FUN-550029  #No.FUN-690026 SMALLINT
 
    LET tno[g_no_sp,g_no_ep]=''              #No.FUN-550029
    DISPLAY BY NAME g_imgg.imgg14,tno,g_imgg.credit,g_imgg.dept #FUN-670093
         
    INPUT BY NAME g_imgg.imgg14, tno, g_imgg.credit ,g_imgg.dept #FUN-670093
          WITHOUT DEFAULTS 
 
       BEFORE INPUT
          CALL cl_set_docno_format("tno")
 
       ON ACTION locale
          ROLLBACK WORK
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          CALL cl_dynamic_locale()
          LET g_chlang='Y' EXIT INPUT
 
       AFTER FIELD imgg14                    #盤點日期
          IF g_imgg.imgg14 IS NULL THEN LET g_imgg.imgg14=g_today END IF
          DISPLAY g_imgg.imgg14 to imgg14
         #CHI-690066--begin
           #IF NOT s_daywk(g_imgg.imgg14) THEN 
           #   CALL cl_err(g_imgg.imgg14,'mfg3152',0)
           #   NEXT FIELD imgg14
           #END IF
           LET li_result = 0
           CALL s_daywk(g_imgg.imgg14) RETURNING li_result
	   IF li_result = 0 THEN #非工作日
              CALL cl_err(g_imgg.imgg14,'mfg3152',0)
	      NEXT FIELD imgg14
	   END IF
	   IF li_result = 2 THEN #未設定
              CALL cl_err(g_imgg.imgg14,'mfg3153',0)
	      NEXT FIELD imgg14
	   END IF
         #CHI-690066--end

          CALL s_yp(g_imgg.imgg14) RETURNING l_year,l_prd
#---->與目前會計年度,期間比較,如日期大於目前會計年度,期間則不可過
          IF (l_year*12+l_prd) > (g_sma.sma51*12+g_sma.sma52) THEN 
             CALL cl_err(l_year,'mfg6091',0) 
             NEXT FIELD imgg14
          END IF
          
          IF g_sma.sma53 IS NOT NULL AND g_imgg.imgg14 <= g_sma.sma53 THEN 
             CALL cl_err('','mfg9999',0)
             NEXT FIELD imgg14
          END IF
          #No.FUN-730033  --Begin
          CALL s_get_bookno(YEAR(g_imgg.imgg14)) RETURNING g_flag,g_bookno1,g_bookno2   #TQC-740042
          IF g_flag =  '1' THEN  #抓不到帳別
             CALL cl_err(g_imgg.imgg14,'aoo-081',1)
             NEXT FIELD imgg14
          END IF
          #No.FUN-730033  --End  
 
       AFTER FIELD tno   #調整單號
          IF NOT cl_null(tno)  THEN
             CALL s_check_no("aim",tno,"","B","","","")
                  RETURNING li_result,tno
             DISPLAY BY NAME tno
             IF (NOT li_result) THEN
                NEXT FIELD tno
             END IF
          END IF
          BEGIN WORK   
          CALL s_auto_assign_no("aim",tno,g_imgg.imgg14,"","","","","","")
               RETURNING li_result,tno
          IF (NOT li_result) THEN
             NEXT FIELD tno 
          END IF
          DISPLAY BY NAME tno
          LET tno_seq = 0
 
       AFTER FIELD credit
          IF g_imgg.credit IS NOT NULL THEN
             IF g_sma.sma03='Y' THEN
                IF NOT s_actchk3(g_imgg.credit,g_bookno1) THEN #檢查會計科目  #No.FUN-730033
                   CALL cl_err(g_imgg.credit,'mfg0018',0)
                   #FUN-B10049--begin
                   CALL cl_init_qry_var()                                         
                   LET g_qryparam.form ="q_aag"                                   
                   LET g_qryparam.default1 = g_imgg.credit  
                   LET g_qryparam.construct = 'N'                
                   LET g_qryparam.arg1 = g_bookno1  
                   LET g_qryparam.where = " aagacti='Y' AND aag01 LIKE '",g_imgg.credit CLIPPED,"%' "            
                   CALL cl_create_qry() RETURNING g_imgg.credit
                   DISPLAY BY NAME g_imgg.credit  
                   #FUN-B10049--end                        
                   NEXT FIELD credit
                END IF
             END IF
          END IF
          
       #FUN-670093...............begin
       AFTER FIELD dept
           IF NOT s_costcenter_chk(g_imgg.dept) THEN
              NEXT FIELD dept
           ELSE
              DISPLAY s_costcenter_desc(g_imgg.dept) TO FORMONLY.gem02
           END IF
       #FUN-670093...............end
 
       AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
          IF NOT INT_FLAG AND g_imgg.imgg14 IS NULL THEN
             DISPLAY BY NAME g_imgg.imgg14 
             CALL cl_err('',9033,0)
             NEXT FIELD imgg14
          END IF
 
       ON ACTION CONTROLF
          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON ACTION controlp                                                      
          CASE                                                                 
              WHEN INFIELD(tno) #查詢單                                         
                 LET g_t1=s_get_doc_no(tno)        #No.FUN-550029
                 LET g_chr='B'
                 LET g_qryparam.state = "c"
                 CALL q_smy(FALSE,FALSE,g_t1,'AIM',g_chr) #TQC-670008
                 RETURNING g_t1
                 LET tno=g_t1                      #No.FUN-550029
                 DISPLAY BY NAME tno                                            
                 NEXT FIELD tno              
 
              WHEN INFIELD(credit) #會計科目                                    
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form     = "q_aag"                              
                 LET g_qryparam.default1 = g_imgg.credit                         
                 LET g_qryparam.arg1 = g_bookno1  #No.FUN-730033
                 CALL cl_create_qry() RETURNING g_imgg.credit                    
                 DISPLAY BY NAME g_imgg.credit                                   
                 NEXT FIELD credit                                              
              #FUN-670093...............begin
              WHEN INFIELD(dept)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gem4"
                 CALL cl_create_qry() RETURNING g_imgg.dept
                 DISPLAY BY NAME g_imgg.dept
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
 
FUNCTION t337_i1()
 
    DISPLAY BY NAME g_imgg.imgg01 
    INPUT BY NAME g_imgg.imgg01 WITHOUT DEFAULTS 
 
        BEFORE FIELD imgg01
           IF g_sma.sma60 = 'Y' THEN       # 若須分段輸入
              CALL s_inp5(12,22,g_imgg.imgg01) RETURNING g_imgg.imgg01
              DISPLAY BY NAME g_imgg.imgg01 
              IF INT_FLAG THEN LET INT_FLAG = 0 END IF
           END IF
 
        AFTER FIELD imgg01 #料件編號
           IF g_imgg.imgg01 IS NOT NULL THEN
#FUN-AA0059 ---------------------start----------------------------
              IF NOT s_chk_item_no(g_imgg.imgg01,"") THEN
                 CALL cl_err('',g_errno,1)
                 LET g_imgg.imgg01= g_imgg01_t
                 NEXT FIELD imgg01
              END IF
#FUN-AA0059 ---------------------end-------------------------------

              IF g_imgg01_t IS NULL OR g_imgg01_t != g_imgg.imgg01 THEN
                 CALL t337_imgg01()
                 IF g_chr='L' THEN #Locked
                    CALL cl_err(g_imgg.imgg01,'aoo-060',0)
                    NEXT FIELD imgg01
                 END IF
                 IF g_chr='E' THEN
                    CALL cl_err(g_imgg.imgg01,'mfg0016',0)
                    NEXT FIELD imgg01
                 END IF
                 CALL s_chk_va_setting(g_imgg.imgg01)
                      RETURNING g_flag,g_ima906,g_ima907
                 IF g_flag=1 THEN
                    NEXT FIELD imgg01
                 END IF
                 IF g_ima906 NOT MATCHES '[23]' THEN
                    CALL cl_err(g_imgg.imgg01,'asm-384',1)
                    NEXT FIELD imgg01
                 END IF
              END IF
           END IF
 
        ON ACTION controlp                                                      
           CASE                                                                 
              WHEN INFIELD(imgg01) #料號                                         
#FUN-AA0059 --Begin--
               #  CALL cl_init_qry_var()                                         
               #  LET g_qryparam.form     = "q_ima"                              
               #  LET g_qryparam.default1 = g_imgg.imgg01                          
               #  CALL cl_create_qry() RETURNING g_imgg.imgg01                     
                 CALL q_sel_ima(FALSE, "q_ima", "", g_imgg.imgg01, "", "", "", "" ,"",'' )  RETURNING g_imgg.imgg01
#FUN-AA0059 --End--
                 DISPLAY BY NAME g_imgg.imgg01                                    
                 CALL t337_imgg01()                                              
                 NEXT FIELD imgg01                                               
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
 
FUNCTION t337_loc()
    #取得儲位性質
    IF g_imgg.imgg03 IS NOT NULL THEN
       SELECT ime05,ime06 INTO g_imgg23,g_imgg24 FROM ime_file
        WHERE ime01=g_imgg.imgg02 AND
              ime02=g_imgg.imgg03
		AND imeacti='Y'          #FUN-D40103 add
    ELSE
        SELECT imd11,imd12 INTO g_imgg23,g_imgg24 FROM imd_file
         WHERE imd01=g_imgg.imgg02
    END IF
    IF SQLCA.sqlcode THEN LET g_imgg23=' ' LET g_imgg24=' ' END IF
 
END FUNCTION
 
#need check
FUNCTION t337_imgg01()
DEFINE
    l_ima02 LIKE ima_file.ima02, #品名規格
    l_ima05 LIKE ima_file.ima05, #目前版本
    l_ima08 LIKE ima_file.ima08, #來源碼
    l_ima30 LIKE ima_file.ima30,
    l_ima35 LIKE ima_file.ima35, #CHI-6A0015 add
    l_ima36 LIKE ima_file.ima36, #CHI-6A0015 add
    p_aqty  LIKE imgg_file.imgg10 #MOD-530179
DEFINE   l_n1        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
DEFINE   l_n2        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
DEFINE   l_n3        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044  
 
    LET g_chr=''
#--->單倉管理時,為顯示料件來源碼,版本,品名規格,庫存單位,庫存數量
#.........在此處無法顯示多倉之資料
    IF g_sma.sma12='N' THEN #單倉管理時, 須要將該筆資料鎖住
#       LET g_forupd_sql = " SELECT ima02,ima05,ima08,ima25,(ima261+ima262),",
#      LET g_forupd_sql = " SELECT ima02,ima05,ima08,ima25,",  #No.FUN-9B0040  #NO.FUN-A20044 
       LET g_forupd_sql = " SELECT ima02,ima05,ima08,ima25,0", #NO.FUN-A20044 
                          " 0,ima39,ima30,ima35,ima36 ",     #CHI-6A0015 add ima35/36
                          " FROM ima_file ", #No.TQC-930155
                          " WHERE ima01= ?  AND imaacti='Y' FOR UPDATE"
       LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

       DECLARE imgg01_lock CURSOR FROM g_forupd_sql
 
       OPEN imgg01_lock USING g_imgg.imgg01
       IF STATUS THEN
          CALL cl_err("OPEN imgg01_lock:", STATUS, 1)
          CLOSE imgg01_lock
#          ROLLBACK WORK    #TQC-930155
          RETURN
       END IF
       FETCH imgg01_lock
        INTO l_ima02,l_ima05,l_ima08,g_imgg.imgg09,g_imgg.imgg10,
             p_aqty,g_imgg.ima39, l_ima30,l_ima35,l_ima36           #CHI-6A0015 add ima35/36
       IF SQLCA.sqlcode THEN
          IF SQLCA.sqlcode=-250 OR SQLCA.sqlcode=-263 THEN #LOCKED By another user   #NO.TQC-930155---add263-----
             LET g_chr='L'
          ELSE
             LET g_chr='E'
          END IF
          RETURN
       END IF
       CALL s_getstock(g_imgg.imgg01,g_plant) RETURNING  l_n1,l_n2,l_n3  ###GP5.2  #NO.FUN-A20044
       LET g_imgg.imgg10 = l_n2+l_n3                                     #NO.FUN-A20044 
       IF p_aqty IS NULL THEN
          LET p_aqty=0
       END IF
#No.TQC-AC0033 --start--
#No.FUN-AA0062  --start--
       #IF NOT s_chk_ware(l_ima35) THEN
       #   LET l_ima35 = ''
       #   LET l_ima36 = ''
       # END IF
#No.FUN-AA0062  --end--
#No.TQC-AC0033 --end--
       LET g_imgg.aqty=g_imgg.imgg10-p_aqty   #可收料數量=可用量-備製量
       DISPLAY l_ima02,     #品名規格
               l_ima05,     #版本
               l_ima08,     #來源碼
               g_imgg.imgg09, #庫存單位
               g_imgg.imgg10, #庫存數量
               l_ima30
               #l_ima35,l_ima36    #CHI-6A0015 add  #TQC-750018
         TO    ima02,
               ima05,
               ima08,
               imgg09,
               imgg10,
               ima30
               #imgg02,imgg03      #CHI-6A0015 add  #TQC-750018
                       
       LET g_desc='單倉管理.....'
       DISPLAY g_desc TO FORMONLY.desc
    ELSE
       SELECT ima02,  ima05,  ima08,  ima25,        ima30  ,ima35,  ima36    #CHI-6A0015 add ima35/36
         INTO l_ima02,l_ima05,l_ima08,g_imgg.imgg09,l_ima30,l_ima35,l_ima36  #CHI-6A0015 add ima35/36
         FROM ima_file
        WHERE ima01=g_imgg.imgg01 AND imaacti='Y'
       IF SQLCA.sqlcode THEN LET g_chr='E' RETURN END IF
       DISPLAY l_ima02,l_ima05,l_ima08, l_ima30
            TO ima02,  ima05,  ima08, ima30
       LET g_desc='多倉管理.....'
       DISPLAY g_desc TO FORMONLY.desc
    END IF
    LET g_imgg21 =1
    LET g_imgg211=1
    LET g_imgg.ima25=g_imgg.imgg09
    LET g_imgg.img09=g_imgg.imgg09
    LET g_img.ima25 =g_imgg.imgg09
    LET g_img.img09 =g_imgg.imgg09
    IF cl_null(g_imgg01_t) OR  g_imgg01_t <> g_imgg.imgg01 THEN    #TQC-750018
      LET g_imgg.imgg02 =l_ima35   #CHI-6A0015 add
      LET g_imgg.imgg03 =l_ima36   #CHI-6A0015 add
      DISPLAY BY NAME g_imgg.imgg02,g_imgg.imgg03   #TQC-750018
    END IF
#No.TQC-AC0033 --start--
#No.FUN-AA0062  --start--
    #IF NOT s_chk_ware(l_ima35) THEN
    #   LET l_ima35 = ''
    #   LET l_ima36 = ''
    #END IF
#No.FUN-AA0062  --end--
#No.TQC-AC0033 --end--
END FUNCTION
 
FUNCTION t337_i2()
DEFINE
    l_imgg04 LIKE imgg_file.imgg04,
    l_cmd    LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(30)
    l_direct LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    l_code   LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    p_cmd    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    l_qty    LIKE imgg_file.imgg10   #MOD-530179
DEFINE l_flag       LIKE type_file.chr1    #FUN-C80107 add
DEFINE l_where      STRING                 #FUN-CB0087 add
 
    LET t_imgg02=' '
    LET t_imgg03=' '
    DISPLAY BY NAME 
        g_imgg.imgg02,g_imgg.imgg03,g_imgg.imgg04,g_imgg.imgg09,
        g_imgg.imgg10,g_imgg.imgg08,g_imgg.diff,
        g_imgg.reason                                  #FUN-CB0087---add>g_imgg.reason
        
    INPUT BY NAME
        g_imgg.imgg02,g_imgg.imgg03,g_imgg.imgg04,g_imgg.imgg09,
        g_imgg.imgg10,g_imgg.imgg08,g_imgg.diff,
        g_imgg.reason                                  #FUN-CB0087---add>g_imgg.reason
        WITHOUT DEFAULTS 
 
        BEFORE INPUT                                                              
           LET g_before_input_done = FALSE                                        
           CALL i110_set_entry(p_cmd)                                             
           CALL i110_set_no_entry(p_cmd)                                          
           LET g_before_input_done = TRUE
 
        AFTER FIELD imgg02  #倉庫
           IF g_imgg.imgg02 IS NOT NULL THEN
              #FUN-D20060----add---str--
              IF NOT s_chksmz(g_imgg.imgg01, tno,
                              g_imgg.imgg02, g_imgg.imgg03) THEN
                 NEXT FIELD imgg02
              END IF
              #FUN-D20060----add---end--
 #------>check-1
              IF NOT s_imfchk1(g_imgg.imgg01,g_imgg.imgg02) THEN
                 CALL cl_err(g_imgg.imgg02,'mfg9036',0)
                 NEXT FIELD imgg02
              END IF
 #------>check-2
              CALL s_stkchk(g_imgg.imgg02,'A') RETURNING l_code
              IF NOT l_code THEN 
                 CALL cl_err(g_imgg.imgg02,'mfg1100',0) 
                 NEXT FIELD imgg02
              END IF
              CALL s_swyn(g_imgg.imgg02) RETURNING sn1,sn2
              IF sn1=1 AND g_imgg.imgg02!=t_imgg02 THEN
                 CALL cl_err(g_imgg.imgg02,'mfg6080',0) 
                 LET t_imgg02=g_imgg.imgg02
                 NEXT FIELD imgg02
              ELSE 
                 IF sn2=2 AND g_imgg.imgg02!=t_imgg02 THEN
                    CALL cl_err(g_imgg.imgg02,'mfg6085',0) 
                    LET t_imgg02=g_imgg.imgg02
                    NEXT FIELD imgg02
                 END IF
              END IF
#No.FUN-AA0062  --start--
              IF NOT s_chk_ware(g_imgg.imgg02) THEN
                 NEXT FIELD imgg02
              END IF
#No.FUN-AA0062  --end--
              LET sn1=0 LET sn2=0
              IF g_imgg.imgg02 IS NULL THEN LET g_imgg.imgg02=' ' END IF
	 #IF NOT s_imechk(g_imgg.imgg02,g_imgg.imgg03) THEN NEXT FIELD imgg03 END IF  #FUN-D40103 add #TQC-D50124 mark 
           END IF
 
        AFTER FIELD imgg03  #儲位
           IF g_imgg.imgg03 IS NULL THEN LET g_imgg.imgg03=' ' END IF
           #------------------------------------ 檢查料號預設倉儲及單別預設倉儲
           IF g_imgg.imgg02 IS NOT NULL THEN  #FUN-D20060 add
              IF NOT s_chksmz(g_imgg.imgg01,tno,g_imgg.imgg02, g_imgg.imgg03) THEN
                 NEXT FIELD imgg02
              END IF
           END IF   #FUN-D20060 add
           #------------------------------------------------------ 970715 roger
#------>chk-1
           IF NOT s_imfchk(g_imgg.imgg01,g_imgg.imgg02,g_imgg.imgg03) THEN
              CALL cl_err(g_imgg.imgg03,'mfg6095',0)
              NEXT FIELD imgg03
           END IF
#------>chk-2
           IF g_imgg.imgg03 IS NOT NULL THEN
              CALL s_hqty(g_imgg.imgg01,g_imgg.imgg02,g_imgg.imgg03)
                   RETURNING g_cnt,g_imgg19,g_imf05
              IF g_imgg19 IS NULL THEN LET g_imgg19=0 END IF
              LET h_qty=g_imgg19
              CALL s_lwyn(g_imgg.imgg02,g_imgg.imgg03) RETURNING sn1,sn2
              IF sn1=1 AND g_imgg.imgg03!=t_imgg03 THEN
                 CALL cl_err(g_imgg.imgg03,'mfg6081',0)
                 LET t_imgg03=g_imgg.imgg03
                 NEXT FIELD imgg03
              ELSE 
                 IF sn2=2 AND g_imgg.imgg03!=t_imgg03 THEN
                    CALL cl_err(g_imgg.imgg03,'mfg6086',0)
                    LET t_imgg03=g_imgg.imgg03
                    NEXT FIELD imgg03
                 END IF
              END IF
           END IF
           LET sn1=0 LET sn2=0
           LET l_direct='D'
           IF g_imgg.imgg03 IS NULL THEN LET g_imgg.imgg03=' ' END IF
	 #IF NOT s_imechk(g_imgg.imgg02,g_imgg.imgg03) THEN NEXT FIELD imgg03 END IF  #FUN-D40103 add #TQC-D50124 mark 
 
        BEFORE FIELD imgg04
           CALL i110_set_entry(p_cmd)                                             
 
        AFTER FIELD imgg04  #批號
           IF g_imgg.imgg04 IS NULL THEN LET g_imgg.imgg04=' ' END IF
           IF g_sma.sma26='Y' AND g_imgg.imgg04 IS NULL THEN  #使用批號管理
              NEXT FIELD imgg04
           END IF
           CALL aimt337_img04_a()
           IF INT_FLAG THEN RETURN END IF
           IF g_chr='L' THEN #Locked
              CALL cl_err(g_imgg.imgg04,'aoo-060',0)
              NEXT FIELD imgg04
           END IF
#----->-3333 表該批號不存在, 則庫存單位預設為料件預設庫存單位
#                              借方會計科目預設為{0,1,2}
           IF g_imgno ='-3333' AND g_img.img09 IS NULL THEN
              LET g_img.img09=g_imf05
           END IF
           IF g_imgno ='-3333' THEN 
              CALL s_act(g_imgg.imgg01,g_imgg.imgg02,
                         g_imgg.imgg03) RETURNING  g_img.img26,g_status
           END IF
           IF g_imgg.imgg02 IS NULL AND g_imgg.imgg03 IS NULL 
              AND g_imgg.imgg04 IS NULL THEN 
              CALL cl_err(' ','mfg6097',0)
              NEXT FIELD imgg02 
           END IF 
           IF g_ima906='3' THEN
              CALL aimt337_imgg09_a()
              IF INT_FLAG THEN RETURN END IF
              IF g_chr='L' THEN #Locked
                 CALL cl_err(g_imgg.imgg09,'aoo-060',0)
                 NEXT FIELD imgg02
              END IF
#----->-3333 表該批號不存在, 則庫存單位預設為料件預設庫存單位
#                              借方會計科目預設為{0,1,2}
              IF g_imggno ='-3333' THEN
                 CALL s_act(g_imgg.imgg01,g_imgg.imgg02,
                            g_imgg.imgg03) RETURNING  g_imgg.imgg26,g_status
              END IF
              IF g_imgg.imgg02 IS NULL AND g_imgg.imgg03 IS NULL AND 
                 g_imgg.imgg04 IS NULL AND cl_null(g_imgg.imgg09) THEN 
                 CALL cl_err(' ','mfg6097',0)
                 NEXT FIELD imgg02 
              END IF 
           END IF
           CALL i110_set_no_entry(p_cmd)                                          
 
        AFTER FIELD imgg09
           IF NOT cl_null(g_imgg.imgg09) THEN
              CALL t337_unit(g_imgg.imgg09)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD imgg09
              END IF
              CALL aimt337_imgg09_a()
              IF INT_FLAG THEN RETURN END IF
              IF g_chr='L' THEN #Locked
                 CALL cl_err(g_imgg.imgg09,'aoo-060',0)
                 NEXT FIELD imgg09
              END IF
#----->-3333 表該批號不存在, 則庫存單位預設為料件預設庫存單位
#                              借方會計科目預設為{0,1,2}
              IF g_imggno ='-3333' THEN
                 CALL s_act(g_imgg.imgg01,g_imgg.imgg02,
                            g_imgg.imgg03) RETURNING  g_imgg.imgg26,g_status
              END IF
              IF g_imgg.imgg02 IS NULL AND g_imgg.imgg03 IS NULL AND 
                 g_imgg.imgg04 IS NULL AND cl_null(g_imgg.imgg09) THEN 
                 CALL cl_err(' ','mfg6097',0)
                 NEXT FIELD imgg02 
              END IF 
           END IF 
 
        AFTER FIELD imgg08  #盤點數量
           IF g_imgg.imgg08 < 0 THEN
              NEXT FIELD imgg08
           ELSE 
              LET g_imgg.diff = g_imgg.imgg08 - g_imgg.imgg10  #盤盈/虧數量
              DISPLAY BY NAME g_imgg.diff
              IF g_imgg.diff < 0 THEN 
                 LET l_qty = g_imgg.diff * -1 
                #IF l_qty > g_imgg.aqty AND g_sma.sma894[8,8]='N' THEN  #FUN-C80107 mark
                 LET l_flag = NULL    #FUN-C80107 add
                 #CALL s_inv_shrt_by_warehouse(g_sma.sma894[8,8],g_imgg.imgg02) RETURNING l_flag   #FUN-C80107 add #FUN-D30024--mark
                 CALL s_inv_shrt_by_warehouse(g_imgg.imgg02,g_plant) RETURNING l_flag                   #FUN-D30024--add #TQC-D40078 g_plant
                 IF l_qty > g_imgg.aqty AND l_flag = 'N' THEN           #FUN-C80107 add
                    #盤虧時考慮備料/備置數量
                    CALL cl_err(' ','mfg6111',0)
                    NEXT FIELD imgg08
                 END IF
              END IF
           END IF
        #FUN-CB0087--add--str
        BEFORE FIELD reason
           IF g_aza.aza115 = 'Y' AND cl_null(g_imgg.reason) THEN
              CALL s_reason_code(tno,'','',g_imgg.imgg01,g_imgg.imgg02,'','') RETURNING g_imgg.reason
              DISPLAY BY NAME g_imgg.reason
              CALL t337_reason()
           END IF

        AFTER FIELD reason
           IF NOT t337_reason_chk() THEN
              NEXT FIELD reason
           ELSE
              CALL t337_reason()
           END IF
        #FUN-CB0087--add--end
       
        AFTER INPUT
           IF g_imgg.imgg02 IS NULL THEN LET g_imgg.imgg02= ' ' END IF
           IF g_imgg.imgg03 IS NULL THEN LET g_imgg.imgg03= ' ' END IF
           IF g_imgg.imgg04 IS NULL THEN LET g_imgg.imgg04= ' ' END IF
{@}        IF NOT INT_FLAG AND g_sma.sma12 ='Y' AND
              (g_imgg.imgg02 IS NULL OR
               g_imgg.imgg08 IS NULL) THEN
               DISPLAY BY NAME g_imgg.imgg02,g_imgg.imgg08 
               CALL cl_err('',9033,0)
               NEXT FIELD imgg02
           END IF
           #FUN-CB0087---add---str---
           IF NOT t337_reason_chk() THEN
              NEXT FIELD reason
           END IF
           #FUN-CB0087--add--end
 
        ON ACTION controlp                                                      
           CASE                                                                 
              WHEN INFIELD(imgg02) #倉庫                                         
                 CALL cl_init_qry_var()                                         
#No.FUN-AA0062  --start--
#                 LET g_qryparam.form     = "q_imfd"                             
#                 LET g_qryparam.default1 = g_imgg.imgg02                          
#                 LET g_qryparam.arg1     = "A"                                  
#                 LET g_qryparam.arg2     = g_imgg.imgg01                        
#                 CALL cl_create_qry() RETURNING g_imgg.imgg02                     
#                 DISPLAY BY NAME g_imgg.imgg02  
                 LET g_qryparam.form     = "q_imgg"                             
                 LET g_qryparam.default1 = g_imgg.imgg02                          
                 LET g_qryparam.default2 = g_imgg.imgg03                          
                 LET g_qryparam.default3 = g_imgg.imgg04                          
                 LET g_qryparam.arg1     = g_imgg.imgg01                                  
                 CALL cl_create_qry() RETURNING g_imgg.imgg02,g_imgg.imgg03,g_imgg.imgg04                  
                 DISPLAY BY NAME g_imgg.imgg02,g_imgg.imgg03,g_imgg.imgg04                                    
#No.FUN-AA0062  --end--
                 NEXT FIELD imgg02                                               
              WHEN INFIELD(imgg03) #儲位                                         
                 CALL cl_init_qry_var()    
#No.FUN-AA0062  --start--                                                       
#                 LET g_qryparam.form     = "q_imfe03"  #MOD-4A0252 儲位開窗                    
#                 LET g_qryparam.default1 = g_imgg.imgg03                          
#                 LET g_qryparam.arg1     = "A"                                  
#                 LET g_qryparam.arg2     = g_imgg.imgg02                          
#                 CALL cl_create_qry() RETURNING g_imgg.imgg03                     
#                 DISPLAY BY NAME g_imgg.imgg02,g_imgg.imgg03   
                 LET g_qryparam.form     = "q_imgg"                             
                 LET g_qryparam.default1 = g_imgg.imgg02                          
                 LET g_qryparam.default2 = g_imgg.imgg03                          
                 LET g_qryparam.default3 = g_imgg.imgg04                          
                 LET g_qryparam.arg1     = g_imgg.imgg01                                  
                 CALL cl_create_qry() RETURNING g_imgg.imgg02,g_imgg.imgg03,g_imgg.imgg04                     
                 DISPLAY BY NAME g_imgg.imgg02,g_imgg.imgg03,g_imgg.imgg04                                    
#No.FUN-AA0062  --end--                     
                 NEXT FIELD imgg03                                               
              WHEN INFIELD(imgg04) #LOTS                                         
                 CALL cl_init_qry_var()   
#No.FUN-AA0062  --start--                                          
#                 LET g_qryparam.form     = "q_imgg"                              
#                 LET g_qryparam.default1 = g_imgg.imgg04  
#                 LET g_qryparam.arg1     = g_imgg.imgg01                          
#                 LET g_qryparam.arg2     = g_imgg.imgg02                          
#                 LET g_qryparam.arg3     = g_imgg.imgg03                          
#                 LET g_qryparam.arg4     = g_imgg.imgg04                          
#                 CALL cl_create_qry() RETURNING g_imgg.imgg04                     
#                 DISPLAY BY NAME g_imgg.imgg04     
                 LET g_qryparam.form     = "q_imgg"                             
                 LET g_qryparam.default1 = g_imgg.imgg02                          
                 LET g_qryparam.default2 = g_imgg.imgg03                          
                 LET g_qryparam.default3 = g_imgg.imgg04                          
                 LET g_qryparam.arg1     = g_imgg.imgg01                                  
                 CALL cl_create_qry() RETURNING g_imgg.imgg02,g_imgg.imgg03,g_imgg.imgg04                      
                 DISPLAY BY NAME g_imgg.imgg02,g_imgg.imgg03,g_imgg.imgg04                                    
#No.FUN-AA0062  --end--                                     
                 NEXT FIELD imgg04                                               
              WHEN INFIELD(imgg09) #單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.default1 = g_imgg.imgg09
                 CALL cl_create_qry() RETURNING g_imgg.imgg09
                 DISPLAY BY NAME g_imgg.imgg09
                 NEXT FIELD imgg09
              #FUN-CB0087---add---str---
              WHEN INFIELD(reason)
                 CALL s_get_where(tno,'','',g_imgg.imgg01,g_imgg.imgg02,'','') RETURNING l_flag,l_where
                 IF g_aza.aza115='Y' AND l_flag THEN
                    CALL cl_init_qry_var()
                    LET g_qryparam.form     ="q_ggc08"
                    LET g_qryparam.where = l_where
                    LET g_qryparam.default1 = g_imgg.reason
                 ELSE
                    CALL cl_init_qry_var()
                    LET g_qryparam.form     ="q_azf41"
                    LET g_qryparam.default1 = g_imgg.reason
                 END IF
                 CALL cl_create_qry() RETURNING g_imgg.reason
                 DISPLAY BY NAME g_imgg.reason
                 CALL t337_reason()
                 NEXT FIELD reason
              #FUN-CB0087---add---end---
              OTHERWISE EXIT CASE                                               
           END CASE                    
 
        ON ACTION mntn_stock
           LET l_cmd = 'aimi200 x'
           CALL cl_cmdrun(l_cmd)
 
        ON ACTION mntn_loc
           LET l_cmd = "aimi201 '",g_imgg.imgg02,"'" #BugNo:6598
           CALL cl_cmdrun(l_cmd)
 
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
      CALL cl_set_comp_entry("imgg02,imgg03,imgg04",TRUE)              
   END IF                                                                       
                                                                                
   CALL cl_set_comp_entry("imgg09",TRUE)              
END FUNCTION                                                                    
                                                                                
FUNCTION i110_set_no_entry(p_cmd)                                               
DEFINE   p_cmd   LIKE type_file.chr1                                                            #No.FUN-690026 VARCHAR(1)
                                                                                
   IF NOT g_before_input_done THEN                          
      IF g_sma.sma12!='Y' THEN                                                 
         CALL cl_set_comp_entry("imgg02,imgg03,imgg04",FALSE)          
      END IF                                                                    
   END IF                            
   IF g_ima906='3' THEN
      CALL cl_set_comp_entry("imgg09",FALSE)
   END IF
END FUNCTION
   
#取得該倉庫/ 儲位的相關數量資料
FUNCTION aimt337_imgg09_a()
DEFINE
#    c        LIKE ima_file.ima262,
    c        LIKE type_file.num15_3,  #No.FUN-9B0040
    l_imgg19 LIKE imgg_file.imgg19   #庫存等級  
 
    LET g_chr=''
    IF g_imgg.imgg02 IS NULL THEN LET g_imgg.imgg02 = ' ' END IF
    IF g_imgg.imgg03 IS NULL THEN LET g_imgg.imgg03=' ' END IF
    IF g_imgg.imgg04 IS NULL THEN LET g_imgg.imgg04=' ' END IF
    LET g_sql=
#       "SELECT imgg01,imgg02,imgg03,imgg04,imgg09,imgg10,imgg19,imgg26,imgg23,imgg24,imgg21,imgg36,imgg211",
        "SELECT '',imgg10,imgg19,imgg26,imgg23,imgg24,imgg21,imgg36,imgg211",  #wujie 091020
        " FROM imgg_file",
        " WHERE imgg01='",g_imgg.imgg01,"'" 
    IF g_imgg.imgg02 IS NOT NULL THEN
       LET g_sql=g_sql CLIPPED," AND imgg02='", g_imgg.imgg02,"'"
    ELSE
       LET g_sql=g_sql CLIPPED," AND imgg02 IS NULL"
    END IF
    IF g_imgg.imgg03 IS NOT NULL THEN
       LET g_sql=g_sql CLIPPED," AND imgg03='", g_imgg.imgg03,"'"
    ELSE
       LET g_sql=g_sql CLIPPED," AND imgg03 IS NULL"
    END IF
    IF g_imgg.imgg04 IS NOT NULL THEN
       LET g_sql=g_sql CLIPPED," AND imgg04='", g_imgg.imgg04,"'"
    ELSE
       LET g_sql=g_sql CLIPPED," AND imgg04 IS NULL"
    END IF
    LET g_sql=g_sql CLIPPED," AND imgg09='",g_imgg.imgg09,"'"
    LET g_sql=g_sql CLIPPED," FOR UPDATE"
    LET g_sql=cl_forupd_sql(g_sql)

    PREPARE imgg09_p FROM g_sql
    DECLARE imgg09_lock CURSOR FOR imgg09_p
    OPEN imgg09_lock
#No.TQC-930155-start-
    IF SQLCA.sqlcode THEN
       IF SQLCA.sqlcode=-250 OR SQLCA.sqlcode=-263 THEN #LOCKED By another user
          LET g_chr='L'
       ELSE
          LET g_chr='E'
          LET g_imggno='-3333'
          #NO.TQC-930155---------begin---------
          CALL t337_get_img()
          #SELECT ime05,ime06 INTO g_imgg23,g_imgg24
          # FROM ime_file WHERE ime01=g_imgg.imgg02
          #                 AND ime02=g_imgg.imgg03
          #IF STATUS THEN
          #   LET g_imgg23=' '
          #   LET g_imgg24=' '
          #END IF
#----->為新增的庫存明細,開窗輸入相關資料
          #CALL aimt3371()
          #LET g_imgg21 =g_imgg.ima25_fac
          #LET g_imgg211=g_imgg.img09_fac
          #No.TQC-930155---------end-----------
       END IF
       #LET g_imgg.imgg10=0   #NO.TQC-930155--mark---
       RETURN
    END IF
#No.TQC-930155--end--
    FETCH imgg09_lock 
     INTO g_imggno,g_imgg.imgg10, g_imgg.imgg19,
          g_imgg.imgg26,g_imgg23,g_imgg24,g_imgg21,
          g_imgg.imgg36,g_imgg211
    IF SQLCA.sqlcode THEN
       IF SQLCA.sqlcode=-250 OR SQLCA.sqlcode=-263 THEN #LOCKED By another user #NO.TQC-930155---add263-----
          LET g_chr='L'
       ELSE
          LET g_chr='E'
          LET g_imggno='-3333'
          CALL t337_get_img()
#----->為新增的庫存明細,開窗輸入相關資料
       END IF
    END IF
END FUNCTION



FUNCTION t337_get_img()
 
   IF NOT cl_null(g_chr) THEN
      SELECT ime05,ime06 INTO g_imgg23,g_imgg24
         FROM ime_file WHERE ime01=g_imgg.imgg02
                         AND ime02=g_imgg.imgg03
			AND imeacti='Y'          #FUN-D40103
      IF STATUS THEN
         LET g_imgg23=' '
         LET g_imgg24=' '
      END IF
      #----->為新增的庫存明細,開窗輸入相關資料
      CALL aimt3371()
      LET g_imgg21 =g_imgg.ima25_fac
      LET g_imgg211=g_imgg.img09_fac
      LET g_imgg.imgg10=0
   END IF
 
   LET g_imgg.aqty=g_imgg.imgg10
   LET g_imgg.ima25_fac=g_imgg21
   LET g_imgg.img09_fac=g_imgg211
   LET g_desc=' '
   DISPLAY g_desc TO FROMONLY.desc
   IF g_imggno='-3333' THEN
      LET g_desc='尚未存在之倉庫/儲位/批號/單位'
   ELSE
      CALL s_wardesc(g_imgg23,g_imgg24) RETURNING g_desc
   END IF
   IF g_imggno='-3333' THEN
      CALL t337_loc()
   END IF
   DISPLAY BY NAME g_imgg.imgg10,g_imgg.imgg19,g_imgg.imgg36
   DISPLAY g_desc TO FORMONLY.desc
END FUNCTION
#NO.TQC-930155---------------end-------------
#--------------------------------------------------------------------
#更新相關的檔案
FUNCTION t337_t()
DEFINE
    l_qty   LIKE imgg_file.imgg08,
    l_qty1  LIKE imgg_file.imgg08,
    l_code  LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    LET l_qty =g_imgg.diff * g_imgg21    #ima qty
    LET l_qty1=g_imgg.diff * g_imgg211   #img qty
    IF l_qty  IS NULL THEN RETURN 1 END IF
    IF l_qty1 IS NULL THEN RETURN 1 END IF
 
    IF g_ima906='3' THEN
       LET l_qty =0
       LET l_qty1=0
    END IF
#更新倉庫庫存明細資料
#--->單倉與多倉已在(s_upimg.4gl 處理掉)
#                1           2  3     4
    CALL s_upimg(g_imgg.imgg01,g_imgg.imgg02,g_imgg.imgg03,g_imgg.imgg04,2,l_qty1,g_imgg.imgg14, #FUN-8C0084
#       5             6             7             8             9
        g_imgg.imgg01,g_imgg.imgg02,g_imgg.imgg03,g_imgg.imgg04,'CYCLE CNT',
#       10 11          12     13
        '',g_img.img09,l_qty1,g_img.img09,
#       14              15              16
        g_img.img09_fac,g_img.ima25_fac,1,
#       17          18            19          20          21
        g_img.img26,g_img.img35_2,g_img.img27,g_img.img28,g_img.img19,
#       22
        g_img.img36)
    IF g_success = 'N' THEN RETURN 1 END IF
 
#  若庫存異動後其庫存量小於等於零時將該筆資料刪除
    CALL s_delimg(g_imgg.imgg01,g_imgg.imgg02,g_imgg.imgg03,g_imgg.imgg04) #FUN-8C0084
#更新庫存主檔之庫存數量 (單位為主檔之庫存單位)
    IF s_udima(g_imgg.imgg01,          #料件編號
               g_imgg23,               #是否可用倉儲
               g_imgg24,               #是否為MRP可用倉儲
               l_qty,                  #盤盈/虧數量(庫存單位)
               g_imgg.imgg14,          #最近一次盤點日期
               2 )                     #表盤點
        THEN RETURN 1 
    END IF
    IF g_success = 'N' THEN RETURN 1 END IF
 
#產生異動記錄資料
    CALL t337_free()
    CALL t337_log(1,0,'',g_imgg.imgg01,l_qty1)
    CALL t337_imgg()
    CALL t337_tlff(g_imgg.imgg01,g_imgg.diff,l_qty1)
    RETURN 0
END FUNCTION
 
FUNCTION t337_free()
    IF g_sma.sma12='N' THEN
       CLOSE imgg01_lock
    ELSE
#       CLOSE img04_lock
       CLOSE imgg09_lock #將已鎖住之資料釋放出來
    END IF
END FUNCTION
 
#--------------------------------------------------------------------
#處理異動記錄
FUNCTION t337_log(p_stdc,p_reason,p_code,p_item,p_qty)
DEFINE
    l_pmn02         LIKE pmn_file.pmn02,    #採購單性質
    p_stdc          LIKE type_file.num5,    #是否需取得標準成本  #No.FUN-690026 SMALLINT
    p_reason        LIKE type_file.num5,    #是否需取得異動原因  #No.FUN-690026 SMALLINT
    p_code          LIKE type_file.chr20,   #No.FUN-690026 VARCHAR(04)
    p_item          LIKE ima_file.ima01,    #No.FUN-690026 VARCHAR(20)
    p_qty           LIKE img_file.img10,
    l_qty           LIKE imgg_file.imgg08 #MOD-530179     #異動數量
 
#----來源----
#-----modify by pin 1992/05/25
    IF g_imgg.imgg03 IS NULL THEN LET g_imgg.imgg03=' ' END IF
    IF g_imgg.imgg04 IS NULL THEN LET g_imgg.imgg04=' ' END IF
    IF p_qty < 0 THEN 
        LET l_qty      =p_qty * -1
        #----來源----
        LET g_tlf.tlf02 =50                         #來源為倉庫(盤虧)
        LET g_tlf.tlf020=g_plant                    #工廠別
        LET g_tlf.tlf021=g_imgg.imgg02              #倉庫別
        LET g_tlf.tlf022=g_imgg.imgg03              #儲位別
        LET g_tlf.tlf023=g_imgg.imgg04              #入庫批號
        LET g_tlf.tlf024=g_img.img10+ p_qty         #(+/-)異動後庫存數量
        LET g_tlf.tlf025=g_img.img09                #庫存單位(ima or imgg)
        LET g_tlf.tlf026=tno                        #調整單號
        LET tno_seq     =tno_seq + 1
        LET g_tlf.tlf027=tno_seq                    #調整項次
        #----目的----
        LET g_tlf.tlf03 =0                          #目的為盤點
        LET g_tlf.tlf030=g_plant                    #工廠別
        LET g_tlf.tlf031=''                         #倉庫別
        LET g_tlf.tlf032=''                         #儲位別
        LET g_tlf.tlf033=''                         #批號
        LET g_tlf.tlf034=''                         #異動後庫存數量
        LET g_tlf.tlf035=' '                        #庫存單位
        LET g_tlf.tlf036='CYCLE'                    #週期盤點
        LET g_tlf.tlf037=''
 
        LET g_tlf.tlf15=g_imgg.credit               #貸方會計科目(盤虧)
        LET g_tlf.tlf16=g_imgg.ima39                #料件會計科目(存貨)
    ELSE 
        LET l_qty      =p_qty          
        #----來源----
        LET g_tlf.tlf02=0                           #來源為盤點(盤盈)
        LET g_tlf.tlf020=g_plant                    #工廠別
        LET g_tlf.tlf021=''                         #倉庫別
        LET g_tlf.tlf022=''                         #儲位別
        LET g_tlf.tlf023=''                         #批號
        LET g_tlf.tlf024=''                         #異動後庫存數量
        LET g_tlf.tlf025=' '                        #庫存單位
        LET g_tlf.tlf026='CYCLE'                    #週期盤點
        LET g_tlf.tlf027=''
        #----目的----
        LET g_tlf.tlf03=50                           #目的為倉庫
        LET g_tlf.tlf030=g_plant                     #工廠別
        LET g_tlf.tlf031=g_imgg.imgg02               #倉庫別
        LET g_tlf.tlf032=g_imgg.imgg03               #儲位別
        LET g_tlf.tlf033=g_imgg.imgg04               #入庫批號
        LET g_tlf.tlf034=g_img.img10+ p_qty          #(+/-)異動後庫存數量
        LET g_tlf.tlf035=g_img.img09                 #庫存單位(ima or imgg)
        LET g_tlf.tlf036=tno                         #調整單號
        LET tno_seq     =tno_seq + 1
        LET g_tlf.tlf037=tno_seq                     #調整項次
        LET g_tlf.tlf15=g_imgg.ima39                 #料件會計科目(存貨)
        LET g_tlf.tlf16=g_imgg.credit                #貸方會計科目(盤盈)
    END IF
 
    LET g_tlf.tlf01=p_item                           #異動料件編號
#--->異動數量 
    LET g_tlf.tlf04=' '                              #工作站
    LET g_tlf.tlf05=' '                              #作業序號
    LET g_tlf.tlf06=g_imgg.imgg14                    #盤點日期
    LET g_tlf.tlf07=g_today                          #異動資料產生日期  
    LET g_tlf.tlf08=TIME                             #異動資料產生時:分:秒
    LET g_tlf.tlf09=g_user                           #產生人
    LET g_tlf.tlf10=l_qty                            #盤盈/虧數量(皆為正值)
    LET g_tlf.tlf11=g_img.img09                      #庫存單位
    LET g_tlf.tlf12=1                                #單位轉換率
    LET g_tlf.tlf13='aimt337'                        #異動命令代號
    #LET g_tlf.tlf14=''                               #異動原因    #FUN-CB0087 mark
    LET g_tlf.tlf14=g_imgg.reason                                  #FUN-CB0087 add
    LET g_tlf.tlf905=tno                             #調整單號
    CALL s_imaQOH(g_imgg.imgg01)
         RETURNING g_tlf.tlf18                       #異動後總庫存量
    LET g_tlf.tlf19= ' '                             #異動廠商/客戶編號
    LET g_tlf.tlf20= ' '                             #project no. 
    LET g_tlf.tlf930=g_imgg.dept #FUN-670093
    CALL s_tlf(p_stdc,p_reason)
END FUNCTION
   
FUNCTION aimt3371()
  DEFINE l_imgg26 LIKE imgg_file.imgg26,
         l_status LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
         l_direct LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
 
    OPEN WINDOW t3371_w AT 8,21
         WITH FORM "aim/42f/aimt3371"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aimt3371")
 
    IF g_imgg.imgg28 IS NULL THEN LET g_imgg.imgg28=99 END IF
 
    DISPLAY g_imgg.imgg35_2 TO imgg35_2
    LET g_imgg.ima25_fac=NULL
    LET g_imgg.img09_fac=NULL
    INPUT BY NAME g_imgg.ima25_fac,g_imgg.ima25,
                  g_imgg.img09_fac,g_imgg.img09,
                  g_imgg.imgg26,g_imgg.imgg19,g_imgg.imgg36,  #FUN-560183 del g_imgg.ima86
                  g_imgg.imgg27,g_imgg.imgg28,g_imgg.imgg35_2
         WITHOUT DEFAULTS 
 
        BEFORE FIELD ima25_fac 
           IF g_imgg.ima25 = g_imgg.imgg09 THEN
              LET g_imgg.ima25_fac=1
              DISPLAY g_imgg.ima25_fac TO ima25_fac
           ELSE
              CALL s_umfchk(g_imgg.imgg01,g_imgg.imgg09,g_imgg.ima25)
                   RETURNING g_cnt,g_imgg.ima25_fac
              IF cl_null(g_imgg.ima25_fac) THEN LET g_imgg.ima25_fac=1 END IF
              DISPLAY g_imgg.ima25_fac TO ima25_fac
           END IF
 
        BEFORE FIELD img09_fac 
           IF g_imgg.img09 = g_imgg.imgg09 THEN
              LET g_imgg.img09_fac=1
              DISPLAY g_imgg.img09_fac TO img09_fac
           ELSE
              CALL s_umfchk(g_imgg.imgg01,g_imgg.imgg09,g_imgg.img09)
                   RETURNING g_cnt,g_imgg.img09_fac
              IF cl_null(g_imgg.img09_fac) THEN LET g_imgg.img09_fac=1 END IF
              DISPLAY g_imgg.img09_fac TO img09_fac
           END IF
 
        BEFORE FIELD imgg26
            CALL s_act(g_imgg.imgg01,g_imgg.imgg02,g_imgg.imgg03)
                 RETURNING l_imgg26,l_status
            IF l_status ='0' AND g_imgg.imgg26 IS NULL 
               THEN CALL cl_err(g_imgg.imgg26,'mfg6112',0)
            END IF
            IF l_status MATCHES '[12]' THEN
               LET g_imgg.imgg26=l_imgg26 
               DISPLAY BY NAME g_imgg.imgg26
            END IF
            IF l_direct='D' THEN
               NEXT FIELD imgg19
            END IF
                     
        AFTER FIELD imgg26   #會計科目
            IF l_status ='0' THEN
               IF g_sma.sma03='Y' THEN
                 IF NOT s_actchk3(g_imgg.imgg26,g_bookno1) THEN  #No.FUN-730033
                    CALL cl_err(g_imgg.imgg26,'mfg0018',0)
                    NEXT FIELD imgg26 
                 END IF
               END IF
            END IF
 
        AFTER FIELD imgg27
            LET l_direct='U'
 
        AFTER FIELD imgg35_2   #專案號碼
            IF NOT cl_null(g_imgg.imgg35_2) THEN
              #FUN-810045 begin
               #SELECT gja01 FROM gja_file
               # WHERE gja01=g_imgg.imgg35_2
               SELECT pja01 FROM pja_file
                WHERE pja01=g_imgg.imgg35_2
                  AND pjaacti = 'Y'
                  AND pjaclose = 'N'                     #No.FUN-960038 
              #FUN-810045 end
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_imgg.imgg35,'mfg3064',0) #No.FUN-660156
                  CALL cl_err3("sel","pja_file",g_imgg.imgg35,"","mfg3064",  #FUN-810045 gja->pja
                               "","",1)  #No.FUN-660156
                  NEXT FIELD imgg35_2
               END IF
            END IF
 
        ON ACTION controlp                                                      
           CASE                                                                 
              WHEN INFIELD(imgg26) #會計科目                                     
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form     = "q_aag"                              
                 LET g_qryparam.default1 = g_imgg.imgg26                          
                 LET g_qryparam.arg1 = g_bookno1  #No.FUN-730033
                 CALL cl_create_qry() RETURNING g_imgg.imgg26                     
                 DISPLAY BY NAME g_imgg.imgg26                                    
                 NEXT FIELD imgg26                                               
              WHEN INFIELD(imgg35_2) #專案名稱                                   
                 CALL cl_init_qry_var()                                         
                #LET g_qryparam.form     = "q_gja"    $FUN-810045
                 LET g_qryparam.form     = "q_pja"   #FUN-810045 
                 LET g_qryparam.default1 = g_imgg.imgg35_2                        
                 CALL cl_create_qry() RETURNING g_imgg.imgg35_2                   
                 DISPLAY BY NAME g_imgg.imgg35_2                                  
                 NEXT FIELD imgg35_2                                             
               OTHERWISE EXIT CASE                                              
           END CASE                                                            
                                
        ON ACTION mntn_prj
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
    CLOSE WINDOW t3371_w
    DISPLAY BY NAME g_imgg.imgg19,g_imgg.imgg36
END FUNCTION
 
#取得該倉庫/ 儲位的相關數量資料
FUNCTION aimt337_img04_a()
DEFINE
#    c        LIKE ima_file.ima262,
    c        LIKE type_file.num15_3,   #No.FUN-9B0040
    l_imgg19 LIKE imgg_file.imgg19   #庫存等級  
 
    LET g_chr=''
    IF g_imgg.imgg02 IS NULL THEN LET g_imgg.imgg02 = ' ' END IF
    IF g_imgg.imgg03 IS NULL THEN LET g_imgg.imgg03 = ' ' END IF
    IF g_imgg.imgg04 IS NULL THEN LET g_imgg.imgg04 = ' ' END IF
    LET g_sql=
#       "SELECT imgg01,imgg02,imgg03,imgg04,imgg09,img09,img10,img19,img26,img23,img24,img21,img36 ",
        "SELECT '',img09,img10,img19,img26,img23,img24,img21,img36 ",    #wujie 091020
        "  FROM img_file",
        " WHERE img01='",g_imgg.imgg01,"'" 
    IF g_imgg.imgg02 IS NOT NULL THEN
       LET g_sql=g_sql CLIPPED," AND img02='", g_imgg.imgg02,"'"
    ELSE
       LET g_sql=g_sql CLIPPED," AND img02 IS NULL"
    END IF
    IF g_imgg.imgg03 IS NOT NULL THEN
       LET g_sql=g_sql CLIPPED," AND img03='", g_imgg.imgg03,"'"
    ELSE
       LET g_sql=g_sql CLIPPED," AND img03 IS NULL"
    END IF
    IF g_imgg.imgg04 IS NOT NULL THEN
       LET g_sql=g_sql CLIPPED," AND img04='", g_imgg.imgg04,"'"
    ELSE
       LET g_sql=g_sql CLIPPED," AND img04 IS NULL"
    END IF
    LET g_sql=g_sql CLIPPED," FOR UPDATE"
    LET g_sql=cl_forupd_sql(g_sql)

    PREPARE img04_p FROM g_sql
    DECLARE img04_lock CURSOR FOR img04_p
    OPEN img04_lock
    #NO.TQC-930155-----begin-------
    IF SQLCA.sqlcode THEN
       IF SQLCA.sqlcode=-250 OR SQLCA.sqlcode=-263 THEN #LOCKED By another user  #NO.TQC-930155---add263-----
          LET g_chr='L'
       ELSE
          LET g_chr='E'
          LET g_imgno='-3333'
          SELECT ime05,ime06 INTO g_img.img23,g_img.img24
           FROM ime_file WHERE ime01=g_imgg.imgg02
                           AND ime02=g_imgg.imgg03
				AND imeacti='Y'          #FUN-D40103 add
          IF STATUS THEN
             LET g_img.img23=' '
             LET g_img.img24=' '
          END IF
#----->為新增的庫存明細,開窗輸入相關資料
          CALL aimt3071()
       END IF
       LET g_img.img10=0
       RETURN
    END IF
    #NO.TQC-930155------end------------
    FETCH img04_lock 
     INTO g_imgno,g_img.img09,g_img.img10,g_img.img19,
          g_img.img26,g_img.img23,g_img.img24,g_img.img21,g_img.img36
    IF SQLCA.sqlcode THEN
       IF SQLCA.sqlcode=-250 OR SQLCA.sqlcode=-263 THEN #LOCKED By another user  #NO.TQC-930155---add263-----
          LET g_chr='L'
       ELSE
          LET g_chr='E'
          LET g_imgno='-3333'
          SELECT ime05,ime06 INTO g_img.img23,g_img.img24
           FROM ime_file WHERE ime01=g_imgg.imgg02
                           AND ime02=g_imgg.imgg03
				AND imeacti='Y'          #FUN-D40103 add
          IF STATUS THEN 
             LET g_img.img23=' '
             LET g_img.img24=' '
          END IF
#----->為新增的庫存明細,開窗輸入相關資料
          CALL aimt3071()    
       END IF
       LET g_img.img10=0
    END IF
    IF g_ima906='3' THEN
       SELECT imgg09,imgg10 INTO g_imgg.imgg09,g_imgg.imgg10
         FROM imgg_file
        WHERE imgg01=g_imgg.imgg01
          AND imgg02=g_imgg.imgg02
          AND imgg03=g_imgg.imgg03
          AND imgg04=g_imgg.imgg04
       IF cl_null(g_imgg.imgg10) THEN LET g_imgg.imgg10=0 END IF
    END IF
    LET g_img.aqty=g_img.img10
    LET g_desc=' '
    IF g_imgno='-3333' THEN 
       LET g_desc='尚未存在之倉庫/儲位/批號'
    ELSE 
       CALL s_wardesc(g_img.img23,g_img.img24) RETURNING g_desc
    END IF
    IF g_imgno='-3333' THEN
       #取得儲位性質
       IF g_imgg.imgg03 IS NOT NULL THEN
          SELECT ime05,ime06 INTO g_img.img23,g_img.img24 FROM ime_file
           WHERE ime01=g_imgg.imgg02
             AND ime02=g_imgg.imgg03
		AND imeacti='Y'          #FUN-D40103 add
       ELSE
           SELECT imd11,imd12 INTO g_img.img23,g_img.img24 FROM imd_file
            WHERE imd01=g_imgg.imgg02
       END IF
       IF SQLCA.sqlcode THEN LET g_img.img23=' ' LET g_img.img24=' ' END IF
       IF g_ima906='3' THEN LET g_imgg.imgg09=g_ima907 END IF
    END IF
    DISPLAY BY NAME g_imgg.imgg09
    DISPLAY BY NAME g_imgg.imgg10
END FUNCTION
 
FUNCTION aimt3071()
  DEFINE l_img26  LIKE img_file.img26,
         l_status LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
         l_direct LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
 
    OPEN WINDOW t3071_w AT 8,21
         WITH FORM "aim/42f/aimt3021"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aimt3021")
 
    IF g_img.img28 IS NULL THEN LET g_img.img28=99 END IF
 
    INPUT BY NAME g_img.ima25_fac,g_img.ima25,
                  g_img.img26,g_img.img19,g_img.img36,
                  g_img.img27,g_img.img28,g_img.img35_2
         WITHOUT DEFAULTS 
 
        BEFORE FIELD ima25_fac 
           IF g_img.ima25 = g_img.img09 THEN
              LET g_img.ima25_fac=1
              DISPLAY g_img.ima25_fac TO ima25_fac
           END IF
 
        BEFORE FIELD img26
           CALL s_act(g_imgg.imgg01,g_imgg.imgg02,g_imgg.imgg03)
                RETURNING l_img26,l_status
           IF l_status ='0' AND g_img.img26 IS NULL THEN
              CALL cl_err(g_img.img26,'mfg6112',0)
           END IF
           IF l_status MATCHES '[12]' THEN
              LET g_img.img26=l_img26 
              DISPLAY BY NAME g_img.img26
           END IF
           IF l_direct='D' THEN
              NEXT FIELD img19
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
             #FUN-810045 begin
              #SELECT gja01 FROM gja_file
              # WHERE gja01=g_img.img35_2
              SELECT pja01 FROM pja_file
               WHERE pja01=g_img.img35_2
                 AND pjaacti = 'Y'
                 AND pjaclose = 'N'                     #No.FUN-960038 
             #FUN-810045 end
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_img.img35,'mfg3064',0) #No.FUN-660156
                 CALL cl_err3("sel","pja_file",g_img.img35_2,"","mfg3064",  #FUN-810045 gja->pja
                              "","",1)  #No.FUN-660156
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
                 DISPLAY BY NAME g_img.img26                                    
                 NEXT FIELD img26                                               
              WHEN INFIELD(img35_2) #專案名稱                                   
                 CALL cl_init_qry_var()                                         
                #LET g_qryparam.form     = "q_gja"  #FUN-810045 
                 LET g_qryparam.form     = "q_pja"  #FUN-810045  
                 LET g_qryparam.default1 = g_img.img35_2                        
                 CALL cl_create_qry() RETURNING g_img.img35_2                   
                 DISPLAY BY NAME g_img.img35_2                                  
                 NEXT FIELD img35_2                                             
              OTHERWISE EXIT CASE                                              
           END CASE                                                            
                                
        ON ACTION mntn_prj
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
END FUNCTION
        
 
#檢查單位是否存在於單位檔中
FUNCTION t337_unit(p_key)
    DEFINE p_key     LIKE gfe_file.gfe01,
           l_gfe02   LIKE gfe_file.gfe02,
           l_gfeacti LIKE gfe_file.gfeacti
 
    LET g_errno = ' '
    SELECT gfe02,gfeacti
      INTO l_gfe02,l_gfeacti
      FROM gfe_file WHERE gfe01 = p_key
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg2605'
                                  LET l_gfe02 = NULL
         WHEN l_gfeacti='N'       LET g_errno = '9028'
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION t337_imgg()
  DEFINE l_ima25    LIKE ima_file.ima25,
         l_ima906   LIKE ima_file.ima906,
         l_imgg21   LIKE imgg_file.imgg21
 
    SELECT ima25,ima906 INTO l_ima25,l_ima906
      FROM ima_file WHERE ima01=g_imgg.imgg01
    IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
#      CALL cl_err('ima25 null',SQLCA.sqlcode,0) #No.FUN-660156
       CALL cl_err3("sel","ima_file",g_imgg.imgg01,"",SQLCA.sqlcode,
                    "","ima25 null",1)  #No.FUN-660156
       LET g_success = 'N' RETURN
    END IF
 
    CALL s_umfchk(g_imgg.imgg01,g_imgg.imgg09,l_ima25)
          RETURNING g_cnt,l_imgg21
    IF g_cnt = 1 AND NOT l_ima906='3' THEN
       CALL cl_err('','mfg3075',0)
       LET g_success = 'N' RETURN
    END IF
 
    CALL s_upimgg(g_imgg.imgg01,g_imgg.imgg02,g_imgg.imgg03,g_imgg.imgg04,g_imgg.imgg09, #FUN-8C0084
         2,g_imgg.diff,g_imgg.imgg14,
         g_imgg.imgg01,g_imgg.imgg02,g_imgg.imgg03,g_imgg.imgg04,
         'CYCLE CNT','',g_imgg.imgg09,g_imgg.diff,g_imgg.imgg09,
         g_imgg.img09_fac,g_imgg.ima25_fac,1,g_imgg.imgg26,g_imgg.imgg35_2,
         g_imgg.imgg27,g_imgg.imgg28,g_imgg.imgg19,g_imgg.imgg36,
         g_imgg.imgg09_fac)
    IF g_success='N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t337_tlff(p_item,p_qty,p_qty1)
DEFINE
    p_item          LIKE ima_file.ima01, #No.FUN-690026 VARCHAR(20)
    p_qty,l_qty     LIKE img_file.img10,
    p_qty1          LIKE img_file.img10
 
#----來源----
#-----modify by pin 1992/05/25
    IF g_imgg.imgg03 IS NULL THEN LET g_imgg.imgg03=' ' END IF
    IF g_imgg.imgg04 IS NULL THEN LET g_imgg.imgg04=' ' END IF
    IF p_qty < 0 THEN 
        LET l_qty      =p_qty * -1
        #----來源----
        LET g_tlff.tlff02 =50                         #來源為倉庫(盤虧)
        LET g_tlff.tlff020=g_plant                    #工廠別
        LET g_tlff.tlff021=g_imgg.imgg02              #倉庫別
        LET g_tlff.tlff022=g_imgg.imgg03              #儲位別
        LET g_tlff.tlff023=g_imgg.imgg04              #入庫批號
        LET g_tlff.tlff024=g_img.img10+ p_qty1        #(+/-)異動後庫存數量
        LET g_tlff.tlff025=g_img.img09                #庫存單位(ima or imgg)
        LET g_tlff.tlff026=tno                        #調整單號
        #LET tno_seq       =tno_seq + 1
        LET g_tlff.tlff027=tno_seq                    #調整項次
        #----目的----
        LET g_tlff.tlff03 =0                          #目的為盤點
        LET g_tlff.tlff030=g_plant                    #工廠別
        LET g_tlff.tlff031=''                         #倉庫別
        LET g_tlff.tlff032=''                         #儲位別
        LET g_tlff.tlff033=''                         #批號
        LET g_tlff.tlff034=''                         #異動後庫存數量
        LET g_tlff.tlff035=' '                        #庫存單位
        LET g_tlff.tlff036='CYCLE'                    #週期盤點
        LET g_tlff.tlff037=''
 
        LET g_tlff.tlff15=g_imgg.credit               #貸方會計科目(盤虧)
        LET g_tlff.tlff16=g_imgg.ima39                #料件會計科目(存貨)
    ELSE 
        LET l_qty      =p_qty          
        #----來源----
        LET g_tlff.tlff02=0                           #來源為盤點(盤盈)
        LET g_tlff.tlff020=g_plant                    #工廠別
        LET g_tlff.tlff021=''                         #倉庫別
        LET g_tlff.tlff022=''                         #儲位別
        LET g_tlff.tlff023=''                         #批號
        LET g_tlff.tlff024=''                         #異動後庫存數量
        LET g_tlff.tlff025=' '                        #庫存單位
        LET g_tlff.tlff026='CYCLE'                    #週期盤點
        LET g_tlff.tlff027=''
        #----目的----
        LET g_tlff.tlff03=50                           #目的為倉庫
        LET g_tlff.tlff030=g_plant                     #工廠別
        LET g_tlff.tlff031=g_imgg.imgg02               #倉庫別
        LET g_tlff.tlff032=g_imgg.imgg03               #儲位別
        LET g_tlff.tlff033=g_imgg.imgg04               #入庫批號
        LET g_tlff.tlff034=g_img.img10+ p_qty1         #(+/-)異動後庫存數量
        LET g_tlff.tlff035=g_img.img09                 #庫存單位(ima or imgg)
        LET g_tlff.tlff036=tno                         #調整單號
        #LET tno_seq       =tno_seq + 1
        LET g_tlff.tlff037=tno_seq                     #調整項次
        LET g_tlff.tlff15=g_imgg.ima39                 #料件會計科目(存貨)
        LET g_tlff.tlff16=g_imgg.credit                #貸方會計科目(盤盈)
    END IF
 
    LET g_tlff.tlff01=p_item                           #異動料件編號
#--->異動數量 
    LET g_tlff.tlff04=' '                              #工作站
    LET g_tlff.tlff05=' '                              #作業序號
    LET g_tlff.tlff06=g_imgg.imgg14                    #盤點日期
    LET g_tlff.tlff07=g_today                          #異動資料產生日期  
    LET g_tlff.tlff08=TIME                             #異動資料產生時:分:秒
    LET g_tlff.tlff09=g_user                           #產生人
    LET g_tlff.tlff10=l_qty                            #盤盈/虧數量(皆為正值)
    LET g_tlff.tlff11=g_imgg.imgg09                    #庫存單位
    LET g_tlff.tlff12=g_imgg.img09_fac                 #單位轉換率
    LET g_tlff.tlff13='aimt337'                        #異動命令代號
    LET g_tlff.tlff14=''                               #異動原因
    LET g_tlff.tlff905=tno                             #調整單號
    CALL s_imaQOH(g_imgg.imgg01)
         RETURNING g_tlff.tlff18                       #異動後總庫存量
    LET g_tlff.tlff19= ' '                             #異動廠商/客戶編號
    LET g_tlff.tlff20= ' '                             #project no.      
    LET g_tlff.tlff930=g_imgg.dept #FUN-670093
    CALL s_tlff('2',NULL)
END FUNCTION

#FUN-CB0087---add---str---
FUNCTION t337_reason()
IF NOT cl_null(g_imgg.reason) THEN               #TQC-D20042
   SELECT azf03 INTO g_imgg.azf03
     FROM azf_file 
    WHERE azf01 = g_imgg.reason
      AND azf02 = '2' 
ELSE                                             #TQC-D20042
   LET g_imgg.azf03 = ' '                        #TQC-D20042
END IF                                           #TQC-D20042
   DISPLAY BY NAME g_imgg.azf03
END FUNCTION

FUNCTION t337_reason_chk()
DEFINE  l_flag          LIKE type_file.chr1,
        l_n             LIKE type_file.num5,
        l_where         STRING,
        l_sql           STRING
   IF NOT cl_null(g_imgg.reason) THEN
      LET l_n = 0
      LET l_flag = FALSE
      IF g_aza.aza115='Y' THEN
         CALL s_get_where(tno,'','',g_imgg.imgg01,g_imgg.imgg02,'','') RETURNING l_flag,l_where
      END IF
      IF g_aza.aza115='Y' AND l_flag THEN
         LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_imgg.reason,"' AND ",l_where
         PREPARE ggc08_pre FROM l_sql
         EXECUTE ggc08_pre INTO l_n
         IF l_n < 1 THEN
            CALL cl_err(g_imgg.reason,'aim-425',0)
            RETURN FALSE
         END IF
      ELSE
         SELECT COUNT(*) INTO l_n FROM azf_file WHERE azf01 = g_imgg.reason AND azf02 = '2'
         IF l_n < 1 THEN
            CALL cl_err(g_imgg.reason,'aim-425',0)
            RETURN FALSE
         END IF
      END IF
   ELSE                                    #TQC-D20042
      LET g_imgg.azf03 = ' '               #TQC-D20042
      DISPLAY BY NAME g_imgg.azf03         #TQC-D20042
   END IF
   RETURN TRUE
END FUNCTION
#FUN-CB0087---add---end---

