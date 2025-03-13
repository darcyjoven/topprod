# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_itemname_by_lang.4gl
# Descriptions...: 欄位資料多語言記錄功能
# Date & Author..: 04/12/31 alex
# Modify.........: No.MOD-530736 05/03/29 alex 新增 cl_itemname_current 函式
# Modify.........: No.FUN-550077 05/05/23 alex 修改 mod_curr 錯誤
# Modify.........: No.FUN-560202 05/10/25 alex 修改 construct error
# Modify.........: No.FUN-580026 05/10/28 alex 修改 update error提示
# Modify.........: No.FUN-690005 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.CHI-6B0034 06/11/10 alexstar 新增刪除相關多語言資料的功能
# Modify.........: No.FUN-7B0028 07/11/12 alex 修訂註解以配合自動抓取機制
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-B50108 11/05/18 By Kevin 維護function的資訊(p_findfunc)
# Modify.........: No.TQC-D10049 13/01/11 by Kevin 加上 WHENEVER ERROR CONTINUE
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
DEFINE  g_gbc05_curr   LIKE gbc_file.gbc05
 
# Descriptions...: 使用多語言記錄功能調閱段副程式
# Memo...........: 使用 gbc_file
#                  需同時搭配cl_itemname_by_lang() 來抓取修正完成的值
# Input parameter: l_gbc01 檔案代碼  (Table ID)   Ex. "zx_file"
#                  l_gbc02 欄位代碼                   "zx02"
#                  l_gbc03 KEY 值序列,多組時以,隔開   "hjwang"
#                  l_gbc04 語言別                     g_lang
# Return code....: 對應語言別的名稱 description mapping language id
# Usage..........: CALL cl_itemname_by_lang("zx_file","zx02","hjwang",g_lang)
#                  RETURNING "item name by lang" / NULL
# Modify.........: No.FUN-7B0028 07/11/12 alex 修訂註解以配合自動抓取機制
 
FUNCTION cl_itemname_by_lang(lc_gbc01,lc_gbc02,lc_gbc03,lc_gbc04,lc_gbc05)
 
   DEFINE lc_gbc01       LIKE gbc_file.gbc01   # table id
   DEFINE lc_gbc02       LIKE gbc_file.gbc02   # field id
   DEFINE lc_gbc03       LIKE gbc_file.gbc03   # key value series
   DEFINE lc_gbc04       LIKE gbc_file.gbc04   # language id
   DEFINE lc_gbc05       LIKE gbc_file.gbc05   # return value
   DEFINE lc_gbc05_t     LIKE gbc_file.gbc05   # return value
 
   WHENEVER ERROR CONTINUE        #TQC-D10049

   IF g_aza.aza44 <> "Y" THEN
      RETURN lc_gbc05 CLIPPED
   END IF
 
   LET lc_gbc05_t = lc_gbc05 CLIPPED
   LET lc_gbc05 = ""
 
   SELECT gbc05 INTO lc_gbc05 FROM gbc_file
    WHERE gbc01=lc_gbc01 AND gbc02=lc_gbc02 AND gbc03=lc_gbc03
      AND gbc04=lc_gbc04
 
   IF cl_null(lc_gbc05) THEN
      RETURN lc_gbc05_t
   ELSE
      RETURN lc_gbc05
   END IF
 
END FUNCTION
 
##################################################
# Descriptions...: 更新現行語言別下資料副程式
# Input parameter: lc_gbc01 檔案代碼  (Table ID)   Ex. "zx_file"
#                  lc_gbc02 欄位代碼                   "zx02"
#                  lc_gbc03 KEY 值序列,多組時以,隔開   "hjwang"
#                  lc_gbc05
# Return code....: TRUE/FALSE
##################################################
 
FUNCTION cl_itemname_modcurr(lc_gbc01,lc_gbc02,lc_gbc03,lc_gbc05)
 
   DEFINE lc_gbc01       LIKE gbc_file.gbc01   # table id
   DEFINE lc_gbc02       LIKE gbc_file.gbc02   # field id
   DEFINE lc_gbc03       LIKE gbc_file.gbc03   # key value series
   DEFINE lc_gbc05       LIKE gbc_file.gbc05   # saved value
   DEFINE li_return      LIKE gbc_file.gbc05   # return value
   DEFINE li_i           LIKE type_file.num10  # No.FUN-690005 INTEGER
 
   IF g_aza.aza44 <> "Y" THEN RETURN 0 END IF
   
   LET lc_gbc05 = lc_gbc05 CLIPPED
   LET li_return=0
   LET li_i=0
   SELECT count(*) INTO li_i FROM gbc_file
    WHERE gbc01=lc_gbc01 AND gbc02=lc_gbc02 AND gbc03=lc_gbc03
      AND gbc04=g_lang
   IF li_i = 0 THEN
      INSERT INTO gbc_file(gbc01,gbc02,gbc03,gbc04,gbc05)
          VALUES (lc_gbc01,lc_gbc02,lc_gbc03,g_lang,lc_gbc05)
      IF SQLCA.SQLCODE THEN
         CALL cl_err_msg(NULL,"lib-152",lc_gbc01,10)
         LET li_return=SQLCA.sqlcode
      END IF
   ELSE
      UPDATE gbc_file SET gbc05=lc_gbc05
       WHERE gbc01=lc_gbc01 AND gbc02=lc_gbc02 AND gbc03=lc_gbc03
         AND gbc04=g_lang
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]<1 THEN
         CALL cl_err_msg(NULL,"lib-152",lc_gbc01,10)
         LET li_return=SQLCA.sqlcode
      END IF
   END IF
 
   RETURN li_return
 
END FUNCTION
 
##################################################
# Descriptions...: 更新現行語言別下資料副程式
# Input parameter: lc_gbc01 檔案代碼  (Table ID)   Ex. "zx_file"
#                  lc_gbc02 欄位代碼                   "zx02"
#                  lc_gbc03 KEY 值序列,多組時以,隔開   "hjwang"
#                  lc_gbc05
# Return code....: TRUE/FALSE
##################################################
 
FUNCTION cl_itemname_modsys(lc_gbc01,lc_gbc02,lc_gbc03,lc_gbc05)
 
   DEFINE lc_gbc01       LIKE gbc_file.gbc01   # table id
   DEFINE lc_gbc02       LIKE gbc_file.gbc02   # field id
   DEFINE lc_gbc03       LIKE gbc_file.gbc03   # key value series
   DEFINE lc_gbc05       LIKE gbc_file.gbc05   # saved value
   DEFINE li_return      LIKE gbc_file.gbc05   # return value
   DEFINE li_i           LIKE type_file.num10  # No.FUN-690005 INTEGER
 
   IF g_aza.aza44 <> "Y" THEN RETURN 0 END IF
   
   LET lc_gbc05 = lc_gbc05 CLIPPED
   LET li_return=0
   LET li_i=0
   SELECT count(*) INTO li_i FROM gbc_file
    WHERE gbc01=lc_gbc01 AND gbc02=lc_gbc02 AND gbc03=lc_gbc03
      AND gbc04=g_aza.aza45
   IF li_i = 0 THEN
      INSERT INTO gbc_file(gbc01,gbc02,gbc03,gbc04,gbc05)
          VALUES (lc_gbc01,lc_gbc02,lc_gbc03,g_aza.aza45,lc_gbc05)
   ELSE
      UPDATE gbc_file SET gbc05=lc_gbc05
       WHERE gbc01=lc_gbc01 AND gbc02=lc_gbc02 AND gbc03=lc_gbc03
         AND gbc04=g_aza.aza45
   END IF
   LET li_return=SQLCA.sqlcode
 
   RETURN li_return
 
END FUNCTION
 
##################################################
# Descriptions...: 使用多語言記錄功能查詢段副程式
# Input parameter: ls_sql  已組完成待修正的 SQL      Ex. g_sql
#                  l_gbc01 檔案代碼  (Table ID)          "zx_file"
#                  l_gbc02 欄位代碼                      "zx02"
#                  l_gbc03 KEY 值序列名稱 多組時以,隔開  "zx01"
# Return code....: ls_sql 修正完的 SQL
# Usage..........: CALL cl_itemname_construct(g_sql,"zx_file","zx02","zx01")
#                  RETURNING g_sql
##################################################
 
FUNCTION cl_itemname_construct(ls_sql,lc_gbc01,lc_gbc02,ls_gbc03)
 
   DEFINE ls_sql       STRING
   DEFINE ls_sql_t     STRING
   DEFINE ls_sql_ts    STRING
   DEFINE lc_gbc01     LIKE gbc_file.gbc01
   DEFINE lc_gbc02     LIKE gbc_file.gbc02
   DEFINE ls_gbc03     STRING
   DEFINE ls_gbc02     STRING
   DEFINE li_gbc02     LIKE type_file.num5   # No.FUN-690005 SMALLINT
   DEFINE li_check     LIKE type_file.num5   # No.FUN-690005 SMALLINT
   DEFINE lc_check     LIKE type_file.chr1   # No.FUN-690005 VARCHAR(1)
   DEFINE li_cutpos    LIKE type_file.num10
   DEFINE li_cnt       LIKE type_file.num10
   DEFINE lsb_gbc03    base.StringBuffer
   DEFINE la_where     DYNAMIC ARRAY OF STRING
   DEFINE li_where     LIKE type_file.num5   # No.FUN-690005 SMALLINT
   DEFINE ls_where     STRING
 
   LET ls_sql=ls_sql.trim()
   IF g_aza.aza44 <> "Y" THEN
      RETURN ls_sql
   END IF
 
   DISPLAY  'INFO: Original SQL=',ls_sql
   LET ls_sql_t=ls_sql.toLowerCase()
 
   #if found word of where then change it!
   LET li_cutpos = ls_sql_t.getIndexOf("where",1) 
   IF li_cutpos THEN
 
      #if found field id (lc_gbc02) in where, then change it!
      LET ls_sql_t=ls_sql_t.subString(li_cutpos,ls_sql_t.getLength())
      IF ls_sql_t.getIndexOf(lc_gbc02 CLIPPED,1) THEN
 
         LET ls_gbc02=lc_gbc02 CLIPPED
         LET li_check=ls_sql_t.getIndexOf(lc_gbc02 CLIPPED,1)+ls_gbc02.getLength()+1
         LET lc_check=ls_sql_t.subString(li_check,li_check)
         IF lc_check NOT MATCHES "[<> =]" THEN
 
#            #check "FROM", if don't exist "gbc_file", add it!
#            IF NOT ls_sql.getIndexOf(",gbc_file",1) THEN
#               LET ls_sql=ls_sql.subString(1,li_cutpos-1),",gbc_file ",
#                          ls_sql.subString(li_cutpos,ls_sql.getLength())
#            END IF
#
#            #if choosen item include rowid, assigned original
#            LET ls_sql_t=ls_sql.toLowerCase()
#            LET li_rowid = ls_sql_t.getIndexOf("rowid",1)  
#            IF li_rowid THEN
#               IF NOT ls_sql_t.getIndexOf(lc_gbc01 CLIPPED||".rowid",1) THEN
#                  LET ls_sql = ls_sql.subString(1,li_rowid-1),lc_gbc01 CLIPPED||".",ls_sql.subString(li_rowid,ls_sql.getLength())
#               END IF
#            END IF 
 
            #start to modify where
            LET ls_sql_t=ls_sql.toLowerCase()
            LET li_where=ls_sql_t.getIndexOf('where',1)
 
            LET ls_sql_t=ls_sql.subString(li_where+5,ls_sql.getLength())
            LET ls_sql=ls_sql.subString(1,li_where+5)
            CALL la_where.clear()
            LET li_where=1
            WHILE TRUE
               LET ls_sql_t=ls_sql_t.trim()
               LET ls_sql_ts=ls_sql_t.toLowerCase()
               IF cl_null(ls_sql_t) THEN
                  EXIT WHILE
               END IF
               IF ls_sql_ts.getIndexOf("and 4=4",1) THEN
                  LET la_where[li_where]=ls_sql_t.subString(1,ls_sql_ts.getIndexOf("and 4=4",1)+7)
                  LET ls_sql_t=ls_sql_t.subString(ls_sql_ts.getIndexOf("and 4=4",1)+7,ls_sql_t.getLength())
                  LET li_where=li_where+1
                  CONTINUE WHILE
               END IF
               IF ls_sql_ts.getIndexOf("and",2) THEN
                  LET la_where[li_where]=ls_sql_t.subString(1,ls_sql_ts.getIndexOf("and",2)-1)
                  LET ls_sql_t=ls_sql_t.subString(ls_sql_ts.getIndexOf("and",1),ls_sql_t.getLength())
                  LET li_where=li_where+1
                  CONTINUE WHILE
               END IF
               IF ls_sql_ts.getIndexOf("group by",2) THEN
                  LET la_where[li_where]=ls_sql_t.subString(1,ls_sql_ts.getIndexOf("group by",2)-1)
                  LET ls_sql_t=ls_sql_t.subString(ls_sql_ts.getIndexOf("group by",1),ls_sql_t.getLength())
                  LET li_where=li_where+1
                  CONTINUE WHILE
               END IF
               IF ls_sql_ts.getIndexOf("having",2) THEN
                  LET la_where[li_where]=ls_sql_t.subString(1,ls_sql_ts.getIndexOf("having",2)-1)
                  LET ls_sql_t=ls_sql_t.subString(ls_sql_ts.getIndexOf("having",1),ls_sql_t.getLength())
                  LET li_where=li_where+1
                  CONTINUE WHILE
               END IF
               IF ls_sql_ts.getIndexOf("order by",2) THEN
                  LET la_where[li_where]=ls_sql_t.subString(1,ls_sql_ts.getIndexOf("order by",2)-1)
                  LET ls_sql_t=ls_sql_t.subString(ls_sql_ts.getIndexOf("order by",1),ls_sql_t.getLength())
                  LET li_where=li_where+1
                  CONTINUE WHILE
               END IF
               LET la_where[li_where]=ls_sql_t.subString(1,ls_sql_t.getLength())
               LET ls_sql_t = ""
               LET li_where=li_where+1
               CONTINUE WHILE
            END WHILE
 
            LET ls_sql_t=""
            IF la_where[1].getIndexOf("3=3",1) THEN
               LET ls_sql_t = la_where[1].trim()
            ELSE
               LET la_where[1] = "and ",la_where[1].trim()
            END IF
 
            #default only one time
            FOR li_where = 1 TO la_where.getLength()
               IF la_where[li_where].getIndexOf(lc_gbc02 CLIPPED||" ",1) OR
                  la_where[li_where].getIndexOf(lc_gbc02 CLIPPED||">",1) OR  
                  la_where[li_where].getIndexOf(lc_gbc02 CLIPPED||"=",1) OR  
                  la_where[li_where].getIndexOf(lc_gbc02 CLIPPED||"<",1) THEN
                  LET li_cnt=li_where
                  EXIT FOR
               END IF
            END FOR
 
            IF cl_null(ls_sql_t) THEN
               LET ls_sql_t=" 3=3 and (",ls_gbc03.trim()," in (select gbc03 from gbc_file where ",la_where[li_cnt].subString(4,la_where[li_cnt].getLength()),")) and 4=4"
            ELSE
               LET ls_sql_t=ls_sql_t.subString(1,ls_sql_t.getIndexOf("and 4=4",1)-1)," and ",
                            "(",ls_gbc03.trim()," in (select gbc03 from gbc_file where ",la_where[li_cnt].subString(4,la_where[li_cnt].getLength()),")) ",
                            ls_sql_t.subString(ls_sql_t.getIndexOf("and 4=4",1),ls_sql_t.getLength())
            END IF
 
            LET li_gbc02=ls_sql_t.getIndexOf(ls_gbc02,1)
            LET ls_sql_t=ls_sql_t.subString(1,li_gbc02-1),
                             " gbc01='",lc_gbc01 CLIPPED,"'",
                         " AND gbc02='",lc_gbc02 CLIPPED,"'",
                         " AND gbc05 ",
                         ls_sql_t.subString(li_gbc02+ls_gbc02.getLength(),ls_sql_t.getLength())
 
            FOR li_where = 1 TO la_where.getLength()
               IF la_where[li_where].getIndexOf("and 4=4",1) OR li_where=li_cnt THEN
                  CONTINUE FOR
               ELSE
                  LET ls_sql_t=ls_sql_t.trim()," ",la_where[li_where].trim()
               END IF
            END FOR
            LET ls_sql = ls_sql.trim()," ",ls_sql_t.trim()
 
#           LET ls_gbc02=lc_gbc02 CLIPPED
#           LET li_rowid=ls_sql.getIndexOf(lc_gbc02 CLIPPED,li_where)
#           LET ls_sql=ls_sql.subString(1,li_rowid-1),
#                          " gbc01='",lc_gbc01 CLIPPED,"' ",
#                      " AND gbc02='",lc_gbc02 CLIPPED,"' ",
#                      " AND ",ls_gbc03.trim(),
#                      " AND gbc05",
#                      ls_sql.subString(li_rowid+ls_gbc02.getLength(),ls_sql.getLength())
         END IF
      END IF
   END IF
   DISPLAY  'INFO: Modified SQL=',ls_sql
   RETURN ls_sql
 
END FUNCTION
 
#FUN-B50108
##################################################
# Descriptions...: 查詢語言別的名稱
# Input parameter: li_cmd,lc_gbc01,lc_gbc02,lc_gbc03,lc_gbc05
# Return code....: lc_gbc05
##################################################
 
FUNCTION cl_itemname_switch(li_cmd,lc_gbc01,lc_gbc02,lc_gbc03,lc_gbc05)
 
   DEFINE lc_gbc01     LIKE gbc_file.gbc01
   DEFINE lc_gbc02     LIKE gbc_file.gbc02
   DEFINE lc_gbc03     LIKE gbc_file.gbc03
   DEFINE lc_gbc05     LIKE gbc_file.gbc05
   DEFINE li_cmd       LIKE type_file.num5   # No.FUN-690005 SMALLINT
 
   IF g_aza.aza44 <> "Y" THEN RETURN lc_gbc05 CLIPPED END IF
   CASE li_cmd
      WHEN "1"   # current -> sys
         IF g_lang <> g_aza.aza45 THEN
            SELECT gbc05 INTO lc_gbc05 FROM gbc_file
             WHERE gbc01=lc_gbc01 AND gbc02=lc_gbc02
               AND gbc03=lc_gbc03 AND gbc04=g_aza.aza45
         END IF
      WHEN "2"   # sys -> current
         IF g_lang <> g_aza.aza45 THEN
            SELECT gbc05 INTO lc_gbc05 FROM gbc_file
             WHERE gbc01=lc_gbc01 AND gbc02=lc_gbc02
               AND gbc03=lc_gbc03 AND gbc04=g_lang
         END IF
      OTHERWISE
         LET lc_gbc05 = ""
   END CASE
   RETURN lc_gbc05
 
END FUNCTION
 
##################################################
# Descriptions...: 查詢指定語言別下的作業程式名稱
# Input parameter: lc_gaz01,lc_gaz02
# Return code....: lc_gaz03 該語言別下的作業程式名稱
##################################################
 
FUNCTION cl_get_progname(lc_gaz01,lc_gaz02)
 
   DEFINE lc_gaz01   LIKE gaz_file.gaz01
   DEFINE lc_gaz02   LIKE gaz_file.gaz02
   DEFINE lc_gaz03   LIKE gaz_file.gaz03 
 
   LET lc_gaz01 = lc_gaz01 CLIPPED
   LET lc_gaz02 = lc_gaz02 CLIPPED
 
   SELECT gaz03 INTO lc_gaz03 FROM gaz_file
    WHERE gaz01=lc_gaz01 AND gaz02=lc_gaz02 AND gaz05="Y"
   IF lc_gaz03 IS NULL OR lc_gaz03=" " THEN
      SELECT gaz03 INTO lc_gaz03 FROM gaz_file
       WHERE gaz01=lc_gaz01 AND gaz02=lc_gaz02 AND gaz05="N"
   END IF
 
   RETURN lc_gaz03
 
END FUNCTION
 
##################################################
# Descriptions...: 用來刪除該筆資料的相關多語言資料
# Input parameter: lc_gbc01 檔案代碼  (Table ID)   Ex. "zx_file"
#                  lc_gbc02 欄位代碼                   "zx02"
#                  lc_gbc03 KEY 值序列,多組時以,隔開   "hjwang"
# Return code....: TRUE/FALSE
# Usage..........: CALL cl_del_itemname("zx_file","zx02","hjwang")
# Memo...........: 使用 gbc_file
# Modify.........: CHI-6B0034
##################################################
 
FUNCTION cl_del_itemname(lc_gbc01,lc_gbc02,lc_gbc03)
 
   DEFINE lc_gbc01   LIKE gbc_file.gbc01
   DEFINE lc_gbc02   LIKE gbc_file.gbc02
   DEFINE lc_gbc03   LIKE gbc_file.gbc03 
 
   DELETE FROM gbc_file WHERE gbc01 = lc_gbc01
                          AND gbc02 = lc_gbc02
                          AND gbc03 = lc_gbc03
 
   IF SQLCA.SQLCODE THEN
      CALL cl_err('del gbc: ',SQLCA.SQLCODE,1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
 
END FUNCTION
 
