# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_aligntxt_left.4gl
# Descriptions...: 傳入字串會截去頭尾附加的空白字元, 以達整體一致的 aligen
# Input parameter: ls_txt,li_move
# Return code....: ls_txt 修改完成字串
# Date & Author..: 04/04/05 alex
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds   #FUN-7C0053
 
FUNCTION s_aligntxt_left(ls_txt,li_move)   
 
   DEFINE ls_txt      STRING
   DEFINE ls_takeout  STRING
   DEFINE ls_putin    STRING
   DEFINE ls_ascii10  STRING
   DEFINE ls_txtleft  STRING
   DEFINE ls_txtright STRING
   DEFINE li_move     LIKE type_file.num5   	#No.FUN-680147 SMALLINT
   DEFINE li_length   LIKE type_file.num5   	#No.FUN-680147 SMALLINT
   DEFINE li_i        LIKE type_file.num5   	#No.FUN-680147 SMALLINT
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   # 若要排版的數值未大於等於一, 則顯示 "請聯絡資管人員" 的錯誤訊息並跳出
   IF li_move < 1 THEN
      CALL cl_err("s_aligntxt","sub-117",1)
      RETURN ls_txt
   END IF
 
   # 定義不變的字串值
   LET ls_ascii10 = ASCII 10
   LET ls_putin = ""
 
   FOR li_i=1 TO li_move
      LET ls_putin = ls_putin," "
   END FOR
 
   # 清除左右都有的空白字元
   LET ls_txt = ls_txt.trim()
 
   LET ls_txt = ls_putin || ls_txt
   LET li_length = ls_txt.getLength()
   LET li_i = 1 + li_move
 
   # 2004/04/05 hjwang 不用 FOR 回圈是因為這樣可以避免做過了又做, li_i 是可以
   #                   隨時的改變
   WHILE li_i < li_length 
 
      LET ls_takeout = ls_txt.getCharAt(li_i)
 
      IF ls_takeout.equals( ls_ascii10 ) THEN
         # 因為沒有 insertAt 所以只好分抓左右來做
         LET ls_txtleft  = ls_txt.subString(1,li_i)
         LET ls_txtright = ls_txt.subString(li_i+1,li_length)
         LET ls_txt=ls_txtleft || ls_putin || ls_txtright
 
         # 數值也要對應平移
         LET li_i=li_i+li_move
         LET li_length=li_length+li_move
      END IF
      LET li_i=li_i+1
 
   END WHILE
 
   RETURN ls_txt   
 
END FUNCTION
 
 
