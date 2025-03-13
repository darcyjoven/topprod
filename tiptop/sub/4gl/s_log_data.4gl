GLOBALS "../../config/top.global"
# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Library name...: s_log_data
# Descriptions...: 程序重要移動情況記錄作業
# Date & Author..: 2012/11/26 By zhangweib     FUN-CB0096
# Modify.........: No.MOD-D70064 2013/08/05 By zhangweib 新增重複時g_id加一
# Modify.........: No.MOD-D90005 13/09/02 By yinhy 增加WHENEVER ERROR CALL cl_err_msg_log

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_azu      RECORD LIKE azu_file.*      #FUN-CB0096

# Descriptions...: 記錄程序操作情況
# Input Parameter: p_cmd   執行方式 'I' 新增 / 'U' 更新
# Input Parameter: p_act   執行動作 '100' 執行、'101'新增....
# Return Code....: none
# Usgae..........: CALL s_log_data('I','100','DS1aglt110100tiptop20121122171917000000','1','171917','876-120900001','TP1-121100003')
FUNCTION s_log_data(p_cmd,p_act,p_id,p_chr,p_time,p_azu10,p_azu14)
   DEFINE p_cmd      LIKE type_file.chr1   #'I' 新增 'U' 修改
   DEFINE p_act      LIKE type_file.chr5   #動作
   DEFINE p_id       LIKE azu_file.azu00   #唯一流水號
   DEFINE p_time     LIKE type_file.chr8   #記錄時間
   DEFINE p_azu10    LIKE azu_file.azu10   #單據編號
   DEFINE p_azu14    LIKE azu_file.azu14   #關聯單號
   DEFINE p_chr      LIKE type_file.chr1   #'1' 人工 '2'系統


   WHENEVER ERROR CALL cl_err_msg_log   #MOD-D90005

   #初始化基本資料
   IF p_cmd = 'I' AND p_act = '100' THEN
      LET g_azu.azu00 = p_id
      LET g_azu.azu01 = g_plant
      LET g_azu.azu02 = g_legal
      LET g_azu.azu03 = "AGL"
      LET g_azu.azu04 = g_today
      LET g_azu.azu09 = g_prog
      LET g_azu.azu11 = g_user
      LET g_azu.azu15 = FGL_GETENV("FGLSERVER")
   END IF
   LET g_azu.azu13 = p_chr
   LET g_azu.azu12 = p_act
   IF p_cmd = 'U' THEN
      UPDATE azu_file SET azu06 = g_today,
                          azu07 = p_time,
                          azu08 = (p_time - azu05) / 60
       WHERE azu00 = g_azu.azu00
         AND azu12 = '100'
   ELSE
      LET g_azu.azu05 = p_time
      IF p_act != '100' THEN
         LET g_azu.azu10 = p_azu10
         LET g_azu.azu14 = p_azu14
      END IF
      INSERT INTO azu_file VALUES (g_azu.*)
     #No.MOD-D70064 ---Add--- Start
      IF SQLCA.SQLERRD[2] = '-268' THEN
         LET g_azu.azu10 = g_azu.azu10 + 1
         INSERT INTO azu_file VALUES (g_azu.*)
      END IF
     #No.MOD-D70064 ---Add--- End
   END IF
END FUNCTION

FUNCTION s_log_check(p_code)
   DEFINE p_code   LIKE azu_file.azu14
   DEFINE l_azu10  LIKE azu_file.azu10
   DEFINE l_i      LIKE type_file.num5

   SELECT DISTINCT azu10 INTO l_azu10 FROM azu_file
    WHERE azu14 = p_code
      AND azu04 = (SELECT MAX(azu04) FROM azu_file WHERE azu14 = p_code)
      AND azu05 = (SELECT MAX(azu05) FROM azu_file WHERE azu14 = p_code) 

   IF NOT cl_null(l_azu10) THEN
      SELECT COUNT(*) INTO l_i FROM aba_file WHERE aba01 = l_azu10
      IF l_i > 0 THEN
         RETURN ''
      ELSE
         RETURN l_azu10
      END IF
   ELSE
      RETURN ''
   END IF

END FUNCTION
