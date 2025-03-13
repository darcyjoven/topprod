# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_create_item_approval_data.4gl
# Descriptions...: 提供建立 料件承認 資料的服務
# Date & Author..: 2010/08/25 By Lilan   #FUN-A80131
# Memo...........:
# Modify.........: No:FUN-AB0022 10/11/09 By lilan 
#                1.PLM傳入欄位的資料檢查 - 依據abmi310內的AFTER FIELD的檢核方式檢查來源資料正確性
#                2.若有錯誤,錯誤訊息內加上錯誤的Key值
# Modify.........: No.FUN-B30104 11/03/29 By Mandy (1)送樣人(bmj07)控管有誤,導致無法建立料件承認資料
#                                                  (2)當asms250的sma102='N'時,資料還是同步寫入了apmi254
# Modify.........: No.FUN-C40009 13/01/10 By Nina 只要程式有UPDATE pmh_file 的任何一個欄位時,多加pmhdate=g_today
# Modify.........: No:FUN-D20002 13/02/01 By Mandy GP5.3 PLM追版 for bmj_file差異欄位補強
# Modify.........: No:FUN-D20004 13/02/01 By Mandy 資料修改出現-6319
#}

DATABASE ds

#FUN-A80131

GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv2_global.4gl"         #TIPTOP Service Gateway 使用的全域變數檔

DEFINE g_bmj01    LIKE bmj_file.bmj01,         #KEY值
       g_bmj02    LIKE bmj_file.bmj02,         #KEY值
       g_bmj03    LIKE bmj_file.bmj03          #KEY值
DEFINE g_bmj      RECORD LIKE bmj_file.*       
DEFINE g_msg      STRING                       #FUN-AB0022 add
DEFINE g_forupd_sql      STRING                #FUN-A80131 add

#[
# Description....: 提供建立料件承認資料的服務(入口 function)
# Date & Author..: 2010/08/25 by Lilan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_item_approval_data()
    
    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 新增 料件供應商 資料                                                           #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_create_item_approval_data_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION


#[
# Description....: 依據傳入資訊新增 ERP 料件承認 資料
# Date & Author..: 2010/08/25 by Lilan
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_item_approval_data_process()
    DEFINE l_i        LIKE type_file.num10,
           l_j        LIKE type_file.num10
    DEFINE l_sql      STRING        
    DEFINE l_wc       STRING        
    DEFINE l_cnt      LIKE type_file.num10,
           l_cnt1     LIKE type_file.num10,
           l_cnt2     LIKE type_file.num10
    DEFINE l_node     om.DomNode
    DEFINE l_flag     LIKE type_file.num10

    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的 料件承認 資料                                    #
    #--------------------------------------------------------------------------#
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("bmj_file")   #取得共有幾筆單檔資料 **
    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       RETURN
    END IF
    
    LET l_sql = "SELECT * FROM bmj_file",
                " WHERE bmj01 = ? ",
                "   AND bmj02 = ? ",
                "   AND bmj03 = ? ",
                " FOR UPDATE "                      #FUN-A80131 mod NOWAIT
   #LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)  #FUN-A80131 add #FUN-D20004 mark
    LET g_forupd_sql = cl_forupd_sql(l_sql)                         #FUN-D20004 add
    DECLARE i310_cl CURSOR FROM g_forupd_sql               #FUN-A80131 mod g_forupd_sql

    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0' #FUN-B30104 add


    BEGIN WORK

    FOR l_i = 1 TO l_cnt1    
        INITIALIZE g_bmj.* TO NULL   

        LET l_node = aws_ttsrv_getMasterRecord(l_i, "bmj_file")    #目前處理單檔的 XML 節點
        LET g_bmj01 = aws_ttsrv_getRecordField(l_node, "bmj01")    #取得此筆單檔資料的欄位值
        LET g_bmj02 = aws_ttsrv_getRecordField(l_node, "bmj02")    #取得此筆單檔資料的欄位值
        LET g_bmj03 = aws_ttsrv_getRecordField(l_node, "bmj03")    #取得此筆單檔資料的欄位值

        
        #----------------------------------------------------------------------#
        # 判斷此資料是否已經建立, 若已建立則為 Update                          #
        #----------------------------------------------------------------------#
        SELECT COUNT(*) INTO l_cnt FROM bmj_file 
         WHERE bmj01 = g_bmj01 
	   AND bmj02 = g_bmj02
           AND bmj03 = g_bmj03

        IF NOT aws_create_item_approval_data_default(l_node,l_cnt) THEN   #檢查欄位預設值       
           EXIT FOR
        END IF

        IF l_cnt = 0 THEN
           #-------------------------------------------------------------------#
           # RECORD資料傳到NODE                                                #
           #-------------------------------------------------------------------#
           CALL aws_create_item_approval_data_insdef() #新增時,空白欄位給予預設值

           CALL aws_ttsrv_setRecordField_record(l_node,base.Typeinfo.create(g_bmj))

           LET l_sql = aws_ttsrv_getRecordSql(l_node, "bmj_file", "I", NULL)   #I 表示取得 INSERT SQL
        ELSE
          #修改資料時,沒有傳入值的欄位則以該欄位原值取代(沒有傳入值則該欄位不異動)
           CALL aws_create_item_approval_data_updchk2(l_node)
           CALL aws_ttsrv_setRecordField_record(l_node,base.Typeinfo.create(g_bmj))
           CALL aws_ttsrv_setRecordField(l_node, "bmjmodu", g_user)
           CALL aws_ttsrv_setRecordField(l_node, "bmjdate", g_today)

          #UPDATE SQL 時的 WHERE condition
           LET l_wc = "     bmj01 = '", g_bmj01 CLIPPED,"' ",                 
                      " AND bmj02 = '", g_bmj02 CLIPPED,"' ",
                      " AND bmj03 = '", g_bmj03 CLIPPED,"' "
           LET l_sql = aws_ttsrv_getRecordSql(l_node, "bmj_file", "U", l_wc)   #U 表示取得 UPDATE SQL

           #-------------------------------------------------------------------#
           # 鎖住將被更改或取消的資料                                          #
           #-------------------------------------------------------------------#
           IF NOT aws_create_item_approval_data_updchk() THEN
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
        ELSE
           IF NOT aws_i310_ins_pmh() THEN
              EXIT FOR
           END IF
        END IF
    END FOR
    
    #全部處理都成功才 COMMIT WORK
    IF g_status.code = "0" THEN
       COMMIT WORK
    ELSE
      #FUN-AB0022 add str --------
       LET g_status.description = cl_getmsg(g_status.code, g_lang)   #取得error code
       LET g_msg = cl_mut_get_feldname('bmj01',g_bmj.bmj01,
                                       'bmj02',g_bmj.bmj02,
                                       'bmj03',g_bmj.bmj03,
                                       '','','','','','')
       LET g_status.description = g_msg CLIPPED,"==>",g_status.description
      #FUN-AB0022 add end --------
       ROLLBACK WORK
    END IF
    
END FUNCTION

#[
# Description....: 設定欄位預設值
# Date & Author..: 2010/08/25 by Lilan
# Parameter......: p_node   - om.DomNode - 單頭 XML 節點 
#                : p_cnt    - INTEGER    - 資料是否已存在，0:新增
# Return.........: l_status - INTEGER    - TRUE / FALSE 預設值檢查結果
# Memo...........:
# Modify.........:
#]
FUNCTION aws_create_item_approval_data_default(p_node,p_cnt)
    DEFINE p_node      om.DomNode,
           p_cnt       LIKE type_file.num10
    DEFINE l_flag      LIKE type_file.chr1
    DEFINE l_imaacti   LIKE ima_file.imaacti
    DEFINE l_ima100    LIKE ima_file.ima100
    DEFINE l_ima101    LIKE ima_file.ima101
    DEFINE l_ima102    LIKE ima_file.ima102
    DEFINE l_bmjacti   LIKE bmj_file.bmjacti
    DEFINE l_mse02     LIKE mse_file.mse02
    DEFINE l_pmc03     LIKE pmc_file.pmc03     #FUN-AB0022 add 
    DEFINE l_genacti   LIKE gen_file.genacti   #FUN-AB0022 add
    DEFINE l_gen02     LIKE gen_file.gen02     #FUN-AB0022 add

    LET g_bmj.bmj01 = g_bmj01
    LET g_bmj.bmj02 = g_bmj02
    LET g_bmj.bmj03 = g_bmj03
    
    IF cl_null(g_bmj.bmj01) THEN
       LET g_status.code = "aic-104"        #料件編號為 NULL
       RETURN FALSE
    END IF

    IF cl_null(g_bmj.bmj02) THEN
       LET g_status.code = "asf-597"        #製造商編號為 NULL
       RETURN FALSE
    END IF

    IF cl_null(g_bmj.bmj03) THEN
       LET g_status.code = "apm-197"        #供應商編號為 NULL
       RETURN FALSE
    END IF

    SELECT imaacti,ima100,ima101,ima102 
      INTO l_imaacti,l_ima100,l_ima101,l_ima102 
      FROM ima_file 
     WHERE ima01 = g_bmj.bmj01
    CASE 
       WHEN SQLCA.SQLCODE = 100  
          LET g_status.code = 'mfg2602'     #無此料號
          RETURN FALSE
       WHEN l_imaacti='N' 
          LET g_status.code = '9028'        #此筆資料已無效, 不可使用
          RETURN FALSE
       WHEN l_imaacti  MATCHES '[PH]'
          LET g_status.code = '9038'        #此筆資料的狀況碼非"確認",不可使用!
          RETURN FALSE
    END CASE

    SELECT mse02 INTO l_mse02 
      FROM mse_file
     WHERE mse01 = g_bmj.bmj02
    IF SQLCA.SQLCODE THEN
       LET g_status.code = 'aem-048'             #無此製造廠商!
       RETURN FALSE
    END IF

   #FUN-AB0022 add str -------------
    SELECT pmc03 INTO l_pmc03  
      FROM pmc_file
     WHERE pmc01 = g_bmj.bmj03
    IF SQLCA.sqlcode THEN
       LET g_status.code = 'aic-050'             #無此供應商!
       RETURN FALSE
    END IF
   #FUN-AB0022 add end -------------

    LET g_bmj.bmj04 = aws_ttsrv_getRecordField(p_node,"bmj04")
    LET g_bmj.bmj05 = aws_ttsrv_getRecordField(p_node,"bmj05")
    LET g_bmj.bmj06 = aws_ttsrv_getRecordField(p_node,"bmj06")
    LET g_bmj.bmj07 = aws_ttsrv_getRecordField(p_node,"bmj07")
    LET g_bmj.bmj08 = aws_ttsrv_getRecordField(p_node,"bmj08")
    LET g_bmj.bmj09 = aws_ttsrv_getRecordField(p_node,"bmj09")
    LET g_bmj.bmj10 = aws_ttsrv_getRecordField(p_node,"bmj10")
    LET g_bmj.bmj11 = aws_ttsrv_getRecordField(p_node,"bmj11")
    LET g_bmj.bmj12 = aws_ttsrv_getRecordField(p_node,"bmj12")
    LET g_bmj.bmj13 = aws_ttsrv_getRecordField(p_node,"bmj13")
    LET g_bmj.bmj14 = aws_ttsrv_getRecordField(p_node,"bmj14")
    LET g_bmj.bmj15 = aws_ttsrv_getRecordField(p_node,"bmj15")
    LET g_bmj.bmjgrup = aws_ttsrv_getRecordField(p_node,"bmjgrup")
    LET g_bmj.bmjacti = aws_ttsrv_getRecordField(p_node,"bmjacti")    #資料有效否
    LET g_bmj.bmjoriu = aws_ttsrv_getRecordField(p_node,"bmjoriu")    #FUN-D20002 add
    LET g_bmj.bmjorig = aws_ttsrv_getRecordField(p_node,"bmjorig")    #FUN-D20002 add

  #FUN-B30104--mark---str---
  ##FUN-AB0022 add str --------------
  # SELECT gen02,genacti 
  #   INTO l_gen02,l_genacti 
  #   FROM gen_file
  #  WHERE gen01 = g_bmj.bmj07
  # CASE WHEN SQLCA.SQLCODE = 100  
  #           LET g_bmj.bmj07 = g_user 
  #      WHEN l_genacti='N'        
  #           LET g_status.code = '9028'
  #           RETURN FALSE
  #      OTHERWISE                 
  #           LET g_status.code = SQLCA.SQLCODE USING '-------'
  #           RETURN FALSE
  # END CASE         
  ##FUN-AB0022 add end --------------
  #FUN-B30104--mark---end---
  #FUN-B30104--add----str---
   IF cl_null(g_bmj.bmj07) THEN
       LET g_bmj.bmj07 = g_user
   ELSE
       LET g_errno = ' '
       SELECT genacti INTO l_genacti    
         FROM gen_file
        WHERE gen01 = g_bmj.bmj07
       CASE
          WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg1312'
                                   LET l_genacti = NULL
          WHEN l_genacti = 'N'  LET g_errno = '9028'
          OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE
       IF NOT cl_null(g_errno) THEN
           LET g_errno = NULL
           LET g_bmj.bmj07 = g_user
       END IF
   END IF
  #FUN-B30104--add----end---


    #--------------------------------------------------------------------------#
    # 若 p_cnt > 0 ,則表示此資料已建立，必須進行資料控管                       #
    #--------------------------------------------------------------------------#
    display "cnt:",p_cnt
    IF p_cnt = 0 THEN
      IF g_bmj.bmjacti = 'N' THEN
         LET g_status.code = "mfg1000"       #傳入(來源)資料為無效資料, 不可更改
         RETURN FALSE
      END IF
    ELSE
       SELECT bmjacti INTO l_bmjacti 
         FROM bmj_file
        WHERE bmj01 = g_bmj01
          AND bmj02 = g_bmj02
          AND bmj03 = g_bmj03
       IF l_bmjacti = 'N' THEN
          LET g_status.code = "mfg1000"      #ERP資料為無效資料, 不可更改
          RETURN FALSE
       END IF
    END IF 

    RETURN TRUE
END FUNCTION


#[
# Description....: 設定新增時欄位預設值(新增資料時,若傳入欄位值為NULL則給予預設值)
# Date & Author..: 2010/08/25 by Lilan
# Parameter......: p_node   - om.DomNode - 單頭 XML 節點
# Memo...........:
# Modify.........:
#]
FUNCTION aws_create_item_approval_data_insdef()
   #FUN-D20002---add---str---
   IF cl_null(g_bmj.bmjoriu) THEN
      LET g_bmj.bmjoriu = g_user
   END IF

   IF cl_null(g_bmj.bmjorig) THEN
      LET g_bmj.bmjorig = g_grup
   END IF
   #FUN-D20002---add---end---

   IF cl_null(g_bmj.bmjacti) THEN
      LET g_bmj.bmjacti = 'Y'
   END IF

   IF cl_null(g_bmj.bmjuser) THEN
      LET g_bmj.bmjuser = g_user
   END IF

   IF cl_null(g_bmj.bmjgrup) THEN
      LET g_bmj.bmjgrup = g_grup
   END IF

   IF cl_null(g_bmj.bmjmodu) THEN
      LET g_bmj.bmjmodu = g_user
   END IF

   IF cl_null(g_bmj.bmjdate) THEN
      LET g_bmj.bmjdate = g_today
   END IF

   #承認狀態 = 3.已承認
   IF cl_null(g_bmj.bmj08) THEN
      LET g_bmj.bmj08 = '3'
   END IF

   #送樣日期
   IF cl_null(g_bmj.bmj06) THEN
      LET g_bmj.bmj06 = g_today
   END IF

  #廠商料號
   IF g_sma.sma102='Y' AND cl_null(g_bmj.bmj04) THEN 
      SELECT pmh04 INTO g_bmj.bmj04 
        FROM pmh_file,pmc_file
       WHERE pmh01 = g_bmj.bmj01
         AND pmh02 = g_bmj.bmj03
         AND pmh02 = pmc01
         AND pmh13 = pmc22
         AND pmh21 = " " 
         AND pmh22 = '1'
         AND pmh23 = ' '    
         AND pmhacti = 'Y' 
   END IF 
END FUNCTION

#[
# Description....: 鎖住將被更改或取消的資料
# Date & Author..: 2010/08/25 by Lilan
# Parameter......: none
# Return.........: l_status - INTEGER - TRUE / FALSE Luck 結果
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_item_approval_data_updchk()
DEFINE l_bmj   RECORD LIKE bmj_file.*     

  OPEN i310_cl USING g_bmj01,g_bmj02,g_bmj03
  IF STATUS THEN
     LET g_status.code = STATUS
     CLOSE i310_cl
     RETURN FALSE
  END IF
  FETCH i310_cl INTO l_bmj.*                # 鎖住將被更改或取消的資料
  IF SQLCA.sqlcode THEN
     LET g_status.code = SQLCA.SQLCODE      # 資料被他人LOCK
     LET g_status.sqlcode = SQLCA.SQLCODE
     CLOSE i310_cl
     RETURN FALSE
  END IF
  RETURN TRUE
END FUNCTION

#寫入料件供應商(apmi254)
FUNCTION aws_i310_ins_pmh()               
  DEFINE  l_cnt      LIKE type_file.num5,           
          l_pmh      RECORD LIKE pmh_file.*,
          l_pmh05    LIKE pmh_file.pmh05,
          l_pmh06    LIKE pmh_file.pmh06,
          l_pmc22    LIKE pmc_file.pmc22

     IF g_sma.sma102='N' THEN 
        RETURN TRUE
     END IF

     SELECT pmc22 INTO l_pmc22 
       FROM pmc_file
      WHERE pmc01 = g_bmj.bmj03

     IF NOT cl_null(l_pmc22) THEN
        SELECT COUNT(*) INTO l_cnt 
          FROM pmh_file
         WHERE pmh01 = g_bmj01
           AND pmh02 = g_bmj.bmj03
           AND pmh13 = l_pmc22
           AND pmh21 = " "                                     
           AND pmh22 = '1'                                
           AND pmh23 = ' '                                          
           AND pmhacti = 'Y'                                          
        IF l_cnt > 0 THEN
           CASE 
             WHEN g_bmj.bmj08 = '3'
                  LET l_pmh05 = '0'
                  LET l_pmh06 = g_bmj.bmj11
             WHEN g_bmj.bmj08 = '4'
                  LET l_pmh05 = '2'
                  LET l_pmh06 = ''
             OTHERWISE
                  LET l_pmh05 = '1'
                  LET l_pmh06 = ''
             EXIT CASE
           END CASE
           UPDATE pmh_file SET
                  pmh05 = l_pmh05,
                  pmh06 = l_pmh06,
                  pmhdate = g_today     #FUN-C40009 add
            WHERE pmh01 = g_bmj01
              AND pmh02 = g_bmj.bmj03
              AND pmh13 = l_pmc22
              AND pmh21 = " "                                              
              AND pmh22 = '1'                                              
              AND pmh23 = ' '                                             
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err3("upd","pmh_file",g_bmj01,g_bmj.bmj03,SQLCA.sqlcode,"","upd_pmh_err",0)
              LET g_status.code = "azz-262"
              RETURN FALSE
           END IF
        ELSE
          LET l_pmh.pmh01 = g_bmj01
          LET l_pmh.pmh02 = g_bmj.bmj03
          LET l_pmh.pmh04 = g_bmj.bmj04
          LET l_pmh.pmh07 = g_bmj.bmj02
          LET l_pmh.pmh13 = l_pmc22
          LET l_pmh.pmhacti = 'Y'

          SELECT ima24 INTO l_pmh.pmh08 
            FROM ima_file
           WHERE ima01 = g_bmj01
          IF cl_null(l_pmh.pmh08) THEN 
             LET l_pmh.pmh08 = 'Y' 
          END IF

          IF g_aza.aza17 = l_pmh.pmh13 THEN   #本幣
             LET l_pmh.pmh14 = 1
          ELSE
             CALL s_curr3(l_pmh.pmh13,g_today,'S') RETURNING l_pmh.pmh14
          END IF

          CASE 
            WHEN g_bmj.bmj08='3'
                 LET l_pmh.pmh05 = '0'
                 LET l_pmh.pmh06 = g_bmj.bmj11
            WHEN g_bmj.bmj08='4'
                 LET l_pmh.pmh05 = '2'
                 LET l_pmh.pmh06 = ''
            OTHERWISE
                 LET l_pmh.pmh05 = '1'
                 LET l_pmh.pmh06 = ''
            EXIT CASE
          END CASE

          IF cl_null(l_pmh.pmh13) THEN 
             LET l_pmh.pmh13 = ' ' 
          END IF
          IF cl_null(l_pmh.pmh21) THEN 
             LET l_pmh.pmh21 = ' ' 
          END IF
          IF cl_null(l_pmh.pmh22) THEN 
             LET l_pmh.pmh22 = '1' 
          END IF

          SELECT ima100,ima101,ima102
            INTO l_pmh.pmh09,l_pmh.pmh15,l_pmh.pmh16
            FROM ima_file
           WHERE ima01 = l_pmh.pmh01

          IF cl_null(l_pmh.pmh23) THEN 
             LET l_pmh.pmh23 = ' ' 
          END IF   

          INSERT INTO pmh_file VALUES(l_pmh.*)
          IF SQLCA.sqlcode  THEN
             CALL cl_err3("ins","pmh_file",l_pmh.pmh01,l_pmh.pmh02,SQLCA.sqlcode,"","ins_pmh_err",0)
             LET g_status.code = "azz-262"
             RETURN FALSE
          END IF
        END IF
     END IF
     
     RETURN TRUE
END FUNCTION

#[
# Description....: 異動資料時,若傳入為NULL則保留ERP欄位內原值
# Date & Author..: 2010/09/30 by Lilan
# Parameter......: p_node   - om.DomNode - 單頭 XML 節點
# Memo...........:
# Modify.........:
#]
FUNCTION aws_create_item_approval_data_updchk2(p_node)
   DEFINE p_node     om.DomNode
   DEFINE l_bmj      RECORD LIKE bmj_file.*   

   SELECT * INTO l_bmj.*
     FROM bmj_file
    WHERE bmj01 = g_bmj01
      AND bmj02 = g_bmj02
      AND bmj03 = g_bmj03
 

   IF cl_null(g_bmj.bmj04) THEN
      LET g_bmj.bmj04 = l_bmj.bmj04
   END IF

   IF cl_null(g_bmj.bmj05) THEN
      LET g_bmj.bmj05 = l_bmj.bmj05
   END IF

   IF cl_null(g_bmj.bmj06) THEN
      LET g_bmj.bmj06 = l_bmj.bmj06
   END IF
   
   IF cl_null(g_bmj.bmj07) THEN
      LET g_bmj.bmj07 = l_bmj.bmj07
   END IF

   IF cl_null(g_bmj.bmj08) THEN
      LET g_bmj.bmj08 = l_bmj.bmj08
   END IF   

   IF cl_null(g_bmj.bmj10) THEN
      LET g_bmj.bmj10 = l_bmj.bmj10
   END IF

   IF cl_null(g_bmj.bmj11) THEN
      LET g_bmj.bmj11 = l_bmj.bmj11
   END IF

   IF cl_null(g_bmj.bmj12) THEN
      LET g_bmj.bmj12 = l_bmj.bmj12
   END IF

   IF cl_null(g_bmj.bmjacti) THEN
      LET g_bmj.bmjacti = l_bmj.bmjacti
   END IF
   #FUN-D20002--add---str---
   IF cl_null(g_bmj.bmjoriu) THEN
      LET g_bmj.bmjoriu = l_bmj.bmjoriu
   END IF
   IF cl_null(g_bmj.bmjorig) THEN
      LET g_bmj.bmjorig = l_bmj.bmjorig
   END IF
   IF cl_null(g_bmj.bmjuser) THEN
      LET g_bmj.bmjuser = l_bmj.bmjuser
   END IF
   IF cl_null(g_bmj.bmjgrup) THEN
      LET g_bmj.bmjgrup = l_bmj.bmjgrup
   END IF
   #FUN-D20002--add---end---
END FUNCTION
