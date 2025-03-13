# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Program name...: s_showmsg.4gl
# Descriptions...: 錯誤訊息統整
# Date & Author..: No.FUN-6C0083 07/01/03 By Nicola 
# Modify.........: No.FUN-740043 07/04/12 By Nicola 視窗及欄位title不出現"錯誤"二個字
# Modify.........: No.FUN-740058 07/04/13 By Nicola 提示類訊息不再出現 
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-850069 08/05/14 By alex 調整說明
# Modify.........: No.FUN-840004 08/07/07 By Echo 背景執行時不需要呼叫 s_errmsg, 維持 call cl_err().
# Modify.........: No.MOD-940038 09/05/25 By Pengu 調整li_newerrno變數的資料型態為num10
# Modify.........: No:FUN-AC0026 11/07/05 By Mandy PLM-資料中心功能
# Modify.........: No:MOD-B80215 11/08/22 By sabrina 將p_msg改為string型態
 
DATABASE ds    #FUN-850069  FUN-7C0053
 
GLOBALS "../../config/top.global"
 
# Descriptions...: 錯誤訊息統整初始化函式
 
FUNCTION s_showmsg_init()
 
   CALL g_err_msg.clear()
   LET g_totsuccess=g_success
   #FUN-840004
   #---------------------------------------------------------------------------#
   #背景執行時，不呼叫 s_showmsg() 顯示錯誤 ARRAY, 依舊維持 CALL cl_err().     #
   #---------------------------------------------------------------------------#
   IF g_bgjob = 'Y' THEN    #20220502 去掉AND g_gui_type NOT MATCHES "[13]"  
       LET g_bgerr = FALSE
   ELSE
       LET g_bgerr = TRUE
   END IF
   #END FUN-840004
 
END FUNCTION
 
# Descriptions...: 錯誤訊息統整
 
FUNCTION s_errmsg(p_field,p_data,p_msg,err_code,p_n)
   DEFINE p_field     STRING
   DEFINE p_data      STRING
   DEFINE g_field     STRING
   DEFINE l_field     STRING
  #DEFINE p_msg       LIKE type_file.chr50   #No:FUN-6C0083 #MOD-B80215 mark
   DEFINE p_msg       STRING                 #MOD-B80215 add 
   DEFINE err_code    LIKE type_file.chr7    #No.FUN-6C0083
   DEFINE p_n         LIKE type_file.num5    #No.FUN-6C0083
   DEFINE lc_ze03     LIKE ze_file.ze03
   DEFINE lc_name     LIKE ze_file.ze03
   DEFINE li_newerrno LIKE type_file.num10   #No.MOD-940038 原先為num5改為num10
   DEFINE tok base.StringTokenizer
   DEFINE lc_gaq03 LIKE gaq_file.gaq03
 
   #-----No.FUN-740058-----
   IF p_n = "0" THEN
      RETURN
   END IF
   #-----No.FUN-740058 END-----
 
  #FUN-AC0026---mark---str---
  ##FUN-840004
  ##---------------------------------------------------------------------------#
  ##當 g_bgerr = FALSE 時，不需記錄並顯示錯誤 ARRAY                            #
  ##---------------------------------------------------------------------------#
  #IF g_bgerr = FALSE THEN
  #   CALL cl_err(p_msg,err_code,p_n)
  #   RETURN
  #END IF
  ##END FUN-840004
  #FUN-AC0026---mark---end---
  #FUN-AC0026---add----str---
  #當 g_prog  = 'aws_ttsrv2'時,不管g_bgerr的值為何,皆要記錄錯誤訊息
  #當 g_prog <> 'aws_ttsrv2'時,g_bgerr = FALSE 時，不需記錄並顯示錯誤 ARRAY                            #
   IF g_prog <> 'aws_ttsrv2' AND g_bgerr = FALSE THEN                             
      CALL cl_err(p_msg,err_code,p_n)
      RETURN
   END IF
  
  #FUN-AC0026---mark---end---
 
   CALL cl_getmsg(err_code,g_lang) RETURNING lc_ze03
 
   IF p_n = "1" THEN
      CALL cl_getmsg("aaz-200",g_lang) RETURNING lc_name
   ELSE
      CALL cl_getmsg("aaz-199",g_lang) RETURNING lc_name
   END IF
 
   LET g_field =""
   LET tok = base.StringTokenizer.create(p_field,",")
   WHILE tok.hasMoreTokens()
#     DISPLAY tok.nextToken()
      LET l_field = tok.nextToken()
      CALL cl_get_feldname(l_field,g_lang) RETURNING lc_gaq03
      IF cl_null(g_field) THEN
         LET g_field = lc_gaq03,"(",l_field,")"
      ELSE
         LET g_field = g_field,"/",lc_gaq03,"(",l_field,")"
      END IF
   END WHILE
 
   LET li_newerrno = g_err_msg.getLength() + 1
   LET g_err_msg[li_newerrno].fld1  = lc_name
   LET g_err_msg[li_newerrno].fld2  = g_field
   LET g_err_msg[li_newerrno].fld3  = p_data
   LET g_err_msg[li_newerrno].fld4  = err_code
   LET g_err_msg[li_newerrno].fld5  = p_msg,lc_ze03
 
END FUNCTION
 
# Descriptions...: 錯誤訊息統整顯示
 
FUNCTION s_showmsg()
   DEFINE l_msg    STRING
   DEFINE l_msg2   STRING
   DEFINE lc_gaq03 LIKE gaq_file.gaq03
 
  #FUN-AC0026---mod---str---
  #LET g_bgerr=FALSE
  #IF g_err_msg.getLength() = 0 THEN
  #改成當g_bgerr = FALSE 時不顯示訊息統整
   IF g_bgerr = FALSE THEN
      RETURN
   END IF
   LET g_bgerr=FALSE
  #FUN-AC0026---mod---end---
 
   CALL cl_get_feldname("gag08",g_lang) RETURNING lc_gaq03
   LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
 
   CALL cl_get_feldname("gae04",g_lang) RETURNING lc_gaq03
   LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
 
   CALL cl_get_feldname("gcd05",g_lang) RETURNING lc_gaq03
   LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
 
   CALL cl_get_feldname("gai01",g_lang) RETURNING lc_gaq03   #No.FUN-740043
   LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
 
   CALL cl_get_feldname("gai03",g_lang) RETURNING lc_gaq03   #No.FUN-740043
   LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
   CALL cl_getmsg("lib-314",g_lang) RETURNING l_msg
   CALL cl_show_array(base.TypeInfo.create(g_err_msg),l_msg,l_msg2)
 
END FUNCTION
 
 
 
