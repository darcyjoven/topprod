# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_create_department_data.4gl
# Descriptions...: 提供建立部門基本資料的服務
# Date & Author..: 2008/11/17 by kevin
# Memo...........:
# Modify.........: 新建立 FUN-890113
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0022 10/10/13 By Mandy HR GP5.2 追版-------str----
# Modify.........: No:FUN-A20045 10/02/22 By Mandy 若傳入的某些欄位並沒有全部建立
# Modify.........: No:FUN-A20053 10/02/24 By Mandy 由"HR"CALL此Service時,當資料欲"更新(UPDATE)"時,則關於會計資料的相關欄位則不同步更新
# Modify.........: No.FUN-AA0022 10/10/13 By Mandy HR GP5.2 追版-------end----
# Modify.........: No.FUN-B50032 11/05/12 By Jay  CROSS-MDM整合
#
#}
 
 
DATABASE ds #FUN-890113
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
 
GLOBALS
DEFINE g_gem         RECORD LIKE gem_file.*
DEFINE g_gem_t       RECORD LIKE gem_file.*
END GLOBALS
 
#[
# Description....: 提供建立使用者基本資料的服務(入口 function)
# Date & Author..: 2007/06/11 by kim
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_department_data()
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
 
    #--------------------------------------------------------------------------#
    # 新增員工基本資料                                                         #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_create_department_data_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
 
#[
# Description....: 依據傳入資訊新增一筆 ERP 員工基本資料
# Date & Author..: 2007/06/11 by kim
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_department_data_process()
    DEFINE l_i       LIKE type_file.num10
    DEFINE l_sql     STRING
    DEFINE l_cnt     LIKE type_file.num5
    DEFINE l_cnt1    LIKE type_file.num10,
           l_cnt2    LIKE type_file.num10
    DEFINE l_wc      STRING
    DEFINE l_node    om.DomNode
    DEFINE l_gem     RECORD LIKE gem_file.*
    DEFINE p_cmd     LIKE type_file.chr1
    DEFINE l_forupd_sql STRING
 
    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的員工基本資料                                      #
    #--------------------------------------------------------------------------#
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("gem_file")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***
    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       RETURN
    END IF
 
    LET l_forupd_sql = " SELECT * FROM gem_file WHERE gem01 = ? FOR UPDATE "
    LET l_forupd_sql=cl_forupd_sql(l_forupd_sql)

    DECLARE gem_cl CURSOR FROM l_forupd_sql
 
    BEGIN WORK
 
    FOR l_i = 1 TO l_cnt1
        INITIALIZE l_gem.* TO NULL
        LET gi_err_code=NULL
 
        LET l_node = aws_ttsrv_getMasterRecord(l_i, "gem_file")         #目前處理單檔的 XML 節點
        LET l_gem.gem01 = aws_ttsrv_getRecordField(l_node, "gem01")     #取得此筆單檔資料的欄位值
        IF cl_null(l_gem.gem01) THEN
           LET g_status.code = "-286"                                   #主鍵的欄位值不可為 NULL
           EXIT FOR
        END IF
 
        #MDM mapping表上可能傳入以下欄位
        LET l_gem.gem02   = aws_ttsrv_getRecordField(l_node,"gem02")    #員工姓名        
       #FUN-A20053 ---mark--str---
       #LET l_gem.gem09   = aws_ttsrv_getRecordField(l_node,"gem09")    #E-mail      
       ##FUN-A20045 ---add---str---
       #LET l_gem.gem03   = aws_ttsrv_getRecordField(l_node,"gem03")
       #LET l_gem.gem04   = aws_ttsrv_getRecordField(l_node,"gem04")
       #LET l_gem.gem05   = aws_ttsrv_getRecordField(l_node,"gem05")
       #LET l_gem.gem06   = aws_ttsrv_getRecordField(l_node,"gem06")
       #LET l_gem.gem07   = aws_ttsrv_getRecordField(l_node,"gem07")
       #LET l_gem.gem08   = aws_ttsrv_getRecordField(l_node,"gem08")
       #LET l_gem.gem10   = aws_ttsrv_getRecordField(l_node,"gem10")
       ##FUN-A20045 ---add---end---
       #FUN-A20053 ---mark--end---
       #FUN-A20053 ---add---str---
       #==>由"HR"CALL此Service時,當資料欲"更新(UPDATE)"時,
       #==>則關於會計資料的相關欄位(gem05/gem07/gem09/gem10)則不同步更新
        SELECT COUNT(*) INTO l_cnt2
          FROM gem_file
         WHERE gem01 = l_gem.gem01
        IF l_cnt2 >= 1 AND g_access.application = "HR" THEN
            LET l_gem.gem03   = aws_ttsrv_getRecordField(l_node,"gem03")
            LET l_gem.gem04   = aws_ttsrv_getRecordField(l_node,"gem04")
            LET l_gem.gem06   = aws_ttsrv_getRecordField(l_node,"gem06")
            LET l_gem.gem08   = aws_ttsrv_getRecordField(l_node,"gem08")
            LET l_gem.gemacti = aws_ttsrv_getRecordField(l_node,"gemacti")   #FUN-B50032
        ELSE
            LET l_gem.gem03   = aws_ttsrv_getRecordField(l_node,"gem03")
            LET l_gem.gem04   = aws_ttsrv_getRecordField(l_node,"gem04")
            LET l_gem.gem05   = aws_ttsrv_getRecordField(l_node,"gem05")
            LET l_gem.gem06   = aws_ttsrv_getRecordField(l_node,"gem06")
            LET l_gem.gem07   = aws_ttsrv_getRecordField(l_node,"gem07")
            LET l_gem.gem08   = aws_ttsrv_getRecordField(l_node,"gem08")
            LET l_gem.gem09   = aws_ttsrv_getRecordField(l_node,"gem09")
            LET l_gem.gem10   = aws_ttsrv_getRecordField(l_node,"gem10")
            LET l_gem.gemacti = aws_ttsrv_getRecordField(l_node,"gemacti")   #FUN-B50032
            IF l_gem.gem09 = '3' THEN #其它
                LET l_gem.gem10 = NULL
            END IF
        END IF
       #FUN-A20053 ---add---str---
                                                                         
        LET l_cnt=0
        SELECT COUNT(*) INTO l_cnt
          FROM gem_file
         WHERE gem01=l_gem.gem01
        IF l_cnt>0 THEN
           LET p_cmd='u'
        ELSE
           LET p_cmd='a'
        END IF
        CASE p_cmd
           WHEN "a"
              LET g_gem.*=l_gem.*
              LET g_action_choice=NULL
 
           WHEN "u"
              LET g_gem.gem01=l_gem.gem01
              #----------------------------------------------------------------------#
              # 修改前檢查                                                           #
              #----------------------------------------------------------------------#
              IF NOT aws_create_dept_updchk() THEN
                 CALL aws_create_dept_error()
                 EXIT FOR
              END IF
 
              LET g_gem_t.* = g_gem.*
              CALL aws_create_dept_field_update(l_gem.*)
              LET g_action_choice=NULL
 
           OTHERWISE
              LET g_status.code = 'aws-101'
              EXIT FOR
        END CASE
 
        #----------------------------------------------------------------------#
        # 指定g_gem Default                                                    #
        #----------------------------------------------------------------------#
        IF p_cmd='a' THEN
           CALL p_gem_default()       
        END IF
 
        #----------------------------------------------------------------------#
        # 新增前檢查                                                           #
        #----------------------------------------------------------------------#        
 
        #避免傳入值在途中被改掉,需重新指定一次g_gem
        CALL aws_create_dept_field_update(l_gem.*)
 
        #------------------------------------------------------------------#
        # RECORD資料傳到NODE                                               #
        #------------------------------------------------------------------#
        CALL aws_ttsrv_setRecordField_record(l_node,base.Typeinfo.create(g_gem))
 
        #----------------------------------------------------------------------#
        # 判斷此資料是否已經建立, 若已建立則為 Update                          #
        #----------------------------------------------------------------------#
        SELECT COUNT(*) INTO l_cnt2 FROM gem_file WHERE gem01 = g_gem.gem01
        IF l_cnt2 = 0 THEN
           LET l_sql = aws_ttsrv_getRecordSql(l_node, "gem_file", "I", NULL)   #I 表示取得 INSERT SQL
        ELSE
           LET l_wc = " gem01 = '", g_gem.gem01 CLIPPED, "' "                  #UPDATE SQL 時的 WHERE condition
           LET l_sql = aws_ttsrv_getRecordSql(l_node, "gem_file", "U", l_wc)   #U 表示取得 UPDATE SQL
        END IF
 
        #----------------------------------------------------------------------#
        # 執行 INSERT / UPDATE SQL                                             #
        #----------------------------------------------------------------------#
        EXECUTE IMMEDIATE l_sql
        IF SQLCA.SQLCODE THEN
           LET g_status.code = SQLCA.SQLCODE
           LET g_status.sqlcode = SQLCA.SQLCODE
           EXIT FOR
        END IF
    END FOR
 
    #全部處理都成功才 COMMIT WORK
    IF g_status.code = "0" THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
END FUNCTION
 
FUNCTION aws_create_dept_error()
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
 
#將l_gem中非NULL的欄位值(本次更新的欄位)更新到g_gem
FUNCTION aws_create_dept_field_update(l_gem)
DEFINE l_gem RECORD LIKE gem_file.*
   IF NOT cl_null(l_gem.gem01) THEN LET g_gem.gem01 = l_gem.gem01 END IF
   IF NOT cl_null(l_gem.gem02) THEN LET g_gem.gem02 = l_gem.gem02 END IF   
   #FUN-A20045--add---str--
   IF NOT cl_null(l_gem.gem03) THEN LET g_gem.gem03 = l_gem.gem03 END IF
   IF NOT cl_null(l_gem.gem04) THEN LET g_gem.gem04 = l_gem.gem04 END IF
   IF NOT cl_null(l_gem.gem05) THEN LET g_gem.gem05 = l_gem.gem05 END IF
   IF NOT cl_null(l_gem.gem06) THEN LET g_gem.gem06 = l_gem.gem06 END IF
   IF NOT cl_null(l_gem.gem07) THEN LET g_gem.gem07 = l_gem.gem07 END IF
   IF NOT cl_null(l_gem.gem08) THEN LET g_gem.gem08 = l_gem.gem08 END IF
   IF NOT cl_null(l_gem.gem09) THEN LET g_gem.gem09 = l_gem.gem09 END IF
   IF NOT cl_null(l_gem.gem10) THEN LET g_gem.gem10 = l_gem.gem10 END IF
   IF NOT cl_null(l_gem.gemacti) THEN LET g_gem.gemacti = l_gem.gemacti END IF   #FUN-B50032
   IF g_gem.gem09 = '3' THEN #其它
       LET g_gem.gem10 = NULL
   END IF
   #FUN-A20045--add---end--
END FUNCTION
 
FUNCTION aws_create_dept_updchk()
   OPEN gem_cl USING g_gem.gem01
   IF STATUS THEN
      CALL cl_err("OPEN gem_cl:", STATUS, 1)
      CLOSE gem_cl
      RETURN FALSE
   END IF
   FETCH gem_cl INTO g_gem.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gem.gem01,SQLCA.sqlcode,0)
      RETURN FALSE
   END IF
   LET g_gem.gemmodu = g_user                   #修改者
   LET g_gem.gemdate = g_today
   RETURN TRUE
END FUNCTION
 
FUNCTION p_gem_default()
   LET g_gem.gemacti = 'Y'
   LET g_gem.gemuser = g_user
   LET g_gem.gemdate = g_today   
   LET g_gem.gemgrup = g_grup     #FUN-B50032  #使用者所屬群
END FUNCTION
 
FUNCTION aws_create_dept_field_check()
   DEFINE p_cmd LIKE type_file.chr1
   
   IF NOT i030_chk_gem01() THEN
      RETURN FALSE
   END IF
 
END FUNCTION
 
FUNCTION i030_chk_gem01()
   DEFINE l_n LIKE type_file.num5
   IF NOT cl_null(g_gem.gem01) THEN
      IF g_gem.gem01 != g_gem_t.gem01 OR
         g_gem_t.gem01 IS NULL THEN
         SELECT count(*) INTO l_n FROM gem_file
          WHERE gem01 = g_gem.gem01
         IF l_n > 0 THEN
            CALL cl_err('',-239,0)
            RETURN FALSE
         END IF
      END IF
   END IF
   RETURN TRUE
END FUNCTION
#FUN-AA0022
