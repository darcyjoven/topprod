# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_sync_account_data.4gl
# Descriptions...: 提供建立使用者基本資料的服務(for Portal使用)
# Date & Author..: 2011/11/23 by ka0132
# Memo...........:
# Modify.........: 新建立  FUN-B60090
# Modify.........: No.FUN-D40047 13/04/10 By zack 修正date型態的變數不接受存放有時/分/秒的字串 
#
#}

DATABASE ds 
#FUN-B60090

GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔

GLOBALS
DEFINE g_zx         RECORD LIKE zx_file.*
DEFINE g_zx_t       RECORD LIKE zx_file.*
END GLOBALS

#[
# Description....: 提供建立使用者基本資料的服務(入口 function)
# Date & Author..: 2011/06/17 by ka0132
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_sync_account_data()

    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序

    #--------------------------------------------------------------------------#
    # 新增員工基本資料                                                         #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_create_user_data_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION


#[
# Description....: 依據傳入資訊新增一筆 ERP 員工基本資料
# Date & Author..: 2011/06/17 by ka0132
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_user_data_process()
    DEFINE l_i       LIKE type_file.num10
    DEFINE l_sql     STRING
    DEFINE l_cnt     LIKE type_file.num5
    DEFINE l_cnt1    LIKE type_file.num10,
           l_cnt2    LIKE type_file.num10
    DEFINE l_wc      STRING
    DEFINE l_node    om.DomNode
    DEFINE l_zx     RECORD LIKE zx_file.*
    DEFINE l_pwd     STRING
    DEFINE p_cmd     LIKE type_file.chr1
    DEFINE l_forupd_sql STRING
    DEFINE l_str     LIKE type_file.chr100   #FUN-D40047 
    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的員工基本資料                                      #
    #--------------------------------------------------------------------------#
    LET l_forupd_sql = " SELECT * FROM zx_file ",
                      " WHERE zx01 = ? FOR UPDATE "
    LET l_forupd_sql = cl_forupd_sql(l_forupd_sql) #調整
    DECLARE zx_cl CURSOR FROM l_forupd_sql

    BEGIN WORK

    INITIALIZE l_zx.* TO NULL
    LET gi_err_code=NULL

    LET l_zx.zx01 = aws_ttsrv_getParameter("UserId")     #取得此筆單檔資料的欄位值
    IF cl_null(l_zx.zx01) THEN
       LET g_status.code = "-286"                        #主鍵的欄位值不可為 NULL
       ROLLBACK WORK
       RETURN
    END IF

    #MDM mapping表上可能傳入以下欄位
    LET l_zx.zx02   = aws_ttsrv_getParameter("UserName")    #員工姓名        
    LET l_zx.zx09   = aws_ttsrv_getParameter("Email")       #E-mail      
    LET l_pwd       = aws_ttsrv_getParameter("Password")    #password      
    IF cl_null(l_pwd) THEN
       LET g_status.code = "aws-611"                        #密碼錯誤
       ROLLBACK WORK
       RETURN
    END IF
         
    LET l_zx.zx10   = cl_decrypt_token_key(l_pwd)           #解密-僅適用於 Portal 整合功能功能 
    IF cl_null(l_zx.zx10) THEN
       LET g_status.code = "aws-611"                        #密碼錯誤
       ROLLBACK WORK
       RETURN
    END IF
    # No.FUN-D40047 START ----- 
    #LET l_zx.zx18   = aws_ttsrv_getParameter("DeactivateDate")    #使用者失效日期        
     LET l_str=aws_ttsrv_getParameter("DeactivateDate")    #使用者失效日期
     LET l_zx.zx18=l_str[1,10] 
    # No.FUN-D40047 END ----- 
    LET l_cnt=0
    SELECT COUNT(*) INTO l_cnt
      FROM zx_file
     WHERE zx01=l_zx.zx01
    IF l_cnt>0 THEN
       LET p_cmd='u'
    ELSE
       LET p_cmd='a'
    END IF
    CASE p_cmd
       WHEN "a"
          LET g_zx.*=l_zx.*
          LET g_action_choice=NULL

       WHEN "u"
          LET g_zx.zx01=l_zx.zx01
          #----------------------------------------------------------------------#
          # 修改前檢查                                                           #
          #----------------------------------------------------------------------#
          IF NOT aws_create_user_updchk() THEN
             CALL aws_create_user_error()
             ROLLBACK WORK
             RETURN
          END IF

          LET g_zx_t.* = g_zx.*
          CALL aws_create_user_field_update(l_zx.*)
          LET g_action_choice=NULL

       OTHERWISE
          LET g_status.code = 'aws-101'
          ROLLBACK WORK
          RETURN
    END CASE
    
    #----------------------------------------------------------------------#
    # 指定g_zx Default                                                     #
    #----------------------------------------------------------------------#
    IF p_cmd='a' THEN
       CALL p_zx_default()
    ELSE         
       IF NOT aws_create_user_updchk() THEN
          CALL aws_create_user_error()
          ROLLBACK WORK
          RETURN
       END IF
    END IF

    #----------------------------------------------------------------------#
    # 新增前檢查                                                           #
    #----------------------------------------------------------------------#

    #避免傳入值在途中被改掉,需重新指定一次g_zx
    CALL aws_create_user_field_update(l_zx.*)

    #----------------------------------------------------------------------#
    # 判斷此資料是否已經建立, 若已建立則為 Update                          #
    # 因 Portal 傳的格式與標準不同，因此自行組合 sql 指令                  #
    #----------------------------------------------------------------------#
    SELECT COUNT(*) INTO l_cnt2 FROM zx_file WHERE zx01 = g_zx.zx01
    IF l_cnt2 = 0 THEN
       INSERT INTO zx_file VALUES(g_zx.*)
    ELSE
       UPDATE zx_file SET zx_file.* = g_zx.* WHERE zx01 = g_zx.zx01 
    END IF
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       ROLLBACK WORK
       RETURN
    END IF

    #全部處理都成功才 COMMIT WORK
    IF g_status.code = "0" THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
END FUNCTION

FUNCTION aws_create_user_error()
   IF gi_err_code<>"0" THEN
      LET g_status.code = gi_err_code
   ELSE
      IF NOT cl_null(g_errno) THEN
         LET g_status.code = g_errno
      ELSE
         LET g_status.code = '-1106'
      END IF
   END IF
END FUNCTION

#將l_zx中非NULL的欄位值(本次更新的欄位)更新到g_zx
FUNCTION aws_create_user_field_update(l_zx)
DEFINE l_zx RECORD LIKE zx_file.*
   IF NOT cl_null(l_zx.zx01) THEN LET g_zx.zx01 = l_zx.zx01 END IF
   IF NOT cl_null(l_zx.zx02) THEN LET g_zx.zx02 = l_zx.zx02 END IF
   #IF NOT cl_null(l_zx.zx03) THEN LET g_zx.zx03 = l_zx.zx03 END IF
   IF NOT cl_null(l_zx.zx08) THEN LET g_zx.zx08 = l_zx.zx08 END IF
   IF NOT cl_null(l_zx.zx09) THEN LET g_zx.zx09 = l_zx.zx09 END IF
   IF NOT cl_null(l_zx.zx10) THEN LET g_zx.zx10 = l_zx.zx10 END IF
   LET g_zx.zx18 = l_zx.zx18             #因使用者可用截止日期可以為空值 
END FUNCTION

FUNCTION aws_create_user_updchk()
   OPEN zx_cl USING g_zx.zx01
   IF STATUS THEN
      CALL cl_err("OPEN zx_cl:", STATUS, 1)
      CLOSE zx_cl
      RETURN FALSE
   END IF
   FETCH zx_cl INTO g_zx.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_zx.zx01,SQLCA.sqlcode,0)
      RETURN FALSE
   END IF
   LET g_zx.zxmodu = g_user                   #修改者
   LET g_zx.zxdate = g_today
   RETURN TRUE
END FUNCTION

FUNCTION p_zx_default()
   LET g_zx.zx06 = '0'
   LET g_zx.zx07 = 'N'
   LET g_zx.zx12 = 'N'
   LET g_zx.zx15 = '3'                     #FUN-660169
   LET g_zx.zx16 = g_today                 #FUN-830011
   LET g_zx.zx17 = "0"                     #FUN-830011
   LET g_zx.zxacti = 'Y'
   LET g_zx.zxmodu = g_user
   LET g_zx.zxdate = g_today   
END FUNCTION

FUNCTION aws_create_user_field_check()
   DEFINE p_cmd LIKE type_file.chr1
   
   IF NOT p_zx_chk_zx01() THEN
      RETURN FALSE
   END IF

END FUNCTION

FUNCTION p_zx_chk_zx01()
   DEFINE l_n LIKE type_file.num5
   IF NOT cl_null(g_zx.zx01) THEN
      IF g_zx.zx01 != g_zx_t.zx01 OR
         g_zx_t.zx01 IS NULL THEN
         SELECT count(*) INTO l_n FROM zx_file
          WHERE zx01 = g_zx.zx01
         IF l_n > 0 THEN
            CALL cl_err('',-239,0)
            RETURN FALSE
         END IF
      END IF
   END IF
   RETURN TRUE
END FUNCTION

