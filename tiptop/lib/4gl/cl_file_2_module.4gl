# Prog. Version..: '5.30.06-13.03.12(00000)'     #
 
# Descriptions...: 找出該 4gl 所屬的 Module 名稱
# Date & Author..: 
# Input Parameter: lc_filename zz01    4gl 檔名
#                  lc_type     VARCHAR(1) 回傳形態 S:大寫英文 D:小寫英文 0,1,2:語言別
# Return code....: ls_module   STRING  所需的模組名稱
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds   #FUN-7C0053
 
FUNCTION cl_file_2_module(lc_zz01, lc_type)
 
   DEFINE lc_zz01           LIKE zz_file.zz01
   DEFINE lc_zz011          LIKE zz_file.zz011
   DEFINE lc_type           LIKE gaz_file.gaz02  #No.FUN-690005 VARCHAR(1)
   DEFINE lc_gaz03          LIKE gaz_file.gaz03
 
   # 2004/07/01 若 zz_file 有錯或查不到 zz08 資料則回傳空值
   SELECT zz011 INTO lc_zz011 FROM zz_file WHERE zz01=lc_zz01
   IF STATUS THEN
      RETURN " "
   END IF
 
   CASE lc_type
     WHEN "S" OR "s"
        LET lc_zz011 = UPSHIFT(lc_zz011) CLIPPED
        RETURN lc_zz011
     WHEN "D" OR "d"
        RETURN lc_zz011
     OTHERWISE
        SELECT gaz03 INTO lc_gaz03 FROM gaz_file
         WHERE gaz01=lc_zz011 AND gaz02 = lc_type
        RETURN lc_gaz03
   END CASE
 
END FUNCTION
 
