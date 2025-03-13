# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Pattern name...: s_ins_imgb.4gl
# Descriptions...: 新增条码庫存档
# Date & Author..: No:DEV-CA0011 2012/10/29 By TSD.JIE
# Usage..........: CALL s_up_imgb(p_imgb01,p_imgb02,p_imgb03,
#                           p_imgb04,p_qty,p_type,p_plant)
# Input Parameter: p_imgb01  条码编号
#                  p_imgb02  仓库
#                  p_imgb03  储位
#                  p_imgb04  批号             
#                  p_type    欲更新之方式
#                       +1 增加
#                       -1 减少
#                  p_qty    庫存數量(庫存單位)
#                  p_plant  异动营运中心       
# Return code....: NONE
# Modify.........: No.DEV-D30025 2013/03/12 By Nina---GP5.3 追版:以上為GP5.25 的單號---


IMPORT os  
DATABASE ds
 
GLOBALS "../../config/top.global"  
 
FUNCTION s_ins_imgb(p_imgb01,p_imgb02,p_imgb03,
                 p_imgb04,p_qty ,p_type ,p_plant ) 
DEFINE
    p_imgb01   LIKE imgb_file.imgb01,
    p_imgb02   LIKE imgb_file.imgb02,
    p_imgb03   LIKE imgb_file.imgb03,
    p_imgb04   LIKE imgb_file.imgb04,
    p_type     LIKE type_file.num5,   	
    p_qty      LIKE imgb_file.imgb05,
    p_plant    LIKE azw_file.azw01,
    l_legal    LIKE azw_file.azw02
DEFINE l_n     LIKE type_file.num5  
DEFINE l_sql   STRING
DEFINE l_imbg  RECORD LIKE imgb_file.*    

     IF cl_null(p_imgb01) 
       OR  cl_null(p_imgb02)  THEN 
        CALL cl_err('','aba-005',1)
        LET g_success = 'N'
        RETURN 
     END IF 
     
   # 默认储位  
     IF cl_null(p_imgb03) THEN 
        LET p_imgb03 = ' '
     END IF 
   # 默认批号
     IF cl_null(p_imgb04) THEN 
        LET p_imgb04 = ' '
     END IF 
     
     IF cl_null(p_plant) THEN 
        LET p_plant = g_plant
     END IF 
     
     SELECT azw02 INTO l_legal FROM azw_file
      WHERE azw01 = p_plant
     
     IF cl_null(p_qty) THEN 
        LET p_qty = 0 
     END IF 
     
     IF cl_null(p_type) THEN 
        LET p_type = 1
     END IF 
     
     LET l_n = 0
     LET l_sql = "SELECT COUNT(*) ",
                 "  FROM ",cl_get_target_table(p_plant,'imgb_file'),
                 " WHERE imgb01 = '",p_imgb01,"' ",
                 "   AND imgb02 = '",p_imgb02,"' ",
                 "   AND imgb03 = '",p_imgb03,"' ",
                 "   AND imgb04 = '",p_imgb04,"' "
     PREPARE get_imgb FROM l_sql 
     EXECUTE get_imgb INTO l_n 
     IF l_n > 0 THEN 
        LET g_success = 'N'
       #CALL cl_err(p_imgb01,'aba-006','1') #DEV-CA0011--mark
        #DEV-CA0011--add--begin
        IF g_bgerr THEN
           CALL s_errmsg('imgb01',p_imgb01,'sel imgb','aba-006',1)
        ELSE
           CALL cl_err(p_imgb01,'aba-006','1')
        END IF
        #DEV-CA0011--add--end
        RETURN 
     END IF 
     
     LET p_qty = p_qty * p_type
     
     LET l_sql = "INSERT INTO  ",
                  cl_get_target_table(p_plant,'imgb_file'),
                  " (imgb01,imgb02,imgb03, ",
                  "  imgb04,imgb05,imgbplant,imgblegal) ",
                  " VALUES (?,?,?,?,?, ?,? ) "
     PREPARE ins_imgb FROM l_sql
     EXECUTE ins_imgb USING 
       p_imgb01,p_imgb02,p_imgb03,
       p_imgb04,p_qty,p_plant,l_legal
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN 
       IF g_bgerr THEN
          CALL s_errmsg('imgb01',p_imgb01,'s_ins_imgb:upd imgb',STATUS,1)
       ELSE
           CALL cl_err3("ins","imgb_file",p_imgb01,"",STATUS,"","",1)
       END IF
       LET g_success='N'
       RETURN
     END IF 
END FUNCTION
#DEV-D30025--add

