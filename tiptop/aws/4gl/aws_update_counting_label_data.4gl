# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_update_counting_label_data.4gl
# Descriptions...: 提供更新盤點標籤資料的服務
# Date & Author..: 2008/05/19 by kim (FUN-840012)
# Memo...........:
#
#}
# Modify.........: No.FUN-980009 09/08/21 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0099 09/11/18 By douzh 给pia931 NOT NULL赋初值
# Modify.........: No.FUN-BB0085 11/12/23 By xianghui 增加數量欄位小數取位
 
DATABASE ds
 
#FUN-840012
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
 
#[
# Description....: 提供更新盤點標籤資料的服務(入口 function)
# Date & Author..: 2008/05/19 by kim
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_update_counting_label_data()
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 更新盤點標籤資料                                                         #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_update_counting_label_data_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
 
#[
# Description....: 依據傳入資訊更新 ERP 盤點標籤資料
# Date & Author..: 2008/05/19 by kim
# Parameter......: none
# Return.........: 標籤編號
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_update_counting_label_data_process()
    DEFINE l_i           LIKE type_file.num10,
           l_j           LIKE type_file.num10
    DEFINE l_sql,l_str   STRING
    DEFINE l_cnt         LIKE type_file.num10,
           l_cnt1        LIKE type_file.num10,
           l_cnt2        LIKE type_file.num10
    DEFINE l_node1       om.DomNode,
           l_node2       om.DomNode
    DEFINE l_flag        LIKE type_file.num5
    DEFINE l_return      RECORD                           #回傳值必須宣告為一個 RECORD 變數, 且此 RECORD 需包含所有要回傳的欄位名稱與定義
                            pia01   LIKE pia_file.pia01   #回傳的欄位名稱
                         END RECORD
    DEFINE l_pia         RECORD LIKE pia_file.*
    DEFINE l_qty         LIKE pia_file.pia30
    DEFINE l_type        LIKE type_file.chr1
    DEFINE p_cmd         LIKE type_file.chr1
 
 
    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的盤點標籤資料                                      #
    #--------------------------------------------------------------------------#
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("pia_file")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***
    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       RETURN
    END IF
 
   #SELECT * INTO g_sma.* FROM sma_file
   # WHERE sma00='0'
 
    SELECT aza42 INTO g_aza.aza42 FROM aza_file
     WHERE aza01='0'
 
    BEGIN WORK
 
    FOR l_i = 1 TO l_cnt1
        INITIALIZE l_pia.* TO NULL
        LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "pia_file")        #目前處理單檔的 XML 節點
 
        LET l_pia.pia01 = aws_ttsrv_getRecordField(l_node1, "pia01")         #盤點標籤
        LET l_type      = aws_ttsrv_getRecordField(l_node1, "type")          #盤點方式  #1:初盤 ; 2:複盤
        LET l_qty       = aws_ttsrv_getRecordField(l_node1, "qty")           #盤點數量-採累加方式
 
        IF cl_null(l_qty) THEN
           LET g_status.code='aws-101'
           EXIT FOR
        END IF
 
        SELECT * INTO l_pia.* FROM pia_file
         WHERE pia01=l_pia.pia01
 
        CASE
          WHEN SQLCA.sqlcode
            #LET g_status.code=SQLCA.sqlcode
            #EXIT FOR
             LET p_cmd='a'
          WHEN l_pia.pia19='Y'
             LET g_status.code='asf-812'
             LET p_cmd='u'
             EXIT FOR
          OTHERWISE
             LET p_cmd='u'
        END CASE
 
        IF p_cmd='u' THEN
           LET l_qty = s_digqty(l_qty,l_pia.pia09)   #FUN-BB0085
           CASE l_type
             WHEN "1"
                IF cl_null(l_pia.pia30) THEN
                   LET l_pia.pia30=0
                END IF
                LET l_pia.pia30=l_pia.pia30+l_qty
                IF l_pia.pia30=0 THEN
                   LET l_sql="UPDATE pia_file SET pia30 = NULL , ",
                                                 "pia31 = NULL , ",
                                                 "pia32 = NULL , ",
                                                 "pia33 = NULL , ",
                                                 "pia34 = NULL , ",
                                                 "pia35 = NULL   ",
                                          " WHERE pia01 = '",l_pia.pia01,"'"
                ELSE
                   LET l_sql="UPDATE pia_file SET pia30 = ",l_pia.pia30,", ",
                                                 "pia31 = '",g_user,"', ",
                                                 "pia32 = '",g_today,"',",
                                                 "pia33 = '",TIME,"', ",
                                                 "pia34 = '",g_user,"', ",
                                                 "pia35 = '",g_today,"' ",
                                          " WHERE pia01 = '",l_pia.pia01,"'"
                END IF
             WHEN "2"
                IF cl_null(l_pia.pia50) THEN
                   LET l_pia.pia50=0
                END IF
                LET l_pia.pia50=l_pia.pia50+l_qty
                IF l_pia.pia50=0 THEN
                   LET l_sql="UPDATE pia_file SET pia50 = NULL , ",
                                                 "pia51 = NULL , ",
                                                 "pia52 = NULL , ",
                                                 "pia53 = NULL , ",
                                                 "pia54 = NULL , ",
                                                 "pia55 = NULL   ",
                                          " WHERE pia01 = '",l_pia.pia01,"'"
                ELSE
                   LET l_sql="UPDATE pia_file SET pia50 = ",l_pia.pia50,", ",
                                                 "pia51 = '",g_user,"', ",
                                                 "pia52 = '",g_today,"',",
                                                 "pia53 = '",TIME,"',",
                                                 "pia54 = '",g_user,"', ",
                                                 "pia55 = '",g_today,"' ",
                                          " WHERE pia01 = '",l_pia.pia01,"'"
                END IF
             OTHERWISE
                LET g_status.code='aws-101'
                EXIT FOR
           END CASE
           
           EXECUTE IMMEDIATE l_sql
           IF SQLCA.sqlerrd[3]=0 THEN
              LET g_status.code = '9050'
              LET g_status.sqlcode = '9050'
              EXIT FOR
           END IF
        ELSE  #新增
           
           LET l_pia.pia02 = aws_ttsrv_getRecordField(l_node1, "pia02")           #料件編號
           LET l_pia.pia03 = aws_ttsrv_getRecordField(l_node1, "pia03")           #倉庫別
           LET l_pia.pia04 = aws_ttsrv_getRecordField(l_node1, "pia04")           #儲位
           LET l_pia.pia05 = aws_ttsrv_getRecordField(l_node1, "pia05")           #批號
           IF cl_null(l_pia.pia03) THEN
              LET l_pia.pia03=' '
           END IF
           IF cl_null(l_pia.pia04) THEN
              LET l_pia.pia04=' '
           END IF
           IF cl_null(l_pia.pia05) THEN
              LET l_pia.pia05=' '
           END IF
           CALL aws_update_counting_label_data_insert(l_type,l_qty,l_pia.*) RETURNING l_flag,l_pia.*
        END IF
        IF g_status.code != "0" THEN   #如果單身處理有任何錯誤, 則離開
           EXIT FOR
        END IF
    END FOR
 
    IF g_status.code = "0" THEN
       LET l_return.pia01 = l_pia.pia01
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
    CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))   #回傳結果
 
END FUNCTION
 
FUNCTION aws_update_counting_label_data_insert(l_type,l_qty,l_pia)
   DEFINE l_qty      LIKE pia_file.pia30
   DEFINE l_pia      RECORD LIKE pia_file.*
   DEFINE l_type     LIKE type_file.chr1
   DEFINE l_img09    LIKE img_file.img09
   DEFINE l_img10    LIKE img_file.img10
   DEFINE l_fac      LIKE ima_file.ima31_fac
   DEFINE l_label    LIKE pib_file.pib01
   DEFINE l_num      LIKE pib_file.pib03
   DEFINE l_flag     LIKE type_file.num5
   DEFINE l_sql      STRING
   DEFINE l_ima25    LIKE ima_file.ima25
 
   SELECT ima25 INTO l_ima25
                FROM ima_file
               WHERE ima01 = l_pia.pia02
   IF SQLCA.sqlcode THEN
      LET g_status.code="mfg1200"
      RETURN FALSE,l_pia.*
   END IF
 
   SELECT img09,img10 INTO l_img09,l_img10
                      FROM img_file
                     WHERE img01 = l_pia.pia02
                       AND img02 = l_pia.pia03
                       AND img03 = l_pia.pia04
                       AND img04 = l_pia.pia05
   IF SQLCA.sqlcode THEN
      LET l_pia.pia09=l_ima25
      LET l_img10=0
      LET l_pia.pia10 = 1
   ELSE
      CALL s_umfchk(l_pia.pia02,l_img09,l_ima25) RETURNING l_flag,l_fac
      IF l_flag = 1 THEN
         LET g_status.code="abm-731"
         RETURN FALSE,l_pia.*
      END IF
      LET l_pia.pia09=l_img09
      LET l_pia.pia10=l_fac
   END IF
 
   LET l_pia.pia08=l_img10
   LET l_pia.pia08=s_digqty(l_pia.pia08,l_pia.pia09)   #FUN-BB0085
   LET l_pia.pia11=g_user
   LET l_pia.pia12=g_today
   LET l_pia.pia15=0
   LET l_pia.pia16='Y'   #空白標籤否  
   LET l_pia.pia19='N'   #是否已作盤點過帳
   LET l_pia.pia66=0
   LET l_pia.pia67=0
   LET l_pia.pia68=0
   LET l_qty = s_digqty(l_qty,l_pia.pia09)    #FUN-BB0085
 
   CASE l_type
      WHEN "1"   #1:初盤
         LET l_pia.pia30=l_qty
         LET l_pia.pia31=g_user
         LET l_pia.pia32=g_today
         LET l_pia.pia33=TIME
         LET l_pia.pia34=g_user
         LET l_pia.pia35=g_today
 
      WHEN "2"   #2:複盤
         LET l_pia.pia50=l_qty
         LET l_pia.pia51=g_user
         LET l_pia.pia52=g_today
         LET l_pia.pia53=TIME
         LET l_pia.pia54=g_user
         LET l_pia.pia55=g_today
 
   END CASE
 
   LET g_success='Y'
  #BEGIN WORK
   
   LET l_label=l_pia.pia01[1,g_doc_len]
 
   LET l_sql = "SELECT pib03 FROM pib_file WHERE pib01 = ? FOR UPDATE"
   LET l_sql=cl_forupd_sql(l_sql)

   DECLARE pib_cl CURSOR FROM l_sql
   OPEN pib_cl USING l_label  #鎖定
   
   #---->目前盤點標籤號碼檔的流水號
   FETCH pib_cl INTO l_num
   
   #---->將現有庫存標籤流水號累加
   CASE g_aza.aza42
   WHEN '1'
     LET l_num  = l_num  + 1 USING "&&&&&&&&"
   WHEN '2'
     LET l_num  = l_num  + 1 USING "&&&&&&&&&"
   WHEN '3'
     LET l_num  = l_num  + 1 USING "&&&&&&&&&&"
   OTHERWISE
     LET l_num  = l_num  + 1 USING "&&&&&&&&"
   END CASE
 
   LET l_pia.pia01 = l_label , "-" , l_num
 
   LET l_pia.pia931 =' '        #FUN-9B0099
   LET l_pia.piaplant = g_plant #FUN-980009
   LET l_pia.pialegal = g_legal #FUN-980009
   INSERT INTO pia_file values (l_pia.*)
   IF SQLCA.sqlcode THEN
      LET g_status.code = '9052'
      LET g_success = 'N'
      CLOSE pib_cl
      RETURN FALSE,l_pia.*
   END IF
   
   UPDATE pib_file
     SET pib03 = l_num
    WHERE pib01 = l_label
   IF SQLCA.sqlerrd[3]=0 THEN
      LET g_status.code ='9050'
      LET g_success = 'N'
      CLOSE pib_cl
      RETURN FALSE,l_pia.*
   END IF
   CLOSE pib_cl
 
   RETURN TRUE,l_pia.*
END FUNCTION
