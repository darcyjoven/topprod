# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: s_chgdbs.4gl 
# Descriptions...: 轉換營運中心後Title要跟著換 
# Date & Author..: 11/01/06 BY sabroma 
# Modify.........: No:MOD-B10051 11/01/07 By sabrina create 

DATABASE ds      

GLOBALS "../../config/top.global"    

FUNCTION s_chgdbs()
   DEFINE   lc_zo02     LIKE zo_file.zo02,
            lc_zx02     LIKE zx_file.zx02,
            lc_zz02     LIKE zz_file.zz02,
            ls_ze031    LIKE type_file.chr1000,  #No.FUN-680135 CHAR(100)
            ls_ze032    LIKE type_file.chr1000,  #No.FUN-680135 CHAR(100)
            ls_msg      STRING,
            lwin_curr   ui.Window,
            l_sql       STRING,
            l_ch        base.channel,
            ls_tmp      STRING,
            lc_azz05    LIKE azz_file.azz05,
            lc_azp02    LIKE azp_file.azp02,
            lc_azp052   LIKE azp_file.azp052 

   # 選擇  使用者名稱(zx_file.zx02)
   LET l_sql="SELECT zx02 FROM zx_file WHERE zx01='",
             g_user CLIPPED,"'"
   PREPARE p_zta_set_win_tit_pre1 FROM l_sql
   EXECUTE p_zta_set_win_tit_pre1 INTO lc_zx02
   IF (SQLCA.SQLCODE) THEN
      LET lc_zx02 = g_user
   END IF
   FREE p_zta_set_win_tit_pre1

   CLOSE DATABASE
   DATABASE g_dbs
   IF (SQLCA.SQLCODE) THEN
      RETURN FALSE
   END IF

   # 選擇  程式名稱(gaz_file.gaz03)
   LET l_sql="SELECT gaz03 FROM gaz_file WHERE gaz01='",
             g_prog CLIPPED,"' AND gaz02='",g_lang CLIPPED,"'"
   PREPARE p_zta_set_win_tit_pre3 FROM l_sql
   EXECUTE p_zta_set_win_tit_pre3 INTO lc_zz02
   FREE p_zta_set_win_tit_pre3

   # 選擇  公司對內全名(zo_file.zo02)
   LET l_sql="SELECT zo02 FROM zo_file WHERE zo01='",
             g_lang CLIPPED,"'"
   PREPARE p_zta_set_win_tit_pre4 FROM l_sql
   EXECUTE p_zta_set_win_tit_pre4 INTO lc_zo02
   IF (SQLCA.SQLCODE) THEN
      LET lc_zo02 = "Empty"
   END IF
   FREE p_zta_set_win_tit_pre4

   LET l_sql="SELECT ze03 FROM ze_file WHERE ze01 = 'lib-035' AND ze02 = '",g_lang CLIPPED,"'"
   PREPARE p_zta_set_win_tit_pre5 FROM l_sql
   EXECUTE p_zta_set_win_tit_pre5 INTO ls_ze031
   FREE p_zta_set_win_tit_pre5
   LET l_sql="SELECT ze03 FROM ze_file WHERE ze01 = 'lib-036' AND ze02 = '",g_lang CLIPPED,"'"
   PREPARE p_zta_set_win_tit_pre6 FROM l_sql
   EXECUTE p_zta_set_win_tit_pre6 INTO ls_ze032
   FREE p_zta_set_win_tit_pre6

   # 時間顯示 (若開時區則加 show GMT表示式)  #FUN-920064
   LET ls_tmp = "  " || ls_ze031 CLIPPED || ":" || g_today CLIPPED 
   SELECT azz05 INTO lc_azz05 FROM azz_file WHERE azz01 = "0"
   IF lc_azz05 IS NOT NULL AND lc_azz05 = "Y" THEN
      SELECT azp02,azp052 INTO lc_azp02,lc_azp052 FROM azp_file WHERE azp03 = g_dbs
                                                                  AND azp01 = g_plant
      IF NOT SQLCA.SQLCODE THEN
        IF NOT cl_null(lc_azp052) THEN
           LET ls_tmp = ls_tmp.trimRight(),"(",lc_azp052 CLIPPED,")"
        END IF
      END IF
   END IF

   LET ls_msg = lc_zz02 CLIPPED, "(", g_prog CLIPPED, ")[", lc_zo02 CLIPPED, "][", g_plant CLIPPED,":",lc_azp02 CLIPPED, "] "
   LET ls_msg = ls_msg,"(", g_dbs CLIPPED, ")"
   LET ls_msg = ls_msg, "  ", ls_tmp CLIPPED, "  ", ls_ze032 CLIPPED, ":", lc_zx02 CLIPPED

   LET lwin_curr = ui.Window.getCurrent()
   CALL lwin_curr.setText(ls_msg)
END FUNCTION
#MOD-B10051
