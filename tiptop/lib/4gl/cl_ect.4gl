# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Library name...: cl_ect.4gl
# Descriptions...: 
# Date & Author..: 2020/12/08 by zhangzs

IMPORT os # No.FUN-B10061

DATABASE ds
GLOBALS "../../config/top.global"


FUNCTION cl_ect(g_ect01,g_ect02,g_ect03,g_ect04,g_ect05,g_ect06) #add g_ect06 by zhangzs 210902
DEFINE g_ect01    LIKE ect_file.ect01  #作业编号
DEFINE g_ect02    LIKE ect_file.ect02  #单据编号
DEFINE g_ect03    LIKE ect_file.ect03  #操作人
DEFINE g_ect04    LIKE ect_file.ect04  #操作类型
DEFINE g_ect05    LIKE ect_file.ect05  #日期+时间
DEFINE g_ect06    LIKE ect_file.ect06  #日期+时间

  INSERT INTO ect_file VALUES (g_ect01,g_ect02,g_ect03,g_ect04,g_ect05,g_ect06)
      
  IF SQLCA.SQLCODE THEN
     CALL cl_err('新增ect表失败', SQLCA.SQLCODE, 0)
  END IF 
END FUNCTION