# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_check_exec_authorization.4gl
# Descriptions...: 提供檢查 使用者執行權限
# Date & Author..: 2008/08/01 by kim (FUN-840012)
# Memo...........:
# Modify.........:
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
           
 
#[
# Description....: 提供檢查 使用者執行權限(入口 function)
# Date & Author..: 2008/08/01 by kim  (FUN-840012)
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_check_exec_authorization()
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
 
    #--------------------------------------------------------------------------#
    # 檢查 使用者執行權限                                                      #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_check_exec_authorization_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
 
#[
# Description....: 檢查 使用者執行權限
# Date & Author..: 2008/08/01 by kim (FUN-840012)
# Parameter......: 使用者代號 & 程式代號
# Return.........: 回傳0=>無登入權限; 回傳1=>有登入權限
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_check_exec_authorization_process()
    DEFINE l_sql       STRING
   #DEFINE l_wc        STRING
    DEFINE l_cnt       LIKE type_file.num10
    DEFINE l_cnt1      LIKE type_file.num10
    DEFINE l_cnt2      LIKE type_file.num10
    DEFINE l_node      om.DomNode
    DEFINE l_user      LIKE zx_file.zx01                  #使用者代號
    DEFINE l_prog      LIKE zy_file.zy02                  #程式代號
    DEFINE l_clas      LIKE zx_file.zx04                  #權限類別
    DEFINE l_return    RECORD       #回傳值必須宣告為一個 RECORD 變數, 且此 RECORD 需包含所有要回傳的欄位名稱與定義
                          value  LIKE type_file.num5
                       END RECORD
 
    LET l_user = aws_ttsrv_getParameter("user")    #使用者代號,不可空白
    LET l_prog = aws_ttsrv_getParameter("prog")    #程式代號  ,不可空白
 
    IF cl_null(l_user) OR cl_null(l_prog) THEN
       LET g_status.code='aws-101'
       RETURN
    END IF
 
    LET l_clas=''
 
    SELECT zx04 INTO l_clas
      FROM zx_file
     WHERE zx01=l_user
 
    IF cl_null(l_clas) THEN
       LET l_return.value=0
       CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
       RETURN
    END IF
 
    LET l_cnt=0
 
    SELECT COUNT(*) INTO l_cnt FROM zxw_file WHERE zxw01=l_user
 
    IF l_cnt=0 THEN
       SELECT COUNT(*) INTO l_cnt
                       FROM zy_file
                      WHERE zy01=l_clas AND zy02=l_prog
    ELSE
       LET l_cnt=0
       LET l_cnt1=0
       LET l_cnt2=0
 
       SELECT COUNT(*) INTO l_cnt1 FROM zxw_file, zy_file
        WHERE zxw01 = l_user
          AND zxw04 = zy01 AND zy02 = l_prog
 
       SELECT COUNT(*) INTO l_cnt2 FROM zxw_file
        WHERE zxw01 = l_user AND zxw04 = l_prog
 
       LET l_cnt=l_cnt1+l_cnt2
    END IF
 
    IF l_cnt>0 THEN
       LET l_return.value=1
    ELSE
       LET l_return.value=0
    END IF
 
    CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
END FUNCTION
