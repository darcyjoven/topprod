# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Program name...: p_preview_path.4gl
# Descriptions...: 輸出畫面檔實際所在路徑
# Date & Author..: 2010/09/02 by alex (由p_preview分割出來)
# Modify.........: 
# Modify.........: No:FUN-B30038 11/03/24 by jrg542 完成解包及安裝程式 
IMPORT os
DATABASE ds
 
GLOBALS "../../config/top.global"
 
GLOBALS
DEFINE g_cust_flag       LIKE type_file.chr1          # 客製註記  #No.FUN-680135 VARCHAR(1)
DEFINE g_syskeep         LIKE type_file.num5          #FUN-680135 SMALLINT  #FUN-5A0002
END GLOBALS
 
FUNCTION p_preview_path(ls_frm_name)
  DEFINE ls_frm_name STRING
  DEFINE ls_module   STRING
  DEFINE ls_checking STRING
  DEFINE ls_frm_path STRING
  DEFINE lc_gao01    LIKE gao_file.gao01
  DEFINE li_n        LIKE type_file.num5    #FUN-680135 SMALLINT
  DEFINE li_error    LIKE type_file.num5    #FUN-680135 SMALLINT
  DEFINE lc_gax02    LIKE gax_file.gax02    #FUN-5C0052
  DEFINE lc_zz011    LIKE zz_file.zz011     #FUN-5C0052
 
  # 2004/11/10 改寫系統判斷式
  LET ls_checking = ls_frm_name.toLowerCase()
  LET li_error = FALSE
  CASE
     # 1.當 frm_name 以 a or g 開頭時, 必為標準 package
     WHEN ls_checking.subString(1,1)="a" OR ls_checking.subString(1,1)="g"
        FOR li_n=3 TO ls_checking.getLength()
           LET ls_module = ls_checking.subString(1,li_n)
           LET lc_gao01 = UPSHIFT(ls_module.trim())
           SELECT gao01 FROM gao_file WHERE gao01=lc_gao01
           IF NOT SQLCA.SQLCODE THEN
              LET li_error=FALSE
              EXIT FOR
           ELSE
              LET li_error=TRUE
           END IF
        END FOR
        IF g_cust_flag = "Y" AND NOT li_error THEN
#          #MOD-590432
           IF ls_checking.subString(1,1)="a" THEN
              LET ls_module = "c" || ls_module.subString(2,ls_module.getLength())
           ELSE
              LET ls_module = "c" || ls_module.subString(1,ls_module.getLength())
           END IF
##         ##MOD-590432
        END IF
 
     # 2.當 frm_name 以 sa or sg 開頭時, 必為標準 package
     WHEN ls_checking.subString(1,2)="sa" OR ls_checking.subString(1,2)="sg"
        FOR li_n=4 TO ls_checking.getLength()
           LET ls_module = ls_checking.subString(2,li_n)
           LET lc_gao01 = UPSHIFT(ls_module.trim())
           SELECT gao01 FROM gao_file WHERE gao01=lc_gao01
           IF NOT SQLCA.SQLCODE THEN
              LET li_error=FALSE
              EXIT FOR
           ELSE
              LET li_error=TRUE
           END IF
        END FOR
        IF g_cust_flag = "Y" AND NOT li_error THEN
           LET ls_module = "c" || ls_module.subString(2,ls_module.getLength())
        END IF
 
     # 3.當 frm_name 以 sc 開頭時, 必為客製模組
     WHEN ls_checking.subString(1,2)="sc" 
        LET g_cust_flag = "Y"
        FOR li_n=4 TO ls_checking.getLength()
           LET ls_module = ls_checking.subString(2,li_n)
           LET lc_gao01 = UPSHIFT(ls_module.trim())
           SELECT gao01 FROM gao_file WHERE gao01=lc_gao01
           IF NOT SQLCA.SQLCODE THEN
              LET li_error=FALSE
              EXIT FOR
           ELSE
              LET li_error=TRUE
           END IF
        END FOR
 
     # 4.當 frm_name 以 p_ 開頭時, 必為 azz or czz
     WHEN ls_checking.subString(1,2)="p_" OR ls_checking.trim()="udm_tree" OR
          ls_checking.subString(1,8)="udm_tree" OR ls_checking.subString(1,7)="udmtree"   #No.FUN-570225
        IF g_cust_flag = "Y" THEN
           LET ls_module = "czz"
        ELSE
              LET lc_gax02 = ls_checking.trim()                #FUN-5C0052
              SELECT zz011 INTO lc_zz011 FROM zz_file,gax_file
               WHERE gax02 = lc_gax02 AND gax01 = zz01
              IF DOWNSHIFT(lc_zz011) = "ain" THEN
                 LET ls_module = "ain"
              ELSE
                 LET ls_module = "azz"
              END IF
        END IF
 
     # 5.當 frm_name 以 s_ 開頭時, 必為 sub or csub
     WHEN ls_checking.subString(1,2)="s_" 
        IF g_cust_flag = "Y" THEN
           LET ls_module = "csub"
        ELSE
           LET ls_module = "sub"
        END IF
 
     # 6.當 frm_name 以 q_ 開頭時, 必為 qry or cqry
     WHEN ls_checking.subString(1,2)="q_" 
        IF g_cust_flag = "Y" THEN
           LET ls_module = "cqry"
        ELSE
           LET ls_module = "qry"
        END IF
 
     # 3.當 frm_name 以 cl_or ccl_開頭時, 必為 lib or clib
     # 4.當 frm_name 以 cp_ 開頭時, 必為 czz
     # 5.當 frm_name 以 cs_ 開頭時, 必為 csub
     # 6.當 frm_name 以 cq_ 開頭時, 必為 cqry
     # 7.當 frm_name 以 c  or cg  開頭時,但非為 cl_或ccl_ 必為客製模組
     WHEN ls_checking.subString(1,1)="c" 
 
        CASE
           WHEN ls_checking.subString(2,3)="l_"
              IF g_cust_flag = "Y" THEN
                 LET ls_module = "clib"
              ELSE
                 LET ls_module = "lib"
              END IF
           WHEN ls_checking.subString(2,4)="cl_"
              LET g_cust_flag = "Y"
              LET ls_module = "clib"
           WHEN ls_checking.subString(2,3)="p_"
              LET g_cust_flag = "Y"
              LET ls_module = "czz"
           WHEN ls_checking.subString(2,3)="q_"
              LET g_cust_flag = "Y"
              LET ls_module = "cqry"
           WHEN ls_checking.subString(2,3)="s_"
              LET g_cust_flag = "Y"
              LET ls_module = "csub"
           OTHERWISE
              LET g_cust_flag = "Y"
              FOR li_n=3 TO ls_checking.getLength()
                 LET ls_module = ls_checking.subString(1,li_n)
                 LET lc_gao01 = UPSHIFT(ls_module.trim())
                 SELECT gao01 FROM gao_file WHERE gao01=lc_gao01
                 IF NOT SQLCA.SQLCODE THEN
                    LET li_error = FALSE
                    EXIT FOR
                 ELSE
                    LET li_error = TRUE
                 END IF
              END FOR
        END CASE
 
 
     OTHERWISE
        LET ls_frm_path = ""
 
  END CASE
 
  #LET ls_frm_path = os.Path.join(FGL_GETENV(UPSHIFT(ls_module.trim())),"4fd")   #FUN-B30038
  LET ls_frm_path = os.Path.join(DOWNSHIFT(ls_module.trim()),"4fd")  
  LET ls_frm_path = os.Path.join(ls_frm_path,ls_frm_name CLIPPED||".4fd")
  #DISPLAY "ls_frm_path:",ls_frm_path 
  RETURN ls_frm_path
   
END FUNCTION
 
 
 
