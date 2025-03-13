# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_create_vendor_data.4gl
# Descriptions...: 提供建立廠商基本資料的服務
# Date & Author..: 2008/06/11 by kim
# Memo...........:
# Modify.........: 新建立 FUN-860036
# Modify.........: 08/09/24 By kevin FUN-890113 多筆傳送
# Modify.........: No.FUN-930113 09/03/19 By mike 將oah_file-->pnz_file
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowi定義規範化
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.           09/10/21 By lilingyu r.c2 fail
# Modify.........: No.FUN-C40009 13/01/10 By Nina 只要程式有UPDATE pmh_file 的任何一個欄位時,多加pmhdate=g_today 

DATABASE ds
 
#FUN-860036
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
 
GLOBALS
DEFINE g_pmc         RECORD LIKE pmc_file.*
DEFINE g_pmc_t       RECORD LIKE pmc_file.*
DEFINE g_pmc_o       RECORD LIKE pmc_file.*
END GLOBALS
 
#[
# Description....: 提供建立廠商基本資料的服務(入口 function)
# Date & Author..: 2007/06/11 by kim
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_vendor_data()
 
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
 
    #--------------------------------------------------------------------------#
    # 新增廠商基本資料                                                         #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_create_vendor_data_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
 
#[
# Description....: 依據傳入資訊新增一筆 ERP 廠商基本資料
# Date & Author..: 2007/06/11 by kim
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_vendor_data_process()
    DEFINE l_i       LIKE type_file.num10
    DEFINE l_sql     STRING
    DEFINE l_cnt     LIKE type_file.num5
    DEFINE l_cnt1    LIKE type_file.num10,
           l_cnt2    LIKE type_file.num10
    DEFINE l_wc      STRING
    DEFINE l_node    om.DomNode
    DEFINE l_pmc     RECORD LIKE pmc_file.*
    DEFINE p_cmd     LIKE type_file.chr1
    DEFINE l_forupd_sql STRING
 
    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的廠商基本資料                                      #
    #--------------------------------------------------------------------------#
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("pmc_file")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***
    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       RETURN
    END IF
 
    LET l_forupd_sql = " SELECT * FROM pmc_file WHERE pmc01 = ? FOR UPDATE "  
    LET l_forupd_sql=cl_forupd_sql(l_forupd_sql)

    DECLARE i600_cl CURSOR FROM l_forupd_sql
 
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
    SELECT * INTO g_aza.* FROM aza_file WHERE aza01='0'
 
    BEGIN WORK
 
    FOR l_i = 1 TO l_cnt1
        INITIALIZE l_pmc.* TO NULL
        INITIALIZE g_pmc_t.* TO NULL
        INITIALIZE g_pmc_o.* TO NULL
        LET gi_err_code=NULL
 
        LET l_node = aws_ttsrv_getMasterRecord(l_i, "pmc_file")         #目前處理單檔的 XML 節點
        LET l_pmc.pmc01 = aws_ttsrv_getRecordField(l_node, "pmc01")     #取得此筆單檔資料的欄位值
        IF cl_null(l_pmc.pmc01) THEN
           LET g_status.code = "-286"                                   #主鍵的欄位值不可為 NULL
           EXIT FOR
        END IF
 
        #MDM mapping表上可能傳入以下欄位
        LET l_pmc.pmc02   = aws_ttsrv_getRecordField(l_node,"pmc02")    #廠商分類
        LET l_pmc.pmc03   = aws_ttsrv_getRecordField(l_node,"pmc03")    #簡稱
        LET l_pmc.pmc05   = aws_ttsrv_getRecordField(l_node,"pmc05")    #交易狀況
        LET l_pmc.pmc06   = aws_ttsrv_getRecordField(l_node,"pmc06")    #區域代號
        LET l_pmc.pmc07   = aws_ttsrv_getRecordField(l_node,"pmc07")    #國別代號
        LET l_pmc.pmc081  = aws_ttsrv_getRecordField(l_node,"pmc081")   #全名(第一行)
        LET l_pmc.pmc091  = aws_ttsrv_getRecordField(l_node,"pmc091")   #地址(第一行)
        LET l_pmc.pmc092  = aws_ttsrv_getRecordField(l_node,"pmc092")   #地址(第二行)
        LET l_pmc.pmc10   = aws_ttsrv_getRecordField(l_node,"pmc10")    #電話號碼
        LET l_pmc.pmc11   = aws_ttsrv_getRecordField(l_node,"pmc11")    #傳真號碼
        LET l_pmc.pmc16   = aws_ttsrv_getRecordField(l_node,"pmc16")    #帳單地址
        LET l_pmc.pmc17   = aws_ttsrv_getRecordField(l_node,"pmc17")    #付款方式
        LET l_pmc.pmc18   = aws_ttsrv_getRecordField(l_node,"pmc18")    #廠商評鑑/ABC 等級
        LET l_pmc.pmc22   = aws_ttsrv_getRecordField(l_node,"pmc22")    #採購幣別
        LET l_pmc.pmc24   = aws_ttsrv_getRecordField(l_node,"pmc24")    #統一編號
        LET l_pmc.pmc26   = aws_ttsrv_getRecordField(l_node,"pmc26")    #應付帳款會計科目
        LET l_pmc.pmc27   = aws_ttsrv_getRecordField(l_node,"pmc27")    #票據寄領方式
        LET l_pmc.pmc47   = aws_ttsrv_getRecordField(l_node,"pmc47")    #慣用稅別
        LET l_pmc.pmc49   = aws_ttsrv_getRecordField(l_node,"pmc49")    #慣用價格條件
        LET l_pmc.pmc55   = aws_ttsrv_getRecordField(l_node,"pmc55")    #匯款銀行編號
        LET l_pmc.pmc56   = aws_ttsrv_getRecordField(l_node,"pmc56")    #銀行帳號
        LET l_pmc.pmc904  = aws_ttsrv_getRecordField(l_node,"pmc904")   #郵遞區號
        LET l_pmc.pmc1916 = aws_ttsrv_getRecordField(l_node,"pmc1916")  #負責人
 
        LET l_cnt=0
        SELECT COUNT(*) INTO l_cnt
          FROM pmc_file
         WHERE pmc01=l_pmc.pmc01
        IF l_cnt>0 THEN
           LET p_cmd='u'
        ELSE
           LET p_cmd='a'
        END IF
        CASE p_cmd
           WHEN "a"
              LET g_pmc.*=l_pmc.*
              INITIALIZE g_pmc_t.* TO NULL
              INITIALIZE g_pmc_o.* TO NULL
              LET g_action_choice=NULL
 
           WHEN "u"
           #  SELECT pmc_file.rowi INTO g_pmc_rowi FROM pmc_file WHERE pmc01=l_pmc.pmc01 #091021
              SELECT pmc01 INTO g_pmc.pmc01 FROM pmc_file WHERE pmc01=l_pmc.pmc01   #091021
              IF SQLCA.sqlcode THEN
                 LET g_status.code = SQLCA.sqlcode
                 EXIT FOR
              END IF
              #----------------------------------------------------------------------#
              # 修改前檢查                                                           #
              #----------------------------------------------------------------------#
              IF NOT aws_create_vendor_updchk() THEN
                 CALL aws_create_vendor_error()
                 EXIT FOR
              END IF
 
              LET g_pmc_t.* = g_pmc.*
              LET g_pmc_o.* = g_pmc.*
              CALL aws_create_vendor_field_update(l_pmc.*)
              LET g_action_choice=NULL
 
           OTHERWISE
              LET g_status.code = 'aws-101'
              EXIT FOR
        END CASE
 
        #----------------------------------------------------------------------#
        # 指定g_pmc Default                                                    #
        #----------------------------------------------------------------------#
        IF p_cmd='a' THEN
           CALL i600_default()
        END IF
 
        #----------------------------------------------------------------------#
        # g_pmc欄位檢查                                                        #
        #----------------------------------------------------------------------#
        IF NOT aws_create_vendor_field_check(p_cmd) THEN
           CALL aws_create_vendor_error()
           EXIT FOR
        END IF
 
        #----------------------------------------------------------------------#
        # 新增前檢查                                                           #
        #----------------------------------------------------------------------#
        IF p_cmd='a' THEN
           IF NOT i600_a_inschk() THEN
              CALL aws_create_vendor_error()
              EXIT FOR
           END IF
        END IF
 
        #避免傳入值在途中被改掉,需重新指定一次g_pmc
        CALL aws_create_vendor_field_update(l_pmc.*)
 
        #------------------------------------------------------------------#
        # RECORD資料傳到NODE                                               #
        #------------------------------------------------------------------#
        CALL aws_ttsrv_setRecordField_record(l_node,base.Typeinfo.create(g_pmc))
 
        #----------------------------------------------------------------------#
        # 判斷此資料是否已經建立, 若已建立則為 Update                          #
        #----------------------------------------------------------------------#
        SELECT COUNT(*) INTO l_cnt2 FROM pmc_file WHERE pmc01 = g_pmc.pmc01
        IF l_cnt2 = 0 THEN
           LET l_sql = aws_ttsrv_getRecordSql(l_node, "pmc_file", "I", NULL)   #I 表示取得 INSERT SQL
        ELSE
           LET l_wc = " pmc01 = '", g_pmc.pmc01 CLIPPED, "' "                  #UPDATE SQL 時的 WHERE condition
           LET l_sql = aws_ttsrv_getRecordSql(l_node, "pmc_file", "U", l_wc)   #U 表示取得 UPDATE SQL
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
 
FUNCTION aws_create_vendor_error()
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
 
#將l_pmc中非NULL的欄位值(本次更新的欄位)更新到g_pmc
FUNCTION aws_create_vendor_field_update(l_pmc)
DEFINE l_pmc RECORD LIKE pmc_file.*
 
   IF NOT cl_null(l_pmc.pmc01  ) THEN LET g_pmc.pmc01   =l_pmc.pmc01    END IF  #供應廠商編號     
   IF NOT cl_null(l_pmc.pmc02  ) THEN LET g_pmc.pmc02   =l_pmc.pmc02    END IF  #廠商分類         
   IF NOT cl_null(l_pmc.pmc03  ) THEN LET g_pmc.pmc03   =l_pmc.pmc03    END IF  #簡稱             
   IF NOT cl_null(l_pmc.pmc05  ) THEN LET g_pmc.pmc05   =l_pmc.pmc05    END IF  #交易狀況         
   IF NOT cl_null(l_pmc.pmc06  ) THEN LET g_pmc.pmc06   =l_pmc.pmc06    END IF  #區域代號         
   IF NOT cl_null(l_pmc.pmc07  ) THEN LET g_pmc.pmc07   =l_pmc.pmc07    END IF  #國別代號         
   IF NOT cl_null(l_pmc.pmc081 ) THEN LET g_pmc.pmc081  =l_pmc.pmc081   END IF  #全名 (第一行)    
   IF NOT cl_null(l_pmc.pmc091 ) THEN LET g_pmc.pmc091  =l_pmc.pmc091   END IF  #地址(第一行)     
   IF NOT cl_null(l_pmc.pmc092 ) THEN LET g_pmc.pmc092  =l_pmc.pmc092   END IF  #地址(第二行)     
   IF NOT cl_null(l_pmc.pmc10  ) THEN LET g_pmc.pmc10   =l_pmc.pmc10    END IF  #電話號碼         
   IF NOT cl_null(l_pmc.pmc11  ) THEN LET g_pmc.pmc11   =l_pmc.pmc11    END IF  #傳真號碼         
   IF NOT cl_null(l_pmc.pmc16  ) THEN LET g_pmc.pmc16   =l_pmc.pmc16    END IF  #帳單地址         
   IF NOT cl_null(l_pmc.pmc17  ) THEN LET g_pmc.pmc17   =l_pmc.pmc17    END IF  #付款方式         
   IF NOT cl_null(l_pmc.pmc18  ) THEN LET g_pmc.pmc18   =l_pmc.pmc18    END IF  #廠商評鑑/ABC 等級
   IF NOT cl_null(l_pmc.pmc22  ) THEN LET g_pmc.pmc22   =l_pmc.pmc22    END IF  #採購幣別         
   IF NOT cl_null(l_pmc.pmc24  ) THEN LET g_pmc.pmc24   =l_pmc.pmc24    END IF  #統一編號         
   IF NOT cl_null(l_pmc.pmc26  ) THEN LET g_pmc.pmc26   =l_pmc.pmc26    END IF  #應付帳款會計科目 
   IF NOT cl_null(l_pmc.pmc27  ) THEN LET g_pmc.pmc27   =l_pmc.pmc27    END IF  #票據寄領方式     
   IF NOT cl_null(l_pmc.pmc47  ) THEN LET g_pmc.pmc47   =l_pmc.pmc47    END IF  #慣用稅別         
   IF NOT cl_null(l_pmc.pmc49  ) THEN LET g_pmc.pmc49   =l_pmc.pmc49    END IF  #慣用價格條件     
   IF NOT cl_null(l_pmc.pmc55  ) THEN LET g_pmc.pmc55   =l_pmc.pmc55    END IF  #匯款銀行編號     
   IF NOT cl_null(l_pmc.pmc56  ) THEN LET g_pmc.pmc56   =l_pmc.pmc56    END IF  #銀行帳號         
   IF NOT cl_null(l_pmc.pmc904 ) THEN LET g_pmc.pmc904  =l_pmc.pmc904   END IF  #郵遞區號         
   IF NOT cl_null(l_pmc.pmc1916) THEN LET g_pmc.pmc1916 =l_pmc.pmc1916  END IF  #負責人           
END FUNCTION
 
FUNCTION aws_create_vendor_updchk()
 # OPEN i600_cl USING g_pmc_rowi   #091021
   OPEN i600_cl USING g_pmc.pmc01  #091021
   IF STATUS THEN
      CALL cl_err("OPEN i600_cl:", STATUS, 1)
      CLOSE i600_cl
      RETURN FALSE
   END IF
   FETCH i600_cl INTO g_pmc.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pmc.pmc01,SQLCA.sqlcode,0)
      RETURN FALSE
   END IF
   LET g_pmc.pmcmodu = g_user                   #修改者
   LET g_pmc.pmcdate = g_today
   RETURN TRUE
END FUNCTION
 
FUNCTION i600_default()
   LET g_pmc.pmc05 = '0'        # 目前狀況
   LET g_pmc.pmc14 = '1'        # 資料性質
   IF cl_null(g_pmc.pmc14) THEN LET g_pmc.pmc14 = '1' END IF
   LET g_pmc.pmc22 = g_aza.aza17   # 幣別
   LET g_pmc.pmc23 = 'Y'           # 列印預設
   LET g_pmc.pmc27 = '1'           # 寄領方式
   LET g_pmc.pmc30 = '3'           # 廠商性質預設為兩者
   LET g_pmc.pmc45 =  0         # AP AMT
   LET g_pmc.pmc46 =  0         # AP AMT
   LET g_pmc.pmc48 =  'Y'         # 禁止背書
   LET g_pmc.pmc912 = 'N'         # 不發給廠商
   LET g_pmc.pmc902 = '0'
   LET g_pmc.pmc903 = 'N'
   LET g_pmc.pmc911 = g_lang
   LET g_pmc.pmc1920 = g_plant
   LET g_pmc.pmcacti = 'P'
   LET g_pmc.pmcuser = g_user   # 使用者
   LET g_pmc.pmcoriu = g_user #FUN-980030
   LET g_pmc.pmcorig = g_grup #FUN-980030
   LET g_pmc.pmcgrup = g_grup              # 使用者所屬群
   LET g_pmc.pmcdate = g_today    # 更改日期
 
   #MDM暫不考慮
   #IF g_aza.aza30 = 'Y' THEN
   #   CALL s_auno(g_pmc.pmc01,'3','') RETURNING g_pmc.pmc01,g_pmc.pmc03
   #END IF
END FUNCTION
 
FUNCTION aws_create_vendor_field_check(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1
   
   IF NOT i600_chk_pmc01(p_cmd) THEN
      RETURN FALSE
   END IF
   IF NOT i600_chk_pmc03() THEN
      RETURN FALSE
   END IF
   IF NOT i600_chk_pmc908(p_cmd) THEN
      RETURN FALSE
   END IF
   IF NOT i600_chk_pmc05() THEN
      RETURN FALSE
   END IF
   IF NOT i600_chk_pmc14() THEN
      RETURN FALSE
   END IF
   IF NOT i600_chk_pmc30() THEN
      RETURN FALSE
   END IF
  #FUN-890113 start
  #IF NOT i600_chk_pmc04() THEN
  #   RETURN FALSE
  #END IF
  #IF NOT i600_chk_pmc901() THEN
  #   RETURN FALSE
  #END IF
  #FUN-890113 end 
   IF NOT i600_chk_pmc24() THEN
      RETURN FALSE
   END IF
   IF NOT i600_chk_pmc091() THEN
      RETURN FALSE
   END IF
   IF NOT i600_chk_pmc22() THEN
      RETURN FALSE
   END IF
   IF NOT i600_chk_pmc47() THEN
      RETURN FALSE
   END IF
   IF NOT i600_chk_pmc54() THEN
      RETURN FALSE
   END IF
   IF NOT i600_chk_pmc50() THEN
      RETURN FALSE
   END IF
   IF NOT i600_chk_pmc51() THEN
      RETURN FALSE
   END IF
   IF NOT i600_chk_pmc15() THEN
      RETURN FALSE
   END IF
   IF NOT i600_chk_pmc16() THEN
      RETURN FALSE
   END IF
   IF NOT i600_chk_pmc49() THEN
      RETURN FALSE
   END IF
   IF NOT i600_chk_pmc27() THEN
      RETURN FALSE
   END IF
   IF NOT i600_chk_pmc55() THEN
      RETURN FALSE
   END IF
   IF NOT i600_chk_pmc17() THEN
      RETURN FALSE
   END IF
   IF NOT i600_chk_pmc28() THEN
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i600_chk_pmc01(p_cmd)
   DEFINE l_n LIKE type_file.num5
   DEFINE p_cmd LIKE type_file.chr1
   DEFINE l_flag     LIKE type_file.chr1
 
   IF p_cmd = "a" OR
     (p_cmd = "u" AND g_pmc.pmc01 != g_pmc_t.pmc01) THEN
      SELECT COUNT(*) INTO l_n FROM pmc_file
       WHERE pmc01 = g_pmc.pmc01
      IF l_n > 0 THEN                  # Duplicated
         CALL cl_err(g_pmc.pmc01,'apm-036',0)
         RETURN FALSE
      ELSE
         CALL s_field_chk(g_pmc.pmc01,'5',g_plant,'pmc01') RETURNING l_flag
         IF l_flag = '0' THEN
            CALL cl_err(g_pmc.pmc01,'aoo-043',1)
            RETURN FALSE
         ELSE
            IF g_pmc.pmc30='3' THEN
               LET g_pmc.pmc04=g_pmc.pmc01
               LET g_pmc.pmc901=g_pmc.pmc01   #no.5138
            END IF
         END IF                          #No.FUN-820034
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i600_chk_pmc03()
   DEFINE l_n LIKE type_file.num5
 
   IF NOT cl_null(g_pmc.pmc03) THEN
      LET l_n =0
      SELECT count(*) INTO l_n FROM pmc_file
       WHERE pmc03 = g_pmc.pmc03 AND pmc01 != g_pmc.pmc01
      IF l_n > 0 THEN
         CALL cl_err('','apm-035',0)
         RETURN FALSE
      END IF
      IF cl_null(g_pmc.pmc081)  THEN
         LET g_pmc.pmc081=g_pmc.pmc03
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i600_chk_pmc908(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1
   IF NOT cl_null(g_pmc.pmc908)  THEN
      CALL i600_pmc908('a')
      IF NOT cl_null(g_errno) THEN
         CALL cl_err(g_pmc.pmc908,g_errno,0)
         RETURN FALSE
      END IF
   ELSE
      LET g_pmc.pmc06 = ' '
      LET g_pmc.pmc07 = ' '
   END IF
   IF NOT cl_null(g_errno) THEN
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i600_pmc908(p_cmd)  #地區代號
   DEFINE   p_cmd       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
            l_geo03     LIKE geb_file.geb03,    #國別代號
            l_geb02     LIKE gea_file.gea02,    #國別名稱
            l_geo02     LIKE geb_file.geb02,    #地區代號
            l_geoacti   LIKE geb_file.gebacti,    #有效碼
            l_gea02     LIKE gea_file.gea02             #區域名稱
 
   LET g_errno = ' '
   SELECT geo03,geoacti,geo02
     INTO l_geo03,l_geoacti,l_geo02
     FROM geo_file
    WHERE geo01 = g_pmc.pmc908
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3011'   #FUN-550091
                                  LET l_geo03   = NULL
                                  LET l_geoacti = NULL
        WHEN l_geoacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF p_cmd = 'a' OR cl_null(g_errno)  THEN
      LET g_pmc.pmc07 = l_geo03
      SELECT geb02 INTO l_geb02 FROM geb_file WHERE geb01 = g_pmc.pmc07
      SELECT gea01,gea02 INTO g_pmc.pmc06,l_gea02 FROM gea_file,geb_file
             WHERE gea01 = geb03 AND geb01 = l_geo03
   END IF
END FUNCTION
 
FUNCTION i600_area(p_no,p_code)  #區域代號
   DEFINE   p_no        LIKE pme_file.pme01,
            p_code      LIKE pme_file.pme02,
            l_pme02     LIKE pme_file.pme02,
            l_pmeacti   LIKE pme_file.pmeacti
 
   LET g_errno = ' '
   SELECT pme02,pmeacti INTO l_pme02,l_pmeacti
     FROM pme_file
    WHERE pme01 = p_no
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3345'
                                  LET l_pmeacti = NULL
        WHEN p_code = '0'  IF l_pme02 = '1' THEN LET g_errno = 'mfg3019' END IF
        WHEN p_code = '1'  IF l_pme02 = '0' THEN LET g_errno = 'mfg3026' END IF
        WHEN l_pmeacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
 
FUNCTION i600_pmc17(p_cmd)  #付款方式
   DEFINE   p_cmd        LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
            l_pma02      LIKE pma_file.pma02,
            l_pmaacti    LIKE pma_file.pmaacti
 
   LET g_errno = ' '
   LET l_pma02 = ' '
   SELECT pma02,pmaacti
          INTO l_pma02,l_pmaacti
          FROM pma_file WHERE pma01 = g_pmc.pmc17
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3099'
                           LET l_pmaacti = NULL  LET l_pma02=NULL
        WHEN l_pmaacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
 
FUNCTION i600_pmc22(p_cmd)  #幣別
   DEFINE   p_cmd       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
            l_azi02     LIKE azi_file.azi02,
            l_aziacti   LIKE azi_file.aziacti
 
   LET g_errno = ' '
   SELECT aziacti,azi02
     INTO l_aziacti,l_azi02
     FROM azi_file WHERE azi01=g_pmc.pmc22
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3008'
                                  LET l_aziacti = NULL
                                  LET l_azi02 = NULL
        WHEN l_aziacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
 
FUNCTION i600_pmc47(p_cmd)  #幣別
   DEFINE   p_cmd       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
            l_gec02     LIKE gec_file.gec02,
            l_gecacti   LIKE gec_file.gecacti
 
   LET g_errno = ' '
   SELECT gecacti,gec02
     INTO l_gecacti,l_gec02
     FROM gec_file WHERE gec01=g_pmc.pmc47
                     AND gec011='1'  #進項
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3044'
        WHEN l_gecacti='N'        LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
 
FUNCTION i600_chk_pmc05()
   IF g_pmc.pmc05 IS NULL THEN
      CALL cl_err(g_pmc.pmc05,'mfg3284',0)
      RETURN FALSE
   END IF
   IF g_pmc_o.pmc05 != g_pmc.pmc05 THEN
      CALL i600_pmc05()
      IF NOT cl_null(g_errno) THEN
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i600_chk_pmc14()
   DEFINE l_flag LIKE type_file.chr1
   CALL s_field_chk(g_pmc.pmc14,'5',g_plant,'pmc14') RETURNING l_flag
   IF l_flag = '0' THEN
      CALL cl_err(g_pmc.pmc14,'aoo-043',1)
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i600_chk_pmc30()
   #MOD-530432(加包CASE)
   CASE g_pmc.pmc30
      WHEN '1'
           IF g_pmc.pmc04 = g_pmc.pmc01 THEN
               LET g_pmc.pmc04=NULL        #付款廠商編號
           END IF
           LET g_pmc.pmc901=g_pmc.pmc01#出貨廠商
      WHEN '2'
           LET g_pmc.pmc04=g_pmc.pmc01 #付款廠商編號
           IF g_pmc.pmc901 = g_pmc.pmc01 THEN
               LET g_pmc.pmc901=NULL       #出貨廠商
           END IF
      WHEN '3'
           LET g_pmc.pmc04=g_pmc.pmc01 #付款廠商編號
           LET g_pmc.pmc901=g_pmc.pmc01#出貨廠商
   END CASE
   RETURN TRUE
END FUNCTION
 
FUNCTION i600_chk_pmc04()
    IF NOT cl_null(g_pmc.pmc04) THEN #MOD-530432 MARK
      IF g_pmc.pmc04 = g_pmc.pmc901 THEN
         CALL cl_err(g_pmc.pmc04,'apm-033',0) #付款廠商和出貨廠商不可相同
         RETURN FALSE
      END IF
      CALL i600_pmc04('a')
      IF NOT cl_null(g_errno) THEN
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i600_chk_pmc901()
   IF NOT cl_null(g_pmc.pmc901) THEN
      IF g_pmc.pmc04 = g_pmc.pmc901 THEN
         CALL cl_err(g_pmc.pmc901,'apm-033',0) #付款廠商和出貨廠商不可相同
         RETURN FALSE
      END IF
      CALL i600_pmc901('a')
      IF NOT cl_null(g_errno) THEN
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i600_chk_pmc24()
   DEFINE x1 LIKE pmc_file.pmc01
   DEFINE l_pmc24 STRING
 
   IF NOT cl_null(g_pmc.pmc24) THEN
      IF g_pmc_t.pmc24 IS NULL OR g_pmc_t.pmc24 <> g_pmc.pmc24 THEN
         LET x1=NULL
         SELECT MAX(pmc01) INTO x1 FROM pmc_file
                WHERE pmc24=g_pmc.pmc24 AND pmc01<>g_pmc.pmc01
         CASE WHEN x1 IS NOT NULL
              CALL cl_err('','apm-600',1)
                   RETURN FALSE
              WHEN SQLCA.SQLCODE=100
              WHEN SQLCA.SQLCODE=0
              OTHERWISE
                   CALL cl_err('sel pmc24:',SQLCA.SQLCODE,0)
                   RETURN FALSE
         END CASE
      END IF
      IF g_pmc.pmc01!='EMPL' AND g_pmc.pmc01!='MISC' THEN
         IF g_aza.aza21 = 'Y' AND g_aza.aza26='0' THEN
              LET l_pmc24= g_pmc.pmc24 CLIPPED
            IF NOT s_chkban(g_pmc.pmc24) OR NOT cl_numchk(g_pmc.pmc24,8)
               OR l_pmc24.getLength() > 8 THEN
               CALL cl_err(g_pmc.pmc24,'aoo-080',0)
               RETURN FALSE
            END IF
         END IF
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i600_chk_pmc091()
   IF cl_null(g_pmc.pmc52) THEN LET g_pmc.pmc52 = g_pmc.pmc091 END IF
   IF cl_null(g_pmc.pmc53) THEN LET g_pmc.pmc53 = g_pmc.pmc091 END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i600_chk_pmc22()
   IF NOT cl_null(g_pmc.pmc22) THEN
     IF cl_null(g_pmc_o.pmc22) OR cl_null(g_pmc_t.pmc22)
        OR  (g_pmc.pmc22 != g_pmc_o.pmc22 OR g_pmc.pmc22 = ' ' ) THEN
        CALL i600_pmc22(g_pmc.pmc22)
        IF NOT cl_null(g_errno) THEN
           RETURN FALSE
        END IF
     END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i600_chk_pmc47()
   IF NOT cl_null(g_pmc.pmc47) THEN
     IF cl_null(g_pmc_o.pmc47) OR cl_null(g_pmc_t.pmc47)
        OR  (g_pmc.pmc47 != g_pmc_o.pmc47 OR g_pmc.pmc47 = ' ' ) THEN
        CALL i600_pmc47('d')
        IF NOT cl_null(g_errno) THEN
           RETURN FALSE
        END IF
     END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i600_chk_pmc54()
   IF NOT cl_null(g_pmc.pmc54) THEN
      SELECT ofs01 FROM ofs_file WHERE ofs01=g_pmc.pmc54
      IF STATUS THEN
         CALL cl_err3("sel","ofs_file",g_pmc.pmc54,"","axm-461","","",1)
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i600_chk_pmc02()
   IF NOT cl_null(g_pmc.pmc02) THEN
      CALL i600_pmc02('a')
      IF NOT cl_null(g_errno) THEN
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i600_chk_pmc50()
   IF NOT cl_null(g_pmc.pmc50) THEN
      IF g_pmc.pmc50>31 THEN
         CALL cl_err(g_pmc.pmc50,'apm-886',0)
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i600_chk_pmc51()
   IF NOT cl_null(g_pmc.pmc51) THEN
      IF g_pmc.pmc51>31 THEN
         CALL cl_err(g_pmc.pmc51,'apm-886',0)
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i600_chk_pmc15()
   IF NOT cl_null(g_pmc.pmc15) THEN
      CALL i600_area(g_pmc.pmc15,'0')
      IF NOT cl_null(g_errno) THEN
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i600_chk_pmc16()
   IF NOT cl_null(g_pmc.pmc16) THEN
      CALL i600_area(g_pmc.pmc16,'1')
      IF NOT cl_null(g_errno) THEN
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i600_chk_pmc49()
   DEFINE l_pnz02 LIKE pnz_file.pnz02 #FUN-930113 
 
   IF NOT cl_null(g_pmc.pmc49) THEN
      SELECT pnz02 INTO l_pnz02 FROM pnz_file WHERE pnz01=g_pmc.pmc49 #FUN-930113 oah-->pnz
      IF STATUS THEN
         CALL cl_err3("sel","pnz_file",g_pmc.pmc49,"",STATUS,"sel pnz:","",1) #FUN-930113 oah-->pnz
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i600_chk_pmc27()
   IF cl_null(g_pmc.pmc28) OR g_pmc.pmc28<=0 AND g_pmc.pmc27='1' THEN #寄出
      LET g_pmc.pmc28=0
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i600_chk_pmc55()
   IF NOT cl_null(g_pmc.pmc55) THEN
      SELECT nmt01 FROM nmt_file WHERE nmt01 = g_pmc.pmc55
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","nmt_file",g_pmc.pmc55,"","apm-227","","",1)
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i600_chk_pmc17()
   IF NOT cl_null(g_pmc.pmc17) THEN
      CALL i600_pmc17(g_pmc.pmc17)
      IF NOT cl_null(g_errno) THEN
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i600_chk_pmc28()
   IF NOT cl_null(g_pmc.pmc28) THEN
      IF g_pmc.pmc28 < 0 THEN
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i600_pmc05()
   DEFINE l_str1   LIKE type_file.chr1000,
          l_ans    LIKE type_file.chr1
 
   # 如從已核準更改成未核準或核準中時 pmh_file 一併修改
   IF g_pmc_o.pmc05 ='0' AND (g_pmc.pmc05 = '1' OR g_pmc.pmc05 ='2' ) THEN
      UPDATE pmh_file SET pmh05 = g_pmc.pmc05,
                          pmhdate = g_today     #FUN-C40009 add
       WHERE pmh02 = g_pmc.pmc01
         AND pmh13 = g_pmc.pmc22
      IF SQLCA.sqlcode THEN
         IF SQLCA.sqlcode != 100 THEN
            CALL cl_err3("upd","pmh_file","","",SQLCA.sqlcode,"Update pmh_file:","",1)
         END IF
      END IF
   END IF
   IF (g_pmc_o.pmc05 ='1' OR  g_pmc_o.pmc05 ='2') AND g_pmc.pmc05='0' THEN
      UPDATE pmh_file SET pmh05 = g_pmc.pmc05,
                          pmhdate = g_today     #FUN-C40009 add
       WHERE pmh02 = g_pmc.pmc01
         AND pmh13 = g_pmc.pmc22
      IF SQLCA.sqlcode THEN
         IF SQLCA.sqlcode != 100 THEN
            CALL cl_err3("upd","pmh_file","","",SQLCA.sqlcode,"Update pmh_file:","",1)  #No.FUN-660129
         END IF
      END IF
   END IF
END FUNCTION
 
FUNCTION i600_pmc04(p_cmd)        #付款廠商
   DEFINE   p_cmd       LIKE type_file.chr1,
            l_pmc03     LIKE pmc_file.pmc03,  #付款廠商簡稱
            l_pmc30     LIKE pmc_file.pmc30,  #性質
            l_pmcacti   LIKE pmc_file.pmcacti
 
   LET g_errno = ' '
   SELECT pmc03,pmc30,pmcacti INTO l_pmc03,l_pmc30,l_pmcacti
     FROM pmc_file
    WHERE pmc01 = g_pmc.pmc04
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3004'
        WHEN l_pmc30  ='1' LET g_errno = 'mfg3004'
        WHEN l_pmcacti='N'             LET g_errno = '9028'
        WHEN l_pmcacti MATCHES '[PH]'  LET g_errno = '9038'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
 
FUNCTION i600_pmc02(p_cmd)        #廠商分類代碼
   DEFINE   p_cmd LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
            l_pmyacti   LIKE pmy_file.pmyacti,
            l_pmy02     LIKE pmy_file.pmy02
 
   LET g_errno = ' '
   SELECT pmy02,pmyacti INTO l_pmy02,l_pmyacti
     FROM pmy_file
    WHERE pmy01 = g_pmc.pmc02
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3005'
        WHEN l_pmyacti='N'        LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
 
FUNCTION i600_pmc901(p_cmd)
   DEFINE   l_pmcacti LIKE pmc_file.pmcacti
   DEFINE   l_pmc03   LIKE pmc_file.pmc03,
            p_cmd     LIKE type_file.chr1
 
    LET g_errno = " "
    IF g_pmc.pmc901 = g_pmc.pmc01 AND NOT cl_null(g_pmc.pmc901) THEN
       LET l_pmc03 = g_pmc.pmc03
    ELSE
        SELECT pmc03,pmcacti INTO l_pmc03,l_pmcacti FROM pmc_file
        WHERE pmc01=g_pmc.pmc901
       CASE
         WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-000'
         WHEN l_pmcacti='N'             LET g_errno = '9028'
         WHEN l_pmcacti MATCHES '[PH]'  LET g_errno = '9038'
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE
    END IF
END FUNCTION
 
FUNCTION i600_a_inschk()
   IF g_pmc.pmc05 NOT MATCHES '[012]' THEN
      RETURN FALSE
   END IF
   IF g_pmc.pmc30 NOT MATCHES '[123]' THEN
      RETURN FALSE
   END IF
   #IF cl_null(g_pmc.pmc17) AND g_pmc.pmc05 ='0' THEN  #VAT 特性
   #   LET g_errno='mfg3099'
   #   RETURN FALSE
   #END IF
   RETURN TRUE
END FUNCTION
