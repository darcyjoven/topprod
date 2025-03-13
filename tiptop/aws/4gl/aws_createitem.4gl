# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aws_CreatItem()
# Date & Author..: by binbin 08/10/27
# Modify.........: 新建 FUN-8A0122 by binbin
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔 
 
FUNCTION aws_createitem()
DEFINE 
  ObjectID   LIKE wam_file.wam01,
  Operate    LIKE wam_file.wam02,
  Seperator  STRING,
  Ignore     STRING,
  DateFormat STRING,
  i          SMALLINT,
  l_errCode  STRING,
  l_errDesc  STRING,
  l_errTot   STRING
 
  #檢查服務私有參數列表中是否包含ObjectId的定義,如果沒有則使用全局變量                                                                                   
  LET ObjectID = FindValue("ObjectID",SParam)                                
  IF cl_null(ObjectID) THEN                                                   
     LET ObjectID = g_ObjectID                                                
  END IF                                                                        
  #獲得Operate操作類型參數                                                      
  LET Operate = FindValue("Operate",SParam)  
 
  #檢查服務私有參數列表中是否包含Seperator的定義,如果沒有則使用全局變量                                                                                     
  LET Seperator = FindValue("Separator",SParam)                                    
  IF cl_null(Seperator) THEN                                                        
     LET Seperator = g_Separator                                                    
  END IF  
 
  #檢查服務私有參數列表中是否包含IgnoreError的定義,如果沒有則使用全局變量                                                                                  
  LET Ignore = FindValue("IgnoreError",SParam)                               
  IF cl_null(Ignore) THEN                                                     
     LET Ignore = g_IgnoreError                                               
  END IF   
  
  #檢查服務私有參數列表中是否包含DateFormat的定義,如果沒有則使用全局變量                                                                                    
  LET DateFormat = FindValue("DateFormat",SParam)                            
  IF cl_null(DateFormat) THEN                                                 
     LET DateFormat = g_DateFormat                                            
  END IF  
 
  BEGIN WORK
  LET l_errTot = ''
  FOR i=1 TO pub_data.getLength()
 
         CALL BeforeInsertItemCheck(ObjectID,Operate,Seperator,pub_data,i) RETURNING l_errCode,l_errDesc
 
         IF NOT cl_null(l_errCode) THEN 
            LET l_errTot = l_errTot,l_errDesc
            ROLLBACK WORK 
            LET l_errCode =''
            IF Ignore = 'N' THEN
               RETURN l_errCode,l_errTot
            ELSE 
               BEGIN WORK
            END IF
         ELSE 
            CALL DB_InsertItem(ObjectID,Seperator,pub_data,i,DateFormat) RETURNING l_errCode,l_errDesc
            IF NOT cl_null(l_errCode) THEN 
               LET l_errTot = l_errTot,l_errDesc
               ROLLBACK WORK 
               LET l_errCode =''
               IF Ignore = 'N' THEN
                  RETURN l_errCode,l_errTot
               ELSE 
                  BEGIN WORK
               END IF
            ELSE            
               CALL AfterInsertItemCheck(ObjectID,Operate,Seperator,pub_data,i) RETURNING l_errCode,l_errDesc
               IF NOT cl_null(l_errCode) THEN 
                  LET l_errTot = l_errTot,l_errDesc
                  ROLLBACK WORK 
                  LET l_errCode =''
                  IF Ignore = 'N' THEN
                     RETURN l_errCode,l_errTot
                  ELSE 
                     BEGIN WORK
                  END IF
               ELSE 
                  IF Ignore = 'Y' THEN 
                     COMMIT WORK
                     BEGIN WORK
                  END IF    
               END IF 
            END IF 
         END IF     
  END FOR 
  COMMIT WORK
  IF NOT cl_null(l_errTot) THEN 
     RETURN 'aws-260',l_errTot
  ELSE 
     RETURN '',''
  END IF 
 
END FUNCTION
 
FUNCTION BeforeInsertItemCheck(ObjectID,Operate,Seperator,Data,i)
DEFINE 
  ObjectID  LIKE wam_file.wam01,
  Operate   LIKE wam_file.wam02,
  Seperator STRING,
  Data          DYNAMIC ARRAY OF RECORD
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
  DateFormat STRING,
  i          SMALLINT 
 
   DISPLAY 'Before check OK!'
   RETURN '',''
END FUNCTION
 
FUNCTION AfterInsertItemCheck(ObjectID,Operate,Seperator,Data,i)
DEFINE 
  ObjectID  LIKE wam_file.wam01,
  Operate   LIKE wam_file.wam02,
  Seperator STRING,
  Data          DYNAMIC ARRAY OF RECORD
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
  i          SMALLINT 
 
   DISPLAY 'After check OK!'
   RETURN '',''
END FUNCTION
 
FUNCTION DB_InsertItem(ObjectID,Seperator,Data,i,DateFormat)
DEFINE 
  ObjectID  LIKE wam_file.wam01,
  Operate   LIKE wam_file.wam02,
  Seperator STRING,
  Data          DYNAMIC ARRAY OF RECORD
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
  DateFormat STRING,
  i          SMALLINT 
 
   DISPLAY 'Insert OK!'
   RETURN '',''
END FUNCTION
# No.FUN-8A0122 by binbin
