# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_menu_data.4gl
# Descriptions...: 取得Menu清單/樹狀結構
# Date & Author..: 2008/08/07 by kevin
# Memo...........:
# Modify.........: 新建立    #FUN-880012
# Modify.........: No.FUN-A70141 10/07/29 by Jay 取程式清單增加zx12判斷
# Modify.........: No:FUN-AA0003 10/10/01 By Jay 根節點加入權限判斷
# Modify.........: No.FUN-B50017 11/05/04 by Jay 在URL傳遞參數時,第一個和第二個參數增加傳遞整合產品名稱 
# Modify.........: No.FUN-C40075 12/04/30 by Kevin 判斷 p_zxw 以程式代號設定 menu 權限
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
#FUN-880012
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
GLOBALS "../4gl/aws_ttsrv2_global.4gl"  #FUN-B50017   TIPTOP Service Gateway 使用的全域變數檔

DEFINE g_cnt     LIKE type_file.num10
DEFINE g_menu    DYNAMIC ARRAY OF RECORD
                         name   LIKE zy_file.zy02,                         
                         text   LIKE gaz_file.gaz03,
                         url    LIKE type_file.chr500
                       END RECORD
 
#[
# Description....: 取得Menu清單/樹狀結構(Portal function)
# Date & Author..: 2008/08/04 by kevin
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_menu_data()
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 取得Menu清單/樹狀結構                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_menu_data_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序    
END FUNCTION
 
 
#[
# Description....: 取得Menu清單/樹狀結構(Portal function)
# Date & Author..: 2008/08/04 by kevin
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_menu_data_process()    
    DEFINE l_node      om.DomNode    
    DEFINE l_sql       STRING     
    DEFINE l_userid    LIKE zx_file.zx01  
    DEFINE l_tree      STRING
    DEFINE l_cnt       LIKE type_file.num5
   
    DEFINE l_return    DYNAMIC ARRAY OF RECORD
                         name   LIKE zy_file.zy02,
                         text   LIKE gaz_file.gaz03,
                         url    LIKE type_file.chr500
                       END RECORD
                           
    DEFINE l_menu_root   LIKE zx_file.zx05                     
    DEFINE l_zx12      LIKE zx_file.zx12     #No.FUN-A70141
 
    LET l_userid = aws_ttsrv_getParameter("userid") 
    
    IF NOT cl_null(l_userid) THEN
       SELECT COUNT(*) INTO l_cnt
           FROM zx_file WHERE zx01=l_userid
          
       IF l_cnt=0 THEN
       	 LET g_status.code = -1
       	 LET g_status.description = "No such user"
       	 RETURN    	 
       END IF
    END IF
    
    LET l_tree = aws_ttsrv_getParameter("tree") 
    LET l_tree = l_tree.toUpperCase()

    SELECT zx12 INTO l_zx12 FROM zx_file WHERE zx01 = l_userid     #FUN-A70141
    
    IF l_tree="Y" THEN  ##取得tree目錄  	
       SELECT zx05 INTO l_menu_root FROM zx_file WHERE zx01=l_userid
       IF cl_null(l_menu_root) THEN    
         LET l_menu_root = "menu"
       END IF
       #tree
       LET l_sql = "select zm04,'','' from zm_file where zm01='",l_menu_root,"' ORDER BY zm03"
                   
       DECLARE zm_curs CURSOR FROM l_sql
       
       OPEN zm_curs      
       IF SQLCA.SQLCODE THEN
          LET g_status.code = SQLCA.SQLCODE
          LET g_status.sqlcode = SQLCA.SQLCODE
          RETURN
       END IF
       
       CALL g_menu.clear()
       LET g_cnt = 1
       #---FUN-AA0003---start------------------------------------------------
       #將原先依使用者所設目錄的下面節點才開始build menu方式mark起來
       #直接改成將使用者所設目錄之名稱直接傳入build menu
       #FOREACH zm_curs INTO g_menu[g_cnt].*
       #   LET g_menu[g_cnt].text = cl_get_node_text(g_lang, g_menu[g_cnt].name)
       #   LET g_menu[g_cnt].url = ""       	  
       #   LET l_node = aws_ttsrv_addMasterMenu(base.TypeInfo.create(g_menu[g_cnt]), g_menu[g_cnt].name,l_userid)    ##   	  
       #   LET g_cnt = g_cnt + 1
       #END FOREACH

       LET g_menu[g_cnt].name = l_menu_root
       LET g_menu[g_cnt].text = cl_get_node_text(g_lang, g_menu[g_cnt].name)
       LET g_menu[g_cnt].url = ""
       LET l_node = aws_ttsrv_addMasterMenu(base.TypeInfo.create(g_menu[g_cnt]), g_menu[g_cnt].name,l_userid)
       #---FUN-AA0003---end--------------------------------------------------       
    ELSE #取得程式清單
         IF cl_null(l_userid) OR l_zx12 = 'N' THEN     #FUN-A70141  增加zx12判斷
    	 	  LET l_sql = "select unique zy02,gaz03,'' from zy_file,gaz_file",
                   " where zy02=gaz01 AND gaz02='",g_lang,"' ",
                   " and  zy02 not in (select zz01 from zz_file where  zz011='MENU') "
    	 ELSE
          LET l_sql = "select unique zy02,gaz03,'' from zy_file,gaz_file",
                   " where zy02=gaz01 AND gaz02='",g_lang,"'",
                   " AND zy01 in (SELECT zxw04 from zxw_file  where zxw01='",l_userid,"'",
                   " union select zx04 from zx_file where zx01= '",l_userid,"' )",
                   " and  zy02 not in (select zz01 from zz_file where zz011='MENU') "  
          #FUN-C40075 --start--
          LET l_sql = l_sql , " UNION SELECT zxw04,gaz03,'' from zxw_file,gaz_file ",
                              "  WHERE zxw01='",l_userid,"'", " and zxw03='2' AND zxw04=gaz01 AND gaz02='0' "
          #FUN-C40075 --end--
       END IF
    
display l_sql
       DECLARE zy_curs CURSOR FROM l_sql
       
       OPEN zy_curs       
       IF SQLCA.SQLCODE THEN
          LET g_status.code = SQLCA.SQLCODE
          LET g_status.sqlcode = SQLCA.SQLCODE
          RETURN
       END IF
       
       CALL l_return.clear()
       LET g_cnt = 1
       
       FOREACH zy_curs INTO l_return[g_cnt].*
       	  #LET l_return[g_cnt].url = "$TIPTOPMenuURL?Arg=&Arg=&Arg=$SOK&Arg=$CompanyCode&Arg=", l_return[g_cnt].name   #FUN-B50017 mark
       	  LET l_return[g_cnt].url = "$TIPTOPMenuURL?Arg=", g_access.application CLIPPED, "&Arg=", g_access.application CLIPPED, "&Arg=$SOK&Arg=$CompanyCode&Arg=", l_return[g_cnt].name    #FUN-B50017
       	  LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_return[g_cnt]), "")
          LET g_cnt = g_cnt + 1
       END FOREACH
       
    END IF
   
END FUNCTION
