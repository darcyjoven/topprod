# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Library name...: cl_create_qry.4gl
# Descriptions...: 動態產生查詢程式與畫面,並回傳在gac_file定義需回傳的欄位值.
# Memo...........: 欲建立的查詢程式
#                  1. 需在gac_file內存有相關資料.
#                  2. 畫面上最多只有20個欄位.
#                  3. WHERE條件最多只有9個替換參數.
#                  4. 最多只有3個回傳值.
#                  5. 在執行主要FUNCTION前,要先執行公用變數初始化FUNCTION.
# Date & Author..: 2003/07/08 by Hiko
# Modify.........: 03/09/09 Hiko 將公用變數的multisel移除,改為判斷是否是在CONSTRUCT狀態下開窗.
#                                若是,則將畫面改為可複選,反之則否.
# Modify.........: 03/09/10 Hiko 因應有些畫面的設定並非依照畫面的順序設定gac_file,因此新增一個
#                                公用變數multiret_index,以設定多選狀態所要回傳的欄位,預設為第一個欄位.
# Modify.........: 04/09/09 alex 加上 gat 作 win title 的墊背
# Modify.........: No.MOD-490496 04/09/30 saki 修改自訂資料庫
# Modify.........: No.MOD-440465 04/10/13 saki 新增客製欄位gab11,gac12
# Modify.........: No.MOD-4B0184 04/11/17 alex Dynamic Array改由STRING組成, 利用
#                  aza_file.aza38 作最大筆數控管,於aoos010設定
# Modify.........: No.MOD-4C0011 04/12/10 alex 增加回傳個數到五個
# Modify.........: No.MOD-470106 05/02/23 alex 增加可以設定 ComboBox
# Modify.........: No.MOD-4C0118 05/02/24 alex 取消最大欄寬限制, 說明請見 p_zl
# Modify.........: No.MOD-530711 05/03/30 alex 取消 INFORMIX 使用 (+)
# Modify.........: No.MOD-540046 05/04/19 alex 處理 DateEdit 和 ComboBox 的問題
# Modify.........: No.FUN-550021 05/05/03 Lifeng 增加對料件多屬性的支持
# Modify.........: No.MOD-570211 05/07/19 alex _cancel() 及 _accept() 函式WHEN判錯
# Modify.........: No.MOD-580049 05/08/03 alex 清空初始變數
# Modify.........: No.FUN-570133 05/08/04 alex 把不該用的翻頁鍵藏起來
# Modify.........: No.FUN-580087 05/08/17 alex 加入無法開啟 window 時的錯誤訊息
# Modify.........: No.MOD-580307 05/08/26 alex modi reconstruct err
# Modify.........: No.MOD-590535 05/09/30 alex 刪除ls_new_arg前後空白
# Modify.........: No.MOD-590436 05/10/18 Sarah 將FUN-550021修改的地方復原成跟Top168一樣
# Modify.........: No.TQC-610001 06/01/02 alex 加lib以減少執行因抓取不到資料的當出
# Modify.........: No.TQC-620117 06/02/23 alex to_char()轉換錯誤
# Modify.........: No.TQC-630132 06/03/13 saki 回復cl_replace_once的參數值
# Modify.........: No.MOD-640523 06/04/21 saki to_char()裡面有,，抓取欄位時須改變
# Modify.........: No.TQC-640180 06/04/25 will 去掉MOD-590436的修改
# Modify.........: No.TQC-650075 06/05/19 Rayven 現將程序中涉及的imandx表改為imx表，原欄位imandx改為imx000
# Modify.........: No.TQC-650102 06/05/23 saki 補充MOD-640523問題，且只在ORA版本才轉換to_char()
# Modify.........: No.FUN-640269 06/07/07 saki 新增開窗Excel匯出功能
# Modify.........: No.FUN-690005 06/09/15 By chen 類型轉換
# Modify.........: No.FUN-6A0048 06/10/25 saki ORA OUTER 字串替換
# Modify.........: No.FUN-710055 07/01/22 saki 自定義欄位開窗功能
# Modify.........: No.FUN-720042 07/03/02 By saki 因應4fd使用, findNode搜尋修改
# Modify.........: No.FUN-710071 07/03/19 By CoCo 無其他程式碼設為False
# Modify.........: No.FUN-760072 07/06/26 By saki 若有設定串查功能，則開窗功能增加串查連結
# Modify.........: No.MOD-770064 07/07/13 By alex 新增MSV程式段
# Modify.........: No.FUN-770073 07/07/13 By shine 於日期欄位輸入如 070101:070501 的條件, SQL WHERE 條件會有問題導致查詢不出任何一筆資料
# Modify.........: No.MOD-780270 07/08/29 By Pengu 當同一欄位在gae_file中有兩筆以上資料時，QRY會查不到資料
# Modify.........: No.FUN-790044 07/09/19 By Brendan .ora 內容回歸 4GL 中
# Modify.........: No.MOD-760095 07/09/27 pengu construct時不會參考g_qryparam.where條件
# Modify.........: No.MOD-7A0107 07/10/18 By Pengu 當arg變數只有一個' '時不應該被trim掉
# Modify.........: No.FUN-7B0028 07/11/12 By alex 修訂註解以配合自動抓取機制
# Modify.........: No.FUN-810071 08/01/25 By alex 增加MSV 使用函式
# Modify.........: No.FUN-840011 08/04/03 By saki 行業別代碼依照cl_ui_locale設定,以執行程式代碼為主
# Modify.........: No.TQC-840050 08/04/21 By chenzhong 使用料件多屬性時, 執行apmt110 單頭的采購單的查詢 (q_pmm6) , 輸入日期為080420查不出資料,需輸入 08/04/20 
# Modify.........: No.CHI-840075 08/04/30 By saki 恢復串查功能為開啟
# Modify.........: No.FUN-870043 08/08/19 By saki 開窗全選功能
# Modify.........: No.FUN-880067 08/08/19 By chenyu 單身xxx_file,OUTER勾選的時候，如果單頭中輸入的where條件中有"ta_xxx01"，組出來的sql語句會出現"ta_xxx_file.xxx01"
# Modify.........: No.MOD-880105 08/08/25 By claire 在asfi301工單開窗查詢後匯出excel有問題
# Modify.........: No.MOD-8A0216 08/10/24 By claire 料件多屬性有勾選時,當qry有日期條件時(當使用 < , >),會無法查出資料
# Modify.........: No.CHI-8B0054 08/11/28 By saki tabIndex屬性值計算方式改變, 不可重複
# Modify.........: No.TQC-910019 09/01/12 By saki 畫面清空位置改變
# Modify.........: No.MOD-930179 09/03/19 By Sarah 當以gc_gac04回抓azp_file抓不到資料時,應預設gc_gac04=g_dbs
# Modify.........: No.TQC-950048 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring() 
# Modify.........: No.FUN-980030 09/08/03 By Hiko 查詢參數增加指定跨Plant查詢資料的設定,並移除gab10與gac04.
# Modify.........: No.FUN-960070 09/08/13 By tsai_yen qry_string回復狀態須在DIALOG中才能有作用
# Modify.........: No:MOD-9B0009 09/11/03 By saki 自定義欄位開窗時先清空g_qryparam的值
# Modify.........: No.FUN-A50080 10/05/21 By Hiko 1.移除FUNCTION cl_get_target_table,改為獨立程式cl_get_target_table.4gl
#                                                 2.取消營運中心階層的部分
# Modify.........: No:FUN-A70010 10/07/05 By tsai_yen 增加尋找ScrollGrid的Matrix屬性的元件
# Modify.........: No:CHI-A40050 10/07/14 By tommas 修正回傳值設定於第10個欄位之後不正確的問題。using "&&"
# Modify.........: No.FUN-AA0017 10/10/22 By alex 新增ASE程式段
# Modify.........: No.FUN-AC0036 10/12/28 By Jay 調整各DB利用sch_file取得table與field等資訊
# Modify.........: No:FUN-B10055 11/01/24 By tsai_yen 視窗title顯示動態查詢程式名稱代碼
# Modify.........: No:FUN-B70007 11/07/05 By jrg542 在EXIT PROGRAM前加上CALL cl_used(2)
# Modify.........: No:WEB-C40003 12/04/06 By tsai_yen GP 5.3 Hard Code動態開窗共用qry,GWC無法動態產生查詢畫面
#                                                     s_xxx 加PHANTOM欄位xxx21 ~ xxx83; 改用cl_getmsg、cl_get_column_info、cl_set_combo_items
#                                                     ma_qry和ma_qry_tmp改名為g_ma_qry和g_ma_qry_tmp,避免GLOBALS變數和其他程式衝突

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#2005/05/03 FUN-550021 Modi By Lifeng Start
#為了容納顯示明細屬性(每個料件編號欄位要有11個對應的欄位)，所以修改欄位最大
#限額為53，設計時允許同一個開窗中最多同時出現3個料件編號欄位
#計算方法:MAX_COUNT = 20(原有)+3*11(3組/每組11個)=53
#這里不改變原來的MAX_COUNT常量的值，而是新增了一個MAX_COUNT_TOT的常量，用來
#存放所有欄位的總計限額，而原來的常量表示屏幕上可作為開窗顯示的欄位數量限額

GLOBALS   #部分function和WEB區共用,所以全域變數要放到GLOBALS  #WEB-C40003
   CONSTANT MI_MAX_COL_COUNT  = 20 # 畫面的最大欄位數.
   CONSTANT MI_MAX_COL_COUNT_TOT  = 83 # 畫面的最大欄位數.
 
   CONSTANT MI_MAX_ITEMNO_COUNT  = 3 #畫面中最多同時出現的料件編號欄位數量
   #2005/05/03 Modi By Lifeng End
 
   CONSTANT MI_MAX_COL_WIDTH  = 50 # 畫面的最大欄位寬度. MOD-4C0118
    
   DEFINE ms_cons_where    STRING          # 暫存CONSTRUCT區塊的WHERE條件.
                                           # 建立查詢程式畫面資料的暫存器.
   DEFINE ma_gac DYNAMIC ARRAY OF RECORD   # LIKE gac_file.*
             gac01  LIKE gac_file.gac01,   # 查詢資料的暫存器.
             gac02  LIKE gac_file.gac02,
             gae04  LIKE gae_file.gae04,   # 2004/03/08 多語言修正至 gae_file
             #gac04  LIKE gac_file.gac04,  #FUN-980030
             gac05  LIKE gac_file.gac05,
             gac06  LIKE gac_file.gac06,
             gac07  LIKE gac_file.gac07,   # 2004/03/22 欄位使用型態設定
             gac09  LIKE gac_file.gac09,
             gac10  LIKE gac_file.gac10,
             gac11  LIKE gac_file.gac11,
             gac12  LIKE gac_file.gac12,
             gac13  LIKE gac_file.gac13    # 2005/02/23 型態遮罩
   END RECORD
 
   #2005/05/03 FUN-550021 Add By Lifeng Start
   #為了多屬性管理增加成員變量為83個
   #DEFINE g_ma_qry DYNAMIC ARRAY OF RECORD
   #       check  LIKE type_file.chr1,           #No.FUN-690005 VARCHAR(1)
   #       item01,item02,item03,item04,item05,
   #       item06,item07,item08,item09,item10,
   #       item11,item12,item13,item14,item15,
   #       item16,item17,item18,item19,item20 STRING  #CHAR(250) #MOD-4B0184
   #END RECORD
   #DEFINE g_ma_qry_tmp DYNAMIC ARRAY OF RECORD
   #       check  LIKE type_file.chr1,           #No.FUN-690005 VARCHAR(1)
   #       item01,item02,item03,item04,item05,
   #       item06,item07,item08,item09,item10,
   #       item11,item12,item13,item14,item15,
   #    item16,item17,item18,item19,item20 STRING  #CHAR(250) #MOD-4B0184
   #END RECORD
    
   DEFINE g_ma_qry DYNAMIC ARRAY OF RECORD
          check  LIKE type_file.chr1,           #No.FUN-690005 VARCHAR(1)
          item01,item02,item03,item04,item05,
          item06,item07,item08,item09,item10,
          item11,item12,item13,item14,item15,
          item16,item17,item18,item19,item20,
          item21,item22,item23,item24,item25,
          item26,item27,item28,item29,item30,
          item31,item32,item33,item34,item35,
          item36,item37,item38,item39,item40,
          item41,item42,item43,item44,item45,
          item46,item47,item48,item49,item50,
          item51,item52,item53,item54,item55,
          item56,item57,item58,item59,item60,
          item61,item62,item63,item64,item65,
          item66,item67,item68,item69,item70,
          item71,item72,item73,item74,item75,
          item76,item77,item78,item79,item80,
          item81,item82,item83 STRING  #CHAR(250) #MOD-4B0184
   END RECORD
   DEFINE g_ma_qry_tmp DYNAMIC ARRAY OF RECORD
          check  LIKE type_file.chr1,           #No.FUN-690005 VARCHAR(1)
          item01,item02,item03,item04,item05,
          item06,item07,item08,item09,item10,
          item11,item12,item13,item14,item15,
          item16,item17,item18,item19,item20,
          item21,item22,item23,item24,item25,
          item26,item27,item28,item29,item30,
          item31,item32,item33,item34,item35,
          item36,item37,item38,item39,item40,
          item41,item42,item43,item44,item45,
          item46,item47,item48,item49,item50,
          item51,item52,item53,item54,item55,
          item56,item57,item58,item59,item60,
          item61,item62,item63,item64,item65,
          item66,item67,item68,item69,item70,
          item71,item72,item73,item74,item75,
          item76,item77,item78,item79,item80,
          item81,item82,item83  STRING  #CHAR(250) #MOD-4B0184
   END RECORD
 
   DEFINE g_imafldlist   DYNAMIC ARRAY OF  LIKE type_file.num5           #No.FUN-690005 SMALLINT   #模塊全局變量，表示當前的查詢中包含料件欄位的數量
          #說明：該動態數組中包含的最大容量受系統常量MI_MAX_ITEM_COUNT限定，並且為了避免因為在同一個
          #查詢中出現兩次同名的料件編號欄位而造成判斷錯誤，這裡記錄的是料件編號的index而非name，在下面
          #ma_multi_rec[xxx].imafld的設置過程中只根據該欄位的索引值是否在該數組中來決定Y，即如果同一個查詢
          #中出現了超過MI_MAX_ITEM_COUNT常數限定個數的料件欄位，則超出的部分將被作為普通欄位，其imafld將為'N'
    
   #這個程序數組是為了用INPUT模擬CONSTRUCT時使用的
   DEFINE ma_cons_lif DYNAMIC ARRAY OF RECORD
          check  LIKE type_file.chr1,           #No.FUN-690005 VARCHAR(1)
          item01,item02,item03,item04,item05,
          item06,item07,item08,item09,item10,
          item11,item12,item13,item14,item15,
          item16,item17,item18,item19,item20,
          item21,item22,item23,item24,item25,
          item26,item27,item28,item29,item30,
          item31,item32,item33,item34,item35,
          item36,item37,item38,item39,item40,
          item41,item42,item43,item44,item45,
          item46,item47,item48,item49,item50,
          item51,item52,item53,item54,item55,
          item56,item57,item58,item59,item60,
          item61,item62,item63,item64,item65,
          item66,item67,item68,item69,item70,
          item71,item72,item73,item74,item75,
          item76,item77,item78,item79,item80,
          item81,item82,item83  STRING  #CHAR(250) #MOD-4B0184
   END RECORD
    
   #該數組是多屬性料號中的一個重要的控制數組，記錄了整個Table中所有的
   #列及其控制信息，在程序中多次用到
   DEFINE ma_multi_rec DYNAMIC ARRAY OF RECORD
          index	 LIKE type_file.num5,           #No.FUN-690005 SMALLINT      #字段的序號
          colname   STRING,        #列名稱
          value     DYNAMIC ARRAY OF STRING,   #屏幕數組值
          dbfield   STRING,        #在數據庫中對應的實際欄位名稱
          dbtype    LIKE type_file.chr1000,        #No.FUN-690005 VARCHAR(102),     #該欄位在數據庫中的數據類型
          object    om.DomNode,    #該欄位的列對象
          dispfld   STRING,        #表示該t欄位(或表示料件的x欄位)對應的顯示欄位
          imafld    STRING,        #只對x欄位有效，'Y'表示該欄位表示料件編號
                                   #'N'表示該欄位不是料件編號
          visible   LIKE type_file.num5           #No.FUN-690005 SMALLINT       #該列是否顯示出來，只對於t欄位有效
   END RECORD
 
   #以下是多屬性料件專用的合成SQL用的字符串
   DEFINE g_multi_join   STRING,
          g_multi_where  STRING
           
   #2005/05/03 Add By Lifeng End
    
    
   # CONSTRUCT區塊的變數值.
   DEFINE ms_xxx01,ms_xxx02,ms_xxx03,ms_xxx04,ms_xxx05,
          ms_xxx06,ms_xxx07,ms_xxx08,ms_xxx09,ms_xxx10,
          ms_xxx11,ms_xxx12,ms_xxx13,ms_xxx14,ms_xxx15,
          ms_xxx16,ms_xxx17,ms_xxx18,ms_xxx19,ms_xxx20 STRING
   # gac_file內欄位定義相關資料的暫存器.
   DEFINE msb_col_name         base.StringBuffer
   DEFINE msb_tab_name         base.StringBuffer
   DEFINE msb_OUTER            base.StringBuffer
   DEFINE msb_ret_field_index  base.StringBuffer
   DEFINE mi_col_count LIKE type_file.num5           #No.FUN-690005 SMALLINT # 所要建立的畫面欄位數.
   # 回傳資料的相關變數.
   DEFINE mst_ret_field_index base.StringTokenizer,
          mi_ret_count  LIKE type_file.num5,           #No.FUN-690005 SMALLINT
          ms_ret1,ms_ret2,ms_ret3,ms_ret4,ms_ret5 STRING
   # 2003/09/15 by Hiko : 複選資料的回傳欄位索引值.
   DEFINE mi_multi_ret_field_index  LIKE type_file.num5           #No.FUN-690005 SMALLINT
   # 2004/09/09 第一個回傳值所屬的 table name
   DEFINE mc_first_table_name  LIKE gac_file.gac05
   # 2004/09/30 MOD-490496 by saki 若有自訂資料庫, 指定是否使用及資料庫名稱
   #DEFINE gc_ignore_db   LIKE gab_file.gab10 #FUN-980030
   #DEFINE gc_gac04       LIKE gac_file.gac04 #FUN-980030
   # 2004/10/13 MOD-440465 by saki 客製碼
   DEFINE gc_cust_flag   LIKE gab_file.gab11
   DEFINE gc_db_type     LIKE type_file.chr3   #No.FUN-690005 VARCHAR(3)           #No.TQC-650102
   DEFINE gi_qry_webdata LIKE type_file.num5   #判斷是否使用WEB區資料   #WEB-C40003
END GLOBALS   #WEB-C40003
DEFINE w ui.Window                                  #MOD-880105
DEFINE n om.DomNode                                 #MOD-880105  

 
##########################################################################
# Descriptions...: 查詢程式系統公用變數初始化.
# Input parameter: none
# Return code....: void
# Usage..........: CALL cl_init_qry_var()
# Date & Author..: 2003/07/08 by Hiko
# Modify.........: No.FUN-7B0028 07/11/12 alex 修訂註解以配合自動抓取機制
##########################################################################
 
FUNCTION cl_init_qry_var()
  INITIALIZE g_qryparam.* TO NULL
 
  LET g_qryparam.state = 'i'
  LET g_qryparam.construct = 'Y'
  LET g_qryparam.multiret_index = 1
  IF NOT cl_null(FGL_GETENV("WEBAREA")) THEN   #WEB區 #WEB-C40003
     LET g_qryparam.pagecount = 25             #WEB-C40003
  ELSE                                         #WEB-C40003
     LET g_qryparam.pagecount = 100
  END IF                                       #WEB-C40003
  LET g_qryparam.ordercons = ''
  LET g_qryparam.plant = g_plant #FUN-980030:預設g_plant
 
   #MOD-580049
  LET ms_cons_where = ""           # 暫存CONSTRUCT區塊的WHERE條件.
  LET ms_ret1 = ""
  LET ms_ret2 = ""
  LET ms_ret3 = ""
  LET ms_ret4 = ""
  LET ms_ret5 = ""
  LET mi_multi_ret_field_index = 1
  LET mc_first_table_name = ""
  #LET gc_ignore_db = "" #FUN-980030
  #LET gc_gac04 = "" #FUN-980030
  LET gc_cust_flag = ""
  LET gi_qry_webdata = FALSE   #WEB-C40003
 
  LET gc_db_type = cl_db_get_database_type()       #No.TQC-650102
 
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 在未取得 gab,gac資料前簡單檢查回傳個數 以期盡量減少程式當出
#                  情形.需注意 程式可能因此函式出現特別狀況下會/不會當出之情形
# Input parameter: none
# Return code....: SMALLINT Return時應回傳幾個值
# Usage..........: CALL cl_create_qry_failret()
# Date & Author..: 2006/01/02 by alex
# Modify.........: #TQC-610001
##########################################################################
 
FUNCTION cl_create_qry_failret()
 
  DEFINE li_i   LIKE type_file.num5           #No.FUN-690005 SMALLINT
 
  LET li_i = 1
  IF NOT cl_null(g_qryparam.default2) THEN LET li_i=2 END IF
  IF NOT cl_null(g_qryparam.default3) THEN LET li_i=3 END IF
  IF NOT cl_null(g_qryparam.default4) THEN LET li_i=4 END IF
  IF NOT cl_null(g_qryparam.default5) THEN LET li_i=5 END IF
  IF g_qryparam.state="c" OR g_qryparam.state="C" THEN LET li_i=1 END IF
 
  RETURN li_i
 
END FUNCTION
 
##########################################################################
# Descriptions...: 建立查詢程式,並回傳查詢結果.
# Input parameter: none
# Return code....: STRING 依照gac_file所定義的回傳欄位(gac10)對應的資料
# Usage..........: CALL cl_create_qry() RETURNING ....
# Date & Author..: 2003/07/08 by Hiko
##########################################################################
 
FUNCTION cl_create_qry()
  DEFINE l_construct LIKE type_file.chr1,           #No.FUN-690005 VARCHAR(1)
         l_value1,l_value2,l_value3 STRING
  DEFINE l_sql STRING,
         l_itemCount LIKE type_file.num5,           #No.FUN-690005 SMALLINT
         l_returnStr,l_orderName STRING
  DEFINE l_reconstruct STRING
  DEFINE l_err STRING
  DEFINE l_cnt LIKE type_file.num5           #No.FUN-690005 SMALLINT

 
  WHENEVER ERROR CALL cl_err_msg_log
 
  IF (cl_null(g_qryparam.form)) THEN
#    ERROR "Form name is null."
     CALL cl_err_msg(NULL,"lib-307",g_prog CLIPPED,20)
     CASE cl_create_qry_failret()     #TQC-610001
        WHEN 2 RETURN NULL,NULL
        WHEN 3 RETURN NULL,NULL,NULL
        WHEN 4 RETURN NULL,NULL,NULL,NULL
        WHEN 5 RETURN NULL,NULL,NULL,NULL,NULL
        OTHERWISE RETURN NULL
     END CASE
  END IF
 
  #2005/05/03 FUN-550021 Add By Lifeng Start 
  
  #初始化各個數組
  CALL ma_cons_lif.clear()
  CALL ma_multi_rec.clear()
  CALL g_imafldlist.clear()
  #2005/05/03 Add By Lifeng End

  ###WEB-C40003 mark START ###
  # # MOD-440465
  #SELECT COUNT(*) INTO l_cnt FROM gab_file
  # WHERE gab01=g_qryparam.form AND gab11='Y'
  #IF l_cnt > 0 THEN
  #   LET gc_cust_flag = "Y"
  #ELSE
  #   SELECT COUNT(*) INTO l_cnt FROM gab_file
  #    WHERE gab01=g_qryparam.form AND gab11='N'
  #   IF l_cnt > 0 THEN
  #      LET gc_cust_flag = "N"
  #   END IF
  #END IF
  #
  #SELECT COUNT(*) INTO mi_col_count FROM gac_file
  # WHERE gac01=g_qryparam.form AND gac02!=-1 AND gac12=gc_cust_flag
  ###WEB-C40003 mark END ###
  ###WEB-C40003 START ###
  IF NOT cl_null(FGL_GETENV("WEBAREA")) THEN   #WEB區
     LET l_sql= "SELECT COUNT(*) FROM ",s_dbstring("wds") CLIPPED,"wzb_file",
                  " WHERE wzb01='",g_qryparam.form CLIPPED,"' AND wzb11='Y'"
     PREPARE create_qry_pre FROM l_sql
     DECLARE create_qry_curs SCROLL CURSOR FOR create_qry_pre 
     OPEN create_qry_curs
     FETCH create_qry_curs INTO l_cnt
     CLOSE create_qry_curs  
     IF l_cnt > 0 THEN
        LET gc_cust_flag = "Y"
        LET gi_qry_webdata = TRUE
     ELSE
        LET l_sql= "SELECT COUNT(*) FROM ",s_dbstring("wds") CLIPPED,"wzb_file",
                     " WHERE wzb01='",g_qryparam.form CLIPPED,"' AND wzb11='N'"       
        PREPARE create_qry_pre2 FROM l_sql
        DECLARE create_qry_curs2 SCROLL CURSOR FOR create_qry_pre2 
        OPEN create_qry_curs2
        FETCH create_qry_curs2 INTO l_cnt
        CLOSE create_qry_curs2       
        IF l_cnt > 0 THEN
           LET gc_cust_flag = "N"
           LET gi_qry_webdata = TRUE
        END IF
     END IF
  END IF

  IF NOT gi_qry_webdata THEN
     LET l_sql = "SELECT COUNT(*) FROM ",s_dbstring("ds") CLIPPED,"gab_file",
                  " WHERE gab01='",g_qryparam.form CLIPPED,"' AND gab11='Y'"
     PREPARE create_qry_pre6 FROM l_sql
     DECLARE create_qry_curs6 SCROLL CURSOR FOR create_qry_pre6 
     OPEN create_qry_curs6
     FETCH create_qry_curs6 INTO l_cnt
     CLOSE create_qry_curs6
     IF l_cnt > 0 THEN
        LET gc_cust_flag = "Y"
     ELSE
         LET l_sql = "SELECT COUNT(*) FROM ",s_dbstring("ds") CLIPPED,"gab_file",
                       " WHERE gab01='",g_qryparam.form CLIPPED,"' AND gab11='N'"
         PREPARE create_qry_pre7 FROM l_sql
         DECLARE create_qry_curs7 SCROLL CURSOR FOR create_qry_pre7 
         OPEN create_qry_curs7
         FETCH create_qry_curs7 INTO l_cnt
         CLOSE create_qry_curs7
        IF l_cnt > 0 THEN
           LET gc_cust_flag = "N"
        END IF
     END IF
  END IF

  IF gi_qry_webdata THEN
     LET l_sql = "SELECT COUNT(*) FROM ",s_dbstring("wds") CLIPPED,"wzc_file",
                  " WHERE wzc01 = '",g_qryparam.form CLIPPED,"' AND wzc02 <> -1 AND wzc12 = '",gc_cust_flag CLIPPED,"'"       
     PREPARE create_qry_pre3 FROM l_sql
     DECLARE create_qry_curs3 SCROLL CURSOR FOR create_qry_pre3 
     OPEN create_qry_curs3
     FETCH create_qry_curs3 INTO mi_col_count
     CLOSE create_qry_curs3  
  ELSE
     LET l_sql = "SELECT COUNT(*) FROM ",s_dbstring("ds") CLIPPED,"gac_file",
                   " WHERE gac01='",g_qryparam.form CLIPPED,"' AND gac02<>-1 AND gac12='",gc_cust_flag CLIPPED,"'"
     PREPARE create_qry_pre8 FROM l_sql
     DECLARE create_qry_curs8 SCROLL CURSOR FOR create_qry_pre8 
     OPEN create_qry_curs8
     FETCH create_qry_curs8 INTO mi_col_count
     CLOSE create_qry_curs8
  END IF
  ###WEB-C40003 END ###
 
  IF (mi_col_count = 0) THEN
#    ERROR g_qryparam.form || " has no data."
     CALL cl_err_msg(NULL,"lib-308",g_qryparam.form CLIPPED,20)
     CASE cl_create_qry_failret()     #TQC-610001
        WHEN 2 RETURN NULL,NULL
        WHEN 3 RETURN NULL,NULL,NULL
        WHEN 4 RETURN NULL,NULL,NULL,NULL
        WHEN 5 RETURN NULL,NULL,NULL,NULL,NULL
        OTHERWISE RETURN NULL
     END CASE
  ELSE
     IF (mi_col_count > MI_MAX_COL_COUNT) THEN
        MESSAGE "The maximum columns count is 20." 
        LET mi_col_count = MI_MAX_COL_COUNT
     END IF
  END IF
 
# OPEN WINDOW w_qry AT 2,2 WITH 30 ROWS,20 COLUMNS ATTRIBUTE(STYLE="create_qry")
  # 2004/02/04 by Hiko : 因為新版runner的bug,導致動態建立Form時會出現memory fault
  #                    : 的錯誤,因此暫時建立一個實體的Form來動態建立畫面.
  IF NOT cl_null(FGL_GETENV("WEBAREA")) THEN   #WEB區   #WEB-C40003
     OPEN WINDOW w_qry WITH FORM "wlib/42f/cl_web_create_qry"   #WEB-C40003
        ATTRIBUTE(STYLE="ontop")                                #WEB-C40003
  ELSE                                                          #WEB-C40003
     OPEN WINDOW w_qry WITH FORM "lib/42f/dummy_form"
          ATTRIBUTE (STYLE="create_qry")
  END IF                                                        #WEB-C40003

  IF STATUS THEN   #FUN-580087
     ###WEB-C40003 START ###
     IF NOT cl_null(FGL_GETENV("WEBAREA")) THEN   #WEB區
        LET l_err="Error: Open Window about cl_create_qry \n",
                  "\t(cl_web_create_qry.42f) error! \n",
                  "\tConnect to system administrators! "
     ELSE
     ###WEB-C40003 END ###
        LET l_err="Error: Open Window about cl_create_qry \n",
                  "\t(dummy_form.42f) error! \n",
                  "\tConnect to system administrators! "
     END IF                                                     #WEB-C40003
     CALL cl_err(l_err,"!",1)
     DISPLAY l_err
     CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B70007  
     EXIT PROGRAM
  END IF
  
  CALL cl_qry_prep_create_info()

  # 2003/07/08 by Hiko : 判斷回傳的欄位個數是否不正確.
  IF ((mi_ret_count = 0) OR (mi_ret_count > 5)) THEN
#    RETURN "Returning column count is between 1 To 5"
     CALL cl_err_msg(NULL,"lib-309",g_qryparam.form CLIPPED,20)
     CASE cl_create_qry_failret()     #TQC-610001
        WHEN 2 RETURN NULL,NULL
        WHEN 3 RETURN NULL,NULL,NULL
        WHEN 4 RETURN NULL,NULL,NULL,NULL
        WHEN 5 RETURN NULL,NULL,NULL,NULL,NULL
        OTHERWISE RETURN NULL
     END CASE
  END IF
 
  # 2003/11/13 by Hiko : 此段程式是為了抓取複選資料時的回傳欄位索引值.
  IF (g_qryparam.state = 'c') THEN
     IF (g_qryparam.multiret_index > mst_ret_field_index.countTokens()) THEN
        LET g_qryparam.multiret_index = mst_ret_field_index.countTokens()
     END IF
 
     CASE g_qryparam.multiret_index
        WHEN 1
           LET mi_multi_ret_field_index = mst_ret_field_index.nextToken()
        WHEN 2 
           LET mi_multi_ret_field_index = mst_ret_field_index.nextToken()
           LET mi_multi_ret_field_index = mst_ret_field_index.nextToken()
        WHEN 3
           LET mi_multi_ret_field_index = mst_ret_field_index.nextToken()
           LET mi_multi_ret_field_index = mst_ret_field_index.nextToken()
           LET mi_multi_ret_field_index = mst_ret_field_index.nextToken()
        WHEN 4
           LET mi_multi_ret_field_index = mst_ret_field_index.nextToken()
           LET mi_multi_ret_field_index = mst_ret_field_index.nextToken()
           LET mi_multi_ret_field_index = mst_ret_field_index.nextToken()
           LET mi_multi_ret_field_index = mst_ret_field_index.nextToken()
        WHEN 5
           LET mi_multi_ret_field_index = mst_ret_field_index.nextToken()
           LET mi_multi_ret_field_index = mst_ret_field_index.nextToken()
           LET mi_multi_ret_field_index = mst_ret_field_index.nextToken()
           LET mi_multi_ret_field_index = mst_ret_field_index.nextToken()
           LET mi_multi_ret_field_index = mst_ret_field_index.nextToken()
     END CASE
  END IF
 
  CALL cl_qry_create_ui()
 
  CALL cl_qry_sel()
 
  CLOSE WINDOW w_qry
 
  # 2003/07/08 by Hiko : 如果是CONSTRUCT狀態,則只需回傳第一個欄位.
  IF (g_qryparam.state = 'c') THEN
    LET ms_ret2 = NULL
    LET ms_ret3 = NULL
    LET ms_ret4 = NULL     #2005/05/02 add by Lifeng , 可能是忘寫了給它補上
    LET ms_ret5 = NULL     #2005/05/02 add by Lifeng , 同上
    RETURN ms_ret1
  ELSE
    CASE mi_ret_count
      WHEN 1 RETURN ms_ret1
      WHEN 2 RETURN ms_ret1,ms_ret2
      WHEN 3 RETURN ms_ret1,ms_ret2,ms_ret3
      WHEN 4 RETURN ms_ret1,ms_ret2,ms_ret3,ms_ret4
      WHEN 5 RETURN ms_ret1,ms_ret2,ms_ret3,ms_ret4,ms_ret5
    END CASE
  END IF
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 轉換DATE type
# Input parameter: none
# Return code....: STRING    Date Format
# Usage..........: CALL cl_qry_datetype() RETURNING ls_datetype
# Date & Author..: 2006/02/23 By alex 
##########################################################################
 
FUNCTION cl_qry_datetype()  #TQC-620117
 
   DEFINE lc_date   LIKE type_file.chr4           #No.FUN-690005 VARCHAR(4)
   DEFINE ls_date   STRING
   DEFINE li_i      LIKE type_file.num5           #No.FUN-690005 SMALLINT
 
   CALL fgl_getenv("DBDATE") RETURNING lc_date
   LET lc_date = DOWNSHIFT(lc_date)
   LET ls_date=""
 
   FOR li_i = 1 TO 3 STEP 2
      CASE lc_date[li_i,li_i+1]
         WHEN "y2" LET ls_date=ls_date.trim(),"yy/"
         WHEN "y4" LET ls_date=ls_date.trim(),"yyyy/"
         WHEN "md" LET ls_date=ls_date.trim(),"mm/dd/"
         WHEN "dm" LET ls_date=ls_date.trim(),"dd/mm/"
      END CASE
   END FOR
   RETURN ls_date.subString(1,ls_date.getLength()-1)
 
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 準備建立畫面所需的資料.
# Input parameter: none
# Return code....: void
# Usage..........: CALL cl_qry_prep_create_info()
# Date & Author..: 2003/07/08 by Hiko
##########################################################################
 
FUNCTION cl_qry_prep_create_info()
  DEFINE lr_gac RECORD                  # LIKE gac_file.*
          gac01  LIKE gac_file.gac01,   # 查詢資料的暫存器.
          gac02  LIKE gac_file.gac02,
          gae04  LIKE gae_file.gae04,   # 2004/03/08 串接用不得不加
          #gac04  LIKE gac_file.gac04,  #FUN-980030
          gac05  LIKE gac_file.gac05,
          gac06  LIKE gac_file.gac06,
          gac07  LIKE gac_file.gac07,   # 2004/03/22 新增
          gac09  LIKE gac_file.gac09,
          gac10  LIKE gac_file.gac10,
          gac11  LIKE gac_file.gac11,
          gac12  LIKE gac_file.gac12,
          gac13  LIKE gac_file.gac13    # 2005/02/23 型態遮罩
                END RECORD
  DEFINE li_i LIKE type_file.num5,           #No.FUN-690005 SMALLINT
         ls_col_name,ls_table_name STRING
# DEFINE lc_gac04                  LIKE gac_file.gac04 #FUN-980030
# DEFINE lc_ignore_db              LIKE gab_file.gab10 #FUN-980030
 
  DEFINE li_ia LIKE type_file.num5           #No.FUN-690005 SMALLINT    #2005/05/03 FUN-550021 Add By Lifeng
  DEFINE li_ib LIKE type_file.num5           #No.FUN-690005 SMALLINT    #2005/05/03 FUN-550021 Add By Lifeng , 用於記錄幾個料件欄位分別的位置信息
                           #           可以和ma_multi_rec中的下標一一對應
 
  DEFINE ls_datetype STRING    #TQC-620117
  DEFINE l_target_db LIKE azw_file.azw05 #FUN-980030 
  DEFINE l_plant     LIKE type_file.chr10    #WEB-C40003
  DEFINE l_sql_1     STRING                  #WEB-C40003
  DEFINE l_sql_2     STRING                  #WEB-C40003
 
  LET msb_col_name = base.StringBuffer.create()
  LET msb_tab_name = base.StringBuffer.create()
  LET msb_OUTER = base.StringBuffer.create()
  LET msb_ret_field_index = base.StringBuffer.create()
 
  #BEGIN:FUN-980030
  ## 2004/05/10 by hjwang:是否忽略db要求
  #SELECT gab10 INTO gc_ignore_db FROM gab_file
  #  WHERE gab01=g_qryparam.form AND gab11=gc_cust_flag         # MOD-440465
  #IF cl_null(gc_ignore_db) THEN
  #   LET gc_ignore_db="Y"
  #END IF
  #END:FUN-980030

  ###WEB-C40003 mark START ###
  #DECLARE lcurs_gac CURSOR FOR
  # SELECT gac01,gac02,gae04,gac05,gac06,gac07,gac09,gac10,gac11,'',gac13 #FUN-980030:移除gac04
  #   FROM gac_file LEFT JOIN gae_file
  #  ON gae_file.gae01=gac_file.gac01 AND gae_file.gae02=gac_file.gac06
  #    AND gae_file.gae03=g_lang AND gae_file.gae11=gc_cust_flag
  #    AND gae_file.gae12=g_sma.sma124           #No.MOD-780270 add
  #    WHERE gac_file.gac01=g_qryparam.form AND gac_file.gac02 != -1
  #    AND gac_file.gac12=gc_cust_flag
  #  ORDER BY gac02
  ###WEB-C40003 mark END ###
  ###WEB-C40003 START ###
  IF gi_qry_webdata THEN
      LET l_sql_1 = "SELECT wzc01,wzc02,wzf04,wzc05,wzc06,wzc07,",
                  "       wzc09,wzc10,wzc11,'',wzc13 ",
                  "  FROM ",s_dbstring("wds") CLIPPED,"wzc_file LEFT JOIN ",s_dbstring("wds") CLIPPED,"wzf_file",
                  " ON wzf_file.wzf01 = wzc01",
                     " AND wzf_file.wzf02 = wzc06",
                     " AND wzf_file.wzf03 = ?",
                     "   AND wzf_file.wzf05 = ?",
                  " WHERE wzc_file.wzc01 = '",g_qryparam.form CLIPPED,"'",
                  "   AND wzc_file.wzc02 <> -1 ",
                  "   AND wzc_file.wzc12 = ?",
                  " ORDER BY wzc02"
      LET l_sql_2 = "SELECT wzc04 FROM ",s_dbstring("wds") CLIPPED,"wzc_file",
                   " WHERE wzc_file.wzc01 = '",g_qryparam.form CLIPPED,"'",
                   "   AND wzc_file.wzc02 = ?",
                   "   AND wzc_file.wzc12 = '",gc_cust_flag CLIPPED,"'"
      PREPARE cl_qry_prep_create_info_plant_pre FROM l_sql_2
  ELSE
      LET l_sql_1 = "SELECT gac01,gac02,gae04,gac05,gac06,gac07,",
                        " gac09,gac10,gac11,'',gac13",
                  " FROM ",s_dbstring("ds") CLIPPED,"gac_file LEFT JOIN ",s_dbstring("ds") CLIPPED,"gae_file",
                  " ON gae_file.gae01=gac_file.gac01", #畫面檔代碼
                     " AND gae_file.gae02=gac_file.gac06", #欄位代碼
                     " AND gae_file.gae03=?", #語言別
                     " AND gae_file.gae11=?", #客製碼
                     " AND gae_file.gae12='",g_sma.sma124 CLIPPED,"'", #行業別
                  " WHERE gac_file.gac01='",g_qryparam.form CLIPPED,"'",
                    " AND gac_file.gac02 <> -1",
                    " AND gac_file.gac12=?",
                    " ORDER BY gac02"
  END IF
  PREPARE gac_pre FROM l_sql_1
  DECLARE lcurs_gac CURSOR FOR gac_pre
  ###WEB-C40003 END ###
  LET li_i = 1
 
  LET li_ib = 1  #2005/05/03 FUN-550021 Add By Lifeng
 
  #FOREACH lcurs_gac INTO lr_gac.*  #WEB-C40003 mark
  FOREACH lcurs_gac USING g_lang,gc_cust_flag,gc_cust_flag INTO lr_gac.*   #WEB-C40003
      ###WEB-C40003 START ###
      IF gi_qry_webdata THEN
         EXECUTE cl_qry_prep_create_info_plant_pre USING lr_gac.gac02 INTO l_plant
         IF l_plant != "now" THEN
            LET g_qryparam.plant = l_plant
         END IF
      END IF
      ###WEB-C40003 END ###
      
      LET ls_col_name = lr_gac.gac06 CLIPPED
 
      #MOD-540046 Referance Form Cori@ShinChu.
      IF lr_gac.gac07="2" AND gc_db_type = "ORA" THEN      #TQC-620117  #No.TQC-650102
#        LET ls_col_name="to_char(",lr_gac.gac06 CLIPPED,",'dd/mm/yy') " ,lr_gac.gac06 CLIPPED  
         CALL cl_qry_datetype() RETURNING ls_datetype  #TQC-620117
         LET ls_col_name="to_char(",lr_gac.gac06 CLIPPED,",'",ls_datetype.trim(),"') " 
       ELSE
         LET ls_col_name = lr_gac.gac06 CLIPPED
      END IF
  
      IF (msb_col_name.getLength() = 0) THEN
         CALL msb_col_name.append(ls_col_name)
      ELSE
         CALL msb_col_name.append("," || ls_col_name)
      END IF
 
      #2005/05/03 FUN-550021 Add By Lifeng Start
      #對從gac_file中取出的欄位信息進行判斷，如果該欄位是表示料件編號的欄位
      #增加g_imafldcount的計數，其最大值為3，即同一個開窗中最多只能同時出現三組料件編號欄位
      #同時要修改SELECT列名，增加21個空白列（即用來擺這些輔助欄位的）
      IF ( g_sma.sma120 = 'Y' )AND( cl_is_itemno(ls_col_name)=TRUE )AND
         cl_null(FGL_GETENV("WEBAREA")) AND   #非WEB區  #WEB-C40003
         ( g_imafldlist.getLength() < MI_MAX_ITEMNO_COUNT ) THEN
         #將當前記錄的欄位數量+1
         CALL g_imafldlist.appendElement()
         LET g_imafldlist[g_imafldlist.getLength()] = li_ib
         
         #向msb_colname中增加21個空格欄位
         FOR li_ia = 1 TO 21
             CALL msb_col_name.append(",' '")
             LET li_ib = li_ib + 1   #為了與ma_multi_rec中的下標對齊，這裡也要一起遞增
         END FOR
      END IF
      
      LET li_ib = li_ib + 1
      #2005/05/03 Add By Lifeng End
 
      #BEGIN:FUN-980030:已經移除gab10與gac04
      #     # 2004/05/10 by hjwang:是否忽略db要求
      #     IF gc_ignore_db="N" THEN
      #        # 2004/05/06 允許 user 在 db 處傳 arg0-9, 若傳了就先變
      #        IF lr_gac.gac04[1,3] = "arg" THEN
      #           CASE lr_gac.gac04
      #              WHEN "arg1" LET gc_gac04 = g_qryparam.arg1
      #              WHEN "arg2" LET gc_gac04 = g_qryparam.arg2
      #              WHEN "arg3" LET gc_gac04 = g_qryparam.arg3
      #              WHEN "arg4" LET gc_gac04 = g_qryparam.arg4
      #              WHEN "arg5" LET gc_gac04 = g_qryparam.arg5
      #              WHEN "arg6" LET gc_gac04 = g_qryparam.arg6
      #              WHEN "arg7" LET gc_gac04 = g_qryparam.arg7
      #              WHEN "arg8" LET gc_gac04 = g_qryparam.arg8
      #              WHEN "arg9" LET gc_gac04 = g_qryparam.arg9
      #           END CASE
      ##          SELECT gzy03 FROM gzy_file WHERE gzy03=gc_gac04
      #           SELECT azp03 FROM azp_file WHERE azp03=gc_gac04       #MOD-490496 by saki
      #           IF STATUS THEN
      #             #LET gc_gac04="ds"    #MOD-930179 mark
      #              LET gc_gac04=g_dbs   #MOD-930179
      #           END IF
      #        ELSE
      #           LET gc_gac04 = lr_gac.gac04 CLIPPED
      #        END IF
      #
      ###FUN-750079 head
      ##TQC-950048 MARK&ADD START-------------------------------------------------  
      ##CASE cl_db_get_database_type() 
      ##   WHEN "ORA" 
      ##      LET ls_table_name = gc_gac04 CLIPPED,".",lr_gac.gac05 CLIPPED
      ##   WHEN "IFX"
      ##      LET ls_table_name = gc_gac04 CLIPPED,":",lr_gac.gac05 CLIPPED
      ##   WHEN "MSV"
      ##      LET ls_table_name = gc_gac04 CLIPPED,".dbo.",lr_gac.gac05 CLIPPED
      ##END CASE
      #        LET ls_table_name = s_dbstring(gc_gac04),lr_gac.gac05 CLIPPED  #add                                                        
      ##TQC-950048 END-----------------------------------------------------------   
      ###FUN-750079 #MOD-770064 tail
      #     ELSE
      #        LET ls_table_name = lr_gac.gac05 CLIPPED
      #     END IF
      #END:FUN-980030

      IF g_qryparam.plant = "wds" THEN                               #WEB-C40003
          LET ls_table_name = s_dbstring("wds"),lr_gac.gac05 CLIPPED #WEB-C40003
      ELSE                                                           #WEB-C40003
         #BEGIN:FUN-980030
         IF g_qryparam.plant != g_plant THEN
            #跨Plant時,要取得實際上的DB.
            LET ls_table_name = cl_get_target_table(g_qryparam.plant, lr_gac.gac05)
         ELSE
            LET ls_table_name = lr_gac.gac05 CLIPPED
         END IF
         #END:FUN-980030
      END IF                                                         #WEB-C40003

      IF (NOT ls_table_name.equalsIgnoreCase("formonly")) THEN
         # 2003/07/09 by Hiko : 判斷欄位所對應的Table是否需要OUTER.
         IF (lr_gac.gac11 = 'Y') THEN
            IF (msb_OUTER.getIndexOf(ls_table_name, 1) = 0) THEN
               CALL msb_OUTER.append(", OUTER " || ls_table_name)
            END IF
         ELSE
            # 2003/07/09 by Hiko : 判斷欄位所對應的Table是否已存在於暫存器內.
            IF (msb_tab_name.getIndexOf(ls_table_name, 1) = 0) THEN
               IF (msb_tab_name.getLength() = 0) THEN
                  CALL msb_tab_name.append(ls_table_name)
               ELSE
                  CALL msb_tab_name.append("," || ls_table_name)
               END IF
            END IF
         END IF
      END IF
  
      # 2003/07/09 by Hiko : 判斷此欄位是否需要回傳.
      IF (lr_gac.gac10 = 'Y') THEN
         IF (msb_ret_field_index.getLength() = 0) THEN
            CALL msb_ret_field_index.append(li_i)
            LET mc_first_table_name=lr_gac.gac05
         ELSE
            CALL msb_ret_field_index.append("," || li_i)
         END IF
      END IF
  
      LET ma_gac[li_i].* = lr_gac.*
      LET li_i = li_i + 1
  END FOREACH
 
  LET mst_ret_field_index = base.StringTokenizer.create(msb_ret_field_index.toString(), ",")
  LET mi_ret_count = mst_ret_field_index.countTokens()
END FUNCTION
 
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 建立查詢程式畫面.
# Input parameter: none
# Return code....: void
# Usage..........: CALL cl_qry_create_ui()
# Date & Author..: 2003/07/08 by Hiko
##########################################################################
FUNCTION cl_qry_create_ui()
  DEFINE lwin_curr   ui.Window,
         lfrm_curr   ui.Form,
         lnode_frm   om.DomNode,
         lnode_win   om.DomNode,
         lc_gae04    LIKE gae_file.gae04,
         ls_title    STRING
  DEFINE lc_gat03    LIKE gat_file.gat03
  DEFINE lc_ze03     LIKE ze_file.ze03
  DEFINE l_sql       STRING               #WEB-C40003
 
  LET lwin_curr = ui.Window.getCurrent()
  #CALL lwin_curr.setAttribute("Width", 150)
  # 2004/02/04 by Hiko : 因為已經存在實體的Form,因此這裡就不需建立.
# LET lnode_win = lwin_curr.getNode()
# LET lnode_frm = lnode_win.createChild("Form")
  LET lfrm_curr = lwin_curr.getForm()
  LET lnode_frm = lfrm_curr.getNode()
  CALL lnode_frm.setAttribute("name", g_qryparam.form CLIPPED)
  CALL lnode_frm.setAttribute("style", "dialog")

  ###WEB-C40003 START ###
  IF NOT cl_null(FGL_GETENV("WEBAREA")) THEN   #WEB區
     # 匯入開窗ToolBar
     CALL lfrm_curr.loadToolBar(FGL_GETENV("WTOPCONFIG")||"/4tb/toolbar_q.4tb")
  END IF

  IF gi_qry_webdata THEN
     LET l_sql = "SELECT wzf04 FROM ",s_dbstring("wds") CLIPPED,"wzf_file",
                   " WHERE wzf01 = '",g_qryparam.form CLIPPED,"' AND wzf02 = 'wintitle'",
                     " AND wzf03 = '",g_lang CLIPPED,"' AND wzf05 = '",gc_cust_flag CLIPPED,"'"
     PREPARE create_qry_pre4 FROM l_sql
     DECLARE create_qry_curs4 SCROLL CURSOR FOR create_qry_pre4 
     OPEN create_qry_curs4
     FETCH create_qry_curs4 INTO lc_gae04
     CLOSE create_qry_curs4
  END IF
  
  IF cl_null(lc_gae04) THEN
     LET l_sql = "SELECT gae04 FROM ",s_dbstring("ds") CLIPPED,"gae_file",
                 " WHERE gae01= '",g_qryparam.form CLIPPED,"' AND gae02= 'wintitle'",
                   " AND gae03= '",g_lang CLIPPED,"' AND gae11= '",gc_cust_flag CLIPPED,"'"
     PREPARE create_qry_pre9 FROM l_sql
     DECLARE create_qry_curs9 SCROLL CURSOR FOR create_qry_pre9 
     OPEN create_qry_curs9
     FETCH create_qry_curs9 INTO lc_gae04
     CLOSE create_qry_curs9
  END IF
  ###WEB-C40003 END ###
  ###WEB-C40003 mark START ###
  # 2004/03/08 變更至 gae_file
  #SELECT gae04 INTO lc_gae04 FROM gae_file 
  # WHERE gae01= g_qryparam.form
  #   AND gae02= 'wintitle'
  #   AND gae03= g_lang
  #   AND gae11= gc_cust_flag
  ###WEB-C40003 mark END ###
  
  # 2004/09/09 如果查不到的話, 拿 lib-213+gat 來做墊背
  #IF SQLCA.SQLCODE THEN     #WEB-C40003 mark
  IF cl_null(lc_gae04) THEN  #WEB-C40003
     SELECT gat03 INTO lc_gat03
       FROM gat_file
      WHERE gat01=mc_first_table_name AND gat02=g_lang
     SELECT ze03 INTO lc_ze03
       FROM ze_file
      WHERE ze01="lib-213" AND ze02=g_lang
     LET ls_title = lc_ze03 CLIPPED, " ",lc_gat03 CLIPPED
  ELSE
     LET ls_title = lc_gae04 CLIPPED
  END IF
# CALL lnode_frm.setAttribute("text", ls_title.trim())
  LET ls_title = ls_title.trim(),"(",g_qryparam.form,")"   #FUN-B10055
  CALL lwin_curr.setText(ls_title.trim())

  IF NOT cl_null(FGL_GETENV("WEBAREA")) THEN   #WEB區   #WEB-C40003
     CALL cl_web_qry_build_table(lnode_frm)    #WEB-C40003
  ELSE                                         #WEB-C40003
     CALL cl_qry_build_table(lnode_frm)      
  END IF                                       #WEB-C40003
  
  # 2004/02/04 by Hiko : 不需建立RecordView節點也可以建立畫面.
 #CALL cl_qry_build_rec_view(lnode_frm)
 
  #CALL lnode_frm.writeXml("@cl_create_qry.xml")
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 建立<Table>節點.
# Input parameter: pnode_frm om.DomNode <Form>節點
# Return code....: void
# Usage..........: CALL cl_qry_build_table(lnode_frm)
# Date & Author..: 2003/07/08 by Hiko
##########################################################################
 
FUNCTION cl_qry_build_table(pnode_frm)
  DEFINE pnode_frm     om.DomNode
  DEFINE lnode_grid    om.DomNode
  DEFINE lnode_table   om.DomNode
  DEFINE lnode_column  om.DomNode
  DEFINE lnode_edit    om.DomNode
  DEFINE lnode_chk     om.DomNode
  DEFINE ls_header     STRING,
         li_i          LIKE type_file.num5,           #No.FUN-690005 SMALLINT
         li_col_width  LIKE type_file.num5,           #No.FUN-690005 SMALLINT
         li_width      LIKE type_file.num5,           #No.FUN-690005 SMALLINT
         lc_col_index  LIKE type_file.chr2            #No.FUN-690005 VARCHAR(2)
  DEFINE lnode_parent  om.DomNode
  DEFINE lwin_curr     ui.Window
  DEFINE lfrm_curr     ui.Form
  DEFINE lc_ze01       LIKE ze_file.ze01
  DEFINE lc_ze03       LIKE ze_file.ze03
  DEFINE ls_type_name  LIKE type_file.chr1000        #No.FUN-690005 VARCHAR(106)
  DEFINE ls_values     STRING,
         ls_items      STRING
         
  #2005/05/03 FUN-550021 Add By Lifeng Start
  DEFINE li_lif        LIKE type_file.num5,           #No.FUN-690005 SMALLINT
         li_ia,li_ib   LIKE type_file.num5,           #No.FUN-690005 SMALLINT
         li_ic,li_id   LIKE type_file.num5           #No.FUN-690005 SMALLINT
  DEFINE lc_ib,lc_ic   LIKE type_file.chr2,           #No.FUN-690005 VARCHAR(2)
         lc_ia,lc_id   LIKE type_file.chr2,           #No.FUN-690005 VARCHAR(2)
         li_ie         LIKE type_file.num5            #No.FUN-690005 SMALLINT
  DEFINE lc_colname    LIKE ze_file.ze03
  DEFINE lc_display_field STRING
  DEFINE ls_tabIndex   STRING                         #No.FUN-710055
  DEFINE li_tabIndex   LIKE type_file.num5            #No.CHI-8B0054
  #2005/05/03 Add By Lifeng End
  DEFINE l_sch03       LIKE sch_file.sch03            #No.FUN-AC0036
 
  LET lwin_curr = ui.Window.getCurrent()
  LET lfrm_curr = lwin_curr.getForm()
  LET lnode_grid = pnode_frm.createChild("Grid")
  LET lnode_table = lnode_grid.createChild("Table")
  CALL lnode_table.setAttribute("tabName", "s_xxx")
  CALL lnode_table.setAttribute("height", 20)
  CALL lnode_table.setAttribute("pageSize", 20)
  CALL lnode_table.setAttribute('name','s_xxx')  #2005/05/03 FUN-550021 Add By Lifeng
 
  # 2004/02/20 by saki : select欄位也要多語言
  SELECT ze03 INTO lc_ze03 FROM ze_file
   WHERE ze01 = 'lib-018' AND ze02 = g_lang
 
  #2005/05/03 FUN-550021 Add By Lifeng Start
  IF g_sma.sma120 = 'Y' THEN
     #顯示欄位的名稱也要從ze_file中取，區分語言別
     SELECT ze03 INTO lc_colname FROM ze_file
       WHERE ze01 = 'lib-233' and ze02 = g_lang
  END IF
  #2005/05/03 Add by Lifeng End
 
  LET lnode_column = lnode_table.createChild("TableColumn")
  CALL lnode_column.setAttribute("text", lc_ze03)
  CALL lnode_column.setAttribute("colName", "check")
  CALL lnode_column.setAttribute("fieldId", "0")
  CALL lnode_column.setAttribute("sqlTabName", "formonly")
  CALL lnode_column.setAttribute('name','check')  #2005/05/03 FUN-550021 Add By Lifeng
  CALL lnode_column.setAttribute("tabIndex","1")  #No.FUN-710055
  # 2003/07/08 by Hiko : 因為CheckBox還無法hidden,所以先以Edit代替,才有辦法hidden.
  IF (g_qryparam.state = 'i') THEN
     LET lnode_edit = lnode_column.createChild("Edit")
     # 2004/02/09 by saki : 用form的元件隱藏checkbox,避免以後attribute(hidden)會改變
     CALL lfrm_curr.setFieldHidden("check",1)
#    CALL lnode_column.setAttribute("hidden",1)
#    CALL lnode_column.setAttribute("unhidable","1")
  ELSE
     CALL lnode_column.setAttribute("notNull", "1")
     CALL lnode_column.setAttribute("required", "1")
     LET lnode_chk = lnode_column.createChild("CheckBox")
     # 2003/07/08 by Hiko : 一定要設寬度,要不然在選擇的時候會有錯誤.
     CALL lnode_chk.setAttribute("width", "3")
     CALL lnode_chk.setAttribute("valueChecked", "Y")
     CALL lnode_chk.setAttribute("valueUnchecked", "N")
  END IF
 
  LET li_ib = 1             #2005/05/03 FUN-550021 Add By Lifeng
  LET li_ic = 0             #2005/05/03 FUN-550021 Add By Lifeng
  LET li_tabIndex = 1       #No.CHI-8B0054
 
  FOR li_i = 1 TO mi_col_count
     LET lnode_column = lnode_table.createChild("TableColumn")
     #No.CHI-8B0054 --start--
#    LET ls_tabIndex = li_i+1
     LET li_tabIndex = li_tabIndex + 1
     LET ls_tabIndex = li_tabIndex
     #No.CHI-8B0054 ---end---
     LET ls_tabIndex = ls_tabIndex.trim()
     CALL lnode_column.setAttribute("tabIndex",ls_tabIndex)      #No.FUN-710055
  
     # 2004/03/08 修改 gac_file 架構, 若 gae04 中有定義欄位多語言轉換,
     #            則使用, 若未定義則抓取 gaq_file 中的對照使用
     IF cl_null(ma_gac[li_i].gae04) THEN
        SELECT gaq03 INTO ma_gac[li_i].gae04 FROM gaq_file
         WHERE gaq01=ma_gac[li_i].gac06 AND gaq02=g_lang
     END IF
     LET ls_header = ma_gac[li_i].gae04 CLIPPED
  
     LET li_col_width = ma_gac[li_i].gac09

     #---FUN-AC0036---start-----
     #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
     #目前統一用sch_file紀錄TIPTOP資料結構,因此改用lib Function取得是否為日期格式
     ## 2004/05/13 by saki : 判斷此欄位在資料庫中是否為日期格式, ora必須轉換格式
     ##                      才搜尋的到
     #SELECT DATA_TYPE INTO ls_type_name FROM user_tab_columns
     # WHERE TABLE_NAME  = upper(ma_gac[li_i].gac05)
     #   AND COLUMN_NAME = upper(ma_gac[li_i].gac06)
     SELECT sch03 INTO l_sch03 FROM sch_file
       WHERE sch01 = ma_gac[li_i].gac05 AND sch02 = ma_gac[li_i].gac06
     LET ls_type_name = UPSHIFT(cl_get_column_datatype(l_sch03))
     #---FUN-AC0036---end-------
 
     # 2003/07/08 by Hiko : 判斷Table Header是否比欄位寬度還大.
     IF (ls_header.getLength() > li_col_width) THEN
        LET li_col_width = ls_header.getLength()
     END IF
  
      # 2005/02/24 MOD-4C0118
#    IF (li_col_width > MI_MAX_COL_WIDTH) THEN
#       LET li_col_width = MI_MAX_COL_WIDTH
#    END IF
  
     LET lc_col_index = li_i USING '&&'
     CALL lnode_column.setAttribute("colName", "xxx" || lc_col_index)
     CALL lnode_column.setAttribute("text", ls_header)
     CALL lnode_column.setAttribute("fieldId", li_i)
     CALL lnode_column.setAttribute("sqlTabName", ma_gac[li_i].gac05 CLIPPED)
     CALL lnode_column.setAttribute('name','xxx'||lc_col_index)  #2005/05/03 FUN-550021 Add By Lifeng
     # 2003/07/09 by Hiko : 將CheckBox以外的欄位都設定成NOENTRY.
     CALL lnode_column.setAttribute("noEntry", "1")
     CALL lnode_column.setAttribute("tag",ma_gac[li_i].gac06 CLIPPED)   #No.FUN-760072
 
     # 2004/03/22 新增欄位使用形態 (0:Edit/1:CheckBox/2:DateEdit/3:ComboBox)
     CASE ma_gac[li_i].gac07
        WHEN "0" 
           LET lnode_edit = lnode_column.createChild("Edit")
        WHEN "1" 
           LET lnode_edit = lnode_column.createChild("CheckBox")
           CALL lnode_edit.setAttribute("valueChecked","Y")
           CALL lnode_edit.setAttribute("valueUnchecked","N")
        WHEN "2" 
           LET lnode_edit = lnode_column.createChild("Edit")  #TQC-620117
#          LET lnode_edit = lnode_column.createChild("DateEdit")
         WHEN "3"  # MOD-470106 增加可以設定 ComboBox
           LET lnode_edit = lnode_column.createChild("ComboBox")
           LET ls_values = ma_gac[li_i].gac13
           LET ls_values = ls_values.trim()
           LET ls_items = ls_values.subString(1,ls_values.getIndexOf("||",1)-1)
           LET ls_values = ls_values.subString(ls_values.getIndexOf("||",1)+2,ls_values.getLength())
           LET lc_ze03=""  LET ls_items=ls_items.trim() LET ls_values=ls_values.trim()
           LET lc_ze01=ls_values.trim()
           SELECT ze03 INTO lc_ze03 FROM ze_file WHERE ze01=lc_ze01 AND ze02=g_lang
           IF NOT cl_null(lc_ze03) THEN LET ls_values=lc_ze03 CLIPPED END IF
           LET lc_ze01=ls_items.trim()
           SELECT ze03 INTO lc_ze03 FROM ze_file WHERE ze01=lc_ze01 AND ze02=g_lang
           IF NOT cl_null(lc_ze03) THEN LET ls_items=lc_ze03 CLIPPED END IF
           CALL cl_set_combo_items("xxx" || lc_col_index,ls_values,ls_items)
        OTHERWISE 
           LET lnode_edit = lnode_column.createChild("Edit")
     END CASE
     CALL lnode_edit.setAttribute("width", li_col_width)
 
     # 2004/05/13 by saki : 若type為DATE則給format
     IF ls_type_name = "DATE" THEN
        CALL lnode_edit.setAttribute("format","yy/mm/dd")
     END IF
     ##
 
     IF (g_qryparam.state = 'c') THEN
        IF (li_i = mi_multi_ret_field_index) THEN
           CALL lnode_edit.setAttribute("color", "red")
        END IF
     END IF
 
     LET li_width = li_width + li_col_width
 
     #2005/05/03 FUN-550021 Add By Lifeng Start
     #填充剛剛創建的節點的控制信息
     LET li_ic = li_ic + 1
     LET lc_ic = li_ic USING '&&'
     LET ma_multi_rec[li_ic].index = li_ic
     LET ma_multi_rec[li_ic].object = lnode_column
     LET ma_multi_rec[li_ic].colname = 'xxx' || lc_col_index
     LET ma_multi_rec[li_ic].dbfield = ma_gac[li_i].gac06 CLIPPED
     LET ma_multi_rec[li_ic].dbtype = ls_type_name
     LET ma_multi_rec[li_ic].visible = TRUE
     #判斷一下當前創建的這個節點是否為料件編號節點，如果是，則在其后默認創建1個
     #只讀的顯示欄位和10個明細屬性欄位，這些欄位的初始狀態都是隱藏的
     LET ma_multi_rec[li_ic].imafld = 'N'
     FOR li_ie = 1 TO g_imafldlist.getLength() 
         IF g_imafldlist[li_ie] = li_ic THEN
            LET ma_multi_rec[li_ic].imafld = 'Y'
            EXIT FOR
         END IF
     END FOR
 
     IF ( g_sma.sma120 = 'Y' )AND( ma_multi_rec[li_ic].imafld = 'Y' ) THEN
        #新創建的欄位以'ttt'開頭，以和標准的'sss'欄位相區別
       
        #創建只顯示欄位
        LET lc_ib = li_ib USING '&&'
        LET lnode_column = lnode_table.createChild('TableColumn')
        CALL lnode_column.setAttribute('colName','ttt'||lc_ib)
        CALL lnode_column.setAttribute('name','ttt'||lc_ib)
        CALL lnode_column.setAttribute('fieldId',20+li_ib)
        CALL lnode_column.setAttribute('noEntry','1')   
        CALL lnode_column.setAttribute('text',lc_colname)
        CALL lnode_column.setAttribute('sqlTabName','formonly')
        #No.CHI-8B0054 --start--
        LET li_tabIndex = li_tabIndex + 1
        LET ls_tabIndex = li_tabIndex
        LET ls_tabIndex = ls_tabIndex.trim()
        #No.CHI-8B0054 ---end---
        CALL lnode_column.setAttribute("tabIndex",ls_tabIndex)   #No.FUN-710055
        LET lnode_edit = lnode_column.createChild('Edit')
        CALL lnode_edit.setAttribute('width',10)    
        CALL lfrm_curr.setFieldHidden('ttt'||lc_ib,1) 
        
        #設置前一個'x'欄位的dispfld信息(就是當前欄位的名稱)
        LET ma_multi_rec[li_ic].dispfld = 'ttt'|| lc_ib
 
        #得到t欄位的datatype，因為所有t欄位的type都相同，所以只需要
        #得到imx_file.imx01的類型就可以了
        SELECT DATA_TYPE INTO ls_type_name FROM user_tab_columns
          WHERE TABLE_NAME  = 'IMANDX_FILE' AND COLUMN_NAME = 'IMANDX01'
        #設置當前創建的't'欄位的信息(這里的t欄位是顯示欄位)
        LET li_ic = li_ic + 1
        LET lc_ic = li_ic USING '&&'
        LET ma_multi_rec[li_ic].index = li_ic
        LET ma_multi_rec[li_ic].object = lnode_column
        LET ma_multi_rec[li_ic].colname = 'ttt' || lc_ib
        LET ma_multi_rec[li_ic].dbfield = ''  #顯示欄位沒有對應的數據庫欄位
        LET ma_multi_rec[li_ic].dbtype = ls_type_name
        LET ma_multi_rec[li_ic].visible = TRUE
        LET ma_multi_rec[li_ic].dispfld = '@SELF';  #顯示欄位的值為一個特殊標示
 
        LET lc_display_field = 'ttt' || lc_ib  #記住這個顯示欄位的名稱
 
        LET li_ib = li_ib + 1
 
        #循環創建明細欄位
        #這裡li_ia表示的是對應于imx_file中各個欄位的下標,而對應的數據庫字段名稱要從imx01~imx10
        #所以這裡不是從1到20
        FOR li_ia = 1 TO 10
            #明細欄位成對創建,單數為Edit,雙數為ComboBox 
            #首先創建Edit欄位
            LET lc_ib = li_ib USING '&&'
            LET lc_ia = li_ia USING '&&'
 
            LET lnode_column = lnode_table.createChild('TableColumn')
            CALL lnode_column.setAttribute('colName','ttt'||lc_ib)
            CALL lnode_column.setAttribute('name','ttt'||lc_ib)
            CALL lnode_column.setAttribute('fieldId',20+li_ib)
            CALL lnode_column.setAttribute('sqlTabName','formonly')
            #No.CHI-8B0054 --start--
            LET li_tabIndex = li_tabIndex + 1
            LET ls_tabIndex = li_tabIndex
            LET ls_tabIndex = ls_tabIndex.trim()
            #No.CHI-8B0054 ---end---
            CALL lnode_column.setAttribute("tabIndex",ls_tabIndex)   #No.FUN-710055
            LET lnode_edit = lnode_column.createChild('Edit')
            CALL lnode_edit.setAttribute('width',10)    
            CALL lfrm_curr.setFieldHidden('ttt'||lc_ib,1) 
 
            #設置當前創建的't'欄位的信息(這里的t欄位是明細欄位)
            LET li_ic = li_ic + 1
            LET lc_ic = li_ic USING '&&'
            LET ma_multi_rec[li_ic].index = li_ic
            LET ma_multi_rec[li_ic].object = lnode_column
            LET ma_multi_rec[li_ic].colname = 'ttt' || lc_ib
            LET ma_multi_rec[li_ic].dbfield = 'imx' || lc_ia
            LET ma_multi_rec[li_ic].dbtype = ls_type_name
            LET ma_multi_rec[li_ic].visible = FALSE
 
            #這一組t欄位的顯示欄位都連接到前面創建的欄位去
            LET ma_multi_rec[li_ic].dispfld = lc_display_field;  
 
            LET li_ib = li_ib + 1
            LET lc_ib = li_ib USING '&&'
 
            #再創建ComboBox欄位
            LET lnode_column = lnode_table.createChild('TableColumn')
            CALL lnode_column.setAttribute('colName','ttt'||lc_ib)
            CALL lnode_column.setAttribute('name','ttt'||lc_ib)
            CALL lnode_column.setAttribute('fieldId',20+li_ib)
            CALL lnode_column.setAttribute('sqlTabName','formonly')
            #No.CHI-8B0054 --start--
            LET li_tabIndex = li_tabIndex + 1
            LET ls_tabIndex = li_tabIndex
            LET ls_tabIndex = ls_tabIndex.trim()
            #No.CHI-8B0054 ---end---
            CALL lnode_column.setAttribute("tabIndex",ls_tabIndex)   #No.FUN-710055
            LET lnode_edit = lnode_column.createChild('ComboBox')
            CALL lnode_edit.setAttribute('width',10)    
            CALL lfrm_curr.setFieldHidden('ttt'||lc_ib,1) 
 
            #設置當前創建的't'欄位的信息(這里的t欄位是明細欄位)
            LET li_ic = li_ic + 1
            LET lc_ic = li_ic USING '&&'
            LET ma_multi_rec[li_ic].index = li_ic
            LET ma_multi_rec[li_ic].object = lnode_column
            LET ma_multi_rec[li_ic].colname = 'ttt' || lc_ib
            LET ma_multi_rec[li_ic].dbfield = 'imx' || lc_ia   #每一組中的兩個控件對應的這一條記錄是相同的
            LET ma_multi_rec[li_ic].dbtype = ls_type_name
            LET ma_multi_rec[li_ic].visible = FALSE
 
            #這一組t欄位的顯示欄位都連接到前面創建的欄位去
            LET ma_multi_rec[li_ic].dispfld = lc_display_field;  
 
            LET li_ib = li_ib + 1
 
        END FOR
     END IF
     #2005/05/03 Add By Lifeng End
     
  END FOR
 
  LET li_width = li_width + mi_col_count * 2 + 7
  CALL pnode_frm.setAttribute("width", li_width)
  CALL pnode_frm.setAttribute("height", 11)
 
  IF (mi_col_count < MI_MAX_COL_COUNT) THEN
     # 2003/03/20 by Hiko : 補足20個欄位.
     FOR li_i = mi_col_count + 1 TO MI_MAX_COL_COUNT
         LET lnode_column = lnode_table.createChild("TableColumn")
         LET lc_col_index = li_i USING '&&'
         CALL lnode_column.setAttribute("colName", "xxx" || lc_col_index)
         CALL lnode_column.setAttribute('name','xxx' || lc_col_index) #2005/05/03 FUN-550021 Add By Lifeng
         CALL lnode_column.setAttribute("fieldId", li_i)
         #No.CHI-8B0054 --start--
#        LET ls_tabIndex = li_i + 1
         LET li_tabIndex = li_tabIndex + 1
         LET ls_tabIndex = li_tabIndex
         #No.CHI-8B0054 ---end---
         LET ls_tabIndex = ls_tabIndex.trim()
         CALL lnode_column.setAttribute("tabIndex",ls_tabIndex)   #No.FUN-710055
   
         LET lnode_edit = lnode_column.createChild("Edit")
         CALL lnode_edit.setAttribute("width", 0)
         # 2004/02/09 by saki : 用form的元件隱藏多餘的欄位,避免以後attribute(hidden)會改變
         CALL lfrm_curr.setFieldHidden("xxx" || lc_col_index,1)
#        CALL lnode_column.setAttribute("hidden",1)
#        CALL lnode_column.setAttribute("unhidable","1")
 
         #2005/05/03 FUN-550021 Add By Lifeng Start
         #填充剛剛創建的節點的控制信息
         LET li_ic = li_ic + 1
         LET lc_ic = li_ic USING '&&'
         LET ma_multi_rec[li_ic].index = li_ic
         LET ma_multi_rec[li_ic].object = lnode_column
         LET ma_multi_rec[li_ic].colname = 'xxx' || lc_col_index
         #以下這些字段對于補充的欄位是不需要的
         LET ma_multi_rec[li_ic].dbfield = ''
         LET ma_multi_rec[li_ic].dbtype = ''
         LET ma_multi_rec[li_ic].visible = FALSE
         #2005/05/03 Add By Lifeng End
 
     END FOR
  END IF
  
  #2005/05/03 FUN-550021 Add By Lifeng Start
  #補足83個欄位,剩下的全部創建成Edit
  IF (MI_MAX_COL_COUNT + li_ib -1 < MI_MAX_COL_COUNT_TOT) THEN
     FOR li_ia = li_ib TO MI_MAX_COL_COUNT_TOT - MI_MAX_COL_COUNT
         LET lnode_column = lnode_table.createChild("TableColumn")
         LET lc_col_index = li_ia USING '&&'
         CALL lnode_column.setAttribute('colName', 'ttt' || lc_col_index)
         CALL lnode_column.setAttribute('name', 'ttt' || lc_col_index)
         CALL lnode_column.setAttribute('fieldId', li_ia)
         CALL lnode_column.setAttribute('sqlTabName','formonly')
         #No.CHI-8B0054 --start--
#        LET ls_tabIndex = li_ia + 1
         LET li_tabIndex = li_tabIndex + 1
         LET ls_tabIndex = li_tabIndex
         #No.CHI-8B0054 ---end---
         LET ls_tabIndex = ls_tabIndex.trim()
         CALL lnode_column.setAttribute("tabIndex",ls_tabIndex)   #No.FUN-710055
   
         LET lnode_edit = lnode_column.createChild('Edit')
         CALL lnode_edit.setAttribute('width', 0)
         #用form的元件隱藏多餘的欄位,避免以後attribute(hidden)會改變
         CALL lfrm_curr.setFieldHidden('ttt' || lc_col_index,1)         
 
         #填充剛剛創建的節點的控制信息
         LET li_ic = li_ic + 1
         LET lc_ic = li_ic USING '&&'
         LET ma_multi_rec[li_ic].index = li_ic
         LET ma_multi_rec[li_ic].object = lnode_column
         LET ma_multi_rec[li_ic].colname = 'ttt' || lc_col_index
         #以下這些字段對于補充的欄位是不需要的
         LET ma_multi_rec[li_ic].dbfield = ''
         LET ma_multi_rec[li_ic].dbtype = ''
         LET ma_multi_rec[li_ic].visible = FALSE
 
     END FOR
  END IF
  #2005/05/03 Add By Lifeng End
 
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 建立<RecordView>節點.
# Input parameter: pnode_frm om.DomNode <Form>節點
# Return code....: void
# Usage..........: CALL cl_qry_build_rec_view(lnode_frm)
# Date & Author..: 2003/07/08 by Hiko
##########################################################################
 
FUNCTION cl_qry_build_rec_view(pnode_frm)
  DEFINE pnode_frm om.DomNode
  DEFINE li_i LIKE type_file.num5,           #No.FUN-690005 SMALLINT
         lnode_rec_view,lnode_link om.DomNode
 
  # 2003/03/20 by Hiko : 第一個欄位為FORMONLY(CheckBox/Edit).
  CALL cl_qry_get_rec_view(pnode_frm, "formonly") RETURNING lnode_rec_view
  LET lnode_link = lnode_rec_view.createChild("Link")
  CALL lnode_link.setAttribute("fieldIdRef", "0")
  # 2003/07/05 by Hiko : 欄位check的fieldIdRef=0,因此其他10個欄位的fieldIdRef從1開始設定.
  FOR li_i = 1 TO mi_col_count
      CALL cl_qry_get_rec_view(pnode_frm, ma_gac[li_i].gac05) RETURNING lnode_rec_view
      LET lnode_link = lnode_rec_view.createChild("Link")
      CALL lnode_link.setAttribute("fieldIdRef", li_i)
  END FOR
 
  IF (mi_col_count < MI_MAX_COL_COUNT) THEN
     # 2003/03/20 by Hiko : 補足20個欄位.
     FOR li_i = mi_col_count + 1 TO MI_MAX_COL_COUNT
         CALL cl_qry_get_rec_view(pnode_frm, "formonly") RETURNING lnode_rec_view
         LET lnode_link = lnode_rec_view.createChild("Link")
         CALL lnode_link.setAttribute("fieldIdRef", li_i)
     END FOR
  END IF
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 回傳<RecordView>節點.
# Input parameter: pnode_frm      om.DomNode   <Form>節點
#                  ps_table_name  STRING       <Table>節點的名稱
# Return code....: om.DomNode     <RecordView>節點
# Usage..........: CALL cl_qry_get_rec_view(lnode_frm, "formonly") RETURNING lnode_rec_view
# Date & Author..: 2003/07/08 by Hiko
##########################################################################
 
FUNCTION cl_qry_get_rec_view(pnode_frm,ps_table_name)
  DEFINE pnode_frm om.DomNode,
         ps_table_name STRING
  DEFINE lnode_rec_view om.DomNode,
         ls_tag_name,ls_table_name STRING
 
  LET lnode_rec_view = pnode_frm.getFirstChild()
 
  # 2003/04/03 by Hiko : 如果找到<RecordView>,則回傳此節點;若找不到,則新建一個<RecordView>.
  WHILE lnode_rec_view IS NOT NULL
    LET ls_tag_name = lnode_rec_view.getTagName()
 
    IF (ls_tag_name.equals("RecordView")) THEN
       LET ls_table_name = lnode_rec_view.getAttribute("tabName")
 
       IF (ls_table_name.equals(ps_table_name)) THEN
          RETURN lnode_rec_view
       END IF
    END IF
 
    LET lnode_rec_view = lnode_rec_view.getNext()
  END WHILE
 
  LET lnode_rec_view = pnode_frm.createChild("RecordView")
  CALL lnode_rec_view.setAttribute("tabName", ps_table_name)
 
  RETURN lnode_rec_view
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 畫面顯現與資料的選擇.
# Input parameter: none
# Return code....: void
# Usage..........: CALL cl_qry_sel()
# Date & Author..: 2003/07/08 by Hiko
##########################################################################
 
FUNCTION cl_qry_sel()
  DEFINE ls_hide_act STRING
  DEFINE li_hide_page   LIKE type_file.num5,        #No.FUN-690005 SMALLINT   #是否隱藏'上下頁'的按鈕.
         li_reconstruct LIKE type_file.num5,        #No.FUN-690005 SMALLINT #是否重新CONSTRUCT.預設為TRUE. 
         li_continue    LIKE type_file.num5         #No.FUN-690005 SMALLINT     #是否繼續顯現資料.
  DEFINE li_start_index,li_end_index    LIKE type_file.num10       #No.FUN-690005 INTEGER
  DEFINE li_curr_page LIKE type_file.num5           #No.FUN-690005 SMALLINT
  DEFINE li_count    LIKE ze_file.ze03,
         li_page     LIKE ze_file.ze03
 
  IF (g_qryparam.pagecount IS NULL) THEN
     LET li_hide_page = TRUE
  END IF
  
  LET li_reconstruct = TRUE
 
  WHILE TRUE
#   CLEAR FORM    #No.TQC-910019
    
    LET INT_FLAG = FALSE
    LET ls_hide_act = ""
 
    IF (li_reconstruct) THEN
       MESSAGE ""
 
       IF (g_qryparam.construct = 'Y') THEN
          IF NOT cl_null(FGL_GETENV("WEBAREA")) THEN   #WEB區   #WEB-C40003
             CALL cl_web_qry_cons()   #WEB-C40003
          ELSE                        #WEB-C40003
             CALL cl_qry_def_cons()
          END IF                      #WEB-C40003
          
          IF (INT_FLAG) THEN
             CALL cl_qry_cancel()
             EXIT WHILE
          END IF
       END IF
 
       CALL cl_qry_prep_result_set() 
       # 2003/07/14 by Hiko : 如果沒有設定'每頁顯現資料筆數',則預設為所有資料一起顯現.
       IF (li_hide_page) THEN
          LET g_qryparam.pagecount = g_ma_qry.getLength()
       END IF
 
       LET li_start_index = 1
       LET li_reconstruct = FALSE
    END IF
 

       # 2003/07/14 by Hiko : 如果所設定的'每頁顯現資料筆數'超過/等於所有資料,則要隱藏'上下頁'的按鈕.
       IF (g_qryparam.pagecount >= g_ma_qry.getLength()) THEN
          LET ls_hide_act = "prevpage,nextpage"
       END IF

       IF (g_qryparam.construct = 'N') THEN
          IF (ls_hide_act IS NULL) THEN
             LET ls_hide_act = "reconstruct"
          ELSE
             LET ls_hide_act = "prevpage,nextpage,reconstruct"
          END IF 
       END IF
 
    LET li_end_index = li_start_index + g_qryparam.pagecount - 1
 
    IF (li_end_index > g_ma_qry.getLength()) THEN
       LET li_end_index = g_ma_qry.getLength()
    END IF
 
    CALL cl_qry_set_display_data(li_start_index, li_end_index)
 
    LET li_curr_page = li_end_index / g_qryparam.pagecount
    # 2004/02/25 by saki : 若最後一頁不到整除的數目, 避免頁次不會再往上加
    IF (li_end_index MOD g_qryparam.pagecount) > 0 THEN
       LET li_curr_page = li_curr_page + 1
       IF cl_null(ls_hide_act) THEN          #FUN-570133
          LET ls_hide_act = "nextpage"
       ELSE
          LET ls_hide_act = ls_hide_act.trim(),",nextpage"
       END IF
    END IF
 
    #FUN-570133
    IF li_curr_page = 1 THEN
       IF cl_null(ls_hide_act) THEN
          LET ls_hide_act = "prevpage"
       ELSE
          LET ls_hide_act = ls_hide_act.trim(),",prevpage"
       END IF
    END IF
 
    SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
    SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
    MESSAGE li_count CLIPPED || " : " || g_ma_qry.getLength() || "    " || li_page CLIPPED || " : " || li_curr_page

    ###WEB-C40003 START ###
    IF NOT cl_null(FGL_GETENV("WEBAREA")) THEN   #WEB區
       IF (g_qryparam.state = 'i') THEN
          CALL cl_web_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
       ELSE
          CALL cl_web_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
       END IF
    ELSE
    ###WEB-C40003 END ###
       IF (g_qryparam.state = 'i') THEN
          CALL cl_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
       ELSE
          CALL cl_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
       END IF
    END IF                                                        #WEB-C40003
 
    IF (NOT li_continue) THEN
       EXIT WHILE
    END IF
 
    CLEAR FORM    #No.TQC-910019
  END WHILE
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 準備查詢畫面的資料集.
# Input parameter: none
# Return code....: void
# Usage..........: CALL cl_qry_prep_result_set()
# Date & Author..: 2003/07/08 by Hiko
##########################################################################
FUNCTION cl_qry_prep_result_set()
  DEFINE lst_col_name base.StringTokenizer,
         ls_col_name,ls_order_col_name STRING,
         lst_all_col_name   base.StringTokenizer,
         li_cons_col_index  LIKE type_file.num5,           #No.FUN-690005 SMALLINT
         li_cons_col_order  LIKE type_file.num5            #No.FUN-690005 SMALLINT
  DEFINE ls_gab_sql         STRING,
         lc_temp_where      LIKE gab_file.gab02,
         lc_temp_join_table LIKE gab_file.gab03,
         lc_distinct        LIKE gab_file.gab04,
         ls_temp_join_table STRING,                 # MOD-490496 取join的table字串出來
         lst_join_tables    base.StringTokenizer,
         ls_table_name      STRING,
         ls_where           STRING,
         ls_new_arg         STRING,
         ls_join_table      STRING,
         ls_unique          STRING,
         ls_sql             STRING
  DEFINE li_cnt             LIKE type_file.num5           #No.FUN-690005 SMALLINT                #MOD-530711
  DEFINE li_i LIKE type_file.num10,          #No.FUN-690005 INTEGER
         li_j LIKE type_file.num5,           #No.FUN-690005 SMALLINT
         la_ret_field_index DYNAMIC ARRAY OF  LIKE type_file.num5           #No.FUN-690005SMALLINT
  DEFINE lr_qry RECORD
         check LIKE type_file.chr1,           #No.FUN-690005 VARCHAR(1)
         item01,item02,item03,item04,item05,
         item06,item07,item08,item09,item10,
         item11,item12,item13,item14,item15,
         item16,item17,item18,item19,item20,
         #2005/05/03 FUN-550021 Add By Lifeng Start , 增加63個欄位
         item21,item22,item23,item24,item25,
         item26,item27,item28,item29,item30,
         item31,item32,item33,item34,item35,
         item36,item37,item38,item39,item40,
         item41,item42,item43,item44,item45,
         item46,item47,item48,item49,item50,
         item51,item52,item53,item54,item55,
         item56,item57,item58,item59,item60,
         item61,item62,item63,item64,item65,
         item66,item67,item68,item69,item70,
         item71,item72,item73,item74,item75,
         item76,item77,item78,item79,item80,
         item81,item82,item83   LIKE type_file.chr1000        #No.FUN-690005 VARCHAR(250)
         #2005/05/03 Add By Lifeng End  END RECORD
         END RECORD
  DEFINE l_gac_sql STRING,
         l_gac05 LIKE gac_file.gac05,
         l_gac05_str STRING,
         l_gat_sql STRING,
         l_gat_cnt SMALLINT,
         l_table_prefix STRING
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE l_target_db LIKE azw_file.azw05 #FUN-980030
 
  LET li_cons_col_index = ms_cons_where.getIndexOf("ms_xxx", 1)
  WHILE li_cons_col_index > 0
     # 2003/11/13 by Hiko : 抓取"ms_xxx流水號"的流水號,並依此抓取CONSTRUCT的where條件.
     LET li_cons_col_order = ms_cons_where.subString(li_cons_col_index+5+1, li_cons_col_index+5+2)
     LET lst_col_name = base.StringTokenizer.create(msb_col_name.toString(), ",")
     WHILE lst_col_name.hasMoreTokens()
        FOR li_i = 1 TO li_cons_col_order
           LET ls_col_name = lst_col_name.nextToken()
           IF gc_db_type = "ORA" THEN                #No.TQC-650102
#             #TQC-620117
              IF ls_col_name.getIndexOf("to_char(",1) THEN
                 LET ls_col_name=ls_col_name.subString(ls_col_name.getIndexOf("to_char(",1)+8,ls_col_name.getLength())
                 IF li_i < li_cons_col_order THEN    #No.TQC-650102
                    LET li_i = li_i - 1              #No.MOD-640523
                 END IF                              #No.TQC-650102
              END IF
#             #TQC-620117
           END IF                                    #No.TQC-650102
        END FOR
        EXIT WHILE
     END WHILE
     # 2003/03/20 by Hiko : 因為"ms_xxx"有6個字元,所以其位置必須加上'5'才是"ms_xxx"的結束位置.
     #                      另外的'2'是要替換掉"01","02"...的位置
     LET ms_cons_where = cl_replace_str_by_index(ms_cons_where, li_cons_col_index, li_cons_col_index+5+2, ls_col_name)
     LET li_cons_col_index = ms_cons_where.getIndexOf("ms_xxx", 1)
  END WHILE
 
  # 2004/05/10 by Hiko : 變數值還原.
  LET li_i = 1
 
  # 2003/07/15 by Hiko : 有些查詢畫面不需CONSTRUCT,因此要設為1=1.
  IF (ms_cons_where IS NULL) THEN
     LET ms_cons_where = "1=1"
  END IF
  # 2003/11/04 by Hiko : 如果是在CONSTRUCT時開窗,則WHERE條件要抓取gab05,以防止OUTER的錯誤.
  ###WEB-C40003 mark START ###
  #IF (g_qryparam.state = 'c') THEN
  #   LET ls_gab_sql = "SELECT gab05,gab03,gab04 FROM gab_file ",
  #                    " WHERE gab01='", g_qryparam.form ,"' AND gab11='", gc_cust_flag ,"'"
  #ELSE
  #   LET ls_gab_sql = "SELECT gab02,gab03,gab04 FROM gab_file ",
  #                    " WHERE gab01='", g_qryparam.form ,"' AND gab11='", gc_cust_flag ,"'"
  #END IF
  ###WEB-C40003 mark END ###
  ###WEB-C40003 START ###
  IF gi_qry_webdata THEN
     IF (g_qryparam.state = 'c') THEN
        LET ls_gab_sql = "SELECT wzb05,wzb03,wzb04 FROM ",s_dbstring("wds") CLIPPED,"wzb_file ",
                         " WHERE wzb01='", g_qryparam.form CLIPPED,"'",
                         "   AND wzb11='", gc_cust_flag CLIPPED,"'"
     ELSE
        LET ls_gab_sql = "SELECT wzb02,wzb03,wzb04 FROM ",s_dbstring("wds") CLIPPED,"wzb_file ",
                         " WHERE wzb01='", g_qryparam.form CLIPPED,"'",
                         "   AND wzb11='", gc_cust_flag CLIPPED,"'"
     END IF
  ELSE
     IF (g_qryparam.state = 'c') THEN
        LET ls_gab_sql = "SELECT gab05,gab03,gab04 FROM ",s_dbstring("ds") CLIPPED,"gab_file ",
                         " WHERE gab01='", g_qryparam.form CLIPPED,"'",
                         "   AND gab11='", gc_cust_flag CLIPPED,"'"
     ELSE
        LET ls_gab_sql = "SELECT gab02,gab03,gab04 FROM ",s_dbstring("ds") CLIPPED,"gab_file ",
                         " WHERE gab01='", g_qryparam.form CLIPPED,"'",
                         "   AND gab11='", gc_cust_flag CLIPPED,"'"
     END IF
  END IF
  ###WEB-C40003 END ###
 
  DECLARE lcurs_gab SCROLL CURSOR FROM ls_gab_sql
  OPEN lcurs_gab
  FETCH lcurs_gab INTO lc_temp_where,lc_temp_join_table,lc_distinct
  CLOSE lcurs_gab
 
  IF (NOT SQLCA.SQLCODE) THEN
 
     IF (NOT cl_null(lc_temp_where)) THEN
        LET ls_where = lc_temp_where CLIPPED
 
        #MOD-530711
        IF (cl_db_get_database_type()="IFX") THEN 
           LET li_cnt=ls_where.getIndexOf("(+)",1)
           IF li_cnt THEN
              LET ls_where=ls_where.subString(1,li_cnt-1),ls_where.subString(li_cnt+3,ls_where.getLength())
           END IF
        END IF
           
        LET li_cons_col_index = ls_where.getIndexOf("arg", 1)
 
        WHILE li_cons_col_index > 0
          CASE ls_where.getCharAt(li_cons_col_index+3)
            WHEN 1 LET ls_new_arg = g_qryparam.arg1
            WHEN 2 LET ls_new_arg = g_qryparam.arg2
            WHEN 3 LET ls_new_arg = g_qryparam.arg3
            WHEN 4 LET ls_new_arg = g_qryparam.arg4
            WHEN 5 LET ls_new_arg = g_qryparam.arg5
            WHEN 6 LET ls_new_arg = g_qryparam.arg6
            WHEN 7 LET ls_new_arg = g_qryparam.arg7
            WHEN 8 LET ls_new_arg = g_qryparam.arg8
            WHEN 9 LET ls_new_arg = g_qryparam.arg9
          END CASE
          IF ls_new_arg != ' ' THEN     #No.MOD-7A0107 add
             LET ls_new_arg = ls_new_arg.trim() #MOD-590535
          END IF                      #No.MOD-7A0107 add
          # 2003/07/08 by Hiko : 因為"arg"有3個字元,所以其位置必須加上'2'才是"arg"的結束位置.
          #                      另外的'1'是要替換掉"1","2","3"的位置.
          LET ls_where = cl_replace_str_by_index(ls_where, li_cons_col_index, li_cons_col_index+2+1, ls_new_arg)
          LET li_cons_col_index = ls_where.getIndexOf("arg", 1)
        END WHILE
     END IF
 
     IF (NOT cl_null(lc_temp_join_table)) THEN
         #MOD-490496
        LET ls_temp_join_table = lc_temp_join_table
        LET lst_join_tables = base.StringTokenizer.create(ls_temp_join_table,",")
        WHILE lst_join_tables.hasMoreTokens()
           LET ls_table_name = lst_join_tables.nextToken()
           LET ls_table_name = ls_table_name.trim()
           
           #BEGIN:FUN-980030
           # IF gc_ignore_db="N" THEN
           ##TQC-950048 MARK&ADD START----------------------------------------------------  
           ##   CASE
           ##   WHEN cl_db_get_database_type() = "ORA"
           ##      LET ls_table_name = gc_gac04 CLIPPED,".",ls_table_name CLIPPED
           ##   WHEN cl_db_get_database_type() = "IFX"
           ##      LET ls_table_name = gc_gac04 CLIPPED,":",ls_table_name CLIPPED
           ##   WHEN cl_db_get_database_type() = "MSV"         #FUN-810071
           ##      LET ls_table_name = gc_gac04 CLIPPED,".dbo.",ls_table_name CLIPPED
           ##   END CASE
           #    LET ls_table_name = s_dbstring(gc_gac04),ls_table_name CLIPPED  #add                                                  
           ##TQC-950048 END-------------------------------------------------------------------- 
           # ELSE
           #    LET ls_table_name = ls_table_name CLIPPED
           # END IF
           #END:FUN-980030
           #BEGIN:FUN-980030
           IF g_qryparam.plant != g_plant THEN
              LET ls_table_name = cl_get_target_table(g_qryparam.plant, ls_table_name)
           END IF
           #END:FUN-980030
           LET ls_join_table = ls_join_table,"," || ls_table_name CLIPPED
        END WHILE
     END IF
 
     IF (lc_distinct = 'Y') THEN
        LET ls_unique = " UNIQUE "
     END IF
 
     IF (NOT cl_null(ls_where)) THEN
        LET ls_where = " ( " || ls_where || " ) AND "
     END IF
  END IF
 
  # 2003/11/13 by Hiko : 因為前面的程式段曾經抓取資料過,因此這裡要重新建立,
  #                      以避免資料並非i從第一個開始抓.
  LET lst_col_name = base.StringTokenizer.create(msb_col_name.toString(), ",")
  # 2003/11/04 by Hiko : 如果是在CONSTRUCT時開窗,則不需要JOIN TABLE.
  IF (g_qryparam.state = 'c') THEN
#    LET ls_join_table = NULL                           #MOD-4A0025
     # 2003/11/13 by Hiko : 底下程式段為ORDER BY的字串.
     LET li_j = 1
     WHILE lst_col_name.hasMoreTokens()
       LET ls_col_name = lst_col_name.nextToken()
       IF (li_j = mi_multi_ret_field_index) THEN
          LET ls_order_col_name = ls_col_name   
          EXIT WHILE
       END IF
 
       LET li_j = li_j + 1
     END WHILE
    #--------------No.MOD-760095 add
     IF (NOT cl_null(g_qryparam.where)) THEN
        LET ls_where = " ( ",g_qryparam.where," ) AND ",ls_where
     END IF
    #--------------No.MOD-760095 end
  ELSE
     IF (NOT cl_null(g_qryparam.where)) THEN
        LET ls_where = " ( ",g_qryparam.where," ) AND ",ls_where
     END IF
 
     # 2003/11/13 by Hiko : 因為前面的程式段曾經抓取資料過,因此這裡要重新建立,以避免資料並非i從第一個開始抓.
     LET mst_ret_field_index = base.StringTokenizer.create(msb_ret_field_index.toString(), ",")
     # 2003/11/13 by Hiko : 將回傳欄位的索引值塞到陣列內,以抓取ORDER BY的字串.
     LET li_i = 1
     WHILE mst_ret_field_index.hasMoreTokens() 
        LET la_ret_field_index[li_i] = mst_ret_field_index.nextToken()
        LET li_i = li_i + 1
     END WHILE
     # 2003/11/13 by Hiko : 底下程式段為ORDER BY的字串.
     LET li_i = 1
     LET li_j = 1
     WHILE lst_col_name.hasMoreTokens()
       LET ls_col_name = lst_col_name.nextToken()
       IF gc_db_type = "ORA" THEN             #No.TQC-650102
#         #TQC-620117
          IF ls_col_name.getIndexOf("dd",1) AND
             ls_col_name.getIndexOf("mm",1) AND
             ls_col_name.getIndexOf("yy",1) THEN
             CONTINUE WHILE
          END IF
          IF ls_col_name.getIndexOf("to_char(",1) THEN
             LET ls_col_name=ls_col_name.subString(ls_col_name.getIndexOf("to_char(",1)+8,ls_col_name.getLength())
          END IF
#         #TQC-620117
       END IF                                 #No.TQC-650102
       IF (li_j = la_ret_field_index[li_i]) THEN
          IF (ls_order_col_name IS NULL) THEN
             LET ls_order_col_name = ls_col_name
          ELSE
             LET ls_order_col_name = ls_order_col_name || "," || ls_col_name
          END IF
 
          LET li_i = li_i + 1
       END IF
 
       LET li_j = li_j + 1
     END WHILE
  END IF
 
  #Begin:FUN-980030 by Hiko:加上權限過濾條件
  LET l_filter_cond = cl_get_extra_cond_for_qry(g_qryparam.form, mc_first_table_name)
 
  IF NOT cl_null(l_filter_cond) THEN
     #會搞這麼複雜是因為cl_get_extra_cond/cl_get_extra_cond_for_qry如果有值的話,前面會加上"AND".
     #這是為了一般程式要呼叫的時候比較方便(因為就不用判斷此回傳值是否為NULL).
     LET l_filter_cond = l_filter_cond.trim()
     LET l_filter_cond = l_filter_cond.subString(4, l_filter_cond.getLength())
     LET ls_where = ls_where,l_filter_cond," AND "
  END IF
  #End:FUN-980030
 
  #2005/05/03 FUN-550021 Add By Lifeng Start
  #判斷如果是進行多屬性管理并且包含了料件欄位，即是通過自定義的CONSTRUCT過程
  #而非標准過程生成的WHERE條件，那麼也需要對SQL語句的合成進行相應的調整
  IF ( g_sma.sma120 = 'Y' )AND( g_imafldlist.getLength() > 0 ) 
     AND cl_null(FGL_GETENV("WEBAREA")) THEN  #非WEB區  #WEB-C40003
     #如果用戶選擇了條件ㄎand aaaaaa
     IF g_multi_where.getLength() > 0 THEN 
        LET ls_sql = 'SELECT DISTINCT ''N'',',msb_col_name.toString(),
                     ' FROM ',msb_tab_name.toString(),ls_join_table,msb_OUTER.toString(),g_multi_join,
                     ' WHERE ',ls_where,g_multi_where,
                     ' ORDER BY ',ls_order_col_name,g_qryparam.ordercons
     ELSE #如果用戶沒有選擇條件則使用默認的邏輯(因為在自定義邏輯中沒有對ms_cons_where進行賦值，
          #所以實際上相當于是沒有條件
        LET ls_sql = "SELECT ",ls_unique,"'N',",msb_col_name.toString(),
                     " FROM ",msb_tab_name.toString(),ls_join_table,msb_OUTER.toString(),
                     " WHERE ",ls_where,ms_cons_where,
                     " ORDER BY ",ls_order_col_name,g_qryparam.ordercons
     END IF
  ELSE #如果沒有進行自定義的CONSTRUCT則還是采用原有的流程
     #下面的這段語句是原有的邏輯
     LET ls_sql = "SELECT ",ls_unique,"'N',",msb_col_name.toString(),
                  " FROM ",msb_tab_name.toString(),ls_join_table,msb_OUTER.toString(),
                  " WHERE ",ls_where,ms_cons_where,
                  " ORDER BY ",ls_order_col_name,g_qryparam.ordercons
  END IF
  #2005/05/03 Add By Lifeng End
 
# IF (cl_db_get_database_type() = "ORA") THEN
#    LET ls_sql = cl_qry_replace_sql(ls_sql)
# END IF
 
  CASE cl_db_get_database_type() 
     WHEN "MSV"                                      #MOD-770064
        LET ls_sql = cl_qry_replace_sql(ls_sql)
        LET ls_sql = cl_qry_replace_sql2ms(ls_sql)   #FUN-810071
     WHEN "ASE"                                      #FUN-AA0017
        LET ls_sql = cl_qry_replace_sql(ls_sql)
        LET ls_sql = cl_qry_replace_sql2ms(ls_sql)   #FUN-810071
     WHEN "ORA"                                      #FUN-AA0017
        LET ls_sql = cl_qry_replace_sql(ls_sql)
     OTHERWISE    # "IFX" 
        #INFORMIX Connot be fix.
  END CASE
 
# IF (g_trace = 'Y') THEN
#     DISPLAY "cl_create_qry : Final sql = " || ls_sql
# END IF
 
  #Begin:FUN-A50080
  #Begin:FUN-980030
  #IF g_qryparam.plant = g_plant THEN
  #   IF cl_table_exist_plant(mc_first_table_name) THEN
  #      IF (g_qryparam.state = 'i') THEN
  #         #在維護狀態要取得單據資料時,都只能取得Plant本身的資料.
  #         LET ls_sql = cl_parse_qry_sql(ls_sql, g_qryparam.plant)
  #      END IF
  #   END IF
  #ELSE
  #   #跨Plant時,都是只能取得Plant本身的資料.
  #   LET ls_sql = cl_parse_qry_sql(ls_sql, g_qryparam.plant)
  #END IF
  #End:FUN-980030
  IF g_qryparam.plant != g_plant THEN 
     LET ls_sql = cl_parse_qry_sql(ls_sql, g_qryparam.plant)
  END IF
  #End:FUN-A50080
 
  DISPLAY g_qryparam.form CLIPPED," : ",ls_sql

  DECLARE lcurs_qry CURSOR FROM ls_sql
 
  CALL g_ma_qry.clear()
 
  LET li_i = 1
 
  FOREACH lcurs_qry INTO lr_qry.*
 
      IF (SQLCA.SQLCODE) THEN
         CALL cl_err(ls_sql, SQLCA.SQLCODE, 1)
         EXIT FOREACH
      END IF
 
       #MOD-4B0184 判斷是否已達選取上限
      IF li_i-1 >= g_aza.aza38 THEN
         CALL cl_err_msg(NULL,"lib-217",g_aza.aza38,10)
         EXIT FOREACH
      END IF
 
 #     LET ma_qry[li_i].* = lr_qry.*     #MOD-4B0184 因為STRING需一個一個指定
      LET g_ma_qry[li_i].check  = lr_qry.check CLIPPED
       LET g_ma_qry[li_i].item01 = lr_qry.item01 CLIPPED #MOD-540046 
       LET g_ma_qry[li_i].item02 = lr_qry.item02 CLIPPED #MOD-540046
       LET g_ma_qry[li_i].item03 = lr_qry.item03 CLIPPED #MOD-540046
       LET g_ma_qry[li_i].item04 = lr_qry.item04 CLIPPED #MOD-540046
       LET g_ma_qry[li_i].item05 = lr_qry.item05 CLIPPED #MOD-540046
       LET g_ma_qry[li_i].item06 = lr_qry.item06 CLIPPED #MOD-540046
       LET g_ma_qry[li_i].item07 = lr_qry.item07 CLIPPED #MOD-540046
       LET g_ma_qry[li_i].item08 = lr_qry.item08 CLIPPED #MOD-540046
       LET g_ma_qry[li_i].item09 = lr_qry.item09 CLIPPED #MOD-540046
       LET g_ma_qry[li_i].item10 = lr_qry.item10 CLIPPED #MOD-540046
       LET g_ma_qry[li_i].item11 = lr_qry.item11 CLIPPED #MOD-540046
       LET g_ma_qry[li_i].item12 = lr_qry.item12 CLIPPED #MOD-540046
       LET g_ma_qry[li_i].item13 = lr_qry.item13 CLIPPED #MOD-540046
       LET g_ma_qry[li_i].item14 = lr_qry.item14 CLIPPED #MOD-540046
       LET g_ma_qry[li_i].item15 = lr_qry.item15 CLIPPED #MOD-540046
       LET g_ma_qry[li_i].item16 = lr_qry.item16 CLIPPED #MOD-540046
       LET g_ma_qry[li_i].item17 = lr_qry.item17 CLIPPED #MOD-540046
       LET g_ma_qry[li_i].item18 = lr_qry.item18 CLIPPED #MOD-540046
       LET g_ma_qry[li_i].item19 = lr_qry.item19 CLIPPED #MOD-540046
       LET g_ma_qry[li_i].item20 = lr_qry.item20 CLIPPED #MOD-540046 
      #2005/05/03 FUN-550021 Add By Lifeng Start
      #新增的33個欄位要部齊
      LET g_ma_qry[li_i].item21 = lr_qry.item21 CLIPPED
      LET g_ma_qry[li_i].item22 = lr_qry.item22 CLIPPED
      LET g_ma_qry[li_i].item23 = lr_qry.item23 CLIPPED
      LET g_ma_qry[li_i].item24 = lr_qry.item24 CLIPPED
      LET g_ma_qry[li_i].item25 = lr_qry.item25 CLIPPED
      LET g_ma_qry[li_i].item26 = lr_qry.item26 CLIPPED
      LET g_ma_qry[li_i].item27 = lr_qry.item27 CLIPPED
      LET g_ma_qry[li_i].item28 = lr_qry.item28 CLIPPED
      LET g_ma_qry[li_i].item29 = lr_qry.item29 CLIPPED
      LET g_ma_qry[li_i].item30 = lr_qry.item30 CLIPPED
      LET g_ma_qry[li_i].item31 = lr_qry.item31 CLIPPED
      LET g_ma_qry[li_i].item32 = lr_qry.item32 CLIPPED
      LET g_ma_qry[li_i].item33 = lr_qry.item33 CLIPPED
      LET g_ma_qry[li_i].item34 = lr_qry.item34 CLIPPED
      LET g_ma_qry[li_i].item35 = lr_qry.item35 CLIPPED
      LET g_ma_qry[li_i].item36 = lr_qry.item36 CLIPPED
      LET g_ma_qry[li_i].item37 = lr_qry.item37 CLIPPED
      LET g_ma_qry[li_i].item38 = lr_qry.item38 CLIPPED
      LET g_ma_qry[li_i].item39 = lr_qry.item39 CLIPPED
      LET g_ma_qry[li_i].item40 = lr_qry.item40 CLIPPED
      LET g_ma_qry[li_i].item41 = lr_qry.item41 CLIPPED
      LET g_ma_qry[li_i].item42 = lr_qry.item42 CLIPPED
      LET g_ma_qry[li_i].item43 = lr_qry.item43 CLIPPED
      LET g_ma_qry[li_i].item44 = lr_qry.item44 CLIPPED
      LET g_ma_qry[li_i].item45 = lr_qry.item45 CLIPPED
      LET g_ma_qry[li_i].item46 = lr_qry.item46 CLIPPED
      LET g_ma_qry[li_i].item47 = lr_qry.item47 CLIPPED
      LET g_ma_qry[li_i].item48 = lr_qry.item48 CLIPPED
      LET g_ma_qry[li_i].item49 = lr_qry.item49 CLIPPED
      LET g_ma_qry[li_i].item50 = lr_qry.item50 CLIPPED
      LET g_ma_qry[li_i].item51 = lr_qry.item51 CLIPPED
      LET g_ma_qry[li_i].item52 = lr_qry.item52 CLIPPED
      LET g_ma_qry[li_i].item53 = lr_qry.item53 CLIPPED
 
      LET g_ma_qry[li_i].item54 = lr_qry.item54 CLIPPED
      LET g_ma_qry[li_i].item55 = lr_qry.item55 CLIPPED
      LET g_ma_qry[li_i].item56 = lr_qry.item56 CLIPPED
      LET g_ma_qry[li_i].item57 = lr_qry.item57 CLIPPED
      LET g_ma_qry[li_i].item58 = lr_qry.item58 CLIPPED
      LET g_ma_qry[li_i].item59 = lr_qry.item59 CLIPPED
      LET g_ma_qry[li_i].item60 = lr_qry.item60 CLIPPED
      LET g_ma_qry[li_i].item61 = lr_qry.item61 CLIPPED
      LET g_ma_qry[li_i].item62 = lr_qry.item62 CLIPPED
      LET g_ma_qry[li_i].item63 = lr_qry.item63 CLIPPED
      LET g_ma_qry[li_i].item64 = lr_qry.item64 CLIPPED
      LET g_ma_qry[li_i].item65 = lr_qry.item65 CLIPPED
      LET g_ma_qry[li_i].item66 = lr_qry.item66 CLIPPED
      LET g_ma_qry[li_i].item67 = lr_qry.item67 CLIPPED
      LET g_ma_qry[li_i].item68 = lr_qry.item68 CLIPPED
      LET g_ma_qry[li_i].item69 = lr_qry.item69 CLIPPED
      LET g_ma_qry[li_i].item70 = lr_qry.item70 CLIPPED
      LET g_ma_qry[li_i].item71 = lr_qry.item71 CLIPPED
      LET g_ma_qry[li_i].item72 = lr_qry.item72 CLIPPED
      LET g_ma_qry[li_i].item73 = lr_qry.item73 CLIPPED
      LET g_ma_qry[li_i].item74 = lr_qry.item74 CLIPPED
      LET g_ma_qry[li_i].item75 = lr_qry.item75 CLIPPED
      LET g_ma_qry[li_i].item76 = lr_qry.item76 CLIPPED
      LET g_ma_qry[li_i].item77 = lr_qry.item77 CLIPPED
      LET g_ma_qry[li_i].item78 = lr_qry.item78 CLIPPED
      LET g_ma_qry[li_i].item79 = lr_qry.item79 CLIPPED
      LET g_ma_qry[li_i].item80 = lr_qry.item80 CLIPPED
      LET g_ma_qry[li_i].item81 = lr_qry.item81 CLIPPED
      LET g_ma_qry[li_i].item82 = lr_qry.item82 CLIPPED
      LET g_ma_qry[li_i].item83 = lr_qry.item83 CLIPPED
      #2005/05/03 Add By Lifeng End
      LET li_i = li_i + 1
  END FOREACH
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: ORACLE取代SQL字串
# Input parameter: ps_sql   STRING   來源字串
# Return code....: STRING   取代後的SQL字串
# Usage..........: LET ls_sql = cl_qry_replace_sql(ls_sql)
# Date & Author..: 03/09/25 by Hiko
##########################################################################
 
FUNCTION cl_qry_replace_sql(ps_sql)
   DEFINE   ps_sql             STRING
   DEFINE   ls_sql_tmp         STRING,
            li_matches_index   LIKE type_file.num5,           #No.FUN-690005 SMALLINT
            li_left_bracket    LIKE type_file.num5,           #No.FUN-690005 SMALLINT
            li_right_bracket   LIKE type_file.num5,           #No.FUN-690005 SMALLINT
            ls_match_cond      STRING,
            ls_in_cond         STRING,
            li_cond_index      LIKE type_file.num5,           #No.FUN-690005 SMALLINT
            lc_condition       LIKE type_file.chr1            #No.FUN-690005 VARCHAR(1)
   DEFINE   lsb_where          base.StringBuffer              #No.FUN-6A0048
   DEFINE   li_i               LIKE type_file.num5            #No.FUN-6A0048
   DEFINE   li_j               LIKE type_file.num5            #No.FUN-6A0048
   DEFINE   li_cnt             LIKE type_file.num5            #No.FUN-6A0048
   DEFINE   lr_rpc_table       DYNAMIC ARRAY OF STRING        #No.FUN-6A0048
   DEFINE   ls_tmp_str         STRING                         #No.FUN-6A0048
   DEFINE   li_result          STRING                         #No.FUN-6A0048
   DEFINE   ls_tmp_str1        STRING                         #No.FUN-880067
 
 
   # 2003/09/25 by Hiko : 因為整個SQL字串的"MATCHES"不見得是大寫字母,因此以暫存的大寫字串來當作搜尋母體.
   LET ls_sql_tmp = ps_sql.toUpperCase()
   LET li_matches_index = ls_sql_tmp.getIndexOf("MATCHES", 1)
   IF (li_matches_index > 0) THEN
      # 2003/09/25 by Hiko : 因為"MATCHES"的長度為7,因此從找到"MATCHES"後的第一個自開始找中括號"[".
      LET li_left_bracket = ls_sql_tmp.getIndexOf("[", li_matches_index+7) 
      IF (li_left_bracket > 0) THEN
         LET li_right_bracket = ls_sql_tmp.getIndexOf("]", li_left_bracket+1)
         IF (li_right_bracket > 0) THEN
            LET ls_match_cond = ps_sql.subString(li_left_bracket+1, li_right_bracket-1)
 
            FOR li_cond_index = 1 TO ls_match_cond.getLength()
               #IF (ls_in_cond IS NOT NULL) THEN
               #   LET ls_in_cond = ls_in_cond || ","
               #END IF
 
                LET lc_condition = ls_match_cond.getCharAt(li_cond_index)
                IF (lc_condition IS NOT NULL) THEN
                   IF (ls_in_cond IS NULL) THEN
                      LET ls_in_cond = "'" || lc_condition || "'"
                   ELSE
                      LET ls_in_cond = ls_in_cond || ",'" || lc_condition || "'" 
                   END IF
                END IF
            END FOR
 
            LET ls_in_cond = "(" || ls_in_cond || ")"
         END IF
 
         LET ls_match_cond = "'[" || ls_match_cond || "]'"
 
         CALL cl_replace_once()
         LET ps_sql = cl_replace_str(ps_sql, ls_match_cond, ls_in_cond)
         # 2003/10/01 by Hiko : 原本li_left_bracket是減1,但是因為ls_match_cond最後會將單引號(')一並加上,
         #                      因此li_left_bracket變成減2.
         LET ps_sql = cl_replace_str_by_index(ps_sql, li_matches_index, li_left_bracket-2, "IN ")
        
         LET ps_sql = cl_qry_replace_sql(ps_sql) #Recursive
      END IF
   END IF
 
   CALL cl_replace_init()        #No.TQC-630132
 
   #No.FUN-6A0048 --start--
   #將OUTER的欄位前加上table name
   LET ls_tmp_str = ps_sql.subString(ps_sql.getIndexOf("WHERE ",1)+6,ps_sql.getIndexOf(" ORDER BY",1)-1)
   LET lsb_where = base.StringBuffer.create()
   CALL lsb_where.append(ls_tmp_str)
   LET li_cnt = 1
   FOR li_i = 1 TO ma_gac.getLength()
       IF ma_gac[li_i].gac11 = "Y" AND (NOT lsb_where.getIndexOf(ma_gac[li_i].gac05,1)) THEN
          LET li_result = FALSE
          FOR li_j = 1 TO lr_rpc_table.getLength()
              IF lr_rpc_table[li_j].equals(ma_gac[li_i].gac05) THEN
                 LET li_result = TRUE
                 EXIT FOR
              END IF
          END FOR
          IF li_result THEN
             CONTINUE FOR
          END IF
          LET ls_tmp_str = ma_gac[li_i].gac05
          LET ls_tmp_str = ls_tmp_str.subString(1,ls_tmp_str.getIndexOf("_file",1)-1)
          CALL lsb_where.replace(ls_tmp_str,ma_gac[li_i].gac05||"."||ls_tmp_str,0)
          #FUN-880067--begin
          LET ls_tmp_str1 = "ta_"||ls_tmp_str||"_file."||ls_tmp_str
          CALL lsb_where.replace(ls_tmp_str1,ma_gac[li_i].gac05||".ta_"||ls_tmp_str,0)
          #FUN-880067--end
          LET lr_rpc_table[li_cnt] = ma_gac[li_i].gac05
          LET li_cnt = li_cnt + 1
       END IF
   END FOR
   CALL lsb_where.replace("(+)","",0)
   LET ps_sql = ps_sql.subString(1,ps_sql.getIndexOf("WHERE ",1)+5),
                lsb_where.toString(),
                ps_sql.subString(ps_sql.getIndexOf(" ORDER BY",1),ps_sql.getLength())
   #No.FUN-6A0048 ---end---
 
   RETURN ps_sql
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: SQL Server取代SQL字串
# Input parameter: ps_sql   STRING   來源字串
# Return code....: STRING   取代後的SQL字串
# Usage..........: LET ls_sql = cl_qry_replace_sql2ms(ls_sql)
# Date & Author..: 03/09/25 by Hiko
##########################################################################
 
FUNCTION cl_qry_replace_sql2ms(ls_sql)    #FUN-810071
 
  DEFINE lc_gac05    LIKE gac_file.gac05
  DEFINE ls_gac05    STRING
  DEFINE ls_sql      STRING
  DEFINE ls_tmp_str  STRING
  DEFINE ls_tabtitle STRING
 
  LET ls_tmp_str = ls_sql.subString(ls_sql.getIndexOf("WHERE ",1)+6,ls_sql.getIndexOf(" ORDER BY",1)-1)
  LET ls_tmp_str = " ",ls_tmp_str.trim()
 
  DECLARE p_sql2ms_cur CURSOR FOR
   SELECT DISTINCT gac05 FROM gac_file
    WHERE gac01 = g_qryparam.form AND gac12=gc_cust_flag
      AND gac11 <> 'Y'
 
  FOREACH p_sql2ms_cur INTO lc_gac05
     LET ls_gac05 = lc_gac05 CLIPPED
     LET ls_tabtitle = ls_gac05.subString(1,ls_gac05.getIndexOf("_file",1)-1)
     IF ls_tmp_str.getIndexOf(" "||ls_tabtitle,1) THEN
        LET ls_tmp_str = cl_replace_str(ls_tmp_str," "||ls_tabtitle,"&"||ls_gac05.trim()||"."||ls_tabtitle)
     END IF
  END FOREACH
  LET ls_tmp_str = cl_replace_str(ls_tmp_str,"&"," ")
 
  LET ls_sql = ls_sql.subString(1,ls_sql.getIndexOf("WHERE ",1)+5),
               ls_tmp_str.trim(),
               ls_sql.subString(ls_sql.getIndexOf(" ORDER BY",1),ls_sql.getLength())
  RETURN ls_sql
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 設定查詢畫面的顯現資料.
# Input parameter: pi_start_index  INTEGER  所要顯現的查詢資料起始位置
#                  pi_end_index    INTEGER  所要顯現的查詢資料結束位置
# Return code....: void
# Usage..........: CALL cl_qry_set_display_data(li_start_index, li_end_index)
# Date & Author..: 2003/07/08 by Hiko
##########################################################################
 
FUNCTION cl_qry_set_display_data(pi_start_index, pi_end_index)
  DEFINE pi_start_index,pi_end_index LIKE type_file.num10          #No.FUN-690005 INTEGER
  DEFINE li_i,li_j LIKE type_file.num10          #No.FUN-690005 INTEGER
 
  CALL g_ma_qry_tmp.clear()
 
  FOR li_i = pi_start_index TO pi_end_index
      LET g_ma_qry_tmp[li_j+1].* = g_ma_qry[li_i].*
      LET li_j = li_j + 1
  END FOR
 
  CALL SET_COUNT(g_ma_qry_tmp.getLength())
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 採用DISPLAY ARRAY的方式來顯現查詢過後的資料.
# Input parameter: ps_hide_act     STRING    所要隱藏的Action Button
#                  pi_start_index  INTEGER   所要顯現的查詢資料起始位置
#                  pi_end_index    INTEGER   所要顯現的查詢資料結束位置
# Return code....: SMALLINT        是否繼續
#                  SMALLINT        是否重新查詢
#                  INTEGER         改變後的起始位置
# Usage..........: CALL cl_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
# Date & Author..: 2003/07/08 by Hiko
# Modify.........: 2003/09/15 by Hiko : 因為DISPLAY ARRAY不需要check,因此將cl_qry_reset_multi_sel移除.
##########################################################################
 
FUNCTION cl_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
  DEFINE ps_hide_act STRING,
         pi_start_index,pi_end_index LIKE type_file.num10          #No.FUN-690005 INTEGER
  DEFINE li_continue,li_reconstruct  LIKE type_file.num5           #No.FUN-690005 SMALLINT
  DEFINE li_i LIKE type_file.num5           #No.FUN-690005 SMALLINT    #2005/05/03 FUN-550021 Add By Lifeng
 
  DISPLAY ARRAY g_ma_qry_tmp TO s_xxx.* 
     BEFORE DISPLAY
        CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
        IF (ps_hide_act IS NOT NULL) THEN   
           CALL cl_set_act_visible(ps_hide_act, FALSE)
        END IF
        #No.FUN-760072 --start--
        SELECT COUNT(*) INTO li_i FROM gav_file
         WHERE gav01=g_qryparam.form AND gav32 IS NOT NULL
        IF li_i > 0 THEN
           CALL cl_set_act_visible("qry_string",TRUE)
        ELSE
           SELECT COUNT(*) INTO li_i FROM gac_file
            WHERE gac01=g_qryparam.form AND gac15 IS NOT NULL
           IF li_i > 0 THEN
              CALL cl_set_act_visible("qry_string",TRUE)
           ELSE
              CALL cl_set_act_visible("qry_string",FALSE)
           END IF
        END IF
        #No.FUN-760072 ---end---

    ON ACTION prevpage
       IF ((pi_start_index - g_qryparam.pagecount) >= 1) THEN
          LET pi_start_index = pi_start_index - g_qryparam.pagecount
       END IF
       LET li_continue = TRUE
       EXIT DISPLAY
 
    ON ACTION nextpage
       IF ((pi_start_index + g_qryparam.pagecount) <= g_ma_qry.getLength()) THEN
          LET pi_start_index = pi_start_index + g_qryparam.pagecount
       END IF
       LET li_continue = TRUE
       EXIT DISPLAY

    ON ACTION refresh
       LET pi_start_index = 1
       LET li_continue = TRUE
       EXIT DISPLAY
 
    ON ACTION reconstruct
       LET li_reconstruct = TRUE
       LET li_continue = TRUE
       #2005/05/03 FUN-550021 Add By Lifeng Start
       CALL ma_cons_lif.clear()
       FOR li_i = 1 TO ma_multi_rec.getLength() 
           CALL ma_multi_rec[li_i].value.clear()
       END FOR
       #2005/05/03 Add By Lifeng End
       EXIT DISPLAY
 
    ON ACTION accept
       CALL cl_qry_accept(pi_start_index+ARR_CURR()-1)
       LET li_continue = FALSE
       EXIT DISPLAY
 
# 2003/11/07 by Hiko : 因為將原本create_qry.4ad寫到tiptop.4ad內,且避免原本Enter
#                      的預設功能被改寫,因此先將此段程式mark起來.
#   ON ACTION enter # 2003/06/03 by Hiko : 為了讓'Enter'與'Accept'功能相同的設定.
#      CALL cl_qry_accept(pi_start_index+ARR_CURR()-1)
#      LET li_continue = FALSE
#      EXIT DISPLAY
#

    ON ACTION cancel
       CALL cl_qry_cancel()
       LET li_continue = FALSE
       EXIT DISPLAY
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
     #No.FUN-640269 --start--
     ON ACTION exporttoexcel
        #MOD-880105-begin-modify
        LET w = ui.Window.getCurrent()
        LET n = w.getNode()
        CALL cl_export_to_excel(n,base.TypeInfo.create(g_ma_qry),'','')
       #CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
        #MOD-880105-end-modify
     #No.FUN-640269 ---end---
 
     #No.FUN-760072 --start--
     ON ACTION qry_string
        CALL cl_qry_string("detail")
     #No.FUN-760072 ---end---
 
     #No.FUN-960070 --start--
     AFTER DISPLAY
        CALL cl_set_act_visible("qry_string",TRUE)
     #No.FUN-960070 ---end---
 
  END DISPLAY
  #CALL cl_set_act_visible("accept,cancel", TRUE)  mark by FUN-710071 沒有其他程式設為False
# CALL cl_set_act_visible("qry_string",TRUE)           #No.CHI-840075 #No.FUN-960070 mark
 
  RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 採用INPUT ARRAY的方式來顯現查詢過後的資料.
# Input parameter: ps_hide_act     STRING   所要隱藏的Action Button
#                  pi_start_index  INTEGER  所要顯現的查詢資料起始位置
#                  pi_end_index    INTEGER  所要顯現的查詢資料結束位置
# Return code....: SMALLINT        是否繼續
#                  SMALLINT        是否重新查詢
#                  INTEGER         改變後的起始位置
# Usage..........: CALL cl_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
# Date & Author..: 2003/07/08 by Hiko
##########################################################################
 
FUNCTION cl_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
  DEFINE ps_hide_act STRING,
         pi_start_index,pi_end_index LIKE type_file.num10          #No.FUN-690005 INTEGER
  DEFINE li_i LIKE type_file.num10          #No.FUN-690005 INTEGER
  DEFINE li_continue,li_reconstruct LIKE type_file.num5           #No.FUN-690005 SMALLINT
 
  INPUT ARRAY g_ma_qry_tmp WITHOUT DEFAULTS FROM s_xxx.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE,UNBUFFERED)   #No.FUN-870043
    BEFORE INPUT
      CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
       IF (ps_hide_act IS NOT NULL) THEN   
          CALL cl_set_act_visible(ps_hide_act, FALSE)
       END IF
       #No.FUN-760072 --start--
       SELECT COUNT(*) INTO li_i FROM gav_file
        WHERE gav01=g_qryparam.form AND gav32 IS NOT NULL
       IF li_i > 0 THEN
          CALL cl_set_act_visible("qry_string",TRUE)
       ELSE
          SELECT COUNT(*) INTO li_i FROM gac_file
           WHERE gac01=g_qryparam.form AND gac15 IS NOT NULL
          IF li_i > 0 THEN
             CALL cl_set_act_visible("qry_string",TRUE)
          ELSE
             CALL cl_set_act_visible("qry_string",FALSE)
          END IF
       END IF
       #No.FUN-760072 ---end---
    ON ACTION prevpage
       CALL GET_FLDBUF(s_xxx.check) RETURNING g_ma_qry_tmp[ARR_CURR()].check
       CALL cl_qry_reset_multi_sel(pi_start_index, pi_end_index)
 
       IF ((pi_start_index - g_qryparam.pagecount) >= 1) THEN
          LET pi_start_index = pi_start_index - g_qryparam.pagecount
       END IF
 
       LET li_continue = TRUE
 
       EXIT INPUT
    ON ACTION nextpage
       CALL GET_FLDBUF(s_xxx.check) RETURNING g_ma_qry_tmp[ARR_CURR()].check
       CALL cl_qry_reset_multi_sel(pi_start_index, pi_end_index)
 
       IF ((pi_start_index + g_qryparam.pagecount) <= g_ma_qry.getLength()) THEN
          LET pi_start_index = pi_start_index + g_qryparam.pagecount
       END IF
 
       LET li_continue = TRUE
 
       EXIT INPUT
    ON ACTION refresh
       FOR li_i = 1 TO g_ma_qry.getLength()
           LET g_ma_qry[li_i].check = 'N'
       END FOR
 
       LET pi_start_index = 1
       LET li_continue = TRUE
 
       EXIT INPUT
    ON ACTION reconstruct
       LET li_reconstruct = TRUE
       LET li_continue = TRUE
       #2005/05/03 FUN-550021 Add By Lifeng Start
       CALL ma_cons_lif.clear()  
       FOR li_i = 1 TO ma_multi_rec.getLength() 
           CALL ma_multi_rec[li_i].value.clear()
       END FOR
       #2005/05/03 Add By Lifeng End
        
       EXIT INPUT
    ON ACTION accept
       IF ARR_CURR() > 0 THEN #FUN-980030:避免查不到資料時的錯誤
          CALL GET_FLDBUF(s_xxx.check) RETURNING g_ma_qry_tmp[ARR_CURR()].check
          CALL cl_qry_reset_multi_sel(pi_start_index, pi_end_index)
          CALL cl_qry_accept(pi_start_index+ARR_CURR()-1)
       END IF
       LET li_continue = FALSE
 
       EXIT INPUT
#   ON ACTION enter # 2003/06/03 by Hiko : 為了讓'Enter'與'Accept'功能相同的設定.
#      CALL GET_FLDBUF(s_xxx.check) RETURNING ma_qry_tmp[ARR_CURR()].check
#      CALL cl_qry_reset_multi_sel(pi_start_index, pi_end_index)
#      CALL cl_qry_accept(pi_start_index+ARR_CURR()-1)
#      LET li_continue = FALSE
#
#      EXIT INPUT
    ON ACTION cancel
       CALL cl_qry_cancel()
       LET li_continue = FALSE
 
       EXIT INPUT
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
  
     #No.FUN-640269 --start--
     ON ACTION exporttoexcel
        #MOD-880105-begin-modify
        LET w = ui.Window.getCurrent()
        LET n = w.getNode()
        CALL cl_export_to_excel(n,base.TypeInfo.create(g_ma_qry),'','')
       #CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ma_qry),'','')
        #MOD-880105-end-modify
     #No.FUN-640269 ---end---
 
     #No.FUN-760072 --start--
     ON ACTION qry_string
        CALL cl_qry_string("detail")
     #No.FUN-760072 ---end---
 
     #No.FUN-870043 --start--
     ON ACTION selectall
        FOR li_i = 1 TO g_ma_qry_tmp.getLength()
            LET g_ma_qry_tmp[li_i].check = "Y"
        END FOR
     ON ACTION select_none
        FOR li_i = 1 TO g_ma_qry_tmp.getLength()
            LET g_ma_qry_tmp[li_i].check = "N"
        END FOR
     #No.FUN-870043 ---end---
 
     #No.FUN-960070 --start--
     AFTER INPUT
        CALL cl_set_act_visible("qry_string",TRUE)
     #No.FUN-960070 ---end---
 
  END INPUT
# CALL cl_set_act_visible("qry_string",TRUE)            #No.CHI-840075  #No.FUN-960070 mark

  RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 重設查詢資料關於'check'欄位的值.
# Input parameter: pi_start_index  INTEGER  所要顯現的查詢資料起始位置
#                  pi_end_index    INTEGER  所要顯現的查詢資料結束位置
# Return code....: void
# Usage..........: CALL cl_qry_reset_multi_sel(pi_start_index, pi_end_index)
# Date & Author..: 2003/07/08 by Hiko
##########################################################################
 
FUNCTION cl_qry_reset_multi_sel(pi_start_index, pi_end_index)
  DEFINE pi_start_index,pi_end_index LIKE type_file.num10          #No.FUN-690005 INTEGER
  DEFINE li_i,li_j LIKE type_file.num10          #No.FUN-690005 INTEGER
 
  FOR li_i = pi_start_index TO pi_end_index
      LET g_ma_qry[li_i].check = g_ma_qry_tmp[li_j+1].check
      LET li_j = li_j + 1
  END FOR
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 選擇並確認資料.
# Input parameter: pi_sel_index  INTEGER  所選擇的資料索引
# Return code....: void
# Usage..........: CALL cl_qry_accept('2')
# Date & Author..: 2003/07/08 by Hiko
##########################################################################
 
FUNCTION cl_qry_accept(pi_sel_index)
  DEFINE pi_sel_index  LIKE type_file.num10          #No.FUN-690005 INTEGER
  DEFINE lsb_multi_sel base.StringBuffer,
         li_i LIKE type_file.num10          #No.FUN-690005 INTEGER
 
  IF (g_qryparam.state = 'i') THEN
     # 2003/11/13 by Hiko : 因為前面的程式段曾經抓取資料過,因此這裡要重新建立,以避免資料並非i從第一個開始抓.
     LET mst_ret_field_index = base.StringTokenizer.create(msb_ret_field_index.toString(), ",")
 
     CASE mi_ret_count
       WHEN 1
         LET ms_ret1 = cl_qry_get_ret_value(pi_sel_index, mst_ret_field_index.nextToken())
       WHEN 2
         LET ms_ret1 = cl_qry_get_ret_value(pi_sel_index, mst_ret_field_index.nextToken())
         LET ms_ret2 = cl_qry_get_ret_value(pi_sel_index, mst_ret_field_index.nextToken())
       WHEN 3
         LET ms_ret1 = cl_qry_get_ret_value(pi_sel_index, mst_ret_field_index.nextToken())
         LET ms_ret2 = cl_qry_get_ret_value(pi_sel_index, mst_ret_field_index.nextToken())
         LET ms_ret3 = cl_qry_get_ret_value(pi_sel_index, mst_ret_field_index.nextToken())
        WHEN 4    #MOD-570211  #2005/05/03 by Lifeng
         LET ms_ret1 = cl_qry_get_ret_value(pi_sel_index, mst_ret_field_index.nextToken())
         LET ms_ret2 = cl_qry_get_ret_value(pi_sel_index, mst_ret_field_index.nextToken())
         LET ms_ret3 = cl_qry_get_ret_value(pi_sel_index, mst_ret_field_index.nextToken())
         LET ms_ret4 = cl_qry_get_ret_value(pi_sel_index, mst_ret_field_index.nextToken())
        WHEN 5    #MOD-570211  #2005/05/03 by Lifeng
         LET ms_ret1 = cl_qry_get_ret_value(pi_sel_index, mst_ret_field_index.nextToken())
         LET ms_ret2 = cl_qry_get_ret_value(pi_sel_index, mst_ret_field_index.nextToken())
         LET ms_ret3 = cl_qry_get_ret_value(pi_sel_index, mst_ret_field_index.nextToken())
         LET ms_ret4 = cl_qry_get_ret_value(pi_sel_index, mst_ret_field_index.nextToken())
         LET ms_ret5 = cl_qry_get_ret_value(pi_sel_index, mst_ret_field_index.nextToken())
     END CASE
  ELSE
     LET lsb_multi_sel = base.StringBuffer.create()
   
     FOR li_i = 1 TO g_ma_qry.getLength()
         IF (g_ma_qry[li_i].check = 'Y') THEN
            IF (lsb_multi_sel.getLength() = 0) THEN
               CALL lsb_multi_sel.append(cl_qry_get_ret_value(li_i, mi_multi_ret_field_index))
            ELSE
               CALL lsb_multi_sel.append("|" || cl_qry_get_ret_value(li_i, mi_multi_ret_field_index))
            END IF
         END IF    
     END FOR
 
     LET ms_ret1 = lsb_multi_sel.toString()
  END IF
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 取消選擇.
# Input parameter: none
# Return code....: void
# Usage..........: CALL cl_qry_cancel()
# Date & Author..: 2003/07/08 by Hiko
##########################################################################
 
FUNCTION cl_qry_cancel()
  LET INT_FLAG = FALSE
  #2003/10/16byHiko:如果是在CONSTRUCT時開窗,則忽略所有的預設值.
  IF (g_qryparam.state = 'i') THEN
     CASE mi_ret_count
       WHEN 1
         LET ms_ret1 = g_qryparam.default1
       WHEN 2
         LET ms_ret1 = g_qryparam.default1
         LET ms_ret2 = g_qryparam.default2
       WHEN 3
         LET ms_ret1 = g_qryparam.default1
         LET ms_ret2 = g_qryparam.default2
         LET ms_ret3 = g_qryparam.default3
        WHEN 4    #MOD-570211    #2005/05/03 by Lifeng
         LET ms_ret1 = g_qryparam.default1
         LET ms_ret2 = g_qryparam.default2
         LET ms_ret3 = g_qryparam.default3
         LET ms_ret4 = g_qryparam.default4
        WHEN 5    #MOD-570211    #2005/05/03 by Lifeng
         LET ms_ret1 = g_qryparam.default1
         LET ms_ret2 = g_qryparam.default2
         LET ms_ret3 = g_qryparam.default3
         LET ms_ret4 = g_qryparam.default4
         LET ms_ret5 = g_qryparam.default5
     END CASE
  ELSE
     LET ms_ret1 = NULL
     LET ms_ret2 = NULL
     LET ms_ret3 = NULL
     LET ms_ret4 = NULL
     LET ms_ret5 = NULL
  END IF
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: CONSTRUCT區塊變數的初始化.
# Input parameter: none
# Return code....: void
# Usage..........: CALL cl_qry_init_cons()
# Date & Author..: 2003/07/08 by Hiko
##########################################################################
 
 
FUNCTION cl_qry_init_cons()
  INITIALIZE ms_xxx01 TO NULL
  INITIALIZE ms_xxx02 TO NULL
  INITIALIZE ms_xxx03 TO NULL
  INITIALIZE ms_xxx04 TO NULL
  INITIALIZE ms_xxx05 TO NULL
  INITIALIZE ms_xxx06 TO NULL
  INITIALIZE ms_xxx07 TO NULL
  INITIALIZE ms_xxx08 TO NULL
  INITIALIZE ms_xxx09 TO NULL
  INITIALIZE ms_xxx10 TO NULL
  INITIALIZE ms_xxx11 TO NULL
  INITIALIZE ms_xxx12 TO NULL
  INITIALIZE ms_xxx13 TO NULL
  INITIALIZE ms_xxx14 TO NULL
  INITIALIZE ms_xxx15 TO NULL
  INITIALIZE ms_xxx16 TO NULL
  INITIALIZE ms_xxx17 TO NULL
  INITIALIZE ms_xxx18 TO NULL
  INITIALIZE ms_xxx19 TO NULL
  INITIALIZE ms_xxx20 TO NULL
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 定義CONSTRUCT區塊.
# Input parameter: none
# Return code....: void
# Usage..........: CALL cl_qry_def_cons()
# Date & Author..: 2003/07/08 by Hiko
##########################################################################
 
FUNCTION cl_qry_def_cons()
 #No.TQC-640180  --start
 #start MOD-590436 mark
 ##2005/05/03 FUN-550021 Add By Lifeng For 料件多屬性管理 
 ##在這里增加了一個判別，如果系統要進行多屬性管理，并且在本次查詢的欄位中
 ##包含表示料件編號的欄位，則進入自定義的CONSTRUCT界面，否則還是按照標准
 ##CONSTRUCT邏輯進行
 #IF ( g_sma.sma120 = 'Y' )AND( g_imafldlist.getLength()>0 ) THEN
 #  #這里進入自定義的CONSTRUCT界面
 #  CALL cl_multi_cons()
 #ELSE
    #下面這些是原有的代碼 
 #end MOD-590436 mark
 IF ( g_sma.sma120 = 'Y' )AND( g_imafldlist.getLength()>0 ) 
    AND cl_null(FGL_GETENV("WEBAREA")) THEN  #非WEB區  #WEB-C40003
    #這里進入自定義的CONSTRUCT界面
    CALL cl_multi_cons()
 ELSE
    #下面這些是原有的代碼 
 #No.TQC-640180  --end
 
    CALL cl_set_act_visible("about,help", FALSE)    #TQC-620117
    CASE mi_col_count
      WHEN  1 CALL cl_qry_cons01()
      WHEN  2 CALL cl_qry_cons02()
      WHEN  3 CALL cl_qry_cons03()
      WHEN  4 CALL cl_qry_cons04()
      WHEN  5 CALL cl_qry_cons05()
      WHEN  6 CALL cl_qry_cons06()
      WHEN  7 CALL cl_qry_cons07()
      WHEN  8 CALL cl_qry_cons08()
      WHEN  9 CALL cl_qry_cons09()
      WHEN 10 CALL cl_qry_cons10()
      WHEN 11 CALL cl_qry_cons11()
      WHEN 12 CALL cl_qry_cons12()
      WHEN 13 CALL cl_qry_cons13()
      WHEN 14 CALL cl_qry_cons14()
      WHEN 15 CALL cl_qry_cons15()
      WHEN 16 CALL cl_qry_cons16()
      WHEN 17 CALL cl_qry_cons17()
      WHEN 18 CALL cl_qry_cons18()
      WHEN 19 CALL cl_qry_cons19()
      WHEN 20 CALL cl_qry_cons20()
    END CASE
 #END IF                          #MOD-590436 mark
 END IF                           #TQC-640180 remove mark
 ##2005/05/03 Add By Lifeng End   #MOD-590436 mark
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 依照畫面的欄位數(1~20)來設定CONSTRUCT區塊.
# Input parameter: none
# Return code....: void
# Usage..........: CALL cl_qry_cons01()
# Date & Author..: 2003/07/08 by Hiko
##########################################################################
 
FUNCTION cl_qry_cons01()
  CONSTRUCT ms_cons_where ON ms_xxx01
               FROM s_xxx[1].xxx01
     AFTER CONSTRUCT
        CALL GET_FLDBUF(s_xxx[1].xxx01) RETURNING ms_xxx01
        CALL cl_qry_chg_type("xxx01",ms_xxx01) RETURNING ms_xxx01
        DISPLAY ms_xxx01
             TO s_xxx[1].xxx01
 
     ON ACTION about         #TQC-620117
        CALL cl_about()      #TQC-620117  
     ON ACTION help          #TQC-620117
        CALL cl_show_help()  #TQC-620117
     ON ACTION controlg      #TQC-620117
        CALL cl_cmdask()     #TQC-620117 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
  
  END CONSTRUCT
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
##########################################################################
 
FUNCTION cl_qry_cons02()
  CONSTRUCT ms_cons_where ON ms_xxx01,ms_xxx02
               FROM s_xxx[1].xxx01,s_xxx[1].xxx02
     AFTER CONSTRUCT
        CALL GET_FLDBUF(s_xxx[1].xxx01) RETURNING ms_xxx01
        CALL GET_FLDBUF(s_xxx[1].xxx02) RETURNING ms_xxx02
        CALL cl_qry_chg_type("xxx01",ms_xxx01) RETURNING ms_xxx01
        CALL cl_qry_chg_type("xxx02",ms_xxx02) RETURNING ms_xxx02
        DISPLAY ms_xxx01,ms_xxx02
             TO s_xxx[1].xxx01,s_xxx[1].xxx02
 
     ON ACTION about         #TQC-620117
        CALL cl_about()      #TQC-620117  
     ON ACTION help          #TQC-620117
        CALL cl_show_help()  #TQC-620117
     ON ACTION controlg      #TQC-620117
        CALL cl_cmdask()     #TQC-620117 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
  
  END CONSTRUCT
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
##########################################################################
 
FUNCTION cl_qry_cons03()
  CONSTRUCT ms_cons_where ON ms_xxx01,ms_xxx02,ms_xxx03
               FROM s_xxx[1].xxx01,s_xxx[1].xxx02,s_xxx[1].xxx03
     AFTER CONSTRUCT
        CALL GET_FLDBUF(s_xxx[1].xxx01) RETURNING ms_xxx01
        CALL GET_FLDBUF(s_xxx[1].xxx02) RETURNING ms_xxx02
        CALL GET_FLDBUF(s_xxx[1].xxx03) RETURNING ms_xxx03
        CALL cl_qry_chg_type("xxx01",ms_xxx01) RETURNING ms_xxx01
        CALL cl_qry_chg_type("xxx02",ms_xxx02) RETURNING ms_xxx02
        CALL cl_qry_chg_type("xxx03",ms_xxx03) RETURNING ms_xxx03
        DISPLAY ms_xxx01,ms_xxx02,ms_xxx03
             TO s_xxx[1].xxx01,s_xxx[1].xxx02,s_xxx[1].xxx03
 
     ON ACTION about         #TQC-620117
        CALL cl_about()      #TQC-620117  
     ON ACTION help          #TQC-620117
        CALL cl_show_help()  #TQC-620117
     ON ACTION controlg      #TQC-620117
        CALL cl_cmdask()     #TQC-620117 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
  
  END CONSTRUCT
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
##########################################################################
 
FUNCTION cl_qry_cons04()
  CONSTRUCT ms_cons_where ON ms_xxx01,ms_xxx02,ms_xxx03,ms_xxx04
               FROM s_xxx[1].xxx01,s_xxx[1].xxx02,s_xxx[1].xxx03,s_xxx[1].xxx04
     AFTER CONSTRUCT
        CALL GET_FLDBUF(s_xxx[1].xxx01) RETURNING ms_xxx01
        CALL GET_FLDBUF(s_xxx[1].xxx02) RETURNING ms_xxx02
        CALL GET_FLDBUF(s_xxx[1].xxx03) RETURNING ms_xxx03
        CALL GET_FLDBUF(s_xxx[1].xxx04) RETURNING ms_xxx04
        CALL cl_qry_chg_type("xxx01",ms_xxx01) RETURNING ms_xxx01
        CALL cl_qry_chg_type("xxx02",ms_xxx02) RETURNING ms_xxx02
        CALL cl_qry_chg_type("xxx03",ms_xxx03) RETURNING ms_xxx03
        CALL cl_qry_chg_type("xxx04",ms_xxx04) RETURNING ms_xxx04
        DISPLAY ms_xxx01,ms_xxx02,ms_xxx03,ms_xxx04
             TO s_xxx[1].xxx01,s_xxx[1].xxx02,s_xxx[1].xxx03,s_xxx[1].xxx04
 
     ON ACTION about         #TQC-620117
        CALL cl_about()      #TQC-620117  
     ON ACTION help          #TQC-620117
        CALL cl_show_help()  #TQC-620117
     ON ACTION controlg      #TQC-620117
        CALL cl_cmdask()     #TQC-620117 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
  
  END CONSTRUCT
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
##########################################################################
 
FUNCTION cl_qry_cons05()
  CONSTRUCT ms_cons_where ON ms_xxx01,ms_xxx02,ms_xxx03,ms_xxx04,ms_xxx05
               FROM s_xxx[1].xxx01,s_xxx[1].xxx02,s_xxx[1].xxx03,s_xxx[1].xxx04,s_xxx[1].xxx05
     AFTER CONSTRUCT
        CALL GET_FLDBUF(s_xxx[1].xxx01) RETURNING ms_xxx01
        CALL GET_FLDBUF(s_xxx[1].xxx02) RETURNING ms_xxx02
        CALL GET_FLDBUF(s_xxx[1].xxx03) RETURNING ms_xxx03
        CALL GET_FLDBUF(s_xxx[1].xxx04) RETURNING ms_xxx04
        CALL GET_FLDBUF(s_xxx[1].xxx05) RETURNING ms_xxx05
        CALL cl_qry_chg_type("xxx01",ms_xxx01) RETURNING ms_xxx01
        CALL cl_qry_chg_type("xxx02",ms_xxx02) RETURNING ms_xxx02
        CALL cl_qry_chg_type("xxx03",ms_xxx03) RETURNING ms_xxx03
        CALL cl_qry_chg_type("xxx04",ms_xxx04) RETURNING ms_xxx04
        CALL cl_qry_chg_type("xxx05",ms_xxx05) RETURNING ms_xxx05
        DISPLAY ms_xxx01,ms_xxx02,ms_xxx03,ms_xxx04,ms_xxx05
             TO s_xxx[1].xxx01,s_xxx[1].xxx02,s_xxx[1].xxx03,s_xxx[1].xxx04,
                s_xxx[1].xxx05
 
     ON ACTION about         #TQC-620117
        CALL cl_about()      #TQC-620117  
     ON ACTION help          #TQC-620117
        CALL cl_show_help()  #TQC-620117
     ON ACTION controlg      #TQC-620117
        CALL cl_cmdask()     #TQC-620117 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
  END CONSTRUCT
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
##########################################################################
 
FUNCTION cl_qry_cons06()
  CONSTRUCT ms_cons_where ON ms_xxx01,ms_xxx02,ms_xxx03,ms_xxx04,ms_xxx05,
                    ms_xxx06
               FROM s_xxx[1].xxx01,s_xxx[1].xxx02,s_xxx[1].xxx03,s_xxx[1].xxx04,s_xxx[1].xxx05,
                    s_xxx[1].xxx06
     AFTER CONSTRUCT
        CALL GET_FLDBUF(s_xxx[1].xxx01) RETURNING ms_xxx01
        CALL GET_FLDBUF(s_xxx[1].xxx02) RETURNING ms_xxx02
        CALL GET_FLDBUF(s_xxx[1].xxx03) RETURNING ms_xxx03
        CALL GET_FLDBUF(s_xxx[1].xxx04) RETURNING ms_xxx04
        CALL GET_FLDBUF(s_xxx[1].xxx05) RETURNING ms_xxx05
        CALL GET_FLDBUF(s_xxx[1].xxx06) RETURNING ms_xxx06
        CALL cl_qry_chg_type("xxx01",ms_xxx01) RETURNING ms_xxx01
        CALL cl_qry_chg_type("xxx02",ms_xxx02) RETURNING ms_xxx02
        CALL cl_qry_chg_type("xxx03",ms_xxx03) RETURNING ms_xxx03
        CALL cl_qry_chg_type("xxx04",ms_xxx04) RETURNING ms_xxx04
        CALL cl_qry_chg_type("xxx05",ms_xxx05) RETURNING ms_xxx05
        CALL cl_qry_chg_type("xxx06",ms_xxx06) RETURNING ms_xxx06
        DISPLAY ms_xxx01,ms_xxx02,ms_xxx03,ms_xxx04,ms_xxx05,ms_xxx06
             TO s_xxx[1].xxx01,s_xxx[1].xxx02,s_xxx[1].xxx03,s_xxx[1].xxx04,
                s_xxx[1].xxx05,s_xxx[1].xxx06
 
     ON ACTION about         #TQC-620117
        CALL cl_about()      #TQC-620117  
     ON ACTION help          #TQC-620117
        CALL cl_show_help()  #TQC-620117
     ON ACTION controlg      #TQC-620117
        CALL cl_cmdask()     #TQC-620117 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
  
  END CONSTRUCT
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
##########################################################################
 
FUNCTION cl_qry_cons07()
  CONSTRUCT ms_cons_where ON ms_xxx01,ms_xxx02,ms_xxx03,ms_xxx04,ms_xxx05,
                    ms_xxx06,ms_xxx07
               FROM s_xxx[1].xxx01,s_xxx[1].xxx02,s_xxx[1].xxx03,s_xxx[1].xxx04,s_xxx[1].xxx05,
                    s_xxx[1].xxx06,s_xxx[1].xxx07
     AFTER CONSTRUCT
        CALL GET_FLDBUF(s_xxx[1].xxx01) RETURNING ms_xxx01
        CALL GET_FLDBUF(s_xxx[1].xxx02) RETURNING ms_xxx02
        CALL GET_FLDBUF(s_xxx[1].xxx03) RETURNING ms_xxx03
        CALL GET_FLDBUF(s_xxx[1].xxx04) RETURNING ms_xxx04
        CALL GET_FLDBUF(s_xxx[1].xxx05) RETURNING ms_xxx05
        CALL GET_FLDBUF(s_xxx[1].xxx06) RETURNING ms_xxx06
        CALL GET_FLDBUF(s_xxx[1].xxx07) RETURNING ms_xxx07
        CALL cl_qry_chg_type("xxx01",ms_xxx01) RETURNING ms_xxx01
        CALL cl_qry_chg_type("xxx02",ms_xxx02) RETURNING ms_xxx02
        CALL cl_qry_chg_type("xxx03",ms_xxx03) RETURNING ms_xxx03
        CALL cl_qry_chg_type("xxx04",ms_xxx04) RETURNING ms_xxx04
        CALL cl_qry_chg_type("xxx05",ms_xxx05) RETURNING ms_xxx05
        CALL cl_qry_chg_type("xxx06",ms_xxx06) RETURNING ms_xxx06
        CALL cl_qry_chg_type("xxx07",ms_xxx07) RETURNING ms_xxx07
        DISPLAY ms_xxx01,ms_xxx02,ms_xxx03,ms_xxx04,ms_xxx05,ms_xxx06,ms_xxx07
             TO s_xxx[1].xxx01,s_xxx[1].xxx02,s_xxx[1].xxx03,s_xxx[1].xxx04,
                s_xxx[1].xxx05,s_xxx[1].xxx06,s_xxx[1].xxx07
 
     ON ACTION about         #TQC-620117
        CALL cl_about()      #TQC-620117  
     ON ACTION help          #TQC-620117
        CALL cl_show_help()  #TQC-620117
     ON ACTION controlg      #TQC-620117
        CALL cl_cmdask()     #TQC-620117 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
  
  END CONSTRUCT
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
##########################################################################
 
FUNCTION cl_qry_cons08()
  CONSTRUCT ms_cons_where ON ms_xxx01,ms_xxx02,ms_xxx03,ms_xxx04,ms_xxx05,
                    ms_xxx06,ms_xxx07,ms_xxx08
               FROM s_xxx[1].xxx01,s_xxx[1].xxx02,s_xxx[1].xxx03,s_xxx[1].xxx04,s_xxx[1].xxx05,
                    s_xxx[1].xxx06,s_xxx[1].xxx07,s_xxx[1].xxx08
     AFTER CONSTRUCT
        CALL GET_FLDBUF(s_xxx[1].xxx01) RETURNING ms_xxx01
        CALL GET_FLDBUF(s_xxx[1].xxx02) RETURNING ms_xxx02
        CALL GET_FLDBUF(s_xxx[1].xxx03) RETURNING ms_xxx03
        CALL GET_FLDBUF(s_xxx[1].xxx04) RETURNING ms_xxx04
        CALL GET_FLDBUF(s_xxx[1].xxx05) RETURNING ms_xxx05
        CALL GET_FLDBUF(s_xxx[1].xxx06) RETURNING ms_xxx06
        CALL GET_FLDBUF(s_xxx[1].xxx07) RETURNING ms_xxx07
        CALL GET_FLDBUF(s_xxx[1].xxx08) RETURNING ms_xxx08
        CALL cl_qry_chg_type("xxx01",ms_xxx01) RETURNING ms_xxx01
        CALL cl_qry_chg_type("xxx02",ms_xxx02) RETURNING ms_xxx02
        CALL cl_qry_chg_type("xxx03",ms_xxx03) RETURNING ms_xxx03
        CALL cl_qry_chg_type("xxx04",ms_xxx04) RETURNING ms_xxx04
        CALL cl_qry_chg_type("xxx05",ms_xxx05) RETURNING ms_xxx05
        CALL cl_qry_chg_type("xxx06",ms_xxx06) RETURNING ms_xxx06
        CALL cl_qry_chg_type("xxx07",ms_xxx07) RETURNING ms_xxx07
        CALL cl_qry_chg_type("xxx08",ms_xxx08) RETURNING ms_xxx08
        DISPLAY ms_xxx01,ms_xxx02,ms_xxx03,ms_xxx04,ms_xxx05,ms_xxx06,ms_xxx07,
                ms_xxx08
             TO s_xxx[1].xxx01,s_xxx[1].xxx02,s_xxx[1].xxx03,s_xxx[1].xxx04,
                s_xxx[1].xxx05,s_xxx[1].xxx06,s_xxx[1].xxx07,s_xxx[1].xxx08
 
     ON ACTION about         #TQC-620117
        CALL cl_about()      #TQC-620117  
     ON ACTION help          #TQC-620117
        CALL cl_show_help()  #TQC-620117
     ON ACTION controlg      #TQC-620117
        CALL cl_cmdask()     #TQC-620117 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
  
  END CONSTRUCT
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
##########################################################################
 
FUNCTION cl_qry_cons09()
  CONSTRUCT ms_cons_where ON ms_xxx01,ms_xxx02,ms_xxx03,ms_xxx04,ms_xxx05,
                    ms_xxx06,ms_xxx07,ms_xxx08,ms_xxx09
               FROM s_xxx[1].xxx01,s_xxx[1].xxx02,s_xxx[1].xxx03,s_xxx[1].xxx04,s_xxx[1].xxx05,
                    s_xxx[1].xxx06,s_xxx[1].xxx07,s_xxx[1].xxx08,s_xxx[1].xxx09
     AFTER CONSTRUCT
        CALL GET_FLDBUF(s_xxx[1].xxx01) RETURNING ms_xxx01
        CALL GET_FLDBUF(s_xxx[1].xxx02) RETURNING ms_xxx02
        CALL GET_FLDBUF(s_xxx[1].xxx03) RETURNING ms_xxx03
        CALL GET_FLDBUF(s_xxx[1].xxx04) RETURNING ms_xxx04
        CALL GET_FLDBUF(s_xxx[1].xxx05) RETURNING ms_xxx05
        CALL GET_FLDBUF(s_xxx[1].xxx06) RETURNING ms_xxx06
        CALL GET_FLDBUF(s_xxx[1].xxx07) RETURNING ms_xxx07
        CALL GET_FLDBUF(s_xxx[1].xxx08) RETURNING ms_xxx08
        CALL GET_FLDBUF(s_xxx[1].xxx09) RETURNING ms_xxx09
        CALL cl_qry_chg_type("xxx01",ms_xxx01) RETURNING ms_xxx01
        CALL cl_qry_chg_type("xxx02",ms_xxx02) RETURNING ms_xxx02
        CALL cl_qry_chg_type("xxx03",ms_xxx03) RETURNING ms_xxx03
        CALL cl_qry_chg_type("xxx04",ms_xxx04) RETURNING ms_xxx04
        CALL cl_qry_chg_type("xxx05",ms_xxx05) RETURNING ms_xxx05
        CALL cl_qry_chg_type("xxx06",ms_xxx06) RETURNING ms_xxx06
        CALL cl_qry_chg_type("xxx07",ms_xxx07) RETURNING ms_xxx07
        CALL cl_qry_chg_type("xxx08",ms_xxx08) RETURNING ms_xxx08
        CALL cl_qry_chg_type("xxx09",ms_xxx09) RETURNING ms_xxx09
        DISPLAY ms_xxx01,ms_xxx02,ms_xxx03,ms_xxx04,ms_xxx05,ms_xxx06,ms_xxx07,
                ms_xxx08,ms_xxx09
             TO s_xxx[1].xxx01,s_xxx[1].xxx02,s_xxx[1].xxx03,s_xxx[1].xxx04,
                s_xxx[1].xxx05,s_xxx[1].xxx06,s_xxx[1].xxx07,s_xxx[1].xxx08,
                s_xxx[1].xxx09
 
     ON ACTION about         #TQC-620117
        CALL cl_about()      #TQC-620117  
     ON ACTION help          #TQC-620117
        CALL cl_show_help()  #TQC-620117
     ON ACTION controlg      #TQC-620117
        CALL cl_cmdask()     #TQC-620117 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
  
  END CONSTRUCT
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
##########################################################################
 
FUNCTION cl_qry_cons10()
  CONSTRUCT ms_cons_where ON ms_xxx01,ms_xxx02,ms_xxx03,ms_xxx04,ms_xxx05,
                    ms_xxx06,ms_xxx07,ms_xxx08,ms_xxx09,ms_xxx10
               FROM s_xxx[1].xxx01,s_xxx[1].xxx02,s_xxx[1].xxx03,s_xxx[1].xxx04,s_xxx[1].xxx05,
                    s_xxx[1].xxx06,s_xxx[1].xxx07,s_xxx[1].xxx08,s_xxx[1].xxx09,s_xxx[1].xxx10
     AFTER CONSTRUCT
        CALL GET_FLDBUF(s_xxx[1].xxx01) RETURNING ms_xxx01
        CALL GET_FLDBUF(s_xxx[1].xxx02) RETURNING ms_xxx02
        CALL GET_FLDBUF(s_xxx[1].xxx03) RETURNING ms_xxx03
        CALL GET_FLDBUF(s_xxx[1].xxx04) RETURNING ms_xxx04
        CALL GET_FLDBUF(s_xxx[1].xxx05) RETURNING ms_xxx05
        CALL GET_FLDBUF(s_xxx[1].xxx06) RETURNING ms_xxx06
        CALL GET_FLDBUF(s_xxx[1].xxx07) RETURNING ms_xxx07
        CALL GET_FLDBUF(s_xxx[1].xxx08) RETURNING ms_xxx08
        CALL GET_FLDBUF(s_xxx[1].xxx09) RETURNING ms_xxx09
        CALL GET_FLDBUF(s_xxx[1].xxx10) RETURNING ms_xxx10
        CALL cl_qry_chg_type("xxx01",ms_xxx01) RETURNING ms_xxx01
        CALL cl_qry_chg_type("xxx02",ms_xxx02) RETURNING ms_xxx02
        CALL cl_qry_chg_type("xxx03",ms_xxx03) RETURNING ms_xxx03
        CALL cl_qry_chg_type("xxx04",ms_xxx04) RETURNING ms_xxx04
        CALL cl_qry_chg_type("xxx05",ms_xxx05) RETURNING ms_xxx05
        CALL cl_qry_chg_type("xxx06",ms_xxx06) RETURNING ms_xxx06
        CALL cl_qry_chg_type("xxx07",ms_xxx07) RETURNING ms_xxx07
        CALL cl_qry_chg_type("xxx08",ms_xxx08) RETURNING ms_xxx08
        CALL cl_qry_chg_type("xxx09",ms_xxx09) RETURNING ms_xxx09
        CALL cl_qry_chg_type("xxx10",ms_xxx10) RETURNING ms_xxx10
        DISPLAY ms_xxx01,ms_xxx02,ms_xxx03,ms_xxx04,ms_xxx05,ms_xxx06,ms_xxx07,
                ms_xxx08,ms_xxx09,ms_xxx10
             TO s_xxx[1].xxx01,s_xxx[1].xxx02,s_xxx[1].xxx03,s_xxx[1].xxx04,
                s_xxx[1].xxx05,s_xxx[1].xxx06,s_xxx[1].xxx07,s_xxx[1].xxx08,
                s_xxx[1].xxx09,s_xxx[1].xxx10
 
     ON ACTION about         #TQC-620117
        CALL cl_about()      #TQC-620117  
     ON ACTION help          #TQC-620117
        CALL cl_show_help()  #TQC-620117
     ON ACTION controlg      #TQC-620117
        CALL cl_cmdask()     #TQC-620117 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
  
  END CONSTRUCT
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
##########################################################################
 
FUNCTION cl_qry_cons11()
  CONSTRUCT ms_cons_where ON ms_xxx01,ms_xxx02,ms_xxx03,ms_xxx04,ms_xxx05,
                    ms_xxx06,ms_xxx07,ms_xxx08,ms_xxx09,ms_xxx10,
                    ms_xxx11
               FROM s_xxx[1].xxx01,s_xxx[1].xxx02,s_xxx[1].xxx03,s_xxx[1].xxx04,s_xxx[1].xxx05,
                    s_xxx[1].xxx06,s_xxx[1].xxx07,s_xxx[1].xxx08,s_xxx[1].xxx09,s_xxx[1].xxx10,
                    s_xxx[1].xxx11
     AFTER CONSTRUCT
        CALL GET_FLDBUF(s_xxx[1].xxx01) RETURNING ms_xxx01
        CALL GET_FLDBUF(s_xxx[1].xxx02) RETURNING ms_xxx02
        CALL GET_FLDBUF(s_xxx[1].xxx03) RETURNING ms_xxx03
        CALL GET_FLDBUF(s_xxx[1].xxx04) RETURNING ms_xxx04
        CALL GET_FLDBUF(s_xxx[1].xxx05) RETURNING ms_xxx05
        CALL GET_FLDBUF(s_xxx[1].xxx06) RETURNING ms_xxx06
        CALL GET_FLDBUF(s_xxx[1].xxx07) RETURNING ms_xxx07
        CALL GET_FLDBUF(s_xxx[1].xxx08) RETURNING ms_xxx08
        CALL GET_FLDBUF(s_xxx[1].xxx09) RETURNING ms_xxx09
        CALL GET_FLDBUF(s_xxx[1].xxx10) RETURNING ms_xxx10
        CALL GET_FLDBUF(s_xxx[1].xxx11) RETURNING ms_xxx11
        CALL cl_qry_chg_type("xxx01",ms_xxx01) RETURNING ms_xxx01
        CALL cl_qry_chg_type("xxx02",ms_xxx02) RETURNING ms_xxx02
        CALL cl_qry_chg_type("xxx03",ms_xxx03) RETURNING ms_xxx03
        CALL cl_qry_chg_type("xxx04",ms_xxx04) RETURNING ms_xxx04
        CALL cl_qry_chg_type("xxx05",ms_xxx05) RETURNING ms_xxx05
        CALL cl_qry_chg_type("xxx06",ms_xxx06) RETURNING ms_xxx06
        CALL cl_qry_chg_type("xxx07",ms_xxx07) RETURNING ms_xxx07
        CALL cl_qry_chg_type("xxx08",ms_xxx08) RETURNING ms_xxx08
        CALL cl_qry_chg_type("xxx09",ms_xxx09) RETURNING ms_xxx09
        CALL cl_qry_chg_type("xxx10",ms_xxx10) RETURNING ms_xxx10
        CALL cl_qry_chg_type("xxx11",ms_xxx11) RETURNING ms_xxx11
        DISPLAY ms_xxx01,ms_xxx02,ms_xxx03,ms_xxx04,ms_xxx05,ms_xxx06,ms_xxx07,
                ms_xxx08,ms_xxx09,ms_xxx10,ms_xxx11
             TO s_xxx[1].xxx01,s_xxx[1].xxx02,s_xxx[1].xxx03,s_xxx[1].xxx04,
                s_xxx[1].xxx05,s_xxx[1].xxx06,s_xxx[1].xxx07,s_xxx[1].xxx08,
                s_xxx[1].xxx09,s_xxx[1].xxx10,s_xxx[1].xxx11
 
     ON ACTION about         #TQC-620117
        CALL cl_about()      #TQC-620117  
     ON ACTION help          #TQC-620117
        CALL cl_show_help()  #TQC-620117
     ON ACTION controlg      #TQC-620117
        CALL cl_cmdask()     #TQC-620117 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
  
  END CONSTRUCT
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
##########################################################################
 
FUNCTION cl_qry_cons12()
  CONSTRUCT ms_cons_where ON ms_xxx01,ms_xxx02,ms_xxx03,ms_xxx04,ms_xxx05,
                    ms_xxx06,ms_xxx07,ms_xxx08,ms_xxx09,ms_xxx10,
                    ms_xxx11,ms_xxx12
               FROM s_xxx[1].xxx01,s_xxx[1].xxx02,s_xxx[1].xxx03,s_xxx[1].xxx04,s_xxx[1].xxx05,
                    s_xxx[1].xxx06,s_xxx[1].xxx07,s_xxx[1].xxx08,s_xxx[1].xxx09,s_xxx[1].xxx10,
                    s_xxx[1].xxx11,s_xxx[1].xxx12
     AFTER CONSTRUCT
        CALL GET_FLDBUF(s_xxx[1].xxx01) RETURNING ms_xxx01
        CALL GET_FLDBUF(s_xxx[1].xxx02) RETURNING ms_xxx02
        CALL GET_FLDBUF(s_xxx[1].xxx03) RETURNING ms_xxx03
        CALL GET_FLDBUF(s_xxx[1].xxx04) RETURNING ms_xxx04
        CALL GET_FLDBUF(s_xxx[1].xxx05) RETURNING ms_xxx05
        CALL GET_FLDBUF(s_xxx[1].xxx06) RETURNING ms_xxx06
        CALL GET_FLDBUF(s_xxx[1].xxx07) RETURNING ms_xxx07
        CALL GET_FLDBUF(s_xxx[1].xxx08) RETURNING ms_xxx08
        CALL GET_FLDBUF(s_xxx[1].xxx09) RETURNING ms_xxx09
        CALL GET_FLDBUF(s_xxx[1].xxx10) RETURNING ms_xxx10
        CALL GET_FLDBUF(s_xxx[1].xxx11) RETURNING ms_xxx11
        CALL GET_FLDBUF(s_xxx[1].xxx12) RETURNING ms_xxx12
        CALL cl_qry_chg_type("xxx01",ms_xxx01) RETURNING ms_xxx01
        CALL cl_qry_chg_type("xxx02",ms_xxx02) RETURNING ms_xxx02
        CALL cl_qry_chg_type("xxx03",ms_xxx03) RETURNING ms_xxx03
        CALL cl_qry_chg_type("xxx04",ms_xxx04) RETURNING ms_xxx04
        CALL cl_qry_chg_type("xxx05",ms_xxx05) RETURNING ms_xxx05
        CALL cl_qry_chg_type("xxx06",ms_xxx06) RETURNING ms_xxx06
        CALL cl_qry_chg_type("xxx07",ms_xxx07) RETURNING ms_xxx07
        CALL cl_qry_chg_type("xxx08",ms_xxx08) RETURNING ms_xxx08
        CALL cl_qry_chg_type("xxx09",ms_xxx09) RETURNING ms_xxx09
        CALL cl_qry_chg_type("xxx10",ms_xxx10) RETURNING ms_xxx10
        CALL cl_qry_chg_type("xxx11",ms_xxx11) RETURNING ms_xxx11
        CALL cl_qry_chg_type("xxx12",ms_xxx12) RETURNING ms_xxx12
        DISPLAY ms_xxx01,ms_xxx02,ms_xxx03,ms_xxx04,ms_xxx05,ms_xxx06,ms_xxx07,
                ms_xxx08,ms_xxx09,ms_xxx10,ms_xxx11,ms_xxx12
             TO s_xxx[1].xxx01,s_xxx[1].xxx02,s_xxx[1].xxx03,s_xxx[1].xxx04,
                s_xxx[1].xxx05,s_xxx[1].xxx06,s_xxx[1].xxx07,s_xxx[1].xxx08,
                s_xxx[1].xxx09,s_xxx[1].xxx10,s_xxx[1].xxx11,s_xxx[1].xxx12
 
     ON ACTION about         #TQC-620117
        CALL cl_about()      #TQC-620117  
     ON ACTION help          #TQC-620117
        CALL cl_show_help()  #TQC-620117
     ON ACTION controlg      #TQC-620117
        CALL cl_cmdask()     #TQC-620117 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
  
  END CONSTRUCT
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
##########################################################################
 
FUNCTION cl_qry_cons13()
  CONSTRUCT ms_cons_where ON ms_xxx01,ms_xxx02,ms_xxx03,ms_xxx04,ms_xxx05,
                    ms_xxx06,ms_xxx07,ms_xxx08,ms_xxx09,ms_xxx10,
                    ms_xxx11,ms_xxx12,ms_xxx13
               FROM s_xxx[1].xxx01,s_xxx[1].xxx02,s_xxx[1].xxx03,s_xxx[1].xxx04,s_xxx[1].xxx05,
                    s_xxx[1].xxx06,s_xxx[1].xxx07,s_xxx[1].xxx08,s_xxx[1].xxx09,s_xxx[1].xxx10,
                    s_xxx[1].xxx11,s_xxx[1].xxx12,s_xxx[1].xxx13
     AFTER CONSTRUCT
        CALL GET_FLDBUF(s_xxx[1].xxx01) RETURNING ms_xxx01
        CALL GET_FLDBUF(s_xxx[1].xxx02) RETURNING ms_xxx02
        CALL GET_FLDBUF(s_xxx[1].xxx03) RETURNING ms_xxx03
        CALL GET_FLDBUF(s_xxx[1].xxx04) RETURNING ms_xxx04
        CALL GET_FLDBUF(s_xxx[1].xxx05) RETURNING ms_xxx05
        CALL GET_FLDBUF(s_xxx[1].xxx06) RETURNING ms_xxx06
        CALL GET_FLDBUF(s_xxx[1].xxx07) RETURNING ms_xxx07
        CALL GET_FLDBUF(s_xxx[1].xxx08) RETURNING ms_xxx08
        CALL GET_FLDBUF(s_xxx[1].xxx09) RETURNING ms_xxx09
        CALL GET_FLDBUF(s_xxx[1].xxx10) RETURNING ms_xxx10
        CALL GET_FLDBUF(s_xxx[1].xxx11) RETURNING ms_xxx11
        CALL GET_FLDBUF(s_xxx[1].xxx12) RETURNING ms_xxx12
        CALL GET_FLDBUF(s_xxx[1].xxx13) RETURNING ms_xxx13
        CALL cl_qry_chg_type("xxx01",ms_xxx01) RETURNING ms_xxx01
        CALL cl_qry_chg_type("xxx02",ms_xxx02) RETURNING ms_xxx02
        CALL cl_qry_chg_type("xxx03",ms_xxx03) RETURNING ms_xxx03
        CALL cl_qry_chg_type("xxx04",ms_xxx04) RETURNING ms_xxx04
        CALL cl_qry_chg_type("xxx05",ms_xxx05) RETURNING ms_xxx05
        CALL cl_qry_chg_type("xxx06",ms_xxx06) RETURNING ms_xxx06
        CALL cl_qry_chg_type("xxx07",ms_xxx07) RETURNING ms_xxx07
        CALL cl_qry_chg_type("xxx08",ms_xxx08) RETURNING ms_xxx08
        CALL cl_qry_chg_type("xxx09",ms_xxx09) RETURNING ms_xxx09
        CALL cl_qry_chg_type("xxx10",ms_xxx10) RETURNING ms_xxx10
        CALL cl_qry_chg_type("xxx11",ms_xxx11) RETURNING ms_xxx11
        CALL cl_qry_chg_type("xxx12",ms_xxx12) RETURNING ms_xxx12
        CALL cl_qry_chg_type("xxx13",ms_xxx13) RETURNING ms_xxx13
        DISPLAY ms_xxx01,ms_xxx02,ms_xxx03,ms_xxx04,ms_xxx05,ms_xxx06,ms_xxx07,
                ms_xxx08,ms_xxx09,ms_xxx10,ms_xxx11,ms_xxx12,ms_xxx13
             TO s_xxx[1].xxx01,s_xxx[1].xxx02,s_xxx[1].xxx03,s_xxx[1].xxx04,
                s_xxx[1].xxx05,s_xxx[1].xxx06,s_xxx[1].xxx07,s_xxx[1].xxx08,
                s_xxx[1].xxx09,s_xxx[1].xxx10,s_xxx[1].xxx11,s_xxx[1].xxx12,
                s_xxx[1].xxx13
 
     ON ACTION about         #TQC-620117
        CALL cl_about()      #TQC-620117  
     ON ACTION help          #TQC-620117
        CALL cl_show_help()  #TQC-620117
     ON ACTION controlg      #TQC-620117
        CALL cl_cmdask()     #TQC-620117 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
  
  END CONSTRUCT
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
##########################################################################
 
FUNCTION cl_qry_cons14()
  CONSTRUCT ms_cons_where ON ms_xxx01,ms_xxx02,ms_xxx03,ms_xxx04,ms_xxx05,
                    ms_xxx06,ms_xxx07,ms_xxx08,ms_xxx09,ms_xxx10,
                    ms_xxx11,ms_xxx12,ms_xxx13,ms_xxx14
               FROM s_xxx[1].xxx01,s_xxx[1].xxx02,s_xxx[1].xxx03,s_xxx[1].xxx04,s_xxx[1].xxx05,
                    s_xxx[1].xxx06,s_xxx[1].xxx07,s_xxx[1].xxx08,s_xxx[1].xxx09,s_xxx[1].xxx10,
                    s_xxx[1].xxx11,s_xxx[1].xxx12,s_xxx[1].xxx13,s_xxx[1].xxx14
     AFTER CONSTRUCT
        CALL GET_FLDBUF(s_xxx[1].xxx01) RETURNING ms_xxx01
        CALL GET_FLDBUF(s_xxx[1].xxx02) RETURNING ms_xxx02
        CALL GET_FLDBUF(s_xxx[1].xxx03) RETURNING ms_xxx03
        CALL GET_FLDBUF(s_xxx[1].xxx04) RETURNING ms_xxx04
        CALL GET_FLDBUF(s_xxx[1].xxx05) RETURNING ms_xxx05
        CALL GET_FLDBUF(s_xxx[1].xxx06) RETURNING ms_xxx06
        CALL GET_FLDBUF(s_xxx[1].xxx07) RETURNING ms_xxx07
        CALL GET_FLDBUF(s_xxx[1].xxx08) RETURNING ms_xxx08
        CALL GET_FLDBUF(s_xxx[1].xxx09) RETURNING ms_xxx09
        CALL GET_FLDBUF(s_xxx[1].xxx10) RETURNING ms_xxx10
        CALL GET_FLDBUF(s_xxx[1].xxx11) RETURNING ms_xxx11
        CALL GET_FLDBUF(s_xxx[1].xxx12) RETURNING ms_xxx12
        CALL GET_FLDBUF(s_xxx[1].xxx13) RETURNING ms_xxx13
        CALL GET_FLDBUF(s_xxx[1].xxx14) RETURNING ms_xxx14
        CALL cl_qry_chg_type("xxx01",ms_xxx01) RETURNING ms_xxx01
        CALL cl_qry_chg_type("xxx02",ms_xxx02) RETURNING ms_xxx02
        CALL cl_qry_chg_type("xxx03",ms_xxx03) RETURNING ms_xxx03
        CALL cl_qry_chg_type("xxx04",ms_xxx04) RETURNING ms_xxx04
        CALL cl_qry_chg_type("xxx05",ms_xxx05) RETURNING ms_xxx05
        CALL cl_qry_chg_type("xxx06",ms_xxx06) RETURNING ms_xxx06
        CALL cl_qry_chg_type("xxx07",ms_xxx07) RETURNING ms_xxx07
        CALL cl_qry_chg_type("xxx08",ms_xxx08) RETURNING ms_xxx08
        CALL cl_qry_chg_type("xxx09",ms_xxx09) RETURNING ms_xxx09
        CALL cl_qry_chg_type("xxx10",ms_xxx10) RETURNING ms_xxx10
        CALL cl_qry_chg_type("xxx11",ms_xxx11) RETURNING ms_xxx11
        CALL cl_qry_chg_type("xxx12",ms_xxx12) RETURNING ms_xxx12
        CALL cl_qry_chg_type("xxx13",ms_xxx13) RETURNING ms_xxx13
        CALL cl_qry_chg_type("xxx14",ms_xxx14) RETURNING ms_xxx14
        DISPLAY ms_xxx01,ms_xxx02,ms_xxx03,ms_xxx04,ms_xxx05,ms_xxx06,ms_xxx07,
                ms_xxx08,ms_xxx09,ms_xxx10,ms_xxx11,ms_xxx12,ms_xxx13,ms_xxx14
             TO s_xxx[1].xxx01,s_xxx[1].xxx02,s_xxx[1].xxx03,s_xxx[1].xxx04,
                s_xxx[1].xxx05,s_xxx[1].xxx06,s_xxx[1].xxx07,s_xxx[1].xxx08,
                s_xxx[1].xxx09,s_xxx[1].xxx10,s_xxx[1].xxx11,s_xxx[1].xxx12,
                s_xxx[1].xxx13,s_xxx[1].xxx14
 
     ON ACTION about         #TQC-620117
        CALL cl_about()      #TQC-620117  
     ON ACTION help          #TQC-620117
        CALL cl_show_help()  #TQC-620117
     ON ACTION controlg      #TQC-620117
        CALL cl_cmdask()     #TQC-620117 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
  
  END CONSTRUCT
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
##########################################################################
 
FUNCTION cl_qry_cons15()
  CONSTRUCT ms_cons_where ON ms_xxx01,ms_xxx02,ms_xxx03,ms_xxx04,ms_xxx05,
                    ms_xxx06,ms_xxx07,ms_xxx08,ms_xxx09,ms_xxx10,
                    ms_xxx11,ms_xxx12,ms_xxx13,ms_xxx14,ms_xxx15
               FROM s_xxx[1].xxx01,s_xxx[1].xxx02,s_xxx[1].xxx03,s_xxx[1].xxx04,s_xxx[1].xxx05,
                    s_xxx[1].xxx06,s_xxx[1].xxx07,s_xxx[1].xxx08,s_xxx[1].xxx09,s_xxx[1].xxx10,
                    s_xxx[1].xxx11,s_xxx[1].xxx12,s_xxx[1].xxx13,s_xxx[1].xxx14,s_xxx[1].xxx15
     AFTER CONSTRUCT
        CALL GET_FLDBUF(s_xxx[1].xxx01) RETURNING ms_xxx01
        CALL GET_FLDBUF(s_xxx[1].xxx02) RETURNING ms_xxx02
        CALL GET_FLDBUF(s_xxx[1].xxx03) RETURNING ms_xxx03
        CALL GET_FLDBUF(s_xxx[1].xxx04) RETURNING ms_xxx04
        CALL GET_FLDBUF(s_xxx[1].xxx05) RETURNING ms_xxx05
        CALL GET_FLDBUF(s_xxx[1].xxx06) RETURNING ms_xxx06
        CALL GET_FLDBUF(s_xxx[1].xxx07) RETURNING ms_xxx07
        CALL GET_FLDBUF(s_xxx[1].xxx08) RETURNING ms_xxx08
        CALL GET_FLDBUF(s_xxx[1].xxx09) RETURNING ms_xxx09
        CALL GET_FLDBUF(s_xxx[1].xxx10) RETURNING ms_xxx10
        CALL GET_FLDBUF(s_xxx[1].xxx11) RETURNING ms_xxx11
        CALL GET_FLDBUF(s_xxx[1].xxx12) RETURNING ms_xxx12
        CALL GET_FLDBUF(s_xxx[1].xxx13) RETURNING ms_xxx13
        CALL GET_FLDBUF(s_xxx[1].xxx14) RETURNING ms_xxx14
        CALL GET_FLDBUF(s_xxx[1].xxx15) RETURNING ms_xxx15
        CALL cl_qry_chg_type("xxx01",ms_xxx01) RETURNING ms_xxx01
        CALL cl_qry_chg_type("xxx02",ms_xxx02) RETURNING ms_xxx02
        CALL cl_qry_chg_type("xxx03",ms_xxx03) RETURNING ms_xxx03
        CALL cl_qry_chg_type("xxx04",ms_xxx04) RETURNING ms_xxx04
        CALL cl_qry_chg_type("xxx05",ms_xxx05) RETURNING ms_xxx05
        CALL cl_qry_chg_type("xxx06",ms_xxx06) RETURNING ms_xxx06
        CALL cl_qry_chg_type("xxx07",ms_xxx07) RETURNING ms_xxx07
        CALL cl_qry_chg_type("xxx08",ms_xxx08) RETURNING ms_xxx08
        CALL cl_qry_chg_type("xxx09",ms_xxx09) RETURNING ms_xxx09
        CALL cl_qry_chg_type("xxx10",ms_xxx10) RETURNING ms_xxx10
        CALL cl_qry_chg_type("xxx11",ms_xxx11) RETURNING ms_xxx11
        CALL cl_qry_chg_type("xxx12",ms_xxx12) RETURNING ms_xxx12
        CALL cl_qry_chg_type("xxx13",ms_xxx13) RETURNING ms_xxx13
        CALL cl_qry_chg_type("xxx14",ms_xxx14) RETURNING ms_xxx14
        CALL cl_qry_chg_type("xxx15",ms_xxx15) RETURNING ms_xxx15
        DISPLAY ms_xxx01,ms_xxx02,ms_xxx03,ms_xxx04,ms_xxx05,ms_xxx06,ms_xxx07,
                ms_xxx08,ms_xxx09,ms_xxx10,ms_xxx11,ms_xxx12,ms_xxx13,ms_xxx14,
                ms_xxx15
             TO s_xxx[1].xxx01,s_xxx[1].xxx02,s_xxx[1].xxx03,s_xxx[1].xxx04,
                s_xxx[1].xxx05,s_xxx[1].xxx06,s_xxx[1].xxx07,s_xxx[1].xxx08,
                s_xxx[1].xxx09,s_xxx[1].xxx10,s_xxx[1].xxx11,s_xxx[1].xxx12,
                s_xxx[1].xxx13,s_xxx[1].xxx14,s_xxx[1].xxx15
 
     ON ACTION about         #TQC-620117
        CALL cl_about()      #TQC-620117  
     ON ACTION help          #TQC-620117
        CALL cl_show_help()  #TQC-620117
     ON ACTION controlg      #TQC-620117
        CALL cl_cmdask()     #TQC-620117 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
  
  END CONSTRUCT
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
##########################################################################
 
FUNCTION cl_qry_cons16()
  CONSTRUCT ms_cons_where ON ms_xxx01,ms_xxx02,ms_xxx03,ms_xxx04,ms_xxx05,
                    ms_xxx06,ms_xxx07,ms_xxx08,ms_xxx09,ms_xxx10,
                    ms_xxx11,ms_xxx12,ms_xxx13,ms_xxx14,ms_xxx15,
                    ms_xxx16
               FROM s_xxx[1].xxx01,s_xxx[1].xxx02,s_xxx[1].xxx03,s_xxx[1].xxx04,s_xxx[1].xxx05,
                    s_xxx[1].xxx06,s_xxx[1].xxx07,s_xxx[1].xxx08,s_xxx[1].xxx09,s_xxx[1].xxx10,
                    s_xxx[1].xxx11,s_xxx[1].xxx12,s_xxx[1].xxx13,s_xxx[1].xxx14,s_xxx[1].xxx15,
                    s_xxx[1].xxx16
     AFTER CONSTRUCT
        CALL GET_FLDBUF(s_xxx[1].xxx01) RETURNING ms_xxx01
        CALL GET_FLDBUF(s_xxx[1].xxx02) RETURNING ms_xxx02
        CALL GET_FLDBUF(s_xxx[1].xxx03) RETURNING ms_xxx03
        CALL GET_FLDBUF(s_xxx[1].xxx04) RETURNING ms_xxx04
        CALL GET_FLDBUF(s_xxx[1].xxx05) RETURNING ms_xxx05
        CALL GET_FLDBUF(s_xxx[1].xxx06) RETURNING ms_xxx06
        CALL GET_FLDBUF(s_xxx[1].xxx07) RETURNING ms_xxx07
        CALL GET_FLDBUF(s_xxx[1].xxx08) RETURNING ms_xxx08
        CALL GET_FLDBUF(s_xxx[1].xxx09) RETURNING ms_xxx09
        CALL GET_FLDBUF(s_xxx[1].xxx10) RETURNING ms_xxx10
        CALL GET_FLDBUF(s_xxx[1].xxx11) RETURNING ms_xxx11
        CALL GET_FLDBUF(s_xxx[1].xxx12) RETURNING ms_xxx12
        CALL GET_FLDBUF(s_xxx[1].xxx13) RETURNING ms_xxx13
        CALL GET_FLDBUF(s_xxx[1].xxx14) RETURNING ms_xxx14
        CALL GET_FLDBUF(s_xxx[1].xxx15) RETURNING ms_xxx15
        CALL GET_FLDBUF(s_xxx[1].xxx16) RETURNING ms_xxx16
        CALL cl_qry_chg_type("xxx01",ms_xxx01) RETURNING ms_xxx01
        CALL cl_qry_chg_type("xxx02",ms_xxx02) RETURNING ms_xxx02
        CALL cl_qry_chg_type("xxx03",ms_xxx03) RETURNING ms_xxx03
        CALL cl_qry_chg_type("xxx04",ms_xxx04) RETURNING ms_xxx04
        CALL cl_qry_chg_type("xxx05",ms_xxx05) RETURNING ms_xxx05
        CALL cl_qry_chg_type("xxx06",ms_xxx06) RETURNING ms_xxx06
        CALL cl_qry_chg_type("xxx07",ms_xxx07) RETURNING ms_xxx07
        CALL cl_qry_chg_type("xxx08",ms_xxx08) RETURNING ms_xxx08
        CALL cl_qry_chg_type("xxx09",ms_xxx09) RETURNING ms_xxx09
        CALL cl_qry_chg_type("xxx10",ms_xxx10) RETURNING ms_xxx10
        CALL cl_qry_chg_type("xxx11",ms_xxx11) RETURNING ms_xxx11
        CALL cl_qry_chg_type("xxx12",ms_xxx12) RETURNING ms_xxx12
        CALL cl_qry_chg_type("xxx13",ms_xxx13) RETURNING ms_xxx13
        CALL cl_qry_chg_type("xxx14",ms_xxx14) RETURNING ms_xxx14
        CALL cl_qry_chg_type("xxx15",ms_xxx15) RETURNING ms_xxx15
        CALL cl_qry_chg_type("xxx16",ms_xxx16) RETURNING ms_xxx16
        DISPLAY ms_xxx01,ms_xxx02,ms_xxx03,ms_xxx04,ms_xxx05,ms_xxx06,ms_xxx07,
                ms_xxx08,ms_xxx09,ms_xxx10,ms_xxx11,ms_xxx12,ms_xxx13,ms_xxx14,
                ms_xxx15,ms_xxx16
             TO s_xxx[1].xxx01,s_xxx[1].xxx02,s_xxx[1].xxx03,s_xxx[1].xxx04,
                s_xxx[1].xxx05,s_xxx[1].xxx06,s_xxx[1].xxx07,s_xxx[1].xxx08,
                s_xxx[1].xxx09,s_xxx[1].xxx10,s_xxx[1].xxx11,s_xxx[1].xxx12,
                s_xxx[1].xxx13,s_xxx[1].xxx14,s_xxx[1].xxx15,s_xxx[1].xxx16
 
     ON ACTION about         #TQC-620117
        CALL cl_about()      #TQC-620117  
     ON ACTION help          #TQC-620117
        CALL cl_show_help()  #TQC-620117
     ON ACTION controlg      #TQC-620117
        CALL cl_cmdask()     #TQC-620117 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
  
  END CONSTRUCT
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
##########################################################################
 
FUNCTION cl_qry_cons17()
  CONSTRUCT ms_cons_where ON ms_xxx01,ms_xxx02,ms_xxx03,ms_xxx04,ms_xxx05,
                    ms_xxx06,ms_xxx07,ms_xxx08,ms_xxx09,ms_xxx10,
                    ms_xxx11,ms_xxx12,ms_xxx13,ms_xxx14,ms_xxx15,
                    ms_xxx16,ms_xxx17
               FROM s_xxx[1].xxx01,s_xxx[1].xxx02,s_xxx[1].xxx03,s_xxx[1].xxx04,s_xxx[1].xxx05,
                    s_xxx[1].xxx06,s_xxx[1].xxx07,s_xxx[1].xxx08,s_xxx[1].xxx09,s_xxx[1].xxx10,
                    s_xxx[1].xxx11,s_xxx[1].xxx12,s_xxx[1].xxx13,s_xxx[1].xxx14,s_xxx[1].xxx15,
                    s_xxx[1].xxx16,s_xxx[1].xxx17
     AFTER CONSTRUCT
        CALL GET_FLDBUF(s_xxx[1].xxx01) RETURNING ms_xxx01
        CALL GET_FLDBUF(s_xxx[1].xxx02) RETURNING ms_xxx02
        CALL GET_FLDBUF(s_xxx[1].xxx03) RETURNING ms_xxx03
        CALL GET_FLDBUF(s_xxx[1].xxx04) RETURNING ms_xxx04
        CALL GET_FLDBUF(s_xxx[1].xxx05) RETURNING ms_xxx05
        CALL GET_FLDBUF(s_xxx[1].xxx06) RETURNING ms_xxx06
        CALL GET_FLDBUF(s_xxx[1].xxx07) RETURNING ms_xxx07
        CALL GET_FLDBUF(s_xxx[1].xxx08) RETURNING ms_xxx08
        CALL GET_FLDBUF(s_xxx[1].xxx09) RETURNING ms_xxx09
        CALL GET_FLDBUF(s_xxx[1].xxx10) RETURNING ms_xxx10
        CALL GET_FLDBUF(s_xxx[1].xxx11) RETURNING ms_xxx11
        CALL GET_FLDBUF(s_xxx[1].xxx12) RETURNING ms_xxx12
        CALL GET_FLDBUF(s_xxx[1].xxx13) RETURNING ms_xxx13
        CALL GET_FLDBUF(s_xxx[1].xxx14) RETURNING ms_xxx14
        CALL GET_FLDBUF(s_xxx[1].xxx15) RETURNING ms_xxx15
        CALL GET_FLDBUF(s_xxx[1].xxx16) RETURNING ms_xxx16
        CALL GET_FLDBUF(s_xxx[1].xxx17) RETURNING ms_xxx17
        CALL cl_qry_chg_type("xxx01",ms_xxx01) RETURNING ms_xxx01
        CALL cl_qry_chg_type("xxx02",ms_xxx02) RETURNING ms_xxx02
        CALL cl_qry_chg_type("xxx03",ms_xxx03) RETURNING ms_xxx03
        CALL cl_qry_chg_type("xxx04",ms_xxx04) RETURNING ms_xxx04
        CALL cl_qry_chg_type("xxx05",ms_xxx05) RETURNING ms_xxx05
        CALL cl_qry_chg_type("xxx06",ms_xxx06) RETURNING ms_xxx06
        CALL cl_qry_chg_type("xxx07",ms_xxx07) RETURNING ms_xxx07
        CALL cl_qry_chg_type("xxx08",ms_xxx08) RETURNING ms_xxx08
        CALL cl_qry_chg_type("xxx09",ms_xxx09) RETURNING ms_xxx09
        CALL cl_qry_chg_type("xxx10",ms_xxx10) RETURNING ms_xxx10
        CALL cl_qry_chg_type("xxx11",ms_xxx11) RETURNING ms_xxx11
        CALL cl_qry_chg_type("xxx12",ms_xxx12) RETURNING ms_xxx12
        CALL cl_qry_chg_type("xxx13",ms_xxx13) RETURNING ms_xxx13
        CALL cl_qry_chg_type("xxx14",ms_xxx14) RETURNING ms_xxx14
        CALL cl_qry_chg_type("xxx15",ms_xxx15) RETURNING ms_xxx15
        CALL cl_qry_chg_type("xxx16",ms_xxx16) RETURNING ms_xxx16
        CALL cl_qry_chg_type("xxx17",ms_xxx17) RETURNING ms_xxx17
        DISPLAY ms_xxx01,ms_xxx02,ms_xxx03,ms_xxx04,ms_xxx05,ms_xxx06,ms_xxx07,
                ms_xxx08,ms_xxx09,ms_xxx10,ms_xxx11,ms_xxx12,ms_xxx13,ms_xxx14,
                ms_xxx15,ms_xxx16,ms_xxx17
             TO s_xxx[1].xxx01,s_xxx[1].xxx02,s_xxx[1].xxx03,s_xxx[1].xxx04,
                s_xxx[1].xxx05,s_xxx[1].xxx06,s_xxx[1].xxx07,s_xxx[1].xxx08,
                s_xxx[1].xxx09,s_xxx[1].xxx10,s_xxx[1].xxx11,s_xxx[1].xxx12,
                s_xxx[1].xxx13,s_xxx[1].xxx14,s_xxx[1].xxx15,s_xxx[1].xxx16,
                s_xxx[1].xxx17
 
     ON ACTION about         #TQC-620117
        CALL cl_about()      #TQC-620117  
     ON ACTION help          #TQC-620117
        CALL cl_show_help()  #TQC-620117
     ON ACTION controlg      #TQC-620117
        CALL cl_cmdask()     #TQC-620117 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
  
  END CONSTRUCT
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
##########################################################################
 
FUNCTION cl_qry_cons18()
  CONSTRUCT ms_cons_where ON ms_xxx01,ms_xxx02,ms_xxx03,ms_xxx04,ms_xxx05,
                    ms_xxx06,ms_xxx07,ms_xxx08,ms_xxx09,ms_xxx10,
                    ms_xxx11,ms_xxx12,ms_xxx13,ms_xxx14,ms_xxx15,
                    ms_xxx16,ms_xxx17,ms_xxx18
               FROM s_xxx[1].xxx01,s_xxx[1].xxx02,s_xxx[1].xxx03,s_xxx[1].xxx04,s_xxx[1].xxx05,
                    s_xxx[1].xxx06,s_xxx[1].xxx07,s_xxx[1].xxx08,s_xxx[1].xxx09,s_xxx[1].xxx10,
                    s_xxx[1].xxx11,s_xxx[1].xxx12,s_xxx[1].xxx13,s_xxx[1].xxx14,s_xxx[1].xxx15,
                    s_xxx[1].xxx16,s_xxx[1].xxx17,s_xxx[1].xxx18
     AFTER CONSTRUCT
        CALL GET_FLDBUF(s_xxx[1].xxx01) RETURNING ms_xxx01
        CALL GET_FLDBUF(s_xxx[1].xxx02) RETURNING ms_xxx02
        CALL GET_FLDBUF(s_xxx[1].xxx03) RETURNING ms_xxx03
        CALL GET_FLDBUF(s_xxx[1].xxx04) RETURNING ms_xxx04
        CALL GET_FLDBUF(s_xxx[1].xxx05) RETURNING ms_xxx05
        CALL GET_FLDBUF(s_xxx[1].xxx06) RETURNING ms_xxx06
        CALL GET_FLDBUF(s_xxx[1].xxx07) RETURNING ms_xxx07
        CALL GET_FLDBUF(s_xxx[1].xxx08) RETURNING ms_xxx08
        CALL GET_FLDBUF(s_xxx[1].xxx09) RETURNING ms_xxx09
        CALL GET_FLDBUF(s_xxx[1].xxx10) RETURNING ms_xxx10
        CALL GET_FLDBUF(s_xxx[1].xxx11) RETURNING ms_xxx11
        CALL GET_FLDBUF(s_xxx[1].xxx12) RETURNING ms_xxx12
        CALL GET_FLDBUF(s_xxx[1].xxx13) RETURNING ms_xxx13
        CALL GET_FLDBUF(s_xxx[1].xxx14) RETURNING ms_xxx14
        CALL GET_FLDBUF(s_xxx[1].xxx15) RETURNING ms_xxx15
        CALL GET_FLDBUF(s_xxx[1].xxx16) RETURNING ms_xxx16
        CALL GET_FLDBUF(s_xxx[1].xxx17) RETURNING ms_xxx17
        CALL GET_FLDBUF(s_xxx[1].xxx18) RETURNING ms_xxx18
        CALL cl_qry_chg_type("xxx01",ms_xxx01) RETURNING ms_xxx01
        CALL cl_qry_chg_type("xxx02",ms_xxx02) RETURNING ms_xxx02
        CALL cl_qry_chg_type("xxx03",ms_xxx03) RETURNING ms_xxx03
        CALL cl_qry_chg_type("xxx04",ms_xxx04) RETURNING ms_xxx04
        CALL cl_qry_chg_type("xxx05",ms_xxx05) RETURNING ms_xxx05
        CALL cl_qry_chg_type("xxx06",ms_xxx06) RETURNING ms_xxx06
        CALL cl_qry_chg_type("xxx07",ms_xxx07) RETURNING ms_xxx07
        CALL cl_qry_chg_type("xxx08",ms_xxx08) RETURNING ms_xxx08
        CALL cl_qry_chg_type("xxx09",ms_xxx09) RETURNING ms_xxx09
        CALL cl_qry_chg_type("xxx10",ms_xxx10) RETURNING ms_xxx10
        CALL cl_qry_chg_type("xxx11",ms_xxx11) RETURNING ms_xxx11
        CALL cl_qry_chg_type("xxx12",ms_xxx12) RETURNING ms_xxx12
        CALL cl_qry_chg_type("xxx13",ms_xxx13) RETURNING ms_xxx13
        CALL cl_qry_chg_type("xxx14",ms_xxx14) RETURNING ms_xxx14
        CALL cl_qry_chg_type("xxx15",ms_xxx15) RETURNING ms_xxx15
        CALL cl_qry_chg_type("xxx16",ms_xxx16) RETURNING ms_xxx16
        CALL cl_qry_chg_type("xxx17",ms_xxx17) RETURNING ms_xxx17
        CALL cl_qry_chg_type("xxx18",ms_xxx18) RETURNING ms_xxx18
        DISPLAY ms_xxx01,ms_xxx02,ms_xxx03,ms_xxx04,ms_xxx05,ms_xxx06,ms_xxx07,
                ms_xxx08,ms_xxx09,ms_xxx10,ms_xxx11,ms_xxx12,ms_xxx13,ms_xxx14,
                ms_xxx15,ms_xxx16,ms_xxx17,ms_xxx18
             TO s_xxx[1].xxx01,s_xxx[1].xxx02,s_xxx[1].xxx03,s_xxx[1].xxx04,
                s_xxx[1].xxx05,s_xxx[1].xxx06,s_xxx[1].xxx07,s_xxx[1].xxx08,
                s_xxx[1].xxx09,s_xxx[1].xxx10,s_xxx[1].xxx11,s_xxx[1].xxx12,
                s_xxx[1].xxx13,s_xxx[1].xxx14,s_xxx[1].xxx15,s_xxx[1].xxx16,
                s_xxx[1].xxx17,s_xxx[1].xxx18
 
     ON ACTION about         #TQC-620117
        CALL cl_about()      #TQC-620117  
     ON ACTION help          #TQC-620117
        CALL cl_show_help()  #TQC-620117
     ON ACTION controlg      #TQC-620117
        CALL cl_cmdask()     #TQC-620117 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
  
  END CONSTRUCT
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
##########################################################################
 
FUNCTION cl_qry_cons19()
  CONSTRUCT ms_cons_where ON ms_xxx01,ms_xxx02,ms_xxx03,ms_xxx04,ms_xxx05,
                    ms_xxx06,ms_xxx07,ms_xxx08,ms_xxx09,ms_xxx10,
                    ms_xxx11,ms_xxx12,ms_xxx13,ms_xxx14,ms_xxx15,
                    ms_xxx16,ms_xxx17,ms_xxx18,ms_xxx19
               FROM s_xxx[1].xxx01,s_xxx[1].xxx02,s_xxx[1].xxx03,s_xxx[1].xxx04,s_xxx[1].xxx05,
                    s_xxx[1].xxx06,s_xxx[1].xxx07,s_xxx[1].xxx08,s_xxx[1].xxx09,s_xxx[1].xxx10,
                    s_xxx[1].xxx11,s_xxx[1].xxx12,s_xxx[1].xxx13,s_xxx[1].xxx14,s_xxx[1].xxx15,
                    s_xxx[1].xxx16,s_xxx[1].xxx17,s_xxx[1].xxx18,s_xxx[1].xxx19
     AFTER CONSTRUCT
        CALL GET_FLDBUF(s_xxx[1].xxx01) RETURNING ms_xxx01
        CALL GET_FLDBUF(s_xxx[1].xxx02) RETURNING ms_xxx02
        CALL GET_FLDBUF(s_xxx[1].xxx03) RETURNING ms_xxx03
        CALL GET_FLDBUF(s_xxx[1].xxx04) RETURNING ms_xxx04
        CALL GET_FLDBUF(s_xxx[1].xxx05) RETURNING ms_xxx05
        CALL GET_FLDBUF(s_xxx[1].xxx06) RETURNING ms_xxx06
        CALL GET_FLDBUF(s_xxx[1].xxx07) RETURNING ms_xxx07
        CALL GET_FLDBUF(s_xxx[1].xxx08) RETURNING ms_xxx08
        CALL GET_FLDBUF(s_xxx[1].xxx09) RETURNING ms_xxx09
        CALL GET_FLDBUF(s_xxx[1].xxx10) RETURNING ms_xxx10
        CALL GET_FLDBUF(s_xxx[1].xxx11) RETURNING ms_xxx11
        CALL GET_FLDBUF(s_xxx[1].xxx12) RETURNING ms_xxx12
        CALL GET_FLDBUF(s_xxx[1].xxx13) RETURNING ms_xxx13
        CALL GET_FLDBUF(s_xxx[1].xxx14) RETURNING ms_xxx14
        CALL GET_FLDBUF(s_xxx[1].xxx15) RETURNING ms_xxx15
        CALL GET_FLDBUF(s_xxx[1].xxx16) RETURNING ms_xxx16
        CALL GET_FLDBUF(s_xxx[1].xxx17) RETURNING ms_xxx17
        CALL GET_FLDBUF(s_xxx[1].xxx18) RETURNING ms_xxx18
        CALL GET_FLDBUF(s_xxx[1].xxx19) RETURNING ms_xxx19
        CALL cl_qry_chg_type("xxx01",ms_xxx01) RETURNING ms_xxx01
        CALL cl_qry_chg_type("xxx02",ms_xxx02) RETURNING ms_xxx02
        CALL cl_qry_chg_type("xxx03",ms_xxx03) RETURNING ms_xxx03
        CALL cl_qry_chg_type("xxx04",ms_xxx04) RETURNING ms_xxx04
        CALL cl_qry_chg_type("xxx05",ms_xxx05) RETURNING ms_xxx05
        CALL cl_qry_chg_type("xxx06",ms_xxx06) RETURNING ms_xxx06
        CALL cl_qry_chg_type("xxx07",ms_xxx07) RETURNING ms_xxx07
        CALL cl_qry_chg_type("xxx08",ms_xxx08) RETURNING ms_xxx08
        CALL cl_qry_chg_type("xxx09",ms_xxx09) RETURNING ms_xxx09
        CALL cl_qry_chg_type("xxx10",ms_xxx10) RETURNING ms_xxx10
        CALL cl_qry_chg_type("xxx11",ms_xxx11) RETURNING ms_xxx11
        CALL cl_qry_chg_type("xxx12",ms_xxx12) RETURNING ms_xxx12
        CALL cl_qry_chg_type("xxx13",ms_xxx13) RETURNING ms_xxx13
        CALL cl_qry_chg_type("xxx14",ms_xxx14) RETURNING ms_xxx14
        CALL cl_qry_chg_type("xxx15",ms_xxx15) RETURNING ms_xxx15
        CALL cl_qry_chg_type("xxx16",ms_xxx16) RETURNING ms_xxx16
        CALL cl_qry_chg_type("xxx17",ms_xxx17) RETURNING ms_xxx17
        CALL cl_qry_chg_type("xxx18",ms_xxx18) RETURNING ms_xxx18
        CALL cl_qry_chg_type("xxx19",ms_xxx19) RETURNING ms_xxx19
        DISPLAY ms_xxx01,ms_xxx02,ms_xxx03,ms_xxx04,ms_xxx05,ms_xxx06,ms_xxx07,
                ms_xxx08,ms_xxx09,ms_xxx10,ms_xxx11,ms_xxx12,ms_xxx13,ms_xxx14,
                ms_xxx15,ms_xxx16,ms_xxx17,ms_xxx18,ms_xxx19
             TO s_xxx[1].xxx01,s_xxx[1].xxx02,s_xxx[1].xxx03,s_xxx[1].xxx04,
                s_xxx[1].xxx05,s_xxx[1].xxx06,s_xxx[1].xxx07,s_xxx[1].xxx08,
                s_xxx[1].xxx09,s_xxx[1].xxx10,s_xxx[1].xxx11,s_xxx[1].xxx12,
                s_xxx[1].xxx13,s_xxx[1].xxx14,s_xxx[1].xxx15,s_xxx[1].xxx16,
                s_xxx[1].xxx17,s_xxx[1].xxx18,s_xxx[1].xxx19
 
     ON ACTION about         #TQC-620117
        CALL cl_about()      #TQC-620117  
     ON ACTION help          #TQC-620117
        CALL cl_show_help()  #TQC-620117
     ON ACTION controlg      #TQC-620117
        CALL cl_cmdask()     #TQC-620117 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
  
  END CONSTRUCT
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
##########################################################################
 
FUNCTION cl_qry_cons20()
  CONSTRUCT ms_cons_where ON ms_xxx01,ms_xxx02,ms_xxx03,ms_xxx04,ms_xxx05,
                    ms_xxx06,ms_xxx07,ms_xxx08,ms_xxx09,ms_xxx10,
                    ms_xxx11,ms_xxx12,ms_xxx13,ms_xxx14,ms_xxx15,
                    ms_xxx16,ms_xxx17,ms_xxx18,ms_xxx19,ms_xxx20
               FROM s_xxx[1].xxx01,s_xxx[1].xxx02,s_xxx[1].xxx03,s_xxx[1].xxx04,s_xxx[1].xxx05,
                    s_xxx[1].xxx06,s_xxx[1].xxx07,s_xxx[1].xxx08,s_xxx[1].xxx09,s_xxx[1].xxx10,
                    s_xxx[1].xxx11,s_xxx[1].xxx12,s_xxx[1].xxx13,s_xxx[1].xxx14,s_xxx[1].xxx15,
                    s_xxx[1].xxx16,s_xxx[1].xxx17,s_xxx[1].xxx18,s_xxx[1].xxx19,s_xxx[1].xxx20
     AFTER CONSTRUCT
        CALL GET_FLDBUF(s_xxx[1].xxx01) RETURNING ms_xxx01
        CALL GET_FLDBUF(s_xxx[1].xxx02) RETURNING ms_xxx02
        CALL GET_FLDBUF(s_xxx[1].xxx03) RETURNING ms_xxx03
        CALL GET_FLDBUF(s_xxx[1].xxx04) RETURNING ms_xxx04
        CALL GET_FLDBUF(s_xxx[1].xxx05) RETURNING ms_xxx05
        CALL GET_FLDBUF(s_xxx[1].xxx06) RETURNING ms_xxx06
        CALL GET_FLDBUF(s_xxx[1].xxx07) RETURNING ms_xxx07
        CALL GET_FLDBUF(s_xxx[1].xxx08) RETURNING ms_xxx08
        CALL GET_FLDBUF(s_xxx[1].xxx09) RETURNING ms_xxx09
        CALL GET_FLDBUF(s_xxx[1].xxx10) RETURNING ms_xxx10
        CALL GET_FLDBUF(s_xxx[1].xxx11) RETURNING ms_xxx11
        CALL GET_FLDBUF(s_xxx[1].xxx12) RETURNING ms_xxx12
        CALL GET_FLDBUF(s_xxx[1].xxx13) RETURNING ms_xxx13
        CALL GET_FLDBUF(s_xxx[1].xxx14) RETURNING ms_xxx14
        CALL GET_FLDBUF(s_xxx[1].xxx15) RETURNING ms_xxx15
        CALL GET_FLDBUF(s_xxx[1].xxx16) RETURNING ms_xxx16
        CALL GET_FLDBUF(s_xxx[1].xxx17) RETURNING ms_xxx17
        CALL GET_FLDBUF(s_xxx[1].xxx18) RETURNING ms_xxx18
        CALL GET_FLDBUF(s_xxx[1].xxx19) RETURNING ms_xxx19
        CALL GET_FLDBUF(s_xxx[1].xxx20) RETURNING ms_xxx20
        CALL cl_qry_chg_type("xxx01",ms_xxx01) RETURNING ms_xxx01
        CALL cl_qry_chg_type("xxx02",ms_xxx02) RETURNING ms_xxx02
        CALL cl_qry_chg_type("xxx03",ms_xxx03) RETURNING ms_xxx03
        CALL cl_qry_chg_type("xxx04",ms_xxx04) RETURNING ms_xxx04
        CALL cl_qry_chg_type("xxx05",ms_xxx05) RETURNING ms_xxx05
        CALL cl_qry_chg_type("xxx06",ms_xxx06) RETURNING ms_xxx06
        CALL cl_qry_chg_type("xxx07",ms_xxx07) RETURNING ms_xxx07
        CALL cl_qry_chg_type("xxx08",ms_xxx08) RETURNING ms_xxx08
        CALL cl_qry_chg_type("xxx09",ms_xxx09) RETURNING ms_xxx09
        CALL cl_qry_chg_type("xxx10",ms_xxx10) RETURNING ms_xxx10
        CALL cl_qry_chg_type("xxx11",ms_xxx11) RETURNING ms_xxx11
        CALL cl_qry_chg_type("xxx12",ms_xxx12) RETURNING ms_xxx12
        CALL cl_qry_chg_type("xxx13",ms_xxx13) RETURNING ms_xxx13
        CALL cl_qry_chg_type("xxx14",ms_xxx14) RETURNING ms_xxx14
        CALL cl_qry_chg_type("xxx15",ms_xxx15) RETURNING ms_xxx15
        CALL cl_qry_chg_type("xxx16",ms_xxx16) RETURNING ms_xxx16
        CALL cl_qry_chg_type("xxx17",ms_xxx17) RETURNING ms_xxx17
        CALL cl_qry_chg_type("xxx18",ms_xxx18) RETURNING ms_xxx18
        CALL cl_qry_chg_type("xxx19",ms_xxx19) RETURNING ms_xxx19
        CALL cl_qry_chg_type("xxx20",ms_xxx20) RETURNING ms_xxx20
        DISPLAY ms_xxx01,ms_xxx02,ms_xxx03,ms_xxx04,ms_xxx05,ms_xxx06,ms_xxx07,
                ms_xxx08,ms_xxx09,ms_xxx10,ms_xxx11,ms_xxx12,ms_xxx13,ms_xxx14,
                ms_xxx15,ms_xxx16,ms_xxx17,ms_xxx18,ms_xxx19,ms_xxx20
             TO s_xxx[1].xxx01,s_xxx[1].xxx02,s_xxx[1].xxx03,s_xxx[1].xxx04,
                s_xxx[1].xxx05,s_xxx[1].xxx06,s_xxx[1].xxx07,s_xxx[1].xxx08,
                s_xxx[1].xxx09,s_xxx[1].xxx10,s_xxx[1].xxx11,s_xxx[1].xxx12,
                s_xxx[1].xxx13,s_xxx[1].xxx14,s_xxx[1].xxx15,s_xxx[1].xxx16,
                s_xxx[1].xxx17,s_xxx[1].xxx18,s_xxx[1].xxx19,s_xxx[1].xxx20
 
     ON ACTION about         #TQC-620117
        CALL cl_about()      #TQC-620117  
     ON ACTION help          #TQC-620117
        CALL cl_show_help()  #TQC-620117
     ON ACTION controlg      #TQC-620117
        CALL cl_cmdask()     #TQC-620117 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
  
  END CONSTRUCT
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 回傳所選擇的欄位值.
# Input parameter: pi_sel_row          SMALLINT  所選擇的資料列
#                  ps_ret_field_index  SMALLINT  所要回傳的欄位索引值
# Return code....: STRING 選擇的欄位值
# Usage..........: LET ms_ret1 = cl_qry_get_ret_value(pi_sel_index, mst_ret_field_index.nextToken())
# Date & Author..: 2003/07/08 by Hiko
##########################################################################
 
FUNCTION cl_qry_get_ret_value(pi_sel_row, ps_ret_field_index)
  DEFINE pi_sel_row  LIKE type_file.num5,           #No.FUN-690005 SMALLINT
         ps_ret_field_index STRING
  DEFINE ls_ret_value STRING
 
  # 2004/06/03 by saki : GDC 1.3版本後，若沒有資料，ARR_CURR()會是0
  IF pi_sel_row = 0 THEN
     LET ls_ret_value = ""
     RETURN ls_ret_value
  END IF
 
  #2005/05/03 FUN-550021 Add By Lifeng Start
  #加入料件多屬性機制后，因為欄位的位置和以前的不一定一樣了，所以這裡
  #要調用新的函數來返回正確的值
  
  #下面被註釋掉的是原有的代碼
#  CASE ps_ret_field_index
#     WHEN "1"  LET ls_ret_value = ma_qry[pi_sel_row].item01 CLIPPED #MOD-540046  
#     WHEN "2"  LET ls_ret_value = ma_qry[pi_sel_row].item02 CLIPPED #MOD-540046
#     WHEN "3"  LET ls_ret_value = ma_qry[pi_sel_row].item03 CLIPPED #MOD-540046
#     WHEN "4"  LET ls_ret_value = ma_qry[pi_sel_row].item04 CLIPPED #MOD-540046
#     WHEN "5"  LET ls_ret_value = ma_qry[pi_sel_row].item05 CLIPPED #MOD-540046
#     WHEN "6"  LET ls_ret_value = ma_qry[pi_sel_row].item06 CLIPPED #MOD-540046
#     WHEN "7"  LET ls_ret_value = ma_qry[pi_sel_row].item07 CLIPPED #MOD-540046
#     WHEN "8"  LET ls_ret_value = ma_qry[pi_sel_row].item08 CLIPPED #MOD-540046
#     WHEN "9"  LET ls_ret_value = ma_qry[pi_sel_row].item09 CLIPPED #MOD-540046
#     WHEN "10" LET ls_ret_value = ma_qry[pi_sel_row].item10 CLIPPED #MOD-540046
#     WHEN "11" LET ls_ret_value = ma_qry[pi_sel_row].item11 CLIPPED #MOD-540046
#     WHEN "12" LET ls_ret_value = ma_qry[pi_sel_row].item12 CLIPPED #MOD-540046
#     WHEN "13" LET ls_ret_value = ma_qry[pi_sel_row].item13 CLIPPED #MOD-540046
#     WHEN "14" LET ls_ret_value = ma_qry[pi_sel_row].item14 CLIPPED #MOD-540046
#     WHEN "15" LET ls_ret_value = ma_qry[pi_sel_row].item15 CLIPPED #MOD-540046
#     WHEN "16" LET ls_ret_value = ma_qry[pi_sel_row].item16 CLIPPED #MOD-540046
#     WHEN "17" LET ls_ret_value = ma_qry[pi_sel_row].item17 CLIPPED #MOD-540046
#     WHEN "18" LET ls_ret_value = ma_qry[pi_sel_row].item18 CLIPPED #MOD-540046
#     WHEN "19" LET ls_ret_value = ma_qry[pi_sel_row].item19 CLIPPED #MOD-540046
#     WHEN "20" LET ls_ret_value = ma_qry[pi_sel_row].item20 CLIPPED #MOD-540046  
#  END CASE
#   
  #下面是修改過以後的代碼
  CASE ps_ret_field_index
    WHEN "1"  LET ls_ret_value = cl_get_array_value(pi_sel_row,'1')  
    WHEN "2"  LET ls_ret_value = cl_get_array_value(pi_sel_row,'2')  
    WHEN "3"  LET ls_ret_value = cl_get_array_value(pi_sel_row,'3')  
    WHEN "4"  LET ls_ret_value = cl_get_array_value(pi_sel_row,'4')  
    WHEN "5"  LET ls_ret_value = cl_get_array_value(pi_sel_row,'5')  
    WHEN "6"  LET ls_ret_value = cl_get_array_value(pi_sel_row,'6')  
    WHEN "7"  LET ls_ret_value = cl_get_array_value(pi_sel_row,'7')  
    WHEN "8"  LET ls_ret_value = cl_get_array_value(pi_sel_row,'8')  
    WHEN "9"  LET ls_ret_value = cl_get_array_value(pi_sel_row,'9')  
    WHEN "10" LET ls_ret_value = cl_get_array_value(pi_sel_row,'10')  
    WHEN "11" LET ls_ret_value = cl_get_array_value(pi_sel_row,'11')  
    WHEN "12" LET ls_ret_value = cl_get_array_value(pi_sel_row,'12')  
    WHEN "13" LET ls_ret_value = cl_get_array_value(pi_sel_row,'13')  
    WHEN "14" LET ls_ret_value = cl_get_array_value(pi_sel_row,'14')  
    WHEN "15" LET ls_ret_value = cl_get_array_value(pi_sel_row,'15')  
    WHEN "16" LET ls_ret_value = cl_get_array_value(pi_sel_row,'16')  
    WHEN "17" LET ls_ret_value = cl_get_array_value(pi_sel_row,'17')  
    WHEN "18" LET ls_ret_value = cl_get_array_value(pi_sel_row,'18')  
    WHEN "19" LET ls_ret_value = cl_get_array_value(pi_sel_row,'19')  
    WHEN "20" LET ls_ret_value = cl_get_array_value(pi_sel_row,'20')  
  END CASE
  
  #2005/05/03 Add By Lifeng End
  
  # 2003/11/05 by Hiko : 因為有些資料在儲存的過程當中前面會不小心存成空白,為了避免
  #                      查詢時資料比對不正確,因此只清除後面的空白.
  LET ls_ret_value = ls_ret_value.trimRight()
 
  RETURN ls_ret_value
END FUNCTION
 
###############################################################################
#------------------2005/05/03 FUN-550021 Add By Lifeng ------------------------
# 以下函數都是李鋒為料件多屬性管理機制添加的函數
 
#
##########################################################################
# Private Func...: TRUE
# Descriptions...: 判斷指定的欄位是否為表示料件編號的欄位，如果是返回1，否則返回0
# Input parameter: p_colname  STRING  欄位代碼
# Return code....: TRUE/FALSE
# Usage..........: IF cl_is_itemno("ima01") THEN
# Date & Author..: 2005/05/03 By Lifeng
##########################################################################
 
FUNCTION cl_is_itemno(p_colname)
  DEFINE p_colname  STRING
  DEFINE p_itemlist STRING
  DEFINE li_pos     LIKE type_file.num5          #No.FUN-690005  SMALLINT
 
  #這是2005/05/10在tiptopGP系統中搜索到的所有表示料件編號的欄位名稱
  LET p_itemlist = 'ale11-alt11-apb12-bgc05-bgp04-bgy05-azv01-bmj01-',
      'bmk01-bmq01-bmr07-bnc03-bne05-bnf01-bnh03-bwa02-bwc03-bwd01-bwe03-',
      'bwf01-bwg04-bwh02-bxj04-mea02-rvh04-crb08-crd04-crh11-coa01-coo04-',
      'cop04-cor04-crb08-crd04-crh11-csa01-csb01-csd01-cse01-ecb01-ecbb01-',
      'ecm03_par-eco01-ecu01-ecw01-sgc01-sgd01-sgm03_par-sgn01-fiw03-ima01-',
      'imb01-imc01-imf01-img01-imgg01-imh04-imk01-imkk01-iml01-imn03-ims05-',
      'imy15-inb04-ind01-pia02-pie02-pif02-mmg04-mmh03-mml04-msb03-msd06-',
      'msm01-mss01-mst01-rpc01-mps01-mpt01-rpc01-rpj04-rqb065-pjf03-pmh01-',
      'pmj03-pml04-pmn04-pmq01-pmx08-pnn03-poc05-pon04-pow05-rvb05-rvv31-',
      'qcc01-qcd01-qcf021-qcm021-qcs021-qdb02-rmd04-rmh03-rmo05-sta01-stb01-',
      'ste05-stp02-stp02-stp02-stv04-ttb03-ksb04-ksd04-sfa03-sfb05-sfi05-',
      'sfj03-sfl03-sfn04-sfs04-sft04-sfv04-shg08-shm05-snc03-smd01-caf04-',
      'cag04-can01-cca01-ccb01-ccc01-ccq01-ccs01-cma01-cmb01-cmc01-cxa01-',
      'cxb01-cxc01-cxd01-adg05-adi05-obc01-obd01-obh01-oft07-ofv02-oqu03-',
      'xmc06-xmd06-xmf03-xmg03-olb11-olf11-cxa01-cxb01-cxc01-cxd01'
 
  LET li_pos = p_itemlist.getIndexOf(p_colname,1)
  IF li_pos > 0 THEN 
     RETURN TRUE
  ELSE 
     RETURN FALSE
  END IF 
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 有料件多屬性欄位的Construct段
# Input parameter: none
# Return code....: void
# Usage..........: CALL cl_multi_cons()
# Date & Author..: 2005/05/03 By Lifeng
##########################################################################
 
FUNCTION cl_multi_cons()
  DEFINE l_cnt           LIKE type_file.num5,           #No.FUN-690005 SMALLINT
         l_i,l_ac        LIKE type_file.num5,           #No.FUN-690005 SMALLINT
 
         lwin_curr       ui.Window,
         lfrm_curr       ui.Form,
         li_i            LIKE type_file.num5,           #No.FUN-690005 SMALLINT
         lc_i            STRING,
         lnode_frm       om.domNode,
         lnode_grid      om.domNode,
         lnode_table     om.domNode,
         lnode_column    om.domNode,
         lc_colname      STRING,
         ls_fname        STRING,
         ls_fvalue       STRING
         
  LET lwin_curr = ui.Window.getCurrent()       #得到當前的窗口句柄
  LET lfrm_curr = lwin_curr.getForm()          #得到當前Form的句柄
 
  #循環隱藏所有的不需要輸入的欄位(如開窗列為3，則其他列都被隱藏以避免進行輸入)
 { FOR li_i = mi_col_count + 1 TO MI_MAX_COL_COUNT
      LET lc_i = li_i USING '&&'
      CALL lfrm_curr.setFieldHidden('xxx'||lc_i,1)
  END FOR}
 
  LET lnode_frm = lfrm_curr.getNode()          #得到Form在Dom中的節點
  LET lnode_grid = lnode_frm.getFirstChild()   #得到Grid的節點
  LET lnode_grid = lnode_grid.getNext()   #這是從Debug Tree中看到的，不知道為什麼
  LET lnode_table = lnode_grid.getFirstChild() #得到Table的節點
  LET lnode_column = lnode_table.getFirstChild()
 
  #因為在默認的窗體創建過程中指定了除CheckBox之外的所有欄位均不能輸入，而現在
  #要用它來模擬CONSTRUCT，所以在調用INPUT過程之前要把這個邏輯反過來，即除了
  #CheckBox之外的所有欄位均可以輸入
  #注意，在模擬CONSTRUCT過程結束之后，要重新恢復原有的規則
  LET li_i = 0
  WHILE NOT lnode_column IS NULL
 
    IF li_i > mi_col_count THEN 
       EXIT WHILE
    END IF
 
    IF li_i = 0 THEN  #第一列是CheckBox
       CALL lnode_column.setAttribute('noEntry','1')
       LET li_i = li_i + 1
    ELSE
       CALL lnode_column.getAttributeString('colName','') RETURNING lc_colname
       #只處理標准的欄位(以xxx開頭)
       IF (lc_colname.substring(1,3) = 'xxx' )AND( li_i <= mi_col_count ) THEN
          CALL lnode_column.setAttribute('noEntry','0')
          LET li_i = li_i + 1
       END IF
    END IF
  
    LET lnode_column = lnode_column.getNext()
  END WHILE
 
  #---------------------------------------------------------------------------
  #以INPUT方式來接受條件查詢并自己手工合成條件
  INPUT ARRAY ma_cons_lif WITHOUT DEFAULTS FROM s_xxx.* 
        ATTRIBUTE(UNBUFFERED,INSERT ROW=TRUE, DELETE ROW=TRUE,APPEND ROW=TRUE)
    BEFORE ROW
      #紀錄當前列標
      LET l_ac = ARR_CURR()
      #在每進入一列之前都要將這一列上面的所有明細屬性欄位隱藏起來,但是作為
      #顯示用的只讀顯示列要顯示出來
      FOR li_i = 1 TO MI_MAX_COL_COUNT_TOT
          #這裡增加一個visible判斷，主要是因為如果每次都把所有控件來一遍設置，
          #這樣的時間會很長以至於能夠被用戶察覺到
          IF ( ma_multi_rec[li_i].colname.subString(1,3) = 'ttt' )AND
             ( ma_multi_rec[li_i].visible = TRUE ) THEN
             IF ma_multi_rec[li_i].dispfld <> '@SELF' THEN #所有非只讀顯示列的t欄位要隱藏
                CALL lfrm_curr.setFieldHidden(ma_multi_rec[li_i].colname,1)
             ELSE #所有的只讀顯示列要顯示
                CALL lfrm_curr.setFieldHidden(ma_multi_rec[li_i].colname,0)
             END IF
          END IF 
      END FOR
      
    #下面是20個原有欄位的離開事件，這些過程主要是向控制數組中的對應位置寫
    #信息以及顯示可能會有的明細屬性列  
    AFTER FIELD xxx01,xxx02,xxx03,xxx04,xxx05,xxx06,xxx07,xxx08,xxx09,xxx10,
                xxx11,xxx12,xxx13,xxx14,xxx15,xxx16,xxx17,xxx18,xxx19,xxx20
      CALL cl_after_normal_field(FGL_DIALOG_GETFIELDNAME(),FGL_DIALOG_GETBUFFER(),l_ac)
 
    AFTER FIELD ttt01,ttt02,ttt03,ttt04,ttt05,ttt06,ttt07,ttt08,ttt09,ttt10,
                ttt11,ttt12,ttt13,ttt14,ttt15,ttt16,ttt17,ttt18,ttt19,ttt20,
                ttt21,ttt22,ttt23,ttt24,ttt25,ttt26,ttt27,ttt28,ttt29,ttt30,
                ttt31,ttt32,ttt33,ttt34,ttt35,ttt36,ttt37,ttt38,ttt39,ttt40,
                ttt41,ttt42,ttt43,ttt44,ttt45,ttt46,ttt47,ttt48,ttt49,ttt50,
                ttt51,ttt52,ttt53,ttt54,ttt55,ttt56,ttt57,ttt58,ttt59,ttt60,
                ttt61,ttt62,ttt63
      CALL cl_after_detail_field(FGL_DIALOG_GETFIELDNAME(),FGL_DIALOG_GETBUFFER(),l_ac)
 
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE INPUT
 
  END INPUT
 
  #處理條件輸入并合成WHERE條件
  IF INT_FLAG THEN
   #  LET INT_FLAG = 0    這里不要恢復標志，然后才可以直接退出開窗
     LET g_multi_where = ''
     LET g_multi_join = ''
  ELSE 
     #這一句話用來生成SQL語句中的where條件
     CALL make_sql_condition()
  END IF  
 
  #到此為止用INPUT來模擬CONSTRUCT的語句已經全部結束了
  #----------------------------------------------------------------------------
  
  #現在恢復原有的關于noEntry的設置
  LET lnode_column = lnode_table.getFirstChild()
  LET li_i = 0
  WHILE NOT lnode_column IS NULL
 
    IF li_i > mi_col_count THEN 
       EXIT WHILE
    END IF
 
    IF li_i = 0 THEN  #第一列是CheckBox
       CALL lnode_column.setAttribute('noEntry','0')
       LET li_i = li_i + 1
    ELSE
       CALL lnode_column.getAttributeString('colName','') RETURNING lc_colname
       #只處理標准的欄位(以xxx開頭)
       IF (lc_colname.substring(1,3) = 'xxx' )AND( li_i <= mi_col_count ) THEN
          CALL lnode_column.setAttribute('noEntry','1')
          LET li_i = li_i + 1
       END IF
    END IF
    
    LET lnode_column = lnode_column.getNext()
  END WHILE
 
  #隱藏所有的輔助列,這次包括只讀顯示列也隱藏掉，因為馬上要顯示結果集了
  FOR li_i = 1 TO MI_MAX_COL_COUNT_TOT
      IF ( ma_multi_rec[li_i].colname.subString(1,3) = 'ttt')AND
         ( ma_multi_rec[li_i].visible = TRUE ) THEN
          CALL lfrm_curr.setFieldHidden(ma_multi_rec[li_i].colname,1)
      END IF 
  END FOR
 
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 一般欄位處理過程，針對'xxx'開頭的欄位，判斷是否為料件編號欄位，
#                  是否需要顯示一些明細屬性欄位以及相應的處理過程
# Input parameter: pname   STRING   欄位代碼
#                  pvalue  STRING   欄位值
#                  prow    SMALLINT 處理行數
# Return code....: void
# Usage..........: CALL cl_after_normal_field("ima01","000",l_ac)
# Date & Author..: 2005/05/03 By Lifeng
##########################################################################
 
FUNCTION cl_after_normal_field(pname,pvalue,prow)
  DEFINE pname        STRING,
         pvalue       STRING,
         prow         LIKE type_file.num5,           #No.FUN-690005 SMALLINT
         pvalue_tmp   LIKE type_file.chr1000,        #No.FUN-690005 VARCHAR(500)
         li_ia,li_ib  LIKE type_file.num5,           #No.FUN-690005 SMALLINT
         l_i          LIKE type_file.num5,           #No.FUN-690005 SMALLINT
         lnode_column om.DomNode,
  #這個數組用于接收各個屬性列的詳細信息
         g_agb        ARRAY[10] OF RECORD
                      agb03 LIKE agb_file.agb03,  #屬性代碼
                      agc02 LIKE agc_file.agc02,  #屬性的中文描述
                      agc03 LIKE agc_file.agc03,  #欄位長度
                      agc04 LIKE agc_file.agc04,  #欄位使用方式：1隨便輸，
                                                  #2選擇,3有範圍的輸入
                      agc05 LIKE agc_file.agc05,  #欄位限定起始值
                      agc06 LIKE agc_file.agc06   #欄位限定截至值
                      END RECORD,
         lsb_item     base.StringBuffer,
         lsb_value    base.StringBuffer,
         l_agd02      LIKE agd_file.agd02,
         l_agd03      LIKE agd_file.agd03,
         lwin_curr        ui.Window,
         lfrm_curr        ui.Form,
         
         li_edit      LIKE type_file.num5,           #No.FUN-690005 SMALLINT
         li_comb      LIKE type_file.num5            #No.FUN-690005 SMALLINT
  
  #定位到控制數組中的當前欄位記錄
  FOR li_ia = 1 TO MI_MAX_COL_COUNT_TOT 
      IF ma_multi_rec[li_ia].colname = pname THEN
         EXIT FOR
      END IF
  END FOR
  #如果在控制數組中沒有定位到當前欄位的信息則說明有問題，直接退出
  IF li_ia > MI_MAX_COL_COUNT_TOT THEN
     RETURN
  END IF
 
  #保存當前欄位屏幕上輸入的值
  LET ma_multi_rec[li_ia].value[prow] = pvalue
  #如果該欄位不是表示料件編號的欄位，那么就到此為止，不再進行以下的操作了
  IF ma_multi_rec[li_ia].imaFld = 'N' THEN
     RETURN
  END IF
  
  #能進行到這一步說明值已經發生了改變，需要刷新後面的輔助欄位的狀態和內容
  #接下來li_ia指向數組下標，然後開始判斷是否需要顯示後面的欄位
  LET lnode_column = ma_multi_rec[li_ia].object
  LET lnode_column = lnode_column.getNext()  #忽略顯示欄位
  #首先隱藏其后面跟著的可能已經顯示出來的20個輔助欄位
  FOR li_ib = 2 TO 21
      LET lnode_column = lnode_column.getNext()
      IF ma_multi_rec[li_ia+li_ib].visible = TRUE THEN
         CALL cl_set_comp_visible(ma_multi_rec[li_ia+li_ib].colname,FALSE)
         LET ma_multi_rec[li_ia+li_ib].value[prow] = '' #清空控制數組中可能已經存在的內容
         CALL cl_set_array_value(li_ia+li_ib,prow,'')   #清空屏幕控件中可能已經存在的內容
      END IF
  END FOR
 
  #清空該欄位對應的只讀顯示欄位的當前內容
  #CALL cl_set_array_value(li_ia+1,prow,'')
 
  LET lwin_curr = ui.Window.getCurrent()       #得到當前的窗口句柄
  LET lfrm_curr = lwin_curr.getForm()          #得到當前Form的句柄
  
  LET pvalue_tmp = pvalue
 
  #如果該欄位當前輸入的料件是要進行多屬性管理的
  IF cl_is_multi_feature_manage(pvalue) = TRUE THEN
     CALL g_agb.clear()
     DECLARE agb_cur CURSOR FOR   
       SELECT agb03,agc02,agc03,agc04,agc05,agc06 
       FROM agb_file,agc_file,ima_file
       WHERE agb01 = imaag AND agc01 = agb03 
         AND ima01 = pvalue_tmp
       ORDER BY agb02      
 
     LET l_i = 1  
     FOREACH agb_cur INTO g_agb[l_i].*     
       #判斷循環的正確性   
       IF STATUS THEN      
          CALL cl_err('foreach agb',STATUS,0)
          EXIT FOREACH     
       END IF     
  
       #分別計算出本條屬性值在控制數組中對應的兩個欄位對應的下標
       LET li_edit = li_ia + 1 + 2*l_i - 1
       LET li_comb = li_edit + 1
  
       #判斷當前這一個屬性列的取值方式       
       IF g_agb[l_i].agc04 = '2' THEN  #如果是預定義值則顯示組合框                          
          #隱藏本組對應的編輯框
          CALL cl_set_comp_visible(ma_multi_rec[li_edit].colname,FALSE)       
          LET ma_multi_rec[li_edit].visible = FALSE
          #顯示本組對應的組合框
          CALL cl_set_comp_visible(ma_multi_rec[li_comb].colname,TRUE)
          LET ma_multi_rec[li_comb].visible = TRUE
          #設置組合框對應列的列標題 
          CALL ma_multi_rec[li_comb].object.setAttribute('text',g_agb[l_i].agc02)
          
          
          #填充組合框中的選項       
          LET lsb_item  = base.StringBuffer.create()  
          LET lsb_value = base.StringBuffer.create()  
          DECLARE agd_cur CURSOR FOR       
            SELECT agd02,agd03 FROM agd_file 
            WHERE agd01 = g_agb[l_i].agb03   
          FOREACH agd_cur INTO l_agd02,l_agd03      
            IF STATUS THEN 
               CALL cl_err('foreach agb',STATUS,0)    
               EXIT FOREACH
            END IF
            #lsb_value放選項的說明  
            CALL lsb_value.append(l_agd03 CLIPPED || ",")      
            #lsb_item放選項的值     
            CALL lsb_item.append(l_agd02 CLIPPED || ",")       
          END FOREACH
          CALL cl_set_combo_items(ma_multi_rec[li_comb].colname,
                                  lsb_item.toString(),
                                  lsb_value.toString())
       ELSE  #否則顯示文本框
          #隱藏本組對應的組合框     
          CALL cl_set_comp_visible(ma_multi_rec[li_comb].colname,FALSE)
          LET ma_multi_rec[li_comb].visible = FALSE       
          #顯示本組對應的文本框
          CALL cl_set_comp_visible(ma_multi_rec[li_edit].colname,TRUE)
          LET ma_multi_rec[li_edit].visible = TRUE  
          #設置編輯框對應列的列標題 
          CALL ma_multi_rec[li_edit].object.setAttribute('text',g_agb[l_i].agc02)
       END IF     
  
       LET l_i = l_i + 1   
       #這里防止下標溢出導致錯誤
       IF l_i = 11 THEN EXIT FOREACH END IF  
     END FOREACH  
  
     #將剩下的輔助列都設置為不可見      
     FOR l_i = li_comb + 1 TO MI_MAX_COL_COUNT_TOT
         #分別計算出本條屬性值在控制數組中對應的兩個欄位對應的下標
         IF ( ma_multi_rec[l_i].colname.subString(1,3) = 'ttt' )AND
            ( ma_multi_rec[l_i].visible = TRUE )AND
            ( ma_multi_rec[l_i].dispfld.equals('@SELF') = FALSE ) THEN
            CALL cl_set_comp_visible(ma_multi_rec[l_i].colname,FALSE)
            LET ma_multi_rec[l_i].visible = FALSE
         END IF 
     END FOR
  END IF           
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 明細欄位處理過程，針對'ttt'開頭的欄位，根據輸入的內容
#                  生成明細屬性顯示信息并保存當前內容到對應的后台數組中
# Input parameter: pname   STRING    欄位代碼
#                  pvalue  STRING    欄位值
#                  pi      SMALLINT  處理行數
# Return code....: void
# Usage..........: CALL cl_after_detail_field("ttt01","abc",l_ac)
# Date & Author..: 2005/05/03 By Lifeng
##########################################################################
 
FUNCTION cl_after_detail_field(pname,pvalue,pi)
  DEFINE pname         STRING
  DEFINE pvalue        STRING
  DEFINE pi            LIKE type_file.num5           #No.FUN-690005 SMALLINT
  DEFINE lc_string     STRING
  DEFINE lc_disp_field STRING
  DEFINE li_i,li_ia    LIKE type_file.num5           #No.FUN-690005 SMALLINT
  DEFINE li_index      LIKE type_file.num5           #No.FUN-690005 SMALLINT
 
  #定位到控制數組中的當前欄位記錄
  FOR li_ia = 1 TO MI_MAX_COL_COUNT_TOT 
      IF ma_multi_rec[li_ia].colname = pname THEN
         EXIT FOR
      END IF
  END FOR
  IF li_ia > MI_MAX_COL_COUNT_TOT THEN
     RETURN
  END IF
 
  #得到當前t欄位關聯的顯示欄位名稱
  LET lc_disp_field = ma_multi_rec[li_ia].dispfld
 
  #將當前界面上接收的數值保存到控制數組中去
  LET ma_multi_rec[li_ia].value[pi] = pvalue
 
  #按照當前輸入的內容來更新顯示欄位的內容  
  IF lc_disp_field.getLength() > 0 THEN
    LET lc_string = ''
    FOR li_i = 1 TO MI_MAX_COL_COUNT_TOT
        #定位到只讀欄位對應的索引號
        IF ma_multi_rec[li_i].colname = lc_disp_field THEN
           LET li_index = li_i
        END IF
 
        #合成要顯示在只讀欄位中的內容
        IF ( ma_multi_rec[li_i].colname.subString(1,3) = 'ttt' )AND
           ( ma_multi_rec[li_i].dispfld = lc_disp_field ) THEN
           #如果該欄位當前行中有值則將其添加到只讀欄位中去
           IF ma_multi_rec[li_i].value[pi].getLength() > 0 THEN
             IF lc_string.getLength() = 0 THEN
                 LET lc_string = cl_get_comb_text(ma_multi_rec[li_i].colname,
                                     ma_multi_rec[li_i].value[pi])
             ELSE 
                 LET lc_string = lc_string,',',
                     cl_get_comb_text(ma_multi_rec[li_i].colname,
                                      ma_multi_rec[li_i].value[pi])
             END IF
           END IF
        END IF
    END FOR
 
    #修改該t欄位當前在屏幕上的顯示
    CALL cl_set_array_value(li_ia,pi,pvalue)
    #修改該t欄位對應的顯示列的當前在屏幕上的顯示
    CALL cl_set_array_value(li_index,pi,lc_string)
    #將只讀顯示列的內容保存到控制數組中的對應位置，因為這些列是noEntry的
    #不能自己觸發after_detail_field事件所以只能由其他欄位來寫
    LET ma_multi_rec[li_index].value[pi] = lc_string
 
  END IF
 
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 公共函數，判斷一個料件是否進行多屬性管理
#                  從s_multifeature.4gl中的s_is_multi_feature_manage()拷貝來
# Input parameter: p_item   料件代碼
# Return code....: TRUE/FALSE
# Usage..........: IF cl_is_multi_feature_manage(pvalue) THEN
# Date & Author..: 2005/05/03 By Lifeng
##########################################################################
 
FUNCTION cl_is_multi_feature_manage(p_item)
  DEFINE 
  p_item  LIKE ima_file.ima01,  
  l_imaag LIKE ima_file.imaag,  
  l_result  LIKE type_file.num5           #No.FUN-690005 SMALLINT   
  
  #這里簡單地進行一下查詢,并且要忽略掉已經是子料件（使用系統保留字@CHILD）的情況  
  SELECT imaag INTO l_imaag FROM ima_file 
     WHERE ima01 = p_item AND imaag != '@CHILD'   
  
  #判斷imaag欄位是否為空并賦相應的返回值  
  IF cl_null(l_imaag) THEN 
     LET l_result = 0 
  ELSE 
     LET l_result = 1 
  END IF    
  
  RETURN l_result
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
##########################################################################
 
FUNCTION cl_set_array_value(pcol,prow,pvalue)
  DEFINE pcol,prow  LIKE type_file.num5           #No.FUN-690005 SMALLINT
  DEFINE pvalue    STRING
  
  CASE pcol
    WHEN 1 
      LET ma_cons_lif[prow].item01 = pvalue
    WHEN 2
      LET ma_cons_lif[prow].item02 = pvalue
    WHEN 3
      LET ma_cons_lif[prow].item03 = pvalue
    WHEN 4 
      LET ma_cons_lif[prow].item04 = pvalue
    WHEN 5
      LET ma_cons_lif[prow].item05 = pvalue
    WHEN 6
      LET ma_cons_lif[prow].item06 = pvalue
    WHEN 7
      LET ma_cons_lif[prow].item07 = pvalue
    WHEN 8 
      LET ma_cons_lif[prow].item08 = pvalue
    WHEN 9
      LET ma_cons_lif[prow].item09 = pvalue
    WHEN 10
      LET ma_cons_lif[prow].item10 = pvalue
    WHEN 11 
      LET ma_cons_lif[prow].item11 = pvalue
    WHEN 12
      LET ma_cons_lif[prow].item12 = pvalue
    WHEN 13
      LET ma_cons_lif[prow].item13 = pvalue
    WHEN 14 
      LET ma_cons_lif[prow].item14 = pvalue
    WHEN 15
      LET ma_cons_lif[prow].item15 = pvalue
    WHEN 16
      LET ma_cons_lif[prow].item16 = pvalue
    WHEN 17
      LET ma_cons_lif[prow].item17 = pvalue
    WHEN 18 
      LET ma_cons_lif[prow].item18 = pvalue
    WHEN 19
      LET ma_cons_lif[prow].item19 = pvalue
    WHEN 20
      LET ma_cons_lif[prow].item20 = pvalue
    WHEN 21 
      LET ma_cons_lif[prow].item21 = pvalue
    WHEN 22
      LET ma_cons_lif[prow].item22 = pvalue
    WHEN 23
      LET ma_cons_lif[prow].item23 = pvalue
    WHEN 24 
      LET ma_cons_lif[prow].item24 = pvalue
    WHEN 25
      LET ma_cons_lif[prow].item25 = pvalue
    WHEN 26
      LET ma_cons_lif[prow].item26 = pvalue
    WHEN 27
      LET ma_cons_lif[prow].item27 = pvalue
    WHEN 28 
      LET ma_cons_lif[prow].item28 = pvalue
    WHEN 29
      LET ma_cons_lif[prow].item29 = pvalue
    WHEN 30
      LET ma_cons_lif[prow].item30 = pvalue
    WHEN 31 
      LET ma_cons_lif[prow].item31 = pvalue
    WHEN 32
      LET ma_cons_lif[prow].item32 = pvalue
    WHEN 33
      LET ma_cons_lif[prow].item33 = pvalue
    WHEN 34 
      LET ma_cons_lif[prow].item34 = pvalue
    WHEN 35
      LET ma_cons_lif[prow].item35 = pvalue
    WHEN 36
      LET ma_cons_lif[prow].item36 = pvalue
    WHEN 37
      LET ma_cons_lif[prow].item37 = pvalue
    WHEN 38 
      LET ma_cons_lif[prow].item38 = pvalue
    WHEN 39
      LET ma_cons_lif[prow].item39 = pvalue
    WHEN 40
      LET ma_cons_lif[prow].item40 = pvalue
    WHEN 41 
      LET ma_cons_lif[prow].item41 = pvalue
    WHEN 42
      LET ma_cons_lif[prow].item42 = pvalue
    WHEN 43
      LET ma_cons_lif[prow].item43 = pvalue
    WHEN 44 
      LET ma_cons_lif[prow].item44 = pvalue
    WHEN 45
      LET ma_cons_lif[prow].item45 = pvalue
    WHEN 46
      LET ma_cons_lif[prow].item46 = pvalue
    WHEN 47
      LET ma_cons_lif[prow].item47 = pvalue
    WHEN 48 
      LET ma_cons_lif[prow].item48 = pvalue
    WHEN 49
      LET ma_cons_lif[prow].item49 = pvalue
    WHEN 50
      LET ma_cons_lif[prow].item50 = pvalue
    WHEN 51 
      LET ma_cons_lif[prow].item51 = pvalue
    WHEN 52
      LET ma_cons_lif[prow].item52 = pvalue
    WHEN 53
      LET ma_cons_lif[prow].item53 = pvalue
 
    WHEN 54 
      LET ma_cons_lif[prow].item54 = pvalue
    WHEN 55
      LET ma_cons_lif[prow].item55 = pvalue
    WHEN 56
      LET ma_cons_lif[prow].item56 = pvalue
    WHEN 57
      LET ma_cons_lif[prow].item57 = pvalue
    WHEN 58 
      LET ma_cons_lif[prow].item58 = pvalue
    WHEN 59
      LET ma_cons_lif[prow].item59 = pvalue
    WHEN 60
      LET ma_cons_lif[prow].item60 = pvalue
    WHEN 61 
      LET ma_cons_lif[prow].item61 = pvalue
    WHEN 62
      LET ma_cons_lif[prow].item62 = pvalue
    WHEN 63
      LET ma_cons_lif[prow].item63 = pvalue
    WHEN 64 
      LET ma_cons_lif[prow].item64 = pvalue
    WHEN 65
      LET ma_cons_lif[prow].item65 = pvalue
    WHEN 66
      LET ma_cons_lif[prow].item66 = pvalue
    WHEN 67
      LET ma_cons_lif[prow].item67 = pvalue
    WHEN 68 
      LET ma_cons_lif[prow].item68 = pvalue
    WHEN 69
      LET ma_cons_lif[prow].item69 = pvalue
    WHEN 70
      LET ma_cons_lif[prow].item70 = pvalue
    WHEN 71 
      LET ma_cons_lif[prow].item71 = pvalue
    WHEN 72
      LET ma_cons_lif[prow].item72 = pvalue
    WHEN 73
      LET ma_cons_lif[prow].item73 = pvalue
    WHEN 74 
      LET ma_cons_lif[prow].item74 = pvalue
    WHEN 75
      LET ma_cons_lif[prow].item75 = pvalue
    WHEN 76
      LET ma_cons_lif[prow].item76 = pvalue
    WHEN 77
      LET ma_cons_lif[prow].item77 = pvalue
    WHEN 78 
      LET ma_cons_lif[prow].item78 = pvalue
    WHEN 79
      LET ma_cons_lif[prow].item79 = pvalue
    WHEN 80
      LET ma_cons_lif[prow].item80 = pvalue
    WHEN 81 
      LET ma_cons_lif[prow].item81 = pvalue
    WHEN 82
      LET ma_cons_lif[prow].item82 = pvalue
    WHEN 83
      LET ma_cons_lif[prow].item83 = pvalue
    
  END CASE
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 傳入欄位的名稱和欄位的值，如果該欄位是用ComboBox表示的話
#                  則返回該值在組合框中對應的文本，如果是Edit則返回傳入參數
# Input parameter: pname   STRING  欄位代碼
#                  pvalue  STRING  欄位值
# Return code....: ComboBox選擇值
# Usage..........: LET ls_str = cl_get_combo_text("ttt10","0001")
# Date & Author..: 2005/05/03 By Lifeng
##########################################################################
 
FUNCTION cl_get_comb_text(pname,pvalue)
  DEFINE pname          STRING,
         pvalue         STRING
  DEFINE lwin_curr      ui.Window,
         lfrm_curr      ui.form,
         lnode_form     om.DomNode,
         lnode_column   om.DomNode,
         lnode_child    om.DomNode,
         lnode_item     om.DomNode,
         li_i,li_ia     LIKE type_file.num5           #No.FUN-690005 SMALLINT
  DEFINE ls_tabname     STRING                        #No.FUN-720042
 
  LET lwin_curr = ui.Window.getCurrent()
  LET lfrm_curr = lwin_curr.getForm()
 
  LET ls_tabname = cl_get_table_name(pname)           #No.FUN-720042
  LET lnode_column = lfrm_curr.findNode('TableColumn',ls_tabname||"."||pname)  #No.FUN-720042
  IF lnode_column IS NULL THEN
     RETURN ''
  END IF
  
  FOR li_i = 1 TO lnode_column.getChildCount()
    LET lnode_child = lnode_column.getChildByIndex(li_i)
    IF NOT lnode_child IS NULL THEN
       IF lnode_child.getTagName() = 'ComboBox' THEN
          FOR li_ia = 1 TO lnode_child.getChildCount()
              LET lnode_item = lnode_child.getChildByIndex(li_ia)
              IF NOT lnode_item IS NULL THEN
                 IF lnode_item.getAttribute('name') = pvalue THEN
                    RETURN lnode_item.getAttribute('text')
                 END IF
              END IF
          END FOR
       END IF
    END IF
  END FOR
 
  #到這里返回表示指定的欄位使用Edit而不是ComboBox，則將傳入值直接返回
  RETURN pvalue
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 該函數按照控制數組ma_multi_rec中的內容來設置合成SQL相關的兩個全局變量
# Input parameter: none
# Return code....: void
# Usage..........: CALL make_sql_condition()
# Date & Author..: 2005/05/03 By Lifeng
##########################################################################
 
FUNCTION make_sql_condition()  
  DEFINE li_rowcount    LIKE type_file.num5           #No.FUN-690005 SMALLINT
  DEFINE lwin_curr      ui.Window,
         lfrm_curr      ui.form,
         lnode_form     om.DomNode,
         lnode_column   om.DomNode,
         lnode_child    om.DomNode,
         lnode_item     om.DomNode,
         li_i,li_ia     LIKE type_file.num5,           #No.FUN-690005 SMALLINT
         li_n           LIKE type_file.num5,           #No.FUN-690005 SMALLINT
         li_idx_a       LIKE type_file.num5,           #No.FUN-690005 SMALLINT
         li_idx_b       LIKE type_file.num5,           #No.FUN-690005 SMALLINT
         li_c           LIKE type_file.num5            #No.FUN-690005 SMALLINT
  #下面的結構體存放由數組中的值轉換成為的條件語句，每行為一個RECORD
  DEFINE arr_row    DYNAMIC ARRAY OF RECORD
           #成員變量，存放包含明細屬性的條件信息，每個料件欄位，如果
           #在界面上進行了明細屬性的設置，都會包含一個RECORD
           detail      DYNAMIC ARRAY OF RECORD
             jointable    STRING,          #需要JOIN的Table
             condition    DYNAMIC ARRAY OF STRING  #
           END RECORD,
           #成員變量，存放不包含明細屬性的其他欄位的條件設置
           normal     DYNAMIC ARRAY OF STRING 
         END RECORD
 
  DEFINE li_alias      LIKE type_file.num5,           #No.FUN-690005 SMALLINT
         lc_alias      STRING,
         lc_tablename  STRING
 
  DEFINE lc_group_min  STRING,
         lc_group      STRING,
         lc_line       STRING
           
 
  #以下這麼長一段代碼僅僅是為了得到當前屏幕數組的行數
  LET lwin_curr = ui.Window.getCurrent()
  LET lfrm_curr = lwin_curr.getForm()
  #用第一個列來作為計算的依據，其實所有列的行數都是相同的
  LET lnode_column = lfrm_curr.findNode('TableColumn','xxx01')
  IF lnode_column IS NULL THEN
     RETURN
  END IF
  
  LET li_rowcount = 0
  FOR li_i = 1 TO lnode_column.getChildCount()
    LET lnode_child = lnode_column.getChildByIndex(li_i)
    IF NOT lnode_child IS NULL THEN
       IF lnode_child.getTagName() = 'ValueList' THEN
          LET li_rowcount = lnode_child.getChildCount()
       END IF
    END IF
  END FOR
  #到這里為止已經得到了列的數量并放在了li_rowcount中
  
  #下面這個下標是用來區分用來join的各個imx_file表的別名的
  LET li_alias = 1
 
  #循環每一行
  FOR li_n = 1 to li_rowcount
      #循環該行中的每一列
      FOR li_i = 1 TO ma_multi_rec.getLength() 
          #這里解釋一下處理邏輯，第一個列肯定是x欄位，依次循環
          #凡是遇到有x欄位是imafld的，則新增加一個專門的處理過程，
          #處理其后緊跟著的11個t欄位，并將列循環下標直接跳轉到這
          #11個t欄位后的第一個x欄位繼續下一次循環,如果只是一般x欄位
          #則直接對其進行處理
          #當當前欄位名稱已經是'xxx20'時，完成對當前欄位的處理過程
          #之后自動結束循環過程
 
          #如果當前行是作為料件編號的欄位(當前欄位肯定是x欄位)
          IF ma_multi_rec[li_i].imafld = 'Y' THEN
             IF ma_multi_rec[li_i].value[li_n].getLength() > 0 THEN
                #看看其后緊跟的只顯示欄位里面有沒有值，如果沒有則表示
                #沒有設置明細屬性，否則表示設置了明細屬性
                IF ma_multi_rec[li_i+1].value[li_n].getLength() = 0 THEN
                  #沒有明細屬性，只當一般的x欄位處理
                  CALL arr_row[li_n].normal.appendElement()
                  LET arr_row[li_n].normal[arr_row[li_n].normal.getLength()] =
                      cl_make_condition(ma_multi_rec[li_i].value[li_n],
                                        ma_multi_rec[li_i].dbfield,
                                        ma_multi_rec[li_i].dbtype,'')
                ELSE
                  #有明細屬性，要記錄jointable的信息，以及各個明細屬性的條件
                  CALL arr_row[li_n].detail.appendElement()
                  LET li_idx_a = arr_row[li_n].detail.getLength()
                  LET lc_alias = li_alias USING '&&'
                  LET lc_tablename = 'tab' || lc_alias  #生成不重復的表名如tab01,tab02等
                  LET arr_row[li_n].detail[li_idx_a].jointable = 
                      'imx_file '||lc_tablename
                  #新增一個條件record
                  CALL arr_row[li_n].detail[li_idx_a].condition.appendElement()
                  LET li_idx_b = arr_row[li_n].detail[li_idx_a].condition.getLength()
                  LET arr_row[li_n].detail[li_idx_a].condition[li_idx_b] = 
                      ma_multi_rec[li_i].dbfield || ' = ' || lc_tablename || '.imx000 AND '||
                      lc_tablename || '.imx000 LIKE ''' || ma_multi_rec[li_i].value[li_n] || '%'' '
                  #下面循環處理各個明細欄位
                  FOR li_c = 2 TO 21
                      #如果該明細屬性有值才加入到條件中
                      IF ma_multi_rec[li_i+li_c].value[li_n].getLength() > 0 THEN
                         #新增一個條件record
                         CALL arr_row[li_n].detail[li_idx_a].condition.appendElement()
                         LET li_idx_b = arr_row[li_n].detail[li_idx_a].condition.getLength()
                         LET arr_row[li_n].detail[li_idx_a].condition[li_idx_b] =
                             cl_make_condition(ma_multi_rec[li_i+li_c].value[li_n],
                                               ma_multi_rec[li_i+li_c].dbfield,
                                               ma_multi_rec[li_i+li_c].dbtype,lc_tablename)
                      END IF
                  END FOR
                  
                  #增加記數標志以保証下次生成的表別名不會重復
                  LET li_alias = li_alias + 1  
                END IF
             END IF
             
             #將當前下標后移21個欄位
             LET li_i = li_i + 21
          ELSE #如果不是料件編號，只是一般的x欄位
             #如果當前欄位給了值(沒有給值則不處理，就當忽略了)
             IF ma_multi_rec[li_i].value[li_n].getLength() > 0 THEN
                CALL arr_row[li_n].normal.appendElement()
                LET li_idx_a = arr_row[li_n].normal.getLength()
                LET arr_row[li_n].normal[li_idx_a] =
                    cl_make_condition(ma_multi_rec[li_i].value[li_n],
                                      ma_multi_rec[li_i].dbfield,
                                      ma_multi_rec[li_i].dbtype,'')
             END IF
          END IF
 
          #如果當前欄位已經是'xxx20'則退出當前層次的循環
          IF ma_multi_rec[li_i].colname = 'xxx20' THEN 
             EXIT FOR
          END IF
         
      END FOR
  END FOR
 
  #按照合成的arr_row數組來賦值兩個全局變量，首先填充明細條件
  #規則，行與行之間是OR關系，同行的各個detail之間是AND關系
  #行內和detail內是AND關系
 
  #循環各個行
  LET g_multi_where = '(1 = 0)'
  LET g_multi_join = ''
  FOR li_i = 1 TO arr_row.getLength()
      #初始化臨時變量(用來存放當前列的所有條件的累加)
      LET lc_line = '1 = 1'
      #得到一行之內的所有normal條件,各個條件之間上用AND連接
      FOR li_n = 1 TO arr_row[li_i].normal.getLength()
          IF arr_row[li_i].normal[li_n].getLength() > 0 THEN
             LET lc_line = lc_line.trim(),' AND ',arr_row[li_i].normal[li_n].trim()
          END IF
      END FOR     
 
      #循環一個行之內的各個明細組
      FOR li_n = 1 TO arr_row[li_i].detail.getLength()
          #如果有jointable則將其添加到g_multi_join全局變量中去
          IF arr_row[li_i].detail[li_n].jointable.getLength() > 0 THEN
             LET g_multi_join = g_multi_join.trim(),',',arr_row[li_i].detail[li_n].jointable.trim()
          END IF
          #初始化中間變量，開始循環填充一個組內的各個條件字段
          FOR li_c = 1 TO arr_row[li_i].detail[li_n].condition.getLength()
              IF arr_row[li_i].detail[li_n].condition[li_c].getLength() > 0 THEN
                 LET lc_line = lc_line.trim(),' AND ',arr_row[li_i].detail[li_n].condition[li_c].trim()
              END IF
          END FOR
      END FOR
      #將行信息添加到總的信息串中去
      LET lc_line = lc_line.trim()
      IF lc_line.getLength() > 5 THEN  #即不是初始狀態下的'1 = 1'
        #LET g_multi_where = g_multi_where,'OR(',lc_line,')'    #MOD-8A0216 mark
         LET g_multi_where = g_multi_where,' OR (',lc_line,')'  #MOD-8A0216
      END IF
  END FOR 
 
  #注意：g_multi_join的首字符是','因此在添加到查詢語句中的時候是不需要再使用','的
  #重新整理一下g_multi_where,去除空格，并清空邏輯上的空串（即沒有設置條件）
  LET g_multi_where = g_multi_where.trim()
  IF g_multi_where = '(1 = 0)' THEN
     LET g_multi_where = ''
  ELSE
     LET g_multi_where = '(',g_multi_where,')' #如果不這樣做，凡是有OUTER的查詢都會出錯
  END IF
 
  #好了，經歷了上面的痛苦的過程，到現在為止g_multi_join和g_multi_where已經成功地合成了
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 該函數用于根據ma_multi_rec數組中的成員變量來合成具體的字段條件
# Memo...........: 其功能主要有以下：
#                  1.判斷欄位的數據類型并決定是否需要使用諸如單引號的前綴
#                  2.對于包含*的內容自動解析為LIKE語句%
#                  3.對於包含?的內容自動解析為LIKE語句_
#                  4.對於包含=的內容自動解析為該欄位等於其後的內容
#                  5.對於>n、<n、>=n、<=n或<>n解析為大於、小於、大於等於、小於等於或不等于關係
#                  6.對於n:m解析為BETWEEN AND關係
#                  7.對於x|y解析為IN關係
#                  8.對於[a-z]*表示第一字符為a-z中任意字符的數據
# Input parameter: pvalue  欄位的值/ma_multi_rec[pcol].value[prow]
#                  pfield  欄位的名稱/ma_multi_rec[pcol].dbfield
#                  ptype   欄位的數據類型/ma_multi_rec[pcol].dbtype
# Return code....: 回傳條件式
# Usage..........: cl_make_condition(ma_multi_rec[li_i+li_c].value[li_n],
#                                    ma_multi_rec[li_i+li_c].dbfield,
#                                    ma_multi_rec[li_i+li_c].dbtype,lc_tablename)
# Date & Author..: 2005/05/03 By Lifeng
##########################################################################
 
FUNCTION cl_make_condition(pvalue,pfield,ptype,ptable)
  DEFINE pvalue,pfield,ptype      STRING,
         ptable,lc_table          STRING,
         li_pos                   LIKE type_file.num5,           #No.FUN-690005 SMALLINT
         ls_like                  base.stringBuffer,
         ls_left,ls_right,ls_temp STRING,
         p_value_tmp             STRING
 
  #根據是否傳入了jointable的名字來決定字段的表前綴的名稱
  IF ptable.getLength() > 0 THEN
     LET lc_table = ptable.trim(),'.'
  ELSE
     LET lc_table = ''
  END IF
  
  LET ls_like = base.stringBuffer.Create()
 
  #判斷條件中是否包含'*'字符（將把*解析為模糊匹配）
  LET li_pos = pvalue.getIndexOf('*',1)
  IF li_pos > 0 THEN
     #如果包含'*'則理解為LIKE關系，且此時數據類型只能為CHAR
     CALL ls_like.append(pvalue)
     CALL ls_like.replace('*','%',0)  #將所有*替換成%
     IF lc_table.getLength() > 0 THEN
        RETURN lc_table.trim()||pfield.trim()||' LIKE '''||ls_like.toString()||''''
     ELSE 
        RETURN pfield.trim()||' LIKE '''||ls_like.toString()||''''
     END IF
  END IF
  
  #判斷條件中是否包含'?'字符（將被替換為單個位上的模糊匹配）
  LET li_pos = pvalue.getIndexOf('?',1)
  IF li_pos > 0 THEN
     #如果包含'*'則理解為LIKE關系，且此時數據類型只能為CHAR
     CALL ls_like.append(pvalue)
     CALL ls_like.replace('?','_',0)  #將所有?替換成_
     IF lc_table.getLength() > 0 THEN
        RETURN lc_table.trim()||pfield.trim()||' LIKE '''||ls_like.toString()||''''
     ELSE 
        RETURN pfield.trim()||' LIKE '''||ls_like.toString()||''''
     END IF
  END IF  
  
  #判斷條件是否為'='形式
  LET li_pos = pvalue.getIndexOf('=',1)
  IF li_pos = 1 THEN
     #得到要比較的內容
     LET ls_right = pvalue.subString(2,pvalue.getLength())
     #因為可能是數值型也可能是字符型所以要判斷一下
## add by chenzhong TQC-840050
     IF ptype='DATE' THEN
        IF lc_table.getLength() >0 THEN
           RETURN lc_table||pfield.trim()||"=to_date('"||ls_right.trim()||"','YYMMDD')"
        ELSE
           RETURN pfield.trim()||"=to_date('"||ls_right.trim()||"','YYMMDD')"
        END IF
     END IF 
## add end TQC-840050
##modify by chenzhong TQC-840050
#     IF ptype = 'CHAR' OR ptype = 'VARCHAR2' OR ptype = 'DATE' THEN      
     IF ptype = 'CHAR' OR ptype = 'VARCHAR2' THEN
##modify end
        IF lc_table.getLength() > 0 THEN
           RETURN lc_table||pfield.trim()||' = '''||ls_right.trim()||'''' 
        ELSE
           RETURN pfield.trim()||' = '''||ls_right.trim()||'''' 
        END IF
     ELSE
        IF ptype<>'DATE' THEN                   ##   TQC-840050 
           IF lc_table.getLength() > 0 THEN
              RETURN lc_table||pfield.trim()||' = '||ls_right.trim()
           ELSE
              RETURN pfield.trim()||' = '||ls_right.trim()
           END IF
        END IF                                   ## TQC-840050
     END IF
  END IF  
 
  #MOD-8A0216-begin-add
  #判斷條件是否為'>='形式
  LET li_pos = pvalue.getIndexOf('>=',1)
  IF li_pos = 1 THEN
     #得到要比較的內容
     LET ls_right = pvalue.subString(3,pvalue.getLength())
     #因為可能是數值型也可能是字符型所以要判斷一下
     IF ptype = 'CHAR' OR ptype = 'VARCHAR2' OR ptype = 'DATE' THEN
      #MOD-8A0216-begin-add
       IF ptype='DATE' THEN                                                                                                           
          IF lc_table.getLength() >0 THEN                                                                                             
             RETURN lc_table||pfield.trim()||" >= to_date('"||ls_right.trim()||"','YYMMDD')"                                             
          ELSE                                                                                                                        
             RETURN pfield.trim()||" >= to_date('"||ls_right.trim()||"','YYMMDD')"                                                       
          END IF                                                                                                                      
       ELSE 
      #MOD-8A0216-end-add
        IF lc_table.getLength() > 0 THEN
           RETURN lc_table||pfield.trim()||' >= '''||ls_right.trim()||'''' 
        ELSE
           RETURN pfield.trim()||' >= '''||ls_right.trim()||'''' 
        END IF
       END IF #MOD-8A0216 
     ELSE
        IF lc_table.getLength() > 0 THEN
           RETURN lc_table||pfield.trim()||' >= '||ls_right.trim()
        ELSE
           RETURN pfield.trim()||' >= '||ls_right.trim()
        END IF
     END IF
  END IF  
  #判斷條件是否為'<='形式
  LET li_pos = pvalue.getIndexOf('<=',1)
  IF li_pos = 1 THEN
     #得到要比較的內容
     LET ls_right = pvalue.subString(3,pvalue.getLength())
     #因為可能是數值型也可能是字符型所以要判斷一下
     IF ptype = 'CHAR' OR ptype = 'VARCHAR2' OR ptype = 'DATE' THEN
      #MOD-8A0216-begin-add
       IF ptype='DATE' THEN                                                                                                           
          IF lc_table.getLength() >0 THEN                                                                                             
             RETURN lc_table||pfield.trim()||" <= to_date('"||ls_right.trim()||"','YYMMDD')"                                             
          ELSE                                                                                                                        
             RETURN pfield.trim()||" <= to_date('"||ls_right.trim()||"','YYMMDD')"                                                       
          END IF                                                                                                                      
       ELSE 
      #MOD-8A0216-end-add
        IF lc_table.getLength() > 0 THEN
           RETURN lc_table||pfield.trim()||' <= '''||ls_right.trim()||'''' 
        ELSE
           RETURN pfield.trim()||' <= '''||ls_right.trim()||'''' 
        END IF
       END IF #MOD-8A0216 
     ELSE
        IF lc_table.getLength() > 0 THEN
           RETURN lc_table||pfield.trim()||' <= '||ls_right.trim()
        ELSE
           RETURN pfield.trim()||' <= '||ls_right.trim()
        END IF
     END IF
  END IF  
  
  #判斷條件是否為'<>'形式
  LET li_pos = pvalue.getIndexOf('<>',1)
  IF li_pos = 1 THEN
     #得到要比較的內容
     LET ls_right = pvalue.subString(3,pvalue.getLength())
     #因為可能是數值型也可能是字符型所以要判斷一下
     IF ptype = 'CHAR' OR ptype = 'VARCHAR2' OR ptype = 'DATE' THEN
      #MOD-8A0216-begin-add
       IF ptype='DATE' THEN                                                                                                           
          IF lc_table.getLength() >0 THEN                                                                                             
             RETURN lc_table||pfield.trim()||" <> to_date('"||ls_right.trim()||"','YYMMDD')"                                             
          ELSE                                                                                                                        
             RETURN pfield.trim()||" <> to_date('"||ls_right.trim()||"','YYMMDD')"                                                       
          END IF                                                                                                                      
       ELSE 
      #MOD-8A0216-end-add
        IF lc_table.getLength() > 0 THEN
           RETURN lc_table||pfield.trim()||' <> '''||ls_right.trim()||'''' 
        ELSE
           RETURN pfield.trim()||' <> '''||ls_right.trim()||'''' 
        END IF
       END IF #MOD-8A0216 
     ELSE
        IF lc_table.getLength() > 0 THEN
           RETURN lc_table||pfield.trim()||' <> '||ls_right.trim()
        ELSE
           RETURN pfield.trim()||' <> '||ls_right.trim()
        END IF
     END IF
  END IF  
  #MOD-8A0216-end-add
  
  #判斷條件是否為'>'形式
  LET li_pos = pvalue.getIndexOf('>',1)
  IF li_pos = 1 THEN
     #得到要比較的內容
     LET ls_right = pvalue.subString(2,pvalue.getLength())
     #因為可能是數值型也可能是字符型所以要判斷一下
     IF ptype = 'CHAR' OR ptype = 'VARCHAR2' OR ptype = 'DATE' THEN
      #MOD-8A0216-begin-add
       IF ptype='DATE' THEN                                                                                                           
          IF lc_table.getLength() >0 THEN                                                                                             
             RETURN lc_table||pfield.trim()||">to_date('"||ls_right.trim()||"','YYMMDD')"                                             
          ELSE                                                                                                                        
             RETURN pfield.trim()||">to_date('"||ls_right.trim()||"','YYMMDD')"                                                       
          END IF                                                                                                                      
       ELSE 
      #MOD-8A0216-end-add
        IF lc_table.getLength() > 0 THEN
           RETURN lc_table||pfield.trim()||' > '''||ls_right.trim()||'''' 
        ELSE
           RETURN pfield.trim()||' > '''||ls_right.trim()||'''' 
        END IF
       END IF #MOD-8A0216 
     ELSE
        IF lc_table.getLength() > 0 THEN
           RETURN lc_table||pfield.trim()||' > '||ls_right.trim()
        ELSE
           RETURN pfield.trim()||' > '||ls_right.trim()
        END IF
     END IF
  END IF  
 
  #判斷條件是否為'<'形式
  LET li_pos = pvalue.getIndexOf('<',1)
  IF li_pos = 1 THEN
     #得到要比較的內容
     LET ls_right = pvalue.subString(2,pvalue.getLength())
     #因為可能是數值型也可能是字符型所以要判斷一下
     IF ptype = 'CHAR' OR ptype = 'VARCHAR2' OR ptype = 'DATE' THEN
      #MOD-8A0216-begin-add
       IF ptype='DATE' THEN                                                                                                           
          IF lc_table.getLength() >0 THEN                                                                                             
             RETURN lc_table||pfield.trim()||"<to_date('"||ls_right.trim()||"','YYMMDD')"                                             
          ELSE                                                                                                                        
             RETURN pfield.trim()||"<to_date('"||ls_right.trim()||"','YYMMDD')"                                                       
          END IF                                                                                                                      
       ELSE 
      #MOD-8A0216-end-add
        IF lc_table.getLength() > 0 THEN
           RETURN lc_table||pfield.trim()||' < '''||ls_right.trim()||'''' 
        ELSE
           RETURN pfield.trim()||' < '''||ls_right.trim()||'''' 
        END IF
       END IF #MOD-8A0216 
     ELSE
        IF lc_table.getLength() > 0 THEN
           RETURN lc_table||pfield.trim()||' < '||ls_right.trim()
        ELSE
           RETURN pfield.trim()||' < '||ls_right.trim()
        END IF
     END IF
  END IF  
 
 
  #MOD-8A0216-begin-mark
  #將  >= 及  <= 及 <>搬到上面去判斷, 以免誤判
  ##判斷條件是否為'>='形式
  #LET li_pos = pvalue.getIndexOf('>=',1)
  #IF li_pos = 1 THEN
  #   #得到要比較的內容
  #   LET ls_right = pvalue.subString(3,pvalue.getLength())
  #   #因為可能是數值型也可能是字符型所以要判斷一下
  #   IF ptype = 'CHAR' OR ptype = 'VARCHAR2' OR ptype = 'DATE' THEN
  #      IF lc_table.getLength() > 0 THEN
  #         RETURN lc_table||pfield.trim()||' >= '''||ls_right.trim()||'''' 
  #      ELSE
  #         RETURN pfield.trim()||' >= '''||ls_right.trim()||'''' 
  #      END IF
  #   ELSE
  #      IF lc_table.getLength() > 0 THEN
  #         RETURN lc_table||pfield.trim()||' >= '||ls_right.trim()
  #      ELSE
  #         RETURN pfield.trim()||' >= '||ls_right.trim()
  #      END IF
  #   END IF
  #END IF  
  #
  ##判斷條件是否為'<='形式
  #LET li_pos = pvalue.getIndexOf('<=',1)
  #IF li_pos = 1 THEN
  #   #得到要比較的內容
  #   LET ls_right = pvalue.subString(3,pvalue.getLength())
  #   #因為可能是數值型也可能是字符型所以要判斷一下
  #   IF ptype = 'CHAR' OR ptype = 'VARCHAR2' OR ptype = 'DATE' THEN
  #      IF lc_table.getLength() > 0 THEN
  #         RETURN lc_table||pfield.trim()||' <= '''||ls_right.trim()||'''' 
  #      ELSE
  #         RETURN pfield.trim()||' <= '''||ls_right.trim()||'''' 
  #      END IF
  #   ELSE
  #      IF lc_table.getLength() > 0 THEN
  #         RETURN lc_table||pfield.trim()||' <= '||ls_right.trim()
  #      ELSE
  #         RETURN pfield.trim()||' <= '||ls_right.trim()
  #      END IF
  #   END IF
  #END IF  
  #
  ##判斷條件是否為'<>'形式
  #LET li_pos = pvalue.getIndexOf('<>',1)
  #IF li_pos = 1 THEN
  #   #得到要比較的內容
  #   LET ls_right = pvalue.subString(3,pvalue.getLength())
  #   #因為可能是數值型也可能是字符型所以要判斷一下
  #   IF ptype = 'CHAR' OR ptype = 'VARCHAR2' OR ptype = 'DATE' THEN
  #      IF lc_table.getLength() > 0 THEN
  #         RETURN lc_table||pfield.trim()||' <> '''||ls_right.trim()||'''' 
  #      ELSE
  #         RETURN pfield.trim()||' <> '''||ls_right.trim()||'''' 
  #      END IF
  #   ELSE
  #      IF lc_table.getLength() > 0 THEN
  #         RETURN lc_table||pfield.trim()||' <> '||ls_right.trim()
  #      ELSE
  #         RETURN pfield.trim()||' <> '||ls_right.trim()
  #      END IF
  #   END IF
  #END IF  
  #MOD-8A0216-end-mark
  
  #判斷條件是否為'n:m'形式
  LET li_pos = pvalue.getIndexOf(':',1)
  IF li_pos > 0 THEN
     #得到兩個要比較的內容
     LET ls_left = pvalue.subString(1,li_pos-1)
     LET ls_right = pvalue.subString(li_pos+1,pvalue.getLength())
     #這裡限定必須要按照格式輸入，不准只輸入左邊或右邊，否則該條件被忽略
     IF ls_left.trim() = '' OR ls_right.trim() = '' THEN
        RETURN '1 = 1'
     END IF
     #因為可能是數值型也可能是字符型所以要判斷一下
     
##add by shine FUN-770073
     IF ptype = 'DATE' THEN 
        IF lc_table.getLength() > 0 THEN
           RETURN lc_table||pfield.trim()||" BETWEEN TO_DATE('"||ls_left.trim()||"','YYMMDD ')"||" AND TO_DATE('"||ls_right.trim()||"','YYMMDD ')"
        ELSE 
           RETURN pfield.trim()||" BETWEEN TO_DATE('"||ls_left.trim()||"','YYMMDD ')"||" AND TO_DATE('"||ls_right.trim()||"','YYMMDD HH24:MI:SS')"
        END IF 
     END IF 
## END..........## 
#     IF ptype = 'CHAR' OR ptype = 'VARCHAR2' OR  ptype = 'DATE' THEN  
     IF ptype = 'CHAR' OR ptype = 'VARCHAR2' THEN     #FUN-770073    
        IF lc_table.getLength() > 0 THEN
           RETURN lc_table||pfield.trim()||' BETWEEN '''||ls_left.trim()||''' AND '''||ls_right.trim()||'''' 
        ELSE
           RETURN pfield.trim()||' BETWEEN '''||ls_left.trim()||''' AND '''||ls_right.trim()||''''
        END IF
     ELSE
        IF lc_table.getLength() > 0 THEN
           RETURN lc_table||pfield.trim()||' BETWEEN '||ls_left.trim()||' AND '||ls_right.trim()
        ELSE
           RETURN pfield.trim()||' BETWEEN '||ls_left.trim()||' AND '||ls_right.trim()
        END IF
     END IF
  END IF  
  
  #判斷是否是屬於x|y型，這個判斷比較複雜，要做循環，因為可能有多個值同屬IN關係
  LET p_value_tmp = pvalue
  LET li_pos = p_value_tmp.getIndexOf('|',1)
  WHILE li_pos > 0
     LET ls_left = p_value_tmp.subString(1,li_pos-1)
     IF ptype = 'CHAR' OR ptype = 'VARCHAR2' OR ptype = 'DATE' THEN
        IF ls_temp.getLength() > 0 THEN
           LET ls_temp = ls_temp.trim()||",'"||ls_left.trim()||"'"
        ELSE
           LET ls_temp = "'"||ls_left||"'"
        END IF
     ELSE
        IF ls_temp.getLength() > 0 THEN
           LET ls_temp = ls_temp.trim()||","||ls_left.trim()
        ELSE
           LET ls_temp = ls_left
        END IF
     END IF
     LET p_value_tmp = p_value_tmp.subString(li_pos+1,p_value_tmp.getLength())
     LET li_pos = p_value_tmp.getIndexOf('|',1)
  END WHILE
  IF ls_temp.getLength() > 0 THEN
     IF lc_table.getLength() > 0 THEN
        RETURN lc_table||pfield.trim()||' IN('||ls_temp.trim()||')'
     ELSE
        RETURN pfield.trim()||' IN('||ls_temp.trim()||')'
     END IF
  END IF
  
  #如果不包含上面任何字符則理解為'='關系，并且要根據字段的類型來判斷是否需要加引號
  #判斷數據類型
 
     
## add by chenzhong TQC-840050
     IF ptype='DATE' THEN
        IF lc_table.getLength() >0 THEN
           RETURN lc_table||pfield.trim()||"=to_date('"||pvalue.trim()||"','YYMMDD')"
        ELSE
           RETURN pfield.trim()||"=to_date('"||pvalue.trim()||"','YYMMDD')"
        END IF
     END IF 
## add end TQC-840050
## modify by chenzhong TQC-840050
#  IF ptype = 'CHAR' OR ptype = 'VARCHAR2' OR ptype = 'DATE' THEN
   IF ptype = 'CHAR' OR ptype = 'VARCHAR2' THEN
##modify end TQC-840050
     IF lc_table.getLength() > 0 THEN
        RETURN lc_table||pfield.trim()||' = '''||pvalue.trim()||'''' 
     ELSE
        RETURN pfield.trim()||' = '''||pvalue.trim()||'''' 
     END IF
  ELSE
     IF ptype<>'DATE' THEN                  ##TQC-840050
        IF lc_table.getLength() > 0 THEN
           RETURN lc_table||pfield.trim()||' = '||pvalue.trim()
        ELSE
           RETURN pfield.trim()||' = '||pvalue.trim()
        END IF
     END IF 
  END IF
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 因為增加了多屬性機制以後，傳統的欄位可能會因為輔助欄位
#                  的插入而產生偏移，即邏輯需要為2的xxx02其在屏幕數組中的
#                  位置可能為item14，本函數用於在這種情況下按照傳入的邏輯
#                  序號來返回正確的數值
# Input parameter: prow        SMALLINT  選擇的行數
#                  pfldindex   STRING    指定的欄位
# Return code....: 欄位值
# Usage..........: LET ls_ret_value = cl_get_array_value(pi_sel_row,'1')  
# Date & Author..: 2005/05/03 By Lifeng
##########################################################################
 
FUNCTION cl_get_array_value(prow,pfldindex)
  DEFINE prow         LIKE type_file.num5,           #No.FUN-690005 SMALLINT
         pfldindex    STRING,
         ls_colname   STRING,
         li_i         LIKE type_file.num5           #No.FUN-690005 SMALLINT
         
  LET pfldindex = pfldindex.trim() USING "&&"     #No:CHI-A40050 add by tommas
  #根據傳入的索引值來生成列名
#  LET ls_colname = 'xxx0'||pfldindex.trim()      #No:CHI-A40050 mark by tommas
  LET ls_colname = 'xxx' || pfldindex             #No:CHI-A40050 add by tommas

  FOR li_i = 1 TO MI_MAX_COL_COUNT_TOT 
      IF ma_multi_rec[li_i].colname = ls_colname THEN
         EXIT FOR
      END IF
  END FOR
  #如果下標越界則說明沒有找到這樣的一個列  
  IF li_i > MI_MAX_COL_COUNT_TOT THEN RETURN '' END IF
  #如果找到了則返回對應的值
  #說明，因為ma_multi_rec和g_ma_qry中的下標定義是一致的，所以這裡可以直接根據從前者得到的
  #下標來在後者中返回資料
  CASE li_i
    WHEN 1  RETURN g_ma_qry[prow].item01
    WHEN 2  RETURN g_ma_qry[prow].item02
    WHEN 3  RETURN g_ma_qry[prow].item03
    WHEN 4  RETURN g_ma_qry[prow].item04
    WHEN 5  RETURN g_ma_qry[prow].item05
    WHEN 6  RETURN g_ma_qry[prow].item06
    WHEN 7  RETURN g_ma_qry[prow].item07
    WHEN 8  RETURN g_ma_qry[prow].item08
    WHEN 9  RETURN g_ma_qry[prow].item09
    WHEN 10 RETURN g_ma_qry[prow].item10
    WHEN 11 RETURN g_ma_qry[prow].item11
    WHEN 12 RETURN g_ma_qry[prow].item12
    WHEN 13 RETURN g_ma_qry[prow].item13
    WHEN 14 RETURN g_ma_qry[prow].item14
    WHEN 15 RETURN g_ma_qry[prow].item15
    WHEN 16 RETURN g_ma_qry[prow].item16
    WHEN 17 RETURN g_ma_qry[prow].item17
    WHEN 18 RETURN g_ma_qry[prow].item18
    WHEN 19 RETURN g_ma_qry[prow].item19
    WHEN 20 RETURN g_ma_qry[prow].item20
    WHEN 21 RETURN g_ma_qry[prow].item21
    WHEN 22 RETURN g_ma_qry[prow].item22
    WHEN 23 RETURN g_ma_qry[prow].item23
    WHEN 24 RETURN g_ma_qry[prow].item24
    WHEN 25 RETURN g_ma_qry[prow].item25
    WHEN 26 RETURN g_ma_qry[prow].item26
    WHEN 27 RETURN g_ma_qry[prow].item27
    WHEN 28 RETURN g_ma_qry[prow].item28
    WHEN 29 RETURN g_ma_qry[prow].item29
    WHEN 30 RETURN g_ma_qry[prow].item30
    WHEN 31 RETURN g_ma_qry[prow].item31
    WHEN 32 RETURN g_ma_qry[prow].item32
    WHEN 33 RETURN g_ma_qry[prow].item33
    WHEN 34 RETURN g_ma_qry[prow].item34
    WHEN 35 RETURN g_ma_qry[prow].item35
    WHEN 36 RETURN g_ma_qry[prow].item36
    WHEN 37 RETURN g_ma_qry[prow].item37
    WHEN 38 RETURN g_ma_qry[prow].item38
    WHEN 39 RETURN g_ma_qry[prow].item39
    WHEN 40 RETURN g_ma_qry[prow].item40
    WHEN 41 RETURN g_ma_qry[prow].item41
    WHEN 42 RETURN g_ma_qry[prow].item42
    WHEN 43 RETURN g_ma_qry[prow].item43
    WHEN 44 RETURN g_ma_qry[prow].item44
    WHEN 45 RETURN g_ma_qry[prow].item45
    WHEN 46 RETURN g_ma_qry[prow].item46
    WHEN 47 RETURN g_ma_qry[prow].item47
    WHEN 48 RETURN g_ma_qry[prow].item48
    WHEN 49 RETURN g_ma_qry[prow].item49
    WHEN 50 RETURN g_ma_qry[prow].item50
    WHEN 51 RETURN g_ma_qry[prow].item51
    WHEN 52 RETURN g_ma_qry[prow].item52
    WHEN 53 RETURN g_ma_qry[prow].item53
    WHEN 54 RETURN g_ma_qry[prow].item54
    WHEN 55 RETURN g_ma_qry[prow].item55
    WHEN 56 RETURN g_ma_qry[prow].item56
    WHEN 57 RETURN g_ma_qry[prow].item57
    WHEN 58 RETURN g_ma_qry[prow].item58
    WHEN 59 RETURN g_ma_qry[prow].item59
    WHEN 60 RETURN g_ma_qry[prow].item60
    WHEN 61 RETURN g_ma_qry[prow].item61
    WHEN 62 RETURN g_ma_qry[prow].item62
    WHEN 63 RETURN g_ma_qry[prow].item63
    WHEN 64 RETURN g_ma_qry[prow].item64
    WHEN 65 RETURN g_ma_qry[prow].item65
    WHEN 66 RETURN g_ma_qry[prow].item66
    WHEN 67 RETURN g_ma_qry[prow].item67
    WHEN 68 RETURN g_ma_qry[prow].item68
    WHEN 69 RETURN g_ma_qry[prow].item69
    WHEN 70 RETURN g_ma_qry[prow].item70
    WHEN 71 RETURN g_ma_qry[prow].item71
    WHEN 72 RETURN g_ma_qry[prow].item72
    WHEN 73 RETURN g_ma_qry[prow].item73
    WHEN 74 RETURN g_ma_qry[prow].item74
    WHEN 75 RETURN g_ma_qry[prow].item75
    WHEN 76 RETURN g_ma_qry[prow].item76
    WHEN 77 RETURN g_ma_qry[prow].item77
    WHEN 78 RETURN g_ma_qry[prow].item78
    WHEN 79 RETURN g_ma_qry[prow].item79
    WHEN 80 RETURN g_ma_qry[prow].item80
    WHEN 81 RETURN g_ma_qry[prow].item81
    WHEN 82 RETURN g_ma_qry[prow].item82
    WHEN 83 RETURN g_ma_qry[prow].item83
  END CASE  
    
END FUNCTION
 
#No.FUN-710055 --start--
##########################################################################
# Descriptions...: 自定義欄位開窗功能
# Input parameter: none
# Return code....: void
# Usage..........: CALL cl_dynamic_qry() RETURNING ...
# Date & Author..: 2007/01/22 by saki
##########################################################################
 
FUNCTION cl_dynamic_qry()
   DEFINE   lc_custom        LIKE gav_file.gav08
   DEFINE   lc_controlp_i    LIKE gav_file.gav19
   DEFINE   lc_controlp_c    LIKE gav_file.gav39
   DEFINE   li_cnt           LIKE type_file.num5
   DEFINE   lwin_curr        ui.Window
   DEFINE   lfrm_curr        ui.Form
   DEFINE   lc_std_id        LIKE smb_file.smb01
   DEFINE   lnode_item       om.DomNode
   DEFINE   li_ret_cnt       LIKE type_file.num5
   DEFINE   lr_zav           RECORD LIKE zav_file.*
   DEFINE   ls_def_field     STRING
   DEFINE   ls_def_value     STRING
   DEFINE   ls_arg           STRING
   DEFINE   lnode_value_list om.DomNode,
            lnode_value      om.DomNode,
            lst_value        om.NodeList 
   DEFINE   lnode_parent     om.DomNode
   DEFINE   li_curr          LIKE type_file.num5
   DEFINE   li_show_curr     LIKE type_file.num5
   DEFINE   li_offset        LIKE type_file.num5
   DEFINE   li_pagesize      LIKE type_file.num5
   DEFINE   ls_value         STRING
   DEFINE   ls_ret1,ls_ret2,ls_ret3,ls_ret4,ls_ret5 STRING
   DEFINE   ls_tabname       STRING
 
 
   LET lwin_curr = ui.Window.getCurrent()
   LET lfrm_curr = lwin_curr.getForm()
 
   IF g_prog = "p_query" THEN
      SELECT * INTO lr_zav.* FROM zav_file
       WHERE zav01="2" AND zav02=g_frm_name AND zav03=g_fld_name
         AND zav04="N" AND zav05="default" AND zav24="c"
   ELSE
      INITIALIZE g_qryparam.* TO NULL   #No:MOD-9B0009

      CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
 
      # 先看有沒有客製資料存在
      SELECT COUNT(UNIQUE gav01) INTO li_cnt FROM gav_file
       WHERE gav01 = g_frm_name AND gav08 = "Y"
      IF li_cnt > 0 THEN
         LET lc_custom = "Y"
      ELSE
         LET lc_custom = "N"
      END IF
      # 再看有沒有行業別資料存在
      # 一般行業代碼
#     SELECT smb01 INTO lc_std_id FROM smb_file WHERE smb02="0" AND smb05="Y"  No.FUN-760072 mark
      LET lc_std_id = "std"
#     LET g_ui_setting = g_sma.sma124    #No.FUN-840011 --mark--
      SELECT COUNT(*) INTO li_cnt FROM gav_file
       WHERE gav01 = g_frm_name AND gav08 = lc_custom AND gav11 = g_ui_setting
      IF li_cnt <= 0 THEN
         LET g_ui_setting = lc_std_id
      END IF
 
      SELECT gav19 INTO lc_controlp_i FROM gav_file
       WHERE gav01 = g_frm_name AND gav02 = g_fld_name
         AND gav08 = lc_custom  AND gav11 = g_ui_setting
      SELECT gav39 INTO lc_controlp_c FROM gav_file
       WHERE gav01 = g_frm_name AND gav02 = g_fld_name
         AND gav08 = lc_custom  AND gav11 = g_ui_setting
   END IF
 
   #設定目前是在CONSTRUCT或是INPUT段
   IF cl_null(g_qryparam.state) THEN
      LET ls_tabname = cl_get_table_name(g_fld_name CLIPPED)   #No.FUN-720042  #No.FUN-760072
      LET lnode_item = lfrm_curr.findNode("FormField",ls_tabname||"."||g_fld_name CLIPPED) #No.FUN-720042 #No.FUN-760072
      IF lnode_item IS NULL THEN
         LET lnode_item = lfrm_curr.findNode("FormField","formonly."||g_fld_name CLIPPED)  #No.FUN-760072
         IF lnode_item IS NULL THEN
            LET lnode_item = lfrm_curr.findNode("TableColumn",ls_tabname||"."||g_fld_name CLIPPED) #No.FUN-720042  #No.FUN-760072
            IF lnode_item IS NULL THEN
               LET lnode_Item = lfrm_curr.findNode("TableColumn","formonly."||g_fld_name CLIPPED)  #No.FUN-760072
               IF lnode_item IS NULL THEN
                  LET lnode_Item = lfrm_curr.findNode("Matrix",ls_tabname||"."||g_fld_name CLIPPED)  #FUN-A70010
                  IF lnode_item IS NULL THEN
                     LET lnode_Item = lfrm_curr.findNode("Matrix","formonly."||g_fld_name CLIPPED)  #FUN-A70010
                     IF lnode_item IS NULL THEN
                        RETURN NULL
                     END IF
                  END IF
               END IF
            END IF
         END IF
      END IF
      IF lnode_item.getAttribute("dialogType") = "Construct" THEN
         LET g_qryparam.state = "c"
      ELSE
         LET g_qryparam.state = "i"
      END IF
   END IF
 
   CASE g_qryparam.state
      WHEN "c"
         IF g_prog != "p_query" THEN
            SELECT * INTO lr_zav.* FROM zav_file
             WHERE zav01="1" AND zav02=g_frm_name AND zav03=g_fld_name
               AND zav04=lc_custom AND zav05=g_ui_setting AND zav24="c"
         END IF
         IF NOT cl_null(lc_controlp_c) OR NOT cl_null(g_qryparam.form) THEN
            SELECT COUNT(*) INTO li_cnt FROM gab_file WHERE gab01 = lc_controlp_c AND gab11 = "Y"
            IF li_cnt > 0 THEN
               LET lc_custom = "Y"
            ELSE
               LET lc_custom = "N"
            END IF
            SELECT COUNT(*) INTO li_ret_cnt FROM gac_file
             WHERE gac01 = lc_controlp_c AND gac12 = lc_custom AND gac10 = 'Y'
 
            #設定開窗程式代碼
            IF cl_null(g_qryparam.form) THEN
               LET g_qryparam.form = lc_controlp_c
            END IF
 
         END IF
      WHEN "i"
         IF g_prog != "p_query" THEN
            SELECT * INTO lr_zav.* FROM zav_file
             WHERE zav01="1" AND zav02=g_frm_name AND zav03=g_fld_name
               AND zav04=lc_custom AND zav05=g_ui_setting AND zav24="i"
         END IF
         IF NOT cl_null(lc_controlp_i) OR NOT cl_null(g_qryparam.form) THEN
            SELECT COUNT(*) INTO li_cnt FROM gab_file WHERE gab01 = lc_controlp_i AND gab11 = "Y"
            IF li_cnt > 0 THEN
               LET lc_custom = "Y"
            ELSE
               LET lc_custom = "N"
            END IF
            SELECT COUNT(*) INTO li_ret_cnt FROM gac_file
             WHERE gac01 = lc_controlp_i AND gac12 = lc_custom AND gac10 = 'Y'
 
            #設定開窗程式代碼
            IF cl_null(g_qryparam.form) THEN
               LET g_qryparam.form = lc_controlp_i
            END IF
 
         END IF
   END CASE
 
   IF NOT cl_null(lc_controlp_i) OR NOT cl_null(g_qryparam.form) OR
      NOT cl_null(lc_controlp_c) THEN
      IF cl_null(lr_zav.zav06) THEN
         LET g_qryparam.construct = 'Y'
      ELSE
         LET g_qryparam.construct = lr_zav.zav06
      END IF
      IF NOT cl_null(lr_zav.zav07) THEN
         LET g_qryparam.where = lr_zav.zav07
      END IF
      IF cl_null(g_qryparam.pagecount) OR g_qryparam.pagecount = 0 THEN
         LET g_qryparam.pagecount = 100
      END IF
      IF cl_null(g_qryparam.multiret_index) THEN
         LET g_qryparam.multiret_index = 1
      END IF
      IF cl_null(g_qryparam.ordercons) THEN
         LET g_qryparam.ordercons = ''
      END IF
      LET ms_cons_where = ""           # 暫存CONSTRUCT區塊的WHERE條件.
      LET ms_ret1 = ""
      LET ms_ret2 = ""
      LET ms_ret3 = ""
      LET ms_ret4 = ""
      LET ms_ret5 = ""
      LET mi_multi_ret_field_index = 1
      LET mc_first_table_name = ""
      #LET gc_ignore_db = "" #FUN-980030
      #LET gc_gac04 = "" #FUN-980030
      LET gc_cust_flag = ""
      LET gc_db_type = cl_db_get_database_type()
 
      #設定default值
      FOR li_cnt = 1 TO 5
          CASE
             WHEN lr_zav.zav08[li_cnt] = "1"
                LET ls_def_value = NULL
                CASE li_cnt
                   WHEN 1
                      LET ls_def_field = lr_zav.zav09
                   WHEN 2
                      LET ls_def_field = lr_zav.zav10
                   WHEN 3
                      LET ls_def_field = lr_zav.zav11
                   WHEN 4
                      LET ls_def_field = lr_zav.zav12
                   WHEN 5
                      LET ls_def_field = lr_zav.zav13
                END CASE
                LET ls_tabname = cl_get_table_name(ls_def_field)  #No.FUN-720042
                LET lnode_item = lfrm_curr.findNode("FormField",ls_tabname||"."||ls_def_field)   #No.FUN-720042
                IF lnode_item IS NULL THEN
                   LET lnode_item = lfrm_curr.findNode("FormField","formonly."||ls_def_field)
                   IF lnode_item IS NULL THEN
                      LET lnode_item = lfrm_curr.findNode("TableColumn",ls_tabname||"."||ls_def_field)  #No.FUN-720042
                      IF lnode_item IS NULL THEN
                         LET lnode_Item = lfrm_curr.findNode("TableColumn","formonly."||ls_def_field)
                         ###FUN-A70010 START ###
                         IF lnode_item IS NULL THEN
                            LET lnode_item = lfrm_curr.findNode("Matrix",ls_tabname||"."||ls_def_field)
                            IF lnode_item IS NULL THEN
                               LET lnode_Item = lfrm_curr.findNode("Matrix","formonly."||ls_def_field)
                            END IF
                         END IF
                         ###FUN-A70010 END ###
                      END IF
                   END IF
                END IF
                IF lnode_item IS NOT NULL THEN
                   IF lnode_item.getTagName() = "TableColumn" THEN
                      LET lnode_value_list = lnode_item.getLastChild()
                      LET lst_value = lnode_value_list.selectByTagName("Value")
                      LET lnode_parent = lnode_item.getParent()
                      LET li_curr = lnode_parent.getAttribute("currentRow")
                      LET li_offset = lnode_parent.getAttribute("offset")
                      LET li_pagesize = lnode_parent.getAttribute("pageSize")
                      LET li_show_curr = li_curr - li_offset + 1
                      IF (li_curr >= li_offset) AND (li_curr < li_offset + li_pagesize) AND 
                         (li_show_curr != 0) THEN
                         LET lnode_value = lst_value.item(li_show_curr)
                         LET ls_def_value = lnode_value.getAttribute("value")
                      END IF
                   ELSE
                      LET ls_def_value = lnode_item.getAttribute("value")
                   END IF
                END IF
                CASE li_cnt
                   WHEN 1
                      LET g_qryparam.default1 = ls_def_value
                   WHEN 2
                      LET g_qryparam.default2 = ls_def_value
                   WHEN 3
                      LET g_qryparam.default3 = ls_def_value
                   WHEN 4
                      LET g_qryparam.default4 = ls_def_value
                   WHEN 5
                      LET g_qryparam.default5 = ls_def_value
                END CASE
             WHEN lr_zav.zav08[li_cnt] = "2"
                CASE li_cnt
                   WHEN 1
                      LET g_qryparam.default1 = lr_zav.zav09
                   WHEN 2
                      LET g_qryparam.default2 = lr_zav.zav10
                   WHEN 3
                      LET g_qryparam.default3 = lr_zav.zav11
                   WHEN 4
                      LET g_qryparam.default4 = lr_zav.zav12
                   WHEN 5
                      LET g_qryparam.default5 = lr_zav.zav13
                END CASE
          END CASE
      END FOR
 
      #設定arg值
      FOR li_cnt = 1 TO 9
          CASE
             WHEN lr_zav.zav14[li_cnt] = "1"
                LET ls_def_value = NULL
                CASE li_cnt
                   WHEN 1
                      LET ls_def_field = lr_zav.zav15
                   WHEN 2
                      LET ls_def_field = lr_zav.zav16
                   WHEN 3
                      LET ls_def_field = lr_zav.zav17
                   WHEN 4
                      LET ls_def_field = lr_zav.zav18
                   WHEN 5
                      LET ls_def_field = lr_zav.zav19
                   WHEN 6
                      LET ls_def_field = lr_zav.zav20
                   WHEN 7
                      LET ls_def_field = lr_zav.zav21
                   WHEN 8
                      LET ls_def_field = lr_zav.zav22
                   WHEN 9
                      LET ls_def_field = lr_zav.zav23
                END CASE
                IF ls_def_field = "g_lang" THEN
                   LET ls_def_value = g_lang
                ELSE
                   LET ls_tabname = cl_get_table_name(ls_def_field)   #No.FUN-720042
                   LET lnode_item = lfrm_curr.findNode("FormField",ls_tabname||"."||ls_def_field)  #No.FUN-720042
                   IF lnode_item IS NULL THEN
                      LET lnode_item = lfrm_curr.findNode("FormField","formonly."||ls_def_field)
                      IF lnode_item IS NULL THEN
                         LET lnode_item = lfrm_curr.findNode("TableColumn",ls_tabname||"."||ls_def_field)  #No.FUN-720042
                         IF lnode_item IS NULL THEN
                            LET lnode_Item = lfrm_curr.findNode("TableColumn","formonly."||ls_def_field)
                            ##FUN-A70010 START ###
                            IF lnode_item IS NULL THEN
                               LET lnode_item = lfrm_curr.findNode("Matrix",ls_tabname||"."||ls_def_field)
                               IF lnode_item IS NULL THEN
                                  LET lnode_Item = lfrm_curr.findNode("Matrix","formonly."||ls_def_field)
                               END IF
                            END IF
                            ##FUN-A70010 END ###
                         END IF
                      END IF
                   END IF
                   IF lnode_item IS NOT NULL THEN
                      IF lnode_item.getTagName() = "TableColumn" THEN
                         LET lnode_value_list = lnode_item.getLastChild()
                         LET lst_value = lnode_value_list.selectByTagName("Value")
                         LET lnode_parent = lnode_item.getParent()
                         LET li_curr = lnode_parent.getAttribute("currentRow")
                         LET li_offset = lnode_parent.getAttribute("offset")
                         LET li_pagesize = lnode_parent.getAttribute("pageSize")
                         LET li_show_curr = li_curr - li_offset + 1
                         IF (li_curr >= li_offset) AND (li_curr < li_offset + li_pagesize) AND 
                            (li_show_curr != 0) THEN
                            LET lnode_value = lst_value.item(li_show_curr)
                            LET ls_def_value = lnode_value.getAttribute("value")
                         END IF
                      ELSE
                         LET ls_def_value = lnode_item.getAttribute("value")
                      END IF
                   END IF
                END IF
                CASE li_cnt
                   WHEN 1
                      LET g_qryparam.arg1 = ls_def_value
                   WHEN 2
                      LET g_qryparam.arg2 = ls_def_value
                   WHEN 3
                      LET g_qryparam.arg3 = ls_def_value
                   WHEN 4
                      LET g_qryparam.arg4 = ls_def_value
                   WHEN 5
                      LET g_qryparam.arg5 = ls_def_value
                   WHEN 6
                      LET g_qryparam.arg6 = ls_def_value
                   WHEN 7
                      LET g_qryparam.arg7 = ls_def_value
                   WHEN 8
                      LET g_qryparam.arg8 = ls_def_value
                   WHEN 9
                      LET g_qryparam.arg9 = ls_def_value
                END CASE
             WHEN lr_zav.zav14[li_cnt] = "2"
                CASE li_cnt
                   WHEN 1
                      LET g_qryparam.arg1 = lr_zav.zav15
                   WHEN 2
                      LET g_qryparam.arg2 = lr_zav.zav16
                   WHEN 3
                      LET g_qryparam.arg3 = lr_zav.zav17
                   WHEN 4
                      LET g_qryparam.arg4 = lr_zav.zav18
                   WHEN 5
                      LET g_qryparam.arg5 = lr_zav.zav19
                   WHEN 6
                      LET g_qryparam.arg6 = lr_zav.zav20
                   WHEN 7
                      LET g_qryparam.arg7 = lr_zav.zav21
                   WHEN 8
                      LET g_qryparam.arg8 = lr_zav.zav22
                   WHEN 9
                      LET g_qryparam.arg9 = lr_zav.zav23
                END CASE
          END CASE
      END FOR
 
      #準備開窗並回傳
      IF g_qryparam.state = "c" THEN
         CALL cl_create_qry() RETURNING ls_ret1
      ELSE
        CASE li_ret_cnt
           WHEN 1 CALL cl_create_qry() RETURNING ls_ret1
           WHEN 2 CALL cl_create_qry() RETURNING ls_ret1,ls_ret2
           WHEN 3 CALL cl_create_qry() RETURNING ls_ret1,ls_ret2,ls_ret3
           WHEN 4 CALL cl_create_qry() RETURNING ls_ret1,ls_ret2,ls_ret3,ls_ret4
           WHEN 5 CALL cl_create_qry() RETURNING ls_ret1,ls_ret2,ls_ret3,ls_ret4,ls_ret5
        END CASE
      END IF
   END IF
 
   IF (g_qryparam.state = 'c') THEN
      INITIALIZE g_qryparam.* TO NULL
      RETURN ls_ret1
   ELSE
      INITIALIZE g_qryparam.* TO NULL
      CASE li_ret_cnt
        WHEN 1 RETURN ls_ret1
        WHEN 2 RETURN ls_ret1,ls_ret2
        WHEN 3 RETURN ls_ret1,ls_ret2,ls_ret3
        WHEN 4 RETURN ls_ret1,ls_ret2,ls_ret3,ls_ret4
        WHEN 5 RETURN ls_ret1,ls_ret2,ls_ret3,ls_ret4,ls_ret5
      END CASE
   END IF
END FUNCTION
#No.FUN-710055 ---end---
 
#-- No.FUN-790044 BEGIN --------------------------------------------------------
##################################################
# Descriptions...: 若為日期欄位則轉換日期格式
# Date & Author..: 2004/05/14 by saki
# Input Parameter: ps_field_name 畫面欄位名稱
#                  ps_field_value 欄位輸入條件
# Return code....: STRING 更改過後的日期字串
# Memo...........: 為了動態產生qry在ora版本上不能自動轉換日期格式
#                  因為欄位的定義都是STRING
##################################################
 
FUNCTION cl_qry_chg_type(ps_field_name,ps_field_value)
   DEFINE   ps_field_name   STRING
   DEFINE   ps_field_value  STRING
   DEFINE   ls_field_value  STRING
   DEFINE   lnode_root      om.DomNode
   DEFINE   llst_items      om.NodeList
   DEFINE   lnode_item      om.DomNode
   DEFINE   lnode_child     om.DomNode
   DEFINE   ls_chd_tag_name STRING
   DEFINE   ls_item_name    STRING
   DEFINE   li_i            INTEGER
   DEFINE   ls_char         STRING
   DEFINE   ls_yy           STRING
   DEFINE   ls_mm           STRING
   DEFINE   ls_dd           STRING
   DEFINE   ls_yy2          STRING
   DEFINE   ls_mm2          STRING
   DEFINE   ls_dd2          STRING
 
  
   IF (ps_field_value.getLength() = 6) OR (ps_field_value.getLength() = 7) OR
      (ps_field_value.getLength() = 8) OR (ps_field_value.getLength() = 9) OR
      (ps_field_value.getLength() = 13) OR (ps_field_value.getLength() = 17) THEN
      LET lnode_root = ui.Interface.getRootNode()
      LET llst_items = lnode_root.selectByTagName("TableColumn")
      
      FOR li_i = 1 TO llst_items.getLength()
          LET lnode_item = llst_items.item(li_i)
          LET ls_item_name = lnode_item.getAttribute("colName")
          IF (ls_item_name.equals(ps_field_name)) THEN
             LET lnode_child = lnode_item.getFirstChild()
             LET ls_chd_tag_name = lnode_child.getTagName()
 
             IF (ls_chd_tag_name.equals("Edit") OR
                 ls_chd_tag_name.equals("DateEdit")) THEN
                IF lnode_child.getAttribute("format") IS NOT NULL THEN
                   CASE
                      WHEN ps_field_value.getLength() = 6
                           LET ls_yy = ps_field_value.subString(1,2)
                           LET ls_mm = ps_field_value.subString(3,4)
                           LET ls_dd = ps_field_value.subString(5,6)
                           LET ls_field_value = ls_yy.trim() || "/" || ls_mm.trim() || "/" || ls_dd.trim()
                      WHEN ps_field_value.getLength() = 7
                           LET ls_char = ps_field_value.subString(1,1)
                           IF ls_char.equals(">") OR ls_char.equals("<") OR
                              ls_char.equals("=") THEN
                              LET ls_yy = ps_field_value.subString(2,3)
                              LET ls_mm = ps_field_value.subString(4,5)
                              LET ls_dd = ps_field_value.subString(6,7)
                              LET ls_field_value = ls_char.trim() || ls_yy.trim() || "/" || ls_mm.trim() || "/" || ls_dd.trim()
                           END IF
                      WHEN ps_field_value.getLength() = 8
                           LET ls_yy = ps_field_value.subString(1,4)
                           LET ls_mm = ps_field_value.subString(5,6)
                           LET ls_dd = ps_field_value.subString(7,8)
                           LET ls_field_value = ls_yy.trim() || "/" || ls_mm.trim() || "/" || ls_dd.trim()
                      WHEN ps_field_value.getLength() = 9
                           LET ls_char = ps_field_value.subString(1,1)
                           IF ls_char.equals(">") OR ls_char.equals("<") OR
                              ls_char.equals("=") THEN
                              LET ls_yy = ps_field_value.subString(2,5)
                              LET ls_mm = ps_field_value.subString(6,7)
                              LET ls_dd = ps_field_value.subString(8,9)
                              LET ls_field_value = ls_char.trim() || ls_yy.trim() || "/" || ls_mm.trim() || "/" || ls_dd.trim()
                           END IF
                      WHEN ps_field_value.getLength() = 13
                           LET ls_char = ps_field_value.subString(7,7)
                           IF ls_char.equals(":") THEN
                              LET ls_yy = ps_field_value.subString(1,2)
                              LET ls_mm = ps_field_value.subString(3,4)
                              LET ls_dd = ps_field_value.subString(5,6)
                              LET ls_yy2 = ps_field_value.subSTring(8,9)
                              LET ls_mm2 = ps_field_value.subString(10,11)
                              LET ls_dd2 = ps_field_value.subString(12,13)
                              LET ls_field_value = ls_yy.trim() || "/" || ls_mm.trim() || "/" || ls_dd.trim() ||
                                                   ls_char.trim() || ls_yy2.trim() || "/" || ls_mm2.trim() || "/" || ls_dd2.trim()
                           END IF
                      WHEN ps_field_value.getLength() = 17
                           LET ls_char = ps_field_value.subString(7,7)
                           IF ls_char.equals(":") THEN
                              LET ls_yy = ps_field_value.subString(1,4)
                              LET ls_mm = ps_field_value.subString(5,6)
                              LET ls_dd = ps_field_value.subString(7,8)
                              LET ls_yy2 = ps_field_value.subSTring(10,13)
                              LET ls_mm2 = ps_field_value.subString(14,15)
                              LET ls_dd2 = ps_field_value.subString(16,17)
                              LET ls_field_value = ls_yy.trim() || "/" || ls_mm.trim() || "/" || ls_dd.trim() ||
                                                   ls_char.trim() || ls_yy2.trim() || "/" || ls_mm2.trim() || "/" || ls_dd2.trim()
                           END IF
                   END CASE
                   EXIT FOR
                END IF
             END IF
          END IF
      END FOR
   END IF
   IF ls_field_value IS NULL THEN
      LET ls_field_value = ps_field_value
   END IF
 
   RETURN ls_field_value
END FUNCTION
#-- No.FUN-790044 END ----------------------------------------------------------

###WEB-C40003 START ###
##################################################
# Private Func...: TRUE
# Description  	: 改變欄位多語言
# Date & Author : 2009/03/11 by saki
# Parameter   	: pnode_frm om.DomNode <Form>節點
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION cl_web_qry_build_table(pnode_frm)
   DEFINE pnode_frm     om.DomNode
   DEFINE lnode_column  om.DomNode
   DEFINE lnode_edit    om.DomNode
   DEFINE ls_header     STRING,
          li_i          LIKE type_file.num5,
          li_col_width  LIKE type_file.num5,
          li_width      LIKE type_file.num5,
          lc_col_index  LIKE type_file.chr2
   DEFINE lwin_curr     ui.Window
   DEFINE lfrm_curr     ui.Form
   DEFINE lc_ze03       LIKE ze_file.ze03,
          lc_ze01       LIKE ze_file.ze01
   DEFINE ls_type_name  LIKE type_file.chr100,
          ls_type_width LIKE type_file.num5
   DEFINE ls_values     STRING,
          ls_items      STRING
   DEFINE l_sql         STRING                  #WEB-C40003

   LET lwin_curr = ui.Window.getCurrent()
   LET lfrm_curr = lwin_curr.getForm()

   CALL cl_getmsg("lib-018",g_lang) RETURNING lc_ze03  #FUN-110514   #WEB-C40003 rename 

   LET lnode_column = lfrm_curr.findNode("TableColumn","formonly.check")
   IF lnode_column IS NOT NULL THEN
      CALL lnode_column.setAttribute("text", lc_ze03)
      CALL lnode_column.setAttribute('name','check')
      IF (g_qryparam.state = 'i') THEN
         CALL lfrm_curr.setFieldHidden("check",1)
      END IF
   END IF

   FOR li_i = 1 TO mi_col_count
       IF cl_null(ma_gac[li_i].gae04) THEN
          LET l_sql = "SELECT wzm09 FROM ",s_dbstring("wds") CLIPPED,"wzm_file",
                      " WHERE wzm01 = 'gaq_file.gaq01' AND wzm02 = '",ma_gac[li_i].gac06,"'",
                        " AND wzm03 = ' ' AND wzm04 = ' ' AND wzm05 = ' ' AND wzm06 = ' '",
                        " AND wzm07 = '",g_lang CLIPPED,"' AND wzm08 = '",gc_cust_flag CLIPPED,"'"
          PREPARE web_create_qry_pre5 FROM l_sql
          DECLARE web_create_qry_curs5 SCROLL CURSOR FOR web_create_qry_pre5 
          OPEN web_create_qry_curs5
          FETCH web_create_qry_curs5 INTO ma_gac[li_i].gae04
          CLOSE web_create_qry_curs5
          IF cl_null(ma_gac[li_i].gae04) THEN
             LET l_sql = "SELECT gaq03 FROM ",s_dbstring("ds") CLIPPED,"gaq_file",
                          " WHERE gaq01='",ma_gac[li_i].gac06 CLIPPED,"' AND gaq02='",g_lang CLIPPED,"'"
             PREPARE web_create_qry_pre12 FROM l_sql
             DECLARE web_create_qry_curs12 SCROLL CURSOR FOR web_create_qry_pre12 
             OPEN web_create_qry_curs12
             FETCH web_create_qry_curs12 INTO ma_gac[li_i].gae04
             CLOSE web_create_qry_curs12
          END IF
       END IF
       LET ls_header = ma_gac[li_i].gae04 CLIPPED
   
       LET li_col_width = ma_gac[li_i].gac09
 
       #No.WEB-C10003 --start--
       #CALL cl_web_get_column_info(ma_gac[li_i].gac04, ma_gac[li_i].gac05, ma_gac[li_i].gac06)  #WEB-C40003 mark
       CALL cl_get_column_info(g_qryparam.plant, ma_gac[li_i].gac05, ma_gac[li_i].gac06)     #WEB-C40003
            RETURNING ls_type_name, ls_type_width
       #No.WEB-C10003 ---end---
       # 2004/05/13 by saki : 判斷此欄位在資料庫中是否為日期格式, ora必須轉換格式
       #                      才搜尋的到
       #SELECT DATA_TYPE INTO ls_type_name FROM user_tab_columns    # FUN-110530 mark
       # WHERE TABLE_NAME  = upper(ma_gac[li_i].gac05)
       #   AND COLUMN_NAME = upper(ma_gac[li_i].gac06)

       # 2003/07/08 by Hiko : 判斷Table Header是否比欄位寬度還大.
       IF (ls_header.getLength() > li_col_width) THEN
          LET li_col_width = ls_header.getLength()
       END IF
   
       LET lc_col_index = li_i USING '&&'
       LET lnode_column = lfrm_curr.findNode("TableColumn","formonly."||"xxx"||lc_col_index)
       IF lnode_column IS NOT NULL THEN

          CALL lnode_column.setAttribute("text", ls_header)
          LET lnode_edit = lnode_column.getFirstChild()
          IF lnode_edit IS NOT NULL THEN
          
             #############  FUN-110530  start ###########################
             # (0:Edit/1:CheckBox/2:DateEdit/3:ComboBox)
             CASE ma_gac[li_i].gac07
			    WHEN "1"
                   CALL lnode_column.removeChild(lnode_edit)
                   LET lnode_edit = lnode_column.createChild("CheckBox")
                   CALL lnode_column.insertBefore(lnode_edit, lnode_column.getFirstChild())                   
                   CALL lnode_edit.setAttribute("valueChecked","Y")
                   CALL lnode_edit.setAttribute("valueUnchecked","N")
                WHEN "3"
                   CALL lnode_column.removeChild(lnode_edit)
                   LET lnode_edit = lnode_column.createChild("ComboBox")
                   CALL lnode_column.insertBefore(lnode_edit, lnode_column.getFirstChild())
                   LET ls_values = ma_gac[li_i].gac13
                   LET ls_values = ls_values.trim()
                   LET ls_items = ls_values.subString(1,ls_values.getIndexOf("||",1)-1)
                   LET ls_values = ls_values.subString(ls_values.getIndexOf("||",1)+2,ls_values.getLength())
                   LET lc_ze03=""  LET ls_items=ls_items.trim() LET ls_values=ls_values.trim()
                   LET lc_ze01=ls_values.trim()
                   CALL cl_getmsg(lc_ze01,g_lang) RETURNING lc_ze03   #WEB-C40003 rename
                   IF NOT cl_null(lc_ze03) THEN LET ls_values=lc_ze03 CLIPPED END IF
                   LET lc_ze01=ls_items.trim()
                   CALL cl_getmsg(lc_ze01,g_lang) RETURNING lc_ze03   #WEB-C40003 rename
                   IF NOT cl_null(lc_ze03) THEN LET ls_items=lc_ze03 CLIPPED END IF
                   CALL cl_set_combo_items("xxx" || lc_col_index,ls_values,ls_items)   #WEB-C40003 rename
             END CASE
             #############  FUN-110530  end  ###########################
             
             CALL lnode_edit.setAttribute("width", li_col_width)

             # 2004/05/13 by saki : 若type為DATE則給format
             IF ls_type_name = "DATE" THEN
                CALL lnode_edit.setAttribute("format","yy/mm/dd")
             END IF

             IF (g_qryparam.state = 'c') THEN
                IF (li_i = mi_multi_ret_field_index) THEN
                   CALL lnode_edit.setAttribute("color", "red")
                END IF
             END IF
          END IF
       END IF
       LET li_width = li_width + li_col_width

       #填充剛剛的節點的控制信息                                   #WEB-C40003
       LET ma_multi_rec[li_i].index = li_i                     #WEB-C40003
       LET ma_multi_rec[li_i].object = lnode_column            #WEB-C40003
       LET ma_multi_rec[li_i].colname = 'xxx' || lc_col_index  #WEB-C40003
       #以下這些字段對于補充的欄位是不需要的                          #WEB-C40003
       LET ma_multi_rec[li_i].dbfield = ''                     #WEB-C40003
       LET ma_multi_rec[li_i].dbtype = ''                      #WEB-C40003
       LET ma_multi_rec[li_i].visible = TRUE                   #WEB-C40003
   END FOR 

   IF (mi_col_count < MI_MAX_COL_COUNT) THEN
      #補足欄位.
      FOR li_i = mi_col_count + 1 TO MI_MAX_COL_COUNT
         LET lc_col_index = li_i USING '&&'
         LET lnode_column = lfrm_curr.findNode("TableColumn","formonly."||"xxx"||lc_col_index)
         #填充剛剛的節點的控制信息                                   #WEB-C40003
         LET ma_multi_rec[li_i].index = li_i                     #WEB-C40003
         LET ma_multi_rec[li_i].object = lnode_column            #WEB-C40003
         LET ma_multi_rec[li_i].colname = 'xxx' || lc_col_index  #WEB-C40003
         #以下這些字段對于補充的欄位是不需要的                          #WEB-C40003
         LET ma_multi_rec[li_i].dbfield = ''                     #WEB-C40003
         LET ma_multi_rec[li_i].dbtype = ''                      #WEB-C40003
         LET ma_multi_rec[li_i].visible = FALSE                  #WEB-C40003
      END FOR
   END IF
   
   #LET li_width = li_width + mi_col_count * 2 + 7   #WEB-C40003 mark
   LET li_width = li_width + 3  #add "check" field   #WEB-C40003 
   LET li_width = 30
   CALL pnode_frm.setAttribute("width", li_width)
   CALL pnode_frm.setAttribute("height", 11)
END FUNCTION

##################################################
# Private Func...: TRUE
# Description  	: 定義CONSTRUCT區塊.
# Date & Author : 2003/07/08 by Hiko
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION cl_web_qry_cons()
   DEFINE   ls_hidden_cols   STRING

   CALL cl_create_qry_hidden_cols(mi_col_count,MI_MAX_COL_COUNT_TOT) RETURNING ls_hidden_cols
   
   #CALL cl_web_set_comp_visible(ls_hidden_cols,FALSE)   #WEB-C40003 mark
   CALL cl_set_comp_visible(ls_hidden_cols,FALSE)        #WEB-C40003
   CONSTRUCT ms_cons_where ON ms_xxx01,ms_xxx02,ms_xxx03,ms_xxx04,ms_xxx05,
                     ms_xxx06,ms_xxx07,ms_xxx08,ms_xxx09,ms_xxx10,
                     ms_xxx11,ms_xxx12,ms_xxx13,ms_xxx14,ms_xxx15,
                     ms_xxx16,ms_xxx17,ms_xxx18,ms_xxx19,ms_xxx20
                FROM s_xxx[1].xxx01,s_xxx[1].xxx02,s_xxx[1].xxx03,s_xxx[1].xxx04,s_xxx[1].xxx05,
                     s_xxx[1].xxx06,s_xxx[1].xxx07,s_xxx[1].xxx08,s_xxx[1].xxx09,s_xxx[1].xxx10,
                     s_xxx[1].xxx11,s_xxx[1].xxx12,s_xxx[1].xxx13,s_xxx[1].xxx14,s_xxx[1].xxx15,
                     s_xxx[1].xxx16,s_xxx[1].xxx17,s_xxx[1].xxx18,s_xxx[1].xxx19,s_xxx[1].xxx20
      AFTER CONSTRUCT
         CALL GET_FLDBUF(s_xxx[1].xxx01) RETURNING ms_xxx01
         CALL GET_FLDBUF(s_xxx[1].xxx02) RETURNING ms_xxx02
         CALL GET_FLDBUF(s_xxx[1].xxx03) RETURNING ms_xxx03
         CALL GET_FLDBUF(s_xxx[1].xxx04) RETURNING ms_xxx04
         CALL GET_FLDBUF(s_xxx[1].xxx05) RETURNING ms_xxx05
         CALL GET_FLDBUF(s_xxx[1].xxx06) RETURNING ms_xxx06
         CALL GET_FLDBUF(s_xxx[1].xxx07) RETURNING ms_xxx07
         CALL GET_FLDBUF(s_xxx[1].xxx08) RETURNING ms_xxx08
         CALL GET_FLDBUF(s_xxx[1].xxx09) RETURNING ms_xxx09
         CALL GET_FLDBUF(s_xxx[1].xxx10) RETURNING ms_xxx10
         CALL GET_FLDBUF(s_xxx[1].xxx11) RETURNING ms_xxx11
         CALL GET_FLDBUF(s_xxx[1].xxx12) RETURNING ms_xxx12
         CALL GET_FLDBUF(s_xxx[1].xxx13) RETURNING ms_xxx13
         CALL GET_FLDBUF(s_xxx[1].xxx14) RETURNING ms_xxx14
         CALL GET_FLDBUF(s_xxx[1].xxx15) RETURNING ms_xxx15
         CALL GET_FLDBUF(s_xxx[1].xxx16) RETURNING ms_xxx16
         CALL GET_FLDBUF(s_xxx[1].xxx17) RETURNING ms_xxx17
         CALL GET_FLDBUF(s_xxx[1].xxx18) RETURNING ms_xxx18
         CALL GET_FLDBUF(s_xxx[1].xxx19) RETURNING ms_xxx19
         CALL GET_FLDBUF(s_xxx[1].xxx20) RETURNING ms_xxx20
         CALL cl_qry_chg_type("xxx01",ms_xxx01) RETURNING ms_xxx01   #WEB-C40003 rename
         CALL cl_qry_chg_type("xxx02",ms_xxx02) RETURNING ms_xxx02   #WEB-C40003 rename
         CALL cl_qry_chg_type("xxx03",ms_xxx03) RETURNING ms_xxx03   #WEB-C40003 rename
         CALL cl_qry_chg_type("xxx04",ms_xxx04) RETURNING ms_xxx04   #WEB-C40003 rename
         CALL cl_qry_chg_type("xxx05",ms_xxx05) RETURNING ms_xxx05   #WEB-C40003 rename
         CALL cl_qry_chg_type("xxx06",ms_xxx06) RETURNING ms_xxx06   #WEB-C40003 rename
         CALL cl_qry_chg_type("xxx07",ms_xxx07) RETURNING ms_xxx07   #WEB-C40003 rename
         CALL cl_qry_chg_type("xxx08",ms_xxx08) RETURNING ms_xxx08   #WEB-C40003 rename
         CALL cl_qry_chg_type("xxx09",ms_xxx09) RETURNING ms_xxx09   #WEB-C40003 rename
         CALL cl_qry_chg_type("xxx10",ms_xxx10) RETURNING ms_xxx10   #WEB-C40003 rename
         CALL cl_qry_chg_type("xxx11",ms_xxx11) RETURNING ms_xxx11   #WEB-C40003 rename
         CALL cl_qry_chg_type("xxx12",ms_xxx12) RETURNING ms_xxx12   #WEB-C40003 rename
         CALL cl_qry_chg_type("xxx13",ms_xxx13) RETURNING ms_xxx13   #WEB-C40003 rename
         CALL cl_qry_chg_type("xxx14",ms_xxx14) RETURNING ms_xxx14   #WEB-C40003 rename
         CALL cl_qry_chg_type("xxx15",ms_xxx15) RETURNING ms_xxx15   #WEB-C40003 rename
         CALL cl_qry_chg_type("xxx16",ms_xxx16) RETURNING ms_xxx16   #WEB-C40003 rename
         CALL cl_qry_chg_type("xxx17",ms_xxx17) RETURNING ms_xxx17   #WEB-C40003 rename
         CALL cl_qry_chg_type("xxx18",ms_xxx18) RETURNING ms_xxx18   #WEB-C40003 rename
         CALL cl_qry_chg_type("xxx19",ms_xxx19) RETURNING ms_xxx19   #WEB-C40003 rename
         CALL cl_qry_chg_type("xxx20",ms_xxx20) RETURNING ms_xxx20   #WEB-C40003 rename
         DISPLAY ms_xxx01,ms_xxx02,ms_xxx03,ms_xxx04,ms_xxx05,ms_xxx06,ms_xxx07,
                 ms_xxx08,ms_xxx09,ms_xxx10,ms_xxx11,ms_xxx12,ms_xxx13,ms_xxx14,
                 ms_xxx15,ms_xxx16,ms_xxx17,ms_xxx18,ms_xxx19,ms_xxx20
              TO s_xxx[1].xxx01,s_xxx[1].xxx02,s_xxx[1].xxx03,s_xxx[1].xxx04,
                 s_xxx[1].xxx05,s_xxx[1].xxx06,s_xxx[1].xxx07,s_xxx[1].xxx08,
                 s_xxx[1].xxx09,s_xxx[1].xxx10,s_xxx[1].xxx11,s_xxx[1].xxx12,
                 s_xxx[1].xxx13,s_xxx[1].xxx14,s_xxx[1].xxx15,s_xxx[1].xxx16,
                 s_xxx[1].xxx17,s_xxx[1].xxx18,s_xxx[1].xxx19,s_xxx[1].xxx20
   END CONSTRUCT
END FUNCTION


##################################################
# Private Func...: TRUE
# Descriptions...: 採用DISPLAY ARRAY的方式來顯現查詢過後的資料.
# Date & Author..: 2003/07/08 by Hiko
# Input parameter: ps_hide_act STRING 所要隱藏的Action Button
#                  pi_start_index LIKE type_file.num10 所要顯現的查詢資料起始位置
#                  pi_end_index LIKE type_file.num10 所要顯現的查詢資料結束位置
# Return code....: LIKE type_file.num5 是否繼續
#                  LIKE type_file.num5 是否重新查詢
#                  LIKE type_file.num10 改變後的起始位置
##################################################
FUNCTION cl_web_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE ps_hide_act STRING,
          pi_start_index,pi_end_index LIKE type_file.num10
   DEFINE li_continue,li_reconstruct  LIKE type_file.num5
   DEFINE ls_hidden_cols              STRING
   DEFINE li_accept_status            LIKE type_file.num5
   DEFINE li_cancel_status            LIKE type_file.num5

   CALL cl_create_qry_hidden_cols(mi_col_count,MI_MAX_COL_COUNT_TOT) RETURNING ls_hidden_cols
   CALL cl_set_comp_visible(ls_hidden_cols,FALSE)

   DISPLAY ARRAY g_ma_qry_tmp TO s_xxx.* 
      BEFORE DISPLAY
         CALL DIALOG.setActionActive("accept",TRUE)
         CALL DIALOG.setActionActive("cancel",TRUE)
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
#        IF gc_progtype = "f" THEN
            CALL cl_set_comp_visible("prevpage,nextpage,reconstruct",TRUE)
            IF (ps_hide_act IS NOT NULL) THEN   
               CALL cl_set_comp_visible(ps_hide_act, FALSE)
            END IF
#        END IF

      ON ACTION prevpage
         IF ((pi_start_index - g_qryparam.pagecount) >= 1) THEN
            LET pi_start_index = pi_start_index - g_qryparam.pagecount
         END IF
         LET li_continue = TRUE
         EXIT DISPLAY

      ON ACTION nextpage
         IF ((pi_start_index + g_qryparam.pagecount) <= g_ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + g_qryparam.pagecount
         END IF
         LET li_continue = TRUE
         EXIT DISPLAY

      ON ACTION refresh
         LET pi_start_index = 1
         LET li_continue = TRUE
         EXIT DISPLAY

      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
         EXIT DISPLAY
 
      ON ACTION accept
         CALL cl_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
         EXIT DISPLAY
 
      ON ACTION cancel
         CALL cl_qry_cancel()
         LET li_continue = FALSE
         EXIT DISPLAY
   END DISPLAY

   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION

##################################################
# Private Func...: TRUE
# Descriptions...: 採用INPUT ARRAY的方式來顯現查詢過後的資料.
# Date & Author..: 2003/07/08 by Hiko
# Input parameter: ps_hide_act STRING 所要隱藏的Action Button
#                  pi_start_index LIKE type_file.num10 所要顯現的查詢資料起始位置
#                  pi_end_index LIKE type_file.num10 所要顯現的查詢資料結束位置
# Return code....: LIKE type_file.num5 是否繼續
#                  LIKE type_file.num5 是否重新查詢
#                  LIKE type_file.num10 改變後的起始位置
##################################################
FUNCTION cl_web_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE ps_hide_act STRING,
          pi_start_index,pi_end_index LIKE type_file.num10
   DEFINE li_i LIKE type_file.num10
   DEFINE li_continue,li_reconstruct  LIKE type_file.num5
   DEFINE ls_hidden_cols              STRING

   CALL cl_create_qry_hidden_cols(mi_col_count,MI_MAX_COL_COUNT_TOT) RETURNING ls_hidden_cols
   CALL cl_set_comp_visible(ls_hidden_cols,FALSE)

   INPUT ARRAY g_ma_qry_tmp WITHOUT DEFAULTS FROM s_xxx.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE,UNBUFFERED)
      BEFORE INPUT
         CALL DIALOG.setActionActive("accept",TRUE)
         CALL DIALOG.setActionActive("cancel",TRUE)
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
         CALL cl_set_comp_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_comp_visible(ps_hide_act, FALSE)
         END IF

      ON ACTION prevpage
         CALL GET_FLDBUF(s_xxx.check) RETURNING g_ma_qry_tmp[ARR_CURR()].check
         CALL cl_qry_reset_multi_sel(pi_start_index, pi_end_index)

         IF ((pi_start_index - g_qryparam.pagecount) >= 1) THEN
            LET pi_start_index = pi_start_index - g_qryparam.pagecount
         END IF
 
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_xxx.check) RETURNING g_ma_qry_tmp[ARR_CURR()].check
         CALL cl_qry_reset_multi_sel(pi_start_index, pi_end_index)

         IF ((pi_start_index + g_qryparam.pagecount) <= g_ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + g_qryparam.pagecount
         END IF
 
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION refresh
         FOR li_i = 1 TO g_ma_qry.getLength()
             LET g_ma_qry[li_i].check = 'N'
         END FOR

         LET pi_start_index = 1
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
          
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR() > 0 THEN
            CALL GET_FLDBUF(s_xxx.check) RETURNING g_ma_qry_tmp[ARR_CURR()].check
            CALL cl_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL cl_qry_accept(pi_start_index+ARR_CURR()-1)
         END IF
         LET li_continue = FALSE
 
         EXIT INPUT
      ON ACTION cancel
         CALL cl_qry_cancel()
         LET li_continue = FALSE
 
         EXIT INPUT

      ON ACTION selall
         FOR li_i = 1 TO g_ma_qry_tmp.getLength()
             LET g_ma_qry_tmp[li_i].check = "Y"
         END FOR

      ON ACTION selnone
         FOR li_i = 1 TO g_ma_qry_tmp.getLength()
             LET g_ma_qry_tmp[li_i].check = "N"
         END FOR
   END INPUT

   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION


##########################################################################
# Private Func...: TRUE
# Descriptions...: 畫面隱藏的欄位
# Input parameter: p_i
# Return code....: ls_hidden_cols
# Usage..........: CALL cl_create_qry_hidden_cols(1)
# Date & Author..: 2012/04/09 by tsai_yen
##########################################################################
FUNCTION cl_create_qry_hidden_cols(p_i,p_max)
   DEFINE   p_i              LIKE type_file.num5 
   DEFINE   p_max            LIKE type_file.num5
   DEFINE   ls_hidden_cols   STRING
   DEFINE   l_str            STRING           
   DEFINE   l_i              LIKE type_file.num5 

   LET p_i = p_i + 1
   IF p_i <= p_max THEN
      FOR l_i = p_i TO p_max
         LET l_str =  l_i
         LET l_str = "xxx",l_str USING "&&"

         IF cl_null(ls_hidden_cols) THEN
            LET ls_hidden_cols = l_str
         ELSE
            LET ls_hidden_cols = ls_hidden_cols CLIPPED,",",l_str CLIPPED
         END IF
      END FOR
   END IF
   
   RETURN ls_hidden_cols
END FUNCTION
###WEB-C40003 END ###
