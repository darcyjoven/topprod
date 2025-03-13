# Prog. Version..: '5.30.07-13.05.16(00007)'     #
#
# Program name...: cl_wcchp.4gl
# Descriptions...: WC 內重要字句中文化 (Changing pattern in p_wc)
# Input Parameter: p_wc LIKE type_file.chr1000   # Where condition        #No.FUN-690005
#                  p_oldp VARCHAR(60)   # Pattern (column list) to be changed
# Return Code....: p_newwc VARCHAR(300) # New where condition after changed
# Usage .........: call cl_wcchp(p_wc,p_oldp) returning p_wc
#                  ex:  cl_wcchp(l_wc,'gca01,gca02,gca03,gca09,gca30')
#                               returning p_wc
# Date & Author..: 92/03/06 By LYS
# Modify.........: No.MOD-590388 05/09/20 alex disable about zq_file
# Modify.........: No.FUN-690005 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-950122 09/05/20 By xiaofeizhu 修改同一個詞出現第二次的時候，第二次會沒有辦法做置換的問題
# Modify.........: No.TQC-960172 09/06/22 By liuxqa 當l_gaq03為空時，會造成死循環。
# Modify.........: No:CHI-A40051 10/04/26 By jay cl_wcchp returning null trouble
# Modify.........: No:CHI-950008 12/05/16 By jacklai QBE太長導致報表失敗,規範當回回傳值大於500即回傳空值
# Modify.........: No:FUN-C50104 12/05/24 By jacklai 列印選擇條件回傳值大於500改為截掉501以後內容,並附加說明
# Modify.........: No:FUN-CA0154 12/11/02 By odyliao 調整邏輯以符合XtraGrid抓p_xglang的標題
# Modify.........: No:FUN-CC0103 12/12/20 By odyliao 補充XtraGrid抓取邏輯，若取不到時則改取 p_feldname
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION cl_wcchp(p_wc,p_oldp)
   DEFINE p_wc          STRING,               #MOD-590388  VARCHAR(300),
          p_newwc       STRING,               #MOD-590388  VARCHAR(300),
          p_oldp        STRING,               #MOD-590388  VARCHAR(120),
          l_gaq01       LIKE gaq_file.gaq01,  #MOD-590388
          l_gaq03       LIKE gaq_file.gaq03,  #MOD-590388
          l_i1          LIKE type_file.num5   #No.FUN-690005 SMALLINT
   DEFINE lst_token     base.StringTokenizer
   DEFINE ls_token      STRING
   DEFINE l_chk_xg      LIKE type_file.chr1  #FUN-CA0154
   DEFINE l_gdr00       LIKE type_file.num5  #FUN-CA0154

   WHENEVER ERROR CALL cl_err_msg_log

   LET p_wc = p_wc.trim()          #CHI-A40051

  #FUN-CA0154-- start--
   LET l_chk_xg = 'N' 
   IF NOT cl_null(g_xgrid.table) OR NOT cl_null(g_xgrid.sql) THEN
      LET l_chk_xg = 'Y' 
      DECLARE cl_wcchp_gdr00_cs CURSOR FOR
       SELECT UNIQUE gdr00 FROM gdr_file,gds_file
        WHERE gdr01 = g_prog
          AND gdr00 = gds00
          AND gds02 = g_lang
      LET l_gdr00 = NULL
      FOREACH cl_wcchp_gdr00_cs INTO l_gdr00
         EXIT FOREACH
      END FOREACH
      IF STATUS THEN LET l_chk_xg = 'N' END IF
      IF cl_null(l_gdr00) THEN LET l_chk_xg = 'N' END IF
   ELSE
      LET l_chk_xg = 'N' 
   END IF
  #FUN-CA0154-- end--

   #IF p_wc.getLength() <= 500 THEN    ### CHI-950008 ###    
   IF p_wc.getLength() <= 500 OR l_chk_xg = 'Y' THEN    ### FUN-CC0103 add l_chk_xg ###    
      LET lst_token = base.StringTokenizer.create(p_oldp.trim(), ',')
      LET l_i1 = 1
      WHILE lst_token.hasMoreTokens()
         LET ls_token = lst_token.nextToken()
         LET l_gaq01 = ls_token.trim()
#        IF p_wc.getIndexOf(l_gaq01 CLIPPED,1) THEN              #TQC-950122 Mark
         WHILE p_wc.getIndexOf(l_gaq01 CLIPPED,1)                #TQC-950122      
  #FUN-CA0154-- start--
          # SELECT gaq03 INTO l_gaq03 FROM gaq_file
          #  WHERE gaq01=l_gaq01 AND gaq02=g_lang
            LET l_gaq03 = NULL
            IF l_chk_xg = 'Y' THEN
               SELECT gds04 INTO l_gaq03 FROM gds_file
                WHERE gds00 = l_gdr00
                  AND gds03 = l_gaq01
              #FUN-CC0103 add ---(S)
               IF cl_null(l_gaq03) THEN
                  SELECT gaq03 INTO l_gaq03 FROM gaq_file
                   WHERE gaq01=l_gaq01 AND gaq02=g_lang
               END IF
              #FUN-CC0103 add ---(E)
            ELSE
               SELECT gaq03 INTO l_gaq03 FROM gaq_file
                WHERE gaq01=l_gaq01 AND gaq02=g_lang
            END IF
  #FUN-CA0154-- end--
            IF NOT cl_null(l_gaq03) THEN
               LET p_wc=p_wc.subString(1,p_wc.getIndexOf(l_gaq01 CLIPPED,1)-1),l_gaq03 CLIPPED,p_wc.subString(p_wc.getIndexOf(l_gaq01 CLIPPED,1)+ls_token.getLength(),p_wc.getLength())
            ELSE                                 #TQC-960172 add
               EXIT WHILE                        #TQC-960172 add
            END IF
#        END IF                                                  #TQC-950122 Mark
         END WHILE                                               #TQC-950122      
      END WHILE
      ### CHI-950008 Start ###                                                  
      IF p_wc.getLength() > 500 THEN                                            
         #LET p_newwc="" #FUN-C50104
         LET p_newwc = cl_wcchp_unicut(p_wc,500) #FUN-C50104                                                         
      ELSE                                                                      
         LET p_newwc=p_wc.trim()                                                
      END IF                                                                    
   ELSE                                                                         
      #LET p_newwc="" #FUN-C50104
      LET p_newwc = cl_wcchp_unicut(p_wc,500) #FUN-C50104                                                            
   END IF                                                                       
   ### CHI-950008  End ###   
 
   RETURN p_newwc
 
END FUNCTION
 
#   DEFINE p_wc		LIKE type_file.chr1000,       #No.FUN-690005
#          p_newwc VARCHAR(300),
#          p_oldp VARCHAR(120),
#          l_zq04 VARCHAR(40),
#          l_x ARRAY[20] OF VARCHAR(10),
#          l_y ARRAY[20] OF VARCHAR(30),
#          i,i1,i2,oi,j,k,k2,x,xmax	SMALLINT,
#          l_wclen,l_oldplen,l_newplen	SMALLINT
#
#   WHENEVER ERROR CALL cl_err_msg_log
## convert input rarameter 'p_oldp' to l_x array
## Ex: p_oldp =  'gka001,gka002,gka003,gka008...... '
##     convert to l_x[1] l_x[2] l_x[3] l_x[4]....
#   LET oi = 1
#   LET xmax = 1
#   LET l_oldplen = LENGTH(p_oldp)
#   FOR i = 1 TO l_oldplen
#       IF xmax > 19 THEN EXIT FOR END IF
#       IF p_oldp[i,i]=','
#          THEN LET l_x[xmax]=p_oldp[oi,i-1]
#               LET xmax = xmax + 1
#               LET oi = i + 1
#       END IF
#   END FOR
#   LET l_x[xmax]=p_oldp[oi,i]
#   FOR i = 1 TO xmax
#       SELECT zq04 INTO l_zq04 FROM zq_file
#              WHERE zq01 = l_x[i] AND zq02 = g_lang AND zq03 = 0
#       IF SQLCA.sqlcode THEN LET l_y[i] = ' ' CONTINUE FOR END IF
#       LET i1=0
#       FOR k = 1 TO 40
#           LET l_y[i]=l_zq04    #NO:4521 
#{ 
#
#       #    IF l_zq04[k,k+1] = '●' AND i1=0 THEN
#       #       LET k=k+2
#
#           IF k < 40 THEN 
#              IF l_zq04[k,k+1] = '●' AND i1=0 THEN
#                 LET k=k+2
#                 IF k > 40 THEN EXIT FOR  END IF 
#              END IF 
#           END IF
#           IF NOT cl_null(l_zq04[k,k]) AND i1=0 THEN
#              LET i1=k
#              CONTINUE FOR
#           END IF
#           IF (cl_null(l_zq04[k,k]) OR l_zq04[k,k] = '[') AND i1!=0 THEN
#              LET i2=k
#              LET l_y[i]=l_zq04[i1,i2]
#              EXIT FOR
#           END IF
# }
#       END FOR
#   END FOR
#
## convert input rarameter 'p_wc' to 'p_newwc
#   LET p_newwc = ''
#   LET l_wclen = LENGTH(p_wc)
#   LET k = 1      
#   FOR i = 1 TO l_wclen
#      LET k = k + 1
#      FOR x = 1 TO xmax
#          LET l_oldplen = LENGTH(l_x[x])
#          LET l_newplen = LENGTH(l_y[x])
#          LET j = i + l_oldplen - 1
#          IF p_wc[i,j] = l_x[x] AND l_newplen != 0
#             THEN LET k2 = k + l_newplen - 1+1
#                  let p_newwc[k-1,k]=' ['          # '['
#                  LET p_newwc[k+1,k2]= l_y[x]
#                  let p_newwc[k2+1,k2+1]=']'       # ']'
#                  LET i = j
#                  LET k = k2+1  
#                  EXIT FOR
#             ELSE LET p_newwc[k,k] = p_wc[i,i]
#          END IF
#      END FOR
#   END FOR
#   RETURN p_newwc
#END FUNCTION

#FUN-C50104 --start--
############################################################
# Descriptions...: 將Unicode字串超過保留的位元組大小以上的內容截掉,
#                  Unicode字串邊界剛好不是保留的位元組大小時,
#                  則往前取到完整的unicode字元邊界
# Date & Author..: 
# Input Parameter: ps_wc  來源Unicode字串
#                  pi_size 
# Return code....: STRING  截掉超過保留的位元組大小後的字串
############################################################
FUNCTION cl_wcchp_unicut(ps_wc,pi_size)
   DEFINE ps_wc  	STRING
   DEFINE pi_size 	LIKE type_file.num10
   DEFINE li_pos  	LIKE type_file.num10
   DEFINE li_endpos  LIKE type_file.num10 #新字串的結尾位置
   DEFINE li_i    	LIKE type_file.num10
   DEFINE li_charlen LIKE type_file.num10
   DEFINE ls_char    STRING
   DEFINE ls_wc  	STRING
   DEFINE li_charmax LIKE type_file.num10	#UTF-8字元最大位元組數
   DEFINE li_chkpos 	LIKE type_file.num10
   DEFINE ls_lang 	STRING
   DEFINE li_isutf8	LIKE type_file.num5

   LET li_isutf8 = FALSE
   LET ls_lang = DOWNSHIFT(FGL_GETENV("LANG"))
   IF ls_lang.getIndexOf("utf8",1) > 0 OR ls_lang.getIndexOf("utf-8",1) > 0 THEN
      LET li_isutf8 = TRUE
   END IF

   IF ps_wc.getLength() <= pi_size THEN
      LET ls_wc = ps_wc
   ELSE
      IF li_isutf8 THEN
         LET li_charmax = 4   
         LET li_chkpos = pi_size - li_charmax + 1
         LET ls_wc = NULL
         LET li_pos = 0
         IF pi_size > 0 AND li_chkpos > 0 THEN
            FOR li_i = pi_size TO li_chkpos STEP -1
               LET ls_char = ps_wc.getCharAt(li_i)
               LET li_charlen = ls_char.getLength()
               
               LET li_pos = li_i
               #找出最後一個多位元組Unicode字元的位置
               IF li_charlen > 1 THEN
                  EXIT FOR
               END IF
            END FOR

            #結尾unicode字元被截掉, 取這個字元的前一個位置做為字串結尾
            IF li_pos + li_charlen > pi_size THEN
               LET li_endpos = li_pos - 1
            ELSE	#結尾的unicode字元未被截掉, 取這個字元為字串結尾
               LET li_endpos = pi_size
            END IF
            
            IF li_endpos > 0 THEN
               LET ls_wc = ps_wc.subString(1,li_endpos)
            END IF

            #字串結尾加上截掉說明
            LET ls_wc = ls_wc,"(",cl_getmsg("lib-625",g_lang) CLIPPED,")"
         ELSE
            LET ls_wc = ps_wc
         END IF
      ELSE
         LET ls_wc = ""	#非unicode時, 超過特定大小即設為空字串
      END IF
   END IF

   RETURN ls_wc
END FUNCTION
#FUN-C50104 --end--
