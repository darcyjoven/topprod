# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Program name...: s_sayc2.4gl
# Descriptions...: 將金額類數值轉換成中文字(帶小數位)
# Date & Author..: 09/05/07 By Carrier #No.MOD-950052
# Usage..........: CALL s_sayc2(p_amt,p_len) RETURNING l_say
# Input Parameter: p_amt   LIKE type_file.num20_6
#                  p_len   String length of SAY1
# Return Code....: l_say   國字數字說明
# Modify.........: No.MOD-980245 09/09/03 By sabrina 兆、億、萬無法顯示出來
# Modify.........: No:MOD-A10131 10/01/21 By Carrier "叁"字修改正确
# Modify.........: No:MOD-A30003 10/04/08 By wujie   若传入数值是0，则直接返回零
# Modify.........: No:TQC-BC0175 11/12/29 By Carrier 角/分不为零时，不显示“整”
 
DATABASE ds    
 
GLOBALS "../../config/top.global" 
DEFINE g_pos1         LIKE type_file.num5          #begin position
DEFINE g_pos2         LIKE type_file.num5          #end position
 
FUNCTION s_sayc2(p_amt,p_len)   #No.MOD-950052
   DEFINE p_amt                 LIKE oeb_file.oeb14, 
	  x                     LIKE oeb_file.oeb092,
          p_len,k,l_kk          LIKE type_file.num5,
          n1,n2,n3,n4,n5,n6     LIKE type_file.num5, 
          n7,n8,n9,n10,n11,n12  LIKE type_file.num5, 
          n13,n14,n15,n21,n22  	LIKE type_file.num5,  
          a ARRAY[20] of        LIKE type_file.chr8, 
          l_say                 STRING,             
          l_err                 LIKE ze_file.ze01    
   DEFINE l_arr                 ARRAY[20] OF LIKE type_file.chr20  
   DEFINE l_i,l_j               LIKE type_file.num5
   DEFINE l_flag                LIKE type_file.chr1
 
   LET l_kk=119
   FOR k=1 TO 20
      LET l_err='sub-',l_kk USING '###'
      SELECT ze03 INTO a[k] FROM ze_file
       WHERE ze01 = l_err AND ze02 = g_lang
      LET l_kk=l_kk+1
   END FOR
 
   #LET a[1]="壹" LET a[2]="貳" LET a[3]="叁" LET a[4]="肆" LET a[5]="伍"  #No.MOD-A10131
   #LET a[6]="陸" LET a[7]="柒" LET a[8]="捌" LET a[9]="玖" 
   #LET a[10]="億" LET a[11]="仟" LET a[12]="零" LET a[13]="萬" LET a[14]="佰"
   #LET a[15]="拾" LET a[16]="角" LET a[17]="整" LET a[18]="分" LET a[19]="元"
   #LET a[20]="兆"
#No.MOD-A30003 --begin                                                          
   IF p_amt =0 THEN                                                             
      LET l_say = a[12] CLIPPED,a[19] CLIPPED,a[17] CLIPPED                     
      RETURN l_say                                                              
   END IF                                                                       
#No.MOD-A30003 --end 
 
   IF p_amt > '99999999999999.999999' THEN LET l_say='unknown' RETURN l_say END IF
   LET x=p_amt USING '&&&&&&&&&&&&&&.&&&&&&'
   
   #>=1
   LET n1=x[14,14] LET n2=x[13,13] LET n3=x[12,12] LET n4=x[11,11]
   LET n5=x[10,10] LET n6=x[9,9]   LET n7=x[8,8]   LET n8=x[7,7]
   LET n9=x[6,6]   LET n10=x[5,5]  LET n11=x[4,4]  LET n12=x[3,3]
   LET n13=x[2,2]  LET n14=x[1,1]
   
   #<1 
   LET n21=x[16,16] LET n22=x[17,17]
     
   let l_say=''	# ex:
    
   LET g_pos1 = 0
   LET g_pos2 = 0
   
   #拾兆    
   IF n14>0 THEN 
      LET l_arr[14] = a[n14] CLIPPED,a[15] CLIPPED #x拾
      CALL s_get_pos(n14,14)
   END IF    
                 
   #兆    
   IF n13>0 THEN 
      LET l_arr[13] = a[n13] CLIPPED               #x
      CALL s_get_pos(n13,13)
   END IF                 
 
  #MOD-980245---add---start---
   IF n14 >0 OR n13>0 THEN
      CALL s_get_pos(1,13)
   END IF
  #MOD-980245---add---end---
   
   #仟億   
   IF n12>0 THEN 
      LET l_arr[12] = a[n12] CLIPPED,a[11] CLIPPED #x仟
      CALL s_get_pos(n12,12)
   END IF                  
     
   #佰億   
   IF n11>0 THEN 
      LET l_arr[11] = a[n11] CLIPPED,a[14] CLIPPED #x佰  
      CALL s_get_pos(n11,11)
   END IF                 
   #拾億   
   IF n10>0 THEN 
      LET l_arr[10] = a[n10] CLIPPED,a[15] CLIPPED #x拾
      CALL s_get_pos(n10,10)
   END IF                 
   #億   
   IF n9>0  THEN 
      LET l_arr[9]  = a[n9]  CLIPPED               #x      
      CALL s_get_pos(n9,9)
   END IF                 
  
  #MOD-980245---add---start---
   IF n12 >0 OR n11>0 OR n10>0 OR n9>0 THEN
      CALL s_get_pos(1,9)
   END IF
  #MOD-980245---add---end---
 
   #千萬
   IF n8>0  THEN 
      LET l_arr[8]  = a[n8]  CLIPPED,a[11] CLIPPED #x仟 
      CALL s_get_pos(n8,8)
   END IF                   
   #佰萬   
   IF n7>0  THEN 
      LET l_arr[7]  = a[n7]  CLIPPED,a[14] CLIPPED #x佰 
      CALL s_get_pos(n7,7)
   END IF                  
   #拾萬   
   IF n6>0  THEN 
      LET l_arr[6]  = a[n6]  CLIPPED,a[15] CLIPPED #x拾
      CALL s_get_pos(n6,6)
   END IF                 
   #萬   
   IF n5>0  THEN 
      LET l_arr[5]  = a[n5]  CLIPPED               #x
      CALL s_get_pos(n5,5)
   END IF
  
  #MOD-980245---add---start---
   IF n8 >0 OR n7>0 OR n6>0 OR n5>0 THEN
      CALL s_get_pos(1,5)
   END IF
  #MOD-980245---add---end---
 
   #千
   IF n4>0  THEN 
      LET l_arr[4]  = a[n4]  CLIPPED,a[11] CLIPPED #x仟 
      CALL s_get_pos(n4,4)
   END IF                   
   #百
   IF n3>0  THEN 
      LET l_arr[3]  = a[n3]  CLIPPED,a[14] CLIPPED #x佰 
      CALL s_get_pos(n3,3)
   END IF                  
   #拾
   IF n2>0  THEN 
      LET l_arr[2]  = a[n2]  CLIPPED,a[15] CLIPPED #x拾
      CALL s_get_pos(n2,2)
   END IF                 
   #個
   IF n1>0  THEN 
      LET l_arr[1]  = a[n1]  CLIPPED               #x
      CALL s_get_pos(n1,1)
   END IF  
  
   IF g_pos1 <> 0 THEN   #first number
      LET l_say = l_arr[g_pos1] CLIPPED
      LET l_flag = 'Y'
      FOR l_i = g_pos1 - 1 TO g_pos2 - 1 STEP -1
          LET l_j = l_i + 1
          IF l_flag = 'Y' THEN
             CASE l_j
                  WHEN 13 LET l_say = l_say CLIPPED,a[20] CLIPPED LET l_flag = 'N'
                  WHEN 9  LET l_say = l_say CLIPPED,a[10] CLIPPED LET l_flag = 'N'
                  WHEN 5  LET l_say = l_say CLIPPED,a[13] CLIPPED LET l_flag = 'N'
             END CASE
          END IF
          IF l_i = g_pos2 -1 THEN EXIT FOR END IF   #處理到g_pos2就結束了
          IF NOT cl_null(l_arr[l_i]) THEN
             LET l_say = l_say CLIPPED,l_arr[l_i] CLIPPED
             LET l_flag = 'Y'
          ELSE
             IF l_i > 1 THEN
               IF NOT cl_null(l_arr[l_i-1]) AND l_i <> 13 AND l_i <> 9 AND l_i <> 5 THEN
                  LET l_say = l_say CLIPPED,a[12] 
               END IF
             END IF
          END IF     
      END FOR
      LET l_say = l_say CLIPPED,a[19] CLIPPED
   END IF   
 
   IF x[16,17] = '00' THEN 
       LET l_say = l_say CLIPPED,a[17]          #No.MOD-530069 a[17]=整
   ELSE 
      #角
      IF n21 > 0 THEN    
         LET l_say = l_say CLIPPED,a[n21]
         IF x[17,17] = '0' THEN 
             #No.TQC-BC0175  --Begin
             #LET l_say = l_say CLIPPED,a[16],a[17]    #No.MOD-530069 a[16]=角
             LET l_say = l_say CLIPPED,a[16]          #No.MOD-530069 a[16]=角
             #No.TQC-BC0175  --End  
         ELSE 
             LET l_say = l_say CLIPPED,a[16]             #No.MOD-530069
             #No.TQC-BC0175  --Begin
             #LET l_say = l_say CLIPPED,a[n22],a[18],a[17]#No.MOD-530069 a[18]=分  #No.MOD-590226 加入"整"
             LET l_say = l_say CLIPPED,a[n22],a[18]      #No.MOD-530069 a[18]=分  #No.MOD-590226 加入"整"
             #No.TQC-BC0175  --End  
         END IF
      ELSE
         IF n22 > 0 THEN                                 #No.MOD-590226 n12必須要>0才需要把分印出來
            LET l_say = l_say CLIPPED,a[12],a[16]        #No.MOD-590226 a[12]=零
            #No.TQC-BC0175  --Begin
            #LET l_say = l_say CLIPPED,a[n22],a[18],a[17] #No.MOD-530069 #No.MOD-59022
            LET l_say = l_say CLIPPED,a[n22],a[18]       #No.MOD-530069 #No.MOD-59022
            #No.TQC-BC0175  --End  
         END IF
      END IF
   END IF
   RETURN l_say
 
END FUNCTION
 
FUNCTION s_get_pos(p_n,p_pos)
   DEFINE p_n      LIKE type_file.num5
   DEFINE p_pos    LIKE type_file.num5
 
   IF p_n > 0 THEN
     IF g_pos1 = 0 THEN
        LET g_pos1 = p_pos
     END IF
     LET g_pos2 = p_pos
   END IF
  
END FUNCTION       
