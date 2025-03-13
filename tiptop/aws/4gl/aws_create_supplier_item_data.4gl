# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_create_supplier_item_data.4gl
# Descriptions...: 提供建立 料件供應商 資料的服務
# Date & Author..: 2010/07/29 By Lilan   #FUN-A70142
# Memo...........:
# Modify.........: No:FUN-AB0035 10/11/09 By Lilan
#                1.PLM傳入欄位的資料檢查 - 依據apmi254內的AFTER FIELD的檢核方式檢查來源資料正確性
#                2.若有錯誤,錯誤訊息內加上錯誤的Key值
# Modify.........: No.FUN-B30104 11/03/29 By Mandy pmh07沒有做檢核
# Modify.........: No.FUN-A70142 11/06/20 By Abby  GP5.1追版至GP5.25
# Modify.........: No.FUN-D10092 13/01/20 By Abby 修改時pmh12有修改… 含稅單價pmh19沒有同步調整
#}

DATABASE ds

#FUN-A70142

GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv2_global.4gl"         #TIPTOP Service Gateway 使用的全域變數檔

DEFINE g_pmh01    LIKE pmh_file.pmh01,         #KEY值
       g_pmh02    LIKE pmh_file.pmh02,         #KEY值
       g_pmh13    LIKE pmh_file.pmh13,         #KEY值
       g_pmh21    LIKE pmh_file.pmh21,         #KEY值
       g_pmh22    LIKE pmh_file.pmh22,         #KEY值
       g_pmh23    LIKE pmh_file.pmh23,         #KEY值
       g_pmh09    LIKE pmh_file.pmh09,
       g_pmh15    LIKE pmh_file.pmh15,
       g_pmh16    LIKE pmh_file.pmh16,
       g_pmh17    LIKE pmh_file.pmh17,
       g_pmh18    LIKE pmh_file.pmh18
DEFINE g_pmh      RECORD LIKE pmh_file.*       
DEFINE g_msg      STRING                       #FUN-AB0035 add

#[
# Description....: 提供建立 BOM 資料的服務(入口 function)
# Date & Author..: 2010/07/29 by Lilan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_supplier_item_data()
 
    
    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 新增 料件供應商 資料                                                           #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_create_supplier_item_data_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION


#[
# Description....: 依據傳入資訊新增 ERP  BOM 資料
# Date & Author..: 2010/07/29 by Lilan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_supplier_item_data_process()
    DEFINE l_i        LIKE type_file.num10,
           l_j        LIKE type_file.num10
    DEFINE l_sql      STRING        
    DEFINE l_wc       STRING        
    DEFINE l_cnt      LIKE type_file.num10,
           l_cnt1     LIKE type_file.num10,
           l_cnt2     LIKE type_file.num10
    DEFINE l_node     om.DomNode
    DEFINE l_flag     LIKE type_file.num10
    DEFINE l_pmc22    LIKE pmc_file.pmc22        #供應商慣用幣別    

    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的 料件供應商 資料                                  #
    #--------------------------------------------------------------------------#
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("pmh_file")   #取得共有幾筆單檔資料 **
    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       RETURN
    END IF
    
    LET l_sql = "SELECT * FROM pmh_file",
                " WHERE pmh01 = ? ",
                "   AND pmh02 = ? ",
                "   AND pmh13 = ? ",
                "   AND pmh21 = ? ",
                "   AND pmh22 = ? ",
                "   AND pmh23 = ? ",
                " FOR UPDATE "                        #FUN-A70142 mod NOWAIT
    LET l_sql = cl_forupd_sql(l_sql)                  #FUN-A70142 add
    DECLARE i254_cl CURSOR FROM l_sql                 


    BEGIN WORK

    FOR l_i = 1 TO l_cnt1    
        INITIALIZE g_pmh.* TO NULL   
        LET l_node = aws_ttsrv_getMasterRecord(l_i, "pmh_file")        #目前處理單檔的 XML 節點
        
        LET g_pmh01 = aws_ttsrv_getRecordField(l_node, "pmh01")        #取得此筆單檔資料的欄位值
        LET g_pmh02 = aws_ttsrv_getRecordField(l_node, "pmh02")
        LET g_pmh13 = aws_ttsrv_getRecordField(l_node, "pmh13")
        LET g_pmh21 = aws_ttsrv_getRecordField(l_node, "pmh21")
        LET g_pmh22 = aws_ttsrv_getRecordField(l_node, "pmh22")
        LET g_pmh23 = aws_ttsrv_getRecordField(l_node, "pmh23")

        IF cl_null(g_pmh13) THEN
           SELECT pmc22 INTO l_pmc22 
             FROM pmc_file
            WHERE pmc01 = g_pmh02   
           LET g_pmh13 = l_pmc22      
        END IF
        IF cl_null(g_pmh21) THEN LET g_pmh21 = ' ' END IF        # KEY 不可空白
        IF cl_null(g_pmh22) THEN LET g_pmh22 = '1' END IF        # KEY 不可空白
        IF cl_null(g_pmh23) THEN LET g_pmh23 = ' ' END IF        # KEY 不可空白
        
        #----------------------------------------------------------------------#
        # 判斷此資料是否已經建立, 若已建立則為 Update                          #
        #----------------------------------------------------------------------#
        SELECT COUNT(*) INTO l_cnt FROM pmh_file 
         WHERE pmh01 = g_pmh01 
	   AND pmh02 = g_pmh02
           AND pmh13 = g_pmh13
           AND pmh21 = g_pmh21
           AND pmh22 = g_pmh22
           AND pmh23 = g_pmh23

        IF NOT aws_create_supplier_item_data_default(l_node,l_cnt) THEN   #檢查欄位預設值           
           EXIT FOR
        END IF

        IF l_cnt = 0 THEN
           #-------------------------------------------------------------------#
           # RECORD資料傳到NODE                                                #
           #-------------------------------------------------------------------#

           #新增時,空白欄位給予預設值
           CALL aws_create_supplier_item_data_insdef(l_node)

           CALL aws_ttsrv_setRecordField_record(l_node,base.Typeinfo.create(g_pmh))


           IF cl_null(g_pmh.pmh21) THEN        # KEY 不可空白
              LET g_pmh.pmh21 = ' '
              CALL aws_ttsrv_setRecordField(l_node, "pmh21", ' ')
           END IF

           IF cl_null(g_pmh.pmh22) THEN        # KEY 不可空白
              LET g_pmh.pmh22 = '1'
              CALL aws_ttsrv_setRecordField(l_node, "pmh22", '1')
           END IF

           IF cl_null(g_pmh.pmh23) THEN        # KEY 不可空白
              LET g_pmh.pmh23 = ' '
              CALL aws_ttsrv_setRecordField(l_node, "pmh23", ' ')
           END IF

           LET l_sql = aws_ttsrv_getRecordSql(l_node, "pmh_file", "I", NULL)   #I 表示取得 INSERT SQL
        ELSE
          #修改資料時,沒有傳入值的欄位則以該欄位原值取代(沒有傳入值則該欄位不異動)
           CALL aws_create_supplier_item_data_updchk2(l_node)
           CALL aws_ttsrv_setRecordField_record(l_node,base.Typeinfo.create(g_pmh))
           CALL aws_ttsrv_setRecordField(l_node, "pmhmodu", g_user)
           CALL aws_ttsrv_setRecordField(l_node, "pmhdate", g_today)

           IF cl_null(g_pmh.pmh21) THEN        # KEY 不可空白
              LET g_pmh.pmh21 = ' '
              CALL aws_ttsrv_setRecordField(l_node, "pmh21", ' ')
           END IF
 
           IF cl_null(g_pmh.pmh22) THEN        # KEY 不可空白
              LET g_pmh.pmh22 = '1'
              CALL aws_ttsrv_setRecordField(l_node, "pmh22", '1')
           END IF
 
           IF cl_null(g_pmh.pmh23) THEN        # KEY 不可空白
              LET g_pmh.pmh23 = ' '
              CALL aws_ttsrv_setRecordField(l_node, "pmh23", ' ')
           END IF

          #FUN-A70142 add str------------------------
           IF cl_null(g_pmh.pmh25) THEN        # KEY 不可空白
              LET g_pmh.pmh25 = 'N'
              CALL aws_ttsrv_setRecordField(l_node, "pmh25", ' ')
           END IF
          #FUN-A70142 add end------------------------

           LET l_wc = " pmh01 = '", g_pmh01 CLIPPED, "' ",                  #UPDATE SQL 時的 WHERE condition
                      " AND pmh02 = '", g_pmh02 CLIPPED,"' ",
                      " AND pmh13 = '", g_pmh13 CLIPPED,"' ",
                      " AND pmh21 = '", g_pmh21 ,"' ",
                      " AND pmh22 = '", g_pmh22 CLIPPED,"' ",
                      " AND pmh23 = '", g_pmh23 ,"' "
           LET l_sql = aws_ttsrv_getRecordSql(l_node, "pmh_file", "U", l_wc)   #U 表示取得 UPDATE SQL

           #-------------------------------------------------------------------#
           # 鎖住將被更改或取消的資料                                          #
           #-------------------------------------------------------------------#
           IF NOT aws_create_supplier_item_data_updchk() THEN
              EXIT FOR
           END IF

        END IF
    
        #----------------------------------------------------------------------#
        # 執行單頭 INSERT / UPDATE SQL                                         #
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
      #FUN-AB0035 add str --------
       LET g_status.description = cl_getmsg(g_status.code, g_lang)   #取得error code
       LET g_msg = cl_mut_get_feldname('pmh01',g_pmh.pmh01,'pmh02',g_pmh.pmh02,
                                       'pmh13',g_pmh.pmh13,'pmh21',g_pmh.pmh21,
                                       'pmh22',g_pmh.pmh22,'pmh23',g_pmh.pmh23)
       LET g_status.description = g_msg CLIPPED,"==>",g_status.description
      #FUN-AB0035 add end --------
       ROLLBACK WORK
    END IF
    
END FUNCTION

#[
# Description....: 鎖住將被更改或取消的資料
# Date & Author..: 2010/07/29 by Lilan
# Parameter......: none
# Return.........: l_status - INTEGER - TRUE / FALSE Luck 結果
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_supplier_item_data_updchk()
DEFINE l_pmh   RECORD LIKE pmh_file.*       #主供應商料件

  OPEN i254_cl USING g_pmh01,g_pmh02,g_pmh13,g_pmh21,g_pmh22,g_pmh23
  IF STATUS THEN
     LET g_status.code = STATUS
     CLOSE i254_cl
     RETURN FALSE
  END IF
  FETCH i254_cl INTO l_pmh.*                # 鎖住將被更改或取消的資料
  IF SQLCA.sqlcode THEN
     LET g_status.code = SQLCA.SQLCODE      # 資料被他人LOCK
     LET g_status.sqlcode = SQLCA.SQLCODE
     CLOSE i254_cl
     RETURN FALSE
  END IF
  RETURN TRUE
END FUNCTION


#[
# Description....: 設定欄位預設值
# Date & Author..: 2010/07/29 by Lilan
# Parameter......: p_node   - om.DomNode - 單頭 XML 節點 
#                : p_cnt    - INTEGER    - 資料是否已存在，0:新增
# Return.........: l_status - INTEGER    - TRUE / FALSE 預設值檢查結果
# Memo...........:
# Modify.........:
#]
FUNCTION aws_create_supplier_item_data_default(p_node,p_cnt)
    DEFINE l_cnt       LIKE type_file.num5 #FUN-B30104 add
    DEFINE p_node      om.DomNode,
           p_cnt       LIKE type_file.num10
    DEFINE l_flag      LIKE type_file.chr1
    DEFINE l_imaacti   LIKE ima_file.imaacti
    DEFINE l_ima100    LIKE ima_file.ima100
    DEFINE l_ima101    LIKE ima_file.ima101
    DEFINE l_ima102    LIKE ima_file.ima102
    DEFINE l_pmhacti   LIKE pmh_file.pmhacti
    DEFINE l_pmc03     LIKE pmc_file.pmc03    #FUN-AB0035 add
    DEFINE l_azi02     LIKE azi_file.azi02    #FUN-AB0035 add

    LET g_pmh.pmh01 = g_pmh01
    LET g_pmh.pmh02 = g_pmh02
    LET g_pmh.pmh13 = g_pmh13                 #FUN-AB0035 add

    IF cl_null(g_pmh.pmh01) THEN
       LET g_status.code = "aic-104"          #料件編號為 NULL
       RETURN FALSE
    END IF

    IF cl_null(g_pmh.pmh02) THEN
       LET g_status.code = "apm-197"          #供應商編號為 NULL
       RETURN FALSE
    END IF

    SELECT imaacti,ima100,ima101,ima102 
      INTO l_imaacti,l_ima100,l_ima101,l_ima102 
      FROM ima_file 
     WHERE ima01 = g_pmh.pmh01
    CASE 
       WHEN SQLCA.SQLCODE = 100  
          LET g_status.code = 'mfg0002'       #無此料號
          RETURN FALSE
       WHEN l_imaacti='N' 
          LET g_status.code = '9028'          #此筆資料已無效, 不可使用
          RETURN FALSE
       WHEN l_imaacti  MATCHES '[PH]'
          LET g_status.code = '9038'          #此筆資料的狀況碼非"確認",不可使用!
          RETURN FALSE
    END CASE

   #FUN-AB0035 add str -------------
    SELECT pmc03 INTO l_pmc03
      FROM pmc_file
     WHERE pmc01 = g_pmh.pmh02
    IF SQLCA.sqlcode THEN
       LET g_status.code = 'aic-050'          #無此供應商!
       RETURN FALSE
    END IF

    IF NOT cl_null(g_pmh.pmh13) THEN
      SELECT azi02 INTO l_azi02
        FROM azi_file
       WHERE azi01 = g_pmh.pmh13 
      IF SQLCA.sqlcode THEN
         LET g_status.code = 'anm-007'        #無此幣別
         RETURN FALSE
      END IF
    END IF
   #FUN-AB0035 add end -------------

    LET g_pmh.pmh03 = aws_ttsrv_getRecordField(p_node,"pmh03")
    LET g_pmh.pmh04 = aws_ttsrv_getRecordField(p_node,"pmh04")
    LET g_pmh.pmh05 = aws_ttsrv_getRecordField(p_node,"pmh05")
    LET g_pmh.pmh06 = aws_ttsrv_getRecordField(p_node,"pmh06")
    LET g_pmh.pmh07 = aws_ttsrv_getRecordField(p_node,"pmh07")
    LET g_pmh.pmh08 = aws_ttsrv_getRecordField(p_node,"pmh08")
    LET g_pmh.pmh09 = aws_ttsrv_getRecordField(p_node,"pmh09")
    LET g_pmh.pmh10 = aws_ttsrv_getRecordField(p_node,"pmh10")
    LET g_pmh.pmh11 = aws_ttsrv_getRecordField(p_node,"pmh11")
    LET g_pmh.pmh12 = aws_ttsrv_getRecordField(p_node,"pmh12")
    LET g_pmh.pmh14 = aws_ttsrv_getRecordField(p_node,"pmh14")
    LET g_pmh.pmh15 = aws_ttsrv_getRecordField(p_node,"pmh15")
    LET g_pmh.pmh16 = aws_ttsrv_getRecordField(p_node,"pmh16")
    LET g_pmh.pmh17 = aws_ttsrv_getRecordField(p_node,"pmh17")
    LET g_pmh.pmh18 = aws_ttsrv_getRecordField(p_node,"pmh18")
    LET g_pmh.pmh19 = aws_ttsrv_getRecordField(p_node,"pmh19")
    LET g_pmh.pmh20 = aws_ttsrv_getRecordField(p_node,"pmh20")
    LET g_pmh.pmhgrup = aws_ttsrv_getRecordField(p_node,"pmhgrup")
    LET g_pmh.pmhacti = aws_ttsrv_getRecordField(p_node,"pmhacti")    #資料有效否

    LET g_pmh09 = l_ima100                                            #檢驗程度
    LET g_pmh15 = l_ima101                                            #檢驗水準
    LET g_pmh16 = l_ima102                                            #級數
    #FUN-B30104---add----str---
    IF NOT cl_null(g_pmh.pmh07) THEN
        SELECT COUNT(*) INTO l_cnt
          FROM mse_file
         WHERE mse01=g_pmh.pmh07
        IF l_cnt = 0 THEN
           LET g_status.code = "mfg2603"
           RETURN FALSE
        END IF
    END IF
    #FUN-B30104---add----end---

    #--------------------------------------------------------------------------#
    # 若 p_cnt > 0 ,則表示此資料已建立，必須進行資料控管                       #
    #--------------------------------------------------------------------------#
    display "cnt:",p_cnt
    IF p_cnt = 0 THEN
      IF g_pmh.pmhacti = 'N' THEN
         LET g_status.code = "mfg1000"       #傳入(來源)資料為無效資料, 不可更改
         RETURN FALSE
      END IF
    ELSE
       SELECT pmhacti INTO l_pmhacti 
         FROM pmh_file
        WHERE pmh01 = g_pmh01
          AND pmh02 = g_pmh02
          AND pmh13 = g_pmh13
          AND pmh21 = g_pmh21
          AND pmh22 = g_pmh22
          AND pmh23 = g_pmh23
       IF l_pmhacti = 'N' THEN
          LET g_status.code = "mfg1000"      #ERP資料為無效資料, 不可更改
          RETURN FALSE
       END IF
    END IF 

    RETURN TRUE
END FUNCTION


#[
# Description....: 設定新增時欄位預設值(新增資料時,若傳入欄位值為NULL則給予預設值)
# Date & Author..: 2010/07/29 by Lilan
# Parameter......: p_node   - om.DomNode - 單頭 XML 節點
# Memo...........:
# Modify.........:
#]
FUNCTION aws_create_supplier_item_data_insdef(p_node)
   DEFINE p_node      om.DomNode
   DEFINE l_ima24     LIKE ima_file.ima24   #FUN-AB0035 add


   IF cl_null(g_pmh.pmh13) THEN        #KEY 不可空白
      LET g_pmh.pmh13 = g_pmh13
   END IF

   IF cl_null(g_pmh.pmh05) THEN        
      LET g_pmh.pmh05 = '0'
   END IF

   IF cl_null(g_pmh.pmh06) THEN
      LET g_pmh.pmh06 = g_today
   END IF

   IF cl_null(g_pmh.pmh08) THEN
     #LET g_pmh.pmh08 = "N"                  #FUN-AB0035 mark
     #FUN-AB0035 add str ------
      SELECT ima24
        INTO l_ima24
        FROM ima_file
       WHERE ima01 = g_pmh.pmh01

      LET g_pmh.pmh08 = l_ima24
     #FUN-AB0035 add end ------
   END IF

   IF cl_null(g_pmh.pmh09) THEN
      LET g_pmh.pmh09 = g_pmh09
   END IF

   IF cl_null(g_pmh.pmh11) THEN
      LET g_pmh.pmh11 = '0'
   END IF
 
   IF cl_null(g_pmh.pmh12) THEN
      LET g_pmh.pmh12 = '0'
   END IF
 
  #匯率(pmh14)
   IF cl_null(g_pmh.pmh14) OR g_pmh.pmh14=0 THEN
      IF g_aza.aza17 = g_pmh.pmh13 THEN   #本幣
         LET g_pmh.pmh14 = 1
      ELSE
         CALL s_curr3(g_pmh.pmh13,g_today,g_sma.sma904)
           RETURNING g_pmh.pmh14
      END IF
   END IF

   IF cl_null(g_pmh.pmh15) THEN
      LET g_pmh.pmh15 = g_pmh15
   END IF
 
   IF cl_null(g_pmh.pmh16) THEN
      LET g_pmh.pmh16 = g_pmh16
   END IF
 
  #最近採購稅別(pmh17),稅率(pmh18)
   IF cl_null(g_pmh.pmh17) THEN
      SELECT pmc47,gec04
        INTO g_pmh17,g_pmh18
        FROM pmc_file,gec_file
       WHERE pmc01 = g_pmh.pmh02
         AND gec011 = '1'
         AND gec01 = pmc47

      LET g_pmh.pmh17 = g_pmh17
      LET g_pmh.pmh18 = g_pmh18
   END IF

   IF cl_null(g_pmh.pmh19) THEN 
      LET g_pmh.pmh19 = '0'
   END IF

  #FUN-AB0035 add str ---------
  #若pmh12不為0且pmh19為0時,要依稅率(pmh18)自動算出pmh19
   IF g_pmh.pmh19 = '0' AND g_pmh.pmh12 <> '0' THEN
      LET g_pmh.pmh19 = g_pmh.pmh12 * (1 + g_pmh.pmh18/100) 
   END IF 
  #FUN-AB0035 add end ---------

  #FUN-A70142 add str ---------
   IF cl_null(g_pmh.pmh25) THEN
      LET g_pmh.pmh25 = 'N'
   END IF

   LET g_pmh.pmhoriu = g_user
   LET g_pmh.pmhorig = g_grup
  #FUN-A70142 add end ---------

   IF cl_null(g_pmh.pmhacti) THEN
      LET g_pmh.pmhacti = 'Y'
   END IF
 
   IF cl_null(g_pmh.pmhuser) THEN
      LET g_pmh.pmhuser = g_user
   END IF
 
   IF cl_null(g_pmh.pmhgrup) THEN
      LET g_pmh.pmhgrup = g_grup
   END IF
 
   IF cl_null(g_pmh.pmhmodu) THEN
      LET g_pmh.pmhmodu = g_user
   END IF
 
   IF cl_null(g_pmh.pmhdate) THEN
      LET g_pmh.pmhdate = g_today 
   END IF

END FUNCTION


#[
# Description....: 異動資料時,若傳入為NULL則保留ERP欄位內原值
# Date & Author..: 2010/07/29 by Lilan
# Parameter......: p_node   - om.DomNode - 單頭 XML 節點
# Memo...........:
# Modify.........:
#]
FUNCTION aws_create_supplier_item_data_updchk2(p_node)
   DEFINE p_node     om.DomNode
   DEFINE l_pmh      RECORD LIKE pmh_file.*   


   SELECT * INTO l_pmh.*
     FROM pmh_file
    WHERE pmh01 = g_pmh01        
      AND pmh02 = g_pmh02
      AND pmh13 = g_pmh13
      AND pmh21 = g_pmh21
      AND pmh22 = g_pmh22
      AND pmh23 = g_pmh23

   IF cl_null(g_pmh.pmh13) THEN
      LET g_pmh.pmh13 = l_pmh.pmh13
   END IF

   IF cl_null(g_pmh.pmh14) THEN
      LET g_pmh.pmh14 = l_pmh.pmh14
   END IF

   IF cl_null(g_pmh.pmh05) THEN
      LET g_pmh.pmh05 = l_pmh.pmh05
   END IF

   IF cl_null(g_pmh.pmh06) THEN
      LET g_pmh.pmh06 = l_pmh.pmh06
   END IF
 
   IF cl_null(g_pmh.pmh08) THEN
      LET g_pmh.pmh08 = l_pmh.pmh08
   END IF
 
   IF cl_null(g_pmh.pmh09) THEN
      LET g_pmh.pmh09 = l_pmh.pmh09
   END IF
 
   IF cl_null(g_pmh.pmh11) THEN
      LET g_pmh.pmh11 = l_pmh.pmh11
   END IF
 
   IF cl_null(g_pmh.pmh12) THEN
      LET g_pmh.pmh12 = l_pmh.pmh12
   END IF
 
   IF cl_null(g_pmh.pmh15) THEN
      LET g_pmh.pmh15 = l_pmh.pmh15
   END IF
 
   IF cl_null(g_pmh.pmh16) THEN
      LET g_pmh.pmh16 = l_pmh.pmh16
   END IF

   IF cl_null(g_pmh.pmh17) THEN
      LET g_pmh.pmh17 = l_pmh.pmh17
   END IF

   IF cl_null(g_pmh.pmh18) THEN
      LET g_pmh.pmh18 = l_pmh.pmh18
   END IF
 
   IF cl_null(g_pmh.pmhacti) THEN
      LET g_pmh.pmhacti = l_pmh.pmhacti
   END IF

   IF cl_null(g_pmh.pmhuser) THEN
      LET g_pmh.pmhuser = l_pmh.pmhuser
   END IF

   IF cl_null(g_pmh.pmhgrup) THEN
      LET g_pmh.pmhgrup = l_pmh.pmhgrup
   END IF

   IF cl_null(g_pmh.pmhmodu) THEN
      LET g_pmh.pmhmodu = l_pmh.pmhmodu
   END IF

   IF cl_null(g_pmh.pmhdate) THEN
      LET g_pmh.pmhdate = l_pmh.pmhdate
   END IF

   IF cl_null(g_pmh.pmh19) THEN
       #FUN-D10092 add str ---------
       #若pmh12不為0且pmh19為0時,要依稅率(pmh18)自動算出pmh19
        LET g_pmh.pmh19 = g_pmh.pmh12 * (1 + g_pmh.pmh18/100) 
       #FUN-D10092 add end ---------
       #LET g_pmh.pmh19 = l_pmh.pmh19 #FUN-D10092 mark
   END IF





END FUNCTION

