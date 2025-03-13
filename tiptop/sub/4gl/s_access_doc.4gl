# Prog. Version..: '5.30.06-13.03.12(00002)'     #
# FUN-A10109
# Pattern name...: s_access_doc.4gl
# Descriptions...: 根據傳入的參數維護doc_file
# Date & Author..: 20/02/10
# Usage..........: CALL s_access_doc(p_cmd,p_auno,p_kind,p_slip,p_sys,p_acti)
# Input Parameter: p_cmd : a.新增 u.修改 r.刪除 
#                  p_auno: 自動編碼否
#                  p_kind: 單據性質
#                  p_slip: 單別
#                  p_sys:  模組代碼
#                  p_acti: 有效否
# Return code....: 
# Modify.........: NO.TQC-A50007 10/05/04 By lilingyu INSERT doc_file可能會出現NULL值,導致insert動作失敗

 
DATABASE ds
 
GLOBALS "../../config/top.global"      
 
DEFINE g_azi RECORD LIKE azi_file.*
 
FUNCTION s_access_doc (p_cmd,p_auno,p_kind,p_slip,p_sys,p_acti)
DEFINE p_cmd          LIKE type_file.chr1,
       p_auno         LIKE doc_file.docauno,
       p_kind         LIKE doc_file.dockind,
       p_slip         LIKE doc_file.docslip,
       p_sys          LIKE doc_file.docsys,
       p_acti         LIKE doc_file.docacti,
       l_doc          RECORD LIKE doc_file.*,
       l_docsys       LIKE doc_file.docsys,
       l_docslip      LIKE doc_file.docslip

   #FUN-A10109
   LET l_docsys  = UPSHIFT(p_sys)
   LET l_docslip = p_slip
   IF p_cmd = 'r' THEN
      DELETE FROM doc_file WHERE docsys  = l_docsys
                             AND docslip = l_docslip
   ELSE
      LET l_doc.docacti =  p_acti
      LET l_doc.docsys = UPSHIFT(p_sys)
      LET l_doc.docslip = p_slip
      LET l_doc.docauno = p_auno
      LET l_doc.dockind = p_kind
      LET l_doc.docacti = p_acti

      UPDATE doc_file SET doc_file.* = l_doc.*
       WHERE docsys  = l_docsys
         AND docslip = l_docslip
      IF SQLCA.sqlcode THEN
         CALL cl_err3('upd','doc_file',l_docsys,l_docslip,
                      SQLCA.sqlcode,'','',1)
      ELSE
         IF SQLCA.sqlerrd[3] = 0 THEN
#TQC-A50007 --begin--
           IF NOT cl_null(l_doc.docsys) AND NOT cl_null(l_doc.docslip) THEN
              IF cl_null(l_doc.docacti) THEN LET l_doc.docacti = 'N' END IF 
              IF cl_null(l_doc.docauno) THEN LET l_doc.docauno = 'N' END IF 
#TQC-A50007 --end--
              INSERT INTO doc_file VALUES(l_doc.*)
           END IF      #TQC-A50007  
            IF SQLCA.sqlcode THEN
               CALL cl_err3('ins','doc_file',l_doc.docsys,l_doc.docslip,
                            SQLCA.sqlcode,'','',1)
            END IF
         END IF
      END IF
   END IF

END FUNCTION
