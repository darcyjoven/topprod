# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: p_get_zr.4gl
# Descriptions...: 在TEXTMODE檢視及建立程式及檔案關連作業
# Date & Author..: 05/07/10 alex
# Modify.........: No.FUN-570131 05/07/20 By alex 刪除 CREATE TEMP TABLE
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-770013 07/07/05 By alex 改為使用 os.Path組路徑
 
IMPORT os     #FUN-770013
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
DEFINE gc_prog       LIKE zz_file.zz01
DEFINE gi_gal_count  LIKE type_file.num5     #FUN-680135 SMALLINT  
DEFINE gi_gak_count  LIKE type_file.num5     #FUN-680135 SMALLINT 
DEFINE gi_zr_count   LIKE type_file.num5     #FUN-680135 SMALLINT 
DEFINE gi_type       LIKE type_file.num5     #FUN-680135 SMALLINT 
DEFINE g_zr         DYNAMIC ARRAY OF RECORD
         zr02       LIKE zr_file.zr02,
         zr03       LIKE zr_file.zr03
                 END RECORD
MAIN
    DEFINE ls_s,ls_u,ls_i,ls_d    STRING
 
    LET gc_prog = ARG_VAL(1)
    LET gi_type = ARG_VAL(2)                      # Show Type 0:Show 1:Don't Show
 
    CALL g_zr.clear()
 
    IF gi_type IS NULL THEN LET gi_type=0 END IF
 
    # gak 是 link 的單頭 gal 是 link 的單身
    SELECT count(*) INTO gi_gal_count FROM gal_file WHERE gal01=gc_prog 
    SELECT count(*) INTO gi_gak_count FROM gak_file WHERE gak01=gc_prog 
    SELECT count(*) INTO gi_zr_count  FROM zr_file  WHERE zr01=gc_prog 
    IF gi_gal_count <= 0 OR gi_gak_count <= 0 THEN
       IF gi_type != 1 THEN
          DISPLAY gc_prog CLIPPED,' NOT Existed in Link Data!'
       ELSE
          CALL cl_err(gc_prog CLIPPED,"azz-027",1)
       END IF
       EXIT PROGRAM
    ELSE
       #退場機制
       IF gi_type = 444 THEN
          IF gi_zr_count != 0 THEN
             BEGIN WORK
             DISPLAY 'Deleteing.....',gc_prog CLIPPED,' count:',gi_zr_count
             DELETE FROM zr_file WHERE zr01=gc_prog
             IF STATUS THEN
                ROLLBACK WORK
                DISPLAY 'Deleteing ',gc_prog CLIPPED,' Fail! Rollback...'
             ELSE
                DISPLAY 'Deleteing ',gc_prog CLIPPED,' Succeed!'
                COMMIT WORK
             END IF
             EXIT PROGRAM
          ELSE
             DISPLAY ' Info: ',gc_prog CLIPPED,' NOT Existed!' 
             EXIT PROGRAM
          END IF
       END IF
       IF gi_type != 1 THEN
          DISPLAY ' '
          DISPLAY 'Analying.....',gc_prog
          DISPLAY ' '
       END IF
    END IF
 
    CALL p_get_zr_select() 
 
    # 必需 gi_gak_count > 0 時才可以做更新
    IF gi_gak_count > 0 THEN
       CALL p_get_zr_compose() RETURNING ls_s,ls_u,ls_i,ls_d
       IF gi_type != 1 THEN
          DISPLAY ' '
          DISPLAY 'SELECT: ',ls_s
          DISPLAY 'UPDATE: ',ls_u
          DISPLAY 'INSERT: ',ls_i
          DISPLAY 'DELETE: ',ls_d
          DISPLAY ' '
          DISPLAY 'Update ',gc_prog CLIPPED,' Data Succeed!'
       END IF
    END IF
 
 
END MAIN
 
# 抓取 gal (Link資料) 自動串接所有有寫在 link 檔裡的 4ad
 
FUNCTION p_get_zr_select()
    DEFINE ls_subprog    STRING
    DEFINE ls_select     STRING
    DEFINE ls_update     STRING
    DEFINE ls_insert     STRING
    DEFINE ls_delete     STRING
    DEFINE ls_tmplist    STRING
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
 
    PREPARE p_get_zr_gal_pre FROM ls_sql
    DECLARE p_get_zr_gal_cs CURSOR FOR p_get_zr_gal_pre
    FOREACH p_get_zr_gal_cs INTO l_gal.*
 
       LET ls_subprog = fgl_getenv(l_gal.gal02)
 
#      #FUN-770013
#      LET ls_subprog = ls_subprog.trim(),"/4gl/",l_gal.gal03 CLIPPED,".4gl"
       LET ls_subprog = os.Path.join( os.Path.join(ls_subprog.trim(),"4gl"),
                                      l_gal.gal03 CLIPPED||".4gl" )
 
       IF gi_type != 1 THEN
          DISPLAY "Part ",li_temp CLIPPED," of ",gi_gal_count CLIPPED,"...",ls_subprog
       END IF
 
       CALL p_get_zr_s(ls_subprog) RETURNING ls_select,ls_update,ls_insert,ls_delete,ls_tmplist
 
       CALL p_get_zr_bfill("S",ls_select)
       CALL p_get_zr_bfill("U",ls_update)
       CALL p_get_zr_bfill("I",ls_insert)
       CALL p_get_zr_bfill("D",ls_delete)
 
       CALL p_get_zr_kfill(ls_tmplist)
       LET li_temp=li_temp+1
    END FOREACH
 
    RETURN 
 
END FUNCTION
 
FUNCTION p_get_zr_bfill(lc_type,ls_waitcut)
 
    DEFINE lc_type         LIKE type_file.chr1     #FUN-680135 VARCHAR(1)
    DEFINE ls_waitcut      STRING
    DEFINE lst_act         base.StringTokenizer,
           ls_act          STRING
    DEFINE li_array_length LIKE type_file.num5     #FUN-680135 SMALLINT 
    DEFINE li_i            LIKE type_file.num5     #FUN-680135 SMALLINT 
 
   LET lst_act = base.StringTokenizer.create(ls_waitcut CLIPPED, ", ")
 
   # 抓取總數
   LET li_array_length = g_zr.getLength()
 
   WHILE lst_act.hasMoreTokens()
      LET ls_act = lst_act.nextToken()
      LET ls_act = ls_act.trim()
 
      FOR li_i=1 TO li_array_length
         IF ls_act = g_zr[li_i].zr02 AND g_zr[li_i].zr03 = lc_type THEN
            CONTINUE WHILE
         END IF
      END FOR
      LET li_array_length = li_array_length + 1
      LET g_zr[li_array_length].zr02=ls_act.trim()
      LET g_zr[li_array_length].zr03=lc_type
 
   END WHILE
 
   RETURN
 
END FUNCTION
 
 
FUNCTION p_get_zr_kfill(ls_waitcut)
 
    DEFINE ls_waitcut      STRING
    DEFINE lst_act         base.StringTokenizer,
           ls_act          STRING
    DEFINE li_array_length LIKE type_file.num5     #FUN-680135 SMALLINT 
    DEFINE li_i            LIKE type_file.num5     #FUN-680135 SMALLINT 
 
   LET lst_act = base.StringTokenizer.create(ls_waitcut CLIPPED, ", ")
 
   # 抓取總數
   LET li_array_length = g_zr.getLength()
 
   WHILE lst_act.hasMoreTokens()
      LET ls_act = lst_act.nextToken()
      LET ls_act = ls_act.trim()
 
      FOR li_i=1 TO li_array_length
         IF ls_act = g_zr[li_i].zr02 THEN
            CALL g_zr.deleteElement(li_i)
         END IF
      END FOR
 
   END WHILE
 
   RETURN
 
END FUNCTION
 
# 2004/06/03 函式定義變更為
#            合併查到的東西再一個個比對 zr_file中是否存在
FUNCTION p_get_zr_compose()
 
    DEFINE li_count      LIKE type_file.num5     #FUN-680135 SMALLINT 
    DEFINE li_temp       LIKE type_file.num5     #FUN-680135 SMALLINT 
    DEFINE ls_s,ls_u     STRING
    DEFINE ls_i,ls_d     STRING
 
    LET ls_s = ""   LET ls_u = ""
    LET ls_i = ""   LET ls_d = ""
 
    FOR li_count=1 TO g_zr.getLength()
 
       # 不為空值時可變更
       IF NOT cl_null(g_zr[li_count].zr02) THEN
          #檢核zr中是否存在此筆資料
          SELECT COUNT(*) INTO li_temp FROM zr_file WHERE zr01=gc_prog
             AND zr02=g_zr[li_count].zr02
             AND zr03=g_zr[li_count].zr03
 
          CASE
             WHEN li_temp=0 
                CASE g_zr[li_count].zr03
                   WHEN "S"
                      INSERT INTO zr_file (zr01,zr02,zr03)
                             VALUES (gc_prog,g_zr[li_count].zr02,"T")
                   WHEN "U"
                      INSERT INTO zr_file (zr01,zr02,zr03)
                             VALUES (gc_prog,g_zr[li_count].zr02,"V")
                   WHEN "I"
                      INSERT INTO zr_file (zr01,zr02,zr03)
                             VALUES (gc_prog,g_zr[li_count].zr02,"J")
                   WHEN "D"
                      INSERT INTO zr_file (zr01,zr02,zr03)
                             VALUES (gc_prog,g_zr[li_count].zr02,"E")
                END CASE
             WHEN li_temp=1 
                CASE g_zr[li_count].zr03
                   WHEN "S"
                      UPDATE zr_file SET zr03="T" WHERE zr01=gc_prog
                         AND zr02=g_zr[li_count].zr02 AND zr03="S"
                   WHEN "U"
                      UPDATE zr_file SET zr03="V" WHERE zr01=gc_prog
                         AND zr02=g_zr[li_count].zr02 AND zr03="U"
                   WHEN "I"
                      UPDATE zr_file SET zr03="J" WHERE zr01=gc_prog
                         AND zr02=g_zr[li_count].zr02 AND zr03="I"
                   WHEN "D"
                      UPDATE zr_file SET zr03="E" WHERE zr01=gc_prog
                         AND zr02=g_zr[li_count].zr02 AND zr03="D"
                END CASE
             OTHERWISE CONTINUE FOR
          END CASE
 
          CASE g_zr[li_count].zr03
             WHEN "S"
                LET ls_s=g_zr[li_count].zr02 CLIPPED,", ",ls_s
             WHEN "U"                                         
                LET ls_u=g_zr[li_count].zr02 CLIPPED,", ",ls_u
             WHEN "I"                                         
                LET ls_i=g_zr[li_count].zr02 CLIPPED,", ",ls_i
             WHEN "D"                                         
                LET ls_d=g_zr[li_count].zr02 CLIPPED,", ",ls_d
          END CASE
       END IF
    END FOR
 
    #砍除SUID指標未變成TVJE的部份
    DELETE FROM zr_file WHERE zr01=gc_prog
       AND (zr03="S" OR zr03="U" OR zr03="I" OR zr03="D" )
 
    #更新指標TVJE回到SUID
    UPDATE zr_file SET zr03="S" WHERE zr01=gc_prog AND zr03="T"
    UPDATE zr_file SET zr03="U" WHERE zr01=gc_prog AND zr03="V"
    UPDATE zr_file SET zr03="I" WHERE zr01=gc_prog AND zr03="J"
    UPDATE zr_file SET zr03="D" WHERE zr01=gc_prog AND zr03="E"
 
    LET ls_s=ls_s.subString(1,ls_s.getLength()-2)
    LET ls_u=ls_u.subString(1,ls_u.getLength()-2)
    LET ls_i=ls_i.subString(1,ls_i.getLength()-2)
    LET ls_d=ls_d.subString(1,ls_d.getLength()-2)
 
    RETURN ls_s.trim(),ls_u.trim(),ls_i.trim(),ls_d.trim()
END FUNCTION
 
