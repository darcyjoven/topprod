# Prog. Version..: '5.30.07-13.06.07(00008)'     #
#
# Pattern name...: s_locchk.4gl
# Descriptions...: 檢查儲位的使用
# Date & Author..: 91/10/04 By Lee
# Usage..........: CALL s_locchk(p_part,p_ware,p_loc) RETURNING l_flag,l_act
# Input Parameter: p_part 料件編號
#                  p_ware 欲檢查之倉庫	 
#                  p_loc  欲檢查之儲位
# Return code....: l_falg 1:Yes 0:No
#                  l_act  會計科目
# Modify.........: No.MOD-530055 05/03/21 by ching sma39判斷
# Modify.........: NO.FUN-670091 06/08/02 BY rainy cl_err->cl_err3
# Modify.........: No.MOD-680037 06/08/14 By pengu 參數sma39是否打勾,系統都讓user可直接在aimt324增加新的倉儲
# Modify.........: No.FUN-680147 06/09/08 By Czl  類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No:TQC-9A0113 09/10/23 By liuxqa 给IME07赋初值。
# Modify.........: No:FUN-9B0099 09/11/18 By douzh 给IME17赋初值。
# Modify.........: No:FUN-B10016 11/01/14 By Lilan 記錄錯誤訊息供背景執行的表單用(如:整合單據)
# Modify.........: No.FUN-D40103 13/05/07 By fengrui 添加檢查ime_file函數s_imechk;ime_file添加imeacti
# Modify.........: No.TQC-D50116 13/05/27 By fengrui 修改儲位檢查報錯信息
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_locchk(p_part,p_ware,p_loc)
DEFINE
    p_part  LIKE ima_file.ima01, #料件
    p_ware  LIKE ime_file.ime01, #倉庫別
    p_loc   LIKE ime_file.ime02, #儲位別
    l_imd RECORD LIKE imd_file.*,#倉庫別資料主檔
    l_ime RECORD LIKE ime_file.* #倉庫/存放位罝資料主檔
 
   IF p_loc IS NULL THEN LET p_loc =' ' END IF
 
   SELECT ime08,ime09 INTO l_ime.ime08,l_ime.ime09 FROM ime_file
    WHERE ime01=p_ware AND ime02=p_loc
   # 若抓不到資料則新增一筆 ime_file
   IF STATUS 
      THEN 
       #MOD-530055
     #-----No.MOD-680037 modify
     #IF g_sma.sma39='N' AND g_sma.sma42='2' THEN
      IF g_sma.sma39='N' THEN
     #-----No.MOD-680037 end 
         CALL cl_err('','mfg1020',1)
         LET g_errno = 'mfg1020'                   #FUN-B10016 add
         RETURN 0,'' 
      END IF
 
      SELECT * INTO l_imd.* FROM imd_file
       WHERE imd01=p_ware
      IF STATUS 
         THEN 
         #CALL cl_err('sel imd_file',STATUS,1) #FUN-670091
          CALL cl_err3("sel","imd_file",p_ware,"",STATUS,"","",0) #FUN-670091
          LET g_errno = STATUS                                    #FUN-B10016 add
          RETURN 0,'' 
      END IF
      INITIALIZE l_ime.* TO NULL
      LET l_ime.ime01 = p_ware
      LET l_ime.ime02 = p_loc
      LET l_ime.ime03 = p_loc
      LET l_ime.ime04 = l_imd.imd10
      LET l_ime.ime05 = l_imd.imd11
      LET l_ime.ime06 = l_imd.imd12
      LET l_ime.ime07 = l_imd.imd13
      LET l_ime.ime08 = '0'
      LET l_ime.ime09 = ''
      LET l_ime.ime10 = l_imd.imd14
      LET l_ime.ime11 = l_imd.imd15
#     LET l_ime.ime17 = ' '    #NO.TQC-9A0113 add #FUN-9B0099 mark
      LET l_ime.ime17 = l_imd.imd17               #FUN-9B0099 add
      LET l_ime.imeacti = 'Y'                     #FUN-D40103 add
      IF cl_null(l_ime.ime17) THEN LET l_ime.ime17 = 'N' END IF  #FUN-9B0099 add

      INSERT INTO ime_file VALUES(l_ime.*)
      IF SQLCA.sqlerrd[3]=0 OR STATUS
         THEN
         #CALL cl_err('ins ime_file',STATUS,1)  #FUN-670091
          CALL cl_err3("ins","ime_file","","",STATUS,"","",0) #FUN-670091
         LET g_errno = STATUS                          #FUN-B10016 add
         RETURN 0,''
      END IF
   END IF
   #取得會計科目使用方式及會計科目
   IF l_ime.ime08='1' 
      THEN
      SELECT ima39 INTO l_ime.ime09 FROM ima_file WHERE ima01=p_part
   ELSE
      IF l_ime.ime08='0' THEN LET l_ime.ime09='' END IF
   END IF
 
   RETURN 1,l_ime.ime09
 
END FUNCTION

#FUN-D40103--add--str--
FUNCTION s_imechk(p_ime01,p_ime02)
   DEFINE p_ime01    LIKE ime_file.ime01
   DEFINE p_ime02    LIKE ime_file.ime02
   DEFINE l_n        LIKE type_file.num5
   DEFINE l_imeacti  LIKE ime_file.imeacti
   DEFINE l_err      LIKE ime_file.ime02    #TQC-D50116 add

   IF p_ime02 IS NOT NULL AND p_ime02 != ' ' THEN
      SELECT COUNT(*) INTO l_n FROM ime_file
       WHERE ime01 = p_ime01 AND ime02 = p_ime02
      IF l_n = 0 THEN
         CALL cl_err(p_ime01||' '||p_ime02,'mfg1101',0)
         RETURN FALSE
      END IF
   END IF
   IF p_ime02 IS NOT NULL THEN
      SELECT imeacti INTO l_imeacti FROM ime_file
       WHERE ime01 = p_ime01 AND ime02 = p_ime02
      IF l_imeacti = 'N' THEN
         #CALL cl_err(p_ime01||' '||p_ime02,'aim-507',0)             #TQC-D50116 mark
         LET l_err = p_ime02                                         #TQC-D50116 add
         IF cl_null(l_err) THEN LET l_err = "' '" END IF             #TQC-D50116 add
         CALL cl_err_msg("","aim-507",p_ime01 || "|" || l_err ,0)    #TQC-D50116 add
         RETURN FALSE
      END IF
   END IF 
   RETURN TRUE
END FUNCTION
#FUN-D40103--add--end--
