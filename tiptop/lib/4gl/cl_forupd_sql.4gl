# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Program name...: cl_forupd_sql.4gl
# Descriptions...: 判斷 SELECT ... FOR UPDATE 是否加上其他語法(by Database)
# Date & Author..: 03/09/04 by Brendan
# Usage..........: CALL cl_forupd_sql(ps_forupd_sql)
# Modify.........: No.FUN-750079 07/05/21 by alex 新增MSV判斷條件
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-A70116 10/07/22 By alex 若已有NOWAIT/UPDLOCK字串時不再增加
# Modify.........: No.FUN-AA0067 10/10/25 By alex 新增to_char function
 
DATABASE ds   #FUN-7C0053
 
#GLOBALS "../../config/top.global"
 
# Descriptions...: 判斷 SELECT ... FOR UPDATE 是否加上其他語法(by Database)
# Date & Author..: 2003/09/04 by Brendan
# Input Parameter: ps_forupd_sql STRING 原傳入 SQL 字串
# Return Code....: ps_forupd_sql STRING 調整過的 SQL 字串
# Modify.........: 07/05/21 FUN-750079 by alex 新增MSV判斷條件
 
FUNCTION cl_forupd_sql(ps_forupd_sql)
 
  DEFINE ps_forupd_sql STRING
  DEFINE ps_temp1      STRING  #FUN-750079
  DEFINE li_pos        LIKE type_file.num5
 
  CASE cl_db_get_database_type()
     WHEN "IFX"
        # IFX為基本語法，不作任何增加或調整
     WHEN "ORA"
        IF NOT ps_forupd_sql.getIndexOf(" NOWAIT",1) THEN      #FUN-A70116
           LET ps_forupd_sql = ps_forupd_sql CLIPPED, " NOWAIT"
        END IF
     WHEN "MSV"
        IF NOT ps_forupd_sql.getIndexOf(" UPDLOCK ",1) THEN      #FUN-A70116
           LET ps_temp1 = ps_forupd_sql.toLowerCase()
           IF ps_temp1.getIndexOf("where ",1) THEN
              LET ps_forupd_sql = ps_forupd_sql.subString(1,ps_temp1.getIndexOf("where ",1)-1),
                                  " UPDLOCK ",
                                  ps_forupd_sql.subString(ps_temp1.getIndexOf("where ",1),ps_temp1.getLength())
           END IF
        END IF
     WHEN "ASE"
        # ASE為基本語法，不作任何增加或調整
     WHEN "DB2"
     OTHERWISE
  END CASE
 
  RETURN ps_forupd_sql
 
END FUNCTION
 
# Descriptions...: 回傳 to_char的字串
# Date & Author..: 2010/10/25 by alex
# Input Parameter: lc_colid  CHAR(50) 欄位名稱
#                  lc_type   CHAR(50) 可接受型態 mm-dd-yy 或 yy/mm/dd 或 yymmdd (yy可代換用 yyyy,大小寫均可)
# Return Code....: ls_sql STRING 調整過的 SQL 字串
 
FUNCTION cl_tp_tochar(lc_colid,lc_type)         #FUN-AA0067

  DEFINE lc_colid    LIKE type_file.chr50
  DEFINE lc_type     LIKE type_file.chr50
  DEFINE li_type     LIKE type_file.num5
  DEFINE ls_cmd      STRING

  CASE
     WHEN db_get_database_type() = "ORA"
        LET ls_cmd = "to_char(",lc_colid CLIPPED,",'",lc_type CLIPPED,"')"

     WHEN db_get_database_type() = "MSV" OR db_get_database_type() = "ASE"
          LET lc_type = DOWNSHIFT(lc_type)
        CASE
           WHEN lc_type = "mm-dd-yy"    LET li_type = 10
           WHEN lc_type = "mm-dd-yyyy"  LET li_type = 110
           WHEN lc_type = "yy/mm/dd"    LET li_type = 11
           WHEN lc_type = "yyyy/mm/dd"  LET li_type = 111
           WHEN lc_type = "yymmdd"      LET li_type = 12
           WHEN lc_type = "yyyymmdd"    LET li_type = 112
           OTHERWISE LET li_type = 0
        END CASE
        LET ls_cmd = "convert(varchar,",lc_colid CLIPPED,",",li_type USING "<<<<",")"

     OTHERWISE
        # 基本語法，不作任何增加或調整
        LET ls_cmd = "to_char(",lc_colid CLIPPED,",'",lc_type CLIPPED,"')"
  END CASE

  RETURN ls_cmd
END FUNCTION
