# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Program name...: s_chk_dimension.4gl
# Descriptions...: 檢核異動碼5-8值是否正確
# Date & Author..: 
# Date & Author..: 11/02/09 FUN-AC0063 BY Summer

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chk_dimension(p_npq,p_aag01,p_key,p_bookno)
DEFINE p_npq      RECORD LIKE npq_file.*
DEFINE p_aag01    LIKE aag_file.aag01      # 科目
DEFINE p_cmd      LIKE aag_file.aag151,    # 異動碼控制方式
       p_key      LIKE aee_file.aee03,     # 異動碼
       p_bookno   LIKE aag_file.aag00,     
       l_aeeacti  LIKE aee_file.aeeacti,
       l_aee04    LIKE aee_file.aee04
DEFINE l_aag      RECORD LIKE aag_file.*  
DEFINE l_ahe      RECORD LIKE ahe_file.*  
DEFINE l_npq31    LIKE npq_file.npq31
DEFINE l_npq32    LIKE npq_file.npq32
DEFINE l_npq33    LIKE npq_file.npq33
DEFINE l_npq34    LIKE npq_file.npq34
DEFINE l_seq      LIKE type_file.num5

   WHENEVER ERROR CALL cl_err_msg_log

   LET g_errno = ' '

   INITIALIZE l_aag.* TO NULL
   INITIALIZE l_ahe.* TO NULL
   
   SELECT * INTO l_aag.* FROM aag_file WHERE aag01=p_aag01
                                         AND aag00=p_bookno
                                         
   FOR l_seq = 5 TO 8                                      
      CASE l_seq
         WHEN "5"  LET p_cmd=l_aag.aag311
                   SELECT * INTO l_ahe.* FROM ahe_file WHERE ahe01=l_aag.aag31
         WHEN "6"  LET p_cmd=l_aag.aag321
                   SELECT * INTO l_ahe.* FROM ahe_file WHERE ahe01=l_aag.aag32
         WHEN "7"  LET p_cmd=l_aag.aag331
                   SELECT * INTO l_ahe.* FROM ahe_file WHERE ahe01=l_aag.aag33
         WHEN "8"  LET p_cmd=l_aag.aag341
                   SELECT * INTO l_ahe.* FROM ahe_file WHERE ahe01=l_aag.aag34
      END CASE

      CASE p_cmd
         WHEN '3'   #異動碼必須輸入要檢查
            CASE
               WHEN l_ahe.ahe03='4'
                  CALL s_def_npq31_npq34(p_npq.*,p_bookno) RETURNING l_npq31,l_npq32,l_npq33,l_npq34
                  CASE l_seq
                     WHEN "5"
                        IF NOT cl_null(p_npq.npq31) AND p_npq.npq31 <> l_npq31 THEN
                           LET g_errno='sub-169'
                           RETURN 'npq31'
                        END IF
                            
                     WHEN "6"
                        IF NOT cl_null(p_npq.npq32) AND p_npq.npq32 <> l_npq32 THEN
                           LET g_errno='sub-169'
                           RETURN 'npq32'
                        END IF
                           
                     WHEN "7"
                        IF NOT cl_null(p_npq.npq33) AND p_npq.npq33 <> l_npq33 THEN
                           LET g_errno='sub-169'
                           RETURN 'npq33'
                        END IF
                            
                     WHEN "8"
                        IF NOT cl_null(p_npq.npq34) AND p_npq.npq34 <> l_npq34 THEN
                           LET g_errno='sub-169'
                           RETURN 'npq34'
                        END IF
                  END CASE
            END CASE         
         OTHERWISE EXIT CASE
      END CASE
   END FOR
   RETURN ''                   
END FUNCTION
#FUN-AC0063
