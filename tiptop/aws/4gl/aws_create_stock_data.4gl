# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_create_stock_data.4gl
# Descriptions...: 提供建立料件新倉儲批資料的服務
# Date & Author..: 2008/09/01 By Nicola
# Memo...........:
# Modify.........: 新建立 FUN-840012
#
#}
# Modify.........: No.FUN-980009 09/08/21 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D40103 13/05/09 By lixh1 增加儲位有效性檢查
 
DATABASE ds
 
#No.FUN-840012
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
 
#[
# Descriptions...: 提供建立料件新倉儲批資料的服務
# Date & Author..: 2008/09/01 By Nicola
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_stock_data()
   
   WHENEVER ERROR CONTINUE
   
   CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
   
   #--------------------------------------------------------------------------#
   # 新增料件新倉儲批資料                                                      #
   #--------------------------------------------------------------------------#
   IF g_status.code = "0" THEN
      CALL aws_create_stock_data_process()
   END IF
 
   CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
 
END FUNCTION
 
 
#[
# Descriptions...: 提供建立料件新倉儲批資料的服務
# Date & Author..: 2008/09/01 By Nicola
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_stock_data_process()
   DEFINE l_img     RECORD LIKE img_file.*
   DEFINE l_ima71   LIKE ima_file.ima71
   DEFINE g_i       LIKE type_file.num5            #count/index for any purpose 	#No.FUN-680147 SMALLINT
   
       
   #--------------------------------------------------------------------------#
   # 處理呼叫方傳遞給 ERP 的料件新倉儲批資料                                  #
   #--------------------------------------------------------------------------#
 
   LET l_img.img01 = aws_ttsrv_getParameter("img01")
   LET l_img.img02 = aws_ttsrv_getParameter("img02")
   LET l_img.img03 = aws_ttsrv_getParameter("img03")
   LET l_img.img04 = aws_ttsrv_getParameter("img04")
 
   IF cl_null(l_img.img01) THEN
      LET g_status.code = "aws_105"                             #主鍵的欄位值不可為 NULL
   END IF
   
   IF cl_null(l_img.img02) THEN
      LET g_status.code = "asf-770"                             #主鍵的欄位值不可為 NULL
   END IF
   
   IF cl_null(l_img.img03) THEN
      LET l_img.img03=" "
   END IF
 
   IF cl_null(l_img.img04) THEN
      LET l_img.img04=" "
   END IF
 
   # 檢查是否有相對應的倉庫/儲位資料存在,若無則自動新增一筆資料
   CALL s_locchk(l_img.img01,l_img.img02,l_img.img03)
       RETURNING g_i,l_img.img26
   IF g_i = 0 THEN 
      LET g_status.code = "mfg0095" 
   END IF
 
   SELECT ima25,ima71 INTO l_img.img09,l_ima71 FROM ima_file
    WHERE ima01=l_img.img01
 
   IF SQLCA.sqlcode OR l_ima71 IS NULL THEN LET l_ima71=0 END IF
 
   LET l_img.img10=0
   LET l_img.img17=g_today     
   LET l_img.img13=null
 
   IF l_ima71 =0 THEN
      LET l_img.img18=g_lastdat
   ELSE
      LET l_img.img13=g_today
      LET l_img.img18=g_today+l_ima71
   END IF
 
   SELECT ime04,ime05,ime06,ime07,ime09,ime10,ime11
     INTO l_img.img22,l_img.img23,l_img.img24,l_img.img25,l_img.img26,
          l_img.img27,l_img.img28
     FROM ime_file
    WHERE ime01 = l_img.img02
      AND ime02 = l_img.img03
      AND imeacti = 'Y'     #FUN-D40103
 
   IF SQLCA.sqlcode THEN 
      SELECT imd10,imd11,imd12,imd13,imd08,imd14,imd15
        INTO l_img.img22,l_img.img23,l_img.img24,l_img.img25,l_img.img26,
             l_img.img27,l_img.img28
        FROM imd_file
       WHERE imd01=l_img.img02
      IF SQLCA.SQLCODE THEN 
         LET l_img.img22 = 'S'
         LET l_img.img23 = 'Y'
         LET l_img.img24 = 'Y'
         LET l_img.img25 = 'N'
      END IF
   END IF
 
   LET l_img.img20=1
   LET l_img.img21=1
   LET l_img.img30=0
   LET l_img.img31=0
   LET l_img.img32=0
   LET l_img.img33=0
   LET l_img.img34=1
   LET l_img.img37=g_today 
   LET l_img.imgplant = g_plant #FUN-980009
   LET l_img.imglegal = g_legal #FUN-980009
 
   INSERT INTO img_file VALUES(l_img.*)
   IF SQLCA.SQLCODE THEN
      LET g_status.code = SQLCA.SQLCODE
      LET g_status.sqlcode = SQLCA.SQLCODE
   END IF
 
 
END FUNCTION
