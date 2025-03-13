# Prog. Version..: '5.30.06-13.03.29(00010)'     #
#
# Pattern name...: s_aic_bom.4gl
# Descriptions...: ICD料號及BOM產生
# Date & Author..: 07/12/07 By Hellen No.FUN-7B0018
# Modify.........: No.FUN-830116 08/04/18 By jan 服飾作業修改
# Modify.........: No.FUN-840194 08/06/20 By Sherry 增加變動前置時間批量(ima601)
# Modify.........: No.CHI-940010 09/04/08 By hellen 修改SELECT ima或者imaicd欄位卻未JOIN相關表的問題
# Modify.........: No.FUN-9B0099 09/11/17 By douzh 加上栏位为空的判断
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No:FUN-A80150 10/09/20 By sabrina 在insert into ima_file之前，當ima156/ima158為null時要給"N"值
# Modify.........: No:FUN-B20008 11/02/10 By jrg542 第302行 where bmm01 = l_ds_combin[l_i] 要有對應欄位
# Modify.........: No:MOD-B30519 11/02/15 By jan 修正程式bug
# Modify.........: No:FUN-BC0106 12/01/17 By jason insert into段程式優化&拆成FUNCTION
# Modify.........: No.TQC-C20131 12/02/13 By zhuhao 在insert into ima_file之前給ima928賦值
# Modify.........: No:FUN-C20100 12/02/20 By jason ima_file日期欄位初始化
# Modify.........: No:TQC-C30140 12/03/08 By bart 預設停產N，已確認
# Modify.........: No:MOD-C30360 12/03/10 By bart 在INSERT INTO bma_file前,增加LET l_bma.bma05 = NULL
# Modify.........: No:FUN-C30082 12/03/29 By bart 1.自動產生料號時,品名、規格帶入aici020設定值icv08,icv09
#                                                 2.小於斷階料號設之製程式序項目不自動產生料號和BOM
#                                                 3.自動產生BOM時,單位由PCS轉換為DIE時,單身之主件底數要帶gross die
# Modify.........: No.FUN-C40011 12/05/15 By bart aimi150拋轉時同aimi100自動產生料號
# Modify.........: No:FUN-C50036 12/05/21 By yangxf 新增ima160字段，给预设值
# Modify.........: No:FUN-C50110 12/06/14 By bart 當自動產生的料件狀態為1.未測Wafer或2.已測Wafer時,也應該同步新增aici001
# Modify.........: No:FUN-C50132 12/06/14 By bart INITIALIZE變數
# Modify.........: No:TQC-C60003 12/06/14 By bart 自動產生出來的BOM,bmb14欄位預設為'0'
# Modify.........: No:TQC-C60022 12/06/14 By bart 新增料號時,若該料號是CP,則需自動新增一筆料件單位轉換率aooi103
# Modify.........: No:TQC-C60149 12/06/19 By bart 自動產生出來的BOM，bmb07
# Modify.........: No:TQC-C60201 12/06/25 By bart 自動產生料號與BOM時,BOM單身不要帶入作業編號(bmb09)
# Modify.........: No:TQC-C60183 12/06/26 By bart 斷階料號的輸入要允許它輸入存在aimi150的料號
# Modify.........: No:MOD-C90127 12/10/11 By Elise 增加抓取BOM單頭主件的料件狀態

DATABASE ds
 
GLOBALS "../../config/top.global"
 
FUNCTION s_aic_bom(p_icu01,p_icu02,p_newcode)
   DEFINE p_icu01      LIKE icu_file.icu01
   DEFINE p_icu02      LIKE icu_file.icu02
   DEFINE p_newcode    LIKE icw_file.icw01
   DEFINE l_icx01      LIKE icx_file.icx01
   DEFINE l_icx03      LIKE icx_file.icx03
   #FUN-BC0106 --START mark--
   #DEFINE l_tmpary     DYNAMIC ARRAY OF RECORD
   #                    icv04   LIKE icv_file.icv04,
   #                    icv05   LIKE icv_file.icv05,
   #                    ima01   LIKE ima_file.ima01,
   #                    icx02   LIKE icx_file.icx02,
   #                    icx03   LIKE icx_file.icx03
   #                    END RECORD
   #DEFINE l_ds_combin  DYNAMIC ARRAY OF RECORD
   #                    ima01   LIKE ima_file.ima01
   #                    END RECORD
   #DEFINE l_ds_combin2 DYNAMIC ARRAY OF RECORD
   #                    ima01   LIKE ima_file.ima01
   #                    END RECORD
   #DEFINE l_icv04      LIKE icv_file.icv04
   #DEFINE l_icv05      LIKE icv_file.icv05
   #DEFINE l_icv06      LIKE icv_file.icv06   
   #DEFINE l_imaicd09   LIKE imaicd_file.imaicd09
   #DEFINE l_imaicd10   LIKE imaicd_file.imaicd10
   #DEFINE l_ima63      LIKE ima_file.ima63
   #DEFINE l_ima63_fac  LIKE ima_file.ima63_fac
   #DEFINE l_ima70      LIKE ima_file.ima70
   #DEFINE l_ima35      LIKE ima_file.ima35
   #DEFINE l_bmm02      LIKE bmm_file.bmm02
   #DEFINE l_bmm06      LIKE bmm_file.bmm06
   #DEFINE l_i          LIKE type_file.num5
   #DEFINE l_j          LIKE type_file.num5
   #DEFINE l_res        LIKE ima_file.ima01
   #DEFINE l_imz        RECORD LIKE imz_file.*
   #DEFINE l_n          LIKE type_file.num10
   #CALL l_ds_combin.clear()   
   #CALL l_tmpary.clear()
   #FUN-BC0106 --END mark-- 
   
   DECLARE icx_cs CURSOR FOR
    SELECT icx01,icx03
      FROM icx_file
     WHERE icx01 = p_newcode
     ORDER BY icx02
      
   #FUN-BC0106 --START mark--
   #DECLARE icv_cs CURSOR FOR
   # SELECT icv04,icv05,icv06
   #   FROM icv_file
   #  WHERE icv01 = p_icu01
   #    AND icv02 = p_icu02       
   #  ORDER BY icv05
   #FUN-BC0106 --END mark--     
   
   #LET l_i = 0 #FUN-BC0106 mark
   FOREACH icx_cs INTO l_icx01,l_icx03
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      CALL s_aic_bom_ins(p_icu01,p_icu02,p_newcode,'')   #FUN-BC0106
#FUN-BC0106 --START move--
#      FOREACH icv_cs INTO l_icv04,l_icv05,l_icv06
#         IF SQLCA.sqlcode THEN
#            CALL cl_err('foreach:',SQLCA.sqlcode,1)
#            EXIT FOREACH
#         END IF
#         
#         LET l_i = l_i + 1            
# 
####################產生料號###################
#         CALL s_aic_auto_no(l_icv06,'4',p_newcode) RETURNING l_res
#                    
#         LET l_n = 0
#         SELECT COUNT(*) INTO l_n
#           FROM ima_file
#          WHERE ima01 = l_res
#         IF l_n >0 THEN
#            CONTINUE FOREACH
#         END IF
#         
#         SELECT * INTO l_imz.*
#           FROM imz_file
#          WHERE imz01 IN 
#                (SELECT ima06 FROM ima_file
#                  WHERE ima01 = p_icu01)
#                  
#         IF SQLCA.sqlcode THEN
#            CALL cl_err3('sel','imz_file','','',SQLCA.sqlcode,'','',0)         
#            CONTINUE FOREACH
#         END IF
#         
#         IF cl_null(l_imz.imz926) THEN LET l_imz.imz926 = 'N' END IF     #FUN-9B0099
#        #FUN-A80150---add---start---
#         IF cl_null(l_imz.imz156) THEN 
#            LET l_imz.imz156 = 'N'
#         END IF
#         IF cl_null(l_imz.imz158) THEN 
#            LET l_imz.imz158 = 'N'
#         END IF
#        #FUN-A80150---add---end---
#        
#        #FUN-BC0106 --START mark--
#        #INSERT INTO ima_file(ima01,ima03,ima04,ima06,
#        #                      ima07,ima08,ima09,ima10,
#        #                      ima11,ima12,ima14,ima15,
#        #                      ima17,ima19,ima21,ima23,
#        #                      ima24,ima25,ima27,ima28,
#        #                      ima31,ima31_fac,ima34,ima35,
#        #                      ima36,ima37,ima38,ima39,
#        #                      ima42,ima43,ima44,ima44_fac,
#        #                      ima45,ima46,ima47,ima48,
#        #                      ima49,ima491,ima50,ima51,
#        #                      ima52,ima54,ima55,ima55_fac,
#        #                      ima56,ima561,ima562,ima571,
#        #                      ima59,ima60,ima601,ima61,ima62, #FUN-840194
#        #                      ima63,ima63_fac,ima64,ima641,
#        #                      ima65,ima66,ima67,ima68,
#        #                      ima69,ima70,ima71,ima86,
#        #                      ima86_fac,ima87,ima871,ima872,
#        #                      ima873,ima874,ima88,ima89,
#        #                      ima90,ima94,ima99,ima100,
#        #                      ima101,ima102,ima103,ima105,  
#        #                      ima106,ima107,ima108,ima109,
#        #                      ima110,ima130,ima131,ima132,
#        #                      ima133,ima134,ima147,ima148,
#        #                      ima903,ima906,ima907,ima908,
#        #                      ima909,ima911,ima136,ima137,
#        #                      ima926,       #FUN-9B0099
#        #                      ima391,ima1321,ima915,imaacti,
#        #                      imauser,imagrup,imamodu,imadate,
#        #                     # ima26,ima261,ima262,ima150,   #FUN-A20044
#        #                      ima150,   #FUN-A20044
#        #                      ima151,ima152,ima916,ima156,ima158)    #FUN-A80150 add ima156,ima158
#        #               VALUES(l_res,l_imz.imz03,l_imz.imz04,l_imz.imz01,
#        #                      l_imz.imz07,l_imz.imz08,l_imz.imz09,l_imz.imz10,
#        #                      l_imz.imz11,l_imz.imz12,l_imz.imz14,l_imz.imz15,
#        #                      l_imz.imz17,l_imz.imz19,l_imz.imz21,l_imz.imz23,
#        #                      l_imz.imz24,l_imz.imz25,l_imz.imz27,l_imz.imz28,
#        #                      l_imz.imz31,l_imz.imz31_fac,l_imz.imz34,l_imz.imz35,
#        #                      l_imz.imz36,l_imz.imz37,l_imz.imz38,l_imz.imz39,
#        #                      l_imz.imz42,l_imz.imz43,l_imz.imz44,l_imz.imz44_fac,
#        #                      l_imz.imz45,l_imz.imz46,l_imz.imz47,l_imz.imz48,
#        #                      l_imz.imz49,l_imz.imz491,l_imz.imz50,l_imz.imz51,
#        #                      l_imz.imz52,l_imz.imz54,l_imz.imz55,l_imz.imz55_fac,
#        #                      l_imz.imz56,l_imz.imz561,l_imz.imz562,l_imz.imz571,
#        #                      l_imz.imz59,l_imz.imz60,1,l_imz.imz61,l_imz.imz62, #FUN-840194
#        #                      l_imz.imz63,l_imz.imz63_fac,l_imz.imz64,l_imz.imz641,
#        #                      l_imz.imz65,l_imz.imz66,l_imz.imz67,l_imz.imz68,
#        #                      l_imz.imz69,l_imz.imz70,l_imz.imz71,l_imz.imz86,
#        #                      l_imz.imz86_fac,l_imz.imz87,l_imz.imz871,l_imz.imz872,
#        #                      l_imz.imz873,l_imz.imz874,l_imz.imz88,l_imz.imz89,
#        #                      l_imz.imz90,l_imz.imz94,l_imz.imz99,l_imz.imz100 ,
#        #                      l_imz.imz101,l_imz.imz102,l_imz.imz103,l_imz.imz105,
#        #                      l_imz.imz106,l_imz.imz107,l_imz.imz108,l_imz.imz109,
#        #                      l_imz.imz110,l_imz.imz130,l_imz.imz131,l_imz.imz132,
#        #                      l_imz.imz133,l_imz.imz134,l_imz.imz147,l_imz.imz148,
#        #                      l_imz.imz903,l_imz.imz906,l_imz.imz907,l_imz.imz908,                              
#        #                      l_imz.imz909,l_imz.imz911,l_imz.imz136,l_imz.imz137,                              
#        #                      l_imz.imz926,   #FUN-9B0099
#        #                      l_imz.imz391,l_imz.imz1321,l_imz.imz72,l_imz.imzacti,
#        #                      l_imz.imzuser,l_imz.imzgrup,l_imz.imzmodu,l_imz.imzdate,
#        #                     # 0,0,0,' ',' ',' ',' ')   #FUN-A20044
#        #                       ' ',' ',' ',' ',l_imz.imz156,l_imz.imz158)   #FUN-A20044  #FUN-A80150 add imz156,imz158
#        #FUN-BC0106 --END mark--        
#        #FUN-BC0106 --START--                
#        LET l_ima.ima01       = l_res           #料件編號
#        LET l_ima.ima03       = l_imz.imz03     #目錄參考號碼
#        LET l_ima.ima04       = l_imz.imz04     #工程圖號    
#        LET l_ima.ima06       = l_imz.imz01     #分群碼      
#        LET l_ima.ima07       = l_imz.imz07     #ABC碼       
#        LET l_ima.ima08       = l_imz.imz08     #來源碼      
#        LET l_ima.ima09       = l_imz.imz09     #其他分群碼一
#        LET l_ima.ima10       = l_imz.imz10     #其他分群碼二
#        LET l_ima.ima11       = l_imz.imz11     #其他分群碼三
#        LET l_ima.ima12       = l_imz.imz12     #其他分群碼四
#        LET l_ima.ima14       = l_imz.imz14     #是否為工程料
#        LET l_ima.ima15       = l_imz.imz15     #保稅與否    
#        LET l_ima.ima17       = l_imz.imz17     #No Use      
#        LET l_ima.ima19       = l_imz.imz19     #保稅料件進出
#        LET l_ima.ima21       = l_imz.imz21     #保稅料件稅則
#        LET l_ima.ima23       = l_imz.imz23     #倉管員      
#        LET l_ima.ima24       = l_imz.imz24     #檢驗碼      
#        LET l_ima.ima25       = l_imz.imz25     #庫存單位    
#        LET l_ima.ima27       = l_imz.imz27     #安全庫存量  
#        LET l_ima.ima28       = l_imz.imz28     #安全庫存期間
#        LET l_ima.ima31       = l_imz.imz31     #銷售單位    
#        LET l_ima.ima31_fac   = l_imz.imz31_fac #銷售單位/庫存單位換算
#        LET l_ima.ima34       = l_imz.imz34     #成本中心    
#        LET l_ima.ima35       = l_imz.imz35     #主要倉庫別  
#        LET l_ima.ima36       = l_imz.imz36     #主要儲位別  
#        LET l_ima.ima37       = l_imz.imz37     #補貨策略碼  
#        LET l_ima.ima38       = l_imz.imz38     #再補貨點    
#        LET l_ima.ima39       = l_imz.imz39     #料件所屬會計
#        LET l_ima.ima42       = l_imz.imz42     #批號追蹤方式
#        LET l_ima.ima43       = l_imz.imz43     #採購員      
#        LET l_ima.ima44       = l_imz.imz44     #採購單位    
#        LET l_ima.ima44_fac   = l_imz.imz44_fac #採購單位/庫存單位換算
#        LET l_ima.ima45       = l_imz.imz45     #採購單位倍量
#        LET l_ima.ima46       = l_imz.imz46     #最少採購數量
#        LET l_ima.ima47       = l_imz.imz47     #採購損耗率  
#        LET l_ima.ima48       = l_imz.imz48     #採購安全期  
#        LET l_ima.ima49       = l_imz.imz49     #到廠前置期  
#        LET l_ima.ima491      = l_imz.imz491    #入庫前置期  
#        LET l_ima.ima50       = l_imz.imz50     #請購安全期  
#        LET l_ima.ima51       = l_imz.imz51     #經濟訂購量  
#        LET l_ima.ima52       = l_imz.imz52     #平均訂購量  
#        LET l_ima.ima54       = l_imz.imz54     #主要供應廠商
#        LET l_ima.ima55       = l_imz.imz55     #生產單位    
#        LET l_ima.ima55_fac   = l_imz.imz55_fac #生產單位/庫存單位換算
#        LET l_ima.ima56       = l_imz.imz56     #生產單位倍量
#        LET l_ima.ima561      = l_imz.imz561    #最少生產數量
#        LET l_ima.ima562      = l_imz.imz562    #生產損耗率  
#        LET l_ima.ima571      = l_imz.imz571    #主製程料件  
#        LET l_ima.ima59       = l_imz.imz59     #固定前置時間
#        LET l_ima.ima60       = l_imz.imz60     #變動前置時間
#        LET l_ima.ima601      = 1               #變動前置時間批量 
#        LET l_ima.ima61       = l_imz.imz61     #QC 前置時間 
#        LET l_ima.ima62       = l_imz.imz62     #最大累計前置
#        LET l_ima.ima63       = l_imz.imz63     #發料單位    
#        LET l_ima.ima63_fac   = l_imz.imz63_fac #發料單位/庫存單位換算
#        LET l_ima.ima64       = l_imz.imz64     #發料單位倍量
#        LET l_ima.ima641      = l_imz.imz641    #最少發料數量
#        LET l_ima.ima65       = l_imz.imz65     #發料安全存量
#        LET l_ima.ima66       = l_imz.imz66     #發料安全期  
#        LET l_ima.ima67       = l_imz.imz67     #計劃員      
#        LET l_ima.ima68       = l_imz.imz68     #需求時距    
#        LET l_ima.ima69       = l_imz.imz69     #計劃時距    
#        LET l_ima.ima70       = l_imz.imz70     #消秏料件    
#        LET l_ima.ima71       = l_imz.imz71     #儲存有效天數
#        LET l_ima.ima86       = l_imz.imz86     #成本單位    
#        LET l_ima.ima86_fac   = l_imz.imz86_fac #成本/庫存單位換算
#        LET l_ima.ima87       = l_imz.imz87     #成本項目        
#        LET l_ima.ima871      = l_imz.imz871    #間接物料分攤
#        LET l_ima.ima872      = l_imz.imz872    #材料製造費用
#        LET l_ima.ima873      = l_imz.imz873    #間接人工分攤
#        LET l_ima.ima874      = l_imz.imz874    #人工製造費用
#        LET l_ima.ima88       = l_imz.imz88     #期間採購數量
#        LET l_ima.ima89       = l_imz.imz89     #期間採購使用
#        LET l_ima.ima90       = l_imz.imz90     #期間採購使用
#        LET l_ima.ima94       = l_imz.imz94     #預設製程編號
#        LET l_ima.ima99       = l_imz.imz99     #再補貨量    
#        LET l_ima.ima100      = l_imz.imz100    #檢驗程度    
#        LET l_ima.ima101      = l_imz.imz101    #檢驗水準    
#        LET l_ima.ima102      = l_imz.imz102    #級數        
#        LET l_ima.ima103      = l_imz.imz103    #採購特性    
#        LET l_ima.ima105      = l_imz.imz105    #是否為軟體物
#        LET l_ima.ima106      = l_imz.imz106    #保稅料件型態
#        LET l_ima.ima107      = l_imz.imz107    #插件位置    
#        LET l_ima.ima108      = l_imz.imz108    #工單發料前調
#        LET l_ima.ima109      = l_imz.imz109    #材料類別    
#        LET l_ima.ima110      = l_imz.imz110    #工單開立展開
#        LET l_ima.ima130      = l_imz.imz130    #產品銷售特性
#        LET l_ima.ima131      = l_imz.imz131    #產品分類編號
#        LET l_ima.ima132      = l_imz.imz132    #費用科目編號
#        LET l_ima.ima133      = l_imz.imz133    #產品預測料號
#        LET l_ima.ima134      = l_imz.imz134    #主要包裝方式
#        LET l_ima.ima147      = l_imz.imz147    #插件位置與QP
#        LET l_ima.ima148      = l_imz.imz148    #保證期      
#        LET l_ima.ima903      = l_imz.imz903    #可否做聯產品
#        LET l_ima.ima906      = l_imz.imz906    #單位使用方式
#        LET l_ima.ima907      = l_imz.imz907    #第二單位(母單位/參考單位)
#        LET l_ima.ima908      = l_imz.imz908    #計價單位    
#        LET l_ima.ima909      = l_imz.imz909    #MRP匯總時距(天)(預留欄位)
#        LET l_ima.ima911      = l_imz.imz911    #是否為重覆性
#        LET l_ima.ima136      = l_imz.imz136    #主要WIP 倉庫
#        LET l_ima.ima137      = l_imz.imz137    #主要WIP 儲位
#        LET l_ima.ima926      = l_imz.imz926    #AVL否       
#        LET l_ima.ima391      = l_imz.imz391    #會計科目二  
#        LET l_ima.ima1321     = l_imz.imz1321   #費用科目二  
#        LET l_ima.ima915      = l_imz.imz72     #是否需做供應
#        LET l_ima.imaacti     = l_imz.imzacti   #資料有效碼  
#        LET l_ima.imauser     = l_imz.imzuser   #資料所有者  
#        LET l_ima.imagrup     = l_imz.imzgrup   #資料所有者  
#        LET l_ima.imamodu     = l_imz.imzmodu   #資料更改者  
#        LET l_ima.imadate     = l_imz.imzdate   #最近修改日  
#        LET l_ima.ima150      = ' '             #收貨替代方式
#        LET l_ima.ima151      = ' '             #母料件否    
#        LET l_ima.ima152      = ' '             #PO對Blanket 
#        LET l_ima.ima916      = ' '             #資料來源    
#        LET l_ima.ima156      = l_imz.imz156    #號機自動編碼
#        LET l_ima.ima158      = l_imz.imz158    #號機庫存管理
#        
#        INSERT INTO ima_file VALUES(l_ima.*)
#        #FUN-BC0106 --END--
#      
#         IF SQLCA.sqlcode THEN
#            CALL cl_err3('ins','ima_file',l_res,l_imz.imz01,SQLCA.sqlcode,'','',1)
#            CONTINUE FOREACH
#         END IF   
# 
#         IF l_icv05 MATCHES "[123]" THEN
#            LET l_imaicd09 = "N"
#         ELSE
#       	    IF l_icv05 MATCHES "[45]" THEN
#               LET l_imaicd09 = "Y"
#            END IF
#         END IF
#         
#         IF l_icv05 = "1" THEN
#            #modify CHI-940010 by hellen -- begin 090408
#            SELECT imaicd10 INTO l_imaicd10
##             FROM ima_file
#              FROM imaicd_file
##            WHERE ima01 = p_icu01
#             WHERE imaicd01 = p_icu01
#            #modify CHI-940010 by hellen -- end 090408
#         ELSE 
#             LET l_imaicd10 = NULL
#         END IF	   
#
#         #FUN-BC0106 --START mark--         
#         #INSERT INTO imaicd_file(imaicd00,imaicd01,imaicd02,imaicd03,imaicd04,
#         #                        imaicd05,imaicd06,imaicd07,imaicd08,imaicd09,
#         #                        imaicd10,imaicd11,imaicd12) 
#         #                 VALUES(l_res,p_icu01,'','',l_icv05,
#         #                        '5','','','Y',l_imaicd09,
#         #                      # l_imcicd10,p_newcode,100)  #MOD-B30519
#         #                        l_imaicd10,p_newcode,100)  #MOD-B30519
#         #FUN-BC0106 --END mark--                                 
#         #FUN-BC0106 --START--
#         LET l_imaicd.imaicd00 = l_res
#         LET l_imaicd.imaicd01 = p_icu01
#         LET l_imaicd.imaicd02 = ''
#         LET l_imaicd.imaicd03 = ''
#         LET l_imaicd.imaicd04 = l_icv05
#         LET l_imaicd.imaicd05 = '5'
#         LET l_imaicd.imaicd06 = ''
#         LET l_imaicd.imaicd07 = ''
#         LET l_imaicd.imaicd08 = 'Y'
#         LET l_imaicd.imaicd09 = l_imaicd09
#         LET l_imaicd.imaicd10 = l_imaicd10
#         LET l_imaicd.imaicd11 = p_newcode
#         LET l_imaicd.imaicd12 = 100         
#
#         INSERT INTO imaicd_file VALUES(l_imaicd.*) 
#         #FUN-BC0106 --END--         
#         IF SQLCA.sqlcode THEN
#            CALL cl_err3("ins","imaicd_file",l_res,p_icu01,SQLCA.sqlcode,"","",1)
#            CONTINUE FOREACH
#         END IF
#         
#         LET l_tmpary[l_i].icv04 = l_icv04
#         LET l_tmpary[l_i].icv05 = l_icv05 
#         LET l_tmpary[l_i].ima01 = l_res
#         LET l_tmpary[l_i].icx02 = l_i
#         LET l_tmpary[l_i].icx03 = l_icx03
#         
#         IF l_icv05 = "3" THEN
#            LET l_ds_combin[l_ds_combin.getlength()+1].ima01 = l_res
#         END IF
#         
#################新增ICD基本資料###############
##        LET l_n = 0 
##        SELECT COUNT(*) INTO l_n
##          FROM icb_file
##         WHERE icb01 = l_res
##         IF l_n > 0 THEN
##            CONTINUE FOREACH
##         END IF
##         
##        INSERT INTO icb_file(icb01) VALUES(l_res)
##        IF SQLCA.sqlcode THEN
##           CALL cl_err3("ins","icb_file",l_res,"",SQLCA.sqlcode,"","",1)
##           CONTINUE FOREACH
##        END IF
#      END FOREACH
# 
# 
#################新增下階料資料################
#      FOR l_i = 1 TO l_tmpary.getlength() - 1
#          #FUN-BC0106 --START mark-- 
#          #INSERT INTO icm_file(icm01,icm02,icm04,icmuser,icmgrup,icmacti)
#          #              VALUES(l_tmpary[l_i].ima01,l_tmpary[l_i+1].ima01,
#          #                     p_newcode,g_user,g_dept,'Y')
#          #FUN-BC0106 --END mark--                     
#          #FUN-BC0106 --START--
#          LET l_icm.icm01 = l_tmpary[l_i].ima01
#          LET l_icm.icm02 = l_tmpary[l_i+1].ima01
#          LET l_icm.icm04 = p_newcode
#          LET l_icm.icmuser = g_user
#          LET l_icm.icmgrup = g_grup
#          LET l_icm.icmacti = 'Y'
#
#          INSERT INTO icm_file VALUES(l_icm.*)
#          #FUN-BC0106 --END--
#          
#          IF SQLCA.sqlcode THEN
#             CALL cl_err3("ins","icm_file",l_tmpary[l_i].ima01,"",SQLCA.sqlcode,"","",1)
#             CONTINUE FOREACH
#          END IF
#      END FOR
# 
#      LET l_i = l_tmpary.getlength()
#      WHILE l_i > 1
# 
#################新增bma_file##################
#          #FUN-BC0106 --START mark--
#          #INSERT INTO bma_file(bma01,bma06,bmauser,
#          #                     bmagrup,bmaacti,bmaicd01)
#          #              VALUES(l_tmpary[l_i].ima01,'',g_user,
#          #                     g_dept,'Y',p_newcode)
#          #FUN-BC0106 --END mark--                     
#          #FUN-BC0106 --START--
#          LET l_bma.bma01 = l_tmpary[l_i].ima01
#          LET l_bma.bma06 = ''
#          LET l_bma.bmauser = g_user
#          LET l_bma.bmagrup = g_grup
#          LET l_bma.bmaacti = 'Y'
#          LET l_bma.bmaicd01 = p_newcode
#
#          INSERT INTO bma_file VALUES(l_bma.*)
#          #FUN-BC0106 --END--
#          IF SQLCA.sqlcode THEN
#             CALL cl_err3("ins","bma_file",l_tmpary[l_i].ima01,"",SQLCA.sqlcode,"","",1)
#             CONTINUE WHILE
#          END IF
# 
#################新增bmb_file##################
#          SELECT ima63,ima63_fac,ima70,ima35 
#            INTO l_ima63,l_ima63_fac,l_ima70,l_ima35
#            FROM ima_file
#           WHERE ima01 = l_tmpary[l_i-1].ima01
#          #FUN-BC0106 --START mark--   
#          #INSERT INTO bmb_file(bmb01,bmb29,bmb03,
#          #                     bmb04,bmb06,bmb07,
#          #                     bmb08,bmb09,bmb10,
#          #                     bmb10_fac,bmb10_fac2,bmb15,
#          #                     bmb16,bmb19,bmb25,bmb33) #No.FUN-830116
#          #              VALUES(l_tmpary[l_i].ima01,'',l_tmpary[l_i-1].ima01,
#          #                     g_today,1,1,
#          #                     0,l_tmpary[l_i-1].icv04,l_ima63,
#          #                     l_ima63_fac,l_ima63_fac,l_ima70,
#          #                     '1','1',l_ima35,0)#No.FUN-830116
#          #FUN-BC0106 --END mark--                     
#          #FUN-BC0106 --START--
#          LET l_bmb.bmb01 = l_tmpary[l_i].ima01
#          LET l_bmb.bmb29 = ''
#          LET l_bmb.bmb03 = l_tmpary[l_i-1].ima01
#          LET l_bmb.bmb04 = g_today
#          LET l_bmb.bmb06 = 1
#          LET l_bmb.bmb07 = 1
#          LET l_bmb.bmb08 = 0
#          LET l_bmb.bmb09 = l_tmpary[l_i-1].icv04
#          LET l_bmb.bmb10 = l_ima63
#          LET l_bmb.bmb10_fac = l_ima63_fac
#          LET l_bmb.bmb10_fac2 = l_ima63_fac
#          LET l_bmb.bmb15 = l_ima70
#          LET l_bmb.bmb16 = '1'
#          LET l_bmb.bmb19 = '1'
#          LET l_bmb.bmb25 = l_ima35
#          LET l_bmb.bmb33 = 0
#
#          INSERT INTO bmb_file VALUES(l_bmb.*)
#          #FUN-BC0106 --END--          
#          IF SQLCA.sqlcode THEN
#             CALL cl_err3("ins","bmb_file",l_tmpary[l_i].ima01,"",SQLCA.sqlcode,"","",1)
#             CONTINUE WHILE
#          END IF
#          
#      END WHILE
#      
#      CALL l_tmpary.clear()
#      LET l_i = 0
#FUN-BC0106 --START move--      
   END FOREACH                         

#FUN-BC0106 --START mark-- 
#################新增bmm_file##################
#   LET l_ds_combin2.* = l_ds_combin.*
#   FOR l_i = 1 TO l_ds_combin.getlength()
#       FOR l_j = 1 TO l_ds_combin2.getlength()
#           LET l_bmm02 = NULL
#           SELECT MAX(bmm02) + 1 
#             INTO l_bmm02
#             FROM bmm_file
#            #WHERE bmm01 = l_ds_combin[l_i] #FUN-B20008
#            WHERE bmm01 = l_ds_combin[l_i].ima01  
#           LET l_ima63 = NULL
#           SELECT ima63 INTO l_ima63 
#             FROM ima_file
#            WHERE ima01 = l_ds_combin2[l_j].ima01
#            
#           LET l_bmm06 = cl_digcut((1/l_ds_combin2.getlength())*100,3)  
#             
#           #FUN-BC0106 --START mark--
#           #INSERT INTO bmm_file(bmm01,bmm02,
#           #                     bmm03,bmm04,
#           #                     bmm05,bmm06)
#           #              VALUES(l_ds_combin[l_i].ima01,l_bmm02,
#           #                     l_ds_combin2[l_j].ima01,l_ima63,
#           #                     'Y',l_bmm06)
#           #FUN-BC0106 --END mark--
#           #FUN-BC0106 --START--
#           LET l_bmm.bmm01 = l_ds_combin[l_i].ima01
#           LET l_bmm.bmm02 = l_bmm02
#           LET l_bmm.bmm03 = l_ds_combin2[l_j].ima01
#           LET l_bmm.bmm04 = l_ima63
#           LET l_bmm.bmm05 = 'Y'
#           LET l_bmm.bmm06 = l_bmm06
#
#           INSERT INTO bmm_file VALUES(l_bmm.*)
#           #FUN-BC0106 --END--           
#           IF SQLCA.sqlcode THEN
#              CALL cl_err3("ins","bmm_file",l_ds_combin[l_i].ima01,"",SQLCA.sqlcode,"","",1)
#              CONTINUE FOR
#           END IF                     
#                                       
#       END FOR
#   END FOR
#FUN-BC0106 --END mark-- 
END FUNCTION

#FUN-BC0106 --START--
FUNCTION s_aic_bom_ins(p_icu01,p_icu02,p_newcode,p_ima01)
   DEFINE p_icu01      LIKE icu_file.icu01
   DEFINE p_icu02      LIKE icu_file.icu02
   DEFINE p_newcode    LIKE icw_file.icw01
   DEFINE p_ima01      LIKE ima_file.ima01
   DEFINE l_tmpary     DYNAMIC ARRAY OF RECORD
                       icv04   LIKE icv_file.icv04,
                       icv05   LIKE icv_file.icv05,
                       ima01   LIKE ima_file.ima01,
                       icx02   LIKE icx_file.icx02,
                       icx03   LIKE icx_file.icx03
                       END RECORD   
   DEFINE l_icv04      LIKE icv_file.icv04
   DEFINE l_icv05      LIKE icv_file.icv05
   DEFINE l_icv06      LIKE icv_file.icv06   
   DEFINE l_icv07      LIKE icv_file.icv07
   #DEFINE l_imaicd09   LIKE imaicd_file.imaicd09   
   #DEFINE l_imaicd10   LIKE imaicd_file.imaicd10
   #DEFINE l_ima63      LIKE ima_file.ima63       #FUN-C30082
   #DEFINE l_ima63_fac  LIKE ima_file.ima63_fac   #FUN-C30082
   #DEFINE l_ima70      LIKE ima_file.ima70       #FUN-C30082
   #DEFINE l_ima35      LIKE ima_file.ima35       #FUN-C30082
   #DEFINE l_bmm02      LIKE bmm_file.bmm02       #FUN-C30082
   #DEFINE l_bmm06      LIKE bmm_file.bmm06       #FUN-C30082
   DEFINE l_i          LIKE type_file.num5
   #DEFINE l_j          LIKE type_file.num5       #FUN-C30082
   DEFINE l_res        LIKE ima_file.ima01
   DEFINE l_imz        RECORD LIKE imz_file.*
   DEFINE l_n          LIKE type_file.num10
   DEFINE l_ima        RECORD LIKE ima_file.*    
   DEFINE l_imaicd     RECORD LIKE imaicd_file.* 
   #DEFINE l_icm        RECORD LIKE icm_file.*    #FUN-C30082
   #DEFINE l_bma        RECORD LIKE bma_file.*    #FUN-C30082
   #DEFINE l_bmb        RECORD LIKE bmb_file.*    #FUN-C30082
   #DEFINE l_bmm        RECORD LIKE bmm_file.*    #FUN-C30082
   DEFINE l_ecd02      LIKE ecd_file.ecd02
   DEFINE l_imaicd14   LIKE imaicd_file.imaicd14   #FUN-C30082 
   DEFINE l_icv03      LIKE icv_file.icv03         #FUN-C30082
   DEFINE l_icv08      LIKE icv_file.icv08         #FUN-C30082
   DEFINE l_icv09      LIKE icv_file.icv09         #FUN-C30082
   DEFINE l_icv10      LIKE icv_file.icv10         #FUN-C30082
   DEFINE l_icv04_1    LIKE icv_file.icv04         #FUN-C30082
   DEFINE l_bmb07      LIKE bmb_file.bmb07         #FUN-C30082
   DEFINE l_imaa       RECORD LIKE imaa_file.*     #FUN-C40011
   DEFINE l_ima01      LIKE ima_file.ima01         #FUN-C40011
   DEFINE l_cnt        LIKE type_file.num5         #FUN-C50110

   CALL l_tmpary.clear()
   #FUN-C30082---begin
   #母體料號之gross die
   LET l_imaicd14 = 0
   SELECT imaicd14 INTO l_imaicd14 FROM imaicd_file
    WHERE imaicd00 =  p_icu01
   #找有設斷階料號之最大製程序 
   LET l_icv03 = NULL 
   SELECT MAX(icv03) INTO l_icv03 FROM icv_file WHERE icv01 = p_icu01 
      AND icv02 = p_icu02 AND icv10 <> ' ' AND icv10 IS NOT NULL
      
   IF cl_null(l_icv03) THEN
   LET l_icv03 = 0
   END IF 

   IF l_icv03 <> 0 THEN
      SELECT icv10,icv04 INTO l_icv10,l_icv04_1 FROM icv_file WHERE icv01 = p_icu01
      AND icv02 = p_icu02 AND icv03 = l_icv03
   ELSE
      LET l_icv10 = NULL 
      LET l_icv04_1 = NULL
   END IF 
   #FUN-C30082---end
      
   DECLARE icv_cs CURSOR FOR
    SELECT icv04,icv05,icv06,icv07,icv08,icv09  #FUN-C30082 add icv08,icv09
      FROM icv_file
     WHERE icv01 = p_icu01
       AND icv02 = p_icu02   
       AND icv03 >= l_icv03      #FUN-C30082 
     ORDER BY icv05
   
      LET l_i = 0
      
      FOREACH icv_cs INTO l_icv04,l_icv05,l_icv06,l_icv07,l_icv08,l_icv09  #FUN-C30082 add l_icv08,l_icv09
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         INITIALIZE l_ima TO NULL      #FUN-C50132
         INITIALIZE l_imaicd TO NULL   #FUN-C50132
         #FUN-C40011---begin
         #若是從aimi150串進來的,第四個參數傳入的會是料件申請單號
         IF g_prog = 'aimi150' THEN
            LET l_ima01 = p_ima01   
            SELECT * INTO l_imaa.* FROM imaa_file WHERE imaano = p_ima01
            LET p_ima01 = l_imaa.imaaicd01   
         END IF
         #FUN-C40011---end
###################產生料號###################
         CALL s_aic_auto_no(l_icv06,'4',p_newcode,p_ima01) RETURNING l_res  
         #FUN-C40011---begin
         IF g_prog = 'aimi150' THEN
            LET p_ima01 = l_ima01
         END IF
         #FUN-C40011---end 
         LET l_n = 0
         SELECT COUNT(*) INTO l_n
           FROM ima_file
          WHERE ima01 = l_res
         IF l_n >0 THEN
            CONTINUE FOREACH
         END IF

         IF NOT cl_null(l_icv07) THEN
            SELECT * INTO l_imz.*
              FROM imz_file
             WHERE imz01 = l_icv07
         ELSE         
            SELECT * INTO l_imz.*
              FROM imz_file
             WHERE imz01 IN 
                (SELECT ima06 FROM ima_file
                  WHERE ima01 = p_icu01)
         END IF          
         IF SQLCA.sqlcode THEN
            CALL cl_err3('sel','imz_file','','',SQLCA.sqlcode,'','',0)         
            CONTINUE FOREACH
         END IF
         
         IF cl_null(l_imz.imz926) THEN LET l_imz.imz926 = 'N' END IF     #FUN-9B0099
        #FUN-A80150---add---start---
         IF cl_null(l_imz.imz156) THEN 
            LET l_imz.imz156 = 'N'
         END IF
         IF cl_null(l_imz.imz158) THEN 
            LET l_imz.imz158 = 'N'
         END IF
        #FUN-A80150---add---end---

        #FUN-C30082---begin
        IF NOT cl_null(l_icv08) THEN 
           LET l_ima.ima02 = l_icv08
        ELSE 
        #FUN-C30082---end
           SELECT ecd02 INTO l_ecd02 FROM ecd_file
            WHERE ecd01 = l_icv04
           IF SQLCA.sqlcode THEN
             CALL cl_err3("sel","ecd_file",l_icv04,"",SQLCA.sqlcode,"","",0)  
             LET l_ecd02 = NULL
           END IF
           LET l_ima.ima02       = l_ecd02
        #FUN-C30082---begin
        END IF 
        IF NOT cl_null(l_icv09) THEN
           LET l_ima.ima021 = l_icv09
        END IF 
        #FUN-C30082---end
                            
        LET l_ima.ima01       = l_res           #料件編號
        #LET l_ima.ima02       = l_ecd02         #品名  #FUN-C30082
        LET l_ima.ima03       = l_imz.imz03     #目錄參考號碼
        LET l_ima.ima04       = l_imz.imz04     #工程圖號    
        LET l_ima.ima06       = l_imz.imz01     #分群碼      
        LET l_ima.ima07       = l_imz.imz07     #ABC碼       
        LET l_ima.ima08       = l_imz.imz08     #來源碼      
        LET l_ima.ima09       = l_imz.imz09     #其他分群碼一
        LET l_ima.ima10       = l_imz.imz10     #其他分群碼二
        LET l_ima.ima11       = l_imz.imz11     #其他分群碼三
        LET l_ima.ima12       = l_imz.imz12     #其他分群碼四
        LET l_ima.ima14       = l_imz.imz14     #是否為工程料
        LET l_ima.ima15       = l_imz.imz15     #保稅與否    
        LET l_ima.ima17       = l_imz.imz17     #No Use      
        LET l_ima.ima19       = l_imz.imz19     #保稅料件進出
        LET l_ima.ima21       = l_imz.imz21     #保稅料件稅則
        LET l_ima.ima23       = l_imz.imz23     #倉管員      
        LET l_ima.ima24       = l_imz.imz24     #檢驗碼      
        LET l_ima.ima25       = l_imz.imz25     #庫存單位    
        LET l_ima.ima27       = l_imz.imz27     #安全庫存量  
        LET l_ima.ima28       = l_imz.imz28     #安全庫存期間
        LET l_ima.ima31       = l_imz.imz31     #銷售單位    
        LET l_ima.ima31_fac   = l_imz.imz31_fac #銷售單位/庫存單位換算
        LET l_ima.ima34       = l_imz.imz34     #成本中心    
        LET l_ima.ima35       = l_imz.imz35     #主要倉庫別  
        LET l_ima.ima36       = l_imz.imz36     #主要儲位別  
        LET l_ima.ima37       = l_imz.imz37     #補貨策略碼  
        LET l_ima.ima38       = l_imz.imz38     #再補貨點    
        LET l_ima.ima39       = l_imz.imz39     #料件所屬會計
        LET l_ima.ima42       = l_imz.imz42     #批號追蹤方式
        LET l_ima.ima43       = l_imz.imz43     #採購員      
        LET l_ima.ima44       = l_imz.imz44     #採購單位    
        LET l_ima.ima44_fac   = l_imz.imz44_fac #採購單位/庫存單位換算
        LET l_ima.ima45       = l_imz.imz45     #採購單位倍量
        LET l_ima.ima46       = l_imz.imz46     #最少採購數量
        LET l_ima.ima47       = l_imz.imz47     #採購損耗率  
        LET l_ima.ima48       = l_imz.imz48     #採購安全期  
        LET l_ima.ima49       = l_imz.imz49     #到廠前置期  
        LET l_ima.ima491      = l_imz.imz491    #入庫前置期  
        LET l_ima.ima50       = l_imz.imz50     #請購安全期  
        LET l_ima.ima51       = l_imz.imz51     #經濟訂購量  
        LET l_ima.ima52       = l_imz.imz52     #平均訂購量  
        LET l_ima.ima54       = l_imz.imz54     #主要供應廠商
        LET l_ima.ima55       = l_imz.imz55     #生產單位    
        LET l_ima.ima55_fac   = l_imz.imz55_fac #生產單位/庫存單位換算
        LET l_ima.ima56       = l_imz.imz56     #生產單位倍量
        LET l_ima.ima561      = l_imz.imz561    #最少生產數量
        LET l_ima.ima562      = l_imz.imz562    #生產損耗率  
        LET l_ima.ima571      = l_imz.imz571    #主製程料件  
        LET l_ima.ima59       = l_imz.imz59     #固定前置時間
        LET l_ima.ima60       = l_imz.imz60     #變動前置時間
        LET l_ima.ima601      = 1               #變動前置時間批量 
        LET l_ima.ima61       = l_imz.imz61     #QC 前置時間 
        LET l_ima.ima62       = l_imz.imz62     #最大累計前置
        LET l_ima.ima63       = l_imz.imz63     #發料單位    
        LET l_ima.ima63_fac   = l_imz.imz63_fac #發料單位/庫存單位換算
        LET l_ima.ima64       = l_imz.imz64     #發料單位倍量
        LET l_ima.ima641      = l_imz.imz641    #最少發料數量
        LET l_ima.ima65       = l_imz.imz65     #發料安全存量
        LET l_ima.ima66       = l_imz.imz66     #發料安全期  
        LET l_ima.ima67       = l_imz.imz67     #計劃員      
        LET l_ima.ima68       = l_imz.imz68     #需求時距    
        LET l_ima.ima69       = l_imz.imz69     #計劃時距    
        LET l_ima.ima70       = l_imz.imz70     #消秏料件    
        LET l_ima.ima71       = l_imz.imz71     #儲存有效天數
        LET l_ima.ima86       = l_imz.imz86     #成本單位    
        LET l_ima.ima86_fac   = l_imz.imz86_fac #成本/庫存單位換算
        LET l_ima.ima87       = l_imz.imz87     #成本項目        
        LET l_ima.ima871      = l_imz.imz871    #間接物料分攤
        LET l_ima.ima872      = l_imz.imz872    #材料製造費用
        LET l_ima.ima873      = l_imz.imz873    #間接人工分攤
        LET l_ima.ima874      = l_imz.imz874    #人工製造費用
        LET l_ima.ima88       = l_imz.imz88     #期間採購數量
        LET l_ima.ima89       = l_imz.imz89     #期間採購使用
        LET l_ima.ima90       = l_imz.imz90     #期間採購使用
        LET l_ima.ima94       = l_imz.imz94     #預設製程編號
        LET l_ima.ima99       = l_imz.imz99     #再補貨量    
        LET l_ima.ima100      = l_imz.imz100    #檢驗程度    
        LET l_ima.ima101      = l_imz.imz101    #檢驗水準    
        LET l_ima.ima102      = l_imz.imz102    #級數        
        LET l_ima.ima103      = l_imz.imz103    #採購特性    
        LET l_ima.ima105      = l_imz.imz105    #是否為軟體物
        LET l_ima.ima106      = l_imz.imz106    #保稅料件型態
        LET l_ima.ima107      = l_imz.imz107    #插件位置    
        LET l_ima.ima108      = l_imz.imz108    #工單發料前調
        LET l_ima.ima109      = l_imz.imz109    #材料類別    
        LET l_ima.ima110      = l_imz.imz110    #工單開立展開
        LET l_ima.ima130      = l_imz.imz130    #產品銷售特性
        LET l_ima.ima131      = l_imz.imz131    #產品分類編號
        LET l_ima.ima132      = l_imz.imz132    #費用科目編號
        LET l_ima.ima133      = l_imz.imz133    #產品預測料號
        LET l_ima.ima134      = l_imz.imz134    #主要包裝方式
        LET l_ima.ima147      = l_imz.imz147    #插件位置與QP
        LET l_ima.ima148      = l_imz.imz148    #保證期      
        LET l_ima.ima903      = l_imz.imz903    #可否做聯產品
        LET l_ima.ima906      = l_imz.imz906    #單位使用方式
        LET l_ima.ima907      = l_imz.imz907    #第二單位(母單位/參考單位)
        LET l_ima.ima908      = l_imz.imz908    #計價單位    
        LET l_ima.ima909      = l_imz.imz909    #MRP匯總時距(天)(預留欄位)
        LET l_ima.ima911      = l_imz.imz911    #是否為重覆性
        LET l_ima.ima136      = l_imz.imz136    #主要WIP 倉庫
        LET l_ima.ima137      = l_imz.imz137    #主要WIP 儲位
        LET l_ima.ima926      = l_imz.imz926    #AVL否       
        LET l_ima.ima391      = l_imz.imz391    #會計科目二  
        LET l_ima.ima1321     = l_imz.imz1321   #費用科目二  
        LET l_ima.ima915      = l_imz.imz72     #是否需做供應
        #LET l_ima.imaacti     = 'P'             #資料有效碼  
        LET l_ima.imaacti     = 'Y'             #TQC-C30140
        LET l_ima.imauser     = g_user          #資料所有者  
        LET l_ima.imagrup     = g_grup          #資料所有者  
        LET l_ima.imamodu     = g_user          #資料更改者  
        LET l_ima.imadate     = g_today         #最近修改日  
        LET l_ima.ima150      = ' '             #收貨替代方式
        LET l_ima.ima151      = ' '             #母料件否    
        LET l_ima.ima152      = ' '             #PO對Blanket 
        LET l_ima.ima916      = ' '             #資料來源    
        LET l_ima.ima156      = l_imz.imz156    #號機自動編碼
        LET l_ima.ima158      = l_imz.imz158    #號機庫存管理
        LET l_ima.ima910      = ' '
        LET l_ima.ima022      = 0       
        LET l_ima.ima927      = 'N'
        LET l_ima.ima120      = ' '
        #LET l_ima.ima159      = ' '  #FUN-C50110
        LET l_ima.ima159      = l_imz.imz159   #FUN-C50110
       #LET l_ima.ima928      = ' '             #TQC-C20131  mark
        LET l_ima.ima928      = 'N'             #TQC-C20131  add
        #LET l_ima.ima1010     = '0'  #TQC-C30140 mark
        LET l_ima.ima1010     = '1'  #TQC-C30140
        LET l_ima.ima140      = 'N'  #TQC-C30140
        

        #FUN-C20100 --START--
        LET l_ima.ima901      = g_today
        LET l_ima.ima902      = NULL
        LET l_ima.ima9021     = NULL
        LET l_ima.ima881      = NULL
        LET l_ima.ima73       = NULL
        LET l_ima.ima74       = NULL
        LET l_ima.ima29       = NULL
        LET l_ima.ima30       = g_today
        #FUN-C20100 --END--
        IF cl_null(l_ima.ima160) THEN LET l_ima.ima160 = 'N' END IF      #FUN-C50036  add 
        INSERT INTO ima_file VALUES(l_ima.*)      
      
         IF SQLCA.sqlcode THEN
            CALL cl_err3('ins','ima_file',l_res,l_imz.imz01,SQLCA.sqlcode,'','',1)
            CONTINUE FOREACH
         END IF   
 
         #IF l_icv05 MATCHES "[123]" THEN
         #   LET l_imaicd09 = "N"
         #ELSE
       	 #   IF l_icv05 MATCHES "[45]" THEN
         #      LET l_imaicd09 = "Y"
         #   END IF
         #END IF
         
         #IF l_icv05 = "1" THEN
            #modify CHI-940010 by hellen -- begin 090408
         #   SELECT imaicd10 INTO l_imaicd10
#             FROM ima_file
         #     FROM imaicd_file
#            WHERE ima01 = p_icu01
             #WHERE imaicd01 = p_icu01   #FUN-BC0106 mark
         #    WHERE imaicd00 = p_icu01    #FUN-BC0106
            #modify CHI-940010 by hellen -- end 090408
         #ELSE 
         #    LET l_imaicd10 = NULL
         #END IF	   
        
         LET l_imaicd.imaicd00 = l_res
         LET l_imaicd.imaicd01 = p_icu01
         LET l_imaicd.imaicd02 = l_imz.imzicd02
         LET l_imaicd.imaicd03 = l_imz.imzicd03
         LET l_imaicd.imaicd04 = l_icv05
         LET l_imaicd.imaicd05 = '5'
         LET l_imaicd.imaicd06 = l_imz.imzicd06
         LET l_imaicd.imaicd07 = l_imz.imzicd07
         LET l_imaicd.imaicd08 = l_imz.imzicd08
         LET l_imaicd.imaicd09 = l_imz.imzicd09
         LET l_imaicd.imaicd10 = l_imz.imzicd10
         #LET l_imaicd.imaicd14 = l_imz.imzicd14 FUN-C30082        
         LET l_imaicd.imaicd15 = l_imz.imzicd15
         LET l_imaicd.imaicd16 = l_imz.imzicd16
         LET l_imaicd.imaicd17 = l_imz.imzicd17

         #FUN-C30082---begin
         #料件特性為wafer時gross die帶母體grossdie 
         IF l_icv05 = '1' OR l_icv05 = '2' AND l_imaicd14 <> 0 THEN
            LET l_imaicd.imaicd14 = l_imaicd14
         ELSE 
            LET l_imaicd.imaicd14 = l_imz.imzicd14
         END IF 
         #FUN-C30082---end

         
         IF cl_null(p_newcode) THEN
            LET l_imaicd.imaicd11 = p_ima01
         ELSE   
            LET l_imaicd.imaicd11 = p_newcode
         END IF    
         LET l_imaicd.imaicd12 = l_imz.imzicd12         

         INSERT INTO imaicd_file VALUES(l_imaicd.*)
         
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","imaicd_file",l_res,p_icu01,SQLCA.sqlcode,"","",1)
            CONTINUE FOREACH
         END IF
         
         #FUN-C50110
         IF l_imaicd.imaicd04 = '0' OR l_imaicd.imaicd04 = '1' OR l_imaicd.imaicd04 = '2' THEN
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM icb_file
             WHERE icb01 = l_ima.ima01
            IF l_cnt = 0 THEN
               INSERT INTO icb_file(icb01,icb05) VALUES (l_ima.ima01,l_imaicd.imaicd14)
               IF SQLCA.SQLCODE THEN 
                  CALL cl_err(l_ima.ima01,SQLCA.SQLCODE,0)
               END IF 
            ELSE
               UPDATE icb_file SET icb05 = l_imaicd.imaicd14
                  WHERE icb01 = l_ima.ima01
               IF SQLCA.SQLCODE THEN 
                  CALL cl_err(l_ima.ima01,SQLCA.SQLCODE,0)
               END IF 
            END IF  
         ELSE  
            UPDATE icb_file SET icb05 = l_imaicd.imaicd14
               WHERE icb01 = l_ima.ima01
            IF SQLCA.SQLCODE THEN 
               CALL cl_err(l_ima.ima01,SQLCA.SQLCODE,0)
            END IF 
         END IF 
         #FUN-C50110
         #TQC-C60022---begin
         IF l_imaicd.imaicd04 = '2' THEN
            INSERT INTO smd_file(smd01,smd02,smd03,smd04,smd06,smdacti,smdpos) VALUES 
               (l_ima.ima01,l_ima.ima25,l_ima.ima907,1,l_imaicd.imaicd14,'Y','1')
            IF SQLCA.SQLCODE THEN 
               CALL cl_err(l_ima.ima01,SQLCA.SQLCODE,0)
            END IF 
            INSERT INTO smd_file(smd01,smd02,smd03,smd04,smd06,smdacti,smdpos) VALUES 
               (l_ima.ima01,l_ima.ima907,l_ima.ima25,l_imaicd.imaicd14,1,'Y','1')
            IF SQLCA.SQLCODE THEN 
               CALL cl_err(l_ima.ima01,SQLCA.SQLCODE,0)
            END IF 
         END IF
         #TQC-C60022---end
         
         LET l_i = l_i + 1
         LET l_tmpary[l_i].icv04 = l_icv04
         LET l_tmpary[l_i].icv05 = l_icv05
         LET l_tmpary[l_i].ima01 = l_res
         LET l_tmpary[l_i].icx02 = l_i
        
         
################新增ICD基本資料###############
#        LET l_n = 0 
#        SELECT COUNT(*) INTO l_n
#          FROM icb_file
#         WHERE icb01 = l_res
#         IF l_n > 0 THEN
#            CONTINUE FOREACH
#         END IF
#         
#        INSERT INTO icb_file(icb01) VALUES(l_res)
#        IF SQLCA.sqlcode THEN
#           CALL cl_err3("ins","icb_file",l_res,"",SQLCA.sqlcode,"","",1)
#           CONTINUE FOREACH
#        END IF
      END FOREACH
 
 
################新增下階料資料################
      IF l_tmpary.getlength() > 1 THEN
         #FUN-C30082---begin
         IF NOT cl_null(l_icv10) THEN   #若有斷階料號設定,上一層即為斷階料號
            CALL s_aic_bom_ins_icm(l_icv10,l_tmpary[1].ima01)
         END IF
         #FUN-C30082---end
      
         FOR l_i = 1 TO l_tmpary.getlength() - 1 
             CALL s_aic_bom_ins_icm(l_tmpary[l_i].ima01,l_tmpary[l_i+1].ima01)         
             #FUN-C30082---begin mark
             #LET l_icm.icm01 = l_tmpary[l_i].ima01
             #LET l_icm.icm02 = l_tmpary[l_i+1].ima01
             #IF cl_null(p_newcode) THEN
             #   LET l_icm.icm04 = p_ima01
             #ELSE 
             #   LET l_icm.icm04 = p_newcode
             #END IF    
             #LET l_icm.icmuser = g_user
             #LET l_icm.icmgrup = g_grup
             #LET l_icm.icmacti = 'Y'
   
             #INSERT INTO icm_file VALUES(l_icm.*)          
             
             #IF SQLCA.sqlcode THEN
             #   CALL cl_err3("ins","icm_file",l_tmpary[l_i].ima01,"",SQLCA.sqlcode,"","",1)
             #   RETURN 
             #END IF
             #FUN-C30082---end
         END FOR
      END IF 
      LET l_i = l_tmpary.getlength()
      #FUN-C30082---begin
      IF l_i > 1 AND NOT cl_null(l_icv10) THEN
         IF (l_tmpary[1].icv05 = '3' OR l_tmpary[1].icv05 = '4') 
         AND (l_icv05 = '1' OR l_icv05 = '2') THEN
            LET l_bmb07 = l_imaicd14
         ELSE 
            LET l_bmb07 = NULL 
         END IF 
         CALL s_aic_bom_ins_bmb(l_tmpary[1].ima01,l_icv10,l_icv04_1,p_newcode,p_ima01,l_bmb07)
      END IF 
      #FUN-C30082---end
      WHILE l_i > 1
     
################新增bma_file##################
          #FUN-C30082---begin mark
          #LET l_bma.bma01 = l_tmpary[l_i].ima01
          #LET l_bma.bma06 = ' '
          #LET l_bma.bma08 = ' '
          #LET l_bma.bma10 = '0'
          #LET l_bma.bmauser = g_user
          #LET l_bma.bmagrup = g_grup
          #LET l_bma.bmaacti = 'Y'
          #IF cl_null(p_newcode) THEN
          #   LET l_bma.bmaicd01 = p_ima01
          #ELSE
          #   LET l_bma.bmaicd01 = p_newcode
          #END IF    
          #LET l_bma.bma05 = NULL  #MOD-C30360

          #INSERT INTO bma_file VALUES(l_bma.*)
          
          #IF SQLCA.sqlcode THEN
          #   CALL cl_err3("ins","bma_file",l_tmpary[l_i].ima01,"",SQLCA.sqlcode,"","",1)
          #   LET l_i = l_i -1
          #   CONTINUE WHILE
          #END IF
 
################新增bmb_file##################
          #SELECT ima63,ima63_fac,ima70,ima35 
          #  INTO l_ima63,l_ima63_fac,l_ima70,l_ima35
          #  FROM ima_file
          # WHERE ima01 = l_tmpary[l_i-1].ima01          
          #LET l_bmb.bmb01 = l_tmpary[l_i].ima01
          #LET l_bmb.bmb29 = ''
          #LET l_bmb.bmb03 = l_tmpary[l_i-1].ima01
          #LET l_bmb.bmb04 = g_today
          #LET l_bmb.bmb05 = ' '
          #LET l_bmb.bmb06 = 1
          #LET l_bmb.bmb07 = 1
          #LET l_bmb.bmb08 = 0
          #LET l_bmb.bmb09 = l_tmpary[l_i-1].icv04
          #LET l_bmb.bmb10 = l_ima63
          #LET l_bmb.bmb10_fac = l_ima63_fac
          #LET l_bmb.bmb10_fac2 = l_ima63_fac
          #LET l_bmb.bmb15 = l_ima70
          #LET l_bmb.bmb16 = '0'
          #LET l_bmb.bmb19 = '1'
          #LET l_bmb.bmb25 = l_ima35
          #LET l_bmb.bmb27 = 'N'
          #LET l_bmb.bmb28 = 0
          #LET l_bmb.bmb29 = ' '
          #LET l_bmb.bmb33 = 0

          #INSERT INTO bmb_file VALUES(l_bmb.*)
          
          #IF SQLCA.sqlcode THEN
          #   CALL cl_err3("ins","bmb_file",l_tmpary[l_i].ima01,"",SQLCA.sqlcode,"","",1)
          #   LET l_i = l_i -1
          #   CONTINUE WHILE
          #END IF
          #FUN-C30082---end
         #若icv05=3或4, 上階料號icv05=1或2時bmb07 = 母體料號gross die
         #FUN-C30082---begin
         IF (l_tmpary[l_i].icv05 = '3' OR l_tmpary[l_i].icv05 = '4') 
         AND (l_tmpary[l_i - 1].icv05 = '1' OR l_tmpary[l_i - 1].icv05 = '2') THEN
            LET l_bmb07 = l_imaicd14
         ELSE 
            LET l_bmb07 = NULL 
         END IF 
         CALL s_aic_bom_ins_bmb(l_tmpary[l_i].ima01,l_tmpary[l_i-1].ima01,l_tmpary[l_i-1].icv04,p_newcode,p_ima01,l_bmb07)
         #FUN-C30082---end
         LET l_i = l_i -1
      END WHILE
      
      CALL l_tmpary.clear()
      LET l_i = 0      
   
END FUNCTION
#FUN-BC0106 --END-- 
#No.FUN-7B0018 create the program

#FUN-C30082---begin
FUNCTION s_aic_bom_ins_icm(p_icm01,p_icm02)
DEFINE p_icm01 LIKE icm_file.icm01
DEFINE p_icm02 LIKE icm_file.icm02
DEFINE l_icm   RECORD LIKE icm_file.*

   LET l_icm.icm01 = p_icm01
   LET l_icm.icm02 = p_icm02                
   LET l_icm.icmuser = g_user
   LET l_icm.icmgrup = g_grup
   LET l_icm.icmacti = 'Y'
   INSERT INTO icm_file VALUES(l_icm.*) 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","icm_file",p_icm01,"",SQLCA.sqlcode,"","",1)
      RETURN 
   END IF
END FUNCTION 

FUNCTION s_aic_bom_ins_bmb(p_bmb01,p_bmb03,p_icv04,p_newcode,p_ima01,p_bmb07)
   DEFINE p_bmb01 LIKE bmb_file.bmb01
   DEFINE p_bmb03 LIKE bmb_file.bmb03
   DEFINE p_icv04 LIKE icv_file.icv04
   DEFINE p_newcode    LIKE icw_file.icw01
   DEFINE p_ima01      LIKE ima_file.ima01
   DEFINE p_bmb07      LIKE bmb_file.bmb07
   DEFINE l_ima63      LIKE ima_file.ima63
   DEFINE l_ima63_fac  LIKE ima_file.ima63_fac
   DEFINE l_ima70      LIKE ima_file.ima70
   DEFINE l_ima35      LIKE ima_file.ima35
   DEFINE l_bma        RECORD LIKE bma_file.*    
   DEFINE l_bmb        RECORD LIKE bmb_file.* 
   DEFINE l_imaicd04   LIKE imaicd_file.imaicd04  #TQC-C60149
   DEFINE l_imaicd14   LIKE imaicd_file.imaicd14  #TQC-C60149
   DEFINE l_imaicd04_2 LIKE imaicd_file.imaicd04  #MOD-C90127
   DEFINE l_imaicd14_2 LIKE imaicd_file.imaicd14  #MOD-C90127
################新增bma_file##################
   LET l_bma.bma01 = p_bmb01
   LET l_bma.bma06 = ' '
   LET l_bma.bma08 = ' '
   #LET l_bma.bma10 = '0'  #FUN-C30082
   LET l_bma.bma10 = '2'   #FUN-C30082
   LET l_bma.bmauser = g_user
   LET l_bma.bmagrup = g_grup
   LET l_bma.bmaacti = 'Y'
   IF cl_null(p_newcode) THEN
      LET l_bma.bmaicd01 = p_ima01
   ELSE
      LET l_bma.bmaicd01 = p_newcode
   END IF    
   #LET l_bma.bma05 = NULL  #MOD-C30360  #FUN-C30082
   LET l_bma.bma05 = g_today  #FUN-C30082
   INSERT INTO bma_file VALUES(l_bma.*)
          
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","bma_file",p_bmb01,"",SQLCA.sqlcode,"","",1)
      RETURN 
   END IF 
################新增bmb_file##################    
   SELECT ima63,ima63_fac,ima70,ima35 
      INTO l_ima63,l_ima63_fac,l_ima70,l_ima35
      FROM ima_file
      WHERE ima01 = p_bmb03  
   #TQC-C60183---begin
   IF SQLCA.sqlcode THEN
      SELECT imaa63,imaa63_fac,imaa70,imaa35 
        INTO l_ima63,l_ima63_fac,l_ima70,l_ima35
        FROM imaa_file
       WHERE imaa01 = p_bmb03   
   END IF 
   #TQC-C60183---end    
   LET l_bmb.bmb01 = p_bmb01
   LET l_bmb.bmb29 = ''
   LET l_bmb.bmb03 = p_bmb03
   LET l_bmb.bmb04 = g_today
   LET l_bmb.bmb05 = ' '
   LET l_bmb.bmb06 = 1
   LET l_bmb.bmb08 = 0
   #LET l_bmb.bmb09 = p_icv04  #TQC-C60201
   LET l_bmb.bmb10 = l_ima63
   LET l_bmb.bmb10_fac = l_ima63_fac
   LET l_bmb.bmb10_fac2 = l_ima63_fac
   LET l_bmb.bmb14 = '0'  #TQC-C60003
   LET l_bmb.bmb15 = l_ima70
   LET l_bmb.bmb16 = '0'
   LET l_bmb.bmb19 = '1'
   LET l_bmb.bmb25 = l_ima35
   LET l_bmb.bmb27 = 'N'
   LET l_bmb.bmb28 = 0
   LET l_bmb.bmb29 = ' '
   LET l_bmb.bmb33 = 0
   LET l_bmb.bmb02 = g_sma.sma19  #FUN-C30082
   LET l_bmb.bmb081 = 0  #TQC-C60003
   LET l_bmb.bmb082 = 1  #TQC-C60003
   LET l_bmb.bmb31 = 'N' #TQC-C60003
   
   IF cl_null(p_bmb07) THEN
      LET l_bmb.bmb07 = 1
   ELSE 
      LET l_bmb.bmb07 = p_bmb07
   END IF 
   LET l_imaicd04 = NULL  #TQC-C60183
   LET l_imaicd14 = NULL  #TQC-C60183
   #TQC-C60149---begin
   SELECT imaicd04,imaicd14 INTO l_imaicd04,l_imaicd14
     FROM imaicd_file WHERE imaicd00 = p_bmb03
   #TQC-C60183---begin
   IF cl_null(l_imaicd04) THEN
      SELECT imaaicd04,imaaicd14 
        INTO l_imaicd04,l_imaicd14
        FROM imaa_file
       WHERE imaa01 = p_bmb03   
   END IF 
   #TQC-C60183---end  
   #MOD-C90127 add---S
   SELECT imaicd04,imaicd14 INTO l_imaicd04_2,l_imaicd14_2
     FROM imaicd_file WHERE imaicd00 = p_bmb01
   IF cl_null(l_imaicd04) THEN
      SELECT imaaicd04,imaaicd14 
        INTO l_imaicd04_2,l_imaicd14_2
        FROM imaa_file
       WHERE imaa01 = p_bmb01   
   END IF 
   #MOD-C90127 add---E
  #IF l_imaicd04 ='2' THEN                           #MOD-C90127 mark
   IF l_imaicd04 ='2' AND l_imaicd04_2 <>'2' THEN    #MOD-C90127
      LET l_bmb.bmb07 = l_imaicd14
   ELSE                                              #MOD-C90127
      LET l_bmb.bmb07 = 1                            #MOD-C90127
   END IF  
   #TQC-C60149---end   
   INSERT INTO bmb_file VALUES(l_bmb.*)
          
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","bmb_file",p_bmb01,"",SQLCA.sqlcode,"","",1)
      RETURN
   END IF
END FUNCTION 
#FUN-C30082---end
