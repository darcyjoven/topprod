# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: scbmp600.4gl
# Descriptions...: BOM，MI工单批量审核功能
# Date & Author..: 22/03/22 By darcy
import os
DATABASE ds

GLOBALS "../../../tiptop/config/top.global"
GLOBALS "../../../tiptop/aec/4gl/aecp110.global"
GLOBALS "../../../tiptop/sub/4gl/s_data_center.global"

DEFINE g_success_bom  DYNAMIC ARRAY OF RECORD
            bma01   LIKE bma_file.bma01,
            ima02   LIKE ima_file.ima02,
            ima021  LIKE ima_file.ima021,
            bma06   LIKE bma_file.bma06,
            bmauser LIKE bma_file.bmauser,
            tim     DATETIME YEAR TO SECOND
        END RECORD,
        g_success_aeci100   DYNAMIC ARRAY OF RECORD
            ecu01   LIKE ecu_file.ecu01,
            ima02   LIKe ima_file.ima02,
            ima021  LIKe ima_file.ima021,
            ecu02   LIKE ecu_file.ecu02,
            ecuuser LIKE ecu_file.ecuuser,
            tim     DATETIME YEAR TO SECOND
        END RECORD
DEFINE g_flag       LIKE type_file.chr1
DEFINE g_first_bma01 LIKE bma_file.bma01  #add:darcy:2022/04/15

define  g_uuid varchar(40)
define  g_err_index integer
define  g_ecu01 like ecu_file.ecu01,
        g_ecu02 like ecu_file.ecu02,
        g_ecu01_o like ecu_file.ecu01,
        g_ecu02_o like ecu_file.ecu02
define  g_ecn    like type_file.chr1
define  g_cnt   record
        error integer,
        warn  integer,
        info integer
        end record

type fast_bom record
    bmb01       varchar(40),
    bmb03       varchar(40),
    ima02       varchar(120),
    ima021      varchar(120),
    bmb06       varchar(40),
    bmbud01     varchar(255),
    bmbud02     varchar(40),
    bmbud05     varchar(40),
    bmbud06     varchar(40),
    bmbuuid     varchar(32)
end record
type fast_mi record
    ecb01       varchar(40),
    ecb02       varchar(10),
    ecb03       varchar(10),
    ecb06       varchar(6),
    ecbud02     varchar(1500),
    ecbud03     varchar(1500),
    ecbud04     varchar(400),
    ecbud17     varchar(1000),
    ecbuuid     varchar(32)
end record
define g_bmb     record like bmb_file.*
define g_bmy     record like bmy_file.*
define g_ima08_h,g_ima08_b like ima_file.ima08
define g_error dynamic array of record
    err01 varchar(40),
    err02 integer,
    err03 varchar(40),
    err04 varchar(40),
    err05 varchar(10),
    err06 varchar(10),
    err07 varchar(1000),
    err08 integer
end record

FUNCTION s_cbmp600(p_wc,p_inTransaction)
    DEFINE p_wc         STRING
    DEFINE l_sql        STRING
    DEFINE l_bma01      LIKE bma_file.bma01
    DEFINE l_bma06      LIKE bma_file.bma06
    DEFINE l_bmauser      LIKE bma_file.bmauser
    DEFINE l_success_cnt    LIKe type_file.num5
    DEFINE l_idx        LIKE type_file.num5
    define p_inTransaction  like type_file.num5 #darcy:2023/04/13 add

    if g_prog = 'abmi600' then
        IF NOT cl_confirm('cbm-006') THEN
            RETURN
        END IF
    end if

    LET g_success = 'Y'
    # CALL s_showmsg_init() #darcy:2023/04/13 mark 移动到crt_temp中
    CALL s_cbmp600_cusor()
    #CALL g_success_bom.clear()      #darcy:2023/04/14 mark 移动到crt_temp中
    #CALL g_success_aeci100.clear()  #darcy:2023/04/14 mark 移动到crt_temp中
    if not p_inTransaction then #darcy:2023/04/13 add
        call s_cbmp600_crt_temp()
        begin work
    end if  #darcy:2023/04/13 add

    LET l_sql = "SELECT bma01,bma06,bmauser FROM bma_file WHERE bmaacti='Y' AND ",p_wc

    PREPARE abmi600_pre FROM l_sql
    DECLARE abmi600_dcl CURSOR FOR abmi600_pre

    LET l_success_cnt = 0
    LET g_first_bma01 ="" #add:darcy:2022/04/15
    FOREACH abmi600_dcl INTO l_bma01,l_bma06,l_bmauser
        IF STATUS THEN
            CALL s_errmsg("bma01,bma06",l_bma01||","||l_bma06,"abmi600_dcl",'!',1)
            LET g_success = 'N'
            RETURN
        END IF
        #add:darcy:2022/04/15 s---
        IF cl_null(g_first_bma01) THEN
            LET g_first_bma01 = l_bma01
        END IF
        #add:darcy:2022/04/15 e---
        LET g_flag = 'Y'
        CALL s_cbmp600_b(l_bma01,l_bma06)
        IF g_success ='N' THEN
            LET g_totsuccess ='N'
            CONTINUE FOREACH
        END iF
        IF g_flag = 'Y' THEN
            CALL g_success_bom.appendElement()
            LET g_success_bom[g_success_bom.getLength()].bma01 = l_bma01
            LET g_success_bom[g_success_bom.getLength()].bma06 = l_bma06
            IF cl_null(g_success_bom[g_success_bom.getLength()].bma06) THEN LET g_success_bom[g_success_bom.getLength()].bma06 =' ' END IF
            SELECT ima02,ima021 INTO g_success_bom[g_success_bom.getLength()].ima02,g_success_bom[g_success_bom.getLength()].ima021 FROM ima_file WHERE ima01 = l_bma01
            IF cl_null(g_success_bom[g_success_bom.getLength()].ima02) THEN LET g_success_bom[g_success_bom.getLength()].ima02 =' ' END IF
            IF cl_null(g_success_bom[g_success_bom.getLength()].ima021) THEN LET g_success_bom[g_success_bom.getLength()].ima021 =' ' END IF
            LET g_success_bom[g_success_bom.getLength()].bmauser= l_bmauser

            LET g_success_bom[g_success_bom.getLength()].tim = CURRENT YEAR TO SECOND
        ELSE
            LET g_flag = 'Y'
        END IF
        CALL s_cbmp600_e(l_bma01)
        IF g_success ='N' THEN
            LET g_totsuccess ='N'
            CONTINUE FOREACH
        END IF
        CALL s_cbmp600_bom(l_bma01,l_bma06)
        IF g_success ='N' THEN
            LET g_totsuccess ='N'
            CONTINUE FOREACH
        END IF
    END FOREACH

    IF g_success ='Y' THEN
        CALL s_errmsg('bmb01',l_bma01,"BOM审核完成，成功"||g_success_bom.getLength()||"笔！","cbm-007",-1)  #darcy:2023/04/14 add 修改提示报错形式
        MESSAGE "BOM审核完成，成功"||g_success_bom.getLength()||"笔！"
        if not p_inTransaction then #darcy:2023/04/13 add
            COMMIT WORK
            CALL s_cbmp600_mail()
            # 发送邮件如果不在事务中才发送，否则应该自己调用发送 #darcy:2023/04/14 add
        end if  #darcy:2023/04/13 add
    ELSE
        ROLLBACK WORK
    END IF
    if not p_inTransaction then #darcy:2023/04/14 add
        CALl s_showmsg()
    end if #darcy:2023/04/14 add
END FUNCTION

FUNCTION s_cbmp600_cusor()
    DEFINE l_sql        STRING

    #查下阶级料
    LET l_sql = " SELECT bmb03,bmb29,bmauser FROM bmb_file,bma_file
                 WHERE bmb01 = bma01 AND bma01 = ? AND bma06 = ? AND bmaacti='Y'
                   AND bmb03 IN (SELECT bmb01 FROM bmb_file) "
    PREPARE cbmp600_bmb03_pre FROM l_sql
    DECLARE cbmp600_bmb03_dlc CURSOR FOR cbmp600_bmb03_pre

    LET l_sql = "SELECT * FROM bma_file WHERE bma01 = ? AND bma06 = ? FOR UPDATE "
    LET l_sql = cl_forupd_sql(l_sql)
    DECLARE i600sub_cl_scbmp600 CURSOR FROM l_sql

    LET l_sql ="SELECT a.gen06 ,b.gen06
                 FROM ima_file, gen_file a,gen_file b
                 WHERE ima01 = ?
                 AND a.gen01 = TO_CHAR(imaud11)
                 AND b.gen01 = to_char(imaud12) "
    PREPARE cbmp600_imaud12 FROM l_sql
END FUNCTION

FUNCTION s_cbmp600_b(p_bma01,p_bmb06)
    DEFINE p_bma01      LIKE bma_file.bma01
    DEFINE p_bmb06      LIKE bma_file.bma06
    define l_cnt        like type_file.num5

    # darcy:2025/11/20 add s---
    # 已经审核的bom不再审核
    select count(*) into l_cnt from bma_file
     where bma01 = p_bma01 and bma06 = p_bmb06 and bma10 <> '0'

    if l_cnt > 0 then
        return
    end if
    # darcy:2025/11/20 add e---

    CALL s_cbmp600_cnf_chk(p_bma01,p_bmb06)
    IF g_success ='N' THEN
        LET g_totsuccess ='N'
        RETURN
    END IF
    CALL s_cbmp600_cnf_upd(p_bma01,p_bmb06)
    IF g_success ='N' THEN
        LET g_totsuccess ='N'
        RETURN
    END IF
    CALL s_cbmp600_release_chk(p_bma01,p_bmb06)
    IF g_success ='N' THEN
        LET g_totsuccess ='N'
        RETURN
    END IF
    CALL s_cbmp600_release_upd(p_bma01,p_bmb06,g_today)
    IF g_success ='N' THEN
        LET g_totsuccess ='N'
        RETURN
    END IF
    RETURN
END FUNCTION

FUNCTION s_cbmp600_e(p_ecu01)
    DEFINE p_ecu01        LIKE ecu_file.ecu01
    DEFINE l_ecu02        LIKE ecu_file.ecu02
    DEFINE l_ecuuser      LIKE ecu_file.ecuuser
    # DEFINE p_ima01      LIKE ima_file.ima01

    RETURN

    DECLARE scbmp600_ecu02 CURSOR FOR
        SELECT ecu02,ecuuser FROM ecu_file WHERE ecu01 =  p_ecu01
           AND ecuacti='Y'

    FOREACH scbmp600_ecu02 INTO l_ecu02,l_ecuuser
        IF STATUS THEN
            CALL cl_err("scbmp600_ecu02",SQLCA.sqlcode,1)
            LET g_success ='N'
            RETURN
        END IF
        CALL s_ceci100_cnf_upd(p_ecu01,l_ecu02)
        IF g_success ='N' THEN
            LET g_totsuccess ='N'
            CONTINUE FOREACH
        END IF
        CALL s_ceci100_release(p_ecu01,l_ecu02)
        IF g_success ='N' THEN
            LET g_totsuccess ='N'
            CONTINUE FOREACH
        END IF
        CALL g_success_aeci100.appendElement()
        LET g_success_aeci100[g_success_aeci100.getLength()].ecu01 = p_ecu01
        LET g_success_aeci100[g_success_aeci100.getLength()].ecu02 = l_ecu02
        IF cl_null(g_success_aeci100[g_success_aeci100.getLength()].ecu02) THEN LET g_success_aeci100[g_success_aeci100.getLength()].ecu02 = ' ' END IF
        SELECT ima02,ima021 INTO g_success_aeci100[g_success_aeci100.getLength()].ima02,g_success_aeci100[g_success_aeci100.getLength()].ima021 FROM ima_file WHERE ima01=p_ecu01
        LET g_success_aeci100[g_success_aeci100.getLength()].ecuuser = l_ecuuser

        IF cl_null(g_success_aeci100[g_success_aeci100.getLength()].ima02) THEN LET g_success_aeci100[g_success_aeci100.getLength()].ima02 = ' ' END IF
        IF cl_null(g_success_aeci100[g_success_aeci100.getLength()].ima021) THEN LET g_success_aeci100[g_success_aeci100.getLength()].ima021 = ' ' END IF

        LET g_success_aeci100[g_success_aeci100.getLength()].tim = CURRENT YEAR TO SECOND
    END FOREACH
END FUNCTION

#BOM 审核检查
FUNCTION s_cbmp600_cnf_chk(p_bma01,p_bma06)
    DEFINE l_imaud10    LIKE ima_file.imaud10
    DEFINE l_imaud07    LIKE ima_file.imaud07
    define l_imaud32    like ima_file.imaud32 #darcy:2023/07/15
    DEFINE l_cnt   LIKE type_file.num5
    DEFINE p_bma01 LIKE bma_file.bma01
    DEFINE p_bma06 LIKE bma_file.bma06
    DEFINE l_bma RECORD LIKE bma_file.*
    DEFINE l_ima01   LIKE ima_file.ima01
    DEFINE l_imaacti LIKE ima_file.imaacti
    DEFINE l_bmb09   LIKE bmb_file.bmb09
    DEFINE l_bmb     RECORD
                   bmb02    LIKE bmb_file.bmb02,
                   bmb03    LIKE bmb_file.bmb03,
                   bmb19    LIKE bmb_file.bmb19,
                   bmb10    LIKE bmb_file.bmb10,
                   bmb10_fac      LIKE bmb_file.bmb10_fac,
                   bmb10_fac2     LIKE bmb_file.bmb10_fac2,
                   ima25    LIKE ima_file.ima25,
                   ima86    LIKE ima_file.ima86,
                   bmb04    LIKE bmb_file.bmb04,
                   bmb09    LIKE bmb_file.bmb09,
                   bmb15    LIKE bmb_file.bmb15
                END RECORD
    DEFINE l_sw             LIKE type_file.chr1,
           l_bmb10_fac      LIKE bmb_file.bmb10_fac,
           l_bmb10_fac2     LIKE bmb_file.bmb10_fac2
    DEFINE l_ima70          LIKE ima_file.ima70

    select imaud10,imaud07 into l_imaud10,l_imaud07 from ima_file where ima01=p_bma01
    IF cl_null(l_imaud10) OR ( l_imaud10=0 ) THEN
        CALL s_errmsg("ima01",p_bma01,"排版数不可为0",'cbm-004',1)
        LET  g_success = 'N'
        RETURN
    END IF
    IF  cl_null(l_imaud07) THEN
        CALL s_errmsg("ima01",p_bma01,"PNL尺寸不可为空",'cbm-005',1)
        LET  g_success = 'N'
        RETURN
    END IF

    IF s_shut(0) THEN RETURN END IF

    IF cl_null(p_bma01)THEN
        CALL s_errmsg("","","",-400,1)
        LET g_errno = '-400'
        LET g_success = 'N'
        RETURN
    END IF

    SELECT * INTO l_bma.* FROM bma_file
    WHERE bma01=p_bma01
      AND bma06=p_bma06
 #NOTE: 已审核，跳过此笔，当做成功处理
    IF l_bma.bma10='1' THEN
        # CALL s_errmsg("bma01",p_bma01,"",'9023',1)
        # LET g_errno = '9023'
        # LET g_success = 'N'
        RETURN
    END IF

    IF l_bma.bma10 = '2' THEN
        # CALL s_errmsg("bma01",p_bma01,"",'abm-123',1)
        # LET g_errno = 'abm-123'
        # LET g_success = 'N'
        RETURN
    END IF

    # IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
    #     IF  NOT cl_confirm('axm-108') THEN
    #         LET g_success = 'N'
    #         RETURN
    #     END IF
    # END IF

    IF cl_null(p_bma06) THEN
        LET p_bma06 = ' '
    END IF

    SELECT ima01,imaacti,ima70
     INTO l_ima01,l_imaacti,l_ima70
     FROM ima_file
    WHERE ima01 = l_bma.bma01

    IF l_imaacti MATCHES '[PH]' THEN
        CALL s_errmsg("ima01,imaacti",l_ima01||","||l_imaacti,"",'abm-038',1)
        LET g_errno = 'abm-038'
        LET g_success = 'N'
        RETURN
    END IF

    DECLARE i600_checkbmb19_cbmp600 CURSOR FOR
    SELECT bmb02,bmb03,bmb19,bmb10,bmb10_fac,bmb10_fac,ima25,ima86,bmb04,bmb09,bmb15
      FROM bmb_file ,ima_file
      WHERE bmb01 =p_bma01 AND bmb29=p_bma06
        AND ima01 = bmb03

    FOREACH i600_checkbmb19_cbmp600 INTO l_bmb.*
        IF STATUS THEN
            CALL cl_err("i600_checkbmb19_cbmp600",STATUS,1)
            LET g_success = 'N'
            RETURN
        END IF

        SELECT ima01,imaacti,ima70,imaud32 #darcy:2023/07/15 add
            INTO l_ima01,l_imaacti,l_ima70,l_imaud32
            FROM ima_file
        WHERE ima01 = l_bmb.bmb03

        #darcy:2023/07/15 add s---
        # 设计停止使用检查
        if l_imaud32 = 1 then
            call s_errmsg('bmb01,bmb03,bmb09',p_bma01||","||l_bmb.bmb03||","||l_bmb.bmb09,'i600:','cbm-023',1)
            let g_success = 'N'
            continue foreach
        end if
        #darcy:2023/07/15 add e---

        IF cl_null(l_bmb.bmb09) THEN
            CALL s_errmsg('bmb01,bmb03,bmb09',p_bma01||","||l_bmb.bmb03||","||l_bmb.bmb09,'i600:','cbm-001',1)
            LET g_success = 'N'
            CONTINUE FOREACH
        END IF

        IF l_ima70 <> l_bmb.bmb15 THEN
            CALL s_errmsg('bmb01,bmb03,bmb15',p_bma01||","||l_bmb.bmb03||","||l_bmb.bmb15,'i600:','cbm-002',1)
            LET g_success = 'N'
            CONTINUE FOREACH
        END IF

        IF l_bmb.bmb03 MATCHES '*-*' AND l_bmb.bmb19 <>'2' THEN
            CALL s_errmsg("bm01,bmb02,bmb03",p_bma01||","||l_bmb.bmb02||","||l_bmb.bmb03," ",'cbm-003',1)
            LET g_success = 'N'
            CONTINUE FOREACH
        END IF

        #darcy:2025/03/13 add s---
        # 油墨单位检查
        if l_bmb.bmb03 matches 'M.IN*' and l_bmb.bmb10 <> 'G' then
            call s_errmsg('bmb01,bmb03,bmb10',p_bma01||","||l_bmb.bmb03||","||l_bmb.bmb10,'i600:','cbm-042',1)
            let g_success = 'N'
            continue foreach
        end if
        #darcy:2025/03/13 add e---

        if not (g_prog = "asft730" or g_prog = 'cbmp100') then #darcy:2024/07/04

        IF l_bmb.bmb03 NOT MATCHES '*-*' AND l_bmb.bmb19 <>'1' and l_bmb.bmb03 NOT MATCHES '*T' THEN  #darcy:2024/06/17 排除下线料号
            CALL s_errmsg("bm01,bmb02,bmb03",p_bma01||","||l_bmb.bmb02||","||l_bmb.bmb03," ",'cbm-003',1)
            LET g_success = 'N'
            CONTINUE FOREACH
        END IF

        end if #darcy:2024/07/04 add



        CALL s_umfchk(l_bmb.bmb03,l_bmb.bmb10,l_bmb.ima25)
            RETURNING l_sw,l_bmb10_fac
        IF l_sw THEN LET l_bmb10_fac = 1 END IF
        CALL s_umfchk(l_bmb.bmb03,l_bmb.bmb10,l_bmb.ima86)
                RETURNING l_sw,l_bmb10_fac2
        IF l_sw THEN LET l_bmb10_fac2 = 1 END IF

        UPDATE bmb_file
            SET bmb10_fac = l_bmb10_fac,
                bmb10_fac2 =  l_bmb10_fac2
        WHERE bmb01 = p_bma01 AND bmb02 = l_bmb.bmb02
            AND bmb03 = l_bmb.bmb03 AND bmb04= l_bmb.bmb04 AND bmb09= l_bmb.bmb09

    END FOREACH

    -- call scbmi600_sample(p_bma01)

    IF g_success = 'N' THEN
        RETURN
    END IF

    SELECT * INTO l_bma.* FROM bma_file
     WHERE bma01=p_bma01
       AND bma06=p_bma06

    IF NOT s_dc_ud_flag('2',l_bma.bma08,g_plant,'u') THEN
        CALL s_errmsg("bma01,bma08",l_bma.bma01||","||l_bma.bma08,"",'aoo-045',1)
        LET g_errno = 'aoo-045'
        LET g_success = 'N'
        RETURN
    END IF

    call scbmi600_sample(p_bma01) #darcy:2025/06/16 add

    IF l_bma.bma10='1' THEN
    #    CALL s_errmsg("bma01,bma10",l_bma.bma01||","||l_bma.bma10,"",'9023',1)
    #    LET g_errno = '9023'
    #    LET g_success = 'N'
       RETURN
    END IF


    LET l_cnt=0
    SELECT COUNT(*) INTO l_cnt
      FROM bmb_file
     WHERE bmb01=p_bma01
       AND bmb29=p_bma06
    IF l_cnt=0 OR l_cnt IS NULL THEN
        CALL s_errmsg("bma01,bmb29",p_bma01||","||p_bma06,"",'mfg-009',1)
        LET g_errno = 'mfg-009'
        LET g_success = 'N'
        RETURN
    END IF

END FUNCTION

#BOM 审核更新
FUNCTION s_cbmp600_cnf_upd(p_bma01,p_bma06)
    DEFINE p_bma01   LIKE bma_file.bma01
    DEFINE p_bma06   LIKE bma_file.bma06
    DEFINE l_bma     RECORD LIKE bma_file.*

    WHENEVER ERROR CONTINUE

    IF cl_null(p_bma06) THEN
        LET p_bma06 = ' '
    END IF

    OPEN i600sub_cl_scbmp600 USING p_bma01,p_bma06
    IF STATUS THEN
        CALL s_errmsg("bma01,bma06",p_bma01||","||p_bma06,"OPEN i600sub_cl_scbmp600:",STATUS,1)
        CLOSE i600sub_cl_scbmp600
        LET g_errno = 'aws-191'
        LET g_success = 'N'
        RETURN
    END IF

    FETCH i600sub_cl_scbmp600 INTO l_bma.*                # 鎖住將被更改或取消的資料

    IF SQLCA.sqlcode THEN
        CALL s_errmsg("bma01",p_bma01,"",SQLCA.sqlcode,1)
        CLOSE i600sub_cl_scbmp600
        LET g_errno = '-243'                     #資料已經被鎖住, 無法讀取 !
        LET g_success = 'N'
        RETURN
    END IF
    IF l_bma.bma10 <>'0' THEN
        CLOSE i600sub_cl_scbmp600
        RETURN
        # 非审核状态跳过更新
    END IF
    CLOSE i600sub_cl_scbmp600

    UPDATE bma_file
       SET bma10 = '1',#審核
           bmadate=g_today     #FUN-C40006 add
     WHERE bma01 = p_bma01
       AND bma06 = p_bma06
    IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
        CALL s_errmsg("bma01,bma06",p_bma01||","||p_bma06,"",SQLCA.sqlcode,1)
        LET g_errno = 'aws-193'
        LET g_success = 'N'
        RETURN
    END IF

END FUNCTION
#BOM 发放检查
FUNCTION s_cbmp600_release_chk(p_bma01,p_bma06)
    DEFINE p_bma01   LIKE bma_file.bma01
    DEFINE p_bma06   LIKE bma_file.bma06
    DEFINE l_bma RECORD LIKE bma_file.*
    DEFINE l_cnt   LIKE type_file.num10
    DEFINE l_ima01   LIKE ima_file.ima01
    DEFINE l_imaacti LIKE ima_file.imaacti
    DEFINE l_bmb01   LIKE bmb_file.bmb01
    DEFINE l_bmb02   LIKE bmb_file.bmb02
    DEFINE l_bmb03   LIKE bmb_file.bmb03
    DEFINE l_bmb04   LIKE bmb_file.bmb04
    DEFINE l_ima910  LIKE ima_file.ima910
    DEFINE l_n       LIKE type_file.num5
    DEFINE l_bma05   LIKE bma_file.bma05

    IF s_shut(0) THEN RETURN END IF

    LET g_success = 'Y'
    IF p_bma01 IS NULL THEN
        CALL s_errmsg("","","",-400,1)
        LET g_errno = '-400'
        LET g_success = 'N'
        RETURN
    END IF
    IF cl_null(p_bma06) THEN
        LET p_bma06 = ' '
    END IF

    SELECT * INTO l_bma.* FROM bma_file
     WHERE bma01=p_bma01
       AND bma06=p_bma06
    IF NOT s_dc_ud_flag('2',l_bma.bma08,g_plant,'u') THEN
       CALL s_errmsg("bma01,bma06,bma08",p_bma01||","||p_bma06||","||l_bma.bma08,"","aoo-045",1)
       LET g_errno = 'aoo-045'
       LET g_success = 'N'
       RETURN
    END IF
    SELECT ima01,imaacti
      INTO l_ima01,l_imaacti
      FROM ima_file
     WHERE ima01 = l_bma.bma01
    IF l_imaacti = 'N' THEN
        CALL s_errmsg("ima01,imaacti",l_ima01||","||l_imaacti ,"",'9028',1)
        LET g_errno = '9028'
        LET g_success = 'N'
        RETURN
    END IF
    IF l_imaacti MATCHES '[PH]' THEN
        CALL s_errmsg("ima01,imaacti",l_ima01||","||l_imaacti ,"",'abm-038',1)
        LET g_errno = 'abm-038'
        LET g_success = 'N'
        RETURN
    END IF
    IF l_bma.bma10 = 0 THEN
        CALL s_errmsg("bma01,bma10",l_ima01||","||l_bma.bma10 ,"",'aco-174',1)
        LET g_errno = 'aco-174'
        LET g_success = 'N'
        RETURN
    END IF
    IF l_bma.bma10 = 2 THEN
        # CALL s_errmsg("bma01",l_bma.bma01,"",'abm-003',1)
        # LET g_errno = 'abm-003'
        # LET g_success = 'N'
        RETURN
    END IF
    IF l_bma.bmaacti='N' THEN
        CALL s_errmsg("bma01",l_bma.bma01,"",'abm-003',1)
        CALL cl_err(l_bma.bmaacti,'aap-127',0)
        LET g_errno = 'aap-127'
        LET g_success = 'N'
        RETURN
    END IF
    IF NOT cl_null(l_bma.bma05) THEN
        # CALL s_errmsg("bma01,bma05",l_bma.bma01||","||l_bma.bma05,"",'abm-003',1)
        # CALL cl_err(l_bma.bma05,'abm-003',0)
        # LET g_errno = 'abm-003'
        # LET g_success = 'N'
        RETURN
    END IF
    SELECT COUNT(*)
      INTO l_cnt
      FROM bmb_file
     WHERE bmb01 = l_bma.bma01
       AND bmb29 = l_bma.bma06
    IF l_cnt=0 THEN
        CALL s_errmsg("bma01,bma05",l_bma.bma01||","||l_bma.bma05,"",'arm-034',1)
        # CALL cl_err(l_bma.bma01,'arm-034',0)
        LET g_errno = 'arm-034'
        LET g_success = 'N'
        RETURN
    END IF

    #TQC-C50031--add--str--
    IF NOT s_cbmp600_chk_bmb03(p_bma01,p_bma06) THEN
       LET g_success = 'N'
       RETURN
    END IF
    #TQC-C50031--add--end--

    #==>BOM在進行發放時，檢核下階半成品的BOM是否發放
    DECLARE i600_up_cs_scbmp600 CURSOR FOR
     SELECT bmb01,bmb02,bmb03,bmb04
       FROM bmb_file
      WHERE bmb01 = l_bma.bma01
        AND bmb29 = l_bma.bma06
        AND (bmb05 > l_bma.bma05 OR bmb05 IS NULL )

    FOREACH i600_up_cs_scbmp600 INTO l_bmb01,l_bmb02,l_bmb03,l_bmb04
        SELECT ima910
          INTO l_ima910
          FROM ima_file
         WHERE ima01 = l_bmb03
        IF cl_null(l_ima910) THEN
            LET l_ima910 = ' '
        END IF
        SELECT COUNT(*) INTO l_n
          FROM bma_file
         WHERE bma01 = l_bmb03
           AND bma06 = l_ima910
           AND bmaacti = 'Y'
        IF l_n > 0 THEN
        #NOTE: 不需要看下阶级报错
            # SELECT bma05 INTO l_bma05
            #   FROM bma_file
            #  WHERE bma01 = l_bmb03
            #    AND bma06 = l_ima910
            #    AND bmaacti = 'Y'
            # IF cl_null(l_bma05) OR l_bma05 = ' ' THEN
            #     # CALL s_errmsg('bmb01,bmb03',l_bmb01||","||l_bmb03,'i600:','amr-001',1)
            #    #LET g_errno = 'amr-001'                                #FUN-AA0035 mark
            #   #-------------No:MOD-AC0292 mark
            #    #LET g_errno = 'aws-452' #此BOM或下階半成品的BOM未發放! #FUN-AA0035 add
            #    #LET g_success = 'N'
            #   #-------------No:MOD-AC0292 end
            # END IF
        END IF
    END FOREACH

END FUNCTION
#BOM 发放
FUNCTION s_cbmp600_release_upd(p_bma01,p_bma06,p_bma05)
    DEFINE p_bma01   LIKE bma_file.bma01
    DEFINE p_bma06   LIKE bma_file.bma06
    DEFINE p_bma05   LIKE bma_file.bma05
    DEFINE l_bma     RECORD LIKE bma_file.*

    WHENEVER ERROR CONTINUE

    LET g_success = 'Y'

    IF cl_null(p_bma06) THEN
        LET p_bma06 = ' '
    END IF

    OPEN i600sub_cl_scbmp600 USING p_bma01,p_bma06
    IF STATUS THEN
        CALL s_errmsg("","",'OPEN i600sub_cl_scbmp600:',STATUS,1)
        # CALL cl_err("OPEN i600sub_cl_scbmp600:", STATUS, 1)
        CLOSE i600sub_cl_scbmp600
        LET g_errno = 'aws-191' #OPEN LOCK CURSOR失敗!
        LET g_success = 'N'
        RETURN
    END IF

    FETCH i600sub_cl_scbmp600 INTO l_bma.*                # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL s_errmsg("bma01",p_bma01,"",SQLCA.sqlcode,1)
        # CALL cl_err(p_bma01,SQLCA.sqlcode,1)     # 資料被他人LOCK
        CLOSE i600sub_cl_scbmp600
        LET g_errno = '-243'                     #資料已經被鎖住, 無法讀取 !
        LET g_success = 'N'
        RETURN
    END IF
    IF l_bma.bma10 <> '1' THEN
        CLOSE i600sub_cl_scbmp600
        LET g_flag = 'N'
        RETURN
        #非审核状态返回不更新
    END IF
    CLOSE i600sub_cl_scbmp600
    IF cl_null(p_bma05) THEN
        LET p_bma05 = g_today
    END IF
    UPDATE bma_file
       SET bma05 = p_bma05,
           bma10 = '2',
           bmadate=g_today     #FUN-C40006 add
     WHERE bma01 = l_bma.bma01
       AND bma06 = l_bma.bma06
    IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
        CALL s_errmsg("bma01,bma06",l_bma.bma01||","||l_bma.bma06,"up bma05",SQLCA.sqlcode,1)
        # CALL cl_err3("upd","bma_file",l_bma.bma01,l_bma.bma06,SQLCA.sqlcode,"","up bma05",1)
        LET g_errno = 'aws-340'
        LET g_success = 'N'
        RETURN
    END IF

END FUNCTION


#工艺审核更新
FUNCTION s_ceci100_cnf_upd(p_ecu01,p_ecu02)
    DEFINE p_ecu01      LIKE ecu_file.ecu01
    DEFINE p_ecu02      LIKE ecu_file.ecu02
    DEFINE l_cn1,l_cn2,l_cn3,l_num  LIKE type_file.num5
    DEFINE l_ecu        RECORD LIKE ecu_file.*
    DEFINE l_ecb06      LIKE ecb_file.ecb06
    DEFINE l_ecu01      LIKE type_file.chr1000


    SELECT * INTO l_ecu.* FROM ecu_file WHERE ecu01=p_ecu01 AND ecu02=p_ecu02

    #检查是否维护受镀面积
    #是否有需要维护受镀面积作业编码
    SELECT count(*) INTO l_cn2 FROM  ecb_file WHERE  ecb01=p_ecu01 AND ecb02=p_ecu02
    AND ecb06  IN (SELECT tc_ecn02 FROM tc_ecn_base  )

    SELECT  count(*) INTO l_cn3
    FROM ecb_file ,tc_ecn_file
    WHERE ecb01=p_ecu01 AND ecb02=p_ecu02
    AND ecb01=tc_ecn01 AND   ecb06=tc_ecn02 AND tc_ecn04>0


    IF l_cn2<l_cn3 THEN
        CALL s_errmsg("ecu01,ecu02",p_ecu01||","||p_ecu02,"","csf-046",1)
        LET g_success = 'N'
        RETURN
        # CALL cl_err('','csf-046',0)
    END IF

    IF cl_null(p_ecu01) OR p_ecu02 IS NULL OR l_ecu.ecu012 IS NULL THEN    #FUN-A50081 add ecu012
        CALL s_errmsg("ecu01,ecu02",p_ecu01||","||p_ecu02,"",-400,1)
        LET g_success = 'N'
        # CALL cl_err('',-400,0)
         RETURN
    END IF

         # 检查作业编码是否重复
    SELECT count(*) INTO l_cn1
    FROM
    ( SELECT  ecb01,ecb02
        FROM ecb_file
        WHERE  ecb01=p_ecu01 AND ecb02=p_ecu02
        GROUP BY  ecb01,ecb02,ecb06
        HAVING count(*)>1 )

    IF cl_null(l_cn1) THEN  LET l_cn1=0 END IF
    IF l_cn1>1 THEN
        CALL s_errmsg("ecu01,ecu02",p_ecu01||","||p_ecu02,"",'csf-033',1)
        # CALL cl_err('','csf-033',0)
        LET g_success = 'N'
         RETURN
    END IF

    UPDATE ECB_FILE
    SET ecbud06='Y'  WHERE ecb01=p_ecu01 AND ecb02=p_ecu02 AND ecbud06<>'Y' AND  ecbud04 IS NOT NULL

    UPDATE ECB_FILE
    SET ecbud06='N'  WHERE ecb01=p_ecu01 AND ecb02=p_ecu02  AND  ecbud08='G1018'

    IF g_success = 'Y' THEN
        IF l_ecu.ecuud02="Y" THEN
            # CALL s_errmsg("ecu01,ecu02",p_ecu01||","||p_ecu02,"",9023,1)
            # CALL cl_err("",9023,1)
            RETURN
        END IF
    END IF
#str----add by huanglf161027
    LET l_num = 0
    LET g_success = 'Y'
     #tianry add 161212

    DECLARE sel_ttrryy_cbmp600_cur CURSOR FOR
    SELECT ecb06,COUNT(ecb06)  FROM ecb_file  WHERE ecb01 = p_ecu01  AND ecb02 = p_ecu02
        GROUP BY ecb06  HAVING COUNT(ecb06)>1
    OPEN sel_ttrryy_cbmp600_cur
    FETCH sel_ttrryy_cbmp600_cur INTO l_ecb06,l_num
    CLOSE sel_ttrryy_cbmp600_cur
    IF l_num>0 THEN
        CALL s_errmsg("ecu01,ecu02,ecb06",p_ecu01||","||p_ecu02||","||l_ecb06,"",9023,1)
        # CALL cl_err(l_ecb06,'cec-034',1)
        LET g_success = 'N'
        RETURN
    END IF
#str----end by huanglf161027
    IF g_success = 'Y' THEN
        IF l_ecu.ecuacti="N"  THEN
            CALL s_errmsg("ecu01,ecu02",p_ecu01||","||p_ecu02,"",'aim-153',1)
            LET g_success = 'N'
            # CALL cl_err("",'aim-153',1)
            # LET g_success = 'N'   #add by huanglf161027
            RETURN                        #No.FUN-840036
        END IF
        IF l_ecu.ecuud02="Y" THEN
            # CALL s_errmsg("ecu01,ecu02",p_ecu01||","||p_ecu02,"",9023,1)
            # CALL cl_err("",9023,1)
            # LET g_success = 'N' #add by huanglf161027
            RETURN
        END IF
    END IF

#str---add by huanglf170313
    CALL scbmp600_i100_ecbud04(p_ecu01,p_ecu02,'')
    IF g_success = 'N' THEN
        CALL s_errmsg("ecu01,ecu02",p_ecu01||","||p_ecu02,"",'cec-100',1)
        # CALL cl_err('','cec-100',1)
    END IF
#str---end by huanglf170313
    IF g_success = 'Y' THEN  #add by huanglf161027
        IF l_ecu.ecuacti="N" THEN
            CALL s_errmsg("ecu01,ecu02",p_ecu01||","||p_ecu02,"",'aim-153',1)
            # CALL cl_err("",'aim-153',1)
            LET g_success = 'N'
            RETURN
        ELSE

            UPDATE ecu_file
            SET ecuud02="Y",ecudate = g_today     #FUN-D10063 add ecudate = g_today
            WHERE ecu01=p_ecu01
                AND ecu02=p_ecu02
                AND ecu012 = l_ecu.ecu012   #FUN-A50081
            IF SQLCA.sqlcode THEN
                CALL s_errmsg("ecu01,ecu02",p_ecu01||","||p_ecu02,"upd ecu_file",SQLCA.sqlcode,1)
                # CALL cl_err3("upd","ecu_file",g_ecu.ecu01,g_ecu.ecu02,SQLCA.sqlcode,"","ecuud02",1)
                ROLLBACK WORK
                LET g_success = 'N'
                RETURN
            ELSE
                CALL scbmp600_i100_e_work(p_ecu01,p_ecu02)  #add by wangxt170209
                # LET l_ecu.ecuud02="Y"
                # DISPLAY l_ecu.ecuud02 TO FORMONLY.ecuud02
                #add by zhangzs 201208   记录审核状态到中间表 ect_file   ----s------
                LET l_ecu01 = p_ecu01,p_ecu02
                # SELECT TO_CHAR(SYSDATE, 'YY-MM-DD,HH24:MM:SS') INTO l_date FROM DUAL  #日期+时间
                CALL cl_ect('aeci100',l_ecu01,g_user,'1',g_today,TIME)
                #add by zhangzs 201208   记录审核状态到中间表 ect_file   ----e------
            END IF
        END IF
    END IF


END FUNCTION

#工艺发放
FUNCTION s_ceci100_release(p_ecu01,p_ecu02)
    DEFINE l_msg              STRING #FUN-A50100
    DEFINE p_ecu01            LIKE ecu_file.ecu01,
           p_ecu02            LIKE ecu_file.ecu02
    DEFINE l_ecu              RECORD LIKE ecu_file.*

    SELECT *  INTO l_ecu.* FROM ecu_file
     WHERE ecu01 = p_ecu01 AND ecu02 = p_ecu02


    IF cl_null(p_ecu01) OR l_ecu.ecu02 IS NULL OR l_ecu.ecu012 IS NULL THEN    #FUN-A50081 add ecu012
       CALL s_errmsg("ecu01,ecu02",p_ecu01||","||p_ecu02,"",-400,1)
    #    CALL cl_err('',-400,0)
        LET g_success = 'N'
       RETURN
    END IF
#CHI-C30107 --------- add --------- begin
    IF l_ecu.ecu10="Y" THEN
        # CALL s_errmsg("ecu01,ecu02",p_ecu01||","||p_ecu02,"",'cec-030',1)
        # CALL cl_err("",'cec-030',1) #modify by huanglf160928
        LET g_success = 'N'
        RETURN
    END IF
    IF l_ecu.ecuacti="N" THEN
        CALL s_errmsg("ecu01,ecu02",p_ecu01||","||p_ecu02,"",'aim-153',1)
        LET g_success = 'N'
        # CALL cl_err("",'aim-153',1)
        RETURN
    END IF
#CHI-C30107 --------- add --------- end
    IF l_ecu.ecu10="Y" THEN
        # CALL s_errmsg("ecu01,ecu02",p_ecu01||","||p_ecu02,"",'cec-030',1)
        LET g_success = 'N'
        # CALL cl_err("",'cec-030',1)  #modify by huanglf160928
        RETURN
    END IF
#NOTE:不使用平行工艺
#  IF g_sma.sma541 = 'Y' THEN       #FUN-A60028
# #FUN-A50081 --begin--
#     LET g_confirm_p110 = 'Y'
#     CALL p110_sub()
#     LET g_confirm_p110 = 'N'
#     IF g_success = 'N' THEN
#        RETURN
# #    ELSE                               #FUN-A50100
# #    	 CALL cl_err('','aec-046',1)    #FUN-A50100
#     END IF
# #FUN-A50081 --end--
#  END IF                           #FUN-A60028


#NOTE: 审核已判断过
 #str---add by huanglf170313
    # CALL i100_ecbud04('')
    # IF g_success = 'N' THEN
    #    CALL cl_err('','cec-100',1)
    #    RETURN
    # END IF
#str---end by huanglf170313

    IF NOT (l_ecu.ecuacti="N") THEN

        #str-----add by guanyao160727
        UPDATE ima_file SET ima571 = p_ecu01,
                            ima94  = p_ecu02
                        WHERE ima01 = p_ecu01  and ima08='M'
        IF SQLCA.sqlcode THEN
            CALL s_errmsg("ecu01,ecu02",p_ecu01||","||p_ecu02,"upd ima_file",SQLCA.sqlcode,1)
            # CALL cl_err3("upd","ima_file",l_ecu.ecu01,l_ecu.ecu02,SQLCA.sqlcode,"","ima571",1)
            LET g_success = 'N'
            ROLLBACK WORK
            RETURN
        END IF
        #end-----add by guanyao160727
        UPDATE ecu_file
        SET ecu10="Y",ecudate = g_today     #FUN-D10063 add ecudate = g_today
        WHERE ecu01=p_ecu01
            AND ecu02=p_ecu02
            AND ecu012 = l_ecu.ecu012   #FUN-A50081
        IF SQLCA.sqlcode THEN
            CALL s_errmsg("ecu01,ecu02",p_ecu01||","||p_ecu02,"upd ecu_file",SQLCA.sqlcode,1)
            # CALL cl_err3("upd","ecu_file",l_ecu.ecu01,l_ecu.ecu02,SQLCA.sqlcode,"","ecu10",1)
            ROLLBACK WORK
            LET g_success = 'N'
            RETURN
        END IF
#       END IF  #CHI-C30107 mark
    END IF
END FUNCTION

#BOM遍历
FUNCTION s_cbmp600_bom(p_bma01,p_bma06)
    DEFINE p_bma01  LIKE    bma_file.bma01
    DEFINE p_bma06  LIKE    bma_file.bma06
    DEFINE l_bmb03  LIKE    bmb_file.bmb03
    DEFINE l_bmb29  LIKE    bmb_file.bmb29
    DEFINE l_success_cnt LIKE type_file.num5
    DEFINE l_bmb    DYNAMIC ARRAY OF RECORD
                    bmb03   LIKE bmb_file.bmb03,
                    bmb29   LIKE bmb_file.bmb29,
                    bmauser LIKE bma_file.bmauser
                END RECORD
    DEFINE l_cnt,l_idx    LIKE type_file.num5

    LET l_success_cnt = 0
    LET l_cnt = 1
    FOREACH cbmp600_bmb03_dlc USING p_bma01,p_bma06 INTO l_bmb[l_cnt].*
        IF STATUS THEN
            CALL cl_err("cbmp600_bmb03_dlc",SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN
        END IF
        LET l_cnt = l_cnt +1
    END FOREACH

    FOR l_idx = 1 TO l_bmb.getLength()-1

        LET g_flag = 'Y'
        CALL s_cbmp600_b(l_bmb[l_idx].bmb03,l_bmb[l_idx].bmb29)
        IF g_success = 'N' THEN
            LET g_totsuccess ='N'
            CONTINUE FOR
        END IF

        IF g_flag = 'Y' THEN

            CALL g_success_bom.appendElement()
            LET g_success_bom[g_success_bom.getLength()].bma01 = l_bmb[l_idx].bmb03
            LET g_success_bom[g_success_bom.getLength()].bma06 = l_bmb[l_idx].bmb29
            IF cl_null(g_success_bom[g_success_bom.getLength()].bma06) THEN LET g_success_bom[g_success_bom.getLength()].bma06 = ' ' END IF
            LET g_success_bom[g_success_bom.getLength()].tim = CURRENT YEAR TO SECOND
            SELECT ima02,ima021 INTO g_success_bom[g_success_bom.getLength()].ima02,g_success_bom[g_success_bom.getLength()].ima021 FROM ima_file where ima01 = l_bmb[l_idx].bmb03
            IF cl_null(g_success_bom[g_success_bom.getLength()].ima02) THEN LET g_success_bom[g_success_bom.getLength()].ima02 = ' ' END IF
            IF cl_null(g_success_bom[g_success_bom.getLength()].ima021) THEN LET g_success_bom[g_success_bom.getLength()].ima021 = ' ' END IF

            LET g_success_bom[g_success_bom.getLength()].bmauser = l_bmb[l_idx].bmauser
        ELSE
            LET g_flag = 'Y'
        END IF
        CALL s_cbmp600_e(l_bmb[l_idx].bmb03)
        IF g_success = 'N' THEN
            LET g_totsuccess ='N'
            CONTINUE FOR
        END IF

        CALL s_cbmp600_bom(l_bmb[l_idx].bmb03,l_bmb[l_idx].bmb29)
        IF g_success = 'N' THEN
            LET g_totsuccess ='N'
            CONTINUE FOR
        END IF

    END FOR
END FUNCTION
#---單身元件未審核不可確認與發放
FUNCTION s_cbmp600_chk_bmb03(p_bma01,p_bma06)
    DEFINE p_bma01 LIKE bma_file.bma01
    DEFINE p_bma06 LIKE bma_file.bma06
    DEFINE l_ima01   LIKE ima_file.ima01
    DEFINE l_imaacti LIKE ima_file.imaacti
    DEFINE l_bmb03   LIKE bmb_file.bmb03
    DEFINE l_ima70   LIKE ima_file.ima70
    DEFINE l_bmb15   LIKE bmb_file.bmb15

    LET l_ima01 = NULL
    LET l_imaacti = NULL

    DECLARE i600_bmb03_cs CURSOR FOR
      SELECT bmb03,bmb15
        FROM bmb_file
       WHERE bmb01 = p_bma01
         AND bmb29 = p_bma06

    FOREACH i600_bmb03_cs INTO l_bmb03,l_bmb15
       SELECT ima01,imaacti,ima70
         INTO l_ima01,l_imaacti,l_ima70
         FROM ima_file
        WHERE ima01 = l_bmb03

       IF l_imaacti MATCHES '[PH]' THEN
          CALL s_errmsg('bmb01,bmb03',p_bma01||","||l_bmb03,'i600:','abm-084',1)
          LET g_success = 'N'
          CONTINUE FOREACH
       END IF
       IF l_ima70 <> l_bmb15 THEN
          CALL s_errmsg('bmb01,bmb03',p_bma01||","||l_bmb03,'i600:','cbm-002',1)
          LET g_success = 'N'
          CONTINUE FOREACH
       END IF
    END FOREACH
    IF g_success = 'N' THEN
       RETURN
    END IF
    RETURN TRUE
END FUNCTION


FUNCTION scbmp600_i100_e_work(p_ecu01,p_ecu02)
DEFINE p_ecu01      LIKE ecu_file.ecu01
DEFINE p_ecu02      LIKE ecu_file.ecu02
DEFINE l_sql,l_sql1      STRING
DEFINE l_ecb06     LIKE ecb_file.ecb06
DEFINE l_bmb_e     RECORD
       ecb06       LIKE ecb_file.ecb06,
       ecbud04     LIKE ecb_file.ecbud04
      END RECORD
DEFINE lst_token base.StringTokenizer
DEFINE l_bmb02     LIKE bmb_file.bmb02
DEFINE l_bmbud02   LIKE bmb_file.bmbud02
DEFINE l_x         LIKE type_file.num5
DEFINE l_bmb09     LIKE bmb_file.bmb09

    IF p_ecu01 IS NULL THEN
        CALL s_errmsg('ecu01,ecu02',p_ecu01||","||p_ecu02,'',-400,1)
        # CALL cl_err('',-400,0)
        LET g_success = 'N'
        RETURN
    END IF

    LET g_success = 'Y'
    UPDATE bmb_file SET bmb09 = ' '
                  WHERE bmb01 = p_ecu01 AND (bmb05>g_today OR bmb05 IS NULL)
    IF SQLCA.sqlcode THEN
        CALL s_errmsg('ecu01,ecu02',p_ecu01||","||p_ecu02,'upd:bmb_file',SQLCA.sqlcode,1)
        # CALL cl_err3("upd","bmb_file",l_ecu.ecu01,'',SQLCA.sqlcode,"","",1)
        LET g_success = 'N'
        RETURN
    END IF
    LET l_x = 0
    SELECT COUNT(*) INTO l_x FROM ecb_file WHERE ecb01 =p_ecu01 AND ecbud04 IS NOT NULL
    IF l_x >0 THEN
       LET l_sql = "SELECT ecb06,ecbud04 FROM ecb_file",
                   " WHERE ecb01 ='",p_ecu01,"' ",
                   "   AND ecbud04 is not null",
                   " ORDER BY ecb03"
       PREPARE i600_e_scbmp600_pb FROM l_sql
       DECLARE bmb_e_cbmp600_curs CURSOR FOR i600_e_scbmp600_pb

       INITIALIZE l_bmb_e.* TO NULL
       FOREACH bmb_e_cbmp600_curs INTO l_bmb_e.*
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             LET g_success = 'N'
             RETURN
          END IF

          LET lst_token = base.StringTokenizer.create(l_bmb_e.ecbud04, "|")
          WHILE lst_token.hasMoreTokens()
             LET l_bmb02 = ''
             LET l_bmbud02 = lst_token.nextToken()
             LET l_x = 0
             SELECT COUNT(*) INTO l_x FROM bmb_file WHERE bmbud02= l_bmbud02 AND bmb01 = p_ecu01
             IF l_x >0 THEN
                LET l_sql = "SELECT bmb02 FROM bmb_file",
                            " WHERE bmb01 ='",p_ecu01,"' ",
                            "   AND bmbud02= '",l_bmbud02,"'",
                            "  AND (bmb05 >to_date('",g_today,"','YY/MM/DD') OR bmb05 IS NULL)",
                            " ORDER BY bmb02"
                PREPARE i600_bmb_cbmp600_pb FROM l_sql
                DECLARE bmb_bmb_cbmp600_curs CURSOR FOR i600_bmb_cbmp600_pb
                LET l_bmb02 = ''
                FOREACH bmb_bmb_cbmp600_curs INTO l_bmb02
                   IF SQLCA.sqlcode THEN
                      CALL cl_err('foreach:',SQLCA.sqlcode,1)
                      LET g_success = 'N'
                      RETURN
                   END IF
                   LET l_bmb09 = ''
                   SELECT bmb09 INTO l_bmb09 FROM bmb_file WHERE bmbud02= l_bmbud02 AND bmb01 = p_ecu01 AND bmb02 = l_bmb02
                   IF NOT cl_null(l_bmb09) THEN
                      CONTINUE WHILE
                   ELSE
                      UPDATE bmb_file SET bmb09 = l_bmb_e.ecb06
                                    WHERE bmb01 = p_ecu01
                                      AND bmb02 = l_bmb02
                      IF SQLCA.sqlcode THEN
                        CALL s_errmsg('ecu01,bmb02',p_ecu01||","||l_bmb02,'upd:bmb_file',SQLCA.sqlcode,1)
                        #  CALL cl_err3("upd","bmb_file",g_ecu.ecu01,l_bmb02,SQLCA.sqlcode,"","",1)
                         LET g_success = 'N'
                         EXIT FOREACH
                      END IF
                   END IF
                END FOREACH
             END IF
          END WHILE
       END FOREACH
    ELSE
       LET g_success = 'N'
    END IF

END FUNCTION

FUNCTION scbmp600_i100_ecbud04(p_ecu01,p_ecu02,p_ecbud04)
DEFINE l_sql,l_sql1      STRING
DEFINE l_ecb06     LIKE ecb_file.ecb06
DEFINE l_ecbud04   LIKE ecb_file.ecbud04
DEFINE l_ecbud04_1 LIKE ecb_file.ecbud04
DEFINE l_ecbud04_2 LIKE ecb_file.ecbud04
DEFINE lst_token base.StringTokenizer
DEFINE lst_token1 base.StringTokenizer
DEFINE l_bmb02     LIKE bmb_file.bmb02
DEFINE l_bmbud02   LIKE bmb_file.bmbud02
DEFINE l_x         LIKE type_file.num5
DEFINE l_bmb09     LIKE bmb_file.bmb09
DEFINE l_num       LIKE type_file.num5
DEFINE p_ecbud04   LIKE ecb_file.ecbud04
DEFINE p_ecu01     LIKE ecu_file.ecu01,
       p_ecu02     LIKE ecu_file.ecu02
    IF p_ecu01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF

    DELETE FROM aeci100_tmp

    LET g_success = 'Y'

    LET l_sql = "SELECT ecbud04 FROM ecb_file",
                " WHERE ecb01 ='",p_ecu01,"' ",
                "   AND ecb02 = '",p_ecu02,"' ",
                "   AND ecbud04 is not null",
                " ORDER BY ecb03"
    PREPARE i600_e_scbmp600_pb1 FROM l_sql
    DECLARE bmb_e_scbmp600_curs1 CURSOR FOR i600_e_scbmp600_pb1

    LET l_ecbud04 = ''
    FOREACH bmb_e_scbmp600_curs1 INTO l_ecbud04
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN
        END IF

        LET lst_token = base.StringTokenizer.create(l_ecbud04, "|")
        WHILE lst_token.hasMoreTokens()
            LET l_ecbud04_1 = lst_token.nextToken()
            SELECT COUNT(*) INTO l_num FROM aeci100_tmp WHERE ecbud04 = l_ecbud04_1
            IF l_num =0 OR cl_null(l_num) THEN
                INSERT INTO aeci100_tmp VALUES(l_ecbud04_1)
            ELSE
                LET g_success = 'N'
            END IF
        END WHILE
    END FOREACH

    IF NOT cl_null(p_ecbud04) THEN
        LET lst_token1 = base.StringTokenizer.create(p_ecbud04, "|")
        WHILE lst_token1.hasMoreTokens()
            LET l_ecbud04_2 = lst_token1.nextToken()
            SELECT COUNT(*) INTO l_num FROM aeci100_tmp WHERE ecbud04 = l_ecbud04_2
            IF l_num = 0 OR cl_null(l_num) THEN
                INSERT INTO aeci100_tmp VALUES(l_ecbud04_2)
            ELSE
                LET g_success = 'N'
            END IF
        END WHILE
    END IF
END FUNCTION
FUNCTION s_cbmp600_crt_temp()
    CALL g_success_bom.clear()
    CALL g_success_aeci100.clear()
    CALL s_showmsg_init()
    DROP TABLE aeci100_tmp
    CREATE TEMP TABLE aeci100_tmp(
            ecbud04   LIKE ecb_file.ecbud04)
END FUNCTION
FUNCTION s_cbmp600_mail()
    DEFINE l_cmd,l_mail     STRING
    DEFINE l_recipient,l_title STRING
    DEFINE l_filename,l_xmlname STRING

    #darcy:2023/04/14 add s---
    #如果没有资料就不发送邮件
    if g_success_bom.getlength() = 0 then
        return
    end if
    #darcy:2023/04/14 add e---

    LET l_filename = s_cbmp600_get_content()
    LET l_recipient = s_cbmp600_get_recipient()
    LET l_title = g_first_bma01," BOM、MI 工单审核发放通知--系统自动发送" #mod:darcy:2022/04/15

    LET l_xmlname = s_cbmp600_get_mail(l_filename,l_recipient,l_title," ")

    LET l_cmd = "sh /u1/topprod/tiptop/ds4gl2/bin/javamail/UnixMailSender.bat ",l_xmlname," TRUE"
    RUN l_cmd
    LET l_cmd = "mv ",l_filename," /u1/out/mail/posted/"
    RUN l_cmd
    LET l_cmd = "rm ",l_xmlname
    RUN l_cmd


END FUNCTION


FUNCTION s_cbmp600_get_content()
    DEFINE l_idx    LIKE type_file.num5
    DEFINE l_filename   STRING
    DEFINE l_cmd        STRING
    DEFINE l_gen02      LIKE gen_file.gen02

    LET l_filename = CURRENT YEAR TO FRACTION(3)

    LET l_filename = "/u1/out/mail/",cl_replace_str(l_filename," ",""),".html"
    LET l_cmd = "rm ",l_filename
    RUN l_cmd
    LET l_cmd = "cd /u1/out/mail && cat /u1/out/mail/head >> ",l_filename
    RUN l_cmd

    FOR l_idx = 1 TO g_success_bom.getLength()
        RUN "cd /u1/out/mail && echo '<tr>' >> '"||l_filename||"'"
        RUN "cd /u1/out/mail && echo '<td>"||g_success_bom[l_idx].bma01||"</td>' >> '"||l_filename||"'"
        RUN "cd /u1/out/mail && echo '<td>"||g_success_bom[l_idx].ima02||"</td>' >> '"||l_filename||"'"
        RUN "cd /u1/out/mail && echo '<td>"||g_success_bom[l_idx].ima021||"</td>' >> '"||l_filename||"'"
        RUN "cd /u1/out/mail && echo '<td>"||g_success_bom[l_idx].bma06||"</td>' >> '"||l_filename||"'"
        RUN "cd /u1/out/mail && echo '<td>"||g_success_bom[l_idx].tim||"</td>' >> '"||l_filename||"'"
        RUN "cd /u1/out/mail && echo '</tr>' >> '"||l_filename||"'"
    END FOR
    RUN "echo '</table>' >> "||l_filename
    SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_user
    RUN "echo '<p> 上述资料审核发放人员"||g_user||"-"||l_gen02||" </p>' >> "||l_filename
    RUN "echo '<p> 邮件生成时间:"||CURRENT YEAR TO SECOND||"</p>' >> "||l_filename
    RUN "echo '</body>' >> "||l_filename
    RUN "echo '</html>' >> "||l_filename
    RUN "echo '\n\n 通知收件人：这封电子邮件和与其一起传送的任何文件都是机密的，仅供被发送邮件的个人或实体使用。如果您不是预定的收件人，并且错误地收到了这份信息，我们要求您删除并销毁您所拥有的所有副本和附件，并通知您，严格禁止根据本信息的内容披露、复制、分发或采取任何行动。 Notice to Recipients: This email and any files transmitted with it are confidential and intended solely for the use of the individual or entity to whom they are addressed. If you are not the intended recipient and received this transmittal in error we request that you please delete and destroy all copies and attachments in your possession, you are notified that disclosing, copying, distributing or taking any action in reliance on the contents of this information is strictly prohibited. ' >> "||l_filename

    RETURN l_filename
END FUNCTION

FUNCTION s_cbmp600_get_mail(p_filename,p_recipient,p_title,p_attach)
    DEFINE l_xmlname,p_filename,p_recipient,p_title,p_attach,l_cmd    STRING

    LET l_xmlname = CURRENT YEAR TO FRACTION(3)
    LET l_xmlname = "/u1/out/mail/",cl_replace_str(l_xmlname," ",""),".xml"

    RUN "echo '<Mail>' >> "||l_xmlname
    RUN "echo '<Protocol>smtp</Protocol>' >> "||l_xmlname
    RUN "echo '<CheckAuth>Y</CheckAuth>' >> "||l_xmlname
    RUN "echo '<MailServer>59.82.44.168</MailServer>' >> "||l_xmlname
    RUN "echo '<MailServerPort>25</MailServerPort>' >> "||l_xmlname
    RUN "echo '<MailServerUser>bi@forewin-sz.com.cn</MailServerUser>' >> "||l_xmlname
    RUN "echo '<MailServerUserPassword>Fly12345678</MailServerUserPassword>' >> "||l_xmlname
    RUN "echo '<Subject>"||p_title||"</Subject>' >> "||l_xmlname
    RUN "echo '<MessageBody>"||p_filename||"</MessageBody>' >> "||l_xmlname
    RUN "echo '<Attach> </Attach>' >> "||l_xmlname
    RUN "echo '<Recipient>"||p_recipient||"</Recipient>' >> "||l_xmlname
    RUN "echo '<From>bi@forewin-sz.com.cn</From>' >> "||l_xmlname
    RUN "echo '</Mail>' >> "||l_xmlname

    RETURN l_xmlname

END FUNCTION
FUNCTION s_cbmp600_get_recipient()
    DEFINE l_recipient  STRING
    DEFINE l_reciplist  STRING
    DEFINE l_idx    LIKE type_file.num5
    DEFINE l_gen06  LIKE gen_file.gen06
    DEFINE l_gen061  LIKE gen_file.gen06
    DEFINE l_gen062  LIKE gen_file.gen06

    #增加aimi100的邮件通知

    LET l_recipient = "gongcheng1@forewin-sz.com.cn;", #工程
                    #   "bruce.han@forewin-sz.com.cn;",  #韩志伟 #darcy:2024/09/04 mark
                    --   "yukun.zhang@forewin-sz.com.cn;",
                      "w.wang@forewin-sz.com.cn;",     #王委
                      "weixing.li@forewin-sz.com.cn;", #李卫星
                      "lusi.cheng@forewin-sz.com.cn;", #程露思
                      "mc23@forewin-sz.com.cn;", #孙俊英  darcy:2022/07/12
                      "darcy.li@forewin-sz.com.cn;",
                    #   "huijing.gao@forewin-sz.com.cn;",
                      "eng11@forewin-sz.com.cn;",
                      "jun.xu@forewin-sz.com.cn;",
                    #   "yifan.yang@forewin-sz.com.cn;", #darcy:2024/09/04 mark
                      "wangwei@forewin-sz.com.cn;",
                    #   "hailong.zheng@forewin-sz.com.cn;", #darcy:2024/01/08 mark
                      "eng32@forewin-sz.com.cn;"  #darcy:2023/11/20 add 增加邮箱地址
                      ,"eng41@forewin-sz.com.cn;" #darcy:2024/04/22 add 地址增加
                      --,"jinjin.chen@forewin-sz.com.cn;" #darcy:2024/10/22 add

    LET l_reciplist=  "liao.xia@forewin-sz.com.cn;"    #下料

    FOR l_idx = 1 TO g_success_bom.getLength()
        SELECT gen06 INTO l_gen06 FROM gen_file
         WHERE gen01 = g_success_bom[l_idx].bmauser
        IF NOT cl_null(l_gen06) AND l_reciplist NOT MATCHES "*"||l_gen06||"*" THEN
             LET l_reciplist = l_reciplist,l_gen06,";"
        END IF

        EXECUTE cbmp600_imaud12 USING g_success_bom[l_idx].bma01
           INTO l_gen061,l_gen062

        IF NOT cl_null(l_gen061) AND l_reciplist NOT MATCHES "*"||l_gen061||"*" THEN
             LET l_reciplist = l_reciplist,l_gen061,";"
        END IF
        IF NOT cl_null(l_gen062) AND l_reciplist NOT MATCHES "*"||l_gen062||"*" THEN
             LET l_reciplist = l_reciplist,l_gen062,";"
        END IF
    END FOR

    LET l_recipient = l_recipient,l_reciplist
    RETURN l_recipient
    # RETURN "darcy.li@forewin-sz.com.cn"
END FUNCTION

{
    导出设计资料到excel，会调用~/bom程序导出
    1. 生成uuid，将导出资料插入到tc_exp_file
    2. 运行cmd，产生excel文件
        cmd: ~/bom export uuid
    3. 下载文件，打开用户浏览器
 }
function s_cbmp600_export(p_ecu01,p_ecu02)
    define p_ecu01  like ecu_file.ecu01
    define p_ecu02  like ecu_file.ecu02
    define l_bma10  like bma_file.bma10,
            l_ecu10 like ecu_file.ecu10,
            l_ecuud02 like ecu_file.ecuud02
    define l_sql string
    define res integer
    define l_bom,l_mi varchar(20)
    define l_uuid varchar(40)

    let g_success = 'Y'

    # 1. 检查bma与ecu状态，有任何一个不存在，不允许导出
    select bma10 into l_bma10 from bma_file where bma01 = p_ecu01
    if sqlca.sqlcode then
        call cl_err(p_ecu01,sqlca.sqlcode,1)
        return 'N'
    end if
    select ecu10,ecuud02 into l_ecu10,l_ecuud02 from ecu_file
     where ecu01 = p_ecu01 and ecu02 = p_ecu02
    if sqlca.sqlcode then
        call cl_err(p_ecu01||"/"||p_ecu02,sqlca.sqlcode,1)
        return 'N'
    end if
    if l_bma10 = '0' then let l_bom = "开立" end if
    if l_bma10 = '1' then let l_bom = "审核" end if
    if l_bma10 = '2' then let l_bom = "发布" end if

    if l_ecu10 = 'Y' and l_ecuud02 = 'Y' then let l_mi = "发布" end if
    if l_ecu10 = 'Y' and l_ecuud02 != 'Y' then let l_mi = "审核" end if
    if l_ecu10 != 'Y' and l_ecuud02 != 'Y' then let l_mi = "开立" end if


    # 2. 产生uuid并插入到表中
    let l_sql = "SELECT rawtohex(SYS_GUID()) as uu FROM dual "
    prepare s_cbmp600_uuid_p from l_sql
    execute s_cbmp600_uuid_p into l_uuid
    if sqlca.sqlcode then
        call cl_err("生成uuid失败",sqlca.sqlcode,1)
        return "N"
    end if
    if cl_null(l_uuid) then
        call cl_err("生成uuid失败","!",1)
        return "N"
    end if

    let l_sql = "insert into tc_exp_file ( ",
                "   tc_exp01,tc_exp02,tc_exp03,tc_exp04,tc_exp05, ",
                "   tc_exp06,tc_exp07,tc_exp08,tc_exp09,tc_exp10 ) ",
                " values (?,?,?,sysdate,?, ?,?,?,?,?)"
    prepare s_cbmp600_ins_p from l_sql
    execute s_cbmp600_ins_p using
                l_uuid,p_ecu01,p_ecu02,l_bom,
                l_mi,g_user,'0','N',''

    if sqlca.sqlcode or sqlca.sqlerrd[3]==0 then
        call cl_err(p_ecu01||"/"||p_ecu02||" 未能插入到中间表，请反馈到IT","!",1)
        return "N"
    end if
    # 3. 运行CMD
    let l_sql = "~/fast/bom export -u ",l_uuid," --config ~/fast/.fastbom.yaml"
    run l_sql

    let l_sql = "/u1/out/",p_ecu01,"-",l_uuid,".xlsx"
    # 4. 文件存在，更新导出成功
    if not os.Path.exists(l_sql) then
        call cl_err("文件不存在，导出失败","!",1)
        update tc_exp_file
            set tc_exp10 = '文件不存在，导出失败'
        where tc_exp01 = l_uuid
        return "N"
    end if

    # 5.打开excel文件
    let l_sql = FGL_GETENV("FGLASIP"),"/tiptop/out/",p_ecu01,"-",l_uuid,".xlsx"

    CALL ui.Interface.frontCall("standard",
                                "shellexec",
                                ["EXPLORER \"" || l_sql || "\""],
                                [res])
    update tc_exp_file
            set tc_exp09 = 'Y'
        where tc_exp01 = l_uuid
    return 'Y'
end function

# 将excel导入中间表
function s_cbmp600_import(l_filename)
    define l_filename varchar(1000),
           l_sql string
    define l_uuid varchar(40)

    # 1. 产生uuid并插入到表中
    let l_sql = "SELECT rawtohex(SYS_GUID()) as uu FROM dual "
    prepare s_cbmp600_uuid_p2 from l_sql
    execute s_cbmp600_uuid_p2 into l_uuid
    if sqlca.sqlcode then
        call cl_err("生成uuid失败",sqlca.sqlcode,1)
        return ""
    end if
    if cl_null(l_uuid) then
        call cl_err("生成uuid失败","!",1)
        return ""
    end if

    let l_sql = "insert into tc_exp_file ( ",
                "   tc_exp01,tc_exp04,tc_exp07,tc_exp08,tc_exp09,tc_exp11 ) ",
                " values (?,sysdate, ?,?,?,?)"
    prepare s_cbmp600_ins_p1 from l_sql
    execute s_cbmp600_ins_p1 using
                l_uuid,g_user,'1','N',l_filename

    if sqlca.sqlcode or sqlca.sqlerrd[3]==0 then
        call cl_err(g_ecu01||"/"||g_ecu02||" 未能插入到中间表，请反馈到IT","!",1)
        return ""
    end if

    # 2. 导入到中间表
    let l_sql = "~/fast/bom import -u ",l_uuid," --config ~/fast/.fastbom.yaml"
    run l_sql

    call scbmp600_insUpd(l_uuid)

    return l_uuid
end function

# 插入新资料或者更新资料
function scbmp600_insUpd(p_uuid)
    define p_uuid varchar(40)
    define l_sql string
    define l_cnt,l_i integer
    define sr fast_bom
    define l_fastbom dynamic array of fast_bom
    define l_ecu01  like ecu_file.ecu01

# init初始化
    let g_uuid = p_uuid
    let g_err_index = 0
    let g_ecu01 = ''
    let g_ecu02 = ''
    initialize g_cnt.* to null
    call g_error.clear()
    let g_ecn = 'N' -- 默认BOM为新增
    let g_ecu01_o = ''
    let g_ecu02_o = ''

# 1获得主件料号
    select count(unique bmb01) into l_cnt from fastbom_file where bmbuuid=p_uuid
        and bmb01 not in (select bmb03 from fastbom_file where bmbuuid=p_uuid)
# 1.2多个主件 E
    if l_cnt > 1 then
        declare scbmp600_ins1_cur cursor for
            select unique bmb01 from fastbom_file where bmbuuid=p_uuid
            and bmb01 not in (select bmb03 from fastbom_file where bmbuuid=p_uuid)

        foreach scbmp600_ins1_cur into g_ecu01
            if sqlca.sqlcode then
                call cl_err("scbmp600_ins1_cur",sqlca.sqlcode,1)
                exit foreach
            end if
            call s_cbmp600_error(sfmt("得到多个主件料号：%1",g_ecu01),"BOM","error","")
        end foreach
        return
    else
# 1.1死循环 e
# 1.3没有主键 e
        if l_cnt = 0 then
            call s_cbmp600_error(sfmt("未查询到任何主件料号，请检查是否有循环套用情况",""),"BOM","error","")
            return
        end if
    end if
# 1.4=>得到主键 i
    select unique bmb01 into g_ecu01 from fastbom_file where bmbuuid=p_uuid
        and bmb01 not in (select bmb03 from fastbom_file where bmbuuid=p_uuid)
    if sqlca.sqlcode or cl_null(g_ecu01) then
        call s_cbmp600_error(sfmt("未查询到任何主件料号",""),"BOM","error","")
        return
    else
        call s_cbmp600_error(sfmt("主件料号：%1",g_ecu01),"BOM","info","")
    end if
# 2.3mi版本是否相同
    let l_cnt = 0
    select count(unique ecb02) into l_cnt from fastmi_file
     where ecbuuid = g_uuid
    if l_cnt > 1 then
        call s_cbmp600_error(sfmt("工艺资料中含有%1个版本，请确保只有1个",l_cnt),"BOM","error","")
        return
    else
        if l_cnt = 0 then
            call s_cbmp600_error(sfmt("未找到有任何工艺版本资料",""),"BOM","error","")
            return
        end if
    end if
    # 得到工艺版本
    select unique ecb02 into g_ecu02 from fastmi_file where ecbuuid = g_uuid
    if sqlca.sqlcode or cl_null(g_ecu02) then
        call s_cbmp600_error(sfmt("未查询到任何工艺版本",""),"BOM","error","")
        return
    else
        call s_cbmp600_error(sfmt("工艺版本%1",g_ecu02),"BOM","info","")
    end if
# 2.4mi中是否有不再BOM中的资料
    declare scbmp600_ins5_cur cursor from
            "select ecu01 from fastmi_file where ecbuuid=? and ecb01 not in (
                select bmb01 from fastbom_file where bmbuuid = ?)"
    foreach scbmp600_ins5_cur using g_uuid,g_uuid into l_ecu01
        if sqlca.sqlcode then
            call cl_err("scbmp600_ins5_cur",sqlca.sqlcode,1)
            exit foreach
        end if
        call s_cbmp600_error(sfmt("工艺料号%1，在BOM中无对应结构",l_ecu01),"MI","error",g_ecu02)
    end foreach

    # 得到来源item和version

    select tc_exp02,tc_exp03 into g_ecu01_o,g_ecu02_o from tc_exp_file
     where tc_exp01 = p_uuid
    if sqlca.sqlcode or cl_null(g_ecu01_o) or cl_null(g_ecu02_o) then
        call s_cbmp600_error(sfmt("未找到复制来源料号与版本，工时，IPQC栏位无法复制",l_ecu01),"MI","warn",g_ecu02)
    end if

    if g_ecu01_o != g_ecu01 then
        let g_ecn = 'Y' -- BOM变更
    end if

    #开始遍历
    declare scbmp600_ins2_cur cursor for
        select bmb01,bmb03,ima02,ima021,bmb06,bmbud01,bmbud02,bmbud05,bmbud06,bmbuuid
        from fastbom_file where bmbuuid = ? and bmb01 = ?

    # 检查是否有下阶料
    prepare scbmp600_ins3_p from "select count(*) from fastbom_file where bmbuuid = ? and bmb01 = ?"
    # 检查mi是否含有对应mi资料
    prepare scbmp600_ins4_p from "select count(*) from fastmi_file where ecbuuid = ? and ecb01 = ?"
    # mi资料已存在并已审核或发放
    prepare scbmp600_ins6_p from "select count(*) from ecu_file where ecu01 =? and ecu02 =? and (ecu10 ='Y' or ecuud02='Y')"
    # 将某个料号新增到scbmp600_ecb
    prepare scbmp600_ins7_p from "insert into scbmp600_ecb (
                                        ecb01,ecb02,
                                        ecb03,ecb06,ecbud04,ecbud03,ecbud02,ecbud17,
                                        ecbud06,ecb04,ecb39,ecb41,ecb45,ecb46,ecb51,ecb14,ecb52,ecb53,ecb012,ecb66,
                                        ecb40,ecb19,ecb21,
                                        ecb08,ecb17
                                        ,uuid
                                    )select ecb01,ecb02,
                                    ecb03,ecb06,ecbud04,ecbud03,ecbud02,ecbud17,
                                    'N' ecbud06,0 ecb04,'N' ecb39,'N' ecb41,'PCS' ecb45,1 ecb46,1 ecb51,
                                    0 ecb14,0 ecb52,1 ecb53,' ' ecb012,'Y' ecb66,
                                    ecb40,ecb19,ecb21,
                                    ecd07 ecb08, ecd02 ecb17,?
                                    from fastmi_file
                                    left join ecd_file on ecd01 = ecb06
                                    left join (select ecb01 ta_ecb01,ecb06 ta_ecb06,ecb02 ta_ecb02,ecb40,ecb19,ecb21 from ecb_file)
                                           on ta_ecb01 =ecb01 and ta_ecb02 = ecb02 and ta_ecb06 = ecb06
                                    where ecbuuid = ? and ecb01 = ? and ecb02 = ? "

    # 新增BOM直接新增到scbmp600_ecb
    prepare scbmp600_ins8_p from
        "insert into scbmp600_bmb(
            bmb01,bmb03,bmbud02,bmbud05,bmbud06,bmb06,bmbud01,
            bmb16,bmb07,bmb14,bmb04,bmb08,bmb081,bmb082,bmb31,bmb29,bmb23,
            bmb17,bmb18,bmb28,bmb33,bmbcomm,
            bmb15,bmb10,
            bmb02,
            uuid
        )select bmb01,bmb03,bmbud02,bmbud05,bmbud06,bmb06,bmbud01,
            0 bmb16,1 bmb07,0 bmb14,trunc(sysdate) bmb04,0 bmb08,0 bmb081,0 bmb082,'N' bmb31,' ' bmb29,100 bmb23,
            'N' bmb17,'0' bmb18, 0 bmb28, 0 bmb33,'cbmp600' bmbcomm,
            ima70 bmb15,ima63,
            rownum*10 bmb02,
            ?
            from fastbom_file left join ima_file on ima01 = bmb03
            where bmbuuid = ? and bmb01 = ?"
    # 处理工单展开
    prepare scbmp600_ins9_p from
        "update scbmp600_bmb set bmb19 = '2'
          where uuid = ?  and bmb03 in (select bmb01 from bmb_file where uuid = ?)"
    # TODO话要处理 bmb10_fac,bmb10_fac2

    # 检查bma状态
    prepare scbmp600_ins10_p from
        "select bma10 from bma_file where bma01 = ? "

    # 查看scbmp600_bmb某一主料的资料内容
    prepare scbmp600_ins11_p from
        "select * from scbmp600_bmb where uuid = ? and bmb01 = ?  "
    declare scbmp600_ins11_cur cursor for scbmp600_ins11_p

    call s_cbmp600_bmb(g_ecu01)

    let l_i = 1
    call l_fastbom.clear()
    foreach scbmp600_ins2_cur using g_uuid,g_ecu01 into l_fastbom[l_i].*--sr.*
        if sqlca.sqlcode then
            call cl_err("scbmp600_ins2_cur",sqlca.sqlcode,1)
            exit foreach
        end if
        let l_i = l_i + 1
    end foreach

    for l_i = 1 to l_fastbom.getlength()-1
        let l_cnt = 0
        execute scbmp600_ins3_p using g_uuid,l_fastbom[l_i].bmb03 into l_cnt
        if l_cnt > 0 then
            call s_cbmp600_retrieve(l_fastbom[l_i].bmb03)
        end if
    end for

    # 更新工单展开选项
    execute scbmp600_ins9_p using g_uuid,g_uuid
    if sqlca.sqlcode then
        call cl_err("scbmp600_ins9_p",sqlca.sqlcode,1)
        call s_cbmp600_error(sfmt("更新工单展开选项失败",g_ecu01),"BOM","error","")
        return
    end if
# 4开始处理
# 4.1bom新增
# 4.2bom变更
# 4.3mi新增
# 4.4mi覆盖
end function

# BOM处理
function s_cbmp600_bmb(p_bmb01)
    define p_bmb01  like bmb_file.bmb01
    define l_cnt integer
    define l_bma10  like bma_file.bma10

    # 2.1bom半成品是否都有对应的mi e
    let l_cnt = 0
    execute scbmp600_ins4_p using g_uuid,p_bmb01 into l_cnt
    if l_cnt = 0 then
        call s_cbmp600_error(sfmt("料号为半成品或辅料：%1，但未找到对应工艺资料",p_bmb01),"BOM","error","")
    else
        # 工艺资料处理
        call s_cbmp600_mi(p_bmb01)
    end if

    # BMB是否已经存在
    # 新增情况下
        # 变更warn
        # 新增info
    # 变更情况下
        # 新增warn
        # 变更info

    # 判断bom状态
    let l_bma10 = ''
    execute scbmp600_ins10_p using p_bmb01 into l_bma10
    if sqlca.sqlcode or cl_null(l_bma10) then
        # 不存在bma
        let l_bma10 = '3'
    end if
    # 0,3 可以覆盖
    # 2 只能变更
    # 1 的时候什么都不能做

    if l_bma10 = '1' then
        call s_cbmp600_error(sfmt("料号%1为审核状态，不能做覆盖或者变更，请处理后再做导入",p_bmb01),"BOM","error","")
        return
    end if

    # BOM资料变更
    if g_ecn = 'Y' then
        # BOM变更要单独处理，产生ECN变更单
        if l_bma10 = '0' or l_bma10 = '3' then
            call s_cbmp600_error(sfmt("料号%1不存在bom或者还未审核，会新增或覆盖",p_bmb01),"BOM","warn","")
            call s_cbmp600_insOrReplace(p_bmb01)
        else
            call s_cbmp600_error(sfmt("BOM变更，料件：%1",p_bmb01),"BOM","info","")
            call s_cbmp600_ecn(p_bmb01)
        end if
    else
    # BOM资料新增
        if l_bma10 = '0' or l_bma10 = '3' then
            call s_cbmp600_error(sfmt("新增或覆盖料号bom：%1",p_bmb01),"BOM","info","")
            call s_cbmp600_insOrReplace(p_bmb01)
        else
            call s_cbmp600_error(sfmt("料号%1，已经存在发放资料，将会变更",p_bmb01),"BOM","warn","")
            call s_cbmp600_ecn(p_bmb01)
        end if
    end if

end function

# aeci100处理
function s_cbmp600_mi(p_ecu01)
    define p_ecu01 like ecu_file.ecu01
    define l_cnt integer

# 2.2mi是否有对应的bom e
# 2.3mi版本是否相同
    let l_cnt = 0
    execute scbmp600_ins4_p using g_uuid,p_ecu01 into l_cnt
    if l_cnt = 0 then
        call s_cbmp600_error(sfmt("BOM料件%1，无对应的工艺资料",p_ecu01),"MI","error",g_ecu02)
        return
    end if

    # mi资料已存在并已审核或发放
    let l_cnt = 0
    execute scbmp600_ins6_p using p_ecu01,g_ecu02 into l_cnt
    if l_cnt > 0 then
        call s_cbmp600_error(sfmt("料件%1，存在已审核MI资料",p_ecu01),"MI","error",g_ecu02)
    end if

    # 新增MI资料到scbmp600_ecb
    execute scbmp600_ins7_p using g_uuid,g_uuid,p_ecu01,g_ecu02
    if sqlca.sqlcode then
        call cl_err("scbmp600_ins7_p",sqlca.sqlcode,1)
        call s_cbmp600_error(sfmt("料件%1，生成MI资料失败",p_ecu01),"MI","error",g_ecu02)
        return
    end if

    # TODO 做MI检查

end function

function s_cbmp600_error(p_msg,p_type,p_level,p_ecu02)
    define p_msg,p_type  like type_file.chr1000
    define p_ecu02 like bmb_file.bmb03
    define p_level varchar(10)

    let g_err_index = g_err_index + 1
    if p_type = 'error' then
        let g_cnt.error = g_cnt.error + 1
    end if
    if p_type = 'warn' then
        let g_cnt.warn = g_cnt.warn + 1
    end if
    if p_type = 'info' then
        let g_cnt.info = g_cnt.info + 1
    end if

    let g_error[g_err_index].err01 = g_uuid
    let g_error[g_err_index].err02 = g_err_index
    let g_error[g_err_index].err03 = g_ecu01
    let g_error[g_err_index].err04 = p_ecu02
    let g_error[g_err_index].err05 = p_type
    let g_error[g_err_index].err06 = p_level
    let g_error[g_err_index].err07 = p_msg
    let g_error[g_err_index].err08 = 0
end function

function s_cbmp600_retrieve(p_bmb01)
    define p_bmb01  like bmb_file.bmb01
    define sr fast_bom
    define l_fastbom dynamic array of fast_bom
    define l_cnt,l_i integer

    call s_cbmp600_bmb(p_bmb01)

    let l_i = 1
    call l_fastbom.clear()
    foreach scbmp600_ins2_cur using g_uuid,p_bmb01 into l_fastbom[l_i].*--sr.*
        if sqlca.sqlcode then
            call cl_err("scbmp600_ins2_cur",sqlca.sqlcode,1)
            exit foreach
        end if
        let l_i = l_i + 1
    end foreach

    for l_i = 1 to l_fastbom.getlength()-1
        let l_cnt = 0
        execute scbmp600_ins3_p using g_uuid,l_fastbom[l_i].bmb03 into l_cnt
        if l_cnt > 0 then
            call s_cbmp600_retrieve(l_fastbom[l_i].bmb03)
        end if
    end for
end function


# bom变更 scbmp600_bmy
function s_cbmp600_ecn(p_bmb01)
    define p_bmb01  like bmb_file.bmb01
    define l_bmb    dynamic array of record like bmb_file.*
    define l_cnt integer

    # 先增加到scbmp600_bmb,方便后面比较
    execute scbmp600_ins8_p using g_uuid,g_uuid,p_bmb01
    if sqlca.sqlcode then
        call cl_err("scbmp600_ins8_p",sqlca.sqlcode,1)
        call s_cbmp600_error(sfmt("BOM变更失败，%1",g_ecu01),"BOM","error","")
        return
    end if
    update scbmp600_bmb set bmb02 = -1
     where uuid = g_uuid and bmb01 = p_bmb01

    select ima08 into g_ima08_h from ima_file where ima01 = p_bmb01

    initialize g_bmb.* to null
    call l_bmb.clear()
    let l_cnt = 1
    foreach scbmp600_ins11_cur using g_uuid,p_bmb01 into g_uuid,l_bmb[l_cnt].*
        if sqlca.sqlcode then
            call cl_err("scbmp600_ins11_cur",sqlca.sqlcode,1)
            call s_cbmp600_error(sfmt("主件料号:%1,迭代时出现错误",p_bmb01),"BOM","error","")
            exit foreach
        end if
        let l_cnt = l_cnt + 1
    end foreach
    call l_bmb.deleteElement(l_cnt)
    let l_cnt = l_cnt - 1

    for l_cnt = 1 to l_bmb.getlength()

        let g_bmb.* = l_bmb[l_cnt].*
        if not s_cbmp600_verify_bmb() then
            continue for
        end if
        initialize g_bmy.* to null

        call s_cbmp600_def_bmb() returning g_bmy.bmy03
        if g_bmy.bmy03 = '0' then
            continue for
        end if
        # g_bmb是修改后的资料
        if s_cbmp600_def_bmy() then
            continue for
        end if
    end for
    # 比较之后删除资料
    delete from scbmp600_bmb where uuid = g_uuid and bmb01 = p_bmb01
    if sqlca.sqlcode then
        call cl_err("del scbmp600_bmb",sqlca.sqlcode,1)
        return
    end if
end function

# bmb资料差异比较
# 返回差异类型bmy 1.新增 2.失效 3.修改 9.报错
# 参考aws_diff_bmb_new
function s_cbmp600_def_bmb()
    define l_bmb      record like bmb_file.*
    define l_cnt      like type_file.num10
    define l_bmb02    like bmb_file.bmb02

    # 和 g_bmb 作比较
    let l_cnt = 0
    select count(*) into l_cnt
      from bmb_file
     where bmb01 = g_bmb.bmb01
       and bmb03 = g_bmb.bmb03
       # 还要保证没有料件匹配过
       and bmb02 not in (select bmb02 from scbmp600_bmb where uuid = g_uuid and bmb01 = g_bmb.bmb01 )

    if l_cnt = 0 then
        return '2' #新元件新增生效
    else
        let l_bmb02 = 0
        if l_cnt > 1 then
        # 如果有多笔，还要判断一下bmbud02
            select bmb02 into l_bmb02
              from bmb_file
             where bmb01 = g_bmb.bmb01
               and bmb03 = g_bmb.bmb03
               # 还要保证没有料件匹配过
               and bmb02 not in (select bmb02 from scbmp600_bmb where uuid = g_uuid and bmb01 = g_bmb.bmb01 )
               and bmbud02 = g_bmb.bmbud02
        end if
        if l_bmb02 = 0 or l_cnt = 1 then
            # 否则要么变更，要么不变，都要更新bmb02
            select bmb02 into l_bmb02
              from bmb_file
             where bmb01 = g_bmb.bmb01
               and bmb03 = g_bmb.bmb03
               # 还要保证没有料件匹配过
               and bmb02 not in (select bmb02 from scbmp600_bmb where uuid = g_uuid and bmb01 = g_bmb.bmb01 )
        end if
        update scbmp600_bmb
           set bmb02 = l_bmb02
         where bmb01 = g_bmb.bmb01
           and bmb03 = g_bmb.bmb03
           and bmbud02 =  g_bmb.bmbud02
    end if

    # => 进行判断
    initialize l_bmb.* to null
    select * into l_bmb.*
      from bmb_file
     where bmb01 = g_bmb.bmb01
       and bmb02 = l_bmb02
       and bmb03 = g_bmb.bmb03
       and bmb29 = g_bmb.bmb29
       and (bmb05 > g_today or bmb05 is null)

    #=>(bmb09)作業編號
    # 不做比较，因为MI审核自动更新
    #=>(bmbud02)
    if not cl_null(g_bmb.bmbud02) then
        if not cl_null(l_bmb.bmbud02) then
            if g_bmb.bmbud02 <> l_bmb.bmbud02 then
                return '3' #舊元件修改
            end if
        else
            return '3' #舊元件修改
        end if
    else
        call s_cbmp600_error(sfmt("主件料号：%1，元件料号：%2 工艺发料编号为空",g_bmb.bmb01,g_bmb.bmb03),"BOM","error",g_bmb.bmb03)
        return '4'
    end if

    if  g_bmb.bmb06 <> l_bmb.bmb06 or
        g_bmb.bmb07 <> l_bmb.bmb07 or
        g_bmb.bmb10 <> l_bmb.bmb10 or
        g_bmb.bmb19 <> l_bmb.bmb19 or
        g_bmb.bmb15 <> l_bmb.bmb15 or
        g_bmb.bmbud01 <> l_bmb.bmbud01 or
        g_bmb.bmbud05 <> l_bmb.bmbud05 or
        g_bmb.bmbud06 <> l_bmb.bmbud06 or
        g_bmb.bmb31 <> l_bmb.bmb31 then
        return '3' #舊元件修改
    else
        return '0' #無異動
    end if
end function

# bmy 单身资料写入
function s_cbmp600_def_bmy()
    define l_cnt    integer
    define  l_ima25     like ima_file.ima25,
            l_ima86     like ima_file.ima86,
            l_ima110    like ima_file.ima110
    define l_bmb    record like bmb_file.*
    define l_ima    record like ima_file.*
    define l_sw varchar(1)

    let g_bmy.bmy05 = g_bmb.bmb03 #元件編號
    let g_bmy.bmy14 = g_bmb.bmb01 #主件編號
    let g_bmy.bmy29 = g_bmb.bmb29

    if g_bmy.bmy03 = '2' then
        let g_bmy.bmy16 = '0'
    else
        if g_bmb.bmb16 is not null then
            let g_bmy.bmy16 = g_bmb.bmb16
        end if
    end if
    #=>變異別(bmy03)
    if g_bmy.bmy03 not matches '[12345]'then
        call s_cbmp600_error(
            sfmt("主件:%1 元件:%2 异动码错误:%3 ",
                 g_bmb.bmb01,g_bmb.bmb03,g_bmy.bmy03),
            "BOM","error","")
        # let g_status.code = "aws-385"   #變異別不正確!
        return false
    end if

    if not cl_null(g_bmy.bmy14) then
        if not cl_null(g_bmy.bmy05) then #元件編號
            if g_bmy.bmy03 matches '[1345]' then #變異碼
                let l_cnt = 0
                if not cl_null(g_bmy.bmy04) then #產品結構項次
                    select count(*) into l_cnt from bmb_file
                    where bmb01 = g_bmy.bmy14
                    and bmb02 = g_bmy.bmy04
                    and bmb03 = g_bmy.bmy05
                    and (bmb04 <= g_bmx.bmx07 or bmb04 is null)
                    and (bmb05 >  g_bmx.bmx07 or bmb05 is null)
                else
                    select count(*) into l_cnt from bmb_file
                    where bmb01 = g_bmy.bmy14
                    and bmb03 = g_bmy.bmy05
                    and (bmb04 <= g_bmx.bmx07 or bmb04 is null)
                    and (bmb05 >  g_bmx.bmx07 or bmb05 is null)
                end if
                if l_cnt = 0 then
                    call s_cbmp600_error(
                        sfmt("主件:%1 元件:%2 产品结构单身档无此元件料号",
                            g_bmb.bmb01,g_bmb.bmb03),
                        "BOM","error","")
                    # let g_status.code = "mfg2631"   #產品結構單身檔無此元件編號
                    return false
                end if
            end if
        end if
        # call aws_plm_ima01_chk(g_bmy.bmy14,'3')
        # if not cl_null(g_errno) then
        #     let g_status.code = g_errno
        #     return false
        # else
            select ima05 into g_bmy.bmy171 from ima_file
                where ima01 = g_bmy.bmy14
        # end if
        let l_cnt = 0
        select count(*) into l_cnt from bma_file
            where bma01 = g_bmy.bmy14
            and (bma05 is null or bma05 >g_bmx.bmx07)
            and bma06 = g_bmy.bmy29
        if l_cnt> 0 then
            call s_cbmp600_error(
                    sfmt("主件:%1 元件:%2 有效日期不可小于发放日期,或此bom发放日期为空",
                        g_bmb.bmb01,g_bmb.bmb03),
                    "BOM","error","")
            # let g_status.code = "abm-005" #有效日期不可小於發放日期,或此bom的發放日期為空白,請查核..!
            return false
        end if
        let l_cnt = 0
        select count(*) into l_cnt from bma_file
        where bma01=g_bmy.bmy14
            and bmaacti='Y'
            and bma06=g_bmy.bmy29
        if l_cnt =0 then
            call s_cbmp600_error(
                sfmt("主件:%1 元件:%2 有效日期不可小于发放日期,或此bom发放日期为空",
                    g_bmb.bmb01,g_bmb.bmb03),
                "BOM","error","")
            # let g_status.code = "abm-742" #無此產品結構資料!
            return false
        end if
        if g_bmy.bmy03 = '2' then #變異碼:2: 新元件新增生效
            if not cl_null(g_bmy.bmy04) then #產品結構項次
                let l_cnt=0
                select count(*) into l_cnt from bmb_file
                    where bmb01 = g_bmy.bmy14
                    and bmb02 = g_bmy.bmy04
                    and bmb29 = g_bmy.bmy29
                    and (bmb04 <= g_bmx.bmx07 or bmb04 is null)
                    and (bmb05 >  g_bmx.bmx07 or bmb05 is null)
                if l_cnt> 0 then
                    call s_cbmp600_error(
                        sfmt("主件:%1 元件:%2 已存在产品结构中",
                            g_bmb.bmb01,g_bmb.bmb03),
                        "BOM","error","")
                    # let g_status.code = "mfg-015" #該主件料號+項次已存在產品結構中, 請重新輸入!
                    return false
                end if
                end if
        end if
        let l_cnt=0
        select count(*) into l_cnt from bma_file
            where bma01  = g_bmy.bmy14
        if l_cnt = 0 then
            call s_cbmp600_error(
                sfmt("主件:%1 欲更新资料主件不存在产品结构主档的bma_file中",
                    g_bmy.bmy14),
                "BOM","error","")
            # let g_status.code = "abm-748" #欲更新的資料主件不存在產品結構主檔的bma_file中
            return false
        end if
    end if

    #=>元件編號(bmy05)
    if not cl_null(g_bmy.bmy05) then
        # call aws_ima01_chk(g_bmy.bmy05,'1')
        # if not cl_null(g_errno) then
        #     let g_status.code = g_errno
        #     return false
        # end if
        if g_bmy.bmy03 != '1' then
            let l_cnt = 0
            if g_bmy.bmy05 = g_bmy.bmy14 then
                call s_cbmp600_error(
                    sfmt("主件:%1 元件:%2 两个料号不能相同",
                        g_bmy.bmy14),
                    "BOM","error","")
                # let g_status.code = "mfg2633" #元件料號不可與主件料號相同
                return false
            end if
        end if
        if g_bmy.bmy03 matches '[13]'  then
                select bmb31 into l_bmb.bmb31 from bmb_file
                where bmb01 = g_bmy.bmy14
                    and bmb03 = g_bmy.bmy05
                    and (bmb04 <= g_bmx.bmx07 or bmb04 is null)
                    and (bmb05 >  g_bmx.bmx07 or bmb05 is null)
                if cl_null(g_bmy.bmy34) then
                    let g_bmy.bmy34 = l_bmb.bmb31
                end if
        end if
        if g_bmy.bmy03 matches '[245]' then
            if cl_null(g_bmy.bmy34) then
                let g_bmy.bmy34 = 'N'
            end if
        end if
        if g_bmy.bmy03 matches '[1345]' then
            let l_cnt = 0
            if not cl_null(g_bmy.bmy04) then
                select count(*) into l_cnt from bmb_file
                    where bmb01 = g_bmy.bmy14
                    and bmb02 = g_bmy.bmy04
                    and bmb03 = g_bmy.bmy05
                    and (bmb04 <= g_bmx.bmx07 or bmb04 is null)
                    and (bmb05 >  g_bmx.bmx07 or bmb05 is null)
            else
                select count(*) into l_cnt from bmb_file
                    where bmb01 = g_bmy.bmy14
                    and bmb03 = g_bmy.bmy05
                    and (bmb04 <= g_bmx.bmx07 or bmb04 is null)
                    and (bmb05 >  g_bmx.bmx07 or bmb05 is null)
            end if
            if  l_cnt = 0 then
                call s_cbmp600_error(
                    sfmt("主件:%1 元件:%2 产品结构单身无此元件编号",
                        g_bmy.bmy14),
                    "BOM","error","")
                # let g_status.code = "mfg2631" #產品結構單身檔無此元件編號
                return false
            end if
        end if
        #default 底數、組成用量
        if g_bmy.bmy03 matches '[1345]' then
            if g_bmy.bmy03 matches '[134]' then
                if cl_null(g_bmy.bmy04) then
                    #select bmb06,bmb07,bmb16 into l_bmb.bmb06,l_bmb.bmb07,l_bmb.bmb16 from bmb_file #tqc-c80022 mark
                    select bmb06,bmb07,bmb16,bmb14,bmb30 into l_bmb.bmb06,l_bmb.bmb07,l_bmb.bmb16,l_bmb.bmb14 from bmb_file #tqc-c80022 add
                        where bmb01 = g_bmy.bmy14
                        and bmb03 = g_bmy.bmy05
                        and bmb04 = (select max(bmb04) from bmb_file
                                        where bmb01 = g_bmy.bmy14
                                        and bmb03 = g_bmy.bmy05)
                        and (bmb04 <= g_bmx.bmx07 or bmb04 is null)
                        and (bmb05 >  g_bmx.bmx07 or bmb05 is null)
                else
                    #select bmb06,bmb07,bmb16 into l_bmb.bmb06,l_bmb.bmb07,l_bmb.bmb16 from bmb_file #tqc-c80022 mark
                    select bmb06,bmb07,bmb16,bmb14,bmb30 into l_bmb.bmb06,l_bmb.bmb07,l_bmb.bmb16,l_bmb.bmb14 from bmb_file #tqc-c80022 add
                        where bmb01 = g_bmy.bmy14
                        and bmb03 = g_bmy.bmy05
                        and bmb02 = g_bmy.bmy04
                        and (bmb04 <= g_bmx.bmx07 or bmb04 is null)
                        and (bmb05 >  g_bmx.bmx07 or bmb05 is null)
                end if
                if cl_null(g_bmy.bmy06) then
                    let g_bmy.bmy06 = l_bmb.bmb06
                end if
                if cl_null(g_bmy.bmy07) then
                    let g_bmy.bmy07 = l_bmb.bmb07
                end if
                if g_bmy.bmy03 matches '[13]' then
                    if cl_null(g_bmy.bmy16) then
                        let g_bmy.bmy16 = l_bmb.bmb16
                    end if
                end if   #chi-960004
            else
                if cl_null(g_bmy.bmy06) then
                    let g_bmy.bmy06 = 1
                end if
                if cl_null(g_bmy.bmy07) then
                    let g_bmy.bmy07 = 1
                end if
            end if
        else
            if cl_null(g_bmy.bmy06) then
                let g_bmy.bmy06 = 1
            end if
        end if
    end if

    if g_bmy.bmy03 matches '[134]' then
        let g_bmy.bmy35 = l_bmb.bmb14
    end if

    if g_bmb.bmb19 is not null then
        let g_bmy.bmy20 = g_bmb.bmb19
    end if
    #工單開立展開選項(bmy20)
    if not cl_null(g_bmy.bmy20) then
        if g_bmy.bmy20 not matches '[1234]' then
            call s_cbmp600_error(
                sfmt("主件:%1 元件:%2 工单开立选项:%3 不正确",
                    g_bmb.bmb01,g_bmb.bmb03,g_bmy.bmy20),
                "BOM","error","")
            # let g_status.code = "aws-390" #工單開立選項不正確!
            return false
        end if
    end if
    if g_bmb.bmb15 is not null then
        let g_bmy.bmy15 = g_bmb.bmb15
        let g_bmy.bmy21 = g_bmb.bmb15
    end if
    if g_bmb.bmb28 is not null then let g_bmy.bmy23 = g_bmb.bmb28 end if
    if g_bmb.bmb31 is not null then let g_bmy.bmy34 = g_bmb.bmb31 end if
    if g_bmb.bmb06 is not null then let g_bmy.bmy06 = g_bmb.bmb06 end if
    #=>組成用量(bmy06)
    if not cl_null(g_bmy.bmy06) then
        if g_bmy.bmy06 <= 0 then
            call s_cbmp600_error(
                sfmt("主件:%1 元件:%2 组成用量:%3 不得小于零",
                    g_bmb.bmb01,g_bmb.bmb03,g_bmy.bmy06),
                "BOM","error","")
            return false
        end if
    end if
    if g_bmb.bmb07 is not null then let g_bmy.bmy07 = g_bmb.bmb07 end if
    #=>底數(bmy07)
    if not cl_null(g_bmy.bmy07) then
        if g_bmy.bmy07 <= 0 then
            call s_cbmp600_error(
                sfmt("主件:%1 元件:%2 底数:%3 不得小于零",
                    g_bmb.bmb01,g_bmb.bmb03,g_bmy.bmy07),
                    "BOM","error","")
            # let g_status.code = "mfg2615"   #主件底數不可小於等於零
            return false
        end if
    end if
    if g_bmb.bmb08 is not null then let g_bmy.bmy08 = g_bmb.bmb08 end if
    if g_bmb.bmb10 is not null then let g_bmy.bmy10 = g_bmb.bmb10 end if
    if g_bmb.bmb13 is not null then let g_bmy.bmy13 = g_bmb.bmb13 end if
    if g_bmb.bmb18 is not null then let g_bmy.bmy18 = g_bmb.bmb18 end if
    if g_bmb.bmb30 is not null then let g_bmy.bmy30 = g_bmb.bmb30 end if
    if g_bmb.bmb33 is not null then let g_bmy.bmy33 = g_bmb.bmb33 end if
    if g_bmb.bmb36 is not null then let g_bmy.bmy361 = g_bmb.bmb36 end if
    if g_bmb.bmb37 is not null then let g_bmy.bmy37 = g_bmb.bmb37 end if

    select ima25,ima86,ima110 into l_ima25,l_ima86,l_ima110 from ima_file
    where ima01=g_bmy.bmy05
    if g_bmy.bmy03 = '2' then #新增
        if cl_null(g_bmy.bmy20) then
            let g_bmy.bmy20 = l_ima.ima110
        end if
    end if

    let g_bmy.bmy29 = g_bmb.bmb29
    if cl_null(g_bmy.bmy33) then let g_bmy.bmy33 = '0' end if

    if g_bmy.bmy03 matches '[2345]' and cl_null(g_bmy.bmy10) then
        initialize l_bmb.* to null
        if not cl_null(g_bmy.bmy04) then
            select * into l_bmb.* from bmb_file
                where bmb01 = g_bmy.bmy14
                and bmb02 = g_bmy.bmy04
        else
            select * into l_bmb.* from bmb_file
                where bmb01 = g_bmy.bmy14
                and bmb03 = g_bmy.bmy05
                and bmb29 = g_bmy.bmy29
                and (bmb05 > g_today or bmb05 is null)
        end if
        if cl_null(g_bmy.bmy18) then #投料時距
            if not cl_null(l_bmb.bmb18) then
                let g_bmy.bmy18 = l_bmb.bmb18
            else
                let g_bmy.bmy18 = 0
            end if
        end if
        if cl_null(g_bmy.bmy08) then #損耗率
            if not cl_null(l_bmb.bmb08) then
                let g_bmy.bmy08 = l_bmb.bmb08
            else
                let g_bmy.bmy08 = 0
            end if
        end if
        if cl_null(g_bmy.bmy09) then #作業編號
            if not cl_null(l_bmb.bmb09) then
                let g_bmy.bmy09 = l_bmb.bmb09
            else
                let g_bmy.bmy09 = ' '
            end if
        end if
        initialize l_ima.* to null
        select ima63      ,ima63_fac      ,ima25
            into l_ima.ima63    ,l_ima.ima63_fac    ,l_ima.ima25
            from ima_file
            where ima01 = g_bmy.bmy05
        if cl_null(g_bmy.bmy10) then
            let g_bmy.bmy10 = l_ima.ima63
        end if
        call s_umfchk(g_bmy.bmy05,g_bmy.bmy10,l_ima.ima25)
                returning l_sw,l_ima.ima63_fac  #發料/庫存單位
        if l_sw then
            let l_ima.ima63_fac = 1
        end if
        if cl_null(g_bmy.bmy10_fac) then
            let g_bmy.bmy10_fac = l_ima.ima63_fac
        end if
        if cl_null(g_bmy.bmy20) then
            let g_bmy.bmy20 = l_bmb.bmb19
        end if
    end if
    if g_bmy.bmy03 matches '[245]' then
        initialize l_ima.* to null
        select ima04,ima136,ima137,ima70,ima562
            into l_ima.ima04,l_ima.ima136,l_ima.ima137,l_ima.ima70,l_ima.ima562
            from ima_file
        where ima01=l_item
        if cl_null(g_bmy.bmy11) then
            let g_bmy.bmy11 = l_ima.ima04
        end if
        if cl_null(g_bmy.bmy25) then
            let g_bmy.bmy25 = l_ima.ima136
        end if
        #fun-b70076---add----str----
        if not cl_null(g_bmy.bmy25) then
            if not s_chk_ware(g_bmy.bmy25) then  #检查仓库是否属于当前门店
                let g_bmy.bmy25 = ''
            end if
        end if
        #fun-b70076---add----end----
        if cl_null(g_bmy.bmy26) then
            let g_bmy.bmy26 = l_ima.ima137
        end if
        if cl_null(g_bmy.bmy21) then
            let g_bmy.bmy21 = l_ima.ima70
            if cl_null(g_bmy.bmy21) then #元件消耗特性
                let g_bmy.bmy21 = 'N'
            end if
        end if
        if cl_null(g_bmy.bmy23) then
            let g_bmy.bmy23 = 0
        end if
    end if
    let g_bmy.bmy33 = '0'        #fun-b70076 add
    let g_bmy.bmyplant = g_plant #fun-b70076 add
    let g_bmy.bmylegal = g_legal #fun-b70076 add
    if cl_null(g_bmy.bmy081) then
        let g_bmy.bmy081 = 0
    end if
    if cl_null(g_bmy.bmy082) then
        let g_bmy.bmy082 = 1
    end if

    if g_bmy.bmy03 = '1' then #新增
        if cl_null(g_bmy.bmy07) then let g_bmy.bmy07 = 1 end if           #底數
        if cl_null(g_bmy.bmy35) then let g_bmy.bmy35 = '0' end if         #元件使用特性
        if cl_null(g_bmy.bmy18) then let g_bmy.bmy18 = 0 end if           #投料時距
        if cl_null(g_bmy.bmy10_fac) then let g_bmy.bmy10_fac = 1 end if   #發料/料件庫存單位換算率
    end if
    if g_bmy.bmy03 = '2' then
        if cl_null(g_bmy.bmy07) then let g_bmy.bmy07 = 1 end if           #底數
        if cl_null(g_bmy.bmy08) then let g_bmy.bmy08 = 0   end if         #損耗率
        if cl_null(g_bmy.bmy10_fac) then let g_bmy.bmy10_fac = 1 end if   #發料/料件庫存單位換算率
        if cl_null(g_bmy.bmy18) then let g_bmy.bmy18 = 0 end if           #投料時距
        if cl_null(g_bmy.bmy20) then
            initialize l_ima.* to null
            select ima25,ima86,ima110
                into l_ima.ima25,l_ima.ima86,l_ima.ima110
                from ima_file
            where ima01=g_bmy.bmy05
            let g_bmy.bmy20 = l_ima.ima110
            if cl_null(g_bmy.bmy20) then
                let g_bmy.bmy20 = '1' #工單開立展開選項 #1.不展開
            end if
        end if
        if cl_null(g_bmy.bmy35) then let g_bmy.bmy35 = '0' end if         #元件使用特性
    end if

    let g_bmy.bmy09 = g_bmb.bmb09
    let g_bmy.bmy11 = g_bmb.bmb11
    let g_bmy.bmy25 = g_bmb.bmb25
    let g_bmy.bmy26 = g_bmb.bmb26

    insert into scbmp600_bmy values (g_uuid,g_bmy.*)
    if sqlca.sqlcode or sqlca.sqlerrd[3] = 0 then
        call s_cbmp600_error(
            sfmt("主件:%1 元件:%2 %3",g_ecu01,g_bmy.bmy05,getze03("aws-551")),
            "BOM","error",g_bmy.bmy05
        )
        # let g_status.code = "aws-551"
        return false
    end if
    return true
end function

# 验证bmb资料是否合法
# g_bmb
# 返回true,false
function s_cbmp600_verify_bmb()
    define  l_imaacti    like ima_file.imaacti,
            l_ima140     like ima_file.ima140,
            l_ima1401    like ima_file.ima1401,
            l_ima151     like ima_file.ima151,
            l_ima63      like ima_file.ima63,
            l_ima86      like ima_file.ima86
    define  l_ima25      like ima_file.ima25
    define  l_sw         like type_file.chr10,
            l_bmb10_fac  like bmb_file.bmb10_fac,
            l_bmb10_fac2 like bmb_file.bmb10_fac2

    if cl_null(g_bmb.bmb02) then
        call s_cbmp600_error(
            sfmt("主件:%1 元件:%2 重要栏位:%3 不可以为空",g_bmb.bmb01,g_bmb.bmb03,"组合项次"),
            "BOM","error",g_bmb.bmb03)
        return false
    end if
    if cl_null(g_bmb.bmb03) then
        call s_cbmp600_error(
            sfmt("主件:%1 元件:%2 重要栏位:%3 不可以为空",g_bmb.bmb01,g_bmb.bmb03,"元件料号"),
            "BOM","error",g_bmb.bmb03)
        return false
    end if
    if cl_null(g_bmb.bmb04) then
        call s_cbmp600_error(
            sfmt("主件:%1 元件:%2 重要栏位:%3 不可以为空",g_bmb.bmb01,g_bmb.bmb03,"生效日期"),
            "BOM","error",g_bmb.bmb03)
        return false
    end if
    if cl_null(g_bmb.bmb01) then
        call s_cbmp600_error(
            sfmt("主件:%1 元件:%2 重要栏位:%3 不可以为空",g_bmb.bmb01,g_bmb.bmb03,"主件料号"),
            "BOM","error",g_bmb.bmb03)
        return false
    end if
    # TODO 需要检查一下同一个元件的位置是否相同，不允许相同 bmb03、bmbud02

    # 检查主件料号是否有效
    let l_imaacti = null
    select imaacti
      into l_imaacti
      from ima_file
     where ima01 = g_bmb.bmb01
    case
       when sqlca.sqlcode = 100
          call s_cbmp600_error(
                sfmt("主件:%1 无此主件料号",g_bmb.bmb01),
                "BOM","error",g_bmb.bmb03)
          return false
       when l_imaacti='N'
            call s_cbmp600_error(
                sfmt("主件:%1 此料号已无效",g_bmb.bmb01),
                "BOM","error",g_bmb.bmb03)
            return false
       when l_imaacti  matches '[PH]'
            call s_cbmp600_error(
                sfmt("主件:%1 此料号不是已审核状态",g_bmb.bmb01),
                "BOM","error",g_bmb.bmb03)
          return false
    end case

    # 检查元件料号是否有效
    select imaacti,ima08,ima140,ima1401,ima151,ima63,ima25,ima86
      into l_imaacti,g_ima08_b,l_ima140,l_ima1401,l_ima151,l_ima63,l_ima25,l_ima86
      from ima_file where ima01 = g_bmb.bmb03
    case
       when sqlca.sqlcode = 100
          call s_cbmp600_error(
                sfmt("主件:%1 元件:%2 无此元件料号",g_bmb.bmb01,g_bmb.bmb03),
                "BOM","error",g_bmb.bmb03)
          return false
       when l_imaacti='N'
            call s_cbmp600_error(
                sfmt("主件:%1 元件:%2 元件料号已无效",g_bmb.bmb01,g_bmb.bmb03),
                "BOM","error",g_bmb.bmb03)
            return false
       when l_imaacti  matches '[PH]'
            call s_cbmp600_error(
                sfmt("主件:%1 元件:%2 元件料件为不是已审核状态",g_bmb.bmb01,g_bmb.bmb03),
                "BOM","error",g_bmb.bmb03)
          return false
    end case
    if g_ima08_b ='Z' then
        call s_cbmp600_error(
                sfmt("主件:%1 元件:%2 元件为杂项料号,不能再BOM结构中",g_bmb.bmb01,g_bmb.bmb03),
                "BOM","error",g_bmb.bmb03)
        return false
    end if

    if l_ima140  ='Y' and l_ima1401 <= g_today then
        call s_cbmp600_error(
            sfmt("主件:%1 元件:%2 元件已停产",g_bmb.bmb01,g_bmb.bmb03),
            "BOM","error",g_bmb.bmb03)
    #    let g_status.code = 'aim-809'        #料件已phase out!
    #    let g_status.description = "bmb03:",g_bmb.bmb03  #tqc-c50229 add
       return false
    end if

    if s_bomchk(g_bmb.bmb01,g_bmb.bmb03,g_ima08_h,g_ima08_b) then
        call s_cbmp600_error(
            sfmt("主件:%1 元件:%2 %3",g_bmb.bmb01,g_bmb.bmb03,getze03(g_errno)),
            "BOM","error",g_bmb.bmb03)
    #    let g_status.code = g_errno
    #    let g_status.description = "bmb01:",g_bmb.bmb01,"+bmb03:",g_bmb.bmb03  #tqc-c50229 add
       return false
    end if

    if g_bmb.bmb05 < g_bmb.bmb04 then
        call s_cbmp600_error(
            sfmt("主件:%1 元件:%2 失效日期不得小于生效日期",g_bmb.bmb01,g_bmb.bmb03),
            "BOM","error",g_bmb.bmb03)
        # let g_status.code = "mfg2604"         #失效日期不可小於生效日期
        # let g_status.description = "bmb04:",g_bmb.bmb04,"+bmb05:",g_bmb.bmb05 #tqc-c50229 add
        return false
    end if

    #=>組成用量(bmb06)
    #組成用量不可小于零
    if not cl_null(g_bmb.bmb06) then
        if g_bmb.bmb14 <> '2' then
            if g_bmb.bmb06 <= 0 then
                call s_cbmp600_error(
                    sfmt("主件:%1 元件:%2 用量:%3 组成用量不得小于零",g_bmb.bmb01,g_bmb.bmb03,g_bmb.bmb06),
                    "BOM","error",g_bmb.bmb03)
                # let g_status.code = "mfg2614" #組成用量不可小於零
                # let g_status.description = "bmb06:",g_bmb.bmb06
                return false
            end if
        else
            if g_bmb.bmb06 >= 0 then
                call s_cbmp600_error(
                    sfmt("主件:%1 元件:%2 用量:%3 回收料时组成用量不得大于零",g_bmb.bmb01,g_bmb.bmb03,g_bmb.bmb06),
                    "BOM","error",g_bmb.bmb03)
                # let g_status.code = "asf-603" #當為回收料時,組成用量應<0
                # let g_status.description = "bmb06:",g_bmb.bmb06
                return false
            end if
        end if
    end if

    #=>底數(bmb07)
    if not cl_null(g_bmb.bmb07) then
        if g_bmb.bmb07 <= 0 then
            call s_cbmp600_error(
                sfmt("主件:%1 元件:%2 主件底数:%3 主件底数不可小于等于零",g_bmb.bmb01,g_bmb.bmb03,g_bmb.bmb07),
                "BOM","error",g_bmb.bmb03)
            # let g_status.code = "mfg2615"   #主件底數不可小於等於零
            # let g_status.description = "bmb07:",g_bmb.bmb07
            return false
        end if
    end if

    #=>替代特性(bmb16)
    if g_bmb.bmb16 not matches '[01245]' then
        call s_cbmp600_error(
            sfmt("主件:%1 元件:%2 取替代特性:%3 不正确",g_bmb.bmb01,g_bmb.bmb03,g_bmb.bmb16),
            "BOM","error",g_bmb.bmb03)
        # let g_status.code = "aws-386" #取替代特性不正確!
        # let g_status.description = "bmb16:",g_bmb.bmb16
        return false
    end if

    #=>損耗率(bmb08)
    if not cl_null(g_bmb.bmb08) then
        if g_bmb.bmb08 < 0 or g_bmb.bmb08 > 100 then
            call s_cbmp600_error(
                sfmt("主件:%1 元件:%2 损耗率:%3 应该再0到100之间",g_bmb.bmb01,g_bmb.bmb03,g_bmb.bmb08),
                "BOM","error",g_bmb.bmb03)
            # let g_status.code = "mfg4063" #本欄位之值不可小於零或大於 100, 請重新輸入
            # let g_status.description = "bmb08:",g_bmb.bmb08
            return false
        end if
    end if

    #=>倉庫(bmb25)
    if not cl_null(g_bmb.bmb25) then
        select * from imd_file
            where imd01 = g_bmb.bmb25
            and imdacti = 'Y'
        if sqlca.sqlcode then
            call s_cbmp600_error(
                sfmt("主件:%1 元件:%2 仓库:%3 不存在或无效",g_bmb.bmb01,g_bmb.bmb03,g_bmb.bmb25),
                "BOM","error",g_bmb.bmb03)
            # let g_status.code = "mfg1100" #無此倉庫或性質不符!
            # let g_status.description = "bmb25:",g_bmb.bmb25
            return false
        end if
    end if

    #=>存放位置(bmb26)
    if not cl_null(g_bmb.bmb25) and g_bmb.bmb26 is not null then
        select * from ime_file
            where ime01 = g_bmb.bmb25
            and ime02 = g_bmb.bmb26
            and imeacti = 'Y'      #fun-d40103
        if sqlca.sqlcode then
            call s_cbmp600_error(
                sfmt("主件:%1 元件:%2 仓库:%3 储位:%4 不存在或无效",g_bmb.bmb01,g_bmb.bmb03,g_bmb.bmb25,g_bmb.bmb26),
                "BOM","error",g_bmb.bmb03)
            # let g_status.code = "asm-020" #無此倉庫+儲位資料
            # let g_status.description = "bmb25:",g_bmb.bmb25,"+bmb26:",g_bmb.bmb26
            return false
        end if
    end if

    #=>發料單位(bmb10)
    if not cl_null(g_bmb.bmb10) then
        select * from gfe_file
            where gfe01 = g_bmb.bmb10
        if status then
            call s_cbmp600_error(
                sfmt("主件:%1 元件:%2 发料单位:%3 不存在",g_bmb.bmb01,g_bmb.bmb03,g_bmb.bmb10),
                "BOM","error",g_bmb.bmb03)
            # let g_status.code = "afa-319" #此單位不存在請重新輸入
            # let g_status.description = "bmb10:",g_bmb.bmb10
            return false
        end if
        let l_ima25=""
        let l_ima86=""
        select ima25,ima86 into l_ima25,l_ima86
            from ima_file
            where ima01 = g_bmb.bmb03
        if not cl_null(g_bmb.bmb10) and g_bmb.bmb10 <> l_ima25 then
            call s_umfchk(g_bmb.bmb03,g_bmb.bmb10,l_ima25)
                    returning l_sw,l_bmb10_fac  #發料/庫存單位
            if l_sw then
                call s_cbmp600_error(
                    sfmt("主件:%1 元件:%2 发料单位:%3 库存单位:%4 之间无转换率",
                        g_bmb.bmb01,g_bmb.bmb03,g_bmb.bmb10,l_ima25),
                    "BOM","error",g_bmb.bmb03)
                # let g_status.code = "mfg2721" #發料單位對庫存單位無轉換率
                # let g_status.description = "bmb10:",g_bmb.bmb10
                return false
            end if
        end if
        if not cl_null(g_bmb.bmb10) and g_bmb.bmb10 <> l_ima86 then
            call s_umfchk(g_bmb.bmb03,g_bmb.bmb10,l_ima86)
                    returning l_sw,l_bmb10_fac2
            if l_sw then
                call s_cbmp600_error(
                    sfmt("主件:%1 元件:%2 发料单位:%3 成本单位:%4 之间无转换率",
                        g_bmb.bmb01,g_bmb.bmb03,g_bmb.bmb10,l_ima86),
                    "BOM","error",g_bmb.bmb03)
                # let g_status.code = "mfg2722" #發料單位對成本單位無轉換率
                # let g_status.description = "bmb10:",g_bmb.bmb10
                return false
            end if
        end if
    end if
    return true
end function

# bom新增
function s_cbmp600_insOrReplace(p_bmb01)
    define p_bmb01  like bmb_file.bmb01

    # 不需要考虑是否已存在
    # 在差异报表中再去比较
    execute scbmp600_ins8_p using g_uuid,g_uuid,p_bmb01
    if sqlca.sqlcode then
        call cl_err("scbmp600_ins8_p",sqlca.sqlcode,1)
        call s_cbmp600_error(sfmt("BOM新增失败，%1",g_ecu01),"BOM","error","")
        return
    end if

end function

function getze03(p_ze01)
    define p_ze01 like ze_file.ze01,
           l_ze03 like ze_file.ze03
    select ze03 into l_ze03 from ze_file
     where ze01 = p_ze01 and ze02 = '2'
    return l_ze03
end function


-- 样品固定损耗设置
function scbmi600_sample(p_bmb01)
    define p_bmb01 like bmb_file.bmb01

    define l_sql    string
    define l_bmb01  like bmb_file.bmb01
    define l_bmb02  like bmb_file.bmb02
    define l_bmb03  like bmb_file.bmb03
    define l_ima06  like ima_file.ima06
    define l_tc_sma06 like tc_sma_file.tc_sma06
    define l_tc_sma07 like tc_sma_file.tc_sma07

    if p_bmb01[10,10] not matches '[SF]' then
        return
    end if

    let l_sql = "select bmb01,bmb02,bmb03 from bmb_file ",
                " where bmb01 = ? and bmb04 <= trunc(sysdate) ",
                "   and (bmb05 > trunc(sysdate) or bmb05 is null)",
                " order by bmb02"
    prepare sbmp600_sample_p from l_sql
    declare sbmp600_sample_cur cursor for sbmp600_sample_p

    foreach sbmp600_sample_cur using p_bmb01 into l_bmb01,l_bmb02,l_bmb03
        if sqlca.sqlcode then
            call cl_err("sbmp600_sample_p",sqlca.sqlcode,1)
            exit foreach
        end if
        -- 查询csmi115 是否由配置资料
        select ima06 into l_ima06 from ima_file where ima01 = l_bmb03

        select tc_sma06,tc_sma07 into l_tc_sma06,l_tc_sma07
          from tc_sma_file
         where tc_sma01 = 'csmi115' and tc_sma02 = l_ima06
        if sqlca.sqlcode then
            continue foreach
        end if

        -- 更新损耗
        update  bmb_file set bmb08 = l_tc_sma07,bmb081 = l_tc_sma06
         where bmb01 = l_bmb01 and bmb02 = l_bmb02 and bmb03 = l_bmb03
        if sqlca.sqlcode then
            call cl_err("update bmb_file",sqlca.sqlcode,1)
            exit foreach
        end if

    end foreach
end function
