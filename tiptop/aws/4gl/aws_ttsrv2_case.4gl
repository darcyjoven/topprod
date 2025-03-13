# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aws_ttsrv2_case.4gl
# Descriptions...: delivery operate according as different Object and Operate
# Date & Author..: 08/10/20 shengbb generate by awsi002 automatically
# Modify.........: 新建 FUN-8A0122
# Modify.........: 08/12/11 By shengbb awsi002 automatically
# Memo...........: 本程序是由awsi002作業自動產生，如需更改，請維護awsi002作業的第二單身。
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
FUNCTION aws_ttsrv2_case(l_ObjectID,l_Operate)
DEFINE
  l_ObjectID  LIKE wam_file.wam01,
  l_Operate  LIKE wam_file.wam02,
  l_errCode STRING,
  l_errDesc STRING
 
  CASE
 
    WHEN (l_ObjectID= 'ITEM' AND l_Operate= 'INSERT')
      CALL aws_createitem() RETURNING l_errCode,l_errDesc
 
    WHEN TRUE
      LET l_errCode='aws-333'
      LET l_errDesc='Cannot_Found'
    OTHERWISE
  END CASE
      RETURN l_errCode,l_errDesc
END FUNCTION
#No.FUN-8A0122
