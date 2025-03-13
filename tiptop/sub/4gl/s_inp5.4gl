# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_inp5.4gl
# Descriptions...: 特殊料號輸入(五段式)
# Date & Author..: 92/01/13 By LYS
# Usage..........: CALL s_inp5(p_row,p_col,p_part) RETURNING l_part
# Input Parameter: p_row   視窗左上角x坐標
#                  p_col   視窗左上角y坐標
#                  p_part  料件編號
# Return code....: l_part  料件編號
# Memo...........: 預設視窗位置(17,30)
# Modify.........: No.MOD-490217 04/09/10 by yiting 料號欄位使用like方式
# Modify.........: No.FUN-680147 06/09/04 By Czl  類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_inp5(p_row,p_col,l_part)
   DEFINE p_row,p_col	LIKE type_file.num5,       #No.FUN-680147 SMALLINT
           l_part	LIKE ima_file.ima01,       #No.MOD-490217
          l_part1	LIKE ima_file.ima01,       #No.FUN-680147 VARCHAR(9)	# 根據參數取位
          l_part2	LIKE ima_file.ima01,       #No.FUN-680147 VARCHAR(9)
          l_part3	LIKE ima_file.ima01,       #No.FUN-680147 VARCHAR(9)
          l_part4	LIKE ima_file.ima01,       #No.FUN-680147 VARCHAR(9)
          l_part5	LIKE ima_file.ima01,       #No.FUN-680147 VARCHAR(9)
          l_part12	LIKE ima_file.ima01,       #No.FUN-680147 VARCHAR(5)	# 特殊修改,不根據參數取位
          l_part22	LIKE ima_file.ima01,       #No.FUN-680147 VARCHAR(9)
          l_right	LIKE ima_file.ima01,       #No.FUN-680147 VARCHAR(1)
          l1,l2,l3,l4,l5	LIKE ima_file.ima16       #No.FUN-680147 SMALLINT
 
   WHENEVER ERROR CALL cl_err_msg_log
 
#  LET l1=4 LET l2=1 LET l3=4 LET l4=3 LET l5=3
   SELECT sma601,sma602,sma603,sma604,sma605,sma609
     INTO l1,l2,l3,l4,l5,l_right
     FROM sma_file WHERE sma00 = '0'
 
   LET p_row = 7 LET p_col = 30
   OPEN WINDOW s_inp5_w AT p_row,p_col WITH FORM "sub/42f/s_inp5"
   ATTRIBUTE( STYLE = g_win_style )
 
   CALL cl_ui_locale("s_inp5")
 
   LET l_part1=l_part[1            ,l1]
   LET l_part2=l_part[l1+1         ,l1+l2]
   LET l_part3=l_part[l1+l2+1      ,l1+l2+l3]
   LET l_part4=l_part[l1+l2+l3+1   ,l1+l2+l3+l4]
   LET l_part5=l_part[l1+l2+l3+l4+1,l1+l2+l3+l4+l5]
   LET l_part12=l_part[1            ,5]
   LET l_part22=l_part[6            ,15]
   INPUT BY NAME l_part1,l_part2,l_part3,l_part4,l_part5 WITHOUT DEFAULTS
      AFTER FIELD l_part1
         IF l_part1 IS NULL THEN NEXT FIELD l_part1 END IF
         IF l_right = 'Y' THEN
            CALL s_inp5_shift(l_part1,l1) RETURNING l_part1
            DISPLAY BY NAME l_part1
         END IF
      AFTER FIELD l_part2
         IF l_part2 IS NULL THEN NEXT FIELD l_part2 END IF
         IF l_right = 'Y' THEN
            CALL s_inp5_shift(l_part2,l2) RETURNING l_part2
            DISPLAY BY NAME l_part2
         END IF
      AFTER FIELD l_part3
         IF l_part3 IS NULL THEN NEXT FIELD l_part3 END IF
         IF l_right = 'Y' THEN
            CALL s_inp5_shift(l_part3,l3) RETURNING l_part3
            DISPLAY BY NAME l_part3
         END IF
      AFTER FIELD l_part4
         IF l_part4 IS NULL THEN NEXT FIELD l_part4 END IF
         IF l_right = 'Y' THEN
            CALL s_inp5_shift(l_part4,l4) RETURNING l_part4
            DISPLAY BY NAME l_part4
         END IF
      AFTER FIELD l_part5
         IF l_part5 IS NULL THEN NEXT FIELD l_part5 END IF
         IF l_right = 'Y' THEN
            CALL s_inp5_shift(l_part5,l5) RETURNING l_part5
            DISPLAY BY NAME l_part5
         END IF
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   
   END INPUT
   IF NOT INT_FLAG
      THEN LET l_part =l_part1[1,l1], l_part2[1,l2], l_part3[1,l3],
                       l_part4[1,l4], l_part5[1,l5]
      ELSE LET INT_FLAG = 0
           INPUT BY NAME l_part12,l_part22 WITHOUT DEFAULTS
                 AFTER FIELD l_part22
                    IF l_part22 IS NULL THEN NEXT FIELD l_part22 END IF
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE INPUT
           
           END INPUT
           IF INT_FLAG
              THEN LET INT_FLAG = 0
              ELSE LET l_part =l_part12[1,5],l_part22
           END IF
   END IF
   CLOSE WINDOW s_inp5_w 
   RETURN l_part
END FUNCTION
 
FUNCTION s_inp5_shift(p_buf,p_len)
   DEFINE p_buf		LIKE ima_file.ima23,          #No.FUN-680147 VARCHAR(10)
          p_len		LIKE type_file.num5,          #No.FUN-680147 SMALLINT
          l_buf		LIKE type_file.chr50,         #No.FUN-680147 VARCHAR(10)
          l_len		LIKE type_file.num5           #No.FUN-680147 SMALLINT
 
   LET l_len = LENGTH(p_buf)
   LET l_buf = ' '
   LET l_buf[p_len-l_len+1,p_len]=p_buf
   RETURN l_buf
END FUNCTION
