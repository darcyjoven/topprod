# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: s_guiauno.4gl
# Descriptions...: 本 sub 提供二種功能:
#            	   (1)自動賦予發票號碼     (當 p_no is null)
#            	   (2)更新發票簿檔最大單號 (當 p_no is not null)
# Date & Author..: 
# Usage..........: CALL s_guiauno(p_no,p_date,p_oma05,p_oma212)
#		                  RETURNING l_stat,l_slip
# Input Parameter: p_slip  單號
# Return code....: l_stat  結果碼 0:OK, 1:FAIL
#                  l_slip  單號
# Modify.........: No.FUN-540023 05/05/09 By ice 發票號碼加大到16位
# Modify.........: No.FUN-560198 05/07/05 By vivien 發票欄位加大后截位修改
# Modify.........: No.FUN-670091 06/08/02 BY rainy cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By Czl  類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0014 09/12/09 By shiwuying 改為可從同法人下不同DB抓資料
# Modify.........: No:FUN-A10104 10/01/19 By shiwuying 函數傳參部份修改
# Modify.........: No.FUN-A50102 10/06/22 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-B90130 11/10/12 BY wujie 大陆版时，oom04-->oom15  
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
GLOBALS
DEFINE g_waitsec	LIKE type_file.num5         #No.FUN-680147 SMALLINT
END GLOBALS
 
FUNCTION s_guiauno1(p_no,p_code,p_date,p_oma05,p_oma212,p_plant) #No.FUN-A10104  #No.FUN-B90130 add p_code 
DEFINE p_no     LIKE oom_file.oom09          #No.FUN-680147 VARCHAR(16)  #INVOICE#
                                             #No.FUN-540023
DEFINE p_date   LIKE type_file.dat           #No.FUN-680147 DATE		#發票日期
DEFINE p_oma05  LIKE oom_file.oom03          #No.FUN-680147 VARCHAR(1)
DEFINE p_oma212 LIKE oom_file.oom04          #No.FUN-680147 VARCHAR(1)
DEFINE l_n      LIKE type_file.num5          #        #No.FUN-680147 SMALLINT
DEFINE i        LIKE type_file.num5          #        #No.FUN-680147 SMALLINT
DEFINE l_cnt    LIKE type_file.num5          #        #No.FUN-680147 SMALLINT
DEFINE l_yy,l_mm	        LIKE type_file.num10         #No.FUN-680147 INTEGER
DEFINE l_oom			RECORD LIKE oom_file.*
DEFINE g_format LIKE oom_file.oom09          #No.FUN-680147  VARCHAR(16)    #No.FUN-560198
DEFINE p_dbs    LIKE type_file.chr21         #No.FUN-9C0014
DEFINE l_sql    LIKE type_file.chr1000       #No.FUN-9C0014
DEFINE p_plant  LIKE azp_file.azp01          #No.FUN-A10104
DEFINE p_code   LIKE oom_file.oom16          #No.FUN-B90130   #发票代码 
 
    WHENEVER ERROR CONTINUE
#No.FUN-A10104 -BEGIN-----
  IF cl_null(p_plant) THEN
     LET p_dbs = ''
  ELSE
     LET g_plant_new = p_plant
     CALL s_gettrandbs()
     LET p_dbs = g_dbs_tra
  END IF
#No.FUN-A10104 -END-------
    LET l_yy=YEAR(p_date) LET l_mm=MONTH(p_date)
         #99.01.28 配合2個月申報一次發票修改
       #  IF l_mm=2 THEN LET l_mm=1 END IF
       #  IF l_mm=4 THEN LET l_mm=3 END IF
       #  IF l_mm=6 THEN LET l_mm=5 END IF
       #  IF l_mm=8 THEN LET l_mm=7 END IF
       #  IF l_mm=10 THEN LET l_mm=9 END IF
       #  IF l_mm=12 THEN LET l_mm=11 END IF
    IF NOT cl_null(p_no) THEN #人工開立發票,不需自動編號,但要更新最大單號
    #No.FUN-9C0014 BEGIN -----
    #  UPDATE oom_file SET oom09=p_no, oom10=p_date
    #   WHERE oom07 <= p_no AND p_no <= oom08
    #     AND (p_no > oom09 OR oom09 IS NULL)
       #LET l_sql = "UPDATE ",p_dbs CLIPPED,"oom_file ",
       LET l_sql = "UPDATE ",cl_get_target_table(p_plant,'oom_file'), #FUN-A50102
                   "   SET oom09='",p_no,"', oom10='",p_date,"'",
                   " WHERE oom07 <= '",p_no,"' AND '",p_no,"' <= oom08",
                   "   AND ('",p_no,"' > oom09 OR oom09 IS NULL)",
                   "   AND (oom16 = '",p_code,"' OR oom16 IS NULL)"  #No.FUN-B90130        
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
	   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql      #FUN-A50102
       PREPARE upd_oom_pre01 FROM l_sql
       EXECUTE upd_oom_pre01
    #No.FUN-9C0014 END -------
       IF SQLCA.SQLCODE THEN
          #CALL cl_err('upd oom09:',SQLCA.SQLCODE,1) RETURN 1,''  #FUN-670091
           CALL cl_err3("upd","oom_file","","",STATUS,"","upd oom09",0) RETURN 1,''  #FUN-670091
       END IF
       RETURN 0,p_no,p_code   #No.FUN-B90130    
    END IF
   #No.FUN-9C0014 BEGIN -----
   #DECLARE oom_curl CURSOR FOR
   #    SELECT oom_file.* FROM oom_file
   #     WHERE oom01=l_yy AND l_mm BETWEEN oom02 AND oom021
   #       AND oom03=p_oma05 AND oom04=p_oma212 AND oom06='1'
   #       AND (oom08>oom09 OR oom09 IS NULL)
   #    ORDER BY oom05
    #LET l_sql = "SELECT oom_file.* FROM ",p_dbs CLIPPED,"oom_file",
    LET l_sql = "SELECT oom_file.* FROM ",cl_get_target_table(p_plant,'oom_file'), #FUN-A50102
                " WHERE oom01=",l_yy," AND ",l_mm," BETWEEN oom02 AND oom021",
#No.FUN-B90130 --begin
#                "   AND oom03='",p_oma05,"' AND oom04='",p_oma212,"' AND oom06='1'",
#                "   AND (oom08>oom09 OR oom09 IS NULL)",
#                " ORDER BY oom05"
                "   AND oom03='",p_oma05,"' AND oom06='1'",
                "   AND (oom08>oom09 OR oom09 IS NULL)"
    IF g_aza.aza26 ='2' THEN 
       IF NOT cl_null(p_code) THEN 
          LET l_sql = l_sql," AND oom15 = '",p_oma212,"' AND oom16 = '",p_code,"' ORDER BY oom05 "  
       ELSE
          LET l_sql = l_sql," AND oom15 = '",p_oma212,"' ORDER BY oom05 "  
       END IF       
    ELSE 
       LET l_sql = l_sql," AND oom04 = '",p_oma212,"' ORDER BY oom05 "        
    END IF
#No.FUN-B90130 --end    
  CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
	CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql      #FUN-A50102
    PREPARE sel_oom_pre02 FROM l_sql
    DECLARE oom_curl CURSOR FOR sel_oom_pre02
   #No.FUN-9C0014 END -------
    FOREACH oom_curl
    INTO l_oom.*
      IF STATUS THEN
         CALL cl_err('s_guiauno:foreach',STATUS,1)
         CLOSE oom_curl  RETURN 1,'',''    #失敗  #No.FUN-B90130      
      END IF
      IF p_date < l_oom.oom10 THEN
         CALL cl_err(l_oom.oom10,'axr-208',1)
         CLOSE oom_curl  RETURN 1,'',''    #失敗  #No.FUN-B90130       
      END IF
      #####
      #No.FUN-560198 --start--
      #為了與舊寫法兼容，default初值
      IF cl_null(l_oom.oom11) THEN LET l_oom.oom11 = 3 END IF
      IF cl_null(l_oom.oom12) THEN LET l_oom.oom12 = 10 END IF
      LET l_cnt=length(l_oom.oom07[l_oom.oom11,l_oom.oom12])
      LET g_format = NULL
      FOR i = 1 TO l_cnt
         LET g_format = '&',g_format CLIPPED
      END FOR
      IF cl_null(l_oom.oom09) THEN
         IF l_oom.oom11 > 1 THEN
            LET l_oom.oom09 = l_oom.oom07[1,l_oom.oom11-1],
                             (l_oom.oom07[l_oom.oom11,l_oom.oom11+l_cnt-1]-1) USING g_format CLIPPED
         ELSE
            LET l_oom.oom09 = (l_oom.oom07[1,l_oom.oom11+l_cnt-1]-1) USING g_format CLIPPED
         END IF
      END IF
      IF l_oom.oom11 > 1 THEN
         LET l_oom.oom09 = l_oom.oom09[1,l_oom.oom11-1],
                          (l_oom.oom09[l_oom.oom11,l_oom.oom11+l_cnt-1]+1) USING g_format CLIPPED
      ELSE
         LET l_oom.oom09 = (l_oom.oom09[l_oom.oom11,l_oom.oom11+l_cnt-1]+1) USING g_format CLIPPED
      END IF
#     IF cl_null(l_oom.oom09) THEN
#        CASE WHEN l_cnt=1
#             LET l_oom.oom09=l_oom.oom07[1,2],(l_oom.oom07[3,3+l_cnt-1]-1) USING '&' CLIPPED
#             WHEN l_cnt=2
#             LET l_oom.oom09=l_oom.oom07[1,2],(l_oom.oom07[3,3+l_cnt-1]-1) USING '&&' CLIPPED
#             WHEN l_cnt=3
#             LET l_oom.oom09=l_oom.oom07[1,2],(l_oom.oom07[3,3+l_cnt-1]-1) USING '&&&' CLIPPED
#             WHEN l_cnt=4
#             LET l_oom.oom09=l_oom.oom07[1,2],(l_oom.oom07[3,3+l_cnt-1]-1) USING '&&&&' CLIPPED
#             WHEN l_cnt=5
#             LET l_oom.oom09=l_oom.oom07[1,2],(l_oom.oom07[3,3+l_cnt-1]-1) USING '&&&&&' CLIPPED
#             WHEN l_cnt=6
#             LET l_oom.oom09=l_oom.oom07[1,2],(l_oom.oom07[3,3+l_cnt-1]-1) USING '&&&&&&' CLIPPED
#             WHEN l_cnt=7
#             LET l_oom.oom09=l_oom.oom07[1,2],(l_oom.oom07[3,3+l_cnt-1]-1) USING '&&&&&&&' CLIPPED
#             WHEN l_cnt=8
#             LET l_oom.oom09=l_oom.oom07[1,2],(l_oom.oom07[3,3+l_cnt-1]-1) USING '&&&&&&&&' CLIPPED
#        END CASE
#     END IF
#     CASE WHEN l_cnt=1
#          LET l_oom.oom09=l_oom.oom09[1,2],(l_oom.oom09[3,3+l_cnt-1]+1) USING '&' CLIPPED
#          WHEN l_cnt=2
#          LET l_oom.oom09=l_oom.oom09[1,2],(l_oom.oom09[3,3+l_cnt-1]+1) USING '&&' CLIPPED
#          WHEN l_cnt=3
#          LET l_oom.oom09=l_oom.oom09[1,2],(l_oom.oom09[3,3+l_cnt-1]+1) USING '&&&' CLIPPED
#          WHEN l_cnt=4
#          LET l_oom.oom09=l_oom.oom09[1,2],(l_oom.oom09[3,3+l_cnt-1]+1) USING '&&&&' CLIPPED
#          WHEN l_cnt=5
#          LET l_oom.oom09=l_oom.oom09[1,2],(l_oom.oom09[3,3+l_cnt-1]+1) USING '&&&&&' CLIPPED
#          WHEN l_cnt=6
#          LET l_oom.oom09=l_oom.oom09[1,2],(l_oom.oom09[3,3+l_cnt-1]+1) USING '&&&&&&' CLIPPED
#          WHEN l_cnt=7
#          LET l_oom.oom09=l_oom.oom09[1,2],(l_oom.oom09[3,3+l_cnt-1]+1) USING '&&&&&&&' CLIPPED
#          WHEN l_cnt=8
#          LET l_oom.oom09=l_oom.oom09[1,2],(l_oom.oom09[3,3+l_cnt-1]+1) USING '&&&&&&&&' CLIPPED
#     END CASE
      #No.FUN-560198 --end--
      LET p_no = l_oom.oom09
      LET p_code = l_oom.oom16  #No.FUN-B90130  
      #####
      EXIT FOREACH
    END FOREACH
    IF p_no IS NULL THEN
    #No.FUN-9C0014 BEGIN -----
    #  SELECT COUNT(*) INTO l_n FROM oom_file           #no:5607
    #    WHERE oom01=l_yy AND l_mm BETWEEN oom02 AND oom021
    #      AND oom03=p_oma05 AND oom04=p_oma212 AND oom06='2'
       #LET l_sql = "SELECT COUNT(*) FROM ",p_dbs CLIPPED,"oom_file",
       LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(p_plant,'oom_file'), #FUN-A50102
                   " WHERE oom01=",l_yy," AND ",l_mm," BETWEEN oom02 AND oom021"       
#No.FUN-B90130 --begin
#                   "   AND oom03='",p_oma05,"' AND oom04='",p_oma212,"' AND oom06='2'" 
    IF g_aza.aza26 ='2' THEN 
       IF NOT cl_null(p_code) THEN 
          LET l_sql = l_sql,"   AND oom03='",p_oma05," AND oom15 = '",p_oma212,"' AND oom16 = '",p_code,"' AND oom06='2' "  
       ELSE
          LET l_sql = l_sql,"   AND oom03='",p_oma05," AND oom15 = '",p_oma212,"' AND oom06='2' "  
       END IF       
    ELSE 
       LET l_sql = l_sql,"   AND oom03='",p_oma05," AND oom04 = '",p_oma212,"' AND oom06='2' "        
    END IF  
#No.FUN-B90130 --end
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
	   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql      #FUN-A50102
       PREPARE sel_oom_pre03 FROM l_sql
       EXECUTE sel_oom_pre03 INTO l_n
    #No.FUN-9C0014 END -------
       IF l_n=0 THEN
          CALL cl_err('s_guiauno:','aap-760',1) RETURN 1,'',''   #No.FUN-B90130       
       END IF
    END IF
    CLOSE oom_curl
    RETURN 0,p_no,p_code   #No.FUN-B90130
END FUNCTION
#Patch....NO.TQC-610035 <001> #
