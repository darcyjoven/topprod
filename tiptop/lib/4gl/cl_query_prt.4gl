# Prog. Version..: '5.30.06-13.03.12(00010)'     #
# 
# Library name...: cl_query_prt
# Descriptions...: 執行自定義查詢報表
# Input parameter: p_prog   查詢單ID
#                  p_cust   客製碼
#                  p_str    SQL 指令
# Return code....: none
# Usage..........: call cl_query_prt(p_prog,p_cust,p_str)   
# Date & Author..: 2006/09/15 No.FUN-690069 By Echo 
# Modify.........: 2006/01/29 No.FUN-730005 By Echo
# Modify.........: No.FUN-750084 07/05/23 By Echo 新增客製碼欄位
# Modify.........: No.FUN-770079 07/07/24 By Echo 第二階段功能調整:欄位值轉換功能、查詢畫面 Input 功能...等
# Modify.........: No.TQC-790050 07/09/17 By Echo BUG調整: 資料轉換欄位，若設定排序會異常。
# Modify.........: No.TQC-790154 07/09/28 By Echo SQL指令包含中文字時會抓取不到資料...
# Modify.........: No.TQC-790173 07/09/29 By Echo 部份報表列印時，列印條件沒有轉為欄位名稱...
# Modify.........: No.FUN-7B0010 07/11/06 By Echo 功能調整<part1>
# Modify.........: No.FUN-7C0020 07/12/06 By Echo 功能調整<part2>
# Modify.........: No.FUN-7C0067 07/12/20 By Echo 調整 LIB function 說明
# Modify.........: No.FUN-810021 08/01/09 By Echo 調整權限部份應與 p_zy 勾稽
# Modify.........: No.TQC-810053 08/01/17 By Echo 功能異常調整
# Modify.........: No.TQC-810073 08/01/24 By joyce 修改判斷不同資料庫別時的處理,
#                                                  原呼叫db_get_database_type()，改為呼叫cl_db_get_database_type()
# Modify.........: No.TQC-810080 08/01/25 By joyce 修改TQC-810073的註解
# Modify.........: No.FUN-810062 08/01/23 By Echo 調整 p_query 作業可以在 Windows 版執行
# Modify.........: No.FUN-820043 08/02/13 By Echo p_query 功能調整
# Modify.........: No.TQC-860016 08/06/06 By saki 修改ON IDLE段
# Modify.........: No.CHI-870002 08/07/24 By Echo 調整計算式欄位
# Modify.........: No.TQC-810077 08/07/25 By Echo p_query 調整 Local Print List 輸出印表機時列印異常
# Modify.........: No.MOD-890009 08/09/09 By Echo 查詢視窗,在日期欄位輸入 >= 2008/08/01 條件會出現(-1106)欄位錯誤
# Modify.........: No.MOD-890218 08/09/25 By Echo 查詢視窗,在日期欄位輸入 08/08/01 條件會出現(-1106)欄位錯誤
# Modify.........: No.FUN-860089 08/12/12 By Echo 新增 CR Viewer 預覽查詢功能
# Modify.........: No.MOD-910058 09/01/08 By Echo 資料庫日期型態改為月/日/年時，列印時日期欄位內容都呈現空白
# Modify.........: No.FUN-940109 09/04/21 By Echo 列印時，GDC 異常crash
# Modify.........: No.TQC-950089 09/06/01 By Echo select 欄位為大寫時無法正確顯示
# Modify.........: No.CHI-940001 09/06/01 By Echo p_query的資料轉換無法使用原來的值
# Modify.........: No.FUN-920079 09/06/02 By Echo select eci_file.eci01 但欄位設定為 eci01 時，資料無法正確顯示
# Modify.........: No.FUN-980030 09/08/06 By Hiko 權限設定改呼叫cl_get_extra_cond
# Modify.........: No.TQC-9C0014 09/12/07 By Echo select odc04,odc041 當 odc04 有設定"資料轉換設定"時會發生SQL錯誤
# Modify.........: No:FUN-A10041 10/01/08 By Hiko 表頭也顯示營運中心的說明
# Modify.........: No:FUN-A30115 10/03/30 By Echo GP5.2 匯出excel問題
# Modify.........: No.FUN-9C0036 10/04/06 By Echo 查詢特殊的 synonym table 無資料
# Modify.........: No.FUN-A60085 10/06/28 By Jay 呼叫cl_query_prt_getlength()只做一次CREATE TEMP TABLE
# Modify.........: No.FUN-A80029 10/08/09 By Echo GP5.2 msv 版本調整
# Modify.........: No.FUN-A90047 10/09/15 By Echo 改善效能，指定 <tr> 高度值可減少開啟excel時間
# Modify.........: No.FUN-AA0017 10/10/22 By alex ASE 版本調整
# Modify.........: No.FUN-A90024 10/11/05 By Jay 調整各DB利用sch_file取得table與field等資訊
# Modify.........: No.FUN-AA0074 11/01/24 By Jay 列印轉excel格式會無法顯示千分位
# Modify.........: No.FUN-AB0037 11/01/26 By Jay 修改execl匯出筆數限制
# Modify.........: No.FUN-B10042 11/02/10 By Jay 修改日期欄位在輸入條件為'='時,所發生錯誤
# Modify.........: No.FUN-AC0011 11/03/08 By Jay 調整截取sql語法中table name、別名、欄位名稱方式
# Modify.........: No.FUN-B30005 11/04/06 By jenjwu 修改若查無資料便自動關窗的錯誤
# Modify.........: No.FUN-A20036 11/05/10 By Henry 在輸出字串前後加上<span> parameter 以保持字串空格原狀
# Modify.........: No.MOD-B50179 11/05/24 By Echo 修正欄位的判斷處理
# Modify.........: No.FUN-B50137 11/06/08 By CaryHsu 增加函數說明註解
# Modify.........: No.TQC-B90082 11/09/09 By Echo 調整Excel設定跳頁的資料異常
# Modify.........: No:FUN-BB0005 11/11/07 BY LeoChang 新增報表TITLE是否呈現營運中心的參數讓user做選擇
# Modify.........: No.TQC-BB0068 11/12/18 By ka0132 調整資料輸出時小數點輸出異常
# Modify.........: No.MOD-C30123 12/03/12 By madey 修正l_msg格式與cl_cl_ui_init.4gl一致 
# Modify.........: No.MOD-C40107 12/04/17 By madey 修正取時區(azp052)時的where condition
# Modify.........: No.TQC-C90102 12/09/24 By LeoChang 修正p_query列印時，使用欄位相乘的小計會空白的問題  
# Modify.........: No.FUN-D20028 13/02/21 By LeoChang 修正Windows XP Title顯示問題
    
import os
DATABASE ds
 
#FUN-690069,FUN-730005,FUN-7C0067
 
GLOBALS "../../config/top.global"
GLOBALS
  DEFINE ms_codeset    STRING
  DEFINE ms_locale     STRING
#No.FUN-860089 -- start -- 
  DEFINE g_query_prog    LIKE gcy_file.gcy01                   #查詢單ID  #No.FUN-860089
  DEFINE g_query_cust    LIKE gcy_file.gcy05                   #客製否    #No.FUN-860089
  DEFINE g_zal_err       LIKE type_file.num5                   #判斷欄位在 zal 是否有設定資料
  DEFINE g_qry_feld_type DYNAMIC ARRAY OF LIKE type_file.chr30 #欄位型態
  DEFINE ga_table_data DYNAMIC ARRAY OF RECORD
     field001, field002, field003, field004, field005, field006, field007,
     field008, field009, field010, field011, field012, field013, field014,
     field015, field016, field017, field018, field019, field020, field021,
     field022, field023, field024, field025, field026, field027, field028,
     field029, field030, field031, field032, field033, field034, field035,
     field036, field037, field038, field039, field040, field041, field042,
     field043, field044, field045, field046, field047, field048, field049,
     field050, field051, field052, field053, field054, field055, field056,
     field057, field058, field059, field060, field061, field062, field063,
     field064, field065, field066, field067, field068, field069, field070,
     field071, field072, field073, field074, field075, field076, field077,
     field078, field079, field080, field081, field082, field083, field084,
     field085, field086, field087, field088, field089, field090, field091,
     field092, field093, field094, field095, field096, field097, field098,
     field099, field100  STRING
    #field101, field102, field103, field104, field105, field106, field107,
    #field108, field109, field110, field111, field112, field113, field114,
    #field115, field116, field117, field118, field119, field120, field121,
    #field122, field123, field124, field125, field126, field127, field128,
    #field129, field130, field131, field132, field133, field134, field135,
    #field136, field137, field138, field139, field140, field141, field142,
    #field143, field144, field145, field146, field147, field148, field149,
    #field150, field151, field152, field153, field154, field155, field156,
    #field157, field158, field159, field160, field161, field162, field163,
    #field164, field165, field166, field167, field168, field169, field170,
    #field171, field172, field173, field174, field175, field176, field177,
    #field178, field179, field180, field181, field182, field183, field184,
    #field185, field186, field187, field188, field189, field190, field191,
    #field192, field193, field194, field195, field196, field197, field198,
    #field199, field200  STRING
     END RECORD
END GLOBALS
#No.FUN-860089 -- end -- 
 
DEFINE g_db_type       LIKE type_file.chr3,   
       g_query_rec_b   LIKE type_file.num10                  #dbqry單身筆數
DEFINE g_qry_feld_cnt  LIKE type_file.num5                   #欄位數
DEFINE g_qry_feld      DYNAMIC ARRAY OF STRING               #欄位名稱
DEFINE g_qry_scale     DYNAMIC ARRAY OF LIKE type_file.num10 #欄位小數點
DEFINE g_scale_curr    DYNAMIC ARRAY OF RECORD
                       curr_col     LIKE type_file.num5,     #小數位欄位的幣別欄位
                       scale_type   LIKE type_file.num5,     #小數位欄位型態
                       aza17        LIKE type_file.chr1      #是否為aza17
                       END RECORD
DEFINE g_qry_length    DYNAMIC ARRAY OF LIKE type_file.num5  #欄位長度
DEFINE g_qry_feld_t    DYNAMIC ARRAY OF STRING               #欄位ID
DEFINE g_qry_show      DYNAMIC ARRAY OF LIKE zat_file.zat03  #欄位顯示欄位
DEFINE g_show_cnt      LIKE type_file.num5                   #顯示欄位數 #FUN-770079
DEFINE g_qry_feld_tmp  LIKE type_file.chr1000                 
DEFINE g_qry_feld_name LIKE type_file.chr1000                 
DEFINE g_qry_feldname  LIKE type_file.chr1000 
DEFINE g_feld_group    DYNAMIC ARRAY OF STRING               #依群組顯示 
DEFINE g_feld_sum      DYNAMIC ARRAY WITH DIMENSION 2 OF LIKE zan_file.zan03
DEFINE g_sum_name      DYNAMIC ARRAY OF STRING
DEFINE g_sum_rec       DYNAMIC ARRAY OF RECORD              #記錄計算的小計
                         group_item LIKE type_file.num10,      #group sum 個數
                         group_sum  LIKE type_file.num26_10,   #group sum 小計
                         total_item LIKE type_file.num10,      #total sum 個數
                         total_sum  LIKE type_file.num26_10    #total sum
                       END RECORD
DEFINE g_zai01         LIKE zai_file.zai01
DEFINE g_zai02         LIKE zai_file.zai02
DEFINE g_zai04         LIKE zai_file.zai04
DEFINE g_zai06         LIKE zai_file.zai06                   #FUN-770079
DEFINE g_zai07         LIKE zai_file.zai07                   #No.FUN-810021
define g_zaiud01       like zai_file.zaiud01                 #darcy:2023/06/09 add
DEFINE g_zao04         DYNAMIC ARRAY OF LIKE zao_file.zao04
DEFINE g_zan_cnt       LIKE type_file.num5
DEFINE g_zam           DYNAMIC ARRAY OF RECORD
                             zal04  LIKE zal_file.zal04,
                             zam07  LIKE zam_file.zam07,
                             zam08  LIKE zam_file.zam08
                       END RECORD
DEFINE g_out_type      LIKE zao_file.zao03
DEFINE g_zao02         LIKE zao_file.zao02
DEFINE g_zao04_2       LIKE zao_file.zao04
DEFINE g_zap           RECORD LIKE zap_file.*
DEFINE g_execmd        STRING                              #SQL指令
DEFINE g_zan           DYNAMIC ARRAY OF RECORD
                             zal04  LIKE zal_file.zal04,   #欄位代號
                             zan03  LIKE zan_file.zan03,   #計算式
                             zan04  LIKE zan_file.zan04,   #依group欄位
                             zan05  LIKE zan_file.zan05,   #group 欄位序號
                             gzal04 LIKE zal_file.zal04,   #group 欄位代號
                             zan07  LIKE zan_file.zan07    #顯示方式 #FUN-770079
                       END RECORD
DEFINE g_zau02         LIKE zau_file.zau02                 #權限-資料所有者
DEFINE g_zau03         LIKE zau_file.zau03                 #權限-資料群組
DEFINE g_field_seq     DYNAMIC ARRAY OF RECORD             #記錄查詢欄位順序
                         id   STRING,                      #欄位代碼
                         name STRING,                      #欄位名稱 
                         len  LIKE type_file.num5,         #欄位寬度 
                         type LIKE type_file.chr30,        #欄位型態 
                         qbe  LIKE zat_file.zat06          #開窗(QBE) 
                       END RECORD
DEFINE g_qry_qbe       DYNAMIC ARRAY OF LIKE zat_file.zat06  #欄位開窗
DEFINE g_page_max_rec    LIKE type_file.num10
DEFINE g_data_end        LIKE type_file.num10                #讀取資料是否結束
DEFINE g_data_end_total  LIKE type_file.num10                #讀取資料是否結束
DEFINE ga_table_data_t DYNAMIC ARRAY OF RECORD
     field001, field002, field003, field004, field005, field006, field007,
     field008, field009, field010, field011, field012, field013, field014,
     field015, field016, field017, field018, field019, field020, field021,
     field022, field023, field024, field025, field026, field027, field028,
     field029, field030, field031, field032, field033, field034, field035,
     field036, field037, field038, field039, field040, field041, field042,
     field043, field044, field045, field046, field047, field048, field049,
     field050, field051, field052, field053, field054, field055, field056,
     field057, field058, field059, field060, field061, field062, field063,
     field064, field065, field066, field067, field068, field069, field070,
     field071, field072, field073, field074, field075, field076, field077,
     field078, field079, field080, field081, field082, field083, field084,
     field085, field086, field087, field088, field089, field090, field091,
     field092, field093, field094, field095, field096, field097, field098,
     field099, field100  STRING
    #field101, field102, field103, field104, field105, field106, field107,
    #field108, field109, field110, field111, field112, field113, field114,
    #field115, field116, field117, field118, field119, field120, field121,
    #field122, field123, field124, field125, field126, field127, field128,
    #field129, field130, field131, field132, field133, field134, field135,
    #field136, field137, field138, field139, field140, field141, field142,
    #field143, field144, field145, field146, field147, field148, field149,
    #field150, field151, field152, field153, field154, field155, field156,
    #field157, field158, field159, field160, field161, field162, field163,
    #field164, field165, field166, field167, field168, field169, field170,
    #field171, field172, field173, field174, field175, field176, field177,
    #field178, field179, field180, field181, field182, field183, field184,
    #field185, field186, field187, field188, field189, field190, field191,
    #field192, field193, field194, field195, field196, field197, field198,
    #field199, field200  STRING
     END RECORD
DEFINE ga_page_data DYNAMIC ARRAY OF RECORD
     field001, field002, field003, field004, field005, field006, field007,
     field008, field009, field010, field011, field012, field013, field014,
     field015, field016, field017, field018, field019, field020, field021,
     field022, field023, field024, field025, field026, field027, field028,
     field029, field030, field031, field032, field033, field034, field035,
     field036, field037, field038, field039, field040, field041, field042,
     field043, field044, field045, field046, field047, field048, field049,
     field050, field051, field052, field053, field054, field055, field056,
     field057, field058, field059, field060, field061, field062, field063,
     field064, field065, field066, field067, field068, field069, field070,
     field071, field072, field073, field074, field075, field076, field077,
     field078, field079, field080, field081, field082, field083, field084,
     field085, field086, field087, field088, field089, field090, field091,
     field092, field093, field094, field095, field096, field097, field098,
     field099, field100  STRING
    #field101, field102, field103, field104, field105, field106, field107,
    #field108, field109, field110, field111, field112, field113, field114,
    #field115, field116, field117, field118, field119, field120, field121,
    #field122, field123, field124, field125, field126, field127, field128,
    #field129, field130, field131, field132, field133, field134, field135,
    #field136, field137, field138, field139, field140, field141, field142,
    #field143, field144, field145, field146, field147, field148, field149,
    #field150, field151, field152, field153, field154, field155, field156,
    #field157, field158, field159, field160, field161, field162, field163,
    #field164, field165, field166, field167, field168, field169, field170,
    #field171, field172, field173, field174, field175, field176, field177,
    #field178, field179, field180, field181, field182, field183, field184,
    #field185, field186, field187, field188, field189, field190, field191,
    #field192, field193, field194, field195, field196, field197, field198,
    #field199, field200  STRING
     END RECORD
DEFINE ga_page_data_t RECORD
     field001, field002, field003, field004, field005, field006, field007,
     field008, field009, field010, field011, field012, field013, field014,
     field015, field016, field017, field018, field019, field020, field021,
     field022, field023, field024, field025, field026, field027, field028,
     field029, field030, field031, field032, field033, field034, field035,
     field036, field037, field038, field039, field040, field041, field042,
     field043, field044, field045, field046, field047, field048, field049,
     field050, field051, field052, field053, field054, field055, field056,
     field057, field058, field059, field060, field061, field062, field063,
     field064, field065, field066, field067, field068, field069, field070,
     field071, field072, field073, field074, field075, field076, field077,
     field078, field079, field080, field081, field082, field083, field084,
     field085, field086, field087, field088, field089, field090, field091,
     field092, field093, field094, field095, field096, field097, field098,
     field099, field100  STRING
    #field101, field102, field103, field104, field105, field106, field107,
    #field108, field109, field110, field111, field112, field113, field114,
    #field115, field116, field117, field118, field119, field120, field121,
    #field122, field123, field124, field125, field126, field127, field128,
    #field129, field130, field131, field132, field133, field134, field135,
    #field136, field137, field138, field139, field140, field141, field142,
    #field143, field144, field145, field146, field147, field148, field149,
    #field150, field151, field152, field153, field154, field155, field156,
    #field157, field158, field159, field160, field161, field162, field163,
    #field164, field165, field166, field167, field168, field169, field170,
    #field171, field172, field173, field174, field175, field176, field177,
    #field178, field179, field180, field181, field182, field183, field184,
    #field185, field186, field187, field188, field189, field190, field191,
    #field192, field193, field194, field195, field196, field197, field198,
    #field199, field200  STRING
     END RECORD
DEFINE ga_page_data_o RECORD
     field001, field002, field003, field004, field005, field006, field007,
     field008, field009, field010, field011, field012, field013, field014,
     field015, field016, field017, field018, field019, field020, field021,
     field022, field023, field024, field025, field026, field027, field028,
     field029, field030, field031, field032, field033, field034, field035,
     field036, field037, field038, field039, field040, field041, field042,
     field043, field044, field045, field046, field047, field048, field049,
     field050, field051, field052, field053, field054, field055, field056,
     field057, field058, field059, field060, field061, field062, field063,
     field064, field065, field066, field067, field068, field069, field070,
     field071, field072, field073, field074, field075, field076, field077,
     field078, field079, field080, field081, field082, field083, field084,
     field085, field086, field087, field088, field089, field090, field091,
     field092, field093, field094, field095, field096, field097, field098,
     field099, field100  STRING
    #field101, field102, field103, field104, field105, field106, field107,
    #field108, field109, field110, field111, field112, field113, field114,
    #field115, field116, field117, field118, field119, field120, field121,
    #field122, field123, field124, field125, field126, field127, field128,
    #field129, field130, field131, field132, field133, field134, field135,
    #field136, field137, field138, field139, field140, field141, field142,
    #field143, field144, field145, field146, field147, field148, field149,
    #field150, field151, field152, field153, field154, field155, field156,
    #field157, field158, field159, field160, field161, field162, field163,
    #field164, field165, field166, field167, field168, field169, field170,
    #field171, field172, field173, field174, field175, field176, field177,
    #field178, field179, field180, field181, field182, field183, field184,
    #field185, field186, field187, field188, field189, field190, field191,
    #field192, field193, field194, field195, field196, field197, field198,
    #field199, field200  STRING
                  END RECORD
DEFINE ga_sum_data DYNAMIC ARRAY WITH DIMENSION 2 OF RECORD
     field001, field002, field003, field004, field005, field006, field007,
     field008, field009, field010, field011, field012, field013, field014,
     field015, field016, field017, field018, field019, field020, field021,
     field022, field023, field024, field025, field026, field027, field028,
     field029, field030, field031, field032, field033, field034, field035,
     field036, field037, field038, field039, field040, field041, field042,
     field043, field044, field045, field046, field047, field048, field049,
     field050, field051, field052, field053, field054, field055, field056,
     field057, field058, field059, field060, field061, field062, field063,
     field064, field065, field066, field067, field068, field069, field070,
     field071, field072, field073, field074, field075, field076, field077,
     field078, field079, field080, field081, field082, field083, field084,
     field085, field086, field087, field088, field089, field090, field091,
     field092, field093, field094, field095, field096, field097, field098,
     field099, field100  STRING
    #field101, field102, field103, field104, field105, field106, field107,
    #field108, field109, field110, field111, field112, field113, field114,
    #field115, field116, field117, field118, field119, field120, field121,
    #field122, field123, field124, field125, field126, field127, field128,
    #field129, field130, field131, field132, field133, field134, field135,
    #field136, field137, field138, field139, field140, field141, field142,
    #field143, field144, field145, field146, field147, field148, field149,
    #field150, field151, field152, field153, field154, field155, field156,
    #field157, field158, field159, field160, field161, field162, field163,
    #field164, field165, field166, field167, field168, field169, field170,
    #field171, field172, field173, field174, field175, field176, field177,
    #field178, field179, field180, field181, field182, field183, field184,
    #field185, field186, field187, field188, field189, field190, field191,
    #field192, field193, field194, field195, field196, field197, field198,
    #field199, field200  STRING
                  END RECORD
 
DEFINE g_zak02         LIKE zak_file.zak02
DEFINE g_header_str    STRING,    # Header Content
       g_trailer_str   STRING,    # Trailer Content
       g_curr_page     LIKE type_file.num10,   # Current Page Number
       g_total_page    LIKE type_file.num10,   # Total Pages 
       g_total_page_t  LIKE type_file.num10    # Total Pages-備用
DEFINE g_rec_b         LIKE type_file.num10     #單身筆數
DEFINE g_rec_b_t       LIKE type_file.num10     #單身筆數-備份
DEFINE l_ac            LIKE type_file.num10     #目前處理的ARRAY CNT
DEFINE g_max_tag       LIKE type_file.num5
DEFINE g_next_tag      LIKE type_file.chr1
DEFINE g_curr_table    LIKE type_file.num10
DEFINE g_curr_page_t   LIKE type_file.num10
DEFINE g_col_value     STRING 
DEFINE g_col_text      STRING
DEFINE g_wc            STRING                  #查詢條件
DEFINE g_wc2           STRING                  #過濾條件
DEFINE g_wc_name       STRING                  #查詢條件 -列印條件
DEFINE g_wc2_name      STRING                  #過濾條件 -列印條件
DEFINE g_auth_wc       STRING                  #權限條件
DEFINE g_sql_wc        STRING
#--FUN-770079
#進階查詢變數
DEFINE g_dis_zal       DYNAMIC ARRAY OF RECORD         #設定顯示/隱藏資料     
                       check   LIKE type_file.chr1,    
                       zal04   LIKE zal_file.zal04,       
                       zal05   LIKE zal_file.zal04       
                       END RECORD
DEFINE g_more          RECORD                          #排序/跳頁/計算方式
                       s1   LIKE zal_file.zal05,    
                       s2   LIKE zal_file.zal05,      
                       s3   LIKE zal_file.zal05,     
                       t1   LIKE type_file.chr1,     
                       t2   LIKE type_file.chr1,     
                       t3   LIKE type_file.chr1,     
                       u1   LIKE type_file.chr1,     
                       u2   LIKE type_file.chr1,     
                       u3   LIKE type_file.chr1     
                       END RECORD
DEFINE g_zan1          DYNAMIC ARRAY OF RECORD         #計算1(SUM)     
                       nzal04_1   LIKE zal_file.zal04,    
                       nzal05_1   LIKE zal_file.zal05,       
                       zan03_1    LIKE zan_file.zan03,       
                       zan07_1    LIKE zan_file.zan07       
                       END RECORD
DEFINE g_zan2          DYNAMIC ARRAY OF RECORD         #計算2(SUM)     
                       nzal04_2   LIKE zal_file.zal04,    
                       nzal05_2   LIKE zal_file.zal05,       
                       zan03_2    LIKE zan_file.zan03,       
                       zan07_2    LIKE zan_file.zan07       
                       END RECORD
DEFINE g_zan3          DYNAMIC ARRAY OF RECORD         #計算3(SUM)     
                       nzal04_3   LIKE zal_file.zal04,    
                       nzal05_3   LIKE zal_file.zal05,       
                       zan03_3    LIKE zan_file.zan03,       
                       zan07_3    LIKE zan_file.zan07       
                       END RECORD
DEFINE g_zan1_rec_b    LIKE type_file.num10            #計算式1單身筆數
DEFINE g_zan2_rec_b    LIKE type_file.num10            #計算式2單身筆數
DEFINE g_zan3_rec_b    LIKE type_file.num10            #計算式3單身筆數
#--END FUN-770079
DEFINE g_zz011         LIKE zz_file.zz011              #No.FUN-810021
DEFINE g_db_tag        LIKE type_file.chr1             #No.FUN-860089
 
CONSTANT GI_MAX_COLUMN_COUNT INTEGER = 100,
         GI_COLUMN_WIDTH     INTEGER = 10
 
FUNCTION cl_query_prt(p_prog,p_cust,p_str)                      ##FUN-750084
DEFINE p_prog      LIKE zai_file.zai01   
DEFINE p_cust      LIKE zai_file.zai05                          ##FUN-750084
DEFINE p_str       LIKE zak_file.zak02
DEFINE l_window    ui.Window
DEFINE l_sql       STRING
DEFINE l_cnt       LIKE type_file.num5
DEFINE l_status    LIKE type_file.num5                          #FUN-810021
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    LET g_query_prog = p_prog CLIPPED
    LET g_query_cust = p_cust CLIPPED                           #FUN-750084
    LET g_zak02 = p_str
    IF cl_null(g_query_prog) OR cl_null(g_zak02) 
    THEN
          RETURN
    END IF
 
    #No.FUN-810021
    LET g_zz011 = ""
    LET g_zz05  = "" 
 
    SELECT zai01,zai02,zai04,zai06,zai07,zaiud01
      INTO g_zai01,g_zai02,g_zai04,g_zai06,g_zai07,g_zaiud01    #FUN-770079 
      FROM zai_file 
     WHERE zai01=g_query_prog  AND zai05=g_query_cust             #FUN-750084
 
    #No.FUN-920079 -- start --
    IF cl_null(g_zai04) THEN
       LET g_zai04 = 'N'
    END IF 
    #No.FUN-920079 -- end --
 
    #FUN-7C0020  
    IF cl_null(g_zai07) THEN
       LET g_zai07 = g_query_prog CLIPPED
    END IF 
 
    SELECT zz011,zz05 INTO g_zz011,g_zz05 
      FROM zz_file WHERE zz01=g_zai07                            
    #END No.FUN-810021
 
    SELECT COUNT(*) INTO l_cnt FROM zz_file WHERE zz01=g_zai01   
    IF l_cnt > 0 THEN
       SELECT gaz06 INTO g_zai02 FROM gaz_file
        WHERE gaz01 = g_zai01 AND gaz02 = g_lang AND gaz05 = "Y"
       IF SQLCA.sqlcode THEN
         LET g_zai02 = ''
       END IF
       IF cl_null(g_zai02) THEN
         SELECT gaz06 INTO g_zai02 FROM gaz_file
          WHERE gaz01 = g_zai01 AND gaz02 = g_lang AND gaz05 = "N"
         IF SQLCA.sqlcode THEN
            LET g_zai02 = ''
         END IF
       END IF
    END IF
    #END FUN-7C0020  
 
    LET l_sql = "SELECT zao02,zao04 FROM zao_file ",
                " WHERE zao01='",g_query_prog CLIPPED,"' ",
                "   AND zao05='",g_query_cust CLIPPED,"' ",     #FUN-750084
                "   AND zao03 = ? ORDER BY zao02"
  
    
    DECLARE zao04_cs CURSOR FROM l_sql 
 
    LET g_out_type = 'V'
   #OPEN zao04_cs USING g_out_type
    FOREACH zao04_cs USING g_out_type INTO g_zao02,g_zao04_2
        LET g_zao04[g_zao02]= g_zao04_2
    END FOREACH
    CLOSE zao04_cs
   
    SELECT * INTO g_zap.* FROM zap_file 
     WHERE zap01=g_query_prog AND zap07 = g_query_cust          #FUN-750084  
    IF g_zap.zap06 IS NULL OR g_zap.zap06 = 0 THEN
       LET g_zap.zap06 = 6600                                   #FUN-820043
    END IF
    IF g_zao04[6] = 'Y' THEN
       LET g_rec_b = g_zap.zap02-g_zap.zap03-g_zap.zap05
       #FUN-7B0010
       IF g_zao04[1] = 'Y' THEN
           LET g_rec_b = g_rec_b - 12 #12為表頭*5+表尾*3+g_dash*2+抬頭*1+g_dash1*1      
       ELSE
           LET g_rec_b = g_rec_b - 4  #g_dash*2+抬頭*1+g_dash1*1      
       END IF
       #END FUN-7B0010
    END IF
   
    #FUN-810021
    #資料權限設定
    #IF NOT cl_query_auth() THEN
    #   RETURN
    #END IF
    CALL cl_query_auth(g_query_prog,g_query_cust,g_zz011,g_zai07)
        RETURNING l_status, g_auth_wc
    IF NOT l_status THEN
       RETURN
    END IF
    #END FUN-810021
   
    #FUN-820043
    WHILE TRUE  
       LET g_max_tag = 0 
       LET g_db_type=cl_db_get_database_type()   # No.TQC-810073
       LET g_curr_table = 1
       LET g_execmd = ""
       LET g_next_tag = 'N'
       LET g_wc = ""
       LET g_wc2 = ""
       LET g_wc_name = ""
       LET g_wc2_name = ""
       LET g_sql_wc = ""
 
       CALL cl_query_prt_sel('V')                    #FUN-770079
       IF INT_FLAG THEN                              #使用者不玩了
          LET INT_FLAG = 0
          RETURN
       END IF
       CALL ui.Interface.refresh()
       #darcy:2023/06/09 add s---
       if g_zaiud01 = 'Y' then
         # call cl_query_prt_cmd_query()
         return
       end if
       #darcy:2023/06/09 add e---
       IF g_query_rec_b < 1 THEN
          CALL cl_err('!','lib-216',1)
          #MOD-B50179 -- start --
          IF g_zai04 = "N" THEN
             RETURN
          ELSE
             CONTINUE WHILE    #FUN-B30005
          END IF
          #MOD-B50179 -- end --
       END IF
      
       LET g_curr_page = 1                            #目前頁數
       IF g_zao04[6] = 'Y' THEN
          LET g_total_page = (ga_table_data.getLength()/g_rec_b)    #總頁數
          IF ga_table_data.getLength() MOD g_rec_b <> 0 THEN
             LET g_total_page = g_total_page + 1
          END IF
       ELSE
          LET g_rec_b = ga_table_data.getLength()
          LET g_total_page = 1
       END IF
    
       #建立畫面
       OPEN WINDOW cl_query_prt  
            WITH FORM "lib/42f/cl_query_prt" ATTRIBUTE(STYLE="reportViewer")
       
       CALL cl_ui_locale("cl_query_prt")
       
       CALL cl_query_prt_buildForm()
       
       CALL cl_query_prt_showPage()
       
       CLOSE WINDOW cl_query_prt
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          IF g_zai04 = "N" THEN 
             EXIT WHILE
          END IF
       END IF
    END WHILE
    #END FUN-820043
END FUNCTION
   
##################################################
# Private Func...: TRUE
# Descriptions...: View 視窗顯示所查詢資料,及過濾資料
# Date & Author..:
# Input Parameter: none
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_prt_showPage()
    DEFINE l_page                LIKE type_file.num10
    DEFINE l_i                   LIKE type_file.num10
    DEFINE ln_table_column       om.DomNode
    DEFINE ln_edit,ln_w          om.DomNode
    DEFINE ln_page               om.DomNode
    DEFINE ln_table,ln_value     om.DomNode
    DEFINE ls_table              om.NodeList
    DEFINE ls_pages              om.NodeList
    DEFINE ls_items,ls_values    om.NodeList
    DEFINE ls_colname            STRING
    DEFINE lw_w                  ui.window
    DEFINE l_cmd                 LIKE gaq_file.gaq03
    DEFINE l_title_cnt           STRING,
           l_allow_insert        LIKE type_file.num5,              #可新增否
           l_allow_delete        LIKE type_file.num5               #可刪除否
    DEFINE l_width               LIKE type_file.num5
    DEFINE l_curr                LIKE type_file.num5
    DEFINE l_column              LIKE type_file.num5
    DEFINE l_offset              LIKE type_file.num5
    DEFINE l_column_name         STRING
    DEFINE l_value_item          LIKE type_file.num5
    DEFINE l_rec_b               LIKE type_file.num10,   #單身筆數
           l_curr_page           LIKE type_file.num10,   # Current Page Number
           l_total_page          LIKE type_file.num10    # Total Pages
    DEFINE l_action              STRING
    DEFINE l_table_data_t DYNAMIC ARRAY OF RECORD
           field001, field002, field003, field004, field005, field006, field007,
           field008, field009, field010, field011, field012, field013, field014,
           field015, field016, field017, field018, field019, field020, field021,
           field022, field023, field024, field025, field026, field027, field028,
           field029, field030, field031, field032, field033, field034, field035,
           field036, field037, field038, field039, field040, field041, field042,
           field043, field044, field045, field046, field047, field048, field049,
           field050, field051, field052, field053, field054, field055, field056,
           field057, field058, field059, field060, field061, field062, field063,
           field064, field065, field066, field067, field068, field069, field070,
           field071, field072, field073, field074, field075, field076, field077,
           field078, field079, field080, field081, field082, field083, field084,
           field085, field086, field087, field088, field089, field090, field091,
           field092, field093, field094, field095, field096, field097, field098,
           field099, field100  STRING
          #field101, field102, field103, field104, field105, field106, field107,
          #field108, field109, field110, field111, field112, field113, field114,
          #field115, field116, field117, field118, field119, field120, field121,
          #field122, field123, field124, field125, field126, field127, field128,
          #field129, field130, field131, field132, field133, field134, field135,
          #field136, field137, field138, field139, field140, field141, field142,
          #field143, field144, field145, field146, field147, field148, field149,
          #field150, field151, field152, field153, field154, field155, field156,
          #field157, field158, field159, field160, field161, field162, field163,
          #field164, field165, field166, field167, field168, field169, field170,
          #field171, field172, field173, field174, field175, field176, field177,
          #field178, field179, field180, field181, field182, field183, field184,
          #field185, field186, field187, field188, field189, field190, field191,
          #field192, field193, field194, field195, field196, field197, field198,
          #field199, field200  STRING
           END RECORD
 
    CALL ga_table_data_t.clear()
    FOR l_i = 1 TO ga_table_data.getLength()
        LET ga_page_data_t.* = ga_table_data[l_i].*
        LET ga_table_data_t[l_i].* = ga_page_data_t.*
    END FOR
    LET g_rec_b_t      = g_rec_b     
    LET g_total_page_t = g_total_page
    LET l_action = ""
    LET l_ac = 1
    WHILE TRUE
 
        IF INT_FLAG THEN
           IF g_zai04 != "N" OR cl_null(g_zai04) THEN 
              LET INT_FLAG = 0                      #FUN-820043
           END IF
           EXIT WHILE
        END IF
        #過濾條件
        IF l_action = 'filter' THEN
           CALL cl_query_filter()
           IF INT_FLAG THEN
              LET INT_FLAG = 0
             #CALL ga_table_data.clear()
             #FOR l_i = 1 TO ga_table_data_t.getLength()
             #    LET ga_page_data_t.* = ga_table_data_t[l_i].*
             #    LET ga_table_data[l_i].* = ga_page_data_t.*
             #END FOR
             #LET g_rec_b      = g_rec_b_t     
             #LET g_curr_page  = 1 
             #LET g_total_page = g_total_page_t
             #LET g_wc2 = NULL 
           END IF
           LET l_action = ""
        END IF
 
        CALL cl_query_prt_loadPage()
 
        LET l_page = g_curr_page
 
        #重新設定連查資料及畫面
        CALL cl_query_prt_settab()
        
        DISPLAY g_header_str TO text1
        DISPLAY g_trailer_str TO text2
        DISPLAY l_page TO curr
        DISPLAY g_total_page TO FORMONLY.total
 
        CALL cl_set_act_visible("accept,cancel", FALSE)
        DISPLAY ARRAY ga_page_data TO s_table_data.* 
          ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
            BEFORE DISPLAY 
               IF g_max_tag = 1 THEN
                  CALL cl_err( '', 'azz-246', 1 )
                  LET g_max_tag = 0
               END IF
               CALL cl_query_prt_disableAction(DIALOG)
               IF g_rec_b != 0 THEN
                  CALL fgl_set_arr_curr(l_ac)
               END IF
               IF cl_null(g_wc2) THEN
                  CALL cl_set_act_visible("unfilter", FALSE)
               END IF
 
            BEFORE ROW
               LET l_ac = ARR_CURR()
 
            ON ACTION other_output #多格式輸出
                LET l_rec_b      = g_rec_b     
                LET l_curr_page  = g_curr_page 
                LET l_total_page = g_total_page
                CALL l_table_data_t.clear()
                FOR l_i = 1 TO ga_table_data.getLength()
                    LET ga_page_data_t.* = ga_table_data[l_i].*
                    LET l_table_data_t[l_i].* = ga_page_data_t.*
                END FOR
                CALL cl_query_output()
                CALL ga_table_data.clear()
                FOR l_i = 1 TO l_table_data_t.getLength()
                    LET ga_page_data_t.* = l_table_data_t[l_i].*
                    LET ga_table_data[l_i].* = ga_page_data_t.*
                END FOR
                LET g_out_type = 'V'
               # OPEN zao04_cs USING g_out_type
                FOREACH zao04_cs USING g_out_type INTO g_zao02,g_zao04_2
                    LET g_zao04[g_zao02]= g_zao04_2
                END FOREACH
                IF g_len > 150 THEN
                   LET g_len = 150
                END IF
                CLOSE zao04_cs
 
                LET g_rec_b      = l_rec_b     
                LET g_curr_page  = l_curr_page 
                LET g_total_page = l_total_page
                EXIT DISPLAY  
 
            #FUN-7C0020  
            ON ACTION local_print                 #Local Printer List
                LET l_rec_b      = g_rec_b     
                LET l_curr_page  = g_curr_page 
                LET l_total_page = g_total_page
                CALL l_table_data_t.clear()
                FOR l_i = 1 TO ga_table_data.getLength()
                    LET ga_page_data_t.* = ga_table_data[l_i].*
                    LET l_table_data_t[l_i].* = ga_page_data_t.*
                END FOR
 
                CALL cl_query_o('V')
 
                CALL ga_table_data.clear()
                FOR l_i = 1 TO l_table_data_t.getLength()
                    LET ga_page_data_t.* = l_table_data_t[l_i].*
                    LET ga_table_data[l_i].* = ga_page_data_t.*
                END FOR
                LET g_out_type = 'V'
                FOREACH zao04_cs USING g_out_type INTO g_zao02,g_zao04_2
                    LET g_zao04[g_zao02]= g_zao04_2
                END FOREACH
                IF g_len > 150 THEN
                   LET g_len = 150
                END IF
                CLOSE zao04_cs
                LET g_rec_b      = l_rec_b     
                LET g_curr_page  = l_curr_page 
                LET g_total_page = l_total_page
                EXIT DISPLAY  
            #END FUN-7C0020  
 
            ON ACTION filter
               CALL cl_set_act_visible("unfilter", TRUE)
               LET l_action = 'filter'
               EXIT DISPLAY
               
            ON ACTION unfilter
                CALL ga_table_data.clear()
                FOR l_i = 1 TO ga_table_data_t.getLength()
                    LET ga_page_data_t.* = ga_table_data_t[l_i].*
                    LET ga_table_data[l_i].* = ga_page_data_t.*
                END FOR
                LET g_rec_b      = g_rec_b_t     
                LET g_curr_page  = 1 
                LET g_total_page = g_total_page_t
                LET g_wc2 = NULL
                LET g_wc2_name = NULL
                EXIT DISPLAY  
               
            ON ACTION first_page   # Jump to First Page
                #LET g_curr_page_t = g_curr_page 
                LET g_curr_page = 1
                EXIT DISPLAY
 
            ON ACTION next_page    # Jump to Next Page
                #LET g_curr_page_t = g_curr_page 
                LET g_curr_page = g_curr_page + 1
                EXIT DISPLAY
 
            ON ACTION prev_page    # Jump to Previous Page
                #LET g_curr_page_t = g_curr_page 
                LET g_curr_page = g_curr_page - 1
                EXIT DISPLAY
 
            ON ACTION last_page    # Jump to Last Page
                #LET g_curr_page_t = g_curr_page 
                LET g_curr_page = g_total_page
                EXIT DISPLAY
 
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE DISPLAY
 
            #No.TQC-860016 --start--
            ON ACTION controlg
               CALL cl_cmdask()
 
            ON ACTION about
               CALL cl_about()
 
            ON ACTION help
               CALL cl_show_help()
            #No.TQC-860016 ---end---
 
        END DISPLAY
        CALL cl_set_act_visible("accept,cancel", TRUE)
 
       #IF INT_FLAG THEN
       #   LET INT_FLAG = 0
       #   EXIT WHILE
       #END IF
 
    END WHILE
END FUNCTION
 
 
##################################################
# Private Func...: TRUE
# Descriptions...: 取得所選擇頁次的查詢資料
# Date & Author..:
# Input Parameter: none
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_prt_loadPage()
    DEFINE l_i            LIKE type_file.num10
    DEFINE l_j            LIKE type_file.num10
    DEFINE l_k            LIKE type_file.num10
    DEFINE l_str          STRING
    DEFINE l_line_str     STRING
    DEFINE l_column       LIKE type_file.num10
    DEFINE l_gae04        LIKE gae_file.gae04
    DEFINE l_ze03         LIKE ze_file.ze03
    DEFINE l_rec_b        LIKE type_file.num10              #單身筆數
    DEFINE l_curr_b       LIKE type_file.num10              #單身筆數
    DEFINE l_zal04        LIKE zal_file.zal04
    DEFINE l_zal05        LIKE zal_file.zal05
    DEFINE l_sql          STRING
    DEFINE l_wc           STRING
    DEFINE l_dash         STRING                            #FUN-7B0010 
    #Begin:FUN-A10041
    DEFINE lc_azp02       LIKE azp_file.azp02,
           l_company_len  SMALLINT,
           l_plant_len    SMALLINT,
           l_azp02_len    SMALLINT
    #End:FUN-A10041
    DEFINE lc_plant       STRING                            #FUN-BB0005
 
    CALL ga_page_data.clear()
    LET g_header_str = NULL   
    LET g_trailer_str = NULL  
    LET l_rec_b = g_rec_b * g_curr_page
    LET l_curr_b = 1 + (g_rec_b*(g_curr_page-1))
 
    IF g_zao04[5]='Y' THEN
       LET l_sql = "SELECT unique zal04 FROM zal_file,zam_file ",
                   " WHERE zal01=zam01 AND zal02=zam02 ",
                   "   AND zam03='Y'   ",
                   "   AND zal01='",g_query_prog CLIPPED,"'",
                   "   AND zal07='",g_query_cust CLIPPED,"'",    #FUN-750084
                   "   AND zal07=zam09"                          #FUN-750084
       DECLARE group2_cur CURSOR FROM l_sql
       FOREACH group2_cur INTO l_zal04
            FOR l_i = 1 TO g_qry_feld_t.getLength()
                 IF l_zal04 CLIPPED = g_qry_feld_t[l_i] CLIPPED THEN
                     LET g_feld_group[l_i]='Y'
                 END IF
            END FOR
       END FOREACH
       LET l_i = 0
       #單身資料
       INITIALIZE ga_page_data_t.* TO NULL
       FOR l_j = l_curr_b TO l_rec_b   
           LET l_i = l_i + 1
           LET ga_page_data[l_i].* = ga_table_data[l_j].*
           IF ga_page_data[l_i].field001 CLIPPED <> '{*}' THEN
              FOR l_k = 1 TO g_qry_feld.getLength()
                   CALL cl_query_page_data(l_k,l_i)
              END FOR
              LET ga_page_data_t.* = ga_table_data[l_j].*
           ELSE
              LET ga_page_data[l_i].field001 = ''
           END IF
       END FOR
    ELSE
       LET l_i = 0
       #單身資料
       FOR l_j = l_curr_b TO l_rec_b   
           LET l_i = l_i + 1
           LET ga_page_data[l_i].* = ga_table_data[l_j].*
           IF ga_page_data[l_i].field001 CLIPPED = '{*}' THEN
              LET ga_page_data[l_i].field001 = ''
           END IF
       END FOR
    END IF
 
    FOR l_i = 1 TO g_zap.zap03  
        LET g_header_str = g_header_str,"\n"
    END FOR
    
    IF g_zao04[1] = 'N' THEN
       FOR l_i = 1 TO g_zap.zap05  
           IF l_i = g_zap.zap05 THEN
              LET g_trailer_str = g_trailer_str
           ELSE 
              LET g_trailer_str = g_trailer_str,"\n"
           END IF
       END FOR
       RETURN
    END IF
    
    #公司名稱
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    #Begin:FUN-A10041
    SELECT azp02 INTO lc_azp02 FROM azp_file WHERE azp01 = g_plant 
    LET l_company_len = FGL_WIDTH(g_company CLIPPED)
    LET l_plant_len = FGL_WIDTH(g_plant CLIPPED)
    LET l_azp02_len = FGL_WIDTH(lc_azp02 CLIPPED)
    #LET l_column=((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1    
    #1+l_plant_len+1+l_azp02_len+1的對應字元如下:
    #[             :             ]
    LET l_column=((g_len-l_company_len-(1+l_plant_len+1+l_azp02_len+1))/2)+1    
    #End:FUN-A10041
    LET l_str = cl_query_space(l_column)
    #FUN-BB0005---start----
    IF g_aza.aza124="Y" THEN
       LET lc_plant="[", g_plant CLIPPED,":",lc_azp02 CLIPPED, "]"
    ELSE
       LET lc_plant=""
    END IF
    #FUN-BB0005----end-----
    LET g_header_str = g_header_str,l_str,g_company CLIPPED,lc_plant CLIPPED,"\n"  #FUN-BB0005
    #LET g_header_str = g_header_str,l_str,g_company CLIPPED,"[",g_plant CLIPPED,":",lc_azp02 CLIPPED,"]","\n" #FUN-BB0005 Mark
 
    LET g_header_str = g_header_str,"\n"
    
    #報表名稱
    LET l_column=((g_len-FGL_WIDTH(g_zai02 CLIPPED))/2)+1    
    LET l_str = cl_query_space(l_column)
    LET g_header_str = g_header_str,l_str,g_zai02 CLIPPED,"\n"
 
    #製表日期
    LET l_line_str = ""
    IF g_zao04[3] = 'Y' THEN    
       SELECT gae04 INTO l_gae04 FROM gae_file  
          WHERE gae01='p_query' and gae02='out1_3' and gae03=g_lang
       LET g_header_str = g_header_str,l_gae04 CLIPPED,":",g_today,' ',TIME
       LET l_line_str = l_gae04 CLIPPED,":",g_today,' ',TIME
    END IF
    
    #製表人
    IF g_zao04[2] = 'Y' THEN
       LET l_column = l_line_str.getLength()
       SELECT gae04 INTO l_gae04 FROM gae_file  
          WHERE gae01='p_query' and gae02='out1_2' and gae03=g_lang
       LET l_column = g_len-FGL_WIDTH(g_user)-FGL_WIDTH(l_gae04 CLIPPED)-15
                      - l_column
       LET l_str = cl_query_space(l_column)
       LET g_header_str = g_header_str,l_str,l_gae04 CLIPPED,":",g_user
       LET l_line_str = l_line_str,l_str,l_gae04 CLIPPED,g_user
    END IF
    
    #頁次
    IF g_zao04[4] = 'Y' THEN 
       LET l_column = l_line_str.getLength()
       SELECT gae04 INTO l_gae04 FROM gae_file
          WHERE gae01='p_query' and gae02='out1_4' and gae03=g_lang
       LET l_column = g_len-14-l_column
       LET l_str = cl_query_space(l_column)
       LET g_header_str = g_header_str,l_str," ",l_gae04 CLIPPED,":",
                          g_curr_page USING '<<<<<<<<<<','/',
                          g_total_page USING '<<<<<<<<<<'
    END IF
 
    LET g_header_str = g_header_str,"\n"
 
    #排列順序   
    SELECT gae04 INTO l_gae04 FROM gae_file
       WHERE gae01='p_query' and gae02='zam05' and gae03=g_lang
    FOR l_i = 1 TO g_zam.getLength()
        SELECT unique(zal05) INTO l_zal05 FROM zal_file 
         WHERE zal04 = g_zam[l_i].zal04 AND zal03 = g_lang 
           AND zal01 = g_query_prog  
           AND zal07 = g_query_cust                              #FUN-750084
        IF l_i = 1 THEN
           LET g_header_str = g_header_str,l_gae04 CLIPPED,":",l_zal05 CLIPPED
        ELSE
           LET g_header_str = g_header_str,"-",l_zal05 CLIPPED
        END IF  
    END FOR
                       
    #表尾資料
    IF g_curr_page = g_total_page THEN
       IF g_zz05 = 'Y' THEN
          SELECT ze03 INTO l_ze03 FROM ze_file
             WHERE ze01='lib-160' AND ze02 = g_lang  
          LET g_trailer_str = g_trailer_str,l_ze03 CLIPPED
          IF cl_null(g_wc_name) THEN
             LET g_wc_name = " 1=1"
          END IF
          LET g_trailer_str = g_trailer_str,g_wc_name
          IF NOT cl_null(g_wc2_name) THEN
             LET g_trailer_str = g_trailer_str," AND ",g_wc2_name
          END IF
          #FUN-7B0010
          IF g_out_type = 'V' THEN
             LET g_trailer_str = g_trailer_str,"\n\n"            
          ELSE
             LET l_dash = ""
             FOR l_i = 1 TO g_len
                 LET l_dash = l_dash,"="
             END FOR
             LET g_trailer_str = g_trailer_str,"\n", l_dash,"\n"            
          END IF
          #END FUN-7B0010
   
       END IF
       SELECT ze03 INTO l_ze03 FROM ze_file   
          WHERE ze01='azz-103' AND ze02=g_lang
    ELSE
       SELECT ze03 INTO l_ze03 FROM ze_file   
          WHERE ze01='azz-102' AND ze02=g_lang
    END IF
   #LET l_line_str = "(",g_zai01 CLIPPED,")"
   #LET g_trailer_str = g_trailer_str,"(",g_zai01 CLIPPED,")"
    LET l_line_str = "(",g_zai07 CLIPPED,")"                   #No.FUN-810021
    LET g_trailer_str = g_trailer_str,l_line_str               #No.FUN-810021
    LET l_column=g_len-FGL_WIDTH(l_ze03 CLIPPED)
    LET l_column = l_column -l_line_str.getLength()
    LET l_str = cl_query_space(l_column)
    LET g_trailer_str = g_trailer_str,l_str,l_ze03 CLIPPED
    #FUN-7B0010
    IF g_curr_page != g_total_page THEN
       LET g_trailer_str = g_trailer_str,l_str,"\n\n"
    END IF
    #END FUN-7B0010
    FOR l_i = 1 TO g_zap.zap05  
        LET g_trailer_str = g_trailer_str,"\n"
    END FOR
END FUNCTION
 
 
##################################################
# Private Func...: TRUE
# Descriptions...: 控制頁次按鈕是否關閉
# Date & Author..:
# Input Parameter: pd_dialog
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_prt_disableAction(pd_dialog)
    DEFINE pd_dialog ui.Dialog
 
 
# If on First Page, disable "First_Page" & "Prev_Page" Action
    IF g_curr_page = 1 THEN
       CALL pd_dialog.setActionActive("first_page", FALSE)
       CALL pd_dialog.setActionActive("prev_page", FALSE)
    END IF
###
 
# If on Last Page, disable "Lastt_Page" & "Next_Page" Action
    IF g_curr_page = g_total_page THEN
       CALL pd_dialog.setActionActive("last_page", FALSE)
       CALL pd_dialog.setActionActive("next_page", FALSE)
    END IF
###
END FUNCTION
 
 
##################################################
# Private Func...: TRUE
# Descriptions...: 建立連查畫面
# Date & Author..:
# Input Parameter: none
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_prt_buildForm()
    DEFINE lw_win        ui.Window
    DEFINE lf_form       ui.Form
    DEFINE ln_win        om.DomNode
    DEFINE ln_tmp        om.DomNode
    DEFINE ln_child      om.DomNode,
           ln_button     om.DomNode
    DEFINE ls_tmp        om.NodeList
    DEFINE l_file        STRING
 
    LET lw_win = ui.Window.getCurrent()
 
    #建立連查畫面
    LET lf_form = lw_win.getForm()
    LET ln_tmp = lf_form.findNode("Group","group02")
    LET ln_child = ln_tmp.createChild("VBox")
    CALL q_query_buildTable(ln_child)
 
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 建立連查畫面-表頭、單身、表尾
# Date & Author..:
# Input Parameter: pn_child
# Return code....:
# Modify.........: 
##################################################
FUNCTION q_query_buildTable(pn_child)
    DEFINE pn_child              om.DomNode
    DEFINE ln_table              om.DomNode,
           ln_table_column       om.DomNode,
           ln_edit               om.DomNode
    DEFINE ln_grid               om.DomNode,
           ln_textedit           om.DomNode,
           ln_formfield          om.DomNode
    DEFINE li_i                  LIKE type_file.num10
    DEFINE ls_colname            STRING
    DEFINE l_rec_b               LIKE type_file.num10
    DEFINE ln_len                LIKE type_file.num5
    DEFINE l_height              LIKE type_file.num5
 
    IF g_len > 150 THEN
       LET g_len = 150
    END IF
    LET ln_len = g_len+ (g_qry_feld_cnt*2)
    #建立表頭-TextEdit
    LET ln_grid = pn_child.createChild("Grid")
    LET ln_formfield = ln_grid.createChild("FormField")
    CALL ln_formfield.setAttribute("colName","text1")
    CALL ln_formfield.setAttribute("name","formonly.text1")
    CALL ln_formfield.setAttribute("tabIndex", 1)
    IF g_zao04[1] = 'N' THEN
        CALL ln_formfield.setAttribute("hidden", 1)
    END IF
    LET ln_textedit = ln_formfield.createChild("TextEdit")
    LET l_height = 5 + g_zap.zap03
    CALL ln_textedit.setAttribute("gridHeight",l_height)
    CALL ln_textedit.setAttribute("width",ln_len)
    CALL ln_textedit.setAttribute("style","fixedFont")
    CALL ln_textedit.setAttribute("stretch","x")
 
    #建立單身-Table
    IF g_zao04[6] = 'Y' THEN
         LET l_rec_b = g_rec_b
    ELSE
       LET l_rec_b = g_zap.zap02-g_zap.zap03-g_zap.zap05
       IF g_zao04[1] = 'Y' THEN
           LET l_rec_b = l_rec_b - 10 
       ELSE
           LET l_rec_b = l_rec_b - 4
       END IF
    END IF
    LET ln_table = pn_child.createChild("Table")
    CALL ln_table.setAttribute("tabName", "s_table_data")
    CALL ln_table.setAttribute("pageSize", l_rec_b)
    CALL ln_table.setAttribute("style", "fixedFont")
    CALL ln_table.setAttribute("unsortableColumns", 1)
 
    FOR li_i = 1 TO GI_MAX_COLUMN_COUNT
        LET ln_table_column = ln_table.createChild("TableColumn")
        LET ls_colname = "field", li_i USING "&&&"
        CALL ln_table_column.setAttribute("colName", ls_colname)
        CALL ln_table_column.setAttribute("name", "formonly." || ls_colname)
        CALL ln_table_column.setAttribute("text", ls_colname)
        CALL ln_table_column.setAttribute("noEntry", 1)
        CALL ln_table_column.setAttribute("hidden", 1)
        CALL ln_table_column.setAttribute("tabIndex", li_i+1)
        LET ln_edit = ln_table_column.createChild("Edit")
        CALL ln_edit.setAttribute("width", GI_COLUMN_WIDTH)
    END FOR
 
    #建立表尾-TextEdit
    LET ln_grid = pn_child.createChild("Grid")
    LET ln_formfield = ln_grid.createChild("FormField")
    CALL ln_formfield.setAttribute("colName","text2")
    CALL ln_formfield.setAttribute("name","formonly.text2")
    CALL ln_formfield.setAttribute("tabIndex", GI_MAX_COLUMN_COUNT+1)
    IF g_zao04[1] = 'N' THEN
        CALL ln_formfield.setAttribute("hidden", 1)
    END IF
    LET ln_textedit = ln_formfield.createChild("TextEdit")
    CALL ln_textedit.setAttribute("gridHeight",3)
   #CALL ln_textedit.setAttribute("height",1)
   #CALL ln_textedit.setAttribute("width",g_len+g_qry_length.getLength()*2)
    CALL ln_textedit.setAttribute("width",ln_len)
    CALL ln_textedit.setAttribute("style","fixedFont")
    CALL ln_textedit.setAttribute("stretch","x")
 
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 重新設定連查資料及畫面
# Date & Author..:
# Input Parameter: none
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_prt_settab()
DEFINE lw_w                  ui.window
DEFINE lf_form               ui.Form
DEFINE ln_table_column       om.DomNode
DEFINE ln_edit,ln_w          om.DomNode
DEFINE ln_child              om.DomNode
DEFINE ln_table              om.DomNode
DEFINE ln_page               om.DomNode
DEFINE ln_group              om.DomNode
DEFINE ln_vbox               om.DomNode
DEFINE ls_items              om.NodeList
DEFINE ls_tables             om.NodeList
DEFINE ls_pages              om.NodeList
DEFINE l_i,l_k               LIKE type_file.num10
DEFINE l_title_cnt           LIKE type_file.num10
DEFINE l_width               LIKE type_file.num5
DEFINE ls_colname            STRING
DEFINE l_action              STRING
DEFINE l_items               STRING
DEFINE l_columns             STRING
 
        LET lw_w=ui.window.getcurrent()
        LET ln_w = lw_w.getNode()
        LET ls_items=ln_w.selectByTagName("TableColumn")
        FOR l_i = 1 TO g_qry_feld_cnt
            LET ln_table_column = ls_items.item(l_i)
            LET ls_colname = "field", l_i USING "&&&"
            CALL ln_table_column.setAttribute("colName", ls_colname)
            CALL ln_table_column.setAttribute("name", "formonly." || ls_colname)
            CALL ln_table_column.setAttribute("text", g_qry_feld[l_i])
            IF g_qry_show[l_i] = 'Y' THEN
               CALL ln_table_column.setAttribute("hidden", 0)
            ELSE
               CALL ln_table_column.setAttribute("hidden", 1)
            END IF
            LET ln_edit = ln_table_column.getChildByIndex(1)
            CALL ln_edit.setAttribute("width", g_qry_length[l_i]+1)
        END FOR
        FOR l_i = g_qry_feld_cnt+1 TO GI_MAX_COLUMN_COUNT
            LET ln_table_column = ls_items.item(l_i)
            LET ls_colname = "field", l_i USING "&&&"
            CALL ln_table_column.setAttribute("colName", ls_colname)
            CALL ln_table_column.setAttribute("name", "formonly." || ls_colname)
            CALL ln_table_column.setAttribute("text", ls_colname)
            CALL ln_table_column.setAttribute("noEntry", 1)
            CALL ln_table_column.setAttribute("hidden", 1)
        END FOR
 
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 依照 p_query 設定產生報表資料
# Date & Author..:
# Input Parameter: p_cmd
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_prt_sel(p_cmd)                     #FUN-770079
    DEFINE p_cmd       LIKE type_file.chr1           #V:預覽模式 O:其他模式 #FUN-770079
    DEFINE l_text      STRING
    DEFINE l_str       STRING
    DEFINE l_str_bak   STRING
    DEFINE l_sql       STRING
    DEFINE l_order     STRING
    DEFINE l_tmp       STRING
    DEFINE l_tok       base.StringTokenizer
    DEFINE l_start     LIKE type_file.num10          #No.FUN-680135 SMALLINT
    DEFINE l_end       LIKE type_file.num10          #No.FUN-680135 SMALLINT
    DEFINE l_tab       DYNAMIC ARRAY OF STRING
    DEFINE l_tab_alias DYNAMIC ARRAY OF STRING
    DEFINE l_i         LIKE type_file.num10          #No.FUN-680135 SMALLINT
    DEFINE l_j         LIKE type_file.num10          #No.FUN-680135 SMALLINT
    defiNE l_k         LIKE type_file.num10          #No.FUN-680135 SMALLINT
    DEFINE l_cnt       LIKE type_file.num10          #No.FUN-680135 SMALLINT
    DEFINE ln_table_column, ln_edit,ln_w om.DomNode
    DEFINE ls_items    om.NodeList
    DEFINE ls_colname  STRING
    DEFINE lw_w        ui.window
    DEFINE l_tabname    STRING
    DEFINE l_table_name LIKE gac_file.gac05
    DEFINE l_tab_cnt   LIKE type_file.num5          #No.FUN-680135 SMALLINT
    DEFINE l_colname   LIKE zal_file.zal04,         #No.FUN-680135 VARCHAR(20)
           l_colnamec  LIKE gaq_file.gaq03,         #No.FUN-680135 VARCHAR(50)
           l_collen    LIKE type_file.num5,         #No.FUN-680135 SMALLINT
           l_coltype   LIKE type_file.chr3,         #No.FUN-680135 VARCHAR(3)
           l_sel       LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
    DEFINE l_zal04     LIKE zal_file.zal04
    DEFINE l_zam05     LIKE zam_file.zam05
    DEFINE l_zam07     LIKE zam_file.zam07
    DEFINE l_zam08     LIKE zam_file.zam08
    DEFINE l_gae04     LIKE gae_file.gae04
    DEFINE l_tag       LIKE type_file.num5
    DEFINE l_next_tag  LIKE type_file.chr1
    DEFINE l_next_cnt  LIKE type_file.num10
    DEFINE l_tag1      LIKE type_file.chr1
    DEFINE l_tag2      LIKE type_file.chr1
    DEFINE l_tag3      LIKE type_file.chr1
    DEFINE l_tag4      LIKE type_file.chr1
    DEFINE l_bar       LIKE type_file.num5
    DEFINE l_azi01     LIKE azi_file.azi01
    DEFINE l_scale     LIKE azi_file.azi03
    DEFINE l_zat       RECORD
                       zat03    LIKE zat_file.zat03,
                       zat04    LIKE zat_file.zat04,
                       zat06    LIKE zat_file.zat06,
                       zat07    LIKE zat_file.zat07,
                       zat08    LIKE zat_file.zat08,
                       zat09    LIKE zat_file.zat09,
                       zat12    LIKE zat_file.zat12            #FUN-7C0020
                       END RECORD
    DEFINE l_table_data RECORD
          field001, field002, field003, field004, field005, field006, field007,
          field008, field009, field010, field011, field012, field013, field014,
          field015, field016, field017, field018, field019, field020, field021,
          field022, field023, field024, field025, field026, field027, field028,
          field029, field030, field031, field032, field033, field034, field035,
          field036, field037, field038, field039, field040, field041, field042,
          field043, field044, field045, field046, field047, field048, field049,
          field050, field051, field052, field053, field054, field055, field056,
          field057, field058, field059, field060, field061, field062, field063,
          field064, field065, field066, field067, field068, field069, field070,
          field071, field072, field073, field074, field075, field076, field077,
          field078, field079, field080, field081, field082, field083, field084,
          field085, field086, field087, field088, field089, field090, field091,
          field092, field093, field094, field095, field096, field097, field098,
          field099, field100  LIKE gaq_file.gaq03
         #field101, field102, field103, field104, field105, field106, field107,
         #field108, field109, field110, field111, field112, field113, field114,
         #field115, field116, field117, field118, field119, field120, field121,
         #field122, field123, field124, field125, field126, field127, field128,
         #field129, field130, field131, field132, field133, field134, field135,
         #field136, field137, field138, field139, field140, field141, field142,
         #field143, field144, field145, field146, field147, field148, field149,
         #field150, field151, field152, field153, field154, field155, field156,
         #field157, field158, field159, field160, field161, field162, field163,
         #field164, field165, field166, field167, field168, field169, field170,
         #field171, field172, field173, field174, field175, field176, field177,
         #field178, field179, field180, field181, field182, field183, field184,
         #field185, field186, field187, field188, field189, field190, field191,
         #field192, field193, field194, field195, field196, field197, field198,
         #field199, field200  LIKE gaq_file.gaq03
           END RECORD
    DEFINE l_sys         STRING                                      #No.FUN-7B0010
    DEFINE l_zz011       LIKE zz_file.zz011                          #No.FUN-7B0010
    DEFINE l_zz01        LIKE zz_file.zz01                           #No.FUN-7B0010
    DEFINE l_zal09       DYNAMIC ARRAY OF LIKE zal_file.zal09        #FUN-AA0074
    DEFINE l_sql1        STRING                                      #FUN-AA0074 
    DEFINE l_table_tok   base.StringTokenizer                        #FUN-AC0011
    DEFINE l_field_name  STRING                                      #FUN-AC0011
 
     CALL ga_table_data.clear()
 
     IF p_cmd = "V" THEN                     #FUN-770079
        CALL g_qry_feld.clear()
        CALL g_qry_feld_type.clear()
        CALL g_qry_scale.clear()
        CALL g_qry_length.clear()
        CALL g_qry_feld_t.clear()
        CALL g_qry_qbe.clear()
        CALL g_scale_curr.clear()
        CALL g_feld_group.clear()
        CALL g_feld_sum.clear()
        CALL g_sum_name.clear()
        CALL g_zan.clear()
        CALL g_zam.clear()
        CALL g_field_seq.clear()
     END IF
 
     LET l_sel = 'N'
     LET l_next_tag = 'N'
 
     #LET l_str = cl_query_cut_spaces(g_zak02 CLIPPED)
     LET l_str = g_zak02 CLIPPED                                #TQC-790154
 
     LET l_end = l_str.getIndexOf(';',1)
     IF l_end != 0 THEN
        LET l_str=l_str.subString(1,l_end-1)
     END IF
     LET l_tok = base.StringTokenizer.createExt(l_str CLIPPED,"\n","",TRUE)
     WHILE l_tok.hasMoreTokens()
           LET l_tmp=l_tok.nextToken()
           IF l_text is null THEN
              LET l_text = l_tmp.trim()
           ELSE
              LET l_text = l_text CLIPPED,' ',l_tmp.trim()
           END IF
     END WHILE
     LET l_tmp=l_text
     LET g_execmd=l_tmp
 
     IF p_cmd = "V" THEN                     #FUN-770079
        LET l_sql = "SELECT unique zal04,zam05,zam07,zam08 FROM zal_file,zam_file ",
                    " WHERE zal01=zam01 AND zal02=zam02 ",
                    "   AND zam04='Y'   AND zam05>0  ",
                    "   AND zal01='",g_query_prog CLIPPED,"'",
                    "   AND zal07='",g_query_cust CLIPPED,"'",      #FUN-750084
                    "   AND zal07=zam09",                           #FUN-750084
                    " ORDER BY zam05 "
        DECLARE group_cur CURSOR FROM l_sql
    
        FOREACH group_cur INTO l_zal04,l_zam05,l_zam07,l_zam08
            LET g_zam[l_zam05].zal04 = l_zal04 CLIPPED
            LET g_zam[l_zam05].zam07 = l_zam07 CLIPPED
            LET g_zam[l_zam05].zam08 = l_zam08 CLIPPED
        END FOREACH
    
        LET l_str=l_tmp
        LET l_str_bak = l_str.toLowerCase()
        LET l_start = l_str_bak.getIndexOf('select',1)
        IF l_start=0 THEN
           CALL cl_err('can not execute this command!','!',0)
           LET INT_FLAG = 1
           #CALL cl_close_progress_bar()                       #FUN-750084
           RETURN
        END IF
        LET l_end   = l_str_bak.getIndexOf('from',1)
        LET l_str=l_str.subString(l_start+7,l_end-2)
        LET l_str=l_str.trim()
        LET l_tok = base.StringTokenizer.createExt(l_str CLIPPED,",","",TRUE)
        LET l_i=1
        WHILE l_tok.hasMoreTokens()
              LET g_qry_feld[l_i]=l_tok.nextToken()
              LET g_qry_feld[l_i]=g_qry_feld[l_i].trim()
              LET g_qry_feld[l_i]=g_qry_feld[l_i].toLowerCase() #No.TQC-950089
              LET l_i=l_i+1
        END WHILE
        LET g_qry_feld_cnt=l_i-1
    
        LET l_str=l_tmp
        LET l_str_bak = l_str.toLowerCase()
        LET l_start = l_str_bak.getIndexOf('from',1)
        LET l_end   = l_str_bak.getIndexOf('where',1)
        IF l_end=0 THEN
           LET l_end   = l_str_bak.getIndexOf('group',1)
           IF l_end=0 THEN
              LET l_end   = l_str_bak.getIndexOf('order',1)
              IF l_end=0 THEN
                 LET l_end=l_str.getLength()
                 LET l_str=l_str.subString(l_start+5,l_end)
              ELSE
                 LET l_str=l_str.subString(l_start+5,l_end-2)
              END IF
           ELSE
              LET l_str=l_str.subString(l_start+5,l_end-2)
           END IF
        ELSE
           LET l_str=l_str.subString(l_start+5,l_end-2)
        END IF
        LET l_str=l_str.trim()
        LET l_str_bak = l_str.toLowerCase()                                          #FUN-AC0011
        #LET l_tok = base.StringTokenizer.createExt(l_str CLIPPED,",","",TRUE)       #FUN-AC0011 mark
        LET l_tok = base.StringTokenizer.createExt(l_str_bak CLIPPED,",","",TRUE)    #FUN-AC0011
        LET l_j=1
        WHILE l_tok.hasMoreTokens()
              #---FUN-AC0011---start-----
              #因為sql語法中FROM後面的table有可能會以 JOIN 的形式出現
              #例1:SELECT XXX FROM nni_file nni LEFT OUTER JOIN nma_file ON nma01 = nni06, nnj_file LEFT OUTER JOIN nne_file ON nnj03 = nne01
              #例2:SELECT XXX FROM nni_file nni RIGHT OUTER JOIN nma_file ON nma01 = nni06, nnj_file LEFT OUTER JOIN nne_file ON nnj03 = nne01
              #例3:SELECT XXX FROM nni_file nni OUTER JOIN nma_file ON nma01 = nni06, nnj_file LEFT OUTER JOIN nne_file ON nnj03 = nne01
              LET l_str_bak = l_tok.nextToken()

              #依照關鍵字去除,取代成逗號,以利分割table
              LET l_text = "left outer join"
              CALL cl_replace_str(l_str_bak, l_text.toLowerCase(), ",") RETURNING l_str_bak
              LET l_text = "right outer join"
              CALL cl_replace_str(l_str_bak, l_text.toLowerCase(), ",") RETURNING l_str_bak
              LET l_text = "outer join"
              CALL cl_replace_str(l_str_bak, l_text.toLowerCase(), ",") RETURNING l_str_bak
              WHILE l_str_bak.getIndexOf("on", 1) > 0
                    #準備將on後面的條件式去除,如:XXXXXX JOIN nma_file nma [ON nma01 = nni06], 
                    LET l_start = l_str_bak.getIndexOf("on", 1) 

                    #從剛才找出on關鍵字地方關始找下一個逗號,應該就是此次所要截取的table名稱和別名
                    #如果後面已找不到逗號位置,代表應該已到字串的最尾端
                    LET l_end = l_str_bak.getIndexOf(",", l_start)  
                    IF l_end = 0 THEN
                       LET l_end = l_str_bak.getLength() + 1   #因為下面會減1,所以這裡先加1
                    END IF
                    LET l_text = l_str_bak.subString(l_start, l_end - 1)
                    CALL cl_replace_str(l_str_bak, l_text, " ") RETURNING l_str_bak
              END WHILE

              #依逗號區隔出各table名稱和別名
              LET l_table_tok = base.StringTokenizer.createExt(l_str_bak CLIPPED,",","",TRUE)
             
              #回復原本sql字串,並轉成小寫,以利找table名稱位置,再抓取真正sql字串
              LET l_str_bak = l_str.toLowerCase()             
              WHILE l_table_tok.hasMoreTokens()
                    LET l_text = l_table_tok.nextToken()
                    LET l_text = l_text.trim()
                    LET l_start = l_str_bak.getIndexOf(l_text, 1) 
                    LET l_text = l_str.substring(l_start, l_start + l_text.getLength() - 1)
                    #LET l_tab[l_j]=l_tok.nextToken()          #mark 改成下面取l_text方式
                    LET l_tab[l_j] = l_text
              #---FUN-AC0011---end-------
                    LET l_tab[l_j]=l_tab[l_j].trim()
                    IF l_tab[l_j].getIndexOf(' ',1) THEN
                       DISPLAY 'qazzaq:',l_tab[l_j].getIndexOf(' ',1)
                       LET l_tab_alias[l_j]=l_tab[l_j].subString(l_tab[l_j].getIndexOf(' ',1)+1,l_tab[l_j].getLength())
                       LET l_tab[l_j]=l_tab[l_j].subString(1,l_tab[l_j].getIndexOf(' ',1)-1)
                    END IF
                    LET l_j=l_j+1
              END WHILE   #FUN-AC0011
        END WHILE
        LET l_tab_cnt=l_j-1
        
        CALL cl_query_prt_temptable()     #No.FUN-A60085

        FOR l_i=1 TO g_qry_feld_cnt
            IF g_qry_feld[l_i]='*' THEN
               LET l_str=l_tmp
               LET l_str_bak = l_str.toLowerCase()
               LET l_start = l_str_bak.getIndexOf('from',1)
               LET l_end   = l_str_bak.getIndexOf('where',1)
               IF l_end=0 THEN
                  LET l_end   = l_str_bak.getIndexOf('group',1)
                  IF l_end=0 THEN
                     LET l_end   = l_str_bak.getIndexOf('order',1)
                     IF l_end=0 THEN
                        LET l_end=l_str.getLength()
                        LET l_str=l_str.subString(l_start+5,l_end)
                     ELSE
                        LET l_str=l_str.subString(l_start+5,l_end-2)
                     END IF
                  ELSE
                     LET l_str=l_str.subString(l_start+5,l_end-2)
                  END IF
               ELSE
                  LET l_str=l_str.subString(l_start+5,l_end-2)
               END IF
               LET l_str=l_str.trim()
               LET l_tok = base.StringTokenizer.createExt(l_str CLIPPED,",","",TRUE)
               FOR l_j=1 TO l_tab_cnt 
                   CALL cl_query_prt_getlength(l_tab[l_j],l_sel,'m','1')  #No.FUN-810062
                   DECLARE cl_query_insert_d_ifx CURSOR FOR
                           SELECT xabc02,xabc03,xabc04,xabc05,xabc06 FROM xabc ORDER BY xabc01
                   FOREACH cl_query_insert_d_ifx INTO g_qry_feld_name,g_qry_feld_tmp,g_qry_length[l_i],g_qry_scale[l_i],g_qry_feld_type[l_i]
                      LET g_qry_feld_t[l_i]=g_qry_feld_name CLIPPED
                      LET g_qry_feld[l_i]=g_qry_feld_tmp CLIPPED
                      IF g_qry_length[l_i] < g_qry_feld[l_i].getLength() THEN
                          LET g_qry_length[l_i] = g_qry_feld[l_i].getLength()
                      END IF
                      #LET g_len=g_len + g_qry_length[l_i] + 1
                      LET l_i=l_i+1
                   END FOREACH
                   LET g_qry_feld_cnt=l_i-1
               END FOR
               EXIT FOR   #確保避免因人為的sql錯誤產生多除的顯示欄位
            ELSE
               IF g_qry_feld[l_i].getIndexOf('.',1) THEN
                  IF g_qry_feld[l_i].subString(g_qry_feld[l_i].getIndexOf('.',1)+1,g_qry_feld[l_i].getLength())='*' THEN
                     FOR l_j=1 TO l_tab_cnt
                         IF l_tab_alias[l_j] is null THEN
                            IF l_tab[l_j]=g_qry_feld[l_i].subString(1,g_qry_feld[l_i].getIndexOf('.',1)-1) THEN
                               LET l_k=l_i   #備份l_i的值
                               CALL g_qry_feld.deleteElement(l_i) #刪除xxx.*那筆資料
                               CALL g_qry_length.deleteElement(l_i) #刪除xxx.*那筆資料
                               CALL g_qry_feld.insertElement(l_i)
                               CALL g_qry_length.insertElement(l_i)
                               CALL cl_query_prt_getlength(l_tab[l_j],l_sel,'m','1')    #No.FUN-810062
                               DECLARE cl_query_insert_d1_ifx CURSOR FOR 
                                       SELECT xabc02,xabc03,xabc04,xabc05,xabc06 FROM xabc ORDER BY xabc01 DESC
                               FOREACH cl_query_insert_d1_ifx INTO g_qry_feld_name,g_qry_feld_tmp,g_qry_length[l_i],g_qry_scale[l_i],g_qry_feld_type[l_i]
                                 #LET g_qry_feld_t[l_i]=g_qry_feld[l_i]
                                  CALL g_qry_feld_t.insertelement(l_i)           #FUN-AC0011
                                  CALL g_qry_scale.insertelement(l_i)            #FUN-AC0011
                                  CALL g_qry_feld_type.insertelement(l_i)        #FUN-AC0011
                                  LET g_qry_feld_t[l_i]=g_qry_feld_name CLIPPED 
                                  LET g_qry_feld[l_i]=g_qry_feld_tmp CLIPPED
                                  IF g_qry_length[l_i] < g_qry_feld[l_i].getLength() THEN
                                      LET g_qry_length[l_i] = g_qry_feld[l_i].getLength()
                                  END IF
                                  #LET g_len=g_len + g_qry_length[l_i] + 1
                                  CALL g_qry_feld.insertElement(l_i)
                                  CALL g_qry_length.insertElement(l_i)
                                  LET l_k=l_k+1
                                  LET g_qry_feld_cnt=g_qry_feld_cnt+1
                               END FOREACH
                               CALL g_qry_feld.deleteElement(l_i) #刪除xxx.*那筆資料
                               CALL g_qry_length.deleteElement(l_i) #刪除xxx.*那筆資料
                               CALL g_qry_scale.deleteElement(l_i)            #FUN-AC0011
                               CALL g_qry_feld_type.deleteElement(l_i)        #FUN-AC0011
                               LET g_qry_feld_cnt=g_qry_feld_cnt-1
                               LET l_i=l_k-1
                            END IF
                         ELSE
                            IF l_tab_alias[l_j]=g_qry_feld[l_i].subString(1,g_qry_feld[l_i].getIndexOf('.',1)-1) THEN
                               LET l_k=l_i   #備份l_i的值
                               CALL g_qry_feld.deleteElement(l_i) #刪除xxx.*那筆資料
                               CALL g_qry_length.deleteElement(l_i) #刪除xxx.*那筆資料
                               CALL g_qry_feld.insertElement(l_i)
                               CALL g_qry_length.insertElement(l_i)
                               CALL cl_query_prt_getlength(l_tab[l_j],l_sel,'m','1')   #No.FUN-810062
                               DECLARE cl_query_insert_d2_ifx CURSOR FOR 
                                       SELECT xabc02,xabc03,xabc04,xabc05,xabc06 FROM xabc ORDER BY xabc01 DESC
                               FOREACH cl_query_insert_d2_ifx INTO g_qry_feld_name,g_qry_feld_tmp,g_qry_length[l_i],g_qry_scale[l_i],g_qry_feld_type[l_i]
                                 #LET g_qry_feld_t[l_i]=g_qry_feld[l_i]
                                  CALL g_qry_feld_t.insertelement(l_i)           #FUN-AC0011
                                  CALL g_qry_scale.insertelement(l_i)            #FUN-AC0011
                                  CALL g_qry_feld_type.insertelement(l_i)        #FUN-AC0011
                                  LET g_qry_feld_t[l_i]=g_qry_feld_name CLIPPED 
                                  LET g_qry_feld[l_i]=g_qry_feld_tmp CLIPPED
                                  IF g_qry_length[l_i] < g_qry_feld[l_i].getLength() THEN
                                      LET g_qry_length[l_i] = g_qry_feld[l_i].getLength()
                                  END IF
                                  #LET g_len=g_len + g_qry_length[l_i] + 1
                                  CALL g_qry_feld.insertElement(l_i)
                                  CALL g_qry_length.insertElement(l_i)
                                  LET l_k=l_k+1
                                  LET g_qry_feld_cnt=g_qry_feld_cnt+1
                               END FOREACH
                               CALL g_qry_feld.deleteElement(l_i) #刪除xxx.*那筆資料
                               CALL g_qry_length.deleteElement(l_i) #刪除xxx.*那筆資料
                               CALL g_qry_scale.deleteElement(l_i)            #FUN-AC0011
                               CALL g_qry_feld_type.deleteElement(l_i)        #FUN-AC0011
                               LET g_qry_feld_cnt=g_qry_feld_cnt-1
                               LET l_i=l_k-1
                            END IF
                         END IF 
                     END FOR
                  ELSE
                    
                     LET l_tabname =g_qry_feld[l_i].subString(1,g_qry_feld[l_i].getIndexOf('.',1)-1)    #FUN-820043
                    #LET g_qry_feld[l_i]=g_qry_feld[l_i].subString(g_qry_feld[l_i].getIndexOf('.',1)+1,g_qry_feld[l_i].getLength())  #FUN-820043
                     LET g_qry_length[l_i]=''
                     CALL cl_query_prt_getlength(g_qry_feld[l_i],l_sel,'s','1')    #No.FUN-810062
                     DECLARE cl_query_ifx CURSOR FOR 
                             SELECT xabc02,xabc03,xabc04,xabc05,xabc06 FROM xabc ORDER BY xabc01 DESC
                     FOREACH cl_query_ifx INTO g_qry_feld_name,g_qry_feld_tmp,g_qry_length[l_i],g_qry_scale[l_i],g_qry_feld_type[l_i]
                       #LET g_qry_feld_t[l_i]=g_qry_feld[l_i] CLIPPED
                        LET g_qry_feld_t[l_i]=g_qry_feld_name CLIPPED
                        LET g_qry_feld[l_i]=g_qry_feld_tmp CLIPPED
                        IF g_qry_length[l_i] < g_qry_feld[l_i].getLength() THEN
                            LET g_qry_length[l_i] = g_qry_feld[l_i].getLength()
                        END IF
                       # LET g_len=g_len + g_qry_length[l_i] + 1
                     END FOREACH
                  END IF
               ELSE
                  LET g_qry_length[l_i]=''
                     CALL cl_query_prt_getlength(g_qry_feld[l_i],l_sel,'s','1')   #No.FUN-810062
                     DECLARE cl_query_d1_ifx CURSOR FOR 
                             SELECT xabc02,xabc03,xabc04,xabc05,xabc06 FROM xabc ORDER BY xabc01 DESC
                     FOREACH cl_query_d1_ifx INTO g_qry_feld_name,g_qry_feld_tmp,g_qry_length[l_i],g_qry_scale[l_i],g_qry_feld_type[l_i]
                        #LET g_qry_feld_t[l_i]=g_qry_feld[l_i]
                        LET g_qry_feld_t[l_i]=g_qry_feld_name CLIPPED
                        LET g_qry_feld[l_i]=g_qry_feld_tmp CLIPPED
                        IF g_qry_length[l_i] < g_qry_feld[l_i].getLength() THEN
                            LET g_qry_length[l_i] = g_qry_feld[l_i].getLength()
                        END IF
                        #LET g_len=g_len + g_qry_length[l_i] + 1
                     END FOREACH
               END IF
            END IF
        END FOR 
        #FUN-770079
        IF g_qry_feld_cnt > 100 and (g_zaiud01 ='N' or cl_null(g_zaiud01) ) THEN  #darcy:2024/07/08 add g_zaiud01
           CALL cl_err( g_qry_feld_cnt, 'azz-271', 1 )
           LET INT_FLAG = 1
           RETURN
        END IF
        #END FUN-770079
    
        #LET g_len = g_len - 1
    
        #No.FUN-820043
        LET l_sql = " SELECT gae04 FROM gae_file ",
                 " WHERE gae01='p_query' AND gae02 like 'zan03_%' ",
                 " AND gae03='",g_lang,"'"
        LET l_i = 0 
        DECLARE sum_name_cur CURSOR FROM l_sql
        FOREACH sum_name_cur INTO l_gae04
              LET l_i = l_i + 1
              LET g_sum_name[l_i] = l_gae04
        END FOREACH
        #END No.FUN-820043
 
        #計算sum筆數
        LET g_zan_cnt = 0
        SELECT COUNT(*) INTO g_zan_cnt FROM zan_file 
         WHERE zan01=g_query_prog AND zan08=g_query_cust     #FUN-750084
        IF g_zan_cnt > 0 THEN
            LET l_i = 1
            LET l_sql="SELECT unique zal04,zan03,zan04,zan05,'',zan07 FROM zal_file,zan_file ", #FUN-770079
                      " WHERE zal01=zan01 AND zal02=zan02 ",
                      "   AND zal01='",g_query_prog CLIPPED,"'",
                      "   AND zal07='",g_query_cust CLIPPED,"'",      #FUN-750084
                      "   AND zal07=zan08"                            #FUN-750084
            DECLARE sum_cur CURSOR FROM l_sql
            FOREACH sum_cur INTO g_zan[l_i].*
              SELECT unique zal04 INTO g_zan[l_i].gzal04 FROM zal_file
               WHERE zal01= g_query_prog AND zal02 = g_zan[l_i].zan05
                 AND zal07= g_query_cust                              #FUN-750084  
              FOR l_k = 1 TO g_qry_feld_t.getLength()
                  IF g_zan[l_i].gzal04 = g_qry_feld_t[l_k] THEN
                     FOR l_j = 1 TO g_qry_feld_t.getLength()
                         IF g_zan[l_i].zal04 = g_qry_feld_t[l_j] THEN
                             #g_feld_sum[field欄位位置,group欄位位置)
                             LET g_feld_sum[l_j,l_k] = g_zan[l_i].zan03
                         END IF
                     END FOR
                  END IF
              END FOR
              LET l_i = l_i + 1
            END FOREACH
            CALL g_zan.deleteElement(l_i)
        END IF
 
        #No.FUN-7B0010
        #No.FUN-810021
        #LET l_zz011 = ""
        #SELECT zz011 INTO l_zz011 FROM zz_file 
        # WHERE zz01 = g_zai01
        IF cl_null(g_zz011) THEN
           LET l_str = g_zai01 CLIPPED
           IF l_str.getIndexOf('_',1) > 0 THEN
              LET l_zz01 = l_str.subString(1,l_str.getIndexOf('_',1)-1)
              SELECT zz011 INTO g_zz011 FROM zz_file 
               WHERE zz01 = l_zz01
           END IF
           IF cl_null(g_zz011) THEN
              IF g_zai01[1,3] = 'tqr' THEN
                 LET g_zz011 = g_zai01[4,6]
              END IF
           END IF
        END IF
 
        LET l_sys = UPSHIFT(g_zz011) CLIPPED
        #END No.FUN-810021
        IF l_sys.subString(1,1) = 'C' THEN
           LET l_sys = 'A',l_sys.subString(2,l_sys.getLength())
        END IF
        #display "sys:",l_sys
        #END No.FUN-7B0010
    
        LET l_i = 0
        LET l_sql="SELECT unique zal04,zat03,zat04,zat06,zat07,zat08,zat09,zat12 ",  #FUN-7C0020
                  "  FROM zal_file,zat_file",
                  " WHERE zal01=zat01 AND zal02=zat02 ",
                  "   AND zal01='",g_query_prog CLIPPED,"' ",
                  "   AND zal07='",g_query_cust CLIPPED,"' ",        #FUN-750084
                  "   AND zal07=zat10 ",                             #FUN-750084 
                  " ORDER BY zat04" 
        DECLARE seq_cs CURSOR FROM l_sql
        FOREACH seq_cs INTO l_zal04,l_zat.*
            FOR l_j = 1 TO g_qry_feld_t.getLength()
                #MOD-B50179 -- start --
                #IF l_zal04 CLIPPED = g_qry_feld_t[l_j] CLIPPED THEN                 #FUN-AC0011   mark 
                LET l_field_name = l_zal04 CLIPPED                                   #FUN_Ac0011
                #IF l_field_name.getIndexOf(g_qry_feld_t[l_j] CLIPPED, 1) > 0 THEN    #FUN-AC0011   mark

                IF l_field_name.getIndexOf('.',1) > 0 AND 
                   g_qry_feld_t[l_j].getIndexOf('.',1) = 0 
                THEN
                   LET l_field_name = l_field_name.subString(l_field_name.getIndexOf('.',1)+1,l_field_name.getLength())
                END IF
                IF l_field_name = g_qry_feld_t[l_j] CLIPPED THEN                     
                #MOD-B50179 -- end --
                   #No.FUN-7B0010
                   CASE l_zat.zat03 
                     WHEN "M"   #依多單位設定(asms290)
                       SELECT sma115 INTO l_zat.zat03 FROM sma_file WHERE sma00='0'
                     WHEN "V"   #依計價單位設定(asms290)
                       SELECT sma116 INTO l_zat.zat03 FROM sma_file WHERE sma00='0'
                       CASE l_zat.zat03 
                         WHEN '0'
                             LET l_zat.zat03 = "N"
                         WHEN '1' 
                             IF l_sys = 'APM' THEN
                                 LET l_zat.zat03 = "Y"
                             ELSE
                                 LET l_zat.zat03 = "N"
                             END IF
                         WHEN '2'
                             IF l_sys = 'AXM' OR l_sys = 'ATM' THEN
                                 LET l_zat.zat03 = "Y"
                             ELSE
                                 LET l_zat.zat03 = "N"
                             END IF
                         WHEN '3'
                         LET l_zat.zat03 = "Y"
                       END CASE 
                     WHEN "X"      #依多套帳設定(aoos010)
                          SELECT aza63 INTO l_zat.zat03 FROM aza_file WHERE aza01='0'
                     WHEN "P"      #依利潤中心設定(agls103)        #FUN-820043
                          SELECT aaz90 INTO l_zat.zat03 FROM aaz_file WHERE aaz00='0'
                   END CASE
                   IF cl_null(l_zat.zat03) THEN
                      LET l_zat.zat03 = 'N'
                   END IF
                   #END No.FUN-7B0010
 
                   LET g_qry_show[l_j] = l_zat.zat03
                   IF l_zat.zat07 = 'Y' AND 
                      (g_qry_feld_type[l_j] <> 'date' AND g_qry_feld_type[l_j] <> 'char' AND   #TQC-810053
                       g_qry_feld_type[l_j] <> "varchar2" )
                   THEN
                      IF l_zat.zat08 MATCHES "[1234]" THEN
                         IF l_zat.zat09 = 'aza17' THEN
                            SELECT aza17 INTO l_azi01 FROM aza_file
                            CASE l_zat.zat08 
                              WHEN '1'
                                   SELECT azi03 INTO l_scale FROM azi_file
                                        WHERE  azi01 = l_azi01
                                   LET g_qry_scale[l_j] = l_scale
                              WHEN '2'
                                   SELECT azi04 INTO l_scale FROM azi_file
                                        WHERE  azi01 = l_azi01
                                   LET g_qry_scale[l_j] = l_scale
                              WHEN '3'
                                   SELECT azi05 INTO l_scale FROM azi_file
                                        WHERE  azi01 = l_azi01
                                   LET g_qry_scale[l_j] = l_scale
                              WHEN '4'
                                   SELECT azi07 INTO l_scale FROM azi_file
                                        WHERE  azi01 = l_azi01
                                   LET g_qry_scale[l_j] = l_scale
                            END CASE
                            LET g_scale_curr[l_j].scale_type = l_zat.zat08  #TQC-810053
                            LET g_scale_curr[l_j].aza17 = "Y"               #TQC-810053
                         ELSE
                            FOR l_k = 1 TO g_qry_feld_t.getLength()
                                IF l_zat.zat09 = g_qry_feld_t[l_k] THEN
                                   LET g_scale_curr[l_j].curr_col = l_k
                                   LET g_scale_curr[l_j].scale_type = l_zat.zat08
                                END IF
                            END FOR
                         END IF
                      ELSE
                          LET g_qry_scale[l_j] = l_zat.zat09
                      END IF
                   END IF
                   IF l_zat.zat04 > 0 THEN
                      LET l_i = l_i + 1
                      LET g_field_seq[l_i].id = l_zal04 CLIPPED
                      LET g_field_seq[l_i].name = g_qry_feld[l_j] CLIPPED
                     #FUN-7C0020
                     #LET g_field_seq[l_i].len = g_qry_length[l_j] CLIPPED
                      IF cl_null(l_zat.zat12) THEN
                         LET l_zat.zat12 = g_qry_length[l_j] CLIPPED
                      END IF
                      LET g_field_seq[l_i].len = l_zat.zat12          
                     #END FUN-7C0020
                      LET g_field_seq[l_i].type = g_qry_feld_type[l_j]
                      LET g_field_seq[l_i].qbe = l_zat.zat06 CLIPPED
                   END IF
                   EXIT FOR
                END IF
            END FOR
        END FOREACH
     END IF                                         #FUN-770079
    
     #查詢報表時是否輸入查詢條件 
     #IF g_zai04 = 'Y' AND g_out_type = 'V' AND cl_null(g_wc) THEN
     IF g_out_type = 'V' AND cl_null(g_wc) THEN       #FUN-790050
        LET g_wc = cl_query_curs('V')
        IF INT_FLAG THEN                              #使用者不玩了
           RETURN
        END IF
     END IF
     LET g_sql_wc = ""
     IF NOT cl_null(g_wc) THEN
        LET g_sql_wc = g_wc
        #過濾的條件(g_wc2)
        IF NOT cl_null(g_wc2) THEN
           LET g_sql_wc = g_sql_wc ," AND ",g_wc2 
        END IF
     ELSE
        IF NOT cl_null(g_wc2) THEN
           LET g_sql_wc = g_wc2 
        END IF
     END IF
     
     IF g_auth_wc CLIPPED <> ' 1=1' THEN
       IF NOT cl_null(g_sql_wc) THEN
          LET g_sql_wc = g_sql_wc," AND ",g_auth_wc
       ELSE
          LET g_sql_wc = g_auth_wc 
       END IF
     END IF
     
     #FUN-770079
     #計算報表長度
     LET g_len = 0
     LET g_show_cnt = 0
     FOR l_i = 1 TO g_qry_feld_cnt 
         IF g_qry_show[l_i] = 'Y' THEN
            LET g_len=g_len + g_qry_length[l_i] + 1
            LET g_show_cnt = g_show_cnt + 1
         END IF
     END FOR
     LET g_len = g_len -1
     #FUN-7B0010
     IF g_len < 80 THEN
        LET g_len = 80
     END IF
     #END FUN-7B0010
     #組 sql 字串排序條件(Order By) 
     LET l_next_tag =  cl_query_order()             
 
     #將 sql 字串欄位換成 DECODE & CASE
     CALL cl_query_prt_replace()                    
 
     #END FUN-770079
 
     IF NOT cl_null(g_sql_wc) THEN
        LET l_str_bak = g_execmd.toLowerCase()
        LET l_end   = l_str_bak.getIndexOf('where',1)
        IF l_end=0 THEN
           LET l_end   = l_str_bak.getIndexOf('group',1)
           IF l_end=0 THEN
              LET l_end   = l_str_bak.getIndexOf('order',1)
              IF l_end=0 THEN
                 LET g_execmd = g_execmd," WHERE ",g_sql_wc
              ELSE
                 LET g_execmd = g_execmd.subString(1,l_end-1),
                             " WHERE ",g_sql_wc," ",
                             g_execmd.subString(l_end,g_execmd.getLength())
              END IF
           ELSE
              LET g_execmd = g_execmd.subString(1,l_end-1),
                             " WHERE ",g_sql_wc," ",
                             g_execmd.subString(l_end,g_execmd.getLength())
           END IF
        ELSE
           LET g_execmd = g_execmd.subString(1,l_end+5),
                          g_sql_wc," AND ",
                          g_execmd.subString(l_end+6,g_execmd.getLength())
        END IF
     END IF 
     DISPLAY g_execmd
     #darcy:2023/06/06 add s---
     # fastexcel版本
     if g_zaiud01 = "Y" then
          call cl_query_prt_cmd_query()
          return
     end if
     #darcy:2023/06/06 add e---
     PREPARE table_pre FROM g_execmd
     IF SQLCA.SQLCODE THEN
        CALL cl_err('',sqlca.sqlcode,1)
        LET INT_FLAG = 1
        RETURN
     END IF
     DECLARE table_cur CURSOR FOR table_pre
     IF SQLCA.SQLCODE THEN
        CALL cl_err('',sqlca.sqlcode,1)
        LET INT_FLAG = 1
        RETURN
     END IF
 
     CALL cl_progress_bar(10)
     LET l_bar = 1
 
     LET l_i = 1
     CALL ga_table_data.clear()
     INITIALIZE ga_page_data_t.* TO NULL
     INITIALIZE l_table_data.*   TO NULL
     CALL ga_sum_data.clear()
     FOR l_k = 1 TO g_qry_feld.getLength()
          LET g_sum_rec[l_k].group_item = 0
          LET g_sum_rec[l_k].group_sum = 0
          LET g_sum_rec[l_k].total_item = 0
          LET g_sum_rec[l_k].total_sum = 0
     END FOR
     LET g_data_end = 0
     LET l_cnt = 1
     FOREACH table_cur INTO l_table_data.*
         IF SQLCA.SQLCODE THEN
            CALL cl_err('',sqlca.sqlcode,1)
            CALL cl_close_progress_bar()
            RETURN
         END IF
        #LET ga_table_data[l_i].* = l_table_data.*
         LET ga_table_data[l_i].field001 = l_table_data.field001
         LET ga_table_data[l_i].field002 = l_table_data.field002
         LET ga_table_data[l_i].field003 = l_table_data.field003
         LET ga_table_data[l_i].field004 = l_table_data.field004
         LET ga_table_data[l_i].field005 = l_table_data.field005
         LET ga_table_data[l_i].field006 = l_table_data.field006
         LET ga_table_data[l_i].field007 = l_table_data.field007
         LET ga_table_data[l_i].field008 = l_table_data.field008
         LET ga_table_data[l_i].field009 = l_table_data.field009
         LET ga_table_data[l_i].field010 = l_table_data.field010
         LET ga_table_data[l_i].field011 = l_table_data.field011
         LET ga_table_data[l_i].field012 = l_table_data.field012
         LET ga_table_data[l_i].field013 = l_table_data.field013
         LET ga_table_data[l_i].field014 = l_table_data.field014
         LET ga_table_data[l_i].field015 = l_table_data.field015
         LET ga_table_data[l_i].field016 = l_table_data.field016
         LET ga_table_data[l_i].field017 = l_table_data.field017
         LET ga_table_data[l_i].field018 = l_table_data.field018
         LET ga_table_data[l_i].field019 = l_table_data.field019
         LET ga_table_data[l_i].field020 = l_table_data.field020
         LET ga_table_data[l_i].field021 = l_table_data.field021
         LET ga_table_data[l_i].field022 = l_table_data.field022
         LET ga_table_data[l_i].field023 = l_table_data.field023
         LET ga_table_data[l_i].field024 = l_table_data.field024
         LET ga_table_data[l_i].field025 = l_table_data.field025
         LET ga_table_data[l_i].field026 = l_table_data.field026
         LET ga_table_data[l_i].field027 = l_table_data.field027
         LET ga_table_data[l_i].field028 = l_table_data.field028
         LET ga_table_data[l_i].field029 = l_table_data.field029
         LET ga_table_data[l_i].field030 = l_table_data.field030
         LET ga_table_data[l_i].field031 = l_table_data.field031
         LET ga_table_data[l_i].field032 = l_table_data.field032
         LET ga_table_data[l_i].field033 = l_table_data.field033
         LET ga_table_data[l_i].field034 = l_table_data.field034
         LET ga_table_data[l_i].field035 = l_table_data.field035
         LET ga_table_data[l_i].field036 = l_table_data.field036
         LET ga_table_data[l_i].field037 = l_table_data.field037
         LET ga_table_data[l_i].field038 = l_table_data.field038
         LET ga_table_data[l_i].field039 = l_table_data.field039
         LET ga_table_data[l_i].field040 = l_table_data.field040
         LET ga_table_data[l_i].field041 = l_table_data.field041
         LET ga_table_data[l_i].field042 = l_table_data.field042
         LET ga_table_data[l_i].field043 = l_table_data.field043
         LET ga_table_data[l_i].field044 = l_table_data.field044
         LET ga_table_data[l_i].field045 = l_table_data.field045
         LET ga_table_data[l_i].field046 = l_table_data.field046
         LET ga_table_data[l_i].field047 = l_table_data.field047
         LET ga_table_data[l_i].field048 = l_table_data.field048
         LET ga_table_data[l_i].field049 = l_table_data.field049
         LET ga_table_data[l_i].field050 = l_table_data.field050
         LET ga_table_data[l_i].field051 = l_table_data.field051
         LET ga_table_data[l_i].field052 = l_table_data.field052
         LET ga_table_data[l_i].field053 = l_table_data.field053
         LET ga_table_data[l_i].field054 = l_table_data.field054
         LET ga_table_data[l_i].field055 = l_table_data.field055
         LET ga_table_data[l_i].field056 = l_table_data.field056
         LET ga_table_data[l_i].field057 = l_table_data.field057
         LET ga_table_data[l_i].field058 = l_table_data.field058
         LET ga_table_data[l_i].field059 = l_table_data.field059
         LET ga_table_data[l_i].field060 = l_table_data.field060
         LET ga_table_data[l_i].field061 = l_table_data.field061
         LET ga_table_data[l_i].field062 = l_table_data.field062
         LET ga_table_data[l_i].field063 = l_table_data.field063
         LET ga_table_data[l_i].field064 = l_table_data.field064
         LET ga_table_data[l_i].field065 = l_table_data.field065
         LET ga_table_data[l_i].field066 = l_table_data.field066
         LET ga_table_data[l_i].field067 = l_table_data.field067
         LET ga_table_data[l_i].field068 = l_table_data.field068
         LET ga_table_data[l_i].field069 = l_table_data.field069
         LET ga_table_data[l_i].field070 = l_table_data.field070
         LET ga_table_data[l_i].field071 = l_table_data.field071
         LET ga_table_data[l_i].field072 = l_table_data.field072
         LET ga_table_data[l_i].field073 = l_table_data.field073
         LET ga_table_data[l_i].field074 = l_table_data.field074
         LET ga_table_data[l_i].field075 = l_table_data.field075
         LET ga_table_data[l_i].field076 = l_table_data.field076
         LET ga_table_data[l_i].field077 = l_table_data.field077
         LET ga_table_data[l_i].field078 = l_table_data.field078
         LET ga_table_data[l_i].field079 = l_table_data.field079
         LET ga_table_data[l_i].field080 = l_table_data.field080
         LET ga_table_data[l_i].field081 = l_table_data.field081
         LET ga_table_data[l_i].field082 = l_table_data.field082
         LET ga_table_data[l_i].field083 = l_table_data.field083
         LET ga_table_data[l_i].field084 = l_table_data.field084
         LET ga_table_data[l_i].field085 = l_table_data.field085
         LET ga_table_data[l_i].field086 = l_table_data.field086
         LET ga_table_data[l_i].field087 = l_table_data.field087
         LET ga_table_data[l_i].field088 = l_table_data.field088
         LET ga_table_data[l_i].field089 = l_table_data.field089
         LET ga_table_data[l_i].field090 = l_table_data.field090
         LET ga_table_data[l_i].field091 = l_table_data.field091
         LET ga_table_data[l_i].field092 = l_table_data.field092
         LET ga_table_data[l_i].field093 = l_table_data.field093
         LET ga_table_data[l_i].field094 = l_table_data.field094
         LET ga_table_data[l_i].field095 = l_table_data.field095
         LET ga_table_data[l_i].field096 = l_table_data.field096
         LET ga_table_data[l_i].field097 = l_table_data.field097
         LET ga_table_data[l_i].field098 = l_table_data.field098
         LET ga_table_data[l_i].field099 = l_table_data.field099
         LET ga_table_data[l_i].field100 = l_table_data.field100
        #LET ga_table_data[l_i].field101 = l_table_data.field101
        #LET ga_table_data[l_i].field102 = l_table_data.field102
        #LET ga_table_data[l_i].field103 = l_table_data.field103
        #LET ga_table_data[l_i].field104 = l_table_data.field104
        #LET ga_table_data[l_i].field105 = l_table_data.field105
        #LET ga_table_data[l_i].field106 = l_table_data.field106
        #LET ga_table_data[l_i].field107 = l_table_data.field107
        #LET ga_table_data[l_i].field108 = l_table_data.field108
        #LET ga_table_data[l_i].field109 = l_table_data.field109
        #LET ga_table_data[l_i].field110 = l_table_data.field110
        #LET ga_table_data[l_i].field111 = l_table_data.field111
        #LET ga_table_data[l_i].field112 = l_table_data.field112
        #LET ga_table_data[l_i].field113 = l_table_data.field113
        #LET ga_table_data[l_i].field114 = l_table_data.field114
        #LET ga_table_data[l_i].field115 = l_table_data.field115
        #LET ga_table_data[l_i].field116 = l_table_data.field116
        #LET ga_table_data[l_i].field117 = l_table_data.field117
        #LET ga_table_data[l_i].field118 = l_table_data.field118
        #LET ga_table_data[l_i].field119 = l_table_data.field119
        #LET ga_table_data[l_i].field120 = l_table_data.field120
        #LET ga_table_data[l_i].field121 = l_table_data.field121
        #LET ga_table_data[l_i].field122 = l_table_data.field122
        #LET ga_table_data[l_i].field123 = l_table_data.field123
        #LET ga_table_data[l_i].field124 = l_table_data.field124
        #LET ga_table_data[l_i].field125 = l_table_data.field125
        #LET ga_table_data[l_i].field126 = l_table_data.field126
        #LET ga_table_data[l_i].field127 = l_table_data.field127
        #LET ga_table_data[l_i].field128 = l_table_data.field128
        #LET ga_table_data[l_i].field129 = l_table_data.field129
        #LET ga_table_data[l_i].field130 = l_table_data.field130
        #LET ga_table_data[l_i].field131 = l_table_data.field131
        #LET ga_table_data[l_i].field132 = l_table_data.field132
        #LET ga_table_data[l_i].field133 = l_table_data.field133
        #LET ga_table_data[l_i].field134 = l_table_data.field134
        #LET ga_table_data[l_i].field135 = l_table_data.field135
        #LET ga_table_data[l_i].field136 = l_table_data.field136
        #LET ga_table_data[l_i].field137 = l_table_data.field137
        #LET ga_table_data[l_i].field138 = l_table_data.field138
        #LET ga_table_data[l_i].field139 = l_table_data.field139
        #LET ga_table_data[l_i].field140 = l_table_data.field140
        #LET ga_table_data[l_i].field141 = l_table_data.field141
        #LET ga_table_data[l_i].field142 = l_table_data.field142
        #LET ga_table_data[l_i].field143 = l_table_data.field143
        #LET ga_table_data[l_i].field144 = l_table_data.field144
        #LET ga_table_data[l_i].field145 = l_table_data.field145
        #LET ga_table_data[l_i].field146 = l_table_data.field146
        #LET ga_table_data[l_i].field147 = l_table_data.field147
        #LET ga_table_data[l_i].field148 = l_table_data.field148
        #LET ga_table_data[l_i].field149 = l_table_data.field149
        #LET ga_table_data[l_i].field150 = l_table_data.field150
        #LET ga_table_data[l_i].field151 = l_table_data.field151
        #LET ga_table_data[l_i].field152 = l_table_data.field152
        #LET ga_table_data[l_i].field153 = l_table_data.field153
        #LET ga_table_data[l_i].field154 = l_table_data.field154
        #LET ga_table_data[l_i].field155 = l_table_data.field155
        #LET ga_table_data[l_i].field156 = l_table_data.field156
        #LET ga_table_data[l_i].field157 = l_table_data.field157
        #LET ga_table_data[l_i].field158 = l_table_data.field158
        #LET ga_table_data[l_i].field159 = l_table_data.field159
        #LET ga_table_data[l_i].field160 = l_table_data.field160
        #LET ga_table_data[l_i].field161 = l_table_data.field161
        #LET ga_table_data[l_i].field162 = l_table_data.field162
        #LET ga_table_data[l_i].field163 = l_table_data.field163
        #LET ga_table_data[l_i].field164 = l_table_data.field164
        #LET ga_table_data[l_i].field165 = l_table_data.field165
        #LET ga_table_data[l_i].field166 = l_table_data.field166
        #LET ga_table_data[l_i].field167 = l_table_data.field167
        #LET ga_table_data[l_i].field168 = l_table_data.field168
        #LET ga_table_data[l_i].field169 = l_table_data.field169
        #LET ga_table_data[l_i].field170 = l_table_data.field170
        #LET ga_table_data[l_i].field171 = l_table_data.field171
        #LET ga_table_data[l_i].field172 = l_table_data.field172
        #LET ga_table_data[l_i].field173 = l_table_data.field173
        #LET ga_table_data[l_i].field174 = l_table_data.field174
        #LET ga_table_data[l_i].field175 = l_table_data.field175
        #LET ga_table_data[l_i].field176 = l_table_data.field176
        #LET ga_table_data[l_i].field177 = l_table_data.field177
        #LET ga_table_data[l_i].field178 = l_table_data.field178
        #LET ga_table_data[l_i].field179 = l_table_data.field179
        #LET ga_table_data[l_i].field180 = l_table_data.field180
        #LET ga_table_data[l_i].field181 = l_table_data.field181
        #LET ga_table_data[l_i].field182 = l_table_data.field182
        #LET ga_table_data[l_i].field183 = l_table_data.field183
        #LET ga_table_data[l_i].field184 = l_table_data.field184
        #LET ga_table_data[l_i].field185 = l_table_data.field185
        #LET ga_table_data[l_i].field186 = l_table_data.field186
        #LET ga_table_data[l_i].field187 = l_table_data.field187
        #LET ga_table_data[l_i].field188 = l_table_data.field188
        #LET ga_table_data[l_i].field189 = l_table_data.field189
        #LET ga_table_data[l_i].field190 = l_table_data.field190
        #LET ga_table_data[l_i].field191 = l_table_data.field191
        #LET ga_table_data[l_i].field192 = l_table_data.field192
        #LET ga_table_data[l_i].field193 = l_table_data.field193
        #LET ga_table_data[l_i].field194 = l_table_data.field194
        #LET ga_table_data[l_i].field195 = l_table_data.field195
        #LET ga_table_data[l_i].field196 = l_table_data.field196
        #LET ga_table_data[l_i].field197 = l_table_data.field197
        #LET ga_table_data[l_i].field198 = l_table_data.field198
        #LET ga_table_data[l_i].field199 = l_table_data.field199
        #LET ga_table_data[l_i].field200 = l_table_data.field200
       
         FOR l_k = 1 TO g_qry_feld.getLength()
             IF g_qry_feld_type[l_k] = 'date' THEN
                CALL cl_query_value(l_k,l_i)
             END IF
         END FOR
         IF g_zan_cnt > 0 THEN
            LET l_tag = 0
            
            FOR l_k = 1 TO g_qry_feld.getLength()
              CALL cl_query_scale(l_k,l_i) 
              #CALL cl_query_sum_data('目前check欄位','目前筆數')
              CALL cl_query_sum_data(l_k,l_i)
            END FOR
            IF l_tag = 0 AND l_i <> ga_table_data.getLength() THEN
               LET l_tag = 1
               FOR l_j = 1 TO ga_sum_data.getLength()
                  IF ga_sum_data[l_j].getLength() > 0 THEN
                     FOR l_k = 1 TO 2 
                         LET ga_table_data[l_i+1].* = ga_table_data[l_i].*
                         INITIALIZE ga_table_data[l_i].* TO NULL
                         LET ga_sum_data[l_j,l_k].field001='{*}'
                         LET ga_table_data[l_i].* = ga_sum_data[l_j,l_k].*
                         LET l_i=l_i+1
                     END FOR
                  END IF
               END FOR
               IF ga_sum_data.getLength() > 0 THEN
                  IF g_next_tag = 'Y' AND (l_i MOD g_rec_b > 0 ) AND 
                     g_zao04[6] = 'Y' 
                  THEN
                     LET l_next_cnt = l_i + (g_rec_b - (l_i MOD g_rec_b)) + 1
                     LET ga_table_data[l_next_cnt].* = ga_table_data[l_i].*
                     INITIALIZE ga_table_data[l_i].* TO NULL
                     LET ga_sum_data[l_j,l_k].field001=''
                     LET ga_table_data[l_i].* = ga_sum_data[l_j,l_k].*
                     LET l_i=l_next_cnt
                     LET g_next_tag = 'N'
                  ELSE    
                     LET ga_table_data[l_i+1].* = ga_table_data[l_i].*
                     INITIALIZE ga_table_data[l_i].* TO NULL
                     LET ga_sum_data[l_j,l_k].field001=''
                     LET ga_table_data[l_i].* = ga_sum_data[l_j,l_k].*
                     LET l_i=l_i+1
                  END IF
                  CALL ga_sum_data.clear()
               END IF
               FOR l_k = 1 TO g_qry_feld.getLength()
                    CALL cl_query_sum_rec(l_k,l_i)
               END FOR
               LET ga_page_data_t.* = ga_table_data[l_i].*
               LET l_i=l_i+1
            ELSE
               IF g_next_tag = 'Y' AND (l_i MOD g_rec_b > 0 ) AND 
                  g_zao04[6] = 'Y' 
               THEN
                  FOR l_k = 1 TO g_qry_feld.getLength()
                       CALL cl_query_sum_rec(l_k,l_i)
                  END FOR
                  LET l_next_cnt = l_i + (g_rec_b - (l_i MOD g_rec_b)) + 1
                  LET ga_table_data[l_next_cnt].* = ga_table_data[l_i].*
                  INITIALIZE ga_table_data[l_i].* TO NULL
                  LET l_i = l_next_cnt + 1
                  LET g_next_tag = 'N'
                  LET ga_page_data_t.* = ga_table_data[l_next_cnt].*
               ELSE 
                  FOR l_k = 1 TO g_qry_feld.getLength()
                       CALL cl_query_sum_rec(l_k,l_i)
                  END FOR
                  LET ga_page_data_t.* = ga_table_data[l_i].*
                  LET l_i = l_i + 1
               END IF
            END IF
         ELSE
            IF l_next_tag = 'Y' THEN
               FOR l_k = 1 TO g_qry_feld.getLength()
                 CALL cl_query_scale(l_k,l_i) 
                 #CALL cl_query_sum_check('目前check欄位','目前筆數')
                 CALL cl_query_sum_check(l_k,l_i) RETURNING l_tag,l_tag1,l_tag2,l_tag3,l_tag4 
               END FOR
               IF g_next_tag = 'Y' AND (l_i MOD g_rec_b > 0 ) AND 
                  g_zao04[6] = 'Y' 
               THEN
                  FOR l_k = 1 TO g_qry_feld.getLength()
                       CALL cl_query_sum_rec(l_k,l_i)
                  END FOR
                  LET l_next_cnt = l_i + (g_rec_b - (l_i MOD g_rec_b)) + 1
                  LET ga_table_data[l_next_cnt].* = ga_table_data[l_i].*
                  INITIALIZE ga_table_data[l_i].* TO NULL
                  LET l_i = l_next_cnt + 1
                  LET g_next_tag = 'N'
                  LET ga_page_data_t.* = ga_table_data[l_next_cnt].*
               ELSE 
                  FOR l_k = 1 TO g_qry_feld.getLength()
                       CALL cl_query_sum_rec(l_k,l_i)
                  END FOR
                  LET ga_page_data_t.* = ga_table_data[l_i].*
                  LET l_i = l_i + 1
               END IF
            ELSE
               FOR l_k = 1 TO g_qry_feld.getLength()
                    CALL cl_query_scale(l_k,l_i)
                    CALL cl_query_sum_rec(l_k,l_i)
               END FOR
               LET l_i=l_i+1
            END IF
         END IF
         IF l_bar < 10 AND l_i MOD g_zap.zap02 = 0 THEN
            CALL cl_progressing("process: Query")
            LET l_bar = l_bar + 1
         END IF
         LET l_cnt = l_cnt + 1
         IF l_cnt > g_zap.zap06 AND g_zao04[8] = 'Y' THEN
            LET g_max_tag = 1 
            EXIT FOREACH
         END IF
         
     END FOREACH
     CALL ga_table_data.deleteElement(l_i)
     CALL cl_close_progress_bar()
 
     IF SQLCA.SQLCODE THEN
        CALL cl_err('',sqlca.sqlcode,1)
     ELSE
        IF g_zan_cnt > 0 AND l_i > 1 THEN
           LET l_tag = 0
           LET g_data_end = 1     
           FOR l_k = 1 TO g_qry_feld.getLength()
             CALL cl_query_scale(l_k,l_i)
             #CALL cl_query_sum_data('目前check欄位','目前筆數')
             CALL cl_query_sum_data(l_k,l_i)
           END FOR
           IF l_tag = 0 AND l_i <> ga_table_data.getLength() THEN
              LET l_tag = 1
              FOR l_j = 1 TO ga_sum_data.getLength()
                 IF ga_sum_data[l_j].getLength() > 0 THEN
                    FOR l_k = 1 TO 2 
                        LET l_i=l_i+1
                        INITIALIZE ga_table_data[l_i].* TO NULL
                        LET ga_sum_data[l_j,l_k].field001='{*}'
                        LET ga_table_data[l_i-1].* = ga_sum_data[l_j,l_k].*
                    END FOR
                 END IF
              END FOR
              CALL ga_sum_data.clear()
           END IF
        END IF
     END IF
     CALL ga_table_data.deleteElement(l_i)
     LET g_query_rec_b = l_i - 1

     #FUN-AA0074 -- start --
     #取得各欄位的欄位屬性格式(zal09)設定
     LET l_sql1 = "SELECT zal09 FROM zal_file ", 
                  "   WHERE zal01 = '", g_query_prog, "' AND zal07 = '", g_query_cust, "'",
                  "     AND zal03 = '", g_lang, "' ",
                  "   ORDER BY zal02"
     PREPARE cl_query_prt_sel_zal09_pre FROM l_sql1           #預備一下
     DECLARE cl_query_prt_zal09_sel_curs CURSOR FOR cl_query_prt_sel_zal09_pre
     LET l_i = 1
     FOREACH cl_query_prt_zal09_sel_curs INTO l_zal09[l_i]
          LET l_i = l_i + 1
     END FOREACH
     CALL l_zal09.deleteElement(l_i)
     LET l_i = 1
     
     #檢查各欄位屬性如果屬於'C'(匯率)格式,則將千方位字元不顯示
     FOR l_i = 1 TO ga_table_data.getlength()
        FOR l_k = 1 TO g_qry_feld.getLength()
           IF l_zal09[l_k] MATCHES '[C]' THEN   #匯率
              CALL cl_query_prt_replace_str(l_k, l_i)   #將匯率格式千方位取消('目前check欄位','目前筆數')
           END IF
        END FOR
     END FOR
     #FUN-AA0074 -- end -- 
  
END FUNCTION
 
#No.FUN-810062
##################################################
# Private Func...: TRUE
# Descriptions...: 取得資料或或p_query 設定的欄位名稱、型態、長度等資訊
# Date & Author..:
# Input Parameter: p_tab,   - 若p_flag傳入's',則p_tab需傳入Field Name,
#                             若p_flag傳入'm',則p_tab需傳入Table Name
#                  p_sel    -   I : show field ID, N:show Field Name, 
#                             其他:show Field ID+Name
#                  p_flag   - s 表single只查單一個field 
#                             m 表multi查table所有的field
#                  p_type   - 0: 以 p_tabname 設定的欄位名稱
#                             1: 以 p_query 設定的欄位名稱
#                             2: 以 p_crview_set 設定的欄位名稱
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_prt_getlength(p_tab,p_sel,p_flag,p_type)
DEFINE p_tab        STRING
DEFINE l_sql        STRING
DEFINE l_sn         LIKE type_file.num5      
DEFINE p_flag       LIKE type_file.chr1       
DEFINE p_type       LIKE type_file.chr1
DEFINE l_colname    LIKE zal_file.zal04,    
       l_colnamec   LIKE gaq_file.gaq03,    
       l_collen     LIKE type_file.num5,    
       l_coltype    LIKE gaq_file.gaq03,   
       l_data_type  LIKE type_file.chr30,
       p_sel        LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
DEFINE l_scale      LIKE type_file.num10
DEFINE l_id         LIKE type_file.num10    #FUN-770079
DEFINE l_zal08      LIKE zal_file.zal08     #FUN-770079
DEFINE l_zal09      LIKE zal_file.zal09     #FUN-7C0020
DEFINE l_zta17      LIKE zta_file.zta17     #FUN-7C0020
DEFINE l_zta01      LIKE zta_file.zta01     #FUN-7C0020
DEFINE l_cnt        LIKE type_file.num5     #FUN-7C0020
DEFINE l_tab_t      LIKE zal_file.zal04     #FUN-820043
DEFINE l_zta07      LIKE zta_file.zta07     #FUN-9C0036
DEFINE l_dbs        LIKE zta_file.zta02     #FUN-9C0036
DEFINE l_sch01      LIKE sch_file.sch01     #FUN-A90024
DEFINE l_sch02      LIKE sch_file.sch02     #FUN-A90024

 
    #No:FUN-A60085 -- start --
    #DROP TABLE xabc
 
    #CREATE TEMP TABLE xabc(
    #  xabc01  LIKE type_file.num5,    #SMALLINT,  
    #  xabc02  LIKE type_file.chr1000, #VARCHAR(1000),
    #  xabc03  LIKE type_file.chr1000, #VARCHAR(1000),
    #  xabc04  LIKE type_file.num5,    #SMALLINT,
    #  xabc05  LIKE type_file.num10,   #INTEGER,
    #  xabc06  LIKE type_file.chr20)   #VARCHAR(20))
    
    #BEGIN WORK    #FUN-A90024 mark因為會影響呼叫端SQL的transaction處理,所以需要mark此處的transaction
       DELETE FROM xabc
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","xabc","DELETE ALL","",SQLCA.sqlcode,"","",0)  
       #--FUN-A90024--start-----mark--
       #   ROLLBACK WORK  
       #ELSE
       #   COMMIT WORK
       #--FUN-A90024--end------ mark--
       END IF
    #No:FUN-A60085 -- end --
     
    #FUN-7C0020
    IF cl_null(g_db_type) THEN                                  
       LET g_db_type=cl_db_get_database_type()           #No.TQC-810073
    END IF
 
    #No.FUN-860089 -- start -- 
    IF p_flag = 'm' THEN
       CASE g_db_type                                           
        WHEN "IFX"  LET g_db_tag = ":"
        WHEN "ORA"  LET g_db_tag = "."
       END CASE
       IF p_tab.getIndexOf(g_db_tag,1) > 0 THEN
          LET l_zta17 = p_tab.subString(1,p_tab.getIndexOf(g_db_tag,1)-1)
       ELSE
          LET l_zta17 = NULL
       END IF
    END IF
 
    LET l_tab_t = p_tab                                  #No.FUN-720043
    LET p_tab  = p_tab.subString(p_tab.getIndexOf(g_db_tag,1)+1,p_tab.getLength())  #FUN-820043
    #No.FUN-860089 -- end -- 
 
    LET l_tab_t = p_tab                                  #No.FUN-720043
    LET p_tab  = p_tab.subString(p_tab.getIndexOf('.',1)+1,p_tab.getLength())
 
    IF p_flag = 'm' THEN
       LET l_zta01= p_tab CLIPPED
       #No.FUN-9C0036 -- start --
       #取得正確synonym的資料庫,如 dsv1 synonym dsall, dsall synonym ds
       LET l_dbs = g_dbs 
       WHILE TRUE
          SELECT zta17 INTO l_zta17
            FROM zta_file WHERE zta01 = l_zta01 AND zta02 = l_dbs
          IF NOT cl_null(l_zta17 CLIPPED) THEN
            SELECT zta07 INTO l_zta07
              FROM zta_file WHERE zta01 = l_zta01 AND zta02=l_zta17
            IF l_zta07 = 'S' THEN
               LET l_dbs = l_zta17
            ELSE
               EXIT WHILE
            END IF
          ELSE
            EXIT WHILE
          END IF
       END WHILE
       #No.FUN-9C0036 -- end --
       
    ELSE
       LET l_colname = p_tab CLIPPED
       #---FUN-A90024---start-----
       #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
       #目前統一用sch_file紀錄TIPTOP資料結構
       SELECT COUNT(*) INTO l_cnt FROM sch_file
         WHERE sch02 = l_colname
          AND sch01 like '%/_file' ESCAPE '/'  
             
       IF l_cnt = 0 THEN 
       #---FUN-A90024---end-------
          CASE g_db_type                                           
           WHEN "IFX"                                              
                 SELECT COUNT(*) INTO l_cnt FROM syscolumns c, systables t
                  WHERE c.tabid = t.tabid AND c.colname = l_colname
                    AND t.tabname like '%/_FILE'                     #TQC-810053
           WHEN "ORA"
                 SELECT COUNT(*) INTO l_cnt FROM user_tab_columns 
                  WHERE lower(column_name)= l_colname 
                    AND table_name like '%/_FILE' ESCAPE '/'         #TQC-810053
           WHEN "MSV"
                 SELECT COUNT(*) INTO l_cnt
                  FROM sys.objects t, sys.columns c 
                 WHERE t.object_id = c.object_id AND c.name=l_colname  
                   AND t.name like '%_FILE'
           WHEN "ASE"
                 SELECT COUNT(*) INTO l_cnt
                  FROM sysobjects t, syscolumns c 
                 WHERE t.id = c.id AND c.name = l_colname  
                   AND t.name like '%_file'
          END CASE
       END IF     #FUN-A90024

       IF l_cnt = 0 THEN
          LET l_zta17 = 'ds'
       END IF
    END IF
    LET l_colname = ""
    #END FUN-7C0020
 
#No.FUN-680135 --end
    LET l_sn=1
    LET l_data_type = ""
    IF p_flag='m' THEN
       #---FUN-A90024---start-----
       #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
       #刪除原本各DB各自採用systable取得TIPTOP table & field等資訊之程式段落
       #增加目前統一用sch_file紀錄取得TIPTOP資料結構的欄位資料型態和長度等資訊
       
       #檢查是否為TIPTOP標準table內之schema,如果不是就需要用DB的system table來檢核欄位資訊(如CR的ds_report)
       LET l_sch01 = p_tab
       SELECT COUNT(*) INTO l_cnt FROM sch_file
         WHERE sch01 = l_sch01
       
       IF l_cnt > 0 THEN   
          LET l_sql=" SELECT sch02, sch03, sch04 ",
                    "   FROM sch_file ",
                    "  WHERE sch01 = '", p_tab CLIPPED, "'",
                    "  ORDER BY sch05"
       
          DECLARE cl_query_getlength_d CURSOR FROM l_sql                 
          FOREACH cl_query_getlength_d INTO l_colname,l_coltype,l_collen 
             LET l_scale = -1
             LET l_data_type = cl_get_column_datatype(l_coltype)
          
             #smallint
             IF l_coltype = '1' OR l_coltype = '257' THEN
                   IF g_db_type = "ORA" OR g_db_type = "MSV" THEN
                      LET l_collen = 5
                   END IF
                  LET l_scale = 0
             END IF
          
             #integer
             IF l_coltype = '2' OR l_coltype = '258' THEN
                   IF g_db_type = "ORA" OR g_db_type = "MSV" THEN
                      LET l_collen = 10
                   END IF
                 LET l_scale = 0
             END IF
          
             #decimal
             IF l_coltype = '5' OR l_coltype = '261' THEN
                   LET l_scale = l_collen MOD 256 CLIPPED
                LET l_collen = l_collen / 256 USING '&&' CLIPPED
             END IF
          
             #date
             IF l_coltype = '7' OR l_coltype = '263' THEN
                   LET l_collen = 10
             END IF
             #---FUN-A90024---end-------
 
             #FUN-770079
             #No.FUN-860089 -- start --
             CALL cl_query_prt_type(p_flag,p_type,l_colname,l_data_type,l_collen,l_scale,'')
                  RETURNING l_colname,l_data_type,l_collen,l_scale,l_colnamec
             #No.FUN-860089 -- end --
             #END FUN-770079
  
             CASE
               WHEN p_sel='N'
                  INSERT INTO xabc(xabc01,xabc02,xabc03,xabc04,xabc05,xabc06) VALUES(l_sn,l_colname,l_colnamec,l_collen,l_scale,l_data_type)
               WHEN p_sel='I'
                  INSERT INTO xabc(xabc01,xabc02,xabc03,xabc04,xabc05,xabc06) VALUES(l_sn,l_colname,l_colname,l_collen,l_scale,l_data_type)
               OTHERWISE
                  LET g_qry_feldname=l_colname CLIPPED,'(',l_colnamec CLIPPED,')'
                  INSERT INTO xabc(xabc01,xabc02,xabc03,xabc04,xabc05,xabc06) VALUES(l_sn,l_colname,g_qry_feldname,l_collen,l_scale,l_data_type)
             END CASE
             LET l_sn=l_sn+1
          END FOREACH
       #---FUN-A90024---start-----
       ELSE
             CALL cl_get_db_column_info(p_flag, l_zta17, p_tab, p_sel, p_type)
       END IF
       #---FUN-A90024---end-------
    ELSE
       #---FUN-A90024---start-----
       #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
       #刪除原本各DB各自採用systable取得TIPTOP table & field等資訊之程式段落
       #增加目前統一用sch_file紀錄取得TIPTOP資料結構的欄位資料型態和長度等資訊

       #檢查是否為TIPTOP標準table內之schema,如果不是就需要用DB的system table來檢核欄位資訊(如CR的ds_report)
       LET l_sch02 = p_tab
       SELECT COUNT(*) INTO l_cnt FROM sch_file
         WHERE sch02 = l_sch02
       
       IF l_cnt > 0 THEN   
       
          LET l_sql = "SELECT sch05, sch02, sch03, sch04 ",
                      "  FROM sch_file ",
                      " WHERE sch01 like '%_file'",
                      "   AND sch02 = '",p_tab CLIPPED,"'",
                      " ORDER BY sch05"
 
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql    
          DECLARE cl_query_getlength_d1 CURSOR FROM l_sql   
          FOREACH cl_query_getlength_d1 INTO l_id,l_colname,l_coltype,l_collen     
             LET l_data_type = cl_get_column_datatype(l_coltype)
             #LET l_scale = l_collen MOD 256
             LET l_scale = -1
          
             #smallint
             IF l_coltype = '1' OR l_coltype = '257' THEN
                   IF g_db_type = "ORA" OR g_db_type = "MSV" THEN
                      LET l_collen = 5
                   END IF
                  LET l_scale = 0
             END IF
          
             #integer
             IF l_coltype = '2' OR l_coltype = '258' THEN
                   IF g_db_type = "ORA" OR g_db_type = "MSV" THEN
                      LET l_collen = 10
                   END IF
                  LET l_scale = 0
             END IF
          
             #decimal
             IF l_coltype = '5' OR l_coltype = '261' THEN
                   LET l_scale = l_collen MOD 256 CLIPPED
                LET l_collen = l_collen / 256 USING '&&' CLIPPED
             END IF
          
             #date
             IF l_coltype = '7' OR l_coltype = '263' THEN
                   LET l_collen = 10
             END IF
             #---FUN-A90024---end-------
    
             #No.FUN-860089 -- start --
             LET l_colnamec = ""
             LET l_zal08 = ""
             LET l_zal09 = ""
 
             CALL cl_query_prt_type(p_flag,p_type,l_colname,l_data_type,l_collen,l_scale,l_tab_t)
                  RETURNING l_colname,l_data_type,l_collen,l_scale,l_colnamec
             #No.FUN-860089 -- end --
 
             CASE
                 WHEN p_sel='N'
                      INSERT INTO xabc(xabc01,xabc02,xabc03,xabc04,xabc05,xabc06) VALUES(l_sn,l_colname,l_colnamec,l_collen,l_scale,l_data_type)
                 WHEN p_sel='I'
                      INSERT INTO xabc(xabc01,xabc02,xabc03,xabc04,xabc05,xabc06) VALUES(l_sn,l_colname,l_colname,l_collen,l_scale,l_data_type)
                 OTHERWISE
                      LET g_qry_feldname=l_colname CLIPPED,'(',l_colnamec CLIPPED,')'
                      INSERT INTO xabc(xabc01,xabc02,xabc03,xabc04,xabc05,xabc06) VALUES(l_sn,l_colname,g_qry_feldname,l_collen,l_scale,l_data_type)
             END CASE
             LET l_sn=l_sn+1
          END FOREACH                                                    #FUN-750084
          #No.FUN-820043

       #---FUN-A90024---start-----
       ELSE
          CALL cl_get_db_column_info(p_flag, l_zta17, p_tab, p_sel, p_type)
       END IF
       #---FUN-A90024---end-------
       
       IF cl_null(l_colname) AND (l_collen=0) THEN  #for count(*)之類的用途
          LET l_collen = 20
          LET l_colname = p_tab
          LET l_data_type = 'decimal'            #CHI-870002
 
          #No.FUN-860089 -- start --
          CALL cl_query_prt_type(p_flag,p_type,l_colname,l_data_type,l_collen,l_scale,l_tab_t)
               RETURNING l_colname,l_data_type,l_collen,l_scale,l_colnamec
          #No.FUN-860089 -- end --
          IF NOT (p_type =1 AND l_data_type ='decimal') THEN   #TQC-C90102
             LET l_scale = 11 #for count(*)之類的用途.TQC-BB0068
          END IF   #TQC-C90102
          INSERT INTO xabc(xabc01,xabc02,xabc03,xabc04,xabc05,xabc06) VALUES(l_sn,l_colname,l_colnamec,l_collen,l_scale,l_data_type)  #No.FUN-820043
       END IF
       #END No.FUN-820043
    END IF
END FUNCTION
 
##################################################
# Descriptions...: 產生空白字串
# Date & Author..:
# Input Parameter: p_cnt  字長長度 - 數值
# Return code....: l_str  字白字串
# Usage..........: LET l_str = cl_query_space(10)
# Memo...........:
# Modify.........: 
##################################################
FUNCTION cl_query_space(p_cnt)
DEFINE p_cnt     LIKE type_file.num10
DEFINE i         LIKE type_file.num10
DEFINE l_str     STRING
 
    LET l_str = ''
    FOR i = 1 TO p_cnt
        LET l_str = l_str,' '
    END FOR
 
    RETURN l_str
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 報表 Group 顯示格式處理
# Date & Author..:
# Input Parameter: p_k,p_i
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_page_data(p_k,p_i)
DEFINE p_k       LIKE type_file.num10
DEFINE p_i       LIKE type_file.num10
 
   CASE p_k 
    WHEN   1  IF g_feld_group[  1] = 'Y' AND ga_page_data[p_i].field001=ga_page_data_t.field001                                         THEN LET ga_page_data[p_i].field001='' END IF
    WHEN   2  IF g_feld_group[  2] = 'Y' AND ga_page_data[p_i].field002=ga_page_data_t.field002 AND cl_null(ga_page_data[p_i].field001) THEN LET ga_page_data[p_i].field002='' END IF
    WHEN   3  IF g_feld_group[  3] = 'Y' AND ga_page_data[p_i].field003=ga_page_data_t.field003 AND cl_null(ga_page_data[p_i].field002) THEN LET ga_page_data[p_i].field003='' END IF
    WHEN   4  IF g_feld_group[  4] = 'Y' AND ga_page_data[p_i].field004=ga_page_data_t.field004 AND cl_null(ga_page_data[p_i].field003) THEN LET ga_page_data[p_i].field004='' END IF
    WHEN   5  IF g_feld_group[  5] = 'Y' AND ga_page_data[p_i].field005=ga_page_data_t.field005 AND cl_null(ga_page_data[p_i].field004) THEN LET ga_page_data[p_i].field005='' END IF
    WHEN   6  IF g_feld_group[  6] = 'Y' AND ga_page_data[p_i].field006=ga_page_data_t.field006 AND cl_null(ga_page_data[p_i].field005) THEN LET ga_page_data[p_i].field006='' END IF
    WHEN   7  IF g_feld_group[  7] = 'Y' AND ga_page_data[p_i].field007=ga_page_data_t.field007 AND cl_null(ga_page_data[p_i].field006) THEN LET ga_page_data[p_i].field007='' END IF
    WHEN   8  IF g_feld_group[  8] = 'Y' AND ga_page_data[p_i].field008=ga_page_data_t.field008 AND cl_null(ga_page_data[p_i].field007) THEN LET ga_page_data[p_i].field008='' END IF
    WHEN   9  IF g_feld_group[  9] = 'Y' AND ga_page_data[p_i].field009=ga_page_data_t.field009 AND cl_null(ga_page_data[p_i].field008) THEN LET ga_page_data[p_i].field009='' END IF
    WHEN  10  IF g_feld_group[ 10] = 'Y' AND ga_page_data[p_i].field010=ga_page_data_t.field010 AND cl_null(ga_page_data[p_i].field009) THEN LET ga_page_data[p_i].field010='' END IF
    WHEN  11  IF g_feld_group[ 11] = 'Y' AND ga_page_data[p_i].field011=ga_page_data_t.field011 AND cl_null(ga_page_data[p_i].field010) THEN LET ga_page_data[p_i].field011='' END IF
    WHEN  12  IF g_feld_group[ 12] = 'Y' AND ga_page_data[p_i].field012=ga_page_data_t.field012 AND cl_null(ga_page_data[p_i].field011) THEN LET ga_page_data[p_i].field012='' END IF
    WHEN  13  IF g_feld_group[ 13] = 'Y' AND ga_page_data[p_i].field013=ga_page_data_t.field013 AND cl_null(ga_page_data[p_i].field012) THEN LET ga_page_data[p_i].field013='' END IF
    WHEN  14  IF g_feld_group[ 14] = 'Y' AND ga_page_data[p_i].field014=ga_page_data_t.field014 AND cl_null(ga_page_data[p_i].field013) THEN LET ga_page_data[p_i].field014='' END IF
    WHEN  15  IF g_feld_group[ 15] = 'Y' AND ga_page_data[p_i].field015=ga_page_data_t.field015 AND cl_null(ga_page_data[p_i].field014) THEN LET ga_page_data[p_i].field015='' END IF
    WHEN  16  IF g_feld_group[ 16] = 'Y' AND ga_page_data[p_i].field016=ga_page_data_t.field016 AND cl_null(ga_page_data[p_i].field015) THEN LET ga_page_data[p_i].field016='' END IF
    WHEN  17  IF g_feld_group[ 17] = 'Y' AND ga_page_data[p_i].field017=ga_page_data_t.field017 AND cl_null(ga_page_data[p_i].field016) THEN LET ga_page_data[p_i].field017='' END IF
    WHEN  18  IF g_feld_group[ 18] = 'Y' AND ga_page_data[p_i].field018=ga_page_data_t.field018 AND cl_null(ga_page_data[p_i].field017) THEN LET ga_page_data[p_i].field018='' END IF
    WHEN  19  IF g_feld_group[ 19] = 'Y' AND ga_page_data[p_i].field019=ga_page_data_t.field019 AND cl_null(ga_page_data[p_i].field018) THEN LET ga_page_data[p_i].field019='' END IF
    WHEN  20  IF g_feld_group[ 20] = 'Y' AND ga_page_data[p_i].field020=ga_page_data_t.field020 AND cl_null(ga_page_data[p_i].field019) THEN LET ga_page_data[p_i].field020='' END IF
    WHEN  21  IF g_feld_group[ 21] = 'Y' AND ga_page_data[p_i].field021=ga_page_data_t.field021 AND cl_null(ga_page_data[p_i].field020) THEN LET ga_page_data[p_i].field021='' END IF
    WHEN  22  IF g_feld_group[ 22] = 'Y' AND ga_page_data[p_i].field022=ga_page_data_t.field022 AND cl_null(ga_page_data[p_i].field021) THEN LET ga_page_data[p_i].field022='' END IF
    WHEN  23  IF g_feld_group[ 23] = 'Y' AND ga_page_data[p_i].field023=ga_page_data_t.field023 AND cl_null(ga_page_data[p_i].field022) THEN LET ga_page_data[p_i].field023='' END IF
    WHEN  24  IF g_feld_group[ 24] = 'Y' AND ga_page_data[p_i].field024=ga_page_data_t.field024 AND cl_null(ga_page_data[p_i].field023) THEN LET ga_page_data[p_i].field024='' END IF
    WHEN  25  IF g_feld_group[ 25] = 'Y' AND ga_page_data[p_i].field025=ga_page_data_t.field025 AND cl_null(ga_page_data[p_i].field024) THEN LET ga_page_data[p_i].field025='' END IF
    WHEN  26  IF g_feld_group[ 26] = 'Y' AND ga_page_data[p_i].field026=ga_page_data_t.field026 AND cl_null(ga_page_data[p_i].field025) THEN LET ga_page_data[p_i].field026='' END IF
    WHEN  27  IF g_feld_group[ 27] = 'Y' AND ga_page_data[p_i].field027=ga_page_data_t.field027 AND cl_null(ga_page_data[p_i].field026) THEN LET ga_page_data[p_i].field027='' END IF
    WHEN  28  IF g_feld_group[ 28] = 'Y' AND ga_page_data[p_i].field028=ga_page_data_t.field028 AND cl_null(ga_page_data[p_i].field027) THEN LET ga_page_data[p_i].field028='' END IF
    WHEN  29  IF g_feld_group[ 29] = 'Y' AND ga_page_data[p_i].field029=ga_page_data_t.field029 AND cl_null(ga_page_data[p_i].field028) THEN LET ga_page_data[p_i].field029='' END IF
    WHEN  30  IF g_feld_group[ 30] = 'Y' AND ga_page_data[p_i].field030=ga_page_data_t.field030 AND cl_null(ga_page_data[p_i].field029) THEN LET ga_page_data[p_i].field030='' END IF
    WHEN  31  IF g_feld_group[ 31] = 'Y' AND ga_page_data[p_i].field031=ga_page_data_t.field031 AND cl_null(ga_page_data[p_i].field030) THEN LET ga_page_data[p_i].field031='' END IF
    WHEN  32  IF g_feld_group[ 32] = 'Y' AND ga_page_data[p_i].field032=ga_page_data_t.field032 AND cl_null(ga_page_data[p_i].field031) THEN LET ga_page_data[p_i].field032='' END IF
    WHEN  33  IF g_feld_group[ 33] = 'Y' AND ga_page_data[p_i].field033=ga_page_data_t.field033 AND cl_null(ga_page_data[p_i].field032) THEN LET ga_page_data[p_i].field033='' END IF
    WHEN  34  IF g_feld_group[ 34] = 'Y' AND ga_page_data[p_i].field034=ga_page_data_t.field034 AND cl_null(ga_page_data[p_i].field033) THEN LET ga_page_data[p_i].field034='' END IF
    WHEN  35  IF g_feld_group[ 35] = 'Y' AND ga_page_data[p_i].field035=ga_page_data_t.field035 AND cl_null(ga_page_data[p_i].field034) THEN LET ga_page_data[p_i].field035='' END IF
    WHEN  36  IF g_feld_group[ 36] = 'Y' AND ga_page_data[p_i].field036=ga_page_data_t.field036 AND cl_null(ga_page_data[p_i].field035) THEN LET ga_page_data[p_i].field036='' END IF
    WHEN  37  IF g_feld_group[ 37] = 'Y' AND ga_page_data[p_i].field037=ga_page_data_t.field037 AND cl_null(ga_page_data[p_i].field036) THEN LET ga_page_data[p_i].field037='' END IF
    WHEN  38  IF g_feld_group[ 38] = 'Y' AND ga_page_data[p_i].field038=ga_page_data_t.field038 AND cl_null(ga_page_data[p_i].field037) THEN LET ga_page_data[p_i].field038='' END IF
    WHEN  39  IF g_feld_group[ 39] = 'Y' AND ga_page_data[p_i].field039=ga_page_data_t.field039 AND cl_null(ga_page_data[p_i].field038) THEN LET ga_page_data[p_i].field039='' END IF
    WHEN  40  IF g_feld_group[ 40] = 'Y' AND ga_page_data[p_i].field040=ga_page_data_t.field040 AND cl_null(ga_page_data[p_i].field039) THEN LET ga_page_data[p_i].field040='' END IF
    WHEN  41  IF g_feld_group[ 41] = 'Y' AND ga_page_data[p_i].field041=ga_page_data_t.field041 AND cl_null(ga_page_data[p_i].field040) THEN LET ga_page_data[p_i].field041='' END IF
    WHEN  42  IF g_feld_group[ 42] = 'Y' AND ga_page_data[p_i].field042=ga_page_data_t.field042 AND cl_null(ga_page_data[p_i].field041) THEN LET ga_page_data[p_i].field042='' END IF
    WHEN  43  IF g_feld_group[ 43] = 'Y' AND ga_page_data[p_i].field043=ga_page_data_t.field043 AND cl_null(ga_page_data[p_i].field042) THEN LET ga_page_data[p_i].field043='' END IF
    WHEN  44  IF g_feld_group[ 44] = 'Y' AND ga_page_data[p_i].field044=ga_page_data_t.field044 AND cl_null(ga_page_data[p_i].field043) THEN LET ga_page_data[p_i].field044='' END IF
    WHEN  45  IF g_feld_group[ 45] = 'Y' AND ga_page_data[p_i].field045=ga_page_data_t.field045 AND cl_null(ga_page_data[p_i].field044) THEN LET ga_page_data[p_i].field045='' END IF
    WHEN  46  IF g_feld_group[ 46] = 'Y' AND ga_page_data[p_i].field046=ga_page_data_t.field046 AND cl_null(ga_page_data[p_i].field045) THEN LET ga_page_data[p_i].field046='' END IF
    WHEN  47  IF g_feld_group[ 47] = 'Y' AND ga_page_data[p_i].field047=ga_page_data_t.field047 AND cl_null(ga_page_data[p_i].field046) THEN LET ga_page_data[p_i].field047='' END IF
    WHEN  48  IF g_feld_group[ 48] = 'Y' AND ga_page_data[p_i].field048=ga_page_data_t.field048 AND cl_null(ga_page_data[p_i].field047) THEN LET ga_page_data[p_i].field048='' END IF
    WHEN  49  IF g_feld_group[ 49] = 'Y' AND ga_page_data[p_i].field049=ga_page_data_t.field049 AND cl_null(ga_page_data[p_i].field048) THEN LET ga_page_data[p_i].field049='' END IF
    WHEN  50  IF g_feld_group[ 50] = 'Y' AND ga_page_data[p_i].field050=ga_page_data_t.field050 AND cl_null(ga_page_data[p_i].field049) THEN LET ga_page_data[p_i].field050='' END IF
    WHEN  51  IF g_feld_group[ 51] = 'Y' AND ga_page_data[p_i].field051=ga_page_data_t.field051 AND cl_null(ga_page_data[p_i].field050) THEN LET ga_page_data[p_i].field051='' END IF
    WHEN  52  IF g_feld_group[ 52] = 'Y' AND ga_page_data[p_i].field052=ga_page_data_t.field052 AND cl_null(ga_page_data[p_i].field051) THEN LET ga_page_data[p_i].field052='' END IF
    WHEN  53  IF g_feld_group[ 53] = 'Y' AND ga_page_data[p_i].field053=ga_page_data_t.field053 AND cl_null(ga_page_data[p_i].field052) THEN LET ga_page_data[p_i].field053='' END IF
    WHEN  54  IF g_feld_group[ 54] = 'Y' AND ga_page_data[p_i].field054=ga_page_data_t.field054 AND cl_null(ga_page_data[p_i].field053) THEN LET ga_page_data[p_i].field054='' END IF
    WHEN  55  IF g_feld_group[ 55] = 'Y' AND ga_page_data[p_i].field055=ga_page_data_t.field055 AND cl_null(ga_page_data[p_i].field054) THEN LET ga_page_data[p_i].field055='' END IF
    WHEN  56  IF g_feld_group[ 56] = 'Y' AND ga_page_data[p_i].field056=ga_page_data_t.field056 AND cl_null(ga_page_data[p_i].field055) THEN LET ga_page_data[p_i].field056='' END IF
    WHEN  57  IF g_feld_group[ 57] = 'Y' AND ga_page_data[p_i].field057=ga_page_data_t.field057 AND cl_null(ga_page_data[p_i].field056) THEN LET ga_page_data[p_i].field057='' END IF
    WHEN  58  IF g_feld_group[ 58] = 'Y' AND ga_page_data[p_i].field058=ga_page_data_t.field058 AND cl_null(ga_page_data[p_i].field057) THEN LET ga_page_data[p_i].field058='' END IF
    WHEN  59  IF g_feld_group[ 59] = 'Y' AND ga_page_data[p_i].field059=ga_page_data_t.field059 AND cl_null(ga_page_data[p_i].field058) THEN LET ga_page_data[p_i].field059='' END IF
    WHEN  60  IF g_feld_group[ 60] = 'Y' AND ga_page_data[p_i].field060=ga_page_data_t.field060 AND cl_null(ga_page_data[p_i].field059) THEN LET ga_page_data[p_i].field060='' END IF
    WHEN  61  IF g_feld_group[ 61] = 'Y' AND ga_page_data[p_i].field061=ga_page_data_t.field061 AND cl_null(ga_page_data[p_i].field060) THEN LET ga_page_data[p_i].field061='' END IF
    WHEN  62  IF g_feld_group[ 62] = 'Y' AND ga_page_data[p_i].field062=ga_page_data_t.field062 AND cl_null(ga_page_data[p_i].field061) THEN LET ga_page_data[p_i].field062='' END IF
    WHEN  63  IF g_feld_group[ 63] = 'Y' AND ga_page_data[p_i].field063=ga_page_data_t.field063 AND cl_null(ga_page_data[p_i].field062) THEN LET ga_page_data[p_i].field063='' END IF
    WHEN  64  IF g_feld_group[ 64] = 'Y' AND ga_page_data[p_i].field064=ga_page_data_t.field064 AND cl_null(ga_page_data[p_i].field063) THEN LET ga_page_data[p_i].field064='' END IF
    WHEN  65  IF g_feld_group[ 65] = 'Y' AND ga_page_data[p_i].field065=ga_page_data_t.field065 AND cl_null(ga_page_data[p_i].field064) THEN LET ga_page_data[p_i].field065='' END IF
    WHEN  66  IF g_feld_group[ 66] = 'Y' AND ga_page_data[p_i].field066=ga_page_data_t.field066 AND cl_null(ga_page_data[p_i].field065) THEN LET ga_page_data[p_i].field066='' END IF
    WHEN  67  IF g_feld_group[ 67] = 'Y' AND ga_page_data[p_i].field067=ga_page_data_t.field067 AND cl_null(ga_page_data[p_i].field066) THEN LET ga_page_data[p_i].field067='' END IF
    WHEN  68  IF g_feld_group[ 68] = 'Y' AND ga_page_data[p_i].field068=ga_page_data_t.field068 AND cl_null(ga_page_data[p_i].field067) THEN LET ga_page_data[p_i].field068='' END IF
    WHEN  69  IF g_feld_group[ 69] = 'Y' AND ga_page_data[p_i].field069=ga_page_data_t.field069 AND cl_null(ga_page_data[p_i].field068) THEN LET ga_page_data[p_i].field069='' END IF
    WHEN  70  IF g_feld_group[ 70] = 'Y' AND ga_page_data[p_i].field070=ga_page_data_t.field070 AND cl_null(ga_page_data[p_i].field069) THEN LET ga_page_data[p_i].field070='' END IF
    WHEN  71  IF g_feld_group[ 71] = 'Y' AND ga_page_data[p_i].field071=ga_page_data_t.field071 AND cl_null(ga_page_data[p_i].field070) THEN LET ga_page_data[p_i].field071='' END IF
    WHEN  72  IF g_feld_group[ 72] = 'Y' AND ga_page_data[p_i].field072=ga_page_data_t.field072 AND cl_null(ga_page_data[p_i].field071) THEN LET ga_page_data[p_i].field072='' END IF
    WHEN  73  IF g_feld_group[ 73] = 'Y' AND ga_page_data[p_i].field073=ga_page_data_t.field073 AND cl_null(ga_page_data[p_i].field072) THEN LET ga_page_data[p_i].field073='' END IF
    WHEN  74  IF g_feld_group[ 74] = 'Y' AND ga_page_data[p_i].field074=ga_page_data_t.field074 AND cl_null(ga_page_data[p_i].field073) THEN LET ga_page_data[p_i].field074='' END IF
    WHEN  75  IF g_feld_group[ 75] = 'Y' AND ga_page_data[p_i].field075=ga_page_data_t.field075 AND cl_null(ga_page_data[p_i].field074) THEN LET ga_page_data[p_i].field075='' END IF
    WHEN  76  IF g_feld_group[ 76] = 'Y' AND ga_page_data[p_i].field076=ga_page_data_t.field076 AND cl_null(ga_page_data[p_i].field075) THEN LET ga_page_data[p_i].field076='' END IF
    WHEN  77  IF g_feld_group[ 77] = 'Y' AND ga_page_data[p_i].field077=ga_page_data_t.field077 AND cl_null(ga_page_data[p_i].field076) THEN LET ga_page_data[p_i].field077='' END IF
    WHEN  78  IF g_feld_group[ 78] = 'Y' AND ga_page_data[p_i].field078=ga_page_data_t.field078 AND cl_null(ga_page_data[p_i].field077) THEN LET ga_page_data[p_i].field078='' END IF
    WHEN  79  IF g_feld_group[ 79] = 'Y' AND ga_page_data[p_i].field079=ga_page_data_t.field079 AND cl_null(ga_page_data[p_i].field078) THEN LET ga_page_data[p_i].field079='' END IF
    WHEN  80  IF g_feld_group[ 80] = 'Y' AND ga_page_data[p_i].field080=ga_page_data_t.field080 AND cl_null(ga_page_data[p_i].field079) THEN LET ga_page_data[p_i].field080='' END IF
    WHEN  81  IF g_feld_group[ 81] = 'Y' AND ga_page_data[p_i].field081=ga_page_data_t.field081 AND cl_null(ga_page_data[p_i].field080) THEN LET ga_page_data[p_i].field081='' END IF
    WHEN  82  IF g_feld_group[ 82] = 'Y' AND ga_page_data[p_i].field082=ga_page_data_t.field082 AND cl_null(ga_page_data[p_i].field081) THEN LET ga_page_data[p_i].field082='' END IF
    WHEN  83  IF g_feld_group[ 83] = 'Y' AND ga_page_data[p_i].field083=ga_page_data_t.field083 AND cl_null(ga_page_data[p_i].field082) THEN LET ga_page_data[p_i].field083='' END IF
    WHEN  84  IF g_feld_group[ 84] = 'Y' AND ga_page_data[p_i].field084=ga_page_data_t.field084 AND cl_null(ga_page_data[p_i].field083) THEN LET ga_page_data[p_i].field084='' END IF
    WHEN  85  IF g_feld_group[ 85] = 'Y' AND ga_page_data[p_i].field085=ga_page_data_t.field085 AND cl_null(ga_page_data[p_i].field084) THEN LET ga_page_data[p_i].field085='' END IF
    WHEN  86  IF g_feld_group[ 86] = 'Y' AND ga_page_data[p_i].field086=ga_page_data_t.field086 AND cl_null(ga_page_data[p_i].field085) THEN LET ga_page_data[p_i].field086='' END IF
    WHEN  87  IF g_feld_group[ 87] = 'Y' AND ga_page_data[p_i].field087=ga_page_data_t.field087 AND cl_null(ga_page_data[p_i].field086) THEN LET ga_page_data[p_i].field087='' END IF
    WHEN  88  IF g_feld_group[ 88] = 'Y' AND ga_page_data[p_i].field088=ga_page_data_t.field088 AND cl_null(ga_page_data[p_i].field087) THEN LET ga_page_data[p_i].field088='' END IF
    WHEN  89  IF g_feld_group[ 89] = 'Y' AND ga_page_data[p_i].field089=ga_page_data_t.field089 AND cl_null(ga_page_data[p_i].field088) THEN LET ga_page_data[p_i].field089='' END IF
    WHEN  90  IF g_feld_group[ 90] = 'Y' AND ga_page_data[p_i].field090=ga_page_data_t.field090 AND cl_null(ga_page_data[p_i].field089) THEN LET ga_page_data[p_i].field090='' END IF
    WHEN  91  IF g_feld_group[ 91] = 'Y' AND ga_page_data[p_i].field091=ga_page_data_t.field091 AND cl_null(ga_page_data[p_i].field090) THEN LET ga_page_data[p_i].field091='' END IF
    WHEN  92  IF g_feld_group[ 92] = 'Y' AND ga_page_data[p_i].field092=ga_page_data_t.field092 AND cl_null(ga_page_data[p_i].field091) THEN LET ga_page_data[p_i].field092='' END IF
    WHEN  93  IF g_feld_group[ 93] = 'Y' AND ga_page_data[p_i].field093=ga_page_data_t.field093 AND cl_null(ga_page_data[p_i].field092) THEN LET ga_page_data[p_i].field093='' END IF
    WHEN  94  IF g_feld_group[ 94] = 'Y' AND ga_page_data[p_i].field094=ga_page_data_t.field094 AND cl_null(ga_page_data[p_i].field093) THEN LET ga_page_data[p_i].field094='' END IF
    WHEN  95  IF g_feld_group[ 95] = 'Y' AND ga_page_data[p_i].field095=ga_page_data_t.field095 AND cl_null(ga_page_data[p_i].field094) THEN LET ga_page_data[p_i].field095='' END IF
    WHEN  96  IF g_feld_group[ 96] = 'Y' AND ga_page_data[p_i].field096=ga_page_data_t.field096 AND cl_null(ga_page_data[p_i].field095) THEN LET ga_page_data[p_i].field096='' END IF
    WHEN  97  IF g_feld_group[ 97] = 'Y' AND ga_page_data[p_i].field097=ga_page_data_t.field097 AND cl_null(ga_page_data[p_i].field096) THEN LET ga_page_data[p_i].field097='' END IF
    WHEN  98  IF g_feld_group[ 98] = 'Y' AND ga_page_data[p_i].field098=ga_page_data_t.field098 AND cl_null(ga_page_data[p_i].field097) THEN LET ga_page_data[p_i].field098='' END IF
    WHEN  99  IF g_feld_group[ 99] = 'Y' AND ga_page_data[p_i].field099=ga_page_data_t.field099 AND cl_null(ga_page_data[p_i].field098) THEN LET ga_page_data[p_i].field099='' END IF
    WHEN 100  IF g_feld_group[100] = 'Y' AND ga_page_data[p_i].field100=ga_page_data_t.field100 AND cl_null(ga_page_data[p_i].field099) THEN LET ga_page_data[p_i].field100='' END IF
   #WHEN 101  IF g_feld_group[101] = 'Y' AND ga_page_data[p_i].field101=ga_page_data_t.field101 AND cl_null(ga_page_data[p_i].field100) THEN LET ga_page_data[p_i].field101='' END IF
   #WHEN 102  IF g_feld_group[102] = 'Y' AND ga_page_data[p_i].field102=ga_page_data_t.field102 AND cl_null(ga_page_data[p_i].field101) THEN LET ga_page_data[p_i].field102='' END IF
   #WHEN 103  IF g_feld_group[103] = 'Y' AND ga_page_data[p_i].field103=ga_page_data_t.field103 AND cl_null(ga_page_data[p_i].field102) THEN LET ga_page_data[p_i].field103='' END IF
   #WHEN 104  IF g_feld_group[104] = 'Y' AND ga_page_data[p_i].field104=ga_page_data_t.field104 AND cl_null(ga_page_data[p_i].field103) THEN LET ga_page_data[p_i].field104='' END IF
   #WHEN 105  IF g_feld_group[105] = 'Y' AND ga_page_data[p_i].field105=ga_page_data_t.field105 AND cl_null(ga_page_data[p_i].field104) THEN LET ga_page_data[p_i].field105='' END IF
   #WHEN 106  IF g_feld_group[106] = 'Y' AND ga_page_data[p_i].field106=ga_page_data_t.field106 AND cl_null(ga_page_data[p_i].field105) THEN LET ga_page_data[p_i].field106='' END IF
   #WHEN 107  IF g_feld_group[107] = 'Y' AND ga_page_data[p_i].field107=ga_page_data_t.field107 AND cl_null(ga_page_data[p_i].field106) THEN LET ga_page_data[p_i].field107='' END IF
   #WHEN 108  IF g_feld_group[108] = 'Y' AND ga_page_data[p_i].field108=ga_page_data_t.field108 AND cl_null(ga_page_data[p_i].field107) THEN LET ga_page_data[p_i].field108='' END IF
   #WHEN 109  IF g_feld_group[109] = 'Y' AND ga_page_data[p_i].field109=ga_page_data_t.field109 AND cl_null(ga_page_data[p_i].field108) THEN LET ga_page_data[p_i].field109='' END IF
   #WHEN 110  IF g_feld_group[110] = 'Y' AND ga_page_data[p_i].field110=ga_page_data_t.field110 AND cl_null(ga_page_data[p_i].field109) THEN LET ga_page_data[p_i].field110='' END IF
   #WHEN 111  IF g_feld_group[111] = 'Y' AND ga_page_data[p_i].field111=ga_page_data_t.field111 AND cl_null(ga_page_data[p_i].field110) THEN LET ga_page_data[p_i].field111='' END IF
   #WHEN 112  IF g_feld_group[112] = 'Y' AND ga_page_data[p_i].field112=ga_page_data_t.field112 AND cl_null(ga_page_data[p_i].field111) THEN LET ga_page_data[p_i].field112='' END IF
   #WHEN 113  IF g_feld_group[113] = 'Y' AND ga_page_data[p_i].field113=ga_page_data_t.field113 AND cl_null(ga_page_data[p_i].field112) THEN LET ga_page_data[p_i].field113='' END IF
   #WHEN 114  IF g_feld_group[114] = 'Y' AND ga_page_data[p_i].field114=ga_page_data_t.field114 AND cl_null(ga_page_data[p_i].field113) THEN LET ga_page_data[p_i].field114='' END IF
   #WHEN 115  IF g_feld_group[115] = 'Y' AND ga_page_data[p_i].field115=ga_page_data_t.field115 AND cl_null(ga_page_data[p_i].field114) THEN LET ga_page_data[p_i].field115='' END IF
   #WHEN 116  IF g_feld_group[116] = 'Y' AND ga_page_data[p_i].field116=ga_page_data_t.field116 AND cl_null(ga_page_data[p_i].field115) THEN LET ga_page_data[p_i].field116='' END IF
   #WHEN 117  IF g_feld_group[117] = 'Y' AND ga_page_data[p_i].field117=ga_page_data_t.field117 AND cl_null(ga_page_data[p_i].field116) THEN LET ga_page_data[p_i].field117='' END IF
   #WHEN 118  IF g_feld_group[118] = 'Y' AND ga_page_data[p_i].field118=ga_page_data_t.field118 AND cl_null(ga_page_data[p_i].field117) THEN LET ga_page_data[p_i].field118='' END IF
   #WHEN 119  IF g_feld_group[119] = 'Y' AND ga_page_data[p_i].field119=ga_page_data_t.field119 AND cl_null(ga_page_data[p_i].field118) THEN LET ga_page_data[p_i].field119='' END IF
   #WHEN 120  IF g_feld_group[120] = 'Y' AND ga_page_data[p_i].field120=ga_page_data_t.field120 AND cl_null(ga_page_data[p_i].field119) THEN LET ga_page_data[p_i].field120='' END IF
   #WHEN 121  IF g_feld_group[121] = 'Y' AND ga_page_data[p_i].field121=ga_page_data_t.field121 AND cl_null(ga_page_data[p_i].field120) THEN LET ga_page_data[p_i].field121='' END IF
   #WHEN 122  IF g_feld_group[122] = 'Y' AND ga_page_data[p_i].field122=ga_page_data_t.field122 AND cl_null(ga_page_data[p_i].field121) THEN LET ga_page_data[p_i].field122='' END IF
   #WHEN 123  IF g_feld_group[123] = 'Y' AND ga_page_data[p_i].field123=ga_page_data_t.field123 AND cl_null(ga_page_data[p_i].field122) THEN LET ga_page_data[p_i].field123='' END IF
   #WHEN 124  IF g_feld_group[124] = 'Y' AND ga_page_data[p_i].field124=ga_page_data_t.field124 AND cl_null(ga_page_data[p_i].field123) THEN LET ga_page_data[p_i].field124='' END IF
   #WHEN 125  IF g_feld_group[125] = 'Y' AND ga_page_data[p_i].field125=ga_page_data_t.field125 AND cl_null(ga_page_data[p_i].field124) THEN LET ga_page_data[p_i].field125='' END IF
   #WHEN 126  IF g_feld_group[126] = 'Y' AND ga_page_data[p_i].field126=ga_page_data_t.field126 AND cl_null(ga_page_data[p_i].field125) THEN LET ga_page_data[p_i].field126='' END IF
   #WHEN 127  IF g_feld_group[127] = 'Y' AND ga_page_data[p_i].field127=ga_page_data_t.field127 AND cl_null(ga_page_data[p_i].field126) THEN LET ga_page_data[p_i].field127='' END IF
   #WHEN 128  IF g_feld_group[128] = 'Y' AND ga_page_data[p_i].field128=ga_page_data_t.field128 AND cl_null(ga_page_data[p_i].field127) THEN LET ga_page_data[p_i].field128='' END IF
   #WHEN 129  IF g_feld_group[129] = 'Y' AND ga_page_data[p_i].field129=ga_page_data_t.field129 AND cl_null(ga_page_data[p_i].field128) THEN LET ga_page_data[p_i].field129='' END IF
   #WHEN 130  IF g_feld_group[130] = 'Y' AND ga_page_data[p_i].field130=ga_page_data_t.field130 AND cl_null(ga_page_data[p_i].field129) THEN LET ga_page_data[p_i].field130='' END IF
   #WHEN 131  IF g_feld_group[131] = 'Y' AND ga_page_data[p_i].field131=ga_page_data_t.field131 AND cl_null(ga_page_data[p_i].field130) THEN LET ga_page_data[p_i].field131='' END IF
   #WHEN 132  IF g_feld_group[132] = 'Y' AND ga_page_data[p_i].field132=ga_page_data_t.field132 AND cl_null(ga_page_data[p_i].field131) THEN LET ga_page_data[p_i].field132='' END IF
   #WHEN 133  IF g_feld_group[133] = 'Y' AND ga_page_data[p_i].field133=ga_page_data_t.field133 AND cl_null(ga_page_data[p_i].field132) THEN LET ga_page_data[p_i].field133='' END IF
   #WHEN 134  IF g_feld_group[134] = 'Y' AND ga_page_data[p_i].field134=ga_page_data_t.field134 AND cl_null(ga_page_data[p_i].field133) THEN LET ga_page_data[p_i].field134='' END IF
   #WHEN 135  IF g_feld_group[135] = 'Y' AND ga_page_data[p_i].field135=ga_page_data_t.field135 AND cl_null(ga_page_data[p_i].field134) THEN LET ga_page_data[p_i].field135='' END IF
   #WHEN 136  IF g_feld_group[136] = 'Y' AND ga_page_data[p_i].field136=ga_page_data_t.field136 AND cl_null(ga_page_data[p_i].field135) THEN LET ga_page_data[p_i].field136='' END IF
   #WHEN 137  IF g_feld_group[137] = 'Y' AND ga_page_data[p_i].field137=ga_page_data_t.field137 AND cl_null(ga_page_data[p_i].field136) THEN LET ga_page_data[p_i].field137='' END IF
   #WHEN 138  IF g_feld_group[138] = 'Y' AND ga_page_data[p_i].field138=ga_page_data_t.field138 AND cl_null(ga_page_data[p_i].field137) THEN LET ga_page_data[p_i].field138='' END IF
   #WHEN 139  IF g_feld_group[139] = 'Y' AND ga_page_data[p_i].field139=ga_page_data_t.field139 AND cl_null(ga_page_data[p_i].field138) THEN LET ga_page_data[p_i].field139='' END IF
   #WHEN 140  IF g_feld_group[140] = 'Y' AND ga_page_data[p_i].field140=ga_page_data_t.field140 AND cl_null(ga_page_data[p_i].field139) THEN LET ga_page_data[p_i].field140='' END IF
   #WHEN 141  IF g_feld_group[141] = 'Y' AND ga_page_data[p_i].field141=ga_page_data_t.field141 AND cl_null(ga_page_data[p_i].field140) THEN LET ga_page_data[p_i].field141='' END IF
   #WHEN 142  IF g_feld_group[142] = 'Y' AND ga_page_data[p_i].field142=ga_page_data_t.field142 AND cl_null(ga_page_data[p_i].field141) THEN LET ga_page_data[p_i].field142='' END IF
   #WHEN 143  IF g_feld_group[143] = 'Y' AND ga_page_data[p_i].field143=ga_page_data_t.field143 AND cl_null(ga_page_data[p_i].field142) THEN LET ga_page_data[p_i].field143='' END IF
   #WHEN 144  IF g_feld_group[144] = 'Y' AND ga_page_data[p_i].field144=ga_page_data_t.field144 AND cl_null(ga_page_data[p_i].field143) THEN LET ga_page_data[p_i].field144='' END IF
   #WHEN 145  IF g_feld_group[145] = 'Y' AND ga_page_data[p_i].field145=ga_page_data_t.field145 AND cl_null(ga_page_data[p_i].field144) THEN LET ga_page_data[p_i].field145='' END IF
   #WHEN 146  IF g_feld_group[146] = 'Y' AND ga_page_data[p_i].field146=ga_page_data_t.field146 AND cl_null(ga_page_data[p_i].field145) THEN LET ga_page_data[p_i].field146='' END IF
   #WHEN 147  IF g_feld_group[147] = 'Y' AND ga_page_data[p_i].field147=ga_page_data_t.field147 AND cl_null(ga_page_data[p_i].field146) THEN LET ga_page_data[p_i].field147='' END IF
   #WHEN 148  IF g_feld_group[148] = 'Y' AND ga_page_data[p_i].field148=ga_page_data_t.field148 AND cl_null(ga_page_data[p_i].field147) THEN LET ga_page_data[p_i].field148='' END IF
   #WHEN 149  IF g_feld_group[149] = 'Y' AND ga_page_data[p_i].field149=ga_page_data_t.field149 AND cl_null(ga_page_data[p_i].field148) THEN LET ga_page_data[p_i].field149='' END IF
   #WHEN 150  IF g_feld_group[150] = 'Y' AND ga_page_data[p_i].field150=ga_page_data_t.field150 AND cl_null(ga_page_data[p_i].field149) THEN LET ga_page_data[p_i].field150='' END IF
   #WHEN 151  IF g_feld_group[151] = 'Y' AND ga_page_data[p_i].field151=ga_page_data_t.field151 AND cl_null(ga_page_data[p_i].field150) THEN LET ga_page_data[p_i].field151='' END IF
   #WHEN 152  IF g_feld_group[152] = 'Y' AND ga_page_data[p_i].field152=ga_page_data_t.field152 AND cl_null(ga_page_data[p_i].field151) THEN LET ga_page_data[p_i].field152='' END IF
   #WHEN 153  IF g_feld_group[153] = 'Y' AND ga_page_data[p_i].field153=ga_page_data_t.field153 AND cl_null(ga_page_data[p_i].field152) THEN LET ga_page_data[p_i].field153='' END IF
   #WHEN 154  IF g_feld_group[154] = 'Y' AND ga_page_data[p_i].field154=ga_page_data_t.field154 AND cl_null(ga_page_data[p_i].field153) THEN LET ga_page_data[p_i].field154='' END IF
   #WHEN 155  IF g_feld_group[155] = 'Y' AND ga_page_data[p_i].field155=ga_page_data_t.field155 AND cl_null(ga_page_data[p_i].field154) THEN LET ga_page_data[p_i].field155='' END IF
   #WHEN 156  IF g_feld_group[156] = 'Y' AND ga_page_data[p_i].field156=ga_page_data_t.field156 AND cl_null(ga_page_data[p_i].field155) THEN LET ga_page_data[p_i].field156='' END IF
   #WHEN 157  IF g_feld_group[157] = 'Y' AND ga_page_data[p_i].field157=ga_page_data_t.field157 AND cl_null(ga_page_data[p_i].field156) THEN LET ga_page_data[p_i].field157='' END IF
   #WHEN 158  IF g_feld_group[158] = 'Y' AND ga_page_data[p_i].field158=ga_page_data_t.field158 AND cl_null(ga_page_data[p_i].field157) THEN LET ga_page_data[p_i].field158='' END IF
   #WHEN 159  IF g_feld_group[159] = 'Y' AND ga_page_data[p_i].field159=ga_page_data_t.field159 AND cl_null(ga_page_data[p_i].field158) THEN LET ga_page_data[p_i].field159='' END IF
   #WHEN 160  IF g_feld_group[160] = 'Y' AND ga_page_data[p_i].field160=ga_page_data_t.field160 AND cl_null(ga_page_data[p_i].field159) THEN LET ga_page_data[p_i].field160='' END IF
   #WHEN 161  IF g_feld_group[161] = 'Y' AND ga_page_data[p_i].field161=ga_page_data_t.field161 AND cl_null(ga_page_data[p_i].field160) THEN LET ga_page_data[p_i].field161='' END IF
   #WHEN 162  IF g_feld_group[162] = 'Y' AND ga_page_data[p_i].field162=ga_page_data_t.field162 AND cl_null(ga_page_data[p_i].field161) THEN LET ga_page_data[p_i].field162='' END IF
   #WHEN 163  IF g_feld_group[163] = 'Y' AND ga_page_data[p_i].field163=ga_page_data_t.field163 AND cl_null(ga_page_data[p_i].field162) THEN LET ga_page_data[p_i].field163='' END IF
   #WHEN 164  IF g_feld_group[164] = 'Y' AND ga_page_data[p_i].field164=ga_page_data_t.field164 AND cl_null(ga_page_data[p_i].field163) THEN LET ga_page_data[p_i].field164='' END IF
   #WHEN 165  IF g_feld_group[165] = 'Y' AND ga_page_data[p_i].field165=ga_page_data_t.field165 AND cl_null(ga_page_data[p_i].field164) THEN LET ga_page_data[p_i].field165='' END IF
   #WHEN 166  IF g_feld_group[166] = 'Y' AND ga_page_data[p_i].field166=ga_page_data_t.field166 AND cl_null(ga_page_data[p_i].field165) THEN LET ga_page_data[p_i].field166='' END IF
   #WHEN 167  IF g_feld_group[167] = 'Y' AND ga_page_data[p_i].field167=ga_page_data_t.field167 AND cl_null(ga_page_data[p_i].field166) THEN LET ga_page_data[p_i].field167='' END IF
   #WHEN 168  IF g_feld_group[168] = 'Y' AND ga_page_data[p_i].field168=ga_page_data_t.field168 AND cl_null(ga_page_data[p_i].field167) THEN LET ga_page_data[p_i].field168='' END IF
   #WHEN 169  IF g_feld_group[169] = 'Y' AND ga_page_data[p_i].field169=ga_page_data_t.field169 AND cl_null(ga_page_data[p_i].field168) THEN LET ga_page_data[p_i].field169='' END IF
   #WHEN 170  IF g_feld_group[170] = 'Y' AND ga_page_data[p_i].field170=ga_page_data_t.field170 AND cl_null(ga_page_data[p_i].field169) THEN LET ga_page_data[p_i].field170='' END IF
   #WHEN 171  IF g_feld_group[171] = 'Y' AND ga_page_data[p_i].field171=ga_page_data_t.field171 AND cl_null(ga_page_data[p_i].field170) THEN LET ga_page_data[p_i].field171='' END IF
   #WHEN 172  IF g_feld_group[172] = 'Y' AND ga_page_data[p_i].field172=ga_page_data_t.field172 AND cl_null(ga_page_data[p_i].field171) THEN LET ga_page_data[p_i].field172='' END IF
   #WHEN 173  IF g_feld_group[173] = 'Y' AND ga_page_data[p_i].field173=ga_page_data_t.field173 AND cl_null(ga_page_data[p_i].field172) THEN LET ga_page_data[p_i].field173='' END IF
   #WHEN 174  IF g_feld_group[174] = 'Y' AND ga_page_data[p_i].field174=ga_page_data_t.field174 AND cl_null(ga_page_data[p_i].field173) THEN LET ga_page_data[p_i].field174='' END IF
   #WHEN 175  IF g_feld_group[175] = 'Y' AND ga_page_data[p_i].field175=ga_page_data_t.field175 AND cl_null(ga_page_data[p_i].field174) THEN LET ga_page_data[p_i].field175='' END IF
   #WHEN 176  IF g_feld_group[176] = 'Y' AND ga_page_data[p_i].field176=ga_page_data_t.field176 AND cl_null(ga_page_data[p_i].field175) THEN LET ga_page_data[p_i].field176='' END IF
   #WHEN 177  IF g_feld_group[177] = 'Y' AND ga_page_data[p_i].field177=ga_page_data_t.field177 AND cl_null(ga_page_data[p_i].field176) THEN LET ga_page_data[p_i].field177='' END IF
   #WHEN 178  IF g_feld_group[178] = 'Y' AND ga_page_data[p_i].field178=ga_page_data_t.field178 AND cl_null(ga_page_data[p_i].field177) THEN LET ga_page_data[p_i].field178='' END IF
   #WHEN 179  IF g_feld_group[179] = 'Y' AND ga_page_data[p_i].field179=ga_page_data_t.field179 AND cl_null(ga_page_data[p_i].field178) THEN LET ga_page_data[p_i].field179='' END IF
   #WHEN 180  IF g_feld_group[180] = 'Y' AND ga_page_data[p_i].field180=ga_page_data_t.field180 AND cl_null(ga_page_data[p_i].field179) THEN LET ga_page_data[p_i].field180='' END IF
   #WHEN 181  IF g_feld_group[181] = 'Y' AND ga_page_data[p_i].field181=ga_page_data_t.field181 AND cl_null(ga_page_data[p_i].field180) THEN LET ga_page_data[p_i].field181='' END IF
   #WHEN 182  IF g_feld_group[182] = 'Y' AND ga_page_data[p_i].field182=ga_page_data_t.field182 AND cl_null(ga_page_data[p_i].field181) THEN LET ga_page_data[p_i].field182='' END IF
   #WHEN 183  IF g_feld_group[183] = 'Y' AND ga_page_data[p_i].field183=ga_page_data_t.field183 AND cl_null(ga_page_data[p_i].field182) THEN LET ga_page_data[p_i].field183='' END IF
   #WHEN 184  IF g_feld_group[184] = 'Y' AND ga_page_data[p_i].field184=ga_page_data_t.field184 AND cl_null(ga_page_data[p_i].field183) THEN LET ga_page_data[p_i].field184='' END IF
   #WHEN 185  IF g_feld_group[185] = 'Y' AND ga_page_data[p_i].field185=ga_page_data_t.field185 AND cl_null(ga_page_data[p_i].field184) THEN LET ga_page_data[p_i].field185='' END IF
   #WHEN 186  IF g_feld_group[186] = 'Y' AND ga_page_data[p_i].field186=ga_page_data_t.field186 AND cl_null(ga_page_data[p_i].field185) THEN LET ga_page_data[p_i].field186='' END IF
   #WHEN 187  IF g_feld_group[187] = 'Y' AND ga_page_data[p_i].field187=ga_page_data_t.field187 AND cl_null(ga_page_data[p_i].field186) THEN LET ga_page_data[p_i].field187='' END IF
   #WHEN 188  IF g_feld_group[188] = 'Y' AND ga_page_data[p_i].field188=ga_page_data_t.field188 AND cl_null(ga_page_data[p_i].field187) THEN LET ga_page_data[p_i].field188='' END IF
   #WHEN 189  IF g_feld_group[189] = 'Y' AND ga_page_data[p_i].field189=ga_page_data_t.field189 AND cl_null(ga_page_data[p_i].field188) THEN LET ga_page_data[p_i].field189='' END IF
   #WHEN 190  IF g_feld_group[190] = 'Y' AND ga_page_data[p_i].field190=ga_page_data_t.field190 AND cl_null(ga_page_data[p_i].field189) THEN LET ga_page_data[p_i].field190='' END IF
   #WHEN 191  IF g_feld_group[191] = 'Y' AND ga_page_data[p_i].field191=ga_page_data_t.field191 AND cl_null(ga_page_data[p_i].field190) THEN LET ga_page_data[p_i].field191='' END IF
   #WHEN 192  IF g_feld_group[192] = 'Y' AND ga_page_data[p_i].field192=ga_page_data_t.field192 AND cl_null(ga_page_data[p_i].field191) THEN LET ga_page_data[p_i].field192='' END IF
   #WHEN 193  IF g_feld_group[193] = 'Y' AND ga_page_data[p_i].field193=ga_page_data_t.field193 AND cl_null(ga_page_data[p_i].field192) THEN LET ga_page_data[p_i].field193='' END IF
   #WHEN 194  IF g_feld_group[194] = 'Y' AND ga_page_data[p_i].field194=ga_page_data_t.field194 AND cl_null(ga_page_data[p_i].field193) THEN LET ga_page_data[p_i].field194='' END IF
   #WHEN 195  IF g_feld_group[195] = 'Y' AND ga_page_data[p_i].field195=ga_page_data_t.field195 AND cl_null(ga_page_data[p_i].field194) THEN LET ga_page_data[p_i].field195='' END IF
   #WHEN 196  IF g_feld_group[196] = 'Y' AND ga_page_data[p_i].field196=ga_page_data_t.field196 AND cl_null(ga_page_data[p_i].field195) THEN LET ga_page_data[p_i].field196='' END IF
   #WHEN 197  IF g_feld_group[197] = 'Y' AND ga_page_data[p_i].field197=ga_page_data_t.field197 AND cl_null(ga_page_data[p_i].field196) THEN LET ga_page_data[p_i].field197='' END IF
   #WHEN 198  IF g_feld_group[198] = 'Y' AND ga_page_data[p_i].field198=ga_page_data_t.field198 AND cl_null(ga_page_data[p_i].field197) THEN LET ga_page_data[p_i].field198='' END IF
   #WHEN 199  IF g_feld_group[199] = 'Y' AND ga_page_data[p_i].field199=ga_page_data_t.field199 AND cl_null(ga_page_data[p_i].field198) THEN LET ga_page_data[p_i].field199='' END IF
   #WHEN 200  IF g_feld_group[200] = 'Y' AND ga_page_data[p_i].field200=ga_page_data_t.field200 AND cl_null(ga_page_data[p_i].field199) THEN LET ga_page_data[p_i].field200='' END IF
   END CASE
 
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 報表 SUM 顯示格式處理
# Date & Author..:
# Input Parameter: p_k,p_i
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_sum_data(p_k,p_i)
DEFINE p_k            LIKE type_file.num10       #目前check的欄位
DEFINE p_i            LIKE type_file.num10       #目前check的筆數
DEFINE l_status       LIKE type_file.num5
DEFINE l_str          LIKE gaq_file.gaq03
DEFINE l_zan03        LIKE zan_file.zan03
DEFINE l_zan03_type   LIKE zan_file.zan03
DEFINE l_tag          LIKE type_file.num5
DEFINE l_sum_name     STRING
 
   LET l_zan03 = ""
   LET g_data_end_total = 0
   wHILE TRUE  
    #CASE p_k 
    # WHEN   1 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field001=l_sum_name  LET ga_sum_data[l_zan03,2].field001=l_str END IF END IF
    # WHEN   2 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field002=l_sum_name  LET ga_sum_data[l_zan03,2].field002=l_str END IF END IF
    # WHEN   3 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field003=l_sum_name  LET ga_sum_data[l_zan03,2].field003=l_str END IF END IF
    # WHEN   4 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field004=l_sum_name  LET ga_sum_data[l_zan03,2].field004=l_str END IF END IF
    # WHEN   5 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field005=l_sum_name  LET ga_sum_data[l_zan03,2].field005=l_str END IF END IF
    # WHEN   6 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field006=l_sum_name  LET ga_sum_data[l_zan03,2].field006=l_str END IF END IF
    # WHEN   7 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field007=l_sum_name  LET ga_sum_data[l_zan03,2].field007=l_str END IF END IF
    # WHEN   8 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field008=l_sum_name  LET ga_sum_data[l_zan03,2].field008=l_str END IF END IF
    # WHEN   9 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field009=l_sum_name  LET ga_sum_data[l_zan03,2].field009=l_str END IF END IF
    # WHEN  10 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field010=l_sum_name  LET ga_sum_data[l_zan03,2].field010=l_str END IF END IF
    # WHEN  11 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field011=l_sum_name  LET ga_sum_data[l_zan03,2].field011=l_str END IF END IF
    # WHEN  12 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field012=l_sum_name  LET ga_sum_data[l_zan03,2].field012=l_str END IF END IF
    # WHEN  13 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field013=l_sum_name  LET ga_sum_data[l_zan03,2].field013=l_str END IF END IF
    # WHEN  14 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field014=l_sum_name  LET ga_sum_data[l_zan03,2].field014=l_str END IF END IF
    # WHEN  15 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field015=l_sum_name  LET ga_sum_data[l_zan03,2].field015=l_str END IF END IF
    # WHEN  16 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field016=l_sum_name  LET ga_sum_data[l_zan03,2].field016=l_str END IF END IF
    # WHEN  17 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field017=l_sum_name  LET ga_sum_data[l_zan03,2].field017=l_str END IF END IF
    # WHEN  18 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field018=l_sum_name  LET ga_sum_data[l_zan03,2].field018=l_str END IF END IF
    # WHEN  19 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field019=l_sum_name  LET ga_sum_data[l_zan03,2].field019=l_str END IF END IF
    # WHEN  20 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field020=l_sum_name  LET ga_sum_data[l_zan03,2].field020=l_str END IF END IF
    # WHEN  21 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field021=l_sum_name  LET ga_sum_data[l_zan03,2].field021=l_str END IF END IF
    # WHEN  22 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field022=l_sum_name  LET ga_sum_data[l_zan03,2].field022=l_str END IF END IF
    # WHEN  23 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field023=l_sum_name  LET ga_sum_data[l_zan03,2].field023=l_str END IF END IF
    # WHEN  24 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field024=l_sum_name  LET ga_sum_data[l_zan03,2].field024=l_str END IF END IF
    # WHEN  25 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field025=l_sum_name  LET ga_sum_data[l_zan03,2].field025=l_str END IF END IF
    # WHEN  26 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field026=l_sum_name  LET ga_sum_data[l_zan03,2].field026=l_str END IF END IF
    # WHEN  27 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field027=l_sum_name  LET ga_sum_data[l_zan03,2].field027=l_str END IF END IF
    # WHEN  28 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field028=l_sum_name  LET ga_sum_data[l_zan03,2].field028=l_str END IF END IF
    # WHEN  29 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field029=l_sum_name  LET ga_sum_data[l_zan03,2].field029=l_str END IF END IF
    # WHEN  30 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field030=l_sum_name  LET ga_sum_data[l_zan03,2].field030=l_str END IF END IF
    # WHEN  31 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field031=l_sum_name  LET ga_sum_data[l_zan03,2].field031=l_str END IF END IF
    # WHEN  32 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field032=l_sum_name  LET ga_sum_data[l_zan03,2].field032=l_str END IF END IF
    # WHEN  33 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field033=l_sum_name  LET ga_sum_data[l_zan03,2].field033=l_str END IF END IF
    # WHEN  34 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field034=l_sum_name  LET ga_sum_data[l_zan03,2].field034=l_str END IF END IF
    # WHEN  35 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field035=l_sum_name  LET ga_sum_data[l_zan03,2].field035=l_str END IF END IF
    # WHEN  36 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field036=l_sum_name  LET ga_sum_data[l_zan03,2].field036=l_str END IF END IF
    # WHEN  37 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field037=l_sum_name  LET ga_sum_data[l_zan03,2].field037=l_str END IF END IF
    # WHEN  38 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field038=l_sum_name  LET ga_sum_data[l_zan03,2].field038=l_str END IF END IF
    # WHEN  39 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field039=l_sum_name  LET ga_sum_data[l_zan03,2].field039=l_str END IF END IF
    # WHEN  40 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field040=l_sum_name  LET ga_sum_data[l_zan03,2].field040=l_str END IF END IF
    # WHEN  41 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field041=l_sum_name  LET ga_sum_data[l_zan03,2].field041=l_str END IF END IF
    # WHEN  42 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field042=l_sum_name  LET ga_sum_data[l_zan03,2].field042=l_str END IF END IF
    # WHEN  43 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field043=l_sum_name  LET ga_sum_data[l_zan03,2].field043=l_str END IF END IF
    # WHEN  44 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field044=l_sum_name  LET ga_sum_data[l_zan03,2].field044=l_str END IF END IF
    # WHEN  45 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field045=l_sum_name  LET ga_sum_data[l_zan03,2].field045=l_str END IF END IF
    # WHEN  46 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field046=l_sum_name  LET ga_sum_data[l_zan03,2].field046=l_str END IF END IF
    # WHEN  47 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field047=l_sum_name  LET ga_sum_data[l_zan03,2].field047=l_str END IF END IF
    # WHEN  48 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field048=l_sum_name  LET ga_sum_data[l_zan03,2].field048=l_str END IF END IF
    # WHEN  49 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field049=l_sum_name  LET ga_sum_data[l_zan03,2].field049=l_str END IF END IF
    # WHEN  50 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field050=l_sum_name  LET ga_sum_data[l_zan03,2].field050=l_str END IF END IF
    # WHEN  51 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field051=l_sum_name  LET ga_sum_data[l_zan03,2].field051=l_str END IF END IF
    # WHEN  52 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field052=l_sum_name  LET ga_sum_data[l_zan03,2].field052=l_str END IF END IF
    # WHEN  53 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field053=l_sum_name  LET ga_sum_data[l_zan03,2].field053=l_str END IF END IF
    # WHEN  54 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field054=l_sum_name  LET ga_sum_data[l_zan03,2].field054=l_str END IF END IF
    # WHEN  55 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field055=l_sum_name  LET ga_sum_data[l_zan03,2].field055=l_str END IF END IF
    # WHEN  56 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field056=l_sum_name  LET ga_sum_data[l_zan03,2].field056=l_str END IF END IF
    # WHEN  57 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field057=l_sum_name  LET ga_sum_data[l_zan03,2].field057=l_str END IF END IF
    # WHEN  58 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field058=l_sum_name  LET ga_sum_data[l_zan03,2].field058=l_str END IF END IF
    # WHEN  59 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field059=l_sum_name  LET ga_sum_data[l_zan03,2].field059=l_str END IF END IF
    # WHEN  60 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field060=l_sum_name  LET ga_sum_data[l_zan03,2].field060=l_str END IF END IF
    # WHEN  61 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field061=l_sum_name  LET ga_sum_data[l_zan03,2].field061=l_str END IF END IF
    # WHEN  62 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field062=l_sum_name  LET ga_sum_data[l_zan03,2].field062=l_str END IF END IF
    # WHEN  63 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field063=l_sum_name  LET ga_sum_data[l_zan03,2].field063=l_str END IF END IF
    # WHEN  64 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field064=l_sum_name  LET ga_sum_data[l_zan03,2].field064=l_str END IF END IF
    # WHEN  65 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field065=l_sum_name  LET ga_sum_data[l_zan03,2].field065=l_str END IF END IF
    # WHEN  66 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field066=l_sum_name  LET ga_sum_data[l_zan03,2].field066=l_str END IF END IF
    # WHEN  67 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field067=l_sum_name  LET ga_sum_data[l_zan03,2].field067=l_str END IF END IF
    # WHEN  68 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field068=l_sum_name  LET ga_sum_data[l_zan03,2].field068=l_str END IF END IF
    # WHEN  69 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field069=l_sum_name  LET ga_sum_data[l_zan03,2].field069=l_str END IF END IF
    # WHEN  70 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field070=l_sum_name  LET ga_sum_data[l_zan03,2].field070=l_str END IF END IF
    # WHEN  71 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field071=l_sum_name  LET ga_sum_data[l_zan03,2].field071=l_str END IF END IF
    # WHEN  72 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field072=l_sum_name  LET ga_sum_data[l_zan03,2].field072=l_str END IF END IF
    # WHEN  73 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field073=l_sum_name  LET ga_sum_data[l_zan03,2].field073=l_str END IF END IF
    # WHEN  74 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field074=l_sum_name  LET ga_sum_data[l_zan03,2].field074=l_str END IF END IF
    # WHEN  75 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field075=l_sum_name  LET ga_sum_data[l_zan03,2].field075=l_str END IF END IF
    # WHEN  76 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field076=l_sum_name  LET ga_sum_data[l_zan03,2].field076=l_str END IF END IF
    # WHEN  77 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field077=l_sum_name  LET ga_sum_data[l_zan03,2].field077=l_str END IF END IF
    # WHEN  78 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field078=l_sum_name  LET ga_sum_data[l_zan03,2].field078=l_str END IF END IF
    # WHEN  79 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field079=l_sum_name  LET ga_sum_data[l_zan03,2].field079=l_str END IF END IF
    # WHEN  80 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field080=l_sum_name  LET ga_sum_data[l_zan03,2].field080=l_str END IF END IF
    # WHEN  81 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field081=l_sum_name  LET ga_sum_data[l_zan03,2].field081=l_str END IF END IF
    # WHEN  82 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field082=l_sum_name  LET ga_sum_data[l_zan03,2].field082=l_str END IF END IF
    # WHEN  83 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field083=l_sum_name  LET ga_sum_data[l_zan03,2].field083=l_str END IF END IF
    # WHEN  84 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field084=l_sum_name  LET ga_sum_data[l_zan03,2].field084=l_str END IF END IF
    # WHEN  85 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field085=l_sum_name  LET ga_sum_data[l_zan03,2].field085=l_str END IF END IF
    # WHEN  86 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field086=l_sum_name  LET ga_sum_data[l_zan03,2].field086=l_str END IF END IF
    # WHEN  87 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field087=l_sum_name  LET ga_sum_data[l_zan03,2].field087=l_str END IF END IF
    # WHEN  88 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field088=l_sum_name  LET ga_sum_data[l_zan03,2].field088=l_str END IF END IF
    # WHEN  89 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field089=l_sum_name  LET ga_sum_data[l_zan03,2].field089=l_str END IF END IF
    # WHEN  90 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field090=l_sum_name  LET ga_sum_data[l_zan03,2].field090=l_str END IF END IF
    # WHEN  91 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field091=l_sum_name  LET ga_sum_data[l_zan03,2].field091=l_str END IF END IF
    # WHEN  92 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field092=l_sum_name  LET ga_sum_data[l_zan03,2].field092=l_str END IF END IF
    # WHEN  93 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field093=l_sum_name  LET ga_sum_data[l_zan03,2].field093=l_str END IF END IF
    # WHEN  94 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field094=l_sum_name  LET ga_sum_data[l_zan03,2].field094=l_str END IF END IF
    # WHEN  95 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field095=l_sum_name  LET ga_sum_data[l_zan03,2].field095=l_str END IF END IF
    # WHEN  96 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field096=l_sum_name  LET ga_sum_data[l_zan03,2].field096=l_str END IF END IF
    # WHEN  97 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field097=l_sum_name  LET ga_sum_data[l_zan03,2].field097=l_str END IF END IF
    # WHEN  98 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field098=l_sum_name  LET ga_sum_data[l_zan03,2].field098=l_str END IF END IF
    # WHEN  99 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field099=l_sum_name  LET ga_sum_data[l_zan03,2].field099=l_str END IF END IF
    # WHEN 100 IF (g_feld_sum[p_k].getLength() > 0) THEN CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field100=l_sum_name  LET ga_sum_data[l_zan03,2].field100=l_str END IF END IF
    #END CASE
      CASE p_k 
       WHEN   1 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field001=l_sum_name  LET ga_sum_data[l_zan03,2].field001=l_str END IF
       WHEN   2 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field002=l_sum_name  LET ga_sum_data[l_zan03,2].field002=l_str END IF
       WHEN   3 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field003=l_sum_name  LET ga_sum_data[l_zan03,2].field003=l_str END IF
       WHEN   4 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field004=l_sum_name  LET ga_sum_data[l_zan03,2].field004=l_str END IF
       WHEN   5 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field005=l_sum_name  LET ga_sum_data[l_zan03,2].field005=l_str END IF
       WHEN   6 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field006=l_sum_name  LET ga_sum_data[l_zan03,2].field006=l_str END IF
       WHEN   7 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field007=l_sum_name  LET ga_sum_data[l_zan03,2].field007=l_str END IF
       WHEN   8 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field008=l_sum_name  LET ga_sum_data[l_zan03,2].field008=l_str END IF
       WHEN   9 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field009=l_sum_name  LET ga_sum_data[l_zan03,2].field009=l_str END IF
       WHEN  10 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field010=l_sum_name  LET ga_sum_data[l_zan03,2].field010=l_str END IF
       WHEN  11 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field011=l_sum_name  LET ga_sum_data[l_zan03,2].field011=l_str END IF
       WHEN  12 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field012=l_sum_name  LET ga_sum_data[l_zan03,2].field012=l_str END IF
       WHEN  13 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field013=l_sum_name  LET ga_sum_data[l_zan03,2].field013=l_str END IF
       WHEN  14 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field014=l_sum_name  LET ga_sum_data[l_zan03,2].field014=l_str END IF
       WHEN  15 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field015=l_sum_name  LET ga_sum_data[l_zan03,2].field015=l_str END IF
       WHEN  16 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field016=l_sum_name  LET ga_sum_data[l_zan03,2].field016=l_str END IF
       WHEN  17 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field017=l_sum_name  LET ga_sum_data[l_zan03,2].field017=l_str END IF
       WHEN  18 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field018=l_sum_name  LET ga_sum_data[l_zan03,2].field018=l_str END IF
       WHEN  19 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field019=l_sum_name  LET ga_sum_data[l_zan03,2].field019=l_str END IF
       WHEN  20 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field020=l_sum_name  LET ga_sum_data[l_zan03,2].field020=l_str END IF
       WHEN  21 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field021=l_sum_name  LET ga_sum_data[l_zan03,2].field021=l_str END IF
       WHEN  22 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field022=l_sum_name  LET ga_sum_data[l_zan03,2].field022=l_str END IF
       WHEN  23 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field023=l_sum_name  LET ga_sum_data[l_zan03,2].field023=l_str END IF
       WHEN  24 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field024=l_sum_name  LET ga_sum_data[l_zan03,2].field024=l_str END IF
       WHEN  25 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field025=l_sum_name  LET ga_sum_data[l_zan03,2].field025=l_str END IF
       WHEN  26 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field026=l_sum_name  LET ga_sum_data[l_zan03,2].field026=l_str END IF
       WHEN  27 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field027=l_sum_name  LET ga_sum_data[l_zan03,2].field027=l_str END IF
       WHEN  28 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field028=l_sum_name  LET ga_sum_data[l_zan03,2].field028=l_str END IF
       WHEN  29 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field029=l_sum_name  LET ga_sum_data[l_zan03,2].field029=l_str END IF
       WHEN  30 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field030=l_sum_name  LET ga_sum_data[l_zan03,2].field030=l_str END IF
       WHEN  31 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field031=l_sum_name  LET ga_sum_data[l_zan03,2].field031=l_str END IF
       WHEN  32 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field032=l_sum_name  LET ga_sum_data[l_zan03,2].field032=l_str END IF
       WHEN  33 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field033=l_sum_name  LET ga_sum_data[l_zan03,2].field033=l_str END IF
       WHEN  34 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field034=l_sum_name  LET ga_sum_data[l_zan03,2].field034=l_str END IF
       WHEN  35 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field035=l_sum_name  LET ga_sum_data[l_zan03,2].field035=l_str END IF
       WHEN  36 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field036=l_sum_name  LET ga_sum_data[l_zan03,2].field036=l_str END IF
       WHEN  37 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field037=l_sum_name  LET ga_sum_data[l_zan03,2].field037=l_str END IF
       WHEN  38 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field038=l_sum_name  LET ga_sum_data[l_zan03,2].field038=l_str END IF
       WHEN  39 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field039=l_sum_name  LET ga_sum_data[l_zan03,2].field039=l_str END IF
       WHEN  40 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field040=l_sum_name  LET ga_sum_data[l_zan03,2].field040=l_str END IF
       WHEN  41 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field041=l_sum_name  LET ga_sum_data[l_zan03,2].field041=l_str END IF
       WHEN  42 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field042=l_sum_name  LET ga_sum_data[l_zan03,2].field042=l_str END IF
       WHEN  43 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field043=l_sum_name  LET ga_sum_data[l_zan03,2].field043=l_str END IF
       WHEN  44 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field044=l_sum_name  LET ga_sum_data[l_zan03,2].field044=l_str END IF
       WHEN  45 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field045=l_sum_name  LET ga_sum_data[l_zan03,2].field045=l_str END IF
       WHEN  46 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field046=l_sum_name  LET ga_sum_data[l_zan03,2].field046=l_str END IF
       WHEN  47 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field047=l_sum_name  LET ga_sum_data[l_zan03,2].field047=l_str END IF
       WHEN  48 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field048=l_sum_name  LET ga_sum_data[l_zan03,2].field048=l_str END IF
       WHEN  49 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field049=l_sum_name  LET ga_sum_data[l_zan03,2].field049=l_str END IF
       WHEN  50 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field050=l_sum_name  LET ga_sum_data[l_zan03,2].field050=l_str END IF
       WHEN  51 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field051=l_sum_name  LET ga_sum_data[l_zan03,2].field051=l_str END IF
       WHEN  52 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field052=l_sum_name  LET ga_sum_data[l_zan03,2].field052=l_str END IF
       WHEN  53 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field053=l_sum_name  LET ga_sum_data[l_zan03,2].field053=l_str END IF
       WHEN  54 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field054=l_sum_name  LET ga_sum_data[l_zan03,2].field054=l_str END IF
       WHEN  55 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field055=l_sum_name  LET ga_sum_data[l_zan03,2].field055=l_str END IF
       WHEN  56 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field056=l_sum_name  LET ga_sum_data[l_zan03,2].field056=l_str END IF
       WHEN  57 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field057=l_sum_name  LET ga_sum_data[l_zan03,2].field057=l_str END IF
       WHEN  58 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field058=l_sum_name  LET ga_sum_data[l_zan03,2].field058=l_str END IF
       WHEN  59 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field059=l_sum_name  LET ga_sum_data[l_zan03,2].field059=l_str END IF
       WHEN  60 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field060=l_sum_name  LET ga_sum_data[l_zan03,2].field060=l_str END IF
       WHEN  61 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field061=l_sum_name  LET ga_sum_data[l_zan03,2].field061=l_str END IF
       WHEN  62 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field062=l_sum_name  LET ga_sum_data[l_zan03,2].field062=l_str END IF
       WHEN  63 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field063=l_sum_name  LET ga_sum_data[l_zan03,2].field063=l_str END IF
       WHEN  64 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field064=l_sum_name  LET ga_sum_data[l_zan03,2].field064=l_str END IF
       WHEN  65 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field065=l_sum_name  LET ga_sum_data[l_zan03,2].field065=l_str END IF
       WHEN  66 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field066=l_sum_name  LET ga_sum_data[l_zan03,2].field066=l_str END IF
       WHEN  67 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field067=l_sum_name  LET ga_sum_data[l_zan03,2].field067=l_str END IF
       WHEN  68 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field068=l_sum_name  LET ga_sum_data[l_zan03,2].field068=l_str END IF
       WHEN  69 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field069=l_sum_name  LET ga_sum_data[l_zan03,2].field069=l_str END IF
       WHEN  70 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field070=l_sum_name  LET ga_sum_data[l_zan03,2].field070=l_str END IF
       WHEN  71 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field071=l_sum_name  LET ga_sum_data[l_zan03,2].field071=l_str END IF
       WHEN  72 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field072=l_sum_name  LET ga_sum_data[l_zan03,2].field072=l_str END IF
       WHEN  73 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field073=l_sum_name  LET ga_sum_data[l_zan03,2].field073=l_str END IF
       WHEN  74 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field074=l_sum_name  LET ga_sum_data[l_zan03,2].field074=l_str END IF
       WHEN  75 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field075=l_sum_name  LET ga_sum_data[l_zan03,2].field075=l_str END IF
       WHEN  76 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field076=l_sum_name  LET ga_sum_data[l_zan03,2].field076=l_str END IF
       WHEN  77 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field077=l_sum_name  LET ga_sum_data[l_zan03,2].field077=l_str END IF
       WHEN  78 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field078=l_sum_name  LET ga_sum_data[l_zan03,2].field078=l_str END IF
       WHEN  79 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field079=l_sum_name  LET ga_sum_data[l_zan03,2].field079=l_str END IF
       WHEN  80 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field080=l_sum_name  LET ga_sum_data[l_zan03,2].field080=l_str END IF
       WHEN  81 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field081=l_sum_name  LET ga_sum_data[l_zan03,2].field081=l_str END IF
       WHEN  82 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field082=l_sum_name  LET ga_sum_data[l_zan03,2].field082=l_str END IF
       WHEN  83 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field083=l_sum_name  LET ga_sum_data[l_zan03,2].field083=l_str END IF
       WHEN  84 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field084=l_sum_name  LET ga_sum_data[l_zan03,2].field084=l_str END IF
       WHEN  85 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field085=l_sum_name  LET ga_sum_data[l_zan03,2].field085=l_str END IF
       WHEN  86 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field086=l_sum_name  LET ga_sum_data[l_zan03,2].field086=l_str END IF
       WHEN  87 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field087=l_sum_name  LET ga_sum_data[l_zan03,2].field087=l_str END IF
       WHEN  88 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field088=l_sum_name  LET ga_sum_data[l_zan03,2].field088=l_str END IF
       WHEN  89 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field089=l_sum_name  LET ga_sum_data[l_zan03,2].field089=l_str END IF
       WHEN  90 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field090=l_sum_name  LET ga_sum_data[l_zan03,2].field090=l_str END IF
       WHEN  91 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field091=l_sum_name  LET ga_sum_data[l_zan03,2].field091=l_str END IF
       WHEN  92 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field092=l_sum_name  LET ga_sum_data[l_zan03,2].field092=l_str END IF
       WHEN  93 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field093=l_sum_name  LET ga_sum_data[l_zan03,2].field093=l_str END IF
       WHEN  94 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field094=l_sum_name  LET ga_sum_data[l_zan03,2].field094=l_str END IF
       WHEN  95 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field095=l_sum_name  LET ga_sum_data[l_zan03,2].field095=l_str END IF
       WHEN  96 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field096=l_sum_name  LET ga_sum_data[l_zan03,2].field096=l_str END IF
       WHEN  97 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field097=l_sum_name  LET ga_sum_data[l_zan03,2].field097=l_str END IF
       WHEN  98 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field098=l_sum_name  LET ga_sum_data[l_zan03,2].field098=l_str END IF
       WHEN  99 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field099=l_sum_name  LET ga_sum_data[l_zan03,2].field099=l_str END IF
       WHEN 100 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field100=l_sum_name  LET ga_sum_data[l_zan03,2].field100=l_str END IF
      #WHEN 101 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field101=l_sum_name  LET ga_sum_data[l_zan03,2].field101=l_str END IF
      #WHEN 102 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field102=l_sum_name  LET ga_sum_data[l_zan03,2].field102=l_str END IF
      #WHEN 103 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field103=l_sum_name  LET ga_sum_data[l_zan03,2].field103=l_str END IF
      #WHEN 104 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field104=l_sum_name  LET ga_sum_data[l_zan03,2].field104=l_str END IF
      #WHEN 105 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field105=l_sum_name  LET ga_sum_data[l_zan03,2].field105=l_str END IF
      #WHEN 106 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field106=l_sum_name  LET ga_sum_data[l_zan03,2].field106=l_str END IF
      #WHEN 107 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field107=l_sum_name  LET ga_sum_data[l_zan03,2].field107=l_str END IF
      #WHEN 108 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field108=l_sum_name  LET ga_sum_data[l_zan03,2].field108=l_str END IF
      #WHEN 109 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field109=l_sum_name  LET ga_sum_data[l_zan03,2].field109=l_str END IF
      #WHEN 110 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field110=l_sum_name  LET ga_sum_data[l_zan03,2].field110=l_str END IF
      #WHEN 111 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field111=l_sum_name  LET ga_sum_data[l_zan03,2].field111=l_str END IF
      #WHEN 112 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field112=l_sum_name  LET ga_sum_data[l_zan03,2].field112=l_str END IF
      #WHEN 113 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field113=l_sum_name  LET ga_sum_data[l_zan03,2].field113=l_str END IF
      #WHEN 114 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field114=l_sum_name  LET ga_sum_data[l_zan03,2].field114=l_str END IF
      #WHEN 115 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field115=l_sum_name  LET ga_sum_data[l_zan03,2].field115=l_str END IF
      #WHEN 116 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field116=l_sum_name  LET ga_sum_data[l_zan03,2].field116=l_str END IF
      #WHEN 117 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field117=l_sum_name  LET ga_sum_data[l_zan03,2].field117=l_str END IF
      #WHEN 118 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field118=l_sum_name  LET ga_sum_data[l_zan03,2].field118=l_str END IF
      #WHEN 119 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field119=l_sum_name  LET ga_sum_data[l_zan03,2].field119=l_str END IF
      #WHEN 120 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field120=l_sum_name  LET ga_sum_data[l_zan03,2].field120=l_str END IF
      #WHEN 121 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field121=l_sum_name  LET ga_sum_data[l_zan03,2].field121=l_str END IF
      #WHEN 122 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field122=l_sum_name  LET ga_sum_data[l_zan03,2].field122=l_str END IF
      #WHEN 123 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field123=l_sum_name  LET ga_sum_data[l_zan03,2].field123=l_str END IF
      #WHEN 124 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field124=l_sum_name  LET ga_sum_data[l_zan03,2].field124=l_str END IF
      #WHEN 125 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field125=l_sum_name  LET ga_sum_data[l_zan03,2].field125=l_str END IF
      #WHEN 126 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field126=l_sum_name  LET ga_sum_data[l_zan03,2].field126=l_str END IF
      #WHEN 127 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field127=l_sum_name  LET ga_sum_data[l_zan03,2].field127=l_str END IF
      #WHEN 128 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field128=l_sum_name  LET ga_sum_data[l_zan03,2].field128=l_str END IF
      #WHEN 129 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field129=l_sum_name  LET ga_sum_data[l_zan03,2].field129=l_str END IF
      #WHEN 130 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field130=l_sum_name  LET ga_sum_data[l_zan03,2].field130=l_str END IF
      #WHEN 131 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field131=l_sum_name  LET ga_sum_data[l_zan03,2].field131=l_str END IF
      #WHEN 132 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field132=l_sum_name  LET ga_sum_data[l_zan03,2].field132=l_str END IF
      #WHEN 133 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field133=l_sum_name  LET ga_sum_data[l_zan03,2].field133=l_str END IF
      #WHEN 134 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field134=l_sum_name  LET ga_sum_data[l_zan03,2].field134=l_str END IF
      #WHEN 135 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field135=l_sum_name  LET ga_sum_data[l_zan03,2].field135=l_str END IF
      #WHEN 136 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field136=l_sum_name  LET ga_sum_data[l_zan03,2].field136=l_str END IF
      #WHEN 137 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field137=l_sum_name  LET ga_sum_data[l_zan03,2].field137=l_str END IF
      #WHEN 138 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field138=l_sum_name  LET ga_sum_data[l_zan03,2].field138=l_str END IF
      #WHEN 139 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field139=l_sum_name  LET ga_sum_data[l_zan03,2].field139=l_str END IF
      #WHEN 140 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field140=l_sum_name  LET ga_sum_data[l_zan03,2].field140=l_str END IF
      #WHEN 141 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field141=l_sum_name  LET ga_sum_data[l_zan03,2].field141=l_str END IF
      #WHEN 142 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field142=l_sum_name  LET ga_sum_data[l_zan03,2].field142=l_str END IF
      #WHEN 143 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field143=l_sum_name  LET ga_sum_data[l_zan03,2].field143=l_str END IF
      #WHEN 144 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field144=l_sum_name  LET ga_sum_data[l_zan03,2].field144=l_str END IF
      #WHEN 145 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field145=l_sum_name  LET ga_sum_data[l_zan03,2].field145=l_str END IF
      #WHEN 146 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field146=l_sum_name  LET ga_sum_data[l_zan03,2].field146=l_str END IF
      #WHEN 147 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field147=l_sum_name  LET ga_sum_data[l_zan03,2].field147=l_str END IF
      #WHEN 148 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field148=l_sum_name  LET ga_sum_data[l_zan03,2].field148=l_str END IF
      #WHEN 149 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field149=l_sum_name  LET ga_sum_data[l_zan03,2].field149=l_str END IF
      #WHEN 150 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field150=l_sum_name  LET ga_sum_data[l_zan03,2].field150=l_str END IF
      #WHEN 151 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field151=l_sum_name  LET ga_sum_data[l_zan03,2].field151=l_str END IF
      #WHEN 152 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field152=l_sum_name  LET ga_sum_data[l_zan03,2].field152=l_str END IF
      #WHEN 153 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field153=l_sum_name  LET ga_sum_data[l_zan03,2].field153=l_str END IF
      #WHEN 154 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field154=l_sum_name  LET ga_sum_data[l_zan03,2].field154=l_str END IF
      #WHEN 155 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field155=l_sum_name  LET ga_sum_data[l_zan03,2].field155=l_str END IF
      #WHEN 156 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field156=l_sum_name  LET ga_sum_data[l_zan03,2].field156=l_str END IF
      #WHEN 157 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field157=l_sum_name  LET ga_sum_data[l_zan03,2].field157=l_str END IF
      #WHEN 158 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field158=l_sum_name  LET ga_sum_data[l_zan03,2].field158=l_str END IF
      #WHEN 159 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field159=l_sum_name  LET ga_sum_data[l_zan03,2].field159=l_str END IF
      #WHEN 160 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field160=l_sum_name  LET ga_sum_data[l_zan03,2].field160=l_str END IF
      #WHEN 161 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field161=l_sum_name  LET ga_sum_data[l_zan03,2].field161=l_str END IF
      #WHEN 162 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field162=l_sum_name  LET ga_sum_data[l_zan03,2].field162=l_str END IF
      #WHEN 163 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field163=l_sum_name  LET ga_sum_data[l_zan03,2].field163=l_str END IF
      #WHEN 164 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field164=l_sum_name  LET ga_sum_data[l_zan03,2].field164=l_str END IF
      #WHEN 165 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field165=l_sum_name  LET ga_sum_data[l_zan03,2].field165=l_str END IF
      #WHEN 166 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field166=l_sum_name  LET ga_sum_data[l_zan03,2].field166=l_str END IF
      #WHEN 167 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field167=l_sum_name  LET ga_sum_data[l_zan03,2].field167=l_str END IF
      #WHEN 168 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field168=l_sum_name  LET ga_sum_data[l_zan03,2].field168=l_str END IF
      #WHEN 169 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field169=l_sum_name  LET ga_sum_data[l_zan03,2].field169=l_str END IF
      #WHEN 170 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field170=l_sum_name  LET ga_sum_data[l_zan03,2].field170=l_str END IF
      #WHEN 171 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field171=l_sum_name  LET ga_sum_data[l_zan03,2].field171=l_str END IF
      #WHEN 172 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field172=l_sum_name  LET ga_sum_data[l_zan03,2].field172=l_str END IF
      #WHEN 173 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field173=l_sum_name  LET ga_sum_data[l_zan03,2].field173=l_str END IF
      #WHEN 174 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field174=l_sum_name  LET ga_sum_data[l_zan03,2].field174=l_str END IF
      #WHEN 175 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field175=l_sum_name  LET ga_sum_data[l_zan03,2].field175=l_str END IF
      #WHEN 176 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field176=l_sum_name  LET ga_sum_data[l_zan03,2].field176=l_str END IF
      #WHEN 177 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field177=l_sum_name  LET ga_sum_data[l_zan03,2].field177=l_str END IF
      #WHEN 178 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field178=l_sum_name  LET ga_sum_data[l_zan03,2].field178=l_str END IF
      #WHEN 179 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field179=l_sum_name  LET ga_sum_data[l_zan03,2].field179=l_str END IF
      #WHEN 180 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field180=l_sum_name  LET ga_sum_data[l_zan03,2].field180=l_str END IF
      #WHEN 181 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field181=l_sum_name  LET ga_sum_data[l_zan03,2].field181=l_str END IF
      #WHEN 182 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field182=l_sum_name  LET ga_sum_data[l_zan03,2].field182=l_str END IF
      #WHEN 183 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field183=l_sum_name  LET ga_sum_data[l_zan03,2].field183=l_str END IF
      #WHEN 184 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field184=l_sum_name  LET ga_sum_data[l_zan03,2].field184=l_str END IF
      #WHEN 185 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field185=l_sum_name  LET ga_sum_data[l_zan03,2].field185=l_str END IF
      #WHEN 186 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field186=l_sum_name  LET ga_sum_data[l_zan03,2].field186=l_str END IF
      #WHEN 187 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field187=l_sum_name  LET ga_sum_data[l_zan03,2].field187=l_str END IF
      #WHEN 188 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field188=l_sum_name  LET ga_sum_data[l_zan03,2].field188=l_str END IF
      #WHEN 189 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field189=l_sum_name  LET ga_sum_data[l_zan03,2].field189=l_str END IF
      #WHEN 190 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field190=l_sum_name  LET ga_sum_data[l_zan03,2].field190=l_str END IF
      #WHEN 191 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field191=l_sum_name  LET ga_sum_data[l_zan03,2].field191=l_str END IF
      #WHEN 192 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field192=l_sum_name  LET ga_sum_data[l_zan03,2].field192=l_str END IF
      #WHEN 193 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field193=l_sum_name  LET ga_sum_data[l_zan03,2].field193=l_str END IF
      #WHEN 194 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field194=l_sum_name  LET ga_sum_data[l_zan03,2].field194=l_str END IF
      #WHEN 195 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field195=l_sum_name  LET ga_sum_data[l_zan03,2].field195=l_str END IF
      #WHEN 196 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field196=l_sum_name  LET ga_sum_data[l_zan03,2].field196=l_str END IF
      #WHEN 197 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field197=l_sum_name  LET ga_sum_data[l_zan03,2].field197=l_str END IF
      #WHEN 198 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field198=l_sum_name  LET ga_sum_data[l_zan03,2].field198=l_str END IF
      #WHEN 199 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field199=l_sum_name  LET ga_sum_data[l_zan03,2].field199=l_str END IF
      #WHEN 200 CALL cl_query_sum_check(p_k,p_i) RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name IF l_status THEN LET ga_sum_data[l_zan03,1].field200=l_sum_name  LET ga_sum_data[l_zan03,2].field200=l_str END IF
     END CASE
     IF (g_data_end = 0) OR (g_data_end_total = 1 ) THEN
          EXIT WHILE
     ELSE
         IF l_zan03_type NOT MATCHES "[CF]" OR l_zan03_type IS NULL 
         OR g_max_tag = 1      
         THEN
            EXIT WHILE
         END IF
     END IF
     LET g_data_end_total = 1
   END WHILE
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 處理型態為日期的欄位格式
# Date & Author..:
# Input Parameter: p_k,p_i
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_value(p_k,p_i)
DEFINE p_k       LIKE type_file.num10       #目前check的欄位
DEFINE p_i       LIKE type_file.num10       #目前check的筆數
DEFINE l_date    STRING                                        #MOD-910058
 
   #No.MOD-910058 -- start --
   #No.TQC-790154
   IF g_qry_feld_type[p_k] = 'date' THEN
      #TQC-810053
      CASE p_k 
       WHEN   1 LET l_date = ga_table_data[p_i].field001  LET ga_table_data[p_i].field001 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN   2 LET l_date = ga_table_data[p_i].field002  LET ga_table_data[p_i].field002 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN   3 LET l_date = ga_table_data[p_i].field003  LET ga_table_data[p_i].field003 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN   4 LET l_date = ga_table_data[p_i].field004  LET ga_table_data[p_i].field004 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN   5 LET l_date = ga_table_data[p_i].field005  LET ga_table_data[p_i].field005 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN   6 LET l_date = ga_table_data[p_i].field006  LET ga_table_data[p_i].field006 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN   7 LET l_date = ga_table_data[p_i].field007  LET ga_table_data[p_i].field007 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN   8 LET l_date = ga_table_data[p_i].field008  LET ga_table_data[p_i].field008 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN   9 LET l_date = ga_table_data[p_i].field009  LET ga_table_data[p_i].field009 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  10 LET l_date = ga_table_data[p_i].field010  LET ga_table_data[p_i].field010 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  11 LET l_date = ga_table_data[p_i].field011  LET ga_table_data[p_i].field011 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  12 LET l_date = ga_table_data[p_i].field012  LET ga_table_data[p_i].field012 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  13 LET l_date = ga_table_data[p_i].field013  LET ga_table_data[p_i].field013 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  14 LET l_date = ga_table_data[p_i].field014  LET ga_table_data[p_i].field014 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  15 LET l_date = ga_table_data[p_i].field015  LET ga_table_data[p_i].field015 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  16 LET l_date = ga_table_data[p_i].field016  LET ga_table_data[p_i].field016 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  17 LET l_date = ga_table_data[p_i].field017  LET ga_table_data[p_i].field017 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  18 LET l_date = ga_table_data[p_i].field018  LET ga_table_data[p_i].field018 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  19 LET l_date = ga_table_data[p_i].field019  LET ga_table_data[p_i].field019 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  20 LET l_date = ga_table_data[p_i].field020  LET ga_table_data[p_i].field020 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  21 LET l_date = ga_table_data[p_i].field021  LET ga_table_data[p_i].field021 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  22 LET l_date = ga_table_data[p_i].field022  LET ga_table_data[p_i].field022 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  23 LET l_date = ga_table_data[p_i].field023  LET ga_table_data[p_i].field023 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  24 LET l_date = ga_table_data[p_i].field024  LET ga_table_data[p_i].field024 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  25 LET l_date = ga_table_data[p_i].field025  LET ga_table_data[p_i].field025 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  26 LET l_date = ga_table_data[p_i].field026  LET ga_table_data[p_i].field026 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  27 LET l_date = ga_table_data[p_i].field027  LET ga_table_data[p_i].field027 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  28 LET l_date = ga_table_data[p_i].field028  LET ga_table_data[p_i].field028 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  29 LET l_date = ga_table_data[p_i].field029  LET ga_table_data[p_i].field029 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  30 LET l_date = ga_table_data[p_i].field030  LET ga_table_data[p_i].field030 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  31 LET l_date = ga_table_data[p_i].field031  LET ga_table_data[p_i].field031 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  32 LET l_date = ga_table_data[p_i].field032  LET ga_table_data[p_i].field032 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  33 LET l_date = ga_table_data[p_i].field033  LET ga_table_data[p_i].field033 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  34 LET l_date = ga_table_data[p_i].field034  LET ga_table_data[p_i].field034 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  35 LET l_date = ga_table_data[p_i].field035  LET ga_table_data[p_i].field035 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  36 LET l_date = ga_table_data[p_i].field036  LET ga_table_data[p_i].field036 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  37 LET l_date = ga_table_data[p_i].field037  LET ga_table_data[p_i].field037 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  38 LET l_date = ga_table_data[p_i].field038  LET ga_table_data[p_i].field038 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  39 LET l_date = ga_table_data[p_i].field039  LET ga_table_data[p_i].field039 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  40 LET l_date = ga_table_data[p_i].field040  LET ga_table_data[p_i].field040 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  41 LET l_date = ga_table_data[p_i].field041  LET ga_table_data[p_i].field041 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  42 LET l_date = ga_table_data[p_i].field042  LET ga_table_data[p_i].field042 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  43 LET l_date = ga_table_data[p_i].field043  LET ga_table_data[p_i].field043 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  44 LET l_date = ga_table_data[p_i].field044  LET ga_table_data[p_i].field044 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  45 LET l_date = ga_table_data[p_i].field045  LET ga_table_data[p_i].field045 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  46 LET l_date = ga_table_data[p_i].field046  LET ga_table_data[p_i].field046 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  47 LET l_date = ga_table_data[p_i].field047  LET ga_table_data[p_i].field047 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  48 LET l_date = ga_table_data[p_i].field048  LET ga_table_data[p_i].field048 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  49 LET l_date = ga_table_data[p_i].field049  LET ga_table_data[p_i].field049 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  50 LET l_date = ga_table_data[p_i].field050  LET ga_table_data[p_i].field050 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  51 LET l_date = ga_table_data[p_i].field051  LET ga_table_data[p_i].field051 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  52 LET l_date = ga_table_data[p_i].field052  LET ga_table_data[p_i].field052 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  53 LET l_date = ga_table_data[p_i].field053  LET ga_table_data[p_i].field053 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  54 LET l_date = ga_table_data[p_i].field054  LET ga_table_data[p_i].field054 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  55 LET l_date = ga_table_data[p_i].field055  LET ga_table_data[p_i].field055 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  56 LET l_date = ga_table_data[p_i].field056  LET ga_table_data[p_i].field056 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  57 LET l_date = ga_table_data[p_i].field057  LET ga_table_data[p_i].field057 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  58 LET l_date = ga_table_data[p_i].field058  LET ga_table_data[p_i].field058 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  59 LET l_date = ga_table_data[p_i].field059  LET ga_table_data[p_i].field059 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  60 LET l_date = ga_table_data[p_i].field060  LET ga_table_data[p_i].field060 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  61 LET l_date = ga_table_data[p_i].field061  LET ga_table_data[p_i].field061 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  62 LET l_date = ga_table_data[p_i].field062  LET ga_table_data[p_i].field062 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  63 LET l_date = ga_table_data[p_i].field063  LET ga_table_data[p_i].field063 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  64 LET l_date = ga_table_data[p_i].field064  LET ga_table_data[p_i].field064 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  65 LET l_date = ga_table_data[p_i].field065  LET ga_table_data[p_i].field065 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  66 LET l_date = ga_table_data[p_i].field066  LET ga_table_data[p_i].field066 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  67 LET l_date = ga_table_data[p_i].field067  LET ga_table_data[p_i].field067 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  68 LET l_date = ga_table_data[p_i].field068  LET ga_table_data[p_i].field068 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  69 LET l_date = ga_table_data[p_i].field069  LET ga_table_data[p_i].field069 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  70 LET l_date = ga_table_data[p_i].field070  LET ga_table_data[p_i].field070 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  71 LET l_date = ga_table_data[p_i].field071  LET ga_table_data[p_i].field071 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  72 LET l_date = ga_table_data[p_i].field072  LET ga_table_data[p_i].field072 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  73 LET l_date = ga_table_data[p_i].field073  LET ga_table_data[p_i].field073 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  74 LET l_date = ga_table_data[p_i].field074  LET ga_table_data[p_i].field074 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  75 LET l_date = ga_table_data[p_i].field075  LET ga_table_data[p_i].field075 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  76 LET l_date = ga_table_data[p_i].field076  LET ga_table_data[p_i].field076 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  77 LET l_date = ga_table_data[p_i].field077  LET ga_table_data[p_i].field077 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  78 LET l_date = ga_table_data[p_i].field078  LET ga_table_data[p_i].field078 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  79 LET l_date = ga_table_data[p_i].field079  LET ga_table_data[p_i].field079 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  80 LET l_date = ga_table_data[p_i].field080  LET ga_table_data[p_i].field080 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  81 LET l_date = ga_table_data[p_i].field081  LET ga_table_data[p_i].field081 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  82 LET l_date = ga_table_data[p_i].field082  LET ga_table_data[p_i].field082 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  83 LET l_date = ga_table_data[p_i].field083  LET ga_table_data[p_i].field083 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  84 LET l_date = ga_table_data[p_i].field084  LET ga_table_data[p_i].field084 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  85 LET l_date = ga_table_data[p_i].field085  LET ga_table_data[p_i].field085 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  86 LET l_date = ga_table_data[p_i].field086  LET ga_table_data[p_i].field086 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  87 LET l_date = ga_table_data[p_i].field087  LET ga_table_data[p_i].field087 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  88 LET l_date = ga_table_data[p_i].field088  LET ga_table_data[p_i].field088 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  89 LET l_date = ga_table_data[p_i].field089  LET ga_table_data[p_i].field089 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  90 LET l_date = ga_table_data[p_i].field090  LET ga_table_data[p_i].field090 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  91 LET l_date = ga_table_data[p_i].field091  LET ga_table_data[p_i].field091 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  92 LET l_date = ga_table_data[p_i].field092  LET ga_table_data[p_i].field092 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  93 LET l_date = ga_table_data[p_i].field093  LET ga_table_data[p_i].field093 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  94 LET l_date = ga_table_data[p_i].field094  LET ga_table_data[p_i].field094 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  95 LET l_date = ga_table_data[p_i].field095  LET ga_table_data[p_i].field095 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  96 LET l_date = ga_table_data[p_i].field096  LET ga_table_data[p_i].field096 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  97 LET l_date = ga_table_data[p_i].field097  LET ga_table_data[p_i].field097 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  98 LET l_date = ga_table_data[p_i].field098  LET ga_table_data[p_i].field098 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN  99 LET l_date = ga_table_data[p_i].field099  LET ga_table_data[p_i].field099 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
       WHEN 100 LET l_date = ga_table_data[p_i].field100  LET ga_table_data[p_i].field100 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 101 LET l_date = ga_table_data[p_i].field101  LET ga_table_data[p_i].field101 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 102 LET l_date = ga_table_data[p_i].field102  LET ga_table_data[p_i].field102 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 103 LET l_date = ga_table_data[p_i].field103  LET ga_table_data[p_i].field103 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 104 LET l_date = ga_table_data[p_i].field104  LET ga_table_data[p_i].field104 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 105 LET l_date = ga_table_data[p_i].field105  LET ga_table_data[p_i].field105 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 106 LET l_date = ga_table_data[p_i].field106  LET ga_table_data[p_i].field106 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 107 LET l_date = ga_table_data[p_i].field107  LET ga_table_data[p_i].field107 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 108 LET l_date = ga_table_data[p_i].field108  LET ga_table_data[p_i].field108 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 109 LET l_date = ga_table_data[p_i].field109  LET ga_table_data[p_i].field109 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 110 LET l_date = ga_table_data[p_i].field110  LET ga_table_data[p_i].field110 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 111 LET l_date = ga_table_data[p_i].field111  LET ga_table_data[p_i].field111 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 112 LET l_date = ga_table_data[p_i].field112  LET ga_table_data[p_i].field112 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 113 LET l_date = ga_table_data[p_i].field113  LET ga_table_data[p_i].field113 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 114 LET l_date = ga_table_data[p_i].field114  LET ga_table_data[p_i].field114 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 115 LET l_date = ga_table_data[p_i].field115  LET ga_table_data[p_i].field115 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 116 LET l_date = ga_table_data[p_i].field116  LET ga_table_data[p_i].field116 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 117 LET l_date = ga_table_data[p_i].field117  LET ga_table_data[p_i].field117 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 118 LET l_date = ga_table_data[p_i].field118  LET ga_table_data[p_i].field118 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 119 LET l_date = ga_table_data[p_i].field119  LET ga_table_data[p_i].field119 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 120 LET l_date = ga_table_data[p_i].field120  LET ga_table_data[p_i].field120 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 121 LET l_date = ga_table_data[p_i].field121  LET ga_table_data[p_i].field121 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 122 LET l_date = ga_table_data[p_i].field122  LET ga_table_data[p_i].field122 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 123 LET l_date = ga_table_data[p_i].field123  LET ga_table_data[p_i].field123 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 124 LET l_date = ga_table_data[p_i].field124  LET ga_table_data[p_i].field124 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 125 LET l_date = ga_table_data[p_i].field125  LET ga_table_data[p_i].field125 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 126 LET l_date = ga_table_data[p_i].field126  LET ga_table_data[p_i].field126 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 127 LET l_date = ga_table_data[p_i].field127  LET ga_table_data[p_i].field127 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 128 LET l_date = ga_table_data[p_i].field128  LET ga_table_data[p_i].field128 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 129 LET l_date = ga_table_data[p_i].field129  LET ga_table_data[p_i].field129 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 130 LET l_date = ga_table_data[p_i].field130  LET ga_table_data[p_i].field130 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 131 LET l_date = ga_table_data[p_i].field131  LET ga_table_data[p_i].field131 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 132 LET l_date = ga_table_data[p_i].field132  LET ga_table_data[p_i].field132 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 133 LET l_date = ga_table_data[p_i].field133  LET ga_table_data[p_i].field133 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 134 LET l_date = ga_table_data[p_i].field134  LET ga_table_data[p_i].field134 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 135 LET l_date = ga_table_data[p_i].field135  LET ga_table_data[p_i].field135 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 136 LET l_date = ga_table_data[p_i].field136  LET ga_table_data[p_i].field136 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 137 LET l_date = ga_table_data[p_i].field137  LET ga_table_data[p_i].field137 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 138 LET l_date = ga_table_data[p_i].field138  LET ga_table_data[p_i].field138 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 139 LET l_date = ga_table_data[p_i].field139  LET ga_table_data[p_i].field139 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 140 LET l_date = ga_table_data[p_i].field140  LET ga_table_data[p_i].field140 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 141 LET l_date = ga_table_data[p_i].field141  LET ga_table_data[p_i].field141 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 142 LET l_date = ga_table_data[p_i].field142  LET ga_table_data[p_i].field142 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 143 LET l_date = ga_table_data[p_i].field143  LET ga_table_data[p_i].field143 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 144 LET l_date = ga_table_data[p_i].field144  LET ga_table_data[p_i].field144 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 145 LET l_date = ga_table_data[p_i].field145  LET ga_table_data[p_i].field145 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 146 LET l_date = ga_table_data[p_i].field146  LET ga_table_data[p_i].field146 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 147 LET l_date = ga_table_data[p_i].field147  LET ga_table_data[p_i].field147 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 148 LET l_date = ga_table_data[p_i].field148  LET ga_table_data[p_i].field148 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 149 LET l_date = ga_table_data[p_i].field149  LET ga_table_data[p_i].field149 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 150 LET l_date = ga_table_data[p_i].field150  LET ga_table_data[p_i].field150 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 151 LET l_date = ga_table_data[p_i].field151  LET ga_table_data[p_i].field151 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 152 LET l_date = ga_table_data[p_i].field152  LET ga_table_data[p_i].field152 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 153 LET l_date = ga_table_data[p_i].field153  LET ga_table_data[p_i].field153 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 154 LET l_date = ga_table_data[p_i].field154  LET ga_table_data[p_i].field154 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 155 LET l_date = ga_table_data[p_i].field155  LET ga_table_data[p_i].field155 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 156 LET l_date = ga_table_data[p_i].field156  LET ga_table_data[p_i].field156 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 157 LET l_date = ga_table_data[p_i].field157  LET ga_table_data[p_i].field157 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 158 LET l_date = ga_table_data[p_i].field158  LET ga_table_data[p_i].field158 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 159 LET l_date = ga_table_data[p_i].field159  LET ga_table_data[p_i].field159 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 160 LET l_date = ga_table_data[p_i].field160  LET ga_table_data[p_i].field160 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 161 LET l_date = ga_table_data[p_i].field161  LET ga_table_data[p_i].field161 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 162 LET l_date = ga_table_data[p_i].field162  LET ga_table_data[p_i].field162 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 163 LET l_date = ga_table_data[p_i].field163  LET ga_table_data[p_i].field163 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 164 LET l_date = ga_table_data[p_i].field164  LET ga_table_data[p_i].field164 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 165 LET l_date = ga_table_data[p_i].field165  LET ga_table_data[p_i].field165 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 166 LET l_date = ga_table_data[p_i].field166  LET ga_table_data[p_i].field166 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 167 LET l_date = ga_table_data[p_i].field167  LET ga_table_data[p_i].field167 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 168 LET l_date = ga_table_data[p_i].field168  LET ga_table_data[p_i].field168 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 169 LET l_date = ga_table_data[p_i].field169  LET ga_table_data[p_i].field169 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 170 LET l_date = ga_table_data[p_i].field170  LET ga_table_data[p_i].field170 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 171 LET l_date = ga_table_data[p_i].field171  LET ga_table_data[p_i].field171 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 172 LET l_date = ga_table_data[p_i].field172  LET ga_table_data[p_i].field172 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 173 LET l_date = ga_table_data[p_i].field173  LET ga_table_data[p_i].field173 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 174 LET l_date = ga_table_data[p_i].field174  LET ga_table_data[p_i].field174 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 175 LET l_date = ga_table_data[p_i].field175  LET ga_table_data[p_i].field175 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 176 LET l_date = ga_table_data[p_i].field176  LET ga_table_data[p_i].field176 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 177 LET l_date = ga_table_data[p_i].field177  LET ga_table_data[p_i].field177 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 178 LET l_date = ga_table_data[p_i].field178  LET ga_table_data[p_i].field178 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 179 LET l_date = ga_table_data[p_i].field179  LET ga_table_data[p_i].field179 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 180 LET l_date = ga_table_data[p_i].field180  LET ga_table_data[p_i].field180 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 181 LET l_date = ga_table_data[p_i].field181  LET ga_table_data[p_i].field181 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 182 LET l_date = ga_table_data[p_i].field182  LET ga_table_data[p_i].field182 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 183 LET l_date = ga_table_data[p_i].field183  LET ga_table_data[p_i].field183 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 184 LET l_date = ga_table_data[p_i].field184  LET ga_table_data[p_i].field184 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 185 LET l_date = ga_table_data[p_i].field185  LET ga_table_data[p_i].field185 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 186 LET l_date = ga_table_data[p_i].field186  LET ga_table_data[p_i].field186 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 187 LET l_date = ga_table_data[p_i].field187  LET ga_table_data[p_i].field187 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 188 LET l_date = ga_table_data[p_i].field188  LET ga_table_data[p_i].field188 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 189 LET l_date = ga_table_data[p_i].field189  LET ga_table_data[p_i].field189 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 190 LET l_date = ga_table_data[p_i].field190  LET ga_table_data[p_i].field190 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 191 LET l_date = ga_table_data[p_i].field191  LET ga_table_data[p_i].field191 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 192 LET l_date = ga_table_data[p_i].field192  LET ga_table_data[p_i].field192 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 193 LET l_date = ga_table_data[p_i].field193  LET ga_table_data[p_i].field193 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 194 LET l_date = ga_table_data[p_i].field194  LET ga_table_data[p_i].field194 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 195 LET l_date = ga_table_data[p_i].field195  LET ga_table_data[p_i].field195 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 196 LET l_date = ga_table_data[p_i].field196  LET ga_table_data[p_i].field196 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 197 LET l_date = ga_table_data[p_i].field197  LET ga_table_data[p_i].field197 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 198 LET l_date = ga_table_data[p_i].field198  LET ga_table_data[p_i].field198 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 199 LET l_date = ga_table_data[p_i].field199  LET ga_table_data[p_i].field199 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
      #WHEN 200 LET l_date = ga_table_data[p_i].field200  LET ga_table_data[p_i].field200 = MDY(l_date.subString(6,7),l_date.subString(9,10),l_date.subString(1,4))
     END CASE
   END IF
   #No.MOD-910058 -- end --
 
   #END No.TQC-790154
   #將日期依指定的列印長度做 FORMAT
   CASE p_k 
    WHEN   1 IF FGL_WIDTH(ga_table_data[p_i].field001 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field001 = ga_table_data[p_i].field001.subString(1,g_qry_length[p_k]) END IF 
    WHEN   2 IF FGL_WIDTH(ga_table_data[p_i].field002 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field002 = ga_table_data[p_i].field002.subString(1,g_qry_length[p_k]) END IF 
    WHEN   3 IF FGL_WIDTH(ga_table_data[p_i].field003 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field003 = ga_table_data[p_i].field003.subString(1,g_qry_length[p_k]) END IF 
    WHEN   4 IF FGL_WIDTH(ga_table_data[p_i].field004 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field004 = ga_table_data[p_i].field004.subString(1,g_qry_length[p_k]) END IF 
    WHEN   5 IF FGL_WIDTH(ga_table_data[p_i].field005 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field005 = ga_table_data[p_i].field005.subString(1,g_qry_length[p_k]) END IF 
    WHEN   6 IF FGL_WIDTH(ga_table_data[p_i].field006 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field006 = ga_table_data[p_i].field006.subString(1,g_qry_length[p_k]) END IF 
    WHEN   7 IF FGL_WIDTH(ga_table_data[p_i].field007 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field007 = ga_table_data[p_i].field007.subString(1,g_qry_length[p_k]) END IF 
    WHEN   8 IF FGL_WIDTH(ga_table_data[p_i].field008 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field008 = ga_table_data[p_i].field008.subString(1,g_qry_length[p_k]) END IF 
    WHEN   9 IF FGL_WIDTH(ga_table_data[p_i].field009 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field009 = ga_table_data[p_i].field009.subString(1,g_qry_length[p_k]) END IF 
    WHEN  10 IF FGL_WIDTH(ga_table_data[p_i].field010 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field010 = ga_table_data[p_i].field010.subString(1,g_qry_length[p_k]) END IF 
    WHEN  11 IF FGL_WIDTH(ga_table_data[p_i].field011 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field011 = ga_table_data[p_i].field011.subString(1,g_qry_length[p_k]) END IF 
    WHEN  12 IF FGL_WIDTH(ga_table_data[p_i].field012 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field012 = ga_table_data[p_i].field012.subString(1,g_qry_length[p_k]) END IF 
    WHEN  13 IF FGL_WIDTH(ga_table_data[p_i].field013 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field013 = ga_table_data[p_i].field013.subString(1,g_qry_length[p_k]) END IF 
    WHEN  14 IF FGL_WIDTH(ga_table_data[p_i].field014 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field014 = ga_table_data[p_i].field014.subString(1,g_qry_length[p_k]) END IF 
    WHEN  15 IF FGL_WIDTH(ga_table_data[p_i].field015 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field015 = ga_table_data[p_i].field015.subString(1,g_qry_length[p_k]) END IF 
    WHEN  16 IF FGL_WIDTH(ga_table_data[p_i].field016 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field016 = ga_table_data[p_i].field016.subString(1,g_qry_length[p_k]) END IF 
    WHEN  17 IF FGL_WIDTH(ga_table_data[p_i].field017 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field017 = ga_table_data[p_i].field017.subString(1,g_qry_length[p_k]) END IF 
    WHEN  18 IF FGL_WIDTH(ga_table_data[p_i].field018 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field018 = ga_table_data[p_i].field018.subString(1,g_qry_length[p_k]) END IF 
    WHEN  19 IF FGL_WIDTH(ga_table_data[p_i].field019 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field019 = ga_table_data[p_i].field019.subString(1,g_qry_length[p_k]) END IF 
    WHEN  20 IF FGL_WIDTH(ga_table_data[p_i].field020 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field020 = ga_table_data[p_i].field020.subString(1,g_qry_length[p_k]) END IF 
    WHEN  21 IF FGL_WIDTH(ga_table_data[p_i].field021 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field021 = ga_table_data[p_i].field021.subString(1,g_qry_length[p_k]) END IF 
    WHEN  22 IF FGL_WIDTH(ga_table_data[p_i].field022 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field022 = ga_table_data[p_i].field022.subString(1,g_qry_length[p_k]) END IF 
    WHEN  23 IF FGL_WIDTH(ga_table_data[p_i].field023 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field023 = ga_table_data[p_i].field023.subString(1,g_qry_length[p_k]) END IF 
    WHEN  24 IF FGL_WIDTH(ga_table_data[p_i].field024 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field024 = ga_table_data[p_i].field024.subString(1,g_qry_length[p_k]) END IF 
    WHEN  25 IF FGL_WIDTH(ga_table_data[p_i].field025 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field025 = ga_table_data[p_i].field025.subString(1,g_qry_length[p_k]) END IF 
    WHEN  26 IF FGL_WIDTH(ga_table_data[p_i].field026 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field026 = ga_table_data[p_i].field026.subString(1,g_qry_length[p_k]) END IF 
    WHEN  27 IF FGL_WIDTH(ga_table_data[p_i].field027 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field027 = ga_table_data[p_i].field027.subString(1,g_qry_length[p_k]) END IF 
    WHEN  28 IF FGL_WIDTH(ga_table_data[p_i].field028 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field028 = ga_table_data[p_i].field028.subString(1,g_qry_length[p_k]) END IF 
    WHEN  29 IF FGL_WIDTH(ga_table_data[p_i].field029 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field029 = ga_table_data[p_i].field029.subString(1,g_qry_length[p_k]) END IF 
    WHEN  30 IF FGL_WIDTH(ga_table_data[p_i].field030 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field030 = ga_table_data[p_i].field030.subString(1,g_qry_length[p_k]) END IF 
    WHEN  31 IF FGL_WIDTH(ga_table_data[p_i].field031 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field031 = ga_table_data[p_i].field031.subString(1,g_qry_length[p_k]) END IF 
    WHEN  32 IF FGL_WIDTH(ga_table_data[p_i].field032 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field032 = ga_table_data[p_i].field032.subString(1,g_qry_length[p_k]) END IF 
    WHEN  33 IF FGL_WIDTH(ga_table_data[p_i].field033 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field033 = ga_table_data[p_i].field033.subString(1,g_qry_length[p_k]) END IF 
    WHEN  34 IF FGL_WIDTH(ga_table_data[p_i].field034 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field034 = ga_table_data[p_i].field034.subString(1,g_qry_length[p_k]) END IF 
    WHEN  35 IF FGL_WIDTH(ga_table_data[p_i].field035 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field035 = ga_table_data[p_i].field035.subString(1,g_qry_length[p_k]) END IF 
    WHEN  36 IF FGL_WIDTH(ga_table_data[p_i].field036 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field036 = ga_table_data[p_i].field036.subString(1,g_qry_length[p_k]) END IF 
    WHEN  37 IF FGL_WIDTH(ga_table_data[p_i].field037 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field037 = ga_table_data[p_i].field037.subString(1,g_qry_length[p_k]) END IF 
    WHEN  38 IF FGL_WIDTH(ga_table_data[p_i].field038 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field038 = ga_table_data[p_i].field038.subString(1,g_qry_length[p_k]) END IF 
    WHEN  39 IF FGL_WIDTH(ga_table_data[p_i].field039 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field039 = ga_table_data[p_i].field039.subString(1,g_qry_length[p_k]) END IF 
    WHEN  40 IF FGL_WIDTH(ga_table_data[p_i].field040 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field040 = ga_table_data[p_i].field040.subString(1,g_qry_length[p_k]) END IF 
    WHEN  41 IF FGL_WIDTH(ga_table_data[p_i].field041 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field041 = ga_table_data[p_i].field041.subString(1,g_qry_length[p_k]) END IF 
    WHEN  42 IF FGL_WIDTH(ga_table_data[p_i].field042 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field042 = ga_table_data[p_i].field042.subString(1,g_qry_length[p_k]) END IF 
    WHEN  43 IF FGL_WIDTH(ga_table_data[p_i].field043 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field043 = ga_table_data[p_i].field043.subString(1,g_qry_length[p_k]) END IF 
    WHEN  44 IF FGL_WIDTH(ga_table_data[p_i].field044 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field044 = ga_table_data[p_i].field044.subString(1,g_qry_length[p_k]) END IF 
    WHEN  45 IF FGL_WIDTH(ga_table_data[p_i].field045 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field045 = ga_table_data[p_i].field045.subString(1,g_qry_length[p_k]) END IF 
    WHEN  46 IF FGL_WIDTH(ga_table_data[p_i].field046 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field046 = ga_table_data[p_i].field046.subString(1,g_qry_length[p_k]) END IF 
    WHEN  47 IF FGL_WIDTH(ga_table_data[p_i].field047 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field047 = ga_table_data[p_i].field047.subString(1,g_qry_length[p_k]) END IF 
    WHEN  48 IF FGL_WIDTH(ga_table_data[p_i].field048 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field048 = ga_table_data[p_i].field048.subString(1,g_qry_length[p_k]) END IF 
    WHEN  49 IF FGL_WIDTH(ga_table_data[p_i].field049 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field049 = ga_table_data[p_i].field049.subString(1,g_qry_length[p_k]) END IF 
    WHEN  50 IF FGL_WIDTH(ga_table_data[p_i].field050 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field050 = ga_table_data[p_i].field050.subString(1,g_qry_length[p_k]) END IF 
    WHEN  51 IF FGL_WIDTH(ga_table_data[p_i].field051 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field051 = ga_table_data[p_i].field051.subString(1,g_qry_length[p_k]) END IF 
    WHEN  52 IF FGL_WIDTH(ga_table_data[p_i].field052 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field052 = ga_table_data[p_i].field052.subString(1,g_qry_length[p_k]) END IF 
    WHEN  53 IF FGL_WIDTH(ga_table_data[p_i].field053 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field053 = ga_table_data[p_i].field053.subString(1,g_qry_length[p_k]) END IF 
    WHEN  54 IF FGL_WIDTH(ga_table_data[p_i].field054 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field054 = ga_table_data[p_i].field054.subString(1,g_qry_length[p_k]) END IF 
    WHEN  55 IF FGL_WIDTH(ga_table_data[p_i].field055 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field055 = ga_table_data[p_i].field055.subString(1,g_qry_length[p_k]) END IF 
    WHEN  56 IF FGL_WIDTH(ga_table_data[p_i].field056 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field056 = ga_table_data[p_i].field056.subString(1,g_qry_length[p_k]) END IF 
    WHEN  57 IF FGL_WIDTH(ga_table_data[p_i].field057 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field057 = ga_table_data[p_i].field057.subString(1,g_qry_length[p_k]) END IF 
    WHEN  58 IF FGL_WIDTH(ga_table_data[p_i].field058 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field058 = ga_table_data[p_i].field058.subString(1,g_qry_length[p_k]) END IF 
    WHEN  59 IF FGL_WIDTH(ga_table_data[p_i].field059 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field059 = ga_table_data[p_i].field059.subString(1,g_qry_length[p_k]) END IF 
    WHEN  60 IF FGL_WIDTH(ga_table_data[p_i].field060 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field060 = ga_table_data[p_i].field060.subString(1,g_qry_length[p_k]) END IF 
    WHEN  61 IF FGL_WIDTH(ga_table_data[p_i].field061 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field061 = ga_table_data[p_i].field061.subString(1,g_qry_length[p_k]) END IF 
    WHEN  62 IF FGL_WIDTH(ga_table_data[p_i].field062 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field062 = ga_table_data[p_i].field062.subString(1,g_qry_length[p_k]) END IF 
    WHEN  63 IF FGL_WIDTH(ga_table_data[p_i].field063 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field063 = ga_table_data[p_i].field063.subString(1,g_qry_length[p_k]) END IF 
    WHEN  64 IF FGL_WIDTH(ga_table_data[p_i].field064 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field064 = ga_table_data[p_i].field064.subString(1,g_qry_length[p_k]) END IF 
    WHEN  65 IF FGL_WIDTH(ga_table_data[p_i].field065 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field065 = ga_table_data[p_i].field065.subString(1,g_qry_length[p_k]) END IF 
    WHEN  66 IF FGL_WIDTH(ga_table_data[p_i].field066 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field066 = ga_table_data[p_i].field066.subString(1,g_qry_length[p_k]) END IF 
    WHEN  67 IF FGL_WIDTH(ga_table_data[p_i].field067 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field067 = ga_table_data[p_i].field067.subString(1,g_qry_length[p_k]) END IF 
    WHEN  68 IF FGL_WIDTH(ga_table_data[p_i].field068 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field068 = ga_table_data[p_i].field068.subString(1,g_qry_length[p_k]) END IF 
    WHEN  69 IF FGL_WIDTH(ga_table_data[p_i].field069 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field069 = ga_table_data[p_i].field069.subString(1,g_qry_length[p_k]) END IF 
    WHEN  70 IF FGL_WIDTH(ga_table_data[p_i].field070 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field070 = ga_table_data[p_i].field070.subString(1,g_qry_length[p_k]) END IF 
    WHEN  71 IF FGL_WIDTH(ga_table_data[p_i].field071 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field071 = ga_table_data[p_i].field071.subString(1,g_qry_length[p_k]) END IF 
    WHEN  72 IF FGL_WIDTH(ga_table_data[p_i].field072 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field072 = ga_table_data[p_i].field072.subString(1,g_qry_length[p_k]) END IF 
    WHEN  73 IF FGL_WIDTH(ga_table_data[p_i].field073 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field073 = ga_table_data[p_i].field073.subString(1,g_qry_length[p_k]) END IF 
    WHEN  74 IF FGL_WIDTH(ga_table_data[p_i].field074 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field074 = ga_table_data[p_i].field074.subString(1,g_qry_length[p_k]) END IF 
    WHEN  75 IF FGL_WIDTH(ga_table_data[p_i].field075 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field075 = ga_table_data[p_i].field075.subString(1,g_qry_length[p_k]) END IF 
    WHEN  76 IF FGL_WIDTH(ga_table_data[p_i].field076 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field076 = ga_table_data[p_i].field076.subString(1,g_qry_length[p_k]) END IF 
    WHEN  77 IF FGL_WIDTH(ga_table_data[p_i].field077 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field077 = ga_table_data[p_i].field077.subString(1,g_qry_length[p_k]) END IF 
    WHEN  78 IF FGL_WIDTH(ga_table_data[p_i].field078 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field078 = ga_table_data[p_i].field078.subString(1,g_qry_length[p_k]) END IF 
    WHEN  79 IF FGL_WIDTH(ga_table_data[p_i].field079 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field079 = ga_table_data[p_i].field079.subString(1,g_qry_length[p_k]) END IF 
    WHEN  80 IF FGL_WIDTH(ga_table_data[p_i].field080 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field080 = ga_table_data[p_i].field080.subString(1,g_qry_length[p_k]) END IF 
    WHEN  81 IF FGL_WIDTH(ga_table_data[p_i].field081 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field081 = ga_table_data[p_i].field081.subString(1,g_qry_length[p_k]) END IF 
    WHEN  82 IF FGL_WIDTH(ga_table_data[p_i].field082 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field082 = ga_table_data[p_i].field082.subString(1,g_qry_length[p_k]) END IF 
    WHEN  83 IF FGL_WIDTH(ga_table_data[p_i].field083 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field083 = ga_table_data[p_i].field083.subString(1,g_qry_length[p_k]) END IF 
    WHEN  84 IF FGL_WIDTH(ga_table_data[p_i].field084 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field084 = ga_table_data[p_i].field084.subString(1,g_qry_length[p_k]) END IF 
    WHEN  85 IF FGL_WIDTH(ga_table_data[p_i].field085 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field085 = ga_table_data[p_i].field085.subString(1,g_qry_length[p_k]) END IF 
    WHEN  86 IF FGL_WIDTH(ga_table_data[p_i].field086 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field086 = ga_table_data[p_i].field086.subString(1,g_qry_length[p_k]) END IF 
    WHEN  87 IF FGL_WIDTH(ga_table_data[p_i].field087 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field087 = ga_table_data[p_i].field087.subString(1,g_qry_length[p_k]) END IF 
    WHEN  88 IF FGL_WIDTH(ga_table_data[p_i].field088 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field088 = ga_table_data[p_i].field088.subString(1,g_qry_length[p_k]) END IF 
    WHEN  89 IF FGL_WIDTH(ga_table_data[p_i].field089 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field089 = ga_table_data[p_i].field089.subString(1,g_qry_length[p_k]) END IF 
    WHEN  90 IF FGL_WIDTH(ga_table_data[p_i].field090 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field090 = ga_table_data[p_i].field090.subString(1,g_qry_length[p_k]) END IF 
    WHEN  91 IF FGL_WIDTH(ga_table_data[p_i].field091 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field091 = ga_table_data[p_i].field091.subString(1,g_qry_length[p_k]) END IF 
    WHEN  92 IF FGL_WIDTH(ga_table_data[p_i].field092 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field092 = ga_table_data[p_i].field092.subString(1,g_qry_length[p_k]) END IF 
    WHEN  93 IF FGL_WIDTH(ga_table_data[p_i].field093 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field093 = ga_table_data[p_i].field093.subString(1,g_qry_length[p_k]) END IF 
    WHEN  94 IF FGL_WIDTH(ga_table_data[p_i].field094 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field094 = ga_table_data[p_i].field094.subString(1,g_qry_length[p_k]) END IF 
    WHEN  95 IF FGL_WIDTH(ga_table_data[p_i].field095 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field095 = ga_table_data[p_i].field095.subString(1,g_qry_length[p_k]) END IF 
    WHEN  96 IF FGL_WIDTH(ga_table_data[p_i].field096 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field096 = ga_table_data[p_i].field096.subString(1,g_qry_length[p_k]) END IF 
    WHEN  97 IF FGL_WIDTH(ga_table_data[p_i].field097 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field097 = ga_table_data[p_i].field097.subString(1,g_qry_length[p_k]) END IF 
    WHEN  98 IF FGL_WIDTH(ga_table_data[p_i].field098 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field098 = ga_table_data[p_i].field098.subString(1,g_qry_length[p_k]) END IF 
    WHEN  99 IF FGL_WIDTH(ga_table_data[p_i].field099 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field099 = ga_table_data[p_i].field099.subString(1,g_qry_length[p_k]) END IF 
    WHEN 100 IF FGL_WIDTH(ga_table_data[p_i].field100 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field100 = ga_table_data[p_i].field100.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 101 IF FGL_WIDTH(ga_table_data[p_i].field101 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field101 = ga_table_data[p_i].field101.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 102 IF FGL_WIDTH(ga_table_data[p_i].field102 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field102 = ga_table_data[p_i].field102.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 103 IF FGL_WIDTH(ga_table_data[p_i].field103 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field103 = ga_table_data[p_i].field103.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 104 IF FGL_WIDTH(ga_table_data[p_i].field104 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field104 = ga_table_data[p_i].field104.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 105 IF FGL_WIDTH(ga_table_data[p_i].field105 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field105 = ga_table_data[p_i].field105.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 106 IF FGL_WIDTH(ga_table_data[p_i].field106 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field106 = ga_table_data[p_i].field106.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 107 IF FGL_WIDTH(ga_table_data[p_i].field107 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field107 = ga_table_data[p_i].field107.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 108 IF FGL_WIDTH(ga_table_data[p_i].field108 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field108 = ga_table_data[p_i].field108.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 109 IF FGL_WIDTH(ga_table_data[p_i].field109 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field109 = ga_table_data[p_i].field109.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 110 IF FGL_WIDTH(ga_table_data[p_i].field110 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field110 = ga_table_data[p_i].field110.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 111 IF FGL_WIDTH(ga_table_data[p_i].field111 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field111 = ga_table_data[p_i].field111.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 112 IF FGL_WIDTH(ga_table_data[p_i].field112 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field112 = ga_table_data[p_i].field112.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 113 IF FGL_WIDTH(ga_table_data[p_i].field113 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field113 = ga_table_data[p_i].field113.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 114 IF FGL_WIDTH(ga_table_data[p_i].field114 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field114 = ga_table_data[p_i].field114.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 115 IF FGL_WIDTH(ga_table_data[p_i].field115 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field115 = ga_table_data[p_i].field115.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 116 IF FGL_WIDTH(ga_table_data[p_i].field116 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field116 = ga_table_data[p_i].field116.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 117 IF FGL_WIDTH(ga_table_data[p_i].field117 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field117 = ga_table_data[p_i].field117.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 118 IF FGL_WIDTH(ga_table_data[p_i].field118 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field118 = ga_table_data[p_i].field118.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 119 IF FGL_WIDTH(ga_table_data[p_i].field119 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field119 = ga_table_data[p_i].field119.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 120 IF FGL_WIDTH(ga_table_data[p_i].field120 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field120 = ga_table_data[p_i].field120.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 121 IF FGL_WIDTH(ga_table_data[p_i].field121 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field121 = ga_table_data[p_i].field121.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 122 IF FGL_WIDTH(ga_table_data[p_i].field122 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field122 = ga_table_data[p_i].field122.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 123 IF FGL_WIDTH(ga_table_data[p_i].field123 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field123 = ga_table_data[p_i].field123.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 124 IF FGL_WIDTH(ga_table_data[p_i].field124 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field124 = ga_table_data[p_i].field124.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 125 IF FGL_WIDTH(ga_table_data[p_i].field125 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field125 = ga_table_data[p_i].field125.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 126 IF FGL_WIDTH(ga_table_data[p_i].field126 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field126 = ga_table_data[p_i].field126.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 127 IF FGL_WIDTH(ga_table_data[p_i].field127 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field127 = ga_table_data[p_i].field127.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 128 IF FGL_WIDTH(ga_table_data[p_i].field128 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field128 = ga_table_data[p_i].field128.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 129 IF FGL_WIDTH(ga_table_data[p_i].field129 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field129 = ga_table_data[p_i].field129.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 130 IF FGL_WIDTH(ga_table_data[p_i].field130 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field130 = ga_table_data[p_i].field130.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 131 IF FGL_WIDTH(ga_table_data[p_i].field131 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field131 = ga_table_data[p_i].field131.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 132 IF FGL_WIDTH(ga_table_data[p_i].field132 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field132 = ga_table_data[p_i].field132.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 133 IF FGL_WIDTH(ga_table_data[p_i].field133 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field133 = ga_table_data[p_i].field133.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 134 IF FGL_WIDTH(ga_table_data[p_i].field134 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field134 = ga_table_data[p_i].field134.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 135 IF FGL_WIDTH(ga_table_data[p_i].field135 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field135 = ga_table_data[p_i].field135.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 136 IF FGL_WIDTH(ga_table_data[p_i].field136 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field136 = ga_table_data[p_i].field136.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 137 IF FGL_WIDTH(ga_table_data[p_i].field137 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field137 = ga_table_data[p_i].field137.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 138 IF FGL_WIDTH(ga_table_data[p_i].field138 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field138 = ga_table_data[p_i].field138.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 139 IF FGL_WIDTH(ga_table_data[p_i].field139 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field139 = ga_table_data[p_i].field139.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 140 IF FGL_WIDTH(ga_table_data[p_i].field140 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field140 = ga_table_data[p_i].field140.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 141 IF FGL_WIDTH(ga_table_data[p_i].field141 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field141 = ga_table_data[p_i].field141.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 142 IF FGL_WIDTH(ga_table_data[p_i].field142 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field142 = ga_table_data[p_i].field142.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 143 IF FGL_WIDTH(ga_table_data[p_i].field143 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field143 = ga_table_data[p_i].field143.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 144 IF FGL_WIDTH(ga_table_data[p_i].field144 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field144 = ga_table_data[p_i].field144.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 145 IF FGL_WIDTH(ga_table_data[p_i].field145 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field145 = ga_table_data[p_i].field145.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 146 IF FGL_WIDTH(ga_table_data[p_i].field146 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field146 = ga_table_data[p_i].field146.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 147 IF FGL_WIDTH(ga_table_data[p_i].field147 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field147 = ga_table_data[p_i].field147.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 148 IF FGL_WIDTH(ga_table_data[p_i].field148 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field148 = ga_table_data[p_i].field148.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 149 IF FGL_WIDTH(ga_table_data[p_i].field149 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field149 = ga_table_data[p_i].field149.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 150 IF FGL_WIDTH(ga_table_data[p_i].field150 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field150 = ga_table_data[p_i].field150.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 151 IF FGL_WIDTH(ga_table_data[p_i].field151 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field151 = ga_table_data[p_i].field151.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 152 IF FGL_WIDTH(ga_table_data[p_i].field152 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field152 = ga_table_data[p_i].field152.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 153 IF FGL_WIDTH(ga_table_data[p_i].field153 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field153 = ga_table_data[p_i].field153.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 154 IF FGL_WIDTH(ga_table_data[p_i].field154 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field154 = ga_table_data[p_i].field154.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 155 IF FGL_WIDTH(ga_table_data[p_i].field155 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field155 = ga_table_data[p_i].field155.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 156 IF FGL_WIDTH(ga_table_data[p_i].field156 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field156 = ga_table_data[p_i].field156.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 157 IF FGL_WIDTH(ga_table_data[p_i].field157 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field157 = ga_table_data[p_i].field157.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 158 IF FGL_WIDTH(ga_table_data[p_i].field158 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field158 = ga_table_data[p_i].field158.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 159 IF FGL_WIDTH(ga_table_data[p_i].field159 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field159 = ga_table_data[p_i].field159.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 160 IF FGL_WIDTH(ga_table_data[p_i].field160 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field160 = ga_table_data[p_i].field160.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 161 IF FGL_WIDTH(ga_table_data[p_i].field161 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field161 = ga_table_data[p_i].field161.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 162 IF FGL_WIDTH(ga_table_data[p_i].field162 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field162 = ga_table_data[p_i].field162.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 163 IF FGL_WIDTH(ga_table_data[p_i].field163 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field163 = ga_table_data[p_i].field163.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 164 IF FGL_WIDTH(ga_table_data[p_i].field164 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field164 = ga_table_data[p_i].field164.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 165 IF FGL_WIDTH(ga_table_data[p_i].field165 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field165 = ga_table_data[p_i].field165.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 166 IF FGL_WIDTH(ga_table_data[p_i].field166 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field166 = ga_table_data[p_i].field166.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 167 IF FGL_WIDTH(ga_table_data[p_i].field167 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field167 = ga_table_data[p_i].field167.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 168 IF FGL_WIDTH(ga_table_data[p_i].field168 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field168 = ga_table_data[p_i].field168.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 169 IF FGL_WIDTH(ga_table_data[p_i].field169 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field169 = ga_table_data[p_i].field169.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 170 IF FGL_WIDTH(ga_table_data[p_i].field170 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field170 = ga_table_data[p_i].field170.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 171 IF FGL_WIDTH(ga_table_data[p_i].field171 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field171 = ga_table_data[p_i].field171.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 172 IF FGL_WIDTH(ga_table_data[p_i].field172 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field172 = ga_table_data[p_i].field172.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 173 IF FGL_WIDTH(ga_table_data[p_i].field173 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field173 = ga_table_data[p_i].field173.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 174 IF FGL_WIDTH(ga_table_data[p_i].field174 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field174 = ga_table_data[p_i].field174.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 175 IF FGL_WIDTH(ga_table_data[p_i].field175 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field175 = ga_table_data[p_i].field175.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 176 IF FGL_WIDTH(ga_table_data[p_i].field176 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field176 = ga_table_data[p_i].field176.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 177 IF FGL_WIDTH(ga_table_data[p_i].field177 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field177 = ga_table_data[p_i].field177.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 178 IF FGL_WIDTH(ga_table_data[p_i].field178 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field178 = ga_table_data[p_i].field178.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 179 IF FGL_WIDTH(ga_table_data[p_i].field179 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field179 = ga_table_data[p_i].field179.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 180 IF FGL_WIDTH(ga_table_data[p_i].field180 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field180 = ga_table_data[p_i].field180.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 181 IF FGL_WIDTH(ga_table_data[p_i].field181 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field181 = ga_table_data[p_i].field181.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 182 IF FGL_WIDTH(ga_table_data[p_i].field182 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field182 = ga_table_data[p_i].field182.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 183 IF FGL_WIDTH(ga_table_data[p_i].field183 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field183 = ga_table_data[p_i].field183.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 184 IF FGL_WIDTH(ga_table_data[p_i].field184 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field184 = ga_table_data[p_i].field184.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 185 IF FGL_WIDTH(ga_table_data[p_i].field185 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field185 = ga_table_data[p_i].field185.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 186 IF FGL_WIDTH(ga_table_data[p_i].field186 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field186 = ga_table_data[p_i].field186.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 187 IF FGL_WIDTH(ga_table_data[p_i].field187 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field187 = ga_table_data[p_i].field187.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 188 IF FGL_WIDTH(ga_table_data[p_i].field188 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field188 = ga_table_data[p_i].field188.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 189 IF FGL_WIDTH(ga_table_data[p_i].field189 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field189 = ga_table_data[p_i].field189.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 190 IF FGL_WIDTH(ga_table_data[p_i].field190 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field190 = ga_table_data[p_i].field190.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 191 IF FGL_WIDTH(ga_table_data[p_i].field191 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field191 = ga_table_data[p_i].field191.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 192 IF FGL_WIDTH(ga_table_data[p_i].field192 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field192 = ga_table_data[p_i].field192.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 193 IF FGL_WIDTH(ga_table_data[p_i].field193 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field193 = ga_table_data[p_i].field193.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 194 IF FGL_WIDTH(ga_table_data[p_i].field194 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field194 = ga_table_data[p_i].field194.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 195 IF FGL_WIDTH(ga_table_data[p_i].field195 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field195 = ga_table_data[p_i].field195.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 196 IF FGL_WIDTH(ga_table_data[p_i].field196 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field196 = ga_table_data[p_i].field196.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 197 IF FGL_WIDTH(ga_table_data[p_i].field197 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field197 = ga_table_data[p_i].field197.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 198 IF FGL_WIDTH(ga_table_data[p_i].field198 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field198 = ga_table_data[p_i].field198.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 199 IF FGL_WIDTH(ga_table_data[p_i].field199 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field199 = ga_table_data[p_i].field199.subString(1,g_qry_length[p_k]) END IF 
   #WHEN 200 IF FGL_WIDTH(ga_table_data[p_i].field200 ) > g_qry_length[p_k] THEN LET ga_table_data[p_i].field200 = ga_table_data[p_i].field200.subString(1,g_qry_length[p_k]) END IF 
   END CASE
 
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 處理型態為數值的欄位格式
#                  將數值依指定的列印長度及小數位數做FORMAT
# Date & Author..:
# Input Parameter: p_k,p_i
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_scale(p_k,p_i)
DEFINE p_k             LIKE type_file.num10       #目前check的欄位
DEFINE p_i             LIKE type_file.num10       #目前check的筆數
DEFINE l_azi01         LIKE azi_file.azi01
DEFINE l_scale         LIKE azi_file.azi03
DEFINE l_i             LIKE type_file.num10       #TQC-790050
DEFINE l_num           LIKE type_file.num26_10    #No.FUN-810062
DEFINE l_len           LIKE type_file.num10       #FUN-920079
DEFINE l_space         LIKE type_file.num10       #FUN-920079
   
   IF g_scale_curr.getLength() >= p_k THEN
       IF NOT cl_null(g_scale_curr[p_k].curr_col) THEN
          INITIALIZE ga_page_data_o.* TO NULL
          LET ga_page_data_o.* = ga_page_data_t.*
          LET ga_page_data_t.* = ga_table_data[p_i].*
          LET l_azi01 = cl_query_getvalue(g_scale_curr[p_k].curr_col)
          CASE g_scale_curr[p_k].scale_type 
            WHEN '1'
                 SELECT azi03 INTO l_scale FROM azi_file
                      WHERE  azi01 = l_azi01
                 LET g_qry_scale[p_k] = l_scale
            WHEN '2'
                 SELECT azi04 INTO l_scale FROM azi_file
                      WHERE  azi01 = l_azi01
                 LET g_qry_scale[p_k] = l_scale
            WHEN '3'
                 SELECT azi05 INTO l_scale FROM azi_file
                      WHERE  azi01 = l_azi01
                 LET g_qry_scale[p_k] = l_scale
            WHEN '4'
                 SELECT azi07 INTO l_scale FROM azi_file
                      WHERE  azi01 = l_azi01
                 LET g_qry_scale[p_k] = l_scale
          END CASE
          LET ga_page_data_t.* = ga_page_data_o.*
 
       END IF
   END IF
 
   #No.FUN-920079
   IF g_qry_length[p_k] > 37 THEN
      LET l_len = 37
      LET l_space = g_qry_length[p_k] - 37
   ELSE
      LET l_len = g_qry_length[p_k]
   END IF
 
   #No.FUN-810062
   #TQC-790050
   #將數值依指定的列印長度及小數位數做FORMAT
   #TQC-BB0068 - Start -
   CASE p_k 
   
    WHEN   1  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field001 LET l_num = ga_table_data[p_i].field001 IF l_i = 0 AND ORD(ga_table_data[p_i].field001) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field001 = l_space SPACES, cl_numfor(ga_table_data[p_i].field001,l_len-1,cl_scale_chk(ga_table_data[p_i].field001 ,g_qry_scale[p_k])) END IF
    WHEN   2  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field002 LET l_num = ga_table_data[p_i].field002 IF l_i = 0 AND ORD(ga_table_data[p_i].field002) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field002 = l_space SPACES, cl_numfor(ga_table_data[p_i].field002,l_len-1,cl_scale_chk(ga_table_data[p_i].field002 ,g_qry_scale[p_k])) END IF
    WHEN   3  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field003 LET l_num = ga_table_data[p_i].field003 IF l_i = 0 AND ORD(ga_table_data[p_i].field003) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field003 = l_space SPACES, cl_numfor(ga_table_data[p_i].field003,l_len-1,cl_scale_chk(ga_table_data[p_i].field003 ,g_qry_scale[p_k])) END IF
    WHEN   4  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field004 LET l_num = ga_table_data[p_i].field004 IF l_i = 0 AND ORD(ga_table_data[p_i].field004) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field004 = l_space SPACES, cl_numfor(ga_table_data[p_i].field004,l_len-1,cl_scale_chk(ga_table_data[p_i].field004 ,g_qry_scale[p_k])) END IF
    WHEN   5  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field005 LET l_num = ga_table_data[p_i].field005 IF l_i = 0 AND ORD(ga_table_data[p_i].field005) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field005 = l_space SPACES, cl_numfor(ga_table_data[p_i].field005,l_len-1,cl_scale_chk(ga_table_data[p_i].field005 ,g_qry_scale[p_k])) END IF
    WHEN   6  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field006 LET l_num = ga_table_data[p_i].field006 IF l_i = 0 AND ORD(ga_table_data[p_i].field006) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field006 = l_space SPACES, cl_numfor(ga_table_data[p_i].field006,l_len-1,cl_scale_chk(ga_table_data[p_i].field006 ,g_qry_scale[p_k])) END IF
    WHEN   7  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field007 LET l_num = ga_table_data[p_i].field007 IF l_i = 0 AND ORD(ga_table_data[p_i].field007) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field007 = l_space SPACES, cl_numfor(ga_table_data[p_i].field007,l_len-1,cl_scale_chk(ga_table_data[p_i].field007 ,g_qry_scale[p_k])) END IF
    WHEN   8  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field008 LET l_num = ga_table_data[p_i].field008 IF l_i = 0 AND ORD(ga_table_data[p_i].field008) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field008 = l_space SPACES, cl_numfor(ga_table_data[p_i].field008,l_len-1,cl_scale_chk(ga_table_data[p_i].field008 ,g_qry_scale[p_k])) END IF
    WHEN   9  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field009 LET l_num = ga_table_data[p_i].field009 IF l_i = 0 AND ORD(ga_table_data[p_i].field009) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field009 = l_space SPACES, cl_numfor(ga_table_data[p_i].field009,l_len-1,cl_scale_chk(ga_table_data[p_i].field009 ,g_qry_scale[p_k])) END IF
    WHEN  10  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field010 LET l_num = ga_table_data[p_i].field010 IF l_i = 0 AND ORD(ga_table_data[p_i].field010) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field010 = l_space SPACES, cl_numfor(ga_table_data[p_i].field010,l_len-1,cl_scale_chk(ga_table_data[p_i].field010 ,g_qry_scale[p_k])) END IF
    WHEN  11  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field011 LET l_num = ga_table_data[p_i].field011 IF l_i = 0 AND ORD(ga_table_data[p_i].field011) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field011 = l_space SPACES, cl_numfor(ga_table_data[p_i].field011,l_len-1,cl_scale_chk(ga_table_data[p_i].field011 ,g_qry_scale[p_k])) END IF
    WHEN  12  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field012 LET l_num = ga_table_data[p_i].field012 IF l_i = 0 AND ORD(ga_table_data[p_i].field012) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field012 = l_space SPACES, cl_numfor(ga_table_data[p_i].field012,l_len-1,cl_scale_chk(ga_table_data[p_i].field012 ,g_qry_scale[p_k])) END IF
    WHEN  13  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field013 LET l_num = ga_table_data[p_i].field013 IF l_i = 0 AND ORD(ga_table_data[p_i].field013) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field013 = l_space SPACES, cl_numfor(ga_table_data[p_i].field013,l_len-1,cl_scale_chk(ga_table_data[p_i].field013 ,g_qry_scale[p_k])) END IF
    WHEN  14  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field014 LET l_num = ga_table_data[p_i].field014 IF l_i = 0 AND ORD(ga_table_data[p_i].field014) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field014 = l_space SPACES, cl_numfor(ga_table_data[p_i].field014,l_len-1,cl_scale_chk(ga_table_data[p_i].field014 ,g_qry_scale[p_k])) END IF
    WHEN  15  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field015 LET l_num = ga_table_data[p_i].field015 IF l_i = 0 AND ORD(ga_table_data[p_i].field015) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field015 = l_space SPACES, cl_numfor(ga_table_data[p_i].field015,l_len-1,cl_scale_chk(ga_table_data[p_i].field015 ,g_qry_scale[p_k])) END IF
    WHEN  16  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field016 LET l_num = ga_table_data[p_i].field016 IF l_i = 0 AND ORD(ga_table_data[p_i].field016) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field016 = l_space SPACES, cl_numfor(ga_table_data[p_i].field016,l_len-1,cl_scale_chk(ga_table_data[p_i].field016 ,g_qry_scale[p_k])) END IF
    WHEN  17  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field017 LET l_num = ga_table_data[p_i].field017 IF l_i = 0 AND ORD(ga_table_data[p_i].field017) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field017 = l_space SPACES, cl_numfor(ga_table_data[p_i].field017,l_len-1,cl_scale_chk(ga_table_data[p_i].field017 ,g_qry_scale[p_k])) END IF
    WHEN  18  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field018 LET l_num = ga_table_data[p_i].field018 IF l_i = 0 AND ORD(ga_table_data[p_i].field018) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field018 = l_space SPACES, cl_numfor(ga_table_data[p_i].field018,l_len-1,cl_scale_chk(ga_table_data[p_i].field018 ,g_qry_scale[p_k])) END IF
    WHEN  19  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field019 LET l_num = ga_table_data[p_i].field019 IF l_i = 0 AND ORD(ga_table_data[p_i].field019) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field019 = l_space SPACES, cl_numfor(ga_table_data[p_i].field019,l_len-1,cl_scale_chk(ga_table_data[p_i].field019 ,g_qry_scale[p_k])) END IF
    WHEN  20  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field020 LET l_num = ga_table_data[p_i].field020 IF l_i = 0 AND ORD(ga_table_data[p_i].field020) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field020 = l_space SPACES, cl_numfor(ga_table_data[p_i].field020,l_len-1,cl_scale_chk(ga_table_data[p_i].field020 ,g_qry_scale[p_k])) END IF
    WHEN  21  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field021 LET l_num = ga_table_data[p_i].field021 IF l_i = 0 AND ORD(ga_table_data[p_i].field021) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field021 = l_space SPACES, cl_numfor(ga_table_data[p_i].field021,l_len-1,cl_scale_chk(ga_table_data[p_i].field021 ,g_qry_scale[p_k])) END IF
    WHEN  22  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field022 LET l_num = ga_table_data[p_i].field022 IF l_i = 0 AND ORD(ga_table_data[p_i].field022) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field022 = l_space SPACES, cl_numfor(ga_table_data[p_i].field022,l_len-1,cl_scale_chk(ga_table_data[p_i].field022 ,g_qry_scale[p_k])) END IF
    WHEN  23  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field023 LET l_num = ga_table_data[p_i].field023 IF l_i = 0 AND ORD(ga_table_data[p_i].field023) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field023 = l_space SPACES, cl_numfor(ga_table_data[p_i].field023,l_len-1,cl_scale_chk(ga_table_data[p_i].field023 ,g_qry_scale[p_k])) END IF
    WHEN  24  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field024 LET l_num = ga_table_data[p_i].field024 IF l_i = 0 AND ORD(ga_table_data[p_i].field024) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field024 = l_space SPACES, cl_numfor(ga_table_data[p_i].field024,l_len-1,cl_scale_chk(ga_table_data[p_i].field024 ,g_qry_scale[p_k])) END IF
    WHEN  25  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field025 LET l_num = ga_table_data[p_i].field025 IF l_i = 0 AND ORD(ga_table_data[p_i].field025) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field025 = l_space SPACES, cl_numfor(ga_table_data[p_i].field025,l_len-1,cl_scale_chk(ga_table_data[p_i].field025 ,g_qry_scale[p_k])) END IF
    WHEN  26  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field026 LET l_num = ga_table_data[p_i].field026 IF l_i = 0 AND ORD(ga_table_data[p_i].field026) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field026 = l_space SPACES, cl_numfor(ga_table_data[p_i].field026,l_len-1,cl_scale_chk(ga_table_data[p_i].field026 ,g_qry_scale[p_k])) END IF
    WHEN  27  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field027 LET l_num = ga_table_data[p_i].field027 IF l_i = 0 AND ORD(ga_table_data[p_i].field027) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field027 = l_space SPACES, cl_numfor(ga_table_data[p_i].field027,l_len-1,cl_scale_chk(ga_table_data[p_i].field027 ,g_qry_scale[p_k])) END IF
    WHEN  28  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field028 LET l_num = ga_table_data[p_i].field028 IF l_i = 0 AND ORD(ga_table_data[p_i].field028) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field028 = l_space SPACES, cl_numfor(ga_table_data[p_i].field028,l_len-1,cl_scale_chk(ga_table_data[p_i].field028 ,g_qry_scale[p_k])) END IF
    WHEN  29  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field029 LET l_num = ga_table_data[p_i].field029 IF l_i = 0 AND ORD(ga_table_data[p_i].field029) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field029 = l_space SPACES, cl_numfor(ga_table_data[p_i].field029,l_len-1,cl_scale_chk(ga_table_data[p_i].field029 ,g_qry_scale[p_k])) END IF
    WHEN  30  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field030 LET l_num = ga_table_data[p_i].field030 IF l_i = 0 AND ORD(ga_table_data[p_i].field030) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field030 = l_space SPACES, cl_numfor(ga_table_data[p_i].field030,l_len-1,cl_scale_chk(ga_table_data[p_i].field030 ,g_qry_scale[p_k])) END IF
    WHEN  31  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field031 LET l_num = ga_table_data[p_i].field031 IF l_i = 0 AND ORD(ga_table_data[p_i].field031) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field031 = l_space SPACES, cl_numfor(ga_table_data[p_i].field031,l_len-1,cl_scale_chk(ga_table_data[p_i].field031 ,g_qry_scale[p_k])) END IF
    WHEN  32  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field032 LET l_num = ga_table_data[p_i].field032 IF l_i = 0 AND ORD(ga_table_data[p_i].field032) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field032 = l_space SPACES, cl_numfor(ga_table_data[p_i].field032,l_len-1,cl_scale_chk(ga_table_data[p_i].field032 ,g_qry_scale[p_k])) END IF
    WHEN  33  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field033 LET l_num = ga_table_data[p_i].field033 IF l_i = 0 AND ORD(ga_table_data[p_i].field033) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field033 = l_space SPACES, cl_numfor(ga_table_data[p_i].field033,l_len-1,cl_scale_chk(ga_table_data[p_i].field033 ,g_qry_scale[p_k])) END IF
    WHEN  34  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field034 LET l_num = ga_table_data[p_i].field034 IF l_i = 0 AND ORD(ga_table_data[p_i].field034) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field034 = l_space SPACES, cl_numfor(ga_table_data[p_i].field034,l_len-1,cl_scale_chk(ga_table_data[p_i].field034 ,g_qry_scale[p_k])) END IF
    WHEN  35  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field035 LET l_num = ga_table_data[p_i].field035 IF l_i = 0 AND ORD(ga_table_data[p_i].field035) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field035 = l_space SPACES, cl_numfor(ga_table_data[p_i].field035,l_len-1,cl_scale_chk(ga_table_data[p_i].field035 ,g_qry_scale[p_k])) END IF
    WHEN  36  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field036 LET l_num = ga_table_data[p_i].field036 IF l_i = 0 AND ORD(ga_table_data[p_i].field036) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field036 = l_space SPACES, cl_numfor(ga_table_data[p_i].field036,l_len-1,cl_scale_chk(ga_table_data[p_i].field036 ,g_qry_scale[p_k])) END IF
    WHEN  37  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field037 LET l_num = ga_table_data[p_i].field037 IF l_i = 0 AND ORD(ga_table_data[p_i].field037) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field037 = l_space SPACES, cl_numfor(ga_table_data[p_i].field037,l_len-1,cl_scale_chk(ga_table_data[p_i].field037 ,g_qry_scale[p_k])) END IF
    WHEN  38  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field038 LET l_num = ga_table_data[p_i].field038 IF l_i = 0 AND ORD(ga_table_data[p_i].field038) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field038 = l_space SPACES, cl_numfor(ga_table_data[p_i].field038,l_len-1,cl_scale_chk(ga_table_data[p_i].field038 ,g_qry_scale[p_k])) END IF
    WHEN  39  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field039 LET l_num = ga_table_data[p_i].field039 IF l_i = 0 AND ORD(ga_table_data[p_i].field039) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field039 = l_space SPACES, cl_numfor(ga_table_data[p_i].field039,l_len-1,cl_scale_chk(ga_table_data[p_i].field039 ,g_qry_scale[p_k])) END IF
    WHEN  40  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field040 LET l_num = ga_table_data[p_i].field040 IF l_i = 0 AND ORD(ga_table_data[p_i].field040) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field040 = l_space SPACES, cl_numfor(ga_table_data[p_i].field040,l_len-1,cl_scale_chk(ga_table_data[p_i].field040 ,g_qry_scale[p_k])) END IF
    WHEN  41  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field041 LET l_num = ga_table_data[p_i].field041 IF l_i = 0 AND ORD(ga_table_data[p_i].field041) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field041 = l_space SPACES, cl_numfor(ga_table_data[p_i].field041,l_len-1,cl_scale_chk(ga_table_data[p_i].field041 ,g_qry_scale[p_k])) END IF
    WHEN  42  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field042 LET l_num = ga_table_data[p_i].field042 IF l_i = 0 AND ORD(ga_table_data[p_i].field042) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field042 = l_space SPACES, cl_numfor(ga_table_data[p_i].field042,l_len-1,cl_scale_chk(ga_table_data[p_i].field042 ,g_qry_scale[p_k])) END IF
    WHEN  43  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field043 LET l_num = ga_table_data[p_i].field043 IF l_i = 0 AND ORD(ga_table_data[p_i].field043) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field043 = l_space SPACES, cl_numfor(ga_table_data[p_i].field043,l_len-1,cl_scale_chk(ga_table_data[p_i].field043 ,g_qry_scale[p_k])) END IF
    WHEN  44  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field044 LET l_num = ga_table_data[p_i].field044 IF l_i = 0 AND ORD(ga_table_data[p_i].field044) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field044 = l_space SPACES, cl_numfor(ga_table_data[p_i].field044,l_len-1,cl_scale_chk(ga_table_data[p_i].field044 ,g_qry_scale[p_k])) END IF
    WHEN  45  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field045 LET l_num = ga_table_data[p_i].field045 IF l_i = 0 AND ORD(ga_table_data[p_i].field045) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field045 = l_space SPACES, cl_numfor(ga_table_data[p_i].field045,l_len-1,cl_scale_chk(ga_table_data[p_i].field045 ,g_qry_scale[p_k])) END IF
    WHEN  46  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field046 LET l_num = ga_table_data[p_i].field046 IF l_i = 0 AND ORD(ga_table_data[p_i].field046) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field046 = l_space SPACES, cl_numfor(ga_table_data[p_i].field046,l_len-1,cl_scale_chk(ga_table_data[p_i].field046 ,g_qry_scale[p_k])) END IF
    WHEN  47  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field047 LET l_num = ga_table_data[p_i].field047 IF l_i = 0 AND ORD(ga_table_data[p_i].field047) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field047 = l_space SPACES, cl_numfor(ga_table_data[p_i].field047,l_len-1,cl_scale_chk(ga_table_data[p_i].field047 ,g_qry_scale[p_k])) END IF
    WHEN  48  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field048 LET l_num = ga_table_data[p_i].field048 IF l_i = 0 AND ORD(ga_table_data[p_i].field048) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field048 = l_space SPACES, cl_numfor(ga_table_data[p_i].field048,l_len-1,cl_scale_chk(ga_table_data[p_i].field048 ,g_qry_scale[p_k])) END IF
    WHEN  49  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field049 LET l_num = ga_table_data[p_i].field049 IF l_i = 0 AND ORD(ga_table_data[p_i].field049) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field049 = l_space SPACES, cl_numfor(ga_table_data[p_i].field049,l_len-1,cl_scale_chk(ga_table_data[p_i].field049 ,g_qry_scale[p_k])) END IF
    WHEN  50  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field050 LET l_num = ga_table_data[p_i].field050 IF l_i = 0 AND ORD(ga_table_data[p_i].field050) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field050 = l_space SPACES, cl_numfor(ga_table_data[p_i].field050,l_len-1,cl_scale_chk(ga_table_data[p_i].field050 ,g_qry_scale[p_k])) END IF
    WHEN  51  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field051 LET l_num = ga_table_data[p_i].field051 IF l_i = 0 AND ORD(ga_table_data[p_i].field051) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field051 = l_space SPACES, cl_numfor(ga_table_data[p_i].field051,l_len-1,cl_scale_chk(ga_table_data[p_i].field051 ,g_qry_scale[p_k])) END IF
    WHEN  52  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field052 LET l_num = ga_table_data[p_i].field052 IF l_i = 0 AND ORD(ga_table_data[p_i].field052) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field052 = l_space SPACES, cl_numfor(ga_table_data[p_i].field052,l_len-1,cl_scale_chk(ga_table_data[p_i].field052 ,g_qry_scale[p_k])) END IF
    WHEN  53  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field053 LET l_num = ga_table_data[p_i].field053 IF l_i = 0 AND ORD(ga_table_data[p_i].field053) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field053 = l_space SPACES, cl_numfor(ga_table_data[p_i].field053,l_len-1,cl_scale_chk(ga_table_data[p_i].field053 ,g_qry_scale[p_k])) END IF
    WHEN  54  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field054 LET l_num = ga_table_data[p_i].field054 IF l_i = 0 AND ORD(ga_table_data[p_i].field054) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field054 = l_space SPACES, cl_numfor(ga_table_data[p_i].field054,l_len-1,cl_scale_chk(ga_table_data[p_i].field054 ,g_qry_scale[p_k])) END IF
    WHEN  55  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field055 LET l_num = ga_table_data[p_i].field055 IF l_i = 0 AND ORD(ga_table_data[p_i].field055) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field055 = l_space SPACES, cl_numfor(ga_table_data[p_i].field055,l_len-1,cl_scale_chk(ga_table_data[p_i].field055 ,g_qry_scale[p_k])) END IF
    WHEN  56  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field056 LET l_num = ga_table_data[p_i].field056 IF l_i = 0 AND ORD(ga_table_data[p_i].field056) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field056 = l_space SPACES, cl_numfor(ga_table_data[p_i].field056,l_len-1,cl_scale_chk(ga_table_data[p_i].field056 ,g_qry_scale[p_k])) END IF
    WHEN  57  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field057 LET l_num = ga_table_data[p_i].field057 IF l_i = 0 AND ORD(ga_table_data[p_i].field057) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field057 = l_space SPACES, cl_numfor(ga_table_data[p_i].field057,l_len-1,cl_scale_chk(ga_table_data[p_i].field057 ,g_qry_scale[p_k])) END IF
    WHEN  58  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field058 LET l_num = ga_table_data[p_i].field058 IF l_i = 0 AND ORD(ga_table_data[p_i].field058) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field058 = l_space SPACES, cl_numfor(ga_table_data[p_i].field058,l_len-1,cl_scale_chk(ga_table_data[p_i].field058 ,g_qry_scale[p_k])) END IF
    WHEN  59  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field059 LET l_num = ga_table_data[p_i].field059 IF l_i = 0 AND ORD(ga_table_data[p_i].field059) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field059 = l_space SPACES, cl_numfor(ga_table_data[p_i].field059,l_len-1,cl_scale_chk(ga_table_data[p_i].field059 ,g_qry_scale[p_k])) END IF
    WHEN  60  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field060 LET l_num = ga_table_data[p_i].field060 IF l_i = 0 AND ORD(ga_table_data[p_i].field060) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field060 = l_space SPACES, cl_numfor(ga_table_data[p_i].field060,l_len-1,cl_scale_chk(ga_table_data[p_i].field060 ,g_qry_scale[p_k])) END IF
    WHEN  61  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field061 LET l_num = ga_table_data[p_i].field061 IF l_i = 0 AND ORD(ga_table_data[p_i].field061) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field061 = l_space SPACES, cl_numfor(ga_table_data[p_i].field061,l_len-1,cl_scale_chk(ga_table_data[p_i].field061 ,g_qry_scale[p_k])) END IF
    WHEN  62  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field062 LET l_num = ga_table_data[p_i].field062 IF l_i = 0 AND ORD(ga_table_data[p_i].field062) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field062 = l_space SPACES, cl_numfor(ga_table_data[p_i].field062,l_len-1,cl_scale_chk(ga_table_data[p_i].field062 ,g_qry_scale[p_k])) END IF
    WHEN  63  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field063 LET l_num = ga_table_data[p_i].field063 IF l_i = 0 AND ORD(ga_table_data[p_i].field063) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field063 = l_space SPACES, cl_numfor(ga_table_data[p_i].field063,l_len-1,cl_scale_chk(ga_table_data[p_i].field063 ,g_qry_scale[p_k])) END IF
    WHEN  64  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field064 LET l_num = ga_table_data[p_i].field064 IF l_i = 0 AND ORD(ga_table_data[p_i].field064) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field064 = l_space SPACES, cl_numfor(ga_table_data[p_i].field064,l_len-1,cl_scale_chk(ga_table_data[p_i].field064 ,g_qry_scale[p_k])) END IF
    WHEN  65  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field065 LET l_num = ga_table_data[p_i].field065 IF l_i = 0 AND ORD(ga_table_data[p_i].field065) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field065 = l_space SPACES, cl_numfor(ga_table_data[p_i].field065,l_len-1,cl_scale_chk(ga_table_data[p_i].field065 ,g_qry_scale[p_k])) END IF
    WHEN  66  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field066 LET l_num = ga_table_data[p_i].field066 IF l_i = 0 AND ORD(ga_table_data[p_i].field066) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field066 = l_space SPACES, cl_numfor(ga_table_data[p_i].field066,l_len-1,cl_scale_chk(ga_table_data[p_i].field066 ,g_qry_scale[p_k])) END IF
    WHEN  67  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field067 LET l_num = ga_table_data[p_i].field067 IF l_i = 0 AND ORD(ga_table_data[p_i].field067) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field067 = l_space SPACES, cl_numfor(ga_table_data[p_i].field067,l_len-1,cl_scale_chk(ga_table_data[p_i].field067 ,g_qry_scale[p_k])) END IF
    WHEN  68  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field068 LET l_num = ga_table_data[p_i].field068 IF l_i = 0 AND ORD(ga_table_data[p_i].field068) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field068 = l_space SPACES, cl_numfor(ga_table_data[p_i].field068,l_len-1,cl_scale_chk(ga_table_data[p_i].field068 ,g_qry_scale[p_k])) END IF
    WHEN  69  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field069 LET l_num = ga_table_data[p_i].field069 IF l_i = 0 AND ORD(ga_table_data[p_i].field069) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field069 = l_space SPACES, cl_numfor(ga_table_data[p_i].field069,l_len-1,cl_scale_chk(ga_table_data[p_i].field069 ,g_qry_scale[p_k])) END IF
    WHEN  70  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field070 LET l_num = ga_table_data[p_i].field070 IF l_i = 0 AND ORD(ga_table_data[p_i].field070) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field070 = l_space SPACES, cl_numfor(ga_table_data[p_i].field070,l_len-1,cl_scale_chk(ga_table_data[p_i].field070 ,g_qry_scale[p_k])) END IF
    WHEN  71  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field071 LET l_num = ga_table_data[p_i].field071 IF l_i = 0 AND ORD(ga_table_data[p_i].field071) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field071 = l_space SPACES, cl_numfor(ga_table_data[p_i].field071,l_len-1,cl_scale_chk(ga_table_data[p_i].field071 ,g_qry_scale[p_k])) END IF
    WHEN  72  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field072 LET l_num = ga_table_data[p_i].field072 IF l_i = 0 AND ORD(ga_table_data[p_i].field072) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field072 = l_space SPACES, cl_numfor(ga_table_data[p_i].field072,l_len-1,cl_scale_chk(ga_table_data[p_i].field072 ,g_qry_scale[p_k])) END IF
    WHEN  73  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field073 LET l_num = ga_table_data[p_i].field073 IF l_i = 0 AND ORD(ga_table_data[p_i].field073) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field073 = l_space SPACES, cl_numfor(ga_table_data[p_i].field073,l_len-1,cl_scale_chk(ga_table_data[p_i].field073 ,g_qry_scale[p_k])) END IF
    WHEN  74  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field074 LET l_num = ga_table_data[p_i].field074 IF l_i = 0 AND ORD(ga_table_data[p_i].field074) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field074 = l_space SPACES, cl_numfor(ga_table_data[p_i].field074,l_len-1,cl_scale_chk(ga_table_data[p_i].field074 ,g_qry_scale[p_k])) END IF
    WHEN  75  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field075 LET l_num = ga_table_data[p_i].field075 IF l_i = 0 AND ORD(ga_table_data[p_i].field075) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field075 = l_space SPACES, cl_numfor(ga_table_data[p_i].field075,l_len-1,cl_scale_chk(ga_table_data[p_i].field075 ,g_qry_scale[p_k])) END IF
    WHEN  76  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field076 LET l_num = ga_table_data[p_i].field076 IF l_i = 0 AND ORD(ga_table_data[p_i].field076) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field076 = l_space SPACES, cl_numfor(ga_table_data[p_i].field076,l_len-1,cl_scale_chk(ga_table_data[p_i].field076 ,g_qry_scale[p_k])) END IF
    WHEN  77  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field077 LET l_num = ga_table_data[p_i].field077 IF l_i = 0 AND ORD(ga_table_data[p_i].field077) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field077 = l_space SPACES, cl_numfor(ga_table_data[p_i].field077,l_len-1,cl_scale_chk(ga_table_data[p_i].field077 ,g_qry_scale[p_k])) END IF
    WHEN  78  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field078 LET l_num = ga_table_data[p_i].field078 IF l_i = 0 AND ORD(ga_table_data[p_i].field078) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field078 = l_space SPACES, cl_numfor(ga_table_data[p_i].field078,l_len-1,cl_scale_chk(ga_table_data[p_i].field078 ,g_qry_scale[p_k])) END IF
    WHEN  79  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field079 LET l_num = ga_table_data[p_i].field079 IF l_i = 0 AND ORD(ga_table_data[p_i].field079) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field079 = l_space SPACES, cl_numfor(ga_table_data[p_i].field079,l_len-1,cl_scale_chk(ga_table_data[p_i].field079 ,g_qry_scale[p_k])) END IF
    WHEN  80  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field080 LET l_num = ga_table_data[p_i].field080 IF l_i = 0 AND ORD(ga_table_data[p_i].field080) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field080 = l_space SPACES, cl_numfor(ga_table_data[p_i].field080,l_len-1,cl_scale_chk(ga_table_data[p_i].field080 ,g_qry_scale[p_k])) END IF
    WHEN  81  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field081 LET l_num = ga_table_data[p_i].field081 IF l_i = 0 AND ORD(ga_table_data[p_i].field081) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field081 = l_space SPACES, cl_numfor(ga_table_data[p_i].field081,l_len-1,cl_scale_chk(ga_table_data[p_i].field081 ,g_qry_scale[p_k])) END IF
    WHEN  82  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field082 LET l_num = ga_table_data[p_i].field082 IF l_i = 0 AND ORD(ga_table_data[p_i].field082) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field082 = l_space SPACES, cl_numfor(ga_table_data[p_i].field082,l_len-1,cl_scale_chk(ga_table_data[p_i].field082 ,g_qry_scale[p_k])) END IF
    WHEN  83  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field083 LET l_num = ga_table_data[p_i].field083 IF l_i = 0 AND ORD(ga_table_data[p_i].field083) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field083 = l_space SPACES, cl_numfor(ga_table_data[p_i].field083,l_len-1,cl_scale_chk(ga_table_data[p_i].field083 ,g_qry_scale[p_k])) END IF
    WHEN  84  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field084 LET l_num = ga_table_data[p_i].field084 IF l_i = 0 AND ORD(ga_table_data[p_i].field084) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field084 = l_space SPACES, cl_numfor(ga_table_data[p_i].field084,l_len-1,cl_scale_chk(ga_table_data[p_i].field084 ,g_qry_scale[p_k])) END IF
    WHEN  85  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field085 LET l_num = ga_table_data[p_i].field085 IF l_i = 0 AND ORD(ga_table_data[p_i].field085) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field085 = l_space SPACES, cl_numfor(ga_table_data[p_i].field085,l_len-1,cl_scale_chk(ga_table_data[p_i].field085 ,g_qry_scale[p_k])) END IF
    WHEN  86  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field086 LET l_num = ga_table_data[p_i].field086 IF l_i = 0 AND ORD(ga_table_data[p_i].field086) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field086 = l_space SPACES, cl_numfor(ga_table_data[p_i].field086,l_len-1,cl_scale_chk(ga_table_data[p_i].field086 ,g_qry_scale[p_k])) END IF
    WHEN  87  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field087 LET l_num = ga_table_data[p_i].field087 IF l_i = 0 AND ORD(ga_table_data[p_i].field087) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field087 = l_space SPACES, cl_numfor(ga_table_data[p_i].field087,l_len-1,cl_scale_chk(ga_table_data[p_i].field087 ,g_qry_scale[p_k])) END IF
    WHEN  88  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field088 LET l_num = ga_table_data[p_i].field088 IF l_i = 0 AND ORD(ga_table_data[p_i].field088) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field088 = l_space SPACES, cl_numfor(ga_table_data[p_i].field088,l_len-1,cl_scale_chk(ga_table_data[p_i].field088 ,g_qry_scale[p_k])) END IF
    WHEN  89  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field089 LET l_num = ga_table_data[p_i].field089 IF l_i = 0 AND ORD(ga_table_data[p_i].field089) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field089 = l_space SPACES, cl_numfor(ga_table_data[p_i].field089,l_len-1,cl_scale_chk(ga_table_data[p_i].field089 ,g_qry_scale[p_k])) END IF
    WHEN  90  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field090 LET l_num = ga_table_data[p_i].field090 IF l_i = 0 AND ORD(ga_table_data[p_i].field090) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field090 = l_space SPACES, cl_numfor(ga_table_data[p_i].field090,l_len-1,cl_scale_chk(ga_table_data[p_i].field090 ,g_qry_scale[p_k])) END IF
    WHEN  91  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field091 LET l_num = ga_table_data[p_i].field091 IF l_i = 0 AND ORD(ga_table_data[p_i].field091) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field091 = l_space SPACES, cl_numfor(ga_table_data[p_i].field091,l_len-1,cl_scale_chk(ga_table_data[p_i].field091 ,g_qry_scale[p_k])) END IF
    WHEN  92  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field092 LET l_num = ga_table_data[p_i].field092 IF l_i = 0 AND ORD(ga_table_data[p_i].field092) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field092 = l_space SPACES, cl_numfor(ga_table_data[p_i].field092,l_len-1,cl_scale_chk(ga_table_data[p_i].field092 ,g_qry_scale[p_k])) END IF
    WHEN  93  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field093 LET l_num = ga_table_data[p_i].field093 IF l_i = 0 AND ORD(ga_table_data[p_i].field093) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field093 = l_space SPACES, cl_numfor(ga_table_data[p_i].field093,l_len-1,cl_scale_chk(ga_table_data[p_i].field093 ,g_qry_scale[p_k])) END IF
    WHEN  94  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field094 LET l_num = ga_table_data[p_i].field094 IF l_i = 0 AND ORD(ga_table_data[p_i].field094) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field094 = l_space SPACES, cl_numfor(ga_table_data[p_i].field094,l_len-1,cl_scale_chk(ga_table_data[p_i].field094 ,g_qry_scale[p_k])) END IF
    WHEN  95  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field095 LET l_num = ga_table_data[p_i].field095 IF l_i = 0 AND ORD(ga_table_data[p_i].field095) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field095 = l_space SPACES, cl_numfor(ga_table_data[p_i].field095,l_len-1,cl_scale_chk(ga_table_data[p_i].field095 ,g_qry_scale[p_k])) END IF
    WHEN  96  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field096 LET l_num = ga_table_data[p_i].field096 IF l_i = 0 AND ORD(ga_table_data[p_i].field096) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field096 = l_space SPACES, cl_numfor(ga_table_data[p_i].field096,l_len-1,cl_scale_chk(ga_table_data[p_i].field096 ,g_qry_scale[p_k])) END IF
    WHEN  97  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field097 LET l_num = ga_table_data[p_i].field097 IF l_i = 0 AND ORD(ga_table_data[p_i].field097) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field097 = l_space SPACES, cl_numfor(ga_table_data[p_i].field097,l_len-1,cl_scale_chk(ga_table_data[p_i].field097 ,g_qry_scale[p_k])) END IF
    WHEN  98  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field098 LET l_num = ga_table_data[p_i].field098 IF l_i = 0 AND ORD(ga_table_data[p_i].field098) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field098 = l_space SPACES, cl_numfor(ga_table_data[p_i].field098,l_len-1,cl_scale_chk(ga_table_data[p_i].field098 ,g_qry_scale[p_k])) END IF
    WHEN  99  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field099 LET l_num = ga_table_data[p_i].field099 IF l_i = 0 AND ORD(ga_table_data[p_i].field099) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field099 = l_space SPACES, cl_numfor(ga_table_data[p_i].field099,l_len-1,cl_scale_chk(ga_table_data[p_i].field099 ,g_qry_scale[p_k])) END IF
    WHEN 100  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field100 LET l_num = ga_table_data[p_i].field100 IF l_i = 0 AND ORD(ga_table_data[p_i].field100) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field100 = l_space SPACES, cl_numfor(ga_table_data[p_i].field100,l_len-1,cl_scale_chk(ga_table_data[p_i].field100 ,g_qry_scale[p_k])) END IF

   #WHEN   1  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field001 LET l_num = ga_table_data[p_i].field001 IF l_i = 0 AND ORD(ga_table_data[p_i].field001) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field001 = l_space SPACES, cl_numfor(ga_table_data[p_i].field001,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN   2  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field002 LET l_num = ga_table_data[p_i].field002 IF l_i = 0 AND ORD(ga_table_data[p_i].field002) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field002 = l_space SPACES, cl_numfor(ga_table_data[p_i].field002,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN   3  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field003 LET l_num = ga_table_data[p_i].field003 IF l_i = 0 AND ORD(ga_table_data[p_i].field003) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field003 = l_space SPACES, cl_numfor(ga_table_data[p_i].field003,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN   4  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field004 LET l_num = ga_table_data[p_i].field004 IF l_i = 0 AND ORD(ga_table_data[p_i].field004) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field004 = l_space SPACES, cl_numfor(ga_table_data[p_i].field004,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN   5  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field005 LET l_num = ga_table_data[p_i].field005 IF l_i = 0 AND ORD(ga_table_data[p_i].field005) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field005 = l_space SPACES, cl_numfor(ga_table_data[p_i].field005,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN   6  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field006 LET l_num = ga_table_data[p_i].field006 IF l_i = 0 AND ORD(ga_table_data[p_i].field006) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field006 = l_space SPACES, cl_numfor(ga_table_data[p_i].field006,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN   7  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field007 LET l_num = ga_table_data[p_i].field007 IF l_i = 0 AND ORD(ga_table_data[p_i].field007) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field007 = l_space SPACES, cl_numfor(ga_table_data[p_i].field007,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN   8  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field008 LET l_num = ga_table_data[p_i].field008 IF l_i = 0 AND ORD(ga_table_data[p_i].field008) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field008 = l_space SPACES, cl_numfor(ga_table_data[p_i].field008,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN   9  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field009 LET l_num = ga_table_data[p_i].field009 IF l_i = 0 AND ORD(ga_table_data[p_i].field009) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field009 = l_space SPACES, cl_numfor(ga_table_data[p_i].field009,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  10  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field010 LET l_num = ga_table_data[p_i].field010 IF l_i = 0 AND ORD(ga_table_data[p_i].field010) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field010 = l_space SPACES, cl_numfor(ga_table_data[p_i].field010,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  11  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field011 LET l_num = ga_table_data[p_i].field011 IF l_i = 0 AND ORD(ga_table_data[p_i].field011) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field011 = l_space SPACES, cl_numfor(ga_table_data[p_i].field011,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  12  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field012 LET l_num = ga_table_data[p_i].field012 IF l_i = 0 AND ORD(ga_table_data[p_i].field012) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field012 = l_space SPACES, cl_numfor(ga_table_data[p_i].field012,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  13  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field013 LET l_num = ga_table_data[p_i].field013 IF l_i = 0 AND ORD(ga_table_data[p_i].field013) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field013 = l_space SPACES, cl_numfor(ga_table_data[p_i].field013,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  14  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field014 LET l_num = ga_table_data[p_i].field014 IF l_i = 0 AND ORD(ga_table_data[p_i].field014) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field014 = l_space SPACES, cl_numfor(ga_table_data[p_i].field014,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  15  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field015 LET l_num = ga_table_data[p_i].field015 IF l_i = 0 AND ORD(ga_table_data[p_i].field015) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field015 = l_space SPACES, cl_numfor(ga_table_data[p_i].field015,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  16  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field016 LET l_num = ga_table_data[p_i].field016 IF l_i = 0 AND ORD(ga_table_data[p_i].field016) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field016 = l_space SPACES, cl_numfor(ga_table_data[p_i].field016,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  17  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field017 LET l_num = ga_table_data[p_i].field017 IF l_i = 0 AND ORD(ga_table_data[p_i].field017) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field017 = l_space SPACES, cl_numfor(ga_table_data[p_i].field017,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  18  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field018 LET l_num = ga_table_data[p_i].field018 IF l_i = 0 AND ORD(ga_table_data[p_i].field018) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field018 = l_space SPACES, cl_numfor(ga_table_data[p_i].field018,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  19  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field019 LET l_num = ga_table_data[p_i].field019 IF l_i = 0 AND ORD(ga_table_data[p_i].field019) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field019 = l_space SPACES, cl_numfor(ga_table_data[p_i].field019,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  20  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field020 LET l_num = ga_table_data[p_i].field020 IF l_i = 0 AND ORD(ga_table_data[p_i].field020) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field020 = l_space SPACES, cl_numfor(ga_table_data[p_i].field020,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  21  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field021 LET l_num = ga_table_data[p_i].field021 IF l_i = 0 AND ORD(ga_table_data[p_i].field021) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field021 = l_space SPACES, cl_numfor(ga_table_data[p_i].field021,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  22  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field022 LET l_num = ga_table_data[p_i].field022 IF l_i = 0 AND ORD(ga_table_data[p_i].field022) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field022 = l_space SPACES, cl_numfor(ga_table_data[p_i].field022,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  23  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field023 LET l_num = ga_table_data[p_i].field023 IF l_i = 0 AND ORD(ga_table_data[p_i].field023) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field023 = l_space SPACES, cl_numfor(ga_table_data[p_i].field023,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  24  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field024 LET l_num = ga_table_data[p_i].field024 IF l_i = 0 AND ORD(ga_table_data[p_i].field024) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field024 = l_space SPACES, cl_numfor(ga_table_data[p_i].field024,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  25  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field025 LET l_num = ga_table_data[p_i].field025 IF l_i = 0 AND ORD(ga_table_data[p_i].field025) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field025 = l_space SPACES, cl_numfor(ga_table_data[p_i].field025,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  26  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field026 LET l_num = ga_table_data[p_i].field026 IF l_i = 0 AND ORD(ga_table_data[p_i].field026) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field026 = l_space SPACES, cl_numfor(ga_table_data[p_i].field026,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  27  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field027 LET l_num = ga_table_data[p_i].field027 IF l_i = 0 AND ORD(ga_table_data[p_i].field027) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field027 = l_space SPACES, cl_numfor(ga_table_data[p_i].field027,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  28  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field028 LET l_num = ga_table_data[p_i].field028 IF l_i = 0 AND ORD(ga_table_data[p_i].field028) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field028 = l_space SPACES, cl_numfor(ga_table_data[p_i].field028,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  29  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field029 LET l_num = ga_table_data[p_i].field029 IF l_i = 0 AND ORD(ga_table_data[p_i].field029) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field029 = l_space SPACES, cl_numfor(ga_table_data[p_i].field029,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  30  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field030 LET l_num = ga_table_data[p_i].field030 IF l_i = 0 AND ORD(ga_table_data[p_i].field030) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field030 = l_space SPACES, cl_numfor(ga_table_data[p_i].field030,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  31  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field031 LET l_num = ga_table_data[p_i].field031 IF l_i = 0 AND ORD(ga_table_data[p_i].field031) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field031 = l_space SPACES, cl_numfor(ga_table_data[p_i].field031,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  32  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field032 LET l_num = ga_table_data[p_i].field032 IF l_i = 0 AND ORD(ga_table_data[p_i].field032) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field032 = l_space SPACES, cl_numfor(ga_table_data[p_i].field032,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  33  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field033 LET l_num = ga_table_data[p_i].field033 IF l_i = 0 AND ORD(ga_table_data[p_i].field033) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field033 = l_space SPACES, cl_numfor(ga_table_data[p_i].field033,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  34  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field034 LET l_num = ga_table_data[p_i].field034 IF l_i = 0 AND ORD(ga_table_data[p_i].field034) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field034 = l_space SPACES, cl_numfor(ga_table_data[p_i].field034,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  35  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field035 LET l_num = ga_table_data[p_i].field035 IF l_i = 0 AND ORD(ga_table_data[p_i].field035) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field035 = l_space SPACES, cl_numfor(ga_table_data[p_i].field035,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  36  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field036 LET l_num = ga_table_data[p_i].field036 IF l_i = 0 AND ORD(ga_table_data[p_i].field036) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field036 = l_space SPACES, cl_numfor(ga_table_data[p_i].field036,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  37  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field037 LET l_num = ga_table_data[p_i].field037 IF l_i = 0 AND ORD(ga_table_data[p_i].field037) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field037 = l_space SPACES, cl_numfor(ga_table_data[p_i].field037,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  38  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field038 LET l_num = ga_table_data[p_i].field038 IF l_i = 0 AND ORD(ga_table_data[p_i].field038) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field038 = l_space SPACES, cl_numfor(ga_table_data[p_i].field038,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  39  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field039 LET l_num = ga_table_data[p_i].field039 IF l_i = 0 AND ORD(ga_table_data[p_i].field039) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field039 = l_space SPACES, cl_numfor(ga_table_data[p_i].field039,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  40  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field040 LET l_num = ga_table_data[p_i].field040 IF l_i = 0 AND ORD(ga_table_data[p_i].field040) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field040 = l_space SPACES, cl_numfor(ga_table_data[p_i].field040,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  41  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field041 LET l_num = ga_table_data[p_i].field041 IF l_i = 0 AND ORD(ga_table_data[p_i].field041) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field041 = l_space SPACES, cl_numfor(ga_table_data[p_i].field041,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  42  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field042 LET l_num = ga_table_data[p_i].field042 IF l_i = 0 AND ORD(ga_table_data[p_i].field042) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field042 = l_space SPACES, cl_numfor(ga_table_data[p_i].field042,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  43  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field043 LET l_num = ga_table_data[p_i].field043 IF l_i = 0 AND ORD(ga_table_data[p_i].field043) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field043 = l_space SPACES, cl_numfor(ga_table_data[p_i].field043,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  44  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field044 LET l_num = ga_table_data[p_i].field044 IF l_i = 0 AND ORD(ga_table_data[p_i].field044) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field044 = l_space SPACES, cl_numfor(ga_table_data[p_i].field044,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  45  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field045 LET l_num = ga_table_data[p_i].field045 IF l_i = 0 AND ORD(ga_table_data[p_i].field045) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field045 = l_space SPACES, cl_numfor(ga_table_data[p_i].field045,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  46  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field046 LET l_num = ga_table_data[p_i].field046 IF l_i = 0 AND ORD(ga_table_data[p_i].field046) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field046 = l_space SPACES, cl_numfor(ga_table_data[p_i].field046,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  47  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field047 LET l_num = ga_table_data[p_i].field047 IF l_i = 0 AND ORD(ga_table_data[p_i].field047) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field047 = l_space SPACES, cl_numfor(ga_table_data[p_i].field047,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  48  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field048 LET l_num = ga_table_data[p_i].field048 IF l_i = 0 AND ORD(ga_table_data[p_i].field048) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field048 = l_space SPACES, cl_numfor(ga_table_data[p_i].field048,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  49  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field049 LET l_num = ga_table_data[p_i].field049 IF l_i = 0 AND ORD(ga_table_data[p_i].field049) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field049 = l_space SPACES, cl_numfor(ga_table_data[p_i].field049,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  50  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field050 LET l_num = ga_table_data[p_i].field050 IF l_i = 0 AND ORD(ga_table_data[p_i].field050) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field050 = l_space SPACES, cl_numfor(ga_table_data[p_i].field050,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  51  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field051 LET l_num = ga_table_data[p_i].field051 IF l_i = 0 AND ORD(ga_table_data[p_i].field051) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field051 = l_space SPACES, cl_numfor(ga_table_data[p_i].field051,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  52  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field052 LET l_num = ga_table_data[p_i].field052 IF l_i = 0 AND ORD(ga_table_data[p_i].field052) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field052 = l_space SPACES, cl_numfor(ga_table_data[p_i].field052,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  53  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field053 LET l_num = ga_table_data[p_i].field053 IF l_i = 0 AND ORD(ga_table_data[p_i].field053) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field053 = l_space SPACES, cl_numfor(ga_table_data[p_i].field053,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  54  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field054 LET l_num = ga_table_data[p_i].field054 IF l_i = 0 AND ORD(ga_table_data[p_i].field054) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field054 = l_space SPACES, cl_numfor(ga_table_data[p_i].field054,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  55  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field055 LET l_num = ga_table_data[p_i].field055 IF l_i = 0 AND ORD(ga_table_data[p_i].field055) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field055 = l_space SPACES, cl_numfor(ga_table_data[p_i].field055,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  56  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field056 LET l_num = ga_table_data[p_i].field056 IF l_i = 0 AND ORD(ga_table_data[p_i].field056) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field056 = l_space SPACES, cl_numfor(ga_table_data[p_i].field056,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  57  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field057 LET l_num = ga_table_data[p_i].field057 IF l_i = 0 AND ORD(ga_table_data[p_i].field057) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field057 = l_space SPACES, cl_numfor(ga_table_data[p_i].field057,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  58  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field058 LET l_num = ga_table_data[p_i].field058 IF l_i = 0 AND ORD(ga_table_data[p_i].field058) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field058 = l_space SPACES, cl_numfor(ga_table_data[p_i].field058,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  59  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field059 LET l_num = ga_table_data[p_i].field059 IF l_i = 0 AND ORD(ga_table_data[p_i].field059) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field059 = l_space SPACES, cl_numfor(ga_table_data[p_i].field059,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  60  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field060 LET l_num = ga_table_data[p_i].field060 IF l_i = 0 AND ORD(ga_table_data[p_i].field060) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field060 = l_space SPACES, cl_numfor(ga_table_data[p_i].field060,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  61  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field061 LET l_num = ga_table_data[p_i].field061 IF l_i = 0 AND ORD(ga_table_data[p_i].field061) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field061 = l_space SPACES, cl_numfor(ga_table_data[p_i].field061,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  62  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field062 LET l_num = ga_table_data[p_i].field062 IF l_i = 0 AND ORD(ga_table_data[p_i].field062) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field062 = l_space SPACES, cl_numfor(ga_table_data[p_i].field062,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  63  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field063 LET l_num = ga_table_data[p_i].field063 IF l_i = 0 AND ORD(ga_table_data[p_i].field063) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field063 = l_space SPACES, cl_numfor(ga_table_data[p_i].field063,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  64  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field064 LET l_num = ga_table_data[p_i].field064 IF l_i = 0 AND ORD(ga_table_data[p_i].field064) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field064 = l_space SPACES, cl_numfor(ga_table_data[p_i].field064,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  65  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field065 LET l_num = ga_table_data[p_i].field065 IF l_i = 0 AND ORD(ga_table_data[p_i].field065) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field065 = l_space SPACES, cl_numfor(ga_table_data[p_i].field065,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  66  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field066 LET l_num = ga_table_data[p_i].field066 IF l_i = 0 AND ORD(ga_table_data[p_i].field066) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field066 = l_space SPACES, cl_numfor(ga_table_data[p_i].field066,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  67  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field067 LET l_num = ga_table_data[p_i].field067 IF l_i = 0 AND ORD(ga_table_data[p_i].field067) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field067 = l_space SPACES, cl_numfor(ga_table_data[p_i].field067,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  68  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field068 LET l_num = ga_table_data[p_i].field068 IF l_i = 0 AND ORD(ga_table_data[p_i].field068) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field068 = l_space SPACES, cl_numfor(ga_table_data[p_i].field068,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  69  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field069 LET l_num = ga_table_data[p_i].field069 IF l_i = 0 AND ORD(ga_table_data[p_i].field069) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field069 = l_space SPACES, cl_numfor(ga_table_data[p_i].field069,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  70  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field070 LET l_num = ga_table_data[p_i].field070 IF l_i = 0 AND ORD(ga_table_data[p_i].field070) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field070 = l_space SPACES, cl_numfor(ga_table_data[p_i].field070,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  71  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field071 LET l_num = ga_table_data[p_i].field071 IF l_i = 0 AND ORD(ga_table_data[p_i].field071) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field071 = l_space SPACES, cl_numfor(ga_table_data[p_i].field071,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  72  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field072 LET l_num = ga_table_data[p_i].field072 IF l_i = 0 AND ORD(ga_table_data[p_i].field072) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field072 = l_space SPACES, cl_numfor(ga_table_data[p_i].field072,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  73  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field073 LET l_num = ga_table_data[p_i].field073 IF l_i = 0 AND ORD(ga_table_data[p_i].field073) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field073 = l_space SPACES, cl_numfor(ga_table_data[p_i].field073,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  74  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field074 LET l_num = ga_table_data[p_i].field074 IF l_i = 0 AND ORD(ga_table_data[p_i].field074) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field074 = l_space SPACES, cl_numfor(ga_table_data[p_i].field074,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  75  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field075 LET l_num = ga_table_data[p_i].field075 IF l_i = 0 AND ORD(ga_table_data[p_i].field075) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field075 = l_space SPACES, cl_numfor(ga_table_data[p_i].field075,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  76  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field076 LET l_num = ga_table_data[p_i].field076 IF l_i = 0 AND ORD(ga_table_data[p_i].field076) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field076 = l_space SPACES, cl_numfor(ga_table_data[p_i].field076,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  77  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field077 LET l_num = ga_table_data[p_i].field077 IF l_i = 0 AND ORD(ga_table_data[p_i].field077) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field077 = l_space SPACES, cl_numfor(ga_table_data[p_i].field077,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  78  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field078 LET l_num = ga_table_data[p_i].field078 IF l_i = 0 AND ORD(ga_table_data[p_i].field078) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field078 = l_space SPACES, cl_numfor(ga_table_data[p_i].field078,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  79  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field079 LET l_num = ga_table_data[p_i].field079 IF l_i = 0 AND ORD(ga_table_data[p_i].field079) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field079 = l_space SPACES, cl_numfor(ga_table_data[p_i].field079,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  80  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field080 LET l_num = ga_table_data[p_i].field080 IF l_i = 0 AND ORD(ga_table_data[p_i].field080) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field080 = l_space SPACES, cl_numfor(ga_table_data[p_i].field080,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  81  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field081 LET l_num = ga_table_data[p_i].field081 IF l_i = 0 AND ORD(ga_table_data[p_i].field081) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field081 = l_space SPACES, cl_numfor(ga_table_data[p_i].field081,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  82  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field082 LET l_num = ga_table_data[p_i].field082 IF l_i = 0 AND ORD(ga_table_data[p_i].field082) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field082 = l_space SPACES, cl_numfor(ga_table_data[p_i].field082,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  83  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field083 LET l_num = ga_table_data[p_i].field083 IF l_i = 0 AND ORD(ga_table_data[p_i].field083) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field083 = l_space SPACES, cl_numfor(ga_table_data[p_i].field083,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  84  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field084 LET l_num = ga_table_data[p_i].field084 IF l_i = 0 AND ORD(ga_table_data[p_i].field084) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field084 = l_space SPACES, cl_numfor(ga_table_data[p_i].field084,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  85  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field085 LET l_num = ga_table_data[p_i].field085 IF l_i = 0 AND ORD(ga_table_data[p_i].field085) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field085 = l_space SPACES, cl_numfor(ga_table_data[p_i].field085,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  86  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field086 LET l_num = ga_table_data[p_i].field086 IF l_i = 0 AND ORD(ga_table_data[p_i].field086) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field086 = l_space SPACES, cl_numfor(ga_table_data[p_i].field086,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  87  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field087 LET l_num = ga_table_data[p_i].field087 IF l_i = 0 AND ORD(ga_table_data[p_i].field087) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field087 = l_space SPACES, cl_numfor(ga_table_data[p_i].field087,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  88  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field088 LET l_num = ga_table_data[p_i].field088 IF l_i = 0 AND ORD(ga_table_data[p_i].field088) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field088 = l_space SPACES, cl_numfor(ga_table_data[p_i].field088,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  89  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field089 LET l_num = ga_table_data[p_i].field089 IF l_i = 0 AND ORD(ga_table_data[p_i].field089) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field089 = l_space SPACES, cl_numfor(ga_table_data[p_i].field089,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  90  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field090 LET l_num = ga_table_data[p_i].field090 IF l_i = 0 AND ORD(ga_table_data[p_i].field090) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field090 = l_space SPACES, cl_numfor(ga_table_data[p_i].field090,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  91  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field091 LET l_num = ga_table_data[p_i].field091 IF l_i = 0 AND ORD(ga_table_data[p_i].field091) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field091 = l_space SPACES, cl_numfor(ga_table_data[p_i].field091,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  92  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field092 LET l_num = ga_table_data[p_i].field092 IF l_i = 0 AND ORD(ga_table_data[p_i].field092) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field092 = l_space SPACES, cl_numfor(ga_table_data[p_i].field092,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  93  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field093 LET l_num = ga_table_data[p_i].field093 IF l_i = 0 AND ORD(ga_table_data[p_i].field093) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field093 = l_space SPACES, cl_numfor(ga_table_data[p_i].field093,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  94  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field094 LET l_num = ga_table_data[p_i].field094 IF l_i = 0 AND ORD(ga_table_data[p_i].field094) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field094 = l_space SPACES, cl_numfor(ga_table_data[p_i].field094,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  95  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field095 LET l_num = ga_table_data[p_i].field095 IF l_i = 0 AND ORD(ga_table_data[p_i].field095) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field095 = l_space SPACES, cl_numfor(ga_table_data[p_i].field095,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  96  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field096 LET l_num = ga_table_data[p_i].field096 IF l_i = 0 AND ORD(ga_table_data[p_i].field096) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field096 = l_space SPACES, cl_numfor(ga_table_data[p_i].field096,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  97  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field097 LET l_num = ga_table_data[p_i].field097 IF l_i = 0 AND ORD(ga_table_data[p_i].field097) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field097 = l_space SPACES, cl_numfor(ga_table_data[p_i].field097,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  98  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field098 LET l_num = ga_table_data[p_i].field098 IF l_i = 0 AND ORD(ga_table_data[p_i].field098) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field098 = l_space SPACES, cl_numfor(ga_table_data[p_i].field098,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN  99  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field099 LET l_num = ga_table_data[p_i].field099 IF l_i = 0 AND ORD(ga_table_data[p_i].field099) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field099 = l_space SPACES, cl_numfor(ga_table_data[p_i].field099,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 100  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field100 LET l_num = ga_table_data[p_i].field100 IF l_i = 0 AND ORD(ga_table_data[p_i].field100) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field100 = l_space SPACES, cl_numfor(ga_table_data[p_i].field100,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 101  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field101 LET l_num = ga_table_data[p_i].field101 IF l_i = 0 AND ORD(ga_table_data[p_i].field101) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field101 = l_space SPACES, cl_numfor(ga_table_data[p_i].field101,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 102  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field102 LET l_num = ga_table_data[p_i].field102 IF l_i = 0 AND ORD(ga_table_data[p_i].field102) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field102 = l_space SPACES, cl_numfor(ga_table_data[p_i].field102,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 103  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field103 LET l_num = ga_table_data[p_i].field103 IF l_i = 0 AND ORD(ga_table_data[p_i].field103) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field103 = l_space SPACES, cl_numfor(ga_table_data[p_i].field103,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 104  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field104 LET l_num = ga_table_data[p_i].field104 IF l_i = 0 AND ORD(ga_table_data[p_i].field104) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field104 = l_space SPACES, cl_numfor(ga_table_data[p_i].field104,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 105  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field105 LET l_num = ga_table_data[p_i].field105 IF l_i = 0 AND ORD(ga_table_data[p_i].field105) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field105 = l_space SPACES, cl_numfor(ga_table_data[p_i].field105,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 106  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field106 LET l_num = ga_table_data[p_i].field106 IF l_i = 0 AND ORD(ga_table_data[p_i].field106) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field106 = l_space SPACES, cl_numfor(ga_table_data[p_i].field106,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 107  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field107 LET l_num = ga_table_data[p_i].field107 IF l_i = 0 AND ORD(ga_table_data[p_i].field107) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field107 = l_space SPACES, cl_numfor(ga_table_data[p_i].field107,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 108  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field108 LET l_num = ga_table_data[p_i].field108 IF l_i = 0 AND ORD(ga_table_data[p_i].field108) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field108 = l_space SPACES, cl_numfor(ga_table_data[p_i].field108,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 109  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field109 LET l_num = ga_table_data[p_i].field109 IF l_i = 0 AND ORD(ga_table_data[p_i].field109) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field109 = l_space SPACES, cl_numfor(ga_table_data[p_i].field109,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 110  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field110 LET l_num = ga_table_data[p_i].field110 IF l_i = 0 AND ORD(ga_table_data[p_i].field110) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field110 = l_space SPACES, cl_numfor(ga_table_data[p_i].field110,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 111  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field111 LET l_num = ga_table_data[p_i].field111 IF l_i = 0 AND ORD(ga_table_data[p_i].field111) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field111 = l_space SPACES, cl_numfor(ga_table_data[p_i].field111,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 112  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field112 LET l_num = ga_table_data[p_i].field112 IF l_i = 0 AND ORD(ga_table_data[p_i].field112) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field112 = l_space SPACES, cl_numfor(ga_table_data[p_i].field112,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 113  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field113 LET l_num = ga_table_data[p_i].field113 IF l_i = 0 AND ORD(ga_table_data[p_i].field113) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field113 = l_space SPACES, cl_numfor(ga_table_data[p_i].field113,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 114  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field114 LET l_num = ga_table_data[p_i].field114 IF l_i = 0 AND ORD(ga_table_data[p_i].field114) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field114 = l_space SPACES, cl_numfor(ga_table_data[p_i].field114,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 115  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field115 LET l_num = ga_table_data[p_i].field115 IF l_i = 0 AND ORD(ga_table_data[p_i].field115) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field115 = l_space SPACES, cl_numfor(ga_table_data[p_i].field115,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 116  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field116 LET l_num = ga_table_data[p_i].field116 IF l_i = 0 AND ORD(ga_table_data[p_i].field116) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field116 = l_space SPACES, cl_numfor(ga_table_data[p_i].field116,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 117  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field117 LET l_num = ga_table_data[p_i].field117 IF l_i = 0 AND ORD(ga_table_data[p_i].field117) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field117 = l_space SPACES, cl_numfor(ga_table_data[p_i].field117,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 118  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field118 LET l_num = ga_table_data[p_i].field118 IF l_i = 0 AND ORD(ga_table_data[p_i].field118) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field118 = l_space SPACES, cl_numfor(ga_table_data[p_i].field118,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 119  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field119 LET l_num = ga_table_data[p_i].field119 IF l_i = 0 AND ORD(ga_table_data[p_i].field119) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field119 = l_space SPACES, cl_numfor(ga_table_data[p_i].field119,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 120  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field120 LET l_num = ga_table_data[p_i].field120 IF l_i = 0 AND ORD(ga_table_data[p_i].field120) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field120 = l_space SPACES, cl_numfor(ga_table_data[p_i].field120,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 121  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field121 LET l_num = ga_table_data[p_i].field121 IF l_i = 0 AND ORD(ga_table_data[p_i].field121) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field121 = l_space SPACES, cl_numfor(ga_table_data[p_i].field121,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 122  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field122 LET l_num = ga_table_data[p_i].field122 IF l_i = 0 AND ORD(ga_table_data[p_i].field122) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field122 = l_space SPACES, cl_numfor(ga_table_data[p_i].field122,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 123  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field123 LET l_num = ga_table_data[p_i].field123 IF l_i = 0 AND ORD(ga_table_data[p_i].field123) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field123 = l_space SPACES, cl_numfor(ga_table_data[p_i].field123,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 124  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field124 LET l_num = ga_table_data[p_i].field124 IF l_i = 0 AND ORD(ga_table_data[p_i].field124) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field124 = l_space SPACES, cl_numfor(ga_table_data[p_i].field124,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 125  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field125 LET l_num = ga_table_data[p_i].field125 IF l_i = 0 AND ORD(ga_table_data[p_i].field125) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field125 = l_space SPACES, cl_numfor(ga_table_data[p_i].field125,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 126  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field126 LET l_num = ga_table_data[p_i].field126 IF l_i = 0 AND ORD(ga_table_data[p_i].field126) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field126 = l_space SPACES, cl_numfor(ga_table_data[p_i].field126,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 127  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field127 LET l_num = ga_table_data[p_i].field127 IF l_i = 0 AND ORD(ga_table_data[p_i].field127) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field127 = l_space SPACES, cl_numfor(ga_table_data[p_i].field127,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 128  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field128 LET l_num = ga_table_data[p_i].field128 IF l_i = 0 AND ORD(ga_table_data[p_i].field128) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field128 = l_space SPACES, cl_numfor(ga_table_data[p_i].field128,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 129  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field129 LET l_num = ga_table_data[p_i].field129 IF l_i = 0 AND ORD(ga_table_data[p_i].field129) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field129 = l_space SPACES, cl_numfor(ga_table_data[p_i].field129,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 130  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field130 LET l_num = ga_table_data[p_i].field130 IF l_i = 0 AND ORD(ga_table_data[p_i].field130) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field130 = l_space SPACES, cl_numfor(ga_table_data[p_i].field130,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 131  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field131 LET l_num = ga_table_data[p_i].field131 IF l_i = 0 AND ORD(ga_table_data[p_i].field131) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field131 = l_space SPACES, cl_numfor(ga_table_data[p_i].field131,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 132  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field132 LET l_num = ga_table_data[p_i].field132 IF l_i = 0 AND ORD(ga_table_data[p_i].field132) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field132 = l_space SPACES, cl_numfor(ga_table_data[p_i].field132,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 133  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field133 LET l_num = ga_table_data[p_i].field133 IF l_i = 0 AND ORD(ga_table_data[p_i].field133) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field133 = l_space SPACES, cl_numfor(ga_table_data[p_i].field133,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 134  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field134 LET l_num = ga_table_data[p_i].field134 IF l_i = 0 AND ORD(ga_table_data[p_i].field134) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field134 = l_space SPACES, cl_numfor(ga_table_data[p_i].field134,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 135  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field135 LET l_num = ga_table_data[p_i].field135 IF l_i = 0 AND ORD(ga_table_data[p_i].field135) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field135 = l_space SPACES, cl_numfor(ga_table_data[p_i].field135,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 136  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field136 LET l_num = ga_table_data[p_i].field136 IF l_i = 0 AND ORD(ga_table_data[p_i].field136) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field136 = l_space SPACES, cl_numfor(ga_table_data[p_i].field136,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 137  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field137 LET l_num = ga_table_data[p_i].field137 IF l_i = 0 AND ORD(ga_table_data[p_i].field137) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field137 = l_space SPACES, cl_numfor(ga_table_data[p_i].field137,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 138  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field138 LET l_num = ga_table_data[p_i].field138 IF l_i = 0 AND ORD(ga_table_data[p_i].field138) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field138 = l_space SPACES, cl_numfor(ga_table_data[p_i].field138,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 139  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field139 LET l_num = ga_table_data[p_i].field139 IF l_i = 0 AND ORD(ga_table_data[p_i].field139) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field139 = l_space SPACES, cl_numfor(ga_table_data[p_i].field139,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 140  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field140 LET l_num = ga_table_data[p_i].field140 IF l_i = 0 AND ORD(ga_table_data[p_i].field140) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field140 = l_space SPACES, cl_numfor(ga_table_data[p_i].field140,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 141  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field141 LET l_num = ga_table_data[p_i].field141 IF l_i = 0 AND ORD(ga_table_data[p_i].field141) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field141 = l_space SPACES, cl_numfor(ga_table_data[p_i].field141,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 142  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field142 LET l_num = ga_table_data[p_i].field142 IF l_i = 0 AND ORD(ga_table_data[p_i].field142) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field142 = l_space SPACES, cl_numfor(ga_table_data[p_i].field142,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 143  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field143 LET l_num = ga_table_data[p_i].field143 IF l_i = 0 AND ORD(ga_table_data[p_i].field143) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field143 = l_space SPACES, cl_numfor(ga_table_data[p_i].field143,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 144  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field144 LET l_num = ga_table_data[p_i].field144 IF l_i = 0 AND ORD(ga_table_data[p_i].field144) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field144 = l_space SPACES, cl_numfor(ga_table_data[p_i].field144,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 145  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field145 LET l_num = ga_table_data[p_i].field145 IF l_i = 0 AND ORD(ga_table_data[p_i].field145) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field145 = l_space SPACES, cl_numfor(ga_table_data[p_i].field145,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 146  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field146 LET l_num = ga_table_data[p_i].field146 IF l_i = 0 AND ORD(ga_table_data[p_i].field146) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field146 = l_space SPACES, cl_numfor(ga_table_data[p_i].field146,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 147  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field147 LET l_num = ga_table_data[p_i].field147 IF l_i = 0 AND ORD(ga_table_data[p_i].field147) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field147 = l_space SPACES, cl_numfor(ga_table_data[p_i].field147,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 148  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field148 LET l_num = ga_table_data[p_i].field148 IF l_i = 0 AND ORD(ga_table_data[p_i].field148) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field148 = l_space SPACES, cl_numfor(ga_table_data[p_i].field148,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 149  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field149 LET l_num = ga_table_data[p_i].field149 IF l_i = 0 AND ORD(ga_table_data[p_i].field149) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field149 = l_space SPACES, cl_numfor(ga_table_data[p_i].field149,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 150  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field150 LET l_num = ga_table_data[p_i].field150 IF l_i = 0 AND ORD(ga_table_data[p_i].field150) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field150 = l_space SPACES, cl_numfor(ga_table_data[p_i].field150,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 151  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field151 LET l_num = ga_table_data[p_i].field151 IF l_i = 0 AND ORD(ga_table_data[p_i].field151) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field151 = l_space SPACES, cl_numfor(ga_table_data[p_i].field151,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 152  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field152 LET l_num = ga_table_data[p_i].field152 IF l_i = 0 AND ORD(ga_table_data[p_i].field152) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field152 = l_space SPACES, cl_numfor(ga_table_data[p_i].field152,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 153  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field153 LET l_num = ga_table_data[p_i].field153 IF l_i = 0 AND ORD(ga_table_data[p_i].field153) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field153 = l_space SPACES, cl_numfor(ga_table_data[p_i].field153,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 154  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field154 LET l_num = ga_table_data[p_i].field154 IF l_i = 0 AND ORD(ga_table_data[p_i].field154) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field154 = l_space SPACES, cl_numfor(ga_table_data[p_i].field154,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 155  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field155 LET l_num = ga_table_data[p_i].field155 IF l_i = 0 AND ORD(ga_table_data[p_i].field155) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field155 = l_space SPACES, cl_numfor(ga_table_data[p_i].field155,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 156  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field156 LET l_num = ga_table_data[p_i].field156 IF l_i = 0 AND ORD(ga_table_data[p_i].field156) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field156 = l_space SPACES, cl_numfor(ga_table_data[p_i].field156,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 157  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field157 LET l_num = ga_table_data[p_i].field157 IF l_i = 0 AND ORD(ga_table_data[p_i].field157) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field157 = l_space SPACES, cl_numfor(ga_table_data[p_i].field157,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 158  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field158 LET l_num = ga_table_data[p_i].field158 IF l_i = 0 AND ORD(ga_table_data[p_i].field158) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field158 = l_space SPACES, cl_numfor(ga_table_data[p_i].field158,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 159  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field159 LET l_num = ga_table_data[p_i].field159 IF l_i = 0 AND ORD(ga_table_data[p_i].field159) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field159 = l_space SPACES, cl_numfor(ga_table_data[p_i].field159,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 160  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field160 LET l_num = ga_table_data[p_i].field160 IF l_i = 0 AND ORD(ga_table_data[p_i].field160) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field160 = l_space SPACES, cl_numfor(ga_table_data[p_i].field160,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 161  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field161 LET l_num = ga_table_data[p_i].field161 IF l_i = 0 AND ORD(ga_table_data[p_i].field161) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field161 = l_space SPACES, cl_numfor(ga_table_data[p_i].field161,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 162  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field162 LET l_num = ga_table_data[p_i].field162 IF l_i = 0 AND ORD(ga_table_data[p_i].field162) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field162 = l_space SPACES, cl_numfor(ga_table_data[p_i].field162,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 163  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field163 LET l_num = ga_table_data[p_i].field163 IF l_i = 0 AND ORD(ga_table_data[p_i].field163) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field163 = l_space SPACES, cl_numfor(ga_table_data[p_i].field163,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 164  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field164 LET l_num = ga_table_data[p_i].field164 IF l_i = 0 AND ORD(ga_table_data[p_i].field164) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field164 = l_space SPACES, cl_numfor(ga_table_data[p_i].field164,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 165  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field165 LET l_num = ga_table_data[p_i].field165 IF l_i = 0 AND ORD(ga_table_data[p_i].field165) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field165 = l_space SPACES, cl_numfor(ga_table_data[p_i].field165,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 166  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field166 LET l_num = ga_table_data[p_i].field166 IF l_i = 0 AND ORD(ga_table_data[p_i].field166) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field166 = l_space SPACES, cl_numfor(ga_table_data[p_i].field166,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 167  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field167 LET l_num = ga_table_data[p_i].field167 IF l_i = 0 AND ORD(ga_table_data[p_i].field167) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field167 = l_space SPACES, cl_numfor(ga_table_data[p_i].field167,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 168  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field168 LET l_num = ga_table_data[p_i].field168 IF l_i = 0 AND ORD(ga_table_data[p_i].field168) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field168 = l_space SPACES, cl_numfor(ga_table_data[p_i].field168,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 169  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field169 LET l_num = ga_table_data[p_i].field169 IF l_i = 0 AND ORD(ga_table_data[p_i].field169) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field169 = l_space SPACES, cl_numfor(ga_table_data[p_i].field169,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 170  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field170 LET l_num = ga_table_data[p_i].field170 IF l_i = 0 AND ORD(ga_table_data[p_i].field170) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field170 = l_space SPACES, cl_numfor(ga_table_data[p_i].field170,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 171  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field171 LET l_num = ga_table_data[p_i].field171 IF l_i = 0 AND ORD(ga_table_data[p_i].field171) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field171 = l_space SPACES, cl_numfor(ga_table_data[p_i].field171,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 172  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field172 LET l_num = ga_table_data[p_i].field172 IF l_i = 0 AND ORD(ga_table_data[p_i].field172) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field172 = l_space SPACES, cl_numfor(ga_table_data[p_i].field172,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 173  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field173 LET l_num = ga_table_data[p_i].field173 IF l_i = 0 AND ORD(ga_table_data[p_i].field173) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field173 = l_space SPACES, cl_numfor(ga_table_data[p_i].field173,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 174  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field174 LET l_num = ga_table_data[p_i].field174 IF l_i = 0 AND ORD(ga_table_data[p_i].field174) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field174 = l_space SPACES, cl_numfor(ga_table_data[p_i].field174,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 175  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field175 LET l_num = ga_table_data[p_i].field175 IF l_i = 0 AND ORD(ga_table_data[p_i].field175) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field175 = l_space SPACES, cl_numfor(ga_table_data[p_i].field175,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 176  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field176 LET l_num = ga_table_data[p_i].field176 IF l_i = 0 AND ORD(ga_table_data[p_i].field176) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field176 = l_space SPACES, cl_numfor(ga_table_data[p_i].field176,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 177  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field177 LET l_num = ga_table_data[p_i].field177 IF l_i = 0 AND ORD(ga_table_data[p_i].field177) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field177 = l_space SPACES, cl_numfor(ga_table_data[p_i].field177,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 178  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field178 LET l_num = ga_table_data[p_i].field178 IF l_i = 0 AND ORD(ga_table_data[p_i].field178) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field178 = l_space SPACES, cl_numfor(ga_table_data[p_i].field178,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 179  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field179 LET l_num = ga_table_data[p_i].field179 IF l_i = 0 AND ORD(ga_table_data[p_i].field179) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field179 = l_space SPACES, cl_numfor(ga_table_data[p_i].field179,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 180  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field180 LET l_num = ga_table_data[p_i].field180 IF l_i = 0 AND ORD(ga_table_data[p_i].field180) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field180 = l_space SPACES, cl_numfor(ga_table_data[p_i].field180,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 181  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field181 LET l_num = ga_table_data[p_i].field181 IF l_i = 0 AND ORD(ga_table_data[p_i].field181) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field181 = l_space SPACES, cl_numfor(ga_table_data[p_i].field181,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 182  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field182 LET l_num = ga_table_data[p_i].field182 IF l_i = 0 AND ORD(ga_table_data[p_i].field182) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field182 = l_space SPACES, cl_numfor(ga_table_data[p_i].field182,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 183  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field183 LET l_num = ga_table_data[p_i].field183 IF l_i = 0 AND ORD(ga_table_data[p_i].field183) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field183 = l_space SPACES, cl_numfor(ga_table_data[p_i].field183,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 184  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field184 LET l_num = ga_table_data[p_i].field184 IF l_i = 0 AND ORD(ga_table_data[p_i].field184) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field184 = l_space SPACES, cl_numfor(ga_table_data[p_i].field184,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 185  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field185 LET l_num = ga_table_data[p_i].field185 IF l_i = 0 AND ORD(ga_table_data[p_i].field185) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field185 = l_space SPACES, cl_numfor(ga_table_data[p_i].field185,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 186  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field186 LET l_num = ga_table_data[p_i].field186 IF l_i = 0 AND ORD(ga_table_data[p_i].field186) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field186 = l_space SPACES, cl_numfor(ga_table_data[p_i].field186,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 187  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field187 LET l_num = ga_table_data[p_i].field187 IF l_i = 0 AND ORD(ga_table_data[p_i].field187) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field187 = l_space SPACES, cl_numfor(ga_table_data[p_i].field187,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 188  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field188 LET l_num = ga_table_data[p_i].field188 IF l_i = 0 AND ORD(ga_table_data[p_i].field188) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field188 = l_space SPACES, cl_numfor(ga_table_data[p_i].field188,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 189  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field189 LET l_num = ga_table_data[p_i].field189 IF l_i = 0 AND ORD(ga_table_data[p_i].field189) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field189 = l_space SPACES, cl_numfor(ga_table_data[p_i].field189,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 190  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field190 LET l_num = ga_table_data[p_i].field190 IF l_i = 0 AND ORD(ga_table_data[p_i].field190) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field190 = l_space SPACES, cl_numfor(ga_table_data[p_i].field190,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 191  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field191 LET l_num = ga_table_data[p_i].field191 IF l_i = 0 AND ORD(ga_table_data[p_i].field191) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field191 = l_space SPACES, cl_numfor(ga_table_data[p_i].field191,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 192  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field192 LET l_num = ga_table_data[p_i].field192 IF l_i = 0 AND ORD(ga_table_data[p_i].field192) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field192 = l_space SPACES, cl_numfor(ga_table_data[p_i].field192,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 193  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field193 LET l_num = ga_table_data[p_i].field193 IF l_i = 0 AND ORD(ga_table_data[p_i].field193) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field193 = l_space SPACES, cl_numfor(ga_table_data[p_i].field193,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 194  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field194 LET l_num = ga_table_data[p_i].field194 IF l_i = 0 AND ORD(ga_table_data[p_i].field194) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field194 = l_space SPACES, cl_numfor(ga_table_data[p_i].field194,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 195  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field195 LET l_num = ga_table_data[p_i].field195 IF l_i = 0 AND ORD(ga_table_data[p_i].field195) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field195 = l_space SPACES, cl_numfor(ga_table_data[p_i].field195,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 196  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field196 LET l_num = ga_table_data[p_i].field196 IF l_i = 0 AND ORD(ga_table_data[p_i].field196) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field196 = l_space SPACES, cl_numfor(ga_table_data[p_i].field196,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 197  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field197 LET l_num = ga_table_data[p_i].field197 IF l_i = 0 AND ORD(ga_table_data[p_i].field197) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field197 = l_space SPACES, cl_numfor(ga_table_data[p_i].field197,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 198  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field198 LET l_num = ga_table_data[p_i].field198 IF l_i = 0 AND ORD(ga_table_data[p_i].field198) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field198 = l_space SPACES, cl_numfor(ga_table_data[p_i].field198,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 199  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field199 LET l_num = ga_table_data[p_i].field199 IF l_i = 0 AND ORD(ga_table_data[p_i].field199) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field199 = l_space SPACES, cl_numfor(ga_table_data[p_i].field199,l_len-1,g_qry_scale[p_k]) END IF
   #WHEN 200  IF (g_qry_scale[p_k]>= 0 ) THEN LET l_i = ga_table_data[p_i].field200 LET l_num = ga_table_data[p_i].field200 IF l_i = 0 AND ORD(ga_table_data[p_i].field200) <> 48 AND cl_null(l_num) THEN EXIT CASE END IF LET ga_table_data[p_i].field200 = l_space SPACES, cl_numfor(ga_table_data[p_i].field200,l_len-1,g_qry_scale[p_k]) END IF
   END CASE
   #TQC-BB0068 -  End  -
   #END TQC-790050
   #END No.FUN-810062
   #END No.FUN-920079
 
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 依照 p_query 設定進行 SUM 處理, 計算 total sum OR group sum 
# Date & Author..:
# Input Parameter: p_k,p_i
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_sum_rec(p_k,p_i)
DEFINE p_k            LIKE type_file.num10       #目前check的欄位
DEFINE p_i            LIKE type_file.num10       #目前check的筆數
DEFINE l_value        LIKE type_file.num26_10
 
      CASE p_k 
       WHEN   1 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field001) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field001 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN   2 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field002) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field002 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN   3 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field003) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field003 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN   4 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field004) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field004 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN   5 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field005) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field005 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN   6 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field006) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field006 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN   7 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field007) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field007 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN   8 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field008) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field008 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN   9 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field009) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field009 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  10 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field010) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field010 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  11 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field011) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field011 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  12 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field012) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field012 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  13 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field013) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field013 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  14 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field014) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field014 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  15 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field015) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field015 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  16 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field016) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field016 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  17 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field017) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field017 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  18 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field018) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field018 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  19 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field019) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field019 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  20 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field020) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field020 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  21 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field021) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field021 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  22 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field022) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field022 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  23 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field023) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field023 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  24 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field024) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field024 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  25 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field025) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field025 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  26 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field026) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field026 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  27 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field027) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field027 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  28 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field028) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field028 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  29 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field029) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field029 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  30 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field030) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field030 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  31 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field031) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field031 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  32 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field032) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field032 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  33 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field033) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field033 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  34 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field034) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field034 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  35 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field035) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field035 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  36 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field036) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field036 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  37 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field037) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field037 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  38 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field038) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field038 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  39 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field039) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field039 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  40 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field040) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field040 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  41 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field041) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field041 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  42 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field042) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field042 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  43 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field043) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field043 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  44 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field044) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field044 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  45 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field045) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field045 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  46 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field046) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field046 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  47 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field047) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field047 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  48 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field048) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field048 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  49 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field049) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field049 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  50 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field050) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field050 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  51 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field051) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field051 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  52 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field052) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field052 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  53 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field053) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field053 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  54 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field054) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field054 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  55 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field055) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field055 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  56 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field056) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field056 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  57 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field057) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field057 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  58 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field058) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field058 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  59 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field059) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field059 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  60 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field060) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field060 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  61 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field061) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field061 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  62 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field062) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field062 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  63 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field063) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field063 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  64 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field064) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field064 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  65 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field065) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field065 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  66 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field066) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field066 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  67 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field067) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field067 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  68 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field068) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field068 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  69 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field069) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field069 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  70 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field070) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field070 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  71 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field071) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field071 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  72 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field072) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field072 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  73 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field073) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field073 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  74 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field074) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field074 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  75 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field075) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field075 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  76 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field076) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field076 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  77 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field077) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field077 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  78 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field078) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field078 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  79 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field079) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field079 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  80 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field080) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field080 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  81 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field081) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field081 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  82 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field082) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field082 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  83 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field083) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field083 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  84 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field084) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field084 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  85 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field085) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field085 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  86 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field086) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field086 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  87 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field087) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field087 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  88 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field088) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field088 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  89 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field089) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field089 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  90 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field090) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field090 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  91 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field091) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field091 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  92 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field092) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field092 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  93 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field093) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field093 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  94 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field094) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field094 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  95 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field095) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field095 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  96 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field096) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field096 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  97 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field097) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field097 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  98 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field098) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field098 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN  99 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field099) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field099 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
       WHEN 100 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field100) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field100 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 101 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field101) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field101 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 102 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field102) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field102 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 103 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field103) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field103 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 104 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field104) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field104 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 105 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field105) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field105 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 106 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field106) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field106 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 107 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field107) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field107 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 108 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field108) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field108 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 109 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field109) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field109 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 110 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field110) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field110 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 111 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field111) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field111 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 112 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field112) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field112 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 113 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field113) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field113 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 114 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field114) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field114 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 115 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field115) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field115 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 116 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field116) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field116 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 117 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field117) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field117 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 118 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field118) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field118 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 119 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field119) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field119 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 120 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field120) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field120 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 121 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field121) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field121 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 122 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field122) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field122 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 123 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field123) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field123 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 124 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field124) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field124 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 125 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field125) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field125 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 126 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field126) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field126 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 127 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field127) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field127 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 128 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field128) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field128 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 129 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field129) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field129 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 130 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field130) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field130 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 131 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field131) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field131 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 132 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field132) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field132 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 133 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field133) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field133 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 134 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field134) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field134 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 135 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field135) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field135 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 136 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field136) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field136 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 137 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field137) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field137 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 138 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field138) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field138 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 139 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field139) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field139 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 140 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field140) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field140 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 141 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field141) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field141 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 142 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field142) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field142 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 143 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field143) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field143 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 144 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field144) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field144 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 145 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field145) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field145 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 146 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field146) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field146 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 147 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field147) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field147 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 148 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field148) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field148 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 149 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field149) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field149 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 150 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field150) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field150 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 151 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field151) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field151 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 152 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field152) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field152 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 153 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field153) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field153 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 154 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field154) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field154 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 155 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field155) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field155 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 156 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field156) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field156 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 157 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field157) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field157 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 158 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field158) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field158 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 159 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field159) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field159 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 160 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field160) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field160 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 161 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field161) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field161 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 162 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field162) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field162 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 163 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field163) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field163 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 164 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field164) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field164 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 165 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field165) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field165 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 166 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field166) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field166 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 167 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field167) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field167 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 168 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field168) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field168 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 169 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field169) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field169 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 170 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field170) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field170 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 171 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field171) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field171 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 172 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field172) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field172 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 173 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field173) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field173 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 174 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field174) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field174 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 175 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field175) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field175 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 176 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field176) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field176 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 177 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field177) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field177 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 178 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field178) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field178 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 179 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field179) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field179 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 180 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field180) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field180 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 181 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field181) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field181 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 182 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field182) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field182 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 183 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field183) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field183 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 184 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field184) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field184 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 185 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field185) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field185 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 186 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field186) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field186 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 187 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field187) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field187 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 188 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field188) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field188 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 189 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field189) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field189 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 190 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field190) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field190 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 191 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field191) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field191 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 192 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field192) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field192 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 193 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field193) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field193 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 194 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field194) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field194 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 195 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field195) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field195 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 196 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field196) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field196 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 197 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field197) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field197 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 198 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field198) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field198 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 199 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field199) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field199 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
      #WHEN 200 IF (g_feld_sum[p_k].getLength() > 0) THEN IF cl_null(ga_table_data[p_i].field200) THEN LET l_value = 0 ELSE LET l_value = ga_table_data[p_i].field200 END IF LET g_sum_rec[p_k].group_item=g_sum_rec[p_k].group_item + 1 LET g_sum_rec[p_k].group_sum = g_sum_rec[p_k].group_sum + l_value LET g_sum_rec[p_k].total_item = g_sum_rec[p_k].total_item + 1 LET g_sum_rec[p_k].total_sum = g_sum_rec[p_k].total_sum + l_value   END IF
     END CASE
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 依照 p_query 設定檢查是否產生 SUM 資料 
# Date & Author..:
# Input Parameter: p_k,p_i
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_sum_check(p_k,p_i) 
DEFINE p_k             LIKE type_file.num5        #目前check的欄位
DEFINE p_i             LIKE type_file.num10       #目前check的ROW
DEFINE l_n             LIKE type_file.num5        #greoup 欄位位置
DEFINE l_i             LIKE type_file.num5
DEFINE l_tag           LIKE type_file.num5
DEFINE l_str           LIKE gaq_file.gaq03
DEFINE l_zan03         LIKE zan_file.zan03
DEFINE l_zan03_type    LIKE zan_file.zan03
DEFINE l_status        LIKE type_file.num5
DEFINE l_sum_name      STRING
 
 LET l_zan03 =""
 LET l_tag = 0
 IF g_zan_cnt > 0 AND (g_feld_sum[p_k].getLength() > 0) THEN
    FOR l_n = 1 TO g_qry_feld.getLength()
      IF l_n = g_feld_sum[p_k].getLength() THEN
         #cl_query_sum_check2(group欄位位置,目前check的ROW)
         CALL cl_query_sum_check2(l_n,p_i) RETURNING l_tag,l_str
         EXIT FOR
      END IF
    END FOR
 ELSE 
    #GROUP 跳頁check
    #cl_query_sum_check2(group欄位位置,field欄位位置)
    CALL cl_query_sum_check2(p_k,p_i) RETURNING l_tag,l_str
    IF l_tag <> 0 THEN
       FOR l_i = 1 TO g_zam.getLength()
          IF g_zam[l_i].zal04 = g_qry_feld_t[p_k] THEN
             IF g_zam[l_i].zam07 = 'Y' THEN
                LET g_next_tag = 'Y'
             END IF
          END IF
       END FOR
       LET l_tag = 0 
    END IF
 END IF
 
 IF l_tag = 0 THEN
    RETURN 0,'','','',''
 END IF 
 
 FOR l_i = 1 TO g_zam.getLength()
    IF g_zam[l_i].zal04 = g_qry_feld_t[l_n] THEN
       IF g_zam[l_i].zam07 = 'Y' THEN
          LET g_next_tag = 'Y'
       END IF
    END IF
 END FOR
 
#CALL cl_query_sum(目前所在的行數,目前所在的欄位,check的group欄位,
#                  check的group欄位)
 CALL cl_query_sum(p_i,p_k,l_str,l_n) 
      RETURNING l_status,l_str,l_zan03,l_zan03_type,l_sum_name
 
 LET ga_table_data[p_i+1].field001=''
 
 RETURN l_status,l_str,l_zan03,l_zan03_type,l_sum_name
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 判斷是否需產生 sum資料
# Date & Author..:
# Input Parameter: p_n,p_i
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_sum_check2(p_n,p_i) 
DEFINE p_i       LIKE type_file.num10        #目前check的欄位
DEFINE p_n       LIKE type_file.num5
DEFINE l_str     LIKE gaq_file.gaq03
DEFINE l_tag     LIKE type_file.num5
 
 LET l_tag = 0
  
      #判斷需計算sum
      CASE p_n 
       WHEN   1 IF ga_table_data[p_i].field001 <> ga_page_data_t.field001 OR ga_table_data[p_i].field001 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field001 END IF
       WHEN   2 IF ga_table_data[p_i].field002 <> ga_page_data_t.field002 OR ga_table_data[p_i].field002 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field002 END IF
       WHEN   3 IF ga_table_data[p_i].field003 <> ga_page_data_t.field003 OR ga_table_data[p_i].field003 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field003 END IF
       WHEN   4 IF ga_table_data[p_i].field004 <> ga_page_data_t.field004 OR ga_table_data[p_i].field004 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field004 END IF
       WHEN   5 IF ga_table_data[p_i].field005 <> ga_page_data_t.field005 OR ga_table_data[p_i].field005 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field005 END IF
       WHEN   6 IF ga_table_data[p_i].field006 <> ga_page_data_t.field006 OR ga_table_data[p_i].field006 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field006 END IF
       WHEN   7 IF ga_table_data[p_i].field007 <> ga_page_data_t.field007 OR ga_table_data[p_i].field007 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field007 END IF
       WHEN   8 IF ga_table_data[p_i].field008 <> ga_page_data_t.field008 OR ga_table_data[p_i].field008 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field008 END IF
       WHEN   9 IF ga_table_data[p_i].field009 <> ga_page_data_t.field009 OR ga_table_data[p_i].field009 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field009 END IF
       WHEN  10 IF ga_table_data[p_i].field010 <> ga_page_data_t.field010 OR ga_table_data[p_i].field010 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field010 END IF
       WHEN  11 IF ga_table_data[p_i].field011 <> ga_page_data_t.field011 OR ga_table_data[p_i].field011 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field011 END IF
       WHEN  12 IF ga_table_data[p_i].field012 <> ga_page_data_t.field012 OR ga_table_data[p_i].field012 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field012 END IF
       WHEN  13 IF ga_table_data[p_i].field013 <> ga_page_data_t.field013 OR ga_table_data[p_i].field013 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field013 END IF
       WHEN  14 IF ga_table_data[p_i].field014 <> ga_page_data_t.field014 OR ga_table_data[p_i].field014 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field014 END IF
       WHEN  15 IF ga_table_data[p_i].field015 <> ga_page_data_t.field015 OR ga_table_data[p_i].field015 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field015 END IF
       WHEN  16 IF ga_table_data[p_i].field016 <> ga_page_data_t.field016 OR ga_table_data[p_i].field016 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field016 END IF
       WHEN  17 IF ga_table_data[p_i].field017 <> ga_page_data_t.field017 OR ga_table_data[p_i].field017 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field017 END IF
       WHEN  18 IF ga_table_data[p_i].field018 <> ga_page_data_t.field018 OR ga_table_data[p_i].field018 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field018 END IF
       WHEN  19 IF ga_table_data[p_i].field019 <> ga_page_data_t.field019 OR ga_table_data[p_i].field019 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field019 END IF
       WHEN  20 IF ga_table_data[p_i].field020 <> ga_page_data_t.field020 OR ga_table_data[p_i].field020 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field020 END IF
       WHEN  21 IF ga_table_data[p_i].field021 <> ga_page_data_t.field021 OR ga_table_data[p_i].field021 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field021 END IF
       WHEN  22 IF ga_table_data[p_i].field022 <> ga_page_data_t.field022 OR ga_table_data[p_i].field022 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field022 END IF
       WHEN  23 IF ga_table_data[p_i].field023 <> ga_page_data_t.field023 OR ga_table_data[p_i].field023 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field023 END IF
       WHEN  24 IF ga_table_data[p_i].field024 <> ga_page_data_t.field024 OR ga_table_data[p_i].field024 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field024 END IF
       WHEN  25 IF ga_table_data[p_i].field025 <> ga_page_data_t.field025 OR ga_table_data[p_i].field025 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field025 END IF
       WHEN  26 IF ga_table_data[p_i].field026 <> ga_page_data_t.field026 OR ga_table_data[p_i].field026 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field026 END IF
       WHEN  27 IF ga_table_data[p_i].field027 <> ga_page_data_t.field027 OR ga_table_data[p_i].field027 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field027 END IF
       WHEN  28 IF ga_table_data[p_i].field028 <> ga_page_data_t.field028 OR ga_table_data[p_i].field028 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field028 END IF
       WHEN  29 IF ga_table_data[p_i].field029 <> ga_page_data_t.field029 OR ga_table_data[p_i].field029 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field029 END IF
       WHEN  30 IF ga_table_data[p_i].field030 <> ga_page_data_t.field030 OR ga_table_data[p_i].field030 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field030 END IF
       WHEN  31 IF ga_table_data[p_i].field031 <> ga_page_data_t.field031 OR ga_table_data[p_i].field031 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field031 END IF
       WHEN  32 IF ga_table_data[p_i].field032 <> ga_page_data_t.field032 OR ga_table_data[p_i].field032 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field032 END IF
       WHEN  33 IF ga_table_data[p_i].field033 <> ga_page_data_t.field033 OR ga_table_data[p_i].field033 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field033 END IF
       WHEN  34 IF ga_table_data[p_i].field034 <> ga_page_data_t.field034 OR ga_table_data[p_i].field034 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field034 END IF
       WHEN  35 IF ga_table_data[p_i].field035 <> ga_page_data_t.field035 OR ga_table_data[p_i].field035 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field035 END IF
       WHEN  36 IF ga_table_data[p_i].field036 <> ga_page_data_t.field036 OR ga_table_data[p_i].field036 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field036 END IF
       WHEN  37 IF ga_table_data[p_i].field037 <> ga_page_data_t.field037 OR ga_table_data[p_i].field037 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field037 END IF
       WHEN  38 IF ga_table_data[p_i].field038 <> ga_page_data_t.field038 OR ga_table_data[p_i].field038 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field038 END IF
       WHEN  39 IF ga_table_data[p_i].field039 <> ga_page_data_t.field039 OR ga_table_data[p_i].field039 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field039 END IF
       WHEN  40 IF ga_table_data[p_i].field040 <> ga_page_data_t.field040 OR ga_table_data[p_i].field040 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field040 END IF
       WHEN  41 IF ga_table_data[p_i].field041 <> ga_page_data_t.field041 OR ga_table_data[p_i].field041 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field041 END IF
       WHEN  42 IF ga_table_data[p_i].field042 <> ga_page_data_t.field042 OR ga_table_data[p_i].field042 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field042 END IF
       WHEN  43 IF ga_table_data[p_i].field043 <> ga_page_data_t.field043 OR ga_table_data[p_i].field043 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field043 END IF
       WHEN  44 IF ga_table_data[p_i].field044 <> ga_page_data_t.field044 OR ga_table_data[p_i].field044 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field044 END IF
       WHEN  45 IF ga_table_data[p_i].field045 <> ga_page_data_t.field045 OR ga_table_data[p_i].field045 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field045 END IF
       WHEN  46 IF ga_table_data[p_i].field046 <> ga_page_data_t.field046 OR ga_table_data[p_i].field046 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field046 END IF
       WHEN  47 IF ga_table_data[p_i].field047 <> ga_page_data_t.field047 OR ga_table_data[p_i].field047 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field047 END IF
       WHEN  48 IF ga_table_data[p_i].field048 <> ga_page_data_t.field048 OR ga_table_data[p_i].field048 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field048 END IF
       WHEN  49 IF ga_table_data[p_i].field049 <> ga_page_data_t.field049 OR ga_table_data[p_i].field049 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field049 END IF
       WHEN  50 IF ga_table_data[p_i].field050 <> ga_page_data_t.field050 OR ga_table_data[p_i].field050 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field050 END IF
       WHEN  51 IF ga_table_data[p_i].field051 <> ga_page_data_t.field051 OR ga_table_data[p_i].field051 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field051 END IF
       WHEN  52 IF ga_table_data[p_i].field052 <> ga_page_data_t.field052 OR ga_table_data[p_i].field052 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field052 END IF
       WHEN  53 IF ga_table_data[p_i].field053 <> ga_page_data_t.field053 OR ga_table_data[p_i].field053 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field053 END IF
       WHEN  54 IF ga_table_data[p_i].field054 <> ga_page_data_t.field054 OR ga_table_data[p_i].field054 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field054 END IF
       WHEN  55 IF ga_table_data[p_i].field055 <> ga_page_data_t.field055 OR ga_table_data[p_i].field055 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field055 END IF
       WHEN  56 IF ga_table_data[p_i].field056 <> ga_page_data_t.field056 OR ga_table_data[p_i].field056 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field056 END IF
       WHEN  57 IF ga_table_data[p_i].field057 <> ga_page_data_t.field057 OR ga_table_data[p_i].field057 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field057 END IF
       WHEN  58 IF ga_table_data[p_i].field058 <> ga_page_data_t.field058 OR ga_table_data[p_i].field058 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field058 END IF
       WHEN  59 IF ga_table_data[p_i].field059 <> ga_page_data_t.field059 OR ga_table_data[p_i].field059 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field059 END IF
       WHEN  60 IF ga_table_data[p_i].field060 <> ga_page_data_t.field060 OR ga_table_data[p_i].field060 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field060 END IF
       WHEN  61 IF ga_table_data[p_i].field061 <> ga_page_data_t.field061 OR ga_table_data[p_i].field061 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field061 END IF
       WHEN  62 IF ga_table_data[p_i].field062 <> ga_page_data_t.field062 OR ga_table_data[p_i].field062 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field062 END IF
       WHEN  63 IF ga_table_data[p_i].field063 <> ga_page_data_t.field063 OR ga_table_data[p_i].field063 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field063 END IF
       WHEN  64 IF ga_table_data[p_i].field064 <> ga_page_data_t.field064 OR ga_table_data[p_i].field064 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field064 END IF
       WHEN  65 IF ga_table_data[p_i].field065 <> ga_page_data_t.field065 OR ga_table_data[p_i].field065 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field065 END IF
       WHEN  66 IF ga_table_data[p_i].field066 <> ga_page_data_t.field066 OR ga_table_data[p_i].field066 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field066 END IF
       WHEN  67 IF ga_table_data[p_i].field067 <> ga_page_data_t.field067 OR ga_table_data[p_i].field067 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field067 END IF
       WHEN  68 IF ga_table_data[p_i].field068 <> ga_page_data_t.field068 OR ga_table_data[p_i].field068 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field068 END IF
       WHEN  69 IF ga_table_data[p_i].field069 <> ga_page_data_t.field069 OR ga_table_data[p_i].field069 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field069 END IF
       WHEN  70 IF ga_table_data[p_i].field070 <> ga_page_data_t.field070 OR ga_table_data[p_i].field070 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field070 END IF
       WHEN  71 IF ga_table_data[p_i].field071 <> ga_page_data_t.field071 OR ga_table_data[p_i].field071 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field071 END IF
       WHEN  72 IF ga_table_data[p_i].field072 <> ga_page_data_t.field072 OR ga_table_data[p_i].field072 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field072 END IF
       WHEN  73 IF ga_table_data[p_i].field073 <> ga_page_data_t.field073 OR ga_table_data[p_i].field073 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field073 END IF
       WHEN  74 IF ga_table_data[p_i].field074 <> ga_page_data_t.field074 OR ga_table_data[p_i].field074 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field074 END IF
       WHEN  75 IF ga_table_data[p_i].field075 <> ga_page_data_t.field075 OR ga_table_data[p_i].field075 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field075 END IF
       WHEN  76 IF ga_table_data[p_i].field076 <> ga_page_data_t.field076 OR ga_table_data[p_i].field076 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field076 END IF
       WHEN  77 IF ga_table_data[p_i].field077 <> ga_page_data_t.field077 OR ga_table_data[p_i].field077 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field077 END IF
       WHEN  78 IF ga_table_data[p_i].field078 <> ga_page_data_t.field078 OR ga_table_data[p_i].field078 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field078 END IF
       WHEN  79 IF ga_table_data[p_i].field079 <> ga_page_data_t.field079 OR ga_table_data[p_i].field079 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field079 END IF
       WHEN  80 IF ga_table_data[p_i].field080 <> ga_page_data_t.field080 OR ga_table_data[p_i].field080 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field080 END IF
       WHEN  81 IF ga_table_data[p_i].field081 <> ga_page_data_t.field081 OR ga_table_data[p_i].field081 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field081 END IF
       WHEN  82 IF ga_table_data[p_i].field082 <> ga_page_data_t.field082 OR ga_table_data[p_i].field082 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field082 END IF
       WHEN  83 IF ga_table_data[p_i].field083 <> ga_page_data_t.field083 OR ga_table_data[p_i].field083 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field083 END IF
       WHEN  84 IF ga_table_data[p_i].field084 <> ga_page_data_t.field084 OR ga_table_data[p_i].field084 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field084 END IF
       WHEN  85 IF ga_table_data[p_i].field085 <> ga_page_data_t.field085 OR ga_table_data[p_i].field085 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field085 END IF
       WHEN  86 IF ga_table_data[p_i].field086 <> ga_page_data_t.field086 OR ga_table_data[p_i].field086 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field086 END IF
       WHEN  87 IF ga_table_data[p_i].field087 <> ga_page_data_t.field087 OR ga_table_data[p_i].field087 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field087 END IF
       WHEN  88 IF ga_table_data[p_i].field088 <> ga_page_data_t.field088 OR ga_table_data[p_i].field088 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field088 END IF
       WHEN  89 IF ga_table_data[p_i].field089 <> ga_page_data_t.field089 OR ga_table_data[p_i].field089 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field089 END IF
       WHEN  90 IF ga_table_data[p_i].field090 <> ga_page_data_t.field090 OR ga_table_data[p_i].field090 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field090 END IF
       WHEN  91 IF ga_table_data[p_i].field091 <> ga_page_data_t.field091 OR ga_table_data[p_i].field091 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field091 END IF
       WHEN  92 IF ga_table_data[p_i].field092 <> ga_page_data_t.field092 OR ga_table_data[p_i].field092 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field092 END IF
       WHEN  93 IF ga_table_data[p_i].field093 <> ga_page_data_t.field093 OR ga_table_data[p_i].field093 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field093 END IF
       WHEN  94 IF ga_table_data[p_i].field094 <> ga_page_data_t.field094 OR ga_table_data[p_i].field094 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field094 END IF
       WHEN  95 IF ga_table_data[p_i].field095 <> ga_page_data_t.field095 OR ga_table_data[p_i].field095 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field095 END IF
       WHEN  96 IF ga_table_data[p_i].field096 <> ga_page_data_t.field096 OR ga_table_data[p_i].field096 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field096 END IF
       WHEN  97 IF ga_table_data[p_i].field097 <> ga_page_data_t.field097 OR ga_table_data[p_i].field097 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field097 END IF
       WHEN  98 IF ga_table_data[p_i].field098 <> ga_page_data_t.field098 OR ga_table_data[p_i].field098 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field098 END IF
       WHEN  99 IF ga_table_data[p_i].field099 <> ga_page_data_t.field099 OR ga_table_data[p_i].field099 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field099 END IF
       WHEN 100 IF ga_table_data[p_i].field100 <> ga_page_data_t.field100 OR ga_table_data[p_i].field100 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field100 END IF
      #WHEN 101 IF ga_table_data[p_i].field101 <> ga_page_data_t.field101 OR ga_table_data[p_i].field101 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field101 END IF
      #WHEN 102 IF ga_table_data[p_i].field102 <> ga_page_data_t.field102 OR ga_table_data[p_i].field102 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field102 END IF
      #WHEN 103 IF ga_table_data[p_i].field103 <> ga_page_data_t.field103 OR ga_table_data[p_i].field103 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field103 END IF
      #WHEN 104 IF ga_table_data[p_i].field104 <> ga_page_data_t.field104 OR ga_table_data[p_i].field104 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field104 END IF
      #WHEN 105 IF ga_table_data[p_i].field105 <> ga_page_data_t.field105 OR ga_table_data[p_i].field105 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field105 END IF
      #WHEN 106 IF ga_table_data[p_i].field106 <> ga_page_data_t.field106 OR ga_table_data[p_i].field106 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field106 END IF
      #WHEN 107 IF ga_table_data[p_i].field107 <> ga_page_data_t.field107 OR ga_table_data[p_i].field107 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field107 END IF
      #WHEN 108 IF ga_table_data[p_i].field108 <> ga_page_data_t.field108 OR ga_table_data[p_i].field108 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field108 END IF
      #WHEN 109 IF ga_table_data[p_i].field109 <> ga_page_data_t.field109 OR ga_table_data[p_i].field109 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field109 END IF
      #WHEN 110 IF ga_table_data[p_i].field110 <> ga_page_data_t.field110 OR ga_table_data[p_i].field110 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field110 END IF
      #WHEN 111 IF ga_table_data[p_i].field111 <> ga_page_data_t.field111 OR ga_table_data[p_i].field111 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field111 END IF
      #WHEN 112 IF ga_table_data[p_i].field112 <> ga_page_data_t.field112 OR ga_table_data[p_i].field112 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field112 END IF
      #WHEN 113 IF ga_table_data[p_i].field113 <> ga_page_data_t.field113 OR ga_table_data[p_i].field113 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field113 END IF
      #WHEN 114 IF ga_table_data[p_i].field114 <> ga_page_data_t.field114 OR ga_table_data[p_i].field114 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field114 END IF
      #WHEN 115 IF ga_table_data[p_i].field115 <> ga_page_data_t.field115 OR ga_table_data[p_i].field115 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field115 END IF
      #WHEN 116 IF ga_table_data[p_i].field116 <> ga_page_data_t.field116 OR ga_table_data[p_i].field116 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field116 END IF
      #WHEN 117 IF ga_table_data[p_i].field117 <> ga_page_data_t.field117 OR ga_table_data[p_i].field117 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field117 END IF
      #WHEN 118 IF ga_table_data[p_i].field118 <> ga_page_data_t.field118 OR ga_table_data[p_i].field118 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field118 END IF
      #WHEN 119 IF ga_table_data[p_i].field119 <> ga_page_data_t.field119 OR ga_table_data[p_i].field119 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field119 END IF
      #WHEN 120 IF ga_table_data[p_i].field120 <> ga_page_data_t.field120 OR ga_table_data[p_i].field120 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field120 END IF
      #WHEN 121 IF ga_table_data[p_i].field121 <> ga_page_data_t.field121 OR ga_table_data[p_i].field121 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field121 END IF
      #WHEN 122 IF ga_table_data[p_i].field122 <> ga_page_data_t.field122 OR ga_table_data[p_i].field122 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field122 END IF
      #WHEN 123 IF ga_table_data[p_i].field123 <> ga_page_data_t.field123 OR ga_table_data[p_i].field123 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field123 END IF
      #WHEN 124 IF ga_table_data[p_i].field124 <> ga_page_data_t.field124 OR ga_table_data[p_i].field124 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field124 END IF
      #WHEN 125 IF ga_table_data[p_i].field125 <> ga_page_data_t.field125 OR ga_table_data[p_i].field125 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field125 END IF
      #WHEN 126 IF ga_table_data[p_i].field126 <> ga_page_data_t.field126 OR ga_table_data[p_i].field126 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field126 END IF
      #WHEN 127 IF ga_table_data[p_i].field127 <> ga_page_data_t.field127 OR ga_table_data[p_i].field127 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field127 END IF
      #WHEN 128 IF ga_table_data[p_i].field128 <> ga_page_data_t.field128 OR ga_table_data[p_i].field128 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field128 END IF
      #WHEN 129 IF ga_table_data[p_i].field129 <> ga_page_data_t.field129 OR ga_table_data[p_i].field129 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field129 END IF
      #WHEN 130 IF ga_table_data[p_i].field130 <> ga_page_data_t.field130 OR ga_table_data[p_i].field130 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field130 END IF
      #WHEN 131 IF ga_table_data[p_i].field131 <> ga_page_data_t.field131 OR ga_table_data[p_i].field131 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field131 END IF
      #WHEN 132 IF ga_table_data[p_i].field132 <> ga_page_data_t.field132 OR ga_table_data[p_i].field132 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field132 END IF
      #WHEN 133 IF ga_table_data[p_i].field133 <> ga_page_data_t.field133 OR ga_table_data[p_i].field133 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field133 END IF
      #WHEN 134 IF ga_table_data[p_i].field134 <> ga_page_data_t.field134 OR ga_table_data[p_i].field134 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field134 END IF
      #WHEN 135 IF ga_table_data[p_i].field135 <> ga_page_data_t.field135 OR ga_table_data[p_i].field135 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field135 END IF
      #WHEN 136 IF ga_table_data[p_i].field136 <> ga_page_data_t.field136 OR ga_table_data[p_i].field136 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field136 END IF
      #WHEN 137 IF ga_table_data[p_i].field137 <> ga_page_data_t.field137 OR ga_table_data[p_i].field137 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field137 END IF
      #WHEN 138 IF ga_table_data[p_i].field138 <> ga_page_data_t.field138 OR ga_table_data[p_i].field138 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field138 END IF
      #WHEN 139 IF ga_table_data[p_i].field139 <> ga_page_data_t.field139 OR ga_table_data[p_i].field139 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field139 END IF
      #WHEN 140 IF ga_table_data[p_i].field140 <> ga_page_data_t.field140 OR ga_table_data[p_i].field140 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field140 END IF
      #WHEN 141 IF ga_table_data[p_i].field141 <> ga_page_data_t.field141 OR ga_table_data[p_i].field141 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field141 END IF
      #WHEN 142 IF ga_table_data[p_i].field142 <> ga_page_data_t.field142 OR ga_table_data[p_i].field142 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field142 END IF
      #WHEN 143 IF ga_table_data[p_i].field143 <> ga_page_data_t.field143 OR ga_table_data[p_i].field143 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field143 END IF
      #WHEN 144 IF ga_table_data[p_i].field144 <> ga_page_data_t.field144 OR ga_table_data[p_i].field144 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field144 END IF
      #WHEN 145 IF ga_table_data[p_i].field145 <> ga_page_data_t.field145 OR ga_table_data[p_i].field145 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field145 END IF
      #WHEN 146 IF ga_table_data[p_i].field146 <> ga_page_data_t.field146 OR ga_table_data[p_i].field146 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field146 END IF
      #WHEN 147 IF ga_table_data[p_i].field147 <> ga_page_data_t.field147 OR ga_table_data[p_i].field147 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field147 END IF
      #WHEN 148 IF ga_table_data[p_i].field148 <> ga_page_data_t.field148 OR ga_table_data[p_i].field148 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field148 END IF
      #WHEN 149 IF ga_table_data[p_i].field149 <> ga_page_data_t.field149 OR ga_table_data[p_i].field149 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field149 END IF
      #WHEN 150 IF ga_table_data[p_i].field150 <> ga_page_data_t.field150 OR ga_table_data[p_i].field150 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field150 END IF
      #WHEN 151 IF ga_table_data[p_i].field151 <> ga_page_data_t.field151 OR ga_table_data[p_i].field151 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field151 END IF
      #WHEN 152 IF ga_table_data[p_i].field152 <> ga_page_data_t.field152 OR ga_table_data[p_i].field152 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field152 END IF
      #WHEN 153 IF ga_table_data[p_i].field153 <> ga_page_data_t.field153 OR ga_table_data[p_i].field153 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field153 END IF
      #WHEN 154 IF ga_table_data[p_i].field154 <> ga_page_data_t.field154 OR ga_table_data[p_i].field154 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field154 END IF
      #WHEN 155 IF ga_table_data[p_i].field155 <> ga_page_data_t.field155 OR ga_table_data[p_i].field155 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field155 END IF
      #WHEN 156 IF ga_table_data[p_i].field156 <> ga_page_data_t.field156 OR ga_table_data[p_i].field156 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field156 END IF
      #WHEN 157 IF ga_table_data[p_i].field157 <> ga_page_data_t.field157 OR ga_table_data[p_i].field157 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field157 END IF
      #WHEN 158 IF ga_table_data[p_i].field158 <> ga_page_data_t.field158 OR ga_table_data[p_i].field158 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field158 END IF
      #WHEN 159 IF ga_table_data[p_i].field159 <> ga_page_data_t.field159 OR ga_table_data[p_i].field159 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field159 END IF
      #WHEN 160 IF ga_table_data[p_i].field160 <> ga_page_data_t.field160 OR ga_table_data[p_i].field160 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field160 END IF
      #WHEN 161 IF ga_table_data[p_i].field161 <> ga_page_data_t.field161 OR ga_table_data[p_i].field161 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field161 END IF
      #WHEN 162 IF ga_table_data[p_i].field162 <> ga_page_data_t.field162 OR ga_table_data[p_i].field162 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field162 END IF
      #WHEN 163 IF ga_table_data[p_i].field163 <> ga_page_data_t.field163 OR ga_table_data[p_i].field163 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field163 END IF
      #WHEN 164 IF ga_table_data[p_i].field164 <> ga_page_data_t.field164 OR ga_table_data[p_i].field164 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field164 END IF
      #WHEN 165 IF ga_table_data[p_i].field165 <> ga_page_data_t.field165 OR ga_table_data[p_i].field165 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field165 END IF
      #WHEN 166 IF ga_table_data[p_i].field166 <> ga_page_data_t.field166 OR ga_table_data[p_i].field166 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field166 END IF
      #WHEN 167 IF ga_table_data[p_i].field167 <> ga_page_data_t.field167 OR ga_table_data[p_i].field167 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field167 END IF
      #WHEN 168 IF ga_table_data[p_i].field168 <> ga_page_data_t.field168 OR ga_table_data[p_i].field168 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field168 END IF
      #WHEN 169 IF ga_table_data[p_i].field169 <> ga_page_data_t.field169 OR ga_table_data[p_i].field169 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field169 END IF
      #WHEN 170 IF ga_table_data[p_i].field170 <> ga_page_data_t.field170 OR ga_table_data[p_i].field170 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field170 END IF
      #WHEN 171 IF ga_table_data[p_i].field171 <> ga_page_data_t.field171 OR ga_table_data[p_i].field171 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field171 END IF
      #WHEN 172 IF ga_table_data[p_i].field172 <> ga_page_data_t.field172 OR ga_table_data[p_i].field172 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field172 END IF
      #WHEN 173 IF ga_table_data[p_i].field173 <> ga_page_data_t.field173 OR ga_table_data[p_i].field173 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field173 END IF
      #WHEN 174 IF ga_table_data[p_i].field174 <> ga_page_data_t.field174 OR ga_table_data[p_i].field174 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field174 END IF
      #WHEN 175 IF ga_table_data[p_i].field175 <> ga_page_data_t.field175 OR ga_table_data[p_i].field175 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field175 END IF
      #WHEN 176 IF ga_table_data[p_i].field176 <> ga_page_data_t.field176 OR ga_table_data[p_i].field176 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field176 END IF
      #WHEN 177 IF ga_table_data[p_i].field177 <> ga_page_data_t.field177 OR ga_table_data[p_i].field177 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field177 END IF
      #WHEN 178 IF ga_table_data[p_i].field178 <> ga_page_data_t.field178 OR ga_table_data[p_i].field178 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field178 END IF
      #WHEN 179 IF ga_table_data[p_i].field179 <> ga_page_data_t.field179 OR ga_table_data[p_i].field179 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field179 END IF
      #WHEN 180 IF ga_table_data[p_i].field180 <> ga_page_data_t.field180 OR ga_table_data[p_i].field180 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field180 END IF
      #WHEN 181 IF ga_table_data[p_i].field181 <> ga_page_data_t.field181 OR ga_table_data[p_i].field181 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field181 END IF
      #WHEN 182 IF ga_table_data[p_i].field182 <> ga_page_data_t.field182 OR ga_table_data[p_i].field182 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field182 END IF
      #WHEN 183 IF ga_table_data[p_i].field183 <> ga_page_data_t.field183 OR ga_table_data[p_i].field183 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field183 END IF
      #WHEN 184 IF ga_table_data[p_i].field184 <> ga_page_data_t.field184 OR ga_table_data[p_i].field184 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field184 END IF
      #WHEN 185 IF ga_table_data[p_i].field185 <> ga_page_data_t.field185 OR ga_table_data[p_i].field185 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field185 END IF
      #WHEN 186 IF ga_table_data[p_i].field186 <> ga_page_data_t.field186 OR ga_table_data[p_i].field186 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field186 END IF
      #WHEN 187 IF ga_table_data[p_i].field187 <> ga_page_data_t.field187 OR ga_table_data[p_i].field187 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field187 END IF
      #WHEN 188 IF ga_table_data[p_i].field188 <> ga_page_data_t.field188 OR ga_table_data[p_i].field188 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field188 END IF
      #WHEN 189 IF ga_table_data[p_i].field189 <> ga_page_data_t.field189 OR ga_table_data[p_i].field189 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field189 END IF
      #WHEN 190 IF ga_table_data[p_i].field190 <> ga_page_data_t.field190 OR ga_table_data[p_i].field190 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field190 END IF
      #WHEN 191 IF ga_table_data[p_i].field191 <> ga_page_data_t.field191 OR ga_table_data[p_i].field191 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field191 END IF
      #WHEN 192 IF ga_table_data[p_i].field192 <> ga_page_data_t.field192 OR ga_table_data[p_i].field192 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field192 END IF
      #WHEN 193 IF ga_table_data[p_i].field193 <> ga_page_data_t.field193 OR ga_table_data[p_i].field193 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field193 END IF
      #WHEN 194 IF ga_table_data[p_i].field194 <> ga_page_data_t.field194 OR ga_table_data[p_i].field194 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field194 END IF
      #WHEN 195 IF ga_table_data[p_i].field195 <> ga_page_data_t.field195 OR ga_table_data[p_i].field195 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field195 END IF
      #WHEN 196 IF ga_table_data[p_i].field196 <> ga_page_data_t.field196 OR ga_table_data[p_i].field196 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field196 END IF
      #WHEN 197 IF ga_table_data[p_i].field197 <> ga_page_data_t.field197 OR ga_table_data[p_i].field197 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field197 END IF
      #WHEN 198 IF ga_table_data[p_i].field198 <> ga_page_data_t.field198 OR ga_table_data[p_i].field198 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field198 END IF
      #WHEN 199 IF ga_table_data[p_i].field199 <> ga_page_data_t.field199 OR ga_table_data[p_i].field199 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field199 END IF
      #WHEN 200 IF ga_table_data[p_i].field200 <> ga_page_data_t.field200 OR ga_table_data[p_i].field200 IS NULL THEN LET l_tag = 1 LET l_str=ga_page_data_t.field200 END IF
     END CASE
 
     #判斷其他Group欄位, 是否已需計算sum
     CASE p_n 
       WHEN   1 IF ga_table_data[p_i].field001 =  ga_page_data_t.field001 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field001 END IF END IF
       WHEN   2 IF ga_table_data[p_i].field002 =  ga_page_data_t.field002 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field002 END IF END IF
       WHEN   3 IF ga_table_data[p_i].field003 =  ga_page_data_t.field003 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field003 END IF END IF
       WHEN   4 IF ga_table_data[p_i].field004 =  ga_page_data_t.field004 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field004 END IF END IF
       WHEN   5 IF ga_table_data[p_i].field005 =  ga_page_data_t.field005 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field005 END IF END IF
       WHEN   6 IF ga_table_data[p_i].field006 =  ga_page_data_t.field006 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field006 END IF END IF
       WHEN   7 IF ga_table_data[p_i].field007 =  ga_page_data_t.field007 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field007 END IF END IF
       WHEN   8 IF ga_table_data[p_i].field008 =  ga_page_data_t.field008 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field008 END IF END IF
       WHEN   9 IF ga_table_data[p_i].field009 =  ga_page_data_t.field009 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field009 END IF END IF
       WHEN  10 IF ga_table_data[p_i].field010 =  ga_page_data_t.field010 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field010 END IF END IF
       WHEN  11 IF ga_table_data[p_i].field011 =  ga_page_data_t.field011 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field011 END IF END IF
       WHEN  12 IF ga_table_data[p_i].field012 =  ga_page_data_t.field012 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field012 END IF END IF
       WHEN  13 IF ga_table_data[p_i].field013 =  ga_page_data_t.field013 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field013 END IF END IF
       WHEN  14 IF ga_table_data[p_i].field014 =  ga_page_data_t.field014 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field014 END IF END IF
       WHEN  15 IF ga_table_data[p_i].field015 =  ga_page_data_t.field015 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field015 END IF END IF
       WHEN  16 IF ga_table_data[p_i].field016 =  ga_page_data_t.field016 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field016 END IF END IF
       WHEN  17 IF ga_table_data[p_i].field017 =  ga_page_data_t.field017 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field017 END IF END IF
       WHEN  18 IF ga_table_data[p_i].field018 =  ga_page_data_t.field018 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field018 END IF END IF
       WHEN  19 IF ga_table_data[p_i].field019 =  ga_page_data_t.field019 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field019 END IF END IF
       WHEN  20 IF ga_table_data[p_i].field020 =  ga_page_data_t.field020 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field020 END IF END IF
       WHEN  21 IF ga_table_data[p_i].field021 =  ga_page_data_t.field021 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field021 END IF END IF
       WHEN  22 IF ga_table_data[p_i].field022 =  ga_page_data_t.field022 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field022 END IF END IF
       WHEN  23 IF ga_table_data[p_i].field023 =  ga_page_data_t.field023 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field023 END IF END IF
       WHEN  24 IF ga_table_data[p_i].field024 =  ga_page_data_t.field024 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field024 END IF END IF
       WHEN  25 IF ga_table_data[p_i].field025 =  ga_page_data_t.field025 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field025 END IF END IF
       WHEN  26 IF ga_table_data[p_i].field026 =  ga_page_data_t.field026 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field026 END IF END IF
       WHEN  27 IF ga_table_data[p_i].field027 =  ga_page_data_t.field027 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field027 END IF END IF
       WHEN  28 IF ga_table_data[p_i].field028 =  ga_page_data_t.field028 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field028 END IF END IF
       WHEN  29 IF ga_table_data[p_i].field029 =  ga_page_data_t.field029 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field029 END IF END IF
       WHEN  30 IF ga_table_data[p_i].field030 =  ga_page_data_t.field030 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field030 END IF END IF
       WHEN  31 IF ga_table_data[p_i].field031 =  ga_page_data_t.field031 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field031 END IF END IF
       WHEN  32 IF ga_table_data[p_i].field032 =  ga_page_data_t.field032 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field032 END IF END IF
       WHEN  33 IF ga_table_data[p_i].field033 =  ga_page_data_t.field033 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field033 END IF END IF
       WHEN  34 IF ga_table_data[p_i].field034 =  ga_page_data_t.field034 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field034 END IF END IF
       WHEN  35 IF ga_table_data[p_i].field035 =  ga_page_data_t.field035 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field035 END IF END IF
       WHEN  36 IF ga_table_data[p_i].field036 =  ga_page_data_t.field036 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field036 END IF END IF
       WHEN  37 IF ga_table_data[p_i].field037 =  ga_page_data_t.field037 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field037 END IF END IF
       WHEN  38 IF ga_table_data[p_i].field038 =  ga_page_data_t.field038 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field038 END IF END IF
       WHEN  39 IF ga_table_data[p_i].field039 =  ga_page_data_t.field039 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field039 END IF END IF
       WHEN  40 IF ga_table_data[p_i].field040 =  ga_page_data_t.field040 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field040 END IF END IF
       WHEN  41 IF ga_table_data[p_i].field041 =  ga_page_data_t.field041 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field041 END IF END IF
       WHEN  42 IF ga_table_data[p_i].field042 =  ga_page_data_t.field042 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field042 END IF END IF
       WHEN  43 IF ga_table_data[p_i].field043 =  ga_page_data_t.field043 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field043 END IF END IF
       WHEN  44 IF ga_table_data[p_i].field044 =  ga_page_data_t.field044 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field044 END IF END IF
       WHEN  45 IF ga_table_data[p_i].field045 =  ga_page_data_t.field045 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field045 END IF END IF
       WHEN  46 IF ga_table_data[p_i].field046 =  ga_page_data_t.field046 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field046 END IF END IF
       WHEN  47 IF ga_table_data[p_i].field047 =  ga_page_data_t.field047 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field047 END IF END IF
       WHEN  48 IF ga_table_data[p_i].field048 =  ga_page_data_t.field048 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field048 END IF END IF
       WHEN  49 IF ga_table_data[p_i].field049 =  ga_page_data_t.field049 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field049 END IF END IF
       WHEN  50 IF ga_table_data[p_i].field050 =  ga_page_data_t.field050 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field050 END IF END IF
       WHEN  51 IF ga_table_data[p_i].field051 =  ga_page_data_t.field051 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field051 END IF END IF
       WHEN  52 IF ga_table_data[p_i].field052 =  ga_page_data_t.field052 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field052 END IF END IF
       WHEN  53 IF ga_table_data[p_i].field053 =  ga_page_data_t.field053 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field053 END IF END IF
       WHEN  54 IF ga_table_data[p_i].field054 =  ga_page_data_t.field054 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field054 END IF END IF
       WHEN  55 IF ga_table_data[p_i].field055 =  ga_page_data_t.field055 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field055 END IF END IF
       WHEN  56 IF ga_table_data[p_i].field056 =  ga_page_data_t.field056 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field056 END IF END IF
       WHEN  57 IF ga_table_data[p_i].field057 =  ga_page_data_t.field057 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field057 END IF END IF
       WHEN  58 IF ga_table_data[p_i].field058 =  ga_page_data_t.field058 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field058 END IF END IF
       WHEN  59 IF ga_table_data[p_i].field059 =  ga_page_data_t.field059 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field059 END IF END IF
       WHEN  60 IF ga_table_data[p_i].field060 =  ga_page_data_t.field060 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field060 END IF END IF
       WHEN  61 IF ga_table_data[p_i].field061 =  ga_page_data_t.field061 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field061 END IF END IF
       WHEN  62 IF ga_table_data[p_i].field062 =  ga_page_data_t.field062 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field062 END IF END IF
       WHEN  63 IF ga_table_data[p_i].field063 =  ga_page_data_t.field063 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field063 END IF END IF
       WHEN  64 IF ga_table_data[p_i].field064 =  ga_page_data_t.field064 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field064 END IF END IF
       WHEN  65 IF ga_table_data[p_i].field065 =  ga_page_data_t.field065 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field065 END IF END IF
       WHEN  66 IF ga_table_data[p_i].field066 =  ga_page_data_t.field066 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field066 END IF END IF
       WHEN  67 IF ga_table_data[p_i].field067 =  ga_page_data_t.field067 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field067 END IF END IF
       WHEN  68 IF ga_table_data[p_i].field068 =  ga_page_data_t.field068 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field068 END IF END IF
       WHEN  69 IF ga_table_data[p_i].field069 =  ga_page_data_t.field069 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field069 END IF END IF
       WHEN  70 IF ga_table_data[p_i].field070 =  ga_page_data_t.field070 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field070 END IF END IF
       WHEN  71 IF ga_table_data[p_i].field071 =  ga_page_data_t.field071 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field071 END IF END IF
       WHEN  72 IF ga_table_data[p_i].field072 =  ga_page_data_t.field072 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field072 END IF END IF
       WHEN  73 IF ga_table_data[p_i].field073 =  ga_page_data_t.field073 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field073 END IF END IF
       WHEN  74 IF ga_table_data[p_i].field074 =  ga_page_data_t.field074 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field074 END IF END IF
       WHEN  75 IF ga_table_data[p_i].field075 =  ga_page_data_t.field075 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field075 END IF END IF
       WHEN  76 IF ga_table_data[p_i].field076 =  ga_page_data_t.field076 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field076 END IF END IF
       WHEN  77 IF ga_table_data[p_i].field077 =  ga_page_data_t.field077 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field077 END IF END IF
       WHEN  78 IF ga_table_data[p_i].field078 =  ga_page_data_t.field078 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field078 END IF END IF
       WHEN  79 IF ga_table_data[p_i].field079 =  ga_page_data_t.field079 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field079 END IF END IF
       WHEN  80 IF ga_table_data[p_i].field080 =  ga_page_data_t.field080 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field080 END IF END IF
       WHEN  81 IF ga_table_data[p_i].field081 =  ga_page_data_t.field081 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field081 END IF END IF
       WHEN  82 IF ga_table_data[p_i].field082 =  ga_page_data_t.field082 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field082 END IF END IF
       WHEN  83 IF ga_table_data[p_i].field083 =  ga_page_data_t.field083 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field083 END IF END IF
       WHEN  84 IF ga_table_data[p_i].field084 =  ga_page_data_t.field084 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field084 END IF END IF
       WHEN  85 IF ga_table_data[p_i].field085 =  ga_page_data_t.field085 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field085 END IF END IF
       WHEN  86 IF ga_table_data[p_i].field086 =  ga_page_data_t.field086 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field086 END IF END IF
       WHEN  87 IF ga_table_data[p_i].field087 =  ga_page_data_t.field087 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field087 END IF END IF
       WHEN  88 IF ga_table_data[p_i].field088 =  ga_page_data_t.field088 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field088 END IF END IF
       WHEN  89 IF ga_table_data[p_i].field089 =  ga_page_data_t.field089 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field089 END IF END IF
       WHEN  90 IF ga_table_data[p_i].field090 =  ga_page_data_t.field090 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field090 END IF END IF
       WHEN  91 IF ga_table_data[p_i].field091 =  ga_page_data_t.field091 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field091 END IF END IF
       WHEN  92 IF ga_table_data[p_i].field092 =  ga_page_data_t.field092 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field092 END IF END IF
       WHEN  93 IF ga_table_data[p_i].field093 =  ga_page_data_t.field093 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field093 END IF END IF
       WHEN  94 IF ga_table_data[p_i].field094 =  ga_page_data_t.field094 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field094 END IF END IF
       WHEN  95 IF ga_table_data[p_i].field095 =  ga_page_data_t.field095 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field095 END IF END IF
       WHEN  96 IF ga_table_data[p_i].field096 =  ga_page_data_t.field096 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field096 END IF END IF
       WHEN  97 IF ga_table_data[p_i].field097 =  ga_page_data_t.field097 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field097 END IF END IF
       WHEN  98 IF ga_table_data[p_i].field098 =  ga_page_data_t.field098 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field098 END IF END IF
       WHEN  99 IF ga_table_data[p_i].field099 =  ga_page_data_t.field099 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field099 END IF END IF
       WHEN 100 IF ga_table_data[p_i].field100 =  ga_page_data_t.field100 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field100 END IF END IF
      #WHEN 101 IF ga_table_data[p_i].field101 =  ga_page_data_t.field101 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field101 END IF END IF
      #WHEN 102 IF ga_table_data[p_i].field102 =  ga_page_data_t.field102 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field102 END IF END IF
      #WHEN 103 IF ga_table_data[p_i].field103 =  ga_page_data_t.field103 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field103 END IF END IF
      #WHEN 104 IF ga_table_data[p_i].field104 =  ga_page_data_t.field104 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field104 END IF END IF
      #WHEN 105 IF ga_table_data[p_i].field105 =  ga_page_data_t.field105 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field105 END IF END IF
      #WHEN 106 IF ga_table_data[p_i].field106 =  ga_page_data_t.field106 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field106 END IF END IF
      #WHEN 107 IF ga_table_data[p_i].field107 =  ga_page_data_t.field107 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field107 END IF END IF
      #WHEN 108 IF ga_table_data[p_i].field108 =  ga_page_data_t.field108 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field108 END IF END IF
      #WHEN 109 IF ga_table_data[p_i].field109 =  ga_page_data_t.field109 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field109 END IF END IF
      #WHEN 110 IF ga_table_data[p_i].field110 =  ga_page_data_t.field110 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field110 END IF END IF
      #WHEN 111 IF ga_table_data[p_i].field111 =  ga_page_data_t.field111 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field111 END IF END IF
      #WHEN 112 IF ga_table_data[p_i].field112 =  ga_page_data_t.field112 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field112 END IF END IF
      #WHEN 113 IF ga_table_data[p_i].field113 =  ga_page_data_t.field113 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field113 END IF END IF
      #WHEN 114 IF ga_table_data[p_i].field114 =  ga_page_data_t.field114 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field114 END IF END IF
      #WHEN 115 IF ga_table_data[p_i].field115 =  ga_page_data_t.field115 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field115 END IF END IF
      #WHEN 116 IF ga_table_data[p_i].field116 =  ga_page_data_t.field116 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field116 END IF END IF
      #WHEN 117 IF ga_table_data[p_i].field117 =  ga_page_data_t.field117 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field117 END IF END IF
      #WHEN 118 IF ga_table_data[p_i].field118 =  ga_page_data_t.field118 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field118 END IF END IF
      #WHEN 119 IF ga_table_data[p_i].field119 =  ga_page_data_t.field119 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field119 END IF END IF
      #WHEN 120 IF ga_table_data[p_i].field120 =  ga_page_data_t.field120 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field120 END IF END IF
      #WHEN 121 IF ga_table_data[p_i].field121 =  ga_page_data_t.field121 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field121 END IF END IF
      #WHEN 122 IF ga_table_data[p_i].field122 =  ga_page_data_t.field122 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field122 END IF END IF
      #WHEN 123 IF ga_table_data[p_i].field123 =  ga_page_data_t.field123 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field123 END IF END IF
      #WHEN 124 IF ga_table_data[p_i].field124 =  ga_page_data_t.field124 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field124 END IF END IF
      #WHEN 125 IF ga_table_data[p_i].field125 =  ga_page_data_t.field125 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field125 END IF END IF
      #WHEN 126 IF ga_table_data[p_i].field126 =  ga_page_data_t.field126 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field126 END IF END IF
      #WHEN 127 IF ga_table_data[p_i].field127 =  ga_page_data_t.field127 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field127 END IF END IF
      #WHEN 128 IF ga_table_data[p_i].field128 =  ga_page_data_t.field128 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field128 END IF END IF
      #WHEN 129 IF ga_table_data[p_i].field129 =  ga_page_data_t.field129 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field129 END IF END IF
      #WHEN 130 IF ga_table_data[p_i].field130 =  ga_page_data_t.field130 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field130 END IF END IF
      #WHEN 131 IF ga_table_data[p_i].field131 =  ga_page_data_t.field131 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field131 END IF END IF
      #WHEN 132 IF ga_table_data[p_i].field132 =  ga_page_data_t.field132 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field132 END IF END IF
      #WHEN 133 IF ga_table_data[p_i].field133 =  ga_page_data_t.field133 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field133 END IF END IF
      #WHEN 134 IF ga_table_data[p_i].field134 =  ga_page_data_t.field134 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field134 END IF END IF
      #WHEN 135 IF ga_table_data[p_i].field135 =  ga_page_data_t.field135 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field135 END IF END IF
      #WHEN 136 IF ga_table_data[p_i].field136 =  ga_page_data_t.field136 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field136 END IF END IF
      #WHEN 137 IF ga_table_data[p_i].field137 =  ga_page_data_t.field137 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field137 END IF END IF
      #WHEN 138 IF ga_table_data[p_i].field138 =  ga_page_data_t.field138 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field138 END IF END IF
      #WHEN 139 IF ga_table_data[p_i].field139 =  ga_page_data_t.field139 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field139 END IF END IF
      #WHEN 140 IF ga_table_data[p_i].field140 =  ga_page_data_t.field140 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field140 END IF END IF
      #WHEN 141 IF ga_table_data[p_i].field141 =  ga_page_data_t.field141 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field141 END IF END IF
      #WHEN 142 IF ga_table_data[p_i].field142 =  ga_page_data_t.field142 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field142 END IF END IF
      #WHEN 143 IF ga_table_data[p_i].field143 =  ga_page_data_t.field143 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field143 END IF END IF
      #WHEN 144 IF ga_table_data[p_i].field144 =  ga_page_data_t.field144 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field144 END IF END IF
      #WHEN 145 IF ga_table_data[p_i].field145 =  ga_page_data_t.field145 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field145 END IF END IF
      #WHEN 146 IF ga_table_data[p_i].field146 =  ga_page_data_t.field146 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field146 END IF END IF
      #WHEN 147 IF ga_table_data[p_i].field147 =  ga_page_data_t.field147 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field147 END IF END IF
      #WHEN 148 IF ga_table_data[p_i].field148 =  ga_page_data_t.field148 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field148 END IF END IF
      #WHEN 149 IF ga_table_data[p_i].field149 =  ga_page_data_t.field149 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field149 END IF END IF
      #WHEN 150 IF ga_table_data[p_i].field150 =  ga_page_data_t.field150 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field150 END IF END IF
      #WHEN 151 IF ga_table_data[p_i].field151 =  ga_page_data_t.field151 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field151 END IF END IF
      #WHEN 152 IF ga_table_data[p_i].field152 =  ga_page_data_t.field152 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field152 END IF END IF
      #WHEN 153 IF ga_table_data[p_i].field153 =  ga_page_data_t.field153 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field153 END IF END IF
      #WHEN 154 IF ga_table_data[p_i].field154 =  ga_page_data_t.field154 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field154 END IF END IF
      #WHEN 155 IF ga_table_data[p_i].field155 =  ga_page_data_t.field155 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field155 END IF END IF
      #WHEN 156 IF ga_table_data[p_i].field156 =  ga_page_data_t.field156 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field156 END IF END IF
      #WHEN 157 IF ga_table_data[p_i].field157 =  ga_page_data_t.field157 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field157 END IF END IF
      #WHEN 158 IF ga_table_data[p_i].field158 =  ga_page_data_t.field158 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field158 END IF END IF
      #WHEN 159 IF ga_table_data[p_i].field159 =  ga_page_data_t.field159 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field159 END IF END IF
      #WHEN 160 IF ga_table_data[p_i].field160 =  ga_page_data_t.field160 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field160 END IF END IF
      #WHEN 161 IF ga_table_data[p_i].field161 =  ga_page_data_t.field161 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field161 END IF END IF
      #WHEN 162 IF ga_table_data[p_i].field162 =  ga_page_data_t.field162 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field162 END IF END IF
      #WHEN 163 IF ga_table_data[p_i].field163 =  ga_page_data_t.field163 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field163 END IF END IF
      #WHEN 164 IF ga_table_data[p_i].field164 =  ga_page_data_t.field164 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field164 END IF END IF
      #WHEN 165 IF ga_table_data[p_i].field165 =  ga_page_data_t.field165 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field165 END IF END IF
      #WHEN 166 IF ga_table_data[p_i].field166 =  ga_page_data_t.field166 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field166 END IF END IF
      #WHEN 167 IF ga_table_data[p_i].field167 =  ga_page_data_t.field167 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field167 END IF END IF
      #WHEN 168 IF ga_table_data[p_i].field168 =  ga_page_data_t.field168 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field168 END IF END IF
      #WHEN 169 IF ga_table_data[p_i].field169 =  ga_page_data_t.field169 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field169 END IF END IF
      #WHEN 170 IF ga_table_data[p_i].field170 =  ga_page_data_t.field170 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field170 END IF END IF
      #WHEN 171 IF ga_table_data[p_i].field171 =  ga_page_data_t.field171 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field171 END IF END IF
      #WHEN 172 IF ga_table_data[p_i].field172 =  ga_page_data_t.field172 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field172 END IF END IF
      #WHEN 173 IF ga_table_data[p_i].field173 =  ga_page_data_t.field173 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field173 END IF END IF
      #WHEN 174 IF ga_table_data[p_i].field174 =  ga_page_data_t.field174 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field174 END IF END IF
      #WHEN 175 IF ga_table_data[p_i].field175 =  ga_page_data_t.field175 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field175 END IF END IF
      #WHEN 176 IF ga_table_data[p_i].field176 =  ga_page_data_t.field176 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field176 END IF END IF
      #WHEN 177 IF ga_table_data[p_i].field177 =  ga_page_data_t.field177 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field177 END IF END IF
      #WHEN 178 IF ga_table_data[p_i].field178 =  ga_page_data_t.field178 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field178 END IF END IF
      #WHEN 179 IF ga_table_data[p_i].field179 =  ga_page_data_t.field179 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field179 END IF END IF
      #WHEN 180 IF ga_table_data[p_i].field180 =  ga_page_data_t.field180 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field180 END IF END IF
      #WHEN 181 IF ga_table_data[p_i].field181 =  ga_page_data_t.field181 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field181 END IF END IF
      #WHEN 182 IF ga_table_data[p_i].field182 =  ga_page_data_t.field182 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field182 END IF END IF
      #WHEN 183 IF ga_table_data[p_i].field183 =  ga_page_data_t.field183 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field183 END IF END IF
      #WHEN 184 IF ga_table_data[p_i].field184 =  ga_page_data_t.field184 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field184 END IF END IF
      #WHEN 185 IF ga_table_data[p_i].field185 =  ga_page_data_t.field185 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field185 END IF END IF
      #WHEN 186 IF ga_table_data[p_i].field186 =  ga_page_data_t.field186 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field186 END IF END IF
      #WHEN 187 IF ga_table_data[p_i].field187 =  ga_page_data_t.field187 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field187 END IF END IF
      #WHEN 188 IF ga_table_data[p_i].field188 =  ga_page_data_t.field188 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field188 END IF END IF
      #WHEN 189 IF ga_table_data[p_i].field189 =  ga_page_data_t.field189 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field189 END IF END IF
      #WHEN 190 IF ga_table_data[p_i].field190 =  ga_page_data_t.field190 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field190 END IF END IF
      #WHEN 191 IF ga_table_data[p_i].field191 =  ga_page_data_t.field191 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field191 END IF END IF
      #WHEN 192 IF ga_table_data[p_i].field192 =  ga_page_data_t.field192 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field192 END IF END IF
      #WHEN 193 IF ga_table_data[p_i].field193 =  ga_page_data_t.field193 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field193 END IF END IF
      #WHEN 194 IF ga_table_data[p_i].field194 =  ga_page_data_t.field194 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field194 END IF END IF
      #WHEN 195 IF ga_table_data[p_i].field195 =  ga_page_data_t.field195 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field195 END IF END IF
      #WHEN 196 IF ga_table_data[p_i].field196 =  ga_page_data_t.field196 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field196 END IF END IF
      #WHEN 197 IF ga_table_data[p_i].field197 =  ga_page_data_t.field197 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field197 END IF END IF
      #WHEN 198 IF ga_table_data[p_i].field198 =  ga_page_data_t.field198 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field198 END IF END IF
      #WHEN 199 IF ga_table_data[p_i].field199 =  ga_page_data_t.field199 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field199 END IF END IF
      #WHEN 200 IF ga_table_data[p_i].field200 =  ga_page_data_t.field200 THEN IF p_query_sum_order(p_n,p_i) THEN LET l_tag = 1 LET l_str=ga_page_data_t.field200 END IF END IF
     END CASE
 
 RETURN l_tag,l_str
 
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 判斷其他Group欄位, 是否已需計算sum
# Date & Author..:
# Input Parameter: p_n,p_i
# Return code....:
# Modify.........: 
##################################################
FUNCTION p_query_sum_order(p_n,p_i) 
DEFINE p_n         LIKE type_file.num10  #目前Group所在的欄位
DEFINE p_i         LIKE type_file.num10  #目前所在的行數
DEFINE l_i         LIKE type_file.num10
DEFINE l_j         LIKE type_file.num10
DEFINE l_k         LIKE type_file.num10
DEFINE l_n         LIKE type_file.num10
DEFINE l_tag       LIKE type_file.num5
 
   LET l_tag = 0
   LET l_j = 0
   FOR l_i = 1 TO g_zam.getLength() 
      IF g_zam[l_i].zal04 = g_qry_feld_t[p_n] THEN
           IF l_i > 1 THEN
               LET l_j = l_i - 1
               EXIT FOR
           END IF
      END IF
   END FOR
   IF l_j = 0 THEN 
        RETURN l_tag
   END IF
 
   FOR l_k = l_j TO 1 STEP -1 
       FOR l_i = 1 TO p_n 
           IF g_qry_feld_t[l_i] = g_zam[l_k].zal04 THEN
                 LET l_n = l_i
           END IF
       END FOR
       
       CASE l_n 
          WHEN   1 IF ga_table_data[p_i].field001 <> ga_page_data_t.field001 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN   2 IF ga_table_data[p_i].field002 <> ga_page_data_t.field002 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN   3 IF ga_table_data[p_i].field003 <> ga_page_data_t.field003 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN   4 IF ga_table_data[p_i].field004 <> ga_page_data_t.field004 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN   5 IF ga_table_data[p_i].field005 <> ga_page_data_t.field005 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN   6 IF ga_table_data[p_i].field006 <> ga_page_data_t.field006 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN   7 IF ga_table_data[p_i].field007 <> ga_page_data_t.field007 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN   8 IF ga_table_data[p_i].field008 <> ga_page_data_t.field008 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN   9 IF ga_table_data[p_i].field009 <> ga_page_data_t.field009 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  10 IF ga_table_data[p_i].field010 <> ga_page_data_t.field010 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  11 IF ga_table_data[p_i].field011 <> ga_page_data_t.field011 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  12 IF ga_table_data[p_i].field012 <> ga_page_data_t.field012 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  13 IF ga_table_data[p_i].field013 <> ga_page_data_t.field013 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  14 IF ga_table_data[p_i].field014 <> ga_page_data_t.field014 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  15 IF ga_table_data[p_i].field015 <> ga_page_data_t.field015 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  16 IF ga_table_data[p_i].field016 <> ga_page_data_t.field016 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  17 IF ga_table_data[p_i].field017 <> ga_page_data_t.field017 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  18 IF ga_table_data[p_i].field018 <> ga_page_data_t.field018 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  19 IF ga_table_data[p_i].field019 <> ga_page_data_t.field019 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  20 IF ga_table_data[p_i].field020 <> ga_page_data_t.field020 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  21 IF ga_table_data[p_i].field021 <> ga_page_data_t.field021 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  22 IF ga_table_data[p_i].field022 <> ga_page_data_t.field022 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  23 IF ga_table_data[p_i].field023 <> ga_page_data_t.field023 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  24 IF ga_table_data[p_i].field024 <> ga_page_data_t.field024 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  25 IF ga_table_data[p_i].field025 <> ga_page_data_t.field025 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  26 IF ga_table_data[p_i].field026 <> ga_page_data_t.field026 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  27 IF ga_table_data[p_i].field027 <> ga_page_data_t.field027 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  28 IF ga_table_data[p_i].field028 <> ga_page_data_t.field028 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  29 IF ga_table_data[p_i].field029 <> ga_page_data_t.field029 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  30 IF ga_table_data[p_i].field030 <> ga_page_data_t.field030 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  31 IF ga_table_data[p_i].field031 <> ga_page_data_t.field031 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  32 IF ga_table_data[p_i].field032 <> ga_page_data_t.field032 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  33 IF ga_table_data[p_i].field033 <> ga_page_data_t.field033 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  34 IF ga_table_data[p_i].field034 <> ga_page_data_t.field034 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  35 IF ga_table_data[p_i].field035 <> ga_page_data_t.field035 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  36 IF ga_table_data[p_i].field036 <> ga_page_data_t.field036 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  37 IF ga_table_data[p_i].field037 <> ga_page_data_t.field037 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  38 IF ga_table_data[p_i].field038 <> ga_page_data_t.field038 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  39 IF ga_table_data[p_i].field039 <> ga_page_data_t.field039 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  40 IF ga_table_data[p_i].field040 <> ga_page_data_t.field040 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  41 IF ga_table_data[p_i].field041 <> ga_page_data_t.field041 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  42 IF ga_table_data[p_i].field042 <> ga_page_data_t.field042 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  43 IF ga_table_data[p_i].field043 <> ga_page_data_t.field043 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  44 IF ga_table_data[p_i].field044 <> ga_page_data_t.field044 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  45 IF ga_table_data[p_i].field045 <> ga_page_data_t.field045 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  46 IF ga_table_data[p_i].field046 <> ga_page_data_t.field046 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  47 IF ga_table_data[p_i].field047 <> ga_page_data_t.field047 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  48 IF ga_table_data[p_i].field048 <> ga_page_data_t.field048 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  49 IF ga_table_data[p_i].field049 <> ga_page_data_t.field049 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  50 IF ga_table_data[p_i].field050 <> ga_page_data_t.field050 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  51 IF ga_table_data[p_i].field051 <> ga_page_data_t.field051 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  52 IF ga_table_data[p_i].field052 <> ga_page_data_t.field052 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  53 IF ga_table_data[p_i].field053 <> ga_page_data_t.field053 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  54 IF ga_table_data[p_i].field054 <> ga_page_data_t.field054 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  55 IF ga_table_data[p_i].field055 <> ga_page_data_t.field055 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  56 IF ga_table_data[p_i].field056 <> ga_page_data_t.field056 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  57 IF ga_table_data[p_i].field057 <> ga_page_data_t.field057 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  58 IF ga_table_data[p_i].field058 <> ga_page_data_t.field058 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  59 IF ga_table_data[p_i].field059 <> ga_page_data_t.field059 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  60 IF ga_table_data[p_i].field060 <> ga_page_data_t.field060 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  61 IF ga_table_data[p_i].field061 <> ga_page_data_t.field061 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  62 IF ga_table_data[p_i].field062 <> ga_page_data_t.field062 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  63 IF ga_table_data[p_i].field063 <> ga_page_data_t.field063 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  64 IF ga_table_data[p_i].field064 <> ga_page_data_t.field064 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  65 IF ga_table_data[p_i].field065 <> ga_page_data_t.field065 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  66 IF ga_table_data[p_i].field066 <> ga_page_data_t.field066 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  67 IF ga_table_data[p_i].field067 <> ga_page_data_t.field067 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  68 IF ga_table_data[p_i].field068 <> ga_page_data_t.field068 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  69 IF ga_table_data[p_i].field069 <> ga_page_data_t.field069 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  70 IF ga_table_data[p_i].field070 <> ga_page_data_t.field070 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  71 IF ga_table_data[p_i].field071 <> ga_page_data_t.field071 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  72 IF ga_table_data[p_i].field072 <> ga_page_data_t.field072 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  73 IF ga_table_data[p_i].field073 <> ga_page_data_t.field073 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  74 IF ga_table_data[p_i].field074 <> ga_page_data_t.field074 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  75 IF ga_table_data[p_i].field075 <> ga_page_data_t.field075 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  76 IF ga_table_data[p_i].field076 <> ga_page_data_t.field076 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  77 IF ga_table_data[p_i].field077 <> ga_page_data_t.field077 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  78 IF ga_table_data[p_i].field078 <> ga_page_data_t.field078 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  79 IF ga_table_data[p_i].field079 <> ga_page_data_t.field079 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  80 IF ga_table_data[p_i].field080 <> ga_page_data_t.field080 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  81 IF ga_table_data[p_i].field081 <> ga_page_data_t.field081 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  82 IF ga_table_data[p_i].field082 <> ga_page_data_t.field082 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  83 IF ga_table_data[p_i].field083 <> ga_page_data_t.field083 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  84 IF ga_table_data[p_i].field084 <> ga_page_data_t.field084 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  85 IF ga_table_data[p_i].field085 <> ga_page_data_t.field085 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  86 IF ga_table_data[p_i].field086 <> ga_page_data_t.field086 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  87 IF ga_table_data[p_i].field087 <> ga_page_data_t.field087 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  88 IF ga_table_data[p_i].field088 <> ga_page_data_t.field088 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  89 IF ga_table_data[p_i].field089 <> ga_page_data_t.field089 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  90 IF ga_table_data[p_i].field090 <> ga_page_data_t.field090 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  91 IF ga_table_data[p_i].field091 <> ga_page_data_t.field091 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  92 IF ga_table_data[p_i].field092 <> ga_page_data_t.field092 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  93 IF ga_table_data[p_i].field093 <> ga_page_data_t.field093 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  94 IF ga_table_data[p_i].field094 <> ga_page_data_t.field094 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  95 IF ga_table_data[p_i].field095 <> ga_page_data_t.field095 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  96 IF ga_table_data[p_i].field096 <> ga_page_data_t.field096 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  97 IF ga_table_data[p_i].field097 <> ga_page_data_t.field097 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  98 IF ga_table_data[p_i].field098 <> ga_page_data_t.field098 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN  99 IF ga_table_data[p_i].field099 <> ga_page_data_t.field099 THEN LET l_tag = 1 EXIT FOR END IF
          WHEN 100 IF ga_table_data[p_i].field100 <> ga_page_data_t.field100 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 101 IF ga_table_data[p_i].field101 <> ga_page_data_t.field101 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 102 IF ga_table_data[p_i].field102 <> ga_page_data_t.field102 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 103 IF ga_table_data[p_i].field103 <> ga_page_data_t.field103 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 104 IF ga_table_data[p_i].field104 <> ga_page_data_t.field104 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 105 IF ga_table_data[p_i].field105 <> ga_page_data_t.field105 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 106 IF ga_table_data[p_i].field106 <> ga_page_data_t.field106 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 107 IF ga_table_data[p_i].field107 <> ga_page_data_t.field107 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 108 IF ga_table_data[p_i].field108 <> ga_page_data_t.field108 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 109 IF ga_table_data[p_i].field109 <> ga_page_data_t.field109 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 110 IF ga_table_data[p_i].field110 <> ga_page_data_t.field110 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 111 IF ga_table_data[p_i].field111 <> ga_page_data_t.field111 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 112 IF ga_table_data[p_i].field112 <> ga_page_data_t.field112 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 113 IF ga_table_data[p_i].field113 <> ga_page_data_t.field113 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 114 IF ga_table_data[p_i].field114 <> ga_page_data_t.field114 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 115 IF ga_table_data[p_i].field115 <> ga_page_data_t.field115 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 116 IF ga_table_data[p_i].field116 <> ga_page_data_t.field116 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 117 IF ga_table_data[p_i].field117 <> ga_page_data_t.field117 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 118 IF ga_table_data[p_i].field118 <> ga_page_data_t.field118 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 119 IF ga_table_data[p_i].field119 <> ga_page_data_t.field119 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 120 IF ga_table_data[p_i].field120 <> ga_page_data_t.field120 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 121 IF ga_table_data[p_i].field121 <> ga_page_data_t.field121 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 122 IF ga_table_data[p_i].field122 <> ga_page_data_t.field122 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 123 IF ga_table_data[p_i].field123 <> ga_page_data_t.field123 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 124 IF ga_table_data[p_i].field124 <> ga_page_data_t.field124 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 125 IF ga_table_data[p_i].field125 <> ga_page_data_t.field125 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 126 IF ga_table_data[p_i].field126 <> ga_page_data_t.field126 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 127 IF ga_table_data[p_i].field127 <> ga_page_data_t.field127 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 128 IF ga_table_data[p_i].field128 <> ga_page_data_t.field128 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 129 IF ga_table_data[p_i].field129 <> ga_page_data_t.field129 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 130 IF ga_table_data[p_i].field130 <> ga_page_data_t.field130 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 131 IF ga_table_data[p_i].field131 <> ga_page_data_t.field131 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 132 IF ga_table_data[p_i].field132 <> ga_page_data_t.field132 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 133 IF ga_table_data[p_i].field133 <> ga_page_data_t.field133 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 134 IF ga_table_data[p_i].field134 <> ga_page_data_t.field134 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 135 IF ga_table_data[p_i].field135 <> ga_page_data_t.field135 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 136 IF ga_table_data[p_i].field136 <> ga_page_data_t.field136 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 137 IF ga_table_data[p_i].field137 <> ga_page_data_t.field137 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 138 IF ga_table_data[p_i].field138 <> ga_page_data_t.field138 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 139 IF ga_table_data[p_i].field139 <> ga_page_data_t.field139 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 140 IF ga_table_data[p_i].field140 <> ga_page_data_t.field140 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 141 IF ga_table_data[p_i].field141 <> ga_page_data_t.field141 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 142 IF ga_table_data[p_i].field142 <> ga_page_data_t.field142 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 143 IF ga_table_data[p_i].field143 <> ga_page_data_t.field143 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 144 IF ga_table_data[p_i].field144 <> ga_page_data_t.field144 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 145 IF ga_table_data[p_i].field145 <> ga_page_data_t.field145 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 146 IF ga_table_data[p_i].field146 <> ga_page_data_t.field146 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 147 IF ga_table_data[p_i].field147 <> ga_page_data_t.field147 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 148 IF ga_table_data[p_i].field148 <> ga_page_data_t.field148 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 149 IF ga_table_data[p_i].field149 <> ga_page_data_t.field149 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 150 IF ga_table_data[p_i].field150 <> ga_page_data_t.field150 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 151 IF ga_table_data[p_i].field151 <> ga_page_data_t.field151 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 152 IF ga_table_data[p_i].field152 <> ga_page_data_t.field152 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 153 IF ga_table_data[p_i].field153 <> ga_page_data_t.field153 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 154 IF ga_table_data[p_i].field154 <> ga_page_data_t.field154 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 155 IF ga_table_data[p_i].field155 <> ga_page_data_t.field155 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 156 IF ga_table_data[p_i].field156 <> ga_page_data_t.field156 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 157 IF ga_table_data[p_i].field157 <> ga_page_data_t.field157 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 158 IF ga_table_data[p_i].field158 <> ga_page_data_t.field158 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 159 IF ga_table_data[p_i].field159 <> ga_page_data_t.field159 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 160 IF ga_table_data[p_i].field160 <> ga_page_data_t.field160 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 161 IF ga_table_data[p_i].field161 <> ga_page_data_t.field161 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 162 IF ga_table_data[p_i].field162 <> ga_page_data_t.field162 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 163 IF ga_table_data[p_i].field163 <> ga_page_data_t.field163 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 164 IF ga_table_data[p_i].field164 <> ga_page_data_t.field164 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 165 IF ga_table_data[p_i].field165 <> ga_page_data_t.field165 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 166 IF ga_table_data[p_i].field166 <> ga_page_data_t.field166 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 167 IF ga_table_data[p_i].field167 <> ga_page_data_t.field167 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 168 IF ga_table_data[p_i].field168 <> ga_page_data_t.field168 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 169 IF ga_table_data[p_i].field169 <> ga_page_data_t.field169 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 170 IF ga_table_data[p_i].field170 <> ga_page_data_t.field170 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 171 IF ga_table_data[p_i].field171 <> ga_page_data_t.field171 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 172 IF ga_table_data[p_i].field172 <> ga_page_data_t.field172 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 173 IF ga_table_data[p_i].field173 <> ga_page_data_t.field173 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 174 IF ga_table_data[p_i].field174 <> ga_page_data_t.field174 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 175 IF ga_table_data[p_i].field175 <> ga_page_data_t.field175 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 176 IF ga_table_data[p_i].field176 <> ga_page_data_t.field176 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 177 IF ga_table_data[p_i].field177 <> ga_page_data_t.field177 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 178 IF ga_table_data[p_i].field178 <> ga_page_data_t.field178 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 179 IF ga_table_data[p_i].field179 <> ga_page_data_t.field179 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 180 IF ga_table_data[p_i].field180 <> ga_page_data_t.field180 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 181 IF ga_table_data[p_i].field181 <> ga_page_data_t.field181 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 182 IF ga_table_data[p_i].field182 <> ga_page_data_t.field182 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 183 IF ga_table_data[p_i].field183 <> ga_page_data_t.field183 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 184 IF ga_table_data[p_i].field184 <> ga_page_data_t.field184 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 185 IF ga_table_data[p_i].field185 <> ga_page_data_t.field185 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 186 IF ga_table_data[p_i].field186 <> ga_page_data_t.field186 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 187 IF ga_table_data[p_i].field187 <> ga_page_data_t.field187 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 188 IF ga_table_data[p_i].field188 <> ga_page_data_t.field188 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 189 IF ga_table_data[p_i].field189 <> ga_page_data_t.field189 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 190 IF ga_table_data[p_i].field190 <> ga_page_data_t.field190 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 191 IF ga_table_data[p_i].field191 <> ga_page_data_t.field191 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 192 IF ga_table_data[p_i].field192 <> ga_page_data_t.field192 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 193 IF ga_table_data[p_i].field193 <> ga_page_data_t.field193 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 194 IF ga_table_data[p_i].field194 <> ga_page_data_t.field194 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 195 IF ga_table_data[p_i].field195 <> ga_page_data_t.field195 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 196 IF ga_table_data[p_i].field196 <> ga_page_data_t.field196 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 197 IF ga_table_data[p_i].field197 <> ga_page_data_t.field197 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 198 IF ga_table_data[p_i].field198 <> ga_page_data_t.field198 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 199 IF ga_table_data[p_i].field199 <> ga_page_data_t.field199 THEN LET l_tag = 1 EXIT FOR END IF
         #WHEN 200 IF ga_table_data[p_i].field200 <> ga_page_data_t.field200 THEN LET l_tag = 1 EXIT FOR END IF
      END CASE
    END FOR
    RETURN l_tag
 
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 依照 p_query 設定產生 SUM name 及 SUM value 
# Date & Author..:
# Input Parameter: p_j,p_k,p_str,p_n
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_sum(p_j,p_k,p_str,p_n)
DEFINE p_j          LIKE type_file.num10  #目前所在的行數
DEFINE p_k          LIKE type_file.num10  #目前所在的欄位
DEFINE p_str        STRING                #check的group欄位值
DEFINE p_n          LIKE type_file.num5   #check的group欄位
DEFINE l_zan03      LIKE zan_file.zan03
DEFINE l_zan03_type LIKE zan_file.zan03
DEFINE l_number     LIKE type_file.num20_6
DEFINE l_total      LIKE gaq_file.gaq03
DEFINE l_zan07      LIKE zan_file.zan07
DEFINE l_zal04      LIKE zal_file.zal04
DEFINE l_sum_name   STRING
DEFINE l_i          LIKE type_file.num5
DEFINE l_azi01      LIKE azi_file.azi01
DEFINE l_scale      LIKE azi_file.azi03
DEFINE l_len        LIKE type_file.num10       #FUN-920079
DEFINE l_space      LIKE type_file.num10       #FUN-920079
 
 LET l_zan03_type = g_feld_sum[p_k,g_feld_sum[p_k].getLength()]
 IF g_data_end = 0 AND l_zan03_type MATCHES "[BE]" THEN
     RETURN 0,'','','',''
 END IF
 
 LET l_zal04 = g_qry_feld_t[p_k] CLIPPED
 
 #FUN-770079
 #SELECT unique zan07 INTO l_zan07  FROM zal_file,zan_file 
 # WHERE zal01=zan01 AND zal02=zan02 AND zal04= l_zal04 
 #   AND zal01=g_query_prog  AND zal07=g_query_cust AND zal07=zan08 #FUN-750084
 
 FOR l_i = 1 TO g_zan.getLength()
     IF g_zan[l_i].zal04 = l_zal04 THEN
        LET l_zan07 = g_zan[l_i].zan07
        EXIT FOR
     END IF
 END FOR
 #END FUN-770079
 
 #最後小計的總計，平均的總計
 IF g_data_end_total = 1 THEN
    IF l_zan03_type = 'C' THEN
       LET l_zan03_type = 'B'
    END IF 
    IF l_zan03_type = 'F' THEN
       LET l_zan03_type = 'E'
    END IF 
 END IF
 
 #小計的小數字
 LET l_azi01 = cl_query_getvalue(g_scale_curr[p_k].curr_col)
 
 #TQC-810053
 #若此欄位的小數位設定欄位屬性為 [1234] 並且計算式設定為 [ABC] 時
 # total value 小數位則以 aooi050 的 [小計/總計] 為主
 IF g_scale_curr[p_k].scale_type MATCHES "[1234]" AND 
    l_zan03_type MATCHES "[ABC]"  
 THEN
     IF cl_null(g_scale_curr[p_k].curr_col) THEN
        SELECT aza17 INTO l_azi01 FROM aza_file
     END IF
     SELECT azi05 INTO l_scale FROM azi_file
          WHERE  azi01 = l_azi01
     #LET g_qry_scale[p_k] = l_scale
 ELSE
     IF g_scale_curr[p_k].aza17 != "Y" OR cl_null(g_scale_curr[p_k].aza17) THEN
        CASE g_scale_curr[p_k].scale_type 
          WHEN '1'
               SELECT azi03 INTO l_scale FROM azi_file
                    WHERE  azi01 = l_azi01
               LET g_qry_scale[p_k] = l_scale
          WHEN '2'
               SELECT azi04 INTO l_scale FROM azi_file
                    WHERE  azi01 = l_azi01
               LET g_qry_scale[p_k] = l_scale
          WHEN '3'
               SELECT azi05 INTO l_scale FROM azi_file
                    WHERE  azi01 = l_azi01
               LET g_qry_scale[p_k] = l_scale
          WHEN '4'
               SELECT azi07 INTO l_scale FROM azi_file
                    WHERE  azi01 = l_azi01
               LET g_qry_scale[p_k] = l_scale
          OTHERWISE
               LET l_scale = g_qry_scale[p_k]
        END CASE
     ELSE
        LET l_scale = g_qry_scale[p_k]
     END IF
 END IF
 
 #No.FUN-920079
 IF g_qry_length[p_k] > 37 THEN
    LET l_len = 37
    LET l_space = g_qry_length[p_k] - 37
 ELSE
    LET l_len = g_qry_length[p_k]   
 END IF
 CASE  
   WHEN l_zan03_type= 'A' OR l_zan03_type = 'C'
     LET l_total = l_space SPACES, cl_numfor(g_sum_rec[p_k].group_sum,l_len-1,l_scale) 
     LET l_zan03 = '1'
     
   WHEN l_zan03_type = 'B'
     LET l_total = l_space SPACES, cl_numfor(g_sum_rec[p_k].total_sum,l_len-1,l_scale) 
     LET l_zan03 = '2'
 
   WHEN l_zan03_type = 'D' OR l_zan03_type = 'F'
     LET l_number = g_sum_rec[p_k].group_sum / g_sum_rec[p_k].group_item
     LET l_total = l_space SPACES, cl_numfor(l_number,l_len-1,l_scale) 
     LET l_zan03 = '4'
 
   WHEN l_zan03_type = 'E'
     LET l_number = g_sum_rec[p_k].total_sum / g_sum_rec[p_k].total_item
     LET l_total = l_space SPACES, cl_numfor(l_number,l_len-1,l_scale) 
      LET l_zan03 = '5'
 
 END CASE
 #NED No.FUN-920079
 #END TQC-810053
 
 LET g_sum_rec[p_k].group_item = 0
 LET g_sum_rec[p_k].group_sum = 0
 
 CASE l_zan07
     WHEN '1'
        LET l_sum_name = g_qry_feld[p_n] CLIPPED," ",
                         g_sum_name[l_zan03] CLIPPED,":"
     WHEN '2'
        LET l_sum_name = g_sum_name[l_zan03] CLIPPED,":"
     OTHERWISE 
        LET l_sum_name = ""
        FOR l_i = 1 TO g_qry_length[p_k]
            LET l_sum_name = l_sum_name,"-" 
        END FOR
 END CASE
 
 RETURN 1,l_total,l_zan03,l_zan03_type,l_sum_name
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 取得顯示的欄位 value
# Date & Author..:
# Input Parameter: p_n
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_getvalue(p_n) 
DEFINE p_n       LIKE type_file.num5
DEFINE l_str     LIKE gaq_file.gaq03
 
      CASE p_n 
       WHEN   1  LET l_str=ga_page_data_t.field001
       WHEN   2  LET l_str=ga_page_data_t.field002
       WHEN   3  LET l_str=ga_page_data_t.field003
       WHEN   4  LET l_str=ga_page_data_t.field004
       WHEN   5  LET l_str=ga_page_data_t.field005
       WHEN   6  LET l_str=ga_page_data_t.field006
       WHEN   7  LET l_str=ga_page_data_t.field007
       WHEN   8  LET l_str=ga_page_data_t.field008
       WHEN   9  LET l_str=ga_page_data_t.field009
       WHEN  10  LET l_str=ga_page_data_t.field010
       WHEN  11  LET l_str=ga_page_data_t.field011
       WHEN  12  LET l_str=ga_page_data_t.field012
       WHEN  13  LET l_str=ga_page_data_t.field013
       WHEN  14  LET l_str=ga_page_data_t.field014
       WHEN  15  LET l_str=ga_page_data_t.field015
       WHEN  16  LET l_str=ga_page_data_t.field016
       WHEN  17  LET l_str=ga_page_data_t.field017
       WHEN  18  LET l_str=ga_page_data_t.field018
       WHEN  19  LET l_str=ga_page_data_t.field019
       WHEN  20  LET l_str=ga_page_data_t.field020
       WHEN  21  LET l_str=ga_page_data_t.field021
       WHEN  22  LET l_str=ga_page_data_t.field022
       WHEN  23  LET l_str=ga_page_data_t.field023
       WHEN  24  LET l_str=ga_page_data_t.field024
       WHEN  25  LET l_str=ga_page_data_t.field025
       WHEN  26  LET l_str=ga_page_data_t.field026
       WHEN  27  LET l_str=ga_page_data_t.field027
       WHEN  28  LET l_str=ga_page_data_t.field028
       WHEN  29  LET l_str=ga_page_data_t.field029
       WHEN  30  LET l_str=ga_page_data_t.field030
       WHEN  31  LET l_str=ga_page_data_t.field031
       WHEN  32  LET l_str=ga_page_data_t.field032
       WHEN  33  LET l_str=ga_page_data_t.field033
       WHEN  34  LET l_str=ga_page_data_t.field034
       WHEN  35  LET l_str=ga_page_data_t.field035
       WHEN  36  LET l_str=ga_page_data_t.field036
       WHEN  37  LET l_str=ga_page_data_t.field037
       WHEN  38  LET l_str=ga_page_data_t.field038
       WHEN  39  LET l_str=ga_page_data_t.field039
       WHEN  40  LET l_str=ga_page_data_t.field040
       WHEN  41  LET l_str=ga_page_data_t.field041
       WHEN  42  LET l_str=ga_page_data_t.field042
       WHEN  43  LET l_str=ga_page_data_t.field043
       WHEN  44  LET l_str=ga_page_data_t.field044
       WHEN  45  LET l_str=ga_page_data_t.field045
       WHEN  46  LET l_str=ga_page_data_t.field046
       WHEN  47  LET l_str=ga_page_data_t.field047
       WHEN  48  LET l_str=ga_page_data_t.field048
       WHEN  49  LET l_str=ga_page_data_t.field049
       WHEN  50  LET l_str=ga_page_data_t.field050
       WHEN  51  LET l_str=ga_page_data_t.field051
       WHEN  52  LET l_str=ga_page_data_t.field052
       WHEN  53  LET l_str=ga_page_data_t.field053
       WHEN  54  LET l_str=ga_page_data_t.field054
       WHEN  55  LET l_str=ga_page_data_t.field055
       WHEN  56  LET l_str=ga_page_data_t.field056
       WHEN  57  LET l_str=ga_page_data_t.field057
       WHEN  58  LET l_str=ga_page_data_t.field058
       WHEN  59  LET l_str=ga_page_data_t.field059
       WHEN  60  LET l_str=ga_page_data_t.field060
       WHEN  61  LET l_str=ga_page_data_t.field061
       WHEN  62  LET l_str=ga_page_data_t.field062
       WHEN  63  LET l_str=ga_page_data_t.field063
       WHEN  64  LET l_str=ga_page_data_t.field064
       WHEN  65  LET l_str=ga_page_data_t.field065
       WHEN  66  LET l_str=ga_page_data_t.field066
       WHEN  67  LET l_str=ga_page_data_t.field067
       WHEN  68  LET l_str=ga_page_data_t.field068
       WHEN  69  LET l_str=ga_page_data_t.field069
       WHEN  70  LET l_str=ga_page_data_t.field070
       WHEN  71  LET l_str=ga_page_data_t.field071
       WHEN  72  LET l_str=ga_page_data_t.field072
       WHEN  73  LET l_str=ga_page_data_t.field073
       WHEN  74  LET l_str=ga_page_data_t.field074
       WHEN  75  LET l_str=ga_page_data_t.field075
       WHEN  76  LET l_str=ga_page_data_t.field076
       WHEN  77  LET l_str=ga_page_data_t.field077
       WHEN  78  LET l_str=ga_page_data_t.field078
       WHEN  79  LET l_str=ga_page_data_t.field079
       WHEN  80  LET l_str=ga_page_data_t.field080
       WHEN  81  LET l_str=ga_page_data_t.field081
       WHEN  82  LET l_str=ga_page_data_t.field082
       WHEN  83  LET l_str=ga_page_data_t.field083
       WHEN  84  LET l_str=ga_page_data_t.field084
       WHEN  85  LET l_str=ga_page_data_t.field085
       WHEN  86  LET l_str=ga_page_data_t.field086
       WHEN  87  LET l_str=ga_page_data_t.field087
       WHEN  88  LET l_str=ga_page_data_t.field088
       WHEN  89  LET l_str=ga_page_data_t.field089
       WHEN  90  LET l_str=ga_page_data_t.field090
       WHEN  91  LET l_str=ga_page_data_t.field091
       WHEN  92  LET l_str=ga_page_data_t.field092
       WHEN  93  LET l_str=ga_page_data_t.field093
       WHEN  94  LET l_str=ga_page_data_t.field094
       WHEN  95  LET l_str=ga_page_data_t.field095
       WHEN  96  LET l_str=ga_page_data_t.field096
       WHEN  97  LET l_str=ga_page_data_t.field097
       WHEN  98  LET l_str=ga_page_data_t.field098
       WHEN  99  LET l_str=ga_page_data_t.field099
       WHEN 100  LET l_str=ga_page_data_t.field100
      #WHEN 101  LET l_str=ga_page_data_t.field101
      #WHEN 102  LET l_str=ga_page_data_t.field102
      #WHEN 103  LET l_str=ga_page_data_t.field103
      #WHEN 104  LET l_str=ga_page_data_t.field104
      #WHEN 105  LET l_str=ga_page_data_t.field105
      #WHEN 106  LET l_str=ga_page_data_t.field106
      #WHEN 107  LET l_str=ga_page_data_t.field107
      #WHEN 108  LET l_str=ga_page_data_t.field108
      #WHEN 109  LET l_str=ga_page_data_t.field109
      #WHEN 110  LET l_str=ga_page_data_t.field110
      #WHEN 111  LET l_str=ga_page_data_t.field111
      #WHEN 112  LET l_str=ga_page_data_t.field112
      #WHEN 113  LET l_str=ga_page_data_t.field113
      #WHEN 114  LET l_str=ga_page_data_t.field114
      #WHEN 115  LET l_str=ga_page_data_t.field115
      #WHEN 116  LET l_str=ga_page_data_t.field116
      #WHEN 117  LET l_str=ga_page_data_t.field117
      #WHEN 118  LET l_str=ga_page_data_t.field118
      #WHEN 119  LET l_str=ga_page_data_t.field119
      #WHEN 120  LET l_str=ga_page_data_t.field120
      #WHEN 121  LET l_str=ga_page_data_t.field121
      #WHEN 122  LET l_str=ga_page_data_t.field122
      #WHEN 123  LET l_str=ga_page_data_t.field123
      #WHEN 124  LET l_str=ga_page_data_t.field124
      #WHEN 125  LET l_str=ga_page_data_t.field125
      #WHEN 126  LET l_str=ga_page_data_t.field126
      #WHEN 127  LET l_str=ga_page_data_t.field127
      #WHEN 128  LET l_str=ga_page_data_t.field128
      #WHEN 129  LET l_str=ga_page_data_t.field129
      #WHEN 130  LET l_str=ga_page_data_t.field130
      #WHEN 131  LET l_str=ga_page_data_t.field131
      #WHEN 132  LET l_str=ga_page_data_t.field132
      #WHEN 133  LET l_str=ga_page_data_t.field133
      #WHEN 134  LET l_str=ga_page_data_t.field134
      #WHEN 135  LET l_str=ga_page_data_t.field135
      #WHEN 136  LET l_str=ga_page_data_t.field136
      #WHEN 137  LET l_str=ga_page_data_t.field137
      #WHEN 138  LET l_str=ga_page_data_t.field138
      #WHEN 139  LET l_str=ga_page_data_t.field139
      #WHEN 140  LET l_str=ga_page_data_t.field140
      #WHEN 141  LET l_str=ga_page_data_t.field141
      #WHEN 142  LET l_str=ga_page_data_t.field142
      #WHEN 143  LET l_str=ga_page_data_t.field143
      #WHEN 144  LET l_str=ga_page_data_t.field144
      #WHEN 145  LET l_str=ga_page_data_t.field145
      #WHEN 146  LET l_str=ga_page_data_t.field146
      #WHEN 147  LET l_str=ga_page_data_t.field147
      #WHEN 148  LET l_str=ga_page_data_t.field148
      #WHEN 149  LET l_str=ga_page_data_t.field149
      #WHEN 150  LET l_str=ga_page_data_t.field150
      #WHEN 151  LET l_str=ga_page_data_t.field151
      #WHEN 152  LET l_str=ga_page_data_t.field152
      #WHEN 153  LET l_str=ga_page_data_t.field153
      #WHEN 154  LET l_str=ga_page_data_t.field154
      #WHEN 155  LET l_str=ga_page_data_t.field155
      #WHEN 156  LET l_str=ga_page_data_t.field156
      #WHEN 157  LET l_str=ga_page_data_t.field157
      #WHEN 158  LET l_str=ga_page_data_t.field158
      #WHEN 159  LET l_str=ga_page_data_t.field159
      #WHEN 160  LET l_str=ga_page_data_t.field160
      #WHEN 161  LET l_str=ga_page_data_t.field161
      #WHEN 162  LET l_str=ga_page_data_t.field162
      #WHEN 163  LET l_str=ga_page_data_t.field163
      #WHEN 164  LET l_str=ga_page_data_t.field164
      #WHEN 165  LET l_str=ga_page_data_t.field165
      #WHEN 166  LET l_str=ga_page_data_t.field166
      #WHEN 167  LET l_str=ga_page_data_t.field167
      #WHEN 168  LET l_str=ga_page_data_t.field168
      #WHEN 169  LET l_str=ga_page_data_t.field169
      #WHEN 170  LET l_str=ga_page_data_t.field170
      #WHEN 171  LET l_str=ga_page_data_t.field171
      #WHEN 172  LET l_str=ga_page_data_t.field172
      #WHEN 173  LET l_str=ga_page_data_t.field173
      #WHEN 174  LET l_str=ga_page_data_t.field174
      #WHEN 175  LET l_str=ga_page_data_t.field175
      #WHEN 176  LET l_str=ga_page_data_t.field176
      #WHEN 177  LET l_str=ga_page_data_t.field177
      #WHEN 178  LET l_str=ga_page_data_t.field178
      #WHEN 179  LET l_str=ga_page_data_t.field179
      #WHEN 180  LET l_str=ga_page_data_t.field180
      #WHEN 181  LET l_str=ga_page_data_t.field181
      #WHEN 182  LET l_str=ga_page_data_t.field182
      #WHEN 183  LET l_str=ga_page_data_t.field183
      #WHEN 184  LET l_str=ga_page_data_t.field184
      #WHEN 185  LET l_str=ga_page_data_t.field185
      #WHEN 186  LET l_str=ga_page_data_t.field186
      #WHEN 187  LET l_str=ga_page_data_t.field187
      #WHEN 188  LET l_str=ga_page_data_t.field188
      #WHEN 189  LET l_str=ga_page_data_t.field189
      #WHEN 190  LET l_str=ga_page_data_t.field190
      #WHEN 191  LET l_str=ga_page_data_t.field191
      #WHEN 192  LET l_str=ga_page_data_t.field192
      #WHEN 193  LET l_str=ga_page_data_t.field193
      #WHEN 194  LET l_str=ga_page_data_t.field194
      #WHEN 195  LET l_str=ga_page_data_t.field195
      #WHEN 196  LET l_str=ga_page_data_t.field196
      #WHEN 197  LET l_str=ga_page_data_t.field197
      #WHEN 198  LET l_str=ga_page_data_t.field198
      #WHEN 199  LET l_str=ga_page_data_t.field199
      #WHEN 200  LET l_str=ga_page_data_t.field200
     END CASE
 
 RETURN l_str CLIPPED
 
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 多格式輸出選擇:
#                  (T) 文字檔
#                  (E) Microsoft Office Excel
#                  (P) Adobe Acrobat PDF
# Date & Author..:
# Input Parameter: none
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_output()
DEFINE l_choice         LIKE type_file.chr1
 
   MENU "output" ATTRIBUTE(STYLE="popup")
         ON ACTION output_t
             CALL cl_query_o('T')
             EXIT MENU
 
         ON ACTION output_x
             CALL cl_query_o('E')
             EXIT MENU
 
         ON ACTION output_p
             CALL cl_query_o('P')
             EXIT MENU
 
         ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE MENU
 
         #No.MOD-890009 --start--
         #No.TQC-860016 --start--
         #ON ACTION controlg
         #   CALL cl_cmdask()
 
         #ON ACTION about
         #   CALL cl_about()
 
         #ON ACTION help
         #   CALL cl_show_help()
         #No.TQC-860016 ---end---
         #No.MOD-890009 ---end---
   END MENU
   IF INT_FLAG THEN
      LET INT_FLAG = 0
   END IF
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 依照輸出選擇,產生報表檔
# Date & Author..:
# Input Parameter: p_type
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_o(p_type)
DEFINE p_type       LIKE zao_file.zao03
DEFINE l_status     LIKE type_file.num10
DEFINE l_url        STRING
DEFINE output_name  STRING
 
   #No.FUN-810021
   LET g_out_type = p_type
   CASE g_out_type
        WHEN 'T'
             LET output_name = g_zai07 CLIPPED,'_',g_user CLIPPED,'.txt'
             CALL cl_query_print(output_name)
        WHEN 'E'
             LET g_out_type = 'E'
             LET output_name = g_zai07 CLIPPED,'_',g_user CLIPPED,'.xls'
             CALL cl_query_print(output_name)
        WHEN 'P'
             LET output_name = g_zai07 CLIPPED,'_',g_user CLIPPED,'.out'
             CALL cl_query_print(output_name)
        #FUN-7C0020
        WHEN 'V'
             LET output_name = g_zai07 CLIPPED,'_',g_user CLIPPED,'.out'
             CALL cl_query_print(output_name)
        #END FUN-7C0020
   END CASE
   #END No.FUN-810021
  
   IF g_max_tag = 1 THEN
      CALL cl_err( '', 'azz-246', 1 )
      LET g_max_tag = 0
   END IF
 
   IF g_out_type NOT MATCHES "[PV]" THEN      
      CALL cl_prt_convert(output_name)
   ELSE
      #FUN-790050
      IF ms_codeset.getIndexOf("BIG5", 1) OR ( ms_codeset.getIndexOf("GB2312", 1) 
       OR ms_codeset.getIndexOf("GBK", 1) OR ms_codeset.getIndexOf("GB18030", 1) )
      THEN
        IF ms_locale = "ZH_TW" AND g_lang = '2' THEN
           LET ms_codeset = "GB2312"
        END IF
        IF ms_locale = "ZH_CN" AND g_lang = '0' THEN
           LET ms_codeset = "BIG5"
        END IF
      END IF
      #END FUN-790050
   END IF
 
   #TQC-810077   
   IF g_zao04[6] = 'N' THEN
      LET g_page_line = 0
   ELSE
      LET g_page_line = g_zap.zap02
   END IF
   #END TQC-810077
 
   #FUN-7C0020
   IF g_out_type = 'V' THEN
      IF cl_null(fgl_getenv("DBPRINT")) THEN
         CALL cl_err_msg(NULL,"9064",NULL,-1)
         RETURN
      END IF
      CALL cl_prt_l3(output_name,"1")
   ELSE
      IF g_out_type = 'P' THEN
         IF g_zao04[7] = 'N' THEN
            LET g_rlang = ''
         ELSE
            LET g_rlang = g_lang
         END IF
        #TQC-810077   
        #IF g_zao04[6] = 'N' THEN
        #   LET g_page_line = 0
        #ELSE
        #   LET g_page_line = g_zap.zap02
        #END IF
        #END TQC-810077   
         CALL cl_set_act_visible("accept,cancel", TRUE)
         CALL cl_prt_p(output_name)
         CALL cl_set_act_visible("accept,cancel", FALSE)
         RETURN
      END IF
      
      LET l_url = FGL_GETENV("FGLASIP") CLIPPED, "/tiptop/out/", output_name
       ## No.MOD-530309
      CALL ui.Interface.frontCall("standard",
                                  "shellexec",
                                  ["EXPLORER \"" || l_url || "\""],
                                  [l_status])
       ## end No.MOD-530309
      IF STATUS THEN
         CALL cl_err("Front End Call failed.", STATUS, 1)
         RETURN
      END IF
      IF NOT l_status THEN
         CALL cl_err("Application execution failed.", '!', 1)
         RETURN
      END IF
   END IF
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 依照 p_query 輸出格式設定產生報表
# Date & Author..:
# Input Parameter: p_type
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_print(p_name)
DEFINE p_name          STRING
DEFINE l_cmd           STRING
DEFINE l_i             LIKE type_file.num5
DEFINE l_str           STRING
 
   LET l_cmd = 'rm -f ',p_name CLIPPED
   RUN l_cmd
 
   #OPEN zao04_cs USING g_out_type
   FOREACH zao04_cs USING g_out_type INTO g_zao02,g_zao04_2
       LET g_zao04[g_zao02]= g_zao04_2
   END FOREACH
   CLOSE zao04_cs
   
   LET g_next_tag = 'N'
   LET g_max_tag = 0 
   IF g_zao04[6] = 'Y' THEN
      LET g_rec_b = g_zap.zap02-g_zap.zap03-g_zap.zap05
      IF g_zao04[1] = 'Y' THEN
          LET g_rec_b = g_rec_b - 12              #FUN-7B0010
      ELSE
          LET g_rec_b = g_rec_b - 4
      END IF
   END IF
 
   CALL cl_query_prt_sel('O')                     #FUN-770079
   CALL ui.Interface.refresh()
 
   IF g_query_rec_b < 1 THEN
      CALL cl_err('!','lib-216',1)
      RETURN
   END IF
 
   LET g_curr_page = 1                            #目前頁數
   IF g_zao04[6] = 'Y' THEN
      LET g_total_page = (ga_table_data.getLength()/g_rec_b)    #總頁數
      IF ga_table_data.getLength() MOD g_rec_b <> 0 THEN
         LET g_total_page = g_total_page + 1
      END IF
   ELSE
      LET g_rec_b = ga_table_data.getLength()
      LET g_total_page = 1
   END IF
 
   CALL cl_progress_bar(g_total_page)
 
   CALL ui.Interface.refresh()        #FUN-940109
 
   CASE g_out_type 
      WHEN 'T'
               LET l_str = "process: Text File"
      WHEN 'P'
               LET l_str = "process: Adobe Acrobat PDF "
      WHEN 'E'
               LET l_str = "process: Microsoft Office Excel"
      WHEN 'V'                                                #FUN-7C0020
               LET l_str = "process: Text File"               #FUN-7C0020
   END CASE
 
   FOR l_i = 1 TO g_total_page 
       LET g_curr_page = l_i
       CALL cl_query_prt_loadPage()
       IF g_out_type = 'E' THEN
           CALl cl_query_excel(p_name,l_i)     
       ELSE
           CALL cl_query_txt(p_name)
       END IF
       CALL cl_progressing(l_str)
   END FOR
 
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 產生文字檔
# Date & Author..:
# Input Parameter: p_name
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_txt(p_name)
DEFINE p_name          STRING
DEFINE l_str           STRING
DEFINE l_value         STRING
DEFINE l_dash          STRING
DEFINE l_channel       base.Channel
DEFINE l_i             LIKE type_file.num5
DEFINE l_j             LIKE type_file.num5
DEFINE l_k             LIKE type_file.num5
DEFINE l_cnt           LIKE type_file.num5
DEFINE l_tok           base.StringTokenizer
 
   LET l_channel = base.Channel.create()
   CALL l_channel.openFile(p_name,"a" )
   CALL l_channel.setDelimiter("")
 
   #PageHeader
   LET l_tok = base.StringTokenizer.createExt(g_header_str,"\n","",TRUE)
   WHILE l_tok.hasMoreTokens()
         LET l_value=l_tok.nextToken()
         CALL l_channel.write(l_value)
   END WHILE
 
   LET l_dash = ""
   FOR l_i = 1 TO g_len
       LET l_dash = l_dash,"="
   END FOR
   CALL l_channel.write(l_dash)
 
   #Body-title
   LET l_str = ""
   FOR l_i = 1 TO g_qry_feld_cnt
       IF g_qry_show[l_i] = "Y" THEN
          LET l_str = l_str,g_qry_feld[l_i]
          LET l_cnt = FGL_WIDTH(g_qry_feld[l_i]) - g_qry_length[l_i]
          LET l_cnt = g_qry_length[l_i] - FGL_WIDTH(g_qry_feld[l_i]) + 1
          #No.FUN-810062
          #FOR l_k = 1 TO l_cnt
          #    LET l_str = l_str," "
          #END FOR
          LET l_str = l_str, l_cnt SPACES
          #END No.FUN-810062
       END IF
   END FOR
   CALL l_channel.write(l_str)
 
   #Body-g_dash1(---- ----- ------ -----)
   LET l_str = ""
   FOR l_i = 1 TO g_qry_feld_cnt
       IF g_qry_show[l_i] = "Y" THEN
          FOR l_k = 1 TO g_qry_length[l_i]
              LET l_str = l_str,"-"
          END FOR
          LET l_str = l_str," "
       END IF
   END FOR
   CALL l_channel.write(l_str)
 
   #Body-on every row
   FOR l_j = 1 TO ga_page_data.getLength()
       LET ga_page_data_t.* = ga_page_data[l_j].*
       LET l_str = ""
       FOR l_i = 1 TO g_qry_feld_cnt
           IF g_qry_show[l_i] = "Y" THEN
              LET l_value = cl_query_getvalue(l_i)
              LET l_str = l_str, l_value 
              LET l_cnt = g_qry_length[l_i] - FGL_WIDTH(l_value) + 1
              #No.FUN-810062
              #FOR l_k = 1 TO l_cnt
              #    LET l_str = l_str," "
              #END FOR
              LET l_str = l_str, l_cnt SPACES
              #END No.FUN-810062
           END IF
       END FOR
       CALL l_channel.write(l_str)
   END FOR
 
   CALL l_channel.write(l_dash)
 
   #PageTrailer
   LET l_tok = base.StringTokenizer.createExt(g_trailer_str,"\n","",TRUE)
   WHILE l_tok.hasMoreTokens()
         LET l_value=l_tok.nextToken()
         CALL l_channel.write(l_value)
   END WHILE
 
   CALL l_channel.close()
 
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 產生 Excel 檔
# Date & Author..:
# Input Parameter: p_name,p_i
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_excel(p_name,p_i)
DEFINE p_name          STRING
DEFINE p_i             LIKE type_file.num5
DEFINE l_str           STRING
DEFINE l_contents      STRING         #FUN-A20036
DEFINE l_value         STRING
DEFINE l_dash          STRING
DEFINE l_channel       base.Channel
DEFINE l_i             LIKE type_file.num5
DEFINE l_j             LIKE type_file.num10     #FUN-AB0037 將變數型態加大,原本只有type_file.num5
DEFINE l_k             LIKE type_file.num5
DEFINE l_cnt           LIKE type_file.num5
DEFINE l_tok           base.StringTokenizer
DEFINE l_value_len     LIKE type_file.num5,
       l_dec           LIKE type_file.num5,
       l_dec_point     LIKE type_file.num5
DEFINE l_zal09         DYNAMIC ARRAY OF LIKE zal_file.zal09         #FUN-AA0074
DEFINE l_sql           STRING   #FUN-AA0074
 
   LET l_channel = base.Channel.create()
   CALL l_channel.openFile(p_name,"a" )
   CALL l_channel.setDelimiter("")
 
   IF p_i = 1 THEN
      LET l_str = ""
      CALL cl_qry_excel_column() RETURNING l_str    #MOD-580063
   ELSE
      LET l_str ="<body><div align=center>",        #No.TQC-B90082
                #"<TABLE BORDER=0 CELLSPACING=0 CELLPADDING=0 STYLE=\"font-size: 12pt\" >"
                 "<TABLE BORDER=0 CELLSPACING=0 CELLPADDING=0 >"
   END IF
   CALL l_channel.write(l_str)
 
   #PageHeader
   LET l_tok = base.StringTokenizer.createExt(g_header_str,"\n","",TRUE)
   WHILE l_tok.hasMoreTokens()
         LET l_value=l_tok.nextToken()
         LET l_str = "<TR height=22><TD colspan=",g_show_cnt," >",cl_add_span(l_value),"</TD></TR>"  #No.FUN-A90047  #FUN-A20036
         CALL l_channel.write(l_str)
   END WHILE
 
   #No.FUN-A90047 -- start --
   IF g_zao04[1] = 'Y' THEN
      LET l_str = "<TR height=22><TD colspan=",g_show_cnt,"> &nbsp; </TD></TR>"
      CALL l_channel.write(l_str)
   END IF
   #No.FUN-A90047 -- end --
 
   #Body
   LET l_str = "<TR height=22>"        #No.FUN-A90047
   FOR l_i = 1 TO g_qry_feld_cnt
       IF g_qry_show[l_i] = "Y" THEN
          LET l_contents = g_qry_feld[l_i] CLIPPED      #FUN-A20036 把資料內容引入 contents 變數          LET l_str = l_str,"<TD>",g_qry_feld[l_i] CLIPPED
          LET l_cnt = FGL_WIDTH(g_qry_feld[l_i]) - g_qry_length[l_i]
          LET l_cnt = g_qry_length[l_i] - FGL_WIDTH(g_qry_feld[l_i]) + 1
          FOR l_k = 1 TO l_cnt
              LET l_contents = l_contents,"&nbsp;"      #FUN-A20036 把資料內容引入 contents 變數
          END FOR
          LET l_str = l_str,"<TD>",cl_add_span(l_contents),"</TD>"     #FUN-580019   #FUN-A20036 最後再將 l_str 的html 指令包住
       END IF
   END FOR
   LET l_str = l_str CLIPPED,"</TR>"
   CALL l_channel.write(l_str)
 
   #No.FUN-A90047 -- start --
   IF g_zao04[1] = 'Y' THEN
      LET l_str = "<TR height=22><TD colspan=",g_show_cnt,"> &nbsp; </TD></TR>"
      CALL l_channel.write(l_str)
   END IF
   #No.FUN-A90047 -- end --
   
   #FUN-AA0074 -- start --
   LET l_sql = "SELECT zal09 FROM zal_file ", 
               "   WHERE zal01 = '", g_query_prog, "' AND zal07 = '", g_query_cust, "'",
               "     AND zal03 = '", g_lang, "' ",
               "   ORDER BY zal02"
   PREPARE cl_query_excel_zal09_pre FROM l_sql           #預備一下
   DECLARE cl_query_excel_zal09_curs CURSOR FOR cl_query_excel_zal09_pre
   LET l_i = 1
   FOREACH cl_query_excel_zal09_curs INTO l_zal09[l_i]
        LET l_i = l_i + 1
   END FOREACH
   CALL l_zal09.deleteElement(l_i)
   #FUN-AA0074 -- end --
 
   FOR l_j = 1 TO ga_page_data.getLength()
       LET ga_page_data_t.* = ga_page_data[l_j].*
       LET l_str = "<TR height=22>"                       #No.FUN-A90047
       FOR l_i = 1 TO g_qry_feld_cnt
           IF g_qry_show[l_i] = "Y" THEN
               LET l_value = cl_query_getvalue(l_i)
               IF g_qry_feld_type[l_i] = "varchar2" OR g_qry_feld_type[l_i] = "char" 
               OR g_qry_feld_type[l_i] = "date" 
               THEN
                  LET l_str = l_str,"<TD class=xl24>",cl_add_span(l_value)
               ELSE
                  LET l_dec_point = l_value.getIndexOf(".",1)
                  IF l_dec_point > 0 THEN
                     LET l_dec = l_value.getLength() - l_dec_point
                     #FUN-AA0074 -- start --
                     #IF l_dec >= 10 THEN
                     #   LET l_str = l_str,"<TD class=xl40>",l_value
                     #ELSE
                     #   LET l_str = l_str,"<TD class=xl3",l_dec USING '<<<<<<<<<<',">",l_value
                     #END IF  
                     IF l_dec >= 10 THEN
                        IF l_zal09[l_i] MATCHES '[ABDEFG]' THEN #單價、金額、總計
                           LET l_str = l_str,"<TD class=xl40>",l_value
                        ELSE
                           LET l_str = l_str,"<TD class=xl60>",l_value
                        END IF
                     ELSE
                        IF l_zal09[l_i] MATCHES '[ABDEFG]' THEN  #單價、金額、總計 
                           LET l_str = l_str,"<TD class=xl3",l_dec USING '<<<<<<<<<<',">",l_value
                        ELSE
                           LET l_str = l_str,"<TD class=xl5",l_dec USING '<<<<<<<<<<',">",l_value
                        END IF
                     END IF
                     #FUN-AA0074 -- end --
                  ELSE 
                     #FUN-AA0074 -- start --
                     #LET l_str = l_str,"<TD class=xl30>",l_value
                     IF l_zal09[l_i] MATCHES '[ABDEFG]' THEN     #單價、金額、總計 
                        LET l_str = l_str,"<TD class=xl30>",l_value
                     ELSE
                        LET l_str = l_str,"<TD class=xl50>",l_value
                     END IF                     
                     #FUN-AA0074 -- end --
                  END IF
               END IF
               LET l_cnt = g_qry_length[l_i] - FGL_WIDTH(l_value) + 1
               #No.FUN-810062
               #FOR l_k = 1 TO l_cnt
               #    LET l_str = l_str," "
               #END FOR
               LET l_str = l_str, l_cnt SPACES
               #END No.FUN-810062
               LET l_str = l_str.trimRight(),"</TD>"     #FUN-580019  #No.FUN-A90047
           END IF
       END FOR
        LET l_str = l_str ,"</TR>"
       CALL l_channel.write(l_str)
   END FOR

   #No.FUN-A90047 -- start --
   IF g_zao04[1] = 'Y' THEN
      LET l_str = "<TR height=22><TD colspan=",g_show_cnt,"> &nbsp; </TD></TR>"
      CALL l_channel.write(l_str)

      #PageTrailer
      LET l_tok = base.StringTokenizer.createExt(g_trailer_str,"\n","",TRUE)
      WHILE l_tok.hasMoreTokens()
            LET l_value=l_tok.nextToken()
            LET l_str = "<TR height=22><TD colspan=",g_show_cnt,"> ",cl_add_span(l_value.trimRight()),"</TD></TR>"
            CALL l_channel.write(l_str)
      END WHILE
   END IF

   #No.TQC-B90082 -- start --
   #LET l_str="</TABLE></div></body></html>"
   LET l_str="</TABLE></div></body>"
   IF p_i = g_total_page THEN
       LET l_str = l_str, "</html>"
   END IF
   #No.TQC-B90082 -- end --

   CALL l_channel.write(l_str)
   CALL l_channel.close()
   #No.FUN-A90047 -- end --
 
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: Excel 內容格式設定
# Date & Author..:
# Input Parameter: none
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_qry_excel_column()  
   DEFINE l_str            STRING
   DEFINE l_codeset        STRING
   DEFINE l_cnt            LIKE type_file.num10              #FUN-670044
 
   IF ms_codeset.getIndexOf("BIG5", 1) OR ( ms_codeset.getIndexOf("GB2312", 1) 
    OR ms_codeset.getIndexOf("GBK", 1) OR ms_codeset.getIndexOf("GB18030", 1) )
   THEN
     IF ms_locale = "ZH_TW" AND g_lang = '2' THEN
        LET ms_codeset = "GB2312"
     END IF
     IF ms_locale = "ZH_CN" AND g_lang = '0' THEN
        LET ms_codeset = "BIG5"
     END IF
   END IF
 
   IF not ms_codeset.getIndexOf("UTF-8", 1) THEN
      IF g_lang = "0" THEN
         LET l_codeset = "big5"
      ELSE
         IF g_lang = "2" THEN 
            IF ms_codeset.getIndexOf("GB2312", 1) THEN
               LET l_codeset = "GB2312"
            ELSE
               IF ms_codeset.getIndexOf("GBK", 1) THEN
                  LET l_codeset = "GBK"
               ELSE
                  IF ms_codeset.getIndexOf("GB18030", 1) THEN
                     LET l_codeset = "GB18030"
                  END IF
               END IF
            END IF
         ELSE
              LET l_codeset = "utf-8"
         END IF
      END IF
   ELSE
      LET l_codeset = "utf-8"
   END IF
 
 
   LET l_str ="<html xmlns:o=\"urn:schemas-microsoft-com:office:office\"",
              "xmlns:x=\"urn:schemas-microsoft-com:office:excel\"",
              "xmlns=\"http://www.w3.org/TR/REC-html40\">",
              "<head>",
              "<meta http-equiv=Content-Type content=\"text/html; charset=",l_codeset,"\">"
 
   LET l_str = l_str,"<style><!--"
   #IF FGL_GETENV("TOPLOCALE") <> "1" THEN   mark by TQC-5B0077 ##
   IF not ms_codeset.getIndexOf("UTF-8", 1) THEN    ## TQC-5B0077 ##
       CASE g_lang
   #MOD-590325
          WHEN "0"
              LET l_str = l_str,"td  {font-family:細明體, serif;}",
                         " pre ",
                     "{margin:0cm; ",
                      " margin-bottom:.0001pt; ",
                     #    " font-size:12.0pt;      ",         ##MOD-580063
                         " font-family:細明體;    ",
                         " mso-bidi-font-family:\"Courier New\";} "
          WHEN "2"
              LET l_str = l_str,"td  {font-family:新宋体, serif;}",
                         " pre ",
                     "{margin:0cm; ",
                      " margin-bottom:.0001pt; ",
                     #    " font-size:12pt;      ",         ##MOD-580063
                         " font-family:新宋体;    ",
                         " mso-bidi-font-family:\"Courier New\";} "
          OTHERWISE
              LET l_str = l_str,"td  {font-family:細明體, serif;}",
                         " pre ",
                     "{margin:0cm; ",
                      " margin-bottom:.0001pt; ",
                     #    " font-size:12pt;      ",         ##MOD-580063
                         " font-family:細明體;    ",
                         " mso-bidi-font-family:\"Courier New\";} "
       END CASE
   ELSE
         LET l_str = l_str,"td  {font-family:細明體, serif;}",
                     " pre ",
                 "{margin:0cm; ",
                  " margin-bottom:.0001pt; ",
                   #  " font-size:12pt;      ",         ##MOD-580063
                     " font-family:細明體;    ",
                     " mso-bidi-font-family:\"Courier New\";} "
   END IF
   #END MOD-590325
 
   LET l_str = l_str,
       ".xl30 {mso-style-parent:style0; mso-number-format:\"\#\,\#\#0_ \";} ",
       ".xl31 {mso-style-parent:style0; mso-number-format:\"\#\,\#\#0\.0_ \";} ",
       ".xl32 {mso-style-parent:style0; mso-number-format:\"\#\,\#\#0\.00_ \";} ",
       ".xl33 {mso-style-parent:style0; mso-number-format:\"\#\,\#\#0\.000_ \";} ",
       ".xl34 {mso-style-parent:style0; mso-number-format:\"\#\,\#\#0\.0000_ \";} ",
       ".xl35 {mso-style-parent:style0; mso-number-format:\"\#\,\#\#0\.00000_ \";} ",
       ".xl36 {mso-style-parent:style0; mso-number-format:\"\#\,\#\#0\.000000_ \";} ",
       ".xl37 {mso-style-parent:style0; mso-number-format:\"\#\,\#\#0\.0000000_ \";} ",
       ".xl38 {mso-style-parent:style0; mso-number-format:\"\#\,\#\#0\.00000000_ \";} ",
       ".xl39 {mso-style-parent:style0; mso-number-format:\"\#\,\#\#0\.000000000_ \";} ",
       ".xl40 {mso-style-parent:style0; mso-number-format:\"\#\,\#\#0\.0000000000_ \";} ",
       #FUN-AA0074 -- start --
       ".xl50 {mso-style-parent:style0; mso-number-format:\"0_ \";} ",
       ".xl51 {mso-style-parent:style0; mso-number-format:\"0\.0_ \";} ",
       ".xl52 {mso-style-parent:style0; mso-number-format:\"0\.00_ \";} ",
       ".xl53 {mso-style-parent:style0; mso-number-format:\"0\.000_ \";} ",
       ".xl54 {mso-style-parent:style0; mso-number-format:\"0\.0000_ \";} ",
       ".xl55 {mso-style-parent:style0; mso-number-format:\"0\.00000_ \";} ",
       ".xl56 {mso-style-parent:style0; mso-number-format:\"0\.000000_ \";} ",
       ".xl57 {mso-style-parent:style0; mso-number-format:\"0\.0000000_ \";} ",
       ".xl58 {mso-style-parent:style0; mso-number-format:\"0\.00000000_ \";} ",
       ".xl59 {mso-style-parent:style0; mso-number-format:\"0\.000000000_ \";} ",
       ".xl60 {mso-style-parent:style0; mso-number-format:\"0\.0000000000_ \";} "
       #FUN-AA0074 -- start --
 
   LET l_str = l_str,".xl24  { mso-number-format:\"@\";}",
              "--></style>",
              "<!--[if gte mso 9]><xml>",
              "<x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet>",
              "<x:Name>Sheet1</x:Name><x:WorksheetOptions>",    #FUN-A30115
              "<x:DefaultRowHeight>330</x:DefaultRowHeight>",
              "<x:Selected/><x:DoDisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorkbook>", #FUN-A30115
              "</xml><![endif]--></head>"
 
   LET l_str = l_str,
              "<body>",                     #No.FUN-A90047
              "<div align=center>",
            # "<TABLE BORDER=0 CELLSPACING=0 CELLPADDING=0 STYLE=\"font-size: 12pt\" >"
              "<TABLE BORDER=0 CELLSPACING=0 CELLPADDING=0 >"
       RETURN l_str
 
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 進行查詢(QBE)、過濾條件輸入
# Date & Author..:
# Input Parameter: p_cmd
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_curs(p_cmd)
DEFINE p_cmd            LIKE type_file.chr1   #F:過瀘功能, V:查詢畫面(per)
DEFINE buf              base.StringBuffer
DEFINE buf2             base.StringBuffer
DEFINE l_tok            base.StringTokenizer
DEFINE lw_w             ui.Window
DEFINE lnode_item       om.DomNode
DEFINE nl_date          om.NodeList
DEFINE l_i              LIKE type_file.num10
DEFINE cnt_date         LIKE type_file.num5
DEFINE l_status         LIKE type_file.num5
DEFINE l_p              LIKE type_file.num5
DEFINE l_cnt            LIKE type_file.num5
DEFINE l_date           LIKE type_file.dat
DEFINE l_date2          LIKE type_file.dat
DEFINE ls_colname       STRING
DEFINE l_name           STRING
DEFINE l_value          STRING
DEFINE l_more           STRING                #FUN-770079
DEFINE l_symbol         STRING
DEFINE l_wc             STRING
#TQC-790050
DEFINE l_wc2            STRING                
DEFINE l_str            STRING               
DEFINE l_str2           STRING               
DEFINE l_arg_value      STRING
DEFINE l_arg            STRING
DEFINE l_start          LIKE type_file.num10        
DEFINE l_end            LIKE type_file.num10        
DEFINE l_zak02          LIKE zak_file.zak02   
#END TQC-790050
 
    #TQC-790050
    IF NOT (g_zai04 = 'N' AND p_cmd = "V") THEN
       CALL cl_query_curs_buildForm(p_cmd)
   
       LET lw_w=ui.window.getcurrent()
   
       CALL FGL_DIALOG_SETFIELDORDER(FALSE)
       CONSTRUCT l_wc ON
             field001, field002, field003, field004, field005, field006, field007,
             field008, field009, field010, field011, field012, field013, field014,
             field015, field016, field017, field018, field019, field020, field021,
             field022, field023, field024, field025, field026, field027, field028,
             field029, field030, field031, field032, field033, field034, field035,
             field036, field037, field038, field039, field040, field041, field042,
             field043, field044, field045, field046, field047, field048, field049,
             field050, field051, field052, field053, field054, field055, field056,
             field057, field058, field059, field060, field061, field062, field063,
             field064, field065, field066, field067, field068, field069, field070,
             field071, field072, field073, field074, field075, field076, field077,
             field078, field079, field080, field081, field082, field083, field084,
             field085, field086, field087, field088, field089, field090, field091,
             field092, field093, field094, field095, field096, field097, field098,
             field099, field100, more               #FUN-770079
            #field101, field102, field103, field104, field105, field106, field107,
            #field108, field109, field110, field111, field112, field113, field114,
            #field115, field116, field117, field118, field119, field120, field121,
            #field122, field123, field124, field125, field126, field127, field128,
            #field129, field130, field131, field132, field133, field134, field135,
            #field136, field137, field138, field139, field140, field141, field142,
            #field143, field144, field145, field146, field147, field148, field149,
            #field150, field151, field152, field153, field154, field155, field156,
            #field157, field158, field159, field160, field161, field162, field163,
            #field164, field165, field166, field167, field168, field169, field170,
            #field171, field172, field173, field174, field175, field176, field177,
            #field178, field179, field180, field181, field182, field183, field184,
            #field185, field186, field187, field188, field189, field190, field191,
            #field192, field193, field194, field195, field196, field197, field198,
            #field199, field200 
        FROM
             field001, field002, field003, field004, field005, field006, field007,
             field008, field009, field010, field011, field012, field013, field014,
             field015, field016, field017, field018, field019, field020, field021,
             field022, field023, field024, field025, field026, field027, field028,
             field029, field030, field031, field032, field033, field034, field035,
             field036, field037, field038, field039, field040, field041, field042,
             field043, field044, field045, field046, field047, field048, field049,
             field050, field051, field052, field053, field054, field055, field056,
             field057, field058, field059, field060, field061, field062, field063,
             field064, field065, field066, field067, field068, field069, field070,
             field071, field072, field073, field074, field075, field076, field077,
             field078, field079, field080, field081, field082, field083, field084,
             field085, field086, field087, field088, field089, field090, field091,
             field092, field093, field094, field095, field096, field097, field098,
             field099, field100, more               #FUN-770079
   
            #field101, field102, field103, field104, field105, field106, field107,
            #field108, field109, field110, field111, field112, field113, field114,
            #field115, field116, field117, field118, field119, field120, field121,
            #field122, field123, field124, field125, field126, field127, field128,
            #field129, field130, field131, field132, field133, field134, field135,
            #field136, field137, field138, field139, field140, field141, field142,
            #field143, field144, field145, field146, field147, field148, field149,
            #field150, field151, field152, field153, field154, field155, field156,
            #field157, field158, field159, field160, field161, field162, field163,
            #field164, field165, field166, field167, field168, field169, field170,
            #field171, field172, field173, field174, field175, field176, field177,
            #field178, field179, field180, field181, field182, field183, field184,
            #field185, field186, field187, field188, field189, field190, field191,
            #field192, field193, field194, field195, field196, field197, field198,
            #field199, field200 
   
            BEFORE CONSTRUCT
                CALL cl_set_act_visible("controlp",FALSE) 
                SELECT COUNT(*) INTO l_cnt  FROM zat_file
                 WHERE zat01 = g_query_prog AND zat10 = g_query_cust
                   AND zat04 > 0            AND zat05 = "Y"
   
                IF l_cnt > 0 THEN
                   CALL cl_set_act_visible("controlp",TRUE) 
                END IF
   
            AFTER FIELD field001, field002, field003, field004, field005, field006, field007,
             field008, field009, field010, field011, field012, field013, field014,
             field015, field016, field017, field018, field019, field020, field021,
             field022, field023, field024, field025, field026, field027, field028,
             field029, field030, field031, field032, field033, field034, field035,
             field036, field037, field038, field039, field040, field041, field042,
             field043, field044, field045, field046, field047, field048, field049,
             field050, field051, field052, field053, field054, field055, field056,
             field057, field058, field059, field060, field061, field062, field063,
             field064, field065, field066, field067, field068, field069, field070,
             field071, field072, field073, field074, field075, field076, field077,
             field078, field079, field080, field081, field082, field083, field084,
             field085, field086, field087, field088, field089, field090, field091,
             field092, field093, field094, field095, field096, field097, field098,
             field099, field100 
            #field101, field102, field103, field104, field105, field106, field107,
            #field108, field109, field110, field111, field112, field113, field114,
            #field115, field116, field117, field118, field119, field120, field121,
            #field122, field123, field124, field125, field126, field127, field128,
            #field129, field130, field131, field132, field133, field134, field135,
            #field136, field137, field138, field139, field140, field141, field142,
            #field143, field144, field145, field146, field147, field148, field149,
            #field150, field151, field152, field153, field154, field155, field156,
            #field157, field158, field159, field160, field161, field162, field163,
            #field164, field165, field166, field167, field168, field169, field170,
            #field171, field172, field173, field174, field175, field176, field177,
            #field178, field179, field180, field181, field182, field183, field184,
            #field185, field186, field187, field188, field189, field190, field191,
            #field192, field193, field194, field195, field196, field197, field198,
            #field199, field200 
   
             LET l_value = FGL_DIALOG_GETBUFFER()
             IF NOT cl_null(l_value) THEN
                LET l_name = FGL_DIALOG_GETFIELDNAME()
                LET lnode_item = lw_w.findNode("FormField",l_name)          
                LET nl_date = lnode_item.selectByTagName("DateEdit")
                LET cnt_date = nl_date.getLength()
                IF cnt_date > 0 THEN 
                   LET l_status = 0 
                  #LET l_value = cl_query_cut_spaces(l_value)
                   LET l_value = l_value.trim()                      #FUN-810062
   
                   LET buf = base.StringBuffer.create()
                   CALL buf.append(l_value)
                   CALL buf.replace(" ","", 0)
                   LET l_value = buf.toString()
                   #判斷日期格式是否正確
                   CASE 
                     WHEN l_value.getIndexOf(">=",1) > 0  
                          LET l_p = l_value.getIndexOf(">=",1)
                          LET l_symbol = ">="
                     WHEN l_value.getIndexOf("<=",1) > 0
                          LET l_p = l_value.getIndexOf("<=",1)
                          LET l_symbol = "<="
                     WHEN l_value.getIndexOf("<>",1) > 0
                          LET l_p = l_value.getIndexOf("<>",1)
                          LET l_symbol = "<>"
                     WHEN l_value.getIndexOf("!=",1) > 0
                          LET l_p = l_value.getIndexOf("!=",1)
                          LET l_symbol = "!="
                     WHEN l_value.getIndexOf(">",1) > 0
                          LET l_p = l_value.getIndexOf(">",1)
                          LET l_symbol = ">" 
                     WHEN l_value.getIndexOf("<",1) > 0
                          LET l_p = l_value.getIndexOf("<",1)
                          LET l_symbol = "<"
                     WHEN l_value.getIndexOf("=",1) > 0
                          LET l_p = l_value.getIndexOf("=",1)
                          LET l_symbol = "="
                     WHEN l_value.getIndexOf(":",1) > 0
                          LET l_p = l_value.getIndexOf(":",1)
                          LET l_symbol = ":"
                     WHEN l_value.getIndexOf("|",1) > 0
                          LET l_p = l_value.getIndexOf("|",1)
                          LET l_symbol = "|"
                     OTHERWISE
                         #LET l_p = 0
                          LET l_p = 1                    #MOD-890218
                          LET l_symbol = ""
                   END CASE
                    
                   IF l_symbol = ":" OR l_symbol = "|" THEN
                       LET l_date = l_value.subString(1,l_p-1)
                       IF cl_null(l_date) THEN
                          LET l_status = 1
                       ELSE 
                          LET l_date2 = l_value.subString(l_p+1,l_value.getLength())
                          IF cl_null(l_date2) THEN
                             LET l_status = 1
                          ELSE
                             LET l_value = l_date,l_symbol ,l_date2
                          END IF
                       END IF
                   ELSE
                      #LET l_date = l_value.subString(l_p+1,l_value.getLength())
                       LET l_date = l_value.subString(l_p+l_symbol.getLength(),l_value.getLength())  #No.MOD-890009
                       IF cl_null(l_date) THEN
                          #---FUN-B10042---start------
                          #當使用者輸入單一個'='時代表要將所以日期欄位 = NULL當成條件帶入
                          IF l_value.trim() = "=" THEN
                             LET l_status = 0
                          ELSE
                          #---FUN-B10042---end--------
                             LET l_status = 1
                          END IF   #FUN-B10042
                       ELSE
                          LET l_value = l_symbol,l_date
                       END IF
                   END IF
                   IF l_status THEN 
                      CALL cl_err('','-1106',0)
                      NEXT FIELD CURRENT
                   ELSE
                      DISPLAY l_value
                      CALL FGL_DIALOG_SETBUFFER(l_value)
                   END IF
                END IF
             END IF
   
            AFTER FIELD more
               LET l_more = FGL_DIALOG_GETBUFFER()
                
            ON ACTION CONTROLP
              LET l_name = FGL_DIALOG_GETFIELDNAME()
              LET l_value = FGL_DIALOG_GETBUFFER()
              LET l_i = l_name.subString(6,l_name.getLength())
              IF (p_cmd = "V" AND (NOT cl_null(g_field_seq[l_i].qbe))) OR
                 (p_cmd = "F" AND (NOT cl_null(g_qry_qbe[l_i])))
              THEN
                 CALL cl_init_qry_var()
                 LET g_frm_name = g_query_prog
                 IF p_cmd = "F" THEN
                     LET g_qryparam.form =  g_qry_qbe[l_i]
                     LET g_fld_name = g_qry_feld_t[l_i]
                 ELSE
                     LET g_qryparam.form =  g_field_seq[l_i].qbe
                     LET g_fld_name = g_field_seq[l_i].id
                 END IF
                 LET g_qryparam.state = "c"
                 CALL cl_dynamic_qry() RETURNING g_qryparam.multiret  
                 CALL FGL_DIALOG_SETBUFFER(g_qryparam.multiret)
                 NEXT FIELD CURRENT
              END IF
              # CASE
              #     WHEN INFIELD(field001)
              # END CASE
   
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
   
            ON ACTION controlg      #MOD-4C0121
               CALL cl_cmdask()     #MOD-4C0121
   
            #No.TQC-860016 --start--
            ON ACTION about
               CALL cl_about()
 
            ON ACTION help
               CALL cl_show_help()
            #No.TQC-860016 ---end---
       END CONSTRUCT
       CALL cl_set_act_visible("controlp",TRUE) 
       
       IF INT_FLAG THEN                              #使用者不玩了
          CLOSE WINDOW cl_query_curs_w              #FUN-770079
          RETURN ''
       END IF
    END IF
    IF p_cmd = "V" AND g_zz05="Y" THEN
       #將傳入的參數條件加入列印條件
       SELECT zak02 INTO l_zak02 FROM zak_file 
        WHERE zak01 = g_query_prog AND zak07 = g_query_cust
       LET l_str = l_zak02 CLIPPED
       LET l_str = l_str.toLowerCase()
       IF l_str.getIndexOf("arg",1) > 0 THEN
          LET l_start = l_str.getIndexOf("where",1)
          LET l_start = l_start + 6
          LET l_end   = l_str.getIndexOf('order',1)
          IF l_end > 0  THEN
             LET l_end = l_end - 1
          ELSE
             LET l_end = l_str.getLength()
          END IF
          LET l_str2 = l_str.subString(l_start,l_end)
 
          LET buf = base.StringBuffer.create()
          CALL buf.append(l_str2)
          CALL buf.replace("\n","", 0)                  #TQC-810053
          CALL buf.replace(" and ","&", 0)
          LET l_str2 = buf.toString()
 
          FOR l_i = 1 TO 50 
              LET l_arg_value = ARG_VAL(l_i+1)
              LET l_arg = "arg",l_i USING '<<<<<'
              LET l_tok = base.StringTokenizer.createExt(l_str2,"&","",TRUE)
              WHILE l_tok.hasMoreTokens()
                    LET l_value=l_tok.nextToken()
                    LET l_p  = l_value.getIndexOf(l_arg,1)
                    IF l_p > 0 AND l_arg_value IS NOT NULL THEN
                       LET l_value = l_value.subString(1,l_p-1),l_arg_value CLIPPED,
                                   l_value.subString(l_p+l_arg.getLength(),l_value.getLength())
                       IF cl_null(l_wc2) THEN
                            LET l_wc2 = l_value.trim()
                       ELSE
                            LET l_wc2 = l_wc2 , " AND ", l_value.trim() 
                       END IF
                       EXIT WHILE
                    END IF
              END WHILE
          END FOR
       END IF
    END IF
    IF NOT cl_null(l_wc2) THEN
       IF cl_null(l_wc) OR l_wc = " 1=1" THEN
          LET l_wc = l_wc2
       ELSE
          LET l_wc = l_wc , " AND ", l_wc2
       END IF
    ELSE
       IF cl_null(l_wc) THEN
          LET l_wc = " 1=1"
       END IF
    END IF
    #END TQC-790050
    #將 field000 取代為 Field_ID
    IF l_wc <> " 1=1" THEN
       LET buf = base.StringBuffer.create()
       CALL buf.append(l_wc)
       #IF p_cmd = "F" THEN   
       IF p_cmd = "F" OR g_zai04 = "N" THEN        #No.TQC-790173
           LET l_cnt = g_qry_feld_cnt
       ELSE
           LET l_cnt = g_field_seq.getLength()
       END IF
      
       #IF g_zai04 = "Y" THEN                       #No.TQC-790173 #FUN-7C0020
          FOR l_i = 1 TO l_cnt
              LET ls_colname = "field", l_i USING "&&&"
              IF p_cmd = "F" THEN
                 CALL buf.replace( ls_colname,g_qry_feld_t[l_i], 0)
              ELSE
                 CALL buf.replace( ls_colname,g_field_seq[l_i].id, 0)
              END IF
          END FOR
       #END IF                                      #No.TQC-790173  #FUN-7C0020
       IF g_zz05="Y" THEN
          #產生列印條件  
          LET buf2 = base.StringBuffer.create()
          CALL buf2.append(l_wc)
          FOR l_i = 1 TO l_cnt
              LET ls_colname = "field", l_i USING "&&&"
              IF p_cmd = "F" OR g_zai04 = "N" THEN           #No.TQC-790173
                 CALL buf2.replace( ls_colname,g_qry_feld[l_i], 0)
                 CALL buf2.replace( g_qry_feld_t[l_i],g_qry_feld[l_i], 0) #FUN-790050
              ELSE
                 CALL buf2.replace( ls_colname,g_field_seq[l_i].name, 0)
                 CALL buf2.replace( g_qry_feld_t[l_i],g_field_seq[l_i].name, 0) #FUN-790050
              END IF
          END FOR
          CALL buf2.replace(" and "," AND ", 0)                    #FUN-790050
          IF p_cmd = "F" THEN
             IF NOT cl_null(g_wc2_name) THEN
                  LET g_wc2_name = g_wc2_name," AND ",buf2.toString()
             ELSE
                  LET g_wc2_name = buf2.toString()
             END IF
          ELSE
             LET g_wc_name = buf2.toString()
          END IF
       END IF
       #FUN-770079
       CASE l_more 
         WHEN 'Y' 
            CALL buf.replace("more='Y'","1=1", 0)
         WHEN 'N' 
            CALL buf.replace("more='N'","1=1", 0)
       END CASE
       #FUN-770079
 
       LET l_wc = buf.toString()
 
       IF l_more = 'Y' THEN
          CALL cl_query_advance()                      #進階查詢條件
          IF INT_FLAG THEN                              #使用者不玩了
             CLOSE WINDOW cl_query_curs_w              #FUN-770079
             RETURN ''
          END IF
       END IF
 
    ELSE 
       IF g_zz05 = "Y" THEN
          IF p_cmd <> "F" THEN
             LET g_wc_name = " 1=1"
          END IF
       END IF
    END IF
 
    IF NOT (g_zai04 = 'N' AND p_cmd = "V") THEN        #FUN-790050
       CLOSE WINDOW cl_query_curs_w                    #FUN-770079
    END IF
    RETURN l_wc
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 動態建立查詢(QBE)、過濾視窗畫面
# Date & Author..:
# Input Parameter: p_cmd
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_curs_buildForm(p_cmd)
    DEFINE p_cmd        LIKE type_file.chr1
    DEFINE lw_win       ui.Window
    DEFINE lf_form      ui.Form
    DEFINE ln_win       om.DomNode,  
           ln_form      om.DomNode, 
           ln_group     om.DomNode,
           ln_vbox      om.DomNode,
           ln_hbox      om.DomNode
    DEFINE l_ze03       LIKE ze_file.ze03
    DEFINE l_gae04      LIKE gae_file.gae04
#No.FUN-7B0010          
    DEFINE ls_msg       STRING                            
    DEFINE ls_tmp       STRING                            
    DEFINE l_zo02       LIKE zo_file.zo02                 
    DEFINE ls_ze031     LIKE ze_file.ze03
    DEFINE ls_ze032     LIKE ze_file.ze03
    DEFINE lc_zx02      LIKE zx_file.zx02
#END No.FUN-7B0010
    DEFINE lc_zz011     LIKE zz_file.zz011   #MOD-C30123
    DEFINE lc_azp02     LIKE azp_file.azp02  #MOD-C30123
    DEFINE lc_azz05     LIKE azz_file.azz05  #MOD-C30123                                                                                                                        
    DEFINE lc_azp052    LIKE azp_file.azp052 #MOD-C30123

 
    OPEN WINDOW cl_query_curs_w WITH FORM "lib/42f/cl_dummy" ATTRIBUTE(STYLE="create_qry")
 
    CALL cl_load_style_list(NULL)
    CALL cl_ui_locale("cl_dummy")
 
    LET lw_win = ui.Window.getCurrent()
    LET ln_win = lw_win.getNode()
 
    IF p_cmd = 'F' THEN
       #No.FUN-810021
        SELECT ze03 INTO l_ze03 FROM ze_file   
           WHERE ze01='lib-213' AND ze02=g_lang
 
       LET l_ze03 = l_ze03 CLIPPED," ",g_zai02 CLIPPED
       LET ls_msg = l_ze03 CLIPPED
       #END No.FUN-810021
    ELSE
       # 選擇 程式模組(zz_file.zz011) #MOD-C30123 start---
       SELECT zz011 INTO lc_zz011 FROM zz_file WHERE zz01=g_prog
       LET ls_ze031=""
       IF lc_zz011[1]="C" THEN
          SELECT ze03 INTO ls_ze031 FROM ze_file
           WHERE ze01 = 'lib-051' AND ze02 = g_lang
       END IF
       #MOD-C30123 end---

       #LET ls_msg = l_ze03 CLIPPED, "(", g_zai01 CLIPPED, ")"
       #LET ls_msg = g_zai02 CLIPPED, "(", g_zai07 CLIPPED, ")"   #No.FUN-810021 ,mark by #MOD-C30123
       LET ls_msg= g_zai02 CLIPPED, "(", g_zai07 CLIPPED,ls_ze031 CLIPPED, ")" #MOD-C30123

       SELECT zo02 INTO l_zo02 FROM zo_file WHERE zo01=g_lang
       IF (SQLCA.SQLCODE) THEN
          LET l_zo02 = "Empty"
       END IF
       
       SELECT azp02 INTO lc_azp02 FROM azp_file WHERE azp01 = g_plant #aza_file.azp02 營運中心說明 #MOD-C30123
       #LET ls_tmp = "[" || l_zo02 CLIPPED || "](" || g_dbs CLIPPED || ")" mark by #MOD-C30123
       LET ls_tmp = "[" , l_zo02 CLIPPED , "][" , g_plant CLIPPED , ":" , lc_azp02 CLIPPED , "](" ,  g_dbs CLIPPED , ")" #MOD-C30123
       LET ls_msg = ls_msg.trim(), ls_tmp.trim()
       
       LET ls_ze031="" LET ls_ze032=""
       SELECT ze03 INTO ls_ze031 FROM ze_file     # 日期
        WHERE ze01 = 'lib-035' AND ze02 = g_lang
       SELECT ze03 INTO ls_ze032 FROM ze_file     # 使用者
        WHERE ze01 = 'lib-036' AND ze02 = g_lang
       
       SELECT zx02 INTO lc_zx02 FROM zx_file WHERE zx01=g_user
       IF (SQLCA.SQLCODE) THEN
          LET lc_zx02 = g_user
       END IF
       
       #LET ls_tmp = "  " || ls_ze031 CLIPPED || ":" || g_today CLIPPED || "  " || ls_ze032 CLIPPED || ":" || lc_zx02 CLIPPED #mark #MOD-C30123
       # 時間顯示 (若開時區則加 show GMT表示式) #MOD-C30123 start---
       LET ls_tmp = "  " , ls_ze031 CLIPPED , ":" , g_today CLIPPED 
       SELECT azz05 INTO lc_azz05 FROM azz_file WHERE azz01 = "0"
       IF lc_azz05 IS NOT NULL AND lc_azz05 = "Y" THEN
          #SELECT azp052 INTO lc_azp052 FROM azp_file WHERE azp03 = g_dbs  #MOD-C40107 mark
          SELECT azp052 INTO lc_azp052 FROM azp_file WHERE azp01 = g_plant #MOD-C40107
          IF NOT SQLCA.SQLCODE THEN
            IF NOT cl_null(lc_azp052) THEN
               LET ls_tmp = ls_tmp.trimRight(),"(",lc_azp052 CLIPPED,")"
            END IF
          END IF
       END IF
       #MOD-C30123 start---
       LET ls_msg = ls_msg.trim(), ls_tmp.trimRight()

       LET ls_tmp = "  " || ls_ze032 CLIPPED || ":" || lc_zx02 CLIPPED #MOD-C30123
       LET ls_msg = ls_msg.trim(), ls_tmp.trimRight()                  #MOD-C30123
    END IF
 
    CALL ln_win.setAttribute("text", ls_msg CLIPPED)
    CALL ui.Interface.setText(ls_msg CLIPPED)           #FUN-D20028 ADD
    #END No.FUN-7B0010 
 
    LET lf_form = lw_win.getForm()
    LET ln_form = lf_form.getNode()
    CALL ln_form.setAttribute("name", "cl_query_curs")
    LET ln_vbox  = ln_form.createChild("VBox")
    LET ln_group = ln_vbox.createChild("Group")
 
    SELECT gae04 INTO l_gae04 FROM gae_file 
       WHERE gae01='p_sql_wizard' AND gae02 = 'zas06' AND gae03 = g_lang
 
    LET l_gae04 = "QBE",l_gae04 CLIPPED
    CALL ln_group.setAttribute("text", l_gae04 CLIPPED)
    LET ln_hbox  = ln_group.createChild("HBox")
 
    #動態建立欄位
    CALL cl_query_dbqry_buildField(p_cmd,ln_hbox)        
 
    #建立進階查詢選項
    CALL cl_query_advance_buildField(p_cmd,ln_vbox)       #FUN-770079
 
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 動態建立查詢(QBE)、過濾畫面欄位
# Date & Author..:
# Input Parameter: p_cmd,pn_hbox
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_dbqry_buildField(p_cmd,pn_hbox)
    DEFINE p_cmd            LIKE type_file.chr1
    DEFINE pn_hbox          om.DomNode
    DEFINE lw_w             ui.Window
    DEFINE ln_w             om.DomNode  
    DEFINE ln_grid          om.DomNode,
           ln_FormField     om.DomNode,
           ln_Field_Edit    om.DomNode,
           ln_label         om.DomNode
    DEFINE ls_grid_items    om.NodeList,
           ls_label_items   om.NodeList,
           ls_field_items   om.NodeList
    DEFINE l_i              LIKE type_file.num10   #No.FUN-680135 INTEGER
    DEFINE l_j              LIKE type_file.num10   #No.FUN-680135 INTEGER
    DEFINE l_posx           LIKE type_file.num10
    DEFINE l_posx2          LIKE type_file.num10
    DEFINE l_posy           LIKE type_file.num10
    DEFINE l_seq_cnt        LIKE type_file.num10
    DEFINE ls_colname       STRING
    DEFINE l_sql            STRING
    DEFINE l_zal04          LIKE zal_file.zal04
    DEFINE l_zat04          LIKE zat_file.zat04
    DEFINE l_zat06          LIKE zat_file.zat06
    DEFINE l_per_field_len  DYNAMIC ARRAY OF LIKE zat_file.zat12  #FUN-7C0020
 
    IF p_cmd = 'F' THEN
       LET l_seq_cnt = g_qry_feld_cnt
       FOR l_i = 1 TO l_seq_cnt
           LET l_zal04 = g_qry_feld_t[l_i] CLIPPED
           SELECT unique zat06,zat12 INTO g_qry_qbe[l_i],l_per_field_len[l_i]   #FUN-7C0020
             FROM zat_file,zal_file 
            WHERE zat01 = zal01        AND zat02 = zal02
              AND zat01 = g_query_prog AND zal04 = l_zal04
              AND zat10 = g_query_cust AND zat10 = zal07         #FUN-750084
       END FOR
    ELSE
       LET l_seq_cnt = g_field_seq.getLength()
    END IF
 
    FOR l_i = 1 TO GI_MAX_COLUMN_COUNT
        IF l_i MOD 15 = 1 THEN
           LET l_posx = 1
           LET l_posx2 = 0
           LET ln_grid = pn_hbox.createChild("Grid")
           CALL ln_grid.setAttribute("hidden", 1)
           IF l_i > l_seq_cnt THEN
               LET l_posx2 = l_posx + 10
           ELSE
               FOR l_j = l_i TO l_i+14
                   IF p_cmd = "F" THEN
                      LET l_posx = FGL_WIDTH(g_qry_feld[l_j] CLIPPED) + 2
                   ELSE
                      LET l_posx = FGL_WIDTH(g_field_seq[l_j].name CLIPPED) + 2
                   END IF
                   IF l_posx2 < l_posx THEN
                      LET l_posx2 = l_posx 
                   END IF
               END FOR
           END IF
        END IF
        LET l_posx = 1
        LET ls_colname = "field", l_i USING "&&&"
        LET ln_label = ln_grid.createChild("Label")
        IF p_cmd = "F" THEN
           CALL ln_label.setAttribute("text",g_qry_feld[l_i] CLIPPED)
           CALL ln_label.setAttribute("gridWidth", FGL_WIDTH(g_qry_feld[l_i] CLIPPED))
        ELSE
           CALL ln_label.setAttribute("text",g_field_seq[l_i].name CLIPPED)
           CALL ln_label.setAttribute("gridWidth", FGL_WIDTH(g_field_seq[l_i].name CLIPPED))
        END IF
        CALL ln_label.setAttribute("hidden", 1)
        CALL ln_label.setAttribute("posX", l_posx)
        LET l_posy = l_i MOD 15 - 1
        IF l_posy = -1 THEN LET l_posy = 14 END IF
        CALL ln_label.setAttribute("posY", l_posy)
       #CALL ln_label.setAttribute("sizePolicy", "dynamic")
        LET ln_formfield = ln_grid.createChild("FormField")
        CALL ln_formfield.setAttribute("colName",ls_colname)
        CALL ln_formfield.setAttribute("name",ls_colname)
        CALL ln_formfield.setAttribute("hidden", 1)
        CALL ln_formfield.setAttribute("tabIndex", l_i)
        IF (NOT cl_null(g_field_seq[l_i].qbe) AND p_cmd="V") OR
           (NOT cl_null(g_qry_qbe[l_i]) AND p_cmd="F") 
        THEN
             LET ln_field_edit = ln_formfield.createChild("ButtonEdit")
             CALL ln_field_edit.setAttribute("image", "zoom")
             CALL ln_field_edit.setAttribute("action", "controlp")
        ELSE
             IF (g_field_seq[l_i].type = "date" AND p_cmd="V") OR
                (g_qry_feld_type[l_i] = "date" AND p_cmd="F") 
             THEN
                 LET ln_field_edit = ln_formfield.createChild("DateEdit")
             ELSE
                 LET ln_field_edit = ln_formfield.createChild("Edit")
             END IF
        END IF
        IF p_cmd ="F" THEN
          #FUN-7C0020
          #CALL ln_field_edit.setAttribute("gridWidth", g_qry_length[l_i])
          #CALL ln_field_edit.setAttribute("width",g_qry_length[l_i])
           IF cl_null(l_per_field_len[l_i]) THEN
              LET l_per_field_len[l_i] = g_qry_length[l_i]
           END IF
           CALL ln_field_edit.setAttribute("gridWidth", l_per_field_len[l_i])
           CALL ln_field_edit.setAttribute("width",l_per_field_len[l_i])
          #END FUN-7C0020
        ELSE
           CALL ln_field_edit.setAttribute("gridWidth", g_field_seq[l_i].len)
           CALL ln_field_edit.setAttribute("width",g_field_seq[l_i].len)
        END IF
        CALL ln_field_edit.setAttribute("posX", l_posx2)
        CALL ln_field_edit.setAttribute("posY", l_posy)
    END FOR
 
    CALL ui.Interface.refresh()
 
    LET lw_w=ui.window.getcurrent()
    LET ln_w = lw_w.getNode()
    LET ls_grid_items =ln_w.selectByTagName("Grid")
    LET ls_label_items=ln_w.selectByTagName("Label")
    LET ls_field_items=ln_w.selectByTagName("FormField")
 
    FOR l_i = 1 TO l_seq_cnt
        IF l_i MOD 15 = 1 THEN
           LET l_j = l_i / 15
           LET ln_grid = ls_grid_items.item(l_j+2)
           CALL ln_grid.setAttribute("hidden", 0)
        END IF
        IF (NOT cl_null(g_field_seq[l_i].type) AND p_cmd="V") OR
           (NOT cl_null(g_qry_feld_type[l_i]) AND p_cmd="F") 
        THEN
           LET ln_label = ls_label_items.item(l_i)
           CALL ln_label.setAttribute("hidden", 0)
           
           LET ln_formfield = ls_field_items.item(l_i)
           CALL ln_formfield.setAttribute("hidden", 0)
        END IF
    END FOR
    CALL ui.Interface.refresh()
 
END FUNCTION
 
#FUN-770079
##################################################
# Private Func...: TRUE
# Descriptions...: 動態建立進階查詢選項
# Date & Author..:
# Input Parameter: p_cmd,pn_vbox
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_advance_buildField(p_cmd,pn_vbox)
    DEFINE p_cmd            LIKE type_file.chr1
    DEFINE pn_vbox          om.DomNode
    DEFINE ln_grid          om.DomNode,
           ln_formfield     om.DomNode,
           ln_checkbox      om.DomNode
    DEFINE l_str            STRING
 
    LET ln_grid = pn_vbox.createChild("Grid")
    LET ln_formfield = ln_grid.createChild("FormField")
    CALL ln_formfield.setAttribute("colName","more")
    CALL ln_formfield.setAttribute("name","formonly.more")
    CALL ln_formfield.setAttribute("tabIndex", GI_MAX_COLUMN_COUNT+1)
    CALL ln_formfield.setAttribute("notNull", 1)
    CALL ln_formfield.setAttribute("required", 1)
    LET ln_checkbox = ln_formfield.createChild("CheckBox")
    CALL ln_checkbox.setAttribute("valueChecked","Y")
    CALL ln_checkbox.setAttribute("valueUnchecked","N")
    LET l_str = cl_getmsg('lib-161',g_lang)
    CALL ln_checkbox.setAttribute("text",l_str.trim())
    CALL ln_checkbox.setAttribute("comment",l_str.trim())
 
    IF (p_cmd="V" AND g_zai06 <> 'Y') OR p_cmd = "F" THEN
       CALL ln_grid.setAttribute("hidden", 1)
    END IF
    CALL ui.Interface.refresh()
 
END FUNCTION
#END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 過濾條件功能
# Date & Author..:
# Input Parameter: none
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_filter()
DEFINE l_field       STRING
DEFINE l_cons        STRING
DEFINE l_i           LIKE type_file.num5
DEFINE l_wc          STRING
 
   LET g_next_tag = 'N'
   LET l_wc = cl_query_curs('F')
   IF INT_FLAG OR l_wc = " 1=1" THEN                              #使用者不玩了
      RETURN
   END IF
   IF cl_null(g_wc2) THEN
      LET g_wc2 = l_wc
   ELSE
      LET g_wc2 = g_wc2 ," AND ", l_wc
   END IF
 
   CALL cl_query_prt_sel('O')                    #FUN-770079
   IF g_len > 150 THEN
      LET g_len = 150
   END IF
   IF INT_FLAG THEN                              #使用者不玩了
      RETURN
   END IF
   CALL ui.Interface.refresh()
 
   IF g_query_rec_b < 1 THEN
      CALL cl_err('!','lib-216',1)
      LET INT_FLAG = 1
      RETURN
   END IF
 
   LET g_curr_page = 1                            #目前頁數
   IF g_zao04[6] = 'Y' THEN
      LET g_total_page = (ga_table_data.getLength()/g_rec_b)    #總頁數
      IF ga_table_data.getLength() MOD g_rec_b <> 0 THEN
         LET g_total_page = g_total_page + 1
      END IF
   ELSE
      LET g_rec_b = ga_table_data.getLength()
      LET g_total_page = 1
   END IF
END FUNCTION
 
#No.FUN-810021
##################################################
# Private Func...: TRUE
# Descriptions...: 資料權限設定
# Date & Author..:
# Input Parameter: none
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_auth(p_query_prog,p_query_cust,p_zz011,p_zai07)
DEFINE p_query_prog    LIKE zai_file.zai01                   #查詢單ID
DEFINE p_query_cust    LIKE zai_file.zai05                   #客製否
DEFINE p_zz011         LIKE zz_file.zz011                    
DEFINE p_zai07         LIKE zai_file.zai07                   
DEFINE l_auth_wc       STRING                  #權限條件
DEFINE l_prog          LIKE zai_file.zai01
DEFINE l_priv1         LIKE zy_file.zy03,      #使用者執行權限  FUN-560097
       l_priv2         LIKE zy_file.zy04,      #使用者資料權限
       l_priv3         LIKE zy_file.zy05,      #使用部門資料權限
       l_priv4         LIKE zy_file.zy06,      #使用者印表權限
       l_priv5         LIKE zy_file.zy07       #使用者單身權限
 
    LET l_prog = g_prog
    LET g_prog = p_zai07    
    IF NOT cl_null(p_zz011) THEN                              
       #判斷程式執行權限.
       IF (NOT cl_set_priv()) THEN
          LET g_prog = l_prog  
          RETURN 0,''
       END IF
    END IF
 
    #權限設定
    LET l_auth_wc = " 1=1"
    SELECT zau02,zau03 INTO g_zau02,g_zau03 FROM zau_file 
     WHERE zau01 = p_query_prog AND zau04 = p_query_cust     #FUN-750084 #FUN-810021
    IF NOT cl_null(g_zau02) OR NOT cl_null(g_zau03) THEN
       LET l_priv1 = g_priv1  
       LET l_priv2 = g_priv2
       LET l_priv3 = g_priv3
       LET l_priv4 = g_priv4
       LET l_priv5 = g_priv5
      #LET l_prog = g_prog                               
      #LET g_prog = g_query_prog                         
       LET g_priv1 = NULL
       LET g_priv2 = NULL
       LET g_priv3 = NULL
       LET g_priv4 = NULL
       LET g_priv5 = NULL
       IF (NOT cl_set_priv()) THEN
          LET g_priv1 = l_priv1  
          LET g_priv2 = l_priv2
          LET g_priv3 = l_priv3
          LET g_priv4 = l_priv4
          LET g_priv5 = l_priv5
          LET g_prog = l_prog  
          RETURN 0,''
       END IF
       #Begin:FUN-980030
       #IF NOT cl_null(g_zau02) THEN 
       #   IF g_priv2='4' THEN                           #只能使用自己的資料
       #       LET l_auth_wc = g_zau02 CLIPPED ," = '",g_user,"'"
       #   END IF
       #END IF
       #IF NOT cl_null(g_zau03) THEN 
       #   IF g_priv3='4' THEN                           #只能使用相同群的資料
       #       LET l_auth_wc = l_auth_wc clipped," AND ",
       #                       g_zau03 CLIPPED," MATCHES '",g_grup CLIPPED,"*'"
       #   END IF
       #   IF g_priv3 MATCHES "[5678]" THEN              #群組權限
       #       LET l_auth_wc = l_auth_wc clipped," AND ",
       #                       g_zau03 CLIPPED," IN ",cl_chk_tgrup_list()
       #   END IF
       #END IF
       #End:FUN-980030
       LET l_auth_wc = l_auth_wc clipped,cl_get_extra_cond(g_zau02, g_zau03) #FOR GP5.2
       display "auth_wc:",l_auth_wc CLIPPED
       LET g_priv1 = l_priv1  
       LET g_priv2 = l_priv2
       LET g_priv3 = l_priv3
       LET g_priv4 = l_priv4
       LET g_priv5 = l_priv5
      #LET g_prog = l_prog                           
    END IF
    LET g_prog = l_prog                              
 
    RETURN 1,l_auth_wc
 
END FUNCTION
#END No.FUN-810021
 
#FUN-770079
##################################################
# Private Func...: TRUE
# Descriptions...: 若欄位有設定轉換值，則將 SQL 字串欄位換成 DECODE & CASE  
# Date & Author..:
# Input Parameter: none
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_prt_replace()                    
DEFINE l_zay            RECORD
                        zay04    LIKE zay_file.zay04,
                        zay05    LIKE zay_file.zay05,
                        zay06    LIKE zay_file.zay06,
                        zay07    LIKE zay_file.zay07
                        END RECORD
DEFINE buf              base.StringBuffer
DEFINE l_zal02          LIKE zal_file.zal02
DEFINE l_zal04          LIKE zal_file.zal04
DEFINE l_cnt            LIKE type_file.num10
DEFINE l_i              LIKE type_file.num10
DEFINE l_start          LIKE type_file.num10
DEFINE l_end            LIKE type_file.num10
DEFINE l_zal04_o        STRING
DEFINE l_other          STRING
DEFINE l_sql            STRING
DEFINE l_decode_str     STRING
DEFINE l_str            STRING
DEFINE l_execmd         STRING                               #TQC-790050
DEFINE l_p              LIKE type_file.num10                 #TQC-790050
DEFINE l_field_lst      STRING                               #No.TQC-9C0014


     SELECT COUNT(*) INTO l_cnt FROM zay_file
      WHERE zay01 = g_query_prog AND zay03 = g_query_cust
     IF l_cnt = 0 THEN
        RETURN
     END IF

     #TQC-9C0014 -- start --
     #若欄位為 select * from 時，需要將改為資料庫欄位,否則無法取代
     LET l_str = g_execmd.toLowerCase()
     LET l_start = l_str.getIndexOf('select',1)
     LET l_start = l_start + 7
     LET l_end = l_str.getIndexOf('from',1)
     LET l_execmd = g_execmd.subString(l_start,l_end-1)
     IF l_execmd.trim() = '*' THEN
        FOR l_i = 1 TO g_qry_feld_t.getlength() 
            IF cl_null(l_field_lst) THEN
               LET l_field_lst = g_qry_feld_t[l_i]
            ELSE 
               LET l_field_lst = l_field_lst ,',' ,g_qry_feld_t[l_i]
            END IF
        END FOR
        LET g_execmd = g_execmd.subString(1,7),l_field_lst,' ',g_execmd.subString(l_end,g_execmd.getLength())
     END IF 
     #TQC-9C0014 -- end --
 
     #No.FUN-810062    
     #------------------------------------------------------------------------  
     #DECODE 語法範例:
     #  SELECT DECODE (value,<if this value>,<return this value>,
     #                 <if this value>,<return this value>,
     #                 ....
     #                 <otherwise this value>)
     #CASE 語法範例:
     #  SELECT CASE WHEN (<column_value>= <value>) THEN
     #         WHEN (<column_value> = <value>) THEN
     #         ELSE <value>
     #    FROM <table_name>;
     #------------------------------------------------------------------------  
     LET l_sql="SELECT unique zal02,zal04 ",
               "  FROM zal_file,zat_file",
               " WHERE zal01=zat01",
               "   AND zal02=zat02",
               "   AND zal01='",g_query_prog CLIPPED,"' ",
               "   AND zal07='",g_query_cust CLIPPED,"' ",        
               "   AND zat11='Y' ",                               
               " ORDER BY zal02" 
     DECLARE rep_item_cs CURSOR FROM l_sql
     FOREACH rep_item_cs INTO l_zal02,l_zal04

        LET l_decode_str = "CASE"
        LET l_other = ""
 
        #TQC-9C0014 -- start --
        LET l_str = g_execmd.toLowerCase()
        LET l_start = l_str.getIndexOf('select',1)
        LET l_start = l_start + 7
        LET l_end = l_str.getIndexOf('from',1)
        LET l_execmd = g_execmd.subString(l_start,l_end-1)
       
        LET l_p = l_str.getIndexOf(l_zal04 CLIPPED,1)

        IF l_p < l_start THEN
            CONTINUE FOREACH
        END IF
        LET l_p = l_p + FGL_WIDTH(l_zal04 CLIPPED) - 1
        FOR l_i = l_p TO  l_start STEP -1
            IF l_str.subString(l_i,l_i) = ',' THEN
               LET l_zal04_o = g_execmd.subString(l_i+1,l_p)
               EXIT FOR
            ELSE
               IF l_i = l_start THEN
                  LET l_zal04_o = g_execmd.subString(l_i,l_p)
               END IF
            END IF   
        END FOR
        #TQC-9C0014 -- end --
 
        LET l_sql="SELECT zay04,zay05,zay06,zay07 ",
                  "  FROM zay_file",
                  " WHERE zay01='",g_query_prog CLIPPED,"' ",
                  "   AND zay02='",l_zal02,"' ",   
                  "   AND zay03='",g_query_cust CLIPPED,"' ",    
                  " ORDER BY zay04" 
        DECLARE rep_cs CURSOR FROM l_sql
        FOREACH rep_cs INTO l_zay.*
           IF l_zay.zay06 = '2' THEN  
              SELECT ze03 INTO l_zay.zay07 FROM ze_file
                 WHERE ze01= l_zay.zay07 AND ze02 = g_lang  
           END IF
           IF l_zay.zay04 = '1' THEN
              LET l_decode_str = l_decode_str ,
                                 " WHEN (",l_zal04_o ,"='",l_zay.zay05 CLIPPED,"')",
                                 " THEN '",l_zay.zay07 CLIPPED,"'"
           ELSE
              #otherwise this value
              LET l_other = " ELSE '",l_zay.zay07 CLIPPED,"'"
           END IF
        END FOREACH
        IF NOT cl_null(l_other) THEN
           LET l_decode_str = l_decode_str ,l_other
        ELSE
           LET l_decode_str = l_decode_str , " ELSE ", l_zal04_o   #No.CHI-940001
        END IF
   
        LET l_decode_str = l_decode_str, " END"
 
     #END No.FUN-810062    
        #TQC-790050
        #LET buf = base.StringBuffer.create()
        #CALL buf.append(g_execmd)
        #CALL buf.replace(l_zal04_o,l_decode_str, 0)
        #LET g_execmd = buf.toString()
 
        #TQC-9C0014 -- start --
        #避免取代錯誤，如類似的欄位: odc04,odc041
        LET l_execmd = l_execmd.trim(),','          
        LET l_zal04_o = l_zal04_o,','
        LET l_decode_str = l_decode_str,','

        LET buf = base.StringBuffer.create()
        CALL buf.append(l_execmd)
        CALL buf.replace(l_zal04_o,l_decode_str, 0)
        LET l_execmd = buf.toString()

        LET l_execmd = l_execmd.subString(1,l_execmd.getLength()-1)
          
        LET g_execmd = g_execmd.subString(1,7),l_execmd,' ',g_execmd.subString(l_end,g_execmd.getLength())
        #TQC-9C0014 -- end --
        #END TQC-790050
     END FOREACH
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 組合 SQL 語法排序條件(Order By) 
# Date & Author..:
# Input Parameter: none
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_order()      
DEFINE l_next_tag      LIKE type_file.chr1
DEFINE l_str           STRING
DEFINE l_exe_str       STRING
DEFINE l_text          STRING
DEFINE l_order         STRING
DEFINE l_sql           STRING
DEFINE l_i             LIKE type_file.num5
DEFINE l_end           LIKE type_file.num10          
DEFINE l_tabname       STRING
DEFINE l_table_name    LIKE gac_file.gac05
 
   LET l_next_tag = 'N'
   LET l_str = g_execmd.toLowerCase()
   LET l_exe_str = g_execmd

   CASE g_db_type
       WHEN "ORA"
          LET l_sql= "SELECT UNIQUE TABLE_NAME FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = UPPER( ? ) AND OWNER='DS'"
       WHEN "IFX"
          LET l_sql = "SELECT tabname FROM ds:syscolumns col, systables tab WHERE col.colname = ? AND tab.tabid = col.tabid"
       WHEN "MSV"                                         #FUN-750084 #FUN-810062
          LET l_sql = "SELECT distinct a.name ",
                      "  FROM ",FGL_GETENV("MSSQLAREA") CLIPPED,"_",g_dbs CLIPPED,".sys.objects a,",
                      "       ",FGL_GETENV("MSSQLAREA") CLIPPED,"_",g_dbs CLIPPED,".sys.columns b",
                      " WHERE b.name = ? ",
                      "   AND a.object_id = b.object_id"
       WHEN "ASE"                                         #FUN-AA0017
          LET l_sql = "SELECT distinct a.name ",
                      "  FROM ",g_dbs CLIPPED,".dbo.sysobjects a,",
                      "       ",g_dbs CLIPPED,".dbo.syscolumns b",
                      " WHERE b.name = ? ",
                      "   AND a.id = b.id"
   END CASE
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
   DECLARE table2_cur CURSOR FROM l_sql
 
   LET l_order = NULL
   FOR l_i = 1 TO g_zam.getLength() 
       LET l_text = ""
       FOREACH table2_cur USING g_zam[l_i].zal04 INTO l_table_name
          LET l_tabname = l_table_name CLIPPED
          LET l_tabname = l_tabname.toLowerCase()
          LET l_end = l_str.getIndexOf(l_tabname,1)
          IF l_end != 0 THEN
              LET l_text = l_tabname,"."
              EXIT FOREACH
          END IF
       END FOREACH
       IF cl_null(l_order) THEN 
          LET l_order = l_text,g_zam[l_i].zal04 CLIPPED
       ELSE
            LET l_order = l_order,",",l_text,g_zam[l_i].zal04 CLIPPED
       END IF
       IF g_zam[l_i].zam08 = '2' THEN
          LET l_order = l_order ," DESC"
       END IF
       IF g_zam[l_i].zam07 = 'Y' THEN
           LET l_next_tag = 'Y'
       END IF
   END FOR
   IF NOT cl_null(l_order) THEN
      LET l_end = l_str.getIndexOf('order by',1)
      IF l_end = 0 THEN
         LET l_exe_str = l_exe_str," order by ",l_order
      ELSE
         LET l_exe_str = l_exe_str.subString(1,l_end-1),"order by ",l_order ,
                     l_exe_str.subString(l_end+8,l_str.getLength())
      END IF
   END IF
   LET g_execmd = l_exe_str
 
   RETURN l_next_tag 
END FUNCTION              
 
##################################################
# Private Func...: TRUE
# Descriptions...: 進階查詢條件視窗功能
# Date & Author..:
# Input Parameter: none
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_advance()                      
 
    OPEN WINDOW query_advance_w WITH FORM "lib/42f/cl_query_advance" 
      ATTRIBUTE(STYLE=g_win_style CLIPPED)
 
    CALL cl_load_style_list(NULL)
    CALL cl_ui_locale("cl_query_advance")
 
    CALL cl_query_advance_show()
 
    LET g_action_choice = "dis_zal"
 
    CALL cl_query_advance_menu()
 
    #依照進階查詢選項設定，產生報表資料
    CALL cl_query_advance_finish()         
 
    CLOSE WINDOW query_advance_w
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 進階查詢條件功能 menu
# Date & Author..:
# Input Parameter: none
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_advance_menu()
 
    WHILE TRUE
      CASE g_action_choice
         WHEN "dis_zal"               #顯示/隱藏 page
              CALL cl_query_dis()
         WHEN "option"                #條件選擇 page
              CALL cl_query_option()
         WHEN "sum1"                  #計算1 page
              CALL cl_query_sum1()
         WHEN "sum2"                  #計算2 page
              CALL cl_query_sum2()
         WHEN "sum3"                  #計算3 page
              CALL cl_query_sum3()
         WHEN "exit"
              EXIT WHILE
      END CASE
    END WHILE
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 進階查詢條件的預設值
# Date & Author..:
# Input Parameter: none
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_advance_show()
DEFINE l_values       STRING
DEFINE l_id_items     STRING
DEFINE l_name_items   STRING
DEFINE l_i            LIKE type_file.num5
DEFINE l_j            LIKE type_file.num5
DEFINE l_n            LIKE type_file.num5
DEFINE l_k            LIKE type_file.num5
 
  INITIALIZE g_more.*   TO NULL
  CALL g_dis_zal.clear()
  CALL g_zan1.clear()
  CALL g_zan2.clear()
  CALL g_zan3.clear()
  LET g_zan1_rec_b = 0 
  LET g_zan2_rec_b = 0 
  LET g_zan3_rec_b = 0 
 
  #隱藏欄位資料
  FOR l_i = 1 TO g_qry_feld_cnt 
      LET g_dis_zal[l_i].check = g_qry_show[l_i]
      LET g_dis_zal[l_i].zal04 = g_qry_feld_t[l_i]
      LET g_dis_zal[l_i].zal05 = g_qry_feld[l_i]
      IF l_i = 1 THEN
         LET l_values = l_i USING '<<<<<'
         LET l_name_items = g_qry_feld[l_i] CLIPPED
      ELSE
         LET l_values = l_values ,",",l_i USING '<<<<<'
         LET l_name_items = l_name_items,",",g_qry_feld[l_i] CLIPPED
      END IF
  END FOR
 
  LET l_id_items = ""
  FOR l_i = 1 TO g_qry_feld_cnt
      #TQC-790050
      IF (NOT (g_qry_feld_type[l_i] = "varchar2" OR 
              g_qry_feld_type[l_i] = "char" OR g_qry_feld_type[l_i] = "date"))
         OR cl_null(g_qry_feld_type[l_i])
      #END TQC-790050
      THEN 
         IF cl_null(l_id_items) THEN
            LET l_id_items = g_qry_feld_t[l_i] CLIPPED
         ELSE
            LET l_id_items = l_id_items,",",g_qry_feld_t[l_i] CLIPPED
         END IF
      END IF
  END FOR
 
  #建立Combobox排序資料
  CALL cl_set_combo_items("s1",l_values,l_name_items)
  CALL cl_set_combo_items("s2",l_values,l_name_items)
  CALL cl_set_combo_items("s3",l_values,l_name_items)
  CALL cl_set_combo_items("nzal04_1",l_id_items,l_id_items)
  CALL cl_set_combo_items("nzal04_2",l_id_items,l_id_items)
  CALL cl_set_combo_items("nzal04_3",l_id_items,l_id_items)
 
  
  LET g_more.u1 = "N"
  LET g_more.t1 = "N"
  LET g_more.u2 = "N"
  LET g_more.t2 = "N"
  LET g_more.u3 = "N"
  LET g_more.t3 = "N"
 
  #排序/跳頁/計算否資料
  FOR l_i = 1 TO g_zam.getLength()
      CASE l_i
         WHEN 1
             FOR l_j = 1 TO g_qry_feld_cnt 
                 IF g_zam[l_i].zal04 = g_qry_feld_t[l_j] THEN
                    LET g_more.s1 = l_j
                    LET g_more.t1 = g_zam[l_i].zam07
                    EXIT FOR
                 END IF
             END FOR
             FOR l_j = 1 TO g_zan.getLength()
                 IF g_zam[l_i].zal04 = g_zan[l_j].gzal04 THEN
                    LET g_more.u1 = "Y"
                    EXIT FOR
                 END IF
             END FOR
         WHEN 2
             FOR l_j = 1 TO g_qry_feld_cnt 
                 IF g_zam[l_i].zal04 = g_qry_feld_t[l_j] THEN
                    LET g_more.s2 = l_j
                    LET g_more.t2 = g_zam[l_i].zam07
                    EXIT FOR
                 END IF
             END FOR
             FOR l_j = 1 TO g_zan.getLength()
                 IF g_zam[l_i].zal04 = g_zan[l_j].gzal04 THEN
                    LET g_more.u2 = "Y"
                    EXIT FOR
                 END IF
             END FOR
         WHEN 3
             FOR l_j = 1 TO g_qry_feld_cnt 
                 IF g_zam[l_i].zal04 = g_qry_feld_t[l_j] THEN
                    LET g_more.s3 = l_j
                    LET g_more.t3 = g_zam[l_i].zam07
                    EXIT FOR
                 END IF
             END FOR
             FOR l_j = 1 TO g_zan.getLength()
                 IF g_zam[l_i].zal04 = g_zan[l_j].gzal04 THEN
                    LET g_more.u3 = "Y"
                    EXIT FOR
                 END IF
             END FOR
         OTHERWISE
            EXIT FOR
      END CASE
  END FOR
 
  #計算式資料
  CALL cl_set_comp_visible("page3,page4,page5", FALSE)           
 
  IF g_more.u1 = "Y" THEN
     LET l_j = g_more.s1
     FOR l_i = 1 TO g_zan.getLength()
        IF g_zan[l_i].gzal04 = g_qry_feld_t[l_j] THEN
           LET l_n = g_zan1.getLength() + 1
           LET g_zan1[l_n].nzal04_1 = g_zan[l_i].zal04
           LET g_zan1[l_n].zan03_1 = g_zan[l_i].zan03 
           LET g_zan1[l_n].zan07_1 = g_zan[l_i].zan07 
           FOR l_k = 1 TO g_qry_feld_cnt 
               IF g_zan1[l_n].nzal04_1 = g_qry_feld_t[l_k] THEN
                  LET g_zan1[l_n].nzal05_1 = g_qry_feld[l_k]
                  EXIT FOR
               END IF
           END FOR
        END IF
     END FOR 
     CALL cl_set_comp_visible("page3", TRUE)           
  END IF               
 
  IF g_more.u2 = "Y" THEN
     LET l_j = g_more.s2
     FOR l_i = 1 TO g_zan.getLength()
        IF g_zan[l_i].gzal04 = g_qry_feld_t[l_j] THEN
           LET l_n = g_zan2.getLength() + 1
           LET g_zan2[l_n].nzal04_2 = g_zan[l_i].zal04
           LET g_zan2[l_n].zan03_2 = g_zan[l_i].zan03 
           LET g_zan2[l_n].zan07_2 = g_zan[l_i].zan07 
           FOR l_k = 1 TO g_qry_feld_cnt 
               IF g_zan2[l_n].nzal04_2 = g_qry_feld_t[l_k] THEN
                  LET g_zan2[l_n].nzal05_2 = g_qry_feld[l_k]
                  EXIT FOR
               END IF
           END FOR
        END IF
     END FOR
     CALL cl_set_comp_visible("page4", TRUE)           
  END IF
 
  IF g_more.u3 = "Y" THEN
     LET l_j = g_more.s3
     FOR l_i = 1 TO g_zan.getLength()
        IF g_zan[l_i].gzal04 = g_qry_feld_t[l_j] THEN
           LET l_n = g_zan3.getLength() + 1
           LET g_zan3[l_n].nzal04_3 = g_zan[l_i].zal04
           LET g_zan3[l_n].zan03_3 = g_zan[l_i].zan03 
           LET g_zan3[l_n].zan07_3 = g_zan[l_i].zan07 
           FOR l_k = 1 TO g_qry_feld_cnt 
               IF g_zan3[l_n].nzal04_3 = g_qry_feld_t[l_k] THEN
                  LET g_zan3[l_n].nzal05_3 = g_qry_feld[l_k]
                  EXIT FOR
               END IF
           END FOR
        END IF
     END FOR
     CALL cl_set_comp_visible("page5", TRUE)           
  END IF
 
  DISPLAY BY NAME g_more.s1,g_more.s2,g_more.s3,
                  g_more.t1,g_more.t2,g_more.t3,
                  g_more.u1,g_more.u2,g_more.u3
 
  DISPLAY ARRAY g_dis_zal TO s_dis_zal.* ATTRIBUTE(COUNT=g_qry_feld_cnt,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
  END DISPLAY
   
  LET g_zan1_rec_b = g_zan1.getLength()
  DISPLAY ARRAY g_zan1 TO s_zan1.* ATTRIBUTE(COUNT=g_zan1_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
  END DISPLAY
 
  LET g_zan2_rec_b = g_zan2.getLength()
  DISPLAY ARRAY g_zan2 TO s_zan2.* ATTRIBUTE(COUNT=g_zan2_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
  END DISPLAY
 
  LET g_zan3_rec_b = g_zan3.getLength()
  DISPLAY ARRAY g_zan3 TO s_zan3.* ATTRIBUTE(COUNT=g_zan3_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
  END DISPLAY
 
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 進階畫面之欄位顯示否設定 page
# Date & Author..:
# Input Parameter: none
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_dis()
DEFINE  l_allow_insert  LIKE type_file.num5    
DEFINE  l_allow_delete  LIKE type_file.num5    
DEFINE  l_w_ac          LIKE type_file.num5
DEFINE  l_dis_zal_t     RECORD         #設定顯示/隱藏資料(備份)     
                          check   LIKE type_file.chr1,    
                          zal04   LIKE zal_file.zal04,       
                          zal05   LIKE zal_file.zal04       
                        END RECORD
 
    LET l_allow_insert = FALSE   #cl_detail_input_auth("insert")
    LET l_allow_delete = FALSE   #cl_detail_input_auth("delete")
 
    LET l_w_ac = 1
    INPUT ARRAY g_dis_zal WITHOUT DEFAULTS FROM s_dis_zal.*
              ATTRIBUTE(COUNT= g_qry_feld_cnt,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE ROW
         LET l_w_ac = ARR_CURR() 
         LET l_dis_zal_t.* = g_dis_zal[l_w_ac].*  
 
      AFTER ROW
         LET l_w_ac = ARR_CURR()
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_dis_zal[l_w_ac].* = l_dis_zal_t.*
            LET g_action_choice="exit"
            EXIT INPUT
         END IF
 
      ON ACTION option 
         LET g_action_choice = "option"
         ACCEPT INPUT
 
      ON ACTION sum1
         LET g_action_choice = "sum1"
         ACCEPT INPUT
        
      ON ACTION sum2
         LET g_action_choice = "sum2"
         ACCEPT INPUT
        
      ON ACTION sum3
         LET g_action_choice = "sum3"
         ACCEPT INPUT
        
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON ACTION accept                        
         LET g_action_choice="exit"
         ACCEPT INPUT
 
      ON ACTION exit                             # Esc.結束
         LET g_action_choice="exit"
         EXIT INPUT
 
      ON ACTION cancel
         LET INT_FLAG=FALSE         #MOD-570244    mars
         LET g_action_choice="exit"
         EXIT INPUT
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
      #No.TQC-860016 --start--
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
      #No.TQC-860016 ---end---
   END INPUT
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 進階畫面之條件選擇 page
# Date & Author..:
# Input Parameter: none
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_option()
DEFINE   l_sql           STRING
DEFINE   l_n             LIKE type_file.num5
 
   INPUT BY NAME g_more.s1,g_more.s2,g_more.s3,g_more.t1,g_more.t2,g_more.t3,
         g_more.u1,g_more.u2,g_more.u3  WITHOUT DEFAULTS 
 
     ON CHANGE s1
        IF g_more.s1 IS NOT NULL THEN
           IF (g_more.s1 = g_more.s2) OR (g_more.s1 = g_more.s3) THEN
              CALL cl_err(g_more.s1,-239,0)
              NEXT FIELD s1
           END IF
        END IF
 
     ON CHANGE s2
        IF g_more.s2 IS NOT NULL THEN
           IF (g_more.s2 = g_more.s1) OR (g_more.s2 = g_more.s3) THEN
              CALL cl_err(g_more.s2,-239,0)
              NEXT FIELD s2
           END IF
        END IF
 
     ON CHANGE s3
        IF g_more.s3 IS NOT NULL THEN
           IF (g_more.s3 = g_more.s1) OR (g_more.s3 = g_more.s2) THEN
              CALL cl_err(g_more.s3,-239,0)
              NEXT FIELD s3
           END IF
        END IF
 
     ON CHANGE u1
        IF g_more.u1 = 'Y' THEN
           CALL cl_set_comp_visible("page3", TRUE)           
        ELSE
           CALL cl_set_comp_visible("page3", FALSE) 
           CALL g_zan1.clear()
        END IF
 
     ON CHANGE u2
        IF g_more.u2 = 'Y' THEN
           CALL cl_set_comp_visible("page4", TRUE)           
        ELSE
           CALL cl_set_comp_visible("page4", FALSE) 
           CALL g_zan2.clear()
        END IF
 
     ON CHANGE u3
        IF g_more.u3 = 'Y' THEN
           CALL cl_set_comp_visible("page5", TRUE)           
        ELSE
           CALL cl_set_comp_visible("page5", FALSE) 
           CALL g_zan3.clear()
        END IF
 
     ON ACTION dis_zal
        LET g_action_choice = "dis_zal"
        ACCEPT INPUT
 
     ON ACTION sum1 
        LET g_action_choice = "sum1"
        ACCEPT INPUT
 
     ON ACTION sum2
        LET g_action_choice = "sum2"
        ACCEPT INPUT
       
     ON ACTION sum3
        LET g_action_choice = "sum3"
        ACCEPT INPUT
 
     ON ACTION accept                        
        LET g_action_choice="exit"
        ACCEPT INPUT
 
     ON ACTION exit                             # Esc.結束
        LET g_action_choice="exit"
        EXIT INPUT
 
     ON ACTION cancel
        LET INT_FLAG=FALSE             #MOD-570244     mars
        LET g_action_choice="exit"
        EXIT INPUT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      #No.TQC-860016 --start--
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
      #No.TQC-860016 ---end---
   END INPUT 
 
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 進階畫面之計算式1設定 page
# Date & Author..:
# Input Parameter: none
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_sum1()
DEFINE  p_cmd           LIKE type_file.chr1   
DEFINE  l_allow_insert  LIKE type_file.num5    
DEFINE  l_allow_delete  LIKE type_file.num5    
DEFINE  l_w_ac          LIKE type_file.num5
DEFINE  l_zan1_t        RECORD                            #計算1(SUM)     
                        nzal04_1   LIKE zal_file.zal04,    
                        nzal05_1   LIKE zal_file.zal05,       
                        zan03_1    LIKE zan_file.zan03,       
                        zan07_1    LIKE zan_file.zan07       
                        END RECORD
DEFINE  l_i             LIKE type_file.num10
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    LET l_w_ac = 1
    INPUT ARRAY g_zan1 WITHOUT DEFAULTS FROM s_zan1.*
              ATTRIBUTE(COUNT= g_zan1_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE ROW
         LET l_w_ac = ARR_CURR() 
         LET l_zan1_t.* = g_zan1[l_w_ac].*  
         LET p_cmd=''
         IF g_zan1_rec_b >= l_w_ac THEN
            LET p_cmd='u'
         END IF
 
      BEFORE INSERT 
         LET p_cmd='a'
         LET g_zan1[l_w_ac].zan03_1 = "A"
         LET g_zan1[l_w_ac].zan07_1 = "1"
 
      AFTER FIELD nzal04_1
         IF g_zan1[l_w_ac].nzal04_1 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_zan1[l_w_ac].nzal04_1 != l_zan1_t.nzal04_1) 
            THEN
               FOR l_i = 1 TO g_zan1_rec_b
                   IF (g_zan1[l_w_ac].nzal04_1 = g_zan1[l_i].nzal04_1) AND
                      (l_i <> l_w_ac)  
                   THEN
                       CALL cl_err(g_zan1[l_w_ac].nzal04_1,-239,0)
                       NEXT FIELD nzal04_1
                   END IF
               END FOR
            END IF
         END IF 
 
      ON CHANGE nzal04_1
         IF g_zan1[l_w_ac].nzal04_1 IS NOT NULL THEN
            SELECT unique(zal05) INTO g_zan1[l_w_ac].nzal05_1
              FROM zal_file 
             WHERE zal04 = g_zan1[l_w_ac].nzal04_1 
               AND zal03 = g_lang 
               AND zal01 = g_query_prog  
               AND zal07 = g_query_cust                          
            DISPLAY BY NAME g_zan1[l_w_ac].nzal05_1
         END IF
 
      AFTER ROW
         LET l_w_ac = ARR_CURR()
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_zan1[l_w_ac].* = l_zan1_t.*
            LET g_action_choice="exit"
            EXIT INPUT
         END IF
 
      AFTER INSERT
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           LET g_action_choice="exit"
           CANCEL INSERT
           EXIT INPUT
        END IF
        LET g_zan1_rec_b = g_zan1_rec_b +1
 
      BEFORE DELETE
        IF NOT cl_delb(0,0) THEN
           CANCEL DELETE
        END IF
        LET g_zan1_rec_b = g_zan1_rec_b - 1
 
      ON ACTION dis_zal
         LET g_action_choice = "dis_zal"
         ACCEPT INPUT
 
      ON ACTION option 
         LET g_action_choice = "option"
         ACCEPT INPUT
 
      ON ACTION sum2
         LET g_action_choice = "sum2"
         ACCEPT INPUT
        
      ON ACTION sum3
         LET g_action_choice = "sum3"
         ACCEPT INPUT
        
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON ACTION accept                        
         LET g_action_choice="exit"
         ACCEPT INPUT
 
      ON ACTION exit                             # Esc.結束
         LET g_action_choice="exit"
         EXIT INPUT
 
      ON ACTION cancel
         LET INT_FLAG=FALSE         #MOD-570244    mars
         LET g_action_choice="exit"
         EXIT INPUT
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
      #No.TQC-860016 --start--
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
      #No.TQC-860016 ---end---
   END INPUT
 
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 進階畫面之計算式2設定 page
# Date & Author..:
# Input Parameter: none
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_sum2()
DEFINE  p_cmd           LIKE type_file.chr1   
DEFINE  l_allow_insert  LIKE type_file.num5    
DEFINE  l_allow_delete  LIKE type_file.num5    
DEFINE  l_w_ac          LIKE type_file.num5
DEFINE  l_zan2_t        RECORD                                 #計算2(SUM)     
                        nzal04_2   LIKE zal_file.zal04,    
                        nzal05_2   LIKE zal_file.zal05,       
                        zan03_2    LIKE zan_file.zan03,       
                        zan07_2    LIKE zan_file.zan07       
                        END RECORD
DEFINE  l_i             LIKE type_file.num10
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    LET l_w_ac = 1
    INPUT ARRAY g_zan2 WITHOUT DEFAULTS FROM s_zan2.*
              ATTRIBUTE(COUNT=g_zan2_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE ROW
         LET l_w_ac = ARR_CURR() 
         LET l_zan2_t.* = g_zan2[l_w_ac].*  
         LET p_cmd=''
         IF g_zan2_rec_b >= l_w_ac THEN
            LET p_cmd='u'
         END IF
 
      BEFORE INSERT 
         LET p_cmd='a'
         LET g_zan2[l_w_ac].zan03_2 = "A"
         LET g_zan2[l_w_ac].zan07_2 = "1"
 
      AFTER FIELD nzal04_2
         IF g_zan2[l_w_ac].nzal04_2 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
             (p_cmd = "u" AND g_zan2[l_w_ac].nzal04_2 != l_zan2_t.nzal04_2) THEN
               FOR l_i = 1 TO g_zan2_rec_b
                   IF (g_zan2[l_w_ac].nzal04_2 = g_zan2[l_i].nzal04_2) AND
                      (l_i <> l_w_ac)  
                   THEN
                       CALL cl_err(g_zan2[l_w_ac].nzal04_2,-239,0)
                       NEXT FIELD nzal04_2
                   END IF
               END FOR
            END IF
         END IF 
 
      ON CHANGE nzal04_2
         IF g_zan2[l_w_ac].nzal04_2 IS NOT NULL THEN
            SELECT unique(zal05) INTO g_zan2[l_w_ac].nzal05_2
              FROM zal_file 
             WHERE zal04 = g_zan2[l_w_ac].nzal04_2 
               AND zal03 = g_lang 
               AND zal01 = g_query_prog  
               AND zal07 = g_query_cust                          
            DISPLAY BY NAME g_zan2[l_w_ac].nzal05_2
         END IF
 
      AFTER ROW
         LET l_w_ac = ARR_CURR()
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_zan2[l_w_ac].* = l_zan2_t.*
            LET g_action_choice="exit"
            EXIT INPUT
         END IF
 
      AFTER INSERT
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           LET g_action_choice="exit"
           CANCEL INSERT
           EXIT INPUT
        END IF
        LET g_zan2_rec_b = g_zan2_rec_b +1
 
      BEFORE DELETE
        IF NOT cl_delb(0,0) THEN
           CANCEL DELETE
        END IF
        LET g_zan2_rec_b = g_zan2_rec_b - 1
 
      ON ACTION dis_zal
         LET g_action_choice = "dis_zal"
         ACCEPT INPUT
 
      ON ACTION option 
         LET g_action_choice = "option"
         ACCEPT INPUT
 
      ON ACTION sum1
         LET g_action_choice = "sum1"
         ACCEPT INPUT
        
      ON ACTION sum3
         LET g_action_choice = "sum3"
         ACCEPT INPUT
        
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON ACTION accept                        
         LET g_action_choice="exit"
         ACCEPT INPUT
 
      ON ACTION exit                             # Esc.結束
         LET g_action_choice="exit"
         EXIT INPUT
 
      ON ACTION cancel
         LET INT_FLAG=FALSE         #MOD-570244    mars
         LET g_action_choice="exit"
         EXIT INPUT
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
      #No.TQC-860016 --start--
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
      #No.TQC-860016 ---end---
   END INPUT
 
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 進階畫面之計算式3設定 page
# Date & Author..:
# Input Parameter: none
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_sum3()
DEFINE  p_cmd           LIKE type_file.chr1   
DEFINE  l_allow_insert  LIKE type_file.num5    
DEFINE  l_allow_delete  LIKE type_file.num5    
DEFINE  l_w_ac          LIKE type_file.num5
DEFINE  l_zan3_t        RECORD                           #計算3(SUM)     
                        nzal04_3   LIKE zal_file.zal04,    
                        nzal05_3   LIKE zal_file.zal05,       
                        zan03_3    LIKE zan_file.zan03,       
                        zan07_3    LIKE zan_file.zan07       
                        END RECORD
DEFINE  l_i             LIKE type_file.num10
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    LET l_w_ac = 1
    INPUT ARRAY g_zan3 WITHOUT DEFAULTS FROM s_zan3.*
              ATTRIBUTE(COUNT=g_zan3_rec_b ,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE ROW
         LET l_w_ac = ARR_CURR() 
         LET l_zan3_t.* = g_zan3[l_w_ac].*  
         LET p_cmd=''
         IF g_zan3_rec_b >= l_w_ac THEN
            LET p_cmd='u'
         END IF
 
      BEFORE INSERT 
         LET p_cmd='a'
         LET g_zan3[l_w_ac].zan03_3 = "A"
         LET g_zan3[l_w_ac].zan07_3 = "1"
 
      AFTER FIELD nzal04_3
         IF g_zan3[l_w_ac].nzal04_3 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
             (p_cmd = "u" AND g_zan3[l_w_ac].nzal04_3 != l_zan3_t.nzal04_3) THEN
               FOR l_i = 1 TO g_zan3_rec_b
                   IF (g_zan3[l_w_ac].nzal04_3 = g_zan3[l_i].nzal04_3) AND
                      (l_i <> l_w_ac)  
                   THEN
                       CALL cl_err(g_zan3[l_w_ac].nzal04_3,-239,0)
                       NEXT FIELD nzal04_3
                   END IF
               END FOR
            END IF
         END IF 
      
      ON CHANGE nzal04_3
         IF g_zan3[l_w_ac].nzal04_3 IS NOT NULL THEN
            SELECT unique(zal05) INTO g_zan3[l_w_ac].nzal05_3
              FROM zal_file 
             WHERE zal04 = g_zan3[l_w_ac].nzal04_3 
               AND zal03 = g_lang 
               AND zal01 = g_query_prog  
               AND zal07 = g_query_cust                          
            DISPLAY BY NAME g_zan3[l_w_ac].nzal05_3
         END IF
 
      AFTER ROW
         LET l_w_ac = ARR_CURR()
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_zan3[l_w_ac].* = l_zan3_t.*
            LET g_action_choice="exit"
            EXIT INPUT
         END IF
 
      AFTER INSERT
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           LET g_action_choice="exit"
           CANCEL INSERT
           EXIT INPUT
        END IF
        LET g_zan3_rec_b = g_zan3_rec_b +1
 
      BEFORE DELETE
        IF NOT cl_delb(0,0) THEN
           CANCEL DELETE
        END IF
        LET g_zan3_rec_b = g_zan3_rec_b - 1
 
 
      ON ACTION dis_zal
         LET g_action_choice = "dis_zal"
         ACCEPT INPUT
 
      ON ACTION option 
         LET g_action_choice = "option"
         ACCEPT INPUT
 
      ON ACTION sum1
         LET g_action_choice = "sum1"
         ACCEPT INPUT
        
      ON ACTION sum2
         LET g_action_choice = "sum2"
         ACCEPT INPUT
        
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON ACTION accept                        
         LET g_action_choice="exit"
         ACCEPT INPUT
 
      ON ACTION exit                             # Esc.結束
         LET g_action_choice="exit"
         EXIT INPUT
 
      ON ACTION cancel
         LET INT_FLAG=FALSE         #MOD-570244    mars
         LET g_action_choice="exit"
         EXIT INPUT
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
      #No.TQC-860016 --start--
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
      #No.TQC-860016 ---end---
   END INPUT
 
END FUNCTION 
 
##################################################
# Private Func...: TRUE
# Descriptions...: 依照進階查詢選項設定，產生報表資料
# Date & Author..:
# Input Parameter: none
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_query_advance_finish()
DEFINE l_i            LIKE type_file.num5
DEFINE l_j            LIKE type_file.num5
DEFINE l_k            LIKE type_file.num5
DEFINE l_cnt          LIKE type_file.num5
 
    #顯示/隱藏設定
     CALL g_qry_show.clear()
     FOR l_i = 1 TO g_qry_feld_cnt 
            LET g_qry_show[l_i] = g_dis_zal[l_i].check
     END FOR
 
    #排列順序,跳頁
     CALL g_zam.clear()
     CALL g_zan.clear()
 
     IF NOT cl_null(g_more.s1) THEN
        LET l_i = g_more.s1
        LET l_cnt = g_zam.getLength() + 1
        LET g_zam[l_cnt].zal04 = g_qry_feld_t[l_i]
        LET g_zam[l_cnt].zam07 = g_more.t1
        LET g_zam[l_cnt].zam08 = "1"
        IF g_more.u1 = "Y" THEN
           FOR l_j = 1 TO g_zan1_rec_b
               LET l_cnt = g_zan.getLength() + 1
               LET g_zan[l_cnt].zal04 = g_zan1[l_j].nzal04_1
               LET g_zan[l_cnt].zan03 = g_zan1[l_j].zan03_1
               LET g_zan[l_cnt].zan04 = "Y"
               LET g_zan[l_cnt].zan07 = g_zan1[l_j].zan07_1
               LET g_zan[l_cnt].gzal04 = g_qry_feld_t[l_i]
           END FOR
        END IF
     END IF
     IF NOT cl_null(g_more.s2) THEN
        LET l_i = g_more.s2
        LET l_cnt = g_zam.getLength() + 1
        LET g_zam[l_cnt].zal04 = g_qry_feld_t[l_i]
        LET g_zam[l_cnt].zam07 = g_more.t2
        LET g_zam[l_cnt].zam08 = "1"
        IF g_more.u2 = "Y" THEN
           FOR l_j = 1 TO g_zan2_rec_b
               LET l_cnt = g_zan.getLength() + 1
               LET g_zan[l_cnt].zal04 = g_zan2[l_j].nzal04_2
               LET g_zan[l_cnt].zan03 = g_zan2[l_j].zan03_2
               LET g_zan[l_cnt].zan04 = "Y"
               LET g_zan[l_cnt].zan07 = g_zan2[l_j].zan07_2
               LET g_zan[l_cnt].gzal04 = g_qry_feld_t[l_i]
           END FOR
        END IF
     END IF
     IF NOT cl_null(g_more.s3) THEN
        LET l_i = g_more.s3
        LET l_cnt = g_zam.getLength() + 1
        LET g_zam[l_cnt].zal04 = g_qry_feld_t[l_i]
        LET g_zam[l_cnt].zam07 = g_more.t3
        LET g_zam[l_cnt].zam08 = "1"
        IF g_more.u3 = "Y" THEN
           FOR l_j = 1 TO g_zan3_rec_b
               LET l_cnt = g_zan.getLength() + 1
               LET g_zan[l_cnt].zal04 = g_zan3[l_j].nzal04_3
               LET g_zan[l_cnt].zan03 = g_zan3[l_j].zan03_3
               LET g_zan[l_cnt].zan04 = "Y"
               LET g_zan[l_cnt].zan07 = g_zan3[l_j].zan07_3
               LET g_zan[l_cnt].gzal04 = g_qry_feld_t[l_i]
           END FOR
        END IF
     END IF
 
     #計算式資料
     CALL g_feld_sum.clear()
     FOR l_i = 1 TO g_zan.getLength()
        FOR l_k = 1 TO g_qry_feld_t.getLength()
            IF g_zan[l_i].gzal04 = g_qry_feld_t[l_k] THEN
               FOR l_j = 1 TO g_qry_feld_t.getLength()
                   IF g_zan[l_i].zal04 = g_qry_feld_t[l_j] THEN
                       #g_feld_sum[field欄位位置,group欄位位置)
                       LET g_feld_sum[l_j,l_k] = g_zan[l_i].zan03
                   END IF
               END FOR
            END IF
        END FOR
     END FOR
     LET g_zan_cnt =  g_zan.getLength()        #No.FUN-820043
END FUNCTION
#END FUN-770079
#No.TQC-810080
 
#No.FUN-860089 -- start --
FUNCTION cl_query_prt_type(p_flag,p_type,p_colname,p_data_type,p_collen,p_scale,p_tab_t)
DEFINE p_flag       LIKE type_file.chr1       
DEFINE p_type       LIKE type_file.chr1
DEFINE p_colname    LIKE zal_file.zal04,    
       p_collen     LIKE type_file.num5,    
       p_data_type  LIKE type_file.chr30
DEFINE p_scale      LIKE type_file.num10
DEFINE p_tab_t      LIKE zal_file.zal04   
DEFINE l_cnt        LIKE type_file.num5 
DEFINE l_colnamec   LIKE gaq_file.gaq03
DEFINE l_zal08      LIKE zal_file.zal08 
DEFINE l_zal09      LIKE zal_file.zal09 
DEFINE l_gcz10      LIKE gcz_file.gcz10
DEFINE l_gcz11      LIKE gcz_file.gcz11
DEFINE l_tab        STRING
     
    IF p_flag = 's' THEN        
       IF p_type = "1" OR p_type="2" THEN
          #若 xxx_file.xxx01 找不到資料時，則以 xxx01 搜尋
          SELECT COUNT(*) INTO l_cnt FROM zal_file
            WHERE zal01 = g_query_prog AND zal04 = p_tab_t  
              AND zal07 = g_query_cust AND zal03 = g_lang   
          IF l_cnt = 0 THEN
             LET l_tab = p_tab_t CLIPPED
             LET p_tab_t = l_tab.subString(l_tab.getIndexOf(".",1)+1,l_tab.getLength())  #FUN-920079
          END IF
          LET p_colname = p_tab_t                           
       END IF
    END IF
 
    CASE p_type
       WHEN "1"
          SELECT COUNT(*) INTO l_cnt FROM zal_file
            WHERE zal01 = g_query_prog AND zal04 = p_colname
              AND zal07 = g_query_cust AND zal03 = g_lang   
          IF l_cnt = 0 THEN
             LET g_zal_err = TRUE     #SQL 與 p_crview_set 設定不一致
 
             SELECT gaq03 INTO l_colnamec FROM gaq_file
              WHERE gaq01= p_colname AND gaq02=g_lang
             IF cl_null(l_colnamec) THEN
                LET l_colnamec =p_colname
             END IF
          ELSE
             SELECT unique zal05,zal08,zal09 INTO l_colnamec,l_zal08,l_zal09 #FUN-7C0020
               FROM zal_file
               WHERE zal01 = g_query_prog AND zal04 = p_colname  
                 AND zal07 = g_query_cust AND zal03 = g_lang   #FUN-750084
             #END FUN-820043
             IF NOT cl_null(l_zal08) THEN
                LET p_collen = l_zal08 
             END IF  
             #FUN-7C0020
             IF l_zal09 MATCHES "[JKLMNOPQRST]" AND p_data_type <> 'date' THEN  #TQC-810053
                LET p_data_type = 'char'
                LET p_scale = -1
             END IF   
          END IF   
 
       WHEN "2"
          SELECT COUNT(*) INTO l_cnt FROM gcz_file
            WHERE gcz01 = g_query_prog AND gcz02 = g_query_cust 
              AND gcz03 = g_query_clas AND gcz04 = g_query_user
              AND gcz06 = g_lang       AND gcz07 = p_colname
          IF l_cnt = 0 THEN
             LET g_zal_err = TRUE     #SQL 與 p_crview_set 設定不一致
 
             SELECT gaq03 INTO l_colnamec FROM gaq_file
              WHERE gaq01= p_colname AND gaq02=g_lang
             IF cl_null(l_colnamec) THEN
                LET l_colnamec = p_colname
             END IF
          ELSE
             #FUN-820043
             SELECT unique gcz08,gcz10,gcz11 INTO l_colnamec,l_gcz10,l_gcz11 
               FROM gcz_file
               WHERE gcz01 = g_query_prog AND gcz02 = g_query_cust 
                 AND gcz03 = g_query_clas AND gcz04 = g_query_user
                 AND gcz06 = g_lang       AND gcz07 = p_colname
             IF NOT cl_null(l_gcz10) THEN
                LET p_collen = l_gcz10
             END IF  
             IF l_gcz11 MATCHES "[JKLMNOPQRST]" AND p_data_type <> 'date' THEN 
                LET p_data_type = 'char'
                LET p_scale = -1
             END IF   
          END IF
 
       OTHERWISE
          SELECT gaq03 INTO l_colnamec FROM gaq_file
           WHERE gaq01= p_colname AND gaq02=g_lang
          IF cl_null(l_colnamec) THEN
             LET l_colnamec = p_colname
          END IF
    END CASE
    RETURN p_colname,p_data_type,p_collen,p_scale,l_colnamec
END FUNCTION
#No.FUN-860089 -- end --

#No:FUN-A60085 -- start --
FUNCTION cl_query_prt_temptable()

    DROP TABLE xabc

    CREATE TEMP TABLE xabc(
      xabc01  LIKE type_file.num5,    #SMALLINT,       序號
      xabc02  LIKE type_file.chr1000, #VARCHAR(1000),  欄位ID
      xabc03  LIKE type_file.chr1000, #VARCHAR(1000),  欄位名稱
      xabc04  LIKE type_file.num5,    #SMALLINT,       欄位長度
      xabc05  LIKE type_file.num10,   #INTEGER,        欄位小數點長度
      xabc06  LIKE type_file.chr20)   #VARCHAR(20))    欄位資料型態
END FUNCTION
#END FUN-A60085

#---FUN-A90024---start-----
##########################################################################
# Private Func...: FALSE
# Descriptions...: 利用DB提供之system table取得欄位資訊
# Input parameter: p_flag   - s 表single只查單一個field 
#                             m 表multi查table所有的field
# Input parameter: p_zta17  資料表或欄位來源資料庫名稱
# Input parameter: p_tab    - 若p_flag傳入's',則p_tab需傳入Field Name,
#                             若p_flag傳入'm',則p_tab需傳入Table Name
#                  p_sel    - I : show field ID, N:show Field Name, 
#                             其他:show Field ID+Name
#                  p_type   - 0: 以 p_tabname 設定的欄位名稱
#                             1: 以 p_query 設定的欄位名稱
#                             2: 以 p_crview_set 設定的欄位名稱
# Return code....: 
# Usage..........: CALL cl_get_db_column_info('m', 'ds1', 'ima_file', 'I', 0)
# Date & Author..: 2010/12/22 by Jay
##########################################################################
FUNCTION cl_get_db_column_info(p_flag, p_zta17, p_tab, p_sel, p_type) 
   DEFINE p_flag       LIKE type_file.chr1
   DEFINE p_zta17      LIKE zta_file.zta17
   DEFINE p_tab        STRING
   DEFINE l_sql        STRING
   DEFINE p_type       LIKE type_file.chr1
   DEFINE l_colname    LIKE zal_file.zal04,    
          l_colnamec   LIKE gaq_file.gaq03,    
          l_collen     LIKE type_file.num5,    
          l_coltype    LIKE gaq_file.gaq03,   
          l_data_type  LIKE type_file.chr30,
          p_sel        LIKE type_file.chr1 
   DEFINE l_scale      LIKE type_file.num10
   DEFINE l_sn         LIKE type_file.num5 
   DEFINE l_id         LIKE type_file.num10

      CASE g_db_type  
        WHEN "IFX"  
            IF p_flag = 'm' THEN
             IF NOT cl_null(p_zta17 CLIPPED) THEN
                LET l_sql="SELECT unique c.colname,c.coltype,c.collength ",
                          "  FROM ",p_zta17 CLIPPED,":syscolumns c,",
                          "       ",p_zta17 CLIPPED,":systables t",
                          " WHERE c.tabid=t.tabid AND t.tabname='",p_tab CLIPPED,"'"
             ELSE
                LET l_sql="SELECT unique c.colname,c.coltype,c.collength ",
                          "  FROM syscolumns c,systables t",
                          " WHERE c.tabid=t.tabid AND t.tabname='",p_tab CLIPPED,"'"
             END IF
          ELSE
               IF NOT cl_null(p_zta17 CLIPPED) THEN
                LET l_sql="SELECT unique c.colname,c.coltype,c.collength ",
                          "  FROM ",p_zta17 CLIPPED,":syscolumns c,",
                          "       ",p_zta17 CLIPPED,":systables t",
                          " WHERE c.colname='",p_tab CLIPPED,"'",
                          "   AND c.tabid = t.tabid ",
                          "   AND t.tabname like '%_file'" 
             ELSE
                LET l_sql="SELECT unique c.colname,c.coltype,c.collength ",
                          "  FROM syscolumns c,systables t",
                          " WHERE c.colname='",p_tab CLIPPED,"'",
                          "   AND c.tabid = t.tabid ",
                          "   AND t.tabname like '%_file'"
             END IF
          END IF
          
          DECLARE cl_query_getlength_ifx CURSOR FROM l_sql
          FOREACH cl_query_getlength_ifx INTO l_colname,l_coltype,l_collen
             LET l_scale = -1
             CASE WHEN l_coltype='0' OR l_coltype='256' 
                       LET l_data_type = 'char'
                  WHEN l_coltype='1' or l_coltype='257'
                       LET l_collen=5
                       LET l_data_type = 'smallint'
                  WHEN l_coltype='2' or l_coltype='258'
                       LET l_data_type = 'integer'
                       LET l_collen=10
                  WHEN l_coltype='5' or l_coltype='261'
                       LET l_scale =l_collen mod 256 CLIPPED
                       LET l_collen=20
                       LET l_data_type = 'decimal'
                  WHEN l_coltype='7' or l_coltype='263'
                       LET l_collen=10
                       LET l_data_type = 'date'
                  WHEN l_coltype='13' or l_coltype='269'   
                       LET l_data_type = 'char'
                  WHEN l_coltype='11'    
                       LET l_data_type = 'byte'  
             END CASE

             CALL cl_query_prt_type(p_flag,p_type,l_colname,l_data_type,l_collen,l_scale,'')
                  RETURNING l_colname,l_data_type,l_collen,l_scale,l_colnamec
 
             CASE
               WHEN p_sel='N'
                  INSERT INTO xabc(xabc01,xabc02,xabc03,xabc04,xabc05,xabc06) VALUES(l_sn,l_colname,l_colnamec,l_collen,l_scale,l_data_type)
               WHEN p_sel='I'
                  INSERT INTO xabc(xabc01,xabc02,xabc03,xabc04,xabc05,xabc06) VALUES(l_sn,l_colname,l_colname,l_collen,l_scale,l_data_type)
               OTHERWISE
                  LET g_qry_feldname=l_colname CLIPPED,'(',l_colnamec CLIPPED,')'
                  INSERT INTO xabc(xabc01,xabc02,xabc03,xabc04,xabc05,xabc06) VALUES(l_sn,l_colname,g_qry_feldname,l_collen,l_scale,l_data_type)
             END CASE
             LET l_sn=l_sn+1
          END FOREACH
        WHEN "ORA"   
            IF p_flag = 'm' THEN
             IF NOT cl_null(p_zta17 CLIPPED) THEN
                LET l_sql="SELECT unique column_id,lower(column_name),lower(data_type),decode(data_type,'VARCHAR2',data_length,'DATE',10,'NUMBER',data_PRECISION),DATA_SCALE FROM all_tab_columns",
                          " WHERE lower(table_name)='",p_tab CLIPPED,"' ",
                          "   AND lower(owner)='",p_zta17 CLIPPED,"'", 
                          " ORDER BY column_id"     
             ELSE
                LET l_sql="SELECT unique column_id,lower(column_name),lower(data_type),decode(data_type,'VARCHAR2',data_length,'DATE',10,'NUMBER',data_PRECISION),DATA_SCALE FROM user_tab_columns",
                          " WHERE lower(table_name)='",p_tab CLIPPED,"' ",
                          " ORDER BY column_id" 
             END IF
          ELSE
               IF NOT cl_null(p_zta17 CLIPPED) THEN
                LET l_sql="SELECT unique column_id,lower(column_name),lower(data_type),decode(data_type,'VARCHAR2',data_length,'DATE',10,'NUMBER',data_PRECISION),DATA_SCALE FROM all_tab_columns",
                          " WHERE lower(column_name)='",p_tab CLIPPED,"'",
                          "   AND table_name like '%/_FILE' ESCAPE '/'", 
                          "   AND lower(owner)='",p_zta17 CLIPPED,"'",
                          " ORDER BY column_id"     
             ELSE
                LET l_sql="SELECT unique column_id,lower(column_name),lower(data_type),decode(data_type,'VARCHAR2',data_length,'DATE',10,'NUMBER',data_PRECISION),DATA_SCALE FROM user_tab_columns",
                          " WHERE lower(column_name)='",p_tab CLIPPED,"'",
                          "   AND table_name like '%/_FILE' ESCAPE '/'", 
                          " ORDER BY column_id"   
             END IF
          END IF

          DECLARE cl_query_getlength_ora CURSOR FROM l_sql
          FOREACH cl_query_getlength_ora INTO l_id,l_colname,l_data_type,l_collen,l_scale 
             IF l_data_type  = 'date' THEN
                LET l_collen = 10
             END IF

             CALL cl_query_prt_type(p_flag,p_type,l_colname,l_data_type,l_collen,l_scale,'')
                  RETURNING l_colname,l_data_type,l_collen,l_scale,l_colnamec
 
             CASE
               WHEN p_sel='N'
                  INSERT INTO xabc(xabc01,xabc02,xabc03,xabc04,xabc05,xabc06) VALUES(l_sn,l_colname,l_colnamec,l_collen,l_scale,l_data_type)
               WHEN p_sel='I'
                  INSERT INTO xabc(xabc01,xabc02,xabc03,xabc04,xabc05,xabc06) VALUES(l_sn,l_colname,l_colname,l_collen,l_scale,l_data_type)
               OTHERWISE
                  LET g_qry_feldname=l_colname CLIPPED,'(',l_colnamec CLIPPED,')'
                  INSERT INTO xabc(xabc01,xabc02,xabc03,xabc04,xabc05,xabc06) VALUES(l_sn,l_colname,g_qry_feldname,l_collen,l_scale,l_data_type)
             END CASE
             LET l_sn=l_sn+1
          END FOREACH
        WHEN "MSV"  
            IF p_flag='m' THEN
             IF NOT cl_null(p_zta17 CLIPPED) THEN
                LET l_sql=" SELECT b.column_id,b.name,c.name,(CASE WHEN b.precision = 0 THEN b.max_length ELSE b.precision END),b.scale ",
                          "  FROM ",FGL_GETENV("MSSQLAREA") CLIPPED,"_",p_zta17 CLIPPED,".sys.objects a,", 
                          "       ",FGL_GETENV("MSSQLAREA") CLIPPED,"_",p_zta17 CLIPPED,".sys.columns b,",
                          "       ",FGL_GETENV("MSSQLAREA") CLIPPED,"_",p_zta17 CLIPPED,".sys.types c",
                          "  WHERE a.name='",p_tab CLIPPED,"' ",
                          "    AND a.object_id=b.object_id ",
                          "    AND b.system_type_id=c.system_type_id",
                          "  ORDER BY column_id" 
             ELSE
                LET l_sql=" SELECT b.column_id,b.name,c.name,(CASE WHEN b.precision = 0 THEN b.max_length ELSE b.precision END),b.scale ",
                          "  FROM sys.objects a, sys.columns b, sys.types c",
                          "  WHERE a.name='",p_tab CLIPPED,"' ",
                          "    AND a.object_id=b.object_id ",
                          "    AND b.system_type_id=c.system_type_id",
                          "  ORDER BY column_id"                    
             END IF
          ELSE
               IF NOT cl_null(p_zta17 CLIPPED) THEN
                LET l_sql=" SELECT b.column_id,b.name,c.name,(CASE WHEN b.precision = 0 THEN b.max_length ELSE b.precision END),b.scale ",
                          "  FROM ",FGL_GETENV("MSSQLAREA") CLIPPED,"_",p_zta17 CLIPPED,".sys.objects a,", 
                          "       ",FGL_GETENV("MSSQLAREA") CLIPPED,"_",p_zta17 CLIPPED,".sys.columns b,",
                          "       ",FGL_GETENV("MSSQLAREA") CLIPPED,"_",p_zta17 CLIPPED,".sys.types c",
                          "  WHERE a.name LIKE '%_file' ",
                          "    AND b.name='",p_tab CLIPPED,"' ",
                          "    AND a.object_id=b.object_id ",
                          "    AND b.system_type_id=c.system_type_id",
                          "  ORDER BY column_id"  
             ELSE
                LET l_sql=" SELECT b.column_id,b.name,c.name,(CASE WHEN b.precision = 0 THEN b.max_length ELSE b.precision END),b.scale ",
                          "  FROM sys.objects a, sys.columns b, sys.types c",
                          "  WHERE a.name LIKE '%_file' ",
                          "    AND b.name='",p_tab CLIPPED,"' ",
                          "    AND a.object_id=b.object_id ",
                          "    AND b.system_type_id=c.system_type_id",
                          "  ORDER BY column_id" 
             END IF
          END IF
          
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql   
          DECLARE cl_query_getlength_msv CURSOR FROM l_sql
          FOREACH cl_query_getlength_msv INTO l_id,l_colname,l_data_type,l_collen,l_scale
             CASE
               WHEN l_data_type  = 'date' OR l_data_type='datetime' 
                  LET l_data_type = 'date'
                  LET l_collen = 10
                  LET l_scale = -1
               WHEN l_data_type = 'varchar' OR l_data_type='nvarchar' 
                  LET l_data_type = 'char'
                  LET l_scale = -1
             END CASE

             CALL cl_query_prt_type(p_flag,p_type,l_colname,l_data_type,l_collen,l_scale,'')
                  RETURNING l_colname,l_data_type,l_collen,l_scale,l_colnamec
 
             CASE
               WHEN p_sel='N'
                  INSERT INTO xabc(xabc01,xabc02,xabc03,xabc04,xabc05,xabc06) VALUES(l_sn,l_colname,l_colnamec,l_collen,l_scale,l_data_type)
               WHEN p_sel='I'
                  INSERT INTO xabc(xabc01,xabc02,xabc03,xabc04,xabc05,xabc06) VALUES(l_sn,l_colname,l_colname,l_collen,l_scale,l_data_type)
               OTHERWISE
                  LET g_qry_feldname=l_colname CLIPPED,'(',l_colnamec CLIPPED,')'
                  INSERT INTO xabc(xabc01,xabc02,xabc03,xabc04,xabc05,xabc06) VALUES(l_sn,l_colname,g_qry_feldname,l_collen,l_scale,l_data_type)
             END CASE
             LET l_sn=l_sn+1
          END FOREACH
        WHEN "ASE"  
            IF p_flag = 'm' THEN
             IF NOT cl_null(p_zta17 CLIPPED) THEN
                LET l_sql="SELECT b.colid, b.name , c.name, (CASE WHEN b.prec is null THEN b.length ELSE b.prec END), b.scale ",
                          " FROM ",p_zta17 CLIPPED, ".dbo.sysobjects a, ",
                                   p_zta17 CLIPPED, ".dbo.syscolumns b, ",
                                   p_zta17 CLIPPED, ".dbo.systypes c ",
                          " WHERE lower(a.name) = '",p_tab CLIPPED,"' ",
                          "   AND a.id = b.id AND b.usertype = c.usertype ",    
                          " ORDER BY b.colid"     
             ELSE
                LET l_sql="SELECT b.colid, b.name , c.name, (CASE WHEN b.prec is null THEN b.length ELSE b.prec END), b.scale ",
                          " FROM sysobjects a, ",
                          "      syscolumns b, ",
                          "      systypes c ",
                          " WHERE lower(a.name) = '",p_tab CLIPPED,"' ",
                          "   AND a.id = b.id AND b.usertype = c.usertype ",    
                          " ORDER BY b.colid"     
             END IF
          ELSE
               IF NOT cl_null(p_zta17 CLIPPED) THEN
                LET l_sql="SELECT b.colid, b.name , c.name, (CASE WHEN b.prec is null THEN b.length ELSE b.prec END), b.scale ",
                          " FROM ",p_zta17 CLIPPED, ".dbo.sysobjects a, ",
                                   p_zta17 CLIPPED, ".dbo.syscolumns b, ",
                                   p_zta17 CLIPPED, ".dbo.systypes c ",
                          " WHERE lower(a.name) LIKE '%_file' ",
                          "   AND lower(b.name) = '",p_tab CLIPPED,"' ",
                          "   AND a.id = b.id AND b.usertype = c.usertype ",    
                          " ORDER BY b.colid"     
             ELSE
                LET l_sql="SELECT b.colid, b.name , c.name, (CASE WHEN b.prec is null THEN b.length ELSE b.prec END), b.scale ",
                          " FROM sysobjects a, ",
                          "      syscolumns b, ",
                          "      systypes c ",
                          " WHERE lower(a.name) LIKE '%_file' ",
                          "   AND lower(b.name) = '",p_tab CLIPPED,"' ",
                          "   AND a.id = b.id AND b.usertype = c.usertype ",    
                          " ORDER BY b.colid"     
             END IF
          END IF

          DECLARE cl_query_getlength_ase CURSOR FROM l_sql
          FOREACH cl_query_getlength_ase INTO l_id,l_colname,l_data_type,l_collen,l_scale
             CASE WHEN l_data_type = 'smallint'
                        LET l_collen = 5
                        LET l_scale = 0
                  WHEN l_data_type = 'integer'
                       LET l_collen = 10
                       LET l_scale = 0
                  WHEN l_data_type = 'date'
                         LET l_collen = 10   
             END CASE
             
             CALL cl_query_prt_type(p_flag,p_type,l_colname,l_data_type,l_collen,l_scale,'')
                  RETURNING l_colname,l_data_type,l_collen,l_scale,l_colnamec
             
             CASE
               WHEN p_sel='N'
                  INSERT INTO xabc(xabc01,xabc02,xabc03,xabc04,xabc05,xabc06) VALUES(l_sn,l_colname,l_colnamec,l_collen,l_scale,l_data_type)
               WHEN p_sel='I'
                  INSERT INTO xabc(xabc01,xabc02,xabc03,xabc04,xabc05,xabc06) VALUES(l_sn,l_colname,l_colname,l_collen,l_scale,l_data_type)
               OTHERWISE
                  LET g_qry_feldname=l_colname CLIPPED,'(',l_colnamec CLIPPED,')'
                  INSERT INTO xabc(xabc01,xabc02,xabc03,xabc04,xabc05,xabc06) VALUES(l_sn,l_colname,g_qry_feldname,l_collen,l_scale,l_data_type)
             END CASE
             LET l_sn=l_sn+1
          END FOREACH
      END CASE
END FUNCTION
#---FUN-A90024---end-------

#No:FUN-AA0074 -- start --
#No:FUN-B50137
##################################################
# Private Func...: TRUE
# Descriptions...: 將匯率格式千方位(逗號)拿掉
# Date & Author..: 11/01/24 By Jay
# Input parameter: p_num  目前check的欄位
#                  p_i    目前check的筆數
# Return code....: void
# Modify ........: 
##################################################
FUNCTION cl_query_prt_replace_str(p_num, p_i)
    DEFINE p_num          LIKE type_file.num10    #目前check的欄位
    DEFINE p_i            LIKE type_file.num10    #目前check的筆數
    
    CASE p_num
       WHEN   1  LET ga_table_data[p_i].field001 = cl_replace_str(ga_table_data[p_i].field001, ',', '') 
       WHEN   2  LET ga_table_data[p_i].field002 = cl_replace_str(ga_table_data[p_i].field002, ',', '') 
       WHEN   3  LET ga_table_data[p_i].field003 = cl_replace_str(ga_table_data[p_i].field003, ',', '') 
       WHEN   4  LET ga_table_data[p_i].field004 = cl_replace_str(ga_table_data[p_i].field004, ',', '') 
       WHEN   5  LET ga_table_data[p_i].field005 = cl_replace_str(ga_table_data[p_i].field005, ',', '') 
       WHEN   6  LET ga_table_data[p_i].field006 = cl_replace_str(ga_table_data[p_i].field006, ',', '') 
       WHEN   7  LET ga_table_data[p_i].field007 = cl_replace_str(ga_table_data[p_i].field007, ',', '') 
       WHEN   8  LET ga_table_data[p_i].field008 = cl_replace_str(ga_table_data[p_i].field008, ',', '') 
       WHEN   9  LET ga_table_data[p_i].field009 = cl_replace_str(ga_table_data[p_i].field009, ',', '') 
       WHEN  10  LET ga_table_data[p_i].field010 = cl_replace_str(ga_table_data[p_i].field010, ',', '') 
       WHEN  11  LET ga_table_data[p_i].field011 = cl_replace_str(ga_table_data[p_i].field011, ',', '') 
       WHEN  12  LET ga_table_data[p_i].field012 = cl_replace_str(ga_table_data[p_i].field012, ',', '') 
       WHEN  13  LET ga_table_data[p_i].field013 = cl_replace_str(ga_table_data[p_i].field013, ',', '') 
       WHEN  14  LET ga_table_data[p_i].field014 = cl_replace_str(ga_table_data[p_i].field014, ',', '') 
       WHEN  15  LET ga_table_data[p_i].field015 = cl_replace_str(ga_table_data[p_i].field015, ',', '') 
       WHEN  16  LET ga_table_data[p_i].field016 = cl_replace_str(ga_table_data[p_i].field016, ',', '') 
       WHEN  17  LET ga_table_data[p_i].field017 = cl_replace_str(ga_table_data[p_i].field017, ',', '') 
       WHEN  18  LET ga_table_data[p_i].field018 = cl_replace_str(ga_table_data[p_i].field018, ',', '') 
       WHEN  19  LET ga_table_data[p_i].field019 = cl_replace_str(ga_table_data[p_i].field019, ',', '') 
       WHEN  20  LET ga_table_data[p_i].field020 = cl_replace_str(ga_table_data[p_i].field020, ',', '') 
       WHEN  21  LET ga_table_data[p_i].field021 = cl_replace_str(ga_table_data[p_i].field021, ',', '') 
       WHEN  22  LET ga_table_data[p_i].field022 = cl_replace_str(ga_table_data[p_i].field022, ',', '') 
       WHEN  23  LET ga_table_data[p_i].field023 = cl_replace_str(ga_table_data[p_i].field023, ',', '') 
       WHEN  24  LET ga_table_data[p_i].field024 = cl_replace_str(ga_table_data[p_i].field024, ',', '') 
       WHEN  25  LET ga_table_data[p_i].field025 = cl_replace_str(ga_table_data[p_i].field025, ',', '') 
       WHEN  26  LET ga_table_data[p_i].field026 = cl_replace_str(ga_table_data[p_i].field026, ',', '') 
       WHEN  27  LET ga_table_data[p_i].field027 = cl_replace_str(ga_table_data[p_i].field027, ',', '') 
       WHEN  28  LET ga_table_data[p_i].field028 = cl_replace_str(ga_table_data[p_i].field028, ',', '') 
       WHEN  29  LET ga_table_data[p_i].field029 = cl_replace_str(ga_table_data[p_i].field029, ',', '') 
       WHEN  30  LET ga_table_data[p_i].field030 = cl_replace_str(ga_table_data[p_i].field030, ',', '') 
       WHEN  31  LET ga_table_data[p_i].field031 = cl_replace_str(ga_table_data[p_i].field031, ',', '') 
       WHEN  32  LET ga_table_data[p_i].field032 = cl_replace_str(ga_table_data[p_i].field032, ',', '') 
       WHEN  33  LET ga_table_data[p_i].field033 = cl_replace_str(ga_table_data[p_i].field033, ',', '') 
       WHEN  34  LET ga_table_data[p_i].field034 = cl_replace_str(ga_table_data[p_i].field034, ',', '') 
       WHEN  35  LET ga_table_data[p_i].field035 = cl_replace_str(ga_table_data[p_i].field035, ',', '') 
       WHEN  36  LET ga_table_data[p_i].field036 = cl_replace_str(ga_table_data[p_i].field036, ',', '') 
       WHEN  37  LET ga_table_data[p_i].field037 = cl_replace_str(ga_table_data[p_i].field037, ',', '') 
       WHEN  38  LET ga_table_data[p_i].field038 = cl_replace_str(ga_table_data[p_i].field038, ',', '') 
       WHEN  39  LET ga_table_data[p_i].field039 = cl_replace_str(ga_table_data[p_i].field039, ',', '') 
       WHEN  40  LET ga_table_data[p_i].field040 = cl_replace_str(ga_table_data[p_i].field040, ',', '') 
       WHEN  41  LET ga_table_data[p_i].field041 = cl_replace_str(ga_table_data[p_i].field041, ',', '') 
       WHEN  42  LET ga_table_data[p_i].field042 = cl_replace_str(ga_table_data[p_i].field042, ',', '') 
       WHEN  43  LET ga_table_data[p_i].field043 = cl_replace_str(ga_table_data[p_i].field043, ',', '') 
       WHEN  44  LET ga_table_data[p_i].field044 = cl_replace_str(ga_table_data[p_i].field044, ',', '') 
       WHEN  45  LET ga_table_data[p_i].field045 = cl_replace_str(ga_table_data[p_i].field045, ',', '') 
       WHEN  46  LET ga_table_data[p_i].field046 = cl_replace_str(ga_table_data[p_i].field046, ',', '') 
       WHEN  47  LET ga_table_data[p_i].field047 = cl_replace_str(ga_table_data[p_i].field047, ',', '') 
       WHEN  48  LET ga_table_data[p_i].field048 = cl_replace_str(ga_table_data[p_i].field048, ',', '') 
       WHEN  49  LET ga_table_data[p_i].field049 = cl_replace_str(ga_table_data[p_i].field049, ',', '') 
       WHEN  50  LET ga_table_data[p_i].field050 = cl_replace_str(ga_table_data[p_i].field050, ',', '') 
       WHEN  51  LET ga_table_data[p_i].field051 = cl_replace_str(ga_table_data[p_i].field051, ',', '') 
       WHEN  52  LET ga_table_data[p_i].field052 = cl_replace_str(ga_table_data[p_i].field052, ',', '') 
       WHEN  53  LET ga_table_data[p_i].field053 = cl_replace_str(ga_table_data[p_i].field053, ',', '') 
       WHEN  54  LET ga_table_data[p_i].field054 = cl_replace_str(ga_table_data[p_i].field054, ',', '') 
       WHEN  55  LET ga_table_data[p_i].field055 = cl_replace_str(ga_table_data[p_i].field055, ',', '') 
       WHEN  56  LET ga_table_data[p_i].field056 = cl_replace_str(ga_table_data[p_i].field056, ',', '') 
       WHEN  57  LET ga_table_data[p_i].field057 = cl_replace_str(ga_table_data[p_i].field057, ',', '') 
       WHEN  58  LET ga_table_data[p_i].field058 = cl_replace_str(ga_table_data[p_i].field058, ',', '') 
       WHEN  59  LET ga_table_data[p_i].field059 = cl_replace_str(ga_table_data[p_i].field059, ',', '') 
       WHEN  60  LET ga_table_data[p_i].field060 = cl_replace_str(ga_table_data[p_i].field060, ',', '') 
       WHEN  61  LET ga_table_data[p_i].field061 = cl_replace_str(ga_table_data[p_i].field061, ',', '') 
       WHEN  62  LET ga_table_data[p_i].field062 = cl_replace_str(ga_table_data[p_i].field062, ',', '') 
       WHEN  63  LET ga_table_data[p_i].field063 = cl_replace_str(ga_table_data[p_i].field063, ',', '') 
       WHEN  64  LET ga_table_data[p_i].field064 = cl_replace_str(ga_table_data[p_i].field064, ',', '') 
       WHEN  65  LET ga_table_data[p_i].field065 = cl_replace_str(ga_table_data[p_i].field065, ',', '') 
       WHEN  66  LET ga_table_data[p_i].field066 = cl_replace_str(ga_table_data[p_i].field066, ',', '') 
       WHEN  67  LET ga_table_data[p_i].field067 = cl_replace_str(ga_table_data[p_i].field067, ',', '') 
       WHEN  68  LET ga_table_data[p_i].field068 = cl_replace_str(ga_table_data[p_i].field068, ',', '') 
       WHEN  69  LET ga_table_data[p_i].field069 = cl_replace_str(ga_table_data[p_i].field069, ',', '') 
       WHEN  70  LET ga_table_data[p_i].field070 = cl_replace_str(ga_table_data[p_i].field070, ',', '') 
       WHEN  71  LET ga_table_data[p_i].field071 = cl_replace_str(ga_table_data[p_i].field071, ',', '') 
       WHEN  72  LET ga_table_data[p_i].field072 = cl_replace_str(ga_table_data[p_i].field072, ',', '') 
       WHEN  73  LET ga_table_data[p_i].field073 = cl_replace_str(ga_table_data[p_i].field073, ',', '') 
       WHEN  74  LET ga_table_data[p_i].field074 = cl_replace_str(ga_table_data[p_i].field074, ',', '') 
       WHEN  75  LET ga_table_data[p_i].field075 = cl_replace_str(ga_table_data[p_i].field075, ',', '') 
       WHEN  76  LET ga_table_data[p_i].field076 = cl_replace_str(ga_table_data[p_i].field076, ',', '') 
       WHEN  77  LET ga_table_data[p_i].field077 = cl_replace_str(ga_table_data[p_i].field077, ',', '') 
       WHEN  78  LET ga_table_data[p_i].field078 = cl_replace_str(ga_table_data[p_i].field078, ',', '') 
       WHEN  79  LET ga_table_data[p_i].field079 = cl_replace_str(ga_table_data[p_i].field079, ',', '') 
       WHEN  80  LET ga_table_data[p_i].field080 = cl_replace_str(ga_table_data[p_i].field080, ',', '') 
       WHEN  81  LET ga_table_data[p_i].field081 = cl_replace_str(ga_table_data[p_i].field081, ',', '') 
       WHEN  82  LET ga_table_data[p_i].field082 = cl_replace_str(ga_table_data[p_i].field082, ',', '') 
       WHEN  83  LET ga_table_data[p_i].field083 = cl_replace_str(ga_table_data[p_i].field083, ',', '') 
       WHEN  84  LET ga_table_data[p_i].field084 = cl_replace_str(ga_table_data[p_i].field084, ',', '') 
       WHEN  85  LET ga_table_data[p_i].field085 = cl_replace_str(ga_table_data[p_i].field085, ',', '') 
       WHEN  86  LET ga_table_data[p_i].field086 = cl_replace_str(ga_table_data[p_i].field086, ',', '') 
       WHEN  87  LET ga_table_data[p_i].field087 = cl_replace_str(ga_table_data[p_i].field087, ',', '') 
       WHEN  88  LET ga_table_data[p_i].field088 = cl_replace_str(ga_table_data[p_i].field088, ',', '') 
       WHEN  89  LET ga_table_data[p_i].field089 = cl_replace_str(ga_table_data[p_i].field089, ',', '') 
       WHEN  90  LET ga_table_data[p_i].field090 = cl_replace_str(ga_table_data[p_i].field090, ',', '') 
       WHEN  91  LET ga_table_data[p_i].field091 = cl_replace_str(ga_table_data[p_i].field091, ',', '') 
       WHEN  92  LET ga_table_data[p_i].field092 = cl_replace_str(ga_table_data[p_i].field092, ',', '') 
       WHEN  93  LET ga_table_data[p_i].field093 = cl_replace_str(ga_table_data[p_i].field093, ',', '') 
       WHEN  94  LET ga_table_data[p_i].field094 = cl_replace_str(ga_table_data[p_i].field094, ',', '') 
       WHEN  95  LET ga_table_data[p_i].field095 = cl_replace_str(ga_table_data[p_i].field095, ',', '') 
       WHEN  96  LET ga_table_data[p_i].field096 = cl_replace_str(ga_table_data[p_i].field096, ',', '') 
       WHEN  97  LET ga_table_data[p_i].field097 = cl_replace_str(ga_table_data[p_i].field097, ',', '') 
       WHEN  98  LET ga_table_data[p_i].field098 = cl_replace_str(ga_table_data[p_i].field098, ',', '') 
       WHEN  99  LET ga_table_data[p_i].field099 = cl_replace_str(ga_table_data[p_i].field099, ',', '') 
       WHEN 100  LET ga_table_data[p_i].field100 = cl_replace_str(ga_table_data[p_i].field100, ',', '') 
    END CASE
END FUNCTION
#END FUN-AA0074

#TQC-BB0068 - Start -
##############################################################################
#[
# Description....: 判斷輸出資料的顯示方式
# Date & Author..: 2011/12/19 by ka0132
# Parameter......: l_value, l_scale    - 要輸出的資料, 顯示的小數位長度
# Return.........: l_scale             - 顯示的小數位長度
# Memo...........:
# Modify.........:
#]
##############################################################################
FUNCTION cl_scale_chk(l_value, l_scale)
DEFINE l_value   STRING
DEFINE l_scale   INTEGER 
   IF l_scale = 11 THEN  #0表示該值為數字,賦予初始值11, 若為null代表該值為文字
      LET l_scale = l_value.getLength() - l_value.getIndexOf(".",1) 
   END IF
RETURN l_scale
END FUNCTION 
#TQC-BB0068 -  End  -

function cl_query_prt_cmd_query()
    define l_darcy_cmd string
    define l_darcy_file string
    define l_darcy_sql  string
    define l_darcy_where,l_darcy_temp string
    define types  varchar(20)
    define l_darcy_length,l_darcy_i,l_darcy_m,l_darcy_n,l_darcy_s,l_darcy_a,l_darcy_b integer  -- 日期字串长度,postion
    define l_darcy_match,l_darcy_format string
    define res like type_file.num10
    define d datetime day to fraction(3)
    define l_temp   string


    let l_darcy_cmd = "/u1/usr/tiptop/fast/query"
    let l_darcy_cmd = l_darcy_cmd," --config /u1/usr/tiptop/fast/config.query.xml"
    let l_darcy_cmd = l_darcy_cmd," --query ",g_zai01
    if not cl_null(g_execmd) then
         let l_darcy_temp = g_execmd.toLowerCase()
         let l_darcy_b = l_darcy_temp.getIndexOf("where",1)
         let l_darcy_temp =""

         let l_darcy_s = g_execmd.getLength() --g_execmd 长度
         if l_darcy_b > 0 then
            let l_darcy_where = g_execmd.subString(l_darcy_b+5,l_darcy_s)
            let l_darcy_s = l_darcy_where.getLength() --p_sql 长度

            let types = fgl_getenv("DBDATE")
            #  Y2MD/  Y4MD/ 四位或者二位年份
            if types = "Y2MD/" then
               let l_darcy_length = 8
               let l_darcy_format = "'yy/mm/dd'"
            end if
            if types = "Y4MD/" then
               let l_darcy_length = 10
               let l_darcy_format = "'yyyy/mm/dd'"
            end if
            let l_darcy_match ="'[0-9]*/[0-9]*/[0-9]*'"

            let l_darcy_a = 1 # 开始 l_darcy_where 是第一个位置
            let l_darcy_i = 1 # 现在位置 '
            while true
               let l_darcy_m = l_darcy_where.getIndexOf("'",l_darcy_i)
               if l_darcy_m <=0 then
                     let l_darcy_sql = l_darcy_sql,l_darcy_where.subString(l_darcy_a,l_darcy_s)
                     exit while
               end if
               let l_darcy_i = l_darcy_m + 1
               let l_darcy_n = l_darcy_where.getIndexOf("'",l_darcy_i)
               if l_darcy_n<=0 then
                     let l_darcy_sql = l_darcy_sql,l_darcy_where.subString(l_darcy_a,l_darcy_s)
                     exit while
               end if
               let l_darcy_i = l_darcy_n + 1
               #  '23/01/01' '2023/01/01'
               let l_darcy_temp = l_darcy_where.subString(l_darcy_m,l_darcy_n)
               if l_darcy_temp.getLength()!=l_darcy_length+2 or l_darcy_temp not MATCHES l_darcy_match then
                     # 不是日期格式
                     let l_darcy_sql = l_darcy_sql,l_darcy_where.subString(l_darcy_a,l_darcy_n)
                     let l_darcy_a = l_darcy_n + 1  #+1 下次从下个位置开始
                     continue while
               end if
               # 是日期格式
               # l_darcy_a 上次结束位置
               # 将日期之前加入
               let l_darcy_sql = l_darcy_sql,l_darcy_where.subString(l_darcy_a,l_darcy_m-1) #-1是为了去掉 '
               let l_darcy_sql = l_darcy_sql,"to_date(",l_darcy_temp,",",l_darcy_format,")"
               let l_darcy_a = l_darcy_n + 1 #+1是为了去掉 '
            end while
            let l_darcy_sql = g_execmd.subString(1,l_darcy_b+4),l_darcy_sql # +4是为了加上where
         else
            # 没有where语句，不需要转换
            let l_darcy_sql = g_execmd
         end if 
         
      #   let g_execmd = cl_export_replace_date_str(g_execmd)
        let l_darcy_cmd = l_darcy_cmd," --param \"",l_darcy_sql,"\""
    end if
   #  let l_darcy_file = cl_export_get_excel_name(),".xlsx"
    

    # 获取文件前缀
    let d = current day to fraction(3)
    let l_temp = cl_replace_str(d,' ','')
    let l_temp = cl_replace_str(l_temp,':','')
    let l_temp = cl_replace_str(l_temp,'.','')
    let l_temp = fgl_getenv("TEMPDIR") clipped,"/",g_zai01,"_",l_temp #darcy:2024/01/18 g_prog --> g_zai01
    let l_darcy_file = l_temp,".xlsx"


    let l_darcy_cmd = l_darcy_cmd," --excel ",l_darcy_file
    let l_darcy_cmd = l_darcy_cmd , " --report "
    display l_darcy_cmd
    run l_darcy_cmd #执行
    if not os.Path.exists(l_darcy_file) then
        call cl_err('','lib-216',1)
        return
    end if

   #  call cl_download_by_explorer(l_darcy_file)
    let l_darcy_file = os.Path.basename(l_darcy_file)

    let l_darcy_file = fgl_getenv("FGLASIP") clipped,"/tiptop/out/",l_darcy_file clipped
    call ui.Interface.frontCall("standard",
                                "shellexec",
                                ["EXPLORER \"" || l_darcy_file || "\""],
                                [res])
    if status then
        call cl_err("Front End Call Failed.",status,1)
        return
    end if

end function
