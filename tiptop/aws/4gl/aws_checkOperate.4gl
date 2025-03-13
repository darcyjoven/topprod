# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Date & Author..: 06/07/20 By heartheros
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷                              
#函數表：
# BeforeInsert(l_ObjectID,l_Sep,rec_data,p_index) RETURNING l_errCode,l_errDesc                                                                    
# BeforeDelete(l_ObjectID,l_Sep,rec_datarec,p_index) RETURNING l_errCode,l_errDesc
# BeforeUpdate(l_ObjectID,l_Sep,rec_dataRec,p_index) RETURNING l_errCode,l_errDesc
# AfterInsert(l_ObjectID,l_Sep,rec_data,p_index) RETURNING l_errCode,l_errDesc
# AfterDelete(l_ObjectID,l_Sep,rec_data,p_index) RETURNING l_errCode,l_errDesc
# AfterUpdate(l_ObjectID,l_Sep,rec_data,p_index) RETURNING l_errCode,l_errDesc
# BeforeInsertItem(l_sep,l_checkHeadField,l_checkBodyField,l_checkHeadData,l_checkBodyData)
# AfterInsertItem(l_sep,l_checkHeadField,l_checkBodyField,l_checkHeadData,l_checkBodyData)
# BeforeDeleteItem(l_sep,l_checkHeadField,l_checkBodyField,l_checkHeadData,l_checkBodyData)
# AfterDeleteItem(l_sep,l_checkHeadField,l_checkBodyField,l_checkHeadData,l_checkBodyData)
# BeforeUpdateItem(l_sep,l_CheckHeadField,l_checkBodyField,l_checkHeadData,l_checkBodyData)
# AfterUpdateItem(l_sep,l_CheckHeadField,l_checkBodyField,l_checkHeadData,l_checkBodyData)
# BeforeInsertBom(l_sep,l_checkHeadField,l_checkBodyField,l_checkHeadData,l_checkBodydata)
# AfterInsertBom(l_sep,l_checkHeadField,l_checkBodyField,l_checkHeadData,l_checkBodydata)
# BeforeDeleteBom(l_sep,l_checkHeadField,l_checkBodyField,l_checkHeadData,l_checkBodydata)
# AfterDeleteBom(l_sep,l_checkHeadField,l_checkBodyField,l_checkHeadData,l_checkBodydata)
#
# Modify.........: No.FUN-980009 09/08/21 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
 
                                                                      
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0080 09/10/26 By lilingyu 調整Sql的標準寫法
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No:FUN-A40023 10/04/12 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No.FUN-C30315 13/01/09 By Nina 只要程式有UPDATE ima_file 的任何一個欄位時,多加imadate=g_today 
# Modify.........: No.FUN-C40007 13/01/10 By Nina 只要程式有UPDATE bmb_file 的任何一個欄位時,多加bmbdate=g_today
# Modify.........: No:FUN-D40103 13/05/09 By lixh1 增加儲位有效性檢查

DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE head1               STRING,
       head2              DYNAMIC ARRAY OF STRING,
       head3              DYNAMIC ARRAY OF STRING,
       value2             DYNAMIC ARRAY OF STRING,
       value3        DYNAMIC ARRAY OF STRING
DEFINE g_ima     RECORD LIKE ima_file.*,
       g_ima_t   RECORD LIKE ima_file.*,
       g_ima_o   RECORD LIKE ima_file.*,
       g_forupd_sql      STRING,
#       g_ima_rowi      VARCHAR(18),   #FUN-9A0080
       g_ima01_t        LIKE ima_file.ima01,
       g_gen02          LIKE gen_file.gen02
DEFINE g_bma     RECORD LIKE bma_file.*,
       g_bma_t   RECORD LIKE bma_file.*,
       g_bma_o   RECORD LIKE bma_file.*,
       g_bmb     RECORD LIKE bmb_file.*,
        g_bmb_t  RECORD LIKE bmb_file.*,
       g_bmb_o   RECORD LIKE bmb_file.*,
       g_cnt            INTEGER,
       g_sw             SMALLINT,
#       g_bma_rowi      VARCHAR(18),  #FUN-9A0080
#       g_bmb_rowi      CHAR{18},     #FUN-9A0080
       g_msg            VARCHAR(72),
       g_bma01_t        LIKE bma_file.bma01
DEFINE g_ima08_b       LIKE ima_file.ima08,   #來源碼
       g_ima08_h       LIKE ima_file.ima08,
       g_ima37_b       LIKE ima_file.ima37,   #補貨政策
       g_ima25_b       LIKE ima_file.ima25,   #庫存單位
       g_ima63_b       LIKE ima_file.ima63,   #發料單位
       g_ima70_b       LIKE ima_file.ima63,   #消耗料件
       g_ima107_b      LIKE ima_file.ima107,  #LOCATION
       g_ima86_b       LIKE ima_file.ima86   #成本單位
DEFINE l_detail            SMALLINT,
       l_ignore            STRING,
       l_headc             STRING            #用來若單頭錯誤，單身全部為l_ignore為Y
DEFINE i,l_n                 SMALLINT   
{DEFINE l_errid             STRING,
       l_errcode           STRING,
       i,l_n                 SMALLINT,
       l_imzacti        LIKE imz_file.imzacti,
       l_misc              VARCHAR(04)
}
 
#*************************************************************************
#CALL BeforeInsert(l_ObjectID,l_Sep,rec_data,p_index) RETURNING l_errCode,l_errDesc
FUNCTION BeforeInsert(l_ObjectID,l_sep,rec_dataRec,p_index)  
DEFINE   l_ObjectID   LIKE waa_file.waa01,
         l_sep        STRING,
         l_errCode    STRING, #ze_file中的errcode
         l_errDesc  STRING,   #錯誤的詳細描述
         p_index      SMALLINT,
         rec_dataRec  DYNAMIC ARRAY OF RECORD
            tables        STRING,
            fields        STRING,
            data          STRING,
            body            DYNAMIC ARRAY OF RECORD
               tables        STRING,
               fields        STRING,
               data          STRING,
               detail           DYNAMIC ARRAY OF RECORD
                  tables         STRING,
                  fields         STRING,
                  data           STRING,
                  subdetail        DYNAMIC ARRAY OF RECORD
                     tables           STRING,
                     fields           STRING,
                     data             STRING
                                   END RECORD       
                               END RECORD
                           END RECORD
                       END RECORD,
         rec_data1     RECORD
            tables        STRING,
            fields        STRING,
            data          STRING,
            body            DYNAMIC ARRAY OF RECORD
               tables        STRING,
               fields        STRING,
               data          STRING,
               detail           DYNAMIC ARRAY OF RECORD
                  tables         STRING,
                  fields         STRING,
                  data           STRING,
                  subdetail        DYNAMIC ARRAY OF RECORD
                     tables           STRING,
                     fields           STRING,
                     data             STRING
                                   END RECORD       
                               END RECORD
                           END RECORD
                       END RECORD
DEFINE l_checkHeadField    STRING,
       l_checkHeadData     STRING
DEFINE l_checkBodyField  DYNAMIC ARRAY OF RECORD
                          FIELD STRING
                         END RECORD,
        l_checkBodyData  DYNAMIC ARRAY OF RECORD
                          DATA  STRING
                          END RECORD
  #分割符為空就設為默認
  IF cl_null(l_sep) THEN
     LET l_sep = '|'
  END IF
  #接受數據
  LET rec_data1.*=rec_dataRec[p_index].*
  #判斷是對BOM操作還是對ITEM操作 
  CASE 
     WHEN l_ObjectID="BOM" OR l_ObjectID="Bom" OR l_ObjectID=" bom"
        IF NOT cl_null(rec_data1.tables) THEN
           IF rec_data1.tables<>"bma_file" AND rec_data1.tables<>"bmb_file"
          AND rec_data1.tables<>"BMA_FILE" AND rec_data1.tables<>"BMB_FILE" THEN
              LET l_errCode='aws-226'
              LET l_errDesc="數據表名稱錯誤(表名：",rec_data1.tables,")"
              RETURN l_errCode,l_errDesc
           END IF
        END IF
        LET l_checkHeadField = rec_data1.fields
        LET l_checkHeadData = rec_data1.data
        LET l_checkBodyField[1].FIELD = rec_data1.body[1].fields
        FOR i=1 TO rec_data1.body.getLength()
           LET l_checkBodyData[i].DATA = rec_data1.body[i].data
        END FOR
        LET l_errCode=NULL
        LET l_errDesc=NULL
        CALL BeforeInsertBom(l_sep,l_checkHeadField,l_checkBodyField,l_checkHeadData,l_checkBodyData)
        RETURNING l_errCode,l_errDesc
        RETURN l_errCode,l_errDesc
     WHEN l_ObjectID="ITEM" OR l_ObjectID="Item" OR l_ObjectID="item"
        IF NOT cl_null(rec_data1.tables) THEN
           IF rec_data1.tables<>"ima_file" AND rec_data1.tables<>"IMA_FILE" THEN
              LET l_errCode="aws-226"
              LET l_errDesc="數據表名稱錯誤(表名：",rec_data1.tables,")"
              RETURN l_errCode,l_errDesc
           END IF
        END IF
        LET l_checkHeadField = rec_data1.fields
        LET l_checkHeadData = rec_data1.data
        LET l_errCode=NULL
        LET l_errDesc=NULL
        CALL BeforeInsertItem(l_sep,l_checkHeadField,'',l_checkHeadData,'')
        RETURNING l_errCode,l_errDesc
        RETURN l_errCode,l_errDesc
     OTHERWISE
#        LET l_errCode="aws-205"
#        LET l_errDesc="操作類型碼錯誤"
#        RETURN l_errCode,l_errDesc
        RETURN '',''
  END CASE
END FUNCTION
#***************************************************************************************
#CALL BeforeDelete(l_ObjectID,l_Sep,rec_datarec,p_index) RETURNING l_errCode,l_errDesc
FUNCTION BeforeDelete(l_ObjectID,l_sep,rec_datarec,p_index)
DEFINE   l_ObjectID   LIKE waa_file.waa01,
         l_sep        STRING,
         l_errCode    STRING, #ze_file中的errcode
         l_errDesc  STRING,   #錯誤的詳細描述
         p_index      SMALLINT,
         rec_dataRec  DYNAMIC ARRAY OF RECORD
            tables        STRING,
            fields        STRING,
            data          STRING,
            body            DYNAMIC ARRAY OF RECORD
               tables        STRING,
               fields        STRING,
               data          STRING,
               detail           DYNAMIC ARRAY OF RECORD
                  tables         STRING,
                  fields         STRING,
                  data           STRING,
                  subdetail        DYNAMIC ARRAY OF RECORD
                     tables           STRING,
                     fields           STRING,
                     data             STRING
                                   END RECORD       
                               END RECORD
                           END RECORD
                       END RECORD,
         rec_data2     RECORD
            tables        STRING,
            fields        STRING,
            data          STRING,
            body            DYNAMIC ARRAY OF RECORD
               tables        STRING,
               fields        STRING,
               data          STRING,
               detail           DYNAMIC ARRAY OF RECORD
                  tables         STRING,
                  fields         STRING,
                  data           STRING,
                  subdetail        DYNAMIC ARRAY OF RECORD
                     tables           STRING,
                     fields           STRING,
                     data             STRING
                                   END RECORD       
                               END RECORD
                           END RECORD
                       END RECORD
DEFINE l_checkHeadField    STRING,
       l_checkHeadData     STRING
DEFINE l_checkBodyField  DYNAMIC ARRAY OF RECORD
                          FIELD STRING
                         END RECORD,
        l_checkBodyData  DYNAMIC ARRAY OF RECORD
                          DATA  STRING
                          END RECORD
  #分割符為空就設為默認
  IF cl_null(l_sep) THEN
     LET l_sep = '|'
  END IF
  #接收數據
  LET rec_data2.*=rec_dataRec[p_index].*
  #判斷是對BOM操作還是對ITEM操作 
  CASE 
     WHEN l_ObjectID="BOM" OR l_ObjectID="Bom" OR l_ObjectID=" bom"
        IF NOT cl_null(rec_data2.tables) THEN
           IF rec_data2.tables<>"bma_file" AND rec_data2.tables<>"bmb_file"
          AND rec_data2.tables<>"BMA_FILE" AND rec_data2.tables<>"BMB_FILE" THEN
              LET l_errCode='aws-226'
              LET l_errDesc="數據表名稱錯誤(表名：",rec_data2.tables,")"
              RETURN l_errCode,l_errDesc
           END IF
        END IF
        LET l_checkHeadField = rec_data2.fields
        LET l_checkHeadData = rec_data2.data
        LET l_checkBodyField[1].FIELD = rec_data2.body[1].fields
        FOR i=1 TO rec_data2.body.getLength()
           LET l_checkBodyData[i].DATA = rec_data2.body[i].data
        END FOR
        LET l_errCode=NULL
        LET l_errDesc=NULL
        CALL BeforeDeleteBom(l_sep,l_checkHeadField,l_checkBodyField,l_checkHeadData,l_checkBodyData)
        RETURNING l_errCode,l_errDesc
        RETURN l_errCode,l_errDesc
     WHEN l_ObjectID="ITEM" OR l_ObjectID="Item" OR l_ObjectID="item"
        IF NOT cl_null(rec_data2.tables) THEN
           IF rec_data2.tables<>"ima_file" AND rec_data2.tables<>"IMA_FILE" THEN
              LET l_errCode="aws-226"
              LET l_errDesc="數據表名稱錯誤(表名：",rec_data2.tables,")"
              RETURN l_errCode,l_errDesc
           END IF
        END IF
        #
        LET l_checkHeadField = rec_data2.fields
        LET l_checkHeadData = rec_data2.data
        LET l_errCode=NULL
        LET l_errDesc=NULL
        CALL BeforeDeleteItem(l_sep,l_checkHeadField,'',l_checkHeadData,'')
        RETURNING l_errCode,l_errDesc
        RETURN l_errCode,l_errDesc
     OTHERWISE
#        LET l_errCode="aws-205"
#        LET l_errDesc="操作類型碼錯誤"
#        RETURN l_errCode,l_errDesc
        RETURN '',''
  END CASE
END FUNCTION
#********************************************************************************** 
#CALL BeforeUpdate(l_ObjectID,l_Sep,rec_dataRec,p_index) RETURNING l_errCode,l_errDesc
FUNCTION BeforeUpdate(l_ObjectID,l_sep,rec_dataRec,p_index)
DEFINE   l_ObjectID   LIKE waa_file.waa01,
         l_sep        STRING,
         l_errCode    STRING, #ze_file中的errcode
         l_errDesc  STRING,   #錯誤的詳細描述
         p_index      SMALLINT,
         rec_dataRec  DYNAMIC ARRAY OF RECORD
            tables        STRING,
            fields        STRING,
            data          STRING,
            body            DYNAMIC ARRAY OF RECORD
               tables        STRING,
               fields        STRING,
               data          STRING,
               detail           DYNAMIC ARRAY OF RECORD
                  tables         STRING,
                  fields         STRING,
                  data           STRING,
                  subdetail        DYNAMIC ARRAY OF RECORD
                     tables           STRING,
                     fields           STRING,
                     data             STRING
                                   END RECORD       
                               END RECORD
                           END RECORD
                       END RECORD,
         rec_data3     RECORD
            tables        STRING,
            fields        STRING,
            data          STRING,
            body            DYNAMIC ARRAY OF RECORD
               tables        STRING,
               fields        STRING,
               data          STRING,
               detail           DYNAMIC ARRAY OF RECORD
                  tables         STRING,
                  fields         STRING,
                  data           STRING,
                  subdetail        DYNAMIC ARRAY OF RECORD
                     tables           STRING,
                     fields           STRING,
                     data             STRING
                                   END RECORD       
                               END RECORD
                           END RECORD
                       END RECORD
DEFINE l_checkHeadField    STRING,
       l_checkHeadData     STRING
DEFINE l_checkBodyField  DYNAMIC ARRAY OF RECORD
                          FILED STRING
                         END RECORD,
        l_checkBodyData  DYNAMIC ARRAY OF RECORD
                          DATA  STRING
                          END RECORD
  #分割符為空就設為默認
  IF cl_null(l_sep) THEN
     LET l_sep = '|'
  END IF
  #接收數據
  LET rec_data3.*=rec_dataRec[p_index].*
  #Update僅僅在ITEM中操作，對BOM的UPDATE在UPDATEBOM接口實現 
  CASE 
     WHEN l_ObjectID="ITEM" OR l_ObjectID="Item" OR l_ObjectID="item"
        IF NOT cl_null(rec_data3.tables) THEN
           IF rec_data3.tables<>"ima_file" AND rec_data3.tables<>"IMA_FILE" THEN
              LET l_errCode="aws-226"
              LET l_errDesc="數據表名稱錯誤(表名：",rec_data3.tables,")"
              RETURN l_errCode,l_errDesc
           END IF
        END IF
        #
        LET l_checkHeadField = rec_data3.fields
        LET l_checkHeadData = rec_data3.data
        LET l_errCode=NULL
        LET l_errDesc=NULL
        CALL BeforeUpdateItem(l_sep,l_checkHeadField,'',l_checkHeadData,'')
        RETURNING l_errCode,l_errDesc
        RETURN l_errCode,l_errDesc
     OTHERWISE
#        LET l_errCode="aws-205"
#        LET l_errDesc="操作類型碼錯誤"
#        RETURN l_errCode,l_errDesc
        RETURN '',''
  END CASE
END FUNCTION
#*********************************************************************************************   
#CALL AfterInsert(l_ObjectID,l_Sep,rec_data,p_index) RETURNING l_errCode,l_errDesc
FUNCTION AfterInsert(l_ObjectID,l_Sep,rec_dataRec,p_index)
DEFINE   l_ObjectID   LIKE waa_file.waa01,
         l_sep        STRING,
         l_errCode    STRING, #ze_file中的errcode
         l_errDesc  STRING,   #錯誤的詳細描述
         p_index      SMALLINT,
         rec_dataRec  DYNAMIC ARRAY OF RECORD
            tables        STRING,
            fields        STRING,
            data          STRING,
            body            DYNAMIC ARRAY OF RECORD
               tables        STRING,
               fields        STRING,
               data          STRING,
               detail           DYNAMIC ARRAY OF RECORD
                  tables         STRING,
                  fields         STRING,
                  data           STRING,
                  subdetail        DYNAMIC ARRAY OF RECORD
                     tables           STRING,
                     fields           STRING,
                     data             STRING
                                   END RECORD       
                               END RECORD
                           END RECORD
                       END RECORD,
         rec_data4     RECORD
            tables        STRING,
            fields        STRING,
            data          STRING,
            body            DYNAMIC ARRAY OF RECORD
               tables        STRING,
               fields        STRING,
               data          STRING,
               detail           DYNAMIC ARRAY OF RECORD
                  tables         STRING,
                  fields         STRING,
                  data           STRING,
                  subdetail        DYNAMIC ARRAY OF RECORD
                     tables           STRING,
                     fields           STRING,
                     data             STRING
                                   END RECORD       
                               END RECORD
                           END RECORD
                       END RECORD
DEFINE l_checkHeadField    STRING,
       l_checkHeadData     STRING
DEFINE l_checkBodyField  DYNAMIC ARRAY OF RECORD
                         FIELD STRING
                         END RECORD,
        l_checkBodyData  DYNAMIC ARRAY OF RECORD
                          DATA  STRING
                          END RECORD
  #分割符為空就設為默認
  IF cl_null(l_sep) THEN
     LET l_sep = '|'
  END IF
  #接收數據
  LET rec_data4.*=rec_dataRec[p_index].*
 
  CASE 
     WHEN l_ObjectID="ITEM" OR l_ObjectID="Item" OR l_ObjectID="item"
        IF NOT cl_null(rec_data4.tables) THEN
           IF rec_data4.tables<>"ima_file" AND rec_data4.tables<>"IMA_FILE" THEN
              LET l_errCode="aws-226"
              LET l_errDesc="數據表名稱錯誤(表名：",rec_data4.tables,")"
              RETURN l_errCode,l_errDesc
           END IF
        END IF
        #
        LET l_checkHeadField = rec_data4.fields
        LET l_checkHeadData = rec_data4.data
        LET l_errCode=NULL
        LET l_errDesc=NULL
        CALL AfterInsertItem(l_sep,l_checkHeadField,'',l_checkHeadData,'')
        RETURNING l_errCode,l_errDesc
        RETURN l_errCode,l_errDesc
     WHEN l_ObjectID="BOM" OR l_ObjectID="Bom" OR l_ObjectID=" bom"
        IF NOT cl_null(rec_data4.tables) THEN
           IF rec_data4.tables<>"bma_file" AND rec_data4.tables<>"bmb_file"
          AND rec_data4.tables<>"BMA_FILE" AND rec_data4.tables<>"BMB_FILE" THEN
              LET l_errCode='aws-226'
              LET l_errDesc="數據表名稱錯誤(表名：",rec_data4.tables,")"
              RETURN l_errCode,l_errDesc
           END IF
        END IF
        LET l_checkHeadField = rec_data4.fields
        LET l_checkHeadData = rec_data4.data
        LET l_checkBodyField[1].FIELD = rec_data4.body[1].fields
        FOR i=1 TO rec_data4.body.getLength()
           LET l_checkBodyData[i].DATA = rec_data4.body[i].data
        END FOR
        LET l_errCode=NULL
        LET l_errDesc=NULL
        CALL AfterInsertBom(l_sep,l_checkHeadField,l_checkBodyField,l_checkHeadData,l_checkBodyData)
        RETURNING l_errCode,l_errDesc
        RETURN l_errCode,l_errDesc
     OTHERWISE
#        LET l_errCode="aws-205"
#        LET l_errDesc="操作類型碼錯誤"
#        RETURN l_errCode,l_errDesc
        RETURN '',''
  END CASE
END FUNCTION
#**************************************************************************************
#CALL AfterDelete(l_ObjectID,l_Sep,rec_data,p_index) RETURNING l_errCode,l_errDesc
FUNCTION AfterDelete(l_ObjectID,l_Sep,rec_dataRec,p_index)
DEFINE   l_ObjectID   LIKE waa_file.waa01,
         l_sep        STRING,
         l_errCode    STRING, #ze_file中的errcode
         l_errDesc  STRING,   #錯誤的詳細描述
         p_index      SMALLINT,
         rec_dataRec  DYNAMIC ARRAY OF RECORD
            tables        STRING,
            fields        STRING,
            data          STRING,
            body            DYNAMIC ARRAY OF RECORD
               tables        STRING,
               fields        STRING,
               data          STRING,
               detail           DYNAMIC ARRAY OF RECORD
                  tables         STRING,
                  fields         STRING,
                  data           STRING,
                  subdetail        DYNAMIC ARRAY OF RECORD
                     tables           STRING,
                     fields           STRING,
                     data             STRING
                                   END RECORD       
                               END RECORD
                           END RECORD
                       END RECORD,
         rec_data5     RECORD
            tables        STRING,
            fields        STRING,
            data          STRING,
            body            DYNAMIC ARRAY OF RECORD
               tables        STRING,
               fields        STRING,
               data          STRING,
               detail           DYNAMIC ARRAY OF RECORD
                  tables         STRING,
                  fields         STRING,
                  data           STRING,
                  subdetail        DYNAMIC ARRAY OF RECORD
                     tables           STRING,
                     fields           STRING,
                     data             STRING
                                   END RECORD       
                               END RECORD
                           END RECORD
                       END RECORD
DEFINE l_checkHeadField    STRING,
       l_checkHeadData     STRING
DEFINE l_checkBodyField  DYNAMIC ARRAY OF RECORD
                          FIELD STRING
                         END RECORD,
        l_checkBodyData  DYNAMIC ARRAY OF RECORD
                          DATA  STRING
                          END RECORD
  #分割符為空就設為默認
  IF cl_null(l_sep) THEN
     LET l_sep = '|'
  END IF
  #接收數據
  LET rec_data5.*=rec_dataRec[p_index].*
  #Update僅僅在ITEM中操作，對BOM的UPDATE在UPDATEBOM接口實現 
  CASE 
     WHEN l_ObjectID="ITEM" OR l_ObjectID="Item" OR l_ObjectID="item"
        IF NOT cl_null(rec_data5.tables) THEN
           IF rec_data5.tables<>"ima_file" AND rec_data5.tables<>"IMA_FILE" THEN
              LET l_errCode="aws-226"
              LET l_errDesc="數據表名稱錯誤(表名：",rec_data5.tables,")"
              RETURN l_errCode,l_errDesc
           END IF
        END IF
        #
        LET l_checkHeadField = rec_data5.fields
        LET l_checkHeadData = rec_data5.data
        LET l_errCode=NULL
        LET l_errDesc=NULL
        CALL AfterDeleteItem(l_sep,l_checkHeadField,'',l_checkHeadData,'')
        RETURNING l_errCode,l_errDesc
        RETURN l_errCode,l_errDesc
     WHEN l_ObjectID="BOM" OR l_ObjectID="Bom" OR l_ObjectID=" bom"
        IF NOT cl_null(rec_data5.tables) THEN
           IF rec_data5.tables<>"bma_file" AND rec_data5.tables<>"bmb_file"
          AND rec_data5.tables<>"BMA_FILE" AND rec_data5.tables<>"BMB_FILE" THEN
              LET l_errCode='aws-226'
              LET l_errDesc="數據表名稱錯誤(表名：",rec_data5.tables,")"
              RETURN l_errCode,l_errDesc
           END IF
        END IF
        LET l_checkHeadField = rec_data5.fields
        LET l_checkHeadData = rec_data5.data
        LET l_checkBodyField[1].FIELD = rec_data5.body[1].fields
        FOR i=1 TO rec_data5.body.getLength()
           LET l_checkBodyData[i].DATA = rec_data5.body[i].data
        END FOR
        LET l_errCode=NULL
        LET l_errDesc=NULL
        CALL AfterDeleteBom(l_sep,l_checkHeadField,l_checkBodyField,l_checkHeadData,l_checkBodyData)
        RETURNING l_errCode,l_errDesc
        RETURN l_errCode,l_errDesc
     OTHERWISE
#        LET l_errCode="aws-205"
#        LET l_errDesc="操作類型碼錯誤"
#        RETURN l_errCode,l_errDesc
        RETURN '',''
  END CASE
END FUNCTION
#****************************************************************
#CALL AfterUpdate(l_ObjectID,l_Sep,rec_data,p_index) RETURNING l_errCode,l_errDesc
FUNCTION AfterUpdate(l_ObjectID,l_Sep,rec_dataRec,p_index)
DEFINE   l_ObjectID   LIKE waa_file.waa01,
         l_sep        STRING,
         l_errCode    STRING, #ze_file中的errcode
         l_errDesc  STRING,   #錯誤的詳細描述
         p_index      SMALLINT,
         rec_dataRec  DYNAMIC ARRAY OF RECORD
            tables        STRING,
            fields        STRING,
            data          STRING,
            body            DYNAMIC ARRAY OF RECORD
               tables        STRING,
               fields        STRING,
               data          STRING,
               detail           DYNAMIC ARRAY OF RECORD
                  tables         STRING,
                  fields         STRING,
                  data           STRING,
                  subdetail        DYNAMIC ARRAY OF RECORD
                     tables           STRING,
                     fields           STRING,
                     data             STRING
                                   END RECORD       
                               END RECORD
                           END RECORD
                       END RECORD,
         rec_data3     RECORD
            tables        STRING,
            fields        STRING,
            data          STRING,
            body            DYNAMIC ARRAY OF RECORD
               tables        STRING,
               fields        STRING,
               data          STRING,
               detail           DYNAMIC ARRAY OF RECORD
                  tables         STRING,
                  fields         STRING,
                  data           STRING,
                  subdetail        DYNAMIC ARRAY OF RECORD
                     tables           STRING,
                     fields           STRING,
                     data             STRING
                                   END RECORD       
                               END RECORD
                           END RECORD
                       END RECORD
DEFINE l_checkHeadField    STRING,
       l_checkHeadData     STRING
DEFINE l_checkBodyField  DYNAMIC ARRAY OF RECORD
                          FILED STRING
                         END RECORD,
        l_checkBodyData  DYNAMIC ARRAY OF RECORD
                          DATA  STRING
                          END RECORD
  #分割符為空就設為默認
  IF cl_null(l_sep) THEN
     LET l_sep = '|'
  END IF
  #接收數據
  LET rec_data3.*=rec_dataRec[p_index].*
  #Update僅僅在ITEM中操作，對BOM的UPDATE在UPDATEBOM接口實現 
  CASE 
     WHEN l_ObjectID="ITEM" OR l_ObjectID="Item" OR l_ObjectID="item"
        IF NOT cl_null(rec_data3.tables) THEN
           IF rec_data3.tables<>"ima_file" AND rec_data3.tables<>"IMA_FILE" THEN
              LET l_errCode="aws-226"
              LET l_errDesc="數據表名稱錯誤(表名：",rec_data3.tables,")"
              RETURN l_errCode,l_errDesc
           END IF
        END IF
        #
        LET l_checkHeadField = rec_data3.fields
        LET l_checkHeadData = rec_data3.data
        LET l_errCode=NULL
        LET l_errDesc=NULL
        CALL AfterUpdateItem(l_sep,l_checkHeadField,'',l_checkHeadData,'')
        RETURNING l_errCode,l_errDesc
        RETURN l_errCode,l_errDesc
     OTHERWISE
#        LET l_errCode="aws-205"
#        LET l_errDesc="操作類型碼錯誤"
#        RETURN l_errCode,l_errDesc
        RETURN '',''
  END CASE
END FUNCTION                       
#**********************************************************************************************
FUNCTION BeforeInsertItem(l_sep,l_checkHeadField,l_checkBodyField,l_checkHeadData,l_checkBodyData)
DEFINE l_sep      STRING,
       l_checkHeadField    STRING,
       l_checkHeadData     STRING,
       l_errCode  STRING,
       l_errDesc  STRING,
       l_misc     STRING
DEFINE l_imzacti  LIKE imz_file.imzacti
DEFINE count1               SMALLINT
 
DEFINE l_checkBodyField  DYNAMIC ARRAY OF RECORD
                          FIELD STRING
                         END RECORD,
        l_checkBodyData  DYNAMIC ARRAY OF RECORD
                          DATA  STRING
                          END RECORD
 
DEFINE tok base.StringTokenizer  
 
 
  INITIALIZE g_ima.* LIKE ima_file.*
  LET g_ima01_t = NULL
  LET g_ima_o.*=g_ima.* 
  LET l_ignore = 'N'
  LET l_errCode=NULL
  LET l_errDesc=NULL
  #CALL ima_default()
  #對單頭的解析將值存入g_ima中
  LET head1 = l_checkHeadField
  LET tok = base.StringTokenizer.createExt(head1,l_sep,"",TRUE)
  LET count1 = tok.countTokens() 
  WHILE tok.hasMoreTokens()
     LET i = tok.countTokens()
     LET head2[i] = tok.nextToken()
  END WHILE      
  LET head1 = l_checkHeadData
  LET tok = base.StringTokenizer.createExt(head1,l_sep,"",TRUE)
  WHILE tok.hasMoreTokens()
     LET i = tok.countTokens()
     LET value2[i] = tok.nextToken()
  END WHILE
 
  FOR i=1 TO count1 
     CASE head2[i]
        WHEN "ima01"
           LET g_ima.ima01=value2[i]
        WHEN "ima02"
           LET g_ima.ima02=value2[i]
        WHEN "ima021"
           LET g_ima.ima021=value2[i]
        WHEN "ima06"
           LET g_ima.ima06=value2[i]
        WHEN "ima18"
           LET g_ima.ima18=value2[i]
  ##NO.FUN-A20044   --begin
#       WHEN "ima26"
#          LET g_ima.ima26=value2[i]
#       WHEN "ima261"
#          LET g_ima.ima261=value2[i]
#       WHEN "ima262"
#          LET g_ima.ima262=value2[i]
  ##NO.FUN-A20044   --end 
        WHEN "imauser"
          LET g_ima.imauser=value2[i]
        WHEN "imagrup"
           LET g_ima.imagrup=value2[i]
        WHEN "imamodu"
           LET g_ima.imamodu=value2[i]
        WHEN "imadate"
           LET g_ima.imadate=value2[i]
        WHEN "imaacti"
           LET g_ima.imaacti=value2[i]
        WHEN "ima08"
           LET g_ima.ima08=value2[i]
        WHEN "ima13"
           LET g_ima.ima13=value2[i]
        WHEN "ima14"
           LET g_ima.ima14=value2[i]
        WHEN "ima903"
           LET g_ima.ima903=value2[i]
        WHEN "ima15"
           LET g_ima.ima15=value2[i]
        WHEN "ima109"
           LET g_ima.ima109=value2[i]
        WHEN "ima105"
           LET g_ima.ima105=value2[i]
        WHEN "ima70"
           LET g_ima.ima70=value2[i]
        WHEN "ima09"
           LET g_ima.ima09=value2[i]
        WHEN "ima10"
           LET g_ima.ima10=value2[i]
        WHEN "ima11"
           LET g_ima.ima11=value2[i]
        WHEN "ima12"
           LET g_ima.ima12=value2[i]
        WHEN "ima25"
           LET g_ima.ima25=value2[i]
        WHEN "ima35"
           LET g_ima.ima35=value2[i]
        WHEN "ima36"
           LET g_ima.ima36=value2[i]
        WHEN "ima23"
           LET g_ima.ima23=value2[i]
        WHEN "ima07"
           LET g_ima.ima07=value2[i]
        WHEN "ima39"
           LET g_ima.ima39=value2[i]
     END CASE
  END FOR 
 
  #ima01不能為空不能重復
  IF NOT cl_null(g_ima.ima01) THEN
    SELECT count(*) INTO l_n FROM ima_file
     WHERE ima01 = g_ima.ima01
     IF l_n > 0 THEN      
        #CALL cl_err(g_ima.ima01,-239,0)
        LET l_errCode='aws-211'
        CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'-239',"物料("||g_ima.ima01||")在系統中已經存在")
        RETURNING l_errDesc
        RETURN l_errCode,l_errDesc 
     END IF
     LET g_ima.ima571=g_ima.ima01
     LET g_ima.ima133=g_ima.ima01
  END IF
 
 
  #對分群碼的管控，且由分群碼帶出相關字段的值
  IF g_ima.ima06 IS NOT NULL AND  g_ima.ima06 != ' '  THEN
     SELECT imzacti INTO l_imzacti
      FROM imz_file
     WHERE imz01 = g_ima.ima06    
    CASE 
         WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3179'
         WHEN l_imzacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
  END IF
  IF cl_null(g_ima.ima06) OR (g_ima.ima06 = '%%') OR (g_ima.ima06='%') THEN LET g_errno = 'mfg3179' END IF 
  IF NOT cl_null(g_errno) THEN
     LET l_errCode='aws-211'
     CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,g_errno,
          "物料("||g_ima.ima01||")主分群碼("||g_ima.ima06 CLIPPED||")為空或不存在")
     RETURNING l_errDesc
     RETURN l_errCode,l_errDesc 
  END IF
 
  #對ima08的管控
  IF NOT cl_null(g_ima.ima08) THEN 
     IF g_ima.ima08 NOT MATCHES "[CTDAMPXKUVZS]" 
                    OR g_ima.ima08 IS NULL 
     THEN 
        LET l_errCode='mfg1001'
        CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1001',
             "物料("||g_ima.ima01||")來源碼("||g_ima.ima08||")錯誤,"||aws_getErrorInfo('mfg1001'))
        RETURNING l_errDesc
        RETURN l_errCode,l_errDesc
     END IF
     #NO:6808(養生)
     LET l_misc=g_ima.ima01[1,4]     
     IF l_misc='MISC' AND g_ima.ima08 <>'Z' THEN
        LET l_errCode='aim-805'
        CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'aim-805',
             "物料("||g_ima.ima01||")來源碼("||g_ima.ima08||")錯誤,"||aws_getErrorInfo('aim-805'))
        RETURNING l_errDesc
        RETURN l_errCode,l_errDesc
     END IF
   END IF
            
   #對ima13的管控
   IF NOT cl_null(g_ima.ima13) THEN
      IF (g_ima.ima08 = 'T') AND (g_ima.ima13 IS NULL 
                         OR g_ima.ima13 = ' ' )
      THEN #CALL cl_err(g_ima.ima13,'mfg1327',0)
         LET l_errCode='mfg1327'
         CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1327',
             "物料("||g_ima.ima01||")規格組件料件編號(ima13)欄位,"||aws_getErrorInfo('mfg1327'))
         RETURNING l_errDesc
         RETURN l_errCode,l_errDesc
      END IF
      IF g_ima.ima18 IS NOT NULL 
      THEN IF (g_ima_o.ima13 IS NULL ) OR (g_ima_o.ima13 != g_ima.ima13)
         THEN SELECT ima08 FROM ima_file 
                   WHERE ima01 = g_ima.ima13
                     AND ima08 matches 'C'     
                     AND imaacti matches'[Yy]'
            IF SQLCA.sqlcode != 0 THEN 
               LET l_errCode='mfg1328'
               CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1328',
                   "物料("||g_ima.ima01||")規格組件料件編號(ima13)欄位,"||aws_getErrorInfo('mfg1328'))
               RETURNING l_errDesc
               RETURN l_errCode,l_errDesc
            END IF
         END IF
      END IF
   END IF
           
          #對ima14#工程料件的管控
   IF NOT cl_null(g_ima.ima14) THEN
      IF g_ima.ima14 NOT MATCHES "[YN]" THEN
         LET l_errCode='aws-211'
         CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1002',
                       "物料("||g_ima.ima01||")是否為工程料件(ima14)欄位,值("||g_ima.ima14||"),"||aws_getErrorInfo('mfg1002'))
         RETURNING l_errDesc
         RETURN l_errCode,l_errDesc
      END IF
   END IF
            
            #對ima903的管控可否做聯產品入庫
   IF NOT cl_null(g_ima.ima903) THEN
      IF g_ima.ima903 NOT MATCHES "[YN]" THEN
         LET l_errCode='aws-211'
         CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1002',
                       "物料("||g_ima.ima01||")是否作聯產品入庫(ima903)欄位,值("||g_ima.ima903||"),"||aws_getErrorInfo('mfg1002'))
         RETURNING l_errDesc
         RETURN l_errCode,l_errDesc
      END IF
   END IF
            
            #對ima24的 #檢驗否 管控缺
            #對ima107，ima147的管控缺
            #對ima15的#保稅料件管控
   IF NOT cl_null(g_ima.ima15) THEN
      IF g_ima.ima15 NOT MATCHES "[YN]" THEN
         #CALL cl_err(g_ima.ima15,'mfg1002',0)
         LET l_errCode='aws-211'
         CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1002',
                       "物料("||g_ima.ima01||")是否保稅(ima15)欄位,值("||g_ima.ima15||"),"||aws_getErrorInfo('mfg1002'))
         RETURNING l_errDesc
         RETURN l_errCode,l_errDesc
      END IF
   END IF         
           
           #對ima109的管控
   IF NOT cl_null(g_ima.ima109) THEN
      IF (g_ima_o.ima109 IS NULL) OR (g_ima.ima109 != g_ima_o.ima109)
         THEN SELECT azf01 FROM azf_file 
               WHERE azf01=g_ima.ima109 AND azf02='8'
                 AND azfacti='Y'
         IF SQLCA.sqlcode  THEN
            LET l_errCode='mfg1306'
            CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1306',
                       "物料("||g_ima.ima01||")材料類型("||g_ima.ima05||")在系統中未定義")
            RETURNING l_errDesc
            RETURN l_errCode,l_errDesc
         END IF
      END IF
   END IF
            
            #對ima105的管控
   IF NOT cl_null(g_ima.ima105) THEN
      IF g_ima.ima105 NOT MATCHES "[YN]" THEN
         LET l_errCode='aws-211'
         CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1002',
                       "物料("||g_ima.ima01||")是否為軟件對象(ima105)欄位,值("||g_ima.ima105||"),"||aws_getErrorInfo('mfg1002'))
         RETURNING l_errDesc
         RETURN l_errCode,l_errDesc
      END IF
   END IF
            
            #對ima70的管控
   IF NOT cl_null(g_ima.ima70) THEN 
      IF g_ima.ima70 NOT MATCHES '[YN]' THEN
         LET l_errCode='aws-211'
         CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1002',
                       "物料("||g_ima.ima01||")是否為消耗料件(ima70)欄位,值("||g_ima.ima70||"),"||aws_getErrorInfo('mfg1002'))
         RETURNING l_errDesc
         RETURN l_errCode,l_errDesc
      END IF
   END IF
               
            #對ima09的管控#其他分群碼一
   IF g_ima.ima09 IS NOT NULL AND g_ima.ima09 != ' ' THEN
      SELECT azf01 FROM azf_file 
       WHERE azf01=g_ima.ima09 AND azf02='D' #6818
         AND azfacti='Y'
      IF SQLCA.sqlcode  THEN
         #CALL cl_err(g_ima.ima09,'mfg1306',0)
         LET l_errCode='aws-211'
         CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1306',
                       "物料("||g_ima.ima01||")其他分群碼一("||g_ima.ima09||")在系統中未定義")
         RETURNING l_errDesc
         RETURN l_errCode,l_errDesc
      END IF
   END IF
           
           #對ima10的管控#其他分群碼二
   IF g_ima.ima10 IS NOT NULL AND g_ima.ima10 != ' ' THEN
      SELECT azf01 FROM azf_file 
       WHERE azf01=g_ima.ima10 AND azf02='E' #6818
         AND azfacti='Y'
      IF SQLCA.sqlcode  THEN
         LET l_errCode='aws-211'
         CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1306',
                       "物料("||g_ima.ima01||")其他分群碼二("||g_ima.ima10||")在系統中未定義")
         RETURNING l_errDesc
         RETURN l_errCode,l_errDesc
      END IF
   END IF
           
           #對ima11的管控其他分群碼三
   IF g_ima.ima11 IS NOT NULL AND g_ima.ima11 != ' ' THEN
      SELECT azf01 FROM azf_file 
       WHERE azf01=g_ima.ima11 AND azf02='F' #6818
         AND azfacti='Y'
      IF SQLCA.sqlcode  THEN
         #CALL cl_err(g_ima.ima11,'mfg1306',0)
         LET l_errCode='aws-211'
         CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1306',
                       "物料("||g_ima.ima01||")其他分群碼三("||g_ima.ima11||")在系統中未定義")         
         RETURNING l_errDesc
         RETURN l_errCode,l_errDesc
      END IF
   END IF
            
            #對ima12的管控#其他分群碼四
   IF g_ima.ima12 IS NOT NULL AND g_ima.ima12 != ' ' THEN
      SELECT azf01 FROM azf_file 
       WHERE azf01=g_ima.ima12 AND azf02='G' #6818
         AND azfacti='Y'
       IF SQLCA.sqlcode  THEN
          #CALL cl_err(g_ima.ima12,'mfg1306',0)
          LET l_errCode='aws-211'
          CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1306',
                       "物料("||g_ima.ima01||")其他分群碼四("||g_ima.ima12||")在系統中未定義")          
          RETURNING l_errDesc
          RETURN l_errCode,l_errDesc
       END IF
    END IF
      
      #對ima25的判斷庫存單位
    IF NOT cl_null(g_ima.ima25) THEN
       SELECT gfe01 FROM gfe_file 
        WHERE gfe01=g_ima.ima25 
         AND (gfeacti='Y' OR gfeacti = 'y')
       IF SQLCA.sqlcode THEN 
          LET l_errCode='aws-211'
          CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1200',
                       "物料("||g_ima.ima01||")庫存單位("||g_ima.ima25||")在系統中未定義")          
          RETURNING l_errDesc
          RETURN l_errCode,l_errDesc
       END IF
    END IF
            
    #對ima35的管控
    IF g_ima.ima35 !=' ' AND g_ima.ima35 IS NOT NULL THEN
       SELECT * FROM imd_file WHERE imd01=g_ima.ima35 AND imdacti='Y'
       IF SQLCA.SQLCODE THEN 
          #CALL cl_err(g_ima.ima35,'mfg1100',0)
          LET l_errCode='aws-211'
          CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1100',
                       "物料("||g_ima.ima01||")主要倉庫("||g_ima.ima35||")在系統中未定義或性質不符")          
          RETURNING l_errDesc
          RETURN l_errCode,l_errDesc
       END IF
    END IF 
          
          #對ima36的管控
    IF g_ima.ima36 !=' ' AND g_ima.ima36 IS NOT NULL THEN
       SELECT * FROM ime_file WHERE ime01=g_ima.ima35 
          AND ime02=g_ima.ima36
          AND imeacti = 'Y'     #FUN-D40103
       IF SQLCA.SQLCODE THEN 
          LET l_errCode='aws-211'
          CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1101',
                       "物料("||g_ima.ima01||")主要庫位("||g_ima.ima36||")在系統中未定義")          
          RETURNING l_errDesc
          RETURN l_errCode,l_errDesc
       END IF
    END IF
  
             #對ima23的管控
    IF NOT cl_null(g_ima.ima23) THEN
       LET g_gen02 = ""                     
       SELECT gen02 INTO g_gen02 FROM gen_file  #BUG-4A0326
        WHERE gen01=g_ima.ima23
          AND genacti='Y'
       IF SQLCA.SQLCODE THEN 
          LET l_errCode='aws-211'
          CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'aoo-001',
                       "物料("||g_ima.ima01||")倉管員("||g_ima.ima23||")在系統中未定義")          
          RETURNING l_errDesc
          RETURN l_errCode,l_errDesc
       END IF
    END IF
             
             
           #對ima07的管控#ABC 碼
    IF NOT cl_null(g_ima.ima07) THEN
       IF g_ima.ima07 NOT MATCHES'[ABC]' THEN
          #CALL cl_err(g_ima.ima07,'mfg0009',0)
          LET l_errCode='aws-211'
          CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg0009',
                       "物料("||g_ima.ima01||")ABC碼("||g_ima.ima07||")的值不在[ABC]范圍內")          
          RETURNING l_errDesc
          RETURN l_errCode,l_errDesc
       END IF
    END IF
           
           #對ima37的管控缺
           #對ima51>0ima52>0的控制缺
           #對ima39的管控
    IF NOT cl_null(g_ima.ima39) OR g_ima.ima39 != ' '  THEN 
       SELECT count(*) INTO l_n FROM aag_file 
        WHERE aag01 = g_ima.ima39   
          AND aag07 != '1'  #No:8400 #BUG-490065將aag071改為aag07
       IF l_n=0 THEN     # Unique 
          #CALL cl_err(g_ima.ima39,100,0)
          LET l_errCode='aws-211'
          CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'100',
                        "物料("||g_ima.ima01||")所屬會計科目("||g_ima.ima39||")在系統中未定義")          
          RETURNING l_errDesc
          RETURN l_errCode,l_errDesc
       END IF
    END IF
           
RETURN l_errCode,l_errDesc 
    
END FUNCTION
#******************************************************************************************************
FUNCTION AfterInsertItem(l_sep,l_checkHeadField,l_checkBodyField,l_checkHeadData,l_checkBodyData)
DEFINE l_sep      STRING,
       l_checkHeadField    STRING,
       l_checkHeadData     STRING,
       l_errCode  STRING,
       l_errDesc  STRING
DEFINE count1               SMALLINT
 
DEFINE l_checkBodyField  DYNAMIC ARRAY OF RECORD
                          FILED STRING
                         END RECORD,
        l_checkBodyData  DYNAMIC ARRAY OF RECORD
                          DATA  STRING,
                          ignore STRING,
                          sucess STRING
                          END RECORD
DEFINE tok base.StringTokenizer  
DEFINE l_cmd  STRING
 
 
   INITIALIZE g_ima.* LIKE ima_file.*
   LET g_ima01_t = NULL
   LET g_ima_o.*=g_ima.* 
   LET l_errCode = NULL
   LET l_errDesc = NULL
   CALL ima_default()
   LET head1 = l_checkHeadField
   LET tok = base.StringTokenizer.createExt(head1,l_sep,"",TRUE)
   LET count1 = tok.countTokens() 
   WHILE tok.hasMoreTokens()
      LET i = tok.countTokens()
      LET head2[i] = tok.nextToken()
   END WHILE      
   LET head1 = l_checkHeadData
   LET tok = base.StringTokenizer.createExt(head1,l_sep,"",TRUE)
   WHILE tok.hasMoreTokens()
      LET i = tok.countTokens()
      LET value2[i] = tok.nextToken()
   END WHILE
 
 FOR i=1 TO count1 
    CASE head2[i]
       WHEN "ima01"
          LET g_ima.ima01=value2[i]
       WHEN "ima02"
          LET g_ima.ima02=value2[i]
       WHEN "ima021"
          LET g_ima.ima021=value2[i]
       WHEN "ima06"
          LET g_ima.ima06=value2[i]
       WHEN "ima18"
          LET g_ima.ima18=value2[i]
       WHEN "ima25"
          LET g_ima.ima25=value2[i]
  ##NO.FUN-A20044   --begin
#      WHEN "ima26"
#         LET g_ima.ima26=value2[i]
#      WHEN "ima261"
#         LET g_ima.ima261=value2[i]
#      WHEN "ima262"
#         LET g_ima.ima262=value2[i] 
  ##NO.FUN-A20044   --end
       WHEN "imauser"
          LET g_ima.imauser=value2[i]
       WHEN "imagrup"
          LET g_ima.imagrup=value2[i]
       WHEN "imamodu"
          LET g_ima.imamodu=value2[i]
       WHEN "imadate"
          LET g_ima.imadate=value2[i]
       WHEN "imaacti"
          LET g_ima.imaacti=value2[i]
       WHEN "ima08"
          LET g_ima.ima08=value2[i]
       WHEN "ima13"
          LET g_ima.ima13=value2[i]
       WHEN "ima14"
          LET g_ima.ima14=value2[i]
       WHEN "ima903"
          LET g_ima.ima903=value2[i]
       WHEN "ima15"
          LET g_ima.ima15=value2[i]
       WHEN "ima109"
          LET g_ima.ima109=value2[i]
       WHEN "ima105"
          LET g_ima.ima105=value2[i]
       WHEN "ima70"
          LET g_ima.ima70=value2[i]
       WHEN "ima09"
          LET g_ima.ima09=value2[i]
       WHEN "ima10"
          LET g_ima.ima10=value2[i]
       WHEN "ima11"
          LET g_ima.ima11=value2[i]
       WHEN "ima12"
          LET g_ima.ima12=value2[i]
       WHEN "ima25"
          LET g_ima.ima25=value2[i]
       WHEN "ima35"
          LET g_ima.ima35=value2[i]
       WHEN "ima36"
          LET g_ima.ima36=value2[i]
       WHEN "ima23"
          LET g_ima.ima23=value2[i]
       WHEN "ima07"
          LET g_ima.ima07=value2[i]
       WHEN "ima39"
          LET g_ima.ima39=value2[i]
#Add By Ryta 20070928
       WHEN "ima915"
          LET g_ima.ima915=value2[i]
#End Add
    END CASE
 END FOR 
 
#Add By Ryta 20070928
   LET g_ima.ima915='0'
  ##NO.FUN-A20044   --begin
#  LET g_ima.ima26=0
#  LET g_ima.ima261=0
#  LET g_ima.ima262=0
  ##NO.FUN-A20044   --end
#End Add
 
   IF NOT cl_null(g_ima.ima01) THEN
      LET g_ima.ima571=g_ima.ima01
      LET g_ima.ima133=g_ima.ima01
   END IF 
   
   IF g_ima.ima06!='S01' THEN        #add by bugbin for ck-telecom only  xike
      LET g_ima.ima06='S01'
   END IF 
   IF NOT cl_null(g_ima.ima06) THEN
      CALL aimi100_ima06('Y') 
   END IF 
   
   IF cl_null(g_ima.ima25) THEN        #add by bugbin for ck-telecom only  xike
      LET g_ima.ima25='PCS'
   END IF 
   IF g_ima.ima31 IS NULL THEN 
     LET g_ima.ima31=g_ima.ima25 
     LET g_ima.ima31_fac=1
  END IF
       
  IF g_ima.ima133 IS NULL THEN LET g_ima.ima133 = g_ima.ima01 END IF
  IF g_ima.ima571 IS NULL THEN LET g_ima.ima571 = g_ima.ima01 END IF
#  IF g_ima.ima44 IS NULL OR g_ima.ima44=' ' THEN
     LET g_ima.ima44=g_ima.ima25   #采購單位
     LET g_ima.ima44_fac=1
#  END IF
#  IF g_ima.ima55 IS NULL OR g_ima.ima55=' ' THEN 
     LET g_ima.ima55=g_ima.ima25   #生產單位
     LET g_ima.ima55_fac=1
#  END IF
#  IF g_ima.ima63 IS NULL OR g_ima.ima63=' ' THEN 
     LET g_ima.ima63=g_ima.ima25   #發料單位
     LET g_ima.ima63_fac=1
#  END IF
  LET g_ima.ima86=g_ima.ima25   #庫存單位=成本單位
  LET g_ima.ima86_fac=1
 
  IF g_ima.ima35 IS NULL THEN
     LET g_ima.ima35=' ' #No:7726
  END IF  
  IF g_ima.ima36 IS NULL THEN
     LET g_ima.ima36=' ' #No:7726
  END IF
#  LET l_cmd = 'echo "',g_ima.ima25 CLIPPED,'" > /u1/out/wlj.sql'
#          RUN l_cmd
   UPDATE ima_file SET *=g_ima.*
    WHERE ima01=g_ima.ima01       # DISK WRITE
  IF SQLCA.SQLCODE THEN
     #CALL cl_err(g_ima.ima01,SQLCA.sqlcode,1)
        LET l_errCode='aws-211'
        CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,SQLCA.SQLCODE,"在填充料件("||g_ima.ima01||")的默認信息時出現錯誤")
        RETURNING l_errDesc
        RETURN l_errCode,l_errDesc
  ELSE RETURN l_errCode,l_errDesc
  END IF
 
END FUNCTION
 
#******************************************************************************************************
FUNCTION aimi100_ima06(p_def) #BUG-490474
   DEFINE     
               p_def          VARCHAR(01), #BUG-490474
               l_ans          VARCHAR(01), 
               l_msg          VARCHAR(57),
               l_ima25        LIKE ima_file.ima25,
               l_imz02        LIKE imz_file.imz02,  
               l_imzacti      LIKE imz_file.imzacti,
               l_imaacti      LIKE ima_file.imaacti,
               l_imauser      LIKE ima_file.imauser,
               l_imagrup      LIKE ima_file.imagrup,
               l_imamodu      LIKE ima_file.imamodu,
               l_imadate      LIKE ima_file.imadate
 
   LET g_errno = ' '
   LET l_ans=' '
    SELECT imzacti INTO l_imzacti
      FROM imz_file
     WHERE imz01 = g_ima.ima06    
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3179'
         WHEN l_imzacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
          SELECT *  INTO g_ima.ima06,l_imz02,g_ima.ima03,g_ima.ima04, 
                      g_ima.ima07,g_ima.ima08,g_ima.ima09,g_ima.ima10,  
                      g_ima.ima11,g_ima.ima12,g_ima.ima14,g_ima.ima15,
                      g_ima.ima17,g_ima.ima19,g_ima.ima21,
                      g_ima.ima23,g_ima.ima24,l_ima25,g_ima.ima27, #No:7703 add ima24
                      g_ima.ima28,g_ima.ima31,g_ima.ima31_fac,g_ima.ima34,
                      g_ima.ima35,g_ima.ima36,g_ima.ima37,g_ima.ima38,
                      g_ima.ima39,g_ima.ima42,g_ima.ima43,g_ima.ima44,
                      g_ima.ima44_fac,g_ima.ima45,g_ima.ima46,g_ima.ima47,
                      g_ima.ima48,g_ima.ima49,g_ima.ima491,g_ima.ima50,
                      g_ima.ima51,g_ima.ima52,g_ima.ima54,g_ima.ima55,
                      g_ima.ima55_fac,g_ima.ima56,g_ima.ima561,g_ima.ima562,
                      g_ima.ima571,
                      g_ima.ima59, g_ima.ima60,g_ima.ima61,g_ima.ima62,
                      g_ima.ima63, g_ima.ima63_fac,g_ima.ima64,g_ima.ima641,
                      g_ima.ima65, g_ima.ima66,g_ima.ima67,g_ima.ima68,
                      g_ima.ima69, g_ima.ima70,g_ima.ima71,g_ima.ima86,
                      g_ima.ima86_fac,g_ima.ima87,g_ima.ima871,g_ima.ima872,
                      g_ima.ima873, g_ima.ima874,g_ima.ima88,g_ima.ima89,
                      g_ima.ima90,g_ima.ima94,g_ima.ima99,g_ima.ima100,     #NO:6842養生
                      g_ima.ima101,g_ima.ima102,g_ima.ima103,g_ima.ima105,  #NO:6842養生
                      g_ima.ima106,g_ima.ima107,g_ima.ima108,g_ima.ima109,  #NO:6842養生
                      g_ima.ima110,g_ima.ima130,g_ima.ima131,g_ima.ima132,  #NO:6842養生
                      g_ima.ima133,g_ima.ima134,                            #NO:6842養生
                      g_ima.ima147,g_ima.ima148,g_ima.ima903,
                      l_imaacti,l_imauser,l_imagrup,l_imamodu,l_imadate,
                      g_ima.ima906,g_ima.ima907,g_ima.ima908,g_ima.ima909,
                      g_ima.ima911,g_ima.ima136,g_ima.ima137,
                      g_ima.ima391,g_ima.ima1321,
                     {g_ima.imaida001,g_ima.imaida002,
                      g_ima.imaida003,g_ima.imaida004,g_ima.imaida005,g_ima.imaida006,
                      g_ima.imaida007,g_ima.imaida008,
                      g_ima.imaida009,g_ima.imaida010,g_ima.imaida011,g_ima.imaida012,
                      g_ima.imaida013,g_ima.imaida014,g_ima.imaida015,g_ima.imaida016,
                      g_ima.imaida017,g_ima.imaida018,
                      g_ima.imaida019,g_ima.imaida020,g_ima.imaidb001,g_ima.imaidb002,
                      g_ima.imaidb003,g_ima.imaidb004,g_ima.imaidb005,
                      g_ima.imaidb006,g_ima.imaidb007,g_ima.imaidb008,
                      g_ima.imaidb009,g_ima.imaidb010,g_ima.imaidc001,
                      g_ima.imaidc002,g_ima.imaidc003,g_ima.imaidc004,
                      g_ima.imaidc005,g_ima.imaidc006,g_ima.imaidc007,g_ima.imaidc008,
                      g_ima.imaidc009,g_ima.imaidc010,g_ima.imaidd001,
                      g_ima.imaidd002,g_ima.imaidd003,g_ima.imaidd004,
                      g_ima.imaidd005,g_ima.imaidd006,g_ima.imaidd007,g_ima.imaidd008,
                      g_ima.imaidd009,g_ima.imaidd010,g_ima.imaide001,
                      g_ima.imaide002,g_ima.imaide003,g_ima.imaide004,
                      g_ima.imaide005,g_ima.imaide006,g_ima.imaide007,g_ima.imaide008,
                      g_ima.imaide009,g_ima.imaide010,g_ima.imaidf001,
                      g_ima.imaidf002,g_ima.imaidf003,g_ima.imaidf004,
                      g_ima.imaidf005,g_ima.imaidg001,g_ima.imaidg002,g_ima.imaidg003,
                      g_ima.imaidg004,g_ima.imaidg005,}
                      g_ima.ima72
                 FROM  imz_file
                 WHERE imz01 = g_ima.ima06    
       IF g_ima.ima99 IS NULL THEN LET g_ima.ima99 = 0 END IF
       IF g_ima.ima133 IS NULL THEN LET g_ima.ima133 = g_ima.ima01 END IF
       IF g_ima.ima01[1,4]='MISC' THEN #NO:6808(養生)
          LET g_ima.ima08='Z'
       END IF
       IF cl_null(g_ima.ima25) THEN LET g_ima.ima25 = l_ima25 END IF 
       LET g_ima.ima31 = g_ima.ima25 LET g_ima.ima31_fac = 1 
       LET g_ima.ima44 = g_ima.ima25 LET g_ima.ima44_fac = 1  
       LET g_ima.ima55 = g_ima.ima25 LET g_ima.ima55_fac = 1 
       LET g_ima.ima63 = g_ima.ima25 LET g_ima.ima63_fac = 1  
       LET g_ima.ima86 = g_ima.ima25 LET g_ima.ima86_fac = 1  
END FUNCTION 
 
 
 
#*******************************************************************************************************
FUNCTION ima_default()
   LET g_ima.ima07 = 'A'
   LET g_ima.ima08 = 'P'
   LET g_ima.ima108 = 'N'
   LET g_ima.ima14 = 'N'
   LET g_ima.ima903= 'N' #NO:6872
   LET g_ima.ima905= 'N'
   LET g_ima.ima15 = 'N'
   LET g_ima.ima16 = 99
   LET g_ima.ima18 = 0
   LET g_ima.ima09 =' '
   LET g_ima.ima10 =' '
   LET g_ima.ima11 =' '
   LET g_ima.ima12 =' '
   LET g_ima.ima23 = ' '
   LET g_ima.ima24 = 'N'
  ##NO.FUN-A20044   --begin
#  LET g_ima.ima26 = 0
#  LET g_ima.ima261 = 0
#  LET g_ima.ima262 = 0
  ##NO.FUN-A20044   --end
   LET g_ima.ima27 = 0
   LET g_ima.ima271 = 0
   LET g_ima.ima28 = 0
   LET g_ima.ima30 = g_today #No:7643 新增 aimi100料號時應default ima30=料件建立日期,以便循環盤點機制
   LET g_ima.ima31_fac = 1
   LET g_ima.ima32 = 0
   LET g_ima.ima33 = 0
   LET g_ima.ima37 = '0'
   LET g_ima.ima38 = 0
   LET g_ima.ima40 = 0
   LET g_ima.ima41 = 0
   LET g_ima.ima42 = '0'
   LET g_ima.ima44_fac = 1
   LET g_ima.ima45 = 0
   LET g_ima.ima46 = 0
   LET g_ima.ima47 = 0
   LET g_ima.ima48 = 0
   LET g_ima.ima49 = 0
   LET g_ima.ima491 = 0
   LET g_ima.ima50 = 0
   LET g_ima.ima51 = 1
   LET g_ima.ima52 = 1
   LET g_ima.ima140 = 'N'
   LET g_ima.ima53 = 0
   LET g_ima.ima531 = 0
   LET g_ima.ima55_fac = 1
   LET g_ima.ima56 = 1
   LET g_ima.ima561 = 1  #最少生產數量
   LET g_ima.ima562 = 0  #生產時損耗率
   LET g_ima.ima57 = 0
   LET g_ima.ima58 = 0
   LET g_ima.ima59 = 0
   LET g_ima.ima60 = 0
   LET g_ima.ima61 = 0
   LET g_ima.ima62 = 0
   LET g_ima.ima63_fac = 1
   LET g_ima.ima64 = 1
   LET g_ima.ima641 = 1   #最少發料數量
   LET g_ima.ima65 = 0
   LET g_ima.ima66 = 0
   LET g_ima.ima68 = 0
   LET g_ima.ima69 = 0
   LET g_ima.ima70 = 'N'
   LET g_ima.ima107= 'N'
   LET g_ima.ima147= 'N' #BugNo:6542 add ima147
   LET g_ima.ima71 = 0
   LET g_ima.ima72 = 0
   LET g_ima.ima75 = ''
   LET g_ima.ima76 = ''
   LET g_ima.ima77 = 0
   LET g_ima.ima78 = 0
   LET g_ima.ima79 = 0
   LET g_ima.ima80 = 0
   LET g_ima.ima81 = 0
   LET g_ima.ima82 = 0
   LET g_ima.ima83 = 0
   LET g_ima.ima84 = 0
   LET g_ima.ima85 = 0
   LET g_ima.ima852= 'N'
   LET g_ima.ima853= 'N'
   LET g_ima.ima86_fac = 1
   LET g_ima.ima871 = 0
   LET g_ima.ima873 = 0
   LET g_ima.ima88 = 1
   LET g_ima.ima91 = 0
   LET g_ima.ima92 = 'N'
   LET g_ima.ima93 = "NNNNNNNN"
   LET g_ima.ima94 = ''
   LET g_ima.ima95 = 0
   LET g_ima.ima96 = 0
   LET g_ima.ima97 = 0
   LET g_ima.ima98 = 0
   LET g_ima.ima99 = 0
   LET g_ima.ima100 = 'N'
   LET g_ima.ima101 = '1'
   LET g_ima.ima102 = '2'
   LET g_ima.ima103 = '0'
   LET g_ima.ima104 = 0
   LET g_ima.ima105 = 'N'
   LET g_ima.ima110 = '1'
   LET g_ima.ima139 = 'N'
   LET g_ima.imaacti ='Y'                   #有效的資料
   LET g_ima.imauser = g_user
   LET g_ima.imaoriu = g_user #FUN-980030
   LET g_ima.imaorig = g_grup #FUN-980030
   LET g_ima.imagrup = g_grup               #使用者所屬群
   LET g_ima.imadate = g_today
   LET g_ima.ima901 = g_today               #料件建檔日期
   #產品資料
   LET g_ima.ima130 = '1'
   LET g_ima.ima121 = 0
   LET g_ima.ima122 = 0
   LET g_ima.ima123 = 0
   LET g_ima.ima124 = 0
   LET g_ima.ima125 = 0
   LET g_ima.ima126 = 0
   LET g_ima.ima127 = 0
   LET g_ima.ima128 = 0
   LET g_ima.ima129 = 0
   LET g_ima.ima141 = '0'
END FUNCTION
#*********************************************************************************************************************
FUNCTION aim_ima06(p_def) #BUG-490474
   DEFINE     
               p_def          VARCHAR(01), #BUG-490474
               l_ans          VARCHAR(01), 
               l_msg          VARCHAR(57),
               l_imz02        LIKE imz_file.imz02,  
               l_imzacti      LIKE imz_file.imzacti,
               l_imaacti      LIKE ima_file.imaacti,
               l_imauser      LIKE ima_file.imauser,
               l_imagrup      LIKE ima_file.imagrup,
               l_imamodu      LIKE ima_file.imamodu,
               l_imadate      LIKE ima_file.imadate
 
   LET g_errno = ' '
   LET l_ans=' '
    SELECT imzacti INTO l_imzacti
      FROM imz_file
     WHERE imz01 = g_ima.ima06    
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3179'
         WHEN l_imzacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
          SELECT *  INTO g_ima.ima06,l_imz02,g_ima.ima03,g_ima.ima04, 
                      g_ima.ima07,g_ima.ima08,g_ima.ima09,g_ima.ima10,  
                      g_ima.ima11,g_ima.ima12,g_ima.ima14,g_ima.ima15,
                      g_ima.ima17,g_ima.ima19,g_ima.ima21,
                      g_ima.ima23,g_ima.ima24,g_ima.ima25,g_ima.ima27, #No:7703 add ima24
                      g_ima.ima28,g_ima.ima31,g_ima.ima31_fac,g_ima.ima34,
                      g_ima.ima35,g_ima.ima36,g_ima.ima37,g_ima.ima38,
                      g_ima.ima39,g_ima.ima42,g_ima.ima43,g_ima.ima44,
                      g_ima.ima44_fac,g_ima.ima45,g_ima.ima46,g_ima.ima47,
                      g_ima.ima48,g_ima.ima49,g_ima.ima491,g_ima.ima50,
                      g_ima.ima51,g_ima.ima52,g_ima.ima54,g_ima.ima55,
                      g_ima.ima55_fac,g_ima.ima56,g_ima.ima561,g_ima.ima562,
                      g_ima.ima571,
                      g_ima.ima59, g_ima.ima60,g_ima.ima61,g_ima.ima62,
                      g_ima.ima63, g_ima.ima63_fac,g_ima.ima64,g_ima.ima641,
                      g_ima.ima65, g_ima.ima66,g_ima.ima67,g_ima.ima68,
                      g_ima.ima69, g_ima.ima70,g_ima.ima71,g_ima.ima86,
                      g_ima.ima86_fac,g_ima.ima87,g_ima.ima871,g_ima.ima872,
                      g_ima.ima873, g_ima.ima874,g_ima.ima88,g_ima.ima89,
                      g_ima.ima90,g_ima.ima94,g_ima.ima99,g_ima.ima100,     #NO:6842養生
                      g_ima.ima101,g_ima.ima102,g_ima.ima103,g_ima.ima105,  #NO:6842養生
                      g_ima.ima106,g_ima.ima107,g_ima.ima108,g_ima.ima109,  #NO:6842養生
                      g_ima.ima110,g_ima.ima130,g_ima.ima131,g_ima.ima132,  #NO:6842養生
                      g_ima.ima133,g_ima.ima134,                            #NO:6842養生
                      g_ima.ima147,g_ima.ima148,g_ima.ima903,
                      l_imaacti,l_imauser,l_imagrup,l_imamodu,l_imadate
                 FROM  imz_file
                 WHERE imz01 = g_ima.ima06    
       IF g_ima.ima99 IS NULL THEN LET g_ima.ima99 = 0 END IF
       IF g_ima.ima133 IS NULL THEN LET g_ima.ima133 = g_ima.ima01 END IF
       IF g_ima.ima01[1,4]='MISC' THEN #NO:6808(養生)
          LET g_ima.ima08='Z'
       END IF
 
END FUNCTION 
#************************************************************************************************************* 
###############################################################################################################     
FUNCTION BeforeDeleteItem(l_sep,l_checkHeadField,l_checkBodyField,l_checkHeadData,l_checkBodyData)
DEFINE l_sep      STRING,
       l_checkHeadField    STRING,
       l_checkHeadData     STRING,
       l_errCode  STRING,
       l_errDesc  STRING,
       l_azo06             LIKE azo_file.azo06,
       count1              SMALLINT
 
 
DEFINE l_checkBodyField  DYNAMIC ARRAY OF RECORD
                          FILED STRING
                         END RECORD,
        l_checkBodyData  DYNAMIC ARRAY OF RECORD
                          DATA  STRING,
                          ignore STRING,
                          success STRING
                          END RECORD
                           
DEFINE tok base.StringTokenizer
  
 
   INITIALIZE g_ima.* LIKE ima_file.*
   LET g_ima01_t = NULL
   LET g_ima_o.*=g_ima.* 
   LET l_errCode=NULL
   LET l_errDesc=NULL
   #CALL ima_default()
   LET head1 = l_checkHeadField
   LET tok = base.StringTokenizer.createExt(head1,l_sep,"",TRUE)
  LET count1=tok.countTokens()
   WHILE tok.hasMoreTokens()
      LET i = tok.countTokens()
      LET head2[i] = tok.nextToken()
   END WHILE      
   LET head1 = l_checkHeadData
   LET tok = base.StringTokenizer.createExt(head1,l_sep,"",TRUE)
   WHILE tok.hasMoreTokens()
      LET i = tok.countTokens()
      LET value2[i] = tok.nextToken()
   END WHILE
   FOR i=1 TO count1       
    CASE head2[i]
       WHEN 'ima01'
          LET g_ima.ima01=value2[i]
       WHEN 'ima02'
          LET g_ima.ima02=value2[i]
       WHEN 'ima021'
          LET g_ima.ima021=value2[i]
       WHEN 'ima06'
          LET g_ima.ima06=value2[i]
       WHEN 'ima18'
          LET g_ima.ima18=value2[i]
  ##NO.FUN-A20044   --begin
 #     WHEN 'ima26'
 #        LET g_ima.ima26=value2[i]
 #     WHEN 'ima261'
 #        LET g_ima.ima261=value2[i]
 #     WHEN 'ima262'
 #        LET g_ima.ima262=value2[i] 
  ##NO.FUN-A20044   --end 
       WHEN 'imauser'
          LET g_ima.imauser=value2[i]
       WHEN 'imagrup'
          LET g_ima.imagrup=value2[i]
       WHEN 'imamodu'
          LET g_ima.imamodu=value2[i]
       WHEN 'imadate'
          LET g_ima.imadate=value2[i]
       WHEN 'imaacti'
          LET g_ima.imaacti=value2[i]
       WHEN "ima08"
          LET g_ima.ima08=value2[i]
       WHEN "ima13"
          LET g_ima.ima13=value2[i]
       WHEN "ima14"
          LET g_ima.ima14=value2[i]
       WHEN "ima903"
          LET g_ima.ima903=value2[i]
       WHEN "ima15"
          LET g_ima.ima15=value2[i]
       WHEN "ima109"
          LET g_ima.ima109=value2[i]
       WHEN "ima105"
          LET g_ima.ima105=value2[i]
       WHEN "ima70"
          LET g_ima.ima70=value2[i]
       WHEN "ima09"
          LET g_ima.ima09=value2[i]
       WHEN "ima10"
          LET g_ima.ima10=value2[i]
       WHEN "ima11"
          LET g_ima.ima11=value2[i]
       WHEN "ima12"
          LET g_ima.ima12=value2[i]
       WHEN "ima25"
          LET g_ima.ima25=value2[i]
       WHEN "ima35"
          LET g_ima.ima35=value2[i]
       WHEN "ima36"
          LET g_ima.ima36=value2[i]
       WHEN "ima23"
          LET g_ima.ima23=value2[i]
       WHEN "ima07"
          LET g_ima.ima07=value2[i]
       WHEN "ima39"
          LET g_ima.ima39=value2[i]
 
    END CASE
     
  END FOR
  IF g_ima.ima01 IS NULL THEN
     # CALL cl_err('',-400,0)
     LET l_errCode='aws-228'
     CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'100',"料件編號不能為空")
     RETURNING l_errDesc
     RETURN l_errCode,l_errDesc
  END IF
  
  CALL i100_del() 
  IF NOT cl_null(g_errno) THEN
      LET l_errCode='aws_228'
      CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,g_errno,"該物料("||g_ima.ima01||")在系統中不允許刪除,"||aws_GetErrorInfo(g_errno))
      RETURNING l_errDesc
      RETURN l_errCode,l_errDesc
   END IF
 
  RETURN l_errCode,l_errDesc
 END FUNCTION
#***************************************************************************************************
FUNCTION AfterDeleteItem(l_sep,l_checkHeadField,l_checkBodyField,l_checkHeadData,l_checkBodyData)
DEFINE l_sep      STRING,
       l_checkHeadField    STRING,
       l_checkHeadData     STRING,
       l_errCode  STRING,
       l_errDesc  STRING,
       l_azo06             LIKE azo_file.azo06,
       count1              SMALLINT
 
 
DEFINE l_checkBodyField  DYNAMIC ARRAY OF RECORD
                          FILED STRING
                         END RECORD,
        l_checkBodyData  DYNAMIC ARRAY OF RECORD
                          DATA  STRING,
                          ignore STRING,
                          success STRING
                          END RECORD
DEFINE tok base.StringTokenizer
  
 
   INITIALIZE g_ima.* LIKE ima_file.*
   LET g_ima01_t = NULL
   LET g_ima_o.*=g_ima.* 
   LET l_errCode=NULL
   LET l_errdesc=NULL
   LET head1 = l_checkHeadField
   LET tok = base.StringTokenizer.createExt(head1,l_sep,"",TRUE)
   LET count1=tok.countTokens()
   WHILE tok.hasMoreTokens()
      LET i = tok.countTokens()
      LET head2[i] = tok.nextToken()
   END WHILE      
   LET head1 = l_checkHeadData
   LET tok = base.StringTokenizer.createExt(head1,l_sep,"",TRUE)
   WHILE tok.hasMoreTokens()
      LET i = tok.countTokens()
      LET value2[i] = tok.nextToken()
   END WHILE
   FOR i=1 TO count1       
    CASE head2[i]
       WHEN 'ima01'
          LET g_ima.ima01=value2[i]
       WHEN 'ima02'
          LET g_ima.ima02=value2[i]
       WHEN 'ima021'
          LET g_ima.ima021=value2[i]
       WHEN 'ima06'
          LET g_ima.ima06=value2[i]
       WHEN 'ima18'
          LET g_ima.ima18=value2[i]
  ##NO.FUN-A20044   --begin   
#      WHEN 'ima26'
#         LET g_ima.ima26=value2[i]
#      WHEN 'ima261'
#         LET g_ima.ima261=value2[i]
#      WHEN 'ima262'
#         LET g_ima.ima262=value2[i] 
  ##NO.FUN-A20044   --end
       WHEN 'imauser'
          LET g_ima.imauser=value2[i]
       WHEN 'imagrup'
          LET g_ima.imagrup=value2[i]
       WHEN 'imamodu'
          LET g_ima.imamodu=value2[i]
       WHEN 'imadate'
          LET g_ima.imadate=value2[i]
       WHEN 'imaacti'
          LET g_ima.imaacti=value2[i]
       WHEN "ima08"
          LET g_ima.ima08=value2[i]
       WHEN "ima13"
          LET g_ima.ima13=value2[i]
       WHEN "ima14"
          LET g_ima.ima14=value2[i]
       WHEN "ima903"
          LET g_ima.ima903=value2[i]
       WHEN "ima15"
          LET g_ima.ima15=value2[i]
       WHEN "ima109"
          LET g_ima.ima109=value2[i]
       WHEN "ima105"
          LET g_ima.ima105=value2[i]
       WHEN "ima70"
          LET g_ima.ima70=value2[i]
       WHEN "ima09"
          LET g_ima.ima09=value2[i]
       WHEN "ima10"
          LET g_ima.ima10=value2[i]
       WHEN "ima11"
          LET g_ima.ima11=value2[i]
       WHEN "ima12"
          LET g_ima.ima12=value2[i]
       WHEN "ima25"
          LET g_ima.ima25=value2[i]
       WHEN "ima35"
          LET g_ima.ima35=value2[i]
       WHEN "ima36"
          LET g_ima.ima36=value2[i]
       WHEN "ima23"
          LET g_ima.ima23=value2[i]
       WHEN "ima07"
          LET g_ima.ima07=value2[i]
       WHEN "ima39"
          LET g_ima.ima39=value2[i]
 
    END CASE
     
  END FOR
  IF g_ima.ima01 IS NULL OR g_ima.ima01=' ' THEN
     # CALL cl_err('',-400,0)
     LET l_errCode='aws-228'
     CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'-400',"料件編號不能為空")
     RETURNING l_errDesc
     RETURN l_errCode,l_errDesc
  END IF
  
#FUN-9A0080 --BEGIN--  
#  SELECT rowi INTO g_ima_rowi FROM ima_file
#   WHERE ima01=g_ima.ima01
#FUN-9A0080 --END-- 

 DELETE FROM imc_file WHERE imc01 = g_ima.ima01
  IF SQLCA.sqlcode THEN 
     LET l_errCode='aws-228'
     CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,SQLCA.SQLCODE,
                   "物料("||g_ima.ima01||")在連帶刪除品名規格額外說明資料(imc_file)時發生錯誤:"||SQLCA.SQLCODE)
     RETURNING l_errDesc
     RETURN l_errCode,l_errDesc
  END IF 
  DELETE FROM ind_file WHERE ind01 = g_ima.ima01
  IF SQLCA.sqlcode THEN 
     LET l_errCode='aws-228'
     CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,SQLCA.SQLCODE,
                   "物料("||g_ima.ima01||")在連帶刪除料件/單據相關之檔案路徑檔案資料(ind_file)時發生錯誤:"||SQLCA.SQLCODE)
     RETURNING l_errDesc
     RETURN l_errCode,l_errDesc
  END IF 
  DELETE FROM imb_file WHERE imb01 = g_ima.ima01
  IF SQLCA.sqlcode THEN 
     LET l_errCode='aws-228'
     CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,SQLCA.SQLCODE,
                   "物料("||g_ima.ima01||")在連帶刪除料件成本要素資料(imb_file)時發生錯誤:"||SQLCA.SQLCODE)
     RETURNING l_errDesc
     RETURN l_errCode,l_errDesc
  END IF 
  DELETE FROM aps_ima  WHERE pid   = g_ima.ima01
  IF SQLCA.sqlcode THEN 
     LET l_errCode='aws-228'
     CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,SQLCA.SQLCODE,
                   "物料("||g_ima.ima01||")在連帶刪除Item_Master_Table(aps_ima)時發生錯誤:"||SQLCA.SQLCODE)
     RETURNING l_errDesc
     RETURN l_errCode,l_errDesc
  END IF 
  
    
    LET g_msg=TIME
    #No.B256 010327 by plum 增加記錄料號
    LET l_azo06='R: ',g_ima.ima01 CLIPPED
    INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,
                         azoplant,azolegal) #FUN-980009
      #VALUES ('aimi100',g_user,g_today,g_msg,g_ima_rowi,'remove')
      # VALUES ('aimi100',g_user,g_today,g_msg,g_ima_rowi,l_azo06,  #FUN-9A0080
       VALUES ('aimi100',g_user,g_today,g_msg,g_ima.ima01,l_azo06,  #FUN-9A0080
               g_plant,g_legal)             #FUN-980009
    #No.B256 ..end
    RETURN l_errCode,l_errDesc
 END FUNCTION
 
#****************************************************************************************************  
 FUNCTION i100_del()
   DEFINE l_n SMALLINT
 
 #No.B013 010322 by plum check 后端資料只要有存在就不允許刪除
   LET g_errno = ' '
  ##NO.FUN-A20044   --begin
#  IF g_ima.ima26  >0 THEN LET g_errno='mfg9161' RETURN END IF
#  IF g_ima.ima261 >0 THEN LET g_errno='mfg9162' RETURN END IF
#  IF g_ima.ima262 >0 THEN LET g_errno='mfg9163' RETURN END IF
  ##NO.FUN-A20044   --end
 #--->產品結構(bma_file,bmb_file)須有效BOM 
 SELECT COUNT(*) INTO l_n FROM bma_file
  WHERE bma01 = g_ima.ima01 
 IF l_n > 0 THEN LET g_errno='mfg9191' RETURN END IF
 SELECT COUNT(*) INTO l_n FROM bmb_file
  WHERE bmb03 = g_ima.ima01 
#   AND (bmb05 >= MDY(12,31,9999) OR bmb05 IS NULL)
    AND (bmb04<=g_today OR bmb04 IS NULL) #BugNo:6039
    AND (bmb05> g_today OR bmb05 IS NULL)
 IF l_n > 0 THEN LET g_errno='mfg9191' RETURN END IF
 #--->取替代(bmd_file)
 SELECT COUNT(*) INTO l_n FROM bmd_file
  WHERE bmd04=g_ima.ima01
    AND bmdacti = 'Y'                                           #CHI-910021
 IF l_n >0 THEN LET g_errno='mfg9191' RETURN END IF
 #--->請購單 (pml_file)，必須尚未結案 -> 只要有存在就不允許刪除
 SELECT COUNT(*) INTO l_n FROM pml_file
  WHERE pml04 = g_ima.ima01 
 IF l_n > 0 THEN LET g_errno='mfg9194' RETURN END IF
 #--->采購單 (pmn_file)，必須尚未結案 -> 只要有存在就不允許刪除
 SELECT COUNT(*) INTO l_n FROM pmn_file
  WHERE pmn04 = g_ima.ima01  
 #  AND pmn16 MATCHES "[X012]"     
 IF l_n > 0 THEN LET g_errno='mfg9192' RETURN END IF
 #--->收貨(rvv_file)
 SELECT COUNT(*) INTO l_n FROM rvv_file
 WHERE rvv31 = g_ima.ima01
 IF l_n > 0 THEN LET g_errno='mfg9192' RETURN END IF
 #--->工單料件 (sfa_file,sfb_file)，必須尚未結案 -> 只要有存在就不允許刪除
 SELECT COUNT(*) INTO l_n FROM sfa_file,sfb_file
  WHERE sfa01=sfb01 AND sfa03 = g_ima.ima01 
#   AND sfb04 != '8'
 IF l_n > 0 THEN LET g_errno='mfg9193' RETURN END IF
 SELECT COUNT(*) INTO l_n FROM sfb_file
  WHERE sfb05 = g_ima.ima01 
#   AND sfb04 != '8'
 IF l_n > 0 THEN LET g_errno='mfg9193' RETURN END IF
 #---> 訂單(oeb_file),只要存在就不允許刪除
 SELECT COUNT(*) INTO l_n FROM oeb_file
  WHERE oeb04 = g_ima.ima01 
 IF l_n > 0 THEN LET g_errno='mfg9195' RETURN END IF
 #---> 出貨單(ogb_file),只要存在就不允許刪除
 SELECT COUNT(*) INTO l_n FROM ogb_file
  WHERE ogb04 = g_ima.ima01 
 IF l_n > 0 THEN LET g_errno='mfg9196' RETURN END IF
 #---> 銷退(ohb_file)
 SELECT COUNT(*) INTO l_n FROM ohb_file
  WHERE ohb04=g_ima.ima01
 IF l_n > 0 THEN LET g_errno='mfg9196' RETURN END IF
 #---> 庫存異動單(inb_file),只要存在就不允許刪除
 SELECT COUNT(*) INTO l_n FROM inb_file
  WHERE inb04 = g_ima.ima01 
 IF l_n > 0 THEN LET g_errno='mfg9197' RETURN END IF
 #---> 調撥單(imn_file),只要存在就不允許刪除
 SELECT COUNT(*) INTO l_n FROM imn_file
  WHERE imn03 = g_ima.ima01 
 IF l_n > 0 THEN LET g_errno='mfg9198' RETURN END IF
#No.B013 010322 by plum
END FUNCTION
#*******************************************************************************************   
#############################################################################################   
 
FUNCTION BeforeUpdateItem(l_sep,l_CheckHeadField,l_checkBodyField,l_checkHeadData,l_checkBodyData)
DEFINE l_sep      STRING,
       l_checkHeadField    STRING,
       l_checkHeadData     STRING,
       l_errCode  STRING,
       l_errDesc  STRING,
       l_misc     STRING,
       count1              SMALLINT
DEFINE l_imzacti           LIKE imz_file.imzacti
DEFINE l_checkBodyField  DYNAMIC ARRAY OF RECORD
                          FILED STRING
                         END RECORD,
        l_checkBodyData  DYNAMIC ARRAY OF RECORD
                          DATA  STRING
                          END RECORD
                          
DEFINE tok base.StringTokenizer
  
 
   INITIALIZE g_ima.* LIKE ima_file.*
   LET g_ima01_t = NULL
   LET g_ima_o.*=g_ima.* 
   LET l_errCode=NULL
   LET l_errDesc=NULL
   LET head1 = l_checkHeadField
   LET tok = base.StringTokenizer.createExt(head1,l_sep,"",TRUE)
   LET count1=tok.countTokens()
   WHILE tok.hasMoreTokens()
      LET i = tok.countTokens()
      LET head2[i] = tok.nextToken()
   END WHILE      
   LET head1 = l_checkHeadData
   LET tok = base.StringTokenizer.createExt(head1,l_sep,"",TRUE)
   WHILE tok.hasMoreTokens()
      LET i = tok.countTokens()
      LET value2[i] = tok.nextToken()
   END WHILE
 
 FOR i=1 TO count1       
    CASE head2[i]
       WHEN "ima01"
          LET g_ima.ima01=value2[i]
       WHEN "ima02"
          LET g_ima.ima02=value2[i]
       WHEN "ima021"
          LET g_ima.ima021=value2[i]
       WHEN "ima06"
          LET g_ima.ima06=value2[i]
       WHEN "ima18"
          LET g_ima.ima18=value2[i]   
       #僅設定可能傳的值
  ##NO.FUN-A20044   --begin
#      WHEN "ima26"
#         LET g_ima.ima26=value2[i]
#      WHEN "ima261"
#         LET g_ima.ima261=value2[i]
#      WHEN "ima262"
#         LET g_ima.ima262=value2[i] 
  ##NO.FUN-A20044   --end
       WHEN "imauser"
          LET g_ima.imauser=value2[i]
       WHEN "imagrup"
          LET g_ima.imagrup=value2[i]
       WHEN "imamodu"
          LET g_ima.imamodu=value2[i]
       WHEN "imadate"
          LET g_ima.imadate=value2[i]
       WHEN "imaacti"
          LET g_ima.imaacti=value2[i]
       WHEN "ima08"
          LET g_ima.ima08=value2[i]
       WHEN "ima13"
          LET g_ima.ima13=value2[i]
       WHEN "ima14"
          LET g_ima.ima14=value2[i]
       WHEN "ima903"
          LET g_ima.ima903=value2[i]
       WHEN "ima15"
          LET g_ima.ima15=value2[i]
       WHEN "ima109"
          LET g_ima.ima109=value2[i]
       WHEN "ima105"
          LET g_ima.ima105=value2[i]
       WHEN "ima70"
          LET g_ima.ima70=value2[i]
       WHEN "ima09"
          LET g_ima.ima09=value2[i]
       WHEN "ima10"
          LET g_ima.ima10=value2[i]
       WHEN "ima11"
          LET g_ima.ima11=value2[i]
       WHEN "ima12"
          LET g_ima.ima12=value2[i]
       WHEN "ima25"
          LET g_ima.ima25=value2[i]
       WHEN "ima35"
          LET g_ima.ima35=value2[i]
       WHEN "ima36"
          LET g_ima.ima36=value2[i]
       WHEN "ima23"
          LET g_ima.ima23=value2[i]
       WHEN "ima07"
          LET g_ima.ima07=value2[i]
       WHEN "ima39"
          LET g_ima.ima39=value2[i]
    END CASE
     
  END FOR
  
  IF g_ima.ima01 IS NULL THEN
     #CALL cl_err('',-400,0)
     LET l_errCode='aws-210'
     CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'-400',"料件編號不能為空")
     RETURNING l_errDesc
     RETURN l_errCode,l_errDesc
  END IF
  
  IF g_ima.ima01<>'%%' THEN
     SELECT imaacti INTO g_ima.imaacti FROM ima_file WHERE ima01=g_ima.ima01
     IF g_ima.imaacti ='N' THEN    #檢查資料是否為無效
        #CALL cl_err(g_ima.ima01,'mfg1000',0)
        LET l_errCode='aws-210'
        CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1000',"要更新的物料("||g_ima.ima01||")為無效料件")
        RETURNING l_errDesc
        RETURN l_errCode,l_errDesc
     END IF
  END IF
        
  #ima01不能為空且不能被更改若key在DB中不存在
  IF NOT cl_null(g_ima.ima01) THEN
     IF g_ima.ima01<>"%%" THEN
        LET l_n=0
        SELECT count(*) INTO l_n FROM ima_file
         WHERE ima01 = g_ima.ima01
        IF l_n = 0 THEN      
           #CALL cl_err(g_ima.ima01,-400,0)
           LET l_errCode='aws-210'
           CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'-400',"料件編號不存在")
           RETURNING l_errDesc
           RETURN l_errCode,l_errDesc
        END IF
     END IF  
  END IF
  
  #對分群碼的管控，且由分群碼帶出相關字段的值
  IF g_ima.ima06 IS NOT NULL AND  g_ima.ima06 != ' ' AND g_ima.ima06 <>'%%' THEN
     SELECT imzacti INTO l_imzacti
       FROM imz_file
      WHERE imz01 = g_ima.ima06    
     CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3179'
          WHEN l_imzacti='N' LET g_errno = '9028'
          OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
  ELSE 
     LET g_errno = 'mfg3179'
  END IF
  IF NOT cl_null(g_errno) THEN
     LET l_errCode=g_errno
     CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,g_errno,
                   "物料("||g_ima.ima01||")分群碼錯誤,值("||g_ima.ima06||"),"||aws_getErrorInfo(g_errno))
     RETURNING l_errDesc
     RETURN l_errCode,l_errDesc
  END IF
  
             #對ima08的管控
  IF (NOT cl_null(g_ima.ima08)) AND (g_ima.ima08<>'%%') THEN 
     IF g_ima.ima08 NOT MATCHES "[CTDAMPXKUVZS]" 
         OR g_ima.ima08 IS NULL 
        THEN 
        #CALL cl_err(g_ima.ima08,'mfg1001',0)
        LET l_errCode='aws-210'
        CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1001',
                      "物料("||g_ima.ima01||")公單發料調撥否錯誤,值("||g_ima.ima08||"),"||aws_getErrorInfo('mfg1001'))
        RETURNING l_errDesc
        RETURN l_errCode,l_errDesc
     END IF
     LET l_misc=g_ima.ima01[1,4]     
     IF l_misc='MISC' AND g_ima.ima08 <>'Z' THEN
        #CALL cl_err('','aim-805',0)
        LET l_errCode='aws-210'
        CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'-400',"雜項料件(料件編號為MISC)的來源碼必須為Z")
        RETURNING l_errDesc
        RETURN l_errCode,l_errDesc
     END IF
  END IF
            
  #對ima13的管控
  IF (NOT cl_null(g_ima.ima13)) AND (g_ima.ima13<>'%%') THEN
     IF (g_ima.ima08 = 'T') AND (g_ima.ima13 IS NULL 
               OR g_ima.ima13 = ' ' )
       THEN #CALL cl_err(g_ima.ima13,'mfg1327',0)
        LET l_errCode='aws-210'
        CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'-400',"料件編號不存在")
        RETURNING l_errDesc
        RETURN l_errCode,l_errDesc
     END IF
     IF g_ima.ima18 IS NOT NULL THEN 
        IF (g_ima_o.ima13 IS NULL ) OR (g_ima_o.ima13 != g_ima.ima13) THEN
           SELECT ima08 FROM ima_file 
            WHERE ima01 = g_ima.ima13
              AND ima08 matches 'C'     
              AND imaacti matches'[Yy]'
           IF SQLCA.sqlcode != 0 THEN 
              #CALL #cl_err(g_ima.ima13,'mfg1328',0)
               LET l_errCode='aws-210'
               CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1328',
                             "物料("||g_ima.ima01||")規格組件料件編號錯誤,值("||g_ima.ima13||"),"||aws_getErrorInfo('mfg1328'))
               RETURNING l_errDesc
               RETURN l_errCode,l_errDesc
           END IF
        END IF
     END IF
  END IF
           
          #對ima14#工程料件的管控
  IF (NOT cl_null(g_ima.ima14)) AND (g_ima.ima14<>'%%') THEN
     IF g_ima.ima14 NOT MATCHES "[YN]" THEN
        #CALL cl_err(g_ima.ima14,'mfg1002',0)
        LET l_errCode='aws-210'
        CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1002',
                      "物料("||g_ima.ima01||")是否為工程料件取值錯誤,值("||g_ima.ima14||"),"||aws_getErrorInfo('mfg1002'))
        RETURNING l_errDesc
        RETURN l_errCode,l_errDesc
     END IF
  END IF
            
  #對ima903的管控可否做聯產品入庫
  IF (NOT cl_null(g_ima.ima903)) AND g_ima.ima903<>'%%' THEN
     IF g_ima.ima903 NOT MATCHES "[YN]" THEN
        #CALL cl_err(g_ima.ima903,'mfg1002',0)
        LET l_errCode='aws-210'
        CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1002',
                      "物料("||g_ima.ima01||")可否做聯產品入庫取值錯誤,值("||g_ima.ima903||"),"||aws_getErrorInfo('mfg1002'))
        RETURNING l_errDesc
        RETURN l_errCode,l_errDesc
     END IF
  END IF
            
  #對ima24的 #檢驗否 管控缺
  #對ima107，ima147的管控缺
  #對ima15的#保稅料件管控
  IF (NOT cl_null(g_ima.ima15)) AND g_ima.ima15<>'%%'THEN
     IF g_ima.ima15 NOT MATCHES "[YN]" THEN
        #CALL cl_err(g_ima.ima15,'mfg1002',0)
        LET l_errCode='aws-210'
        CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1002',
                      "物料("||g_ima.ima01||")保稅與否取值錯誤,值("||g_ima.ima15||"),"||aws_getErrorInfo('mfg1002'))
        RETURNING l_errDesc
        RETURN l_errCode,l_errDesc
     END IF
  END IF
           
  #對ima109的管控
  IF (NOT cl_null(g_ima.ima109)) AND g_ima.ima109<>'%%' THEN
     IF (g_ima_o.ima109 IS NULL) OR (g_ima.ima109 != g_ima_o.ima109) THEN
        SELECT azf01 FROM azf_file 
         WHERE azf01=g_ima.ima109 AND azf02='8'
           AND azfacti='Y'
        IF SQLCA.sqlcode  THEN
           #CALL cl_err(g_ima.ima109,'mfg1306',0)
          LET l_errCode='aws-210'
          CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1306',
                        "物料("||g_ima.ima01||")可否做聯產品入庫取值錯誤,值("||g_ima.ima903||"),"||aws_getErrorInfo('mfg1306'))
          RETURNING l_errDesc
          RETURN l_errCode,l_errDesc
        END IF
     END IF
  END IF
            
            #對ima105的管控
  IF (NOT cl_null(g_ima.ima105)) AND g_ima.ima105<>'%%' THEN
     IF g_ima.ima105 NOT MATCHES "[YN]" THEN
        #CALL cl_err(g_ima.ima105,'mfg1002',0)
         LET l_errCode='aws-210'
         CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1002',
                       "物料("||g_ima.ima01||")是否為軟體物件取值錯誤,值("||g_ima.ima105||"),"||aws_getErrorInfo('mfg1002'))
         RETURNING l_errDesc
         RETURN l_errCode,l_errDesc
     END IF
  END IF
  
  #對ima70的管控
  IF (NOT cl_null(g_ima.ima70)) AND g_ima.ima70<>'%%' THEN 
     IF g_ima.ima70 NOT MATCHES '[YN]' THEN
        #CALL cl_err(g_ima.ima70,'mfg1002',0) 
        LET l_errCode='aws-210'
        CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1306',
                      "物料("||g_ima.ima01||")材料類型錯誤,值("||g_ima.ima70||"),"||aws_getErrorInfo('mfg1306'))
        RETURNING l_errDesc
        RETURN l_errCode,l_errDesc
     END IF
  END IF
               
  #對ima09的管控#其他分群碼一
  IF (g_ima.ima09 IS NOT NULL AND g_ima.ima09 != ' ') AND (g_ima.ima09<>'%%') THEN
     SELECT azf01 FROM azf_file 
      WHERE azf01=g_ima.ima09 AND azf02='D' #6818
        AND azfacti='Y'
     IF SQLCA.sqlcode  THEN
        #CALL cl_err(g_ima.ima09,'mfg1306',0)
        LET l_errCode='aws-210'
        CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1306',
                      "物料("||g_ima.ima01||")其他分群碼一("||g_ima.ima09||")在系統中未定義")  
        RETURNING l_errDesc
        RETURN l_errCode,l_errDesc
     END IF
  END IF
           
           #對ima10的管控#其他分群碼二
  IF (g_ima.ima10 IS NOT NULL AND g_ima.ima10 != ' ') AND (g_ima.ima10<>'%%') THEN
     SELECT azf01 FROM azf_file 
     WHERE azf01=g_ima.ima10 AND azf02='E' #6818
       AND azfacti='Y'
     IF SQLCA.sqlcode  THEN
        #CALL cl_err(g_ima.ima10,'mfg1306',0)
        LET l_errCode='aws-210'
        CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1306',
                      "物料("||g_ima.ima01||")其他分群碼二("||g_ima.ima10||")在系統中未定義") 
        RETURNING l_errDesc
        RETURN l_errCode,l_errDesc
     END IF
  END IF
           
  #對ima11的管控其他分群碼三
  IF (g_ima.ima11 IS NOT NULL AND g_ima.ima11 != ' ') AND (g_ima.ima11<>'%%') THEN
     SELECT azf01 FROM azf_file 
      WHERE azf01=g_ima.ima11 AND azf02='F' #6818
        AND azfacti='Y'
     IF SQLCA.sqlcode  THEN
        #CALL cl_err(g_ima.ima11,'mfg1306',0)
        LET l_errCode='aws-210'
        CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1306',
                       "物料("||g_ima.ima01||")其他分群碼三("||g_ima.ima11||")在系統中未定義") 
        RETURNING l_errDesc
        RETURN l_errCode,l_errDesc
     END IF
       #END IF #No:7062
  END IF
            
            #對ima12的管控#其他分群碼四
  IF (g_ima.ima12 IS NOT NULL AND g_ima.ima12 != ' ') AND (g_ima.ima12<>'%%')
     THEN 
          #No:7062
          #IF (g_ima_o.ima12 IS NULL) OR (g_ima_o.ima12 != g_ima.ima12) THEN
     SELECT azf01 FROM azf_file 
     WHERE azf01=g_ima.ima12 AND azf02='G' #6818
       AND azfacti='Y'
     IF SQLCA.sqlcode  THEN
        #CALL cl_err(g_ima.ima12,'mfg1306',0)
        LET l_errCode='aws-210'
        CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1306',
                      "物料("||g_ima.ima01||")其他分群碼四("||g_ima.ima12||")在系統中未定義")
        RETURNING l_errDesc
        RETURN l_errCode,l_errDesc
     END IF
          #END IF #No:7062
  END IF
      
      #對ima25的判斷庫存單位
  IF (NOT cl_null(g_ima.ima25)) AND g_ima.ima25<>'%%' THEN
     SELECT gfe01 FROM gfe_file 
     WHERE gfe01=g_ima.ima25 
  #    AND gfeacti matches'[Yy]'  marked by fuli 070522
     IF SQLCA.sqlcode THEN 
        #CALL cl_err(g_ima.ima25,'mfg1200',0)
        LET l_errCode='aws-210'
        CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1200',
                      "物料("||g_ima.ima01||")庫存單位，值("||g_ima.ima25||")在系統中未定義")
        RETURNING l_errDesc
        RETURN l_errCode,l_errDesc
     END IF
       LET g_ima.ima31 = g_ima.ima25 LET g_ima.ima31_fac = 1 
       LET g_ima.ima44 = g_ima.ima25 LET g_ima.ima44_fac = 1  
       LET g_ima.ima55 = g_ima.ima25 LET g_ima.ima55_fac = 1 
       LET g_ima.ima63 = g_ima.ima25 LET g_ima.ima63_fac = 1  
       LET g_ima.ima86 = g_ima.ima25 LET g_ima.ima86_fac = 1       
  END IF
            
            #對ima35的管控
  IF (g_ima.ima35 !=' ' AND g_ima.ima35 IS NOT NULL) AND g_ima.ima35<>'%%' THEN
     #No.B052 010326 by plum
     #SELECT * FROM imd_file WHERE imd01=g_ima.ima35
     SELECT * FROM imd_file WHERE imd01=g_ima.ima35 AND imdacti='Y'
     IF SQLCA.SQLCODE THEN 
        #CALL cl_err(g_ima.ima35,'mfg1100',0)
         LET l_errCode='aws-210'
         CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1100',
                       "物料("||g_ima.ima01||")主要倉庫，值("||g_ima.ima35||")在系統中未定義")
         RETURNING l_errDesc
         RETURN l_errCode,l_errDesc
     END IF
  END IF 
  
  #對ima36的管控
  IF (g_ima.ima36 !=' ' AND g_ima.ima36 IS NOT NULL) AND g_ima.ima36<>'%%' THEN
     SELECT * FROM ime_file WHERE ime01=g_ima.ima35 
        AND ime02=g_ima.ima36
        AND imeacti = 'Y'      #FUN-D40103
     IF SQLCA.SQLCODE THEN 
        #CALL cl_err(g_ima.ima36,'mfg1101',0)
        LET l_errCode='aws-210'
        CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1101',
                     "物料("||g_ima.ima01||")主要庫位別，值("||g_ima.ima36||")在系統中未定義")
        RETURNING l_errDesc
        RETURN l_errCode,l_errDesc
     END IF
  END IF
  
  #對ima23的管控
  IF (NOT cl_null(g_ima.ima23)) AND g_ima.ima23<>'%%' THEN
     LET g_gen02 = ""                         #BUG-4A0326
    #SELECT * FROM gen_file                   #BUG-4A0326
     SELECT gen02 INTO g_gen02 FROM gen_file  #BUG-4A0326
      WHERE gen01=g_ima.ima23
        AND genacti='Y'
     IF SQLCA.SQLCODE THEN 
        #CALL cl_err(g_ima.ima23,'aoo-001',0)
        LET l_errCode='aws-210'
        CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'aoo-001',
                      "物料("||g_ima.ima01||")倉管員，值("||g_ima.ima23||")在系統中未定義")
        RETURNING l_errDesc
        RETURN l_errCode,l_errDesc
     END IF
  END IF
             
             
  #對ima07的管控#ABC 碼
  IF (NOT cl_null(g_ima.ima07)) AND g_ima.ima07<>'%%' THEN
     IF g_ima.ima07 NOT MATCHES'[ABC]' THEN
         #CALL cl_err(g_ima.ima07,'mfg0009',0)
        LET l_errCode='aws-210'
        CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg0009',
                      "物料("||g_ima.ima01||")ABC碼錯誤,值("||g_ima.ima07||"),"||aws_getErrorInfo('mfg0009'))
        RETURNING l_errDesc
        RETURN l_errCode,l_errDesc
     END IF
  END IF
           
  #對ima37的管控缺
  #對ima51>0ima52>0的控制缺
  #對ima39的管控
  IF (NOT cl_null(g_ima.ima39) OR g_ima.ima39 != ' ') AND g_ima.ima39<>'%%' THEN 
      SELECT count(*) INTO l_n FROM aag_file 
             WHERE aag01 = g_ima.ima39   
               AND aag07 != '1'  #No:8400 #BUG-490065將aag071改為aag07
      IF l_n=0 THEN     # Unique 
           #CALL cl_err(g_ima.ima39,100,0)
         LET l_errCode='aws-210'
         CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'100',
                       "物料("||g_ima.ima01||")所屬會計科目,值("||g_ima.ima39||")在系統中未定義") 
         RETURNING l_errDesc
         RETURN l_errCode,l_errDesc
      END IF
  END IF
  
  RETURN l_errCode,l_errDesc
  
  #對ima18單位重量無管控
END FUNCTION
#*********************************************************************************************
FUNCTION AfterUpdateItem(l_sep,l_CheckHeadField,l_checkBodyField,l_checkHeadData,l_checkBodyData)
DEFINE l_sep      STRING,
       l_checkHeadField    STRING,
       l_checkHeadData     STRING,
       l_errCode STRING,
       l_errDesc STRING,
       count1              SMALLINT
DEFINE l_imzacti           LIKE imz_file.imzacti
 
 
DEFINE l_checkBodyField  DYNAMIC ARRAY OF RECORD
                          FILED STRING
                         END RECORD,
        l_checkBodyData  DYNAMIC ARRAY OF RECORD
                          DATA  STRING
                          END RECORD
DEFINE tok base.StringTokenizer
  
 
 INITIALIZE g_ima.* LIKE ima_file.*
 LET g_ima01_t = NULL
 LET g_ima_o.*=g_ima.* 
 LET l_errCode=NULL
 LET l_errDesc=NULL
 LET head1 = l_checkHeadField
 LET tok = base.StringTokenizer.createExt(head1,l_sep,"",TRUE)
 LET count1=tok.countTokens()
 WHILE tok.hasMoreTokens()
    LET i = tok.countTokens()
    LET head2[i] = tok.nextToken()
 END WHILE      
 LET head1 = l_checkHeadData
 LET tok = base.StringTokenizer.createExt(head1,l_sep,"",TRUE)
 WHILE tok.hasMoreTokens()
    LET i = tok.countTokens()
    LET value2[i] = tok.nextToken()
 END WHILE
 
 FOR i=1 TO count1       
    CASE head2[i]
       WHEN "ima01"
          LET g_ima.ima01=value2[i]
       WHEN "ima02"
          LET g_ima.ima02=value2[i]
       WHEN "ima021"
          LET g_ima.ima021=value2[i]
       WHEN "ima06"
          LET g_ima.ima06=value2[i]
       WHEN "ima18"
          LET g_ima.ima18=value2[i]   
       #僅設定可能傳的值
  ##NO.FUN-A20044   --begin
#      WHEN "ima26"
#         LET g_ima.ima26=value2[i]
#      WHEN "ima261"
#         LET g_ima.ima261=value2[i]
#      WHEN "ima262"
#         LET g_ima.ima262=value2[i]       #NO.FUN-A40023
  ##NO.FUN-A20044   --end
       WHEN "imauser"
          LET g_ima.imauser=value2[i]
       WHEN "imagrup"
          LET g_ima.imagrup=value2[i]
       WHEN "imamodu"
          LET g_ima.imamodu=value2[i]
       WHEN "imadate"
          LET g_ima.imadate=value2[i]
       WHEN "imaacti"
          LET g_ima.imaacti=value2[i]
       WHEN "ima08"
          LET g_ima.ima08=value2[i]
       WHEN "ima13"
          LET g_ima.ima13=value2[i]
       WHEN "ima14"
          LET g_ima.ima14=value2[i]
       WHEN "ima903"
          LET g_ima.ima903=value2[i]
       WHEN "ima15"
          LET g_ima.ima15=value2[i]
       WHEN "ima109"
          LET g_ima.ima109=value2[i]
       WHEN "ima105"
          LET g_ima.ima105=value2[i]
       WHEN "ima70"
          LET g_ima.ima70=value2[i]
       WHEN "ima09"
          LET g_ima.ima09=value2[i]
       WHEN "ima10"
          LET g_ima.ima10=value2[i]
       WHEN "ima11"
          LET g_ima.ima11=value2[i]
       WHEN "ima12"
          LET g_ima.ima12=value2[i]
       WHEN "ima25"
          LET g_ima.ima25=value2[i]
       WHEN "ima35"
          LET g_ima.ima35=value2[i]
       WHEN "ima36"
          LET g_ima.ima36=value2[i]
       WHEN "ima23"
          LET g_ima.ima23=value2[i]
       WHEN "ima07"
          LET g_ima.ima07=value2[i]
       WHEN "ima39"
          LET g_ima.ima39=value2[i]
    END CASE
 END FOR
  
 IF g_ima.ima01 IS NULL THEN
       #CALL cl_err('',-400,0)
      LET l_errCode='aws-210'
      CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'-400',"料件編號不能為空")
      RETURNING l_errDesc
      RETURN l_errCode,l_errDesc
 END IF
 IF g_ima.ima25 IS NOT NULL THEN 
       LET g_ima.ima31 = g_ima.ima25 LET g_ima.ima31_fac = 1 
       LET g_ima.ima44 = g_ima.ima25 LET g_ima.ima44_fac = 1  
       LET g_ima.ima55 = g_ima.ima25 LET g_ima.ima55_fac = 1 
       LET g_ima.ima63 = g_ima.ima25 LET g_ima.ima63_fac = 1  
       LET g_ima.ima86 = g_ima.ima25 LET g_ima.ima86_fac = 1 
 END IF 
 UPDATE ima_file SET ima31 = g_ima.ima25,ima31_fac=1,
                     ima44 = g_ima.ima25,ima44_fac=1,
                     ima55 = g_ima.ima25,ima55_fac=1,
                     ima63 = g_ima.ima25,ima63_fac=1,
                     ima86 = g_ima.ima25,ima86_fac=1,
                     imadate = g_today    #FUN-C30315 add
       WHERE ima01 = g_ima.ima01
#FUN-9A0080 --BEGIN--
# SELECT rowi INTO g_ima_rowi 
#   FROM ima_file
#  WHERE ima01=g_ima.ima01 
#FUN-9A0080 --END--

 LET g_errno = TIME
 LET g_msg = 'Chg No:',g_ima.ima01
 INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,
                       azoplant,azolegal) #FUN-980009
   # VALUES ('aimi100',g_user,g_today,g_errno,g_ima_rowi,g_msg,  #FUN-9A0080
    VALUES ('aimi100',g_user,g_today,g_errno,g_ima.ima01,g_msg,  #FUN-9A0080
            g_plant,g_legal)              #FUN-980009
 IF SQLCA.sqlcode THEN
     #CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
    LET l_errCode='aws-210'
    CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,SQLCA.SQLCODE,
                  "物料("||g_ima.ima01||")在更新系統重要資料工更改記錄檔案資料(azo_file)時發生錯誤:"||SQLCA.SQLCODE)
    RETURNING l_errDesc
    RETURN l_errCode,l_errDesc
 ELSE 
 	 RETURN l_errCode,l_errDesc
 END IF
        
END FUNCTION
#*******************************************************************************************************************
###################################################################################################################
FUNCTION BeforeInsertBom(l_sep,l_checkHeadField,l_checkBodyField,l_checkHeadData,l_checkBodydata)
DEFINE l_sep      STRING,
       l_checkHeadField    STRING,
       l_checkHeadData     STRING,
       l_errCode           STRING,
       l_errDesc           STRING
       
DEFINE tok  base.StringTokenizer
      
 
DEFINE l_checkBodyField  DYNAMIC ARRAY OF RECORD
                          FIELD STRING
                         END RECORD
DEFINE l_checkBodyData  DYNAMIC ARRAY OF RECORD
                          DATA  STRING
                          END RECORD
DEFINE count1,count2   SMALLINT
                  
 INITIALIZE g_bma.*  LIKE bma_file.*
 LET head1 = l_checkHeadField
 LET l_errCode=NULL
 LET l_errDesc=NULL
 CALL head2.CLEAR()
 CALL value2.CLEAR()
 LET tok = base.StringTokenizer.createExt(head1,l_sep,"",TRUE)
 LET count1 = tok.countTokens()
 WHILE tok.hasMoreTokens()
    LET i = tok.countTokens()
    LET head2[i] = tok.nextToken()
 END WHILE      
 LET head1 = l_checkHeadData
 LET tok = base.StringTokenizer.CREATEExt(head1,l_sep,"",TRUE)
 WHILE tok.hasMoreTokens()
    LET i = tok.countTokens()
    LET value2[i] = tok.nextToken()
 END WHILE
 
 #將字符串分為一些值表示
 FOR i=1 TO count1       
   CASE head2[i]
      WHEN "bma01"
         LET g_bma.bma01=value2[i]
      WHEN "bma02"
         LET g_bma.bma02=value2[i]
      WHEN "bma03"
         LET g_bma.bma03=value2[i]
      WHEN "bma04"
         LET g_bma.bma04=value2[i]
      WHEN "bma05"
         LET g_bma.bma05=value2[i]
      WHEN "bmauser"
         LET g_bma.bmauser=value2[i]
      WHEN "bmagrup"
         LET g_bma.bmagrup=value2[i]
      WHEN "bmamodu"
         LET g_bma.bmamodu=value2[i]
      WHEN "bmadate"
         LET g_bma.bmadate=value2[i]
      WHEN "bmaacti"
         LET g_bma.bmaacti=value2[i]
   END CASE
 END FOR
 IF cl_null(g_bma.bma05) THEN LET g_bma.bma05 = g_today END IF      
 IF cl_null(g_bma.bmadate) THEN LET g_bma.bmadate = g_today END IF 
  WHILE TRUE
 #對傳入值的管控
 #對bma01的管控
     IF g_bma.bma01 IS NULL THEN                   #主料件bma01新增時不能為空
        #CALL cl_err('','703',0)
        LET l_errCode='aws-211'
        CALL errZhuhe("bma_file",l_checkHeadField,l_checkHeadData,'703',"主件料號不能為空")
        RETURNING l_errDesc
        RETURN l_errCode,l_errDesc                                
     END IF
     IF NOT cl_null(g_bma.bma01) THEN
        IF g_bma.bma01 != g_bma01_t OR g_bma01_t IS NULL THEN
           SELECT count(*) INTO g_cnt FROM bma_file          #輸入的bma01不能已經存在于bma表中，主件資料不能重復
            WHERE bma01 = g_bma.bma01
           IF g_cnt > 0 THEN   #資料重復
              #CALL cl_err(g_bma.bma01,-239,0)
              LET l_errCode='aws-211'
              CALL errZhuhe("bma_file",l_checkHeadField,l_checkHeadData,'-239',"該BOM("||g_bma.bma01||")在系統中已經存在")
              RETURNING l_errDesc
              RETURN l_errCode,l_errDesc
           END IF
        END IF
        CALL bom_bma01('a') #輸入的bma01須存在于ima_file中的有效料件，且ima_file中的來源碼不為Z（z雜料）        
        IF NOT cl_null(g_errno) THEN
           LET l_errCode='aws-211'
           CALL errZhuhe("bma_file",l_checkHeadField,l_checkHeadData,g_errno,
                         "BOM(主件料號為"||g_bma.bma01||")錯誤:"||aws_getErrorInfo(g_errno))
           RETURNING l_errDesc
           RETURN l_errCode,l_errDesc
        END IF
        SELECT COUNT(*) INTO g_cnt        #若此bma01料件為它料的聯產品，所以不可以建立此料件的bom
          FROM bmm_file
         WHERE bmm03 = g_bma.bma01
           AND bmm01 != bmm03
        IF g_cnt >=1 THEN
           #此料件為它料的聯產品,所以不可建立此料件的BOM!
           LET l_errCode='aws-211'
           CALL errZhuhe("bma_file",l_checkHeadField,l_checkHeadData,'abm-611',
                         "料件("||g_bma.bma01||")為它料的聯產品，所以不可以建立此料件的BOM")
           RETURNING l_errDesc
           RETURN l_errCode,l_errDesc
        END IF
     END IF
     #對bma04無管控
     #對bma05發放日期無管控
     EXIT WHILE               
  END WHILE
  #對單身的分開賦值處理
  LET l_detail=1
  #每次WHILE插入一條單身記錄，直到l_checkBodyData為空為止
  WHILE (l_checkBodyData[l_detail].DATA IS NOT NULL)
     INITIALIZE g_bmb.* TO NULL
     LET head1 = l_checkBodyField[1].FIELD
     CALL head2.CLEAR()
     CALL value2.CLEAR()
     LET tok = base.StringTokenizer.createExt(head1,l_sep,"",TRUE)
     LET count2 = tok.countTokens()
     WHILE tok.hasMoreTokens()
        LET i = tok.countTokens()
        LET head2[i] = tok.nextToken()
     END WHILE 
     LET head1 = l_checkBodyData[l_detail].DATA
     LET tok = base.StringTokenizer.CREATEExt(head1,l_sep,"",TRUE)
     WHILE tok.hasMoreTokens()
        LET i = tok.countTokens()
        LET value2[i] = tok.nextToken()
     END WHILE  
     
     FOR i=1 TO count2       
        CASE head2[i]
           WHEN "bmb01"
             #LET g_bma.bma01=value2[i]
              LET g_bmb.bmb01=value2[i]
           WHEN "bmb02"
              LET g_bmb.bmb02=value2[i]
           WHEN "bmb03"
              LET g_bmb.bmb03=value2[i]
           WHEN "bmb04"
              LET g_bmb.bmb04=value2[i]
           WHEN "bmb05"
              LET g_bmb.bmb05=value2[i]
           WHEN "bmb06"
              LET g_bmb.bmb06=value2[i]
           WHEN "bmb07"
              LET g_bmb.bmb07=value2[i]
           WHEN "bmb08"
              LET g_bmb.bmb08=value2[i]
           WHEN "bmb10"
              LET g_bmb.bmb10=value2[i]
           WHEN "bmb11"
              LET g_bmb.bmb11=value2[i]
           WHEN "bmb13"
              LET g_bmb.bmb13=value2[i]
           #WHEN "bmb_pdm_rowi"
           #   LET g_bmb.bmb_pdm_rowi=value2[i]
           WHEN "bmbmodu"
              LET g_bmb.bmbmodu=value2[i]
           WHEN "bmadate"
              LET g_bmb.bmbdate=value2[i]
           WHEN "bmacomm"
              LET g_bmb.bmbcomm=value2[i]
        END CASE
     END FOR
{     
     #對bmb各字段的管控
     #bmb_pdm_rowi一定要有
     IF cl_null(g_bmb.bmb_pdm_rowi) THEN
        LET l_errCode='aws-226'
        CALL errzhuhe("bmb_file",l_checkBodyField[1].FIELD,l_checkBodyData[l_detail].DATA,'100',"bmb_pdm_rowi為必要欄位,不能為空！")
        RETURNING l_errDesc
        RETURN l_errCode,l_errDesc
     END IF
     #對bmb01的管控
}     
     #bmb01必須為ima_file中的數據，否則錯誤
     IF NOT cl_null(g_bmb.bmb01) THEN
        LET l_n=0
        SELECT COUNT(*) INTO l_n FROM ima_file
         WHERE ima01=g_bmb.bmb01
        IF l_n=0 THEN
           LET l_errCode='aws-271'
           CALL errZhuhe("bmb_file",l_checkBodyField[1].FIELD,l_checkBodyData[l_detail].DATA,'100',"主件料號"||g_bmb.bmb01||"不存在")
           RETURNING l_errDesc
           RETURN l_errCode,l_errDesc
        END IF
     END IF
     
      #對bmb02的管控
      #對bmb03元件料件的管控
     IF NOT cl_null(g_bmb.bmb03) THEN    #zqj 060722
        #未加對元件料件是否重復的管控，本應由用戶選擇是否接受重復
        CALL i600_bmb03('a')    #必需讀取(料件主檔) #No:7685　　　　#根據此料件帶出相關字段之值
        IF NOT cl_null(g_errno) THEN                        #管控組件料件之來源碼不為Ｚ
           LET l_errCode='aws-259'
           CALL errZhuhe("bmb_file",l_checkBodyField[1].FIELD,l_checkBodyData[l_detail].DATA,g_errno,
                "BOM(主料件"||g_bmb.bmb01||",子料件"||g_bmb.bmb03||")不正確:"||aws_GetErrorInfo(g_errno))
           RETURNING l_errDesc
           RETURN l_errCode,l_errDesc
        END IF
        IF s_bomchk(g_bmb.bmb01,g_bmb.bmb03,g_ima08_h,g_ima08_b) THEN  #檢查產品結構建立是否正確 #返回１不成功則返回
           LET l_errCode='aws-260'
           CALL errZhuhe("bmb_file",l_checkBodyField[1].FIELD,l_checkBodyData[l_detail].DATA,g_errno,
                "BOM(主料件"||g_bmb.bmb01||",子料件"||g_bmb.bmb03||")不正確:"||aws_GetErrorInfo(g_errno))
           RETURNING l_errDesc
           RETURN l_errCode,l_errDesc
        END IF
     END IF
     
       #對bmb04生效日期的管控
     IF NOT cl_null(g_bmb.bmb04) THEN        #geshi
        SELECT count(*) INTO l_n
          FROM bmb_file
         WHERE bmb01 = g_bma.bma01 
           AND bmb02 = g_bmb.bmb02
           AND bmb03 = g_bmb.bmb03 
           AND bmb04 = g_bmb.bmb04
        IF l_n > 0 THEN
           #CALL cl_err('',-239,0)
           LET l_errCode='aws-261'
           CALL errZhuhe("bmb_file",l_checkBodyField[1].FIELD,l_checkBodyData[l_detail].DATA,'-239',
                "BOM(主料件"||g_bmb.bmb01||",子料件"||g_bmb.bmb03||",生效日期"||g_bmb.bmb04||")已經存在")
           RETURNING l_errDesc
           RETURN l_errCode,l_errDesc
        END IF
        CALL i600_bdate('a')
        IF NOT cl_null(g_errno) THEN
            #CALL cl_err(g_bmb[l_ac].bmb04,g_errno,0)  
           LET l_errCode='aws-262'
           CALL errZhuhe("bmb_file",l_checkBodyField[1].FIELD,l_checkBodyData[l_detail].DATA,g_errno,
                "BOM(主料件"||g_bmb.bmb01||",子料件"||g_bmb.bmb03||")錯誤:"||aws_getErrorInfo(g_errno))
           RETURNING l_errDesc
           RETURN l_errCode,l_errDesc
        END IF
     END IF
                    
                    
     #對bmb05失效日期的管控
     IF NOT cl_null(g_bmb.bmb05) THEN
         IF g_bmb.bmb05 IS NOT NULL OR g_bmb.bmb05 != ' ' THEN
             IF g_bmb.bmb05 < g_bmb.bmb04 THEN
                #CALL cl_err(g_bmb[l_ac].bmb05,'mfg2604',0)
                LET l_errCode='aws-263'
                CALL errZhuhe("bmb_file",l_checkBodyField[1].FIELD,
                     l_checkBodyData[l_detail].DATA,'mfg2604',
                     "BOM(主料件"||g_bmb.bmb01||",子料件"||g_bmb.bmb03||")失效日期("||g_bmb.bmb05||")早于生效日期("||
                     g_bmb.bmb04||")")
                RETURNING l_errDesc
                RETURN l_errCode,l_errDesc
             END IF
         END IF                                                        ##check 同一主件，元件，項次的有效日期不重復
         CALL i600_edate('a')     #生效日　　　　　　　　　　　　　　　　　
         IF NOT cl_null(g_errno) THEN 
            #CALL cl_err(g_bmb[l_ac].bmb05,g_errno,0)
            LET l_errCode='aws-264'
            CALL errZhuhe("bmb_file",l_checkBodyField[1].FIELD,l_checkBodyData[l_detail].DATA,g_errno,
                          "BOM(主料件"||g_bmb.bmb01||",子料件"||g_bmb.bmb03||")失效日期("||g_bmb.bmb05||")錯誤:"||aws_getErrorInfo(g_errno))
            RETURNING l_errDesc
            RETURN l_errCode,l_errDesc
         END IF
     END IF
     
     IF NOT cl_null(g_bmb.bmb06) THEN
        IF g_bmb.bmb06<=0 THEN
           LET l_errCode='aws-265'
           CALL errZhuhe("bmb_file",l_checkBodyField[1].FIELD,l_checkBodyData[l_detail].DATA,'value',
                "BOM(主料件"||g_bmb.bmb01||",子料件"||g_bmb.bmb03||")組成用量("||g_bmb.bmb06||")必須大于0")
           RETURNING l_errDesc
           RETURN l_errCode,l_errDesc
        END IF
     END IF
     #LET g_bmb_o.bmb06 = g_bmb.bmb06 
             
       #對bmb07的管控
     IF NOT cl_null(g_bmb.bmb07) THEN
         IF g_bmb.bmb07 <= 0 
          THEN #CALL cl_err(g_bmb[l_ac].bmb07,'mfg2615',0)
            LET l_errCode='aws-266'
            CALL errZhuhe("bmb_file",l_checkBodyField[1].FIELD,l_checkBodyData[l_detail].DATA,'value',
                    "BOM(主料件"||g_bmb.bmb01||",子料件"||g_bmb.bmb03||")底數("||g_bmb.bmb07||")必須大于0")
            RETURNING l_errDesc
            RETURN l_errCode,l_errDesc
         END IF
     END IF
          
           #對bmb08損耗率的管控
     IF NOT cl_null(g_bmb.bmb08) THEN
        IF g_bmb.bmb08<0 OR g_bmb.bmb08>100 THEN
           LET l_errCode='aws-267'
           CALL errZhuhe("bmb_file",l_checkBodyField[1].FIELD,l_checkBodyData[l_detail].DATA,'value',
                     "BOM(主料件"||g_bmb.bmb01||",子料件"||g_bmb.bmb03||")損耗率("||g_bmb.bmb08||")必須介于1到100之間")
           RETURNING l_errDesc
           RETURN l_errCode,l_errDesc
        END IF
     END IF
     
             #由于bmb09應該不會傳至系統，所以無管控#必須存在于ecd_file中的作業
             #對bmb10發料單位的管控
           #由于bmb09應該不會傳至系統，所以無管控#必須存在于ecd_file中的作業
             #對bmb10發料單位的管控
     IF g_bmb.bmb10 IS NULL OR g_bmb.bmb10 = ' ' THEN
        LET g_bmb.bmb10 = g_bmb_o.bmb10
     ELSE 
     	  IF (g_bmb_o.bmb10 IS NULL) OR (g_bmb_t.bmb10 IS NULL)
               OR (g_bmb.bmb10 != g_bmb_o.bmb10) THEN
           CALL i600_bmb10()
           IF NOT cl_null(g_errno) THEN                               #出錯返回
              #CALL cl_err(g_bmb[l_ac].bmb10,g_errno,0)
              LET l_errCode='aws-268'
              CALL cl_getmsg(g_errno,2) RETURNING g_msg
              LET g_msg = g_msg,':1'
              CALL errZhuhe("bmb_file",l_checkBodyField[1].FIELD,g_bmb.bmb03,g_errno,
                            "BOM(主料件"||g_bmb.bmb01||",子料件"||g_bmb.bmb03||")"||g_msg)
              RETURNING l_errDesc
              RETURN l_errCode,l_errDesc
           ELSE 
           	 IF g_bmb.bmb10 != g_ima25_b THEN  
                 LET g_bmb.bmb10=g_ima25_b   #add by bugbin 080811
                 CALL s_umfchk(g_bmb.bmb03,
                       g_bmb.bmb10,g_ima25_b)
                 RETURNING g_sw,g_bmb.bmb10_fac  #發料/庫存單位
                 IF g_sw THEN
                   #CALL cl_err(g_bmb[l_ac].bmb10,'mfg2721',0)　　#若有，返回轉換率給g_bmb10_fac
                   LET l_errCode='aws-269'
                   LET g_msg = "發料單位(",g_bmb.bmb10,")與庫存單位(",g_ima25_b,")換算錯誤"
                   CALL errZhuhe("bmb_file",l_checkBodyField[1].FIELD,g_bmb.bmb03,'mfg2721',
                            "BOM(主料件"||g_bmb.bmb01||",子料件"||g_bmb.bmb03||")"||g_msg)
                   RETURNING l_errDesc
                   RETURN l_errCode,l_errDesc
                 END IF
              ELSE   LET g_bmb.bmb10_fac  = 1
              END  IF
           END IF
        END IF
     END IF
     LET l_detail=l_detail+1
  END WHILE
  RETURN l_errCode,l_errDesc 
END FUNCTION
#********************************************************************************************************
FUNCTION AfterInsertBom(l_sep,l_checkHeadField,l_checkBodyField,l_checkHeadData,l_checkBodydata)
DEFINE l_sep      STRING,
       l_checkHeadField    STRING,
       l_checkHeadData     STRING,
       l_errCode           STRING,
       l_errDesc           STRING
 
DEFINE tok  base.StringTokenizer
      
 
DEFINE l_checkBodyField  DYNAMIC ARRAY OF RECORD
                          FIELD STRING
                         END RECORD
DEFINE l_checkBodyData  DYNAMIC ARRAY OF RECORD
                          DATA  STRING
                          END RECORD
DEFINE count1,count2   SMALLINT
 
INITIALIZE g_bma.*  LIKE bma_file.*
 LET l_errCode=NULL
 LET l_errDesc=NULL
 LET head1 = l_checkHeadField
 
 CALL head2.CLEAR()
 CALL value2.CLEAR()
 LET tok = base.StringTokenizer.createExt(head1,l_sep,"",TRUE)
 LET count1 = tok.countTokens()
   WHILE tok.hasMoreTokens()
      LET i = tok.countTokens()
      LET head2[i] = tok.nextToken()
   END WHILE      
   LET head1 = l_checkHeadData
   LET tok = base.StringTokenizer.CREATEExt(head1,l_sep,"",TRUE)
   WHILE tok.hasMoreTokens()
      LET i = tok.countTokens()
      LET value2[i] = tok.nextToken()
   END WHILE
 
  #將字符串分為一些值表示
  FOR i=1 TO count1       
    CASE head2[i]
       WHEN "bma01"
          LET g_bma.bma01=value2[i]
        #  LET g_bmb.bmb01=value2[i]
       WHEN "bma02"
          LET g_bma.bma02=value2[i]
       WHEN "bma03"
          LET g_bma.bma03=value2[i]
       WHEN "bma04"
          LET g_bma.bma04=value2[i]
       WHEN "bma05"
          LET g_bma.bma05=value2[i]
       WHEN "bmauser"
          LET g_bma.bmauser=value2[i]
       WHEN "bmagrup"
          LET g_bma.bmagrup=value2[i]
       WHEN "bmamodu"
          LET g_bma.bmamodu=value2[i]
       WHEN "bmadate"
          LET g_bma.bmadate=value2[i]
       WHEN "bmaacti"
          LET g_bma.bmaacti=value2[i]
       
    END CASE
  END FOR
 IF cl_null(g_bma.bma05) THEN LET g_bma.bma05 = g_today END IF      
 IF cl_null(g_bma.bmadate) THEN LET g_bma.bmadate = g_today END IF   
  WHILE TRUE   
      IF cl_null(g_bma.bma01) THEN
       # LET l_headc="Y" 
        EXIT WHILE
      ELSE 
      	IF cl_null(g_bma.bma06) THEN
      	   LET g_bma.bma06=' '       
      	END IF
      	SELECT * INTO g_bma.* FROM bma_file
      	 WHERE bma01=g_bma.bma01
      	   AND bma06=g_bma.bma06
      	 LET g_bma.bmauser=g_user
         LET g_bma.bmagrup=g_grup
         LET g_bma.bmadate=g_today
         LET g_bma.bmaacti='Y'   
      	 IF cl_null(g_bma.bma05) THEN
      	    LET g_bma.bma05=g_today
      	 END IF
 
         LET g_bma.bma05=''      #add by bugbin for ck-telecom only
        
 
      	 UPDATE bma_file SET *=g_bma.*
      	    WHERE bma01=g_bma.bma01
              AND bma06=g_bma.bma06
      	 IF SQLCA.SQLCODE THEN
      	    LET l_errCode='aws-270'
            CALL errZhuhe("bma_file",l_checkHeadField,l_checkHeadData,SQLCA.SQLCODE,
                          "BOM(主料件"||g_bma.bma01||")在更新產品結構主件資料(bma_file)時發生錯誤:"||SQLCA.SQLCODE)
            RETURNING l_errDesc
            RETURN l_errCode,l_errDesc
      	  END IF
      	 EXIT WHILE
      END IF
  END WHILE
 
  #對單身的分開賦值處理
  LET l_detail=1
  #每次WHILE插入一條單身記錄，直到l_checkBodyData為空為止
  WHILE (l_checkBodyData[l_detail].DATA IS NOT NULL)
     INITIALIZE g_bmb.* TO NULL
     LET head1 = l_checkBodyField[1].FIELD
     CALL head2.CLEAR()
     CALL value2.CLEAR()
     LET tok = base.StringTokenizer.createExt(head1,l_sep,"",TRUE)
     LET count2 = tok.countTokens()
     WHILE tok.hasMoreTokens()
        LET i = tok.countTokens()
        LET head2[i] = tok.nextToken()
     END WHILE 
     LET head1 = l_checkBodyData[l_detail].DATA
     LET tok = base.StringTokenizer.CREATEExt(head1,l_sep,"",TRUE)
     WHILE tok.hasMoreTokens()
        LET i = tok.countTokens()
        LET value2[i] = tok.nextToken()
     END WHILE  
     
     FOR i=1 TO count2       
        CASE head2[i]
           WHEN "bmb01"
             #LET g_bma.bma01=value2[i]
              LET g_bmb.bmb01=value2[i]
           WHEN "bmb02"
              LET g_bmb.bmb02=value2[i]
           WHEN "bmb03"
              LET g_bmb.bmb03=value2[i]
           WHEN "bmb04"
              LET g_bmb.bmb04=value2[i]
           WHEN "bmb05"
              LET g_bmb.bmb05=value2[i]
           WHEN "bmb06"
              LET g_bmb.bmb06=value2[i]
           WHEN "bmb07"
              LET g_bmb.bmb07=value2[i]
           WHEN "bmb08"
              LET g_bmb.bmb08=value2[i]
           WHEN "bmb10"
              LET g_bmb.bmb10=value2[i]
           WHEN "bmb11"
              LET g_bmb.bmb11=value2[i]
           WHEN "bmb13"
              LET g_bmb.bmb13=value2[i]
           WHEN "bmb16"
              LET g_bmb.bmb16=value2[i]
           #WHEN "bmb_pdm_rowi"
           #   LET g_bmb.bmb_pdm_rowi=value2[i]
           WHEN "bmbmodu"
              LET g_bmb.bmbmodu=value2[i]
           WHEN "bmadate"
              LET g_bmb.bmbdate=value2[i]
           WHEN "bmacomm"
              LET g_bmb.bmbcomm=value2[i]
        END CASE
     END FOR
     
     CALL bmb_default()
     UPDATE bmb_file SET *=g_bmb.*
#     WHERE bmb_pdm_rowi=g_bmb.bmb_pdm_rowi
      WHERE bmb01=g_bmb.bmb01
        AND bmb03=g_bmb.bmb03 
        AND bmb29=g_bmb.bmb29
        AND (bmb04<=TODAY OR bmb04 IS NULL)   #Add By binbin080825
        AND (bmb05> TODAY OR bmb05 IS NULL)   #Add By binbin080825
     LET l_detail=l_detail+1
  END WHILE
     
     
 {    LET l_detail=1
  #每次WHILE插入一條單身記錄，直到l_checkBodyData為空為止
 WHILE (l_checkBodyData[l_detail].DATA IS NOT NULL)
    IF (l_headc="Y")  THEN
       LET l_ignore = l_ignore,l_sep,"Y"
       LET l_detail=l_detail+1
       CONTINUE WHILE
    ELSE
    	 LET l_ignore = l_ignore,l_sep,"N"
       LET l_detail=l_detail+1
       CONTINUE WHILE
    END IF
 END WHILE
 } 
 
   RETURN l_errCode,l_errDesc
 END FUNCTION
 
#********************************************************************************************************  
#=====>此FUNCTION 目的在update 上一筆的失效日
FUNCTION i600_update(p_cmd)
  DEFINE p_cmd     VARCHAR(01),
         l_bmb02   LIKE bmb_file.bmb02,
         l_bmb03   LIKE bmb_file.bmb03,
         l_bmb04   LIKE bmb_file.bmb04,
         l_bmb29   LIKE bmb_file.bmb29
 
    IF p_cmd ='u' THEN 
       #--->更新BOM說明檔(bmc_file)的index key
       UPDATE bmc_file SET bmc02  = g_bmb.bmb02,
                           bmc021 = g_bmb.bmb03,
                           bmc03  = g_bmb.bmb04 
                       WHERE bmc01 = g_bma.bma01
                         AND bmc02 = g_bmb_t.bmb02
                         AND bmc021= g_bmb_t.bmb03
                         AND bmc03 = g_bmb_t.bmb04
                         AND bmc06 = g_bmb_.bmb29
    END IF
    DECLARE i600_update SCROLL CURSOR  FOR
#            SELECT bmb02,bmb03,bmb04,bmb29,rowi FROM bmb_file  #FUN-9A0080
            SELECT bmb02,bmb03,bmb04,bmb29 FROM bmb_file  #FUN-9A0080
                   WHERE bmb01 = g_bma.bma01 AND
                         bmb02 = g_bmb.bmb02  AND
                         bmb29 = g_bmb.bmb29  AND
                         (bmb04 < g_bmb.bmb04)
                   ORDER BY bmb04                        
    OPEN i600_update  
#    FETCH LAST i600_update INTO l_bmb02,l_bmb03,l_bmb04,l_bmb29,g_bmb_rowi  #FUN-9A0080
    FETCH LAST i600_update INTO l_bmb02,l_bmb03,l_bmb04,l_bmb29  #FUN-9A0080
    IF SQLCA.sqlcode = 0
       THEN UPDATE bmb_file SET bmb05 = g_bmb.bmb04,    #
                                bmbdate = g_today     #FUN-C40007 add
                          WHERE bmb01 = g_bma.bma01 AND 
                                bmb02 = l_bmb02 AND 
                                bmb03 = l_bmb03 AND 
                                bmb04 = l_bmb04 AND
                                bmb29 = l_bmb29
            #MESSAGE 'update 上一筆失效日 ok'
    END IF 
    CLOSE i600_update
END FUNCTION 
#*****************************************************************************************************************
FUNCTION  i600_bmb10()
DEFINE l_gfeacti       LIKE gfe_file.gfeacti
 
LET g_errno = ' ' 
 
     SELECT gfeacti INTO l_gfeacti FROM gfe_file 
       WHERE gfe01 = g_bmb.bmb10
 
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg2605'
         WHEN l_gfeacti='N'       LET g_errno = '9028'
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
#******************************************************************************************************************
FUNCTION  i600_edate(p_cmd)
  DEFINE   l_bmb04_i   LIKE bmb_file.bmb04,
           l_bmb04_a   LIKE bmb_file.bmb04,
           p_cmd       VARCHAR(01),
           l_n         SMALLINT
 
    IF p_cmd = 'u' THEN 
       SELECT COUNT(*) INTO l_n FROM bmb_file 
                      WHERE bmb01 = g_bma.bma01         #主件
                        AND bmb02 = g_bmb.bmb02   #項次
       IF l_n =1 THEN RETURN END IF
    END IF
    LET g_errno = " "
    SELECT MIN(bmb04) INTO l_bmb04_i
                       FROM bmb_file
                      WHERE bmb01 = g_bma.bma01         #主件
                       AND  bmb02 = g_bmb.bmb02   #項次
                       AND  bmb04 > g_bmb.bmb04   #生效日
   SELECT MAX(bmb04) INTO l_bmb04_a
                       FROM bmb_file
                      WHERE bmb01 = g_bma.bma01         #主件
                       AND  bmb02 = g_bmb.bmb02   #項次
                       AND  bmb04 > g_bmb.bmb04   #生效日
   IF l_bmb04_i IS NULL THEN RETURN END IF 
   IF g_bmb.bmb05 > l_bmb04_i THEN LET g_errno = 'mfg2738' END IF
END FUNCTION 
#************************************************************************************************************
FUNCTION  i600_bdate(p_cmd)
  DEFINE   l_bmb04_a,l_bmb04_i LIKE bmb_file.bmb04,
           l_bmb05_a,l_bmb05_i LIKE bmb_file.bmb05,
           p_cmd    VARCHAR(01),
           l_n     INTEGER
 
    LET g_errno = " "
    IF p_cmd = 'a' THEN 
       SELECT COUNT(*) INTO l_n FROM bmb_file 
                             WHERE bmb01 = g_bma.bma01         #主件
                               AND  bmb02 = g_bmb.bmb02  #項次
                               AND  bmb04 = g_bmb.bmb04
       IF l_n >= 1 THEN  LET g_errno = 'mfg2737' RETURN END IF
    END IF
    IF p_cmd = 'u' THEN 
       SELECT count(*) INTO l_n FROM bmb_file
                      WHERE bmb01 = g_bma.bma01         #主件
                        AND bmb02 = g_bmb.bmb02   #項次
       IF l_n = 1 THEN RETURN END IF
    END IF
    SELECT MAX(bmb04),MAX(bmb05) INTO l_bmb04_a,l_bmb05_a
                       FROM bmb_file
                      WHERE bmb01 = g_bma.bma01         #主件
                       AND  bmb02 = g_bmb.bmb02   #項次
                       AND  bmb04 < g_bmb.bmb04   #生效日
    IF l_bmb04_a IS NOT NULL AND l_bmb05_a IS NOT NULL
    THEN IF (g_bmb.bmb04 > l_bmb04_a )
            AND (g_bmb.bmb04 < l_bmb05_a)
         THEN LET g_errno = 'mfg2737'
              RETURN 
         END IF
    END IF
    IF g_bmb.bmb04 <  l_bmb04_a THEN 
        LET g_errno = 'mfg2737' 
    END IF
    IF l_bmb04_a IS NULL AND l_bmb05_a IS NULL THEN 
       RETURN 
    END IF
 
    SELECT MIN(bmb04),MIN(bmb05) INTO l_bmb04_i,l_bmb05_i
                       FROM bmb_file
                      WHERE bmb01 = g_bma.bma01         #主件
                       AND  bmb02 = g_bmb.bmb02   #項次
                       AND  bmb04 > g_bmb.bmb04   #生效日
    IF l_bmb04_i IS NULL AND l_bmb05_i IS NULL THEN RETURN END IF
    IF l_bmb04_a IS NULL AND l_bmb05_a IS NULL THEN 
       IF g_bmb.bmb04 < l_bmb04_i THEN 
          LET g_errno = 'mfg2737' 
       END IF
    END IF
    IF g_bmb.bmb04 > l_bmb04_i THEN LET g_errno = 'mfg2737' END IF
END FUNCTION    
#**************************************************************************************************** 
FUNCTION i600_bmb03(p_cmd)
DEFINE
    p_cmd           VARCHAR(1),
    l_ima110        LIKE ima_file.ima110,
    l_ima140        LIKE ima_file.ima140,
    l_imaacti       LIKE ima_file.imaacti,
    l_ima08         LIKE ima_file.ima08,
    l_ima10         LIKE ima_file.ima10
 
    LET g_errno = ' '
    SELECT ima08,ima37,ima25,ima63,ima70,ima105,ima107,
           ima110,ima140,imaacti,ima08,ima10
        INTO g_ima08_b,g_ima37_b,g_ima25_b,g_ima63_b,
             g_ima70_b,g_bmb.bmb27,g_ima107_b,l_ima110,l_ima140,l_imaacti,l_ima08,l_ima10
        FROM ima_file
        WHERE ima01 = g_bmb.bmb03
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                   LET l_imaacti = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    #IF g_ima70_b IS NULL OR g_ima70_b = ' ' THEN 
    #   LET g_ima70_b = 'N'
    #END IF
    #--->來源碼為'Z':雜項料件
    IF g_ima08_b ='Z'
    THEN LET g_errno = 'mfg2752'
         RETURN 
    END IF
 
    #No.9810
    IF l_ima140  ='Y' THEN
       LET g_errno = 'aim-809'
       RETURN
    END IF
    #--
 
    IF g_bmb.bmb27 IS NULL OR g_bmb.bmb27 = ' ' THEN LET g_bmb.bmb27 = 'N' END IF
  # IF p_cmd = 'a' AND cl_null(g_bmb[].bmb19) THEN 
  #No.B237 010326 mod
    IF cl_null(l_ima110) THEN LET l_ima110='1' END IF
    IF p_cmd = 'a' THEN 
  #No.B237 end----
       LET g_bmb.bmb19 = l_ima110
       LET g_bmb.bmb21 = l_ima08
       IF l_ima08 = 'P' THEN LET l_ima08 = 'D' END IF 
       LET g_bmb.bmb26 = l_ima10
    END IF
END FUNCTION
#*************************************************************************************
FUNCTION bmb_default()
IF g_bmb.bmb01 IS NULL OR g_bmb.bmb01='' THEN LET g_bmb.bmb01=g_bma.bma01 END IF
IF g_bmb.bmb15 IS NULL OR g_bmb.bmb15='' THEN LET g_bmb.bmb15='N' END IF
IF g_bmb.bmb21 IS NULL OR g_bmb.bmb21='' THEN 
  SELECT ima08 INTO g_bmb.bmb21 FROM ima_file WHERE ima01=g_bmb.bmb03
  IF g_bmb.bmb21 = 'P' THEN LET g_bmb.bmb21 = 'D' END IF 
END IF 
IF g_bmb.bmb22 IS NULL OR g_bmb.bmb22='' THEN LET g_bmb.bmb22='Y' END IF
IF g_bmb.bmb23 IS NULL OR g_bmb.bmb23='' THEN LET g_bmb.bmb23=100 END IF
IF g_bmb.bmb18 IS NULL OR g_bmb.bmb18='' THEN LET g_bmb.bmb18=0 END IF
IF g_bmb.bmb17 IS NULL OR g_bmb.bmb17='' THEN LET g_bmb.bmb17='N' END IF
IF g_bmb.bmb28 IS NULL OR g_bmb.bmb28='' THEN LET g_bmb.bmb28=0 END IF
  SELECT ima25 INTO g_bmb.bmb10 FROM ima_file WHERE ima01=g_bmb.bmb03
IF g_bmb.bmb10_fac IS NULL OR g_bmb.bmb10_fac='' THEN LET g_bmb.bmb10_fac=1 END IF
IF g_bmb.bmb10_fac2 IS NULL OR g_bmb.bmb10_fac2='' THEN LET g_bmb.bmb10_fac2=1 END IF
IF g_bmb.bmb16 IS NULL OR g_bmb.bmb16='' THEN LET g_bmb.bmb16='2' END IF
IF g_bmb.bmb13='%%' THEN LET g_bmb.bmb13='' END IF
IF g_bmb.bmb14 IS NULL OR g_bmb.bmb14='' THEN LET g_bmb.bmb14='0' END IF
IF g_bmb.bmb04 IS NULL OR g_bmb.bmb04='' THEN LET g_bmb.bmb04=g_today END IF
IF g_bmb.bmb06 IS NULL OR g_bmb.bmb06='' THEN LET g_bmb.bmb06=1 END IF
IF g_bmb.bmb07 IS NULL OR g_bmb.bmb07='' THEN LET g_bmb.bmb07=1 END IF
IF g_bmb.bmb08 IS NULL OR g_bmb.bmb08='' THEN LET g_bmb.bmb08=0 END IF
IF g_bmb.bmb19 IS NULL OR g_bmb.bmb19='' THEN LET g_bmb.bmb19='1' END IF
IF g_bmb.bmb29 IS NULL OR g_bmb.bmb29='' THEN LET g_bmb.bmb29=' ' END IF   #add by binbin 080801
IF g_bmb.bmb33 IS NULL THEN LET g_bmb.bmb33=0 END IF 
LET g_bmb_t.* = g_bmb.*         #新輸入資料
LET g_bmb_o.* = g_bmb.*         #新輸入資料
 
END FUNCTION
#*************************************************************************************************
 
FUNCTION bom_bma01(p_cmd)  #主件料件
    DEFINE p_cmd     VARCHAR(01), 
           l_bmz01   LIKE bmz_file.bmz01,
           l_bmz03   LIKE bmz_file.bmz03,
           l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_ima55   LIKE ima_file.ima55,
           l_ima05   LIKE ima_file.ima05,
           l_imaacti LIKE ima_file.imaacti,
           g_ima08_h LIKE ima_file.ima08
 
    LET g_errno = ' '
## No:2803 modify 1998/11/18 -----------------------------
    SELECT  ima08,imaacti
      INTO g_ima08_h,l_imaacti
      FROM ima_file 
      WHERE ima01 = g_bma.bma01
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg2602'
                                   LET g_ima08_h = NULL
                            LET l_imaacti = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    #--->來源碼為'Z':雜項料件
    IF g_ima08_h ='Z'
    THEN LET g_errno = 'mfg2752'
         RETURN 
    END IF
   
END FUNCTION
 
#********************************************************************************************************
FUNCTION BeforeDeleteBom(l_sep,l_checkHeadField,l_checkBodyField,l_checkHeadData,l_checkBodydata)
DEFINE l_sep      STRING,
       l_checkHeadField    STRING,
       l_checkHeadData     STRING,
       l_errCode           STRING,
       l_errDesc           STRING
DEFINE tok  base.StringTokenizer
      
 
DEFINE l_checkBodyField  DYNAMIC ARRAY OF RECORD
                          FIELD STRING
                         END RECORD
DEFINE l_checkBodyData  DYNAMIC ARRAY OF RECORD
                          DATA  STRING
                          END RECORD
DEFINE count1,count2   SMALLINT
                  
 INITIALIZE g_bma.*  LIKE bma_file.*
 LET l_errCode=NULL
 LET l_errDesc=NULL
 CALL head2.CLEAR()
 CALL value2.CLEAR()                            
 LET head1 = l_checkHeadField
 LET tok = base.StringTokenizer.createExt(head1,l_sep,"",TRUE)
 LET count1 = tok.countTokens()
 WHILE tok.hasMoreTokens()
    LET i = tok.countTokens()
    LET head2[i] = tok.nextToken()
 END WHILE      
 LET head1 = l_checkHeadData
 LET tok = base.StringTokenizer.CREATEExt(head1,l_sep,"",TRUE)
 WHILE tok.hasMoreTokens()
    LET i = tok.countTokens()
    LET value2[i] = tok.nextToken()
 END WHILE
 
  #將字符串分為一些值表示
 FOR i=1 TO count1       
    CASE head2[i]
       WHEN "bma01"
          LET g_bma.bma01=value2[i]
          #LET g_bmb.bmb01=value2[i]
       WHEN "bma02"
          LET g_bma.bma02=value2[i]
       WHEN "bma03"
          LET g_bma.bma03=value2[i]
       WHEN "bma04"
          LET g_bma.bma04=value2[i]
       WHEN "bma05"
          LET g_bma.bma05=value2[i]
       WHEN "bmauser"
          LET g_bma.bmauser=value2[i]
       WHEN "bmagrup"
          LET g_bma.bmagrup=value2[i]
       WHEN "bmamodu"
          LET g_bma.bmamodu=value2[i]
       WHEN "bmadate"
          LET g_bma.bmadate=value2[i]
       WHEN "bmaacti"
          LET g_bma.bmaacti=value2[i]
    END CASE
 END FOR
      
 WHILE TRUE
 #對傳入值的管控
 #對bma01的管控
 
    IF g_bma.bma01 IS NULL OR g_bma.bma01 = ' ' THEN              
       #CALL cl_err('',-400,0)
       LET l_errCode='aws-228'
       CALL errZhuhe("bma_file",l_checkHeadField,l_checkHeadData,'-400',"主料件編號不能為空")
       RETURNING l_errDesc
       RETURN l_errCode,l_errDesc                                
    END IF
     
    IF NOT cl_null(g_bma.bma01) THEN
       LET l_n=0
       SELECT COUNT(*) INTO l_n
         FROM bma_file
        WHERE bma01=g_bma.bma01
       IF l_n=0 THEN
          LET l_errCode='aws-228'
          CALL errZhuhe("bma_file",l_checkHeadField,l_checkHeadData,'100',"BOM(主料件"||g_bma.bma01||")不存在")
          RETURNING l_errDesc
          RETURN l_errCode,l_errDesc 
       END IF
        #被他bom引用的bom 不能被刪掉
       LET l_n=0
       SELECT COUNT(*) INTO l_n
         FROM bmb_file
        WHERE bmb03=g_bma.bma01
       IF l_n>0 THEN
          LET l_errCode='aws-228'
          CALL errZhuhe("bma_file",l_checkHeadField,l_checkHeadData,'value',"BOM(主料件"||g_bma.bma01||")已經被其它BOM引用，不允許刪除")
          RETURNING l_errDesc
          RETURN l_errCode,l_errDesc 
       END IF          
       #考慮參數(sma101) BOM表發放后是否可以修改單身
       #取g_ima08_h
       LET g_errno=' '
       LET g_ima08_h=NULL
       SELECT ima08 INTO g_ima08_h
         FROM ima_file
        WHERE ima01=g_bma.bma01
       CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg2602'
            OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE
       IF NOT cl_null(g_errno) THEN
          LET l_errCode='aws-228'
          CALL errZhuhe("bma_file",l_checkHeadField,l_checkHeadData,g_errno,"主料件"||g_bma.bma01||"不存在")
          RETURNING l_errDesc
          RETURN l_errCode,l_errDesc
       END IF
       IF NOT cl_null(g_bma.bma05) AND g_sma.sma101 = 'N' THEN
          IF g_ima08_h MATCHES '[MPXT]' THEN    #單頭料件來源碼='MPXT'才control
             #CALL cl_err('','abm-120',0)
             LET l_errCode='aws-228'
             CALL errZhuhe("bma_file",l_checkHeadField,l_checkHeadData,'abm-120',"BOM(主料件"||g_bma.bma01||")料件來源碼錯誤,料件來源碼必須是MPXT中的一項")
             RETURNING l_errDesc
             RETURN l_errCode,l_errDesc
          END IF
       END IF
    END IF                         #IF NOT cl_null(bma01)的空
          #存在工單之bom本應詢問是否可以取消，此控制缺，設定可取消
          
          #check此bom記錄是否被鎖
          {SELECT rowi INTO g_bma_rowi FROM bma_file
            WHERE bma01 = g_bma.bma01
          LET g_forupd_sql =
             "SELECT * FROM bma_file WHERE rowi = ? FOR UPDATE "
         LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
         DECLARE i600_cl CURSOR FROM g_forupd_sql
         OPEN i600_cl USING g_bma_rowi
         IF STATUS THEN
             #CALL cl_err("OPEN i600_cl:", STATUS, 1)
             LET l_errid = l_ID
             LET l_errcode = STATUS
             LET l_ignore = "Y"
             LET l_headc="Y"
             CLOSE i600_cl
             EXIT WHILE
         END IF
         FETCH i600_cl INTO g_bma.*
         IF SQLCA.sqlcode THEN 
            #CALL cl_err(g_bma.bma01,SQLCA.sqlcode,0) RETURN 
            LET l_errid = l_ID
            LET l_errcode = SQLCA.SQLCODE
            LET l_ignore = "Y"
            LET l_headc="Y"
            CLOSE i600_cl
            EXIT WHILE
         END IF
         CLOSE i600_cl
         #checkover}
    EXIT WHILE
 END WHILE
         #若刪除單頭，則單身全部刪除,若有傳進來若干個單身check是否存在設定l_ignore
         #check單身
 LET l_detail=1
  #每次WHILE插入一條單身記錄，直到l_checkBodyData為空為止
 WHILE(l_checkBodyData[l_detail].DATA IS NOT NULL)
    INITIALIZE g_bmb.* TO NULL                               
    CALL head2.CLEAR()
    CALL value2.CLEAR()
    LET head1 = l_checkBodyField[l_detail].FIELD
    LET tok = base.StringTokenizer.createExt(head1,l_sep,"",TRUE)
    LET count2 = tok.countTokens()
    WHILE tok.hasMoreTokens()
       LET i = tok.countTokens()
       LET head2[i] = tok.nextToken()
    END WHILE 
    LET head1 = l_checkBodyData[l_detail].DATA
    LET tok = base.StringTokenizer.CREATEExt(head1,l_sep,"",TRUE)
    WHILE tok.hasMoreTokens()
       LET i = tok.countTokens()
       LET value2[i] = tok.nextToken()
    END WHILE  
    
    FOR i=1 TO count2       
     CASE head2[i]
        WHEN "bmb01"
           #LET g_bma.bma01=value2[i]
           LET g_bmb.bmb01=value2[i]
        WHEN "bmb02"
           LET g_bmb.bmb02=value2[i]
        WHEN "bmb03"
           LET g_bmb.bmb03=value2[i]
        WHEN "bmb04"
           LET g_bmb.bmb04=value2[i]
        WHEN "bmb05"
           LET g_bmb.bmb05=value2[i]
        WHEN "bmb06"
           LET g_bmb.bmb06=value2[i]
        WHEN "bmb07"
           LET g_bmb.bmb07=value2[i]
        WHEN "bmb08"
           LET g_bmb.bmb08=value2[i]
        WHEN "bmb10"
           LET g_bmb.bmb10=value2[i]
        WHEN "bmb11"
           LET g_bmb.bmb11=value2[i]
        WHEN "bmb13"
           LET g_bmb.bmb13=value2[i]
        #WHEN "bmb_pdm_rowi"
        #   LET g_bmb.bmb_pdm_rowi=value2[i]
        WHEN "bmbmodu"
           LET g_bmb.bmbmodu=value2[i]
        WHEN "bmadate"
           LET g_bmb.bmbdate=value2[i]
        WHEN "bmacomm"
           LET g_bmb.bmbcomm=value2[i]  
     END CASE
    END FOR
    IF NOT cl_null(g_bmb.bmb01) THEN   
       LET l_n=0
       SELECT COUNT(*) INTO l_n FROM bmb_file
        WHERE bmb01=g_bmb.bmb01
       IF l_n=0 THEN
          LET l_errCode='aws-221'
          CALL errZhuhe("bmb_file",l_checkBodyField[1].FIELD,l_checkBodyData[l_detail].DATA,'100',"BOM(主料件:"||g_bmb.bmb01||")不存在")
          RETURNING l_errDesc
          RETURN l_errCode,l_errDesc
       END IF
    END IF
           
    IF NOT cl_null(g_bmb.bmb02) THEN
       LET l_n=0
     SELECT COUNT(*) INTO l_n FROM bmb_file
      WHERE bmb01=g_bmb.bmb01
        AND bmb02=g_bmb.bmb02 
      IF l_n=0 THEN
         LET l_errCode='aws-221'
         CALL errZhuhe("bmb_file",l_checkBodyField[1].FIELD,l_checkBodyData[l_detail].DATA,'100',
              "BOM(主料件"||g_bmb.bmb01||",子料件"||g_bmb.bmb03||",組合項次"||g_bmb.bmb02||")在系統中不存在")
         RETURNING l_errDesc
         RETURN l_errCode,l_errDesc
      END IF
    END IF
           
    IF NOT cl_null(g_bmb.bmb03) THEN
       LET l_n=0
       SELECT COUNT(*) INTO l_n FROM bmb_file
        WHERE bmb01=g_bmb.bmb01
          AND bmb03=g_bmb.bmb03 
       IF l_n=0 THEN
          LET l_errCode='aws-221'
          CALL errZhuhe("bmb_file",l_checkBodyField[1].FIELD,l_checkBodyData[l_detail].DATA,'100',
          "BOM(主料件"||g_bmb.bmb01||",子料件"||g_bmb.bmb03||")在系統中不存在")
          RETURNING l_errDesc
          RETURN l_errCode,l_errDesc
       END IF
    END IF
    LET l_detail=l_detail+1
 END WHILE
 RETURN l_errCode,l_errDesc
END FUNCTION
#*******************************************************************************************************
FUNCTION AfterDeleteBom(l_sep,l_checkHeadField,l_checkBodyField,l_checkHeadData,l_checkBodydata)
DEFINE l_sep      STRING,
       l_checkHeadField    STRING,
       l_checkHeadData     STRING,
       l_errCode           STRING,
       l_errDesc           STRING
DEFINE tok  base.StringTokenizer
DEFINE l_checkBodyField  DYNAMIC ARRAY OF RECORD
                          FIELD STRING
                         END RECORD
DEFINE l_checkBodyData  DYNAMIC ARRAY OF RECORD
                          DATA  STRING
                          END RECORD
DEFINE count1,count2   SMALLINT
                  
 INITIALIZE g_bma.*  LIKE bma_file.*
 LET l_errCode=NULL
 LET l_errDesc=NULL
 CALL head2.CLEAR()
 CALL value2.CLEAR()                            
 LET head1 = l_checkHeadField
 LET tok = base.StringTokenizer.createExt(head1,l_sep,"",TRUE)
 LET count1 = tok.countTokens()
 WHILE tok.hasMoreTokens()
    LET i = tok.countTokens()
    LET head2[i] = tok.nextToken()
 END WHILE      
 LET head1 = l_checkHeadData
 LET tok = base.StringTokenizer.CREATEExt(head1,l_sep,"",TRUE)
 WHILE tok.hasMoreTokens()
    LET i = tok.countTokens()
    LET value2[i] = tok.nextToken()
 END WHILE
 
  #將字符串分為一些值表示
 FOR i=1 TO count1       
    CASE head2[i]
       WHEN "bma01"
          LET g_bma.bma01=value2[i]
          #LET g_bmb.bmb01=value2[i]
       WHEN "bma02"
          LET g_bma.bma02=value2[i]
       WHEN "bma03"
          LET g_bma.bma03=value2[i]
       WHEN "bma04"
          LET g_bma.bma04=value2[i]
       WHEN "bma05"
          LET g_bma.bma05=value2[i]
       WHEN "bmauser"
          LET g_bma.bmauser=value2[i]
       WHEN "bmagrup"
          LET g_bma.bmagrup=value2[i]
       WHEN "bmamodu"
          LET g_bma.bmamodu=value2[i]
       WHEN "bmadate"
          LET g_bma.bmadate=value2[i]
       WHEN "bmaacti"
          LET g_bma.bmaacti=value2[i]
    END CASE
 END FOR
  
 IF NOT cl_null(g_bma.bma01) THEN
#FUN-9A0080 --BEGIN--
#    SELECT rowi INTO g_bma_rowi
#      FROM bma_file
#     WHERE bma01=g_bma.bma01
#FUN-9A0080 --END--   
    DELETE FROM bmt_file WHERE bmt01=g_bma.bma01
       
    DELETE FROM bmc_file WHERE bmc01=g_bma.bma01
       
    DELETE FROM bml_file WHERE bml02=g_bma.bma01
       
    DELETE FROM bmd_file WHERE bmd08=g_bma.bma01
       
    DELETE FROM bmm_file WHERE bmm01=g_bma.bma01 #---->聯產品
       
    LET g_msg=TIME
    INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,
                         azoplant,azolegal) #FUN-980009 
   # VALUES ('abmi600',g_user,g_today,g_msg,g_bma_rowi,'delete',  #FUN-9A0080 
    VALUES ('abmi600',g_user,g_today,g_msg,g_bma.bma01,'delete',   #FUN-9A0080
            g_plant,g_legal)                #FUN-980009
    INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,
                         azoplant,azolegal) #FUN-980009
    VALUES ('abmi600',g_user,g_today,g_msg,g_bma.bma01,'delete',
            g_plant,g_legal)                #FUN-980009
    IF SQLCA.SQLCODE THEN
       LET l_errCode='aws-228'
       CALL errZhuhe("bma_file",l_checkHeadField,l_checkHeadData,SQLCA.SQLCODE,
                      "BOM(主料件"||g_bma.bma01||")在更新系統重要資料工更改記錄檔案資料(azo_file)時發生錯誤:"||SQLCA.SQLCODE)
       RETURNING l_errDesc
       RETURN l_errCode,l_errDesc
    END IF
 END IF
 RETURN l_errCode,l_errDesc
END FUNCTION
 
FUNCTION aws_getErrorInfo(p_errno)
DEFINE
  p_errno  LIKE ze_file.ze01,
  l_result LIKE ze_file.ze03
 
  SELECT ze03 INTO l_result FROM ze_file WHERE ze01 = p_errno AND ze02 = '2'
  RETURN l_result
END FUNCTION
 
{   
#********************************************************************************** 
#CALL BeforeUpdate(l_ObjectID,l_Sep,rec_dataRec,p_index) RETURNING l_errCode,l_errDesc
FUNCTION BeforeAdjust(l_ObjectID,l_sep,rec_dataRec,p_index)
DEFINE   l_ObjectID   LIKE waa_file.waa01,
         l_sep        STRING,
         l_errCode    STRING, #ze_file中的errcode
         l_errDesc  STRING,   #錯誤的詳細描述
         p_index      SMALLINT,
         rec_dataRec  DYNAMIC ARRAY OF RECORD
            tables        STRING,
            fields        STRING,
            data          STRING,
            body            DYNAMIC ARRAY OF RECORD
               tables        STRING,
               fields        STRING,
               data          STRING,
               detail           DYNAMIC ARRAY OF RECORD
                  tables         STRING,
                  fields         STRING,
                  data           STRING,
                  subdetail        DYNAMIC ARRAY OF RECORD
                     tables           STRING,
                     fields           STRING,
                     data             STRING
                                   END RECORD       
                               END RECORD
                           END RECORD
                       END RECORD,
         rec_data3     RECORD
            tables        STRING,
            fields        STRING,
            data          STRING,
            body            DYNAMIC ARRAY OF RECORD
               tables        STRING,
               fields        STRING,
               data          STRING,
               detail           DYNAMIC ARRAY OF RECORD
                  tables         STRING,
                  fields         STRING,
                  data           STRING,
                  subdetail        DYNAMIC ARRAY OF RECORD
                     tables           STRING,
                     fields           STRING,
                     data             STRING
                                   END RECORD       
                               END RECORD
                           END RECORD
                       END RECORD
DEFINE l_checkHeadField    STRING,
       l_checkHeadData     STRING
DEFINE l_checkBodyField  DYNAMIC ARRAY OF RECORD
                          FILED STRING
                         END RECORD,
        l_checkBodyData  DYNAMIC ARRAY OF RECORD
                          DATA  STRING
                          END RECORD
  #分割符為空就設為默認
  IF cl_null(l_sep) THEN
     LET l_sep = '|'
  END IF
  #接收數據
  LET rec_data3.*=rec_dataRec[p_index].*
  #Update僅僅在ITEM中操作，對BOM的UPDATE在UPDATEBOM接口實現 
  CASE 
     WHEN l_ObjectID="ITEM" OR l_ObjectID="Item" OR l_ObjectID="item"
        IF NOT cl_null(rec_data3.tables) THEN
           IF rec_data3.tables<>"ima_file" AND rec_data3.tables<>"IMA_FILE" THEN
              LET l_errCode="aws-226"
              LET l_errDesc="數據表名稱錯誤(表名：",rec_data3.tables,")"
              RETURN l_errCode,l_errDesc
           END IF
        END IF
        #
        LET l_checkHeadField = rec_data3.fields
        LET l_checkHeadData = rec_data3.data
        LET l_errCode=NULL
        LET l_errDesc=NULL
        CALL BeforeAdjustItem(l_sep,l_checkHeadField,'',l_checkHeadData,'')
        RETURNING l_errCode,l_errDesc
        RETURN l_errCode,l_errDesc
     OTHERWISE
        LET l_errCode="aws-205"
        LET l_errDesc="操作類型碼錯誤"
        RETURN l_errCode,l_errDesc
  END CASE
END FUNCTION
 
#*******************************************************************************************   
#############################################################################################   
 
FUNCTION BeforeAdjustItem(l_sep,l_CheckHeadField,l_checkBodyField,l_checkHeadData,l_checkBodyData)
DEFINE l_sep      STRING,
       l_checkHeadField    STRING,
       l_checkHeadData     STRING,
       l_errCode  STRING,
       l_errDesc  STRING,
       l_misc     STRING,
       count1              SMALLINT
DEFINE l_imzacti           LIKE imz_file.imzacti
DEFINE l_checkBodyField  DYNAMIC ARRAY OF RECORD
                          FILED STRING
                         END RECORD,
        l_checkBodyData  DYNAMIC ARRAY OF RECORD
                          DATA  STRING
                          END RECORD
                          
DEFINE tok base.StringTokenizer
  
 
   INITIALIZE g_ima.* LIKE ima_file.*
   LET g_ima01_t = NULL
   LET g_ima_o.*=g_ima.* 
   LET l_errCode=NULL
   LET l_errDesc=NULL
   LET head1 = l_checkHeadField
   LET tok = base.StringTokenizer.createExt(head1,l_sep,"",TRUE)
   LET count1=tok.countTokens()
   WHILE tok.hasMoreTokens()
      LET i = tok.countTokens()
      LET head2[i] = tok.nextToken()
   END WHILE      
   LET head1 = l_checkHeadData
   LET tok = base.StringTokenizer.createExt(head1,l_sep,"",TRUE)
   WHILE tok.hasMoreTokens()
      LET i = tok.countTokens()
      LET value2[i] = tok.nextToken()
   END WHILE
 
 FOR i=1 TO count1       
    CASE head2[i]
       WHEN "ima01"
          LET g_ima.ima01=value2[i]
       WHEN "ima02"
          LET g_ima.ima02=value2[i]
       WHEN "ima021"
          LET g_ima.ima021=value2[i]
       WHEN "ima06"
          LET g_ima.ima06=value2[i]
       WHEN "ima18"
          LET g_ima.ima18=value2[i]   
       #僅設定可能傳的值
  ##NO.FUN-A20044   --begin
#      WHEN "ima26"
#         LET g_ima.ima26=value2[i]
#      WHEN "ima261"
#         LET g_ima.ima261=value2[i]
#      WHEN "ima262"
#         LET g_ima.ima262=value2[i] 
  ##NO.FUN-A20044   --end
       WHEN "imauser"
          LET g_ima.imauser=value2[i]
       WHEN "imagrup"
          LET g_ima.imagrup=value2[i]
       WHEN "imamodu"
          LET g_ima.imamodu=value2[i]
       WHEN "imadate"
          LET g_ima.imadate=value2[i]
       WHEN "imaacti"
          LET g_ima.imaacti=value2[i]
       WHEN "ima08"
          LET g_ima.ima08=value2[i]
       WHEN "ima13"
          LET g_ima.ima13=value2[i]
       WHEN "ima14"
          LET g_ima.ima14=value2[i]
       WHEN "ima903"
          LET g_ima.ima903=value2[i]
       WHEN "ima15"
          LET g_ima.ima15=value2[i]
       WHEN "ima109"
          LET g_ima.ima109=value2[i]
       WHEN "ima105"
          LET g_ima.ima105=value2[i]
       WHEN "ima70"
          LET g_ima.ima70=value2[i]
       WHEN "ima09"
          LET g_ima.ima09=value2[i]
       WHEN "ima10"
          LET g_ima.ima10=value2[i]
       WHEN "ima11"
          LET g_ima.ima11=value2[i]
       WHEN "ima12"
          LET g_ima.ima12=value2[i]
       WHEN "ima25"
          LET g_ima.ima25=value2[i]
       WHEN "ima35"
          LET g_ima.ima35=value2[i]
       WHEN "ima36"
          LET g_ima.ima36=value2[i]
       WHEN "ima23"
          LET g_ima.ima23=value2[i]
       WHEN "ima07"
          LET g_ima.ima07=value2[i]
       WHEN "ima39"
          LET g_ima.ima39=value2[i]
    END CASE
     
  END FOR
  
  IF g_ima.ima01 IS NULL THEN
     #CALL cl_err('',-400,0)
     LET l_errCode='aws-210'
     CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'-400',"料件編號不能為空")
     RETURNING l_errDesc
     RETURN l_errCode,l_errDesc
  END IF
  
  IF g_ima.ima01<>'%%' THEN
     SELECT imaacti INTO g_ima.imaacti FROM ima_file WHERE ima01=g_ima.ima01
     IF g_ima.imaacti ='N' THEN    #檢查資料是否為無效
        #CALL cl_err(g_ima.ima01,'mfg1000',0)
        LET l_errCode='aws-210'
        CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1000',"物料("||g_ima.ima01||")為無效料件")
        RETURNING l_errDesc
        RETURN l_errCode,l_errDesc
     END IF
  END IF
        
  #ima01不能為空且不能被更改若key在DB中不存在
  IF NOT cl_null(g_ima.ima01) THEN
# Removed By Johnson 060810  
     IF g_ima.ima01<>"%%" THEN
        LET l_n=0
        SELECT count(*) INTO l_n FROM ima_file
         WHERE ima01 = g_ima.ima01
        IF l_n = 0 THEN      
           #CALL cl_err(g_ima.ima01,-400,0)
           LET l_errCode='aws-210'
           CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'-400',"料件編號"||g_ima.ima01||"不存在")
           RETURNING l_errDesc
           RETURN l_errCode,l_errDesc
        END IF
     END IF  
     
  END IF
  
  #對分群碼的管控，且由分群碼帶出相關字段的值
  IF g_ima.ima06 IS NOT NULL AND  g_ima.ima06 != ' ' AND g_ima.ima06 <>'%%' THEN
     SELECT imzacti INTO l_imzacti
       FROM imz_file
      WHERE imz01 = g_ima.ima06    
     CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3179'
          WHEN l_imzacti='N' LET g_errno = '9028'
          OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
  END IF
  IF NOT cl_null(g_errno) THEN
     LET l_errCode='aws-210'
     CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,g_errno,
                   "物料("||g_ima.ima01||")主分群碼("||g_ima.ima06 CLIPPED||")為空或不存在")
     RETURNING l_errDesc
     RETURN l_errCode,l_errDesc
  END IF
  
             #對ima08的管控
  IF (NOT cl_null(g_ima.ima08)) AND (g_ima.ima08<>'%%') THEN 
     IF g_ima.ima08 NOT MATCHES "[CTDAMPXKUVZS]" 
         OR g_ima.ima08 IS NULL 
        THEN 
        #CALL cl_err(g_ima.ima08,'mfg1001',0)
        LET l_errCode='aws-210'
        CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1001',
                      "物料("||g_ima.ima01||")來源碼("||g_ima.ima08||")錯誤,"||aws_getErrorInfo('mfg1001'))
        RETURNING l_errDesc
        RETURN l_errCode,l_errDesc
     END IF
     LET l_misc=g_ima.ima01[1,4]     
     IF l_misc='MISC' AND g_ima.ima08 <>'Z' THEN
        #CALL cl_err('','aim-805',0)
        LET l_errCode='aws-210'
        CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'-400',"雜項料件(料件編號為MISC)的來源碼必須為Z")
        RETURNING l_errDesc
        RETURN l_errCode,l_errDesc
     END IF
  END IF
            
  #對ima13的管控
  IF (NOT cl_null(g_ima.ima13)) AND (g_ima.ima13<>'%%') THEN
     IF (g_ima.ima08 = 'T') AND (g_ima.ima13 IS NULL 
               OR g_ima.ima13 = ' ' )
       THEN #CALL cl_err(g_ima.ima13,'mfg1327',0)
        LET l_errCode='aws-210'
        CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'-400',
                      "物料("||g_ima.ima01||")規格組件料件編號(ima13)欄位,"||aws_getErrorInfo('mfg1327'))
        RETURNING l_errDesc
        RETURN l_errCode,l_errDesc
     END IF
     IF g_ima.ima18 IS NOT NULL THEN 
        IF (g_ima_o.ima13 IS NULL ) OR (g_ima_o.ima13 != g_ima.ima13) THEN
           SELECT ima08 FROM ima_file 
            WHERE ima01 = g_ima.ima13
              AND ima08 matches 'C'     
              AND imaacti matches'[Yy]'
           IF SQLCA.sqlcode != 0 THEN 
              #CALL #cl_err(g_ima.ima13,'mfg1328',0)
               LET l_errCode='aws-210'
               CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1328',
                             "物料("||g_ima.ima01||")規格組件料件編號(ima13)欄位,"||aws_getErrorInfo('mfg1328'))
               RETURNING l_errDesc
               RETURN l_errCode,l_errDesc
           END IF
        END IF
     END IF
  END IF
           
          #對ima14#工程料件的管控
  IF (NOT cl_null(g_ima.ima14)) AND (g_ima.ima14<>'%%') THEN
     IF g_ima.ima14 NOT MATCHES "[YN]" THEN
        #CALL cl_err(g_ima.ima14,'mfg1002',0)
        LET l_errCode='aws-210'
        CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1002',
                      "物料("||g_ima.ima01||")是否為工程料件(ima14)欄位,值("||g_ima.ima14||"),"||aws_getErrorInfo('mfg1002'))
        RETURNING l_errDesc
        RETURN l_errCode,l_errDesc
     END IF
  END IF
            
  #對ima903的管控可否做聯產品入庫
  IF (NOT cl_null(g_ima.ima903)) AND g_ima.ima903<>'%%' THEN
     IF g_ima.ima903 NOT MATCHES "[YN]" THEN
        #CALL cl_err(g_ima.ima903,'mfg1002',0)
        LET l_errCode='aws-210'
        CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1002',
                      "物料("||g_ima.ima01||")是否作聯產品入庫(ima903)欄位,值("||g_ima.ima903||"),"||aws_getErrorInfo('mfg1002'))
        RETURNING l_errDesc
        RETURN l_errCode,l_errDesc
     END IF
  END IF
            
  #對ima24的 #檢驗否 管控缺
  #對ima107，ima147的管控缺
  #對ima15的#保稅料件管控
  IF (NOT cl_null(g_ima.ima15)) AND g_ima.ima15<>'%%'THEN
     IF g_ima.ima15 NOT MATCHES "[YN]" THEN
        #CALL cl_err(g_ima.ima15,'mfg1002',0)
        LET l_errCode='aws-210'
        CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1002',
                      "物料("||g_ima.ima01||")保稅與否取值錯誤,值("||g_ima.ima15||"),"||aws_getErrorInfo('mfg1002'))
        RETURNING l_errDesc
        RETURN l_errCode,l_errDesc
     END IF
  END IF
           
  #對ima109的管控
  IF (NOT cl_null(g_ima.ima109)) AND g_ima.ima109<>'%%' THEN
     IF (g_ima_o.ima109 IS NULL) OR (g_ima.ima109 != g_ima_o.ima109) THEN
        SELECT azf01 FROM azf_file 
         WHERE azf01=g_ima.ima109 AND azf02='8'
           AND azfacti='Y'
        IF SQLCA.sqlcode  THEN
           #CALL cl_err(g_ima.ima109,'mfg1306',0)
          LET l_errCode='aws-210'
          CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1306',
                        "物料("||g_ima.ima01||")可否做聯產品入庫取值錯誤,值("||g_ima.ima903||"),"||aws_getErrorInfo('mfg1306')
          RETURNING l_errDesc
          RETURN l_errCode,l_errDesc
        END IF
     END IF
  END IF
            
            #對ima105的管控
  IF (NOT cl_null(g_ima.ima105)) AND g_ima.ima105<>'%%' THEN
     IF g_ima.ima105 NOT MATCHES "[YN]" THEN
        #CALL cl_err(g_ima.ima105,'mfg1002',0)
         LET l_errCode='aws-210'
         CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1002',
                       "物料("||g_ima.ima01||")是否為軟體物件取值錯誤,值("||g_ima.ima105||"),"||aws_getErrorInfo('mfg1002'))
         RETURNING l_errDesc
         RETURN l_errCode,l_errDesc
     END IF
  END IF
  
  #對ima70的管控
  IF (NOT cl_null(g_ima.ima70)) AND g_ima.ima70<>'%%' THEN 
     IF g_ima.ima70 NOT MATCHES '[YN]' THEN
        #CALL cl_err(g_ima.ima70,'mfg1002',0) 
        LET l_errCode='aws-210'
        CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1306',
                      "物料("||g_ima.ima01||")材料類型錯誤,值("||g_ima.ima70||"),"||aws_getErrorInfo('mfg1306'))
        RETURNING l_errDesc
        RETURN l_errCode,l_errDesc
     END IF
  END IF
               
  #對ima09的管控#其他分群碼一
  IF (g_ima.ima09 IS NOT NULL AND g_ima.ima09 != ' ') AND (g_ima.ima09<>'%%') THEN
     SELECT azf01 FROM azf_file 
      WHERE azf01=g_ima.ima09 AND azf02='D' #6818
        AND azfacti='Y'
     IF SQLCA.sqlcode  THEN
        #CALL cl_err(g_ima.ima09,'mfg1306',0)
        LET l_errCode='aws-210'
        CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1306',
                      "物料("||g_ima.ima01||")其他分群碼一("||g_ima.ima09||")在系統中未定義")
        RETURNING l_errDesc
        RETURN l_errCode,l_errDesc
     END IF
  END IF
           
           #對ima10的管控#其他分群碼二
  IF (g_ima.ima10 IS NOT NULL AND g_ima.ima10 != ' ') AND (g_ima.ima10<>'%%') THEN
     SELECT azf01 FROM azf_file 
     WHERE azf01=g_ima.ima10 AND azf02='E' #6818
       AND azfacti='Y'
     IF SQLCA.sqlcode  THEN
        #CALL cl_err(g_ima.ima10,'mfg1306',0)
        LET l_errCode='aws-210'
        CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1306',
                      "物料("||g_ima.ima01||")其他分群碼二("||g_ima.ima10||")在系統中未定義")
        RETURNING l_errDesc
        RETURN l_errCode,l_errDesc
     END IF
  END IF
           
  #對ima11的管控其他分群碼三
  IF (g_ima.ima11 IS NOT NULL AND g_ima.ima11 != ' ') AND (g_ima.ima11<>'%%') THEN
     SELECT azf01 FROM azf_file 
      WHERE azf01=g_ima.ima11 AND azf02='F' #6818
        AND azfacti='Y'
     IF SQLCA.sqlcode  THEN
        #CALL cl_err(g_ima.ima11,'mfg1306',0)
        LET l_errCode='aws-210'
        CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1306',
                      "物料("||g_ima.ima01||")其他分群碼三("||g_ima.ima11||")在系統中未定義")
        RETURNING l_errDesc
        RETURN l_errCode,l_errDesc
     END IF
       #END IF #No:7062
  END IF
            
            #對ima12的管控#其他分群碼四
  IF (g_ima.ima12 IS NOT NULL AND g_ima.ima12 != ' ') AND (g_ima.ima12<>'%%')
     THEN 
          #No:7062
          #IF (g_ima_o.ima12 IS NULL) OR (g_ima_o.ima12 != g_ima.ima12) THEN
     SELECT azf01 FROM azf_file 
     WHERE azf01=g_ima.ima12 AND azf02='G' #6818
       AND azfacti='Y'
     IF SQLCA.sqlcode  THEN
        #CALL cl_err(g_ima.ima12,'mfg1306',0)
        LET l_errCode='aws-210'
        CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1306',
                      "物料("||g_ima.ima01||")其他分群碼四("||g_ima.ima12||")在系統中未定義")
        RETURNING l_errDesc
        RETURN l_errCode,l_errDesc
     END IF
          #END IF #No:7062
  END IF
      
      #對ima25的判斷庫存單位
  IF (NOT cl_null(g_ima.ima25)) AND g_ima.ima25<>'%%' THEN
     SELECT gfe01 FROM gfe_file 
     WHERE gfe01=g_ima.ima25 
       AND gfeacti matches'[Yy]'
     IF SQLCA.sqlcode THEN 
        #CALL cl_err(g_ima.ima25,'mfg1200',0)
        LET l_errCode='aws-210'
        CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1200',
                      "物料("||g_ima.ima01||")庫存單位，值("||g_ima.ima25||")在系統中未定義")
        RETURNING l_errDesc
        RETURN l_errCode,l_errDesc
     END IF
  END IF
            
            #對ima35的管控
  IF (g_ima.ima35 !=' ' AND g_ima.ima35 IS NOT NULL) AND g_ima.ima35<>'%%' THEN
     #No.B052 010326 by plum
     #SELECT * FROM imd_file WHERE imd01=g_ima.ima35
     SELECT * FROM imd_file WHERE imd01=g_ima.ima35 AND imdacti='Y'
     IF SQLCA.SQLCODE THEN 
        #CALL cl_err(g_ima.ima35,'mfg1100',0)
         LET l_errCode='aws-210'
         CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1100',
                       "物料("||g_ima.ima01||")主要倉庫，值("||g_ima.ima35||")在系統中未定義")
         RETURNING l_errDesc
         RETURN l_errCode,l_errDesc
     END IF
  END IF 
  
  #對ima36的管控
  IF (g_ima.ima36 !=' ' AND g_ima.ima36 IS NOT NULL) AND g_ima.ima36<>'%%' THEN
     SELECT * FROM ime_file WHERE ime01=g_ima.ima35 
        AND ime02=g_ima.ima36
     IF SQLCA.SQLCODE THEN 
        #CALL cl_err(g_ima.ima36,'mfg1101',0)
        LET l_errCode='aws-210'
        CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg1101',
                      "物料("||g_ima.ima01||")主要庫位別，值("||g_ima.ima36||")在系統中未定義")
        RETURNING l_errDesc
        RETURN l_errCode,l_errDesc
     END IF
  END IF
  
  #對ima23的管控
  IF (NOT cl_null(g_ima.ima23)) AND g_ima.ima23<>'%%' THEN
     LET g_gen02 = ""                         #BUG-4A0326
    #SELECT * FROM gen_file                   #BUG-4A0326
     SELECT gen02 INTO g_gen02 FROM gen_file  #BUG-4A0326
      WHERE gen01=g_ima.ima23
        AND genacti='Y'
     IF SQLCA.SQLCODE THEN 
        #CALL cl_err(g_ima.ima23,'aoo-001',0)
        LET l_errCode='aws-210'
        CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'aoo-001',
                      "物料("||g_ima.ima01||")倉管員，值("||g_ima.ima23||")在系統中未定義")
        RETURNING l_errDesc
        RETURN l_errCode,l_errDesc
     END IF
  END IF
             
             
  #對ima07的管控#ABC 碼
  IF (NOT cl_null(g_ima.ima07)) AND g_ima.ima07<>'%%' THEN
     IF g_ima.ima07 NOT MATCHES'[ABC]' THEN
         #CALL cl_err(g_ima.ima07,'mfg0009',0)
        LET l_errCode='aws-210'
        CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'mfg0009',
                      "物料("||g_ima.ima01||")ABC碼錯誤,值("||g_ima.ima07||"),"||aws_getErrorInfo('mfg0009'))
        RETURNING l_errDesc
        RETURN l_errCode,l_errDesc
     END IF
  END IF
           
  #對ima37的管控缺
  #對ima51>0ima52>0的控制缺
  #對ima39的管控
  IF (NOT cl_null(g_ima.ima39) OR g_ima.ima39 != ' ') AND g_ima.ima39<>'%%' THEN 
      SELECT count(*) INTO l_n FROM aag_file 
             WHERE aag01 = g_ima.ima39   
               AND aag07 != '1'  #No:8400 #BUG-490065將aag071改為aag07
      IF l_n=0 THEN     # Unique 
           #CALL cl_err(g_ima.ima39,100,0)
         LET l_errCode='aws-210'
         CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'100',
                       "物料("||g_ima.ima01||")所屬會計科目,值("||g_ima.ima39||")在系統中未定義")
         RETURNING l_errDesc
         RETURN l_errCode,l_errDesc
      END IF
  END IF
  
  RETURN l_errCode,l_errDesc
  
  #對ima18單位重量無管控
END FUNCTION
}     
#****************************************************************
#CALL AfterAdjust(l_ObjectID,l_Sep,rec_data,p_index) RETURNING l_errCode,l_errDesc
{FUNCTION AfterAdjust(l_ObjectID,l_Sep,rec_dataRec,p_index)
DEFINE   l_ObjectID   LIKE waa_file.waa01,
         l_sep        STRING,
         l_errCode    STRING, #ze_file中的errcode
         l_errDesc  STRING,   #錯誤的詳細描述
         p_index      SMALLINT,
         rec_dataRec  DYNAMIC ARRAY OF RECORD
            tables        STRING,
            fields        STRING,
            data          STRING,
            body            DYNAMIC ARRAY OF RECORD
               tables        STRING,
               fields        STRING,
               data          STRING,
               detail           DYNAMIC ARRAY OF RECORD
                  tables         STRING,
                  fields         STRING,
                  data           STRING,
                  subdetail        DYNAMIC ARRAY OF RECORD
                     tables           STRING,
                     fields           STRING,
                     data             STRING
                                   END RECORD       
                               END RECORD
                           END RECORD
                       END RECORD,
         rec_data3     RECORD
            tables        STRING,
            fields        STRING,
            data          STRING,
            body            DYNAMIC ARRAY OF RECORD
               tables        STRING,
               fields        STRING,
               data          STRING,
               detail           DYNAMIC ARRAY OF RECORD
                  tables         STRING,
                  fields         STRING,
                  data           STRING,
                  subdetail        DYNAMIC ARRAY OF RECORD
                     tables           STRING,
                     fields           STRING,
                     data             STRING
                                   END RECORD       
                               END RECORD
                           END RECORD
                       END RECORD
DEFINE l_checkHeadField    STRING,
       l_checkHeadData     STRING
DEFINE l_checkBodyField  DYNAMIC ARRAY OF RECORD
                          FILED STRING
                         END RECORD,
        l_checkBodyData  DYNAMIC ARRAY OF RECORD
                          DATA  STRING
                          END RECORD
  #分割符為空就設為默認
  IF cl_null(l_sep) THEN
     LET l_sep = '|'
  END IF
  #接收數據
  LET rec_data3.*=rec_dataRec[p_index].*
  #Update僅僅在ITEM中操作，對BOM的UPDATE在UPDATEBOM接口實現 
  CASE 
     WHEN l_ObjectID="ITEM" OR l_ObjectID="Item" OR l_ObjectID="item"
        IF NOT cl_null(rec_data3.tables) THEN
           IF rec_data3.tables<>"ima_file" AND rec_data3.tables<>"IMA_FILE" THEN
              LET l_errCode="aws-226"
              LET l_errDesc="數據表名稱錯誤(表名：",rec_data3.tables,")"
              RETURN l_errCode,l_errDesc
           END IF
        END IF
        #
        LET l_checkHeadField = rec_data3.fields
        LET l_checkHeadData = rec_data3.data
        LET l_errCode=NULL
        LET l_errDesc=NULL
        CALL AfterUpdateItem(l_sep,l_checkHeadField,'',l_checkHeadData,'')
        RETURNING l_errCode,l_errDesc
        RETURN l_errCode,l_errDesc
     OTHERWISE
        LET l_errCode="aws-205"
        LET l_errDesc="操作類型碼錯誤"
        RETURN l_errCode,l_errDesc
  END CASE
END FUNCTION                       
 
#*********************************************************************************************
FUNCTION AfterAdjustItem(l_sep,l_CheckHeadField,l_checkBodyField,l_checkHeadData,l_checkBodyData)
DEFINE l_sep      STRING,
       l_checkHeadField    STRING,
       l_checkHeadData     STRING,
       l_errCode STRING,
       l_errDesc STRING,
       count1              SMALLINT
DEFINE l_imzacti           LIKE imz_file.imzacti
 
 
DEFINE l_checkBodyField  DYNAMIC ARRAY OF RECORD
                          FILED STRING
                         END RECORD,
        l_checkBodyData  DYNAMIC ARRAY OF RECORD
                          DATA  STRING
                          END RECORD
DEFINE tok base.StringTokenizer
  
 
 INITIALIZE g_ima.* LIKE ima_file.*
 LET g_ima01_t = NULL
 LET g_ima_o.*=g_ima.* 
 LET l_errCode=NULL
 LET l_errDesc=NULL
 LET head1 = l_checkHeadField
 LET tok = base.StringTokenizer.createExt(head1,l_sep,"",TRUE)
 LET count1=tok.countTokens()
 WHILE tok.hasMoreTokens()
    LET i = tok.countTokens()
    LET head2[i] = tok.nextToken()
 END WHILE      
 LET head1 = l_checkHeadData
 LET tok = base.StringTokenizer.createExt(head1,l_sep,"",TRUE)
 WHILE tok.hasMoreTokens()
    LET i = tok.countTokens()
    LET value2[i] = tok.nextToken()
 END WHILE
 
 FOR i=1 TO count1       
    CASE head2[i]
       WHEN "ima01"
          LET g_ima.ima01=value2[i]
       WHEN "ima02"
          LET g_ima.ima02=value2[i]
       WHEN "ima021"
          LET g_ima.ima021=value2[i]
       WHEN "ima06"
          LET g_ima.ima06=value2[i]
       WHEN "ima18"
          LET g_ima.ima18=value2[i]   
       #僅設定可能傳的值
  ##NO.FUN-A20044   --begin
#      WHEN "ima26"
#         LET g_ima.ima26=value2[i]
#      WHEN "ima261"
#         LET g_ima.ima261=value2[i]
#      WHEN "ima262"
#         LET g_ima.ima262=value2[i] 
  ##NO.FUN-A20044   --end
       WHEN "imauser"
          LET g_ima.imauser=value2[i]
       WHEN "imagrup"
          LET g_ima.imagrup=value2[i]
       WHEN "imamodu"
          LET g_ima.imamodu=value2[i]
       WHEN "imadate"
          LET g_ima.imadate=value2[i]
       WHEN "imaacti"
          LET g_ima.imaacti=value2[i]
       WHEN "ima08"
          LET g_ima.ima08=value2[i]
       WHEN "ima13"
          LET g_ima.ima13=value2[i]
       WHEN "ima14"
          LET g_ima.ima14=value2[i]
       WHEN "ima903"
          LET g_ima.ima903=value2[i]
       WHEN "ima15"
          LET g_ima.ima15=value2[i]
       WHEN "ima109"
          LET g_ima.ima109=value2[i]
       WHEN "ima105"
          LET g_ima.ima105=value2[i]
       WHEN "ima70"
          LET g_ima.ima70=value2[i]
       WHEN "ima09"
          LET g_ima.ima09=value2[i]
       WHEN "ima10"
          LET g_ima.ima10=value2[i]
       WHEN "ima11"
          LET g_ima.ima11=value2[i]
       WHEN "ima12"
          LET g_ima.ima12=value2[i]
       WHEN "ima25"
          LET g_ima.ima25=value2[i]
       WHEN "ima35"
          LET g_ima.ima35=value2[i]
       WHEN "ima36"
          LET g_ima.ima36=value2[i]
       WHEN "ima23"
          LET g_ima.ima23=value2[i]
       WHEN "ima07"
          LET g_ima.ima07=value2[i]
       WHEN "ima39"
          LET g_ima.ima39=value2[i]
    END CASE
 END FOR
  
 IF g_ima.ima01 IS NULL THEN
       #CALL cl_err('',-400,0)
      LET l_errCode='aws-210'
      CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,'-400',"料件編號不能為空")
      RETURNING l_errDesc
      RETURN l_errCode,l_errDesc
 END IF
#FUN-9A0080 --BEGIN--
# SELECT rowi INTO g_ima_rowi 
#   FROM ima_file
#  WHERE ima01=g_ima.ima01 
#FUN-9A0080 --END--

 LET g_errno = TIME
 LET g_msg = 'Chg No:',g_ima.ima01
 INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,
                       azoplant,azolegal) #FUN-980009
   # VALUES ('aimi100',g_user,g_today,g_errno,g_ima_rowi,g_msg,  #FUN-9A0080
    VALUES ('aimi100',g_user,g_today,g_errno,g_ima.ima01,g_msg,  #FUN-9A0080
            g_plant,g_legal)              #FUN-980009
 IF SQLCA.sqlcode THEN
     #CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
    LET l_errCode='aws-210'
    CALL errZhuhe("ima_file",l_checkHeadField,l_checkHeadData,SQLCA.SQLCODE,
                  "物料("||g_ima.ima01||")在更新系統重要資料工更改記錄檔案資料(azo_file)時發生錯誤:"||SQLCA.SQLCODE)
    RETURNING l_errDesc
    RETURN l_errCode,l_errDesc
 ELSE 
 	 RETURN l_errCode,l_errDesc
 END IF
        
END FUNCTION
 
} 
