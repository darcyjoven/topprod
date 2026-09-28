# Prog. Version..: '5.25.01-12.12.26(00001)'
#
# Pattern name...: s_ckk.4gl
# Descriptions...: 成本勾稽表(ckk_file)新增數據
# Date & Author..: 12/08/27 By fengrui NO.FUN-C80092

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_ckk(p_ckk,p_plant)
   DEFINE p_ckk   RECORD LIKE ckk_file.*
   DEFINE p_plant LIKE        azp_file.azp01
   DEFINE l_sql   STRING 
   DEFINE l_ckk   RECORD LIKE ckk_file.*
   DEFINE l_ckk00 LIKE        ckk_file.ckk00
   DEFINE l_ccz01 LIKE        ccz_file.ccz01
   DEFINE l_ccz02 LIKE        ccz_file.ccz02

   LET l_ckk.* = p_ckk.*
   IF cl_null(l_ckk.ckk06) THEN LET l_ckk.ckk06 = ' ' END IF
   IF cl_null(l_ckk.ckk07) THEN LET l_ckk.ckk07 = 0 END IF 
   IF cl_null(l_ckk.ckk08) THEN LET l_ckk.ckk08 = 0 END IF
   IF cl_null(l_ckk.ckk09) THEN LET l_ckk.ckk09 = 0 END IF
   IF cl_null(l_ckk.ckk10) THEN LET l_ckk.ckk10 = 0 END IF
   IF cl_null(l_ckk.ckk11) THEN LET l_ckk.ckk11 = 0 END IF 
   IF cl_null(l_ckk.ckk12) THEN LET l_ckk.ckk12 = 0 END IF
   IF cl_null(l_ckk.ckk13) THEN LET l_ckk.ckk13 = 0 END IF
   IF cl_null(l_ckk.ckk14) THEN LET l_ckk.ckk14 = 0 END IF
   IF cl_null(l_ckk.ckk15) THEN LET l_ckk.ckk15 = 0 END IF
   IF cl_null(l_ckk.ckk16) THEN LET l_ckk.ckk16 = 0 END IF
   IF cl_null(l_ckk.ckkacti) THEN LET l_ckk.ckkacti = 'Y' END IF

   IF cl_null(p_plant) THEN LET p_plant = g_plant END IF 
   IF cl_null(p_ckk.ckk01) OR cl_null(p_ckk.ckk03) OR cl_null(p_ckk.ckk04) OR cl_null(p_ckk.ckk05) THEN 
      RETURN  FALSE 
   ELSE 
      LET l_sql = "SELECT ccz01,ccz02 FROM ", cl_get_target_table(p_plant,'ccz_file'),
                  " WHERE ccz00 = '0' "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
      CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql 
      PREPARE ckk_pre01 FROM l_sql
      DECLARE ckk_cs01  CURSOR FOR ckk_pre01
      OPEN ckk_cs01
      FETCH ckk_cs01 INTO l_ccz01,l_ccz02
      IF l_ccz01 <> p_ckk.ckk03 OR l_ccz02 <> p_ckk.ckk04 THEN
         RETURN FALSE
      END IF 
      #xujing-add---str
      IF NOT cl_null(p_ckk.ckk02) THEN
         LET l_ckk.ckk02 = cl_getmsg(p_ckk.ckk02,g_lang)  
      END IF
      #xujing-add---end
   END IF 
   IF cl_null(l_ckk.ckk06) THEN
      SELECT ccz28 INTO l_ckk.ckk06 FROM ccz_file WHERE ccz00 = '0'
   END IF
   IF cl_null(p_ckk.ckk00) THEN  #yymmdd+3碼流水號
      LET l_ckk00 = ''
      LET l_sql = "SELECT MAX(ckk00) FROM ", cl_get_target_table(p_plant,'ckk_file')
              #    " WHERE ckk03 = '",p_ckk.ckk03 ,"' ",
              #    "   AND ckk04 = '",p_ckk.ckk04 ,"' " 
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
      CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql 
      PREPARE ckk_pre02 FROM l_sql
      DECLARE ckk_cs02  CURSOR FOR ckk_pre02
      OPEN ckk_cs02
      FETCH ckk_cs02 INTO l_ckk00
      IF cl_null(l_ckk00) THEN 
         LET l_ckk.ckk00 = TODAY USING 'yymmdd' 
         LET l_ckk.ckk00 = l_ckk.ckk00 , '001'
      ELSE
         LET l_ckk.ckk00 = TODAY USING 'yymmdd'
         LET l_ckk.ckk00 = l_ckk.ckk00 , '001'
         IF l_ckk.ckk00 <= l_ckk00 THEN
            LET l_ckk.ckk00 = l_ckk00 + 1
         END IF 
      END IF 
   END IF 
   
   BEGIN WORK  #free:是否需要開啟事務   需確認原function中是否已有?

   LET l_sql = "DELETE FROM ", cl_get_target_table(p_plant,'ckk_file'),
               " WHERE ckk01 = '",l_ckk.ckk01 ,"' ",
               "   AND ckk03 = '",l_ckk.ckk03 ,"' ",
               "   AND ckk04 = '",l_ckk.ckk04 ,"' ", 
               "   AND ckk06 = '",l_ckk.ckk06 ,"' ",
               "   AND ckkacti = 'Y' "  
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql 
   PREPARE ckk_pre03 FROM l_sql
   EXECUTE ckk_pre03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("del","ckk_file",l_ckk.ckk01,l_ckk.ckk05,SQLCA.sqlcode,"","",0)
      ROLLBACK WORK 
      RETURN FALSE
   ELSE
      LET l_sql = " INSERT INTO ", cl_get_target_table(p_plant,'ckk_file'),
                  " VALUES (?,?,?,?,?,?,?,?,?,?,",  #10
                           "?,?,?,?,?,?,?,?,?,?,",  #10
                           "?,?) "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
      CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql 
      PREPARE ckk_pre04 FROM l_sql
      EXECUTE ckk_pre04 USING l_ckk.*
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","ckk_file",l_ckk.ckk01,l_ckk.ckk05,SQLCA.sqlcode,"","",0)
         ROLLBACK WORK 
         RETURN FALSE
      END IF
   END IF 
   COMMIT WORK 
   RETURN TRUE 
END FUNCTION 

FUNCTION s_ckk_fill(p_ckk00,p_ckk01,p_ckk02,p_ckk03,p_ckk04,p_ckk05,p_ckk06,p_ckk07,
                    p_ckk08,p_ckk09,p_ckk10,p_ckk11,p_ckk12,p_ckk13,p_ckk14,p_ckk15,
                    p_ckk16,p_ckk17,p_ckkuser,p_ckkdate,p_ckktime,p_ckkacti)
   DEFINE p_ckk00   LIKE ckk_file.ckk00
   DEFINE p_ckk01   LIKE ckk_file.ckk01
   DEFINE p_ckk02   LIKE ckk_file.ckk02
   DEFINE p_ckk03   LIKE ckk_file.ckk03
   DEFINE p_ckk04   LIKE ckk_file.ckk04
   DEFINE p_ckk05   LIKE ckk_file.ckk05
   DEFINE p_ckk06   LIKE ckk_file.ckk06
   DEFINE p_ckk07   LIKE ckk_file.ckk07
   DEFINE p_ckk08   LIKE ckk_file.ckk08
   DEFINE p_ckk09   LIKE ckk_file.ckk09
   DEFINE p_ckk10   LIKE ckk_file.ckk10
   DEFINE p_ckk11   LIKE ckk_file.ckk11
   DEFINE p_ckk12   LIKE ckk_file.ckk12
   DEFINE p_ckk13   LIKE ckk_file.ckk13
   DEFINE p_ckk14   LIKE ckk_file.ckk14
   DEFINE p_ckk15   LIKE ckk_file.ckk15
   DEFINE p_ckk16   LIKE ckk_file.ckk16
   DEFINE p_ckk17   LIKE ckk_file.ckk17
   DEFINE p_ckkuser LIKE ckk_file.ckkuser
   DEFINE p_ckkdate LIKE ckk_file.ckkdate
   DEFINE p_ckktime LIKE ckk_file.ckktime
   DEFINE p_ckkacti LIKE ckk_file.ckkacti
   DEFINE l_ckk     RECORD LIKE ckk_file.*

   LET l_ckk.ckk00 = p_ckk00 
   LET l_ckk.ckk01 = p_ckk01 
   LET l_ckk.ckk02 = p_ckk02 
   LET l_ckk.ckk03 = p_ckk03 
   LET l_ckk.ckk04 = p_ckk04 
   LET l_ckk.ckk05 = p_ckk05 
   LET l_ckk.ckk06 = p_ckk06 
   LET l_ckk.ckk07 = p_ckk07 
   LET l_ckk.ckk08 = p_ckk08 
   LET l_ckk.ckk09 = p_ckk09 
   LET l_ckk.ckk10 = p_ckk10 
   LET l_ckk.ckk11 = p_ckk11 
   LET l_ckk.ckk12 = p_ckk12 
   LET l_ckk.ckk13 = p_ckk13 
   LET l_ckk.ckk14 = p_ckk14 
   LET l_ckk.ckk15 = p_ckk15 
   LET l_ckk.ckk16 = p_ckk16 
   LET l_ckk.ckk17 = p_ckk17
   LET l_ckk.ckkuser = p_ckkuser
   LET l_ckk.ckkdate = p_ckkdate
   LET l_ckk.ckktime = TIME  
   LET l_ckk.ckkacti = p_ckkacti

   RETURN l_ckk.* 
END FUNCTION 
#FUN-C80092
