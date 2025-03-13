# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: s_groupby
# Descriptions...: AXC系統的GROUP BY是變動的 ex:"SELECT ",l_title,"0,0",..
#                                               " GROUP BY 1,2,3,4 "
#                  在ORACLE如此的寫法會有問題，本副程式目的在將group by
#                  的條件整理出來
# Input parameter: p_str
# RETURN code....: l_str
# Date & Author..: 01/10/09 By Kammy
# Modify.........: No.FUN-680122 06/09/01 By zdyllq 類型轉換  
 
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds        #FUN-680122
 
FUNCTION s_groupby(p_str)
 DEFINE l_len          LIKE type_file.num10,     #No.FUN-680122 INTEGER,
        i,j            LIKE type_file.num10,     #No.FUN-680122 INTEGER,
        p_str,l_str    LIKE type_file.chr1000    #No.FUN-680122 VARCHAR(100)
    
    LET l_len = length(p_str)
    LET j = 1
    FOR i = 1 TO l_len
      IF p_str[i,i+2]=",''" THEN LET i = i + 2 CONTINUE FOR END IF
      IF i=l_len AND p_str[l_len] = "," THEN 
         EXIT FOR   #group by的最後不可為逗號
      END IF 
      LET l_str[j] = p_str[i]
      LET j = j+1
    END FOR
    RETURN l_str
 
END FUNCTION
