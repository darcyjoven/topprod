# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Program name...: sapcp200_log.4gl
# Description....: 提供sapcp200.4gl,sapcp100.log使用的sub:传输异常纪录
# Date & Author..: No.TQC-B20181 11/03/03 wangxin 
# Modify.........: 
#                  p_transno                      ryl01  传输编号
#                  p_shop                         ryl02  门店编号
#                  p_fno                          ryl03  单据编号
#                  p_ucode                        ryl04  单据类型
#                  p_tbname                       ryl05  对应表格
#                  p_errno                        ryl06  错误代码
#                  p_errmsg                       ryl07  错误讯息
#                  p_transtype                    ryl08  传输类型
#                  p_transflg                     ryl09  传输状态
#                  p_transmemo                    ryl13  备注
# Modify.........: No:FUN-B40017 11/04/12 By wangxin 添加g_time的賦值
# Modify.........: No:FUN-B70125 11/07/29 By yangxf mark 掉l_fno
# Modify.........: No:FUN-B70075 11/10/31 By shiwuying Bug修改
# Modify.........: No:FUN-C50017 12/07/31 By shiwuying Bug修改

DATABASE ds

GLOBALS "../../config/top.global"
DEFINE g_bookno1     LIKE aza_file.aza81         
DEFINE g_bookno2     LIKE aza_file.aza82         
DEFINE g_flag        LIKE type_file.chr1          
DEFINE g_exdate      LIKE oga_file.oga021  
DEFINE p_success1    LIKE type_file.chr1    

DEFINE l_transno     LIKE ryl_file.ryl01
DEFINE l_shop        LIKE ryl_file.ryl02
DEFINE l_fno         LIKE ryl_file.ryl03
DEFINE l_ucode       LIKE ryl_file.ryl04
DEFINE l_tbname      LIKE ryl_file.ryl05
DEFINE l_errno       LIKE ryl_file.ryl06
DEFINE l_errmsg      LIKE ryl_file.ryl07
DEFINE l_transtype   LIKE ryl_file.ryl08
DEFINE l_transflg    LIKE ryl_file.ryl09
DEFINE l_transmemo   LIKE ryl_file.ryl13

FUNCTION p200_log(p_transno,p_shop,p_fno,p_ucode,p_tbname,p_errno,p_errmsg,p_transtype,p_transflg,p_transmemo)
 DEFINE p_transno     LIKE ryl_file.ryl01
 DEFINE p_shop        LIKE ryl_file.ryl02
 DEFINE p_fno         LIKE ryl_file.ryl03
 DEFINE p_ucode       LIKE ryl_file.ryl04
 DEFINE p_tbname      LIKE ryl_file.ryl05
 DEFINE p_errno       LIKE ryl_file.ryl06
 DEFINE p_errmsg      LIKE ryl_file.ryl07
 DEFINE p_transtype   LIKE ryl_file.ryl08
 DEFINE p_transflg    LIKE ryl_file.ryl09
 DEFINE p_transmemo   LIKE ryl_file.ryl13
 DEFINE l_cnt         LIKE ogb_file.ogb03
 DEFINE l_ryl RECORD LIKE ryl_file.*
 
 WHENEVER ERROR CALL cl_err_msg_log #FUN-C50017 Add
 LET g_time = TIME #FUN-B40017 add #CURRENT TIME
 
 LET l_transno   = p_transno
 LET l_shop      = p_shop
 LET l_fno       = p_fno
 LET l_ucode     = p_ucode
 LET l_tbname    = p_tbname
 LET l_errno     = p_errno
 LET l_errmsg    = p_errmsg
 LET l_transtype = p_transtype
 LET l_transflg  = p_transflg
 LET l_transmemo = p_transmemo
 
 LET l_ryl.ryl01 = l_transno    
 LET l_ryl.ryl02 = l_shop       
 LET l_ryl.ryl03 = l_fno        
 LET l_ryl.ryl04 = l_ucode      
 LET l_ryl.ryl05 = l_tbname     
 LET l_ryl.ryl06 = l_errno      
 LET l_ryl.ryl07 = l_errmsg     
 LET l_ryl.ryl08 = l_transtype  
 LET l_ryl.ryl09 = l_transflg   
 LET l_ryl.ryl13 = l_transmemo  
 LET l_ryl.ryl10 = g_today
 LET l_ryl.ryl11 = g_time
 LET l_ryl.ryl12 = g_user

#  IF cl_null(l_transno) OR cl_null(l_shop) OR cl_null(l_fno) THEN   #FUN-B70125  mark
   IF cl_null(l_transno) OR cl_null(l_shop) THEN                     #FUN-B70125
      RETURN
   END IF
   
   SELECT COUNT(*) INTO l_cnt FROM ryl_file 
    WHERE ryl01=l_transno
      AND ryl02=l_shop
      AND ryl03=l_fno
      AND ryl04=l_ucode
      AND ryl05=l_tbname
   IF cl_null(l_cnt) THEN LET l_cnt=0 END IF
   IF l_cnt>0 THEN
      UPDATE ryl_file 
         SET ryl11 = g_time
       WHERE ryl01=l_transno
         AND ryl02=l_shop
         AND ryl03=l_fno
         AND ryl04=l_ucode
         AND ryl05=l_tbname
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('upd ryl_file','upd',l_shop||'-'||l_fno,SQLCA.sqlcode,1)
      END IF   
   ELSE  #FUN-B70075 Add      
      INSERT INTO ryl_file VALUES(l_ryl.*)   
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('ins ryl_file','ins',l_shop||'-'||l_fno,SQLCA.sqlcode,1)
      END IF
   END IF

END FUNCTION

#FUNCTION p200_log_check(p_transno,p_shop,p_fno,p_ucode,p_tbname)
FUNCTION p200_log_check(p_shop,p_fno)
 #DEFINE p_transno     LIKE ryl_file.ryl01
 DEFINE p_shop        LIKE ryl_file.ryl02
 DEFINE p_fno         LIKE ryl_file.ryl03
 #DEFINE p_ucode       LIKE ryl_file.ryl04
 #DEFINE p_tbname      LIKE ryl_file.ryl05
 DEFINE l_cnt         LIKE ogb_file.ogb03
 #LET l_transno   = p_transno
 LET l_shop      = p_shop
 LET l_fno       = p_fno
 #LET l_ucode     = p_ucode
 #LET l_tbname    = p_tbname

   #IF cl_null(l_transno) OR cl_null(l_shop) OR cl_null(l_fno) THEN
   IF cl_null(l_shop) OR cl_null(l_fno) THEN
      RETURN
   END IF
   
   SELECT COUNT(*) INTO l_cnt FROM ryl_file 
   #WHERE ryl05=l_tbname
   #  AND ryl02=l_shop
    WHERE ryl02=l_shop
      AND ryl03=l_fno
   #  AND ryl04=l_ucode
   #  AND ryl01=l_transno
   IF cl_null(l_cnt) THEN LET l_cnt=0 END IF
   IF l_cnt>0 THEN
      DELETE FROM ryl_file 
      #WHERE ryl05=l_tbname
      #  AND ryl02=l_shop
       WHERE ryl02=l_shop
         AND ryl03=l_fno
      #  AND ryl04=l_ucode
      #  AND ryl01=l_transno
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('del ryl_file','del',l_shop||'-'||l_fno,SQLCA.sqlcode,1)
      END IF
   END IF

END FUNCTION
#TQC-B20181

