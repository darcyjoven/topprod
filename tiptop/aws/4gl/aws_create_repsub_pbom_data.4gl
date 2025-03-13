# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_create_repsub_pbom_data.4gl
# Descriptions...: 提供建立P-BOM取替代件資料的服務
# Date & Author..: 2010/07/30 by Mandy
# Memo...........:
# Modify.........: 新建立 FUN-A70147
# Modify.........: No:FUN-AA0035 10/10/25 By Mandy
#                  取替代異動統一call  CreateRepSubPBOMData（建立替代料資料服務），函式說明文件更新如附件，
#                  函式增加異動碼(acttype)欄位，當取代/替代關係全刪除的狀況，需提供此異動碼、檔案類別(bmd02)及主件編號(bmd08)，
#                  表此主件已無任何取代/替代關係。
#                 <Field name="acttype" value="DEL"/>
#                 <!-異動碼  刪除: DEL-->
#                 <!-若取替代關係全刪除的狀況,要提供此異動碼,並提供檔案類別(bmd02)及主件編號(bmd08)-->

#-------------------------------------------------------------------------------------
# Modify.........: No:FUN-A70147 11/07/05 By Mandy GP5.25 PLM 追版,以上單號為GP5.1 單號
# Modify.........: No.FUN-C40007 13/01/10 By Nina 只要程式有UPDATE bmb_file 的任何一個欄位時,多加bmbdate=g_today
# Modify.........: No:FUN-D10092 13/01/20 By Abby service當有錯誤發生時,請給g_status.description 錯誤的說明,方便User 辯識
# Modify.........: No:FUN-D20001 13/02/01 By Mandy GP5.3 PLM追版 for bmd_file差異欄位補強
#}

DATABASE ds #FUN-A70147

GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔

GLOBALS
DEFINE g_bmd         RECORD LIKE bmd_file.*
DEFINE g_bmd_t       RECORD LIKE bmd_file.*
END GLOBALS

#[
# Description....: 提供建立P-BOM取替代件資料的服務(入口 function)
# Date & Author..: 2010/07/30 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_repsub_pbom_data()

    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序

    #--------------------------------------------------------------------------#
    # 新增P-BOM取替代件資料                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_create_repsub_pbom_data_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION


#[
# Description....: 依據傳入資訊新增ERP P-BOM取替代件資料
# Date & Author..: 2010/07/30 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_repsub_pbom_data_process()
    DEFINE l_i       LIKE type_file.num10
    DEFINE l_sql     STRING
    DEFINE l_n       LIKE type_file.num5   #FUN-AA0035 add
    DEFINE l_cnt     LIKE type_file.num5
    DEFINE l_cnt1    LIKE type_file.num10,
           l_cnt2    LIKE type_file.num10
    DEFINE l_wc      STRING
    DEFINE l_node    om.DomNode
    DEFINE l_bmd     RECORD LIKE bmd_file.*
    DEFINE p_cmd     LIKE type_file.chr1
    DEFINE l_forupd_sql STRING
    DEFINE l_acttype LIKE type_file.chr3 #FUN-AA0035 add #當欲刪除取替代關係時,則欄位值為"DEL"
    DEFINE l_bmd01   LIKE bmd_file.bmd01 #FUN-AA0035 add
    DEFINE l_bmd02   LIKE bmd_file.bmd02 #FUN-AA0035 add
    DEFINE l_bmd08   LIKE bmd_file.bmd08 #FUN-AA0035 add
    DEFINE l_msg     STRING              #FUN-D10092 add


    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的P-BOM取替代件資料                                 #
    #--------------------------------------------------------------------------#
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("bmd_file")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***
    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       RETURN
    END IF

    LET l_forupd_sql = " SELECT * FROM bmd_file ",
                       "  WHERE bmd01 = ? ",
                       "    AND bmd02 = ? ",
                       "    AND bmd03 = ? ",
                       "    AND bmd08 = ? ",
                       " FOR UPDATE "              #FUN-A70147(110705) mod
    LET l_forupd_sql = cl_forupd_sql(l_forupd_sql) #FUN-A70147(110705) add
    DECLARE bmd_cl CURSOR FROM l_forupd_sql

    #FUN-AA0035---add---str---
    DROP TABLE  bmd_tmp
    CREATE TEMP TABLE bmd_tmp(
         bmd02  LIKE bmd_file.bmd02,
         bmd08  LIKE bmd_file.bmd08);
    
    LET l_sql = "SELECT UNIQUE bmd01 FROM bmd_file",
                " WHERE bmd02 = ? ",
                "   AND bmd08 = ? ",
                "  ORDER BY bmd01 "
    DECLARE sel_bmd_cl1 CURSOR FROM l_sql

    LET l_sql = "SELECT UNIQUE bmd02,bmd08 FROM bmd_tmp",
                "  ORDER BY bmd02 "
    DECLARE sel_bmd_cl2 CURSOR FROM l_sql
    #FUN-AA0035---add---end---

    BEGIN WORK

    #FUN-AA0035---add---str---
    FOR l_i = 1 TO l_cnt1
        INITIALIZE l_bmd.* TO NULL
        LET gi_err_code=NULL

        LET l_node = aws_ttsrv_getMasterRecord(l_i, "bmd_file")          #目前處理單檔的 XML 節點
        LET l_acttype     = aws_ttsrv_getRecordField(l_node,"acttype")   #
        LET l_bmd.bmd02   = aws_ttsrv_getRecordField(l_node,"bmd02")     #檔案類別
        LET l_bmd.bmd08   = aws_ttsrv_getRecordField(l_node,"bmd08")     #主件
        INSERT INTO bmd_tmp (bmd02,bmd08) VALUES (l_bmd.bmd02,l_bmd.bmd08)
        FOREACH sel_bmd_cl1 USING l_bmd.bmd02,l_bmd.bmd08 INTO l_bmd01
            IF l_bmd.bmd08 <> 'ALL' THEN
                SELECT COUNT(*) INTO l_n
                  FROM bmd_file
                 WHERE bmd01= l_bmd01
                   AND bmd08='ALL'
                   AND bmdacti = 'Y'
                IF l_n = 0 THEN
                   UPDATE bmb_file
                      SET bmb16 = '0', #不可取替代
                          bmbdate = g_today     #FUN-C40007 add
                    WHERE bmb01 = l_bmd.bmd08 #主件編號
                      AND bmb03 = l_bmd01
                END IF
            ELSE
                SELECT COUNT(*) INTO l_n
                  FROM bmd_file
                 WHERE bmd01 = l_bmd01
                   AND bmd08<>'ALL'
                   AND bmdacti = 'Y'
                IF l_n = 0 THEN
                    UPDATE bmb_file
                       SET bmb16 = '0', #不可取替代
                           bmbdate = g_today     #FUN-C40007 add
                     WHERE bmb03 =  l_bmd01 #元件編號
                END IF
            END IF
            IF SQLCA.SQLCODE THEN
               LET g_status.code = SQLCA.SQLCODE
               LET g_status.sqlcode = SQLCA.SQLCODE
               EXIT FOR
            END IF
        END FOREACH
    END FOR
    IF g_status.code = "0" THEN
        FOREACH sel_bmd_cl2 INTO l_bmd02,l_bmd08
            DELETE FROM bmd_file
              WHERE bmd08 = l_bmd08 
                AND bmd02 = l_bmd02
            IF SQLCA.SQLCODE THEN
               LET g_status.code = SQLCA.SQLCODE
               LET g_status.sqlcode = SQLCA.SQLCODE
               EXIT FOREACH
            END IF
        END FOREACH
    END IF
    #FUN-AA0035---add---end---
    IF g_status.code = "0" THEN #FUN-AA0035 add if 判斷
        FOR l_i = 1 TO l_cnt1
            INITIALIZE l_bmd.* TO NULL
            LET gi_err_code=NULL
        
            LET l_node = aws_ttsrv_getMasterRecord(l_i, "bmd_file")         #目前處理單檔的 XML 節點
        
            LET l_acttype     = aws_ttsrv_getRecordField(l_node,"acttype")   #FUN-AA0035 add
            LET l_bmd.bmd01   = aws_ttsrv_getRecordField(l_node,"bmd01")     #取得此筆單檔資料的欄位值
            LET l_bmd.bmd02   = aws_ttsrv_getRecordField(l_node,"bmd02")    
            LET l_bmd.bmd03   = aws_ttsrv_getRecordField(l_node,"bmd03")    
            LET l_bmd.bmd04   = aws_ttsrv_getRecordField(l_node,"bmd04")    
            LET l_bmd.bmd05   = aws_ttsrv_getRecordField(l_node,"bmd05")    
            LET l_bmd.bmd06   = aws_ttsrv_getRecordField(l_node,"bmd06")    
            LET l_bmd.bmd07   = aws_ttsrv_getRecordField(l_node,"bmd07")    
            LET l_bmd.bmd08   = aws_ttsrv_getRecordField(l_node,"bmd08")    
            LET l_bmd.bmd09   = aws_ttsrv_getRecordField(l_node,"bmd09")    
            LET l_bmd.bmdacti = aws_ttsrv_getRecordField(l_node,"bmdacti")    
            LET l_bmd.bmddate = aws_ttsrv_getRecordField(l_node,"bmddate")    
            LET l_bmd.bmdgrup = aws_ttsrv_getRecordField(l_node,"bmdgrup")    
            LET l_bmd.bmduser = aws_ttsrv_getRecordField(l_node,"bmduser")    
            LET l_bmd.bmdmodu = aws_ttsrv_getRecordField(l_node,"bmdmodu")    
            #FUN-AA0035--add---str---
            #FUN-D20001--add---str---
            LET l_bmd.bmdorig = aws_ttsrv_getRecordField(l_node,"bmdorig")    
            LET l_bmd.bmdoriu = aws_ttsrv_getRecordField(l_node,"bmdoriu")    
            LET l_bmd.bmd10   = aws_ttsrv_getRecordField(l_node,"bmd10") 
            LET l_bmd.bmd11   = aws_ttsrv_getRecordField(l_node,"bmd11") 
            #FUN-D20001--add---end---
            IF NOT cl_null(l_acttype) AND l_acttype = 'DEL' THEN
                IF cl_null(l_bmd.bmd02) THEN
                   LET g_status.code = "-286"                                   #主鍵的欄位值不可為 NULL
                   EXIT FOR
                END IF
                IF cl_null(l_bmd.bmd08) THEN
                   LET g_status.code = "-286"                                   #主鍵的欄位值不可為 NULL
                   EXIT FOR
                END IF
                LET p_cmd = 'd'
            ELSE
            #FUN-AA0035--add---end---
                #----------------------------------
                #資料檢查
                IF cl_null(l_bmd.bmd01) THEN
                   LET g_status.code = "-286"                                   #主鍵的欄位值不可為 NULL
                   EXIT FOR
                END IF
                IF cl_null(l_bmd.bmd02) THEN
                   LET g_status.code = "-286"                                   #主鍵的欄位值不可為 NULL
                   EXIT FOR
                END IF
                IF cl_null(l_bmd.bmd03) THEN
                   LET g_status.code = "-286"                                   #主鍵的欄位值不可為 NULL
                   EXIT FOR
                END IF
                IF cl_null(l_bmd.bmd08) THEN
                   LET g_status.code = "-286"                                   #主鍵的欄位值不可為 NULL
                   EXIT FOR
                END IF
                IF cl_null(l_bmd.bmd04) THEN
                   LET g_status.code = "aws-380"  #替代料號的欄位值不可為空
                   EXIT FOR
                END IF
                IF l_bmd.bmd01 = l_bmd.bmd08 THEN
                   LET g_status.code = "mfg2633"  #元件料號不可與主件料號相同                                
                   EXIT FOR
                END IF
                IF l_bmd.bmd01 = l_bmd.bmd04 THEN
                   LET g_status.code = "abm-807"  #元件料號不可和替代料號相同
                   EXIT FOR
                END IF
                IF NOT aws_create_resub_pbom_ima01_chk(l_bmd.bmd01,'1') THEN
                   CALL aws_create_repsub_pbom_error()
                   EXIT FOR
                END IF
                IF NOT aws_create_resub_pbom_ima01_chk(l_bmd.bmd04,'2') THEN
                   CALL aws_create_repsub_pbom_error()
                   EXIT FOR
                END IF
                IF l_bmd.bmd08 <> 'ALL' THEN
                    IF NOT aws_create_resub_pbom_ima01_chk(l_bmd.bmd08,'3') THEN
                       CALL aws_create_repsub_pbom_error()
                       EXIT FOR
                    END IF
                    SELECT * FROM bmb_file
                     WHERE bmb01 = l_bmd.bmd08 
                       AND bmb03 = l_bmd.bmd01
                    IF STATUS = 100 THEN
                        LET g_status.code = "abm-742"  #無此產品結構資料!
                        EXIT FOR
                    END IF
                END IF
                IF NOT aws_create_resub_pbom_date_chk(l_bmd.bmd05,l_bmd.bmd06) THEN
                   CALL aws_create_repsub_pbom_error()
                   EXIT FOR
                END IF
                IF NOT cl_null(l_bmd.bmd07) THEN
                   IF l_bmd.bmd07 <= 0 THEN
                       LET g_status.code = "aws-381"  #替代量不可為負數或不可為零
                       EXIT FOR
                   END IF
                END IF
                #----------------------------------
                #FUN-D20001---add----str----
                IF cl_null(l_bmd.bmd11) THEN #回扣料
                    LET l_bmd.bmd11 = 'N'
                ELSE
                    LET g_status.code = "aws-934" #回扣料(bmd11)的值需為"Y" 或 "N" !
                END IF
                #FUN-D20001---add----end----
                                                                             
                LET l_cnt=0
                SELECT COUNT(*) INTO l_cnt
                  FROM bmd_file
                 WHERE bmd01=l_bmd.bmd01
                   AND bmd02=l_bmd.bmd02
                   AND bmd03=l_bmd.bmd03
                   AND bmd08=l_bmd.bmd08
                IF l_cnt>0 THEN
                   LET p_cmd='u'
                ELSE
                   LET p_cmd='a'
                END IF
            END IF #FUN-AA0035 add
            CASE p_cmd
               WHEN "a"
                  LET g_bmd.*=l_bmd.*
                  LET g_action_choice=NULL
        
               WHEN "u"
                  LET g_bmd.bmd01=l_bmd.bmd01
                  LET g_bmd.bmd02=l_bmd.bmd02
                  LET g_bmd.bmd03=l_bmd.bmd03
                  LET g_bmd.bmd08=l_bmd.bmd08
                  #----------------------------------------------------------------------#
                  # 修改前檢查                                                           #
                  #----------------------------------------------------------------------#
                  IF NOT aws_create_repsub_pbom_updchk() THEN
                     CALL aws_create_repsub_pbom_error()
                     EXIT FOR
                  END IF
        
                  LET g_bmd_t.* = g_bmd.*
                  CALL aws_create_repsub_pbom_delete() #若取替代資料已存在,則做更新動作(先刪除後新增) #FUN-AA0035 mark
                  LET g_action_choice=NULL
        
               #FUN-AA0035---add----str--
               WHEN "d"  #刪除
                  EXIT CASE
               #FUN-AA0035---add----end--
        
               OTHERWISE
                  LET g_status.code = 'aws-101'
                  EXIT FOR
            END CASE
            IF p_cmd = 'a' OR p_cmd = 'u' THEN #FUN-AA0035 add if 判斷
                #----------------------------------------------------------------------#
                # 指定g_bmd Default                                                    #
                #----------------------------------------------------------------------#
                CALL p_bmd_default()       
                
                #----------------------------------------------------------------------#
                # 新增前檢查                                                           #
                #----------------------------------------------------------------------#        
                
                #避免傳入值在途中被改掉,需重新指定一次g_bmd
                CALL aws_create_repsub_pbom_field_update(l_bmd.*)
                
                #------------------------------------------------------------------#
                # RECORD資料傳到NODE                                               #
                #------------------------------------------------------------------#
                CALL aws_ttsrv_setRecordField_record(l_node,base.Typeinfo.create(g_bmd))
                
                #----------------------------------------------------------------------#
                # 若取替代資料已存在,則做更新動作(先刪除後新增)                        #
                #----------------------------------------------------------------------#
                LET l_sql = aws_ttsrv_getRecordSql(l_node, "bmd_file", "I", NULL)   #I 表示取得 INSERT SQL
                
                #----------------------------------------------------------------------#
                # 執行 INSERT / UPDATE SQL                                             #
                #----------------------------------------------------------------------#
                EXECUTE IMMEDIATE l_sql
                IF SQLCA.SQLCODE THEN
                   LET g_status.code = SQLCA.SQLCODE
                   LET g_status.sqlcode = SQLCA.SQLCODE
                   EXIT FOR
                END IF
                #FUN-AA0035---add----str---
                #==>更新BOM表內的取替代特性(bmb16)
                IF l_bmd.bmd08 = 'ALL' THEN
                    UPDATE bmb_file 
                       SET bmb16 = l_bmd.bmd02,
                           bmbdate = g_today     #FUN-C40007 add
                     WHERE bmb03 = l_bmd.bmd01
                ELSE
                    UPDATE bmb_file 
                       SET bmb16 = l_bmd.bmd02,
                           bmbdate = g_today     #FUN-C40007 add   
                     WHERE bmb01 = l_bmd.bmd08
                       AND bmb03 = l_bmd.bmd01
                END IF
                IF SQLCA.SQLCODE THEN
                   LET g_status.code = SQLCA.SQLCODE
                   LET g_status.sqlcode = SQLCA.SQLCODE
                   EXIT FOR
                END IF
                #FUN-AA0035---add----end---
            END IF #FUN-AA0035 add
        END FOR
    END IF #FUN-AA0035 add 
    #全部處理都成功才 COMMIT WORK
    IF g_status.code = "0" THEN
       COMMIT WORK
    ELSE
       #FUN-D10092---add----str----
       LET g_status.description = cl_getmsg(g_status.code, g_lang)   #取得error code
       LET l_msg = cl_mut_get_feldname('bmd01',l_bmd.bmd01,
                                       'bmd02',l_bmd.bmd02,
                                       'bmd03',l_bmd.bmd03,
                                       'bmd08',l_bmd.bmd08,
                                       '','',
                                       '','')
       LET g_status.description = l_msg CLIPPED,"==>",g_status.description
       #FUN-D10092---add----end----
       ROLLBACK WORK
    END IF
END FUNCTION

FUNCTION aws_create_repsub_pbom_error()
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

#將l_bmd中非NULL的欄位值(本次更新的欄位)更新到g_bmd
FUNCTION aws_create_repsub_pbom_field_update(l_bmd)
DEFINE l_bmd RECORD LIKE bmd_file.*
   IF NOT cl_null(l_bmd.bmd01) THEN LET g_bmd.bmd01 = l_bmd.bmd01 END IF
   IF NOT cl_null(l_bmd.bmd02) THEN LET g_bmd.bmd02 = l_bmd.bmd02 END IF   
   IF NOT cl_null(l_bmd.bmd03) THEN LET g_bmd.bmd03 = l_bmd.bmd03 END IF   
   IF NOT cl_null(l_bmd.bmd04) THEN LET g_bmd.bmd04 = l_bmd.bmd04 END IF   
   IF NOT cl_null(l_bmd.bmd05) THEN LET g_bmd.bmd05 = l_bmd.bmd05 END IF   
   IF NOT cl_null(l_bmd.bmd06) THEN LET g_bmd.bmd06 = l_bmd.bmd06 END IF   
   IF NOT cl_null(l_bmd.bmd07) THEN LET g_bmd.bmd07 = l_bmd.bmd07 END IF   
   IF NOT cl_null(l_bmd.bmd08) THEN LET g_bmd.bmd08 = l_bmd.bmd08 END IF   
   IF NOT cl_null(l_bmd.bmd09) THEN LET g_bmd.bmd09 = l_bmd.bmd09 END IF   
   IF NOT cl_null(l_bmd.bmdacti) THEN LET g_bmd.bmdacti = l_bmd.bmdacti END IF   
   IF NOT cl_null(l_bmd.bmddate) THEN LET g_bmd.bmddate = l_bmd.bmddate END IF   
   IF NOT cl_null(l_bmd.bmdgrup) THEN LET g_bmd.bmdgrup = l_bmd.bmdgrup END IF   
   IF NOT cl_null(l_bmd.bmduser) THEN LET g_bmd.bmduser = l_bmd.bmduser END IF   
   IF NOT cl_null(l_bmd.bmdmodu) THEN LET g_bmd.bmdmodu = l_bmd.bmdmodu END IF   
   #FUN-D20001---add---str---
   IF NOT cl_null(l_bmd.bmdorig) THEN LET g_bmd.bmdorig = l_bmd.bmdorig END IF   
   IF NOT cl_null(l_bmd.bmdoriu) THEN LET g_bmd.bmdoriu = l_bmd.bmdoriu END IF   
   IF NOT cl_null(l_bmd.bmd10) THEN LET g_bmd.bmd10 = l_bmd.bmd10 END IF   
   IF NOT cl_null(l_bmd.bmd11) THEN LET g_bmd.bmd11 = l_bmd.bmd11 END IF   
   #FUN-D20001---add---end---
END FUNCTION

FUNCTION aws_create_repsub_pbom_updchk()
   OPEN bmd_cl USING g_bmd.bmd01,g_bmd.bmd02,g_bmd.bmd03,g_bmd.bmd08
   IF STATUS THEN
      CALL cl_err("OPEN bmd_cl:", STATUS, 1)
      CLOSE bmd_cl
      RETURN FALSE
   END IF
   FETCH bmd_cl INTO g_bmd.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bmd.bmd01,SQLCA.sqlcode,0)
      RETURN FALSE
   END IF
   LET g_bmd.bmdmodu = g_user                   #修改者
   LET g_bmd.bmddate = g_today
   RETURN TRUE
END FUNCTION

FUNCTION p_bmd_default()
   LET g_bmd.bmd05   = g_today
   LET g_bmd.bmd07   = 1
   LET g_bmd.bmduser = g_user
   LET g_bmd.bmdgrup = g_grup
   LET g_bmd.bmddate = g_today   
   LET g_bmd.bmdacti = 'Y'
   LET g_bmd.bmdoriu = g_user #FUN-D20001 add
   LET g_bmd.bmdorig = g_grup #FUN-D20001 add
END FUNCTION


#[
# Description....: 刪除相關資料 
# Date & Author..: 2010/07/30 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_repsub_pbom_delete()
    DELETE FROM bmd_file
       WHERE bmd01 = g_bmd.bmd01 
         AND bmd02 = g_bmd.bmd02
         AND bmd03 = g_bmd.bmd03
         AND bmd08 = g_bmd.bmd08

END FUNCTION

FUNCTION aws_create_resub_pbom_ima01_chk(p_ima01,p_type)
   DEFINE  p_ima01   LIKE ima_file.ima01
   DEFINE  p_type    LIKE type_file.chr1 #'1':檢核bmd01 ,'2':檢核bmd04 '3':檢核bmd08 
   DEFINE  l_imaacti LIKE ima_file.imaacti
 
    LET g_errno = ' '
    SELECT imaacti
      INTO l_imaacti
      FROM ima_file 
     WHERE ima01 = p_ima01
    IF SQLCA.SQLCODE = 100 THEN
        CASE p_type
              WHEN '1' 
                  LET g_errno = 'aws-194' #元件編號(bmd01)不存在料件主檔(ima_file)中!
              WHEN '2' 
                  LET g_errno = 'aws-195' #替代料號(bmd04)不存在料件主檔(ima_file)中!
              WHEN '3' 
                  LET g_errno = 'aws-196' #主件編號(bmd08)不存在料件主檔(ima_file)中!
        END CASE
        RETURN FALSE
    END IF
    IF SQLCA.SQLCODE THEN
        LET g_errno = SQLCA.SQLCODE USING '-------'
        RETURN FALSE
    END IF
    IF l_imaacti <>'Y' THEN LET g_errno = '9029'
        CASE p_type
              WHEN '1' 
                  LET g_errno = 'aws-197' #元件編號(bmd01)資料尚未確認,不可使用!
              WHEN '2' 
                  LET g_errno = 'aws-198' #替代料號(bmd04)資料尚未確認,不可使用!
              WHEN '3' 
                  LET g_errno = 'aws-199' #主件編號(bmd08)資料尚未確認,不可使用!
        END CASE
        RETURN FALSE
    END IF
    LET g_errno = SQLCA.SQLCODE USING '-------'
    RETURN TRUE
END FUNCTION

FUNCTION aws_create_resub_pbom_date_chk(p_bmd05,p_bmd06)
   DEFINE p_bmd05   LIKE bmd_file.bmd05
   DEFINE p_bmd06   LIKE bmd_file.bmd06

   LET g_errno = ' '
   IF NOT cl_null(p_bmd05) AND NOT cl_null(p_bmd06) THEN
       IF p_bmd06 <= p_bmd05 THEN
          LET g_errno = "mfg2604" #失效日期不可小於生效日期
          RETURN FALSE
       END IF
   END IF
   RETURN TRUE
END FUNCTION
