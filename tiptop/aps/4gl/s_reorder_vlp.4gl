# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: s_reorder_vlp.4gl
# Descriptions...: 重新給定vlp02的值
# Date & Author..: 2010/11/24 By Mandy #FUN-AB0090
# Modify.........: No.FUN-B50022 11/05/10 By Mandy---GP5.25 追版:以上為GP5.1 的單號---

DATABASE ds        

GLOBALS "../../config/top.global"   

#項次由10重排
FUNCTION s_reorder_vlp_1(p_vlp01) 
DEFINE p_vlp01         LIKE vlp_file.vlp01
DEFINE l_vlp02_old     LIKE vlp_file.vlp02
DEFINE l_vlp02_new     LIKE vlp_file.vlp02
DEFINE l_vlp02_last    LIKE vlp_file.vlp02
#DEFINE l_vlp_rowid     LIKE type_file.chr18 #FUN-B50022 mark
DEFINE l_vlp01         LIKE vlp_file.vlp01   #FUN-B50022 add
DEFINE l_vlp03         LIKE vlp_file.vlp03   #FUN-B50022 add

  DECLARE s_reorder_vlp_1 CURSOR FOR
  #SELECT vlp_file.ROWID,vlp02 #FUN-B50022 mark
   SELECT vlp01,vlp03,vlp02    #FUN-B50022 add
    FROM vlp_file
   WHERE vlp01 = p_vlp01
   ORDER BY vlp02

   LET l_vlp02_new = 0
   LET l_vlp02_last = ''
  #FOREACH s_reorder_vlp_1 INTO l_vlp_rowid,l_vlp02_old        #FUN-B50022 mark
   FOREACH s_reorder_vlp_1 INTO l_vlp01,l_vlp03,l_vlp02_old    #FUN-B50022 add
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:s_reorder_vlp_1',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       IF cl_null(l_vlp02_last) THEN
           LET l_vlp02_new = l_vlp02_new + 10
       ELSE
           IF l_vlp02_last <> l_vlp02_old THEN
               LET l_vlp02_new = l_vlp02_new + 10
           END IF
       END IF
       UPDATE vlp_file
          SET vlp02 = l_vlp02_new
       #WHERE ROWID = l_vlp_rowid #FUN-B50022 mark
        WHERE vlp01 = l_vlp01     #FUN-B50022 add
          AND vlp03 = l_vlp03     #FUN-B50022 add
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err('',SQLCA.sqlcode,0)
           LET g_success = 'N'
           EXIT FOREACH
       END IF
       LET l_vlp02_last = l_vlp02_old
   END FOREACH
END FUNCTION

#依產品分類碼排序
FUNCTION s_reorder_vlp_2() 
DEFINE l_vlp02         LIKE vlp_file.vlp02
DEFINE l_vlp03         LIKE vlp_file.vlp03
#DEFINE l_vlp_rowid     LIKE type_file.chr18 #FUN-B50022 mark
DEFINE l_vlp01         LIKE vlp_file.vlp01   #FUN-B50022 add
DEFINE l_ima131        LIKE ima_file.ima131

  DECLARE s_reorder_vlp_2 CURSOR FOR
  #SELECT vlp_file.ROWID,ima131,vlp03 #FUN-B50022 mark
   SELECT vlp01,ima131,vlp03          #FUN-B50022 add
    FROM vlp_file,OUTER ima_file
   WHERE vlp01 = '1' #資料類別:'1':料件
     AND vlp03 = ima_file.ima01
   ORDER BY ima131,vlp03 

   LET l_vlp02 = 10
  #FOREACH s_reorder_vlp_2 INTO l_vlp_rowid,l_ima131,l_vlp03 #FUN-B50022 mark
   FOREACH s_reorder_vlp_2 INTO l_vlp01,l_ima131,l_vlp03     #FUN-B50022 add
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:s_reorder_vlp_2',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       UPDATE vlp_file
          SET vlp02 = l_vlp02
       #WHERE ROWID = l_vlp_rowid #FUN-B50022 mark
        WHERE vlp01 = l_vlp01     #FUN-B50022 add
          AND vlp03 = l_vlp03     #FUN-B50022 add
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err('',SQLCA.sqlcode,0)
           LET g_success = 'N'
           EXIT FOREACH
       END IF
       LET l_vlp02 = l_vlp02 + 10
   END FOREACH
END FUNCTION

#依資料編號排序
FUNCTION s_reorder_vlp_3(p_vlp01) 
DEFINE p_vlp01         LIKE vlp_file.vlp01
DEFINE l_vlp02         LIKE vlp_file.vlp02
#DEFINE l_vlp_rowid     LIKE type_file.chr18 #FUN-B50022 mark
DEFINE l_vlp01         LIKE vlp_file.vlp01   #FUN-B50022 add
DEFINE l_vlp03         LIKE vlp_file.vlp03   #FUN-B50022 add


  DECLARE s_reorder_vlp_3 CURSOR FOR
  #SELECT vlp_file.ROWID #FUN-B50022 mark
   SELECT vlp01,vlp03    #FUN-B50022 add
    FROM vlp_file
   WHERE vlp01 = p_vlp01
   ORDER BY vlp03

   LET l_vlp02 = 10
  #FOREACH s_reorder_vlp_3 INTO l_vlp_rowid     #FUN-B50022 mark
   FOREACH s_reorder_vlp_3 INTO l_vlp01,l_vlp03 #FUN-B50022 add
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:s_reorder_vlp_3',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       UPDATE vlp_file
          SET vlp02 = l_vlp02
       #WHERE ROWID = l_vlp_rowid #FUN-B50022 mark
        WHERE vlp01 = l_vlp01     #FUN-B50022 add
          AND vlp03 = l_vlp03     #FUN-B50022 add
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err('',SQLCA.sqlcode,0)
           LET g_success = 'N'
           EXIT FOREACH
       END IF
       LET l_vlp02 = l_vlp02 + 10
   END FOREACH
END FUNCTION

#依客戶群組排序
FUNCTION s_reorder_vlp_4() 
DEFINE l_vlp02         LIKE vlp_file.vlp02
DEFINE l_vlp03         LIKE vlp_file.vlp03
#DEFINE l_vlp_rowid     LIKE type_file.chr18 #FUN-B50022 mark
DEFINE l_vlp01         LIKE vlp_file.vlp01   #FUN-B50022 add
DEFINE l_occ34         LIKE occ_file.occ34

  DECLARE s_reorder_vlp_4 CURSOR FOR
  #SELECT vlp_file.ROWID,occ34,vlp03 #FUN-B50022 mark
   SELECT vlp01,occ34,vlp03          #FUN-B50022 add
    FROM vlp_file,OUTER occ_file
   WHERE vlp01 = '2' #資料類別:'2':客戶
     AND vlp03 = occ_file.occ01
   ORDER BY occ34,vlp03 

   LET l_vlp02 = 10
  #FOREACH s_reorder_vlp_4 INTO l_vlp_rowid,l_occ34,l_vlp03 #FUN-B50022 mark
   FOREACH s_reorder_vlp_4 INTO l_vlp01,l_occ34,l_vlp03     #FUN-B50022 add
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:s_reorder_vlp_4',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       UPDATE vlp_file
          SET vlp02 = l_vlp02
       #WHERE ROWID = l_vlp_rowid #FUN-B50022 mark
        WHERE vlp01 = l_vlp01     #FUN-B50022 add
          AND vlp03 = l_vlp03     #FUN-B50022 add
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err('',SQLCA.sqlcode,0)
           LET g_success = 'N'
           EXIT FOREACH
       END IF
       LET l_vlp02 = l_vlp02 + 10
   END FOREACH
END FUNCTION

#依部門排序
FUNCTION s_reorder_vlp_5() 
DEFINE l_vlp02         LIKE vlp_file.vlp02
DEFINE l_vlp03         LIKE vlp_file.vlp03
#DEFINE l_vlp_rowid     LIKE type_file.chr18 #FUN-B50022 mark
DEFINE l_vlp01         LIKE vlp_file.vlp01   #FUN-B50022 add
DEFINE l_gen03         LIKE gen_file.gen03

  DECLARE s_reorder_vlp_5 CURSOR FOR
  #SELECT vlp_file.ROWID,gen03,vlp03 #FUN-B50022 mark
   SELECT vlp01,gen03,vlp03          #FUN-B50022 add
    FROM vlp_file,OUTER gen_file
   WHERE vlp01 = '3' #資料類別:'3':業務
     AND vlp03 = gen_file.gen01
   ORDER BY gen03,vlp03 

   LET l_vlp02 = 10
  #FOREACH s_reorder_vlp_5 INTO l_vlp_rowid,l_gen03,l_vlp03 #FUN-B50022 mark
   FOREACH s_reorder_vlp_5 INTO l_vlp01,l_gen03,l_vlp03     #FUN-B50022 add
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:s_reorder_vlp_5',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       UPDATE vlp_file
          SET vlp02 = l_vlp02
       #WHERE ROWID = l_vlp_rowid #FUN-B50022 mark
        WHERE vlp01 = l_vlp01     #FUN-B50022 add
          AND vlp03 = l_vlp03     #FUN-B50022 add
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err('',SQLCA.sqlcode,0)
           LET g_success = 'N'
           EXIT FOREACH
       END IF
       LET l_vlp02 = l_vlp02 + 10
   END FOREACH
END FUNCTION
#FUN-AB0090
