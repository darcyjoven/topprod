# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Program name...: s_add_imgg.4gl
# Descriptions...: 新增imgg_file資料
# Date & Author..: 05/04/22 By Carrier  FUN-540022
# Usage..........: CALL s_add_imgg(p_item,p_ware,p_loc,p_lot,p_unit,p_fac,p_no,p_line,p_fac1)
# Input Parameter:  p_item   料件
#                   p_ware   倉庫
#                   p_loc    儲位
#                   p_lot    批號
#                   p_unit   單位
#                   p_fac    轉換率   imgg對img09的轉換率
#                   p_no     單號
#                   p_line   項次
#                   p_fac1   轉換率   imgg對ima25的轉換率
# Return Code....:  '1'  no ok
#                   '0'   ok
# Modify.........: No.FUN-550130 05/05/31 By Carrier  
# Modify.........: No.MOD-660122 06/06/30 By Rayven 當ima25與img09的單位一樣時，imgg21及imgg211所存的轉換率，也應該要一樣
# Modify.........: NO.FUN-670091 06/08/01 BY rainy cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-980012 09/08/24 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-A90049 10/10/11 By huangtao 增加料號參數的判斷 
# Modify.........: No.FUN-AB0011 10/10/05 By huangtao 修改return值
# Modify.........: No.MOD-CC0172 12/12/19 By SunLM 對於參考單位直接用傳入的轉換率參數,不再重新取值

DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_add_imgg(p_item,p_ware,p_loc,p_lot,p_unit,p_fac,p_no,p_line,p_fac1)
 
DEFINE
    p_item     LIKE imgg_file.imgg01,
    p_ware     LIKE imgg_file.imgg02,
    p_loc      LIKE imgg_file.imgg03,
    p_lot      LIKE imgg_file.imgg04,
    p_unit     LIKE imgg_file.imgg07,
    p_fac1     LIKE imgg_file.imgg21,   #No.FUN-550130
    p_fac      LIKE imgg_file.imgg211,  #No.FUN-550130
    l_ima25    LIKE ima_file.ima25,
    l_imgg21   LIKE imgg_file.imgg21,
    l_sw       LIKE type_file.chr1,   	#No.FUN-680147 VARCHAR(1)
    p_no       LIKE inb_file.inb01,  
    p_line     LIKE inb_file.inb03,   
    l_imgg     RECORD LIKE imgg_file.*,
    l_ima906   LIKE ima_file.ima906,
    l_ima907   LIKE ima_file.ima907,
    l_msg      LIKE ze_file.ze03,       #No.FUN-680147 VARCHAR(200)
    l_flag     LIKE type_file.chr1,   	#No.FUN-680147 VARCHAR(1)
    l_img09    LIKE img_file.img09,     #No.TQC-660122
    l_imgg211  LIKE imgg_file.imgg211   #No.TQC-660122

 
    WHENEVER ERROR CALL cl_err_msg_log
#FUN-A90049 -------------------start-------------------------------
    IF s_joint_venture( p_item ,g_plant) OR NOT s_internal_item( p_item,g_plant ) THEN
    #    RETURN                       #FUN-AB0011  mark
         RETURN 0                     #FUN-AB0011
    END IF 
#FUN-A90049 -------------------end---------------------------------   

    LET l_flag = 0
    SELECT ima906,ima907 INTO l_ima906,l_ima907 FROM ima_file WHERE ima01=p_item
    IF SQLCA.sqlcode OR cl_null(l_ima906) THEN
       #CALL cl_err('s_add_imgg(#chk1)',SQLCA.sqlcode,0)  #FUN-670091
       CALL cl_err3("sel","ima_file",p_item,"",SQLCA.sqlcode,"","",0) #FUN-670091
       LET l_flag = 1
       RETURN 1
    END IF
    INITIALIZE l_imgg.* TO NULL
#   IF cl_null(p_fac)  THEN LET p_fac = 1 END IF  #No.TQC-660122 mark
#   IF p_fac1 = 0 THEN  #No.TQC-660122 
    IF NOT  (l_ima906='3' AND p_unit = l_ima907) THEN  #MOD-CC0172
       SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01=p_item
       IF SQLCA.sqlcode OR cl_null(l_ima25) THEN 
          #CALL cl_err('sel ima',SQLCA.sqlcode,0)  #FUN-670091
          CALL cl_err3("sel","ima_file",p_item,"",SQLCA.sqlcode,"","",0) #FUN-670091
          RETURN 1
       END IF
       CALL s_umfchk(p_item,p_unit,l_ima25)
            RETURNING l_sw,l_imgg21
       IF l_sw  = 1 AND NOT(l_ima906='3' AND p_unit = l_ima907) THEN
          CALL cl_err('imgg09/ima25','mfg3075',0)
          RETURN 1
       END IF
       LET p_fac1 = l_imgg21
    END IF  #MOD-CC0172  
#   END IF  #No.TQC-660122 
    #No.TQC-660122 --start--
#   IF p_fac = 0 THEN  #No.TQC-660122
    IF NOT  (l_ima906='3' AND p_unit = l_ima907)  THEN #MOD-CC0172
       SELECT img09 INTO l_img09 
         FROM img_file
        WHERE img01 = p_item AND img02 = p_ware
          AND img03 = p_loc  AND img04 = p_lot
       IF SQLCA.sqlcode OR cl_null(l_img09) THEN
          #CALL cl_err('sel img',SQLCA.sqlcode,0)  #FUN-670091
          CALL cl_err3("sel","img_file",p_item,p_ware,SQLCA.sqlcode,"","",0) #FUN-670091
          RETURN 1
       END IF
       CALL s_umfchk(p_item,p_unit,l_img09)
            RETURNING l_sw,l_imgg211 
       IF l_sw = 1 AND NOT(l_ima906='3' AND p_unit = l_ima907) THEN
          CALL cl_err('imgg09/img09','mfg3075',0)
          RETURN 1
       END IF
       LET p_fac = l_imgg211
    END IF  #MOD-CC0172        
#   END IF  #No.TQC-660122
    IF cl_null(p_fac) THEN LET p_fac = 1 END IF
    #No.TQC-660122 --end--
    IF cl_null(p_fac1) THEN LET p_fac1 = 1 END IF
    IF l_ima906 = '2' THEN LET l_imgg.imgg00='1' END IF
    IF l_ima906 = '3' THEN LET l_imgg.imgg00='2' END IF
    LET l_imgg.imgg01=p_item
    LET l_imgg.imgg02=p_ware
    LET l_imgg.imgg03=p_loc
    LET l_imgg.imgg04=p_lot
    LET l_imgg.imgg05=p_no
    LET l_imgg.imgg06=p_line
    LET l_imgg.imgg09=p_unit
    LET l_imgg.imgg10=0
    LET l_imgg.imgg20=1
    LET l_imgg.imgg21=p_fac1   #No.FUN-550130
    LET l_imgg.imgg211=p_fac   #No.FUN-550130
    LET l_imgg.imggplant = g_plant #FUN-980012 add
    LET l_imgg.imgglegal = g_legal #FUN-980012 add
    INSERT INTO imgg_file VALUES(l_imgg.*)
    IF SQLCA.sqlcode THEN
       CALL cl_getmsg('asm-300',g_lang) RETURNING l_msg
       #CALL cl_err('s_add_imgg'||l_msg CLIPPED,SQLCA.sqlcode,0) #FUN-670091
       CALL cl_err3("sel","img_file",p_item,p_ware,SQLCA.sqlcode,"","",0) #FUN-670091
       LET l_flag = 1
    END IF
    RETURN l_flag
 
END FUNCTION
