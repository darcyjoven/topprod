# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: p_get_lib.4gl
# Descriptions...: 在TEXTMODE抓取函式說明 
# Date & Author..: 07/07/05 alex    #FUN-760087
# Modify.........: No.FUN-770018 07/07/06 By alex 放大欄寬及加入private func
# Modify.........: No.MOD-770047 07/07/11 By alex 修正單支SUB抓取功能
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-C60064 12/07/04 by madey修正安全機制程式的函式資料若已存在hjb_file時會因重跑p_get_lib lib被刪除
 
IMPORT os
DATABASE ds
 
DEFINE gc_prog       LIKE type_file.chr50
DEFINE gi_gal_count  LIKE type_file.num5     #FUN-680135 SMALLINT
DEFINE gi_gak_count  LIKE type_file.num5     #FUN-680135 SMALLINT
DEFINE gi_type       LIKE type_file.num5     #FUN-770018 SMALLINT
 
MAIN
   DEFINE li_gal_count  LIKE type_file.num5     #FUN-760087 SMALLINT
   DEFINE li_tmp_count  LIKE type_file.num5     #FUN-760087 SMALLINT
 
   LET gc_prog = ARG_VAL(1)
   LET gi_type = ARG_VAL(2)# Show Type 0:Show 1:Don't Show
 
   IF gc_prog IS NULL or gc_prog CLIPPED = "" THEN
      DISPLAY ""
      DISPLAY "Usage: r.r2 p_get_lib PROGRAMID"
      DISPLAY "PROGRAMID: lib/sub OR any single program id in lib/sub modules."
      DISPLAY ""
      EXIT PROGRAM
   END IF
 
   IF gi_type IS NULL THEN LET gi_type=0 END IF
 
   # gak 是 link 的單頭 gal 是 link 的單身
   SELECT count(*) INTO gi_gal_count FROM gal_file
    WHERE gal01=gc_prog AND (gal01='lib' OR gal01='sub')
   SELECT count(*) INTO gi_gak_count FROM gak_file
    WHERE gak01=gc_prog 
   IF gi_gal_count <= 0 OR gi_gak_count <= 0 THEN
      IF gi_type != 1 THEN
         DISPLAY "WARNING: ",gc_prog CLIPPED,' not menas lib/sub. '
      ELSE
         CALL cl_err(gc_prog CLIPPED,"azz-027",1)
      END IF
      SELECT COUNT(*) INTO li_gal_count FROM gal_file 
       WHERE gal03=gc_prog AND (gal01="lib" OR gal01='sub')   #MOD-770047
      IF li_gal_count = 1 THEN
         SELECT COUNT(*) INTO li_tmp_count FROM gal_file 
          WHERE gal03=gc_prog AND gal01="lib" 
         IF li_tmp_count = 1 THEN
            CALL p_get_lib_do("LIB",gc_prog)
         ELSE
            CALL p_get_lib_do("SUB",gc_prog)    #MOD-770047
         END IF
      ELSE
         IF gi_type != 1 THEN
            DISPLAY "ERROR  : ",gc_prog CLIPPED,' NOT belong in lib/sub!'
         END IF
         EXIT PROGRAM
      END IF
      IF gi_type != 1 THEN
         DISPLAY "MESSAGE: ",gc_prog CLIPPED,' update succesfully !'
      END IF
   ELSE
      CALL p_get_lib_select()
   END IF
 
END MAIN
 
 
# 抓取 gal (Link資料) 自動串接所有有寫在 link 檔裡的 4ad
 
FUNCTION p_get_lib_select()
   DEFINE ls_path       STRING
   DEFINE ls_sql        STRING
   DEFINE li_temp       LIKE type_file.num5     #FUN-680135 SMALLINT
   DEFINE l_gal         RECORD
            gal02       LIKE gal_file.gal02,
            gal03       LIKE gal_file.gal03
                    END RECORD
 
   # 2004/04/06 新增抓取 gal (Link資料) 自動串接所有有寫在 link 檔裡的 4ad
   LET ls_sql = " SELECT gal02,gal03 FROM gal_file ",
                 " WHERE gal01='",gc_prog CLIPPED,"'"
 
   LET li_temp = 1
 
   PREPARE p_get_lib_gal_pre FROM ls_sql
   DECLARE p_get_lib_gal_cs CURSOR FOR p_get_lib_gal_pre
   FOREACH p_get_lib_gal_cs INTO l_gal.*
 
      LET ls_path = fgl_getenv(l_gal.gal02)
      LET ls_path = os.Path.join( os.Path.join(ls_path.trim(),"4gl"),
                               l_gal.gal03 CLIPPED||".4gl")
      IF gi_type != 1 THEN
         DISPLAY "Part ",li_temp CLIPPED," of ",gi_gal_count CLIPPED,"...",ls_path
      END IF
 
      CALL p_get_lib_do(l_gal.gal02,l_gal.gal03)
 
      LET li_temp=li_temp+1
   END FOREACH
 
   RETURN
 
END FUNCTION
 
 
FUNCTION p_get_lib_do(lc_gal02, lc_gal03)
 
   DEFINE lc_gal02  LIKE gal_file.gal02
   DEFINE lc_gal03  LIKE gal_file.gal03
   DEFINE ls_path   STRING
   DEFINE li_count      LIKE type_file.num5     #FUN-680135 SMALLINT
 
   LET ls_path = fgl_getenv(lc_gal02)
   LET ls_path = os.Path.join( os.Path.join(ls_path.trim(),"4gl"),
                               lc_gal03 CLIPPED||".4gl")
   #埋入退場機制 hjb03
   SELECT COUNT(*) INTO li_count FROM hjb_file
    WHERE hjb01 = lc_gal03 
 
   #IF li_count > 0 THEN #mark by FUN-C60064
   IF li_count > 0 AND os.Path.exists(ls_path.trim()) THEN #FUN-C60064 因應安全機制設計,若不存在則不埋入退場機制
      UPDATE hjb_file SET hjb03 = "N" WHERE hjb01 = lc_gal03 
   END IF
 
   CALL p_get_lib_s(lc_gal03 CLIPPED,ls_path.trim())
 
   SELECT COUNT(*) INTO li_count FROM hjb_file
    WHERE hjb01 = lc_gal03 AND hjb03 = "N"
   IF li_count > 0 THEN
      DELETE FROM hjb_file
       WHERE hjb01 = lc_gal03 AND hjb03 = "N"
   END IF
 
END FUNCTION
