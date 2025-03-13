# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: p_recomd5.4gl
# Descriptions...: 將指定的程式特徵碼寫入db
# Date & Author..: 12/03/01 by alex
# Modify.........: No.FUN-C30003 12/03/01 By alex 新增作業

IMPORT os
DATABASE ds

DEFINE g_gdt RECORD LIKE gdt_file.*
DEFINE gs_path     STRING

MAIN
  DEFINE ls_cmd   STRING

  LET g_gdt.gdt01 = ARG_VAL(1) 
  LET g_gdt.gdt02 = ARG_VAL(2) 
  IF g_gdt.gdt01[1,1] = "c" THEN
     LET gs_path = os.Path.join(os.Path.join(FGL_GETENV("CUST"),g_gdt.gdt01),"4gl")
  ELSE
     LET gs_path = os.Path.join(os.Path.join(FGL_GETENV("TOP"),g_gdt.gdt01),"4gl")
  END IF

  CALL p_recomd5_sql()

END MAIN


FUNCTION p_recomd5_sql()

  DEFINE ls_filepath    STRING
  DEFINE ls_tmp         STRING
  DEFINE lc_channel     base.channel
  DEFINE ls_cmd         STRING
  DEFINE ls_result      STRING
  DEFINE li_cnt         LIKE type_file.num5

  LET ls_filepath = os.Path.join(gs_path,g_gdt.gdt02)

  LET ls_tmp = os.Path.mtime(ls_filepath)

  LET lc_channel = base.Channel.create()
  LET ls_cmd = "md5sum ",ls_filepath    
  CALL lc_channel.openPipe(ls_cmd,"r")
  WHILE (lc_channel.read(ls_result))
     LET ls_result = ls_result.trim()
  END WHILE

  LET g_gdt.gdt03 = ls_result.subString(1,ls_result.getIndexOf(" ",1)-1)
  LET g_gdt.gdt04 = MDY(ls_tmp.subString(6,7),ls_tmp.substring(9,10),ls_tmp.subString(1,4))
  LET g_gdt.gdt05 = "prodcent"
  LET g_gdt.gdtuser = FGL_GETENV("LOGNAME")
  LET g_gdt.gdtdate = TODAY

  SELECT COUNT(*) INTO li_cnt FROM gdt_file
   WHERE gdt01=g_gdt.gdt01 AND gdt02=g_gdt.gdt02
  IF li_cnt > 0 THEN
     DELETE FROM gdt_file
      WHERE gdt01=g_gdt.gdt01 AND gdt02=g_gdt.gdt02
  END IF

  INSERT INTO gdt_file VALUES(g_gdt.*)
  display 'Module=',g_gdt.gdt01," Program=",g_gdt.gdt02," MD5=",g_gdt.gdt03

END FUNCTION


