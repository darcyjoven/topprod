# Prog. Version..: '5.30.03-12.09.18(00000)'     #
#{
# Program name...: aws_login_check.4gl
# Descriptions...: 用户登录验证
# Date & Author..: 2016/4/17 16:36:26 by shenran
 
 
DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../../aws/4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 

DEFINE g_login   RECORD 
            username   LIKE type_file.chr20,
            plant      LIKE type_file.chr50,
            realname   LIKE type_file.chr50,
            departcode LIKE type_file.chr20,
            departname LIKE type_file.chr50
           END RECORD
                   
FUNCTION aws_login_check()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_login_check_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
 
#[
# Description....: 检验逻辑
# Date & Author..: 2016/4/17 16:40:06 by shenran
# Parameter......: none
# Return.........: none
# Memo...........:
#
#]
FUNCTION aws_login_check_process()
	DEFINE l_username LIKE type_file.chr20,
	             l_password LIKE type_file.chr50,
	             l_plant    LIKE type_file.chr20,
	             l_nn       LIKE type_file.num5
    DEFINE l_node  om.DomNode

    DEFINE l_sql   STRING
    DEFINE l_chk_pasword VARCHAR(100)
    DEFINE l_chk_pasword1 string

    LET l_username = aws_ttsrv_getParameter("username")   #取由呼叫端呼叫時給予的 SQL Condition
    LET l_password = aws_ttsrv_getParameter("password")  #取由呼叫端呼叫時給予的 SQL Condition
  
    IF cl_null(l_username) THEN
    	   LET g_status.code = -1
         LET g_status.description = '用户名不能为空!'
         RETURN
    END IF
    IF cl_null(l_password) THEN
    	   LET g_status.code = -1
         LET g_status.description = '密码不能为空!'
         RETURN
    END IF

		LET l_sql =" SELECT zx10 FROM zx_file WHERE zx01 = '",l_username,"'"
		PREPARE prep_aaa FROM l_sql
		EXECUTE prep_aaa INTO l_chk_pasword
		IF cl_null(l_chk_pasword) THEN 
			   LET g_status.code = -1
         LET g_status.description = '用户名不存在,请重新输入!'
         RETURN
		END IF
		LET l_chk_pasword = aws_chk_id_and_password_sec_chkz(l_chk_pasword)


	   IF l_password <> l_chk_pasword THEN
         LET g_status.code = -1
         LET g_status.description = '密码有误!请联系管理员!'
         RETURN
     ELSE 
     	   SELECT zx01,zx08,zx02,zx03 INTO g_login.username,g_login.plant,g_login.realname,g_login.departcode 
     	   FROM zx_file
     	   WHERE zx01=l_username
     	   IF NOT cl_null(g_login.departcode) THEN
     	   	  SELECT gem02 INTO g_login.departname FROM gem_file WHERE gem01=g_login.departcode
     	   END IF
	   END IF
     CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(g_login))
     IF SQLCA.SQLCODE THEN
          LET g_status.code = SQLCA.SQLCODE
          LET g_status.sqlcode = SQLCA.SQLCODE
     END IF
    	    
END FUNCTION

FUNCTION aws_chk_id_and_password_sec_chkz(ls_pwd)
   DEFINE ls_pwd     STRING

      RETURN aws_chk_id_and_password_hash_dd("28682266",ls_pwd)

END FUNCTION

FUNCTION aws_chk_id_and_password_hash_dd(p_token,ls_inp) #FUN-C60025
 
   DEFINE ls_inp, ls_out  STRING
   DEFINE ls_demo         STRING
   DEFINE ls_new1,ls_new2 STRING
   DEFINE li_cnt,li_i,li_j,li_move,li_tmp  SMALLINT
   DEFINE lc_gbt07        LIKE type_file.chr1
   DEFINE p_token         STRING    #FUN-C60025

   LET ls_inp = ls_inp.trim() 

   IF p_token <> "28682266" THEN    #FUN-C60025 控管進入的token ,避免被外部程式不當使用
      RETURN ls_inp
   END IF
 
   SELECT gbt07 INTO lc_gbt07 FROM gbt_file WHERE gbt00="0"
   IF SQLCA.SQLCODE OR lc_gbt07 IS NULL OR lc_gbt07 <> "Y" THEN
      RETURN ls_inp
   END IF
 
   LET li_cnt = ls_inp.subString(ls_inp.getLength(),ls_inp.getLength())
   LET ls_out = ls_inp.subString(1,ls_inp.getLength()-1)
 
   IF li_cnt > 0 THEN
      FOR li_j = 1 TO li_cnt
         LET ls_inp = ls_out
         LET ls_new1="" LET ls_new2=""
         LET li_i = TRUE
         FOR li_tmp = ls_inp.getLength() TO 1 STEP -1
            IF li_i THEN
               LET ls_new2 = ls_inp.subString(li_tmp,li_tmp),ls_new2
               LET li_i = FALSE
            ELSE
               LET ls_new1 = ls_new1,ls_inp.subString(li_tmp,li_tmp)
               LET li_i = TRUE
            END IF
         END FOR
         LET ls_out = ls_new1,ls_new2
      END FOR
 
   END IF
 
   LET li_move = ls_out.subString(ls_out.getLength()-1,ls_out.getLength())
   LET ls_inp = ls_out.subString(1,ls_out.getLength()-2)
 
   #Seed
   LET ls_demo = "7D#wG^>t4H&s3KAz5B!y6C<@x)pLJ(q]1nN_mOl,P8E$v9F[%u0o-MI*r2kQ.jRi:ShT;gUf?VeW+dXc|Yb~Za `='",'"'
 
   LET ls_out = ""
   FOR li_i = 1 TO ls_inp.getLength()
      LET li_tmp = ls_demo.getIndexOf(ls_inp.subString(li_i,li_i),1) 
      IF li_tmp > 0 THEN
         IF li_tmp < li_move THEN
            LET li_tmp = li_tmp + 91 - li_move
         ELSE
            LET li_tmp = li_tmp - li_move
         END IF
         #樣本字串裡存在的
         LET ls_out = ls_out,ls_demo.subString(li_tmp,li_tmp)
      ELSE
         #樣本字串裡不存在的
         LET ls_out = ls_out,ls_inp.subString(li_i,li_i)
      END IF
   END FOR
 
   LET ls_out = ls_out.subString(3,ls_out.getLength()-4)
   RETURN ls_out
 
END FUNCTION
	
	
	