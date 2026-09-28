# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: almi560.4gl
# Descriptions...: 會員基本資料維護作業
# Date & Author..: NO.FUN-960058 08/09/02 By  destiny
# Modify.........: No.FUN-960058 09/06/12 by destiny從歐尚超市移植到標准版
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960081 09/10/22 by dxfwo 栏位的添加与删除 
# Modify.........: No.FUN-9B0136 09/11/25 By destiny construct新增字段
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A30030 10/03/10 By Cockroach ADD POS?
# Modify.........: No:MOD-A30222 10/03/30 By Smapmin 卡種名稱沒有顯示出來
# Modify.........: No:FUN-A60075 10/06/25 By sunchenxu 新增列印功能
# Modify.........: NO:FUN-A80148 10/09/01 By wangxin 因為lma_file已不使用,所以將lma_file改為rtz_file的相應欄位
# Modify.........: No.FUN-A80022 10/09/15 BY suncx add lpkpos已傳POS否
# Modify.........: No.MOD-AC0212 10/12/18 BY suncx 新增修改時 證件號碼不可以開窗否,輸入格式管控
# Modify.........: No.FUN-B30202 11/04/07 By huangtao 新增會員地址開窗維護和銷售明細查詢 
# Modify.........: No:FUN-B40071 11/04/28 by jason 已傳POS否狀態調整
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80060 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外 
# Modify.........: No:FUN-B80194 11/09/23 By pauline 新增生日月份欄位
# Modify.........: No.FUN-B70075 11/10/26 By nanbing 更新已傳POS否的狀態
# Modify.........: No.FUN-BC0058 11/12/20 By yangxf 原會員分類碼別以不同檔案區分存放,改以同一檔案不同類別區分.
# Modify.........: No.FUN-BC0079 11/12/22 By yuhuabao 加入出生年度/出生月份/出生日期及"紀念日維護" Action
# Modify.........: No:FUN-B90118 12/01/05 By pauline 判斷證件號碼是否為必要欄位,新增自定欄位頁籤,積分異動查詢  
# Modify.........: No:FUN-BC0134 12/01/05 By pauline 新增資料清單Page,以及匯出簡訊傳輸ACTION 
# Modify.........: No:MOD-C30152 12/03/09 By nanbing 輸入lpk03,檢查其證件號,若已存在,提示訊息,但不控卡.
# Modify.........: No:CHI-C30021 12/03/10 By nanbing 使用會員自動編號功能BUG更改

#FUN-BC0134 add START
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

IMPORT os

#FUN-BC0134 add END

DATABASE ds
#No.FUN-960058--begin 
GLOBALS "../../config/top.global"
#No.FUN-960081 


DEFINE g_argv1             LIKE lpk_file.lpk01   #FUN-B90118 add
DEFINE g_argv2             LIKE type_file.chr1   #FUN-B90118 add
MAIN 
   OPTIONS                               
        INPUT NO WRAP    #No.FUN-9B0136
    #   FIELD ORDER FORM #No.FUN-9B0136
   DEFER INTERRUPT              
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   LET g_argv1 = ARG_VAL(1)   #會員代號   #FUN-B90118 add
   LET g_argv2 = ARG_VAL(2)   #flag       #FUN-B90118 add
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF 
  
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   CALL i560(g_argv1,g_argv2,FALSE)#CHI-C30021 add
   
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
