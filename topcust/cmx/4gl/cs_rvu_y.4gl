# Prog. Version..: '5.00.01-07.05.10(00010)'     #
# Pattern name...: cs_rva_y.4gl
# Descriptions...: 入库单审核函数
# Date & Author..: 16/01/01  By  LGe
# Note           : 传入值:  rvu01,user
# ...............: 返回值:  Y-成功; N-失败
#                           code: 0 成功    其他为错误代码
#                           msg:  错误信息  成功


DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

FUNCTION cs_rvu_y(p_rvu01)
DEFINE p_rvu01          LIKE rvu_file.rvu01
DEFINE l_sql            STRING 
DEFINE l_ret            RECORD 
             success    LIKE type_file.chr1,
             code       LIKE type_file.chr10,
             msg        STRING
                        END RECORD
DEFINE l_rvu            RECORD LIKE rvu_file.*
DEFINE l_rvv            RECORD LIKE rvv_file.*
DEFINE l_ima91          LIKE ima_file.ima91
DEFINE l_ima908         LIKE ima_file.ima908
DEFINE l_ima44          LIKE ima_file.ima44
DEFINE l_ima25          LIKE ima_file.ima25
DEFINE l_ima86          LIKE ima_file.ima86
DEFINE l_ima44_fac      LIKE ima_file.ima44_fac
DEFINE l_ima86_fac      LIKE ima_file.ima86_fac
DEFINE l_ima871         LIKE ima_file.ima871
DEFINE l_avl_stk_mpsmrp LIKE type_file.num15_3
DEFINE l_unavl_stk      LIKE type_file.num15_3
DEFINE l_avl_stk        LIKE type_file.num15_3
DEFINE l_pmn07          LIKE pmn_file.pmn07
DEFINE l_pmn09          LIKE pmn_file.pmn09
DEFINE l_pmn44          LIKE pmn_file.pmn44
DEFINE l_pmn65          LIKE pmn_file.pmn65
DEFINE l_cost           LIKE oeb_file.oeb13
DEFINE l_cnt            LIKE type_file.num10
DEFINE l_pmm43          LIKE pmm_file.pmm43 
DEFINE l_gfe03          LIKE gfe_file.gfe03 
DEFINE l_img10          LIKE img_file.img10 
DEFINE l_img26          LIKE img_file.img26 
DEFINE l_img30          LIKE img_file.img30 
DEFINE l_img31          LIKE img_file.img31 
DEFINE p_rvvud08        LIKE rvv_file.rvvud08
DEFINE l_img30_update   LIKE img_file.img30 
DEFINE l_img31_update   LIKE img_file.img31 
DEFINE l_img23          LIKE img_file.img23 
DEFINE l_img24          LIKE img_file.img24 
DEFINE l_ss             LIKE type_file.num5 
DEFINE l_factor         LIKE ima_file.ima31_fac
DEFINE l_ima01          LIKE ima_file.ima01 
DEFINE p_rvv17          LIKE rvv_file.rvv17 
DEFINE l_rva00          LIKE rva_file.rva00

    INITIALIZE l_ret TO NULL 
    LET l_ret.success = 'Y'
    LET l_ret.code = '0'

    IF cl_null(p_rvu01) THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "无入库单单号！"
        RETURN l_ret.*
    END IF 
    
    INITIALIZE l_rvu TO NULL 
    SELECT * INTO l_rvu.* FROM rvu_file 
     WHERE rvu01 = p_rvu01
    IF SQLCA.SQLCODE THEN 
        LET l_ret.success = 'N'
        LET l_ret.code = SQLCA.SQLCODE 
        LET l_ret.msg = "cs_rvu_y() select rvu error:",cl_getmsg(SQLCA.SQLCODE,g_lang)
        RETURN l_ret.*
    END IF 

    INITIALIZE l_sql TO NULL
    LET l_sql = "SELECT * FROM rvu_file WHERE rvu01 = ? FOR UPDATE "
    LET l_sql = cl_forupd_sql(l_sql)
    DECLARE p001_y_rvu_cl CURSOR FROM l_sql
    OPEN p001_y_rvu_cl USING l_rvu.rvu01
    IF SQLCA.SQLCODE  THEN 
        CLOSE p001_y_rvu_cl
        LET l_ret.success = 'N'
        LET l_ret.code = SQLCA.SQLCODE 
        LET l_ret.msg = "lock rvu_file error:",cl_getmsg(SQLCA.SQLCODE,g_lang)
        RETURN l_ret.*
    END IF 
    LET g_time = TIME 
    UPDATE rvu_file SET rvuconf = 'Y',
                        rvu17 = '1',
                        rvuconu = g_user,
                        rvucond = g_today,
                        rvucont = g_time
      WHERE rvu01 = l_rvu.rvu01
    IF SQLCA.SQLCODE THEN 
        LET l_ret.success = 'N'
        LET l_ret.code = SQLCA.SQLCODE
        LET l_ret.msg = "cs_rvu_y() update rvu_file error:",cl_getmsg(SQLCA.SQLCODE,g_lang)
        CLOSE p001_y_rvu_cl
        RETURN l_ret.*
    ELSE 
        IF SQLCA.SQLERRD[3] = 0 THEN 
            LET l_ret.success = 'N'
            LET l_ret.code = 0
            LET l_ret.msg = "cs_rvu_y() update rvu_file rows = 0"
            CLOSE p001_y_rvu_cl
            RETURN l_ret.*
        END IF 
    END IF 

    DECLARE p001_y_rvv_cl CURSOR FOR 
        SELECT * FROM rvv_file WHERE rvv01 = l_rvu.rvu01
    
    INITIALIZE l_rvv TO NULL 
    LET l_ret.msg = ''
    FOREACH p001_y_rvv_cl INTO l_rvv.*
        IF SQLCA.SQLCODE THEN 
            EXIT FOREACH
        END IF 

        UPDATE rvb_file SET rvb30 = rvb30 + l_rvv.rvv17,
                            rvb09 = rvb09 + l_rvv.rvv17,
                            rvb31 = rvb31 - l_rvv.rvv17,
                            rvb18='30'
         WHERE rvb01 = l_rvu.rvu02 AND rvb02 = l_rvv.rvv05
        IF SQLCA.SQLCODE THEN 
            LET l_ret.msg = "cs_rvu_y() update rvb error:"
            EXIT FOREACH
        ELSE 
            IF SQLCA.SQLERRD[3] = 0 THEN 
                LET l_ret.success = 'Y'
                LET l_ret.code = 0
                LET l_ret.msg = "cs_rvu_y() update rvb rows = 0 !"
                EXIT FOREACH
            END IF 
        END IF 

        INITIALIZE l_rva00 TO NULL 
        SELECT rva00 INTO l_rva00 FROM rva_file 
         WHERE rva01 = l_rvu.rvu02

        IF l_rva00 <> '2' THEN 
            UPDATE pmn_file SET pmn53=pmn53+l_rvv.rvv17
             WHERE pmn01 = l_rvv.rvv36 
               AND pmn02 = l_rvv.rvv37
            IF SQLCA.SQLCODE THEN 
                LET l_ret.msg = "cs_rvu_y() update pmm error:"
                EXIT FOREACH
            ELSE 
                IF SQLCA.SQLERRD[3] = 0 THEN 
                    LET l_ret.success = 'Y'
                    LET l_ret.code = 0
                    LET l_ret.msg = "cs_rvu_y() update pmm rows = 0 !"
                    EXIT FOREACH
                END IF 

            END IF 
        END IF 

        IF l_rvv.rvv31[1,4] <> 'MISC' AND l_rvu.rvu08 <> 'SUB' THEN
            IF g_sma.sma12 = 'Y' THEN
                SELECT ima91,ima908,ima44,ima25,ima86,ima44_fac,ima86_fac,ima871
                  INTO l_ima91,l_ima908,l_ima44,l_ima25,l_ima86,l_ima44_fac,l_ima86_fac,l_ima871
                  FROM ima_file
                 WHERE ima01 = l_rvv.rvv31
                IF SQLCA.SQLCODE THEN 
                    LET l_ret.msg = "cs_rvu_y() sel ima error:"
                    EXIT FOREACH
                END IF 
                CALL s_getstock(l_rvv.rvv31,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk
                 
                IF l_rva00 <> '2' THEN 
                    SELECT pmn07,pmn09,pmn44,pmn65 
                      INTO l_pmn07,l_pmn09,l_pmn44,l_pmn65
                      FROM pmn_file
                     WHERE pmn01 = l_rvv.rvv36
                       AND pmn02 = l_rvv.rvv37
                ELSE 

                    SELECT rvb90,1,rvb10,'1' INTO l_pmn07,l_pmn09,l_pmn44,l_pmn65         -- 采购单位，换算因子，本币单价，代码性质
                      FROM rvb_file 
                     WHERE rvb01 = l_rvu.rvu02
                       AND rvb02 = l_rvv.rvv05
                END IF 
                IF SQLCA.SQLCODE THEN 
                    LET l_ret.msg = "cs_rvu_y() sel pmn error:"
                    EXIT FOREACH
                END IF 
                IF l_rvv.rvv17=0 THEN     #入庫數量
     		    LET l_cost=0
     		ELSE
                    IF cl_null(l_ima908) THEN   #计价单位
                        LET l_ima908 = l_ima44 
                    END IF
                    IF g_sma.sma116 MATCHES '[13]' THEN 
                        LET l_ima44 = l_ima908
                    END IF
                    CALL s_umfchk(l_rvv.rvv31,l_ima25,l_ima44)
                        RETURNING l_cnt,l_factor
     		    IF l_cnt THEN
     		      LET l_factor = 1
                    END IF
                    LET l_cost = ((l_ima91*((l_unavl_stk+l_avl_stk)*l_factor))+
                                 (l_pmn44*(l_rvv.rvv17*l_rvv.rvv35_fac*l_factor)))/
                                 (((l_unavl_stk+l_avl_stk)*l_factor)+
                                 (l_rvv.rvv17*l_rvv.rvv35_fac*l_factor))
                END IF 
                IF cl_null(l_cost) THEN
                    LET l_cost = 0
                END IF
                LET l_sql="SELECT ima01 FROM ima_file WHERE ima01= ? FOR UPDATE " 
                LET l_sql = cl_forupd_sql(l_sql)
                DECLARE rvv_ima_lock CURSOR FROM l_sql
                OPEN rvv_ima_lock USING l_rvv.rvv31
                IF SQLCA.sqlcode THEN
                    LET l_ret.msg = "lock ima_file error:"
                    CLOSE rvv_ima_lock 
                    EXIT FOREACH
                END IF 
                FETCH rvv_ima_lock INTO l_ima01
                IF SQLCA.sqlcode THEN
                    LET l_ret.msg = "lock ima_file error:"
                    CLOSE rvv_ima_lock 
                    EXIT FOREACH
                END IF 

                UPDATE ima_file SET ima91   = l_cost,
                                    imadate = g_today
                 WHERE ima01 = l_rvv.rvv31
                IF SQLCA.SQLCODE THEN 
                    LET l_ret.msg = "upd ima error:"
                    CLOSE rvv_ima_lock
                    EXIT FOREACH
                END IF 
                CLOSE rvv_ima_lock

                LET l_cost = l_cost / l_ima44_fac * l_ima86_fac
                IF cl_null(l_cost) THEN
                    LET l_cost = 0
                END IF 
                LET l_cnt = 0
                SELECT COUNT(*) INTO l_cnt FROM imb_file
                 WHERE imb01 = l_rvv.rvv31
                IF cl_null(l_cnt) THEN 
                    LET l_cnt = 0 
                END IF
                IF l_cnt = 0 THEN
                    CALL p001_insimb(l_rvv.rvv31,l_cost) RETURNING l_ret.*
                    IF l_ret.success = 'N' THEN 
                        EXIT FOREACH
                    END IF 
                ELSE
                    UPDATE imb_file SET imb118 = l_cost 
                     WHERE imb01 = l_rvv.rvv31
                    IF SQLCA.SQLCODE THEN 
                        LET l_ret.msg = "upd imb error:"
                        EXIT FOREACH 
                    END IF 
                END IF 
                IF NOT cl_null(l_rvv.rvv32) AND l_pmn65='1' THEN
                    IF cl_null(l_rvv.rvv33) THEN
                        LET l_rvv.rvv33 = ' '
                    END IF 
                    IF cl_null(l_rvv.rvv34) THEN
                        LET l_rvv.rvv34 = ' '
                    END IF 
                    LET l_sql = "SELECT img01,img02,img03,img04 FROM img_file ",
                                "  WHERE img01= ? ",
                                "    AND img02= ? ",
                                "    AND img03= ? ",
                                "    AND img04= ? FOR UPDATE "
                    LET l_sql = cl_forupd_sql(l_sql)
                    DECLARE rvv_img_lock_t1 CURSOR FROM l_sql
                    OPEN rvv_img_lock_t1 USING l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34
                    IF SQLCA.SQLCODE THEN
                        CLOSE rvv_img_lock_t1
                        LET l_ret.msg = "open rvv_img_lock_t1 error:"
                        EXIT FOREACH
                    END IF 
                    FETCH rvv_img_lock_t1 INTO l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34
                    IF SQLCA.SQLCODE THEN
                        CLOSE rvv_img_lock_t1
                        LET l_ret.msg = "fetch rvv_img_lock_t1 error:"
                        EXIT FOREACH
                    END IF 
                    CLOSE rvv_img_lock_t1
                    IF cl_null(l_rvv.rvv17) THEN
                        LET l_rvv.rvv17 = 0
                    END IF 
                    IF cl_null(l_rvv.rvv35_fac) THEN
                        LET l_rvv.rvv35_fac = 1
                    END IF 

                    IF g_azw.azw04 = '2' THEN
                        SELECT pmm43 INTO l_pmm43 FROM pmm_file WHERE pmm01 = l_rvv.rvv36
                        IF cl_null(l_pmm43) THEN
                            SELECT gec04 INTO l_pmm43 FROM gec_file,pmc_file
                             WHERE gec01 = pmc47 AND pmc01 = l_rvu.rvu04 AND gec011='1'
                        END IF 
                    ELSE
                        LET l_pmm43 = ' '
                    END IF 
                    SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01 =l_ima25
                    IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN
                        LET l_gfe03 = 0
                    END IF 
                    LET p_rvv17=l_rvv.rvv17*l_rvv.rvv35_fac
                    CALL cl_digcut(p_rvv17,l_gfe03) RETURNING p_rvv17
                   #LET p_rvvud08 = l_rvv.rvvud08*l_rvv.rvv35_fac
                   #CALL cl_digcut(p_rvvud08,l_gfe03) RETURNING p_rvvud08
                    CALL s_upimg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,+1,p_rvv17,
                                 l_rvu.rvu03,l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,
                                 l_rvv.rvv34,l_rvv.rvv01,l_rvv.rvv02,l_pmn07,l_rvv.rvv17,
                                 l_ima25,l_rvv.rvv35_fac,1,'','','','','','','')
                    LET l_ret.success = g_success 
                    IF l_ret.success = 'N' THEN 
                        EXIT FOREACH
                    END IF 

                    SELECT img10,img26,img30,img31
                      INTO l_img10,l_img26,l_img30,l_img31
                      FROM img_file
                     WHERE img01 = l_rvv.rvv31
                       AND img02 = l_rvv.rvv32
                       AND img03 = l_rvv.rvv33
                       AND img04 = l_rvv.rvv34
                    IF SQLCA.SQLCODE THEN 
                        LET l_ret.msg = "sel img error:"
                        EXIT FOREACH
                    END IF  

                    IF l_img10+l_rvv.rvv17*l_rvv.rvv35_fac = 0 OR
                       l_img10+l_rvv.rvv17*l_rvv.rvv35_fac IS NULL THEN
                        LET l_img30_update = 0 
                        LET l_img31_update = 0
                    ELSE
                        LET l_img30_update = ((l_img10*l_img30)+(l_rvv.rvv17*l_pmn44))
                                             /(l_img10+l_rvv.rvv17*l_rvv.rvv35_fac)
                        LET l_img31_update = (((l_img10*l_img30)+(l_rvv.rvv17*l_pmn44))
                                             /(l_img10+l_rvv.rvv17*l_rvv.rvv35_fac))*l_ima871
                    END IF 
                         
                    UPDATE img_file SET img30 = l_img30_update,
                                        img31 = l_img31_update
                     WHERE img01 = l_rvv.rvv31
                       AND img02 = l_rvv.rvv32
                       AND img03 = l_rvv.rvv33
                       AND img04 = l_rvv.rvv34
                    IF SQLCA.SQLCODE THEN 
                        LET l_ret.msg = "upd img error:"
                        EXIT FOREACH
                    END IF 
                END IF 
            
                LET l_ss=0
                SELECT img23,img24 INTO l_img23,l_img24 FROM img_file
                 WHERE img01 = l_rvv.rvv31
                   AND img02 = l_rvv.rvv32
                   AND img03 = l_rvv.rvv33
                   AND img04 = l_rvv.rvv34
                IF SQLCA.SQLCODE THEN 
                    SELECT ime05,ime06 INTO l_img23,l_img24 FROM ime_file
                     WHERE ime01 = l_rvv.rvv32 
                       AND ime02 = l_rvv.rvv33
                       AND imeacti = 'Y'
                    IF SQLCA.sqlcode THEN
                        SELECT imd11,imd12 INTO l_img23,l_img24 FROM imd_file
                         WHERE imd01 = l_rvv.rvv32
                    END IF 
                END IF 

                CALL s_udima(l_rvv.rvv31,l_img23,l_img24,l_rvv.rvv17*l_rvv.rvv35_fac,l_rvu.rvu03,1) 
                    RETURNING l_ss
                IF l_ss THEN
                    LET l_ret.success = 'N'
                    EXIT FOREACH
                END IF

            ELSE 
                CALL s_udima(l_rvv.rvv31,'Y','Y',l_rvv.rvv17,l_rvu.rvu03,1) RETURNING l_ss
                IF l_ss THEN
                    LET l_ret.success = 'N'
                    EXIT FOREACH
                END IF
            END IF 
            CALL p001_rvv_log(l_rvv.*,l_rvu.rvu00,l_rvu.rvu08,l_ima25,'1')
            LET l_ret.success = g_success 
            IF l_ret.success = 'N' THEN 
                EXIT FOREACH
            END IF 
            IF g_sma.sma115 = 'Y' THEN
                CALL p001_update_imgg(+1,l_rvv.*,l_rvu.rvu03) 
                CALL p001_update_tlff(l_rvv.*,l_rvu.rvu00,l_rvu.rvu08)
                LET l_ret.success = g_success 
                IF l_ret.success = 'N' THEN 
                    EXIT FOREACH
                END IF 
            END IF 
        END IF 
    END FOREACH
    IF SQLCA.SQLCODE THEN 
        LET l_ret.success = 'N'
        LET l_ret.code = SQLCA.SQLCODE 
        IF cl_null(l_ret.msg) THEN 
            LET l_ret.msg = "cs_rvu_y() foreach rvv error:",cl_getmsg(SQLCA.SQLCODE,g_lang) 
        ELSE 
            LET l_ret.msg = l_ret.msg,cl_getmsg(SQLCA.SQLCODE,g_lang) 
        END IF 
    END IF 

    CLOSE p001_y_rvu_cl
    RETURN l_ret.*
END FUNCTION 

FUNCTION p001_imgg_lock_cl()
DEFINE l_sql            STRING
 LET l_sql =
     "SELECT imgg01,imgg02,imgg03,imgg04,imgg09 FROM imgg_file ",
     "   WHERE imgg01= ? AND imgg02= ? AND imgg03= ? AND imgg04= ? ",
     "   AND imgg09= ? FOR UPDATE "

 LET l_sql = cl_forupd_sql(l_sql)
 DECLARE imgg_lock CURSOR FROM l_sql

END FUNCTION

FUNCTION p001_insimb(l_rvv31,l_cost)
DEFINE l_imb            RECORD LIKE imb_file.*
DEFINE l_rvv31          LIKE rvv_file.rvv31
DEFINE l_cost           LIKE imb_file.imb118
DEFINE l_ret            RECORD
              success   LIKE type_file.chr1,
              code      LIKE type_file.chr10,
              msg       STRING
                        END RECORD

    INITIALIZE l_ret TO NULL
    LET l_ret.success = 'Y'
    LET l_ret.code = '0'

    INITIALIZE l_imb.* LIKE imb_file.*
    LET l_imb.imb01  =l_rvv31
    LET l_imb.imb02  ='0'      LET l_imb.imb111=0
    LET l_imb.imb112 =0        LET l_imb.imb1131=0
    LET l_imb.imb1132=0        LET l_imb.imb114=0
    LET l_imb.imb115 =0        LET l_imb.imb116=0
    LET l_imb.imb1151=0
    LET l_imb.imb1171=0        LET l_imb.imb1172=0
    LET l_imb.imb118 =l_cost   LET l_imb.imb119=0
    LET l_imb.imb129 =0        LET l_imb.imb121=0
    LET l_imb.imb122 =0        LET l_imb.imb1231=0
    LET l_imb.imb1232=0        LET l_imb.imb124=0
    LET l_imb.imb125 =0        LET l_imb.imb126=0
    LET l_imb.imb1251=0
    LET l_imb.imb1271=0        LET l_imb.imb1272=0
    LET l_imb.imb120 =0        LET l_imb.imb130=0
    LET l_imb.imb211 =0        LET l_imb.imb212=0
    LET l_imb.imb2131=0        LET l_imb.imb2132=0
    LET l_imb.imb214 =0        LET l_imb.imb215=0
    LET l_imb.imb2151=0  
    LET l_imb.imb216 =0        LET l_imb.imb2171=0
    LET l_imb.imb2172=0        LET l_imb.imb219=0
    LET l_imb.imb218 =0        LET l_imb.imb221=0
    LET l_imb.imb222 =0        LET l_imb.imb2231=0
    LET l_imb.imb2232=0        LET l_imb.imb224=0
    LET l_imb.imb225 =0        LET l_imb.imb226=0
    LET l_imb.imb2251=0
    LET l_imb.imb2271=0        LET l_imb.imb2272=0
    LET l_imb.imb229 =0        LET l_imb.imb311=0
    LET l_imb.imb220 =0        LET l_imb.imb230=0
    LET l_imb.imb312 =0        LET l_imb.imb3131=0
    LET l_imb.imb3132=0        LET l_imb.imb314=0
    LET l_imb.imb315 =0        LET l_imb.imb316=0
    LET l_imb.imb3151=0
    LET l_imb.imb3171=0        LET l_imb.imb3172=0
    LET l_imb.imb319 =0        LET l_imb.imb318=0
    LET l_imb.imb321 =0        LET l_imb.imb322=0
    LET l_imb.imb3231=0        LET l_imb.imb3232=0
    LET l_imb.imb324 =0        LET l_imb.imb325=0
    LET l_imb.imb3251=0
    LET l_imb.imb326 =0        LET l_imb.imb3271=0
    LET l_imb.imb3272=0        LET l_imb.imb329=0
    LET l_imb.imb320 =0        LET l_imb.imb330=0
    LET l_imb.imbacti='Y'                   #有效的資料
    LET l_imb.imbuser= g_user
    LET l_imb.imbgrup= g_grup               #使用者所屬群
    LET l_imb.imbdate= g_today
    INSERT INTO imb_file VALUES(l_imb.*)     
    IF SQLCA.sqlcode  THEN
        LET l_ret.success ='N'
        LET l_ret.code = SQLCA.SQLCODE
        LET l_ret.msg = "ins imb error:",cl_getmsg(SQLCA.SQLCODE,g_lang)
    END IF

    RETURN l_ret.*
END FUNCTION


FUNCTION p001_rvv_log(l_rvv,p_rvu00,p_rvu08,p_ima25,p_rva00)
  DEFINE l_flag      LIKE type_file.num5,    #No.FUN-680136 SMALLINT
         l_ima25_fac LIKE tlf_file.tlf60,
         l_img09     LIKE img_file.img09,       #庫存單位
         l_img10     LIKE img_file.img10,       #庫存數量
         l_img26     LIKE img_file.img26,
         l_pmn65     LIKE pmn_file.pmn65
  DEFINE l_rvv       RECORD LIKE rvv_file.*
  DEFINE p_rvu00     LIKE rvu_file.rvu00
  DEFINE p_rvu08     LIKE rvu_file.rvu08
  DEFINE p_ima25     LIKE ima_file.ima25
  DEFINE l_ima39     LIKE ima_file.ima39
  DEFINE l_ima25     LIKE ima_file.ima25
  DEFINE p_rva00     LIKE rva_file.rva00

  LET l_img09 = ''   #TQC-A60044
  LET l_img10 = ''   #TQC-A60044
  LET l_img26 = ''   #TQC-A60044

  IF l_rvv.rvv31[1,4]!='MISC' AND p_rvu00!='2' 
    AND NOT (p_rvu00='3' AND l_rvv.rvv17=0) THEN   #TQC-A60044
    SELECT img09,img10,img26 INTO l_img09,l_img10,l_img26
      FROM img_file WHERE img01 = l_rvv.rvv31 AND img02 = l_rvv.rvv32
                      AND img03 = l_rvv.rvv33 AND img04 = l_rvv.rvv34
    IF SQLCA.sqlcode THEN
      LET g_success = 'N' RETURN
    END IF
  END IF
  SELECT ima39 INTO l_ima39 FROM ima_file WHERE ima01=l_rvv.rvv31

  INITIALIZE g_tlf.* TO NULL

  LET g_tlf.tlf01  = l_rvv.rvv31             #異動料件編號
  LET g_tlf.tlf020 = g_plant                 #工廠別

  IF p_rvu00 = '1' OR p_rvu00='2' THEN      #入庫
    IF p_rvu08='SUB' THEN
       LET g_tlf.tlf02  = 25                #來源狀況
    ELSE
       LET g_tlf.tlf02  = 20                #來源狀況
    END IF
    LET g_tlf.tlf021 = ' '                  #倉庫別
    LET g_tlf.tlf022 = ' '                  #儲位別
    LET g_tlf.tlf023 = ' '                  #批號
    LET g_tlf.tlf024 = ' '                  #異動後庫存數量
    LET g_tlf.tlf025 = ' '                  #庫存單位(ima_file or img_file)
  ELSE
    LET g_tlf.tlf02 = 50
    LET g_tlf.tlf021 = l_rvv.rvv32          #倉庫別
    LET g_tlf.tlf022 = l_rvv.rvv33          #儲位別
    LET g_tlf.tlf023 = l_rvv.rvv34          #批號
    LET g_tlf.tlf024 = l_img10              #異動後庫存數量
    LET g_tlf.tlf025 = p_ima25
  END IF
  IF p_rvu00='1' THEN
    LET g_tlf.tlf026 = l_rvv.rvv04          #單據號碼(驗收單號)
    LET g_tlf.tlf027 = l_rvv.rvv05          #單據項次(驗收序號)
  ELSE
    LET g_tlf.tlf026 = l_rvv.rvv01
    LET g_tlf.tlf027 = l_rvv.rvv02
  END IF
  CASE
    WHEN p_rvu00='1'
         LET g_tlf.tlf03=50                   #資料目的為倉庫
    WHEN p_rvu00='2'  OR p_rvu00='3'
         LET g_tlf.tlf03=31
  END CASE
  IF p_rvu00='1' OR p_rvu00='2' THEN #入庫
    LET g_tlf.tlf031=l_rvv.rvv32         #倉庫別
    LET g_tlf.tlf032=l_rvv.rvv33         #儲位別
    LET g_tlf.tlf033=l_rvv.rvv34         #批號
  ELSE
    LET g_tlf.tlf031=' '                 #倉庫別
    LET g_tlf.tlf032=' '                 #儲位別
    LET g_tlf.tlf033=' '                 #批號
  END IF
  LET g_tlf.tlf034=l_img10                #異動後存數量
  IF p_rvu00='1' THEN
     LET g_tlf.tlf035=p_ima25             #庫存單位(ima_file or img_file)
     LET g_tlf.tlf036=l_rvv.rvv01         #參考號碼(入庫單號)
     LET g_tlf.tlf037=l_rvv.rvv02
  ELSE
     LET g_tlf.tlf035=' '                 #庫存單位(ima_file or img_file)
     LET g_tlf.tlf036=l_rvv.rvv04         #參考號碼(驗收單號)
     LET g_tlf.tlf037=l_rvv.rvv05
  END IF
#--->異動數量
  LET g_tlf.tlf04=' '                  #工作站
  LET g_tlf.tlf05=' '                  #作業序號
  LET g_tlf.tlf06=l_rvv.rvv09          #日期
  LET g_tlf.tlf07=g_today              #異動資料產生日期
  LET g_tlf.tlf08=TIME                 #異動資料產生時:分:秒
  LET g_tlf.tlf09=g_user               #產生人
 #LET g_tlf.tlf10=l_rvv.rvvud08          #收料數量 #modify by junchuan 20150314 l_rvv.rvv17->l_rvv.rvvud08
  LET g_tlf.tlf10=l_rvv.rvv17          #收料數量 #modify by junchuan 20150314 l_rvv.rvv17->l_rvv.rvvud08
  LET g_tlf.tlf11=l_rvv.rvv35          #收料單位
  LET g_tlf.tlf12=l_rvv.rvv35_fac      #收料/庫存轉換率
  CASE
    WHEN p_rvu00='1' AND p_rvu08!='SUB'
        LET g_tlf.tlf13='apmt150'            #異動命令代號
    WHEN p_rvu00='1' AND p_rvu08='SUB'
        SELECT pmn65 INTO l_pmn65 FROM pmn_file
         WHERE pmn01=l_rvv.rvv36 AND pmn02=l_rvv.rvv37
        IF l_pmn65='2' THEN
          LET g_tlf.tlf13='apmt230'        #異動命令代號
        ELSE
          LET g_tlf.tlf13='asft6201'        #異動命令代號
        END IF
    WHEN p_rvu00='2'
        LET g_tlf.tlf13='apmt102'            #異動命令代號
    WHEN p_rvu00='3' AND p_rvu08 != 'SUB' #FUN-D20078 add
        LET g_tlf.tlf13='apmt1072'           #異動命令代號
    WHEN p_rvu00='3' AND p_rvu08 = 'SUB'
        SELECT pmn65 INTO l_pmn65 FROM pmn_file
         WHERE pmn01=l_rvv.rvv36 AND pmn02=l_rvv.rvv37
        IF l_pmn65='2' THEN               #委外非代買
          LET g_tlf.tlf13='apmt230'        #異動命令代號
        ELSE                              #委外代買
          LET g_tlf.tlf13='asft6201'        #異動命令代號
        END IF
  END CASE

  LET g_tlf.tlf14= l_rvv.rvv26
  IF p_rvu00='1' THEN
    IF g_sma.sma12='N' THEN             #是否為使用多倉儲管理
      LET g_tlf.tlf15=l_ima39          #料件會計科目
    ELSE
      LET g_tlf.tlf15=l_img26          #倉儲會計科目
    END IF
  END IF
  LET g_tlf.tlf16=' '                  #貸方
  LET g_tlf.tlf17=' '                  #非庫存性料件編號
  CALL s_imaQOH(l_rvv.rvv31) RETURNING g_tlf.tlf18           #異動後總庫存量
  LET g_tlf.tlf19= l_rvv.rvv06         #異動廠商/客戶編號
  LET g_tlf.tlf20= l_rvv.rvv34         #專案號碼

  SELECT ima25       #庫存單位
    INTO l_ima25
    FROM ima_file WHERE ima01=l_rvv.rvv31 AND imaacti='Y'
  CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv35,l_ima25)
       RETURNING l_flag,l_ima25_fac
  IF l_flag THEN
    LET g_success ='N'
    LET l_ima25_fac = 1.0
  END IF
  LET g_tlf.tlf60=l_ima25_fac

  IF p_rvu08='SUB' THEN
    SELECT pmn65 INTO l_pmn65 FROM pmn_file
     WHERE pmn01=l_rvv.rvv36 AND pmn02=l_rvv.rvv37
    IF l_pmn65='1' THEN
       LET g_tlf.tlf62= l_rvv.rvv18
       LET g_tlf.tlf63= ' '
    ELSE
       LET g_tlf.tlf62= ' '
       LET g_tlf.tlf63= ' '
       IF p_rvu00 = '1' OR p_rvu00 = '2' THEN  #入庫
         LET g_tlf.tlf02 = 18
       END IF
    END IF
  ELSE
    LET g_tlf.tlf62= l_rvv.rvv36
    LET g_tlf.tlf63= l_rvv.rvv37
  END IF
  LET g_tlf.tlf64 = l_rvv.rvv41 
  LET g_tlf.tlf930 = l_rvv.rvv930  
  IF p_rva00 = '1' THEN
    SELECT pmn122,pmn96,pmn97,pmn98
      INTO g_tlf.tlf20,g_tlf.tlf41,g_tlf.tlf42,g_tlf.tlf43
      FROM pmn_file
     WHERE pmn01 = l_rvv.rvv36
       AND pmn02 = l_rvv.rvv37
    IF SQLCA.sqlcode THEN
      LET g_tlf.tlf20 = ' '
      LET g_tlf.tlf41 = ' '
      LET g_tlf.tlf42 = ' '
      LET g_tlf.tlf43 = ' '
    END IF
  ELSE
    LET g_tlf.tlf20 = ' '
    LET g_tlf.tlf41 = ' '
    LET g_tlf.tlf42 = ' '
    LET g_tlf.tlf43 = ' '
  END IF
  IF g_prog = 'apmt732' OR g_prog = 'apmt732_icd' THEN
    LET g_tlf.tlf10 = 0
  END IF
  CALL s_tlf(1,0)
END FUNCTION


FUNCTION p001_update_imgg(p_type,l_rvv,p_rvu03)
  DEFINE l_ima25   LIKE ima_file.ima25,
         p_type    LIKE type_file.num5    #No.FUN-680136 SMALLINT
  DEFINE l_ima906  LIKE ima_file.ima906
  DEFINE l_ima907  LIKE ima_file.ima907
  DEFINE l_rvv     RECORD LIKE rvv_file.*
  DEFINE p_rvu03   LIKE rvu_file.rvu03

  IF g_sma.sma115 = 'N' THEN RETURN END IF

  SELECT ima906,ima907,ima25 INTO l_ima906,l_ima907,l_ima25 FROM ima_file
   WHERE ima01 = l_rvv.rvv31
  IF SQLCA.sqlcode THEN
    LET g_success='N' RETURN
  END IF

  IF l_ima906 = '1' OR cl_null(l_ima906) THEN RETURN END IF

  IF l_ima906 = '2' THEN  #子母單位
    IF NOT cl_null(l_rvv.rvv83) THEN
      CALL p001_rvv_upd_imgg('1',l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvv.rvv83,l_rvv.rvv84,l_rvv.rvv85,p_type,'2',p_rvu03)
      IF g_success='N' THEN RETURN END IF
    END IF
    IF NOT cl_null(l_rvv.rvv80) THEN
      CALL p001_rvv_upd_imgg('1',l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvv.rvv80,l_rvv.rvv81,l_rvv.rvv82,p_type,'1',p_rvu03)
      IF g_success='N' THEN RETURN END IF
    END IF
  END IF
  IF l_ima906 = '3' THEN  #參考單位
    IF NOT cl_null(l_rvv.rvv83) THEN
      CALL p001_rvv_upd_imgg('2',l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvv.rvv83,l_rvv.rvv84,l_rvv.rvv85,p_type,'2',p_rvu03)
      IF g_success='N' THEN RETURN END IF
    END IF
  END IF
END FUNCTION

FUNCTION p001_rvv_upd_imgg(p_imgg00,p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_imgg211,p_imgg10,p_type,p_no,p_rvu03)
  DEFINE p_imgg00   LIKE imgg_file.imgg00,
         p_imgg01   LIKE imgg_file.imgg01,
         p_imgg02   LIKE imgg_file.imgg02,
         p_imgg03   LIKE imgg_file.imgg03,
         p_imgg04   LIKE imgg_file.imgg04,
         p_imgg09   LIKE imgg_file.imgg09,
         p_imgg211  LIKE imgg_file.imgg211,
         l_ima25    LIKE ima_file.ima25,
         l_imgg21   LIKE imgg_file.imgg21,
         p_imgg10   LIKE imgg_file.imgg10,
         p_no       LIKE type_file.chr1,  
         p_type     LIKE type_file.num10 
  DEFINE l_ima906   LIKE ima_file.ima906
  DEFINE l_ima907   LIKE ima_file.ima907
  DEFINE p_rvu03    LIKE rvu_file.rvu03
  DEFINE l_cnt      LIKE type_file.num5
  DEFINE g_forupd_sql  STRING

  CALL p001_imgg_lock_cl()
  OPEN imgg_lock USING p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
  IF STATUS THEN
     LET g_success='N'
     CLOSE imgg_lock
     RETURN
  END IF
  FETCH imgg_lock INTO p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
  IF STATUS THEN
     LET g_success='N'
     CLOSE imgg_lock
     RETURN
  END IF

  SELECT ima25,ima906,ima907 INTO l_ima25,l_ima906,l_ima907
    FROM ima_file WHERE ima01=p_imgg01
  IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
     LET g_success = 'N' RETURN
  END IF

  CALL s_umfchk(p_imgg01,p_imgg09,l_ima25)
        RETURNING l_cnt,l_imgg21
  IF l_cnt = 1 AND NOT (l_ima906 = '3' AND p_no='2') THEN
     LET g_success = 'N' RETURN
  END IF
  IF g_prog = 'apmt732' OR g_prog = 'apmt732_icd' THEN
     LET p_imgg10 = 0 
  END IF
  CALL s_upimgg(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_type,p_imgg10,p_rvu03, 
        p_imgg01,p_imgg02,p_imgg03,p_imgg04,'','','','',p_imgg09,'',l_imgg21,'','','','','','','',p_imgg211)
  IF g_success='N' THEN RETURN END IF

END FUNCTION

FUNCTION p001_update_tlff(l_rvv,p_rvu00,p_rvu08)
  DEFINE l_ima25   LIKE ima_file.ima25,
         l_ima906  LIKE ima_file.ima906,
         l_ima907  LIKE ima_file.ima907
  DEFINE l_rvv     RECORD LIKE rvv_file.*
  DEFINE p_rvu00   LIKE rvu_file.rvu00
  DEFINE p_rvu08   LIKE rvu_file.rvu08
  DEFINE l_rvv83   LIKE rvv_file.rvv83
  DEFINE l_rvv84   LIKE rvv_file.rvv84
  DEFINE l_rvv85   LIKE rvv_file.rvv85

  IF g_sma.sma115 = 'N' THEN RETURN END IF

  SELECT ima906,ima907,ima25 INTO l_ima906,l_ima907,l_ima25 FROM ima_file
   WHERE ima01 = l_rvv.rvv31
  IF SQLCA.sqlcode THEN
    IF l_rvv.rvv31 MATCHES 'MISC*' THEN
      RETURN
    ELSE
      LET g_success='N' RETURN
    END IF
  END IF

  IF l_ima906 = '1' OR cl_null(l_ima906) THEN RETURN END IF

  IF l_ima906 = '2' THEN  #子母單位
    IF NOT cl_null(l_rvv.rvv83) THEN
      IF NOT cl_null(l_rvv.rvv85) THEN
        LET l_rvv83=l_rvv.rvv83 LET l_rvv84=l_rvv.rvv84 LET l_rvv85=l_rvv.rvv85
        CALL p001_rvv_tlff('2',l_rvv83,l_rvv84,l_rvv85,l_rvv.*,p_rvu00,p_rvu08,l_ima25,l_ima906)
        IF g_success='N' THEN RETURN END IF
      END IF
    END IF
    IF NOT cl_null(l_rvv.rvv80) THEN
      IF NOT cl_null(l_rvv.rvv82) THEN   
        LET l_rvv83=l_rvv.rvv80 LET l_rvv84=l_rvv.rvv81 LET l_rvv85=l_rvv.rvv82
        CALL p001_rvv_tlff('1',l_rvv83,l_rvv84,l_rvv85,l_rvv.*,p_rvu00,p_rvu08,l_ima25,l_ima906)
        IF g_success='N' THEN RETURN END IF
      END IF
    END IF
  END IF
  IF l_ima906 = '3' THEN  #參考單位
    IF NOT cl_null(l_rvv.rvv83) THEN
      IF NOT cl_null(l_rvv.rvv85) THEN
        LET l_rvv83=l_rvv.rvv83 LET l_rvv84=l_rvv.rvv84 LET l_rvv85=l_rvv.rvv85
        CALL p001_rvv_tlff('2',l_rvv83,l_rvv84,l_rvv85,l_rvv.*,p_rvu00,p_rvu08,l_ima25,l_ima906)
        IF g_success='N' THEN RETURN END IF
      END IF
    END IF
  END IF

END FUNCTION

FUNCTION p001_rvv_tlff(p_flag,p_unit,p_fac,p_qty,l_rvv,p_rvu00,p_rvu08,p_ima25,p_ima906)
  DEFINE p_unit       LIKE imgg_file.imgg09,
         p_flag       LIKE type_file.chr1,    #No.FUN-680136 CHAR(1)
         p_fac        LIKE imgg_file.imgg21,
         p_qty        LIKE imgg_file.imgg10,
         l_flag       LIKE type_file.num5,    #No.FUN-680136 SMALLINT
         l_ima25_fac  LIKE tlff_file.tlff60,
         l_imgg10     LIKE imgg_file.imgg10,       #庫存數量
         l_imgg26     LIKE imgg_file.imgg26,
         l_pmn65      LIKE pmn_file.pmn65
  DEFINE l_rvv        RECORD LIKE rvv_file.*
  DEFINE p_rvu00      LIKE rvu_file.rvu00
  DEFINE p_rvu08      LIKE rvu_file.rvu08
  DEFINE p_ima25      LIKE ima_file.ima25
  DEFINE p_ima906     LIKE ima_file.ima906
  DEFINE l_ima39      LIKE ima_file.ima39
  DEFINE l_ima906     LIKE ima_file.ima906
  DEFINE l_ima907     LIKE ima_file.ima907
  DEFINE l_ima25      LIKE ima_file.ima25

  IF l_rvv.rvv31[1,4]!='MISC' AND p_rvu00!='2'       #MOD-CC0062 add
    AND NOT (p_rvu00='3' AND l_rvv.rvv17=0) THEN    #MOD-CC0062 add
    SELECT imgg10,imgg26 INTO l_imgg10,l_imgg26
      FROM imgg_file WHERE imgg01 = l_rvv.rvv31 AND imgg02 = l_rvv.rvv32
                       AND imgg03 = l_rvv.rvv33 AND imgg04 = l_rvv.rvv34
                       AND imgg09 = p_unit
    IF SQLCA.sqlcode AND NOT (p_ima906='3' AND p_flag = '1') THEN
      LET g_success = 'N' RETURN
    END IF
  END IF

  SELECT ima39 INTO l_ima39 FROM ima_file WHERE ima01=l_rvv.rvv31

  INITIALIZE g_tlff.* TO NULL

  LET g_tlff.tlff01  = l_rvv.rvv31             #異動料件編號
  LET g_tlff.tlff020 = g_plant                 #工廠別

  IF p_rvu00 = '1' OR p_rvu00='2' THEN      #入庫
    IF p_rvu08='SUB' THEN
      LET g_tlff.tlff02  = 25                #來源狀況
    ELSE
      LET g_tlff.tlff02  = 20                #來源狀況
    END IF
    LET g_tlff.tlff021 = ' '                  #倉庫別
    LET g_tlff.tlff022 = ' '                  #儲位別
    LET g_tlff.tlff023 = ' '                  #批號
    LET g_tlff.tlff024 = ' '                  #異動後庫存數量
    LET g_tlff.tlff025 = ' '                  #庫存單位(ima_file or imgg_file)
  ELSE
    LET g_tlff.tlff02 = 50
    LET g_tlff.tlff021 = l_rvv.rvv32          #倉庫別
    LET g_tlff.tlff022 = l_rvv.rvv33          #儲位別
    LET g_tlff.tlff023 = l_rvv.rvv34          #批號
    LET g_tlff.tlff024 = l_imgg10             #異動後庫存數量
    LET g_tlff.tlff025 = p_ima25
  END IF
  IF p_rvu00='1' THEN
    LET g_tlff.tlff026 = l_rvv.rvv04          #單據號碼(驗收單號)
    LET g_tlff.tlff027 = l_rvv.rvv05          #單據項次(驗收序號)
  ELSE
    LET g_tlff.tlff026 = l_rvv.rvv01
    LET g_tlff.tlff027 = l_rvv.rvv02
  END IF
  CASE
    WHEN p_rvu00='1'
         LET g_tlff.tlff03=50                   #資料目的為倉庫
    WHEN p_rvu00='2'  OR p_rvu00='3'
         LET g_tlff.tlff03=31
  END CASE
  IF p_rvu00='1' OR p_rvu00='2' THEN #入庫
    LET g_tlff.tlff031=l_rvv.rvv32         #倉庫別
    LET g_tlff.tlff032=l_rvv.rvv33         #儲位別
    LET g_tlff.tlff033=l_rvv.rvv34         #批號
  ELSE
    LET g_tlff.tlff031=' '                 #倉庫別
    LET g_tlff.tlff032=' '                 #儲位別
    LET g_tlff.tlff033=' '                 #批號
  END IF
  LET g_tlff.tlff034=l_imgg10                #異動後存數量
  IF p_rvu00='1' THEN
    LET g_tlff.tlff035=p_ima25             #庫存單位(ima_file or imgg_file)
    LET g_tlff.tlff036=l_rvv.rvv01         #參考號碼(入庫單號)
    LET g_tlff.tlff037=l_rvv.rvv02
  ELSE
    LET g_tlff.tlff035=' '                 #庫存單位(ima_file or imgg_file)
    LET g_tlff.tlff036=l_rvv.rvv04         #參考號碼(驗收單號)
    LET g_tlff.tlff037=l_rvv.rvv05
  END IF
#--->異動數量
  LET g_tlff.tlff04=' '                  #工作站
  LET g_tlff.tlff05=' '                  #作業序號
  LET g_tlff.tlff06=l_rvv.rvv09          #日期
  LET g_tlff.tlff07=g_today              #異動資料產生日期
  LET g_tlff.tlff08=TIME                 #異動資料產生時:分:秒
  LET g_tlff.tlff09=g_user               #產生人
  LET g_tlff.tlff10=p_qty                #收料數量
  LET g_tlff.tlff11=p_unit               #收料單位
  LET g_tlff.tlff12=p_fac                #收料/庫存轉換率
  CASE
    WHEN p_rvu00='1' AND p_rvu08!='SUB'
        LET g_tlff.tlff13='apmt150'            #異動命令代號
    WHEN p_rvu00='1' AND p_rvu08='SUB'
        SELECT pmn65 INTO l_pmn65 FROM pmn_file
         WHERE pmn01=l_rvv.rvv36 AND pmn02=l_rvv.rvv37
        IF l_pmn65='2' THEN
           LET g_tlff.tlff13='apmt230'        #異動命令代號
        ELSE
           LET g_tlff.tlff13='asft6201'        #異動命令代號
        END IF
    WHEN p_rvu00='2'
        LET g_tlff.tlff13='apmt102'            #異動命令代號
    WHEN p_rvu00='3' AND p_rvu08 != 'SUB' 
        LET g_tlff.tlff13='apmt1072'           #異動命令代號
    WHEN p_rvu00='3' AND p_rvu08 = 'SUB'
         SELECT pmn65 INTO l_pmn65 FROM pmn_file
          WHERE pmn01=l_rvv.rvv36 AND pmn02=l_rvv.rvv37
         IF l_pmn65='2' THEN                
            LET g_tlff.tlff13='apmt230'        #異動命令代號
         ELSE                              
            LET g_tlff.tlff13='asft6201'        #異動命令代號
         END IF
  END CASE
  LET g_tlff.tlff14= l_rvv.rvv26

  IF p_rvu00='1' THEN
    IF g_sma.sma12='N' THEN               #是否為使用多倉儲管理
      LET g_tlff.tlff15=l_ima39          #料件會計科目
    ELSE
      LET g_tlff.tlff15=l_imgg26          #倉儲會計科目
    END IF
  END IF
  LET g_tlff.tlff16=' '                  #貸方
  LET g_tlff.tlff17=' '                  #非庫存性料件編號
  CALL s_imaQOH(l_rvv.rvv31) RETURNING g_tlff.tlff18           #異動後總庫存量
  LET g_tlff.tlff19= l_rvv.rvv06         #異動廠商/客戶編號
  LET g_tlff.tlff20= l_rvv.rvv34         #專案號碼

  LET l_ima906=NULL
  LET l_ima907=NULL
  SELECT ima25,ima906,ima907       #庫存單位
    INTO l_ima25,l_ima906,l_ima907
    FROM ima_file WHERE ima01=l_rvv.rvv31 AND imaacti='Y'
  CALL s_umfchk(l_rvv.rvv31,p_unit,l_ima25)
       RETURNING l_flag,l_ima25_fac
  IF l_flag AND NOT (l_ima906='3' AND p_flag='2') THEN
     LET g_success ='N'
     LET l_ima25_fac = 1.0
  END IF
  LET g_tlff.tlff60=l_ima25_fac
#--------------------------------

  IF p_rvu08='SUB' THEN
    SELECT pmn65 INTO l_pmn65 FROM pmn_file
     WHERE pmn01=l_rvv.rvv36 AND pmn02=l_rvv.rvv37
    IF l_pmn65='1' THEN
       LET g_tlff.tlff62= l_rvv.rvv18
       LET g_tlff.tlff63= ' '
    ELSE
       LET g_tlff.tlff62= ' '
       LET g_tlff.tlff63= ' '
       IF p_rvu00 = '1' OR p_rvu00 = '2' THEN  #入庫
          LET g_tlff.tlff02 = 18
       END IF
    END IF
  ELSE
    LET g_tlff.tlff62= l_rvv.rvv36
    LET g_tlff.tlff63= l_rvv.rvv37
  END IF
  LET g_tlff.tlff64 = l_rvv.rvv41 
  LET g_tlff.tlff930= l_rvv.rvv930   
  IF g_prog = 'apmt732' OR g_prog = 'apmt732_icd' THEN
    LET g_tlff.tlff10 = 0
  END IF
  IF cl_null(l_rvv.rvv85) OR l_rvv.rvv85 = 0 THEN
    CALL s_tlff(p_flag,NULL)
  ELSE
    CALL s_tlff(p_flag,l_rvv.rvv83)
  END IF
END FUNCTION

