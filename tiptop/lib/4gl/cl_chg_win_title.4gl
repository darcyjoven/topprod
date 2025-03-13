# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Library name...: cl_chg_win_title.4gl
# Descriptions...: 設定視窗Title
# Memo...........: 附加基本資訊(User,DB...)後, 改變程式名稱的部份
# Input parameter: ps_str  STRING  視窗title顯示字串
# Return code....: none
# Usage..........: CALL cl_chg_win_title("Warning!")
# Date & Author..: 2007/01/01 by saki
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-7C0045 07/12/14 By alex 修改說明
# Modify.........: No.MOD-C30123 12/03/12 By madey 修正l_msg格式與cl_cl_ui_init.4gl一致
# Modify.........: No.MOD-C40107 12/04/17 By madey 修正取時區(azp052)時的where condition

 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0045
 
FUNCTION cl_chg_win_title(ps_str)
   DEFINE   ps_str      STRING
   DEFINE   lc_zo02     LIKE zo_file.zo02, 
            lc_zx02     LIKE zx_file.zx02, 
            lc_zz03     LIKE zz_file.zz03,
            lc_zz02     LIKE zz_file.zz02,
            lc_zz25     LIKE zz_file.zz25
   DEFINE   ls_msg      STRING,
            lwin_curr   ui.Window
   DEFINE   ls_ze031    LIKE ze_file.ze03,    #No.FUN-690005 VARCHAR(100)
            ls_ze032    LIKE ze_file.ze03,    #No.FUN-690005 VARCHAR(100)
            ls_ze033    LIKE ze_file.ze03     #No.FUN-690005 VARCHAR(100)
   DEFINE   lc_zz011    LIKE zz_file.zz011    #MOD-C30123	  
   DEFINE   lc_azz05    LIKE azz_file.azz05   #MOD-C30123  
   DEFINE   lc_azp052   LIKE azp_file.azp052  #MOD-C30123
   DEFINE   lc_azp02    LIKE azp_file.azp02   #MOD-C30123
    
   SELECT zo02 INTO lc_zo02 FROM zo_file WHERE zo01 = g_lang
   IF (SQLCA.SQLCODE) THEN
      LET lc_zo02 = "Empty"
   END IF

    # 選擇 程式模組(zz_file.zz011) #是否為客製程式 #MOD-C30123 
   SELECT zz011 INTO lc_zz011 FROM zz_file WHERE zz01=g_prog
   LET ls_ze031=""
   IF lc_zz011[1]="C" THEN
      SELECT ze03 INTO ls_ze031 FROM ze_file
       WHERE ze01 = 'lib-051' AND ze02 = g_lang
   END IF

   # 選擇  使用者名稱(zx_file.zx02)
   SELECT zx02 INTO lc_zx02 FROM zx_file WHERE zx01 = g_user
   IF (SQLCA.SQLCODE) THEN
      LET lc_zx02 = g_user
   END IF
 
   # 選擇  程式類別(zz_file.zz03) Explain SW (zz_file.zz25)
   SELECT zz03,zz25 INTO lc_zz03,lc_zz25 FROM zz_file WHERE zz01 = g_prog
 
   # 選擇  程式名稱(gaz_file.gaz03)
#  SELECT gaz03 INTO lc_zz02 FROM gaz_file WHERE gaz01 = g_prog AND gaz02 = g_lang
 
   # 選擇 營運中心說明(azp_file.azp02) #No.MOD-C30123 add
   SELECT azp02 INTO lc_azp02 FROM azp_file WHERE azp01 = g_plant 

  #LET ls_msg = ps_str CLIPPED || "(" || g_prog CLIPPED || ")  [" || lc_zo02 CLIPPED || "]" || "(" || g_dbs CLIPPED || ")" #MOD-C30123 mark
   LET ls_msg = ps_str CLIPPED , "(" , g_prog CLIPPED , ls_ze031 CLIPPED , ")[" , lc_zo02 CLIPPED , "][" , g_plant CLIPPED , ":" , lc_azp02 CLIPPED , "](" , g_dbs CLIPPED , ")" #MOD-C30123 
      
   SELECT ze03 INTO ls_ze031 FROM ze_file WHERE ze01 = 'lib-035' AND ze02 = g_lang
   SELECT ze03 INTO ls_ze032 FROM ze_file WHERE ze01 = 'lib-036' AND ze02 = g_lang
 
   #LET ls_msg = ls_msg || "  " || ls_ze031 CLIPPED || ":" || g_today || "  " || ls_ze032 CLIPPED || ":" || lc_zx02 CLIPPED #MOD-C30123 mark
   #MOD-C30123 start ---    # 時間顯示 (若開時區則加 show GMT表示式)
   LET ls_msg = ls_msg , "  " , ls_ze031 CLIPPED , ":" , g_today CLIPPED
   SELECT azz05 INTO lc_azz05 FROM azz_file WHERE azz01 = "0"                                                                                                   
   IF lc_azz05 IS NOT NULL AND lc_azz05 = "Y" THEN
      #SELECT azp052 INTO lc_azp052 FROM azp_file WHERE azp03 = g_dbs  #MOD-C40107 mark
      SELECT azp052 INTO lc_azp052 FROM azp_file WHERE azp01 = g_plant #MOD-C40107
      IF NOT SQLCA.SQLCODE THEN
        IF NOT cl_null(lc_azp052) THEN
           LET ls_msg = ls_msg.trimRight(),"(",lc_azp052 CLIPPED,")"
        END IF
      END IF
   END IF 
   LET ls_msg = ls_msg , "  " , ls_ze032 CLIPPED , ":" , lc_zx02 CLIPPED
   #MOD-C30123 end ---

 
   LET lwin_curr = ui.window.getCurrent()
   CALL lwin_curr.setText(ls_msg)
 
END FUNCTION
