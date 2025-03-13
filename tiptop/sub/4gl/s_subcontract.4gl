# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Program Name...: s_subcontract.4gl
# Descriptions...: 委外处理
# Date & Author..: 10/06/03 By Carrier   #No.FUN-A60011
# Usage..........: CALL s_subcontract(p_wo,p_processno,p_route_seq)
# Input Parameter: p_wo            工单
#                : p_processno     工艺段
#                : p_route_seq     工艺序
# Return Code....: 
# Modify.........: No:FUN-A60095 10/07/07 By jan 平行工艺功能--RUNCARD可委外量计算
# Modify.........: No:FUN-A80102 10/09/17 By kim PO取消確認時,若ecm321=0,不應該回寫ecm52='N'
# Modify.........: No:FUN-A90057 10/09/23 By kim PO取消確認時,若sgm321=0,不應該回寫sgm52='N'
# Modify.........: No:TQC-AC0277 10/12/21 By jan 可委外量計算公式調整
# Modify.........: No:TQC-B20107 10/12/21 By jan 可委外量計算公式調整
# Modify.........: No:CHI-B50033 11/05/20 By kim 可委外量計算公式調整
# Modify.........: No:FUN-A70095 11/07/20 By jan 還原CHI-B50033的處理

DATABASE ds
 
GLOBALS "../../config/top.global"   #No.FUN-A60011
 
FUNCTION s_sub_available_qty(p_wo,p_processno,p_route_seq)
   DEFINE p_wo         LIKE sfb_file.sfb01
   DEFINE p_processno  LIKE ecm_file.ecm012
   DEFINE p_route_seq  LIKE ecm_file.ecm03
   DEFINE l_ecm        RECORD LIKE ecm_file.*
   DEFINE l_wip        LIKE ecm_file.ecm321
   DEFINE l_pmn20      LIKE pmn_file.pmn20 

   WHENEVER ERROR CALL cl_err_msg_log

   SELECT * INTO l_ecm.* FROM ecm_file
    WHERE ecm01 = p_wo
      AND ecm012= p_processno
      AND ecm03 = p_route_seq
   IF SQLCA.sqlcode THEN
      RETURN FALSE,0
   END IF 

   LET l_wip = 0
   IF cl_null(l_ecm.ecm291) THEN LET l_ecm.ecm291 = 0 END IF
   IF cl_null(l_ecm.ecm301) THEN LET l_ecm.ecm301 = 0 END IF
   IF cl_null(l_ecm.ecm302) THEN LET l_ecm.ecm302 = 0 END IF
   IF cl_null(l_ecm.ecm303) THEN LET l_ecm.ecm303 = 0 END IF
   IF cl_null(l_ecm.ecm311) THEN LET l_ecm.ecm311 = 0 END IF
   IF cl_null(l_ecm.ecm312) THEN LET l_ecm.ecm312 = 0 END IF
   IF cl_null(l_ecm.ecm313) THEN LET l_ecm.ecm313 = 0 END IF
   IF cl_null(l_ecm.ecm314) THEN LET l_ecm.ecm314 = 0 END IF
   IF cl_null(l_ecm.ecm316) THEN LET l_ecm.ecm316 = 0 END IF
   IF cl_null(l_ecm.ecm321) THEN LET l_ecm.ecm321 = 0 END IF
   IF cl_null(l_ecm.ecm322) THEN LET l_ecm.ecm322 = 0 END IF

   IF l_ecm.ecm54 = 'Y' THEN    #工單作check-in
      #可委外量 = check_in量ecm291-良品转出量ecm311-重工转出量ecm312-当站报废量ecm313-当站下线量ecm314-工单转出量ecm316
      LET l_wip = l_ecm.ecm291 - l_ecm.ecm311 - l_ecm.ecm312 - l_ecm.ecm313 - l_ecm.ecm314 - l_ecm.ecm316   
   ELSE
      #可委外量 = 良品转入量ecm301+重工转入量ecm302+工单转入量ecm303 -
      #          (良品转出量ecm311+重工转出量ecm312+当站报废量ecm313+当站下线量ecm314+工单转出量ecm316)
      LET l_wip = l_ecm.ecm301 + l_ecm.ecm302 + l_ecm.ecm303 - 
                 (l_ecm.ecm311 + l_ecm.ecm312 + l_ecm.ecm313 + l_ecm.ecm314 + l_ecm.ecm316)   
   END IF
   IF cl_null(l_wip) THEN LET l_wip = 0 END IF

  #未审核PO上的委外量
  #TQC-AC0277--begin--mod-------
  #SELECT SUM(pmn20) INTO l_pmn20 FROM pmn_file,pmm_file
  # WHERE pmm01 = pmn01
  #   AND pmn41 = p_wo
  #   AND pmn43 = p_route_seq
  #   AND pmn012= p_processno
  #   AND pmmacti = 'Y'
  #   AND pmm18 = 'N' 
  #IF cl_null(l_pmn20) THEN LET l_pmn20 = 0 END IF
   CALL s_subcontract_po(p_wo,p_processno,p_route_seq) RETURNING l_pmn20
  #TQC-AC0277--end--mod--------------

   #目前可委外量=总共可委外-已委外量
  #IF l_ecm.ecm65 > 0 THEN  #CHI-B50033   #FUN-A70095
  #   LET l_wip = l_ecm.ecm65 - l_ecm.ecm321 + l_ecm.ecm322 - l_pmn20  #CHI-B50033 #FUN-A70095
  #ELSE                                                                #FUN-A70095
      LET l_wip = l_wip - l_ecm.ecm321 + l_ecm.ecm322 - l_pmn20 #TQC-AC0277 add ecm322
  #END IF                   #FUN-A70095
   RETURN TRUE,l_wip
END FUNCTION

#TQC-AC0277--begin--add------
FUNCTION s_subcontract_po(p_wo,p_processno,p_route_seq)
   DEFINE p_wo         LIKE sfb_file.sfb01
   DEFINE p_processno  LIKE ecm_file.ecm012
   DEFINE p_route_seq  LIKE ecm_file.ecm03
   DEFINE l_pmn20      LIKE pmn_file.pmn20

   SELECT SUM(pmn20) INTO l_pmn20 FROM pmn_file,pmm_file
    WHERE pmm01 = pmn01
      AND pmn41 = p_wo
      AND pmn43 = p_route_seq
      AND pmn012= p_processno
      AND pmmacti = 'Y'
      AND pmm18 = 'N' 
   IF cl_null(l_pmn20) THEN LET l_pmn20 = 0 END IF 
   RETURN l_pmn20
END FUNCTION
#TQC-AC0277--end--add------

FUNCTION s_update_ecm52(p_wo,p_processno,p_route_seq)
   DEFINE p_wo         LIKE sfb_file.sfb01
   DEFINE p_processno  LIKE ecm_file.ecm012
   DEFINE p_route_seq  LIKE ecm_file.ecm03
   DEFINE l_ecm321     LIKE ecm_file.ecm321
   DEFINE l_ecm52      LIKE ecm_file.ecm52 

   WHENEVER ERROR CALL cl_err_msg_log

   SELECT ecm321,ecm52 INTO l_ecm321,l_ecm52 FROM ecm_file
    WHERE ecm01 = p_wo
      AND ecm012= p_processno
      AND ecm03 = p_route_seq
   IF SQLCA.sqlcode THEN
      RETURN FALSE
   END IF 

   IF cl_null(l_ecm321) THEN LET l_ecm321 = 0 END IF
   IF (l_ecm321 > 0) AND (l_ecm52='N') THEN  #FUN-A80102
      UPDATE ecm_file SET ecm52 = 'Y'
       WHERE ecm01 = p_wo
         AND ecm012= p_processno
         AND ecm03 = p_route_seq
   #FUN-A80102 mark (S)
   #ELSE
   #   UPDATE ecm_file SET ecm52 = 'N'
   #    WHERE ecm01 = p_wo
   #      AND ecm012= p_processno
   #      AND ecm03 = p_route_seq
   #FUN-A80102 mark (E)
   END IF
   IF SQLCA.sqlcode THEN
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION

#carrier mark
#FUNCTION s_upd_ecm321(p_ecm01,p_ecm03,p_ecm012,p_cmd,p_qty1,p_qty2)
#   DEFINE p_ecm01     LIKE ecm_file.ecm01    #工单
#   DEFINE p_ecm03     LIKE ecm_file.ecm03    #制程序号
#   DEFINE p_ecm012    LIKE ecm_file.ecm012   #制程段号
#   DEFINE p_cmd       LIKE type_file.chr1    #'a' 新增/'u' 修改/'d' 删除
#   DEFINE p_qty1      LIKE ecm_file.ecm321   #新值
#   DEFINE p_qty2      LIKE ecm_file.ecm321   #旧值
#   DEFINE l_sw        LIKE type_file.num5    #+1/-1
#   DEFINE l_ecm321    LIKE ecm_file.ecm321
#
#   IF cl_null(p_ecm01) OR cl_null(p_ecm03) OR p_ecm012 IS NULL THEN
#      RETURN
#   END IF
#
#   SELECT * FROM ecm_file
#    WHERE ecm01 = p_ecm01
#      AND ecm03 = p_ecm03
#      AND ecm012= p_ecm012
#   IF SQLCA.sqlcode THEN
#      IF g_bgerr THEN
#         LET g_showmsg = p_ecm01 CLIPPED,'/',p_ecm03 USING "<<<<<",'/',p_ecm012
#         CALL s_errmsg('ecm01,ecm03,ecm012',g_showmsg,'select ecm',SQLCA.sqlcode,1)
#      ELSE
#         CALL cl_err3('sel','ecm_file',p_ecm01,p_ecm03,SQLCA.sqlcode,'','select ecm',1)
#      END IF
#      RETURN
#   END IF
#
#   IF cl_null(p_qty1) THEN LET p_qty1 = 0 END IF
#   IF cl_null(p_qty2) THEN LET p_qty2 = 0 END IF
#
#   #数量都要为正值
#   IF p_qty1 < 0 THEN LET p_qty1 * -1 END IF
#   IF p_qty2 < 0 THEN LET p_qty2 * -1 END IF
#
#   IF p_cmd = 'a' THEN LET l_ecm321 = p_qty1 END IF
#   IF p_cmd = 'd' THEN LET l_ecm321 = p_qty1 * - 1 END IF
#   IF p_cmd = 'u' THEN LET l_ecm321 = p_qty1 - p_qty2 END IF
#
#   UPDATE ecm_file SET ecm321 = ecm321 + l_ecm321
#    WHERE ecm01 = p_ecm01
#      AND ecm03 = p_ecm03
#      AND ecm012= p_ecm012
#   IF SQLCA.sqlcode THEN
#      LET g_success = 'N'
#      IF g_bgerr THEN
#         LET g_showmsg = p_ecm01 CLIPPED,'/',p_ecm03 USING "<<<<<",'/',p_ecm012
#         CALL s_errmsg('ecm01,ecm03,ecm012',g_showmsg,'update ecm321',SQLCA.sqlcode,1)
#      ELSE
#         CALL cl_err3('upd','ecm_file',p_ecm01,p_ecm03,SQLCA.sqlcode,'','update ecm321',1)
#      END IF
#   ELSE
#      SELECT ecm321 INTO l_ecm321 FROM ecm_file
#       WHERE ecm01 = p_ecm01
#         AND ecm03 = p_ecm03
#         AND ecm012= p_ecm012
#      IF l_ecm321 < 0 THEN
#         IF g_bgerr THEN
#            LET g_showmsg = p_ecm01 CLIPPED,'/',p_ecm03 USING "<<<<<",'/',p_ecm012
#            CALL s_errmsg('ecm01,ecm03,ecm012',g_showmsg,'update ecm321','aec-316',1)
#         ELSE
#            CALL cl_err3('upd','ecm_file',p_ecm01,p_ecm03,'aec-316','','update ecm321',1)
#         END IF
#      END IF
#   END IF
#END FUNCTION

#FUN-A60095--begin--add--------------
FUNCTION s_subcontract_sgm_qty(p_wo,p_processno,p_route_seq)
   DEFINE p_wo         LIKE shm_file.shm01
   DEFINE p_processno  LIKE sgm_file.sgm012
   DEFINE p_route_seq  LIKE sgm_file.sgm03
   DEFINE l_sgm        RECORD LIKE sgm_file.*
   DEFINE l_wip        LIKE sgm_file.sgm321
   DEFINE l_pmn20      LIKE pmn_file.pmn20 

   WHENEVER ERROR CALL cl_err_msg_log

   SELECT * INTO l_sgm.* FROM sgm_file
    WHERE sgm01 = p_wo
      AND sgm012= p_processno
      AND sgm03 = p_route_seq
   IF SQLCA.sqlcode THEN
      RETURN FALSE,0
   END IF 

   LET l_wip = 0
   IF cl_null(l_sgm.sgm291) THEN LET l_sgm.sgm291 = 0 END IF
   IF cl_null(l_sgm.sgm301) THEN LET l_sgm.sgm301 = 0 END IF
   IF cl_null(l_sgm.sgm302) THEN LET l_sgm.sgm302 = 0 END IF
   IF cl_null(l_sgm.sgm303) THEN LET l_sgm.sgm303 = 0 END IF
   IF cl_null(l_sgm.sgm304) THEN LET l_sgm.sgm304 = 0 END IF
   IF cl_null(l_sgm.sgm311) THEN LET l_sgm.sgm311 = 0 END IF
   IF cl_null(l_sgm.sgm312) THEN LET l_sgm.sgm312 = 0 END IF
   IF cl_null(l_sgm.sgm313) THEN LET l_sgm.sgm313 = 0 END IF
   IF cl_null(l_sgm.sgm314) THEN LET l_sgm.sgm314 = 0 END IF
   IF cl_null(l_sgm.sgm316) THEN LET l_sgm.sgm316 = 0 END IF
   IF cl_null(l_sgm.sgm317) THEN LET l_sgm.sgm317 = 0 END IF
   IF cl_null(l_sgm.sgm321) THEN LET l_sgm.sgm321 = 0 END IF
   IF cl_null(l_sgm.sgm322) THEN LET l_sgm.sgm322 = 0 END IF

   IF l_sgm.sgm54 = 'Y' THEN    #工單作check-in
      #可委外量 = check_in量sgm291-良品转出量sgm311-重工转出量sgm312-当站报废量sgm313-当站下线量sgm314-分割转出量sgm316-合併转出量sgm317
      LET l_wip = l_sgm.sgm291 - l_sgm.sgm311 - l_sgm.sgm312 - l_sgm.sgm313 - l_sgm.sgm314 - l_sgm.sgm316 - l_sgm.sgm317   
   ELSE
      #可委外量 = 良品转入量sgm301+重工转入量sgm302+分割转入量sgm303+合并转入量sgm304 -
      #          (良品转出量sgm311+重工转出量sgm312+当站报废量sgm313+当站下线量sgm314+分割转出量sgm316+合并转出量sgm317)
      LET l_wip = l_sgm.sgm301 + l_sgm.sgm302 + l_sgm.sgm303 + l_sgm.sgm304 - 
                 (l_sgm.sgm311 + l_sgm.sgm312 + l_sgm.sgm313 + l_sgm.sgm314 + l_sgm.sgm316 + l_sgm.sgm317)   
   END IF
   IF cl_null(l_wip) THEN LET l_wip = 0 END IF

   #未审核PO上的委外量
   SELECT SUM(pmn20) INTO l_pmn20 FROM pmn_file,pmm_file
    WHERE pmm01 = pmn01
      AND pmn41 = l_sgm.sgm02
      AND pmn43 = p_route_seq
      AND pmn012= p_processno
      AND pmmacti = 'Y'
      AND pmm18 = 'N' 
   IF cl_null(l_pmn20) THEN LET l_pmn20 = 0 END IF

   #目前可委外量=总共可委外-已委外量
  #LET l_wip = l_wip - l_sgm.sgm321 - l_pmn20   #TQC-B20107
   LET l_wip = l_wip - l_sgm.sgm321 + l_sgm.sgm322 - l_pmn20 #TQC-B20107

   RETURN TRUE,l_wip
END FUNCTION

FUNCTION s_update_sgm52(p_runcard,p_processno,p_route_seq)
   DEFINE p_runcard    LIKE sgm_file.sgm01
   DEFINE p_processno  LIKE sgm_file.sgm012
   DEFINE p_route_seq  LIKE sgm_file.sgm03
   DEFINE l_sgm321     LIKE sgm_file.sgm321
   DEFINE l_sgm52      LIKE sgm_file.sgm52

   WHENEVER ERROR CALL cl_err_msg_log

   SELECT sgm321,sgm52 INTO l_sgm321,l_sgm52 FROM sgm_file
    WHERE sgm01 = p_runcard
      AND sgm012= p_processno
      AND sgm03 = p_route_seq
   IF SQLCA.sqlcode THEN
      RETURN FALSE
   END IF

   IF cl_null(l_sgm321) THEN LET l_sgm321 = 0 END IF
   IF l_sgm321 > 0 THEN
      UPDATE sgm_file SET sgm52 = 'Y'
       WHERE sgm01 = p_runcard
         AND sgm012= p_processno
         AND sgm03 = p_route_seq     
   #FUN-A90057 mark(S)      
   #ELSE
   #   UPDATE sgm_file SET sgm52 = 'N'
   #    WHERE sgm01 = p_runcard
   #      AND sgm012= p_processno
   #      AND sgm03 = p_route_seq
   #FUN-A90057 mark(E)      
   END IF
   IF SQLCA.sqlcode THEN
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION
#FUN-A60095--end--add-----------
