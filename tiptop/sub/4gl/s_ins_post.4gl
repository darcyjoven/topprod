# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: s_ins_post.4gl
# Descriptions...: 
# Date & Author..: No.FUN-CC0082 12/12/20 By baogc

DATABASE ds

GLOBALS "../../config/top.global"

# Function name..: s_insrvu(p_rvu,p_rvv)
# Descriptions...: 将入库/仓退单数据新增到数据库中
# Input Parameter: p_rvu 入库/仓退单单头Record
#                  p_rvv 入库/仓退单单身数组Record
# Usage..........: CALL s_insrvu(l_rvu,l_rvv)

FUNCTION s_insrvu(p_rvu,p_rvv)
DEFINE p_rvu     RECORD LIKE rvu_file.*
DEFINE p_rvv     DYNAMIC ARRAY OF RECORD LIKE rvv_file.*
DEFINE l_cnt     LIKE type_file.num10
DEFINE l_sql     STRING

   IF g_success = 'N' THEN RETURN END IF

   WHENEVER ERROR CONTINUE

   IF cl_null(p_rvu.rvu01) THEN RETURN END IF
   IF p_rvv.getLength() <= 0 THEN RETURN END IF

   LET l_sql = "INSERT INTO ",cl_get_target_table(p_rvu.rvuplant,'rvu_file'),"( ",
               "            rvu00, ",       #異動類別
               "            rvu01, ",       #入庫單號/退貨單號
               "            rvu02, ",       #收貨單號
               "            rvu03, ",       #異動日期
               "            rvu04, ",       #廠商編號
               "            rvu05, ",       #廠商簡稱
               "            rvu06, ",       #部門
               "            rvu07, ",       #人員
               "            rvu08, ",       #採購性質
               "            rvu09, ",       #取回日期
               "            rvu10, ",       #開立折讓單否
               "            rvu11, ",       #折讓單日期
               "            rvu12, ",       #稅率
               "            rvu13, ",       #折讓單未稅金額
               "            rvu14, ",       #折讓單稅額
               "            rvu15, ",       #折讓原發票號
               "            rvu16, ",       #領料單號
               "            rvu17, ",       #簽核狀況
               "            rvu20, ",       #多角貿易拋轉否
               "            rvu21, ",       #經營方式
               "            rvu22, ",       #採購營運中心
               "            rvu23, ",       #配送中心
               "            rvu24, ",       #多角貿易流程代碼
               "            rvu25, ",       #來源單號
               "            rvu26, ",       #申請單號
               "            rvu27, ",       #虛擬類型
               "            rvu99, ",       #多角貿易流程序號
               "            rvu100, ",      #保稅異動原因代碼
               "            rvu101, ",      #保稅進口報單
               "            rvu102, ",      #保稅進口報單日期
               "            rvu111, ",      #付款方式
               "            rvu112, ",      #價格條件
               "            rvu113, ",      #幣別
               "            rvu114, ",      #匯率
               "            rvu115, ",      #稅別
               "            rvu116, ",      #退貨方式
               "            rvu117, ",      #VMI發/退料單號
               "            rvu900, ",      #狀況碼
               "            rvuconf, ",     #確認碼
               "            rvuacti, ",     #資料有效碼
               "            rvuuser, ",     #資料所有者
               "            rvugrup, ",     #資料所有部門
               "            rvumodu, ",     #資料修改者
               "            rvudate, ",     #最近修改日
               "            rvuud01, ",     #自訂欄位-Textedit
               "            rvuud02, ",     #自訂欄位-文字
               "            rvuud03, ",     #自訂欄位-文字
               "            rvuud04, ",     #自訂欄位-文字
               "            rvuud05, ",     #自訂欄位-文字
               "            rvuud06, ",     #自訂欄位-文字
               "            rvuud07, ",     #自訂欄位-數值
               "            rvuud08, ",     #自訂欄位-數值
               "            rvuud09, ",     #自訂欄位-數值
               "            rvuud10, ",     #自訂欄位-整數
               "            rvuud11, ",     #自訂欄位-整數
               "            rvuud12, ",     #自訂欄位-整數
               "            rvuud13, ",     #自訂欄位-日期
               "            rvuud14, ",     #自訂欄位-日期
               "            rvuud15, ",     #自訂欄位-日期
               "            rvuplant, ",    #所屬營運中心
               "            rvulegal, ",    #所屬法人
               "            rvucond, ",     #審核日期
               "            rvucont, ",     #審核時間
               "            rvuconu, ",     #審核人員
               "            rvucrat, ",     #資料創建日
               "            rvudays, ",     #簽核完成天數
               "            rvumksg, ",     #是否簽核
               "            rvuprit, ",     #簽核優先等級
               "            rvusign, ",     #簽核等級
               "            rvusmax, ",     #應簽核順序
               "            rvusseq, ",     #已簽核順序
               "            rvupos, ",      #已傳POS否
               "            rvuoriu, ",     #資料建立者
               "            rvuorig) ",     #資料建立部門
               "     VALUES(?,?,?,?,?,  ?,?,?,?,?, ",   #1 ~10
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #11~20
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #21~30
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #31~40
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #41~50
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #51~60
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #61~70
               "            ?,?,?,?) "                  #71~74
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,p_rvu.rvuplant) RETURNING l_sql
   PREPARE s_insrvu_rvu_pre FROM l_sql

   LET l_sql = "INSERT INTO ",cl_get_target_table(p_rvu.rvuplant,'rvv_file'),"( ",
               "            rvv01, ",       #入庫單號/退貨單號
               "            rvv02, ",       #項次
               "            rvv03, ",       #異動類別
               "            rvv04, ",       #收貨單號
               "            rvv05, ",       #項次
               "            rvv06, ",       #送貨廠商編號
               "            rvv09, ",       #異動日期
               "            rvv10, ",       #取價類型1-搭贈,2-促銷協議,3-
               "            rvv11, ",       #價格來源
               "            rvv12, ",       #來源單號
               "            rvv13, ",       #來源項次
               "            rvv17, ",       #數量
               "            rvv18, ",       #工單編號
               "            rvv22, ",       #發票編號
               "            rvv23, ",       #已請款匹配量
               "            rvv24, ",       #保稅過帳否
               "            rvv25, ",       #樣品否(N.非樣品Y.樣品不付款P.樣品需付款)
               "            rvv26, ",       #退貨理由
               "            rvv31, ",       #料件編號
               "            rvv031, ",      #品名
               "            rvv32, ",       #倉庫
               "            rvv33, ",       #存放位置
               "            rvv34, ",       #批號/專案代號
               "            rvv35, ",       #單位
               "            rvv35_fac, ",   #轉換率
               "            rvv36, ",       #採購單號
               "            rvv37, ",       #採購序號
               "            rvv38, ",       #單價
               "            rvv38t, ",      #含稅單價
               "            rvv39, ",       #金額
               "            rvv39t, ",      #含稅金額
               "            rvv40, ",       #沖暫估否
               "            rvv41, ",       #手冊編號
               "            rvv42, ",       #NoUse
               "            rvv43, ",       #NoUse
               "            rvv45, ",       #檢驗批號
               "            rvv46, ",       #QC判定結果編碼
               "            rvv47, ",       #QC判定結果項次
               "            rvv80, ",       #單位一
               "            rvv81, ",       #單位一換算率(與採購單位)
               "            rvv82, ",       #單位一數量
               "            rvv83, ",       #單位二
               "            rvv84, ",       #單位二換算率(與採購單位)
               "            rvv85, ",       #單位二數量
               "            rvv86, ",       #計價單位
               "            rvv87, ",       #計價數量
               "            rvv88, ",       #暫估數量
               "            rvv89, ",       #VMI退貨否
               "            rvv919, ",      #計畫批號
               "            rvv930, ",      #成本中心
               "            rvvud01, ",     #自訂欄位-Textedit
               "            rvvud02, ",     #自訂欄位-文字
               "            rvvud03, ",     #自訂欄位-文字
               "            rvvud04, ",     #自訂欄位-文字
               "            rvvud05, ",     #自訂欄位-文字
               "            rvvud06, ",     #自訂欄位-文字
               "            rvvud07, ",     #自訂欄位-數值
               "            rvvud08, ",     #自訂欄位-數值
               "            rvvud09, ",     #自訂欄位-數值
               "            rvvud10, ",     #自訂欄位-整數
               "            rvvud11, ",     #自訂欄位-整數
               "            rvvud12, ",     #自訂欄位-整數
               "            rvvud13, ",     #自訂欄位-日期
               "            rvvud14, ",     #自訂欄位-日期
               "            rvvud15, ",     #自訂欄位-日期
               "            rvvplant, ",    #所屬營運中心
               "            rvvlegal) ",    #所屬法人
               "     VALUES(?,?,?,?,?,  ?,?,?,?,?, ",   #1 ~10
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #11~20
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #21~30
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #31~40
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #41~50
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #51~60
               "            ?,?,?,?,?,  ?,?) "          #61~67
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,p_rvu.rvuplant) RETURNING l_sql
   PREPARE s_insrvu_rvv_pre FROM l_sql
   
   EXECUTE s_insrvu_rvu_pre USING p_rvu.rvu00,       #異動類別
                                  p_rvu.rvu01,       #入庫單號/退貨單號
                                  p_rvu.rvu02,       #收貨單號
                                  p_rvu.rvu03,       #異動日期
                                  p_rvu.rvu04,       #廠商編號
                                  p_rvu.rvu05,       #廠商簡稱
                                  p_rvu.rvu06,       #部門
                                  p_rvu.rvu07,       #人員
                                  p_rvu.rvu08,       #採購性質
                                  p_rvu.rvu09,       #取回日期
                                  p_rvu.rvu10,       #開立折讓單否
                                  p_rvu.rvu11,       #折讓單日期
                                  p_rvu.rvu12,       #稅率
                                  p_rvu.rvu13,       #折讓單未稅金額
                                  p_rvu.rvu14,       #折讓單稅額
                                  p_rvu.rvu15,       #折讓原發票號
                                  p_rvu.rvu16,       #領料單號
                                  p_rvu.rvu17,       #簽核狀況
                                  p_rvu.rvu20,       #多角貿易拋轉否
                                  p_rvu.rvu21,       #經營方式
                                  p_rvu.rvu22,       #採購營運中心
                                  p_rvu.rvu23,       #配送中心
                                  p_rvu.rvu24,       #多角貿易流程代碼
                                  p_rvu.rvu25,       #來源單號
                                  p_rvu.rvu26,       #申請單號
                                  p_rvu.rvu27,       #虛擬類型
                                  p_rvu.rvu99,       #多角貿易流程序號
                                  p_rvu.rvu100,      #保稅異動原因代碼
                                  p_rvu.rvu101,      #保稅進口報單
                                  p_rvu.rvu102,      #保稅進口報單日期
                                  p_rvu.rvu111,      #付款方式
                                  p_rvu.rvu112,      #價格條件
                                  p_rvu.rvu113,      #幣別
                                  p_rvu.rvu114,      #匯率
                                  p_rvu.rvu115,      #稅別
                                  p_rvu.rvu116,      #退貨方式
                                  p_rvu.rvu117,      #VMI發/退料單號
                                  p_rvu.rvu900,      #狀況碼
                                  p_rvu.rvuconf,     #確認碼
                                  p_rvu.rvuacti,     #資料有效碼
                                  p_rvu.rvuuser,     #資料所有者
                                  p_rvu.rvugrup,     #資料所有部門
                                  p_rvu.rvumodu,     #資料修改者
                                  p_rvu.rvudate,     #最近修改日
                                  p_rvu.rvuud01,     #自訂欄位-Textedit
                                  p_rvu.rvuud02,     #自訂欄位-文字
                                  p_rvu.rvuud03,     #自訂欄位-文字
                                  p_rvu.rvuud04,     #自訂欄位-文字
                                  p_rvu.rvuud05,     #自訂欄位-文字
                                  p_rvu.rvuud06,     #自訂欄位-文字
                                  p_rvu.rvuud07,     #自訂欄位-數值
                                  p_rvu.rvuud08,     #自訂欄位-數值
                                  p_rvu.rvuud09,     #自訂欄位-數值
                                  p_rvu.rvuud10,     #自訂欄位-整數
                                  p_rvu.rvuud11,     #自訂欄位-整數
                                  p_rvu.rvuud12,     #自訂欄位-整數
                                  p_rvu.rvuud13,     #自訂欄位-日期
                                  p_rvu.rvuud14,     #自訂欄位-日期
                                  p_rvu.rvuud15,     #自訂欄位-日期
                                  p_rvu.rvuplant,    #所屬營運中心
                                  p_rvu.rvulegal,    #所屬法人
                                  p_rvu.rvucond,     #審核日期
                                  p_rvu.rvucont,     #審核時間
                                  p_rvu.rvuconu,     #審核人員
                                  p_rvu.rvucrat,     #資料創建日
                                  p_rvu.rvudays,     #簽核完成天數
                                  p_rvu.rvumksg,     #是否簽核
                                  p_rvu.rvuprit,     #簽核優先等級
                                  p_rvu.rvusign,     #簽核等級
                                  p_rvu.rvusmax,     #應簽核順序
                                  p_rvu.rvusseq,     #已簽核順序
                                  p_rvu.rvupos,      #已傳POS否
                                  p_rvu.rvuoriu,     #資料建立者
                                  p_rvu.rvuorig      #資料建立部門
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      LET g_success = 'N'
      LET g_errno = SQLCA.sqlcode
      RETURN
   END IF
   
   FOR l_cnt = 1 TO p_rvv.getLength()
      EXECUTE s_insrvu_rvv_pre USING p_rvv[l_cnt].rvv01,       #入庫單號/退貨單號
                                     p_rvv[l_cnt].rvv02,       #項次
                                     p_rvv[l_cnt].rvv03,       #異動類別
                                     p_rvv[l_cnt].rvv04,       #收貨單號
                                     p_rvv[l_cnt].rvv05,       #項次
                                     p_rvv[l_cnt].rvv06,       #送貨廠商編號
                                     p_rvv[l_cnt].rvv09,       #異動日期
                                     p_rvv[l_cnt].rvv10,       #取價類型1-搭贈,2-促銷協議,3-
                                     p_rvv[l_cnt].rvv11,       #價格來源
                                     p_rvv[l_cnt].rvv12,       #來源單號
                                     p_rvv[l_cnt].rvv13,       #來源項次
                                     p_rvv[l_cnt].rvv17,       #數量
                                     p_rvv[l_cnt].rvv18,       #工單編號
                                     p_rvv[l_cnt].rvv22,       #發票編號
                                     p_rvv[l_cnt].rvv23,       #已請款匹配量
                                     p_rvv[l_cnt].rvv24,       #保稅過帳否
                                     p_rvv[l_cnt].rvv25,       #樣品否(N.非樣品Y.樣品不付款P.樣品需付款)
                                     p_rvv[l_cnt].rvv26,       #退貨理由
                                     p_rvv[l_cnt].rvv31,       #料件編號
                                     p_rvv[l_cnt].rvv031,      #品名
                                     p_rvv[l_cnt].rvv32,       #倉庫
                                     p_rvv[l_cnt].rvv33,       #存放位置
                                     p_rvv[l_cnt].rvv34,       #批號/專案代號
                                     p_rvv[l_cnt].rvv35,       #單位
                                     p_rvv[l_cnt].rvv35_fac,   #轉換率
                                     p_rvv[l_cnt].rvv36,       #採購單號
                                     p_rvv[l_cnt].rvv37,       #採購序號
                                     p_rvv[l_cnt].rvv38,       #單價
                                     p_rvv[l_cnt].rvv38t,      #含稅單價
                                     p_rvv[l_cnt].rvv39,       #金額
                                     p_rvv[l_cnt].rvv39t,      #含稅金額
                                     p_rvv[l_cnt].rvv40,       #沖暫估否
                                     p_rvv[l_cnt].rvv41,       #手冊編號
                                     p_rvv[l_cnt].rvv42,       #NoUse
                                     p_rvv[l_cnt].rvv43,       #NoUse
                                     p_rvv[l_cnt].rvv45,       #檢驗批號
                                     p_rvv[l_cnt].rvv46,       #QC判定結果編碼
                                     p_rvv[l_cnt].rvv47,       #QC判定結果項次
                                     p_rvv[l_cnt].rvv80,       #單位一
                                     p_rvv[l_cnt].rvv81,       #單位一換算率(與採購單位)
                                     p_rvv[l_cnt].rvv82,       #單位一數量
                                     p_rvv[l_cnt].rvv83,       #單位二
                                     p_rvv[l_cnt].rvv84,       #單位二換算率(與採購單位)
                                     p_rvv[l_cnt].rvv85,       #單位二數量
                                     p_rvv[l_cnt].rvv86,       #計價單位
                                     p_rvv[l_cnt].rvv87,       #計價數量
                                     p_rvv[l_cnt].rvv88,       #暫估數量
                                     p_rvv[l_cnt].rvv89,       #VMI退貨否
                                     p_rvv[l_cnt].rvv919,      #計畫批號
                                     p_rvv[l_cnt].rvv930,      #成本中心
                                     p_rvv[l_cnt].rvvud01,     #自訂欄位-Textedit
                                     p_rvv[l_cnt].rvvud02,     #自訂欄位-文字
                                     p_rvv[l_cnt].rvvud03,     #自訂欄位-文字
                                     p_rvv[l_cnt].rvvud04,     #自訂欄位-文字
                                     p_rvv[l_cnt].rvvud05,     #自訂欄位-文字
                                     p_rvv[l_cnt].rvvud06,     #自訂欄位-文字
                                     p_rvv[l_cnt].rvvud07,     #自訂欄位-數值
                                     p_rvv[l_cnt].rvvud08,     #自訂欄位-數值
                                     p_rvv[l_cnt].rvvud09,     #自訂欄位-數值
                                     p_rvv[l_cnt].rvvud10,     #自訂欄位-整數
                                     p_rvv[l_cnt].rvvud11,     #自訂欄位-整數
                                     p_rvv[l_cnt].rvvud12,     #自訂欄位-整數
                                     p_rvv[l_cnt].rvvud13,     #自訂欄位-日期
                                     p_rvv[l_cnt].rvvud14,     #自訂欄位-日期
                                     p_rvv[l_cnt].rvvud15,     #自訂欄位-日期
                                     p_rvv[l_cnt].rvvplant,    #所屬營運中心
                                     p_rvv[l_cnt].rvvlegal     #所屬法人
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         LET g_success = 'N'
         LET g_errno = SQLCA.sqlcode
         RETURN
      END IF
   END FOR

END FUNCTION

# Function name..: s_insoga(p_oga,p_ogb)
# Descriptions...: 将出货单数据新增到数据库中
# Input Parameter: p_oga 出货单单头Record
#                  p_ogb 出货单单身数组Record
# Usage..........: CALL s_insoga(l_oga,l_ogb)

FUNCTION s_insoga(p_oga,p_ogb)
DEFINE p_oga     RECORD LIKE oga_file.*
DEFINE p_ogb     DYNAMIC ARRAY OF RECORD LIKE ogb_file.*
DEFINE l_cnt     LIKE type_file.num10
DEFINE l_sql     STRING

   IF g_success = 'N' THEN RETURN END IF

   WHENEVER ERROR CONTINUE

   IF cl_null(p_oga.oga01) THEN RETURN END IF
   IF p_ogb.getLength() <= 0 THEN RETURN END IF

   LET l_sql = "INSERT INTO ",cl_get_target_table(p_oga.ogaplant,'oga_file'),"( ",
               "            oga00, ",       #出貨別
               "            oga01, ",       #出貨單號/出通單號
               "            oga011, ",      #出貨通知單號
               "            oga02, ",       #出貨日期
               "            oga021, ",      #結關日期
               "            oga022, ",      #裝船日期
               "            oga03, ",       #帳款客戶編號
               "            oga032, ",      #帳款客戶簡稱
               "            oga033, ",      #帳款客戶統一編號
               "            oga04, ",       #送貨客戶編號
               "            oga044, ",      #送貨地址碼
               "            oga05, ",       #發票別
               "            oga06, ",       #修改版本
               "            oga07, ",       #出貨是否計入未開發票的銷貨
               "            oga08, ",       #1.內銷2.外銷3.視同外銷
               "            oga09, ",       #單據別
               "            oga10, ",       #帳單編號
               "            oga11, ",       #應收款日
               "            oga12, ",       #容許票據到期日
               "            oga13, ",       #科目分類碼
               "            oga14, ",       #人員編號
               "            oga15, ",       #部門編號
               "            oga16, ",       #訂單單號
               "            oga161, ",      #訂金應收比率
               "            oga162, ",      #出貨應收比率
               "            oga163, ",      #尾款應收比率
               "            oga17, ",       #排貨模擬順序
               "            oga18, ",       #收款客戶編號
               "            oga19, ",       #待抵帳款-預收單號
               "            oga20, ",       #分錄底稿是否可重新產生
               "            oga21, ",       #稅別
               "            oga211, ",      #稅率
               "            oga212, ",      #聯數
               "            oga213, ",      #含稅否
               "            oga23, ",       #幣別
               "            oga24, ",       #匯率
               "            oga25, ",       #銷售分類一
               "            oga26, ",       #銷售分類二
               "            oga27, ",       #InvoiceNo.
               "            oga28, ",       #立帳時採用訂單匯率
               "            oga29, ",       #信用額度餘額
               "            oga30, ",       #包裝單確認碼
               "            oga31, ",       #價格條件編號
               "            oga32, ",       #收款條件編號
               "            oga33, ",       #其它條件
               "            oga34, ",       #佣金率
               "            oga35, ",       #外銷方式
               "            oga36, ",       #非經海關証明文件名稱
               "            oga37, ",       #非經海關証明文件號碼
               "            oga38, ",       #出口報單類別
               "            oga39, ",       #出口報單號碼
               "            oga40, ",       #NOTIFY
               "            oga41, ",       #起運地
               "            oga42, ",       #到達地
               "            oga43, ",       #交運方式
               "            oga44, ",       #嘜頭編號
               "            oga45, ",       #聯絡人
               "            oga46, ",       #專案編號
               "            oga47, ",       #船名/車號
               "            oga48, ",       #航次
               "            oga49, ",       #SailingDate
               "            oga50, ",       #原幣出貨金額
               "            oga501, ",      #本幣出貨金額
               "            oga51, ",       #原幣出貨金額
               "            oga511, ",      #本幣出貨金額
               "            oga52, ",       #原幣預收訂金轉銷貨收入金額
               "            oga53, ",       #原幣應開發票未稅金額
               "            oga54, ",       #原幣已開發票未稅金額
               "            oga55, ",       #狀況碼
               "            oga56, ",       #簽收單號
               "            oga57, ",       #發票性質
               "            oga65, ",       #客戶出貨簽收否
               "            oga66, ",       #出貨簽收在途/驗退倉庫
               "            oga67, ",       #出貨簽收在途/驗退儲位
               "            oga68, ",       #NoUse
               "            oga69, ",       #輸入日期
               "            oga70, ",       #調撥單號
               "            oga71, ",       #申報統編
               "            oga72, ",       #預計簽收日
               "            oga83, ",       #銷貨營運中心
               "            oga84, ",       #取貨營運中心
               "            oga85, ",       #結算方式
               "            oga86, ",       #客層代碼
               "            oga87, ",       #會員卡號
               "            oga88, ",       #顧客姓名
               "            oga89, ",       #聯系電話
               "            oga90, ",       #證件類型
               "            oga91, ",       #證件號碼
               "            oga92, ",       #贈品發放單號
               "            oga93, ",       #返券發放單號
               "            oga94, ",       #POS銷售否Y-是,N-否
               "            oga95, ",       #本次積分
               "            oga96, ",       #收銀機號
               "            oga97, ",       #交易序號
               "            oga98, ",       #POS單號
               "            oga99, ",       #多角貿易流程序號
               "            oga901, ",      #posttoabxsystemflag
               "            oga902, ",      #信用超限留置代碼
               "            oga903, ",      #信用查核放行否
               "            oga904, ",      #NoUse
               "            oga905, ",      #已轉三角貿易出貨單否
               "            oga906, ",      #起始出貨單否
               "            oga907, ",      #傳票號碼
               "            oga908, ",      #L/CNO
               "            oga909, ",      #三角貿易否
               "            oga910, ",      #境外倉庫
               "            oga911, ",      #境外儲位
               "            oga912, ",      #保稅異動原因代碼
               "            oga913, ",      #保稅報單日期
               "            oga914, ",      #入庫單號
               "            ogaconf, ",     #確認否/作廢碼
               "            ogapost, ",     #出貨扣帳否
               "            ogaprsw, ",     #列印次數
               "            ogauser, ",     #資料所有者
               "            ogagrup, ",     #資料所有部門
               "            ogamodu, ",     #資料修改者
               "            ogadate, ",     #最近修改日
               "            ogamksg, ",     #簽核
               "            oga1001, ",     #收款客戶代號
               "            oga1002, ",     #債權代碼
               "            oga1003, ",     #業績歸屬組織
               "            oga1004, ",     #調貨客戶
               "            oga1005, ",     #是否計算業績
               "            oga1006, ",     #折扣金額(未稅)
               "            oga1007, ",     #折扣金額(含稅)
               "            oga1008, ",     #出貨總含稅金額
               "            oga1009, ",     #客戶所屬通路
               "            oga1010, ",     #客戶所屬組織
               "            oga1011, ",     #開票客戶
               "            oga1012, ",     #銷退單單號
               "            oga1013, ",     #已列印提單否
               "            oga1014, ",     #調貨銷退單所自動產生否
               "            oga1015, ",     #導物流狀況碼
               "            oga1016, ",     #代送商
               "            ogaspc, ",      #SPC拋轉碼0/1/2
               "            ogaud01, ",     #自訂欄位-Textedit
               "            ogaud02, ",     #自訂欄位-文字
               "            ogaud03, ",     #自訂欄位-文字
               "            ogaud04, ",     #自訂欄位-文字
               "            ogaud05, ",     #自訂欄位-文字
               "            ogaud06, ",     #自訂欄位-文字
               "            ogaud07, ",     #自訂欄位-數值
               "            ogaud08, ",     #自訂欄位-數值
               "            ogaud09, ",     #自訂欄位-數值
               "            ogaud10, ",     #自訂欄位-整數
               "            ogaud11, ",     #自訂欄位-整數
               "            ogaud12, ",     #自訂欄位-整數
               "            ogaud13, ",     #自訂欄位-日期
               "            ogaud14, ",     #自訂欄位-日期
               "            ogaud15, ",     #自訂欄位-日期
               "            ogaplant, ",    #所屬營運中心
               "            ogalegal, ",    #所屬法人
               "            ogacond, ",     #審核日期
               "            ogaconu, ",     #審核人員
               "            ogaoriu, ",     #資料建立者
               "            ogaorig, ",     #資料建立部門
               "            ogacont, ",     #審核時間
               "            ogaslk01, ",    #裝箱單單號
               "            ogaslk02) ",    #出貨類型(現貨，期貨)
               "     VALUES(?,?,?,?,?,  ?,?,?,?,?, ",   #1  ~10
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #11 ~20
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #21 ~30
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #31 ~40
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #41 ~50
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #51 ~60
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #61 ~70
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #71 ~80
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #81 ~90
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #91 ~100
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #101~110
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #111~120
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #121~130
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #131~140
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #141~150
               "            ?,?,?,?,?,  ?,?,?,?) "      #151~159
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,p_oga.ogaplant) RETURNING l_sql
   PREPARE s_insoga_oga_pre FROM l_sql
   
   LET l_sql = "INSERT INTO ",cl_get_target_table(p_oga.ogaplant,'ogb_file'),"( ",
               "            ogb01, ",       #出貨單號
               "            ogb03, ",       #項次
               "            ogb04, ",       #產品編號
               "            ogb05, ",       #銷售單位
               "            ogb05_fac, ",   #銷售/庫存彙總單位換算率
               "            ogb06, ",       #品名規格
               "            ogb07, ",       #額外品名編號
               "            ogb08, ",       #出貨營運中心編號
               "            ogb09, ",       #出貨倉庫編號
               "            ogb091, ",      #出貨儲位編號
               "            ogb092, ",      #出貨批號
               "            ogb11, ",       #客戶產品編號
               "            ogb12, ",       #實際出貨數量
               "            ogb13, ",       #原幣單價
               "            ogb14, ",       #原幣未稅金額
               "            ogb14t, ",      #原幣含稅金額
               "            ogb15, ",       #庫存明細單位由廠/倉/儲/批自
               "            ogb15_fac, ",   #銷售/庫存明細單位換算率
               "            ogb16, ",       #數量
               "            ogb17, ",       #多倉儲批出貨否
               "            ogb18, ",       #預計出貨數量
               "            ogb19, ",       #檢驗否
               "            ogb20, ",       #NoUse
               "            ogb21, ",       #NoUse
               "            ogb22, ",       #NoUse
               "            ogb31, ",       #訂單單號
               "            ogb32, ",       #訂單項次
               "            ogb37, ",       #基礎單价
               "            ogb40, ",       #抽成代號
               "            ogb41, ",       #專案代號
               "            ogb42, ",       #WBS編號
               "            ogb43, ",       #活動代號
               "            ogb44, ",       #經營方式
               "            ogb45, ",       #原扣率
               "            ogb46, ",       #新扣率
               "            ogb47, ",       #分攤折價=全部折價欄位值的合
               "            ogb48, ",       #攤位編號
               "            ogb49, ",       #商戶編號
               "            ogb50, ",       #開票性質
               "            ogb51, ",       #已簽退數量
               "            ogb52, ",       #簽退數量
               "            ogb53, ",       #單位一驗退數量
               "            ogb54, ",       #單位二驗退數量
               "            ogb55, ",       #驗退計價數量
               "            ogb60, ",       #已開發票數量
               "            ogb63, ",       #銷退數量
               "            ogb64, ",       #銷退數量
               "            ogb65, ",       #驗退理由碼
               "            ogb71, ",       #發票號碼
               "            ogb901, ",      #NoUse
               "            ogb902, ",      #NoUse
               "            ogb903, ",      #NoUse
               "            ogb904, ",      #NoUse
               "            ogb905, ",      #NoUse
               "            ogb906, ",      #NoUse
               "            ogb907, ",      #NoUse
               "            ogb908, ",      #手冊編號
               "            ogb909, ",      #NoUse
               "            ogb910, ",      #單位一
               "            ogb911, ",      #單位一換算率(與銷售單位)
               "            ogb912, ",      #單位一數量
               "            ogb913, ",      #單位二
               "            ogb914, ",      #單位二換算率(與銷售單位)
               "            ogb915, ",      #單位二數量
               "            ogb916, ",      #計價單位
               "            ogb917, ",      #計價數量
               "            ogb930, ",      #成本中心
               "            ogb931, ",      #包裝編號
               "            ogb932, ",      #包裝數量
               "            ogb1001, ",     #原因碼
               "            ogb1002, ",     #訂價代號
               "            ogb1003, ",     #預計出貨日期
               "            ogb1004, ",     #提案代號
               "            ogb1005, ",     #作業方式
               "            ogb1006, ",     #折扣率
               "            ogb1007, ",     #現金折扣單號
               "            ogb1008, ",     #稅別
               "            ogb1009, ",     #稅率
               "            ogb1010, ",     #含稅否
               "            ogb1011, ",     #非直營KAB
               "            ogb1012, ",     #搭贈
               "            ogb1013, ",     #已開發票未稅金額
               "            ogb1014, ",     #保稅已放行否
               "            ogbud01, ",     #自訂欄位-Textedit
               "            ogbud02, ",     #自訂欄位-文字
               "            ogbud03, ",     #自訂欄位-文字
               "            ogbud04, ",     #自訂欄位-文字
               "            ogbud05, ",     #自訂欄位-文字
               "            ogbud06, ",     #自訂欄位-文字
               "            ogbud07, ",     #自訂欄位-數值
               "            ogbud08, ",     #自訂欄位-數值
               "            ogbud09, ",     #自訂欄位-數值
               "            ogbud10, ",     #自訂欄位-整數
               "            ogbud11, ",     #自訂欄位-整數
               "            ogbud12, ",     #自訂欄位-整數
               "            ogbud13, ",     #自訂欄位-日期
               "            ogbud14, ",     #自訂欄位-日期
               "            ogbud15, ",     #自訂欄位-日期
               "            ogbplant, ",    #所屬營運中心
               "            ogblegal) ",    #所屬法人
               "     VALUES(?,?,?,?,?,  ?,?,?,?,?, ",   #1 ~10
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #11~20
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #21~30
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #31~40
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #41~50
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #51~60
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #61~70
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #71~80
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #81~90
               "            ?,?,?,?,?,  ?,?,?,?,?) "    #91~100
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,p_oga.ogaplant) RETURNING l_sql
   PREPARE s_insoga_ogb_pre FROM l_sql
   
   EXECUTE s_insoga_oga_pre USING p_oga.oga00,       #出貨別
                                  p_oga.oga01,       #出貨單號/出通單號
                                  p_oga.oga011,      #出貨通知單號
                                  p_oga.oga02,       #出貨日期
                                  p_oga.oga021,      #結關日期
                                  p_oga.oga022,      #裝船日期
                                  p_oga.oga03,       #帳款客戶編號
                                  p_oga.oga032,      #帳款客戶簡稱
                                  p_oga.oga033,      #帳款客戶統一編號
                                  p_oga.oga04,       #送貨客戶編號
                                  p_oga.oga044,      #送貨地址碼
                                  p_oga.oga05,       #發票別
                                  p_oga.oga06,       #修改版本
                                  p_oga.oga07,       #出貨是否計入未開發票的銷貨
                                  p_oga.oga08,       #1.內銷2.外銷3.視同外銷
                                  p_oga.oga09,       #單據別
                                  p_oga.oga10,       #帳單編號
                                  p_oga.oga11,       #應收款日
                                  p_oga.oga12,       #容許票據到期日
                                  p_oga.oga13,       #科目分類碼
                                  p_oga.oga14,       #人員編號
                                  p_oga.oga15,       #部門編號
                                  p_oga.oga16,       #訂單單號
                                  p_oga.oga161,      #訂金應收比率
                                  p_oga.oga162,      #出貨應收比率
                                  p_oga.oga163,      #尾款應收比率
                                  p_oga.oga17,       #排貨模擬順序
                                  p_oga.oga18,       #收款客戶編號
                                  p_oga.oga19,       #待抵帳款-預收單號
                                  p_oga.oga20,       #分錄底稿是否可重新產生
                                  p_oga.oga21,       #稅別
                                  p_oga.oga211,      #稅率
                                  p_oga.oga212,      #聯數
                                  p_oga.oga213,      #含稅否
                                  p_oga.oga23,       #幣別
                                  p_oga.oga24,       #匯率
                                  p_oga.oga25,       #銷售分類一
                                  p_oga.oga26,       #銷售分類二
                                  p_oga.oga27,       #InvoiceNo.
                                  p_oga.oga28,       #立帳時採用訂單匯率
                                  p_oga.oga29,       #信用額度餘額
                                  p_oga.oga30,       #包裝單確認碼
                                  p_oga.oga31,       #價格條件編號
                                  p_oga.oga32,       #收款條件編號
                                  p_oga.oga33,       #其它條件
                                  p_oga.oga34,       #佣金率
                                  p_oga.oga35,       #外銷方式
                                  p_oga.oga36,       #非經海關証明文件名稱
                                  p_oga.oga37,       #非經海關証明文件號碼
                                  p_oga.oga38,       #出口報單類別
                                  p_oga.oga39,       #出口報單號碼
                                  p_oga.oga40,       #NOTIFY
                                  p_oga.oga41,       #起運地
                                  p_oga.oga42,       #到達地
                                  p_oga.oga43,       #交運方式
                                  p_oga.oga44,       #嘜頭編號
                                  p_oga.oga45,       #聯絡人
                                  p_oga.oga46,       #專案編號
                                  p_oga.oga47,       #船名/車號
                                  p_oga.oga48,       #航次
                                  p_oga.oga49,       #SailingDate
                                  p_oga.oga50,       #原幣出貨金額
                                  p_oga.oga501,      #本幣出貨金額
                                  p_oga.oga51,       #原幣出貨金額
                                  p_oga.oga511,      #本幣出貨金額
                                  p_oga.oga52,       #原幣預收訂金轉銷貨收入金額
                                  p_oga.oga53,       #原幣應開發票未稅金額
                                  p_oga.oga54,       #原幣已開發票未稅金額
                                  p_oga.oga55,       #狀況碼
                                  p_oga.oga56,       #簽收單號
                                  p_oga.oga57,       #發票性質
                                  p_oga.oga65,       #客戶出貨簽收否
                                  p_oga.oga66,       #出貨簽收在途/驗退倉庫
                                  p_oga.oga67,       #出貨簽收在途/驗退儲位
                                  p_oga.oga68,       #NoUse
                                  p_oga.oga69,       #輸入日期
                                  p_oga.oga70,       #調撥單號
                                  p_oga.oga71,       #申報統編
                                  p_oga.oga72,       #預計簽收日
                                  p_oga.oga83,       #銷貨營運中心
                                  p_oga.oga84,       #取貨營運中心
                                  p_oga.oga85,       #結算方式
                                  p_oga.oga86,       #客層代碼
                                  p_oga.oga87,       #會員卡號
                                  p_oga.oga88,       #顧客姓名
                                  p_oga.oga89,       #聯系電話
                                  p_oga.oga90,       #證件類型
                                  p_oga.oga91,       #證件號碼
                                  p_oga.oga92,       #贈品發放單號
                                  p_oga.oga93,       #返券發放單號
                                  p_oga.oga94,       #POS銷售否Y-是,N-否
                                  p_oga.oga95,       #本次積分
                                  p_oga.oga96,       #收銀機號
                                  p_oga.oga97,       #交易序號
                                  p_oga.oga98,       #POS單號
                                  p_oga.oga99,       #多角貿易流程序號
                                  p_oga.oga901,      #posttoabxsystemflag
                                  p_oga.oga902,      #信用超限留置代碼
                                  p_oga.oga903,      #信用查核放行否
                                  p_oga.oga904,      #NoUse
                                  p_oga.oga905,      #已轉三角貿易出貨單否
                                  p_oga.oga906,      #起始出貨單否
                                  p_oga.oga907,      #傳票號碼
                                  p_oga.oga908,      #L/CNO
                                  p_oga.oga909,      #三角貿易否
                                  p_oga.oga910,      #境外倉庫
                                  p_oga.oga911,      #境外儲位
                                  p_oga.oga912,      #保稅異動原因代碼
                                  p_oga.oga913,      #保稅報單日期
                                  p_oga.oga914,      #入庫單號
                                  p_oga.ogaconf,     #確認否/作廢碼
                                  p_oga.ogapost,     #出貨扣帳否
                                  p_oga.ogaprsw,     #列印次數
                                  p_oga.ogauser,     #資料所有者
                                  p_oga.ogagrup,     #資料所有部門
                                  p_oga.ogamodu,     #資料修改者
                                  p_oga.ogadate,     #最近修改日
                                  p_oga.ogamksg,     #簽核
                                  p_oga.oga1001,     #收款客戶代號
                                  p_oga.oga1002,     #債權代碼
                                  p_oga.oga1003,     #業績歸屬組織
                                  p_oga.oga1004,     #調貨客戶
                                  p_oga.oga1005,     #是否計算業績
                                  p_oga.oga1006,     #折扣金額(未稅)
                                  p_oga.oga1007,     #折扣金額(含稅)
                                  p_oga.oga1008,     #出貨總含稅金額
                                  p_oga.oga1009,     #客戶所屬通路
                                  p_oga.oga1010,     #客戶所屬組織
                                  p_oga.oga1011,     #開票客戶
                                  p_oga.oga1012,     #銷退單單號
                                  p_oga.oga1013,     #已列印提單否
                                  p_oga.oga1014,     #調貨銷退單所自動產生否
                                  p_oga.oga1015,     #導物流狀況碼
                                  p_oga.oga1016,     #代送商
                                  p_oga.ogaspc,      #SPC拋轉碼0/1/2
                                  p_oga.ogaud01,     #自訂欄位-Textedit
                                  p_oga.ogaud02,     #自訂欄位-文字
                                  p_oga.ogaud03,     #自訂欄位-文字
                                  p_oga.ogaud04,     #自訂欄位-文字
                                  p_oga.ogaud05,     #自訂欄位-文字
                                  p_oga.ogaud06,     #自訂欄位-文字
                                  p_oga.ogaud07,     #自訂欄位-數值
                                  p_oga.ogaud08,     #自訂欄位-數值
                                  p_oga.ogaud09,     #自訂欄位-數值
                                  p_oga.ogaud10,     #自訂欄位-整數
                                  p_oga.ogaud11,     #自訂欄位-整數
                                  p_oga.ogaud12,     #自訂欄位-整數
                                  p_oga.ogaud13,     #自訂欄位-日期
                                  p_oga.ogaud14,     #自訂欄位-日期
                                  p_oga.ogaud15,     #自訂欄位-日期
                                  p_oga.ogaplant,    #所屬營運中心
                                  p_oga.ogalegal,    #所屬法人
                                  p_oga.ogacond,     #審核日期
                                  p_oga.ogaconu,     #審核人員
                                  p_oga.ogaoriu,     #資料建立者
                                  p_oga.ogaorig,     #資料建立部門
                                  p_oga.ogacont,     #審核時間
                                  p_oga.ogaslk01,    #裝箱單單號
                                  p_oga.ogaslk02     #出貨類型(現貨，期貨)
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      LET g_success = 'N'
      LET g_errno = SQLCA.sqlcode
      RETURN
   END IF
   
   FOR l_cnt = 1 TO p_ogb.getLength()
      EXECUTE s_insoga_ogb_pre USING p_ogb[l_cnt].ogb01,       #出貨單號
                                     p_ogb[l_cnt].ogb03,       #項次
                                     p_ogb[l_cnt].ogb04,       #產品編號
                                     p_ogb[l_cnt].ogb05,       #銷售單位
                                     p_ogb[l_cnt].ogb05_fac,   #銷售/庫存彙總單位換算率
                                     p_ogb[l_cnt].ogb06,       #品名規格
                                     p_ogb[l_cnt].ogb07,       #額外品名編號
                                     p_ogb[l_cnt].ogb08,       #出貨營運中心編號
                                     p_ogb[l_cnt].ogb09,       #出貨倉庫編號
                                     p_ogb[l_cnt].ogb091,      #出貨儲位編號
                                     p_ogb[l_cnt].ogb092,      #出貨批號
                                     p_ogb[l_cnt].ogb11,       #客戶產品編號
                                     p_ogb[l_cnt].ogb12,       #實際出貨數量
                                     p_ogb[l_cnt].ogb13,       #原幣單價
                                     p_ogb[l_cnt].ogb14,       #原幣未稅金額
                                     p_ogb[l_cnt].ogb14t,      #原幣含稅金額
                                     p_ogb[l_cnt].ogb15,       #庫存明細單位由廠/倉/儲/批自
                                     p_ogb[l_cnt].ogb15_fac,   #銷售/庫存明細單位換算率
                                     p_ogb[l_cnt].ogb16,       #數量
                                     p_ogb[l_cnt].ogb17,       #多倉儲批出貨否
                                     p_ogb[l_cnt].ogb18,       #預計出貨數量
                                     p_ogb[l_cnt].ogb19,       #檢驗否
                                     p_ogb[l_cnt].ogb20,       #NoUse
                                     p_ogb[l_cnt].ogb21,       #NoUse
                                     p_ogb[l_cnt].ogb22,       #NoUse
                                     p_ogb[l_cnt].ogb31,       #訂單單號
                                     p_ogb[l_cnt].ogb32,       #訂單項次
                                     p_ogb[l_cnt].ogb37,       #基礎單价
                                     p_ogb[l_cnt].ogb40,       #抽成代號
                                     p_ogb[l_cnt].ogb41,       #專案代號
                                     p_ogb[l_cnt].ogb42,       #WBS編號
                                     p_ogb[l_cnt].ogb43,       #活動代號
                                     p_ogb[l_cnt].ogb44,       #經營方式
                                     p_ogb[l_cnt].ogb45,       #原扣率
                                     p_ogb[l_cnt].ogb46,       #新扣率
                                     p_ogb[l_cnt].ogb47,       #分攤折價=全部折價欄位值的合
                                     p_ogb[l_cnt].ogb48,       #攤位編號
                                     p_ogb[l_cnt].ogb49,       #商戶編號
                                     p_ogb[l_cnt].ogb50,       #開票性質
                                     p_ogb[l_cnt].ogb51,       #已簽退數量
                                     p_ogb[l_cnt].ogb52,       #簽退數量
                                     p_ogb[l_cnt].ogb53,       #單位一驗退數量
                                     p_ogb[l_cnt].ogb54,       #單位二驗退數量
                                     p_ogb[l_cnt].ogb55,       #驗退計價數量
                                     p_ogb[l_cnt].ogb60,       #已開發票數量
                                     p_ogb[l_cnt].ogb63,       #銷退數量
                                     p_ogb[l_cnt].ogb64,       #銷退數量
                                     p_ogb[l_cnt].ogb65,       #驗退理由碼
                                     p_ogb[l_cnt].ogb71,       #發票號碼
                                     p_ogb[l_cnt].ogb901,      #NoUse
                                     p_ogb[l_cnt].ogb902,      #NoUse
                                     p_ogb[l_cnt].ogb903,      #NoUse
                                     p_ogb[l_cnt].ogb904,      #NoUse
                                     p_ogb[l_cnt].ogb905,      #NoUse
                                     p_ogb[l_cnt].ogb906,      #NoUse
                                     p_ogb[l_cnt].ogb907,      #NoUse
                                     p_ogb[l_cnt].ogb908,      #手冊編號
                                     p_ogb[l_cnt].ogb909,      #NoUse
                                     p_ogb[l_cnt].ogb910,      #單位一
                                     p_ogb[l_cnt].ogb911,      #單位一換算率(與銷售單位)
                                     p_ogb[l_cnt].ogb912,      #單位一數量
                                     p_ogb[l_cnt].ogb913,      #單位二
                                     p_ogb[l_cnt].ogb914,      #單位二換算率(與銷售單位)
                                     p_ogb[l_cnt].ogb915,      #單位二數量
                                     p_ogb[l_cnt].ogb916,      #計價單位
                                     p_ogb[l_cnt].ogb917,      #計價數量
                                     p_ogb[l_cnt].ogb930,      #成本中心
                                     p_ogb[l_cnt].ogb931,      #包裝編號
                                     p_ogb[l_cnt].ogb932,      #包裝數量
                                     p_ogb[l_cnt].ogb1001,     #原因碼
                                     p_ogb[l_cnt].ogb1002,     #訂價代號
                                     p_ogb[l_cnt].ogb1003,     #預計出貨日期
                                     p_ogb[l_cnt].ogb1004,     #提案代號
                                     p_ogb[l_cnt].ogb1005,     #作業方式
                                     p_ogb[l_cnt].ogb1006,     #折扣率
                                     p_ogb[l_cnt].ogb1007,     #現金折扣單號
                                     p_ogb[l_cnt].ogb1008,     #稅別
                                     p_ogb[l_cnt].ogb1009,     #稅率
                                     p_ogb[l_cnt].ogb1010,     #含稅否
                                     p_ogb[l_cnt].ogb1011,     #非直營KAB
                                     p_ogb[l_cnt].ogb1012,     #搭贈
                                     p_ogb[l_cnt].ogb1013,     #已開發票未稅金額
                                     p_ogb[l_cnt].ogb1014,     #保稅已放行否
                                     p_ogb[l_cnt].ogbud01,     #自訂欄位-Textedit
                                     p_ogb[l_cnt].ogbud02,     #自訂欄位-文字
                                     p_ogb[l_cnt].ogbud03,     #自訂欄位-文字
                                     p_ogb[l_cnt].ogbud04,     #自訂欄位-文字
                                     p_ogb[l_cnt].ogbud05,     #自訂欄位-文字
                                     p_ogb[l_cnt].ogbud06,     #自訂欄位-文字
                                     p_ogb[l_cnt].ogbud07,     #自訂欄位-數值
                                     p_ogb[l_cnt].ogbud08,     #自訂欄位-數值
                                     p_ogb[l_cnt].ogbud09,     #自訂欄位-數值
                                     p_ogb[l_cnt].ogbud10,     #自訂欄位-整數
                                     p_ogb[l_cnt].ogbud11,     #自訂欄位-整數
                                     p_ogb[l_cnt].ogbud12,     #自訂欄位-整數
                                     p_ogb[l_cnt].ogbud13,     #自訂欄位-日期
                                     p_ogb[l_cnt].ogbud14,     #自訂欄位-日期
                                     p_ogb[l_cnt].ogbud15,     #自訂欄位-日期
                                     p_ogb[l_cnt].ogbplant,    #所屬營運中心
                                     p_ogb[l_cnt].ogblegal     #所屬法人
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         LET g_success = 'N'
         LET g_errno = SQLCA.sqlcode
         RETURN
      END IF                
   END FOR

END FUNCTION 

# Function name..: s_oga_post
# Descriptions...: 出货单过账逻辑
# Input Parameter: p_azw01 所属营运中心
#                  p_oga01 单据编号
# Usage..........: CALL s_oga_post(p_azw01,p_oga01)

FUNCTION s_oga_post(p_azw01,p_oga01)
DEFINE p_azw01   LIKE azw_file.azw01
DEFINE p_oga01   LIKE oga_file.oga01
DEFINE l_oga     RECORD LIKE oga_file.*
DEFINE l_ogb     RECORD LIKE ogb_file.*
DEFINE l_sql     STRING
DEFINE l_count   LIKE type_file.num10
DEFINE l_img     RECORD LIKE img_file.*

   IF g_success = 'N' THEN RETURN END IF

   WHENEVER ERROR CONTINUE

   IF cl_null(p_azw01) OR cl_null(p_oga01) THEN RETURN END IF

  #CALL s_oga_post_chk(p_azw01,p_oga01)
  #IF g_success = 'N' THEN RETURN END IF
   
   INITIALIZE l_oga.* TO NULL
   INITIALIZE l_ogb.* TO NULL
   
   #取出货单单头
   LET l_sql = "SELECT * FROM ",cl_get_target_table(p_azw01,'oga_file')," WHERE oga01 = '",p_oga01 CLIPPED,"' "
   PREPARE s_oga_post_sel_oga_pre FROM l_sql
   EXECUTE s_oga_post_sel_oga_pre INTO l_oga.*

   IF l_oga.oga02 <= g_sma.sma53 THEN
      LET g_success = 'N'
      LET g_errno = 'mfg9999'
      CALL s_errmsg('oga02',l_oga.oga02,' oga_post(chk oga02):','mfg9999',1)
      ROLLBACK WORK
      RETURN
   END IF
   
   #取出货单单身
   LET l_sql = "SELECT * FROM ",cl_get_target_table(p_azw01,'ogb_file')," WHERE ogb01 = '",p_oga01 CLIPPED,"' "
   PREPARE s_oga_post_sel_ogb_pre FROM l_sql
   DECLARE s_oga_post_sel_ogb_cs CURSOR FOR s_oga_post_sel_ogb_pre
   
   #取img笔数
   LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(p_azw01,'img_file'),
               " WHERE img01 = ? AND img02 = ? ",
               "   AND img03 = ? AND img04 = ? "
   PREPARE s_oga_post_sel_count_img_pre FROM l_sql
   
   #锁库存明细img
   LET l_sql = "SELECT * FROM ",cl_get_target_table(p_azw01,'img_file'),
               " WHERE img01 = ? AND img02 = ? ",
               "   AND img03 = ? AND img04 = ? FOR UPDATE "
   CALL cl_forupd_sql(l_sql) RETURNING l_sql
   LET l_sql = cl_forupd_sql(l_sql)
   DECLARE s_oga_post_sel_img_lock CURSOR FROM l_sql
   
   #更新库存
   LET l_sql = "UPDATE ",cl_get_target_table(p_azw01,'img_file'),
               "   SET img10 = img10 - ?, ",
               "       img16 = '",l_oga.oga02,"', ",
               "       img17 = '",l_oga.oga02,"' ",
               " WHERE img01 = ? AND img02 = ? AND img03 = ? AND img04 = ? "
   PREPARE s_oga_post_upd_img_pre FROM l_sql
   
   FOREACH s_oga_post_sel_ogb_cs INTO l_ogb.*
      IF l_ogb.ogb64 = '4' OR l_ogb.ogb04[1,4] = 'MISC' THEN 
         CONTINUE FOREACH 
      END IF
      
      LET l_count = 0
      EXECUTE s_oga_post_sel_count_img_pre INTO l_count USING l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092
      IF l_count = 0 THEN
         LET g_sma.sma892[2,2] = 'N'
         LET g_sma.sma39 = 'Y'
         CALL s_madd_img(l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,l_oga.oga01,l_ogb.ogb03,l_oga.oga02,p_azw01)
         IF g_success='N' THEN
            RETURN
         END IF
      END IF
      
      OPEN s_oga_post_sel_img_lock USING l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         LET g_errno = SQLCA.sqlcode
         CALL s_errmsg('','',' OPEN s_oga_post_sel_img_lock:',SQLCA.sqlcode,1)
         CLOSE s_oga_post_sel_img_lock
         RETURN
      END IF
      
      FETCH s_oga_post_sel_img_lock INTO l_img.*
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         LET g_errno = SQLCA.sqlcode
         CALL s_errmsg('','',' FETCH s_oga_post_sel_img_lock:',SQLCA.sqlcode,1)
         CLOSE s_oga_post_sel_img_lock
         RETURN
      END IF
      
      EXECUTE s_oga_post_upd_img_pre USING l_ogb.ogb16,l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         LET g_errno = SQLCA.sqlcode
         CALL s_errmsg('','',' UPD img_file',SQLCA.sqlcode,1)
         RETURN
      END IF
  
                     #门店       #料件编号   #仓库           #储位        #批号
      CALL s_ins_tlf(p_azw01,    l_ogb.ogb04,l_ogb.ogb09,    l_ogb.ogb091,l_ogb.ogb092,
                     #数量       #类型       #单据编号       #项次        #单据编号(参)
                     l_ogb.ogb16,'1',        l_ogb.ogb01,    l_ogb.ogb03, l_ogb.ogb31,
                     #项次(参)   #单位       #转换率         #客户        #日期
                     l_ogb.ogb32,l_ogb.ogb05,l_ogb.ogb05_fac,l_oga.oga03, l_oga.oga02)
      IF g_success = 'N' THEN
         RETURN
      END IF

      INITIALIZE l_ogb.*,l_img.* TO NULL
  
   END FOREACH 
   
   IF g_success = 'Y' THEN 
      #更新出货单过账码
      LET l_sql = "UPDATE ",cl_get_target_table(p_azw01,'oga_file'),
                  "   SET ogapost = 'Y' ",
                  " WHERE oga01 = '",l_oga.oga01,"' AND ogaplant = '",l_oga.ogaplant,"' "
      PREPARE s_oga_post_upd_oga_pre FROM l_sql
      EXECUTE s_oga_post_upd_oga_pre
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         LET g_errno = SQLCA.sqlcode
         CALL s_errmsg('','',' UPD oga_file(ogapost)',SQLCA.sqlcode,1)
         RETURN
      END IF
   END IF
   
END FUNCTION 

# Function name..: s_rvu_post
# Descriptions...: 入库/仓退单过账逻辑
# Input Parameter: p_azw01 所属营运中心
#                  p_rvu01 单据编号
# Usage..........: CALL s_rvu_post(p_azw01,p_rvu01)

FUNCTION s_rvu_post(p_azw01,p_rvu01)
DEFINE p_azw01   LIKE azw_file.azw01
DEFINE p_rvu01   LIKE rvu_file.rvu01
DEFINE l_rvu     RECORD LIKE rvu_file.*
DEFINE l_rvv     RECORD LIKE rvv_file.*
DEFINE l_sql     STRING
DEFINE l_count   LIKE type_file.num10
DEFINE l_img     RECORD LIKE img_file.*

   IF g_success = 'N' THEN RETURN END IF

   WHENEVER ERROR CONTINUE

   IF cl_null(p_azw01) OR cl_null(p_rvu01) THEN RETURN END IF

  #CALL s_rvu_post_chk(p_azw01,p_rvu01)
   IF g_success = 'N' THEN RETURN END IF
   
   INITIALIZE l_rvu.* TO NULL
   INITIALIZE l_rvv.* TO NULL
   
   #取入库/仓退单单头
   LET l_sql = "SELECT * FROM ",cl_get_target_table(p_azw01,'rvu_file')," WHERE rvu01 = '",p_rvu01 CLIPPED,"' "
   PREPARE s_rvu_post_sel_rvu_pre FROM l_sql
   EXECUTE s_rvu_post_sel_rvu_pre INTO l_rvu.*

   IF l_rvu.rvu03 <= g_sma.sma53 THEN
      LET g_success = 'N'
      LET g_errno = 'mfg9999'
      CALL s_errmsg('rvu03',l_rvu.rvu03,' oga_post(chk rvu03):','mfg9999',1)
      RETURN
   END IF
   
   #取入库/仓退单单身
   LET l_sql = "SELECT * FROM ",cl_get_target_table(p_azw01,'rvv_file')," WHERE rvv01 = '",p_rvu01 CLIPPED,"' "
   PREPARE s_rvu_post_sel_rvv_pre FROM l_sql
   DECLARE s_rvu_post_sel_rvv_cs CURSOR FOR s_rvu_post_sel_rvv_pre
   
   #取img笔数
   LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(p_azw01,'img_file'),
               " WHERE img01 = ? AND img02 = ? ",
               "   AND img03 = ? AND img04 = ? "
   PREPARE s_rvu_post_sel_count_img_pre FROM l_sql
   
   #锁库存明细img
   LET l_sql = "SELECT * FROM ",cl_get_target_table(p_azw01,'img_file'),
               " WHERE img01 = ? AND img02 = ? ",
               "   AND img03 = ? AND img04 = ? FOR UPDATE "
   CALL cl_forupd_sql(l_sql) RETURNING l_sql
   LET l_sql = cl_forupd_sql(l_sql)
   DECLARE s_rvu_post_sel_img_lock CURSOR FROM l_sql
   
   #更新库存
   LET l_sql = "UPDATE ",cl_get_target_table(p_azw01,'img_file')
   IF l_rvu.rvu00 = '1' THEN 
      LET l_sql = l_sql CLIPPED," SET img10 = img10 + ?, "
   ELSE
      LET l_sql = l_sql CLIPPED," SET img10 = img10 - ?, "
   END IF
   LET l_sql = l_sql CLIPPED," img16 = '",l_rvu.rvu03,"',img17 = '",l_rvu.rvu03,"' WHERE img01 = ? AND img02 = ? AND img03 = ? AND img04 = ? "
   PREPARE s_rvu_post_upd_img_pre FROM l_sql
   
   
   FOREACH s_rvu_post_sel_rvv_cs INTO l_rvv.*
     #IF l_rvv.rvv31[1,4] = 'MISC' THEN 
     #   CONTINUE FOREACH 
     #ELSE
     #	 LET l_sql = "SELECT COALESCE(rty06,'1') FROM ",cl_get_target_table(p_azw01,'rty_file'),
     #	             " WHERE rty01 = '",p_rvu.rvuplant,"' AND rty02 = '",l_rvv.rvv31,"' "
     #	 PREPARE s_rvu_post_sel_rty06_pre FROM l_sql
     #	 EXECUTE s_rvu_post_sel_rty06_pre INTO l_rty06
     #	 IF NOT cl_null(l_rty06) AND l_rty06 = '4' THEN
     #	    CONTINUE FOREACH
     #	 END IF
     #END IF
      
      LET l_count = 0
      EXECUTE s_rvu_post_sel_count_img_pre INTO l_count USING l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34
      IF l_count = 0 THEN
         LET g_sma.sma892[2,2] = 'N'
         LET g_sma.sma39 = 'Y'
         CALL s_madd_img(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvu.rvu01,l_rvv.rvv02,l_rvu.rvu03,p_azw01)
         IF g_success='N' THEN
            RETURN
         END IF
      END IF
      
      OPEN s_rvu_post_sel_img_lock USING l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34 
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         LET g_errno = SQLCA.sqlcode
         CALL s_errmsg('','',' OPEN s_rvu_post_sel_img_lock:',SQLCA.sqlcode,1)
         CLOSE s_rvu_post_sel_img_lock
         RETURN
      END IF
      
      FETCH s_rvu_post_sel_img_lock INTO l_img.*
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         LET g_errno = SQLCA.sqlcode
         CALL s_errmsg('','',' FETCH s_rvu_post_sel_img_lock:',SQLCA.sqlcode,1)
         CLOSE s_rvu_post_sel_img_lock
         RETURN
      END IF
      
      EXECUTE s_rvu_post_upd_img_pre USING l_rvv.rvv17,l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34 
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         LET g_errno = SQLCA.sqlcode
         CALL s_errmsg('','',' UPD img_file',SQLCA.sqlcode,1)
         RETURN
      END IF
      
      IF l_rvu.rvu00 = '1' THEN
                        #门店       #料件编号   #仓库           #储位       #批号
         CALL s_ins_tlf(p_azw01,    l_rvv.rvv31,l_rvv.rvv32,    l_rvv.rvv33,l_rvv.rvv34,
                        #数量       #类型       #单据编号       #项次       #单据编号(参)
                        l_rvv.rvv17,'3',        l_rvv.rvv01,    l_rvv.rvv02,l_rvv.rvv04,
                        #项次(参)   #单位       #转换率         #部门       #日期
                        l_rvv.rvv05,l_rvv.rvv35,l_rvv.rvv35_fac,l_rvv.rvv06,l_rvu.rvu03)
      ELSE
                        #门店       #料件编号   #仓库           #储位       #批号
         CALL s_ins_tlf(p_azw01,    l_rvv.rvv31,l_rvv.rvv32,    l_rvv.rvv33,l_rvv.rvv34,
                        #数量       #类型       #单据编号       #项次       #单据编号(参)
                        l_rvv.rvv17,'4',        l_rvv.rvv01,    l_rvv.rvv02,l_rvv.rvv04,
                        #项次(参)   #单位       #转换率         #部门       #日期
                        l_rvv.rvv05,l_rvv.rvv35,l_rvv.rvv35_fac,l_rvv.rvv06,l_rvu.rvu03)
      END IF
      IF g_success = 'N' THEN
         RETURN
      END IF
      
      INITIALIZE l_rvv.*,l_img.* TO NULL
  
   END FOREACH 
   
END FUNCTION 

# Function name..: s_ins_tlf
# Descriptions...: 新增库存异动明细
# Input Parameter: p_azw01  - 所属营运中心
#                  p_part   - 料件编号
#                  p_ware   - 仓库
#                  p_loca   - 储位
#                  p_lot    - 批号
#                  p_qty    - 数量
#                  p_sta    - 异动类型 - 1.出货 2.销退 3.入库 4.仓退
#                  p_no     - 单据编号
#                  p_no1    - 单据项次
#                  p_no2    - 单据编号(参考单号)
#                  p_no3    - 单据项次(参考项次)
#                  p_unit   - 单位
#                  p_factor - 转换率
#                  p_gov    - 所属部门
#                  p_date   - 单据日期
# Usage..........: s_ins_tlf(p_azw01,p_part,p_ware,p_loca,p_lot,p_qty,p_sta,p_no,p_no1,p_no2,p_no3,p_unit,p_factor,p_gov,p_date)

FUNCTION s_ins_tlf(p_azw01,p_part,p_ware,p_loca,p_lot,p_qty,p_sta,p_no,p_no1,p_no2,p_no3,p_unit,p_factor,p_gov,p_date)
DEFINE p_azw01  LIKE azw_file.azw01        #所属营运中心
DEFINE p_part   LIKE img_file.img01        #料件編號(p_part)
DEFINE p_ware   LIKE img_file.img02        #倉庫
DEFINE p_loca   LIKE img_file.img03        #儲位
DEFINE p_lot    LIKE img_file.img04        #批號
DEFINE p_qty    LIKE img_file.img10        #數量
DEFINE p_sta    LIKE type_file.chr1        #1.出货2.销退3.入库4.仓退
DEFINE p_no     LIKE ogb_file.ogb01        #单据编号
DEFINE p_no1    LIKE ogb_file.ogb03        #单据项次
DEFINE p_no2    LIKE ogb_file.ogb01        #单据编号(参考号码)
DEFINE p_no3    LIKE ogb_file.ogb03        #单据项次
DEFINE p_factor LIKE ima_file.ima31_fac    #轉換率
DEFINE p_unit   LIKE ima_file.ima25        #單位
DEFINE p_gov    LIKE oga_file.oga15        #部門
DEFINE p_date   LIKE oga_file.oga02        #单据日期
DEFINE l_ima25  LIKE ima_file.ima25        #庫存單位
DEFINE l_ima86  LIKE ima_file.ima86        #成本單位
DEFINE l_azw02  LIKE azw_file.azw02        #所屬法人
DEFINE l_sql    STRING

   IF g_success = 'N' THEN RETURN END IF

   WHENEVER ERROR CONTINUE

   INITIALIZE g_tlf.* TO NULL

   IF cl_null(p_loca) THEN LET p_loca = ' ' END IF
   IF cl_null(p_lot)  THEN LET p_lot  = ' ' END IF
   
   LET l_sql = "SELECT ima25,ima86 FROM ",cl_get_target_table(p_azw01,'ima_file')," WHERE ima01 = '",p_part,"' "
   PREPARE s_ins_tlf_sel_ima_pre FROM l_sql
   EXECUTE s_ins_tlf_sel_ima_pre INTO l_ima25,l_ima86
   
   LET l_sql = "SELECT azw02 FROM ",cl_get_target_table(p_azw01,'azw_file')," WHERE azw01 = '",p_azw01,"' "
   PREPARE s_ins_tlf_sel_azw_pre FROM l_sql
   EXECUTE s_ins_tlf_sel_azw_pre INTO l_azw02
   
   CASE p_sta
      WHEN '1'  #出货
         LET g_tlf.tlf02  = 50             #來源狀況                  
         LET g_tlf.tlf020 = p_azw01        #異動來源營運中心編號      
         LET g_tlf.tlf021 = p_ware         #倉庫別                    
         LET g_tlf.tlf022 = p_loca         #儲位                      
         LET g_tlf.tlf023 = p_lot          #批號                      
         LET g_tlf.tlf024 = ' '            #異動後庫存數量            
         LET g_tlf.tlf025 = l_ima25        #異動後庫存數量單位        
         LET g_tlf.tlf026 = p_no           #單據編號                  
         LET g_tlf.tlf027 = p_no1          #單據項次                  
         LET g_tlf.tlf03  = 724            #目的狀況                  
         LET g_tlf.tlf030 = ' '            #異動目的營運中心編號      
         LET g_tlf.tlf031 = ' '            #倉庫別                    
         LET g_tlf.tlf032 = ' '            #儲位                      
         LET g_tlf.tlf033 = ' '            #批號                      
         LET g_tlf.tlf034 = ' '            #異動後庫存數量            
         LET g_tlf.tlf035 = ' '            #異動後庫存數量單位        
         LET g_tlf.tlf036 = p_no2          #單據編號                  
         LET g_tlf.tlf037 = p_no3          #單據項次                  
         LET g_tlf.tlf11  = p_unit         #異動數量單位              
         LET g_tlf.tlf12  = p_factor       #轉換率                    
         LET g_tlf.tlf13  = 'axmt620'      #異動命令程式代號          
         LET g_tlf.tlf19  = p_gov          #異動廠商/客戶編號/部門編號
         LET g_tlf.tlf60  = p_factor       #異動單據單位對庫存單位之換
      WHEN '2'  #销退
         LET g_tlf.tlf02  = 731            #來源狀況
         LET g_tlf.tlf020 = ' '            #異動來源營運中心編號
         LET g_tlf.tlf021 = ' '            #倉庫別
         LET g_tlf.tlf022 = ' '            #儲位
         LET g_tlf.tlf023 = ' '            #批號
         LET g_tlf.tlf024 = ' '            #異動後庫存數量
         LET g_tlf.tlf025 = ' '            #異動後庫存數量單位
         LET g_tlf.tlf026 = p_no           #單據編號
         LET g_tlf.tlf027 = p_no1          #單據項次
         LET g_tlf.tlf03  = 50             #目的狀況
         LET g_tlf.tlf030 = p_azw01        #異動目的營運中心編號
         LET g_tlf.tlf031 = p_ware         #倉庫別
         LET g_tlf.tlf032 = p_loca         #儲位
         LET g_tlf.tlf033 = p_lot          #批號
         LET g_tlf.tlf034 = ' '            #異動後庫存數量
         LET g_tlf.tlf035 = l_ima25        #異動後庫存數量單位
         LET g_tlf.tlf036 = p_no           #單據編號
         LET g_tlf.tlf037 = p_no1          #單據項次
         LET g_tlf.tlf11  = p_unit         #異動數量單位
         LET g_tlf.tlf12  = p_factor       #轉換率
         LET g_tlf.tlf13  = 'aomt800'      #異動命令程式代號
         LET g_tlf.tlf19  = p_gov          #異動廠商/客戶編號/部門編號
         LET g_tlf.tlf60  = p_factor       #異動單據單位對庫存單位之換
      WHEN '3'  #入庫
         LET g_tlf.tlf02  = 20             #來源狀況
         LET g_tlf.tlf020 = p_azw01        #異動來源營運中心編號
         LET g_tlf.tlf021 = ' '            #倉庫別
         LET g_tlf.tlf022 = ' '            #儲位
         LET g_tlf.tlf023 = ' '            #批號
         LET g_tlf.tlf024 = ' '            #異動後庫存數量
         LET g_tlf.tlf025 = ' '            #異動後庫存數量單位
         LET g_tlf.tlf026 = p_no           #單據編號
         LET g_tlf.tlf027 = p_no1          #單據項次
         LET g_tlf.tlf03  = 50             #目的狀況
         LET g_tlf.tlf030 = ''             #異動目的營運中心編號
         LET g_tlf.tlf031 = p_ware         #倉庫別
         LET g_tlf.tlf032 = p_loca         #儲位
         LET g_tlf.tlf033 = p_lot          #批號
         LET g_tlf.tlf034 = ' '            #異動後庫存數量
         LET g_tlf.tlf035 = l_ima25        #異動後庫存數量單位
         LET g_tlf.tlf036 = p_no2          #單據編號
         LET g_tlf.tlf037 = p_no3          #單據項次
         LET g_tlf.tlf11  = p_unit         #異動數量單位
         LET g_tlf.tlf12  = p_factor       #轉換率
         LET g_tlf.tlf13  = 'apmt150'      #異動命令程式代號
         LET g_tlf.tlf19  = p_gov          #異動廠商/客戶編號/部門編號
         LET g_tlf.tlf60  = p_factor       #異動單據單位對庫存單位之換
      WHEN '4'  #倉退
         LET g_tlf.tlf02  = 50             #來源狀況                  
         LET g_tlf.tlf020 = p_azw01        #異動來源營運中心編號      
         LET g_tlf.tlf021 = p_ware         #倉庫別                    
         LET g_tlf.tlf022 = p_loca         #儲位                      
         LET g_tlf.tlf023 = p_lot          #批號                      
         LET g_tlf.tlf024 = ' '            #異動後庫存數量            
         LET g_tlf.tlf025 = l_ima25        #異動後庫存數量單位        
         LET g_tlf.tlf026 = p_no           #單據編號                  
         LET g_tlf.tlf027 = p_no1          #單據項次                  
         LET g_tlf.tlf03  = 31             #目的狀況                  
         LET g_tlf.tlf030 = ''             #異動目的營運中心編號      
         LET g_tlf.tlf031 = ' '            #倉庫別                    
         LET g_tlf.tlf032 = ' '            #儲位                      
         LET g_tlf.tlf033 = ' '            #批號                      
         LET g_tlf.tlf034 = ' '            #異動後庫存數量            
         LET g_tlf.tlf035 = ' '            #異動後庫存數量單位        
         LET g_tlf.tlf036 = p_no2          #單據編號                  
         LET g_tlf.tlf037 = p_no3          #單據項次                  
         LET g_tlf.tlf11  = p_unit         #異動數量單位              
         LET g_tlf.tlf12  = p_factor       #轉換率                    
         LET g_tlf.tlf13  = 'apmt1072'     #異動命令程式代號          
         LET g_tlf.tlf19  = p_gov          #異動廠商/客戶編號/部門編號
         LET g_tlf.tlf60  = p_factor       #異動單據單位對庫存單位之換
   END CASE
   LET g_tlf.tlf01    = p_part             #異動料件編號
   LET g_tlf.tlf012   = ' '                #製程段號
   LET g_tlf.tlf013   = 0                  #製程序
   LET g_tlf.tlf04    = ' '                #工作站
   LET g_tlf.tlf05    = ' '                #作業編號
   LET g_tlf.tlf06    = p_date             #單據扣帳日期
   LET g_tlf.tlf07    = g_today            #執行扣帳日期
   LET g_tlf.tlf08    = TIME               #異動資料產生時間
   LET g_tlf.tlf09    = g_user             #異動資料發出者
   LET g_tlf.tlf10    = p_qty              #異動數量
   LET g_tlf.tlf17    = ' '                #備註
   LET g_tlf.tlf20    = ' '                #專案號碼
   LET g_tlf.tlf61    = l_ima86            #單別
   LET g_tlf.tlfplant = p_azw01            #所屬營運中心
   LET g_tlf.tlflegal = l_azw02            #所屬法人
         
   CASE  
      WHEN g_tlf.tlf02=50
         LET g_tlf.tlf902 = g_tlf.tlf021   #倉庫
         LET g_tlf.tlf903 = g_tlf.tlf022   #儲位
         LET g_tlf.tlf904 = g_tlf.tlf023   #批號
         LET g_tlf.tlf905 = g_tlf.tlf026   #單號
         LET g_tlf.tlf906 = g_tlf.tlf027   #項次
         LET g_tlf.tlf907 = -1             #入出庫碼
      WHEN g_tlf.tlf03=50 
         LET g_tlf.tlf902 = g_tlf.tlf031   #倉庫    
         LET g_tlf.tlf903 = g_tlf.tlf032   #儲位    
         LET g_tlf.tlf904 = g_tlf.tlf033   #批號    
         LET g_tlf.tlf905 = g_tlf.tlf036   #單號    
         LET g_tlf.tlf906 = g_tlf.tlf037   #項次    
         LET g_tlf.tlf907 = 1              #入出庫碼
      OTHERWISE 
         LET g_tlf.tlf902 = ' '            #倉庫    
         LET g_tlf.tlf903 = ' '            #儲位    
         LET g_tlf.tlf904 = ' '            #批號    
         LET g_tlf.tlf905 = ' '            #單號    
         LET g_tlf.tlf906 = ' '            #項次    
         LET g_tlf.tlf907 = 0              #入出庫碼
   END CASE
   
   IF NOT cl_null(g_tlf.tlf902) THEN
      LET l_sql = "SELECT imd09 ",
                  "  FROM ",cl_get_target_table(p_azw01,'imd_file'),
                  " WHERE imd01 = '",g_tlf.tlf902,"' ",
                  "   AND imdacti = 'Y' "
      PREPARE s_ins_tlf_sel_imd09_pre FROM l_sql
      EXECUTE s_ins_tlf_sel_imd09_pre INTO g_tlf.tlf901
      IF cl_null(g_tlf.tlf901) THEN LET g_tlf.tlf901 = ' ' END IF
   ELSE
      LET g_tlf.tlf901 = ' '                #成本庫別
   END IF

   IF (g_tlf.tlf02 = 50 OR g_tlf.tlf03 = 50) THEN
      IF NOT s_tlfidle(p_azw01,g_tlf.*) THEN
         CALL cl_err('upd ima902:','9050',1)
         LET g_success = 'N'
      END IF
   END IF
   
   LET l_sql = "INSERT INTO ",cl_get_target_table(p_azw01,'tlf_file'),"( ",
               "            tlf01, ",       #异动料件编号 
               "            tlf02, ",       #来源状况
               "            tlf020, ",      #异动来源营运中心编号
               "            tlf021, ",      #仓库
               "            tlf022, ",      #库位
               "            tlf023, ",      #批号
               "            tlf024, ",      #异动后库存数量                                             
               "            tlf025, ",      #异动后库存数量单位                                         
               "            tlf026, ",      #单据编号
               "            tlf027, ",      #单据项次
               "            tlf03, ",       #目的状况
               "            tlf030, ",      #异动目的营运中心编号                                       
               "            tlf031, ",      #仓库
               "            tlf032, ",      #库位
               "            tlf033, ",      #批号
               "            tlf034, ",      #异动后库存数量                                             
               "            tlf035, ",      #异动后库存数量单位                                         
               "            tlf036, ",      #单据编号
               "            tlf037, ",      #单据项次
               "            tlf04, ",       #工作站
               "            tlf05, ",       #作业编号
               "            tlf06, ",       #单据扣帐日期
               "            tlf07, ",       #运行扣帐日期
               "            tlf08, ",       #异动资料生成时间                                           
               "            tlf09, ",       #异动资料发出者                                             
               "            tlf10, ",       #异动数量
               "            tlf11, ",       #异动数量单位
               "            tlf12, ",       #异动数量单位与异动目的数量单位转换率                       
               "            tlf13, ",       #异动指令编号
               "            tlf14, ",       #异动原因
               "            tlf15, ",       #借方会计科目
               "            tlf16, ",       #贷方会计科目
               "            tlf17, ",       #备注
               "            tlf18, ",       #异动后总库存量                                             
               "            tlf19, ",       #异动厂商/客户编号/部门编号                                 
               "            tlf20, ",       #项目号码
               "            tlf21, ",       #成会异动成本
               "            tlf211, ",      #成会计算日期
               "            tlf212, ",      #成会计算时间
               "            tlf2131, ",     #No Use
               "            tlf2132, ",     #No Use
               "            tlf214, ",      #No Use
               "            tlf215, ",      #No Use
               "            tlf2151, ",     #No Use
               "            tlf216, ",      #No Use
               "            tlf2171, ",     #No Use
               "            tlf2172, ",     #No Use
               "            tlf219, ",      #1.第二单位   2.第一单位
               "            tlf218, ",      #第二单位的rowid内容
               "            tlf220, ",      #单位  双单位的单位
               "            tlf221, ",      #材料成本
               "            tlf222, ",      #人工成本
               "            tlf2231, ",     #制费一成本
               "            tlf2232, ",     #加工成本
               "            tlf224, ",      #制费二成本
               "            tlf225, ",      #No Use
               "            tlf2251, ",     #No Use
               "            tlf226, ",      #No Use
               "            tlf2271, ",     #No Use
               "            tlf2272, ",     #No Use
               "            tlf229, ",      #No Use
               "            tlf230, ",      #No Use
               "            tlf231, ",      #No Use
               "            tlf60, ",       #异动单据单位对库存单位之换算率
               "            tlf61, ",       #单别
               "            tlf62, ",       #工单单号
               "            tlf63, ",       #No Use
               "            tlf64, ",       #手册编号
               "            tlf65, ",       #凭证编号
               "            tlf66, ",       #多仓出货 Flag
               "            tlf901, ",      #成本仓库
               "            tlf902, ",      #仓库
               "            tlf903, ",      #库位
               "            tlf904, ",      #批号
               "            tlf905, ",      #单号
               "            tlf906, ",      #项次
               "            tlf907, ",      #入出库码
               "            tlf908, ",      #保税审核否
               "            tlf909, ",      #保税撷取否
               "            tlf910, ",      #合同撷取否
               "            tlf99, ",       #多角序号
               "            tlf930, ",      #成本中心
               "            tlf931, ",      #内部成本
               "            tlf151, ",      #借方会计科目二
               "            tlf161, ",      #贷方会计科目二
               "            tlf2241, ",     #制费三成本
               "            tlf2242, ",     #制费四成本
               "            tlf2243, ",     #制费五成本
               "            tlfcost, ",     #类型编号(批次号/专案号/利润中心)
               "            tlf41, ",       #WBS编号
               "            tlf42, ",       #活动编号
               "            tlf43, ",       #理由码
               "            tlf211x, ",     #成会计算日期
               "            tlf212x, ",     #成会计算时间
               "            tlf21x, ",      #成会异动成本
               "            tlf221x, ",     #材料成本
               "            tlf222x, ",     #人工成本
               "            tlf2231x, ",    #制费一成本
               "            tlf2232x, ",    #加工成本
               "            tlf2241x, ",    #制费三成本
               "            tlf2242x, ",    #制费四成本
               "            tlf2243x, ",    #制费五成本
               "            tlf224x, ",     #制费二成本
               "            tlf65x, ",      #凭证编号
               "            tlfplant, ",    #所属营运中心
               "            tlflegal, ",    #所属法人
               "            tlf27, ",       #被替代料号
               "            tlf28, ",       #成会分类
               "            tlf012, ",      #工艺段号
               "            tlf013) ",      #工艺序
               "     VALUES(?,?,?,?,?,  ?,?,?,?,?, ",   #1  ~10
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #11 ~20
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #21 ~30
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #31 ~40
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #41 ~50
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #51 ~60
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #61 ~70
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #71 ~80
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #81 ~90
               "            ?,?,?,?,?,  ?,?,?,?,?, ",   #91 ~100
               "            ?,?,?,?,?,  ?,?,?,?,?) "    #101~110
   PREPARE s_ins_tlf_pre FROM l_sql
   EXECUTE s_ins_tlf_pre USING g_tlf.tlf01,          #异动料件编号
                               g_tlf.tlf02,          #来源状况
                               g_tlf.tlf020,         #异动来源营运中心编号
                               g_tlf.tlf021,         #仓库
                               g_tlf.tlf022,         #库位
                               g_tlf.tlf023,         #批号  
                               g_tlf.tlf024,         #异动后库存数量
                               g_tlf.tlf025,         #异动后库存数量单位
                               g_tlf.tlf026,         #单据编号
                               g_tlf.tlf027,         #单据项次
                               g_tlf.tlf03,          #目的状况
                               g_tlf.tlf030,         #异动目的营运中心编号
                               g_tlf.tlf031,         #仓库
                               g_tlf.tlf032,         #库位
                               g_tlf.tlf033,         #批号
                               g_tlf.tlf034,         #异动后库存数量
                               g_tlf.tlf035,         #异动后库存数量单位
                               g_tlf.tlf036,         #单据编号
                               g_tlf.tlf037,         #单据项次
                               g_tlf.tlf04,          #工作站
                               g_tlf.tlf05,          #作业编号
                               g_tlf.tlf06,          #单据扣帐日期
                               g_tlf.tlf07,          #运行扣帐日期
                               g_tlf.tlf08,          #异动资料生成时间
                               g_tlf.tlf09,          #异动资料发出者
                               g_tlf.tlf10,          #异动数量 
                               g_tlf.tlf11,          #异动数量单位
                               g_tlf.tlf12,          #异动数量单位与异动目的数量单位转换率
                               g_tlf.tlf13,          #异动指令编号
                               g_tlf.tlf14,          #异动原因
                               g_tlf.tlf15,          #借方会计科目
                               g_tlf.tlf16,          #贷方会计科目
                               g_tlf.tlf17,          #备注
                               g_tlf.tlf18,          #异动后总库存量
                               g_tlf.tlf19,          #异动厂商/客户编号/部门编号
                               g_tlf.tlf20,          #项目号码
                               g_tlf.tlf21,          #成会异动成本
                               g_tlf.tlf211,         #成会计算日期
                               g_tlf.tlf212,         #成会计算时间
                               g_tlf.tlf2131,        #No Use
                               g_tlf.tlf2132,        #No Use
                               g_tlf.tlf214,         #No Use
                               g_tlf.tlf215,         #No Use
                               g_tlf.tlf2151,        #No Use
                               g_tlf.tlf216,         #No Use
                               g_tlf.tlf2171,        #No Use
                               g_tlf.tlf2172,        #No Use
                               g_tlf.tlf219,         #1.第二单位   2.第一单位
                               g_tlf.tlf218,         #第二单位的rowid内容
                               g_tlf.tlf220,         #单位  双单位的单位
                               g_tlf.tlf221,         #材料成本
                               g_tlf.tlf222,         #人工成本
                               g_tlf.tlf2231,        #制费一成本
                               g_tlf.tlf2232,        #加工成本
                               g_tlf.tlf224,         #制费二成本
                               g_tlf.tlf225,         #No Use
                               g_tlf.tlf2251,        #No Use
                               g_tlf.tlf226,         #No Use
                               g_tlf.tlf2271,        #No Use
                               g_tlf.tlf2272,        #No Use
                               g_tlf.tlf229,         #No Use
                               g_tlf.tlf230,         #No Use
                               g_tlf.tlf231,         #No Use
                               g_tlf.tlf60,          #异动单据单位对库存单位之换算率
                               g_tlf.tlf61,          #单别
                               g_tlf.tlf62,          #工单单号
                               g_tlf.tlf63,          #No Use
                               g_tlf.tlf64,          #手册编号
                               g_tlf.tlf65,          #凭证编号
                               g_tlf.tlf66,          #多仓出货 Flag
                               g_tlf.tlf901,         #成本仓库
                               g_tlf.tlf902,         #仓库
                               g_tlf.tlf903,         #库位
                               g_tlf.tlf904,         #批号
                               g_tlf.tlf905,         #单号
                               g_tlf.tlf906,         #项次
                               g_tlf.tlf907,         #入出库码
                               g_tlf.tlf908,         #保税审核否
                               g_tlf.tlf909,         #保税撷取否 
                               g_tlf.tlf910,         #合同撷取否
                               g_tlf.tlf99,          #多角序号
                               g_tlf.tlf930,         #成本中心
                               g_tlf.tlf931,         #内部成本
                               g_tlf.tlf151,         #借方会计科目二
                               g_tlf.tlf161,         #贷方会计科目二
                               g_tlf.tlf2241,        #制费三成本
                               g_tlf.tlf2242,        #制费四成本
                               g_tlf.tlf2243,        #制费五成本
                               g_tlf.tlfcost,        #类型编号(批次号/专案号/利润中心)
                               g_tlf.tlf41,          #WBS编号
                               g_tlf.tlf42,          #活动编号
                               g_tlf.tlf43,          #理由码
                               g_tlf.tlf211x,        #成会计算日期
                               g_tlf.tlf212x,        #成会计算时间
                               g_tlf.tlf21x,         #成会异动成本
                               g_tlf.tlf221x,        #材料成本
                               g_tlf.tlf222x,        #人工成本
                               g_tlf.tlf2231x,       #制费一成本
                               g_tlf.tlf2232x,       #加工成本
                               g_tlf.tlf2241x,       #制费三成本
                               g_tlf.tlf2242x,       #制费四成本
                               g_tlf.tlf2243x,       #制费五成本
                               g_tlf.tlf224x,        #制费二成本
                               g_tlf.tlf65x,         #凭证编号
                               g_tlf.tlfplant,       #所属营运中心
                               g_tlf.tlflegal,       #所属法人
                               g_tlf.tlf27,          #被替代料号
                               g_tlf.tlf28,          #成会分类
                               g_tlf.tlf012,         #工艺段号
                               g_tlf.tlf013          #工艺序
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      LET g_errno = SQLCA.sqlcode
      CALL s_errmsg('tlf01',g_tlf.tlf01,'tlf_ins',SQLCA.sqlcode,1)
   END IF
END FUNCTION

#FUN-CC0082
