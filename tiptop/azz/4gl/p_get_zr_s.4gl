# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: p_get_zr_s.4gl
# Descriptions...: 1.會抓取所有寫在 p_link 作業中的程式資料 (p_zr提供檔名)
#                  2.程式行起始若為 #井號 --雙短線 {左大括號  則該行視為註解
#                  3.若行首為 {} or  該整行一樣視為註解, 理由同上
#           
#                  SELECT 規則
#                  1.SELECT 後十行 (含自身行) 內都會偵測 FROM 是否存在
#                  2.FROM 後面的資料不可拆行寫,要一行寫完
# Date & Author..: 05/07/08 alex
# Modify.........: No.FUN-570131 05/07/20 By alex 修改一些抓取錯誤點
# Modify.........: No.MOD-580163 05/08/16 By alex 刪除 WHERE 內涵的 table name
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-880019 08/09/18 By alex 補上若檔案不存在則不要再查 (安全機制處理)
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定

IMPORT os  
 
DATABASE ds
 
    DEFINE la_zr          DYNAMIC ARRAY OF RECORD
             zr02         LIKE zr_file.zr02,
             zr03         LIKE zr_file.zr03
                          END RECORD
 
FUNCTION p_get_zr_s(ls_prog)
 
    DEFINE ls_prog        STRING
    DEFINE lp_prog        base.Channel
    DEFINE lc_analy       LIKE type_file.chr1000  #FUN-680135 VARCHAR(300)
    DEFINE ls_analy       STRING
    DEFINE li_i,li_j      LIKE type_file.num5     #FUN-680135 SMALLINT 
    DEFINE li_length      LIKE type_file.num5     #FUN-680135 SMALLINT  
    DEFINE li_array       LIKE type_file.num5     #FUN-680135 SMALLINT 
    DEFINE li_lineno      LIKE type_file.num5     #FUN-680135 SMALLINT 
    DEFINE ls_select_list STRING
    DEFINE ls_update_list STRING
    DEFINE ls_insert_list STRING
    DEFINE ls_delete_list STRING
    DEFINE ls_tmp_list    STRING
 
    LET ls_select_list = ""
    LET ls_update_list = ""
    LET li_lineno = 11
 
    #安全機制的action id需要以合法的方式補到別支作業  #FUN-880019
    IF NOT os.Path.exists(ls_prog) THEN
       RETURN "","","","",""
    END IF
 
    LET lp_prog = base.Channel.create()
    CALL lp_prog.openFile(ls_prog,"r")
 
    WHILE lp_prog.read([lc_analy])
       LET li_lineno = li_lineno + 1
       LET ls_analy = DOWNSHIFT(lc_analy)
       LET ls_analy = ls_analy.trim()
 
       # 04/04/24 先判斷本行行頭是否以 # 或 -- 為開頭, 如果是就放棄這個找下個
       # 04/06/29 補上 { 符號   請勿在行首放大括號
       IF ls_analy.subString(1,1) = "#" OR ls_analy.subString(1,2) = "--" OR
          ls_analy.subString(1,1) = "{" THEN
          CONTINUE WHILE
       END IF
 
       # 05/07/08 抓 SELECT
       CALL ls_analy.getIndexOf("select ",1) RETURNING li_i
       IF li_i > 0 THEN  # p_get_zr_s_line_chknomemo  Check select前是否有註解 
          IF p_get_zr_s_line_chknomemo(ls_analy, li_i) THEN
             LET li_lineno = 0
             LET ls_analy = ls_analy.subString(li_i,ls_analy.getLength())
             LET li_j = ls_analy.getIndexOf("from ",1) 
             # FUN-570131 delete 'into temp'
             IF ls_analy.getIndexOf("into temp",li_j) THEN
                LET ls_analy = ls_analy.subString(1,ls_analy.getIndexOf("into temp",li_j)-1)
             END IF
             IF li_j > 0 THEN
                IF p_get_zr_s_line_chknomemo(ls_analy,li_j) THEN
                   LET ls_analy = ls_analy.subString(ls_analy.getIndexOf("from ",1)+4,ls_analy.getLength())
                   LET ls_analy = ls_analy.trim()
                   CALL p_get_zr_s_getfile("S",ls_analy.trim())
                END IF
             END IF
          END IF
          CONTINUE WHILE
       END IF
 
       # 05/07/08 抓 UPDATE
       CALL ls_analy.getIndexOf("update ",1) RETURNING li_i
       IF li_i > 0 THEN  # p_get_zr_s_line_chknomemo  Check select前是否有註解 
          IF p_get_zr_s_line_chknomemo(ls_analy, li_i) THEN
             LET li_lineno = 10
             LET ls_analy = ls_analy.subString(li_i+6,ls_analy.getLength())
             IF ls_analy.getIndexOf("set ",1) THEN
                LET ls_analy = ls_analy.subString(1,ls_analy.getIndexOf("set ",1)-1)
             END IF
             IF ls_analy.getIndexOf("_file",2) THEN
                CALL p_get_zr_s_getfile("U",ls_analy.trim())
             END IF
          END IF
          CONTINUE WHILE
       END IF
 
       # 05/07/08 抓 INSERT
       CALL ls_analy.getIndexOf("insert ",1) RETURNING li_i
       IF ls_analy.getIndexOf(" into ",1) AND
          li_i > 0 THEN  # p_get_zr_s_line_chknomemo  Check select前是否有註解 
          IF p_get_zr_s_line_chknomemo(ls_analy, li_i) THEN
             LET li_lineno = 10
             LET ls_analy = ls_analy.subString(li_i+6,ls_analy.getLength())
             LET ls_analy = ls_analy.trim()
             IF ls_analy.getIndexOf("into ",1) THEN
                LET ls_analy = ls_analy.subString(ls_analy.getIndexOf("into ",1)+4,ls_analy.getLength())
             END IF
             IF ls_analy.getIndexOf("_file",2) THEN
                CALL p_get_zr_s_getfile("I",ls_analy.trim())
             END IF
          END IF
          CONTINUE WHILE
       END IF
 
       # 05/07/08 抓 DELETE
       CALL ls_analy.getIndexOf("delete ",1) RETURNING li_i
       IF ls_analy.getIndexOf(" from ",1) AND
          li_i > 0 THEN  # p_get_zr_s_line_chknomemo  Check select前是否有註解 
          IF p_get_zr_s_line_chknomemo(ls_analy, li_i) THEN
             LET li_lineno = 10
             LET ls_analy = ls_analy.subString(li_i+6,ls_analy.getLength())
             LET ls_analy = ls_analy.trim()
             IF ls_analy.getIndexOf("from ",1) THEN
                LET ls_analy = ls_analy.subString(ls_analy.getIndexOf("from ",1)+4,ls_analy.getLength())
             END IF
             IF ls_analy.getIndexOf("_file",2) THEN
                CALL p_get_zr_s_getfile("D",ls_analy.trim())
             END IF
          END IF
          CONTINUE WHILE
       END IF
 
       # 05/07/10 FUN-570131 抓 CREATE TEMP TABLE
       CALL ls_analy.getIndexOf("table ",1) RETURNING li_i
       IF ls_analy.getIndexOf("create ",1) AND ls_analy.getIndexOf("temp ",1) AND
          li_i > 0 THEN  # p_get_zr_s_line_chknomemo  Check select前是否有註解 
          IF p_get_zr_s_line_chknomemo(ls_analy, li_i) THEN
             LET li_lineno = 10
             LET ls_analy = ls_analy.subString(li_i+5,ls_analy.getLength())
             LET ls_analy = ls_analy.trim()
             IF ls_analy.getIndexOf("_file",2) THEN
                CALL p_get_zr_s_getfile("T",ls_analy.trim())
             END IF
          END IF
          CONTINUE WHILE
       END IF
 
       # 05/07/10 FUN-570131 抓 INTO TEMP
       CALL ls_analy.getIndexOf("into ",1) RETURNING li_i
       IF ls_analy.getIndexOf("temp ",1) AND
          li_i > 0 THEN  # p_get_zr_s_line_chknomemo  Check select前是否有註解 
          IF p_get_zr_s_line_chknomemo(ls_analy, li_i) THEN
             LET li_lineno = 10
             LET ls_analy = ls_analy.subString(li_i+4,ls_analy.getLength())
             LET ls_analy = ls_analy.trim()
             IF ls_analy.getIndexOf("_file",2) THEN
                CALL p_get_zr_s_getfile("T",ls_analy.trim())
             END IF
          END IF
          CONTINUE WHILE
       END IF
 
       IF li_lineno <= 10 AND li_lineno >0 THEN
          LET li_i = ls_analy.getIndexOf("from ",1)
          IF li_i > 0 THEN
             IF p_get_zr_s_line_chknomemo(ls_analy,li_i) THEN
                LET ls_analy = ls_analy.subString(li_i+4,ls_analy.getLength())
                CALL p_get_zr_s_getfile("S",ls_analy.trim())
             END IF
          END IF
       END IF
 
    END WHILE
 
    CALL lp_prog.close()
    LET ls_select_list=""      LET ls_update_list=""
    LET ls_insert_list=""      LET ls_delete_list=""
    LET ls_tmp_list=""
 
    # 抓 array 組合
    LET li_array = la_zr.getLength()
    FOR li_j=1 TO li_array
       CASE la_zr[li_j].zr03 
          WHEN "S" 
             LET ls_select_list= ls_select_list,la_zr[li_j].zr02 CLIPPED, ", "
          WHEN "U" 
             LET ls_update_list= ls_update_list,la_zr[li_j].zr02 CLIPPED, ", "
          WHEN "I" 
             LET ls_insert_list= ls_insert_list,la_zr[li_j].zr02 CLIPPED, ", "
          WHEN "D" 
             LET ls_delete_list= ls_delete_list,la_zr[li_j].zr02 CLIPPED, ", "
          WHEN "T" 
             LET ls_tmp_list= ls_tmp_list,la_zr[li_j].zr02 CLIPPED, ", "
       END CASE
    END FOR
 
    LET ls_select_list = ls_select_list.subString(1,ls_select_list.getLength()-2)
    LET ls_update_list = ls_update_list.subString(1,ls_update_list.getLength()-2)
    LET ls_insert_list = ls_insert_list.subString(1,ls_insert_list.getLength()-2)
    LET ls_delete_list = ls_delete_list.subString(1,ls_delete_list.getLength()-2)
    LET ls_tmp_list    = ls_tmp_list.subString(1,ls_tmp_list.getLength()-2)
 
    RETURN ls_select_list,ls_update_list,ls_insert_list,ls_delete_list,ls_tmp_list
 
END FUNCTION
 
 
FUNCTION p_get_zr_s_line_chknomemo(ls_analy, li_i)
 
   DEFINE ls_analy     STRING
   DEFINE ls_tmp       STRING
   DEFINE li_i         LIKE type_file.num10    #FUN-680135 INTEGER
 
   LET ls_tmp = ls_analy.subString(1,li_i)
   IF ls_tmp.getIndexOf("#",1) THEN
      RETURN FALSE
   END IF
   IF ls_tmp.getIndexOf("--",1) THEN
      RETURN FALSE
   END IF
 
   RETURN TRUE
END FUNCTION
 
 
FUNCTION p_get_zr_s_getfile(lc_type,ls_analy)
 
   DEFINE lc_type     LIKE type_file.chr1     #FUN-680135 VARCHAR(1)
   DEFINE ls_analy    STRING
   DEFINE ls_filename STRING
   DEFINE li_i,li_j   LIKE type_file.num5     #FUN-680135 SMALLINT 
   DEFINE li_array    LIKE type_file.num10    #FUN-680135 INTEGER
   DEFINE li_check    LIKE type_file.num5     #FUN-680135 SMALLINT 
 
   WHILE TRUE
      IF NOT ls_analy.getIndexOf("_file",1) THEN
         EXIT WHILE
      END IF
# display 'bef==',ls_analy
      LET li_i = ls_analy.getIndexOf("_file",1)
      IF li_i > 10 THEN
         LET ls_analy = ls_analy.subString(li_i-10, ls_analy.getLength())
         LET ls_analy = ls_analy.trim()
      END IF 
      LET li_i = ls_analy.getIndexOf("_file",1)
      LET li_j = ls_analy.getIndexOf(",",1)
      IF li_j < li_i AND li_j != 0 THEN
         LET ls_analy = ls_analy.subString(li_j+1, ls_analy.getLength())
         LET ls_analy = ls_analy.trim()
      END IF 
      LET li_i = ls_analy.getIndexOf("_file",1)
      LET li_j = ls_analy.getIndexOf(".",1)
      IF li_j < li_i AND li_j != 0 THEN
         LET ls_analy = ls_analy.subString(li_j+1, ls_analy.getLength())
         LET ls_analy = ls_analy.trim()
      END IF 
      LET li_i = ls_analy.getIndexOf("_file",1)
      LET li_j = ls_analy.getIndexOf("(",1) 
      IF li_j < li_i AND li_j != 0 THEN
         LET ls_analy = ls_analy.subString(li_j+1,ls_analy.getLength())
         LET ls_analy = ls_analy.trim()
      END IF 
      LET li_i = ls_analy.getIndexOf("_file",1)
      LET li_j = ls_analy.getIndexOf('"',1) 
      IF li_j < li_i AND li_j != 0 THEN
         LET ls_analy = ls_analy.subString(li_j+1,ls_analy.getLength())
         LET ls_analy = ls_analy.trim()
      END IF 
      LET li_i = ls_analy.getIndexOf("_file",1)
      LET li_j = ls_analy.getIndexOf(":",1) 
      IF li_j < li_i AND li_j != 0 THEN
         LET ls_analy = ls_analy.subString(li_j+1,ls_analy.getLength())
         LET ls_analy = ls_analy.trim()
      END IF 
      LET li_i = ls_analy.getIndexOf("_file",1)
      LET li_j = ls_analy.getIndexOf("'",1) 
      IF li_j < li_i AND li_j != 0 THEN
         LET ls_analy = ls_analy.subString(li_j+1,ls_analy.getLength())
         LET ls_analy = ls_analy.trim()
      END IF 
 
 #     #MOD-580163
      LET li_i = ls_analy.getIndexOf("_file",1)
      LET li_j = ls_analy.getIndexOf("where",1)
      IF li_j > li_i AND li_j != 0 THEN
         LET ls_analy = ls_analy.subString(1,li_j-1)
         LET ls_analy = ls_analy.trim()
      END IF
 
#     #FUN-570131
      LET li_j = ls_analy.getIndexOf("#",1) 
      IF li_j > 0 THEN
         LET ls_analy = ls_analy.subString(1,li_j-1)
         LET ls_analy = ls_analy.trimRight()
      END IF 
      LET li_j = ls_analy.getIndexOf("--",1) 
      IF li_j > 0 THEN
         LET ls_analy = ls_analy.subString(1,li_j-1)
         LET ls_analy = ls_analy.trimRight()
      END IF 
      LET li_i = ls_analy.getIndexOf("_file",1)
      LET li_j = ls_analy.getIndexOf("OUTER ",1) 
      IF li_j < li_i AND li_j != 0 THEN
         LET ls_analy = ls_analy.subString(li_j+5,ls_analy.getLength())
         LET ls_analy = ls_analy.trim()
      END IF 
      LET li_i = ls_analy.getIndexOf("_file",1)
      LET li_j = ls_analy.getIndexOf("join ",1) 
      IF li_j < li_i AND li_j != 0 THEN
         LET ls_analy = ls_analy.subString(li_j+4,ls_analy.getLength())
         LET ls_analy = ls_analy.trim()
      END IF 
      LET li_i = ls_analy.getIndexOf("_file",1)
      LET li_j = ls_analy.getIndexOf(" ",1)
      IF li_j < li_i AND li_j != 0 THEN
         LET ls_analy = ls_analy.subString(li_j+1, ls_analy.getLength())
         LET ls_analy = ls_analy.trim()
      END IF 
      LET li_i = ls_analy.getIndexOf("_file",1)
      LET ls_filename = ls_analy.subString(1,li_i+4)
# display 'aft==',ls_filename
 
      IF ls_analy.getLength() > li_i+5 THEN
         LET ls_analy = ls_analy.subString(li_i+5,ls_analy.getLength())
         LET ls_analy = ls_analy.trim()
      END IF
 
      # 比對是否已經有加進來的  所以把它寫到 array 最後再組出來
      LET li_check=FALSE
      LET li_array = la_zr.getLength()
      FOR li_j=1 TO li_array
          IF ls_filename.trim() = la_zr[li_j].zr02 CLIPPED AND
             lc_type = la_zr[li_j].zr03 THEN
             LET li_check = TRUE
             EXIT FOR
          END IF
      END FOR
      IF NOT li_check THEN
         LET la_zr[li_array+1].zr02 = ls_filename.trim()
         LET la_zr[li_array+1].zr03 = lc_type CLIPPED
      END IF
      IF NOT ls_analy.getLength() > li_i+5 THEN
         EXIT WHILE
      END IF
 
   END WHILE
 
END FUNCTION
