# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_string_auno.4gl
# Descriptions...: 將字串加上後面的序號成為一新字串, 但序號會補滿十碼
# Date & Author..: 93/02/11 By alex
# Usage..........: CALL s_string_auno(p_string,p_auno) RETURNING p_string
# Input Parameter: p_string STRING    起頭的字串
#                  p_auno   alh_file.alh33 序號 	#No.FUN-680147
# Return code....: p_string 合併後的字串
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.MOD-910115 09/01/12 By chenl 調整p_j變量類型。
 
DATABASE ds      #No.FUN-680147   #FUN-7C0053
 
FUNCTION s_string_auno(p_string,p_auno)
 
   DEFINE p_string,p_digi    STRING
  #DEFINE p_auno,p_j         LIKE fab_file.fab09        #No.FUN-680147 DEC(11,0) #No.MOD-910115 mark
   DEFINE p_auno             LIKE fab_file.fab09        #No.MOD-910115  
   DEFINE p_j                LIKE type_file.num20_6     #No.MOD-910115
   DEFINE p_diff_digi        LIKE type_file.num5   	#No.FUN-680147 SMALLINT
   DEFINE p_i                LIKE type_file.num5   	#No.FUN-680147 SMALLINT
   
   LET p_diff_digi = 10
   LET p_j=p_auno
   FOR p_i=1 TO 10
       LET p_diff_digi = p_diff_digi - 1
       LET p_j = p_j / 10.0
       IF p_j < 10.0 THEN EXIT FOR END IF
   END FOR
   IF p_auno >= 10.0 AND p_auno <= 9444444444.0 THEN
      LET p_diff_digi = p_diff_digi - 1
   END IF
   LET p_digi = p_auno
   IF p_diff_digi >= 1 THEN
      FOR p_i=1 TO p_diff_digi
         LET p_string = p_string CLIPPED,"0"
      END FOR
   END IF
   LET p_string = p_string CLIPPED, p_digi.trimleft()
   RETURN p_string
 
END FUNCTION
