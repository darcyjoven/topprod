# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Descriptions...: 对条码录入进行解析
# ...............: 目前只解析两部分出来，预留了5段，以备后续使用。
# Usage..........: 1.解析仓库与类型：CALL s_analyze('A202%301-01-01','%')
# ...............:                    RETURNING l_part1,l_part2
# ...............:
# Date & Author..: 12/11/12 By Abby
# Modify.........: No:DEV-D20003 13/02/21 By Mandy 增加用$拆分單號與項次
# Modify.........: No.WEB-D30009 13/03/26 By Nina GP5.3 追版:以上為GP5.25 的單號

DATABASE ds

FUNCTION  s_analyze(p_source)
 DEFINE p_source  STRING
 DEFINE l_delim   LIKE type_file.chr5
 DEFINE tok base.StringTokenizer
 DEFINE l_cnt     LIKE type_file.num5
 DEFINE l_i       LIKE type_file.num5
 DEFINE l_idx     LIKE type_file.num5
 DEFINE l_part    ARRAY[5] OF VARCHAR(80)
 DEFINE l_part1   LIKE type_file.chr100
 DEFINE l_part2   LIKE type_file.chr100
 DEFINE l_part3   LIKE type_file.chr100
 DEFINE l_part4   LIKE type_file.chr100
 DEFINE l_part5   LIKE type_file.chr100
 DEFINE l_iba01   LIKE iba_file.iba01
 
             
 IF cl_null(p_source) THEN 
    RETURN '','',p_source
 END IF 
 
 LET l_idx = p_source.getIndexOf('%',1)
 IF l_idx > 0 THEN 
    LET l_delim = '%'
 END IF 

 #DEV-D20003---add---str--
 LET l_idx = p_source.getIndexOf('$',1)
 IF l_idx > 0 THEN 
    LET l_delim = '$'
 END IF 
 #DEV-D20003---add---end--

#WEB-CB0002 mark str---
#IF l_idx = 0 THEN 
#   LET l_iba01 = p_source
#   SELECT COUNT(*) INTO l_cnt
#     FROM iba_file
#    WHERE iba01 = l_iba01
#   IF l_cnt >= 1 THEN
#       LET l_delim = '$'
#   ELSE
#       LET l_delim = '-'
#   END IF
#ELSE 
#   LET l_delim = '%'
#END IF 
#WEB-CB0002 mark end---
 
 CASE l_delim
    WHEN '%'
      #拆分仓库与库位
       LET l_cnt = 1
       LET tok = base.StringTokenizer.CREATE(p_source,'%')
       WHILE tok.hasMoreTokens()
          LET l_part[l_cnt] = tok.nextToken()
          LET l_cnt = l_cnt + 1
       END WHILE  	
       LET l_cnt = l_cnt - 1     

    #DEV-D20003---add---str---
    WHEN '$'
      #拆分單號與項次
       LET l_cnt = 1
       LET tok = base.StringTokenizer.CREATE(p_source,'$')
       WHILE tok.hasMoreTokens()
          LET l_part[l_cnt] = tok.nextToken()
          LET l_cnt = l_cnt + 1
       END WHILE  	
       LET l_cnt = l_cnt - 1     
    #DEV-D20003---add---end---

    OTHERWISE 
       LET l_part[1] = p_source
       LET l_part[2] = p_source
       LET l_part[3] = p_source
       LET l_part[4] = p_source
       LET l_part[5] = p_source
 END CASE 

 
 FOR l_i = 1 TO 5
    CASE l_i 
      WHEN 1
        LET l_part1 = l_part[l_i]
      WHEN 2
        LET l_part2 = l_part[l_i]
      WHEN 3
        LET l_part3 = l_part[l_i]
      WHEN 4
        LET l_part4 = l_part[l_i]
      WHEN 5
        LET l_part5 = l_part[l_i]
    END CASE 
 END FOR 

 IF cl_null(l_part2) THEN
    LET l_part2 = ' '
 END IF

 RETURN l_delim,l_part1,l_part2

END FUNCTION 

#WEB-D30009 add

