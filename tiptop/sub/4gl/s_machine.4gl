# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: s_machine.4gl
# Descriptions...: 存放GP5.25號機管理的相關函數
# Date & Author..: 10/08/20 by kim (#FUN-A80102)
# Modify.........: No.MOD-B30025 11/03/04 by zhangll 语法修正
 
DATABASE ds        
 
GLOBALS "../../config/top.global"

#FUN-A80102
#傳入料號,計畫批號(接受格式: 001-008  OR  1-8  OR  SWE50H14700101-108)
#回傳:起始流水碼及截止流水碼
FUNCTION s_machine_de_code(p_machine_item,p_machine_lot) 
   DEFINE p_machine_item   LIKE ima_file.ima01
   DEFINE p_machine_lot    LIKE sfb_file.sfb919
   DEFINE l_cnt    LIKE type_file.num5
   DEFINE l_snum,l_enum,l_tmp    STRING
   DEFINE lr_snum,lr_enum        STRING
   DEFINE l_ima156  LIKE ima_file.ima156
   DEFINE l_ima157  LIKE ima_file.ima157
   DEFINE l_sql     STRING
   DEFINE l_gel02   LIKE gel_file.gel02
   DEFINE l_gel03,l_start   LIKE gel_file.gel03
   DEFINE tok1      base.StringTokenizer
   
   LET l_cnt=1
   LET tok1 = base.StringTokenizer.create(p_machine_lot,"-")
   WHILE tok1.hasMoreTokens()
      LET l_tmp = tok1.nextToken()
      LET l_tmp = l_tmp.trim()
      CASE l_cnt
         WHEN "1"  LET l_snum = l_tmp
         WHEN "2"  LET l_enum = l_tmp
         OTHERWISE EXIT WHILE
      END CASE
      LET l_cnt = l_cnt + 1
   END WHILE

   SELECT ima156,ima157
     INTO l_ima156,l_ima157 FROM ima_file 
    WHERE ima01= p_machine_item
   IF l_ima156 ='Y' THEN
      LET l_sql = "SELECT gel02,gel03 FROM gel_file WHERE gel01='",l_ima157,"'",
                  "   AND gel04='3' ORDER BY gel02 DESC"
      PREPARE machine_decode_p FROM l_sql
      DECLARE machine_decode_c CURSOR FOR machine_decode_p
      OPEN machine_decode_c
      FETCH machine_decode_c INTO l_gel02,l_gel03
      CLOSE machine_decode_c
      LET l_sql = "SELECT SUM(gel03) FROM gel_file WHERE gel01='",l_ima157,"'",
                  "   AND gel02 <", l_gel02 CLIPPED
      PREPARE machine_decode_p2 FROM l_sql
      EXECUTE machine_decode_p2 INTO l_start
      IF l_start IS NULL THEN
         LET l_start = 0
      END IF
      IF l_snum.getlength() > l_gel03 THEN 
         LET lr_snum = l_snum.substring(l_start+1,l_start+l_gel03)
      ELSE
         LET lr_snum = l_snum
      END IF
      IF l_enum.getlength() > l_gel03 THEN 
         LET lr_enum = l_enum.substring(l_start+1,l_start+l_gel03)
      ELSE
         LET lr_enum = l_enum
      END IF
   ELSE
      LET lr_snum = l_snum
      LET lr_enum = l_enum
   END IF
   RETURN lr_snum,lr_enum
END FUNCTION

#傳入料號,流水碼(接受格式: 008  OR  8)
#回傳:號機編碼
#註:型態(gel04)只支援下列類型==>1:固定值/3:流水碼/4:欄位值/5:年-9:日
FUNCTION s_machine_en_code(p_machine_item,p_machine_sn) 
   DEFINE p_machine_item LIKE ima_file.ima01
   DEFINE p_machine_sn   STRING
   DEFINE l_ima156  LIKE ima_file.ima156
   DEFINE l_ima157  LIKE ima_file.ima157
   DEFINE l_sql,lr_str,l_tmp,l_format     STRING
   DEFINE l_gel RECORD LIKE gel_file.*
   DEFINE l_imastr     LIKE type_file.chr1000
   DEFINE l_gff03       LIKE gff_file.gff03 
   DEFINE l_date        LIKE type_file.chr10
   DEFINE l_no1         LIKE type_file.chr2 
   DEFINE l_length,l_i  LIKE type_file.num5 

   SELECT ima156,ima157
     INTO l_ima156,l_ima157 FROM ima_file
    WHERE ima01= p_machine_item
   IF l_ima156 = 'Y' THEN
      LET l_sql ="SELECT * FROM gel_file WHERE gel01 = '",l_ima157,"'",
                 " ORDER BY gel02"
      PREPARE machine_en_code_p1 FROM l_sql
      DECLARE machine_en_code_c1 CURSOR FOR  machine_en_code_p1
      FOREACH machine_en_code_c1 INTO l_gel.*
         CASE l_gel.gel04
            WHEN "1"  LET lr_str = lr_str , l_gel.gel05
            WHEN "3"
                 LET l_format = ''
                 FOR l_i = 1 TO l_gel.gel03
                    LET l_format = l_format , '&'
                 END FOR
                 LET l_tmp = p_machine_sn USING l_format
                 LET lr_str = lr_str , l_tmp CLIPPED
            WHEN "4"    #欄位值
                 LET l_sql ="SELECT ",l_gel.gel05, 
                            "  FROM ima_file WHERE ima01 ='",p_machine_item,"'"
                 PREPARE machine_en_code_p2 FROM l_sql
                 DECLARE machine_en_code_c2 CURSOR FOR machine_en_code_p2
                 OPEN machine_en_code_c2
                 FETCH machine_en_code_c2 INTO l_imastr
                 LET l_imastr = l_imastr[1,l_gel.gel03]
                 LET lr_str = lr_str , l_imastr CLIPPED
           #WHEN l_gel.gel04 = '5'    #年
            WHEN '5'    #年  #Mod MOD-B30025
                 SELECT gff03 INTO l_gff03 FROM gff_file
                  WHERE gff01 = YEAR(g_today)
                    AND gff02 = l_gel.gel03
                 LET lr_str = lr_str , l_gff03 CLIPPED
           #WHEN l_gel.gel04 = '6'    #季
            WHEN '6'    #季   #Mod MOD-B30025
                 CALL s_season(YEAR(g_today),MONTH(g_today)) RETURNING l_date
                 LET l_date = "00" CLIPPED,l_date
                 LET l_length = LENGTH(l_date)
                 LET l_no1 = l_date[l_length-1,l_length]
                 LET lr_str = lr_str ,l_no1 CLIPPED
           #WHEN l_gel.gel04 = '7'    #月
            WHEN '7'    #月  #Mod MOD-B30025
                 LET l_date = MONTH(g_today)
                 LET l_date = "00" CLIPPED,l_date
                 LET l_length = LENGTH(l_date)
                 LET l_no1 = l_date[l_length-1,l_length]
                 LET lr_str = lr_str ,l_no1 CLIPPED
           #WHEN l_gel.gel04 = '8'    #週
            WHEN '8'    #週  #Mod MOD-B30025
                 LET l_date = WEEKDAY(g_today)
                 LET l_date = "00" CLIPPED,l_date
                 LET l_length = LENGTH(l_date)
                 LET l_no1 = l_date[l_length-1,l_length]
                 LET lr_str = lr_str ,l_no1 CLIPPED
           #WHEN l_gel.gel04 = '9'    #日
            WHEN '9'    #日  #Mod MOD-B30025
                 LET l_date = DAY(g_today)
                 LET l_date = "00" CLIPPED,l_date
                 LET l_length = LENGTH(l_date)
                 LET l_no1 = l_date[l_length-1,l_length]
                 LET lr_str = lr_str ,l_no1 CLIPPED
         END CASE
      END FOREACH
   ELSE
      LET l_format = ''
      FOR l_i = 1 TO l_gel.gel03
         LET l_format = l_format , '&'
      END FOR
      LET lr_str = p_machine_sn USING l_format
   END IF
   RETURN lr_str
END FUNCTION

#(A).函數目的:檢查本站可以報工的量(總允許轉出量)
#(B).需手動報工的站:
#1.當工序中含有委外時，委外工序和前道工序必須手工報工
#2.當報工點(ecm66/sgm66)為'Y'時必須手動報工
#(C).當站可報工量:
#Rule.1:若當前工序之前的工序中存在報工點ecm66='Y'的工序，則當前工序的轉出量(shb111+shb112+shb113+shb114)不得大於上道報工點ecm66='Y'的工序的良品轉出量(ecm311+ecm315)-本道工序良品已轉出量(ecm311+ecm312+ecm313+ecm314+ecm316)
#Rule.2:若當前工序之前的工序中不存在報工點ecm66='Y'的工序，則當前工序的良品轉出量(shb111+shb112+shb113+shb114)不得大於當前製程段的第一道工序的良品轉入量(ecm301)-本道工序良品已轉出量(ecm311+ecm312+ecm313+ecm314+ecm316)
#(D).傳入參數:
#工單、Runcard、製程段、製程序
#特別說明:
#WHEN p_sgm01為 NULL 時，抓ecm,有值時抓sgm
#WHEN p_ecm03 = 0 OR NULL 時，回傳值改為:求得本製程段中所有製程序的最小轉出量
#(E).回傳值: 
#1.瓶頸製程段 
#2.瓶頸製程序 (前製程的手動報工站或首製程序)
#3.本站可報工量 (瓶頸站的轉出量)
FUNCTION s_machine_check_auto_report(p_sfb01,p_sgm01,p_ecm012,p_ecm03)
   DEFINE p_sfb01  LIKE sfb_file.sfb01 
   DEFINE p_sgm01  LIKE sgm_file.sgm01 
   DEFINE p_ecm012 LIKE ecm_file.ecm012
   DEFINE p_ecm03  LIKE ecm_file.ecm03 
   DEFINE l_sql    STRING
   DEFINE l_cnt    LIKE type_file.num5
   DEFINE l_min_tran_out LIKE ecm_file.ecm311   #最小轉出量
   DEFINE l_min_ecm012   LIKE ecm_file.ecm012
   DEFINE l_min_ecm03    LIKE ecm_file.ecm03
   DEFINE l_ecm  RECORD 
                   ecm012   LIKE ecm_file.ecm012 ,
                   ecm03    LIKE ecm_file.ecm03  ,
                   ecm301   LIKE ecm_file.ecm301 ,
                   ecm302   LIKE ecm_file.ecm302 ,
                   ecm303   LIKE ecm_file.ecm303 ,
                   ecm311   LIKE ecm_file.ecm311 ,
                   ecm312   LIKE ecm_file.ecm312 ,
                   ecm313   LIKE ecm_file.ecm313 ,
                   ecm314   LIKE ecm_file.ecm314 ,
                   ecm315   LIKE ecm_file.ecm315 ,
                   ecm316   LIKE ecm_file.ecm316 ,
                   ecm321   LIKE ecm_file.ecm321 ,
                   ecm322   LIKE ecm_file.ecm322 ,
                   ecm52    LIKE ecm_file.ecm52  ,
                   ecm62    LIKE ecm_file.ecm62  ,
                   ecm63    LIKE ecm_file.ecm63
                END RECORD
   DEFINE l_pre_ecm012   LIKE ecm_file.ecm012
   DEFINE l_pre_ecm03    LIKE ecm_file.ecm03
   
   IF p_ecm012 IS NULL THEN LET p_ecm012=' ' END IF
   
   #1.Check 前一報工點
   IF cl_null(p_sgm01) THEN
      LET l_sql = "SELECT ecm012,ecm03,ecm301,ecm302,ecm303,",
                  "ecm311,ecm312,ecm313,ecm314,ecm315,ecm316,",
                  "ecm321,ecm322,ecm52,ecm62,ecm63,ecm321,ecm322,ecm66 FROM ecm_file ",
                  " WHERE ecm01='",p_sfb01,"'",
                  "   AND ecm012='",p_ecm012,"'",
                  "   AND ecm66='Y' "
      IF p_ecm03 > 0 AND p_ecm03 IS NOT NULL THEN
         LET l_sql = l_sql ,"   AND ecm03 < ",p_ecm03
      END IF
         LET l_sql = l_sql ,"  ORDER BY ecm03 DESC"
   ELSE
      LET l_sql = "SELECT sgm012,sgm03,sgm301,sgm302,sgm303,",
                  "sgm311,sgm312,sgm313,sgm314,sgm315,sgm316,",
                  "sgm321,sgm322,sgm52,sgm62,sgm63,sgm321,sgm322,sgm66 FROM sgm_file ",
                  " WHERE sgm01='",p_sgm01,"'",
                  "   AND sgm012='",p_ecm012,"'",
                  "   AND sgm66='Y' "
      IF p_ecm03 > 0 AND p_ecm03 IS NOT NULL THEN
         LET l_sql = l_sql ,"   AND sgm03 < ",p_ecm03
      END IF
      LET l_sql = l_sql ,"  ORDER BY sgm03 DESC"
   END IF
   
   LET l_min_ecm012 = ' '
   LET l_min_ecm03  = 0
   PREPARE auto_report_p1 FROM l_sql
   DECLARE auto_report_c1 CURSOR FOR auto_report_p1
   FOREACH auto_report_c1 INTO l_ecm.*
       LET l_min_tran_out = l_ecm.ecm311 + l_ecm.ecm315
       LET l_min_ecm012 = l_ecm.ecm012
       LET l_min_ecm03  = l_ecm.ecm03
       EXIT FOREACH
   END FOREACH
   
   #2.若前面無報工點='Y'的資料,則check首製程序
   IF l_min_ecm03 = 0 THEN
      IF cl_null(p_sgm01) THEN
         SELECT MIN(ecm03) INTO l_min_ecm03 
           FROM ecm_file
          WHERE ecm01 =p_sfb01
            AND ecm012=p_ecm012
            AND ecm03 =p_ecm03
         SELECT ecm301 INTO l_min_tran_out
           FROM ecm_file
          WHERE ecm01 =p_sfb01
            AND ecm012=p_ecm012
            AND ecm03 =l_min_ecm03
      ELSE
         SELECT MIN(sgm03) INTO l_min_ecm03 
           FROM sgm_file
          WHERE sgm01 =p_sfb01
            AND sgm012=p_ecm012
            AND sgm03 =p_ecm03
         SELECT sgm301 INTO l_min_tran_out
           FROM sgm_file
          WHERE sgm01 =p_sfb01
            AND sgm012=p_ecm012
            AND sgm03 =l_min_ecm03
      END IF
   END IF
   
   RETURN l_min_ecm012,l_min_ecm03,l_min_tran_out
END FUNCTION

#自動產生前幾站的報工單
FUNCTION s_machine_auto_report()

END FUNCTION
