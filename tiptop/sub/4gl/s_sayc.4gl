# Prog. Version..: '5.30.06-13.04.02(00006)'     #
#
# Program name...: s_sayc.4gl
# Descriptions...: 將金額類數值轉換成中文字
# Date & Author..: 92/05/07 by May
# Usage..........: CALL s_sayc(p_amt,p_len) RETURNING l_say
# Input Parameter:  p_amt   LIKE type_file.num20_6
#                   p_len   String length of SAY1
# RETURN Code....:  l_say   國字數字說明
# Modify.........: No.TQC-610008 06/01/04 alex 放大接字的 ARRAY 為 STRING
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-950024 09/09/25 By hongmei 國字數字改由p_ze抓，不寫死
# Modify.........: No:MOD-A10131 10/01/21 By Carrier "叁"字修改正确
# Modify.........: No:MOD-A30003 10/04/08 By wujie   若传入数值是0，则直接返回零
# Modify.........: No:MOD-BC0206 11/12/20 By Dido 此函式不須要處理 MOD-A30003 問題
# Modify.........: No:MOD-D30270 13/04/01 By Alberti  sub-129 改用 sub-130
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_sayc(p_amt,p_len)
   DEFINE p_amt		LIKE type_file.num10,         #No.FUN-680147 INTEGER
          x             LIKE smh_file.smh01,          #No.FUN-680147 VARCHAR(9)
          p_len,i	LIKE type_file.num5,          #No.FUN-680147 SMALLINT
          n1,n2,n3,n4,n5,n6,n7,n8,n9,m1,m2	LIKE type_file.num5,          #No.FUN-680147 SMALLINT
          a ARRAY[10] of       STRING,          #TQC-610008 VARCHAR(2),
          l_say                STRING           #TQC-610008 VARCHAR(100)
   #FUN-950024---add---str
   DEFINE l_yy                 LIKE type_file.chr10                  
   DEFINE l_i                  LIKE type_file.num5                   
   DEFINE l_a                  LIKE type_file.chr30 
   #FUN-950024---add---end
   
   #FUN-950024---add---str---
   FOR l_i = 1 TO 9 
       CASE l_i
            WHEN '1'         
                 LET l_yy = 'sub-119'
            WHEN '2'         
                 LET l_yy = 'sub-120'
            WHEN '3'         
                 LET l_yy = 'sub-121'
            WHEN '4'         
                 LET l_yy = 'sub-122'
            WHEN '5'         
                 LET l_yy = 'sub-123'
            WHEN '6'         
                 LET l_yy = 'sub-124'
            WHEN '7'         
                 LET l_yy = 'sub-125'
            WHEN '8'         
                 LET l_yy = 'sub-126'
            WHEN '9'         
                 LET l_yy = 'sub-127'
       END CASE 
       CALL s_sayc_1(l_yy) RETURNING l_a
       LET a[l_i] = l_a
   END FOR 
   #FUN-950024---add---end---
   
  #FUN-950024---mark---str---
  #LET a[1]="壹" LET a[2]="貳" LET a[3]="叁" LET a[4]="肆" LET a[5]="伍"  #No.MOD-A10131
  #LET a[6]="陸" LET a[7]="柒" LET a[8]="捌" LET a[9]="玖"
  #FUN-950024---mark---end--- 
  
#No.MOD-A30003 --begin                                                          
  #-MOD-BC0206-mark-
  #IF p_amt =0 THEN                                                             
  #   LET l_say = a[12] CLIPPED,a[19] CLIPPED,a[17] CLIPPED                     
  #   RETURN l_say                                                              
  #END IF                                                                       
  #-MOD-BC0206-end-
#No.MOD-A30003 --end
   IF p_amt > '999999999' THEN LET l_say='unknown' RETURN l_say END IF
   LET x=p_amt USING '&&&&&&&&&'
   LET n9=x[1,1] LET n8=x[2,2] LET n7=x[3,3] LET n6=x[4,4] LET n5=x[5,5]
   LET n4=x[6,6] LET n3=x[7,7] LET n2=x[8,8] LET n1=x[9,9]   
   let l_say=''	# ex:
#-----------------------------------------------------------------------------
#FUN-950024---mark---str---
#  IF n9>0 THEN LET l_say = a[n9],'億' END IF
#-----------------------------------------------------------------------------
#  IF n8 > 0 THEN LET l_say = l_say CLIPPED,a[n8],'仟' END IF
#  IF x[1,1]!='0' AND x[2,2]='0' AND x[3,5]!='000'
#            THEN LET l_say = l_say CLIPPED,'零' END IF
#  IF n7 > 0 THEN LET l_say = l_say CLIPPED,a[n7],'佰' END IF
#  IF x[2,2]!='0' AND x[3,3]='0' AND x[4,5]!='00'
#            THEN LET l_say = l_say CLIPPED,'零' END IF
#  IF n6 > 0 THEN LET l_say = l_say CLIPPED,a[n6],'拾' END IF
#  IF x[3,3]!='0' AND x[4,4]='0' AND x[5,5]!='0'
#            THEN LET l_say = l_say CLIPPED,'零' END IF
#  IF n5 > 0 THEN LET l_say = l_say CLIPPED,a[n5]      END IF
#  IF x[2,5] != '0000' THEN LET l_say = l_say CLIPPED,'萬' END IF
#-----------------------------------------------------------------------------
#  IF n4 > 0 THEN LET l_say = l_say CLIPPED,a[n4],'仟' END IF
#  IF x[1,5]!='00000' AND x[6,6]='0' AND x[7,9]!='000'
#            THEN LET l_say = l_say CLIPPED,'零' END IF
#  IF n3 > 0 THEN LET l_say = l_say CLIPPED,a[n3],'佰' END IF
#  IF x[6,6]!='0' AND x[7,7]='0' AND x[8,9]!='00'
#            THEN LET l_say = l_say CLIPPED,'零' END IF
#  IF n2 > 0 THEN LET l_say = l_say CLIPPED,a[n2],'拾' END IF
#  IF x[7,7]!='0' AND x[8,8]='0' AND x[9,9]!='0'
#            THEN LET l_say = l_say CLIPPED,'零' END IF
#  IF n1 > 0 THEN LET l_say = l_say CLIPPED,a[n1]      END IF
#  LET l_say = l_say CLIPPED,'元整'
#FUN-950024---mark---end---
 
#FUN-950024---mod---str---
   IF n9 > 0 THEN LET l_yy = 'sub-128' 
                  CALL s_sayc_1(l_yy) RETURNING l_a
                  LET l_say = a[n9], l_a
   END IF
 
   IF n8 > 0 THEN LET l_yy = 'sub-129' 
                  CALL s_sayc_1(l_yy) RETURNING l_a
                  LET l_say = l_say CLIPPED,a[n8], l_a
   END IF
 
   IF x[1,1]!='0' AND x[2,2]='0' AND x[3,5]!='000' THEN 
                 #LET l_yy = 'sub-129'      #MOD-D30270 mark
                  LET l_yy = 'sub-130'      #MOD-D30270
                  CALL s_sayc_1(l_yy) RETURNING l_a
                  LET l_say = l_say CLIPPED, l_a 
   END IF
 
   IF n7 > 0 THEN LET l_yy = 'sub-132' 
                  CALL s_sayc_1(l_yy) RETURNING l_a
                  LET l_say = l_say CLIPPED,a[n7], l_a 
   END IF
 
   IF x[2,2]!='0' AND x[3,3]='0' AND x[4,5]!='00' THEN
                  LET l_yy = 'sub-130' 
                  CALL s_sayc_1(l_yy) RETURNING l_a
                  LET l_say = l_say CLIPPED, l_a 
   END IF
 
   IF n6 > 0 THEN LET l_yy = 'sub-133' 
                  CALL s_sayc_1(l_yy) RETURNING l_a
                  LET l_say = l_say CLIPPED,a[n6], l_a 
   END IF
 
   IF x[3,3]!='0' AND x[4,4]='0' AND x[5,5]!='0' THEN 
                  LET l_yy = 'sub-130' 
                  CALL s_sayc_1(l_yy) RETURNING l_a
                  LET l_say = l_say CLIPPED, l_a
   END IF
 
   IF n5 > 0 THEN LET l_say = l_say CLIPPED,a[n5] END IF
 
   IF x[2,5] != '0000' THEN 
                  LET l_yy = 'sub-131' 
                  CALL s_sayc_1(l_yy) RETURNING l_a
                  LET l_say = l_say CLIPPED, l_a 
   END IF
 
   IF n4 > 0 THEN LET l_yy = 'sub-129' 
                  CALL s_sayc_1(l_yy) RETURNING l_a
                  LET l_say = l_say CLIPPED,a[n4], l_a
   END IF
 
   IF x[1,5]!='00000' AND x[6,6]='0' AND x[7,9]!='000' THEN 
                  LET l_yy = 'sub-130' 
                  CALL s_sayc_1(l_yy) RETURNING l_a
                  LET l_say = l_say CLIPPED,l_a 
   END IF
 
   IF n3 > 0 THEN LET l_yy = 'sub-132' 
                  CALL s_sayc_1(l_yy) RETURNING l_a
                  LET l_say = l_say CLIPPED,a[n3], l_a 
   END IF
 
   IF x[6,6]!='0' AND x[7,7]='0' AND x[8,9]!='00' THEN 
                  LET l_yy = 'sub-130' 
                  CALL s_sayc_1(l_yy) RETURNING l_a
                  LET l_say = l_say CLIPPED, l_a
   END IF
 
   IF n2 > 0 THEN LET l_yy = 'sub-133' 
                  CALL s_sayc_1(l_yy) RETURNING l_a
                  LET l_say = l_say CLIPPED,a[n2], l_a 
   END IF
 
   IF x[7,7]!='0' AND x[8,8]='0' AND x[9,9]!='0' THEN 
                  LET l_yy = 'sub-130' 
                  CALL s_sayc_1(l_yy) RETURNING l_a
                  LET l_say = l_say CLIPPED, l_a 
   END IF
   IF n1 > 0 THEN LET l_say = l_say CLIPPED,a[n1] END IF
 
   LET l_yy = 'sub-168' 
   CALL s_sayc_1(l_yy) RETURNING l_a
   LET l_say = l_say CLIPPED, l_a
 
#FUN-950024---mod---end---
   RETURN l_say
END FUNCTION
 
#FUN-950024---add---str---
FUNCTION s_sayc_1(p_yy)
 
   DEFINE l_sql                STRING                                
   DEFINE p_yy                 LIKE type_file.chr10                  
   DEFINE l_aa                 LIKE type_file.chr30                  
 
   LET l_sql ="SELECT ze03 FROM ze_file ",
              " WHERE ze01 = ? ",
              "   AND ze02 = ",g_lang CLIPPED
 
   DECLARE s_cur CURSOR FROM l_sql
 
   OPEN s_cur USING p_yy 
   IF STATUS THEN
      CALL cl_err("OPEN s_cur:", STATUS, 1)
   ELSE  
      FETCH s_cur INTO l_aa
      IF SQLCA.sqlcode THEN
         CALL cl_err(p_yy,SQLCA.sqlcode,1)
      END IF
      IF cl_null(l_aa) THEN LET l_aa=''  END IF
   END IF
 
   CLOSE s_cur
 
   RETURN l_aa
 
END FUNCTION
#FUN-950024---add---end---
