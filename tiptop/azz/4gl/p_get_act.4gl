# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: p_get_act.4gl
# Descriptions...: 在TEXTMODE檢視4ad作業
# Date & Author..: 04/04/06 alex
# Modify.........: 04/04/16 By alex 將記錄欄位合併到 gak_file 中
# Modify.........: 04/05/27 By alex 將記錄欄位要獨立到 gap_file 中
# Modify.........: 04/06/03 By alex 規畫記錄退場機制
# Modify.........: No.MOD-490479 04/09/30 By alex 增加不控管記錄 以讓s_define_act分析
# Modify.........: No.FUN-570088 05/07/08 By alex 增加自動補入系統 action
# Modify.........: No.FUN-680135 06/08/31 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-770013 07/07/05 By alex 改為使用os.Path組路徑
 
IMPORT os     #FUN-770013
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
DEFINE gc_prog       LIKE zz_file.zz01
DEFINE gi_gal_count  LIKE type_file.num5     #FUN-680135 SMALLINT
DEFINE gi_gak_count  LIKE type_file.num5     #FUN-680135 SMALLINT
DEFINE gi_gap_count  LIKE type_file.num5     #FUN-680135 SMALLINT
DEFINE gi_type       LIKE type_file.num5     #FUN-680135 SMALLINT
DEFINE g_gap         DYNAMIC ARRAY OF RECORD
         gap02       LIKE gap_file.gap02,
         gap06       LIKE gap_file.gap06
                 END RECORD
MAIN
    DEFINE ls_compose    STRING
 
    LET gc_prog = ARG_VAL(1)
    LET gi_type = ARG_VAL(2)                      # Show Type 0:Show 1:Don't Show
 
    CALL g_gap.clear()
 
    IF gi_type IS NULL THEN LET gi_type=0 END IF
 
    # gak 是 link 的單頭 gal 是 link 的單身
    SELECT count(*) INTO gi_gal_count FROM gal_file WHERE gal01=gc_prog 
    SELECT count(*) INTO gi_gap_count FROM gap_file WHERE gap01=gc_prog 
    SELECT count(*) INTO gi_gak_count FROM gak_file WHERE gak01=gc_prog 
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
          IF gi_gap_count != 0 THEN
             BEGIN WORK
             DISPLAY 'Deleteing.....',gc_prog CLIPPED,' count:',gi_gap_count
             DELETE FROM gap_file WHERE gap01=gc_prog
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
 
    CALL p_get_act_select() 
 
    # 必需 gi_gak_count > 0 時才可以做更新
    IF gi_gak_count > 0 THEN
       CALL p_get_act_system_chk()                   #FUN-570088
       CALL p_get_act_compose() RETURNING ls_compose
       IF gi_type != 1 THEN
          DISPLAY ' '
          DISPLAY 'Action List: '
          DISPLAY ls_compose
          DISPLAY ' '
          DISPLAY 'Update ',gc_prog CLIPPED,' Data Succeed!'
       END IF
    END IF
 
 
END MAIN
 
# 抓取 gal (Link資料) 自動串接所有有寫在 link 檔裡的 4ad
 
FUNCTION p_get_act_select()
    DEFINE ls_subprog    STRING
    DEFINE ls_sub_act    STRING
    DEFINE ls_sub_ctl    STRING
    DEFINE ls_compose    STRING
    DEFINE ls_sql        STRING
    DEFINE li_temp       LIKE type_file.num5     #FUN-680135 SMALLINT
    DEFINE l_gal         RECORD
             gal02       LIKE gal_file.gal02,
             gal03       LIKE gal_file.gal03
                     END RECORD
 
    # 2004/04/06 新增抓取 gal (Link資料) 自動串接所有有寫在 link 檔裡的 4ad
    LET ls_sql = " SELECT gal02,gal03 FROM gal_file ",
                  " WHERE gal01='",gc_prog CLIPPED,"'"
 
    LET ls_compose=""
    LET li_temp = 1
 
    PREPARE p_get_act_gal_pre FROM ls_sql
    DECLARE p_get_act_gal_cs CURSOR FOR p_get_act_gal_pre
    FOREACH p_get_act_gal_cs INTO l_gal.*
 
       LET ls_subprog = fgl_getenv(l_gal.gal02)
 
#      #FUN-770013
#      LET ls_subprog = ls_subprog.trim(),"/4gl/",l_gal.gal03 CLIPPED,".4gl"
       LET ls_subprog = os.Path.join( os.Path.join(ls_subprog.trim(),"4gl"),
                                      l_gal.gal03 CLIPPED || ".4gl" )
 
       IF gi_type != 1 THEN
          DISPLAY "Part ",li_temp CLIPPED," of ",gi_gal_count CLIPPED,"...",ls_subprog
       END IF
 
       CALL p_get_act_s(ls_subprog) RETURNING ls_sub_act,ls_sub_ctl
       CALL p_get_act_bfill(ls_sub_act)
       CALL p_get_act_cfill(ls_sub_ctl)
       LET li_temp=li_temp+1
    END FOREACH
 
    RETURN 
 
END FUNCTION
 
FUNCTION p_get_act_bfill(ls_waitcut)
 
    DEFINE ls_waitcut      STRING
    DEFINE lst_act         base.StringTokenizer,
           ls_act          STRING
    DEFINE li_array_length LIKE type_file.num5     #FUN-680135 SMALLINT
    DEFINE li_i            LIKE type_file.num5     #FUN-680135 SMALLINT
 
   LET lst_act = base.StringTokenizer.create(ls_waitcut CLIPPED, ", ")
 
   # 抓取總數
   LET li_array_length = g_gap.getLength()
 
   WHILE lst_act.hasMoreTokens()
      LET ls_act = lst_act.nextToken()
      LET ls_act = ls_act.trim()
 
      FOR li_i=1 TO li_array_length
         IF ls_act = g_gap[li_i].gap02 THEN
            CONTINUE WHILE
         END IF
      END FOR
      LET li_array_length = li_array_length + 1
      LET g_gap[li_array_length].gap02=ls_act
      LET g_gap[li_array_length].gap06="N"
   END WHILE
 
   RETURN
 
END FUNCTION
 
# 2004/09/30 Controled Item Fill into Dynamic Array
 
FUNCTION p_get_act_cfill(ls_waitcut)
 
    DEFINE ls_waitcut      STRING
    DEFINE lst_act         base.StringTokenizer,
           ls_act          STRING
    DEFINE li_array_length LIKE type_file.num5     #FUN-680135 SMALLINT
    DEFINE li_i            LIKE type_file.num5     #FUN-680135 SMALLINT
 
   LET lst_act = base.StringTokenizer.create(ls_waitcut CLIPPED, ", ")
 
   # 抓取總數
   LET li_array_length = g_gap.getLength()
 
   WHILE lst_act.hasMoreTokens()
      LET ls_act = lst_act.nextToken()
      LET ls_act = ls_act.trim()
 
      FOR li_i=1 TO li_array_length
         IF ls_act = g_gap[li_i].gap02 THEN
            LET g_gap[li_i].gap06 = "Y"
         END IF
      END FOR
   END WHILE
   RETURN
END FUNCTION
 
 
# 2004/06/03 函式定義變更為
#            合併查到的東西再一個個比對 gap_file中是否存在
FUNCTION p_get_act_compose()
 
    DEFINE li_count      LIKE type_file.num5     #FUN-680135 SMALLINT
    DEFINE li_temp       LIKE type_file.num5     #FUN-680135 SMALLINT
    DEFINE ls_compose    STRING
 
    LET ls_compose = ""
    FOR li_count=1 TO g_gap.getLength()
       # 不為空值時可變更
       IF NOT cl_null(g_gap[li_count].gap02) THEN
          #檢核gap中是否存在此筆資料
          SELECT COUNT(*) INTO li_temp FROM gap_file WHERE gap01=gc_prog
             AND gap02=g_gap[li_count].gap02
          CASE
             WHEN li_temp=0
                # 2004/06/15 如果抓到的是 detail 則自動給單身核取="Y"
                IF g_gap[li_count].gap02 = "detail" THEN
                   INSERT INTO gap_file (gap01,gap02,gap03,gap04,gap05,gap06)
                    VALUES (gc_prog, "detail", "R","Y","N","Y")
                ELSE
                   INSERT INTO gap_file (gap01,gap02,gap03,gap04,gap05,gap06)
                    VALUES (gc_prog, g_gap[li_count].gap02, "R","N","N",
                                     g_gap[li_count].gap06)
                END IF
             WHEN li_temp=1
                UPDATE gap_file SET gap03="R",gap06=g_gap[li_count].gap06
                 WHERE gap01=gc_prog
                   AND gap02=g_gap[li_count].gap02
             OTHERWISE CONTINUE FOR
          END CASE
 
          LET ls_compose=ls_compose,g_gap[li_count].gap02 CLIPPED,", "
       END IF
    END FOR
 
    #砍除N指標未變成R的部份
    DELETE FROM gap_file WHERE gap01=gc_prog AND gap03="N"
 
    #更新指標R回到N
    UPDATE gap_file SET gap03="N" WHERE gap01=gc_prog AND gap03="R"
 
    #請注意:在上述機制下,若有系統中ACT被寫入程式ACT,則會自動轉換為N
    #       若無則不予理會指標為Y部份
 
    LET ls_compose=ls_compose.subString(1,ls_compose.getLength()-2)
 
    RETURN ls_compose
END FUNCTION
 
FUNCTION p_get_act_system_chk()    #FUN-570088
 
   DEFINE li_array_length LIKE type_file.num5     #FUN-680135 SMALLINT
   DEFINE li_i            LIKE type_file.num5     #FUN-680135 SMALLINT
   DEFINE lc_chk          LIKE type_file.chr3     #FUN-680135 VARCHAR(3)
 
   # 抓取總數
   LET li_array_length = g_gap.getLength()
   LET lc_chk="NNN"
   FOR li_i = 1 TO li_array_length
      CASE g_gap[li_i].gap02
         WHEN "accept" LET lc_chk[1] = "Y"
         WHEN "cancel" LET lc_chk[2] = "Y"
         WHEN "exit"   LET lc_chk[3] = "Y"
         OTHERWISE     CONTINUE FOR
      END CASE
   END FOR
 
   IF lc_chk[1] = "N" THEN
      LET li_array_length = g_gap.getLength() + 1
      LET g_gap[li_array_length].gap02="accept"
      LET g_gap[li_array_length].gap06="N"
   END IF
   IF lc_chk[2] = "N" THEN
      LET li_array_length = g_gap.getLength() + 1
      LET g_gap[li_array_length].gap02="cancel"
      LET g_gap[li_array_length].gap06="N"
   END IF
   IF lc_chk[3] = "N" THEN
      LET li_array_length = g_gap.getLength() + 1
      LET g_gap[li_array_length].gap02="exit"
      LET g_gap[li_array_length].gap06="N"
   END IF
 
   RETURN
 
END FUNCTION
