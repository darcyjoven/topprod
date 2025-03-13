# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Library name...: cl_oraserver
# Descriptions...: 檢查系統參數aza57，系統目前是否串接Express
#                  測試連線 ORA Server
# Input Parameter: p_gcf Record 匯入Tiptop工廠與Express對應DB之關聯
#                  p_gch Record 存取用戶設定SQL Server連線參數
# Return code....: void
# Usage..........: call cl_oraserver(p_gcf,p_gch)
# Date & Author..: 06/02/11 By Leagh
# Revise record..: FUN-660048
# Modify.........: No.FUN-690005 06/09/15 By cheunl  欄位型態定義，改為LIKE
# Modify.........: NO.FUN-6B0004 06/11/03 BY Echo  設定 Express 是否有與 BI 整合,抓資料的sql語法會不同
# Modify.........: NO.MOD-710165 07/02/28 BY Echo 將報表ID新增至程式資料檔(zz_file)時，p_zz必要需入欄位應設定預設值
# Modify.........: No.FUN-740207 07/05/03 By Echo 搭配 V-Point4 Express 版本功能調整
# Modify.........: No.FUN-7C0067 07/12/20 By Echo 調整 LIB function 說明
# Modify.........: No.FUN-810054 08/01/18 By alex 判別作業系統
# Modify.........: No.FUN-840065 08/04/16 By kevin 調整訊息說明
 
IMPORT os     #FUN-980097
DATABASE ds
 
GLOBALS "../../config/top.global"
 
# FUN-660048 測試連線SQL Server以獲取數據
FUNCTION cl_oraserver(p_gcf,p_gch)                             #FUN-740207
   DEFINE p_gch        RECORD LIKE gch_file.* ,                #FUN-740207
                       # l_gch 存取用戶設定SQL Server連線參數
          p_gcf        RECORD LIKE gcf_file.*                  #FUN-740207
                       # l_gcf 匯入Tiptop工廠與Express對應DB之關聯
   DEFINE l_gch        RECORD LIKE gch_file.* ,
                       # l_gch 存取用戶設定SQL Server連線參數
          l_gcf        RECORD LIKE gcf_file.*, 
                       # l_gcf 匯入Tiptop工廠與Express對應DB之關聯
          l_aza57      LIKE aza_file.aza57,
                       # aoos010 設定系統是否串接Express系統
          l_cnt        LIKE type_file.num10,               # 計算資料筆數 #FUN-690005
          l_gci_cnt    LIKE type_file.num10,               # 計算資料筆數 #FUN-690005
          l_msg,l_err  STRING,                # 存儲成功查詢結果
          l_cmd        STRING,                # 組合查詢SQL Server資料參數
          l_where      STRING,                # 組合查詢SQL Server資料條件
          l_status     STRING                 # 返回通訊SQL Server結果狀態
   DEFINE l_data       STRING,                # 獲取查詢返回數據，按行
          l_chr        LIKE type_file.chr1000,          # 字串轉換字符 #FUN-690005
          l_array      ARRAY[5] OF LIKE gci_file.gci03, # 暫存字串     #FUN-690005
          l_gci03      LIKE gci_file.gci03,   #FUN-690005
          l_gci04      LIKE gci_file.gci04,   #FUN-690005
          l_gci        RECORD LIKE gci_file.* # 截取字串
   DEFINE l_zz01       LIKE zz_file.zz01,
          l_zz02       LIKE zz_file.zz02,
          l_zz08       LIKE zz_file.zz08, 
          l_channel    base.Channel
   DEFINE l_zm04       LIKE zm_file.zm04
   DEFINE l_i          LIKE type_file.num10,
          l_gaz_cmd    STRING,
          l_zm_tag     LIKE type_file.num5                 
   DEFINE l_ze03       LIKE ze_file.ze03
   DEFINE l_gaz        DYNAMIC ARRAY OF RECORD
                        gaz01  LIKE gaz_file.gaz01,   #程式代號
                        gaz03  LIKE gaz_file.gaz03    #程式名稱
                       END RECORD   
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   #FUN-740207
   LET l_gcf.* = p_gcf.*
   LET l_gch.* = p_gch.*
 
   ## 判斷系統參數是否允許使用Express
   #SELECT aza57 INTO l_aza57 FROM aza_file
 
   #IF l_aza57 MATCHES "[Yy]" THEN
   #   SELECT COUNT(*) INTO l_cnt FROM gcf_file WHERE gcf02='S' AND gcf06='ds'
   #   IF l_cnt = 0 THEN
   #      SELECT COUNT(*) INTO l_cnt FROM gcf_file WHERE gcf02='S'
   #      IF l_cnt = 0 THEN
   #         # 需設定 對應 DB關聯 gcf06
   #         #CALL cl_err('','No DB Relation Between Tiptop & Express',1)
   #         CALL cl_err('','azz-133',1)
   #         RETURN
   #      END IF
   #      SELECT unique * INTO l_gcf.* FROM gcf_file WHERE gcf02='S'
   #      IF cl_null(l_gcf.gcf06) THEN 
   #        #CALL cl_err('','No DB Relation Between Tiptop & Express',1)
   #         CALL cl_err('','azz-133',1)
   #         RETURN
   #      END IF 
   #   ELSE
   #      # 需設定 對應 DB關聯 gcf06
   #      SELECT * INTO l_gcf.* FROM gcf_file WHERE gcf02 = 'S' AND gcf06='ds'
   #      IF cl_null(l_gcf.gcf06) THEN 
   #        #CALL cl_err('','No DB Relation Between Tiptop & Express',1)
   #         CALL cl_err('','azz-133',1)
   #         RETURN
   #      END IF 
   #   END IF
   #   SELECT COUNT(*) INTO l_cnt FROM gch_file 
   #    WHERE gch01 = l_gcf.gcf01 AND gch02=l_gcf.gcf02 AND gch03= l_gcf.gcf03
   #      AND gch04 = l_gcf.gcf04 AND gch05=l_gcf.gcf05
   #   IF l_cnt = 0 THEN
   #      # 若參數未設定，則直接返回
   #      #CALL cl_err('','Repository Server Parameter Error!',1)
   #      CALL cl_err('','azz-133',1)
   #      RETURN
   #   END IF
   #   
   #   SELECT * INTO l_gch.* FROM gch_file 
   #    WHERE gch01 = l_gcf.gcf01 AND gch02=l_gcf.gcf02 AND gch03= l_gcf.gcf03
   #      AND gch04 = l_gcf.gcf04 AND gch05=l_gcf.gcf05
   #   IF cl_null(l_gch.gch06) OR cl_null(l_gch.gch07) OR 
   #      cl_null(l_gch.gch08) OR cl_null(l_gch.gch09) OR
   #      cl_null(l_gch.gch10) THEN 
   #      # 若SQL Server連線參數未設定，則錯誤返回
   #      #CALL cl_err('','Repository Server Parameter Error!',1)
   #      CALL cl_err('','azz-133',1)
   #      RETURN
   #   END IF
   #ELSE
   #   CALL cl_err('','lib-351',1)
   #   RETURN
   #END IF    
   #END FUN-740207
  
   # 計算導入筆數
   LET l_cmd = NULL
   LET l_where = '1=1'
  # LET l_where = l_gcf.gcf06 CLIPPED
  #IF l_gcf.gcf06 = 'ds' THEN 
  #   LET l_where = " M_DOC_C_NAME NOT LIKE '%ds%' "
  #ELSE
  #   LET l_where = " SUBSTRING(M_DOC_C_NAME,1,",
  #                 l_where.getLength() USING "&",")='",l_gcf.gcf06 CLIPPED,"'"
  #END IF
 
  #LET l_cmd = l_gch.gch09 CLIPPED,"/",l_gch.gch10 CLIPPED,"@",l_gch.gch08 CLIPPED
   LET l_cmd = l_gch.gch09 CLIPPED
  #LET l_cmd = " SELECT COUNT(*) FROM  ",l_cmd CLIPPED,".OBJ_M_DOCUMENTS ",
  #            "  WHERE ",l_where CLIPPED
  #FUN-6B0004
  #LET l_cmd = " SELECT COUNT(*) ",
  #            "   FROM ",l_cmd CLIPPED,".OBJ_M_DOCUMENTS,",l_cmd CLIPPED,
  #            ".OBJ_M_CATEG,",l_cmd CLIPPED,".OBJ_M_DOCCATEG         ",
  #            "  WHERE OBJ_M_DOCCATEG.M_CATEG_N_ID = OBJ_M_CATEG.M_CATEG_N_ID",
  #            "    AND OBJ_M_DOCCATEG.M_DOC_N_ID = OBJ_M_DOCUMENTS.M_DOC_N_ID",
  #            "    AND ",l_where CLIPPED,
  #            "  ORDER BY OBJ_M_DOCUMENTS.M_DOC_N_ID, ",
  #            "           OBJ_M_DOCUMENTS.M_DOC_C_NAME" 
  IF l_gcf.gcf09 = 'Y' THEN
    LET l_cmd ="select COUNT(*) ", 
               "FROM  ",l_cmd CLIPPED,".OBJ_M_DOCUMENTS, ",
               "      ",l_cmd CLIPPED,".OBJ_M_DOCCATEG, ",
               "      ",l_cmd CLIPPED,".OBJ_M_CATEG ",
               "WHERE ",l_cmd CLIPPED,".OBJ_M_DOCCATEG.M_DOC_N_ID = ",
               "      ",l_cmd CLIPPED,".OBJ_M_DOCUMENTS.M_DOC_N_ID ",
               "AND   ",l_cmd CLIPPED,".OBJ_M_CATEG.M_CATEG_N_ID= ",
               "      ",l_cmd CLIPPED,".OBJ_M_DOCCATEG.M_CATEG_N_ID ",
               "AND  upper( substr(",l_cmd CLIPPED,".OBJ_M_CATEG.M_CATEG_C_NAME,1,7))='EXPRESS'"
  ELSE
 
    LET l_cmd ="SELECT COUNT(*)  ",
               "FROM  ",l_cmd CLIPPED,".OBJ_M_DOCUMENTS, ",
               "      ",l_cmd CLIPPED,".OBJ_M_DOCCATEG, ",
               "      ",l_cmd CLIPPED,".OBJ_M_CATEG ",
               "WHERE ",l_cmd CLIPPED,".OBJ_M_DOCCATEG.M_DOC_N_ID = ",
               "      ",l_cmd CLIPPED,".OBJ_M_DOCUMENTS.M_DOC_N_ID ",
               "AND   ",l_cmd CLIPPED,".OBJ_M_CATEG.M_CATEG_N_ID= ",
               "      ",l_cmd CLIPPED,".OBJ_M_DOCCATEG.M_CATEG_N_ID "
  END IF
  #END FUN-6B0004
   PREPARE ora_gci_cnt FROM l_cmd
   EXECUTE ora_gci_cnt INTO l_gci_cnt
   IF cl_null(l_gci_cnt) OR l_gci_cnt = 0 THEN 
     #CALL cl_err("No data to be Import",'No Data to be Import!',1)
      CALL cl_err('','azz-135',1)
      RETURN
   END IF
    
   # 測試匯入
   LET l_cmd = NULL
   LET l_cmd = l_gch.gch09 CLIPPED
  #FUN-6B0004
  #LET l_cmd = " SELECT TRIM(OBJ_M_DOCUMENTS.M_DOC_N_TYPE), ",
  #            "        TRIM(OBJ_M_DOCUMENTS.M_DOC_N_ID),   ",
  #            "        TRIM(OBJ_M_DOCUMENTS.M_DOC_C_NAME), ",
  #            "        TRIM(OBJ_M_CATEG.M_CATEG_C_NAME)    ",
  #            "   FROM ",l_cmd CLIPPED,".OBJ_M_DOCUMENTS,",l_cmd CLIPPED,
  #            "        .OBJ_M_CATEG,",l_cmd CLIPPED,".OBJ_M_DOCCATEG         ",
  #            "  WHERE OBJ_M_DOCCATEG.M_CATEG_N_ID = OBJ_M_CATEG.M_CATEG_N_ID",
  #            "    AND OBJ_M_DOCCATEG.M_DOC_N_ID = OBJ_M_DOCUMENTS.M_DOC_N_ID",
  #            "    AND ",l_where CLIPPED,
  #            "  ORDER BY OBJ_M_DOCUMENTS.M_DOC_N_ID, ",
  #            "           OBJ_M_DOCUMENTS.M_DOC_C_NAME" 
  IF l_gcf.gcf09 = 'Y' THEN
      LET l_cmd = 
          " SELECT LTRIM(RTRIM(",l_cmd CLIPPED, ".OBJ_M_DOCUMENTS.M_DOC_N_TYPE)),",
          "        LTRIM(RTRIM(",l_cmd CLIPPED, ".OBJ_M_DOCUMENTS.M_DOC_N_ID)), ",
          "        LTRIM(RTRIM(",l_cmd CLIPPED, ".OBJ_M_DOCUMENTS.M_DOC_C_NAME)),",
          "        LTRIM(RTRIM(",l_cmd CLIPPED, ".OBJ_M_CATEG.M_CATEG_C_NAME)) ",
          "FROM  ",l_cmd CLIPPED,".OBJ_M_DOCUMENTS, ",
          "      ",l_cmd CLIPPED,".OBJ_M_DOCCATEG, ",
          "      ",l_cmd CLIPPED,".OBJ_M_CATEG ",
          "WHERE ",l_cmd CLIPPED,".OBJ_M_DOCCATEG.M_DOC_N_ID = ",
          "      ",l_cmd CLIPPED,".OBJ_M_DOCUMENTS.M_DOC_N_ID ",
          "AND   ",l_cmd CLIPPED,".OBJ_M_CATEG.M_CATEG_N_ID= ",
          "      ",l_cmd CLIPPED,".OBJ_M_DOCCATEG.M_CATEG_N_ID ",
          "AND  upper( substr(",l_cmd CLIPPED,".OBJ_M_CATEG.M_CATEG_C_NAME,1,7))='EXPRESS' ",
          "ORDER BY ",l_cmd CLIPPED,".OBJ_M_CATEG.M_CATEG_C_NAME "
  ELSE
 
      LET l_cmd =
          " SELECT LTRIM(RTRIM(",l_cmd CLIPPED, ".OBJ_M_DOCUMENTS.M_DOC_N_TYPE)),",
          "        LTRIM(RTRIM(",l_cmd CLIPPED, ".OBJ_M_DOCUMENTS.M_DOC_N_ID)), ",
          "        LTRIM(RTRIM(",l_cmd CLIPPED, ".OBJ_M_DOCUMENTS.M_DOC_C_NAME)),",
          "        LTRIM(RTRIM(",l_cmd CLIPPED, ".OBJ_M_CATEG.M_CATEG_C_NAME)) ",
          "FROM  ",l_cmd CLIPPED,".OBJ_M_DOCUMENTS, ",
          "      ",l_cmd CLIPPED,".OBJ_M_DOCCATEG, ",
          "      ",l_cmd CLIPPED,".OBJ_M_CATEG ",
          "WHERE ",l_cmd CLIPPED,".OBJ_M_DOCCATEG.M_DOC_N_ID = ",
          "      ",l_cmd CLIPPED,".OBJ_M_DOCUMENTS.M_DOC_N_ID ",
          "AND   ",l_cmd CLIPPED,".OBJ_M_CATEG.M_CATEG_N_ID= ",
          "      ",l_cmd CLIPPED,".OBJ_M_DOCCATEG.M_CATEG_N_ID ",
          "ORDER BY ",l_cmd CLIPPED,".OBJ_M_CATEG.M_CATEG_C_NAME "
  END IF
  #END FUN-6B0004
 
   BEGIN WORK
 
   LET l_gaz_cmd = "SELECT gaz01,gaz03 FROM zm_file,gaz_file  ",
               " WHERE zm01 = 'mbo' AND zm04 = gaz01 AND gaz02 = '0'"
   PREPARE gaz_pre FROM l_gaz_cmd
   DECLARE gaz_curs CURSOR FOR gaz_pre
   LET l_cnt = 1
   FOREACH gaz_curs INTO l_gaz[l_cnt].gaz01,l_gaz[l_cnt].gaz03
         LET l_cnt = l_cnt + 1
   END FOREACH
   CALL l_gaz.deleteElement(l_cnt)
   LET l_zm_tag = 0
 
   # 顯示讀取進度
   DELETE FROM gci_file WHERE 1=1
   DELETE FROM zz_file WHERE zz01 LIKE "bo%"
   DELETE FROM gaz_file WHERE gaz01 LIKE "bo%"
  #DELETE FROM gcg_file WHERE gcg02 = 'S'
 
  #LET l_msg = "REP Succefully Import List:\n"
  #LET l_err = "REP Fail Import List:\n"
 
   SELECT ze03 INTO l_ze03 FROM ze_file
      WHERE ze01 = 'lib-353' AND ze02 = g_lang #FUN-840065
   LET l_msg = l_ze03 CLIPPED,"\n"
 
   SELECT ze03 INTO l_ze03 FROM ze_file
      WHERE ze01 = 'lib-354' AND ze02 = g_lang #FUN-840065
   LET l_err = l_ze03 CLIPPED,"\n"
 
   CALL cl_progress_bar(l_gci_cnt)
 
   # 讀取SQL Server查詢返回結果，更新DOC_FILE數據
 
   CALL l_array.clear()
 
   PREPARE ora_gci02_pre FROM l_cmd
   DECLARE ora_gci02_cur CURSOR FOR ora_gci02_pre
   FOREACH ora_gci02_cur INTO l_array[1],l_array[2],l_array[3],l_array[4]
      CASE l_array[1]
         WHEN '1'    LET l_gci.gci01 = "rep"
         WHEN '1024' LET l_gci.gci01 = "wid"
         OTHERWISE   LET l_gci.gci01 = "rep"
      END CASE
 
      LET l_gci.gci02 = l_array[2] CLIPPED
      LET l_gci03 = l_array[3]
      LET l_gci04 = l_array[4]
 
      INSERT INTO gci_file(gci01,gci02,gci03,gci04) 
                    VALUES(l_gci.gci01,l_gci.gci02,
                           l_gci03,l_gci04)
 
      # 未成功導入報表清單
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err(l_gci03,SQLCA.sqlcode,0)
         LET l_err = l_err CLIPPED,l_gci03 CLIPPED,"\n"
      ELSE 
         LET l_zz01 = NULL LET l_zz02 = NULL LET l_zz08 = NULL
         LET l_zz01 = l_array[2] CLIPPED
         LET l_zz01 = "bo",l_gci.gci01 CLIPPED,l_zz01 CLIPPED  #FUN-740207
         LET l_zz02 = l_gci03 CLIPPED
         IF cl_get_os_type() = "WINDOWS" THEN   #FUN-810054
            LET l_zz08 = "%FGLRUN% %AZZi%/p_express 'S' ",l_array[2] CLIPPED,
                         " '",l_gci.gci01 CLIPPED,"' ''"
         ELSE
            LET l_zz08 = "$FGLRUN $AZZi/p_express 'S' ",l_array[2] CLIPPED,
                         " '",l_gci.gci01 CLIPPED,"' ''"
         END IF
 
         #更新設定關聯的報表ID
         UPDATE gcg_file SET gcg08 = l_zz01             #FUN-740207
           WHERE gcg07=l_gci03 AND gcg11 = l_gci.gci01
 
         FOR l_i = 1 TO l_gaz.getLength()
             IF  l_gaz[l_i].gaz03 = l_zz02 AND l_gaz[l_i].gaz01[3] = l_zz01[3] 
             AND l_gaz[l_i].gaz01 <> l_zz01
             THEN
                   UPDATE zm_file SET zm04=l_zz01
                       WHERE zm01 = 'mbo' AND zm04 = l_gaz[l_i].gaz01
                   LET l_zm_tag = 1
             END IF
         END FOR
 
         #MOD-710165
         #INSERT INTO zz_file(zz01,zz02,zz08,) VALUES(l_zz01,l_zz02,l_zz08)
         INSERT INTO zz_file(zz01,zz011,zz03,zz05,zz06,zz08,zz13,zz15,
                             zz25,zz26,zz27,zz28,zz29,zz30,
                             zzuser,zzgrup,zzmodu,zzdate)
              VALUES (l_zz01,"AZZ","R","N","1",l_zz08,"N","N",
                      "N","N","sm1","N","1",0,g_user,g_grup,"",g_today)
         #END MOD-710165
 
         INSERT INTO gaz_file(gaz01,gaz02,gaz03,gaz05) VALUES(l_zz01,'2',l_zz02,'N')
         INSERT INTO gaz_file(gaz01,gaz02,gaz03,gaz05) VALUES(l_zz01,'0',l_zz02,'N')
         IF STATUS THEN 
            CALL cl_err(l_gci03,SQLCA.sqlcode,0)
         END IF
 
      END IF
      # 顯示進度
      CALL cl_progressing("Import Document:" || l_gci03)
      # SLEEP 1
 
      # 成功導入報表清單
      LET l_msg = l_msg CLIPPED,l_gci03 CLIPPED,"\n"
   END FOREACH
   IF l_zm_tag = 1 THEN
     IF (cl_confirm("lib-355")) THEN
       CALL cl_ora_redo_menu()              #重新產生menu
     END IF
   END IF
 
   COMMIT WORK
    
   IF NOT cl_null(l_msg) THEN 
    #LET l_cmd = 'rm -f p_bi.out'
    #RUN l_cmd
     IF os.Path.delete("p_bi.out") THEN
     END IF
 
     LET l_channel = base.Channel.create()
     CALL l_channel.openFile("p_bi.out","a" )
     CALL l_channel.setDelimiter("")
     CALL l_channel.write(l_msg)
     CALL l_channel.close()
 
    #LET l_cmd = "chmod 777 p_bi.out 2>/dev/null" #MOD-530271
    #RUN l_cmd 
     IF os.Path.chrwx("p_bi.out", 511 ) THEN   #FUN-980097
     END IF
 
     LET l_msg = "p_view p_bi.out"
     CALL cl_cmdrun_wait(l_msg)
 
    #LET l_cmd = 'rm -f p_bi.out'
    #RUN l_cmd
     IF os.Path.delete("p_bi.out") THEN
     END IF
 
     #CALL cl_err(l_msg,l_msg,1)
 
   END IF
 
END FUNCTION
 
##################################################
# Descriptions...: 重新產生 zx 所有設定的 menu 
# Date & Author..:
# Input Parameter: none
# Return code....: none
# Usage..........: CALL cl_ora_redo_menu()
# Modify.........: 
##################################################
FUNCTION cl_ora_redo_menu()
   DEFINE  ls_zx05       LIKE zx_file.zx05
   DEFINE  lr_redomenu   DYNAMIC ARRAY OF RECORD
             menu_name   LIKE zx_file.zx05
                         END RECORD
   DEFINE  li_cnt        LIKE type_file.num5,    #FUN-690005
           li_i          LIKE type_file.num5     #FUN-690005
 
   LET li_cnt = 1
   DECLARE zx05_all_curs CURSOR FOR
                         SELECT UNIQUE(zx05) FROM zx_file
   FOREACH zx05_all_curs INTO ls_zx05
      IF SQLCA.sqlcode THEN
         CALL cl_err('OPEN zx05_all_curs:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET lr_redomenu[li_cnt].menu_name = ls_zx05
      LET li_cnt = li_cnt + 1
   END FOREACH
   FOR li_i = 1 TO lr_redomenu.getLength()
       IF NOT cl_null(lr_redomenu[li_i].menu_name) THEN
          CALL cl_create_4sm(lr_redomenu[li_i].menu_name,TRUE)
       END IF
   END FOR
 
END FUNCTION
