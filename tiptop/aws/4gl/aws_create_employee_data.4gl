# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_create_employee_data.4gl
# Descriptions...: 提供建立員工基本資料的服務
# Date & Author..: 2008/06/11 by kim
# Memo...........:
# Modify.........: 新建立 FUN-860036
# Modify.........: No.FUN-AA0022 10/10/13 By Mandy HR GP5.2 追版-------str----
# Modify.........: No:FUN-A20045 10/02/22 By Mandy 若傳入的某些欄位並沒有全部建立#FUN-A20053
# Modify.........: No.FUN-AA0022 10/10/13 By Mandy HR GP5.2 追版-------end----
# Modify.........: No:FUN-C40038 12/06/28 By Mandy 需多接收員工有效無效碼(genacti)
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B40071 11/05/09 by jason 已傳POS否狀態調整
# Modify.........: No.FUN-B50032 11/05/12 By Jay  CROSS-MDM整合
 
DATABASE ds
 
#FUN-860036
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
 
GLOBALS
DEFINE g_gen         RECORD LIKE gen_file.*
DEFINE g_gen_t       RECORD LIKE gen_file.*
END GLOBALS
 
#[
# Description....: 提供建立員工基本資料的服務(入口 function)
# Date & Author..: 2007/06/11 by kim
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_employee_data()
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
 
    #--------------------------------------------------------------------------#
    # 新增員工基本資料                                                         #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_create_employee_data_process()
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
FUNCTION aws_create_employee_data_process()
    DEFINE l_i       LIKE type_file.num10
    DEFINE l_sql     STRING
    DEFINE l_cnt     LIKE type_file.num5
    DEFINE l_cnt1    LIKE type_file.num10,
           l_cnt2    LIKE type_file.num10
    DEFINE l_wc      STRING
    DEFINE l_node    om.DomNode
    DEFINE l_gen     RECORD LIKE gen_file.*
    DEFINE p_cmd     LIKE type_file.chr1
    DEFINE l_forupd_sql STRING
 
    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的員工基本資料                                      #
    #--------------------------------------------------------------------------#
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("gen_file")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***
    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       RETURN
    END IF
 
    LET l_forupd_sql = " SELECT * FROM gen_file WHERE gen01 = ? FOR UPDATE "
    LET l_forupd_sql=cl_forupd_sql(l_forupd_sql)

    DECLARE i040_cl CURSOR FROM l_forupd_sql
 
    BEGIN WORK
 
    FOR l_i = 1 TO l_cnt1
        INITIALIZE l_gen.* TO NULL
        LET gi_err_code=NULL
 
        LET l_node = aws_ttsrv_getMasterRecord(l_i, "gen_file")         #目前處理單檔的 XML 節點
        LET l_gen.gen01 = aws_ttsrv_getRecordField(l_node, "gen01")     #取得此筆單檔資料的欄位值
        IF cl_null(l_gen.gen01) THEN
           LET g_status.code = "-286"                                   #主鍵的欄位值不可為 NULL
           EXIT FOR
        END IF
 
        #MDM mapping表上可能傳入以下欄位
        LET l_gen.gen02   = aws_ttsrv_getRecordField(l_node,"gen02")    #員工姓名    
        LET l_gen.gen03   = aws_ttsrv_getRecordField(l_node,"gen03")    #所屬部門編號
        LET l_gen.gen04   = aws_ttsrv_getRecordField(l_node,"gen04")    #職稱 #FUN-A20045 add
        LET l_gen.gen05   = aws_ttsrv_getRecordField(l_node,"gen05")    #分機        
        LET l_gen.gen06   = aws_ttsrv_getRecordField(l_node,"gen06")    #E-mail      
        LET l_gen.genacti   = aws_ttsrv_getRecordField(l_node,"genacti")#有效/無效碼  #FUN-B50032 add  
        LET l_gen.genpos  = aws_ttsrv_getRecordField(l_node,"genpos")   #已傳POS否 #FUN-AA0022 add
        #FUN-AA0022 add---str---
        IF cl_null(l_gen.genpos) THEN 
            LET l_gen.genpos = '1' #NO.FUN-B40071 
        END IF
        #FUN-AA0022 add---end---
                                                                         
        LET l_cnt=0
        SELECT COUNT(*) INTO l_cnt
          FROM gen_file
         WHERE gen01=l_gen.gen01
        IF l_cnt>0 THEN
           LET p_cmd='u'
        ELSE
           LET p_cmd='a'
        END IF
        CASE p_cmd
           WHEN "a"
              LET g_gen.*=l_gen.*
              LET g_action_choice=NULL
 
           WHEN "u"
              LET g_gen.gen01=l_gen.gen01
              #----------------------------------------------------------------------#
              # 修改前檢查                                                           #
              #----------------------------------------------------------------------#
              IF NOT aws_create_employee_updchk() THEN
                 CALL aws_create_employee_error()
                 EXIT FOR
              END IF
 
              LET g_gen_t.* = g_gen.*
              CALL aws_create_employee_field_update(l_gen.*)
              LET g_action_choice=NULL
 
           OTHERWISE
              LET g_status.code = 'aws-101'
              EXIT FOR
        END CASE
 
        #----------------------------------------------------------------------#
        # 指定g_gen Default                                                    #
        #----------------------------------------------------------------------#
        IF p_cmd='a' THEN
           CALL i040_default()
        END IF
 
        #----------------------------------------------------------------------#
        # g_gen欄位檢查                                                        #
        #----------------------------------------------------------------------#
        IF NOT aws_create_employee_field_check() THEN
           CALL aws_create_employee_error()
           EXIT FOR
        END IF
 
        #----------------------------------------------------------------------#
        # 新增前檢查                                                           #
        #----------------------------------------------------------------------#
        #None.
 
        #避免傳入值在途中被改掉,需重新指定一次g_gen
        CALL aws_create_employee_field_update(l_gen.*)
 
        #------------------------------------------------------------------#
        # RECORD資料傳到NODE                                               #
        #------------------------------------------------------------------#
        CALL aws_ttsrv_setRecordField_record(l_node,base.Typeinfo.create(g_gen))
 
        #----------------------------------------------------------------------#
        # 判斷此資料是否已經建立, 若已建立則為 Update                          #
        #----------------------------------------------------------------------#
        SELECT COUNT(*) INTO l_cnt2 FROM gen_file WHERE gen01 = g_gen.gen01
        IF l_cnt2 = 0 THEN
           LET l_sql = aws_ttsrv_getRecordSql(l_node, "gen_file", "I", NULL)   #I 表示取得 INSERT SQL
        ELSE
           LET l_wc = " gen01 = '", g_gen.gen01 CLIPPED, "' "                  #UPDATE SQL 時的 WHERE condition
           LET l_sql = aws_ttsrv_getRecordSql(l_node, "gen_file", "U", l_wc)   #U 表示取得 UPDATE SQL
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
 
FUNCTION aws_create_employee_error()
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
 
#將l_gen中非NULL的欄位值(本次更新的欄位)更新到g_gen
FUNCTION aws_create_employee_field_update(l_gen)
DEFINE l_gen RECORD LIKE gen_file.*
   IF NOT cl_null(l_gen.gen01) THEN LET g_gen.gen01 = l_gen.gen01 END IF
   IF NOT cl_null(l_gen.gen02) THEN LET g_gen.gen02 = l_gen.gen02 END IF
   IF NOT cl_null(l_gen.gen03) THEN LET g_gen.gen03 = l_gen.gen03 END IF
   IF NOT cl_null(l_gen.gen04) THEN LET g_gen.gen04 = l_gen.gen04 END IF #FUN-A20045 add
   IF NOT cl_null(l_gen.gen05) THEN LET g_gen.gen05 = l_gen.gen05 END IF
   IF NOT cl_null(l_gen.gen06) THEN LET g_gen.gen06 = l_gen.gen06 END IF
   IF NOT cl_null(l_gen.genacti) THEN LET g_gen.genacti = l_gen.genacti END IF #FUN-B50032 add
END FUNCTION
 
FUNCTION aws_create_employee_updchk()
   OPEN i040_cl USING g_gen.gen01
   IF STATUS THEN
      CALL cl_err("OPEN i040_cl:", STATUS, 1)
      CLOSE i040_cl
      RETURN FALSE
   END IF
   FETCH i040_cl INTO g_gen.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gen.gen01,SQLCA.sqlcode,0)
      RETURN FALSE
   END IF
   LET g_gen.genmodu = g_user                   #修改者
   LET g_gen.gendate = g_today
   RETURN TRUE
END FUNCTION
 
FUNCTION i040_default()
   IF cl_null(g_gen.genacti) THEN #FUN-C40038 add if 判斷
       LET g_gen.genacti = 'Y'
   END IF                         #FUN-C40038 add
   LET g_gen.genuser = g_user   # 使用者
   LET g_gen.gengrup = g_grup              # 使用者所屬群
   LET g_gen.gendate = g_today    # 更改日期
END FUNCTION
 
FUNCTION aws_create_employee_field_check()
   DEFINE p_cmd LIKE type_file.chr1
   
   IF NOT i040_chk_gen01() THEN
      RETURN FALSE
   END IF
   IF NOT i040_chk_gen03() THEN
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i040_chk_gen01()
   DEFINE l_n LIKE type_file.num5
   IF NOT cl_null(g_gen.gen01) THEN
      IF g_gen.gen01 != g_gen_t.gen01 OR
         g_gen_t.gen01 IS NULL THEN
         SELECT count(*) INTO l_n FROM gen_file
          WHERE gen01 = g_gen.gen01
         IF l_n > 0 THEN
            CALL cl_err('',-239,0)
            RETURN FALSE
         END IF
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i040_chk_gen03()
   IF NOT cl_null(g_gen.gen03) THEN
      CALL i040_gen03('a')
      IF NOT cl_null(g_errno)  THEN
         RETURN FALSE
      END IF
   END IF 
   RETURN TRUE
END FUNCTION
 
FUNCTION i040_gen03(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,    #No.FUN-680102 VARCHAR(1)
    l_gemacti       LIKE gem_file.gemacti
 
    LET g_errno = ' '
    SELECT gemacti INTO l_gemacti
        FROM gem_file
        WHERE gem01 = g_gen.gen03
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aoo-005'
         WHEN l_gemacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
#FUN-A20053
