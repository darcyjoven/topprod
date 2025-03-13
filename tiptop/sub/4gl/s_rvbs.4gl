# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: s_rvbs.4gl
# Descriptions...: 
# Date & Author..: FUN-810045 by rainy 
# Input Parameter: 
# Return code....: 
# Modify.........: No.FUN-810036 08/04/22 By Nicola rvbs03預設值修改
# Modify.........: NO.CHI-860008 08/06/11 BY yiting 刪除rvbs_file條件修改 
# Modify.........: No.MOD-870219 08/07/17 By Nicola 檢驗順序修改 
# Modify.........: No.FUN-870146 08/08/28 By xiaofeizhu 增加對rvbs13的判斷
# Modify.........: No.FUN-980012 09/08/26 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No:TQC-9C0174 09/12/28 By sherry 在asfi510 asfi520里面維護的批序號內容,在asfi511 asfi526等作業里面查不到
# Modify.........: No:FUN-AB0059 10/11/16 By huangtao 添加料號相關控卡
# Modify.........: No:TQC-AC0262 10/12/21 By lilingyu it規範中要求g_prog不可更改
# Modify.........: No:FUN-C70014 12/07/09 By wangwei 新增RUN CARD發料作業
# Modify.........: No.DEV-D40013 13/04/15 By Nina 純過單 

DATABASE ds
 
GLOBALS "../../config/top.global"   
 
 
#依專案代碼及料號判斷是否該做批序號管理
FUNCTION s_chk_rvbs(l_pja01,l_ima01)   
 DEFINE l_pja01    LIKE pja_file.pja01,
        l_ima01    LIKE ima_file.ima01
 DEFINE l_i,l_cnt  LIKE type_file.num5,
        l_pja26     LIKE pja_file.pja26

#FUN-AB0059 ---------------------start---------------------------- 
 IF s_joint_venture( l_ima01,g_plant) OR NOT s_internal_item( l_ima01,g_plant ) THEN
    RETURN FALSE
 END IF
#FUN-AB0059 ---------------------end-------------------------------
 IF NOT cl_null(l_pja01) THEN
   SELECT pja26 INTO l_pja26 FROM pja_file
    WHERE pja01 = l_pja01
   IF l_pja26 = 'Y' THEN
     SELECT COUNT(*) INTO l_cnt FROM ima_file
      WHERE ima01 = l_ima01
        AND (ima918 = 'Y' OR ima921 = 'Y')
     IF l_cnt = 0 THEN
        RETURN TRUE
     END IF
   END IF
 END IF
 
 RETURN FALSE
END FUNCTION
 
#080402全部併到 rvbs_file,取消ogbs_file,rvbs09:1入 -1出
#INSET 資料到rvbs_file/ogbs_file
#l_act :入出庫   1:出庫(ogbs_file)   2:入庫(rvbs_file)
#rvbs00:作業代號 g_prog
#rvbs01:單號
#rvbs02:單身序號
#rvbs021:料號
#rvbs022.dbo.rvbs_file序號 (此處不做批號管理的固定為1)
#rvbs06:單身數量 (必需換算成庫存數量)
#rvbs08:專案代號
#rvbs09: 1/-1  case 1入庫 / -1出庫  #080402異動
 
FUNCTION s_ins_rvbs(l_act,b_rvbs)   #rvbs傳整個table
 DEFINE l_act    LIKE type_file.chr1
 DEFINE b_rvbs  RECORD LIKE rvbs_file.*,
        l_rvbs  RECORD LIKE rvbs_file.*
 IF cl_null(b_rvbs.rvbs01) THEN RETURN END IF
 
 
 LET b_rvbs.rvbs022 = 1
 LET b_rvbs.rvbs03 = ' '   #No.FUN-810036
 LET b_rvbs.rvbs04 = ' '
 LET b_rvbs.rvbs05 = null
 LET b_rvbs.rvbs07 = '3'
 LET b_rvbs.rvbsplant = g_plant #FUN-980012 add
 LET b_rvbs.rvbslegal = g_legal #FUN-980012 add
 
 CASE l_act
   WHEN "1"  #出庫
     LET b_rvbs.rvbs09 = -1
 
  WHEN "2"   #入庫
     LET b_rvbs.rvbs09 = 1
 
 END CASE
 
 
 CASE l_act
   WHEN "1"  #出庫
     LET b_rvbs.rvbs09 = -1
 
  WHEN "2"   #入庫
     LET b_rvbs.rvbs09 = 1
 
 END CASE
 
 SELECT * INTO l_rvbs.*  FROM rvbs_file
  WHERE rvbs00 = b_rvbs.rvbs00
    AND rvbs01 = b_rvbs.rvbs01
    AND rvbs02 = b_rvbs.rvbs02
    AND rvbs03 = b_rvbs.rvbs03
    AND rvbs04 = b_rvbs.rvbs04
    AND rvbs07 = b_rvbs.rvbs07
    AND rvbs09 = b_rvbs.rvbs09
 IF SQLCA.sqlcode = 100 THEN
 
    INSERT INTO rvbs_file values(b_rvbs.*)
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","rvbs_file",b_rvbs.rvbs01,b_rvbs.rvbs02,STATUS,"","",1)
       LET g_success = 'N'
    END IF
 ELSE
    UPDATE rvbs_file
       SET rvbs021 = b_rvbs.rvbs021 
          ,rvbs06 = b_rvbs.rvbs06
          ,rvbs08 = b_rvbs.rvbs08
     WHERE rvbs00 = b_rvbs.rvbs00
       AND rvbs01 = b_rvbs.rvbs01
       AND rvbs02 = b_rvbs.rvbs02
       AND rvbs03 = b_rvbs.rvbs03
       AND rvbs04 = b_rvbs.rvbs04
       AND rvbs07 = b_rvbs.rvbs07
       AND rvbs09 = b_rvbs.rvbs09
    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","rvbs_file",b_rvbs.rvbs01,b_rvbs.rvbs02,STATUS,"","",1)
       LET g_success = 'N'
    END IF
 END IF
END FUNCTION
 
#刪除rvbs_file
#l_act:入出庫    1:出庫  2:入庫
#l_rvbs01 單號
#l_rvbs02 單身序號
#l_rvbs13 檢驗順序
FUNCTION s_del_rvbs(l_act,l_rvbs01,l_rvbs02,l_rvbs13)
 DEFINE l_act    LIKE type_file.chr1,
        l_rvbs01 LIKE rvbs_file.rvbs01,
        l_rvbs02 LIKE rvbs_file.rvbs02,
        l_rvbs13 LIKE rvbs_file.rvbs13
 DEFINE l_sfp06  LIKE sfp_file.sfp06  #TQC-9C0174 add
 DEFINE l_prog   LIKE type_file.chr20 #TQC-AC0262  

 LET l_prog = g_prog     #TQC-AC0262

     IF cl_null(l_rvbs13) THEN                    #FUN-870146
        LET l_rvbs13=0                            #FUN-870146
     END IF                                       #FUN-870146
 #TQC-9C0174---Begin
 SELECT sfp06 INTO l_sfp06 FROM sfp_file
  WHERE sfp01 = l_rvbs01
 IF g_prog = 'asfi510' THEN
    IF l_sfp06 = '1' THEN LET l_prog = 'asfi511' END IF    #TQC-AC0262 g_prog -> l_prog
    IF l_sfp06 = '2' THEN LET l_prog = 'asfi512' END IF    #TQC-AC0262 g_prog -> l_prog
    IF l_sfp06 = '3' THEN LET l_prog = 'asfi513' END IF    #TQC-AC0262 g_prog -> l_prog
    IF l_sfp06 = '4' THEN LET l_prog = 'asfi514' END IF    #TQC-AC0262 g_prog -> l_prog
    IF l_sfp06 = 'D' THEN LET l_prog = 'asfi519' END IF    #FUN-C70014
 END IF
 IF g_prog= 'asfi520' THEN
    IF l_sfp06 = '6' THEN LET l_prog = 'asfi526' END IF    #TQC-AC0262 g_prog -> l_prog
    IF l_sfp06 = '7' THEN LET l_prog = 'asfi527' END IF    #TQC-AC0262 g_prog -> l_prog
    IF l_sfp06 = '8' THEN LET l_prog = 'asfi528' END IF    #TQC-AC0262 g_prog -> l_prog
    IF l_sfp06 = '9' THEN LET l_prog = 'asfi529' END IF    #TQC-AC0262 g_prog -> l_prog
 END IF
 #TQC-9C0174---End
 CASE l_act 
   WHEN "1"  #出庫
    DELETE FROM rvbs_file
     WHERE rvbs00 = l_prog                                 #TQC-AC0262 g_prog -> l_prog
       AND rvbs01 = l_rvbs01
       AND rvbs02 = l_rvbs02
       #AND rvbs03 = ' '   #No.FUN-810036    #NO.CHI-860008 MARK
       #AND rvbs04 = ' '                     #NO.CHI-860008 mark
       #AND rvbs07 = '3'                     #NO.CHI-860008 mark
       #AND rvbs08 = l_rvbs08                #NO.CHI-860008 mark
        AND rvbs13 = l_rvbs13   #No.MOD-870219
       AND rvbs09 = -1  #-1出庫
     IF SQLCA.sqlcode THEN     
        CALL cl_err3("del","rvbs_file",l_rvbs01,l_rvbs02,SQLCA.sqlcode,"","",1)
        RETURN FALSE
     END IF
 
   WHEN "2"  #入庫 
     DELETE FROM rvbs_file
      WHERE rvbs00 = l_prog                                #TQC-AC0262 g_prog -> l_prog     
        AND rvbs01 = l_rvbs01
        AND rvbs02 = l_rvbs02
        #AND rvbs03 = ' '    #No.FUN-810036   #NO.CHI-860008 MARK
        #AND rvbs04 = ' '                     #NO.CHI-860008 MARK
        #AND rvbs07 = '3'                     #NO.CHI-860008 MARK 
        #AND rvbs08 = l_rvbs08                #NO.CHI-860008 MARK
        AND rvbs13 = l_rvbs13   #No.MOD-870219
        AND rvbs09 = 1   #1入庫 
     IF SQLCA.sqlcode THEN        
        CALL cl_err3("del","rvbs_file",l_rvbs01,l_rvbs02,SQLCA.sqlcode,"","",1)
        RETURN FALSE
     END IF
 END CASE
 RETURN TRUE
END FUNCTION
 
#FUN-810045
#DEV-D40013 add
