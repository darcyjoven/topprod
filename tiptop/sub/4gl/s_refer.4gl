# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_refer.4gl
# Descriptions...: 日報表變動表頭定義
# Date & Author..: 93/05/03 By Apple
# Usage..........: CALL s_refer(p_code) RETURNING l_str1,l_str2,l_str3,l_str4
# Input Parameter: p_code   入庫狀況
# Return code....: l_str1   傳回字串
#                  l_str2   傳回字串
#                  l_str3   傳回字串
#                  l_str4   傳回字串
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_refer(p_code)
   DEFINE  p_code          LIKE type_file.num5,          #No.FUN-680147 SMALLINT
           l_str1,l_str2,l_str3,l_str4 LIKE cre_file.cre08        #No.FUN-680147 VARCHAR(10)
 
   CASE p_code
      WHEN 1
         SELECT ze03 INTO l_str1 FROM ze_file WHERE ze01 = 'sub-098' AND ze02 = g_lang
         SELECT ze03 INTO l_str2 FROM ze_file WHERE ze01 = 'sub-100' AND ze02 = g_lang
         SELECT ze03 INTO l_str3 FROM ze_file WHERE ze01 = 'sub-099' AND ze02 = g_lang
      WHEN 2
         SELECT ze03 INTO l_str1 FROM ze_file WHERE ze01 = 'sub-098' AND ze02 = g_lang
         SELECT ze03 INTO l_str2 FROM ze_file WHERE ze01 = 'sub-100' AND ze02 = g_lang
         SELECT ze03 INTO l_str3 FROM ze_file WHERE ze01 = 'sub-099' AND ze02 = g_lang
      WHEN 3
         SELECT ze03 INTO l_str1 FROM ze_file WHERE ze01 = 'sub-098' AND ze02 = g_lang
         SELECT ze03 INTO l_str2 FROM ze_file WHERE ze01 = 'sub-100' AND ze02 = g_lang
         SELECT ze03 INTO l_str3 FROM ze_file WHERE ze01 = 'sub-101' AND ze02 = g_lang
      WHEN 4
         SELECT ze03 INTO l_str1 FROM ze_file WHERE ze01 = 'sub-102' AND ze02 = g_lang
         SELECT ze03 INTO l_str2 FROM ze_file WHERE ze01 = 'sub-103' AND ze02 = g_lang
         SELECT ze03 INTO l_str3 FROM ze_file WHERE ze01 = 'sub-101' AND ze02 = g_lang
         SELECT ze03 INTO l_str4 FROM ze_file WHERE ze01 = 'sub-098' AND ze02 = g_lang
      WHEN 5
         SELECT ze03 INTO l_str1 FROM ze_file WHERE ze01 = 'sub-102' AND ze02 = g_lang
         SELECT ze03 INTO l_str2 FROM ze_file WHERE ze01 = 'sub-103' AND ze02 = g_lang
         SELECT ze03 INTO l_str3 FROM ze_file WHERE ze01 = 'sub-101' AND ze02 = g_lang
         SELECT ze03 INTO l_str4 FROM ze_file WHERE ze01 = 'sub-098' AND ze02 = g_lang
      WHEN 6
         SELECT ze03 INTO l_str1 FROM ze_file WHERE ze01 = 'sub-104' AND ze02 = g_lang
         SELECT ze03 INTO l_str2 FROM ze_file WHERE ze01 = 'sub-105' AND ze02 = g_lang
      WHEN 7
         SELECT ze03 INTO l_str1 FROM ze_file WHERE ze01 = 'sub-106' AND ze02 = g_lang
         SELECT ze03 INTO l_str2 FROM ze_file WHERE ze01 = 'sub-108' AND ze02 = g_lang
         SELECT ze03 INTO l_str3 FROM ze_file WHERE ze01 = 'sub-107' AND ze02 = g_lang
      WHEN 8
         SELECT ze03 INTO l_str1 FROM ze_file WHERE ze01 = 'sub-106' AND ze02 = g_lang
         SELECT ze03 INTO l_str2 FROM ze_file WHERE ze01 = 'sub-108' AND ze02 = g_lang
         SELECT ze03 INTO l_str3 FROM ze_file WHERE ze01 = 'sub-107' AND ze02 = g_lang
      WHEN 9
         SELECT ze03 INTO l_str1 FROM ze_file WHERE ze01 = 'sub-109' AND ze02 = g_lang
         SELECT ze03 INTO l_str2 FROM ze_file WHERE ze01 = 'sub-111' AND ze02 = g_lang
         SELECT ze03 INTO l_str3 FROM ze_file WHERE ze01 = 'sub-110' AND ze02 = g_lang
      WHEN 21
         SELECT ze03 INTO l_str1 FROM ze_file WHERE ze01 = 'sub-098' AND ze02 = g_lang
         SELECT ze03 INTO l_str2 FROM ze_file WHERE ze01 = 'sub-100' AND ze02 = g_lang
         SELECT ze03 INTO l_str3 FROM ze_file WHERE ze01 = 'sub-099' AND ze02 = g_lang
      WHEN 23
         SELECT ze03 INTO l_str1 FROM ze_file WHERE ze01 = 'sub-098' AND ze02 = g_lang
         SELECT ze03 INTO l_str2 FROM ze_file WHERE ze01 = 'sub-100' AND ze02 = g_lang
         SELECT ze03 INTO l_str3 FROM ze_file WHERE ze01 = 'sub-099' AND ze02 = g_lang
      WHEN 24
         SELECT ze03 INTO l_str1 FROM ze_file WHERE ze01 = 'sub-102' AND ze02 = g_lang
         SELECT ze03 INTO l_str2 FROM ze_file WHERE ze01 = 'sub-103' AND ze02 = g_lang
         SELECT ze03 INTO l_str3 FROM ze_file WHERE ze01 = 'sub-101' AND ze02 = g_lang
      WHEN 25
         SELECT ze03 INTO l_str1 FROM ze_file WHERE ze01 = 'sub-104' AND ze02 = g_lang
         SELECT ze03 INTO l_str2 FROM ze_file WHERE ze01 = 'sub-105' AND ze02 = g_lang
      WHEN 26
         SELECT ze03 INTO l_str1 FROM ze_file WHERE ze01 = 'sub-104' AND ze02 = g_lang
         SELECT ze03 INTO l_str2 FROM ze_file WHERE ze01 = 'sub-105' AND ze02 = g_lang
      WHEN 27
         SELECT ze03 INTO l_str1 FROM ze_file WHERE ze01 = 'sub-112' AND ze02 = g_lang
         SELECT ze03 INTO l_str2 FROM ze_file WHERE ze01 = 'sub-113' AND ze02 = g_lang
         SELECT ze03 INTO l_str3 FROM ze_file WHERE ze01 = 'sub-114' AND ze02 = g_lang
      WHEN 28
         SELECT ze03 INTO l_str1 FROM ze_file WHERE ze01 = 'sub-099' AND ze02 = g_lang
         SELECT ze03 INTO l_str2 FROM ze_file WHERE ze01 = 'sub-115' AND ze02 = g_lang
      WHEN 29
         SELECT ze03 INTO l_str1 FROM ze_file WHERE ze01 = 'sub-104' AND ze02 = g_lang
         SELECT ze03 INTO l_str2 FROM ze_file WHERE ze01 = 'sub-105' AND ze02 = g_lang
      WHEN 31
         SELECT ze03 INTO l_str1 FROM ze_file WHERE ze01 = 'sub-116' AND ze02 = g_lang
         SELECT ze03 INTO l_str2 FROM ze_file WHERE ze01 = 'sub-110' AND ze02 = g_lang
      OTHERWISE
         EXIT CASE
   END CASE
 
   RETURN l_str1,l_str2,l_str3,l_str4
 
#IF g_lang = '1' THEN 
#   CASE p_code 
#        #入庫狀況
#        WHEN  1        LET l_str1='  W/O   ' LET l_str3='  S/O   '
#                       LET l_str2='DEPT'
#        WHEN  2        LET l_str1='  W/O   ' LET l_str3='  S/O   '
#                       LET l_str2='DEPT'
#        WHEN  3        LET l_str1='  W/O   ' LET l_str3='  S/O   '
#                       LET l_str2='DEPT'
#        WHEN  4        LET l_str1='Receipt ' LET l_str3='  P/O   '
#                       LET l_str2='Ven.'
#        WHEN  5        LET l_str1='Receipt ' LET l_str3='  P/O   '
#                       LET l_str2='Ven.'     LET l_str4='  W/O   '
#        WHEN  6        LET l_str1='Ref. No.' LET l_str2='Note'
#        WHEN  7        LET l_str1='From W/H' LET l_str3='From Lot'
#                       LET l_str2='Location'
#        WHEN  8        LET l_str1='From W/H' LET l_str3='From Lot'
#                       LET l_str2='Location'
#        WHEN  9        LET l_str1='Plant   ' LET l_str3='Adj. No.'
#                       LET l_str2='Issue No'
#        #出庫狀況
#        WHEN 21        LET l_str1='  W/O   ' LET l_str3='  S/O   '
#                       LET l_str2='DEPT'
#        WHEN 23        LET l_str1='  W/O   ' LET l_str3='  S/O   '
#                       LET l_str2='DEPT'
#        WHEN 24        LET l_str1='Receipt ' LET l_str3='  P/O   '
#                       LET l_str2='Ven.'
#        WHEN 25        LET l_str1='Ref. No.' LET l_str2='Note'
#        WHEN 26        LET l_str1='Ref. No.' LET l_str2='Note'
#        WHEN 27        LET l_str1='To   W/H' LET l_str3='To Lot  '
#                       LET l_str2='Location'
#        WHEN 28        LET l_str1='  S/O   ' LET l_str2='Customer'
#
#        WHEN 29        LET l_str1='Ref. No.' LET l_str2='Note'
#        WHEN 31        LET l_str1='Plant   ' LET l_str2='Adj. No.'
#        OTHERWISE EXIT CASE
#   END CASE
#ELSE 
#   CASE p_code 
#        #入庫狀況
#        WHEN  1        LET l_str1='工單單號' LET l_str3='訂單單號'
#                       LET l_str2='部門'
#        WHEN  2        LET l_str1='工單單號' LET l_str3='訂單單號'
#                       LET l_str2='部門'
#        WHEN  3        LET l_str1='工單單號' LET l_str3='採購單號'
#                       LET l_str2='部門'     
#        WHEN  4        LET l_str1='驗收單號' LET l_str3='採購單號'
#                       LET l_str2='廠商'     LET l_str4='工單單號'
#        WHEN  5        LET l_str1='驗收單號' LET l_str3='採購單號'
#                       LET l_str2='廠商'     LET l_str4='工單單號'
#        WHEN  6        LET l_str1='參考單號' LET l_str2='理由'
#        WHEN  7        LET l_str1='來源倉庫' LET l_str3='來源批號'
#                       LET l_str2='來源儲位'
#        WHEN  8        LET l_str1='來源倉庫' LET l_str3='來源批號'
#                       LET l_str2='來源儲位'
#        WHEN  9        LET l_str1='撥出工廠' LET l_str3='調撥單號'
#                       LET l_str2='撥出單號'
#        #出庫狀況
#        WHEN 21        LET l_str1='工單編號' LET l_str3='訂單編號'
#                       LET l_str2='部門'
#        WHEN 23        LET l_str1='工單編號' LET l_str3='訂單編號'
#                       LET l_str2='部門'
#        WHEN 24        LET l_str1='驗收單號' LET l_str3='採購單號'
#                       LET l_str2='廠商'
#        WHEN 25        LET l_str1='參考單號' LET l_str2='理由'
#        WHEN 26        LET l_str1='參考單號' LET l_str2='理由'
#        WHEN 27        LET l_str1='目的倉庫' LET l_str3='目的批號'
#                       LET l_str2='目的儲位'
#        WHEN 28        LET l_str1='訂單編號' LET l_str2='客戶編號'
#
#        WHEN 29        LET l_str1='參考單號' LET l_str2='理由'
#        WHEN 31        LET l_str1='撥入工廠' LET l_str2='調撥單號'
#        OTHERWISE EXIT CASE
#   END CASE
#END IF
END FUNCTION
