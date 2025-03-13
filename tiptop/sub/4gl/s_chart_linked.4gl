# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: s_chart_linked.4gl
# Descriptions...: 連動圖表入口程式
# Date & Author..: No.FUN-BA0095 2011/10/25 By baogc

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../4gl/s_chart.global"

DEFINE g_lnkchartparam  RECORD
               loc1     LIKE  type_file.chr10,         
               loc2     LIKE  type_file.chr10,         
               loc3     LIKE  type_file.chr10,         
               loc4     LIKE  type_file.chr10,         
               loc5     LIKE  type_file.chr10,         
               loc6     LIKE  type_file.chr10        
                        END RECORD

# Descriptions...: 設定udm_tree中，連動圖表的主題選項
# Input Parameter: p_combo_no 下拉combo的名稱
# Usage..........: CALL s_chart_linked_set(p_combo_no)

FUNCTION s_chart_linked_set(p_combo_no)
DEFINE p_combo_no STRING
DEFINE l_combo    STRING
DEFINE l_value1   LIKE type_file.chr4
DEFINE l_value2   LIKE type_file.chr4
DEFINE l_value3   LIKE type_file.chr4
DEFINE l_value4   LIKE type_file.chr4
DEFINE l_value5   LIKE type_file.chr4
DEFINE l_value6   LIKE type_file.chr4
DEFINE l_value7   LIKE type_file.chr4
DEFINE l_value8   LIKE type_file.chr4
DEFINE l_value9   LIKE type_file.chr4
DEFINE l_value10  LIKE type_file.chr4
DEFINE l_value11  LIKE type_file.chr4
DEFINE l_item1    STRING
DEFINE l_item2    STRING
DEFINE l_item3    STRING
DEFINE l_item4    STRING
DEFINE l_item5    STRING
DEFINE l_item6    STRING
DEFINE l_item7    STRING
DEFINE l_item8    STRING
DEFINE l_item9    STRING
DEFINE l_item10   STRING
DEFINE l_item11   STRING
DEFINE l_comb     RECORD
           value  STRING, 
           item   STRING
                  END RECORD

   LET l_combo = p_combo_no  #udm_tree中下拉combo的名稱

   #銷售業績分析(1-1)
   #check主圖表有無權限
   IF s_chart_auth("s_chart_sale_m",g_user) THEN
      LET l_value1 = "1-1"
      CALL cl_getmsg('azz-151',g_lang) RETURNING l_item1
   END IF

   #部門銷售業績分析(1-2)
   #check主圖表有無權限
   IF s_chart_auth("s_chart_sale3_m",g_user) THEN
      LET l_value2 = "1-2"
      LET l_item2 = cl_getmsg('sub-100',g_lang) CLIPPED,cl_getmsg('azz-151',g_lang) CLIPPED
     #CALL cl_getmsg('',g_lang) RETURNING l_item2
   END IF

   #流通多營運銷售業績分析(1-3)
   #check主圖表有無權限
   IF s_chart_auth("s_chart_sale2_m",g_user) THEN
      LET l_value3 = "1-3"
      CALL cl_getmsg('azz-152',g_lang) RETURNING l_item3
   END IF

   #流通銷售目標與實際分析(1-4)
   #check主圖表有無權限
   IF s_chart_auth("s_chart_forecast_m",g_user) THEN
      LET l_value4 = "1-4"
      CALL cl_getmsg('azz-153',g_lang) RETURNING l_item4
   END IF

   #銷貨退回分析(1-5)
   #check主圖表有無權限
   IF s_chart_auth("s_chart_salereturn_m",g_user) THEN
      LET l_value5 = "1-5"
      CALL cl_getmsg('azz-154',g_lang) RETURNING l_item5
   END IF

   #部門銷貨退回分析(1-6)
   #check主圖表有無權限
   IF s_chart_auth("s_chart_salereturn2_m",g_user) THEN
      LET l_value6 = "1-6"
      LET l_item6 = cl_getmsg('sub-100',g_lang) CLIPPED,cl_getmsg('azz-154',g_lang) CLIPPED
     #CALL cl_getmsg('',g_lang) RETURNING l_item6
   END IF

   #採購退貨分析(1-7)
   #check主圖表有無權限
   IF s_chart_auth("s_chart_purreturn_m",g_user) THEN
      LET l_value7 = "1-7"
      CALL cl_getmsg('azz-155',g_lang) RETURNING l_item7
   END IF

   #部門採購退貨分析(1-8)
   #check主圖表有無權限
   IF s_chart_auth("s_chart_purreturn2_m",g_user) THEN
      LET l_value8 = "1-8"
      LET l_item8 = cl_getmsg('sub-100',g_lang) CLIPPED,cl_getmsg('azz-155',g_lang) CLIPPED
     #CALL cl_getmsg('',g_lang) RETURNING l_item8
   END IF

   #費用及預算耗用狀況分析(1-9)
   #check主圖表有無權限
   IF s_chart_auth("s_chart_budget_m",g_user) THEN
      LET l_value9 = "1-9"
      CALL cl_getmsg('azz-156',g_lang) RETURNING l_item9
   END IF

   #應收帳款分析(1-10)
   #check主圖表有無權限
   IF s_chart_auth("s_chart_ar_m",g_user) THEN
      LET l_value10 = "1-10"
      CALL cl_getmsg('azz-157',g_lang) RETURNING l_item10
   END IF

   #應付帳款分析(1-11)
   #check主圖表有無權限
   IF s_chart_auth("s_chart_ap_m",g_user) THEN
      LET l_value11 = "1-11"
      CALL cl_getmsg('azz-158',g_lang) RETURNING l_item11
   END IF

   IF NOT cl_null(l_value1) THEN 
      LET l_comb.value = l_value1 
      LET l_comb.item = l_item1 
   END IF
   IF NOT cl_null(l_value2) THEN
      IF NOT cl_null(l_comb.value) THEN
         LET l_comb.value = l_comb.value,",",l_value2
         LET l_comb.item  = l_comb.item,",",l_item2
      ELSE
         LET l_comb.value = l_value2
         LET l_comb.item  = l_item2
      END IF
   END IF
   IF NOT cl_null(l_value3) THEN
      IF NOT cl_null(l_comb.value) THEN
         LET l_comb.value = l_comb.value,",",l_value3
         LET l_comb.item  = l_comb.item,",",l_item3
      ELSE
         LET l_comb.value = l_value3
         LET l_comb.item  = l_item3
      END IF
   END IF
   IF NOT cl_null(l_value4) THEN
      IF NOT cl_null(l_comb.value) THEN
         LET l_comb.value = l_comb.value,",",l_value4
         LET l_comb.item  = l_comb.item,",",l_item4
      ELSE
         LET l_comb.value = l_value4
         LET l_comb.item  = l_item4
      END IF
   END IF
   IF NOT cl_null(l_value5) THEN
      IF NOT cl_null(l_comb.value) THEN
         LET l_comb.value = l_comb.value,",",l_value5
         LET l_comb.item  = l_comb.item,",",l_item5
      ELSE
         LET l_comb.value = l_value5
         LET l_comb.item  = l_item5
      END IF
   END IF
   IF NOT cl_null(l_value6) THEN
      IF NOT cl_null(l_comb.value) THEN
         LET l_comb.value = l_comb.value,",",l_value6
         LET l_comb.item  = l_comb.item,",",l_item6
      ELSE
         LET l_comb.value = l_value6
         LET l_comb.item  = l_item6
      END IF
   END IF
   IF NOT cl_null(l_value7) THEN
      IF NOT cl_null(l_comb.value) THEN
         LET l_comb.value = l_comb.value,",",l_value7
         LET l_comb.item  = l_comb.item,",",l_item7
      ELSE
         LET l_comb.value = l_value7
         LET l_comb.item  = l_item7
      END IF
   END IF
   IF NOT cl_null(l_value8) THEN
      IF NOT cl_null(l_comb.value) THEN
         LET l_comb.value = l_comb.value,",",l_value8
         LET l_comb.item  = l_comb.item,",",l_item8
      ELSE
         LET l_comb.value = l_value8
         LET l_comb.item  = l_item8
      END IF
   END IF
   IF NOT cl_null(l_value9) THEN
      IF NOT cl_null(l_comb.value) THEN
         LET l_comb.value = l_comb.value,",",l_value9
         LET l_comb.item  = l_comb.item,",",l_item9
      ELSE
         LET l_comb.value = l_value9
         LET l_comb.item  = l_item9
      END IF
   END IF
   IF NOT cl_null(l_value10) THEN
      IF NOT cl_null(l_comb.value) THEN
         LET l_comb.value = l_comb.value,",",l_value10
         LET l_comb.item  = l_comb.item,",",l_item10
      ELSE
         LET l_comb.value = l_value10
         LET l_comb.item  = l_item10
      END IF
   END IF
   IF NOT cl_null(l_value11) THEN
      IF NOT cl_null(l_comb.value) THEN
         LET l_comb.value = l_comb.value,",",l_value11
         LET l_comb.item  = l_comb.item,",",l_item11
      ELSE
         LET l_comb.value = l_value11
         LET l_comb.item  = l_item11
      END IF
   END IF

   CALL cl_set_combo_items(l_combo,l_comb.value,l_comb.item)

END FUNCTION

# Descriptions...: 接收由udm_tree傳來的資料並串各連動圖表
# Input Parameter: p_sel:   連動主題
#                  p_cht:   點選第幾個連動圖表
#                  p_value: 點選的值
# Usage..........: CALL s_chart_linked_m(p_sel,p_cht,p_value)

FUNCTION s_chart_linked_m(p_sel,p_cht,p_value)
DEFINE p_sel   LIKE type_file.chr10
DEFINE p_cht   LIKE type_file.num5
DEFINE p_value LIKE type_file.chr100


   #設定udm_tree中，連動圖表的6個位置
   LET g_lnkchartparam.loc1 = "wc_1"
   LET g_lnkchartparam.loc2 = "wc_2"
   LET g_lnkchartparam.loc3 = "wc_3"
   LET g_lnkchartparam.loc4 = "wc_4"
   LET g_lnkchartparam.loc5 = "wc_5"
   LET g_lnkchartparam.loc6 = "wc_6"

   CASE p_sel
      WHEN "1-1" #銷售業績分析
         IF cl_null(p_cht) THEN                        #由下拉選單傳值，未點選任何圖表
            INITIALIZE g_lnkchart1.* TO NULL           #將連動值清空
            CALL s_chart_sale_m(g_lnkchartparam.loc1,'')  #執行主圖表
         ELSE
            CASE p_cht
               WHEN 1 #第一個圖表（各年度銷售業績）
                  INITIALIZE g_lnkchart1.* TO NULL
                  LET g_lnkchart1.argv1 = p_value
                  CALL s_chart_sale_s1(g_lnkchart1.argv1,g_lnkchartparam.loc2,'')
               WHEN 2 #第二個圖表（年度各月銷售業績）
                  INITIALIZE g_lnkchart1.argv2 TO NULL
                  INITIALIZE g_lnkchart1.argv3 TO NULL
                  INITIALIZE g_lnkchart1.argv4 TO NULL
                  INITIALIZE g_lnkchart1.argv5 TO NULL
                  INITIALIZE g_lnkchart1.argv6 TO NULL
                  LET g_lnkchart1.argv2 = p_value
               WHEN 3 #第三個圖表（各產品分類銷售業績）
                  LET g_lnkchart1.argv3 = p_value
               WHEN 4 #第四個圖表（客戶分類銷售業績）
                  LET g_lnkchart1.argv4 = p_value
               WHEN 5 #第五個圖表（銷售地區業績比例）
                  LET g_lnkchart1.argv5 = p_value
               WHEN 6 #第六個圖表（出貨類別銷售業績）
                  LET g_lnkchart1.argv6 = p_value
            END CASE
            CALL s_chart_sale_s2(g_lnkchart1.argv1,g_lnkchart1.argv2,g_lnkchart1.argv4,g_lnkchart1.argv5,g_lnkchart1.argv6,g_lnkchartparam.loc3,'') #各產品分類銷售業績
            CALL s_chart_sale_s3(g_lnkchart1.argv1,g_lnkchart1.argv2,g_lnkchart1.argv3,g_lnkchart1.argv5,g_lnkchart1.argv6,g_lnkchartparam.loc4,'') #客戶分類銷售類績
            CALL s_chart_sale_s4(g_lnkchart1.argv1,g_lnkchart1.argv2,g_lnkchart1.argv3,g_lnkchart1.argv4,g_lnkchart1.argv6,g_lnkchartparam.loc5,'') #銷售地區業績比例
            CALL s_chart_sale_s5(g_lnkchart1.argv1,g_lnkchart1.argv2,g_lnkchart1.argv3,g_lnkchart1.argv4,g_lnkchart1.argv5,g_lnkchartparam.loc6,'') #出貨類別銷售業績
         END IF
      WHEN "1-2" #部門銷售業績分析
         IF cl_null(p_cht) THEN                        #由下拉選單傳值，未點選任何圖表
            INITIALIZE g_lnkchart1.* TO NULL           #將連動值清空
            CALL s_chart_sale3_m(g_lnkchartparam.loc1)  #執行主圖表
         ELSE
            CASE p_cht
               WHEN 1 #第一個圖表（部門各年度銷售業績）
                  INITIALIZE g_lnkchart1.* TO NULL
                  LET g_lnkchart1.argv1 = p_value
                  CALL s_chart_sale3_s1(g_lnkchart1.argv1,g_lnkchartparam.loc2)
               WHEN 2 #第二個圖表（部門年度各月銷售業績）
                  INITIALIZE g_lnkchart1.argv2 TO NULL
                  INITIALIZE g_lnkchart1.argv3 TO NULL
                  INITIALIZE g_lnkchart1.argv4 TO NULL
                  INITIALIZE g_lnkchart1.argv5 TO NULL
                  INITIALIZE g_lnkchart1.argv6 TO NULL
                  LET g_lnkchart1.argv2 = p_value
               WHEN 3 #第三個圖表（部門各產品分類銷售業績）
                  LET g_lnkchart1.argv3 = p_value
               WHEN 4 #第四個圖表（部門客戶分類銷售業績）
                  LET g_lnkchart1.argv4 = p_value
               WHEN 5 #第五個圖表（部門銷售地區業績比例）
                  LET g_lnkchart1.argv5 = p_value
               WHEN 6 #第六個圖表（部門出貨類別銷售業績）
                  LET g_lnkchart1.argv6 = p_value
            END CASE
            CALL s_chart_sale3_s2(g_lnkchart1.argv1,g_lnkchart1.argv2,g_lnkchart1.argv4,g_lnkchart1.argv5,g_lnkchart1.argv6,g_lnkchartparam.loc3) #各產品分類銷售業績
            CALL s_chart_sale3_s3(g_lnkchart1.argv1,g_lnkchart1.argv2,g_lnkchart1.argv3,g_lnkchart1.argv5,g_lnkchart1.argv6,g_lnkchartparam.loc4) #客戶分類銷售類績
            CALL s_chart_sale3_s4(g_lnkchart1.argv1,g_lnkchart1.argv2,g_lnkchart1.argv3,g_lnkchart1.argv4,g_lnkchart1.argv6,g_lnkchartparam.loc5) #銷售地區業績比例
            CALL s_chart_sale3_s5(g_lnkchart1.argv1,g_lnkchart1.argv2,g_lnkchart1.argv3,g_lnkchart1.argv4,g_lnkchart1.argv5,g_lnkchartparam.loc6) #出貨類別銷售業績
         END IF
      WHEN "1-3" #流通多營運銷售業績分析
         IF cl_null(p_cht) THEN                        #由下拉選單傳值，未點選任何圖表
            INITIALIZE g_lnkchart2.* TO NULL           #將連動值清空
            CALL s_chart_sale2_m(g_lnkchartparam.loc1) #執行主圖表
         ELSE
            CASE p_cht
               WHEN 1 #第一個圖表（多營運中心各年度銷售業額）
                  INITIALIZE g_lnkchart2.* TO NULL
                  LET g_lnkchart2.argv1 = p_value
                  CALL s_chart_sale2_s1(g_lnkchart2.argv1,g_lnkchartparam.loc2)
               WHEN 2 #第二個圖表（多營運中心年度各月銷售業績）
                  INITIALIZE g_lnkchart2.argv2 TO NULL
                  INITIALIZE g_lnkchart2.argv3 TO NULL
                  INITIALIZE g_lnkchart2.argv4 TO NULL
                  INITIALIZE g_lnkchart2.argv5 TO NULL
                  LET g_lnkchart2.argv2 = p_value
               WHEN 3 #第三個圖表（多營運中心年度產品分類銷售額）
                  LET g_lnkchart2.argv3 = p_value
               WHEN 4 #第四個圖表（多營運中心年度各城區銷售額）
                  LET g_lnkchart2.argv4 = p_value
               WHEN 5 #第五個圖表（多營運中心營運中心銷售額）
                  LET g_lnkchart2.argv5 = p_value
               WHEN 6 #第六個圖表（多營運中心營運中心折價額）
                  LET g_lnkchart2.argv5 = p_value
            END CASE
            CALL s_chart_sale2_s2(g_lnkchart2.argv1,g_lnkchart2.argv2,g_lnkchart2.argv4,g_lnkchart2.argv5,g_lnkchartparam.loc3)
            CALL s_chart_sale2_s3(g_lnkchart2.argv1,g_lnkchart2.argv2,g_lnkchart2.argv3,g_lnkchartparam.loc4)
            CALL s_chart_sale2_s4(g_lnkchart2.argv1,g_lnkchart2.argv2,g_lnkchart2.argv3,g_lnkchart2.argv4,g_lnkchartparam.loc5)
            CALL s_chart_sale2_s5(g_lnkchart2.argv1,g_lnkchart2.argv2,g_lnkchart2.argv3,g_lnkchart2.argv4,g_lnkchartparam.loc6)
         END IF
      WHEN "1-4" #流通銷售目標與實際分析
         IF cl_null(p_cht) THEN
            INITIALIZE g_lnkchart3.* TO NULL
            CALL s_chart_forecast_m(g_lnkchartparam.loc1)
         ELSE
            CASE p_cht
               WHEN 1 #第一個圖表（年度銷售目標金額）
                  INITIALIZE g_lnkchart3.* TO NULL
                  LET g_lnkchart3.argv1 = p_value
                  CALL s_chart_forecast_s1(g_lnkchart3.argv1,g_lnkchartparam.loc2)
               WHEN 2 #第二個圖表（年度各月銷售目標金額）
                  INITIALIZE g_lnkchart3.argv2 TO NULL
                  INITIALIZE g_lnkchart3.argv3 TO NULL
                  LET g_lnkchart3.argv2 = p_value
               WHEN 3 #第三個圖表（各營業中心銷售目標金額）
                  SELECT azw01 FROM azw_file WHERE azw01 = p_value
                  IF SQLCA.sqlcode = 100 THEN
                  ELSE
                     LET g_lnkchart3.argv3 = p_value
                  END IF
               WHEN 4 #第四個圖表（營運中心目標與實際比較）
                  LET g_lnkchart3.argv3 = p_value
            END CASE
            CALL s_chart_forecast_s2(g_lnkchart3.argv1,g_lnkchart3.argv2,g_lnkchartparam.loc3)
            CALL s_chart_forecast_s3(g_lnkchart3.argv1,g_lnkchart3.argv2,g_lnkchartparam.loc4)
            CALL s_chart_forecast_s4(g_lnkchart3.argv1,g_lnkchart3.argv2,g_lnkchart3.argv3,g_lnkchartparam.loc5)
            CALL s_chart_forecast_s5(g_lnkchart3.argv1,g_lnkchart3.argv2,g_lnkchart3.argv3,g_lnkchartparam.loc6)
         END IF
      WHEN "1-5" #銷貨退回分析
         IF cl_null(p_cht) THEN
            INITIALIZE g_lnkchart4.* TO NULL
            CALL s_chart_salereturn_m(g_lnkchartparam.loc1,'')
         ELSE
            CASE p_cht
               WHEN 1 #第一個圖表（各年度銷退金額）
                  INITIALIZE g_lnkchart4.* TO NULL
                  LET g_lnkchart4.argv1 = p_value
                  CALL s_chart_salereturn_s1(g_lnkchart4.argv1,g_lnkchartparam.loc2,'')
               WHEN 2 #第二個圖表（年度各月銷退金額）
                  INITIALIZE g_lnkchart4.argv2 TO NULL
                  INITIALIZE g_lnkchart4.argv3 TO NULL
                  INITIALIZE g_lnkchart4.argv4 TO NULL
                  INITIALIZE g_lnkchart4.argv5 TO NULL
                  INITIALIZE g_lnkchart4.argv6 TO NULL
                  LET g_lnkchart4.argv2 = p_value
               WHEN 3 #第三個圖表（各銷退原因銷退金額）
                  LET g_lnkchart4.argv3 = p_value
               WHEN 4 #第四個圖表（各產品分類銷退金額）
                  LET g_lnkchart4.argv4 = p_value
               WHEN 5 #第五個圖表（各客戶分類銷退金額）
                  LET g_lnkchart4.argv5 = p_value
               WHEN 6 #第六個圖表（各客戶銷退金額）
                  LET g_lnkchart4.argv6 = p_value
            END CASE
            CALL s_chart_salereturn_s2(g_lnkchart4.argv1,g_lnkchart4.argv2,g_lnkchart4.argv4,g_lnkchart4.argv5,g_lnkchart4.argv6,g_lnkchartparam.loc3,'')
            CALL s_chart_salereturn_s3(g_lnkchart4.argv1,g_lnkchart4.argv2,g_lnkchart4.argv3,g_lnkchart4.argv5,g_lnkchart4.argv6,g_lnkchartparam.loc4,'')
            CALL s_chart_salereturn_s4(g_lnkchart4.argv1,g_lnkchart4.argv2,g_lnkchart4.argv3,g_lnkchart4.argv4,g_lnkchartparam.loc5,'')
            CALL s_chart_salereturn_s5(g_lnkchart4.argv1,g_lnkchart4.argv2,g_lnkchart4.argv3,g_lnkchart4.argv4,g_lnkchart4.argv5,g_lnkchartparam.loc6,'')
         END IF
      WHEN "1-6" #部門銷貨退回分析
         IF cl_null(p_cht) THEN
            INITIALIZE g_lnkchart4.* TO NULL
            CALL s_chart_salereturn2_m(g_lnkchartparam.loc1)
         ELSE
            CASE p_cht
               WHEN 1 #第一個圖表（部門各年度銷退金額）
                  INITIALIZE g_lnkchart4.* TO NULL
                  LET g_lnkchart4.argv1 = p_value
                  CALL s_chart_salereturn2_s1(g_lnkchart4.argv1,g_lnkchartparam.loc2)
               WHEN 2 #第二個圖表（部門年度各月銷退金額）
                  INITIALIZE g_lnkchart4.argv2 TO NULL
                  INITIALIZE g_lnkchart4.argv3 TO NULL
                  INITIALIZE g_lnkchart4.argv4 TO NULL
                  INITIALIZE g_lnkchart4.argv5 TO NULL
                  INITIALIZE g_lnkchart4.argv6 TO NULL
                  LET g_lnkchart4.argv2 = p_value
               WHEN 3 #第三個圖表（部門各銷退原因銷退金額）
                  LET g_lnkchart4.argv3 = p_value
               WHEN 4 #第四個圖表（部門各產品分類銷退金額）
                  LET g_lnkchart4.argv4 = p_value
               WHEN 5 #第五個圖表（部門各客戶分類銷退金額）
                  LET g_lnkchart4.argv5 = p_value
               WHEN 6 #第六個圖表（部門各客戶銷退金額）
                  LET g_lnkchart4.argv6 = p_value
            END CASE
            CALL s_chart_salereturn2_s2(g_lnkchart4.argv1,g_lnkchart4.argv2,g_lnkchart4.argv4,g_lnkchart4.argv5,g_lnkchart4.argv6,g_lnkchartparam.loc3)
            CALL s_chart_salereturn2_s3(g_lnkchart4.argv1,g_lnkchart4.argv2,g_lnkchart4.argv3,g_lnkchart4.argv5,g_lnkchart4.argv6,g_lnkchartparam.loc4)
            CALL s_chart_salereturn2_s4(g_lnkchart4.argv1,g_lnkchart4.argv2,g_lnkchart4.argv3,g_lnkchart4.argv4,g_lnkchartparam.loc5)
            CALL s_chart_salereturn2_s5(g_lnkchart4.argv1,g_lnkchart4.argv2,g_lnkchart4.argv3,g_lnkchart4.argv4,g_lnkchart4.argv5,g_lnkchartparam.loc6)
         END IF
      WHEN "1-7" #採購退貨分析
         IF cl_null(p_cht) THEN
            INITIALIZE g_lnkchart5.* TO NULL
            CALL s_chart_purreturn_m(g_lnkchartparam.loc1,'')
         ELSE
            CASE p_cht
               WHEN 1 #第一個圖表（各年度採購退貨金額）
                  INITIALIZE g_lnkchart5.* TO NULL
                  LET g_lnkchart5.argv1 = p_value
                  CALL s_chart_purreturn_s1(g_lnkchart5.argv1,g_lnkchartparam.loc2,'')
               WHEN 2 #第二個圖表（年度各月採購退貨金額）
                  INITIALIZE g_lnkchart5.argv2 TO NULL
                  INITIALIZE g_lnkchart5.argv3 TO NULL
                  INITIALIZE g_lnkchart5.argv4 TO NULL
                  INITIALIZE g_lnkchart5.argv5 TO NULL
                  INITIALIZE g_lnkchart5.argv6 TO NULL
                  LET g_lnkchart5.argv2 = p_value
               WHEN 3 #第三個圖表（各退貨原因採購退貨金額）
                  LET g_lnkchart5.argv3 = p_value
               WHEN 4 #第四個圖表（各產品分類採購退貨金額）
                  LET g_lnkchart5.argv4 = p_value
               WHEN 5 #第五個圖表（各廠商分類採購退貨金額）
                  LET g_lnkchart5.argv5 = p_value
               WHEN 6 #第六個圖表（各廠商採購退貨金額）
                  LET g_lnkchart5.argv6 = p_value
            END CASE
            CALL s_chart_purreturn_s2(g_lnkchart5.argv1,g_lnkchart5.argv2,g_lnkchart5.argv4,g_lnkchart5.argv5,g_lnkchart5.argv6,g_lnkchartparam.loc3,'')
            CALL s_chart_purreturn_s3(g_lnkchart5.argv1,g_lnkchart5.argv2,g_lnkchart5.argv3,g_lnkchart5.argv5,g_lnkchart5.argv6,g_lnkchartparam.loc4,'')
            CALL s_chart_purreturn_s4(g_lnkchart5.argv1,g_lnkchart5.argv2,g_lnkchart5.argv3,g_lnkchart5.argv4,g_lnkchartparam.loc5,'')
            CALL s_chart_purreturn_s5(g_lnkchart5.argv1,g_lnkchart5.argv2,g_lnkchart5.argv3,g_lnkchart5.argv4,g_lnkchart5.argv5,g_lnkchartparam.loc6,'')
         END IF
      WHEN "1-8" #部門採購退貨分析
         IF cl_null(p_cht) THEN
            INITIALIZE g_lnkchart5.* TO NULL
            CALL s_chart_purreturn2_m(g_lnkchartparam.loc1)
         ELSE
            CASE p_cht
               WHEN 1 #第一個圖表（部門各年度採購退貨金額）
                  INITIALIZE g_lnkchart5.* TO NULL
                  LET g_lnkchart5.argv1 = p_value
                  CALL s_chart_purreturn2_s1(g_lnkchart5.argv1,g_lnkchartparam.loc2)
               WHEN 2 #第二個圖表（部門年度各月採購退貨金額）
                  INITIALIZE g_lnkchart5.argv2 TO NULL
                  INITIALIZE g_lnkchart5.argv3 TO NULL
                  INITIALIZE g_lnkchart5.argv4 TO NULL
                  INITIALIZE g_lnkchart5.argv5 TO NULL
                  INITIALIZE g_lnkchart5.argv6 TO NULL
                  LET g_lnkchart5.argv2 = p_value
               WHEN 3 #第三個圖表（部門各退貨原因採購退貨金額）
                  LET g_lnkchart5.argv3 = p_value
               WHEN 4 #第四個圖表（部門各產品分類採購退貨金額）
                  LET g_lnkchart5.argv4 = p_value
               WHEN 5 #第五個圖表（部門各廠商分類採購退貨金額）
                  LET g_lnkchart5.argv5 = p_value
               WHEN 6 #第六個圖表（部門各廠商採購退貨金額）
                  LET g_lnkchart5.argv6 = p_value
            END CASE
            CALL s_chart_purreturn2_s2(g_lnkchart5.argv1,g_lnkchart5.argv2,g_lnkchart5.argv4,g_lnkchart5.argv5,g_lnkchart5.argv6,g_lnkchartparam.loc3)
            CALL s_chart_purreturn2_s3(g_lnkchart5.argv1,g_lnkchart5.argv2,g_lnkchart5.argv3,g_lnkchart5.argv5,g_lnkchart5.argv6,g_lnkchartparam.loc4)
            CALL s_chart_purreturn2_s4(g_lnkchart5.argv1,g_lnkchart5.argv2,g_lnkchart5.argv3,g_lnkchart5.argv4,g_lnkchartparam.loc5)
            CALL s_chart_purreturn2_s5(g_lnkchart5.argv1,g_lnkchart5.argv2,g_lnkchart5.argv3,g_lnkchart5.argv4,g_lnkchart5.argv5,g_lnkchartparam.loc6)
         END IF
      WHEN "1-9" #費用及預算耗用分析
         IF cl_null(p_cht) THEN
            INITIALIZE g_lnkchart6.* TO NULL
            CALL s_chart_budget_m(g_lnkchartparam.loc1)
         ELSE
            CASE p_cht
               WHEN 1 #第一個圖表（各年度費用金額）
                  INITIALIZE g_lnkchart6.* TO NULL
                  LET g_lnkchart6.argv1 = p_value
               WHEN 2 #第二個圖表（各費用原因費用使用比例）
                  LET g_lnkchart6.argv2 = p_value
               WHEN 3 #第三個圖表（各部門費用比例）
                  LET g_lnkchart6.argv3 = p_value
               WHEN 4 #第四個圖表（各專案費用比例）
                  LET g_lnkchart6.argv4 = p_value
               WHEN 5 #第五個圖表（各科目費用比例）
                  LET g_lnkchart6.argv5 = p_value
               WHEN 6 #第六個圖表（年度期別預算消耗狀況）
                  LET g_lnkchart6.argv6 = p_value
            END CASE
            CALL s_chart_budget_s1(g_lnkchart6.argv1,g_lnkchart6.argv3,g_lnkchart6.argv4,g_lnkchart6.argv5,g_lnkchart6.argv6,g_lnkchartparam.loc2)
            CALL s_chart_budget_s2(g_lnkchart6.argv1,g_lnkchart6.argv2,g_lnkchart6.argv4,g_lnkchart6.argv5,g_lnkchart6.argv6,g_lnkchartparam.loc3)
            CALL s_chart_budget_s3(g_lnkchart6.argv1,g_lnkchart6.argv2,g_lnkchart6.argv3,g_lnkchart6.argv5,g_lnkchart6.argv6,g_lnkchartparam.loc4)
            CALL s_chart_budget_s4(g_lnkchart6.argv1,g_lnkchart6.argv2,g_lnkchart6.argv3,g_lnkchart6.argv4,g_lnkchart6.argv6,g_lnkchartparam.loc5)
            CALL s_chart_budget_s5(g_lnkchart6.argv1,g_lnkchart6.argv2,g_lnkchart6.argv3,g_lnkchart6.argv4,g_lnkchart6.argv5,g_lnkchartparam.loc6)
         END IF
      WHEN "1-10" #應收帳款分析
         IF cl_null(p_cht) THEN
            INITIALIZE g_lnkchart7.* TO NULL
            CALL s_chart_ar_m(g_lnkchartparam.loc1)
         ELSE
            CASE p_cht
               WHEN 1 #第一個圖表（各年月應收帳款狀況）
                  INITIALIZE g_lnkchart7.* TO NULL
                  LET g_lnkchart7.argv1 = p_value
               WHEN 2 #第二個圖表（各帳款類別應收帳款比例）
                  LET g_lnkchart7.argv2 = p_value
               WHEN 3 #第三個圖表（內銷/外銷應收帳款比例）
                  LET g_lnkchart7.argv3 = p_value
               WHEN 4 #第四個圖表（帳款部門應收帳款比例）
                  LET g_lnkchart7.argv4 = p_value
               WHEN 5 #第五個圖表（帳款人員應收帳款比例）
                  LET g_lnkchart7.argv5 = p_value
               WHEN 6 #第六個圖表（收款客戶應收帳款比例）
                  LET g_lnkchart7.argv6 = p_value
            END CASE
            CALL s_chart_ar_s1(g_lnkchart7.argv1,g_lnkchart7.argv3,g_lnkchart7.argv4,g_lnkchart7.argv5,g_lnkchart7.argv6,g_lnkchartparam.loc2)
            CALL s_chart_ar_s2(g_lnkchart7.argv1,g_lnkchart7.argv2,g_lnkchart7.argv4,g_lnkchart7.argv5,g_lnkchart7.argv6,g_lnkchartparam.loc3)
            CALL s_chart_ar_s3(g_lnkchart7.argv1,g_lnkchart7.argv2,g_lnkchart7.argv3,g_lnkchart7.argv6,g_lnkchartparam.loc4)
            CALL s_chart_ar_s4(g_lnkchart7.argv1,g_lnkchart7.argv2,g_lnkchart7.argv3,g_lnkchart7.argv4,g_lnkchart7.argv6,g_lnkchartparam.loc5)
            CALL s_chart_ar_s5(g_lnkchart7.argv1,g_lnkchart7.argv2,g_lnkchart7.argv3,g_lnkchart7.argv4,g_lnkchart7.argv5,g_lnkchartparam.loc6)
         END IF
      WHEN "1-11" #應付帳款分析
         IF cl_null(p_cht) THEN
            INITIALIZE g_lnkchart8.* TO NULL
            CALL s_chart_ap_m(g_lnkchartparam.loc1)
         ELSE
            CASE p_cht
               WHEN 1 #第一個圖表（各年月應付帳款比例）
                  INITIALIZE g_lnkchart8.* TO NULL
                  LET g_lnkchart8.argv1 = p_value
               WHEN 2 #第二個圖表（各帳款類別應付帳款比例）
                  INITIALIZE g_lnkchart8.argv2 TO NULL
                  INITIALIZE g_lnkchart8.argv3 TO NULL
                  INITIALIZE g_lnkchart8.argv4 TO NULL
                  INITIALIZE g_lnkchart8.argv5 TO NULL
                  INITIALIZE g_lnkchart8.argv6 TO NULL
                  LET g_lnkchart8.argv2 = p_value
               WHEN 3 #第三個圖表（各請款部門應付帳款比例）
                  LET g_lnkchart8.argv3 = p_value
               WHEN 4 #第四個圖表（請款人員應付帳款比例）
                  LET g_lnkchart8.argv4 = p_value
               WHEN 5 #第五個圖表（付款方式應付帳款比例）
                  LET g_lnkchart8.argv5 = p_value
               WHEN 6 #第六個圖表（各廠商應付帳款狀況）
                  LET g_lnkchart8.argv6 = p_value
            END CASE
            CALL s_chart_ap_s1(g_lnkchart8.argv1,g_lnkchart8.argv3,g_lnkchart8.argv4,g_lnkchart8.argv5,g_lnkchart8.argv6,g_lnkchartparam.loc2)
            CALL s_chart_ap_s2(g_lnkchart8.argv1,g_lnkchart8.argv2,g_lnkchart8.argv4,g_lnkchart8.argv5,g_lnkchart8.argv6,g_lnkchartparam.loc3)
            CALL s_chart_ap_s3(g_lnkchart8.argv1,g_lnkchart8.argv2,g_lnkchart8.argv3,g_lnkchart8.argv5,g_lnkchart8.argv6,g_lnkchartparam.loc4)
            CALL s_chart_ap_s4(g_lnkchart8.argv1,g_lnkchart8.argv2,g_lnkchart8.argv3,g_lnkchart8.argv4,g_lnkchart8.argv6,g_lnkchartparam.loc5)
            CALL s_chart_ap_s5(g_lnkchart8.argv1,g_lnkchart8.argv2,g_lnkchart8.argv3,g_lnkchart8.argv4,g_lnkchart8.argv5,g_lnkchartparam.loc6)
         END IF
   END CASE

END FUNCTION

#FUN-BA0095
