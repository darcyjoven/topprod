# Prog. Version..: '5.00.01-07.05.10(00010)'     #
# Pattern name...: cs_rva_y.4gl
# Descriptions...: 收货单审核函数
# Date & Author..: 16/01/01  By  LGe
# Note           : 传入值:  rva01,user
# ...............: 返回值:  Y-成功; N-失败
#                           code: 0 成功    其他为错误代码
#                           msg:  错误信息  成功



DATABASE ds

GLOBALS "../../../tiptop/config/top.global"


FUNCTION cs_rva_y(p_rva01)
DEFINE p_rva01          LIKE rva_file.rva01
DEFINE l_ret            RECORD
              success   LIKE type_file.chr1,
              code      STRING,
              msg       STRING
                        END RECORD
DEFINE l_sql            STRING

    INITIALIZE l_ret TO NULL
    LET l_ret.success = 'Y'
    LET l_ret.code = '0'

    IF cl_null(p_rva01) THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "未传入收货单单号！无法审核！"
        RETURN l_ret.*
    END IF 

    UPDATE rva_file SET rvaconf = 'Y',
                        rvaconu=rvauser,
                        rvacond=g_today,
                        rvacont=g_time,
                        rva32 ='1'
     WHERE rva01 = p_rva01
    IF SQLCA.SQLCODE THEN 
        LET l_ret.success = 'N'
        LET l_ret.code = SQLCA.SQLCODE 
        LET l_ret.msg  = "rva_y() update rva_file error:",cl_getmsg(SQLCA.SQLCODE,g_lang)
        RETURN l_ret.*
    END IF 

    LET l_sql = " INSERT INTO tlf_file ",
                " SELECT rvb05,DECODE(rva10,'REG',11,'EXP',14,'CAP',16,'SUB',60),'",g_plant,"',' ',' ',' ',",
                "        NULL,NULL,decode(rva10,'SUB',rvb34,rvb04),rvb03,",
                "        decode(rva10,'SUB',25,20),'",g_plant,"',rvb36,rvb37,rvb38,NULL,NULL,",
                "        rvb01,rvb02,NULL,' ',rva06,rva06,'",g_time,"','",g_user,"',rvb07,",
                "        rvb90,rvb90_fac,decode(rva10,'SUB','asft6001','apmt1101'),' ',NULL,NULL,NULL,",
                "        (SELECT SUM(img10*img21) FROM img_file WHERE img01 = rvb05),",
                "        rva05,' ',NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,",
                "        NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,1,SUBSTR(rva01,1,4),rvb04,rvb03,",
                "        rvb25,NULL,NULL,imd09,rvb36,rvb37,rvb38,rvb01,rvb02,0,NULL,NULL,NULL,NULL,",
                "        rvb930,NULL,NULL,NULL,NULL,NULL,NULL,' ',NULL,NULL,NULL,NULL,NULL,NULL,",
                "        NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'",g_plant,"','",g_legal,"',",
                "        NULL,NULL,' ',0,NULL ",
                "   FROM rva_file,rvb_file,imd_file ",
                "  WHERE rva01 = rvb01 ",
                "    AND rvb36 = imd01 ",
                "    AND rva01 = '",p_rva01,"' ",
                "    AND SUBSTR(rvb05,1,4) <> 'MISC' "
    PREPARE p001_ins_tlf01 FROM l_sql
    EXECUTE p001_ins_tlf01
    IF SQLCA.SQLCODE THEN 
        LET l_ret.success = 'N'
        LET l_ret.code = SQLCA.SQLCODE 
        LET l_ret.msg  = "rva_y() insert tlf_file error:",cl_getmsg(SQLCA.SQLCODE,g_lang)
        RETURN l_ret.*
    END IF 

    LET l_sql = " INSERT INTO tlff_file ",
                " SELECT rvb05,DECODE(rva10,'REG',11,'EXP',14,'CAP',16,'SUB',60),'",g_plant,"',' ',' ',' ',",
                "        NULL,NULL,decode(rva10,'SUB',rvb34,rvb04),rvb03,decode(rva10,'SUB',25,20),'",g_plant,"',rvb36,rvb37,rvb38,NULL,NULL,",
                "        rvb01,rvb02,NULL,' ',rva06,rva06,'",g_time,"','",g_user,"',NVL(rvb85,rvb82),",
                "        NVL(rvb83,rvb80),1,decode(rva10,'SUB','asft6001','apmt1101'),' ',NULL,NULL,NULL,",
                "        (SELECT SUM(img10*img21) FROM img_file WHERE img01 = rvb05),",
                "        rva05,' ',NULL,NULL,NULL,0,0,0,0,0,0,0,0,1,imd_file.ROWID,NVL(rvb83,rvb80),",
                "        NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,1,SUBSTR(rva01,1,4),rvb04,rvb03,",
                "        rvb25,NULL,NULL,imd09,rvb36,rvb37,rvb38,rvb01,rvb02,0,NULL,NULL,NULL,NULL,",
                "        rvb930,NULL,'",g_plant,"','",g_legal,"',NULL,' ',0 ",
                "   FROM rva_file,rvb_file,ima_file,imd_file ",
                "  WHERE rva01 = rvb01 ",
                "    AND ima01 = rvb05 ",
                "    AND rvb36 = imd01 ",
                "    AND ima906 IN ('2','3') ",
                "    AND rva01 = '",p_rva01,"'",
                "    AND SUBSTR(rvb05,1,4) <> 'MISC'"
    PREPARE p001_ins_tlff01 FROM l_sql
    EXECUTE p001_ins_tlff01
    IF SQLCA.SQLCODE THEN 
        LET l_ret.success = 'N'
        LET l_ret.code = SQLCA.SQLCODE 
        LET l_ret.msg  = "rva_y() insert tlff_file error:",cl_getmsg(SQLCA.SQLCODE,g_lang)
        RETURN l_ret.*
    END IF 

    UPDATE rvb_file SET rvb33 = rvb07,
                        rvb31 = rvb07,  
                        rvb331 = rvb82,
                        rvb332 = nvl(rvb85,0),
                       #rvb39 = 'N',
                        rvb40 = rvb12,
                        rvb41 = 'OK'
     WHERE rvb01 = p_rva01
       AND rvb39 = 'N'
    IF SQLCA.SQLCODE THEN 
        LET l_ret.success = 'N'
        LET l_ret.code = SQLCA.SQLCODE 
        LET l_ret.msg  = "rva_y() update rvb_file error:",cl_getmsg(SQLCA.SQLCODE,g_lang)
        RETURN l_ret.*
    END IF 
    
    UPDATE pmn_file SET pmn50 = pmn50 + (SELECT rvb07 FROM rvb_file WHERE rvb04 = pmn01 AND rvb03 = pmn02 AND rvb01 = p_rva01)
     WHERE EXISTS(SELECT 1 FROM rvb_file WHERE rvb04 = pmn01 AND rvb03 = pmn02 AND rvb01 = p_rva01)
    IF SQLCA.SQLCODE THEN 
        LET l_ret.success = 'N'
        LET l_ret.code = SQLCA.SQLCODE 
        LET l_ret.msg  = "rva_y() update pmn_file error:",cl_getmsg(SQLCA.SQLCODE,g_lang)
        RETURN l_ret.*
    END IF 
    
    RETURN l_ret.*

END FUNCTION 


