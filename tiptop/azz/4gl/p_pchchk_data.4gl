# Prog. Version..: '5.30.06-13.03.12(00001)'     #

##################################################
# Description   : p_pchchk_data     Patch 資料驗證作業
# Date & Author : 2012/01/16 by jt_chen
# Modify........: No.TQC-BB0113 12/01/16 By jt_chen 過單.

IMPORT os 

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_find_key        DYNAMIC ARRAY OF RECORD #紀錄TABLE 所有KEY值
       g_file_name       LIKE type_file.chr100,
       g_index_name      LIKE type_file.chr100,
       g_sort            LIKE type_file.chr100,
       g_field_name      LIKE type_file.chr100
                         END RECORD
DEFINE g_find_field      DYNAMIC ARRAY OF RECORD #記錄TABLE 所有欄位
       g_file_name       LIKE type_file.chr1000,
       g_field_name      LIKE type_file.chr1000,
       g_field_chname    LIKE type_file.chr1000
                         END RECORD
DEFINE g_find_data       DYNAMIC ARRAY OF RECORD #記錄差異資料
       g_minu_data       VARCHAR(6999)
                         END RECORD
DEFINE g_tmp_data        DYNAMIC ARRAY OF RECORD #記錄由KEY值 撈出的Patchtemp & Ds的資料
       g_patchtemp       VARCHAR(6999),
       g_ds              VARCHAR(6999)
                         END RECORD
DEFINE g_patch_path      STRING                  
DEFINE g_show_msg        DYNAMIC ARRAY OF RECORD #show excel
       g_file_name       LIKE type_file.chr100,
       g_patchtemp_data  LIKE type_file.chr1000,
       g_ds_data         LIKE type_file.chr1000,
       l_chk             LIKE type_file.chr100
                         END RECORD

MAIN

DEFINE l_tarname         STRING
DEFINE lc_result         LIKE type_file.num5
DEFINE l_cmd             STRING

   WHENEVER ERROR CONTINUE  

   DROP TABLE show_tmp           #temp table 記錄export to excel的data
   CREATE TEMP TABLE show_tmp
   ( 
     z001       VARCHAR(10),     #異動檔案
     z002       VARCHAR(1000),   #PATCHTEMP
     z003       VARCHAR(1000),   #DS
     z004       VARCHAR(10)      #CHK
     );
   DELETE FROM show_tmp

   PROMPT "請輸入您這次要驗證的PATCH單號:" CLIPPED FOR l_tarname

   IF INT_FLAG THEN
      LET INT_FLAG = FALSE
      EXIT PROGRAM 
   END IF 

   CALL ui.interface.refresh()
   LET g_patch_path = os.Path.join(os.Path.join(FGL_GETENV('TOP'),"unpack"),l_tarname)
   LET lc_result = TRUE

   IF os.Path.chdir(g_patch_path) THEN
      DISPLAY "開始進行 .txt檔 V.S patchtemp ..."
      CALL diff_txt_patchtemp()	 RETURNING lc_result
      IF NOT lc_result THEN     # 表有異常
         LET l_cmd = ".txt檔與patchtemp有差異. 請確認!"
         CALL p_pchchk_data_show_msg(l_cmd)
         DISPLAY "請確認patchtemp的Schema,是否適用.txt檔"
         EXIT PROGRAM   
      ELSE
         DISPLAY "開始進行 patchtemp V.S ds ..."
         CALL diff_patchtemp_ds() RETURNING lc_result
         IF NOT lc_result THEN     # 表有異常
            LET l_cmd = "patchtemp與DS有差異. 請確認!"
            CALL p_pchchk_data_show_msg(l_cmd)
            DISPLAY "請確認patchtemp的Schema,是否與DS相同"
            EXIT PROGRAM
         END IF
      END IF
      DISPLAY "比對結束!"
      DISPLAY "Patch同步資料順利完成更新，請確認後續Rebuild結果!!"
   ELSE
      DISPLAY "請檢查您輸入的PATCH單號是否正確."
      DISPLAY "Change Directory ",g_patch_path," Error."
   END IF
END MAIN


FUNCTION diff_txt_patchtemp()
DEFINE l_table           STRING
DEFINE l_tbname          STRING
DEFINE l_tempname        STRING
DEFINE l_file            STRING
DEFINE l_sql             STRING
DEFINE l_h               LIKE type_file.num5
DEFINE l_idx             LIKE type_file.num5
DEFINE l_cnt             LIKE type_file.num5
DEFINE l_ac              LIKE type_file.num5
DEFINE l_ac2             LIKE type_file.num5
DEFINE l_key_str         STRING
DEFINE li_result_final  LIKE type_file.num5
DEFINE l_tempdir        STRING
DEFINE l_patchtemp_str  STRING
DEFINE l_ds_str         STRING
DEFINE l_i              LIKE type_file.num5

    LET l_tempdir = FGL_GETENV('TEMPDIR')
    CALL os.Path.dirsort("name",1)
    LET l_h = os.Path.diropen(g_patch_path)
    LET li_result_final = TRUE
    #撈出$TOP/pack/A**** 目錄底下的.txt檔,並建立該temp table
    WHILE l_h > 0
       LET l_file = os.Path.dirnext(l_h)
       IF l_file IS NULL THEN
          EXIT WHILE
       END IF
       IF l_file = "." OR l_file = ".." THEN
          CONTINUE WHILE
       END IF
       IF l_file.subString(1,5) <> "patch" THEN
          CONTINUE WHILE
       END IF
       LET l_idx = l_file.getIndexOf(".txt",1)
       IF l_idx > 0 THEN
          DISPLAY "目前比對的.txt檔: ",l_file
          LET l_table = l_file.subString(l_file.getIndexOf("patch_",1)+6,l_file.getLength()-4)
          LET l_tbname = l_table||"_file"
          LET l_tempname = l_table||"_tmp"

          LET l_sql = "DROP TABLE ",l_tempname
          EXECUTE IMMEDIATE l_sql
          LET l_sql = "SELECT * FROM ",l_tbname CLIPPED," WHERE 1=2 INTO TEMP ",l_tempname CLIPPED
          EXECUTE IMMEDIATE l_sql
          LET l_sql = "DELETE FROM ",l_tempname CLIPPED
          EXECUTE IMMEDIATE l_sql
          LET l_sql = "INSERT INTO ",l_tempname
          LOAD FROM l_file l_sql

          #  temp table 與patchtemp比較
          LET l_sql = "DROP TABLE minus_tmp"
          EXECUTE IMMEDIATE l_sql
          LET l_sql = "SELECT * FROM ",l_tbname CLIPPED," WHERE 1=2 INTO TEMP minus_tmp"
          EXECUTE IMMEDIATE l_sql
          LET l_sql = "DELETE FROM minus_tmp"
          EXECUTE IMMEDIATE l_sql

          SELECT COUNT(*) INTO l_i  FROM gay_file WHERE gay01 = '1'  
          # 刪除語言別為英文的資料
          IF l_i = 0 THEN
              CASE l_tempname
                WHEN "ze_tmp"
                   LET l_sql = "DELETE FROM ",l_tempname CLIPPED," WHERE  ze02  = '1'"
                WHEN "gbd_tmp"
                   LET l_sql = "DELETE FROM ",l_tempname CLIPPED," WHERE  gbd03 = '1'"
                WHEN "gae_tmp"
                   LET l_sql = "DELETE FROM ",l_tempname CLIPPED," WHERE  gae03 = '1'"
                WHEN "gaq_tmp"
                   LET l_sql = "DELETE FROM ",l_tempname CLIPPED," WHERE  gaq02 = '1'"
                WHEN "gat_tmp"
                   LET l_sql = "DELETE FROM ",l_tempname CLIPPED," WHERE  gat02 = '1'"
                WHEN "gaz_tmp"
                   LET l_sql = "DELETE FROM ",l_tempname CLIPPED," WHERE  gaz02 = '1'"
                WHEN "zaa_tmp"
                   LET l_sql = "DELETE FROM ",l_tempname CLIPPED," WHERE  zaa03 = '1'"
                WHEN "zab_tmp"
                   LET l_sql = "DELETE FROM ",l_tempname CLIPPED," WHERE  zab04 = '1'"
                WHEN "gba_tmp"
                   LET l_sql = "DELETE FROM ",l_tempname CLIPPED," WHERE  gba04 = '1'"
                WHEN "gbb_tmp"
                   LET l_sql = "DELETE FROM ",l_tempname CLIPPED," WHERE  gbb04 = '1'"
                WHEN "gbf_tmp"
                   LET l_sql = "DELETE FROM ",l_tempname CLIPPED," WHERE  gbf02 = '1'"
                WHEN "zad_tmp"
                   LET l_sql = "DELETE FROM ",l_tempname CLIPPED," WHERE  zad03 = '1'"
                WHEN "zae_tmp"
                   LET l_sql = "DELETE FROM ",l_tempname CLIPPED," WHERE  zae05 = '1'"
                WHEN "zaw_tmp"
                   LET l_sql = "DELETE FROM ",l_tempname CLIPPED," WHERE  zaw06 = '1'"
                WHEN "zal_tmp"
                   LET l_sql = "DELETE FROM ",l_tempname CLIPPED," WHERE  zal03 = '1'"
                WHEN "wan_tmp"
                   LET l_sql = "DELETE FROM ",l_tempname CLIPPED," WHERE  wan05 = '1'"
                WHEN "zta_tmp"
                   LET l_sql = "DELETE FROM ",l_tempname CLIPPED," WHERE  zta01 = '1'"
                WHEN "gee_tmp"
                   LET l_sql = "DELETE FROM ",l_tempname CLIPPED," WHERE  gee03 = '1'"
                WHEN "gdm_tmp"
                   LET l_sql = "DELETE FROM ",l_tempname CLIPPED," WHERE  gdm03 = '1'"
                WHEN "gfs_tmp"
                   LET l_sql = "DELETE FROM ",l_tempname CLIPPED," WHERE  gfs02 = '1'"
                WHEN "gfp_tmp"
                   LET l_sql = "DELETE FROM ",l_tempname CLIPPED," WHERE  gfp03 = '1'"
                WHEN "wzm_tmp"
                   LET l_sql = "DELETE FROM ",l_tempname CLIPPED," WHERE  wzm07 = '1'"
                WHEN "wzh_tmp"
                   LET l_sql = "DELETE FROM ",l_tempname CLIPPED," WHERE  wzh02 = '1'"
                WHEN "wzf_tmp"
                   LET l_sql = "DELETE FROM ",l_tempname CLIPPED," WHERE  wzf03 = '1'"  
                WHEN "wya_tmp"
                   LET l_sql = "DELETE FROM ",l_tempname CLIPPED," WHERE  wya03 = '1'"
                WHEN "gfs_tmp"
                   LET l_sql = "DELETE FROM ",l_tempname CLIPPED," WHERE  gfs02 = '1'"
                   
             END CASE
             EXECUTE IMMEDIATE l_sql
             IF SQLCA.SQLCODE THEN
               #DISPLAY SQLCA.SQLCODE
               #DISPLAY SQLCA.SQLERRD[2]
             END IF     
          END IF

          #將MINUS結果寫進minus_tmp 
          LET l_sql = "INSERT INTO minus_tmp ",
                       " SELECT * FROM ",l_tempname CLIPPED," MINUS SELECT * FROM patchtemp.",l_tbname CLIPPED
          EXECUTE IMMEDIATE l_sql
          SELECT COUNT(*) INTO l_cnt FROM minus_tmp
          IF l_cnt > 0 THEN
             DISPLAY " TABLE:" ,l_tbname," p_unpack2解包時,建立的patchtemp與.txt檔 有差異!!.\n"        
             LET l_ac = 1
             LET l_key_str = NULL
             CALL g_find_key.clear()
             CALL g_find_field.clear()

             #撈出TABLE的KEY值
             LET l_sql = "SELECT lower(dic.table_name),lower( dic.index_name),lower(dic.column_position),lower( dic.column_name) ",
                            " FROM user_indexes di, user_ind_columns dic,gat_file ",
                            " WHERE dic.table_name  = di.table_name ",
                            " AND dic.index_name  = di.index_name ",
                            " AND gat01 = '",l_tbname CLIPPED,"'",
                            " and lower(di.table_name) = gat01 ",
                            " and gat02 = '0' ",
                            " and di.uniqueness = 'UNIQUE' ",
                            " ORDER BY dic.table_name, dic.index_name,di.uniqueness desc, dic.column_position "
             PREPARE key_prepare FROM l_sql
             DECLARE key_curs CURSOR FOR key_prepare
             FOREACH key_curs INTO g_find_key[l_ac].*  
                IF SQLCA.sqlcode != 0 THEN
                   EXIT FOREACH
                END IF
                LET l_key_str = l_key_str,g_find_key[l_ac].g_field_name CLIPPED,"='''||",g_find_key[l_ac].g_field_name CLIPPED,"||''' AND "
                LET l_ac = l_ac + 1
             END FOREACH
             CALL g_find_key.deleteElement(l_ac)
             LET l_key_str = l_key_str.subString(1,l_key_str.getLength()-10)

             #組出由各個TABLE的KEY值,組合成差異的WHERE條件
             LET l_ac = 1
             LET l_sql = "SELECT '",l_key_str CLIPPED," FROM minus_tmp"
             PREPARE data_prepare FROM l_sql
             DECLARE data_curs CURSOR FOR data_prepare
             FOREACH data_curs INTO g_find_data[l_ac].g_minu_data 
                IF SQLCA.sqlcode != 0 THEN
                   EXIT FOREACH
                END IF
                LET l_ac = l_ac + 1
             END FOREACH
             CALL g_find_data.deleteElement(l_ac)  

             #撈出各個TABLE的所有欄位
             LET l_ac = 1
             LET l_sql = "SELECT gat01,gaq01,gaq03 FROM gaq_file,gat_file",
                         " WHERE gat01 = '",l_tbname CLIPPED,"' and gaq02 = '0' and substr(gaq01,1,3) = substr(gat01,1,3) and gat02 = '0'",
                         " AND gaq03 <> 'No Use'",
                         " ORDER BY gat01,gaq01" 
             PREPARE feld_prepare FROM l_sql
             DECLARE feld_curs CURSOR FOR feld_prepare
             FOREACH feld_curs INTO g_find_field[l_ac].*
                IF SQLCA.sqlcode != 0 THEN
                   EXIT FOREACH
                END IF
                LET l_ac = l_ac + 1
             END FOREACH
             CALL g_find_field.deleteElement(l_ac)

             #由差異資料,將所有欄位的DATA撈出
             LET l_cnt = 0
             FOR l_ac = 1 TO g_find_data.getLength()
                LET l_patchtemp_str = NULL
                LET l_ds_str = NULL 
                CALL g_show_msg.clear()
                #組出excel欄位2、欄位3的字串
                FOR l_ac2 =1 TO g_find_field.getLength() 
                   #patchtemp               
                   LET l_sql = " SELECT ",g_find_field[l_ac2].g_field_name CLIPPED," FROM patchtemp.",g_find_field[l_ac2].g_file_name CLIPPED," WHERE ",g_find_data[l_ac].g_minu_data CLIPPED,"'"
                   PREPARE get_cur1_pre FROM l_sql
                   DECLARE get_cur1 CURSOR FOR get_cur1_pre
                   OPEN get_cur1
                   FETCH get_cur1 INTO g_tmp_data[l_ac2].g_patchtemp
                   LET l_patchtemp_str = l_patchtemp_str,g_find_field[l_ac2].g_field_name CLIPPED,"= ",g_tmp_data[l_ac2].g_patchtemp CLIPPED," ; "
                   #ds
                   LET l_sql = " SELECT ",g_find_field[l_ac2].g_field_name CLIPPED," FROM ds.",g_find_field[l_ac2].g_file_name CLIPPED," WHERE ",g_find_data[l_ac].g_minu_data CLIPPED,"'"
                   PREPARE get_cur2_pre FROM l_sql
                   DECLARE get_cur2 CURSOR FOR get_cur2_pre
                   OPEN get_cur2
                   FETCH get_cur2 INTO g_tmp_data[l_ac2].g_ds
                   LET l_ds_str = l_ds_str,g_find_field[l_ac2].g_field_name CLIPPED,"= ",g_tmp_data[l_ac2].g_ds CLIPPED," ; "
                END FOR
                #將記錄寫入show_tmp中
                LET l_patchtemp_str = l_patchtemp_str.subString(1,l_patchtemp_str.getLength()-3) 
                LET l_ds_str = l_ds_str.subString(1,l_ds_str.getLength()-3)
                LET g_show_msg[l_ac].g_file_name = l_tbname CLIPPED
                LET g_show_msg[l_ac].g_patchtemp_data = l_patchtemp_str CLIPPED
                LET g_show_msg[l_ac].g_ds_data = l_ds_str CLIPPED
                IF g_show_msg[l_ac].g_patchtemp_data = g_show_msg[l_ac].g_ds_data = l_ds_str THEN
                   LET g_show_msg[l_ac].l_chk = "成功"
                ELSE
                   LET g_show_msg[l_ac].l_chk = "失敗"
                END IF
                LET l_sql = "INSERT INTO show_tmp VALUES("
                LET l_sql =l_sql,"'",g_show_msg[l_ac].g_file_name,"','",g_show_msg[l_ac].g_patchtemp_data,"','",g_show_msg[l_ac].g_ds_data,"','",g_show_msg[l_ac].l_chk,"')"   
                EXECUTE IMMEDIATE l_sql
                IF SQLCA.SQLCODE THEN
                  #DISPLAY SQLCA.SQLCODE
                  #DISPLAY SQLCA.SQLERRD[2]
                END IF
             END FOR
          END IF
       END IF
    END WHILE
    
    CALL g_show_msg.clear()
    LET l_ac = 1
    DECLARE show_cur CURSOR FOR SELECT * FROM show_tmp
    FOREACH show_cur INTO g_show_msg[l_ac].*
       IF SQLCA.sqlcode != 0 THEN
          EXIT FOREACH
       END IF
    LET l_ac = l_ac + 1
    END FOREACH
    CALL g_show_msg.deleteElement(l_ac) 
    LET l_ac = l_ac -1

    IF l_ac > 0 THEN
       LET li_result_final = FALSE
       DISPLAY "差異總筆數:",l_ac
       LET g_max_rec = g_show_msg.getLength()
       IF os.Path.chdir(l_tempdir) THEN
          CALL cl_show_array(base.TypeInfo.create(g_show_msg),'第一階段比對(.txt檔 v.s Patchtemp有差異)','異動檔案|patchtemp資料|DS 資料|檢核結果')
          IF INT_FLAG = 1 THEN
             LET INT_FLAG = 0
          END IF
       END IF
    END IF

    CALL os.Path.dirclose(l_h)
    RETURN li_result_final
END FUNCTION

FUNCTION diff_patchtemp_ds()
DEFINE l_table           STRING
DEFINE l_tbname          STRING
DEFINE l_tempname        STRING
DEFINE l_file            STRING
DEFINE l_sql             STRING
DEFINE l_h               LIKE type_file.num5
DEFINE l_idx             LIKE type_file.num5
DEFINE l_cnt             LIKE type_file.num5
DEFINE l_ac              LIKE type_file.num5
DEFINE l_ac2             LIKE type_file.num5
DEFINE l_key_str         STRING
DEFINE l_tempdir        STRING
DEFINE l_patchtemp_str  STRING
DEFINE l_ds_str         STRING
DEFINE li_result_final  LIKE type_file.num5

    LET l_tempdir = FGL_GETENV('TEMPDIR')
    CALL os.Path.dirsort("name",1)
    LET l_h = os.Path.diropen(g_patch_path)
    LET li_result_final = TRUE
    #撈出$TOP/pack/A**** 目錄底下的.txt檔,並建立該temp table
    WHILE l_h > 0
       LET l_file = os.Path.dirnext(l_h)
       IF l_file IS NULL THEN
          EXIT WHILE
       END IF
       IF l_file = "." OR l_file = ".." THEN
          CONTINUE WHILE
       END IF
       IF l_file.subString(1,5) <> "patch" THEN
          CONTINUE WHILE
       END IF
       LET l_idx = l_file.getIndexOf(".txt",1)
       IF l_idx > 0 THEN
          DISPLAY "目前比對的.txt檔: ",l_file
          LET l_table = l_file.subString(l_file.getIndexOf("patch_",1)+6,l_file.getLength()-4)
          LET l_tbname = l_table||"_file"
          LET l_tempname = l_table||"_tmp"

          LET l_sql = "DROP TABLE ",l_tempname
          EXECUTE IMMEDIATE l_sql
          LET l_sql = "SELECT * FROM ",l_tbname CLIPPED," WHERE 1=2 INTO TEMP ",l_tempname CLIPPED
          EXECUTE IMMEDIATE l_sql
          LET l_sql = "DELETE FROM ",l_tempname CLIPPED
          EXECUTE IMMEDIATE l_sql
          LET l_sql = "INSERT INTO ",l_tempname
          LOAD FROM l_file l_sql

          #  patchtemp與DS比較
          LET l_sql = "DROP TABLE minus_tmp"
          EXECUTE IMMEDIATE l_sql
          LET l_sql = "SELECT * FROM ",l_tbname CLIPPED," WHERE 1=2 INTO TEMP minus_tmp"
          EXECUTE IMMEDIATE l_sql
          LET l_sql = "DELETE FROM minus_tmp"
          EXECUTE IMMEDIATE l_sql

          #將MINUS結果寫進minus_tmp 
          LET l_sql = "INSERT INTO minus_tmp ",
                       " SELECT * FROM patchtemp.",l_tempname CLIPPED," MINUS SELECT * FROM ds.",l_tbname CLIPPED
          EXECUTE IMMEDIATE l_sql

          SELECT COUNT(*) INTO l_cnt FROM minus_tmp
          IF l_cnt > 0 THEN
             DISPLAY " TABLE:" ,l_tbname," p_unpack2解包時,建立的patchtemp與DS data 有差異!!.\N"        
             LET l_ac = 1
             LET l_key_str = NULL
             CALL g_find_key.clear()
             CALL g_find_field.clear()
             LET l_sql = "SELECT lower(dic.table_name),lower( dic.index_name),lower(dic.column_position),lower( dic.column_name) ",
                          " FROM user_indexes di, user_ind_columns dic,gat_file ",
                          " WHERE dic.table_name  = di.table_name ",
                          " AND dic.index_name  = di.index_name ",
                          " AND gat01 = '",l_tbname CLIPPED,"'",
                          " and lower(di.table_name) = gat01 ",
                          " and gat02 = '0' ",
                          " and di.uniqueness = 'UNIQUE' ",
                          " ORDER BY dic.table_name, dic.index_name,di.uniqueness desc, dic.column_position "
             PREPARE key_prepare2 FROM l_sql
             DECLARE key_curs2 CURSOR FOR key_prepare2
             FOREACH key_curs2 INTO g_find_key[l_ac].*  
                IF SQLCA.sqlcode != 0 THEN
                   EXIT FOREACH
                END IF
                LET l_key_str = l_key_str,g_find_key[l_ac].g_field_name CLIPPED,"='''||",g_find_key[l_ac].g_field_name CLIPPED,"||''' AND "
                LET l_ac = l_ac + 1
             END FOREACH
             CALL g_find_key.deleteElement(l_ac)
             LET l_key_str = l_key_str.subString(1,l_key_str.getLength()-10)
             
             LET l_ac = 1
             LET l_sql = "SELECT '",l_key_str CLIPPED," FROM minus_tmp"
             PREPARE data_prepare2 FROM l_sql
             DECLARE data_curs2 CURSOR FOR data_prepare2
             FOREACH data_curs2 INTO g_find_data[l_ac].g_minu_data 
                IF SQLCA.sqlcode != 0 THEN
                   EXIT FOREACH
                END IF
                LET l_ac = l_ac + 1
             END FOREACH
             CALL g_find_data.deleteElement(l_ac)  
             
             LET l_ac = 1
             LET l_sql = "SELECT gat01,gaq01,gaq03 FROM gaq_file,gat_file",
                         " WHERE gat01 = '",l_tbname CLIPPED,"' and gaq02 = '0' and substr(gaq01,1,3) = substr(gat01,1,3) and gat02 = '0'",
                         " AND gaq03 <> 'No Use'",
                         " ORDER BY gat01,gaq01" 
             PREPARE feld_prepare2 FROM l_sql
             DECLARE feld_curs2 CURSOR FOR feld_prepare2
             FOREACH feld_curs2 INTO g_find_field[l_ac].*
                IF SQLCA.sqlcode != 0 THEN
                   EXIT FOREACH
                END IF
                LET l_ac = l_ac + 1
             END FOREACH
             CALL g_find_field.deleteElement(l_ac)
             
             LET l_cnt = 0
             FOR l_ac = 1 TO g_find_data.getLength()
                LET l_patchtemp_str = NULL
                LET l_ds_str = NULL 
                CALL g_show_msg.clear()
                #組出excel欄位2、欄位3的字串
                FOR l_ac2 =1 TO g_find_field.getLength() 
                   #patchtemp           
                   LET l_sql = " SELECT ",g_find_field[l_ac2].g_field_name CLIPPED," FROM patchtemp.",g_find_field[l_ac2].g_file_name CLIPPED," WHERE ",g_find_data[l_ac].g_minu_data CLIPPED,"'"
                   PREPARE get_cur1_pre2 FROM l_sql
                   DECLARE get_cur12 CURSOR FOR get_cur1_pre2
                   OPEN get_cur12
                   FETCH get_cur12 INTO g_tmp_data[l_ac2].g_patchtemp
                   LET l_patchtemp_str = l_patchtemp_str,g_find_field[l_ac2].g_field_name CLIPPED,"= ",g_tmp_data[l_ac2].g_patchtemp CLIPPED," ; "
                   #ds
                   LET l_sql = " SELECT ",g_find_field[l_ac2].g_field_name CLIPPED," FROM ds.",g_find_field[l_ac2].g_file_name CLIPPED," WHERE ",g_find_data[l_ac].g_minu_data CLIPPED,"'"
                   PREPARE get_cur2_pre2 FROM l_sql
                   DECLARE get_cur22 CURSOR FOR get_cur2_pre2
                   OPEN get_cur22
                   FETCH get_cur22 INTO g_tmp_data[l_ac2].g_ds
                   LET l_ds_str = l_ds_str,g_find_field[l_ac2].g_field_name CLIPPED,"= ",g_tmp_data[l_ac2].g_ds CLIPPED," ; "
                END FOR

                #將記錄寫入show_tmp中
                LET l_patchtemp_str = l_patchtemp_str.subString(1,l_patchtemp_str.getLength()-3) 
                LET l_ds_str = l_ds_str.subString(1,l_ds_str.getLength()-3)
                LET g_show_msg[l_ac].g_file_name = l_tbname CLIPPED
                LET g_show_msg[l_ac].g_patchtemp_data = l_patchtemp_str CLIPPED
                LET g_show_msg[l_ac].g_ds_data = l_ds_str CLIPPED
                IF g_show_msg[l_ac].g_patchtemp_data = g_show_msg[l_ac].g_ds_data = l_ds_str THEN
                   LET g_show_msg[l_ac].l_chk = "成功"
                ELSE
                   LET g_show_msg[l_ac].l_chk = "失敗"
                END IF
                LET l_sql = "INSERT INTO show_tmp VALUES("
                LET l_sql =l_sql,"'",g_show_msg[l_ac].g_file_name,"','",g_show_msg[l_ac].g_patchtemp_data,"','",g_show_msg[l_ac].g_ds_data,"','",g_show_msg[l_ac].l_chk,"')"   
                EXECUTE IMMEDIATE l_sql
                IF SQLCA.SQLCODE THEN
                  #DISPLAY SQLCA.SQLCODE
                  #DISPLAY SQLCA.SQLERRD[2]
                END IF
             END FOR
          END IF
       END IF
    END WHILE
    CALL g_show_msg.clear()
    LET l_ac = 1
    DECLARE show_cur2 CURSOR FOR SELECT * FROM show_tmp
    FOREACH show_cur2 INTO g_show_msg[l_ac].*
       IF SQLCA.sqlcode != 0 THEN
          EXIT FOREACH
       END IF
    LET l_ac = l_ac + 1
    END FOREACH
    CALL g_show_msg.deleteElement(l_ac)
    LET l_ac = l_ac -1
    DISPLAY "差異總筆數: ",l_ac
    IF l_ac > 0 THEN
       LET li_result_final = FALSE 
       LET g_max_rec = g_show_msg.getLength()
       IF os.Path.chdir(l_tempdir) THEN
          CALL cl_show_array(base.TypeInfo.create(g_show_msg),'第一階段比對(.txt檔 v.s Patchtemp有差異)','異動檔案|patchtemp資料|DS 資料|檢核結果')
          IF INT_FLAG = 1 THEN
             LET INT_FLAG = 0
          END IF
       END IF
    END IF
    CALL os.Path.dirclose(l_h)   
    RETURN li_result_final
END FUNCTION

FUNCTION p_pchchk_data_show_msg(ps_msg)
   DEFINE  ps_msg     STRING
   MENU "Message" ATTRIBUTE (STYLE="dialog", COMMENT=ps_msg.trim() CLIPPED, IMAGE="information")
      ON ACTION ok
         EXIT MENU
   END MENU
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
   END IF	   
END FUNCTION
#TQC-BB0113                                   
