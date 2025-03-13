# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: p_get_ze.4gl
# Descriptions...: 在TEXTMODE檢視ze使用種類作業 (只做資料輸出，不存檔)
# Date & Author..: 10/10/05 alex #FUN-B20036
# Modify.........: 
 
IMPORT os 
DATABASE ds
 
DEFINE gc_prog       LIKE zz_file.zz01
DEFINE gi_gal_count  LIKE type_file.num5 
DEFINE gi_gak_count  LIKE type_file.num5  
DEFINE gi_gap_count  LIKE type_file.num5  
DEFINE gi_type       LIKE type_file.num5  
DEFINE g_result      STRING

MAIN   #FUN-B20036
    LET gc_prog = ARG_VAL(1)
    LET gi_type = ARG_VAL(2)                          #Show Type 0:Show all 1:Output for where condiction

    IF gi_type IS NULL THEN LET gi_type=0 END IF
 
    # gak 是 link 的單頭 gal 是 link 的單身
    SELECT count(*) INTO gi_gal_count FROM gal_file WHERE gal01=gc_prog 
    SELECT count(*) INTO gi_gap_count FROM gap_file WHERE gap01=gc_prog 
    SELECT count(*) INTO gi_gak_count FROM gak_file WHERE gak01=gc_prog 
    IF gi_gal_count <= 0 OR gi_gak_count <= 0 THEN
          DISPLAY gc_prog CLIPPED,' NOT Existed in Link Data!'
       EXIT PROGRAM
    ELSE
       IF NOT gi_type THEN
          DISPLAY ' '
          DISPLAY 'Analying.....',gc_prog
          DISPLAY ' '
       END IF
    END IF
 
    CALL p_get_ze_select() 
 
    LET g_result = g_result.trim()
    LET g_result = g_result.subString(1,g_result.getLength()-1)

    # 必需 gi_gak_count > 0 時才可以做更新
    IF gi_gak_count > 0 THEN
       IF NOT gi_type THEN
          DISPLAY ' '
          DISPLAY 'Error Item List: '
          DISPLAY g_result
          DISPLAY ' '
       ELSE
          DISPLAY g_result
       END IF
    END IF
 
 
END MAIN
 
# 抓取 gal (Link資料) 自動串接所有有寫在 link 檔裡的 4ad
FUNCTION p_get_ze_select()
    DEFINE ls_subprog    STRING
    DEFINE ls_sub_ze     STRING
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
 
    PREPARE p_get_ze_gal_pre FROM ls_sql
    DECLARE p_get_ze_gal_cs CURSOR FOR p_get_ze_gal_pre
    FOREACH p_get_ze_gal_cs INTO l_gal.*
 
       LET ls_subprog = fgl_getenv(l_gal.gal02)
 
       LET ls_subprog = os.Path.join( os.Path.join(ls_subprog.trim(),"4gl"),
                                      l_gal.gal03 CLIPPED || ".4gl" )
 
      
       IF NOT gi_type THEN
          DISPLAY "Part ",li_temp CLIPPED," of ",gi_gal_count CLIPPED,"...",ls_subprog
       END IF
 
       CALL p_get_ze_s(ls_subprog) RETURNING ls_sub_ze
       CALL p_get_ze_fill(ls_sub_ze)
       LET li_temp = li_temp + 1
    END FOREACH
 
    RETURN 
 
END FUNCTION
 
 
 
FUNCTION p_get_ze_fill(ls_waitcut)
 
    DEFINE ls_waitcut      STRING
    DEFINE lst_act         base.StringTokenizer,
           ls_act          STRING
    DEFINE li_array_length LIKE type_file.num5     #FUN-680135 SMALLINT
    DEFINE li_i            LIKE type_file.num5     #FUN-680135 SMALLINT
 
   LET lst_act = base.StringTokenizer.create(ls_waitcut CLIPPED, ",")
 
   WHILE lst_act.hasMoreTokens()
      LET ls_act = lst_act.nextToken()
      LET ls_act = ls_act.trim(),","

      IF NOT g_result.getIndexOf(ls_act,1) THEN
         IF NOT gi_type THEN
            LET g_result = g_result,ls_act," "
         ELSE
            LET g_result = g_result,"'",ls_act.subString(1,ls_act.getLength()-1),"', "
         END IF
      END IF
   END WHILE

   RETURN
END FUNCTION
 
