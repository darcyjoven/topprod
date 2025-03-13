# Prog. Version..: '5.30.06-13.03.28(00002)'     #
#
# Library name...: cl_say
# Descriptions...: 將金額類數值轉換成 SAY TOTAL
# Usage .........: call cl_say(p_amt,p_len) RETURNING l_say1,l_say2
# Date & Author..: 90/04/13 By LYS
# Modify.........: 05/01/18 alex 修正19的英文拼法
# Modify.........: No.MOD-590105 05/09/08 saki 修正14的英文拼法
# Modify.........: No.MOD-590423 09/09/23 alex 改寫為 Genero 版作法
# Modify.........: No.FUN-690005 06/09/05 By chen 類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-810007 08/01/16 By Sarah 當金額為15,800這樣子的金額的話，後面的800會轉不出來
# Modify.........: No.MOD-830123 08/03/14 By Claire 當金額為112,050這樣子的金額的話，後面的050會轉不出來
# Modify.........: No.FUN-B50108 11/05/18 By Kevin 維護function的資訊(p_findfunc)
# Modify.........: No.CHI-D30011 13/03/21 By Elise 將DOLLAR拿掉
 
DATABASE ds        #No.FUN-690005
 
DEFINE pc_word     DYNAMIC ARRAY OF RECORD   #FUN-7C0053
          unit     STRING,
          teen     STRING,
          tenth    STRING,
          large    STRING
               END RECORD
 
# FUN-B50108 add
##################################################
# Descriptions...: 將金額類數值轉換成 SAY TOTAL
# Input Parameter: p_amt (Decimal value of money)
#                  p_len (String length of SAY1 and SAY2)
# Return code....: l_say1 (Say total string-1 of p_amt)
#                  l_say2 (Say total string-2 of p_amt)
# Usage..........: 
# Memo...........:
##################################################

FUNCTION cl_say(pi_amt,pi_length)
   DEFINE pi_amt      LIKE ofb_file.ofb14           #No.FUN-690005  DEC(21,2)
   DEFINE pi_cnt      LIKE type_file.num5             #No.FUN-690005  SMALLINT
   DEFINE pi_length   LIKE type_file.num5             #No.FUN-690005  SMALLINT
   DEFINE ps_amt      STRING  
   DEFINE pi_lagidx   LIKE type_file.num5             #No.FUN-690005  SMALLINT
   DEFINE pi_idx      LIKE type_file.num5             #No.FUN-690005  SMALLINT
   DEFINE pc_cent     LIKE type_file.chr2             #No.FUN-690005  VARCHAR(2)
   DEFINE pc_part     LIKE type_file.chr3             #No.FUN-690005  VARCHAR(3)
   DEFINE ps_part     STRING
   DEFINE ps_str1     STRING
   DEFINE ptk_tk1     base.StringTokenizer
   DEFINE pi_ac      LIKE type_file.num5               #No.FUN-690005                   SMALLINT
   DEFINE pc_ret1,pc_ret2 LIKE type_file.chr1000          #No.FUN-690005  VARCHAR(80)
 
   CALL pc_word.clear()
   LET ps_str1="" 
   IF pi_length IS NULL OR pi_length = " " OR pi_length > 80 THEN
      LET pi_length = 80
   END IF
 
   LET pc_word[1].unit= "ONE"         LET pc_word[1].teen= "ELEVEN"
   LET pc_word[2].unit= "TWO"         LET pc_word[2].teen= "TWELVE"
   LET pc_word[3].unit= "THREE"       LET pc_word[3].teen= "THIRTEEN"
   LET pc_word[4].unit= "FOUR"        LET pc_word[4].teen= "FOURTEEN"
   LET pc_word[5].unit= "FIVE"        LET pc_word[5].teen= "FIFTEEN"
   LET pc_word[6].unit= "SIX"         LET pc_word[6].teen= "SIXTEEN"
   LET pc_word[7].unit= "SEVEN"       LET pc_word[7].teen= "SEVENTEEN"
   LET pc_word[8].unit= "EIGHT"       LET pc_word[8].teen= "EIGHTEEN"
   LET pc_word[9].unit= "NINE"        LET pc_word[9].teen= "NINETEEN"
 
   LET pc_word[1].tenth= "TEN"        LET pc_word[1].large= "HUNDRED"
   LET pc_word[2].tenth= "TWENTY"     LET pc_word[2].large= "THOUSAND"
   LET pc_word[3].tenth= "THIRTY"     LET pc_word[3].large= "MILLION"
   LET pc_word[4].tenth= "FORTY"      LET pc_word[4].large= "BILLION"
   LET pc_word[5].tenth= "FIFTY"      LET pc_word[5].large= "TRILLION"
   LET pc_word[6].tenth= "SIXTY"      LET pc_word[6].large= "QUADRILLION" 
   LET pc_word[7].tenth= "SEVENTY"    LET pc_word[7].large= "QUINTILLION"
   LET pc_word[8].tenth= "EIGHTY"     LET pc_word[8].large= "SEXTILLION"
   LET pc_word[9].tenth= "NINETY"     LET pc_word[9].large= "SEPTILLION"
 
   LET ps_amt = pi_amt USING "###,###,###,###,###,###,##&.##"
   LET ps_amt = ps_amt.trim()
   LET pc_cent = ps_amt.subString(ps_amt.getIndexOf(".",1)+1,ps_amt.getLength())
   LET ps_amt  = ps_amt.subString(1,ps_amt.getIndexOf(".",1)-1)
   LET pi_lagidx = 1  LET pi_idx=0
   WHILE TRUE
     IF ps_amt.getIndexOf(",",pi_idx+1) THEN
        LET pi_idx = ps_amt.getIndexOf(",",pi_idx+1)
        LET pi_lagidx = pi_lagidx + 1
     ELSE
        EXIT WHILE
     END IF
   END WHILE
   LET ptk_tk1 = base.StringTokenizer.create(ps_amt,",")
   WHILE ptk_tk1.hasMoreTokens()
      LET pc_part = ptk_tk1.nextToken()
      CALL cl_say_chk3(pc_part) RETURNING ps_part
      IF ps_part IS NULL OR ps_part.trim() = " " THEN
         CONTINUE WHILE
      END IF
      IF ps_str1.getLength() = 0 THEN
         IF pi_lagidx > 1 THEN
            LET ps_str1 = ps_part," ",pc_word[pi_lagidx].large.trim()
         ELSE
            LET ps_str1 = ps_part.trim()
         END IF
      ELSE IF pi_lagidx > 1 THEN
              LET ps_str1 = ps_str1.trim(),",",ps_part.trim()," ",pc_word[pi_lagidx].large.trim()
           ELSE
              LET ps_str1 = ps_str1.trim(),",",ps_part.trim()
           END IF
      END IF
      LET pi_lagidx = pi_lagidx - 1
   END WHILE
   IF pc_cent[1,1]='0' AND pc_cent[2,2]='0' THEN
     #LET ps_str1 = ps_str1.trim()," DOLLAR ONLY" #CHI-D30011 mark
      LET ps_str1 = ps_str1.trim()," ONLY"        #CHI-D30011
   ELSE
      CALL cl_say_chk2(pc_cent,1) RETURNING ps_part
     #LET ps_str1 = ps_str1.trim()," DOLLAR AND ",ps_part.trim()," CENTS ONLY" #CHI-D30011 mark
      LET ps_str1 = ps_str1.trim()," AND ",ps_part.trim()," CENTS ONLY"        #CHI-D30011
   END IF
 
   IF ps_str1.getLength() <= pi_length THEN
      LET pc_ret1 = ps_str1.trim()
   ELSE
      LET pi_idx = ps_str1.getIndexOf(" ",pi_length - 10 )
      LET pc_ret1 = ps_str1.subString(1,pi_idx - 1)
      LET pc_ret2 = ps_str1.subString(pi_idx + 1, ps_str1.getLength())
   END IF
 
   RETURN pc_ret1,pc_ret2
END FUNCTION
 
# Private Func...: TRUE                #FUN-B50108
# Descriptions...: 
# Input parameter: pc_part
# Return code....: ps_str1
 
FUNCTION cl_say_chk3(pc_part)
 
   DEFINE pc_part   LIKE type_file.chr3             #No.FUN-690005  VARCHAR(3)
   DEFINE pi_ac     LIKE type_file.num5             #No.FUN-690005  SMALLINT
   DEFINE ps_str1,ps_str2  STRING
 
   LET ps_str1="" LET ps_str2=""
   IF pc_part[3,3] is not null AND pc_part[3,3] <> " " THEN
      LET pi_ac = pc_part[1,1]
      IF pi_ac <> 0 THEN
         LET ps_str1 = pc_word[pi_ac].unit.trim()
         LET ps_str1 = ps_str1," ",pc_word[1].large.trim()
      END IF
      CALL cl_say_chk2(pc_part[2,3],0) RETURNING ps_str2
      IF cl_null(ps_str2) THEN LET ps_str2 = " " END IF   #TQC-810007 add
      IF cl_null(ps_str1) THEN LET ps_str1 = " " END IF   #MOD-830123 add
      LET ps_str1 = ps_str1.trim()||" "||ps_str2.trim()
   ELSE
      IF pc_part="000" THEN
         RETURN NULL
      END IF
      CALL cl_say_chk2(pc_part[1,2],0) RETURNING ps_str2
      IF cl_null(ps_str2) THEN LET ps_str2 = " " END IF   #TQC-810007 add
      LET ps_str1 = ps_str2.trim()
   END IF
 
   RETURN ps_str1
 
END FUNCTION
 
# Private Func...: TRUE
# Descriptions...: 
# Input parameter: pc_part, pi_type
# Return code....: ps_str1
 
FUNCTION cl_say_chk2(pc_part,pi_type)
 
   DEFINE ps_str1   STRING
   DEFINE pc_part   LIKE type_file.chr2           #No.FUN-690005  VARCHAR(2)
   DEFINE pi_ac     LIKE type_file.num5           #No.FUN-690005  SMALLINT
   DEFINE pi_type   LIKE type_file.num5           #No.FUN-690005  SMALLINT
 
   LET ps_str1="" 
   IF pc_part[2,2] is not null AND pc_part[2,2] <> " " THEN
      IF pi_type AND pc_part[1,1] = '0' THEN
         LET pi_ac = pc_part[2,2]
         LET ps_str1 = pc_word[pi_ac].unit.trim()
         RETURN ps_str1.trim()
      END IF
      IF pc_part[1,1] = '1' THEN
         IF pc_part[2,2] <> '0' THEN
            LET pi_ac = pc_part[2,2]
            LET ps_str1 = pc_word[pi_ac].teen.trim()
         ELSE
            LET ps_str1 = pc_word[1].tenth.trim()
         END IF
         RETURN ps_str1.trim()
      ELSE
         LET pi_ac = pc_part[1,1]
         IF pi_ac <> 0 THEN
            LET ps_str1 = pc_word[pi_ac].tenth.trim()
         END IF
         IF pc_part[2,2] <> "0" THEN
            LET pi_ac = pc_part[2,2]
            IF ps_str1 IS NULL THEN
               LET ps_str1 = " AND ",pc_word[pi_ac].unit.trim()
            ELSE
               LET ps_str1 = ps_str1,'-',pc_word[pi_ac].unit.trim()
            END IF
         END IF
         RETURN ps_str1.trim()
      END IF
   ELSE
      LET pi_ac = pc_part[1,1]
      IF pi_ac = 0 THEN
         LET ps_str1 = "ZERO"
      ELSE
         LET ps_str1 = pc_word[pi_ac].unit.trim()
      END IF
      RETURN ps_str1.trim()
   END IF
END FUNCTION
 
 
#FUNCTION cl_say2(p_amt,p_len)
#   DEFINE p_amt,x      LIKE ecb_file.ecb18,          #No.FUN-690005 	DECIMAL(14,2)
#          p_len,i	LIKE type_file.num5,          #No.FUN-690005    SMALLINT
#          n1,n2,n3,n4,n5,n6,n7,n8,n9,m1,m2   LIKE type_file.num5,             #No.FUN-690005	SMALLINT
#          a ARRAY[20] of     LIKE bnb_file.bnb06,           #No.FUN-690005 VARCHAR(20)
#          b ARRAY[10] of     LIKE bnb_file.bnb06,           #No.FUN-690005 VARCHAR(20)
#          l_chr 		LIKE type_file.chr1,          #No.FUN-690005
#          l_say		LIKE type_file.chr1000,          #No.FUN-690005 VARCHAR(220)
#          l_say1,l_say2	LIKE nab_file.nab03              #No.FUN-690005 VARCHAR(80)
#
#   LET a[1]= "ONE"
#   LET a[2]= "TWO"
#   LET a[3]= "THREE"
#   LET a[4]= "FOUR"
#   LET a[5]= "FIVE"
#   LET a[6]= "SIX"
#   LET a[7]= "SEVEN"
#   LET a[8]= "EIGHT"
#   LET a[9]= "NINE"
#   LET a[10]= "TEN"
#   LET a[11]= "ELEVEN"
#   LET a[12]= "TWELVE"
#   LET a[13]= "THIRTEEN"
##  LET a[14]= "FORTEEN"
#   LET a[14]= "FOURTEEN"        #No.MOD-590105
#   LET a[15]= "FIFTEEN"
#   LET a[16]= "SIXTEEN"
#   LET a[17]= "SEVENTEEN"
#   LET a[18]= "EIGHTEEN"
# #  MOD-510024
##  LET a[19]= "NINTEEN"
#   LET a[19]= "NINETEEN"
#
#   LET b[1]= "TEN"
#   LET b[2]= "TWENTY"
#   LET b[3]= "THIRTY"
#   LET b[4]= "FORTY"
#   LET b[5]= "FIFTY"
#   LET b[6]= "SIXTY"
#   LET b[7]= "SEVENTY"
#   LET b[8]= "EIGHTY"
#   LET b[9]= "NINETY"
#
#   WHILE TRUE
#      LET x=p_amt
#      LET n9=  x/100000000
#      LET x=x-n9*100000000
#      LET n8=  x/10000000
#      LET x=x-n8*10000000
#      LET n7=  x/1000000
#      LET x=x-n7*1000000
#      LET n6=  x/100000
#      LET x=x-n6*100000
#      LET n5=  x/10000
#      LET x=x-n5*10000
#      LET n4=  x/1000
#      LET x=x-n4*1000
#      LET n3=  x/100
#      LET x=x-n3*100
#      LET n2=  x/10
#      LET x=x-n2*10
#      LET n1=  x/1
#      LET x=x-n1*1
#      LET m2=  x*10
#      LET x=x-m2*0.1
#      LET m1=  x*100
#
#      let l_say=''	# ex:
##9,8,7
#      if n9>0
#         then let i=n9 let l_say=l_say clipped,' ',a[i] clipped,' HUNDRED'
#			# ex: TWO HUNDRED
#      end if
#      let i=n8*10 + n7
#      if i>10 and i<20
#         then let i=i let l_say=l_say clipped,' ',a[i]
#			# ex: TWO HUNDRED SEVENTEEN
#         else if n8 > 0 then let i=n8 let l_say=l_say clipped,' ',b[i] end if
#              if n7 > 0 then let i=n7 let l_say=l_say clipped,' ',a[i] end if
#			# ex: TWO HUNDRED SEVENTY FIVE
#      end if
#      if n9>0 or n8>0 or n7>0
#         then let l_say=l_say clipped,' MILLION'
#      end if
##ex:TWO HUNDRED SEVENTEEN MILLION
##6,5,4
#      if n6>0
#         then let i=n6
#              let l_say=l_say clipped,' ',a[i] clipped,' HUNDRED'
#      end if
#      let i=n5*10 + n4
#      if i>10 and i<20
#         then let i=i let l_say=l_say clipped,' ',a[i]
#         else if n5 > 0 then let i=n5 let l_say=l_say clipped,' ',b[i] end if
#              if n4 > 0 then let i=n4 let l_say=l_say clipped,' ',a[i] end if
#      end if
#      if n6>0 or n5>0 or n4>0
#         then let l_say=l_say clipped,' THOUSAND'
#      end if
##ex:TWO HUNDRED SEVENTEEN MILLION FIVE HUNDRED FORTY ONE THOUSAND
##3,2,1
#      if n3>0
#         then let i=n3
#              let l_say=l_say clipped,' ',a[i] clipped,' HUNDRED'
#      end if
#      let i=n2*10 + n1
#      if i>10 and i<20
#         then let i=i let l_say=l_say clipped,' ',a[i]
#         else if n2 > 0 then let i=n2 let l_say=l_say clipped,' ',b[i] end if
#              if n1 > 0 then let i=n1 let l_say=l_say clipped,' ',a[i] end if
#      end if
##ex:TWO HUNDRED SEVENTEEN MILLION FIVE HUNDRED FORTY ONE THOUSAND SIX HUNDRED
##   NINETY FIVE
##m2,m1
#      if m2>0 or m1>0
#         then let l_say=l_say clipped,' AND CENTS'
#      end if
#      let i=m2*10+m1
#      if i>10 and i<20
#         then let i=i let l_say=l_say clipped,' ',a[i]
#         else if m2 > 0 then let i=m2 let l_say=l_say clipped,' ',b[i] end if
#              if m1 > 0 then let i=m1 let l_say=l_say clipped,' ',a[i] end if
#      end if
##tail
#      let l_say=l_say clipped,' ONLY'
##ex:TWO HUNDRED SEVENTEEN MILLION FIVE HUNDRED FORTY ONE THOUSAND SIX HUNDRED
##   NINETY FIVE AND CENTS FIFTY ONLY
##     prompt 'l_say:',l_say clipped for l_chr
#      FOR i = p_len TO p_len-20 STEP -1
#         IF cl_null(l_say[i,i]) THEN EXIT FOR END IF
#      END FOR
#      LET l_say1=l_say[1,i]
#      LET l_say2=l_say[i+1,p_len*2]
#      RETURN l_say1,l_say2
#   END WHILE
#END FUNCTION
