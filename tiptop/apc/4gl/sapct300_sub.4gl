# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Program name...: aapct300_sub.4gl
# Description....: 提供apct300.4gl使用的sub routine
# Date & Author..: No.FUN-C70116 12/08/10 By suncx
# Modify.........: No.FUN-C70116 12/08/10 By suncx 新增程序
# Modify.........: No:FUN-C90102 12/10/31 By pauline 將lsn_file檔案類別改為B.基本資料,將lsnplant由lsnstore取代
#                                                    將lsm_file檔案類別改為B.基本資料,將lsmplant用lsmstore取代 
# Modify.........: No:FUN-CB0028 12/11/07 By shiwuying 储值卡付款还原的时候不写lpj07
# Modify.........: No:FUN-CB0028 12/11/08 By xumm 增加发卡\退卡\换卡\充值\发券\退券请求类型的相关逻辑
# Modify.........: No.FUN-CB0118 12/12/05 By xumm 服务状态增加4:异常（ERP处理失败）
# Modify.........: No.FUN-CC0057 12/12/26 By xumm 请求类型增加13:更新订单
# Modify.........: No.FUN-CC0135 12/12/27 By xumm 请求类型增加12:会员升等
# Modify.........: No:FUN-D10040 13/01/18 By xumm 券状态改为4:已用
# Modify.........: No.FUN-D10095 13/01/29 By xumm XML格式调整
# Modify.........: No.CHI-D20015 12/03/26 By lujh 統一確認和取消確認時確認人員和確認日期的寫法
# Modify.........: No.FUN-D40052 13/04/15 By xumm XML解析逻辑修改

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../4gl/sapct300.global"

DEFINE g_guid  STRING
#FUN-CB0028-------add-----str
DEFINE g_lpj06     LIKE lpj_file.lpj06
DEFINE g_lpj07     LIKE lpj_file.lpj07
DEFINE g_lpj08     LIKE lpj_file.lpj08
DEFINE g_lpj11     LIKE lpj_file.lpj11
DEFINE g_lpj12     LIKE lpj_file.lpj12
DEFINE g_lpj13     LIKE lpj_file.lpj13
DEFINE g_lpj14     LIKE lpj_file.lpj14
DEFINE g_lpj15     LIKE lpj_file.lpj15
#FUN-CB0028-------add-----end
#FUN-C70116 
FUNCTION t300sub_lock_cl()
   DEFINE l_forupd_sql STRING

   LET l_forupd_sql = "SELECT * FROM rxs_file WHERE rxs01 = ? FOR UPDATE"
   LET l_forupd_sql=cl_forupd_sql(l_forupd_sql)

   DECLARE t300sub_cl CURSOR FROM l_forupd_sql
END FUNCTION

#審核邏輯
#FUNCTION t300sub_y(p_rxs01)                   #FUN-CB0028 mark
FUNCTION t300sub_y(p_rxs01,p_inTransaction)    #FUN-CB0028 add
DEFINE p_rxs01 LIKE rxs_file.rxs01
DEFINE p_inTransaction  LIKE type_file.num5    #TRUE->在事務中FALSE->不在事務中    #FUN-CB0028 add
DEFINE l_rxs   RECORD LIKE rxs_file.*
DEFINE l_cnt   LIKE type_file.num5

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(p_rxs01) THEN CALL cl_err('',-400,0) RETURN END IF

   SELECT * INTO l_rxs.* FROM rxs_file WHERE rxs01 = p_rxs01

   IF l_rxs.rxsconf='X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF l_rxs.rxsconf='Y' THEN CALL cl_err('','9023',0) RETURN END IF
   IF l_rxs.rxspost='Y' THEN CALL cl_err('','arm-035',0) RETURN END IF
   IF l_rxs.rxsacti='N' THEN CALL cl_err('','mfg0301',1) RETURN END IF

   #控管單身未輸入資料
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM rxt_file
    WHERE rxt01=p_rxs01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',1)
      LET g_success = 'N'
      RETURN
   END IF
 
   IF p_inTransaction THEN #FUN-CB0028 add
      IF NOT cl_confirm('axm-108') THEN LET g_success = 'N' RETURN END IF
      BEGIN WORK
   END IF                      #FUN-CB0028 add
   IF p_inTransaction THEN #FUN-CB0028 add
      LET g_success = 'Y'
   END IF                      #FUN-CB0028 add
   CALL t300sub_lock_cl()
   OPEN t300sub_cl USING p_rxs01
   IF STATUS THEN
      CALL cl_err("OPEN t300sub_cl:", STATUS, 1)
      CLOSE t300sub_cl
      IF p_inTransaction THEN  #FUN-CB0028 add
         ROLLBACK WORK
      END IF                   #FUN-CB0028 add
      LET g_success = 'N'      #FUN-CB0028 add
      RETURN
   END IF

   FETCH t300sub_cl INTO l_rxs.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(p_rxs01,SQLCA.sqlcode,0)          #資料被他人LOCK
      IF p_inTransaction THEN  #FUN-CB0028 add
         ROLLBACK WORK
      END IF                   #FUN-CB0028 add
      LET g_success = 'N'      #FUN-CB0028 add
      RETURN
   END IF

   UPDATE rxs_file SET rxsconf='Y',
                       rxsconu=g_user,
                       rxscont=g_time,
                       rxscond=g_today,
                       rxsmodu=g_user,
                       rxsdate=g_today,
                       rxs05 = '1'
    WHERE rxs01=p_rxs01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("upd","rxs_file",p_rxs01,"","apm-266","","upd rxs_file",1)
      LET g_success='N'
   END IF

   IF p_inTransaction THEN     #FUN-CB0028 add
      IF g_success = 'Y' THEN
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF
   END IF                      #FUN-CB0028 add

END FUNCTION

#取消審核邏輯
FUNCTION t300sub_z(p_rxs01)
   DEFINE p_rxs01 LIKE rxs_file.rxs01
   DEFINE l_rxs   RECORD LIKE rxs_file.*

   IF cl_null(p_rxs01) THEN CALL cl_err('',-400,0) RETURN END IF

   SELECT * INTO l_rxs.* FROM rxs_file
    WHERE rxs01=p_rxs01

   IF l_rxs.rxsconf='X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF l_rxs.rxsconf='N' THEN CALL cl_err('','9025',0) RETURN END IF
   IF l_rxs.rxsacti='N' THEN CALL cl_err('','mfg0301',1) RETURN END IF
   IF l_rxs.rxspost='Y' THEN CALL cl_err('','arm-035',0) RETURN END IF

   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   BEGIN WORK
   CALL t300sub_lock_cl()
   OPEN t300sub_cl USING p_rxs01
   IF STATUS THEN
      CALL cl_err("OPEN t300sub_cl:", STATUS, 1)
      CLOSE t300sub_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t300sub_cl INTO l_rxs.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(p_rxs01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF

   LET g_success = 'Y'
   LET l_rxs.rxs05 = '0'

   UPDATE rxs_file SET rxsconf='N',
                       #rxsconu=NULL,          #CHI-D20015 mark 
                       rxsconu=g_user,         #CHI-D20015 add 
                       rxscont=NULL,
                       #rxscond=NULL,          #CHI-D20015 mark
                       rxscond=g_today,        #CHI-D20015 add
                       rxsmodu=g_user,
                       rxsdate=g_today,
                       rxs05 = '0'
                WHERE rxs01=p_rxs01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("upd","rxs_file",p_rxs01,"",SQLCA.sqlcode,"","upd rxs_file",1)
      LET g_success='N'
   END IF

   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF

END FUNCTION

#過賬邏輯
#FUNCTION t300sub_s(p_rxs01)                       #FUN-CB0028 mark
FUNCTION t300sub_s(p_rxs01,p_inTransaction)        #FUN-CB0028 add
    DEFINE p_rxs01 LIKE rxs_file.rxs01
    DEFINE p_inTransaction  LIKE type_file.num5    #TRUE->在事務中FALSE->不在事務中    #FUN-CB0028 add 

    WHENEVER ERROR CONTINUE
    IF cl_null(p_rxs01) THEN CALL cl_err('',-400,0) RETURN END IF

    SELECT * INTO g_rxs.* FROM rxs_file
     WHERE rxs01=p_rxs01

    IF g_rxs.rxsconf='X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_rxs.rxsconf='N' THEN CALL cl_err('','aba-100',0) RETURN END IF
    IF g_rxs.rxspost='Y' THEN CALL cl_err('','arm-035',0) RETURN END IF
    IF g_rxs.rxsacti='N' THEN CALL cl_err('','mfg0301',1) RETURN END IF
    IF p_inTransaction THEN  #FUN-CB0028 add
       IF NOT cl_confirm('mfg0176') THEN RETURN END IF
       #BEGIN WORK  #FUN-CB0028
        DROP TABLE lpj_tmp
        CREATE TEMP TABLE lpj_tmp(
            lpj03 LIKE lpj_file.lpj03,
            lpj07 LIKE lpj_file.lpj07,
            lpj15 LIKE lpj_file.lpj15)
        BEGIN WORK  #FUN-CB0028
    END IF                   #FUN-CB0028 add
    CALL t300sub_lock_cl()
    OPEN t300sub_cl USING p_rxs01
    IF STATUS THEN
        CALL cl_err("OPEN t300sub_cl:", STATUS, 1)
        CLOSE t300sub_cl
        IF p_inTransaction THEN  #FUN-CB0028 add
           ROLLBACK WORK
        END IF                   #FUN-CB0028 add
        LET g_success='N'        #FUN-CB0028 add
        RETURN
    END IF

    FETCH t300sub_cl INTO g_rxs.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(p_rxs01,SQLCA.sqlcode,0)          #資料被他人LOCK
        IF p_inTransaction THEN  #FUN-CB0028 add
           ROLLBACK WORK
        END IF                   #FUN-CB0028 add
        LET g_success='N'        #FUN-CB0028 add
        RETURN
    END IF

    IF p_inTransaction THEN  #FUN-CB0028 add
       LET g_success = "Y"
       CALL s_showmsg_init()
    END IF                   #FUN-CB0028 add
    INITIALIZE g_guid TO NULL

    CALL t300sub_s1(g_rxs.rxs01)
    CALL t300sub_s2(g_rxs.rxs01)

    IF g_success = 'Y' AND NOT cl_null(g_guid) THEN
       CALL t300sub_upd_tk_wslog(g_guid,'3')
    END IF

    IF g_success = 'Y' AND NOT cl_null(g_guid) THEN
       CALL t300sub_upd_rxu(g_guid,'3')
    END IF

    IF p_inTransaction THEN  #FUN-CB0028 add
       CALL s_showmsg()
       IF g_success = "N" THEN
           ROLLBACK WORK
           RETURN
       END IF
    END IF                   #FUN-CB0028 add

    UPDATE rxs_file
       SET rxspost='Y'
     WHERE rxs01 = g_rxs.rxs01
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
        CALL cl_err("upd rxs_file",STATUS,1)
        IF p_inTransaction THEN  #FUN-CB0028 add
        ROLLBACK WORK
        END IF                   #FUN-CB0028 add
        LET g_success = "N"      #FUN-CB0028 add
        RETURN
    END IF
    IF p_inTransaction THEN  #FUN-CB0028 add
       COMMIT WORK #FUN-CB0028
       DROP TABLE lpj_tmp
      #COMMIT WORK #FUN-CB0028
       CALL cl_err(g_rxs.rxs01,'axm-669',1)  #FUN-CB0028 add
    END IF                   #FUN-CB0028 add
END FUNCTION

#過賬邏輯 -> 異常方式：1、補錄
FUNCTION t300sub_s1(p_rxs01)
DEFINE p_rxs01 LIKE rxs_file.rxs01
DEFINE l_rxt   RECORD LIKE rxt_file.*
    DECLARE t300sub_s1_cs CURSOR FOR
     SELECT * FROM rxt_file
      WHERE rxt01 = p_rxs01 AND rxt16 = '1'

    FOREACH t300sub_s1_cs INTO l_rxt.*
        IF STATUS THEN
            CALL s_errmsg("foreach:",'','',STATUS,1)
            LET g_success = "N"
            EXIT FOREACH
        END IF
        CASE l_rxt.rxt08
            WHEN '2'
                CALL t300sub_ins_lsm(l_rxt.rxt09,l_rxt.rxt05,l_rxt.rxt06,l_rxt.rxt12,
                                     l_rxt.rxt14,l_rxt.rxt13,l_rxt.rxt03,l_rxt.rxt08,'1')
                CALL t300sub_upd_lpj(l_rxt.rxt14,l_rxt.rxt12,l_rxt.rxt13,l_rxt.rxt12,
                                     l_rxt.rxt03,l_rxt.rxt09,l_rxt.rxt05,l_rxt.rxt08,'1')
        END CASE
        IF cl_null(g_guid) THEN
            LET g_guid = "'",l_rxt.rxt07,"'"
        ELSE
            LET g_guid = g_guid,",'",l_rxt.rxt07,"'"
        END IF
    END FOREACH
END FUNCTION

#過賬邏輯 -> 異常方式：1、還原
FUNCTION t300sub_s2(p_rxs01)
DEFINE p_rxs01 LIKE rxs_file.rxs01
DEFINE l_rxt   RECORD LIKE rxt_file.*
DEFINE l_sql   STRING
DEFINE l_shop  LIKE azp_file.azp01
DEFINE l_lpj06     LIKE lpj_file.lpj06  #FUN-CB0028 add
DEFINE l_lpj03     LIKE lpj_file.lpj03  #FUN-CB0028 add
DEFINE l_shop1     LIKE azp_file.azp01  #FUN-CC0057 add
DEFINE l_isupgrade LIKE type_file.chr1  #FUN-CC0135 add
DEFINE l_lpj01     LIKE lpj_file.lpj01  #FUN-CC0135 add

    DECLARE t300sub_s2_cs CURSOR FOR
     SELECT * FROM rxt_file
      WHERE rxt01 = p_rxs01 AND rxt16 = '2'
    FOREACH t300sub_s2_cs INTO l_rxt.*
        IF STATUS THEN
            CALL s_errmsg("foreach:",'','',STATUS,1)
            LET g_success = "N"
            EXIT FOREACH
        END IF
        CALL t300sub_set_posdbs()     #FUN-CC0057 add
        CASE l_rxt.rxt08
            WHEN '1'
                LET l_sql = " UPDATE ",cl_get_target_table(l_rxt.rxt03,"ryi_file"),
                            "    SET ryi03 = '",l_rxt.rxt10,"',",
                            "        ryipos = '2' ",
                            "  WHERE ryi01 = '",l_rxt.rxt09,"'"
                CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                PREPARE upd_password_pre FROM l_sql
                EXECUTE upd_password_pre
                IF sqlca.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN
                    LET g_success = 'N'
                    LET g_showmsg = l_rxt.rxt09
                    CALL s_errmsg('ryi01',g_showmsg,'',SQLCA.sqlcode,1)
                END IF
            WHEN '2'
                CALL t300sub_ins_lsm(l_rxt.rxt09,l_rxt.rxt05,l_rxt.rxt06,l_rxt.rxt12,
                                     l_rxt.rxt14,l_rxt.rxt13,l_rxt.rxt03,l_rxt.rxt08,'2')
                CALL t300sub_upd_lpj(l_rxt.rxt14,l_rxt.rxt12,l_rxt.rxt13,l_rxt.rxt12,
                                     l_rxt.rxt03,l_rxt.rxt09,l_rxt.rxt05,l_rxt.rxt08,'2')
            WHEN '3'
                CALL t300sub_ins_lsm(l_rxt.rxt09,l_rxt.rxt05,l_rxt.rxt06,l_rxt.rxt12,
                                     l_rxt.rxt14,l_rxt.rxt13,l_rxt.rxt03,l_rxt.rxt08,'2')
                CALL t300sub_upd_lpj(l_rxt.rxt14,l_rxt.rxt12,l_rxt.rxt13,l_rxt.rxt12,
                                     l_rxt.rxt03,l_rxt.rxt09,l_rxt.rxt05,l_rxt.rxt08,'2')
            WHEN '4'
                CALL t300sub_ins_lsn(l_rxt.rxt09,l_rxt.rxt05,l_rxt.rxt06,l_rxt.rxt12,
                                     l_rxt.rxt14,l_rxt.rxt03,'2')
                CALL t300sub_upd_lpj(l_rxt.rxt14,l_rxt.rxt12,l_rxt.rxt13,l_rxt.rxt12,
                                     l_rxt.rxt03,l_rxt.rxt09,l_rxt.rxt05,l_rxt.rxt08,'2')
            WHEN '5'
                LET l_sql = " UPDATE ",cl_get_target_table(l_rxt.rxt03,"lqe_file"),
                            "  SET lqe17 = '",l_rxt.rxt10,"',"
                IF l_rxt.rxt10 = '4' THEN
                    LET l_sql = l_sql CLIPPED,
                                " lqe24 = '",l_rxt.rxt03,"',",  #FUN-D10040 add
                                " lqe25 = '",l_rxt.rxt14,"'"    #FUN-D10040 add
                               #" lqe18 = '",l_rxt.rxt03,"',",  #FUN-D10040 mark
                               #" lqe19 = '",l_rxt.rxt14,"'"    #FUN-D10040 mark
                ELSE
                    LET l_sql = l_sql CLIPPED,
                                " lqe24 = NULL,",               #FUN-D10040 add
                                " lqe25 = NULL"                 #FUN-D10040 add
                               #" lqe18 = NULL,",               #FUN-D10040 mark
                               #" lqe19 = NULL"                 #FUN-D10040 mark
                END IF
                LET l_sql = l_sql CLIPPED,
                            " WHERE lqe17 = '",l_rxt.rxt11,"' ",
                            "   AND lqe01 = '",l_rxt.rxt09,"'"
                CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                PREPARE upd_amt_pre1 FROM l_sql
                EXECUTE upd_amt_pre1
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN
                    LET g_success = 'N'
                    LET g_showmsg = l_rxt.rxt09
                    CALL s_errmsg('lqe01',g_showmsg,'',SQLCA.sqlcode,1)
                END IF
           #FUN-CB0028---------add-----str
           WHEN '6'
                DECLARE t300sub_sel_lpj03_cs CURSOR FOR
                SELECT lpj03 FROM lpj_file
                 WHERE lpj03 BETWEEN l_rxt.rxt10 AND l_rxt.rxt11
                FOREACH t300sub_sel_lpj03_cs INTO l_lpj03
                   CALL t300sub_ins_lsn(l_lpj03,l_rxt.rxt05,l_rxt.rxt06,l_rxt.rxt12,
                                        l_rxt.rxt14,l_rxt.rxt03,'2')
                   CALL t300sub_upd_lpj(l_rxt.rxt14,l_rxt.rxt12,l_rxt.rxt13,l_rxt.rxt12,
                                        l_rxt.rxt03,l_lpj03,l_rxt.rxt05,l_rxt.rxt08,'2')
                   IF g_success = 'N' THEN
                      EXIT FOREACH
                   END IF
                END FOREACH
           WHEN '7'
                CALL t300sub_ins_lsn(l_rxt.rxt09,l_rxt.rxt05,l_rxt.rxt06,l_rxt.rxt12,
                                     l_rxt.rxt14,l_rxt.rxt03,'2')
                CALL t300sub_upd_lpj(l_rxt.rxt14,l_rxt.rxt12,l_rxt.rxt13,l_rxt.rxt12,
                                     l_rxt.rxt03,l_rxt.rxt09,l_rxt.rxt05,l_rxt.rxt08,'2')
           WHEN '8'
                CALL t300sub_ins_lsn(l_rxt.rxt11,l_rxt.rxt05,l_rxt.rxt06,l_rxt.rxt12,
                                     l_rxt.rxt14,l_rxt.rxt03,'2')
                CALL t300sub_ins_lsm(l_rxt.rxt11,l_rxt.rxt05,l_rxt.rxt06,l_rxt.rxt12,
                                     l_rxt.rxt14,l_rxt.rxt13,l_rxt.rxt03,l_rxt.rxt08,'2')
                CALL t300sub_upd_lpj(l_rxt.rxt14,l_rxt.rxt12,l_rxt.rxt13,l_rxt.rxt12,
                                     l_rxt.rxt03,l_rxt.rxt11,l_rxt.rxt05,'81','2')
                CALL t300sub_upd_lpj(l_rxt.rxt14,l_rxt.rxt12,l_rxt.rxt13,l_rxt.rxt12,
                                     l_rxt.rxt03,l_rxt.rxt10,l_rxt.rxt05,'82','2')
           WHEN '9'
                LET l_lpj06 = l_rxt.rxt11-l_rxt.rxt10
                CALL t300sub_ins_lsn(l_rxt.rxt09,l_rxt.rxt05,l_rxt.rxt06,l_rxt.rxt12,
                                     l_rxt.rxt14,l_rxt.rxt03,'2')
                CALL t300sub_upd_lpj(l_rxt.rxt14,l_rxt.rxt12,l_rxt.rxt13,l_lpj06,
                                     l_rxt.rxt03,l_rxt.rxt09,l_rxt.rxt05,l_rxt.rxt08,'2')
           WHEN '10'
                LET l_sql = " UPDATE ",cl_get_target_table(l_rxt.rxt03,"lqe_file"),
                            "    SET lqe17 = '2',",
                            "        lqe06 = '',",
                            "        lqe07 = ''",
                            "  WHERE lqe01 BETWEEN '",l_rxt.rxt10,"' AND '",l_rxt.rxt11,"'"
                CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                PREPARE upd_lqe_pre FROM l_sql
                EXECUTE upd_lqe_pre
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN
                    LET g_success = 'N'
                    LET g_showmsg = l_rxt.rxt10,'~',l_rxt.rxt11
                    CALL s_errmsg('lqe01',g_showmsg,'',SQLCA.sqlcode,1)
                END IF
           WHEN '11'
                LET l_sql = " UPDATE ",cl_get_target_table(l_rxt.rxt03,"lqe_file"),
                            "    SET lqe17 = '1',",
                            "        lqe09 = '',",
                            "        lqe10 = ''",
                            "  WHERE lqe01 = '",l_rxt.rxt09,"'"
                CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                PREPARE upd_lqe_pre1 FROM l_sql
                EXECUTE upd_lqe_pre1
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN
                    LET g_success = 'N'
                    LET g_showmsg = l_rxt.rxt09
                    CALL s_errmsg('lqe01',g_showmsg,'',SQLCA.sqlcode,1)
                END IF
           #FUN-CB0028---------add-----end
           #FUN-CC0135---------add-----str
           WHEN '12'
                CALL t300sub_XmlData('MemberUpgrade','','IsUpgrade',l_rxt.rxt07) RETURNING l_isupgrade
                IF g_success = 'N' THEN   CONTINUE FOREACH  END IF    #FUN-D40052 Add
                LET l_isupgrade = sapcq300_xml_getDetailRecordField(g_request_root,"IsUpgrade")
                LET l_sql = " SELECT lpj01 FROM ",cl_get_target_table(l_rxt.rxt03,"lpj_file"),
                            "  WHERE lpj03 = '",l_rxt.rxt09,"'"
                CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                PREPARE sel_lpj_pre FROM l_sql
                EXECUTE sel_lpj_pre INTO l_lpj01 
                IF SQLCA.sqlcode  THEN
                    LET g_success = 'N'
                    LET g_showmsg = l_lpj01
                    CALL s_errmsg('lpj01',g_showmsg,'',SQLCA.sqlcode,1)
                END IF
                IF l_isupgrade = '1' THEN
                  LET l_sql = " UPDATE ",cl_get_target_table(l_rxt.rxt03,"lpk_file"),
                              "    SET lpk21 = 'Y'",
                              "  WHERE lpk01 = '",l_lpj01,"'"
                ELSE
                  LET l_sql = " UPDATE ",cl_get_target_table(l_rxt.rxt03,"lpk_file"),
                              "    SET lpk10 = '",l_rxt.rxt10,"'",",",
                              "        lpkmodu = '",g_user,"'",",",
                              "        lpkdate = '",g_today,"'",
                              "  WHERE lpk01 = '",l_lpj01,"'"
                END IF
                CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                PREPARE upd_lpk_pre FROM l_sql
                EXECUTE upd_lpk_pre
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN
                    LET g_success = 'N'
                    LET g_showmsg = l_lpj01
                    CALL s_errmsg('lpk01',g_showmsg,'',SQLCA.sqlcode,1)
                END IF
                IF l_isupgrade = '0' THEN
                   LET l_sql = " DELETE  FROM ",cl_get_target_table(l_rxt.rxt03,"lqr_file"),
                               "  WHERE  lqr01 = '",l_rxt.rxt18,"'"
                   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                   PREPARE del_lqr_pre FROM l_sql
                   EXECUTE del_lqr_pre 
                   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN
                      LET g_success = 'N'
                      LET g_showmsg = l_rxt.rxt18 
                      CALL s_errmsg('lqr01',g_showmsg,'',SQLCA.sqlcode,1)
                   END IF
                   LET l_sql = " DELETE  FROM ",cl_get_target_table(l_rxt.rxt03,"lqt_file"),
                               "  WHERE  lqt01 = '",l_rxt.rxt18,"'"
                   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                   PREPARE del_lqt_pre FROM l_sql
                   EXECUTE del_lqt_pre
                   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN
                      LET g_success = 'N'
                      LET g_showmsg = l_rxt.rxt18
                      CALL s_errmsg('lqt01',g_showmsg,'',SQLCA.sqlcode,1)
                   END IF
                END IF
           #FUN-CC0135---------add-----end
           #FUN-CC0057---------add-----str
           WHEN '13'
                CALL t300sub_XmlData('DeductSPayment','UpdateOrderBill','Shop',l_rxt.rxt07) RETURNING l_shop1
                IF g_success = 'N' THEN   CONTINUE FOREACH  END IF    #FUN-D40052 Add
                LET l_sql = " UPDATE ",g_posdbs,"td_Sale",g_db_links,
                            "    SET ECSFLG = 'N'",
                            "  WHERE SaleNO = '",l_rxt.rxt09,"'",
                            "    AND SHOP = '",l_shop1,"'",
                            "    AND TYPE = '3'"
                PREPARE upd_td_sale_cs FROM l_sql
                EXECUTE upd_td_sale_cs
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN
                   LET g_success = 'N'
                   LET g_showmsg = l_rxt.rxt09 
                   CALL s_errmsg('td_Sale',g_showmsg,'',SQLCA.sqlcode,1)
                END IF
           #FUN-CC0057---------add-----end
        END CASE
        IF cl_null(g_guid) THEN
            LET g_guid = "'",l_rxt.rxt07,"'"
        ELSE
            LET g_guid = g_guid,",'",l_rxt.rxt07,"'"
        END IF
    END FOREACH

    #根據門店更新lpj_file
    DECLARE t300sub_shop_cs1 CURSOR FOR
     SELECT DISTINCT rxt03 FROM rxt_file
      WHERE rxt01 = p_rxs01 AND rxt16 = '2'
        AND rxt08 IN ('2','3','4')
    FOREACH t300sub_shop_cs1 INTO l_shop
       DELETE FROM lpj_tmp
       INSERT INTO lpj_tmp
       SELECT rxt09,COUNT(DISTINCT rxt06),0 FROM rxt_file
        WHERE rxt08 IN ('2','3','4') AND rxt16='2' 
          AND rxt01 = p_rxs01 AND rxt03 = l_shop
        GROUP BY rxt09 
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN
           LET g_success = 'N'
           CALL s_errmsg('',"INSERT INTO lpj_tmp",'',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF

       UPDATE lpj_tmp SET lpj15 = (SELECT SUM(-1*rxt12) FROM rxt_file
                                    WHERE rxt16='2' AND rxt08='4' AND rxt03 = l_shop
                                      AND rxt01 = p_rxs01 AND lpj03 = rxt09
                                    GROUP BY rxt09)
                         ,lpj07 = 0  #FUN-CB0028 #储值卡付款不算累计消费积分次数
        WHERE lpj03 IN (SELECT rxt09 FROM rxt_file WHERE rxt16='2' AND rxt08='4'
                                      AND rxt01 = p_rxs01 AND rxt03 = l_shop)
       IF SQLCA.sqlcode THEN
           LET g_success = 'N'
           CALL s_errmsg('',"UPDATE lpj_tmp1",'',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       UPDATE lpj_tmp SET lpj15 = (SELECT SUM(rxt13) FROM rxt_file
                                    WHERE rxt16='2' AND rxt08='2' AND rxt03 = l_shop
                                      AND rxt01 = p_rxs01 AND lpj03 = rxt09
                                    GROUP BY rxt09)
        WHERE lpj03 IN (SELECT rxt09 FROM rxt_file WHERE rxt16='2' AND rxt08='2'
                                      AND rxt01 = p_rxs01 AND rxt03 = l_shop)
       IF SQLCA.sqlcode THEN
           LET g_success = 'N'
           CALL s_errmsg('',"UPDATE lpj_tmp2",'',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       LET l_sql="UPDATE ",cl_get_target_table(l_shop,"lpj_file")," a ",
                 "   SET a.lpj07 = a.lpj07-(SELECT b.lpj07 FROM lpj_tmp b WHERE b.lpj03 = a.lpj03),",
                 "       a.lpj15 = a.lpj15-(SELECT c.lpj15 FROM lpj_tmp c WHERE c.lpj03 = a.lpj03)",
                 " WHERE a.lpj03 IN (SELECT lpj03 FROM lpj_tmp)"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
       PREPARE upd_lpj_pre1 FROM l_sql
       EXECUTE upd_lpj_pre1
       IF sqlca.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN
           LET g_success = 'N'
           LET g_showmsg = p_rxs01
           CALL s_errmsg('upd lpj_file',g_showmsg,'',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
    END FOREACH 
END FUNCTION

FUNCTION t300sub_w()
DEFINE l_rxt   RECORD LIKE rxt_file.*
DEFINE l_sql   STRING
DEFINE l_shop  LIKE azp_file.azp01
DEFINE l_lpj06    LIKE lpj_file.lpj06   #FUN-CB0028 add
DEFINE l_lpj03_2  LIKE lpj_file.lpj03   #FUN-CB0028 add
DEFINE l_shop1    LIKE azp_file.azp01   #FUN-CC0057 add
DEFINE l_isupgrade LIKE type_file.chr1  #FUN-CC0135 add
DEFINE l_lpj01     LIKE lpj_file.lpj01  #FUN-CC0135 add

    IF s_shut(0) THEN LET g_success='N' RETURN END IF
    IF cl_null(g_rxs.rxs01) THEN CALL cl_err('',-400,0) LET g_success='N' RETURN END IF
    SELECT * INTO g_rxs.* FROM rxs_file WHERE rxs01 = g_rxs.rxs01
    IF g_rxs.rxspost='N' THEN CALL cl_err('','mfg0178',1) RETURN END IF
    IF g_rxs.rxsconf='X' THEN CALL cl_err('','9024',1) LET g_success='N' RETURN END IF
    IF NOT cl_confirm('asf-663') THEN RETURN END IF
   #BEGIN WORK  #FUN-CB0028
    DROP TABLE lpj_tmp
    CREATE TEMP TABLE lpj_tmp(
        lpj03 LIKE lpj_file.lpj03,
        lpj07 LIKE lpj_file.lpj07,
        lpj15 LIKE lpj_file.lpj15)
    CALL t300sub_lock_cl()
    BEGIN WORK  #FUN-CB0028
    OPEN t300sub_cl USING g_rxs.rxs01
    IF STATUS THEN
        CALL cl_err("OPEN t300sub_cl:", STATUS, 1)
        CLOSE t300sub_cl
        ROLLBACK WORK
        RETURN
    END IF

    FETCH t300sub_cl INTO g_rxs.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rxs.rxs01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF

    LET g_success = "Y"
    CALL s_showmsg_init()
    INITIALIZE g_guid TO NULL
    INITIALIZE l_rxt.* TO NULL
    DECLARE t300sub_w1_cs CURSOR FOR
     SELECT * FROM rxt_file
      WHERE rxt01 = g_rxs.rxs01

    FOREACH t300sub_w1_cs INTO l_rxt.*
        IF STATUS THEN
            CALL s_errmsg("foreach:",'','',STATUS,1)
            LET g_success = "N"
            EXIT FOREACH
        END IF
        CALL t300sub_set_posdbs()     #FUN-CC0057 add
        CASE l_rxt.rxt08
            WHEN '1'
                LET l_sql = " UPDATE ",cl_get_target_table(l_rxt.rxt03,"ryi_file"),
                            "    SET ryi03 = '",l_rxt.rxt11,"',",
                            "        ryipos = '2' ",
                            "  WHERE ryi01 = '",l_rxt.rxt09,"'"
                CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                PREPARE upd_password_pre2 FROM l_sql
                EXECUTE upd_password_pre2
                IF sqlca.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN
                    LET g_success = 'N'
                    LET g_showmsg = l_rxt.rxt09
                    CALL s_errmsg('ryi01',g_showmsg,'',SQLCA.sqlcode,1)
                END IF
            WHEN '2'
                CALL t300sub_del_lsm(l_rxt.rxt09,l_rxt.rxt05,l_rxt.rxt06,l_rxt.rxt14,
                                     l_rxt.rxt03,l_rxt.rxt08)
                CALL t300sub_w_upd_lpj(l_rxt.rxt14,l_rxt.rxt12,l_rxt.rxt13,l_rxt.rxt12,
                                       l_rxt.rxt03,l_rxt.rxt09,l_rxt.rxt05,l_rxt.rxt08,
                                       l_rxt.rxt16)
            WHEN '3'
                CALL t300sub_del_lsm(l_rxt.rxt09,l_rxt.rxt05,l_rxt.rxt06,l_rxt.rxt14,
                                     l_rxt.rxt03,l_rxt.rxt08)
                CALL t300sub_w_upd_lpj(l_rxt.rxt14,l_rxt.rxt12,l_rxt.rxt13,l_rxt.rxt12,
                                       l_rxt.rxt03,l_rxt.rxt09,l_rxt.rxt05,l_rxt.rxt08,
                                       l_rxt.rxt16)
            WHEN '4'
                CALL t300sub_del_lsn(l_rxt.rxt09,l_rxt.rxt05,l_rxt.rxt06,l_rxt.rxt03)
                CALL t300sub_w_upd_lpj(l_rxt.rxt14,l_rxt.rxt12,l_rxt.rxt13,l_rxt.rxt12,
                                       l_rxt.rxt03,l_rxt.rxt09,l_rxt.rxt05,l_rxt.rxt08,
                                       l_rxt.rxt16)
            WHEN '5'
                LET l_sql = " UPDATE ",cl_get_target_table(l_rxt.rxt03,"lqe_file"),
                            "  SET lqe17 = '",l_rxt.rxt11,"',"
                IF l_rxt.rxt11 = '4' THEN
                    LET l_sql = l_sql CLIPPED,
                                " lqe24 = '",l_rxt.rxt03,"',",  #FUN-D10040 add
                                " lqe25 = '",l_rxt.rxt14,"'"    #FUN-D10040 add
                               #" lqe18 = '",l_rxt.rxt03,"',",  #FUN-D10040 mark
                               #" lqe19 = '",l_rxt.rxt14,"'"    #FUN-D10040 mark
                ELSE
                    LET l_sql = l_sql CLIPPED,
                                " lqe24 = NULL,",               #FUN-D10040 add
                                " lqe25 = NULL"                 #FUN-D10040 add
                               #" lqe18 = NULL,",               #FUN-D10040 mark
                               #" lqe19 = NULL"                 #FUN-D10040 mark
                END IF
                LET l_sql = l_sql CLIPPED,
                            " WHERE lqe17 = '",l_rxt.rxt10,"' ",
                            "   AND lqe01 = '",l_rxt.rxt09,"'"
                CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                PREPARE upd_lqe_pre2 FROM l_sql
                EXECUTE upd_lqe_pre2
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN
                    LET g_success = 'N'
                    LET g_showmsg = l_rxt.rxt09
                    CALL s_errmsg('lqe01',g_showmsg,'',SQLCA.sqlcode,1)
                END IF
           #FUN-CB0028---------add-----str
           WHEN '6'
                DECLARE t300sub_sel_lpj03_2_cs CURSOR FOR
                SELECT lpj03 FROM lpj_file
                 WHERE lpj03 BETWEEN l_rxt.rxt10 AND l_rxt.rxt11
                FOREACH t300sub_sel_lpj03_2_cs INTO l_lpj03_2
                   CALL t300sub_del_lsn(l_lpj03_2,l_rxt.rxt05,l_rxt.rxt06,l_rxt.rxt03)
                   CALL t300sub_w_upd_lpj(l_rxt.rxt14,l_rxt.rxt12,l_rxt.rxt13,l_rxt.rxt12,
                                          l_rxt.rxt03,l_lpj03_2,l_rxt.rxt05,l_rxt.rxt08,
                                          l_rxt.rxt16)
                   IF g_success = 'N' THEN
                      EXIT FOREACH
                   END IF
                END FOREACH
           WHEN '7'
                CALL t300sub_del_lsn(l_rxt.rxt09,l_rxt.rxt05,l_rxt.rxt06,l_rxt.rxt03)
                CALL t300sub_w_upd_lpj(l_rxt.rxt14,l_rxt.rxt12,l_rxt.rxt13,l_rxt.rxt12,
                                       l_rxt.rxt03,l_rxt.rxt09,l_rxt.rxt05,l_rxt.rxt08,
                                       l_rxt.rxt16) 
           WHEN '8'
                CALL t300sub_del_lsm(l_rxt.rxt11,l_rxt.rxt05,l_rxt.rxt06,l_rxt.rxt14,
                                     l_rxt.rxt03,l_rxt.rxt08)
                CALL t300sub_del_lsn(l_rxt.rxt11,l_rxt.rxt05,l_rxt.rxt06,l_rxt.rxt03)
                CALL st300_sel_lpj(l_rxt.rxt03,l_rxt.rxt10) 
                CALL t300sub_w_upd_lpj(l_rxt.rxt14,l_rxt.rxt12,l_rxt.rxt13,l_rxt.rxt12,
                                       l_rxt.rxt03,l_rxt.rxt11,l_rxt.rxt05,'81',
                                       l_rxt.rxt16)
                CALL t300sub_w_upd_lpj(l_rxt.rxt14,l_rxt.rxt12,l_rxt.rxt13,l_rxt.rxt12,
                                       l_rxt.rxt03,l_rxt.rxt10,l_rxt.rxt05,'82',
                                       l_rxt.rxt16)
           WHEN '9'
                LET l_lpj06 = l_rxt.rxt11-l_rxt.rxt10
                CALL t300sub_del_lsn(l_rxt.rxt09,l_rxt.rxt05,l_rxt.rxt06,l_rxt.rxt03)
                CALL t300sub_w_upd_lpj(l_rxt.rxt14,l_rxt.rxt12,l_rxt.rxt13,l_lpj06,
                                       l_rxt.rxt03,l_rxt.rxt09,l_rxt.rxt05,l_rxt.rxt08,
                                       l_rxt.rxt16)
           WHEN '10'
                LET l_sql = " UPDATE ",cl_get_target_table(l_rxt.rxt03,"lqe_file"),
                            "    SET lqe17 = '1',",
                            "        lqe06 = '",l_rxt.rxt03,"',",
                            "        lqe07 = '",l_rxt.rxt14,"'",
                            "  WHERE lqe01 BETWEEN '",l_rxt.rxt10,"' AND '",l_rxt.rxt11,"'"
                CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                PREPARE upd_lqe_pre3 FROM l_sql
                EXECUTE upd_lqe_pre3
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN
                    LET g_success = 'N'
                    LET g_showmsg = l_rxt.rxt10,'~',l_rxt.rxt11
                    CALL s_errmsg('lqe01',g_showmsg,'',SQLCA.sqlcode,1)
                END IF
           WHEN '11'
                LET l_sql = " UPDATE ",cl_get_target_table(l_rxt.rxt03,"lqe_file"),
                            "    SET lqe17 = '2',",
                            "        lqe09 = '",l_rxt.rxt03,"',",
                            "        lqe10 = '",l_rxt.rxt14,"'",
                            "  WHERE lqe01 = '",l_rxt.rxt09,"'" 
                CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                PREPARE upd_lqe_pre4 FROM l_sql
                EXECUTE upd_lqe_pre4
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN
                    LET g_success = 'N'
                    LET g_showmsg = l_rxt.rxt09
                    CALL s_errmsg('lqe01',g_showmsg,'',SQLCA.sqlcode,1)
                END IF
           #FUN-CB0028---------add-----end 
           #FUN-CC0135---------add-----str
           WHEN '12'
                CALL t300sub_XmlData('MemberUpgrade','','IsUpgrade',l_rxt.rxt07) RETURNING l_isupgrade
                IF g_success = 'N' THEN   CONTINUE FOREACH  END IF    #FUN-D40052 Add
                LET l_sql = " SELECT lpj01 FROM ",cl_get_target_table(l_rxt.rxt03,"lpj_file"),
                            "  WHERE lpj03 = '",l_rxt.rxt09,"'"
                CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                PREPARE sel_lpj_pre1 FROM l_sql
                EXECUTE sel_lpj_pre1 INTO l_lpj01
                IF SQLCA.sqlcode THEN
                    LET g_success = 'N'
                    LET g_showmsg = l_lpj01
                    CALL s_errmsg('lpj01',g_showmsg,'',SQLCA.sqlcode,1)
                END IF
                IF l_isupgrade = '0' THEN
                   CALL t300sub_ins_lqr(l_lpj01,l_rxt.rxt03,l_rxt.rxt11,l_rxt.rxt07)
                END IF
                IF l_isupgrade = '1' THEN 
                  LET l_sql = " UPDATE ",cl_get_target_table(l_rxt.rxt03,"lpk_file"),
                              "    SET lpk21 = 'N'",
                              "  WHERE lpk01 = '",l_lpj01,"'"
                ELSE          
                  LET l_sql = " UPDATE ",cl_get_target_table(l_rxt.rxt03,"lpk_file"),
                              "    SET lpk10 = '",l_rxt.rxt11,"'",",",
                              "        lpkmodu = NULL ",",",
                              "        lpkdate = NULL ",
                              "  WHERE lpk01 = '",l_lpj01,"'"
                END IF
                CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                PREPARE upd_lpk_pre1 FROM l_sql
                EXECUTE upd_lpk_pre1
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN
                    LET g_success = 'N'
                    LET g_showmsg = l_lpj01
                    CALL s_errmsg('lpk01',g_showmsg,'',SQLCA.sqlcode,1)
                END IF
           #FUN-CC0135---------add-----end
           #FUN-CC0057---------add-----str
           WHEN '13'
                CALL t300sub_XmlData('DeductSPayment','UpdateOrderBill','Shop',l_rxt.rxt07) RETURNING l_shop1
                IF g_success = 'N' THEN   CONTINUE FOREACH  END IF    #FUN-D40052 Add
                LET l_sql = " UPDATE ",g_posdbs,"td_Sale",g_db_links,
                            "    SET ECSFLG = 'Y'",
                            "  WHERE SaleNO = '",l_rxt.rxt09,"'",
                            "    AND SHOP = '",l_shop1,"'",
                            "    AND TYPE = '3'"
                PREPARE upd_td_sale1_cs FROM l_sql
                EXECUTE upd_td_sale1_cs
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN
                   LET g_success = 'N'
                   LET g_showmsg = l_rxt.rxt09 
                   CALL s_errmsg('td_Sale',g_showmsg,'',SQLCA.sqlcode,1)
                END IF
           #FUN-CC0057---------add-----end
        END CASE
        IF cl_null(g_guid) THEN
            LET g_guid = "'",l_rxt.rxt07,"'"
        ELSE
            LET g_guid = g_guid,",'",l_rxt.rxt07,"'"
        END IF
        INITIALIZE l_rxt.* TO NULL
    END FOREACH

    IF g_success = 'Y' AND NOT cl_null(g_guid) THEN
       CALL t300sub_upd_tk_wslog(g_guid,'4')
    END IF

    IF g_success = 'Y' AND NOT cl_null(g_guid) THEN
       CALL t300sub_upd_rxu(g_guid,'4')
    END IF

    #根據門店更新lpj_file
    DECLARE t300sub_shop_cs2 CURSOR FOR
     SELECT DISTINCT rxt03 FROM rxt_file
      WHERE rxt01 = g_rxs.rxs01 AND rxt16 = '2'
        AND rxt08 IN ('2','3','4')
    FOREACH t300sub_shop_cs2 INTO l_shop
       DELETE FROM lpj_tmp
       INSERT INTO lpj_tmp
       SELECT rxt09,COUNT(DISTINCT rxt06),0 FROM rxt_file
        WHERE rxt08 IN ('2','3','4') AND rxt16='2' 
          AND rxt01 = g_rxs.rxs01 AND rxt03 = l_shop
        GROUP BY rxt09 
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN
           LET g_success = 'N'
           CALL s_errmsg('',"INSERT INTO lpj_tmp",'',SQLCA.sqlcode,1)
           RETURN
       END IF

       UPDATE lpj_tmp SET lpj15 = (SELECT SUM(-1*rxt12) FROM rxt_file
                                    WHERE rxt16='2' AND rxt08='4' AND rxt03 = l_shop
                                      AND rxt01 = g_rxs.rxs01 AND lpj03 = rxt09
                                    GROUP BY rxt09)
                         ,lpj07 = 0  #FUN-CB0028 #储值卡付款不算累计消费积分次数
        WHERE lpj03 IN (SELECT rxt09 FROM rxt_file WHERE rxt16='2' AND rxt08='4'
                                      AND rxt01 = g_rxs.rxs01 AND rxt03 = l_shop)
       IF SQLCA.sqlcode THEN
           LET g_success = 'N'
           CALL s_errmsg('',"UPDATE lpj_tmp1",'',SQLCA.sqlcode,1)
           RETURN
       END IF
       UPDATE lpj_tmp SET lpj15 = (SELECT SUM(rxt13) FROM rxt_file
                                    WHERE rxt16='2' AND rxt08='2' AND rxt03 = l_shop
                                      AND rxt01 = g_rxs.rxs01 AND lpj03 = rxt09
                                    GROUP BY rxt09)
        WHERE lpj03 IN (SELECT rxt09 FROM rxt_file WHERE rxt16='2' AND rxt08='2'
                                      AND rxt01 = g_rxs.rxs01 AND rxt03 = l_shop)
       IF SQLCA.sqlcode THEN
           LET g_success = 'N'
           CALL s_errmsg('',"UPDATE lpj_tmp2",'',SQLCA.sqlcode,1)
           RETURN
       END IF
       LET l_sql="UPDATE ",cl_get_target_table(l_shop,"lpj_file")," a ",
                 "   SET a.lpj07 = a.lpj07+(SELECT b.lpj07 FROM lpj_tmp b WHERE b.lpj03 = a.lpj03),",
                 "       a.lpj15 = a.lpj15+(SELECT c.lpj15 FROM lpj_tmp c WHERE c.lpj03 = a.lpj03)",
                 " WHERE a.lpj03 IN (SELECT lpj03 FROM lpj_tmp)"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
       PREPARE upd_lpj_pre2 FROM l_sql
       EXECUTE upd_lpj_pre2
       IF sqlca.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN
           LET g_success = 'N'
           LET g_showmsg = g_rxs.rxs01
           CALL s_errmsg('upd lpj_file',g_showmsg,'',SQLCA.sqlcode,1)
       END IF
    END FOREACH 

    CALL s_showmsg()
    IF g_success = "N" THEN
        ROLLBACK WORK
        RETURN
    END IF

    UPDATE rxs_file
       SET rxspost='N'
     WHERE rxs01 = g_rxs.rxs01
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
        CALL cl_err("upd rxs_file",STATUS,1)
        ROLLBACK WORK
        RETURN
    END IF
    COMMIT WORK #FUN-CB0028
    DROP TABLE lpj_tmp
   #COMMIT WORK #FUN-CB0028
    CALL cl_err(g_rxs.rxs01,'mfg1605',1)   #FUN-CB0028 add
END FUNCTION

FUNCTION t300sub_del_lsm(p_lsm01,p_lsm02,p_lsm03,p_lsm05,p_lsmplant,p_rxt08)
DEFINE p_lsm01    LIKE lsm_file.lsm01,
       #p_lsm02    LIKE lsm_file.lsm02,  #FUN-CB0028 mark
       p_lsm02    LIKE rxt_file.rxt05,   #FUN-CB0028 add
       p_lsm03    LIKE lsm_file.lsm03,
       p_lsm05    LIKE lsm_file.lsm05,
       p_lsmplant LIKE lsm_file.lsmplant,
       p_rxt08    LIKE rxt_file.rxt08
DEFINE l_sql      STRING
    IF p_rxt08 = '2' THEN
        CASE
            WHEN p_lsm02 MATCHES '[03]'
                IF p_lsm02 = '0' THEN LET p_lsm02 = '7' END IF   #銷售單積分
                IF p_lsm02 = '3' THEN LET p_lsm02 = 'X' END IF   #訂單積分 目前先給X
            WHEN p_lsm02 MATCHES '[124]'
                IF p_lsm02 MATCHES '[12]' THEN LET p_lsm02 = '8' END IF   #銷退單積分
                IF p_lsm02 = '4' THEN LET p_lsm02 = 'Y' END IF        #退訂單積分 目前先給Y
        END CASE
    END IF
    IF p_rxt08 = '3' THEN
        CASE
            WHEN p_lsm02 MATCHES '[03]'
                IF p_lsm02 = '0' THEN LET p_lsm02 = '9' END IF   #銷售單積分
                IF p_lsm02 = '3' THEN LET p_lsm02 = 'B' END IF   #訂單積分 目前先給X
            WHEN p_lsm02 MATCHES '[124]'
                IF p_lsm02 MATCHES '[12]' THEN LET p_lsm02 = 'A' END IF   #銷退單積分
                IF p_lsm02 = '4' THEN LET p_lsm02 = 'C' END IF        #退訂單積分 目前先給Y
        END CASE
    END IF
    #FUN-CB0028-------add----str
    IF p_rxt08 = '8' THEN
       IF p_lsm02 = '16' THEN LET p_lsm02 = '4' END IF
    END IF
    #FUN-CB0028-------add----end
   #LET l_sql = "DELETE FROM ",cl_get_target_table(p_lsmplant,"lsm_file"),   #FUN-C90102 mark 
    LET l_sql = "DELETE FROM lsm_file ",   #FUN-C90102 add 
                " WHERE lsm01='",p_lsm01,"' AND lsm02='",p_lsm02,"'",
                "   AND lsm03='",p_lsm03,"' AND lsm05='",p_lsm05,"'",
                "   AND lsm15='3'",
                "   AND lsmstore = '",p_lsmplant CLIPPED,"' "  #FUN-C90102 add 
   #CALL cl_replace_sqldb(l_sql) RETURNING l_sql  #FUN-C90102 mark 
    PREPARE del_lsm_prep FROM l_sql
    EXECUTE del_lsm_prep
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN
        LET g_success = 'N'
        LET g_showmsg = p_lsmplant,"/",p_lsm02,"/",p_lsm03,"/",p_lsm01
        CALL s_errmsg('rxt03,rxt05,rxt06,rxt09',g_showmsg,'lsm_file',SQLCA.sqlcode,1)
        RETURN
    END IF
END FUNCTION

FUNCTION t300sub_del_lsn(p_lsn01,p_lsn02,p_lsn03,p_lsnplant)
DEFINE p_lsn01     LIKE lsn_file.lsn01,
       p_lsn02     LIKE lsn_file.lsn02,
       p_lsn03     LIKE lsn_file.lsn03,
       p_lsnplant  LIKE lsn_file.lsnplant
DEFINE l_sql  STRING
    CASE
         WHEN p_lsn02 MATCHES '[03]'   #扣減餘額
             IF p_lsn02 = '0' THEN LET p_lsn02 = '7' END IF   #銷售單
             IF p_lsn02 = '3' THEN LET p_lsn02 = '6' END IF   #訂單
         WHEN p_lsn02 MATCHES '[124]'   #增加餘額
             IF p_lsn02 MATCHES '[12]' THEN LET p_lsn02 = '8' END IF   #銷退單
             IF p_lsn02 = '4' THEN LET p_lsn02 = '9' END IF            #預收退回
         #FUN-CB0028--------add------str
         WHEN p_lsn02 = '5'
            LET p_lsn02 = '3'
         WHEN p_lsn02 = '7'
            LET p_lsn02 = '1'
         WHEN p_lsn02 = '8'
            LET p_lsn02 = '4'
         WHEN p_lsn02 = '16'
            LET p_lsn02 = '5'
         #FUN-CB0028--------add------end
    END CASE
   #LET l_sql = "DELETE FROM ",cl_get_target_table(p_lsnplant,"lsn_file"),   #FUN-C90102 mark 
    LET l_sql = "DELETE FROM lsn_file ",                                     #FUN-C90102 add
                " WHERE lsn01='",p_lsn01,"' AND lsn02='",p_lsn02,"' ",
                "   AND lsn03='",p_lsn03,"' AND lsn10='3'",
                "   AND lsnstore = '",p_lsnplant CLIPPED,"' "  #FUN-C90102 add
   #CALL cl_replace_sqldb(l_sql) RETURNING l_sql   #FUN-C90102 mark 
    PREPARE del_lsn_prep FROM l_sql
    EXECUTE del_lsn_prep
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN
        LET g_success = 'N'
        LET g_showmsg = p_lsn01,"/",p_lsn02,"/",p_lsn03,"/",p_lsnplant
        CALL s_errmsg('lsn01,lsn02,lsn03,lsnplant',g_showmsg,'',SQLCA.sqlcode,1)
        RETURN
    END IF
END FUNCTION

FUNCTION t300sub_w_upd_lpj(p_lpj08,p_lpj12,p_lpj15,p_lpj06,p_shop,p_lpj03,p_rxt05,p_rxt08,p_rxt16)
DEFINE p_lpj08  LIKE lpj_file.lpj08,
       p_lpj12  LIKE lpj_file.lpj12,
       p_lpj15  LIKE lpj_file.lpj15,
       p_lpj06  LIKE lpj_file.lpj06,
       p_shop   LIKE azp_file.azp01,
       p_lpj03  LIKE lpj_file.lpj03,
       p_rxt05  LIKE rxt_file.rxt05,
       p_rxt08  LIKE rxt_file.rxt08,
       p_rxt16  LIKE rxt_file.rxt16
DEFINE l_sql    STRING
    IF cl_null(p_lpj15) THEN LET p_lpj15  = 0 END IF   #FUN-CB0028 add
    LET l_sql = "UPDATE ",cl_get_target_table(p_shop,"lpj_file")
    IF p_rxt16 = '1' THEN
        IF p_rxt08 = '2' THEN
            LET l_sql = l_sql CLIPPED,
                        " SET lpj07 = lpj07 - 1 ,",
                        "     lpj12 = lpj12 - ",p_lpj12,",",
                        "     lpj14 = lpj14 - ",p_lpj12,",",
                        "     lpj15 = lpj15 - ",p_lpj15
        END IF
    ELSE
        IF p_rxt08 = '2' THEN
            LET l_sql = l_sql CLIPPED,
                        " SET lpj12 = lpj12 + ",p_lpj12,",",
                        "     lpj14 = lpj14 + ",p_lpj12
        END IF
        IF p_rxt08 = '3' THEN
            LET l_sql = l_sql CLIPPED,
                        " SET lpj12 = lpj12 + ",p_lpj12,",",
                        "     lpj13 = lpj13 - ",p_lpj12
        END IF
        IF p_rxt08 = '4' THEN
            LET l_sql = l_sql CLIPPED,
                        " SET lpj06 = lpj06 + ",p_lpj06
        END IF
        #FUN-CB0028--------add-------str
        IF p_rxt08 = '6' THEN
           LET l_sql = l_sql CLIPPED,
                       " SET lpj09 = '2',",
                       "     lpj01 = '",p_lpj03,"',",
                       "     lpj04 = '",p_lpj08,"',",
                       "     lpj17 = '",p_shop,"' "
        END IF
        IF p_rxt08 = '7' THEN
           LET l_sql = l_sql CLIPPED,
                       " SET lpj09 = '4',",
                       "     lpj06 = lpj06 - ",p_lpj06,",",
                       "     lpj21 = '",p_lpj08,"',", 
                       "     lpj22 = '",p_shop,"' "
        END IF
        IF p_rxt08 = '81' THEN
           LET l_sql = l_sql CLIPPED,
                       " SET lpj09 = '2',",
                       "     lpj04 = '",p_lpj08,"',",
                       "     lpj17 = '",p_shop,"',",
                       "     lpj06 = ",g_lpj06,",",
                       "     lpj07 = ",g_lpj07,",",
                       "     lpj08 = '",p_lpj08,"',",
                       "     lpj11 = ",g_lpj11,",",
                       "     lpj12 = ",g_lpj12,",",
                       "     lpj13 = ",g_lpj13,",",
                       "     lpj14 = ",g_lpj14,",",
                       "     lpj15 = ",g_lpj15
        END IF
        IF p_rxt08 = '82' THEN
           LET l_sql = l_sql CLIPPED,
                       " SET lpj09 = '4',",
                       "     lpj21 = '",p_lpj08,"',",
                       "     lpj22 = '",p_shop,"' "
        END IF
        IF p_rxt08 = '9' THEN
           LET l_sql = l_sql CLIPPED,
                       " SET lpj06 = lpj06 + ",p_lpj06
        END IF
        #FUN-CB0028--------add-------end
    END IF
    LET l_sql = l_sql CLIPPED," WHERE lpj03 = '",p_lpj03,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
    PREPARE upd_lpj_prep1 FROM  l_sql
    EXECUTE upd_lpj_prep1
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN
        LET g_success = 'N'
        LET g_showmsg = p_shop,"/",p_lpj03
        CALL s_errmsg('rxt03,rxt09',g_showmsg,'',SQLCA.sqlcode,1)
        RETURN
    END IF
END FUNCTION

#更新rxu_file資料狀態
FUNCTION t300sub_upd_rxu(p_guid,p_type)
DEFINE p_guid      STRING
DEFINE p_type      LIKE type_file.chr1   #1:新增 Y->N   2:刪除 N->Y   3:處理完成 N->X
DEFINE l_sql       STRING
DEFINE l_rxuacti_o LIKE rxu_file.rxuacti,
       l_rxuacti_n LIKE rxu_file.rxuacti
    IF cl_null(p_guid) THEN RETURN END IF
    CASE p_type
        WHEN '1'
            LET l_rxuacti_o = 'Y'
            LET l_rxuacti_n = 'N'
        WHEN '2'
            LET l_rxuacti_o = 'N'
            LET l_rxuacti_n = 'Y'
        WHEN '3'
            LET l_rxuacti_o = 'N'
            LET l_rxuacti_n = 'X'
        WHEN '4'
            LET l_rxuacti_o = 'X'
            LET l_rxuacti_n = 'N'
    END CASE
    LET l_sql = "UPDATE rxu_file ",
                "   SET rxuacti = '",l_rxuacti_n,"'",
                " WHERE rxuacti = '",l_rxuacti_o,"' AND rxu01 IN (",p_guid,")"
    PREPARE upd_rxu_pre FROM l_sql
    EXECUTE upd_rxu_pre
    IF SQLCA.sqlcode THEN
        CALL cl_err3("upd","rxu_file",'',"",SQLCA.sqlcode,"","upd rxu_file",1)
        LET g_success = 'N'
    END IF
END FUNCTION

#更新tk_wslog資料狀態
FUNCTION t300sub_upd_tk_wslog(p_guid,p_type)
DEFINE p_guid   STRING
DEFINE p_type   LIKE type_file.chr1  #1:新增 A->B   2:刪除 B->A   3:處理完成 B->Y
DEFINE l_sql    STRING
DEFINE l_guid   STRING
DEFINE l_buf    base.StringBuffer
DEFINE l_cond_o LIKE type_file.chr1,
       l_cond_n LIKE type_file.chr1
    IF cl_null(p_guid) THEN RETURN END IF
    CASE p_type
        WHEN '1'
            LET l_cond_o = 'A'
            LET l_cond_n = 'B'
        WHEN '2'
            LET l_cond_o = 'B'
            LET l_cond_n = 'A'
        WHEN '3'
            LET l_cond_o = 'B'
            LET l_cond_n = 'Y'
        WHEN '4'
            LET l_cond_o = 'Y'
            LET l_cond_n = 'B'
    END CASE
    CALL t300sub_set_posdbs()
    CALL cl_replace_str(p_guid,"-","") RETURNING l_guid
    LET l_buf = base.StringBuffer.create()
    CALL l_buf.append(l_guid)
    CALL l_buf.toUpperCase()
    LET l_guid = l_buf.toString()
    LET l_sql = "UPDATE ",g_posdbs,"tk_wslog",g_db_links,
                "   SET condition2 = '",l_cond_n,"'",
                #" WHERE servicestate IN('2','3')",       #FUN-CB0118 mark
               #" WHERE servicestate IN('2','3','4')",    #FUN-CB0118 add                 #FUN-CC0135 Mark
               #"   AND condition2 = '",l_cond_o,"' AND UPPER(trans_id) IN (",l_guid,")"  #FUN-CC0135 Mark
                " WHERE condition2 = '",l_cond_o,"' AND UPPER(trans_id) IN (",l_guid,")"  #FUN-CC0135 Add
    PREPARE upd_tk_wslog_pre FROM l_sql
    EXECUTE upd_tk_wslog_pre
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]<=0 THEN
        CALL cl_err3("upd","tk_wslog",'',"",SQLCA.sqlcode,"","UPDATE tk_wslog",1)
        LET g_success = 'N'
    END IF
END FUNCTION

FUNCTION t300sub_set_posdbs()
DEFINE l_posdbs       LIKE ryg_file.ryg00,
       l_db_links     LIKE ryg_file.ryg02
    SELECT DISTINCT ryg00,ryg02 INTO l_posdbs,l_db_links FROM ryg_file
    LET g_posdbs = s_dbstring(l_posdbs)
    IF l_db_links IS NULL OR l_db_links = ' ' THEN
       LET l_db_links = ' '
    ELSE
       LET l_db_links = '@',l_db_links CLIPPED
    END IF
    LET g_db_links = l_db_links
END FUNCTION

FUNCTION t300sub_b_g()
DEFINE l_wc   STRING
DEFINE l_sql  STRING
DEFINE l_lineno LIKE rxt_file.rxt02
DEFINE l_rxt   RECORD LIKE rxt_file.*
DEFINE l_request_xml  VARCHAR(4000),
       l_service_name LIKE type_file.chr20

    IF cl_null(g_rxs.rxs01) THEN CALL cl_err('',-400,0) RETURN END IF

    OPEN WINDOW t300c_w WITH FORM "apc/42f/apct300c"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_locale("apct300c")
    CONSTRUCT l_wc ON shop,machine,rdate
        FROM shop,mach,rdate
        BEFORE CONSTRUCT
          CALL cl_qbe_init()

        ON ACTION controlp
            CASE
                WHEN INFIELD(shop)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state  = "c"
                    LET g_qryparam.form   = "q_azw01_2"
                    LET g_qryparam.arg1   = g_plant
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO shop
                    NEXT FIELD shop
                OTHERWISE
                    EXIT CASE
            END CASE

        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT

        ON ACTION about
            CALL cl_about()

        ON ACTION HELP
            CALL cl_show_help()

        ON ACTION controlg
            CALL cl_cmdask()

        ON ACTION qbe_select
            CALL cl_qbe_select()

        ON ACTION qbe_save
            CALL cl_qbe_save()

    END CONSTRUCT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLOSE WINDOW t300c_w
       RETURN
    END IF
    CLOSE WINDOW t300c_w
    CALL t300sub_set_posdbs()
    CALL t300sub_get_plant()
    LET l_sql = "SELECT DISTINCT '',0,shop,machine,'','','',",
                "       '','','','',0,0,CAST(rdate AS DATE), ",
                "       rtime[1,2]||':'||rtime[3,4]||':'||rtime[5,6],'1',servicestate,",
                "       '','','',requestxml,methodname",                                    #FUN-CC0135 add ''
                "  FROM ",g_posdbs,"tk_wslog",g_db_links,
                #" WHERE ",l_wc CLIPPED," AND servicestate IN('2','3')",                    #FUN-CB0118 mark
               #" WHERE ",l_wc CLIPPED," AND servicestate IN('2','3','4')",                 #FUN-CB0118 add  #FUN-CC0135 Mark
                " WHERE ",l_wc CLIPPED,                                                                      #FUN-CC0135 Add
                "   AND condition2 = 'A' AND cnfflg = 'Y'",
                "   AND methodname = 'WritePoint' AND UPPER(trans_id) NOT IN ",
                "  (SELECT DISTINCT UPPER(replace(rxu01,'-','')) FROM rxu_file",
                "    WHERE rxuacti = 'Y' AND rxu05 = 'WritePoint')"
    IF NOT cl_null(g_wc_plant) THEN
        LET l_sql = l_sql CLIPPED," AND shop IN (",g_wc_plant,")"
    END IF
    LET l_sql = l_sql CLIPPED," UNION ALL ",
                "SELECT DISTINCT '',0,shop,machine,rxu14,rxu04,rxu01,",
                "       rxu06,rxu07,rxu08,rxu09,rxu10,rxu15,CAST(rdate AS DATE), ",
                "       rtime[1,2]||':'||rtime[3,4]||':'||rtime[5,6],'2',servicestate,",
                "       '','',rxu16,requestxml,methodname",                                 #FUN-CC0135 add rxu16
                "  FROM ",g_posdbs,"tk_wslog",g_db_links,",rxu_file ",
                #" WHERE ",l_wc CLIPPED," AND servicestate IN('2','3')",                    #FUN-CB0118 mark
               #" WHERE ",l_wc CLIPPED," AND servicestate IN('2','3','4')",                 #FUN-CB0118 add #FUN-CC0135 Mark
                " WHERE ",l_wc CLIPPED,                                                                     #FUN-CC0135 Add
                "   AND condition2 = 'A' AND cnfflg = 'Y'",
                "   AND UPPER(replace(rxu01,'-','')) = UPPER(trans_id)",
                "   AND rxuacti = 'Y' AND methodname <> 'WritePoint'"
    IF NOT cl_null(g_wc_plant) THEN
        LET l_sql = l_sql CLIPPED," AND shop IN (",g_wc_plant,")"
    END IF
    LET l_sql = l_sql CLIPPED," ORDER BY 3,6,7 "
    PREPARE t300_pb1 FROM l_sql
    DECLARE tk_wslog_curs1 CURSOR WITH HOLD FOR t300_pb1
    BEGIN WORK
    LET l_lineno = 0
    INITIALIZE g_guid TO NULL
    INITIALIZE l_rxt.* TO NULL
    LET g_success = 'Y'
    FOREACH tk_wslog_curs1 INTO l_rxt.*,l_request_xml,l_service_name   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF

        LET g_request_root = NULL
        IF l_rxt.rxt16 = '1' THEN
           #FUN-D40052-----mark&add---str
           #SELECT wap02 INTO g_wap02 FROM wap_file
           #IF g_wap02 = 'Y' THEN
           #   LET l_request_xml = cl_coding_de(l_request_xml)
           #END IF
            LET l_request_xml = cl_get_plaintext(l_request_xml)
            IF l_request_xml="-1" THEN
               CALL cl_err('','Decode error',1)
               CONTINUE FOREACH
            END IF
           #FUN-D40052-----mark&add---end
            LET l_request_xml = sapcq300_xml_process(l_request_xml)
            LET g_request_root = sapcq300_xml_stringToXml(l_request_xml)
            IF g_request_root IS NOT NULL THEN    #根XML節點不可為空
                CALL t300sub_ins_rxt_XmlData(l_service_name,l_rxt.*)
                IF g_success = 'N' THEN
                   EXIT FOREACH
                END IF
            ELSE
                LET g_success = 'N'
                EXIT FOREACH
            END IF
        ELSE
            LET l_rxt.rxt01 = g_rxs.rxs01
            SELECT MAX(rxt02) INTO l_lineno FROM rxt_file
             WHERE rxt01 = g_rxs.rxs01
            IF cl_null(l_lineno) THEN
               LET l_lineno = 1
            ELSE
               LET l_lineno = l_lineno+1
            END IF
            LET l_rxt.rxt02 = l_lineno
            LET l_rxt.rxtplant = g_plant
            LET l_rxt.rxtlegal = g_legal
            INSERT INTO rxt_file VALUES (l_rxt.*)
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL cl_err3("ins","rxt_file",l_rxt.rxt01,l_rxt.rxt02,SQLCA.sqlcode,"","",1)
               LET g_success = 'N'
               EXIT FOREACH
            END IF
        END IF
        IF cl_null(g_guid) THEN
            LET g_guid = "'",l_rxt.rxt07,"'"
        ELSE
            LET g_guid =g_guid,",'",l_rxt.rxt07,"'"
        END IF
        INITIALIZE l_rxt.* TO NULL
    END FOREACH
    IF g_success = 'Y' AND NOT cl_null(g_guid) THEN
       CALL t300sub_upd_tk_wslog(g_guid,'1')
    END IF
    IF g_success = 'Y' AND NOT cl_null(g_guid) THEN
       CALL t300sub_upd_rxu(g_guid,'1')
    END IF
    IF g_success = 'Y' THEN
        COMMIT WORK
    ELSE
        ROLLBACK WORK
    END IF

END FUNCTION

FUNCTION t300sub_ins_rxt_XmlData(p_server_name,p_rxt)
DEFINE p_server_name  STRING
DEFINE p_rxt   RECORD LIKE rxt_file.*
DEFINE l_len1         INTEGER,    #XML單頭筆數
       l_len2         INTEGER     #XML單身筆數
DEFINE l_node1        om.DomNode,
       l_node2        om.DomNode
DEFINE l_paytype      STRING      #請求類型
DEFINE l_type         LIKE rxu_file.rxu14,
       l_saleno       LIKE rxu_file.rxu04
DEFINE l_n            INTEGER,
       l_m            INTEGER
DEFINE l_guid         LIKE rxu_file.rxu01
DEFINE l_cnt          LIKE type_file.num10
DEFINE l_lineno LIKE rxt_file.rxt02
DEFINE l_rxt    RECORD LIKE rxt_file.*
DEFINE l_node         om.DomNode  #FUN-D10095 Add

    LET l_guid = sapcq300_xml_get_ConnectionMsg(g_request_root,"guid")
    CASE p_server_name
        WHEN "DeductSPayment"
           #FUN-D10095 Mark&Add STR-------
           #LET l_len1 = sapcq300_xml_getMasterRecordLength(g_request_root,"PAY")
           #FOR l_n = 1 TO l_len1
           #    LET l_node1 = sapcq300_xml_getMasterRecord(g_request_root,l_n,"PAY")
           #    LET l_type = sapcq300_xml_getRecordField(l_node1, "Type")
           #    LET l_saleno = sapcq300_xml_getRecordField(l_node1, "SaleNO")
           #    LET l_len2 = sapcq300_xml_getDetailRecordLength(l_node1)
           #    FOR l_m = 1 TO l_len2
           #        LET l_rxt.* = p_rxt.*
           #        LET l_node2 = sapcq300_xml_getDetail(l_node1, l_m)
            LET l_len1 = sapcq300_xml_getTreeMasterRecordLength(g_request_root,"Pay")
            FOR l_n = 1 TO l_len1
                LET l_node1 = sapcq300_xml_getTreeMasterRecord(g_request_root,l_n,"Pay")
                LET l_type = sapcq300_xml_getRecordField(l_node1, "Type")
                LET l_saleno = sapcq300_xml_getRecordField(l_node1, "SaleNO")
                LET l_len2 = sapcq300_xml_getTreeRecordLength(l_node1,"Pay")
                FOR l_m = 1 TO l_len2
                    LET l_node2 = sapcq300_xml_getTreeRecord(l_node1, l_m ,"Pay")
           #FUN-D10095 Mark&Add END------- 
                    LET l_paytype = l_node2.getAttribute("name")
                    LET l_rxt.rxt05 = l_type
                    LET l_rxt.rxt06 = l_saleno
                    LET l_rxt.rxt07 = l_guid
                    IF cl_null(g_guid) THEN
                        LET g_guid = "'",l_rxt.rxt07,"'"
                    ELSE
                        LET g_guid =g_guid,",'",l_rxt.rxt07,"'"
                    END IF
                    CASE
                        WHEN(l_paytype = "Card")
                            LET l_rxt.rxt08 = '4'
                            LET l_rxt.rxt09 = sapcq300_xml_getDetailRecordField(l_node2,"CardNO")
                            LET l_rxt.rxt12 = sapcq300_xml_getDetailRecordField(l_node2,"DeductAmount")
                            IF l_rxt.rxt05 MATCHES '[03]' THEN LET l_rxt.rxt12 = -1*l_rxt.rxt12 END IF
                        WHEN(l_paytype = "Coupon")
                            LET l_rxt.rxt08 = '5'
                            LET l_rxt.rxt09 = sapcq300_xml_getDetailRecordField(l_node2,"CouponNO")
                        WHEN(l_paytype = "Score")
                            LET l_rxt.rxt08 = '3'
                            LET l_rxt.rxt09 = sapcq300_xml_getDetailRecordField(l_node2,"CardNO")
                        WHEN(l_paytype = "WritePoint")
                            LET l_rxt.rxt08 = '2'
                            LET l_rxt.rxt09 = sapcq300_xml_getDetailRecordField(l_node2,"CardNO")
                            LET l_rxt.rxt12 = sapcq300_xml_getDetailRecordField(l_node2, "POINT_QTY")
                            IF l_rxt.rxt05 MATCHES '[124]' THEN LET l_rxt.rxt12 = -1*l_rxt.rxt12 END IF
                            LET l_rxt.rxt13 = sapcq300_xml_getDetailRecordField(l_node2, "TOT_AMT")
                            IF l_rxt.rxt05 MATCHES '[124]' THEN LET l_rxt.rxt13 = -1*l_rxt.rxt13 END IF
                    END CASE
                    LET l_rxt.rxt01 = g_rxs.rxs01
                    SELECT MAX(rxt02) INTO l_lineno FROM rxt_file
                     WHERE rxt01 = g_rxs.rxs01
                    IF cl_null(l_lineno) THEN
                        LET l_lineno = 1
                    ELSE
                        LET l_lineno = l_lineno+1
                    END IF
                    LET l_rxt.rxt02 = l_lineno
                    LET l_rxt.rxtplant = g_plant
                    LET l_rxt.rxtlegal = g_legal
                    INSERT INTO rxt_file VALUES (l_rxt.*)
                    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                        CALL cl_err3("ins","rxt_file",l_rxt.rxt01,l_rxt.rxt02,SQLCA.sqlcode,"","",1)
                        LET g_success = 'N'
                        RETURN
                    END IF
                END FOR
            END FOR
        WHEN "WritePoint"
            LET l_rxt.* = p_rxt.*
            LET l_rxt.rxt08 = '2'
           #FUN-D10095 Mark&Add STR-------
           #LET l_rxt.rxt09 = sapcq300_xml_getParameter(g_request_root,"CardNO")
           #LET l_rxt.rxt05 = sapcq300_xml_getParameter(g_request_root,"Type")
           #LET l_rxt.rxt13 = sapcq300_xml_getParameter(g_request_root,"TOT_AMT")
           #LET l_rxt.rxt06 = sapcq300_xml_getParameter(g_request_root,"SaleNO")
           #LET l_rxt.rxt12 = sapcq300_xml_getParameter(g_request_root,"POINT_QTY")
            LET l_node = sapcq300_xml_getTreeMasterRecord(g_request_root,1,"WritePoint")
            LET l_rxt.rxt09 = sapcq300_xml_getDetailRecordField(l_node,"CardNO")
            LET l_rxt.rxt05 = sapcq300_xml_getDetailRecordField(l_node,"Type")
            LET l_rxt.rxt13 = sapcq300_xml_getDetailRecordField(l_node,"TOT_AMT")
            LET l_rxt.rxt06 = sapcq300_xml_getDetailRecordField(l_node,"SaleNO")
            LET l_rxt.rxt12 = sapcq300_xml_getDetailRecordField(l_node,"POINT_QTY")
           #FUN-D10095 Mark&Add END-------
            LET l_rxt.rxt07 = l_guid
            IF cl_null(g_guid) THEN
                LET g_guid = "'",l_rxt.rxt07,"'"
            ELSE
                LET g_guid =g_guid,",'",l_rxt.rxt07,"'"
            END IF
            LET l_rxt.rxt01 = g_rxs.rxs01
            SELECT MAX(rxt02) INTO l_lineno FROM rxt_file
             WHERE rxt01 = g_rxs.rxs01
            IF cl_null(l_lineno) THEN
               LET l_lineno = 1
            ELSE
               LET l_lineno = l_lineno+1
            END IF
            LET l_rxt.rxt02 = l_lineno
            LET l_rxt.rxtplant = g_plant
            LET l_rxt.rxtlegal = g_legal
            INSERT INTO rxt_file VALUES (l_rxt.*)
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL cl_err3("ins","rxt_file",l_rxt.rxt01,l_rxt.rxt02,SQLCA.sqlcode,"","",1)
               LET g_success = 'N'
               RETURN
            END IF
        WHEN "ModPassWord"
            LET l_rxt.* = p_rxt.*
            LET l_rxt.rxt08 = '1'
           #FUN-D10095 Mark&Add STR-------
           #LET l_rxt.rxt09 = sapcq300_xml_getParameter(g_request_root,"OPNO")
           #LET l_rxt.rxt11 = sapcq300_xml_getParameter(g_request_root,"npsw")
            LET l_node = sapcq300_xml_getTreeMasterRecord(g_request_root,1,"ModPassWord")
            LET l_rxt.rxt09 = sapcq300_xml_getDetailRecordField(l_node,"OPNO")
            LET l_rxt.rxt11 = sapcq300_xml_getDetailRecordField(l_node,"npsw")
           #FUN-D10095 Mark&Add END-------
            LET l_rxt.rxt07 = l_guid
            IF cl_null(g_guid) THEN
                LET g_guid = "'",l_rxt.rxt07,"'"
            ELSE
                LET g_guid =g_guid,",'",l_rxt.rxt07,"'"
            END IF
            LET l_rxt.rxt01 = g_rxs.rxs01
            SELECT MAX(rxt02) INTO l_lineno FROM rxt_file
             WHERE rxt01 = g_rxs.rxs01
            IF cl_null(l_lineno) THEN
               LET l_lineno = 1
            ELSE
               LET l_lineno = l_lineno+1
            END IF
            LET l_rxt.rxt02 = l_lineno
            LET l_rxt.rxtplant = g_plant
            LET l_rxt.rxtlegal = g_legal
            INSERT INTO rxt_file VALUES (l_rxt.*)
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL cl_err3("ins","rxt_file",l_rxt.rxt01,l_rxt.rxt02,SQLCA.sqlcode,"","",1)
               LET g_success = 'N'
               RETURN
            END IF
    END CASE
END FUNCTION

#寫積分異動檔
FUNCTION t300sub_ins_lsm(p_lsm01,p_lsm02,p_lsm03,p_lsm04,p_lsm05,p_lsm08,p_lsmplant,p_rxt08,p_rxt16)
DEFINE p_lsm01     LIKE lsm_file.lsm01,
       #p_lsm02     LIKE lsm_file.lsm02,   #FUN-CB0028 mark
       p_lsm02     LIKE rxt_file.rxt05,    #FUN-CB0028 add
       p_lsm03     LIKE lsm_file.lsm03,
       p_lsm04     LIKE lsm_file.lsm04,
       p_lsm05     LIKE lsm_file.lsm05,
       p_lsm08     LIKE lsm_file.lsm08,
       p_lsmplant  LIKE lsm_file.lsmplant,
       p_rxt08     LIKE rxt_file.rxt08,
       p_rxt16     LIKE rxt_file.rxt16

DEFINE l_lsm  RECORD LIKE lsm_file.*
DEFINE l_sql  STRING
DEFINE l_cnt  LIKE type_file.num5

    INITIALIZE l_lsm.* TO NULL
    LET l_lsm.lsm01 = p_lsm01
    IF cl_null(p_lsm04) THEN   #FUN-CB0028 add
       LET p_lsm04 = 0         #FUN-CB0028 add
    END IF                     #FUN-CB0028 add
    IF p_rxt16  = '1' THEN
        IF p_rxt08 = '2' THEN
            CASE
                WHEN p_lsm02 MATCHES '[03]'
                    IF p_lsm02 = '0' THEN LET l_lsm.lsm02 = '7' END IF   #銷售單積分
                    IF p_lsm02 = '3' THEN LET l_lsm.lsm02 = 'X' END IF   #訂單積分 目前先給X
                WHEN p_lsm02 MATCHES '[124]'
                    IF p_lsm02 MATCHES '[12]' THEN LET l_lsm.lsm02 = '8' END IF   #銷退單積分
                    IF p_lsm02 = '4' THEN LET l_lsm.lsm02 = 'Y' END IF        #退訂單積分 目前先給Y
            END CASE
        END IF
        LET l_lsm.lsm04 = p_lsm04
        LET l_lsm.lsm08 = p_lsm08
    ELSE
        IF p_rxt08 = '2' THEN
            CASE
                WHEN p_lsm02 MATCHES '[03]'
                    IF p_lsm02 = '0' THEN LET l_lsm.lsm02 = '7' END IF   #銷售單積分
                    IF p_lsm02 = '3' THEN LET l_lsm.lsm02 = 'X' END IF   #訂單積分 目前先給X
                WHEN p_lsm02 MATCHES '[124]'
                    IF p_lsm02 MATCHES '[12]' THEN LET l_lsm.lsm02 = '8' END IF   #銷退單積分
                    IF p_lsm02 = '4' THEN LET l_lsm.lsm02 = 'Y' END IF        #退訂單積分 目前先給Y
            END CASE
        END IF
        IF p_rxt08 = '3' THEN
            CASE
                WHEN p_lsm02 MATCHES '[03]'
                    IF p_lsm02 = '0' THEN LET l_lsm.lsm02 = '9' END IF   #銷售單積分
                    IF p_lsm02 = '3' THEN LET l_lsm.lsm02 = 'B' END IF   #訂單積分 目前先給X
                WHEN p_lsm02 MATCHES '[124]'
                    IF p_lsm02 MATCHES '[12]' THEN LET l_lsm.lsm02 = 'A' END IF   #銷退單積分
                    IF p_lsm02 = '4' THEN LET l_lsm.lsm02 = 'C' END IF        #退訂單積分 目前先給Y
            END CASE
        END IF
        LET l_lsm.lsm04 = -1*p_lsm04
        LET l_lsm.lsm08 = -1*p_lsm08
        #FUN-CB0028-------add----str
        IF p_rxt08 = '8' THEN
           IF p_lsm02 = '16' THEN LET l_lsm.lsm02 = '4' END IF
           SELECT lsm04,lsm08 INTO l_lsm.lsm04,l_lsm.lsm08 FROM lsm_file
            WHERE lsm01 = l_lsm.lsm01
              AND lsm02 = l_lsm.lsm02
              AND lsm03 = p_lsm03
              AND lsm05 = p_lsm05
              AND lsm15 = '2'
              AND lsmstore = p_lsmplant
           IF cl_null(l_lsm.lsm04) THEN LET l_lsm.lsm04 = 0 END IF
           IF cl_null(l_lsm.lsm08) THEN LET l_lsm.lsm08 = 0 END IF
           LET l_lsm.lsm04 = -1*l_lsm.lsm04
           LET l_lsm.lsm08 = -1*l_lsm.lsm08
        END IF
        #FUN-CB0028-------add----end
    END IF
    LET l_lsm.lsm03 = p_lsm03
    LET l_lsm.lsm05 = p_lsm05
    LET l_lsm.lsm07 = p_lsmplant
    LET l_lsm.lsm09 = 0
    LET l_lsm.lsm10 = 0
    LET l_lsm.lsm11 = 0
    LET l_lsm.lsm12 = 0
    LET l_lsm.lsm13 = 0
    LET l_lsm.lsm15 = '3'
   #LET l_lsm.lsmplant = p_lsmplant   #FUN-C90102 mark 
    LET l_lsm.lsmstore = p_lsmplant   #FUN-C90102 add
   #SELECT azw02 INTO l_lsm.lsmlegal FROM azw_file WHERE azw01= l_lsm.lsmplant #FUN-CB0028
    CALL s_getlegal(l_lsm.lsmstore) RETURNING l_lsm.lsmlegal                   #FUN-CB0028

   #LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_lsm.lsmplant,"lsm_file"),  #FUN-C90102 mark 
    LET l_sql = "SELECT COUNT(*) FROM lsm_file",                                         #FUN-C90102 add
                " WHERE lsm01='",l_lsm.lsm01,"' AND lsm02='",l_lsm.lsm02,"' ",
                "   AND lsm03='",l_lsm.lsm03,"' AND lsm05='",l_lsm.lsm05,"' ",
               #"   AND lsm15='3' AND lsmplant='",l_lsm.lsmplant,"'"    #FUN-C90102 mark 
                "   AND lsm15='3' AND lsmstore='",l_lsm.lsmplant,"'"    #FUN-C90102 add
   #CALL cl_replace_sqldb(l_sql) RETURNING l_sql  #FUN-C90102 mark 
    PREPARE sel_lsm_prep2 FROM l_sql
    EXECUTE sel_lsm_prep2 INTO l_cnt
    IF l_cnt = 0 THEN
       #FUN-C90102 mark START
       #LET l_sql = "INSERT INTO ",cl_get_target_table(l_lsm.lsmplant,"lsm_file"),
       #            "  VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?) "
       #CALL cl_replace_sqldb(l_sql) RETURNING l_sql
       #PREPARE insert_lsm_prep FROM l_sql
       #EXECUTE insert_lsm_prep USING l_lsm.*
       #FUN-C90102 mark END
        INSERT INTO lsm_file VALUES l_lsm.*  #FUN-C90102 add
    ELSE
       #LET l_sql = "UPDATE ",cl_get_target_table(l_lsm.lsmplant,"lsm_file"),   #FUN-C90102 mark 
        LET l_sql = "UPDATE lsm_file",                                          #FUN-C90102 add 
                    "   SET lsm04 = lsm04 + ",l_lsm.lsm04,",",
                    "       lsm08 = lsm08 + ",l_lsm.lsm08,
                    " WHERE lsm01='",l_lsm.lsm01,"' AND lsm02='",l_lsm.lsm02,"' ",
                    "   AND lsm03='",l_lsm.lsm03,"' AND lsm05='",l_lsm.lsm05,"'",
                   #"   AND lsm15='3' AND lsmplant='",l_lsm.lsmplant,"'"   #FUN-C90102 mark 
                    "   AND lsm15='3' AND lsmstore='",l_lsm.lsmplant,"'"   #FUN-C90102 add
       #CALL cl_replace_sqldb(l_sql) RETURNING l_sql
        PREPARE upd_lsm_prep FROM l_sql
        EXECUTE upd_lsm_prep
    END IF
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN
        LET g_success = 'N'
        LET g_showmsg = l_lsm.lsmplant,"/",p_lsm02,"/",l_lsm.lsm03,"/",l_lsm.lsm01
        CALL s_errmsg('rxt03,rxt05,rxt06,rxt09',g_showmsg,'lsm_file',SQLCA.sqlcode,1)
        RETURN
    END IF
END FUNCTION

#更新卡信息
FUNCTION t300sub_upd_lpj(p_lpj08,p_lpj12,p_lpj15,p_lpj06,p_shop,p_lpj03,p_rxt05,p_rxt08,p_rxt16)
DEFINE p_lpj08  LIKE lpj_file.lpj08,
       p_lpj12  LIKE lpj_file.lpj12,
       p_lpj15  LIKE lpj_file.lpj15,
       p_lpj06  LIKE lpj_file.lpj06,
       p_shop   LIKE azp_file.azp01,
       p_lpj03  LIKE lpj_file.lpj03,
       p_rxt05  LIKE rxt_file.rxt05,
       p_rxt08  LIKE rxt_file.rxt08,
       p_rxt16  LIKE rxt_file.rxt16
DEFINE l_sql    STRING
    LET l_sql = "UPDATE ",cl_get_target_table(p_shop,"lpj_file")
    IF p_rxt16 = '1' THEN
        IF p_rxt08 = '2' THEN
            LET l_sql = l_sql CLIPPED,
                        " SET lpj07 = lpj07 + 1 ,",
                        "     lpj08 = '",p_lpj08,"',",
                        "     lpj12 = lpj12 + ",p_lpj12,",",
                        "     lpj14 = lpj14 + ",p_lpj12,",",
                        "     lpj15 = lpj15 + ",p_lpj15
        END IF
    ELSE
        IF p_rxt08 = '2' THEN
            LET l_sql = l_sql CLIPPED,
                        " SET lpj12 = lpj12 - ",p_lpj12,",",
                        "     lpj14 = lpj14 - ",p_lpj12,""
        END IF
        IF p_rxt08 = '3' THEN
            LET l_sql = l_sql CLIPPED,
                        " SET lpj12 = lpj12 - ",p_lpj12,",",
                        "     lpj13 = lpj13 + ",p_lpj12
        END IF
        IF p_rxt08 = '4' THEN
            LET l_sql = l_sql CLIPPED,
                        " SET lpj06 = lpj06 - ",p_lpj06
        END IF
        #FUN-CB0028--------add-------str
        IF p_rxt08 = '6' THEN
           LET l_sql = l_sql CLIPPED,
                       " SET lpj09 = '1',",
                       "     lpj01 = '',",
                       "     lpj04 = '',",
                       "     lpj17 = ''"
        END IF
        IF p_rxt08 = '7' THEN
           LET l_sql = l_sql CLIPPED,
                       " SET lpj09 = '2',",
                       "     lpj06 = lpj06 + ",p_lpj06,",",
                       "     lpj21 = '',",
                       "     lpj22 = ''"
        END IF
        IF p_rxt08 = '81' THEN
           LET l_sql = l_sql CLIPPED,
                       " SET lpj09 = '1',",
                       "     lpj04 = '',",
                       "     lpj17 = '',",
                       "     lpj06 = 0,",
                       "     lpj07 = 0,",
                       "     lpj08 = '',",
                       "     lpj11 = 0,",
                       "     lpj12 = 0,",
                       "     lpj13 = 0,",
                       "     lpj14 = 0,",
                       "     lpj15 = 0"
        END IF
        IF p_rxt08 = '82' THEN
           LET l_sql = l_sql CLIPPED,
                       " SET lpj09 = '2',",
                       "     lpj21 = '',",
                       "     lpj22 = ''"
        END IF
        IF p_rxt08 = '9' THEN
           LET l_sql = l_sql CLIPPED,
                       " SET lpj06 = lpj06 - ",p_lpj06
        END IF
        #FUN-CB0028--------add-------end
    END IF
    LET l_sql = l_sql CLIPPED," WHERE lpj03 = '",p_lpj03,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
    PREPARE upd_lpj_prep FROM  l_sql
    EXECUTE upd_lpj_prep
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN
        LET g_success = 'N'
        LET g_showmsg = p_shop,"/",p_lpj03
        CALL s_errmsg('rxt03,rxt09',g_showmsg,'',SQLCA.sqlcode,1)
        RETURN
    END IF
END FUNCTION

FUNCTION t300sub_ins_lsn(p_lsn01,p_lsn02,p_lsn03,p_lsn04,p_lsn05,p_lsnplant,p_rxt16)
DEFINE p_lsn01     LIKE lsn_file.lsn01,
       p_lsn02     LIKE lsn_file.lsn02,
       p_lsn03     LIKE lsn_file.lsn03,
       p_lsn04     LIKE lsn_file.lsn04,
       p_lsn05     LIKE lsn_file.lsn05,
       p_lsnplant  LIKE lsn_file.lsnplant,
       p_rxt16     LIKE rxt_file.rxt16
DEFINE l_lsn  RECORD LIKE lsn_file.*
DEFINE l_sql  STRING
DEFINE l_cnt  LIKE type_file.num5

    INITIALIZE l_lsn.* TO NULL
    LET l_lsn.lsn01 = p_lsn01
    CASE
         WHEN p_lsn02 MATCHES '[03]'   #扣減餘額
             IF p_lsn02 = '0' THEN LET l_lsn.lsn02 = '7' END IF   #銷售單
             IF p_lsn02 = '3' THEN LET l_lsn.lsn02 = '6' END IF   #訂單
         WHEN p_lsn02 MATCHES '[124]'   #增加餘額
             IF p_lsn02 MATCHES '[12]' THEN LET l_lsn.lsn02 = '8' END IF   #銷退單
             IF p_lsn02 = '4' THEN LET l_lsn.lsn02 = '9' END IF            #預收退回
         #FUN-CB0028--------add------str
         WHEN p_lsn02 = '5' 
            LET l_lsn.lsn02 = '3'
         WHEN p_lsn02 = '7'
            LET l_lsn.lsn02 = '1'
         WHEN p_lsn02 = '8'
            LET l_lsn.lsn02 = '4'
         WHEN p_lsn02 = '16'
            LET l_lsn.lsn02 = '5'
         #FUN-CB0028--------add------end
    END CASE
    LET l_lsn.lsn03 = p_lsn03 
    IF cl_null(p_lsn04) THEN  #FUN-CB0028 add
       LET p_lsn04 = 0        #FUN-CB0028 add
    END IF                    #FUN-CB0028 add
    IF p_rxt16 = '1' THEN
       LET l_lsn.lsn04 = p_lsn04
    ELSE
       LET l_lsn.lsn04 = -1*p_lsn04
    END IF
    LET l_lsn.lsn05 = p_lsn05
    LET l_lsn.lsn07 = 0
    LET l_lsn.lsn08 = ' '
    LET l_lsn.lsn09 = 0
    LET l_lsn.lsn10 = '3'
   #LET l_lsn.lsnplant = p_lsnplant  #FUN-C90102 mark 
    LET l_lsn.lsnplant = ''          #FUN-C90102 add
    LET l_lsn.lsnstore = p_lsnplant  #FUN-C90102 add
   #SELECT azw02 INTO l_lsn.lsnlegal FROM azw_file WHERE azw01= l_lsn.lsnplant  #FUN-CB0028
    CALL s_getlegal(l_lsn.lsnstore) RETURNING l_lsn.lsnlegal                    #FUN-CB0028
   #LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(p_lsnplant,"lsn_file"),   #FUN-C90102 mark
    LET l_sql = "SELECT COUNT(*) FROM lsn_file ",                                     #FUN-C90102 add
                " WHERE lsn01='",l_lsn.lsn01,"' AND lsn02='",l_lsn.lsn02,"' ",
                "   AND lsn03='",l_lsn.lsn03,"' AND lsn10='3'",
                "   AND lsnstore = '",p_lsnplant CLIPPED,"' "   #FUN-C90102 add
   #CALL cl_replace_sqldb(l_sql) RETURNING l_sql   #FUN-C90102 mark
    PREPARE sel_lsn_prep FROM l_sql
    EXECUTE sel_lsn_prep INTO l_cnt
    IF l_cnt = 0 THEN
       #FUN-C90102 mark START
       #LET l_sql = "INSERT INTO ",cl_get_target_table(p_lsnplant,"lsn_file"),  
       #            "  VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?) "
       #PREPARE insert_lsn_prep FROM  l_sql
       #EXECUTE insert_lsn_prep USING l_lsn.*
       #FUN-C90102 mark END
       INSERT INTO lsn_file VALUES l_lsn.*  #FUN-C90102 add
    ELSE
       #LET l_sql = "UPDATE ",cl_get_target_table(p_lsnplant,"lsn_file"),   #FUN-C90102 mark 
        LET l_sql = "UPDATE lsn_file ",                                     #FUN-C90102 add
                            "   SET lsn04 = lsn04 + ",l_lsn.lsn04,
                            " WHERE lsn01='",l_lsn.lsn01,"' AND lsn02='",l_lsn.lsn02,"' ",
                            "   AND lsn03='",l_lsn.lsn03,"' AND lsn10='3'",
                            "   AND lsnstore = '",p_lsnplant CLIPPED,"' "   #FUN-C90102 add
       #CALL cl_replace_sqldb(l_sql) RETURNING l_sql  #FUN-C90102 mark 
        PREPARE upd_lsn_prep FROM l_sql
        EXECUTE upd_lsn_prep
    END IF
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN
        LET g_success = 'N'
        LET g_showmsg = l_lsn.lsn01,"/",l_lsn.lsn02,"/",l_lsn.lsn03,"/",l_lsn.lsn10
        CALL s_errmsg('lsn01,lsn02,lsn03,lsn10',g_showmsg,'',SQLCA.sqlcode,1)
        RETURN
    END IF
END FUNCTION

FUNCTION t300sub_get_plant()
DEFINE l_azw01  LIKE azw_file.azw01
    LET g_wc_plant = NULL
    DECLARE q300_plant_cs CURSOR FOR
     SELECT azw01 FROM azw_file
      WHERE azw01 = g_plant OR azw07 = g_plant
        AND azwacti = 'Y'
    FOREACH q300_plant_cs INTO l_azw01
        IF cl_null(g_wc_plant) THEN
            LET g_wc_plant = "'",l_azw01,"'"
        ELSE
            LET g_wc_plant = g_wc_plant,",'",l_azw01,"'"
        END IF
    END FOREACH
END FUNCTION
#FUN-CB0028-----------add-------str
FUNCTION st300_sel_lpj(p_shop,p_rxt09)
 DEFINE p_shop       LIKE lsm_file.lsmplant
 DEFINE p_rxt09      LIKE rxt_file.rxt09
 DEFINE l_sql        STRING
 DEFINE l_sql2       STRING
 DEFINE l_lsm09      LIKE lsm_file.lsm09
 DEFINE l_lsm10      LIKE lsm_file.lsm10
 DEFINE l_lsm11      LIKE lsm_file.lsm11
 DEFINE l_lsm12      LIKE lsm_file.lsm12
 DEFINE l_lsm13      LIKE lsm_file.lsm13
 DEFINE l_lsm14      LIKE lsm_file.lsm14
 DEFINE l_lsm09_1    LIKE lsm_file.lsm09
 DEFINE l_lsm10_1    LIKE lsm_file.lsm10
 DEFINE l_lsm11_1    LIKE lsm_file.lsm11
 DEFINE l_lsm12_1    LIKE lsm_file.lsm12
 DEFINE l_lsm13_1    LIKE lsm_file.lsm13

   LET g_lpj06 = 0
   LET g_lpj07 = 0
   LET g_lpj11 = 0
   LET g_lpj12 = 0
   LET g_lpj13 = 0
   LET g_lpj14 = 0
   LET g_lpj15 = 0
   LET l_lsm09 = 0
   LET l_lsm10 = 0
   LET l_lsm11 = 0
   LET l_lsm12 = 0
   LET l_lsm13 = 0
   LET l_lsm14 = NULL
   LET l_lsm09_1 = 0
   LET l_lsm10_1 = 0
   LET l_lsm11_1 = 0
   LET l_lsm12_1 = 0
   LET l_lsm13_1 = 0
   LET l_sql2 = " SELECT lpj06,lpj11,lpj12 FROM ",cl_get_target_table(p_shop,"lpj_file"),
               " WHERE lpj03 = '",p_rxt09,"'"
   PREPARE sel_oldlpj_p FROM l_sql2
   EXECUTE sel_oldlpj_p INTO g_lpj06,g_lpj11,g_lpj12 
     #1.開帳，2.補積分，3.積分清零，4.換卡，5.積分換物，6.積分換券，7出貨單，8.銷退單，9.出貨單積分抵現，A.銷退積分抵現
     #累計消費次數
      LET l_sql = " SELECT COUNT(*) FROM lsm_file " ,
                  "  WHERE lsm01 = '",p_rxt09,"'",
                  "    AND lsm02 IN ('7', '8') "
      PREPARE st300_lsm09 FROM l_sql
      EXECUTE st300_lsm09 INTO l_lsm09
      IF cl_null(l_lsm09) THEN LET l_lsm09 = 0 END IF

      LET l_lsm09_1 = 0
      LET l_sql = " SELECT lsm09 FROM lsm_file " , 
                  "  WHERE lsm01 = '",p_rxt09,"' AND lsm02 IN ('1','4') "
      PREPARE st300_lsm09_1 FROM l_sql
      EXECUTE st300_lsm09_1 INTO l_lsm09_1
      IF cl_null(l_lsm09_1) THEN LET l_lsm09_1 = 0 END IF
      LET g_lpj07 = g_lpj07 + l_lsm09 + l_lsm09_1

     #累計消費金額
      LET l_sql = " SELECT SUM(lsm08) FROM lsm_file " , 
                  "  WHERE lsm01 = '",p_rxt09,"'",
                  "    AND lsm02 IN ('2', '3', '4','7', '8') "
      PREPARE st300_lsm10 FROM l_sql
      EXECUTE st300_lsm10 INTO l_lsm10
      IF cl_null(l_lsm10) THEN LET l_lsm10 = 0 END IF

      LET l_lsm10_1 = 0
      LET l_sql = " SELECT SUM(lsm10) FROM lsm_file " ,
                  "  WHERE lsm01 = '",p_rxt09,"' AND lsm02 = '1'"
      PREPARE st300_lsm10_1 FROM l_sql
      EXECUTE st300_lsm10_1 INTO l_lsm10_1
      IF cl_null(l_lsm10_1) THEN LET l_lsm10_1 = 0 END IF
      LET g_lpj15 = g_lpj15 + l_lsm10 + l_lsm10_1

     #累計消費積分
      LET l_sql = " SELECT SUM(lsm04) FROM lsm_file " ,
                  "  WHERE lsm01 = '",p_rxt09,"'",
                  "    AND lsm02 IN ('2', '3', '7', '8') "
      PREPARE st300_lsm11 FROM l_sql
      EXECUTE st300_lsm11 INTO l_lsm11
      IF cl_null(l_lsm11) THEN LET l_lsm11 = 0 END IF

      LET l_lsm11_1 = 0
      LET l_sql = " SELECT SUM(lsm11) FROM lsm_file " , 
                  "  WHERE lsm01 = '",p_rxt09,"' AND lsm02 IN ('1','2') "
      PREPARE st300_lsm11_1 FROM l_sql
      EXECUTE st300_lsm11_1 INTO l_lsm11_1
      IF cl_null(l_lsm11_1) THEN LET l_lsm11_1 = 0 END IF
      LET g_lpj14 = g_lpj14 + l_lsm11 + l_lsm11_1
     #已兌換積分
      LET l_sql = " SELECT SUM(lsm04) FROM lsm_file " ,
                  "  WHERE lsm01 = '",p_rxt09,"'",
                  "    AND lsm02 IN ('5', '6', '9', 'A') "
      PREPARE st300_lsm13 FROM l_sql
      EXECUTE st300_lsm13 INTO l_lsm13
      IF cl_null(l_lsm13) THEN LET l_lsm13 = 0 END IF

      LET l_lsm13_1 = 0
      LET l_sql = " SELECT SUM(lsm13) FROM lsm_file " , 
                  "  WHERE lsm01 = '",p_rxt09,"' AND lsm02 IN ('1','2') "
      PREPARE st300_lsm13_1 FROM l_sql
      EXECUTE st300_lsm13_1 INTO l_lsm13_1
      IF cl_null(l_lsm13_1) THEN LET l_lsm13_1 = 0 END IF
      LET g_lpj13 = g_lpj13 + l_lsm13 + l_lsm13_1

     #最後消費日
      LET l_sql = " SELECT MAX(lsm05) FROM lsm_file " , 
                  "  WHERE lsm01 = '",p_rxt09,"'",
                  "    AND lsm02 IN ('1','2', '3','4', '7', '8') "
      PREPARE st300_lsm14 FROM l_sql
      EXECUTE st300_lsm14 INTO l_lsm14
      IF NOT cl_null(l_lsm14) THEN
         IF NOT cl_null(g_lpj08) THEN
            IF l_lsm14 > g_lpj08 THEN
               LET g_lpj08 = l_lsm14
            END IF
         ELSE
            LET g_lpj08 = l_lsm14
         END IF
      END IF
END FUNCTION
#FUN-CB0028-----------add-------end
#FUN-CC0057-----------add-------str
FUNCTION t300sub_XmlData(p_server_name,p_type,p_value,p_requestxml)
DEFINE p_server_name       STRING      #服务名
DEFINE p_type              STRING      #单身名
DEFINE p_value             STRING      #字段名
DEFINE p_requestxml        STRING
DEFINE l_value             STRING
DEFINE l_len1              INTEGER,    #XML單頭筆數
       l_len2              INTEGER     #XML單身筆數
DEFINE l_node1             om.DomNode,
       l_node2             om.DomNode
DEFINE l_paytype           STRING      #請求類型
DEFINE l_n                 INTEGER,
       l_m                 INTEGER
DEFINE l_request_xml       VARCHAR(4000)
DEFINE l_sql               STRING
DEFINE l_node              om.DomNode  #FUN-D10095 Add

   LET l_sql =  "SELECT requestxml ",
                "  FROM ",g_posdbs,"tk_wslog",g_db_links,",rxu_file ",
                " WHERE servicestate IN('2','3','4')",
                "   AND UPPER(replace(rxu01,'-','')) = UPPER(trans_id)",
                "   AND rxu01 = '",p_requestxml,"'"
   PREPARE sel_xml FROM l_sql
   EXECUTE sel_xml INTO l_request_xml

  #FUN-D40052-----mark&add---str
  #SELECT wap02 INTO g_wap02 FROM wap_file
  #IF g_wap02 = 'Y' THEN
  #   LET l_request_xml = cl_coding_de(l_request_xml)
  #END IF
   LET l_request_xml = cl_get_plaintext(l_request_xml)
   IF l_request_xml="-1" THEN
      LET g_success = 'N'
      CALL s_errmsg('','','Decode error',SQLCA.sqlcode,1)
      RETURN NULL
   END IF
  #FUN-D40052-----mark&add---end
   LET l_request_xml = sapcq300_xml_process(l_request_xml)
   LET g_request_root = sapcq300_xml_stringToXml(l_request_xml)
   CASE p_server_name
        WHEN "DeductSPayment"
           #FUN-D10095 Mark&Add STR-------
           #LET l_len1 = sapcq300_xml_getMasterRecordLength(g_request_root,"PAY")
           #FOR l_n = 1 TO l_len1
           #    LET l_node1 = sapcq300_xml_getMasterRecord(g_request_root,l_n,"PAY")
           #    LET l_len2 = sapcq300_xml_getDetailRecordLength(l_node1)
           #    FOR l_m = 1 TO l_len2
           #        LET l_node2 = sapcq300_xml_getDetail(l_node1,l_m)
             LET l_len1 = sapcq300_xml_getTreeMasterRecordLength(g_request_root,"Pay")
             FOR l_n = 1 TO l_len1
                 LET l_node1 = sapcq300_xml_getTreeMasterRecord(g_request_root,l_n,"Pay")
                 LET l_len2 = sapcq300_xml_getTreeRecordLength(l_node1,"Pay")
                 FOR l_m = 1 TO l_len2
                     LET l_node2 = sapcq300_xml_getTreeRecord(l_node1, l_m ,"Pay")
           #FUN-D10095 Mark&Add END-------
                    LET l_paytype = l_node2.getAttribute("name")
                    IF l_paytype = p_type THEN
                       LET l_value = sapcq300_xml_getDetailRecordField(l_node2,p_value)
                    END IF
                END FOR
            END FOR
        WHEN "MemberUpgrade"
           #LET l_value = sapcq300_xml_getParameter(g_request_root,p_value)                  #FUN-D10095 Mark
           LET l_node = sapcq300_xml_getTreeMasterRecord(g_request_root,1,"MemberUpgrade")   #FUN-D10095 Add
           LET l_value = sapcq300_xml_getDetailRecordField(l_node,p_value)                   #FUN-D10095 Add
    END CASE
    RETURN l_value
END FUNCTION
#FUN-CC0057-----------add-------end
#FUN-CC0135---------add-----str
FUNCTION t300sub_ins_lqr(p_lpj01,p_shop,p_rxt11,p_rxt07)
DEFINE p_lpj01       LIKE lpj_file.lpj01
DEFINE p_shop        LIKE azw_file.azw01
DEFINE p_rxt07       LIKE rxt_file.rxt07
DEFINE p_rxt11       LIKE rxt_file.rxt11
DEFINE g_lqr         RECORD LIKE lqr_file.*
DEFINE g_lqt         RECORD LIKE lqt_file.*
DEFINE l_rye04       LIKE rye_file.rye04
DEFINE li_result     LIKE type_file.num5
DEFINE l_sql         STRING

   CALL s_get_defslip("alm","O3",p_shop,'N') RETURNING l_rye04
   IF cl_null(l_rye04) THEN
      LET g_success = 'N'
   END IF
   CALL s_auto_assign_no("alm",l_rye04,g_today,"O3","lqr_file","lqr",p_shop,"","")
        RETURNING li_result,g_lqr.lqr01
   IF (NOT li_result) THEN
       LET g_success = 'N'
   END IF
   LET g_lqr.lqr02 = g_today
   LET g_lqr.lqr04 = g_user
   LET g_lqr.lqr05 = '2'
   LET g_lqr.lqracti = 'Y'
   LET g_lqr.lqrconf ='Y'
   LET g_lqr.lqrdate = g_today
   LET g_lqr.lqrgrup = g_grup
   CALL s_getlegal(p_shop) RETURNING g_lqr.lqrlegal
   LET g_lqr.lqrorig = g_grup
   LET g_lqr.lqroriu = g_user
   LET g_lqr.lqrplant = p_shop
   LET g_lqr.lqrmodu = g_user
   LET g_lqr.lqrud13 = NULL
   LET g_lqr.lqrud14 = NULL
   LET g_lqr.lqrud15 = NULL
   LET g_lqr.lqruser = g_user
   LET g_lqr.lqrcond = g_today
   LET g_lqr.lqrconu = g_user
   LET l_sql = " INSERT INTO ",cl_get_target_table(p_shop,"lqr_file"),
               " (lqr01,lqr02,lqr04,lqr05,lqracti,lqrconf,lqrdate,lqrgrup,lqrlegal,lqrorig,lqroriu,lqrplant,lqrmodu,lqrud13,lqrud14,lqrud15,lqruser,lqrcond,lqrconu)",
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?) "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,p_shop) RETURNING l_sql
   PREPARE ins_lqr_pre FROM l_sql
   EXECUTE ins_lqr_pre USING g_lqr.lqr01,g_lqr.lqr02,g_lqr.lqr04,g_lqr.lqr05,
                             g_lqr.lqracti,g_lqr.lqrconf,g_lqr.lqrdate,g_lqr.lqrgrup,
                             g_lqr.lqrlegal,g_lqr.lqrorig,g_lqr.lqroriu,g_lqr.lqrplant,
                             g_lqr.lqrmodu,g_lqr.lqrud13,g_lqr.lqrud14,g_lqr.lqrud15,
                             g_lqr.lqruser,g_lqr.lqrcond,g_lqr.lqrconu
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN
      LET g_success = 'N'
      LET g_showmsg = g_lqr.lqr01
      CALL s_errmsg('lqr01',g_showmsg,'lqr_file',SQLCA.sqlcode,1)
      RETURN
   END IF
   LET g_lqt.lqt01 = g_lqr.lqr01
   LET g_lqt.lqt02 = 1
   LET l_sql = "SELECT lpk10 FROM ",cl_get_target_table(p_shop,"lpk_file"),
               " WHERE lpk01 = '",p_lpj01,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,p_shop) RETURNING l_sql
   PREPARE sel_lpk10_pre FROM l_sql
   EXECUTE sel_lpk10_pre INTO g_lqt.lqt04
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      LET g_showmsg = g_lqt.lqt04
      CALL s_errmsg('lqt01',g_showmsg,'lqt_file',SQLCA.sqlcode,1)
      RETURN
   END IF
   LET l_sql = "SELECT lpj01,SUM(lpj15),SUM(lpj14),SUM(lpj07) FROM ",cl_get_target_table(p_shop,"lpj_file"),
               " WHERE lpj01 = '",p_lpj01,"'",
               " GROUP BY lpj01"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,p_shop) RETURNING l_sql
   PREPARE sel_lpj01_lpj15_pre FROM l_sql
   EXECUTE sel_lpj01_lpj15_pre INTO g_lqt.lqt03,g_lqt.lqt05,g_lqt.lqt06,g_lqt.lqt07
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      LET g_showmsg = g_lqt.lqt03
      CALL s_errmsg('lqt01',g_showmsg,'lqt_file',SQLCA.sqlcode,1)
      RETURN
   END IF
   LET g_lqt.lqt08 = p_rxt11 
   LET g_lqt.lqtlegal = g_lqr.lqrlegal
   LET g_lqt.lqtplant = p_shop
   LET l_sql = " INSERT INTO ",cl_get_target_table(p_shop,"lqt_file"),
               " (lqt01,lqt02,lqt04,lqt03,lqt05,lqt06,lqt07,lqt08,lqtlegal,lqtplant)",
               " VALUES(?,?,?,?,?, ?,?,?,?,?) "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,p_shop) RETURNING l_sql
   PREPARE ins_lqt_pre FROM l_sql
   EXECUTE ins_lqt_pre USING g_lqt.lqt01,g_lqt.lqt02,g_lqt.lqt04,g_lqt.lqt03,g_lqt.lqt05,
                             g_lqt.lqt06,g_lqt.lqt07,g_lqt.lqt08,g_lqt.lqtlegal,g_lqt.lqtplant
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN
      LET g_success = 'N'
      LET g_showmsg = g_lqt.lqt01
      CALL s_errmsg('lqt01',g_showmsg,'lqt_file',SQLCA.sqlcode,1)
      RETURN
   END IF
   LET l_sql = " UPDATE ",cl_get_target_table(p_shop,"rxu_file"),
               "    SET rxu16 = '",g_lqr.lqr01,"'",
               "  WHERE rxu01 = '",p_rxt07,"'",
               "    AND rxu02 = ' '"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,p_shop) RETURNING l_sql
   PREPARE upd_rxu_pre1 FROM l_sql
   EXECUTE upd_rxu_pre1
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <= 0 THEN
      LET g_success = 'N'
      LET g_showmsg = p_rxt07 
      CALL s_errmsg('rxu01',g_showmsg,'rxu_file',SQLCA.sqlcode,1)
      RETURN
   END IF
END FUNCTION
#FUN-CC0135---------add-----end
